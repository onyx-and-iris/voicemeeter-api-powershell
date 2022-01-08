. $PSScriptRoot\meta.ps1

class Strip {
    [Int]$id
    [Array]$string_params
    [Array]$float_params
    [Array]$bool_params
    [Array]$int_params
    [Int]$num_strip
    [Int]$num_bus

    # Constructor
    Strip ([Int]$id, [Int]$num_strip, [Int]$num_bus)
    {
        $this.id = $id
        $this.num_strip = $num_strip
        $this.num_bus = $num_bus
        $this.string_params = @('label')
        $this.bool_params = @('mono', 'solo', 'mute')
        $this.float_params = @('gain', 'comp', 'gate')
        $this.int_params = @('limit')

        $this.SetChannelLayout()
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

    SetChannelLayout() {
        $this.bool_params
        0..($this.num_strip -1) | ForEach-Object {
            $this.bool_params += "A{0}" -f $_
        }
        0..($this.num_bus -1) | ForEach-Object {
            $this.bool_params += "B{0}" -f $_
        }
    }
}


Function Strips {
    [System.Collections.ArrayList]$strip = @()
    0..$($layout.Strip-1) | ForEach-Object {
        [void]$strip.Add([Strip]::new($_, $layout.Strip, $layout.Bus))
    }
    $strip
}
