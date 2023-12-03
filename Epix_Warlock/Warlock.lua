local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1467 - (899 + 568);
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((10966 - 6434) < (1635 - (268 + 335)))) then
			return v6(...);
		end
		if (((290 - (60 + 230)) == v5) or ((892 - (426 + 146)) <= (7 + 45))) then
			v6 = v0[v4];
			if (((2765 - (282 + 1174)) <= (4317 - (569 + 242))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	if (((169 + 2786) == (3979 - (706 + 318))) and not v16.Warlock) then
		v16.Warlock = {};
	end
	v16.Warlock.Commons = {Berserking=v16(27548 - (721 + 530), nil, 1272 - (945 + 326)),BloodFury=v16(84197 - 50495, nil, 2 + 0),Fireblood=v16(265921 - (271 + 429), nil, 3 + 0),Corruption=v16(1672 - (1408 + 92), nil, 1090 - (461 + 625)),DarkPact=v16(109704 - (993 + 295), nil, 1 + 4),ShadowBolt=v16(1857 - (418 + 753), nil, 3 + 3),SummonDarkglare=v16(21147 + 184033, nil, 3 + 4),UnendingResolve=v16(26479 + 78294, nil, 537 - (406 + 123)),GrimoireofSacrifice=v16(110272 - (1749 + 20), nil, 3 + 6),GrimoireofSacrificeBuff=v16(197421 - (1249 + 73), nil, 4 + 6),SoulConduit=v16(217086 - (466 + 679), nil, 26 - 15),SummonSoulkeeper=v16(1104764 - 718508, nil, 1912 - (106 + 1794)),InquisitorsGaze=v16(122221 + 264123, nil, 4 + 9),InquisitorsGazeBuff=v16(1145732 - 757664, nil, 37 - 23),Soulburn=v16(386013 - (4 + 110), nil, 599 - (57 + 527)),PowerInfusionBuff=v16(11487 - (41 + 1386), nil, 119 - (17 + 86)),AxeToss=v16(81387 + 38527, nil, 37 - 20),Seduction=v16(347249 - 227340, nil, 184 - (122 + 44)),ShadowBulwark=v16(207118 - 87211, nil, 62 - 43),SingeMagic=v16(97541 + 22364, nil, 3 + 17),SpellLock=v16(242920 - 123010, nil, 86 - (30 + 35))};
	v16.Warlock.Demonology = v19(v16.Warlock.Commons, {Felstorm=v16(61687 + 28064, nil, 1279 - (1043 + 214)),HandofGuldan=v16(397626 - 292452, nil, 1235 - (323 + 889)),SummonPet=v16(81141 - 50995, nil, 604 - (361 + 219)),BilescourgeBombers=v16(267531 - (53 + 267), nil, 6 + 19),CallDreadstalkers=v16(104729 - (15 + 398), nil, 1008 - (18 + 964)),Demonbolt=v16(994397 - 730219, nil, 16 + 11),DemonicCalling=v16(129249 + 75896, nil, 878 - (20 + 830)),DemonicStrength=v16(208551 + 58620, nil, 155 - (116 + 10)),Doom=v16(45 + 558, nil, 768 - (542 + 196)),FelDomination=v16(715760 - 381871, nil, 10 + 21),FelCovenant=v16(196842 + 190590, nil, 12 + 20),FromtheShadows=v16(704017 - 436847, nil, 84 - 51),GrimoireFelguard=v16(113449 - (1126 + 425), nil, 439 - (118 + 287)),Guillotine=v16(1516111 - 1129278, nil, 1156 - (118 + 1003)),ImpGangBoss=v16(1133831 - 746386, nil, 413 - (142 + 235)),Implosion=v16(890414 - 694137, nil, 9 + 28),InnerDemons=v16(268193 - (553 + 424), nil, 71 - 33),NetherPortal=v16(235396 + 31821, nil, 39 + 0),PowerSiphon=v16(153792 + 110338, nil, 18 + 22),SacrificedSouls=v16(152598 + 114616, nil, 88 - 47),SoulboundTyrant=v16(932259 - 597674, nil, 93 - 51),SoulStrike=v16(76786 + 187271, nil, 207 - 164),SummonDemonicTyrant=v16(265940 - (239 + 514), nil, 16 + 28),SummonVilefiend=v16(265448 - (797 + 532), nil, 33 + 12),TheExpendables=v16(130758 + 256842, nil, 107 - 61),ReignofTyranny=v16(428886 - (373 + 829), nil, 863 - (476 + 255)),GrandWarlocksDesign=v16(388214 - (369 + 761), nil, 77 + 56),DemonicCallingBuff=v16(372624 - 167478, nil, 89 - 42),DemonicCoreBuff=v16(264411 - (64 + 174), nil, 7 + 41),DemonicPowerBuff=v16(392852 - 127579, nil, 385 - (144 + 192)),FelCovenantBuff=v16(387653 - (42 + 174), nil, 38 + 12),NetherPortalBuff=v16(221356 + 45862, nil, 22 + 29),DoomDebuff=v16(2107 - (363 + 1141), nil, 1632 - (1183 + 397)),FromtheShadowsDebuff=v16(823704 - 553135, nil, 39 + 14),DoomBrandDebuff=v16(316611 + 106972)});
	v16.Warlock.Affliction = v19(v16.Warlock.Commons, {Agony=v16(2955 - (1913 + 62), nil, 35 + 19),DrainLife=v16(619873 - 385720, nil, 1988 - (565 + 1368)),SummonPet=v16(2587 - 1899, nil, 1717 - (1477 + 184)),AbsoluteCorruption=v16(267205 - 71102, nil, 54 + 3),DrainSoul=v16(199446 - (564 + 292), nil, 99 - 41),DreadTouch=v16(1174847 - 785072, nil, 363 - (244 + 60)),Haunt=v16(37047 + 11134, nil, 536 - (41 + 435)),InevitableDemise=v16(335320 - (938 + 63), nil, 47 + 14),MaleficAffliction=v16(390886 - (936 + 189), nil, 21 + 41),MaleficRapture=v16(326149 - (1565 + 48), nil, 39 + 24),Nightfall=v16(109696 - (782 + 356), nil, 331 - (176 + 91)),PhantomSingularity=v16(534558 - 329379, nil, 95 - 30),SowTheSeeds=v16(197318 - (975 + 117), nil, 1941 - (157 + 1718)),SeedofCorruption=v16(22110 + 5133, nil, 237 - 170),ShadowEmbrace=v16(93138 - 65895, nil, 1086 - (697 + 321)),SiphonLife=v16(171908 - 108802, nil, 145 - 76),SoulRot=v16(892175 - 505178, nil, 28 + 42),SoulSwap=v16(725013 - 338062, nil, 190 - 119),SoulTap=v16(388300 - (322 + 905), nil, 683 - (602 + 9)),SouleatersGluttony=v16(390819 - (449 + 740), nil, 945 - (826 + 46)),SowtheSeeds=v16(197173 - (245 + 702), nil, 233 - 159),TormentedCrescendo=v16(124433 + 262642, nil, 1973 - (260 + 1638)),UnstableAffliction=v16(316539 - (382 + 58), nil, 243 - 167),VileTaint=v16(231297 + 47053, nil, 159 - 82),InevitableDemiseBuff=v16(993801 - 659481, nil, 1283 - (902 + 303)),NightfallBuff=v16(580902 - 316331, nil, 190 - 111),MaleficAfflictionBuff=v16(33500 + 356345, nil, 1770 - (1121 + 569)),TormentedCrescendoBuff=v16(387293 - (22 + 192), nil, 764 - (483 + 200)),UmbrafireKindlingBuff=v16(425228 - (1404 + 59)),AgonyDebuff=v16(2682 - 1702, nil, 109 - 27),CorruptionDebuff=v16(147504 - (468 + 297), nil, 645 - (334 + 228)),HauntDebuff=v16(162513 - 114332, nil, 194 - 110),PhantomSingularityDebuff=v16(372121 - 166942, nil, 25 + 60),SeedofCorruptionDebuff=v16(27479 - (141 + 95), nil, 85 + 1),SiphonLifeDebuff=v16(162435 - 99329, nil, 208 - 121),UnstableAfflictionDebuff=v16(74042 + 242057, nil, 241 - 153),VileTaintDebuff=v16(195678 + 82672, nil, 47 + 42),SoulRotDebuff=v16(544985 - 157988, nil, 54 + 36),DreadTouchDebuff=v16(390031 - (92 + 71), nil, 45 + 46),ShadowEmbraceDebuff=v16(54457 - 22067, nil, 857 - (574 + 191))});
	v16.Warlock.Destruction = v19(v16.Warlock.Commons, {Immolate=v16(288 + 60, nil, 232 - 139),Incinerate=v16(15182 + 14540, nil, 943 - (254 + 595)),SummonPet=v16(814 - (55 + 71), nil, 124 - 29),AshenRemains=v16(389042 - (573 + 1217), nil, 265 - 169),AvatarofDestruction=v16(29458 + 357701, nil, 155 - 58),Backdraft=v16(197345 - (714 + 225), nil, 286 - 188),BurntoAshes=v16(539753 - 152600, nil, 11 + 88),Cataclysm=v16(220244 - 68136, nil, 906 - (118 + 688)),ChannelDemonfire=v16(196495 - (25 + 23), nil, 20 + 81),ChaosBolt=v16(118744 - (927 + 959), nil, 343 - 241),Conflagrate=v16(18694 - (16 + 716), nil, 198 - 95),CryHavoc=v16(387619 - (11 + 86), nil, 253 - 149),DiabolicEmbers=v16(387458 - (175 + 110), nil, 264 - 159),DimensionalRift=v16(1913594 - 1525618, nil, 1902 - (503 + 1293)),Eradication=v16(548539 - 352127, nil, 78 + 29),FireandBrimstone=v16(197469 - (810 + 251), nil, 75 + 33),Havoc=v16(24626 + 55614, nil, 99 + 10),Inferno=v16(271078 - (43 + 490), nil, 843 - (711 + 22)),InternalCombustion=v16(1029461 - 763327, nil, 970 - (240 + 619)),MadnessoftheAzjAqir=v16(93485 + 293915, nil, 177 - 65),Mayhem=v16(25646 + 361860, nil, 1857 - (1344 + 400)),RagingDemonfire=v16(387571 - (255 + 150), nil, 90 + 24),RainofChaos=v16(142456 + 123630, nil, 491 - 376),RainofFire=v16(18539 - 12799, nil, 1855 - (404 + 1335)),RoaringBlaze=v16(205590 - (183 + 223), nil, 141 - 24),Ruin=v16(256490 + 130613, nil, 43 + 75),SoulFire=v16(6690 - (10 + 327), nil, 83 + 36),SummonInfernal=v16(1460 - (118 + 220), nil, 40 + 80),BackdraftBuff=v16(118277 - (108 + 341), nil, 55 + 66),MadnessCBBuff=v16(1637890 - 1250481, nil, 1615 - (711 + 782)),RainofChaosBuff=v16(510097 - 244010, nil, 592 - (270 + 199)),RitualofRuinBuff=v16(125512 + 261645, nil, 1943 - (580 + 1239)),BurntoAshesBuff=v16(1150926 - 763772, nil, 120 + 5),EradicationDebuff=v16(7056 + 189358, nil, 55 + 71),HavocDebuff=v16(209504 - 129264, nil, 79 + 48),ImmolateDebuff=v16(158903 - (645 + 522), nil, 1918 - (1010 + 780)),RoaringBlazeDebuff=v16(265800 + 131, nil, 614 - 485)});
	if (not v18.Warlock or ((8507 - 5604) == (3331 - (1045 + 791)))) then
		v18.Warlock = {};
	end
	v18.Warlock.Commons = {Healthstone=v18(53 - 32),ConjuredChillglobe=v18(296686 - 102386, {(1587 - (1281 + 293)),(31 - 17)}),DesperateInvokersCodex=v18(195869 - (1381 + 178), {(11 + 2),(48 - 34)}),TimebreachingTalon=v18(100397 + 93394, {(12 + 1),(23 - 9)}),TimeThiefsGambit=v18(208735 - (1074 + 82), {(1797 - (214 + 1570)),(6 + 8)}),BelorrelostheSuncaller=v18(90146 + 117026, {(50 - 37),(640 - (512 + 114))})};
	v18.Warlock.Affliction = v19(v18.Warlock.Commons, {});
	v18.Warlock.Demonology = v19(v18.Warlock.Commons, {});
	v18.Warlock.Destruction = v19(v18.Warlock.Commons, {});
	if (((11851 - 7305) >= (4702 - 2427)) and not v22.Warlock) then
		v22.Warlock = {};
	end
	v22.Warlock.Commons = {Healthstone=v22(72 - 51),ConjuredChillglobe=v22(11 + 11),DesperateInvokersCodex=v22(5 + 18),TimebreachingTalon=v22(21 + 3),AxeTossMouseover=v22(80 - 56),CorruptionMouseover=v22(2019 - (109 + 1885)),SpellLockMouseover=v22(1495 - (1269 + 200)),ShadowBoltPetAttack=v22(51 - 24)};
	v22.Warlock.Affliction = v19(v22.Warlock.Commons, {AgonyMouseover=v22(843 - (98 + 717)),VileTaintCursor=v22(855 - (802 + 24))});
	v22.Warlock.Demonology = v19(v22.Warlock.Commons, {DemonboltPetAttack=v22(51 - 21),DoomMouseover=v22(38 - 7),GuillotineCursor=v22(5 + 27)});
	v22.Warlock.Destruction = v19(v22.Warlock.Commons, {HavocMouseover=v22(26 + 7),ImmolateMouseover=v22(6 + 28),ImmolatePetAttack=v22(8 + 27),RainofFireCursor=v22(100 - 64),SummonInfernalCursor=v22(123 - 86)});
	v10.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v10.GuardiansTable = {Pets={},ImpCount=(0 + 0),FelguardDuration=(0 + 0),DreadstalkerDuration=(0 + 0),DemonicTyrantDuration=(0 + 0),VilefiendDuration=(0 + 0),PitLordDuration=(1433 - (797 + 636)),Infernal=(0 - 0),Blasphemy=(1619 - (1427 + 192)),DarkglareDuration=(0 + 0),InnerDemonsNextCast=(0 - 0),ImpsSpawnedFromHoG=(0 + 0)};
	local v39 = {[44428 + 53607]={name="Dreadstalker",duration=(338.25 - (192 + 134))},[56935 - (316 + 960)]={name="Wild Imp",duration=(12 + 8)},[110836 + 32786]={name="Wild Imp",duration=(19 + 1)},[65954 - 48702]={name="Felguard",duration=(568 - (83 + 468))},[136808 - (1202 + 604)]={name="Demonic Tyrant",duration=(70 - 55)},[226040 - 90224]={name="Vilefiend",duration=(41 - 26)},[196436 - (45 + 280)]={name="Pit Lord",duration=(10 + 0)},[78 + 11]={name="Infernal",duration=(11 + 19)},[102697 + 82887]={name="Blasphemy",duration=(2 + 6)},[191978 - 88305]={name="Darkglare",duration=(1936 - (340 + 1571))}};
	v10:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(4 + 4, ...);
		if (((2591 - (1733 + 39)) >= (60 - 38)) and (SpellID == (158770 - (125 + 909)))) then
			v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 1948 - (1096 + 852);
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v10:RegisterForSelfCombatEvent(function(...)
		local v44 = 0 + 0;
		while true do
			if (((4515 - 1353) == (3067 + 95)) and (v44 == (512 - (409 + 103)))) then
				DestGUID, _, _, _, SpellID = select(244 - (46 + 190), ...);
				if ((SpellID == (157831 - (51 + 44))) or ((669 + 1700) > (5746 - (1114 + 203)))) then
					if (((4821 - (228 + 498)) >= (690 + 2493)) and v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
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
			if ((v45 == (663 - (174 + 489))) or ((9668 - 5957) < (2913 - (830 + 1075)))) then
				DestGUID = select(532 - (303 + 221), ...);
				if (v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((2318 - (231 + 1038)) <= (755 + 151))) then
					v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
				end
				break;
			end
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v46 = 1162 - (171 + 991);
		while true do
			if (((18598 - 14085) > (7319 - 4593)) and (v46 == (0 - 0))) then
				DestGUID, _, _, _, SpellID = select(7 + 1, ...);
				if ((SpellID == (62963 - 45001)) or ((4272 - 2791) >= (4284 - 1626))) then
					if (v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((9953 - 6733) == (2612 - (111 + 1137)))) then
						v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v10.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + (159 - (91 + 67));
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v23.UpdatePetTable = function()
		for v66, v67 in pairs(v10.GuardiansTable.Pets) do
			if (v67 or ((3136 - 2082) > (847 + 2545))) then
				if ((GetTime() >= v67.despawnTime) or ((1199 - (423 + 100)) >= (12 + 1630))) then
					local v83 = 0 - 0;
					while true do
						if (((2156 + 1980) > (3168 - (326 + 445))) and (v83 == (4 - 3))) then
							v10.GuardiansTable.Pets[v66] = nil;
							break;
						end
						if ((v83 == (0 - 0)) or ((10116 - 5782) == (4956 - (530 + 181)))) then
							if ((v67.name == "Wild Imp") or ((5157 - (614 + 267)) <= (3063 - (19 + 13)))) then
								v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (1 - 0);
							end
							if ((v67.name == "Felguard") or ((11143 - 6361) <= (3425 - 2226))) then
								v10.GuardiansTable.FelguardDuration = 0 + 0;
							elseif ((v67.name == "Dreadstalker") or ((8554 - 3690) < (3943 - 2041))) then
								v10.GuardiansTable.DreadstalkerDuration = 1812 - (1293 + 519);
							elseif (((9872 - 5033) >= (9660 - 5960)) and (v67.name == "Demonic Tyrant")) then
								v10.GuardiansTable.DemonicTyrantDuration = 0 - 0;
							elseif ((v67.name == "Vilefiend") or ((4635 - 3560) > (4518 - 2600))) then
								v10.GuardiansTable.VilefiendDuration = 0 + 0;
							elseif (((81 + 315) <= (8838 - 5034)) and (v67.name == "Pit Lord")) then
								v10.GuardiansTable.PitLordDuration = 0 + 0;
							elseif ((v67.name == "Infernal") or ((1385 + 2784) == (1367 + 820))) then
								v10.GuardiansTable.InfernalDuration = 1096 - (709 + 387);
							elseif (((3264 - (673 + 1185)) == (4077 - 2671)) and (v67.name == "Blasphemy")) then
								v10.GuardiansTable.BlasphemyDuration = 0 - 0;
							elseif (((2518 - 987) < (3055 + 1216)) and (v67.name == "Darkglare")) then
								v10.GuardiansTable.DarkglareDuration = 0 + 0;
							end
							v83 = 1 - 0;
						end
					end
				end
			end
			if (((156 + 479) == (1266 - 631)) and (v67.ImpCasts <= (0 - 0))) then
				local v78 = 1880 - (446 + 1434);
				while true do
					if (((4656 - (1040 + 243)) <= (10613 - 7057)) and (v78 == (1847 - (559 + 1288)))) then
						v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount - (1932 - (609 + 1322));
						v10.GuardiansTable.Pets[v66] = nil;
						break;
					end
				end
			end
			if ((GetTime() <= v67.despawnTime) or ((3745 - (13 + 441)) < (12256 - 8976))) then
				local v79 = 0 - 0;
				while true do
					if (((21844 - 17458) >= (33 + 840)) and (v79 == (0 - 0))) then
						v67.Duration = v67.despawnTime - GetTime();
						if (((328 + 593) <= (483 + 619)) and (v67.name == "Felguard")) then
							v10.GuardiansTable.FelguardDuration = v67.Duration;
						elseif (((13965 - 9259) >= (527 + 436)) and (v67.name == "Dreadstalker")) then
							v10.GuardiansTable.DreadstalkerDuration = v67.Duration;
						elseif ((v67.name == "Demonic Tyrant") or ((1765 - 805) <= (580 + 296))) then
							v10.GuardiansTable.DemonicTyrantDuration = v67.Duration;
						elseif ((v67.name == "Vilefiend") or ((1150 + 916) == (670 + 262))) then
							v10.GuardiansTable.VilefiendDuration = v67.Duration;
						elseif (((4052 + 773) < (4739 + 104)) and (v67.name == "Pit Lord")) then
							v10.GuardiansTable.PitLordDuration = v67.Duration;
						elseif ((v67.name == "Infernal") or ((4310 - (153 + 280)) >= (13100 - 8563))) then
							v10.GuardiansTable.InfernalDuration = v67.Duration;
						elseif ((v67.name == "Blasphy") or ((3875 + 440) < (682 + 1044))) then
							v10.GuardiansTable.BlasphemyDuration = v67.Duration;
						elseif ((v67.name == "Darkglare") or ((1926 + 1753) < (568 + 57))) then
							v10.GuardiansTable.DarkglareDuration = v67.Duration;
						end
						break;
					end
				end
			end
		end
	end;
	v10:RegisterForSelfCombatEvent(function(...)
		local v47, v48, v49, v50, v49, v49, v49, v51, v49, v49, v49, v52 = select(1 + 0, ...);
		local v49, v49, v49, v49, v49, v49, v49, v53 = v20(v51, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
		v53 = tonumber(v53);
		if (((v51 ~= UnitGUID("pet")) and (v48 == "SPELL_SUMMON") and v39[v53]) or ((7042 - 2417) < (391 + 241))) then
			local v70 = 667 - (89 + 578);
			local v71;
			local v72;
			local v73;
			while true do
				if (((1 + 0) == v70) or ((171 - 88) > (2829 - (572 + 477)))) then
					if (((74 + 472) <= (647 + 430)) and (v71.name == "Wild Imp")) then
						local v97 = 0 + 0;
						while true do
							if ((v97 == (86 - (84 + 2))) or ((1641 - 645) > (3099 + 1202))) then
								v10.GuardiansTable.ImpCount = v10.GuardiansTable.ImpCount + (843 - (497 + 345));
								v72 = v71.duration;
								break;
							end
						end
					elseif (((105 + 3965) > (117 + 570)) and (v71.name == "Felguard")) then
						v10.GuardiansTable.FelguardDuration = v71.duration;
						v72 = v71.duration;
					elseif ((v71.name == "Dreadstalker") or ((1989 - (605 + 728)) >= (2376 + 954))) then
						local v111 = 0 - 0;
						while true do
							if (((0 + 0) == v111) or ((9213 - 6721) <= (303 + 32))) then
								v10.GuardiansTable.DreadstalkerDuration = v71.duration;
								v72 = v71.duration;
								break;
							end
						end
					elseif (((11974 - 7652) >= (1935 + 627)) and (v71.name == "Demonic Tyrant")) then
						if ((v52 == (265676 - (457 + 32))) or ((1544 + 2093) >= (5172 - (832 + 570)))) then
							local v120 = 0 + 0;
							while true do
								if ((v120 == (0 + 0)) or ((8418 - 6039) > (2206 + 2372))) then
									v10.GuardiansTable.DemonicTyrantDuration = v71.duration;
									v72 = v71.duration;
									break;
								end
							end
						end
					elseif ((v71.name == "Vilefiend") or ((1279 - (588 + 208)) > (2002 - 1259))) then
						local v121 = 1800 - (884 + 916);
						while true do
							if (((5137 - 2683) > (336 + 242)) and (v121 == (653 - (232 + 421)))) then
								v10.GuardiansTable.VilefiendDuration = v71.duration;
								v72 = v71.duration;
								break;
							end
						end
					elseif (((2819 - (1569 + 320)) < (1094 + 3364)) and (v71.name == "Pit Lord")) then
						local v125 = 0 + 0;
						while true do
							if (((2230 - 1568) <= (1577 - (316 + 289))) and (v125 == (0 - 0))) then
								v10.GuardiansTable.PitLordDuration = v71.duration;
								v72 = v71.duration;
								break;
							end
						end
					elseif (((202 + 4168) == (5823 - (666 + 787))) and (v71.name == "Infernal")) then
						v10.GuardiansTable.InfernalDuration = v71.duration;
						v72 = v71.duration;
					elseif ((v71.name == "Blasphemy") or ((5187 - (360 + 65)) <= (805 + 56))) then
						local v140 = 254 - (79 + 175);
						while true do
							if ((v140 == (0 - 0)) or ((1102 + 310) == (13070 - 8806))) then
								v10.GuardiansTable.BlasphemyDuration = v71.duration;
								v72 = v71.duration;
								break;
							end
						end
					elseif ((v71.name == "Darkglare") or ((6100 - 2932) < (3052 - (503 + 396)))) then
						local v144 = 181 - (92 + 89);
						while true do
							if ((v144 == (0 - 0)) or ((2552 + 2424) < (789 + 543))) then
								v10.GuardiansTable.DarkglareDuration = v71.duration;
								v72 = v71.duration;
								break;
							end
						end
					end
					v73 = {ID=v51,name=v71.name,spawnTime=GetTime(),ImpCasts=(19 - 14),Duration=v72,despawnTime=(GetTime() + tonumber(v72))};
					v70 = 1 + 1;
				end
				if (((10552 - 5924) == (4038 + 590)) and (v70 == (1 + 1))) then
					table.insert(v10.GuardiansTable.Pets, v73);
					break;
				end
				if ((v70 == (0 - 0)) or ((7 + 47) == (602 - 207))) then
					v71 = v39[v53];
					v72 = nil;
					v70 = 1245 - (485 + 759);
				end
			end
		end
		if (((189 - 107) == (1271 - (442 + 747))) and v39[v53] and (v39[v53].name == "Demonic Tyrant")) then
			for v80, v81 in pairs(v10.GuardiansTable.Pets) do
				if ((v81 and (v81.name ~= "Demonic Tyrant") and (v81.name ~= "Pit Lord")) or ((1716 - (832 + 303)) < (1228 - (88 + 858)))) then
					v81.despawnTime = v81.despawnTime + 5 + 10;
					v81.ImpCasts = v81.ImpCasts + 6 + 1;
				end
			end
		end
		if ((v53 == (5916 + 137706)) or ((5398 - (766 + 23)) < (12317 - 9822))) then
			v10.GuardiansTable.InnerDemonsNextCast = GetTime() + (15 - 3);
		end
		if (((3034 - 1882) == (3909 - 2757)) and (v53 == (56732 - (1036 + 37))) and (v10.GuardiansTable.ImpsSpawnedFromHoG > (0 + 0))) then
			v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG - (1 - 0);
		end
		v23.UpdatePetTable();
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v10:RegisterForCombatEvent(function(...)
		local v54 = 0 + 0;
		local v55;
		local v56;
		local v57;
		local v58;
		while true do
			if (((3376 - (641 + 839)) <= (4335 - (910 + 3))) and (v54 == (2 - 1))) then
				if (((v55 == v13:GUID()) and (v58 == (197961 - (1466 + 218)))) or ((455 + 535) > (2768 - (556 + 592)))) then
					for v91, v92 in pairs(v10.GuardiansTable.Pets) do
						if ((v92.name == "Wild Imp") or ((312 + 565) > (5503 - (329 + 479)))) then
							v10.GuardiansTable.Pets[v91] = nil;
						end
					end
					v10.GuardiansTable.ImpCount = 854 - (174 + 680);
				end
				v23.UpdatePetTable();
				break;
			end
			if (((9246 - 6555) >= (3836 - 1985)) and (v54 == (0 + 0))) then
				v55, v56, v56, v56, v57, v56, v56, v56, v58 = select(743 - (396 + 343), ...);
				if ((v58 == (9230 + 95088)) or ((4462 - (29 + 1448)) >= (6245 - (135 + 1254)))) then
					for v93, v94 in pairs(v10.GuardiansTable.Pets) do
						if (((16108 - 11832) >= (5579 - 4384)) and (v55 == v94.ID)) then
							v94.ImpCasts = v94.ImpCasts - (1 + 0);
						end
					end
				end
				v54 = 1528 - (389 + 1138);
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v23.LastPI = 574 - (102 + 472);
	v10:RegisterForCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(8 + 0, ...);
		if (((1793 + 1439) <= (4374 + 316)) and (SpellID == (11605 - (320 + 1225))) and (DestGUID == v13:GUID())) then
			v23.LastPI = GetTime();
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v23.SoulShards = 0 - 0;
	v23.UpdateSoulShards = function()
		v23.SoulShards = v13:SoulShards();
	end;
	v10:RegisterForSelfCombatEvent(function(v60, v61, v60, v60, v60, v60, v60, v60, v60, v60, v60, v62)
		if ((v62 == (64353 + 40821)) or ((2360 - (157 + 1307)) >= (5005 - (821 + 1038)))) then
			v10.GuardiansTable.ImpsSpawnedFromHoG = v10.GuardiansTable.ImpsSpawnedFromHoG + (((v23.SoulShards >= (7 - 4)) and (1 + 2)) or v23.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Warlock_Warlock.lua"]();

