. $PSScriptRoot\meta.ps1

class Bus {
    [Int]$id
    [Array]$bool_params
    [Array]$float_params

    # Constructor
    Bus ([Int]$id)
    {
        $this.id = $id
        $this.bool_params = @('mono', 'mute')
        $this.float_params = @('gain')
        AddPublicMembers($this)
    }

    [void] Setter($cmd, $set) {
        Param_Set -PARAM $cmd -VALUE $set
    }

    [Single] Getter($cmd) {
        return Param_Get -PARAM $cmd
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

Function Buses {
    [System.Collections.ArrayList]$bus = @()
    0..$($layout.p_out + $layout.v_out -1) | ForEach-Object {
        if ($_ -lt $layout.p_out) { [void]$bus.Add([PhysicalBus]::new($_)) }
        else { [void]$bus.Add([VirtualBus]::new($_)) }
    }
    $bus
}
