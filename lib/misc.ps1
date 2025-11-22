class Preset : IRemote {
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
    [System.Collections.ArrayList]$asio
    [System.Collections.ArrayList]$composite
    [System.Collections.ArrayList]$insert
    
    Patch ([Object]$remote) : base ($remote) {
        AddBoolMembers -PARAMS @('postFaderComposite', 'postFxInsert')
        
        # AddASIOOutMembers
        
        $this.asio = @()
        for ($i = 0; $i -lt $remote.kind.asio_in; $i++) {
            $this.asio.Add([IntArrayMember]::new($i, 'asio', $this))
        }
        
        $this.composite = @()
        for ($i = 0; $i -lt $remote.kind.composite; $i++) {
            $this.composite.Add([IntArrayMember]::new($i, 'composite', $this))
        }
        
        $this.insert = @()
        for ($i = 0; $i -lt $remote.kind.insert; $i++) {
            $this.insert.Add([BoolArrayMember]::new($i, 'insert', $this))
        }
    }
    
    [string] identifier () {
        return 'Patch'
    }
    
    <# hidden [void] AddASIOOutMembers () {
        $num_A     = [int]$this.remote.kind.p_out
        $asio_out  = [int]$this.remote.kind.asio_out
        
        if ($num_A -le 1 -or $asio_out -le 0) { return }
        
        for ($a = 2; $a -le $num_A; $a++) {
            [System.Collections.ArrayList]$members = @()
            for ($i = 0; $i -lt $asio_out; $i++) {
                [void]$members.Add([IndexedIntMember]::new($i, "OutA$a", $this))
            }
            Add-Member -InputObject $this -MemberType NoteProperty -Name "OutA$a" -Value $members -Force
        }
    } #>
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