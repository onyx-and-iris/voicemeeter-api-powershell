. $PSScriptRoot\strip.ps1
. $PSScriptRoot\bus.ps1
. $PSScriptRoot\macrobuttons.ps1

$Handles  = @'
    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_Login();
    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_Logout();
    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_RunVoicemeeter(Int64 run);
    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_GetVoicemeeterType(ref int ptr);

    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_MacroButton_IsDirty();
    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_MacroButton_SetStatus(Int64 id, Single state, Int64 mode);
    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_MacroButton_GetStatus(Int64 id, ref float ptr, Int64 mode);

    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_IsParametersDirty();
    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_SetParameterFloat(String param, Single value);
    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_GetParameterFloat(String param, ref float ptr);

    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_SetParameterStringA(String param, String value);
    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_GetParameterStringA(String param, byte[] buff);

    [DllImport(@"C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")]
    public static extern int VBVMR_SetParameters(String param);
'@

$lib = Add-Type -MemberDefinition $Handles -Name VMRemote -PassThru

$global:layout = $null

Function Param_Set_Multi {
    param(
        [HashTable]$HASH
    )
    Start-Sleep -m 50
    while(M_Dirty) { Start-Sleep -m 1 }

    [string[]]$params = ($HASH | out-string -stream) -ne '' | select -Skip 2
    [String]$cmd = [String]::new(512)
    ForEach ($line in $params) {
        $line = $($line -replace '\s+', ' ')
        $line = $line.TrimEnd()
        $line = $line -replace '\s', '='
        $line = $line -replace 'True', '1'
        $line = $line -replace 'False', '0'

        $cmd += $line + ';'
    }
    [String]$cmd = $cmd.SubString(1)

    $retval = $lib::VBVMR_SetParameters($cmd)
    if($retval) { Throw "ERROR: CAPI return value: $retval" }
}

Function Param_Set_String {
    param(
        [String]$PARAM, [String]$VALUE
    )
    $retval = $lib::VBVMR_SetParameterStringA($PARAM, $VALUE)
    if($retval) { Throw "ERROR: CAPI return value: $retval" }
}


Function Param_Get_String {
    param(
        [String]$PARAM
    )
    Start-Sleep -m 50
    while(P_Dirty) { Start-Sleep -m 1 }

    $BYTES = [System.Byte[]]::new(512)
    $retval = $lib::VBVMR_GetParameterStringA($PARAM, $BYTES)
    if($retval) { Throw "ERROR: CAPI return value: $retval" }

    [System.Text.Encoding]::ASCII.GetString($BYTES).Trim([char]0)
}


Function Param_Set {
    param(
        [String]$PARAM, [Single]$VALUE
    )
    $retval = $lib::VBVMR_SetParameterFloat($PARAM, $VALUE)
    if($retval) { Throw "ERROR: CAPI return value: $retval" }
}


Function Param_Get {
    param(
        [String]$PARAM
    )
    Start-Sleep -m 50
    while(P_Dirty) { Start-Sleep -m 1 }

    $ptr = 0.0
    $retval = $lib::VBVMR_GetParameterFloat($PARAM, [ref]$ptr)
    if($retval) { Throw "ERROR: CAPI return value: $retval" }
    $ptr
}


Function MB_Set {
    param(
        [Int64]$ID, [Single]$SET, [Int64]$MODE
    )
    $retval = $lib::VBVMR_MacroButton_SetStatus($ID, $SET, $MODE)
    if($retval) { Throw "ERROR: CAPI return value: $retval" }
}


Function MB_Get {
    param(
        [Int64]$ID, [Int64]$MODE
    )
    Start-Sleep -m 50
    while(M_Dirty) { Start-Sleep -m 1 }

    $ptr = 0.0
    $retval = $lib::VBVMR_MacroButton_GetStatus($ID, [ref]$ptr, $MODE)
    if($retval) { Throw "ERROR: CAPI return value: $retval" }
    $ptr
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
        }
    }
    elseif($TYPE -eq 2) {
        $layout = @{
           "strip" = 5
           "bus" = 5
        }
    }
    elseif($TYPE -eq 3) {
        $layout = @{
           "strip" = 8
           "bus" = 8
        }
    }
    $global:layout = $layout
}


Function Login {
    param(
        [String]$TYPE=$null
    )
    $retval = $lib::VBVMR_Login()
    if(-not $retval) { Write-Host("LOGGED IN") }
    elseif($retval -eq 1) {
        Write-Host("VB NOT RUNNING")

        if($TYPE -eq 'basic') {
            $retval = $lib::VBVMR_RunVoicemeeter([Int64]1)
            if(-not $retval) { Write-Host("STARTING VB") }
        }
        elseif($TYPE -eq 'banana') {
            $retval = $lib::VBVMR_RunVoicemeeter([Int64]2)
            if(-not $retval) { Write-Host("STARTING VB") }
        }
        elseif($TYPE -eq 'potato') {
            $retval = $lib::VBVMR_RunVoicemeeter([Int64]3)
            if(-not $retval) { Write-Host("STARTING VB") }
        }
    } else { Exit }

    while(P_Dirty -or M_Dirty) { Start-Sleep -m 1 }

    $ptr = 0
    $retval = $lib::VBVMR_GetVoicemeeterType([ref]$ptr)
    if(-not $retval) {
        if($ptr -eq 1) { Write-Host("VERSION:[BASIC]") }
        elseif($ptr -eq 2) { Write-Host("VERSION:[BANANA]") }
        elseif($ptr -eq 3) { Write-Host("VERSION:[POTATO]") }
        Start-Sleep -s 1
    }

    DefineVersion -TYPE $ptr
}


Function Logout {
    Start-Sleep -m 20
    $retval = $lib::VBVMR_Logout()
    if(-not $retval) { Write-Host("LOGGED OUT") }
}


Function P_Dirty {
    $lib::VBVMR_IsParametersDirty()
}


Function M_Dirty {
    $lib::VBVMR_MacroButton_IsDirty()
}


if ($MyInvocation.InvocationName -ne '.')
{
    Login

    $hash = @{
        "Strip[0].Mute" = $true
        "Strip[1].Mute" = $true
        "Strip[2].Mute" = $true
        "Strip[0].Mono" = $true
        "Strip[1].Mono" = $true
        "Strip[2].Mono" = $true
    }


    0..10 | ForEach-Object {
        foreach($key in $($hash.keys)){
        $hash[$key] = $true
        }
        Param_Set_Multi -HASH $hash

        foreach($key in $($hash.keys)){
        $hash[$key] = $false
        }
        Param_Set_Multi -HASH $hash
    }

    Logout
}
