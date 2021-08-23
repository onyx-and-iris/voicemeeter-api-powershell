. $PSScriptRoot\errors.ps1
. $PSScriptRoot\inst.ps1
. $PSScriptRoot\strip.ps1
. $PSScriptRoot\bus.ps1
. $PSScriptRoot\macrobuttons.ps1
. $PSScriptRoot\vban.ps1
. $PSScriptRoot\special.ps1

$global:layout = $null

Function Setup_DLL {
    try {
        $vb_path = Get_VBPath

        if([string]::IsNullOrWhiteSpace($vb_path)) {
            throw [VBPathError]::new("ERROR: Couldn't get Voicemeeter path")
        }
        else {
            if([Environment]::Is64BitOperatingSystem) {
                $dll = Join-Path -Path $vb_path -ChildPath "VoicemeeterRemote64.dll"
            }
            else {
                $dll = Join-Path -Path $vb_path -ChildPath "VoicemeeterRemote.dll"
            }
        }
    }
    catch [VBPathError] {
        Write-Warning $_.Exception.ErrorMessage()
        return $false
    }

$Signature = @"
    [DllImport(@"$dll")]
    public static extern int VBVMR_Login();
    [DllImport(@"$dll")]
    public static extern int VBVMR_Logout();
    [DllImport(@"$dll")]
    public static extern int VBVMR_RunVoicemeeter(Int64 run);
    [DllImport(@"$dll")]
    public static extern int VBVMR_GetVoicemeeterType(ref int ptr);

    [DllImport(@"$dll")]
    public static extern int VBVMR_MacroButton_IsDirty();
    [DllImport(@"$dll")]
    public static extern int VBVMR_MacroButton_SetStatus(Int64 id, Single state, Int64 mode);
    [DllImport(@"$dll")]
    public static extern int VBVMR_MacroButton_GetStatus(Int64 id, ref float ptr, Int64 mode);

    [DllImport(@"$dll")]
    public static extern int VBVMR_IsParametersDirty();
    [DllImport(@"$dll")]
    public static extern int VBVMR_SetParameterFloat(String param, Single value);
    [DllImport(@"$dll")]
    public static extern int VBVMR_GetParameterFloat(String param, ref float ptr);

    [DllImport(@"$dll")]
    public static extern int VBVMR_SetParameterStringA(String param, String value);
    [DllImport(@"$dll")]
    public static extern int VBVMR_GetParameterStringA(String param, byte[] buff);

    [DllImport(@"$dll")]
    public static extern int VBVMR_SetParameters(String param);
"@

    Add-Type -MemberDefinition $Signature -Name Remote -Namespace Voicemeeter -PassThru | Out-Null
    return $true
}


Function Param_Set_Multi {
    param(
        [HashTable]$HASH
    )
    Start-Sleep -m 50
    while(M_Dirty) { Start-Sleep -m 1 }

    $cmd_strip = [String]::new(512)
    $cmd_bus = [String]::new(512)

    $textInfo = (Get-Culture).TextInfo
    ForEach($key in $HASH.keys) {
        $identifier = $key.Split("_")[0]
        $num = $key.Split("_")[1]
        $val = if($HASH.Item($key).values -eq "True") {1} else {0}

        if($identifier -eq "strip") {
            ForEach($k in $HASH.Item($key).keys) {
                    $param = $textInfo.ToTitleCase($k)
                    $cmd_strip += "Strip[$num].$param=$val;"
                }
            }
        elseif($identifier -eq "bus") {
            ForEach($k in $HASH.Item($key).keys) {
                $param = $textInfo.ToTitleCase($k)
                $cmd_bus += "Bus[$num].$param=$val;"
            }
        }
        elseif($identifier -eq "mb") {
            ForEach($k in $HASH.Item($key).keys) {
                if($k -eq "state") { $mode = 1 }
                elseif($k -eq "stateonly") { $mode = 2 }
                elseif($k -eq "trigger") { $mode = 3 }

                MB_Set -ID $num -SET $val -MODE $mode
            }
        }
    }

    @($cmd_bus, $cmd_strip) | ForEach-Object {
        try {
            $retval = [Int][Voicemeeter.Remote]::VBVMR_SetParameters($_.Substring(1))
            if($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
        }
        catch [CAPIError] {
            Write-Warning $_.Exception.ErrorMessage()
        }
    }
}

Function Param_Set_String {
    param(
        [String]$PARAM, [String]$VALUE
    )
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_SetParameterStringA($PARAM, $VALUE)
        if($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
}


Function Param_Get_String {
    param(
        [String]$PARAM
    )
    Start-Sleep -m 50
    while(P_Dirty) { Start-Sleep -m 1 }

    $BYTES = [System.Byte[]]::new(512)
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_GetParameterStringA($PARAM, $BYTES)
        if($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }

    [System.Text.Encoding]::ASCII.GetString($BYTES).Trim([char]0)
}


Function Param_Set {
    param(
        [String]$PARAM, [Single]$VALUE
    )
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_SetParameterFloat($PARAM, $VALUE)
        if($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
}


Function Param_Get {
    param(
        [String]$PARAM
    )
    Start-Sleep -m 50
    while(P_Dirty) { Start-Sleep -m 1 }

    New-Variable -Name ptr -Value 0.0
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_GetParameterFloat($PARAM, [ref]$ptr)
        if($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
    [Single]$ptr
}


Function MB_Set {
    param(
        [Int64]$ID, [Single]$SET, [Int64]$MODE
    )
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_MacroButton_SetStatus($ID, $SET, $MODE)
        if($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
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
    while(M_Dirty) { Start-Sleep -m 1 }

    New-Variable -Name ptr -Value 0.0
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_MacroButton_GetStatus($ID, [ref]$ptr, $MODE)
        if($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
    }
    catch [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }
    [Int]$ptr
}

Function DefineVersion {
    param(
        [Int]$TYPE
    )
    $layout = @{}

    if($TYPE -eq 1) {
        $layout = @{
           "strip" = 3
           "bus" = 2
           "vban_in" = 4
           "vban_out" = 4
        }
    }
    elseif($TYPE -eq 2) {
        $layout = @{
           "strip" = 5
           "bus" = 5
           "vban_in" = 8
           "vban_out" = 8
        }
    }
    elseif($TYPE -eq 3) {
        $layout = @{
           "strip" = 8
           "bus" = 8
           "vban_in" = 8
           "vban_out" = 8
        }
    }
    $global:layout = $layout
}


Function Login {
    param(
        [String]$TYPE=$null
    )
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_Login()
        if(-not $retval) { Write-Host("LOGGED IN") }
        elseif($retval -eq 1) {
            Write-Host("VB NOT RUNNING")
            New-Variable -Name vbtype -Value 0

            Switch($TYPE) {
                'basic' { $vbtype = 1; Break}
                'banana' { $vbtype = 2; Break}
                'potato' {
                    if ([Environment]::Is64BitOperatingSystem) {
                            $vbtype = 6
                        } else { $vbtype = 3 }
                    Break
                }
                Default { throw [LoginError]::new('Unknown Voicemeeter type') }
            }

            $retval = [Int][Voicemeeter.Remote]::VBVMR_RunVoicemeeter([Int64]$vbtype)
            if(-not $retval) { Write-Host("STARTING VB") }
            else { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
            Start-Sleep -s 1
        } else { Exit }
    }
    catch [LoginError], [CAPIError] {
        Write-Warning $_.Exception.ErrorMessage()
    }

    while(P_Dirty -or M_Dirty) { Start-Sleep -m 1 }

    New-Variable -Name ptr -Value 0
    $retval = [Int][Voicemeeter.Remote]::VBVMR_GetVoicemeeterType([ref]$ptr)
    if(-not $retval) {
        if($ptr -eq 1) { Write-Host("VERSION:[BASIC]") }
        elseif($ptr -eq 2) { Write-Host("VERSION:[BANANA]") }
        elseif($ptr -eq 3) { Write-Host("VERSION:[POTATO]") }
    }

    DefineVersion -TYPE $ptr
}


Function Logout {
    Start-Sleep -m 20
    $retval = [Int][Voicemeeter.Remote]::VBVMR_Logout()
    if(-not $retval) { Write-Host("LOGGED OUT") }
}


Function P_Dirty {
    [Bool][Voicemeeter.Remote]::VBVMR_IsParametersDirty()
}


Function M_Dirty {
    [Bool][Voicemeeter.Remote]::VBVMR_MacroButton_IsDirty()
}
