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

    [void] Setup() {
        Login -TYPE $this.type

        $this.button = Buttons
        $this.strip = Strips
        $this.bus = Buses
    }

    [void] Logout() {
        Logout
    }
    
    [void] Set_Multi([HashTable]$hash) {
        Param_Set_Multi -HASH $hash
    }
}

Function Get-RemoteBasic {
    return [Remote]::new('basic')
}

Function Get-RemoteBanana {
    return [Remote]::new('banana')
}

Function Get-RemotePotato {
    return [Remote]::new('potato')
}

Export-ModuleMember -Function Get-RemoteBasic, Get-RemoteBanana, Get-RemotePotato
