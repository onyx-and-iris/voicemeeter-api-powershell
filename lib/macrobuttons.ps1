class MacroButton {
    [int32]$index

    # Constructor
    MacroButton ([int]$index) {
        $this.index = $index
    }

    [string] ToString() {
        return $this.GetType().Name + $this.index
    }

    [int] Getter ($mode) {
        return MB_Get -Id $this.index -Mode $mode
    }

    [void] Setter ($set, $mode) {
        MB_Set -Id $this.index -SET $set -Mode $mode
    }

    hidden $_state = $($this | Add-Member ScriptProperty 'state' `
        {
            [bool]$this.Getter(1)
        } `
        {
            param($arg)
            $this._state = $this.Setter($arg, 1)
        }
    )

    hidden $_stateonly = $($this | Add-Member ScriptProperty 'stateonly' `
        {
            [bool]$this.Getter(2)
        } `
        {
            param($arg)
            $this._stateonly = $this.Setter($arg, 2)
        }
    )

    hidden $_trigger = $($this | Add-Member ScriptProperty 'trigger' `
        {
            [bool]$this.Getter(3)
        } `
        {
            param($arg)
            $this._trigger = $this.Setter($arg, 3)
        }
    )
}

function Make_Buttons {
    [System.Collections.ArrayList]$button = @()
    0..79 | ForEach-Object {
        [void]$button.Add([MacroButton]::new($_))
    }
    $button
}
