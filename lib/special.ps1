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
        return Write-Warning("ERROR: " + $param + " is a write only parameter")
    }

    [void] Setter($param) {
        Param_Set -PARAM $param -VALUE 1
    }    

    [String] cmd ($arg) {
        return "Command.$arg"
    }

    hidden $_showvbanchat = $($this | Add-Member ScriptProperty 'showvbanchat' `
        {
            $this._showvbanchat = $this.Setter($this.cmd('DialogShow.VBANCHAT'))
        }`
        {
            $this._showvbanchat = $this.Getter($this.cmd('DialogShow.VBANCHAT'))
        }
    )
}

Function Special {
    return [Special]::new()
}
