class Preset {
    [int]$index
    [Object]$remote

    Preset ([int]$index, [Object]$remote) {
        $this.index  = $index
        $this.remote = $remote
    }

    [string] ToString() {
        return $this.GetType().Name + $this.index
    }
    
    hidden $_recall = $($this | Add-Member ScriptProperty 'recall' `
        {
            $param = "Command.Preset[$($this.index)].Recall"
            $this.remote.Setter($param, 1)
        } `
        {}
    )
}

class IFx {
    [Object]$remote

    IFx ([Object]$remote) {
        $this.remote = $remote
    }

    [single] Getter ($param) {
        $this.Cmd($param) | Write-Debug
        return $this.remote.Getter($this.Cmd($param))
    }

    [void] Setter ($param, $val) {
        "$($this.Cmd($param))=$val" | Write-Debug
        if ($val -is [Boolean]) {
            $this.remote.Setter($this.Cmd($param), $(if ($val) { 1 } else { 0 }))
        }
        else {
            $this.remote.Setter($this.Cmd($param), $val)
        }
    }

    [string] Cmd ($param) {
        if ([string]::IsNullOrEmpty($param)) {
            return $this.identifier()
        }
        return "$($this.identifier()).$param"
    }
}

class Fx : IFx {
    [Object]$remote
    [Object]$reverb
    [Object]$delay
    
    Fx ([Object]$remote) {
        $this.remote = $remote
        $this.reverb = [FxReverb]::new($remote)
        $this.delay = [FxDelay]::new($remote)
    }
    
    [string] identifier () {
        return 'Fx'
    }
    
    [string] ToString() {
        return $this.GetType().Name
    }
}

class FxReverb : IFx {
    FxReverb ([Object]$remote : base ($remote)) {
        AddBoolMembers -PARAMS @('on', 'ab')
    }
    
    [string] identifier () {
        return 'Fx.Reverb'
    }
}

class FxDelay : IFx {
    FxDelay ([Object]$remote : base ($remote)) {
        AddBoolMembers -PARAMS @('on', 'ab')
    }
    
    [string] identifier () {
        return 'Fx.Delay'
    }
}

class Patch {
    [Object]$remote
    
    Patch ([Object]$remote) {
        AddBoolMembers -PARAMS @('postFaderComposite', 'postFxInsert')
        
        AddASIOInMembers
        AddASIOOutMembers
        AddCompositeMembers
        AddInsertMembers
        
        $this.remote = $remote
    }
    
    [string] identifier () {
        return 'Patch'
    }
    
    [string] ToString() {
        return $this.GetType().Name
    }
    
    [single] Getter ($param) {
        $this.Cmd($param) | Write-Debug
        return $this.remote.Getter($this.Cmd($param))
    }

    [void] Setter ($param, $val) {
        "$($this.Cmd($param))=$val" | Write-Debug
        if ($val -is [Boolean]) {
            $this.remote.Setter($this.Cmd($param), $(if ($val) { 1 } else { 0 }))
        }
        else {
            $this.remote.Setter($this.Cmd($param), $val)
        }
    }

    [string] Cmd ($param) {
        if ([string]::IsNullOrEmpty($param)) {
            return $this.identifier()
        }
        return "$($this.identifier()).$param"
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