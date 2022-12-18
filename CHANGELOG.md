# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Before any major/minor/patch is released all test units will be run to verify they pass.

## [Unreleased] These changes have not been added to PSGallery yet

-   [x] Implement command.load
-   [x] Implement comp/gate parameters introduced in v3.0.2.8 of the api.
-   [x] Add unit tests for new classes.
-   [x] Update README with changes to Strip/Bus classes.

## [3.0.0]

v3 introduces some breaking changes. They are as follows:

-   Strip[i].comp now references [Comp] class. (see README for details on settings strip.comp parameters)
-   Strip[i].gate now references [Gate] class. (see README for details on settings strip.gate parameters)
-   Strip[i].eq now references [Eq] class. (see README for details on settings strip.eq parameters)
-   Strip[i].device now references [Device] class. (see README for details on settings strip.device parameters)

-   Bus[i].eq now references [Eq] class. (see README for details on settings bus.eq parameters)
-   Bus[i].mode now implemented as its own class [Mode]. (see README for details on settings bus.mode parameters)

### Changed

-   meta functions refactored, they now use identifier() functions.
-   OBS example reworked, now using obs-powershell module.
-   Rethrow LoginError for unknown kind exceptions, let the consumer handle it from there.

### Added

-   Entry/exit points Connect-Voicemeeter, Disconnect-Voicemeeter added to module.
-   Comp, Gate, Denoiser and Eq classes added to PhysicalStrip
-   Device class added to PhysicalStrip/PhysicalBus
-   AppGain(), AppMute() methods added to VirtualStrip
-   eq added to Bus
-   interface classes IBus, IStrip and IVban added. getters/setters moved into interface classes.
-   RemoteBasic, RemoteBanana and RemotePotato subclasses added.

### Fixed

-   Button getters return boolean values.

### Removed

-   Bus[i].mode\_{param} members removed. Replaced with Bus[i].mode.{param}

## [2.5.0] - 2022-10-27

### Added

-   xy parameters added to strip/bus
-   fx parameters added to strip/bus
-   GetType, GetVersion added to Remote class.
-   SendText implemented (set parameters by script), added to Remote class.
-   CLI example added
-   README and CHANGELOG updated to reflect latest changes.

### Changed

-   pester tests now support all kinds.
-   GoToNextBus example refactored
-   Previous console output now written to Debug stream.

### Removed

-   setmulti, setandget and special examples.

## [2.4.0] - 2022-06-25

### Added

-   fadeto, fadeby methods for strips/buses
-   README and CHANGELOG updated to reflect latest changes.
-   Version 2.4 added to PSGAllery

### Changed

-   Move kinds, profiles into their own modules.
-   remove global variable layout. added GetKind() to kinds.
-   link to official documentation in readme now points to SDK repo.

### Fixed

-   number of macrobuttons

## [2.3.0] - 2022-03-08

### Added

-   mc, k properties added to virtual strips.
-   gainlayer properties added to all strips
-   busmode and eq_ab properties added to all buses.
-   Added ability to load custom profiles in psd1 format.
-   Added hide command to Command class
-   Added recorder module
-   Added recorder tests to higher.tests
-   README and CHANGELOG updated to reflect latest changes.
-   Version 2.3 added to PSGAllery

### Changed

-   Pester tests refactored

### Fixed

-   eq, eq_ab getters now return boolean values
-   fixed bug with command action props

## [2.2.0] - 2022-01-19

### Added

-   Add VMRemoteErrors class and subclass other error classes.
-   Expose lower level setters and getters as well as polling parameters through Remote class.
-   README and CHANGELOG updated to reflect latest changes.
-   Version 2.2 added to PSGAllery

### Changed

-   Rework set many parameters so class properties are set through the wrapper instead by VBVMR_SetParameters
-   Rework meta module. Separate functions for each member type.
-   Update pester tests to reflect latest changes
-   Add throw LoginError if multiple login attempts are made. In testing the session was still crashing, however.

## [2.1.0] - 2022-01-11

### Added

-   Special command lock
-   Special command showvbanchat
-   vban.enable command added (toggle vban)
-   README and CHANGELOG updated to reflect latest changes.
-   Version 2.1 added to PSGAllery

### Changed

-   Subclass strip and bus classes into physical/virtual buses.

### Fixed

-   Special command showvbanchat now accepts boolean

## [2.0.0] - 2022-01-06

### Added

-   README and CHANGELOG updated to reflect latest changes.
-   Version 2.0 added to PSGAllery

### Changed

-   Moved meta functions into own module
-   Vban class now custom object comprising of two arrays of subclasses for each stream type
-   Major version bumped due to changes to vban class
-   Pester tests updated to reflect changes.

### Fixed

-   Special commands now throw write only error on read attempt.

## [1.8.0] - 2021-08-23

### Added

-   Added special commands

### Changed

-   Add special section to README

### Fixed

-   Removed unneeded console output

## [1.6.0] - 2021-06-06

### Added

-   Add vban commands
-   Added meta functions for bus/strip attrs

### Changed

-   Update tests to reflect changes
-   Add vban section to README

### Fixed

-   Run 64bit exe for potato version if on 64bit OS

## [1.5.0] - 2021-05-11

### Added

-   Fetch dll path through registry (support for 32 and 64 bit)
-   Add strip/bus commands section to README
-   Add label name command to Strips

## [1.4.0] - 2021-05-03

### Added

-   Add gain, comp, limit to Strips
-   Update tests to reflect changes
-   Add logging + summary for tests
-   Add info to README about powershellget, nuget and psgallery
-   Support other types of params in multi_set

### Changed

-   Multi_Set now accepts nested hash

## [1.3.0] - 2021-04-30

### Added

-   Updated README to include Installation instructions.
-   Added FROM_SOURCE.md to explain alternative loading of scripts if directly
    downloaded.
-   Set_Multi command for setting many parameters at once.

## [1.0.0] - 2021-04-29

-   Added module to PSGAllery
