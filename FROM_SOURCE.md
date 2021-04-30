#### Direct download:
All commands remain the same, the only difference when you download from source is how you load scripts.
You will need to dot source the Voicemeeter.ps1 since you won't have it installed as a module

Instead of `Import-Module Voicemeeter` use `. .\lib\voicemeeter.ps1` (from repository root)

and call remote class directly, so: `$vmr = [Remote]::new('banana')`

Where you pass it a Voicemeeter type argument. Type can be one of:
- basic
- banana
- potato

Simple example if using from source:

```powershell
. .\lib\voicemeeter.ps1

try {
    # Pass a Voicemeeter type as argument
    $vmr = [Remote]::new('banana')

    # Set strip and bus params
    $vmr.strip[0].mono = $true
    $vmr.strip[0].mono  '=> $true'
    $vmr.bus[1].mute = $false
    $vmr.bus[1].mute    '=> $false'

    # Set macrobutton with id 4, mode state to 1
    $vmr.button[4].state = $true
    $vmr.button[4].state    '=> $true'
}
finally { $vmr.Logout() }
```
