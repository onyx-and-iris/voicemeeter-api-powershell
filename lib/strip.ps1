. $PSScriptRoot\meta.ps1

class Strip {
    [Int]$id
    [Array]$string_params
    [Array]$float_params
    [System.Collections.ArrayList]$bool_params
    [Array]$int_params

    hidden SetChannelLayout($num_A, $num_B) {
        1..$num_A | ForEach-Object {
            $this.bool_params.Add("A{0}" -f $_)
        }
        1..$num_B | ForEach-Object {
            $this.bool_params.Add("B{0}" -f $_)
        }
    }

    # Constructor
    Strip ([Int]$id, [Int]$num_A, [Int]$num_B)
    {
        $this.id = $id
        $this.string_params = @('label')
        $this.float_params = @('gain', 'comp', 'gate')
        $this.int_params = @('limit')
        $this.bool_params = @('mono', 'solo', 'mute')
        $this.SetChannelLayout($num_A, $num_B)

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

    hidden $_device = $($this | Add-Member ScriptProperty 'device' `
        {
            $this.Getter_String($this.cmd('device.name'))
        }`
        {
            return Write-Warning("ERROR: " + $this.cmd('device.name') +  " is read only")
        }
    )

    hidden $_sr = $($this | Add-Member ScriptProperty 'sr' `
        {
            $this.Getter_String($this.cmd('device.sr'))
        }`
        {
            return Write-Warning("ERROR: " + $this.cmd('device.sr') +  " is read only")
        }
    )
}

class PhysicalStrip : Strip {
    PhysicalStrip ([Int]$id, [Int]$num_A, [Int]$num_B) : base ($id, $num_A, $num_B) {
    }
}

class VirtualStrip : Strip {
    VirtualStrip ([Int]$id, [Int]$num_A, [Int]$num_B) : base ($id, $num_A, $num_B) {
    }
}


Function Strips {
    [System.Collections.ArrayList]$strip = @()
    0..$($layout.p_in + $layout.v_in - 1) | ForEach-Object {
        if ($_ -lt $layout.p_in) { 
            [void]$strip.Add([PhysicalStrip]::new($_, $layout.p_out, $layout.v_out)) 
        }
        else { [void]$strip.Add([VirtualStrip]::new($_, $layout.p_out, $layout.v_out)) }
    }
    $strip
}
