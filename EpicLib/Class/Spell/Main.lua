--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...
-- EpicDBC
local DBC = EpicDBC.DBC
-- EpicLib
local Cache, Utils = EpicCache, EL.Utils
local Unit = EL.Unit
local Player, Pet, Target = Unit.Player, Unit.Pet, Unit.Target
local Focus, MouseOver = Unit.Focus, Unit.MouseOver
local Arena, Boss, Nameplate = Unit.Arena, Unit.Boss, Unit.Nameplate
local Party, Raid = Unit.Party, Unit.Raid
local Spell = EL.Spell
local Item = EL.Item
-- Lua
local GetTime = GetTime
local GetSpellInfo = GetSpellInfo -- name, rank, icon, castTime, minRange, maxRange, spellId
local IsSpellKnown = IsSpellKnown
local IsPlayerSpell = IsPlayerSpell
local IsUsableSpell = IsUsableSpell
local GetSpellCount = GetSpellCount
local GetSpellPowerCost = GetSpellPowerCost
local pairs = pairs
local unpack = unpack
local wipe = table.wipe
-- File Locals



--- ============================ CONTENT ============================
-- Get the spell ID.
function Spell:ID()
  return self.SpellID
end

-- Get the spell Type.
function Spell:Type()
  return self.SpellType
end

-- Get the spell Name.
function Spell:Name()
  return self.SpellName
end

-- Get the spell Minimum Range.
function Spell:MinimumRange()
  return self.MinimumRange
end

-- Get the spell Maximum Range.
function Spell:MaximumRange()
  return self.MaximumRange
end

-- Check if the spell Is Melee or not.
function Spell:IsMelee()
  return self.IsMelee
end

-- Get the spell Info from the spell ID.
function Spell:InfoByID()
  return GetSpellInfo(self:ID())
end

-- Get the spell Info from the spell Name.
function Spell:InfoByName()
  return GetSpellInfo(self:Name())
end

-- Get the Time since Last spell Cast.
function Spell:TimeSinceLastCast()
  return GetTime() - self.LastCastTime
end

-- Get the Time since Last spell Display.
function Spell:TimeSinceLastDisplay()
  return GetTime() - self.LastDisplayTime
end

-- Get the Time since Last Buff applied on the player.
function Spell:TimeSinceLastAppliedOnPlayer()
  return GetTime() - self.LastAppliedOnPlayerTime
end

-- Get the Time since Last Buff removed from the player.
function Spell:TimeSinceLastRemovedOnPlayer()
  return GetTime() - self.LastRemovedFromPlayerTime
end

-- Register the spell damage formula.
function Spell:RegisterDamageFormula(Function)
  self.DamageFormula = Function
end

-- Get the spell damage formula if it exists.
function Spell:Damage()
  return self.DamageFormula and self.DamageFormula() or 0
end

-- Check if the spell Is Available or not.
function Spell:IsAvailable(CheckPet)
  return CheckPet and IsSpellKnown(self.SpellID, true) or IsPlayerSpell(self.SpellID)
end

-- Check if the spell Is Known or not.
function Spell:IsKnown(CheckPet)
  return IsSpellKnown(self.SpellID, CheckPet and true or false)
end

-- Check if the spell Is Known (including Pet) or not.
function Spell:IsPetKnown()
  return self:IsKnown(true)
end

-- Check if the spell Is Usable or not.
function Spell:IsUsable()
  return IsUsableSpell(self.SpellID)
end

-- Check if the spell is Usable (by resources) in predicted mode
function Spell:IsUsableP(Offset)
  -- Handle case where spell is actually disabled not due to missing resources
  local SpellUsable, SpellMissingResource = self:IsUsable()
  if SpellUsable == false and SpellMissingResource == false then
    return false
  end

  local CostTable = self:CostTable() or {}
  local Usable = true
  if #CostTable > 0 then
    local i = 1
    while Usable == true and i <= #CostTable do
        local CostInfo = CostTable[i]
        local Type = CostInfo.type
        if Player.PredictedResourceMap[Type]() < ((self.CustomCost and self.CustomCost[Type] and self.CustomCost[Type]()) or CostInfo.minCost) + (Offset or 0) then
          Usable = false
        end
        i = i + 1
    end
  end
  return Usable
end

-- Only checks IsUsableP against the primary resource for pooling
function Spell:IsUsablePPool(Offset)
  local CostTable = self:CostTable()
  if #CostTable > 0 then
    local CostInfo = CostTable[1]
    local Type = CostInfo.type
    return Player.PredictedResourceMap[Type]() < ((self.CustomCost and self.CustomCost[Type] and self.CustomCost[Type]()) or CostInfo.minCost) + (Offset or 0)
  else
    return true
  end
end

-- Check if the spell is in the Spell Learned Cache.
function Spell:IsLearned()
  return Cache.Persistent.SpellLearned[self:Type()][self:ID()] or false
end

function Spell:Count()
  return GetSpellCount(self:ID())
end

-- Check if the spell Is Castable or not.
function Spell:IsCastable(BypassRecovery)
  return self:IsLearned() and self:CooldownUp(BypassRecovery)
end

-- Check if the spell Is Castable and Usable or not.
function Spell:IsReady()
  return self:IsCastable() and self:IsUsableP()
end

-- action.foo.cast_time
function Spell:CastTime()
  local _, _, _, CastTime = self:InfoByID()

  return CastTime and CastTime / 1000 or 0
end

-- action.foo.execute_time
function Spell:ExecuteTime()
  local CastTime = self:CastTime()
  local GCD = Player:GCD()

  return CastTime > GCD and CastTime or GCD
end

-- action.foo.execute_remains
function Spell:ExecuteRemains()
  if not Player:IsCasting(self) then return 0 end
  local CastRemains = Player:CastRemains()
  local GCDRemains = Player:GCDRemains()

  return CastRemains > GCDRemains and CastRemains or GCDRemains
end

-- Get the CostTable using GetSpellPowerCost.
function Spell:CostTable()
  local SpellID = self.SpellID

  local SpellInfo = Cache.SpellInfo[SpellID]
  if not SpellInfo then
    SpellInfo = {}
    Cache.SpellInfo[SpellID] = SpellInfo
  end

  local CostTable = SpellInfo.CostTable
  if not CostTable then
    -- {hasRequiredAura, type, name, cost, minCost, requiredAuraID, costPercent, costPerSec}
    CostTable = GetSpellPowerCost(SpellID)
    SpellInfo.CostTable = CostTable
  end

  return CostTable
end

-- Get the CostInfo from the CostTable.
function Spell:CostInfo(Index, Key)
  if not Key or type(Key) ~= "string" then error("Invalid Key type.") end

  local CostTable = self:CostTable()

  -- Convert Combo Points to Energy as default resource if applicable
  if not Index and CostTable and #CostTable > 1 and CostTable[1]["type"] == 4 and CostTable[2]["type"] == 3 then
    Index = 2
  else
    Index = Index or 1
  end

  return CostTable and CostTable[Index] and CostTable[Index][Key] or nil
end

-- action.foo.cost
function Spell:Cost(Index)
  local Cost = self:CostInfo(Index, "cost")

  return Cost or 0
end

-- talent.foo.rank
function Spell:TalentRank()
  return Cache.Persistent.Talents[self.SpellID] or 0
end

-- Spell Tick Time
do
  local SpellTickTime = DBC.SpellTickTime
  local ClassesSpecsBySpecID = EL.SpecID_ClassesSpecs

  function Spell:FilterTickTime(SpecID)
    local RegisteredSpells = {}

    -- Fetch registered spells during the init
    for _, SpecSpells in pairs(ClassesSpecsBySpecID[SpecID][1]) do
      for _, ThisSpell in pairs(SpecSpells) do
        local SpellID = ThisSpell:ID()
        local TickTimeInfo = SpellTickTime[SpellID][1]
        if TickTimeInfo ~= nil then
          RegisteredSpells[SpellID] = TickTimeInfo
        end
      end
    end

    SpellTickTime = RegisteredSpells
  end

  function Spell:BaseTickTime()
    local Tick = SpellTickTime[self:ID()]
    if not Tick or Tick == 0 then return 0 end

    return Tick[1] / 1000
  end

  -- action.foo.tick_time
  function Spell:TickTime()
    local BaseTickTime = self:BaseTickTime()
    if not BaseTickTime or BaseTickTime == 0 then return 0 end

    local Hasted = SpellTickTime[self:ID()][2]
    if Hasted then return BaseTickTime * Player:SpellHaste() end

    return BaseTickTime
  end
end

-- Spell Duration
do
  local SpellDuration = DBC.SpellDuration

  function Spell:BaseDuration()
    local Duration = SpellDuration[self:ID()]
    if not Duration or Duration == 0 then return 0 end

    return Duration[1] / 1000
  end

  function Spell:MaxDuration()
    local Duration = SpellDuration[self.SpellID]
    if not Duration or Duration == 0 then return 0 end

    return Duration[2] / 1000
  end

  function Spell:PandemicThreshold()
    local BaseDuration = self:BaseDuration()
    if not BaseDuration or BaseDuration == 0 then return 0 end

    return BaseDuration * 0.3
  end
end

-- Spell GCD
do
  local SpellGCD = DBC.SpellGCD

  function Spell:GCD()
    local GCD = SpellGCD[self.SpellID]
    if not GCD or GCD == 0 then return 0 end

    return GCD / 1000
  end
end

-- action.foo.travel_time
do
  local SpellProjectileSpeed = DBC.SpellProjectileSpeed
  local ClassesSpecsBySpecID = EL.SpecID_ClassesSpecs

  function Spell:FilterProjectileSpeed(SpecID)
    local RegisteredSpells = {}

    -- Fetch registered spells during the init
    for _, SpecSpells in pairs(Spell[ClassesSpecsBySpecID[SpecID][1]]) do
      for _, ThisSpell in pairs(SpecSpells) do
        local SpellID = ThisSpell:ID()
        local ProjectileSpeed = SpellProjectileSpeed[SpellID]
        if ProjectileSpeed ~= nil then
          RegisteredSpells[SpellID] = ProjectileSpeed
        end
      end
    end

    SpellProjectileSpeed = RegisteredSpells
  end

  function Spell:TravelTime(ThisUnit)
    local SpellID = self:ID()

    local Speed = SpellProjectileSpeed[SpellID]
    if not Speed or Speed == 0 then return 0 end

    local MaxDistance = (ThisUnit and ThisUnit:MaxDistance()) or Target:MaxDistance()
    if not MaxDistance then return 0 end

    return MaxDistance / (Speed or 22)
  end
end

-- action.foo.in_flight
function Spell:IsInFlight()
  return GetTime() < self.LastHitTime
end

