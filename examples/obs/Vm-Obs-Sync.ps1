[cmdletbinding()]
param()

Import-Module ..\..\lib\Voicemeeter.psm1
Import-Module obs-powershell

function CurrentProgramSceneChanged {
    param([System.Object]$data)
    Write-Host "Switched to scene", $data.sceneName

    switch ($data.sceneName) {
        "START" { 
            $vmr.strip[0].mute = !$vmr.strip[0].mute
        }
        "BRB" { 
            $vmr.strip[0].gain = -8.3
        }
        "END" { 
            $vmr.strip[0].mono = $true
        }
        "LIVE" { 
            $vmr.strip[0].color_x = 0.3
        }
        default { "Expected START, BRB, END or LIVE scene" | Write-Warning; return }
    }
}

function ExitStarted {
    param([System.Object]$data)
    "OBS shutdown has begun!" | Write-Host
    break
}

function eventHandler($data) {
    if (Get-Command $data.eventType -ErrorAction SilentlyContinue) {
        & $data.eventType -data $data.eventData
    }
}

function ConnFromFile {
    $configpath = Join-Path $PSScriptRoot "config.psd1"
    return Import-PowerShellDataFile -Path $configpath
}

function main {
    $vmr = Connect-Voicemeeter -Kind "basic"

    $conn = ConnFromFile
    $job = Watch-OBS -WebSocketURI "ws://$($conn.host):$($conn.port)" -WebSocketToken $conn.password

    try {
        while ($true) {
            Receive-Job -Job $job | ForEach-Object {
                $data = $_.MessageData

                if ($data.op -eq 5) {
                    eventHandler($data.d)
                }
            }
        }
    }
    finally { 
        Disconnect-OBS 
        Disconnect-Voicemeeter
    }    
}

main
