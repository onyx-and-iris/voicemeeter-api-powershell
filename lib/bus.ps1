. $PSScriptRoot\meta.ps1

class Bus {
    [Int]$id

    # Constructor
    Bus ([Int]$id)
    {
        $this.id = $id

        AddBoolMembers -PARAMS @('mono', 'mute')
        AddFloatMembers -PARAMS @('gain')
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
            $this.Getter($this.cmd('EQ.on'))
        }`
        {
            param ( $arg )
            $this._eq = $this.Setter($this.cmd('EQ.on'), $arg)
        }
    )
}

class PhysicalBus : Bus {
    PhysicalBus ([Int]$id) : base ($id) {
    }
}

class VirtualBus : Bus {
    VirtualBus ([Int]$id) : base ($id) {
    }
}

Function Make_Buses {
    [System.Collections.ArrayList]$bus = @()
    0..$($layout.p_out + $layout.v_out -1) | ForEach-Object {
        if ($_ -lt $layout.p_out) { [void]$bus.Add([PhysicalBus]::new($_)) }
        else { [void]$bus.Add([VirtualBus]::new($_)) }
    }
    $bus
}
