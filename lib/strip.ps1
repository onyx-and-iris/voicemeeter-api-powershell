class Strip : IndexedIRemote {
    [Object]$levels
    [FloatArray]$gainlayer

    Strip ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('solo', 'mute')
        AddFloatMembers -PARAMS @('gain', 'limit', 'pan_x', 'pan_y')
        AddStringMembers -PARAMS @('label')
        
        $this.levels = [StripLevels]::new($index, $remote)

        $parentId = "Strip[$index]"
        $glcount = $remote.kind.gainlayer
        $this.gainlayer = [FloatArray]::new($remote, $parentId, 'gainlayer', $glcount)

        AddGainlayerMembers
        AddChannelMembers
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
    
    hidden [void] AddGainlayerMembers () {
        $glcount = $this.remote.kind.gainlayer
        
        for ($i = 0; $i -lt $glcount; $i++) {
            $propName = "gainlayer$($i)"
            if ($this.PSObject.Properties[$propName]) {
                continue
            }

            $getter = [scriptblock]::Create("`$this.gainlayer[$i]")
            $setter = [scriptblock]::Create("param ( [single]`$value )`n`$this.gainlayer[$i] = `$value")

            $this | Add-Member -MemberType ScriptProperty -Name $propName -Value $getter -SecondValue $setter
        }
    }
}

class StripLevels : IndexedIRemote {
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
    [Object]$pitch
    [Object]$eq
    [Object]$device

    PhysicalStrip ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('color_x', 'color_y', 'fx_x', 'fx_y')
        AddFloatMembers -PARAMS @('audibility', 'reverb', 'delay', 'fx1', 'fx2')
        AddBoolMembers -PARAMS @('postreverb', 'postdelay', 'postfx1', 'postfx2')
        AddBoolMembers -PARAMS @('mono', 'vaio')

        $this.comp = [StripComp]::new($index, $remote)
        $this.gate = [StripGate]::new($index, $remote)
        $this.denoiser = [StripDenoiser]::new($index, $remote)
        $this.pitch = [StripPitch]::new($index, $remote)
        $this.eq = [StripEq]::new($index, $remote)
        $this.device = [StripDevice]::new($index, $remote)
    }
}

class StripComp : IndexedIRemote {
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

class StripGate : IndexedIRemote {
    StripGate ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('threshold', 'damping', 'attack', 'hold', 'release')
        AddIntMembers -PARAMS @('bpsidechain')
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

class StripDenoiser : IndexedIRemote {
    StripDenoiser ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddFloatMembers -PARAMS @('threshold')
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

class StripPitch : IndexedIRemote {
    StripPitch ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('on')
        AddIntMembers -PARAMS @('drywet')
        AddFloatMembers -PARAMS @('pitchvalue', 'loformant', 'medformant', 'hiformant')
    }
    
    [string] identifier () {
        return 'Strip[' + $this.index + '].Pitch'
    }
}

class StripEq : IndexedIRemote {
    [System.Collections.ArrayList]$channels
    
    StripEq ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('on', 'ab')
        
        $this.channels = @()
        $chCount = $remote.kind.strip_ch
        for ($ch = 0; $ch -lt $chCount; $ch++) {
            [void]$this.channels.Add([StripEqCh]::new($index, $ch, $remote))
        } 
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].EQ'
    }
    
    [void] Load ([string]$filename) {
        $param = 'Command.LoadStripEq[' + $this.index + ']'
        $this.remote.Setter($param, $filename)
    }
    
    [void] Save ([string]$filename) {
        $param = 'Command.SaveStripEq[' + $this.index + ']'
        $this.remote.Setter($param, $filename)
    }
}

class StripEqCh : IndexedIRemote {
    [System.Collections.ArrayList]$cells
    [int]$stripIndex
    [int]$chIndex
    
    StripEqCh ([int]$stripIndex, [int]$chIndex, [Object]$remote) : base ($stripIndex, $remote) {
        $this.stripIndex = $stripIndex
        $this.chIndex = $chIndex
        
        $this.cells = @()
        $cellCount = $remote.kind.cells
        for ($c = 0; $c -lt $cellCount; $c++) {
            [void]$this.cells.Add([StripEqChCell]::new($stripIndex, $chIndex, $c, $remote))
        }
    }
    
    [string] identifier () {
        return ('Strip[{0}].EQ.Channel[{1}]' -f $this.stripIndex, $this.chIndex)
    }
}

class StripEqChCell : IndexedIRemote {
    [int]$stripIndex
    [int]$chIndex
    [int]$cellIndex
    
    StripEqChCell ([int]$stripIndex, [int]$chIndex, [int]$cellIndex, [Object]$remote) : base ($stripIndex, $remote) {
        AddBoolMembers -PARAMS @('on')
        AddIntMembers -PARAMS @('type')
        AddFloatMembers -PARAMS @('f', 'gain', 'q')
        
        $this.stripIndex  = $stripIndex
        $this.chIndex   = $chIndex
        $this.cellIndex = $cellIndex
    }
    
    [string] identifier () {
        return ('Strip[{0}].EQ.Channel[{1}].Cell[{2}]' -f $this.stripIndex, $this.chIndex, $this.cellIndex)
    }
}

class StripDevice : IndexedIRemote {
    StripDevice ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    [string] identifier () {
        return 'Strip[' + $this.index + '].Device'
    }

    hidden $_name = $($this | Add-Member ScriptProperty 'name' `
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

    hidden $_wdm = $($this | Add-Member ScriptProperty 'wdm' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).wdm is write only")
        } `
        {
            param($arg)
            return $this.Setter('wdm', $arg)
        }
    )

    hidden $_ks = $($this | Add-Member ScriptProperty 'ks' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).ks is write only")
        } `
        {
            param($arg)
            return $this.Setter('ks', $arg)
        }
    )

    hidden $_mme = $($this | Add-Member ScriptProperty 'mme' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).mme is write only")
        } `
        {
            param($arg)
            return $this.Setter('mme', $arg)
        }
    )

    hidden $_asio = $($this | Add-Member ScriptProperty 'asio' `
        {
            return Write-Warning ("ERROR: $($this.identifier()).asio is write only")
        } `
        {
            param($arg)
            return $this.Setter('asio', $arg)
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
        $this.Setter('AppMute', "(`"$appname`", $(if ($mutestate) { 1 } else { 0 }))")
    }
    
    hidden $_bass = $($this | Add-Member ScriptProperty 'bass' {
            [math]::Round($this.Getter('eqgain1'), 1)
        } {
            param([single]$arg)
            $this.Setter('eqgain1', $arg)
        }
    )

    hidden $_mid = $($this | Add-Member ScriptProperty 'mid' {
            [math]::Round($this.Getter('eqgain2'), 1)
        } {
            param([single]$arg)
            $this.Setter('eqgain2', $arg)
        }
    )

    hidden $_treble = $($this | Add-Member ScriptProperty 'treble' {
            [math]::Round($this.Getter('eqgain3'), 1)
        } {
            param([single]$arg)
            $this.Setter('eqgain3', $arg)
        }
    )
    
    hidden $_aliases = $(
        $this | Add-Member -MemberType AliasProperty -Name 'mono' -Value 'mc'
        $this | Add-Member -MemberType AliasProperty -Name 'karaoke' -Value 'k'
        $this | Add-Member -MemberType AliasProperty -Name 'low'  -Value 'bass'
        $this | Add-Member -MemberType AliasProperty -Name 'med'  -Value 'mid'
        $this | Add-Member -MemberType AliasProperty -Name 'high' -Value 'treble'
    )
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
