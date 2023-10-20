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
local Spell      = EL.Spell
local Item       = EL.Item
-- EpicLib
local ER         = EpicLib
local Bind       = ER.Bind
local Cast       = ER.Cast
local Macro      = ER.Macro
local Press      = ER.Press
-- Num/Bool Helper Functions
local num        = ER.Commons.Everyone.num
local bool       = ER.Commons.Everyone.bool

--- ============================ CONTENT ===========================

local ShouldReturn

-- Toggles
local OOC = false;
local AOE = false;
local CDs = false;
local Kick = false;

--Settings Use
local UseAvatar
local UseBattleShout
local UseBloodbath
local UseBloodthirst
local UseCharge
local UseCrushingBlow
local UseExecute
local UseHeroicThrow
local UseOdynsFury
local UseOnslaught
local UseRagingBlow
local UseRampage
local UseRavager
local UseRecklessness
local UseSlam
local UseSpearOfBastion
local UseThunderousRoar
local UseWhirlwind
local UseWreckingThrow

local UseRacials
local UseTrinkets

--Settings WithCDs
local AvatarWithCD
local OdynsFuryWithCD
local RavagerWithCD
local RecklessnessWithCD
local SpearOfBastionWithCD
local ThunderousRoarWithCD

local RacialsWithCD
local TrinketsWithCD

--Interrupts Use
local UsePummel
local UseStormBolt
local UseIntimidatingShout

--Settings UseDefensives
local UseBitterImmunity
local UseEnragedRegeneration
local UseIgnorePain
local UseRallyingCry
local UseIntervene
local UseDefensiveStance
local UseHealthstone
local UseHealingPotion
local UseVictoryRush

--Settings DefensiveHP
local BitterImmunityHP
local EnragedRegenerationHP
local IgnorePainHP
local RallyingCryHP
local RallyingCryGroup
local InterveneHP
local DefensiveStanceHP
local HealthstoneHP
local HealingPotionHP
local UnstanceHP
local VictoryRushHP

--Extras
local HandleIncorporeal;
local HealingPotionName;
local InterruptWithStun;
local InterruptOnlyWhitelist;
local InterruptThreshold;
local FightRemainsCheck;

--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999
-- Commons
local Everyone = ER.Commons.Everyone
--local Warrior = ER.Commons.wafp

-- Define S/I for spell and item arrays
local S = Spell.Warrior.Fury
local I = Item.Warrior.Fury
local M = Macro.Warrior.Fury

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
}

-- Variables
local BossFightRemains = 11111
local FightRemains = 11111

EL:RegisterForEvent(function()
  BossFightRemains = 11111
  FightRemains = 11111
end, "PLAYER_REGEN_ENABLED")

-- Enemies Variables
local Enemies8y, EnemiesCount8y
local TargetInMeleeRange

---- GUI Settings
--local Settings = {
  --General = ER.GUISettings.General,
  --Commons = ER.GUISettings.APL.Warrior.Commons,
  --Fury = ER.GUISettings.APL.Warrior.Fury
--}

local function IsShieldOnTarget()
  local totalabsorbs = UnitGetTotalAbsorbs(Target)
  if totalabsorbs > 0 then
    return true
  else
    return false
  end
end

local function Defensive()
  -- bitter immunity @ hp
  if S.BitterImmunity:IsReady() and UseBitterImmunity and (Player:HealthPercentage() <= BitterImmunityHP)then
    if Press(S.BitterImmunity) then return "bitter_immunity defensive"; end
  end
  -- enraged regeneration @ hp
  if S.EnragedRegeneration:IsCastable() and UseEnragedRegeneration and (Player:HealthPercentage() <= EnragedRegenerationHP) then
    if Press(S.EnragedRegeneration) then return "enraged_regeneration defensive"; end
  end
  -- ignore pain @ hp
  if S.IgnorePain:IsCastable() and UseIgnorePain and (Player:HealthPercentage() <= IgnorePainHP) then
    if Press(S.IgnorePain) then return "ignore_pain defensive"; end
  end
  -- rallying cry @ group hp or raid hp
  if S.RallyingCry:IsCastable() and UseRallyingCry and Player:BuffDown(S.AspectsFavorBuff) and Player:BuffDown(S.RallyingCry) and ((Player:HealthPercentage() <= RallyingCryHP and Everyone.IsSoloMode()) or Everyone.AreUnitsBelowHealthPercentage(RallyingCryHP, RallyingCryGroup)) then
    if Press(S.RallyingCry) then return "rallying_cry defensive"; end
  end
  -- intervene @ hp
  if S.Intervene:IsCastable() and UseIntervene and (Focus:HealthPercentage() <= InterveneHP) then
    if Press(M.InterveneFocus) then return "intervene defensive"; end
  end
  -- defensive stance @ hp
  if S.DefensiveStance:IsCastable() and UseDefensiveStance and (Player:HealthPercentage() <= DefensiveStanceHP) then
    if Press(S.DefensiveStance) then return "defensive_stance defensive"; end
  end
  -- unstance @ hp
  if S.BerserkerStance:IsCastable() and UseDefensiveStance and (Player:HealthPercentage() > UnstanceHP) then
    if Press(S.BerserkerStance) then return "berserker_stance after defensive stance defensive"; end
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
  -- avatar,if=!talent.titans_torment
  if UseAvatar and ((AvatarWithCD and CDs) or not AvatarWithCD) and FightRemainsCheck < FightRemains and S.Avatar:IsCastable() and (not S.TitansTorment:IsAvailable()) then
    if Press(S.Avatar, not TargetInMeleeRange) then return "avatar precombat 6"; end
  end
  -- recklessness,if=!talent.reckless_abandon
  if UseRecklessness and ((RecklessnessWithCD and CDs) or not RecklessnessWithCD) and FightRemainsCheck < FightRemains and S.Recklessness:IsCastable() and (not S.RecklessAbandon:IsAvailable()) then
    if Press(S.Recklessness, not TargetInMeleeRange) then return "recklessness precombat 8"; end
  end
  -- Manually Added: Charge if not in melee range. Bloodthirst if in melee range
  if S.Bloodthirst:IsCastable() and UseBloodthirst and TargetInMeleeRange then
    if Press(S.Bloodthirst, not TargetInMeleeRange) then return "bloodthirst precombat 10"; end
  end
  if UseCharge and S.Charge:IsReady() and not TargetInMeleeRange then
    if Press(S.Charge, not Target:IsSpellInRange(S.Charge)) then return "charge precombat 12"; end
  end
end

local function SingleTarget()
  -- whirlwind,if=spell_targets.whirlwind>1&talent.improved_whirlwind&!buff.meat_cleaver.up|raid_event.adds.in<2&talent.improved_whirlwind&!buff.meat_cleaver.up
  if S.Whirlwind:IsCastable() and UseWhirlwind and EnemiesCount8y > 1 and S.ImprovedWhilwind:IsAvailable() and Player:BuffDown(S.MeatCleaverBuff) then
    if Press(S.Whirlwind, not Target:IsInMeleeRange(8)) then return "whirlwind single_target 2"; end
  end
  -- execute,if=buff.ashen_juggernaut.up&buff.ashen_juggernaut.remains<gcd
  if S.Execute:IsReady() and UseExecute and Player:BuffUp(S.AshenJuggernautBuff) and Player:BuffRemains(S.AshenJuggernautBuff) < Player:GCD() then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute single_target 4"; end
  end
  -- thunderous_roar,if=buff.enrage.up&(spell_targets.whirlwind>1|raid_event.adds.in>15)
  if UseThunderousRoar and ((ThunderousRoarWithCD and CDs) or not ThunderousRoarWithCD) and FightRemainsCheck < FightRemains and S.ThunderousRoar:IsCastable() and Player:BuffUp(S.EnrageBuff) then
    if Press(S.ThunderousRoar, not Target:IsInMeleeRange(12)) then return "thunderous_roar single_target 6"; end
  end
  -- odyns_fury,if=buff.enrage.up&(spell_targets.whirlwind>1|raid_event.adds.in>15)&(talent.dancing_blades&buff.dancing_blades.remains<5|!talent.dancing_blades)
  if UseOdynsFury and ((OdynsFuryWithCD and CDs) or not OdynsFuryWithCD) and S.OdynsFury:IsCastable() and FightRemainsCheck < FightRemains and Player:BuffUp(S.EnrageBuff) and (S.DancingBlades:IsAvailable() and Player:BuffRemains(S.DancingBladesBuff) < 5 or not S.DancingBlades:IsAvailable()) then
    if Press(S.OdynsFury, not Target:IsInMeleeRange(12)) then return "odyns_fury single_target 8"; end
  end
  -- rampage,if=talent.anger_management&(buff.recklessness.up|buff.enrage.remains<gcd|rage.pct>85)
  if S.Rampage:IsReady() and UseRampage and S.AngerManagement:IsAvailable() and (Player:BuffUp(S.RecklessnessBuff) or Player:BuffRemains(S.EnrageBuff) < Player:GCD() or Player:RagePercentage() > 85) then
    if Press(S.Rampage, not TargetInMeleeRange) then return "rampage single_target 10"; end
  end
  local BTCritChance = Player:CritChancePct() + num(Player:BuffUp(S.RecklessnessBuff)) * 20 + Player:BuffStack(S.MercilessAssaultBuff) * 10 + Player:BuffStack(S.BloodcrazeBuff) * 15
  if (BTCritChance >= 95 or (not S.ColdSteelHotBlood:IsAvailable()) and Player:HasTier(30, 4)) then
    -- bloodbath,if=action.bloodbath.crit_pct_current>=95|!talent.cold_steel_hot_blood&set_bonus.tier30_4pc
    if S.Bloodbath:IsCastable() and UseBloodbath then
      if Press(S.Bloodbath, not TargetInMeleeRange) then return "bloodbath single_target 12"; end
    end
    -- bloodthirst,if=action.bloodthirst.crit_pct_current>=95|!talent.cold_steel_hot_blood&set_bonus.tier30_4pc
    if S.Bloodthirst:IsCastable() and UseBloodthirst then
      if Press(S.Bloodthirst, not TargetInMeleeRange) then return "bloodthirst single_target 14"; end
    end
  end
  -- execute,if=buff.enrage.up
  if S.Execute:IsReady() and UseExecute and Player:BuffUp(S.EnrageBuff) then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute single_target 12"; end
  end
  -- onslaught,if=buff.enrage.up|talent.tenderize
  if S.Onslaught:IsReady() and UseOnslaught and (Player:BuffUp(S.EnrageBuff) or S.Tenderize:IsAvailable()) then
    if Press(S.Onslaught, not TargetInMeleeRange) then return "onslaught single_target 14"; end
  end
  -- crushing_blow,if=talent.wrath_and_fury&buff.enrage.up
  if S.CrushingBlow:IsCastable() and UseCrushingBlow and S.WrathandFury:IsAvailable() and Player:BuffUp(S.EnrageBuff) then
    if Press(S.CrushingBlow, not TargetInMeleeRange) then return "crushing_blow single_target 16"; end
  end
  -- rampage,if=talent.reckless_abandon&(buff.recklessness.up|buff.enrage.remains<gcd|rage.pct>85)
  if S.Rampage:IsReady() and UseRampage and S.RecklessAbandon:IsAvailable() and (Player:BuffUp(S.RecklessnessBuff) or Player:BuffRemains(S.EnrageBuff) < Player:GCD() or Player:RagePercentage() > 85) then
    if Press(S.Rampage, not TargetInMeleeRange) then return "rampage single_target 18"; end
  end
  -- rampage,if=talent.anger_management
  if S.Rampage:IsReady() and UseRampage and S.AngerManagement:IsAvailable() then
    if Press(S.Rampage, not TargetInMeleeRange) then return "rampage single_target 20"; end
  end
  -- execute
  if S.Execute:IsReady() and UseExecute then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute single_target 22"; end
  end
  -- bloodbath,if=buff.enrage.up&talent.reckless_abandon&!talent.wrath_and_fury
  if S.Bloodbath:IsCastable() and UseBloodbath and Player:BuffUp(S.EnrageBuff) and S.RecklessAbandon:IsAvailable() and not S.WrathandFury:IsAvailable() then
    if Press(S.Bloodbath, not TargetInMeleeRange) then return "bloodbath single_target 24"; end
  end
  -- bloodthirst,if=buff.enrage.down|(talent.annihilator&!buff.recklessness.up)
  if S.Bloodthirst:IsCastable() and UseBloodthirst and ((not Player:BuffUp(S.EnrageBuff)) or (S.Annihilator:IsAvailable() and Player:BuffDown(S.RecklessnessBuff))) then
    if Press(S.Bloodthirst, not TargetInMeleeRange) then return "bloodthirst single_target 26"; end
  end
  -- raging_blow,if=charges>1&talent.wrath_and_fury
  if S.RagingBlow:IsCastable() and UseRagingBlow and S.RagingBlow:Charges() > 1 and S.WrathandFury:IsAvailable() then
    if Press(S.RagingBlow, not TargetInMeleeRange) then return "raging_blow single_target 28"; end
  end
  -- crushing_blow,if=charges>1&talent.wrath_and_fury
  if S.CrushingBlow:IsCastable() and UseCrushingBlow and S.CrushingBlow:Charges() > 1 and S.WrathandFury:IsAvailable() then
    if Press(S.CrushingBlow, not TargetInMeleeRange) then return "crushing_blow single_target 30"; end
  end
  -- bloodbath,if=buff.enrage.down|!talent.wrath_and_fury
  if S.Bloodbath:IsCastable() and UseBloodbath and ((not Player:BuffUp(S.EnrageBuff)) or not S.WrathandFury:IsAvailable()) then
    if Press(S.Bloodbath, not TargetInMeleeRange) then return "bloodbath single_target 32"; end
  end
  -- crushing_blow,if=buff.enrage.up&talent.reckless_abandon
  if S.CrushingBlow:IsCastable() and UseCrushingBlow and Player:BuffUp(S.EnrageBuff) and S.RecklessAbandon:IsAvailable() then
    if Press(S.CrushingBlow, not TargetInMeleeRange) then return "crushing_blow single_target 34"; end
  end
  -- bloodthirst,if=!talent.wrath_and_fury
  if S.Bloodthirst:IsCastable() and UseBloodthirst and not S.WrathandFury:IsAvailable() then
    if Press(S.Bloodthirst, not TargetInMeleeRange) then return "bloodthirst single_target 36"; end
  end
  -- raging_blow,if=charges>1
  if S.RagingBlow:IsCastable() and UseRagingBlow and S.RagingBlow:Charges() > 1 then
    if Press(S.RagingBlow, not TargetInMeleeRange) then return "raging_blow single_target 38"; end
  end
  -- rampage
  if S.Rampage:IsReady() and UseRampage then
    if Press(S.Rampage, not TargetInMeleeRange) then return "rampage single_target 40"; end
  end
  -- slam,if=talent.annihilator
  if S.Slam:IsReady() and UseSlam and (S.Annihilator:IsAvailable()) then
    if Press(S.Slam, not TargetInMeleeRange) then return "slam single_target 42"; end
  end
  -- bloodbath
  if S.Bloodbath:IsCastable() and UseBloodbath then
    if Press(S.Bloodbath, not TargetInMeleeRange) then return "bloodbath single_target 44"; end
  end
  -- raging_blow
  if S.RagingBlow:IsCastable() and UseRagingBlow then
    if Press(S.RagingBlow, not TargetInMeleeRange) then return "raging_blow single_target 46"; end
  end
  -- crushing_blow
  if S.CrushingBlow:IsCastable() and UseCrushingBlow then
    if Press(S.CrushingBlow, not TargetInMeleeRange) then return "crushing_blow single_target 48"; end
  end
  -- bloodthirst
  if S.Bloodthirst:IsCastable() and UseBloodthirst then
    if Press(S.Bloodthirst, not TargetInMeleeRange) then return "bloodthirst single_target 50"; end
  end
  -- whirlwind
  if AOE and S.Whirlwind:IsCastable() and UseWhirlwind then
    if Press(S.Whirlwind, not Target:IsInMeleeRange(8)) then return "whirlwind single_target 52"; end
  end
end

local function MultiTarget()
  -- recklessness,if=raid_event.adds.in>15|active_enemies>1|target.time_to_die<12
  if S.Recklessness:IsCastable() and ((RecklessnessWithCD and CDs) or not RecklessnessWithCD) and UseRecklessness and FightRemainsCheck < FightRemains and (EnemiesCount8y > 1 or FightRemains < 12) then
    if Press(S.Recklessness, not TargetInMeleeRange) then return "recklessness multi_target 2"; end
  end
  -- odyns_fury,if=active_enemies>1&talent.titanic_rage&(!buff.meat_cleaver.up|buff.avatar.up|buff.recklessness.up)
  if S.OdynsFury:IsCastable() and ((OdynsFuryWithCD and CDs) or not OdynsFuryWithCD) and UseOdynsFury and FightRemainsCheck < FightRemains and EnemiesCount8y > 1 and S.TitanicRage:IsAvailable() and (Player:BuffDown(S.MeatCleaverBuff) or Player:BuffUp(S.AvatarBuff) or Player:BuffUp(S.RecklessnessBuff)) then
    if Press(S.OdynsFury, not Target:IsInMeleeRange(12)) then return "odyns_fury multi_target 4"; end
  end
  -- whirlwind,if=spell_targets.whirlwind>1&talent.improved_whirlwind&!buff.meat_cleaver.up|raid_event.adds.in<2&talent.improved_whirlwind&!buff.meat_cleaver.up
  if S.Whirlwind:IsCastable() and UseWhirlwind and EnemiesCount8y > 1 and S.ImprovedWhilwind:IsAvailable() and Player:BuffDown(S.MeatCleaverBuff) then
    if Press(S.Whirlwind, not Target:IsInMeleeRange(8)) then return "whirlwind multi_target 6"; end
  end
  -- execute,if=buff.ashen_juggernaut.up&buff.ashen_juggernaut.remains<gcd
  if S.Execute:IsReady() and UseExecute and Player:BuffUp(S.AshenJuggernautBuff) and Player:BuffRemains(S.AshenJuggernautBuff) < Player:GCD() then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute multi_target 8"; end
  end
  -- thunderous_roar,if=buff.enrage.up&(spell_targets.whirlwind>1|raid_event.adds.in>15)
  if S.ThunderousRoar:IsCastable() and ((ThunderousRoarWithCD and CDs) or not ThunderousRoarWithCD) and UseThunderousRoar and FightRemainsCheck < FightRemains and Player:BuffUp(S.EnrageBuff) then
    if Press(S.ThunderousRoar, not Target:IsInMeleeRange(12)) then return "thunderous_roar multi_target 10"; end
  end
  -- odyns_fury,if=active_enemies>1&buff.enrage.up&raid_event.adds.in>15
  if S.OdynsFury:IsCastable() and ((OdynsFuryWithCD and CDs) or not OdynsFuryWithCD) and UseOdynsFury and FightRemainsCheck < FightRemains and EnemiesCount8y > 1 and Player:BuffUp(S.EnrageBuff) then
    if Press(S.OdynsFury, not Target:IsInMeleeRange(12)) then return "odyns_fury multi_target 12"; end
  end
  local BTCritChance = Player:CritChancePct() + num(Player:BuffUp(S.RecklessnessBuff)) * 20 + Player:BuffStack(S.MercilessAssaultBuff) * 10 + Player:BuffStack(S.BloodcrazeBuff) * 15
  if (BTCritChance >= 95 or (not S.ColdSteelHotBlood:IsAvailable()) and Player:HasTier(30, 4)) then
    -- bloodbath,if=action.bloodbath.crit_pct_current>=95|!talent.cold_steel_hot_blood&set_bonus.tier30_4pc
    if S.Bloodbath:IsCastable() and UseBloodbath then
      if Press(S.Bloodbath, not TargetInMeleeRange) then return "bloodbath multi_target 14"; end
    end
    -- bloodthirst,if=action.bloodthirst.crit_pct_current>=95|!talent.cold_steel_hot_blood&set_bonus.tier30_4pc
    if S.Bloodthirst:IsCastable() and UseBloodthirst then
      if Press(S.Bloodthirst, not TargetInMeleeRange) then return "bloodthirst multi_target 16"; end
    end
  end
  -- crushing_blow,if=talent.wrath_and_fury&buff.enrage.up
  if S.CrushingBlow:IsCastable() and S.WrathandFury:IsAvailable() and UseCrushingBlow and Player:BuffUp(S.EnrageBuff) then
    if Press(S.CrushingBlow, not TargetInMeleeRange) then return "crushing_blow multi_target 14"; end
  end
  -- execute,if=buff.enrage.up
  if S.Execute:IsReady() and UseExecute and Player:BuffUp(S.EnrageBuff) then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute multi_target 16"; end
  end
  -- odyns_fury,if=buff.enrage.up&raid_event.adds.in>15
  if S.OdynsFury:IsCastable() and ((OdynsFuryWithCD and CDs) or not OdynsFuryWithCD) and UseOdynsFury and FightRemainsCheck < FightRemains and Player:BuffUp(S.EnrageBuff) then
    if Press(S.OdynsFury, not Target:IsInMeleeRange(12)) then return "odyns_fury multi_target 18"; end
  end
  -- rampage,if=buff.recklessness.up|buff.enrage.remains<gcd|(rage>110&talent.overwhelming_rage)|(rage>80&!talent.overwhelming_rage)
  if S.Rampage:IsReady() and UseRampage and (Player:BuffUp(S.RecklessnessBuff) or Player:BuffRemains(S.EnrageBuff) < Player:GCD() or (Player:Rage() > 110 and S.OverwhelmingRage:IsAvailable()) or (Player:Rage() > 80 and not S.OverwhelmingRage:IsAvailable())) then
    if Press(S.Rampage, not TargetInMeleeRange) then return "rampage multi_target 20"; end
  end
  -- execute
  if S.Execute:IsReady() and UseExecute then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute multi_target 22"; end
  end
  -- bloodbath,if=buff.enrage.up&talent.reckless_abandon&!talent.wrath_and_fury
  if S.Bloodbath:IsCastable() and UseBloodbath and Player:BuffUp(S.EnrageBuff) and S.RecklessAbandon:IsAvailable() and not S.WrathandFury:IsAvailable() then
    if Press(S.Bloodbath, not TargetInMeleeRange) then return "bloodbath multi_target 24"; end
  end
  -- bloodthirst,if=buff.enrage.down|(talent.annihilator&!buff.recklessness.up)
  if S.Bloodthirst:IsCastable() and UseBloodthirst and ((not Player:BuffUp(S.EnrageBuff)) or (S.Annihilator:IsAvailable() and Player:BuffDown(S.RecklessnessBuff))) then
    if Press(S.Bloodthirst, not TargetInMeleeRange) then return "bloodthirst multi_target 26"; end
  end
  -- onslaught,if=!talent.annihilator&buff.enrage.up|talent.tenderize
  if S.Onslaught:IsReady() and UseOnslaught and ((not S.Annihilator:IsAvailable()) and Player:BuffUp(S.EnrageBuff) or S.Tenderize:IsAvailable()) then
    if Press(S.Onslaught, not TargetInMeleeRange) then return "onslaught multi_target 28"; end
  end
  -- raging_blow,if=charges>1&talent.wrath_and_fury
  if S.RagingBlow:IsCastable() and UseRagingBlow and S.RagingBlow:Charges() > 1 and S.WrathandFury:IsAvailable() then
    if Press(S.RagingBlow, not TargetInMeleeRange) then return "raging_blow multi_target 30"; end
  end
  -- crushing_blow,if=charges>1&talent.wrath_and_fury
  if S.CrushingBlow:IsCastable() and UseCrushingBlow and S.CrushingBlow:Charges() > 1 and S.WrathandFury:IsAvailable() then
    if Press(S.CrushingBlow, not TargetInMeleeRange) then return "crushing_blow multi_target 32"; end
  end
  -- bloodbath,if=buff.enrage.down|!talent.wrath_and_fury
  if S.Bloodbath:IsCastable() and UseBloodbath and ((not Player:BuffUp(S.EnrageBuff)) or not S.WrathandFury:IsAvailable()) then
    if Press(S.Bloodbath, not TargetInMeleeRange) then return "bloodbath multi_target 34"; end
  end
  -- crushing_blow,if=buff.enrage.up&talent.reckless_abandon
  if S.CrushingBlow:IsCastable() and UseCrushingBlow and Player:BuffUp(S.EnrageBuff) and S.RecklessAbandon:IsAvailable() then
    if Press(S.CrushingBlow, not TargetInMeleeRange) then return "crushing_blow multi_target 36"; end
  end
  -- bloodthirst,if=!talent.wrath_and_fury
  if S.Bloodthirst:IsCastable() and UseBloodthirst and not S.WrathandFury:IsAvailable() then
    if Press(S.Bloodthirst, not TargetInMeleeRange) then return "bloodthirst multi_target 38"; end
  end
  -- raging_blow,if=charges>=1
  if S.RagingBlow:IsCastable() and UseRagingBlow and S.RagingBlow:Charges() > 1 then
    if Press(S.RagingBlow, not TargetInMeleeRange) then return "raging_blow multi_target 40"; end
  end
  -- rampage
  if S.Rampage:IsReady() and UseRampage then
    if Press(S.Rampage, not TargetInMeleeRange) then return "rampage multi_target 42"; end
  end
  -- slam,if=talent.annihilator
  if S.Slam:IsReady() and UseSlam and (S.Annihilator:IsAvailable()) then
    if Press(S.Slam, not TargetInMeleeRange) then return "slam multi_target 44"; end
  end
  -- bloodbath
  if S.Bloodbath:IsCastable() and UseBloodbath then
    if Press(S.Bloodbath, not TargetInMeleeRange) then return "bloodbath multi_target 46"; end
  end
  -- raging_blow
  if S.RagingBlow:IsCastable() and UseRagingBlow then
    if Press(S.RagingBlow, not TargetInMeleeRange) then return "raging_blow multi_target 48"; end
  end
  -- crushing_blow
  if S.CrushingBlow:IsCastable() and UseCrushingBlow then
    if Press(S.CrushingBlow, not TargetInMeleeRange) then return "crushing_blow multi_target 50"; end
  end
  -- whirlwind
  if S.Whirlwind:IsCastable() and UseWhirlwind then
    if Press(S.Whirlwind, not Target:IsInMeleeRange(8)) then return "whirlwind multi_target 52"; end
  end
end


local function Combat()
  -- In Combat
  -- defensive
  ShouldReturn = Defensive(); if ShouldReturn then return ShouldReturn; end

  -- Incorporeal
  if HandleIncorporeal then
    ShouldReturn = Everyone.HandleIncorporeal(S.StormBolt, M.StormBoltMouseover, 20, true); if ShouldReturn then return ShouldReturn; end
    ShouldReturn = Everyone.HandleIncorporeal(S.IntimidatingShout, M.IntimidatingShoutMouseover, 8, true); if ShouldReturn then return ShouldReturn; end
  end

  if Everyone.TargetIsValid() then
    -- Interrupts
    if not Player:IsCasting() and not Player:IsChanneling() and Kick then 
      if UsePummel then
        ShouldReturn = Everyone.Interrupt(S.Pummel, 5); if ShouldReturn then return ShouldReturn; end
        ShouldReturn = Everyone.Interrupt(M.PummelMouseover, 5); if ShouldReturn then return ShouldReturn; end
      end
      if UseStormBolt then
        ShouldReturn = Everyone.InterruptWithStun(S.StormBolt, 20); if ShouldReturn then return ShouldReturn; end
        ShouldReturn = Everyone.InterruptWithStun(M.StormBoltMouseover, 20); if ShouldReturn then return ShouldReturn; end
      end
      if UseIntimidatingShout then
        ShouldReturn = Everyone.Interrupt(S.IntimidatingShout, 8); if ShouldReturn then return ShouldReturn; end
        ShouldReturn = Everyone.Interrupt(M.IntimidatingShoutMouseover, 8); if ShouldReturn then return ShouldReturn; end
      end
    end
    
    -- charge,if=time<=0.5|movement.distance>5
    if UseCharge and S.Charge:IsCastable() then
      if Press(S.Charge, not Target:IsSpellInRange(S.Charge)) then return "charge main 2"; end
    end

    -- potion
    local ShouldReturnPot = Everyone.HandleDPSPotion(Target:BuffUp(S.RecklessnessBuff)); if ShouldReturnPot then return ShouldReturnPot; end

    -- Manually added: VR/IV
    if Player:HealthPercentage() < VictoryRushHP then
      if S.VictoryRush:IsReady() and UseVictoryRush then
        if Press(S.VictoryRush, not TargetInMeleeRange) then return "victory_rush heal"; end
      end
      if S.ImpendingVictory:IsReady() and UseVictoryRush then
        if Press(S.ImpendingVictory, not TargetInMeleeRange) then return "impending_victory heal"; end
      end
    end
    
    if FightRemainsCheck < FightRemains then
      if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) then
        ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
      end
    end

    if FightRemainsCheck < FightRemains and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) then
      -- blood_fury
      if S.BloodFury:IsCastable() then
        if Press(S.BloodFury, not TargetInMeleeRange) then return "blood_fury main 12"; end
      end
      -- berserking,if=buff.recklessness.up
      if S.Berserking:IsCastable() and Player:BuffUp(S.RecklessnessBuff) then
        if Press(S.Berserking, not TargetInMeleeRange) then return "berserking main 14"; end
      end
      -- lights_judgment,if=buff.recklessness.down
      if S.LightsJudgment:IsCastable() and Player:BuffDown(S.RecklessnessBuff) then
        if Press(S.LightsJudgment, not Target:IsSpellInRange(S.LightsJudgment)) then return "lights_judgment main 16"; end
      end
      -- fireblood
      if S.Fireblood:IsCastable() then
        if Press(S.Fireblood, not TargetInMeleeRange) then return "fireblood main 18"; end
      end
      -- ancestral_call
      if S.AncestralCall:IsCastable() then
        if Press(S.AncestralCall, not TargetInMeleeRange) then return "ancestral_call main 20"; end
      end
      --bag_of_tricks,if=buff.recklessness.down&buff.enrage.up
      if S.BagofTricks:IsCastable() and Player:BuffDown(S.RecklessnessBuff) and Player:BuffUp(S.EnrageBuff) then
         if Cast(S.BagofTricks, Settings.Commons.OffGCDasOffGCD.Racials, nil, not Target:IsSpellInRange(S.BagofTricks)) then return "bag_of_tricks main 22"; end
      end
    end

    if FightRemainsCheck < FightRemains then
      -- ravager,if=cooldown.recklessness.remains<3|buff.recklessness.up
      -- Note: manually added end of fight
      if S.Ravager:IsCastable() and RavagerSetting == "player" and UseRavager and ((RavagerWithCD and CDs) or not RavagerWithCD) and (S.Avatar:CooldownRemains() < 3 or Player:BuffUp(S.RecklessnessBuff) or FightRemains < 10) then
        if Press(M.RavagerPlayer, not TargetInMeleeRange) then return "ravager main 10"; end
      end
      if S.Ravager:IsCastable() and RavagerSetting == "cursor" and UseRavager and ((RavagerWithCD and CDs) or not RavagerWithCD) and (S.Avatar:CooldownRemains() < 3 or Player:BuffUp(S.RecklessnessBuff) or FightRemains < 10) then
        if Press(M.RavagerCursor, not TargetInMeleeRange) then return "ravager main 11"; end
      end
      -- avatar,if=talent.titans_torment&buff.enrage.up&raid_event.adds.in>15|talent.berserkers_torment&buff.enrage.up&!buff.avatar.up&raid_event.adds.in>15|!talent.titans_torment&!talent.berserkers_torment&(buff.recklessness.up|target.time_to_die<20)
      if S.Avatar:IsCastable() and UseAvatar and ((AvatarWithCD and CDs) or not AvatarWithCD) and (S.TitansTorment:IsAvailable() and Player:BuffUp(S.EnrageBuff) or S.BerserkersTorment:IsAvailable() and Player:BuffUp(S.EnrageBuff) and Player:BuffDown(S.AvatarBuff) or (not S.TitansTorment:IsAvailable()) and (not S.BerserkersTorment:IsAvailable()) and (Player:BuffUp(S.RecklessnessBuff) or FightRemains < 20)) then
        if Press(S.Avatar, not TargetInMeleeRange) then return "avatar main 24"; end
      end
      -- recklessness,if=!raid_event.adds.exists&(talent.annihilator&cooldown.avatar.remains<1|cooldown.avatar.remains>40|!talent.avatar|target.time_to_die<12)
      if S.Recklessness:IsCastable() and UseRecklessness and ((RecklessnessWithCD and CDs) or not RecklessnessWithCD) and (S.Annihilator:IsAvailable() and S.Avatar:CooldownRemains() < 1 or S.Avatar:CooldownRemains() > 40 or (not S.Avatar:IsAvailable()) or FightRemains < 12) then
        if Press(S.Recklessness, not TargetInMeleeRange) then return "recklessness main 26"; end
      end
      -- recklessness,if=!raid_event.adds.exists&!talent.annihilator|target.time_to_die<12
      if S.Recklessness:IsCastable() and UseRecklessness and ((RecklessnessWithCD and CDs) or not RecklessnessWithCD) and (not S.Annihilator:IsAvailable() or EL.FightRemains() < 12) then
        if Press(S.Recklessness, not TargetInMeleeRange) then return "recklessness main 28"; end
      end
      -- spear_of_bastion,if=buff.enrage.up&(buff.recklessness.up|buff.avatar.up|target.time_to_die<20|active_enemies>1)&raid_event.adds.in>15
      if S.SpearofBastion:IsCastable() and SpearSetting == "player" and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and (Player:BuffUp(S.EnrageBuff) and (Player:BuffUp(S.RecklessnessBuff) or Player:BuffUp(S.AvatarBuff) or FightRemains < 20 or EnemiesCount8y > 1)) then
        if Press(M.SpearofBastionPlayer, not TargetInMeleeRange) then return "spear_of_bastion main 30"; end
      end
      if S.SpearofBastion:IsCastable() and SpearSetting == "cursor" and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and (Player:BuffUp(S.EnrageBuff) and (Player:BuffUp(S.RecklessnessBuff) or Player:BuffUp(S.AvatarBuff) or FightRemains < 20 or EnemiesCount8y > 1)) then
        if Press(M.SpearofBastionCursor, not TargetInMeleeRange) then return "spear_of_bastion main 31"; end
      end
    end
      
    -- HeroicThrow, if out of range
    if UseHeroicThrow and S.HeroicThrow:IsCastable() and (not Target:IsInRange(30)) then
      if Press(S.HeroicThrow, not Target:IsInRange(30)) then return "heroic_throw main"; end
    end

    -- wrecking_throw if Shield on target
    if S.WreckingThrow:IsCastable() and UseWreckingThrow and Target:AffectingCombat() and IsShieldOnTarget() then
      if Press(S.WreckingThrow, not Target:IsInRange(30)) then return "wrecking_throw main"; end
    end

    -- call_action_list,name=multi_target,if=raid_event.adds.exists|active_enemies>2
    if AOE and EnemiesCount8y > 2 then
      ShouldReturn = MultiTarget(); if ShouldReturn then return ShouldReturn; end
    end
    -- call_action_list,name=single_target,if=!raid_event.adds.exists
    ShouldReturn = SingleTarget(); if ShouldReturn then return ShouldReturn; end
    -- Pool if nothing else to suggest
    if ER.CastAnnotated(S.Pool, false, "WAIT") then return "Wait/Pool Resources"; end
  end
end

local function OutOfCombat()
  if not Player:AffectingCombat() then
    -- berserker_stance,toggle=on
    if S.BerserkerStance:IsCastable() and Player:BuffDown(S.BerserkerStance, true) then
      if Press(S.BerserkerStance) then return "berserker_stance"; end
    end
    -- Manually added: Group buff check
    if S.BattleShout:IsCastable() and UseBattleShout and (Player:BuffDown(S.BattleShoutBuff, true) or Everyone.GroupBuffMissing(S.BattleShoutBuff)) then
      if Press(S.BattleShout) then return "battle_shout precombat"; end
    end
  end
  if Everyone.TargetIsValid() and OOC then
    -- call Precombat
    if not Player:AffectingCombat() then
      ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
    end
  end
end

local function FetchUseSettings()
  --General Use
  UseBattleShout = EpicSettings.Settings["useBattleShout"]
  UseBloodbath = EpicSettings.Settings["useBloodbath"]
  UseBloodthirst = EpicSettings.Settings["useBloodthirst"]
  UseCharge = EpicSettings.Settings["useCharge"]
  UseCrushingBlow = EpicSettings.Settings["useCrushingBlow"]
  UseExecute = EpicSettings.Settings["useExecute"]
  UseHeroicThrow = EpicSettings.Settings["useHeroicThrow"]
  UseOnslaught = EpicSettings.Settings["useOnslaught"]
  UseRagingBlow = EpicSettings.Settings["useRagingBlow"]
  UseRampage = EpicSettings.Settings["useRampage"]
  UseSlam = EpicSettings.Settings["useSlam"]
  UseWhirlwind = EpicSettings.Settings["useWhirlwind"]
  UseWreckingThrow = EpicSettings.Settings["useWreckingThrow"]

  --CD Use
  UseAvatar = EpicSettings.Settings["useAvatar"]
  UseOdynsFury = EpicSettings.Settings["useOdynsFury"]
  UseRavager = EpicSettings.Settings["useRavager"]
  UseRecklessness = EpicSettings.Settings["useRecklessness"]
  UseSpearOfBastion = EpicSettings.Settings["useSpearOfBastion"]
  UseThunderousRoar = EpicSettings.Settings["useThunderousRoar"]

  --SaveWithCD Settings
  AvatarWithCD = EpicSettings.Settings["avatarWithCD"]
  OdynsFuryWithCD = EpicSettings.Settings["odynFuryWithCD"]
  RavagerWithCD = EpicSettings.Settings["ravagerWithCD"]
  RecklessnessWithCD = EpicSettings.Settings["recklessnessWithCD"]
  SpearOfBastionWithCD = EpicSettings.Settings["spearOfBastionWithCD"]
  ThunderousRoarWithCD = EpicSettings.Settings["thunderousRoarWithCD"]
end

local function FetchMoreSettings()
    --Interupt Settings
  UsePummel = EpicSettings.Settings["usePummel"]
  UseStormBolt = EpicSettings.Settings["useStormBolt"]
  UseIntimidatingShout = EpicSettings.Settings["useIntimidatingShout"]

  --Defensive Use Settings
  UseBitterImmunity = EpicSettings.Settings["useBitterImmunity"]
  UseEnragedRegeneration = EpicSettings.Settings["useEnragedRegeneration"]
  UseIgnorePain = EpicSettings.Settings["useIgnorePain"]
  UseRallyingCry = EpicSettings.Settings["useRallyingCry"]
  UseIntervene = EpicSettings.Settings["useIntervene"]
  UseDefensiveStance = EpicSettings.Settings["useDefensiveStance"]
  UseVictoryRush = EpicSettings.Settings["useVictoryRush"]

  --Defensive HP Settings
  BitterImmunityHP = EpicSettings.Settings["bitterImmunityHP"] or 0
  EnragedRegenerationHP = EpicSettings.Settings["enragedRegenerationHP"] or 0
  IgnorePainHP = EpicSettings.Settings["ignorePainHP"] or 0
  RallyingCryHP = EpicSettings.Settings["rallyingCryHP"] or 0
  RallyingCryGroup = EpicSettings.Settings["rallyingCryGroup"] or 0
  InterveneHP = EpicSettings.Settings["interveneHP"] or 0
  DefensiveStanceHP = EpicSettings.Settings["defensiveStanceHP"] or 0
  UnstanceHP = EpicSettings.Settings["unstanceHP"] or 0
  VictoryRushHP = EpicSettings.Settings["victoryRushHP"] or 0
  
  --Placement Settings
  RavagerSetting = EpicSettings.Settings["ravagerSetting"] or "player"
  SpearSetting = EpicSettings.Settings["spearSetting"] or "player"
end

local function FetchGeneralSettings()
  FightRemainsCheck = EpicSettings.Settings["fightRemainsCheck"] or 0

  InterruptWithStun = EpicSettings.Settings["InterruptWithStun"]
  InterruptOnlyWhitelist = EpicSettings.Settings["InterruptOnlyWhitelist"]
  InterruptThreshold = EpicSettings.Settings["InterruptThreshold"]
  
  UseTrinkets = EpicSettings.Settings["useTrinkets"]
  UseRacials = EpicSettings.Settings["useRacials"]
  TrinketsWithCD = EpicSettings.Settings["trinketsWithCD"]
  RacialsWithCD = EpicSettings.Settings["racialsWithCD"]

  UseHealthstone = EpicSettings.Settings["useHealthstone"]
  UseHealingPotion = EpicSettings.Settings["useHealingPotion"]
  HealthstoneHP = EpicSettings.Settings["healthstoneHP"] or 0
  HealingPotionHP = EpicSettings.Settings["healingPotionHP"] or 0
  HealingPotionName = EpicSettings.Settings["HealingPotionName"] or ""

  HandleIncorporeal = EpicSettings.Settings["HandleIncorporeal"]
end

--- ======= ACTION LISTS =======
local function APL()
  FetchMoreSettings();
  FetchUseSettings();
  FetchGeneralSettings();
  
  OOC = EpicSettings.Toggles["ooc"]
  AOE = EpicSettings.Toggles["aoe"]
  CDs = EpicSettings.Toggles["cds"]
  Kick = EpicSettings.Toggles["kick"]

  if AOE then
    Enemies8y = Player:GetEnemiesInMeleeRange(8)
    EnemiesCount8y = #Enemies8y
  else
    EnemiesCount8y = 1
  end

  -- Range check
  TargetInMeleeRange = Target:IsInMeleeRange(5)

  if Everyone.TargetIsValid() or Player:AffectingCombat() then
    -- Calculate fight_remains
    BossFightRemains = EL.BossFightRemains(nil, true)
    FightRemains = BossFightRemains
    if FightRemains == 11111 then
      FightRemains = EL.FightRemains(Enemies10yd, false)
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
  ER.Print("Fury Warrior by Epic. Supported by xKaneto.")
end

ER.SetAPL(72, APL, Init)
