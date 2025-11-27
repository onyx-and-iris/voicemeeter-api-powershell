class Bus : IRemote {
    [Object]$mode
    [Object]$eq
    [Object]$levels

    Bus ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('mono', 'mute')
        AddStringMembers -PARAMS @('label')
        AddFloatMembers -PARAMS @('gain', 'returnreverb', 'returndelay', 'returnfx1', 'returnfx2')

        $this.mode = [BusMode]::new($index, $remote)
        $this.eq = [BusEq]::new($index, $remote)
        $this.levels = [BusLevels]::new($index, $remote)
    }

    [string] identifier () {
        return 'Bus[' + $this.index + ']'
    }

    [void] FadeTo ([single]$target, [int]$time) {
        $this.Setter('FadeTo', "($target, $time)")
    }

    [void] FadeBy ([single]$target, [int]$time) {
        $this.Setter('FadeBy', "($target, $time)")
    }
}

class BusLevels : IRemote {
    [int]$init
    [int]$offset

    BusLevels ([int]$index, [Object]$remote) : base ($index, $remote) {
        $this.init = $index * 8
        $this.offset = 8            
    }

    [float] Convert([float]$val) {
        if ($val -gt 0) { 
            return [math]::Round(20 * [math]::Log10($val), 1) 
        } 
        else { 
            return - 200.0 
        }
    }

    [System.Collections.ArrayList] Getter([int]$mode) {
        [System.Collections.ArrayList]$vals = @()
        $this.init..$($this.init + $this.offset - 1) | ForEach-Object {
            $vals.Add($this.Convert($(Get_Level -MODE $mode -INDEX $_)))
        }
        return $vals
    }

    [System.Collections.ArrayList] All() {
        return $this.Getter(3)
    }
}

class BusMode : IRemote {
    [System.Collections.ArrayList]$modes

    BusMode ([int]$index, [Object]$remote) : base ($index, $remote) {
        $this.modes = @(
            'normal', 'amix', 'bmix', 'repeat', 'composite', 'tvmix', 'upmix21', 'upmix41', 'upmix61', 
            'centeronly', 'lfeonly', 'rearonly'
        )

        AddBoolMembers -PARAMS $this.modes
    }

    [string] identifier () {
        return 'Bus[' + $this.index + '].mode'
    }

    [string] Get () {
        foreach ($mode in $this.modes) {
            if ($this.$mode) {
                break
            }
        }
        return $mode
    }
}

class BusEq : IRemote {
    BusEq ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('on', 'ab')
    }

    [string] identifier () {
        return 'Bus[' + $this.index + '].EQ'
    }
}

class PhysicalBus : Bus {
    [Object]$device

    PhysicalBus ([int]$index, [Object]$remote) : base ($index, $remote) {
        $this.device = [BusDevice]::new($index, $remote)
    }
}

class VirtualBus : Bus {
    [Object]$device
    
    VirtualBus ([int]$index, [Object]$remote) : base ($index, $remote) {
        if ($this.remote.kind.name -eq 'basic') {
            $this.device = [BusDevice]::new($index, $remote)
        }
    }
}

class BusDevice : Device {
    BusDevice ([int]$index, [Object]$remote) : base ($index, $remote) {
        if ($this.index -eq 0) {
            $this.AddASIO()
        }
    }

    [string] identifier () {
        return 'Bus[' + $this.index + '].Device'
    }

    hidden [void] AddASIO () {
        Add-Member -InputObject $this -MemberType ScriptProperty -Name 'asio' `
            -Value {
            return Write-Warning ("ERROR: $($this.identifier()).asio is write only")
        } -SecondValue {
            param($arg)
            return $this.Setter('asio', $arg)
        } -Force
    }
}

function Make_Buses ([Object]$remote) {
    [System.Collections.ArrayList]$bus = @()
    0..$($remote.kind.p_out + $remote.kind.v_out - 1) | ForEach-Object {
        if ($_ -lt $remote.kind.p_out) { [void]$bus.Add([PhysicalBus]::new($_, $remote)) }
        else { [void]$bus.Add([VirtualBus]::new($_, $remote)) }
    }
    $bus
}
