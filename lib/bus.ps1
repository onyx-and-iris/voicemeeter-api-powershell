class Bus {
    [int32]$id
    [Array]$bool_params
    [Array]$float_params

    hidden AddPublicMembers() {
        [HashTable]$Signatures = @{}
        @($this.bool_params, $this.float_params) | ForEach-Object {
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
                    $Signatures["Getter"] = "[math]::Round(`$this.Getter(`$this.cmd('{0}')), 1)" -f $param
                    # Define setter
                    $Signatures["Setter"] = "param ( [Single]`$arg )`n`$this.Setter(`$this.cmd('{0}'), `$arg)" `
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
    Bus ([Int]$id)
    {
        $this.id = $id
        $this.bool_params = @('mono', 'mute')
        $this.float_params = @('gain')
        $this.AddPublicMembers()
    }

    [void] Setter($cmd, $set) {
        Param_Set -PARAM $cmd -VALUE $set
    }

    [Single] Getter($cmd) {
        return Param_Get -PARAM $cmd
    }

    [string] cmd ($arg) {
        return "Bus[" + $this.id + "].$arg"
    }
}

Function Buses {
    [System.Collections.ArrayList]$bus = @()
    0..$($layout.Bus-1) | ForEach-Object {
        [void]$bus.Add([Bus]::new($_))
    }
    $bus
}
