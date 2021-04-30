#### Direct download:
The only difference when you download from source is how you load scripts.
You will need to Import-Module by relative location, for example:

Instead of `Import-Module Voicemeeter` use `Import-Module .\lib\Voicemeeter.psm1` (from repository root)

Everything else remains the same

Simple example if using from source:

```powershell
Import-Module .\lib\Voicemeeter.psm1

try {
    # Pass a Voicemeeter type as argument
    $vmr = Get-RemoteBanana

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
