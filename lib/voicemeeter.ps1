. $PSScriptRoot\base.ps1

class Remote {
    [String]$type
    [System.Collections.ArrayList]$button
    [System.Collections.ArrayList]$strip
    [System.Collections.ArrayList]$bus

    # Constructor
    Remote ([String]$type)
    {
        $this.type = $type
        $this.Setup()
    }

    [void] Setup () {
        Login -TYPE $this.type

        $this.button = Buttons
        $this.strip = Strips
        $this.bus = Buses
    }

    [void] Logout () {
        Logout
    }
}
