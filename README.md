[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/onyx-and-iris/voicemeeter-api-powershell/blob/dev/LICENSE)

# Powershell Wrapper for Voicemeeter API

This module offers a Powershell interface for the Voicemeeter Remote C API.

For past/future changes to this project refer to: [CHANGELOG](CHANGELOG.md)

## Tested against

- Basic 1.0.8.8
- Banana 2.0.6.8
- Potato 3.0.2.8

## Requirements

- [Voicemeeter](https://voicemeeter.com/)
- Powershell 5.1+ or Powershell 7.2+

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

#### `Script files`

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

Added in `v3` you may also use the following entry/exit points:

- Connect-Voicemeeter
- Disconnect-Voicemeeter

`Connect-Voicemeeter` takes a single parameter `Kind`.

for example:

```powershell
$vmr = Connect-Voicemeeter -Kind "potato"
...
Disconnect-Voicemeeter
```

#### `Through the Shell`

One liners should be run through a subshell, you may pipe the Remote object to a script block, for example:

```powershell
powershell { Get-RemoteBanana | % { $_.strip[0].mute=$true; $_.Logout() } }
```

You may also save the object returned by a factory function to a local variable, then invoke any commands through the shell, for example:

```powershell
$vmr = Get-RemoteBanana
$vmr.strip[0].mute=1
$vmr.strip[0].mute
$vmr.Logout()
```

### Strip

The following strip commands are available:

- mute: boolean
- mono: boolean
- mc: boolean
- k: int, from 0 to 4
- solo: boolean
- A1-A5: boolean
- B1-B3: boolean
- limit: int, from -40 to 12
- gain: float, from -60.0 to 12.0
- label: string
- reverb: float, from 0.0 to 10.0
- delay: float, from 0.0 to 10.0
- fx1: float, from 0.0 to 10.0
- fx2: float, from 0.0 to 10.0
- pan_x: float, from -0.5 to 0.5
- pan_y: float, from 0.0 to 1.0
- color_x: float, from -0.5 to 0.5
- color_y: float, from 0.0 to 1.0
- fx_x: float, from -0.5 to 0.5
- fx_y: float, from 0.0 to 1.0
- postreverb: boolean
- postdelay: boolean
- postfx1: boolean
- postfx2: boolean
- gainlayer0-gainlayer7: float

for example:

```powershell
$vmr.strip[5].gainlayer1 = -8.3
```

A,B commands depend on Voicemeeter type.

gainlayers defined for Potato version only.

mc, k for virtual strips only.

#### comp

The following strip.comp commands are available:

- knob: float, from 0.0 to 10.0
- gainin: float, from -24.0 to 24.0
- ratio: float, from 1.0 to 8.0
- threshold: float, from -40.0 to -3.0
- attack: float, from 0.0 to 200.0
- release: float, from 0.0 to 5000.0
- knee: float, 0.0 to 1.0
- gainout: float, from -24.0 to 24.0
- makeup: boolean

for example:

```powershell
$vmr.strip[3].comp.attack = 8.5
```

#### gate

The following strip.gate commands are available:

- knob: float, from 0.0 to 10.0
- threshold: float, from -60.0 to -10.0
- damping: float, from -60.0 to -10.0
- bpsidechain: int, from 100 to 4000
- attack: float, from 0.0 to 1000.0
- hold: float, from 0.0 to 5000.0
- release: float, from 0.0 to 5000.0

for example:

```powershell
$vmr.strip[3].gate.threshold = -40.5
```

#### denoiser

The following strip.denoiser commands are available:

- knob: float, from 0.0 to 10.0

for example:

```powershell
$vmr.strip[3].denoiser.knob = 5
```

#### AppGain | AppMute

- `AppGain(amount, gain)` : string, float
- `AppMute(amount, mutestate)` : string, boolean

for example:

```powershell
$vmr.strip[5].AppGain("Spotify", 0.5)
$vmr.strip[5].AppMute("Spotify", $true)
```

#### levels

The following strip.level commands are available:

- PreFader()
- PostFader()
- PostMute()

for example:

```powershell
$vmr.strip[2].levels.PreFader() -Join ', ' | Write-Host
```

### Bus

The following bus commands are available:

- mute: bool
- mono: bool
- limit: int, from -40 to 12
- gain: float, from -60.0 to 12.0
- label: string
- returnreverb: float, from 0.0 to 10.0
- returndelay: float, from 0.0 to 10.0
- returnfx1: float, from 0.0 to 10.0
- returnfx2: float, from 0.0 to 10.0

for example:

```powershell
$vmr.bus[3].returnreverb = 5.7
```

#### modes

The following bus.mode members are available:

- normal: boolean
- amix: boolean
- bmix: boolean
- repeat: boolean
- composite: boolean
- tvmix: boolean
- upmix21: boolean
- upmix41: boolean
- upmix61: boolean
- centeronly: boolean
- lfeonly: boolean
- rearonly: boolean

The following bus.mode commands are available:

- Get(): returns the current bus mode.

for example:

```powershell
$vmr.bus[0].mode.centeronly = $true

$vmr.bus[0].mode.Get()
```

#### levels

The following strip.level commands are available:

- All()

for example:

```powershell
$vmr.bus[2].levels.All() -Join ', ' | Write-Host
```

### Strip|Bus

#### device

The following strip.device | bus.device commands are available:

- name: string
- sr: int
- wdm: string
- ks: string
- mme: string
- asio: string

for example:

```powershell
$vmr.strip[0].device.wdm = "Mic|Line|Instrument 1 (Audient EVO4)"
$vmr.bus[0].device.name
```

name, sr are defined as read only.
wdm, ks, mme, asio are defined as write only.

#### eq

The following strip.eq | bus.eq commands are available:

- on: boolean
- ab: boolean

for example:

```powershell
$vmr.strip[0].eq.on = $true
$vmr.bus[0].eq.ab = $false
```

#### FadeTo | FadeBy

- `FadeTo(amount, time)` : float, int
- `FadeBy(amount, time)` : float, int

Modify gain to or by the selected amount in db over a time interval in ms.

for example:

```powershell
$vmr.strip[3].FadeTo(-18.7, 1000)
$vmr.bus[0].FadeBy(-10, 500)
```

### Macrobuttons

Three modes defined: state, stateonly and trigger.

- State runs associated scripts
- Stateonly does not run associated scripts
- Index range (0, 69)

```powershell
$vmr.button[3].state = $true

$vmr.button[4].stateonly = $false

$vmr.button[5].trigger = $true
```

### VBAN

- vmr.vban.enable: Toggle VBAN on or off. Accepts a boolean value.

For each vban in/out stream the following parameters are defined:

- on: boolean
- name: string
- ip: string
- port: int from 1024 - 65535
- sr: int (11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
- channel: int from 1 to 8
- bit: int 16 or 24
- quality: int from 0 to 4
- route: int from 0 to 8

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

- show
- hide
- restart
- shutdown
- Load(filepath)

The following properties are write only and accept boolean values:

- showvbanchat
- lock

example:

```powershell
$vmr.command.show

$vmr.command.lock = $true

$vmr.command.Load("path/to/filename.xml")
```

### Recorder

The following methods are available:

- play
- stop
- pause
- record
- ff
- rew

The following properties accept boolean values.

- loop
- A1 - A5
- B1 - B3

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

### Config Files

`$vmr.Set_Profile(<configname>)`

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

### Remote class

Access to lower level Getters and Setters are provided with these functions:

- `$vmr.Getter(param)`: For getting the value of a parameter expected to return a value other than string.
- `$vmr.Getter_String(param)`: For getting the value of any parameter expected to return a string.
- `$vmr.Setter(param, value)`: For setting the value of any parameter.

```powershell
$vmr.Getter('Strip[2].Mute')
$vmr.Getter_String('Bus[1].Label')
$vmr.Setter('Strip[4].Label', 'stripname')
$vmr.Setter('Strip[0].Gain', -3.6)
```

- `$vmr.SendText`: Set parameters by script

```powershell
 $vmr.SendText("strip[0].mute=1;strip[2].gain=3.8;bus[1].eq.On=1")
```

Access to lower level polling functions are provided with these functions:

- `$vmr.PDirty`: Returns true if a parameter has been updated.
- `$vmr.MDirty`: Returns true if a macrobutton has been updated.

### Run tests

Run tests using .\tests\pre-commit.ps1 which accepts the following parameters:

- `kind`: Run tests of this kind
- `tag`: Run tests tagged with this marker (currently `higher` or `lower`)
- `num`: Run this number of tests
- `log`: Write summary log file

Run tests from repository root in a subshell and write logs, like so:

`powershell .\tests\pre-commit.ps1 -k "potato" -t "higher" -log`

### Official Documentation

- [Voicemeeter Remote C API](https://github.com/onyx-and-iris/Voicemeeter-SDK/blob/update-docs/VoicemeeterRemoteAPI.pdf)
