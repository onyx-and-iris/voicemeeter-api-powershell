class Preset : IndexedIRemote {
    Preset ([int]$index, [Object]$remote) : base ($index, $remote) {}

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
    
    Fx ([Object]$remote) : base ($remote) {
        $this.reverb = [FxReverb]::new($remote)
        $this.delay = [FxDelay]::new($remote)
    }
    
    [string] identifier () {
        return 'Fx'
    }
}

class FxReverb : IRemote {
    FxReverb ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('on', 'ab')
    }
    
    [string] identifier () {
        return 'Fx.Reverb'
    }
}

class FxDelay : IRemote {
    FxDelay ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('on', 'ab')
    }
    
    [string] identifier () {
        return 'Fx.Delay'
    }
}

class Patch : IRemote {
    [IntArray]$asio
    [IntArray]$composite
    [BoolArray]$insert
    
    Patch ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('postFaderComposite', 'postFxInsert')
        
        $this.asio = [IntArray]::new($remote, 'Patch', 'asio', $remote.kind.asio_in)
        $this.composite = [IntArray]::new($remote, 'Patch', 'composite', $remote.kind.composite)
        $this.insert = [BoolArray]::new($remote, 'Patch', 'insert', $remote.kind.insert)
        
        AddASIOOutMembers
    }
    
    [string] identifier () {
        return 'Patch'
    }
    
    hidden [void] AddASIOOutMembers () {
        $num_A = $this.remote.kind.p_out
        $asio_out = [int]$this.remote.kind.asio_out
        
        for ($i = 2; $i -le $num_A; $i++) {
            $propName = "OutA$($i)"
            if (-not $this.PSObject.Properties[$propName]) {
                $array = [IntArray]::new($this.remote, 'Patch', $propName, $asio_out)
                # Add as NoteProperty so the same instance is reused
                Add-Member -InputObject $this -MemberType NoteProperty -Name $propName -Value $array
            }
        }
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