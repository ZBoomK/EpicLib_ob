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
local Bind       = ER.Bind
local Cast       = ER.Cast
local Macro      = ER.Macro
local Press      = ER.Press
-- Num/Bool Helper Functions
local num        = ER.Commons.Everyone.num
local bool       = ER.Commons.Everyone.bool
-- lua
local mathfloor  = math.floor

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
local UseCharge
local UseDemoralizingShout
local UseDevastate
local UseExecute
local UseHeroicThrow
local UseRavager
local UseRevenge
local UseShieldCharge
local UseShieldSlam
local UseShockwave
local UseSpearOfBastion
local UseThunderClap
local UseThunderousRoar
local UseWreckingThrow

local UseTrinkets
local UseRacials

--Settings WithCDs
local AvatarWithCD
local RavagerWithCD
local ShieldChargeWithCD
local SpearOfBastionWithCD
local ThunderousRoarWithCD

local TrinketsWithCD
local RacialsWithCD

--Interrupts Use
local UsePummel
local UseStormBolt
local UseIntimidatingShout

--Settings UseDefensives
local UseBitterImmunity
local UseShieldWall
local UseShieldBlock
local UseLastStand
local UseIgnorePain
local UseRallyingCry
local UseIntervene
local UseDefensiveStance
local UseHealthstone
local UseHealingPotion
local UseVictoryRush

--Settings DefensiveHP
local BitterImmunityHP
local ShieldWallHP
local ShieldBlockHP
local LastStandHP
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
local S = Spell.Warrior.Protection
local I = Item.Warrior.Protection
local M = Macro.Warrior.Protection

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
}

-- Variables
local TargetInMeleeRange

-- Enemies Variables
local Enemies8y
local EnemiesCount8

-- GUI Settings
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.Warrior.Commons,
--  Protection = ER.GUISettings.APL.Warrior.Protection
--}

local function IsShieldOnTarget()
  local totalabsorbs = UnitGetTotalAbsorbs(Target)
  if totalabsorbs > 0 then
    return true
  else
    return false
  end
end

local function IsCurrentlyTanking()
  return Player:IsTankingAoE(16) or Player:IsTanking(Target) or Target:IsDummy()
end

local function IgnorePainWillNotCap()
  if Player:BuffUp(S.IgnorePain) then
    local absorb = Player:AttackPowerDamageMod() * 3.5 * (1 + Player:VersatilityDmgPct() / 100)
    local spellTable = Player:AuraInfo(S.IgnorePain, nil, true)
    local IPAmount = spellTable.points[1]
    --return IPAmount < (0.5 * mathfloor(absorb * 1.3))
    -- Ignore Pain appears to cap at 2 times its absorb value now
    return IPAmount < absorb
  else
    return true
  end
end

local function IgnorePainValue()
  if Player:BuffUp(S.IgnorePain) then
    local IPBuffInfo = Player:BuffInfo(S.IgnorePain, nil, true)
    return IPBuffInfo.points[1]
  else
    return 0
  end
end

local function ShouldPressShieldBlock()
  -- shield_block,if=buff.shield_block.duration<=18&talent.enduring_defenses.enabled|buff.shield_block.duration<=12
  return IsCurrentlyTanking() and S.ShieldBlock:IsReady() and (Player:BuffRemains(S.ShieldBlockBuff) <= 18 and S.EnduringDefenses:IsAvailable() or Player:BuffRemains(S.ShieldBlockBuff) <= 12)
end

-- A bit of logic to decide whether to pre-cast-rage-dump on ignore pain.
local function SuggestRageDump(RageFromSpell)
  -- Get RageMax from setting (default 80)
  local RageMax = 80
  -- If the setting value is lower than 35, it's not possible to cast Ignore Pain, so just return false
  if (RageMax < 35 or Player:Rage() < 35) then return false end
  local shouldPreRageDump = false
  -- Make sure we have enough Rage to cast IP, that it's not on CD, and that we shouldn't use Shield Block
  local AbleToCastIP = (Player:Rage() >= 35 and not ShouldPressShieldBlock())
  if AbleToCastIP and (Player:Rage() + RageFromSpell >= RageMax or S.DemoralizingShout:IsReady()) then
    -- should pre-dump rage into IP if rage + RageFromSpell >= RageMax or Demo Shout is ready
      shouldPreRageDump = true
  end
  if shouldPreRageDump then
    if IsCurrentlyTanking() and IgnorePainWillNotCap() then
      if Press(S.IgnorePain) then return "ignore_pain rage capped"; end
    else
      if Press(S.Revenge, not TargetInMeleeRange) then return "revenge rage capped"; end
    end
  end
end

local function Defensive()
  -- bitter immunity @ hp
  if S.BitterImmunity:IsReady() and UseBitterImmunity and (Player:HealthPercentage() <= BitterImmunityHP)then
    if Press(S.BitterImmunity) then return "bitter_immunity defensive"; end
  end
  -- last stand @ hp
  if S.LastStand:IsCastable() and UseLastStand and (Player:HealthPercentage() <= LastStandHP or Player:ActiveMitigationNeeded()) then 
    if Press(S.LastStand) then return "last_stand defensive"; end
  end
  -- ignore pain @ hp
  if S.IgnorePain:IsReady() and UseIgnorePain and (Player:HealthPercentage() <= IgnorePainHP) and IgnorePainWillNotCap() then
    if Press(S.IgnorePain) then return "ignore_pain defensive"; end
  end
  -- rallying cry @ group hp or raid hp
  if S.RallyingCry:IsReady() and UseRallyingCry and Player:BuffDown(S.AspectsFavorBuff) and Player:BuffDown(S.RallyingCry) and ((Player:HealthPercentage() <= RallyingCryHP and Everyone.IsSoloMode()) or Everyone.AreUnitsBelowHealthPercentage(RallyingCryHP, RallyingCryGroup)) then
    if Press(S.RallyingCry) then return "rallying_cry defensive"; end
  end
  -- intervene @ hp
  if S.Intervene:IsReady() and UseIntervene and (Focus:HealthPercentage() <= InterveneHP) then
    if Press(M.InterveneFocus) then return "intervene defensive"; end
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
  -- Manually added opener
  if Target:IsInMeleeRange(12) then
    if S.ThunderClap:IsCastable() and UseThunderClap then
      if Press(S.ThunderClap) then return "thunder_clap precombat"; end
    end
  else
    if UseCharge and S.Charge:IsCastable() and not Target:IsInRange(8) then
      if Press(S.Charge, not Target:IsSpellInRange(S.Charge)) then return "charge precombat"; end
    end
  end
end

local function Aoe()
  --thunder_clap,if=dot.rend.remains<=1
  if S.ThunderClap:IsCastable() and UseThunderClap and Target:DebuffRemains(S.RendDebuff) <= 1 then
    SuggestRageDump(5)
    if Press(S.ThunderClap, not Target:IsInMeleeRange(8)) then return "thunder_clap aoe 2"; end
  end
  -- shield_slam,if=(set_bonus.tier30_2pc|set_bonus.tier30_4pc)&spell_targets.thunder_clap<=7|buff.earthen_tenacity.up
  -- Note: If set_bonus.tier30_2pc is true, then tier30_4pc would be true also, so just checking for 2pc.
  if S.ShieldSlam:IsCastable() and UseShieldSlam and (Player:HasTier(30, 2) and EnemiesCount8 <= 7 or Player:BuffUp(S.EarthenTenacityBuff)) then
    if Press(S.ShieldSlam, not TargetInMeleeRange) then return "shield_slam aoe 3"; end
  end
  --thunder_clap,if=buff.violent_outburst.up&spell_targets.thunderclap>5&buff.avatar.up&talent.unstoppable_force.enabled
  if S.ThunderClap:IsCastable() and UseThunderClap and Player:BuffUp(S.ViolentOutburstBuff) and EnemiesCount8 > 5 and Player:BuffUp(S.AvatarBuff) and S.UnstoppableForce:IsAvailable() then
    SuggestRageDump(5)
    if Press(S.ThunderClap, not Target:IsInMeleeRange(8)) then return "thunder_clap aoe 4"; end
  end
  --revenge,if=rage>=70&talent.seismic_reverberation.enabled&spell_targets.revenge>=3
  if S.Revenge:IsReady() and UseRevenge and Player:Rage() >= 70 and S.SeismicReverberation:IsAvailable() and EnemiesCount8 >= 3 then
    if Press(S.Revenge, not TargetInMeleeRange) then return "revenge aoe 6"; end
  end
  --shield_slam,if=rage<=60|buff.violent_outburst.up&spell_targets.thunderclap<=7
  if S.ShieldSlam:IsCastable() and UseShieldSlam and (Player:Rage() <= 60 or Player:BuffUp(S.ViolentOutburstBuff) and EnemiesCount8 <= 7) then
    SuggestRageDump(20)
    if Press(S.ShieldSlam, not TargetInMeleeRange) then return "shield_slam aoe 8"; end
  end
  --thunder_clap
  if S.ThunderClap:IsCastable() and UseThunderClap then
    SuggestRageDump(5)
    if Press(S.ThunderClap, not Target:IsInMeleeRange(8)) then return "thunder_clap aoe 10"; end
  end
  --revenge,if=rage>=30|rage>=40&talent.barbaric_training.enabled
  if S.Revenge:IsReady() and UseRevenge and (Player:Rage() >= 30 or Player:Rage() >= 40 and S.BarbaricTraining:IsAvailable()) then
    if Press(S.Revenge, not TargetInMeleeRange) then return "revenge aoe 12"; end
  end
end

local function Generic()
  -- shield_slam
  if S.ShieldSlam:IsCastable() and UseShieldSlam then
    SuggestRageDump(20)
    if Press(S.ShieldSlam, not TargetInMeleeRange) then return "shield_slam generic 2"; end
  end
  -- thunder_clap,if=dot.rend.remains<=1&buff.violent_outburst.down
  if S.ThunderClap:IsCastable() and UseThunderClap and Target:DebuffRemains(S.RendDebuff) <= 1 and Player:BuffDown(S.ViolentOutburstBuff) then
    SuggestRageDump(5)
    if Press(S.ThunderClap, not Target:IsInMeleeRange(8)) then return "thunder_clap generic 4"; end
  end
  -- execute,if=buff.sudden_death.up&talent.sudden_death.enabled
  if S.Execute:IsReady() and UseExecute and Player:BuffUp(S.SuddenDeathBuff) and S.SuddenDeath:IsAvailable() then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute generic 6"; end
  end
  -- execute,if=spell_targets.revenge=1&(talent.massacre.enabled|talent.juggernaut.enabled)&rage>=50
  if S.Execute:IsReady() and UseExecute and EnemiesCount8 == 1 and (S.Massacre:IsAvailable() or S.Juggernaut:IsAvailable()) and Player:Rage() >= 50 then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute generic 6"; end
  end
  -- execute,if=spell_targets.revenge=1&rage>=50
  if S.Execute:IsReady() and UseExecute and EnemiesCount8 == 1 and Player:Rage() >= 50 then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute generic 10"; end
  end
  -- thunder_clap,if=(spell_targets.thunder_clap>1|cooldown.shield_slam.remains&!buff.violent_outburst.up)
  if S.ThunderClap:IsCastable() and UseThunderClap and (EnemiesCount8 > 1 or S.ShieldSlam:CooldownDown() and not Player:BuffUp(S.ViolentOutburstBuff)) then
    SuggestRageDump(5)
    if Press(S.ThunderClap, not Target:IsInMeleeRange(8)) then return "thunder_clap generic 12"; end
  end
  --revenge,if=
  --(rage>=60&target.health.pct>20|buff.revenge.up&target.health.pct<=20&rage<=18&cooldown.shield_slam.remains|buff.revenge.up&target.health.pct>20)
  --|(rage>=60&target.health.pct>35|buff.revenge.up&target.health.pct<=35&rage<=18&cooldown.shield_slam.remains|buff.revenge.up&target.health.pct>35)
  --&talent.massacre.enabled
  if S.Revenge:IsReady() and UseRevenge 
  and ((Player:Rage() >= 60 and Target:HealthPercentage() > 20 or Player:BuffUp(S.RevengeBuff) and Target:HealthPercentage() <= 20 and Player:Rage() <= 18 and S.ShieldSlam:CooldownDown() or Player:BuffUp(S.RevengeBuff) and Target:HealthPercentage() > 20) 
  or (Player:Rage() >= 60 and Target:HealthPercentage() > 35 or Player:BuffUp(S.RevengeBuff) and Target:HealthPercentage() <= 35 and Player:Rage() <= 18 and S.ShieldSlam:CooldownDown() or Player:BuffUp(S.RevengeBuff) and Target:HealthPercentage() > 35) 
  and S.Massacre:IsAvailable()) then
    if Press(S.Revenge, not TargetInMeleeRange) then return "revenge generic 14"; end
  end
  -- execute,if=spell_targets.revenge=1
  if S.Execute:IsReady() and UseExecute and EnemiesCount8 == 1 then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute generic 16"; end
  end
  -- revenge
  if S.Revenge:IsReady() and UseRevenge then
    if Press(S.Revenge, not TargetInMeleeRange) then return "revenge generic 18"; end
  end
  -- thunder_clap,if=(spell_targets.thunder_clap>=1|cooldown.shield_slam.remains&buff.violent_outburst.up)
  if S.ThunderClap:IsCastable() and UseThunderClap and (EnemiesCount8 >= 1 or S.ShieldSlam:CooldownDown() and Player:BuffUp(S.ViolentOutburstBuff)) then
    SuggestRageDump(5)
    if Press(S.ThunderClap, not Target:IsInMeleeRange(8)) then return "thunder_clap generic 20"; end
  end
  -- devastate
  if S.Devastate:IsCastable() and UseDevastate then
    if Press(S.Devastate, not TargetInMeleeRange) then return "devastate generic 22"; end
  end
end

local function OutOfCombat()
  if not Player:AffectingCombat() then
    -- Manually added: Group buff check
    if S.BattleShout:IsCastable() and UseBattleShout and (Player:BuffDown(S.BattleShoutBuff, true) or Everyone.GroupBuffMissing(S.BattleShoutBuff)) then
      if Press(S.BattleShout) then return "battle_shout precombat"; end
    end
    if S.DefensiveStance:IsCastable() and not Player:BuffUp(S.DefensiveStance) then
      if Press(S.DefensiveStance) then return "defensive_stance precombat"; end
    end
  end

  if Everyone.TargetIsValid() and OOC then
    -- call precombat
    if not Player:AffectingCombat() then
      ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
    end
  end
end


local function Combat()
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

    -- auto_attack

    -- shield_charge,if=time=0
    if UseShieldCharge and ((ShieldChargeWithCD and CDs) or not ShieldChargeWithCD) and FightRemainsCheck < FightRemains and S.ShieldCharge:IsCastable() and (not TargetInMeleeRange) then
      if Press(S.ShieldCharge, not Target:IsSpellInRange(S.ShieldCharge)) then return "shield_charge main 34"; end
    end
    -- charge,if=time=0
    if UseCharge and S.Charge:IsCastable() and (not TargetInMeleeRange) then
      if Press(S.Charge, not Target:IsSpellInRange(S.Charge)) then return "charge main 34"; end
    end

    -- Manually added: VR/IV
    if Player:HealthPercentage() < VictoryRushHP then
      if S.VictoryRush:IsReady() and UseVictoryRush then
        if Press(S.VictoryRush, not TargetInMeleeRange) then return "victory_rush heal"; end
      end
      if S.ImpendingVictory:IsReady() and UseVictoryRush then
        if Press(S.ImpendingVictory, not TargetInMeleeRange) then return "impending_victory heal"; end
      end
    end
    -- Note: Above 2 lines handled in Precombat
    -- use_items
    if FightRemainsCheck < FightRemains then
      if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) then
        ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
      end
    end

    -- HeroicThrow, if out of range
    if UseHeroicThrow and S.HeroicThrow:IsCastable() and (not Target:IsInRange(30)) then
      if Press(S.HeroicThrow, not Target:IsInRange(30)) then return "heroic_throw main"; end
    end
    
    -- wrecking throw
    if S.WreckingThrow:IsCastable() and UseWreckingThrow and Target:AffectingCombat() and IsShieldOnTarget() then
      if Press(S.WreckingThrow, not Target:IsInRange(30)) then return "wrecking_throw main"; end
    end

    -- avatar
    if FightRemainsCheck < FightRemains and UseAvatar and ((AvatarWithCD and CDs) or not AvatarWithCD) and S.Avatar:IsCastable() then
      if Press(S.Avatar) then return "avatar main 2"; end
    end

    if FightRemainsCheck < FightRemains and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD)then
      -- blood_fury
      if S.BloodFury:IsCastable() then
        if Press(S.BloodFury) then return "blood_fury main 4"; end
      end
      -- berserking
      if S.Berserking:IsCastable() then
        if Press(S.Berserking) then return "berserking main 6"; end
      end
      -- arcane_torrent
      if S.ArcaneTorrent:IsCastable() then
        if Press(S.ArcaneTorrent) then return "arcane_torrent main 8"; end
      end
      -- lights_judgment
      if S.LightsJudgment:IsCastable() then
        if Press(S.LightsJudgment) then return "lights_judgment main 10"; end
      end
      -- fireblood
      if S.Fireblood:IsCastable() then
        if Press(S.Fireblood) then return "fireblood main 12"; end
      end
      -- ancestral_call
      if S.AncestralCall:IsCastable() then
        if Press(S.AncestralCall) then return "ancestral_call main 14"; end
      end
      -- bag_of_tricks
      if S.BagofTricks:IsCastable() then
        if Press(S.BagofTricks) then return "ancestral_call main 16"; end
      end
    end
    -- potion,if=buff.avatar.up|buff.avatar.up&target.health.pct<=20
    local ShouldReturnPot = Everyone.HandleDPSPotion(Target:BuffUp(S.AvatarBuff)); if ShouldReturnPot then return ShouldReturnPot; end
    
    -- ignore_pain,if=target.health.pct>=20&
    --(rage.deficit<=15&cooldown.shield_slam.ready
    --|rage.deficit<=40&cooldown.shield_charge.ready&talent.champions_bulwark.enabled
    --|rage.deficit<=20&cooldown.shield_charge.ready
    --|rage.deficit<=30&cooldown.demoralizing_shout.ready&talent.booming_voice.enabled
    --|rage.deficit<=20&cooldown.avatar.ready
    --|rage.deficit<=45&cooldown.demoralizing_shout.ready&talent.booming_voice.enabled&buff.last_stand.up&talent.unnerving_focus.enabled
    --|rage.deficit<=30&cooldown.avatar.ready&buff.last_stand.up&talent.unnerving_focus.enabled
    --|rage.deficit<=20
    --|rage.deficit<=40&cooldown.shield_slam.ready&buff.violent_outburst.up&talent.heavy_repercussions.enabled&talent.impenetrable_wall.enabled
    --|rage.deficit<=55&cooldown.shield_slam.ready&buff.violent_outburst.up&buff.last_stand.up&talent.unnerving_focus.enabled&talent.heavy_repercussions.enabled&talent.impenetrable_wall.enabled
    --|rage.deficit<=17&cooldown.shield_slam.ready&talent.heavy_repercussions.enabled
    --|rage.deficit<=18&cooldown.shield_slam.ready&talent.impenetrable_wall.enabled),use_off_gcd=1
    if S.IgnorePain:IsReady() and UseIgnorePain and IgnorePainWillNotCap() and (Target:HealthPercentage() >= 20 and 
      (Player:RageDeficit() <= 15 and S.ShieldSlam:CooldownUp() 
      or Player:RageDeficit() <= 40 and S.ShieldCharge:CooldownUp() and S.ChampionsBulwark:IsAvailable() 
      or Player:RageDeficit() <= 20 and S.ShieldCharge:CooldownUp() 
      or Player:RageDeficit() <= 30 and S.DemoralizingShout:CooldownUp() and S.BoomingVoice:IsAvailable() 
      or Player:RageDeficit() <= 20 and S.Avatar:CooldownUp() 
      or Player:RageDeficit() <= 45 and S.DemoralizingShout:CooldownUp() and S.BoomingVoice:IsAvailable() and Player:BuffUp(S.LastStandBuff) and S.UnnervingFocus:IsAvailable() 
      or Player:RageDeficit() <= 30 and S.Avatar:CooldownUp() and Player:BuffUp(S.LastStandBuff) and S.UnnervingFocus:IsAvailable()
      or Player:RageDeficit() <= 20
      or Player:RageDeficit() <= 40 and S.ShieldSlam:CooldownUp() and Player:BuffUp(S.ViolentOutburstBuff) and S.HeavyRepercussions:IsAvailable() and S.ImpenetrableWall:IsAvailable() 
      or Player:RageDeficit() <= 55 and S.ShieldSlam:CooldownUp() and Player:BuffUp(S.ViolentOutburstBuff) and Player:BuffUp(S.LastStandBuff) and S.UnnervingFocus:IsAvailable() and S.HeavyRepercussions:IsAvailable() and S.ImpenetrableWall:IsAvailable()
      or Player:RageDeficit() <= 17 and S.ShieldSlam:CooldownUp() and S.HeavyRepercussions:IsAvailable()
      or Player:RageDeficit() <= 18 and S.ShieldSlam:CooldownUp() and S.ImpenetrableWall:IsAvailable())) then
      if Press(S.IgnorePain) then return "ignore_pain main 20"; end
    end
    -- last_stand,if=(target.health.pct>=90&talent.unnerving_focus.enabled|target.health.pct<=20&talent.unnerving_focus.enabled)|talent.bolster.enabled
    if IsCurrentlyTanking() and UseLastStand and S.LastStand:IsCastable() and Player:BuffDown(S.ShieldWallBuff) and ((Target:HealthPercentage() >= 90 and S.UnnervingFocus:IsAvailable() or Target:HealthPercentage() <= 20 and S.UnnervingFocus:IsAvailable()) or S.Bolster:IsAvailable() or Player:HasTier(30, 2)) then
      if Press(S.LastStand) then return "last_stand defensive"; end
    end
    -- ravager
    if FightRemainsCheck < FightRemains and UseRavager and ((RavagerWithCD and CDs) or not RavagerWithCD) and RavagerSetting == "player" and S.Ravager:IsCastable() then
      SuggestRageDump(10)
      if Press(M.RavagerPlayer, not TargetInMeleeRange) then return "ravager main 24"; end
    end
    if FightRemainsCheck < FightRemains and UseRavager and ((RavagerWithCD and CDs) or not RavagerWithCD) and RavagerSetting == "cursor" and S.Ravager:IsCastable() then
      SuggestRageDump(10)
      if Press(M.RavagerCursor, not TargetInMeleeRange) then return "ravager main 24"; end
    end
    -- demoralizing_shout,if=talent.booming_voice.enabled
    if S.DemoralizingShout:IsCastable() and UseDemoralizingShout and S.BoomingVoice:IsAvailable() then
      SuggestRageDump(30)
      if Press(S.DemoralizingShout, not TargetInMeleeRange) then return "demoralizing_shout main 28"; end
    end
    -- spear_of_bastion
    if FightRemainsCheck < FightRemains and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and SpearSetting == "player" and S.SpearofBastion:IsCastable() then
      SuggestRageDump(20)
      if Press(M.SpearofBastionPlayer, not TargetInMeleeRange) then return "spear_of_bastion main 28"; end
    end
    if FightRemainsCheck < FightRemains and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and SpearSetting == "cursor" and S.SpearofBastion:IsCastable() then
      SuggestRageDump(20)
      if Press(M.SpearofBastionCursor, not TargetInMeleeRange) then return "spear_of_bastion main 28"; end
    end
    -- thunderous_roar
    if FightRemainsCheck < FightRemains and UseThunderousRoar and ((ThunderousRoarWithCD and CDs) or not ThunderousRoarWithCD) and S.ThunderousRoar:IsCastable() then
      if Press(S.ThunderousRoar, not Target:IsInMeleeRange(12)) then return "thunderous_roar main 30"; end
    end
    -- shockwave,if=talent.sonic_boom.enabled&buff.avatar.up&talent.unstoppable_force.enabled&!talent.rumbling_earth.enabled
    if S.Shockwave:IsCastable() and UseShockwave and S.SonicBoom:IsAvailable() and Player:BuffUp(S.AvatarBuff) and S.UnstoppableForce:IsAvailable() and not S.RumblingEarth:IsAvailable() then
      SuggestRageDump(10)
      if Press(S.Shockwave, not Target:IsInMeleeRange(10)) then return "shockwave main 32"; end
    end
    -- shield_charge
    if FightRemainsCheck < FightRemains and S.ShieldCharge:IsCastable() and UseShieldCharge and ((ShieldChargeWithCD and CDs) or not ShieldChargeWithCD) then
      if Press(S.ShieldCharge, not Target:IsSpellInRange(S.ShieldCharge)) then return "shield_charge main 34"; end
    end
    -- shield_block,if=buff.shield_block.duration<=18&talent.enduring_defenses.enabled|buff.shield_block.duration<=12
    if ShouldPressShieldBlock() and UseShieldBlock then
      if Press(S.ShieldBlock) then return "shield_block main 38"; end
    end
    -- run_action_list,name=aoe,if=spell_targets.thunder_clap>3
    if EnemiesCount8 > 3 then
      ShouldReturn = Aoe(); if ShouldReturn then return ShouldReturn; end
      if ER.CastAnnotated(S.Pool, false, "WAIT") then return "Pool for Aoe()"; end
    end
    -- call_action_list,name=generic
    ShouldReturn = Generic(); if ShouldReturn then return ShouldReturn; end
    -- If nothing else to do, show the Pool icon
    if ER.CastAnnotated(S.Pool, false, "WAIT") then return "Wait/Pool Resources"; end
  end
end

local function FetchUseSettings()
  --General Use
  UseBattleShout = EpicSettings.Settings["useBattleShout"]
  UseCharge = EpicSettings.Settings["useCharge"]
  UseDemoralizingShout = EpicSettings.Settings["useDemoralizingShout"]
  UseDevastate = EpicSettings.Settings["useDevastate"]
  UseExecute = EpicSettings.Settings["useExecute"]
  UseHeroicThrow = EpicSettings.Settings["useHeroicThrow"]
  UseRevenge = EpicSettings.Settings["useRevenge"]
  UseShieldSlam = EpicSettings.Settings["useShieldSlam"]
  UseShockwave = EpicSettings.Settings["useShockwave"]
  UseThunderClap = EpicSettings.Settings["useThunderClap"]
  UseWreckingThrow = EpicSettings.Settings["useWreckingThrow"]

  --CD Use
  UseAvatar = EpicSettings.Settings["useAvatar"]
  UseRavager = EpicSettings.Settings["useRavager"]
  UseShieldCharge = EpicSettings.Settings["useShieldCharge"]
  UseSpearOfBastion = EpicSettings.Settings["useSpearOfBastion"]
  UseThunderousRoar = EpicSettings.Settings["useThunderousRoar"]

  --SaveWithCD Settings
  AvatarWithCD = EpicSettings.Settings["avatarWithCD"]
  RavagerWithCD = EpicSettings.Settings["ravagerWithCD"]
  ShieldChargeWithCD = EpicSettings.Settings["shieldChargeWithCD"]
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
  UseIgnorePain = EpicSettings.Settings["useIgnorePain"] 
  UseIntervene = EpicSettings.Settings["useIntervene"] 
  UseLastStand = EpicSettings.Settings["useLastStand"] 
  UseRallyingCry = EpicSettings.Settings["useRallyingCry"] 
  UseShieldBlock = EpicSettings.Settings["useShieldBlock"] 
  UseShieldWall = EpicSettings.Settings["useShieldWall"] 
  UseVictoryRush = EpicSettings.Settings["useVictoryRush"] 

  --Defensive HP Settings
  BitterImmunityHP = EpicSettings.Settings["bitterImmunityHP"] or 0
  IgnorePainHP = EpicSettings.Settings["ignorePainHP"] or 0
  InterveneHP = EpicSettings.Settings["interveneHP"] or 0
  LastStandHP = EpicSettings.Settings["lastStandHP"] or 0
  RallyingCryGroup = EpicSettings.Settings["rallyingCryGroup"] or 0
  RallyingCryHP = EpicSettings.Settings["rallyingCryHP"] or 0
  ShieldBlockHP = EpicSettings.Settings["shieldBlockHP"] or 0
  ShieldWallHP = EpicSettings.Settings["shieldWallHP"] or 0
  VictoryRushHP = EpicSettings.Settings["victoryRushHP"] or 0
  
  --Placement Settings
  RavagerSetting = EpicSettings.Settings["ravagerSetting"] or ""
  SpearSetting = EpicSettings.Settings["spearSetting"] or ""
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
    Enemies8y = Player:GetEnemiesInMeleeRange(8) -- Multiple Abilities
    EnemiesCount8 = #Enemies8y
  else
    EnemiesCount8 = 1
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
  ER.Print("Protection Warrior by Epic. Supported by xKaneto.")
end

ER.SetAPL(73, APL, Init)
