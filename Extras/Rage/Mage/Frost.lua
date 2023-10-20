--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- EpicDBC
local DBC = EpicDBC.DBC
-- EpicLib
local EL         = EpicLib
local Cache      = EpicCache
local Unit       = EL.Unit
local Player     = Unit.Player
local Target     = Unit.Target
local Focus      = Unit.Focus
local Mouseover  = Unit.MouseOver
local Pet        = Unit.Pet
local Spell      = EL.Spell
local MultiSpell = EL.MultiSpell
local Item       = EL.Item
-- EpicLib
local ER         = EpicLib
local Cast       = ER.Cast
local Press      = ER.Press
local PressCursor = ER.PressCursor
local Macro      = ER.Macro
local Bind       = ER.Bind

-- Num/Bool Helper Functions
local num        = ER.Commons.Everyone.num
local bool       = ER.Commons.Everyone.bool
-- lua
local max        = math.max

--- ============================ CONTENT ===========================

local ShouldReturn

-- Toggles
local OOC = false;
local AOE = false;
local CDs = false;
local Kick = false;
local DispelToggle = false;

--Settings Use
local UseArcaneExplosion
local UseArcaneIntellect
local UseBlizzard
local UseDragonsBreath
local UseFireBlast
local UseFrostbolt
local UseFrostNova
local UseFlurry
local UseFreezePet
local UseGlacialSpike
local UseIceFloes
local UseIceLance
local UseIceNova
local UseRayOfFrost

--Settings Use Interrupts
local UseCounterspell
local UseBlastWave

--Settings Use With CD
local UseIcyVeins
local UseFrozenOrb
local UseCometStorm
local UseConeOfCold
local UseShiftingPower

--Settings WithCDs
local IcyVeinsWithCD
local FrozenOrbWithCD
local CometStormWithCD
local ConeOfColdWithCD
local ShiftingPowerWithCD

--Settings UseDefensives
local UseAlterTime
local UseIceBarrier
local UseGreaterInvisibility
local UseIceBlock
local UseMassBarrier
local UseMirrorImage

--Settings DefensiveHP
local AlterTimeHP
local IceBarrierHP
local GreaterInvisibilityHP
local IceBlockHP
local MirrorImageHP

--Extras
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

local UseRacials
local UseTrinkets
local TrinketsWithCD
local RacialsWithCD

local UseSpellStealTarget
local UseSpellsWhileMoving
local UseTimeWarpWithTalent

--Afflicted
local UseRemoveCurseWithAfflicted

--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Define S/I for spell and item arrays
local S = Spell.Mage.Frost
local I = Item.Mage.Frost
local M = Macro.Mage.Frost

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
}

-- Rotation Var
local EnemiesCount8ySplash, EnemiesCount16ySplash --Enemies arround target
local EnemiesCount15yMelee  --Enemies arround player
local Enemies16ySplash
local RemainingWintersChill = 0
local var_snowstorm_max_stack = 15
local BossFightRemains = 11111
local FightRemains = 11111
local GCDMax

-- GUI Settings
local Everyone = ER.Commons.Everyone
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.Mage.Commons,
--  Frost = ER.GUISettings.APL.Mage.Frost
--}

local function FillDispels()
  if S.RemoveCurse:IsAvailable() then
    Everyone.DispellableDebuffs = Everyone.DispellableCurseDebuffs
  end
end

EL:RegisterForEvent(function()
  FillDispels()
end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");

S.FrozenOrb:RegisterInFlightEffect(84721)
S.FrozenOrb:RegisterInFlight()
EL:RegisterForEvent(function() S.FrozenOrb:RegisterInFlight() end, "LEARNED_SPELL_IN_TAB")
S.Frostbolt:RegisterInFlightEffect(228597)--also register hitting spell to track in flight (spell book id ~= hitting id)
S.Frostbolt:RegisterInFlight()
S.Flurry:RegisterInFlightEffect(228354)
S.Flurry:RegisterInFlight()
S.IceLance:RegisterInFlightEffect(228598)
S.IceLance:RegisterInFlight()

EL:RegisterForEvent(function()
  BossFightRemains = 11111
  FightRemains = 11111
  RemainingWintersChill = 0
end, "PLAYER_REGEN_ENABLED")

local function Freezable(Tar)
  if Tar == nil then Tar = Target end
  return (not Tar:IsInBossList() or Tar:Level() < 73)
end

local function FrozenRemains()
  return max(Player:BuffRemains(S.FingersofFrostBuff), Target:DebuffRemains(S.WintersChillDebuff), Target:DebuffRemains(S.Frostbite), Target:DebuffRemains(S.Freeze), Target:DebuffRemains(S.FrostNova))
end

local function Defensive()
  -- Ice Barrier
  if S.IceBarrier:IsReady() and UseIceBarrier and Player:BuffDown(S.IceBarrier) and not S.MassBarrier:IsReady() and Player:HealthPercentage() <= IceBarrierHP then
    if Press(S.IceBarrier) then return "ice_barrier defensive 1"; end
  end

  -- Mass Barrier
  if S.MassBarrier:IsReady() and UseMassBarrier and (Player:IsInParty() or Player:IsInRaid()) then
    if Press(S.MassBarrier) then return "mass_barrier defensive 2"; end
  end

  -- Ice Block
  if S.IceBlock:IsReady() and UseIceBlock and Player:HealthPercentage() <= IceBlockHP then
    if Press(S.IceBlock) then return "ice_block defensive 3"; end
  end

  -- Mirror Image
  if S.MirrorImage:IsCastable() and UseMirrorImage and Player:HealthPercentage() <= MirrorImageHP then
    if Press(S.MirrorImage) then return "mirror_image defensive 4"; end
  end

  -- Greater Invisibility
  if S.GreaterInvisibility:IsReady() and UseGreaterInvisibility and Player:HealthPercentage() <= GreaterInvisibilityHP then
    if Press(S.GreaterInvisibility) then return "greater_invisibility defensive 5"; end
  end

  -- Alter Time
  if S.AlterTime:IsReady() and UseAlterTime and Player:HealthPercentage() <= AlterTimeHP then
    if Press(S.AlterTime) then return "alter_time defensive 6"; end
  end

  -- healthstone
  if I.Healthstone:IsReady() and UseHealthstone and Player:HealthPercentage() <= HealthstoneHP then
    if Press(M.Healthstone) then return "healthstone defensive"; end
  end

  -- HealingPot
  if UseHealingPotion and Player:HealthPercentage() <= HealingPotionHP then
    if HealingPotionName == "Refreshing Healing Potion" then
      if I.RefreshingHealingPotion:IsReady() then
        if Press(M.RefreshingHealingPotion) then return "refreshing healing potion defensive"; end
      end
    end
  end
end

local function Dispel()
  -- Remove Curse
  if S.RemoveCurse:IsReady() and DispelToggle and Everyone.DispellableFriendlyUnit() then
    if Press(M.RemoveCurseFocus) then return "remove_curse dispel"; end
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
  if Everyone.TargetIsValid() then
    -- ice_barrier
    if S.IceBarrier:IsCastable() then
      if Press(S.IceBarrier) then return "IceBarrier"; end
    end
    -- blizzard,if=active_enemies>=2
    -- Note: Can't check active_enemies in Precombat
    -- TODO precombat active_enemies
    -- frostbolt,if=active_enemies=1
    if S.Frostbolt:IsCastable() and not Player:IsCasting(S.Frostbolt) then
      if Press(S.Frostbolt, not Target:IsSpellInRange(S.Frostbolt)) then return "frostbolt"; end
    end
  end
end

local function Cooldowns()
  -- time_warp,if=buff.exhaustion.up&talent.temporal_warp&buff.bloodlust.down&prev_off_gcd.icy_veins
  -- Note: Keeping this as TemporalWarp time_warp, as we won't suggest time_warp otherwise.
  if UseTimeWarpWithTalent and S.TimeWarp:IsCastable() and (Player:BloodlustExhaustUp() and S.TemporalWarp:IsAvailable() and Player:BloodlustDown() and Player:PrevGCDP(1, S.IcyVeins)) then
    if Press(S.TimeWarp) then return "time_warp cd 2"; end
  end
  -- potion,if=prev_off_gcd.icy_veins|fight_remains<60
  local ShouldReturnPot = Everyone.HandleDPSPotion(Player:BuffUp(S.IcyVeinsBuff)); if ShouldReturnPot then return ShouldReturnPot; end

  -- icy_veins
  if S.IcyVeins:IsCastable() and CDs and UseIcyVeins and IcyVeinsWithCD and FightRemainsCheck < FightRemains then
    if Press(S.IcyVeins) then return "icy_veins cd 6"; end
  end
  -- use_items
  -- trinkets
  if FightRemainsCheck < FightRemains then
    if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) then
      ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
    end
  end
  -- invoke_external_buff,name=power_infusion,if=buff.power_infusion.down
  -- invoke_external_buff,name=blessing_of_summer,if=buff.blessing_of_summer.down
  -- Note: Not handling external buffs.
  -- blood_fury
  if UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) and FightRemainsCheck < FightRemains then 
    if S.BloodFury:IsCastable() then
      if Press(S.BloodFury) then return "blood_fury cd 10"; end
    end
    -- berserking
    if S.Berserking:IsCastable() then
      if Press(S.Berserking) then return "berserking cd 12"; end
    end
    -- lights_judgment
    if S.LightsJudgment:IsCastable() then
      if Press(S.LightsJudgment, not Target:IsSpellInRange(S.LightsJudgment)) then return "lights_judgment cd 14"; end
    end
    -- fireblood
    if S.Fireblood:IsCastable() then
      if Press(S.Fireblood) then return "fireblood cd 16"; end
    end
    -- ancestral_call
    if S.AncestralCall:IsCastable() then
      if Press(S.AncestralCall) then return "ancestral_call cd 18"; end
    end
  end
end

local function Movement()
  -- ice_floes,if=buff.ice_floes.down
  if S.IceFloes:IsCastable() and UseIceFloes and Player:BuffDown(S.IceFloes) then
    if Press(S.IceFloes) then return "ice_floes movement"; end
  end
  -- ice_nova
  if S.IceNova:IsCastable() and UseIceNova then
    if Press(S.IceNova, not Target:IsSpellInRange(S.IceNova)) then return "ice_nova movement"; end
  end
  -- arcane_explosion,if=mana.pct>30&active_enemies>=2
  if S.ArcaneExplosion:IsCastable() and UseArcaneExplosion and (Player:ManaPercentage() > 30 and EnemiesCount16ySplash >= 2) then
    if Press(S.ArcaneExplosion, not Target:IsInRange(10)) then return "arcane_explosion movement"; end
  end
  -- fire_blast
  if S.FireBlast:IsCastable() and UseFireblast then
    if Press(S.FireBlast, not Target:IsSpellInRange(S.FireBlast)) then return "fire_blast movement"; end
  end
  -- ice_lance
  if S.IceLance:IsCastable() and UseIceLance then
    if Press(S.IceLance, not Target:IsSpellInRange(S.IceLance)) then return "ice_lance movement"; end
  end
end

local function Aoe()
  -- cone_of_cold,if=talent.coldest_snap&(prev_gcd.1.comet_storm|prev_gcd.1.frozen_orb&!talent.comet_storm)
  if S.ConeofCold:IsCastable() and UseConeOfCold and ((ConeOfColdWithCD and CDs) or not ConeOfColdWithCD) and FightRemainsCheck < FightRemains and (S.ColdestSnap:IsAvailable() and (Player:PrevGCDP(1, S.CometStorm) or Player:PrevGCDP(1, S.FrozenOrb) and not S.CometStorm:IsAvailable())) then
    if Press(S.ConeofCold, not Target:IsInRange(12)) then return "cone_of_cold aoe 2"; end
  end
  -- frozen_orb
  if S.FrozenOrb:IsCastable() and ((FrozenOrbWithCD and CDs) or not FrozenOrbWithCD) and UseFrozenOrb and FightRemainsCheck < FightRemains and (not Player:PrevGCDP(1, S.GlacialSpike) or not Freezable()) then
    if Press(S.FrozenOrb, not Target:IsInRange(40)) then return "frozen_orb aoe 4"; end
  end
  -- blizzard
  if S.Blizzard:IsCastable() and UseBlizzard and (not Player:PrevGCDP(1, S.GlacialSpike) or not Freezable()) then
    if Press(M.BlizzardCursor, not Target:IsInRange(40)) then return "blizzard aoe 6"; end
  end
  -- comet_storm
  if S.CometStorm:IsCastable() and ((CometStormWithCD and CDs) or not CometStormWithCD) and UseCometStorm  and FightRemainsCheck < FightRemains and (not Player:PrevGCDP(1, S.GlacialSpike) and (not S.ColdestSnap:IsAvailable() or S.ConeofCold:CooldownUp() and S.FrozenOrb:CooldownRemains() > 25 or S.ConeofCold:CooldownRemains() > 20))then
    if Press(S.CometStorm, not Target:IsSpellInRange(S.CometStorm)) then return "comet_storm aoe 8"; end
  end
  -- freeze,if=(target.level<level+3|target.is_add)&(!talent.snowstorm&debuff.frozen.down|cooldown.cone_of_cold.ready&buff.snowstorm.stack=buff.snowstorm.max_stack)
  if Pet:IsActive() and UseFreezePet and S.Freeze:IsReady() and (Freezable() and FrozenRemains() == 0 and (not S.GlacialSpike:IsAvailable() and not S.Snowstorm:IsAvailable() or Player:PrevGCDP(1, S.GlacialSpike) or S.ConeofCold:CooldownUp() and Player:BuffStack(S.SnowstormBuff) == var_snowstorm_max_stack)) then
    if Press(M.FreezePet, not Target:IsSpellInRange(S.Freeze)) then return "freeze aoe 10"; end
  end
  -- ice_nova,if=(target.level<level+3|target.is_add)&(prev_gcd.1.comet_storm|cooldown.cone_of_cold.ready&buff.snowstorm.stack=buff.snowstorm.max_stack&gcd.max<1)
  if S.IceNova:IsCastable() and UseIceNova and (Freezable() and not Player:PrevOffGCDP(1, S.Freeze) and (Player:PrevGCDP(1, S.GlacialSpike) or S.ConeofCold:CooldownUp() and Player:BuffStack(S.SnowstormBuff) == var_snowstorm_max_stack and GCDMax < 1)) then
    if Press(S.IceNova, not Target:IsSpellInRange(S.IceNova)) then return "ice_nova aoe 11"; end
  end
  -- frost_nova,if=(target.level<level+3|target.is_add)&active_enemies>=5&cooldown.cone_of_cold.ready&buff.snowstorm.stack=buff.snowstorm.max_stack&gcd.max<1
  if S.FrostNova:IsCastable() and UseFrostNova and (Freezable() and not Player:PrevOffGCDP(1, S.Freeze) and (Player:PrevGCDP(1, S.GlacialSpike) and RemainingWintersChill == 0 or S.ConeofCold:CooldownUp() and Player:BuffStack(S.SnowstormBuff) == var_snowstorm_max_stack and GCDMax < 1)) then
    if Press(S.FrostNova, not Target:IsInRange(12)) then return "frost_nova aoe 12"; end
  end
  -- cone_of_cold,if=buff.snowstorm.stack=buff.snowstorm.max_stack
  if S.ConeofCold:IsCastable() and UseConeOfCold and ((ConeOfColdWithCD and CDs) or not ConeOfColdWithCD) and FightRemainsCheck < FightRemains and (Player:BuffStack(S.SnowstormBuff) == var_snowstorm_max_stack) then
    if Press(S.ConeofCold, not Target:IsInRange(12)) then return "cone_of_cold aoe 14"; end
  end
  -- shifting_power
  if S.ShiftingPower:IsCastable() and UseShiftingPower and ((ShiftingPowerWithCD and CDs) or not ShiftingPowerWithCD) and FightRemainsCheck < FightRemains then
    if Press(S.ShiftingPower, not Target:IsInRange(18), true) then return "shifting_power aoe 16"; end
  end
  -- glacial_spike,if=buff.icicles.react=5&cooldown.blizzard.remains>gcd.max
  if S.GlacialSpike:IsReady() and UseGlacialSpike and (Player:BuffStack(S.IciclesBuff) == 5 and S.Blizzard:CooldownRemains() > GCDMax) then
    if Press(S.GlacialSpike, not Target:IsSpellInRange(S.GlacialSpike)) then return "glacial_spike aoe 18"; end
  end
  -- flurry,if=cooldown_react&remaining_winters_chill=0&debuff.winters_chill.down&(prev_gcd.1.frostbolt|(active_enemies>=7|charges=max_charges)&buff.fingers_of_frost.react=0)
  if S.Flurry:IsCastable() and UseFlurry and (not Freezable() and RemainingWintersChill == 0 and (Player:PrevGCDP(1, S.GlacialSpike) or S.Flurry:ChargesFractional() > 1.8))  then
    if Press(S.Flurry, not Target:IsSpellInRange(S.Flurry)) then return "flurry aoe 20"; end
  end
  -- flurry,if=cooldown_react&!debuff.winters_chill.remains&(buff.brain_freeze.react|!buff.fingers_of_frost.react)
  if S.Flurry:IsCastable() and UseFlurry and (RemainingWintersChill == 0 and (Player:BuffUp(S.BrainFreezeBuff) or Player:BuffUp(S.FingersofFrostBuff))) then
    if Press(S.Flurry, not Target:IsSpellInRange(S.Flurry)) then return "flurry aoe 21"; end
  end
  -- ice_lance,if=buff.fingers_of_frost.react|debuff.frozen.remains>travel_time|remaining_winters_chill
  if S.IceLance:IsCastable() and UseIceLance and (Player:BuffUp(S.FingersofFrostBuff) or FrozenRemains() > S.IceLance:TravelTime() or bool(RemainingWintersChill)) then
    if Press(S.IceLance, not Target:IsSpellInRange(S.IceLance)) then return "ice_lance aoe 22"; end
  end
  -- ice_nova,if=active_enemies>=4&(!talent.snowstorm&!talent.glacial_spike|!freezable)
  if S.IceNova:IsCastable() and UseIceNova and (EnemiesCount8ySplash >= 4 and (not S.Snowstorm:IsAvailable() and not S.GlacialSpike:IsAvailable() or not Freezable()))  then
    if Press(S.IceNova, not Target:IsSpellInRange(S.IceNova)) then return "ice_nova aoe 23"; end
  end
  -- dragons_breath,if=active_enemies>=7
  if S.DragonsBreath:IsCastable() and UseDragonsBreath and (EnemiesCount16ySplash >= 7) then
    if Press(S.DragonsBreath, not Target:IsInRange(12)) then return "dragons_breath aoe 26"; end
  end
  -- arcane_explosion,if=mana.pct>30&active_enemies>=7
  if S.ArcaneExplosion:IsCastable() and UseArcaneExplosion and (Player:ManaPercentage() > 30 and EnemiesCount16ySplash >= 7) then
    if Press(S.ArcaneExplosion, not Target:IsInRange(10)) then return "arcane_explosion aoe 28"; end
  end
  -- frostbolt
  if S.Frostbolt:IsCastable() and UseFrostbolt then
    if Press(S.Frostbolt, not Target:IsSpellInRange(S.Frostbolt), true) then return "frostbolt aoe 32"; end
  end
  -- call_action_list,name=movement
  if Player:IsMoving() and UseSpellsWhileMoving then
    local ShouldReturn = Movement(); if ShouldReturn then return ShouldReturn; end
  end
end

local function Single()
  -- comet_storm,if=prev_gcd.1.flurry|prev_gcd.1.cone_of_cold
  if S.CometStorm:IsCastable() and UseCometStorm and ((CometStormWithCD and CDs) or not CometStormWithCD) and FightRemainsCheck < FightRemains and (Player:PrevGCDP(1, S.Flurry) or Player:PrevGCDP(1, S.ConeofCold)) then
    if Press(S.CometStorm, not Target:IsSpellInRange(S.CometStorm)) then return "comet_storm single 4"; end
  end
  -- flurry,if=cooldown_react&remaining_winters_chill=0&debuff.winters_chill.down&(prev_gcd.1.frostbolt|prev_gcd.1.glacial_spike|talent.glacial_spike&buff.icicles.react=4&!buff.fingers_of_frost.react)
  if S.Flurry:IsCastable() and UseFlurry and (RemainingWintersChill == 0 and Target:DebuffDown(S.WintersChillDebuff) and (Player:PrevGCDP(1, S.Frostbolt) or Player:PrevGCDP(1, S.GlacialSpike) or S.GlacialSpike:IsAvailable() and Player:BuffStack(S.IciclesBuff) ==4 and Player:BuffDown(S.FingersofFrostBuff))) then
    if Press(S.Flurry, not Target:IsSpellInRange(S.Flurry)) then return "flurry single 6"; end
  end
  -- ice_lance,if=talent.glacial_spike&debuff.winters_chill.down&buff.icicles.react=4&buff.fingers_of_frost.react
  if S.IceLance:IsReady() and UseIceLance and (S.GlacialSpike:IsAvailable() and RemainingWintersChill == 0 and Player:BuffStack(S.IciclesBuff) == 4 and Player:BuffUp(S.FingersofFrostBuff)) then
    if Press(S.IceLance, not Target:IsSpellInRange(S.IceLance)) then return "ice_lance single 7"; end
  end
  -- ray_of_frost,if=remaining_winters_chill=1
  if S.RayofFrost:IsCastable() and UseRayOfFrost and (RemainingWintersChill == 1) then
    if Press(S.RayofFrost, not Target:IsSpellInRange(S.RayofFrost)) then return "ray_of_frost single 8"; end
  end
  -- glacial_spike,if=buff.icicles.react=5&(action.flurry.cooldown_react|remaining_winters_chill)
  if S.GlacialSpike:IsReady() and UseGlacialSpike and (Player:BuffStack(S.IciclesBuff) == 5 and (S.Flurry:Charges() >= 1 or RemainingWintersChill > 0)) then
    if Press(S.GlacialSpike, not Target:IsSpellInRange(S.GlacialSpike)) then return "glacial_spike single 10"; end
  end
  -- frozen_orb,if=buff.fingers_of_frost.react<2&(!talent.ray_of_frost|cooldown.ray_of_frost.remains)
  if S.FrozenOrb:IsCastable() and UseFrozenOrb and ((FrozenOrbWithCD and CDs) or not FrozenOrbWithCD) and FightRemainsCheck < FightRemains and (Player:BuffStack(S.FingersofFrostBuff) < 2 and (not S.RayofFrost:IsAvailable() or S.RayofFrost:CooldownDown())) then
    if Press(S.FrozenOrb, not Target:IsInRange(40)) then return "frozen_orb single 12"; end
  end
  -- cone_of_cold,if=talent.coldest_snap&cooldown.comet_storm.remains>10&cooldown.frozen_orb.remains>10&remaining_winters_chill=0&active_enemies>=3
  if S.ConeofCold:IsCastable() and UseConeOfCold and ((ConeOfColdWithCD and CDs) or not ConeOfColdWithCD) and FightRemainsCheck < FightRemains and (S.ColdestSnap:IsAvailable() and S.CometStorm:CooldownRemains() > 10 and S.FrozenOrb:CooldownRemains() > 10 and RemainingWintersChill == 0 and EnemiesCount8ySplash >= 3) then
    if Press(S.ConeofCold, not Target:IsInRange(12)) then return "cone_of_cold single 14"; end
  end
  -- blizzard,if=active_enemies>=2&talent.ice_caller&talent.freezing_rain&(!talent.splintering_cold&!talent.ray_of_frost|buff.freezing_rain.up|active_enemies>=3)
  if S.Blizzard:IsCastable() and UseBlizzard and (EnemiesCount8ySplash >= 2 and S.IceCaller:IsAvailable() and S.FreezingRain:IsAvailable() and (not S.SplinteringCold:IsAvailable() and not S.RayofFrost:IsAvailable() or Player:BuffUp(S.FreezingRainBuff) or EnemiesCount8ySplash >= 3)) then
    if Press(M.BlizzardCursor, not Target:IsInRange(40)) then return "blizzard single 16"; end
  end
  -- shifting_power,if=cooldown.frozen_orb.remains>10&(!talent.comet_storm|cooldown.comet_storm.remains>10)&(!talent.ray_of_frost|cooldown.ray_of_frost.remains>10)|cooldown.icy_veins.remains<20
  if S.ShiftingPower:IsCastable() and UseShiftingPower and ((ShiftingPowerWithCD and CDs) or not ShiftingPowerWithCD) and FightRemainsCheck < FightRemains and (S.FrozenOrb:CooldownRemains() > 10 and (not S.CometStorm:IsAvailable() or S.CometStorm:CooldownRemains() > 10) and (not S.RayofFrost:IsAvailable() or S.RayofFrost:CooldownRemains() > 10) or S.IcyVeins:CooldownRemains() < 20) then
    if Press(S.ShiftingPower, not Target:IsInRange(18)) then return "shifting_power single 18"; end
  end
  -- ice_lance,if=buff.fingers_of_frost.react&!prev_gcd.1.glacial_spike|remaining_winters_chill
  if S.IceLance:IsReady() and UseIceLance and (Player:BuffUp(S.FingersofFrostBuff) and not Player:PrevGCDP(1, S.GlacialSpike) or bool(RemainingWintersChill)) then
    if Press(S.IceLance, not Target:IsSpellInRange(S.IceLance)) then return "ice_lance single 20"; end
  end
  -- ice_nova,if=active_enemies>=4
  if S.IceNova:IsCastable() and UseIceNova and (EnemiesCount16ySplash >= 4) then
    if Press(S.IceNova, not Target:IsSpellInRange(S.IceNova)) then return "ice_nova single 22"; end
  end
  -- glacial_spike,if=buff.icicles.react=5&buff.icy_veins.up
  if S.GlacialSpike:IsCastable() and UseGlacialSpike and (Player:BuffStack(S.IciclesBuff) == 5 and Player:BuffUp(S.IcyVeinsBuff)) then
    if Press(S.GlacialSpike, not Target:IsSpellInRange(S.GlacialSpike)) then return "glacial_spike single 34"; end
  end
  if UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) then
    -- bag_of_tricks
    if S.BagofTricks:IsCastable() then
      if Press(S.BagofTricks, not Target:IsSpellInRange(S.BagofTricks)) then return "bag_of_tricks cd 40"; end
    end
  end
  -- frostbolt
  if S.Frostbolt:IsCastable() and UseFrostbolt then
    if Press(S.Frostbolt, not Target:IsSpellInRange(S.Frostbolt), true) then return "frostbolt single 42"; end
  end
  -- Manually added: ice_lance as a fallthrough when MovingRotation is true
  -- call_action_list,name=movement
  if Player:IsMoving() and UseSpellsWhileMoving then
    local ShouldReturn = Movement(); if ShouldReturn then return ShouldReturn; end
  end
end


local function FetchSettings()
  --General Use
  UseArcaneExplosion = EpicSettings.Settings["useArcaneExplosion"]
  UseArcaneIntellect = EpicSettings.Settings["useArcaneIntellect"]
  UseBlizzard = EpicSettings.Settings["useBlizzard"]
  UseDragonsBreath = EpicSettings.Settings["useDragonsBreath"]
  UseFireBlast = EpicSettings.Settings["useFireBlast"]
  UseFrostbolt = EpicSettings.Settings["useFrostbolt"]
  UseFrostNova = EpicSettings.Settings["useFrostNova"]
  UseFlurry = EpicSettings.Settings["useFlurry"]
  UseFreezePet = EpicSettings.Settings["useFreezePet"]
  UseGlacialSpike = EpicSettings.Settings["useGlacialSpike"]
  UseIceFloes = EpicSettings.Settings["useIceFloes"]
  UseIceLance = EpicSettings.Settings["useIceLance"]
  UseIceNova = EpicSettings.Settings["useIceNova"]
  UseRayOfFrost = EpicSettings.Settings["useRayOfFrost"]
  
  --Settings Interrupt
  UseCounterspell = EpicSettings.Settings["useCounterspell"]
  UseBlastWave = EpicSettings.Settings["useBlastWave"]

  --CDs Use
  UseIcyVeins = EpicSettings.Settings["useIcyVeins"]
  UseFrozenOrb = EpicSettings.Settings["useFrozenOrb"]
  UseCometStorm = EpicSettings.Settings["useCometStorm"]
  UseConeOfCold = EpicSettings.Settings["useConeOfCold"]
  UseShiftingPower = EpicSettings.Settings["useShiftingPower"]

  --SaveWithCD Settings
  IcyVeinsWithCD = EpicSettings.Settings["icyVeinsWithCD"]
  FrozenOrbWithCD = EpicSettings.Settings["frozenOrbWithCD"]
  CometStormWithCD = EpicSettings.Settings["cometStormWithCD"]
  ConeOfColdWithCD = EpicSettings.Settings["coneOfColdWithCD"]
  ShiftingPowerWithCD = EpicSettings.Settings["shiftingPowerWithCD"]

  --Defensive Use Settings
  UseAlterTime = EpicSettings.Settings["useAlterTime"]
  UseIceBarrier = EpicSettings.Settings["useIceBarrier"]
  UseGreaterInvisibility = EpicSettings.Settings["useGreaterInvisibility"]
  UseIceBlock = EpicSettings.Settings["useIceBlock"]
  UseMassBarrier = EpicSettings.Settings["useMassBarrier"]
  UseMirrorImage = EpicSettings.Settings["useMirrorImage"]

  --Defensive HP Settings
  AlterTimeHP = EpicSettings.Settings["alterTimeHP"] or 0
  IceBarrierHP = EpicSettings.Settings["iceBarrierHP"] or 0
  GreaterInvisibilityHP = EpicSettings.Settings["greaterInvisibilityHP"] or 0
  IceBlockHP = EpicSettings.Settings["iceBlockHP"] or 0
  MirrorImageHP = EpicSettings.Settings["mirrorImageHP"] or 0
 
  --Other Settings
  UseSpellStealTarget = EpicSettings.Settings["useSpellStealTarget"]
  UseSpellsWhileMoving = EpicSettings.Settings["useSpellsWhileMoving"]
  UseTimeWarpWithTalent = EpicSettings.Settings["useTimeWarpWithTalent"]

  --Afflicted Reaction
  UseRemoveCurseWithAfflicted = EpicSettings.Settings["useRemoveCurseWithAfflicted"]
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



--- ======= ACTION LISTS =======
local function APL()

  FetchSettings();
  FetchGeneralSettings();

  OOC = EpicSettings.Toggles["ooc"]
  AOE = EpicSettings.Toggles["aoe"]
  CDs = EpicSettings.Toggles["cds"]
  Kick = EpicSettings.Toggles["kick"]
  DispelToggle = EpicSettings.Toggles["dispel"]

  -- Enemies Update
  Enemies16ySplash = Target:GetEnemiesInSplashRange(16)
  if AOE then
    EnemiesCount8ySplash = Target:GetEnemiesInSplashRangeCount(8)
    EnemiesCount16ySplash = Target:GetEnemiesInSplashRangeCount(16)
  else
    EnemiesCount15yMelee = 1
    EnemiesCount8ySplash = 1
    EnemiesCount16ySplash = 1
  end

  if not Player:AffectingCombat() then
    -- arcane_intellect
    if S.ArcaneIntellect:IsCastable() and (Player:BuffDown(S.ArcaneIntellect, true) or Everyone.GroupBuffMissing(S.ArcaneIntellect)) then
      if Press(S.ArcaneIntellect) then return "arcane_intellect"; end
    end
  end

  if Everyone.TargetIsValid() or Player:AffectingCombat() then
    -- Calculate fight_remains
    BossFightRemains = EL.BossFightRemains(nil, true)
    FightRemains = BossFightRemains
    if FightRemains == 11111 then
      FightRemains = EL.FightRemains(Enemies16ySplash, false)
    end

    -- Calculate remaining_winters_chill, as it's used in many lines
    RemainingWintersChill = Target:DebuffStack(S.WintersChillDebuff)

    -- Calculate GCDMax
    GCDMax = Player:GCD() + 0.25
  end


  if Everyone.TargetIsValid() then

    if Focus then
      -- dispel
      if DispelDebuffs then
        ShouldReturn = Dispel(); if ShouldReturn then return ShouldReturn; end
      end
    end

    -- call precombat
    if not Player:AffectingCombat() and OOC then
      ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
    end

    -- defensive
    ShouldReturn = Defensive(); if ShouldReturn then return ShouldReturn; end

    --Focus and Dispell
    if Player:AffectingCombat() or DispelDebuffs then
      local includeDispellableUnits = DispelDebuffs and S.RemoveCurse:IsReady() and DispelToggle
      ShouldReturn = Everyone.FocusUnit(includeDispellableUnits, nil, nil, nil); if ShouldReturn then return ShouldReturn; end
    end

    -- Afflicted
    if HandleAfflicted then
      if UseRemoveCurseWithAfflicted then
        ShouldReturn = Everyone.HandleAfflicted(S.RemoveCurse, M.RemoveCurseMouseover, 30); if ShouldReturn then return ShouldReturn; end
      end
    end

    -- Incorporeal
    if HandleIncorporeal then
      ShouldReturn = Everyone.HandleIncorporeal(S.Polymorph, M.PolymorphMouseOver, 30, true); if ShouldReturn then return ShouldReturn; end
    end

    -- spellsteal
    if S.Spellsteal:IsAvailable() and UseSpellStealTarget and S.Spellsteal:IsReady() and DispelToggle and DispelBuffs and (not Player:IsCasting()) and (not Player:IsChanneling()) and Everyone.UnitHasMagicBuff(Target) then
      if Press(S.Spellsteal, not Target:IsSpellInRange(S.Spellsteal)) then return "spellsteal damage"; end
    end

    -- Interrupts
    if not Player:IsCasting() and not Player:IsChanneling() and Kick then
      if UseCounterspell then
        ShouldReturn = Everyone.Interrupt(S.Counterspell, 40); if ShouldReturn then return ShouldReturn; end
        ShouldReturn = Everyone.Interrupt(M.CounterspellMouseover, 40); if ShouldReturn then return ShouldReturn; end
      end
      if UseBlastWave then
        ShouldReturn = Everyone.InterruptWithStun(S.BlastWave, 8); if ShouldReturn then return ShouldReturn; end
      end
      if UseDragonsBreath then
        ShouldReturn = Everyone.InterruptWithStun(S.DragonsBreath, 12); if ShouldReturn then return ShouldReturn; end
      end
    end

    if Player:AffectingCombat() and Everyone.TargetIsValid() and not Player:IsChanneling() and not Player:IsCasting() then
      -- call_action_list,name=cds
      if CDs then
        ShouldReturn = Cooldowns(); if ShouldReturn then return ShouldReturn; end
      end
      -- run_action_list,name=aoe,if=active_enemies>=7&!set_bonus.tier30_2pc|active_enemies>=3&talent.ice_caller
      if AOE and (EnemiesCount16ySplash >= 7 and not Player:HasTier(30, 2) or EnemiesCount16ySplash >= 3 and S.IceCaller:IsAvailable()) then
        ShouldReturn = Aoe(); if ShouldReturn then return ShouldReturn; end
        if Press(S.Pool) then return "pool for Aoe()"; end
      end
      -- call_action_list,name=single,if=active_enemies<7&(active_enemies<3|!talent.ice_caller)
      ShouldReturn = Single(); if ShouldReturn then return ShouldReturn; end
      if Press(S.Pool) then return "pool for ST()"; end
      
      -- call_action_list,name=movement
      if UseSpellsWhileMoving then
        ShouldReturn = Movement(); if ShouldReturn then return ShouldReturn; end
      end
    end
  end
end

local function Init()
  FillDispels()
  ER.Print("Frost Mage rotation by Epic. Supported by xKaneto.")
end

ER.SetAPL(64, APL, Init)
