class Strip {
    [int32]$id

    # Constructor
    Strip ([Int]$id)
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
        return "Strip[" + $this.id + "].$arg"
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

    hidden $_solo = $($this | Add-Member ScriptProperty 'solo' `
        {
            # get
            $this.Getter($this.cmd('Solo'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._solo = $this.Setter($this.cmd('Solo'), $arg)
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

    hidden $_A1 = $($this | Add-Member ScriptProperty 'A1' `
        {
            # get
            $this.Getter($this.cmd('A1'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._A1 = $this.Setter($this.cmd('A1'), $arg)
        }
    )

    hidden $_A2 = $($this | Add-Member ScriptProperty 'A2' `
        {
            # get
            $this.Getter($this.cmd('A2'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._A2 = $this.Setter($this.cmd('A2'), $arg)
        }
    )

    hidden $_A3 = $($this | Add-Member ScriptProperty 'A3' `
        {
            # get
            $this.Getter($this.cmd('A3'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._A3 = $this.Setter($this.cmd('A3'), $arg)
        }
    )

    hidden $_A4 = $($this | Add-Member ScriptProperty 'A4' `
        {
            # get
            $this.Getter($this.cmd('A4'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._A4 = $this.Setter($this.cmd('A4'), $arg)
        }
    )

    hidden $_A5 = $($this | Add-Member ScriptProperty 'A5' `
        {
            # get
            $this.Getter($this.cmd('A5'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._A5 = $this.Setter($this.cmd('A5'), $arg)
        }
    )

    hidden $_B1 = $($this | Add-Member ScriptProperty 'B1' `
        {
            # get
            $this.Getter($this.cmd('B1'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._B1 = $this.Setter($this.cmd('B1'), $arg)
        }
    )

    hidden $_B2 = $($this | Add-Member ScriptProperty 'B2' `
        {
            # get
            $this.Getter($this.cmd('B2'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._B2 = $this.Setter($this.cmd('B2'), $arg)
        }
    )

    hidden $_B3 = $($this | Add-Member ScriptProperty 'B3' `
        {
            # get
            $this.Getter($this.cmd('B3'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._B3 = $this.Setter($this.cmd('B3'), $arg)
        }
    )

    hidden $_gain = $($this | Add-Member ScriptProperty 'gain' `
        {
            # get
            $this.Getter($this.cmd('gain'))
        }`
        {
            # set
            param ( [Single]$arg )
            $this._gain = $this.Setter($this.cmd('gain'), $arg)
        }
    )
}

Function Strips {
    [System.Collections.ArrayList]$strip = @()
    0..$($layout.Strip-1) | ForEach-Object {
        [void]$strip.Add([Strip]::new($_))
    }
    $strip
}

if ($MyInvocation.InvocationName -ne '.')
{
    . .\voicemeeter.ps1

    $vmr = [Remote]::new('potato')

    $vmr.Login()

    $vmr.strip[1].A1 = 1
    $vmr.strip[1].A1
    $vmr.strip[2].A2 = 0
    $vmr.strip[2].A2


    $vmr.strip[1].gain = 3.2
    $vmr.strip[1].gain
    $vmr.strip[2].gain = -2.0
    $vmr.strip[2].gain

    $vmr.Logout()
}
