local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (((5880 - 3640) > (1035 - (39 + 896))) and not v6) then
		return v2(v5, v0, ...);
	end
	return v6(v0, ...);
end
v1["Epix_Warlock_Warlock.lua"] = function(...)
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
	if (not v16.Warlock or ((7657 - 4013) >= (7404 - 2740))) then
		v16.Warlock = {};
	end
	v16.Warlock.Commons = {Berserking=v16(73764 - 47467, nil, 1 + 0),AncestralCall=v16(174930 + 99808),BloodFury=v16(34098 - (115 + 281), nil, 4 - 2),Fireblood=v16(219588 + 45633, nil, 7 - 4),Corruption=v16(630 - 458, nil, 871 - (550 + 317)),DarkPact=v16(156637 - 48221, nil, 7 - 2),ShadowBolt=v16(1916 - 1230, nil, 291 - (134 + 151)),SummonDarkglare=v16(206845 - (970 + 695), nil, 12 - 5),UnendingResolve=v16(106763 - (582 + 1408), nil, 27 - 19),GrimoireofSacrifice=v16(136520 - 28017, nil, 33 - 24),GrimoireofSacrificeBuff=v16(197923 - (1195 + 629), nil, 13 - 3),SoulConduit=v16(216182 - (187 + 54), nil, 791 - (162 + 618)),SummonSoulkeeper=v16(270649 + 115607, nil, 8 + 4),InquisitorsGaze=v16(823956 - 437612, nil, 21 - 8),InquisitorsGazeBuff=v16(30343 + 357725, nil, 1650 - (1373 + 263)),Soulburn=v16(386899 - (451 + 549), nil, 5 + 10),PowerInfusionBuff=v16(15655 - 5595, nil, 26 - 10),AxeToss=v16(121298 - (746 + 638), nil, 7 + 10),Seduction=v16(182055 - 62146, nil, 359 - (218 + 123)),ShadowBulwark=v16(121488 - (1535 + 46), nil, 19 + 0),SingeMagic=v16(17351 + 102554, nil, 580 - (306 + 254)),SpellLock=v16(7424 + 112486, nil, 40 - 19),BurningRush=v16(112867 - (899 + 568), nil, 365 + 190)};
	v16.Warlock.Demonology = v19(v16.Warlock.Commons, {Felstorm=v16(217188 - 127437, nil, 625 - (268 + 335)),HandofGuldan=v16(105464 - (60 + 230), nil, 595 - (426 + 146)),ShadowBoltLineCD=v16(83 + 603, nil, 1462 - (282 + 1174)),SummonPet=v16(30957 - (569 + 242), nil, 68 - 44),BilescourgeBombers=v16(15281 + 251930, nil, 1049 - (706 + 318)),CallDreadstalkers=v16(105567 - (721 + 530), nil, 1297 - (945 + 326)),Demonbolt=v16(660000 - 395822, nil, 25 + 2),DemonicCalling=v16(205845 - (271 + 429), nil, 26 + 2),DemonicStrength=v16(268671 - (1408 + 92), nil, 1115 - (461 + 625)),Doom=v16(1891 - (993 + 295), nil, 2 + 28),FelDomination=v16(335060 - (418 + 753), nil, 12 + 19),FelCovenant=v16(39930 + 347502, nil, 10 + 22),FromtheShadows=v16(67521 + 199649, nil, 562 - (406 + 123)),GrimoireFelguard=v16(113667 - (1749 + 20), nil, 9 + 25),Guillotine=v16(388155 - (1249 + 73), nil, 13 + 22),ImpGangBoss=v16(388590 - (466 + 679), nil, 86 - 50),Implosion=v16(561388 - 365111, nil, 1937 - (106 + 1794)),InnerDemons=v16(84535 + 182681, nil, 10 + 28),NetherPortal=v16(788932 - 521715, nil, 105 - 66),PowerSiphon=v16(264244 - (4 + 110), nil, 624 - (57 + 527)),SacrificedSouls=v16(268641 - (41 + 1386), nil, 144 - (17 + 86)),SoulboundTyrant=v16(227085 + 107500, nil, 93 - 51),SoulStrike=v16(764694 - 500637, nil, 209 - (122 + 44)),SummonDemonicTyrant=v16(458065 - 192878, nil, 145 - 101),SummonVilefiend=v16(214857 + 49262, nil, 7 + 38),TheExpendables=v16(785222 - 397622, nil, 111 - (30 + 35)),ReignofTyranny=v16(293952 + 133732, nil, 1389 - (1043 + 214)),GrandWarlocksDesign=v16(1463431 - 1076347, nil, 1345 - (323 + 889)),DemonicCallingBuff=v16(552179 - 347033, nil, 627 - (361 + 219)),DemonicCoreBuff=v16(264493 - (53 + 267), nil, 11 + 37),DemonicPowerBuff=v16(265686 - (15 + 398), nil, 1031 - (18 + 964)),FelCovenantBuff=v16(1458358 - 1070921, nil, 29 + 21),NetherPortalBuff=v16(168358 + 98860, nil, 901 - (20 + 830)),DoomDebuff=v16(471 + 132, nil, 178 - (116 + 10)),FromtheShadowsDebuff=v16(19987 + 250582, nil, 791 - (542 + 196)),DoomBrandDebuff=v16(908038 - 484455),DrainLife=v16(68377 + 165776, nil, 28 + 27),DoomBrand=v16(152477 + 271107)});
	v16.Warlock.Affliction = v19(v16.Warlock.Commons, {Agony=v16(2582 - 1602, nil, 138 - 84),DrainLife=v16(235704 - (1126 + 425), nil, 460 - (118 + 287)),SummonPet=v16(2696 - 2008, nil, 1177 - (118 + 1003)),AbsoluteCorruption=v16(573881 - 377778, nil, 434 - (142 + 235)),DoomBlossom=v16(1768171 - 1378407),DrainSoul=v16(43211 + 155379, nil, 1035 - (553 + 424)),DreadTouch=v16(737047 - 347272, nil, 52 + 7),Haunt=v16(47795 + 386, nil, 35 + 25),InevitableDemise=v16(142116 + 192203, nil, 35 + 26),MaleficAffliction=v16(844960 - 455199, nil, 172 - 110),MaleficRapture=v16(726649 - 402113, nil, 19 + 44),Nightfall=v16(524623 - 416065, nil, 817 - (239 + 514)),PhantomSingularity=v16(72061 + 133118, nil, 1394 - (797 + 532)),SowTheSeeds=v16(142581 + 53645, nil, 23 + 43),SeedofCorruption=v16(64054 - 36811, nil, 1269 - (373 + 829)),ShadowEmbrace=v16(27974 - (476 + 255), nil, 1198 - (369 + 761)),SiphonLife=v16(36506 + 26600, nil, 124 - 55),SoulRot=v16(733361 - 346364, nil, 308 - (64 + 174)),SoulSwap=v16(55111 + 331840, nil, 104 - 33),SoulTap=v16(387409 - (144 + 192), nil, 288 - (42 + 174)),SouleatersGluttony=v16(292704 + 96926, nil, 61 + 12),SowtheSeeds=v16(83366 + 112860, nil, 1578 - (363 + 1141)),TormentedCrescendo=v16(388655 - (1183 + 397), nil, 228 - 153),UnstableAffliction=v16(231716 + 84383, nil, 57 + 19),VileTaint=v16(280325 - (1913 + 62), nil, 49 + 28),InevitableDemiseBuff=v16(885046 - 550726, nil, 2011 - (565 + 1368)),NightfallBuff=v16(994981 - 730410, nil, 1740 - (1477 + 184)),MaleficAfflictionBuff=v16(531195 - 141350, nil, 75 + 5),TormentedCrescendoBuff=v16(387935 - (564 + 292), nil, 139 - 58),UmbrafireKindlingBuff=v16(1277299 - 853534),AgonyDebuff=v16(1284 - (244 + 60), nil, 64 + 18),CorruptionDebuff=v16(147215 - (41 + 435), nil, 1084 - (938 + 63)),HauntDebuff=v16(37055 + 11126, nil, 1209 - (936 + 189)),PhantomSingularityDebuff=v16(67525 + 137654, nil, 1698 - (1565 + 48)),SeedofCorruptionDebuff=v16(16829 + 10414, nil, 1224 - (782 + 356)),SiphonLifeDebuff=v16(63373 - (176 + 91), nil, 226 - 139),UnstableAfflictionDebuff=v16(465869 - 149770, nil, 1180 - (975 + 117)),VileTaintDebuff=v16(280225 - (157 + 1718), nil, 73 + 16),SoulRotDebuff=v16(1373809 - 986812, nil, 307 - 217),DreadTouchDebuff=v16(390886 - (697 + 321), nil, 247 - 156),ShadowEmbraceDebuff=v16(68621 - 36231, nil, 211 - 119)});
	v16.Warlock.Destruction = v19(v16.Warlock.Commons, {Immolate=v16(136 + 212, nil, 173 - 80),Incinerate=v16(79676 - 49954, nil, 1321 - (322 + 905)),SummonPet=v16(1299 - (602 + 9), nil, 1284 - (449 + 740)),AshenRemains=v16(388124 - (826 + 46), nil, 1043 - (245 + 702)),AvatarofDestruction=v16(1223406 - 836247, nil, 32 + 65),Backdraft=v16(198304 - (260 + 1638), nil, 538 - (382 + 58)),BurntoAshes=v16(1242014 - 854861, nil, 83 + 16),Cataclysm=v16(314361 - 162253, nil, 297 - 197),ChannelDemonfire=v16(197652 - (902 + 303), nil, 221 - 120),ChaosBolt=v16(281452 - 164594, nil, 9 + 93),ChaosIncarnate=v16(388965 - (1121 + 569)),Chaosbringer=v16(422271 - (22 + 192)),Conflagrate=v16(18645 - (483 + 200), nil, 1566 - (1404 + 59)),CrashingChaos=v16(1141860 - 724626),CryHavoc=v16(520840 - 133318, nil, 869 - (468 + 297)),DiabolicEmbers=v16(387735 - (334 + 228), nil, 354 - 249),DimensionalRift=v16(899293 - 511317, nil, 191 - 85),Eradication=v16(55774 + 140638, nil, 343 - (141 + 95)),FireandBrimstone=v16(192934 + 3474, nil, 277 - 169),Havoc=v16(192890 - 112650, nil, 26 + 83),Inferno=v16(741260 - 470715, nil, 78 + 32),InternalCombustion=v16(138583 + 127551, nil, 155 - 44),MadnessoftheAzjAqir=v16(228511 + 158889, nil, 275 - (92 + 71)),Mayhem=v16(191407 + 196099, nil, 189 - 76),RagingDemonfire=v16(387931 - (574 + 191), nil, 95 + 19),RainofChaos=v16(666626 - 400540, nil, 59 + 56),RainofFire=v16(6589 - (254 + 595), nil, 242 - (55 + 71)),RoaringBlaze=v16(270308 - 65124, nil, 1907 - (573 + 1217)),Ruin=v16(1072051 - 684948, nil, 9 + 109),SoulFire=v16(10237 - 3884, nil, 1058 - (714 + 225)),SummonInfernal=v16(3278 - 2156, nil, 167 - 47),BackdraftBuff=v16(12757 + 105071, nil, 174 - 53),MadnessCBBuff=v16(388215 - (118 + 688), nil, 170 - (25 + 23)),MadnessRoFBuff=v16(75037 + 312376),MadnessSBBuff=v16(389300 - (927 + 959)),RainofChaosBuff=v16(896951 - 630864, nil, 855 - (16 + 716)),RitualofRuinBuff=v16(747370 - 360213, nil, 221 - (11 + 86)),BurntoAshesBuff=v16(944334 - 557180, nil, 410 - (175 + 110)),EradicationDebuff=v16(495905 - 299491, nil, 621 - 495),ConflagrateDebuff=v16(267727 - (503 + 1293)),HavocDebuff=v16(224094 - 143854, nil, 92 + 35),ImmolateDebuff=v16(158797 - (810 + 251), nil, 89 + 39),PyrogenicsDebuff=v16(118801 + 268295),RoaringBlazeDebuff=v16(239725 + 26206, nil, 662 - (43 + 490))});
	if (not v18.Warlock or ((2102 - (711 + 22)) == (18284 - 13557))) then
		v18.Warlock = {};
	end
	v18.Warlock.Commons = {Healthstone=v18(880 - (240 + 619)),PotionOfWitheringDreams=v18(49962 + 157079),ConjuredChillglobe=v18(309073 - 114773, {(1757 - (1344 + 400)),(12 + 2)}),DesperateInvokersCodex=v18(104029 + 90281, {(41 - 28),(420 - (183 + 223))}),TimebreachingTalon=v18(235817 - 42026, {(5 + 8),(10 + 4)}),TimeThiefsGambit=v18(207917 - (118 + 220), {(462 - (108 + 341)),(59 - 45)}),BelorrelostheSuncaller=v18(208665 - (711 + 782), {(482 - (270 + 199)),(1833 - (580 + 1239))}),Iridal=v18(619293 - 410972, {(1 + 15)}),NymuesUnravelingSpindle=v18(90878 + 117737, {(9 + 4),(1804 - (1010 + 780))}),MirrorofFracturedTomorrows=v18(207479 + 102, {(38 - 25),(34 - 20)}),RubyWhelpShell=v18(295856 - 102099, {(1587 - (1281 + 293)),(31 - 17)}),WhisperingIncarnateIcon=v18(195860 - (1381 + 178), {(11 + 2),(48 - 34)})};
	v18.Warlock.Affliction = v19(v18.Warlock.Commons, {});
	v18.Warlock.Demonology = v19(v18.Warlock.Commons, {});
	v18.Warlock.Destruction = v19(v18.Warlock.Commons, {});
	if (not v22.Warlock or ((448 + 415) == (3927 - (381 + 89)))) then
		v22.Warlock = {};
	end
	v22.Warlock.Commons = {Healthstone=v22(19 + 2),HealingPotion=v22(7 + 3),ConjuredChillglobe=v22(37 - 15),DesperateInvokersCodex=v22(1179 - (1074 + 82)),TimebreachingTalon=v22(52 - 28),AxeTossMouseover=v22(1808 - (214 + 1570)),CorruptionMouseover=v22(1480 - (990 + 465)),SpellLockMouseover=v22(11 + 15),ShadowBoltPetAttack=v22(12 + 15),IridialStaff=v22(39 + 1),CancelBurningRush=v22(161 - 120)};
	v22.Warlock.Affliction = v19(v22.Warlock.Commons, {AgonyMouseover=v22(1754 - (1668 + 58)),VileTaintCursor=v22(655 - (512 + 114))});
	v22.Warlock.Demonology = v19(v22.Warlock.Commons, {DemonboltPetAttack=v22(78 - 48),DoomMouseover=v22(63 - 32),GuillotineCursor=v22(111 - 79)});
	v22.Warlock.Destruction = v19(v22.Warlock.Commons, {HavocMouseover=v22(16 + 17),ImmolateMouseover=v22(7 + 27),ImmolatePetAttack=v22(31 + 4),RainofFireCursor=v22(121 - 85),SummonInfernalCursor=v22(2031 - (109 + 1885))});
	v10.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v10.GuardiansTable = {Pets={},ImpCount=(1469 - (1269 + 200)),FelguardDuration=(0 - 0),DreadstalkerDuration=(815 - (98 + 717)),DemonicTyrantDuration=(826 - (802 + 24)),VilefiendDuration=(0 - 0),PitLordDuration=(0 - 0),Infernal=(0 + 0),Blasphemy=(0 + 0),DarkglareDuration=(0 + 0),InnerDemonsNextCast=(0 + 0),ImpsSpawnedFromHoG=(0 - 0)};
	local v39 = {[326923 - 228888]={name="Dreadstalker",duration=(5.25 + 7)},[22657 + 33002]={name="Wild Imp",duration=(17 + 3)},[104433 + 39189]={name="Wild Imp",duration=(10 + 10)},[18685 - (797 + 636)]={name="Felguard",duration=(82 - 65)},[136621 - (1427 + 192)]={name="Demonic Tyrant",duration=(6 + 9)},[315334 - 179518]={name="Vilefiend",duration=(14 + 1)},[88875 + 107236]={name="Pit Lord",duration=(336 - (192 + 134))},[1365 - (316 + 960)]={name="Infernal",duration=(17 + 13)},[143219 + 42365]={name="Blasphemy",duration=(8 + 0)},[396342 - 292669]={name="Darkglare",duration=(576 - (83 + 468))}};
	v10:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(1814 - (1202 + 604), ...);
		if ((SpellID == (736342 - 578606)) or ((712 - 284) > (1572 - 1004))) then
			v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 325 - (45 + 280);
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v10:RegisterForSelfCombatEvent(function(...)
		local v44 = 0 + 0;
		while true do
			if (((1166 + 168) <= (1685 + 2928)) and (v44 == (0 + 0))) then
				DestGUID, _, _, _, SpellID = select(2 + 6, ...);
				if ((SpellID == (292091 - 134355)) or ((3776 - (340 + 1571)) >= (801 + 1228))) then
					if (((6722 - (1733 + 39)) >= (4440 - 2824)) and v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
						v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED");
	v10:RegisterForCombatEvent(function(...)
		local v45 = 1034 - (125 + 909);
		while true do
			if (((3673 - (1096 + 852)) == (774 + 951)) and (v45 == (0 - 0))) then
				DestGUID = select(8 + 0, ...);
				if (((1971 - (409 + 103)) <= (2718 - (46 + 190))) and v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
					v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
				end
				break;
			end
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v46 = 95 - (51 + 44);
		while true do
			if ((v46 == (0 + 0)) or ((4013 - (1114 + 203)) >= (5258 - (228 + 498)))) then
				DestGUID, _, _, _, SpellID = select(2 + 6, ...);
				if (((579 + 469) >= (715 - (174 + 489))) and (SpellID == (46796 - 28834))) then
					if (((4863 - (830 + 1075)) < (5027 - (303 + 221))) and v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
						v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + (1270 - (231 + 1038));
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v23.UpdatePetTable = function()
		for v67, v68 in pairs(v10.GuardiansTable.Pets) do
			local v69 = 0 + 0;
			while true do
				if ((v69 == (1163 - (171 + 991))) or ((11271 - 8536) == (3514 - 2205))) then
					if ((GetTime() <= v68.despawnTime) or ((10306 - 6176) <= (2366 + 589))) then
						local v80 = 0 - 0;
						while true do
							if ((v80 == (0 - 0)) or ((3165 - 1201) <= (4142 - 2802))) then
								v68.Duration = v68.despawnTime - GetTime();
								if (((3747 - (111 + 1137)) == (2657 - (91 + 67))) and (v68.name == "Felguard")) then
									v10.GuardiansTable.FelguardDuration = v68.Duration;
								elseif ((v68.name == "Dreadstalker") or ((6711 - 4456) < (6 + 16))) then
									v10.GuardiansTable.DreadstalkerDuration = v68.Duration;
								elseif ((v68.name == "Demonic Tyrant") or ((1609 - (423 + 100)) >= (10 + 1395))) then
									v10.GuardiansTable.DemonicTyrantDuration = v68.Duration;
								elseif ((v68.name == "Vilefiend") or ((6559 - 4190) == (223 + 203))) then
									v10.GuardiansTable.VilefiendDuration = v68.Duration;
								elseif ((v68.name == "Pit Lord") or ((3847 - (326 + 445)) > (13890 - 10707))) then
									v10.GuardiansTable.PitLordDuration = v68.Duration;
								elseif (((2677 - 1475) > (2469 - 1411)) and (v68.name == "Infernal")) then
									v10.GuardiansTable.InfernalDuration = v68.Duration;
								elseif (((4422 - (530 + 181)) > (4236 - (614 + 267))) and (v68.name == "Blasphy")) then
									v10.GuardiansTable.BlasphemyDuration = v68.Duration;
								elseif ((v68.name == "Darkglare") or ((938 - (19 + 13)) >= (3627 - 1398))) then
									v10.GuardiansTable.DarkglareDuration = v68.Duration;
								end
								break;
							end
						end
					end
					break;
				end
				if (((3001 - 1713) > (3573 - 2322)) and (v69 == (0 + 0))) then
					if (v68 or ((7936 - 3423) < (6950 - 3598))) then
						if ((GetTime() >= v68.despawnTime) or ((3877 - (1293 + 519)) >= (6520 - 3324))) then
							if ((v68.name == "Wild Imp") or ((11425 - 7049) <= (2832 - 1351))) then
								v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (4 - 3);
							end
							if ((v68.name == "Felguard") or ((7990 - 4598) >= (2512 + 2229))) then
								v10.GuardiansTable.FelguardDuration = 0 + 0;
							elseif (((7725 - 4400) >= (498 + 1656)) and (v68.name == "Dreadstalker")) then
								v10.GuardiansTable.DreadstalkerDuration = 0 + 0;
							elseif ((v68.name == "Demonic Tyrant") or ((810 + 485) >= (4329 - (709 + 387)))) then
								v10.GuardiansTable.DemonicTyrantDuration = 1858 - (673 + 1185);
							elseif (((12693 - 8316) > (5272 - 3630)) and (v68.name == "Vilefiend")) then
								v10.GuardiansTable.VilefiendDuration = 0 - 0;
							elseif (((3379 + 1344) > (1014 + 342)) and (v68.name == "Pit Lord")) then
								v10.GuardiansTable.PitLordDuration = 0 - 0;
							elseif ((v68.name == "Infernal") or ((1016 + 3120) <= (6844 - 3411))) then
								v10.GuardiansTable.InfernalDuration = 0 - 0;
							elseif (((6125 - (446 + 1434)) <= (5914 - (1040 + 243))) and (v68.name == "Blasphemy")) then
								v10.GuardiansTable.BlasphemyDuration = 0 - 0;
							elseif (((6123 - (559 + 1288)) >= (5845 - (609 + 1322))) and (v68.name == "Darkglare")) then
								v10.GuardiansTable.DarkglareDuration = 454 - (13 + 441);
							end
							v10.GuardiansTable.Pets[v67] = nil;
						end
					end
					if (((739 - 541) <= (11433 - 7068)) and (v68.ImpCasts <= (0 - 0))) then
						v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (1 + 0);
						v10.GuardiansTable.Pets[v67] = nil;
					end
					v69 = 3 - 2;
				end
			end
		end
	end;
	v10:RegisterForSelfCombatEvent(function(...)
		local v47 = 0 + 0;
		local v48;
		local v49;
		local v50;
		local v51;
		local v52;
		local v53;
		local v54;
		while true do
			if (((2096 + 2686) > (13876 - 9200)) and (v47 == (2 + 0))) then
				if (((8945 - 4081) > (1453 + 744)) and v39[v54] and (v39[v54].name == "Demonic Tyrant")) then
					for v83, v84 in pairs(v10.GuardiansTable.Pets) do
						if ((v84 and (v84.name ~= "Demonic Tyrant") and (v84.name ~= "Pit Lord")) or ((2058 + 1642) == (1802 + 705))) then
							v84.despawnTime = v84.despawnTime + 13 + 2;
							v84.ImpCasts = v84.ImpCasts + 7 + 0;
						end
					end
				end
				if (((4907 - (153 + 280)) >= (790 - 516)) and (v54 == (128944 + 14678))) then
					v10.GuardiansTable.InnerDemonsNextCast = GetTime() + 5 + 7;
				end
				v47 = 2 + 1;
			end
			if (((3 + 0) == v47) or ((1373 + 521) <= (2140 - 734))) then
				if (((972 + 600) >= (2198 - (89 + 578))) and (v54 == (39761 + 15898)) and (v10.GuardiansTable.ImpsSpawnedFromHoG > (0 - 0))) then
					v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG - (1050 - (572 + 477));
				end
				v23.UpdatePetTable();
				break;
			end
			if ((v47 == (1 + 0)) or ((2813 + 1874) < (543 + 3999))) then
				v54 = tonumber(v54);
				if (((3377 - (84 + 2)) > (2746 - 1079)) and (v52 ~= UnitGUID("pet")) and (v49 == "SPELL_SUMMON") and v39[v54]) then
					local v76 = v39[v54];
					local v77;
					if ((v76.name == "Wild Imp") or ((629 + 244) == (2876 - (497 + 345)))) then
						v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount + 1 + 0;
						v77 = v76.duration;
					elseif ((v76.name == "Felguard") or ((477 + 2339) < (1344 - (605 + 728)))) then
						local v99 = 0 + 0;
						while true do
							if (((8223 - 4524) < (216 + 4490)) and (v99 == (0 - 0))) then
								v10.GuardiansTable.FelguardDuration = v76.duration;
								v77 = v76.duration;
								break;
							end
						end
					elseif (((2386 + 260) >= (2426 - 1550)) and (v76.name == "Dreadstalker")) then
						v10.GuardiansTable.DreadstalkerDuration = v76.duration;
						v77 = v76.duration;
					elseif (((464 + 150) <= (3673 - (457 + 32))) and (v76.name == "Demonic Tyrant")) then
						if (((1327 + 1799) == (4528 - (832 + 570))) and (v53 == (249830 + 15357))) then
							v10.GuardiansTable.DemonicTyrantDuration = v76.duration;
							v77 = v76.duration;
						end
					elseif ((v76.name == "Vilefiend") or ((571 + 1616) >= (17531 - 12577))) then
						local v116 = 0 + 0;
						while true do
							if ((v116 == (796 - (588 + 208))) or ((10449 - 6572) == (5375 - (884 + 916)))) then
								v10.GuardiansTable.VilefiendDuration = v76.duration;
								v77 = v76.duration;
								break;
							end
						end
					elseif (((1479 - 772) > (367 + 265)) and (v76.name == "Pit Lord")) then
						v10.GuardiansTable.PitLordDuration = v76.duration;
						v77 = v76.duration;
					elseif ((v76.name == "Infernal") or ((1199 - (232 + 421)) >= (4573 - (1569 + 320)))) then
						v10.GuardiansTable.InfernalDuration = v76.duration;
						v77 = v76.duration;
					elseif (((360 + 1105) <= (818 + 3483)) and (v76.name == "Blasphemy")) then
						v10.GuardiansTable.BlasphemyDuration = v76.duration;
						v77 = v76.duration;
					elseif (((5741 - 4037) > (2030 - (316 + 289))) and (v76.name == "Darkglare")) then
						local v137 = 0 - 0;
						while true do
							if (((0 + 0) == v137) or ((2140 - (666 + 787)) == (4659 - (360 + 65)))) then
								v10.GuardiansTable.DarkglareDuration = v76.duration;
								v77 = v76.duration;
								break;
							end
						end
					end
					local v78 = {ID=v52,name=v76.name,spawnTime=GetTime(),ImpCasts=(5 + 0),Duration=v77,despawnTime=(GetTime() + tonumber(v77))};
					table.insert(v10.GuardiansTable.Pets, v78);
				end
				v47 = 256 - (79 + 175);
			end
			if ((v47 == (0 - 0)) or ((2599 + 731) < (4379 - 2950))) then
				v48, v49, v50, v51, v50, v50, v50, v52, v50, v50, v50, v53 = select(1 - 0, ...);
				v50, v50, v50, v50, v50, v50, v50, v54 = v20(v52, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
				v47 = 900 - (503 + 396);
			end
		end
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v10:RegisterForCombatEvent(function(...)
		local v55 = 181 - (92 + 89);
		local v56;
		local v57;
		local v58;
		local v59;
		while true do
			if (((2225 - 1078) >= (172 + 163)) and (v55 == (0 + 0))) then
				v56, v57, v57, v57, v58, v57, v57, v57, v59 = select(15 - 11, ...);
				if (((470 + 2965) > (4781 - 2684)) and (v59 == (91017 + 13301))) then
					for v85, v86 in pairs(v10.GuardiansTable.Pets) do
						if ((v56 == v86.ID) or ((1801 + 1969) >= (12307 - 8266))) then
							v86.ImpCasts = v86.ImpCasts - (1 + 0);
						end
					end
				end
				v55 = 1 - 0;
			end
			if ((v55 == (1245 - (485 + 759))) or ((8771 - 4980) <= (2800 - (442 + 747)))) then
				if (((v56 == v13:GUID()) and (v59 == (197412 - (832 + 303)))) or ((5524 - (88 + 858)) <= (612 + 1396))) then
					for v87, v88 in pairs(v10.GuardiansTable.Pets) do
						if (((932 + 193) <= (86 + 1990)) and (v88.name == "Wild Imp")) then
							v10.GuardiansTable.Pets[v87] = nil;
						end
					end
					v10.GuardiansTable.ImpCount = 789 - (766 + 23);
				end
				v23.UpdatePetTable();
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v23.LastPI = 0 - 0;
	v10:RegisterForCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(10 - 2, ...);
		if (((SpellID == (26505 - 16445)) and (DestGUID == v13:GUID())) or ((2521 - 1778) >= (5472 - (1036 + 37)))) then
			v23.LastPI = GetTime();
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v23.SoulShards = 0 + 0;
	v23.UpdateSoulShards = function()
		v23.SoulShards = v13:SoulShards();
	end;
	v10:RegisterForSelfCombatEvent(function(v61, v62, v61, v61, v61, v61, v61, v61, v61, v61, v61, v63)
		if (((2249 - 1094) < (1317 + 356)) and (v63 == (106654 - (641 + 839)))) then
			v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG + (((v23.SoulShards >= (916 - (910 + 3))) and (7 - 4)) or v23.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v1["Epix_Warlock_Warlock.lua"](...);

