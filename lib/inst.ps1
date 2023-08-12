function Get_VMPath {
    $reg_path = "Registry::HKEY_LOCAL_MACHINE\Software" + `
    (& { if ([Environment]::Is64BitOperatingSystem) { "\WOW6432Node" } else { "" } }) + `
        "\Microsoft\Windows\CurrentVersion\Uninstall"
    $vm_key = "\VB:Voicemeeter {17359A74-1236-5467}\"

    return $(Get-ItemPropertyValue -Path ($reg_path + $vm_key) -Name UninstallString | Split-Path -Parent)
}
