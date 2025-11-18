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

function AddGainlayerMembers () {
    $gainlayer = $this.remote.kind.gainlayer

    # Collect (name, alias) pairs
    [System.Collections.ArrayList]$gainlayers = @()
    for ($i = 0; $i -lt $gainlayer; $i++) {
        $name  = "gainlayer[$i]"
        $alias = "gainlayer$i"
        [void]$gainlayers.Add([pscustomobject]@{
            name  = $name
            alias = $alias
        })
    }

    # Add the float members using only the 'name' values
    AddFloatMembers -PARAMS ($gainlayers | ForEach-Object { $_.name })

    # Add alias properties pointing alias -> name
    foreach ($gl in $gainlayers) {
        Add-Member -InputObject $this -MemberType AliasProperty -Name $gl.alias -Value $gl.name
    }
}

function AddASIOInMembers () {
    $asio_in = $this.remote.kind.asio_in
    
    [System.Collections.ArrayList]$in_ps = @()
    for ($i = 0; $i -lt $asio_in; $i++) {
        $in_ps.Add('asio[{0}]' -f $i)
    }

    AddIntMembers -PARAMS $in_ps
}

function AddASIOOutMembers () {
    $num_A = $this.remote.kind.p_out
    $asio_out = $this.remote.kind.asio_out
    
    [System.Collections.ArrayList]$out_ps = @()
    for ($i = 0; $i -lt $asio_out; $i++) {
        foreach ($j in 2..$num_A) {
            $out_ps.Add('OutA{0}[{1}]' -f $j $i)
        }
    }

    AddIntMembers -PARAMS $out_ps
}

function AddCompositeMembers () {
    $composite = $this.remote.kind.composite
    
    [System.Collections.ArrayList]$composite_ps = @()
    for ($i = 0; $i -lt $composite; $i++) {
        $composite_ps.Add('composite[{0}]' -f $i)
    }

    AddIntMembers -PARAMS $composite_ps
}

function AddInsertMembers () {
    $insert = $this.remote.kind.insert
    
    [System.Collections.ArrayList]$insert_ps = @()
    for ($i = 0; $i -lt $insert; $i++) {
        $insert_ps.Add('insert[{0}]' -f $i)
    }

    AddBoolMembers -PARAMS $insert_ps
}

function AddDelayMembers () {
    $p_out = $this.remote.kind.p_out
    
    foreach ($i in 0..$($p_out - 1)) {
        $name = 'delay[{0}]' -f $i
        $this | Add-Member ScriptProperty $name `
            {
                [math]::Round($this.Getter($name), 2)
            } `
            {
                param ([Single]$arg)
                $this.Setter($name, $arg)
            }
    }
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
