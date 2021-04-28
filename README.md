# Powershell Wrapper for Voicemeeter API
This wrapper was written in response to a request in the VB-AUDIO discord for
a way to invoke commands using Powershell. It is designed to be simple to use
but not every feature is added.

## Tested against
- Basic 1.0.7.8
- Banana 2.0.5.8
- Potato 3.0.1.8

You may have success with many commands in earlier versions but some commands
(example Macrobuttons) were only added to the API in later releases.

## Requirements
- Voicemeeter: https://voicemeeter.com/
- Powershell 5.1

## Use
You may use try, finally blocks to ensure you login and logout.
```powershell
. $PSScriptRoot\lib\voicemeeter.ps1

try {
    # pass a Voicemeeter type to class Remote
    $vmr = [Remote]::new('banana')
    $vmr.Login()

    # Set macrobutton with id 4, mode state to 1
    $vmr.button[4].state = 1
    $vmr.button[4].state

    # Set strip and bus params
    $vmr.strip[0].mono = 1
    $vmr.strip[0].mono
    $vmr.bus[1].mute = 0
    $vmr.bus[1].mute
}
finally
{
    $vmr.Logout()
}
```

Voicemeeter type can be one of:
- basic
- banana
- potato

There is no bounds checking in this wrapper, meaning if you attempt to set a
parameter that does not exist for that version of Voicemeeter the wrapper will
throw an error and crash. So make sure what you are settings actually exists.

### Macrobuttons
Three modes defined: state, stateonly and trigger.
- State runs associated scripts
- Stateonly does not run associated scripts
- Index range (0, 69)

```
$vmr.button[3].state = 1

$vmr.button[4].stateonly = 0

$vmr.button[5].trigger = 1
```

### Run tests
Run tests using invoke-pester in powershell console from test directory.

Alternatively you may use .\runall.ps1 which accepts two parameters:
- tag Run tests of this type
- num Run this number of tests

Current test types are 'higher' and 'lower'

Example:
`.\runall.ps1 -tag 'higher' -num 3`
