class Preset {
    [int]$index
    [Object]$remote

    Preset ([int]$index, [Object]$remote) {
        $this.index  = $index
        $this.remote = $remote

        
        hidden $_recall = $($this | Add-Member ScriptProperty 'recall' `
            {
                $param = "Command.Preset[$($this.index)].Recall"
                $this.remote.Setter($param, 1)
            } `
            {}
        )
    }

    [string] ToString() {
        return "Preset$($this.index)"
    }
}

function Make_Presets ([Object]$remote) {
    [System.Collections.ArrayList]$presets = @()
    0..63 | ForEach-Object {
        [void]$presets.Add([Preset]::new($_, $remote))
    }
    $presets
}