# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Before any minor/major patch is released all test units will be run to verify they pass.

## [Unreleased]
- [x]

## [2.1] - 2021-01-11
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

## [2.0] - 2021-01-06
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

## [1.8] - 2021-08-23
### Added
- Added special commands

### Changed
- Add special section to README

### Fixed
- Removed unneeded console output

## [1.6] - 2021-06-06
### Added
- Add vban commands
- Added meta functions for bus/strip attrs

### Changed
- Update tests to reflect changes
- Add vban section to README

### Fixed
- Run 64bit exe for potato version if on 64bit OS

## [1.5] - 2021-05-11
### Added
- Fetch dll path through registry (support for 32 and 64 bit)
- Add strip/bus commands section to README
- Add label name command to Strips

## [1.4] - 2021-05-03
### Added
- Add gain, comp, limit to Strips
- Update tests to reflect changes
- Add logging + summary for tests
- Add info to README about powershellget, nuget and psgallery
- Support other types of params in multi_set

### Changed
- Multi_Set now accepts nested hash

## [1.3] - 2021-04-30
### Added
- Updated README to include Installation instructions.
- Added FROM_SOURCE.md to explain alternative loading of scripts if directly
downloaded.
- Set_Multi command for setting many parameters at once.


## [1.0] - 2021-04-29
- Added module to PSGAllery
