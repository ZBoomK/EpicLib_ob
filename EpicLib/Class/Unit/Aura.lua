--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...
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
local UnitAura = UnitAura -- name, icon, count, dispelType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellID, canApplyAura, isBossAura, casterIsPlayer, nameplateShowAll, timeMod, value1, value2, value3, ..., value11
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local GetTime = GetTime
-- File Locals



--- ============================ CONTENT ============================
-- Note: BypassRecovery is a common arg of this module because by default, in order to improve the prediction, we take in account the remaining time of the GCD or the current cast (whichever is higher).
--       Although sometimes we might want to ignore this and return the "raw" value, which this arg is for.

-- Get the AuraInfo (from UnitAura).
-- Only returns Stack, Duration, ExpirationTime, Index by default. Except if the Full argument is truthy then it is the UnitAura call that is returned.
do
  local GUID, SpellID, UnitID
  local AuraStack, AuraDuration, AuraExpirationTime, AuraSpellID, Index

  function Unit:AuraInfo(ThisSpell, Filter, Full)
    GUID = self:GUID()
    if not GUID then return end

    SpellID = ThisSpell:ID()

    -- Use GetPlayerAuraBySpellID if we are checking a player buff as it is more performant and finds more things
    if GUID == Player:GUID() then
      if Full then
        return GetPlayerAuraBySpellID(SpellID)
      else
        local spellTable = GetPlayerAuraBySpellID(SpellID)
        if type(spellTable) ~= "table" then return nil end
        AuraDuration = spellTable.duration
        AuraExpirationTime = spellTable.expirationTime
        AuraStack = spellTable.applications
        return AuraStack, AuraDuration, AuraExpirationTime
      end
    end

    UnitID = self:ID()
    Index = 1
    while true do
      _, _, AuraStack, _, AuraDuration, AuraExpirationTime, _, _, _, AuraSpellID = UnitAura(UnitID, Index, Filter)

      -- Returns no value if the aura was not found.
      if not AuraSpellID then return end

      -- Returns the info once we match the spell ids.
      if AuraSpellID == SpellID then
        if Full then
          return UnitAura(UnitID, Index, Filter)
        else
          return AuraStack, AuraDuration, AuraExpirationTime, Index
        end
        --return Full and UnitAura(UnitID, Index, Filter) or AuraStack, AuraDuration, AuraExpirationTime, Index
      end

      Index = Index + 1
    end
  end
end

-- Get the BuffInfo (from AuraInfo).
function Unit:BuffInfo(ThisSpell, AnyCaster, Full)
  local Filter = AnyCaster and "HELPFUL" or "HELPFUL|PLAYER"

  return self:AuraInfo(ThisSpell, Filter, Full)
end

-- buff.foo.stack
function Unit:BuffStack(ThisSpell, AnyCaster, BypassRecovery)
  -- In the case we are using the prediction, we have to check if the buff will still be there before considering its stacks.
  if not BypassRecovery and self:BuffDown(ThisSpell, AnyCaster, BypassRecovery) then return 0 end

  local Stack = self:BuffInfo(ThisSpell, AnyCaster)

  return Stack or 0
end

-- buff.foo.duration
function Unit:BuffDuration(ThisSpell, AnyCaster)
  local _, Duration = self:BuffInfo(ThisSpell, AnyCaster)

  return Duration or 0
end

-- buff.foo.remains
function Unit:BuffRemains(ThisSpell, AnyCaster, BypassRecovery)
  local _, _, ExpirationTime = self:BuffInfo(ThisSpell, AnyCaster)
  if not ExpirationTime then return 0 end
  if ExpirationTime == 0 then return 9999 end

  -- TODO: Why this is here ?
  -- Stealth-like buffs (Subterfurge and Master Assassin) are delayed but within aura latency
  local SpellID = ThisSpell:ID()
  if SpellID == 115192 or SpellID == 256735 then
    ExpirationTime = ExpirationTime - 0.3
  end

  local Remains = ExpirationTime - GetTime() - EL.RecoveryOffset(BypassRecovery)

  return Remains >= 0 and Remains or 0
end

-- buff.foo.up
function Unit:BuffUp(ThisSpell, AnyCaster, BypassRecovery)
  return self:BuffRemains(ThisSpell, AnyCaster, BypassRecovery) > 0
end

-- buff.foo.down
function Unit:BuffDown(ThisSpell, AnyCaster, BypassRecovery)
  return not self:BuffUp(ThisSpell, AnyCaster, BypassRecovery)
end

-- "buff.foo.refreshable" (doesn't exists on SimC), automaticaly calculates the PandemicThreshold from EpicDBC spell data.
function Unit:BuffRefreshable(ThisSpell, AnyCaster, BypassRecovery)
  local PandemicThreshold = ThisSpell:PandemicThreshold()

  return self:BuffRemains(ThisSpell, AnyCaster, BypassRecovery) <= PandemicThreshold
end

-- hot.foo.ticks_remain
function Unit:BuffTicksRemain(ThisSpell, AnyCaster, BypassRecovery)
  local Remains = self:BuffRemains(ThisSpell, AnyCaster, BypassRecovery)
  if Remains == 0 then return 0 end

  return math.ceil(Remains / ThisSpell:TickTime())
end

-- Get the DebuffInfo (from AuraInfo).
function Unit:DebuffInfo(ThisSpell, AnyCaster, Full)
  local Filter = AnyCaster and "HARMFUL" or "HARMFUL|PLAYER"

  return self:AuraInfo(ThisSpell, Filter, Full)
end

-- debuff.foo.stack & dot.foo.stack
function Unit:DebuffStack(ThisSpell, AnyCaster, BypassRecovery)
  -- In the case we are using the prediction, we have to check if the debuff will still be there before considering its stacks.
  if not BypassRecovery and self:DebuffDown(ThisSpell, AnyCaster, BypassRecovery) then return 0 end

  local Stack = self:DebuffInfo(ThisSpell, AnyCaster)

  return Stack or 0
end

-- debuff.foo.duration & dot.foo.duration
function Unit:DebuffDuration(ThisSpell, AnyCaster)
  local _, Duration = self:DebuffInfo(ThisSpell, AnyCaster)

  return Duration or 0
end

-- debuff.foo.remains & dot.foo.remains
function Unit:DebuffRemains(ThisSpell, AnyCaster, BypassRecovery)
  local _, _, ExpirationTime = self:DebuffInfo(ThisSpell, AnyCaster)
  if not ExpirationTime then return 0 end
  if ExpirationTime == 0 then return 9999 end

  local Remains = ExpirationTime - GetTime() - EL.RecoveryOffset(BypassRecovery)

  return Remains >= 0 and Remains or 0
end

-- debuff.foo.up
function Unit:DebuffUp(ThisSpell, AnyCaster, BypassRecovery)
  return self:DebuffRemains(ThisSpell, AnyCaster, BypassRecovery) > 0
end

-- debuff.foo.down
function Unit:DebuffDown(ThisSpell, AnyCaster, BypassRecovery)
  return not self:DebuffUp(ThisSpell, AnyCaster, BypassRecovery)
end

-- debuff.foo.refreshable & dot.foo.refreshable, automaticaly calculates the PandemicThreshold from EpicDBC spell data.
function Unit:DebuffRefreshable(ThisSpell, PandemicThreshold, AnyCaster, BypassRecovery)
  local PandemicThreshold = PandemicThreshold or ThisSpell:PandemicThreshold()
  return self:DebuffRemains(ThisSpell, AnyCaster, BypassRecovery) <= PandemicThreshold
end

-- dot.foo.ticks_remain
function Unit:DebuffTicksRemain(ThisSpell, AnyCaster, BypassRecovery)
  local Remains = self:DebuffRemains(ThisSpell, AnyCaster, BypassRecovery)
  if Remains == 0 then return 0 end

  return math.ceil(Remains / ThisSpell:TickTime())
end


do
  local BloodlustSpells = {
    -- Abilities
    Spell(2825), -- Shaman: Bloodlust (Horde)
    Spell(32182), -- Shaman: Heroism (Alliance)
    Spell(80353), -- Mage:Time Warp
    Spell(90355), -- Hunter: Ancient Hysteria
    Spell(160452), -- Hunter: Netherwinds
    Spell(264667), -- Hunter: Primal Rage
    Spell(390386), -- Evoker: Fury of the Aspects
    -- Drums
    Spell(35475), -- Drums of War (Cata)
    Spell(35476), -- Drums of Battle (Cata)
    Spell(146555), -- Drums of Rage (MoP)
    Spell(178207), -- Drums of Fury (WoD)
    Spell(230935), -- Drums of the Mountain (Legion)
    Spell(256740), -- Drums of the Maelstrom (BfA)
    Spell(309658), -- Drums of Deathly Ferocity (SL)
    Spell(381301), -- Feral Hide Drums (DF)
  }

  -- buff.bloodlust.remains
  function Unit:BloodlustRemains(BypassRecovery)
    local GUID = self:GUID()
    if not GUID then return false end

    for i = 1, #BloodlustSpells do
      local BloodlustSpell = BloodlustSpells[i]
      if self:BuffUp(BloodlustSpell, nil) then
        return self:BuffRemains(BloodlustSpell, nil, BypassRecovery)
      end
    end

    return 0
  end

  -- buff.bloodlust.up
  function Unit:BloodlustUp(BypassRecovery)
    return self:BloodlustRemains(BypassRecovery) > 0
  end

  -- buff.bloodlust.down
  function Unit:BloodlustDown(BypassRecovery)
    return not self:BloodlustUp(BypassRecovery)
  end
end

do
  local PowerInfusionSpells = {
    -- Abilities
    Spell(10060), -- Priest: Power Infusion
  }

  -- buff.power_infusion.remains
  function Unit:PowerInfusionRemains(BypassRecovery)
    local GUID = self:GUID()
    if not GUID then return false end

    for i = 1, #PowerInfusionSpells do
      local PowerInfusionSpell = PowerInfusionSpells[i]
      if self:BuffUp(PowerInfusionSpell, nil) then
        return self:BuffRemains(PowerInfusionSpell, nil, BypassRecovery)
      end
    end

    return 0
  end

  -- buff.power_infusion.up
  function Unit:PowerInfusionUp(BypassRecovery)
    return self:PowerInfusionRemains(BypassRecovery) > 0
  end

  -- buff.power_infusion.down
  function Unit:PowerInfusionDown(BypassRecovery)
    return not self:PowerInfusionUp(BypassRecovery)
  end
end

do
  local BloodlustExhaustSpells = {
    --TODO : look for other debuffs
    -- Abilities
    Spell(57724),   -- Shaman: Sated (Horde)
    Spell(57723),   -- Shaman: Exhaustion (Alliance)
    Spell(80354),   -- Mage:Temporal Displacement
    Spell(264689),  -- Hunter: Fatigued
    Spell(390435),  -- Evoker: Exhaustion
    -- Drums
    --Spell(35475), -- Drums of War
    --Spell(35476), -- Drums of Battle
    --Spell(146555), -- Drums of Rage
    --Spell(178207), -- Drums of Fury
    --Spell(230935), -- Drums of the Mountain
    --Spell(256740), -- Drums of the Maelstrom
    --Spell(309658), -- Drums of Deathly Ferocity
  }

  -- buff.bloodlust.remains
  function Unit:BloodlustExhaustRemains(BypassRecovery)
    local GUID = self:GUID()
    if not GUID then return false end

    for i = 1, #BloodlustExhaustSpells do
      local BloodlustExhaustSpell = BloodlustExhaustSpells[i]
      if self:DebuffUp(BloodlustExhaustSpell, nil) then
        return self:DebuffRemains(BloodlustExhaustSpell, nil, BypassRecovery)
      end
    end

    return 0
  end

  -- buff.bloodlust.up
  function Unit:BloodlustExhaustUp(BypassRecovery)
    return self:BloodlustExhaustRemains(BypassRecovery) > 0
  end

  -- buff.bloodlust.down
  function Unit:BloodlustExhaustDown(BypassRecovery)
    return not self:BloodlustExhaustUp(BypassRecovery)
  end
end

do
  local EnemyAbsorbSpells = {
    ---- Vault of the Incarnates
    -- Raszageth
    Spell(382530), -- Surging Ruiner Shield (Surge)
    Spell(388691), -- Stormsurge Shield
    ---- Aberrus
    -- Assault of the Zaqari
    Spell(397383), -- Molten Barrier (Mystics)
  }

  function Unit:EnemyAbsorb()
    for i = 1, #EnemyAbsorbSpells do
      local AbsorbSpell = EnemyAbsorbSpells[i]
      if self:BuffUp(AbsorbSpell, true) then
        return true
      end
    end
    return false
  end
end
