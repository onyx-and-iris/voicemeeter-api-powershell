class Vban : IRemote {
    [string]$direction
    
    Vban ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote) {
        $this.direction = $direction

        AddBoolMembers -PARAMS @('on')
        AddStringMembers -PARAMS @('name', 'ip')
    }

    [string] identifier () {
        return 'vban.' + $this.direction + 'stream[' + $this.index + ']'
    }

    hidden $_port = $($this | Add-Member ScriptProperty 'port' `
        {
            [int]$this.Getter('port')
        } `
        {
            param([int]$arg)
            if ($arg -ge 1024 -and $arg -le 65535) {
                $this._port = $this.Setter('port', $arg)
            }
            else {
                Write-Warning ('Expected value from 1024 to 65535')
            }
        }
    )
}

class VbanAudio : Vban {
    VbanAudio ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
        AddIntMembers -PARAMS @('quality', 'route')
    }
}

class VbanMidi : Vban {
    VbanMidi ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
    }
}

class VbanText : Vban {
    VbanText ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
    }
}

class VbanVideo : Vban {
    VbanVideo ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
    }
}

class VbanInAudio : VbanAudio {
    VbanInAudio ([int]$index, [Object]$remote) : base ($index, $remote, 'in') {
        AddIntMembers -ReadOnly -PARAMS @('sr', 'channel')
    }

    hidden $_bit = $($this | Add-Member ScriptProperty 'bit' `
        {
            $val = if ($this.Getter('bit') -eq 1) { 16 } else { 24 }
            return $val
        } `
        {
            Write-Warning ("ERROR: $($this.identifier()).bit is read only")
        }
    )
}

class VbanInMidi : VbanMidi {
    VbanInMidi ([int]$index, [Object]$remote) : base ($index, $remote, 'in') {
    }
}

class VbanInText : VbanText {
    VbanInText ([int]$index, [Object]$remote) : base ($index, $remote, 'in') {
    }
}

class VbanOutAudio : VbanAudio {
    VbanOutAudio ([int]$index, [Object]$remote) : base ($index, $remote, 'out') {
        AddIntMembers -PARAMS @('channel')
    }

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            [int]$this.Getter('sr')
        } `
        {
            param([int]$arg)
            $opts = @(11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
            if ($opts.Contains($arg)) {
                $this._sr = $this.Setter('sr', $arg)
            }
            else {
                Write-Warning ('Expected one of', $opts)
            }
        }
    )

    hidden $_bit = $($this | Add-Member ScriptProperty 'bit' `
        {
            $val = if ($this.Getter('bit') -eq 1) { 16 } else { 24 }
            return $val
        } `
        {
            param([int]$arg)
            if (@(16, 24).Contains($arg)) {
                $val = if ($arg -eq 16) { 1 } else { 2 }
                $this._bit = $this.Setter('bit', $val)
            }
            else {
                Write-Warning ('Expected value 16 or 24')
            }
        }
    )
}

class VbanOutMidi : VbanMidi {
    VbanOutMidi ([int]$index, [Object]$remote) : base ($index, $remote, 'out') {
    }

    hidden $_route = $($this | Add-Member ScriptProperty 'route' `
        {
            [string]$val = ''
            switch ($this.Getter('route')) {
                0 { $val = 'none' }
                1 { $val = 'midi_in' }
                2 { $val = 'aux_in' }
                4 { $val = 'vban_in' }
                7 { $val = 'all_in' }
                8 { $val = 'midi_out' }
            }
            return $val
        } `
        {
            param([string]$arg)
            [int]$val = 0
            switch ($arg) {
                'none' { $val = 0 }
                'midi_in' { $val = 1 }
                'aux_in' { $val = 2 }
                'vban_in' { $val = 4 }
                'all_in' { $val = 7 }
                'midi_out' { $val = 8 }
                default { Write-Warning ("route got: $arg, expected one of 'none', 'midi_in', 'aux_in', 'vban_in', 'all_in', 'midi_out'") }
            }
            $this._route = $this.Setter('route', $val)
        }
    )
}

class VbanOutVideo : VbanVideo {
    VbanOutVideo ([int]$index, [Object]$remote) : base ($index, $remote, 'out') {
        AddIntMembers -PARAMS @('vfps', 'vquality')
        AddIntMembers -WriteOnly -PARAMS @('route')
        AddBoolMembers -PARAMS @('vcursor')
    }

    hidden $_vformat = $($this | Add-Member ScriptProperty 'vformat' `
        {
            [string]$val = ''
            switch ($this.Getter('vformat')) {
                1 { $val = 'png' }
                2 { $val = 'jpg' }
            }
            return $val
        } `
        {
            param([string]$arg)
            [int]$val = 0
            switch ($arg) {
                'png' { $val = 1 }
                'jpg' { $val = 2 }
                default { Write-Warning ("vformat got: $arg, expected one of 'png', 'jpg'") }
            }
            $this._vformat = $this.Setter('vformat', $val)
        }
    )
}

function Make_Vban ([Object]$remote) {
    [System.Collections.ArrayList]$instream = @()
    [System.Collections.ArrayList]$outstream = @()

    $totalInstreams = $remote.kind.vban.in + $remote.kind.vban.midi + $remote.kind.vban.text
    $totalOutstreams = $remote.kind.vban.out + $remote.kind.vban.midi + $remote.kind.vban.video

    for ($i = 0; $i -lt $totalInstreams; $i++) {
        if ($i -lt $remote.kind.vban.in) {
            [void]$instream.Add([VbanInAudio]::new($i, $remote))
        }
        elseif ($i -lt ($remote.kind.vban.in + $remote.kind.vban.midi)) {
            [void]$instream.Add([VbanInMidi]::new($i, $remote))
        }
        else {
            [void]$instream.Add([VbanInText]::new($i, $remote))
        }
    }
    for ($i = 0; $i -lt $totalOutstreams; $i++) {
        if ($i -lt $remote.kind.vban.out) {
            [void]$outstream.Add([VbanOutAudio]::new($i, $remote))
        }
        elseif ($i -lt ($remote.kind.vban.out + $remote.kind.vban.midi)) {
            [void]$outstream.Add([VbanOutMidi]::new($i, $remote))
        }
        else {
            [void]$outstream.Add([VbanOutVideo]::new($i, $remote))
        }
    }

    $CustomObject = [pscustomobject]@{
        instream  = $instream
        outstream = $outstream
    }

    $CustomObject | Add-Member ScriptProperty 'enable' `
    {
        return [bool]( Param_Get -PARAM 'vban.enable' )
    } `
    {
        param([bool]$arg)
        Param_Set -PARAM 'vban.enable' -Value $(if ($arg) { 1 } else { 0 })
    }

    $CustomObject | Add-Member ScriptProperty 'port' `
    {
        return [int]( Param_Get -PARAM 'vban.instream[0].port' )
    } `
    {
        param([int]$arg)
        if ($arg -ge 1024 -and $arg -le 65535) {
            Param_Set -PARAM 'vban.instream[0].port' -Value $arg
        }
        else {
            Write-Warning ('Expected value from 1024 to 65535')
        }
    }

    $CustomObject
}
