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
#### PowerShellGet:
In Powershell as admin:

`Install-Module Voicemeeter`

In Powershell as current user:

`Install-Module -Name Voicemeeter -Scope CurrentUser`

You may be asked to install NuGet provider required by PowerShellGet if you don't have it already.

When prompted you will need to accept PSGallery as a trusted repository.

More Info:
- [PowerShellGet](https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-7.1)
- [NuGet](https://www.powershellgallery.com/packages/NuGet/1.3.3)
- [PSGallery](https://docs.microsoft.com/en-gb/powershell/scripting/gallery/overview?view=powershell-7.1)

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
Set many strip/bus/macrobutton parameters at once, for Example
```powershell
Import-Module Voicemeeter

try {
    $vmr = Get-RemoteBanana

    $hash = @{
        strip_0 = @{mute = $true; mono = $true};
        strip_2 = @{mute = $true; mono = $true};
        bus_1 = @{mute = $true; mono = $true};

        mb_34 = @{state = $true};
        mb_12 = @{trigger = $false};
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
Run tests using .\runall.ps1 which accepts two parameters:
- tag Run tests of this type
- num Run this number of tests

Current test types are 'higher' and 'lower'

Example:
`.\runall.ps1 -tag 'higher' -num 3`

Results will be logged and summary file written.
