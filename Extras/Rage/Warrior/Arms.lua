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
local UseBladestorm
local UseCharge
local UseCleave
local UseColossusSmash
local UseExecute
local UseHeroicThrow
local UseMortalStrike
local UseOverpower
local UseRend
local UseRevenge
local UseShockwave
local UseSkullsplitter
local UseSlam
local UseSweepingStrikes
local UseThunderClap
local UseThunderousRoar
local UseWarbreaker
local UseWhirlwind
local UseWreckingThrow

--Settings WithCDs
local AvatarWithCD
local BladestormWithCD
local ColossusSmashWithCD
local SpearOfBastionWithCD
local ThunderousRoarWithCD
local WarbreakerWithCD

local TrinketsWithCD
local RacialsWithCD

--Interrupts Use
local UsePummel
local UseStormBolt
local UseIntimidatingShout

--Settings UseDefensives
local UseBitterImmunity
local UseDieByTheSword
local UseIgnorePain
local UseRallyingCry
local UseIntervene
local UseDefensiveStance
local UseHealthstone
local UseHealingPotion
local UseVictoryRush

--Settings DefensiveHP
local BitterImmunityHP
local DieByTheSwordHP
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

local UseRacials
local UseTrinkets

--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999
-- Commons
local Everyone = ER.Commons.Everyone
--local Warrior = ER.Commons.wafp

-- Define S/I for spell and item arrays
local S = Spell.Warrior.Arms
local I = Item.Warrior.Arms
local M = Macro.Warrior.Arms

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
}

-- Variables
local TargetInMeleeRange
local BossFightRemains = 11111
local FightRemains = 11111

EL:RegisterForEvent(function()
  BossFightRemains = 11111
  FightRemains = 11111
end, "PLAYER_REGEN_ENABLED")

-- Enemies Variables
local Enemies8y
local EnemiesCount8y

-- GUI Settings
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.Warrior.Commons,
--  Arms = ER.GUISettings.APL.Warrior.Arms
--}

local function IsShieldOnTarget()
  local totalabsorbs = UnitGetTotalAbsorbs(Target)
  if totalabsorbs > 0 then
    return true
  else
    return false
  end
end

local function EvaluateCycleColossusSmash(TargetUnit)
  -- if=(target.health.pct<20|talent.massacre&target.health.pct<35)
  return (TargetUnit:HealthPercentage() > 20 or S.Massacre:IsAvailable() and TargetUnit:HealthPercentage() < 35)
end

local function EvaluateCycleMortalStrike(TargetUnit)
  -- if=debuff.executioners_precision.stack=2|dot.deep_wounds.remains<=gcd|talent.dreadnaught&talent.battlelord&active_enemies<=2
  return (TargetUnit:DebuffStack(S.ExecutionersPrecisionDebuff) == 2 or TargetUnit:DebuffRemains(S.DeepWoundsDebuff) <= Player:GCD() or S.Dreadnaught:IsAvailable() and S.Battlelord:IsAvailable() and EnemiesCount8y <= 2)
end

local function EvaluateCycleExecute(TargetUnit)
  --if=buff.sudden_death.react|active_enemies<=2&(target.health.pct<20|talent.massacre&target.health.pct<35)|buff.sweeping_strikes.up
  return (Player:BuffUp(S.SuddenDeathBuff) or EnemiesCount8y <= 2 and (TargetUnit:HealthPercentage() < 20 or S.Massacre:IsAvailable() and TargetUnit:HealthPercentage() < 35) or Player:BuffUp(S.SweepingStrikes) )
end

local function Defensive()
  -- bitter immunity @ hp
  if S.BitterImmunity:IsReady() and UseBitterImmunity and (Player:HealthPercentage() <= BitterImmunityHP)then
    if Press(S.BitterImmunity) then return "bitter_immunity defensive"; end
  end
  -- diebythesword @ hp
  if S.DieByTheSword:IsCastable() and UseDieByTheSword and (Player:HealthPercentage() <= DieByTheSwordHP) then
    if Press(S.DieByTheSword) then return "die_by_the_sword defensive"; end
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
  if S.DefensiveStance:IsCastable() and Player:BuffUp(S.BattleStance) and UseDefensiveStance and (Player:HealthPercentage() <= DefensiveStanceHP) then
    if Press(S.DefensiveStance) then return "defensive_stance defensive"; end
  end
  -- unstance @ hp
  if S.BattleStance:IsCastable() and Player:BuffUp(S.DefensiveStance)and UseDefensiveStance and (Player:HealthPercentage() > UnstanceHP) then
    if Press(S.BattleStance) then return "battle_stance after defensive stance defensive"; end
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

  -- Manually added: pre-pull
  if TargetInMeleeRange then
    if S.Skullsplitter:IsCastable() and UseSkullsplitter then
      if Press(S.Skullsplitter) then return "skullsplitter precombat"; end
    end
    if FightRemainsCheck < FightRemains and S.ColossusSmash:IsCastable() and UseColossusSmash and ((ColossusSmashWithCD and CDs) or not ColossusSmashWithCD) then
      if Press(S.ColossusSmash) then return "colossus_smash precombat"; end
    end
    if FightRemainsCheck < FightRemains and S.Warbreaker:IsCastable() and UseWarbreaker and ((WarbreakerWithCD and CDs) or not WarbreakerWithCD) then
      if Press(S.Warbreaker) then return "warbreaker precombat"; end
    end
    if S.Overpower:IsCastable() and UseOverpower then
      if Press(S.Overpower) then return "overpower precombat"; end
    end
  end
  if UseCharge and S.Charge:IsCastable() then
    if Press(S.Charge) then return "charge precombat"; end
  end
end

local function Hac()
  -- execute,if=buff.juggernaut.up&buff.juggernaut.remains<gcd
  if S.Execute:IsReady() and UseExecute and Player:BuffUp(S.JuggernautBuff) and Player:BuffRemains(S.JuggernautBuff) < Player:GCD() then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute hac 67"; end
  end
  -- thunder_clap,if=active_enemies>2&talent.thunder_clap&talent.blood_and_thunder&talent.rend&dot.rend.remains<=dot.rend.duration*0.3
  if S.ThunderClap:IsReady() and UseThunderClap and EnemiesCount8y > 2 and S.BloodandThunder:IsAvailable() and S.Rend:IsAvailable() and Target:DebuffRefreshable(S.RendDebuff) then
    if Press(S.ThunderClap, not TargetInMeleeRange) then return "thunder_clap hac 68"; end
  end
  -- sweeping_strikes,if=active_enemies>=2&(cooldown.bladestorm.remains>15|!talent.bladestorm)
  if S.SweepingStrikes:IsCastable() and UseSweepingStrikes and (EnemiesCount8y >= 2) and (S.Bladestorm:CooldownRemains() > 15 or not S.Bladestorm:IsAvailable()) then
    if Press(S.SweepingStrikes, not Target:IsInMeleeRange(8)) then return "sweeping_strikes hac 68"; end
  end
  -- rend,if=active_enemies=1&remains<=gcd&(target.health.pct>20|talent.massacre&target.health.pct>35)|talent.tide_of_blood&cooldown.skullsplitter.remains<=gcd&(cooldown.colossus_smash.remains<=gcd|debuff.colossus_smash.up)&dot.rend.remains<dot.rend.duration*0.85
  if S.Rend:IsReady() and UseRend and EnemiesCount8y == 1 and (Target:HealthPercentage() > 20 or S.Massacre:IsAvailable() and Target:HealthPercentage() < 35) or S.TideofBlood:IsAvailable() and S.Skullsplitter:CooldownRemains() <= Player:GCD() and (S.ColossusSmash:CooldownRemains() < Player:GCD() or Target:DebuffUp(S.ColossusSmashDebuff)) and Target:DebuffRemains(S.RendDebuff) < 21 * 0.85 then
    if Press(S.Rend, not TargetInMeleeRange) then return "rend hac 70"; end
  end
  -- avatar,if=raid_event.adds.in>15|talent.blademasters_torment&active_enemies>1|target.time_to_die<20
  if FightRemainsCheck < FightRemains and UseAvatar and ((AvatarWithCD and CDs) or not AvatarWithCD) and S.Avatar:IsCastable() and ((S.BlademastersTorment:IsAvailable() and EnemiesCount8y > 1) or FightRemains < 20) then
    if Press(S.Avatar, not TargetInMeleeRange) then return "avatar hac 71"; end
  end
  -- warbreaker,if=raid_event.adds.in>22|active_enemies>1
  if FightRemainsCheck < FightRemains and S.Warbreaker:IsCastable() and UseWarbreaker and ((WarbreakerWithCD and CDs) or not WarbreakerWithCD) and EnemiesCount8y > 1 then
    if Press(S.Warbreaker, not TargetInMeleeRange) then return "warbreaker hac 72"; end
  end
  -- colossus_smash,cycle_targets=1,if=(target.health.pct<20|talent.massacre&target.health.pct<35)
  if FightRemainsCheck < FightRemains and UseColossusSmash and ((ColossusSmashWithCD and CDs) or not ColossusSmashWithCD) and S.ColossusSmash:IsCastable() then
    if Everyone.CastCycle(S.ColossusSmash, Enemies8y, EvaluateCycleColossusSmash, not TargetInMeleeRange) then return "colossus_smash hac 73"; end
  end
  -- colossus_smash
  if FightRemainsCheck < FightRemains and UseColossusSmash and ((ColossusSmashWithCD and CDs) or not ColossusSmashWithCD) and S.ColossusSmash:IsCastable() then
    if Press(S.ColossusSmash, not TargetInMeleeRange) then return "colossus_smash hac 74"; end
  end
  -- thunderous_roar,if=(buff.test_of_might.up|!talent.test_of_might&debuff.colossus_smash.up)&raid_event.adds.in>15|active_enemies>1&dot.deep_wounds.remains
  if FightRemainsCheck < FightRemains and UseThunderousRoar and ((ThunderousRoarWithCD and CDs) or not ThunderousRoarWithCD) and S.ThunderousRoar:IsCastable() and ((Player:BuffUp(S.TestofMightBuff) or (not S.TestofMight:IsAvailable()) and Target:DebuffUp(S.ColossusSmashDebuff)) or EnemiesCount8y > 1 and Target:DebuffRemains(S.DeepWoundsDebuff) > 0) then
    if Press(S.ThunderousRoar, not Target:IsInMeleeRange(12)) then return "thunderous_roar hac 75"; end
  end
  -- spear_of_bastion,if=(buff.test_of_might.up|!talent.test_of_might&debuff.colossus_smash.up)&raid_event.adds.in>15
  if FightRemainsCheck < FightRemains and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and SpearSetting == "player" and S.SpearofBastion:IsCastable() and (Player:BuffUp(S.TestofMightBuff) or not S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff)) then
    if Press(M.SpearofBastionPlayer, not Target:IsSpellInRange(S.SpearofBastion)) then return "spear_of_bastion hac 76"; end
  end
  if FightRemainsCheck < FightRemains and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and SpearSetting == "cursor" and S.SpearofBastion:IsCastable() and (Player:BuffUp(S.TestofMightBuff) or not S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff)) then
    if Press(M.SpearofBastionCursor, not Target:IsSpellInRange(S.SpearofBastion)) then return "spear_of_bastion hac 76"; end
  end
  -- bladestorm,if=talent.unhinged&(buff.test_of_might.up|!talent.test_of_might&debuff.colossus_smash.up)
  if FightRemainsCheck < FightRemains and UseBladestorm and ((BladestormWithCD and CDs) or not BladestormWithCD) and S.Bladestorm:IsCastable() and S.Unhinged:IsAvailable() and (Player:BuffUp(S.TestofMightBuff) or not S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff)) then
    if Press(S.Bladestorm, not TargetInMeleeRange) then return "bladestorm hac 77"; end
  end
  -- bladestorm,if=active_enemies>1&(buff.test_of_might.up|!talent.test_of_might&debuff.colossus_smash.up)&raid_event.adds.in>30|active_enemies>1&dot.deep_wounds.remains
  if FightRemainsCheck < FightRemains and UseBladestorm and ((BladestormWithCD and CDs) or not BladestormWithCD) and S.Bladestorm:IsCastable() and (EnemiesCount8y > 1 and (Player:BuffUp(S.TestofMightBuff) or not S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff)) or EnemiesCount8y > 1 and Target:DebuffRemains(S.DeepWoundsDebuff) > 0) then
    if Press(S.Bladestorm, not TargetInMeleeRange) then return "bladestorm hac 78"; end
  end
  -- cleave,if=active_enemies>2|!talent.battlelord&buff.merciless_bonegrinder.up&cooldown.mortal_strike.remains>gcd
  if S.Cleave:IsReady() and UseCleave and (EnemiesCount8y > 2 or not S.Battlelord:IsAvailable() and Player:BuffUp(S.MercilessBonegrinderBuff) and S.MortalStrike:CooldownRemains() > Player:GCD()) then
    if Press(S.Cleave, not TargetInMeleeRange) then return "cleave hac 79"; end
  end
  -- whirlwind,if=active_enemies>2|talent.storm_of_swords&(buff.merciless_bonegrinder.up|buff.hurricane.up)
  if S.Whirlwind:IsReady() and UseWhirlwind and (EnemiesCount8y > 2 or S.StormofSwords:IsAvailable() and (Player:BuffUp(S.MercilessBonegrinderBuff) or Player:BuffUp(S.HurricaneBuff))) then
    if Press(S.Whirlwind, not Target:IsInMeleeRange(8)) then return "whirlwind hac 80"; end
  end
  -- skullsplitter,if=rage<40|talent.tide_of_blood&dot.rend.remains&(buff.sweeping_strikes.up&active_enemies>=2|debuff.colossus_smash.up|buff.test_of_might.up)
  if S.Skullsplitter:IsCastable() and UseSkullsplitter and (Player:Rage() < 40 or S.TideofBlood:IsAvailable() and Target:DebuffRemains(S.RendDebuff) > 0 and (Player:BuffUp(S.SweepingStrikes) and EnemiesCount8y > 2 or Target:DebuffUp(S.ColossusSmashDebuff) or Player:BuffUp(S.TestofMightBuff))) then
    if Press(S.Skullsplitter, not Target:IsInMeleeRange(8)) then return "sweeping_strikes execute 81"; end
  end
  -- mortal_strike,if=buff.sweeping_strikes.up&buff.crushing_advance.stack=3,if=set_bonus.tier30_4pc
  -- Note: crushing_advance is the tier30_4pc bonus, so don't need to check for tier.
  if S.MortalStrike:IsReady() and UseMortalStrike and (Player:BuffUp(S.SweepingStrikes) and Player:BuffStack(S.CrushingAdvanceBuff) == 3) then
    if Press(S.MortalStrike, not TargetInMeleeRange) then return "mortal_strike hac 81.5"; end
  end
  -- overpower,if=buff.sweeping_strikes.up&talent.dreadnaught
  if S.Overpower:IsCastable() and UseOverpower and Player:BuffUp(S.SweepingStrikes) and S.Dreadnaught:IsAvailable() then
    if Press(S.Overpower, not TargetInMeleeRange) then return "overpower hac 82"; end
  end
  -- mortal_strike,cycle_targets=1,if=debuff.executioners_precision.stack=2|dot.deep_wounds.remains<=gcd|talent.dreadnaught&talent.battlelord&active_enemies<=2
  if S.MortalStrike:IsReady() and UseMortalStrike then
    if Everyone.CastCycle(S.MortalStrike, Enemies8y, EvaluateCycleMortalStrike, not TargetInMeleeRange) then return "mortal_strike hac 83"; end
  end
  -- execute,cycle_targets=1,if=buff.sudden_death.react|active_enemies<=2&(target.health.pct<20|talent.massacre&target.health.pct<35)|buff.sweeping_strikes.up
  if S.Execute:IsReady() and UseExecute and (Player:BuffUp(S.SuddenDeathBuff) or EnemiesCount8y <= 2 and (Target:HealthPercentage() < 20 or S.Massacre:IsAvailable() and Target:HealthPercentage() < 35) or Player:BuffUp(S.SweepingStrikes) ) then
    if Everyone.CastCycle(S.Execute, Enemies8y, EvaluateCycleExecute, not TargetInMeleeRange) then return "execute hac 84"; end
  end
  -- thunderous_roar,if=raid_event.adds.in>15
  if FightRemainsCheck < FightRemains and UseThunderousRoar and ((ThunderousRoarWithCD and CDs) or not ThunderousRoarWithCD) and S.ThunderousRoar:IsCastable() then
    if Press(S.ThunderousRoar, not Target:IsInMeleeRange(12)) then return "thunderous_roar hac 85"; end
  end
  -- shockwave,if=active_enemies>2&talent.sonic_boom
  if S.Shockwave:IsCastable() and UseShockwave and EnemiesCount8y > 2 and (S.SonicBoom:IsAvailable()) then
    if Press(S.Shockwave, not Target:IsInMeleeRange(10)) then return "shockwave hac 86"; end
  end
  -- overpower,if=active_enemies=1&(charges=2&!talent.battlelord&(debuff.colossus_smash.down|rage.pct<25)|talent.battlelord)
  if S.Overpower:IsCastable() and UseOverpower and EnemiesCount8y == 1 and (S.Overpower:Charges() == 2 and not S.Battlelord:IsAvailable() and (Target:Debuffdown(S.ColossusSmashDebuff) or Player:RagePercentage() < 25) or S.Battlelord:IsAvailable()) then
    if Press(S.Overpower, not TargetInMeleeRange) then return "overpower hac 87"; end
  end
  -- slam,if=active_enemies=1&!talent.battlelord&rage.pct>70
  if S.Slam:IsReady() and UseSlam and EnemiesCount8y == 1 and not S.Battlelord:IsAvailable() and Player:RagePercentage() > 70 then
    if Press(S.Slam, not TargetInMeleeRange) then return "slam hac 88"; end
  end
  -- overpower,if=charges=2&(!talent.test_of_might|talent.test_of_might&debuff.colossus_smash.down|talent.battlelord)|rage<70
  if S.Overpower:IsCastable() and UseOverpower and (S.Overpower:Charges() == 2 and (not S.TestofMight:IsAvailable() or S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff) or S.Battlelord:IsAvailable()) or Player:Rage() < 70) then
    if Press(S.Overpower, not TargetInMeleeRange) then return "overpower hac 89"; end
  end
  -- thunder_clap,if=active_enemies>2
  if S.ThunderClap:IsReady() and UseThunderClap and EnemiesCount8y > 2 then
    if Press(S.ThunderClap, not TargetInMeleeRange) then return "thunder_clap hac 90"; end
  end
  -- mortal_strike
  if S.MortalStrike:IsReady() and UseMortalStrike then
    if Press(S.MortalStrike, not TargetInMeleeRange) then return "mortal_strike hac 91"; end
  end
  -- rend,if=active_enemies=1&dot.rend.remains<duration*0.3
  if S.Rend:IsReady() and UseRend and EnemiesCount8y == 1 and Target:DebuffRefreshable(S.RendDebuff) then
    if Press(S.Rend, not TargetInMeleeRange) then return "rend hac 92"; end
  end
  -- whirlwind,if=talent.storm_of_swords|talent.fervor_of_battle&active_enemies>1
  if S.Whirlwind:IsReady() and UseWhirlwind and (S.StormofSwords:IsAvailable() or (S.FervorofBattle:IsAvailable() and EnemiesCount8y > 1)) then
    if Press(S.Whirlwind, not Target:IsInMeleeRange(8)) then return "whirlwind hac 93"; end
  end
  -- cleave,if=!talent.crushing_force
  if S.Cleave:IsReady() and UseCleave and not S.CrushingForce:IsAvailable() then
    if Press(S.Cleave, not TargetInMeleeRange) then return "cleave hac 94"; end
  end
  -- ignore_pain,if=talent.battlelord&talent.anger_management&rage>30&(target.health.pct>20|talent.massacre&target.health.pct>35)
  if S.IgnorePain:IsReady() and UseIgnorePain and (S.Battlelord:IsAvailable() and S.AngerManagement:IsAvailable() and Player:Rage() > 30 and (Target:HealthPercentage() < 20 or S.Massacre:IsAvailable() and Target:HealthPercentage() < 35)) then
    if Press(S.IgnorePain, not TargetInMeleeRange) then return "ignore_pain hac 95"; end
  end
  -- slam,if=talent.crushing_force&rage>30&(talent.fervor_of_battle&active_enemies=1|!talent.fervor_of_battle)
  if S.Slam:IsReady() and UseSlam and S.CrushingForce:IsAvailable() and Player:Rage() > 30 and (S.FervorofBattle:IsAvailable() and EnemiesCount8y == 1 or not S.FervorofBattle:IsAvailable()) then
    if Press(S.Slam, not TargetInMeleeRange) then return "slam hac 96"; end
  end
  -- shockwave,if=talent.sonic_boom
  if S.Shockwave:IsCastable() and UseShockwave and (S.SonicBoom:IsAvailable()) then
    if Press(S.Shockwave, not Target:IsInMeleeRange(10)) then return "shockwave hac 97"; end
  end
  -- bladestorm,if=raid_event.adds.in>30
  if CDs and FightRemainsCheck < FightRemains and UseBladestorm and ((BladestormWithCD and CDs) or not BladestormWithCD) and S.Bladestorm:IsCastable() then
    if Press(S.Bladestorm, not TargetInMeleeRange) then return "bladestorm hac 98"; end
  end
end

local function Execute()
  -- sweeping_strikes,if=spell_targets.whirlwind>1
  if FightRemainsCheck < FightRemains and UseSweepingStrikes and S.SweepingStrikes:IsCastable() and (EnemiesCount8y > 1) then
    if Press(S.SweepingStrikes, not Target:IsInMeleeRange(8)) then return "sweeping_strikes execute 51"; end
  end
  -- rend,if=remains<=gcd&(!talent.warbreaker&cooldown.colossus_smash.remains<4|talent.warbreaker&cooldown.warbreaker.remains<4)&target.time_to_die>12
  if S.Rend:IsReady() and UseRend and (Target:DebuffRemains(S.RendDebuff) <= Player:GCD() and ((not S.Warbreaker:IsAvailable()) and S.ColossusSmash:CooldownRemains() < 4 or S.Warbreaker:IsAvailable() and S.Warbreaker:CooldownRemains() < 4) and Target:TimeToDie() > 12) then
    if Press(S.Rend, not TargetInMeleeRange) then return "rend execute 52"; end
  end
  -- avatar,if=cooldown.colossus_smash.ready|debuff.colossus_smash.up|target.time_to_die<20
  if FightRemainsCheck < FightRemains and UseAvatar and ((AvatarWithCD and CDs) or not AvatarWithCD) and S.Avatar:IsCastable() and (S.ColossusSmash:CooldownUp() or Target:DebuffUp(S.ColossusSmashDebuff) or FightRemains < 20) then
    if Press(S.Avatar, not TargetInMeleeRange) then return "avatar execute 53"; end
  end
  -- warbreaker
  if FightRemainsCheck < FightRemains and UseWarbreaker and ((WarbreakerWithCD and CDs) or not WarbreakerWithCD) and S.Warbreaker:IsCastable() then
    if Press(S.Warbreaker, not TargetInMeleeRange) then return "warbreaker execute 54"; end
  end
  -- colossus_smash
  if FightRemainsCheck < FightRemains and UseColossusSmash and ((ColossusSmashWithCD and CDs) or not ColossusSmashWithCD) and S.ColossusSmash:IsCastable() then
    if Press(S.ColossusSmash, not TargetInMeleeRange) then return "colossus_smash execute 55"; end
  end
  -- thunderous_roar,if=buff.test_of_might.up|!talent.test_of_might&debuff.colossus_smash.up
  if FightRemainsCheck < FightRemains and UseThunderousRoar and ((ThunderousRoarWithCD and CDs) or not ThunderousRoarWithCD) and S.ThunderousRoar:IsCastable() and (Player:BuffUp(S.TestofMightBuff) or (not S.TestofMight:IsAvailable()) and Target:DebuffUp(S.ColossusSmashDebuff)) then
    if Press(S.ThunderousRoar, not Target:IsInMeleeRange(12)) then return "thunderous_roar execute 56"; end
  end
  -- spear_of_bastion,if=debuff.colossus_smash.up|buff.test_of_might.up
  if FightRemainsCheck < FightRemains and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and SpearSetting == "player" and S.SpearofBastion:IsCastable() and (Target:DebuffUp(S.ColossusSmashDebuff) or Player:BuffUp(S.TestofMightBuff) ) then
    if Press(M.SpearofBastionPlayer, not Target:IsSpellInRange(S.SpearofBastion)) then return "spear_of_bastion execute 57"; end
  end
  if FightRemainsCheck < FightRemains and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and SpearSetting == "cursor" and S.SpearofBastion:IsCastable() and (Target:DebuffUp(S.ColossusSmashDebuff) or Player:BuffUp(S.TestofMightBuff) ) then
    if Press(M.SpearofBastionCursor, not Target:IsSpellInRange(S.SpearofBastion)) then return "spear_of_bastion execute 57"; end
  end
  -- skullsplitter,if=rage<40
  if S.Skullsplitter:IsCastable() and UseSkullsplitter and Player:Rage() < 40 then
    if Press(S.Skullsplitter, not Target:IsInMeleeRange(8)) then return "skullsplitter execute 58"; end
  end
  -- cleave,if=spell_targets.whirlwind>2&dot.deep_wounds.remains<gcd
  if S.Cleave:IsReady() and UseCleave and (EnemiesCount8y > 2 and Target:DebuffRemains(S.DeepWoundsDebuff) < Player:GCD()) then
    if Press(S.Cleave, not TargetInMeleeRange) then return "cleave execute 59"; end
  end
  -- overpower,if=rage<40&buff.martial_prowess.stack<2
  if S.Overpower:IsCastable() and UseOverpower and Player:Rage() < 40 and Player:BuffStack(S.MartialProwessBuff) < 2 then
    if Press(S.Overpower, not TargetInMeleeRange) then return "overpower execute 60"; end
  end
  -- mortal_strike,if=debuff.executioners_precision.stack=2|dot.deep_wounds.remains<=gcd
  if S.MortalStrike:IsReady() and UseMortalStrike and (Target:DebuffStack(S.ExecutionersPrecisionDebuff) == 2 or Target:DebuffRemains(S.DeepWoundsDebuff) <= Player:GCD()) then
    if Press(S.MortalStrike, not TargetInMeleeRange) then return "mortal_strike execute 61"; end
  end
  -- execute
  if S.Execute:IsReady() and UseExecute then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute execute 62"; end
  end
  -- shockwave,if=talent.sonic_boom
  if S.Shockwave:IsCastable() and UseShockwave and (S.SonicBoom:IsAvailable()) then
    if Press(S.Shockwave, not Target:IsInMeleeRange(10)) then return "shockwave execute 63"; end
  end
  -- overpower
  if S.Overpower:IsCastable() and UseOverpower then
    if Press(S.Overpower, not TargetInMeleeRange) then return "overpower execute 64"; end
  end
  -- bladestorm
  if FightRemainsCheck < FightRemains and UseBladestorm and ((BladestormWithCD and CDs) or not BladestormWithCD) and S.Bladestorm:IsCastable() then
    if Press(S.Bladestorm, not TargetInMeleeRange) then return "bladestorm execute 65"; end
  end
end

local function SingleTarget()
  -- sweeping_strikes,if=spell_targets.whirlwind>1
  if FightRemainsCheck < FightRemains and UseSweepingStrikes and S.SweepingStrikes:IsCastable() and (EnemiesCount8y > 1) then
    if Press(S.SweepingStrikes, not Target:IsInMeleeRange(8)) then return "sweeping_strikes single_target 98"; end
  end
  -- mortal_strike
  if S.MortalStrike:IsReady() and UseMortalStrike then
    if Press(S.MortalStrike, not TargetInMeleeRange) then return "mortal_strike single_target 99"; end
  end
  -- rend,if=remains<=gcd|talent.tide_of_blood&cooldown.skullsplitter.remains<=gcd&(cooldown.colossus_smash.remains<=gcd|debuff.colossus_smash.up)&dot.rend.remains<dot.rend.duration*0.85
  if S.Rend:IsReady() and UseRend and (Target:DebuffRemains(S.RendDebuff) <= Player:GCD() or S.TideofBlood:IsAvailable() and S.Skullsplitter:CooldownRemains() <= Player:GCD() and (S.ColossusSmash:CooldownRemains() <= Player:GCD() or Target:DebuffUp(S.ColossusSmashDebuff)) and Target:DebuffRemains(S.RendDebuff) < S.RendDebuff:BaseDuration() * 0.85) then
    if Press(S.Rend, not TargetInMeleeRange) then return "rend single_target 100"; end
  end
  -- avatar,if=talent.warlords_torment&rage.pct<33&(cooldown.colossus_smash.ready|debuff.colossus_smash.up|buff.test_of_might.up)|!talent.warlords_torment&(cooldown.colossus_smash.ready|debuff.colossus_smash.up)
  if FightRemainsCheck < FightRemains and UseAvatar and ((AvatarWithCD and CDs) or not AvatarWithCD) and S.Avatar:IsCastable() and ((S.WarlordsTorment:IsAvailable() and Player:RagePercentage() < 33 and (S.ColossusSmash:CooldownUp() or Target:DebuffUp(S.ColossusSmashDebuff) or Player:BuffUp(S.TestofMightBuff))) or (not S.WarlordsTorment:IsAvailable() and (S.ColossusSmash:CooldownUp() or Target:DebuffUp(S.ColossusSmashDebuff)))) then
    if Press(S.Avatar, not TargetInMeleeRange) then return "avatar single_target 101"; end
  end
  -- spear_of_bastion,if=cooldown.colossus_smash.remains<=gcd|cooldown.warbreaker.remains<=gcd
  if FightRemainsCheck < FightRemains and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and SpearSetting == "player" and S.SpearofBastion:IsCastable() and (S.ColossusSmash:CooldownRemains() <= Player:GCD() or S.Warbreaker:CooldownRemains() <= Player:GCD() ) then
    if Press(M.SpearofBastionPlayer, not Target:IsSpellInRange(S.SpearofBastion)) then return "spear_of_bastion single_target 102"; end
  end
  if FightRemainsCheck < FightRemains and UseSpearOfBastion and ((SpearOfBastionWithCD and CDs) or not SpearOfBastionWithCD) and SpearSetting == "cursor" and S.SpearofBastion:IsCastable() and (S.ColossusSmash:CooldownRemains() <= Player:GCD() or S.Warbreaker:CooldownRemains() <= Player:GCD() ) then
    if Press(M.SpearofBastionCursor, not Target:IsSpellInRange(S.SpearofBastion)) then return "spear_of_bastion single_target 102"; end
  end
  -- warbreaker
  if FightRemainsCheck < FightRemains and UseWarbreaker and ((WarbreakerWithCD and CDs) or not WarbreakerWithCD) and S.Warbreaker:IsCastable() then
    if Press(S.Warbreaker, not Target:IsInRange(8)) then return "warbreaker single_target 103"; end
  end
  -- colossus_smash
  if FightRemainsCheck < FightRemains and UseColossusSmash and ((ColossusSmashWithCD and CDs) or not ColossusSmashWithCD) and S.ColossusSmash:IsCastable() then
    if Press(S.ColossusSmash, not TargetInMeleeRange) then return "colossus_smash single_target 104"; end
  end
  -- thunderous_roar,if=buff.test_of_might.up|talent.test_of_might&debuff.colossus_smash.up&rage.pct<33|!talent.test_of_might&debuff.colossus_smash.up
  if FightRemainsCheck < FightRemains and UseThunderousRoar and ((ThunderousRoarWithCD and CDs) or not ThunderousRoarWithCD) and S.ThunderousRoar:IsCastable() and (Player:BuffUp(S.TestofMightBuff) or (S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff) and Player:RagePercentage() < 33) or (not S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff))) then
    if Press(S.ThunderousRoar, not Target:IsInMeleeRange(12)) then return "thunderous_roar single_target 105"; end
  end
  -- bladestorm,if=talent.hurricane&(buff.test_of_might.up|!talent.test_of_might&debuff.colossus_smash.up)|talent.unhinged&(buff.test_of_might.up|!talent.test_of_might&debuff.colossus_smash.up)
  if FightRemainsCheck < FightRemains and UseBladestorm and ((BladestormWithCD and CDs) or not BladestormWithCD) and S.Bladestorm:IsCastable() and (S.Hurricane:IsAvailable() and (Player:BuffUp(S.TestofMightBuff) or (not S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff))) or S.Unhinged:IsAvailable() and (Player:BuffUp(S.TestofMightBuff) or (not S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff)))) then
    if Press(S.Bladestorm, not TargetInMeleeRange) then return "bladestorm single_target 106"; end
  end
  -- skullsplitter,if=talent.tide_of_blood&dot.rend.remains&(debuff.colossus_smash.up|cooldown.colossus_smash.remains>gcd*4&buff.test_of_might.up|!talent.test_of_might&cooldown.colossus_smash.remains>gcd*4)|rage<30
  if S.Skullsplitter:IsCastable() and UseSkullsplitter and (S.TideofBlood:IsAvailable() and Target:DebuffUp(S.RendDebuff) and (Target:DebuffUp(S.ColossusSmashDebuff) or (S.ColossusSmash:CooldownRemains() > Player:GCD() * 4 and Player:BuffUp(S.TestofMightBuff)) or (not S.TestofMight:IsAvailable() and S.ColossusSmash:CooldownRemains() > Player:GCD() * 4)) or Player:Rage() < 30) then
    if Press(S.Skullsplitter, not TargetInMeleeRange) then return "skullsplitter single_target 107"; end
  end
  -- execute,if=buff.sudden_death.react
  if S.Execute:IsReady() and UseExecute and (Player:BuffUp(S.SuddenDeathBuff)) then
    if Press(S.Execute, not TargetInMeleeRange) then return "execute single_target 108"; end
  end
  -- shockwave,if=talent.sonic_boom.enabled
  if S.Shockwave:IsCastable() and UseShockwave and (S.SonicBoom:IsAvailable()) then
    if Press(S.Shockwave, not Target:IsInMeleeRange(10)) then return "shockwave single_target 109"; end
  end
  -- ignore_pain,if=talent.anger_management|talent.test_of_might&debuff.colossus_smash.up
  if S.IgnorePain:IsReady() and UseIgnorePain and (S.AngerManagement:IsAvailable() or S.TestofMight:IsAvailable() and Target:DebuffUp(S.ColossusSmashDebuff)) then
    if Press(S.IgnorePain, not TargetInMeleeRange) then return "ignore_pain single_target 110"; end
  end
  -- whirlwind,if=talent.storm_of_swords&talent.battlelord&rage.pct>80&debuff.colossus_smash.up
  if S.Whirlwind:IsReady() and UseWhirlwind and (S.StormofSwords:IsAvailable() and S.Battlelord:IsAvailable() and Player:RagePercentage() > 80 and Target:DebuffUp(S.ColossusSmashDebuff)) then
    if Press(S.Whirlwind, not Target:IsInMeleeRange(8)) then return "whirlwind single_target 113"; end
  end
  -- overpower,if=charges=2&!talent.battlelord&(debuff.colossus_smash.down|rage.pct<25)|talent.battlelord
  if S.Overpower:IsCastable() and UseOverpower and (S.Overpower:Charges() == 2 and not S.Battlelord:IsAvailable() and (Target:DebuffUp(S.ColossusSmashDebuff) or Player:RagePercentage() < 25) or S.Battlelord:IsAvailable()) then
    if Press(S.Overpower, not TargetInMeleeRange) then return "overpower single_target 114"; end
  end
  -- whirlwind,if=talent.storm_of_swords|talent.fervor_of_battle&active_enemies>1
  if S.Whirlwind:IsReady() and UseWhirlwind and (S.StormofSwords:IsAvailable() or (S.FervorofBattle:IsAvailable() and EnemiesCount8y > 1)) then
    if Press(S.Whirlwind, not Target:IsInMeleeRange(8)) then return "whirlwind single_target 113"; end
  end
  -- thunder_clap,if=talent.battlelord&talent.blood_and_thunder
  if S.ThunderClap:IsReady() and UseThunderClap and S.Battlelord:IsAvailable() and S.BloodandThunder:IsAvailable() then
    if Press(S.ThunderClap, not TargetInMeleeRange) then return "thunder_clap single_target 90"; end
  end
  -- overpower,if=debuff.colossus_smash.down&rage.pct<50&!talent.battlelord|rage.pct<25
  if S.Overpower:IsCastable() and UseOverpower and (Target:DebuffDown(S.ColossusSmashDebuff) and Player:RagePercentage() < 50 and not S.Battlelord:IsAvailable() or Player:RagePercentage() < 25) then
    if Press(S.Overpower, not TargetInMeleeRange) then return "overpower single_target 114"; end
  end
  -- whirlwind,if=buff.merciless_bonegrinder.up
  if S.Whirlwind:IsReady() and UseWhirlwind and Player:BuffUp(S.MercilessBonegrinderBuff) then
    if Press(S.Whirlwind, not Target:IsInRange(8)) then return "whirlwind single_target 115"; end
  end
  -- cleave,if=set_bonus.tier29_2pc&!talent.crushing_force
  if S.Cleave:IsReady() and UseCleave and Player:HasTier(29, 2) and not S.CrushingForce:IsAvailable() then
    if Press(S.Cleave, not TargetInMeleeRange) then return "cleave single_target 116"; end
  end
  -- slam,if=rage>30&(!talent.fervor_of_battle|talent.fervor_of_battle&active_enemies=1)
  if S.Slam:IsReady() and UseSlam and Player:Rage() > 30 and (not S.FervorofBattle:IsAvailable() or S.FervorofBattle:IsAvailable() and EnemiesCount8y == 1) then
    if Press(S.Slam, not TargetInMeleeRange) then return "slam single_target 117"; end
  end
  -- bladestorm
  if FightRemainsCheck < FightRemains and UseBladestorm and ((BladestormWithCD and CDs) or not BladestormWithCD) and S.Bladestorm:IsCastable() then
    if Press(S.Bladestorm, not TargetInMeleeRange) then return "bladestorm single_target 106"; end
  end
  -- arcane_torrent
  if FightRemainsCheck < FightRemains and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) and S.ArcaneTorrent:IsCastable() then
    if Press(S.ArcaneTorrent, not Target:IsInRange(8)) then return "arcane_torrent single_target 46"; end
  end
  -- cleave
  if S.Cleave:IsReady() and UseCleave then
    if Press(S.Cleave, not TargetInMeleeRange) then return "cleave single_target 116"; end
  end
  -- rend,if=remains<duration*0.3
  if S.Rend:IsReady() and UseRend and Target:DebuffRefreshable(S.RendDebuff) then
    if Press(S.Rend, not TargetInMeleeRange) then return "rend single_target 100"; end
  end
end

local function OutOfCombat()
  if not Player:AffectingCombat() then
    -- berserker_stance,toggle=on
    if S.BattleStance:IsCastable() and Player:BuffDown(S.BattleStance, true) then
      if Press(S.BattleStance) then return "battle_stance"; end
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

    -- charge
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

    -- auto_attack
    -- potion,if=gcd.remains=0&debuff.colossus_smash.remains>8|target.time_to_die<25
    local ShouldReturnPot = Everyone.HandleDPSPotion(Target:DebuffUp(S.ColossusSmashDebuff)); if ShouldReturnPot then return ShouldReturnPot; end

    if TargetInMeleeRange and UseRacials and ((RacialsWithCD and CDs) or not RacialsWithCD) and FightRemainsCheck < FightRemains then
      -- blood_fury,if=debuff.colossus_smash.up
      if S.BloodFury:IsCastable() and Target:DebuffUp(S.ColossusSmashDebuff) then
        if Press(S.BloodFury) then return "blood_fury main 39"; end
      end
      -- berserking,if=debuff.colossus_smash.remains>6
      if S.Berserking:IsCastable() and Target:DebuffRemains(S.ColossusSmashDebuff) > 6 then
        if Press(S.Berserking) then return "berserking main 40"; end
      end
      -- arcane_torrent,if=cooldown.mortal_strike.remains>1.5&rage<50
      if S.ArcaneTorrent:IsCastable() and S.MortalStrike:CooldownRemains() > 1.5 and Player:Rage() < 50 then
        if Press(S.ArcaneTorrent, not Target:IsInRange(8)) then return "arcane_torrent main 41"; end
      end
      -- lights_judgment,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains
      if S.LightsJudgment:IsCastable() and Target:DebuffDown(S.ColossusSmashDebuff) and not S.MortalStrike:CooldownUp() then
        if Press(S.LightsJudgment, not Target:IsSpellInRange(S.LightsJudgment)) then return "lights_judgment main 42"; end
      end
      -- fireblood,if=debuff.colossus_smash.up
      if S.Fireblood:IsCastable() and (Target:DebuffUp(S.ColossusSmashDebuff)) then
        if Press(S.Fireblood) then return "fireblood main 43"; end
      end
      -- ancestral_call,if=debuff.colossus_smash.up
      if S.AncestralCall:IsCastable() and (Target:DebuffUp(S.ColossusSmashDebuff)) then
        if Press(S.AncestralCall) then return "ancestral_call main 44"; end
      end
      -- bag_of_tricks,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains
      if S.BagofTricks:IsCastable() and (Target:DebuffDown(S.ColossusSmashDebuff) and not S.MortalStrike:CooldownUp()) then
        if Press(S.BagofTricks, not Target:IsSpellInRange(S.BagofTricks)) then return "bag_of_tricks main 10"; end
      end
    end

    if FightRemainsCheck < FightRemains then
      if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) then
        ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
      end
    end

    -- HeroicThrow, if out of range
    if UseHeroicThrow and S.HeroicThrow:IsCastable() and (not Target:IsInRange(30)) then
      if Press(S.HeroicThrow, not Target:IsInRange(30)) then return "heroic_throw main"; end
    end

    -- wrecking_throw
    if S.WreckingThrow:IsCastable() and UseWreckingThrow and Target:AffectingCombat() and IsShieldOnTarget() then
      if Press(S.WreckingThrow, not Target:IsInRange(30)) then return "wrecking_throw main"; end
    end

    -- run_action_list,name=hac,if=raid_event.adds.exists|active_enemies>2
    if AOE and EnemiesCount8y > 2 then
      ShouldReturn = Hac(); if ShouldReturn then return ShouldReturn; end
    end
    -- call_action_list,name=execute,target_if=min:target.health.pct,if=(talent.massacre.enabled&target.health.pct<35)|target.health.pct<20
    if (S.Massacre:IsAvailable() and Target:HealthPercentage() < 35) or Target:HealthPercentage() < 20 then
      ShouldReturn = Execute(); if ShouldReturn then return ShouldReturn; end
    end
    -- run_action_list,name=single_target,if=!raid_event.adds.exists
    ShouldReturn = SingleTarget(); if ShouldReturn then return ShouldReturn; end
    -- Pool if nothing else to suggest
    if ER.CastAnnotated(S.Pool, false, "WAIT") then return "Wait/Pool Resources"; end
  end
end

local function FetchUseSettings()
  --General Use
  UseBattleShout = EpicSettings.Settings["useBattleShout"]
  UseCharge = EpicSettings.Settings["useCharge"]
  UseCleave = EpicSettings.Settings["useCleave"]
  UseExecute = EpicSettings.Settings["useExecute"]
  UseHeroicThrow = EpicSettings.Settings["useHeroicThrow"]
  UseMortalStrike = EpicSettings.Settings["useMortalStrike"]
  UseOverpower = EpicSettings.Settings["useOverpower"]
  UseRend = EpicSettings.Settings["useRend"]
  UseShockwave = EpicSettings.Settings["useShockwave"]
  UseSkullsplitter = EpicSettings.Settings["useSkullsplitter"]
  UseSlam = EpicSettings.Settings["useSlam"]
  UseSweepingStrikes = EpicSettings.Settings["useSweepingStrikes"]
  UseThunderClap = EpicSettings.Settings["useThunderClap"]
  UseWhirlwind = EpicSettings.Settings["useWhirlwind"]
  UseWreckingThrow = EpicSettings.Settings["useWreckingThrow"]

  --CD Use
  UseAvatar = EpicSettings.Settings["useAvatar"]
  UseBladestorm = EpicSettings.Settings["useBladestorm"]
  UseColossusSmash = EpicSettings.Settings["useColossusSmash"]
  UseSpearOfBastion = EpicSettings.Settings["useSpearOfBastion"]
  UseThunderousRoar = EpicSettings.Settings["useThunderousRoar"]
  UseWarbreaker = EpicSettings.Settings["useWarbreaker"]

  --SaveWithCD Settings
  AvatarWithCD = EpicSettings.Settings["avatarWithCD"]
  BladestormWithCD = EpicSettings.Settings["bladestormWithCD"]
  ColossusSmashWithCD = EpicSettings.Settings["colossusSmashWithCD"]
  SpearOfBastionWithCD = EpicSettings.Settings["spearOfBastionWithCD"]
  ThunderousRoarWithCD = EpicSettings.Settings["thunderousRoarWithCD"]
  WarbreakerWithCD = EpicSettings.Settings["warbreakerWithCD"]
end

local function FetchMoreSettings()
  --Interupt Settings
  UsePummel = EpicSettings.Settings["usePummel"]
  UseStormBolt = EpicSettings.Settings["useStormBolt"]
  UseIntimidatingShout = EpicSettings.Settings["useIntimidatingShout"]

  --Defensive Use Settings
  UseBitterImmunity = EpicSettings.Settings["useBitterImmunity"]
  UseDefensiveStance = EpicSettings.Settings["useDefensiveStance"]
  UseDieByTheSword = EpicSettings.Settings["useDieByTheSword"]
  UseIgnorePain = EpicSettings.Settings["useIgnorePain"]
  UseIntervene = EpicSettings.Settings["useIntervene"]
  UseRallyingCry = EpicSettings.Settings["useRallyingCry"]
  UseVictoryRush = EpicSettings.Settings["useVictoryRush"]

  --Defensive HP Settings
  BitterImmunityHP = EpicSettings.Settings["bitterImmunityHP"] or 0
  DefensiveStanceHP = EpicSettings.Settings["defensiveStanceHP"] or 0
  UnstanceHP = EpicSettings.Settings["unstanceHP"] or 0
  DieByTheSwordHP = EpicSettings.Settings["dieByTheSwordHP"] or 0
  IgnorePainHP = EpicSettings.Settings["ignorePainHP"] or 0
  InterveneHP = EpicSettings.Settings["interveneHP"] or 0
  RallyingCryGroup = EpicSettings.Settings["rallyingCryGroup"] or 0
  RallyingCryHP = EpicSettings.Settings["rallyingCryHP"] or 0
  VictoryRushHP = EpicSettings.Settings["victoryRushHP"] or 0
  
  --Placement Settings
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
    Enemies8y = Player:GetEnemiesInMeleeRange(8) -- Multiple Abilities
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
  ER.Print("Arms Warrior by Epic. Supported by xKaneto.")
end

ER.SetAPL(71, APL, Init)
