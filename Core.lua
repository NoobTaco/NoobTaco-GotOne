local addonName, addon = ...
addon.L = {}
local L = addon.L

-- Initialize the addon
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, name, ...)
  if name == addonName then
    print(addonName .. " loaded.")
    self:UnregisterEvent(event)
  end
end)
