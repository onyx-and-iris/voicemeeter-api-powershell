# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Before any minor/major patch is released all test units will be run to verify they pass.

## [Unreleased]
- [x]

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
