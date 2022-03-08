. $PSScriptRoot\meta.ps1

class Strip {
    [Int]$id

    Strip ([Int]$id)
    {
        $this.id = $id

        AddBoolMembers -PARAMS @('mono', 'solo', 'mute')
        AddIntMembers -PARAMS @('limit')
        AddFloatMembers -PARAMS @('gain')
        AddStringMembers -PARAMS @('label')

        AddChannelMembers
        AddGainlayerMembers
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

    [String] cmd ($arg) {
        return "Strip[" + $this.id + "].$arg"
    }
}

class PhysicalStrip : Strip {
    PhysicalStrip ([Int]$id) : base ($id) {
        AddFloatMembers -PARAMS @('comp', 'gate')
    }
    
    hidden $_device = $($this | Add-Member ScriptProperty 'device' `
        {
            $this.Getter_String($this.cmd('device.name'))
        }`
        {
            return Write-Warning("ERROR: " + $this.cmd('device.name') +  " is read only")
        }
    )

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            $this.Getter($this.cmd('device.sr'))
        }`
        {
            return Write-Warning("ERROR: " + $this.cmd('device.sr') +  " is read only")
        }
    )
}

class VirtualStrip : Strip {
    VirtualStrip ([Int]$id) : base ($id) {
        AddBoolMembers -PARAMS @('mc')
        AddIntMembers -PARAMS @('k')
    }
}


Function Make_Strips {
    [System.Collections.ArrayList]$strip = @()
    0..$($layout.p_in + $layout.v_in - 1) | ForEach-Object {
        if ($_ -lt $layout.p_in) { 
            [void]$strip.Add([PhysicalStrip]::new($_)) 
        }
        else { [void]$strip.Add([VirtualStrip]::new($_)) }
    }
    $strip
}
