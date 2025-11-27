class Eq : IRemote {
    [System.Collections.ArrayList]$channel
    [string]$prefix
    
    Eq ([string]$prefix, [int]$chCount, [Object]$parent) : base ($parent.index, $parent.remote) {
        AddBoolMembers -PARAMS @('on', 'ab')

        $this.channel = @()
        for ($ch = 0; $ch -lt $chCount; $ch++) {
            $this.channel.Add([EqChannel]::new($ch, $this))
        }

        $this.prefix = $prefix
    }

    [void] Load ([string]$filename) {
        $param = 'Command.Load{0}Eq[{1}]' -f $this.prefix, $this.index
        $this.remote.Setter($param, $filename)
    }

    [void] Save ([string]$filename) {
        $param = 'Command.Save{0}Eq[{1}]' -f $this.prefix, $this.index
        $this.remote.Setter($param, $filename)
    }
}

class EqChannel : IRemote {
    [System.Collections.ArrayList]$cell
    [string]$eqId
    
    EqChannel ([int]$index, [Object]$eq) : base ($index, $eq.remote) {
        $this.eqId = $eq.identifier()

        $this.cell = @()
        $cellCount = $this.remote.kind.cells
        for ($c = 0; $c -lt $cellCount; $c++) {
            $this.cell.Add([EqCell]::new($c, $this))
        }
    }

    [string] identifier () {
        return '{0}.Channel[{1}]' -f $this.eqId, $this.index
    }
}

class EqCell : IRemote {
    [string]$channelId
    
    EqCell ([int]$index, [Object]$channel) : base ($index, $channel.remote) {
        $this.channelId = $channel.identifier()

        AddBoolMembers -PARAMS @('on')
        AddIntMembers -PARAMS @('type')
        AddFloatMembers -PARAMS @('f', 'gain', 'q')
    }

    [string] identifier () {
        return '{0}.Cell[{1}]' -f $this.channelId, $this.index
    }
}