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

function Make_Fx ([Object]$remote) {
    return [Fx]::new($remote)
}