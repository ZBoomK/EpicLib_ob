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
local pairs = pairs
-- File Locals


--- ============================ CONTENT ============================
-- Nameplate Updated
do
  local NameplateUnits = Unit.Nameplate

  EL:RegisterForEvent(function(Event, UnitID) NameplateUnits[UnitID]:Cache() end, "NAME_PLATE_UNIT_ADDED")
  EL:RegisterForEvent(function(Event, UnitID) NameplateUnits[UnitID]:Init() end, "NAME_PLATE_UNIT_REMOVED")
end

-- Player Target Updated
EL:RegisterForEvent(function() Target:Cache() end, "PLAYER_TARGET_CHANGED")

-- Player Focus Target Updated
do
  local Focus = Unit.Focus

  EL:RegisterForEvent(function() Focus:Cache() end, "PLAYER_FOCUS_CHANGED")
end

-- Arena Unit Updated
do
  local ArenaUnits = Unit.Arena

  EL:RegisterForEvent(
    function(Event, UnitID)
      local ArenaUnit = ArenaUnits[UnitID]
      if ArenaUnit then ArenaUnit:Cache() end
    end,
    "ARENA_OPPONENT_UPDATE"
  )
end

-- Boss Unit Updated
do
  local BossUnits = Unit.Boss

  EL:RegisterForEvent(
    function()
      for _, BossUnit in pairs(BossUnits) do BossUnit:Cache() end
    end,
    "INSTANCE_ENCOUNTER_ENGAGE_UNIT"
  )
end

-- Party/Raid Unit Updated
EL:RegisterForEvent(
  function()
    for _, PartyUnit in pairs(Unit.Party) do PartyUnit:Cache() end
    for _, RaidUnit in pairs(Unit.Raid) do RaidUnit:Cache() end
  end,
  "GROUP_ROSTER_UPDATE"
)
-- TODO: Need to maybe also update friendly units with:
-- PARTY_MEMBER_ENABLE
-- PARTY_MEMBER_DISABLE

-- General Unit Target Updated
do
  local Focus = Unit.Focus
  local BossUnits, PartyUnits, RaidUnits, NameplateUnits = Unit.Boss, Unit.Party, Unit.Raid, Unit.Nameplate

  EL:RegisterForEvent(
    function(Event, UnitID)
      if UnitID == Target:ID() then
        Target:Cache()
      elseif UnitID == Focus:ID() then
        Focus:Cache()
      else
        local FoundUnit = PartyUnits[UnitID] or RaidUnits[UnitID] or BossUnits[UnitID] or NameplateUnits[UnitID]
        if FoundUnit then FoundUnit:Cache() end
      end
    end,
    "UNIT_TARGETABLE_CHANGED", "UNIT_FACTION", "UNIT_FLAGS"
  )
end
