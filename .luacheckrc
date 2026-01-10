std = "lua51+wow"
globals = {
    "NoobTacoGotOneDB",
    "SLASH_NTCOLLECTION1",
    "SLASH_NTCOLLECTION2",
    "SLASH_NTGOTONE1",
    "SLASH_NTGOTONE2",
    "NoobTacoGotOne"
}
read_globals = {
    "LibStub",
    "wipe",
    "strtrim",
    "strmatch"
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
    "212/self",         -- Methods defined with : implicitly have self, but we might not use it.
    "212/_",            -- Allow underscore as unused argument
    "211/_",            -- Allow underscore as unused variable
}
