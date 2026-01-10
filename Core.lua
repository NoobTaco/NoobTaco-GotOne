local addonName, addon = ...
addon.L = {}

-------------------------------------------------------------------------------
-- Addon Compartment Integration
-------------------------------------------------------------------------------
function NoobTacoGotOne_OnAddonCompartmentClick(addonName, buttonName)
  if buttonName == "LeftButton" then
    -- Open config panel
    if addon.Config and addon.Config.Toggle then
      addon.Config:Toggle()
    end
  elseif buttonName == "RightButton" then
    -- Toggle notifications
    if NoobTacoGotOneDB and NoobTacoGotOneDB.CollectionNotifications then
      local current = NoobTacoGotOneDB.CollectionNotifications.enabled
      NoobTacoGotOneDB.CollectionNotifications.enabled = not current
      local status = (not current) and "|cff00ff00Enabled|r" or "|cffff0000Disabled|r"
      print("|cff33ff99NoobTaco|r GotOne: Collection Notifications " .. status)
    end
  end
end

function NoobTacoGotOne_OnAddonCompartmentEnter(addonName, menuButtonFrame)
  GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_LEFT")
  GameTooltip:SetText("|cff33ff99NoobTaco|r GotOne", 1, 1, 1)
  GameTooltip:AddLine("Audio-only collection notifications", 0.7, 0.7, 0.7)
  GameTooltip:AddLine(" ", 1, 1, 1)
  GameTooltip:AddLine("Left-click: Open configuration", 0.7, 0.7, 0.7)
  GameTooltip:AddLine("Right-click: Toggle notifications", 0.7, 0.7, 0.7)
  GameTooltip:Show()
end

function NoobTacoGotOne_OnAddonCompartmentLeave(addonName, menuButtonFrame)
  GameTooltip:Hide()
end

-------------------------------------------------------------------------------
-- Initialize the addon
-------------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, name)
  if name == addonName then
    print(addonName .. " loaded.")
    self:UnregisterEvent(event)
  end
end)
