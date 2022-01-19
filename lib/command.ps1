. $PSScriptRoot\meta.ps1

class Special {
    # Constructor
    Special()
    {
        AddCommandMembers -PARAMS @('restart', 'shutdown', 'show')
    }

    [String] Getter($param) {
        return Write-Warning("ERROR: Usage: $param")
    }

    [void] Setter($param, $val = $true) {
        Param_Set -PARAM $param -VALUE $(if ($val) {1} else {0})
    }    

    [String] cmd ($arg) {
        return "Command.$arg"
    }

    hidden $_showvbanchat = $($this | Add-Member ScriptProperty 'showvbanchat' `
        {
            $this.Getter($this.cmd('DialogShow.VBANCHAT'))
        }`
        {
            param( [bool]$arg )
            $this._showvbanchat = $this.Setter($this.cmd('DialogShow.VBANCHAT'), $arg)
        }
    )

    hidden $_lock = $($this | Add-Member ScriptProperty 'lock' `
        {
            $this._lock = $this.Getter($this.cmd('lock'))
        }`
        {
            param( [bool]$arg )
            $this._lock = $this.Setter($this.cmd('lock'), $arg)
        }
    )
}

Function Make_Command {
    return [Special]::new()
}
