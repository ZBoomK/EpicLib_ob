local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 - 0;
	local v7;
	while true do
		if ((v6 == (1 - 0)) or ((3745 - (218 + 123)) == (6041 - (1535 + 46)))) then
			return v7(v0, ...);
		end
		if ((v6 == (0 + 0)) or ((343 + 2021) > (4066 - (306 + 254)))) then
			v7 = v1[v5];
			if (not v7 or ((180 + 2723) > (9722 - 4768))) then
				return v2(v5, v0, ...);
			end
			v6 = 1468 - (899 + 568);
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
	if (((2028 + 1056) > (96 - 56)) and not v17.Warlock) then
		v17.Warlock = {};
	end
	v17.Warlock.Commons = {Berserking=v17(26900 - (268 + 335), nil, 291 - (60 + 230)),AncestralCall=v17(275310 - (426 + 146)),BloodFury=v17(4038 + 29664, nil, 1458 - (282 + 1174)),Fireblood=v17(266032 - (569 + 242), nil, 8 - 5),Corruption=v17(10 + 162, nil, 1028 - (706 + 318)),DarkPact=v17(109667 - (721 + 530), nil, 1276 - (945 + 326)),ShadowBolt=v17(1713 - 1027, nil, 6 + 0),SummonDarkglare=v17(205880 - (271 + 429), nil, 7 + 0),UnendingResolve=v17(106273 - (1408 + 92), nil, 1094 - (461 + 625)),GrimoireofSacrifice=v17(109791 - (993 + 295), nil, 1 + 8),GrimoireofSacrificeBuff=v17(197270 - (418 + 753), nil, 4 + 6),SoulConduit=v17(22256 + 193685, nil, 4 + 7),SummonSoulkeeper=v17(97617 + 288639, nil, 541 - (406 + 123)),InquisitorsGaze=v17(388113 - (1749 + 20), nil, 4 + 9),InquisitorsGazeBuff=v17(389390 - (1249 + 73), nil, 5 + 9),Soulburn=v17(387044 - (466 + 679), nil, 35 - 20),PowerInfusionBuff=v17(28773 - 18713, nil, 1916 - (106 + 1794)),AxeToss=v17(37936 + 81978, nil, 5 + 12),Seduction=v17(354019 - 234110, nil, 48 - 30),ShadowBulwark=v17(120021 - (4 + 110), nil, 603 - (57 + 527)),SingeMagic=v17(121332 - (41 + 1386), nil, 123 - (17 + 86)),SpellLock=v17(81384 + 38526, nil, 46 - 25),BurningRush=v17(322608 - 211208, nil, 721 - (122 + 44))};
	v17.Warlock.Demonology = v20(v17.Warlock.Commons, {Felstorm=v17(155029 - 65278, nil, 72 - 50),HandofGuldan=v17(85558 + 19616, nil, 4 + 19),ShadowBoltLineCD=v17(1389 - 703, nil, 71 - (30 + 35)),SummonPet=v17(20720 + 9426, nil, 1281 - (1043 + 214)),BilescourgeBombers=v17(1010233 - 743022, nil, 1237 - (323 + 889)),CallDreadstalkers=v17(280780 - 176464, nil, 606 - (361 + 219)),Demonbolt=v17(264498 - (53 + 267), nil, 7 + 20),DemonicCalling=v17(205558 - (15 + 398), nil, 1010 - (18 + 964)),DemonicStrength=v17(1005663 - 738492, nil, 17 + 12),Doom=v17(380 + 223, nil, 880 - (20 + 830)),FelDomination=v17(260631 + 73258, nil, 157 - (116 + 10)),FelCovenant=v17(28619 + 358813, nil, 770 - (542 + 196)),FromtheShadows=v17(572734 - 305564, nil, 10 + 23),GrimoireFelguard=v17(56852 + 55046, nil, 13 + 21),Guillotine=v17(1019339 - 632506, nil, 89 - 54),ImpGangBoss=v17(388996 - (1126 + 425), nil, 441 - (118 + 287)),Implosion=v17(769266 - 572989, nil, 1158 - (118 + 1003)),InnerDemons=v17(781989 - 514773, nil, 415 - (142 + 235)),NetherPortal=v17(1212234 - 945017, nil, 9 + 30),PowerSiphon=v17(265107 - (553 + 424), nil, 75 - 35),SacrificedSouls=v17(235394 + 31820, nil, 41 + 0),SoulboundTyrant=v17(194814 + 139771, nil, 18 + 24),SoulStrike=v17(150795 + 113262, nil, 92 - 49),SummonDemonicTyrant=v17(738894 - 473707, nil, 98 - 54),SummonVilefiend=v17(76804 + 187315, nil, 217 - 172),TheExpendables=v17(388353 - (239 + 514), nil, 17 + 29),ReignofTyranny=v17(429013 - (797 + 532), nil, 96 + 36),GrandWarlocksDesign=v17(130584 + 256500, nil, 312 - 179),DemonicCallingBuff=v17(206348 - (373 + 829), nil, 778 - (476 + 255)),DemonicCoreBuff=v17(265303 - (369 + 761), nil, 28 + 20),DemonicPowerBuff=v17(481839 - 216566, nil, 92 - 43),FelCovenantBuff=v17(387675 - (64 + 174), nil, 8 + 42),NetherPortalBuff=v17(395733 - 128515, nil, 387 - (144 + 192)),DoomDebuff=v17(819 - (42 + 174), nil, 40 + 12),FromtheShadowsDebuff=v17(224132 + 46437, nil, 23 + 30),DoomBrandDebuff=v17(425087 - (363 + 1141)),DrainLife=v17(235733 - (1183 + 397), nil, 167 - 112),DoomBrand=v17(310507 + 113077)});
	v17.Warlock.Affliction = v20(v17.Warlock.Commons, {Agony=v17(733 + 247, nil, 2029 - (1913 + 62)),DrainLife=v17(147465 + 86688, nil, 145 - 90),SummonPet=v17(2621 - (565 + 1368), nil, 210 - 154),AbsoluteCorruption=v17(197764 - (1477 + 184), nil, 77 - 20),DoomBlossom=v17(363164 + 26600),DrainSoul=v17(199446 - (564 + 292), nil, 99 - 41),DreadTouch=v17(1174847 - 785072, nil, 363 - (244 + 60)),Haunt=v17(37047 + 11134, nil, 536 - (41 + 435)),InevitableDemise=v17(335320 - (938 + 63), nil, 47 + 14),MaleficAffliction=v17(390886 - (936 + 189), nil, 21 + 41),MaleficRapture=v17(326149 - (1565 + 48), nil, 39 + 24),Nightfall=v17(109696 - (782 + 356), nil, 331 - (176 + 91)),PhantomSingularity=v17(534558 - 329379, nil, 95 - 30),SowTheSeeds=v17(197318 - (975 + 117), nil, 1941 - (157 + 1718)),SeedofCorruption=v17(22110 + 5133, nil, 237 - 170),ShadowEmbrace=v17(93138 - 65895, nil, 1086 - (697 + 321)),SiphonLife=v17(171908 - 108802, nil, 145 - 76),SoulRot=v17(892175 - 505178, nil, 28 + 42),SoulSwap=v17(725013 - 338062, nil, 190 - 119),SoulTap=v17(388300 - (322 + 905), nil, 683 - (602 + 9)),SouleatersGluttony=v17(390819 - (449 + 740), nil, 945 - (826 + 46)),SowtheSeeds=v17(197173 - (245 + 702), nil, 233 - 159),TormentedCrescendo=v17(124433 + 262642, nil, 1973 - (260 + 1638)),UnstableAffliction=v17(316539 - (382 + 58), nil, 243 - 167),VileTaint=v17(231297 + 47053, nil, 159 - 82),InevitableDemiseBuff=v17(993801 - 659481, nil, 1283 - (902 + 303)),NightfallBuff=v17(580902 - 316331, nil, 190 - 111),MaleficAfflictionBuff=v17(33500 + 356345, nil, 1770 - (1121 + 569)),TormentedCrescendoBuff=v17(387293 - (22 + 192), nil, 764 - (483 + 200)),UmbrafireKindlingBuff=v17(425228 - (1404 + 59)),AgonyDebuff=v17(2682 - 1702, nil, 109 - 27),CorruptionDebuff=v17(147504 - (468 + 297), nil, 645 - (334 + 228)),HauntDebuff=v17(162513 - 114332, nil, 194 - 110),PhantomSingularityDebuff=v17(372121 - 166942, nil, 25 + 60),SeedofCorruptionDebuff=v17(27479 - (141 + 95), nil, 85 + 1),SiphonLifeDebuff=v17(162435 - 99329, nil, 208 - 121),UnstableAfflictionDebuff=v17(74042 + 242057, nil, 241 - 153),VileTaintDebuff=v17(195678 + 82672, nil, 47 + 42),SoulRotDebuff=v17(544985 - 157988, nil, 54 + 36),DreadTouchDebuff=v17(390031 - (92 + 71), nil, 45 + 46),ShadowEmbraceDebuff=v17(54457 - 22067, nil, 857 - (574 + 191))});
	v17.Warlock.Destruction = v20(v17.Warlock.Commons, {Immolate=v17(288 + 60, nil, 232 - 139),Incinerate=v17(15182 + 14540, nil, 943 - (254 + 595)),SummonPet=v17(814 - (55 + 71), nil, 124 - 29),AshenRemains=v17(389042 - (573 + 1217), nil, 265 - 169),AvatarofDestruction=v17(29458 + 357701, nil, 155 - 58),Backdraft=v17(197345 - (714 + 225), nil, 286 - 188),BurntoAshes=v17(539753 - 152600, nil, 11 + 88),Cataclysm=v17(220244 - 68136, nil, 906 - (118 + 688)),ChannelDemonfire=v17(196495 - (25 + 23), nil, 20 + 81),ChaosBolt=v17(118744 - (927 + 959), nil, 343 - 241),ChaosIncarnate=v17(388007 - (16 + 716)),Chaosbringer=v17(814741 - 392684),Conflagrate=v17(18059 - (11 + 86), nil, 250 - 147),CrashingChaos=v17(417519 - (175 + 110)),CryHavoc=v17(978413 - 590891, nil, 512 - 408),DiabolicEmbers=v17(388969 - (503 + 1293), nil, 293 - 188),DimensionalRift=v17(280570 + 107406, nil, 1167 - (810 + 251)),Eradication=v17(136306 + 60106, nil, 33 + 74),FireandBrimstone=v17(177053 + 19355, nil, 641 - (43 + 490)),Havoc=v17(80973 - (711 + 22), nil, 421 - 312),Inferno=v17(271404 - (240 + 619), nil, 27 + 83),InternalCombustion=v17(423340 - 157206, nil, 8 + 103),MadnessoftheAzjAqir=v17(389144 - (1344 + 400), nil, 517 - (255 + 150)),Mayhem=v17(305230 + 82276, nil, 61 + 52),RagingDemonfire=v17(1654197 - 1267031, nil, 367 - 253),RainofChaos=v17(267825 - (404 + 1335), nil, 521 - (183 + 223)),RainofFire=v17(6984 - 1244, nil, 77 + 39),RoaringBlaze=v17(73841 + 131343, nil, 454 - (10 + 327)),Ruin=v17(269575 + 117528, nil, 456 - (118 + 220)),SoulFire=v17(2118 + 4235, nil, 568 - (108 + 341)),SummonInfernal=v17(504 + 618, nil, 507 - 387),BackdraftBuff=v17(119321 - (711 + 782), nil, 231 - 110),MadnessCBBuff=v17(387878 - (270 + 199), nil, 40 + 82),MadnessRoFBuff=v17(389232 - (580 + 1239)),MadnessSBBuff=v17(1151699 - 764285),RainofChaosBuff=v17(254420 + 11667, nil, 5 + 118),RitualofRuinBuff=v17(168655 + 218502, nil, 323 - 199),BurntoAshesBuff=v17(240522 + 146632, nil, 1292 - (645 + 522)),EradicationDebuff=v17(198204 - (1010 + 780), nil, 126 + 0),ConflagrateDebuff=v17(1266871 - 1000940),HavocDebuff=v17(235139 - 154899, nil, 1963 - (1045 + 791)),ImmolateDebuff=v17(399274 - 241538, nil, 195 - 67),PyrogenicsDebuff=v17(387601 - (351 + 154)),RoaringBlazeDebuff=v17(267505 - (1281 + 293), nil, 395 - (28 + 238))});
	if (((7623 - 4211) > (2378 - (1381 + 178))) and not v19.Warlock) then
		v19.Warlock = {};
	end
	v19.Warlock.Commons = {Healthstone=v19(20 + 1),PotionOfWitheringDreams=v19(166946 + 40095),ConjuredChillglobe=v19(82881 + 111419, {(7 + 6),(13 + 1)}),DesperateInvokersCodex=v19(131410 + 62900, {(1169 - (1074 + 82)),(1798 - (214 + 1570))}),TimebreachingTalon=v19(195246 - (990 + 465), {(6 + 7),(55 - 41)}),TimeThiefsGambit=v19(209305 - (1668 + 58), {(33 - 20),(48 - 34)}),BelorrelostheSuncaller=v19(96379 + 110793, {(12 + 1),(2008 - (109 + 1885))}),Iridal=v19(209790 - (1269 + 200), {(831 - (98 + 717))}),NymuesUnravelingSpindle=v19(209441 - (802 + 24), {(15 - 2),(11 + 3)}),MirrorofFracturedTomorrows=v19(34097 + 173484, {(36 - 23),(6 + 8)}),RubyWhelpShell=v19(78871 + 114886, {(10 + 3),(1447 - (797 + 636))}),WhisperingIncarnateIcon=v19(943401 - 749100, {(5 + 8),(13 + 1)}),AshesoftheEmbersoul=v19(93885 + 113282, {(1289 - (316 + 960)),(11 + 3)}),BeacontotheBeyond=v19(188525 + 15438, {(564 - (83 + 468)),(65 - 51)}),IcebloodDeathsnare=v19(323384 - 129080, {(338 - (45 + 280)),(13 + 1)}),IrideusFragment=v19(70744 + 122999, {(3 + 10),(1925 - (340 + 1571))}),NeltharionsCallToDominance=v19(80543 + 123659, {(35 - 22),(1962 - (1096 + 852))}),RotcrustedVoodooDoll=v19(71604 + 88020, {(13 + 0),(250 - (46 + 190))}),SpoilsofNeltharus=v19(193868 - (51 + 44), {(1330 - (1114 + 203)),(4 + 10)}),VoidmendersShadowgem=v19(60775 + 49232, {(33 - 20),(538 - (303 + 221))})};
	v19.Warlock.Affliction = v20(v19.Warlock.Commons, {});
	v19.Warlock.Demonology = v20(v19.Warlock.Commons, {});
	v19.Warlock.Destruction = v20(v19.Warlock.Commons, {});
	if (((4431 - (231 + 1038)) <= (2868 + 573)) and not v23.Warlock) then
		v23.Warlock = {};
	end
	v23.Warlock.Commons = {Healthstone=v23(1183 - (171 + 991)),HealingPotion=v23(41 - 31),ConjuredChillglobe=v23(58 - 36),DesperateInvokersCodex=v23(57 - 34),TimebreachingTalon=v23(20 + 4),AxeTossMouseover=v23(83 - 59),CorruptionMouseover=v23(72 - 47),SpellLockMouseover=v23(41 - 15),ShadowBoltPetAttack=v23(83 - 56),IridialStaff=v23(1288 - (111 + 1137)),CancelBurningRush=v23(199 - (91 + 67))};
	v23.Warlock.Affliction = v20(v23.Warlock.Commons, {AgonyMouseover=v23(83 - 55),VileTaintCursor=v23(8 + 21)});
	v23.Warlock.Demonology = v20(v23.Warlock.Commons, {DemonboltPetAttack=v23(553 - (423 + 100)),DoomMouseover=v23(1 + 30),GuillotineCursor=v23(88 - 56)});
	v23.Warlock.Destruction = v20(v23.Warlock.Commons, {HavocMouseover=v23(18 + 15),ImmolateMouseover=v23(805 - (326 + 445)),ImmolatePetAttack=v23(152 - 117),RainofFireCursor=v23(79 - 43),SummonInfernalCursor=v23(86 - 49)});
	v11.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v11.GuardiansTable = {Pets={},ImpCount=(711 - (530 + 181)),FelguardDuration=(881 - (614 + 267)),DreadstalkerDuration=(32 - (19 + 13)),DemonicTyrantDuration=(0 - 0),VilefiendDuration=(0 - 0),PitLordDuration=(0 - 0),Infernal=(0 + 0),Blasphemy=(0 - 0),DarkglareDuration=(0 - 0),InnerDemonsNextCast=(1812 - (1293 + 519)),ImpsSpawnedFromHoG=(0 - 0)};
	local v40 = {[255964 - 157929]={name="Dreadstalker",duration=(22.25 - 10)},[240007 - 184348]={name="Wild Imp",duration=(47 - 27)},[76069 + 67553]={name="Wild Imp",duration=(5 + 15)},[40084 - 22832]={name="Felguard",duration=(4 + 13)},[44849 + 90153]={name="Demonic Tyrant",duration=(10 + 5)},[136912 - (709 + 387)]={name="Vilefiend",duration=(1873 - (673 + 1185))},[568749 - 372638]={name="Pit Lord",duration=(32 - 22)},[145 - 56]={name="Infernal",duration=(22 + 8)},[138669 + 46915]={name="Blasphemy",duration=(10 - 2)},[25463 + 78210]={name="Darkglare",duration=(49 - 24)}};
	v11:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(15 - 7, ...);
		if (((6586 - (446 + 1434)) > (5712 - (1040 + 243))) and (SpellID == (470781 - 313045))) then
			v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 1847 - (559 + 1288);
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v11:RegisterForSelfCombatEvent(function(...)
		local v45 = 1931 - (609 + 1322);
		while true do
			if (((3308 - (13 + 441)) < (15302 - 11207)) and (v45 == (0 - 0))) then
				DestGUID, _, _, _, SpellID = select(39 - 31, ...);
				if ((SpellID == (5874 + 151862)) or ((3842 - 2784) >= (427 + 775))) then
					if (((1627 + 2084) > (9956 - 6601)) and v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
						v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED");
	v11:RegisterForCombatEvent(function(...)
		local v46 = 0 + 0;
		while true do
			if ((v46 == (0 - 0)) or ((599 + 307) >= (1240 + 989))) then
				DestGUID = select(6 + 2, ...);
				if (((1082 + 206) > (1224 + 27)) and v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
					v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
				end
				break;
			end
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v11:RegisterForSelfCombatEvent(function(...)
		local v47 = 433 - (153 + 280);
		while true do
			if ((v47 == (0 - 0)) or ((4052 + 461) < (1324 + 2028))) then
				DestGUID, _, _, _, SpellID = select(5 + 3, ...);
				if ((SpellID == (16301 + 1661)) or ((1497 + 568) >= (4866 - 1670))) then
					if (v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((2705 + 1671) <= (2148 - (89 + 578)))) then
						v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + 1 + 0;
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v24.UpdatePetTable = function()
		for v68, v69 in pairs(v11.GuardiansTable.Pets) do
			if (v69 or ((7051 - 3659) >= (5790 - (572 + 477)))) then
				if (((449 + 2876) >= (1293 + 861)) and (GetTime() >= v69.despawnTime)) then
					local v81 = 0 + 0;
					while true do
						if ((v81 == (87 - (84 + 2))) or ((2134 - 839) >= (2330 + 903))) then
							v11.GuardiansTable.Pets[v68] = nil;
							break;
						end
						if (((5219 - (497 + 345)) > (43 + 1599)) and (v81 == (0 + 0))) then
							if (((6056 - (605 + 728)) > (968 + 388)) and (v69.name == "Wild Imp")) then
								v11.GuardiansTable.ImpCount = v11.GuardiansTable.ImpCount - (1 - 0);
							end
							if ((v69.name == "Felguard") or ((190 + 3946) <= (12692 - 9259))) then
								v11.GuardiansTable.FelguardDuration = 0 + 0;
							elseif (((11761 - 7516) <= (3497 + 1134)) and (v69.name == "Dreadstalker")) then
								v11.GuardiansTable.DreadstalkerDuration = 489 - (457 + 32);
							elseif (((1815 + 2461) >= (5316 - (832 + 570))) and (v69.name == "Demonic Tyrant")) then
								v11.GuardiansTable.DemonicTyrantDuration = 0 + 0;
							elseif (((52 + 146) <= (15446 - 11081)) and (v69.name == "Vilefiend")) then
								v11.GuardiansTable.VilefiendDuration = 0 + 0;
							elseif (((5578 - (588 + 208)) > (12602 - 7926)) and (v69.name == "Pit Lord")) then
								v11.GuardiansTable.PitLordDuration = 1800 - (884 + 916);
							elseif (((10182 - 5318) > (1274 + 923)) and (v69.name == "Infernal")) then
								v11.GuardiansTable.InfernalDuration = 653 - (232 + 421);
							elseif ((v69.name == "Blasphemy") or ((5589 - (1569 + 320)) == (616 + 1891))) then
								v11.GuardiansTable.BlasphemyDuration = 0 + 0;
							elseif (((15076 - 10602) >= (879 - (316 + 289))) and (v69.name == "Darkglare")) then
								v11.GuardiansTable.DarkglareDuration = 0 - 0;
							end
							v81 = 1 + 0;
						end
					end
				end
			end
			if ((v69.ImpCasts <= (1453 - (666 + 787))) or ((2319 - (360 + 65)) <= (1314 + 92))) then
				local v74 = 254 - (79 + 175);
				while true do
					if (((2478 - 906) >= (1195 + 336)) and (v74 == (0 - 0))) then
						v11.GuardiansTable.ImpCount = v11.GuardiansTable.ImpCount - (1 - 0);
						v11.GuardiansTable.Pets[v68] = nil;
						break;
					end
				end
			end
			if ((GetTime() <= v69.despawnTime) or ((5586 - (503 + 396)) < (4723 - (92 + 89)))) then
				local v75 = 0 - 0;
				while true do
					if (((1688 + 1603) > (987 + 680)) and (v75 == (0 - 0))) then
						v69.Duration = v69.despawnTime - GetTime();
						if ((v69.name == "Felguard") or ((120 + 753) == (4637 - 2603))) then
							v11.GuardiansTable.FelguardDuration = v69.Duration;
						elseif ((v69.name == "Dreadstalker") or ((2457 + 359) < (6 + 5))) then
							v11.GuardiansTable.DreadstalkerDuration = v69.Duration;
						elseif (((11265 - 7566) < (588 + 4118)) and (v69.name == "Demonic Tyrant")) then
							v11.GuardiansTable.DemonicTyrantDuration = v69.Duration;
						elseif (((4034 - 1388) >= (2120 - (485 + 759))) and (v69.name == "Vilefiend")) then
							v11.GuardiansTable.VilefiendDuration = v69.Duration;
						elseif (((1420 - 806) <= (4373 - (442 + 747))) and (v69.name == "Pit Lord")) then
							v11.GuardiansTable.PitLordDuration = v69.Duration;
						elseif (((4261 - (832 + 303)) == (4072 - (88 + 858))) and (v69.name == "Infernal")) then
							v11.GuardiansTable.InfernalDuration = v69.Duration;
						elseif ((v69.name == "Blasphy") or ((667 + 1520) >= (4100 + 854))) then
							v11.GuardiansTable.BlasphemyDuration = v69.Duration;
						elseif ((v69.name == "Darkglare") or ((160 + 3717) == (4364 - (766 + 23)))) then
							v11.GuardiansTable.DarkglareDuration = v69.Duration;
						end
						break;
					end
				end
			end
		end
	end;
	v11:RegisterForSelfCombatEvent(function(...)
		local v48 = 0 - 0;
		local v49;
		local v50;
		local v51;
		local v52;
		local v53;
		local v54;
		local v55;
		while true do
			if (((966 - 259) > (1664 - 1032)) and (v48 == (0 - 0))) then
				v49, v50, v51, v52, v51, v51, v51, v53, v51, v51, v51, v54 = select(1074 - (1036 + 37), ...);
				v51, v51, v51, v51, v51, v51, v51, v55 = v21(v53, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
				v48 = 1 + 0;
			end
			if ((v48 == (5 - 2)) or ((430 + 116) >= (4164 - (641 + 839)))) then
				if (((2378 - (910 + 3)) <= (10964 - 6663)) and (v55 == (57343 - (1466 + 218))) and (v11.GuardiansTable.ImpsSpawnedFromHoG > (0 + 0))) then
					v11.GuardiansTable.ImpsSpawnedFromHoG = v11.GuardiansTable.ImpsSpawnedFromHoG - (1149 - (556 + 592));
				end
				v24.UpdatePetTable();
				break;
			end
			if (((606 + 1098) > (2233 - (329 + 479))) and (v48 == (856 - (174 + 680)))) then
				if ((v40[v55] and (v40[v55].name == "Demonic Tyrant")) or ((2360 - 1673) == (8775 - 4541))) then
					for v93, v94 in pairs(v11.GuardiansTable.Pets) do
						if ((v94 and (v94.name ~= "Demonic Tyrant") and (v94.name ~= "Pit Lord")) or ((2378 + 952) < (2168 - (396 + 343)))) then
							local v101 = 0 + 0;
							while true do
								if (((2624 - (29 + 1448)) >= (1724 - (135 + 1254))) and (v101 == (0 - 0))) then
									v94.despawnTime = v94.despawnTime + (70 - 55);
									v94.ImpCasts = v94.ImpCasts + 5 + 2;
									break;
								end
							end
						end
					end
				end
				if (((4962 - (389 + 1138)) > (2671 - (102 + 472))) and (v55 == (135535 + 8087))) then
					v11.GuardiansTable.InnerDemonsNextCast = GetTime() + 7 + 5;
				end
				v48 = 3 + 0;
			end
			if ((v48 == (1546 - (320 + 1225))) or ((6711 - 2941) >= (2473 + 1568))) then
				v55 = tonumber(v55);
				if (((v53 ~= UnitGUID("pet")) and (v50 == "SPELL_SUMMON") and v40[v55]) or ((5255 - (157 + 1307)) <= (3470 - (821 + 1038)))) then
					local v84 = v40[v55];
					local v85;
					if ((v84.name == "Wild Imp") or ((11422 - 6844) <= (220 + 1788))) then
						local v97 = 0 - 0;
						while true do
							if (((419 + 706) <= (5145 - 3069)) and (v97 == (1026 - (834 + 192)))) then
								v11.GuardiansTable.ImpCount = v11.GuardiansTable.ImpCount + 1 + 0;
								v85 = v84.duration;
								break;
							end
						end
					elseif ((v84.name == "Felguard") or ((191 + 552) >= (95 + 4304))) then
						local v102 = 0 - 0;
						while true do
							if (((1459 - (300 + 4)) < (447 + 1226)) and (v102 == (0 - 0))) then
								v11.GuardiansTable.FelguardDuration = v84.duration;
								v85 = v84.duration;
								break;
							end
						end
					elseif ((v84.name == "Dreadstalker") or ((2686 - (112 + 250)) <= (231 + 347))) then
						local v111 = 0 - 0;
						while true do
							if (((2159 + 1608) == (1949 + 1818)) and (v111 == (0 + 0))) then
								v11.GuardiansTable.DreadstalkerDuration = v84.duration;
								v85 = v84.duration;
								break;
							end
						end
					elseif (((2028 + 2061) == (3038 + 1051)) and (v84.name == "Demonic Tyrant")) then
						if (((5872 - (1001 + 413)) >= (3732 - 2058)) and (v54 == (266069 - (244 + 638)))) then
							local v122 = 693 - (627 + 66);
							while true do
								if (((2896 - 1924) <= (2020 - (512 + 90))) and (v122 == (1906 - (1665 + 241)))) then
									v11.GuardiansTable.DemonicTyrantDuration = v84.duration;
									v85 = v84.duration;
									break;
								end
							end
						end
					elseif ((v84.name == "Vilefiend") or ((5655 - (373 + 344)) < (2148 + 2614))) then
						v11.GuardiansTable.VilefiendDuration = v84.duration;
						v85 = v84.duration;
					elseif ((v84.name == "Pit Lord") or ((663 + 1841) > (11247 - 6983))) then
						local v128 = 0 - 0;
						while true do
							if (((3252 - (35 + 1064)) == (1567 + 586)) and (v128 == (0 - 0))) then
								v11.GuardiansTable.PitLordDuration = v84.duration;
								v85 = v84.duration;
								break;
							end
						end
					elseif ((v84.name == "Infernal") or ((3 + 504) >= (3827 - (298 + 938)))) then
						local v134 = 1259 - (233 + 1026);
						while true do
							if (((6147 - (636 + 1030)) == (2291 + 2190)) and (v134 == (0 + 0))) then
								v11.GuardiansTable.InfernalDuration = v84.duration;
								v85 = v84.duration;
								break;
							end
						end
					elseif ((v84.name == "Blasphemy") or ((692 + 1636) < (47 + 646))) then
						local v140 = 221 - (55 + 166);
						while true do
							if (((839 + 3489) == (436 + 3892)) and ((0 - 0) == v140)) then
								v11.GuardiansTable.BlasphemyDuration = v84.duration;
								v85 = v84.duration;
								break;
							end
						end
					elseif (((1885 - (36 + 261)) >= (2329 - 997)) and (v84.name == "Darkglare")) then
						local v146 = 1368 - (34 + 1334);
						while true do
							if (((0 + 0) == v146) or ((3244 + 930) > (5531 - (1035 + 248)))) then
								v11.GuardiansTable.DarkglareDuration = v84.duration;
								v85 = v84.duration;
								break;
							end
						end
					end
					local v86 = {ID=v53,name=v84.name,spawnTime=GetTime(),ImpCasts=(26 - (20 + 1)),Duration=v85,despawnTime=(GetTime() + tonumber(v85))};
					table.insert(v11.GuardiansTable.Pets, v86);
				end
				v48 = 2 + 0;
			end
		end
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v11:RegisterForCombatEvent(function(...)
		local v56, v57, v57, v57, v58, v57, v57, v57, v59 = select(323 - (134 + 185), ...);
		if ((v59 == (105451 - (549 + 584))) or ((5271 - (314 + 371)) <= (281 - 199))) then
			for v76, v77 in pairs(v11.GuardiansTable.Pets) do
				if (((4831 - (478 + 490)) == (2047 + 1816)) and (v56 == v77.ID)) then
					v77.ImpCasts = v77.ImpCasts - (1173 - (786 + 386));
				end
			end
		end
		if (((v56 == v14:GUID()) and (v59 == (635740 - 439463))) or ((1661 - (1055 + 324)) <= (1382 - (1093 + 247)))) then
			for v78, v79 in pairs(v11.GuardiansTable.Pets) do
				if (((4096 + 513) >= (81 + 685)) and (v79.name == "Wild Imp")) then
					v11.GuardiansTable.Pets[v78] = nil;
				end
			end
			v11.GuardiansTable.ImpCount = 0 - 0;
		end
		v24.UpdatePetTable();
	end, "SPELL_CAST_SUCCESS");
	v24.LastPI = 0 - 0;
	v11:RegisterForCombatEvent(function(...)
		local v60 = 0 - 0;
		while true do
			if ((v60 == (0 - 0)) or ((410 + 742) == (9584 - 7096))) then
				DestGUID, _, _, _, SpellID = select(27 - 19, ...);
				if (((2581 + 841) > (8567 - 5217)) and (SpellID == (10748 - (364 + 324))) and (DestGUID == v14:GUID())) then
					v24.LastPI = GetTime();
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v24.SoulShards = 0 - 0;
	v24.UpdateSoulShards = function()
		v24.SoulShards = v14:SoulShards();
	end;
	v11:RegisterForSelfCombatEvent(function(v62, v63, v62, v62, v62, v62, v62, v62, v62, v62, v62, v64)
		if (((2104 - 1227) > (125 + 251)) and (v64 == (440082 - 334908))) then
			v11.GuardiansTable.ImpsSpawnedFromHoG = v11.GuardiansTable.ImpsSpawnedFromHoG + (((v24.SoulShards >= (4 - 1)) and (8 - 5)) or v24.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v1["Epix_Warlock_Warlock.lua"](...);

