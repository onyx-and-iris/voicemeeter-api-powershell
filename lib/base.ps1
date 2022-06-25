. $PSScriptRoot\errors.ps1
. $PSScriptRoot\binding.ps1
. $PSScriptRoot\profiles.ps1
. $PSScriptRoot\inst.ps1
. $PSScriptRoot\strip.ps1
. $PSScriptRoot\bus.ps1
. $PSScriptRoot\macrobuttons.ps1
. $PSScriptRoot\vban.ps1
. $PSScriptRoot\command.ps1
. $PSScriptRoot\recorder.ps1

Function Login {
    param(
        [String]$KIND = $null
    )
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_Login()
        if (-not $retval) { Write-Host("LOGGED IN") }
        elseif ($retval -eq 1) {
            Write-Host("VM NOT RUNNING")
            New-Variable -Name vm_exe -Value 0

            Switch ($KIND) {
                'basic' { $vm_exe = 1; Break }
                'banana' { $vm_exe = 2; Break }
                'potato' {
                    if ([Environment]::Is64BitOperatingSystem) {
                        $vm_exe = 6
                    }
                    else { $vm_exe = 3 }
                    Break
                }
                Default { throw [LoginError]::new('Unknown Voicemeeter type') }
            }

            $retval = [Int][Voicemeeter.Remote]::VBVMR_RunVoicemeeter([Int64]$vm_exe)
            if (-not $retval) { Write-Host("STARTING VOICEMEETER") }
            else { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
            Start-Sleep -s 1
        }
        elseif ($retval -eq -2) { 
            throw [LoginError]::new('Login may only be called once per session')
        }
        else { Exit }
    }
    catch [LoginError], [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }

    while (P_Dirty -or M_Dirty) { Start-Sleep -m 1 }

    New-Variable -Name ptr -Value 0
    $retval = [Int][Voicemeeter.Remote]::VBVMR_GetVoicemeeterType([ref]$ptr)
    if (-not $retval) {
        if ($ptr -eq 1) { Write-Host("VERSION:[BASIC]") }
        elseif ($ptr -eq 2) { Write-Host("VERSION:[BANANA]") }
        elseif ($ptr -eq 3) { Write-Host("VERSION:[POTATO]") }
    }
}

Function Logout {
    Start-Sleep -m 20
    $retval = [Int][Voicemeeter.Remote]::VBVMR_Logout()
    if (-not $retval) { Write-Host("LOGGED OUT") }
}

Function P_Dirty {
    [Bool][Voicemeeter.Remote]::VBVMR_IsParametersDirty()
}

Function M_Dirty {
    [Bool][Voicemeeter.Remote]::VBVMR_MacroButton_IsDirty()
}


Function Param_Get {
    param(
        [String]$PARAM, [bool]$IS_STRING = $false
    )
    Start-Sleep -m 50
    while (P_Dirty) { Start-Sleep -m 1 }

    if ($IS_STRING) {
        $BYTES = [System.Byte[]]::new(512)
        try {
            $retval = [Int][Voicemeeter.Remote]::VBVMR_GetParameterStringA($PARAM, $BYTES)
            if ($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
        }
        catch [CAPIError] {
            Write-Warning $_.Exception.ErrorMessage()
        }
        [System.Text.Encoding]::ASCII.GetString($BYTES).Trim([char]0)        
    }
    else {
        New-Variable -Name ptr -Value 0.0
        try {
            $retval = [Int][Voicemeeter.Remote]::VBVMR_GetParameterFloat($PARAM, [ref]$ptr)
            if ($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
        }
        catch [CAPIError] {
            Write-Warning $_.Exception.ErrorMessage()
        }
        [Single]$ptr
    }
}

Function Param_Set {
    param(
        [String]$PARAM, [Object]$VALUE
    )
    try {
        if ($VALUE -is [String]) {
            $retval = [Int][Voicemeeter.Remote]::VBVMR_SetParameterStringA($PARAM, $VALUE)
        }
        else {
            $retval = [Int][Voicemeeter.Remote]::VBVMR_SetParameterFloat($PARAM, $VALUE)
        }
        if ($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
}

Function MB_Set {
    param(
        [Int64]$ID, [Single]$SET, [Int64]$MODE
    )
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_MacroButton_SetStatus($ID, $SET, $MODE)
        if ($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
}

Function MB_Get {
    param(
        [Int64]$ID, [Int64]$MODE
    )
    Start-Sleep -m 50
    while (M_Dirty) { Start-Sleep -m 1 }

    New-Variable -Name ptr -Value 0.0
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_MacroButton_GetStatus($ID, [ref]$ptr, $MODE)
        if ($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
    [Int]$ptr
}

Function Param_Set_Multi {
    param(
        [HashTable]$HASH
    )
    ForEach ($key in $HASH.keys) { 
        $classobj , $m2, $m3 = $key.Split("_")
        if ($m2 -match "^\d+$") { $index = [int]$m2 } else { $index = [int]$m3 }

        ForEach ($h in $HASH[$key].GetEnumerator()) {
            $property = $h.Name
            $value = $h.Value
            if ($value -in ('False', 'True')) { [System.Convert]::ToBoolean($value) }

            Switch ($classobj) {
                'strip' { $this.strip[$index].$property = $value }
                'bus' { $this.bus[$index].$property = $value }
                { ($_ -eq 'button') -or ($_ -eq 'mb') } { $this.button[$index].$property = $value }
                'vban' { $this.vban.$m2[$index].$property = $value }
            }
        }
    }
}
