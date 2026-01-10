std = "lua51"
read_globals = {
    "CreateFrame",
    "UIParent",
    "GameFontNormal",
    "GameFontHighlight",
    "GameFontHighlightSmall",
    "GameFontNormalLarge",
    "GameTooltip",
    "PlaySoundFile",
    "UIDropDownMenu_Initialize",
    "UIDropDownMenu_CreateInfo",
    "UIDropDownMenu_AddButton",
    "UIDropDownMenu_SetSelectedValue",
    "UIDropDownMenu_SetText",
    "UIDropDownMenu_SetWidth",
    "Settings",
    "PixelUtil",
    "C_Timer",
    "wipe",
    "strtrim",
    "strmatch",
    "GetBuildInfo",
    "LibStub"
}

-- Exclude test files and installed rock dependencies
exclude_files = {
    "Tests/**", 
    ".luarocks/**",
    ".github/**"
}

-- Slightly relaxed line length
max_line_length = 200

-- Suppress specific warnings
-- We have fixed most shadownig and unused vars, so this list is minimal.
ignore = {
    "212/self",         -- Methods defined with : implicitly have self, but we might not use it.
    "212/_",            -- Allow underscore as unused argument
    "211/_",            -- Allow underscore as unused variable
}
