. $PSScriptRoot\lib\voicemeeter.ps1

try {
    $vmr = [Remote]::new('potato')

    $vmr.Login()

    $vmr.button[0].state = 1
    $vmr.button[0].state
    $vmr.button[0].state = 0
    $vmr.button[0].state

    $vmr.strip[0].mono = 1
    $vmr.strip[0].mono
    $vmr.strip[0].mono = 0
    $vmr.strip[0].mono

    $vmr.bus[2].mute = 1
    $vmr.bus[2].mute
    $vmr.bus[2].mute = 0
    $vmr.bus[2].mute
}
finally
{
    $vmr.Logout()
}
