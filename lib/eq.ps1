class Eq : IRemote {
    [System.Collections.ArrayList]$channel
    [string]$parentId
    [string]$prefix
    
    Eq ([string]$prefix, [int]$chCount, [object]$parent) : base ($parent.index, $parent.remote) {
        $this.parentId = $parent.identifier()
        $this.prefix = $prefix
        
        AddBoolMembers -PARAMS @('on', 'ab')
        
        $this.channel = @()
        for ($ch = 0; $ch -lt $chCount; $ch++) {
            $this.channel.Add([EqCh]::new($ch, $this))
        }
    }
    
    [string] identifier () {
        return $this.parentId + '.EQ'
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

class EqCh : IRemote {
    [System.Collections.ArrayList]$cell
    [string]$parentId
    
    EqCh ([int]$index, [object]$parent) : base ($index, $parent.remote) {
        $this.parentId = $parent.identifier()
        
        $this.cell = @()
        $cellCount = $parent.remote.kind.cells
        for ($c = 0; $c -lt $cellCount; $c++) {
            $this.cell.Add([EqChCell]::new($c, $this))
        }
    }
    
    [string] identifier () {
        return '{0}.Channel[{1}]' -f $this.parentId, $this.index
    }
}

class EqChCell : IRemote {
    [string]$parentId
    
    EqChCell ([int]$index, [object]$parent) : base ($index, $parent.remote) {
        $this.parentId = $parent.identifier()
        
        AddBoolMembers -PARAMS @('on')
        AddIntMembers -PARAMS @('type')
        AddFloatMembers -PARAMS @('f', 'gain', 'q')
    }
    
    [string] identifier () {
        return '{0}.Cell[{1}]' -f $this.parentId, $this.index
    }
}