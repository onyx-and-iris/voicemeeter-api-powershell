Function Get_VBPath {
    @(
        'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall',
        'Registry::HKEY_LOCAL_MACHINE\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    ) | ForEach-Object {
        if(Test-Path -Path $_) {
            (Get-ChildItem -Path $_\*) | ForEach-Object {
                if($_.Name.Contains("Voicemeeter")) {
                    $reg = -join("Registry::", $_.Name)
                    return $(Get-ItemPropertyValue -Path $reg -Name UninstallString | Split-Path -Parent)
                }
            }
        }
    }
}
