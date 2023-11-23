--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...
-- EpicLib
local Cache = EpicCache
local Unit = EL.Unit
local Player = Unit.Player
local Pet = Unit.Pet
local Target = Unit.Target
local Spell = EL.Spell
local Item = EL.Item
-- Lua
local BOOKTYPE_PET, BOOKTYPE_SPELL = BOOKTYPE_PET, BOOKTYPE_SPELL
local C_Timer = C_Timer
local GetFlyoutInfo, GetFlyoutSlotInfo = GetFlyoutInfo, GetFlyoutSlotInfo
local GetNumFlyouts, GetFlyoutID = GetNumFlyouts, GetFlyoutID
local GetNumSpellTabs = GetNumSpellTabs
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpellBookItemInfo = GetSpellBookItemInfo
local GetSpellInfo, GetSpellTabInfo = GetSpellInfo, GetSpellTabInfo
local GetTime = GetTime
local HasPetSpells = HasPetSpells
local IsTalentSpell = IsTalentSpell
local stringfind = string.find
local stringsub = string.sub
local UnitClass = UnitClass
local wipe = wipe
local SPELL_FAILED_UNIT_NOT_INFRONT = SPELL_FAILED_UNIT_NOT_INFRONT
-- File Locals


--- ============================ CONTENT ============================
-- Scan the Book to cache every Spell Learned.
local function BookScan(BlankScan)
  -- Pet Book
  do
    local NumPetSpells = HasPetSpells()
    if NumPetSpells then
      local SpellLearned = Cache.Persistent.SpellLearned.Pet
      for i = 1, NumPetSpells do
        local CurrentSpellID = select(7, GetSpellInfo(i, BOOKTYPE_PET))
        if CurrentSpellID then
          local CurrentSpell = Spell(CurrentSpellID, "Pet")
          if CurrentSpell:IsAvailable(true) and (CurrentSpell:IsKnown(true) or IsTalentSpell(i, BOOKTYPE_PET)) then
            if not BlankScan then
              SpellLearned[CurrentSpell:ID()] = true
            end
          end
        end
      end
    end
  end
  -- Player Book
  do
    local SpellLearned = Cache.Persistent.SpellLearned.Player

    for i = 1, GetNumSpellTabs() do
      local Offset, NumSpells, _, OffSpec = select(3, GetSpellTabInfo(i))
      -- GetSpellTabInfo has been updated, it now returns the OffSpec ID.
      -- If the OffSpec ID is set to 0, then it's the Main Spec.
      if OffSpec == 0 then
        for j = 1, (Offset + NumSpells) do
          local CurrentSpellID = select(7, GetSpellInfo(j, BOOKTYPE_SPELL))
          if CurrentSpellID and GetSpellBookItemInfo(j, BOOKTYPE_SPELL) == "SPELL" then
            if not BlankScan then
              SpellLearned[CurrentSpellID] = true
            end
          end
        end
      end
    end

    -- Flyout Spells
    for i = 1, GetNumFlyouts() do
      local FlyoutID = GetFlyoutID(i)
      local NumSlots, IsKnown = select(3, GetFlyoutInfo(FlyoutID))
      if IsKnown and NumSlots > 0 then
        for j = 1, NumSlots do
          local CurrentSpellID, _, IsKnownSpell = GetFlyoutSlotInfo(FlyoutID, j)
          if CurrentSpellID and IsKnownSpell then
            SpellLearned[CurrentSpellID] = true
          end
        end
      end
    end
  end
end

-- Avoid creating garbage for pcall calls
local function BlankBookScan ()
  BookScan(true)
end

-- PLAYER_REGEN_DISABLED
EL.CombatStarted = 0
EL.CombatEnded = 1
-- Entering Combat
EL:RegisterForEvent(
  function()
    EL.CombatStarted = GetTime()
    EL.CombatEnded = 0
  end,
  "PLAYER_REGEN_DISABLED"
)

-- PLAYER_REGEN_ENABLED
-- Leaving Combat
EL:RegisterForEvent(
  function()
    EL.CombatStarted = 0
    EL.CombatEnded = GetTime()
  end,
  "PLAYER_REGEN_ENABLED"
)

-- CHAT_MSG_ADDON
-- DBM/BW Pull Timer
EL:RegisterForEvent(
  function(Event, Prefix, Message)
    if Prefix == "D4" and stringfind(Message, "PT") then
      EL.BossModTime = tonumber(stringsub(Message, 4, 5))
      EL.BossModEndTime = GetTime() + EL.BossModTime
    elseif Prefix == "BigWigs" and string.find(Message, "Pull") then
      EL.BossModTime = tonumber(stringsub(Message, 8, 9))
      EL.BossModEndTime = GetTime() + EL.BossModTime
    end
  end,
  "CHAT_MSG_ADDON"
)

-- Player Inspector
EL:RegisterForEvent(
  function(Event, Arg1)
    -- Prevent execute if not initiated by the player
    if Event == "PLAYER_SPECIALIZATION_CHANGED" and Arg1 ~= "player" then
      return
    end

    -- Update Player
    Cache.Persistent.Player.Class = { UnitClass("player") }
    Cache.Persistent.Player.Spec = { GetSpecializationInfo(GetSpecialization()) }

    -- Wipe the texture from Persistent Cache
    wipe(Cache.Persistent.Texture.Spell)
    wipe(Cache.Persistent.Texture.Item)

    -- Update Equipment
    Player:UpdateEquipment()

    -- Load / Refresh Core Overrides
    if Event == "PLAYER_SPECIALIZATION_CHANGED" then
      local UpdateOverrides
      UpdateOverrides = function()
        if Cache.Persistent.Player.Spec[1] ~= nil then
          EL.LoadRestores()
          EL.LoadOverrides(Cache.Persistent.Player.Spec[1])
        else
          C_Timer.After(2, UpdateOverrides)
        end
      end
      UpdateOverrides()
    end

    if Event == "PLAYER_SPECIALIZATION_CHANGED" or Event == "PLAYER_TALENT_UPDATE" or Event == "TRAIT_CONFIG_UPDATED" then
      UpdateTalents = function()
        wipe(Cache.Persistent.Talents)
        local TalentConfigID = C_ClassTalents.GetActiveConfigID()
        local TalentConfigInfo
        if TalentConfigID then
          TalentConfigInfo = C_Traits.GetConfigInfo(TalentConfigID)
        end
        if TalentConfigID ~= nil and TalentConfigInfo ~= nil then
          local TalentTreeIDs = TalentConfigInfo["treeIDs"]
          for i = 1, #TalentTreeIDs do
            for _, NodeID in pairs(C_Traits.GetTreeNodes(TalentTreeIDs[i])) do
              local NodeInfo = C_Traits.GetNodeInfo(TalentConfigID, NodeID)
              local ActiveTalent = NodeInfo.activeEntry
              local TalentRank = NodeInfo.activeRank
              if (ActiveTalent and TalentRank > 0) then
                local TalentEntryID = ActiveTalent.entryID
                local TalentEntryInfo = C_Traits.GetEntryInfo(TalentConfigID, TalentEntryID)
                local DefinitionID = TalentEntryInfo["definitionID"]
                local DefinitionInfo = C_Traits.GetDefinitionInfo(DefinitionID)
                local SpellID = DefinitionInfo["spellID"]
                local SpellName = GetSpellInfo(SpellID)
                Cache.Persistent.Talents[SpellID] = (Cache.Persistent.Talents[SpellID]) and (Cache.Persistent.Talents[SpellID] + TalentRank) or TalentRank
              end
            end
          end
        else
          C_Timer.After(2, UpdateTalents)
        end
      end
      UpdateTalents()
    end
  end,
  "PLAYER_LOGIN", "ZONE_CHANGED_NEW_AREA", "PLAYER_SPECIALIZATION_CHANGED", "PLAYER_TALENT_UPDATE", "PLAYER_EQUIPMENT_CHANGED", "TRAIT_CONFIG_UPDATED"
)

-- Player Unit Cache
EL:RegisterForEvent(
  function(Event, Arg1)
    Player:Cache()
    -- TODO: fix timing issue via event?
    C_Timer.After(3, function() Player:Cache() end)
  end,
  "PLAYER_LOGIN"
)

-- Spell Book Scanner
-- Checks the same event as Blizzard Spell Book, from SpellBookFrame_OnLoad in SpellBookFrame.lua
EL:RegisterForEvent(
  function(Event, Arg1)
    -- Prevent execute if not initiated by the player
    if Event == "PLAYER_SPECIALIZATION_CHANGED" and Arg1 ~= "player" then
      return
    end

    -- FIXME: workaround to prevent Lua errors when Blizz do some shenanigans with book in Arena/Timewalking
    if pcall(BlankBookScan) then
      wipe(Cache.Persistent.BookIndex.Player)
      wipe(Cache.Persistent.BookIndex.Pet)
      wipe(Cache.Persistent.SpellLearned.Player)
      wipe(Cache.Persistent.SpellLearned.Pet)
      BookScan()
    end
  end,
  "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB", "SKILL_LINES_CHANGED", "PLAYER_GUILD_UPDATE", "PLAYER_SPECIALIZATION_CHANGED", "USE_GLYPH", "CANCEL_GLYPH_CAST", "ACTIVATE_GLYPH"
)

-- Not Facing Unit Blacklist
EL.UnitNotInFront = Player
EL.UnitNotInFrontTime = 0
EL.LastUnitCycled = Player
EL.LastUnitCycledTime = 0
EL:RegisterForEvent(
  function(Event, MessageType, Message)
    if MessageType == 50 and Message == SPELL_FAILED_UNIT_NOT_INFRONT then
      EL.UnitNotInFront = EL.LastUnitCycled
      EL.UnitNotInFrontTime = EL.LastUnitCycledTime
    end
  end,
  "UI_ERROR_MESSAGE"
)
