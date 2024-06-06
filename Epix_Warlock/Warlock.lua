local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 0 - 0;
	local v7;
	while true do
		if (((625 - (268 + 335)) <= (2545 - (60 + 230))) and (v6 == (572 - (426 + 146)))) then
			v7 = v1[v5];
			if (not v7 or ((131 + 955) >= (2861 - (282 + 1174)))) then
				return v2(v5, v0, ...);
			end
			v6 = 812 - (569 + 242);
		end
		if ((v6 == (2 - 1)) or ((136 + 2233) == (1450 - (706 + 318)))) then
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
	if (not v17.Warlock or ((4327 - (721 + 530)) > (4454 - (945 + 326)))) then
		v17.Warlock = {};
	end
	v17.Warlock.Commons = {Berserking=v17(65697 - 39400, nil, 1 + 0),AncestralCall=v17(275438 - (271 + 429)),BloodFury=v17(30959 + 2743, nil, 1502 - (1408 + 92)),Fireblood=v17(266307 - (461 + 625), nil, 1291 - (993 + 295)),Corruption=v17(9 + 163, nil, 1175 - (418 + 753)),DarkPact=v17(41291 + 67125, nil, 1 + 4),ShadowBolt=v17(201 + 485, nil, 2 + 4),SummonDarkglare=v17(205709 - (406 + 123), nil, 1776 - (1749 + 20)),UnendingResolve=v17(24887 + 79886, nil, 1330 - (1249 + 73)),GrimoireofSacrifice=v17(38711 + 69792, nil, 1154 - (466 + 679)),GrimoireofSacrificeBuff=v17(471709 - 275610, nil, 28 - 18),SoulConduit=v17(217841 - (106 + 1794), nil, 4 + 7),SummonSoulkeeper=v17(97638 + 288618, nil, 35 - 23),InquisitorsGaze=v17(1046196 - 659852, nil, 127 - (4 + 110)),InquisitorsGazeBuff=v17(388652 - (57 + 527), nil, 1441 - (41 + 1386)),Soulburn=v17(386002 - (17 + 86), nil, 11 + 4),PowerInfusionBuff=v17(22434 - 12374, nil, 46 - 30),AxeToss=v17(120080 - (122 + 44), nil, 28 - 11),Seduction=v17(397794 - 277885, nil, 15 + 3),ShadowBulwark=v17(17342 + 102565, nil, 37 - 18),SingeMagic=v17(119970 - (30 + 35), nil, 14 + 6),SpellLock=v17(121167 - (1043 + 214), nil, 79 - 58),BurningRush=v17(112612 - (323 + 889), nil, 1493 - 938)};
	v17.Warlock.Demonology = v20(v17.Warlock.Commons, {Felstorm=v17(90331 - (361 + 219), nil, 342 - (53 + 267)),HandofGuldan=v17(23761 + 81413, nil, 436 - (15 + 398)),ShadowBoltLineCD=v17(1668 - (18 + 964), nil, 22 - 16),SummonPet=v17(17454 + 12692, nil, 16 + 8),BilescourgeBombers=v17(268061 - (20 + 830), nil, 20 + 5),CallDreadstalkers=v17(104442 - (116 + 10), nil, 2 + 24),Demonbolt=v17(264916 - (542 + 196), nil, 57 - 30),DemonicCalling=v17(59906 + 145239, nil, 15 + 13),DemonicStrength=v17(96173 + 170998, nil, 75 - 46),Doom=v17(1545 - 942, nil, 1581 - (1126 + 425)),FelDomination=v17(334294 - (118 + 287), nil, 121 - 90),FelCovenant=v17(388553 - (118 + 1003), nil, 93 - 61),FromtheShadows=v17(267547 - (142 + 235), nil, 149 - 116),GrimoireFelguard=v17(24348 + 87550, nil, 1011 - (553 + 424)),Guillotine=v17(731484 - 344651, nil, 31 + 4),ImpGangBoss=v17(384338 + 3107, nil, 21 + 15),Implosion=v17(83436 + 112841, nil, 22 + 15),InnerDemons=v17(579296 - 312080, nil, 105 - 67),NetherPortal=v17(598309 - 331092, nil, 12 + 27),PowerSiphon=v17(1276450 - 1012320, nil, 793 - (239 + 514)),SacrificedSouls=v17(93849 + 173365, nil, 1370 - (797 + 532)),SoulboundTyrant=v17(243115 + 91470, nil, 15 + 27),SoulStrike=v17(620865 - 356808, nil, 1245 - (373 + 829)),SummonDemonicTyrant=v17(265918 - (476 + 255), nil, 1174 - (369 + 761)),SummonVilefiend=v17(152786 + 111333, nil, 81 - 36),TheExpendables=v17(734503 - 346903, nil, 284 - (64 + 174)),ReignofTyranny=v17(60913 + 366771, nil, 195 - 63),GrandWarlocksDesign=v17(387420 - (144 + 192), nil, 349 - (42 + 174)),DemonicCallingBuff=v17(154113 + 51033, nil, 39 + 8),DemonicCoreBuff=v17(112232 + 151941, nil, 1552 - (363 + 1141)),DemonicPowerBuff=v17(266853 - (1183 + 397), nil, 148 - 99),FelCovenantBuff=v17(284010 + 103427, nil, 38 + 12),NetherPortalBuff=v17(269193 - (1913 + 62), nil, 33 + 18),DoomDebuff=v17(1596 - 993, nil, 1985 - (565 + 1368)),FromtheShadowsDebuff=v17(1017538 - 746969, nil, 1714 - (1477 + 184)),DoomBrandDebuff=v17(577166 - 153583),DrainLife=v17(218173 + 15980, nil, 911 - (564 + 292))});
	v17.Warlock.Affliction = v20(v17.Warlock.Commons, {Agony=v17(1690 - 710, nil, 162 - 108),DrainLife=v17(234457 - (244 + 60), nil, 43 + 12),SummonPet=v17(1164 - (41 + 435), nil, 1057 - (938 + 63)),AbsoluteCorruption=v17(150819 + 45284, nil, 1182 - (936 + 189)),DoomBlossom=v17(128272 + 261492),DrainSoul=v17(200203 - (1565 + 48), nil, 36 + 22),DreadTouch=v17(390913 - (782 + 356), nil, 326 - (176 + 91)),Haunt=v17(125527 - 77346, nil, 88 - 28),InevitableDemise=v17(335411 - (975 + 117), nil, 1936 - (157 + 1718)),MaleficAffliction=v17(316313 + 73448, nil, 219 - 157),MaleficRapture=v17(1109527 - 784991, nil, 1081 - (697 + 321)),Nightfall=v17(295725 - 187167, nil, 135 - 71),PhantomSingularity=v17(473015 - 267836, nil, 26 + 39),SowTheSeeds=v17(367660 - 171434, nil, 176 - 110),SeedofCorruption=v17(28470 - (322 + 905), nil, 678 - (602 + 9)),ShadowEmbrace=v17(28432 - (449 + 740), nil, 940 - (826 + 46)),SiphonLife=v17(64053 - (245 + 702), nil, 217 - 148),SoulRot=v17(124408 + 262589, nil, 1968 - (260 + 1638)),SoulSwap=v17(387391 - (382 + 58), nil, 227 - 156),SoulTap=v17(321641 + 65432, nil, 148 - 76),SouleatersGluttony=v17(1158216 - 768586, nil, 1278 - (902 + 303)),SowtheSeeds=v17(430841 - 234615, nil, 178 - 104),TormentedCrescendo=v17(33262 + 353813, nil, 1765 - (1121 + 569)),UnstableAffliction=v17(316313 - (22 + 192), nil, 759 - (483 + 200)),VileTaint=v17(279813 - (1404 + 59), nil, 210 - 133),InevitableDemiseBuff=v17(449335 - 115015, nil, 843 - (468 + 297)),NightfallBuff=v17(265133 - (334 + 228), nil, 266 - 187),MaleficAfflictionBuff=v17(903625 - 513780, nil, 145 - 65),TormentedCrescendoBuff=v17(109917 + 277162, nil, 317 - (141 + 95)),UmbrafireKindlingBuff=v17(416268 + 7497),AgonyDebuff=v17(2522 - 1542, nil, 196 - 114),CorruptionDebuff=v17(34372 + 112367, nil, 227 - 144),HauntDebuff=v17(33871 + 14310, nil, 44 + 40),PhantomSingularityDebuff=v17(288941 - 83762, nil, 51 + 34),SeedofCorruptionDebuff=v17(27406 - (92 + 71), nil, 43 + 43),SiphonLifeDebuff=v17(106099 - 42993, nil, 852 - (574 + 191)),UnstableAfflictionDebuff=v17(260739 + 55360, nil, 220 - 132),VileTaintDebuff=v17(142178 + 136172, nil, 938 - (254 + 595)),SoulRotDebuff=v17(387123 - (55 + 71), nil, 118 - 28),DreadTouchDebuff=v17(391658 - (573 + 1217), nil, 251 - 160),ShadowEmbraceDebuff=v17(2465 + 29925, nil, 147 - 55)});
	v17.Warlock.Destruction = v20(v17.Warlock.Commons, {Immolate=v17(1287 - (714 + 225), nil, 271 - 178),Incinerate=v17(41436 - 11714, nil, 11 + 83),SummonPet=v17(995 - 307, nil, 901 - (118 + 688)),AshenRemains=v17(387300 - (25 + 23), nil, 19 + 77),AvatarofDestruction=v17(389045 - (927 + 959), nil, 326 - 229),Backdraft=v17(197138 - (16 + 716), nil, 189 - 91),BurntoAshes=v17(387250 - (11 + 86), nil, 241 - 142),Cataclysm=v17(152393 - (175 + 110), nil, 252 - 152),ChannelDemonfire=v17(968925 - 772478, nil, 1897 - (503 + 1293)),ChaosBolt=v17(326361 - 209503, nil, 74 + 28),ChaosIncarnate=v17(388336 - (810 + 251)),Chaosbringer=v17(292899 + 129158),Conflagrate=v17(5513 + 12449, nil, 93 + 10),CrashingChaos=v17(417767 - (43 + 490)),CryHavoc=v17(388255 - (711 + 22), nil, 402 - 298),DiabolicEmbers=v17(388032 - (240 + 619), nil, 26 + 79),DimensionalRift=v17(617154 - 229178, nil, 8 + 98),Eradication=v17(198156 - (1344 + 400), nil, 512 - (255 + 150)),FireandBrimstone=v17(154706 + 41702, nil, 58 + 50),Havoc=v17(342831 - 262591, nil, 351 - 242),Inferno=v17(272284 - (404 + 1335), nil, 516 - (183 + 223)),InternalCombustion=v17(323848 - 57714, nil, 74 + 37),MadnessoftheAzjAqir=v17(139416 + 247984, nil, 449 - (10 + 327)),Mayhem=v17(269855 + 117651, nil, 451 - (118 + 220)),RagingDemonfire=v17(129025 + 258141, nil, 563 - (108 + 341)),RainofChaos=v17(119509 + 146577, nil, 486 - 371),RainofFire=v17(7233 - (711 + 782), nil, 222 - 106),RoaringBlaze=v17(205653 - (270 + 199), nil, 38 + 79),Ruin=v17(388922 - (580 + 1239), nil, 350 - 232),SoulFire=v17(6075 + 278, nil, 5 + 114),SummonInfernal=v17(489 + 633, nil, 313 - 193),BackdraftBuff=v17(73202 + 44626, nil, 1288 - (645 + 522)),MadnessCBBuff=v17(389199 - (1010 + 780), nil, 122 + 0),MadnessRoFBuff=v17(1845600 - 1458187),MadnessSBBuff=v17(1135300 - 747886),RainofChaosBuff=v17(267923 - (1045 + 791), nil, 310 - 187),RitualofRuinBuff=v17(591168 - 204011, nil, 629 - (351 + 154)),BurntoAshesBuff=v17(388728 - (1281 + 293), nil, 391 - (28 + 238)),EradicationDebuff=v17(438881 - 242467, nil, 1685 - (1381 + 178)),ConflagrateDebuff=v17(249427 + 16504),HavocDebuff=v17(64701 + 15539, nil, 55 + 72),ImmolateDebuff=v17(543782 - 386046, nil, 67 + 61),PyrogenicsDebuff=v17(387566 - (381 + 89)),RoaringBlazeDebuff=v17(235825 + 30106, nil, 88 + 41)});
	if (((2058 - 856) > (2214 - (1074 + 82))) and not v19.Warlock) then
		v19.Warlock = {};
	end
	v19.Warlock.Commons = {Healthstone=v19(45 - 24),PotionOfWitheringDreams=v19(208825 - (214 + 1570)),ConjuredChillglobe=v19(195755 - (990 + 465), {(6 + 7),(55 - 41)}),DesperateInvokersCodex=v19(196036 - (1668 + 58), {(33 - 20),(48 - 34)}),TimebreachingTalon=v19(90154 + 103637, {(12 + 1),(2008 - (109 + 1885))}),TimeThiefsGambit=v19(209048 - (1269 + 200), {(828 - (98 + 717)),(23 - 9)}),BelorrelostheSuncaller=v19(261648 - 54476, {(10 + 3),(4 + 10)}),Iridal=v19(579536 - 371215, {(6 + 10)}),NymuesUnravelingSpindle=v19(84920 + 123695, {(10 + 3),(1447 - (797 + 636))}),MirrorofFracturedTomorrows=v19(1007880 - 800299, {(5 + 8),(13 + 1)})};
	v19.Warlock.Affliction = v20(v19.Warlock.Commons, {});
	v19.Warlock.Demonology = v20(v19.Warlock.Commons, {});
	v19.Warlock.Destruction = v20(v19.Warlock.Commons, {});
	if (((1682 + 2029) > (3681 - (192 + 134))) and not v23.Warlock) then
		v23.Warlock = {};
	end
	v23.Warlock.Commons = {Healthstone=v23(1297 - (316 + 960)),HealingPotion=v23(6 + 4),ConjuredChillglobe=v23(17 + 5),DesperateInvokersCodex=v23(22 + 1),TimebreachingTalon=v23(91 - 67),AxeTossMouseover=v23(575 - (83 + 468)),CorruptionMouseover=v23(1831 - (1202 + 604)),SpellLockMouseover=v23(121 - 95),ShadowBoltPetAttack=v23(44 - 17),IridialStaff=v23(110 - 70),CancelBurningRush=v23(366 - (45 + 280))};
	v23.Warlock.Affliction = v20(v23.Warlock.Commons, {AgonyMouseover=v23(28 + 0),VileTaintCursor=v23(26 + 3)});
	v23.Warlock.Demonology = v20(v23.Warlock.Commons, {DemonboltPetAttack=v23(11 + 19),DoomMouseover=v23(18 + 13),GuillotineCursor=v23(6 + 26)});
	v23.Warlock.Destruction = v20(v23.Warlock.Commons, {HavocMouseover=v23(60 - 27),ImmolateMouseover=v23(1945 - (340 + 1571)),ImmolatePetAttack=v23(14 + 21),RainofFireCursor=v23(1808 - (1733 + 39)),SummonInfernalCursor=v23(101 - 64)});
	v11.ImmolationTable = {Destruction={ImmolationDebuff={}}};
	v11.GuardiansTable = {Pets={},ImpCount=(1034 - (125 + 909)),FelguardDuration=(1948 - (1096 + 852)),DreadstalkerDuration=(0 + 0),DemonicTyrantDuration=(0 - 0),VilefiendDuration=(0 + 0),PitLordDuration=(512 - (409 + 103)),Infernal=(236 - (46 + 190)),Blasphemy=(95 - (51 + 44)),DarkglareDuration=(0 + 0),InnerDemonsNextCast=(1317 - (1114 + 203)),ImpsSpawnedFromHoG=(726 - (228 + 498))};
	local v40 = {[21240 + 76795]={name="Dreadstalker",duration=(7.25 + 5)},[56322 - (174 + 489)]={name="Wild Imp",duration=(52 - 32)},[145527 - (830 + 1075)]={name="Wild Imp",duration=(544 - (303 + 221))},[18521 - (231 + 1038)]={name="Felguard",duration=(15 + 2)},[136164 - (171 + 991)]={name="Demonic Tyrant",duration=(61 - 46)},[364693 - 228877]={name="Vilefiend",duration=(37 - 22)},[156957 + 39154]={name="Pit Lord",duration=(35 - 25)},[256 - 167]={name="Infernal",duration=(48 - 18)},[573692 - 388108]={name="Blasphemy",duration=(1256 - (111 + 1137))},[103831 - (91 + 67)]={name="Darkglare",duration=(74 - 49)}};
	v11:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(2 + 6, ...);
		if ((SpellID == (158259 - (423 + 100))) or ((7 + 899) >= (6171 - 3942))) then
			v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = 0 + 0;
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v11:RegisterForSelfCombatEvent(function(...)
		local v45 = 771 - (326 + 445);
		while true do
			if (((5620 - 4332) > (2786 - 1535)) and (v45 == (0 - 0))) then
				DestGUID, _, _, _, SpellID = select(719 - (530 + 181), ...);
				if ((SpellID == (158617 - (614 + 267))) or ((4545 - (19 + 13)) < (5455 - 2103))) then
					if (v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((4811 - 2746) >= (9129 - 5933))) then
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
			if ((v46 == (0 - 0)) or ((9074 - 4698) <= (3293 - (1293 + 519)))) then
				DestGUID = select(16 - 8, ...);
				if (v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((8856 - 5464) >= (9066 - 4325))) then
					v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = nil;
				end
				break;
			end
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	v11:RegisterForSelfCombatEvent(function(...)
		DestGUID, _, _, _, SpellID = select(34 - 26, ...);
		if (((7832 - 4507) >= (1141 + 1013)) and (SpellID == (3665 + 14297))) then
			if (v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] or ((3008 - 1713) >= (748 + 2485))) then
				v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] = v11.ImmolationTable.Destruction.ImmolationDebuff[DestGUID] + 1 + 0;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v24.UpdatePetTable = function()
		for v68, v69 in pairs(v11.GuardiansTable.Pets) do
			local v70 = 0 + 0;
			while true do
				if (((5473 - (709 + 387)) > (3500 - (673 + 1185))) and (v70 == (2 - 1))) then
					if (((15166 - 10443) > (2230 - 874)) and (GetTime() <= v69.despawnTime)) then
						v69.Duration = v69.despawnTime - GetTime();
						if ((v69.name == "Felguard") or ((2959 + 1177) <= (2566 + 867))) then
							v11.GuardiansTable.FelguardDuration = v69.Duration;
						elseif (((5730 - 1485) <= (1138 + 3493)) and (v69.name == "Dreadstalker")) then
							v11.GuardiansTable.DreadstalkerDuration = v69.Duration;
						elseif (((8525 - 4249) >= (7683 - 3769)) and (v69.name == "Demonic Tyrant")) then
							v11.GuardiansTable.DemonicTyrantDuration = v69.Duration;
						elseif (((2078 - (446 + 1434)) <= (5648 - (1040 + 243))) and (v69.name == "Vilefiend")) then
							v11.GuardiansTable.VilefiendDuration = v69.Duration;
						elseif (((14272 - 9490) > (6523 - (559 + 1288))) and (v69.name == "Pit Lord")) then
							v11.GuardiansTable.PitLordDuration = v69.Duration;
						elseif (((6795 - (609 + 1322)) > (2651 - (13 + 441))) and (v69.name == "Infernal")) then
							v11.GuardiansTable.InfernalDuration = v69.Duration;
						elseif ((v69.name == "Blasphy") or ((13826 - 10126) == (6566 - 4059))) then
							v11.GuardiansTable.BlasphemyDuration = v69.Duration;
						elseif (((22282 - 17808) >= (11 + 263)) and (v69.name == "Darkglare")) then
							v11.GuardiansTable.DarkglareDuration = v69.Duration;
						end
					end
					break;
				end
				if ((v70 == (0 - 0)) or ((673 + 1221) <= (617 + 789))) then
					if (((4664 - 3092) >= (838 + 693)) and v69) then
						if ((GetTime() >= v69.despawnTime) or ((8620 - 3933) < (3003 + 1539))) then
							if (((1831 + 1460) > (1198 + 469)) and (v69.name == "Wild Imp")) then
								v11.GuardiansTable.ImpCount = v11.GuardiansTable.ImpCount - (1 + 0);
							end
							if ((v69.name == "Felguard") or ((855 + 18) == (2467 - (153 + 280)))) then
								v11.GuardiansTable.FelguardDuration = 0 - 0;
							elseif ((v69.name == "Dreadstalker") or ((2529 + 287) < (5 + 6))) then
								v11.GuardiansTable.DreadstalkerDuration = 0 + 0;
							elseif (((3357 + 342) < (3410 + 1296)) and (v69.name == "Demonic Tyrant")) then
								v11.GuardiansTable.DemonicTyrantDuration = 0 - 0;
							elseif (((1636 + 1010) >= (1543 - (89 + 578))) and (v69.name == "Vilefiend")) then
								v11.GuardiansTable.VilefiendDuration = 0 + 0;
							elseif (((1276 - 662) <= (4233 - (572 + 477))) and (v69.name == "Pit Lord")) then
								v11.GuardiansTable.PitLordDuration = 0 + 0;
							elseif (((1876 + 1250) == (374 + 2752)) and (v69.name == "Infernal")) then
								v11.GuardiansTable.InfernalDuration = 86 - (84 + 2);
							elseif ((v69.name == "Blasphemy") or ((3603 - 1416) >= (3569 + 1385))) then
								v11.GuardiansTable.BlasphemyDuration = 842 - (497 + 345);
							elseif ((v69.name == "Darkglare") or ((100 + 3777) == (605 + 2970))) then
								v11.GuardiansTable.DarkglareDuration = 1333 - (605 + 728);
							end
							v11.GuardiansTable.Pets[v68] = nil;
						end
					end
					if (((505 + 202) > (1404 - 772)) and (v69.ImpCasts <= (0 + 0))) then
						local v85 = 0 - 0;
						while true do
							if ((v85 == (0 + 0)) or ((1512 - 966) >= (2027 + 657))) then
								v11.GuardiansTable.ImpCount = v11.GuardiansTable.ImpCount - (490 - (457 + 32));
								v11.GuardiansTable.Pets[v68] = nil;
								break;
							end
						end
					end
					v70 = 1 + 0;
				end
			end
		end
	end;
	v11:RegisterForSelfCombatEvent(function(...)
		local v47 = 1402 - (832 + 570);
		local v48;
		local v49;
		local v50;
		local v51;
		local v52;
		local v53;
		local v54;
		while true do
			if (((1381 + 84) <= (1122 + 3179)) and (v47 == (10 - 7))) then
				if (((821 + 883) > (2221 - (588 + 208))) and (v54 == (150013 - 94354)) and (v11.GuardiansTable.ImpsSpawnedFromHoG > (1800 - (884 + 916)))) then
					v11.GuardiansTable.ImpsSpawnedFromHoG = v11.GuardiansTable.ImpsSpawnedFromHoG - (1 - 0);
				end
				v24.UpdatePetTable();
				break;
			end
			if ((v47 == (2 + 0)) or ((1340 - (232 + 421)) == (6123 - (1569 + 320)))) then
				if ((v40[v54] and (v40[v54].name == "Demonic Tyrant")) or ((817 + 2513) < (272 + 1157))) then
					for v86, v87 in pairs(v11.GuardiansTable.Pets) do
						if (((3865 - 2718) >= (940 - (316 + 289))) and v87 and (v87.name ~= "Demonic Tyrant") and (v87.name ~= "Pit Lord")) then
							local v96 = 0 - 0;
							while true do
								if (((159 + 3276) > (3550 - (666 + 787))) and (v96 == (425 - (360 + 65)))) then
									v87.despawnTime = v87.despawnTime + 15 + 0;
									v87.ImpCasts = v87.ImpCasts + (261 - (79 + 175));
									break;
								end
							end
						end
					end
				end
				if ((v54 == (226467 - 82845)) or ((2942 + 828) >= (12386 - 8345))) then
					v11.GuardiansTable.InnerDemonsNextCast = GetTime() + (22 - 10);
				end
				v47 = 902 - (503 + 396);
			end
			if ((v47 == (181 - (92 + 89))) or ((7354 - 3563) <= (827 + 784))) then
				v48, v49, v50, v51, v50, v50, v50, v52, v50, v50, v50, v53 = select(1 + 0, ...);
				v50, v50, v50, v50, v50, v50, v50, v54 = v21(v52, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)");
				v47 = 3 - 2;
			end
			if ((v47 == (1 + 0)) or ((10438 - 5860) <= (1752 + 256))) then
				v54 = tonumber(v54);
				if (((538 + 587) <= (6322 - 4246)) and (v52 ~= UnitGUID("pet")) and (v49 == "SPELL_SUMMON") and v40[v54]) then
					local v78 = 0 + 0;
					local v79;
					local v80;
					local v81;
					while true do
						if ((v78 == (0 - 0)) or ((1987 - (485 + 759)) >= (10178 - 5779))) then
							v79 = v40[v54];
							v80 = nil;
							v78 = 1190 - (442 + 747);
						end
						if (((2290 - (832 + 303)) < (2619 - (88 + 858))) and (v78 == (1 + 0))) then
							if ((v79.name == "Wild Imp") or ((1924 + 400) <= (24 + 554))) then
								local v106 = 789 - (766 + 23);
								while true do
									if (((18596 - 14829) == (5151 - 1384)) and (v106 == (0 - 0))) then
										v11.GuardiansTable.ImpCount = v11.GuardiansTable.ImpCount + (3 - 2);
										v80 = v79.duration;
										break;
									end
								end
							elseif (((5162 - (1036 + 37)) == (2900 + 1189)) and (v79.name == "Felguard")) then
								local v112 = 0 - 0;
								while true do
									if (((3507 + 951) >= (3154 - (641 + 839))) and (v112 == (913 - (910 + 3)))) then
										v11.GuardiansTable.FelguardDuration = v79.duration;
										v80 = v79.duration;
										break;
									end
								end
							elseif (((2477 - 1505) <= (3102 - (1466 + 218))) and (v79.name == "Dreadstalker")) then
								local v118 = 0 + 0;
								while true do
									if ((v118 == (1148 - (556 + 592))) or ((1756 + 3182) < (5570 - (329 + 479)))) then
										v11.GuardiansTable.DreadstalkerDuration = v79.duration;
										v80 = v79.duration;
										break;
									end
								end
							elseif ((v79.name == "Demonic Tyrant") or ((3358 - (174 + 680)) > (14651 - 10387))) then
								if (((4461 - 2308) == (1538 + 615)) and (v53 == (265926 - (396 + 343)))) then
									local v129 = 0 + 0;
									while true do
										if (((1477 - (29 + 1448)) == v129) or ((1896 - (135 + 1254)) >= (9760 - 7169))) then
											v11.GuardiansTable.DemonicTyrantDuration = v79.duration;
											v80 = v79.duration;
											break;
										end
									end
								end
							elseif (((20922 - 16441) == (2987 + 1494)) and (v79.name == "Vilefiend")) then
								local v130 = 1527 - (389 + 1138);
								while true do
									if ((v130 == (574 - (102 + 472))) or ((2197 + 131) < (385 + 308))) then
										v11.GuardiansTable.VilefiendDuration = v79.duration;
										v80 = v79.duration;
										break;
									end
								end
							elseif (((4036 + 292) == (5873 - (320 + 1225))) and (v79.name == "Pit Lord")) then
								v11.GuardiansTable.PitLordDuration = v79.duration;
								v80 = v79.duration;
							elseif (((2826 - 1238) >= (816 + 516)) and (v79.name == "Infernal")) then
								local v143 = 1464 - (157 + 1307);
								while true do
									if (((1859 - (821 + 1038)) == v143) or ((10413 - 6239) > (465 + 3783))) then
										v11.GuardiansTable.InfernalDuration = v79.duration;
										v80 = v79.duration;
										break;
									end
								end
							elseif ((v79.name == "Blasphemy") or ((8145 - 3559) <= (31 + 51))) then
								local v145 = 0 - 0;
								while true do
									if (((4889 - (834 + 192)) == (246 + 3617)) and (v145 == (0 + 0))) then
										v11.GuardiansTable.BlasphemyDuration = v79.duration;
										v80 = v79.duration;
										break;
									end
								end
							elseif ((v79.name == "Darkglare") or ((7 + 275) <= (64 - 22))) then
								local v148 = 304 - (300 + 4);
								while true do
									if (((1231 + 3378) >= (2005 - 1239)) and (v148 == (362 - (112 + 250)))) then
										v11.GuardiansTable.DarkglareDuration = v79.duration;
										v80 = v79.duration;
										break;
									end
								end
							end
							v81 = {ID=v52,name=v79.name,spawnTime=GetTime(),ImpCasts=(2 + 3),Duration=v80,despawnTime=(GetTime() + tonumber(v80))};
							v78 = 4 - 2;
						end
						if ((v78 == (2 + 0)) or ((596 + 556) == (1861 + 627))) then
							table.insert(v11.GuardiansTable.Pets, v81);
							break;
						end
					end
				end
				v47 = 1 + 1;
			end
		end
	end, "SPELL_SUMMON", "SPELL_CAST_SUCCESS");
	v11:RegisterForCombatEvent(function(...)
		local v55 = 0 + 0;
		local v56;
		local v57;
		local v58;
		local v59;
		while true do
			if (((4836 - (1001 + 413)) > (7470 - 4120)) and (v55 == (882 - (244 + 638)))) then
				v56, v57, v57, v57, v58, v57, v57, v57, v59 = select(697 - (627 + 66), ...);
				if (((2612 - 1735) > (978 - (512 + 90))) and (v59 == (106224 - (1665 + 241)))) then
					for v88, v89 in pairs(v11.GuardiansTable.Pets) do
						if ((v56 == v89.ID) or ((3835 - (373 + 344)) <= (835 + 1016))) then
							v89.ImpCasts = v89.ImpCasts - (1 + 0);
						end
					end
				end
				v55 = 2 - 1;
			end
			if ((v55 == (1 - 0)) or ((1264 - (35 + 1064)) >= (2541 + 951))) then
				if (((8448 - 4499) < (20 + 4836)) and (v56 == v14:GUID()) and (v59 == (197513 - (298 + 938)))) then
					for v90, v91 in pairs(v11.GuardiansTable.Pets) do
						if ((v91.name == "Wild Imp") or ((5535 - (233 + 1026)) < (4682 - (636 + 1030)))) then
							v11.GuardiansTable.Pets[v90] = nil;
						end
					end
					v11.GuardiansTable.ImpCount = 0 + 0;
				end
				v24.UpdatePetTable();
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v24.LastPI = 0 + 0;
	v11:RegisterForCombatEvent(function(...)
		local v60 = 0 + 0;
		while true do
			if (((317 + 4373) > (4346 - (55 + 166))) and (v60 == (0 + 0))) then
				DestGUID, _, _, _, SpellID = select(1 + 7, ...);
				if (((SpellID == (38419 - 28359)) and (DestGUID == v14:GUID())) or ((347 - (36 + 261)) >= (1566 - 670))) then
					v24.LastPI = GetTime();
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
	v24.SoulShards = 1368 - (34 + 1334);
	v24.UpdateSoulShards = function()
		v24.SoulShards = v14:SoulShards();
	end;
	v11:RegisterForSelfCombatEvent(function(v62, v63, v62, v62, v62, v62, v62, v62, v62, v62, v62, v64)
		if ((v64 == (40432 + 64742)) or ((1332 + 382) >= (4241 - (1035 + 248)))) then
			v11.GuardiansTable.ImpsSpawnedFromHoG = v11.GuardiansTable.ImpsSpawnedFromHoG + (((v24.SoulShards >= (24 - (20 + 1))) and (2 + 1)) or v24.SoulShards);
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v1["Epix_Warlock_Warlock.lua"](...);

