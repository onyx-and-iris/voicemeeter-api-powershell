function AddBoolMembers () {
    param(
        [String[]]$PARAMS, [Switch]$readOnly, [Switch]$writeOnly
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        $Signatures['Getter'] = "[bool]`$this.Getter('{0}')" -f $param
        $Signatures['Setter'] = "param ( [bool]`$arg )`n`$this.Setter('{0}', `$arg)" `
            -f $param

        Addmember -ReadOnly:$readOnly -WriteOnly:$writeOnly
    }
}

function AddFloatMembers () {
    param(
        [String[]]$PARAMS, [Switch]$readOnly, [Switch]$writeOnly,
        [int]$decimals = 2
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        $Signatures['Getter'] = "[math]::Round(`$this.Getter('{0}'), {1})" -f $param, $decimals
        $Signatures['Setter'] = "param ( [Single]`$arg )`n`$this.Setter('{0}', `$arg)" `
            -f $param

        Addmember -ReadOnly:$readOnly -WriteOnly:$writeOnly
    }
}

function AddIntMembers () {
    param(
        [String[]]$PARAMS, [Switch]$readOnly, [Switch]$writeOnly
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        $Signatures['Getter'] = "[Int]`$this.Getter('{0}')" -f $param
        $Signatures['Setter'] = "param ( [Int]`$arg )`n`$this.Setter('{0}', `$arg)" `
            -f $param

        Addmember -ReadOnly:$readOnly -WriteOnly:$writeOnly
    }
}

function AddStringMembers () {
    param(
        [String[]]$PARAMS, [Switch]$readOnly, [Switch]$writeOnly
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        $Signatures['Getter'] = "[String]`$this.Getter_String('{0}')" -f $param
        $Signatures['Setter'] = "param ( [String]`$arg )`n`$this.Setter('{0}', `$arg)" `
            -f $param

        Addmember -ReadOnly:$readOnly -WriteOnly:$writeOnly
    }
}

function AddActionMembers () {
    param(
        [String[]]$PARAMS
    )
    foreach ($param in $PARAMS) {
        $this | Add-Member -MemberType ScriptMethod -Name $param `
            -Value ([scriptblock]::Create("`$null = `$this.Setter('$param', 1)")) `
            -Force
    }
}

function AddAliasMembers () {
    param(
        [hashtable]$MAP
    )
    foreach ($alias in $MAP.Keys) {
        $this | Add-Member -MemberType AliasProperty -Name $alias `
            -Value $MAP[$alias] -Force
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
    param(
        [Switch]$readOnly, [Switch]$writeOnly
    )

    if ($readOnly -and $writeOnly) {
        throw "AddMember: cannot be both readOnly and writeOnly for '$param'"
    }

    # Override signatures based on mode
    if ($readOnly) {
        $Signatures['Setter'] = "return Write-Warning (`"ERROR: `$(`$this.identifier()).{0} is read only`")" `
            -f $param
    }
    elseif ($writeOnly) {
        $Signatures['Getter'] = "return Write-Warning (`"ERROR: `$(`$this.identifier()).{0} is write only`")" `
            -f $param
    }
    
    $AddMemberParams = @{
        Name        = $param
        MemberType  = 'ScriptProperty'
        Value       = [scriptblock]::Create($Signatures['Getter'])
        SecondValue = [scriptblock]::Create($Signatures['Setter'])
    }
    $this | Add-Member @AddMemberParams
}
