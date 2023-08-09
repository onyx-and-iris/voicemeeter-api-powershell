function Setup_DLL {
    try {
        $vb_path = Get_VBPath

        if ([string]::IsNullOrWhiteSpace($vb_path)) {
            throw [VMRemoteError]::new("couldn't get Voicemeeter path")
        }
        $dll = Join-Path -Path $vb_path -ChildPath ("VoicemeeterRemote" + `
            (& { if ([Environment]::Is64BitOperatingSystem) { "64" } else { "" } }) + `
                ".dll")
    }
    catch [VMRemoteError] {
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
    public static extern int VBVMR_GetVoicemeeterVersion(ref int ptr);

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

    [DllImport(@"$dll")]
    public static extern int VBVMR_GetLevel(Int64 mode, Int64 index, ref float ptr);
"@

    Add-Type -MemberDefinition $Signature -Name Remote -Namespace Voicemeeter -PassThru | Out-Null
    return $true
}
