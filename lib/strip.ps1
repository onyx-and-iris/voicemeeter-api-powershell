. $PSScriptRoot\meta.ps1

class Strip {
    [Int]$id
    [Object]$remote

    Strip ([Int]$id, [Object]$remote) {
        $this.id = $id
        $this.remote = $remote

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

    [void] Setter($cmd, $val) {
        Param_Set -PARAM $cmd -VALUE $val
    }

    [String] cmd ($arg) {
        return "Strip[" + $this.id + "].$arg"
    }

    [void] FadeTo([Single]$target, [int]$time) {
        $this.Setter($this.cmd('FadeTo'), "($target, $time)")
    }

    [void] FadeBy([Single]$target, [int]$time) {
        $this.Setter($this.cmd('FadeBy'), "($target, $time)")
    }
}

class PhysicalStrip : Strip {
    PhysicalStrip ([Int]$id, [Object]$remote) : base ($id, $remote) {
        AddFloatMembers -PARAMS @('comp', 'gate')
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

class VirtualStrip : Strip {
    VirtualStrip ([Int]$id, [Object]$remote) : base ($id, $remote) {
        AddBoolMembers -PARAMS @('mc')
        AddIntMembers -PARAMS @('k')
    }
}


Function Make_Strips([Object]$remote) {
    [System.Collections.ArrayList]$strip = @()
    0..$($remote.kind.p_in + $remote.kind.v_in - 1) | ForEach-Object {
        if ($_ -lt $remote.kind.p_in) { 
            [void]$strip.Add([PhysicalStrip]::new($_, $remote)) 
        }
        else { [void]$strip.Add([VirtualStrip]::new($_, $remote)) }
    }
    $strip
}
