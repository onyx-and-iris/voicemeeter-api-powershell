class Preset : IndexedIRemote {
    Preset ([int]$index, [Object]$remote : base ($index, $remote)) {}

    [string] identifier () {
        return 'Preset[' + $this.index + ']'
    }
    
    hidden $_recall = $($this | Add-Member ScriptProperty 'recall' `
        {
            $param = "Command.Preset[$($this.index)].Recall"
            $this.remote.Setter($param, 1)
        } `
        {}
    )
}

class Fx : IRemote {
    [Object]$reverb
    [Object]$delay
    
    Fx ([Object]$remote : base ($remote)) {
        $this.reverb = [FxReverb]::new($remote)
        $this.delay = [FxDelay]::new($remote)
    }
    
    [string] identifier () {
        return 'Fx'
    }
}

class FxReverb : IRemote {
    FxReverb ([Object]$remote : base ($remote)) {
        AddBoolMembers -PARAMS @('on', 'ab')
    }
    
    [string] identifier () {
        return 'Fx.Reverb'
    }
}

class FxDelay : IRemote {
    FxDelay ([Object]$remote : base ($remote)) {
        AddBoolMembers -PARAMS @('on', 'ab')
    }
    
    [string] identifier () {
        return 'Fx.Delay'
    }
}

class Patch : IRemote {
    Patch ([Object]$remote : base ($remote)) {
        AddBoolMembers -PARAMS @('postFaderComposite', 'postFxInsert')
        
        AddASIOInMembers
        AddASIOOutMembers
        AddCompositeMembers
        AddInsertMembers
    }
    
    [string] identifier () {
        return 'Patch'
    }
}

function Make_Presets ([Object]$remote) {
    [System.Collections.ArrayList]$preset = @()
    0..63 | ForEach-Object {
        [void]$preset.Add([Preset]::new($_, $remote))
    }
    $preset
}

function Make_Fx ([Object]$remote) {
    return [Fx]::new($remote)
}

function Make_Patch ([Object]$remote) {
    return [Patch]::new($remote)
}