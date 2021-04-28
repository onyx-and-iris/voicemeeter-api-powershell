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

    [int] Getter($cmd) {
        return Param_Get -PARAM $cmd
    }

    [string] cmd ($arg) {
        return "Bus[" + $this.id + "].$arg"
    }

    hidden $_mono = $($this | Add-Member ScriptProperty 'mono' `
        {
            # get
            $this.Getter($this.cmd('Mono'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._mono = $this.Setter($this.cmd('Mono'), $arg)
        }
    )

    hidden $_mute = $($this | Add-Member ScriptProperty 'mute' `
        {
            # get
            $this.Getter($this.cmd('Mute'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._mute = $this.Setter($this.cmd('Mute'), $arg)
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

if ($MyInvocation.InvocationName -ne '.')
{
    Login

    $bus = Buses

    $bus[0].mono = 1
    $bus[0].mono
    $bus[0].mono = 0
    $bus[0].mono

    Logout
}
