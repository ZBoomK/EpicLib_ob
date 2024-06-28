local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = v1[v5];
	if (not v6 or ((88 + 1580) >= (5616 - (195 + 1442)))) then
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
	if (((1593 - 1025) > (230 + 198)) and not v16.Warlock) then
		v16.Warlock = {};
	end
	v16.Warlock.Commons = {Berserking=v16(16744 + 9553, nil, 397 - (115 + 281)),AncestralCall=v16(639050 - 364312),BloodFury=v16(27904 + 5798, nil, 4 - 2),Fireblood=v16(972512 - 707291, nil, 870 - (550 + 317)),Corruption=v16(248 - 76, nil, 4 - 0),DarkPact=v16(302966 - 194550, nil, 290 - (134 + 151)),ShadowBolt=v16(2351 - (970 + 695), nil, 11 - 5),SummonDarkglare=v16(207170 - (582 + 1408), nil, 23 - 16),UnendingResolve=v16(131827 - 27054, nil, 30 - 22),GrimoireofSacrifice=v16(110327 - (1195 + 629), nil, 11 - 2),GrimoireofSacrificeBuff=v16(196340 - (187 + 54), nil, 790 - (162 + 618)),SoulConduit=v16(151310 + 64631, nil, 8 + 3),SummonSoulkeeper=v16(823768 - 437512, nil, 19 - 7),InquisitorsGaze=v16(30208 + 356136, nil, 1649 - (1373 + 263)),InquisitorsGazeBuff=v16(389068 - (451 + 549), nil, 5 + 9),Soulburn=v16(600554 - 214655, nil, 25 - 10),PowerInfusionBuff=v16(11444 - (746 + 638), nil, 7 + 9),AxeToss=v16(182062 - 62148, nil, 358 - (218 + 123)),Seduction=v16(121490 - (1535 + 46), nil, 18 + 0),ShadowBulwark=v16(17351 + 102556, nil, 579 - (306 + 254)),SingeMagic=v16(7424 + 112481, nil, 39 - 19),SpellLock=v16(121377 - (899 + 568), nil, 14 + 7),BurningRush=v16(269577 - 158177, nil, 1158 - (268 + 335))};
	v16.Warlock.Demonology = v19(v16.Warlock.Commons, {Felstorm=v16(90041 - (60 + 230), nil, 594 - (426 + 146)),HandofGuldan=v16(12600 + 92574, nil, 1479 - (282 + 1174)),ShadowBoltLineCD=v16(1497 - (569 + 242), nil, 17 - 11),SummonPet=v16(1724 + 28422, nil, 1048 - (706 + 318)),BilescourgeBombers=v16(268462 - (721 + 530), nil, 1296 - (945 + 326)),CallDreadstalkers=v16(260614 - 156298, nil, 24 + 2),Demonbolt=v16(264878 - (271 + 429), nil, 25 + 2),DemonicCalling=v16(206645 - (1408 + 92), nil, 1114 - (461 + 625)),DemonicStrength=v16(268459 - (993 + 295), nil, 2 + 27),Doom=v16(1774 - (418 + 753), nil, 12 + 18),FelDomination=v16(34411 + 299478, nil, 10 + 21),FelCovenant=v16(97915 + 289517, nil, 561 - (406 + 123)),FromtheShadows=v16(268939 - (1749 + 20), nil, 8 + 25),GrimoireFelguard=v16(113220 - (1249 + 73), nil, 13 + 21),Guillotine=v16(387978 - (466 + 679), nil, 84 - 49),ImpGangBoss=v16(1108164 - 720719, nil, 1936 - (106 + 1794)),Implosion=v16(62093 + 134184, nil, 10 + 27),InnerDemons=v16(788928 - 521712, nil, 102 - 64),NetherPortal=v16(267331 - (4 + 110), nil, 623 - (57 + 527)),PowerSiphon=v16(265557 - (41 + 1386), nil, 143 - (17 + 86)),SacrificedSouls=v16(181360 + 85854, nil, 91 - 50),SoulboundTyrant=v16(968939 - 634354, nil, 208 - (122 + 44)),SoulStrike=v16(456113 - 192056, nil, 142 - 99),SummonDemonicTyrant=v16(215726 + 49461, nil, 7 + 37),SummonVilefiend=v16(535066 - 270947, nil, 110 - (30 + 35)),TheExpendables=v16(266402 + 121198, nil, 1303 - (1043 + 214)),ReignofTyranny=v16(1616926 - 1189242, nil, 1344 - (323 + 889)),GrandWarlocksDesign=v16(1041891 - 654807, nil, 713 - (361 + 219)),DemonicCallingBuff=v16(205466 - (53 + 267), nil, 11 + 36),DemonicCoreBuff=v16(264586 - (15 + 398), nil, 1030 - (18 + 964)),DemonicPowerBuff=v16(998519 - 733246, nil, 29 + 20),FelCovenantBuff=v16(244100 + 143337, nil, 900 - (20 + 830)),NetherPortalBuff=v16(208588 + 58630, nil, 177 - (116 + 10)),DoomDebuff=v16(45 + 558, nil, 790 - (542 + 196)),FromtheShadowsDebuff=v16(580020 - 309451, nil, 16 + 37),DoomBrandDebuff=v16(215209 + 208374),DrainLife=v16(84288 + 149865, nil, 144 - 89),DoomBrand=v16(1085979 - 662395)});
	v16.Warlock.Affliction = v19(v16.Warlock.Commons, {Agony=v16(2531 - (1126 + 425), nil, 459 - (118 + 287)),DrainLife=v16(917714 - 683561, nil, 1176 - (118 + 1003)),SummonPet=v16(2013 - 1325, nil, 433 - (142 + 235)),AbsoluteCorruption=v16(889624 - 693521, nil, 13 + 44),DoomBlossom=v16(390741 - (553 + 424)),DrainSoul=v16(375525 - 176935, nil, 52 + 6),DreadTouch=v16(386650 + 3125, nil, 35 + 24),Haunt=v16(20482 + 27699, nil, 35 + 25),InevitableDemise=v16(724767 - 390448, nil, 169 - 108),MaleficAffliction=v16(872691 - 482930, nil, 19 + 43),MaleficRapture=v16(1568371 - 1243835, nil, 816 - (239 + 514)),Nightfall=v16(38127 + 70431, nil, 1393 - (797 + 532)),PhantomSingularity=v16(149087 + 56092, nil, 22 + 43),SowTheSeeds=v16(461376 - 265150, nil, 1268 - (373 + 829)),SeedofCorruption=v16(27974 - (476 + 255), nil, 1197 - (369 + 761)),ShadowEmbrace=v16(15760 + 11483, nil, 123 - 55),SiphonLife=v16(119585 - 56479, nil, 307 - (64 + 174)),SoulRot=v16(55118 + 331879, nil, 103 - 33),SoulSwap=v16(387287 - (144 + 192), nil, 287 - (42 + 174)),SoulTap=v16(290783 + 96290, nil, 60 + 12),SouleatersGluttony=v16(165532 + 224098, nil, 1577 - (363 + 1141)),TormentedCrescendo=v16(388655 - (1183 + 397), nil, 228 - 153),UnstableAffliction=v16(231716 + 84383, nil, 57 + 19),VileTaint=v16(280325 - (1913 + 62), nil, 49 + 28),InevitableDemiseBuff=v16(885046 - 550726, nil, 2011 - (565 + 1368)),NightfallBuff=v16(994981 - 730410, nil, 1740 - (1477 + 184)),MaleficAfflictionBuff=v16(531195 - 141350, nil, 75 + 5),TormentedCrescendoBuff=v16(387935 - (564 + 292), nil, 139 - 58),UmbrafireKindlingBuff=v16(1277299 - 853534),AgonyDebuff=v16(1284 - (244 + 60), nil, 64 + 18),CorruptionDebuff=v16(147215 - (41 + 435), nil, 1084 - (938 + 63)),HauntDebuff=v16(37055 + 11126, nil, 1209 - (936 + 189)),PhantomSingularityDebuff=v16(67525 + 137654, nil, 1698 - (1565 + 48)),SeedofCorruptionDebuff=v16(16829 + 10414, nil, 1224 - (782 + 356)),SiphonLifeDebuff=v16(63373 - (176 + 91), nil, 226 - 139),UnstableAfflictionDebuff=v16(465869 - 149770, nil, 1180 - (975 + 117)),VileTaintDebuff=v16(280225 - (157 + 1718), nil, 73 + 16),SoulRotDebuff=v16(1373809 - 986812, nil, 307 - 217),DreadTouchDebuff=v16(390886 - (697 + 321), nil, 247 - 156),ShadowEmbraceDebuff=v16(68621 - 36231, nil, 211 - 119)});
	v16.Warlock.Destruction = v19(v16.Warlock.Commons, {Immolate=v16(136 + 212, nil, 173 - 80),Incinerate=v16(79676 - 49954, nil, 1321 - (322 + 905)),SummonPet=v16(1299 - (602 + 9), nil, 1284 - (449 + 740)),AshenRemains=v16(388124 - (826 + 46), nil, 1043 - (245 + 702)),AvatarofDestruction=v16(1223406 - 836247, nil, 32 + 65),Backdraft=v16(198304 - (260 + 1638), nil, 538 - (382 + 58)),BurntoAshes=v16(1242014 - 854861, nil, 83 + 16),Cataclysm=v16(314361 - 162253, nil, 297 - 197),ChannelDemonfire=v16(197652 - (902 + 303), nil, 221 - 120),ChaosBolt=v16(281452 - 164594, nil, 9 + 93),ChaosIncarnate=v16(388965 - (1121 + 569)),Chaosbringer=v16(422271 - (22 + 192)),Conflagrate=v16(18645 - (483 + 200), nil, 1566 - (1404 + 59)),CrashingChaos=v16(1141860 - 724626),CryHavoc=v16(520840 - 133318, nil, 869 - (468 + 297)),DiabolicEmbers=v16(387735 - (334 + 228), nil, 354 - 249),DimensionalRift=v16(899293 - 511317, nil, 191 - 85),Eradication=v16(55774 + 140638, nil, 343 - (141 + 95)),FireandBrimstone=v16(192934 + 3474, nil, 277 - 169),Havoc=v16(192890 - 112650, nil, 26 + 83),Inferno=v16(741260 - 470715, nil, 78 + 32),InternalCombustion=v16(138583 + 127551, nil, 155 - 44),MadnessoftheAzjAqir=v16(228511 + 158889, nil, 275 - (92 + 71)),Mayhem=v16(191407 + 196099, nil, 189 - 76),RagingDemonfire=v16(387931 - (574 + 191), nil, 95 + 19),RainofChaos=v16(666626 - 400540, nil, 59 + 56),RainofFire=v16(6589 - (254 + 595), nil, 242 - (55 + 71)),RoaringBlaze=v16(270308 - 65124, nil, 1907 - (573 + 1217)),Ruin=v16(1072051 - 684948, nil, 9 + 109),SoulFire=v16(10237 - 3884, nil, 1058 - (714 + 225)),SummonInfernal=v16(3278 - 2156, nil, 167 - 47),BackdraftBuff=v16(12757 + 105071, nil, 174 - 53),MadnessCBBuff=v16(388215 - (118 + 688), nil, 170 - (25 + 23)),MadnessRoFBuff=v16(75037 + 312376),MadnessSBBuff=v16(389300 - (927 + 959)),RainofChaosBuff=v16(896951 - 630864, nil, 855 - (16 + 716)),RitualofRuinBuff=v16(747370 - 360213, nil, 221 - (11 + 86)),BurntoAshesBuff=v16(944334 - 557180, nil, 410 - (175 + 110)),EradicationDebuff=v16(495905 - 299491, nil, 621 - 495),ConflagrateDebuff=v16(267727 - (503 + 1293)),HavocDebuff=v16(224094 - 143854, nil, 92 + 35),ImmolateDebuff=v16(158797 - (810 + 251), nil, 89 + 39),PyrogenicsDebuff=v16(118801 + 268295),RoaringBlazeDebuff=v16(239725 + 26206, nil, 662 - (43 + 490))});
	if (((2067 - (711 + 22)) <= (17843 - 13230)) and not v18.Warlock) then
		v18.Warlock = {};
	end
	v18.Warlock.Commons = {Healthstone=v18(880 - (240 + 619)),PotionOfWitheringDreams=v18(49962 + 157079),ConjuredChillglobe=v18(309073 - 114773, {(1757 - (1344 + 400)),(12 + 2)}),DesperateInvokersCodex=v18(104029 + 90281, {(41 - 28),(420 - (183 + 223))}),TimebreachingTalon=v18(235817 - 42026, {(5 + 8),(10 + 4)}),TimeThiefsGambit=v18(207917 - (118 + 220), {(462 - (108 + 341)),(59 - 45)}),BelorrelostheSuncaller=v18(208665 - (711 + 782), {(482 - (270 + 199)),(1833 - (580 + 1239))}),Iridal=v18(619293 - 410972, {(1 + 15)}),NymuesUnravelingSpindle=v18(90878 + 117737, {(9 + 4),(1804 - (1010 + 780))}),MirrorofFracturedTomorrows=v18(207479 + 102, {(38 - 25),(34 - 20)}),RubyWhelpShell=v18(295856 - 102099, {(1587 - (1281 + 293)),(31 - 17)}),WhisperingIncarnateIcon=v18(195860 - (1381 + 178), {(11 + 2),(48 - 34)}),AshesoftheEmbersoul=v18(107326 + 99841, {(12 + 1),(23 - 9)}),BeacontotheBeyond=v18(205119 - (1074 + 82), {(1797 - (214 + 1570)),(6 + 8)}),IcebloodDeathsnare=v18(84546 + 109758, {(50 - 37),(640 - (512 + 114))}),IrideusFragment=v18(505116 - 311373, {(45 - 32),(3 + 11)}),NeltharionsCallToDominance=v18(177520 + 26682, {(2007 - (109 + 1885)),(26 - 12)}),RotcrustedVoodooDoll=v18(160439 - (98 + 717), {(22 - 9),(3 + 11)}),SpoilsofNeltharus=v18(148881 + 44892, {(3 + 10),(46 - 32)}),VoidmendersShadowgem=v18(39347 + 70660, {(11 + 2),(7 + 7)})};
	v18.Warlock.Affliction = v19(v18.Warlock.Commons, {});
	v18.Warlock.Demonology = v19(v18.Warlock.Commons, {});
	v18.Warlock.Destruction = v19(v18.Warlock.Commons, {});
	if (not v22.Warlock or ((3298 - (797 + 636)) >= (9851 - 7822))) then
		v22.Warlock = {};
	end
	v22.Warlock.Commons = {Healthstone=v22(1640 - (1427 + 192)),HealingPotion=v22(4 + 6),RefreshingHealingPotion=v18(444341 - 252961),DreamwalkersHealingPotion=v18(186086 + 20937),ConjuredChillglobe=v22(10 + 12),DesperateInvokersCodex=v22(349 - (192 + 134)),TimebreachingTalon=v22(1300 - (316 + 960)),AxeTossMouseover=v22(14 + 10),CorruptionMouseover=v22(20 + 5),SpellLockMouseover=v22(25 + 1),ShadowBoltPetAttack=v22(103 - 76),IridialStaff=v22(591 - (83 + 468)),CancelBurningRush=v22(1847 - (1202 + 604))};
	v22.Warlock.Affliction = v19(v22.Warlock.Commons, {AgonyMouseover=v22(130 - 102),VileTaintCursor=v22(47 - 18)});
	v22.Warlock.Demonology = v19(v22.Warlock.Commons, {DemonboltPetAttack=v22(83 - 53),DoomMouseover=v22(356 - (45 + 280)),GuillotineCursor=v22(31 + 1)});
	v22.Warlock.Destruction = v19(v22.Warlock.Commons, {HavocMouseover=v22(29 + 4),ImmolateMouseover=v22(13 + 21),ImmolatePetAttack=v22(20 + 15),RainofFireCursor=v22(7 + 29),SummonInfernalCursor=v22(68 - 31)});
	v10.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v10.GuardiansTable = {Pets={},ImpCount=(1911 - (340 + 1571)),FelguardDuration=(0 + 0),DreadstalkerDuration=(1772 - (1733 + 39)),DemonicTyrantDuration=(0 - 0),VilefiendDuration=(1034 - (125 + 909)),PitLordDuration=(1948 - (1096 + 852)),Infernal=(0 + 0),Blasphemy=(0 - 0),DarkglareDuration=(0 + 0),InnerDemonsNextCast=(512 - (409 + 103)),ImpsSpawnedFromHoG=(236 - (46 + 190))};
	local v39 = {[98130 - (51 + 44)]={name="Dreadstalker",duration=(4.25 + 8)},[56976 - (1114 + 203)]={name="Wild Imp",duration=(746 - (228 + 498))},[31117 + 112505]={name="Wild Imp",duration=(12 + 8)},[17915 - (174 + 489)]={name="Felguard",duration=(44 - 27)},[136907 - (830 + 1075)]={name="Demonic Tyrant",duration=(539 - (303 + 221))},[137085 - (231 + 1038)]={name="Vilefiend",duration=(13 + 2)},[197273 - (171 + 991)]={name="Pit Lord",duration=(41 - 31)},[238 - 149]={name="Infernal",duration=(74 - 44)},[148531 + 37053]={name="Blasphemy",duration=(27 - 19)},[299076 - 195403]={name="Darkglare",duration=(40 - 15)}};
	v10:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(24 - 16, ...);
		if (((6198 - (111 + 1137)) >= (1774 - (91 + 67))) and (SpellID == (469461 - 311725))) then
			v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 0 + 0;
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v10:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(531 - (423 + 100), ...);
		if (((13 + 1712) == (4775 - 3050)) and (SpellID == (82216 + 75520))) then
			if (((2230 - (326 + 445)) <= (10831 - 8349)) and v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
				v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
			end
		end
	end, "SPELL_AURA_REMOVED");
	v10:RegisterForCombatEvent(function(...)
		local v44 = 0 - 0;
		while true do
			if ((v44 == (0 - 0)) or ((3407 - (530 + 181)) >= (5413 - (614 + 267)))) then
				DestGUID = select(40 - (19 + 13), ...);
				if (((1705 - 657) >= (120 - 68)) and v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
					v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
				end
				break;
			end
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v45 = 0 - 0;
		while true do
			if (((769 + 2189) < (7918 - 3415)) and (v45 == (0 - 0))) then
				DestGUID, _, _, _, SpellID = select(1820 - (1293 + 519), ...);
				if ((SpellID == (36647 - 18685)) or ((7140 - 4405) == (2502 - 1193))) then
					if (v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((17809 - 13679) <= (6961 - 4006))) then
						v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + 1 + 0;
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v23.UpdatePetTable = function()
		for v65, v66 in pairs(v10.GuardiansTable.Pets) do
			if (v66 or ((401 + 1563) <= (3113 - 1773))) then
				if (((578 + 1921) == (831 + 1668)) and (GetTime() >= v66.despawnTime)) then
					if ((v66.name == "Wild Imp") or ((1410 + 845) < (1118 - (709 + 387)))) then
						v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (1859 - (673 + 1185));
					end
					if ((v66.name == "Felguard") or ((3149 - 2063) >= (4511 - 3106))) then
						v10.GuardiansTable.FelguardDuration = 0 - 0;
					elseif ((v66.name == "Dreadstalker") or ((1695 + 674) == (319 + 107))) then
						v10.GuardiansTable.DreadstalkerDuration = 0 - 0;
					elseif ((v66.name == "Demonic Tyrant") or ((756 + 2320) > (6346 - 3163))) then
						v10.GuardiansTable.DemonicTyrantDuration = 0 - 0;
					elseif (((3082 - (446 + 1434)) > (2341 - (1040 + 243))) and (v66.name == "Vilefiend")) then
						v10.GuardiansTable.VilefiendDuration = 0 - 0;
					elseif (((5558 - (559 + 1288)) > (5286 - (609 + 1322))) and (v66.name == "Pit Lord")) then
						v10.GuardiansTable.PitLordDuration = 454 - (13 + 441);
					elseif ((v66.name == "Infernal") or ((3385 - 2479) >= (5838 - 3609))) then
						v10.GuardiansTable.InfernalDuration = 0 - 0;
					elseif (((48 + 1240) > (4543 - 3292)) and (v66.name == "Blasphemy")) then
						v10.GuardiansTable.BlasphemyDuration = 0 + 0;
					elseif ((v66.name == "Darkglare") or ((1978 + 2535) < (9947 - 6595))) then
						v10.GuardiansTable.DarkglareDuration = 0 + 0;
					end
					v10.GuardiansTable.Pets[v65] = nil;
				end
			end
			if ((v66.ImpCasts <= (0 - 0)) or ((1366 + 699) >= (1778 + 1418))) then
				local v75 = 0 + 0;
				while true do
					if ((v75 == (0 + 0)) or ((4282 + 94) <= (1914 - (153 + 280)))) then
						v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (2 - 1);
						v10.GuardiansTable.Pets[v65] = nil;
						break;
					end
				end
			end
			if ((GetTime() <= v66.despawnTime) or ((3046 + 346) >= (1872 + 2869))) then
				local v76 = 0 + 0;
				while true do
					if (((3018 + 307) >= (1561 + 593)) and (v76 == (0 - 0))) then
						v66.Duration = v66.despawnTime - GetTime();
						if ((v66.name == "Felguard") or ((801 + 494) >= (3900 - (89 + 578)))) then
							v10.GuardiansTable.FelguardDuration = v66.Duration;
						elseif (((3127 + 1250) > (3413 - 1771)) and (v66.name == "Dreadstalker")) then
							v10.GuardiansTable.DreadstalkerDuration = v66.Duration;
						elseif (((5772 - (572 + 477)) > (183 + 1173)) and (v66.name == "Demonic Tyrant")) then
							v10.GuardiansTable.DemonicTyrantDuration = v66.Duration;
						elseif ((v66.name == "Vilefiend") or ((2483 + 1653) <= (410 + 3023))) then
							v10.GuardiansTable.VilefiendDuration = v66.Duration;
						elseif (((4331 - (84 + 2)) <= (7631 - 3000)) and (v66.name == "Pit Lord")) then
							v10.GuardiansTable.PitLordDuration = v66.Duration;
						elseif (((3081 + 1195) >= (4756 - (497 + 345))) and (v66.name == "Infernal")) then
							v10.GuardiansTable.InfernalDuration = v66.Duration;
						elseif (((6 + 192) <= (738 + 3627)) and (v66.name == "Blasphy")) then
							v10.GuardiansTable.BlasphemyDuration = v66.Duration;
						elseif (((6115 - (605 + 728)) > (3337 + 1339)) and (v66.name == "Darkglare")) then
							v10.GuardiansTable.DarkglareDuration = v66.Duration;
						end
						break;
					end
				end
			end
		end
	end;
	v10:RegisterForSelfCombatEvent(function(...)
		local v46, v47, v48, v49, v48, v48, v48, v50, v48, v48, v48, v51 = select(1 - 0, ...);
		local v48, v48, v48, v48, v48, v48, v48, v52 = v20(v50, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
		v52 = tonumber(v52);
		if (((223 + 4641) > (8122 - 5925)) and (v50 ~= UnitGUID("pet")) and (v47 == "SPELL_SUMMON") and v39[v52]) then
			local v68 = v39[v52];
			local v69;
			if ((v68.name == "Wild Imp") or ((3336 + 364) == (6945 - 4438))) then
				local v84 = 0 + 0;
				while true do
					if (((4963 - (457 + 32)) >= (117 + 157)) and (v84 == (1402 - (832 + 570)))) then
						v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount + 1 + 0;
						v69 = v68.duration;
						break;
					end
				end
			elseif ((v68.name == "Felguard") or ((494 + 1400) <= (4975 - 3569))) then
				v10.GuardiansTable.FelguardDuration = v68.duration;
				v69 = v68.duration;
			elseif (((758 + 814) >= (2327 - (588 + 208))) and (v68.name == "Dreadstalker")) then
				local v103 = 0 - 0;
				while true do
					if ((v103 == (1800 - (884 + 916))) or ((9812 - 5125) < (2634 + 1908))) then
						v10.GuardiansTable.DreadstalkerDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			elseif (((3944 - (232 + 421)) > (3556 - (1569 + 320))) and (v68.name == "Demonic Tyrant")) then
				if ((v51 == (65062 + 200125)) or ((166 + 707) == (6853 - 4819))) then
					local v114 = 605 - (316 + 289);
					while true do
						if ((v114 == (0 - 0)) or ((131 + 2685) < (1464 - (666 + 787)))) then
							v10.GuardiansTable.DemonicTyrantDuration = v68.duration;
							v69 = v68.duration;
							break;
						end
					end
				end
			elseif (((4124 - (360 + 65)) < (4399 + 307)) and (v68.name == "Vilefiend")) then
				local v115 = 254 - (79 + 175);
				while true do
					if (((4172 - 1526) >= (684 + 192)) and (v115 == (0 - 0))) then
						v10.GuardiansTable.VilefiendDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			elseif (((1182 - 568) <= (4083 - (503 + 396))) and (v68.name == "Pit Lord")) then
				local v119 = 181 - (92 + 89);
				while true do
					if (((6063 - 2937) == (1604 + 1522)) and (v119 == (0 + 0))) then
						v10.GuardiansTable.PitLordDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			elseif ((v68.name == "Infernal") or ((8564 - 6377) >= (678 + 4276))) then
				local v127 = 0 - 0;
				while true do
					if ((v127 == (0 + 0)) or ((1852 + 2025) == (10888 - 7313))) then
						v10.GuardiansTable.InfernalDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			elseif (((89 + 618) > (963 - 331)) and (v68.name == "Blasphemy")) then
				local v133 = 1244 - (485 + 759);
				while true do
					if ((v133 == (0 - 0)) or ((1735 - (442 + 747)) >= (3819 - (832 + 303)))) then
						v10.GuardiansTable.BlasphemyDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			elseif (((2411 - (88 + 858)) <= (1311 + 2990)) and (v68.name == "Darkglare")) then
				local v139 = 0 + 0;
				while true do
					if (((71 + 1633) > (2214 - (766 + 23))) and (v139 == (0 - 0))) then
						v10.GuardiansTable.DarkglareDuration = v68.duration;
						v69 = v68.duration;
						break;
					end
				end
			end
			local v70 = {ID=v50,name=v68.name,spawnTime=GetTime(),ImpCasts=(6 - 1),Duration=v69,despawnTime=(GetTime() + tonumber(v69))};
			table.insert(v10.GuardiansTable.Pets, v70);
		end
		if ((v39[v52] and (v39[v52].name == "Demonic Tyrant")) or ((1809 - 1122) == (14370 - 10136))) then
			for v77, v78 in pairs(v10.GuardiansTable.Pets) do
				if ((v78 and (v78.name ~= "Demonic Tyrant") and (v78.name ~= "Pit Lord")) or ((4403 - (1036 + 37)) < (1014 + 415))) then
					local v87 = 0 - 0;
					while true do
						if (((903 + 244) >= (1815 - (641 + 839))) and (v87 == (913 - (910 + 3)))) then
							v78.despawnTime = v78.despawnTime + (38 - 23);
							v78.ImpCasts = v78.ImpCasts + (1691 - (1466 + 218));
							break;
						end
					end
				end
			end
		end
		if (((1579 + 1856) > (3245 - (556 + 592))) and (v52 == (51072 + 92550))) then
			v10.GuardiansTable.InnerDemonsNextCast = GetTime() + (820 - (329 + 479));
		end
		if (((v52 == (56513 - (174 + 680))) and (v10.GuardiansTable.ImpsSpawnedFromHoG > (0 - 0))) or ((7814 - 4044) >= (2886 + 1155))) then
			v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG - (740 - (396 + 343));
		end
		v23.UpdatePetTable();
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v10:RegisterForCombatEvent(function(...)
		local v53, v54, v54, v54, v55, v54, v54, v54, v56 = select(1 + 3, ...);
		if ((v56 == (105795 - (29 + 1448))) or ((5180 - (135 + 1254)) <= (6068 - 4457))) then
			for v79, v80 in pairs(v10.GuardiansTable.Pets) do
				if ((v53 == v80.ID) or ((21375 - 16797) <= (1339 + 669))) then
					v80.ImpCasts = v80.ImpCasts - (1528 - (389 + 1138));
				end
			end
		end
		if (((1699 - (102 + 472)) <= (1960 + 116)) and (v53 == v13:GUID()) and (v56 == (108842 + 87435))) then
			for v81, v82 in pairs(v10.GuardiansTable.Pets) do
				if ((v82.name == "Wild Imp") or ((693 + 50) >= (5944 - (320 + 1225)))) then
					v10.GuardiansTable.Pets[v81] = nil;
				end
			end
			v10.GuardiansTable.ImpCount = 0 - 0;
		end
		v23.UpdatePetTable();
	end, "SPELL_CAST_SUCCESS");
	v23.LastPI = 0 + 0;
	v10:RegisterForCombatEvent(function(...)
		local v57 = 1464 - (157 + 1307);
		while true do
			if (((3014 - (821 + 1038)) < (4174 - 2501)) and (v57 == (0 + 0))) then
				DestGUID, _, _, _, SpellID = select(13 - 5, ...);
				if (((SpellID == (3743 + 6317)) and (DestGUID == v13:GUID())) or ((5760 - 3436) <= (1604 - (834 + 192)))) then
					v23.LastPI = GetTime();
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v23.SoulShards = 0 + 0;
	v23.UpdateSoulShards = function()
		v23.SoulShards = v13:SoulShards();
	end;
	v10:RegisterForSelfCombatEvent(function(v59, v60, v59, v59, v59, v59, v59, v59, v59, v59, v59, v61)
		if (((967 + 2800) == (81 + 3686)) and (v61 == (162935 - 57761))) then
			v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG + (((v23.SoulShards >= (307 - (300 + 4))) and (1 + 2)) or v23.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v1["Epix_Warlock_Warlock.lua"](...);

