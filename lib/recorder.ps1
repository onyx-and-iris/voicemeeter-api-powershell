. $PSScriptRoot\meta.ps1

class IRecorder {
    [Object]$remote

    IRecorder ([Object]$remote) {
        $this.remote = $remote
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
}

class Recorder : IRecorder {
    [Object]$remote
    [Object]$mode

    Recorder ([Object]$remote) : base ($remote) {
        $this.remote = $remote
        $this.mode = [RecorderMode]::new($remote)

        AddActionMembers -PARAMS @('play', 'stop', 'pause', 'replay', 'record', 'ff', 'rew')
        AddChannelMembers
    }

    [string] identifier () {
        return "Recorder"
    }

    [string] ToString() {
        return $this.GetType().Name
    }

    hidden $_loop = $($this | Add-Member ScriptProperty 'loop' `
        {
            [bool]$this.mode.loop
        } `
        {
            param($arg)
            $this.mode.loop = $arg
        }
    )

    [void] Load ([string]$filename) {
        $this.Setter('load', $filename)
    }
}

class RecorderMode : IRecorder {
    RecorderMode ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('loop')
    }

    [string] identifier () {
        return "Recorder.Mode"
    }
}

function Make_Recorder ([Object]$remote) {
    return [Recorder]::new($remote)
}
