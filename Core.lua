local addonName, addon = ...
addon.L = {}

-- Access the config library for theming
local Lib = LibStub and LibStub("NoobTaco-Config-1.0", true)

-------------------------------------------------------------------------------
-- Themed Print Helper
-------------------------------------------------------------------------------
local function Print(msg)
  if Lib and Lib.Theme and Lib.Theme.ProcessText then
    print(Lib.Theme:ProcessText(msg))
  else
    -- Fallback if library not loaded yet
    print((msg:gsub("|c%w+|", ""):gsub("|r", "")))
  end
end

-- Export for other modules
addon.Print = Print

-------------------------------------------------------------------------------
-- Addon Compartment Integration
-------------------------------------------------------------------------------
function NoobTacoGotOne_OnAddonCompartmentClick(_, buttonName)
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
      local status = (not current) and "|csuccess|Enabled|r" or "|cerror|Disabled|r"
      Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: Collection Notifications " .. status)
    end
  end
end

function NoobTacoGotOne_OnAddonCompartmentEnter(_, menuButtonFrame)
  local title, tip1, tip2, tip3
  if Lib and Lib.Theme and Lib.Theme.ProcessText then
    title = Lib.Theme:ProcessText("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r")
    tip1 = Lib.Theme:ProcessText("Audio-only collection notifications")
    tip2 = Lib.Theme:ProcessText("Left-click: Open configuration")
    tip3 = Lib.Theme:ProcessText("Right-click: Toggle notifications")
  else
    title = "|cffD78144NoobTaco|r|cffF8F9FAGotOne|r"
    tip1 = "Audio-only collection notifications"
    tip2 = "Left-click: Open configuration"
    tip3 = "Right-click: Toggle notifications"
  end

  GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_LEFT")
  GameTooltip:SetText(title, 1, 1, 1)
  GameTooltip:AddLine(tip1, 0.7, 0.7, 0.7)
  GameTooltip:AddLine(" ", 1, 1, 1)
  GameTooltip:AddLine(tip2, 0.7, 0.7, 0.7)
  GameTooltip:AddLine(tip3, 0.7, 0.7, 0.7)
  GameTooltip:Show()
end

function NoobTacoGotOne_OnAddonCompartmentLeave(_, _menuButtonFrame)
  GameTooltip:Hide()
end

-------------------------------------------------------------------------------
-- Initialize the addon
-------------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, name)
  if name == addonName then
    Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r loaded.")
    self:UnregisterEvent(event)
  end
end)
