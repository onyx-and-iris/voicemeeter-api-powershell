<#
.SYNOPSIS
    Synchronizes OBS Studio scene changes with Voicemeeter audio settings.

.DESCRIPTION
    This script monitors OBS Studio for scene changes via WebSocket connection and 
    automatically adjusts Voicemeeter audio settings based on the active scene.

.PARAMETER ConfigPath
    Path to the configuration file. Defaults to 'config.psd1' in the script directory.

.PARAMETER VoicemeeterKind
    Type of Voicemeeter to connect to. Defaults to 'basic'.

.EXAMPLE
    .\Vm-Obs-Sync.ps1
    
.EXAMPLE
    .\Vm-Obs-Sync.ps1 -ConfigPath "C:\myconfig.psd1" -VoicemeeterKind "banana"
#>

[CmdletBinding()]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'config.psd1'),
    [ValidateSet('basic', 'banana', 'potato')]
    [string]$VoicemeeterKind = 'basic'
)

#Requires -Modules obs-powershell

# Import required modules
try {
    Import-Module ..\..\lib\Voicemeeter.psm1
    Import-Module obs-powershell
}
catch {
    Write-Error "Failed to import required modules: $($_.Exception.Message)"
    exit 1
}

# Script-level variables
$script:vmr = $null
$script:obsJob = $null
$script:shouldExit = $false

#region Helper Functions

function Write-Log {
    <#
    .SYNOPSIS
        Writes timestamped log messages to the console.
    #>
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Message,
        [ValidateSet('Info', 'Warning', 'Error')]
        [string]$Level = 'Info'
    )
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logMessage = "[$timestamp] [$Level] $Message"
    
    switch ($Level) {
        'Info' { Write-Information $logMessage -InformationAction Continue }
        'Warning' { Write-Warning $logMessage }
        'Error' { Write-Error $logMessage }
    }
}

function Get-ConnectionConfig {
    <#
    .SYNOPSIS
        Loads OBS connection configuration from file.
    #>
    param([string]$Path = $ConfigPath)
    
    try {
        if (-not (Test-Path $Path)) {
            throw "Configuration file not found: $Path"
        }
        
        $config = Import-PowerShellDataFile -Path $Path -ErrorAction Stop
        
        # Validate required properties
        $requiredProperties = @('host', 'port', 'password')
        foreach ($prop in $requiredProperties) {
            if (-not $config.ContainsKey($prop)) {
                throw "Missing required configuration property: $prop"
            }
        }
        
        Write-Log "Configuration loaded successfully from: $Path"
        return $config
    }
    catch {
        Write-Log "Failed to load configuration: $($_.Exception.Message)" -Level Error
        throw
    }
}

function Initialize-Connections {
    <#
    .SYNOPSIS
        Initializes connections to Voicemeeter and OBS.
    #>
    try {
        $script:vmr = Connect-Voicemeeter -Kind $VoicemeeterKind -ErrorAction Stop
        Write-Log 'Voicemeeter connection established'
        
        $obsConfig = Get-ConnectionConfig
        

        $webSocketUri = "ws://$($obsConfig.host):$($obsConfig.port)"
        $script:obsJob = Watch-OBS -WebSocketURI $webSocketUri -WebSocketToken $obsConfig.password -ErrorAction Stop
        Write-Log "OBS connection at $webSocketUri established"
    }
    catch {
        Write-Log "Failed to initialize connections: $($_.Exception.Message)" -Level Error
        throw
    }
}

function Disconnect-All {
    <#
    .SYNOPSIS
        Safely disconnects from all services.
    #>
    Write-Log 'Cleaning up connections...'
    
    try {
        if ($script:obsJob) {
            Remove-Job -Job $script:obsJob -Force -ErrorAction SilentlyContinue
            Disconnect-OBS -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Log "Error disconnecting from OBS: $($_.Exception.Message)" -Level Warning
    }
    
    try {
        if ($script:vmr) {
            Disconnect-Voicemeeter -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Log "Error disconnecting from Voicemeeter: $($_.Exception.Message)" -Level Warning
    }
    
    Write-Log 'Cleanup completed'
}

#endregion

#region Event Handlers

function Invoke-CurrentProgramSceneChanged {
    <#
    .SYNOPSIS
        Handles OBS scene change events.
    #>
    param(
        [Parameter(Mandatory)]
        [System.Object]$EventData
    )
    
    if (-not $EventData.sceneName) {
        Write-Log 'Scene change event received but no scene name provided' -Level Warning
        return
    }
    
    Write-Log "Scene changed to: $($EventData.sceneName)"
    
    try {
        switch ($EventData.sceneName) {
            'START' { 
                Write-Log 'Toggling mute for strip 0'
                $script:vmr.strip[0].mute = !$script:vmr.strip[0].mute
            }
            'BRB' { 
                Write-Log 'Setting gain to -8.3dB for strip 0'
                $script:vmr.strip[0].gain = -8.3
            }
            'END' { 
                Write-Log 'Enabling mono for strip 0'
                $script:vmr.strip[0].mono = $true
            }
            'LIVE' { 
                Write-Log 'Setting color_x to 0.3 for strip 0'
                $script:vmr.strip[0].color_x = 0.3
            }
            default { 
                Write-Log "Unknown scene '$($EventData.sceneName)'. Expected: START, BRB, END, or LIVE" -Level Warning
            }
        }
    }
    catch {
        Write-Log "Error processing scene change: $($_.Exception.Message)" -Level Error
    }
}

function Invoke-ExitStarted {
    <#
    .SYNOPSIS
        Handles OBS exit events.
    #>
    param([System.Object]$EventData)
    
    Write-Log 'OBS shutdown detected - initiating graceful exit'
    $script:shouldExit = $true
}

function Invoke-EventDispatcher {
    <#
    .SYNOPSIS
        Dispatches OBS events to appropriate handlers.
    #>
    param(
        [Parameter(Mandatory)]
        [System.Object]$EventData
    )
    
    if (-not $EventData.eventType) {
        Write-Log 'Event received without eventType property' -Level Warning
        return
    }
    
    $handlerName = "Invoke-$($EventData.eventType)"
    
    if (Get-Command $handlerName -ErrorAction SilentlyContinue) {
        try {
            & $handlerName -EventData $EventData.eventData
        }
        catch {
            Write-Log "Error in event handler '$handlerName': $($_.Exception.Message)" -Level Error
        }
    }
    else {
        Write-Log "No handler found for event type: $($EventData.eventType)" -Level Warning
    }
}

#endregion

#region Main Execution

function Start-VoicemeeterObsSync {
    <#
    .SYNOPSIS
        Main execution function for the sync process.
    #>
    Write-Log 'Starting Voicemeeter-OBS synchronization service'
    
    try {
        Initialize-Connections
        
        Write-Log 'Monitoring OBS events... Press Ctrl+C to stop'
        
        while (-not $script:shouldExit) {
            try {
                $obsEvents = Receive-Job -Job $script:obsJob -ErrorAction SilentlyContinue
                
                foreach ($obsEvent in $obsEvents) {
                    if ($obsEvent.MessageData.op -eq 5) {
                        Invoke-EventDispatcher -EventData $obsEvent.MessageData.d
                    }
                }
                
                Start-Sleep -Milliseconds 100
            }
            catch {
                Write-Log "Error processing OBS events: $($_.Exception.Message)" -Level Error
            }
        }
    }
    catch {
        Write-Log "Fatal error: $($_.Exception.Message)" -Level Error
        exit 1
    }
    finally {
        Disconnect-All
    }
    
    Write-Log 'Voicemeeter-OBS synchronization service stopped'
}

# Handle Ctrl+C gracefully
$null = Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    $script:shouldExit = $true
}

Start-VoicemeeterObsSync

#endregion  