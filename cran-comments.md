## Test environments
Tests were executed based on automatic install from github

Package deployed in three test environments, and also build_win() called.

* local OS X install, R 3.5.1
* OS: ubuntu 16.04 R 3.4.4
* Windows7:  R 3.4.1
* win-builder - using devtools::build_win() (1 NOTE)

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

## Changes made following first submission 18th August 2018.

* Placed all software references in quotes in title and description.
* Ensured that LICENSE file followed CRAN format
* Removed issues in relation to github (no longer required)

Changed title field to title case:
* was Provides an R API To Python Library 'pysd'
* is now Provides an R API to Python Library 'pysd'

## Changes made following feedback on August 22nd 2018
* Changed title to API to Python Library 'pysd'
* Added blank after 'xmile' format
* Executable examples added in the Rd-files, with PNG files moved to man/figures directory

## Changes made following feedback on August 29th 2018
* Added quotes to software name Python on title (DESCRIPTION)
* Added add small executable examples in the Rd-files.

## Changes made following feedback on September 3rd 2018
* Added 32/64 bit python3 requirement to DESCRIPTION file (SystemRequirements)


