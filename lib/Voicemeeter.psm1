. $PSScriptRoot\errors.ps1
. $PSScriptRoot\meta.ps1
. $PSScriptRoot\base.ps1
. $PSScriptRoot\kinds.ps1
. $PSScriptRoot\strip.ps1
. $PSScriptRoot\bus.ps1
. $PSScriptRoot\macrobuttons.ps1
. $PSScriptRoot\vban.ps1
. $PSScriptRoot\command.ps1
. $PSScriptRoot\recorder.ps1
. $PSScriptRoot\profiles.ps1

class Remote {
    [String]$vmpath
    [Hashtable]$kind
    [Object]$profiles

    Remote ([String]$kindId) {
        $this.vmpath = Setup_DLL
        $this.kind = GetKind($kindId)
        $this.profiles = Get_Profiles($this.kind.name)
    }

    [string] ToString() {
        return "Voicemeeter " + $this.kind.name.substring(0, 1).toupper() + $this.kind.name.substring(1)
    }

    [Remote] Login() {
        Login -kindId $this.kind.name
        return $this
    }

    [void] Logout() {
        Logout
    }

    [string] GetType() {
        return VmType
    }

    [String] GetVersion() {
        return VmVersion
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
        $this.command = Make_Command($this)
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
        $this.command = Make_Command($this)
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
        $this.command = Make_Command($this)
        $this.recorder = Make_Recorder($this)
    }
}

Function Get-RemoteBasic {
    [RemoteBasic]::new().Login()
}

Function Get-RemoteBanana {
    [RemoteBanana]::new().Login()
}

Function Get-RemotePotato {
    [RemotePotato]::new().Login()
}

Function Connect-Voicemeeter {
    param([String]$Kind)
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
        default { 
            throw [LoginError]::new("Unknown Voicemeeter kind `"$Kind`"")
        }
    }         
}

Function Disconnect-Voicemeeter {
    Logout
}

Export-ModuleMember -Function Get-RemoteBasic, Get-RemoteBanana, Get-RemotePotato, Connect-Voicemeeter, Disconnect-Voicemeeter
