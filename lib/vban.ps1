class IVban {
    [int32]$index
    [Object]$remote
    [string]$direction

    IVban ([int]$index, [Object]$remote, [string]$direction) {
        $this.index = $index
        $this.remote = $remote
        $this.direction = $direction
    }

    [string] identifier () {
        return "vban." + $this.direction + "stream[" + $this.index + "]"
    }

    [single] Getter ($param) {
        return $this.remote.Getter($this.Cmd($param))
    }

    [string] Getter_String ($param) {
        $this.Cmd($param) | Write-Debug
        return $this.remote.Getter_String($this.Cmd($param))
    }

    [void] Setter ($param, $val) {
        "$($this.Cmd($param))=$val" | Write-Debug
        $this.remote.Setter($this.Cmd($param), $val)
    }

    [string] Cmd ($param) {
        if ([string]::IsNullOrEmpty($param)) {
            return $this.identifier()
        }
        return "$($this.identifier()).$param"
    }
}

class Vban : IVban {
    Vban ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
    }

    [string] ToString() {
        return $this.GetType().Name + $this.index
    }

    hidden $_on = $($this | Add-Member ScriptProperty 'on' `
        {
            $this.Getter('on')
        } `
        {
            param([bool]$arg)
            $this._on = $this.Setter('on', $arg)
        }
    )

    hidden $_name = $($this | Add-Member ScriptProperty 'name' `
        {
            $this.Getter_String('name')
        } `
        {
            param([string]$arg)
            $this._name = $this.Setter('name', $arg)
        }
    )

    hidden $_ip = $($this | Add-Member ScriptProperty 'ip' `
        {
            $this.Getter_String('ip')
        } `
        {
            param([string]$arg)
            $this._ip = $this.Setter('ip', $arg)
        }
    )

    hidden $_port = $($this | Add-Member ScriptProperty 'port' `
        {
            $this.Getter('port')
        } `
        {
            param([string]$arg)
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
            $this.Getter('sr')
        } `
        {
            param([int]$arg)
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
            else {
                $opts = @(11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
                if ($opts.Contains($arg)) {
                    $this._port = $this.Setter('sr', $arg)
                }
                else {
                    Write-Warning ('Expected one of', $opts)
                }
            }
        }
    )

    hidden $_channel = $($this | Add-Member ScriptProperty 'channel' `
        {
            $this.Getter('channel')
        } `
        {
            param([int]$arg)
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
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
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
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
            $this.Getter('quality')
        } `
        {
            param([int]$arg)
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
            else {
                if ($arg -ge 0 -and $arg -le 4) {
                    $this._quality = $this.Setter('quality', $arg)
                }
                else {
                    Write-Warning ('Expected value from 0 to 4')
                }
            }
        }
    )

    hidden $_route = $($this | Add-Member ScriptProperty 'route' `
        {
            $this.Getter('route')
        } `
        {
            param([int]$arg)
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
            else {
                if ($arg -ge 0 -and $arg -le 8) {
                    $this._route = $this.Setter('route', $arg)
                }
                else {
                    Write-Warning ('Expected value from 0 to 8')
                }
            }
        }
    )
}


class VbanInstream : Vban {
    VbanInstream ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
    }
}


class VbanOutstream : Vban {
    VbanOutstream ([int]$index, [Object]$remote, [string]$direction) : base ($index, $remote, $direction) {
    }
}


function Make_Vban ([Object]$remote) {
    [System.Collections.ArrayList]$instream = @()
    [System.Collections.ArrayList]$outstream = @()

    0..$($remote.kind.vban_in - 1) | ForEach-Object {
        [void]$instream.Add([VbanInstream]::new($_, $remote, "in"))
    }
    0..$($remote.kind.vban_out - 1) | ForEach-Object {
        [void]$outstream.Add([VbanOutstream]::new($_, $remote, "out"))
    }

    $CustomObject = [pscustomobject]@{
        instream  = $instream
        outstream = $outstream
    }

    $CustomObject | Add-Member ScriptProperty 'enable' `
    {
        return Write-Warning ("ERROR: vban.enable is write only")
    } `
    {
        param([bool]$arg)
        Param_Set -PARAM 'vban.Enable' -Value $(if ($arg) { 1 } else { 0 })
    }

    $CustomObject
}
