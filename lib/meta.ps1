Function AddBoolMembers() {
    param(
        [String[]]$PARAMS
    )
    [HashTable]$Signatures = @{}
    ForEach ($param in $PARAMS) {
        # Define getter
        $Signatures["Getter"] = "[bool]`$this.Getter(`$this.cmd('{0}'))" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)"  `
            -f $param

        Addmember
    }
}

Function AddFloatMembers() {
    param(
        [String[]]$PARAMS
    )
    [HashTable]$Signatures = @{}
    ForEach ($param in $PARAMS) {
        # Define getter
        $Signatures["Getter"] = "[math]::Round(`$this.Getter(`$this.cmd('{0}')), 1)" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)" `
            -f $param

        Addmember
    }
}

Function AddIntMembers() {
    param(
        [String[]]$PARAMS
    )
    [HashTable]$Signatures = @{}
    ForEach ($param in $PARAMS) {
        # Define getter
        $Signatures["Getter"] = "[Int]`$this.Getter(`$this.cmd('{0}'))" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)" `
            -f $param

        Addmember
    }
}

Function AddStringMembers() {
    param(
        [String[]]$PARAMS
    )
    [HashTable]$Signatures = @{}
    ForEach ($param in $PARAMS) {
        # Define getter
        $Signatures["Getter"] = "[String]`$this.Getter_String(`$this.cmd('{0}'))" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [String]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)" `
            -f $param

        Addmember
    }    
}

Function AddActionMembers() { 
    param(
        [String[]]$PARAMS
    )
    [HashTable]$Signatures = @{}
    ForEach ($param in $PARAMS) {
        # Define getter
        $Signatures["Getter"] = "`$this.Setter(`$this.cmd('{0}'), `$true)" -f $param
        # Define setter
        $Signatures["Setter"] = ""

        Addmember
    }
}

Function AddChannelMembers() {
    $num_A = $layout.p_out
    $num_B = $layout.v_out

    [System.Collections.ArrayList]$channels = @()
    1..$($num_A + $num_B) | ForEach-Object {
        if ($_ -le $num_A) { $channels.Add("A{0}" -f $_) } else { $channels.Add("B{0}" -f $($_ - $num_A)) }
    }

    AddBoolMembers -PARAMS $channels
}

Function AddGainlayerMembers() {
    [HashTable]$Signatures = @{}
    0..7 | ForEach-Object {
        # Define getter
        $Signatures["Getter"] = "`$this.Getter(`$this.cmd('gainlayer[{0}]'))" -f $_
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('gainlayer[{0}]'), `$arg)" `
            -f $_
        $param = "gainlayer{0}" -f $_

        Addmember
    }
}

Function AddBusModeMembers() {
    param(
        [String[]]$PARAMS
    )
    [HashTable]$Signatures = @{}
    ForEach ($param in $PARAMS) {
        # Define getter
        $Signatures["Getter"] = "[bool]`$this.Getter(`$this.cmd('mode.{0}'))" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('mode.{0}'), `$arg)"  `
            -f $param
        $param = "mode_{0}" -f $param

        Addmember
    }
}

Function Addmember {
    $AddMemberParams = @{
        Name        = $param
        MemberType  = 'ScriptProperty'
        Value       = [ScriptBlock]::Create($Signatures["Getter"])
        SecondValue = [ScriptBlock]::Create($Signatures["Setter"])
    }
    $this | Add-Member @AddMemberParams
}
