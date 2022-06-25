. $PSScriptRoot\meta.ps1

class Bus {
    [Int]$id
    [Object]$remote

    # Constructor
    Bus ([Int]$id, [Object]$remote) {
        $this.id = $id
        $this.remote = $remote

        AddBoolMembers -PARAMS @('mono', 'mute')
        AddStringMembers -PARAMS @('label')
        AddFloatMembers -PARAMS @('gain')

        AddBusModeMembers -PARAMS @('normal', 'amix', 'bmix', 'repeat', 'composite', 'tvmix', 'upmix21',
            'upmix41', 'upmix61', 'centeronly', 'lfeonly', 'rearonly')
    }

    [Single] Getter($cmd) {
        return Param_Get -PARAM $cmd -IS_STRING $false
    }

    [String] Getter_String($cmd) {
        return Param_Get -PARAM $cmd -IS_STRING $true
    }

    [void] Setter($cmd, $set) {
        Param_Set -PARAM $cmd -VALUE $set
    }

    [string] cmd ($arg) {
        return "Bus[" + $this.id + "].$arg"
    }

    hidden $_eq = $($this | Add-Member ScriptProperty 'eq' `
        {
            [bool]$this.Getter($this.cmd('EQ.on'))
        }`
        {
            param ( $arg )
            $this._eq = $this.Setter($this.cmd('EQ.on'), $arg)
        }
    )

    hidden $_eq_ab = $($this | Add-Member ScriptProperty 'eq_ab' `
        {
            [bool]$this.Getter($this.cmd('eq.ab'))
        }`
        {
            param ( $arg )
            $this._eq = $this.Setter($this.cmd('eq.ab'), $arg)
        }
    )

    [void] FadeTo([Single]$target, [int]$time) {
        $this.Setter($this.cmd('FadeTo'), "($target, $time)")
    }

    [void] FadeBy([Single]$target, [int]$time) {
        $this.Setter($this.cmd('FadeBy'), "($target, $time)")
    }
}

class PhysicalBus : Bus {
    PhysicalBus ([Int]$id, [Object]$remote) : base ($id, $remote) {
    }
    hidden $_device = $($this | Add-Member ScriptProperty 'device' `
        {
            $this.Getter_String($this.cmd('device.name'))
        }`
        {
            return Write-Warning("ERROR: " + $this.cmd('device.name') + " is read only")
        }
    )

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            $this.Getter($this.cmd('device.sr'))
        }`
        {
            return Write-Warning("ERROR: " + $this.cmd('device.sr') + " is read only")
        }
    )
}

class VirtualBus : Bus {
    VirtualBus ([Int]$id, [Object]$remote) : base ($id, $remote) {
    }
}

Function Make_Buses([Object]$remote) {
    [System.Collections.ArrayList]$bus = @()
    0..$($remote.kind.p_out + $remote.kind.v_out - 1) | ForEach-Object {
        if ($_ -lt $remote.kind.p_out) { [void]$bus.Add([PhysicalBus]::new($_, $remote)) }
        else { [void]$bus.Add([VirtualBus]::new($_, $remote)) }
    }
    $bus
}
