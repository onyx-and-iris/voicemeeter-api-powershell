. $PSScriptRoot\errors.ps1
. $PSScriptRoot\strip.ps1
. $PSScriptRoot\bus.ps1
. $PSScriptRoot\macrobuttons.ps1

$Signature = @'
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

Add-Type -MemberDefinition $Signature -Name Remote -Namespace Voicemeeter -PassThru | Out-Null

$global:layout = $null


Function Param_Set_Multi {
    param(
        [HashTable]$HASH
    )
    Start-Sleep -m 50
    while(M_Dirty) { Start-Sleep -m 1 }
    [string[]]$params = ($HASH | out-string -stream) -ne '' | Select-Object -Skip 2
    $cmd_channel = [String]::new(512)
    $cmd_mb = @(
        ,@()
    )
    ForEach ($line in $params) {
        if($line.Trim() -Match "(^\w+)\[(\d)\].(\w+)\s+(\w+)") {
            if($Matches[4] -eq "True") { $val = 1 } else { $val = 0 }
            [String]$cmd_channel += "$($Matches[1])[$($Matches[2])].$($Matches[3])=$val;"
        }
        elseif($line.Trim() -Match "mb_(\d+).(\w+)\s+(\w+)") {
            $id = $Matches[1]
            if($Matches[2] -eq "state") { $mode = 1 }
            elseif($Matches[2] -eq "stateonly") { $mode = 2 }
            elseif($Matches[2] -eq "trigger") { $mode = 3 }
            if($Matches[3] -eq "True") { $val = 1 } else { $val = 0 }

            $cmd_mb += , @($id, $val, $mode)
        }
    }

    [HashTable]$cmds = @{}
    if(![string]::IsNullOrEmpty($cmd_channel)) { $cmds["channel"] = $cmd_channel }
    if($cmd_mb.count -gt 0) { $cmds["mb"] = $cmd_mb }

    if($cmds.ContainsKey("channel")) {
        $cmds["channel"] = $cmds["channel"] -replace '[^a-z0-9.\[\]=;]+'
        if(![string]::IsNullOrEmpty($cmds["channel"])) {
            try {
                $retval = [Int][Voicemeeter.Remote]::VBVMR_SetParameters($cmds["channel"])
                if($retval) { Throw [CAPIError]::new($retval, $MyInvocation.MyCommand) }
            }
            catch [CAPIError] {
                Write-Warning $_.Exception.ErrorMessage()
            }
        }
    }
    if($cmds.ContainsKey("mb")) {
        $cmds["mb"] | ForEach-Object {
            if($_.count -gt 0) {
                MB_Set -ID $_[0] -SET $_[1] -MODE $_[2]
            }
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
    try {
        $retval = [Int][Voicemeeter.Remote]::VBVMR_Login()
        if(-not $retval) { Write-Host("LOGGED IN") }
        elseif($retval -eq 1) {
            Write-Host("VB NOT RUNNING")
            New-Variable -Name vbtype -Value 0

            Switch($TYPE) {
                'basic' { $vbtype = 1; Break}
                'banana' { $vbtype = 2; Break}
                'potato' { $vbtype = 3; Break}
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
