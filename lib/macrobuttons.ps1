class MacroButton {
    [int32]$id
    
    # Constructor
    MacroButton ([Int]$id)
    {
        $this.id = $id
    }

    [int] Getter($mode) {
        return MB_Get -ID $this.id -MODE $mode
    }

    [void] Setter($set, $mode) {
        MB_Set -ID $this.id -SET $set -MODE $mode
    }

    hidden $_state = $($this | Add-Member ScriptProperty 'state' `
        {
            $this.Getter(1)
        }`
        {
            param ( $arg )
            $this._state = $this.Setter($arg, 1)
        }
    )

    hidden $_stateonly = $($this | Add-Member ScriptProperty 'stateonly' `
        {
            $this.Getter(2)
        }`
        {
            param ( $arg )
            $this._stateonly = $this.Setter($arg, 2)
        }
    )

    hidden $_trigger = $($this | Add-Member ScriptProperty 'trigger' `
        {
            $this.Getter(3)
        }`
        {
            param ( $arg )
            $this._trigger = $this.Setter($arg, 3)
        }
    )
}

Function Make_Buttons {
    [System.Collections.ArrayList]$button = @()
    0..79 | ForEach-Object {
        [void]$button.Add([MacroButton]::new($_))
    }
    $button
}
