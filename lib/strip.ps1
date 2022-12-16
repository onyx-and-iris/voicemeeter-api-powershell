. $PSScriptRoot\meta.ps1

class IStrip {
    [int]$index
    [Object]$remote

    IStrip ([int]$index, [Object]$remote) {
        $this.index = $index
        $this.remote = $remote
    }

    [string] identifier () {
        return "Strip[" + $this.index + "]"
    }

    [single] Getter ($param) {
        return Param_Get -PARAM "$($this.identifier()).$param" -IS_STRING $false
    }

    [string] Getter_String ($param) {
        return Param_Get -PARAM "$($this.identifier()).$param" -IS_STRING $true
    }

    [void] Setter ($param, $val) {
        Param_Set -PARAM "$($this.identifier()).$param" -Value $val
    }
}

class Strip : IStrip {
    Strip ([int]$index, [Object]$remote) : base ($index, $remote) {
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

    [void] FadeTo ([single]$target, [int]$time) {
        $this.Setter('FadeTo', "($target, $time)")
    }

    [void] FadeBy ([single]$target, [int]$time) {
        $this.Setter('FadeBy', "($target, $time)")
    }
}

class PhysicalStrip : Strip {
    [Object]$comp
    [Object]$gate
    [Object]$denoiser
    [Object]$eq
    [Object]$device

    PhysicalStrip ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('color_x', 'color_y', 'fx_x', 'fx_y')
        AddFloatMembers -PARAMS @('reverb', 'delay', 'fx1', 'fx2')
        AddBoolMembers -PARAMS @('postreverb', 'postdelay', 'postfx1', 'postfx2')

        $this.comp = [Comp]::new($index, $remote)
        $this.gate = [Gate]::new($index, $remote)
        $this.denoiser = [Denoiser]::new($index, $remote)
        $this.eq = [Eq]::new($index, $remote)
        $this.device = [Device]::new($index, $remote)
    }
}

class Comp : IStrip {
    Comp ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('gainin', 'ratio', 'threshold', 'attack', 'release', 'knee', 'gainout')
        AddBoolMembers -PARAMS @('makeup')
    }

    [string] identifier () {
        return "Strip[" + $this.index + "].Comp"
    }

    hidden $_knob = $($this | Add-Member ScriptProperty 'knob' `
        {
            $this.Getter_String('')
        } `
        {
            param($arg)
            return $this.Setter('', $arg)
        }
    )
}

class Gate : IStrip {
    Gate ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('threshold', 'damping', 'bpsidechain', 'attack', 'hold', 'release')
    }

    [string] identifier () {
        return "Strip[" + $this.index + "].Gate"
    }

    hidden $_knob = $($this | Add-Member ScriptProperty 'knob' `
        {
            $this.Getter_String('')
        } `
        {
            param($arg)
            return $this.Setter('', $arg)
        }
    )
}

class Denoiser : IStrip {
    Denoiser ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return "Strip[" + $this.index + "].Denoiser"
    }

    hidden $_knob = $($this | Add-Member ScriptProperty 'knob' `
        {
            $this.Getter_String('')
        } `
        {
            param($arg)
            return $this.Setter('', $arg)
        }
    )
}

class Eq : IStrip {
    Eq ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('on', 'ab')
    }

    [string] identifier () {
        return "Strip[" + $this.index + "].EQ"
    }
}

class Device : IStrip {
    Device ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return "Strip[" + $this.index + "].Device"
    }

    hidden $_device = $($this | Add-Member ScriptProperty 'device' `
        {
            $this.Getter_String('name')
        } `
        {
            return Write-Warning ("ERROR: $($this.identifier()).name is read only")
        }
    )

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            $this.Getter('sr')
        } `
        {
            return Write-Warning ("ERROR: $($this.identifier()).sr is read only")
        }
    )
}

class VirtualStrip : Strip {
    VirtualStrip ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('mc')
        AddIntMembers -PARAMS @('k')
    }

    [void] AppGain ([string]$appname, [single]$gain) {
        $this.Setter('AppGain', "(`"$appname`", $gain)")
    }

    [void] AppMute ([string]$appname, [bool]$mutestate) {
        $this.Setter('AppMute', "(`"$appname`", $(if ($mutestate) { 1 } else { 0 })")
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
