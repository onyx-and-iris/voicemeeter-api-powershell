. $PSScriptRoot\kinds.ps1
. $PSScriptRoot\base.ps1

class Remote {
    [Hashtable]$kind
    [Object]$profiles

    Remote ([String]$kindId) {
        if (!(Setup_DLL)) {
            Exit -1
        }
        $this.kind = GetKind($kindId)
        $this.profiles = Get_Profiles($this.kind.name)
        Login -KIND $this.kind.name
    }

    [string] ToString() {
        return "Voicemeeter " + $this.kind.name.substring(0, 1).toupper() + $this.kind.name.substring(1)
    }

    [void] Logout() {
        Logout
    }

    [string] GetType() {
        return VmType
    }

    [String] GetVersion() {
        return Version
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

    [void] SendText([String]$script) {
        Set_By_Script -SCRIPT $script
    }

    [void] PDirty() { P_Dirty }

    [void] MDirty() { M_Dirty }
}

class RemoteBasic : Remote {
    [System.Collections.ArrayList]$strip
    [System.Collections.ArrayList]$bus
    [System.Collections.ArrayList]$button
    [PSCustomObject]$vban
    [Object]$command

    RemoteBasic () : base ('basic') {
        $this.strip = Make_Strips($this)
        $this.bus = Make_Buses($this)
        $this.button = Make_Buttons
        $this.vban = Make_Vban($this)
        $this.command = Make_Command
    }
}

class RemoteBanana : Remote {
    [System.Collections.ArrayList]$strip
    [System.Collections.ArrayList]$bus
    [System.Collections.ArrayList]$button
    [PSCustomObject]$vban
    [Object]$command
    [Object]$recorder

    RemoteBanana () : base ('banana') {
        $this.strip = Make_Strips($this)
        $this.bus = Make_Buses($this)
        $this.button = Make_Buttons
        $this.vban = Make_Vban($this)
        $this.command = Make_Command
        $this.recorder = Make_Recorder($this)
    }
}

class RemotePotato : Remote {
    [System.Collections.ArrayList]$strip
    [System.Collections.ArrayList]$bus
    [System.Collections.ArrayList]$button
    [PSCustomObject]$vban
    [Object]$command
    [Object]$recorder

    RemotePotato () : base ('potato') {
        $this.strip = Make_Strips($this)
        $this.bus = Make_Buses($this)
        $this.button = Make_Buttons
        $this.vban = Make_Vban($this)
        $this.command = Make_Command
        $this.recorder = Make_Recorder($this)
    }
}

Function Get-RemoteBasic {
    [RemoteBasic]::new()
}

Function Get-RemoteBanana {
    [RemoteBanana]::new()
}

Function Get-RemotePotato {
    [RemotePotato]::new()
}

Function Connect-Voicemeeter {
    param([String]$Kind)
    try {
        switch ($Kind) {
            "basic" { 
                return Get-RemoteBasic
            }
            "banana" { 
                return Get-RemoteBanana
            }
            "potato" { 
                return Get-RemotePotato
            }
            default { throw [LoginError]::new("Unknown Voicemeeter kind `"$Kind`"") }
        }        
    }
    catch [LoginError], [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
        throw
    }
}

Function Disconnect-Voicemeeter {
    Logout
}

Export-ModuleMember -Function Get-RemoteBasic, Get-RemoteBanana, Get-RemotePotato, Connect-Voicemeeter, Disconnect-Voicemeeter
