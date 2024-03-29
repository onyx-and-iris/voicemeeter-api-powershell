function AddBoolMembers () {
    param(
        [String[]]$PARAMS
    )
    [hashtable]$Signatures = @{}
    foreach ($param in $PARAMS) {
        # Define getter
        $Signatures["Getter"] = "[bool]`$this.Getter('{0}')" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter('{0}', `$arg)" `
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
        $Signatures["Getter"] = "[math]::Round(`$this.Getter('{0}'), 1)" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter('{0}', `$arg)" `
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
        $Signatures["Getter"] = "[Int]`$this.Getter('{0}')" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter('{0}', `$arg)" `
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
        $Signatures["Getter"] = "[String]`$this.Getter_String('{0}')" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [String]`$arg )`n`$this.Setter('{0}', `$arg)" `
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
        $Signatures["Getter"] = "`$this.Setter('{0}', `$true)" -f $param
        # Define setter
        $Signatures["Setter"] = ""

        Addmember
    }
}

function AddChannelMembers () {
    $num_A = $this.remote.kind.p_out
    $num_B = $this.remote.kind.v_out

    [System.Collections.ArrayList]$channels = @()
    1..$($num_A + $num_B) | ForEach-Object {
        if ($_ -le $num_A) { $channels.Add("A{0}" -f $_) } else { $channels.Add("B{0}" -f $($_ - $num_A)) }
    }

    AddBoolMembers -PARAMS $channels
}

function AddGainlayerMembers () {
    [hashtable]$Signatures = @{}
    0..7 | ForEach-Object {
        # Define getter
        $Signatures["Getter"] = "`$this.Getter('gainlayer[{0}]')" -f $_
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter('gainlayer[{0}]', `$arg)" `
            -f $_
        $param = "gainlayer{0}" -f $_
        $null = $param

        Addmember
    }
}

function Addmember {
    $AddMemberParams = @{
        Name        = $param
        MemberType  = 'ScriptProperty'
        Value       = [scriptblock]::Create($Signatures["Getter"])
        SecondValue = [scriptblock]::Create($Signatures["Setter"])
    }
    $this | Add-Member @AddMemberParams
}
