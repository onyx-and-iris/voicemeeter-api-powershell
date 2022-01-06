<#
    The following script was written with the intention of being used with a .vbs helper script, to create
    a hotkey to "Go to Next Bus" in a subset of buses with a visual indicator on your primary display.

    Credits go to @bobsupercow
#>

# 1) Loop through an array of buses. Toggle mute for first unmuted bus
# 2) If next bus in array exists, unmute it
# 3) else unmute the first bus specified in array.
# 4) If every bus in array is muted, unmute the first bus specified in array.

Import-Module Voicemeeter

try {
    # Run the factory function for required Voicemeeter type
    $vmr = Get-RemotePotato

    $unmutedIndex = $null
    [int32[]]$buses = @(1,2,4,6)

    0..($buses.Length -1) | ForEach-Object {
        # 1)
        if (-not $vmr.bus[$buses[$_]].mute){
            $unmutedIndex = $_
            $vmr.bus[$buses[$unmutedIndex]].mute = $true

            # 2)
            if ($unmutedIndex -lt ($buses.Length -1)){
                $vmr.bus[$buses[++$unmutedIndex]].mute = $false
                break
            }
            # 3)
            else {
                $vmr.bus[$buses[0]].mute = $false
            }
        }
    }   
    # 4)
    if ($null -eq $unmutedIndex) { $vmr.bus[$buses[0]].mute = -not $vmr.bus[$buses[0]].mute }

} finally { $vmr.Logout() }
