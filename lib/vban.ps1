class Vban {
    [int32]$index
    [string]$direction

    # Constructor
    Vban ([int]$index) {
        $this.index = $index
    }

    [string] ToString() {
        return $this.GetType().Name + $this.index
    }

    [single] Getter ($cmd) {
        return Param_Get -PARAM $cmd -IS_STRING $false
    }

    [string] Getter_String ($cmd) {
        return Param_Get -PARAM $cmd -IS_STRING $true
    }

    [void] Setter ($cmd, $set) {
        Param_Set -PARAM $cmd -Value $set
    }

    [string] cmd ($arg) {
        return "vban." + $this.direction + "stream[" + $this.index + "].$arg"
    }

    hidden $_on = $($this | Add-Member ScriptProperty 'on' `
        {
            $this.Getter($this.cmd('on'))
        } `
        {
            param([bool]$arg)
            $this._on = $this.Setter($this.cmd('on'), $arg)
        }
    )

    hidden $_name = $($this | Add-Member ScriptProperty 'name' `
        {
            $this.Getter_String($this.cmd('name'))
        } `
        {
            param([string]$arg)
            $this._name = $this.Setter($this.cmd('name'), $arg)
        }
    )

    hidden $_ip = $($this | Add-Member ScriptProperty 'ip' `
        {
            $this.Getter_String($this.cmd('ip'))
        } `
        {
            param([string]$arg)
            $this._ip = $this.Setter($this.cmd('ip'), $arg)
        }
    )

    hidden $_port = $($this | Add-Member ScriptProperty 'port' `
        {
            $this.Getter($this.cmd('port'))
        } `
        {
            param([string]$arg)
            if ($arg -in 1024..65535) {
                $this._port = $this.Setter($this.cmd('port'), $arg)
            }
            else {
                Write-Warning ('Expected value from 1024 to 65535')
            }
        }
    )

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            $this.Getter($this.cmd('sr'))
        } `
        {
            param([int]$arg)
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
            else {
                $opts = @(11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
                if ($opts.Contains($arg)) {
                    $this._port = $this.Setter($this.cmd('sr'), $arg)
                }
                else {
                    Write-Warning ('Expected one of', $opts)
                }
            }
        }
    )

    hidden $_channel = $($this | Add-Member ScriptProperty 'channel' `
        {
            $this.Getter($this.cmd('channel'))
        } `
        {
            param([int]$arg)
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
            else {
                if ($arg -in 1..8) {
                    $this._channel = $this.Setter($this.cmd('channel'), $arg)
                }
                else {
                    Write-Warning ('Expected value from 1 to 8')
                }
            }
        }
    )

    hidden $_bit = $($this | Add-Member ScriptProperty 'bit' `
        {
            $val = if ($this.Getter($this.cmd('bit')) -eq 1) { 16 } else { 24 }
            return $val
        } `
        {
            param([int]$arg)
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
            else {
                if (@(16, 24).Contains($arg)) {
                    $val = if ($arg -eq 16) { 1 } else { 2 }
                    $this._bit = $this.Setter($this.cmd('bit'), $val)
                }
                else {
                    Write-Warning ('Expected value 16 or 24')
                }
            }
        }
    )

    hidden $_quality = $($this | Add-Member ScriptProperty 'quality' `
        {
            $this.Getter($this.cmd('quality'))
        } `
        {
            param([int]$arg)
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
            else {
                if ($arg -in 0..4) {
                    $this._quality = $this.Setter($this.cmd('quality'), $arg)
                }
                else {
                    Write-Warning ('Expected value from 0 to 4')
                }
            }
        }
    )

    hidden $_route = $($this | Add-Member ScriptProperty 'route' `
        {
            $this.Getter($this.cmd('route'))
        } `
        {
            param([int]$arg)
            if ($this.direction -eq "in") { Write-Warning ('Error, read only value') }
            else {
                if ($arg -in 0..8) {
                    $this._route = $this.Setter($this.cmd('route'), $arg)
                }
                else {
                    Write-Warning ('Expected value from 0 to 8')
                }
            }
        }
    )
}


class VbanInstream : Vban {
    # Constructor
    VbanInstream ([int]$index) : base ($index) {
        $this.direction = "in"
    }
}


class VbanOutstream : Vban {
    # Constructor
    VbanOutstream ([int]$index) : base ($index) {
        $this.direction = "out"
    }
}


function Make_Vban ([Object]$remote) {
    [System.Collections.ArrayList]$instream = @()
    [System.Collections.ArrayList]$outstream = @()

    0..$($remote.kind.vban_in - 1) | ForEach-Object {
        [void]$instream.Add([VbanInstream]::new($_))
    }
    0..$($remote.kind.vban_out - 1) | ForEach-Object {
        [void]$outstream.Add([VbanOutstream]::new($_))
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
