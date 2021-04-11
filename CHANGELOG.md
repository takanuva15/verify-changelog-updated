# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Can now specify your own token input to override the default GitHub token

### Changed
- Some "pre-check" bash steps are now executed in action.yml rather than within the bash script

## [1.1.0] - 2021-04-10
### Changed
- User no longer needs to specify GitHub token within their workflow file; we retrieve it automatically from execution context

## [1.0.0] - 2021-04-09
### Added
- Added verify script to check if current PR has updated the changelog file
- Added info in readme for others to easily use this GitHub action
