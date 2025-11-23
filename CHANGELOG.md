# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Before any major/minor/patch is released all test units will be run to verify they pass.

## [Unreleased] These changes have not been added to PSGallery yet

### Added

- Bus[i].sel to select strip gainlayers to be changed with Strip[i].gain
- Bus[i].monitor for use with Monitor On Select
- Bus[i].vaio on physical buses for use with the VAIO extension
- Strip[i].audibility for use with Voicemeeter Standard
- Strip[i].vaio on physical strips for use with the VAIO extension
- Strip[i].denoiser.threshold
- Strip[i].Pitch parameters on physical strips with new [Pitch] class for use with Voicemeeter Potato
  - Strip[i].Pitch.on
  - Strip[i].Pitch.drywet
  - Strip[i].Pitch.pitchvalue
  - Strip[i].Pitch.loformant
  - Strip[i].Pitch.medformant
  - Strip[i].Pitch.hiformant
- EQGain on virtual strips
  - Strip[i].bass or Strip[i].low
  - Strip[i].mid or Strip[i].med
  - Strip[i].treble or Strip[i].high
- Command.save($filepath) and Command.reset
- Recorder.replay and Recorder.gain to README
- New [Preset] class for Preset objects to accommodate future additions to VMRAPI such as:
  - store/overwrite
  - name, comment
  - load, save
- Preset[i].recall is the only command currently implemented
- Recorder.eject through VMRAPI's Command.eject
- Strip[i].karaoke alias for Strip[i].k
- New Fx class
  - Fx.Reverb.on
  - Fx.Reverb.ab
  - Fx.Delay.on
  - Fx.Delay.ab
- New Patch class
  - Patch.asio[i].Set($val) & .Get()
  - Patch.OutA2[i]-OutA5[i].Set($val) & .Get()
  - Patch.composite[i].Set($val) & .Get()
  - Patch.insert[i].Set($val) & .Get()
  - Patch.postFaderComposite
  - Patch.postFxInsert
- Alternate pattern for gainlayers: Strip.gainlayer[i].Set($val) & .Get() (old pattern still works)
- New IRemote class to consolidate generic $this.remote, setter, getter, etc.
- New ArrayMember classes with .Set($val) and .Get()
- New Option class
  - Option.sr
  - Option.asiosr
  - Option.delay[i].Set($val) & .Get()
  - Option.Buffer.mme
  - Option.Buffer.wdm
  - Option.Buffer.ks
  - Option.Buffer.asio
  - Option.Mode.exclusif
  - Option.Mode.swift
  - Option.monitorOnSel
  - Option.sliderMode
- More Bus.Eq | Strip.Eq methods and commands
  - Eq.save($filename)
  - Eq.load($filename)
  - Eq.Channel[i].Cell[j].on
  - Eq.Channel[i].Cell[j].type
  - Eq.Channel[i].Cell[j].f
  - Eq.Channel[i].Cell[j].gain
  - Eq.Channel[i].Cell[j].q

### Changed

- Strip[i].mono is now an alias for Strip[i].mc on virtual strips (matches Python module behavior)
- GainLayers are now based on KindMap so they're only added for Potato
- Strip and Bus now use IRemote base class

### Removed

- Bus[i].limit from README as it does not exist

### Fixed

- Strip[i].limit changed to float (the value is visually truncated in the GUI, but it's not actually an integer)
- MacroButton index range in README
- Parenthesis in Strip.AppMute string
- '$this._port' -> '$this._sr' for Vban.stream.sr
- Bus[i].mono changed to int (0 off, 1 mono, 2 stereo reverse)
- Strip[i].Gate.BPSidechain changed to int
- Vban.stream.route: fixed range 0..8 -> 0..7 (API documentation is incorrect; strip/bus 0 based index)

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
