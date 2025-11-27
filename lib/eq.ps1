class Eq : IRemote {
    [System.Collections.ArrayList]$channel
    [string]$prefix
    
    Eq ([int]$index, [Object]$remote, [string]$prefix, [int]$chCount) : base ($index, $remote) {
        $this.prefix = $prefix

        AddBoolMembers -PARAMS @('on', 'ab')

        $this.channel = @()
        for ($ch = 0; $ch -lt $chCount; $ch++) {
            $this.channel.Add([EqChannel]::new($ch, $remote, $this.identifier()))
        }
    }

    [string] identifier () {
        return '{0}[{1}].EQ' -f $this.prefix, $this.index
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
    
    EqChannel ([int]$index, [Object]$remote, [string]$eqId) : base ($index, $remote) {
        $this.eqId = $eqId

        $this.cell = @()
        $cellCount = $this.remote.kind.cells
        for ($c = 0; $c -lt $cellCount; $c++) {
            $this.cell.Add([EqCell]::new($c, $remote, $this.identifier()))
        }
    }

    [string] identifier () {
        return '{0}.Channel[{1}]' -f $this.eqId, $this.index
    }
}

class EqCell : IRemote {
    [string]$channelId
    
    EqCell ([int]$index, [Object]$remote, [string]$channelId) : base ($index, $remote) {
        $this.channelId = $channelId

        AddBoolMembers -PARAMS @('on')
        AddIntMembers -PARAMS @('type')
        AddFloatMembers -PARAMS @('f', 'gain', 'q')
    }

    [string] identifier () {
        return '{0}.Cell[{1}]' -f $this.channelId, $this.index
    }
}