<#
    1) Loop through an array of bus objects. 
    2) Mute first unmuted bus
    3) If next bus in array exists, unmute it, otherwise clear unmuted variable.
    4) If every bus in array is muted, unmute the first bus specified in array.

    Credits go to @bobsupercow
#>

Import-Module Voicemeeter

try {
    $vmr = Get-RemotePotato

    $buses = @($vmr.bus[1], $vmr.bus[2], $vmr.bus[4], $vmr.bus[6])
    $unmutedIndex = $null

    # 1)
    $buses | ForEach-Object {
        $bus = $_
        # 2)
        if (-not $bus.mute) {
            Write-Host "bus", $bus.index, "is unmuted... muting it"
            $unmutedIndex = $buses.IndexOf($bus)
            $bus.mute = $true

            # 3)
            if ($buses[++ $unmutedIndex]) {
                "unmuting bus " + $buses[$unmutedIndex].index | Write-Host
                $buses[$unmutedIndex].mute = $false
                break
            }
            else { Clear-Variable unmutedIndex }
        }
    }
    # 4)
    if ($null -eq $unmutedIndex) { $buses[0].mute = $false }
    "unmuting bus " + $buses[0].index | Write-Host
}
finally { $vmr.Logout() }
