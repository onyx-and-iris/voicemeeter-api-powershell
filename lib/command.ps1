. $PSScriptRoot\meta.ps1

class Special {
    # Constructor
    Special () {
        AddActionMembers -PARAMS @('restart', 'shutdown', 'show')
    }

    [string] ToString() {
        return $this.GetType().Name
    }

    [single] Getter ($cmd) {
        return Param_Get -PARAM $cmd -IS_STRING $false
    }

    [void] Setter ($param, $val) {
        if ($val -is [Boolean]) {
            Param_Set -PARAM $param -Value $(if ($val) { 1 } else { 0 })
        }
        else {
            Param_Set -PARAM $param -Value $val
        }
    }

    [string] cmd ($arg) {
        return "Command.$arg"
    }

    hidden $_hide = $($this | Add-Member ScriptProperty 'hide' `
        {
            $this._hide = $this.Setter($this.cmd('show'), $false)
        } `
        {}
    )

    hidden $_showvbanchat = $($this | Add-Member ScriptProperty 'showvbanchat' `
        {
            $this.Getter($this.cmd('DialogShow.VBANCHAT'))
        } `
        {
            param([bool]$arg)
            $this._showvbanchat = $this.Setter($this.cmd('DialogShow.VBANCHAT'), $arg)
        }
    )

    hidden $_lock = $($this | Add-Member ScriptProperty 'lock' `
        {
            $this._lock = $this.Getter($this.cmd('lock'))
        } `
        {
            param([bool]$arg)
            $this._lock = $this.Setter($this.cmd('lock'), $arg)
        }
    )
}

function Make_Command {
    return [Special]::new()
}
