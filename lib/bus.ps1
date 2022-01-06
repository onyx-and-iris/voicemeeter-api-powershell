. $PSScriptRoot\meta.ps1

class Bus {
    [int32]$id
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

Function Buses {
    [System.Collections.ArrayList]$bus = @()
    0..$($layout.Bus-1) | ForEach-Object {
        [void]$bus.Add([Bus]::new($_))
    }
    $bus
}
