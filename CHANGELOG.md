# NoobTaco GotOne Changelog

## [Unreleased]
### Fixed
- **Media Widget Audio Preview**: Fixed sound preview button to use the correct file path instead of the sound name.
- **Media Widget onChange**: Added onChange callback support for media dropdowns to trigger live updates.
- **Sound Options Refresh**: Schemas now rebuild on render to ensure fresh LibSharedMedia sound options.

### Changed
- **Library Update**: Updated `NoobTaco-Config` to v1.0.3 to resolve library loading conflicts and fix checkbox sizing.



### Added
- Initial project setup.
- Core addon structure and configuration.
- LibSharedMedia-3.0 and NoobTaco-Config integration.
- Imported Collection Notifications module from NoobTacoUI.
- Added collection-related sound files.
- Implemented Configuration Menu (Config.lua) using NoobTaco-Config.
  - Added Audio Settings with Global Toggle.
  - Added per-collection type settings (Pet, Mount, Toy, Transmog).
  - Integrated LibSharedMedia for sound selection.
  - Implemented live settings updates (no reload required).
