# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Before any major/minor/patch is released all unit tests will be run to verify they pass.

## [Unreleased] These changes have not been added to PSGallery yet

## [4.2.0] - 2026-03-15

### Added

- New Remote methods for device enumeration:
  - GetInputCount()
  - GetOutputCount()
  - GetInputDevice($index)
  - GetOutputDevice($index)

- New IODevice property `driver` to get the driver type of the current device (e.g. 'wdm', 'mme', etc.)

- New IODevice methods to get, set, or clear the current device for a strip or bus:
  - Get(): returns a PSObject with properties Driver, Name, HardwareId, and IsOutput
  - Set($device): accepts a PSObject with properties Driver, Name, and IsOutput
  - Clear()

## [4.1.0] - 2025-12-23

### Added

- Bus.EQ.Channel.Trim
- Bus.EQ.Channel.Delay

- MIDI Vban.Outstream.Route: 'none', 'midi_in', 'aux_in', 'vban_in', 'all_in', 'midi_out'
- Video Vban.Outstream
  - Vban.Outstream.Vfps
  - Vban.Outstream.Vformat: 'png', 'jpg'
  - Vban.Outstream.Vquality
  - Vban.Outstream.Vcursor
  - Vban.Outstream.Route (VMR bug: currently write-only)

### Changed

- `on`, `name`, `ip` now read/write on all streams
- Simple ranges of consecutive integers moved to `AddIntMembers`
  - Retained warning for `sr` and anything with atypical behavior, consistent with the rest of the module
  - Retained warning for `port` because Voicemeeter will allow this to be set below 1024
- Audio instream/outstream divergent behavior via 'if' dropped in favor of explicit separation in derived classes

- Updated EQ.Channel.Cell.Gain range in README

## [4.0.0] - 2025-12-16

This release introduces some breaking changes, the affected classes are Command, Recorder and Strip.

### Breaking Changes

- Some of the Command properties have been converted to methods. See Command section in README for more details.
- Recorder.loop removed, it can be accessed through {Recorder}.{Mode}.loop.
- Recorder.FileType changed from method to write-only property.
- Strip Gainlayers are now defined by their own class and may be accessed through {Strip}.Gainlayer[i]. 
  - The previous {Strip}.gainlayer{i} properties have been removed.

### Changed

- Meta functions can now take a -ReadOnly or -WriteOnly switch parameter
- Meta: AddBoolMembers, AddIntMembers $arg types for consistency
- Float getters/setters now default to two decimal places.
- Device: explicit $arg types for consistency
- Device members now added with meta functions

- some vban.instream | vban.outstream commands now added with meta functions
  - on
  - name
  - ip
- cast vban getters to types for consistency

- Recorder.Armstrip|Armbus -> BoolArrayMember: now have .Get()
- Cast Recorder getters to types for consistency
- Recorder.Prefix now added with AddStringMembers

- Strip.Mono is now an alias for Strip.MC on virtual strips
- Strip.AppMute|AppGain can now take an app index; see README for details
- Strip Knob setters: explicit $arg types for consistency

### Added

- IRemote abstract base class serves as a launching point for the higher classes.
- ArrayMember classes offer a common interface for array-like properties
- Patch class
- Option class
- IO classes to centralize controls common to both Strip and Bus
  - IOControl
  - IOLevels
  - IOEq
  - IODevice
- FX class

- AddAliasMembers meta function takes a hashtable `-MAP` of `alias = property`

- Vban.port sets Vban.Instream[0].port
- Vban Midi and Command streams
  - on, write-only
  - name, write-only
  - ip, write-only

- Recorder.Armedbus
- Recorder.PreRecTime
- Recorder.Prefix
- Recorder.State
- Recorder.Eject()

- Command.Reset()
- Command.Save($filepath)
- Command.StorePreset()
- Command.RecallPreset()

- Bus.Sel, Bus.Monitor, Bus.Vaio
- Bus.Mode.Set($mode)

- Strip.Karaoke alias for Strip.K
- Strip.EQGain1|EQGain2|EQGain3 with bass/low, mid/med, treble/high aliases, respectively
- StripKnob base class which defines a knob property.
- StripAudbility class which represents the audibility knob for basic kind, it subclasses StripKnob.
- Strip.Denoiser.Threshold
- Strip.VAIO.
- Strip.Pitch, StripPitch class
  - on
  - drywet
  - pitchvalue
  - loformant
  - medformant
  - hiformant
  - recallpreset($presetIndex)

### Fixed

- some vban commands incorrectly read-only/write-only
  - enable
  - instream|outstream.quality
  - instream|outstream.route
- vban.stream.port: [string]$arg -> [int]$arg
- vban route range (API documentation is incorrect)
- vban.stream.sr: $this._port -> $this._sr

- Recorder.channel values: 1..8 -> (2, 4, 6, 8)

- Bus.Mono -> [int]
  - This gives the user access to set stereo reverse.

- Strip.Limit type [int] -> [float]
- Missing closing parenthesis in AppMute value string
- Strip Knob getters: `this.Getter_String('') -> [math]::Round($this.Getter(''), 2)`

## [3.3.0] - 2024-06-29

### Added

- Add a timeout (2s) to the login function. If timeout exceeded a VMRemoteError is thrown.

### Changed

- Launch x64 bit GUIs for all kinds if on 64 bit system.

## [3.2.0] - 2023-08-17

### Added

- Debug statements added to Getters, Setters in higher classes.
- RunVoicemeeter function added to base.ps1. Accepts kind name as parameter.
- Errors section to README.

### Fixed

- All CAPIErrors are now exposed to the consumer.
  - The function name and error code can be retrieved using [CAPIError].function and [CAPIError].code
- Set_By_Script now throws [VMRemoteError] if script length exceeds 48kB.
- parameter range checks in Vban class.

## [3.1.0] - 2023-08-15

### Added

- Level methods for Strip class implemented. See Strip.levels section in README.
- Level methods for Bus class implemented. See Bus.levels section in README.
- More Recorder commands implemented. See Recorder section in README.
- RunMacrobuttons, CloseMacrobuttons added to Special class

## [3.0.0] - 2023-08-09

v3 introduces some breaking changes. They are as follows:

- Strip[i].comp now references [Comp] class. (see README for details on settings strip.comp parameters)
- Strip[i].gate now references [Gate] class. (see README for details on settings strip.gate parameters)
- Strip[i].eq now references [Eq] class. (see README for details on settings strip.eq parameters)
- Strip[i].device now references [Device] class. (see README for details on settings strip.device parameters)

- Bus[i].eq now references [Eq] class. (see README for details on settings bus.eq parameters)
- Bus[i].mode now implemented as its own class [Mode]. (see README for details on settings bus.mode parameters)

There are other changes but they should not be breaking.

### Changed

- meta functions refactored, they now use identifier() functions.
- OBS example reworked, now using obs-powershell module.
- Rethrow LoginError for unknown kind exceptions, let the consumer handle it from there.

### Added

- Entry/exit points Connect-Voicemeeter, Disconnect-Voicemeeter added to module.
- Comp, Gate, Denoiser and Eq classes added to PhysicalStrip
- Device class added to PhysicalStrip/PhysicalBus
- AppGain(), AppMute() methods added to VirtualStrip
- eq added to Bus
- interface classes IBus, IStrip and IVban added. getters/setters moved into interface classes.
- RemoteBasic, RemoteBanana and RemotePotato subclasses added.

### Fixed

- Button getters return boolean values.

### Removed

- Bus[i].mode\_{param} members removed. Replaced with Bus[i].mode.{param}

## [2.5.0] - 2022-10-27

### Added

- xy parameters added to strip/bus
- fx parameters added to strip/bus
- GetType, GetVersion added to Remote class.
- SendText implemented (set parameters by script), added to Remote class.
- CLI example added
- README and CHANGELOG updated to reflect latest changes.

### Changed

- pester tests now support all kinds.
- GoToNextBus example refactored
- Previous console output now written to Debug stream.

### Removed

- setmulti, setandget and special examples.

## [2.4.0] - 2022-06-25

### Added

- fadeto, fadeby methods for strips/buses
- README and CHANGELOG updated to reflect latest changes.
- Version 2.4 added to PSGAllery

### Changed

- Move kinds, profiles into their own modules.
- remove global variable layout. added GetKind() to kinds.
- link to official documentation in readme now points to SDK repo.

### Fixed

- number of macrobuttons

## [2.3.0] - 2022-03-08

### Added

- mc, k properties added to virtual strips.
- gainlayer properties added to all strips
- busmode and eq_ab properties added to all buses.
- Added ability to load custom profiles in psd1 format.
- Added hide command to Command class
- Added recorder module
- Added recorder tests to higher.tests
- README and CHANGELOG updated to reflect latest changes.
- Version 2.3 added to PSGAllery

### Changed

- Pester tests refactored

### Fixed

- eq, eq_ab getters now return boolean values
- fixed bug with command action props

## [2.2.0] - 2022-01-19

### Added

- Add VMRemoteErrors class and subclass other error classes.
- Expose lower level setters and getters as well as polling parameters through Remote class.
- README and CHANGELOG updated to reflect latest changes.
- Version 2.2 added to PSGAllery

### Changed

- Rework set many parameters so class properties are set through the wrapper instead by VBVMR_SetParameters
- Rework meta module. Separate functions for each member type.
- Update pester tests to reflect latest changes
- Add throw LoginError if multiple login attempts are made. In testing the session was still crashing, however.

## [2.1.0] - 2022-01-11

### Added

- Special command lock
- Special command showvbanchat
- vban.enable command added (toggle vban)
- README and CHANGELOG updated to reflect latest changes.
- Version 2.1 added to PSGAllery

### Changed

- Subclass strip and bus classes into physical/virtual buses.

### Fixed

- Special command showvbanchat now accepts boolean

## [2.0.0] - 2022-01-06

### Added

- README and CHANGELOG updated to reflect latest changes.
- Version 2.0 added to PSGAllery

### Changed

- Moved meta functions into own module
- Vban class now custom object comprising of two arrays of subclasses for each stream type
- Major version bumped due to changes to vban class
- Pester tests updated to reflect changes.

### Fixed

- Special commands now throw write only error on read attempt.

## [1.8.0] - 2021-08-23

### Added

- Added special commands

### Changed

- Add special section to README

### Fixed

- Removed unneeded console output

## [1.6.0] - 2021-06-06

### Added

- Add vban commands
- Added meta functions for bus/strip attrs

### Changed

- Update tests to reflect changes
- Add vban section to README

### Fixed

- Run 64bit exe for potato version if on 64bit OS

## [1.5.0] - 2021-05-11

### Added

- Fetch dll path through registry (support for 32 and 64 bit)
- Add strip/bus commands section to README
- Add label name command to Strips

## [1.4.0] - 2021-05-03

### Added

- Add gain, comp, limit to Strips
- Update tests to reflect changes
- Add logging + summary for tests
- Add info to README about powershellget, nuget and psgallery
- Support other types of params in multi_set

### Changed

- Multi_Set now accepts nested hash

## [1.3.0] - 2021-04-30

### Added

- Updated README to include Installation instructions.
- Added FROM_SOURCE.md to explain alternative loading of scripts if directly
  downloaded.
- Set_Multi command for setting many parameters at once.

## [1.0.0] - 2021-04-29

- Added module to PSGAllery
