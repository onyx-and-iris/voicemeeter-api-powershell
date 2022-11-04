Import-Module Voicemeeter
Import-Module OBSWebSocket

$VerbosePreference = "Continue"

$info = @{
    START = "Toggling Strip 0 mute"
    BRB = "Setting Strip 0 gain to -8.3"
    END = "Setting Strip 0 mono to `$false"
    LIVE = "Setting Strip 0 color_x to 0.3"
}

function CurrentProgramSceneChanged($data) {
    "Switched to scene " + $data.sceneName | Write-Host
    
    switch ($data.SceneName) {
        "START" { $vmr.strip[0].mute = !$vmr.strip[0].mute }
        "BRB" { $vmr.strip[0].gain = -8.3 }
        "END" { $vmr.strip[0].mono = $true }
        "LIVE" { $vmr.strip[0].color_x = 0.3 }
        default { "Expected START, BRB, END or LIVE scene" | Write-Warning; return }
    }
    $info[$data.SceneName] | Write-Host
}

function ConnFromFile {
    $configpath = Join-Path $PSScriptRoot "config.psd1"
    return Import-PowerShellDataFile -Path $configpath
}

function main {
    try {
        $vmr = Get-RemoteBasic
        $conn = ConnFromFile
        $r_client = Get-OBSRequest -hostname $conn.hostname -port $conn.port -pass $conn.password
        $resp = $r_client.getVersion()
        "obs version:" + $resp.obsVersion | Write-Host
        "websocket version:" + $resp.obsWebSocketVersion | Write-Host

        $e_client = Get-OBSEvent -hostname $conn.hostname -port $conn.port -pass $conn.password
        $callbacks = @("CurrentProgramSceneChanged", ${function:CurrentProgramSceneChanged})
        $e_client.Register($callbacks)
    } finally { 
        $r_client.TearDown()
        $e_client.TearDown()
        $vmr.Logout()
    }
}

if ($MyInvocation.InvocationName -ne '.') { main }
