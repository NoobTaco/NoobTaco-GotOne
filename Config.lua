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
        title = "|cff33ff99NoobTaco|r GotOne",
        version = version,
        description = "Audio-only collection notifications.\n\nNever miss a collection item again!",
        links = {
          { label = "GitHub", url = "https://github.com/NoobTaco/NoobTaco-GotOne" },
        }
      },
      { type = "header",      label = "Instructions" },
      { type = "description", text = "This addon plays a sound when you collect a new appearance, mount, pet, or toy.\n\nYou can configure specific sounds for each collection type in the Audio Settings menu." }
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

function Config:Initialize()
  self:BuildSchemas()

  local canvas = CreateFrame("Frame", nil, UIParent)
  canvas.name = "NoobTaco GotOne"

  if Settings and Settings.RegisterCanvasLayoutCategory then
    local category = Settings.RegisterCanvasLayoutCategory(canvas, "NoobTaco GotOne")
    Settings.RegisterAddOnCategory(category)

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
f:SetScript("OnEvent", function() Config:Initialize() end)
