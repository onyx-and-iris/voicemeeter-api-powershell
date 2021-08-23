Import-Module Voicemeeter

try {
    $vmr = Get-RemoteBanana
    
    $vmr.command.show
    $vmr.command.restart
    $vmr.command.showvbanchat
}
finally { $vmr.Logout() }
