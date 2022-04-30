[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/onyx-and-iris/voicemeeter-api-powershell/blob/dev/LICENSE)

# Powershell Wrapper for Voicemeeter API

This module offers a Powershell interface for the Voicemeeter Remote C API.

For past/future changes to this project refer to: [CHANGELOG](CHANGELOG.md)

## Tested against

-   Basic 1.0.8.1
-   Banana 2.0.6.1
-   Potato 3.0.2.1

## Requirements

-   [Voicemeeter](https://voicemeeter.com/)
-   Powershell 5.1

## Installation

#### PowerShellGet:

In Powershell as admin:

`Install-Module Voicemeeter`

In Powershell as current user:

`Install-Module -Name Voicemeeter -Scope CurrentUser`

You may be asked to install NuGet provider required by PowerShellGet if you don't have it already.

When prompted you will need to accept PSGallery as a trusted repository.

More Info:

-   [PowerShellGet](https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-7.1)
-   [NuGet](https://www.powershellgallery.com/packages/NuGet/1.3.3)
-   [PSGallery](https://docs.microsoft.com/en-gb/powershell/scripting/gallery/overview?view=powershell-7.1)

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

-   Get-RemoteBasic
-   Get-RemoteBanana
-   Get-RemotePotato

### Strip

The following strip commands are available:

-   mute: bool
-   mono: bool
-   mc: bool
-   k: int, from 0 to 4
-   solo: bool
-   A1-A5: bool
-   B1-B3: bool
-   limit: int, from -40 to 12
-   gain: float, from -60 to 12
-   comp: float, from 0 to 10
-   gate: float, from 0 to 10
-   gainlayer0-gainlayer7: float

for example:

```
$vmr.strip[5].gainlayer1 = -8.3
```

A,B commands depend on Voicemeeter type.

gainlayers defined for Potato version only.

mc, k for virtual strips only.

### Bus

The following bus commands are available:

-   mute: bool
-   mono: bool
-   eq: bool
-   limit: int, from -40 to 12
-   gain: float, from -60 to 12
-   mode\_: bool, any of the following:
    @('normal', 'amix', 'bmix', 'repeat', 'composite', 'tvmix', 'upmix21',
    'upmix41', 'upmix61', 'centeronly', 'lfeonly', 'rearonly')

for example:

```
$vmr.bus[3].mode_repeat = $true
```

### Macrobuttons

Three modes defined: state, stateonly and trigger.

-   State runs associated scripts
-   Stateonly does not run associated scripts
-   Index range (0, 69)

```
$vmr.button[3].state = $true

$vmr.button[4].stateonly = $false

$vmr.button[5].trigger = $true
```

### VBAN

-   vmr.vban.enable: Toggle VBAN on or off. Accepts a boolean value.

For each vban in/out stream the following parameters are defined:

-   on: boolean
-   name: string
-   ip: string
-   port: int from 1024 - 65535
-   sr: int (11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
-   channel: int from 1 to 8
-   bit: int 16 or 24
-   quality: int from 0 to 4
-   route: int from 0 to 8

SR, channel and bit are defined as readonly for instreams. Attempting to write
to those parameters will throw an error. They are read and write for outstreams.

example:

```powershell
$vmr.vban.enable = $true

$vmr.vban.instream[0].on = $true
$vmr.vban.instream[2].port = 6990
$vmr.vban.outstream[3].bit = 16
```

### Command

Certain 'special' commands are defined by the API as performing actions rather than setting values.

The following methods are available:

-   show
-   hide
-   restart
-   shutdown

The following properties are write only and accept boolean values:

-   showvbanchat
-   lock

example:

```powershell
$vmr.command.show

$vmr.command.lock = $true
```

### Recorder

The following methods are available:

-   play
-   stop
-   pause
-   record
-   ff
-   rw

The following properties accept boolean values.

-   loop
-   A1 - A5
-   B1 - B3

example:

```powershell
$vmr.recorder.play

$vmr.recorder.loop = $true
```

### Multiple parameters

Set many strip/bus/macrobutton/vban parameters at once, for Example

```powershell
Import-Module Voicemeeter

try {
    $vmr = Get-RemoteBanana

    $hash = @{
        strip_0 = @{mute = $true; mono = $true};
        strip_2 = @{mute = $true; mono = $true};
        bus_1 = @{mute = $true; mono = $true};

        button_34 = @{state = $true};
        button_12 = @{trigger = $false};

        vban_instream_3 = @{name = 'streamname'};
        vban_outstream_0 = @{on = $false};
    }

    $vmr.Set_Multi($hash)
}
finally { $vmr.Logout() }
```

### Remote class

Access to lower level Getters and Setters are provided with these functions:

-   `$vmr.Getter(param)`: For getting the value of a parameter expected to return a value other than string.
-   `$vmr.Getter_String(param)`: For getting the value of any parameter expected to return a string.
-   `$vmr.Setter(param, value)`: For setting the value of any parameter.

Access to lower level polling functions are provided with these functions:

-   `$vmr.PDirty`: Returns true if a parameter has been updated.
-   `$vmr.MDirty`: Returns true if a macrobutton has been updated.

example:

```powershell
$vmr.Getter('Strip[2].Mute')
$vmr.Getter_String('Bus[1].Label')
$vmr.Setter('Strip[4].Label', 'stripname')
$vmr.Setter('Strip[0].Gain', -3.6)
```

### Config Files

`$vmr.Set_Profile('config')`

You may load config files in psd1 format. An example profile has been included with the package. Remember to save current settings before loading a profile. To test simply rename \_profiles directory to profiles. It will be loaded into memory but not set. To set one you may do:

```powershell
Import-Module Voicemeeter
try {
    $vmr = Get-RemoteBanana
    $vmr.Set_Profile("config")
}
finally { $vmr.Logout() }
```

will load a config file at profiles/banana/config.psd1 for Voicemeeter Banana.

### Run tests

Run tests using .\runall.ps1 which accepts two parameters:

-   tag Run tests of this type
-   num Run this number of tests

Current test types are 'higher' and 'lower'

Example:
`.\runall.ps1 -tag 'higher' -num 3`

Results will be logged and summary file written.

### Official Documentation

-   [Voicemeeter Remote C API](https://forum.vb-audio.com/viewtopic.php?f=8&t=346)
