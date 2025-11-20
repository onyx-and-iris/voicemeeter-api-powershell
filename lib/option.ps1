class Option : IRemote {
    [Object]$buffer
    [Object]$mode
    
    Option ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('asiosr', 'monitorOnSel', 'sliderMode')
        
        AddDelayMembers
        
        $this.buffer = [OptionBuffer]::new($remote)
        $this.mode = [OptionMode]::new($remote)
    }
    
    [string] identifier () {
        return 'Option'
    }
    
    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            $this.Getter('sr')
        } `
        {
            param([int]$arg)
            $opts = @(32000, 44100, 48000, 88200, 96000, 176400, 192000)
                if ($opts.Contains($arg)) {
                    $this._sr = $this.Setter('sr', $arg)
                }
                else {
                    Write-Warning ('Expected one of', $opts)
                }
        }
    )
}

class OptionBuffer : IRemote {
    OptionBuffer ([Object]$remote) : base ($remote) {}
    
    [string] identifier () {
        return 'Option.Buffer'
    }
    
    hidden $_mme = $($this | Add-Member ScriptProperty 'mme' `
        {
            $this.Getter('mme')
        } `
        {
            param([int]$arg)
            $opts = @(441, 480, 512, 576, 640, 704, 768, 896, 1024, 1536, 2048)
                if ($opts.Contains($arg)) {
                    $this._mme = $this.Setter('mme', $arg)
                }
                else {
                    Write-Warning ('Expected one of', $opts)
                }
        }
    )
    
    hidden $_wdm = $($this | Add-Member ScriptProperty 'wdm' `
        {
            $this.Getter('wdm')
        } `
        {
            param([int]$arg)
            $opts = @(128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 441, 448, 480, 512, 576, 640, 704, 768, 896, 1024, 1536, 2048)
            if ($opts.Contains($arg)) {
                $this._wdm = $this.Setter('wdm', $arg)
            }
            else {
                Write-Warning ('Expected one of', $opts)
            }
        }
    )
    
    hidden $_ks = $($this | Add-Member ScriptProperty 'ks' `
        {
            $this.Getter('ks')
        } `
        {
            param([int]$arg)
            $opts = @(128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 441, 448, 480, 512, 576, 640, 704, 768, 896, 1024, 1536, 2048)
            if ($opts.Contains($arg)) {
                $this._ks = $this.Setter('ks', $arg)
            }
            else {
                Write-Warning ('Expected one of', $opts)
            }
        }
    )
    
    hidden $_asio = $($this | Add-Member ScriptProperty 'asio' `
        {
            $this.Getter('asio')
        } `
        {
            param([int]$arg)
            $opts = @(0, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 441, 448, 480, 512, 576, 640, 704, 768, 1024)
            if ($opts.Contains($arg)) {
                $this._asio = $this.Setter('asio', $arg)
            }
            else {
                Write-Warning ('Expected one of', $opts)
            }
        }
    )
}

class OptionMode : IRemote {
    OptionMode ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('exclusif', 'swift')
    }
    
    [string] identifier () {
        return 'Option.Mode'
    }
}

function Make_Option ([Object]$remote) {
    return [Option]::new($remote)
}