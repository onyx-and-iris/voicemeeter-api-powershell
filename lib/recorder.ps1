. $PSScriptRoot\meta.ps1

class Recorder {
    # Constructor
    Recorder() {
        AddActionMembers -PARAMS @('play', 'stop', 'pause', 'replay', 'record', 'ff', 'rew')
        AddChannelMembers
    }

    [Single] Getter($cmd) {
        return Param_Get -PARAM $cmd -IS_STRING $false
    }

    [void] Setter($param, $val) {
        if ($val -is [Boolean]) {
            Param_Set -PARAM $param -VALUE $(if ($val) { 1 } else { 0 })
        }
        else {
            Param_Set -PARAM $param -VALUE $val
        }
    }

    [String] cmd ($arg) {
        return "Recorder.$arg"
    }

    hidden $_loop = $($this | Add-Member ScriptProperty 'loop' `
        {
            return Write-Warning("ERROR: " + $this.cmd('mode.loop') + " is write only")
        }`
        {
            param( [bool]$arg )
            $this._loop = $this.Setter($this.cmd('mode.loop'), $arg)
        }
    )

    [void] load([String]$filename) {
        $this.Setter($this.cmd('load'), $filename)
    }
}

Function Make_Recorder {
    return [Recorder]::new()
}
