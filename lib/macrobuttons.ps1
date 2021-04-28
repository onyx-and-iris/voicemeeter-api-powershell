class MacroButton {
    [int32]$id

    # Constructor
    MacroButton ([Int]$id)
    {
        $this.id = $id
    }

    [void] Setter($set, $mode) {
        MB_Set -ID $this.id -SET $set -MODE $mode
    }

    [int] Getter($mode) {
        return MB_Get -ID $this.id -MODE $mode
    }

    hidden $_state = $($this | Add-Member ScriptProperty 'state' `
        {
            # get
            $this.Getter(1)
        }`
        {
            # set
            param ( $arg )
            $this._state = $this.Setter($arg, 1)
        }
    )

    hidden $_stateonly = $($this | Add-Member ScriptProperty 'stateonly' `
        {
            # get
            $this.Getter(2)
        }`
        {
            # set
            param ( $arg )
            $this._stateonly = $this.Setter($arg, 2)
        }
    )

    hidden $_trigger = $($this | Add-Member ScriptProperty 'trigger' `
        {
            # get
            $this.Getter(3)
        }`
        {
            # set
            param ( $arg )
            $this._trigger = $this.Setter($arg, 3)
        }
    )
}

Function Buttons {
    [System.Collections.ArrayList]$button = @()
    0..69 | ForEach-Object {
        [void]$button.Add([MacroButton]::new($_))
    }
    $button
}

if ($MyInvocation.InvocationName -ne '.')
{

    Login

    $button = Buttons

    $button[0].state = 1
    $button[0].state
    $button[0].state = 0
    $button[0].state

    Logout
}
