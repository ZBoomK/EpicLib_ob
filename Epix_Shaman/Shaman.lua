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
if not Spell.Shaman then Spell.Shaman = {} end
Spell.Shaman.Commons = {
  -- Racialstest
  AncestralCall                         = Spell(274738, nil, 1),
  BagofTricks                           = Spell(312411, nil, 2),
  Berserking                            = Spell(26297, nil, 3),
  BloodFury                             = Spell(33697, nil, 4),
  Fireblood                             = Spell(265221, nil, 5),
  -- Abilities
  AncestralSpirit                       = Spell(2008, nil, 6),
  AncestralGuidance                     = Spell(108281, nil, 202),
  Bloodlust                             = Spell(2825, nil, 7), 
  FlameShock                            = Spell(188389, nil, 8),
  FlamentongueWeapon                    = Spell(318038, nil, 9),
  FrostShock                            = Spell(196840, nil, 10),
  HealingSurge                          = Spell(8004, nil, 201),
  HealingStreamTotem                    = Spell(5394, nil, 203),
  Heroism                               = Spell(32182, nil, 200), 
  LightningBolt                         = Spell(188196, nil, 11),
  LightningShield                       = Spell(192106, nil, 12),
  Purge                                 = Spell(254411, nil, 13),
  GreaterPurge                          = Spell(378773, nil, 14),
  -- Talents
  AstralShift                           = Spell(108271, nil, 15),
  CapacitorTotem                        = Spell(192058, nil, 16),
  ChainLightning                        = Spell(188443, nil, 17),
  CleanseSpirit                         = Spell(51886, nil, 18),
  DeeplyRootedElements                  = Spell(378270, nil, 19),
  EarthElemental                        = Spell(198103, nil, 20),
  EarthShield                           = Spell(974, nil, 21),
  ElementalBlast                        = Spell(117014, nil, 22),
  ElementalOrbit                        = Spell(383010, nil, 205),
  Hex                                   = Spell(51514, nil, 23),
  LavaBurst                             = Spell(51505, nil, 24),
  NaturesSwiftness                      = Spell(378081, nil, 25),
  PoisonCleansingTotem                  = Spell(383013, nil, 26),
  PrimordialWave                        = Spell(375982, nil, 27),
  SpiritwalkersGrace                    = Spell(79206, nil, 28),
  Thundershock                          = Spell(378779, nil, 29),
  Thunderstorm                          = Spell(51490, nil, 30),
  TremorTotem                           = Spell(8143, nil, 31),
  TotemicRecall                         = Spell(108285, nil, 32),
  WindShear                             = Spell(57994, nil, 33),
  ImprovedPurifySpirit                  = Spell(383016, nil, 152),
  -- Buffs
  EarthShieldBuff                       = Spell(383648, nil, 206),
  LightningShieldBuff                   = Spell(192106, nil, 34),
  PrimordialWaveBuff                    = Spell(375986, nil, 35),
  SpiritwalkersGraceBuff                = Spell(79206, nil, 36),
  SplinteredElementsBuff                = Spell(382043, nil, 37),
  -- Debuffs
  FlameShockDebuff                      = Spell(188389, nil, 38),
  -- Trinket Effects
  AcquiredSwordBuff                     = Spell(368657, nil, 39),
  ScarsofFraternalStrifeBuff4           = Spell(368638, nil, 40),
  -- Misc
  Pool                                  = Spell(999910, nil, 41),
}

Spell.Shaman.Elemental = MergeTableByKey(Spell.Shaman.Commons, {
  -- Abilities
  EarthShock                            = Spell(8042, nil, 85),
  Earthquake                            = Spell(61882, nil, 86),
  FireElemental                         = Spell(198067, nil, 87),
  -- Talents
  Aftershock                            = Spell(273221, nil, 88),
  Ascendance                            = Spell(114050, nil, 89),
  EarthenRage                           = Spell(170374, nil, 90),
  EchooftheElements                     = Spell(333919, nil, 91),
  EchoesofGreatSundering                = Spell(384087, nil, 92),
  EchoingShock                          = Spell(320125, nil, 93),
  EchoingShockBuff                      = Spell(320125, nil, 94),
  ElectrifiedShocks                     = Spell(382086, nil, 95),
  EyeoftheStorm                         = Spell(381708, nil, 96),
  FlowofPower                           = Spell(385923, nil, 97),
  FluxMelting                           = Spell(381776, nil, 98),
  Icefury                               = Spell(210714, nil, 99),
  IcefuryBuff                           = Spell(210714, nil, 100),
  ImprovedFlametongueWeapon             = Spell(382027, nil, 101),
  LavaBeam                              = Spell(114074, nil, 101),
  LavaSurge                             = Spell(77756, nil, 102),
  LightningRod                          = Spell(210689, nil, 103),
  LiquidMagmaTotem                      = Spell(192222, nil, 104),
  MagmaChamber                          = Spell(381932, nil, 105),
  MasteroftheElements                   = Spell(16166, nil, 106),
  MountainsWillFall                     = Spell(381726, nil, 163),
  PrimalElementalist                    = Spell(117013, nil, 107),
  PrimordialSurge                       = Spell(386474, nil, 204),
  SearingFlames                         = Spell(381782, nil, 108),
  SkybreakersFieryDemise                = Spell(378310, nil, 109),
  StaticDischarge                       = Spell(342243, nil, 110),
  StormElemental                        = Spell(192249, nil, 111),
  Stormkeeper                           = Spell(191634, nil, 112),
  StormkeeperBuff                       = Spell(191634, nil, 113),
  SurgeofPower                          = Spell(262303, nil, 114),
  SwellingMaelstrom                     = Spell(384359, nil, 115),
  UnlimitedPower                        = Spell(260895, nil, 116),
  UnrelentingCalamity                   = Spell(382685, nil, 117),
  WindGustBuff                          = Spell(263806, nil, 118),
  -- Pets
  Meteor                                = Spell(117588, "pet", 119),
  CallLightning                         = Spell(157348, "pet", 120),
  CallLightningBuff                     = Spell(157348, "pet", 121),
  Tempest                               = Spell(157375, "pet", 122),
  -- Buffs
  AscendanceBuff                        = Spell(114050, nil, 122),
  EchoesofGreatSunderingBuff            = Spell(384088, nil, 123),
  FluxMeltingBuff                       = Spell(381777, nil, 124),
  LavaSurgeBuff                         = Spell(77762, nil, 125),
  MasteroftheElementsBuff               = Spell(260734, nil, 126),
  PoweroftheMaelstromBuff               = Spell(191877, nil, 127),
  SurgeofPowerBuff                      = Spell(285514, nil, 128),
  WindspeakersLavaResurgenceBuff        = Spell(378269, nil, 129),
  -- Debuffs
  ElectrifiedShocksDebuff               = Spell(382089, nil, 130),
  LightningRodDebuff                    = Spell(197209, nil, 131),
})

Spell.Shaman.Enhancement = MergeTableByKey(Spell.Shaman.Commons, {
  -- Abilities
  Windstrike                            = Spell(115356, nil, 42),
  -- Talents
  AlphaWolf                             = Spell(198434, nil, 162),
  Ascendance                            = Spell(114051, nil, 43),
  AshenCatalyst                         = Spell(390370, nil, 44),
  CrashLightning                        = Spell(187874, nil, 45),
  CrashingStorms                        = Spell(334308, nil, 46),
  DoomWinds                             = Spell(384352, nil, 47),
  ElementalAssault                      = Spell(210853, nil, 161),
  ElementalSpirits                      = Spell(262624, nil, 48),
  FeralSpirit                           = Spell(51533, nil, 49),
  FireNova                              = Spell(333974, nil, 50),
  Hailstorm                             = Spell(334195, nil, 51),
  HotHand                               = Spell(201900, nil, 52),
  IceStrike                             = Spell(342240, nil, 53),
  LashingFlames                         = Spell(334046, nil, 54),
  LavaLash                              = Spell(60103, nil, 55),
  OverflowingMaelstrom                  = Spell(384149, nil, 56),
  StaticAccumulation                    = Spell(384411, nil, 159),
  Stormblast                            = Spell(319930, nil, 160),
  Stormflurry                           = Spell(344357, nil, 57),
  Stormstrike                           = Spell(17364, nil, 58),
  Sundering                             = Spell(197214, nil, 59),
  SwirlingMaelstrom                     = Spell(384359, nil, 60),
  ThorimsInvocation                     = Spell(384444, nil, 61),
  UnrulyWinds                           = Spell(390288, nil, 156),
  WindfuryTotem                         = Spell(8512, nil, 62),
  WindfuryWeapon                        = Spell(33757, nil, 63),
  MoltenAssault							            = Spell(334033, nil, 64),
  ConvergingStorms                      = Spell(384363, nil, 65),
  -- Buffs
  AscendanceBuff                        = Spell(114051, nil, 66),
  AshenCatalystBuff                     = Spell(390371, nil, 67),
  ConvergingStormsBuff                  = Spell(198300, nil, 158),
  CracklingThunderBuff                  = Spell(409834, nil, 154),
  CrashLightningBuff                    = Spell(187878, nil, 68),
  CLCrashLightningBuff                  = Spell(333964, nil, 69),
  DoomWindsBuff                         = Spell(384352, nil, 70),
  FeralSpiritBuff                       = Spell(333957, nil, 71),
  GatheringStormsBuff                   = Spell(198300, nil, 72),
  HailstormBuff                         = Spell(334196, nil, 73),
  HotHandBuff                           = Spell(215785, nil, 74),
  IceStrikeBuff                         = Spell(384357, nil, 155),
  MaelstromWeaponBuff                   = Spell(344179, nil, 75),
  StormbringerBuff                      = Spell(201846, nil, 76),
  WindfuryTotemBuff                     = Spell(327942, nil, 77),
  -- Debuffs
  LashingFlamesDebuff                   = Spell(334168, nil, 78),
  -- Elemental Spirits Buffs
  CracklingSurgeBuff                    = Spell(224127, nil, 79),
  EarthenWeaponBuff                     = Spell(392375, nil, 80),
  LegacyoftheFrostWitch                 = Spell(335901, nil, 81),
  IcyEdgeBuff                           = Spell(224126, nil, 82),
  MoltenWeaponBuff                      = Spell(224125, nil, 83),
  -- Tier 29 Buffs
  MaelstromofElementsBuff               = Spell(394677, nil, 84),
})


Spell.Shaman.Restoration = MergeTableByKey(Spell.Shaman.Commons, {
WaterShield                             = Spell(52127, nil, 132),
    AncestralVision                     = Spell(212048, nil, 133),
    Riptide                             = Spell(61295, nil, 134),
    PurifySpirit                        = Spell(77130, nil, 135),
    --HealingSurge                        = Spell(8004, nil, 136),
    HealingWave                         = Spell(77472, nil, 137),
    UnleashLife                         = Spell(73685, nil, 138),
    HealingRain                         = Spell(73920, nil, 139),
    ChainHeal                           = Spell(1064, nil, 140),
    --HealingStreamTotem                  = Spell(5394, nil, 141),
    SpiritLinkTotem                     = Spell(98008, nil, 142),
    HealingTideTotem                    = Spell(108280, nil, 143),
    EarthenWallTotem                    = Spell(198838, nil, 144),
    Downpour                            = Spell(207778, nil, 145),
    AncestralProtectionTotem            = Spell(207399, nil, 146),
    CloudburstTotem                     = Spell(157153, nil, 147),
    Wellspring                          = Spell(197995, nil, 148),
    AncestralGuidance                   = Spell(108281, nil, 149),
    Ascendance                          = Spell(114052, nil, 150),
    ManaTideTotem                       = Spell(16191, nil, 151),
    Stormkeeper                           = Spell(383009, nil, 153),
})

if not Item.Shaman then Item.Shaman = {} end
Item.Shaman.Commons = {
  -- Trinkets
  CacheofAcquiredTreasures              = Item(188265, {13, 14}),
  ScarsofFraternalStrife                = Item(188253, {13, 14}),
  TheFirstSigil                         = Item(188271, {13, 14}),
  Healthstone                           = Item(5512),
  RefreshingHealingPotion               = Item(191380),
  DreamwalkersHealingPotion             = Item(207023),
}
Item.Shaman.Enhancement = MergeTableByKey(Item.Shaman.Commons, {
})

Item.Shaman.Elemental = MergeTableByKey(Item.Shaman.Commons, {
})

Item.Shaman.Restoration = MergeTableByKey(Item.Shaman.Commons, {
})

if not Macro.Shaman then Macro.Shaman = {} end
Macro.Shaman.Commons = {
  Healthstone                           = Macro(9),
  RefreshingHealingPotion               = Macro(10),
  CleanseSpiritFocus                    = Macro(11),
  CleanseSpiritMouseover                = Macro(12),
  CapacitorTotemCursor                  = Macro(13),
  WindShearMouseover                    = Macro(14),
  HexMouseOver                          = Macro(15),
  AncestralSpiritMouseover              = Macro(25),
  PurifyMouseover                       = Macro(16),
  HealingSurgeFocus                     = Macro(43),
  HealingSurgeMouseover                 = Macro(44),
}

Macro.Shaman.Elemental = MergeTableByKey(Macro.Shaman.Commons, {
  EarthquakePlayer                      = Macro(17),
  EarthquakeCursor                      = Macro(18),
  LiquidMagmaTotemPlayer                = Macro(19),
  LiquidMagmaTotemCursor                = Macro(20),
  FireElementalMeteor                   = Macro(21),
  StormElementalTempest                 = Macro(22),
})

Macro.Shaman.Enhancement = MergeTableByKey(Macro.Shaman.Commons, {
  HealingSurgeFocus                     = Macro(23),
  HealingSurgeMouseover                 = Macro(24),
})

Macro.Shaman.Restoration = MergeTableByKey(Macro.Shaman.Commons, {
  EarthShieldFocus                     = Macro(45),
  HealingWaveFocus                      = Macro(26),
  HealingRainPlayer                      = Macro(27),
  HealingRainCursor                      = Macro(28),
  ChainHealFocus                       = Macro(29),
  SpiritLinkTotemPlayer                       = Macro(30),
  SpiritLinkTotemCursor                       = Macro(31),
  EarthenWallTotemPlayer                       = Macro(32),
  EarthenWallTotemCursor                       = Macro(33),
  DownpourPlayer                      = Macro(34),
  DownpourCursor                       = Macro(35),
  AncestralProtectionTotemPlayer                      = Macro(36),
  AncestralProtectionTotemCursor                       = Macro(37),
  PurifySpiritMouseover                     = Macro(38),
  RiptideMouseover                      = Macro(39),
  HealingWaveMouseover                      = Macro(40),
  RiptideFocus                      = Macro(41),
  PrimordialWaveFocus                      = Macro(42),
})

-- Overrides
-- Elemental, ID: 262

-- Enhancement, ID: 263