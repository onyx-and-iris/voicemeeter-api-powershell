# Powershell Wrapper for Voicemeeter API
This wrapper was written in response to a request in the VB-AUDIO discord for
a way to invoke commands using Powershell. It is designed to be simple to use
but not every feature is added.

For past/future changes to this project refer to: [CHANGELOG](CHANGELOG.md)

## Tested against
- Basic 1.0.7.8
- Banana 2.0.5.8
- Potato 3.0.1.8

You may have success with many commands in earlier versions but some commands
(example Macrobuttons) were only added to the API in later releases.

## Requirements
- Voicemeeter: https://voicemeeter.com/
- Powershell 5.1

## Installation
#### Powershell:
`Install-Module Voicemeeter`

You will need to add PSGallery as a trusted repository source.
More info: [PSGallery](https://www.powershellgallery.com/)

#### Direct download:
`git clone https://github.com/onyx-and-iris/voicemeeter-api-powershell.git`

All examples in this readme assume you've installed as a module.
If you decide to direct download see [alternative instructions](FROM_SOURCE.md).

## Use
When you instantiate Remote class you will automatically be logged in. Use a
try finally block to ensure you logout at the end of your code.
```powershell
Import-Module Voicemeeter

try {
    # Run the factory function for required Voicemeeter type
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

Voicemeeter factory function can be:
- Get-RemoteBasic
- Get-RemoteBanana
- Get-RemotePotato

There is no bounds checking in this wrapper, meaning if you attempt to set a
parameter that does not exist for that version of Voicemeeter the wrapper will
throw an error. So make sure what you are settings actually exists.

### Multiple parameters
Set many strip/bus parameters at once, for Example
```powershell
Import-Module Voicemeeter

try {
    $hash = @{
        "Strip[0].Mute" = $true
        "Strip[1].Mute" = $true
        "Strip[2].Mute" = $false
        "Strip[0].Mono" = $true
        "Strip[1].Mono" = $false
        "Strip[2].Mono" = $true
    }

    $vmr.Set_Multi($hash)
}
finally { $vmr.Logout() }
```

### Macrobuttons
Three modes defined: state, stateonly and trigger.
- State runs associated scripts
- Stateonly does not run associated scripts
- Index range (0, 69)

```
$vmr.button[3].state = $true

$vmr.button[4].stateonly = $false

$vmr.button[5].trigger = $true
```

### Run tests
Run tests using invoke-pester in powershell console from test directory.

Alternatively you may use .\runall.ps1 which accepts two parameters:
- tag Run tests of this type
- num Run this number of tests

Current test types are 'higher' and 'lower'

Example:
`.\runall.ps1 -tag 'higher' -num 3`
