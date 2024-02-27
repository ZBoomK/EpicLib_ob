local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1384 - (746 + 638);
	local v6;
	while true do
		if (((1440 + 2384) >= (620 - 211)) and (v5 == (342 - (218 + 123)))) then
			return v6(...);
		end
		if (((3668 - (1535 + 46)) == (2074 + 13)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((3964 - (306 + 254)) > (279 + 4224))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_Mage_Mage.lua"] = function(...)
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
	local v20 = EpicLib;
	local v21 = v20.Macro;
	local v22 = GetTime;
	local v23 = math.min;
	if (not v16.Mage or ((4973 - (899 + 568)) <= (861 + 448))) then
		v16.Mage = {};
	end
	v16.Mage.Commons = {AncestralCall=v16(664839 - 390101, nil, 604 - (268 + 335)),BagofTricks=v16(312701 - (60 + 230), nil, 574 - (426 + 146)),Berserking=v16(3151 + 23146, nil, 1459 - (282 + 1174)),BloodFury=v16(21383 - (569 + 242), nil, 11 - 7),Fireblood=v16(15167 + 250054, nil, 1029 - (706 + 318)),LightsJudgment=v16(256898 - (721 + 530), nil, 1277 - (945 + 326)),ArcaneExplosion=v16(3619 - 2170, nil, 7 + 0),ArcaneIntellect=v16(2159 - (271 + 429), nil, 8 + 0),Blink=v17(1509 - (1408 + 92), 3039 - (461 + 625), 213941 - (993 + 295)),Frostbolt=v16(7 + 109, nil, 1181 - (418 + 753)),FrostNova=v16(47 + 75, nil, 2 + 9),Polymorph=v16(35 + 83, nil, 4 + 8),SlowFall=v16(659 - (406 + 123), nil, 1782 - (1749 + 20)),TimeWarp=v16(19086 + 61267, nil, 1336 - (1249 + 73)),AlterTime=v16(122102 + 220143, nil, 1160 - (466 + 679)),BlastWave=v16(380018 - 222037, nil, 45 - 29),Counterspell=v16(4039 - (106 + 1794), nil, 6 + 11),DragonsBreath=v16(8004 + 23657, nil, 52 - 34),FocusMagic=v16(870218 - 548860, nil, 133 - (4 + 110)),GreaterInvisibility=v16(111543 - (57 + 527), nil, 1483 - (41 + 1386)),IceBlock=v16(45541 - (17 + 86), nil, 14 + 6),IceColdAbility=v16(924734 - 510076, nil, 463 - 303),IceColdTalent=v16(414825 - (122 + 44), nil, 277 - 116),IceFloes=v16(361069 - 252230, nil, 18 + 3),IceNova=v16(22850 + 135147, nil, 43 - 21),Invisibility=v16(131 - (30 + 35), nil, 16 + 7),MassBarrier=v16(415917 - (1043 + 214), nil, 90 - 66),Meteor=v16(154773 - (323 + 889), nil, 66 - 41),MirrorImage=v16(55922 - (361 + 219), nil, 346 - (53 + 267)),RemoveCurse=v16(108 + 367, nil, 440 - (15 + 398)),RingOfFrost=v16(114706 - (18 + 964), nil, 105 - 77),RuneofPower=v16(67166 + 48845, nil, 19 + 10),ShiftingPower=v16(383290 - (20 + 830), nil, 24 + 6),Spellsteal=v16(30575 - (116 + 10), nil, 3 + 28),TemporalWarp=v16(387277 - (542 + 196), nil, 68 - 36),ArcaneIntellectBuff=v16(427 + 1032, nil, 17 + 16),BerserkingBuff=v16(9467 + 16830, nil, 89 - 55),BloodFuryBuff=v16(52742 - 32170, nil, 1586 - (1126 + 425)),RuneofPowerBuff=v16(116419 - (118 + 287), nil, 141 - 105),TemporalWarpBuff=v16(387661 - (118 + 1003), nil, 108 - 71),Pool=v16(1000287 - (142 + 235), nil, 907 - 707)};
	v16.Mage.Arcane = v19(v16.Mage.Commons, {ArcaneBlast=v16(6626 + 23825, nil, 1015 - (553 + 424)),FireBlast=v16(604795 - 284959, nil, 35 + 4),Amplification=v16(234731 + 1897, nil, 24 + 16),ArcaneBarrage=v16(18885 + 25540, nil, 24 + 17),ArcaneBombardment=v16(833730 - 449149, nil, 116 - 74),ArcaneEcho=v16(766269 - 424038, nil, 13 + 30),ArcaneFamiliar=v16(990801 - 785779, nil, 797 - (239 + 514)),ArcaneHarmony=v16(135024 + 249428, nil, 1374 - (797 + 532)),ArcaneMissiles=v16(3737 + 1406, nil, 16 + 30),ArcaneOrb=v16(361213 - 207587, nil, 1249 - (373 + 829)),ArcanePower=v16(322470 - (476 + 255), nil, 1178 - (369 + 761)),ArcaneSurge=v16(211345 + 154005, nil, 88 - 39),CascadingPower=v16(728204 - 343928, nil, 288 - (64 + 174)),ChargedOrb=v16(54784 + 329867, nil, 75 - 24),ConjureManaGem=v16(1095 - (144 + 192), nil, 268 - (42 + 174)),Concentration=v16(288755 + 95619, nil, 44 + 9),Enlightened=v16(136539 + 184848, nil, 1558 - (363 + 1141)),Evocation=v16(13631 - (1183 + 397), nil, 167 - 112),NetherTempest=v16(84244 + 30679, nil, 43 + 14),NetherPrecision=v16(385757 - (1913 + 62), nil, 37 + 21),OrbBarrage=v16(1018835 - 633977, nil, 1992 - (565 + 1368)),Overpowered=v16(583466 - 428319, nil, 1721 - (1477 + 184)),PresenceofMind=v16(279363 - 74338, nil, 57 + 4),PrismaticBarrier=v16(236306 - (564 + 292), nil, 106 - 44),RadiantSpark=v16(1133637 - 757534, nil, 367 - (244 + 60)),Resonance=v16(157649 + 47379, nil, 540 - (41 + 435)),RuleofThrees=v16(265355 - (938 + 63), nil, 50 + 15),SiphonStorm=v16(385312 - (936 + 189), nil, 22 + 44),Slipstream=v16(238070 - (1565 + 48), nil, 42 + 25),Supernova=v16(159118 - (782 + 356), nil, 335 - (176 + 91)),TimeAnomaly=v16(998474 - 615231, nil, 101 - 32),TouchoftheMagi=v16(322599 - (975 + 117), nil, 1945 - (157 + 1718)),ArcaneArtilleryBuff=v16(344368 + 79963, nil, 539 - 387),ArcaneFamiliarBuff=v16(718381 - 508255, nil, 1089 - (697 + 321)),ArcaneHarmonyBuff=v16(1047304 - 662849, nil, 152 - 80),ArcaneOverloadBuff=v16(942951 - 533929, nil, 29 + 44),ArcaneSurgeBuff=v16(684562 - 319200, nil, 198 - 124),ClearcastingBuff=v16(264952 - (322 + 905), nil, 686 - (602 + 9)),ConcentrationBuff=v16(385568 - (449 + 740), nil, 948 - (826 + 46)),NetherPrecisionBuff=v16(384730 - (245 + 702), nil, 243 - 166),PresenceofMindBuff=v16(65910 + 139115, nil, 1976 - (260 + 1638)),RuleofThreesBuff=v16(265214 - (382 + 58), nil, 253 - 174),SiphonStormBuff=v16(319309 + 64958, nil, 165 - 85),NetherTempestDebuff=v16(341620 - 226697, nil, 1286 - (902 + 303)),RadiantSparkDebuff=v16(825786 - 449683, nil, 197 - 115),RadiantSparkVulnerability=v16(32320 + 343784, nil, 1773 - (1121 + 569)),TouchoftheMagiDebuff=v16(211038 - (22 + 192), nil, 767 - (483 + 200))});
	v16.Mage.Fire = v19(v16.Mage.Commons, {Fireball=v16(1596 - (1404 + 59), nil, 232 - 147),Flamestrike=v16(2849 - 729, nil, 851 - (468 + 297)),AlexstraszasFury=v16(236432 - (334 + 228), nil, 293 - 206),BlazingBarrier=v16(545434 - 310121, nil, 159 - 71),Combustion=v16(54044 + 136275, nil, 325 - (141 + 95)),FeeltheBurn=v16(376609 + 6782, nil, 231 - 141),FireBlast=v17(218 - 127, 25498 + 83355, 634465 - 402898, 224842 + 94994),Firestarter=v16(106763 + 98263, nil, 128 - 36),FlameOn=v16(120938 + 84091, nil, 256 - (92 + 71)),FlamePatch=v16(101277 + 103760, nil, 157 - 63),FromTheAshes=v16(343109 - (574 + 191), nil, 79 + 16),FueltheFire=v16(1042442 - 626348, nil, 79 + 75),Hyperthermia=v16(384709 - (254 + 595), nil, 222 - (55 + 71)),ImprovedScorch=v16(505357 - 121753, nil, 1887 - (573 + 1217)),Kindling=v16(429670 - 274522, nil, 8 + 90),LivingBomb=v16(71637 - 27180, nil, 1038 - (714 + 225)),PhoenixFlames=v16(752638 - 495097, nil, 139 - 39),Pyroblast=v16(1231 + 10135, nil, 145 - 44),Scorch=v16(3754 - (118 + 688), nil, 150 - (25 + 23)),SearingTouch=v16(52227 + 217417, nil, 1989 - (927 + 959)),SunKingsBlessing=v16(1294040 - 910154, nil, 836 - (16 + 716)),TemperedFlames=v16(740617 - 356958, nil, 202 - (11 + 86)),CombustionBuff=v16(464220 - 273901, nil, 391 - (175 + 110)),FeeltheBurnBuff=v16(967993 - 584598, nil, 527 - 420),FlameAccelerantBuff=v16(205073 - (503 + 1293), nil, 301 - 193),FlamesFuryBuff=v16(296471 + 113493, nil, 1170 - (810 + 251)),HeatingUpBuff=v16(33386 + 14721, nil, 34 + 76),HotStreakBuff=v16(43368 + 4740, nil, 644 - (43 + 490)),HyperthermiaBuff=v16(384607 - (711 + 22), nil, 432 - 320),SunKingsBlessingBuff=v16(384741 - (240 + 619), nil, 28 + 85),FuryoftheSunKingBuff=v16(610644 - 226761, nil, 8 + 106),CharringEmbersDebuff=v16(410409 - (1344 + 400), nil, 520 - (255 + 150)),IgniteDebuff=v16(9968 + 2686, nil, 63 + 53),ImprovedScorchDebuff=v16(1638995 - 1255387, nil, 377 - 260)});
	v16.Mage.Frost = v19(v16.Mage.Commons, {ConeofCold=v16(1859 - (404 + 1335), nil, 524 - (183 + 223)),IciclesBuff=v16(250032 - 44559, nil, 79 + 40),WintersChillDebuff=v16(82181 + 146177, nil, 457 - (10 + 327)),FireBlast=v16(222731 + 97105, nil, 459 - (118 + 220)),Blizzard=v16(63437 + 126919, nil, 571 - (108 + 341)),BoneChilling=v16(92417 + 113349, nil, 519 - 396),ChainReaction=v16(279802 - (711 + 782), nil, 237 - 113),ColdestSnap=v16(417962 - (270 + 199), nil, 41 + 84),CometStorm=v16(155414 - (580 + 1239), nil, 374 - 248),Ebonbolt=v16(246245 + 11292, nil, 5 + 122),Flurry=v16(19435 + 25179, nil, 333 - 205),FreezingRain=v16(167884 + 102349, nil, 1296 - (645 + 522)),FreezingWinds=v16(383893 - (1010 + 780), nil, 130 + 0),Frostbite=v16(943830 - 745709, nil, 383 - 252),FrozenOrb=v17(1968 - (1045 + 791), 214434 - 129720, 302562 - 104413),GlacialSpike=v16(200291 - (351 + 154), nil, 1707 - (1281 + 293)),IceBarrier=v16(11692 - (28 + 238), nil, 299 - 165),IceCaller=v16(238221 - (1381 + 178), nil, 127 + 8),IceLance=v16(24558 + 5897, nil, 59 + 77),IcyVeins=v16(42996 - 30524, nil, 71 + 66),RayofFrost=v16(205491 - (381 + 89), nil, 123 + 15),SlickIce=v16(258440 + 123704, nil, 237 - 98),Snowstorm=v16(382862 - (1074 + 82), nil, 306 - 166),SplinteringCold=v16(380833 - (214 + 1570), nil, 1596 - (990 + 465)),SplittingIce=v16(23241 + 33136, nil, 62 + 79),SummonWaterElemental=v16(30814 + 873, nil, 558 - 416),Freeze=v16(35121 - (1668 + 58), nil, 769 - (512 + 114)),WaterJet=v16(352040 - 217011, nil, 297 - 153),BrainFreezeBuff=v16(662686 - 472240, nil, 68 + 77),FingersofFrostBuff=v16(8339 + 36205, nil, 127 + 19),FreezingRainBuff=v16(911483 - 641251, nil, 2141 - (109 + 1885)),FreezingWindsBuff=v16(383575 - (1269 + 200), nil, 283 - 135),GlacialSpikeBuff=v16(200659 - (98 + 717), nil, 975 - (802 + 24)),IcyVeinsBuff=v16(21507 - 9035, nil, 189 - 39),SnowstormBuff=v16(56344 + 325178, nil, 117 + 34),FrostbiteDebuff=v16(62213 + 316547, nil, 34 + 119)});
	if (((8220 - 5265) == (9854 - 6899)) and not v18.Mage) then
		v18.Mage = {};
	end
	v18.Mage.Commons = {Dreambinder=v18(74616 + 134000),Iridal=v18(84800 + 123521),Healthstone=v18(4547 + 965),RefreshingHealingPotion=v18(139159 + 52221),DreamwalkersHealingPotion=v18(96657 + 110366)};
	v18.Mage.Arcane = v19(v18.Mage.Commons, {ManaGem=v18(38232 - (797 + 636))});
	v18.Mage.Fire = v19(v18.Mage.Commons, {});
	v18.Mage.Frost = v19(v18.Mage.Commons, {});
	if (not v21.Mage or ((14095 - 11192) == (3114 - (1427 + 192)))) then
		v21.Mage = {};
	end
	v21.Mage.Commons = {Healthstone=v21(4 + 5),RefreshingHealingPotion=v21(23 - 13),UseWeapon=v21(91 + 10),CounterspellMouseover=v21(5 + 6),PolymorphMouseover=v21(338 - (192 + 134)),RemoveCurseMouseover=v21(1289 - (316 + 960)),RemoveCurseFocus=v21(8 + 6),StopCasting=v21(12 + 3)};
	v21.Mage.Arcane = v19(v21.Mage.Commons, {ManaGem=v21(15 + 1),CancelPOM=v21(64 - 47)});
	v21.Mage.Fire = v19(v21.Mage.Commons, {FlamestrikeCursor=v21(569 - (83 + 468)),MeteorCursor=v21(1825 - (1202 + 604)),FireBlastMacro=v21(107 - 84)});
	v21.Mage.Frost = v19(v21.Mage.Commons, {BlizzardCursor=v21(33 - 13),IceLanceMouseover=v21(58 - 37),FreezePet=v21(347 - (45 + 280)),FrozenOrbCast=v21(24 + 0)});
	local v36 = v16.Mage.Frost.RuneofPower:BaseDuration();
	local v37;
	v37 = v10.AddCoreOverride("Player.AffectingCombat", function(v49)
		return v16.Mage.Arcane.ArcaneBlast:InFlight() or v37(v49);
	end, 55 + 7);
	v10.AddCoreOverride("Spell.IsCastable", function(v50, v51, v52, v53, v54, v55)
		local v56 = 0 + 0;
		local v57;
		local v58;
		while true do
			if (((2516 + 2030) >= (401 + 1874)) and (v56 == (3 - 1))) then
				if (((2730 - (340 + 1571)) >= (9 + 13)) and (v50 == v16.Mage.Arcane.PresenceofMind)) then
					return v58 and v13:BuffDown(v16.Mage.Arcane.PresenceofMind);
				elseif (((4934 - (1733 + 39)) == (8688 - 5526)) and (v50 == v16.Mage.Arcane.RadiantSpark)) then
					return v58 and not v13:IsCasting(v50);
				elseif ((v50 == v16.Mage.Arcane.ShiftingPower) or ((3403 - (125 + 909)) > (6377 - (1096 + 852)))) then
					return v58 and not v13:IsCasting(v50);
				elseif (((1837 + 2258) >= (4544 - 1361)) and (v50 == v16.Mage.Arcane.TouchoftheMagi)) then
					return v58 and not v13:IsCasting(v50);
				elseif ((v50 == v16.Mage.Arcane.ConjureManaGem) or ((3600 + 111) < (1520 - (409 + 103)))) then
					local v142 = 236 - (46 + 190);
					local v143;
					local v144;
					while true do
						if ((v142 == (96 - (51 + 44))) or ((296 + 753) <= (2223 - (1114 + 203)))) then
							return v58 and not v13:IsCasting(v50) and not (v143:IsReady() or (v144 > (726 - (228 + 498))));
						end
						if (((978 + 3535) > (1507 + 1219)) and (v142 == (663 - (174 + 489)))) then
							v143 = v18.Mage.Arcane.ManaGem;
							v144 = v143:CooldownRemains();
							v142 = 2 - 1;
						end
					end
				elseif ((v50 == v16.Mage.Arcane.ArcaneSurge) or ((3386 - (830 + 1075)) >= (3182 - (303 + 221)))) then
					return v50:IsLearned() and v50:CooldownUp() and v57;
				else
					return v58;
				end
				break;
			end
			if ((v56 == (1270 - (231 + 1038))) or ((2684 + 536) == (2526 - (171 + 991)))) then
				if (v52 or ((4343 - 3289) > (9108 - 5716))) then
					local v137 = v54 or v14;
					v57 = v137:IsInRange(v52, v53);
				end
				v58 = v50:IsLearned() and (v50:CooldownRemains(v51, v55 or "Auto") == (0 - 0)) and v57 and (v13:Mana() >= v50:Cost());
				v56 = 2 + 0;
			end
			if ((v56 == (0 - 0)) or ((1949 - 1273) >= (2646 - 1004))) then
				if (((12785 - 8649) > (3645 - (111 + 1137))) and (v50:CastTime() > (158 - (91 + 67))) and v13:IsMoving()) then
					return false;
				end
				v57 = true;
				v56 = 2 - 1;
			end
		end
	end, 16 + 46);
	local v38;
	v38 = v10.AddCoreOverride("Player.BuffStack", function(v59, v60, v61, v62)
		local v63 = 523 - (423 + 100);
		local v64;
		while true do
			if ((v63 == (0 + 0)) or ((12000 - 7666) == (2213 + 2032))) then
				v64 = v38(v59, v60, v61, v62);
				if (((v60 == v60.Mage.Fire.PyroclasmBuff) and v59:IsCasting(v60.Mage.Fire.Pyroblast)) or ((5047 - (326 + 445)) <= (13227 - 10196))) then
					return 0 - 0;
				else
					return v64;
				end
				break;
			end
		end
	end, 146 - 83);
	local v39;
	v39 = v10.AddCoreOverride("Player.BuffRemains", function(v65, v66, v67, v68)
		local v69 = 711 - (530 + 181);
		local v70;
		while true do
			if ((v69 == (881 - (614 + 267))) or ((4814 - (19 + 13)) <= (1950 - 751))) then
				v70 = v39(v65, v66, v67, v68);
				if (((v66 == v66.Mage.Fire.PyroclasmBuff) and v65:IsCasting(v66.Mage.Fire.Pyroblast)) or ((11334 - 6470) < (5433 - 3531))) then
					return 0 + 0;
				end
				v69 = 1 - 0;
			end
			if (((10034 - 5195) >= (5512 - (1293 + 519))) and (v69 == (1 - 0))) then
				return v70;
			end
		end
	end, 164 - 101);
	v10.AddCoreOverride("Spell.IsReady", function(v71, v72, v73, v74, v75, v76)
		local v77 = v71:IsCastable() and v71:IsUsableP();
		local v78 = true;
		if (((v71:CastTime() > (0 - 0)) and v13:IsMoving()) or ((4635 - 3560) > (4518 - 2600))) then
			if (((210 + 186) <= (777 + 3027)) and ((v71 == v16.Mage.Fire.Scorch) or ((v71 == v16.Mage.Fire.Pyroblast) and v13:BuffUp(v16.Mage.Fire.HotStreakBuff)) or ((v71 == v16.Mage.Fire.Flamestrike) and v13:BuffUp(v16.Mage.Fire.HotStreakBuff)))) then
				v78 = true;
			else
				return false;
			end
		else
			return v77;
		end
	end, 145 - 82);
	v10.AddCoreOverride("Spell.IsCastable", function(v79, v80, v81, v82, v83, v84)
		local v85 = 0 + 0;
		local v86;
		local v87;
		while true do
			if ((v85 == (1 + 0)) or ((2606 + 1563) == (3283 - (709 + 387)))) then
				if (((3264 - (673 + 1185)) == (4077 - 2671)) and v81) then
					local v138 = 0 - 0;
					local v139;
					while true do
						if (((2518 - 987) < (3055 + 1216)) and (v138 == (0 + 0))) then
							v139 = v83 or v14;
							v86 = v139:IsInRange(v81, v82);
							break;
						end
					end
				end
				v87 = v79:IsLearned() and (v79:CooldownRemains(v80, v84 or "Auto") == (0 - 0)) and v86;
				v85 = 1 + 1;
			end
			if (((1266 - 631) == (1246 - 611)) and (v85 == (1882 - (446 + 1434)))) then
				if (((4656 - (1040 + 243)) <= (10613 - 7057)) and (v79 == v16.Mage.Fire.RadiantSpark)) then
					return v87 and not v13:IsCasting(v79);
				elseif ((v79 == v16.Mage.Fire.ShiftingPower) or ((5138 - (559 + 1288)) < (5211 - (609 + 1322)))) then
					return v87 and not v13:IsCasting(v79);
				else
					return v87;
				end
				break;
			end
			if (((4840 - (13 + 441)) >= (3261 - 2388)) and (v85 == (0 - 0))) then
				if (((4586 - 3665) <= (42 + 1060)) and (v79:CastTime() > (0 - 0)) and v13:IsMoving()) then
					return false;
				end
				v86 = true;
				v85 = 1 + 0;
			end
		end
	end, 28 + 35);
	local v40;
	v40 = v10.AddCoreOverride("Player.AffectingCombat", function(v88)
		return v40(v88) or v13:IsCasting(v16.Mage.Fire.Pyroblast) or v13:IsCasting(v16.Mage.Fire.Fireball);
	end, 186 - 123);
	v10.AddCoreOverride("Spell.InFlightRemains", function(v89)
		return v89:TravelTime() - v89:TimeSinceLastCast();
	end, 35 + 28);
	local v41;
	v41 = v10.AddCoreOverride("Spell.IsCastable", function(v90, v91, v92, v93, v94, v95)
		local v96 = 0 - 0;
		local v97;
		local v98;
		while true do
			if (((3112 + 1594) >= (536 + 427)) and (v96 == (2 + 0))) then
				if ((v90 == v16.Mage.Frost.GlacialSpike) or ((807 + 153) <= (858 + 18))) then
					return v90:IsLearned() and v98 and v97 and not v13:IsCasting(v90) and (v13:BuffUp(v16.Mage.Frost.GlacialSpikeBuff) or (v13:BuffStack(v16.Mage.Frost.IciclesBuff) == (438 - (153 + 280))));
				else
					local v140 = v41(v90, v91, v92, v93, v94, v95);
					if ((v90 == v16.Mage.Frost.SummonWaterElemental) or ((5965 - 3899) == (837 + 95))) then
						return v140 and not v15:IsActive();
					elseif (((1906 + 2919) < (2535 + 2308)) and (v90 == v16.Mage.Frost.RuneofPower)) then
						return v140 and not v13:IsCasting(v90) and v13:BuffDown(v16.Mage.Frost.RuneofPowerBuff);
					elseif ((v90 == v16.Mage.Frost.MirrorsofTorment) or ((3519 + 358) >= (3288 + 1249))) then
						return v140 and not v13:IsCasting(v90);
					elseif ((v90 == v16.Mage.Frost.RadiantSpark) or ((6570 - 2255) < (1067 + 659))) then
						return v140 and not v13:IsCasting(v90);
					elseif ((v90 == v16.Mage.Frost.ShiftingPower) or ((4346 - (89 + 578)) < (447 + 178))) then
						return v140 and not v13:IsCasting(v90);
					elseif ((v90 == v16.Mage.Frost.Deathborne) or ((9614 - 4989) < (1681 - (572 + 477)))) then
						return v140 and not v13:IsCasting(v90);
					else
						return v140;
					end
				end
				break;
			end
			if ((v96 == (1 + 0)) or ((50 + 33) > (213 + 1567))) then
				v98 = true;
				if (((632 - (84 + 2)) <= (1774 - 697)) and v92) then
					local v141 = v94 or v14;
					v98 = v141:IsInRange(v92, v93);
				end
				v96 = 2 + 0;
			end
			if ((v96 == (842 - (497 + 345))) or ((26 + 970) > (728 + 3573))) then
				v97 = true;
				if (((5403 - (605 + 728)) > (491 + 196)) and (v90:CastTime() > (0 - 0)) and v13:IsMoving()) then
					if (((v90 == v16.Mage.Frost.Blizzard) and v13:BuffUp(v16.Mage.Frost.FreezingRain)) or ((31 + 625) >= (12311 - 8981))) then
						v97 = true;
					else
						return false;
					end
				end
				v96 = 1 + 0;
			end
		end
	end, 177 - 113);
	local v42;
	v42 = v10.AddCoreOverride("Spell.CooldownRemains", function(v99, v100, v101)
		if (((v99 == v16.Mage.Frost.Blizzard) and v13:IsCasting(v99)) or ((1882 + 610) <= (824 - (457 + 32)))) then
			return 4 + 4;
		elseif (((5724 - (832 + 570)) >= (2414 + 148)) and (v99 == v16.Mage.Frost.Ebonbolt) and v13:IsCasting(v99)) then
			return 12 + 33;
		else
			return v42(v99, v100, v101);
		end
	end, 226 - 162);
	local v43;
	v43 = v10.AddCoreOverride("Player.BuffStackP", function(v102, v103, v104, v105)
		local v106 = 0 + 0;
		local v107;
		while true do
			if ((v106 == (796 - (588 + 208))) or ((9802 - 6165) >= (5570 - (884 + 916)))) then
				v107 = v13:BuffStack(v103);
				if ((v103 == v103.Mage.Frost.IciclesBuff) or ((4980 - 2601) > (2655 + 1923))) then
					return (v102:IsCasting(v103.Mage.Frost.GlacialSpike) and (653 - (232 + 421))) or math.min(v107 + ((v102:IsCasting(v103.Mage.Frost.Frostbolt) and (1890 - (1569 + 320))) or (0 + 0)), 1 + 4);
				elseif ((v103 == v103.Mage.Frost.GlacialSpikeBuff) or ((1627 - 1144) > (1348 - (316 + 289)))) then
					return (v102:IsCasting(v103.Mage.Frost.GlacialSpike) and (0 - 0)) or v107;
				elseif (((114 + 2340) > (2031 - (666 + 787))) and (v103 == v103.Mage.Frost.WintersReachBuff)) then
					return (v102:IsCasting(v103.Mage.Frost.Flurry) and (425 - (360 + 65))) or v107;
				elseif (((870 + 60) < (4712 - (79 + 175))) and (v103 == v103.Mage.Frost.FingersofFrostBuff)) then
					if (((1043 - 381) <= (759 + 213)) and v103.Mage.Frost.IceLance:InFlight()) then
						if (((13395 - 9025) == (8416 - 4046)) and (v107 == (899 - (503 + 396)))) then
							return 181 - (92 + 89);
						else
							return v107 - (1 - 0);
						end
					else
						return v107;
					end
				else
					return v107;
				end
				break;
			end
		end
	end, 33 + 31);
	local v44;
	v44 = v10.AddCoreOverride("Player.BuffUpP", function(v108, v109, v110, v111)
		local v112 = 0 + 0;
		local v113;
		while true do
			if (((0 - 0) == v112) or ((652 + 4110) <= (1963 - 1102))) then
				v113 = v13:BuffUp(v109);
				if ((v109 == v109.Mage.Frost.FingersofFrostBuff) or ((1232 + 180) == (2037 + 2227))) then
					if (v109.Mage.Frost.IceLance:InFlight() or ((9648 - 6480) < (269 + 1884))) then
						return v13:BuffStack(v109) >= (1 - 0);
					else
						return v113;
					end
				else
					return v113;
				end
				break;
			end
		end
	end, 1308 - (485 + 759));
	local v45;
	v45 = v10.AddCoreOverride("Player.BuffDownP", function(v114, v115, v116, v117)
		local v118 = 0 - 0;
		local v119;
		while true do
			if ((v118 == (1189 - (442 + 747))) or ((6111 - (832 + 303)) < (2278 - (88 + 858)))) then
				v119 = v13:BuffDown(v115);
				if (((1411 + 3217) == (3831 + 797)) and (v115 == v115.Mage.Frost.FingersofFrostBuff)) then
					if (v115.Mage.Frost.IceLance:InFlight() or ((3 + 51) == (1184 - (766 + 23)))) then
						return v13:BuffStack(v115) == (0 - 0);
					else
						return v119;
					end
				else
					return v119;
				end
				break;
			end
		end
	end, 87 - 23);
	local v46;
	v46 = v10.AddCoreOverride("Target.DebuffStack", function(v120, v121, v122, v123)
		local v124 = 0 - 0;
		local v125;
		while true do
			if (((278 - 196) == (1155 - (1036 + 37))) and (v124 == (0 + 0))) then
				v125 = v46(v120, v121, v122, v123);
				if ((v121 == v121.Mage.Frost.WintersChillDebuff) or ((1131 - 550) < (222 + 60))) then
					if (v121.Mage.Frost.Flurry:InFlight() or ((6089 - (641 + 839)) < (3408 - (910 + 3)))) then
						return 4 - 2;
					elseif (((2836 - (1466 + 218)) == (530 + 622)) and v121.Mage.Frost.IceLance:InFlight()) then
						if (((3044 - (556 + 592)) <= (1217 + 2205)) and (v125 == (808 - (329 + 479)))) then
							return 854 - (174 + 680);
						else
							return v125 - (3 - 2);
						end
					else
						return v125;
					end
				else
					return v125;
				end
				break;
			end
		end
	end, 132 - 68);
	local v47;
	v47 = v10.AddCoreOverride("Target.DebuffRemains", function(v126, v127, v128, v129)
		local v130 = 0 + 0;
		local v131;
		while true do
			if ((v130 == (739 - (396 + 343))) or ((88 + 902) > (3097 - (29 + 1448)))) then
				v131 = v47(v126, v127, v128, v129);
				if ((v127 == v127.Mage.Frost.WintersChillDebuff) or ((2266 - (135 + 1254)) > (17687 - 12992))) then
					return (v127.Mage.Frost.Flurry:InFlight() and (27 - 21)) or v131;
				else
					return v131;
				end
				break;
			end
		end
	end, 43 + 21);
	local v48;
	v48 = v10.AddCoreOverride("Player.AffectingCombat", function(v132)
		return v16.Mage.Frost.Frostbolt:InFlight() or v48(v132);
	end, 1591 - (389 + 1138));
end;
return v0["Epix_Mage_Mage.lua"]();

