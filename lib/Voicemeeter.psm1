. $PSScriptRoot\kinds.ps1
. $PSScriptRoot\base.ps1

class Remote {
    [Hashtable]$kind
    [System.Collections.ArrayList]$strip
    [System.Collections.ArrayList]$bus
    [System.Collections.ArrayList]$button
    [PSCustomObject]$vban
    [Object]$command
    [Object]$recorder
    [Object]$profiles

    # Constructor
    Remote ([String]$kind_id) {
        $this.kind = GetKind($kind_id)
        $this.Setup()
    }

    [void] Setup() {
        if (Setup_DLL) {
            Login -KIND $this.kind.name
            $this.profiles = Get_Profiles($this.kind.name)
            $this.strip = Make_Strips($this)
            $this.bus = Make_Buses($this)
            $this.button = Make_Buttons
            $this.vban = Make_Vban($this)
            $this.command = Make_Command
            $this.recorder = Make_Recorder($this)
        }
        else { Exit }
    }

    [void] Logout() {
        Logout
    }

    [void] Set_Profile([String]$config) {
        Set_Profile -DATA $this.profiles -CONF $config
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
