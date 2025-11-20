# Base for non-indexed nodes (e.g., Recorder, Command, FX container)
class IRemote {
    [Object]$remote

    IRemote ([Object]$remote) {
        $this.remote = $remote
    }

    [single] Getter ($param) {
        $this.ToString() + " Getter: $($this.Cmd($param))" | Write-Debug
        return $this.remote.Getter($this.Cmd($param))
    }

    [string] Getter_String ($param) {
        $this.ToString() + " Getter_String: $($this.Cmd($param))" | Write-Debug
        return $this.remote.Getter_String($this.Cmd($param))
    }

    [void] Setter ($param, $val) {
        $this.ToString() + " Setter: $($this.Cmd($param))=$val" | Write-Debug
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

    # Must be overridden by derived classes
    [string] identifier () {
        throw [System.NotImplementedException]::new("$($this.GetType().Name) must override identifier()")
    }

    [string] ToString() {
        return $this.GetType().Name
    }
}

# Base for indexed nodes (e.g., Strip, Bus, and their indexed children)
class IndexedIRemote : IRemote {
    [int]$index

    IndexedIRemote ([int]$index, [Object]$remote) : base ($remote) {
        $this.index = $index
    }

    # Helper to build common id segments like 'Strip[2]' or 'Bus[0]'
    [string] BaseId ([string]$root) {
        return "$root[$($this.index)]"
    }

    [string] ToString() {
        return $this.GetType().Name + $this.index
    }
}

class ParamArray : IRemote {
    [string]$parentId
    [string]$prefix
    [int]$count
    
    ParamArray (
        [object]$remote, [string]$parentId, [string]$prefix, [int]$count
    ) : base ($remote) {
        $this.parentId = $parentId
        $this.prefix   = $prefix
        $this.count    = $count
    }
    
    [string] identifier () {
        return $this.parentId
    }
    
    hidden [void] ValidateIndex ([int]$index) {
        if ($this.Count -eq 0) {
            throw "ParamArray ($($this.ParentId).$($this.Prefix)) has Count=0 (no elements)."
        }
        if ($index -lt 0 -or $index -ge $this.Count) {
            throw "ParamArray index $index out of range (0..$($this.Count - 1))."
        }
    }
    
    hidden [string] ElementParam ([int]$index) {
        return "{0}[{1}]" -f $this.Prefix, $index
    }

    [string] ToString() {
        return "ParamArray {$($this.ParentId).$($this.Prefix)} Count=$($this.Count)"
    }
}

class BoolArray : ParamArray {
    BoolArray (
        [object]$remote, [string]$parentId, [string]$prefix, [int]$count
    ) : base ($remote, $parentId, $prefix, $count) {}
    
    [bool] get_Item([int]$index) {
        $this.ValidateIndex($index)
        $param = $this.ElementParam($index)
        return [bool]($this.Getter($param))  # Getter returns single/numeric; cast to bool
    }

    [void] set_Item([int]$index, [bool]$value) {
        $this.ValidateIndex($index)
        $param = $this.ElementParam($index)
        $this.Setter($param, $value)         # IRemote.Setter maps bool -> 0/1
    }

    [bool[]] ToArray() {
        $arr = [bool[]]::new($this.Count)
        for ($i = 0; $i -lt $this.Count; $i++) {
            $arr[$i] = $this.get_Item($i)
        }
        return $arr
    }

    [void] SetAll([bool]$state) {
        for ($i = 0; $i -lt $this.Count; $i++) {
            $this.set_Item($i, $state)
        }
    }
}

class IntArray : ParamArray {
    IntArray (
        [object]$remote, [string]$parentId, [string]$prefix, [int]$count
    ) : base ($remote, $parentId, $prefix, $count) {}
    
    [int] get_Item([int]$index) {
        $this.ValidateIndex($index)
        $param = $this.ElementParam($index)
        return [int]($this.Getter($param))
    }

    [void] set_Item([int]$index, [int]$value) {
        $this.ValidateIndex($index)
        $param = $this.ElementParam($index)
        $this.Setter($param, $value)
    }

    [int[]] ToArray() {
        $arr = [int[]]::new($this.Count)
        for ($i = 0; $i -lt $this.Count; $i++) {
            $arr[$i] = $this.get_Item($i)
        }
        return $arr
    }

    [void] SetAll([int]$value) {
        for ($i = 0; $i -lt $this.Count; $i++) {
            $this.set_Item($i, $value)
        }
    }
}

class FloatArray : ParamArray {
    [int]$decimals
    
    FloatArray (
        [object]$remote, [string]$parentId, [string]$prefix, [int]$count, [int]$decimals = 1
    ) : base ($remote, $parentId, $prefix, $count) {
        $this.decimals = $decimals
    }

    [double] get_Item([int]$index) {
        $this.ValidateIndex($index)
        $param = $this.ElementParam($index)
        return [math]::Round($this.Getter($param), $this.decimals)
    }

    [void] set_Item([int]$index, [double]$value) {
        $this.ValidateIndex($index)
        $param = $this.ElementParam($index)
        $this.Setter($param, $value)
    }

    [double[]] ToArray() {
        $arr = [double[]]::new($this.Count)
        for ($i = 0; $i -lt $this.Count; $i++) {
            $arr[$i] = $this.get_Item($i)
        }
        return $arr
    }

    [void] SetAll([double]$value) {
        for ($i = 0; $i -lt $this.Count; $i++) {
            $this.set_Item($i, $value)
        }
    }
}

class StringArray : ParamArray {
    StringArray (
        [object]$remote, [string]$parentId, [string]$prefix, [int]$count
    ) : base ($remote, $parentId, $prefix, $count) {}

    [string] get_Item([int]$index) {
        $this.ValidateIndex($index)
        $param = $this.ElementParam($index)
        return $this.Getter_String($param)
    }

    [void] set_Item([int]$index, [string]$value) {
        $this.ValidateIndex($index)
        $param = $this.ElementParam($index)
        $this.Setter($param, $value)
    }

    [string[]] ToArray() {
        $arr = [string[]]::new($this.Count)
        for ($i = 0; $i -lt $this.Count; $i++) {
            $arr[$i] = $this.get_Item($i)
        }
        return $arr
    }

    [void] SetAll([string]$value) {
        for ($i = 0; $i -lt $this.Count; $i++) {
            $this.set_Item($i, $value)
        }
    }
}

function AddBoolMembers () {
    param(
        [String[]]$PARAMS
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        # Define getter
        $Signatures['Getter'] = "[bool]`$this.Getter('{0}')" -f $param
        # Define setter
        $Signatures['Setter'] = "param ( [Single]`$arg )`n`$this.Setter('{0}', `$arg)" `
            -f $param

        Addmember
    }
}

function AddIntMembers () {
    param(
        [String[]]$PARAMS
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        # Define getter
        $Signatures['Getter'] = "[Int]`$this.Getter('{0}')" -f $param
        # Define setter
        $Signatures['Setter'] = "param ( [Single]`$arg )`n`$this.Setter('{0}', `$arg)" `
            -f $param

        Addmember
    }
}

function AddFloatMembers () {
    param(
        [String[]]$PARAMS
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        # Define getter
        $Signatures['Getter'] = "[math]::Round(`$this.Getter('{0}'), 1)" -f $param
        # Define setter
        $Signatures['Setter'] = "param ( [Single]`$arg )`n`$this.Setter('{0}', `$arg)" `
            -f $param

        Addmember
    }
}

function AddStringMembers () {
    param(
        [String[]]$PARAMS
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        # Define getter
        $Signatures['Getter'] = "[String]`$this.Getter_String('{0}')" -f $param
        # Define setter
        $Signatures['Setter'] = "param ( [String]`$arg )`n`$this.Setter('{0}', `$arg)" `
            -f $param

        Addmember
    }
}

function AddActionMembers () {
    param(
        [String[]]$PARAMS
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        # Define getter
        $Signatures['Getter'] = "`$this.Setter('{0}', `$true)" -f $param
        # Define setter
        $Signatures['Setter'] = ''

        Addmember
    }
}

function AddChannelMembers () {
    $num_A = $this.remote.kind.p_out
    $num_B = $this.remote.kind.v_out

    [System.Collections.ArrayList]$channels = @()
    1..$($num_A + $num_B) | ForEach-Object {
        if ($_ -le $num_A) { $channels.Add('A{0}' -f $_) } else { $channels.Add('B{0}' -f $($_ - $num_A)) }
    }

    AddBoolMembers -PARAMS $channels
}

function Addmember {
    $AddMemberParams = @{
        Name        = $param
        MemberType  = 'ScriptProperty'
        Value       = [scriptblock]::Create($Signatures['Getter'])
        SecondValue = [scriptblock]::Create($Signatures['Setter'])
    }
    $this | Add-Member @AddMemberParams
}
