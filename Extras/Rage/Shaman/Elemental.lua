--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- HeroDBC
local DBC        = EpicDBC.DBC
-- HeroLib
local EL         = EpicLib
local Cache      = EpicCache
local Unit       = EL.Unit
local Player     = Unit.Player
local Mouseover  = Unit.MouseOver
local Pet        = Unit.Pet
local Target     = Unit.Target
local Spell      = EL.Spell
local MultiSpell = EL.MultiSpell
local Item       = EL.Item
-- HeroRotation
local ER         = EpicLib
local Cast       = ER.Cast
local Macro      = ER.Macro
local Press      = ER.Press
-- Num/Bool Helper Functions
local num        = ER.Commons.Everyone.num
local bool       = ER.Commons.Everyone.bool
-- Lua
local GetTime    = GetTimelocal 
local GetWeaponEnchantInfo = GetWeaponEnchantInfo

--- ============================ CONTENT ============================

local ShouldReturn

-- Toggles
local OOC = false;
local AOE = false;
local CDs = false;
local MiniCDs = false;
local Kick = false;
local DispelToggle = false;

--Settings Use
local UseChainlightning
local UseEarthquake
local UseEarthshock
local UseElementalBlast
local UseFlameshock
local UseFrostShock
local UseIceFury
local UseLavaBeam
local UseLavaBurst
local UsePrimordialWave
local UseStormkeeper
local UseTotemicRecall
local UseWeaponEnchant

--Settings Use with CDs
local UseAscendance
local UseFireElemental
local UseLiquidMagmaTotem
local UseStormElemental
local UseTrinkets
local UseRacials

--Settings WithCDs
local AscendanceWithCD
local FireElementalWithCD
local StormElementalWithCD
local LiquidMagmaTotemWithCD

local TrinketsWithCD
local RacialsWithCD

local PrimordialWaveWithMiniCD
local StormkeeperWithMiniCD

--Interrupt Use Settings
local UseWindShear
local UseCapacitorTotem
local UseThunderstorm

--Settings UseDefensives
local UseAncestralGuidance
local UseAstralShift
local UseHealingStreamTotem

--Settings DefensiveHP
local AncestralGuidanceHP
local AncestralGuidanceGroup
local AstralShiftHP
local HealingStreamTotemHP
local HealingStreamTotemGroup

--Afflicted Settings
local UseCleanseSpiritWithAfflicted
local UseTremorTotemWithAfflicted
local UsePoisonCleansingTotemWithAfflicted

--Extras
local CycleThroughEnemies
local DispelBuffs
local DispelDebuffs
local HandleAfflicted;
local HandleIncorporeal;
local InterruptWithStun;
local InterruptOnlyWhitelist;
local InterruptThreshold;
local FightRemainsCheck;

local UseHealingPotion
local UseHealthstone
local HealingPotionHP
local HealthstoneHP
local HealingPotionName;

local UsePurgeTarget;
local UseHealOOC
local HealOOCHP


--- ======= APL LOCALS =======

-- Define S/I for spell and item arrays
local S = Spell.Shaman.Elemental
local I = Item.Shaman.Elemental
local M = Macro.Shaman.Elemental

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
  -- I.TrinketName:ID(),
}

-- GUI Settings
local Everyone = ER.Commons.Everyone
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.Shaman.Commons,
--  Elemental = ER.GUISettings.APL.Shaman.Elemental
--}

local function FillDispels()
  if S.CleanseSpirit:IsAvailable() then
    Everyone.DispellableDebuffs = Everyone.DispellableCurseDebuffs
  end
end

EL:RegisterForEvent(function()
  FillDispels()
end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");

EL:RegisterForEvent(function()
  S.PrimordialWave:RegisterInFlightEffect(327162)
  S.PrimordialWave:RegisterInFlight()
  S.LavaBurst:RegisterInFlight()
end, "LEARNED_SPELL_IN_TAB")
S.PrimordialWave:RegisterInFlightEffect(327162)
S.PrimordialWave:RegisterInFlight()
S.LavaBurst:RegisterInFlight()

-- Rotation Variables
local BossFightRemains = 11111
local FightRemains = 11111
local HasMainHandEnchant, MHEnchantTimeRemains
local Enemies40y, Enemies10ySplash
local Targets40y = 0
local TargetsSplash10y = 0

local function T302pcNextTick()
  return 40 - (GetTime() - Shaman.LastT302pcBuff)
end

local function EvaluateFlameShockRefreshable(TargetUnit)
  -- target_if=refreshable
  return (TargetUnit:DebuffRefreshable(S.FlameShockDebuff))
end

local function EvaluateFlameShockRefreshable2(TargetUnit)
  -- target_if=refreshable,if=dot.flame_shock.remains<target.time_to_die-5
  -- Note: Trimmed items handled before this function is called
  return (TargetUnit:DebuffRefreshable(S.FlameShockDebuff) and TargetUnit:DebuffRemains(S.FlameShockDebuff) < TargetUnit:TimeToDie() - 5)
end

local function EvaluateFlameShockRefreshable3(TargetUnit)
  -- target_if=refreshable,if=dot.flame_shock.remains<target.time_to_die-5&dot.flame_shock.remains>0
  -- Note: Trimmed items handled before this function is called
  return (TargetUnit:DebuffRefreshable(S.FlameShockDebuff) and TargetUnit:DebuffRemains(S.FlameShockDebuff) < TargetUnit:TimeToDie() - 5 and TargetUnit:DebuffRemains(S.FlameShockDebuff) > 0)
end

local function EvaluateFlameShockRemains(TargetUnit)
  -- target_if=min:dot.flame_shock.remains
  return (TargetUnit:DebuffRemains(S.FlameShockDebuff))
end

local function EvaluateFlameShockRemains2(TargetUnit)
  -- target_if=dot.flame_shock.remains>2
  return (TargetUnit:DebuffRemains(S.FlameShockDebuff) > 2)
end

local function EvaluateLightningRodRemains(TargetUnit)
  -- target_if=min:debuff.lightning_rod.remains
  return (TargetUnit:DebuffRemains(S.LightningRodDebuff))
end

local function MaelstromPlayer()
  local Maelstrom = Player:Maelstrom()
  if not Player:IsCasting() then
    return Maelstrom
  else
    if Player:IsCasting(S.ElementalBlast) then
      return Maelstrom - 75
    elseif Player:IsCasting(S.Icefury) then
      return Maelstrom + 25
    elseif Player:IsCasting(S.LightningBolt) then
      return Maelstrom + 10
    elseif Player:IsCasting(S.LavaBurst) then
      return Maelstrom + 12
    elseif Player:IsCasting(S.ChainLightning) then
      --TODO: figure out the *actual* maelstrom you'll get from hitting your current target...
      --return Maelstrom + (4 * #SplashedEnemiesTable[Target])
      -- If you're hitting the best target with CL , this is 4*Shaman.ClusterTargets
      return Maelstrom + (4 * TargetsSplash10y)
    else
      return Maelstrom
    end
  end
end

local function MOTEP()
  if not S.MasteroftheElements:IsAvailable() then return false end
  local MOTEUp = Player:BuffUp(S.MasteroftheElementsBuff)
  if not Player:IsCasting() then
    return MOTEUp
  else
    if Player:IsCasting(S.LavaBurst) then
      return true
    elseif Player:IsCasting(S.ElementalBlast) then 
      return false
    elseif Player:IsCasting(S.Icefury) then
      return false
    elseif Player:IsCasting(S.LightningBolt) then
      return false
    elseif Player:IsCasting(S.ChainLightning) then
      return false
    else
      return MOTEUp
    end
  end
end

local function StormkeeperP()
  if not S.Stormkeeper:IsAvailable() then return false end
  local StormkeeperUp = Player:BuffUp(S.StormkeeperBuff)
  if not Player:IsCasting() then
    return StormkeeperUp
  else
    if Player:IsCasting(S.Stormkeeper) then
      return true
    else
      return StormkeeperUp
    end
  end
end

local function IceFuryP()
  if not S.Icefury:IsAvailable() then return false end
  local IcefuryUp = Player:BuffUp(S.IcefuryBuff)
  if not Player:IsCasting() then
    return IcefuryUp
  else
    if Player:IsCasting(S.Icefury) then
      return true
    else
      return IcefuryUp
    end
  end
end

local function Dispel()
  -- Cleanse Spirit
  if S.CleanseSpirit:IsReady() and DispelToggle and Everyone.DispellableFriendlyUnit() then
    if Press(M.CleanseSpiritFocus) then return "cleanse_spirit dispel"; end
  end
end

local function HealOOC()
  -- Heal Out of Combat
  if UseHealOOC and (Player:HealthPercentage() <= HealOOCHP) then
    -- Healing Surge
    if S.HealingSurge:IsReady() then
      if Press(S.HealingSurge) then return "healing_surge heal ooc"; end
    end
  end
end

local function Defensive()
  -- astral shift @ hp%
  if S.AstralShift:IsReady() and UseAstralShift and Player:HealthPercentage() <= AstralShiftHP then
    if Press(S.AstralShift) then return "astral_shift defensive 1"; end
  end

  -- ancestral guidance @ hp%
  if S.AncestralGuidance:IsReady() and UseAncestralGuidance and Everyone.AreUnitsBelowHealthPercentage(AncestralGuidanceHP, AncestralGuidanceGroup) then
    if Press(S.AncestralGuidance) then return "ancestral_guidance defensive 2"; end
  end

  -- Healing Stream Totem @ hp%
  if S.HealingStreamTotem:IsReady() and UseHealingStreamTotem and Everyone.AreUnitsBelowHealthPercentage(HealingStreamTotemHP, HealingStreamTotemGroup) then
    if Press(S.HealingStreamTotem) then return "healing_stream_totem defensive 3"; end
  end

  -- healthstone
  if I.Healthstone:IsReady() and UseHealthstone and Player:HealthPercentage() <= HealthstoneHP then
    if Press(M.Healthstone) then return "healthstone defensive 3"; end
  end
  -- HealingPot
  if UseHealingPotion and Player:HealthPercentage() <= HealingPotionHP then
    if HealingPotionName == "Refreshing Healing Potion" then
      if I.RefreshingHealingPotion:IsReady() then
        if Press(M.RefreshingHealingPotion) then return "refreshing healing potion defensive 4"; end
      end
    end
  end
end

local function Trinket()
  -- trinket
  ShouldReturn = Everyone.HandleTopTrinket(OnUseExcludes, CDs, 40, nil); if ShouldReturn then return ShouldReturn; end
  ShouldReturn = Everyone.HandleBottomTrinket(OnUseExcludes, CDs, 40, nil); if ShouldReturn then return ShouldReturn; end
  --if Player:GetUseableItems(OnUseExcludes, 13) then
  --  if Press(M.Trinket1, nil, nil, true) then return "trinket1 trinket"; end
  --end
  --if Player:GetUseableItems(OnUseExcludes, 14) then
  --  if Press(M.Trinket2, nil, nil, true) then return "trinket2 trinket"; end
  --end
end

local function Precombat()
  -- flask
  -- food
  -- augmentation
  -- snapshot_stats

  -- Check weapon enchants
  HasMainHandEnchant, MHEnchantTimeRemains = GetWeaponEnchantInfo()

  -- flametongue_weapon,if=talent.improved_flametongue_weapon.enabled
  if S.ImprovedFlametongueWeapon:IsAvailable() and UseWeaponEnchant and (not HasMainHandEnchant or MHEnchantTimeRemains < 600000) and S.FlametongueWeapon:IsAvailable() then
    if Press(S.FlamentongueWeapon) then return "flametongue_weapon enchant"; end
  end

  -- potion
  -- Note: Skipping this, as we don't need to use potion in Precombat any longer.
  -- stormkeeper
  if S.Stormkeeper:IsAvailable() and S.Stormkeeper:CooldownRemains() == 0 and not Player:BuffUp(S.StormkeeperBuff) and UseStormkeeper and ((StormkeeperWithMiniCD and MiniCDs) or not StormkeeperWithMiniCD) and FightRemainsCheck < FightRemains then
    if Press(S.Stormkeeper) then return "stormkeeper precombat 2"; end
  end
  -- icefury
  if S.Icefury:IsAvailable() and S.Icefury:CooldownRemains() == 0 and UseIceFury then
    if Press(S.Icefury,not Target:IsSpellInRange(S.Icefury)) then return "icefury precombat 4"; end
  end
  -- Manually added: Opener abilities, in case icefury is on CD
  if S.ElementalBlast:IsAvailable() and UseElementalBlast then
    if Press(S.ElementalBlast,not Target:IsSpellInRange(S.ElementalBlast)) then return "elemental_blast precombat 6"; end
  end
  if Player:IsCasting(S.ElementalBlast) and UsePrimordialWave and ((PrimordialWaveWithMiniCD and MiniCDs) or not PrimordialWaveWithMiniCD) and S.PrimordialWave:IsAvailable() then
    if Press(S.PrimordialWave,not Target:IsSpellInRange(S.PrimordialWave)) then return "primordial_wave precombat 8"; end
  end
  if Player:IsCasting(S.ElementalBlast) and UseFlameShock and not S.PrimordialWave:IsAvailable() and S.FlameShock:IsReady() then
    if Press(S.FlameShock,not Target:IsSpellInRange(S.FlameShock)) then return "flameshock precombat 10"; end
  end
  if S.LavaBurst:IsAvailable() and UseLavaBurst and not Player:IsCasting(S.LavaBurst) and (not S.ElementalBlast:IsAvailable() or (S.ElementalBlast:IsAvailable() and not S.ElementalBlast:IsAvailable())) then
    if Press(S.LavaBurst,not Target:IsSpellInRange(S.LavaBurst)) then return "lavaburst precombat 12"; end
  end
  if Player:IsCasting(S.LavaBurst) and UseFlameShock and S.FlameShock:IsReady() then 
    if Press(S.FlameShock,not Target:IsSpellInRange(S.FlameShock)) then return "flameshock precombat 14"; end
  end
  if Player:IsCasting(S.LavaBurst) and UsePrimordialWave and ((PrimordialWaveWithMiniCD and MiniCDs) or not PrimordialWaveWithMiniCD) and S.PrimordialWave:IsAvailable() then
    if Press(S.PrimordialWave,not Target:IsSpellInRange(S.PrimordialWave)) then return "primordial_wave precombat 16"; end
  end
end

local function Aoe()
  -- fire_elemental
  if S.FireElemental:IsReady() and UseFireElemental and ((FireElementalWithCD and CDs) or not FireElementalWithCD) and FightRemainsCheck < FightRemains then
    if Press(S.FireElemental) then return "fire_elemental aoe 2"; end
  end
  -- storm_elemental
  if S.StormElemental:IsReady() and UseStormElemental and ((StormElementalWithCD and CDs) or not StormElementalWithCD) and FightRemainsCheck < FightRemains then
    if Press(S.StormElemental) then return "storm_elemental aoe 4"; end
  end
  -- fire_elemental: Meteor
  --if S.Meteor:IsReady() and CDs and FightRemainsCheck < FightRemains then
  --  if Press(M.FireElementalMeteor,not Target:IsInRange(40)) then return "fire_elemental meteor aoe 5"; end
  --end
  -- storm_elemental: Tempest
  --if S.Tempest:IsReady() and CDs and FightRemainsCheck < FightRemains then
  --  if Press(M.StormElementalTempest,not Target:IsInRange(40)) then return "storm_elemental tempest aoe 6"; end
  --end
  -- stormkeeper,if=!buff.stormkeeper.up
  if S.Stormkeeper:IsAvailable() and S.Stormkeeper:CooldownRemains() == 0 and not Player:BuffUp(S.StormkeeperBuff) and UseStormkeeper and ((StormkeeperWithMiniCD and MiniCDs) or not StormkeeperWithMiniCD) and FightRemainsCheck < FightRemains and (not StormkeeperP()) then
    if Press(S.Stormkeeper) then return "stormkeeper aoe 7"; end
  end
  -- totemic_recall,if=cooldown.liquid_magma_totem.remains>45
  if S.TotemicRecall:IsCastable() and (S.LiquidMagmaTotem:CooldownRemains() > 45) and UseTotemicRecall then
    if Press(S.TotemicRecall) then return "totemic_recall aoe 8"; end
  end
  -- liquid_magma_totem
  if S.LiquidMagmaTotem:IsReady() and UseLiquidMagmaTotem and ((LiquidMagmaTotemWithCD and CDs) or not LiquidMagmaTotemWithCD) and FightRemainsCheck < FightRemains and LiquidMagmaTotemSetting == "cursor" then
    if Press(M.LiquidMagmaTotemCursor,not Target:IsInRange(40)) then return "liquid_magma_totem aoe 10"; end
  end
  if S.LiquidMagmaTotem:IsReady() and UseLiquidMagmaTotem and ((LiquidMagmaTotemWithCD and CDs) or not LiquidMagmaTotemWithCD) and FightRemainsCheck < FightRemains and LiquidMagmaTotemSetting == "player" then
    if Press(M.LiquidMagmaTotemPlayer,not Target:IsInRange(40)) then return "liquid_magma_totem aoe 11"; end
  end
  -- primordial_wave,target_if=min:dot.flame_shock.remains,if=!buff.primordial_wave.up&buff.surge_of_power.up&!buff.splintered_elements.up
  if S.PrimordialWave:IsAvailable() and CycleThroughEnemies and UsePrimordialWave and ((PrimordialWaveWithMiniCD and MiniCDs) or not PrimordialWaveWithMiniCD) and (Player:BuffDown(S.PrimordialWaveBuff) and Player:BuffUp(S.SurgeofPowerBuff) and Player:BuffDown(S.SplinteredElementsBuff)) then
    if Everyone.CastTargetIf(S.PrimordialWave, Enemies10ySplash, "min", EvaluateFlameShockRemains, nil, not Target:IsSpellInRange(S.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature) then return "primordial_wave aoe 12"; end
  end
  -- primordial_wave,target_if=min:dot.flame_shock.remains,if=!buff.primordial_wave.up&talent.deeply_rooted_elements.enabled&!talent.surge_of_power.enabled&!buff.splintered_elements.up
  if S.PrimordialWave:IsAvailable() and CycleThroughEnemies and UsePrimordialWave and ((PrimordialWaveWithMiniCD and MiniCDs) or not PrimordialWaveWithMiniCD) and (Player:BuffDown(S.PrimordialWaveBuff) and S.DeeplyRootedElements:IsAvailable() and not S.SurgeofPower:IsAvailable() and Player:BuffDown(S.SplinteredElementsBuff)) then
    if Everyone.CastTargetIf(S.PrimordialWave, Enemies10ySplash, "min", EvaluateFlameShockRemains, nil, not Target:IsSpellInRange(S.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature) then return "primordial_wave aoe 14"; end
  end
  -- primordial_wave,target_if=min:dot.flame_shock.remains,if=!buff.primordial_wave.up&talent.master_of_the_elements.enabled&!talent.lightning_rod.enabled
  if S.PrimordialWave:IsAvailable() and CycleThroughEnemies and UsePrimordialWave and ((PrimordialWaveWithMiniCD and MiniCDs) or not PrimordialWaveWithMiniCD) and (Player:BuffDown(S.PrimordialWaveBuff) and S.MasteroftheElements:IsAvailable() and not S.LightningRod:IsAvailable()) then
    if Everyone.CastTargetIf(S.PrimordialWave, Enemies10ySplash, "min", EvaluateFlameShockRemains, nil, not Target:IsSpellInRange(S.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature) then return "primordial_wave aoe 16"; end
  end
  if S.FlameShock:IsCastable() then
    -- flame_shock,target_if=refreshable,if=buff.surge_of_power.up&talent.lightning_rod.enabled&talent.windspeakers_lava_resurgence.enabled&dot.flame_shock.remains<target.time_to_die-16&active_enemies<5
    if (Player:BuffUp(S.SurgeofPowerBuff) and UseFlameshock and CycleThroughEnemies and S.LightningRod:IsAvailable() and S.WindspeakersLavaResurgence:IsAvailable() and Target:DebuffRemains(S.FlameShockDebuff) < Target:TimeToDie() - 1) then
      if Everyone.CastCycle(S.FlameShock, Enemies10ySplash, EvaluateFlameShockRefreshable2, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 18"; end
    end
    -- flame_shock,target_if=refreshable,if=buff.surge_of_power.up&(!talent.lightning_rod.enabled|talent.skybreakers_fiery_demise.enabled)&dot.flame_shock.remains<target.time_to_die-5&active_dot.flame_shock<6
    if (Player:BuffUp(S.SurgeofPowerBuff) and UseFlameshock and CycleThroughEnemies and (not S.LightningRod:IsAvailable() or S.SkybreakersFieryDemise:IsAvailable()) and S.FlameShockDebuff:AuraActiveCount() < 6) then
      if Everyone.CastCycle(S.FlameShock, Enemies10ySplash, EvaluateFlameShockRefreshable2, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 20"; end
    end
    -- flame_shock,target_if=refreshable,if=talent.master_of_the_elements.enabled&!talent.lightning_rod.enabled&dot.flame_shock.remains<target.time_to_die-5&active_dot.flame_shock<6
    if (S.MasteroftheElements:IsAvailable() and UseFlameshock and CycleThroughEnemies and not S.LightningRod:IsAvailable() and S.FlameShockDebuff:AuraActiveCount() < 6) then
      if Everyone.CastCycle(S.FlameShock, Enemies10ySplash, EvaluateFlameShockRefreshable2, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 22"; end
    end
    -- flame_shock,target_if=refreshable,if=talent.deeply_rooted_elements.enabled&!talent.surge_of_power.enabled&dot.flame_shock.remains<target.time_to_die-5&active_dot.flame_shock<6
    if (S.DeeplyRootedElements:IsAvailable() and UseFlameshock and CycleThroughEnemies and not S.SurgeofPower:IsAvailable() and S.FlameShockDebuff:AuraActiveCount() < 6) then
      if Everyone.CastCycle(S.FlameShock, Enemies10ySplash, EvaluateFlameShockRefreshable2, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 24"; end
    end
    -- flame_shock,target_if=refreshable,if=buff.surge_of_power.up&(!talent.lightning_rod.enabled|talent.skybreakers_fiery_demise.enabled)&dot.flame_shock.remains<target.time_to_die-5&dot.flame_shock.remains>0
    if (Player:BuffUp(S.SurgeofPowerBuff) and UseFlameshock and CycleThroughEnemies and (not S.LightningRod:IsAvailable() or S.SkybreakersFieryDemise:IsAvailable())) then
      if Everyone.CastCycle(S.FlameShock, Enemies10ySplash, EvaluateFlameShockRefreshable3, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 26"; end
    end
    -- flame_shock,target_if=refreshable,if=talent.master_of_the_elements.enabled&!talent.lightning_rod.enabled&dot.flame_shock.remains<target.time_to_die-5&dot.flame_shock.remains>0
    if (S.MasteroftheElements:IsAvailable() and UseFlameshock and CycleThroughEnemies and not S.LightningRod:IsAvailable()) then
      if Everyone.CastCycle(S.FlameShock, Enemies10ySplash, EvaluateFlameShockRefreshable3, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 28"; end
    end
    -- flame_shock,target_if=refreshable,if=talent.deeply_rooted_elements.enabled&!talent.surge_of_power.enabled&dot.flame_shock.remains<target.time_to_die-5&dot.flame_shock.remains>0
    if (S.DeeplyRootedElements:IsAvailable() and UseFlameshock and CycleThroughEnemies and not S.SurgeofPower:IsAvailable()) then
      if Everyone.CastCycle(S.FlameShock, Enemies10ySplash, EvaluateFlameShockRefreshable3, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 30"; end
    end
  end
  -- ascendance
  if S.Ascendance:IsCastable() and UseAscendance and ((AscendanceWithCD and CDs) or not AscendanceWithCD) and FightRemainsCheck < FightRemains then
    if Press(S.Ascendance) then return "ascendance aoe 32"; end
  end
  -- lava_burst,target_if=dot.flame_shock.remains,if=cooldown_react&buff.lava_surge.up&talent.master_of_the_elements.enabled&!buff.master_of_the_elements.up&(maelstrom>=60-5*talent.eye_of_the_storm.rank-2*talent.flow_of_power.enabled)&(!talent.echoes_of_great_sundering.enabled&!talent.lightning_rod.enabled|buff.echoes_of_great_sundering.up)&(!buff.ascendance.up&active_enemies>3&talent.unrelenting_calamity.enabled|active_enemies>3&!talent.unrelenting_calamity.enabled|active_enemies=3)
  if S.LavaBurst:IsAvailable() and UseLavaBurst and CycleThroughEnemies and (Player:BuffUp(S.LavaSurgeBuff) and S.MasteroftheElements:IsAvailable() and not MOTEP() and (MaelstromPlayer() >= 60 - 5 * S.EyeoftheStorm:TalentRank() - 2 * num(S.FlowofPower:IsAvailable())) and (not S.EchoesofGreatSundering:IsAvailable() and not S.LightningRod:IsAvailable() or Player:BuffUp(S.EchoesofGreatSunderingBuff)) and (Player:BuffDown(S.AscendanceBuff) and Targets40y > 3 and not S.UnrelentingCalamity:IsAvailable() or TargetsSplash10y == 3)) then
    if Everyone.CastCycle(S.LavaBurst, Enemies10ySplash, EvaluateFlameShockRemains, not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst aoe 34"; end
  end
  -- earthquake,if=!talent.echoes_of_great_sundering.enabled&active_enemies>3&(spell_targets.chain_lightning>3|spell_targets.lava_beam>3)
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "cursor" and (not S.EchoesofGreatSundering:IsAvailable() and Targets40y > 3 and TargetsSplash10y > 3) then
    if Press(M.EarthquakeCursor,not Target:IsInRange(40)) then return "earthquake aoe 36"; end
  end
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "player" and (not S.EchoesofGreatSundering:IsAvailable() and Targets40y > 3 and TargetsSplash10y > 3) then
    if Press(M.EarthquakePlayer,not Target:IsInRange(40)) then return "earthquake aoe 36"; end
  end
  -- earthquake,if=!talent.echoes_of_great_sundering.enabled&!talent.elemental_blast.enabled&active_enemies=3&(spell_targets.chain_lightning=3|spell_targets.lava_beam=3)
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "cursor" and (not S.EchoesofGreatSundering:IsAvailable() and not S.ElementalBlast:IsAvailable() and Targets40y == 3 and TargetsSplash10y == 3) then
    if Press(M.EarthquakeCursor,not Target:IsInRange(40)) then return "earthquake aoe 38"; end
  end
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "player" and (not S.EchoesofGreatSundering:IsAvailable() and not S.ElementalBlast:IsAvailable() and Targets40y == 3 and TargetsSplash10y == 3) then
    if Press(M.EarthquakePlayer,not Target:IsInRange(40)) then return "earthquake aoe 38"; end
  end
  -- earthquake,if=buff.echoes_of_great_sundering.up
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "cursor" and (Player:BuffUp(S.EchoesofGreatSunderingBuff)) then
    if Press(M.EarthquakeCursor,not Target:IsInRange(40)) then return "earthquake aoe 40"; end
  end
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "player" and (Player:BuffUp(S.EchoesofGreatSunderingBuff)) then
    if Press(M.EarthquakePlayer,not Target:IsInRange(40)) then return "earthquake aoe 40"; end
  end
  -- elemental_blast,target_if=min:debuff.lightning_rod.remains,if=talent.echoes_of_great_sundering.enabled
  if S.ElementalBlast:IsAvailable() and CycleThroughEnemies and UseElementalBlast and (S.EchoesofGreatSundering:IsAvailable()) then
    if Everyone.CastTargetIf(S.ElementalBlast, Enemies10ySplash, "min", EvaluateLightningRodRemains, nil, not Target:IsSpellInRange(S.ElementalBlast)) then return "elemental_blast aoe 42"; end
  end
  -- elemental_blast,if=talent.echoes_of_great_sundering.enabled
  if S.ElementalBlast:IsAvailable() and UseElementalBlast and (S.EchoesofGreatSundering:IsAvailable()) then
    if Press(S.ElementalBlast,not Target:IsSpellInRange(S.ElementalBlast)) then return "elemental_blast aoe 44"; end
  end
  -- elemental_blast,if=enemies=3&!talent.echoes_of_great_sundering.enabled
  if S.ElementalBlast:IsAvailable() and UseElementalBlast and (Targets40y == 3 and not S.EchoesofGreatSundering:IsAvailable()) then
    if Press(S.ElementalBlast,not Target:IsSpellInRange(S.ElementalBlast)) then return "elemental_blast aoe 46"; end
  end
  -- earth_shock,target_if=min:debuff.lightning_rod.remains,if=talent.echoes_of_great_sundering.enabled
  if S.EarthShock:IsReady() and CycleThroughEnemies and UseEarthshock and (S.EchoesofGreatSundering:IsAvailable()) then
    if Everyone.CastTargetIf(S.EarthShock, Enemies10ySplash, "min", EvaluateLightningRodRemains, nil, not Target:IsSpellInRange(S.EarthShock)) then return "earth_shock aoe 48"; end
  end
  -- earth_shock,if=talent.echoes_of_great_sundering.enabled
  if S.EarthShock:IsReady() and UseEarthshock and (S.EchoesofGreatSundering:IsAvailable()) then
    if Press(S.EarthShock,not Target:IsSpellInRange(S.EarthShock)) then return "earth_shock aoe 50"; end
  end
  -- icefury,if=!buff.ascendance.up&talent.electrified_shocks.enabled&(talent.lightning_rod.enabled&active_enemies<5&!buff.master_of_the_elements.up|talent.deeply_rooted_elements.enabled&active_enemies=3)
  if S.Icefury:IsAvailable() and S.Icefury:CooldownRemains() == 0 and UseIceFury and (Player:BuffDown(S.AscendanceBuff) and S.ElectrifiedShocks:IsAvailable() and (S.LightningRod:IsAvailable() and Targets40y < 5 and not MOTEP() or S.DeeplyRootedElements:IsAvailable() and Targets40y == 3)) then
    if Press(S.Icefury,not Target:IsSpellInRange(S.Icefury)) then return "icefury aoe 52"; end
  end
  -- frost_shock,if=!buff.ascendance.up&buff.icefury.up&talent.electrified_shocks.enabled&(!debuff.electrified_shocks.up|buff.icefury.remains<gcd)&(talent.lightning_rod.enabled&active_enemies<5&!buff.master_of_the_elements.up|talent.deeply_rooted_elements.enabled&active_enemies=3)
  if S.FrostShock:IsCastable() and UseFrostShock and (Player:BuffDown(S.AscendanceBuff) and IceFuryP() and S.ElectrifiedShocks:IsAvailable() and (Target:DebuffDown(S.ElectrifiedShocksDebuff) or Player:BuffRemains(S.IcefuryBuff) < Player:GCD()) and (S.LightningRod:IsAvailable() and Targets40y < 5 and not MOTEP() or S.DeeplyRootedElements:IsAvailable() and Targets40y == 3)) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock moving aoe 54"; end
  end
  -- lava_burst,target_if=dot.flame_shock.remains,if=talent.master_of_the_elements.enabled&!buff.master_of_the_elements.up&(buff.stormkeeper.up|t30_2pc_timer.next_tick<3&set_bonus.tier30_2pc)&(maelstrom<60-5*talent.eye_of_the_storm.rank-2*talent.flow_of_power.enabled-10)&active_enemies<5
  if S.LavaBurst:IsAvailable() and UseLavaBurst and (S.MasteroftheElements:IsAvailable() and not MOTEP() and (StormkeeperP() or Player:HasTier(30, 2) and T302pcNextTick() < 3) and (MaelstromPlayer() < 60 - 5 * S.EyeoftheStorm:TalentRank() - 2 * num(S.FlowofPower:IsAvailable()) - 10) and Targets40y < 5) then
    if Everyone.CastCycle(S.LavaBurst, Enemies10ySplash, EvaluateFlameShockRemains, not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst aoe 56"; end
  end
  -- lava_beam,if=buff.stormkeeper.up
  if S.LavaBeam:IsAvailable() and UseLavaBeam and (StormkeeperP()) then
    if Press(S.LavaBeam,not Target:IsSpellInRange(S.LavaBeam)) then return "lava_beam aoe 58"; end
  end
  -- chain_lightning,if=buff.stormkeeper.up
  if S.ChainLightning:IsAvailable() and UseChainlightning and (StormkeeperP()) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning aoe 60"; end
  end
  -- lava_beam,if=buff.power_of_the_maelstrom.up&buff.ascendance.remains>cast_time
  if S.LavaBeam:IsAvailable() and UseLavaBeam and (Player:BuffUp(S.Power) and Player:BuffRemains(S.AscendanceBuff) > S.LavaBeam:CastTime()) then
    if Press(S.LavaBeam,not Target:IsSpellInRange(S.LavaBeam)) then return "lava_beam aoe 62"; end
  end
  -- chain_lightning,if=buff.power_of_the_maelstrom.up
  if S.ChainLightning:IsAvailable()and UseChainlightning and (MOTEP()) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning aoe 64"; end
  end
  -- lava_beam,if=active_enemies>=6&buff.surge_of_power.up&buff.ascendance.remains>cast_time
  if S.LavaBeam:IsAvailable() and UseLavaBeam and (Targets40y >= 6 and Player:BuffUp(S.SurgeofPowerBuff) and Player:BuffRemains(S.AscendanceBuff) > S.LavaBeam:CastTime()) then
    if Press(S.LavaBeam,not Target:IsSpellInRange(S.LavaBeam)) then return "lava_beam aoe 66"; end
  end
  -- chain_lightning,if=active_enemies>=6&buff.surge_of_power.up
  if S.ChainLightning:IsAvailable()and UseChainlightning and (Targets40y >= 6 and Player:BuffUp(S.SurgeofPowerBuff)) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning aoe 68"; end
  end
  -- lava_burst,target_if=dot.flame_shock.remains,if=buff.lava_surge.up&talent.deeply_rooted_elements.enabled&buff.windspeakers_lava_resurgence.up
  if S.LavaBurst:IsAvailable()and UseLavaBurst and (Player:BuffUp(S.LavaSurgeBuff) and S.DeeplyRootedElements:IsAvailable() and Player:BuffUp(S.WindspeakersLavaResurgenceBuff)) then
    if Press(S.LavaBurst,not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst aoe 70"; end
  end
  -- lava_beam,if=buff.master_of_the_elements.up&buff.ascendance.remains>cast_time
  if S.LavaBeam:IsAvailable() and UseLavaBeam and (MOTEP() and Player:BuffRemains(S.AscendanceBuff) > S.LavaBeam:CastTime()) then
    if Press(S.LavaBeam,not Target:IsSpellInRange(S.LavaBeam)) then return "lava_beam aoe 72"; end
  end
  -- lava_burst,target_if=dot.flame_shock.remains,if=enemies=3&talent.master_of_the_elements.enabled
  if S.LavaBurst:IsAvailable() and UseLavaBurst and (Targets40y == 3 and S.MasteroftheElements:IsAvailable()) then
    if Everyone.CastCycle(S.LavaBurst, Enemies10ySplash, EvaluateFlameShockRemains, not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst aoe 74"; end
  end
  -- lava_burst,target_if=dot.flame_shock.remains,if=buff.lava_surge.up&talent.deeply_rooted_elements.enabled
  if S.LavaBurst:IsAvailable() and UseLavaBurst and (Player:BuffUp(S.LavaSurgeBuff) and S.DeeplyRootedElements:IsAvailable()) then
    if Everyone.CastCycle(S.LavaBurst, Enemies10ySplash, EvaluateFlameShockRemains, not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst aoe 76"; end
  end
  -- icefury,if=talent.electrified_shocks.enabled&active_enemies<5
  if S.Icefury:IsAvailable() and S.Icefury:CooldownRemains() == 0 and UseIceFury and (S.ElectrifiedShocks:IsAvailable() and TargetsSplash10y < 5) then
    if Press(S.Icefury,not Target:IsSpellInRange(S.Icefury)) then return "icefury aoe 78"; end
  end
  -- frost_shock,if=buff.icefury.up&talent.electrified_shocks.enabled&!debuff.electrified_shocks.up&active_enemies<5&talent.unrelenting_calamity.enabled
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and S.ElectrifiedShocks:IsAvailable() and Target:DebuffDown(S.ElectrifiedShocksDebuff) and Targets40y < 5 and S.UnrelentingCalamity:IsAvailable()) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock aoe 80"; end
  end
  -- lava_beam,if=buff.ascendance.remains>cast_time
  if S.LavaBeam:IsAvailable() and UseLavaBeam and (Player:BuffRemains(S.AscendanceBuff) > S.LavaBeam:CastTime()) then
    if Press(S.LavaBeam,not Target:IsSpellInRange(S.LavaBeam)) then return "lava_beam aoe 82"; end
  end
  -- chain_lightning
  if S.ChainLightning:IsAvailable() and UseChainlightning then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning aoe 84"; end
  end
  -- flame_shock,moving=1,target_if=refreshable
  if S.FlameShock:IsCastable() and UseFlameShock and CycleThroughEnemies then
    if Everyone.CastCycle(S.FlameShock, Enemies10ySplash, EvaluateFlameShockRefreshable, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock moving aoe 86"; end
  end
  -- frost_shock,moving=1
  if S.FrostShock:IsCastable() and UseFrostShock then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock moving aoe 88"; end
  end
end

local function SingleTarget()
  -- fire_elemental
  if S.FireElemental:IsCastable() and UseFireElemental and ((FireElementalWithCD and CDs) or not FireElementalWithCD) and FightRemainsCheck < FightRemains then
    if Press(S.FireElemental) then return "fire_elemental single_target 2"; end
  end
  -- storm_elemental
  if S.StormElemental:IsCastable() and UseStormElemental and ((StormElementalWithCD and CDs) or not StormElementalWithCD) and FightRemainsCheck < FightRemains then
    if Press(S.StormElemental) then return "storm_elemental single_target 4"; end
  end
  -- fire_elemental: Meteor
  --if S.Meteor:IsReady() and CDs and FightRemainsCheck < FightRemains then
  --  if Press(M.FireElementalMeteor,not Target:IsInRange(40)) then return "fire_elemental meteor single_target 5"; end
  --end
  -- storm_elemental: Tempest
  --if S.Tempest:IsReady() and CDs and FightRemainsCheck < FightRemains then
  --  if Press(M.StormElementalTempest,not Target:IsInRange(40)) then return "storm_elemental tempest single_target 6"; end
  --end
  -- totemic_recall,if=cooldown.liquid_magma_totem.remains>45&(talent.lava_surge.enabled&talent.splintered_elements.enabled|active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1))
  if S.TotemicRecall:IsCastable() and UseTotemicRecall and (S.LiquidMagmaTotem:CooldownRemains() > 45 and (S.LavaSurge:IsAvailable() and S.SplinteredElements:IsAvailable() or Targets40y > 1 and TargetsSplash10y > 1)) then
    if Press(S.TotemicRecall) then return "totemic_recall single_target 7"; end
  end
  -- liquid_magma_totem,if=talent.lava_surge.enabled&talent.splintered_elements.enabled|active_dot.flame_shock=0|dot.flame_shock.remains<6|active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)
  if S.LiquidMagmaTotem:IsCastable() and UseLiquidMagmaTotem and ((LiquidMagmaTotemWithCD and CDs) or not LiquidMagmaTotemWithCD) and FightRemainsCheck < FightRemains and LiquidMagmaTotemSetting == "cursor" and (S.LavaSurge:IsAvailable() and S.SplinteredElements:IsAvailable() or S.FlameShockDebuff:AuraActiveCount() == 0 or Target:DebuffRemains(S.FlameShockDebuff) < 6 or Targets40y > 1 and TargetsSplash10y > 1) then
    if Press(M.LiquidMagmaTotemCursor,not Target:IsInRange(40)) then return "liquid_magma_totem single_target 8"; end
  end
  if S.LiquidMagmaTotem:IsCastable() and UseLiquidMagmaTotem and ((LiquidMagmaTotemWithCD and CDs) or not LiquidMagmaTotemWithCD) and FightRemainsCheck < FightRemains and LiquidMagmaTotemSetting == "player" and (S.LavaSurge:IsAvailable() and S.SplinteredElements:IsAvailable() or S.FlameShockDebuff:AuraActiveCount() == 0 or Target:DebuffRemains(S.FlameShockDebuff) < 6 or Targets40y > 1 and TargetsSplash10y > 1) then
    if Press(M.LiquidMagmaTotemPlayer,not Target:IsInRange(40)) then return "liquid_magma_totem single_target 8"; end
  end
  -- primordial_wave,target_if=min:dot.flame_shock.remains,if=!buff.primordial_wave.up&!buff.splintered_elements.up
  if S.PrimordialWave:IsAvailable() and CycleThroughEnemies and UsePrimordialWave and PrimordialWaveWithMiniCD and FightRemainsCheck < FightRemains and MiniCDs and (Player:BuffDown(S.PrimordialWaveBuff) and Player:BuffDown(S.SplinteredElementsBuff)) then
    if Everyone.CastTargetIf(S.PrimordialWave, Enemies10ySplash, "min", EvaluateFlameShockRemains, nil, not Target:IsSpellInRange(S.PrimordialWave), nil, Settings.Commons.DisplayStyle.Signature) then return "primordial_wave single_target 10"; end
  end
  -- flame_shock,target_if=min:dot.flame_shock.remains,if=active_enemies=1&refreshable&!buff.surge_of_power.up&(!buff.master_of_the_elements.up|(!buff.stormkeeper.up&(talent.elemental_blast.enabled&maelstrom<90-8*talent.eye_of_the_storm.rank|maelstrom<60-5*talent.eye_of_the_storm.rank)))
  if S.FlameShock:IsCastable() and UseFlameShock and (Targets40y == 1 and Target:DebuffRefreshable(S.FlameShockDebuff) and Player:BuffDown(S.SurgeofPowerBuff) and (not MOTEP() or (not StormkeeperP() and (S.ElementalBlast:IsAvailable() and MaelstromPlayer() < 90 - 8 * S.EyeoftheStorm:TalentRank() or MaelstromPlayer() < 60 - 5 * S.EyeoftheStorm:TalentRank())))) then
    if Press(S.FlameShock,not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock single_target 12"; end
  end
  -- flame_shock,target_if=min:dot.flame_shock.remains,if=active_dot.flame_shock=0&active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)&(talent.deeply_rooted_elements.enabled|talent.ascendance.enabled|talent.primordial_wave.enabled|talent.searing_flames.enabled|talent.magma_chamber.enabled)&(!buff.master_of_the_elements.up&(buff.stormkeeper.up|cooldown.stormkeeper.remains=0)|!talent.surge_of_power.enabled)
  if S.FlameShock:IsCastable() and CycleThroughEnemies and UseFlameShock and (S.FlameShockDebuff:AuraActiveCount() == 0 and Targets40y > 1 and TargetsSplash10y > 1 and (S.DeeplyRootedElements:IsAvailable() or S.Ascendance:IsAvailable() or S.PrimordialWave:IsAvailable() or S.SearingFlames:IsAvailable() or S.MagmaChamber:IsAvailable()) and (not MOTEP() and (StormkeeperP() or S.Stormkeeper:CooldownRemains() > 0) or not S.SurgeofPower:IsAvailable())) then
    if Everyone.CastTargetIf(S.FlameShock, Enemies10ySplash, "min", EvaluateFlameShockRemains, nil, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock single_target 14"; end
  end
  -- flame_shock,target_if=min:dot.flame_shock.remains,if=active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)&refreshable&(talent.deeply_rooted_elements.enabled|talent.ascendance.enabled|talent.primordial_wave.enabled|talent.searing_flames.enabled|talent.magma_chamber.enabled)&(buff.surge_of_power.up&!buff.stormkeeper.up&!cooldown.stormkeeper.remains=0|!talent.surge_of_power.enabled),cycle_targets=1
  if S.FlameShock:IsCastable() and CycleThroughEnemies and UseFlameShock and (Targets40y > 1 and TargetsSplash10y > 1 and (S.DeeplyRootedElements:IsAvailable() or S.Ascendance:IsAvailable() or S.PrimordialWave:IsAvailable() or S.SearingFlames:IsAvailable() or S.MagmaChamber:IsAvailable()) and (Player:BuffUp(S.SurgeofPowerBuff) and not StormkeeperP() and S.Stormkeeper:IsAvailable() or not S.SurgeofPower:IsAvailable())) then
    if Everyone.CastTargetIf(S.FlameShock, Enemies10ySplash, "min", EvaluateFlameShockRemains, EvaluateFlameShockRefreshable, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock single_target 16"; end
  end
  -- stormkeeper,if=!buff.ascendance.up&!buff.stormkeeper.up&maelstrom>=116&talent.elemental_blast.enabled&talent.surge_of_power.enabled&talent.swelling_maelstrom.enabled&!talent.lava_surge.enabled&!talent.echo_of_the_elements.enabled&!talent.primordial_surge.enabled
  if S.Stormkeeper:IsAvailable() and S.Stormkeeper:CooldownRemains() == 0 and not Player:BuffUp(S.StormkeeperBuff) and UseStormkeeper and ((StormkeeperWithMiniCD and MiniCDs) or not StormkeeperWithMiniCD) and FightRemainsCheck < FightRemains and (Player:BuffDown(S.AscendanceBuff) and not StormkeeperP() and MaelstromPlayer() >= 116 and S.ElementalBlast:IsAvailable() and S.SurgeofPower:IsAvailable() and S.SwellingMaelstrom:IsAvailable() and not S.LavaSurge:IsAvailable() and not S.EchooftheElements:IsAvailable() and not S.PrimordialSurge:IsAvailable()) then
    if Press(S.Stormkeeper) then return "stormkeeper single_target 18"; end
  end
  -- stormkeeper,if=!buff.ascendance.up&!buff.stormkeeper.up&buff.surge_of_power.up&!talent.lava_surge.enabled&!talent.echo_of_the_elements.enabled&!talent.primordial_surge.enabled
  if S.Stormkeeper:IsAvailable() and S.Stormkeeper:CooldownRemains() == 0 and not Player:BuffUp(S.StormkeeperBuff) and UseStormkeeper and ((StormkeeperWithMiniCD and MiniCDs) or not StormkeeperWithMiniCD) and FightRemainsCheck < FightRemains and (Player:BuffDown(S.AscendanceBuff) and not StormkeeperP() and Player:BuffUp(S.SurgeofPowerBuff) and not S.LavaSurge:IsAvailable() and not S.EchooftheElements:IsAvailable() and not S.PrimordialSurge:IsAvailable()) then
    if Press(S.Stormkeeper) then return "stormkeeper single_target 20"; end
  end
  -- stormkeeper,if=!buff.ascendance.up&!buff.stormkeeper.up&(!talent.surge_of_power.enabled|!talent.elemental_blast.enabled|talent.lava_surge.enabled|talent.echo_of_the_elements.enabled|talent.primordial_surge.enabled)
  if S.Stormkeeper:IsAvailable() and S.Stormkeeper:CooldownRemains() == 0 and not Player:BuffUp(S.StormkeeperBuff) and UseStormkeeper and ((StormkeeperWithMiniCD and MiniCDs) or not StormkeeperWithMiniCD) and FightRemainsCheck < FightRemains and (Player:BuffDown(S.AscendanceBuff) and not StormkeeperP() and (not S.SurgeofPower:IsAvailable() or not S.ElementalBlast:IsAvailable() or S.LavaSurge:IsAvailable() or S.EchooftheElements:IsAvailable() or S.PrimordialSurge:IsAvailable())) then
    if Press(S.Stormkeeper) then return "stormkeeper single_target 22"; end
  end
  -- ascendance,if=!buff.stormkeeper.up
  if S.Ascendance:IsCastable() and UseAscendance and ((AscendanceWithCD and CDs) or not AscendanceWithCD) and FightRemainsCheck < FightRemains and (not StormkeeperP()) then
    if Press(S.Ascendance) then return "ascendance single_target 24"; end
  end
  -- lightning_bolt,if=buff.stormkeeper.up&buff.surge_of_power.up
  if S.LightningBolt:IsAvailable() and UseLightningBolt and (StormkeeperP() and Player:BuffUp(S.SurgeofPowerBuff)) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single_target 26"; end
  end
  -- lava_beam,if=active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)&buff.stormkeeper.up&!talent.surge_of_power.enabled
  if S.LavaBeam:IsCastable() and UseLavaBeam and (Targets40y > 1 and TargetsSplash10y > 1 and StormkeeperP() and not S.SurgeofPower:IsAvailable()) then
    if Press(S.LavaBeam,not Target:IsSpellInRange(S.LavaBeam)) then return "lava_beam single_target 28"; end
  end
  -- chain_lightning,if=active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)&buff.stormkeeper.up&!talent.surge_of_power.enabled
  if S.ChainLightning:IsAvailable() and UseChainlightning and (Targets40y > 1 and TargetsSplash10y > 1 and StormkeeperP() and not S.SurgeofPower:IsAvailable()) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning single_target 30"; end
  end
  -- lava_burst,if=buff.stormkeeper.up&!buff.master_of_the_elements.up&!talent.surge_of_power.enabled&talent.master_of_the_elements.enabled
  if S.LavaBurst:IsAvailable() and UseLavaBurst and (StormkeeperP() and not MOTEP() and not S.SurgeofPower:IsAvailable() and S.MasteroftheElements:IsAvailable()) then
    if Press(S.LavaBurst,not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst single_target 32"; end
  end
  -- lightning_bolt,if=buff.stormkeeper.up&!talent.surge_of_power.enabled&buff.master_of_the_elements.up
  if S.LightningBolt:IsAvailable() and UseLightningBolt and (StormkeeperP() and not S.SurgeofPower:IsAvailable() and MOTEP()) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single_target 34"; end
  end
  -- lightning_bolt,if=buff.stormkeeper.up&!talent.surge_of_power.enabled&!talent.master_of_the_elements.enabled
  if S.LightningBolt:IsAvailable() and UseLightningBolt and (StormkeeperP() and not S.SurgeofPower:IsAvailable() and not S.MasteroftheElements:IsAvailable()) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single_target 36"; end
  end
  -- lightning_bolt,if=buff.surge_of_power.up
  if S.LightningBolt:IsAvailable() and UseLightningBolt and (Player:BuffUp(S.SurgeofPowerBuff)) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single_target 38"; end
  end
  -- icefury,if=talent.electrified_shocks.enabled
  if S.Icefury:IsAvailable() and S.Icefury:CooldownRemains() == 0 and UseIceFury and (S.ElectrifiedShocks:IsAvailable()) then
    if Press(S.Icefury,not Target:IsSpellInRange(S.Icefury)) then return "icefury single_target 40"; end
  end
  -- frost_shock,if=buff.icefury.up&talent.electrified_shocks.enabled&(debuff.electrified_shocks.remains<2|buff.icefury.remains<=gcd)
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and S.ElectrifiedShocks:IsAvailable() and (Target:DebuffRemains(S.ElectrifiedShocksDebuff) < 2 or Player:BuffRemains(S.IcefuryBuff) <= Player:GCD())) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 42"; end
  end
  -- frost_shock,if=buff.icefury.up&talent.electrified_shocks.enabled&maelstrom>=50&debuff.electrified_shocks.remains<2*gcd&buff.stormkeeper.up
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and S.ElectrifiedShocks:IsAvailable() and MaelstromPlayer() >= 50 and Target:DebuffRemains(S.ElectrifiedShocksDebuff) < 2 * Player:GCD() and StormkeeperP()) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 44"; end
  end
  -- lava_beam,if=active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)&buff.power_of_the_maelstrom.up&buff.ascendance.remains>cast_time
  if S.LavaBeam:IsCastable() and UseLavaBeam and (Targets40y > 1 and TargetsSplash10y > 1 and MOTEP() and Player:BuffRemains(S.AscendanceBuff) > S.LavaBeam:CastTime()) then
    if Press(S.LavaBeam,not Target:IsSpellInRange(S.LavaBeam)) then return "lava_beam single_target 46"; end
  end
  -- frost_shock,if=buff.icefury.up&buff.stormkeeper.up&!talent.lava_surge.enabled&!talent.echo_of_the_elements.enabled&!talent.primordial_surge.enabled&talent.elemental_blast.enabled&(maelstrom>=61&maelstrom<75&cooldown.lava_burst.remains>gcd|maelstrom>=49&maelstrom<63&cooldown.lava_burst.ready)
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and StormkeeperP() and not S.LavaSurge:IsAvailable() and not S.EchooftheElements:IsAvailable() and not S.PrimordialSurge:IsAvailable() and S.ElementalBlast:IsAvailable() and (MaelstromPlayer() >= 61 and MaelstromPlayer() < 75 and S.LavaBurst:CooldownRemains() > Player:GCD() or MaelstromPlayer() >= 49 and MaelstromPlayer() < 63 and S.LavaBurst:CooldownRemains() > 0)) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 48"; end
  end
  -- frost_shock,if=buff.icefury.up&buff.stormkeeper.up&!talent.lava_surge.enabled&!talent.echo_of_the_elements.enabled&!talent.elemental_blast.enabled&(maelstrom>=36&maelstrom<50&cooldown.lava_burst.remains>gcd|maelstrom>=24&maelstrom<38&cooldown.lava_burst.ready)
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and not S.LavaSurge:IsAvailable() and not S.EchooftheElements:IsAvailable() and not S.ElementalBlast:IsAvailable() and (MaelstromPlayer() >= 36 and MaelstromPlayer() < 50 and S.LavaBurst:CooldownRemains() > Player:GCD() or MaelstromPlayer() >= 24 and MaelstromPlayer() < 38 and S.LavaBurst:CooldownRemains() > 0)) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 50"; end
  end
  -- lava_burst,if=buff.windspeakers_lava_resurgence.up&(talent.echo_of_the_elements.enabled|talent.lava_surge.enabled|talent.primordial_surge.enabled|maelstrom>=63&talent.master_of_the_elements.enabled|maelstrom>=38&buff.echoes_of_great_sundering.up&active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)|!talent.elemental_blast.enabled)
  if S.LavaBurst:IsAvailable() and UseLavaBurst and (Player:BuffUp(S.WindspeakersLavaResurgenceBuff) and (S.EchooftheElements:IsAvailable() or S.LavaSurge:IsAvailable() or S.PrimordialSurge:IsAvailable() or MaelstromPlayer() >= 63 and S.MasteroftheElements:IsAvailable() or MaelstromPlayer() >= 38 and Player:BuffUp(S.EchoesofGreatSunderingBuff) and Targets40y > 1 and TargetsSplash10y > 1 or not S.ElementalBlast:IsAvailable())) then
    if Press(S.LavaBurst,not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst single_target 52"; end
  end
  -- lava_burst,if=cooldown_react&buff.lava_surge.up&(talent.echo_of_the_elements.enabled|talent.lava_surge.enabled|talent.primordial_surge.enabled|!talent.master_of_the_elements.enabled|!talent.elemental_blast.enabled)
  if S.LavaBurst:IsAvailable() and UseLavaBurst and (Player:BuffUp(S.LavaSurgeBuff) and (S.EchooftheElements:IsAvailable() or S.LavaSurge:IsAvailable() or S.PrimordialSurge:IsAvailable() or not S.MasteroftheElements:IsAvailable() or not S.ElementalBlast:IsAvailable())) then
    if Press(S.LavaBurst,not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst single_target 54"; end
  end
  -- lava_burst,if=talent.master_of_the_elements.enabled&!buff.master_of_the_elements.up&maelstrom>=50&!talent.swelling_maelstrom.enabled&maelstrom<=80
  if S.LavaBurst:IsAvailable() and UseLavaBurst and (S.MasteroftheElements:IsAvailable() and not MOTEP() and MaelstromPlayer() >= 50 and not S.SwellingMaelstrom:IsAvailable() and MaelstromPlayer() <= 80) then
    if Press(S.LavaBurst,not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst single_target 56"; end
  end
  -- lava_burst,if=talent.master_of_the_elements.enabled&!buff.master_of_the_elements.up&(maelstrom>=75|maelstrom>=50&!talent.elemental_blast.enabled)&talent.swelling_maelstrom.enabled&maelstrom<=130
  if S.LavaBurst:IsAvailable() and UseLavaBurst and (S.MasteroftheElements:IsAvailable() and not MOTEP() and (MaelstromPlayer() >= 75 or MaelstromPlayer() >= 50 and not S.SwellingMaelstrom:IsAvailable()) and S.SwellingMaelstrom:IsAvailable() and MaelstromPlayer() <= 130) then
    if Press(S.LavaBurst,not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst single_target 58"; end
  end
  -- earthquake,if=buff.echoes_of_great_sundering.up&(!talent.elemental_blast.enabled&active_enemies<2|active_enemies>1)
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "cursor" and (Player:BuffUp(S.EchoesofGreatSunderingBuff) and (not S.ElementalBlast:IsAvailable() and Targets40y < 2 or Targets40y > 1)) then
    if Press(M.EarthquakeCursor,not Target:IsInRange(40)) then return "earthquake single_target 60"; end
  end
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "player" and (Player:BuffUp(S.EchoesofGreatSunderingBuff) and (not S.ElementalBlast:IsAvailable() and Targets40y < 2 or Targets40y > 1)) then
    if Press(M.EarthquakePlayer,not Target:IsInRange(40)) then return "earthquake single_target 60"; end
  end
  -- earthquake,if=active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)&!talent.echoes_of_great_sundering.enabled&!talent.elemental_blast.enabled
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "cursor"  and (Targets40y > 1 and TargetsSplash10y > 1 and not S.EchoesofGreatSundering:IsAvailable() and not S.ElementalBlast:IsAvailable()) then
    if Press(M.EarthquakeCursor,not Target:IsInRange(40)) then return "earthquake single_target 62"; end
  end
  if S.Earthquake:IsReady() and UseEarthquake and EarthquakeSetting == "player"  and (Targets40y > 1 and TargetsSplash10y > 1 and not S.EchoesofGreatSundering:IsAvailable() and not S.ElementalBlast:IsAvailable()) then
    if Press(M.EarthquakePlayer,not Target:IsInRange(40)) then return "earthquake single_target 62"; end
  end
  -- elemental_blast
  if S.ElementalBlast:IsAvailable() and UseElementalBlast then
    if Press(S.ElementalBlast,not Target:IsSpellInRange(S.ElementalBlast)) then return "elemental_blast single_target 64"; end
  end
  -- earth_shock
  if S.EarthShock:IsReady() and UseEarthshock then
    if Press(S.EarthShock,not Target:IsSpellInRange(S.EarthShock)) then return "earth_shock single_target 66"; end
  end
  -- lava_burst,target_if=dot.flame_shock.remains>2,if=buff.flux_melting.up&active_enemies>1
  if S.LavaBurst:IsAvailable() and UseLavaBurst and CycleThroughEnemies and (Player:BuffUp(S.FluxMeltingBuff) and Targets40y > 1) then
    if Everyone.CastCycle(S.LavaBurst, Enemies10ySplash, EvaluateFlameShockRemains2, not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst single_target 68"; end
  end
  -- lava_burst,target_if=dot.flame_shock.remains>2,if=enemies=1&talent.deeply_rooted_elements.enabled
  if S.LavaBurst:IsAvailable() and UseLavaBurst and CycleThroughEnemies and (Targets40y == 1 and S.DeeplyRootedElements:IsAvailable()) then
    if Everyone.CastCycle(S.LavaBurst, Enemies10ySplash, EvaluateFlameShockRemains2, not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst single_target 70"; end
  end
  -- frost_shock,if=buff.icefury.up&talent.flux_melting.enabled&!buff.flux_melting.up
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and S.FluxMelting:IsAvailable() and Player:BuffDown(S.FluxMeltingBuff)) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 72"; end
  end
  -- frost_shock,if=buff.icefury.up&(talent.electrified_shocks.enabled&debuff.electrified_shocks.remains<2|buff.icefury.remains<6)
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and (S.ElectrifiedShocks:IsAvailable() and Target:DebuffRemains(S.ElectrifiedShocksDebuff) < 2 or Player:BuffRemains(S.IcefuryBuff) < 6)) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 74"; end
  end
  -- lava_burst,target_if=dot.flame_shock.remains>2,if=talent.echo_of_the_elements.enabled|talent.lava_surge.enabled|talent.primordial_surge.enabled|!talent.elemental_blast.enabled|!talent.master_of_the_elements.enabled|buff.stormkeeper.up
  if S.LavaBurst:IsAvailable() and UseLavaBurst and CycleThroughEnemies and (S.EchooftheElements:IsAvailable() or S.LavaSurge:IsAvailable() or S.PrimordialSurge:IsAvailable() or not S.ElementalBlast:IsAvailable() or not S.MasteroftheElements:IsAvailable() or StormkeeperP()) then
    if Everyone.CastCycle(S.LavaBurst, Enemies10ySplash, EvaluateFlameShockRemains2, not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst single_target 76"; end
  end
  -- chain_lightning,if=buff.power_of_the_maelstrom.up&talent.unrelenting_calamity.enabled&active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)
  if S.ChainLightning:IsAvailable() and UseChainlightning and (MOTEP() and S.UnrelentingCalamity:IsAvailable() and Targets40y > 1 and TargetsSplash10y > 1) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning single_target 78"; end
  end
  -- lightning_bolt,if=buff.power_of_the_maelstrom.up&talent.unrelenting_calamity.enabled
  if S.LightningBolt:IsAvailable() and UseLightningBolt and (MOTEP() and S.UnrelentingCalamity:IsAvailable()) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single_target 80"; end
  end
  -- icefury
  if S.Icefury:IsAvailable() and S.Icefury:CooldownRemains() == 0 and UseIceFury then
    if Press(S.Icefury,not Target:IsSpellInRange(S.Icefury)) then return "icefury single_target 82"; end
  end
  -- chain_lightning,if=pet.storm_elemental.active&debuff.lightning_rod.up&(debuff.electrified_shocks.up|buff.power_of_the_maelstrom.up)&active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)
  if S.ChainLightning:IsAvailable() and UseChainlightning and (Pet:IsActive() and Pet:Name() == "Greater Storm Elemental" and Target:DebuffUp(S.LightningRodDebuff) and (Target:DebuffUp(S.ElectrifiedShocksDebuff) or MOTEP()) and Targets40y > 1 and TargetsSplash10y > 1) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning single_target 84"; end
  end
  -- lightning_bolt,if=pet.storm_elemental.active&debuff.lightning_rod.up&(debuff.electrified_shocks.up|buff.power_of_the_maelstrom.up)
  if S.LightningBolt:IsAvailable() and UseLightningBolt and (Pet:IsActive() and Pet:Name() == "Greater Storm Elemental" and Target:DebuffUp(S.LightningRodDebuff) and (Target:DebuffUp(S.ElectrifiedShocksDebuff) or MOTEP())) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single_target 86"; end
  end
  -- frost_shock,if=buff.icefury.up&buff.master_of_the_elements.up&!buff.lava_surge.up&!talent.electrified_shocks.enabled&!talent.flux_melting.enabled&cooldown.lava_burst.charges_fractional<1.0&talent.echo_of_the_elements.enabled
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and MOTEP() and Player:BuffDown(S.LavaSurgeBuff) and not S.ElectrifiedShocks:IsAvailable() and not S.FluxMelting:IsAvailable() and S.LavaBurst:ChargesFractional() < 1.0 and S.EchooftheElements:IsAvailable()) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 88"; end
  end
  -- frost_shock,if=buff.icefury.up&talent.flux_melting.enabled
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and S.FluxMelting:IsAvailable()) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 90"; end
  end
  -- chain_lightning,if=buff.master_of_the_elements.up&!buff.lava_surge.up&(cooldown.lava_burst.charges_fractional<1.0&talent.echo_of_the_elements.enabled)&active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)
  if S.ChainLightning:IsAvailable() and UseChainlightning and (MOTEP() and Player:BuffDown(S.LavaSurgeBuff) and (S.LavaBurst:ChargesFractional() < 1.0 and S.EchooftheElements:IsAvailable()) and Targets40y > 1 and TargetsSplash10y > 1) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning single_target 92"; end
  end
  -- lightning_bolt,if=buff.master_of_the_elements.up&!buff.lava_surge.up&(cooldown.lava_burst.charges_fractional<1.0&talent.echo_of_the_elements.enabled)
  if S.LightningBolt:IsAvailable() and UseLightningBolt and (MOTEP() and Player:BuffDown(S.LavaSurgeBuff) and (S.LavaBurst:ChargesFractional() < 1.0 and S.EchooftheElements:IsAvailable())) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single_target 94"; end
  end
  -- frost_shock,if=buff.icefury.up&!talent.electrified_shocks.enabled&!talent.flux_melting.enabled
  if S.FrostShock:IsCastable() and UseFrostShock and (IceFuryP() and not S.ElectrifiedShocks:IsAvailable() and not S.FluxMelting:IsAvailable()) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 96"; end
  end
  -- chain_lightning,if=active_enemies>1&(spell_targets.chain_lightning>1|spell_targets.lava_beam>1)
  if S.ChainLightning:IsAvailable() and UseChainlightning and (Targets40y > 1 and TargetsSplash10y > 1) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning single_target 98"; end
  end
  -- lightning_bolt
  if S.LightningBolt:IsAvailable() and UseLightningBolt then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single_target 100"; end
  end
  -- flame_shock,moving=1,target_if=refreshable
  if S.FlameShock:IsCastable() and UseFlameShock and CycleThroughEnemies and (Player:IsMoving()) then
    if Everyone.CastCycle(S.FlameShock, Enemies10ySplash, EvaluateFlameShockRefreshable, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock single_target 102"; end
  end
  -- flame_shock,moving=1,if=movement.distance>6
  if S.FlameShock:IsCastable() and UseFlameShock then
    if Press(S.FlameShock,not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock single_target 104"; end
  end
  -- frost_shock,moving=1
  if S.FrostShock:IsCastable() and UseFrostShock then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single_target 106"; end
  end
end


local function OutOfCombat()
  -- Refresh shields.
  if AutoShield and ShieldUse == "Earth Shield" and S.EarthShield:IsCastable() and (Player:BuffDown(S.EarthShield) or (not Player:AffectingCombat() and Player:BuffStack(S.EarthShield) < 5)) then
    if Press(S.EarthShield) then return "Earth Shield Refresh"; end
  elseif AutoShield and S.LightningShield:IsCastable() and Player:BuffDown(S.LightningShield) and (ShieldUse == "Earth Shield" and Player:BuffDown(S.EarthShield) or ShieldUse == "Lightning Shield") then
    if Press(S.LightningShield) then return "Lightning Shield Refresh" end
  end

  if Focus then
    -- dispel
    if DispelDebuffs then
      ShouldReturn = Dispel(); if ShouldReturn then return ShouldReturn; end
    end
  end

  -- Afflicted
  if HandleAfflicted then
    if UseCleanseSpiritWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.CleanseSpirit, M.CleanseSpiritMouseover, 40); if ShouldReturn then return ShouldReturn; end
    end
    if UseTremorTotemWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.TremorTotem, S.TremorTotem, 30); if ShouldReturn then return ShouldReturn; end
    end
    if UsePoisonCleansingTotemWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.PoisonCleansingTotem, S.PoisonCleansingTotem, 30); if ShouldReturn then return ShouldReturn; end
    end
  end

  -- heal
  ShouldReturn = HealOOC(); if ShouldReturn then return ShouldReturn; end

  -- resurrection
  if Target and Target:Exists() and Target:IsAPlayer() and Target:IsDeadOrGhost() and (not Player:CanAttack(Target)) then
    if Press(S.AncestralSpirit, nil, true) then return "ancestral_spirit"; end
  end
  --Redemption Mouseover
  if S.AncestralSpirit:IsCastable() and S.AncestralSpirit:IsReady() and not Player:AffectingCombat() and Mouseover:Exists() and Mouseover:IsDeadOrGhost() and Mouseover:IsAPlayer() and (not Player:CanAttack(Mouseover))  then
    if Press(M.AncestralSpiritMouseover) then return "ancestral_spirit mouseover" end
  end

  -- call Precombat
  if not Player:AffectingCombat() and OOC then
    ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
  end
end

local function Combat()
  -- defensive
  ShouldReturn = Defensive(); if ShouldReturn then return ShouldReturn; end

  -- Afflicted
  if HandleAfflicted then
    if UseCleanseSpiritWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.CleanseSpirit, M.CleanseSpiritMouseover, 40); if ShouldReturn then return ShouldReturn; end
    end
    if UseTremorTotemWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.TremorTotem, S.TremorTotem, 30); if ShouldReturn then return ShouldReturn; end
    end
    if UsePoisonCleansingTotemWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.PoisonCleansingTotem, S.PoisonCleansingTotem, 30); if ShouldReturn then return ShouldReturn; end
    end
  end
  
  -- Incorporeal
  if HandleIncorporeal then
    ShouldReturn = Everyone.HandleIncorporeal(S.Hex, M.HexMouseOver, 30, true); if ShouldReturn then return ShouldReturn; end
  end

  if Focus then
    -- dispel
    if DispelDebuffs then
      ShouldReturn = Dispel(); if ShouldReturn then return ShouldReturn; end
    end
  end

  -- purge
  if S.GreaterPurge:IsAvailable() and UsePurgeTarget and S.GreaterPurge:IsReady() and DispelToggle and DispelBuffs and (not Player:IsCasting()) and (not Player:IsChanneling()) and Everyone.UnitHasMagicBuff(Target) then
    if Press(S.GreaterPurge, not Target:IsSpellInRange(S.GreaterPurge)) then return "greater_purge damage"; end
  end
  if S.Purge:IsReady() and UsePurgeTarget and DispelToggle and DispelBuffs and (not Player:IsCasting()) and (not Player:IsChanneling()) and Everyone.UnitHasMagicBuff(Target) then
    if Press(S.Purge, not Target:IsSpellInRange(S.Purge)) then return "purge damage"; end
  end

  if Everyone.TargetIsValid() then
    -- spiritwalkers_grace,moving=1,if=movement.distance>6
    -- Note: Too situational to include
    -- wind_shear
    -- wind_shear
    if not Player:IsCasting() and not Player:IsChanneling() and Kick then
      if UseWindShear then
        ShouldReturn = Everyone.Interrupt(S.WindShear, 30); if ShouldReturn then return ShouldReturn; end
        ShouldReturn = Everyone.Interrupt(M.WindShearMouseover, 30); if ShouldReturn then return ShouldReturn; end
      end
      if UseCapacitorTotem then
        ShouldReturn = Everyone.InterruptWithStunCursor(M.CapacitorTotemCursor, 40); if ShouldReturn then return ShouldReturn; end
      end
      if UseThunderstorm and S.Thundershock:IsAvailable() then
        ShouldReturn = Everyone.InterruptWithStun(S.Thunderstorm, 10); if ShouldReturn then return ShouldReturn; end
      end
    end

    if FightRemainsCheck < FightRemains and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) then
      -- blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
      if S.BloodFury:IsCastable() and (not S.Ascendance:IsAvailable() or Player:BuffUp(S.AscendanceBuff) or S.Ascendance:CooldownRemains() > 50) then
        if Press(S.BloodFury) then return "blood_fury main 2"; end
      end
      -- berserking,if=!talent.ascendance.enabled|buff.ascendance.up
      if S.Berserking:IsCastable() and (not S.Ascendance:IsAvailable() or Player:BuffUp(S.AscendanceBuff)) then
        if Press(S.Berserking) then return "berserking main 4"; end
      end
      -- fireblood,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
      if S.Fireblood:IsCastable() and (not S.Ascendance:IsAvailable() or Player:BuffUp(S.AscendanceBuff) or S.Ascendance:CooldownRemains() > 50) then
        if Press(S.Fireblood) then return "fireblood main 6"; end
      end
      -- ancestral_call,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
      if S.AncestralCall:IsCastable() and (not S.Ascendance:IsAvailable() or Player:BuffUp(S.AscendanceBuff) or S.Ascendance:CooldownRemains() > 50) then
        if Press(S.AncestralCall) then return "ancestral_call main 8"; end
      end
      -- bag_of_tricks,if=!talent.ascendance.enabled|!buff.ascendance.up
      if S.BagofTricks:IsCastable() and (not S.Ascendance:IsAvailable() or Player:BuffUp(S.AscendanceBuff)) then
        if Press(S.BagofTricks) then return "bag_of_tricks main 10"; end
      end
    end
    -- trinkets
    if FightRemainsCheck < FightRemains then
      if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) then
        ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
      end
    end

    -- natures_swiftness
    if S.NaturesSwiftness:IsCastable() and UseNaturesSwiftness then
      if Press(S.NaturesSwiftness) then return "natures_swiftness main 12"; end
    end
    -- invoke_external_buff,name=power_infusion,if=talent.ascendance.enabled&buff.ascendance.up|!talent.ascendance.enabled
    -- Note: Not handling external buffs.
    -- potion
    local ShouldReturnPot = Everyone.HandleDPSPotion(Player:BuffUp(S.AscendanceBuff)); if ShouldReturnPot then return ShouldReturnPot; end
    -- Note: Not handling potions.
    -- run_action_list,name=aoe,if=active_enemies>2&(spell_targets.chain_lightning>2|spell_targets.lava_beam>2)
    if (AOE and Targets40y > 2 and TargetsSplash10y > 2) then
      ShouldReturn = Aoe(); if ShouldReturn then return ShouldReturn; end
      if Press(S.Pool) then return "Pool for Aoe()"; end
    end
    -- run_action_list,name=single_target
    if (true) then
      ShouldReturn = SingleTarget(); if ShouldReturn then return ShouldReturn; end
      if Press(S.Pool) then return "Pool for SingleTarget()"; end
    end
  end
end

local function FetchUseSettings()
  --General Use
  UseChainlightning = EpicSettings.Settings["useChainlightning"]
  UseEarthquake = EpicSettings.Settings["useEarthquake"]
  UseEarthshock = EpicSettings.Settings["useEarthshock"]
  UseElementalBlast = EpicSettings.Settings["useElementalBlast"]
  UseFlameShock = EpicSettings.Settings["useFlameShock"]
  UseFrostShock = EpicSettings.Settings["useFrostShock"]
  UseIceFury = EpicSettings.Settings["useIceFury"]
  UseLavaBeam = EpicSettings.Settings["useLavaBeam"]
  UseLavaBurst = EpicSettings.Settings["useLavaBurst"]
  UseLightningBolt = EpicSettings.Settings["useLightningBolt"]
  UseNaturesSwiftness = EpicSettings.Settings["useNaturesSwiftness"]
  UsePrimordialWave = EpicSettings.Settings["usePrimordialWave"]
  UseStormkeeper = EpicSettings.Settings["useStormkeeper"]
  UseTotemicRecall = EpicSettings.Settings["useTotemicRecall"]

  UseWeaponEnchant = EpicSettings.Settings["useWeaponEnchant"]

  -- CD Usage
  UseAscendance = EpicSettings.Settings["useAscendance"]
  UseLiquidMagmaTotem = EpicSettings.Settings["useLiquidMagmaTotem"]
  UseFireElemental = EpicSettings.Settings["useFireElemental"]
  UseStormElemental = EpicSettings.Settings["useStormElemental"]

  --SaveWithCD Settings
  AscendanceWithCD = EpicSettings.Settings["ascendanceWithCD"]
  LiquidMagmaTotemWithCD = EpicSettings.Settings["liquidMagmaTotemWithCD"]
  FireElementalWithCD = EpicSettings.Settings["fireElementalWithCD"]
  StormElementalWithCD = EpicSettings.Settings["stormElementalWithCD"]

  --SaveWithMiniCD Settings
  PrimordialWaveWithMiniCD = EpicSettings.Settings["primordialWaveWithMiniCD"]
  StormkeeperWithMiniCD = EpicSettings.Settings["stormkeeperWithMiniCD"]
end

local function FetchSettings()
  --Interrupt Settings
  UseWindShear = EpicSettings.Settings["useWindShear"]
  UseCapacitorTotem = EpicSettings.Settings["useCapacitorTotem"]
  UseThunderstorm = EpicSettings.Settings["useThunderstorm"]

  --Defensive Use Settings
  UseAncestralGuidance = EpicSettings.Settings["useAncestralGuidance"]
  UseAstralShift = EpicSettings.Settings["useAstralShift"]
  UseHealingStreamTotem = EpicSettings.Settings["useHealingStreamTotem"]

  --Defensive HP Settings
  AncestralGuidanceHP = EpicSettings.Settings["ancestralGuidanceHP"] or 0
  AncestralGuidanceGroup = EpicSettings.Settings["ancestralGuidanceGroup"] or 0
  AstralShiftHP = EpicSettings.Settings["astralShiftHP"] or 0
  HealingStreamTotemHP = EpicSettings.Settings["healingStreamTotemHP"] or 0
  HealingStreamTotemGroup = EpicSettings.Settings["healingStreamTotemGroup"] or 0
  
  --Placement Settings
  EarthquakeSetting = EpicSettings.Settings["earthquakeSetting"] or ""
  LiquidMagmaTotemSetting = EpicSettings.Settings["liquidMagmaTotemSetting"] or ""

  --Other Settings
  AutoShield = EpicSettings.Settings["autoShield"]
  ShieldUse = EpicSettings.Settings["shieldUse"] or "Lightning Shield"
  UseHealOOC = EpicSettings.Settings["healOOC"]
  HealOOCHP = EpicSettings.Settings["healOOCHP"] or 0
  CycleThroughEnemies = EpicSettings.Settings["cycleThroughEnemies"]
  UsePurgeTarget = EpicSettings.Settings["usePurgeTarget"]

  --Afflicted Reaction
  UseCleanseSpiritWithAfflicted = EpicSettings.Settings["useCleanseSpiritWithAfflicted"]
  UseTremorTotemWithAfflicted = EpicSettings.Settings["useTremorTotemWithAfflicted"]
  UsePoisonCleansingTotemWithAfflicted = EpicSettings.Settings["usePoisonCleansingTotemWithAfflicted"]
end

local function FetchGeneralSettings()
  FightRemainsCheck = EpicSettings.Settings["fightRemainsCheck"] or 0

  InterruptWithStun = EpicSettings.Settings["InterruptWithStun"]
  InterruptOnlyWhitelist = EpicSettings.Settings["InterruptOnlyWhitelist"]
  InterruptThreshold = EpicSettings.Settings["InterruptThreshold"]

  DispelDebuffs = EpicSettings.Settings["DispelDebuffs"]
  DispelBuffs = EpicSettings.Settings["DispelBuffs"]
  
  UseTrinkets = EpicSettings.Settings["useTrinkets"]
  UseRacials = EpicSettings.Settings["useRacials"]
  TrinketsWithCD = EpicSettings.Settings["trinketsWithCD"]
  RacialsWithCD = EpicSettings.Settings["racialsWithCD"]

  UseHealthstone = EpicSettings.Settings["useHealthstone"]
  UseHealingPotion = EpicSettings.Settings["useHealingPotion"]
  HealthstoneHP = EpicSettings.Settings["healthstoneHP"] or 0
  HealingPotionHP = EpicSettings.Settings["healingPotionHP"] or 0
  HealingPotionName = EpicSettings.Settings["HealingPotionName"] or ""

  HandleAfflicted = EpicSettings.Settings["handleAfflicted"]
  HandleIncorporeal = EpicSettings.Settings["HandleIncorporeal"]
end

--- ======= MAIN =======
local function APL()
  FetchSettings();
  FetchUseSettings();
  FetchGeneralSettings();

  OOC = EpicSettings.Toggles["ooc"]
  AOE = EpicSettings.Toggles["aoe"]
  CDs = EpicSettings.Toggles["cds"]
  Kick = EpicSettings.Toggles["kick"]
  DispelToggle = EpicSettings.Toggles["dispel"]
  MiniCDs = EpicSettings.Toggles["minicds"]

  Enemies40y = Player:GetEnemiesInRange(40)
  Enemies10ySplash = Target:GetEnemiesInSplashRange(10)
  if AOE then
    Targets40y = #Enemies40y
    TargetsSplash10y = Target:GetEnemiesInSplashRangeCount(10)
  else
    Targets40y = 1
    TargetsSplash10y = 1
  end

  --Focus and Dispell
  if Player:AffectingCombat() or DispelDebuffs then
    local includeDispellableUnits = DispelDebuffs and S.CleanseSpirit:IsReady() and DispelToggle
    ShouldReturn = Everyone.FocusUnit(includeDispellableUnits, nil, nil, nil); if ShouldReturn then return ShouldReturn; end
  end

  if Everyone.TargetIsValid() or Player:AffectingCombat() then
    -- Calculate fight_remains
    BossFightRemains = EL.BossFightRemains()
    FightRemains = BossFightRemains
    if FightRemains == 11111 then
      FightRemains = EL.FightRemains(Enemies10ySplash, false)
    end
  end

  if (not Player:IsChanneling()) then
    if Player:AffectingCombat() then
      -- Combat
      ShouldReturn = Combat(); if ShouldReturn then return ShouldReturn; end
    else
      -- OutOfCombat
      ShouldReturn = OutOfCombat(); if ShouldReturn then return ShouldReturn; end
    end
  end
end

local function Init()
  S.FlameShockDebuff:RegisterAuraTracking()
  FillDispels()
  ER.Print("Elemental Shaman by Epic. Supported by xKaneto.")
end

ER.SetAPL(262, APL, Init)
