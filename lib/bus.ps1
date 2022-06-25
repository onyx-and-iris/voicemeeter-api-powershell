. $PSScriptRoot\meta.ps1

class Bus {
    [Int]$id

    # Constructor
    Bus ([Int]$id) {
        $this.id = $id

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
}

class PhysicalBus : Bus {
    PhysicalBus ([Int]$id) : base ($id) {
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
    VirtualBus ([Int]$id) : base ($id) {
    }
}

Function Make_Buses {
    [System.Collections.ArrayList]$bus = @()
    0..$($layout.p_out + $layout.v_out - 1) | ForEach-Object {
        if ($_ -lt $layout.p_out) { [void]$bus.Add([PhysicalBus]::new($_)) }
        else { [void]$bus.Add([VirtualBus]::new($_)) }
    }
    $bus
}
