. $PSScriptRoot\base.ps1

class Remote {
    [String]$kind
    [System.Collections.ArrayList]$strip
    [System.Collections.ArrayList]$bus
    [System.Collections.ArrayList]$button
    [PSCustomObject]$vban
    $command

    # Constructor
    Remote ([String]$kind)
    {
        $this.kind = $kind
        $this.Setup()
    }

    [void] Setup() {
        if(Setup_DLL) {
            Login -KIND $this.kind

            $this.strip = Make_Strips
            $this.bus = Make_Buses
            $this.button = Make_Buttons
            $this.vban = Make_Vban
            $this.command = Make_Command
        }
        else { Exit }
    }

    [void] Logout() {
        Logout
    }

    [Single] Getter([String]$param) {
        return Param_Get -PARAM $param
    }

    [String] Getter_String([String]$param) {
        return Param_Get -PARAM $param -IS_STRING $true
    }

    [void] Setter([String]$param, [Object]$value) {
        Param_Set -PARAM $param -VALUE $value
    }
    
    [void] Set_Multi([HashTable]$hash) {
        Param_Set_Multi -HASH $hash
    }

    [void] PDirty() { P_Dirty }

    [void] MDirty() { M_Dirty }
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
