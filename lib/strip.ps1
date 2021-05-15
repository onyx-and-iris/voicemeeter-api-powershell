class Strip {
    [int32]$id
    [Array]$string_params
    [Array]$float_params
    [Array]$bool_params

    hidden AddPublicMembers() {
        [HashTable]$Signatures = @{}
        @($this.bool_params, $this.string_params, $this.float_params) | ForEach-Object {
            ForEach($param in $_) {
                if($this.bool_params.Contains($param)) {
                    # Define getter
                    $Signatures["Getter"] = "`$this.Getter(`$this.cmd('{0}'))" -f $param
                    # Define setter
                    $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)"  `
                    -f $param
                }
                elseif($this.float_params.Contains($param)) {
                    # Define getter
                    if($param -eq "limit") {
                        $Signatures["Getter"] = "[Int]`$this.Getter(`$this.cmd('{0}'))" -f $param
                    } else {
                        $Signatures["Getter"] = "[math]::Round(`$this.Getter(`$this.cmd('{0}')), 1)" -f $param
                    }
                    # Define setter
                    $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)" `
                    -f $param
                }
                elseif($this.string_params.Contains($param)) {
                    # Define getter
                    $Signatures["Getter"] = "[String]`$this.Getter_String(`$this.cmd('{0}'))" -f $param
                    # Define setter
                    $Signatures["Setter"] = "param ( [String]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)" `
                    -f $param
                }

                $GetterScriptBlock = [ScriptBlock]::Create($Signatures["Getter"])
                $SetterScriptBlock = [ScriptBlock]::Create($Signatures["Setter"])
                $AddMemberParams = @{
                    Name = $param
                    MemberType = 'ScriptProperty'
                    Value = $GetterScriptBlock
                    SecondValue = $SetterScriptBlock
                }
                $this | Add-Member @AddMemberParams
            }
        }
    }

    # Constructor
    Strip ([Int]$id)
    {
        $this.id = $id
        $this.string_params = @('label')
        $this.bool_params = @('mono', 'solo', 'mute',
        'A1', 'A2', 'A3', 'A4', 'A5',
        'B1', 'B2', 'B3')
        $this.float_params = @('gain', 'comp', 'gate', 'limit')
        $this.AddPublicMembers()
    }

    [void] Setter($cmd, $set) {
        if( $this.string_params.Contains($cmd.Split('.')[1]) ) {
            Param_Set_String -PARAM $cmd -VALUE $set
        }
        else { Param_Set -PARAM $cmd -VALUE $set }
    }

    [Single] Getter($cmd) {
        return Param_Get -PARAM $cmd
    }

    [String] Getter_String($cmd) {
        return Param_Get_String -PARAM $cmd
    }

    [String] cmd ($arg) {
        return "Strip[" + $this.id + "].$arg"
    }
}

Function Strips {
    [System.Collections.ArrayList]$strip = @()
    0..$($layout.Strip-1) | ForEach-Object {
        [void]$strip.Add([Strip]::new($_))
    }
    $strip
}
