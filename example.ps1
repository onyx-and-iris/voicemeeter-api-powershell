. $PSScriptRoot\lib\voicemeeter.ps1

try {
    $vmr = [Remote]::new('potato')

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
}
finally { $vmr.Logout() }
