class Bus {
    [int32]$id

    # Constructor
    Bus ([Int]$id)
    {
        $this.id = $id
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

    hidden $_mono = $($this | Add-Member ScriptProperty 'mono' `
        {
            $this.Getter($this.cmd('Mono'))
        }`
        {
            param ( [Single]$arg )
            $this._mono = $this.Setter($this.cmd('Mono'), $arg)
        }
    )

    hidden $_mute = $($this | Add-Member ScriptProperty 'mute' `
        {
            $this.Getter($this.cmd('Mute'))
        }`
        {
            param ( [Single]$arg )
            $this._mute = $this.Setter($this.cmd('Mute'), $arg)
        }
    )

    hidden $_gain = $($this | Add-Member ScriptProperty 'gain' `
        {
            [math]::Round($this.Getter($this.cmd('gain')), 1)
        }`
        {
            param ( [Single]$arg )
            $this._gain = $this.Setter($this.cmd('gain'), $arg)
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
