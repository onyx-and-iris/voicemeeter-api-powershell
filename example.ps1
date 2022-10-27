Import-Module .\lib\Voicemeeter.psm1

try {
    # Run the factory function for required Voicemeeter type
    $vmr = Get-RemoteBanana

    # Set strip and bus params
    $vmr.strip[0].mono = $true
    $vmr.strip[0].mono
    $vmr.bus[1].mute = $false
    $vmr.bus[1].mute

    # Set macrobutton with id 4, mode state to 1
    $vmr.button[4].state = $true
    $vmr.button[4].state
}
finally { $vmr.Logout() }
