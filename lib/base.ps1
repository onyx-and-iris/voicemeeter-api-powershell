. $PSScriptRoot\errors.ps1
. $PSScriptRoot\binding.ps1

function Login {
    param(
        [string]$kindId
    )
    try {
        $retval = [int][Voicemeeter.Remote]::VBVMR_Login()
        if ($retval -ne 0) {
            switch ($retval) {
                1 {
                    New-Variable -Name vmExe -Value 0

                    if ( $kindId -eq "basic" ) { $vmExe = 1 }
                    elseif ( $kindId -eq "banana" ) { $vmExe = 2 }
                    elseif ( $kindId -eq "potato" ) {
                        $vmExe = $(if ([Environment]::Is64BitOperatingSystem) { 6 } else { 3 })
                    }

                    $retval = [int][Voicemeeter.Remote]::VBVMR_RunVoicemeeter([int64]$vmExe)
                    if (-not $retval) { 
                        "Voicemeeter Engine running but GUI not launched. Launching GUI now." | Write-Verbose
                        Start-Sleep -s 1
                    }
                    else { 
                        throw [CAPIError]::new($retval, $MyInvocation.MyCommand) 
                    }
                }
                -2 {
                    throw [LoginError]::new('Login may only be called once per session')
                }
                default { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
            }
        }   
    }
    catch [LoginError] {
        "$($_.Exception.ErrorMessage()). Fatal error, exiting..." | Write-Warning
        exit -2
    }

    while (P_Dirty -or M_Dirty) { Start-Sleep -m 1 }
    "Successfully logged into Voicemeeter [" + $(VmType).ToUpper() + "] Version " + $(VmVersion) | Write-Verbose
}

function Logout {
    Start-Sleep -m 20
    $retval = [int][Voicemeeter.Remote]::VBVMR_Logout()
    if ($retval -eq 0) { "Sucessfully logged out" | Write-Verbose }     
}

function P_Dirty {
    [bool][Voicemeeter.Remote]::VBVMR_IsParametersDirty()
}

function M_Dirty {
    [bool][Voicemeeter.Remote]::VBVMR_MacroButton_IsDirty()
}

function VmType {
    New-Variable -Name ptr -Value 0
    $retval = [int][Voicemeeter.Remote]::VBVMR_GetVoicemeeterType([ref]$ptr)
    if ($retval) { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    switch ($ptr) {
        1 { return "basic" }
        2 { return "banana" }
        3 { return "potato" }
    }
}

function VmVersion {
    New-Variable -Name ptr -Value 0
    $retval = [int][Voicemeeter.Remote]::VBVMR_GetVoicemeeterVersion([ref]$ptr)
    if ($retval) { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    $v1 = ($ptr -band 0xFF000000) -shr 24
    $v2 = ($ptr -band 0x00FF0000) -shr 16
    $v3 = ($ptr -band 0x0000FF00) -shr 8
    $v4 = $ptr -band 0x000000FF
    "$v1.$v2.$v3.$v4"
}


function Param_Get {
    param(
        [string]$PARAM, [bool]$IS_STRING = $false
    )
    Start-Sleep -m 50
    while (P_Dirty) { Start-Sleep -m 1 }

    if ($IS_STRING) {
        $BYTES = [System.Byte[]]::new(512)
        try {
            $retval = [int][Voicemeeter.Remote]::VBVMR_GetParameterStringA($PARAM, $BYTES)
            if ($retval) { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
        }
        catch [CAPIError] {
            Write-Warning $_.Exception.ErrorMessage()
        }
        [System.Text.Encoding]::ASCII.GetString($BYTES).Trim([char]0)
    }
    else {
        New-Variable -Name ptr -Value 0.0
        try {
            $retval = [int][Voicemeeter.Remote]::VBVMR_GetParameterFloat($PARAM, [ref]$ptr)
            if ($retval) { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
        }
        catch [CAPIError] {
            Write-Warning $_.Exception.ErrorMessage()
        }
        [single]$ptr
    }
}

function Param_Set {
    param(
        [string]$PARAM, [Object]$VALUE
    )
    try {
        if ($VALUE -is [string]) {
            $retval = [int][Voicemeeter.Remote]::VBVMR_SetParameterStringA($PARAM, $VALUE)
        }
        else {
            $retval = [int][Voicemeeter.Remote]::VBVMR_SetParameterFloat($PARAM, $VALUE)
        }
        if ($retval) { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
}

function MB_Set {
    param(
        [int64]$ID, [single]$SET, [int64]$MODE
    )
    try {
        $retval = [int][Voicemeeter.Remote]::VBVMR_MacroButton_SetStatus($ID, $SET, $MODE)
        if ($retval) { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
}

function MB_Get {
    param(
        [int64]$ID, [int64]$MODE
    )
    Start-Sleep -m 50
    while (M_Dirty) { Start-Sleep -m 1 }

    New-Variable -Name ptr -Value 0.0
    try {
        $retval = [int][Voicemeeter.Remote]::VBVMR_MacroButton_GetStatus($ID, [ref]$ptr, $MODE)
        if ($retval) { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
    [int]$ptr
}

function Param_Set_Multi {
    param(
        [hashtable]$HASH
    )
    foreach ($key in $HASH.keys) {
        $classobj, $m2, $m3 = $key.Split("_")
        if ($m2 -match "^\d+$") { $index = [int]$m2 } else { $index = [int]$m3 }

        foreach ($h in $HASH[$key].GetEnumerator()) {
            $property = $h.Name
            $value = $h.Value
            if ($value -in ('False', 'True')) { [System.Convert]::ToBoolean($value) }

            switch ($classobj) {
                'strip' { $this.strip[$index].$property = $value }
                'bus' { $this.bus[$index].$property = $value }
                { ($_ -eq 'button') -or ($_ -eq 'mb') } { $this.button[$index].$property = $value }
                'vban' { $this.vban.$m2[$index].$property = $value }
            }
        }
    }
}

function Set_By_Script {
    param(
        [string]$script
    )
    try {
        $retval = [int][Voicemeeter.Remote]::VBVMR_SetParameters($script)
        if ($retval) { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
}

function Get_Level {
    param(
        [int64]$MODE, [int64]$INDEX
    )
    New-Variable -Name ptr -Value 0.0
    try {
        $retval = [int][Voicemeeter.Remote]::VBVMR_GetLevel($MODE, $INDEX, [ref]$ptr)
        if ($retval) { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
    [float]$ptr
}