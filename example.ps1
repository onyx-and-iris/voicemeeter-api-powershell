Import-Module .\lib\Voicemeeter.psm1

try {
    $vmr = Get-RemoteBanana

    $hash = @{
        "Strip[0].Mute" = $true
        "Strip[1].Mute" = $true
        "Strip[2].Mute" = $false
        "Strip[0].Mono" = $true
        "Strip[1].Mono" = $false
        "Strip[2].Mono" = $true
    }

    $vmr.Set_Multi($hash)

    $hash = @{
        "Strip[0].Mute" = $false
        "Strip[1].Mute" = $false
        "Strip[2].Mute" = $false
        "Strip[0].Mono" = $true
        "Strip[1].Mono" = $true
        "Strip[2].Mono" = $false
    }

    $vmr.Set_Multi($hash)
}
finally { $vmr.Logout() }