<#
    The following script was written with the intention of being used with a .vbs helper script, to create
    a hotkey to "Go to Next Bus" in a subset of buses with a visual indicator on your primary display.

    Credits go to @bobsupercow
#>

# 1) Loop through an array of buses. 
# 2) Mute first unmuted bus
# 3) If next bus in array exists, unmute it
# 4) else unmute the first bus specified in array.
# 5) If every bus in array is muted, unmute the first bus specified in array.

Import-Module Voicemeeter

try {
    # Run the factory function for required Voicemeeter type
    $vmr = Get-RemotePotato

    $unmutedIndex = $null
    [int32[]]$buses = @(1,2,4,6)

    # 1)
    0..($buses.Length -1) | ForEach-Object {
        # 2)
        if ( -not $vmr.bus[$buses[$_]].mute ){
            $unmutedIndex = $_
            $vmr.bus[$buses[$unmutedIndex]].mute = $true

            # 3)
            if ( $buses[++$unmutedIndex] ){
                $vmr.bus[$buses[$unmutedIndex]].mute = $false
                break
            }
            # 4)
            else { $vmr.bus[$buses[0]].mute = $false }
        }
    }   
    # 5)
    if ( $null -eq $unmutedIndex ) { $vmr.bus[$buses[0]].mute = $false }

} finally { $vmr.Logout() }
