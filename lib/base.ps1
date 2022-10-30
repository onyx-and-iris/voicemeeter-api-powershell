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

function Login {
    param(
        [string]$KIND = $null
    )
    try {
        $retval = [int][Voicemeeter.Remote]::VBVMR_Login()
        if (-not $retval) { "LOGGED IN" | Write-Verbose }
        elseif ($retval -eq 1) {
            "VM NOT RUNNING" | Write-Verbose
            New-Variable -Name vm_exe -Value 0

            switch ($KIND) {
                'basic' { $vm_exe = 1; break }
                'banana' { $vm_exe = 2; break }
                'potato' {
                    if ([Environment]::Is64BitOperatingSystem) {
                        $vm_exe = 6
                    }
                    else { $vm_exe = 3 }
                    break
                }
                default { throw [LoginError]::new('Unknown Voicemeeter type') }
            }

            $retval = [int][Voicemeeter.Remote]::VBVMR_RunVoicemeeter([int64]$vm_exe)
            if (-not $retval) { "STARTING VOICEMEETER" | Write-Verbose }
            else { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
            Start-Sleep -s 1
        }
        elseif ($retval -eq -2) {
            throw [LoginError]::new('Login may only be called once per session')
        }
        else { throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [LoginError], [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
        exit
    }

    while (P_Dirty -or M_Dirty) { Start-Sleep -m 1 }
    "VERSION:[" + $(VmType).ToUpper() + "]" | Write-Verbose
}

function Logout {
    Start-Sleep -m 20
    $retval = [int][Voicemeeter.Remote]::VBVMR_Logout()
    if (-not $retval) { "LOGGED OUT" | Write-Verbose }
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

function Version {
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
