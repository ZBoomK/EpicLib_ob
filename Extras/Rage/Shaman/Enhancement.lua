--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- EpicDBC
local DBC        = EpicDBC.DBC
-- EpicLib
local EL         = EpicLib
local Cache      = EpicCache
local Unit       = EL.Unit
local Player     = Unit.Player
local Target     = Unit.Target
local Spell      = EL.Spell
local MultiSpell = EL.MultiSpell
local Item       = EL.Item
-- EpicLib
local ER         = EpicLib
local Cast       = ER.Cast
local Macro      = ER.Macro
local Press      = ER.Press
-- Num/Bool Helper Functions
local num        = ER.Commons.Everyone.num
local bool       = ER.Commons.Everyone.bool
-- Lua
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local max        = math.max
local strmatch   = string.match

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

local UseCapacitorTotem
local UseChainlightning
local UseCrashLightning
local UseEarthElemental
local UseElementalBlast
local UseFireNova
local UseFlameShock
local UseFrostShock
local UseIceStrike
local UseLavaBurst
local UseLavaLash
local UseLightningBolt
local UsePrimordialWave
local UseStormStrike
local UseSundering
local UseWindfuryTotem
local UseWindstrike
local UseWeaponEnchant

--Settings Use with CD
local UseAscendance
local UseFeralSpirit
local UseDoomWinds
local UseTrinkets
local UseRacials

--Settings WithCDs
local AscendanceWithCD
local FeralSpiritWithCD
local DoomWindsWithCD

local SunderingWithMiniCD
local PrimordialWaveWithMiniCD

local TrinketsWithCD
local RacialsWithCD

--Interrupt Use Settings
local UseWindShear
local UseCapacitorTotem
local UseThunderstorm

--Settings UseDefensives
local UseHealingSurge
local UseAstralShift
local UseAncestralGuidance
local UseHealingStreamTotem
local UseMaelstromHealingSurge

local UseHealthstone
local UseHealingPotion

--Settings DefensiveHP
local AstralShiftHP
local AncestralGuidanceHP
local AncestralGuidanceGroup
local HealingStreamTotemHP
local HealingStreamTotemGroup
local MaelstromHealingSurgeCriticalHP

local HealthstoneHP
local HealingPotionHP
local UseHealOOC
local HealOOCHP;

--Afflicted Settings
local UseCleanseSpiritWithAfflicted
local UseTremorTotemWithAfflicted
local UsePoisonCleansingTotemWithAfflicted
local UseMaelstromHealingSurgeWithAfflicted

--Extras
local CycleThroughEnemies
local DispelBuffs
local DispelDebuffs
local HandleAfflicted;
local HandleIncorporeal;
local HealingPotionName;
local InterruptWithStun;
local InterruptOnlyWhitelist;
local InterruptThreshold;
local FightRemainsCheck;
local UsePurgeTarget

--- ======= APL LOCALS =======

-- Define S/I for spell and item arrays
local S = Spell.Shaman.Enhancement
local I = Item.Shaman.Enhancement
local M = Macro.Shaman.Enhancement

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
}

-- Rotation Var
local HasMainHandEnchant, HasOffHandEnchant
local MHEnchantTimeRemains, OHEnchantTimeRemains
local Enemies40y, Enemies10y, Enemies10yCount, Enemies40yCount
local MaxEBCharges = S.LavaBurst:IsAvailable() and 2 or 1
local TIAction = S.LightningBolt
local BossFightRemains = 11111
local FightRemains = 11111

EL:RegisterForEvent(function()
  MaxEBCharges = S.LavaBurst:IsAvailable() and 2 or 1
end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB")

EL:RegisterForEvent(function()
  TIAction = S.LightningBolt
  BossFightRemains = 11111
  FightRemains = 11111
end, "PLAYER_REGEN_ENABLED")

-- GUI Settings
local Everyone = ER.Commons.Everyone
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.Shaman.Commons,
--  Enhancement = ER.GUISettings.APL.Shaman.Enhancement
--}

local function FillDispels()
  if S.CleanseSpirit:IsAvailable() then
    Everyone.DispellableDebuffs = Everyone.DispellableCurseDebuffs
  end
end

EL:RegisterForEvent(function()
  FillDispels()
end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");

local function TotemFinder()
  for i = 1, 6, 1 do
    if strmatch(Player:TotemName(i), 'Totem') then
      return i
    end
  end
end

local function EvaluateCycleFlameShock(TargetUnit)
  return (TargetUnit:DebuffRefreshable(S.FlameShockDebuff))
end

local function EvaluateCycleLavaLash(TargetUnit)
  return (TargetUnit:DebuffRefreshable(S.LashingFlamesDebuff))
end

local function EvaluateTargetIfFilterPrimordialWave(TargetUnit)
  return (TargetUnit:DebuffRemains(S.FlameShockDebuff))
end

local function EvaluateTargetIfPrimordialWave(TargetUnit)
  return (Player:BuffDown(S.PrimordialWaveBuff))
end

local function EvaluateTargetIfFilterLavaLash(TargetUnit)
  return (Target:DebuffRemains(S.LashingFlamesDebuff))
end

local function EvaluateTargetIfLavaLash(TargetUnit)
  return (S.LashingFlames:IsAvailable())
end

local function EvaluateTargetIfLavaLash2(TargetUnit)
  return (TargetUnit:DebuffUp(S.FlameShockDebuff) and (S.FlameShockDebuff:AuraActiveCount() < Enemies10yCount and S.FlameShockDebuff:AuraActiveCount() < 6))
end

local function Dispel()
  -- Cleanse Spirit
  if S.CleanseSpirit:IsReady() and DispelToggle and Everyone.DispellableFriendlyUnit() then
    if Press(M.CleanseSpiritFocus) then return "cleanse_spirit dispel"; end
  end
end

local function HealCombat()
  if not Focus or not Focus:Exists() or not Focus:IsInRange(40) then return; end
  if Focus then
    -- Maelstrom Heal in Combat
    if Focus:HealthPercentage() <= MaelstromHealingSurgeCriticalHP and UseMaelstromHealingSurge and S.HealingSurge:IsReady() and Player:BuffStack(S.MaelstromWeaponBuff) >= 5 then
      if Press(M.HealingSurgeFocus) then return "healing_surge heal focus"; end
    end
  end
end
local function HealOOC()
  -- Heal Out of Combat
  if Player:HealthPercentage() <= HealOOCHP then
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

  -- Maelstrom Healing Surge Critical @ hp%
  if S.HealingSurge:IsReady() and UseMaelstromHealingSurge and Player:HealthPercentage() <= MaelstromHealingSurgeCriticalHP and Player:BuffStack(S.MaelstromWeaponBuff) >= 5 then
    if Press(S.HealingSurge) then return "healing_surge defensive 4"; end
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
  -- windfury_weapon
  if ((not HasMainHandEnchant) or MHEnchantTimeRemains < 600000) and UseWeaponEnchant and S.WindfuryWeapon:IsCastable() then
    if Press(S.WindfuryWeapon) then return "windfury_weapon enchant"; end
  end
  -- flametongue_weapon
  if ((not HasOffHandEnchant) or OHEnchantTimeRemains < 600000) and UseWeaponEnchant and S.FlamentongueWeapon:IsCastable() then
    if Press(S.FlamentongueWeapon) then return "flametongue_weapon enchant"; end
  end
  -- lightning_shield
  -- Note: Moved to top of APL()
  -- windfury_totem
  if S.WindfuryTotem:IsReady() and (Player:BuffDown(S.WindfuryTotemBuff, true) or S.WindfuryTotem:TimeSinceLastCast() > 90 and UseWindfuryTotem) then
    if Press(S.WindfuryTotem) then return "windfury_totem precombat 4"; end
  end
  -- variable,name=trinket1_is_weird,value=trinket.1.is.the_first_sigil|trinket.1.is.scars_of_fraternal_strife|trinket.1.is.cache_of_acquired_treasures
  -- variable,name=trinket2_is_weird,value=trinket.2.is.the_first_sigil|trinket.2.is.scars_of_fraternal_strife|trinket.2.is.cache_of_acquired_treasures
  -- Note: These variables just exclude these three trinkets from the generic use_items. We'll just use ER's OnUseExcludes instead.
  -- snapshot_stats
end

local function Single()
  -- windstrike,if=talent.thorims_invocation.enabled&buff.maelstrom_weapon.stack>=1
  if S.Windstrike:IsReady() and UseWindstrike and (S.ThorimsInvocation:IsAvailable() and Player:BuffStack(S.MaelstromWeaponBuff) >= 1) then
    if Press(S.Windstrike,not Target:IsSpellInRange(S.Windstrike)) then return "windstrike single 2"; end
  end
  -- lava_lash,if=buff.hot_hand.up|buff.ashen_catalyst.stack=8|(buff.ashen_catalyst.stack>=5&buff.maelstrom_of_elements.up&buff.maelstrom_weapon.stack<=6)
  if S.LavaLash:IsReady() and UseLavaLash and (Player:BuffUp(S.HotHandBuff) or Player:BuffStack(S.AshenCatalystBuff) == 8 or (Player:BuffStack(S.AshenCatalystBuff) >= 5 and Player:BuffUp(S.MaelstromofElementsBuff) and Player:BuffStack(S.MaelstromWeaponBuff) <= 6)) then
    if Press(S.LavaLash,not Target:IsSpellInRange(S.LavaLash)) then return "lava_lash single 4"; end
  end
  -- windfury_totem,if=!buff.windfury_totem.up
  if S.WindfuryTotem:IsReady() and UseWindfuryTotem and (Player:BuffDown(S.WindfuryTotemBuff, true)) then
    if Press(S.WindfuryTotem) then return "windfury_totem single 6"; end
  end
  if (Player:BuffUp(S.DoomWindsBuff)) then
    -- stormstrike,if=buff.doom_winds_talent.up
    if S.Stormstrike:IsReady() and UseStormStrike then
      if Press(S.Stormstrike,not Target:IsSpellInRange(S.Stormstrike)) then return "stormstrike single 8"; end
    end
    -- crash_lightning,if=buff.doom_winds_talent.up
    if S.CrashLightning:IsReady() and UseCrashLightning then
      if Press(S.CrashLightning,not Target:IsInMeleeRange(8)) then return "crash_lightning single 10"; end
    end
    -- ice_strike,if=buff.doom_winds_talent.up
    if S.IceStrike:IsReady() and UseIceStrike then
      if Press(S.IceStrike,not Target:IsInMeleeRange(5)) then return "ice_strike single 12"; end
    end
    -- sundering,if=buff.doom_winds_talent.up
    if S.Sundering:IsReady() and UseSundering and ((SunderingWithMiniCD and MiniCDs) or not SunderingWithMiniCD) and FightRemainsCheck < FightRemains then
      if Press(S.Sundering,not Target:IsInRange(11)) then return "sundering single 14"; end
    end
  end
  -- primordial_wave,if=buff.primordial_wave.down&(raid_event.adds.in>42|raid_event.adds.in<6)
  if S.PrimordialWave:IsCastable() and UsePrimordialWave and ((PrimordialWaveWithMiniCD and MiniCDs) or not PrimordialWaveWithMiniCD) and FightRemainsCheck < FightRemains and (Player:BuffDown(S.PrimordialWaveBuff)) then
    if Press(S.PrimordialWave,not Target:IsSpellInRange(S.PrimordialWave)) then return "primordial_wave single 16"; end
  end
  -- flame_shock,if=!ticking
  if S.FlameShock:IsReady() and UseFlameShock and (Target:DebuffDown(S.FlameShockDebuff)) then
    if Press(S.FlameShock,not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock single 18"; end
  end
  -- lightning_bolt,if=buff.maelstrom_weapon.stack>=5&buff.primordial_wave.up&raid_event.adds.in>buff.primordial_wave.remains&(!buff.splintered_elements.up|fight_remains<=12)
  if S.LightningBolt:IsCastable() and UseLightningBolt and (Player:BuffStack(S.MaelstromWeaponBuff) >= 5 and Player:BuffUp(S.PrimordialWaveBuff) and (Player:BuffDown(S.SplinteredElementsBuff) or FightRemains <= 12)) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single 20"; end
  end
  -- ice_strike,if=talent.hailstorm.enabled
  if S.IceStrike:IsReady() and UseIceStrike and (S.Hailstorm:IsAvailable()) then
    if Press(S.IceStrike,not Target:IsInMeleeRange(5)) then return "ice_strike single 22"; end
  end
  -- stormstrike,if=set_bonus.tier29_2pc&buff.maelstrom_of_elements.down&buff.maelstrom_weapon.stack<=5
  if S.Stormstrike:IsCastable() and UseStormStrike and (Player:HasTier(29, 2) and Player:BuffDown(S.MaelstromofElementsBuff) and Player:BuffStack(S.MaelstromWeaponBuff) <= 5) then
    if Press(S.Stormstrike,not Target:IsSpellInRange(S.Stormstrike)) then return "stormstrike single 28"; end
  end
  -- frost_shock,if=buff.hailstorm.up
  if S.FrostShock:IsReady() and UseFrostShock and (Player:BuffUp(S.HailstormBuff)) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single 24"; end
  end
  -- lava_lash,if=talent.molten_assault.enabled&dot.flame_shock.refreshable
  if S.LavaLash:IsCastable() and UseLavaLash and (S.MoltenAssault:IsAvailable() and Target:DebuffRefreshable(S.FlameShockDebuff)) then
    if Press(S.LavaLash,not Target:IsSpellInRange(S.LavaLash)) then return "lava_lash single 26"; end
  end
  -- windstrike,if=talent.deeply_rooted_elements.enabled|buff.earthen_weapon.up|buff.legacy_of_the_frost_witch.up
  if S.Windstrike:IsCastable() and UseWindstrike and (S.DeeplyRootedElements:IsAvailable() or Player:BuffUp(S.EarthenWeaponBuff) or Player:BuffUp(S.LegacyoftheFrostWitch)) then
    if Press(S.Windstrike,not Target:IsSpellInRange(S.Windstrike)) then return "stormstrike single 28"; end
  end
  -- stormstrike,if=talent.deeply_rooted_elements.enabled|buff.earthen_weapon.up|buff.legacy_of_the_frost_witch.up
  if S.Stormstrike:IsCastable() and UseStormStrike and (S.DeeplyRootedElements:IsAvailable() or Player:BuffUp(S.EarthenWeaponBuff) or Player:BuffUp(S.LegacyoftheFrostWitch)) then
    if Press(S.Stormstrike,not Target:IsSpellInRange(S.Stormstrike)) then return "stormstrike single 28"; end
  end
  -- elemental_blast,if=(talent.elemental_spirits.enabled&buff.maelstrom_weapon.stack=10)|(!talent.elemental_spirits.enabled&buff.maelstrom_weapon.stack>=5)
  if S.ElementalBlast:IsReady() and UseElementalBlast and ((S.ElementalSpirits:IsAvailable() and Player:BuffStack(S.MaelstromWeaponBuff) == 10) or ((not S.ElementalSpirits:IsAvailable()) and Player:BuffStack(S.MaelstromWeaponBuff) >= 5)) then
    if Press(S.ElementalBlast,not Target:IsSpellInRange(S.ElementalBlast)) then return "elemental_blast single 30"; end
  end
  -- lava_burst,if=buff.maelstrom_weapon.stack>=5
  if S.LavaBurst:IsReady() and UseLavaBurst and (Player:BuffStack(S.MaelstromWeaponBuff) >= 5) then
    if Press(S.LavaBurst,not Target:IsSpellInRange(S.LavaBurst)) then return "lava_burst single 34"; end
  end
  -- lightning_bolt,if=buff.maelstrom_weapon.stack=10&buff.primordial_wave.down
  if S.LightningBolt:IsReady() and UseLightningBolt and (Player:BuffStack(S.MaelstromWeaponBuff) == 10 and Player:BuffDown(S.PrimordialWaveBuff)) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single 36"; end
  end
  -- windstrike
  if S.Windstrike:IsCastable() and UseWindstrike then
    if Press(S.Windstrike,not Target:IsSpellInRange(S.Windstrike)) then return "windstrike single 37"; end
  end
  -- stormstrike
  if S.Stormstrike:IsReady() and UseWindstrike then
    if Press(S.Stormstrike,not Target:IsSpellInRange(S.Stormstrike)) then return "stormstrike single 38"; end
  end
  -- windfury_totem,if=buff.windfury_totem.remains<10
  if S.WindfuryTotem:IsReady() and UseWindfuryTotem and (Player:BuffDown(S.WindfuryTotemBuff, true) or S.WindfuryTotem:TimeSinceLastCast() > 110) then
    if Press(S.WindfuryTotem) then return "windfury_totem single 42"; end
  end
  -- ice_strike
  if S.IceStrike:IsReady() and UseIceStrike then
    if Press(S.IceStrike,not Target:IsInMeleeRange(5)) then return "ice_strike single 44"; end
  end
  -- lava_lash
  if S.LavaLash:IsReady() and UseLavaLash then
    if Press(S.LavaLash,not Target:IsSpellInRange(S.LavaLash)) then return "lava_lash single 46"; end
  end
  -- elemental_blast,if=talent.elemental_spirits.enabled&(charges=max_charges|buff.feral_spirit.up)&buff.maelstrom_weapon.stack>=5
  if S.ElementalBlast:IsReady() and UseElementalBlast and (S.ElementalSpirits:IsAvailable() and (S.ElementalBlast:Charges() == S.ElementalBlast:MaxCharges() or Player:BuffUp(S.FeralSpiritBuff)) and Player:BuffStack(S.MaelstromWeaponBuff) >= 5) then
    if Press(S.ElementalBlast,not Target:IsSpellInRange(S.ElementalBlast)) then return "elemental_blast single 47"; end
  end
  -- bag_of_tricks
  if S.BagofTricks:IsCastable() and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) then
    if Press(S.BagofTricks) then return "bag_of_tricks single 48"; end
  end
  -- lightning_bolt,if=buff.maelstrom_weapon.stack>=5&buff.primordial_wave.down
  if S.LightningBolt:IsCastable() and UseLightningBolt and (Player:BuffStack(S.MaelstromWeaponBuff) >= 5 and Player:BuffDown(S.PrimordialWaveBuff)) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt single 50"; end
  end
  -- sundering,if=raid_event.adds.in>=40
  if S.Sundering:IsReady() and UseSundering and ((SunderingWithMiniCD and MiniCDs) or not SunderingWithMiniCD) and FightRemainsCheck < FightRemains  then
    if Press(S.Sundering,not Target:IsInRange(11)) then return "sundering single 52"; end
  end
  -- fire_nova,if=talent.swirling_maelstrom.enabled&active_dot.flame_shock
  if S.FireNova:IsReady() and UseFireNova and (S.SwirlingMaelstrom:IsAvailable() and Target:DebuffUp(S.FlameShockDebuff)) then
    if Press(S.FireNova,not Target:IsInMeleeRange(5)) then return "fire_nova single 54"; end
  end
  -- frost_shock
  if S.FrostShock:IsReady() and UseFrostShock then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock single 56"; end
  end
  -- crash_lightning
  if S.CrashLightning:IsReady() and UseCrashLightning then
    if Press(S.CrashLightning,not Target:IsInRange(8)) then return "crash_lightning single 58"; end
  end
  -- fire_nova,if=active_dot.flame_shock
  if S.FireNova:IsReady() and UseFireNova and (Target:DebuffUp(S.FlameShockDebuff)) then
    if Press(S.FireNova) then return "fire_nova single 60"; end
  end
  -- earth_elemental
  if S.EarthElemental:IsCastable() and UseEarthElemental then
    if Press(S.EarthElemental) then return "earth_elemental single 64"; end
  end
  -- flame_shock
  if S.FlameShock:IsCastable() and UseFlameShock then
    if Press(S.FlameShock,not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock single 66"; end
  end
  -- windfury_totem,if=buff.windfury_totem.remains<30
  if S.WindfuryTotem:IsReady() and UseWindfuryTotem and (Player:BuffDown(S.WindfuryTotemBuff, true) or S.WindfuryTotem:TimeSinceLastCast() > 90) then
    if Press(S.WindfuryTotem) then return "windfury_totem single 68"; end
  end
end

local function Aoe()
  -- crash_lightning,if=buff.doom_winds_talent.up|!buff.crash_lightning.up
  if S.CrashLightning:IsReady() and UseCrashLightning and (Player:BuffUp(S.DoomWindsBuff) or Player:BuffDown(S.CrashLightningBuff)) then
    if Press(S.CrashLightning,not Target:IsInRange(8)) then return "crash_lightning aoe 2"; end
  end
  -- lightning_bolt,if=(active_dot.flame_shock=active_enemies|active_dot.flame_shock=6)&buff.primordial_wave.up&buff.maelstrom_weapon.stack>=(5+5*talent.overflowing_maelstrom.enabled)&(!buff.splintered_elements.up|fight_remains<=12|raid_event.adds.remains<=gcd)
  if S.LightningBolt:IsReady() and UseLightningBolt and ((S.FlameShockDebuff:AuraActiveCount() == Enemies10yCount or S.FlameShockDebuff:AuraActiveCount() >= 6) and Player:BuffUp(S.PrimordialWaveBuff) and Player:BuffStack(S.MaelstromWeaponBuff) >= (5 + 5 * num(S.OverflowingMaelstrom:IsAvailable())) and (Player:BuffDown(S.SplinteredElementsBuff) or FightRemains <= 12)) then
    if Press(S.LightningBolt,not Target:IsSpellInRange(S.LightningBolt)) then return "lightning_bolt aoe 4"; end
  end
  -- sundering,if=buff.doom_winds_talent.up
  if S.Sundering:IsReady() and UseSundering and ((SunderingWithMiniCD and MiniCDs) or not SunderingWithMiniCD) and FightRemainsCheck < FightRemains and (Player:BuffUp(S.DoomWindsBuff)) then
    if Press(S.Sundering,not Target:IsInRange(11)) then return "sundering aoe 8"; end
  end
  -- fire_nova,if=active_dot.flame_shock=6|(active_dot.flame_shock>=4&active_dot.flame_shock=active_enemies)
  if S.FireNova:IsReady() and UseFireNova and (S.FlameShockDebuff:AuraActiveCount() == 6 or (S.FlameShockDebuff:AuraActiveCount() >= 4 and S.FlameShockDebuff:AuraActiveCount() >= Enemies10yCount)) then
    if Press(S.FireNova) then return "fire_nova aoe 10"; end
  end
  -- primordial_wave,target_if=min:dot.flame_shock.remains,cycle_targets=1,if=!buff.primordial_wave.up
  if S.PrimordialWave:IsReady() and CycleThroughEnemies and ((PrimordialWaveWithMiniCD and MiniCDs) or not PrimordialWaveWithMiniCD) and UsePrimordialWave and FightRemainsCheck < FightRemains and (Player:BuffDown(S.PrimordialWaveBuff)) then
    if Everyone.CastTargetIf(S.PrimordialWave, Enemies40y, "min", EvaluateTargetIfFilterPrimordialWave, EvaluateTargetIfPrimordialWave, not Target:IsSpellInRange(S.PrimordialWave), nil, nil) then return "primordial_wave aoe 12"; end
  end
  -- windstrike,if=talent.thorims_invocation.enabled&ti_chain_lightning&buff.maelstrom_weapon.stack>1
  if S.Windstrike:IsReady() and UseWindstrike and (S.ThorimsInvocation:IsAvailable() and TIAction == S.ChainLightning and Player:BuffStack(S.MaelstromWeaponBuff) > 1) then
    if Press(S.Windstrike,not Target:IsSpellInRange(S.Windstrike)) then return "windstrike aoe 14"; end
  end
  -- lava_lash,target_if=min:debuff.lashing_flames.remains,cycle_targets=1,if=talent.lashing_flames.enabled&dot.flame_shock.ticking&(active_dot.flame_shock<active_enemies)&active_dot.flame_shock<6
  if S.LavaLash:IsReady() and CycleThroughEnemies and UseLavaLash and (S.LashingFlames:IsAvailable()) then
    if Everyone.CastTargetIf(S.LavaLash, Enemies10y, "min", EvaluateTargetIfFilterLavaLash, EvaluateTargetIfLavaLash2, not Target:IsSpellInRange(S.LavaLash)) then return "lava_lash aoe 16"; end
  end
  -- lava_lash,if=talent.molten_assault.enabled&dot.flame_shock.ticking&(active_dot.flame_shock<active_enemies)&active_dot.flame_shock<6
  if S.LavaLash:IsReady() and UseLavaLash and (S.MoltenAssault:IsAvailable() and Target:DebuffUp(S.FlameShockDebuff) and (S.FlameShockDebuff:AuraActiveCount() < Enemies10yCount) and S.FlameShockDebuff:AuraActiveCount() < 6) then
    if Press(S.LavaLash,not Target:IsSpellInRange(S.LavaLash)) then return "lava_lash aoe 17"; end
  end
  -- flame_shock,if=!ticking
  if S.FlameShock:IsReady() and UseFlameShock and (Target:DebuffDown(S.FlameShockDebuff)) then
    if Press(S.FlameShock,not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 18"; end
  end
  -- flame_shock,target_if=min:dot.flame_shock.remains,cycle_targets=1,if=talent.fire_nova.enabled&(active_dot.flame_shock<active_enemies)&active_dot.flame_shock<6
  if S.FlameShock:IsReady() and UseFlameShock and CycleThroughEnemies and (S.FireNova:IsAvailable() and S.FlameShockDebuff:AuraActiveCount() < Enemies10yCount and S.FlameShockDebuff:AuraActiveCount() < 6) then
    if Everyone.CastCycle(S.FlameShock, Enemies40y, EvaluateCycleFlameShock, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 20"; end
  end
  -- ice_strike,if=talent.hailstorm.enabled
  if S.IceStrike:IsReady() and UseIceStrike and (S.Hailstorm:IsAvailable()) then
    if Press(S.IceStrike,not Target:IsInMeleeRange(5)) then return "ice_strike aoe 22"; end
  end
  -- frost_shock,if=talent.hailstorm.enabled&buff.hailstorm.up
  if S.FrostShock:IsReady() and UseFrostShock and (S.Hailstorm:IsAvailable() and Player:BuffUp(S.HailstormBuff)) then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock aoe 24"; end
  end
  -- sundering
  if S.Sundering:IsReady() and UseSundering and ((SunderingWithMiniCD and MiniCDs) or not SunderingWithMiniCD) and FightRemainsCheck < FightRemains then
    if Press(S.Sundering,not Target:IsInRange(11)) then return "sundering aoe 26"; end
  end
  -- fire_nova,if=active_dot.flame_shock>=4
  if S.FireNova:IsReady() and UseFireNova and (S.FlameShockDebuff:AuraActiveCount() >= 4) then
    if Press(S.FireNova) then return "fire_nova aoe 28"; end
  end
  -- lava_lash,target_if=min:debuff.lashing_flames.remains,cycle_targets=1,if=talent.lashing_flames.enabled
  if S.LavaLash:IsReady() and CycleThroughEnemies and UseLavaLash and (S.LashingFlames:IsAvailable()) then
    if Everyone.CastTargetIf(S.LavaLash, Enemies10y, "min", EvaluateTargetIfFilterLavaLash, EvaluateTargetIfLavaLash, not Target:IsSpellInRange(S.LavaLash)) then return "lava_lash aoe 32"; end
  end
  -- fire_nova,if=active_dot.flame_shock>=3
  if S.FireNova:IsReady() and UseFireNova and (S.FlameShockDebuff:AuraActiveCount() >= 3) then
    if Press(S.FireNova) then return "fire_nova aoe 34"; end
  end
  -- elemental_blast,if=(!talent.elemental_spirits.enabled|(talent.elemental_spirits.enabled&(charges=max_charges|buff.feral_spirit.up)))&buff.maelstrom_weapon.stack=10&(!talent.crashing_storms.enabled|active_enemies<=3)
  if S.ElementalBlast:IsReady() and UseElementalBlast and (((not S.ElementalSpirits:IsAvailable()) or (S.ElementalSpirits:IsAvailable() and (S.ElementalBlast:Charges() == MaxEBCharges or Player:BuffUp(S.FeralSpiritBuff)))) and Player:BuffStack(S.MaelstromWeaponBuff) == 10 and ((not S.CrashingStorms) or Enemies10yCount <= 3)) then
    if Press(S.ElementalBlast,not Target:IsSpellInRange(S.ElementalBlast)) then return "elemental_blast aoe 36"; end
  end
  -- chain_lightning,if=buff.maelstrom_weapon.stack=10
  if S.ChainLightning:IsReady() and UseChainlightning and (Player:BuffStack(S.MaelstromWeaponBuff) == 10) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning aoe 38"; end
  end
  -- crash_lightning,if=buff.cl_crash_lightning.up
  if S.CrashLightning:IsReady() and UseCrashLightning and (Player:BuffUp(S.CLCrashLightningBuff)) then
    if Press(S.CrashLightning,not Target:IsInMeleeRange(5)) then return "crash_lightning aoe 40"; end
  end
  if Player:BuffUp(S.CrashLightningBuff) then
    -- lava_lash,if=buff.crash_lightning.up&buff.ashen_catalyst.stack=8
    if S.LavaLash:IsReady() and UseLavaLash and (Player:BuffStack(S.AshenCatalystBuff) == 8) then
      if Press(S.LavaLash,not Target:IsInMeleeRange(5)) then return "lava_lash aoe 42"; end
    end
    -- windstrike,if=buff.crash_lightning.up
    if S.Windstrike:IsReady() and UseWindstrike then
      if Press(S.Windstrike,not Target:IsSpellInRange(S.Windstrike)) then return "windstrike aoe 44"; end
    end
    -- stormstrike,if=buff.crash_lightning.up&(buff.converging_storms.stack=6|(set_bonus.tier29_2pc&buff.maelstrom_of_elements.down&buff.maelstrom_weapon.stack<=5))
    if S.Stormstrike:IsReady() and UseStormStrike and (Player:BuffStack(S.ConvergingStorms) == 6 or (Player:HasTier(29, 2) and Player:BuffDown(S.MaelstromofElementsBuff) and Player:BuffStack(S.MaelstromWeaponBuff) <= 5)) then
      if Press(S.Stormstrike,not Target:IsInMeleeRange(5)) then return "stormstrike aoe 46"; end
    end
    -- lava_lash,if=buff.crash_lightning.up,if=talent.molten_assault.enabled
    if S.LavaLash:IsReady() and UseLavaLash and (S.MoltenAssault:IsAvailable()) then
      if Press(S.LavaLash,not Target:IsInMeleeRange(5)) then return "lava_lash aoe 48"; end
    end
    -- ice_strike,if=buff.crash_lightning.up,if=talent.swirling_maelstrom.enabled
    if S.IceStrike:IsReady() and UseIceStrike and (S.SwirlingMaelstrom:IsAvailable()) then
      if Press(S.IceStrike,not Target:IsInMeleeRange(5)) then return "ice_strike aoe 50"; end
    end
    -- stormstrike,if=buff.crash_lightning.up
    if S.Stormstrike:IsReady() and UseStormStrike then
      if Press(S.Stormstrike,not Target:IsInMeleeRange(5)) then return "stormstrike aoe 52"; end
    end
    -- ice_strike,if=buff.crash_lightning.up
    if S.IceStrike:IsReady() and UseIceStrike then
      if Press(S.IceStrike,not Target:IsInMeleeRange(5)) then return "ice_strike aoe 50"; end
    end
    -- lava_lash,if=buff.crash_lightning.up
    if S.LavaLash:IsReady() and UseLavaLash then
      if Press(S.LavaLash,not Target:IsInMeleeRange(5)) then return "lava_lash aoe 48"; end
    end
  end
  -- elemental_blast,if=(!talent.elemental_spirits.enabled|(talent.elemental_spirits.enabled&(charges=max_charges|buff.feral_spirit.up)))&buff.maelstrom_weapon.stack>=5&(!talent.crashing_storms.enabled|active_enemies<=3)
  if S.ElementalBlast:IsReady() and UseElementalBlast and (((not S.ElementalSpirits:IsAvailable()) or (S.ElementalSpirits:IsAvailable() and (S.ElementalBlast:Charges() == MaxEBCharges or Player:BuffUp(S.FeralSpiritBuff)))) and Player:BuffStack(S.MaelstromWeaponBuff) >= 5 and ((not S.CrashingStorms:IsAvailable()) or Enemies10yCount <= 3)) then
    if Press(S.ElementalBlast,not Target:IsSpellInRange(S.ElementalBlast)) then return "elemental_blast aoe 54"; end
  end
  -- fire_nova,if=active_dot.flame_shock>=2
  if S.FireNova:IsReady() and UseFireNova and (S.FlameShockDebuff:AuraActiveCount() >= 2) then
    if Press(S.FireNova) then return "fire_nova aoe 56"; end
  end
  -- crash_lightning
  if S.CrashLightning:IsReady() and UseCrashLightning then
    if Press(S.CrashLightning,not Target:IsInRange(8)) then return "crash_lightning aoe 58"; end
  end
  -- windstrike
  if S.Windstrike:IsReady() and UseWindstrike then
    if Press(S.Windstrike,not Target:IsSpellInRange(S.Windstrike)) then return "windstrike aoe 60"; end
  end
  -- lava_lash,if=talent.molten_assault.enabled
  if S.LavaLash:IsReady() and UseLavaLash and (S.MoltenAssault:IsAvailable()) then
    if Press(S.LavaLash,not Target:IsInMeleeRange(5)) then return "lava_lash aoe 62"; end
  end
  -- ice_strike,if=talent.swirling_maelstrom.enabled
  if S.IceStrike:IsReady() and UseIceStrike and (S.SwirlingMaelstrom:IsAvailable()) then
    if Press(S.IceStrike,not Target:IsInMeleeRange(5)) then return "ice_strike aoe 64"; end
  end
  -- stormstrike
  if S.Stormstrike:IsReady() and UseStormStrike then
    if Press(S.Stormstrike,not Target:IsSpellInRange(S.Stormstrike)) then return "stormstrike aoe 66"; end
  end
  -- ice_strike
  if S.IceStrike:IsReady() and UseIceStrike then
    if Press(S.IceStrike,not Target:IsInMeleeRange(5)) then return "ice_strike aoe 64"; end
  end
  -- lava_lash
  if S.LavaLash:IsReady() and UseLavaLash then
    if Press(S.LavaLash,not Target:IsInMeleeRange(5)) then return "lava_lash aoe 48"; end
  end
  -- flame_shock,target_if=refreshable,cycle_targets=1
  if S.FlameShock:IsReady() and UseFlameShock and CycleThroughEnemies then
    if Everyone.CastCycle(S.FlameShock, Enemies40y, EvaluateCycleFlameShock, not Target:IsSpellInRange(S.FlameShock)) then return "flame_shock aoe 68"; end
  end
  -- frost_shock
  if S.FrostShock:IsReady() and UseFrostShock then
    if Press(S.FrostShock,not Target:IsSpellInRange(S.FrostShock)) then return "frost_shock aoe 70"; end
  end
  -- chain_lightning,if=buff.maelstrom_weapon.stack>=5
  if S.ChainLightning:IsReady() and UseChainlightning and (Player:BuffStack(S.MaelstromWeaponBuff) >= 5) then
    if Press(S.ChainLightning,not Target:IsSpellInRange(S.ChainLightning)) then return "chain_lightning aoe 72"; end
  end
  -- earth_elemental
  if S.EarthElemental:IsCastable() and UseEarthElemental then
    if Press(S.EarthElemental) then return "earth_elemental aoe 74"; end
  end
  -- windfury_totem,if=buff.windfury_totem.remains<30
  if S.WindfuryTotem:IsReady() and UseWindfuryTotem and (Player:BuffDown(S.WindfuryTotemBuff, true) or S.WindfuryTotem:TimeSinceLastCast() > 90) then
    if Press(S.WindfuryTotem) then return "windfury_totem aoe 76"; end
  end
end

local function OutOfCombat()
  -- Moved from Precombat: lightning_shield
  -- Manually added: earth_shield if available and PreferEarthShield setting is true
  if AutoShield and ShieldUse == "Earth Shield" and S.EarthShield:IsReady() and (Player:BuffDown(S.EarthShield) or (not Player:AffectingCombat() and Player:BuffStack(S.EarthShield) < 5)) then
    if Press(S.EarthShield) then return "earth_shield main 2"; end
  elseif AutoShield and S.LightningShield:IsReady() and Player:BuffDown(S.LightningShield) and (ShieldUse == "Earth Shield" and Player:BuffDown(S.EarthShield) or ShieldUse == "Lightning Shield") then
    if Press(S.LightningShield) then return "lightning_shield main 2"; end
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
    if Player:BuffStack(S.MaelstromWeaponBuff) >= 5 and UseMaelstromHealingSurgeWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.HealingSurge, M.HealingSurgeMouseover, 40, true); if ShouldReturn then return ShouldReturn; end
    end
  end

  -- heal
  if UseHealOOC then
    ShouldReturn = HealOOC(); if ShouldReturn then return ShouldReturn; end
  end

  -- resurrection
  if Target and Target:Exists() and Target:IsAPlayer() and Target:IsDeadOrGhost() and (not Player:CanAttack(Target)) then
    if Press(S.AncestralSpirit, nil, true) then return "resurrection"; end
  end

  if Everyone.TargetIsValid() and OOC then
    -- Precombat
    if not Player:AffectingCombat() then
      local ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
    end
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
    if Player:BuffStack(S.MaelstromWeaponBuff) >= 5 and UseMaelstromHealingSurgeWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.HealingSurge, M.HealingSurgeMouseover, 40, true); if ShouldReturn then return ShouldReturn; end
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

  -- heal
  ShouldReturn = HealCombat(); if ShouldReturn then return ShouldReturn; end

  if Everyone.TargetIsValid() then
    -- bloodlust
    -- Not adding this, as when to use Bloodlust will vary fight to fight
    -- potion,if=(talent.ascendance.enabled&raid_event.adds.in>=90&cooldown.ascendance.remains<10)|(talent.hot_hand.enabled&buff.molten_weapon.up)|buff.icy_edge.up|(talent.stormflurry.enabled&buff.crackling_surge.up)|active_enemies>1|fight_remains<30
    local ShouldReturnPot = Everyone.HandleDPSPotion(Player:BuffUp(S.FeralSpiritBuff)); if ShouldReturnPot then return ShouldReturnPot; end
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
    -- auto_attack

    -- trinkets
    if FightRemainsCheck < FightRemains then
      if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) then
        ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
      end
    end

    if FightRemainsCheck < FightRemains and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) then
      -- blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
      if S.BloodFury:IsCastable() and (not S.Ascendance:IsAvailable() or Player:BuffUp(S.AscendanceBuff) or S.Ascendance:CooldownRemains() > 50) then
        if Press(S.BloodFury) then return "blood_fury racial"; end
      end
      -- berserking,if=!talent.ascendance.enabled|buff.ascendance.up
      if S.Berserking:IsCastable() and (not S.Ascendance:IsAvailable() or Player:BuffUp(S.AscendanceBuff)) then
        if Press(S.Berserking) then return "berserking racial"; end
      end
      -- fireblood,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
      if S.Fireblood:IsCastable() and (not S.Ascendance:IsAvailable() or Player:BuffUp(S.AscendanceBuff) or S.Ascendance:CooldownRemains() > 50) then
        if Press(S.Fireblood) then return "fireblood racial"; end
      end
      -- ancestral_call,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
      if S.AncestralCall:IsCastable() and (not S.Ascendance:IsAvailable() or Player:BuffUp(S.AscendanceBuff) or S.Ascendance:CooldownRemains() > 50) then
        if Press(S.AncestralCall) then return "ancestral_call racial"; end
      end
    end
    -- feral_spirit
    if S.FeralSpirit:IsCastable() and UseFeralSpirit and ((FeralSpiritWithCD and CDs) or not FeralSpiritWithCD) and FightRemainsCheck < FightRemains then
      if Press(S.FeralSpirit) then return "feral_spirit main 12"; end
    end
    -- ascendance,if=(ti_lightning_bolt&active_enemies=1&raid_event.adds.in>=90)|(ti_chain_lightning&active_enemies>1)
    if S.Ascendance:IsCastable() and UseAscendance and ((AscendanceWithCD and CDs) or not AscendanceWithCD) and FightRemainsCheck < FightRemains and (TIAction == S.LightningBolt and Enemies10yCount == 1 or TIAction == S.ChainLightning and Enemies10yCount > 1) then
      if Press(S.Ascendance) then return "ascendance main 18"; end
    end
    -- doom_winds,if=raid_event.adds.in>=90|active_enemies>1
    if S.DoomWinds:IsCastable() and UseDoomWinds and ((DoomWindsWithCD and CDs) or not DoomWindsWithCD) and FightRemainsCheck < FightRemains then
      if Press(S.DoomWinds,not Target:IsInMeleeRange(5)) then return "doom_winds main 20"; end
    end
    -- call_action_list,name=single,if=active_enemies=1
    if Enemies10yCount == 1 then
      local ShouldReturn = Single(); if ShouldReturn then return ShouldReturn; end
    end
    -- call_action_list,name=aoe,if=active_enemies>1
    if AOE and Enemies10yCount > 1 then
      local ShouldReturn = Aoe(); if ShouldReturn then return ShouldReturn; end
    end
    -- If nothing else to do, show the Pool icon
    if ER.CastAnnotated(S.Pool, false, "WAIT") then return "Wait/Pool Resources"; end
  end
end


local function FetchUseSettings()
  --General Use
  UseAscendance = EpicSettings.Settings["useAscendance"]
  UseDoomWinds = EpicSettings.Settings["useDoomWinds"]
  UseFeralSpirit = EpicSettings.Settings["useFeralSpirit"]

  UseChainlightning = EpicSettings.Settings["useChainlightning"]
  UseCrashLightning = EpicSettings.Settings["useCrashLightning"]
  UseEarthElemental = EpicSettings.Settings["useEarthElemental"]
  UseElementalBlast = EpicSettings.Settings["useElementalBlast"]
  UseFireNova = EpicSettings.Settings["useFireNova"]
  UseFlameShock = EpicSettings.Settings["useFlameShock"]
  UseFrostShock = EpicSettings.Settings["useFrostShock"]
  UseIceStrike = EpicSettings.Settings["useIceStrike"]
  UseLavaBurst = EpicSettings.Settings["useLavaBurst"]
  UseLavaLash = EpicSettings.Settings["useLavaLash"]
  UseLightningBolt = EpicSettings.Settings["useLightningBolt"]
  UsePrimordialWave = EpicSettings.Settings["usePrimordialWave"]
  UseStormStrike = EpicSettings.Settings["useStormStrike"]
  UseSundering = EpicSettings.Settings["useSundering"]
  UseWindstrike = EpicSettings.Settings["useWindstrike"]
  UseWindfuryTotem = EpicSettings.Settings["useWindfuryTotem"]

  UseWeaponEnchant = EpicSettings.Settings["useWeaponEnchant"]

  --SaveWithCD Settings
  AscendanceWithCD = EpicSettings.Settings["ascendanceWithCD"]
  DoomWindsWithCD = EpicSettings.Settings["doomWindsWithCD"]
  FeralSpiritWithCD = EpicSettings.Settings["feralSpiritWithCD"]

  --SaveWithMiniCD Settings
  PrimordialWaveWithMiniCD = EpicSettings.Settings["primordialWaveWithMiniCD"]
  SunderingWithMiniCD = EpicSettings.Settings["sunderingWithMiniCD"]
end

local function FetchSettings()
  --Interrupt Use Settings
  UseWindShear = EpicSettings.Settings["useWindShear"]
  UseCapacitorTotem = EpicSettings.Settings["useCapacitorTotem"]
  UseThunderstorm = EpicSettings.Settings["useThunderstorm"]

  --Defensive Use Settings
  UseAncestralGuidance = EpicSettings.Settings["useAncestralGuidance"]
  UseAstralShift = EpicSettings.Settings["useAstralShift"]
  UseMaelstromHealingSurge = EpicSettings.Settings["useMaelstromHealingSurge"]
  UseHealingStreamTotem = EpicSettings.Settings["useHealingStreamTotem"]

  --Defensive HP Settings
  AncestralGuidanceHP = EpicSettings.Settings["ancestralGuidanceHP"] or 0
  AncestralGuidanceGroup = EpicSettings.Settings["ancestralGuidanceGroup"] or 0
  AstralShiftHP = EpicSettings.Settings["astralShiftHP"] or 0
  HealingStreamTotemHP = EpicSettings.Settings["healingStreamTotemHP"] or 0
  HealingStreamTotemGroup = EpicSettings.Settings["healingStreamTotemGroup"] or 0
  MaelstromHealingSurgeCriticalHP = EpicSettings.Settings["maelstromHealingSurgeCriticalHP"] or 0
  
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
  UseMaelstromHealingSurgeWithAfflicted = EpicSettings.Settings["useMaelstromHealingSurgeWithAfflicted"]
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

  -- Check weapon enchants
  HasMainHandEnchant, MHEnchantTimeRemains, _, _, HasOffHandEnchant, OHEnchantTimeRemains = GetWeaponEnchantInfo()

  -- Unit Update
  if AOE then
    Enemies40y = Player:GetEnemiesInRange(40)
    Enemies40yCount = #Enemies40y
    Enemies10y = Player:GetEnemiesInMeleeRange(10)
    Enemies10yCount = #Enemies10y
  else
    Enemies40y = {}
    Enemies40yCount = 1
    Enemies10y = {}
    Enemies10yCount = 1
  end

  --Focus and Dispell
  if Player:AffectingCombat() or DispelDebuffs then
    local includeDispellableUnits = DispelDebuffs and S.CleanseSpirit:IsReady() and DispelToggle
    ShouldReturn = Everyone.FocusUnit(includeDispellableUnits, nil, nil, nil); if ShouldReturn then return ShouldReturn; end
  end

  -- Calculate fight_remains
  if Everyone.TargetIsValid() or Player:AffectingCombat() then
    -- Calculate fight_remains
    BossFightRemains = EL.BossFightRemains(nil, true)
    FightRemains = BossFightRemains
    if FightRemains == 11111 then
      FightRemains = EL.FightRemains(Enemies10y, false)
    end
  end

  -- Update Thorim's Invocation
  if Player:AffectingCombat() and Player:BuffUp(S.AscendanceBuff) then
    if Player:PrevGCD(1, S.ChainLightning) then
      TIAction = S.ChainLightning
    elseif Player:PrevGCD(1, S.LightningBolt) then
      TIAction = S.LightningBolt
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
  ER.Print("Enhancement Shaman by Epic. Supported by xKaneto.")
end


ER.SetAPL(263, APL, Init)
