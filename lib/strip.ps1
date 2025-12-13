class Strip : IOControl {
    [System.Collections.ArrayList]$gainlayer
    [Object]$levels

    Strip ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('solo')
        AddFloatMembers -PARAMS @('limit', 'pan_x', 'pan_y')

        AddChannelMembers

        $this.levels = [StripLevels]::new($index, $remote)

        $this.gainlayer = @()
        for ($i = 0; $i -lt $remote.kind.gainlayer; $i++) {
            $this.gainlayer.Add([FloatArrayMember]::new($i, 'gainlayer', $this))
        }
    }

    [string] identifier () {
        return 'Strip[' + $this.index + ']'
    }
}

class StripLevels : IOLevels {
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
    [Object]$audibility
    [Object]$pitch

    PhysicalStrip ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('color_x', 'color_y', 'fx_x', 'fx_y')
        AddFloatMembers -PARAMS @('reverb', 'delay', 'fx1', 'fx2')
        AddBoolMembers -PARAMS @('postreverb', 'postdelay', 'postfx1', 'postfx2')
        AddBoolMembers -PARAMS @('mono', 'vaio')

        $this.comp = [StripComp]::new($index, $remote)
        $this.gate = [StripGate]::new($index, $remote)
        $this.denoiser = [StripDenoiser]::new($index, $remote)
        $this.pitch = [StripPitch]::new($index, $remote)
        $this.audibility = [StripAudibility]::new($index, $remote)
        $this.eq = [StripEq]::new($index, $remote)
        $this.device = [StripDevice]::new($index, $remote)
    }
}

class StripKnob : IRemote {
    StripKnob ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    hidden $_knob = $($this | Add-Member ScriptProperty 'knob' `
        {
            [math]::Round($this.Getter(''), 2)
        } `
        {
            param([single]$arg)
            return $this.Setter('', $arg)
        }
    )
}

class StripComp : StripKnob {
    StripComp ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('gainin', 'ratio', 'threshold', 'attack', 'release', 'knee', 'gainout')
        AddBoolMembers -PARAMS @('makeup')
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Comp'
    }
}

class StripGate : StripKnob {
    StripGate ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('threshold', 'damping', 'bpsidechain', 'attack', 'hold', 'release')
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Gate'
    }
}

class StripDenoiser : StripKnob {
    StripDenoiser ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('threshold')
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Denoiser'
    }
}

class StripPitch : IRemote {
    StripPitch ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('on')
        AddFloatMembers -PARAMS @('drywet', 'pitchvalue', 'loformant', 'medformant', 'hiformant')
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Pitch'
    }

    [void] RecallPreset ([int]$presetIndex) {
        $this.Setter('RecallPreset', $presetIndex)
    }
}

class StripAudibility : StripKnob {
    StripAudibility ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Audibility'
    }
}

class StripEq : IOEq {
    StripEq ([int]$index, [Object]$remote) : base ($index, $remote, 'Strip') {
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].EQ'
    }
}

class StripDevice : IODevice {
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
        AddFloatMembers -PARAMS @('eqgain1', 'eqgain2', 'eqgain3')

        AddAliasMembers -MAP @{ 
            mono    = 'mc'
            karaoke = 'k'
            bass    = 'eqgain1'
            low     = 'eqgain1'
            mid     = 'eqgain2'
            med     = 'eqgain2'
            treble  = 'eqgain3'
            high    = 'eqgain3'
        }
    }

    [void] AppGain ([string]$appname, [single]$gain) {
        $this.Setter('AppGain', "(`"$appname`", $gain)")
    }

    [void] AppGain ([int]$appindex, [single]$gain) {
        $this.Setter("App[$appindex].Gain", $gain)
    }

    [void] AppMute ([string]$appname, [bool]$mutestate) {
        $this.Setter('AppMute', "(`"$appname`", $(if ($mutestate) { 1 } else { 0 }))")
    }

    [void] AppMute ([int]$appindex, [bool]$mutestate) {
        $this.Setter("App[$appindex].Mute", $mutestate)
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
