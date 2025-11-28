class Strip : IRemote {
    [Object]$levels

    Strip ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('mono', 'solo', 'mute')
        AddIntMembers -PARAMS @('limit')
        AddFloatMembers -PARAMS @('gain', 'pan_x', 'pan_y')
        AddStringMembers -PARAMS @('label')

        AddChannelMembers
        AddGainlayerMembers

        $this.levels = [StripLevels]::new($index, $remote)
    }

    [string] identifier () {
        return 'Strip[' + $this.index + ']'
    }

    [void] FadeTo ([single]$target, [int]$time) {
        $this.Setter('FadeTo', "($target, $time)")
    }

    [void] FadeBy ([single]$target, [int]$time) {
        $this.Setter('FadeBy', "($target, $time)")
    }
}

class StripLevels : IRemote {
    [int]$init
    [int]$offset

    StripLevels ([int]$index, [Object]$remote) : base ($index, $remote) {
        $p_in = $remote.kind.p_in
        if ($index -lt $p_in) {
            $this.init = $index * 2
            $this.offset = 2            
        }
        else {
            $this.init = ($p_in * 2) + (($index - $p_in) * 8)
            $this.offset = 8
        }
    }

    [float] Convert([float]$val) {
        if ($val -gt 0) { 
            return [math]::Round(20 * [math]::Log10($val), 1) 
        } 
        else { 
            return -200.0 
        }
    }

    [System.Collections.ArrayList] Getter([int]$mode) {
        [System.Collections.ArrayList]$vals = @()
        $this.init..$($this.init + $this.offset - 1) | ForEach-Object {
            $vals.Add($this.Convert($(Get_Level -MODE $mode -INDEX $_)))
        }
        return $vals
    }

    [System.Collections.ArrayList] PreFader() {
        return $this.Getter(0)
    }

    [System.Collections.ArrayList] PostFader() {
        return $this.Getter(1)
    }

    [System.Collections.ArrayList] PostMute() {
        return $this.Getter(2)
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

        $this.comp = [StripComp]::new($index, $remote)
        $this.gate = [StripGate]::new($index, $remote)
        $this.denoiser = [StripDenoiser]::new($index, $remote)
        $this.eq = [StripEq]::new($index, $remote)
        $this.device = [StripDevice]::new($index, $remote)
    }
}

class StripComp : IRemote {
    StripComp ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('gainin', 'ratio', 'threshold', 'attack', 'release', 'knee', 'gainout')
        AddBoolMembers -PARAMS @('makeup')
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Comp'
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

class StripGate : IRemote {
    StripGate ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('threshold', 'damping', 'bpsidechain', 'attack', 'hold', 'release')
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Gate'
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

class StripDenoiser : IRemote {
    StripDenoiser ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Denoiser'
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

class StripEq : Eq {
    StripEq ([int]$index, [Object]$remote) : base ($index, $remote, 'Strip') {
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].EQ'
    }
}

class StripDevice : Device {
    StripDevice ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Device'
    }
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
