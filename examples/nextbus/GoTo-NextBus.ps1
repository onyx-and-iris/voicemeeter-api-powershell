<#
.SYNOPSIS
    Rotates through specified Voicemeeter buses, unmuting one at a time.
.DESCRIPTION
    This script connects to Voicemeeter Potato and allows the user to rotate through a set
    of buses (1, 2, 4, and 6). When the user presses Enter, the next bus in the sequence is unmuted,
    while all other specified buses are muted. The user can exit the rotation by typing 'Q'.
#>

[cmdletbinding()]
param()

Import-Module ..\..\lib\Voicemeeter.psm1

<#  
    A class that accepts a list of Voicemeeter buses and unmutes them one at a time in a round-robin fashion
#>
class BusRotator {
    [object]$vmr = $null
    [int]$CurrentIndex = -1
    [object[]]$Buses

    BusRotator([object]$vmr, [object[]]$buses) {
        $this.vmr = $vmr
        $this.Buses = $buses
    }

    hidden [object] GetNextBus() {
        # Mute all buses in the list
        foreach ($bus in $this.Buses) {
            $bus.mute = $true
        }

        # Determine the next bus to unmute
        $this.CurrentIndex = ($this.CurrentIndex + 1) % $this.Buses.Count

        return $this.Buses[$this.CurrentIndex]
    }

    [object] MuteNextBus() {
        $nextBus = $this.GetNextBus()
        $nextBus.mute = $false
        return $nextBus
    }
}


try {
    $vmr = Connect-Voicemeeter -Kind 'potato'

    # Mute all buses initially
    foreach ($bus in $vmr.bus) {
        $bus.mute = $true
    }

    $busesToRotate = @(
        $vmr.bus[1],
        $vmr.bus[2],
        $vmr.bus[4],
        $vmr.bus[6]
    )

    $rotator = [BusRotator]::new($vmr, $busesToRotate)
    while ((Read-Host "Press Enter to rotate buses or type 'Q' to quit.") -ne 'Q') {
        $nextBus = $rotator.MuteNextBus()
        Write-Host "Bus $nextBus is now unmuted."
    }
}
finally { Disconnect-Voicemeeter }
