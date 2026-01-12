local addonName, addon = ...
local Lib = LibStub("NoobTaco-Config-1.0")
local LSM = LibStub("LibSharedMedia-3.0")

if not Lib then return end

local Config = {}
addon.Config = Config

-- ----------------------------------------------------------------------------
-- Data Providers
-- ----------------------------------------------------------------------------

local function GetSoundOptions()
  local options = {}
  -- Fetch sounds from LibSharedMedia
  for name, path in pairs(LSM:HashTable("sound")) do
    table.insert(options, { label = name, value = name, path = path })
  end
  -- Sort alphabetically
  table.sort(options, function(a, b) return a.label < b.label end)
  return options
end

-- ----------------------------------------------------------------------------
-- Configuration Schemas
-- ----------------------------------------------------------------------------

function Config:BuildSchemas()
  -- Helper to get version
  local version = C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Version") or GetAddOnMetadata(addonName, "Version") or
      "v1.0.0"
  local soundOptions = GetSoundOptions()

  local function RefreshRegistration()
    Lib.State:Commit()
    if addon.CollectionNotifications then
      addon.CollectionNotifications.UnregisterEvents()
      addon.CollectionNotifications.RegisterEvents()
    end
  end

  local function CommitState()
    Lib.State:Commit()
  end

  -- 1. About Section
  Config.AboutSchema = {
    type = "group",
    children = {
      {
        type = "about",
        icon = "Interface\\AddOns\\NoobTaco-GotOne\\Media\\Textures\\noobtaco_gotone_logo.tga",
        title = "|cffD78144NoobTaco|r|cffF8F9FAGotOne|r",
        version = version,
        description = "Audio-only collection notifications.\n\nNever miss a collection item again!",
        links = {
          {
            label = "Donate",
            url = "https://ko-fi.com/mikenorton",
            onClick = function()
              StaticPopupDialogs["NOOBTACOUI_GENERIC_COPY"] = {
                text = "CTRL+C to copy the link: https://ko-fi.com/mikenorton",
                button1 = "Close",
                hasEditBox = true,
                editBoxWidth = 400,
                OnShow = function(frame)
                  frame.EditBox:SetText("https://ko-fi.com/mikenorton")
                  frame.EditBox:SetFocus()
                  frame.EditBox:HighlightText()
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                preferredIndex = 3,
              }
              StaticPopup_Show("NOOBTACOUI_GENERIC_COPY")
            end
          },
          {
            label = "GitHub",
            url = "https://github.com/NoobTaco/NoobTaco-GotOne",
            onClick = function()
              StaticPopupDialogs["NOOBTACOUI_GENERIC_COPY"] = {
                text = "CTRL+C to copy the link: https://github.com/NoobTaco/NoobTaco-GotOne",
                button1 = "Close",
                hasEditBox = true,
                editBoxWidth = 400,
                OnShow = function(frame)
                  frame.EditBox:SetText("https://github.com/NoobTaco/NoobTaco-GotOne")
                  frame.EditBox:SetFocus()
                  frame.EditBox:HighlightText()
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                preferredIndex = 3,
              }
              StaticPopup_Show("NOOBTACOUI_GENERIC_COPY")
            end
          },
        }
      },
      { type = "header", label = "Instructions" },
      {
        type = "description",
        text = "This addon plays a sound when you collect a new appearance, mount, pet, or toy.\n\n" ..
            "You can configure specific sounds for each collection type in the Audio Settings menu."
      }
    }
  }

  -- 2. Audio Settings
  Config.SettingsSchema = {
    type = "group",
    children = {
      { type = "header",      label = "Configuration" },
      { type = "description", text = "Manage your notification preferences and audio alerts." },

      -- Global Toggle
      {
        type = "card",
        label = "Global Settings",
        children = {
          {
            id = "enabled",
            type = "checkbox",
            label = "Enable Notifications",
            default = true,
            onChange = RefreshRegistration
          },
          {
            id = "showMessages",
            type = "checkbox",
            label = "Show Chat Messages",
            default = true,
            onChange = CommitState
          }
        }
      },

      -- Per-Type Settings
      {
        type = "card",
        label = "Collection Types & Audio",
        children = {
          { type = "description", text = "Enable specific collection types and choose their alert sounds." },

          -- Pets
          {
            type = "row",
            children = {
              { id = "newPet",   type = "checkbox", label = "Pets",     width = 170,            labelWidth = 130,              default = true, onChange = RefreshRegistration },
              { id = "soundPet", type = "media",    default = "NT_Pet", options = soundOptions, onChange = RefreshRegistration }
            }
          },

          -- Mounts
          {
            type = "row",
            children = {
              { id = "newMount",   type = "checkbox", label = "Mounts",                width = 170,            labelWidth = 130,              default = true, onChange = RefreshRegistration },
              { id = "soundMount", type = "media",    default = "NT_Mount_Collection", options = soundOptions, onChange = RefreshRegistration }
            }
          },

          -- Toys
          {
            type = "row",
            children = {
              { id = "newToy",   type = "checkbox", label = "Toys",                width = 170,            labelWidth = 130,              default = true, onChange = RefreshRegistration },
              { id = "soundToy", type = "media",    default = "NT_Toy_Collection", options = soundOptions, onChange = RefreshRegistration }
            }
          },

          -- Transmog
          {
            type = "row",
            children = {
              { id = "newTransmog",   type = "checkbox", label = "Transmog",      width = 170,            labelWidth = 130,              default = true, onChange = RefreshRegistration },
              { id = "soundTransmog", type = "media",    default = "NT_Transmog", options = soundOptions, onChange = RefreshRegistration }
            }
          },
        }
      }
    }
  }
end

-- ----------------------------------------------------------------------------
-- Initialization & Rendering
-- ----------------------------------------------------------------------------

function Config:RenderContent(parent)
  -- Ensure DB is ready
  if not NoobTacoGotOneDB then NoobTacoGotOneDB = {} end
  if not NoobTacoGotOneDB.CollectionNotifications then NoobTacoGotOneDB.CollectionNotifications = {} end

  -- Initialize State with DB
  Lib.State:Initialize(NoobTacoGotOneDB.CollectionNotifications)

  -- Rebuild schemas each time to ensure fresh LSM sound options
  self:BuildSchemas()

  local Schemas = Config

  -- Layout Initialization
  local layout = parent.Layout
  if not layout then
    layout = Lib.Layout:CreateTwoColumnLayout(parent)
    parent.Layout = layout
    -- layout:SetScale(1.0) -- Optional scale

    -- Sidebar Configuration
    Lib.Layout:AddSidebarButton(layout, "settings", "Audio Settings", function()
      Lib.State:SetValue("lastSection", "settings")
      Lib.Renderer:Render(Schemas.SettingsSchema, layout)
    end)

    Lib.Layout:AddSidebarButton(layout, "about", "About", function()
      Lib.State:SetValue("lastSection", "about")
      Lib.Renderer:Render(Schemas.AboutSchema, layout)
    end)
  end

  -- Initial Render
  local lastSection = Lib.State:GetValue("lastSection") or "settings"
  local sectionSchemas = {
    about    = Schemas.AboutSchema,
    settings = Schemas.SettingsSchema
  }

  Lib.Layout:SelectSidebarButton(layout, lastSection)
  Lib.Renderer:Render(sectionSchemas[lastSection] or Schemas.SettingsSchema, layout)
end

function Config:Toggle()
  -- If we are in the settings menu, just open it
  if Settings and Settings.OpenToCategory then
    if self.category then
      Settings.OpenToCategory(self.category:GetID())
    else
      Settings.OpenToCategory("NoobTaco GotOne")
    end
  elseif InterfaceOptionsFrame_OpenToCategory then
    InterfaceOptionsFrame_OpenToCategory("NoobTaco GotOne")
  end
end

-- Global helper for macros or other addons
function NoobTacoGotOne_ToggleSettings()
  Config:Toggle()
end

function Config:Initialize()
  self:BuildSchemas()

  local canvas = CreateFrame("Frame", nil, UIParent)
  canvas.name = "NoobTaco|cffF8F9FAGotOne|r"
  self.canvas = canvas

  if Settings and Settings.RegisterCanvasLayoutCategory then
    self.category = Settings.RegisterCanvasLayoutCategory(canvas, "|cffD78144NoobTaco|r|cffF8F9FAGotOne|r")
    Settings.RegisterAddOnCategory(self.category)

    local hasRenderedOnce = false
    local function TryRender()
      local width = canvas:GetWidth()
      if width > 10 and (not canvas.lastRenderedWidth or math.abs(canvas.lastRenderedWidth - width) > 5) then
        self:RenderContent(canvas)
        canvas.lastRenderedWidth = width
      end
    end

    canvas:SetScript("OnShow", function()
      if not hasRenderedOnce then
        TryRender()
        C_Timer.After(0, function()
          TryRender()
          hasRenderedOnce = true
        end)
      else
        TryRender()
      end
    end)

    canvas:SetScript("OnSizeChanged", TryRender)
    -- Fallback for older interface options if necessary, but assuming Dragonflight+
    if InterfaceOptions_AddCategory then
      InterfaceOptions_AddCategory(canvas)
      canvas:SetScript("OnShow", function() Config:RenderContent(canvas) end)
    end
  end
end

-- Initialize on Login to ensure SavedVariables are loaded
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
  Config:Initialize()

  -- Register Slash Commands
  SLASH_GOTONE1 = "/ntgotone"
  SLASH_GOTONE2 = "/ntgo"
  SlashCmdList["GOTONE"] = function(msg)
    local args = string.lower(msg or "")
    if args == "" then
      Config:Toggle()
    elseif args == "test" then
      addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: Testing all sounds...")
      if addon.CollectionNotifications then
        addon.CollectionNotifications.PlayNotificationSound("soundPet", true)
        C_Timer.After(1, function() addon.CollectionNotifications.PlayNotificationSound("soundMount", true) end)
        C_Timer.After(2, function() addon.CollectionNotifications.PlayNotificationSound("soundToy", true) end)
        C_Timer.After(3, function() addon.CollectionNotifications.PlayNotificationSound("soundTransmog", true) end)
      end
    elseif args == "testpet" then
      addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: Testing pet notification...")
      if addon.CollectionNotifications then
        addon.CollectionNotifications.PlayNotificationSound("soundPet", true)
        if addon.CollectionNotifications.GetSetting("showMessages") then
          addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: New pet species collected: |csuccess|Test Pet|r")
        end
      end
    elseif args == "testmount" then
      addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: Testing mount notification...")
      if addon.CollectionNotifications then
        addon.CollectionNotifications.PlayNotificationSound("soundMount", true)
        if addon.CollectionNotifications.GetSetting("showMessages") then
          addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: New mount collected: |csuccess|Test Mount|r")
        end
      end
    elseif args == "testtoy" then
      addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: Testing toy notification...")
      if addon.CollectionNotifications then
        addon.CollectionNotifications.PlayNotificationSound("soundToy", true)
        if addon.CollectionNotifications.GetSetting("showMessages") then
          addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: New toy collected: |csuccess|Test Toy|r")
        end
      end
    elseif args == "testtransmog" then
      addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: Testing transmog notification...")
      if addon.CollectionNotifications then
        addon.CollectionNotifications.PlayNotificationSound("soundTransmog", true)
        if addon.CollectionNotifications.GetSetting("showMessages") then
          addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r: New transmog collected: |csuccess|Test Transmog Item|r")
        end
      end
    elseif args == "status" then
      if addon.CollectionNotifications then
        local GetSetting = addon.CollectionNotifications.GetSetting
        addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r Status:")
        addon.Print("  Enabled: " .. (GetSetting("enabled") and "|csuccess|Yes|r" or "|cerror|No|r"))
        addon.Print("  Pets: " .. (GetSetting("newPet") and "|csuccess|Yes|r" or "|cerror|No|r"))
        addon.Print("  Mounts: " .. (GetSetting("newMount") and "|csuccess|Yes|r" or "|cerror|No|r"))
        addon.Print("  Toys: " .. (GetSetting("newToy") and "|csuccess|Yes|r" or "|cerror|No|r"))
        addon.Print("  Transmog: " .. (GetSetting("newTransmog") and "|csuccess|Yes|r" or "|cerror|No|r"))
      end
    else
      addon.Print("|chighlight|NoobTaco|r|cffF8F9FAGotOne|r commands:")
      addon.Print("  |cinfo|/ntgo|r - Open configuration panel")
      addon.Print("  |cinfo|/ntgo test|r - Test all notification sounds")
      addon.Print("  |cinfo|/ntgo testpet|r - Test pet notification")
      addon.Print("  |cinfo|/ntgo testmount|r - Test mount notification")
      addon.Print("  |cinfo|/ntgo testtoy|r - Test toy notification")
      addon.Print("  |cinfo|/ntgo testtransmog|r - Test transmog notification")
      addon.Print("  |cinfo|/ntgo status|r - Show current settings")
    end
  end
end)
