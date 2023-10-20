--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- EpicDBC
local DBC = EpicDBC.DBC
-- EpicLib
local EL         = EpicLib
local Unit       = EL.Unit
local Player     = Unit.Player
local Target     = Unit.Target
local Spell      = EL.Spell
local Item       = EL.Item
-- EpicLib
local ER         = EpicLib
local Cast       = ER.Cast
local Press      = ER.Press
local Macro      = ER.Macro
local Bind       = ER.Bind
-- Num/Bool Helper Functions
local num        = ER.Commons.Everyone.num
local bool       = ER.Commons.Everyone.bool
-- WoW API
local GetItemCount = GetItemCount

--- ============================ CONTENT ===========================

local ShouldReturn

-- Toggles
local OOC = false;
local AOE = false;
local CDs = false;
local MiniCDs = false;
local Kick = false;
local DispelToggle = false;

--Settings Use
local UseArcaneBlast
local UseArcaneBarrage
local UseArcaneExplosion
local UseArcaneFamiliar
local UseArcaneIntellect
local UseArcaneMissiles
local UseConjureManaGem
local UseDragonsBreath
local UseEvocation
local UseManaGem
local UseNetherTempest
local UsePresenceOfMind

--Settings Use Interrupts
local UseCounterspell
local UseBlastWave

--Settings Use With CD
local UseArcaneSurge
local UseShiftingPower

--Settings Use With MiniCD
local UseArcaneOrb
local UseRadiantSpark
local UseTouchOfTheMagi

--Settings WithCDs
local ArcaneSurgeWithCD
local ShiftingPowerWithCD

--Settings WithMiniCDs
local ArcaneOrbWithMiniCD
local RadiantSparkWithMiniCD
local TouchOfTheMagiWithMiniCD

--Settings UseDefensives
local UseAlterTime
local UsePrismaticBarrier
local UseGreaterInvisibility
local UseIceBlock
local UseMassBarrier
local UseMirrorImage

--Settings DefensiveHP
local AlterTimeHP
local PrismaticBarrierHP
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
local UseRacials
local UseTrinkets
local TrinketsWithCD
local RacialsWithCD

local UseHealingPotion
local UseHealthstone
local HealingPotionHP
local HealthstoneHP
local HealingPotionName;

local UseSpellStealTarget

--Afflicted
local UseRemoveCurseWithAfflicted


--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Define S/I for spell and item arrays
local S = Spell.Mage.Arcane;
local I = Item.Mage.Arcane;
local M = Macro.Mage.Arcane;

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
}

-- GUI Settings
local Everyone = ER.Commons.Everyone;
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.Mage.Commons,
--  Arcane = ER.GUISettings.APL.Mage.Arcane
--};

local function FillDispels()
  if S.RemoveCurse:IsAvailable() then
    Everyone.DispellableDebuffs = Everyone.DispellableCurseDebuffs
  end
end

EL:RegisterForEvent(function()
  FillDispels()
end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");

S.ArcaneBlast:RegisterInFlight()
S.ArcaneBarrage:RegisterInFlight()

-- Variables
local Enemies10yMelee, EnemiesCount10yMelee
local Enemies8ySplash, EnemiesCount8ySplash --Enemies arround target
local var_aoe_target_count = 3
local var_conserve_mana = false
local var_opener = OpenerArcaneSetting
local var_opener_min_mana = (S.ArcaneHarmony:IsAvailable()) and 225000 or 200000
local var_totm_on_last_spark_stack = not Player:HasTier(30, 4)
local var_steroid_trinket_equipped = false
local var_talon_double_on_use = false
local var_aoe_spark_phase
local var_spark_phase

local ClearCastingMaxStack = 3 --buff.clearcasting.max_stack
local BossFightRemains = 11111
local FightRemains = 11111
local GCDMax

EL:RegisterForEvent(function()
  var_conserve_mana = false
  var_opener = OpenerArcaneSetting
  var_opener_min_mana = (S.ArcaneHarmony:IsAvailable()) and 225000 or 200000
  BossFightRemains = 11111
  FightRemains = 11111
end, "PLAYER_REGEN_ENABLED")

EL:RegisterForEvent(function()
  var_totm_on_last_spark_stack = not Player:HasTier(30, 4)
  var_steroid_trinket_equipped = false
  var_talon_double_on_use = false
end, "PLAYER_EQUIPMENT_CHANGED")

local function Defensive()
  -- Ice Barrier
  if S.PrismaticBarrier:IsReady() and UsePrismaticBarrier and Player:BuffDown(S.PrismaticBarrier) and not S.MassBarrier:IsReady() and Player:HealthPercentage() <= PrismaticBarrierHP then
    if Press(S.PrismaticBarrier) then return "ice_barrier defensive 1"; end
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
  -- arcane_intellect
  -- Note: Moved to top of APL()
  -- variable,name=aoe_target_count,op=reset,default=3
  -- variable,name=conserve_mana,op=set,value=0
  -- variable,name=opener,op=set,value=1
  -- variable,name=opener_min_mana,default=-1,op=set,if=variable.opener_min_mana=-1,value=225000-(25000*!talent.arcane_harmony)
  -- variable,name=totm_on_last_spark_stack,default=-1,op=set,if=variable.totm_on_last_spark_stack=-1,value=!set_bonus.tier30_4pc
  -- variable,name=steroid_trinket_equipped,op=set,value=equipped.gladiators_badge|equipped.irideus_fragment|equipped.erupting_spear_fragment|equipped.spoils_of_neltharus|equipped.tome_of_unstable_power|equipped.timebreaching_talon|equipped.horn_of_valor
  -- variable,name=talon_double_on_use,op=set,value=equipped.timebreaching_talon&equipped.irideus_fragment
  -- Note: Moved to variable declarations and event registrations to avoid potential issue from entering combat before targeting an enemy.
  -- snapshot_stats
  -- mirror_image
  if S.MirrorImage:IsCastable() and MirrorImagesBeforePull and UseMirrorImage then
    if Press(S.MirrorImage) then return "mirror_image precombat 6"; end
  end
  -- arcane_blast,if=!talent.siphon_storm
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (not S.SiphonStorm:IsAvailable()) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast)) then return "arcane_blast precombat 8"; end
  end
  -- evocation,if=talent.siphon_storm
  if S.Evocation:IsReady() and UseEvocation and (S.SiphonStorm:IsAvailable()) then
    if Press(S.Evocation) then return "evocation precombat 10"; end
  end
end

local function Calculations()
  -- variable,name=aoe_spark_phase,op=set,value=1,if=active_enemies>=variable.aoe_target_count&(action.arcane_orb.charges>0|buff.arcane_charge.stack>=3)&cooldown.radiant_spark.ready&cooldown.touch_of_the_magi.remains<=(gcd.max*2)
  -- variable,name=aoe_spark_phase,op=set,value=0,if=variable.aoe_spark_phase&debuff.radiant_spark_vulnerability.down&dot.radiant_spark.remains<7&cooldown.radiant_spark.remains
  if ((EnemiesCount8ySplash >= var_aoe_target_count or EnemiesCount10yMelee >= var_aoe_target_count) and (S.ArcaneOrb:Charges() > 0 or Player:ArcaneCharges() >= 3) and S.RadiantSpark:CooldownUp() and S.TouchoftheMagi:CooldownRemains() <= GCDMax * 2) then
    var_aoe_spark_phase = true
  elseif (var_aoe_spark_phase and Target:DebuffDown(S.RadiantSparkVulnerability) and Target:DebuffRemains(S.RadiantSparkDebuff) < 7 and S.RadiantSpark:CooldownDown()) then
    var_aoe_spark_phase = false
  end
  -- variable,name=spark_phase,op=set,value=1,if=buff.arcane_charge.stack>3&active_enemies<variable.aoe_target_count&cooldown.radiant_spark.ready&cooldown.touch_of_the_magi.remains<=(gcd.max*7)
  -- variable,name=spark_phase,op=set,value=0,if=variable.spark_phase&debuff.radiant_spark_vulnerability.down&dot.radiant_spark.remains<7&cooldown.radiant_spark.remains
  if (Player:ArcaneCharges() > 3 and (EnemiesCount8ySplash < var_aoe_target_count and EnemiesCount10yMelee < var_aoe_target_count) and S.RadiantSpark:CooldownUp() and S.TouchoftheMagi:CooldownRemains() <= GCDMax * 7) then
    var_spark_phase = true
  elseif (var_spark_phase and Target:DebuffDown(S.RadiantSparkVulnerability) and Target:DebuffRemains(S.RadiantSparkDebuff) < 7 and S.RadiantSpark:CooldownDown()) then
    var_spark_phase = false
  end

  -- variable,name=opener,op=set,if=debuff.touch_of_the_magi.up&variable.opener,value=0
  if (Target:DebuffUp(S.TouchoftheMagiDebuff) and var_opener) then
    var_opener = false
  end
end

local function CooldownPhase()
  -- touch_of_the_magi,use_off_gcd=1,if=prev_gcd.1.arcane_barrage
  if S.TouchoftheMagi:IsReady() and UseTouchOfTheMagi and ((TouchOfTheMagiWithMiniCD and MiniCDs) or not TouchOfTheMagiWithMiniCD) and FightRemainsCheck < FightRemains and (Player:PrevGCDP(1, S.ArcaneBarrage)) then
    if Press(S.TouchoftheMagi) then return "touch_of_the_magi cooldown_phase 2"; end
  end
  -- variable,name=conserve_mana,op=set,if=cooldown.radiant_spark.ready,value=0+(cooldown.arcane_surge.remains<10)
  -- Note: Removed "0+". No need to add zero.
  if S.RadiantSpark:CooldownUp() then
    var_conserve_mana = num(S.ArcaneSurge:CooldownRemains() < 10)
  end
  -- shifting_power,if=buff.arcane_surge.down&!talent.radiant_spark
  if S.ShiftingPower:IsReady() and UseShiftingPower and ((CDs and ShiftingPowerWithCD) or not ShiftingPowerWithCD) and FightRemainsCheck < FightRemains and (Player:BuffDown(S.ArcaneSurgeBuff) and not S.RadiantSpark:IsAvailable()) then
    if Press(S.ShiftingPower, not Target:IsInRange(18), true) then return "shifting_power cooldown_phase 4"; end
  end
  -- arcane_orb,if=cooldown.radiant_spark.ready&buff.arcane_charge.stack<buff.arcane_charge.max_stack
  if S.ArcaneOrb:IsReady() and UseArcaneOrb and ArcaneOrbWithMiniCD and MiniCDs and FightRemainsCheck < FightRemains and (S.RadiantSpark:CooldownUp() and Player:ArcaneCharges() < Player:ArcaneChargesMax()) then
    if Press(S.ArcaneOrb, not Target:IsInRange(40)) then return "arcane_orb cooldown_phase 6"; end
  end
  -- arcane_blast,if=cooldown.radiant_spark.ready&(buff.arcane_charge.stack<2|(buff.arcane_charge.stack<buff.arcane_charge.max_stack&cooldown.arcane_orb.remains>=gcd.max))
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (S.RadiantSpark:CooldownUp() and (Player:ArcaneCharges() < 2 or (Player:ArcaneCharges() < Player:ArcaneChargesMax() and S.ArcaneOrb:CooldownRemains() >= GCDMax))) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast cooldown_phase 8"; end
  end
  -- arcane_missiles,if=cooldown.radiant_spark.ready&buff.clearcasting.react&(talent.nether_precision&(buff.nether_precision.down|buff.nether_precision.remains<gcd.max))
  if S.ArcaneMissiles:IsReady() and UseArcaneMissiles and (S.RadiantSpark:CooldownUp() and Player:BuffUp(S.ClearcastingBuff) and (S.NetherPrecision:IsAvailable() and (Player:BuffDown(S.NetherPrecisionBuff) or Player:BuffRemains(S.NetherPrecisionBuff) < GCDMax))) then
    if Press(S.ArcaneMissiles, not Target:IsSpellInRange(S.ArcaneMissiles)) then return "arcane_missiles cooldown_phase 10"; end
  end
  -- radiant_spark
  if S.RadiantSpark:IsReady() and UseRadiantSpark and ((RadiantSparkWithMiniCD and MiniCDs) or not RadiantSparkWithMiniCD) and FightRemainsCheck < FightRemains then
    if Press(S.RadiantSpark, not Target:IsSpellInRange(S.RadiantSpark), true) then return "radiant_spark cooldown_phase 12"; end
  end
  -- nether_tempest,if=talent.arcane_echo,line_cd=30
  if S.NetherTempest:IsReady() and UseNetherTempest and S.NetherTempest:TimeSinceLastCast() >= 30 and (S.ArcaneEcho:IsAvailable()) then
    if Press(S.NetherTempest, not Target:IsSpellInRange(S.NetherTempest)) then return "nether_tempest cooldown_phase 14"; end
  end
  -- arcane_surge
  if S.ArcaneSurge:IsReady() and UseArcaneSurge and ((ArcaneSurgeWithCD and CDs) or not ArcaneSurgeWithCD) and FightRemainsCheck < FightRemains then
    if Press(S.ArcaneSurge, not Target:IsSpellInRange(S.ArcaneSurge), true) then return "arcane_surge cooldown_phase 16"; end
  end
  -- wait,sec=0.05,if=prev_gcd.1.arcane_surge,line_cd=15
  -- arcane_barrage,if=prev_gcd.1.arcane_surge|prev_gcd.1.nether_tempest|prev_gcd.1.radiant_spark
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (Player:PrevGCDP(1, S.ArcaneSurge) or Player:PrevGCDP(1, S.NetherTempest) or Player:PrevGCDP(1, S.RadiantSpark)) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage cooldown_phase 18"; end
  end
  -- arcane_blast,if=prev_gcd.1.arcane_barrage|prev_gcd.2.arcane_barrage|prev_gcd.3.arcane_barrage|(prev_gcd.4.arcane_barrage&cooldown.arcane_surge.remains<60)
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (Player:PrevGCDP(1, S.ArcaneBarrage) or Player:PrevGCDP(2, S.ArcaneBarrage) or Player:PrevGCDP(3, S.ArcaneBarrage) or (Player:PrevGCDP(4, S.ArcaneBarrage) and S.ArcaneSurge:CooldownRemains() < 60)) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast cooldown_phase 20"; end
  end
  -- presence_of_mind,if=debuff.touch_of_the_magi.remains<=gcd.max
  if S.PresenceofMind:IsCastable() and UsePresenceOfMind and (not Player:IsChanneling()) and (Target:DebuffRemains(S.TouchoftheMagiDebuff) <= GCDMax) then
    if Press(S.PresenceofMind) then return "presence_of_mind cooldown_phase 22"; end
  end
  -- arcane_blast,if=buff.presence_of_mind.up
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (Player:BuffUp(S.PresenceofMindBuff)) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast)) then return "arcane_blast cooldown_phase 24"; end
  end
  -- cancel_action,if=action.arcane_missiles.channeling&gcd.remains=0&mana.pct>30&buff.nether_precision.up
  if Player:IsChanneling(S.ArcaneMissiles) and Player:GCDRemains() == 0 and Player:ManaPercentage() > 30 and Player:BuffUp(S.NetherPrecisionBuff) then
    if Press(M.StopCasting) then return "cancel arcane_missiles cooldown_phase 26"; end
  end
  -- arcane_missiles,if=buff.nether_precision.down&buff.clearcasting.react
  if S.ArcaneMissiles:IsReady() and UseArcaneMissiles and (Player:BuffDown(S.NetherPrecisionBuff) and Player:BuffUp(S.ClearcastingBuff)) then
    if Press(S.ArcaneMissiles, not Target:IsSpellInRange(S.ArcaneMissiles)) then return "arcane_missiles cooldown_phase 28"; end
  end
  -- arcane_blast
  if S.ArcaneBlast:IsReady() and UseArcaneBlast then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast cooldown_phase 30"; end
  end
end

local function SparkPhase()
  -- nether_tempest,if=!ticking&variable.opener&buff.bloodlust.up,line_cd=45
  if S.NetherTempest:IsReady() and UseNetherTempest and S.NetherTempest:TimeSinceLastCast() >= 45 and (Target:DebuffDown(S.NetherTempestDebuff) and var_opener and Player:BloodlustUp()) then
    if Press(S.NetherTempest, not Target:IsSpellInRange(S.NetherTempest)) then return "nether_tempest spark_phase 2"; end
  end
  -- arcane_blast,if=variable.opener&cooldown.arcane_surge.ready&buff.bloodlust.up&mana>=variable.opener_min_mana
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (var_opener and S.ArcaneSurge:CooldownUp() and Player:BloodlustUp() and Player:Mana() >= var_opener_min_mana) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast spark_phase 4"; end
  end
  -- arcane_missiles,if=variable.opener&buff.bloodlust.up&buff.clearcasting.react&buff.clearcasting.stack>=2&cooldown.radiant_spark.remains<5&buff.nether_precision.down,chain=1
  if S.ArcaneMissiles:IsCastable() and UseArcaneMissiles and (var_opener and Player:BloodlustUp() and Player:BuffUp(S.ClearcastingBuff) and Player:BuffStack(S.ClearcastingBuff) >= 2 and S.RadiantSpark:CooldownRemains() < 5 and Player:BuffDown(S.NetherPrecisionBuff)) then
    if Press(S.ArcaneMissiles, not Target:IsSpellInRange(S.ArcaneMissiles)) then return "arcane_missiles spark_phase 6"; end
  end
  -- arcane_missiles,if=talent.arcane_harmony&buff.arcane_harmony.stack<15&((variable.opener&buff.bloodlust.up)|buff.clearcasting.react&cooldown.radiant_spark.remains<5)&cooldown.arcane_surge.remains<30,chain=1
  if S.ArcaneMissiles:IsReady() and UseArcaneMissiles and (S.ArcaneHarmony:IsAvailable() and Player:BuffStack(S.ArcaneHarmonyBuff) < 15 and ((var_opener and Player:BloodlustUp()) or Player:BuffUp(S.ClearcastingBuff) and S.RadiantSpark:CooldownRemains() < 5) and S.ArcaneSurge:CooldownRemains() < 30) then
    if Press(S.ArcaneMissiles, not Target:IsSpellInRange(S.ArcaneMissiles)) then return "arcane_missiles spark_phase 8"; end
  end
  -- radiant_spark
  if S.RadiantSpark:IsReady() and UseRadiantSpark and ((RadiantSparkWithMiniCD and MiniCDs) or not RadiantSparkWithMiniCD) and FightRemainsCheck < FightRemains then
    if Press(S.RadiantSpark, not Target:IsSpellInRange(S.RadiantSpark)) then return "radiant_spark spark_phase 10"; end
  end
  -- nether_tempest,if=(prev_gcd.4.radiant_spark&cooldown.arcane_surge.remains<=execute_time)|prev_gcd.5.radiant_spark,line_cd=15
  if S.NetherTempest:IsReady() and UseNetherTempest and S.NetherTempest:TimeSinceLastCast() >= 15 and ((Player:PrevGCDP(4, S.RadiantSpark) and S.ArcaneSurge:CooldownRemains() <= S.NetherTempest:ExecuteTime()) or Player:PrevGCDP(5, S.RadiantSpark)) then
    if Press(S.NetherTempest, not Target:IsSpellInRange(S.NetherTempest)) then return "nether_tempest spark_phase 12"; end
  end
  -- arcane_surge,if=(!talent.nether_tempest&prev_gcd.4.radiant_spark)|prev_gcd.1.nether_tempest
  if S.ArcaneSurge:IsReady() and UseArcaneSurge and ((ArcaneSurgeWithCD and CDs) or not ArcaneSurgeWithCD) and FightRemainsCheck < FightRemains  and (((not S.NetherTempest:IsAvailable()) and Player:PrevGCDP(4, S.RadiantSpark)) or Player:PrevGCDP(1, S.NetherTempest)) then
    if Press(S.ArcaneSurge, not Target:IsSpellInRange(S.ArcaneSurge), true) then return "arcane_surge spark_phase 14"; end
  end
  -- arcane_blast,if=cast_time>=gcd&execute_time<debuff.radiant_spark_vulnerability.remains&(!talent.arcane_bombardment|target.health.pct>=35)&(talent.nether_tempest&prev_gcd.6.radiant_spark|!talent.nether_tempest&prev_gcd.5.radiant_spark)
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (S.ArcaneBlast:CastTime() >= Player:GCD() and S.ArcaneBlast:ExecuteTime() < Target:DebuffRemains(S.RadiantSparkVulnerability) and ((not S.ArcaneBombardment:IsAvailable()) or Target:HealthPercentage() >= 35) and (S.NetherTempest:IsAvailable() and Player:PrevGCDP(6, S.RadiantSpark) or (not S.NetherTempest:IsAvailable()) and Player:PrevGCDP(5, S.RadiantSpark))) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast spark_phase 16"; end
  end
  -- wait,sec=0.05,if=(talent.nether_tempest&prev_gcd.6.radiant_spark)|(!talent.nether_tempest&prev_gcd.5.radiant_spark),line_cd=15
  -- arcane_barrage,if=debuff.radiant_spark_vulnerability.stack=4
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (Target:DebuffStack(S.RadiantSparkVulnerability) == 4) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage spark_phase 18"; end
  end
  -- touch_of_the_magi,use_off_gcd=1,if=prev_gcd.1.arcane_barrage&(action.arcane_barrage.in_flight_remains<=0.2|gcd.remains<=0.2)
  if S.TouchoftheMagi:IsReady() and UseTouchOfTheMagi and ((TouchOfTheMagiWithMiniCD and MiniCDs) or not TouchOfTheMagiWithMiniCD) and FightRemainsCheck < FightRemains and (Player:PrevGCDP(1, S.ArcaneBarrage) and (S.ArcaneBarrage:InFlight() and S.ArcaneBarrage:TravelTime() - S.ArcaneBarrage:TimeSinceLastCast() <= 0.2 or Player:GCDRemains() <= 0.2)) then
    if Press(S.TouchoftheMagi) then return "touch_of_the_magi spark_phase 20"; end
  end
  -- arcane_blast
  if S.ArcaneBlast:IsReady() and UseArcaneBlast then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast spark_phase 22"; end
  end
  -- arcane_barrage
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage spark_phase 24"; end
  end
end

local function AoeSparkPhase()
  -- cancel_buff,name=presence_of_mind,if=prev_gcd.1.arcane_blast&cooldown.arcane_surge.remains>75
  -- TODO: Add handling for buff removal
  if Player:BuffUp(S.PresenceofMindBuff) and CancelPOMSetting and (Player:PrevGCDP(1, S.ArcaneBlast)) and Player:CooldownRemains(S.ArcaneSurge) > 75 then
    if Press(M.CancelPOM) then return "cancel presence_of_mind aoe_spark_phase 1"; end
  end
  -- touch_of_the_magi,use_off_gcd=1,if=prev_gcd.1.arcane_barrage
  if S.TouchoftheMagi:IsReady() and UseTouchOfTheMagi and ((TouchOfTheMagiWithMiniCD and MiniCDs) or not TouchOfTheMagiWithMiniCD) and FightRemainsCheck < FightRemains and (Player:PrevGCDP(1, S.ArcaneBarrage)) then
    if Press(S.TouchoftheMagi) then return "touch_of_the_magi aoe_spark_phase 2"; end
  end
  -- radiant_spark
  if S.RadiantSpark:IsReady() and UseRadiantSpark and ((RadiantSparkWithMiniCD and MiniCDs) or not RadiantSparkWithMiniCD) and FightRemainsCheck < FightRemains then
    if Press(S.RadiantSpark, not Target:IsSpellInRange(S.RadiantSpark), true) then return "radiant_spark aoe_spark_phase 4"; end
  end
  -- arcane_orb,if=buff.arcane_charge.stack<3,line_cd=15
  if S.ArcaneOrb:IsReady() and UseArcaneOrb and ArcaneOrbWithMiniCD and MiniCDs and FightRemainsCheck < FightRemains  and S.ArcaneOrb:TimeSinceLastCast() >= 15 and (Player:ArcaneCharges() < 3) then
    if Press(S.ArcaneOrb, not Target:IsInRange(40)) then return "arcane_orb aoe_spark_phase 6"; end
  end
  -- nether_tempest,if=talent.arcane_echo,line_cd=15
  if S.NetherTempest:IsReady() and UseNetherTempest and S.NetherTempest:TimeSinceLastCast() >= 15 and (S.ArcaneEcho:IsAvailable()) then
    if Press(S.NetherTempest, not Target:IsSpellInRange(S.NetherTempest)) then return "nether_tempest aoe_spark_phase 8"; end
  end
  -- arcane_surge
  if S.ArcaneSurge:IsReady() and UseArcaneSurge and ((ArcaneSurgeWithCD and CDs) or not ArcaneSurgeWithCD) and FightRemainsCheck < FightRemains then
    if Press(S.ArcaneSurge, not Target:IsSpellInRange(S.ArcaneSurge), true) then return "arcane_surge aoe_spark_phase 10"; end
  end
  -- wait,sec=0.05,if=cooldown.arcane_surge.remains>75&prev_gcd.1.arcane_blast&!talent.presence_of_mind,line_cd=15
  -- wait,sec=0.05,if=prev_gcd.1.arcane_surge,line_cd=15
  -- wait,sec=0.05,if=cooldown.arcane_surge.remains<75&debuff.radiant_spark_vulnerability.stack=3&!talent.presence_of_mind,line_cd=15
  -- arcane_barrage,if=cooldown.arcane_surge.remains<75&debuff.radiant_spark_vulnerability.stack=4&!talent.orb_barrage
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (S.ArcaneSurge:CooldownRemains() < 75 and Target:DebuffStack(S.RadiantSparkVulnerability) == 4 and not S.OrbBarrage:IsAvailable()) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage aoe_spark_phase 12"; end
  end
  -- arcane_barrage,if=(debuff.radiant_spark_vulnerability.stack=2&cooldown.arcane_surge.remains>75)|(debuff.radiant_spark_vulnerability.stack=1&cooldown.arcane_surge.remains<75)&!talent.orb_barrage
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and ((Target:DebuffStack(S.RadiantSparkVulnerability) == 2 and S.ArcaneSurge:CooldownRemains() > 75) or (Target:DebuffStack(S.RadiantSparkVulnerability) == 1 and S.ArcaneSurge:CooldownRemains() < 75) and not S.OrbBarrage:IsAvailable()) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage aoe_spark_phase 14"; end
  end
  -- arcane_barrage,if=(debuff.radiant_spark_vulnerability.stack=1|debuff.radiant_spark_vulnerability.stack=2|(debuff.radiant_spark_vulnerability.stack=3&active_enemies>5)|debuff.radiant_spark_vulnerability.stack=4)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&talent.orb_barrage
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and ((Target:DebuffStack(S.RadiantSparkVulnerability) == 1 or Target:DebuffStack(S.RadiantSparkVulnerability) == 2 or (Target:DebuffStack(S.RadiantSparkVulnerability) == 3 and (EnemiesCount8ySplash > 5 or EnemiesCount10yMelee > 5)) or Target:DebuffStack(S.RadiantSparkVulnerability) == 4) and Player:ArcaneCharges() == Player:ArcaneChargesMax() and S.OrbBarrage:IsAvailable()) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage aoe_spark_phase 16"; end
  end
  -- presence_of_mind
  if S.PresenceofMind:IsCastable() and UsePresenceOfMind and (not Player:IsChanneling()) then
    if Press(S.PresenceofMind) then return "presence_of_mind aoe_spark_phase 18"; end
  end
  -- arcane_blast,if=((debuff.radiant_spark_vulnerability.stack=2|debuff.radiant_spark_vulnerability.stack=3)&!talent.orb_barrage)|(debuff.radiant_spark_vulnerability.remains&talent.orb_barrage)
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (((Target:DebuffStack(S.RadiantSparkVulnerability) == 2 or Target:DebuffStack(S.RadiantSparkVulnerability) == 3) and not S.OrbBarrage:IsAvailable()) or (Target:DebuffUp(S.RadiantSparkVulnerability) and S.OrbBarrage:IsAvailable())) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast aoe_spark_phase 20"; end
  end
  -- arcane_barrage,if=(debuff.radiant_spark_vulnerability.stack=4&buff.arcane_surge.up)|(debuff.radiant_spark_vulnerability.stack=3&buff.arcane_surge.down)&!talent.orb_barrage
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and ((Target:DebuffStack(S.RadiantSparkVulnerability) == 4 and Player:BuffUp(S.ArcaneSurgeBuff)) or (Target:DebuffStack(S.RadiantSparkVulnerability) == 3 and Player:BuffDown(S.ArcaneSurgeBuff)) and not S.OrbBarrage:IsAvailable()) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage aoe_spark_phase 22"; end
  end
end

local function TouchPhase()
  -- variable,name=conserve_mana,op=set,if=debuff.touch_of_the_magi.remains>9,value=1-variable.conserve_mana
  if Target:DebuffRemains(S.TouchoftheMagiDebuff) > 9 then
    var_conserve_mana = bool(1 - num(var_conserve_mana))
  end
  -- presence_of_mind,if=debuff.touch_of_the_magi.remains<=gcd.max
  if S.PresenceofMind:IsCastable()and UsePresenceOfMind and (not Player:IsChanneling()) and (Target:DebuffRemains(S.TouchoftheMagiDebuff) <= GCDMax) then
    if Press(S.PresenceofMind) then return "presence_of_mind touch_phase 2"; end
  end
  -- arcane_blast,if=buff.presence_of_mind.up&buff.arcane_charge.stack=buff.arcane_charge.max_stack
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (Player:BuffUp(S.PresenceofMindBuff) and Player:ArcaneCharges() == Player:ArcaneChargesMax()) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast)) then return "arcane_blast touch_phase 4"; end
  end
  -- arcane_barrage,if=(buff.arcane_harmony.up|(talent.arcane_bombardment&target.health.pct<35))&debuff.touch_of_the_magi.remains<=gcd.max
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and ((Player:BuffUp(S.ArcaneHarmonyBuff) or (S.ArcaneBombardment:IsAvailable() and Target:HealthPercentage() < 35)) and Target:DebuffRemains(S.TouchoftheMagiDebuff) <= GCDMax) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage touch_phase 6"; end
  end
  -- arcane_missiles,if=buff.clearcasting.stack>1&talent.conjure_mana_gem&cooldown.use_mana_gem.ready,chain=1
  if S.ArcaneMissiles:IsCastable() and UseArcaneMissiles and (Player:BuffStack(S.ClearcastingBuff) > 1 and S.ConjureManaGem:IsAvailable() and I.ManaGem:CooldownUp()) then
    if Press(S.ArcaneMissiles, not Target:IsSpellInRange(S.ArcaneMissiles)) then return "arcane_missiles touch_phase 8"; end
  end
  -- arcane_blast,if=buff.nether_precision.up
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (Player:BuffUp(S.NetherPrecisionBuff)) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast touch_phase 10"; end
  end
  -- arcane_missiles,if=buff.clearcasting.react&(debuff.touch_of_the_magi.remains>execute_time|!talent.presence_of_mind),chain=1
  if S.ArcaneMissiles:IsCastable() and UseArcaneMissiles and (Player:BuffUp(S.ClearcastingBuff) and (Target:DebuffRemains(S.TouchoftheMagiDebuff) > S.ArcaneMissiles:CastTime() or not S.PresenceofMind:IsAvailable())) then
    if Press(S.ArcaneMissiles, not Target:IsSpellInRange(S.ArcaneMissiles)) then return "arcane_missiles touch_phase 12"; end
  end
  -- arcane_blast
  if S.ArcaneBlast:IsReady() and UseArcaneBlast then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast touch_phase 14"; end
  end
  -- arcane_barrage
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage touch_phase 16"; end
  end
end

local function AoeTouchPhase()
  -- variable,name=conserve_mana,op=set,if=debuff.touch_of_the_magi.remains>9,value=1-variable.conserve_mana
  if Target:DebuffRemains(S.TouchoftheMagiDebuff) > 9 then
    var_conserve_mana = bool(1 - num(var_conserve_mana))
  end
  -- arcane_barrage,if=(active_enemies<=4&buff.arcane_charge.stack=3)|buff.arcane_charge.stack=buff.arcane_charge.max_stack
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (((EnemiesCount8ySplash <= 4 and EnemiesCount10yMelee <= 4) and Player:ArcaneCharges() == 3) or Player:ArcaneCharges() == Player:ArcaneChargesMax()) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage aoe_touch_phase 2"; end
  end
  -- arcane_orb,if=buff.arcane_charge.stack<2
  if S.ArcaneOrb:IsReady() and UseArcaneOrb and ((ArcaneOrbWithMiniCD and MiniCDs) or not ArcaneOrbWithMiniCD) and FightRemainsCheck < FightRemains and (Player:ArcaneCharges() < 2) then
    if Press(S.ArcaneOrb, not Target:IsInRange(40)) then return "arcane_orb aoe_touch_phase 4"; end
  end
  -- arcane_explosion
  if S.ArcaneExplosion:IsReady() and UseArcaneExplosion then
    if Press(S.ArcaneExplosion, not Target:IsInRange(10)) then return "arcane_explosion aoe_touch_phase 6"; end
  end
end

local function Rotation()
  -- arcane_orb,if=buff.arcane_charge.stack<3&(buff.bloodlust.down|mana.pct>70|(variable.totm_on_last_spark_stack&cooldown.touch_of_the_magi.remains>30))
  if S.ArcaneOrb:IsReady() and UseArcaneOrb and ((ArcaneOrbWithMiniCD and MiniCDs) or not ArcaneOrbWithMiniCD) and FightRemainsCheck < FightRemains and (Player:ArcaneCharges() < 3 and (Player:BloodlustDown() or Player:ManaPercentage() > 70 or (var_totm_on_last_spark_stack and S.TouchoftheMagi:CooldownRemains() > 30))) then
    if Press(S.ArcaneOrb, not Target:IsInRange(40)) then return "arcane_orb rotation 2"; end
  end
  -- shifting_power,if=variable.totm_on_last_spark_stack&(!talent.evocation|cooldown.evocation.remains>12)&(!talent.arcane_surge|cooldown.arcane_surge.remains>12)&(!talent.touch_of_the_magi|cooldown.touch_of_the_magi.remains>12)&buff.arcane_surge.down&fight_remains>15
  if S.ShiftingPower:IsReady() and UseShiftingPower and ((CDs and ShiftingPowerWithCD) or not ShiftingPowerWithCD) and FightRemainsCheck < FightRemains and (var_totm_on_last_spark_stack and ((not S.Evocation:IsAvailable()) or S.Evocation:CooldownRemains() > 12) and ((not S.ArcaneSurge:IsAvailable()) or S.ArcaneSurge:CooldownRemains() > 12) and ((not S.TouchoftheMagi:IsAvailable()) or S.TouchoftheMagi:CooldownRemains() > 12) and Player:BuffDown(S.ArcaneSurgeBuff) and FightRemains > 15) then
    if Press(S.ShiftingPower, not Target:IsInRange(18)) then return "shifting_power rotation 4"; end
  end
  -- shifting_power,if=!variable.totm_on_last_spark_stack&buff.arcane_surge.down&cooldown.arcane_surge.remains>45&fight_remains>15
  if S.ShiftingPower:IsReady() and UseShiftingPower and ((CDs and ShiftingPowerWithCD) or not ShiftingPowerWithCD) and FightRemainsCheck < FightRemains and ((not var_totm_on_last_spark_stack) and Player:BuffDown(S.ArcaneSurgeBuff) and S.ArcaneSurge:CooldownRemains() > 45 and FightRemains > 15) then
    if Press(S.ShiftingPower, not Target:IsInRange(18)) then return "shifting_power rotation 6"; end
  end
  -- nether_tempest,if=(refreshable|!ticking)&equipped.neltharions_call_to_chaos&fight_remains>=12
  --if S.NetherTempest:IsReady() and (Target:DebuffRefreshable(S.NetherTempestDebuff) and I.NeltharionsCalltoChaos:IsEquipped() and FightRemains >= 12) then
  --  if Press(S.NetherTempest, not Target:IsSpellInRange(S.NetherTempest)) then return "nether_tempest rotation 7"; end
  --end
  -- presence_of_mind,if=buff.arcane_charge.stack<3&target.health.pct<35&talent.arcane_bombardment
  if S.PresenceofMind:IsCastable() and UsePresenceOfMind and (not Player:IsChanneling()) and (Player:ArcaneCharges() < 3 and Target:HealthPercentage() < 35 and S.ArcaneBombardment:IsAvailable()) then
    if Press(S.PresenceofMind) then return "presence_of_mind rotation 8"; end
  end
  -- arcane_blast,if=talent.time_anomaly&buff.arcane_surge.up&buff.arcane_surge.remains<=6
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (S.TimeAnomaly:IsAvailable() and Player:BuffUp(S.ArcaneSurgeBuff) and Player:BuffRemains(S.ArcaneSurgeBuff) <= 6) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast rotation 10"; end
  end
  -- arcane_blast,if=buff.presence_of_mind.up&target.health.pct<35&talent.arcane_bombardment&buff.arcane_charge.stack<3
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (Player:BuffUp(S.PresenceofMindBuff) and Target:HealthPercentage() < 35 and S.ArcaneBombardment:IsAvailable() and Player:ArcaneCharges() < 3) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast)) then return "arcane_blast rotation 12"; end
  end
  -- arcane_missiles,if=buff.clearcasting.react&buff.clearcasting.stack=buff.clearcasting.max_stack
  if S.ArcaneMissiles:IsCastable() and UseArcaneMissiles and (Player:BuffUp(S.ClearcastingBuff) and Player:BuffStack(S.ClearcastingBuff) == ClearCastingMaxStack) then
    if Press(S.ArcaneMissiles, not Target:IsSpellInRange(S.ArcaneMissiles)) then return "arcane_missiles rotation 14"; end
  end
  -- nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&(buff.temporal_warp.up|mana.pct<10|!talent.shifting_power)&buff.arcane_surge.down&fight_remains>=12
  if S.NetherTempest:IsReady() and UseNetherTempest and (Target:DebuffRefreshable(S.NetherTempestDebuff) and Player:ArcaneCharges() == Player:ArcaneChargesMax() and (Player:BuffUp(S.TemporalWarpBuff) or Player:ManaPercentage() < 10 or not S.ShiftingPower:IsAvailable()) and Player:BuffDown(S.ArcaneSurgeBuff) and FightRemains >= 12) then
    if Press(S.NetherTempest, not Target:IsSpellInRange(S.NetherTempest)) then return "nether_tempest rotation 16"; end
  end
  -- arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&mana.pct<50&!talent.evocation&fight_remains>20
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (Player:ArcaneCharges() == Player:ArcaneChargesMax() and Player:ManaPercentage() < 50 and (not S.Evocation:IsAvailable()) and FightRemains > 20) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage rotation 18"; end
  end
  -- arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&mana.pct<70&variable.conserve_mana&buff.bloodlust.up&cooldown.touch_of_the_magi.remains>5&fight_remains>20
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (Player:ArcaneCharges() == Player:ArcaneChargesMax() and Player:ManaPercentage() < 70 and var_conserve_mana and Player:BloodlustUp() and S.TouchoftheMagi:CooldownRemains() > 5 and FightRemains > 20) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage rotation 20"; end
  end
  -- arcane_missiles,if=buff.clearcasting.react&buff.concentration.up&buff.arcane_charge.stack=buff.arcane_charge.max_stack
  if S.ArcaneMissiles:IsCastable() and UseArcaneMissiles and (Player:BuffUp(S.ClearcastingBuff) and Player:BuffUp(S.ConcentrationBuff) and Player:ArcaneCharges() == Player:ArcaneChargesMax()) then
    if Press(S.ArcaneMissiles, not Target:IsSpellInRange(S.ArcaneMissiles)) then return "arcane_missiles rotation 22"; end
  end
  -- arcane_blast,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.nether_precision.up
  if S.ArcaneBlast:IsReady() and UseArcaneBlast and (Player:ArcaneCharges() == Player:ArcaneChargesMax() and Player:BuffUp(S.NetherPrecisionBuff)) then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast rotation 24"; end
  end
  -- arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&mana.pct<60&variable.conserve_mana&cooldown.touch_of_the_magi.remains>10&cooldown.evocation.remains>40&fight_remains>20
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (Player:ArcaneCharges() == Player:ArcaneChargesMax() and Player:ManaPercentage() < 60 and var_conserve_mana and S.TouchoftheMagi:CooldownRemains() > 10 and S.Evocation:CooldownRemains() > 40 and FightRemains > 20) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage rotation 26"; end
  end
  -- cancel_action,if=action.arcane_missiles.channeling&gcd.remains=0&&buff.nether_precision.up&(mana.pct>30&cooldown.touch_of_the_magi.remains>30|mana.pct>70)
  -- cancel_action,if=action.arcane_missiles.channeling&gcd.remains=0&mana.pct>30&buff.nether_precision.up
  if Player:IsChanneling(S.ArcaneMissiles) and Player:GCDRemains() == 0 and Player:BuffUp(S.NetherPrecisionBuff) and (Player:ManaPercentage() > 30 and S.TouchoftheMagi:CooldownRemains() > 30 or Player:ManaPercentage() > 70) then
    if Press(M.StopCasting, nil, nil, true) then return "cancel_action arcane_missiles rotation 28"; end
  end
  -- arcane_missiles,if=buff.clearcasting.react&buff.nether_precision.down
  if S.ArcaneMissiles:IsCastable() and UseArcaneMissiles and (Player:BuffUp(S.ClearcastingBuff) and Player:BuffDown(S.NetherPrecisionBuff)) then
    if Press(S.ArcaneMissiles, not Target:IsSpellInRange(S.ArcaneMissiles)) then return "arcane_missiles rotation 30"; end
  end
  -- arcane_blast
  if S.ArcaneBlast:IsReady() and UseArcaneBlast then
    if Press(S.ArcaneBlast, not Target:IsSpellInRange(S.ArcaneBlast), true) then return "arcane_blast rotation 32"; end
  end
  -- arcane_barrage
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage rotation 34"; end
  end
end

local function AoeRotation()
  -- shifting_power,if=(!talent.evocation|cooldown.evocation.remains>12)&(!talent.arcane_surge|cooldown.arcane_surge.remains>12)&(!talent.touch_of_the_magi|cooldown.touch_of_the_magi.remains>12)&buff.arcane_surge.down&((!talent.charged_orb&cooldown.arcane_orb.remains>12)|(action.arcane_orb.charges=0|cooldown.arcane_orb.remains>12))
  if S.ShiftingPower:IsReady() and UseShiftingPower and ((CDs and ShiftingPowerWithCD) or not ShiftingPowerWithCD) and FightRemainsCheck < FightRemains and (((not S.Evocation:IsAvailable()) or S.Evocation:CooldownRemains() > 12) and ((not S.ArcaneSurge:IsAvailable()) or S.ArcaneSurge:CooldownRemains() > 12) and ((not S.TouchoftheMagi:IsAvailable()) or S.TouchoftheMagi:CooldownRemains() > 12) and Player:BuffDown(S.ArcaneSurgeBuff) and (((not S.ChargedOrb:IsAvailable()) and S.ArcaneOrb:CooldownRemains() > 12) or (S.ArcaneOrb:Charges() == 0 or S.ArcaneOrb:CooldownRemains() > 12))) then
    if Press(S.ShiftingPower, not Target:IsInRange(18), true) then return "shifting_power aoe_rotation 2"; end
  end
  -- nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.arcane_surge.down&(active_enemies>6|!talent.orb_barrage)
  if S.NetherTempest:IsReady() and UseNetherTempest and (Target:DebuffRefreshable(S.NetherTempestDebuff) and Player:ArcaneCharges() == Player:ArcaneChargesMax() and Player:BuffDown(S.ArcaneSurgeBuff) and ((EnemiesCount8ySplash > 6 or EnemiesCount10yMelee > 6) or not S.OrbBarrage:IsAvailable())) then
    if Press(S.NetherTempest, not Target:IsSpellInRange(S.NetherTempest)) then return "nether_tempest aoe_rotation 4"; end
  end
  -- arcane_barrage,if=(active_enemies<=4|buff.clearcasting.up)&buff.arcane_charge.stack=3
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (((EnemiesCount8ySplash <= 4 and EnemiesCount10yMelee <= 4) or Player:BuffUp(S.ClearcastingBuff)) and Player:ArcaneCharges() == 3) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage aoe_rotation 6"; end
  end
  -- arcane_orb,if=buff.arcane_charge.stack=0&cooldown.touch_of_the_magi.remains>18
  if S.ArcaneOrb:IsReady() and UseArcaneOrb and ((ArcaneOrbWithMiniCD and MiniCDs) or not ArcaneOrbWithMiniCD) and FightRemainsCheck < FightRemains and (Player:ArcaneCharges() == 0 and S.TouchoftheMagi:CooldownRemains() > 18) then
    if Press(S.ArcaneOrb, not Target:IsInRange(40)) then return "arcane_orb aoe_rotation 8"; end
  end
  -- arcane_barrage,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack|mana.pct<10
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (Player:ArcaneCharges() == Player:ArcaneChargesMax() or Player:ManaPercentage() < 10) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage aoe_rotation 10"; end
  end
  -- arcane_explosion
  if S.ArcaneExplosion:IsReady() and UseArcaneExplosion then
    if Press(S.ArcaneExplosion, not Target:IsInRange(10)) then return "arcane_explosion aoe_rotation 12"; end
  end
end

local function Combat()
  -- Manually added: touch_of_the_magi,if=prev_gcd.1.arcane_barrage
  if S.TouchoftheMagi:IsReady() and UseTouchOfTheMagi and ((TouchOfTheMagiWithMiniCD and MiniCDs) or not TouchOfTheMagiWithMiniCD) and FightRemainsCheck < FightRemains and (Player:PrevGCDP(1, S.ArcaneBarrage)) then
    if Press(S.TouchoftheMagi) then return "touch_of_the_magi main 30"; end
  end
  -- cancel_action,if=action.evocation.channeling&mana.pct>=95&!talent.siphon_storm
  -- cancel_action,if=action.evocation.channeling&(mana.pct>fight_remains*4)&!(fight_remains>10&cooldown.arcane_surge.remains<1)
  if Player:IsChanneling(S.Evocation) and ((Player:ManaPercentage() >= 95 and not S.SiphonStorm:IsAvailable()) or ((Player:ManaPercentage() > FightRemains * 4) and not (FightRemains > 10 and S.ArcaneSurge:CooldownRemains() < 1))) then
    if Press(M.StopCasting) then return "cancel_action evocation main 32"; end
  end
  -- arcane_barrage,if=fight_remains<2
  if S.ArcaneBarrage:IsReady() and UseArcaneBarrage and (FightRemains < 2) then
    if Press(S.ArcaneBarrage, not Target:IsSpellInRange(S.ArcaneBarrage)) then return "arcane_barrage main 34"; end
  end
  -- evocation,if=buff.arcane_surge.down&debuff.touch_of_the_magi.down&((mana.pct<10&cooldown.touch_of_the_magi.remains<20)|cooldown.touch_of_the_magi.remains<15)&(mana.pct<fight_remains*4)
  -- Note: Manually added var_opener check, as we don't want to cast Evocation during the initial opener.
  if S.Evocation:IsCastable() and UseEvocation and (not var_opener) and (Player:BuffDown(S.ArcaneSurgeBuff) and Target:DebuffDown(S.TouchoftheMagiDebuff) and ((Player:ManaPercentage() < 10 and S.TouchoftheMagi:CooldownRemains() < 20) or S.TouchoftheMagi:CooldownRemains() < 15) and (Player:ManaPercentage() < FightRemains * 4)) then
    if Press(S.Evocation) then return "evocation main 36"; end
  end
  -- conjure_mana_gem,if=debuff.touch_of_the_magi.down&buff.arcane_surge.down&cooldown.arcane_surge.remains<30&cooldown.arcane_surge.remains<fight_remains&!mana_gem_charges
  if S.ConjureManaGem:IsCastable() and UseConjureManaGem and (Target:DebuffDown(S.TouchoftheMagiDebuff) and Player:BuffDown(S.ArcaneSurgeBuff) and S.ArcaneSurge:CooldownRemains() < 30 and S.ArcaneSurge:CooldownRemains() < FightRemains and (not I.ManaGem:Exists())) then
    if Press(S.ConjureManaGem) then return "conjure_mana_gem main 38"; end
  end
  -- use_mana_gem,if=talent.cascading_power&buff.clearcasting.stack<2&buff.arcane_surge.up
  -- TODO: Fix hotkey issue, as item and spell use the same icon
  if I.ManaGem:IsReady() and UseManaGem and (S.CascadingPower:IsAvailable() and Player:BuffStack(S.ClearcastingBuff) < 2 and Player:BuffUp(S.ArcaneSurgeBuff)) then
    if Press(M.ManaGem) then return "mana_gem main 40"; end
  end
  -- use_mana_gem,if=!talent.cascading_power&prev_gcd.1.arcane_surge
  -- TODO: Fix hotkey issue, as item and spell use the same icon
  if I.ManaGem:IsReady() and UseManaGem and ((not S.CascadingPower:IsAvailable()) and Player:PrevGCDP(1, S.ArcaneSurge)) then
    if Press(M.ManaGem) then return "mana_gem main 42"; end
  end
  -- call_action_list,name=cooldown_phase,if=!variable.totm_on_last_spark_stack&(cooldown.arcane_surge.remains<=(gcd.max*(1+(talent.nether_tempest&talent.arcane_echo)))|buff.arcane_surge.up|buff.arcane_overload.up)&cooldown.evocation.remains>45&((cooldown.touch_of_the_magi.remains<gcd.max*4)|cooldown.touch_of_the_magi.remains>20)&active_enemies<variable.aoe_target_count
  if ((not var_totm_on_last_spark_stack) and (S.ArcaneSurge:CooldownRemains() <= (GCDMax * (1 + num(S.NetherTempest:IsAvailable() and S.ArcaneEcho:IsAvailable()))) or Player:BuffUp(S.ArcaneSurgeBuff) or Player:BuffUp(S.ArcaneOverloadBuff)) and S.Evocation:CooldownRemains() > 45 and ((S.TouchoftheMagi:CooldownRemains() < GCDMax * 4) or S.TouchoftheMagi:CooldownRemains() > 20) and EnemiesCount8ySplash < var_aoe_target_count and EnemiesCount10yMelee < var_aoe_target_count) then
    ShouldReturn = CooldownPhase(); if ShouldReturn then return ShouldReturn; end
  end
  -- call_action_list,name=cooldown_phase,if=!variable.totm_on_last_spark_stack&cooldown.arcane_surge.remains>30&(cooldown.radiant_spark.ready|dot.radiant_spark.remains|debuff.radiant_spark_vulnerability.up)&(cooldown.touch_of_the_magi.remains<=(gcd.max*3)|debuff.touch_of_the_magi.up)&active_enemies<variable.aoe_target_count
  if ((not var_totm_on_last_spark_stack) and S.ArcaneSurge:CooldownRemains() > 30 and (S.RadiantSpark:CooldownUp() or Target:DebuffUp(S.RadiantSparkDebuff) or Target:DebuffUp(S.RadiantSparkVulnerability)) and (S.TouchoftheMagi:CooldownRemains() <= GCDMax * 3 or Target:DebuffUp(S.TouchoftheMagiDebuff)) and EnemiesCount8ySplash < var_aoe_target_count and EnemiesCount10yMelee < var_aoe_target_count) then
    ShouldReturn = CooldownPhase(); if ShouldReturn then return ShouldReturn; end
  end
  -- call_action_list,name=aoe_spark_phase,if=talent.radiant_spark&variable.aoe_spark_phase
  if CDs and S.RadiantSpark:IsAvailable() and var_aoe_spark_phase then
    ShouldReturn = AoeSparkPhase(); if ShouldReturn then return ShouldReturn; end
  end
  -- call_action_list,name=spark_phase,if=variable.totm_on_last_spark_stack&talent.radiant_spark&variable.spark_phase
  if CDs and var_totm_on_last_spark_stack and S.RadiantSpark:IsAvailable() and var_spark_phase then
    ShouldReturn = SparkPhase(); if ShouldReturn then return ShouldReturn; end
  end
  -- call_action_list,name=aoe_touch_phase,if=debuff.touch_of_the_magi.up&active_enemies>=variable.aoe_target_count
  if CDs and Target:DebuffUp(S.TouchoftheMagiDebuff) and (EnemiesCount8ySplash >= var_aoe_target_count or EnemiesCount10yMelee >= var_aoe_target_count) then
    ShouldReturn = AoeTouchPhase(); if ShouldReturn then return ShouldReturn; end
  end
  -- call_action_list,name=touch_phase,if=variable.totm_on_last_spark_stack&debuff.touch_of_the_magi.up&active_enemies<variable.aoe_target_count
  if CDs and var_totm_on_last_spark_stack and Target:DebuffUp(S.TouchoftheMagiDebuff) and (EnemiesCount8ySplash >= var_aoe_target_count or EnemiesCount10yMelee >= var_aoe_target_count) then
    ShouldReturn = TouchPhase(); if ShouldReturn then return ShouldReturn; end
  end
  -- call_action_list,name=aoe_rotation,if=active_enemies>=variable.aoe_target_count
  if EnemiesCount8ySplash >= var_aoe_target_count or EnemiesCount10yMelee >= var_aoe_target_count then
    ShouldReturn = AoeRotation(); if ShouldReturn then return ShouldReturn; end
  end
  -- call_action_list,name=rotation
  ShouldReturn = Rotation(); if ShouldReturn then return ShouldReturn; end
end

local function FetchSettings()
  --Settings Use
  UseArcaneBlast = EpicSettings.Settings["useArcaneBlast"]
  UseArcaneBarrage = EpicSettings.Settings["useArcaneBarrage"]
  UseArcaneExplosion = EpicSettings.Settings["useArcaneExplosion"]
  UseArcaneFamiliar = EpicSettings.Settings["useArcaneFamiliar"]
  UseArcaneIntellect = EpicSettings.Settings["useArcaneIntellect"]
  UseArcaneMissiles = EpicSettings.Settings["useArcaneMissiles"]
  UseConjureManaGem = EpicSettings.Settings["useConjureManaGem"]
  UseEvocation = EpicSettings.Settings["useEvocation"]
  UseManaGem = EpicSettings.Settings["useManaGem"]
  UseNetherTempest = EpicSettings.Settings["useNetherTempest"]
  UsePresenceOfMind = EpicSettings.Settings["usePresenceOfMind"]

  --Settings Interrupt
  UseCounterspell = EpicSettings.Settings["useCounterspell"]
  UseBlastWave = EpicSettings.Settings["useBlastWave"]
  UseDragonsBreath = EpicSettings.Settings["useDragonsBreath"]

  --Settings Use With CD
  UseArcaneSurge = EpicSettings.Settings["useArcaneSurge"]
  UseShiftingPower = EpicSettings.Settings["useShiftingPower"]

  --Settings Use With MiniCD
  UseArcaneOrb = EpicSettings.Settings["useArcaneOrb"]
  UseRadiantSpark = EpicSettings.Settings["useRadiantSpark"]
  UseTouchOfTheMagi = EpicSettings.Settings["useTouchOfTheMagi"]

  --Settings WithCDs
  ArcaneSurgeWithCD = EpicSettings.Settings["arcaneSurgeWithCD"]
  ShiftingPowerWithCD = EpicSettings.Settings["shiftingPowerWithCD"]

  --Settings WithMiniCDs
  ArcaneOrbWithMiniCD = EpicSettings.Settings["arcaneOrbWithMiniCD"]
  RadiantSparkWithMiniCD = EpicSettings.Settings["radiantSparkWithMiniCD"]
  TouchOfTheMagiWithMiniCD = EpicSettings.Settings["touchOfTheMagiWithMiniCD"]

  --Settings UseDefensives
  UseAlterTime = EpicSettings.Settings["useAlterTime"]
  UsePrismaticBarrier = EpicSettings.Settings["usePrismaticBarrier"]
  UseGreaterInvisibility = EpicSettings.Settings["useGreaterInvisibility"]
  UseIceBlock = EpicSettings.Settings["useIceBlock"]
  UseMassBarrier = EpicSettings.Settings["useMassBarrier"]
  UseMirrorImage = EpicSettings.Settings["useMirrorImage"]

  --Settings DefensiveHP
  AlterTimeHP = EpicSettings.Settings["alterTimeHP"] or 0
  PrismaticBarrierHP = EpicSettings.Settings["prismaticBarrierHP"] or 0
  GreaterInvisibilityHP = EpicSettings.Settings["greaterInvisibilityHP"] or 0
  IceBlockHP = EpicSettings.Settings["iceBlockHP"] or 0
  MirrorImageHP = EpicSettings.Settings["mirrorImageHP"] or 0
 
  --Other Settings
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
  MiniCDs = EpicSettings.Toggles["minicds"]
  Kick = EpicSettings.Toggles["kick"]
  DispelToggle = EpicSettings.Toggles["dispel"]

  Enemies8ySplash = Target:GetEnemiesInSplashRange(8)
  Enemies10yMelee = Player:GetEnemiesInMeleeRange(10)
  if AOE then
    EnemiesCount8ySplash = Target:GetEnemiesInSplashRangeCount(8)
    EnemiesCount10yMelee = #Enemies10yMelee
  else
    EnemiesCount8ySplash = 1
    EnemiesCount10yMelee = 1
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
  end

  GCDMax = Player:GCD() + 0.25
  
  -- Afflicted
  if HandleAfflicted then
    if UseRemoveCurseWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.RemoveCurse, M.RemoveCurseMouseover, 30); if ShouldReturn then return ShouldReturn; end
    end
  end
  
  if not Player:AffectingCombat() then
    -- arcane_intellect
    if S.ArcaneIntellect:IsCastable() and UseArcaneIntellect and (Player:BuffDown(S.ArcaneIntellect, true) or Everyone.GroupBuffMissing(S.ArcaneIntellect)) then
      if Press(S.ArcaneIntellect) then return "arcane_intellect group_buff"; end
    end
    -- arcane_familiar
    if S.ArcaneFamiliar:IsCastable() and UseArcaneFamiliar and Player:BuffDown(S.ArcaneFamiliarBuff) then
      if Press(S.ArcaneFamiliar) then return "arcane_familiar precombat 2"; end
    end
    -- conjure_mana_gem
    -- TODO: Fix hotkey issue (spell and item use the same icon)
    if S.ConjureManaGem:IsCastable() and UseConjureManaGem then
      if Press(S.ConjureManaGem) then return "conjure_mana_gem precombat 4"; end
    end
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

    -- interrupt
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

    if not Player:IsCasting() and not Player:IsChanneling() then
      -- todo
      -- potion,if=cooldown.arcane_surge.ready-- potion
      local ShouldReturnPot = Everyone.HandleDPSPotion(not S.ArcaneSurge:IsReady()); if ShouldReturnPot then return ShouldReturnPot; end
    
      -- todo
      -- time_warp,if=talent.temporal_warp&buff.exhaustion.up&(cooldown.arcane_surge.ready|fight_remains<=40|buff.arcane_surge.up&fight_remains<=80)
      -- lights_judgment,if=buff.arcane_surge.down&debuff.touch_of_the_magi.down&active_enemies>=2
      if UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) and FightRemainsCheck < FightRemains then
        if S.LightsJudgment:IsCastable() and (Player:BuffDown(S.ArcaneSurgeBuff) and Target:DebuffDown(S.TouchoftheMagiDebuff) and (EnemiesCount8ySplash >= 2 or EnemiesCount10yMelee >= 2)) then
          if Press(S.LightsJudgment, not Target:IsSpellInRange(S.LightsJudgment)) then return "lights_judgment main 6"; end
        end
        -- berserking,if=(prev_gcd.1.arcane_surge&!(buff.temporal_warp.up&buff.bloodlust.up))|(buff.arcane_surge.up&debuff.touch_of_the_magi.up)
        if S.Berserking:IsCastable() and ((Player:PrevGCDP(1, S.ArcaneSurge) and (not (Player:BuffUp(S.TemporalWarpBuff) and Player:BloodlustUp()))) or Player:BuffUp(S.ArcaneSurgeBuff) and Target:DebuffUp(S.TouchoftheMagiDebuff)) then
          if Press(S.Berserking) then return "berserking main 8"; end
        end
        if Player:PrevGCDP(1, S.ArcaneSurge) then
          -- blood_fury,if=prev_gcd.1.arcane_surge
          if S.BloodFury:IsCastable() then
            if Press(S.BloodFury) then return "blood_fury main 10"; end
          end
          -- fireblood,if=prev_gcd.1.arcane_surge
          if S.Fireblood:IsCastable() then
            if Press(S.Fireblood) then return "fireblood main 12"; end
          end
          -- ancestral_call,if=prev_gcd.1.arcane_surge
          if S.AncestralCall:IsCastable() then
            if Press(S.AncestralCall) then return "ancestral_call main 14"; end
          end
        end
      end
      -- invoke_external_buff,name=power_infusion,if=((!talent.radiant_spark&prev_gcd.1.arcane_surge)|(talent.radiant_spark&prev_gcd.1.radiant_spark&cooldown.arcane_surge.remains<=(gcd.max*3)))
      -- invoke_external_buff,name=blessing_of_summer,if=(!talent.radiant_spark&prev_gcd.1.arcane_surge)|(talent.radiant_spark&prev_gcd.1.radiant_spark&cooldown.arcane_surge.remains<=(gcd.max*3))
      -- invoke_external_buff,name=blessing_of_autumn,if=cooldown.touch_of_the_magi.remains>5
      -- Note: Not handling external buffs
      -- trinkets
      if FightRemainsCheck < FightRemains then
        if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) then
          ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
        end
      end

      -- Var calculations
      ShouldReturn = Calculations(); if ShouldReturn then return ShouldReturn; end
      
      ShouldReturn = Combat(); if ShouldReturn then return ShouldReturn; end
    end
  end
end

local function Init()
  FillDispels()
  ER.Print("Arcane Mage rotation by Epic. Supported by xKaneto.")
end

ER.SetAPL(62, APL, Init)

-- Arcane:
-- B4DArSxcnei16P8xFL3rzzOyRKJiU0QSkkigISERESSgkkQSLJAAAAAAAAAAAgIJJJkkkIkA
-- B4DArSxcnei16P8xFL3rzzOyRKRIFNkEJpIgIREJRSSCkkQSLJAAAAAAAAAAAgIJJJRSSyBgA
-- Fire
-- B8DArSxcnei16P8xFL3rzzOyRKJIFNkEJpIIiERERSCAAAAAAAAQkkEJSUSUkkIJJJpBAAACA
-- Frost
-- BAEArSxcnei16P8xFL3rzzOyRKJiU0QCJpIIiERERSCAAQikIhEJJJSSSSkEAAAAAAAAAICA