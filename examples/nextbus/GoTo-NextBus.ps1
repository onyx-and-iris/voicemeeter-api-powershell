<#
    1) Loop through an array of bus objects. 
    2) Mute first unmuted bus
    3) If next bus in array exists, unmute it, otherwise clear unmuted variable.
    4) If every bus in array is muted, unmute the first bus specified in array.

    Credits go to @bobsupercow
#>

[cmdletbinding()]
param()

Import-Module ..\..\lib\Voicemeeter.psm1

try {
    $vmr = Connect-Voicemeeter -Kind "potato"

    $buses = @($vmr.bus[1], $vmr.bus[2], $vmr.bus[4], $vmr.bus[6])
    "Buses in selection: $($buses)"
    $unmutedIndex = $null

    # 1)
    "Cycling through bus selection to check for first unmuted Bus..." | Write-Host
    foreach ($bus in $buses) {
        # 2)
        if (-not $bus.mute) {
            "Bus $($bus.index) is unmuted... muting it" | Write-Host
            $unmutedIndex = $buses.IndexOf($bus)
            $bus.mute = $true

            # 3)
            if ($buses[++$unmutedIndex]) {
                "Unmuting Bus $($buses[$unmutedIndex].index)" | Write-Host
                $buses[$unmutedIndex].mute = $false
                break
            }
            else { Clear-Variable unmutedIndex }
        }
    }
    # 4)
    if ($null -eq $unmutedIndex) { 
        $buses[0].mute = $false 
        "Unmuting Bus $($buses[0].index)" | Write-Host
    }
    
}
finally { Disconnect-Voicemeeter }
