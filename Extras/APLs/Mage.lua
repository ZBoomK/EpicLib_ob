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
local MergeTableByKey = EL.Utils.MergeTableByKey
-- EpicLib
local ER         = EpicLib
local Macro      = ER.Macro
-- lua
local GetTime    = GetTime
-- lua
local mathmin     = math.min


--- ============================ CONTENT ============================

-- Spells
if not Spell.Mage then Spell.Mage = {} end
Spell.Mage.Commons = {
  -- Racials
  AncestralCall                         = Spell(274738, nil, 1),
  BagofTricks                           = Spell(312411, nil, 2),
  Berserking                            = Spell(26297, nil, 3),
  BloodFury                             = Spell(20572, nil, 4),
  Fireblood                             = Spell(265221, nil, 5),
  LightsJudgment                        = Spell(255647, nil, 6),
  -- Abilities
  ArcaneExplosion                       = Spell(1449, nil, 7), --Melee, 10
  ArcaneIntellect                       = Spell(1459, nil, 8),
  Blink                                 = MultiSpell(9, 1953, 212653),
  Frostbolt                             = Spell(116, nil, 10),
  FrostNova                             = Spell(122, nil, 11),
  Polymorph                             = Spell(118, nil, 12),
  SlowFall                              = Spell(130, nil, 13),
  TimeWarp                              = Spell(80353, nil, 14),
  -- Talents
  AlterTime                             = Spell(342245, nil, 15),
  BlastWave                             = Spell(157981, nil, 16),
  Counterspell                          = Spell(2139, nil, 17),
  DragonsBreath                         = Spell(31661, nil, 18),
  FocusMagic                            = Spell(321358, nil, 19),
  GreaterInvisibility                   = Spell(110959, nil, 56),
  IceBlock                              = Spell(45438, nil, 20),
  IceFloes                              = Spell(108839, nil, 21),
  IceNova                               = Spell(157997, nil, 22), --splash, 8
  Invisibility                          = Spell(66, nil, 23),
  MassBarrier                           = Spell(414660, nil, 24),
  Meteor                                = Spell(153561, nil, 25),
  MirrorImage                           = Spell(55342, nil, 26),
  RemoveCurse                           = Spell(475, nil, 27),
  RingOfFrost                           = Spell(113724, nil, 28),
  RuneofPower                           = Spell(116011, nil, 29),
  ShiftingPower                         = Spell(382440, nil, 30), --Melee 15
  Spellsteal                            = Spell(30449, nil, 31),
  TemporalWarp                          = Spell(386539, nil, 32),
  -- Buffs
  ArcaneIntellectBuff                   = Spell(1459, nil, 33),
  BerserkingBuff                        = Spell(26297, nil, 34),
  BloodFuryBuff                         = Spell(20572, nil, 35),
  RuneofPowerBuff                       = Spell(116014, nil, 36),
  TemporalWarpBuff                      = Spell(386540, nil, 37),
  -- Debuffs
  Pool                                  = Spell(999910, nil, 200),
}

Spell.Mage.Arcane = MergeTableByKey(Spell.Mage.Commons, {
  -- Abilities
  ArcaneBlast                           = Spell(30451, nil, 38),
  FireBlast                             = Spell(319836, nil, 39),
  -- Talents
  Amplification                         = Spell(236628, nil, 40),
  ArcaneBarrage                         = Spell(44425, nil, 41), --Splash, 10
  ArcaneBombardment                     = Spell(384581, nil, 42),
  ArcaneEcho                            = Spell(342231, nil, 43), --Splash, 8
  ArcaneFamiliar                        = Spell(205022, nil, 44),
  ArcaneHarmony                         = Spell(384452, nil, 45),
  ArcaneMissiles                        = Spell(5143, nil, 46), --Splash, 8
  ArcaneOrb                             = Spell(153626, nil, 47), --Splash, 16
  ArcanePower                           = Spell(321739, nil, 48),
  ArcaneSurge                           = Spell(365350, nil, 49),
  CascadingPower                        = Spell(384276, nil, 50),
  ChargedOrb                            = Spell(384651, nil, 51),
  ConjureManaGem                        = Spell(759, nil, 52),
  Concentration                         = Spell(384374, nil, 53),
  Enlightened                           = Spell(321387, nil, 54),
  Evocation                             = Spell(12051, nil, 55),
  NetherTempest                         = Spell(114923, nil, 57), --Splash, 10
  NetherPrecision                       = Spell(383782, nil, 58),
  OrbBarrage                            = Spell(384858, nil, 59),
  Overpowered                           = Spell(155147, nil, 60),
  PresenceofMind                        = Spell(205025, nil, 61),
  PrismaticBarrier                      = Spell(235450, nil, 62),
  RadiantSpark                          = Spell(376103, nil, 63),
  Resonance                             = Spell(205028, nil, 64),
  RuleofThrees                          = Spell(264354, nil, 65),
  SiphonStorm                           = Spell(384187, nil, 66),
  Slipstream                            = Spell(236457, nil, 67),
  Supernova                             = Spell(157980, nil, 68), --Splash, 8
  TimeAnomaly                           = Spell(383243, nil, 69),
  TouchoftheMagi                        = Spell(321507, nil, 70), --Splash, 8
  -- Buffs
  ArcaneFamiliarBuff                    = Spell(210126, nil, 71),
  ArcaneHarmonyBuff                     = Spell(384455, nil, 72),
  ArcaneOverloadBuff                    = Spell(409022, nil, 73), -- Tier 30 4pc
  ArcaneSurgeBuff                       = Spell(365362, nil, 74),
  ClearcastingBuff                      = Spell(263725, nil, 75),
  ConcentrationBuff                     = Spell(384379, nil, 76),
  NetherPrecisionBuff                   = Spell(383783, nil, 77),
  PresenceofMindBuff                    = Spell(205025, nil, 78),
  RuleofThreesBuff                      = Spell(264774, nil, 79),
  SiphonStormBuff                       = Spell(384267, nil, 80),
  -- Debuffs
  NetherTempestDebuff                   = Spell(114923, nil, 81), --Splash, 10
  RadiantSparkDebuff                    = Spell(376103, nil, 82),
  RadiantSparkVulnerability             = Spell(376104, nil, 83),
  TouchoftheMagiDebuff                  = Spell(210824, nil, 84),
})

Spell.Mage.Fire = MergeTableByKey(Spell.Mage.Commons, {
  -- Abilities
  Fireball                              = Spell(133, nil, 85),
  Flamestrike                           = Spell(2120, nil, 86),
  -- Talents
  AlexstraszasFury                      = Spell(235870, nil, 87),
  BlazingBarrier                        = Spell(235313, nil, 88),
  Combustion                            = Spell(190319, nil, 89),
  FeeltheBurn                           = Spell(383391, nil, 90),
  FireBlast                             = Spell(108853, nil, 91),
  Firestarter                           = Spell(205026, nil, 92),
  FlameOn                               = Spell(205029, nil, 93),
  FlamePatch                            = Spell(205037, nil, 94),
  FromTheAshes                          = Spell(342344, nil, 95),
  Hyperthermia                          = Spell(383860, nil, 96),
  ImprovedScorch                        = Spell(383604, nil, 97),
  Kindling                              = Spell(155148, nil, 98),
  LivingBomb                            = Spell(44457, nil, 99),
  PhoenixFlames                         = Spell(257541, nil, 100),
  Pyroblast                             = Spell(11366, nil, 101),
  Scorch                                = Spell(2948, nil, 102),
  SearingTouch                          = Spell(269644, nil, 103),
  SunKingsBlessing                      = Spell(383886, nil, 104),
  TemperedFlames                        = Spell(383659, nil, 105),
  -- Buffs
  CombustionBuff                        = Spell(190319, nil, 106),
  FeeltheBurnBuff                       = Spell(383395, nil, 107),
  FlameAccelerantBuff                   = Spell(203277, nil, 108),
  FlamesFuryBuff                        = Spell(409964, nil, 109), -- T30 4pc bonus
  HeatingUpBuff                         = Spell(48107, nil, 110),
  HotStreakBuff                         = Spell(48108, nil, 111),
  HyperthermiaBuff                      = Spell(383874, nil, 112),
  SunKingsBlessingBuff                  = Spell(383882, nil, 113),
  FuryoftheSunKingBuff                  = Spell(383883, nil, 114),
  -- Debuffs
  CharringEmbersDebuff                  = Spell(408665, nil, 115), -- T30 2pc bonus
  IgniteDebuff                          = Spell(12654, nil, 116),
  ImprovedScorchDebuff                  = Spell(383608, nil, 117),
})

Spell.Mage.Frost = MergeTableByKey(Spell.Mage.Commons, {
  -- Abilities
  ConeofCold                            = Spell(120, nil, 118), --Melee, 12
  IciclesBuff                           = Spell(205473, nil, 119),
  WintersChillDebuff                    = Spell(228358, nil, 120),
  FireBlast                             = Spell(319836, nil, 121),
  -- Talents
  Blizzard                              = Spell(190356, nil, 122), --splash, 16
  BoneChilling                          = Spell(205766, nil, 123),
  ChainReaction                         = Spell(278309, nil, 124),
  ColdestSnap                           = Spell(417493, nil, 125),
  CometStorm                            = Spell(153595, nil, 126), --splash, 6
  Ebonbolt                              = Spell(257537, nil, 127), --splash, 8 (with splitting ice),
  Flurry                                = Spell(44614, nil, 128),
  FreezingRain                          = Spell(270233, nil, 129),
  FreezingWinds                         = Spell(382103, nil, 130),
  Frostbite                             = Spell(198121, nil, 131),
  FrozenOrb                             = Spell(84714, nil, 132), --splash, 16
  GlacialSpike                          = Spell(199786, nil, 133), --splash, 8 (with splitting ice),
  IceBarrier                            = Spell(11426, nil, 134),
  IceCaller                             = Spell(236662, nil, 135),
  IceLance                              = Spell(30455, nil, 136), --splash, 8 (with splitting ice),
  IcyVeins                              = Spell(12472, nil, 137),
  RayofFrost                            = Spell(205021, nil, 138),
  SlickIce                              = Spell(382144, nil, 139),
  Snowstorm                             = Spell(381706, nil, 140),
  SplinteringCold                       = Spell(379049, nil, 141),
  SplittingIce                          = Spell(56377, nil, 141), --splash, 8
  SummonWaterElemental                  = Spell(31687, nil, 142),
  -- Pet Abilities
  Freeze                                = Spell(33395, nil, 143), --splash, 8
  WaterJet                              = Spell(135029, nil, 144),
  -- Buffs
  BrainFreezeBuff                       = Spell(190446, nil, 145),
  FingersofFrostBuff                    = Spell(44544, nil, 146),
  FreezingRainBuff                      = Spell(270232, nil, 147),
  FreezingWindsBuff                     = Spell(382106, nil, 148),
  GlacialSpikeBuff                      = Spell(199844, nil, 149),
  IcyVeinsBuff                          = Spell(12472, nil, 150),
  SnowstormBuff                         = Spell(381522, nil, 151),
  -- Debuffs
})

-- Items
if not Item.Mage then Item.Mage = {} end
Item.Mage.Commons = {
  -- Potion
  Healthstone                           = Item(5512),
  RefreshingHealingPotion               = Item(191380),
}

Item.Mage.Arcane = MergeTableByKey(Item.Mage.Commons, {
  ManaGem                               = Item(36799),
})

Item.Mage.Fire = MergeTableByKey(Item.Mage.Commons, {
})

Item.Mage.Frost = MergeTableByKey(Item.Mage.Commons, {
})

-- Macros
if not Macro.Mage then Macro.Mage = {} end
Macro.Mage.Commons = {
  -- Items
  Healthstone                             = Macro(9),
  RefreshingHealingPotion                 = Macro(10),
  -- Spells
  CounterspellMouseover                   = Macro(11),
  PolymorphMouseover                      = Macro(12),
  RemoveCurseMouseover                    = Macro(13),
  RemoveCurseFocus                        = Macro(14),
  StopCasting                             = Macro(15),
}

Macro.Mage.Arcane = MergeTableByKey(Macro.Mage.Commons, {
  ManaGem                                 = Macro(16),
  CancelPOM                               = Macro(17),
})

Macro.Mage.Fire = MergeTableByKey(Macro.Mage.Commons, {
  FlamestrikeCursor                       = Macro(18),
  MeteorCursor                            = Macro(19),
})  

Macro.Mage.Frost = MergeTableByKey(Macro.Mage.Commons, {
  BlizzardCursor                          = Macro(20),
  IceLanceMouseover                       = Macro(21),
  FreezePet                               = Macro(22),
})

-- Overrides
-- Mage
local RopDuration = Spell.Mage.Frost.RuneofPower:BaseDuration()

-- Arcane, ID: 62
local ArcaneOldPlayerAffectingCombat
ArcaneOldPlayerAffectingCombat = EL.AddCoreOverride("Player.AffectingCombat",
  function (self)
    return Spell.Mage.Arcane.ArcaneBlast:InFlight() or ArcaneOldPlayerAffectingCombat(self)
  end
, 62)

EL.AddCoreOverride("Spell.IsCastable",
  function (self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
    if self:CastTime() > 0 and Player:IsMoving() then
      return false
    end

    local RangeOK = true
    if Range then
      local RangeUnit = ThisUnit or Target
      RangeOK = RangeUnit:IsInRange( Range, AoESpell )
    end

    local BaseCheck = self:IsLearned() and self:CooldownRemains( BypassRecovery, Offset or "Auto") == 0 and RangeOK and Player:Mana() >= self:Cost()
    if self == Spell.Mage.Arcane.PresenceofMind then
      return BaseCheck and Player:BuffDown(Spell.Mage.Arcane.PresenceofMind)
    elseif self == Spell.Mage.Arcane.RadiantSpark then
      return BaseCheck and not Player:IsCasting(self)
    elseif self == Spell.Mage.Arcane.ShiftingPower then
      return BaseCheck and not Player:IsCasting(self)
    elseif self == Spell.Mage.Arcane.TouchoftheMagi then
      return BaseCheck and not Player:IsCasting(self)
    elseif self == Spell.Mage.Arcane.ConjureManaGem then
      local ManaGem = Item.Mage.Arcane.ManaGem
      local GemCD = ManaGem:CooldownRemains()
      return BaseCheck and (not Player:IsCasting(self)) and not (ManaGem:IsReady() or GemCD > 0)
    elseif self == Spell.Mage.Arcane.ArcaneSurge then
      return self:IsLearned() and self:CooldownUp() and RangeOK
    else
      return BaseCheck
    end
  end
, 62)

-- Fire, ID: 63
local FireOldPlayerBuffStack
FireOldPlayerBuffStack = EL.AddCoreOverride("Player.BuffStack",
  function (self, Spell, AnyCaster, Offset)
    local BaseCheck = FireOldPlayerBuffStack(self, Spell, AnyCaster, Offset)
    if Spell == Spell.Mage.Fire.PyroclasmBuff and self:IsCasting(Spell.Mage.Fire.Pyroblast) then
      return 0
    else
      return BaseCheck
    end
  end
, 63)

local FirePlayerBuffRemains
FirePlayerBuffRemains = EL.AddCoreOverride("Player.BuffRemains",
  function (self, Spell, AnyCaster, Offset)
    local BaseCheck = FirePlayerBuffRemains(self, Spell, AnyCaster, Offset)
    if Spell == Spell.Mage.Fire.PyroclasmBuff and self:IsCasting(Spell.Mage.Fire.Pyroblast) then
      return 0
    end
    return BaseCheck
  end
, 63)

EL.AddCoreOverride("Spell.IsReady",
  function (self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
    local BaseCheck = self:IsCastable() and self:IsUsableP()
    local MovingOK = true
    if self:CastTime() > 0 and Player:IsMoving() then
      if self == Spell.Mage.Fire.Scorch or (self == Spell.Mage.Fire.Pyroblast and Player:BuffUp(Spell.Mage.Fire.HotStreakBuff)) or (self == Spell.Mage.Fire.Flamestrike and Player:BuffUp(Spell.Mage.Fire.HotStreakBuff)) then
        MovingOK = true
      else
        return false
      end
    else
      return BaseCheck
    end
  end
, 63)

EL.AddCoreOverride("Spell.IsCastable",
  function (self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
    if self:CastTime() > 0 and Player:IsMoving() then
      return false
    end

    local RangeOK = true
    if Range then
      local RangeUnit = ThisUnit or Target
      RangeOK = RangeUnit:IsInRange( Range, AoESpell )
    end

    local BaseCheck = self:IsLearned() and self:CooldownRemains( BypassRecovery, Offset or "Auto") == 0 and RangeOK
    if self == Spell.Mage.Fire.RadiantSpark then
      return BaseCheck and not Player:IsCasting(self)
    elseif self == Spell.Mage.Fire.ShiftingPower then
      return BaseCheck and not Player:IsCasting(self)
    else
      return BaseCheck
    end
  end
, 63)

local FireOldPlayerAffectingCombat
FireOldPlayerAffectingCombat = EL.AddCoreOverride("Player.AffectingCombat",
  function (self)
    return FireOldPlayerAffectingCombat(self)
      or Player:IsCasting(Spell.Mage.Fire.Pyroblast)
      or Player:IsCasting(Spell.Mage.Fire.Fireball)
  end
, 63)

EL.AddCoreOverride("Spell.InFlightRemains",
  function(self)
    return self:TravelTime() - self:TimeSinceLastCast()
  end
, 63)

-- Frost, ID: 64
local FrostOldSpellIsCastable
FrostOldSpellIsCastable = EL.AddCoreOverride("Spell.IsCastable",
  function (self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
    local MovingOK = true
    if self:CastTime() > 0 and Player:IsMoving() then
      if self == Spell.Mage.Frost.Blizzard and Player:BuffUp(Spell.Mage.Frost.FreezingRain) then
        MovingOK = true
      else
        return false
      end
    end

    local RangeOK = true
    if Range then
      local RangeUnit = ThisUnit or Target
      RangeOK = RangeUnit:IsInRange( Range, AoESpell )
    end
    if self == Spell.Mage.Frost.GlacialSpike then
      return self:IsLearned() and RangeOK and MovingOK and not Player:IsCasting(self) and (Player:BuffUp(Spell.Mage.Frost.GlacialSpikeBuff) or (Player:BuffStack(Spell.Mage.Frost.IciclesBuff) == 5))
    else
      local BaseCheck = FrostOldSpellIsCastable(self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
      if self == Spell.Mage.Frost.SummonWaterElemental then
        return BaseCheck and not Pet:IsActive()
      elseif self == Spell.Mage.Frost.RuneofPower then
        return BaseCheck and not Player:IsCasting(self) and Player:BuffDown(Spell.Mage.Frost.RuneofPowerBuff)
      elseif self == Spell.Mage.Frost.MirrorsofTorment then
        return BaseCheck and not Player:IsCasting(self)
      elseif self == Spell.Mage.Frost.RadiantSpark then
        return BaseCheck and not Player:IsCasting(self)    
      elseif self == Spell.Mage.Frost.ShiftingPower then
        return BaseCheck and not Player:IsCasting(self)    
      elseif self == Spell.Mage.Frost.Deathborne then
        return BaseCheck and not Player:IsCasting(self)
      else
        return BaseCheck
      end
    end
  end
, 64)

local FrostOldSpellCooldownRemains
FrostOldSpellCooldownRemains = EL.AddCoreOverride("Spell.CooldownRemains",
  function (self, BypassRecovery, Offset)
    if self == Spell.Mage.Frost.Blizzard and Player:IsCasting(self) then
      return 8
    elseif self == Spell.Mage.Frost.Ebonbolt and Player:IsCasting(self) then
      return 45
    else
      return FrostOldSpellCooldownRemains(self, BypassRecovery, Offset)
    end
  end
, 64)

local FrostOldPlayerBuffStack
FrostOldPlayerBuffStack = EL.AddCoreOverride("Player.BuffStackP",
  function (self, Spell, AnyCaster, Offset)
    local BaseCheck = Player:BuffStack(Spell)
    if Spell == Spell.Mage.Frost.IciclesBuff then
      return self:IsCasting(Spell.Mage.Frost.GlacialSpike) and 0 or math.min(BaseCheck + (self:IsCasting(Spell.Mage.Frost.Frostbolt) and 1 or 0), 5)
    elseif Spell == Spell.Mage.Frost.GlacialSpikeBuff then
      return self:IsCasting(Spell.Mage.Frost.GlacialSpike) and 0 or BaseCheck
    elseif Spell == Spell.Mage.Frost.WintersReachBuff then
      return self:IsCasting(Spell.Mage.Frost.Flurry) and 0 or BaseCheck
    elseif Spell == Spell.Mage.Frost.FingersofFrostBuff then
      if Spell.Mage.Frost.IceLance:InFlight() then
        if BaseCheck == 0 then
          return 0
        else
          return BaseCheck - 1
        end
      else
        return BaseCheck
      end
    else
      return BaseCheck
    end
  end
, 64)

local FrostOldPlayerBuffUp
FrostOldPlayerBuffUp = EL.AddCoreOverride("Player.BuffUpP",
  function (self, Spell, AnyCaster, Offset)
    local BaseCheck = Player:BuffUp(Spell)
    if Spell == Spell.Mage.Frost.FingersofFrostBuff then
      if Spell.Mage.Frost.IceLance:InFlight() then
        return Player:BuffStack(Spell) >= 1
      else
        return BaseCheck
      end
    else
      return BaseCheck
    end
  end
, 64)

local FrostOldPlayerBuffDown
FrostOldPlayerBuffDown = EL.AddCoreOverride("Player.BuffDownP",
  function (self, Spell, AnyCaster, Offset)
    local BaseCheck = Player:BuffDown(Spell)
    if Spell == Spell.Mage.Frost.FingersofFrostBuff then
      if Spell.Mage.Frost.IceLance:InFlight() then
        return Player:BuffStack(Spell) == 0
      else
        return BaseCheck
      end
    else
      return BaseCheck
    end
  end
, 64)

local FrostOldTargetDebuffStack
FrostOldTargetDebuffStack = EL.AddCoreOverride("Target.DebuffStack",
  function (self, Spell, AnyCaster, Offset)
    local BaseCheck = FrostOldTargetDebuffStack(self, Spell, AnyCaster, Offset)
    if Spell == Spell.Mage.Frost.WintersChillDebuff then
      if Spell.Mage.Frost.Flurry:InFlight() then
        return 2
      elseif Spell.Mage.Frost.IceLance:InFlight() then
        if BaseCheck == 0 then
          return 0
        else
          return BaseCheck - 1
        end
      else
        return BaseCheck
      end
    else
      return BaseCheck
    end
  end
, 64)

local FrostOldTargetDebuffRemains
FrostOldTargetDebuffRemains = EL.AddCoreOverride("Target.DebuffRemains",
  function (self, Spell, AnyCaster, Offset)
    local BaseCheck = FrostOldTargetDebuffRemains(self, Spell, AnyCaster, Offset)
    if Spell == Spell.Mage.Frost.WintersChillDebuff then
      return Spell.Mage.Frost.Flurry:InFlight() and 6 or BaseCheck
    else
      return BaseCheck
    end
  end
, 64)

local FrostOldPlayerAffectingCombat
FrostOldPlayerAffectingCombat = EL.AddCoreOverride("Player.AffectingCombat",
  function (self)
    return Spell.Mage.Frost.Frostbolt:InFlight() or FrostOldPlayerAffectingCombat(self)
  end
, 64)
