. $PSScriptRoot\meta.ps1

class Strip {
    [int]$index
    [Object]$remote

    Strip ([int]$index, [Object]$remote) {
        $this.index = $index
        $this.remote = $remote

        AddBoolMembers -PARAMS @('mono', 'solo', 'mute')
        AddIntMembers -PARAMS @('limit')
        AddFloatMembers -PARAMS @('gain', 'pan_x', 'pan_y')
        AddStringMembers -PARAMS @('label')

        AddChannelMembers
        AddGainlayerMembers
    }

    [string] ToString() {
        return $this.GetType().Name + $this.index
    }

    [single] Getter ($cmd) {
        return Param_Get -PARAM $cmd -IS_STRING $false
    }

    [string] Getter_String ($cmd) {
        return Param_Get -PARAM $cmd -IS_STRING $true
    }

    [void] Setter ($cmd, $val) {
        Param_Set -PARAM $cmd -Value $val
    }

    [string] cmd ($arg) {
        return "Strip[" + $this.index + "].$arg"
    }

    [void] FadeTo ([single]$target, [int]$time) {
        $this.Setter($this.cmd('FadeTo'), "($target, $time)")
    }

    [void] FadeBy ([single]$target, [int]$time) {
        $this.Setter($this.cmd('FadeBy'), "($target, $time)")
    }
}

class PhysicalStrip : Strip {
    PhysicalStrip ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('comp', 'gate', 'color_x', 'color_y', 'fx_x', 'fx_y')
        AddFloatMembers -PARAMS @('reverb', 'delay', 'fx1', 'fx2')
        AddBoolMembers -PARAMS @('postreverb', 'postdelay', 'postfx1', 'postfx2')
    }

    hidden $_device = $($this | Add-Member ScriptProperty 'device' `
        {
            $this.Getter_String($this.cmd('device.name'))
        } `
        {
            return Write-Warning ("ERROR: " + $this.cmd('device.name') + " is read only")
        }
    )

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            $this.Getter($this.cmd('device.sr'))
        } `
        {
            return Write-Warning ("ERROR: " + $this.cmd('device.sr') + " is read only")
        }
    )
}

class VirtualStrip : Strip {
    VirtualStrip ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('mc')
        AddIntMembers -PARAMS @('k')
    }
}


function Make_Strips ([Object]$remote) {
    [System.Collections.ArrayList]$strip = @()
    0..$($remote.kind.p_in + $remote.kind.v_in - 1) | ForEach-Object {
        if ($_ -lt $remote.kind.p_in) {
            [void]$strip.Add([PhysicalStrip]::new($_, $remote))
        }
        else { [void]$strip.Add([VirtualStrip]::new($_, $remote)) }
    }
    $strip
}
