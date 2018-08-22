## Test environments
Tests were executed based on automatic install from github (repository not yet public, auth token used)

Command:
**devtools::install_github("JimDuggan/pysd2r", auth_token = "1b818ae98f783e8df4816a22d31755dff48e16c1")**

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

## Changes made following feedback on August 22nd.
* Changed title to API to Python Library 'pysd'
* Added blank after 'xmile' format
* Please add small executable examples in your Rd-files.

