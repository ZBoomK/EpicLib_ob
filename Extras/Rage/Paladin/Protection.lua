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
local stringformat = string.format

--- ============================ CONTENT ===========================

local ShouldReturn

-- Toggles
local OOC = false;
local AOE = false;
local CDs = false;
local Kick = false;
local DispelToggle = false;

--Settings Use
local UseAvengersShield
local UseBlessedHammer
local UseConsecration
local UseCrusaderStrike
local UseHammeroftheRighteous
local UseHammerofWrath
local UseJudgment

--Settings Use with CDs 
local UseAvengingWrath
local UseBastionofLight
local UseDivineToll
local UseEyeofTyr
local UseMomentOfGlory
local UseSentinel

--Settings WithCDs
local AvengingWrathWithCD
local BastionofLightWithCD
local DivineTollWithCD
local EyeofTyrWithCD
local MomentofGloryWithCD
local SentinelWithCD

--Interrupt Use Settings
local UseRebuke
local UseHammerofJustice

--Settings UseDefensives
local UseArdentDefender
local UseDivineShield
local UseGuardianofAncientKings
local UseLayOnHands
local UseWordofGloryPlayer
local UseShieldoftheRighteous

local UseLayOnHandsFocus
local UseWordofGloryFocus
local UseBlessingOfProtectionFocus
local UseBlessingOfSacrificeFocus

--Settings DefensiveHP
local ArdentDefenderHP
local DivineShieldHP
local GuardianofAncientKingsHP
local LayonHandsHP
local WordofGloryHP
local ShieldoftheRighteousHP

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

--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Define S/I for spell and item arrays
local S = Spell.Paladin.Protection
local I = Item.Paladin.Protection
local M = Macro.Paladin.Protection

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
}

-- Rotation Var
local ActiveMitigationNeeded
local IsTanking
local Enemies8y, Enemies30y
local EnemiesCount8y, EnemiesCount30y

-- GUI Settings
local Everyone = ER.Commons.Everyone
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.Paladin.Commons,
--  Protection = ER.GUISettings.APL.Paladin.Protection
--}

local function FillDispels()
  if S.CleanseToxins:IsAvailable() then
    Everyone.DispellableDebuffs = Utils.MergeTable(Everyone.DispellableDiseaseDebuffs, Everyone.DispellablePoisonDebuffs)
  end
end

EL:RegisterForEvent(function()
  FillDispels()
end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");

local function EvaluateTargetIfFilterJudgment(TargetUnit)
  return TargetUnit:DebuffRemains(S.JudgmentDebuff)
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

local function Defensives()
  if Player:HealthPercentage() <= DivineShieldHP and UseDivineShield and S.DivineShield:IsCastable() and Player:DebuffDown(S.ForbearanceDebuff) then
    if Press(S.DivineShield) then return "divine_shield defensive"; end
  end
  if Player:HealthPercentage() <= LayonHandsHP and UseLayOnHands and S.LayonHands:IsCastable() and Player:DebuffDown(S.ForbearanceDebuff) then
    if Press(M.LayonHandsPlayer) then return "lay_on_hands defensive 2"; end
  end
  if S.GuardianofAncientKings:IsCastable() and (Player:HealthPercentage() <= GuardianofAncientKingsHP and UseGuardianofAncientKings and Player:BuffDown(S.ArdentDefenderBuff)) then
    if Press(S.GuardianofAncientKings) then return "guardian_of_ancient_kings defensive 4"; end
  end
  if S.ArdentDefender:IsCastable() and (Player:HealthPercentage() <= ArdentDefenderHP and UseArdentDefender and Player:BuffDown(S.GuardianofAncientKingsBuff)) then
    if Press(S.ArdentDefender) then return "ardent_defender defensive 6"; end
  end
  if S.WordofGlory:IsReady() and (Player:HealthPercentage() <= WordofGloryHP and UseWordofGloryPlayer and not Player:HealingAbsorbed()) then
    if Press(M.WordofGloryPlayer) then return "word_of_glory defensive 8"; end
  end  
  if S.ShieldoftheRighteous:IsReady() and (Player:BuffRefreshable(S.ShieldoftheRighteousBuff) and UseShieldoftheRighteous and (ActiveMitigationNeeded or Player:HealthPercentage() <= ShieldoftheRighteousHP)) then
    if Press(S.ShieldoftheRighteous) then return "shield_of_the_righteous defensive 12"; end
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

local function DefensivesGroup()
  if not Focus or not Focus:Exists() or not Focus:IsInRange(40) then return; end
  if Focus then
    -- Word of Glory Focus
    if S.WordofGlory:IsReady() and UseWordofGloryFocus and Player:BuffUp(S.ShiningLightFreeBuff) and (Focus:HealthPercentage() <= WordofGloryFocusHP and not Focus:HealingAbsorbed()) then
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

local function Precombat()
  -- flask
  -- food
  -- augmentation
  -- snapshot_stats
  -- lights_judgment
  if FightRemainsCheck < FightRemains and S.LightsJudgment:IsCastable() and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) then
    if Press(S.LightsJudgment, not Target:IsSpellInRange(S.LightsJudgment)) then return "lights_judgment precombat 4"; end
  end
  -- arcane_torrent
  if FightRemainsCheck < FightRemains and S.ArcaneTorrent:IsCastable() and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) and HolyPower < 5 then
    if Press(S.ArcaneTorrent, not Target:IsInRange(8)) then return "arcane_torrent precombat 6"; end
  end
  -- consecration
  if S.Consecration:IsCastable() and UseConsecration then
    if Press(S.Consecration, not Target:IsInMeleeRange(8)) then return "consecration"; end
  end
  -- Manually added: avengers_shield
  if S.AvengersShield:IsCastable() and UseAvengersShield then
    if Press(S.AvengersShield, not Target:IsSpellInRange(S.AvengersShield)) then return "avengers_shield precombat 10"; end
  end
  -- Manually added: judgment
  if S.Judgment:IsReady() and UseJudgment then
    if Press(S.Judgment, not Target:IsSpellInRange(S.Judgment)) then return "judgment precombat 12"; end
  end
end

local function Cooldowns()
  -- avenging_wrath
  if S.AvengingWrath:IsCastable() and UseAvengingWrath and ((AvengingWrathWithCD and CDs) or not AvengingWrathWithCD) then
    if Press(S.AvengingWrath, not Target:IsInMeleeRange(8)) then return "avenging_wrath cooldowns 4"; end
  end
  -- potion,if=buff.avenging_wrath.up
  local ShouldReturnPot = Everyone.HandleDPSPotion(Player:BuffUp(S.AvengingWrathBuff)); if ShouldReturnPot then return ShouldReturnPot; end

  -- TODO  
  -- sentinel
  -- Note: Protection Paladin APL has back-end code to replace AW with Sentinel when talented.
  if S.Sentinel:IsCastable() and UseSentinel and ((SentinelWithCD and CDs) or not SentinelWithCD) then
    if Press(S.Sentinel, not Target:IsInMeleeRange(8)) then return "sentinel cooldowns 6"; end
  end
  -- moment_of_glory,if=(buff.avenging_wrath.remains<15|(time>10|(cooldown.avenging_wrath.remains>15))&(cooldown.avengers_shield.remains&cooldown.judgment.remains&cooldown.hammer_of_wrath.remains))
  if S.MomentofGlory:IsCastable() and UseMomentOfGlory and ((MomentofGloryWithCD and CDs) or not MomentofGloryWithCD) and (Player:BuffRemains(S.AvengingWrathBuff) < 15 or (EL.CombatTime() > 10 or (S.AvengingWrath:CooldownRemains() > 15)) and (S.AvengersShield:CooldownDown() and S.Judgment:CooldownDown() and S.HammerofWrath:CooldownDown())) then
    if Press(S.MomentofGlory, not Target:IsInMeleeRange(8)) then return "moment_of_glory cooldowns 8"; end
  end
  -- bastion_of_light,if=buff.avenging_wrath.up
  if S.BastionofLight:IsCastable() and UseBastionofLight and ((BastionofLightWithCD and CDs) or not BastionofLightWithCD) and (Player:BuffUp(S.AvengingWrathBuff)) then
    if Press(S.BastionofLight, not Target:IsInMeleeRange(8)) then return "bastion_of_light cooldowns 12"; end
  end
end

local function Standard()
  -- shield_of_the_righteous,if=(!talent.righteous_protector.enabled|cooldown.righteous_protector_icd.remains=0)&(buff.bastion_of_light.up|buff.divine_purpose.up|holy_power>2)
  -- TODO: Find a way to track RighteousProtector ICD.
  if S.ShieldoftheRighteous:IsReady() and UseShieldoftheRighteous and (Player:BuffUp(S.BastionofLightBuff) or Player:BuffUp(S.DivinePurposeBuff) or Player:HolyPower() > 2) then
    if Press(S.ShieldoftheRighteous) then return "shield_of_the_righteous standard 2"; end
  end
  -- avengers_shield,if=buff.moment_of_glory.up|!talent.moment_of_glory.enabled
  if S.AvengersShield:IsCastable() and UseAvengersShield and (Player:BuffUp(S.MomentofGloryBuff) or not S.MomentofGlory:IsAvailable()) then
    if Press(S.AvengersShield, not Target:IsSpellInRange(S.AvengersShield)) then return "avengers_shield standard 4"; end
  end
  -- hammer_of_wrath,if=buff.avenging_wrath.up
  if S.HammerofWrath:IsReady() and UseHammerofWrath and (Player:BuffUp(S.AvengingWrathBuff)) then
    if Press(S.HammerofWrath, not Target:IsSpellInRange(S.HammerofWrath)) then return "hammer_of_wrath standard 6"; end
  end
  -- judgment,target_if=min:debuff.judgment.remains,if=charges=2|!talent.crusaders_judgment.enabled
  if S.Judgment:IsReady() and UseJudgment and (S.Judgment:Charges() == 2 or not S.CrusadersJudgment:IsAvailable()) then
    if Everyone.CastTargetIf(S.Judgment, Enemies30y, "min", EvaluateTargetIfFilterJudgment, nil, not Target:IsSpellInRange(S.Judgment), nil, nil, M.JudgmentMouseover) then return "judgment standard 8"; end
  end
  -- divine_toll,if=time>20|((buff.avenging_wrath.up|!talent.avenging_wrath.enabled)&(buff.moment_of_glory.up|!talent.moment_of_glory.enabled))
  if FightRemainsCheck < FightRemains and UseDivineToll and ((DivineTollWithCD and CDs) or not DivineTollWithCD) and S.DivineToll:IsReady() then
    if Press(S.DivineToll, not Target:IsInRange(30)) then return "divine_toll standard 10"; end
  end
  -- avengers_shield
  if S.AvengersShield:IsCastable() and UseAvengersShield then
    if Press(S.AvengersShield, not Target:IsSpellInRange(S.AvengersShield)) then return "avengers_shield standard 12"; end
  end
  -- hammer_of_wrath
  if S.HammerofWrath:IsReady() and UseHammerofWrath then
    if Press(S.HammerofWrath, not Target:IsSpellInRange(S.HammerofWrath)) then return "hammer_of_wrath standard 14"; end
  end
  -- judgment,target_if=min:debuff.judgment.remains
  if S.Judgment:IsReady() and UseJudgment then
    if Everyone.CastTargetIf(S.Judgment, Enemies30y, "min", EvaluateTargetIfFilterJudgment, nil, not Target:IsSpellInRange(S.Judgment), nil, nil, M.JudgmentMouseover) then return "judgment standard 16"; end
  end
  -- consecration,if=!consecration.up
  if S.Consecration:IsCastable() and UseConsecration and (Player:BuffDown(S.ConsecrationBuff)) then
    if Press(S.Consecration, not Target:IsInMeleeRange(8)) then return "consecration standard 18"; end
  end
  -- eye_of_tyr,if=talent.inmost_light.enabled&raid_event.adds.in>=45
  if FightRemainsCheck < FightRemains and UseEyeofTyr and ((EyeofTyrWithCD and CDs) or not EyeofTyrWithCD) and S.EyeofTyr:IsCastable() and (S.InmostLight:IsAvailable()) then
    if Press(S.EyeofTyr, not Target:IsInMeleeRange(8)) then return "eye_of_tyr standard 20"; end
  end
  -- blessed_hammer
  if S.BlessedHammer:IsCastable() and UseBlessedHammer then
    if Press(S.BlessedHammer, not Target:IsInMeleeRange(5)) then return "blessed_hammer standard 22"; end
  end
  -- hammer_of_the_righteous
  if S.HammeroftheRighteous:IsCastable() and UseHammeroftheRighteous then
    if Press(S.HammeroftheRighteous, not Target:IsInMeleeRange(5)) then return "hammer_of_the_righteous standard 24"; end
  end
  -- crusader_strike
  if S.CrusaderStrike:IsCastable() and UseCrusaderStrike then
    if Press(S.CrusaderStrike, not Target:IsInMeleeRange(5)) then return "crusader_strike standard 26"; end
  end
  -- eye_of_tyr,if=!talent.inmost_light.enabled&raid_event.adds.in>=60
  if FightRemainsCheck < FightRemains and UseEyeofTyr and ((EyeofTyrWithCD and CDs) or not EyeofTyrWithCD) and S.EyeofTyr:IsCastable() and (not S.InmostLight:IsAvailable()) then
    if Press(S.EyeofTyr, not Target:IsInMeleeRange(8)) then return "eye_of_tyr standard 27"; end
  end
  -- word_of_glory,if=buff.shining_light_free.up
  if S.WordofGlory:IsReady() and Player:BuffUp(S.ShiningLightFreeBuff) then
    if Player:HealthPercentage() > 90 and Player:IsInParty() and not Player:IsInRaid() then
      ShouldReturn = Everyone.FocusUnit(false, M); if ShouldReturn then return ShouldReturn; end
      if Focus and Focus:Exists() and Focus:HealthPercentage() < 80 then
        if Press(M.WordofGloryFocus) then return "word_of_glory standard party 28"; end
      end
    else
      if Press(M.WordofGloryPlayer) then return "word_of_glory standard self 32"; end
    end
  end
  -- consecration
  if S.Consecration:IsCastable() and UseConsecration then
    if Press(S.Consecration, not Target:IsInMeleeRange(8)) then return "consecration standard 34"; end
  end
end

local function FetchUseSettings()
  --Settings Use
  UseAvengersShield = EpicSettings.Settings["useAvengersShield"]
  UseBlessedHammer = EpicSettings.Settings["useBlessedHammer"]
  UseConsecration = EpicSettings.Settings["useConsecration"]
  UseCrusaderStrike = EpicSettings.Settings["useCrusaderStrike"]
  UseHammeroftheRighteous = EpicSettings.Settings["useHammeroftheRighteous"]
  UseHammerofWrath = EpicSettings.Settings["useHammerofWrath"]
  UseJudgment = EpicSettings.Settings["useJudgment"]

--Settings Use with CDs 
  UseAvengingWrath = EpicSettings.Settings["useAvengingWrath"]
  UseBastionofLight = EpicSettings.Settings["useBastionofLight"]
  UseDivineToll = EpicSettings.Settings["useDivineToll"]
  UseEyeofTyr = EpicSettings.Settings["useEyeofTyr"]
  UseMomentOfGlory = EpicSettings.Settings["useMomentOfGlory"]
  UseSentinel = EpicSettings.Settings["useSentinel"]

--Settings WithCDs
  AvengingWrathWithCD = EpicSettings.Settings["avengingWrathWithCD"]
  BastionofLightWithCD = EpicSettings.Settings["bastionofLightWithCD"]
  DivineTollWithCD = EpicSettings.Settings["divineTollWithCD"]
  EyeofTyrWithCD = EpicSettings.Settings["eyeofTyrWithCD"]
  MomentofGloryWithCD = EpicSettings.Settings["momentofGloryWithCD"]
  SentinelWithCD = EpicSettings.Settings["sentinelWithCD"]
end


local function FetchSettings()
--Interrupt Use Settings
  UseRebuke = EpicSettings.Settings["useRebuke"]
  UseHammerofJustice = EpicSettings.Settings["useHammerofJustice"]

--Settings UseDefensives
  UseArdentDefender = EpicSettings.Settings["useArdentDefender"]
  UseDivineShield = EpicSettings.Settings["useDivineShield"]
  UseGuardianofAncientKings = EpicSettings.Settings["useGuardianofAncientKings"]
  UseLayOnHands = EpicSettings.Settings["useLayOnHands"]
  UseWordofGloryPlayer  = EpicSettings.Settings["useWordofGloryPlayer"]
  UseShieldoftheRighteous = EpicSettings.Settings["useShieldoftheRighteous"]

  UseLayOnHandsFocus = EpicSettings.Settings["useLayOnHandsFocus"]
  UseWordofGloryFocus = EpicSettings.Settings["useWordofGloryFocus"]
  UseBlessingOfProtectionFocus = EpicSettings.Settings["useBlessingOfProtectionFocus"]
  UseBlessingOfSacrificeFocus = EpicSettings.Settings["useBlessingOfSacrificeFocus"]

--Settings DefensiveHP
  ArdentDefenderHP = EpicSettings.Settings["ardentDefenderHP"]
  DivineShieldHP = EpicSettings.Settings["divineShieldHP"]
  GuardianofAncientKingsHP = EpicSettings.Settings["guardianofAncientKingsHP"]
  LayonHandsHP = EpicSettings.Settings["layonHandsHP"]
  WordofGloryHP = EpicSettings.Settings["wordofGloryHP"]
  ShieldoftheRighteousHP = EpicSettings.Settings["shieldoftheRighteousHP"]
 
  LayOnHandsFocusHP = EpicSettings.Settings["layOnHandsFocusHP"]
  WordofGloryFocusHP = EpicSettings.Settings["wordofGloryFocusHP"]
  BlessingofProtectionFocusHP = EpicSettings.Settings["blessingofProtectionFocusHP"]
  BlessingofSacrificeFocusHP = EpicSettings.Settings["blessingofSacrificeFocusHP"]

--Afflicted Settings
  UseCleanseToxinsWithAfflicted = EpicSettings.Settings["useCleanseToxinsWithAfflicted"]
  UseWordofGloryWithAfflicted = EpicSettings.Settings["useWordofGloryWithAfflicted"]
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

-- APL Main
local function APL()

  FetchSettings();
  FetchUseSettings();
  FetchGeneralSettings();

  OOC = EpicSettings.Toggles["ooc"]
  AOE = EpicSettings.Toggles["aoe"]
  CDs = EpicSettings.Toggles["cds"]
  Kick = EpicSettings.Toggles["kick"]
  DispelToggle = EpicSettings.Toggles["dispel"]

  Enemies8y = Player:GetEnemiesInMeleeRange(8)
  Enemies30y = Player:GetEnemiesInRange(30)
  if (AOE) then
    EnemiesCount8y = #Enemies8y
    EnemiesCount30y = #Enemies30y
  else
    EnemiesCount8y = 1
    EnemiesCount30y = 1
  end

  ActiveMitigationNeeded = Player:ActiveMitigationNeeded()
  IsTanking = Player:IsTankingAoE(8) or Player:IsTanking(Target)

  
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

  -- Calculate fight_remains
  if Everyone.TargetIsValid() or Player:AffectingCombat() then
    -- Calculate fight_remains
    BossFightRemains = EL.BossFightRemains(nil, true)
    FightRemains = BossFightRemains
    if FightRemains == 11111 then
      FightRemains = EL.FightRemains(Enemies10y, false)
    end
  end

  if not Player:AffectingCombat() then
    -- Manually added: devotion_aura
    if S.DevotionAura:IsCastable() and (MissingAura()) then
      if Press(S.DevotionAura) then return "devotion_aura"; end
    end
  end
    
  -- Afflicted
  if HandleAfflicted then
    if UseCleanseToxinsWithAfflicted then
      ShouldReturn = Everyone.HandleAfflicted(S.CleanseToxins, M.CleanseToxinsMouseover, 40); if ShouldReturn then return ShouldReturn; end
    end
    if Player:BuffUp(S.ShiningLightFreeBuff) and UseWordofGloryWithAfflicted then
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

  --Redemption Mouseover
  if S.Redemption:IsCastable() and S.Redemption:IsReady() and not Player:AffectingCombat() and Mouseover:Exists() and Mouseover:IsDeadOrGhost() and Mouseover:IsAPlayer() and (not Player:CanAttack(Mouseover))  then
    if Press(M.RedemptionMouseover) then return "redemption mouseover" end
  end

  if Everyone.TargetIsValid() then
    -- revive
    if Target:Exists() and Target:IsAPlayer() and Target:IsDeadOrGhost() and not Player:CanAttack(Target) then
      if Player:AffectingCombat() then
        if S.Intercession:IsCastable() then
          if Press(S.Intercession, nil, true) then return "intercession"; end
        end
      else
        if S.Redemption:IsCastable() then
          if Press(S.Redemption, not Target:IsInRange(40), true) then return "redemption"; end
        end
      end
    end

    -- Precombat
    if not Player:AffectingCombat() and OOC then
      ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
    end
    
    if Player:AffectingCombat() then 
      --Intercession
      if S.Intercession:IsCastable() and Player:HolyPower() >=3 and S.Intercession:IsReady() and Player:AffectingCombat() and Mouseover:Exists() and Mouseover:IsDeadOrGhost() and Mouseover:IsAPlayer() and (not Player:CanAttack(Mouseover))  then
        if Press(M.IntercessionMouseover) then return "Intercession" end
      end

      -- auto_attack

      -- Interrupts
      if not Player:IsCasting() and not Player:IsChanneling() and Kick then
        if UseRebuke then
          ShouldReturn = Everyone.Interrupt(S.Rebuke, 5); if ShouldReturn then return ShouldReturn; end
          ShouldReturn = Everyone.Interrupt(M.RebukeMouseover, 5); if ShouldReturn then return ShouldReturn; end
        end
        if UseHammerofJustice then
          ShouldReturn = Everyone.InterruptWithStun(S.HammerofJustice, 8); if ShouldReturn then return ShouldReturn; end
          ShouldReturn = Everyone.InterruptWithStun(M.HammerofJusticeMouseover, 8); if ShouldReturn then return ShouldReturn; end
        end
      end
      -- Manually added: Defensives!
      if IsTanking then
        ShouldReturn = Defensives(); if ShouldReturn then return ShouldReturn; end
      end
      -- call_action_list,name=cooldowns
      if FightRemainsCheck < FightRemains then
        ShouldReturn = Cooldowns(); if ShouldReturn then return ShouldReturn; end
      end
      -- call_action_list,name=trinkets
      -- use_items
      if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) and Target:IsInMeleeRange(8) then
        ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
      end
      -- call_action_list,name=standard
      ShouldReturn = Standard(); if ShouldReturn then return ShouldReturn; end
      -- Manually added: Pool, if nothing else to do
      if Press(S.Pool) then return "Wait/Pool Resources"; end
    end
  end
end

local function Init()
  ER.Print("Protection Paladin by Epic. Supported by xKaneto")
  FillDispels()
end

ER.SetAPL(66, APL, Init)
