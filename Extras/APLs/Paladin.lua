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
-- Spells
if not Spell.Paladin then Spell.Paladin = {} end
Spell.Paladin.Commons = {
  -- Racials
  AncestralCall                         = Spell(274738, nil, 1),
  ArcanePulse                           = Spell(260364, nil, 2),
  ArcaneTorrent                         = Spell(50613, nil, 3),
  BagofTricks                           = Spell(312411, nil, 4),
  Berserking                            = Spell(26297, nil, 5),
  BloodFury                             = Spell(20572, nil, 6),
  Fireblood                             = Spell(265221, nil, 7),
  GiftoftheNaaru                        = Spell(59542, nil, 8),
  LightsJudgment                        = Spell(255647, nil, 9),
  -- Abilities
  BlessingofFreedom                     = Spell(1044, nil, 10),
  BlessingofProtection                  = Spell(1022, nil, 11),
  BlessingofSacrifice                   = Spell(6940, nil, 150),
  Consecration                          = Spell(26573, nil, 12),
  CrusaderStrike                        = Spell(35395, nil, 13),
  CleanseToxins                         = Spell(213644, nil, 14),
  DivineShield                          = Spell(642, nil, 15),
  DivineSteed                           = Spell(190784, nil, 16),
  Intercession                          = Spell(391054, nil, 17),
  FlashofLight                          = Spell(19750, nil, 18),
  HammerofJustice                       = Spell(853, nil, 19),
  HandofReckoning                       = Spell(62124, nil, 20),
  Judgment                              = Spell(20271, nil, 21),
  Rebuke                                = Spell(96231, nil, 22),
  Redemption                            = Spell(7328, nil, 23),
  ShieldoftheRighteous                  = Spell(53600, nil, 24),
  WordofGlory                           = Spell(85673, nil, 25),
  -- Talents
  AvengingWrath                         = Spell(31884, nil, 26),
  BlindingLight                         = Spell(115750, nil, 27),
  HammerofWrath                         = Spell(24275, nil, 28),
  HolyAvenger                           = Spell(105809, nil, 29),
  LayonHands                            = Spell(633, nil, 30),
  Seraphim                              = Spell(152262, nil, 31),
  ZealotsParagon                        = Spell(391142, nil, 32),
  Repentance                            = Spell(20066, nil, 152),
  TurnEvil                              = Spell(10326, nil, 151),

  -- Auras
  ConcentrationAura                     = Spell(317920, nil, 33),
  CrusaderAura                          = Spell(32223, nil, 34),
  DevotionAura                          = Spell(465, nil, 35),
  RetributionAura                       = Spell(183435, nil, 36),
  -- Buffs
  AvengingWrathBuff                     = Spell(31884, nil, 37),
  BlessingofDuskBuff                    = Spell(385126, nil, 38),
  ConsecrationBuff                      = Spell(188370, nil, 39),
  DivinePurposeBuff                     = Spell(223819, nil, 40),
  HolyAvengerBuff                       = Spell(105809, nil, 41),
  SeraphimBuff                          = Spell(152262, nil, 42),
  ShieldoftheRighteousBuff              = Spell(132403, nil, 43),
  -- Debuffs
  ConsecrationDebuff                    = Spell(204242, nil, 44),
  JudgmentDebuff                        = Spell(197277, nil, 45),
  ForbearanceDebuff                     = Spell(25771, nil, 46),
  Entangled                             = Spell(408556, nil, 148),
  BlackoutBarrelDebuff                  = Spell(258338, nil, 149),
  -- Pool
  Pool                                  = Spell(999910, nil, 47),
}

Spell.Paladin.Protection = MergeTableByKey(Spell.Paladin.Commons, {
  -- Abilities
  Judgment                              = Spell(275779, nil, 48),
  -- Talents
  ArdentDefender                        = Spell(31850, nil, 49),
  AvengersShield                        = Spell(31935, nil, 50),
  BastionofLight                        = Spell(378974, nil, 51),
  BlessedHammer                         = Spell(204019, nil, 52),
  CrusadersJudgment                     = Spell(204023, nil, 53),
  DivineToll                            = Spell(375576, nil, 54),
  EyeofTyr                              = Spell(387174, nil, 55),
  GuardianofAncientKings                = MultiSpell(141, 86659,212641),
  HammeroftheRighteous                  = Spell(53595, nil, 56),
  InmostLight                           = Spell(405757, nil, 57),
  MomentofGlory                         = Spell(327193, nil, 58),
  RighteousProtector                    = Spell(204074, nil, 59),
  Sentinel                              = Spell(389539, nil, 60),
  -- Buffs
  AllyoftheLightBuff                    = Spell(394714, nil, 61),
  ArdentDefenderBuff                    = Spell(31850, nil, 62),
  BastionofLightBuff                    = Spell(378974, nil, 63),
  GuardianofAncientKingsBuff            = MultiSpell(140, 86659,212641),
  MomentofGloryBuff                     = Spell(327193, nil, 64),
  SentinelBuff                          = Spell(389539, nil, 65),
  ShiningLightFreeBuff                  = Spell(327510, nil, 66),
  -- Debuffs
})

Spell.Paladin.Retribution = MergeTableByKey(Spell.Paladin.Commons, {
  -- Abilities
  TemplarsVerdict                       = Spell(85256, nil, 67),
  -- Talents
  AshestoDust                           = Spell(383300, nil, 68),
  BladeofJustice                        = Spell(184575, nil, 69),
  BladeofWrath                          = Spell(231832, nil, 70),
  BlessedChampion                       = Spell(403010, nil, 71),
  BoundlessJudgment                     = Spell(405278, nil, 72),
  Crusade                               = Spell(231895, nil, 73),
  CrusadingStrikes                      = Spell(404542, nil, 74),
  DivineArbiter                         = Spell(404306, nil, 75),
  DivineAuxiliary                       = Spell(406158, nil, 76),
  DivineHammer                          = Spell(198034, nil, 77),
  DivineResonance                       = Spell(384027, nil, 78),
  DivineProtection                      = Spell(403876, nil, 79),
  DivineStorm                           = Spell(53385, nil, 80),
  DivineToll                            = Spell(375576, nil, 81),
  EmpyreanLegacy                        = Spell(387170, nil, 82),
  EmpyreanPower                         = Spell(326732, nil, 83),
  ExecutionSentence                     = Spell(343527, nil, 84),
  ExecutionersWill                      = Spell(406940, nil, 85),
  ExecutionersWrath                     = Spell(387196, nil, 86),
  Exorcism                              = Spell(383185, nil, 87),
  Expurgation                           = Spell(383344, nil, 88),
  FinalReckoning                        = Spell(343721, nil, 89),
  FinalVerdict                          = Spell(383328, nil, 90),
  FiresofJustice                        = Spell(203316, nil, 91),
  HolyBlade                             = Spell(383342, nil, 92),
  Jurisdiction                          = Spell(402971, nil, 93),
  JusticarsVengeance                    = Spell(215661, nil, 94),
  RadiantDecree                         = Spell(383469, nil, 95),
  RadiantDecreeTalent                   = Spell(384052, nil, 96),
  RighteousVerdict                      = Spell(267610, nil, 97),
  ShieldofVengeance                     = Spell(184662, nil, 98),
  TemplarSlash                          = Spell(406647, nil, 99),
  TemplarStrike                         = Spell(407480, nil, 100),
  VanguardsMomentum                     = Spell(383314, nil, 101),
  WakeofAshes                           = Spell(255937, nil, 102),
  Zeal                                  = Spell(269569, nil, 103),
  -- Buffs
  CrusadeBuff                           = Spell(231895, nil, 104),
  DivineArbiterBuff                     = Spell(406975, nil, 105),
  DivineResonanceBuff                   = Spell(384029, nil, 106),
  EmpyreanLegacyBuff                    = Spell(387178, nil, 107),
  EmpyreanPowerBuff                     = Spell(326733, nil, 108),
  -- Debuffs
})

Spell.Paladin.Holy = MergeTableByKey(Spell.Paladin.Commons, {
  -- Abilities
  AuraMastery                           = Spell(31821, nil, 109),
  Absolution                            = Spell(212056, nil, 110),
  BlessingofSummer                      = Spell(388007, nil, 111),
  BlessingofAutumn                      = Spell(388010, nil, 112),
  BlessingofWinter                      = Spell(388011, nil, 113),
  BlessingofSpring                      = Spell(388013, nil, 114),
  BlessingofSacrifice                   = Spell(6940, nil, 115),
  BeaconofVirtue                        = Spell(200025, nil, 116),
  Cleanse                               = Spell(4987, nil, 117),
  DivineFavor                           = Spell(210294, nil, 118),
  DivineProtection                      = Spell(498, nil, 119),
  DivineToll                            = Spell(375576, nil, 120),
  HolyLight                             = Spell(82326, nil, 121),
  HolyShock                             = Spell(20473, nil, 122),
  InfusionofLightBuff                   = Spell(54149, nil, 123),
  LightofDawn                           = Spell(85222, nil, 124),
  LightoftheMartyr                      = Spell(183998, nil, 125),
  Judgment                              = Spell(275773, nil, 126),
  Daybreak                              = Spell(414170, nil, 142),
  HandofDivinity                        = Spell(414273, nil, 143),
  BarrierofFaith                        = Spell(148039, nil, 144),
  TyrsDeliverance                        = Spell(200652, nil, 145),
  BeaconofLight                         = Spell(53563, nil, 146),
  BeaconofFaith                         = Spell(156910, nil, 147),
  -- Talents
  AvengingCrusader                      = Spell(216331, nil, 127),
  Awakening                             = Spell(248033, nil, 128),
  BestowFaith                           = Spell(223306, nil, 129),
  CrusadersMight                        = Spell(196926, nil, 130),
  EmpyreanLegacyBuff                    = Spell(387178, nil, 131),
  GlimmerofLight                        = Spell(325966, nil, 132),
  GlimmerofLightBuff                    = Spell(287280, nil, 133),
  GoldenPath                            = Spell(377128, nil, 134),
  HolyPrism                             = Spell(114165, nil, 135),
  LightsHammer                          = Spell(114158, nil, 136),
  JudgmentofLight                       = Spell(183778, nil, 137),
  JudgmentofLightDebuff                 = Spell(196941, nil, 138),
  UnendingLightBuff                     = Spell(394709, nil, 139),
})

-- Items
if not Item.Paladin then Item.Paladin = {} end
Item.Paladin.Commons = {
  -- Potion
  Healthstone                           = Item(5512),
  ElementalPotionOfPower                = Item(191389),
  RefreshingHealingPotion               = Item(191380), 
  -- Trinkets
  AlgetharPuzzleBox                     = Item(193701, {13, 14}),
  WindscarWhetstone                     = Item(137486, {13, 14}),
}

Item.Paladin.Protection = MergeTableByKey(Item.Paladin.Commons, {
})

Item.Paladin.Retribution = MergeTableByKey(Item.Paladin.Commons, {
})

Item.Paladin.Holy = MergeTableByKey(Item.Paladin.Commons, {
})

-- Macros
if not Macro.Paladin then Macro.Paladin = {} end
Macro.Paladin.Commons = {
  -- Items
  Healthstone                      = Macro(9),
  RefreshingHealingPotion          = Macro(10),
  -- Spells
  BlessingofProtectionMouseover    = Macro(11),
  BlessingofProtectionFocus        = Macro(29),
  BlessingofFreedomMouseover       = Macro(12),
  BlessingofSacrificeFocus         = Macro(30),
  CleanseToxinsFocus               = Macro(28),
  CleanseToxinsMouseover           = Macro(13),
  CrusaderStrikeMouseover          = Macro(14),
  FlashofLightFocus                = Macro(15),
  FlashofLightPlayer               = Macro(16),
  IntercessionMouseover            = Macro(17),
  LayonHandsFocus                  = Macro(18),
  LayonHandsPlayer                 = Macro(19),
  LayonHandsMouseover              = Macro(20),
  JudgmentMouseover                = Macro(21),
  HammerofJusticeMouseover         = Macro(22),
  RebukeMouseover                  = Macro(23),
  RedemptionMouseover              = Macro(33),
  RepentanceMouseOver              = Macro(31),
  TurnEvilMouseOver                = Macro(32),
  WordofGloryFocus                 = Macro(24),
  WordofGloryPlayer                = Macro(25),
  TurnEvilMouseover                = Macro(50),
  RepentanceMouseover              = Macro(49),
}

Macro.Paladin.Protection = MergeTableByKey(Macro.Paladin.Commons, {
})

Macro.Paladin.Retribution = MergeTableByKey(Macro.Paladin.Commons, {
  FinalReckoningPlayer             = Macro(40),
  FinalReckoningCursor             = Macro(41),
})

Macro.Paladin.Holy = MergeTableByKey(Macro.Paladin.Commons, {
  BeaconofVirtueFocus              = Macro(60),
  BlessingofSummerPlayer           = Macro(61),
  BlessingofSummerFocus            = Macro(62),
  BlessingofSacrificeFocus         = Macro(63),
  BlessingofSacrificeMouseover     = Macro(64),
  CleanseFocus                     = Macro(65),
  CleanseMouseover                 = Macro(66),
  DivineTollFocus                  = Macro(67),
  HolyLightFocus                   = Macro(68),
  HolyShockFocus                   = Macro(69),
  HolyShockMouseover               = Macro(70),
  HolyPrismPlayer                  = Macro(71),
  LightoftheMartyrFocus            = Macro(72),
  LightsHammerPlayer               = Macro(73),
  WordofGloryMouseover             = Macro(74),
  LightsHammercursor               = Macro(75),
  HolyLightMouseover               = Macro(76),
  FlashofLightMouseover            = Macro(77),
  BeaconofFaithFocus               = Macro(78),
  BeaconofLightFocus               = Macro(79),
  BeaconofFaithPlayer              = Macro(80),
  BeaconofLightPlayer              = Macro(81),
  BlessingofFreedomPlayer          = Macro(82),
  BlessingofFreedomFocus           = Macro(83),
})

Spell.Paladin.FreedomDebuffList = {
  Spell(408556), --EntanglingDebuff
  Spell(258338), -- Blackout Barrel Freehold
}