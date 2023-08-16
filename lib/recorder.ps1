class IRecorder {
    [Object]$remote

    IRecorder ([Object]$remote) {
        $this.remote = $remote
    }

    [single] Getter ($param) {
        $this.Cmd($param) | Write-Debug
        return $this.remote.Getter($this.Cmd($param))
    }

    [void] Setter ($param, $val) {
        "$($this.Cmd($param))=$val" | Write-Debug
        if ($val -is [Boolean]) {
            $this.remote.Setter($this.Cmd($param), $(if ($val) { 1 } else { 0 }))
        }
        else {
            $this.remote.Setter($this.Cmd($param), $val)
        }
    }

    [string] Cmd ($param) {
        if ([string]::IsNullOrEmpty($param)) {
            return $this.identifier()
        }
        return "$($this.identifier()).$param"
    }
}

class Recorder : IRecorder {
    [Object]$remote
    [Object]$mode
    [System.Collections.ArrayList]$armstrip
    [System.Collections.ArrayList]$armbus

    Recorder ([Object]$remote) : base ($remote) {
        $this.mode = [RecorderMode]::new($remote)
        $this.armstrip = @()
        0..($remote.kind.p_in + $remote.kind.v_in - 1) | ForEach-Object {
            $this.armstrip.Add([RecorderArmStrip]::new($_, $remote))
        }
        $this.armbus = @()
        0..($remote.kind.p_out + $remote.kind.v_out - 1) | ForEach-Object {
            $this.armbus.Add([RecorderArmBus]::new($_, $remote))
        }

        AddActionMembers -PARAMS @('play', 'stop', 'pause', 'replay', 'record', 'ff', 'rew')
        AddFloatMembers -PARAMS @('gain')
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

    hidden $_samplerate = $($this | Add-Member ScriptProperty 'samplerate' `
        {
            $this.Getter('samplerate')
        } `
        {
            param([int]$arg)
            $opts = @(22050, 24000, 32000, 44100, 48000, 88200, 96000, 176400, 192000)
            if ($opts.Contains($arg)) {
                $this._samplerate = $this.Setter('samplerate', $arg)
            }
            else {
                "samplerate got: $arg, expected one of $opts" | Write-Warning
            }
        }
    )

    hidden $_bitresolution = $($this | Add-Member ScriptProperty 'bitresolution' `
        {
            $this.Getter('bitresolution')
        } `
        {
            param([int]$arg)
            $opts = @(8, 16, 24, 32)
            if ($opts.Contains($arg)) {
                $this._bitresolution = $this.Setter('bitresolution', $arg)
            }
            else {
                "bitresolution got: $arg, expected one of $opts" | Write-Warning
            }
        }
    )

    hidden $_channel = $($this | Add-Member ScriptProperty 'channel' `
        {
            $this.Getter('channel')
        } `
        {
            param([int]$arg)
            if ($arg -ge 1 -and $arg -le 8) {
                $this._channel = $this.Setter('channel', $arg)
            }
            else {
                "channel got: $arg, expected value from 1 to 8" | Write-Warning
            }
        }
    )

    hidden $_kbps = $($this | Add-Member ScriptProperty 'kbps' `
        {
            $this.Getter('kbps')
        } `
        {
            param([int]$arg)
            $opts = @(32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320)
            if ($opts.Contains($arg)) {
                $this._kbps = $this.Setter('kbps', $arg)
            }
            else {
                "kbps got: $arg, expected one of $opts" | Write-Warning
            }
        }
    )

    [void] Load ([string]$filename) {
        $this.Setter('load', $filename)
    }

    [void] GoTo ([string]$timestring) {
        try {
            if ([datetime]::ParseExact($timestring, "HH:mm:ss", $null)) {
                $timespan = [timespan]::Parse($timestring)
                $this.Setter("GoTo", $timespan.TotalSeconds)                
            }
        }
        catch [FormatException] {
            "Time string $timestring does not match the required format 'hh:mm:ss'" | Write-Warning
        }
    }

    [void] FileType($format) {
        [int]$val = 0
        switch ($format) {
            "wav" { $val = 1 }
            "aiff" { $val = 2 }
            "bwf" { $val = 3 }
            "mp3" { $val = 100 }
            default { "Filetype() got: $format, expected one of 'wav', 'aiff', 'bwf', 'mp3'" }
        }
        $this.Setter("filetype", $val)
    }
}

class RecorderMode : IRecorder {
    RecorderMode ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('recbus', 'playonload', 'loop', 'multitrack')
    }

    [string] identifier () {
        return "Recorder.Mode"
    }
}

class RecorderArm : IRecorder {
    [int]$index

    RecorderArm ([int]$index, [Object]$remote) : base ($remote) {
        $this.index = $index
    }

    Set ([bool]$val) {
        $this.Setter("", $(if ($val) { 1 } else { 0 }))
    }
}

class RecorderArmStrip : RecorderArm {
    RecorderArmStrip ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return "Recorder.ArmStrip[$($this.index)]"
    }
}

class RecorderArmBus : RecorderArm {
    RecorderArmBus ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return "Recorder.ArmBus[$($this.index)]"
    }
}

function Make_Recorder ([Object]$remote) {
    return [Recorder]::new($remote)
}
