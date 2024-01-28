local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((564 + 700) < (1108 - (660 + 176)))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warlock_Warlock.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.Pet;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = v9.Utils.MergeTableByKey;
	local v19 = string.find;
	local v20 = EpicLib;
	local v21 = v20.Macro;
	local v22 = {};
	v9.Commons.Warlock = v22;
	if (((376 + 2747) < (4093 - (14 + 188))) and not v15.Warlock) then
		v15.Warlock = {};
	end
	v15.Warlock.Commons = {Berserking=v15(26972 - (534 + 141), nil, 1 + 0),AncestralCall=v15(243018 + 31720),BloodFury=v15(32403 + 1299, nil, 3 - 1),Fireblood=v15(421069 - 155848, nil, 8 - 5),Corruption=v15(93 + 79, nil, 3 + 1),DarkPact=v15(108812 - (115 + 281), nil, 11 - 6),ShadowBolt=v15(568 + 118, nil, 14 - 8),SummonDarkglare=v15(752354 - 547174, nil, 874 - (550 + 317)),UnendingResolve=v15(151373 - 46600, nil, 10 - 2),GrimoireofSacrifice=v15(303209 - 194706, nil, 294 - (134 + 151)),GrimoireofSacrificeBuff=v15(197764 - (970 + 695), nil, 19 - 9),SoulConduit=v15(217931 - (582 + 1408), nil, 37 - 26),SummonSoulkeeper=v15(485995 - 99739, nil, 45 - 33),InquisitorsGaze=v15(388168 - (1195 + 629), nil, 16 - 3),InquisitorsGazeBuff=v15(388309 - (187 + 54), nil, 794 - (162 + 618)),Soulburn=v15(270399 + 115500, nil, 10 + 5),PowerInfusionBuff=v15(21454 - 11394, nil, 26 - 10),AxeToss=v15(9376 + 110538, nil, 1653 - (1373 + 263)),Seduction=v15(120909 - (451 + 549), nil, 6 + 12),ShadowBulwark=v15(186605 - 66698, nil, 31 - 12),SingeMagic=v15(121289 - (746 + 638), nil, 8 + 12),SpellLock=v15(182057 - 62147, nil, 362 - (218 + 123)),BurningRush=v15(112981 - (1535 + 46), nil, 552 + 3)};
	v15.Warlock.Demonology = v18(v15.Warlock.Commons, {Felstorm=v15(12988 + 76763, nil, 582 - (306 + 254)),HandofGuldan=v15(6512 + 98662, nil, 44 - 21),ShadowBoltLineCD=v15(2153 - (899 + 568), nil, 4 + 2),SummonPet=v15(72950 - 42804, nil, 627 - (268 + 335)),BilescourgeBombers=v15(267501 - (60 + 230), nil, 597 - (426 + 146)),CallDreadstalkers=v15(12497 + 91819, nil, 1482 - (282 + 1174)),Demonbolt=v15(264989 - (569 + 242), nil, 77 - 50),DemonicCalling=v15(11732 + 193413, nil, 1052 - (706 + 318)),DemonicStrength=v15(268422 - (721 + 530), nil, 1300 - (945 + 326)),Doom=v15(1506 - 903, nil, 27 + 3),FelDomination=v15(334589 - (271 + 429), nil, 29 + 2),FelCovenant=v15(388932 - (1408 + 92), nil, 1118 - (461 + 625)),FromtheShadows=v15(268458 - (993 + 295), nil, 2 + 31),GrimoireFelguard=v15(113069 - (418 + 753), nil, 13 + 21),Guillotine=v15(39868 + 346965, nil, 11 + 24),ImpGangBoss=v15(97918 + 289527, nil, 565 - (406 + 123)),Implosion=v15(198046 - (1749 + 20), nil, 9 + 28),InnerDemons=v15(268538 - (1249 + 73), nil, 14 + 24),NetherPortal=v15(268362 - (466 + 679), nil, 93 - 54),PowerSiphon=v15(755461 - 491331, nil, 1940 - (106 + 1794)),SacrificedSouls=v15(84534 + 182680, nil, 11 + 30),SoulboundTyrant=v15(987829 - 653244, nil, 113 - 71),SoulStrike=v15(264171 - (4 + 110), nil, 627 - (57 + 527)),SummonDemonicTyrant=v15(266614 - (41 + 1386), nil, 147 - (17 + 86)),SummonVilefiend=v15(179259 + 84860, nil, 100 - 55),TheExpendables=v15(1122468 - 734868, nil, 212 - (122 + 44)),ReignofTyranny=v15(738752 - 311068, nil, 437 - 305),GrandWarlocksDesign=v15(314887 + 72197, nil, 20 + 113),DemonicCallingBuff=v15(415596 - 210450, nil, 112 - (30 + 35)),DemonicCoreBuff=v15(181569 + 82604, nil, 1305 - (1043 + 214)),DemonicPowerBuff=v15(1002906 - 737633, nil, 1261 - (323 + 889)),FelCovenantBuff=v15(1042841 - 655404, nil, 630 - (361 + 219)),NetherPortalBuff=v15(267538 - (53 + 267), nil, 12 + 39),DoomDebuff=v15(1016 - (15 + 398), nil, 1034 - (18 + 964)),FromtheShadowsDebuff=v15(1018453 - 747884, nil, 31 + 22),DoomBrandDebuff=v15(266873 + 156710)});
	v15.Warlock.Affliction = v18(v15.Warlock.Commons, {Agony=v15(1830 - (20 + 830), nil, 43 + 11),DrainLife=v15(234279 - (116 + 10), nil, 5 + 50),SummonPet=v15(1426 - (542 + 196), nil, 119 - 63),AbsoluteCorruption=v15(57266 + 138837, nil, 29 + 28),DoomBlossom=v15(140302 + 249462),DrainSoul=v15(523302 - 324712, nil, 148 - 90),DreadTouch=v15(391326 - (1126 + 425), nil, 464 - (118 + 287)),Haunt=v15(188835 - 140654, nil, 1181 - (118 + 1003)),InevitableDemise=v15(978361 - 644042, nil, 438 - (142 + 235)),MaleficAffliction=v15(1768158 - 1378397, nil, 14 + 48),MaleficRapture=v15(325513 - (553 + 424), nil, 118 - 55),Nightfall=v15(95631 + 12927, nil, 64 + 0),PhantomSingularity=v15(119467 + 85712, nil, 28 + 37),SowTheSeeds=v15(112059 + 84167, nil, 142 - 76),SeedofCorruption=v15(75907 - 48664, nil, 149 - 82),ShadowEmbrace=v15(7923 + 19320, nil, 328 - 260),SiphonLife=v15(63859 - (239 + 514), nil, 25 + 44),SoulRot=v15(388326 - (797 + 532), nil, 51 + 19),SoulSwap=v15(130539 + 256412, nil, 166 - 95),SoulTap=v15(388275 - (373 + 829), nil, 803 - (476 + 255)),SouleatersGluttony=v15(390760 - (369 + 761), nil, 43 + 30),SowtheSeeds=v15(356422 - 160196, nil, 140 - 66),TormentedCrescendo=v15(387313 - (64 + 174), nil, 11 + 64),UnstableAffliction=v15(468122 - 152023, nil, 412 - (144 + 192)),VileTaint=v15(278566 - (42 + 174), nil, 58 + 19),InevitableDemiseBuff=v15(276942 + 57378, nil, 34 + 44),NightfallBuff=v15(266075 - (363 + 1141), nil, 1659 - (1183 + 397)),MaleficAfflictionBuff=v15(1186822 - 796977, nil, 59 + 21),TormentedCrescendoBuff=v15(289325 + 97754, nil, 2056 - (1913 + 62)),UmbrafireKindlingBuff=v15(266879 + 156886),AgonyDebuff=v15(2594 - 1614, nil, 2015 - (565 + 1368)),CorruptionDebuff=v15(551846 - 405107, nil, 1744 - (1477 + 184)),HauntDebuff=v15(65650 - 17469, nil, 79 + 5),PhantomSingularityDebuff=v15(206035 - (564 + 292), nil, 146 - 61),SeedofCorruptionDebuff=v15(82114 - 54871, nil, 390 - (244 + 60)),SiphonLifeDebuff=v15(48523 + 14583, nil, 563 - (41 + 435)),UnstableAfflictionDebuff=v15(317100 - (938 + 63), nil, 68 + 20),VileTaintDebuff=v15(279475 - (936 + 189), nil, 30 + 59),SoulRotDebuff=v15(388610 - (1565 + 48), nil, 56 + 34),DreadTouchDebuff=v15(391006 - (782 + 356), nil, 358 - (176 + 91)),ShadowEmbraceDebuff=v15(84386 - 51996, nil, 134 - 42)});
	v15.Warlock.Destruction = v18(v15.Warlock.Commons, {Immolate=v15(1440 - (975 + 117), nil, 1968 - (157 + 1718)),Incinerate=v15(24122 + 5600, nil, 333 - 239),SummonPet=v15(2351 - 1663, nil, 1113 - (697 + 321)),AshenRemains=v15(1054923 - 667671, nil, 202 - 106),AvatarofDestruction=v15(892548 - 505389, nil, 38 + 59),Backdraft=v15(367997 - 171591, nil, 262 - 164),BurntoAshes=v15(388380 - (322 + 905), nil, 710 - (602 + 9)),Cataclysm=v15(153297 - (449 + 740), nil, 972 - (826 + 46)),ChannelDemonfire=v15(197394 - (245 + 702), nil, 319 - 218),ChaosBolt=v15(37567 + 79291, nil, 2000 - (260 + 1638)),ChaosIncarnate=v15(387715 - (382 + 58)),Chaosbringer=v15(1353989 - 931932),Conflagrate=v15(14926 + 3036, nil, 212 - 109),CrashingChaos=v15(1240272 - 823038),CryHavoc=v15(388727 - (902 + 303), nil, 228 - 124),DiabolicEmbers=v15(932507 - 545334, nil, 10 + 95),DimensionalRift=v15(389666 - (1121 + 569), nil, 320 - (22 + 192)),Eradication=v15(197095 - (483 + 200), nil, 1570 - (1404 + 59)),FireandBrimstone=v15(537517 - 341109, nil, 144 - 36),Havoc=v15(81005 - (468 + 297), nil, 671 - (334 + 228)),Inferno=v15(912544 - 641999, nil, 254 - 144),InternalCombustion=v15(482671 - 216537, nil, 32 + 79),MadnessoftheAzjAqir=v15(387636 - (141 + 95), nil, 111 + 1),Mayhem=v15(997443 - 609937, nil, 271 - 158),RagingDemonfire=v15(90689 + 296477, nil, 312 - 198),RainofChaos=v15(187057 + 79029, nil, 60 + 55),RainofFire=v15(8083 - 2343, nil, 69 + 47),RoaringBlaze=v15(205347 - (92 + 71), nil, 58 + 59),Ruin=v15(650835 - 263732, nil, 883 - (574 + 191)),SoulFire=v15(5241 + 1112, nil, 297 - 178),SummonInfernal=v15(574 + 548, nil, 969 - (254 + 595)),BackdraftBuff=v15(117954 - (55 + 71), nil, 159 - 38),MadnessCBBuff=v15(389199 - (573 + 1217), nil, 337 - 215),MadnessRoFBuff=v15(29478 + 357935),MadnessSBBuff=v15(624277 - 236863),RainofChaosBuff=v15(267026 - (714 + 225), nil, 359 - 236),RitualofRuinBuff=v15(539760 - 152603, nil, 14 + 110),BurntoAshesBuff=v15(560579 - 173425, nil, 931 - (118 + 688)),EradicationDebuff=v15(196462 - (25 + 23), nil, 25 + 101),ConflagrateDebuff=v15(267817 - (927 + 959)),HavocDebuff=v15(270480 - 190240, nil, 859 - (16 + 716)),ImmolateDebuff=v15(304494 - 146758, nil, 225 - (11 + 86)),PyrogenicsDebuff=v15(944193 - 557097),RoaringBlazeDebuff=v15(266216 - (175 + 110), nil, 325 - 196)});
	if (((19442 - 15500) <= (6783 - (503 + 1293))) and not v17.Warlock) then
		v17.Warlock = {};
	end
	v17.Warlock.Commons = {Healthstone=v17(58 - 37),ConjuredChillglobe=v17(140511 + 53789, {(10 + 3),(13 + 1)}),DesperateInvokersCodex=v17(194843 - (43 + 490), {(50 - 37),(4 + 10)}),TimebreachingTalon=v17(308263 - 114472, {(1757 - (1344 + 400)),(12 + 2)}),TimeThiefsGambit=v17(111133 + 96446, {(41 - 28),(420 - (183 + 223))}),BelorrelostheSuncaller=v17(252099 - 44927, {(5 + 8),(10 + 4)}),Iridal=v17(208659 - (118 + 220), {(465 - (108 + 341))}),NymuesUnravelingSpindle=v17(93697 + 114918, {(1506 - (711 + 782)),(483 - (270 + 199))})};
	v17.Warlock.Affliction = v18(v17.Warlock.Commons, {});
	v17.Warlock.Demonology = v18(v17.Warlock.Commons, {});
	v17.Warlock.Destruction = v18(v17.Warlock.Commons, {});
	if (((1487 + 3097) == (6403 - (580 + 1239))) and not v21.Warlock) then
		v21.Warlock = {};
	end
	v21.Warlock.Commons = {Healthstone=v21(62 - 41),HealingPotion=v21(10 + 0),ConjuredChillglobe=v21(1 + 21),DesperateInvokersCodex=v21(11 + 12),TimebreachingTalon=v21(62 - 38),AxeTossMouseover=v21(15 + 9),CorruptionMouseover=v21(1192 - (645 + 522)),SpellLockMouseover=v21(1816 - (1010 + 780)),ShadowBoltPetAttack=v21(27 + 0),IridialStaff=v21(190 - 150),CancelBurningRush=v21(120 - 79)};
	v21.Warlock.Affliction = v18(v21.Warlock.Commons, {AgonyMouseover=v21(1864 - (1045 + 791)),VileTaintCursor=v21(72 - 43)});
	v21.Warlock.Demonology = v18(v21.Warlock.Commons, {DemonboltPetAttack=v21(45 - 15),DoomMouseover=v21(536 - (351 + 154)),GuillotineCursor=v21(1606 - (1281 + 293))});
	v21.Warlock.Destruction = v18(v21.Warlock.Commons, {HavocMouseover=v21(299 - (28 + 238)),ImmolateMouseover=v21(75 - 41),ImmolatePetAttack=v21(1594 - (1381 + 178)),RainofFireCursor=v21(34 + 2),SummonInfernalCursor=v21(30 + 7)});
	v9.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v9.GuardiansTable = {Pets={},ImpCount=(0 + 0),FelguardDuration=(0 - 0),DreadstalkerDuration=(0 + 0),DemonicTyrantDuration=(470 - (381 + 89)),VilefiendDuration=(0 + 0),PitLordDuration=(0 + 0),Infernal=(0 - 0),Blasphemy=(1156 - (1074 + 82)),DarkglareDuration=(0 - 0),InnerDemonsNextCast=(1784 - (214 + 1570)),ImpsSpawnedFromHoG=(1455 - (990 + 465))};
	local v38 = {[40415 + 57620]={name="Dreadstalker",duration=(6.25 + 6)},[54126 + 1533]={name="Wild Imp",duration=(78 - 58)},[145348 - (1668 + 58)]={name="Wild Imp",duration=(646 - (512 + 114))},[44978 - 27726]={name="Felguard",duration=(35 - 18)},[469760 - 334758]={name="Demonic Tyrant",duration=(7 + 8)},[25424 + 110392]={name="Vilefiend",duration=(14 + 1)},[661475 - 465364]={name="Pit Lord",duration=(2004 - (109 + 1885))},[1558 - (1269 + 200)]={name="Infernal",duration=(57 - 27)},[186399 - (98 + 717)]={name="Blasphemy",duration=(834 - (802 + 24))},[178787 - 75114]={name="Darkglare",duration=(31 - 6)}};
	v9:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(2 + 6, ...);
		if (((3058 + 921) >= (274 + 1394)) and (SpellID == (34025 + 123711))) then
			v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 0 - 0;
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v9:RegisterForSelfCombatEvent(function(...)
		local v43 = 0 - 0;
		while true do
			if (((204 + 364) > (175 + 253)) and (v43 == (0 + 0))) then
				DestGUID, _, _, _, SpellID = select(6 + 2, ...);
				if (((623 + 711) <= (6046 - (797 + 636))) and (SpellID == (765865 - 608129))) then
					if (v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((3484 - (1427 + 192)) >= (704 + 1325))) then
						v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED");
	v9:RegisterForCombatEvent(function(...)
		local v44 = 0 - 0;
		while true do
			if (((4450 + 500) >= (733 + 883)) and (v44 == (326 - (192 + 134)))) then
				DestGUID = select(1284 - (316 + 960), ...);
				if (((960 + 765) == (1332 + 393)) and v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
					v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
				end
				break;
			end
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v9:RegisterForSelfCombatEvent(function(...)
		local v45 = 0 + 0;
		while true do
			if (((5577 - 4118) <= (3033 - (83 + 468))) and (v45 == (1806 - (1202 + 604)))) then
				DestGUID, _, _, _, SpellID = select(37 - 29, ...);
				if ((SpellID == (29894 - 11932)) or ((7464 - 4768) >= (4857 - (45 + 280)))) then
					if (((1012 + 36) >= (46 + 6)) and v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
						v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + 1 + 0;
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v22.UpdatePetTable = function()
		for v65, v66 in pairs(v9.GuardiansTable.Pets) do
			local v67 = 0 + 0;
			while true do
				if (((521 + 2437) < (8338 - 3835)) and (v67 == (1912 - (340 + 1571)))) then
					if ((GetTime() <= v66.despawnTime) or ((1079 + 1656) == (3081 - (1733 + 39)))) then
						local v89 = 0 - 0;
						while true do
							if (((1034 - (125 + 909)) == v89) or ((6078 - (1096 + 852)) <= (1326 + 1629))) then
								v66.Duration = v66.despawnTime - GetTime();
								if ((v66.name == "Felguard") or ((2804 - 840) <= (1300 + 40))) then
									v9.GuardiansTable.FelguardDuration = v66.Duration;
								elseif (((3011 - (409 + 103)) == (2735 - (46 + 190))) and (v66.name == "Dreadstalker")) then
									v9.GuardiansTable.DreadstalkerDuration = v66.Duration;
								elseif ((v66.name == "Demonic Tyrant") or ((2350 - (51 + 44)) < (7 + 15))) then
									v9.GuardiansTable.DemonicTyrantDuration = v66.Duration;
								elseif ((v66.name == "Vilefiend") or ((2403 - (1114 + 203)) >= (2131 - (228 + 498)))) then
									v9.GuardiansTable.VilefiendDuration = v66.Duration;
								elseif ((v66.name == "Pit Lord") or ((514 + 1855) == (236 + 190))) then
									v9.GuardiansTable.PitLordDuration = v66.Duration;
								elseif ((v66.name == "Infernal") or ((3739 - (174 + 489)) > (8292 - 5109))) then
									v9.GuardiansTable.InfernalDuration = v66.Duration;
								elseif (((3107 - (830 + 1075)) > (1582 - (303 + 221))) and (v66.name == "Blasphy")) then
									v9.GuardiansTable.BlasphemyDuration = v66.Duration;
								elseif (((4980 - (231 + 1038)) > (2796 + 559)) and (v66.name == "Darkglare")) then
									v9.GuardiansTable.DarkglareDuration = v66.Duration;
								end
								break;
							end
						end
					end
					break;
				end
				if ((v67 == (1162 - (171 + 991))) or ((3733 - 2827) >= (5984 - 3755))) then
					if (((3213 - 1925) > (1002 + 249)) and v66) then
						if ((GetTime() >= v66.despawnTime) or ((15819 - 11306) < (9669 - 6317))) then
							local v95 = 0 - 0;
							while true do
								if ((v95 == (3 - 2)) or ((3313 - (111 + 1137)) >= (3354 - (91 + 67)))) then
									v9.GuardiansTable.Pets[v65] = nil;
									break;
								end
								if ((v95 == (0 - 0)) or ((1092 + 3284) <= (2004 - (423 + 100)))) then
									if ((v66.name == "Wild Imp") or ((24 + 3368) >= (13126 - 8385))) then
										v9.GuardiansTable.ImpCount = v9.GuardiansTable.ImpCount - (1 + 0);
									end
									if (((4096 - (326 + 445)) >= (9399 - 7245)) and (v66.name == "Felguard")) then
										v9.GuardiansTable.FelguardDuration = 0 - 0;
									elseif ((v66.name == "Dreadstalker") or ((3022 - 1727) >= (3944 - (530 + 181)))) then
										v9.GuardiansTable.DreadstalkerDuration = 881 - (614 + 267);
									elseif (((4409 - (19 + 13)) > (2671 - 1029)) and (v66.name == "Demonic Tyrant")) then
										v9.GuardiansTable.DemonicTyrantDuration = 0 - 0;
									elseif (((13491 - 8768) > (353 + 1003)) and (v66.name == "Vilefiend")) then
										v9.GuardiansTable.VilefiendDuration = 0 - 0;
									elseif ((v66.name == "Pit Lord") or ((8577 - 4441) <= (5245 - (1293 + 519)))) then
										v9.GuardiansTable.PitLordDuration = 0 - 0;
									elseif (((11083 - 6838) <= (8855 - 4224)) and (v66.name == "Infernal")) then
										v9.GuardiansTable.InfernalDuration = 0 - 0;
									elseif (((10072 - 5796) >= (2074 + 1840)) and (v66.name == "Blasphemy")) then
										v9.GuardiansTable.BlasphemyDuration = 0 + 0;
									elseif (((459 - 261) <= (1009 + 3356)) and (v66.name == "Darkglare")) then
										v9.GuardiansTable.DarkglareDuration = 0 + 0;
									end
									v95 = 1 + 0;
								end
							end
						end
					end
					if (((5878 - (709 + 387)) > (6534 - (673 + 1185))) and (v66.ImpCasts <= (0 - 0))) then
						local v90 = 0 - 0;
						while true do
							if (((8002 - 3138) > (1572 + 625)) and ((0 + 0) == v90)) then
								v9.GuardiansTable.ImpCount = v9.GuardiansTable.ImpCount - (1 - 0);
								v9.GuardiansTable.Pets[v65] = nil;
								break;
							end
						end
					end
					v67 = 1 + 0;
				end
			end
		end
	end;
	v9:RegisterForSelfCombatEvent(function(...)
		local v46, v47, v48, v49, v48, v48, v48, v50, v48, v48, v48, v51 = select(1 - 0, ...);
		local v48, v48, v48, v48, v48, v48, v48, v52 = v19(v50, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
		v52 = tonumber(v52);
		if (((v50 ~= UnitGUID("pet")) and (v47 == "SPELL_SUMMON") and v38[v52]) or ((7263 - 3563) == (4387 - (446 + 1434)))) then
			local v69 = v38[v52];
			local v70;
			if (((5757 - (1040 + 243)) >= (817 - 543)) and (v69.name == "Wild Imp")) then
				v9.GuardiansTable.ImpCount = v9.GuardiansTable.ImpCount + (1848 - (559 + 1288));
				v70 = v69.duration;
			elseif ((v69.name == "Felguard") or ((3825 - (609 + 1322)) <= (1860 - (13 + 441)))) then
				v9.GuardiansTable.FelguardDuration = v69.duration;
				v70 = v69.duration;
			elseif (((5874 - 4302) >= (4010 - 2479)) and (v69.name == "Dreadstalker")) then
				v9.GuardiansTable.DreadstalkerDuration = v69.duration;
				v70 = v69.duration;
			elseif ((v69.name == "Demonic Tyrant") or ((23343 - 18656) < (170 + 4372))) then
				if (((11952 - 8661) > (593 + 1074)) and (v51 == (116201 + 148986))) then
					v9.GuardiansTable.DemonicTyrantDuration = v69.duration;
					v70 = v69.duration;
				end
			elseif ((v69.name == "Vilefiend") or ((2590 - 1717) == (1114 + 920))) then
				v9.GuardiansTable.VilefiendDuration = v69.duration;
				v70 = v69.duration;
			elseif ((v69.name == "Pit Lord") or ((5178 - 2362) < (8 + 3))) then
				local v114 = 0 + 0;
				while true do
					if (((2658 + 1041) < (3952 + 754)) and (v114 == (0 + 0))) then
						v9.GuardiansTable.PitLordDuration = v69.duration;
						v70 = v69.duration;
						break;
					end
				end
			elseif (((3079 - (153 + 280)) >= (2529 - 1653)) and (v69.name == "Infernal")) then
				v9.GuardiansTable.InfernalDuration = v69.duration;
				v70 = v69.duration;
			elseif (((552 + 62) <= (1258 + 1926)) and (v69.name == "Blasphemy")) then
				v9.GuardiansTable.BlasphemyDuration = v69.duration;
				v70 = v69.duration;
			elseif (((1636 + 1490) == (2837 + 289)) and (v69.name == "Darkglare")) then
				local v130 = 0 + 0;
				while true do
					if (((0 - 0) == v130) or ((1352 + 835) >= (5621 - (89 + 578)))) then
						v9.GuardiansTable.DarkglareDuration = v69.duration;
						v70 = v69.duration;
						break;
					end
				end
			end
			local v71 = {ID=v50,name=v69.name,spawnTime=GetTime(),ImpCasts=(4 + 1),Duration=v70,despawnTime=(GetTime() + tonumber(v70))};
			table.insert(v9.GuardiansTable.Pets, v71);
		end
		if ((v38[v52] and (v38[v52].name == "Demonic Tyrant")) or ((8060 - 4183) == (4624 - (572 + 477)))) then
			for v76, v77 in pairs(v9.GuardiansTable.Pets) do
				if (((96 + 611) > (380 + 252)) and v77 and (v77.name ~= "Demonic Tyrant") and (v77.name ~= "Pit Lord")) then
					local v85 = 0 + 0;
					while true do
						if ((v85 == (86 - (84 + 2))) or ((899 - 353) >= (1934 + 750))) then
							v77.despawnTime = v77.despawnTime + (857 - (497 + 345));
							v77.ImpCasts = v77.ImpCasts + 1 + 6;
							break;
						end
					end
				end
			end
		end
		if (((248 + 1217) <= (5634 - (605 + 728))) and (v52 == (102472 + 41150))) then
			v9.GuardiansTable.InnerDemonsNextCast = GetTime() + (26 - 14);
		end
		if (((79 + 1625) > (5268 - 3843)) and (v52 == (50177 + 5482)) and (v9.GuardiansTable.ImpsSpawnedFromHoG > (0 - 0))) then
			v9.GuardiansTable.ImpsSpawnedFromHoG = v9.GuardiansTable.ImpsSpawnedFromHoG - (1 + 0);
		end
		v22.UpdatePetTable();
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v9:RegisterForCombatEvent(function(...)
		local v53, v54, v54, v54, v55, v54, v54, v54, v56 = select(493 - (457 + 32), ...);
		if ((v56 == (44260 + 60058)) or ((2089 - (832 + 570)) == (3989 + 245))) then
			for v78, v79 in pairs(v9.GuardiansTable.Pets) do
				if ((v53 == v79.ID) or ((869 + 2461) < (5056 - 3627))) then
					v79.ImpCasts = v79.ImpCasts - (1 + 0);
				end
			end
		end
		if (((1943 - (588 + 208)) >= (902 - 567)) and (v53 == v12:GUID()) and (v56 == (198077 - (884 + 916)))) then
			for v80, v81 in pairs(v9.GuardiansTable.Pets) do
				if (((7191 - 3756) > (1216 + 881)) and (v81.name == "Wild Imp")) then
					v9.GuardiansTable.Pets[v80] = nil;
				end
			end
			v9.GuardiansTable.ImpCount = 653 - (232 + 421);
		end
		v22.UpdatePetTable();
	end, "SPELL_CAST_SUCCESS");
	v22.LastPI = 1889 - (1569 + 320);
	v9:RegisterForCombatEvent(function(...)
		local v57 = 0 + 0;
		while true do
			if ((v57 == (0 + 0)) or ((12704 - 8934) >= (4646 - (316 + 289)))) then
				DestGUID, _, _, _, SpellID = select(20 - 12, ...);
				if (((SpellID == (465 + 9595)) and (DestGUID == v12:GUID())) or ((5244 - (666 + 787)) <= (2036 - (360 + 65)))) then
					v22.LastPI = GetTime();
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v22.SoulShards = 0 + 0;
	v22.UpdateSoulShards = function()
		v22.SoulShards = v12:SoulShards();
	end;
	v9:RegisterForSelfCombatEvent(function(v59, v60, v59, v59, v59, v59, v59, v59, v59, v59, v59, v61)
		if ((v61 == (105428 - (79 + 175))) or ((7218 - 2640) <= (1567 + 441))) then
			v9.GuardiansTable.ImpsSpawnedFromHoG = v9.GuardiansTable.ImpsSpawnedFromHoG + (((v22.SoulShards >= (8 - 5)) and (5 - 2)) or v22.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Warlock_Warlock.lua"]();

