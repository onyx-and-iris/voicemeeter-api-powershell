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
            $this.Getter($this.cmd('gain'))
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

if ($MyInvocation.InvocationName -ne '.')
{
    . .\voicemeeter.ps1
    try {
        $vmr = [Remote]::new('potato')

        $vmr.bus[0].mono = $true
        $vmr.bus[0].mono
        $vmr.bus[0].mono = $false
        $vmr.bus[0].mono

        $vmr.bus[1].gain = 3.2
        $vmr.bus[1].gain
        $vmr.bus[2].gain = -2.0
        $vmr.bus[2].gain
    }
    finally { $vmr.Logout() }
}
