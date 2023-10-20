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
if not Spell.DemonHunter then Spell.DemonHunter = {} end
Spell.DemonHunter.Commons = {
  -- Racials
  ArcaneTorrent                         = Spell(50613, nil, 1),
  -- Abilities
  Glide                                 = Spell(131347, nil, 2),
  ImmolationAura                        = Spell(258920, nil, 3),
  -- Talents
  ChaosNova                             = Spell(179057, nil, 4),
  ConsumeMagic                          = Spell(278326, nil, 94),
  Darkness                              = Spell(196718, nil, 93),
  Demonic                               = Spell(213410, nil, 5),
  ElysianDecree                         = Spell(390163, nil, 6),
  Felblade                              = Spell(232893, nil, 7),
  FodderToTheFlame                      = Spell(391429, nil, 8),
  Imprison                              = Spell(217832, nil, 9),
  SigilOfFlame                          = MultiSpell(10, 204596, 204513, 389810), -- 204596: Base ID, 204513: Concentrated, 389810: Precise
  TheHunt                               = Spell(370965, nil, 11),
  VengefulRetreat                       = Spell(198793, nil, 50),
  -- Utility
  Disrupt                               = Spell(183752, nil, 12),
  -- Buffs
  ImmolationAuraBuff                    = Spell(258920, nil, 13),
  -- Debuffs
  SigilOfFlameDebuff                    = Spell(204598, nil, 14),
  -- Other
  Pool                                  = Spell(999910, nil, 15),
}

Spell.DemonHunter.Havoc = MergeTableByKey(Spell.DemonHunter.Commons, {
  -- Abilities
  Annihilation                          = Spell(201427, nil, 16),
  BladeDance                            = Spell(188499, nil, 17),
  Blur                                  = Spell(198589, nil, 18),
  ChaosStrike                           = Spell(162794, nil, 19),
  DeathSweep                            = Spell(210152, nil, 20),
  DemonsBite                            = Spell(162243, nil, 21),
  FelRush                               = Spell(195072, nil, 22),
  Metamorphosis                         = Spell(191427, nil, 23),
  ThrowGlaive                           = Spell(185123, nil, 24),
  -- Talents
  BlindFury                             = Spell(203550, nil, 25),
  BurningWound                          = Spell(391189, nil, 26),
  ChaosTheory                           = Spell(389687, nil, 27),
  ChaoticTransformation                 = Spell(388112, nil, 28),
  CycleofHatred                         = Spell(258887, nil, 29),
  DemonBlades                           = Spell(203555, nil, 30),
  EssenceBreak                          = Spell(258860, nil, 31),
  EyeBeam                               = Spell(198013, nil, 32),
  FelBarrage                            = Spell(258925, nil, 33),
  FelEruption                           = Spell(211881, nil, 34),
  FirstBlood                            = Spell(206416, nil, 35),
  FuriousGaze                           = Spell(343311, nil, 36),
  FuriousThrows                         = Spell(393029, nil, 37),
  GlaiveTempest                         = Spell(342817, nil, 38),
  Initiative                            = Spell(388108, nil, 39),
  InnerDemon                            = Spell(389693, nil, 40),
  IsolatedPrey                          = Spell(388113, nil, 41),
  Momentum                              = Spell(206476, nil, 42),
  Netherwalk                            = Spell(196555, nil, 95),
  Ragefire                              = Spell(388107, nil, 43),
  SerratedGlaive                        = Spell(390154, nil, 44),
  SigilOfMisery                         = Spell(389813, nil, 45),
  Soulrend                              = Spell(388106, nil, 46),
  TacticalRetreat                       = Spell(389688, nil, 47),
  TrailofRuin                           = Spell(258881, nil, 48),
  UnboundChaos                          = Spell(347461, nil, 49),
  -- Buffs
  ChaosTheoryBuff                       = Spell(390195, nil, 51),
  FuriousGazeBuff                       = Spell(343312, nil, 52),
  InnerDemonBuff                        = Spell(390145, nil, 53),
  MetamorphosisBuff                     = Spell(162264, nil, 54),
  MomentumBuff                          = Spell(208628, nil, 55),
  TacticalRetreatBuff                   = Spell(389890, nil, 56),
  UnboundChaosBuff                      = Spell(347462, nil, 57),
  -- Debuffs
  BurningWoundDebuff                    = Spell(391191, nil, 58),
  EssenceBreakDebuff                    = Spell(320338, nil, 59),
  SerratedGlaiveDebuff                  = Spell(390155, nil, 60),
})

Spell.DemonHunter.Vengeance = MergeTableByKey(Spell.DemonHunter.Commons, {
  -- Abilities
  InfernalStrike                        = Spell(189110, nil, 61),
  Shear                                 = Spell(203782, nil, 62),
  SoulCleave                            = Spell(228477, nil, 63),
  SoulFragments                         = Spell(203981, nil, 64),
  ThrowGlaive                           = Spell(204157, nil, 65),
  -- Defensive
  DemonSpikes                           = Spell(203720, nil, 66),
  Torment                               = Spell(185245, nil, 67),
  -- Talents
  AgonizingFlames                       = Spell(207548, nil, 68),
  BulkExtraction                        = Spell(320341, nil, 69),
  BurningAlive                          = Spell(207739, nil, 70),
  CharredFlesh                          = Spell(336639, nil, 71),
  ConcentratedSigils                    = Spell(207666, nil, 72),
  DarkglareBoon                         = Spell(389708, nil, 73),
  DowninFlames                          = Spell(389732, nil, 74),
  Fallout                               = Spell(227174, nil, 75),
  FelDevastation                        = Spell(212084, nil, 76),
  FieryBrand                            = Spell(204021, nil, 77),
  FieryDemise                           = Spell(389220, nil, 78),
  Frailty                               = Spell(389958, nil, 79),
  Fracture                              = Spell(263642, nil, 80),
  SigilOfChains                         = Spell(202138, nil, 92),
  SigilOfSilence                        = Spell(202137, nil, 81),
  SoulBarrier                           = Spell(263648, nil, 82),
  SoulCarver                            = Spell(207407, nil, 83),
  SoulCrush                             = Spell(389985, nil, 84),
  SpiritBomb                            = Spell(247454, nil, 85),
  Vulnerability                         = Spell(389976, nil, 86),
  -- Utility
  Metamorphosis                         = Spell(187827, nil, 87),
  -- Buffs
  DemonSpikesBuff                       = Spell(203819, nil, 88),
  MetamorphosisBuff                     = Spell(187827, nil, 89),
  -- Debuffs
  FieryBrandDebuff                      = Spell(207771, nil, 90),
  FrailtyDebuff                         = Spell(247456, nil, 91),
})

-- Items
if not Item.DemonHunter then Item.DemonHunter = {} end
Item.DemonHunter.Commons = {
  Healthstone                           = Item(5512),
  RefreshingHealingPotion               = Item(191380),
}

Item.DemonHunter.Havoc = MergeTableByKey(Item.DemonHunter.Commons, {
})

Item.DemonHunter.Vengeance = MergeTableByKey(Item.DemonHunter.Commons, {
})

-- Macros
if not Macro.DemonHunter then Macro.DemonHunter = {}; end
Macro.DemonHunter.Commons = {
  -- Items
  Healthstone                      = Macro(9),
  RefreshingHealingPotion          = Macro(10),

  -- Spells
  DisruptMouseover                 = Macro(11),
  ImprisonMouseover                = Macro(12),
  SigilOfFlamePlayer               = Macro(13),
  SigilOfFlameCursor               = Macro(14),
  MetamorphosisPlayer              = Macro(17),
}

Macro.DemonHunter.Havoc = MergeTableByKey(Macro.DemonHunter.Commons, {
  SigilOfMiseryPlayer              = Macro(19),
  SigilOfMiseryCursor              = Macro(20),
})

Macro.DemonHunter.Vengeance = MergeTableByKey(Macro.DemonHunter.Commons, {
  SigilOfSilencePlayer             = Macro(15),
  SigilOfSilenceCursor             = Macro(16),
  InfernalStrikePlayer             = Macro(18),
  InfernalStrikeCursor             = Macro(21),
})

