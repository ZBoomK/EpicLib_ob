--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...
-- EpicLib
local Cache, Utils = EpicCache, EL.Utils
local Unit = EL.Unit
local Player = Unit.Player
local Pet = Unit.Pet
local Target = Unit.Target
local Spell = EL.Spell
local Item = EL.Item
-- Lua
local GetActionInfo = GetActionInfo -- type, globalID, subType
local GetActionText = GetActionText -- text
local GetActionTexture = GetActionTexture -- texture
local GetBindingKey = GetBindingKey
local GetBonusBarOffset = GetBonusBarOffset
local HasAction = HasAction
local mathceil = math.ceil
local mathfloor = math.floor
local tableinsert = table.insert
local tableremove = table.remove
local gmatch = gmatch
-- File Locals
local Actions = {} -- { [ActionSlot] = { Type, ID, SubType, Texture, Text, CommandName, HotKey } }
local ActionSlotsBy = {
  Item = {}, -- { [ItemID] = { [1] = ActionSlot, [2] = ActionSlot, [3] = ... } }
  Macro = {},  -- { [MacroID] = { [1] = ActionSlot, [2] = ActionSlot, [3] = ... } }
  Spell = {}, -- { [SpellID] = { [1] = ActionSlot, [2] = ActionSlot, [3] = ... } }
  Text = {}, -- { [ActionText] = { [1] = ActionSlot, [2] = ActionSlot, [3] = ... } }
  Texture = {}, -- { [TextureID] = { [1] = ActionSlot, [2] = ActionSlot, [3] = ... } }
}
local HotKeyWhitelist = {
  Item = {}, -- { [ItemID] = HotKey }
  Macro = {},  -- { [MacroID] = HotKey }
  Spell = {}, -- { [SpellID] = HotKey }
  Text = {}, -- { [ActionText] = HotKey }
  Texture = {}, -- { [TextureID] = HotKey }
}
local Action = {
  Actions = Actions,
  ActionSlotsBy = ActionSlotsBy,
  HotKeyWhitelist = HotKeyWhitelist,
}

--- ======= GLOBALIZE =======
EL.Action = Action


--- ============================ CONTENT ============================

-- See: http://wowwiki.wikia.com/wiki/ActionSlot
-- ActionSlot        ButtonBaseName               CommandName                    Page
-- 1..12           = ActionButton                 ACTIONBUTTON..ActionSlot       1
-- 13..24          = ActionButton                 NONE                           2
-- 25..36          = MultiBarRightButton          MULTIACTIONBAR3BUTTON..BarSlot /
-- 37..48          = MultiBarLeftButton           MULTIACTIONBAR4BUTTON..BarSlot /
-- 49..60          = MultiBarBottomRightButton    MULTIACTIONBAR2BUTTON..BarSlot /
-- 61..72          = MultiBarBottomLeftButton     MULTIACTIONBAR1BUTTON..BarSlot /
-- 73..84          = ActionButton                 NONE                           3
-- 85..16          = ActionButton                 NONE                           4
-- 97..108         = ActionButton                 NONE                           5
-- 109..120        = ActionButton                 NONE                           6
-- Where ActionSlot is in 1..132 and BarSlot is in 1..12 for MULTIACTIONBARs.
-- Technically, ACTIONBUTTON commands above 12 are not bindables by default (hence why Dominos use virtual bars for those).
-- We ignore Slots from 121 to 132 because these aren't controlled by the player (Possess bar).

local ButtonByAddOn = {
  Bartender = {
    [1] = { "BT4Button", "CLICK BT4Button%i:LeftButton" },
  },
  Blizzard = {
    [1]  = { "ActionButton",              "ACTIONBUTTON%i" },
    [2]  = { "ActionButton",              nil },
    [3]  = { "MultiBarRightButton",       "MULTIACTIONBAR3BUTTON%i" },
    [4]  = { "MultiBarLeftButton",        "MULTIACTIONBAR4BUTTON%i" },
    [5]  = { "MultiBarBottomRightButton", "MULTIACTIONBAR2BUTTON%i" },
    [6]  = { "MultiBarBottomLeftButton",  "MULTIACTIONBAR1BUTTON%i" },
    [7]  = { "ActionButton",              nil },
    [8]  = { "ActionButton",              nil },
    [9]  = { "ActionButton",              nil },
    [10] = { "ActionButton",              nil },
  },
  Dominos = {
    [1]  = { "ActionButton",              "ACTIONBUTTON%i"                         },
    [2]  = { "DominosActionButton",       "CLICK DominosActionButton%i:HOTKEY" },
    [3]  = { "MultiBarRightButton",       "MULTIACTIONBAR3BUTTON%i"                },
    [4]  = { "MultiBarLeftButton",        "MULTIACTIONBAR4BUTTON%i"                },
    [5]  = { "MultiBarBottomRightButton", "MULTIACTIONBAR2BUTTON%i"                },
    [6]  = { "MultiBarBottomLeftButton",  "MULTIACTIONBAR1BUTTON%i"                },
    [7]  = { "DominosActionButton",       "CLICK DominosActionButton%i:HOTKEY" },
    [8]  = { "DominosActionButton",       "CLICK DominosActionButton%i:HOTKEY" },
    [9]  = { "DominosActionButton",       "CLICK DominosActionButton%i:HOTKEY" },
    [10] = { "DominosActionButton",       "CLICK DominosActionButton%i:HOTKEY" },
  },
  ElvUI = {
    [1]  = { "ElvUI_Bar1Button",  "ACTIONBUTTON%i" },
    [2]  = { "ElvUI_Bar2Button",  "ELVUIBAR2BUTTON%i" },
    [3]  = { "ElvUI_Bar3Button",  "MULTIACTIONBAR3BUTTON%i" },
    [4]  = { "ElvUI_Bar4Button",  "MULTIACTIONBAR4BUTTON%i" },
    [5]  = { "ElvUI_Bar5Button",  "MULTIACTIONBAR2BUTTON%i" },
    [6]  = { "ElvUI_Bar6Button",  "MULTIACTIONBAR1BUTTON%i" },
    [7]  = { "ElvUI_Bar7Button",  "ELVUIBAR7BUTTON%i" },
    [8]  = { "ElvUI_Bar8Button",  "ELVUIBAR8BUTTON%i" },
    [9]  = { "ElvUI_Bar9Button",  "ELVUIBAR9BUTTON%i" },
    [10] = { "ElvUI_Bar10Button", "ELVUIBAR10BUTTON%i" },
  },
} -- { [AddOn] = { [BarIndex] = { [1] = ButtonBaseName, [2] = CommandNameFormat } } }

local function GetBarInfo(ActionSlot)
  local BarIndex = mathceil(ActionSlot / 12)
  local BarSlot = ActionSlot % 12
  if BarSlot == 0 then BarSlot = 12 end

  return BarIndex, BarSlot
end

local function GetButtonInfo(ActionSlot, Blizzard)
  local BarIndex, BarSlot = GetBarInfo(ActionSlot)

  local ButtonBaseName, ButtonSlot
  if Blizzard then
    -- Blizzard
    ButtonBaseName = ButtonByAddOn.Blizzard[BarIndex][1]

    if BarIndex >= 3 or BarIndex <= 6 then
      -- Bar 3 to 6: MultiBarXXXButton
      ButtonSlot = BarSlot
    else
      -- Bar 1 to 2 and 7 to 10: ActionButton
      ButtonSlot = ActionSlot
    end
  elseif _G.Bartender4 then
    -- Bartender
    ButtonBaseName = ButtonByAddOn.Bartender[1][1]
    ButtonSlot = ActionSlot
  elseif _G.Dominos then
    -- Dominos
    ButtonBaseName = ButtonByAddOn.Dominos[BarIndex][1]

    if BarIndex == 1 then
      -- Bar 1: ActionButton
      ButtonSlot = ActionSlot
    elseif BarIndex >= 3 and BarIndex <= 6 then
      -- Bar 3 to 6: MultiBarXXXButton
      ButtonSlot = BarSlot
    else
      -- Bar 2 and 7 to 10: DominosActionButton
      if BarIndex == 2 then
        -- Bar 2: First slot is 1 instead of 13
        ButtonSlot = ActionSlot - 12
      else
        -- Bar 7 to 10: First slot is 13 instead of 73
        ButtonSlot = ActionSlot - 60
      end
    end
  elseif _G.ElvUI and _G.ElvUI[1].ActionBars then
    -- ElvUI
    ButtonBaseName = ButtonByAddOn.ElvUI[BarIndex][1]
    ButtonSlot = BarSlot
  else
    -- Blizzard
    ButtonBaseName = ButtonByAddOn.Blizzard[BarIndex][1]

    if BarIndex >= 3 or BarIndex <= 6 then
      -- Bar 3 to 6: MultiBarXXXButton
      ButtonSlot = BarSlot
    else
      -- Bar 1 to 2 and 7 to 10: ActionButton
      ButtonSlot = ActionSlot
    end
  end

  return ButtonBaseName, ButtonSlot
end

local function GetButtonNameFromActionSlot(ActionSlot)
  local BarIndex = GetBarInfo(ActionSlot)
  local ButtonBaseName, ButtonSlot = GetButtonInfo(ActionSlot)

  return ButtonBaseName .. ButtonSlot
end

local function UpdateElvUIPaging(class)
  for i = 1, 10 do
    local BarNum = "bar"..i
    local PagingString = _G.ElvUI[1].ActionBars.db[BarNum].paging[class]
    if PagingString == "" or not PagingString then
      Cache.Persistent.ElvUIPaging.PagingStrings[i] = nil
      for k,v in pairs(Cache.Persistent.ElvUIPaging.PagingBars) do
        if v == i then Cache.Persistent.ElvUIPaging.PagingBars[k] = nil end
      end
    end
    if PagingString and PagingString ~= "" and Cache.Persistent.ElvUIPaging.PagingStrings[i] ~= PagingString then
      for match1 in (PagingString..";"):gmatch("(.-)"..";") do
        for match2 in (match1.." "):gmatch("(%d+)".." ") do
          if match2 then
            Cache.Persistent.ElvUIPaging.PagingStrings[i] = PagingString
            Cache.Persistent.ElvUIPaging.PagingBars[tonumber(match2)] = i
          end
        end
      end
    end
  end
end

local function GetCommandNameFromActionSlot(ActionSlot, Blizzard)
  local BarIndex = GetBarInfo(ActionSlot)
  local _, ButtonSlot = GetButtonInfo(ActionSlot)

  local CommandNameFormat
  if Blizzard then
    _, ButtonSlot = GetButtonInfo(ActionSlot, true)
    if (GetBonusBarOffset() > 0 and (BarIndex < 3 or BarIndex > 6) and (Cache.Persistent.Player.Class[1] == "Rogue" or Cache.Persistent.Player.Class[1] == "Druid")) then BarIndex = 1 end
    CommandNameFormat = ButtonByAddOn.Blizzard[BarIndex][2]
  elseif _G.Bartender4 then
    -- Bartender
    CommandNameFormat = ButtonByAddOn.Bartender[1][2]
  elseif _G.Dominos then
    -- Dominos
    CommandNameFormat = ButtonByAddOn.Dominos[BarIndex][2]
  elseif _G.ElvUI and _G.ElvUI[1].ActionBars then
    -- ElvUI
    if _G.ElvUI[1].ActionBars.db then
      UpdateElvUIPaging(Cache.Persistent.Player.Class[2])
      if Cache.Persistent.ElvUIPaging.PagingBars[BarIndex] then BarIndex = Cache.Persistent.ElvUIPaging.PagingBars[BarIndex] end
    end
    CommandNameFormat = ButtonByAddOn.ElvUI[BarIndex][2]
  else
    -- Blizzard
    if (GetBonusBarOffset() > 0 and (BarIndex < 3 or BarIndex > 6) and (Cache.Persistent.Player.Class[1] == "Rogue" or Cache.Persistent.Player.Class[1] == "Druid")) then BarIndex = 1 end
    CommandNameFormat = ButtonByAddOn.Blizzard[BarIndex][2]
  end

  -- Some actions cannot be binded, this is mostly the case for Blizzard bars.
  if CommandNameFormat then
    return (CommandNameFormat):format(ButtonSlot)
  end

  return nil
end

local function AddActionSlotsByValue(Type, Identifier, ActionSlot)
  local ActionSlots = ActionSlotsBy[Type][Identifier]
  if not ActionSlots then
    ActionSlots = {}
    ActionSlotsBy[Type][Identifier] = ActionSlots
  end

  tableinsert(ActionSlots, ActionSlot)
end

local function RemoveActionSlotsByValue(Type, Identifier, ActionSlot)
  local ActionSlots = ActionSlotsBy[Type][Identifier]
  tableremove(ActionSlots, Utils.FindValueIndexInArray(ActionSlots, ActionSlot))
end

local function ClearAction(ActionSlot)
  local PrevAction = Actions[ActionSlot]
  if not PrevAction then return end

  local ActionType, ActionID = PrevAction.Type, PrevAction.ID
  local ActionText = PrevAction.Text
  local ActionTexture = PrevAction.Texture

  if ActionTexture then
    RemoveActionSlotsByValue("Texture", ActionTexture, ActionSlot)
  end

  if ActionText then
    RemoveActionSlotsByValue("Text", ActionText, ActionSlot)
  end

  if ActionID then
    if ActionType == "spell" then
      RemoveActionSlotsByValue("Spell", ActionID, ActionSlot)
    elseif ActionType == "item" then
      RemoveActionSlotsByValue("Item", ActionID, ActionSlot)
    elseif ActionType == "macro" then
      RemoveActionSlotsByValue("Macro", ActionID, ActionSlot)
    end
  end

  Actions[ActionSlot] = nil
end

local function UpdateAction(ActionSlot)
  -- Prevent update for other actions than the one from ability bars.
  if not ActionSlot or ActionSlot <= 0 or ActionSlot > 120 then return end

  -- Clear the action info cached from the previous update.
  ClearAction(ActionSlot)

  -- Prevent any update if the slot is empty.
  if not HasAction(ActionSlot) then return end

  -- Update the action info.
  local ActionType, ActionID, ActionSubType = GetActionInfo(ActionSlot)
  if ActionID then
    if ActionType == "spell" then
      AddActionSlotsByValue("Spell", ActionID, ActionSlot)
    elseif ActionType == "item" then
      AddActionSlotsByValue("Item", ActionID, ActionSlot)
    elseif ActionType == "macro" then
      AddActionSlotsByValue("Macro", ActionID, ActionSlot)
    end
  end

  local ActionTexture = GetActionTexture(ActionSlot)
  if ActionTexture then
    AddActionSlotsByValue("Texture", ActionTexture, ActionSlot)
  end

  local ActionText = GetActionText(ActionSlot)
  if ActionText then
    AddActionSlotsByValue("Text", ActionText, ActionSlot)
  end

  local CommandName = GetCommandNameFromActionSlot(ActionSlot)
  local RawHotKey = (CommandName and GetBindingKey(CommandName)) or nil

  if RawHotKey == nil then
    CommandName = GetCommandNameFromActionSlot(ActionSlot, true)
    RawHotKey = (CommandName and GetBindingKey(CommandName)) or nil
  end

  local ActionHotKey = RawHotKey and Utils.ShortenHotKey(RawHotKey) or nil

  Actions[ActionSlot] = {
    Slot = ActionSlot,
    Type = ActionType,
    ID = ActionID,
    SubType = ActionSubType,
    Texture = ActionTexture,
    Text = ActionText,
    CommandName = CommandName,
    HotKey = ActionHotKey
  }
end

EL:RegisterForEvent(function(Event, ActionSlot) UpdateAction(ActionSlot) end, "ACTIONBAR_SLOT_CHANGED")

EL:RegisterForEvent(
  function()
    for i = 1, 120 do
      UpdateAction(i)
    end
  end,
  "ZONE_CHANGED_NEW_AREA", "PLAYER_SPECIALIZATION_CHANGED", "PLAYER_TALENT_UPDATE", "UPDATE_BINDINGS", "LEARNED_SPELL_IN_TAB", "SPELL_UPDATE_ICON", "UPDATE_SHAPESHIFT_FORM", "ACTIONBAR_UPDATE_USABLE"
)

local function FindAction(Type, Identifier)
  local ActionSlots = ActionSlotsBy[Type][Identifier]
  if not ActionSlots then return end

  -- If stealthed Rogue or form-shifted Druid, return the appropriate slot. Otherwise, return the first.
  local ActionSlot
  local BonusBarOffset = GetBonusBarOffset()
  if (BonusBarOffset > 0 and (Cache.Persistent.Player.Class[1] == "Rogue" or Cache.Persistent.Player.Class[1] == "Druid")) then
    for k,v in pairs(ActionSlots) do
      local low = (1 + (NUM_ACTIONBAR_PAGES + BonusBarOffset - 1) * NUM_ACTIONBAR_BUTTONS)
      local high = ((NUM_ACTIONBAR_PAGES + BonusBarOffset) * NUM_ACTIONBAR_BUTTONS)
      if v >= low and v <= high then
        ActionSlot = ActionSlots[k]
      end
    end
    -- Just in case the above couldn't find a slot, return the first slot in the array, unless it's on bar1.
    if not ActionSlot then 
      if #ActionSlots == 1 then
        ActionSlot = ActionSlots[1]
      else
        for k,v in pairs(ActionSlots) do
          if v > 12 then
            ActionSlot = ActionSlots[k]
            break
          end
        end
      end
    end
    if not ActionSlot then ActionSlot = ActionSlots[1] end
  else
    ActionSlot = ActionSlots[1]
  end
  if ActionSlot then
    return Actions[ActionSlot]
  end
end

function Action.FindByItemID(ItemID)
  return FindAction("Item", ItemID)
end

function Action.FindByMacroID(MacroID)
  return FindAction("Macro", MacroID)
end

function Action.FindBySpellID(SpellID)
  return FindAction("Spell", SpellID)
end

function Action.FindByText(Text)
  return FindAction("Text", Text)
end

function Action.FindByTextureID(TextureID)
  return FindAction("Texture", TextureID)
end

do
  local function WhitelistHotKey(Type, Identifier, HotKey)
    HotKeyWhitelist[Type][Identifier] = HotKey
  end

  function Action.WhitelistItemHotKey(ItemID, HotKey)
    WhitelistHotKey("Item", ItemID, HotKey)
  end

  function Action.WhitelistMacroHotKey(MacroID, HotKey)
    WhitelistHotKey("Macro", MacroID, HotKey)
  end

  function Action.WhitelistSpellHotKey(SpellID, HotKey)
    WhitelistHotKey("Spell", SpellID, HotKey)
  end

  function Action.WhitelistTextHotKey(Text, HotKey)
    WhitelistHotKey("Text", Text, HotKey)
  end

  function Action.WhitelistTextureHotKey(TextureID, HotKey)
    WhitelistHotKey("Texture", TextureID, HotKey)
  end
end

do
  local function HotKey(Type, Identifier)
    local WhitelistedHotKey = HotKeyWhitelist[Type][Identifier]
    if WhitelistedHotKey then
      return WhitelistedHotKey
    end

    local ThisAction = FindAction(Type, Identifier)
    if ThisAction then
      return ThisAction.HotKey
    end

    return nil
  end

  function Action.ItemHotKey(ItemID)
    return HotKey("Item", ItemID)
  end

  function Action.MacroHotKey(MacroID)
    return HotKey("Macro", MacroID)
  end

  function Action.SpellHotKey(SpellID)
    return HotKey("Spell", SpellID)
  end

  function Action.TextHotKey(Text)
    return HotKey("Text", Text)
  end

  function Action.TextureHotKey(TextureID)
    return HotKey("Texture", TextureID)
  end
end

function Unit:IsItemInActionRange(ThisItem)
  local ItemID = ThisItem:ID()
  local ThisAction = Action.FindByItemID(ItemID)
  if not ThisAction then
    return false
  end

  return self:IsActionInRange(Action.Slot)
end

function Unit:IsSpellInActionRange(ThisSpell)
  local SpellID = ThisSpell:ID()
  local ThisAction = Action.FindBySpellID(SpellID)
  if not ThisAction then
    return false
  end

  return self:IsActionInRange(ThisAction.Slot)
end
