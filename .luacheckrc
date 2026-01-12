std = "lua51"
globals = {
    "NoobTacoGotOneDB",
    "SLASH_NTCOLLECTION1",
    "SLASH_NTCOLLECTION2",
    "SLASH_NTGOTONE1",
    "SLASH_NTGOTONE2",
    "NoobTacoGotOne",
    "SlashCmdList",
    "SLASH_GOTONE1",
    "SLASH_GOTONE2",
    "NoobTacoGotOne_ToggleSettings",
    "NoobTacoGotOne_OnAddonCompartmentClick",
    "NoobTacoGotOne_OnAddonCompartmentEnter",
    "NoobTacoGotOne_OnAddonCompartmentLeave",
    "StaticPopupDialogs",
}
read_globals = {
    "LibStub",
    "wipe",
    "strtrim",
    "strmatch",
    "CreateFrame",
    "UIParent",
    "GameFontNormal",
    "GameFontHighlight",
    "GameFontHighlightSmall",
    "GameFontNormalLarge",
    "GameTooltip",
    "PlaySoundFile",
    "GetTime",
    "C_PetJournal",
    "C_MountJournal",
    "C_ToyBox",
    "C_TransmogCollection",
    "C_Item",
    "C_Timer",
    "print",
    "pairs",
    "ipairs",
    "select",
    "unpack",
    "type",
    "tostring",
    "tonumber",
    "error",
    "setmetatable",
    "getmetatable",
    "assert",
    "format",
    "date",
    "time",
    "C_AddOns",
    "GetAddOnMetadata",
    "Settings",
    "InterfaceOptions_AddCategory",
    "InterfaceOptionsFrame_OpenToCategory",
    "StaticPopup_Show",
}

-- Exclude test files, installed rock dependencies, and vendored libraries
exclude_files = {
    "Tests/**",
    ".luarocks/**",
    ".github/**",
    "Libraries/**"
}

-- Slightly relaxed line length
max_line_length = 200

-- Suppress specific warnings
-- We have fixed most shadownig and unused vars, so this list is minimal.
ignore = {
    "112", -- Mutating undefined variable (handled by globals)
    "113", -- Accessing undefined variable (handled by globals above)
    "141", -- Setting non-standard global variable (needed for WoW addon globals)
    "211", -- Unused variable
    "212", -- Unused argument
    "431", -- Shadowing upvalue argument (very common in WoW addon callbacks)
    "432", -- Shadowing upvalue
}
