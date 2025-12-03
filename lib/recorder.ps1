class Recorder : IRemote {
    [Object]$mode
    [System.Collections.ArrayList]$armstrip
    [System.Collections.ArrayList]$armbus
    [System.Collections.ArrayList]$states

    Recorder ([Object]$remote) : base ($remote) {
        $this.mode = [RecorderMode]::new($remote)
        
        $this.armstrip = @()
        $stripCount = $($remote.kind.p_in + $remote.kind.v_in)
        for ($i = 0; $i -lt $stripCount; $i++) {
            $this.armstrip.Add([BoolArrayMember]::new($i, 'armstrip', $this))
        }
        
        $this.armbus = @()
        $busCount = $($remote.kind.p_out + $remote.kind.v_out)
        for ($i = 0; $i -lt $busCount; $i++) {
            $this.armbus.Add([BoolArrayMember]::new($i, 'armbus', $this))
        }

        $this.states = @('play', 'stop', 'record', 'pause')
        AddActionMembers -PARAMS $this.states

        AddActionMembers -PARAMS @('replay', 'ff', 'rew')
        AddFloatMembers -PARAMS @('gain')
        AddIntMembers -PARAMS @('prerectime')

        AddChannelMembers
    }

    [string] identifier () {
        return 'Recorder'
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

    hidden $_armedbus = $($this | Add-Member ScriptProperty 'armedbus' `
        {
            foreach ($bus in 0..$($this.remote.kind.p_out + $this.remote.kind.v_out - 1)) {
                if ($this.remote.Getter("Recorder.ArmBus[$bus]")) {
                    break
                }
            }
            return $bus
        } `
        {
            param([int]$arg)
            $busMax = $this.remote.kind.p_out + $this.remote.kind.v_out - 1
            if ($arg -ge 0 -and $arg -le $busMax) {
                $this._armedbus = $this.remote.Setter("Recorder.ArmBus[$arg]", 1)
            }
            else {
                Write-Warning ("Expected a bus index between 0 and $busMax")
            }
        }
    )

    hidden $_state = $($this | Add-Member ScriptProperty 'state' `
        {
            if ($this.Getter('pause')) { return 'pause' }
            foreach ($state in $this.states) {
                if ($this.Getter($state)) {
                    break
                }
            }
            return $state
        } `
        {
            param([string]$arg)
            if (-not $this.states.Contains($arg)) {
                Write-Warning ("Recorder.State got: $arg, expected one of $($this.states)")
                return
            }
            if ($arg -eq 'pause' -and -not $this.Getter('record')) {
                Write-Warning ("Recorder.State can only be set to 'pause' when recording")
                return
            }
            $this._state = $this.Setter($arg, 1)
        }
    )

    [void] Load ([string]$filename) {
        $this.Setter('load', $filename)
    }

    [void] GoTo ([string]$timestring) {
        try {
            if ([datetime]::ParseExact($timestring, 'HH:mm:ss', $null)) {
                $timespan = [timespan]::Parse($timestring)
                $this.Setter('GoTo', $timespan.TotalSeconds)                
            }
        }
        catch [FormatException] {
            "Time string $timestring does not match the required format 'hh:mm:ss'" | Write-Warning
        }
    }

    [void] FileType($format) {
        [int]$val = 0
        switch ($format) {
            'wav' { $val = 1 }
            'aiff' { $val = 2 }
            'bwf' { $val = 3 }
            'mp3' { $val = 100 }
            default { "Filetype() got: $format, expected one of 'wav', 'aiff', 'bwf', 'mp3'" }
        }
        $this.Setter('filetype', $val)
    }

    [void] Prefix ([string]$prefix) {
        $this.Setter('prefix', $prefix)
    }

    [void] Eject () {
        $this.remote.Setter('Command.Eject', 1)
    }
}

class RecorderMode : IRemote {
    RecorderMode ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('recbus', 'playonload', 'loop', 'multitrack')
    }

    [string] identifier () {
        return 'Recorder.Mode'
    }
}

class RecorderArm : IRemote {
    RecorderArm ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    Set ([bool]$val) {
        $this.Setter('', $(if ($val) { 1 } else { 0 }))
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
