# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Before any major/minor/patch is released all test units will be run to verify they pass.

## [Unreleased] These changes have not been added to PSGallery yet

-   [x] fix number of macrobuttons
-   [ ] Add fadeto, fadeby methods for strips/buses
-   [ ] Move kinds, profiles into their own modules.

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
