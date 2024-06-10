local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 120 - (30 + 90);
	local v7;
	while true do
		if (((656 + 2467) < (1565 + 2326)) and (v6 == (0 + 0))) then
			v7 = v1[v5];
			if (((3791 + 151) <= (10479 - 5492)) and not v7) then
				return v2(v5, v0, ...);
			end
			v6 = 1 - 0;
		end
		if (((12858 - 8274) == (2462 + 2122)) and (v6 == (1 + 0))) then
			return v7(v0, ...);
		end
	end
end
v1["Epix_Warlock_Warlock.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v13.Pet;
	local v17 = v11.Spell;
	local v18 = v11.MultiSpell;
	local v19 = v11.Item;
	local v20 = v11.Utils.MergeTableByKey;
	local v21 = string.find;
	local v22 = EpicLib;
	local v23 = v22.Macro;
	local v24 = {};
	v11.Commons.Warlock = v24;
	if (((4375 - (115 + 281)) >= (3879 - 2211)) and not v17.Warlock) then
		v17.Warlock = {};
	end
	v17.Warlock.Commons = {Berserking=v17(21773 + 4524, nil, 2 - 1),AncestralCall=v17(1007409 - 732671),BloodFury=v17(34569 - (550 + 317), nil, 2 - 0),Fireblood=v17(372787 - 107566, nil, 8 - 5),Corruption=v17(457 - (134 + 151), nil, 1669 - (970 + 695)),DarkPact=v17(206883 - 98467, nil, 1995 - (582 + 1408)),ShadowBolt=v17(2378 - 1692, nil, 7 - 1),SummonDarkglare=v17(773191 - 568011, nil, 1831 - (1195 + 629)),UnendingResolve=v17(138561 - 33788, nil, 249 - (187 + 54)),GrimoireofSacrifice=v17(109283 - (162 + 618), nil, 7 + 2),GrimoireofSacrificeBuff=v17(130610 + 65489, nil, 21 - 11),SoulConduit=v17(363037 - 147096, nil, 1 + 10),SummonSoulkeeper=v17(387892 - (1373 + 263), nil, 1012 - (451 + 549)),InquisitorsGaze=v17(121954 + 264390, nil, 19 - 6),InquisitorsGazeBuff=v17(652210 - 264142, nil, 1398 - (746 + 638)),Soulburn=v17(145229 + 240670, nil, 22 - 7),PowerInfusionBuff=v17(10401 - (218 + 123), nil, 1597 - (1535 + 46)),AxeToss=v17(119147 + 767, nil, 3 + 14),Seduction=v17(120469 - (306 + 254), nil, 2 + 16),ShadowBulwark=v17(235322 - 115415, nil, 1486 - (899 + 568)),SingeMagic=v17(78814 + 41091, nil, 48 - 28),SpellLock=v17(120513 - (268 + 335), nil, 311 - (60 + 230)),BurningRush=v17(111972 - (426 + 146), nil, 67 + 488)};
	v17.Warlock.Demonology = v20(v17.Warlock.Commons, {Felstorm=v17(91207 - (282 + 1174), nil, 833 - (569 + 242)),HandofGuldan=v17(302963 - 197789, nil, 2 + 21),ShadowBoltLineCD=v17(1710 - (706 + 318), nil, 1257 - (721 + 530)),SummonPet=v17(31417 - (945 + 326), nil, 59 - 35),BilescourgeBombers=v17(237770 + 29441, nil, 725 - (271 + 429)),CallDreadstalkers=v17(95825 + 8491, nil, 1526 - (1408 + 92)),Demonbolt=v17(265264 - (461 + 625), nil, 1315 - (993 + 295)),DemonicCalling=v17(10653 + 194492, nil, 1199 - (418 + 753)),DemonicStrength=v17(101753 + 165418, nil, 3 + 26),Doom=v17(177 + 426, nil, 8 + 22),FelDomination=v17(334418 - (406 + 123), nil, 1800 - (1749 + 20)),FelCovenant=v17(92026 + 295406, nil, 1354 - (1249 + 73)),FromtheShadows=v17(95318 + 171852, nil, 1178 - (466 + 679)),GrimoireFelguard=v17(269167 - 157269, nil, 97 - 63),Guillotine=v17(388733 - (106 + 1794), nil, 12 + 23),ImpGangBoss=v17(97938 + 289507, nil, 105 - 69),Implosion=v17(531506 - 335229, nil, 151 - (4 + 110)),InnerDemons=v17(267800 - (57 + 527), nil, 1465 - (41 + 1386)),NetherPortal=v17(267320 - (17 + 86), nil, 27 + 12),PowerSiphon=v17(589040 - 324910, nil, 115 - 75),SacrificedSouls=v17(267380 - (122 + 44), nil, 70 - 29),SoulboundTyrant=v17(1109976 - 775391, nil, 35 + 7),SoulStrike=v17(38189 + 225868, nil, 86 - 43),SummonDemonicTyrant=v17(265252 - (30 + 35), nil, 31 + 13),SummonVilefiend=v17(265376 - (1043 + 214), nil, 169 - 124),TheExpendables=v17(388812 - (323 + 889), nil, 123 - 77),ReignofTyranny=v17(428264 - (361 + 219), nil, 452 - (53 + 267)),GrandWarlocksDesign=v17(87451 + 299633, nil, 546 - (15 + 398)),DemonicCallingBuff=v17(206128 - (18 + 964), nil, 176 - 129),DemonicCoreBuff=v17(152947 + 111226, nil, 31 + 17),DemonicPowerBuff=v17(266123 - (20 + 830), nil, 39 + 10),FelCovenantBuff=v17(387563 - (116 + 10), nil, 4 + 46),NetherPortalBuff=v17(267956 - (542 + 196), nil, 109 - 58),DoomDebuff=v17(177 + 426, nil, 27 + 25),FromtheShadowsDebuff=v17(97396 + 173173, nil, 139 - 86),DoomBrandDebuff=v17(1085977 - 662394),DrainLife=v17(235704 - (1126 + 425), nil, 460 - (118 + 287)),DoomBrand=v17(1660149 - 1236565)});
	v17.Warlock.Affliction = v20(v17.Warlock.Commons, {Agony=v17(2101 - (118 + 1003), nil, 157 - 103),DrainLife=v17(234530 - (142 + 235), nil, 249 - 194),SummonPet=v17(150 + 538, nil, 1033 - (553 + 424)),AbsoluteCorruption=v17(370821 - 174718, nil, 51 + 6),DoomBlossom=v17(386639 + 3125),DrainSoul=v17(115631 + 82959, nil, 25 + 33),DreadTouch=v17(222589 + 167186, nil, 127 - 68),Haunt=v17(134247 - 86066, nil, 134 - 74),InevitableDemise=v17(97218 + 237101, nil, 294 - 233),MaleficAffliction=v17(390514 - (239 + 514), nil, 22 + 40),MaleficRapture=v17(325865 - (797 + 532), nil, 46 + 17),Nightfall=v17(36623 + 71935, nil, 150 - 86),PhantomSingularity=v17(206381 - (373 + 829), nil, 796 - (476 + 255)),SowTheSeeds=v17(197356 - (369 + 761), nil, 39 + 27),SeedofCorruption=v17(49483 - 22240, nil, 126 - 59),ShadowEmbrace=v17(27481 - (64 + 174), nil, 10 + 58),SiphonLife=v17(93455 - 30349, nil, 405 - (144 + 192)),SoulRot=v17(387213 - (42 + 174), nil, 53 + 17),SoulSwap=v17(320540 + 66411, nil, 31 + 40),SoulTap=v17(388577 - (363 + 1141), nil, 1652 - (1183 + 397)),SouleatersGluttony=v17(1186167 - 796537, nil, 54 + 19),TormentedCrescendo=v17(289322 + 97753, nil, 2050 - (1913 + 62)),UnstableAffliction=v17(199073 + 117026, nil, 201 - 125),VileTaint=v17(280283 - (565 + 1368), nil, 289 - 212),InevitableDemiseBuff=v17(335981 - (1477 + 184), nil, 105 - 27),NightfallBuff=v17(246515 + 18056, nil, 935 - (564 + 292)),MaleficAfflictionBuff=v17(672648 - 282803, nil, 241 - 161),TormentedCrescendoBuff=v17(387383 - (244 + 60), nil, 63 + 18),UmbrafireKindlingBuff=v17(424241 - (41 + 435)),AgonyDebuff=v17(1981 - (938 + 63), nil, 64 + 18),CorruptionDebuff=v17(147864 - (936 + 189), nil, 28 + 55),HauntDebuff=v17(49794 - (1565 + 48), nil, 52 + 32),PhantomSingularityDebuff=v17(206317 - (782 + 356), nil, 352 - (176 + 91)),SeedofCorruptionDebuff=v17(70976 - 43733, nil, 126 - 40),SiphonLifeDebuff=v17(64198 - (975 + 117), nil, 1962 - (157 + 1718)),UnstableAfflictionDebuff=v17(256532 + 59567, nil, 312 - 224),VileTaintDebuff=v17(951626 - 673276, nil, 1107 - (697 + 321)),SoulRotDebuff=v17(1054229 - 667232, nil, 190 - 100),DreadTouchDebuff=v17(898794 - 508926, nil, 36 + 55),ShadowEmbraceDebuff=v17(60687 - 28297, nil, 246 - 154)});
	v17.Warlock.Destruction = v20(v17.Warlock.Commons, {Immolate=v17(1575 - (322 + 905), nil, 704 - (602 + 9)),Incinerate=v17(30911 - (449 + 740), nil, 966 - (826 + 46)),SummonPet=v17(1635 - (245 + 702), nil, 300 - 205),AshenRemains=v17(124490 + 262762, nil, 1994 - (260 + 1638)),AvatarofDestruction=v17(387599 - (382 + 58), nil, 310 - 213),Backdraft=v17(163205 + 33201, nil, 202 - 104),BurntoAshes=v17(1150853 - 763700, nil, 1304 - (902 + 303)),Cataclysm=v17(333974 - 181866, nil, 240 - 140),ChannelDemonfire=v17(16881 + 179566, nil, 1791 - (1121 + 569)),ChaosBolt=v17(117072 - (22 + 192), nil, 785 - (483 + 200)),ChaosIncarnate=v17(388738 - (1404 + 59)),Chaosbringer=v17(1155059 - 733002),Conflagrate=v17(24141 - 6179, nil, 868 - (468 + 297)),CrashingChaos=v17(417796 - (334 + 228)),CryHavoc=v17(1307106 - 919584, nil, 240 - 136),DiabolicEmbers=v17(702193 - 315020, nil, 30 + 75),DimensionalRift=v17(388212 - (141 + 95), nil, 105 + 1),Eradication=v17(505565 - 309153, nil, 256 - 149),FireandBrimstone=v17(46006 + 150402, nil, 295 - 187),Havoc=v17(56408 + 23832, nil, 57 + 52),Inferno=v17(380993 - 110448, nil, 65 + 45),InternalCombustion=v17(266297 - (92 + 71), nil, 55 + 56),MadnessoftheAzjAqir=v17(651334 - 263934, nil, 877 - (574 + 191)),Mayhem=v17(319640 + 67866, nil, 282 - 169),RagingDemonfire=v17(197760 + 189406, nil, 963 - (254 + 595)),RainofChaos=v17(266212 - (55 + 71), nil, 151 - 36),RainofFire=v17(7530 - (573 + 1217), nil, 321 - 205),RoaringBlaze=v17(15612 + 189572, nil, 187 - 70),Ruin=v17(388042 - (714 + 225), nil, 344 - 226),SoulFire=v17(8856 - 2503, nil, 13 + 106),SummonInfernal=v17(1624 - 502, nil, 926 - (118 + 688)),BackdraftBuff=v17(117876 - (25 + 23), nil, 24 + 97),MadnessCBBuff=v17(389295 - (927 + 959), nil, 411 - 289),MadnessRoFBuff=v17(388145 - (16 + 716)),MadnessSBBuff=v17(747866 - 360452),RainofChaosBuff=v17(266184 - (11 + 86), nil, 299 - 176),RitualofRuinBuff=v17(387442 - (175 + 110), nil, 312 - 188),BurntoAshesBuff=v17(1909540 - 1522386, nil, 1921 - (503 + 1293)),EradicationDebuff=v17(548545 - 352131, nil, 92 + 34),ConflagrateDebuff=v17(266992 - (810 + 251)),HavocDebuff=v17(55685 + 24555, nil, 39 + 88),ImmolateDebuff=v17(142192 + 15544, nil, 661 - (43 + 490)),PyrogenicsDebuff=v17(387829 - (711 + 22)),RoaringBlazeDebuff=v17(1028675 - 762744, nil, 988 - (240 + 619))});
	if (((138 + 430) > (680 - 252)) and not v19.Warlock) then
		v19.Warlock = {};
	end
	v19.Warlock.Commons = {Healthstone=v19(2 + 19),PotionOfWitheringDreams=v19(208785 - (1344 + 400)),ConjuredChillglobe=v19(194705 - (255 + 150), {(7 + 6),(44 - 30)}),DesperateInvokersCodex=v19(196049 - (404 + 1335), {(15 - 2),(6 + 8)}),TimebreachingTalon=v19(194128 - (10 + 327), {(351 - (118 + 220)),(463 - (108 + 341))}),TimeThiefsGambit=v19(93231 + 114348, {(1506 - (711 + 782)),(483 - (270 + 199))}),BelorrelostheSuncaller=v19(67163 + 140009, {(38 - 25),(1 + 13)}),Iridal=v19(90750 + 117571, {(10 + 6)}),NymuesUnravelingSpindle=v19(209782 - (645 + 522), {(13 + 0),(41 - 27)}),MirrorofFracturedTomorrows=v19(209417 - (1045 + 791), {(19 - 6),(1588 - (1281 + 293))}),RubyWhelpShell=v19(194023 - (28 + 238), {(1572 - (1381 + 178)),(12 + 2)}),WhisperingIncarnateIcon=v19(82881 + 111420, {(7 + 6),(13 + 1)}),AshesoftheEmbersoul=v19(140105 + 67062, {(1169 - (1074 + 82)),(1798 - (214 + 1570))}),BeacontotheBeyond=v19(205418 - (990 + 465), {(6 + 7),(55 - 41)}),IcebloodDeathsnare=v19(196030 - (1668 + 58), {(33 - 20),(48 - 34)}),IrideusFragment=v19(90132 + 103611, {(12 + 1),(2008 - (109 + 1885))}),NeltharionsCallToDominance=v19(205671 - (1269 + 200), {(828 - (98 + 717)),(23 - 9)}),RotcrustedVoodooDoll=v19(201597 - 41973, {(10 + 3),(4 + 10)}),SpoilsofNeltharus=v19(539064 - 345291, {(5 + 8),(12 + 2)}),VoidmendersShadowgem=v19(79990 + 30017, {(1446 - (797 + 636)),(1633 - (1427 + 192))})};
	v19.Warlock.Affliction = v20(v19.Warlock.Commons, {});
	v19.Warlock.Demonology = v20(v19.Warlock.Commons, {});
	v19.Warlock.Destruction = v20(v19.Warlock.Commons, {});
	if (((463 + 871) <= (10709 - 6096)) and not v23.Warlock) then
		v23.Warlock = {};
	end
	v23.Warlock.Commons = {Healthstone=v23(19 + 2),HealingPotion=v23(5 + 5),ConjuredChillglobe=v23(348 - (192 + 134)),DesperateInvokersCodex=v23(1299 - (316 + 960)),TimebreachingTalon=v23(14 + 10),AxeTossMouseover=v23(19 + 5),CorruptionMouseover=v23(24 + 1),SpellLockMouseover=v23(99 - 73),ShadowBoltPetAttack=v23(578 - (83 + 468)),IridialStaff=v23(1846 - (1202 + 604)),CancelBurningRush=v23(191 - 150)};
	v23.Warlock.Affliction = v20(v23.Warlock.Commons, {AgonyMouseover=v23(46 - 18),VileTaintCursor=v23(80 - 51)});
	v23.Warlock.Demonology = v20(v23.Warlock.Commons, {DemonboltPetAttack=v23(355 - (45 + 280)),DoomMouseover=v23(30 + 1),GuillotineCursor=v23(28 + 4)});
	v23.Warlock.Destruction = v20(v23.Warlock.Commons, {HavocMouseover=v23(13 + 20),ImmolateMouseover=v23(19 + 15),ImmolatePetAttack=v23(7 + 28),RainofFireCursor=v23(66 - 30),SummonInfernalCursor=v23(1948 - (340 + 1571))});
	v11.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v11.GuardiansTable = {Pets={},ImpCount=(0 + 0),FelguardDuration=(1772 - (1733 + 39)),DreadstalkerDuration=(0 - 0),DemonicTyrantDuration=(1034 - (125 + 909)),VilefiendDuration=(1948 - (1096 + 852)),PitLordDuration=(0 + 0),Infernal=(0 - 0),Blasphemy=(0 + 0),DarkglareDuration=(512 - (409 + 103)),InnerDemonsNextCast=(236 - (46 + 190)),ImpsSpawnedFromHoG=(95 - (51 + 44))};
	local v40 = {[27650 + 70385]={name="Dreadstalker",duration=(1329.25 - (1114 + 203))},[56385 - (228 + 498)]={name="Wild Imp",duration=(5 + 15)},[79346 + 64276]={name="Wild Imp",duration=(683 - (174 + 489))},[44946 - 27694]={name="Felguard",duration=(1922 - (830 + 1075))},[135526 - (303 + 221)]={name="Demonic Tyrant",duration=(1284 - (231 + 1038))},[113177 + 22639]={name="Vilefiend",duration=(1177 - (171 + 991))},[808213 - 612102]={name="Pit Lord",duration=(26 - 16)},[221 - 132]={name="Infernal",duration=(25 + 5)},[650538 - 464954]={name="Blasphemy",duration=(22 - 14)},[167117 - 63444]={name="Darkglare",duration=(77 - 52)}};
	v11:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(1256 - (111 + 1137), ...);
		if ((SpellID == (157894 - (91 + 67))) or ((5550 - 3685) >= (507 + 1522))) then
			v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 523 - (423 + 100);
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v11:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(1 + 7, ...);
		if (((13705 - 8755) >= (843 + 773)) and (SpellID == (158507 - (326 + 445)))) then
			if (((7527 - 5802) == (3842 - 2117)) and v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
				v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
			end
		end
	end, "SPELL_AURA_REMOVED");
	v11:RegisterForCombatEvent(function(...)
		DestGUID = select(18 - 10, ...);
		if (((2170 - (530 + 181)) <= (3363 - (614 + 267))) and v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
			v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v11:RegisterForSelfCombatEvent(function(...)
		local v45 = 32 - (19 + 13);
		while true do
			if ((v45 == (0 - 0)) or ((6282 - 3586) >= (12946 - 8414))) then
				DestGUID, _, _, _, SpellID = select(3 + 5, ...);
				if (((1842 - 794) >= (107 - 55)) and (SpellID == (19774 - (1293 + 519)))) then
					if (((6035 - 3077) < (11756 - 7253)) and v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
						v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + (1 - 0);
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v24.UpdatePetTable = function()
		for v65, v66 in pairs(v11.GuardiansTable.Pets) do
			local v67 = 0 - 0;
			while true do
				if (((0 - 0) == v67) or ((1449 + 1286) == (268 + 1041))) then
					if (v66 or ((9596 - 5466) <= (683 + 2272))) then
						if ((GetTime() >= v66.despawnTime) or ((653 + 1311) <= (838 + 502))) then
							local v94 = 1096 - (709 + 387);
							while true do
								if (((4357 - (673 + 1185)) == (7247 - 4748)) and (v94 == (3 - 2))) then
									v11.GuardiansTable.Pets[v65] = nil;
									break;
								end
								if ((v94 == (0 - 0)) or ((1613 + 642) < (17 + 5))) then
									if ((v66.name == "Wild Imp") or ((1465 - 379) >= (346 + 1059))) then
										v11.GuardiansTable.ImpCount = v11.GuardiansTable.ImpCount - (1 - 0);
									end
									if ((v66.name == "Felguard") or ((4649 - 2280) == (2306 - (446 + 1434)))) then
										v11.GuardiansTable.FelguardDuration = 1283 - (1040 + 243);
									elseif ((v66.name == "Dreadstalker") or ((9180 - 6104) > (5030 - (559 + 1288)))) then
										v11.GuardiansTable.DreadstalkerDuration = 1931 - (609 + 1322);
									elseif (((1656 - (13 + 441)) > (3953 - 2895)) and (v66.name == "Demonic Tyrant")) then
										v11.GuardiansTable.DemonicTyrantDuration = 0 - 0;
									elseif (((18482 - 14771) > (125 + 3230)) and (v66.name == "Vilefiend")) then
										v11.GuardiansTable.VilefiendDuration = 0 - 0;
									elseif ((v66.name == "Pit Lord") or ((322 + 584) >= (977 + 1252))) then
										v11.GuardiansTable.PitLordDuration = 0 - 0;
									elseif (((705 + 583) > (2300 - 1049)) and (v66.name == "Infernal")) then
										v11.GuardiansTable.InfernalDuration = 0 + 0;
									elseif ((v66.name == "Blasphemy") or ((2511 + 2002) < (2409 + 943))) then
										v11.GuardiansTable.BlasphemyDuration = 0 + 0;
									elseif ((v66.name == "Darkglare") or ((2021 + 44) >= (3629 - (153 + 280)))) then
										v11.GuardiansTable.DarkglareDuration = 0 - 0;
									end
									v94 = 1 + 0;
								end
							end
						end
					end
					if ((v66.ImpCasts <= (0 + 0)) or ((2291 + 2085) <= (1344 + 137))) then
						local v85 = 0 + 0;
						while true do
							if ((v85 == (0 - 0)) or ((2097 + 1295) >= (5408 - (89 + 578)))) then
								v11.GuardiansTable.ImpCount = v11.GuardiansTable.ImpCount - (1 + 0);
								v11.GuardiansTable.Pets[v65] = nil;
								break;
							end
						end
					end
					v67 = 1 - 0;
				end
				if (((4374 - (572 + 477)) >= (291 + 1863)) and (v67 == (1 + 0))) then
					if ((GetTime() <= v66.despawnTime) or ((155 + 1140) >= (3319 - (84 + 2)))) then
						v66.Duration = v66.despawnTime - GetTime();
						if (((7212 - 2835) > (1183 + 459)) and (v66.name == "Felguard")) then
							v11.GuardiansTable.FelguardDuration = v66.Duration;
						elseif (((5565 - (497 + 345)) > (35 + 1321)) and (v66.name == "Dreadstalker")) then
							v11.GuardiansTable.DreadstalkerDuration = v66.Duration;
						elseif ((v66.name == "Demonic Tyrant") or ((700 + 3436) <= (4766 - (605 + 728)))) then
							v11.GuardiansTable.DemonicTyrantDuration = v66.Duration;
						elseif (((3029 + 1216) <= (10295 - 5664)) and (v66.name == "Vilefiend")) then
							v11.GuardiansTable.VilefiendDuration = v66.Duration;
						elseif (((196 + 4080) >= (14470 - 10556)) and (v66.name == "Pit Lord")) then
							v11.GuardiansTable.PitLordDuration = v66.Duration;
						elseif (((179 + 19) <= (12093 - 7728)) and (v66.name == "Infernal")) then
							v11.GuardiansTable.InfernalDuration = v66.Duration;
						elseif (((3611 + 1171) > (5165 - (457 + 32))) and (v66.name == "Blasphy")) then
							v11.GuardiansTable.BlasphemyDuration = v66.Duration;
						elseif (((2064 + 2800) > (3599 - (832 + 570))) and (v66.name == "Darkglare")) then
							v11.GuardiansTable.DarkglareDuration = v66.Duration;
						end
					end
					break;
				end
			end
		end
	end;
	v11:RegisterForSelfCombatEvent(function(...)
		local v46, v47, v48, v49, v48, v48, v48, v50, v48, v48, v48, v51 = select(1 + 0, ...);
		local v48, v48, v48, v48, v48, v48, v48, v52 = v21(v50, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
		v52 = tonumber(v52);
		if (((v50 ~= UnitGUID("pet")) and (v47 == "SPELL_SUMMON") and v40[v52]) or ((965 + 2735) == (8871 - 6364))) then
			local v71 = v40[v52];
			local v72;
			if (((2156 + 2318) >= (1070 - (588 + 208))) and (v71.name == "Wild Imp")) then
				local v81 = 0 - 0;
				while true do
					if ((v81 == (1800 - (884 + 916))) or ((3964 - 2070) <= (816 + 590))) then
						v11.GuardiansTable.ImpCount = v11.GuardiansTable.ImpCount + (654 - (232 + 421));
						v72 = v71.duration;
						break;
					end
				end
			elseif (((3461 - (1569 + 320)) >= (376 + 1155)) and (v71.name == "Felguard")) then
				v11.GuardiansTable.FelguardDuration = v71.duration;
				v72 = v71.duration;
			elseif ((v71.name == "Dreadstalker") or ((891 + 3796) < (15305 - 10763))) then
				v11.GuardiansTable.DreadstalkerDuration = v71.duration;
				v72 = v71.duration;
			elseif (((3896 - (316 + 289)) > (4363 - 2696)) and (v71.name == "Demonic Tyrant")) then
				if ((v51 == (12247 + 252940)) or ((2326 - (666 + 787)) == (2459 - (360 + 65)))) then
					v11.GuardiansTable.DemonicTyrantDuration = v71.duration;
					v72 = v71.duration;
				end
			elseif ((v71.name == "Vilefiend") or ((2632 + 184) < (265 - (79 + 175)))) then
				local v113 = 0 - 0;
				while true do
					if (((2887 + 812) < (14424 - 9718)) and (v113 == (0 - 0))) then
						v11.GuardiansTable.VilefiendDuration = v71.duration;
						v72 = v71.duration;
						break;
					end
				end
			elseif (((3545 - (503 + 396)) >= (1057 - (92 + 89))) and (v71.name == "Pit Lord")) then
				local v118 = 0 - 0;
				while true do
					if (((315 + 299) <= (1885 + 1299)) and ((0 - 0) == v118)) then
						v11.GuardiansTable.PitLordDuration = v71.duration;
						v72 = v71.duration;
						break;
					end
				end
			elseif (((428 + 2698) == (7127 - 4001)) and (v71.name == "Infernal")) then
				v11.GuardiansTable.InfernalDuration = v71.duration;
				v72 = v71.duration;
			elseif ((v71.name == "Blasphemy") or ((1909 + 278) >= (2367 + 2587))) then
				v11.GuardiansTable.BlasphemyDuration = v71.duration;
				v72 = v71.duration;
			elseif ((v71.name == "Darkglare") or ((11808 - 7931) == (447 + 3128))) then
				v11.GuardiansTable.DarkglareDuration = v71.duration;
				v72 = v71.duration;
			end
			local v73 = {ID=v50,name=v71.name,spawnTime=GetTime(),ImpCasts=(7 - 2),Duration=v72,despawnTime=(GetTime() + tonumber(v72))};
			table.insert(v11.GuardiansTable.Pets, v73);
		end
		if (((1951 - (485 + 759)) > (1462 - 830)) and v40[v52] and (v40[v52].name == "Demonic Tyrant")) then
			for v78, v79 in pairs(v11.GuardiansTable.Pets) do
				if ((v79 and (v79.name ~= "Demonic Tyrant") and (v79.name ~= "Pit Lord")) or ((1735 - (442 + 747)) >= (3819 - (832 + 303)))) then
					v79.despawnTime = v79.despawnTime + (961 - (88 + 858));
					v79.ImpCasts = v79.ImpCasts + 3 + 4;
				end
			end
		end
		if (((1213 + 252) <= (178 + 4123)) and (v52 == (144411 - (766 + 23)))) then
			v11.GuardiansTable.InnerDemonsNextCast = GetTime() + (59 - 47);
		end
		if (((2330 - 626) > (3754 - 2329)) and (v52 == (188908 - 133249)) and (v11.GuardiansTable.ImpsSpawnedFromHoG > (1073 - (1036 + 37)))) then
			v11.GuardiansTable.ImpsSpawnedFromHoG = v11.GuardiansTable.ImpsSpawnedFromHoG - (1 + 0);
		end
		v24.UpdatePetTable();
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v11:RegisterForCombatEvent(function(...)
		local v53 = 0 - 0;
		local v54;
		local v55;
		local v56;
		local v57;
		while true do
			if ((v53 == (0 + 0)) or ((2167 - (641 + 839)) == (5147 - (910 + 3)))) then
				v54, v55, v55, v55, v56, v55, v55, v55, v57 = select(9 - 5, ...);
				if ((v57 == (106002 - (1466 + 218))) or ((1531 + 1799) < (2577 - (556 + 592)))) then
					for v89, v90 in pairs(v11.GuardiansTable.Pets) do
						if (((408 + 739) >= (1143 - (329 + 479))) and (v54 == v90.ID)) then
							v90.ImpCasts = v90.ImpCasts - (855 - (174 + 680));
						end
					end
				end
				v53 = 3 - 2;
			end
			if (((7119 - 3684) > (1498 + 599)) and (v53 == (740 - (396 + 343)))) then
				if (((v54 == v14:GUID()) and (v57 == (17367 + 178910))) or ((5247 - (29 + 1448)) >= (5430 - (135 + 1254)))) then
					local v84 = 0 - 0;
					while true do
						if (((0 - 0) == v84) or ((2527 + 1264) <= (3138 - (389 + 1138)))) then
							for v103, v104 in pairs(v11.GuardiansTable.Pets) do
								if ((v104.name == "Wild Imp") or ((5152 - (102 + 472)) <= (1895 + 113))) then
									v11.GuardiansTable.Pets[v103] = nil;
								end
							end
							v11.GuardiansTable.ImpCount = 0 + 0;
							break;
						end
					end
				end
				v24.UpdatePetTable();
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v24.LastPI = 0 + 0;
	v11:RegisterForCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(1553 - (320 + 1225), ...);
		if (((2002 - 877) <= (1271 + 805)) and (SpellID == (11524 - (157 + 1307))) and (DestGUID == v14:GUID())) then
			v24.LastPI = GetTime();
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v24.SoulShards = 1859 - (821 + 1038);
	v24.UpdateSoulShards = function()
		v24.SoulShards = v14:SoulShards();
	end;
	v11:RegisterForSelfCombatEvent(function(v59, v60, v59, v59, v59, v59, v59, v59, v59, v59, v59, v61)
		if ((v61 == (262407 - 157233)) or ((82 + 661) >= (7813 - 3414))) then
			v11.GuardiansTable.ImpsSpawnedFromHoG = v11.GuardiansTable.ImpsSpawnedFromHoG + (((v24.SoulShards >= (2 + 1)) and (7 - 4)) or v24.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v1["Epix_Warlock_Warlock.lua"](...);

