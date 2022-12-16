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
    [Object]$eq

    # Constructor
    Bus ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('mono', 'mute')
        AddStringMembers -PARAMS @('label')
        AddFloatMembers -PARAMS @('gain', 'returnreverb', 'returndelay', 'returnfx1', 'returnfx2')

        AddBusModeMembers -PARAMS @('normal', 'amix', 'bmix', 'repeat', 'composite', 'tvmix', 'upmix21')
        AddBusModeMembers -PARAMS @('upmix41', 'upmix61', 'centeronly', 'lfeonly', 'rearonly')

        $this.eq = [Eq]::new($index, $remote)
    }

    [void] FadeTo ([single]$target, [int]$time) {
        $this.Setter('FadeTo', "($target, $time)")
    }

    [void] FadeBy ([single]$target, [int]$time) {
        $this.Setter('FadeBy', "($target, $time)")
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
