local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1289 - (993 + 295))) or ((178 + 3234) <= (3670 - (418 + 753)))) then
			return v6(...);
		end
		if (((859 + 1396) < (467 + 4061)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((356 + 1049) >= (3970 - (406 + 123)))) then
				return v1(v4, ...);
			end
			v5 = 1770 - (1749 + 20);
		end
	end
end
v0["Epix_Warlock_Warlock.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Pet;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Utils.MergeTableByKey;
	local v20 = string.find;
	local v21 = EpicLib;
	local v22 = v21.Macro;
	local v23 = {};
	v10.Commons.Warlock = v23;
	if (((563 + 1806) == (3691 - (1249 + 73))) and not v16.Warlock) then
		v16.Warlock = {};
	end
	v16.Warlock.Commons = {Berserking=v16(9382 + 16915, nil, 1146 - (466 + 679)),AncestralCall=v16(660873 - 386135),BloodFury=v16(96393 - 62691, nil, 1902 - (106 + 1794)),Fireblood=v16(83904 + 181317, nil, 1 + 2),Corruption=v16(507 - 335, nil, 10 - 6),DarkPact=v16(108530 - (4 + 110), nil, 589 - (57 + 527)),ShadowBolt=v16(2113 - (41 + 1386), nil, 109 - (17 + 86)),SummonDarkglare=v16(139257 + 65923, nil, 14 - 7),UnendingResolve=v16(303416 - 198643, nil, 174 - (122 + 44)),GrimoireofSacrifice=v16(187420 - 78917, nil, 29 - 20),GrimoireofSacrificeBuff=v16(159524 + 36575, nil, 2 + 8),SoulConduit=v16(437465 - 221524, nil, 76 - (30 + 35)),SummonSoulkeeper=v16(265478 + 120778, nil, 1269 - (1043 + 214)),InquisitorsGaze=v16(1460634 - 1074290, nil, 1225 - (323 + 889)),InquisitorsGazeBuff=v16(1044540 - 656472, nil, 594 - (361 + 219)),Soulburn=v16(386219 - (53 + 267), nil, 4 + 11),PowerInfusionBuff=v16(10473 - (15 + 398), nil, 998 - (18 + 964)),AxeToss=v16(451370 - 331456, nil, 10 + 7),Seduction=v16(75548 + 44361, nil, 868 - (20 + 830)),ShadowBulwark=v16(93599 + 26308, nil, 145 - (116 + 10)),SingeMagic=v16(8857 + 111048, nil, 758 - (542 + 196)),SpellLock=v16(257052 - 137142, nil, 7 + 14)};
	v16.Warlock.Demonology = v19(v16.Warlock.Commons, {Felstorm=v16(45600 + 44151, nil, 8 + 14),HandofGuldan=v16(277142 - 171968, nil, 58 - 35),ShadowBoltLineCD=v16(2237 - (1126 + 425), nil, 411 - (118 + 287)),SummonPet=v16(118150 - 88004, nil, 1145 - (118 + 1003)),BilescourgeBombers=v16(781974 - 514763, nil, 402 - (142 + 235)),CallDreadstalkers=v16(473231 - 368915, nil, 6 + 20),Demonbolt=v16(265155 - (553 + 424), nil, 50 - 23),DemonicCalling=v16(180716 + 24429, nil, 28 + 0),DemonicStrength=v16(155562 + 111609, nil, 13 + 16),Doom=v16(345 + 258, nil, 65 - 35),FelDomination=v16(930320 - 596431, nil, 69 - 38),FelCovenant=v16(112663 + 274769, nil, 154 - 122),FromtheShadows=v16(267923 - (239 + 514), nil, 12 + 21),GrimoireFelguard=v16(113227 - (797 + 532), nil, 25 + 9),Guillotine=v16(130500 + 256333, nil, 81 - 46),ImpGangBoss=v16(388647 - (373 + 829), nil, 767 - (476 + 255)),Implosion=v16(197407 - (369 + 761), nil, 22 + 15),InnerDemons=v16(485368 - 218152, nil, 71 - 33),NetherPortal=v16(267455 - (64 + 174), nil, 6 + 33),PowerSiphon=v16(391160 - 127030, nil, 376 - (144 + 192)),SacrificedSouls=v16(267430 - (42 + 174), nil, 31 + 10),SoulboundTyrant=v16(277161 + 57424, nil, 18 + 24),SoulStrike=v16(265561 - (363 + 1141), nil, 1623 - (1183 + 397)),SummonDemonicTyrant=v16(807320 - 542133, nil, 33 + 11),SummonVilefiend=v16(197418 + 66701, nil, 2020 - (1913 + 62)),TheExpendables=v16(244103 + 143497, nil, 121 - 75),ReignofTyranny=v16(429617 - (565 + 1368), nil, 496 - 364),GrandWarlocksDesign=v16(388745 - (1477 + 184), nil, 180 - 47),DemonicCallingBuff=v16(191146 + 14000, nil, 903 - (564 + 292)),DemonicCoreBuff=v16(455810 - 191637, nil, 144 - 96),DemonicPowerBuff=v16(265577 - (244 + 60), nil, 38 + 11),FelCovenantBuff=v16(387913 - (41 + 435), nil, 1051 - (938 + 63)),NetherPortalBuff=v16(205512 + 61706, nil, 1176 - (936 + 189)),DoomDebuff=v16(199 + 404, nil, 1665 - (1565 + 48)),FromtheShadowsDebuff=v16(167136 + 103433, nil, 1191 - (782 + 356)),DoomBrandDebuff=v16(423850 - (176 + 91))});
	v16.Warlock.Affliction = v19(v16.Warlock.Commons, {Agony=v16(2553 - 1573, nil, 79 - 25),DrainLife=v16(235245 - (975 + 117), nil, 1930 - (157 + 1718)),SummonPet=v16(559 + 129, nil, 198 - 142),AbsoluteCorruption=v16(670439 - 474336, nil, 1075 - (697 + 321)),DoomBlossom=v16(1061766 - 672002),DrainSoul=v16(420735 - 222145, nil, 133 - 75),DreadTouch=v16(151718 + 238057, nil, 110 - 51),Haunt=v16(129159 - 80978, nil, 1287 - (322 + 905)),InevitableDemise=v16(334930 - (602 + 9), nil, 1250 - (449 + 740)),MaleficAffliction=v16(390633 - (826 + 46), nil, 1009 - (245 + 702)),MaleficRapture=v16(1025520 - 700984, nil, 21 + 42),Nightfall=v16(110456 - (260 + 1638), nil, 504 - (382 + 58)),PhantomSingularity=v16(658228 - 453049, nil, 55 + 10),SowTheSeeds=v16(405539 - 209313, nil, 195 - 129),SeedofCorruption=v16(28448 - (902 + 303), nil, 147 - 80),ShadowEmbrace=v16(65614 - 38371, nil, 6 + 62),SiphonLife=v16(64796 - (1121 + 569), nil, 283 - (22 + 192)),SoulRot=v16(387680 - (483 + 200), nil, 1533 - (1404 + 59)),SoulSwap=v16(1058983 - 672032, nil, 95 - 24),SoulTap=v16(387838 - (468 + 297), nil, 634 - (334 + 228)),SouleatersGluttony=v16(1314217 - 924587, nil, 169 - 96),SowtheSeeds=v16(355883 - 159657, nil, 22 + 52),TormentedCrescendo=v16(387311 - (141 + 95), nil, 74 + 1),UnstableAffliction=v16(813640 - 497541, nil, 182 - 106),VileTaint=v16(65200 + 213150, nil, 210 - 133),InevitableDemiseBuff=v16(235024 + 99296, nil, 41 + 37),NightfallBuff=v16(372580 - 108009, nil, 47 + 32),MaleficAfflictionBuff=v16(390008 - (92 + 71), nil, 40 + 40),TormentedCrescendoBuff=v16(650794 - 263715, nil, 846 - (574 + 191)),UmbrafireKindlingBuff=v16(349549 + 74216),AgonyDebuff=v16(2455 - 1475, nil, 42 + 40),CorruptionDebuff=v16(147588 - (254 + 595), nil, 209 - (55 + 71)),HauntDebuff=v16(63473 - 15292, nil, 1874 - (573 + 1217)),PhantomSingularityDebuff=v16(568227 - 363048, nil, 7 + 78),SeedofCorruptionDebuff=v16(43899 - 16656, nil, 1025 - (714 + 225)),SiphonLifeDebuff=v16(184420 - 121314, nil, 121 - 34),UnstableAfflictionDebuff=v16(34222 + 281877, nil, 127 - 39),VileTaintDebuff=v16(279156 - (118 + 688), nil, 137 - (25 + 23)),SoulRotDebuff=v16(74956 + 312041, nil, 1976 - (927 + 959)),DreadTouchDebuff=v16(1314205 - 924337, nil, 823 - (16 + 716)),ShadowEmbraceDebuff=v16(62525 - 30135, nil, 189 - (11 + 86))});
	v16.Warlock.Destruction = v19(v16.Warlock.Commons, {Immolate=v16(848 - 500, nil, 378 - (175 + 110)),Incinerate=v16(75041 - 45319, nil, 463 - 369),SummonPet=v16(2484 - (503 + 1293), nil, 265 - 170),AshenRemains=v16(280047 + 107205, nil, 1157 - (810 + 251)),AvatarofDestruction=v16(268680 + 118479, nil, 30 + 67),Backdraft=v16(177051 + 19355, nil, 631 - (43 + 490)),BurntoAshes=v16(387886 - (711 + 22), nil, 382 - 283),Cataclysm=v16(152967 - (240 + 619), nil, 25 + 75),ChannelDemonfire=v16(312488 - 116041, nil, 7 + 94),ChaosBolt=v16(118602 - (1344 + 400), nil, 507 - (255 + 150)),ChaosIncarnate=v16(305048 + 82227),Chaosbringer=v16(225959 + 196098),Conflagrate=v16(76743 - 58781, nil, 332 - 229),CrashingChaos=v16(418973 - (404 + 1335)),CryHavoc=v16(387928 - (183 + 223), nil, 125 - 21),DiabolicEmbers=v16(256536 + 130637, nil, 38 + 67),DimensionalRift=v16(388313 - (10 + 327), nil, 74 + 32),Eradication=v16(196750 - (118 + 220), nil, 36 + 71),FireandBrimstone=v16(196857 - (108 + 341), nil, 49 + 59),Havoc=v16(339239 - 258999, nil, 1602 - (711 + 782)),Inferno=v16(518643 - 248098, nil, 579 - (270 + 199)),InternalCombustion=v16(86278 + 179856, nil, 1930 - (580 + 1239)),MadnessoftheAzjAqir=v16(1151657 - 764257, nil, 108 + 4),Mayhem=v16(13921 + 373585, nil, 50 + 63),RagingDemonfire=v16(1010879 - 623713, nil, 71 + 43),RainofChaos=v16(267253 - (645 + 522), nil, 1905 - (1010 + 780)),RainofFire=v16(5738 + 2, nil, 552 - 436),RoaringBlaze=v16(601282 - 396098, nil, 1953 - (1045 + 791)),Ruin=v16(979868 - 592765, nil, 179 - 61),SoulFire=v16(6858 - (351 + 154), nil, 1693 - (1281 + 293)),SummonInfernal=v16(1388 - (28 + 238), nil, 268 - 148),BackdraftBuff=v16(119387 - (1381 + 178), nil, 114 + 7),MadnessCBBuff=v16(312384 + 75025, nil, 53 + 69),MadnessRoFBuff=v16(1335574 - 948161),MadnessSBBuff=v16(200706 + 186708),RainofChaosBuff=v16(266557 - (381 + 89), nil, 110 + 13),RitualofRuinBuff=v16(261830 + 125327, nil, 211 - 87),BurntoAshesBuff=v16(388310 - (1074 + 82), nil, 273 - 148),EradicationDebuff=v16(198198 - (214 + 1570), nil, 1581 - (990 + 465)),ConflagrateDebuff=v16(109628 + 156303),HavocDebuff=v16(34915 + 45325, nil, 124 + 3),ImmolateDebuff=v16(620774 - 463038, nil, 1854 - (1668 + 58)),PyrogenicsDebuff=v16(387722 - (512 + 114)),RoaringBlazeDebuff=v16(693320 - 427389, nil, 266 - 137)});
	if (((14249 - 10154) >= (1481 + 1702)) and not v18.Warlock) then
		v18.Warlock = {};
	end
	v18.Warlock.Commons = {Healthstone=v18(4 + 17),ConjuredChillglobe=v18(168912 + 25388, {(2007 - (109 + 1885)),(26 - 12)}),DesperateInvokersCodex=v18(195125 - (98 + 717), {(22 - 9),(3 + 11)}),TimebreachingTalon=v18(148894 + 44897, {(3 + 10),(46 - 32)}),TimeThiefsGambit=v18(74245 + 133334, {(11 + 2),(7 + 7)}),BelorrelostheSuncaller=v18(208605 - (797 + 636), {(1632 - (1427 + 192)),(32 - 18)}),Iridal=v18(187253 + 21068, {(342 - (192 + 134))})};
	v18.Warlock.Affliction = v19(v18.Warlock.Commons, {});
	v18.Warlock.Demonology = v19(v18.Warlock.Commons, {});
	v18.Warlock.Destruction = v19(v18.Warlock.Commons, {});
	if (not v22.Warlock or ((4987 - (316 + 960)) < (561 + 447))) then
		v22.Warlock = {};
	end
	v22.Warlock.Commons = {Healthstone=v22(17 + 4),ConjuredChillglobe=v22(21 + 1),DesperateInvokersCodex=v22(87 - 64),TimebreachingTalon=v22(575 - (83 + 468)),AxeTossMouseover=v22(1830 - (1202 + 604)),CorruptionMouseover=v22(116 - 91),SpellLockMouseover=v22(42 - 16),ShadowBoltPetAttack=v22(74 - 47),IridialStaff=v22(365 - (45 + 280))};
	v22.Warlock.Affliction = v19(v22.Warlock.Commons, {AgonyMouseover=v22(28 + 0),VileTaintCursor=v22(26 + 3)});
	v22.Warlock.Demonology = v19(v22.Warlock.Commons, {DemonboltPetAttack=v22(11 + 19),DoomMouseover=v22(18 + 13),GuillotineCursor=v22(6 + 26)});
	v22.Warlock.Destruction = v19(v22.Warlock.Commons, {HavocMouseover=v22(60 - 27),ImmolateMouseover=v22(1945 - (340 + 1571)),ImmolatePetAttack=v22(14 + 21),RainofFireCursor=v22(1808 - (1733 + 39)),SummonInfernalCursor=v22(101 - 64)});
	v10.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v10.GuardiansTable = {Pets={},ImpCount=(1034 - (125 + 909)),FelguardDuration=(1948 - (1096 + 852)),DreadstalkerDuration=(0 + 0),DemonicTyrantDuration=(0 - 0),VilefiendDuration=(0 + 0),PitLordDuration=(512 - (409 + 103)),Infernal=(236 - (46 + 190)),Blasphemy=(95 - (51 + 44)),DarkglareDuration=(0 + 0),InnerDemonsNextCast=(1317 - (1114 + 203)),ImpsSpawnedFromHoG=(726 - (228 + 498))};
	local v39 = {[21240 + 76795]={name="Dreadstalker",duration=(7.25 + 5)},[56322 - (174 + 489)]={name="Wild Imp",duration=(52 - 32)},[145527 - (830 + 1075)]={name="Wild Imp",duration=(544 - (303 + 221))},[18521 - (231 + 1038)]={name="Felguard",duration=(15 + 2)},[136164 - (171 + 991)]={name="Demonic Tyrant",duration=(61 - 46)},[364693 - 228877]={name="Vilefiend",duration=(37 - 22)},[156957 + 39154]={name="Pit Lord",duration=(35 - 25)},[256 - 167]={name="Infernal",duration=(48 - 18)},[573692 - 388108]={name="Blasphemy",duration=(1256 - (111 + 1137))},[103831 - (91 + 67)]={name="Darkglare",duration=(74 - 49)}};
	v10:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(2 + 6, ...);
		if ((SpellID == (158259 - (423 + 100))) or ((8 + 1041) <= (2508 - 1602))) then
			v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 0 + 0;
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v10:RegisterForSelfCombatEvent(function(...)
		local v44 = 771 - (326 + 445);
		while true do
			if (((19694 - 15181) > (6072 - 3346)) and (v44 == (0 - 0))) then
				DestGUID, _, _, _, SpellID = select(719 - (530 + 181), ...);
				if ((SpellID == (158617 - (614 + 267))) or ((1513 - (19 + 13)) >= (4325 - 1667))) then
					if (v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((7503 - 4283) == (3896 - 2532))) then
						v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED");
	v10:RegisterForCombatEvent(function(...)
		local v45 = 0 + 0;
		while true do
			if ((v45 == (0 - 0)) or ((2185 - 1131) > (5204 - (1293 + 519)))) then
				DestGUID = select(16 - 8, ...);
				if (v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((1764 - 1088) >= (3139 - 1497))) then
					v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
				end
				break;
			end
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v10:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(34 - 26, ...);
		if (((9743 - 5607) > (1270 + 1127)) and (SpellID == (3665 + 14297))) then
			if (v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((10069 - 5735) == (981 + 3264))) then
				v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + 1 + 0;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v23.UpdatePetTable = function()
		for v67, v68 in pairs(v10.GuardiansTable.Pets) do
			local v69 = 0 + 0;
			while true do
				if ((v69 == (1097 - (709 + 387))) or ((6134 - (673 + 1185)) <= (8790 - 5759))) then
					if ((GetTime() <= v68.despawnTime) or ((15355 - 10573) <= (1972 - 773))) then
						v68.Duration = v68.despawnTime - GetTime();
						if ((v68.name == "Felguard") or ((3480 + 1384) < (1422 + 480))) then
							v10.GuardiansTable.FelguardDuration = v68.Duration;
						elseif (((6532 - 1693) >= (909 + 2791)) and (v68.name == "Dreadstalker")) then
							v10.GuardiansTable.DreadstalkerDuration = v68.Duration;
						elseif ((v68.name == "Demonic Tyrant") or ((2143 - 1068) > (3764 - 1846))) then
							v10.GuardiansTable.DemonicTyrantDuration = v68.Duration;
						elseif (((2276 - (446 + 1434)) <= (5087 - (1040 + 243))) and (v68.name == "Vilefiend")) then
							v10.GuardiansTable.VilefiendDuration = v68.Duration;
						elseif ((v68.name == "Pit Lord") or ((12442 - 8273) == (4034 - (559 + 1288)))) then
							v10.GuardiansTable.PitLordDuration = v68.Duration;
						elseif (((3337 - (609 + 1322)) == (1860 - (13 + 441))) and (v68.name == "Infernal")) then
							v10.GuardiansTable.InfernalDuration = v68.Duration;
						elseif (((5720 - 4189) < (11187 - 6916)) and (v68.name == "Blasphy")) then
							v10.GuardiansTable.BlasphemyDuration = v68.Duration;
						elseif (((3162 - 2527) == (24 + 611)) and (v68.name == "Darkglare")) then
							v10.GuardiansTable.DarkglareDuration = v68.Duration;
						end
					end
					break;
				end
				if (((12250 - 8877) <= (1264 + 2292)) and (v69 == (0 + 0))) then
					if (v68 or ((9766 - 6475) < (1795 + 1485))) then
						if (((8066 - 3680) >= (578 + 295)) and (GetTime() >= v68.despawnTime)) then
							local v94 = 0 + 0;
							while true do
								if (((662 + 259) <= (926 + 176)) and (v94 == (0 + 0))) then
									if (((5139 - (153 + 280)) >= (2780 - 1817)) and (v68.name == "Wild Imp")) then
										v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (1 + 0);
									end
									if ((v68.name == "Felguard") or ((380 + 580) <= (459 + 417))) then
										v10.GuardiansTable.FelguardDuration = 0 + 0;
									elseif ((v68.name == "Dreadstalker") or ((1498 + 568) == (1418 - 486))) then
										v10.GuardiansTable.DreadstalkerDuration = 0 + 0;
									elseif (((5492 - (89 + 578)) < (3460 + 1383)) and (v68.name == "Demonic Tyrant")) then
										v10.GuardiansTable.DemonicTyrantDuration = 0 - 0;
									elseif ((v68.name == "Vilefiend") or ((4926 - (572 + 477)) >= (612 + 3925))) then
										v10.GuardiansTable.VilefiendDuration = 0 + 0;
									elseif ((v68.name == "Pit Lord") or ((516 + 3799) < (1812 - (84 + 2)))) then
										v10.GuardiansTable.PitLordDuration = 0 - 0;
									elseif ((v68.name == "Infernal") or ((2651 + 1028) < (1467 - (497 + 345)))) then
										v10.GuardiansTable.InfernalDuration = 0 + 0;
									elseif ((v68.name == "Blasphemy") or ((782 + 3843) < (1965 - (605 + 728)))) then
										v10.GuardiansTable.BlasphemyDuration = 0 + 0;
									elseif ((v68.name == "Darkglare") or ((184 - 101) > (82 + 1698))) then
										v10.GuardiansTable.DarkglareDuration = 0 - 0;
									end
									v94 = 1 + 0;
								end
								if (((1512 - 966) <= (814 + 263)) and (v94 == (490 - (457 + 32)))) then
									v10.GuardiansTable.Pets[v67] = nil;
									break;
								end
							end
						end
					end
					if ((v68.ImpCasts <= (0 + 0)) or ((2398 - (832 + 570)) > (4052 + 249))) then
						local v84 = 0 + 0;
						while true do
							if (((14402 - 10332) > (331 + 356)) and (v84 == (796 - (588 + 208)))) then
								v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (2 - 1);
								v10.GuardiansTable.Pets[v67] = nil;
								break;
							end
						end
					end
					v69 = 1801 - (884 + 916);
				end
			end
		end
	end;
	v10:RegisterForSelfCombatEvent(function(...)
		local v46 = 0 - 0;
		local v47;
		local v48;
		local v49;
		local v50;
		local v51;
		local v52;
		local v53;
		while true do
			if ((v46 == (2 + 0)) or ((1309 - (232 + 421)) >= (5219 - (1569 + 320)))) then
				if ((v39[v53] and (v39[v53].name == "Demonic Tyrant")) or ((612 + 1880) <= (64 + 271))) then
					for v85, v86 in pairs(v10.GuardiansTable.Pets) do
						if (((14564 - 10242) >= (3167 - (316 + 289))) and v86 and (v86.name ~= "Demonic Tyrant") and (v86.name ~= "Pit Lord")) then
							local v95 = 0 - 0;
							while true do
								if ((v95 == (0 + 0)) or ((5090 - (666 + 787)) >= (4195 - (360 + 65)))) then
									v86.despawnTime = v86.despawnTime + 15 + 0;
									v86.ImpCasts = v86.ImpCasts + (261 - (79 + 175));
									break;
								end
							end
						end
					end
				end
				if ((v53 == (226467 - 82845)) or ((1857 + 522) > (14032 - 9454))) then
					v10.GuardiansTable.InnerDemonsNextCast = GetTime() + (22 - 10);
				end
				v46 = 902 - (503 + 396);
			end
			if ((v46 == (181 - (92 + 89))) or ((936 - 453) > (382 + 361))) then
				v47, v48, v49, v50, v49, v49, v49, v51, v49, v49, v49, v52 = select(1 + 0, ...);
				v49, v49, v49, v49, v49, v49, v49, v53 = v20(v51, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
				v46 = 3 - 2;
			end
			if (((336 + 2118) > (1317 - 739)) and (v46 == (3 + 0))) then
				if (((445 + 485) < (13577 - 9119)) and (v53 == (6947 + 48712)) and (v10.GuardiansTable.ImpsSpawnedFromHoG > (0 - 0))) then
					v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG - (1245 - (485 + 759));
				end
				v23.UpdatePetTable();
				break;
			end
			if (((1531 - 869) <= (2161 - (442 + 747))) and ((1136 - (832 + 303)) == v46)) then
				v53 = tonumber(v53);
				if (((5316 - (88 + 858)) == (1332 + 3038)) and (v51 ~= UnitGUID("pet")) and (v48 == "SPELL_SUMMON") and v39[v53]) then
					local v77 = 0 + 0;
					local v78;
					local v79;
					local v80;
					while true do
						if (((1 + 0) == v77) or ((5551 - (766 + 23)) <= (4250 - 3389))) then
							if ((v78.name == "Wild Imp") or ((1930 - 518) == (11234 - 6970))) then
								v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount + (3 - 2);
								v79 = v78.duration;
							elseif ((v78.name == "Felguard") or ((4241 - (1036 + 37)) < (1527 + 626))) then
								local v110 = 0 - 0;
								while true do
									if ((v110 == (0 + 0)) or ((6456 - (641 + 839)) < (2245 - (910 + 3)))) then
										v10.GuardiansTable.FelguardDuration = v78.duration;
										v79 = v78.duration;
										break;
									end
								end
							elseif (((11797 - 7169) == (6312 - (1466 + 218))) and (v78.name == "Dreadstalker")) then
								local v115 = 0 + 0;
								while true do
									if (((1148 - (556 + 592)) == v115) or ((20 + 34) == (1203 - (329 + 479)))) then
										v10.GuardiansTable.DreadstalkerDuration = v78.duration;
										v79 = v78.duration;
										break;
									end
								end
							elseif (((936 - (174 + 680)) == (281 - 199)) and (v78.name == "Demonic Tyrant")) then
								if ((v52 == (549662 - 284475)) or ((415 + 166) < (1021 - (396 + 343)))) then
									v10.GuardiansTable.DemonicTyrantDuration = v78.duration;
									v79 = v78.duration;
								end
							elseif ((v78.name == "Vilefiend") or ((408 + 4201) < (3972 - (29 + 1448)))) then
								local v128 = 1389 - (135 + 1254);
								while true do
									if (((4339 - 3187) == (5378 - 4226)) and (v128 == (0 + 0))) then
										v10.GuardiansTable.VilefiendDuration = v78.duration;
										v79 = v78.duration;
										break;
									end
								end
							elseif (((3423 - (389 + 1138)) <= (3996 - (102 + 472))) and (v78.name == "Pit Lord")) then
								local v132 = 0 + 0;
								while true do
									if (((0 + 0) == v132) or ((924 + 66) > (3165 - (320 + 1225)))) then
										v10.GuardiansTable.PitLordDuration = v78.duration;
										v79 = v78.duration;
										break;
									end
								end
							elseif ((v78.name == "Infernal") or ((1560 - 683) > (2873 + 1822))) then
								local v138 = 1464 - (157 + 1307);
								while true do
									if (((4550 - (821 + 1038)) >= (4618 - 2767)) and (v138 == (0 + 0))) then
										v10.GuardiansTable.InfernalDuration = v78.duration;
										v79 = v78.duration;
										break;
									end
								end
							elseif ((v78.name == "Blasphemy") or ((5301 - 2316) >= (1807 + 3049))) then
								local v142 = 0 - 0;
								while true do
									if (((5302 - (834 + 192)) >= (76 + 1119)) and (v142 == (0 + 0))) then
										v10.GuardiansTable.BlasphemyDuration = v78.duration;
										v79 = v78.duration;
										break;
									end
								end
							elseif (((70 + 3162) <= (7265 - 2575)) and (v78.name == "Darkglare")) then
								local v146 = 304 - (300 + 4);
								while true do
									if (((0 + 0) == v146) or ((2345 - 1449) >= (3508 - (112 + 250)))) then
										v10.GuardiansTable.DarkglareDuration = v78.duration;
										v79 = v78.duration;
										break;
									end
								end
							end
							v80 = {ID=v51,name=v78.name,spawnTime=GetTime(),ImpCasts=(2 + 3),Duration=v79,despawnTime=(GetTime() + tonumber(v79))};
							v77 = 4 - 2;
						end
						if (((1754 + 1307) >= (1530 + 1428)) and (v77 == (2 + 0))) then
							table.insert(v10.GuardiansTable.Pets, v80);
							break;
						end
						if (((1581 + 1606) >= (479 + 165)) and (v77 == (1414 - (1001 + 413)))) then
							v78 = v39[v53];
							v79 = nil;
							v77 = 2 - 1;
						end
					end
				end
				v46 = 884 - (244 + 638);
			end
		end
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v10:RegisterForCombatEvent(function(...)
		local v54 = 693 - (627 + 66);
		local v55;
		local v56;
		local v57;
		local v58;
		while true do
			if (((1918 - 1274) <= (1306 - (512 + 90))) and (v54 == (1907 - (1665 + 241)))) then
				if (((1675 - (373 + 344)) > (428 + 519)) and (v55 == v13:GUID()) and (v58 == (51934 + 144343))) then
					for v87, v88 in pairs(v10.GuardiansTable.Pets) do
						if (((11848 - 7356) >= (4491 - 1837)) and (v88.name == "Wild Imp")) then
							v10.GuardiansTable.Pets[v87] = nil;
						end
					end
					v10.GuardiansTable.ImpCount = 1099 - (35 + 1064);
				end
				v23.UpdatePetTable();
				break;
			end
			if (((2505 + 937) >= (3215 - 1712)) and (v54 == (0 + 0))) then
				v55, v56, v56, v56, v57, v56, v56, v56, v58 = select(1240 - (298 + 938), ...);
				if ((v58 == (105577 - (233 + 1026))) or ((4836 - (636 + 1030)) <= (749 + 715))) then
					for v89, v90 in pairs(v10.GuardiansTable.Pets) do
						if ((v55 == v90.ID) or ((4686 + 111) == (1304 + 3084))) then
							v90.ImpCasts = v90.ImpCasts - (1 + 0);
						end
					end
				end
				v54 = 222 - (55 + 166);
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v23.LastPI = 0 + 0;
	v10:RegisterForCombatEvent(function(...)
		local v59 = 0 + 0;
		while true do
			if (((2104 - 1553) <= (978 - (36 + 261))) and (v59 == (0 - 0))) then
				DestGUID, _, _, _, SpellID = select(1376 - (34 + 1334), ...);
				if (((1260 + 2017) > (317 + 90)) and (SpellID == (11343 - (1035 + 248))) and (DestGUID == v13:GUID())) then
					v23.LastPI = GetTime();
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v23.SoulShards = 21 - (20 + 1);
	v23.UpdateSoulShards = function()
		v23.SoulShards = v13:SoulShards();
	end;
	v10:RegisterForSelfCombatEvent(function(v61, v62, v61, v61, v61, v61, v61, v61, v61, v61, v61, v63)
		if (((2447 + 2248) >= (1734 - (134 + 185))) and (v63 == (106307 - (549 + 584)))) then
			v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG + (((v23.SoulShards >= (688 - (314 + 371))) and (10 - 7)) or v23.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Warlock_Warlock.lua"]();

