. $PSScriptRoot\meta.ps1

class Recorder {
    [Object]$remote

    Recorder ([Object]$remote) {
        $this.remote = $remote

        AddActionMembers -PARAMS @('play', 'stop', 'pause', 'replay', 'record', 'ff', 'rew')
        AddChannelMembers
    }

    [string] identifier () {
        return "Recorder"
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

    hidden $_loop = $($this | Add-Member ScriptProperty 'loop' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).mode.loop is write only")
        } `
        {
            param([bool]$arg)
            $this._loop = $this.Setter('mode.loop', $arg)
        }
    )

    [void] Load ([string]$filename) {
        $this.Setter('load', $filename)
    }
}

function Make_Recorder ([Object]$remote) {
    return [Recorder]::new($remote)
}
