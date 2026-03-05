[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/onyx-and-iris/voicemeeter-api-powershell/blob/dev/LICENSE)

# Powershell Wrapper for Voicemeeter API

This module offers a Powershell interface for the Voicemeeter Remote C API.

For past/future changes to this project refer to: [CHANGELOG](CHANGELOG.md)

## Tested against

- Basic 1.1.2.2
- Banana 2.1.2.2
- Potato 3.1.2.2

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

The following Strip properties are available:

- mute: bool
- mono: bool
- mc: bool
- k/karaoke: int, from 0 to 4
- solo: bool
- A1-A5: bool
- B1-B3: bool
- vaio: bool
- limit: float, from -40.00 to 12.00
- gain: float, from -60.00 to 12.00
- label: string
- reverb: float, from 0.00 to 10.00
- delay: float, from 0.00 to 10.00
- fx1: float, from 0.00 to 10.00
- fx2: float, from 0.00 to 10.00
- pan_x: float, from -0.50 to 0.50
- pan_y: float, physical: from 0.00 to 1.00, virtual: from -0.50 to 0.50
- color_x: float, from -0.50 to 0.50
- color_y: float, from 0.00 to 1.00
- fx_x: float, from -0.50 to 0.50
- fx_y: float, from 0.00 to 1.00
- postreverb: bool
- postdelay: bool
- postfx1: bool
- postfx2: bool
- eqgain1/bass/low: float, from -12.00 to 12.00
- eqgain2/mid/med: float, from -12.00 to 12.00
- eqgain3/treble/high: float, from -12.00 to 12.00

for example:

```powershell
$vmr.strip[6].karaoke = 3
$vmr.strip[0].limit = 4.5
$vmr.strip[2].label = 'example'
$vmr.strip[7].pan_y = -0.38
$vmr.strip[5].treble = -2.43
```

The following Strip methods are available:

- AppGain($appname or $appindex, $gain) : string or int, float, from 0.00 to 1.00
- AppMute($appname or $appindex, $mutestate) : string or int, bool

for example:

```powershell
$vmr.strip[5].AppGain("Spotify", 0.5)
$vmr.strip[5].AppMute("Spotify", $true)
$vmr.strip[7].AppGain(0, 0.28)
$vmr.strip[6].AppMute(2, $false)
```

A,B properties depend on Voicemeeter type.
mc, k for virtual strips only.

#### comp

The following Strip.comp properties are available:

- knob: float, from 0.00 to 10.00
- gainin: float, from -24.00 to 24.00
- ratio: float, from 1.00 to 8.00
- threshold: float, from -40.00 to -3.00
- attack: float, from 0.00 to 200.00
- release: float, from 0.00 to 5000.00
- knee: float, 0.00 to 1.00
- gainout: float, from -24.00 to 24.00
- makeup: bool

for example:

```powershell
$vmr.strip[3].comp.attack = 8.5
```

#### gate

The following Strip.gate properties are available:

- knob: float, from 0.00 to 10.00
- threshold: float, from -60.00 to -10.00
- damping: float, from -60.00 to -10.00
- bpsidechain: float, from 100.00 to 4000.00
- attack: float, from 0.00 to 1000.00
- hold: float, from 0.00 to 5000.00
- release: float, from 0.00 to 5000.00

for example:

```powershell
$vmr.strip[3].gate.threshold = -40.5
```

#### denoiser

The following Strip.denoiser properties are available:

- knob: float, from 0.00 to 10.00
- threshold: float, from 0.00 to 10.00

for example:

```powershell
$vmr.strip[3].denoiser.knob = 5
```

#### pitch

The following Strip.pitch properties are available:

- on: bool
- drywet: float, from -100.00 to 100.00
- pitchvalue: float, from -12.00 to 12.00
- loformant: float, from -12.00 to 12.00
- medformant: float, from -12.00 to 12.00
- hiformant: float, from -12.00 to 12.00

The following Strip.pitch methods are available:

- RecallPreset($presetIndex) : int, from 0 to 7

for example:

```powershell
$vmr.strip[2].pitch.recallpreset(4)
$vmr.strip[4].pitch.drywet = -22.86
$vmr.strip[1].pitch.medformant = 2.1
```

#### audibility

The following Strip.audibility properties are available:

- knob: float, from 0.00 to 10.00

for example:

```powershell
$vmr.strip[1].audibility.knob = 2.66
```

#### gainlayer[i]

The following Strip.gainlayer[i] methods are available:

- Set($val) : float, from -60.00 to 12.00
- Get()

for example:

```powershell
$vmr.strip[4].gainlayer[7].set(-26.81)
```

#### levels

The following Strip.levels methods are available:

- PreFader()
- PostFader()
- PostMute()

for example:

```powershell
$vmr.strip[2].levels.PreFader() -Join ', ' | Write-Host
```

### Bus

The following Bus properties are available:

- mute: bool
- sel: bool
- monitor: bool
- vaio: bool
- mono: int, 0 off, 1 mono, 2 stereo reverse
- gain: float, from -60.00 to 12.00
- label: string
- returnreverb: float, from 0.00 to 10.00
- returndelay: float, from 0.00 to 10.00
- returnfx1: float, from 0.00 to 10.00
- returnfx2: float, from 0.00 to 10.00

for example:

```powershell
$vmr.bus[3].returnreverb = 5.7
```

#### modes

The following Bus.mode members are available:

- normal: bool
- amix: bool
- bmix: bool
- repeat: bool
- composite: bool
- tvmix: bool
- upmix21: bool
- upmix41: bool
- upmix61: bool
- centeronly: bool
- lfeonly: bool
- rearonly: bool

The following Bus.mode methods are available:

- Set($mode) : string, sets the current bus mode
- Get() : returns the current bus mode

for example:

```powershell
$vmr.bus[0].mode.centeronly = $true
$vmr.bus[0].mode.Set('tvmix')
```

#### levels

The following Bus.levels methods are available:

- All()

for example:

```powershell
$vmr.bus[2].levels.All() -Join ', ' | Write-Host
```

### Strip|Bus

The following Strip | Bus methods are available:

- FadeTo(amount, time) : float, int
- FadeBy(amount, time) : float, int

Modify gain to or by the selected amount in db over a time interval in ms.

for example:

```powershell
$vmr.strip[3].FadeTo(-18.75, 1000)
$vmr.bus[0].FadeBy(-10, 500)
```

#### device

The following Strip.device | Bus.device properties are available:

- name: string
- driver: string
- sr: int
- wdm: string
- ks: string
- mme: string
- asio: string

The following Strip.device | Bus.device methods are available:

- Set($device) : PSObject, where device is a PSObject with properties Driver and Name
- Get() : PSObject, returns a PSObject with properties Driver, Name, HardwareId, and IsOutput
- Clear() : Clears the currently selected device

for example:

```powershell
$vmr.strip[0].device.wdm = "Mic|Line|Instrument 1 (Audient EVO4)"
$vmr.bus[0].device.name | Write-Host

$device = $vmr.strip[3].device.Get()
$vmr.strip[1].device.Set($device)    # moves the device selected for strip 4 to strip 2

$vmr.bus[2].device.Clear()
```

name, driver, sr are defined as read only.
wdm, ks, mme, asio are defined as write only.
asio only defined for Bus[0].Device

#### eq

The following Strip.eq | Bus.eq properties are available:

- on: bool
- ab: bool

The following Strip.eq | Bus.eq methods are available:

- Load($filepath) : string
- Save($filepath) : string

for example:

```powershell
$vmr.strip[0].eq.on = $true
$vmr.bus[0].eq.ab = $false
```

##### channel

The following bus.eq.channel.cell properties are available:

- trim: float, from -24.00 to 24.00
- delay: float, from 0.00 to 500.00

###### cell

The following eq.channel.cell properties are available:

- on: bool
- type: int, from 0 to 6
- f: float, from 20.00 to 20000.00
- gain: float, from -36.00 to 18.00
- q: float, from 0.30 to 100.00

for example:

```powershell
$vmr.strip[2].eq.channel[1].cell[4].type = 1
$vmr.bus[5].eq.channel[6].cell[3].on = $false
```

### Macrobuttons

The following Button properties are available:

- state: bool, runs associated scripts
- stateonly: bool, does not run associated scripts
- trigger: bool

```powershell
$vmr.button[3].state = $true
$vmr.button[4].stateonly = $false
$vmr.button[5].trigger = $true
```

Index range (0, 79)

### VBAN

The following Vban properties are available:

- enable: bool
- port: int, from 1024 - 65535

for example:

```powershell
$vmr.vban.enable = $true
$vmr.vban.port = 6990
```

#### instream[i]|outstream[i]

The following Vban.instream | Vban.outstream properties are available:

- on: bool
- name: string
- ip: string

for example:

```powershell
$vmr.vban.instream[0].on = $true
$vmr.vban.outstream[9].ip = '192.168.1.154'
```

##### audio

The following audio Vban.instream | Vban.outstream properties are available:

- sr: int, (11025, 16000, 22050, 24000, 32000, 44100, 48000, 64000, 88200, 96000)
- channel: int, from 1 to 8
- bit: int, 16 or 24
- quality: int, from 0 to 4
- route: int, from 0 to 8

SR, channel and bit are defined as readonly for instreams. Attempting to write
to those parameters will throw an error. They are read and write for outstreams.

for example:

```powershell
$vmr.vban.instream[0].route = 4
$vmr.vban.outstream[3].bit = 16
```

##### midi

The following midi Vban.outstream properties are available:

- route: string, ('none', 'midi_in', 'aux_in', 'vban_in', 'all_in', 'midi_out')

for example:

```powershell
$vmr.vban.outstream[8].route = 'aux_in'
```

##### video

The following video Vban.outstream properties are available:

- vfps: int, from 1 to 30
- vformat: string, ('png', 'jpg')
- vquality: int, from 1 to 100
- vcursor: bool
- route: int, from 0 to 4

Route is currently write-only. This is a VMR bug.

for example:

```powershell
$vmr.vban.outstream[9].vformat = 'jpg'
$vmr.vban.outstream[9].vquality = 85
$vmr.vban.outstream[9].vcursor = $true
```

### Command

Certain 'special' commands are defined by the API as performing actions rather than setting values.

The following Command methods are available:

- Show()
- Hide()
- Lock()
- Unlock()
- ShowVBANChat()
- HideVBANChat()
- Restart()
- Shutdown()
- Reset() : Reset all config
- Save($filepath) : string
- Load($filepath) : string
- StorePreset($index, $name) : (int, string)
- RecallPreset($index or $name) : (int or string)
- RunMacrobuttons() : Launches the macrobuttons app
- CloseMacrobuttons() : Closes the macrobuttons app

for example:

```powershell
$vmr.command.Show()
$vmr.command.Lock()
$vmr.command.Load("path/to/filename.xml")
$vmr.command.RunMacrobuttons()

$vmr.command.StorePreset(63, 'example')
$vmr.command.StorePreset('example')
$vmr.command.StorePreset(63)                # same as StorePreset(63, '')
$vmr.command.StorePreset()                  # same as StorePreset(''), overwrites last recalled

$vmr.command.RecallPreset('example')
$vmr.command.RecallPreset(63)
$vmr.command.RecallPreset()                 # same as RecallPreset(''), recalls last recalled
```

StorePreset('') and RecallPreset('') interact with the 'selected' preset. This is highlighted green in the GUI. Recalling a preset selects it. Storing a preset via GUI also selects it. Storing a preset with StorePreset does not select it.

### Fx

The following Fx properties are available:

- Reverb.on: bool
- Reverb.ab: bool
- Delay.on: bool
- Delay.ab: bool

for example:

```powershell
$vmr.fx.reverb.ab = $false
```

### Patch

The following Patch properties are available:

- postFaderComposite: bool
- postFxInsert: bool

The following Patch members have methods Set($val) | Get() available:

- asio[i]: int, from 0 to ASIO input channels
- OutA2[i]-OutA5[i]: int, from 0 to ASIO output channels
- composite[i]: int, from 0 to strip channels
- insert[i]: bool

for example:

```powershell
$vmr.patch.asio[3].set(2)        # patches ASIO input channel 2 (2) to strip 2, channel 2 (3)
$vmr.patch.OutA3[0].set(24)      # patches bus A3, channel 1 (0) to ASIO output channel 24
$vmr.patch.composite[5].set(0)   # sets composite channel 6 (5) to default bus channel
$vmr.patch.insert[4].get()
```

### Option

The following Option properties are available:

- sr: int, (32000, 44100, 48000, 88200, 96000, 176400, 192000)
- asiosr: bool
- monitorOnSel: bool
- sliderMode: bool
- monitoringBus: int, from 0 to bus index

for example:

```powershell
$vmr.Option.sliderMode = $false   # sets slider mode to absolute
```

#### buffers

The following Option.buffer properties are available:

- mme: int, (441, 480, 512, 576, 640, 704, 768, 896, 1024, 1536, 2048)
- wdm: int, (128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 441, 448, 480, 512, 576, 640, 704, 768, 1024, 1536, 2048)
- ks: int, (128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 441, 448, 480, 512, 576, 640, 704, 768, 1024, 1536, 2048)
- asio: int, (0, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 441, 448, 480, 512, 576, 640, 704, 768, 1024)

for example:

```powershell
$vmr.Option.buffer.wdm = 512
$vmr.Option.buffer.asio = 0    # to use default buffer size
```

#### delay[i]

The following Option.delay[i] methods are available:

- Set($val) : float, from 0.00 to 500.00
- Get()

for example:

```powershell
$vmr.Option.delay[2].set(30.26)   # sets the delay for the third (2) bus
```

### Recorder

The following Recorder properties are available:

- A1 - A5: bool
- B1 - B3: bool
- gain: float, from -60.00 to 12.00
- armedbus: int, from 0 to bus index
- state: string, ('play', 'stop', 'record', 'pause')
- prerectime: int, from 0 to 20 seconds
- prefix: string, write-only
- filetype: string, write-only, ('wav', 'aiff', 'bwf', 'mp3')
- samplerate: int, (22050, 24000, 32000, 44100, 48000, 88200, 96000, 176400, 192000)
- bitresolution: int, (8, 16, 24, 32)
- channel: int, (2, 4, 6, 8)
- kbps: int, (32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320)

for example:

```powershell
$vmr.recorder.A1 = $true
$vmr.recorder.filetype = 'mp3'
$vmr.recorder.kbps = 256
```

The following Recorder methods are available:

- Play()
- Stop()
- Replay()
- FF()
- Rew()
- Record()
- Pause()
- Eject()
- Load($filepath) : string
- GoTo($timestring) : string, must match the format 'hh:mm:ss'

for example:

```powershell
$vmr.recorder.play()
$vmr.recorder.GoTo("00:01:15")  # go to 1min 15sec into track
```

#### mode

The following Recorder.mode properties are available:

- recbus: bool
- playonload: bool
- loop: bool
- multitrack: bool

for example:

```powershell
$vmr.recorder.mode.loop = $true
```

#### armstrip[i]|armbus[i]

The following Recorder.armstrip | Recorder.armbus methods are available:

- Set($val) : bool
- Get()

for example:

```powershell
$vmr.recorder.armstrip[0].Set($true)
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

Access to lower level device enumeration functions are provided with these functions:

- `$vmr.GetInputCount()`: Returns the number of available input devices.
- `$vmr.GetOutputCount()`: Returns the number of available output devices.
- `$vmr.GetInputDevice($index)`: Returns a PSObject with properties Driver, Name, HardwareId, and IsOutput for the input device at the given index.
- `$vmr.GetOutputDevice($index)`: Returns a PSObject with properties Driver, Name, HardwareId, and IsOutput for the output device at the given index.

```powershell
$count = $vmr.GetInputCount()
for ($i = 0; $i -lt $count; $i++) {
    $device = $vmr.GetInputDevice($i)
    Write-Host "Input Device $i: $($device.Driver) - $($device.Name)"
}
```

### Errors

- `VMRemoteError`: Base custom error class.
- `LoginError`: Raised when a login error occurs.
- `CAPIError`: Raised when a C-API function returns an error code.
  - The following class properties are available:
    - `function`: The name of the C-API function that returned the error code.
    - `code`: The error code.

### Run tests

Parameters:

- `kind`: Run tests of this kind
- `tag`: Run tests tagged with this marker (currently `higher` or `lower`)

*with Task*

```console
task test -- -t "higher" -k "banana"
```

### Official Documentation

- [Voicemeeter Remote C API](https://github.com/onyx-and-iris/Voicemeeter-SDK/blob/main/VoicemeeterRemoteAPI.pdf)
