. $PSScriptRoot\meta.ps1

class IBus {
    [int]$index
    [Object]$remote
    
    IBus ([int]$index, [Object]$remote) {
        $this.index = $index
        $this.remote = $remote
    }

    [string] identifier () {
        return "Bus[" + $this.index + "]"
    }

    [string] ToString() {
        return $this.GetType().Name + $this.index
    }

    [single] Getter ($param) {
        return Param_Get -PARAM "$($this.identifier()).$param" -IS_STRING $false
    }

    [string] Getter_String ($param) {
        return Param_Get -PARAM "$($this.identifier()).$param" -IS_STRING $true
    }

    [void] Setter ($param, $set) {
        Param_Set -PARAM "$($this.identifier()).$param" -Value $set
    }
}

class Bus : IBus {
    [Object]$mode
    [Object]$eq
    [Object]$levels

    Bus ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('mono', 'mute')
        AddStringMembers -PARAMS @('label')
        AddFloatMembers -PARAMS @('gain', 'returnreverb', 'returndelay', 'returnfx1', 'returnfx2')

        $this.mode = [Mode]::new($index, $remote)
        $this.eq = [Eq]::new($index, $remote)
        $this.levels = [Levels]::new($index, $remote)
    }

    [void] FadeTo ([single]$target, [int]$time) {
        $this.Setter('FadeTo', "($target, $time)")
    }

    [void] FadeBy ([single]$target, [int]$time) {
        $this.Setter('FadeBy', "($target, $time)")
    }
}

class Levels : IBus {
    [int]$init
    [int]$offset

    Levels ([int]$index, [Object]$remote) : base ($index, $remote) {
        $this.init = $index * 8
        $this.offset = 8            
    }

    [float] Convert([float]$val) {
        if ($val -gt 0) { 
            return [math]::Round(20 * [math]::Log10($val), 1) 
        } 
        else { 
            return -200.0 
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

class Mode : IBus {
    [System.Collections.ArrayList]$modes

    Mode ([int]$index, [Object]$remote) : base ($index, $remote) {
        $this.modes = @(
            'normal', 'amix', 'bmix', 'repeat', 'composite', 'tvmix', 'upmix21', 'upmix41', 'upmix61', 
            'centeronly', 'lfeonly', 'rearonly'
        )

        AddBoolMembers -PARAMS $this.modes
    }

    [string] identifier () {
        return "Bus[" + $this.index + "].mode"
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

class Eq : IBus {
    Eq ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('on', 'ab')
    }

    [string] identifier () {
        return "Bus[" + $this.index + "].EQ"
    }
}

class PhysicalBus : Bus {
    [Object]$device

    PhysicalBus ([int]$index, [Object]$remote) : base ($index, $remote) {
        $this.device = [Device]::new($index, $remote)
    }
}

class Device : IBus {
    Device ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return "Bus[" + $this.index + "].Device"
    }

    hidden $_name = $($this | Add-Member ScriptProperty 'name' `
        {
            $this.Getter_String('name')
        } `
        {
            return Write-Warning ("ERROR: $($this.identifier()).name is read only")
        }
    )

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            $this.Getter('sr')
        } `
        {
            return Write-Warning ("ERROR: $($this.identifier()).sr is read only")
        }
    )

    hidden $_wdm = $($this | Add-Member ScriptProperty 'wdm' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).wdm is write only")
        } `
        {
            param($arg)
            return $this.Setter('wdm', $arg)
        }
    )

    hidden $_ks = $($this | Add-Member ScriptProperty 'ks' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).ks is write only")
        } `
        {
            param($arg)
            return $this.Setter('ks', $arg)
        }
    )

    hidden $_mme = $($this | Add-Member ScriptProperty 'mme' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).mme is write only")
        } `
        {
            param($arg)
            return $this.Setter('mme', $arg)
        }
    )

    hidden $_asio = $($this | Add-Member ScriptProperty 'asio' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).asio is write only")
        } `
        {
            param($arg)
            return $this.Setter('asio', $arg)
        }
    )
}

class VirtualBus : Bus {
    VirtualBus ([int]$index, [Object]$remote) : base ($index, $remote) {
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
