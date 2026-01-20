<#
.SYNOPSIS
    Command Line Interface for Voicemeeter control.
.DESCRIPTION
    This script provides a command line interface to interact with Voicemeeter. It supports both interactive mode and scripted commands.
    Users can specify the type of Voicemeeter (banana or potato) and execute commands to get or set parameters.
.PARAMETER help
    Displays help information.
.PARAMETER interactive
    Starts the CLI in interactive mode.
.PARAMETER kind
    Specifies the type of Voicemeeter to connect to (banana or potato). Default is 'banana'.
.PARAMETER script
    A list of commands to execute in sequence.
#>

[cmdletbinding()]
param(
    [switch]$help,
    [switch]$interactive,
    [String]$kind = 'banana',
    [String[]]$script = @()
)

Import-Module ..\..\lib\Voicemeeter.psm1

if ($help -or ($script.Count -eq 0 -and -not $interactive)) {
    Write-Host 'Voicemeeter CLI'
    Write-Host ''
    Write-Host 'Usage:'
    Write-Host '  CLI.ps1 [-interactive] [-kind <basic|banana|potato>] [-script <command1>, <command2>, ...]'
    Write-Host ''
    Write-Host 'Options:'
    Write-Host '  -interactive        Start in interactive mode.'
    Write-Host '  -kind <type>       Specify the Voicemeeter type (basic, banana or potato). Default is banana.'
    Write-Host '  -script <commands> Provide a list of commands to execute in sequence.'
    Write-Host ''
    Write-Host 'Commands can be of the form:'
    Write-Host '  Parameter=Value     Set a parameter to a specific value.'
    Write-Host '  !Parameter         Toggle a boolean parameter.'
    Write-Host '  Parameter          Get the current value of a parameter.'
    exit 0
}

function Get-ParameterValue {
    param(
        [object]$vmr,
        [string]$Parameter
    )

    try {
        $retval = $vmr.Getter($Parameter)
    }
    catch {
        $retval = $vmr.Getter_String($Parameter)
    }
    $retval
}


function Invoke-VoicemeeterCLICommand {
    param(
        [object]$vmr,
        [string]$Command
    )

    # Toggle command
    if ($Command[0] -eq '!') {
        $parameter = $Command.Substring(1).Trim()
        $currentValue = Get-ParameterValue -vmr $vmr -Parameter $parameter

        if ($currentValue -ne 0 -and $currentValue -ne 1) {
            throw "Cannot toggle non-boolean parameter '$parameter' with value '$currentValue'"
        }

        $newValue = 1 - $currentValue
        $vmr.SendText("$parameter=$newValue")
        Write-Host "Toggled $parameter to $newValue"
    }
    # Set command
    elseif ($Command.Contains('=')) {
        $vmr.SendText("$Command")
        Write-Host "Set $Command"
    }
    # Get command
    else {
        $parameter = $Command.Trim()
        $value = Get-ParameterValue -vmr $vmr -Parameter $parameter
        Write-Host "$parameter = $value"
    }
}

function Start-VoicemeeterCLI {
    param(
        [object]$vmr
    )

    Write-Host "Connected to Voicemeeter. Type 'Q' to quit." -ForegroundColor Green
    while (($CommandFromInput = Read-Host 'command') -ne 'Q') {
        try {
            Invoke-VoicemeeterCLICommand -vmr $vmr -Command $CommandFromInput
        }
        catch {
            Write-Host "Error: $_" -ForegroundColor Red
        }
    }
}

try {
    $vmr = Connect-Voicemeeter -Kind $kind
    
    if ($interactive) {
        Start-VoicemeeterCLI -vmr $vmr
    }
    else {
        foreach ($command in $script) {
            Invoke-VoicemeeterCLICommand -vmr $vmr -Command $command
        }
    }
}
finally { Disconnect-Voicemeeter }