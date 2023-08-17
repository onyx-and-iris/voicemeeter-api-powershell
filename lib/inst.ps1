function Get_VMPath {
    $REG_KEY = @(
        "Registry::HKEY_LOCAL_MACHINE",
        "Software",
        (& { if ([Environment]::Is64BitOperatingSystem) { "WOW6432Node" } else { "" } }),
        "Microsoft",
        "Windows",
        "CurrentVersion",
        "Uninstall"
    ).Where({ $_ -ne "" }) -Join "\"
    $VM_KEY = "VB:Voicemeeter {17359A74-1236-5467}"

    try {
        return $(Get-ItemPropertyValue -Path (@($REG_KEY, $VM_KEY) -Join "\") -Name UninstallString | Split-Path -Parent)
    }
    catch {
        throw [VMRemoteError]::new("Unable to fetch Voicemeeter path from the Registry.")
    }
}
