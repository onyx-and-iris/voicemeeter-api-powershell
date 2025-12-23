class IOControl : IRemote {
    IOControl ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddBoolMembers -PARAMS @('mute')
        AddFloatMembers -PARAMS @('gain')
        AddStringMembers -PARAMS @('label')
    }

    [void] FadeTo ([single]$target, [int]$time) {
        $this.Setter('FadeTo', "($target, $time)")
    }

    [void] FadeBy ([single]$target, [int]$time) {
        $this.Setter('FadeBy', "($target, $time)")
    }
}

class IOLevels : IRemote {
    IOLevels ([int]$index, [Object]$remote) : base ($index, $remote) {
    }

    hidden [single] Convert([single]$val) {
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
}

class IOEq : IRemote {
    [System.Collections.ArrayList]$channel
    [string]$kindOfEq
    
    IOEq ([int]$index, [Object]$remote, [string]$kindOfEq) : base ($index, $remote) {
        $this.kindOfEq = $kindOfEq

        AddBoolMembers -PARAMS @('on', 'ab')

        $this.channel = @()
        for ($ch = 0; $ch -lt $remote.kind.eq_ch[$this.kindOfEq]; $ch++) {
            $this.channel.Add([EqChannel]::new($ch, $this))
        }
    }

    [void] Load ([string]$filename) {
        $param = 'Command.Load{0}Eq[{1}]' -f $this.kindOfEq, $this.index
        $this.remote.Setter($param, $filename)
    }

    [void] Save ([string]$filename) {
        $param = 'Command.Save{0}Eq[{1}]' -f $this.kindOfEq, $this.index
        $this.remote.Setter($param, $filename)
    }
}

class EqChannel : IRemote {
    [System.Collections.ArrayList]$cell
    [Object]$eq
    
    EqChannel ([int]$index, [Object]$eq) : base ($index, $eq.remote) {
        $this.eq = $eq

        if ($eq.kindOfEq -eq 'Bus') { AddFloatMembers -PARAMS @('trim', 'delay') }

        $this.cell = @()
        $cellCount = $this.remote.kind.cells
        for ($c = 0; $c -lt $cellCount; $c++) {
            $this.cell.Add([EqCell]::new($c, $this))
        }
    }

    [string] identifier () {
        return '{0}.Channel[{1}]' -f $this.eq.identifier(), $this.index
    }
}

class EqCell : IRemote {
    [Object]$channel
    
    EqCell ([int]$index, [Object]$channel) : base ($index, $channel.remote) {
        $this.channel = $channel

        AddBoolMembers -PARAMS @('on')
        AddIntMembers -PARAMS @('type')
        AddFloatMembers -PARAMS @('f', 'gain', 'q')
    }

    [string] identifier () {
        return '{0}.Cell[{1}]' -f $this.channel.identifier(), $this.index
    }
}

class IODevice : IRemote {
    IODevice ([int]$index, [Object]$remote) : base ($index, $remote) {
        AddStringMembers -WriteOnly -PARAMS @('wdm', 'ks', 'mme')
        AddStringMembers -ReadOnly -PARAMS @('name')
        AddIntMembers -ReadOnly -PARAMS @('sr')
    }
}