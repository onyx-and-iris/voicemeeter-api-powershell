class Vban : IRemote {
    [string]$direction
    
    Vban ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote) {
        $this.direction = $direction
    }

    [string] identifier () {
        return 'vban.' + $this.direction + 'stream[' + $this.index + ']'
    }
}

class VbanAudio : Vban {
    VbanAudio ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
        AddBoolMembers -PARAMS @('on')
        AddStringMembers -PARAMS @('name', 'ip')
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

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            [int]$this.Getter('sr')
        } `
        {
            param([int]$arg)
            if ($this.direction -eq 'in') { Write-Warning ('Error, read only value') }
            else {
                $opts = @(11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
                if ($opts.Contains($arg)) {
                    $this._sr = $this.Setter('sr', $arg)
                }
                else {
                    Write-Warning ('Expected one of', $opts)
                }
            }
        }
    )

    hidden $_channel = $($this | Add-Member ScriptProperty 'channel' `
        {
            [int]$this.Getter('channel')
        } `
        {
            param([int]$arg)
            if ($this.direction -eq 'in') { Write-Warning ('Error, read only value') }
            else {
                if ($arg -ge 1 -and $arg -le 8) {
                    $this._channel = $this.Setter('channel', $arg)
                }
                else {
                    Write-Warning ('Expected value from 1 to 8')
                }
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
            if ($this.direction -eq 'in') { Write-Warning ('Error, read only value') }
            else {
                if (@(16, 24).Contains($arg)) {
                    $val = if ($arg -eq 16) { 1 } else { 2 }
                    $this._bit = $this.Setter('bit', $val)
                }
                else {
                    Write-Warning ('Expected value 16 or 24')
                }
            }
        }
    )

    hidden $_quality = $($this | Add-Member ScriptProperty 'quality' `
        {
            [int]$this.Getter('quality')
        } `
        {
            param([int]$arg)
            if ($arg -ge 0 -and $arg -le 4) {
                $this._quality = $this.Setter('quality', $arg)
            }
            else {
                Write-Warning ('Expected value from 0 to 4')
            }
        }
    )

    hidden $_route = $($this | Add-Member ScriptProperty 'route' `
        {
            [int]$this.Getter('route')
        } `
        {
            param([int]$arg)
            $rt = $this.remote.kind['p_' + $this.direction] + $this.remote.kind['v_' + $this.direction] - 1
            if ($arg -ge 0 -and $arg -le $rt) {
                $this._route = $this.Setter('route', $arg)
            }
            else {
                Write-Warning ("Expected value from 0 to $rt")
            }
        }
    )
}

class VbanMidi : Vban {
    VbanMidi ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
    }

    hidden $_on = $($this | Add-Member ScriptProperty 'on' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).on is write only")
        } `
        {
            param([bool]$arg)
            $this._on = $this.Setter('on', $arg)
        }
    )

    hidden $_name = $($this | Add-Member ScriptProperty 'name' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).name is write only")
        } `
        {
            param([string]$arg)
            $this._name = $this.Setter('name', $arg)
        }
    )

    hidden $_ip = $($this | Add-Member ScriptProperty 'ip' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).ip is write only")
        } `
        {
            param([string]$arg)
            $this._ip = $this.Setter('ip', $arg)
        }
    )
}

class VbanText : Vban {
    VbanText ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
    }

    hidden $_on = $($this | Add-Member ScriptProperty 'on' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).on is write only")
        } `
        {
            param([bool]$arg)
            $this._on = $this.Setter('on', $arg)
        }
    )

    hidden $_name = $($this | Add-Member ScriptProperty 'name' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).name is write only")
        } `
        {
            param([string]$arg)
            $this._name = $this.Setter('name', $arg)
        }
    )

    hidden $_ip = $($this | Add-Member ScriptProperty 'ip' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).ip is write only")
        } `
        {
            param([string]$arg)
            $this._ip = $this.Setter('ip', $arg)
        }
    )
}

class VbanInAudio : VbanAudio {
    VbanInAudio ([int]$index, [Object]$remote) : base ($index, $remote, 'in') {
    }
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
    }
}

class VbanOutMidi : VbanMidi {
    VbanOutMidi ([int]$index, [Object]$remote) : base ($index, $remote, 'out') {
    }
}

function Make_Vban ([Object]$remote) {
    [System.Collections.ArrayList]$instream = @()
    [System.Collections.ArrayList]$outstream = @()

    $totalInstreams = $remote.kind.vban.in + $remote.kind.vban.midi + $remote.kind.vban.text
    $totalOutstreams = $remote.kind.vban.out + $remote.kind.vban.midi

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
        else {
            [void]$outstream.Add([VbanOutMidi]::new($i, $remote))
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
