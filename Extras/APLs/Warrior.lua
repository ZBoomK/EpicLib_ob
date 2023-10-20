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

--- ============================ CONTENT ============================

-- Spell
if not Spell.Warrior then Spell.Warrior = {} end
Spell.Warrior.Commons = {
  -- Racials
  AncestralCall                         = Spell(274738, nil, 1),
  ArcaneTorrent                         = Spell(50613, nil, 2),
  BagofTricks                           = Spell(312411, nil, 3),
  Berserking                            = Spell(26297, nil, 4),
  BloodFury                             = Spell(20572, nil, 5),
  Fireblood                             = Spell(265221, nil, 6),
  LightsJudgment                        = Spell(255647, nil, 7),
  WarStomp                              = Spell(20549, nil, 8),
  -- Abilities
  BattleShout                           = Spell(6673, nil, 9),
  Charge                                = Spell(100, nil, 10),
  HeroicThrow                           = Spell(57755, nil, 11),
  IgnorePain                            = Spell(190456, nil, 72),
  Pummel                                = Spell(6552, nil, 12),
  Slam                                  = Spell(1464, nil, 13),
  VictoryRush                           = Spell(34428, nil, 14),
  DefensiveStance                       = Spell(386208, nil, 15),
  -- Talents
  Avatar                                = MultiSpell(16, 107574, 401150),
  AvatarBuff                            = MultiSpell(17, 107574, 401150),
  BerserkerRage                         = Spell(18499, nil, 18),
  BerserkersTorment                     = Spell(390123, nil, 19),
  BitterImmunity                        = Spell(383762, nil, 20),
  BloodandThunder                       = Spell(384277, nil, 21),
  DoubleTime                            = Spell(103827, nil, 22),
  CrushingForce                         = Spell(382764, nil, 23),
  FrothingBerserker                     = Spell(215571, nil, 24),
  ImmovableObject                       = Spell(394307, nil, 25),
  Intervene                             = Spell(3411, nil, 147),
  IntimidatingShout                     = Spell(5246, nil, 26),
  HeroicLeap                            = Spell(6544, nil, 27),
  ImpendingVictory                      = Spell(202168, nil, 28),
  OverwhelmingRage                      = Spell(382767, nil, 29),
  RallyingCry                           = Spell(97462, nil, 30),
  RumblingEarth                         = Spell(275339, nil, 31),
  Shockwave                             = Spell(46968, nil, 32),
  SonicBoom                             = Spell(390725, nil, 33),
  SpearofBastion                        = Spell(376079, nil, 34),
  SpellReflection                       = Spell(23920, nil, 35),
  StormBolt                             = Spell(107570, nil, 36),
  ThunderClap                           = MultiSpell(37, 6343, 396719),
  ThunderousRoar                        = Spell(384318, nil, 38),
  TitanicThrow                          = Spell(384090, nil, 39),
  WarMachineBuff                        = Spell(262232, nil, 40),
  WreckingThrow                         = Spell(384110, nil, 41),
  -- Buffs
  BattleShoutBuff                       = Spell(6673, nil, 42),
  AspectsFavorBuff                      = Spell(407254, nil, 43),
  -- Pool
  Pool                                  = Spell(999910, nil, 44),
}

Spell.Warrior.Arms = MergeTableByKey(Spell.Warrior.Commons, {
  -- Abilities
  BattleStance                          = Spell(386164, nil, 45),
  Execute                               = MultiSpell(46, 163201, 281000),
  Whirlwind                             = Spell(1680, nil, 47),
  -- Talents
  AngerManagement                       = Spell(152278, nil, 48),
  Battlelord                            = Spell(386630, nil, 49),
  BattlelordBuff                        = Spell(386631, nil, 50),
  BlademastersTorment                   = Spell(390138, nil, 60),
  Bladestorm                            = MultiSpell(61, 227847, 389774),
  Cleave                                = Spell(845, nil, 62),
  ColossusSmash                         = MultiSpell(63, 167105, 262161),
  ColossusSmashDebuff                   = Spell(208086, nil, 64),
  DieByTheSword                         = Spell(118038, nil, 65),
  Dreadnaught                           = Spell(262150, nil, 66),
  ExecutionersPrecision                 = Spell(386634, nil, 67),
  ExecutionersPrecisionDebuff           = Spell(386633, nil, 68),
  FervorofBattle                        = Spell(202316, nil, 69),
  Hurricane                             = Spell(390563, nil, 70),
  HurricaneBuff                         = Spell(390581, nil, 71),
  Juggernaut                            = Spell(383292, nil, 73),
  JuggernautBuff                        = Spell(383292, nil, 74),
  MartialProwessBuff                    = Spell(7384, nil, 75),
  Massacre                              = Spell(281001, nil, 76),
  MercilessBonegrinder                  = Spell(383317, nil, 77),
  MercilessBonegrinderBuff              = Spell(383316, nil, 78),
  MortalStrike                          = Spell(12294, nil, 79),
  Overpower                             = Spell(7384, nil, 80),
  Rend                                  = Spell(772, nil, 81),
  RendDebuff                            = Spell(388539, nil, 82),
  Skullsplitter                         = Spell(260643, nil, 83),
  StormofSwords                         = Spell(385512, nil, 84),
  SuddenDeath                           = Spell(29725, nil, 85),
  SuddenDeathBuff                       = Spell(52437, nil, 86),
  SweepingStrikes                       = Spell(260708, nil, 87),
  SweepingStrikesBuff                   = Spell(260708, nil, 88),
  TestofMight                           = Spell(385008, nil, 89),
  TestofMightBuff                       = Spell(385013, nil, 90),
  TideofBlood                           = Spell(386357, nil, 91),
  Unhinged                              = Spell(386628, nil, 92),
  Warbreaker                            = Spell(262161, nil, 93),
  WarlordsTorment                       = Spell(390140, nil, 94),
  -- Buffs/Debuffs
  CrushingAdvanceBuff                   = Spell(410138, nil, 95),
  DeepWoundsDebuff                      = Spell(262115, nil, 96),
})

Spell.Warrior.Fury = MergeTableByKey(Spell.Warrior.Commons, {
  -- Abilities
  BerserkerStance                       = Spell(386196, nil, 97),
  Bloodbath                             = Spell(335096, nil, 98),
  CrushingBlow                          = Spell(335097, nil, 99),
  Execute                               = MultiSpell(100,5308, 280735),
  Whirlwind                             = Spell(190411, nil, 101),
  -- Talents
  AngerManagement                       = Spell(152278, nil, 102),
  Annihilator                           = Spell(383916, nil, 103),
  AshenJuggernaut                       = Spell(392536, nil, 104),
  AshenJuggernautBuff                   = Spell(392537, nil, 105),
  Bloodthirst                           = Spell(23881, nil, 106),
  ColdSteelHotBlood                     = Spell(383959, nil, 107),
  DancingBlades                         = Spell(391683, nil, 108),
  DancingBladesBuff                     = Spell(391688, nil, 109),
  EnragedRegeneration                   = Spell(184364, nil, 110),
  Frenzy                                = Spell(335077, nil, 111),
  FrenzyBuff                            = Spell(335082, nil, 112),
  ImprovedWhilwind                      = Spell(12950, nil, 113),
  MeatCleaver                           = Spell(280392, nil, 114),
  MeatCleaverBuff                       = Spell(85739, nil, 115),
  OdynsFury                             = Spell(385059, nil, 116),
  Onslaught                             = Spell(315720, nil, 117),
  RagingBlow                            = Spell(85288, nil, 118),
  Rampage                               = Spell(184367, nil, 119),
  Ravager                               = Spell(228920, nil, 120),
  RecklessAbandon                       = Spell(396749, nil, 121),
  Recklessness                          = Spell(1719, nil, 122),
  RecklessnessBuff                      = Spell(1719, nil, 123),
  StormofSwords                         = Spell(388903, nil, 124),
  SuddenDeath                           = Spell(280721, nil, 125),
  SuddenDeathBuff                       = Spell(280776, nil, 126),
  Tenderize                             = Spell(388933, nil, 127),
  TitanicRage                           = Spell(394329, nil, 128),
  TitansTorment                         = Spell(390135, nil, 129),
  WrathandFury                          = Spell(392936, nil, 130),
  -- Buffs
  BloodcrazeBuff                        = Spell(393951, nil, 131),
  EnrageBuff                            = Spell(184362, nil, 132),
  MercilessAssaultBuff                  = Spell(409983, nil, 133),
})

Spell.Warrior.Protection = MergeTableByKey(Spell.Warrior.Commons, {
  -- Abilities
  BattleStance                          = Spell(386164, nil, 134),
  Devastate                             = Spell(20243, nil, 135),
  Execute                               = Spell(163201, nil, 136),
  ShieldBlock                           = Spell(2565, nil, 137),
  ShieldSlam                            = Spell(23922, nil, 138),
  -- Talents
  BarbaricTraining                      = Spell(390675, nil, 139),
  Bolster                               = Spell(280001, nil, 140),
  BoomingVoice                          = Spell(202743, nil, 141),
  ChampionsBulwark                      = Spell(386328, nil, 142),
  DemoralizingShout                     = Spell(1160, nil, 143),
  EnduringDefenses                      = Spell(386027, nil, 144),
  HeavyRepercussions                    = Spell(203177, nil, 145),
  ImpenetrableWall                      = Spell(384072, nil, 148),
  Juggernaut                            = Spell(393967, nil, 149),
  LastStand                             = Spell(12975, nil, 150),
  Massacre                              = Spell(281001, nil, 151),
  Ravager                               = Spell(228920, nil, 152),
  Rend                                  = Spell(394062, nil, 153),
  Revenge                               = Spell(6572, nil, 154),
  SeismicReverberation                  = Spell(382956, nil, 155),
  ShieldCharge                          = Spell(385952, nil, 156),
  ShieldWall                            = Spell(871, nil, 157),
  SuddenDeath                           = Spell(29725, nil, 158),
  SuddenDeathBuff                       = Spell(52437, nil, 159),
  UnnervingFocus                        = Spell(384042, nil, 160),  
  UnstoppableForce                      = Spell(275336, nil, 161),
  -- Buffs
  AvatarBuff                            = Spell(401150, nil, 162),
  EarthenTenacityBuff                   = Spell(410218, nil, 163),  -- T30 4P
  LastStandBuff                         = Spell(12975, nil, 164),
  RallyingCryBuff                       = Spell(97463, nil, 165),
  RevengeBuff                           = Spell(5302, nil, 166),
  SeeingRedBuff                         = Spell(386486, nil, 167), 
  ShieldBlockBuff                       = Spell(132404, nil, 168),
  ShieldWallBuff                        = Spell(871, nil, 169),
  ViolentOutburstBuff                   = Spell(386478, nil, 170),  
  VanguardsDeterminationBuff            = Spell(394056, nil, 171), -- T29 2P
  -- Debuffs
  RendDebuff                            = Spell(388539, nil, 172),
})

-- Items
if not Item.Warrior then Item.Warrior = {} end
Item.Warrior.Commons = {
  Healthstone                           = Item(5512),
  RefreshingHealingPotion               = Item(191380),
  -- Trinkets
  AlgetharPuzzleBox                     = Item(193701, {13, 14}),
  ManicGrieftorch                       = Item(194308, {13, 14}),
}

Item.Warrior.Arms = MergeTableByKey(Item.Warrior.Commons, {
})

Item.Warrior.Fury = MergeTableByKey(Item.Warrior.Commons, {
})

Item.Warrior.Protection = MergeTableByKey(Item.Warrior.Commons, {
})

-- Macros
if not Macro.Warrior then Macro.Warrior = {}; end
Macro.Warrior.Commons = {
  -- Items
  Healthstone                             = Macro(9),
  RefreshingHealingPotion                 = Macro(10),
  -- Spells
  InterveneFocus                          = Macro(11),
  PummelMouseover                         = Macro(12),
  StormBoltMouseover                      = Macro(13),
  SpearofBastionPlayer                    = Macro(14),
  SpearofBastionCursor                    = Macro(15),
  IntimidatingShoutMouseover              = Macro(16),
}

Macro.Warrior.Arms = MergeTableByKey(Macro.Warrior.Commons, {
})

Macro.Warrior.Fury = MergeTableByKey(Macro.Warrior.Commons, {
  -- Spells
  RavagerPlayer                           = Macro(17),
  RavagerCursor                           = Macro(18),
})

Macro.Warrior.Protection = MergeTableByKey(Macro.Warrior.Commons, {
  -- Spells
  RavagerPlayer                           = Macro(19),
  RavagerCursor                           = Macro(20),
})

-- Overrides
-- Arms, ID: 71
local ArmsOldSpellIsCastable
ArmsOldSpellIsCastable = EL.AddCoreOverride ("Spell.IsCastable",
  function (self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
    local BaseCheck = ArmsOldSpellIsCastable(self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
    if self == Spell.Warrior.Arms.Charge then
      return BaseCheck and (self:Charges() >= 1 and (Player:AffectingCombat() and (not Target:IsInRange(8)) and Target:IsInRange(25) or not Player:AffectingCombat()))
    else
      return BaseCheck
    end
  end
, 71)

-- Fury, ID: 72
local FuryOldSpellIsCastable
FuryOldSpellIsCastable = EL.AddCoreOverride ("Spell.IsCastable",
  function (self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
    local BaseCheck = FuryOldSpellIsCastable(self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
    if self == Spell.Warrior.Fury.Charge then
      return BaseCheck and (self:Charges() >= 1 and (Player:AffectingCombat() and (not Target:IsInRange(8)) and Target:IsInRange(25) or not Player:AffectingCombat()))
    else
      return BaseCheck
    end
  end
, 72)

local FuryOldSpellIsReady
FuryOldSpellIsReady = EL.AddCoreOverride ("Spell.IsReady",
  function (self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
    local BaseCheck = FuryOldSpellIsReady(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
    if self == Spell.Warrior.Fury.Rampage then
      if Player:PrevGCDP(1, Spell.Warrior.Fury.Bladestorm) then
        return self:IsCastable() and Player:Rage() >= self:Cost()
      else
        return BaseCheck
      end
    else
      return BaseCheck
    end
  end
, 72)

-- Protection, ID: 73
local ProtOldSpellIsCastable
ProtOldSpellIsCastable = EL.AddCoreOverride ("Spell.IsCastable",
  function (self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
    local BaseCheck = ProtOldSpellIsCastable(self, BypassRecovery, Range, AoESpell, ThisUnit, Offset)
    if self == Spell.Warrior.Protection.Charge then
      return BaseCheck and (self:Charges() >= 1 and (not Target:IsInRange(8)))
    elseif self == Spell.Warrior.Protection.HeroicThrow or self == Spell.Warrior.Protection.TitanicThrow then
      return BaseCheck and (not Target:IsInRange(8))
    elseif self == Spell.Warrior.Protection.Avatar then
      return BaseCheck and (Player:BuffDown(Spell.Warrior.Protection.AvatarBuff))
    elseif self == Spell.Warrior.Protection.Intervene then
      return BaseCheck and (Player:IsInParty() or Player:IsInRaid())
    else
      return BaseCheck
    end
  end
, 73)