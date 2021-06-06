class Vban {
    [int32]$id
    [String]$direction
    [Array]$stringparams

    # Constructor
    Vban ([Int]$id, [String]$direction)
    {
        $this.id = $id
        $this.direction = $direction
        $this.stringparams = @('name', 'ip')
    }

    [void] Setter($cmd, $set) {
        if( $this.stringparams.Contains($cmd.Split('.')[2]) ) { 
            Param_Set_String -PARAM $cmd -VALUE $set 
        }
        else { Param_Set -PARAM $cmd -VALUE $set }
    }

    [Single] Getter($cmd) {
        return Param_Get -PARAM $cmd
    }

    [String] Getter_String($cmd) {
        return Param_Get_String -PARAM $cmd
    }

    [String] cmd ($arg) {
        return "vban." + $this.direction + "stream[" + $this.id + "].$arg"
    }

    hidden $_on = $($this | Add-Member ScriptProperty 'on' `
        {
            $this.Getter($this.cmd('on'))
        }`
        {
            param ( [Bool]$arg )
            $this._on = $this.Setter($this.cmd('on'), $arg)
        }
    )

    hidden $_name = $($this | Add-Member ScriptProperty 'name' `
        {
            $this.Getter_String($this.cmd('name'))
        }`
        {
            param ( [String]$arg )
            $this._name = $this.Setter($this.cmd('name'), $arg)
        }
    )

    hidden $_ip = $($this | Add-Member ScriptProperty 'ip' `
        {
            $this.Getter_String($this.cmd('ip'))
        }`
        {
            param ( [String]$arg )
            $this._ip = $this.Setter($this.cmd('ip'), $arg)
        }
    )

    hidden $_port = $($this | Add-Member ScriptProperty 'port' `
        {
            $this.Getter($this.cmd('port'))
        }`
        {
            param ( [String]$arg )
            if($arg -In 1024..65535) {
                $this._port = $this.Setter($this.cmd('port'), $arg)
            }
            else {
                Write-Warning('Expected value from 1024 to 65535')
            }
        }
    )

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            $this.Getter($this.cmd('sr'))
        }`
        {
            param ( [Int]$arg )
            if($this.direction -eq "in") { Write-Warning('Error, read only value') }
            else {
                $opts = @(11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
                if($opts.Contains($arg)) {
                    $this._port = $this.Setter($this.cmd('sr'), $arg)
                }
                else {
                    Write-Warning('Expected one of', $opts)
                }
            }
        }
    )

    hidden $_channel = $($this | Add-Member ScriptProperty 'channel' `
        {
            $this.Getter($this.cmd('channel'))
        }`
        {
            param ( [Int]$arg )
            if($this.direction -eq "in") { Write-Warning('Error, read only value') }
            else {
                if($arg -In 1..8) {
                    $this._channel = $this.Setter($this.cmd('channel'), $arg)
                }
                else {
                    Write-Warning('Expected value from 1 to 8')
                }
            }
        }
    )

    hidden $_bit = $($this | Add-Member ScriptProperty 'bit' `
        {
            $val = if($this.Getter($this.cmd('bit')) -eq 1) {16} else {24}
            return $val
        }`
        {
            param ( [Int]$arg )
            if($this.direction -eq "in") { Write-Warning('Error, read only value') }
            else {
                if(@(16,24).Contains($arg)) {
                    $val = if($arg -eq 16) {1} else {2}
                    $this._bit = $this.Setter($this.cmd('bit'), $val)
                }
                else {
                    Write-Warning('Expected value 16 or 24')
                }
            }
        }
    )

    hidden $_quality = $($this | Add-Member ScriptProperty 'quality' `
        {
            $this.Getter($this.cmd('quality'))
        }`
        {
            param ( [Int]$arg )
            if($this.direction -eq "in") { Write-Warning('Error, read only value') }
            else {
                if($arg -In 0..4) {
                    $this._quality = $this.Setter($this.cmd('quality'), $arg)
                }
                else {
                    Write-Warning('Expected value from 0 to 4')
                }
            }
        }
    )

    hidden $_route = $($this | Add-Member ScriptProperty 'route' `
        {
            $this.Getter($this.cmd('route'))
        }`
        {
            param ( [Int]$arg )
            if($this.direction -eq "in") { Write-Warning('Error, read only value') }
            else {
                if($arg -In 0..8) {
                    $this._route = $this.Setter($this.cmd('route'), $arg)
                }
                else {
                    Write-Warning('Expected value from 0 to 8')
                }
            }
        }
    )
}

Function Vban_In {
    [System.Collections.ArrayList]$vban_in = @()
    0..$($layout.vban_in-1) | ForEach-Object {
        [void]$vban_in.Add([Vban]::new($_, "in"))
    }
    $vban_in
}

Function Vban_Out {
    [System.Collections.ArrayList]$vban_out = @()
    0..$($layout.vban_out-1) | ForEach-Object {
        [void]$vban_out.Add([Vban]::new($_, "out"))
    }
    $vban_out
}