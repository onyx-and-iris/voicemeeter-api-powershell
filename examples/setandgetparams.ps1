Import-Module Voicemeeter

try {
    $vmr = Get-RemoteBanana

    $vmr.button[0].state = $true
    $vmr.button[0].state
    $vmr.button[0].state = $false
    $vmr.button[0].state

    $vmr.strip[0].mono = $true
    $vmr.strip[0].mono
    $vmr.strip[0].mono = $false
    $vmr.strip[0].mono

    $vmr.bus[2].mute = $true
    $vmr.bus[2].mute
    $vmr.bus[2].mute = $false
    $vmr.bus[2].mute
    
    $vmr.strip[0].A1 = $true
    $vmr.strip[0].A1
    $vmr.strip[0].B2 = $false
    $vmr.strip[0].B2

    $vmr.bus[2].gain = -0.3
    $vmr.bus[2].gain
    $vmr.bus[3].gain = 3.2
    $vmr.bus[3].gain
}
finally { $vmr.Logout() }
