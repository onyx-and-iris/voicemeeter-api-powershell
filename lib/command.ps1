class Special {
    hidden AddPublicMembers($commands) { 
        $commands | ForEach-Object {
            # Define getter
            $GetterSignature = "`$this.Getter(`$this.cmd('{0}'))" -f $_
            # Define setter
            $SetterSignature = "`$this.Setter(`$this.cmd('{0}'))" -f $_

            $AddMemberParams = @{
                Name = $_
                MemberType = 'ScriptProperty'
                Value = [ScriptBlock]::Create($SetterSignature)
                SecondValue = [ScriptBlock]::Create($GetterSignature)
            }
            $this | Add-Member @AddMemberParams
        }
    }

    # Constructor
    Special()
    {
        $this.AddPublicMembers(@('restart', 'shutdown', 'show'))
    }

    [String] Getter($param) {
        return Write-Warning("ERROR: Usage: $param")
    }

    [void] Setter($param, $val = $true) {
        Param_Set -PARAM $param -VALUE $(if ($val) {1} else {0})
    }    

    [String] cmd ($arg) {
        return "Command.$arg"
    }

    hidden $_showvbanchat = $($this | Add-Member ScriptProperty 'showvbanchat' `
        {
            $this.Getter($this.cmd('DialogShow.VBANCHAT'))
        }`
        {
            param( [bool]$arg )
            $this._showvbanchat = $this.Setter($this.cmd('DialogShow.VBANCHAT'), $arg)
        }
    )

    hidden $_lock = $($this | Add-Member ScriptProperty 'lock' `
        {
            $this._lock = $this.Getter($this.cmd('lock'))
        }`
        {
            param( [bool]$arg )
            $this._lock = $this.Setter($this.cmd('lock'), $arg)
        }
    )
}

Function Make_Command {
    return [Special]::new()
}
