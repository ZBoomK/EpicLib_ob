local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1384 - (746 + 638);
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((5048 - 1723) > (4954 - (218 + 123)))) then
			return v6(...);
		end
		if ((v5 == (1581 - (1535 + 46))) or ((4919 + 31) <= (659 + 3894))) then
			v6 = v0[v4];
			if (((3225 - (306 + 254)) <= (244 + 3689)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
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
	if (((4740 - (899 + 568)) == (2152 + 1121)) and not v16.Warlock) then
		v16.Warlock = {};
	end
	v16.Warlock.Commons = {Berserking=v16(63635 - 37338, nil, 604 - (268 + 335)),AncestralCall=v16(275028 - (60 + 230)),BloodFury=v16(34274 - (426 + 146), nil, 1 + 1),Fireblood=v16(266677 - (282 + 1174), nil, 814 - (569 + 242)),Corruption=v16(495 - 323, nil, 1 + 3),DarkPact=v16(109440 - (706 + 318), nil, 1256 - (721 + 530)),ShadowBolt=v16(1957 - (945 + 326), nil, 14 - 8),SummonDarkglare=v16(182573 + 22607, nil, 707 - (271 + 429)),UnendingResolve=v16(96245 + 8528, nil, 1508 - (1408 + 92)),GrimoireofSacrifice=v16(109589 - (461 + 625), nil, 1297 - (993 + 295)),GrimoireofSacrificeBuff=v16(10183 + 185916, nil, 1181 - (418 + 753)),SoulConduit=v16(82242 + 133699, nil, 2 + 9),SummonSoulkeeper=v16(112974 + 273282, nil, 4 + 8),InquisitorsGaze=v16(386873 - (406 + 123), nil, 1782 - (1749 + 20)),InquisitorsGazeBuff=v16(92177 + 295891, nil, 1336 - (1249 + 73)),Soulburn=v16(137677 + 248222, nil, 1160 - (466 + 679)),PowerInfusionBuff=v16(24199 - 14139, nil, 45 - 29),AxeToss=v16(121814 - (106 + 1794), nil, 6 + 11),Seduction=v16(30311 + 89598, nil, 52 - 34),ShadowBulwark=v16(324700 - 204793, nil, 133 - (4 + 110)),SingeMagic=v16(120489 - (57 + 527), nil, 1447 - (41 + 1386)),SpellLock=v16(120013 - (17 + 86), nil, 15 + 6)};
	v16.Warlock.Demonology = v19(v16.Warlock.Commons, {Felstorm=v16(200154 - 110403, nil, 63 - 41),HandofGuldan=v16(105340 - (122 + 44), nil, 39 - 16),ShadowBoltLineCD=v16(2275 - 1589, nil, 5 + 1),SummonPet=v16(4360 + 25786, nil, 48 - 24),BilescourgeBombers=v16(267276 - (30 + 35), nil, 18 + 7),CallDreadstalkers=v16(105573 - (1043 + 214), nil, 98 - 72),Demonbolt=v16(265390 - (323 + 889), nil, 72 - 45),DemonicCalling=v16(205725 - (361 + 219), nil, 348 - (53 + 267)),DemonicStrength=v16(60360 + 206811, nil, 442 - (15 + 398)),Doom=v16(1585 - (18 + 964), nil, 112 - 82),FelDomination=v16(193310 + 140579, nil, 20 + 11),FelCovenant=v16(388282 - (20 + 830), nil, 25 + 7),FromtheShadows=v16(267296 - (116 + 10), nil, 3 + 30),GrimoireFelguard=v16(112636 - (542 + 196), nil, 72 - 38),Guillotine=v16(112962 + 273871, nil, 18 + 17),ImpGangBoss=v16(139468 + 247977, nil, 94 - 58),Implosion=v16(503212 - 306935, nil, 1588 - (1126 + 425)),InnerDemons=v16(267621 - (118 + 287), nil, 148 - 110),NetherPortal=v16(268338 - (118 + 1003), nil, 114 - 75),PowerSiphon=v16(264507 - (142 + 235), nil, 181 - 141),SacrificedSouls=v16(58143 + 209071, nil, 1018 - (553 + 424)),SoulboundTyrant=v16(632685 - 298100, nil, 37 + 5),SoulStrike=v16(261940 + 2117, nil, 26 + 17),SummonDemonicTyrant=v16(112729 + 152458, nil, 26 + 18),SummonVilefiend=v16(572581 - 308462, nil, 125 - 80),TheExpendables=v16(867853 - 480253, nil, 14 + 32),ReignofTyranny=v16(2066851 - 1639167, nil, 885 - (239 + 514)),GrandWarlocksDesign=v16(135948 + 251136, nil, 1462 - (797 + 532)),DemonicCallingBuff=v16(149063 + 56083, nil, 16 + 31),DemonicCoreBuff=v16(621137 - 356964, nil, 1250 - (373 + 829)),DemonicPowerBuff=v16(266004 - (476 + 255), nil, 1179 - (369 + 761)),FelCovenantBuff=v16(224122 + 163315, nil, 90 - 40),NetherPortalBuff=v16(506379 - 239161, nil, 289 - (64 + 174)),DoomDebuff=v16(86 + 517, nil, 76 - 24),FromtheShadowsDebuff=v16(270905 - (144 + 192), nil, 269 - (42 + 174)),DoomBrandDebuff=v16(318210 + 105373)});
	v16.Warlock.Affliction = v19(v16.Warlock.Commons, {Agony=v16(812 + 168, nil, 23 + 31),DrainLife=v16(235657 - (363 + 1141), nil, 1635 - (1183 + 397)),SummonPet=v16(2094 - 1406, nil, 42 + 14),AbsoluteCorruption=v16(146579 + 49524, nil, 2032 - (1913 + 62)),DoomBlossom=v16(245465 + 144299),DrainSoul=v16(525728 - 327138, nil, 1991 - (565 + 1368)),DreadTouch=v16(1465840 - 1076065, nil, 1720 - (1477 + 184)),Haunt=v16(65650 - 17469, nil, 56 + 4),InevitableDemise=v16(335175 - (564 + 292), nil, 104 - 43),MaleficAffliction=v16(1174805 - 785044, nil, 366 - (244 + 60)),MaleficRapture=v16(249540 + 74996, nil, 539 - (41 + 435)),Nightfall=v16(109559 - (938 + 63), nil, 50 + 14),PhantomSingularity=v16(206304 - (936 + 189), nil, 22 + 43),SowTheSeeds=v16(197839 - (1565 + 48), nil, 41 + 25),SeedofCorruption=v16(28381 - (782 + 356), nil, 334 - (176 + 91)),ShadowEmbrace=v16(70976 - 43733, nil, 100 - 32),SiphonLife=v16(64198 - (975 + 117), nil, 1944 - (157 + 1718)),SoulRot=v16(314069 + 72928, nil, 248 - 178),SoulSwap=v16(1322913 - 935962, nil, 1089 - (697 + 321)),SoulTap=v16(1054436 - 667363, nil, 152 - 80),SouleatersGluttony=v16(898246 - 508616, nil, 29 + 44),SowtheSeeds=v16(367660 - 171434, nil, 198 - 124),TormentedCrescendo=v16(388302 - (322 + 905), nil, 686 - (602 + 9)),UnstableAffliction=v16(317288 - (449 + 740), nil, 948 - (826 + 46)),VileTaint=v16(279297 - (245 + 702), nil, 243 - 166),InevitableDemiseBuff=v16(107474 + 226846, nil, 1976 - (260 + 1638)),NightfallBuff=v16(265011 - (382 + 58), nil, 253 - 174),MaleficAfflictionBuff=v16(323945 + 65900, nil, 165 - 85),TormentedCrescendoBuff=v16(1150633 - 763554, nil, 1286 - (902 + 303)),UmbrafireKindlingBuff=v16(930435 - 506670),AgonyDebuff=v16(2360 - 1380, nil, 8 + 74),CorruptionDebuff=v16(148429 - (1121 + 569), nil, 297 - (22 + 192)),HauntDebuff=v16(48864 - (483 + 200), nil, 1547 - (1404 + 59)),PhantomSingularityDebuff=v16(561521 - 356342, nil, 114 - 29),SeedofCorruptionDebuff=v16(28008 - (468 + 297), nil, 648 - (334 + 228)),SiphonLifeDebuff=v16(212855 - 149749, nil, 201 - 114),UnstableAfflictionDebuff=v16(573290 - 257191, nil, 25 + 63),VileTaintDebuff=v16(278586 - (141 + 95), nil, 88 + 1),SoulRotDebuff=v16(996132 - 609135, nil, 216 - 126),DreadTouchDebuff=v16(91322 + 298546, nil, 249 - 158),ShadowEmbraceDebuff=v16(22770 + 9620, nil, 48 + 44)});
	v16.Warlock.Destruction = v19(v16.Warlock.Commons, {Immolate=v16(489 - 141, nil, 55 + 38),Incinerate=v16(29885 - (92 + 71), nil, 47 + 47),SummonPet=v16(1156 - 468, nil, 860 - (574 + 191)),AshenRemains=v16(319431 + 67821, nil, 240 - 144),AvatarofDestruction=v16(197757 + 189402, nil, 946 - (254 + 595)),Backdraft=v16(196532 - (55 + 71), nil, 128 - 30),BurntoAshes=v16(388943 - (573 + 1217), nil, 274 - 175),Cataclysm=v16(11574 + 140534, nil, 161 - 61),ChannelDemonfire=v16(197386 - (714 + 225), nil, 295 - 194),ChaosBolt=v16(162918 - 46060, nil, 12 + 90),ChaosIncarnate=v16(560754 - 173479),Chaosbringer=v16(422863 - (118 + 688)),Conflagrate=v16(18010 - (25 + 23), nil, 20 + 83),CrashingChaos=v16(419120 - (927 + 959)),CryHavoc=v16(1306296 - 918774, nil, 836 - (16 + 716)),DiabolicEmbers=v16(747401 - 360228, nil, 202 - (11 + 86)),DimensionalRift=v16(946339 - 558363, nil, 391 - (175 + 110)),Eradication=v16(495899 - 299487, nil, 527 - 420),FireandBrimstone=v16(198204 - (503 + 1293), nil, 301 - 193),Havoc=v16(58027 + 22213, nil, 1170 - (810 + 251)),Inferno=v16(187753 + 82792, nil, 34 + 76),InternalCombustion=v16(239908 + 26226, nil, 644 - (43 + 490)),MadnessoftheAzjAqir=v16(388133 - (711 + 22), nil, 432 - 320),Mayhem=v16(388365 - (240 + 619), nil, 28 + 85),RagingDemonfire=v16(615866 - 228700, nil, 8 + 106),RainofChaos=v16(267830 - (1344 + 400), nil, 520 - (255 + 150)),RainofFire=v16(4522 + 1218, nil, 63 + 53),RoaringBlaze=v16(876664 - 671480, nil, 377 - 260),Ruin=v16(388842 - (404 + 1335), nil, 524 - (183 + 223)),SoulFire=v16(7730 - 1377, nil, 79 + 40),SummonInfernal=v16(404 + 718, nil, 457 - (10 + 327)),BackdraftBuff=v16(82055 + 35773, nil, 459 - (118 + 220)),MadnessCBBuff=v16(129106 + 258303, nil, 571 - (108 + 341)),MadnessRoFBuff=v16(174001 + 213412),MadnessSBBuff=v16(1637911 - 1250497),RainofChaosBuff=v16(267580 - (711 + 782), nil, 235 - 112),RitualofRuinBuff=v16(387626 - (270 + 199), nil, 41 + 83),BurntoAshesBuff=v16(388973 - (580 + 1239), nil, 371 - 246),EradicationDebuff=v16(187802 + 8612, nil, 5 + 121),ConflagrateDebuff=v16(115846 + 150085),HavocDebuff=v16(209504 - 129264, nil, 79 + 48),ImmolateDebuff=v16(158903 - (645 + 522), nil, 1918 - (1010 + 780)),PyrogenicsDebuff=v16(386905 + 191),RoaringBlazeDebuff=v16(1266871 - 1000940, nil, 378 - 249)});
	if (((5660 - (1045 + 791)) > (1034 - 625)) and not v18.Warlock) then
		v18.Warlock = {};
	end
	v18.Warlock.Commons = {Healthstone=v18(31 - 10),ConjuredChillglobe=v18(194805 - (351 + 154), {(279 - (28 + 238)),(1573 - (1381 + 178))}),DesperateInvokersCodex=v18(182251 + 12059, {(6 + 7),(8 + 6)}),TimebreachingTalon=v18(194261 - (381 + 89), {(9 + 4),(1170 - (1074 + 82))}),TimeThiefsGambit=v18(454904 - 247325, {(1468 - (990 + 465)),(7 + 7)}),BelorrelostheSuncaller=v18(201465 + 5707, {(1739 - (1668 + 58)),(36 - 22)})};
	v18.Warlock.Affliction = v19(v18.Warlock.Commons, {});
	v18.Warlock.Demonology = v19(v18.Warlock.Commons, {});
	v18.Warlock.Destruction = v19(v18.Warlock.Commons, {});
	if (((4314 - 2227) == (7261 - 5174)) and not v22.Warlock) then
		v22.Warlock = {};
	end
	v22.Warlock.Commons = {Healthstone=v22(10 + 11),ConjuredChillglobe=v22(5 + 17),DesperateInvokersCodex=v22(20 + 3),TimebreachingTalon=v22(80 - 56),AxeTossMouseover=v22(2018 - (109 + 1885)),CorruptionMouseover=v22(1494 - (1269 + 200)),SpellLockMouseover=v22(49 - 23),ShadowBoltPetAttack=v22(842 - (98 + 717))};
	v22.Warlock.Affliction = v19(v22.Warlock.Commons, {AgonyMouseover=v22(854 - (802 + 24)),VileTaintCursor=v22(49 - 20)});
	v22.Warlock.Demonology = v19(v22.Warlock.Commons, {DemonboltPetAttack=v22(37 - 7),DoomMouseover=v22(5 + 26),GuillotineCursor=v22(25 + 7)});
	v22.Warlock.Destruction = v19(v22.Warlock.Commons, {HavocMouseover=v22(6 + 27),ImmolateMouseover=v22(8 + 26),ImmolatePetAttack=v22(97 - 62),RainofFireCursor=v22(119 - 83),SummonInfernalCursor=v22(14 + 23)});
	v10.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v10.GuardiansTable = {Pets={},ImpCount=(0 + 0),FelguardDuration=(0 + 0),DreadstalkerDuration=(0 + 0),DemonicTyrantDuration=(0 + 0),VilefiendDuration=(1433 - (797 + 636)),PitLordDuration=(0 - 0),Infernal=(1619 - (1427 + 192)),Blasphemy=(0 + 0),DarkglareDuration=(0 - 0),InnerDemonsNextCast=(0 + 0),ImpsSpawnedFromHoG=(0 + 0)};
	local v39 = {[98361 - (192 + 134)]={name="Dreadstalker",duration=(1288.25 - (316 + 960))},[30975 + 24684]={name="Wild Imp",duration=(16 + 4)},[132752 + 10870]={name="Wild Imp",duration=(76 - 56)},[17803 - (83 + 468)]={name="Felguard",duration=(1823 - (1202 + 604))},[630215 - 495213]={name="Demonic Tyrant",duration=(24 - 9)},[376039 - 240223]={name="Vilefiend",duration=(340 - (45 + 280))},[189286 + 6825]={name="Pit Lord",duration=(9 + 1)},[33 + 56]={name="Infernal",duration=(17 + 13)},[32643 + 152941]={name="Blasphemy",duration=(14 - 6)},[105584 - (340 + 1571)]={name="Darkglare",duration=(10 + 15)}};
	v10:RegisterForSelfCombatEvent(function(...)
		local v44 = 1772 - (1733 + 39);
		while true do
			if ((v44 == (0 - 0)) or ((4438 - (125 + 909)) > (6451 - (1096 + 852)))) then
				DestGUID, _, _, _, SpellID = select(4 + 4, ...);
				if ((SpellID == (225263 - 67527)) or ((3401 + 105) <= (1821 - (409 + 103)))) then
					v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 236 - (46 + 190);
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v10:RegisterForSelfCombatEvent(function(...)
		local v45 = 95 - (51 + 44);
		while true do
			if (((834 + 2121) == (4272 - (1114 + 203))) and (v45 == (726 - (228 + 498)))) then
				DestGUID, _, _, _, SpellID = select(2 + 6, ...);
				if ((SpellID == (87143 + 70593)) or ((3566 - (174 + 489)) == (3894 - 2399))) then
					if (((6451 - (830 + 1075)) >= (2799 - (303 + 221))) and v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
						v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED");
	v10:RegisterForCombatEvent(function(...)
		DestGUID = select(1277 - (231 + 1038), ...);
		if (((683 + 136) >= (1184 - (171 + 991))) and v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
			v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v46 = 0 - 0;
		while true do
			if (((8490 - 5328) == (7890 - 4728)) and (v46 == (0 + 0))) then
				DestGUID, _, _, _, SpellID = select(27 - 19, ...);
				if ((SpellID == (51816 - 33854)) or ((3818 - 1449) > (13691 - 9262))) then
					if (((5343 - (111 + 1137)) >= (3341 - (91 + 67))) and v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
						v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + (2 - 1);
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v23.UpdatePetTable = function()
		for v66, v67 in pairs(v10.GuardiansTable.Pets) do
			local v68 = 0 + 0;
			while true do
				if ((v68 == (524 - (423 + 100))) or ((27 + 3684) < (2790 - 1782))) then
					if ((GetTime() <= v67.despawnTime) or ((547 + 502) <= (1677 - (326 + 445)))) then
						local v86 = 0 - 0;
						while true do
							if (((10053 - 5540) > (6362 - 3636)) and ((711 - (530 + 181)) == v86)) then
								v67.Duration = v67.despawnTime - GetTime();
								if ((v67.name == "Felguard") or ((2362 - (614 + 267)) >= (2690 - (19 + 13)))) then
									v10.GuardiansTable.FelguardDuration = v67.Duration;
								elseif ((v67.name == "Dreadstalker") or ((5240 - 2020) == (3178 - 1814))) then
									v10.GuardiansTable.DreadstalkerDuration = v67.Duration;
								elseif ((v67.name == "Demonic Tyrant") or ((3010 - 1956) > (881 + 2511))) then
									v10.GuardiansTable.DemonicTyrantDuration = v67.Duration;
								elseif ((v67.name == "Vilefiend") or ((1188 - 512) >= (3404 - 1762))) then
									v10.GuardiansTable.VilefiendDuration = v67.Duration;
								elseif (((5948 - (1293 + 519)) > (4890 - 2493)) and (v67.name == "Pit Lord")) then
									v10.GuardiansTable.PitLordDuration = v67.Duration;
								elseif ((v67.name == "Infernal") or ((11315 - 6981) == (8117 - 3872))) then
									v10.GuardiansTable.InfernalDuration = v67.Duration;
								elseif ((v67.name == "Blasphy") or ((18438 - 14162) <= (7140 - 4109))) then
									v10.GuardiansTable.BlasphemyDuration = v67.Duration;
								elseif ((v67.name == "Darkglare") or ((2533 + 2249) <= (245 + 954))) then
									v10.GuardiansTable.DarkglareDuration = v67.Duration;
								end
								break;
							end
						end
					end
					break;
				end
				if ((v68 == (0 - 0)) or ((1124 + 3740) < (632 + 1270))) then
					if (((3024 + 1815) >= (4796 - (709 + 387))) and v67) then
						if ((GetTime() >= v67.despawnTime) or ((2933 - (673 + 1185)) > (5562 - 3644))) then
							local v96 = 0 - 0;
							while true do
								if (((651 - 255) <= (2721 + 1083)) and (v96 == (1 + 0))) then
									v10.GuardiansTable.Pets[v66] = nil;
									break;
								end
								if ((v96 == (0 - 0)) or ((1024 + 3145) == (4360 - 2173))) then
									if (((2759 - 1353) == (3286 - (446 + 1434))) and (v67.name == "Wild Imp")) then
										v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (1284 - (1040 + 243));
									end
									if (((4569 - 3038) < (6118 - (559 + 1288))) and (v67.name == "Felguard")) then
										v10.GuardiansTable.FelguardDuration = 1931 - (609 + 1322);
									elseif (((1089 - (13 + 441)) == (2372 - 1737)) and (v67.name == "Dreadstalker")) then
										v10.GuardiansTable.DreadstalkerDuration = 0 - 0;
									elseif (((16799 - 13426) <= (133 + 3423)) and (v67.name == "Demonic Tyrant")) then
										v10.GuardiansTable.DemonicTyrantDuration = 0 - 0;
									elseif ((v67.name == "Vilefiend") or ((1169 + 2122) < (1438 + 1842))) then
										v10.GuardiansTable.VilefiendDuration = 0 - 0;
									elseif (((2401 + 1985) >= (1605 - 732)) and (v67.name == "Pit Lord")) then
										v10.GuardiansTable.PitLordDuration = 0 + 0;
									elseif (((513 + 408) <= (792 + 310)) and (v67.name == "Infernal")) then
										v10.GuardiansTable.InfernalDuration = 0 + 0;
									elseif (((4605 + 101) >= (1396 - (153 + 280))) and (v67.name == "Blasphemy")) then
										v10.GuardiansTable.BlasphemyDuration = 0 - 0;
									elseif ((v67.name == "Darkglare") or ((862 + 98) <= (346 + 530))) then
										v10.GuardiansTable.DarkglareDuration = 0 + 0;
									end
									v96 = 1 + 0;
								end
							end
						end
					end
					if ((v67.ImpCasts <= (0 + 0)) or ((3145 - 1079) == (577 + 355))) then
						local v87 = 667 - (89 + 578);
						while true do
							if (((3447 + 1378) < (10067 - 5224)) and (v87 == (1049 - (572 + 477)))) then
								v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (1 + 0);
								v10.GuardiansTable.Pets[v66] = nil;
								break;
							end
						end
					end
					v68 = 1 + 0;
				end
			end
		end
	end;
	v10:RegisterForSelfCombatEvent(function(...)
		local v47, v48, v49, v50, v49, v49, v49, v51, v49, v49, v49, v52 = select(1 + 0, ...);
		local v49, v49, v49, v49, v49, v49, v49, v53 = v20(v51, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
		v53 = tonumber(v53);
		if (((v51 ~= UnitGUID("pet")) and (v48 == "SPELL_SUMMON") and v39[v53]) or ((3963 - (84 + 2)) >= (7476 - 2939))) then
			local v71 = 0 + 0;
			local v72;
			local v73;
			local v74;
			while true do
				if ((v71 == (844 - (497 + 345))) or ((111 + 4204) < (292 + 1434))) then
					table.insert(v10.GuardiansTable.Pets, v74);
					break;
				end
				if ((v71 == (1334 - (605 + 728))) or ((2625 + 1054) < (1389 - 764))) then
					if ((v72.name == "Wild Imp") or ((212 + 4413) < (2336 - 1704))) then
						v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount + 1 + 0;
						v73 = v72.duration;
					elseif ((v72.name == "Felguard") or ((229 - 146) > (1344 + 436))) then
						v10.GuardiansTable.FelguardDuration = v72.duration;
						v73 = v72.duration;
					elseif (((1035 - (457 + 32)) <= (457 + 620)) and (v72.name == "Dreadstalker")) then
						local v107 = 1402 - (832 + 570);
						while true do
							if ((v107 == (0 + 0)) or ((260 + 736) > (15220 - 10919))) then
								v10.GuardiansTable.DreadstalkerDuration = v72.duration;
								v73 = v72.duration;
								break;
							end
						end
					elseif (((1961 + 2109) > (1483 - (588 + 208))) and (v72.name == "Demonic Tyrant")) then
						if ((v52 == (714739 - 449552)) or ((2456 - (884 + 916)) >= (6971 - 3641))) then
							local v117 = 0 + 0;
							while true do
								if ((v117 == (653 - (232 + 421))) or ((4381 - (1569 + 320)) <= (83 + 252))) then
									v10.GuardiansTable.DemonicTyrantDuration = v72.duration;
									v73 = v72.duration;
									break;
								end
							end
						end
					elseif (((822 + 3500) >= (8633 - 6071)) and (v72.name == "Vilefiend")) then
						v10.GuardiansTable.VilefiendDuration = v72.duration;
						v73 = v72.duration;
					elseif ((v72.name == "Pit Lord") or ((4242 - (316 + 289)) >= (9868 - 6098))) then
						local v123 = 0 + 0;
						while true do
							if ((v123 == (1453 - (666 + 787))) or ((2804 - (360 + 65)) > (4279 + 299))) then
								v10.GuardiansTable.PitLordDuration = v72.duration;
								v73 = v72.duration;
								break;
							end
						end
					elseif ((v72.name == "Infernal") or ((737 - (79 + 175)) > (1171 - 428))) then
						local v129 = 0 + 0;
						while true do
							if (((7522 - 5068) > (1113 - 535)) and (v129 == (899 - (503 + 396)))) then
								v10.GuardiansTable.InfernalDuration = v72.duration;
								v73 = v72.duration;
								break;
							end
						end
					elseif (((1111 - (92 + 89)) < (8648 - 4190)) and (v72.name == "Blasphemy")) then
						v10.GuardiansTable.BlasphemyDuration = v72.duration;
						v73 = v72.duration;
					elseif (((340 + 322) <= (576 + 396)) and (v72.name == "Darkglare")) then
						local v142 = 0 - 0;
						while true do
							if (((598 + 3772) == (9964 - 5594)) and (v142 == (0 + 0))) then
								v10.GuardiansTable.DarkglareDuration = v72.duration;
								v73 = v72.duration;
								break;
							end
						end
					end
					v74 = {ID=v51,name=v72.name,spawnTime=GetTime(),ImpCasts=(3 + 2),Duration=v73,despawnTime=(GetTime() + tonumber(v73))};
					v71 = 5 - 3;
				end
				if ((v71 == (0 + 0)) or ((7261 - 2499) <= (2105 - (485 + 759)))) then
					v72 = v39[v53];
					v73 = nil;
					v71 = 2 - 1;
				end
			end
		end
		if ((v39[v53] and (v39[v53].name == "Demonic Tyrant")) or ((2601 - (442 + 747)) == (5399 - (832 + 303)))) then
			for v79, v80 in pairs(v10.GuardiansTable.Pets) do
				if ((v80 and (v80.name ~= "Demonic Tyrant") and (v80.name ~= "Pit Lord")) or ((4114 - (88 + 858)) < (657 + 1496))) then
					v80.despawnTime = v80.despawnTime + 13 + 2;
					v80.ImpCasts = v80.ImpCasts + 1 + 6;
				end
			end
		end
		if ((v53 == (144411 - (766 + 23))) or ((24565 - 19589) < (1821 - 489))) then
			v10.GuardiansTable.InnerDemonsNextCast = GetTime() + (31 - 19);
		end
		if (((15707 - 11079) == (5701 - (1036 + 37))) and (v53 == (39461 + 16198)) and (v10.GuardiansTable.ImpsSpawnedFromHoG > (0 - 0))) then
			v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG - (1 + 0);
		end
		v23.UpdatePetTable();
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v10:RegisterForCombatEvent(function(...)
		local v54 = 1480 - (641 + 839);
		local v55;
		local v56;
		local v57;
		local v58;
		while true do
			if ((v54 == (914 - (910 + 3))) or ((137 - 83) == (2079 - (1466 + 218)))) then
				if (((38 + 44) == (1230 - (556 + 592))) and (v55 == v13:GUID()) and (v58 == (69796 + 126481))) then
					for v88, v89 in pairs(v10.GuardiansTable.Pets) do
						if ((v89.name == "Wild Imp") or ((1389 - (329 + 479)) < (1136 - (174 + 680)))) then
							v10.GuardiansTable.Pets[v88] = nil;
						end
					end
					v10.GuardiansTable.ImpCount = 0 - 0;
				end
				v23.UpdatePetTable();
				break;
			end
			if ((v54 == (0 - 0)) or ((3291 + 1318) < (3234 - (396 + 343)))) then
				v55, v56, v56, v56, v57, v56, v56, v56, v58 = select(1 + 3, ...);
				if (((2629 - (29 + 1448)) == (2541 - (135 + 1254))) and (v58 == (392989 - 288671))) then
					for v90, v91 in pairs(v10.GuardiansTable.Pets) do
						if (((8852 - 6956) <= (2281 + 1141)) and (v55 == v91.ID)) then
							v91.ImpCasts = v91.ImpCasts - (1528 - (389 + 1138));
						end
					end
				end
				v54 = 575 - (102 + 472);
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v23.LastPI = 0 + 0;
	v10:RegisterForCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(5 + 3, ...);
		if (((SpellID == (9381 + 679)) and (DestGUID == v13:GUID())) or ((2535 - (320 + 1225)) > (2883 - 1263))) then
			v23.LastPI = GetTime();
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v23.SoulShards = 0 + 0;
	v23.UpdateSoulShards = function()
		v23.SoulShards = v13:SoulShards();
	end;
	v10:RegisterForSelfCombatEvent(function(v60, v61, v60, v60, v60, v60, v60, v60, v60, v60, v60, v62)
		if ((v62 == (106638 - (157 + 1307))) or ((2736 - (821 + 1038)) > (11713 - 7018))) then
			v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG + (((v23.SoulShards >= (1 + 2)) and (4 - 1)) or v23.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Warlock_Warlock.lua"]();

