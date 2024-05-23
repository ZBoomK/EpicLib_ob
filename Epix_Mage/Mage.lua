local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1409 - (450 + 959);
	local v6;
	while true do
		if (((3038 - (582 + 1408)) >= (179 - 127)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((11146 - 8188) < (6327 - (1195 + 629))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (242 - (187 + 54))) or ((3515 - (162 + 618)) == (918 + 391))) then
			return v6(...);
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
	if (not v16.Mage or ((2751 + 1379) <= (6302 - 3347))) then
		v16.Mage = {};
	end
	v16.Mage.Commons = {AncestralCall=v16(461887 - 187149, nil, 1 + 0),BagofTricks=v16(314047 - (1373 + 263), nil, 1002 - (451 + 549)),Berserking=v16(8301 + 17996, nil, 4 - 1),BloodFury=v16(56641 - 22939, nil, 1388 - (746 + 638)),Fireblood=v16(99813 + 165408, nil, 7 - 2),LightsJudgment=v16(255988 - (218 + 123), nil, 1587 - (1535 + 46)),ArcaneExplosion=v16(1440 + 9, nil, 2 + 5),ArcaneIntellect=v16(2019 - (306 + 254), nil, 1 + 7),Blink=v17(17 - 8, 3420 - (899 + 568), 139777 + 72876),Frostbolt=v16(280 - 164, nil, 613 - (268 + 335)),FrostNova=v16(412 - (60 + 230), nil, 583 - (426 + 146)),Polymorph=v16(15 + 103, nil, 1468 - (282 + 1174)),SlowFall=v16(941 - (569 + 242), nil, 37 - 24),TimeWarp=v16(4596 + 75757, nil, 1038 - (706 + 318)),AlterTime=v16(343496 - (721 + 530), nil, 1286 - (945 + 326)),BlastWave=v16(394686 - 236705, nil, 15 + 1),Counterspell=v16(2839 - (271 + 429), nil, 16 + 1),DragonsBreath=v16(33161 - (1408 + 92), nil, 1104 - (461 + 625)),FocusMagic=v16(322646 - (993 + 295), nil, 1 + 18),GreaterInvisibility=v16(112130 - (418 + 753), nil, 22 + 34),IceBlock=v16(4683 + 40755, nil, 6 + 14),IceColdAbility=v16(104795 + 309863, nil, 689 - (406 + 123)),IceColdTalent=v16(416428 - (1749 + 20), nil, 39 + 122),IceFloes=v16(110161 - (1249 + 73), nil, 8 + 13),IceNova=v16(159142 - (466 + 679), nil, 52 - 30),Invisibility=v16(188 - 122, nil, 1923 - (106 + 1794)),MassBarrier=v16(131179 + 283481, nil, 7 + 17),Meteor=v16(453373 - 299812, nil, 67 - 42),MirrorImage=v16(55456 - (4 + 110), nil, 610 - (57 + 527)),RemoveCurse=v16(1902 - (41 + 1386), nil, 130 - (17 + 86)),RingOfFrost=v16(77185 + 36539, nil, 62 - 34),RuneofPower=v16(335961 - 219950, nil, 195 - (122 + 44)),ShiftingPower=v16(660601 - 278161, nil, 99 - 69),Spellsteal=v16(24770 + 5679, nil, 5 + 26),TemporalWarp=v16(783072 - 396533, nil, 97 - (30 + 35)),ArcaneIntellectBuff=v16(1003 + 456, nil, 1290 - (1043 + 214)),BerserkingBuff=v16(99419 - 73122, nil, 1246 - (323 + 889)),BloodFuryBuff=v16(55372 - 34800, nil, 615 - (361 + 219)),RuneofPowerBuff=v16(116334 - (53 + 267), nil, 9 + 27),TemporalWarpBuff=v16(386953 - (15 + 398), nil, 1019 - (18 + 964)),Pool=v16(3763780 - 2763870, nil, 116 + 84)};
	v16.Mage.Arcane = v19(v16.Mage.Commons, {ArcaneBlast=v16(19186 + 11265, nil, 888 - (20 + 830)),FireBlast=v16(249661 + 70175, nil, 165 - (116 + 10)),Amplification=v16(17479 + 219149, nil, 778 - (542 + 196)),ArcaneBarrage=v16(95234 - 50809, nil, 12 + 29),ArcaneBombardment=v16(195394 + 189187, nil, 16 + 26),ArcaneEcho=v16(901809 - 559578, nil, 109 - 66),ArcaneFamiliar=v16(206573 - (1126 + 425), nil, 449 - (118 + 287)),ArcaneHarmony=v16(1506779 - 1122327, nil, 1166 - (118 + 1003)),ArcaneMissiles=v16(15050 - 9907, nil, 423 - (142 + 235)),ArcaneOrb=v16(696927 - 543301, nil, 11 + 36),ArcanePower=v16(322716 - (553 + 424), nil, 90 - 42),ArcaneSurge=v16(321843 + 43507, nil, 49 + 0),ArcingCleave=v16(134830 + 96734, nil, 66 + 89),CascadingPower=v16(219449 + 164827, nil, 108 - 58),ChargedOrb=v16(1071759 - 687108, nil, 114 - 63),ConjureManaGem=v16(221 + 538, nil, 251 - 199),Concentration=v16(385127 - (239 + 514), nil, 19 + 34),Enlightened=v16(322716 - (797 + 532), nil, 40 + 14),Evocation=v16(4066 + 7985, nil, 128 - 73),NetherTempest=v16(116125 - (373 + 829), nil, 788 - (476 + 255)),NetherPrecision=v16(384912 - (369 + 761), nil, 34 + 24),OrbBarrage=v16(699052 - 314194, nil, 111 - 52),Overpowered=v16(155385 - (64 + 174), nil, 9 + 51),PresenceofMind=v16(303629 - 98604, nil, 397 - (144 + 192)),PrismaticBarrier=v16(235666 - (42 + 174), nil, 47 + 15),RadiantSpark=v16(311554 + 64549, nil, 27 + 36),Resonance=v16(206532 - (363 + 1141), nil, 1644 - (1183 + 397)),RuleofThrees=v16(804784 - 540430, nil, 48 + 17),SiphonStorm=v16(287164 + 97023, nil, 2041 - (1913 + 62)),Slipstream=v16(148916 + 87541, nil, 177 - 110),Supernova=v16(159913 - (565 + 1368), nil, 255 - 187),TimeAnomaly=v16(384904 - (1477 + 184), nil, 93 - 24),TouchoftheMagi=v16(299565 + 21942, nil, 926 - (564 + 292)),ArcaneArtilleryBuff=v16(732152 - 307821, nil, 457 - 305),ArcaneFamiliarBuff=v16(210430 - (244 + 60), nil, 55 + 16),ArcaneHarmonyBuff=v16(384931 - (41 + 435), nil, 1073 - (938 + 63)),ArcaneOverloadBuff=v16(314570 + 94452, nil, 1198 - (936 + 189)),ArcaneSurgeBuff=v16(120241 + 245121, nil, 1687 - (1565 + 48)),ClearcastingBuff=v16(162908 + 100817, nil, 1213 - (782 + 356)),ConcentrationBuff=v16(384646 - (176 + 91), nil, 197 - 121),NetherPrecisionBuff=v16(565623 - 181840, nil, 1169 - (975 + 117)),PresenceofMindBuff=v16(206900 - (157 + 1718), nil, 64 + 14),RuleofThreesBuff=v16(939927 - 675153, nil, 269 - 190),SiphonStormBuff=v16(385285 - (697 + 321), nil, 217 - 137),NetherTempestDebuff=v16(243476 - 128553, nil, 186 - 105),RadiantSparkDebuff=v16(146396 + 229707, nil, 153 - 71),RadiantSparkVulnerability=v16(1008226 - 632122, nil, 1310 - (322 + 905)),TouchoftheMagiDebuff=v16(211435 - (602 + 9), nil, 1273 - (449 + 740))});
	v16.Mage.Fire = v19(v16.Mage.Commons, {Fireball=v16(1005 - (826 + 46), nil, 1032 - (245 + 702)),Flamestrike=v16(6699 - 4579, nil, 28 + 58),AlexstraszasFury=v16(237768 - (260 + 1638), nil, 527 - (382 + 58)),BlazingBarrier=v16(754900 - 519587, nil, 74 + 14),Combustion=v16(393331 - 203012, nil, 264 - 175),FeeltheBurn=v16(384596 - (902 + 303), nil, 197 - 107),FireBlast=v17(219 - 128, 9354 + 99499, 233257 - (1121 + 569), 320050 - (22 + 192)),Firestarter=v16(205709 - (483 + 200), nil, 1555 - (1404 + 59)),FlameOn=v16(561110 - 356081, nil, 124 - 31),FlamePatch=v16(205802 - (468 + 297), nil, 656 - (334 + 228)),FromTheAshes=v16(1154721 - 812377, nil, 220 - 125),FueltheFire=v16(754645 - 338551, nil, 44 + 110),Hyperthermia=v16(384096 - (141 + 95), nil, 95 + 1),ImprovedScorch=v16(987399 - 603795, nil, 232 - 135),Kindling=v16(36342 + 118806, nil, 268 - 170),LivingBomb=v16(31253 + 13204, nil, 52 + 47),PhoenixFlames=v16(362680 - 105139, nil, 59 + 41),Pyroblast=v16(11529 - (92 + 71), nil, 50 + 51),Scorch=v16(4956 - 2008, nil, 867 - (574 + 191)),SearingTouch=v16(222420 + 47224, nil, 257 - 154),SunKingsBlessing=v16(196085 + 187801, nil, 953 - (254 + 595)),TemperedFlames=v16(383785 - (55 + 71), nil, 137 - 32),CombustionBuff=v16(192109 - (573 + 1217), nil, 293 - 187),FeeltheBurnBuff=v16(29172 + 354223, nil, 171 - 64),FlameAccelerantBuff=v16(204216 - (714 + 225), nil, 315 - 207),FlamesFuryBuff=v16(571556 - 161592, nil, 12 + 97),HeatingUpBuff=v16(69656 - 21549, nil, 916 - (118 + 688)),HotStreakBuff=v16(48156 - (25 + 23), nil, 22 + 89),HyperthermiaBuff=v16(385760 - (927 + 959), nil, 377 - 265),SunKingsBlessingBuff=v16(384614 - (16 + 716), nil, 218 - 105),FuryoftheSunKingBuff=v16(383980 - (11 + 86), nil, 277 - 163),CharringEmbersDebuff=v16(408950 - (175 + 110), nil, 290 - 175),IgniteDebuff=v16(62412 - 49758, nil, 1912 - (503 + 1293)),ImprovedScorchDebuff=v16(1071341 - 687733, nil, 85 + 32)});
	v16.Mage.Frost = v19(v16.Mage.Commons, {ConeofCold=v16(1181 - (810 + 251), nil, 82 + 36),IciclesBuff=v16(63061 + 142412, nil, 108 + 11),WintersChillDebuff=v16(228891 - (43 + 490), nil, 853 - (711 + 22)),FireBlast=v16(1237191 - 917355, nil, 980 - (240 + 619)),Blizzard=v16(45936 + 144420, nil, 193 - 71),BoneChilling=v16(13618 + 192148, nil, 1867 - (1344 + 400)),ChainReaction=v16(278714 - (255 + 150), nil, 98 + 26),ColdestSnap=v16(223516 + 193977, nil, 534 - 409),CometStorm=v16(496099 - 342504, nil, 1865 - (404 + 1335)),Ebonbolt=v16(257943 - (183 + 223), nil, 154 - 27),Flurry=v16(29561 + 15053, nil, 47 + 81),FreezingRain=v16(270570 - (10 + 327), nil, 90 + 39),FreezingWinds=v16(382441 - (118 + 220), nil, 44 + 86),Frostbite=v16(198570 - (108 + 341), nil, 59 + 72),FrozenOrb=v17(557 - 425, 86207 - (711 + 782), 379857 - 181708),GlacialSpike=v16(200255 - (270 + 199), nil, 44 + 89),IceBarrier=v16(13245 - (580 + 1239), nil, 398 - 264),IceCaller=v16(226285 + 10377, nil, 5 + 130),IceLance=v16(13267 + 17188, nil, 354 - 218),IcyVeins=v16(7749 + 4723, nil, 1304 - (645 + 522)),RayofFrost=v16(206811 - (1010 + 780), nil, 138 + 0),SlickIce=v16(1820499 - 1438355, nil, 407 - 268),Snowstorm=v16(383542 - (1045 + 791), nil, 354 - 214),SplinteringCold=v16(578787 - 199738, nil, 646 - (351 + 154)),SplittingIce=v16(57951 - (1281 + 293), nil, 407 - (28 + 238)),SummonWaterElemental=v16(70803 - 39116, nil, 1701 - (1381 + 178)),Freeze=v16(31323 + 2072, nil, 116 + 27),WaterJet=v16(57598 + 77431, nil, 496 - 352),BrainFreezeBuff=v16(98664 + 91782, nil, 615 - (381 + 89)),FingersofFrostBuff=v16(39502 + 5042, nil, 99 + 47),FreezingRainBuff=v16(462903 - 192671, nil, 1303 - (1074 + 82)),FreezingWindsBuff=v16(837376 - 455270, nil, 1932 - (214 + 1570)),GlacialSpikeBuff=v16(201299 - (990 + 465), nil, 62 + 87),IcyVeinsBuff=v16(5427 + 7045, nil, 146 + 4),SnowstormBuff=v16(1501491 - 1119969, nil, 1877 - (1668 + 58)),FrostbiteDebuff=v16(379386 - (512 + 114), nil, 398 - 245)});
	if (not v18.Mage or ((4060 - 2096) <= (4662 - 3322))) then
		v18.Mage = {};
	end
	v18.Mage.Commons = {Dreambinder=v18(97051 + 111565),Iridal=v18(38996 + 169325),Healthstone=v18(4792 + 720),RefreshingHealingPotion=v18(645518 - 454138),DreamwalkersHealingPotion=v18(209017 - (109 + 1885)),PotionOfWitheringDreams=v18(208510 - (1269 + 200))};
	v18.Mage.Arcane = v19(v18.Mage.Commons, {ManaGem=v18(70532 - 33733)});
	v18.Mage.Fire = v19(v18.Mage.Commons, {});
	v18.Mage.Frost = v19(v18.Mage.Commons, {});
	if (((3314 - (98 + 717)) == (3325 - (802 + 24))) and not v21.Mage) then
		v21.Mage = {};
	end
	v21.Mage.Commons = {Healthstone=v21(15 - 6),RefreshingHealingPotion=v21(12 - 2),UseWeapon=v21(15 + 86),CounterspellMouseover=v21(9 + 2),PolymorphMouseover=v21(2 + 10),RemoveCurseMouseover=v21(3 + 10),RemoveCurseFocus=v21(38 - 24),StopCasting=v21(49 - 34)};
	v21.Mage.Arcane = v19(v21.Mage.Commons, {ManaGem=v21(6 + 10),CancelPOM=v21(7 + 10)});
	v21.Mage.Fire = v19(v21.Mage.Commons, {FlamestrikeCursor=v21(15 + 3),MeteorCursor=v21(14 + 5),FireBlastMacro=v21(11 + 12)});
	v21.Mage.Frost = v19(v21.Mage.Commons, {BlizzardCursor=v21(1453 - (797 + 636)),IceLanceMouseover=v21(101 - 80),FreezePet=v21(1641 - (1427 + 192)),FrozenOrbCast=v21(9 + 15)});
	local v36 = v16.Mage.Frost.RuneofPower:BaseDuration();
	local v37;
	v37 = v10.AddCoreOverride("Player.AffectingCombat", function(v49)
		return v16.Mage.Arcane.ArcaneBlast:InFlight() or v37(v49);
	end, 143 - 81);
	v10.AddCoreOverride("Spell.IsCastable", function(v50, v51, v52, v53, v54, v55)
		local v56 = 0 + 0;
		local v57;
		local v58;
		while true do
			if ((v56 == (0 + 0)) or ((2581 - (192 + 134)) < (1298 - (316 + 960)))) then
				if (((v50:CastTime() > (0 + 0)) and v13:IsMoving()) or ((839 + 247) >= (1299 + 106))) then
					return false;
				end
				v57 = true;
				v56 = 3 - 2;
			end
			if ((v56 == (552 - (83 + 468))) or ((4175 - (1202 + 604)) == (1988 - 1562))) then
				if (v52 or ((5118 - 2042) > (8812 - 5629))) then
					local v137 = 325 - (45 + 280);
					local v138;
					while true do
						if (((1161 + 41) > (925 + 133)) and (v137 == (0 + 0))) then
							v138 = v54 or v14;
							v57 = v138:IsInRange(v52, v53);
							break;
						end
					end
				end
				v58 = v50:IsLearned() and (v50:CooldownRemains(v51, v55 or "Auto") == (0 + 0)) and v57 and (v13:Mana() >= v50:Cost());
				v56 = 1 + 1;
			end
			if (((6871 - 3160) > (5266 - (340 + 1571))) and (v56 == (1 + 1))) then
				if ((v50 == v16.Mage.Arcane.PresenceofMind) or ((2678 - (1733 + 39)) >= (6124 - 3895))) then
					return v58 and v13:BuffDown(v16.Mage.Arcane.PresenceofMind);
				elseif (((2322 - (125 + 909)) > (3199 - (1096 + 852))) and (v50 == v16.Mage.Arcane.RadiantSpark)) then
					return v58 and not v13:IsCasting(v50);
				elseif ((v50 == v16.Mage.Arcane.ShiftingPower) or ((2025 + 2488) < (4786 - 1434))) then
					return v58 and not v13:IsCasting(v50);
				elseif ((v50 == v16.Mage.Arcane.TouchoftheMagi) or ((2003 + 62) >= (3708 - (409 + 103)))) then
					return v58 and not v13:IsCasting(v50);
				elseif ((v50 == v16.Mage.Arcane.ConjureManaGem) or ((4612 - (46 + 190)) <= (1576 - (51 + 44)))) then
					local v142 = 0 + 0;
					local v143;
					local v144;
					while true do
						if ((v142 == (1317 - (1114 + 203))) or ((4118 - (228 + 498)) >= (1028 + 3713))) then
							v143 = v18.Mage.Arcane.ManaGem;
							v144 = v143:CooldownRemains();
							v142 = 1 + 0;
						end
						if (((3988 - (174 + 489)) >= (5611 - 3457)) and (v142 == (1906 - (830 + 1075)))) then
							return v58 and not v13:IsCasting(v50) and not (v143:IsReady() or (v144 > (524 - (303 + 221))));
						end
					end
				elseif ((v50 == v16.Mage.Arcane.ArcaneSurge) or ((2564 - (231 + 1038)) >= (2695 + 538))) then
					return v50:IsLearned() and v50:CooldownUp() and v57;
				else
					return v58;
				end
				break;
			end
		end
	end, 1224 - (171 + 991));
	local v38;
	v38 = v10.AddCoreOverride("Player.BuffStack", function(v59, v60, v61, v62)
		local v63 = 0 - 0;
		local v64;
		while true do
			if (((11752 - 7375) > (4097 - 2455)) and (v63 == (0 + 0))) then
				v64 = v38(v59, v60, v61, v62);
				if (((16555 - 11832) > (3911 - 2555)) and (v60 == v60.Mage.Fire.PyroclasmBuff) and v59:IsCasting(v60.Mage.Fire.Pyroblast)) then
					return 0 - 0;
				else
					return v64;
				end
				break;
			end
		end
	end, 194 - 131);
	local v39;
	v39 = v10.AddCoreOverride("Player.BuffRemains", function(v65, v66, v67, v68)
		local v69 = 1248 - (111 + 1137);
		local v70;
		while true do
			if ((v69 == (159 - (91 + 67))) or ((12309 - 8173) <= (857 + 2576))) then
				return v70;
			end
			if (((4768 - (423 + 100)) <= (33 + 4598)) and (v69 == (0 - 0))) then
				v70 = v39(v65, v66, v67, v68);
				if (((2229 + 2047) >= (4685 - (326 + 445))) and (v66 == v66.Mage.Fire.PyroclasmBuff) and v65:IsCasting(v66.Mage.Fire.Pyroblast)) then
					return 0 - 0;
				end
				v69 = 2 - 1;
			end
		end
	end, 146 - 83);
	v10.AddCoreOverride("Spell.IsReady", function(v71, v72, v73, v74, v75, v76)
		local v77 = 711 - (530 + 181);
		local v78;
		local v79;
		while true do
			if (((1079 - (614 + 267)) <= (4397 - (19 + 13))) and (v77 == (0 - 0))) then
				v78 = v71:IsCastable() and v71:IsUsableP();
				v79 = true;
				v77 = 2 - 1;
			end
			if (((13660 - 8878) > (1215 + 3461)) and (v77 == (1 - 0))) then
				if (((10086 - 5222) > (4009 - (1293 + 519))) and (v71:CastTime() > (0 - 0)) and v13:IsMoving()) then
					if ((v71 == v16.Mage.Fire.Scorch) or ((v71 == v16.Mage.Fire.Pyroblast) and v13:BuffUp(v16.Mage.Fire.HotStreakBuff)) or ((v71 == v16.Mage.Fire.Flamestrike) and v13:BuffUp(v16.Mage.Fire.HotStreakBuff)) or ((9660 - 5960) == (4793 - 2286))) then
						v79 = true;
					else
						return false;
					end
				else
					return v78;
				end
				break;
			end
		end
	end, 271 - 208);
	v10.AddCoreOverride("Spell.IsCastable", function(v80, v81, v82, v83, v84, v85)
		if (((10539 - 6065) >= (146 + 128)) and (v80:CastTime() > (0 + 0)) and v13:IsMoving()) then
			return false;
		end
		local v86 = true;
		if (v82 or ((4400 - 2506) <= (325 + 1081))) then
			local v135 = 0 + 0;
			local v136;
			while true do
				if (((983 + 589) >= (2627 - (709 + 387))) and (v135 == (1858 - (673 + 1185)))) then
					v136 = v84 or v14;
					v86 = v136:IsInRange(v82, v83);
					break;
				end
			end
		end
		local v87 = v80:IsLearned() and (v80:CooldownRemains(v81, v85 or "Auto") == (0 - 0)) and v86;
		if ((v80 == v16.Mage.Fire.RadiantSpark) or ((15050 - 10363) < (7472 - 2930))) then
			return v87 and not v13:IsCasting(v80);
		elseif (((2354 + 937) > (1246 + 421)) and (v80 == v16.Mage.Fire.ShiftingPower)) then
			return v87 and not v13:IsCasting(v80);
		else
			return v87;
		end
	end, 84 - 21);
	local v40;
	v40 = v10.AddCoreOverride("Player.AffectingCombat", function(v88)
		return v40(v88) or v13:IsCasting(v16.Mage.Fire.Pyroblast) or v13:IsCasting(v16.Mage.Fire.Fireball);
	end, 16 + 47);
	v10.AddCoreOverride("Spell.InFlightRemains", function(v89)
		return v89:TravelTime() - v89:TimeSinceLastCast();
	end, 125 - 62);
	local v41;
	v41 = v10.AddCoreOverride("Spell.IsCastable", function(v90, v91, v92, v93, v94, v95)
		local v96 = 0 - 0;
		local v97;
		local v98;
		while true do
			if ((v96 == (1881 - (446 + 1434))) or ((2156 - (1040 + 243)) == (6070 - 4036))) then
				v98 = true;
				if (v92 or ((4663 - (559 + 1288)) < (1942 - (609 + 1322)))) then
					local v139 = 454 - (13 + 441);
					local v140;
					while true do
						if (((13822 - 10123) < (12326 - 7620)) and (v139 == (0 - 0))) then
							v140 = v94 or v14;
							v98 = v140:IsInRange(v92, v93);
							break;
						end
					end
				end
				v96 = 1 + 1;
			end
			if (((9609 - 6963) >= (312 + 564)) and (v96 == (1 + 1))) then
				if (((1822 - 1208) <= (1743 + 1441)) and (v90 == v16.Mage.Frost.GlacialSpike)) then
					return v90:IsLearned() and v98 and v97 and not v13:IsCasting(v90) and (v13:BuffUp(v16.Mage.Frost.GlacialSpikeBuff) or (v13:BuffStack(v16.Mage.Frost.IciclesBuff) == (8 - 3)));
				else
					local v141 = v41(v90, v91, v92, v93, v94, v95);
					if (((2067 + 1059) == (1739 + 1387)) and (v90 == v16.Mage.Frost.SummonWaterElemental)) then
						return v141 and not v15:IsActive();
					elseif ((v90 == v16.Mage.Frost.RuneofPower) or ((1572 + 615) >= (4160 + 794))) then
						return v141 and not v13:IsCasting(v90) and v13:BuffDown(v16.Mage.Frost.RuneofPowerBuff);
					elseif ((v90 == v16.Mage.Frost.MirrorsofTorment) or ((3794 + 83) == (4008 - (153 + 280)))) then
						return v141 and not v13:IsCasting(v90);
					elseif (((2041 - 1334) > (568 + 64)) and (v90 == v16.Mage.Frost.RadiantSpark)) then
						return v141 and not v13:IsCasting(v90);
					elseif ((v90 == v16.Mage.Frost.ShiftingPower) or ((216 + 330) >= (1405 + 1279))) then
						return v141 and not v13:IsCasting(v90);
					elseif (((1330 + 135) <= (3117 + 1184)) and (v90 == v16.Mage.Frost.Deathborne)) then
						return v141 and not v13:IsCasting(v90);
					else
						return v141;
					end
				end
				break;
			end
			if (((2594 - 890) > (881 + 544)) and (v96 == (667 - (89 + 578)))) then
				v97 = true;
				if (((v90:CastTime() > (0 + 0)) and v13:IsMoving()) or ((1428 - 741) == (5283 - (572 + 477)))) then
					if (((v90 == v16.Mage.Frost.Blizzard) and v13:BuffUp(v16.Mage.Frost.FreezingRain)) or ((450 + 2880) < (858 + 571))) then
						v97 = true;
					else
						return false;
					end
				end
				v96 = 1 + 0;
			end
		end
	end, 150 - (84 + 2));
	local v42;
	v42 = v10.AddCoreOverride("Spell.CooldownRemains", function(v99, v100, v101)
		if (((1889 - 742) >= (242 + 93)) and (v99 == v16.Mage.Frost.Blizzard) and v13:IsCasting(v99)) then
			return 850 - (497 + 345);
		elseif (((88 + 3347) > (355 + 1742)) and (v99 == v16.Mage.Frost.Ebonbolt) and v13:IsCasting(v99)) then
			return 1378 - (605 + 728);
		else
			return v42(v99, v100, v101);
		end
	end, 46 + 18);
	local v43;
	v43 = v10.AddCoreOverride("Player.BuffStackP", function(v102, v103, v104, v105)
		local v106 = v13:BuffStack(v103);
		if ((v103 == v103.Mage.Frost.IciclesBuff) or ((8381 - 4611) >= (186 + 3855))) then
			return (v102:IsCasting(v103.Mage.Frost.GlacialSpike) and (0 - 0)) or math.min(v106 + ((v102:IsCasting(v103.Mage.Frost.Frostbolt) and (1 + 0)) or (0 - 0)), 4 + 1);
		elseif ((v103 == v103.Mage.Frost.GlacialSpikeBuff) or ((4280 - (457 + 32)) <= (684 + 927))) then
			return (v102:IsCasting(v103.Mage.Frost.GlacialSpike) and (1402 - (832 + 570))) or v106;
		elseif ((v103 == v103.Mage.Frost.WintersReachBuff) or ((4313 + 265) <= (524 + 1484))) then
			return (v102:IsCasting(v103.Mage.Frost.Flurry) and (0 - 0)) or v106;
		elseif (((542 + 583) <= (2872 - (588 + 208))) and (v103 == v103.Mage.Frost.FingersofFrostBuff)) then
			if (v103.Mage.Frost.IceLance:InFlight() or ((2002 - 1259) >= (6199 - (884 + 916)))) then
				if (((2418 - 1263) < (971 + 702)) and (v106 == (653 - (232 + 421)))) then
					return 1889 - (1569 + 320);
				else
					return v106 - (1 + 0);
				end
			else
				return v106;
			end
		else
			return v106;
		end
	end, 13 + 51);
	local v44;
	v44 = v10.AddCoreOverride("Player.BuffUpP", function(v107, v108, v109, v110)
		local v111 = v13:BuffUp(v108);
		if ((v108 == v108.Mage.Frost.FingersofFrostBuff) or ((7831 - 5507) <= (1183 - (316 + 289)))) then
			if (((9860 - 6093) == (174 + 3593)) and v108.Mage.Frost.IceLance:InFlight()) then
				return v13:BuffStack(v108) >= (1454 - (666 + 787));
			else
				return v111;
			end
		else
			return v111;
		end
	end, 489 - (360 + 65));
	local v45;
	v45 = v10.AddCoreOverride("Player.BuffDownP", function(v112, v113, v114, v115)
		local v116 = 0 + 0;
		local v117;
		while true do
			if (((4343 - (79 + 175)) == (6446 - 2357)) and (v116 == (0 + 0))) then
				v117 = v13:BuffDown(v113);
				if (((13664 - 9206) >= (3223 - 1549)) and (v113 == v113.Mage.Frost.FingersofFrostBuff)) then
					if (((1871 - (503 + 396)) <= (1599 - (92 + 89))) and v113.Mage.Frost.IceLance:InFlight()) then
						return v13:BuffStack(v113) == (0 - 0);
					else
						return v117;
					end
				else
					return v117;
				end
				break;
			end
		end
	end, 33 + 31);
	local v46;
	v46 = v10.AddCoreOverride("Target.DebuffStack", function(v118, v119, v120, v121)
		local v122 = 0 + 0;
		local v123;
		while true do
			if ((v122 == (0 - 0)) or ((676 + 4262) < (10857 - 6095))) then
				v123 = v46(v118, v119, v120, v121);
				if ((v119 == v119.Mage.Frost.WintersChillDebuff) or ((2185 + 319) > (2037 + 2227))) then
					if (((6557 - 4404) == (269 + 1884)) and v119.Mage.Frost.Flurry:InFlight()) then
						return 2 - 0;
					elseif (v119.Mage.Frost.IceLance:InFlight() or ((1751 - (485 + 759)) >= (5995 - 3404))) then
						if (((5670 - (442 + 747)) == (5616 - (832 + 303))) and (v123 == (946 - (88 + 858)))) then
							return 0 + 0;
						else
							return v123 - (1 + 0);
						end
					else
						return v123;
					end
				else
					return v123;
				end
				break;
			end
		end
	end, 3 + 61);
	local v47;
	v47 = v10.AddCoreOverride("Target.DebuffRemains", function(v124, v125, v126, v127)
		local v128 = 789 - (766 + 23);
		local v129;
		while true do
			if ((v128 == (0 - 0)) or ((3183 - 855) < (1825 - 1132))) then
				v129 = v47(v124, v125, v126, v127);
				if (((14689 - 10361) == (5401 - (1036 + 37))) and (v125 == v125.Mage.Frost.WintersChillDebuff)) then
					return (v125.Mage.Frost.Flurry:InFlight() and (5 + 1)) or v129;
				else
					return v129;
				end
				break;
			end
		end
	end, 124 - 60);
	local v48;
	v48 = v10.AddCoreOverride("Player.AffectingCombat", function(v130)
		return v16.Mage.Frost.Frostbolt:InFlight() or v48(v130);
	end, 51 + 13);
end;
return v0["Epix_Mage_Mage.lua"]();

