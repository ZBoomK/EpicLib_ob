--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- EpicDBC
local DBC = EpicDBC.DBC
-- EpicLib
local EL            = EpicLib
local Cache         = EpicCache
local Unit          = EL.Unit
local Utils         = EL.Utils
local Player        = Unit.Player
local Target        = Unit.Target
local Pet           = Unit.Pet
local Spell         = EL.Spell
local Item          = EL.Item
-- EpicLib
local ER            = EpicLib
local Bind          = ER.Bind
local Cast          = ER.Cast
local CastSuggested = ER.CastSuggested
local Press         = ER.Press
local Macro         = ER.Macro
-- Commons
local Everyone      = ER.Commons.Everyone
-- Num/Bool Helper Functions
local num           = Everyone.num
local bool          = Everyone.bool
-- lua
local mathmin       = math.min

--- ============================ CONTENT ===========================

local ShouldReturn

-- Toggles
local OOC = false;
local AOE = false;
local CDs = false;
local Kick = false;

--Settings Use
local UseAnnihilation
local UseBladeDance
local UseChaosStrike
local UseConsumeMagic
local UseDeathSweep
local UseDemonsBite
local UseEssenceBreak
local UseEyeBeam
local UseFelBarrage
local UseFelblade
local UseFelRush
local UseGlaiveTempest
local UseImmolationAura
local UseSigilOfFlame
local UseThrowGlaive
local UseVengefulRetreat

--Settings Use Interrupts
local UseChaosNova
local UseDisrupt
local UseFelEruption
local UseSigilOfMisery

--Settings Use With CD
local UseElysianDecree
local UseMetamorphosis
local UseTheHunt

--Settings WithCDs
local ElysianDecreeWithCD
local MetamorphosisWithCD
local TheHuntWithCD

--Settings UseDefensives
local UseBlur
local UseNetherwalk

--Settings DefensiveHP
local BlurHP

--Extras
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

local UseHealingPotion
local UseHealthstone
local HealingPotionHP
local HealthstoneHP
local HealingPotionName;

local SigilSetting
local CycleThroughEnemies


--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Define S/I for spell and item arrays
local S = Spell.DemonHunter.Havoc
local I = Item.DemonHunter.Havoc
local M = Macro.DemonHunter.Havoc

-- Create table to exclude above trinkets from On Use function
local OnUseExcludes = {
}

-- Trinket Item Objects
local equip = Player:GetEquipment()
local trinket1 = equip[13] and Item(equip[13]) or Item(0)
local trinket2 = equip[14] and Item(equip[14]) or Item(0)

-- Rotation Var
local Enemies8y, Enemies20y
local EnemiesCount8, EnemiesCount20
local FelbladeRange = 15

-- GUI Settings
--local Settings = {
--  General = ER.GUISettings.General,
--  Commons = ER.GUISettings.APL.DemonHunter.Commons,
--  Havoc = ER.GUISettings.APL.DemonHunter.Havoc
--}

-- Interrupts List
local StunInterrupts = {
  {S.FelEruption},
  {S.ChaosNova},
}

-- Variables
local VarBladeDance = false
local VarPoolingForBladeDance = false
local VarPoolingForEyeBeam = false
local VarWaitingForEssenceBreak = false
local VarWaitingForMomentum = false
local VarUseEyeBeamFuryCondition = false
local BossFightRemains = 11111
local FightRemains = 11111
local FodderToTheFlamesDeamonIds = {
  169421,
  169425,
  168932,
  169426,
  169429,
  169428,
  169430
}

EL:RegisterForEvent(function()
  VarBladeDance = false
  VarPoolingForBladeDance = false
  VarPoolingForEyeBeam = false
  VarWaitingForEssenceBreak = false
  VarWaitingForMomentum = false
  BossFightRemains = 11111
  FightRemains = 11111
end, "PLAYER_REGEN_ENABLED")

EL:RegisterForEvent(function()
  equip = Player:GetEquipment()
  trinket1 = equip[13] and Item(equip[13]) or Item(0)
  trinket2 = equip[14] and Item(equip[14]) or Item(0)
end, "PLAYER_EQUIPMENT_CHANGED")

-- Functions
local function EvalutateTargetIfFilterDemonsBite(TargetUnit)
  -- target_if=min:debuff.burning_wound.remains
  return TargetUnit:DebuffRemains(S.BurningWoundDebuff) or TargetUnit:DebuffRemains(S.BurningWoundLegDebuff)
end

local function EvaluateTargetIfDemonsBite(TargetUnit)
  -- if=talent.burning_wound&debuff.burning_wound.remains<4&active_dot.burning_wound<(spell_targets>?3)
  return S.BurningWound:IsAvailable() and TargetUnit:DebuffRemains(S.BurningWoundDebuff) < 4 and S.BurningWoundDebuff:AuraActiveCount() < mathmin(EnemiesCount8, 3)
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

local function Defensive()
  -- Manually added: Defensive Blur
  if S.Blur:IsCastable() and UseBlur and Player:HealthPercentage() <= BlurHP then
    if Press(S.Blur) then return "blur defensive"; end
  end

  -- Manually added: Defensive Netherwalk
  if S.Netherwalk:IsCastable() and UseNetherwalk and Player:HealthPercentage() <= NetherwalkHP then
    if Press(S.Netherwalk) then return "netherwalk defensive"; end
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
  -- augmentation
  -- food
  -- snapshot_stats
  
  -- sigil_of_flame
  if UseSigilOfFlame and S.SigilOfFlame:IsCastable() then
    if SigilSetting == "player" or S.ConcentratedSigils:IsAvailable() then
      if Press(M.SigilOfFlamePlayer, not Target:IsInMeleeRange(8)) then return "sigil_of_flame precombat 2"; end
    elseif SigilSetting == "cursor" then
      if Press(M.SigilOfFlameCursor, not Target:IsInMeleeRange(8)) then return "sigil_of_flame precombat 2"; end
    end
  end
  -- immolation_aura
  if S.ImmolationAura:IsCastable() and UseImmolationAura then
    if Press(S.ImmolationAura, not Target:IsInMeleeRange(8)) then return "immolation_aura precombat 8"; end
  end
  -- Manually added: Fel Rush if out of range
  if (not Target:IsInMeleeRange(5)) and S.FelRush:IsCastable() and UseFelRush then
    if Press(S.FelRush, not Target:IsInRange(8)) then return "fel_rush precombat 10"; end
  end
  -- Manually added: Demon's Bite/Demon Blades if in melee range
  if Target:IsInMeleeRange(5) and UseDemonsBite and (S.DemonsBite:IsCastable() or S.DemonBlades:IsAvailable()) then
    if Press(S.DemonsBite, not Target:IsInMeleeRange(5)) then return "demons_bite or demon_blades precombat 12"; end
  end
end

local function Cooldown()
  -- metamorphosis,if=!talent.demonic&((!talent.chaotic_transformation|cooldown.eye_beam.remains>20)&active_enemies>desired_targets|raid_event.adds.in>60|fight_remains<25)
  if FightRemainsCheck < FightRemains and ((CDs and MetamorphosisWithCD) or not MetamorphosisWithCD) and S.Metamorphosis:IsCastable() and UseMetamorphosis and (not S.Demonic:IsAvailable()) then
    if Press(M.MetamorphosisPlayer, not Target:IsInMeleeRange(5)) then return "metamorphosis cooldown 2"; end
  end
  -- metamorphosis,if=talent.demonic&(!talent.chaotic_transformation|cooldown.eye_beam.remains>20&(!variable.blade_dance|cooldown.blade_dance.remains>gcd.max)|fight_remains<25)
  if FightRemainsCheck < FightRemains and ((CDs and MetamorphosisWithCD) or not MetamorphosisWithCD) and S.Metamorphosis:IsCastable() and UseMetamorphosis and (S.Demonic:IsAvailable() and ((not S.ChaoticTransformation:IsAvailable()) or S.EyeBeam:CooldownRemains() > 20 and ((not VarBladeDance) or S.BladeDance:CooldownRemains() > Player:GCD() + 0.5) or FightRemains < 25)) then
    if Press(M.MetamorphosisPlayer, not Target:IsInMeleeRange(5)) then return "metamorphosis cooldown 4"; end
  end
  
  -- trinkets
  if FightRemainsCheck < FightRemains then
    if UseTrinkets and ((CDs and TrinketsWithCD) or not TrinketsWithCD) then
      ShouldReturn = Trinket(); if ShouldReturn then return ShouldReturn; end
    end
  end

  -- the_hunt,if=(!talent.momentum|!buff.momentum.up)
  if FightRemainsCheck < FightRemains and ((CDs and TheHuntWithCD) or not TheHuntWithCD) and S.TheHunt:IsCastable() and UseTheHunt and ((not S.Momentum:IsAvailable()) or Player:BuffDown(S.MomentumBuff) or (not UseVengefulRetreat and not UseFelRush)) then
    if Press(S.TheHunt, not Target:IsSpellInRange(S.TheHunt)) then return "the_hunt cooldown 20"; end
  end
  -- elysian_decree,if=(active_enemies>desired_targets|raid_event.adds.in>30)
  if FightRemainsCheck < FightRemains and UseElysianDecree and ((CDs and ElysianDecreeWithCD) or not ElysianDecreeWithCD) and S.ElysianDecree:IsCastable() then
    if Press(S.ElysianDecree, not Target:IsInRange(30)) then return "elysian_decree cooldown 22"; end
  end
end


local function FetchUseSetting()
  --Settings Use
  UseAnnihilation = EpicSettings.Settings["useAnnihilation"]
  UseBladeDance = EpicSettings.Settings["useBladeDance"]
  UseChaosStrike = EpicSettings.Settings["useChaosStrike"]
  UseConsumeMagic = EpicSettings.Settings["useConsumeMagic"]
  UseDeathSweep = EpicSettings.Settings["useDeathSweep"]
  UseDemonsBite = EpicSettings.Settings["useDemonsBite"]
  UseEssenceBreak = EpicSettings.Settings["useEssenceBreak"]
  UseEyeBeam = EpicSettings.Settings["useEyeBeam"]
  UseFelBarrage = EpicSettings.Settings["useFelBarrage"]
  UseFelblade = EpicSettings.Settings["useFelblade"]
  UseFelRush = EpicSettings.Settings["useFelRush"]
  UseGlaiveTempest = EpicSettings.Settings["useGlaiveTempest"]
  UseImmolationAura = EpicSettings.Settings["useImmolationAura"]
  UseSigilOfFlame = EpicSettings.Settings["useSigilOfFlame"]
  UseThrowGlaive = EpicSettings.Settings["useThrowGlaive"]
  UseVengefulRetreat = EpicSettings.Settings["useVengefulRetreat"]

  --Settings Use With CD
  UseElysianDecree = EpicSettings.Settings["useElysianDecree"]
  UseMetamorphosis = EpicSettings.Settings["useMetamorphosis"]
  UseTheHunt = EpicSettings.Settings["useTheHunt"]

  --Settings WithCDs
  ElysianDecreeWithCD = EpicSettings.Settings["elysianDecreeWithCD"]
  MetamorphosisWithCD = EpicSettings.Settings["metamorphosisWithCD"]
  TheHuntWithCD = EpicSettings.Settings["theHuntWithCD"]
end

local function FetchSettings()
  --Settings Use Interrupts
  UseChaosNova = EpicSettings.Settings["useChaosNova"]
  UseDisrupt = EpicSettings.Settings["useDisrupt"]
  UseFelEruption = EpicSettings.Settings["useFelEruption"]
  UseSigilOfMisery = EpicSettings.Settings["useSigilOfMisery"]

  --Settings UseDefensives
  UseBlur = EpicSettings.Settings["useBlur"]
  UseNetherwalk = EpicSettings.Settings["useNetherwalk"]

  --Settings DefensiveHP
  BlurHP = EpicSettings.Settings["blurHP"] or 0
  NetherwalkHP = EpicSettings.Settings["netherwalkHP"] or 0
 
  --Other Settings
  SigilSetting = EpicSettings.Settings["sigilSetting"] or ""
  CycleThroughEnemies = EpicSettings.Settings["cycleThroughEnemies"]
end

local function FetchGeneralSettings()
  FightRemainsCheck = EpicSettings.Settings["fightRemainsCheck"] or 0

  DispelBuffs = EpicSettings.Settings["dispelBuffs"]

  InterruptWithStun = EpicSettings.Settings["InterruptWithStun"]
  InterruptOnlyWhitelist = EpicSettings.Settings["InterruptOnlyWhitelist"]
  InterruptThreshold = EpicSettings.Settings["InterruptThreshold"]
  
  UseTrinkets = EpicSettings.Settings["useTrinkets"]
  TrinketsWithCD = EpicSettings.Settings["trinketsWithCD"]

  UseHealthstone = EpicSettings.Settings["useHealthstone"]
  UseHealingPotion = EpicSettings.Settings["useHealingPotion"]
  HealthstoneHP = EpicSettings.Settings["healthstoneHP"] or 0
  HealingPotionHP = EpicSettings.Settings["healingPotionHP"] or 0
  HealingPotionName = EpicSettings.Settings["HealingPotionName"] or ""

  HandleIncorporeal = EpicSettings.Settings["HandleIncorporeal"]
end


--- ======= ACTION LISTS =======
local function APL()

  FetchSettings();
  FetchUseSetting();
  FetchGeneralSettings();

  OOC = EpicSettings.Toggles["ooc"]
  AOE = EpicSettings.Toggles["aoe"]
  CDs = EpicSettings.Toggles["cds"]
  Kick = EpicSettings.Toggles["kick"]

  if AOE then
    Enemies8y = Player:GetEnemiesInMeleeRange(8) -- Multiple Abilities
    Enemies20y = Player:GetEnemiesInMeleeRange(20) -- Eye Beam
    EnemiesCount8 = #Enemies8y
    EnemiesCount20 = #Enemies20y
  else
    EnemiesCount8 = 1
    EnemiesCount20 = 1
  end
  FelbladeRange = 15
  if not (UseFelRush and UseVengefulRetreat) then FelbladeRange = 8 end

  if Everyone.TargetIsValid() or Player:AffectingCombat() then
    -- Calculate fight_remains
    BossFightRemains = EL.BossFightRemains(nil, true)
    FightRemains = BossFightRemains
    if FightRemains == 11111 then
      FightRemains = EL.FightRemains(Enemies8y, false)
    end
  end

  -- Defensive
  ShouldReturn = Defensive(); if ShouldReturn then return ShouldReturn; end

  -- Incorporeal
  if HandleIncorporeal then
    ShouldReturn = Everyone.HandleIncorporeal(S.Imprison, M.ImprisonMouseover, 30, true); if ShouldReturn then return ShouldReturn; end
  end

  if Everyone.TargetIsValid() then
    -- Precombat
    if not Player:AffectingCombat() then
      ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
    end

    -- potion
    local ShouldReturnPot = Everyone.HandleDPSPotion(Player:BuffUp(S.MetamorphosisBuff)); if ShouldReturnPot then return ShouldReturnPot; end

    if S.ConsumeMagic:IsAvailable() and UseConsumeMagic and S.ConsumeMagic:IsReady() and DispelBuffs and (not Player:IsCasting()) and (not Player:IsChanneling()) and Everyone.UnitHasMagicBuff(Target) then
      if Press(S.ConsumeMagic, not Target:IsSpellInRange(S.ConsumeMagic)) then return "greater_purge damage"; end
    end

    -- FodderToTheFlames
    if S.ThrowGlaive:IsReady() and Utils.ValueIsInArray(FodderToTheFlamesDeamonIds, Target:NPCID()) then
      if Press(S.ThrowGlaive, not Target:IsSpellInRange(S.ThrowGlaive)) then return "fodder to the flames"; end
    end
    -- auto_attack
    -- retarget_auto_attack,line_cd=1,target_if=min:debuff.burning_wound.remains,if=talent.burning_wound&talent.demon_blades&active_dot.burning_wound<(spell_targets>?3)
    -- variable,name=blade_dance,value=talent.first_blood|talent.trail_of_ruin|talent.chaos_theory&buff.chaos_theory.down|spell_targets.blade_dance1>1
    VarBladeDance = (S.FirstBlood:IsAvailable() or S.TrailofRuin:IsAvailable() or S.ChaosTheory:IsAvailable() and Player:BuffDown(S.ChaosTheoryBuff) or EnemiesCount8 > 1)
    -- variable,name=pooling_for_blade_dance,value=variable.blade_dance&fury<(75-talent.demon_blades*20)&cooldown.blade_dance.remains<gcd.max
    VarPoolingForBladeDance = (VarBladeDance and Player:Fury() < (75 - num(S.DemonBlades:IsAvailable()) * 20) and S.BladeDance:CooldownRemains() < Player:GCD() + 0.5)
    -- variable,name=pooling_for_eye_beam,value=talent.demonic&!talent.blind_fury&cooldown.eye_beam.remains<(gcd.max*2)&fury.deficit>20
    VarPoolingForEyeBeam = S.Demonic:IsAvailable() and (not S.BlindFury:IsAvailable()) and S.EyeBeam:CooldownRemains() < (Player:GCD() * 2) and Player:FuryDeficit() > 20
    -- variable,name=waiting_for_momentum,value=talent.momentum&!buff.momentum.up
    VarWaitingForMomentum = S.Momentum:IsAvailable() and Player:BuffDown(S.MomentumBuff) and (UseFelRush or UseVengefulRetreat)
    
    -- disrupt,if=target.debuff.casting.react (Interrupts)
    if not Player:IsCasting() and not Player:IsChanneling() and Kick then
      if UseDisrupt then
        ShouldReturn = Everyone.Interrupt(S.Disrupt, 10); if ShouldReturn then return ShouldReturn; end
        ShouldReturn = Everyone.Interrupt(M.DisruptMouseover,10); if ShouldReturn then return ShouldReturn; end
      end
      if UseSigilOfMisery then
        if ConcentratedSigils:IsAvailable() or SigilSetting == "player" then
          ShouldReturn = Everyone.Interrupt(M.SigilOfMiseryPlayer, 10); if ShouldReturn then return ShouldReturn; end
        elseif SigilSetting == "cursor" then
          ShouldReturn = Everyone.InterruptCursor(M.SigilOfMiseryCursor, 30); if ShouldReturn then return ShouldReturn; end
        end
      end
      if UseChaosNova then
        ShouldReturn = Everyone.InterruptWithStun(S.ChaosNova, 8); if ShouldReturn then return ShouldReturn; end
      end
      if UseFelEruption then
        ShouldReturn = Everyone.InterruptWithStun(S.FelEruption, 8); if ShouldReturn then return ShouldReturn; end
      end
    end
    -- call_action_list,name=cooldown,if=gcd.remains=0
    ShouldReturn = Cooldown(); if ShouldReturn then return ShouldReturn; end
    
    -- pick_up_fragment,type=demon,if=demon_soul_fragments>0
    -- pick_up_fragment,mode=nearest,if=talent.demonic_appetite&fury.deficit>=35&(!cooldown.eye_beam.ready|fury<30)
    -- TODO: Can't detect when orbs actually spawn, we could possibly show a suggested icon when we DON'T want to pick up souls so people can avoid moving?
    -- annihilation,if=buff.inner_demon.up&cooldown.metamorphosis.remains<=gcd*3
    if S.Annihilation:IsReady() and UseAnnihilation and (Player:BuffUp(S.InnerDemonBuff) and S.Metamorphosis:CooldownRemains() <= Player:GCD() * 3) then
      if Press(S.Annihilation, not Target:IsInMeleeRange(5)) then return "annihilation main 2"; end
    end
    -- vengeful_retreat,use_off_gcd=1,if=talent.initiative&talent.essence_break&time>1&gcd.remains<0.4&(cooldown.essence_break.remains>15|cooldown.essence_break.remains<gcd.max&(!talent.demonic|buff.metamorphosis.up|cooldown.eye_beam.remains>15+(10*talent.cycle_of_hatred)))
    -- Note: Add 250ms to GCDRemains check to allow for internet and human latencies
    if UseVengefulRetreat and S.VengefulRetreat:IsCastable() and (S.Initiative:IsAvailable() and S.EssenceBreak:IsAvailable() and EL.CombatTime() > 1 and Player:GCDRemains() < 0.65 and (S.EssenceBreak:CooldownRemains() > 15 or S.EssenceBreak:CooldownRemains() < Player:GCD() + 0.5 and ((not S.Demonic:IsAvailable()) or Player:BuffUp(S.MetamorphosisBuff) or S.EyeBeam:CooldownRemains() > 15 + (10 * num(S.CycleofHatred:IsAvailable()))))) then
      if Press(S.VengefulRetreat, not Target:IsInMeleeRange(8)) then return "vengeful_retreat main 4"; end
    end
    -- vengeful_retreat,use_off_gcd=1,if=talent.initiative&!talent.essence_break&time>1&!buff.momentum.up
    if UseVengefulRetreat and S.VengefulRetreat:IsCastable() and (S.Initiative:IsAvailable() and (not S.EssenceBreak:IsAvailable()) and EL.CombatTime() > 1 and Player:BuffDown(S.MomentumBuff)) then
      if Press(S.VengefulRetreat, not Target:IsInMeleeRange(8)) then return "vengeful_retreat main 5"; end
    end
    -- fel_rush,if=(buff.unbound_chaos.up|variable.waiting_for_momentum&(!talent.unbound_chaos|!cooldown.immolation_aura.ready))&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if S.FelRush:IsCastable() and ((Player:BuffUp(S.UnboundChaosBuff) or VarWaitingForMomentum and ((not S.UnboundChaos:IsAvailable()) or S.ImmolationAura:CooldownDown())) and UseFelRush) then
      if Press(S.FelRush, not Target:IsInMeleeRange(8)) then return "fel_rush main 6"; end
    end
    -- essence_break,if=(active_enemies>desired_targets|raid_event.adds.in>40)&!variable.waiting_for_momentum&fury>40&(cooldown.eye_beam.remains>8|buff.metamorphosis.up)&(!talent.tactical_retreat|buff.tactical_retreat.up)
    if S.EssenceBreak:IsCastable() and UseEssenceBreak and ((not VarWaitingForMomentum) and Player:Fury() > 40 and (S.EyeBeam:CooldownRemains() > 8 or Player:BuffUp(S.MetamorphosisBuff)) and ((not S.TacticalRetreat:IsAvailable()) or Player:BuffUp(S.TacticalRetreatBuff) or not UseVengefulRetreat)) then
      if Press(S.EssenceBreak, not Target:IsInMeleeRange(10)) then return "essence_break main 9"; end
    end
    -- death_sweep,if=variable.blade_dance&(!talent.essence_break|cooldown.essence_break.remains>(cooldown.death_sweep.duration-4))
    if S.DeathSweep:IsReady() and UseDeathSweep and (VarBladeDance and ((not S.EssenceBreak:IsAvailable()) or S.EssenceBreak:CooldownRemains() > ((9 * Player:SpellHaste()) - 4))) then
      if Press(S.DeathSweep, not Target:IsInMeleeRange(8)) then return "death_sweep main 10"; end
    end
    -- fel_barrage,if=active_enemies>desired_targets|raid_event.adds.in>30
    if S.FelBarrage:IsCastable() and UseFelBarrage then
      if Press(S.FelBarrage, not Target:IsInMeleeRange(8)) then return "fel_barrage main 12"; end
    end
    -- glaive_tempest,if=active_enemies>desired_targets|raid_event.adds.in>10
    if S.GlaiveTempest:IsReady() and UseGlaiveTempest then
      if Press(S.GlaiveTempest, not Target:IsInMeleeRange(8)) then return "glaive_tempest main 14"; end
    end
    -- annihilation,if=buff.inner_demon.up&cooldown.eye_beam.remains<=gcd
    if S.Annihilation:IsReady() and UseAnnihilation and (Player:BuffUp(S.InnerDemonBuff) and S.EyeBeam:CooldownRemains() <= Player:GCD()) then
      if Press(S.Annihilation, not Target:IsInMeleeRange(5)) then return "annihilation main 16"; end
    end
    -- eye_beam,if=active_enemies>desired_targets|raid_event.adds.in>(40-talent.cycle_of_hatred*15)&!debuff.essence_break.up
    if S.EyeBeam:IsReady() and UseEyeBeam and (Target:DebuffDown(S.EssenceBreakDebuff)) then
      if Press(S.EyeBeam, not Target:IsInMeleeRange(20)) then return "eye_beam main 18"; end
    end
    -- blade_dance,if=variable.blade_dance&(cooldown.eye_beam.remains>5|!talent.demonic|(raid_event.adds.in>cooldown&raid_event.adds.in<25))
    if S.BladeDance:IsReady() and UseBladeDance and (VarBladeDance and (S.EyeBeam:CooldownRemains() > 5 or not S.Demonic:IsAvailable())) then
      if Press(S.BladeDance, not Target:IsInMeleeRange(8)) then return "blade_dance main 20"; end
    end
    -- throw_glaive,if=talent.soulrend&(active_enemies>desired_targets|raid_event.adds.in>full_recharge_time+9)&spell_targets>=(2-talent.furious_throws)&!debuff.essence_break.up
    if Target:AffectingCombat() and UseThrowGlaive and S.ThrowGlaive:IsReady() and (S.Soulrend:IsAvailable() and EnemiesCount8 >= (2 - num(S.FuriousThrows)) and Target:DebuffDown(S.EssenceBreakDebuff)) then
      if Press(S.ThrowGlaive, not Target:IsSpellInRange(S.ThrowGlaive)) then return "throw_glaive main 22"; end
    end
    -- annihilation,if=!variable.pooling_for_blade_dance
    if S.Annihilation:IsReady() and UseAnnihilation and (not VarPoolingForBladeDance) then
      if Press(S.Annihilation, not Target:IsInMeleeRange(5)) then return "annihilation main 24"; end
    end
    -- throw_glaive,if=talent.serrated_glaive&cooldown.eye_beam.remains<4&!debuff.serrated_glaive.up&!debuff.essence_break.up
    if Target:AffectingCombat() and UseThrowGlaive and S.ThrowGlaive:IsReady() and (S.SerratedGlaive:IsAvailable() and S.EyeBeam:CooldownRemains() < 4 and Target:DebuffDown(S.SerratedGlaiveDebuff) and Target:DebuffDown(S.EssenceBreakDebuff)) then
      if Press(S.ThrowGlaive, not Target:IsSpellInRange(S.ThrowGlaive)) then return "throw_glaive main 16"; end
    end
    -- immolation_aura,if=!buff.immolation_aura.up&(!talent.ragefire|active_enemies>desired_targets|raid_event.adds.in>15)
    if S.ImmolationAura:IsCastable() and UseImmolationAura and (Player:BuffDown(S.ImmolationAuraBuff)) then
      if Press(S.ImmolationAura, not Target:IsInMeleeRange(8)) then return "immolation_aura main 26"; end
    end
    -- fel_rush,if=talent.isolated_prey&active_enemies=1&fury.deficit>=35
    if S.FelRush:IsCastable() and (S.IsolatedPrey:IsAvailable() and EnemiesCount8 == 1 and Player:FuryDeficit() >= 35) and UseFelRush then
      if Press(S.FelRush, not Target:IsInMeleeRange(8)) then return "fel_rush main 27"; end
    end
    -- felblade,if=fury.deficit>=40
    if S.Felblade:IsCastable() and UseFelblade and (Player:FuryDeficit() >= 40) then
      if Press(S.Felblade, not Target:IsInRange(FelbladeRange)) then return "felblade main 28"; end
    end
    -- chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam
    if S.ChaosStrike:IsReady() and UseChaosStrike and ((not VarPoolingForBladeDance) and not VarPoolingForEyeBeam) then
      if Press(S.ChaosStrike, not Target:IsSpellInRange(S.ChaosStrike)) then return "chaos_strike main 32"; end
    end
    -- fel_rush,if=!talent.momentum&talent.demon_blades&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if S.FelRush:IsCastable() and ((not S.Momentum:IsAvailable()) and S.DemonBlades:IsAvailable() and S.EyeBeam:CooldownDown() and UseFelRush) then
      if Press(S.FelRush, not Target:IsInMeleeRange(8)) then return "fel_rush main 34"; end
    end
    -- demons_bite,target_if=min:debuff.burning_wound.remains,if=talent.burning_wound&debuff.burning_wound.remains<4&active_dot.burning_wound<(spell_targets>?3)
    if S.DemonsBite:IsCastable() and UseDemonsBite and CycleThroughEnemies then
      if Everyone.CastTargetIf(S.DemonsBite, Enemies8y, "min", EvalutateTargetIfFilterDemonsBite, EvaluateTargetIfDemonsBite, not Target:IsSpellInRange(S.DemonsBite)) then return "demons_bite main 36"; end
    end
    -- fel_rush,if=!talent.momentum&!talent.demon_blades&spell_targets>1&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
    if S.FelRush:IsCastable() and ((not S.Momentum:IsAvailable()) and (not S.DemonBlades:IsAvailable()) and EnemiesCount8 > 1 and UseFelRush) then
      if Press(S.FelRush, not Target:IsInMeleeRange(8)) then return "fel_rush main 38"; end
    end
    -- sigil_of_flame,if=raid_event.adds.in>15&fury.deficit>=30
    if UseSigilOfFlame and S.SigilOfFlame:IsCastable() and (Player:FuryDeficit() >= 40) then
      if SigilSetting == "player" or S.ConcentratedSigils:IsAvailable() then
        if Press(M.SigilOfFlamePlayer, not Target:IsInMeleeRange(8)) then return "sigil_of_flame precombat 2"; end
      elseif SigilSetting == "cursor" then
        if Press(M.SigilOfFlameCursor, not Target:IsInMeleeRange(8)) then return "sigil_of_flame precombat 2"; end
      end
    end
    -- demons_bite
    if S.DemonsBite:IsCastable() and UseDemonsBite then
      if Press(S.DemonsBite, not Target:IsSpellInRange(S.DemonsBite)) then return "demons_bite main 42"; end
    end
    -- fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum)
    if S.FelRush:IsCastable() and ((not Target:IsInMeleeRange(8)) and (not S.Momentum:IsAvailable()) and UseFelRush) then
      if Press(S.FelRush, not Target:IsInMeleeRange(8)) then return "fel_rush main 46"; end
    end
    -- vengeful_retreat,if=!talent.initiative&movement.distance>15
    if UseVengefulRetreat and S.VengefulRetreat:IsCastable() and ((not S.Initiative:IsAvailable()) and (not Target:IsInMeleeRange(8))) then
      if Press(S.VengefulRetreat, not Target:IsInMeleeRange(8)) then return "vengeful_retreat main 48"; end
    end
    -- throw_glaive,if=(talent.demon_blades.enabled|buff.out_of_range.up)&!debuff.essence_break.up
    if Target:AffectingCombat() and UseThrowGlaive and S.ThrowGlaive:IsReady() and ((S.DemonBlades:IsAvailable() or not Target:IsInRange(12)) and Target:DebuffDown(S.EssenceBreakDebuff)) then
      if Press(S.ThrowGlaive, not Target:IsSpellInRange(S.ThrowGlaive)) then return "throw_glaive main 50"; end
    end
    -- Show pool icon if nothing else to do (should only happen when Demon Blades is used)
    if (S.DemonBlades:IsAvailable()) then
      if Press(S.Pool) then return "pool demon_blades"; end
    end
  end
end

local function Init()
  S.BurningWoundDebuff:RegisterAuraTracking()
  ER.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.")
end

ER.SetAPL(577, APL, Init)
