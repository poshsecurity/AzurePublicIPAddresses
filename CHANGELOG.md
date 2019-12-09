# AzurePublicIPAddresses Release History

## 1.11 - 2019-12-09

### Added

* Added deprectation notice to module.
* Please look at the Service Tags files or the Az module.
* Added new regions.

### Removed

* Removed regions that no longer exist

## 1.0 - 2018-05-01

### Fixed

* Handling for unknown regions.

### Added

* Added support for Australia Central, Australia Central 2, UK North, UK South 2, and placeholders North Europe 2 and East Europe.
* Added Readme, change log,  code of conduct, issue and pull request templates.
* Better tests including help content and more script analyser tests.

## 0.9 - 2018-02-04

### Added

* Support for France and Germany regions.
* Support for downloading the Germany region specific file.

### Changed

* Get-MicrosoftAzureDatacenterIPRangeFile parameters have changed. -ChinaRegion has been replaced with -Region China and -Region Germany.

## 0.8.3 - 2017-03-05

### Added

* Support for Korea regions.

## 0.8.2 - 2016-12-31

### Fixed

* CMDLetsToExport is now an empty array

### Added

* Support for US Central and US EAST2 EUAP regions.

## 0.8.1 - 2016-11-13

### Fixed

* Parameter validation for Get-MicrosoftAzureDatacenterIPRange and Get-MicrosoftAzureDatacenterIPRangeFile

### Changed

* Test cases for each Azure region.
* Comment based help has been improved.
* Better verbose output.
