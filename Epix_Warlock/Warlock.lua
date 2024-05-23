local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((3125 + 766) >= (3646 - 2112)) and not v5) then
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
	if (((5694 - 1752) == (5540 - 1598)) and not v15.Warlock) then
		v15.Warlock = {};
	end
	v15.Warlock.Commons = {Berserking=v15(73486 - 47189, nil, 286 - (134 + 151)),AncestralCall=v15(276403 - (970 + 695)),BloodFury=v15(64310 - 30608, nil, 1992 - (582 + 1408)),Fireblood=v15(919806 - 654585, nil, 3 - 0),Corruption=v15(648 - 476, nil, 1828 - (1195 + 629)),DarkPact=v15(143379 - 34963, nil, 246 - (187 + 54)),ShadowBolt=v15(1466 - (162 + 618), nil, 5 + 1),SummonDarkglare=v15(136659 + 68521, nil, 14 - 7),UnendingResolve=v15(176143 - 71370, nil, 1 + 7),GrimoireofSacrifice=v15(110139 - (1373 + 263), nil, 1009 - (451 + 549)),GrimoireofSacrificeBuff=v15(61901 + 134198, nil, 15 - 5),SoulConduit=v15(362923 - 146982, nil, 1395 - (746 + 638)),SummonSoulkeeper=v15(145363 + 240893, nil, 17 - 5),InquisitorsGaze=v15(386685 - (218 + 123), nil, 1594 - (1535 + 46)),InquisitorsGazeBuff=v15(385585 + 2483, nil, 3 + 11),Soulburn=v15(386459 - (306 + 254), nil, 1 + 14),PowerInfusionBuff=v15(19743 - 9683, nil, 1483 - (899 + 568)),AxeToss=v15(78820 + 41094, nil, 40 - 23),Seduction=v15(120512 - (268 + 335), nil, 308 - (60 + 230)),ShadowBulwark=v15(120479 - (426 + 146), nil, 3 + 16),SingeMagic=v15(121361 - (282 + 1174), nil, 831 - (569 + 242)),SpellLock=v15(345412 - 225502, nil, 2 + 19),BurningRush=v15(112424 - (706 + 318), nil, 1806 - (721 + 530))};
	v15.Warlock.Demonology = v18(v15.Warlock.Commons, {Felstorm=v15(91022 - (945 + 326), nil, 54 - 32),HandofGuldan=v15(93586 + 11588, nil, 723 - (271 + 429)),ShadowBoltLineCD=v15(631 + 55, nil, 1506 - (1408 + 92)),SummonPet=v15(31232 - (461 + 625), nil, 1312 - (993 + 295)),BilescourgeBombers=v15(13876 + 253335, nil, 1196 - (418 + 753)),CallDreadstalkers=v15(39730 + 64586, nil, 3 + 23),Demonbolt=v15(77268 + 186910, nil, 7 + 20),DemonicCalling=v15(205674 - (406 + 123), nil, 1797 - (1749 + 20)),DemonicStrength=v15(63461 + 203710, nil, 1351 - (1249 + 73)),Doom=v15(216 + 387, nil, 1175 - (466 + 679)),FelDomination=v15(803159 - 469270, nil, 88 - 57),FelCovenant=v15(389332 - (106 + 1794), nil, 11 + 21),FromtheShadows=v15(67535 + 199635, nil, 97 - 64),GrimoireFelguard=v15(303012 - 191114, nil, 148 - (4 + 110)),Guillotine=v15(387417 - (57 + 527), nil, 1462 - (41 + 1386)),ImpGangBoss=v15(387548 - (17 + 86), nil, 25 + 11),Implosion=v15(437719 - 241442, nil, 107 - 70),InnerDemons=v15(267382 - (122 + 44), nil, 65 - 27),NetherPortal=v15(886484 - 619267, nil, 32 + 7),PowerSiphon=v15(38200 + 225930, nil, 81 - 41),SacrificedSouls=v15(267279 - (30 + 35), nil, 29 + 12),SoulboundTyrant=v15(335842 - (1043 + 214), nil, 158 - 116),SoulStrike=v15(265269 - (323 + 889), nil, 115 - 72),SummonDemonicTyrant=v15(265767 - (361 + 219), nil, 364 - (53 + 267)),SummonVilefiend=v15(59670 + 204449, nil, 458 - (15 + 398)),TheExpendables=v15(388582 - (18 + 964), nil, 173 - 127),ReignofTyranny=v15(247613 + 180071, nil, 84 + 48),GrandWarlocksDesign=v15(387934 - (20 + 830), nil, 104 + 29),DemonicCallingBuff=v15(205272 - (116 + 10), nil, 4 + 43),DemonicCoreBuff=v15(264911 - (542 + 196), nil, 102 - 54),DemonicPowerBuff=v15(77464 + 187809, nil, 25 + 24),FelCovenantBuff=v15(139465 + 247972, nil, 131 - 81),NetherPortalBuff=v15(685090 - 417872, nil, 1602 - (1126 + 425)),DoomDebuff=v15(1008 - (118 + 287), nil, 203 - 151),FromtheShadowsDebuff=v15(271690 - (118 + 1003), nil, 155 - 102),DoomBrandDebuff=v15(423960 - (142 + 235))});
	v15.Warlock.Affliction = v18(v15.Warlock.Commons, {Agony=v15(4445 - 3465, nil, 12 + 42),DrainLife=v15(235130 - (553 + 424), nil, 103 - 48),SummonPet=v15(607 + 81, nil, 56 + 0),AbsoluteCorruption=v15(114183 + 81920, nil, 25 + 32),DoomBlossom=v15(222583 + 167181),DrainSoul=v15(430522 - 231932, nil, 161 - 103),DreadTouch=v15(872722 - 482947, nil, 18 + 41),Haunt=v15(232842 - 184661, nil, 813 - (239 + 514)),InevitableDemise=v15(117417 + 216902, nil, 1390 - (797 + 532)),MaleficAffliction=v15(283207 + 106554, nil, 21 + 41),MaleficRapture=v15(763066 - 438530, nil, 1265 - (373 + 829)),Nightfall=v15(109289 - (476 + 255), nil, 1194 - (369 + 761)),PhantomSingularity=v15(118691 + 86488, nil, 118 - 53),SowTheSeeds=v15(371848 - 175622, nil, 304 - (64 + 174)),SeedofCorruption=v15(3881 + 23362, nil, 98 - 31),ShadowEmbrace=v15(27579 - (144 + 192), nil, 284 - (42 + 174)),SiphonLife=v15(47408 + 15698, nil, 58 + 11),SoulRot=v15(164413 + 222584, nil, 1574 - (363 + 1141)),SoulSwap=v15(388531 - (1183 + 397), nil, 216 - 145),SoulTap=v15(283743 + 103330, nil, 54 + 18),SouleatersGluttony=v15(391605 - (1913 + 62), nil, 46 + 27),SowtheSeeds=v15(519469 - 323243, nil, 2007 - (565 + 1368)),TormentedCrescendo=v15(1455686 - 1068611, nil, 1736 - (1477 + 184)),UnstableAffliction=v15(430710 - 114611, nil, 71 + 5),VileTaint=v15(279206 - (564 + 292), nil, 132 - 55),InevitableDemiseBuff=v15(1007696 - 673376, nil, 382 - (244 + 60)),NightfallBuff=v15(203432 + 61139, nil, 555 - (41 + 435)),MaleficAfflictionBuff=v15(390846 - (938 + 63), nil, 62 + 18),TormentedCrescendoBuff=v15(388204 - (936 + 189), nil, 27 + 54),UmbrafireKindlingBuff=v15(425378 - (1565 + 48)),AgonyDebuff=v15(606 + 374, nil, 1220 - (782 + 356)),CorruptionDebuff=v15(147006 - (176 + 91), nil, 216 - 133),HauntDebuff=v15(71009 - 22828, nil, 1176 - (975 + 117)),PhantomSingularityDebuff=v15(207054 - (157 + 1718), nil, 69 + 16),SeedofCorruptionDebuff=v15(96710 - 69467, nil, 293 - 207),SiphonLifeDebuff=v15(64124 - (697 + 321), nil, 236 - 149),UnstableAfflictionDebuff=v15(669690 - 353591, nil, 202 - 114),VileTaintDebuff=v15(108346 + 170004, nil, 166 - 77),SoulRotDebuff=v15(1037427 - 650430, nil, 1317 - (322 + 905)),DreadTouchDebuff=v15(390479 - (602 + 9), nil, 1280 - (449 + 740)),ShadowEmbraceDebuff=v15(33262 - (826 + 46), nil, 1039 - (245 + 702))});
	v15.Warlock.Destruction = v18(v15.Warlock.Commons, {Immolate=v15(1099 - 751, nil, 30 + 63),Incinerate=v15(31620 - (260 + 1638), nil, 534 - (382 + 58)),SummonPet=v15(2206 - 1518, nil, 79 + 16),AshenRemains=v15(800333 - 413081, nil, 284 - 188),AvatarofDestruction=v15(388364 - (902 + 303), nil, 212 - 115),Backdraft=v15(473044 - 276638, nil, 9 + 89),BurntoAshes=v15(388843 - (1121 + 569), nil, 313 - (22 + 192)),Cataclysm=v15(152791 - (483 + 200), nil, 1563 - (1404 + 59)),ChannelDemonfire=v15(537623 - 341176, nil, 135 - 34),ChaosBolt=v15(117623 - (468 + 297), nil, 664 - (334 + 228)),ChaosIncarnate=v15(1306273 - 918998),Chaosbringer=v15(978289 - 556232),Conflagrate=v15(32575 - 14613, nil, 30 + 73),CrashingChaos=v15(417470 - (141 + 95)),CryHavoc=v15(380666 + 6856, nil, 267 - 163),DiabolicEmbers=v15(930730 - 543557, nil, 25 + 80),DimensionalRift=v15(1063007 - 675031, nil, 75 + 31),Eradication=v15(102277 + 94135, nil, 149 - 42),FireandBrimstone=v15(115853 + 80555, nil, 271 - (92 + 71)),Havoc=v15(39635 + 40605, nil, 182 - 73),Inferno=v15(271310 - (574 + 191), nil, 91 + 19),InternalCombustion=v15(666746 - 400612, nil, 57 + 54),MadnessoftheAzjAqir=v15(388249 - (254 + 595), nil, 238 - (55 + 71)),Mayhem=v15(510497 - 122991, nil, 1903 - (573 + 1217)),RagingDemonfire=v15(1072225 - 685059, nil, 9 + 105),RainofChaos=v15(428770 - 162684, nil, 1054 - (714 + 225)),RainofFire=v15(16774 - 11034, nil, 160 - 44),RoaringBlaze=v15(22214 + 182970, nil, 169 - 52),Ruin=v15(387909 - (118 + 688), nil, 166 - (25 + 23)),SoulFire=v15(1231 + 5122, nil, 2005 - (927 + 959)),SummonInfernal=v15(3781 - 2659, nil, 852 - (16 + 716)),BackdraftBuff=v15(227455 - 109627, nil, 218 - (11 + 86)),MadnessCBBuff=v15(944956 - 557547, nil, 407 - (175 + 110)),MadnessRoFBuff=v15(978138 - 590725),MadnessSBBuff=v15(1910822 - 1523408),RainofChaosBuff=v15(267883 - (503 + 1293), nil, 343 - 220),RitualofRuinBuff=v15(279978 + 107179, nil, 1185 - (810 + 251)),BurntoAshesBuff=v15(268677 + 118477, nil, 39 + 86),EradicationDebuff=v15(177059 + 19355, nil, 659 - (43 + 490)),ConflagrateDebuff=v15(266664 - (711 + 22)),HavocDebuff=v15(310384 - 230144, nil, 986 - (240 + 619)),ImmolateDebuff=v15(38064 + 119672, nil, 203 - 75),PyrogenicsDebuff=v15(25619 + 361477),RoaringBlazeDebuff=v15(267675 - (1344 + 400), nil, 534 - (255 + 150))});
	if (not v17.Warlock or ((2586 + 696) > (2531 + 2196))) then
		v17.Warlock = {};
	end
	v17.Warlock.Commons = {Healthstone=v17(89 - 68),PotionOfWitheringDreams=v17(668726 - 461685),ConjuredChillglobe=v17(196039 - (404 + 1335), {(15 - 2),(6 + 8)}),DesperateInvokersCodex=v17(194647 - (10 + 327), {(351 - (118 + 220)),(463 - (108 + 341))}),TimebreachingTalon=v17(87039 + 106752, {(1506 - (711 + 782)),(483 - (270 + 199))}),TimeThiefsGambit=v17(67295 + 140284, {(38 - 25),(1 + 13)}),BelorrelostheSuncaller=v17(90250 + 116922, {(9 + 4),(1804 - (1010 + 780))}),Iridal=v17(208218 + 103, {(46 - 30)}),NymuesUnravelingSpindle=v17(210451 - (1045 + 791), {(19 - 6),(1588 - (1281 + 293))})};
	v17.Warlock.Affliction = v18(v17.Warlock.Commons, {});
	v17.Warlock.Demonology = v18(v17.Warlock.Commons, {});
	v17.Warlock.Destruction = v18(v17.Warlock.Commons, {});
	if (not v21.Warlock or ((4245 - (28 + 238)) < (7724 - 4267))) then
		v21.Warlock = {};
	end
	v21.Warlock.Commons = {Healthstone=v21(1580 - (1381 + 178)),HealingPotion=v21(10 + 0),ConjuredChillglobe=v21(18 + 4),DesperateInvokersCodex=v21(10 + 13),TimebreachingTalon=v21(82 - 58),AxeTossMouseover=v21(13 + 11),CorruptionMouseover=v21(495 - (381 + 89)),SpellLockMouseover=v21(24 + 2),ShadowBoltPetAttack=v21(19 + 8),IridialStaff=v21(68 - 28),CancelBurningRush=v21(1197 - (1074 + 82))};
	v21.Warlock.Affliction = v18(v21.Warlock.Commons, {AgonyMouseover=v21(61 - 33),VileTaintCursor=v21(1813 - (214 + 1570))});
	v21.Warlock.Demonology = v18(v21.Warlock.Commons, {DemonboltPetAttack=v21(1485 - (990 + 465)),DoomMouseover=v21(13 + 18),GuillotineCursor=v21(14 + 18)});
	v21.Warlock.Destruction = v18(v21.Warlock.Commons, {HavocMouseover=v21(33 + 0),ImmolateMouseover=v21(133 - 99),ImmolatePetAttack=v21(1761 - (1668 + 58)),RainofFireCursor=v21(662 - (512 + 114)),SummonInfernalCursor=v21(96 - 59)});
	v9.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v9.GuardiansTable = {Pets={},ImpCount=(0 - 0),FelguardDuration=(0 - 0),DreadstalkerDuration=(0 + 0),DemonicTyrantDuration=(0 + 0),VilefiendDuration=(0 + 0),PitLordDuration=(0 - 0),Infernal=(1994 - (109 + 1885)),Blasphemy=(1469 - (1269 + 200)),DarkglareDuration=(0 - 0),InnerDemonsNextCast=(815 - (98 + 717)),ImpsSpawnedFromHoG=(826 - (802 + 24))};
	local v38 = {[169064 - 71029]={name="Dreadstalker",duration=(14.25 - 2)},[8220 + 47439]={name="Wild Imp",duration=(16 + 4)},[23591 + 120031]={name="Wild Imp",duration=(5 + 15)},[47993 - 30741]={name="Felguard",duration=(56 - 39)},[48286 + 86716]={name="Demonic Tyrant",duration=(7 + 8)},[112030 + 23786]={name="Vilefiend",duration=(11 + 4)},[91562 + 104549]={name="Pit Lord",duration=(1443 - (797 + 636))},[432 - 343]={name="Infernal",duration=(1649 - (1427 + 192))},[64304 + 121280]={name="Blasphemy",duration=(18 - 10)},[93189 + 10484]={name="Darkglare",duration=(12 + 13)}};
	v9:RegisterForSelfCombatEvent(function(...)
		local v43 = 326 - (192 + 134);
		while true do
			if (((1704 - (316 + 960)) < (1004 + 800)) and (v43 == (0 + 0))) then
				DestGUID, _, _, _, SpellID = select(8 + 0, ...);
				if ((SpellID == (603025 - 445289)) or ((3876 - (83 + 468)) > (6419 - (1202 + 604)))) then
					v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 0 - 0;
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v9:RegisterForSelfCombatEvent(function(...)
		local v44 = 0 - 0;
		while true do
			if ((v44 == (0 - 0)) or ((5275 - (45 + 280)) <= (4395 + 158))) then
				DestGUID, _, _, _, SpellID = select(7 + 1, ...);
				if (((974 + 1691) <= (2177 + 1756)) and (SpellID == (27745 + 129991))) then
					if (((6060 - 2787) == (5184 - (340 + 1571))) and v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
						v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED");
	v9:RegisterForCombatEvent(function(...)
		DestGUID = select(4 + 4, ...);
		if (((5596 - (1733 + 39)) > (1123 - 714)) and v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
			v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v9:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(1042 - (125 + 909), ...);
		if (((4035 - (1096 + 852)) == (937 + 1150)) and (SpellID == (25651 - 7689))) then
			if (v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((3302 + 102) > (5015 - (409 + 103)))) then
				v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + (237 - (46 + 190));
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v22.UpdatePetTable = function()
		for v64, v65 in pairs(v9.GuardiansTable.Pets) do
			local v66 = 95 - (51 + 44);
			while true do
				if ((v66 == (1 + 0)) or ((4823 - (1114 + 203)) <= (2035 - (228 + 498)))) then
					if (((641 + 2314) == (1633 + 1322)) and (GetTime() <= v65.despawnTime)) then
						local v83 = 663 - (174 + 489);
						while true do
							if ((v83 == (0 - 0)) or ((4808 - (830 + 1075)) == (2019 - (303 + 221)))) then
								v65.Duration = v65.despawnTime - GetTime();
								if (((5815 - (231 + 1038)) >= (1896 + 379)) and (v65.name == "Felguard")) then
									v9.GuardiansTable.FelguardDuration = v65.Duration;
								elseif (((1981 - (171 + 991)) >= (90 - 68)) and (v65.name == "Dreadstalker")) then
									v9.GuardiansTable.DreadstalkerDuration = v65.Duration;
								elseif (((8490 - 5328) == (7890 - 4728)) and (v65.name == "Demonic Tyrant")) then
									v9.GuardiansTable.DemonicTyrantDuration = v65.Duration;
								elseif ((v65.name == "Vilefiend") or ((1897 + 472) > (15525 - 11096))) then
									v9.GuardiansTable.VilefiendDuration = v65.Duration;
								elseif (((11813 - 7718) >= (5130 - 1947)) and (v65.name == "Pit Lord")) then
									v9.GuardiansTable.PitLordDuration = v65.Duration;
								elseif ((v65.name == "Infernal") or ((11471 - 7760) < (2256 - (111 + 1137)))) then
									v9.GuardiansTable.InfernalDuration = v65.Duration;
								elseif ((v65.name == "Blasphy") or ((1207 - (91 + 67)) <= (2696 - 1790))) then
									v9.GuardiansTable.BlasphemyDuration = v65.Duration;
								elseif (((1127 + 3386) > (3249 - (423 + 100))) and (v65.name == "Darkglare")) then
									v9.GuardiansTable.DarkglareDuration = v65.Duration;
								end
								break;
							end
						end
					end
					break;
				end
				if ((v66 == (0 + 0)) or ((4100 - 2619) >= (1386 + 1272))) then
					if (v65 or ((3991 - (326 + 445)) == (5952 - 4588))) then
						if ((GetTime() >= v65.despawnTime) or ((2347 - 1293) > (7917 - 4525))) then
							if ((v65.name == "Wild Imp") or ((1387 - (530 + 181)) >= (2523 - (614 + 267)))) then
								v9.GuardiansTable.ImpCount = v9.GuardiansTable.ImpCount - (33 - (19 + 13));
							end
							if (((6731 - 2595) > (5585 - 3188)) and (v65.name == "Felguard")) then
								v9.GuardiansTable.FelguardDuration = 0 - 0;
							elseif ((v65.name == "Dreadstalker") or ((1126 + 3208) == (7465 - 3220))) then
								v9.GuardiansTable.DreadstalkerDuration = 0 - 0;
							elseif ((v65.name == "Demonic Tyrant") or ((6088 - (1293 + 519)) <= (6183 - 3152))) then
								v9.GuardiansTable.DemonicTyrantDuration = 0 - 0;
							elseif ((v65.name == "Vilefiend") or ((9144 - 4362) <= (5170 - 3971))) then
								v9.GuardiansTable.VilefiendDuration = 0 - 0;
							elseif ((v65.name == "Pit Lord") or ((2577 + 2287) < (389 + 1513))) then
								v9.GuardiansTable.PitLordDuration = 0 - 0;
							elseif (((1119 + 3720) >= (1230 + 2470)) and (v65.name == "Infernal")) then
								v9.GuardiansTable.InfernalDuration = 0 + 0;
							elseif ((v65.name == "Blasphemy") or ((2171 - (709 + 387)) > (3776 - (673 + 1185)))) then
								v9.GuardiansTable.BlasphemyDuration = 0 - 0;
							elseif (((1271 - 875) <= (6258 - 2454)) and (v65.name == "Darkglare")) then
								v9.GuardiansTable.DarkglareDuration = 0 + 0;
							end
							v9.GuardiansTable.Pets[v64] = nil;
						end
					end
					if ((v65.ImpCasts <= (0 + 0)) or ((5628 - 1459) == (538 + 1649))) then
						local v84 = 0 - 0;
						while true do
							if (((2759 - 1353) == (3286 - (446 + 1434))) and (v84 == (1283 - (1040 + 243)))) then
								v9.GuardiansTable.ImpCount = v9.GuardiansTable.ImpCount - (2 - 1);
								v9.GuardiansTable.Pets[v64] = nil;
								break;
							end
						end
					end
					v66 = 1848 - (559 + 1288);
				end
			end
		end
	end;
	v9:RegisterForSelfCombatEvent(function(...)
		local v45, v46, v47, v48, v47, v47, v47, v49, v47, v47, v47, v50 = select(1932 - (609 + 1322), ...);
		local v47, v47, v47, v47, v47, v47, v47, v51 = v19(v49, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
		v51 = tonumber(v51);
		if (((1985 - (13 + 441)) < (15959 - 11688)) and (v49 ~= UnitGUID("pet")) and (v46 == "SPELL_SUMMON") and v38[v51]) then
			local v68 = v38[v51];
			local v69;
			if (((1663 - 1028) == (3162 - 2527)) and (v68.name == "Wild Imp")) then
				local v78 = 0 + 0;
				while true do
					if (((12250 - 8877) <= (1264 + 2292)) and (v78 == (0 + 0))) then
						v9.GuardiansTable.ImpCount = v9.GuardiansTable.ImpCount + (2 - 1);
						v69 = v68.duration;
						break;
					end
				end
			elseif ((v68.name == "Felguard") or ((1801 + 1490) < (6032 - 2752))) then
				local v85 = 0 + 0;
				while true do
					if (((2440 + 1946) >= (628 + 245)) and (v85 == (0 + 0))) then
						v9.GuardiansTable.FelguardDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			elseif (((902 + 19) <= (1535 - (153 + 280))) and (v68.name == "Dreadstalker")) then
				v9.GuardiansTable.DreadstalkerDuration = v68.duration;
				v69 = v68.duration;
			elseif (((13588 - 8882) >= (865 + 98)) and (v68.name == "Demonic Tyrant")) then
				if ((v50 == (104707 + 160480)) or ((503 + 457) <= (795 + 81))) then
					local v108 = 0 + 0;
					while true do
						if ((v108 == (0 - 0)) or ((1277 + 789) == (1599 - (89 + 578)))) then
							v9.GuardiansTable.DemonicTyrantDuration = v68.duration;
							v69 = v68.duration;
							break;
						end
					end
				end
			elseif (((3447 + 1378) < (10067 - 5224)) and (v68.name == "Vilefiend")) then
				local v109 = 1049 - (572 + 477);
				while true do
					if ((v109 == (0 + 0)) or ((2327 + 1550) >= (542 + 3995))) then
						v9.GuardiansTable.VilefiendDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			elseif ((v68.name == "Pit Lord") or ((4401 - (84 + 2)) < (2844 - 1118))) then
				local v113 = 0 + 0;
				while true do
					if ((v113 == (842 - (497 + 345))) or ((95 + 3584) < (106 + 519))) then
						v9.GuardiansTable.PitLordDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			elseif ((v68.name == "Infernal") or ((5958 - (605 + 728)) < (451 + 181))) then
				v9.GuardiansTable.InfernalDuration = v68.duration;
				v69 = v68.duration;
			elseif ((v68.name == "Blasphemy") or ((184 - 101) > (82 + 1698))) then
				local v128 = 0 - 0;
				while true do
					if (((493 + 53) <= (2983 - 1906)) and (v128 == (0 + 0))) then
						v9.GuardiansTable.BlasphemyDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			elseif ((v68.name == "Darkglare") or ((1485 - (457 + 32)) > (1825 + 2476))) then
				local v132 = 1402 - (832 + 570);
				while true do
					if (((3835 + 235) > (180 + 507)) and (v132 == (0 - 0))) then
						v9.GuardiansTable.DarkglareDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			end
			local v70 = {ID=v49,name=v68.name,spawnTime=GetTime(),ImpCasts=(3 + 2),Duration=v69,despawnTime=(GetTime() + tonumber(v69))};
			table.insert(v9.GuardiansTable.Pets, v70);
		end
		if ((v38[v51] and (v38[v51].name == "Demonic Tyrant")) or ((1452 - (588 + 208)) >= (8975 - 5645))) then
			for v75, v76 in pairs(v9.GuardiansTable.Pets) do
				if ((v76 and (v76.name ~= "Demonic Tyrant") and (v76.name ~= "Pit Lord")) or ((4292 - (884 + 916)) <= (701 - 366))) then
					v76.despawnTime = v76.despawnTime + 9 + 6;
					v76.ImpCasts = v76.ImpCasts + (660 - (232 + 421));
				end
			end
		end
		if (((6211 - (1569 + 320)) >= (629 + 1933)) and (v51 == (27287 + 116335))) then
			v9.GuardiansTable.InnerDemonsNextCast = GetTime() + (40 - 28);
		end
		if (((v51 == (56264 - (316 + 289))) and (v9.GuardiansTable.ImpsSpawnedFromHoG > (0 - 0))) or ((168 + 3469) >= (5223 - (666 + 787)))) then
			v9.GuardiansTable.ImpsSpawnedFromHoG = v9.GuardiansTable.ImpsSpawnedFromHoG - (426 - (360 + 65));
		end
		v22.UpdatePetTable();
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v9:RegisterForCombatEvent(function(...)
		local v52 = 0 + 0;
		local v53;
		local v54;
		local v55;
		local v56;
		while true do
			if (((255 - (79 + 175)) == v52) or ((3750 - 1371) > (3573 + 1005))) then
				if (((v53 == v12:GUID()) and (v56 == (601643 - 405366))) or ((930 - 447) > (1642 - (503 + 396)))) then
					for v86, v87 in pairs(v9.GuardiansTable.Pets) do
						if (((2635 - (92 + 89)) > (1120 - 542)) and (v87.name == "Wild Imp")) then
							v9.GuardiansTable.Pets[v86] = nil;
						end
					end
					v9.GuardiansTable.ImpCount = 0 + 0;
				end
				v22.UpdatePetTable();
				break;
			end
			if (((551 + 379) < (17458 - 13000)) and (v52 == (0 + 0))) then
				v53, v54, v54, v54, v55, v54, v54, v54, v56 = select(8 - 4, ...);
				if (((578 + 84) <= (465 + 507)) and (v56 == (317718 - 213400))) then
					for v88, v89 in pairs(v9.GuardiansTable.Pets) do
						if (((546 + 3824) == (6664 - 2294)) and (v53 == v89.ID)) then
							v89.ImpCasts = v89.ImpCasts - (1245 - (485 + 759));
						end
					end
				end
				v52 = 2 - 1;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v22.LastPI = 1189 - (442 + 747);
	v9:RegisterForCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(1143 - (832 + 303), ...);
		if (((SpellID == (11006 - (88 + 858))) and (DestGUID == v12:GUID())) or ((1452 + 3310) <= (713 + 148))) then
			v22.LastPI = GetTime();
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v22.SoulShards = 0 + 0;
	v22.UpdateSoulShards = function()
		v22.SoulShards = v12:SoulShards();
	end;
	v9:RegisterForSelfCombatEvent(function(v58, v59, v58, v58, v58, v58, v58, v58, v58, v58, v58, v60)
		if ((v60 == (105963 - (766 + 23))) or ((6970 - 5558) == (5831 - 1567))) then
			v9.GuardiansTable.ImpsSpawnedFromHoG = v9.GuardiansTable.ImpsSpawnedFromHoG + (((v22.SoulShards >= (7 - 4)) and (10 - 7)) or v22.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Warlock_Warlock.lua"]();

