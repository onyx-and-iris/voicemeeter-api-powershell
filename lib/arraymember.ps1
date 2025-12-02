class ArrayMember : IRemote {
    [string]$prefix
    [Object]$parent
    
    ArrayMember (
        [int]$index, [string]$prefix, [Object]$parent
    ) : base ($index, $parent.remote) {
        $this.prefix = $prefix
        $this.parent = $parent
    }
    
    [string] identifier () {
        $parentId = $this.parent.identifier()
        return "{0}.{1}[{2}]" -f $parentId, $this.prefix, $this.index
    }
    
    [void] Set ($val) {
        $this.Setter('', $val)
    }
}

class BoolArrayMember : ArrayMember {
    BoolArrayMember (
        [int]$index, [string]$prefix, [Object]$parent
    ) : base ($index, $prefix, $parent) {}
    
    [bool] Get () {
        return $this.Getter('')
    }
}

class IntArrayMember : ArrayMember {
    IntArrayMember (
        [int]$index, [string]$prefix, [Object]$parent
    ) : base ($index, $prefix, $parent) {}
    
    [int] Get () {
        return $this.Getter('')
    }
}

class FloatArrayMember : ArrayMember {
    [int]$decimals
    
    FloatArrayMember (
        [int]$index, [string]$prefix, [Object]$parent, [int]$decimals = 1
    ) : base ($index, $prefix, $parent) {
        $this.decimals = $decimals
    }
    
    [double] Get () {
        return [math]::Round($this.Getter(''), $this.decimals)
    }
}

class StringArrayMember : ArrayMember {
    StringArrayMember (
        [int]$index, [string]$prefix, [Object]$parent
    ) : base ($index, $prefix, $parent) {}
    
    [string] Get () {
        return $this.Getter_String('')
    }
}