class Option : IRemote {
    [System.Collections.ArrayList]$delay
    [Object]$buffer
    
    Option ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('asiosr', 'monitorOnSel', 'sliderMode')
        
        $this.buffer = [OptionBuffer]::new($remote)
        
        $num_A = $this.remote.kind.p_out
        if ($this.remote.kind.name -eq 'basic') {
            $num_A += $this.remote.kind.v_out
        }
        
        $this.delay = @()
        for ($i = 0; $i -lt $num_A; $i++) {
            $this.delay.Add([FloatArrayMember]::new($i, 'delay', $this))
        }
    }
    
    [string] identifier () {
        return 'Option'
    }
    
    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            [int]$this.Getter('sr')
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

    hidden $_monitoringBus = $($this | Add-Member ScriptProperty 'monitoringBus' `
        {
            foreach ($bus in 0..$($this.remote.kind.p_out + $this.remote.kind.v_out - 1)) {
                if ($this.remote.Getter("Bus[$bus].Monitor")) {
                    break
                }
            }
            return $bus
        } `
        {
            param([int]$arg)
            $busMax = $this.remote.kind.p_out + $this.remote.kind.v_out - 1
            if ($arg -ge 0 -and $arg -le $busMax) {
                $this._monitoringBus = $this.remote.Setter("Bus[$arg].Monitor", $arg)
            }
            else {
                Write-Warning ("Expected a bus index between 0 and $busMax")
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
            [int]$this.Getter('mme')
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
            [int]$this.Getter('wdm')
        } `
        {
            param([int]$arg)
            $opts = @(128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 441, 448, 480, 512, 576, 640, 704, 768, 1024, 1536, 2048)
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
            [int]$this.Getter('ks')
        } `
        {
            param([int]$arg)
            $opts = @(128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 441, 448, 480, 512, 576, 640, 704, 768, 1024, 1536, 2048)
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
            [int]$this.Getter('asio')
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

function Make_Option ([Object]$remote) {
    return [Option]::new($remote)
}