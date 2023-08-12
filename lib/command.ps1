. $PSScriptRoot\meta.ps1
. $PSScriptRoot\inst.ps1

class Special {
    Special () {
        AddActionMembers -PARAMS @('restart', 'shutdown', 'show')
    }

    [string] identifier () {
        return "Command"
    }

    [string] ToString() {
        return $this.GetType().Name
    }

    [single] Getter ($param) {
        return Param_Get -PARAM "$($this.identifier()).$param" -IS_STRING $false
    }

    [void] Setter ($param, $val) {
        if ($val -is [Boolean]) {
            Param_Set -PARAM "$($this.identifier()).$param" -Value $(if ($val) { 1 } else { 0 })
        }
        else {
            Param_Set -PARAM "$($this.identifier()).$param" -Value $val
        }
    }

    [void] RunMacrobuttons() {
        Start-Process -FilePath $(Join-Path -Path $(Get_VMPath) -ChildPath "VoicemeeterMacroButtons.exe")
    }

    [void] CloseMacrobuttons() {
        Stop-Process -Name "VoicemeeterMacroButtons"
    }

    hidden $_hide = $($this | Add-Member ScriptProperty 'hide' `
        {
            $this._hide = $this.Setter('show', $false)
        } `
        {}
    )

    hidden $_showvbanchat = $($this | Add-Member ScriptProperty 'showvbanchat' `
        {
            $this.Getter('DialogShow.VBANCHAT')
        } `
        {
            param([bool]$arg)
            $this._showvbanchat = $this.Setter('DialogShow.VBANCHAT', $arg)
        }
    )

    hidden $_lock = $($this | Add-Member ScriptProperty 'lock' `
        {
            $this._lock = $this.Getter('lock')
        } `
        {
            param([bool]$arg)
            $this._lock = $this.Setter('lock', $arg)
        }
    )

    [void] Load ([string]$filename) {
        $this.Setter('load', $filename)
    }
}

function Make_Command {
    return [Special]::new()
}
