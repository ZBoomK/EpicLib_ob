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
local ceil       = math.ceil
-- Commons


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
local UseDragonsBreath
local UseFireBlast
local UseFireball
local UseFlamestrike
local UseLivingBomb
local UseMeteor
local UseMirrorImage
local UsePhoenixFlames
local UsePyroblast
local UseScorch

--Settings Use Interrupts
local UseCounterspell
local UseBlastWave

--Settings Use With CD
local UseCombustion
local UseShiftingPower

--Settings WithCDs
local CombustionWithCD
local ShiftingPowerWithCD

--Settings UseDefensives
local UseAlterTime
local UseBlazingBarrier
local UseGreaterInvisibility
local UseIceBlock
local UseMassBarrier

--Settings DefensiveHP
local AlterTimeHP
local BlazingBarrierHP
local GreaterInvisibilityHP
local IceBlockHP

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

local MirrorImageBeforePull
local UseSpellStealTarget

--Afflicted
local UseRemoveCurseWithAfflicted

--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Define S/I for spell and item arrays
local S = Spell.Mage.Fire
local I = Item.Mage.Fire
local M = Macro.Mage.Fire

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
}

-- GUI Settings
local Everyone = ER.Commons.Everyone
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.Mage.Commons,
--  Fire = ER.GUISettings.APL.Mage.Fire
--}

local function FillDispels()
  if S.RemoveCurse:IsAvailable() then
    Everyone.DispellableDebuffs = Everyone.DispellableCurseDebuffs
  end
end

EL:RegisterForEvent(function()
  FillDispels()
end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");

-- Variables from Precombat
-- variable,name=disable_combustion,op=reset
local var_disable_combustion = not CDs
-- variable,name=firestarter_combustion,default=-1,value=talent.sun_kings_blessing,if=variable.firestarter_combustion<0
local var_firestarter_combustion = S.SunKingsBlessing:IsAvailable()
-- variable,name=hot_streak_flamestrike,if=variable.hot_streak_flamestrike=0,value=3*talent.flame_patch+999*!talent.flame_patch
local var_hot_streak_flamestrike = (S.FlamePatch:IsAvailable()) and 3 or 999
-- variable,name=hard_cast_flamestrike,if=variable.hard_cast_flamestrike=0,value=999
local var_hard_cast_flamestrike = 999
-- variable,name=combustion_flamestrike,if=variable.combustion_flamestrike=0,value=3*talent.flame_patch+999*!talent.flame_patch
local var_combustion_flamestrike = var_hot_streak_flamestrike
-- variable,name=skb_flamestrike,if=variable.skb_flamestrike=0,value=3
local var_skb_flamestrike = 3
-- variable,name=arcane_explosion,if=variable.arcane_explosion=0,value=999
local var_arcane_explosion = 999
-- variable,name=arcane_explosion_mana,default=40,op=reset
local var_arcane_explosion_mana = 40
-- variable,name=combustion_shifting_power,if=variable.combustion_shifting_power=0,value=999
local var_combustion_shifting_power = 999
-- variable,name=combustion_cast_remains,default=0.3,op=reset
-- Note: Increased to 0.6 to give more player reaction time.
local var_combustion_cast_remains = 0.6
-- variable,name=overpool_fire_blasts,default=0,op=reset
local var_overpool_fire_blasts = 0
-- variable,name=skb_duration,value=dbc.effect.1016075.base_value
-- Note: This is the duration of Sun King's Blessing's free Combustion
local var_skb_duration = 6
-- variable,name=combustion_on_use,value=equipped.gladiators_badge|equipped.moonlit_prism|equipped.irideus_fragment|equipped.spoils_of_neltharus|equipped.tome_of_unstable_power|equipped.timebreaching_talon|equipped.horn_of_valor
local var_combustion_on_use = false
-- variable,name=on_use_cutoff,value=20,if=variable.combustion_on_use
local var_on_use_cutoff = (var_combustion_on_use) and 20 or 0

-- Variables that need to be set later
-- variable,name=time_to_combustion,value=fight_remains+100,if=variable.disable_combustion
local var_time_to_combustion

-- Other variables used in the rotation
local var_kindling_reduction = (S.Kindling:IsAvailable()) and 0.4 or 1
local var_shifting_power_before_combustion = false
local var_phoenix_pooling = false
local var_fire_blast_pooling = false
local var_combustion_ready_time = 0
local var_combustion_precast_time = 0
local var_sun_kings_blessing_max_stack = 8
local var_improved_scorch_max_stack = 3
local CombustionUp
local CombustionDown
local ShiftingPowerTickReduction = 3
local BossFightRemains = 11111
local FightRemains = 11111
local GCDMax

-- Enemy variables
local EnemiesCount8ySplash,EnemiesCount10ySplash,EnemiesCount16ySplash
local EnemiesCount10yMelee,EnemiesCount18yMelee
local Enemies8ySplash,Enemies10yMelee,Enemies18yMelee
local UnitsWithIgniteCount

EL:RegisterForEvent(function()
  var_combustion_on_use = false
  var_on_use_cutoff = (var_combustion_on_use) and 20 or 0
end, "PLAYER_EQUIPMENT_CHANGED")

EL:RegisterForEvent(function()
  S.Pyroblast:RegisterInFlight()
  S.Fireball:RegisterInFlight()
  S.Meteor:RegisterInFlightEffect(351140)
  S.Meteor:RegisterInFlight()
  S.PhoenixFlames:RegisterInFlightEffect(257542)
  S.PhoenixFlames:RegisterInFlight()
  S.Pyroblast:RegisterInFlight(S.CombustionBuff)
  S.Fireball:RegisterInFlight(S.CombustionBuff)
end, "LEARNED_SPELL_IN_TAB")
S.Pyroblast:RegisterInFlight()
S.Fireball:RegisterInFlight()
S.Meteor:RegisterInFlightEffect(351140)
S.Meteor:RegisterInFlight()
S.PhoenixFlames:RegisterInFlightEffect(257542)
S.PhoenixFlames:RegisterInFlight()
S.Pyroblast:RegisterInFlight(S.CombustionBuff)
S.Fireball:RegisterInFlight(S.CombustionBuff)

EL:RegisterForEvent(function()
  BossFightRemains = 11111
  FightRemains = 11111
end, "PLAYER_REGEN_ENABLED")

EL:RegisterForEvent(function()
  var_firestarter_combustion = S.SunKingsBlessing:IsAvailable()
  var_hot_streak_flamestrike = (S.FlamePatch:IsAvailable()) and 3 or 999
  var_combustion_flamestrike = var_hot_streak_flamestrike
  var_kindling_reduction = (S.Kindling:IsAvailable()) and 0.4 or 1
end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB")

local function FirestarterActive()
  return (S.Firestarter:IsAvailable() and (Target:HealthPercentage() > 90))
end

local function FirestarterRemains()
  return S.Firestarter:IsAvailable() and ((Target:HealthPercentage() > 90) and Target:TimeToX(90) or 0) or 0
end

local function SearingTouchActive()
  return S.SearingTouch:IsAvailable() and Target:HealthPercentage() < 30
end

local function ImprovedScorchActive()
  return S.ImprovedScorch:IsAvailable() and Target:HealthPercentage() < 30
end

local function ShiftingPowerFullReduction()
  return ShiftingPowerTickReduction * S.ShiftingPower:BaseDuration() / S.ShiftingPower:BaseTickTime()
end

local function FreeCastAvailable()
  local FSInFlight = FirestarterActive() and (num(S.Pyroblast:InFlight()) + num(S.Fireball:InFlight())) or 0
  FSInFlight = FSInFlight + num(S.PhoenixFlames:InFlight() or Player:PrevGCDP(1, S.PhoenixFlames))
  return Player:BuffUp(S.HotStreakBuff) or Player:BuffUp(S.HyperthermiaBuff) or (Player:BuffUp(S.HeatingUpBuff) and (ImprovedScorchActive() and Player:IsCasting(S.Scorch) or FirestarterActive() and (Player:IsCasting(S.Fireball) or Player:IsCasting(S.Pyroblast) or FSInFlight > 0)))
end

local function UnitsWithIgnite(enemies)
  local WithIgnite = 0
  for _, CycleUnit in pairs(enemies) do
    if CycleUnit:DebuffUp(S.IgniteDebuff) then
      WithIgnite = WithIgnite + 1
    end
  end
  return WithIgnite
end

local function HotStreakInFlight()
  local total = 0
  if S.Fireball:InFlight() or S.PhoenixFlames:InFlight() then
    total = total + 1
  end
  return total
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

local function Dispel()
  -- Remove Curse
  if S.RemoveCurse:IsReady() and DispelToggle and Everyone.DispellableFriendlyUnit() then
    if Press(M.RemoveCurseFocus) then return "remove_curse dispel"; end
  end
end

local function Defensive()
  -- Blazing Barrier
  if S.BlazingBarrier:IsReady() and UseBlazingBarrier and Player:BuffDown(S.BlazingBarrier) and not S.MassBarrier:IsReady() and Player:HealthPercentage() <= BlazingBarrierHP then
    if Press(S.BlazingBarrier) then return "blazing_barrier defensive 1"; end
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

local function Precombat()
  -- flask
  -- food
  -- augmentation
  -- arcane_intellect
  if S.ArcaneIntellect:IsCastable() and UseArcaneIntellect and (Player:BuffDown(S.ArcaneIntellect, true) or Everyone.GroupBuffMissing(S.ArcaneIntellect)) then
    if Press(S.ArcaneIntellect) then return "arcane_intellect precombat 2"; end
  end
  -- variable,name=disable_combustion,op=reset
  -- Note: Moved to APL(), since the users may enable or disable CDsON at any time.
  -- variable,name=firestarter_combustion,default=-1,value=talent.sun_kings_blessing,if=variable.firestarter_combustion<0
  -- variable,name=hot_streak_flamestrike,if=variable.hot_streak_flamestrike=0,value=3*talent.flame_patch+999*!talent.flame_patch
  -- variable,name=hard_cast_flamestrike,if=variable.hard_cast_flamestrike=0,value=999
  -- variable,name=combustion_flamestrike,if=variable.combustion_flamestrike=0,value=3*talent.flame_patch+999*!talent.flame_patch
  -- variable,name=skb_flamestrike,if=variable.skb_flamestrike=0,value=3
  -- variable,name=arcane_explosion,if=variable.arcane_explosion=0,value=999
  -- variable,name=arcane_explosion_mana,default=40,op=reset
  -- variable,name=combustion_shifting_power,if=variable.combustion_shifting_power=0,value=999
  -- variable,name=combustion_cast_remains,default=0.3,op=reset
  -- variable,name=overpool_fire_blasts,default=0,op=reset
  -- Note: Moved to initial declarations and SPELLS_CHANGED/LEARNED_SPELL_IN_TAB
  -- variable,name=time_to_combustion,value=fight_remains+100,if=variable.disable_combustion
  -- Note: Moved to APL(), since the users may enable or disable CDsON at any time.
  -- variable,name=skb_duration,value=dbc.effect.1016075.base_value
  -- Note: Moved to initial declarations and SPELLS_CHANGED/LEARNED_SPELL_IN_TAB
  -- variable,name=combustion_on_use,value=equipped.gladiators_badge|equipped.moonlit_prism|equipped.irideus_fragment|equipped.spoils_of_neltharus|equipped.tome_of_unstable_power|equipped.timebreaching_talon|equipped.horn_of_valor
  -- variable,name=on_use_cutoff,value=20,if=variable.combustion_on_use
  -- Note: Moved to initial declarations and PLAYER_EQUIPMENT_CHANGED
  -- snapshot_stats
  -- mirror_image
  if CDs and S.MirrorImage:IsCastable() and UseMirrorImage and MirrorImageBeforePull then
    if Press(S.MirrorImage) then return "mirror_image precombat 2"; end
  end
  -- flamestrike,if=active_enemies>=variable.hot_streak_flamestrike
  -- Note: Can't calculate enemies in Precombat
  -- pyroblast
  if S.Pyroblast:IsReady() and UsePyroblast and not Player:IsCasting(S.Pyroblast) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast), true) then return "pyroblast precombat 4"; end
  end
  -- Manually added: fireball
  if S.Fireball:IsReady() and UseFireball then
    if Press(S.Fireball, not Target:IsSpellInRange(S.Fireball), true) then return "fireball precombat 6"; end
  end
end

local function ActiveTalents()
  -- living_bomb,if=active_enemies>1&buff.combustion.down&(variable.time_to_combustion>cooldown.living_bomb.duration|variable.time_to_combustion<=0)
  if S.LivingBomb:IsReady() and UseLivingBomb  and (EnemiesCount10ySplash > 1 and CombustionDown and (var_time_to_combustion > S.LivingBomb:CooldownRemains() or var_time_to_combustion <= 0)) then
    if Press(S.LivingBomb, not Target:IsSpellInRange(S.LivingBomb)) then return "living_bomb active_talents 2"; end
  end
  -- meteor,if=variable.time_to_combustion<=0|buff.combustion.remains>travel_time|!talent.sun_kings_blessing&(cooldown.meteor.duration<variable.time_to_combustion|fight_remains<variable.time_to_combustion)
  if S.Meteor:IsReady() and UseMeteor and (var_time_to_combustion <= 0 or Player:BuffRemains(S.CombustionBuff) > S.Meteor:TravelTime() or (not S.SunKingsBlessing:IsAvailable()) and (45 < var_time_to_combustion or FightRemains < var_time_to_combustion)) then
    if Press(M.MeteorCursor, not Target:IsInRange(40)) then return "meteor active_talents 4"; end
  end
  -- dragons_breath,if=talent.alexstraszas_fury&(buff.combustion.down&!buff.hot_streak.react)&(buff.feel_the_burn.up|time>15)&!firestarter.remains&!talent.tempered_flames
  -- dragons_breath,if=talent.alexstraszas_fury&(buff.combustion.down&!buff.hot_streak.react)&(buff.feel_the_burn.up|time>15)&(!improved_scorch.active)&!firestarter.remains&!talent.tempered_flames
  if S.DragonsBreath:IsReady() and UseDragonsBreath and (S.AlexstraszasFury:IsAvailable() and (CombustionDown and Player:BuffDown(S.HotStreakBuff)) and (Player:BuffUp(S.FeeltheBurnBuff) or EL.CombatTime() > 15) and (not ImprovedScorchActive()) and FirestarterRemains() == 0 and not S.TemperedFlames:IsAvailable()) then
    if Press(S.DragonsBreath, not Target:IsInRange(12)) then return "dragons_breath active_talents 6"; end
  end
  -- dragons_breath,if=talent.alexstraszas_fury&(buff.combustion.down&!buff.hot_streak.react)&(buff.feel_the_burn.up|time>15)&(!improved_scorch.active)&talent.tempered_flames
  if S.DragonsBreath:IsReady() and UseDragonsBreath and (S.AlexstraszasFury:IsAvailable() and (CombustionDown and Player:BuffDown(S.HotStreakBuff)) and (Player:BuffUp(S.FeeltheBurnBuff) or EL.CombatTime() > 15) and (not ImprovedScorchActive()) and S.TemperedFlames:IsAvailable()) then
    if Press(S.DragonsBreath, not Target:IsInRange(12)) then return "dragons_breath active_talents 8"; end
  end
end

local function CombustionCooldowns()
  -- todo
  -- potion
  local ShouldReturnPot = Everyone.HandleDPSPotion(Player:BuffUp(S.CombustionBuff)); if ShouldReturnPot then return ShouldReturnPot; end
  -- blood_fury
  if UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) and FightRemainsCheck < FightRemains then 
    if S.BloodFury:IsCastable() then
      if Press(S.BloodFury) then return "blood_fury combustion_cooldowns 4"; end
    end
    -- berserking,if=buff.combustion.up
    if S.Berserking:IsCastable() and (CombustionUp) then
      if Press(S.Berserking) then return "berserking combustion_cooldowns 6"; end
    end
    -- fireblood
    if S.Fireblood:IsCastable() then
      if Press(S.Fireblood) then return "fireblood combustion_cooldowns 8"; end
    end
    -- ancestral_call
    if S.AncestralCall:IsCastable() then
      if Press(S.AncestralCall) then return "ancestral_call combustion_cooldowns 10"; end
    end
  end
  -- invoke_external_buff,name=power_infusion,if=buff.power_infusion.down
  -- invoke_external_buff,name=blessing_of_summer,if=buff.blessing_of_summer.down
  -- Note: Not handling external buffs
  -- time_warp,if=talent.temporal_warp&buff.exhaustion.up
  -- todo trinkets
end

local function CombustionPhase()
  -- lights_judgment,if=buff.combustion.down
  if S.LightsJudgment:IsCastable() and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) and FightRemainsCheck < FightRemains and (CombustionDown) then
    if Press(S.LightsJudgment) then return "lights_judgment combustion_phase 2"; end
  end
  -- bag_of_tricks,if=buff.combustion.down
  if S.BagofTricks:IsCastable() and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) and FightRemainsCheck < FightRemains and (CombustionDown) then
    if Press(S.BagofTricks) then return "bag_of_tricks combustion_phase 4"; end
  end
  -- living_bomb,if=active_enemies>1&buff.combustion.down
  if S.LivingBomb:IsReady() and AOE and UseLivingBomb and (EnemiesCount10ySplash > 1 and CombustionDown) then
    if Press(S.LivingBomb, not Target:IsSpellInRange(S.LivingBomb)) then return "living_bomb combustion_phase 6"; end
  end
  -- call_action_list,name=combustion_cooldowns,if=buff.combustion.remains>variable.skb_duration|fight_remains<20
  if Player:BuffRemains(S.CombustionBuff) > var_skb_duration or FightRemains < 20 then
    ShouldReturn = CombustionCooldowns(); if ShouldReturn then return ShouldReturn; end
  end
  -- use_item,name=hyperthread_wristwraps,if=hyperthread_wristwraps.fire_blast>=2&action.fire_blast.charges=0
  -- use_item,name=neural_synapse_enhancer,if=variable.time_to_combustion>60
  -- Note: Not handling items from Mechagon...
  -- phoenix_flames,if=buff.combustion.down&set_bonus.tier30_2pc&!action.phoenix_flames.in_flight&debuff.charring_embers.remains<4*gcd.max&!buff.hot_streak.react
  if S.PhoenixFlames:IsCastable() and UsePhoenixFlames and (Player:BuffDown(S.CombustionBuff) and Player:HasTier(30, 2) and (not S.PhoenixFlames:InFlight()) and Target:DebuffRemains(S.CharringEmbersDebuff) < 4 * GCDMax and Player:BuffDown(S.HotStreakBuff)) then
    if Press(S.PhoenixFlames, not Target:IsSpellInRange(S.PhoenixFlames)) then return "phoenix_flames combustion_phase 8"; end
  end
  -- call_action_list,name=active_talents
  ShouldReturn = ActiveTalents(); if ShouldReturn then return ShouldReturn; end
  -- combustion from below
  if S.Combustion:IsReady() and UseCombustion and ((CombustionWithCD and CDs) or not CombustionWithCD) and FightRemainsCheck < FightRemains and (HotStreakInFlight() == 0 and CombustionDown and var_time_to_combustion <= 0 and (Player:IsCasting(S.Scorch) and S.Scorch:ExecuteRemains() < var_combustion_cast_remains or Player:IsCasting(S.Fireball) and S.Fireball:ExecuteRemains() < var_combustion_cast_remains or Player:IsCasting(S.Pyroblast) and S.Pyroblast:ExecuteRemains() < var_combustion_cast_remains or Player:IsCasting(S.Flamestrike) and S.Flamestrike:ExecuteRemains() < var_combustion_cast_remains or S.Meteor:InFlight() and S.Meteor:InFlightRemains() < var_combustion_cast_remains)) then
    if Press(S.Combustion) then return "combustion combustion_phase 10"; end
  end
  -- flamestrike,if=buff.combustion.down&buff.fury_of_the_sun_king.up&buff.fury_of_the_sun_king.remains>cast_time&buff.fury_of_the_sun_king.expiration_delay_remains=0&cooldown.combustion.remains<cast_time&active_enemies>=variable.skb_flamestrike
  -- TODO: Handle expiration_delay_remains
  if AOE and S.Flamestrike:IsReady() and UseFlamestrike and (not Player:IsCasting(S.Flamestrike)) and (CombustionDown and Player:BuffUp(S.FuryoftheSunKingBuff) and Player:BuffRemains(S.FuryoftheSunKingBuff) > S.Flamestrike:CastTime() and S.Combustion:CooldownRemains() < S.Flamestrike:CastTime() and EnemiesCount8ySplash >= var_skb_flamestrike) then
    -- todo
    if Press(M.FlamestrikeCursor, not Target:IsInRange(40)) then return "flamestrike combustion_phase 12"; end
  end
  -- pyroblast,if=buff.combustion.down&buff.fury_of_the_sun_king.up&buff.fury_of_the_sun_king.remains>cast_time&buff.fury_of_the_sun_king.expiration_delay_remains=0
  if S.Pyroblast:IsReady() and UsePyroblast and (not Player:IsCasting(S.Pyroblast)) and (CombustionDown and Player:BuffUp(S.FuryoftheSunKingBuff) and Player:BuffRemains(S.FuryoftheSunKingBuff) > S.Pyroblast:CastTime()) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast)) then return "pyroblast combustion_phase 14"; end
  end
  -- fireball,if=buff.combustion.down&cooldown.combustion.remains<cast_time&active_enemies<2&!improved_scorch.active
  if S.Fireball:IsReady() and UseFireball and (CombustionDown and S.Combustion:CooldownRemains() < S.Fireball:CastTime() and EnemiesCount8ySplash < 2 and not ImprovedScorchActive()) then
    if Press(S.Fireball, not Target:IsSpellInRange(S.Fireball)) then return "fireball combustion_phase 16"; end
  end
  -- scorch,if=buff.combustion.down&cooldown.combustion.remains<cast_time
  if S.Scorch:IsReady() and UseScorch and (CombustionDown and S.Combustion:CooldownRemains() < S.Scorch:CastTime()) then
    if Press(S.Scorch, not Target:IsSpellInRange(S.Scorch)) then return "scorch combustion_phase 18"; end
  end
  -- combustion,use_off_gcd=1,use_while_casting=1,if=hot_streak_spells_in_flight=0&buff.combustion.down&variable.time_to_combustion<=0&(action.scorch.executing&action.scorch.execute_remains<variable.combustion_cast_remains|action.fireball.executing&action.fireball.execute_remains<variable.combustion_cast_remains|action.pyroblast.executing&action.pyroblast.execute_remains<variable.combustion_cast_remains|action.flamestrike.executing&action.flamestrike.execute_remains<variable.combustion_cast_remains|action.meteor.in_flight&action.meteor.in_flight_remains<variable.combustion_cast_remains)
  -- Note: Moved above the previous four lines, due to use_while_casting.
  -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!variable.fire_blast_pooling&(!improved_scorch.active|action.scorch.executing|debuff.improved_scorch.remains>4*gcd.max)&(buff.fury_of_the_sun_king.down|action.pyroblast.executing)&buff.combustion.up&!buff.hyperthermia.react&!buff.hot_streak.react&hot_streak_spells_in_flight+buff.heating_up.react*(gcd.remains>0)<2
  if S.FireBlast:IsReady() and UseFireblast and (not FreeCastAvailable()) and ((not var_fire_blast_pooling) and ((not ImprovedScorchActive()) or Player:IsCasting(S.Scorch) or Target:DebuffRemains(S.ImprovedScorchDebuff) > 4 * GCDMax) and (Player:BuffDown(S.FuryoftheSunKingBuff) or Player:IsCasting(S.Pyroblast)) and CombustionUp and Player:BuffDown(S.HyperthermiaBuff) and Player:BuffDown(S.HotStreakBuff) and HotStreakInFlight() + num(Player:BuffUp(S.HeatingUpBuff)) * num(Player:GCDRemains() > 0) < 2) then
    if Press(S.FireBlast) then return "fire_blast combustion_phase 20"; end
  end
  -- flamestrike,if=(buff.hot_streak.react&active_enemies>=variable.combustion_flamestrike)|(buff.hyperthermia.react&active_enemies>=variable.combustion_flamestrike-talent.hyperthermia)
  if AOE and S.Flamestrike:IsReady() and UseFlamestrike and ((Player:BuffUp(S.HotStreakBuff) and EnemiesCount8ySplash >= var_combustion_flamestrike) or (Player:BuffUp(S.HyperthermiaBuff) and EnemiesCount8ySplash >= var_combustion_flamestrike - num(S.Hyperthermia:IsAvailable()))) then
    -- todo
    if Press(M.FlamestrikeCursor, not Target:IsInRange(40)) then return "flamestrike combustion_phase 22"; end
  end
  -- pyroblast,if=buff.hyperthermia.react
  if S.Pyroblast:IsReady() and UsePyroblast and (Player:BuffUp(S.HyperthermiaBuff)) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast)) then return "pyroblast combustion_phase 24"; end
  end
  -- pyroblast,if=buff.hot_streak.react&buff.combustion.up
  if S.Pyroblast:IsReady() and UsePyroblast and (Player:BuffUp(S.HotStreakBuff) and CombustionUp) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast)) then return "pyroblast combustion_phase 26"; end
  end
  -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.react&active_enemies<variable.combustion_flamestrike&buff.combustion.up
  if S.Pyroblast:IsReady() and UsePyroblast and (Player:PrevGCDP(1, S.Scorch) and Player:BuffUp(S.HeatingUpBuff) and EnemiesCount8ySplash < var_combustion_flamestrike and CombustionUp) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast)) then return "pyroblast combustion_phase 28"; end
  end
  -- shifting_power,if=buff.combustion.up&!action.fire_blast.charges&(action.phoenix_flames.charges<action.phoenix_flames.max_charges|talent.alexstraszas_fury)&variable.combustion_shifting_power<=active_enemies
  if S.ShiftingPower:IsReady() and UseShiftingPower and ((ShiftingPowerWithCD and CDs) or not ShiftingPowerWithCD) and FightRemainsCheck < FightRemains and (CombustionUp and S.FireBlast:Charges() == 0 and (S.PhoenixFlames:Charges() < S.PhoenixFlames:MaxCharges() or S.AlexstraszasFury:IsAvailable()) and var_combustion_shifting_power <= EnemiesCount8ySplash) then
    if Press(S.ShiftingPower, not Target:IsInRange(18)) then return "shifting_power combustion_phase 30"; end
  end
  -- flamestrike,if=buff.fury_of_the_sun_king.up&buff.fury_of_the_sun_king.remains>cast_time&active_enemies>=variable.skb_flamestrike&buff.fury_of_the_sun_king.expiration_delay_remains=0
  if AOE and S.Flamestrike:IsReady() and UseFlamestrike and (not Player:IsCasting(S.Flamestrike)) and (Player:BuffUp(S.FuryoftheSunKingBuff) and Player:BuffRemains(S.FuryoftheSunKingBuff) > S.Flamestrike:CastTime() and EnemiesCount8ySplash >= var_skb_flamestrike) then
    -- todo
    if Press(M.FlamestrikeCursor, not Target:IsInRange(40)) then return "flamestrike combustion_phase 32"; end
  end
  -- pyroblast,if=buff.fury_of_the_sun_king.up&buff.fury_of_the_sun_king.remains>cast_time&buff.fury_of_the_sun_king.expiration_delay_remains=0
  if S.Pyroblast:IsReady() and UsePyroblast and (not Player:IsCasting(S.Pyroblast)) and (Player:BuffUp(S.FuryoftheSunKingBuff) and Player:BuffRemains(S.FuryoftheSunKingBuff) > S.Pyroblast:CastTime()) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast)) then return "pyroblast combustion_phase 34"; end
  end
  -- scorch,if=improved_scorch.active&(debuff.improved_scorch.remains<4*gcd.max)&active_enemies<variable.combustion_flamestrike
  if S.Scorch:IsReady() and UseScorch and (ImprovedScorchActive() and (Target:DebuffRemains(S.ImprovedScorchDebuff) < 4 * GCDMax) and EnemiesCount16ySplash < var_combustion_flamestrike) then
    if Press(S.Scorch, not Target:IsSpellInRange(S.Scorch)) then return "scorch combustion_phase 36"; end
  end
  -- phoenix_flames,if=set_bonus.tier30_2pc&travel_time<buff.combustion.remains&buff.heating_up.react+hot_streak_spells_in_flight<2&(debuff.charring_embers.remains<4*gcd.max|buff.flames_fury.stack>1|buff.flames_fury.up)
  if S.PhoenixFlames:IsCastable() and UsePhoenixFlames and (Player:HasTier(30, 2) and S.PhoenixFlames:TravelTime() < Player:BuffRemains(S.CombustionBuff) and num(Player:BuffUp(S.HeatingUpBuff)) + HotStreakInFlight() < 2 and (Target:DebuffRemains(S.CharringEmbersDebuff) < 4 * GCDMax or Player:BuffStack(S.FlamesFuryBuff) > 1 or Player:BuffUp(S.FlamesFuryBuff))) then
   if Press(S.PhoenixFlames, not Target:IsSpellInRange(S.PhoenixFlames)) then return "phoenix_flames combustion_phase 38"; end
  end
  -- fireball,if=buff.combustion.remains>cast_time&buff.flame_accelerant.react
  if S.Fireball:IsReady() and UseFireball and (Player:BuffRemains(S.CombustionBuff) > S.Fireball:CastTime() and Player:BuffUp(S.FlameAccelerantBuff)) then
    if Press(S.Fireball, not Target:IsSpellInRange(S.Fireball)) then return "fireball combustion_phase 40"; end
  end
  -- phoenix_flames,if=!set_bonus.tier30_2pc&!talent.alexstraszas_fury&travel_time<buff.combustion.remains&buff.heating_up.react+hot_streak_spells_in_flight<2
  if S.PhoenixFlames:IsCastable() and UsePhoenixFlames and ((not Player:HasTier(30, 2)) and (not S.AlexstraszasFury:IsAvailable()) and S.PhoenixFlames:TravelTime() < Player:BuffRemains(S.CombustionBuff) and num(Player:BuffUp(S.HeatingUpBuff)) + HotStreakInFlight() < 2) then
    if Press(S.PhoenixFlames, not Target:IsSpellInRange(S.PhoenixFlames)) then return "phoenix_flames combustion_phase 42"; end
  end
  -- scorch,if=buff.combustion.remains>cast_time&cast_time>=gcd.max
  if S.Scorch:IsReady() and UseScorch and (Player:BuffRemains(S.CombustionBuff) > S.Scorch:CastTime() and S.Scorch:CastTime() >= GCDMax) then
    if Press(S.Scorch, not Target:IsSpellInRange(S.Scorch)) then return "scorch combustion_phase 44"; end
  end
  -- fireball,if=buff.combustion.remains>cast_time
  if S.Fireball:IsReady() and UseFireball and (Player:BuffRemains(S.CombustionBuff) > S.Fireball:CastTime()) then
    if Press(S.Fireball, not Target:IsSpellInRange(S.Fireball)) then return "fireball combustion_phase 46"; end
  end
  -- living_bomb,if=buff.combustion.remains<gcd.max&active_enemies>1
  if S.LivingBomb:IsReady() and UseLivingBomb and (Player:BuffRemains(S.CombustionBuff) < GCDMax and EnemiesCount10ySplash > 1) then
    if Press(S.LivingBomb, not Target:IsSpellInRange(S.LivingBomb)) then return "living_bomb combustion_phase 48"; end
  end
end

local function CombustionTiming()
  -- variable,use_off_gcd=1,use_while_casting=1,name=combustion_ready_time,value=cooldown.combustion.remains*expected_kindling_reduction
  var_combustion_ready_time = S.Combustion:CooldownRemains() * var_kindling_reduction
  -- variable,use_off_gcd=1,use_while_casting=1,name=combustion_precast_time,value=action.fireball.cast_time*(active_enemies<variable.combustion_flamestrike)+action.flamestrike.cast_time*(active_enemies>=variable.combustion_flamestrike)-variable.combustion_cast_remains
  var_combustion_precast_time = S.Fireball:CastTime() * num(EnemiesCount8ySplash < var_combustion_flamestrike) + S.Flamestrike:CastTime() * num(EnemiesCount8ySplash >= var_combustion_flamestrike) - var_combustion_cast_remains
  -- variable,use_off_gcd=1,use_while_casting=1,name=time_to_combustion,value=variable.combustion_ready_time
  var_time_to_combustion = var_combustion_ready_time
  -- variable,use_off_gcd=1,use_while_casting=1,name=time_to_combustion,op=max,value=firestarter.remains,if=talent.firestarter&!variable.firestarter_combustion
  if S.Firestarter:IsAvailable() and not var_firestarter_combustion then
    var_time_to_combustion = max(FirestarterRemains(), var_time_to_combustion)
  end
  -- variable,use_off_gcd=1,use_while_casting=1,name=time_to_combustion,op=max,value=(buff.sun_kings_blessing.max_stack-buff.sun_kings_blessing.stack)*(3*gcd.max),if=talent.sun_kings_blessing&firestarter.active&buff.fury_of_the_sun_king.down
  if S.SunKingsBlessing:IsAvailable() and FirestarterActive() and Player:BuffDown(S.FuryoftheSunKingBuff) then
    var_time_to_combustion = max(((var_sun_kings_blessing_max_stack - Player:BuffStack(S.SunKingsBlessingBuff)) * (3 * GCDMax)), var_time_to_combustion)
  end
  -- variable,use_off_gcd=1,use_while_casting=1,name=time_to_combustion,op=max,value=buff.combustion.remains
  var_time_to_combustion = max(Player:BuffRemains(S.CombustionBuff), var_time_to_combustion)
  -- variable,use_off_gcd=1,use_while_casting=1,name=time_to_combustion,op=max,value=raid_event.adds.in,if=raid_event.adds.exists&raid_event.adds.count>=3&raid_event.adds.duration>15
  -- Note: Skipping this, as we don't handle SimC's raid_event
  -- variable,use_off_gcd=1,use_while_casting=1,name=time_to_combustion,value=raid_event.vulnerable.in*!raid_event.vulnerable.up,if=raid_event.vulnerable.exists&variable.combustion_ready_time<raid_event.vulnerable.in
  -- Note: Skipping this, as we don't handle SimC's raid_event
  -- variable,use_off_gcd=1,use_while_casting=1,name=time_to_combustion,value=variable.combustion_ready_time,if=variable.combustion_ready_time+cooldown.combustion.duration*(1-(0.4+0.2*talent.firestarter)*talent.kindling)<=variable.time_to_combustion|variable.time_to_combustion>fight_remains-20
  if var_combustion_ready_time + 120 * (1 - (0.4 + 0.2 * num(S.Firestarter:IsAvailable())) * num(S.Kindling:IsAvailable())) <= var_time_to_combustion or var_time_to_combustion > FightRemains - 20 then
    var_time_to_combustion = var_combustion_ready_time
  end
end

local function FirestarterFireBlasts()
  -- fire_blast,use_while_casting=1,if=!variable.fire_blast_pooling&!buff.hot_streak.react&(action.fireball.execute_remains>gcd.remains|action.pyroblast.executing)&buff.heating_up.react+hot_streak_spells_in_flight=1&(cooldown.shifting_power.ready|charges>1|buff.feel_the_burn.remains<2*gcd.max)
  if S.FireBlast:IsReady() and UseFireblast and (not FreeCastAvailable()) and ((not var_fire_blast_pooling) and Player:BuffDown(S.HotStreakBuff) and num(Player:BuffUp(S.HeatingUpBuff)) + HotStreakInFlight() == 1 and (S.ShiftingPower:CooldownUp() or S.FireBlast:Charges() > 1 or Player:BuffRemains(S.FeeltheBurnBuff) < 2 * GCDMax)) then
    if Press(S.FireBlast) then return "fire_blast firestarter_fire_blasts 2"; end
  end
  -- fire_blast,use_off_gcd=1,if=!variable.fire_blast_pooling&buff.heating_up.react+hot_streak_spells_in_flight=1&(talent.feel_the_burn&buff.feel_the_burn.remains<gcd.remains|cooldown.shifting_power.ready&(!set_bonus.tier30_2pc|debuff.charring_embers.remains>2*gcd.max))
  -- Note: Added check to not cast Fire Blast when HotStreakBuff is active.
  if S.FireBlast:IsReady() and UseFireblast and (not FreeCastAvailable()) and ((not var_fire_blast_pooling) and num(Player:BuffUp(S.HeatingUpBuff)) + HotStreakInFlight() == 1 and (S.ShiftingPower:CooldownUp() and ((not Player:HasTier(30, 2)) or Target:DebuffRemains(S.CharringEmbersDebuff) > 2 * GCDMax))) then
    if Press(S.FireBlast) then return "fire_blast firestarter_fire_blasts 4"; end
  end
end

local function StandardRotation()
  -- flamestrike,if=active_enemies>=variable.hot_streak_flamestrike&(buff.hot_streak.react|buff.hyperthermia.react)
  if AOE and S.Flamestrike:IsReady() and UseFlamestrike and (EnemiesCount8ySplash >= var_hot_streak_flamestrike and FreeCastAvailable()) then
    -- todo
    if Press(M.FlamestrikeCursor, not Target:IsInRange(40)) then return "flamestrike standard_rotation 2"; end
  end
  -- pyroblast,if=buff.hyperthermia.react
  -- pyroblast,if=buff.hot_streak.react&(buff.hot_streak.remains<action.fireball.execute_time)
  -- pyroblast,if=buff.hot_streak.react&(hot_streak_spells_in_flight|firestarter.active|talent.alexstraszas_fury&action.phoenix_flames.charges)
  -- pyroblast,if=buff.hot_streak.react&searing_touch.active
  -- Note: Combining free Pyroblast lines
  if S.Pyroblast:IsReady() and UsePyroblast and (FreeCastAvailable()) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast), true) then return "pyroblast standard_rotation 4"; end
  end
  -- flamestrike,if=active_enemies>=variable.skb_flamestrike&buff.fury_of_the_sun_king.up&buff.fury_of_the_sun_king.expiration_delay_remains=0"
  if AOE and S.Flamestrike:IsReady() and UseFlamestrike and (not Player:IsCasting(S.Flamestrike)) and (EnemiesCount8ySplash >= var_skb_flamestrike and Player:BuffUp(S.FuryoftheSunKingBuff)) then
    -- todo
    if Press(M.FlamestrikeCursor, not Target:IsInRange(40)) then return "flamestrike standard_rotation 12"; end
  end
  -- Note: Using IsCasting check for !action.scorch.in_flight, since Scorch is an instant hit ability with no travel time.
  if S.Scorch:IsReady() and UseScorch and (ImprovedScorchActive() and Target:DebuffRemains(S.ImprovedScorchDebuff) < S.Pyroblast:CastTime() + 5 * GCDMax and Player:BuffUp(S.FuryoftheSunKingBuff) and not Player:IsCasting(S.Scorch)) then
    if Press(S.Scorch, not Target:IsSpellInRange(S.Scorch)) then return "scorch standard_rotation 13"; end
  end
  -- pyroblast,if=buff.fury_of_the_sun_king.up&buff.fury_of_the_sun_king.expiration_delay_remains=0
  if S.Pyroblast:IsReady() and UsePyroblast and (not Player:IsCasting(S.Pyroblast)) and (Player:BuffUp(S.FuryoftheSunKingBuff)) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast), true) then return "pyroblast standard_rotation 14"; end
  end
  -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!firestarter.active&!variable.fire_blast_pooling&buff.fury_of_the_sun_king.down&(((action.fireball.executing&(action.fireball.execute_remains<0.5|!talent.hyperthermia)|action.pyroblast.executing&(action.pyroblast.execute_remains<0.5|!talent.hyperthermia))&buff.heating_up.react)|(searing_touch.active&(!improved_scorch.active|debuff.improved_scorch.stack=debuff.improved_scorch.max_stack|full_recharge_time<3)&(buff.heating_up.react&!action.scorch.executing|!buff.hot_streak.react&!buff.heating_up.react&action.scorch.executing&!hot_streak_spells_in_flight)))
  if S.FireBlast:IsReady() and UseFireblast and (not FreeCastAvailable()) and ((not FirestarterActive()) and (not var_fire_blast_pooling) and Player:BuffDown(S.FuryoftheSunKingBuff) and (((Player:IsCasting(S.Fireball) and (S.Fireball:ExecuteRemains() < 0.5 or not S.Hyperthermia:IsAvailable()) or Player:IsCasting(S.Pyroblast) and (S.Pyroblast:ExecuteRemains() < 0.5 or not S.Hyperthermia:IsAvailable())) and Player:BuffUp(S.HeatingUpBuff)) or (SearingTouchActive() and ((not ImprovedScorchActive()) or Target:DebuffStack(S.ImprovedScorchDebuff) == var_improved_scorch_max_stack or S.FireBlast:FullRechargeTime() < 3) and (Player:BuffUp(S.HeatingUpBuff) and (not Player:IsCasting(S.Scorch)) or Player:BuffDown(S.HotStreakBuff) and Player:BuffDown(S.HeatingUpBuff) and Player:IsCasting(S.Scorch) and HotStreakInFlight() == 0)))) then
    if Press(S.FireBlast) then return "fire_blast standard_rotation 16"; end
  end
  -- pyroblast,if=prev_gcd.1.scorch&buff.heating_up.react&searing_touch.active&active_enemies<variable.hot_streak_flamestrike
  if S.Pyroblast:IsReady() and UsePyroblast and ((Player:IsCasting(S.Scorch) or Player:PrevGCDP(1, S.Scorch)) and Player:BuffUp(S.HeatingUpBuff) and SearingTouchActive() and EnemiesCount8ySplash < var_hot_streak_flamestrike) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast), true) then return "pyroblast standard_rotation 18"; end
  end
  -- scorch,if=improved_scorch.active&debuff.improved_scorch.remains<4*gcd.max
  if S.Scorch:IsReady() and UseScorch and (ImprovedScorchActive() and Target:DebuffRemains(S.ImprovedScorchDebuff) < 4 * GCDMax) then
    if Press(S.Scorch, not Target:IsSpellInRange(S.Scorch)) then return "scorch standard_rotation 19"; end
  end
  -- phoenix_flames,if=talent.alexstraszas_fury&(!talent.feel_the_burn|buff.feel_the_burn.remains<2*gcd.max)
  if S.PhoenixFlames:IsCastable() and UsePhoenixFlames and (S.AlexstraszasFury:IsAvailable() and ((not S.FeeltheBurn:IsAvailable()) or Player:BuffRemains(S.FeeltheBurnBuff) < 2 * GCDMax)) then
    if Press(S.PhoenixFlames, not Target:IsSpellInRange(S.PhoenixFlames)) then return "phoenix_flames standard_rotation 20"; end
  end
  -- phoenix_flames,if=set_bonus.tier30_2pc&debuff.charring_embers.remains<2*gcd.max&!buff.hot_streak.react
  if S.PhoenixFlames:IsCastable() and UsePhoenixFlames and (Player:HasTier(30, 2) and Target:DebuffRemains(S.CharringEmbersDebuff) < 2 * GCDMax and Player:BuffDown(S.HotStreakBuff)) then
    if Press(S.PhoenixFlames, not Target:IsSpellInRange(S.PhoenixFlames)) then return "phoenix_flames standard_rotation 21"; end
  end
  -- scorch,if=improved_scorch.active&debuff.improved_scorch.stack<debuff.improved_scorch.max_stack
  if S.Scorch:IsReady() and UseScorch and (ImprovedScorchActive() and Target:DebuffStack(S.ImprovedScorchDebuff) < var_improved_scorch_max_stack) then
    if Press(S.Scorch, not Target:IsSpellInRange(S.Scorch)) then return "scorch standard_rotation 22"; end
  end
  -- phoenix_flames,if=!talent.alexstraszas_fury&!buff.hot_streak.react&!variable.phoenix_pooling&buff.flames_fury.up
  if S.PhoenixFlames:IsCastable() and UsePhoenixFlames and ((not S.AlexstraszasFury:IsAvailable()) and Player:BuffDown(S.HotStreakBuff) and (not var_phoenix_pooling) and Player:BuffUp(S.FlamesFuryBuff)) then
    if Press(S.PhoenixFlames, not Target:IsSpellInRange(S.PhoenixFlames)) then return "phoenix_flames standard_rotation 24"; end
  end
  -- phoenix_flames,if=talent.alexstraszas_fury&!buff.hot_streak.react&hot_streak_spells_in_flight=0&(!variable.phoenix_pooling&buff.flames_fury.up|charges_fractional>2.5|charges_fractional>1.5&(!talent.feel_the_burn|buff.feel_the_burn.remains<3*gcd.max))
  if S.PhoenixFlames:IsCastable() and UsePhoenixFlames and (S.AlexstraszasFury:IsAvailable() and Player:BuffDown(S.HotStreakBuff) and HotStreakInFlight() == 0 and ((not var_phoenix_pooling) and Player:BuffUp(S.FlamesFuryBuff) or S.PhoenixFlames:ChargesFractional() > 2.5 or S.PhoenixFlames:ChargesFractional() > 1.5 and ((not S.FeeltheBurn:IsAvailable()) or Player:BuffRemains(S.FeeltheBurnBuff) < 3 * GCDMax))) then
    if Press(S.PhoenixFlames, not Target:IsSpellInRange(S.PhoenixFlames)) then return "phoenix_flames standard_rotation 26"; end
  end
  -- call_action_list,name=active_talents
  ShouldReturn = ActiveTalents(); if ShouldReturn then return ShouldReturn; end
  -- dragons_breath,if=active_enemies>1
  if AOE and S.DragonsBreath:IsReady() and UseDragonsBreath and (EnemiesCount16ySplash > 1) then
    if Press(S.DragonsBreath, not Target:IsInRange(12)) then return "dragons_breath standard_rotation 28"; end
  end
  -- scorch,if=searing_touch.active
  if S.Scorch:IsReady() and UseScorch and (SearingTouchActive()) then
    if Press(S.Scorch, not Target:IsSpellInRange(S.Scorch)) then return "scorch standard_rotation 30"; end
  end
  -- arcane_explosion,if=active_enemies>=variable.arcane_explosion&mana.pct>=variable.arcane_explosion_mana
  if AOE and S.ArcaneExplosion:IsReady() and UseArcaneExplosion and (EnemiesCount10yMelee >= var_arcane_explosion and Player:ManaPercentageP() >= var_arcane_explosion_mana) then
    if Press(S.ArcaneExplosion, not Target:IsInRange(10)) then return "arcane_explosion standard_rotation 32"; end
  end
  -- flamestrike,if=active_enemies>=variable.hard_cast_flamestrike
  if AOE and S.Flamestrike:IsReady() and UseFlamestrike and (EnemiesCount8ySplash >= var_hard_cast_flamestrike) then
    -- todo
    if Press(M.FlamestrikeCursor, not Target:IsInRange(40)) then return "flamestrike standard_rotation 34"; end
  end
  -- pyroblast,if=talent.tempered_flames&!buff.flame_accelerant.react
  if S.Pyroblast:IsReady() and UsePyroblast and (S.TemperedFlames:IsAvailable() and Player:BuffDown(S.FlameAccelerantBuff)) then
    if Press(S.Pyroblast, not Target:IsSpellInRange(S.Pyroblast), true) then return "pyroblast standard_rotation 35"; end
  end
  -- fireball
  if S.Fireball:IsReady() and UseFireball and (not FreeCastAvailable()) then
    if Press(S.Fireball, not Target:IsSpellInRange(S.Fireball), true) then return "fireball standard_rotation 36"; end
  end
end

local function Combat()
  
  if not var_disable_combustion then
    CombustionTiming()
  end
  -- variable,name=shifting_power_before_combustion,value=variable.time_to_combustion>cooldown.shifting_power.remains
  var_shifting_power_before_combustion = var_time_to_combustion > S.ShiftingPower:CooldownRemains()
  -- trinkets
  if FightRemainsCheck < FightRemains then
    if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) then
      ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
    end
  end
  -- variable,use_off_gcd=1,use_while_casting=1,name=fire_blast_pooling,value=buff.combustion.down&action.fire_blast.charges_fractional+(variable.time_to_combustion+action.shifting_power.full_reduction*variable.shifting_power_before_combustion)%cooldown.fire_blast.duration-1<cooldown.fire_blast.max_charges+variable.overpool_fire_blasts%cooldown.fire_blast.duration-(buff.combustion.duration%cooldown.fire_blast.duration)%%1&variable.time_to_combustion<fight_remains
  var_fire_blast_pooling = CombustionDown and S.FireBlast:ChargesFractional() + (var_time_to_combustion + ShiftingPowerFullReduction() * num(var_shifting_power_before_combustion)) / S.FireBlast:Cooldown() - 1 < S.FireBlast:MaxCharges() + var_overpool_fire_blasts / S.FireBlast:Cooldown() - (12 / S.FireBlast:Cooldown()) % 1 and var_time_to_combustion < FightRemains
  -- call_action_list,name=combustion_phase,if=variable.time_to_combustion<=0|buff.combustion.up|variable.time_to_combustion<variable.combustion_precast_time&cooldown.combustion.remains<variable.combustion_precast_time
  if not var_disable_combustion and (var_time_to_combustion <= 0 or CombustionUp or var_time_to_combustion < var_combustion_precast_time and S.Combustion:CooldownRemains() < var_combustion_precast_time) then
    ShouldReturn = CombustionPhase(); if ShouldReturn then return ShouldReturn; end
  end
  -- variable,use_off_gcd=1,use_while_casting=1,name=fire_blast_pooling,value=searing_touch.active&action.fire_blast.full_recharge_time>3*gcd.max,if=!variable.fire_blast_pooling&talent.sun_kings_blessing
  if (not var_fire_blast_pooling) and S.SunKingsBlessing:IsAvailable() then
    var_fire_blast_pooling = SearingTouchActive() and S.FireBlast:FullRechargeTime() > 3 * GCDMax
  end
  -- shifting_power,if=buff.combustion.down&(action.fire_blast.charges=0|variable.fire_blast_pooling)&(!improved_scorch.active|debuff.improved_scorch.remains>cast_time+action.scorch.cast_time&!buff.fury_of_the_sun_king.up)&!buff.hot_streak.react&variable.shifting_power_before_combustion
  if S.ShiftingPower:IsReady() and ((CDs and ShiftingPowerWithCD) or not ShiftingPowerWithCD) and UseShiftingPower and FightRemainsCheck < FightRemains and (CombustionDown and (S.FireBlast:Charges() == 0 or var_fire_blast_pooling) and ((not ImprovedScorchActive()) or Target:DebuffRemains(S.ImprovedScorchDebuff) > S.ShiftingPower:CastTime() + S.Scorch:CastTime() and Player:BuffDown(S.FuryoftheSunKingBuff)) and Player:BuffDown(S.HotStreakBuff) and var_shifting_power_before_combustion) then
   if Press(S.ShiftingPower, not Target:IsInRange(18), true) then return "shifting_power main 12"; end
  end
  -- variable,name=phoenix_pooling,if=active_enemies<variable.combustion_flamestrike,value=(variable.time_to_combustion+buff.combustion.duration-5<action.phoenix_flames.full_recharge_time+cooldown.phoenix_flames.duration-action.shifting_power.full_reduction*variable.shifting_power_before_combustion&variable.time_to_combustion<fight_remains|talent.sun_kings_blessing)&!talent.alexstraszas_fury
  -- Note: Swapped SunKingsBlessing check to the front so we can avoid lots of math if it's talented.
  if EnemiesCount8ySplash < var_combustion_flamestrike then
    var_phoenix_pooling = (S.SunKingsBlessing:IsAvailable() or var_time_to_combustion + 7 < S.PhoenixFlames:FullRechargeTime() + S.PhoenixFlames:Cooldown() - ShiftingPowerFullReduction() * num(var_shifting_power_before_combustion) and var_time_to_combustion < FightRemains) and not S.AlexstraszasFury:IsAvailable()
  end
  -- variable,name=phoenix_pooling,if=active_enemies>=variable.combustion_flamestrike,value=(variable.time_to_combustion<action.phoenix_flames.full_recharge_time-action.shifting_power.full_reduction*variable.shifting_power_before_combustion&variable.time_to_combustion<fight_remains|talent.sun_kings_blessing)&!talent.alexstraszas_fury
  -- Note: Swapped SunKingsBlessing check to the front so we can avoid lots of math if it's talented.
  if EnemiesCount8ySplash >= var_combustion_flamestrike then
    var_phoenix_pooling = (S.SunKingsBlessing:IsAvailable() or var_time_to_combustion < S.PhoenixFlames:FullRechargeTime() - ShiftingPowerFullReduction() * num(var_shifting_power_before_combustion) and var_time_to_combustion < FightRemains) and not S.AlexstraszasFury:IsAvailable()
  end
  -- fire_blast,use_off_gcd=1,use_while_casting=1,if=!variable.fire_blast_pooling&variable.time_to_combustion>0&active_enemies>=variable.hard_cast_flamestrike&!firestarter.active&!buff.hot_streak.react&(buff.heating_up.react&action.flamestrike.execute_remains<0.5|charges_fractional>=2)
  if S.FireBlast:IsReady() and UseFireblast and (not FreeCastAvailable()) and ((not var_fire_blast_pooling) and var_time_to_combustion > 0 and EnemiesCount8ySplash >= var_hard_cast_flamestrike and (not FirestarterActive()) and Player:BuffDown(S.HotStreakBuff) and (Player:BuffUp(S.HeatingUpBuff) and S.Flamestrike:ExecuteRemains() < 0.5 or S.FireBlast:ChargesFractional() >= 2)) then
    if Press(S.FireBlast) then return "fire_blast main 14"; end
  end
  -- call_action_list,name=firestarter_fire_blasts,if=buff.combustion.down&firestarter.active&variable.time_to_combustion>0
  if CombustionDown and FirestarterActive() and var_time_to_combustion > 0 then
    ShouldReturn = FirestarterFireBlasts(); if ShouldReturn then return ShouldReturn; end
  end
  -- fire_blast,use_while_casting=1,if=action.shifting_power.executing&full_recharge_time<action.shifting_power.tick_reduction
  if S.FireBlast:IsReady() and UseFireblast and (not FreeCastAvailable()) and (Player:IsCasting(S.ShiftingPower) and S.FireBlast:FullRechargeTime() < ShiftingPowerTickReduction) then
    if Press(S.FireBlast) then return "fire_blast main 16"; end
  end
  -- call_action_list,name=standard_rotation,if=variable.time_to_combustion>0&buff.combustion.down
  if var_time_to_combustion > 0 and CombustionDown then
    ShouldReturn = StandardRotation(); if ShouldReturn then return ShouldReturn; end
  end
  -- ice_nova,if=!searing_touch.active
  if S.IceNova:IsCastable() and UseIceNova and (not SearingTouchActive()) then
    if Press(S.IceNova, not Target:IsSpellInRange(S.IceNova)) then return "ice_nova main 18"; end
  end
  -- scorch
  if S.Scorch:IsReady() and UseScorch then
    if Press(S.Scorch, not Target:IsSpellInRange(S.Scorch)) then return "scorch main 20"; end
  end
end



local function FetchSettings()
  --General Use
  UseArcaneExplosion = EpicSettings.Settings["useArcaneExplosion"]
  UseArcaneIntellect = EpicSettings.Settings["useArcaneIntellect"]
  UseDragonsBreath = EpicSettings.Settings["useDragonsBreath"]
  UseFireBlast = EpicSettings.Settings["useFireBlast"]
  UseFireball = EpicSettings.Settings["useFireball"]
  UseFlamestrike = EpicSettings.Settings["useFlamestrike"]
  UseLivingBomb = EpicSettings.Settings["useLivingBomb"]
  UseMeteor = EpicSettings.Settings["useMeteor"]
  UsePhoenixFlames = EpicSettings.Settings["usePhoenixFlames"]
  UsePyroblast = EpicSettings.Settings["usePyroblast"]
  UseScorch = EpicSettings.Settings["useScorch"]

  --Settings Interrupt
  UseCounterspell = EpicSettings.Settings["useCounterspell"]
  UseBlastWave = EpicSettings.Settings["useBlastWave"]

  --CDs Use
  UseCombustion = EpicSettings.Settings["useCombustion"]
  UseShiftingPower = EpicSettings.Settings["useShiftingPower"]

  --SaveWithCD Settings
  CombustionWithCD = EpicSettings.Settings["combustionWithCD"]
  ShiftingPowerWithCD = EpicSettings.Settings["shiftingPowerWithCD"]

  --Defensive Use Settings
  UseAlterTime = EpicSettings.Settings["useAlterTime"]
  UseBlazingBarrier = EpicSettings.Settings["useBlazingBarrier"]
  UseGreaterInvisibility = EpicSettings.Settings["useGreaterInvisibility"]
  UseIceBlock = EpicSettings.Settings["useIceBlock"]
  UseMassBarrier = EpicSettings.Settings["useMassBarrier"]
  UseMirrorImage = EpicSettings.Settings["useMirrorImage"]

  --Defensive HP Settings
  AlterTimeHP = EpicSettings.Settings["alterTimeHP"] or 0
  BlazingBarrierHP = EpicSettings.Settings["blazingBarrierHP"] or 0
  GreaterInvisibilityHP = EpicSettings.Settings["greaterInvisibilityHP"] or 0
  IceBlockHP = EpicSettings.Settings["iceBlockHP"] or 0
  MirrorImageHP = EpicSettings.Settings["mirrorImageHP"] or 0
 
  --Other Settings
  MirrorImageBeforePull = EpicSettings.Settings["mirrorImageBeforePull"]
  UseSpellStealTarget = EpicSettings.Settings["useSpellStealTarget"]

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

  -- Update our enemy tables
  Enemies8ySplash = Target:GetEnemiesInSplashRange(8)
  Enemies10yMelee = Player:GetEnemiesInMeleeRange(10)
  Enemies18yMelee = Player:GetEnemiesInMeleeRange(18)
  if AOE then
    EnemiesCount8ySplash = Target:GetEnemiesInSplashRangeCount(8)
    EnemiesCount10ySplash = Target:GetEnemiesInSplashRangeCount(10)
    EnemiesCount16ySplash = Target:GetEnemiesInSplashRangeCount(16)
    EnemiesCount10yMelee = #Enemies10yMelee
    EnemiesCount18yMelee = #Enemies18yMelee
  else
    EnemiesCount8ySplash = 1
    EnemiesCount10ySplash = 1
    EnemiesCount16ySplash = 1
    EnemiesCount10yMelee = 1
    EnemiesCount18yMelee = 1
  end

  if Everyone.TargetIsValid() or Player:AffectingCombat() then

    --Focus and Dispell
    if Player:AffectingCombat() or DispelDebuffs then
      local includeDispellableUnits = DispelDebuffs and S.RemoveCurse:IsReady() and DispelToggle
      ShouldReturn = Everyone.FocusUnit(includeDispellableUnits, nil, nil, nil); if ShouldReturn then return ShouldReturn; end
    end

    -- Calculate fight_remains
    BossFightRemains = EL.BossFightRemains(nil, true)
    FightRemains = BossFightRemains
    if FightRemains == 11111 then
      FightRemains = EL.FightRemains(Enemies8ySplash, false)
    end

    -- Check how many units have ignite
    UnitsWithIgniteCount = UnitsWithIgnite(Enemies8ySplash)

    --  variable,name=disable_combustion,op=reset (from Precombat)
    var_disable_combustion = not CDs

    -- variable,name=time_to_combustion,value=fight_remains+100,if=variable.disable_combustion (from Precombat)
    if var_disable_combustion then
      var_time_to_combustion = 99999
    end

    -- Define gcd.max
    GCDMax = Player:GCD() + 0.25

    -- Get our Combustion status
    CombustionUp = Player:BuffUp(S.CombustionBuff)
    CombustionDown = not CombustionUp
  end

  if Everyone.TargetIsValid() then

    if Focus then
      -- dispel
      if DispelDebuffs then
        ShouldReturn = Dispel(); if ShouldReturn then return ShouldReturn; end
      end
    end

    -- call precombat
    if not Player:AffectingCombat() and OCC then
      ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
    end

    -- defensive
    ShouldReturn = Defensive(); if ShouldReturn then return ShouldReturn; end

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

    -- counterspell
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
    ShouldReturn = Combat(); if ShouldReturn then return ShouldReturn; end
  end
end

local function Init()
  FillDispels()
  ER.Print("Fire Mage rotation by Epic. Supported by xKaneto.")
end

ER.SetAPL(63, APL, Init)
