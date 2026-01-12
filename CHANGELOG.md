# NoobTaco GotOne Changelog

## [1.1.2] - 2026-01-11
### Changed
- **Accessibility**: Increased font weight of the body font in the configuration menu to improve readability for users with poor eyesight.
- **Themes**: Updated default typography to use `Poppins-Medium` for 'Normal' and `Poppins-Bold` for 'Bold' weights.
- **Library Sync**: Synchronized `NoobTaco-Config` with the latest changes in the core suite.

## [1.1.1] - 2026-01-11
### Changed
- **Library Sync**: Synchronized `NoobTaco-Config` with the latest changes in the core suite.
- **Branding**: Enhanced support buttons (Donate, GitHub) to open a copy-paste dialog when clicked for easier link sharing.

## [1.1.0] - 2026-01-11
### Changed
- **Branding**: Re-branded the addon in-game strings and titles to use the split-color Burnt Sienna and Cloud White "NoobTaco Tech Brand Identity". Added visual consistency in the Blizzard Options panel.
- **Library Update**: Updated `NoobTaco-Config` to v1.3.1 to resolve library loading conflicts and fix checkbox sizing.


## [1.0.0] - 2026-01-10
### Added
- **Addon Logo**: Added addon icon for the addon compartment and minimap display.
- **Addon Compartment Integration**: Added support for the addon drawer with left-click to open config and right-click to toggle notifications.
- **Collections Category**: Added localized category entries so addon shows under "Collections" in WoW.
- **Theme Integration**: All chat output now uses NoobTaco-Config library theme system with tokens (`|chighlight|`, `|csuccess|`, `|cerror|`, `|cinfo|`).

### Fixed
- **Media Widget Audio Preview**: Fixed sound preview button to use the correct file path instead of the sound name.
- **Media Widget onChange**: Added onChange callback support for media dropdowns to trigger live updates.
- **Sound Options Refresh**: Schemas now rebuild on render to ensure fresh LibSharedMedia sound options.

### Changed
- **Library Update**: Updated `NoobTaco-Config` to v1.2.0 to resolve library loading conflicts and fix checkbox sizing.

### Initial Setup
- Core addon structure and configuration.
- LibSharedMedia-3.0 and NoobTaco-Config integration.
- Imported Collection Notifications module from NoobTacoUI.
- Added collection-related sound files.
- Implemented Configuration Menu (`Config.lua`) using NoobTaco-Config.
    - Added Audio Settings with Global Toggle.
    - Added per-collection type settings (Pet, Mount, Toy, Transmog).
    - Integrated LibSharedMedia for sound selection.
    - Implemented live settings updates (no reload required).
