enum ButtonTypes {
    State = 1
    StateOnly = 2
    Trigger = 3
}

class MacroButton {
    [int32]$index

    MacroButton ([int]$index) {
        $this.index = $index
    }

    [string] ToString() {
        return $this.GetType().Name + $this.index
    }

    [int] Getter ($mode) {
        "Button[$($this.index)].$([ButtonTypes].GetEnumName($mode))" | Write-Debug
        return MB_Get -Id $this.index -Mode $mode
    }

    [void] Setter ($val, $mode) {
        "Button[$($this.index)].$([ButtonTypes].GetEnumName($mode))=$val" | Write-Debug
        MB_Set -Id $this.index -SET $val -Mode $mode
    }

    hidden $_state = $($this | Add-Member ScriptProperty 'state' `
        {
            [bool]$this.Getter([ButtonTypes]::State)
        } `
        {
            param($arg)
            $this._state = $this.Setter($arg, [ButtonTypes]::State)
        }
    )

    hidden $_stateonly = $($this | Add-Member ScriptProperty 'stateonly' `
        {
            [bool]$this.Getter([ButtonTypes]::StateOnly)
        } `
        {
            param($arg)
            $this._stateonly = $this.Setter($arg, [ButtonTypes]::StateOnly)
        }
    )

    hidden $_trigger = $($this | Add-Member ScriptProperty 'trigger' `
        {
            [bool]$this.Getter([ButtonTypes]::Trigger)
        } `
        {
            param($arg)
            $this._trigger = $this.Setter($arg, [ButtonTypes]::Trigger)
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
