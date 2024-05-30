local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1849 + 2735) == (3977 + 607)) and not v5) then
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
	if (((4553 - (507 + 67)) >= (3417 - (1013 + 736))) and not v15.Warlock) then
		v15.Warlock = {};
	end
	v15.Warlock.Commons = {Berserking=v15(21773 + 4524, nil, 2 - 1),AncestralCall=v15(1007409 - 732671),BloodFury=v15(34569 - (550 + 317), nil, 2 - 0),Fireblood=v15(372787 - 107566, nil, 8 - 5),Corruption=v15(457 - (134 + 151), nil, 1669 - (970 + 695)),DarkPact=v15(206883 - 98467, nil, 1995 - (582 + 1408)),ShadowBolt=v15(2378 - 1692, nil, 7 - 1),SummonDarkglare=v15(773191 - 568011, nil, 1831 - (1195 + 629)),UnendingResolve=v15(138561 - 33788, nil, 249 - (187 + 54)),GrimoireofSacrifice=v15(109283 - (162 + 618), nil, 7 + 2),GrimoireofSacrificeBuff=v15(130610 + 65489, nil, 21 - 11),SoulConduit=v15(363037 - 147096, nil, 1 + 10),SummonSoulkeeper=v15(387892 - (1373 + 263), nil, 1012 - (451 + 549)),InquisitorsGaze=v15(121954 + 264390, nil, 19 - 6),InquisitorsGazeBuff=v15(652210 - 264142, nil, 1398 - (746 + 638)),Soulburn=v15(145229 + 240670, nil, 22 - 7),PowerInfusionBuff=v15(10401 - (218 + 123), nil, 1597 - (1535 + 46)),AxeToss=v15(119147 + 767, nil, 3 + 14),Seduction=v15(120469 - (306 + 254), nil, 2 + 16),ShadowBulwark=v15(235322 - 115415, nil, 1486 - (899 + 568)),SingeMagic=v15(78814 + 41091, nil, 48 - 28),SpellLock=v15(120513 - (268 + 335), nil, 311 - (60 + 230)),BurningRush=v15(111972 - (426 + 146), nil, 67 + 488)};
	v15.Warlock.Demonology = v18(v15.Warlock.Commons, {Felstorm=v15(91207 - (282 + 1174), nil, 833 - (569 + 242)),HandofGuldan=v15(302963 - 197789, nil, 2 + 21),ShadowBoltLineCD=v15(1710 - (706 + 318), nil, 1257 - (721 + 530)),SummonPet=v15(31417 - (945 + 326), nil, 59 - 35),BilescourgeBombers=v15(237770 + 29441, nil, 725 - (271 + 429)),CallDreadstalkers=v15(95825 + 8491, nil, 1526 - (1408 + 92)),Demonbolt=v15(265264 - (461 + 625), nil, 1315 - (993 + 295)),DemonicCalling=v15(10653 + 194492, nil, 1199 - (418 + 753)),DemonicStrength=v15(101753 + 165418, nil, 3 + 26),Doom=v15(177 + 426, nil, 8 + 22),FelDomination=v15(334418 - (406 + 123), nil, 1800 - (1749 + 20)),FelCovenant=v15(92026 + 295406, nil, 1354 - (1249 + 73)),FromtheShadows=v15(95318 + 171852, nil, 1178 - (466 + 679)),GrimoireFelguard=v15(269167 - 157269, nil, 97 - 63),Guillotine=v15(388733 - (106 + 1794), nil, 12 + 23),ImpGangBoss=v15(97938 + 289507, nil, 105 - 69),Implosion=v15(531506 - 335229, nil, 151 - (4 + 110)),InnerDemons=v15(267800 - (57 + 527), nil, 1465 - (41 + 1386)),NetherPortal=v15(267320 - (17 + 86), nil, 27 + 12),PowerSiphon=v15(589040 - 324910, nil, 115 - 75),SacrificedSouls=v15(267380 - (122 + 44), nil, 70 - 29),SoulboundTyrant=v15(1109976 - 775391, nil, 35 + 7),SoulStrike=v15(38189 + 225868, nil, 86 - 43),SummonDemonicTyrant=v15(265252 - (30 + 35), nil, 31 + 13),SummonVilefiend=v15(265376 - (1043 + 214), nil, 169 - 124),TheExpendables=v15(388812 - (323 + 889), nil, 123 - 77),ReignofTyranny=v15(428264 - (361 + 219), nil, 452 - (53 + 267)),GrandWarlocksDesign=v15(87451 + 299633, nil, 546 - (15 + 398)),DemonicCallingBuff=v15(206128 - (18 + 964), nil, 176 - 129),DemonicCoreBuff=v15(152947 + 111226, nil, 31 + 17),DemonicPowerBuff=v15(266123 - (20 + 830), nil, 39 + 10),FelCovenantBuff=v15(387563 - (116 + 10), nil, 4 + 46),NetherPortalBuff=v15(267956 - (542 + 196), nil, 109 - 58),DoomDebuff=v15(177 + 426, nil, 27 + 25),FromtheShadowsDebuff=v15(97396 + 173173, nil, 139 - 86),DoomBrandDebuff=v15(1085977 - 662394),DrainLife=v15(235704 - (1126 + 425), nil, 460 - (118 + 287))});
	v15.Warlock.Affliction = v18(v15.Warlock.Commons, {Agony=v15(3840 - 2860, nil, 1175 - (118 + 1003)),DrainLife=v15(685232 - 451079, nil, 432 - (142 + 235)),SummonPet=v15(3121 - 2433, nil, 13 + 43),AbsoluteCorruption=v15(197080 - (553 + 424), nil, 107 - 50),DoomBlossom=v15(343350 + 46414),DrainSoul=v15(196998 + 1592, nil, 34 + 24),DreadTouch=v15(165690 + 224085, nil, 34 + 25),Haunt=v15(104451 - 56270, nil, 167 - 107),InevitableDemise=v15(748554 - 414235, nil, 18 + 43),MaleficAffliction=v15(1883582 - 1493821, nil, 815 - (239 + 514)),MaleficRapture=v15(113981 + 210555, nil, 1392 - (797 + 532)),Nightfall=v15(78880 + 29678, nil, 22 + 42),PhantomSingularity=v15(482427 - 277248, nil, 1267 - (373 + 829)),SowTheSeeds=v15(196957 - (476 + 255), nil, 1196 - (369 + 761)),SeedofCorruption=v15(15760 + 11483, nil, 121 - 54),ShadowEmbrace=v15(51625 - 24382, nil, 306 - (64 + 174)),SiphonLife=v15(8988 + 54118, nil, 101 - 32),SoulRot=v15(387333 - (144 + 192), nil, 286 - (42 + 174)),SoulSwap=v15(290691 + 96260, nil, 59 + 12),SoulTap=v15(164445 + 222628, nil, 1576 - (363 + 1141)),SouleatersGluttony=v15(391210 - (1183 + 397), nil, 222 - 149),SowtheSeeds=v15(143843 + 52383, nil, 56 + 18),TormentedCrescendo=v15(389050 - (1913 + 62), nil, 48 + 27),UnstableAffliction=v15(836809 - 520710, nil, 2009 - (565 + 1368)),VileTaint=v15(1046800 - 768450, nil, 1738 - (1477 + 184)),InevitableDemiseBuff=v15(455538 - 121218, nil, 73 + 5),NightfallBuff=v15(265427 - (564 + 292), nil, 135 - 56),MaleficAfflictionBuff=v15(1175058 - 785213, nil, 384 - (244 + 60)),TormentedCrescendoBuff=v15(297630 + 89449, nil, 557 - (41 + 435)),UmbrafireKindlingBuff=v15(424766 - (938 + 63)),AgonyDebuff=v15(754 + 226, nil, 1207 - (936 + 189)),CorruptionDebuff=v15(48292 + 98447, nil, 1696 - (1565 + 48)),HauntDebuff=v15(29763 + 18418, nil, 1222 - (782 + 356)),PhantomSingularityDebuff=v15(205446 - (176 + 91), nil, 221 - 136),SeedofCorruptionDebuff=v15(40150 - 12907, nil, 1178 - (975 + 117)),SiphonLifeDebuff=v15(64981 - (157 + 1718), nil, 71 + 16),UnstableAfflictionDebuff=v15(1122127 - 806028, nil, 300 - 212),VileTaintDebuff=v15(279368 - (697 + 321), nil, 242 - 153),SoulRotDebuff=v15(819896 - 432899, nil, 207 - 117),DreadTouchDebuff=v15(151754 + 238114, nil, 170 - 79),ShadowEmbraceDebuff=v15(86828 - 54438, nil, 1319 - (322 + 905))});
	v15.Warlock.Destruction = v18(v15.Warlock.Commons, {Immolate=v15(959 - (602 + 9), nil, 1282 - (449 + 740)),Incinerate=v15(30594 - (826 + 46), nil, 1041 - (245 + 702)),SummonPet=v15(2173 - 1485, nil, 31 + 64),AshenRemains=v15(389150 - (260 + 1638), nil, 536 - (382 + 58)),AvatarofDestruction=v15(1242033 - 854874, nil, 81 + 16),Backdraft=v15(405911 - 209505, nil, 291 - 193),BurntoAshes=v15(388358 - (902 + 303), nil, 216 - 117),Cataclysm=v15(366352 - 214244, nil, 9 + 91),ChannelDemonfire=v15(198137 - (1121 + 569), nil, 315 - (22 + 192)),ChaosBolt=v15(117541 - (483 + 200), nil, 1565 - (1404 + 59)),ChaosIncarnate=v15(1059870 - 672595),Chaosbringer=v15(567256 - 145199),Conflagrate=v15(18727 - (468 + 297), nil, 665 - (334 + 228)),CrashingChaos=v15(1407324 - 990090),CryHavoc=v15(898240 - 510718, nil, 188 - 84),DiabolicEmbers=v15(109944 + 277229, nil, 341 - (141 + 95)),DimensionalRift=v15(381112 + 6864, nil, 272 - 166),Eradication=v15(472157 - 275745, nil, 26 + 81),FireandBrimstone=v15(538134 - 341726, nil, 76 + 32),Havoc=v15(41783 + 38457, nil, 152 - 43),Inferno=v15(159584 + 110961, nil, 273 - (92 + 71)),InternalCombustion=v15(131456 + 134678, nil, 186 - 75),MadnessoftheAzjAqir=v15(388165 - (574 + 191), nil, 93 + 19),Mayhem=v15(970820 - 583314, nil, 58 + 55),RagingDemonfire=v15(388015 - (254 + 595), nil, 240 - (55 + 71)),RainofChaos=v15(350539 - 84453, nil, 1905 - (573 + 1217)),RainofFire=v15(15896 - 10156, nil, 9 + 107),RoaringBlaze=v15(330632 - 125448, nil, 1056 - (714 + 225)),Ruin=v15(1131270 - 744167, nil, 164 - 46),SoulFire=v15(688 + 5665, nil, 171 - 52),SummonInfernal=v15(1928 - (118 + 688), nil, 168 - (25 + 23)),BackdraftBuff=v15(22822 + 95006, nil, 2007 - (927 + 959)),MadnessCBBuff=v15(1305915 - 918506, nil, 854 - (16 + 716)),MadnessRoFBuff=v15(747864 - 360451),MadnessSBBuff=v15(387511 - (11 + 86)),RainofChaosBuff=v15(649031 - 382944, nil, 408 - (175 + 110)),RitualofRuinBuff=v15(977492 - 590335, nil, 611 - 487),BurntoAshesBuff=v15(388950 - (503 + 1293), nil, 349 - 224),EradicationDebuff=v15(142040 + 54374, nil, 1187 - (810 + 251)),ConflagrateDebuff=v15(184551 + 81380),HavocDebuff=v15(24626 + 55614, nil, 115 + 12),ImmolateDebuff=v15(158269 - (43 + 490), nil, 861 - (711 + 22)),PyrogenicsDebuff=v15(1497367 - 1110271),RoaringBlazeDebuff=v15(266790 - (240 + 619), nil, 32 + 97)});
	if (((903 - 335) > (29 + 399)) and not v17.Warlock) then
		v17.Warlock = {};
	end
	v17.Warlock.Commons = {Healthstone=v17(1765 - (1344 + 400)),PotionOfWitheringDreams=v17(207446 - (255 + 150)),ConjuredChillglobe=v17(153046 + 41254, {(55 - 42),(1753 - (404 + 1335))}),DesperateInvokersCodex=v17(194716 - (183 + 223), {(9 + 4),(351 - (10 + 327))}),TimebreachingTalon=v17(134954 + 58837, {(5 + 8),(7 + 7)}),TimeThiefsGambit=v17(877603 - 670024, {(24 - 11),(5 + 9)}),BelorrelostheSuncaller=v17(208991 - (580 + 1239), {(13 + 0),(7 + 7)}),Iridal=v17(543919 - 335598, {(1183 - (645 + 522))}),NymuesUnravelingSpindle=v17(210405 - (1010 + 780), {(61 - 48),(1850 - (1045 + 791))})};
	v17.Warlock.Affliction = v18(v17.Warlock.Commons, {});
	v17.Warlock.Demonology = v18(v17.Warlock.Commons, {});
	v17.Warlock.Destruction = v18(v17.Warlock.Commons, {});
	if (((3376 - 2042) <= (7043 - 2430)) and not v21.Warlock) then
		v21.Warlock = {};
	end
	v21.Warlock.Commons = {Healthstone=v21(526 - (351 + 154)),HealingPotion=v21(1584 - (1281 + 293)),ConjuredChillglobe=v21(288 - (28 + 238)),DesperateInvokersCodex=v21(50 - 27),TimebreachingTalon=v21(1583 - (1381 + 178)),AxeTossMouseover=v21(23 + 1),CorruptionMouseover=v21(21 + 4),SpellLockMouseover=v21(12 + 14),ShadowBoltPetAttack=v21(93 - 66),IridialStaff=v21(21 + 19),CancelBurningRush=v21(511 - (381 + 89))};
	v21.Warlock.Affliction = v18(v21.Warlock.Commons, {AgonyMouseover=v21(25 + 3),VileTaintCursor=v21(20 + 9)});
	v21.Warlock.Demonology = v18(v21.Warlock.Commons, {DemonboltPetAttack=v21(51 - 21),DoomMouseover=v21(1187 - (1074 + 82)),GuillotineCursor=v21(69 - 37)});
	v21.Warlock.Destruction = v18(v21.Warlock.Commons, {HavocMouseover=v21(1817 - (214 + 1570)),ImmolateMouseover=v21(1489 - (990 + 465)),ImmolatePetAttack=v21(15 + 20),RainofFireCursor=v21(16 + 20),SummonInfernalCursor=v21(36 + 1)});
	v9.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v9.GuardiansTable = {Pets={},ImpCount=(0 - 0),FelguardDuration=(1726 - (1668 + 58)),DreadstalkerDuration=(626 - (512 + 114)),DemonicTyrantDuration=(0 - 0),VilefiendDuration=(0 - 0),PitLordDuration=(0 - 0),Infernal=(0 + 0),Blasphemy=(0 + 0),DarkglareDuration=(0 + 0),InnerDemonsNextCast=(0 - 0),ImpsSpawnedFromHoG=(1994 - (109 + 1885))};
	local v38 = {[99504 - (1269 + 200)]={name="Dreadstalker",duration=(22.25 - 10)},[56474 - (98 + 717)]={name="Wild Imp",duration=(846 - (802 + 24))},[247680 - 104058]={name="Wild Imp",duration=(25 - 5)},[2548 + 14704]={name="Felguard",duration=(14 + 3)},[22175 + 112827]={name="Demonic Tyrant",duration=(4 + 11)},[377831 - 242015]={name="Vilefiend",duration=(49 - 34)},[70143 + 125968]={name="Pit Lord",duration=(5 + 5)},[74 + 15]={name="Infernal",duration=(22 + 8)},[86647 + 98937]={name="Blasphemy",duration=(1441 - (797 + 636))},[503369 - 399696]={name="Darkglare",duration=(1644 - (1427 + 192))}};
	v9:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(3 + 5, ...);
		if ((SpellID == (366227 - 208491)) or ((1677 + 188) >= (920 + 1109))) then
			v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 326 - (192 + 134);
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v9:RegisterForSelfCombatEvent(function(...)
		local v43 = 1276 - (316 + 960);
		while true do
			if (((2755 + 2195) >= (1248 + 368)) and (v43 == (0 + 0))) then
				DestGUID, _, _, _, SpellID = select(30 - 22, ...);
				if (((2276 - (83 + 468)) == (3531 - (1202 + 604))) and (SpellID == (736342 - 578606))) then
					if (((2427 - 968) <= (6871 - 4389)) and v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
						v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_REMOVED");
	v9:RegisterForCombatEvent(function(...)
		DestGUID = select(333 - (45 + 280), ...);
		if (v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((2603 + 93) >= (3960 + 572))) then
			v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v9:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(3 + 5, ...);
		if (((580 + 468) >= (10 + 42)) and (SpellID == (33261 - 15299))) then
			if (((4869 - (340 + 1571)) < (1777 + 2726)) and v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID]) then
				v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v9.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + (1773 - (1733 + 39));
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v22.UpdatePetTable = function()
		for v63, v64 in pairs(v9.GuardiansTable.Pets) do
			local v65 = 0 - 0;
			while true do
				if ((v65 == (1035 - (125 + 909))) or ((4683 - (1096 + 852)) == (588 + 721))) then
					if ((GetTime() <= v64.despawnTime) or ((5898 - 1768) <= (2867 + 88))) then
						local v82 = 512 - (409 + 103);
						while true do
							if ((v82 == (236 - (46 + 190))) or ((2059 - (51 + 44)) <= (378 + 962))) then
								v64.Duration = v64.despawnTime - GetTime();
								if (((3816 - (1114 + 203)) == (3225 - (228 + 498))) and (v64.name == "Felguard")) then
									v9.GuardiansTable.FelguardDuration = v64.Duration;
								elseif ((v64.name == "Dreadstalker") or ((489 + 1766) < (13 + 9))) then
									v9.GuardiansTable.DreadstalkerDuration = v64.Duration;
								elseif ((v64.name == "Demonic Tyrant") or ((1749 - (174 + 489)) >= (3660 - 2255))) then
									v9.GuardiansTable.DemonicTyrantDuration = v64.Duration;
								elseif ((v64.name == "Vilefiend") or ((4274 - (830 + 1075)) == (950 - (303 + 221)))) then
									v9.GuardiansTable.VilefiendDuration = v64.Duration;
								elseif ((v64.name == "Pit Lord") or ((4345 - (231 + 1038)) > (2653 + 530))) then
									v9.GuardiansTable.PitLordDuration = v64.Duration;
								elseif (((2364 - (171 + 991)) > (4360 - 3302)) and (v64.name == "Infernal")) then
									v9.GuardiansTable.InfernalDuration = v64.Duration;
								elseif (((9964 - 6253) > (8372 - 5017)) and (v64.name == "Blasphy")) then
									v9.GuardiansTable.BlasphemyDuration = v64.Duration;
								elseif ((v64.name == "Darkglare") or ((726 + 180) >= (7813 - 5584))) then
									v9.GuardiansTable.DarkglareDuration = v64.Duration;
								end
								break;
							end
						end
					end
					break;
				end
				if (((3715 - 2427) > (2016 - 765)) and (v65 == (0 - 0))) then
					if (v64 or ((5761 - (111 + 1137)) < (3510 - (91 + 67)))) then
						if ((GetTime() >= v64.despawnTime) or ((6145 - 4080) >= (798 + 2398))) then
							local v90 = 523 - (423 + 100);
							while true do
								if ((v90 == (1 + 0)) or ((12116 - 7740) <= (772 + 709))) then
									v9.GuardiansTable.Pets[v63] = nil;
									break;
								end
								if ((v90 == (771 - (326 + 445))) or ((14802 - 11410) >= (10561 - 5820))) then
									if (((7760 - 4435) >= (2865 - (530 + 181))) and (v64.name == "Wild Imp")) then
										v9.GuardiansTable.ImpCount = v9.GuardiansTable.ImpCount - (882 - (614 + 267));
									end
									if ((v64.name == "Felguard") or ((1327 - (19 + 13)) >= (5261 - 2028))) then
										v9.GuardiansTable.FelguardDuration = 0 - 0;
									elseif (((12503 - 8126) > (427 + 1215)) and (v64.name == "Dreadstalker")) then
										v9.GuardiansTable.DreadstalkerDuration = 0 - 0;
									elseif (((9794 - 5071) > (3168 - (1293 + 519))) and (v64.name == "Demonic Tyrant")) then
										v9.GuardiansTable.DemonicTyrantDuration = 0 - 0;
									elseif ((v64.name == "Vilefiend") or ((10798 - 6662) <= (6564 - 3131))) then
										v9.GuardiansTable.VilefiendDuration = 0 - 0;
									elseif (((9999 - 5754) <= (2453 + 2178)) and (v64.name == "Pit Lord")) then
										v9.GuardiansTable.PitLordDuration = 0 + 0;
									elseif (((9934 - 5658) >= (905 + 3009)) and (v64.name == "Infernal")) then
										v9.GuardiansTable.InfernalDuration = 0 + 0;
									elseif (((124 + 74) <= (5461 - (709 + 387))) and (v64.name == "Blasphemy")) then
										v9.GuardiansTable.BlasphemyDuration = 1858 - (673 + 1185);
									elseif (((13868 - 9086) > (15015 - 10339)) and (v64.name == "Darkglare")) then
										v9.GuardiansTable.DarkglareDuration = 0 - 0;
									end
									v90 = 1 + 0;
								end
							end
						end
					end
					if (((3635 + 1229) > (2966 - 769)) and (v64.ImpCasts <= (0 + 0))) then
						local v83 = 0 - 0;
						while true do
							if ((v83 == (0 - 0)) or ((5580 - (446 + 1434)) == (3790 - (1040 + 243)))) then
								v9.GuardiansTable.ImpCount = v9.GuardiansTable.ImpCount - (2 - 1);
								v9.GuardiansTable.Pets[v63] = nil;
								break;
							end
						end
					end
					v65 = 1848 - (559 + 1288);
				end
			end
		end
	end;
	v9:RegisterForSelfCombatEvent(function(...)
		local v44, v45, v46, v47, v46, v46, v46, v48, v46, v46, v46, v49 = select(1932 - (609 + 1322), ...);
		local v46, v46, v46, v46, v46, v46, v46, v50 = v19(v48, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
		v50 = tonumber(v50);
		if (((4928 - (13 + 441)) >= (1023 - 749)) and (v48 ~= UnitGUID("pet")) and (v45 == "SPELL_SUMMON") and v38[v50]) then
			local v68 = 0 - 0;
			local v69;
			local v70;
			local v71;
			while true do
				if ((v68 == (0 - 0)) or ((71 + 1823) <= (5106 - 3700))) then
					v69 = v38[v50];
					v70 = nil;
					v68 = 1 + 0;
				end
				if (((689 + 883) >= (4543 - 3012)) and (v68 == (1 + 0))) then
					if ((v69.name == "Wild Imp") or ((8620 - 3933) < (3003 + 1539))) then
						local v89 = 0 + 0;
						while true do
							if (((2365 + 926) > (1400 + 267)) and (v89 == (0 + 0))) then
								v9.GuardiansTable.ImpCount = v9.GuardiansTable.ImpCount + (434 - (153 + 280));
								v70 = v69.duration;
								break;
							end
						end
					elseif ((v69.name == "Felguard") or ((2520 - 1647) == (1827 + 207))) then
						local v98 = 0 + 0;
						while true do
							if (((0 + 0) == v98) or ((2556 + 260) < (8 + 3))) then
								v9.GuardiansTable.FelguardDuration = v69.duration;
								v70 = v69.duration;
								break;
							end
						end
					elseif (((5631 - 1932) < (2909 + 1797)) and (v69.name == "Dreadstalker")) then
						v9.GuardiansTable.DreadstalkerDuration = v69.duration;
						v70 = v69.duration;
					elseif (((3313 - (89 + 578)) >= (626 + 250)) and (v69.name == "Demonic Tyrant")) then
						if (((1276 - 662) <= (4233 - (572 + 477))) and (v49 == (35766 + 229421))) then
							local v115 = 0 + 0;
							while true do
								if (((374 + 2752) == (3212 - (84 + 2))) and (v115 == (0 - 0))) then
									v9.GuardiansTable.DemonicTyrantDuration = v69.duration;
									v70 = v69.duration;
									break;
								end
							end
						end
					elseif ((v69.name == "Vilefiend") or ((1576 + 611) >= (5796 - (497 + 345)))) then
						v9.GuardiansTable.VilefiendDuration = v69.duration;
						v70 = v69.duration;
					elseif ((v69.name == "Pit Lord") or ((100 + 3777) == (605 + 2970))) then
						v9.GuardiansTable.PitLordDuration = v69.duration;
						v70 = v69.duration;
					elseif (((2040 - (605 + 728)) > (451 + 181)) and (v69.name == "Infernal")) then
						local v128 = 0 - 0;
						while true do
							if (((0 + 0) == v128) or ((2018 - 1472) >= (2420 + 264))) then
								v9.GuardiansTable.InfernalDuration = v69.duration;
								v70 = v69.duration;
								break;
							end
						end
					elseif (((4058 - 2593) <= (3248 + 1053)) and (v69.name == "Blasphemy")) then
						v9.GuardiansTable.BlasphemyDuration = v69.duration;
						v70 = v69.duration;
					elseif (((2193 - (457 + 32)) > (605 + 820)) and (v69.name == "Darkglare")) then
						v9.GuardiansTable.DarkglareDuration = v69.duration;
						v70 = v69.duration;
					end
					v71 = {ID=v48,name=v69.name,spawnTime=GetTime(),ImpCasts=(1407 - (832 + 570)),Duration=v70,despawnTime=(GetTime() + tonumber(v70))};
					v68 = 2 + 0;
				end
				if ((v68 == (1 + 1)) or ((2430 - 1743) == (2040 + 2194))) then
					table.insert(v9.GuardiansTable.Pets, v71);
					break;
				end
			end
		end
		if ((v38[v50] and (v38[v50].name == "Demonic Tyrant")) or ((4126 - (588 + 208)) < (3851 - 2422))) then
			for v76, v77 in pairs(v9.GuardiansTable.Pets) do
				if (((2947 - (884 + 916)) >= (701 - 366)) and v77 and (v77.name ~= "Demonic Tyrant") and (v77.name ~= "Pit Lord")) then
					local v80 = 0 + 0;
					while true do
						if (((4088 - (232 + 421)) > (3986 - (1569 + 320))) and ((0 + 0) == v80)) then
							v77.despawnTime = v77.despawnTime + 3 + 12;
							v77.ImpCasts = v77.ImpCasts + (23 - 16);
							break;
						end
					end
				end
			end
		end
		if ((v50 == (144227 - (316 + 289))) or ((9868 - 6098) >= (187 + 3854))) then
			v9.GuardiansTable.InnerDemonsNextCast = GetTime() + (1465 - (666 + 787));
		end
		if (((v50 == (56084 - (360 + 65))) and (v9.GuardiansTable.ImpsSpawnedFromHoG > (0 + 0))) or ((4045 - (79 + 175)) <= (2540 - 929))) then
			v9.GuardiansTable.ImpsSpawnedFromHoG = v9.GuardiansTable.ImpsSpawnedFromHoG - (1 + 0);
		end
		v22.UpdatePetTable();
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v9:RegisterForCombatEvent(function(...)
		local v51 = 0 - 0;
		local v52;
		local v53;
		local v54;
		local v55;
		while true do
			if ((v51 == (0 - 0)) or ((5477 - (503 + 396)) <= (2189 - (92 + 89)))) then
				v52, v53, v53, v53, v54, v53, v53, v53, v55 = select(7 - 3, ...);
				if (((577 + 548) <= (1229 + 847)) and (v55 == (408524 - 304206))) then
					for v84, v85 in pairs(v9.GuardiansTable.Pets) do
						if ((v52 == v85.ID) or ((102 + 641) >= (10029 - 5630))) then
							v85.ImpCasts = v85.ImpCasts - (1 + 0);
						end
					end
				end
				v51 = 1 + 0;
			end
			if (((3517 - 2362) < (209 + 1464)) and (v51 == (1 - 0))) then
				if (((v52 == v12:GUID()) and (v55 == (197521 - (485 + 759)))) or ((5377 - 3053) <= (1767 - (442 + 747)))) then
					for v86, v87 in pairs(v9.GuardiansTable.Pets) do
						if (((4902 - (832 + 303)) == (4713 - (88 + 858))) and (v87.name == "Wild Imp")) then
							v9.GuardiansTable.Pets[v86] = nil;
						end
					end
					v9.GuardiansTable.ImpCount = 0 + 0;
				end
				v22.UpdatePetTable();
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v22.LastPI = 0 + 0;
	v9:RegisterForCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(1 + 7, ...);
		if (((4878 - (766 + 23)) == (20186 - 16097)) and (SpellID == (13758 - 3698)) and (DestGUID == v12:GUID())) then
			v22.LastPI = GetTime();
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v22.SoulShards = 0 - 0;
	v22.UpdateSoulShards = function()
		v22.SoulShards = v12:SoulShards();
	end;
	v9:RegisterForSelfCombatEvent(function(v57, v58, v57, v57, v57, v57, v57, v57, v57, v57, v57, v59)
		if (((15130 - 10672) >= (2747 - (1036 + 37))) and (v59 == (74566 + 30608))) then
			v9.GuardiansTable.ImpsSpawnedFromHoG = v9.GuardiansTable.ImpsSpawnedFromHoG + (((v22.SoulShards >= (5 - 2)) and (3 + 0)) or v22.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Warlock_Warlock.lua"]();

