. $PSScriptRoot\meta.ps1

class Recorder {
    [Object]$remote
    # Constructor
    Recorder ([Object]$remote) {
        $this.remote = $remote

        AddActionMembers -PARAMS @('play', 'stop', 'pause', 'replay', 'record', 'ff', 'rew')
        AddChannelMembers
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
        return "Recorder.$arg"
    }

    hidden $_loop = $($this | Add-Member ScriptProperty 'loop' `
        {
            return Write-Warning ("ERROR: " + $this.cmd('mode.loop') + " is write only")
        } `
        {
            param([bool]$arg)
            $this._loop = $this.Setter($this.cmd('mode.loop'), $arg)
        }
    )

    [void] Load ([string]$filename) {
        $this.Setter($this.cmd('load'), $filename)
    }
}

function Make_Recorder ([Object]$remote) {
    return [Recorder]::new($remote)
}
