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
local Focus      = Unit.Focus
local Player     = Unit.Player
local Mouseover  = Unit.MouseOver
local Target     = Unit.Target
local Pet        = Unit.Pet
local Spell      = EL.Spell
local Item       = EL.Item
-- EpicLib
local ER         = EpicLib
local Cast       = ER.Cast
local Bind       = ER.Bind
local Macro      = ER.Macro
local Press      = ER.Press
-- Num/Bool Helper Functions
local num        = ER.Commons.Everyone.num
local bool       = ER.Commons.Everyone.bool
-- Lua
local mathmin = math.min

--- ============================ CONTENT ============================

local ShouldReturn

-- Toggles
local OOC = false;
local AOE = false;
local CDs = false;
local Kick = false;
local DispelToggle = false;

--Settings Use
local UseBladeofJustice
local UseConsecration
local UseCrusaderStrike
local UseDivineHammer
local UseDivineStorm
local UseDivineToll
local UseExecutionSentence
local UseFinalReckoning
local UseHammerofWrath
local UseJudgment
local UseJusticarsVengeance
local UseTemplarSlash
local UseTemplarStrike
local UseWakeofAshes
local UseVerdict

--Settings Use with CDs 
local UseAvengingWrath
local UseCrusade
local UseFinalReckoning
local UseShieldofVengeance

--Settings WithCDs
local AvengingWrathWithCD
local CrusadeWithCD
local FinalReckoningWithCD
local ShieldofVengeanceWithCD

--Interrupt Use Settings
local UseRebuke
local UseHammerofJustice

--Settings UseDefensives
local UseDivineProtection
local UseDivineShield
local UseLayonHands

local UseLayOnHandsFocus
local UseWordofGloryFocus
local UseBlessingOfProtectionFocus
local UseBlessingOfSacrificeFocus

--Settings DefensiveHP
local DivineProtectionHP
local DivineShieldHP
local LayonHandsHP

local LayOnHandsFocusHP
local WordofGloryFocusHP
local BlessingofProtectionFocusHP
local BlessingofSacrificeFocusHP

--Afflicted Settings
local UseCleanseToxinsWithAfflicted
local UseWordofGloryWithAfflicted

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

local UseTrinkets
local TrinketsWithCD
local UseRacials
local RacialsWithCD

local UseHealingPotion
local UseHealthstone
local HealingPotionHP
local HealthstoneHP
local HealingPotionName;

local UseHealOOC
local HealOOCHP

local FinalReckoningSetting

--- ======= APL LOCALS =======
-- Commons
local Everyone = ER.Commons.Everyone

-- GUI Settings
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.Paladin.Commons,
--  Retribution = ER.GUISettings.APL.Paladin.Retribution
--}

-- Spells
local S = Spell.Paladin.Retribution

-- Items
local I = Item.Paladin.Retribution
local OnUseExcludes = {
}

local function FillDispels()
  if S.CleanseToxins:IsAvailable() then
    Everyone.DispellableDebuffs = Utils.MergeTable(Everyone.DispellableDiseaseDebuffs, Everyone.DispellablePoisonDebuffs)
  end
end

EL:RegisterForEvent(function()
  FillDispels()
end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");

-- Macros
local M = Macro.Paladin.Retribution

-- Enemies
local Enemies5y
local Enemies8y
local EnemiesCount8y

-- Rotation Variables
local BossFightRemains = 11111
local FightRemains = 11111
local TimeToHPG
local HolyPower = 0
local PlayerGCD = 0
local VarDSCastable

EL:RegisterForEvent(function()
  BossFightRemains = 11111
  FightRemains = 11111
end, "PLAYER_REGEN_ENABLED")

EL:RegisterForEvent(function()
  if S.FinalVerdict:IsAvailable() then
    S.TemplarsVerdict = S.FinalVerdict
  end
end, "PLAYER_TALENT_UPDATE")

--- ======= HELPERS =======
-- time_to_hpg_expr_t @ https://github.com/simulationcraft/simc/blob/shadowlands/engine/class_modules/paladin/sc_paladin.cpp#L3236
local function ComputeTimeToHPG()
  local GCDRemains = Player:GCDRemains()
  local ShortestHPGTime = mathmin(
    S.CrusaderStrike:CooldownRemains(),
    S.BladeofJustice:CooldownRemains(),
    S.Judgment:CooldownRemains(),
    S.HammerofWrath:IsUsable() and S.HammerofWrath:CooldownRemains() or 10, -- if not usable, return a dummy 10
    S.WakeofAshes:CooldownRemains()
  )

  if GCDRemains > ShortestHPGTime then
    return GCDRemains
  end

  return ShortestHPGTime
end

local function MissingAura()
  return (Player:BuffDown(S.RetributionAura) and Player:BuffDown(S.DevotionAura) and Player:BuffDown(S.ConcentrationAura) and Player:BuffDown(S.CrusaderAura))
end


local function Dispel()
  -- Cleanse Spirit
  if S.CleanseToxins:IsReady() and DispelToggle and Everyone.DispellableFriendlyUnit() then
    if Press(M.CleanseToxinsFocus) then return "cleanse_spirit dispel"; end
  end
end

local function HealOOC()
  -- Heal Out of Combat
  if UseHealOOC and (Player:HealthPercentage() <= HealOOCHP) then
    -- Flash of Light
    if S.FlashofLight:IsReady() then
      if Press(S.FlashofLight) then return "healing_surge heal ooc"; end
    end
  end
end

local function DefensivesGroup()
  if not Focus or not Focus:Exists() or not Focus:IsInRange(40) then return; end
  if Focus then
    -- Word of Glory Focus
    if S.WordofGlory:IsReady() and UseWordofGloryFocus and (Focus:HealthPercentage() <= WordofGloryFocusHP and not Focus:HealingAbsorbed()) then
      if Press(M.WordofGloryFocus) then return "word_of_glory defensive focus"; end
    end  

    -- Lay on Hands Focus
    if S.LayonHands:IsCastable() and UseLayOnHandsFocus and Focus:DebuffDown(S.ForbearanceDebuff) and (Focus:HealthPercentage() <= LayOnHandsFocusHP) then
      if Press(M.LayonHandsFocus) then return "lay_on_hands defensive focus"; end
    end

    -- Blessing of Sacrifice Focus
    if S.BlessingofSacrifice:IsCastable() and UseBlessingOfSacrificeFocus and (Focus:HealthPercentage() <= BlessingofSacrificeFocusHP) then
      if Press(M.BlessingofSacrificeFocus) then return "blessing_of_sacrifice defensive focus"; end
    end

    -- Blessing of Protection Focus
    if S.BlessingofProtection:IsCastable() and UseBlessingOfProtectionFocus and Focus:DebuffDown(S.ForbearanceDebuff) and (Focus:HealthPercentage() <= BlessingofProtectionFocusHP) then
      if Press(M.BlessingofProtectionFocus) then return "blessing_of_protection defensive focus"; end
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

--- ======= ACTION LISTS =======
local function Precombat()
  -- flask
  -- food
  -- augmentation
  -- snapshot_stats
  -- shield_of_vengeance
  if S.ShieldofVengeance:IsCastable() and UseShieldofVengeance and ((CDs and ShieldofVengeanceWithCD) or not ShieldofVengeanceWithCD) then
    if Press(S.ShieldofVengeance) then return "shield_of_vengeance precombat 6"; end
  end
  -- variable,name=trinket_1_buffs,value=trinket.1.has_buff.strength|trinket.1.has_buff.mastery|trinket.1.has_buff.versatility|trinket.1.has_buff.haste|trinket.1.has_buff.crit
  -- variable,name=trinket_2_buffs,value=trinket.2.has_buff.strength|trinket.2.has_buff.mastery|trinket.2.has_buff.versatility|trinket.2.has_buff.haste|trinket.2.has_buff.crit
  -- variable,name=trinket_1_manual,value=trinket.1.is.manic_grieftorch
  -- variable,name=trinket_2_manual,value=trinket.2.is.manic_grieftorch
  -- variable,name=trinket_1_sync,op=setif,value=1,value_else=0.5,condition=variable.trinket_1_buffs&(trinket.1.cooldown.duration%%cooldown.crusade.duration=0|cooldown.crusade.duration%%trinket.1.cooldown.duration=0|trinket.1.cooldown.duration%%cooldown.avenging_wrath.duration=0|cooldown.avenging_wrath.duration%%trinket.1.cooldown.duration=0)
  -- variable,name=trinket_2_sync,op=setif,value=1,value_else=0.5,condition=variable.trinket_2_buffs&(trinket.2.cooldown.duration%%cooldown.crusade.duration=0|cooldown.crusade.duration%%trinket.2.cooldown.duration=0|trinket.2.cooldown.duration%%cooldown.avenging_wrath.duration=0|cooldown.avenging_wrath.duration%%trinket.2.cooldown.duration=0)
  -- variable,name=trinket_priority,op=setif,value=2,value_else=1,condition=!variable.trinket_1_buffs&variable.trinket_2_buffs|variable.trinket_2_buffs&((trinket.2.cooldown.duration%trinket.2.proc.any_dps.duration)*(1.5+trinket.2.has_buff.strength)*(variable.trinket_2_sync))>((trinket.1.cooldown.duration%trinket.1.proc.any_dps.duration)*(1.5+trinket.1.has_buff.strength)*(variable.trinket_1_sync))
  -- Note: Currently unable to handle some of the above trinket conditions.
  -- Manually added: openers
  if S.TemplarsVerdict:IsReady() and UseVerdict and HolyPower >= 4 and Target:IsInMeleeRange(5) then
    if Press(S.TemplarsVerdict) then return "either verdict precombat 2" end
  end
  if S.BladeofJustice:IsCastable() and UseBladeofJustice then
    if Press(S.BladeofJustice, not Target:IsSpellInRange(S.BladeofJustice)) then return "blade_of_justice precombat 4" end
  end
  if S.Judgment:IsCastable() and UseJudgment then
    if Press(S.Judgment, not Target:IsSpellInRange(S.Judgment)) then return "judgment precombat 6" end
  end
  if S.HammerofWrath:IsReady() and UseHammerofWrath then
    if Press(S.HammerofWrath, not Target:IsSpellInRange(S.HammerofWrath)) then return "hammer_of_wrath precombat 8" end
  end
  if S.CrusaderStrike:IsCastable() and UseCrusaderStrike then
    if Press(S.CrusaderStrike, not Target:IsInMeleeRange(5)) then return "crusader_strike precombat 10" end
  end
end

local function Cooldowns()
  -- potion,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10|fight_remains<25
  local ShouldReturnPot = Everyone.HandleDPSPotion(Player:BuffUp(S.AvengingWrathBuff) or (Player:BuffUp(S.CrusadeBuff) and Player.BuffStack(S.Crusade) == 10) or FightRemains < 25); if ShouldReturnPot then return ShouldReturnPot; end
  -- lights_judgment,if=spell_targets.lights_judgment>=2|!raid_event.adds.exists|raid_event.adds.in>75|raid_event.adds.up
  if S.LightsJudgment:IsCastable() and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) then
    if Press(S.LightsJudgment, not Target:IsInRange(40)) then return "lights_judgment cooldowns 4" end
  end
  -- fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
  if S.Fireblood:IsCastable() and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) and (Player:BuffUp(S.AvengingWrathBuff) or Player:BuffUp(S.CrusadeBuff) and Player:BuffStack(S.CrusadeBuff) == 10) then
    if Press(S.Fireblood, not Target:IsInMeleeRange(8)) then return "fireblood cooldowns 6" end
  end
  -- use_items
  if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) and Target:IsInMeleeRange(8) then
    ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
  end
  -- shield_of_vengeance,if=fight_remains>15
  if S.ShieldofVengeance:IsCastable() and UseShieldofVengeance and ((CDs and ShieldofVengeanceWithCD) or not ShieldofVengeanceWithCD) and (FightRemains > 15 and ((not S.ExecutionSentence:IsAvailable()) or Target:DebuffDown(S.ExecutionSentence))) then
    if Press(S.ShieldofVengeance) then return "shield_of_vengeance cooldowns 10"; end
  end
  -- execution_sentence,if=(!buff.crusade.up&cooldown.crusade.remains>10|buff.crusade.stack=10|cooldown.avenging_wrath.remains>10)&(holy_power>=3|holy_power>=2&talent.divine_auxiliary)&target.time_to_die>8
  if S.ExecutionSentence:IsCastable() and UseExecutionSentence and ((Player:BuffDown(S.CrusadeBuff) and S.Crusade:CooldownRemains() > 15 or Player:BuffStack(S.CrusadeBuff) == 10 or S.AvengingWrath:CooldownRemains() < 0.75 or S.AvengingWrath:CooldownRemains() > 15) and (HolyPower >= 3 or HolyPower >= 2 and S.DivineAuxiliary:IsAvailable()) and (Target:TimeToDie() > 8 or Target:TimeToDie() > 12 and S.ExecutionersWill:IsAvailable())) then
    if Press(S.ExecutionSentence, not Target:IsSpellInRange(S.ExecutionSentence)) then return "execution_sentence cooldowns 16"; end
  end
  -- avenging_wrath,if=holy_power>=4&time<5|holy_power>=3&time>5|holy_power>=2&talent.divine_auxiliary&(cooldown.execution.remains=0|cooldown.final_reckoning.remains=0)
  if S.AvengingWrath:IsCastable() and UseAvengingWrath and ((CDs and AvengingWrathWithCD) or not AvengingWrathWithCD) and (HolyPower >= 4 and EL.CombatTime() < 5 or HolyPower >= 3 and EL.CombatTime() > 5 or HolyPower >= 2 and S.DivineAuxiliary:IsAvailable() and (S.ExecutionSentence:CooldownUp() or S.FinalReckoning:CooldownUp())) then
    if Press(S.AvengingWrath, not Target:IsInMeleeRange(8)) then return "avenging_wrath cooldowns 12" end
  end
  -- crusade,if=holy_power>=4&time<5|holy_power>=3&time>5
  if S.Crusade:IsCastable() and UseCrusade and ((CDs and CrusadeWithCD) or not CrusadeWithCD) and (HolyPower >= 4 and EL.CombatTime() < 5 or HolyPower >= 3 and EL.CombatTime() >= 5) then
    if Press(S.Crusade, not Target:IsInMeleeRange(8)) then return "crusade cooldowns 14" end
  end
  -- final_reckoning,if=(holy_power>=4&time<8|holy_power>=3&time>=8|holy_power>=2&talent.divine_auxiliary)&(cooldown.avenging_wrath.remains>gcd|cooldown.crusade.remains&(!buff.crusade.up|buff.crusade.stack>=10))&(time_to_hpg>0|holy_power=5|holy_power>=2&talent.divine_auxiliary)&(!raid_event.adds.exists|raid_event.adds.up|raid_event.adds.in>40)
  if S.FinalReckoning:IsCastable() and UseFinalReckoning and ((CDs and FinalReckoningWithCD) or not FinalReckoningWithCD) and ((HolyPower >= 4 and EL.CombatTime() < 8 or HolyPower >= 3 and EL.CombatTime() >= 8 or HolyPower >= 2 and S.DivineAuxiliary:IsAvailable()) and (S.AvengingWrath:CooldownRemains() > 10 or S.Crusade:CooldownDown() and (Player:BuffDown(S.CrusadeBuff) or Player:BuffStack(S.CrusadeBuff) >= 10)) and (TimeToHPG > 0 or HolyPower == 5 or HolyPower >= 2 and S.DivineAuxiliary:IsAvailable())) then
    if FinalReckoningSetting == "player" then
      if Press(M.FinalReckoningPlayer, not Target:IsInMeleeRange(8)) then return "final_reckoning cooldowns 18" end
    end
    if FinalReckoningSetting == "cursor" then
      if Press(M.FinalReckoningCursor, not Target:IsInMeleeRange(8)) then return "final_reckoning cooldowns 18" end
    end
  end
end

local function Finishers()
  -- variable,name=ds_castable,value=spell_targets.divine_storm>=2|buff.empyrean_power.up
  VarDSCastable = ((EnemiesCount8y >= 3 or EnemiesCount8y >= 2 and (not S.DivineArbiter:IsAvailable()) or Player:BuffUp(S.EmpyreanPowerBuff)) and Player:BuffDown(S.EmpyreanLegacyBuff) and not (Player:BuffUp(S.DivineArbiterBuff) and Player:BuffStack(S.DivineArbiterBuff) > 24))
  -- divine_storm,if=variable.ds_castable&!buff.empyrean_legacy.up&!(buff.divine_arbiter.up&buff.divine_arbiter.stack>24)&((!talent.crusade|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence|talent.divine_auxiliary|target.time_to_die<8|cooldown.execution_sentence.remains>gcd*2)&(!talent.final_reckoning|talent.divine_auxiliary|cooldown.final_reckoning.remains>gcd*2)|buff.crusade.up&buff.crusade.stack<10)
  if S.DivineStorm:IsReady() and UseDivineStorm and (VarDSCastable and ((not S.Crusade:IsAvailable()) or S.Crusade:CooldownRemains() > PlayerGCD * 3 or Player:BuffUp(S.CrusadeBuff) and Player:BuffStack(S.CrusadeBuff) < 10)) then
    if Press(S.DivineStorm, not Target:IsInRange(8)) then return "divine_storm finishers 2" end
  end
  -- justicars_vengeance,if=(!talent.crusade|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence|talent.divine_auxiliary|target.time_to_die<8|cooldown.execution_sentence.remains>gcd*2)&(!talent.final_reckoning|talent.divine_auxiliary|cooldown.final_reckoning.remains>gcd*2)|buff.crusade.up&buff.crusade.stack<10
  if S.JusticarsVengeance:IsReady() and UseJusticarsVengeance and ((not S.Crusade:IsAvailable()) or S.Crusade:CooldownRemains() > PlayerGCD * 3 or Player:BuffUp(S.CrusadeBuff) and Player:BuffStack(S.CrusadeBuff) < 10) then
    if Press(S.JusticarsVengeance, not Target:IsInMeleeRange(5)) then return "justicars_vengeance finishers 4"; end
  end
  -- templars_verdict,if=(!talent.crusade|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence|talent.divine_auxiliary|target.time_to_die<8|cooldown.execution_sentence.remains>gcd*2)&(!talent.final_reckoning|talent.divine_auxiliary|cooldown.final_reckoning.remains>gcd*2)|buff.crusade.up&buff.crusade.stack<10
  if S.TemplarsVerdict:IsReady() and UseVerdict and ((not S.Crusade:IsAvailable()) or S.Crusade:CooldownRemains() > PlayerGCD * 3 or Player:BuffUp(S.CrusadeBuff) and Player:BuffStack(S.CrusadeBuff) < 10) then
    if Press(S.TemplarsVerdict, not Target:IsInMeleeRange(5)) then return "either verdict finishers 6" end
  end
end

local function Generators()
  -- call_action_list,name=finishers,if=holy_power=5|(debuff.judgment.up|holy_power=4)&buff.divine_resonance.up
  if (HolyPower >= 5 or (Target:DebuffUp(S.JudgmentDebuff) or HolyPower == 4) and Player:BuffUp(S.DivineResonanceBuff)) then
    ShouldReturn = Finishers(); if ShouldReturn then return ShouldReturn; end
  end
  -- wake_of_ashes,if=holy_power<=2&(cooldown.avenging_wrath.remains|cooldown.crusade.remains)&(!talent.execution_sentence|cooldown.execution_sentence.remains>4|target.time_to_die<8)&(!raid_event.adds.exists|raid_event.adds.in>20|raid_event.adds.up)
  if S.WakeofAshes:IsCastable() and UseWakeofAshes and (HolyPower <= 2 and (S.AvengingWrath:CooldownDown() or S.Crusade:CooldownDown()) and ((not S.ExecutionSentence:IsAvailable()) or S.ExecutionSentence:CooldownRemains() > 4 or FightRemains < 8)) then
    if Press(S.WakeofAshes, not Target:IsInMeleeRange(12)) then return "wake_of_ashes generators 2"; end
  end
  -- divine_toll,if=holy_power<=2&!debuff.judgment.up&(!raid_event.adds.exists|raid_event.adds.in>30|raid_event.adds.up)&(cooldown.avenging_wrath.remains>15|cooldown.crusade.remains>15|fight_remains<8)
  if S.DivineToll:IsCastable() and UseDivineToll and (HolyPower <= 2 and Target:DebuffDown(S.JudgmentDebuff) and (S.AvengingWrath:CooldownRemains() > 15 or S.Crusade:CooldownRemains() > 15 or FightRemains < 8)) then
    if Press(S.DivineToll, not Target:IsInRange(30)) then return "divine_toll generators 6"; end
  end
  -- call_action_list,name=finishers,if=holy_power>=3&buff.crusade.up&buff.crusade.stack<10
  if (HolyPower >= 3 and Player:BuffUp(S.CrusadeBuff) and Player:BuffStack(S.CrusadeBuff) < 10) then
    ShouldReturn = Finishers(); if ShouldReturn then return ShouldReturn; end
  end
  -- templar_slash,if=buff.templar_strikes.remains<gcd&spell_targets.divine_storm>=2
  if S.TemplarSlash:IsReady() and UseTemplarSlash and (S.TemplarStrike:TimeSinceLastCast() + PlayerGCD < 4 and EnemiesCount8y >= 2) then
    if Press(S.TemplarSlash, not Target:IsInMeleeRange(9)) then return "templar_slash generators 8"; end
  end
  -- blade_of_justice,if=(holy_power<=3|!talent.holy_blade)&spell_targets.divine_storm>=2
  if S.BladeofJustice:IsCastable() and UseBladeofJustice and ((HolyPower <= 3 or not S.HolyBlade:IsAvailable()) and (EnemiesCount8y >= 2 and (not S.CrusadingStrikes:IsAvailable()) or EnemiesCount8y >= 4)) then
    if Press(S.BladeofJustice, not Target:IsSpellInRange(S.BladeofJustice)) then return "blade_of_justice generators 12"; end
  end
  -- hammer_of_wrath,if=(spell_targets.divine_storm<2|!talent.blessed_champion|set_bonus.tier30_4pc)&(holy_power<=3|target.health.pct>20|!talent.vanguards_momentum)
  if S.HammerofWrath:IsReady() and UseHammerofWrath and ((EnemiesCount8y < 2 or (not S.BlessedChampion:IsAvailable()) or Player:HasTier(30, 4)) and (HolyPower <= 3 or Target:HealthPercentage() > 20 or not S.VanguardsMomentum:IsAvailable())) then
    if Press(S.HammerofWrath, not Target:IsSpellInRange(S.HammerofWrath)) then return "hammer_of_wrath generators 10"; end
  end
  -- templar_slash,if=buff.templar_strikes.remains<gcd
  if S.TemplarSlash:IsReady() and UseTemplarSlash and (S.TemplarStrike:TimeSinceLastCast() + PlayerGCD < 4) then
    if Press(S.TemplarSlash, not Target:IsSpellInRange(S.TemplarSlash)) then return "templar_slash generators 12"; end
  end
  -- judgment,if=!debuff.judgment.up&(holy_power<=3|!talent.boundless_judgment)&spell_targets.divine_storm>=2
  if S.Judgment:IsReady() and UseJudgment and (Player:BuffDown(S.AvengingWrathBuff) and (Player:HolyPower() <= 3 or not S.BoundlessJudgment:IsAvailable()) and S.CrusadingStrikes:IsAvailable()) then
    if Press(S.Judgment, not Target:IsSpellInRange(S.Judgment)) then return "judgment generators 10"; end
  end
  -- blade_of_justice,if=holy_power<=3|!talent.holy_blade
  if S.BladeofJustice:IsCastable() and UseBladeofJustice and (HolyPower <= 3 or not S.HolyBlade:IsAvailable()) then
    if Press(S.BladeofJustice, not Target:IsSpellInRange(S.BladeofJustice)) then return "blade_of_justice generators 18"; end
  end
  -- judgment,if=!debuff.judgment.up&(holy_power<=3|!talent.boundless_judgment)
  if S.Judgment:IsReady() and UseJudgment and (Target:DebuffDown(S.JudgmentDebuff) and (HolyPower <= 3 or not S.BoundlessJudgment:IsAvailable())) then
    if Press(S.Judgment, not Target:IsSpellInRange(S.Judgment)) then return "judgment generators 20"; end
  end
  -- call_action_list,name=finishers,if=(target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up|buff.empyrean_power.up)
  if (Target:HealthPercentage() <= 20 or Player:BuffUp(S.AvengingWrathBuff) or Player:BuffUp(S.CrusadeBuff) or Player:BuffUp(S.EmpyreanPowerBuff)) then
    ShouldReturn = Finishers(); if ShouldReturn then return ShouldReturn; end
  end
  -- consecration,if=!consecration.up&spell_targets.divine_storm>=2
  if S.Consecration:IsCastable() and UseConsecration and (Target:DebuffDown(S.ConsecrationDebuff) and EnemiesCount8y >= 2) then
    if Press(S.Consecration, not Target:IsInMeleeRange(8)) then return "consecration generators 22"; end
  end
  -- divine_hammer,if=spell_targets.divine_storm>=2
  if S.DivineHammer:IsCastable() and UseDivineHammer and (EnemiesCount8y >= 2) then
    if Press(S.DivineHammer, not Target:IsInMeleeRange(8)) then return "divine_hammer generators 24"; end
  end
  -- crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2)
  if S.CrusaderStrike:IsCastable() and UseCrusaderStrike and (S.CrusaderStrike:ChargesFractional() >= 1.75 and (HolyPower <= 2 or HolyPower <= 3 and S.BladeofJustice:CooldownRemains() > PlayerGCD * 2 or HolyPower == 4 and S.BladeofJustice:CooldownRemains() > PlayerGCD * 2 and S.Judgment:CooldownRemains() > PlayerGCD * 2)) then
    if Press(S.CrusaderStrike, not Target:IsInMeleeRange(5)) then return "crusader_strike generators 26"; end
  end
  -- call_action_list,name=finishers
  ShouldReturn = Finishers(); if ShouldReturn then return ShouldReturn; end
  -- templar_slash
  if S.TemplarSlash:IsReady() and UseTemplarSlash then
    if Press(S.TemplarSlash, not Target:IsInMeleeRange(9)) then return "templar_slash generators 28"; end
  end
  -- templar_strike
  if S.TemplarStrike:IsReady() and UseTemplarStrike then
    if Press(S.TemplarStrike, not Target:IsInMeleeRange(9)) then return "templar_strike generators 30"; end
  end
  -- judgment,if=holy_power<=3|!talent.boundless_judgment
  if S.Judgment:IsReady() and UseJudgment and (HolyPower <= 3 or not S.BoundlessJudgment:IsAvailable()) then
    if Press(S.Judgment, not Target:IsSpellInRange(S.Judgment)) then return "judgment generators 32"; end
  end
  -- hammer_of_wrath,if=holy_power<=3|target.health.pct>20|!talent.vanguards_momentum
  if S.HammerofWrath:IsReady() and UseHammerofWrath and (HolyPower <= 3 or Target:HealthPercentage() > 20 or not S.VanguardsMomentum:IsAvailable()) then
    if Press(S.HammerofWrath, not Target:IsSpellInRange(S.HammerofWrath)) then return "hammer_of_wrath generators 34"; end
  end
  -- crusader_strike
  if S.CrusaderStrike:IsCastable() and UseCrusaderStrike then
    if Press(S.CrusaderStrike, not Target:IsInMeleeRange(5)) then return "crusader_strike generators 26"; end
  end
  -- arcane_torrent
  if S.ArcaneTorrent:IsCastable() and ((RacialsWithCD and CDs) or not RacialsWithCD) and UseRacials and HolyPower < 5 then
    if Press(S.ArcaneTorrent, not Target:IsInRange(8)) then return "arcane_torrent generators 28"; end
  end
  -- consecration
  if S.Consecration:IsCastable() and UseConsecration then
    if Press(S.Consecration, not Target:IsInMeleeRange(8)) then return "consecration generators 30"; end
  end
  -- divine_hammer
  if S.DivineHammer:IsCastable() and UseDivineHammer then
    if Press(S.DivineHammer, not Target:IsInMeleeRange(8)) then return "divine_hammer generators 32"; end
  end
end

local function FetchUseSettings()
  --Settings Use
  UseBladeofJustice = EpicSettings.Settings["useBladeofJustice"]
  UseConsecration = EpicSettings.Settings["useConsecration"]
  UseCrusaderStrike = EpicSettings.Settings["useCrusaderStrike"]
  UseDivineHammer = EpicSettings.Settings["useDivineHammer"]
  UseDivineStorm = EpicSettings.Settings["useDivineStorm"]
  UseDivineToll = EpicSettings.Settings["useDivineToll"]
  UseExecutionSentence = EpicSettings.Settings["useExecutionSentence"]
  UseHammerofWrath = EpicSettings.Settings["useHammerofWrath"]
  UseJudgment = EpicSettings.Settings["useJudgment"]
  UseJusticarsVengeance = EpicSettings.Settings["useJusticarsVengeance"]
  UseTemplarSlash = EpicSettings.Settings["useTemplarSlash"]
  UseTemplarStrike = EpicSettings.Settings["useTemplarStrike"]
  UseWakeofAshes = EpicSettings.Settings["useWakeofAshes"]
  UseVerdict = EpicSettings.Settings["useVerdict"]

  --Settings Use with CDs 
  UseAvengingWrath = EpicSettings.Settings["useAvengingWrath"]
  UseCrusade = EpicSettings.Settings["useCrusade"]
  UseFinalReckoning = EpicSettings.Settings["useFinalReckoning"]
  UseShieldofVengeance = EpicSettings.Settings["useShieldofVengeance"]

  --Settings WithCDs
  AvengingWrathWithCD = EpicSettings.Settings["avengingWrathWithCD"]
  CrusadeWithCD = EpicSettings.Settings["crusadeWithCD"]
  FinalReckoningWithCD = EpicSettings.Settings["finalReckoningWithCD"]
  ShieldofVengeanceWithCD = EpicSettings.Settings["shieldofVengeanceWithCD"]
end

local function FetchSettings()
  --Interrupt Use Settings
  UseRebuke = EpicSettings.Settings["useRebuke"]
  UseHammerofJustice = EpicSettings.Settings["useHammerofJustice"]

  --Settings UseDefensives
  UseDivineProtection = EpicSettings.Settings["useDivineProtection"]
  UseDivineShield = EpicSettings.Settings["useDivineShield"]
  UseLayonHands = EpicSettings.Settings["useLayonHands"]

  UseLayOnHandsFocus = EpicSettings.Settings["useLayonHandsFocus"]
  UseWordofGloryFocus = EpicSettings.Settings["useWordofGloryFocus"]
  UseBlessingOfProtectionFocus = EpicSettings.Settings["useBlessingOfProtectionFocus"]
  UseBlessingOfSacrificeFocus = EpicSettings.Settings["useBlessingOfSacrificeFocus"]

  --Settings DefensiveHP
  DivineProtectionHP = EpicSettings.Settings["divineProtectionHP"] or 0
  DivineShieldHP = EpicSettings.Settings["divineShieldHP"] or 0
  LayonHandsHP = EpicSettings.Settings["layonHandsHP"] or 0

  LayOnHandsFocusHP = EpicSettings.Settings["layonHandsFocusHP"] or 0
  WordofGloryFocusHP = EpicSettings.Settings["wordofGloryFocusHP"] or 0
  BlessingofProtectionFocusHP = EpicSettings.Settings["blessingofProtectionFocusHP"] or 0
  BlessingofSacrificeFocusHP = EpicSettings.Settings["blessingofSacrificeFocusHP"] or 0

--Afflicted Settings
  UseCleanseToxinsWithAfflicted = EpicSettings.Settings["useCleanseToxinsWithAfflicted"]
  UseWordofGloryWithAfflicted = EpicSettings.Settings["useWordofGloryWithAfflicted"]

  FinalReckoningSetting = EpicSettings.Settings["finalReckoningSetting"] or ""
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

  UseHealOOC = EpicSettings.Settings["HealOOC"]
  HealOOCHP = EpicSettings.Settings["HealOOCHP"] or 0
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

  Enemies5y = Player:GetEnemiesInMeleeRange(5) -- Light's Judgment
  Enemies8y = Player:GetEnemiesInMeleeRange(8) -- Divine Storm
  -- Enemies Update
  if AOE then
    EnemiesCount8y = #Enemies8y
  else
    Enemies8y = {}
    EnemiesCount8y = 1
    Enemies5y = {}
  end

  if not Player:AffectingCombat() and Player:IsMounted() then
    if S.CrusaderAura:IsCastable() and (Player:BuffDown(S.CrusaderAura)) then
      if Press(S.CrusaderAura) then return "crusader_aura"; end
    end
  end

  --Focus and Dispell
  if Player:AffectingCombat() or DispelDebuffs then
    local includeDispellableUnits = DispelDebuffs and S.CleanseToxins:IsReady() and DispelToggle
    ShouldReturn = Everyone.FocusUnit(includeDispellableUnits, nil, nil, nil); if ShouldReturn then return ShouldReturn; end
  end

  -- Rotation Variables Update
  TimeToHPG = ComputeTimeToHPG()
  
  if not Player:AffectingCombat() then
    -- retribution_aura
    if S.RetributionAura:IsCastable() and (MissingAura()) then
      if Press(S.RetributionAura) then return "retribution_aura"; end
    end
  end

  -- revive
  if Target and Target:Exists() and Target:IsAPlayer() and Target:IsDeadOrGhost() and not Player:CanAttack(Target) then
    if Player:AffectingCombat() then
      if S.Intercession:IsCastable() then
        if Press(S.Intercession, nil, true) then return "intercession target"; end
      end
    else
      if S.Redemption:IsCastable() then
        if Press(S.Redemption, not Target:IsInRange(40), true) then return "redemption target"; end
      end
    end
  end
  --Redemption Mouseover
  if S.Redemption:IsCastable() and S.Redemption:IsReady() and not Player:AffectingCombat() and Mouseover:Exists() and Mouseover:IsDeadOrGhost() and Mouseover:IsAPlayer() and (not Player:CanAttack(Mouseover))  then
    if Press(M.RedemptionMouseover) then return "redemption mouseover" end
  end

  if Player:AffectingCombat() then
    --Intercession
    if S.Intercession:IsCastable() and Player:HolyPower() >=3 and S.Intercession:IsReady() and Player:AffectingCombat() and Mouseover:Exists() and Mouseover:IsDeadOrGhost() and Mouseover:IsAPlayer() and (not Player:CanAttack(Mouseover))  then
      if Press(M.IntercessionMouseover) then return "Intercession mouseover" end
    end
  end

  if Everyone.TargetIsValid() or Player:AffectingCombat() then
    -- Calculate fight_remains
    BossFightRemains = EL.BossFightRemains(nil, true)
    FightRemains = BossFightRemains
    if FightRemains == 11111 then
      FightRemains = EL.FightRemains(Enemies8y, false)
    end

    -- We check Player:GCD() and Player:HolyPower() a lot, so let's put them in variables
    PlayerGCD = Player:GCD()
    HolyPower = Player:HolyPower()
  end

  -- Afflicted
  if HandleAfflicted then
    if UseCleanseToxinsWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.CleanseToxins, M.CleanseToxinsMouseover, 40); if ShouldReturn then return ShouldReturn; end
    end
    if UseWordofGloryWithAfflicted and HolyPower > 2 then
      ShouldReturn = Everyone.HandleAfflicted(S.WordofGlory, M.WordofGloryMouseover, 40, true); if ShouldReturn then return ShouldReturn; end
    end
  end
    
  -- Incorporeal
  if HandleIncorporeal then
    ShouldReturn = Everyone.HandleIncorporeal(S.Repentance, M.RepentanceMouseOver, 30, true); if ShouldReturn then return ShouldReturn; end
    ShouldReturn = Everyone.HandleIncorporeal(S.TurnEvil, M.TurnEvilMouseOver, 30, true); if ShouldReturn then return ShouldReturn; end
  end

  -- heal
  ShouldReturn = HealOOC(); if ShouldReturn then return ShouldReturn; end

  if Focus then
    -- dispel
    if DispelDebuffs then
      ShouldReturn = Dispel(); if ShouldReturn then return ShouldReturn; end
    end
  end

  -- heal
  ShouldReturn = DefensivesGroup(); if ShouldReturn then return ShouldReturn; end

  if Everyone.TargetIsValid() then
    -- Precombat
    if not Player:AffectingCombat() then
      ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
    end
    -- auto_attack
    -- Interrupts
    if not Player:IsCasting() and not Player:IsChanneling() then
      ShouldReturn = Everyone.Interrupt(S.Rebuke, 5, true); if ShouldReturn then return ShouldReturn; end
      ShouldReturn = Everyone.InterruptWithStun(S.HammerofJustice, 8); if ShouldReturn then return ShouldReturn; end
    end
    
    if UseLayOnHands and Player:HealthPercentage() <= LayonHandsHP and S.LayonHands:IsReady() and Player:DebuffDown(S.ForbearanceDebuff) then
      if Press(S.LayonHands) then return "lay_on_hands_player defensive"; end
    end
    if UseDivineShield and Player:HealthPercentage() <= DivineShieldHP and S.DivineShield:IsCastable() and Player:DebuffDown(S.ForbearanceDebuff) then
      if Press(S.DivineShield) then return "divine_shield defensive"; end
    end
    if UseDivineProtection and S.DivineProtection:IsCastable() and Player:HealthPercentage() <= DivineProtectionHP then
      if Press(S.DivineProtection) then return "divine_protection defensive"; end
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
    -- call_action_list,name=cooldowns
    if (FightRemainsCheck < FightRemains) then
      ShouldReturn = Cooldowns(); if ShouldReturn then return ShouldReturn; end
    end
    -- call_action_list,name=generators
    ShouldReturn = Generators(); if ShouldReturn then return ShouldReturn; end
    -- Manually added: Pooling, if nothing else to do
    if Press(S.Pool) then return "Wait/Pool Resources"; end
  end
end

local function Init()
  ER.Print("Retribution Paladin by Epic. Supported by xKaneto.")
  FillDispels()
end

ER.SetAPL(70, APL, OnInit)
