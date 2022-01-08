Function AddPublicMembers($obj) {
    [HashTable]$Signatures = @{}
    ForEach($param in $obj.bool_params) {
        # Define getter
        $Signatures["Getter"] = "`$this.Getter(`$this.cmd('{0}'))" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)"  `
        -f $param

        Addmember
    }

    ForEach($param in $obj.float_params) {
        # Define getter
        $Signatures["Getter"] = "[math]::Round(`$this.Getter(`$this.cmd('{0}')), 1)" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)" `
        -f $param

        Addmember
    }
    
    ForEach($param in $obj.int_params) {
        # Define getter
        $Signatures["Getter"] = "[Int]`$this.Getter(`$this.cmd('{0}'))" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)" `
        -f $param

        Addmember
    }

    ForEach($param in $obj.string_params) {
        # Define getter
        $Signatures["Getter"] = "[String]`$this.Getter_String(`$this.cmd('{0}'))" -f $param
        # Define setter
        $Signatures["Setter"] = "param ( [String]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)" `
        -f $param

        Addmember
    }
}

Function Addmember{
    $AddMemberParams = @{
        Name = $param
        MemberType = 'ScriptProperty'
        Value = [ScriptBlock]::Create($Signatures["Getter"])
        SecondValue = [ScriptBlock]::Create($Signatures["Setter"])
    }
    $obj | Add-Member @AddMemberParams
}
