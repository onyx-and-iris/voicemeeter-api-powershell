. $PSScriptRoot\meta.ps1

class Strip {
    [int32]$id
    [Array]$string_params
    [Array]$float_params
    [Array]$bool_params
    [Array]$int_params

    # Constructor
    Strip ([Int]$id)
    {
        $this.id = $id
        $this.string_params = @('label')
        $this.bool_params = @('mono', 'solo', 'mute',
        'A1', 'A2', 'A3', 'A4', 'A5',
        'B1', 'B2', 'B3')
        $this.float_params = @('gain', 'comp', 'gate')
        $this.int_params = @('limit')
        AddPublicMembers($this)
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
