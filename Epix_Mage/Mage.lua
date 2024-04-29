local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((14575 - 11293) > (3796 + 931))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Mage_Mage.lua"] = function(...)
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
	local v19 = EpicLib;
	local v20 = v19.Macro;
	local v21 = GetTime;
	local v22 = math.min;
	if (not v15.Mage or ((9458 - 5479) < (4994 - 1537))) then
		v15.Mage = {};
	end
	v15.Mage.Commons = {AncestralCall=v15(386164 - 111426, nil, 2 - 1),BagofTricks=v15(312696 - (134 + 151), nil, 1667 - (970 + 695)),Berserking=v15(50180 - 23883, nil, 1993 - (582 + 1408)),BloodFury=v15(71344 - 50772, nil, 4 - 0),Fireblood=v15(999447 - 734226, nil, 1829 - (1195 + 629)),LightsJudgment=v15(338092 - 82445, nil, 247 - (187 + 54)),ArcaneExplosion=v15(2229 - (162 + 618), nil, 5 + 2),ArcaneIntellect=v15(972 + 487, nil, 16 - 8),Blink=v16(14 - 5, 153 + 1800, 214289 - (1373 + 263)),Frostbolt=v15(1116 - (451 + 549), nil, 4 + 6),FrostNova=v15(189 - 67, nil, 18 - 7),Polymorph=v15(1502 - (746 + 638), nil, 5 + 7),SlowFall=v15(197 - 67, nil, 354 - (218 + 123)),TimeWarp=v15(81934 - (1535 + 46), nil, 14 + 0),AlterTime=v15(49524 + 292721, nil, 575 - (306 + 254)),BlastWave=v15(9781 + 148200, nil, 30 - 14),Counterspell=v15(3606 - (899 + 568), nil, 12 + 5),DragonsBreath=v15(76616 - 44955, nil, 621 - (268 + 335)),FocusMagic=v15(321648 - (60 + 230), nil, 591 - (426 + 146)),GreaterInvisibility=v15(13293 + 97666, nil, 1512 - (282 + 1174)),IceBlock=v15(46249 - (569 + 242), nil, 57 - 37),IceColdAbility=v15(23713 + 390945, nil, 1184 - (706 + 318)),IceColdTalent=v15(415910 - (721 + 530), nil, 1432 - (945 + 326)),IceFloes=v15(271914 - 163075, nil, 19 + 2),IceNova=v15(158697 - (271 + 429), nil, 21 + 1),Invisibility=v15(1566 - (1408 + 92), nil, 1109 - (461 + 625)),MassBarrier=v15(415948 - (993 + 295), nil, 2 + 22),Meteor=v15(154732 - (418 + 753), nil, 10 + 15),MirrorImage=v15(5704 + 49638, nil, 8 + 18),RemoveCurse=v15(121 + 354, nil, 556 - (406 + 123)),RingOfFrost=v15(115493 - (1749 + 20), nil, 7 + 21),RuneofPower=v15(117333 - (1249 + 73), nil, 11 + 18),ShiftingPower=v15(383585 - (466 + 679), nil, 72 - 42),Spellsteal=v15(87089 - 56640, nil, 1931 - (106 + 1794)),TemporalWarp=v15(122283 + 264256, nil, 9 + 23),ArcaneIntellectBuff=v15(4307 - 2848, nil, 89 - 56),BerserkingBuff=v15(26411 - (4 + 110), nil, 618 - (57 + 527)),BloodFuryBuff=v15(21999 - (41 + 1386), nil, 138 - (17 + 86)),RuneofPowerBuff=v15(78740 + 37274, nil, 79 - 43),TemporalWarpBuff=v15(1119398 - 732858, nil, 203 - (122 + 44)),Pool=v15(1727177 - 727267, nil, 663 - 463)};
	v15.Mage.Arcane = v18(v15.Mage.Commons, {ArcaneBlast=v15(24772 + 5679, nil, 6 + 32),FireBlast=v15(647941 - 328105, nil, 104 - (30 + 35)),Amplification=v15(162637 + 73991, nil, 1297 - (1043 + 214)),ArcaneBarrage=v15(167955 - 123530, nil, 1253 - (323 + 889)),ArcaneBombardment=v15(1035154 - 650573, nil, 622 - (361 + 219)),ArcaneEcho=v15(342551 - (53 + 267), nil, 10 + 33),ArcaneFamiliar=v15(205435 - (15 + 398), nil, 1026 - (18 + 964)),ArcaneHarmony=v15(1447122 - 1062670, nil, 27 + 18),ArcaneMissiles=v15(3241 + 1902, nil, 896 - (20 + 830)),ArcaneOrb=v15(119919 + 33707, nil, 173 - (116 + 10)),ArcanePower=v15(23766 + 297973, nil, 786 - (542 + 196)),ArcaneSurge=v15(783204 - 417854, nil, 15 + 34),ArcingCleave=v15(117651 + 113913, nil, 56 + 99),CascadingPower=v15(1012601 - 628325, nil, 128 - 78),ChargedOrb=v15(386202 - (1126 + 425), nil, 456 - (118 + 287)),ConjureManaGem=v15(2974 - 2215, nil, 1173 - (118 + 1003)),Concentration=v15(1124843 - 740469, nil, 430 - (142 + 235)),Enlightened=v15(1457978 - 1136591, nil, 12 + 42),Evocation=v15(13028 - (553 + 424), nil, 103 - 48),NetherTempest=v15(101238 + 13685, nil, 57 + 0),NetherPrecision=v15(223460 + 160322, nil, 25 + 33),OrbBarrage=v15(219781 + 165077, nil, 127 - 68),Overpowered=v15(432288 - 277141, nil, 134 - 74),PresenceofMind=v15(59620 + 145405, nil, 294 - 233),PrismaticBarrier=v15(236203 - (239 + 514), nil, 22 + 40),RadiantSpark=v15(377432 - (797 + 532), nil, 46 + 17),Resonance=v15(69167 + 135861, nil, 150 - 86),RuleofThrees=v15(265556 - (373 + 829), nil, 796 - (476 + 255)),SiphonStorm=v15(385317 - (369 + 761), nil, 39 + 27),Slipstream=v15(429497 - 193040, nil, 126 - 59),Supernova=v15(158218 - (64 + 174), nil, 10 + 58),TimeAnomaly=v15(567558 - 184315, nil, 405 - (144 + 192)),TouchoftheMagi=v15(321723 - (42 + 174), nil, 53 + 17),ArcaneArtilleryBuff=v15(351504 + 72827, nil, 65 + 87),ArcaneFamiliarBuff=v15(211630 - (363 + 1141), nil, 1651 - (1183 + 397)),ArcaneHarmonyBuff=v15(1170413 - 785958, nil, 53 + 19),ArcaneOverloadBuff=v15(305727 + 103295, nil, 2048 - (1913 + 62)),ArcaneSurgeBuff=v15(230098 + 135264, nil, 195 - 121),ClearcastingBuff=v15(265658 - (565 + 1368), nil, 282 - 207),ConcentrationBuff=v15(386040 - (1477 + 184), nil, 102 - 26),NetherPrecisionBuff=v15(357591 + 26192, nil, 933 - (564 + 292)),PresenceofMindBuff=v15(353755 - 148730, nil, 234 - 156),RuleofThreesBuff=v15(265078 - (244 + 60), nil, 61 + 18),SiphonStormBuff=v15(384743 - (41 + 435), nil, 1081 - (938 + 63)),NetherTempestDebuff=v15(88385 + 26538, nil, 1206 - (936 + 189)),RadiantSparkDebuff=v15(123776 + 252327, nil, 1695 - (1565 + 48)),RadiantSparkVulnerability=v15(232326 + 143778, nil, 1221 - (782 + 356)),TouchoftheMagiDebuff=v15(211091 - (176 + 91), nil, 218 - 134)});
	v15.Mage.Fire = v18(v15.Mage.Commons, {Fireball=v15(195 - 62, nil, 1177 - (975 + 117)),Flamestrike=v15(3995 - (157 + 1718), nil, 70 + 16),AlexstraszasFury=v15(837320 - 601450, nil, 297 - 210),BlazingBarrier=v15(236331 - (697 + 321), nil, 239 - 151),Combustion=v15(403211 - 212892, nil, 204 - 115),FeeltheBurn=v15(149233 + 234158, nil, 168 - 78),FireBlast=v16(243 - 152, 110080 - (322 + 905), 232178 - (602 + 9), 321025 - (449 + 740)),Firestarter=v15(205898 - (826 + 46), nil, 1039 - (245 + 702)),FlameOn=v15(647882 - 442853, nil, 30 + 63),FlamePatch=v15(206935 - (260 + 1638), nil, 534 - (382 + 58)),FromTheAshes=v15(1098263 - 755919, nil, 79 + 16),FueltheFire=v15(859941 - 443847, nil, 457 - 303),Hyperthermia=v15(385065 - (902 + 303), nil, 210 - 114),ImprovedScorch=v15(923911 - 540307, nil, 9 + 88),Kindling=v15(156838 - (1121 + 569), nil, 312 - (22 + 192)),LivingBomb=v15(45140 - (483 + 200), nil, 1562 - (1404 + 59)),PhoenixFlames=v15(704822 - 447281, nil, 134 - 34),Pyroblast=v15(12131 - (468 + 297), nil, 663 - (334 + 228)),Scorch=v15(9943 - 6995, nil, 235 - 133),SearingTouch=v15(489037 - 219393, nil, 30 + 73),SunKingsBlessing=v15(384122 - (141 + 95), nil, 103 + 1),TemperedFlames=v15(987540 - 603881, nil, 252 - 147),CombustionBuff=v15(44580 + 145739, nil, 290 - 184),FeeltheBurnBuff=v15(269524 + 113871, nil, 56 + 51),FlameAccelerantBuff=v15(286262 - 82985, nil, 64 + 44),FlamesFuryBuff=v15(410127 - (92 + 71), nil, 54 + 55),HeatingUpBuff=v15(80881 - 32774, nil, 875 - (574 + 191)),HotStreakBuff=v15(39683 + 8425, nil, 277 - 166),HyperthermiaBuff=v15(196079 + 187795, nil, 961 - (254 + 595)),SunKingsBlessingBuff=v15(384008 - (55 + 71), nil, 147 - 34),FuryoftheSunKingBuff=v15(385673 - (573 + 1217), nil, 315 - 201),CharringEmbersDebuff=v15(31095 + 377570, nil, 185 - 70),IgniteDebuff=v15(13593 - (714 + 225), nil, 338 - 222),ImprovedScorchDebuff=v15(534811 - 151203, nil, 13 + 104)});
	v15.Mage.Frost = v18(v15.Mage.Commons, {ConeofCold=v15(173 - 53, nil, 924 - (118 + 688)),IciclesBuff=v15(205521 - (25 + 23), nil, 24 + 95),WintersChillDebuff=v15(230244 - (927 + 959), nil, 404 - 284),FireBlast=v15(320568 - (16 + 716), nil, 233 - 112),Blizzard=v15(190453 - (11 + 86), nil, 297 - 175),BoneChilling=v15(206051 - (175 + 110), nil, 309 - 186),ChainReaction=v15(1372689 - 1094380, nil, 1920 - (503 + 1293)),ColdestSnap=v15(1165975 - 748482, nil, 91 + 34),CometStorm=v15(154656 - (810 + 251), nil, 88 + 38),Ebonbolt=v15(79039 + 178498, nil, 115 + 12),Flurry=v15(45147 - (43 + 490), nil, 861 - (711 + 22)),FreezingRain=v15(1045316 - 775083, nil, 988 - (240 + 619)),FreezingWinds=v15(92207 + 289896, nil, 206 - 76),Frostbite=v15(13112 + 185009, nil, 1875 - (1344 + 400)),FrozenOrb=v16(537 - (255 + 150), 66728 + 17986, 106084 + 92065),GlacialSpike=v15(853601 - 653815, nil, 429 - 296),IceBarrier=v15(13165 - (404 + 1335), nil, 540 - (183 + 223)),IceCaller=v15(287985 - 51323, nil, 90 + 45),IceLance=v15(10961 + 19494, nil, 473 - (10 + 327)),IcyVeins=v15(8686 + 3786, nil, 475 - (118 + 220)),RayofFrost=v15(68324 + 136697, nil, 587 - (108 + 341)),SlickIce=v15(171635 + 210509, nil, 587 - 448),Snowstorm=v15(383199 - (711 + 782), nil, 268 - 128),SplinteringCold=v15(379518 - (270 + 199), nil, 46 + 95),SplittingIce=v15(58196 - (580 + 1239), nil, 419 - 278),SummonWaterElemental=v15(30298 + 1389, nil, 6 + 136),Freeze=v15(14548 + 18847, nil, 372 - 229),WaterJet=v15(83888 + 51141, nil, 1311 - (645 + 522)),BrainFreezeBuff=v15(192236 - (1010 + 780), nil, 145 + 0),FingersofFrostBuff=v15(212203 - 167659, nil, 427 - 281),FreezingRainBuff=v15(272068 - (1045 + 791), nil, 371 - 224),FreezingWindsBuff=v15(583455 - 201349, nil, 653 - (351 + 154)),GlacialSpikeBuff=v15(201418 - (1281 + 293), nil, 415 - (28 + 238)),IcyVeinsBuff=v15(27867 - 15395, nil, 1709 - (1381 + 178)),SnowstormBuff=v15(357844 + 23678, nil, 122 + 29),FrostbiteDebuff=v15(161564 + 217196, nil, 527 - 374)});
	if (((222 + 206) < (2274 - (381 + 89))) and not v17.Mage) then
		v17.Mage = {};
	end
	v17.Mage.Commons = {Dreambinder=v17(184999 + 23617),Iridal=v17(140886 + 67435),Healthstone=v17(9441 - 3929),RefreshingHealingPotion=v17(192536 - (1074 + 82)),DreamwalkersHealingPotion=v17(453685 - 246662)};
	v17.Mage.Arcane = v18(v17.Mage.Commons, {ManaGem=v17(38583 - (214 + 1570))});
	v17.Mage.Fire = v18(v17.Mage.Commons, {});
	v17.Mage.Frost = v18(v17.Mage.Commons, {});
	if (not v20.Mage or ((4780 - (990 + 465)) > (1902 + 2711))) then
		v20.Mage = {};
	end
	v20.Mage.Commons = {Healthstone=v20(4 + 5),RefreshingHealingPotion=v20(10 + 0),UseWeapon=v20(397 - 296),CounterspellMouseover=v20(1737 - (1668 + 58)),PolymorphMouseover=v20(638 - (512 + 114)),RemoveCurseMouseover=v20(33 - 20),RemoveCurseFocus=v20(28 - 14),StopCasting=v20(52 - 37)};
	v20.Mage.Arcane = v18(v20.Mage.Commons, {ManaGem=v20(8 + 8),CancelPOM=v20(4 + 13)});
	v20.Mage.Fire = v18(v20.Mage.Commons, {FlamestrikeCursor=v20(16 + 2),MeteorCursor=v20(63 - 44),FireBlastMacro=v20(2017 - (109 + 1885))});
	v20.Mage.Frost = v18(v20.Mage.Commons, {BlizzardCursor=v20(1489 - (1269 + 200)),IceLanceMouseover=v20(40 - 19),FreezePet=v20(837 - (98 + 717)),FrozenOrbCast=v20(850 - (802 + 24))});
	local v35 = v15.Mage.Frost.RuneofPower:BaseDuration();
	local v36;
	v36 = v9.AddCoreOverride("Player.AffectingCombat", function(v48)
		return v15.Mage.Arcane.ArcaneBlast:InFlight() or v36(v48);
	end, 106 - 44);
	v9.AddCoreOverride("Spell.IsCastable", function(v49, v50, v51, v52, v53, v54)
		if (((v49:CastTime() > (0 - 0)) and v12:IsMoving()) or ((732 + 4218) <= (3499 + 1054))) then
			return false;
		end
		local v55 = true;
		if (((438 + 2227) <= (849 + 3084)) and v51) then
			local v134 = 0 - 0;
			local v135;
			while true do
				if (((10914 - 7641) == (1171 + 2102)) and (v134 == (0 + 0))) then
					v135 = v53 or v13;
					v55 = v135:IsInRange(v51, v52);
					break;
				end
			end
		end
		local v56 = v49:IsLearned() and (v49:CooldownRemains(v50, v54 or "Auto") == (0 + 0)) and v55 and (v12:Mana() >= v49:Cost());
		if (((2781 + 1043) > (191 + 218)) and (v49 == v15.Mage.Arcane.PresenceofMind)) then
			return v56 and v12:BuffDown(v15.Mage.Arcane.PresenceofMind);
		elseif (((3520 - (797 + 636)) == (10133 - 8046)) and (v49 == v15.Mage.Arcane.RadiantSpark)) then
			return v56 and not v12:IsCasting(v49);
		elseif ((v49 == v15.Mage.Arcane.ShiftingPower) or ((5023 - (1427 + 192)) > (1561 + 2942))) then
			return v56 and not v12:IsCasting(v49);
		elseif ((v49 == v15.Mage.Arcane.TouchoftheMagi) or ((8140 - 4634) <= (1177 + 132))) then
			return v56 and not v12:IsCasting(v49);
		elseif (((1340 + 1615) == (3281 - (192 + 134))) and (v49 == v15.Mage.Arcane.ConjureManaGem)) then
			local v140 = v17.Mage.Arcane.ManaGem;
			local v141 = v140:CooldownRemains();
			return v56 and not v12:IsCasting(v49) and not (v140:IsReady() or (v141 > (1276 - (316 + 960))));
		elseif ((v49 == v15.Mage.Arcane.ArcaneSurge) or ((1616 + 1287) == (1154 + 341))) then
			return v49:IsLearned() and v49:CooldownUp() and v55;
		else
			return v56;
		end
	end, 58 + 4);
	local v37;
	v37 = v9.AddCoreOverride("Player.BuffStack", function(v57, v58, v59, v60)
		local v61 = 0 - 0;
		local v62;
		while true do
			if (((5097 - (83 + 468)) >= (4081 - (1202 + 604))) and (v61 == (0 - 0))) then
				v62 = v37(v57, v58, v59, v60);
				if (((1362 - 543) >= (60 - 38)) and (v58 == v58.Mage.Fire.PyroclasmBuff) and v57:IsCasting(v58.Mage.Fire.Pyroblast)) then
					return 325 - (45 + 280);
				else
					return v62;
				end
				break;
			end
		end
	end, 61 + 2);
	local v38;
	v38 = v9.AddCoreOverride("Player.BuffRemains", function(v63, v64, v65, v66)
		local v67 = 0 + 0;
		local v68;
		while true do
			if (((1155 + 2007) == (1750 + 1412)) and (v67 == (1 + 0))) then
				return v68;
			end
			if ((v67 == (0 - 0)) or ((4280 - (340 + 1571)) > (1747 + 2682))) then
				v68 = v38(v63, v64, v65, v66);
				if (((5867 - (1733 + 39)) >= (8746 - 5563)) and (v64 == v64.Mage.Fire.PyroclasmBuff) and v63:IsCasting(v64.Mage.Fire.Pyroblast)) then
					return 1034 - (125 + 909);
				end
				v67 = 1949 - (1096 + 852);
			end
		end
	end, 29 + 34);
	v9.AddCoreOverride("Spell.IsReady", function(v69, v70, v71, v72, v73, v74)
		local v75 = 0 - 0;
		local v76;
		local v77;
		while true do
			if ((v75 == (0 + 0)) or ((4223 - (409 + 103)) < (1244 - (46 + 190)))) then
				v76 = v69:IsCastable() and v69:IsUsableP();
				v77 = true;
				v75 = 96 - (51 + 44);
			end
			if ((v75 == (1 + 0)) or ((2366 - (1114 + 203)) <= (1632 - (228 + 498)))) then
				if (((978 + 3535) > (1507 + 1219)) and (v69:CastTime() > (663 - (174 + 489))) and v12:IsMoving()) then
					if ((v69 == v15.Mage.Fire.Scorch) or ((v69 == v15.Mage.Fire.Pyroblast) and v12:BuffUp(v15.Mage.Fire.HotStreakBuff)) or ((v69 == v15.Mage.Fire.Flamestrike) and v12:BuffUp(v15.Mage.Fire.HotStreakBuff)) or ((3858 - 2377) >= (4563 - (830 + 1075)))) then
						v77 = true;
					else
						return false;
					end
				else
					return v76;
				end
				break;
			end
		end
	end, 587 - (303 + 221));
	v9.AddCoreOverride("Spell.IsCastable", function(v78, v79, v80, v81, v82, v83)
		local v84 = 1269 - (231 + 1038);
		local v85;
		local v86;
		while true do
			if ((v84 == (2 + 0)) or ((4382 - (171 + 991)) == (5621 - 4257))) then
				if ((v78 == v15.Mage.Fire.RadiantSpark) or ((2829 - 1775) > (8464 - 5072))) then
					return v86 and not v12:IsCasting(v78);
				elseif ((v78 == v15.Mage.Fire.ShiftingPower) or ((542 + 134) >= (5755 - 4113))) then
					return v86 and not v12:IsCasting(v78);
				else
					return v86;
				end
				break;
			end
			if (((11931 - 7795) > (3863 - 1466)) and (v84 == (0 - 0))) then
				if (((v78:CastTime() > (1248 - (111 + 1137))) and v12:IsMoving()) or ((4492 - (91 + 67)) == (12634 - 8389))) then
					return false;
				end
				v85 = true;
				v84 = 1 + 0;
			end
			if ((v84 == (524 - (423 + 100))) or ((31 + 4245) <= (8392 - 5361))) then
				if (v80 or ((2493 + 2289) <= (1970 - (326 + 445)))) then
					local v136 = 0 - 0;
					local v137;
					while true do
						if ((v136 == (0 - 0)) or ((11353 - 6489) < (2613 - (530 + 181)))) then
							v137 = v82 or v13;
							v85 = v137:IsInRange(v80, v81);
							break;
						end
					end
				end
				v86 = v78:IsLearned() and (v78:CooldownRemains(v79, v83 or "Auto") == (881 - (614 + 267))) and v85;
				v84 = 34 - (19 + 13);
			end
		end
	end, 101 - 38);
	local v39;
	v39 = v9.AddCoreOverride("Player.AffectingCombat", function(v87)
		return v39(v87) or v12:IsCasting(v15.Mage.Fire.Pyroblast) or v12:IsCasting(v15.Mage.Fire.Fireball);
	end, 146 - 83);
	v9.AddCoreOverride("Spell.InFlightRemains", function(v88)
		return v88:TravelTime() - v88:TimeSinceLastCast();
	end, 179 - 116);
	local v40;
	v40 = v9.AddCoreOverride("Spell.IsCastable", function(v89, v90, v91, v92, v93, v94)
		local v95 = 0 + 0;
		local v96;
		local v97;
		while true do
			if (((8509 - 3670) >= (7673 - 3973)) and ((1814 - (1293 + 519)) == v95)) then
				if ((v89 == v15.Mage.Frost.GlacialSpike) or ((2193 - 1118) > (5007 - 3089))) then
					return v89:IsLearned() and v97 and v96 and not v12:IsCasting(v89) and (v12:BuffUp(v15.Mage.Frost.GlacialSpikeBuff) or (v12:BuffStack(v15.Mage.Frost.IciclesBuff) == (9 - 4)));
				else
					local v138 = v40(v89, v90, v91, v92, v93, v94);
					if (((1707 - 1311) <= (8961 - 5157)) and (v89 == v15.Mage.Frost.SummonWaterElemental)) then
						return v138 and not v14:IsActive();
					elseif ((v89 == v15.Mage.Frost.RuneofPower) or ((2209 + 1960) == (447 + 1740))) then
						return v138 and not v12:IsCasting(v89) and v12:BuffDown(v15.Mage.Frost.RuneofPowerBuff);
					elseif (((3266 - 1860) == (325 + 1081)) and (v89 == v15.Mage.Frost.MirrorsofTorment)) then
						return v138 and not v12:IsCasting(v89);
					elseif (((509 + 1022) < (2670 + 1601)) and (v89 == v15.Mage.Frost.RadiantSpark)) then
						return v138 and not v12:IsCasting(v89);
					elseif (((1731 - (709 + 387)) == (2493 - (673 + 1185))) and (v89 == v15.Mage.Frost.ShiftingPower)) then
						return v138 and not v12:IsCasting(v89);
					elseif (((9782 - 6409) <= (11418 - 7862)) and (v89 == v15.Mage.Frost.Deathborne)) then
						return v138 and not v12:IsCasting(v89);
					else
						return v138;
					end
				end
				break;
			end
			if (((1 - 0) == v95) or ((2354 + 937) < (2451 + 829))) then
				v97 = true;
				if (((5921 - 1535) >= (215 + 658)) and v91) then
					local v139 = v93 or v13;
					v97 = v139:IsInRange(v91, v92);
				end
				v95 = 3 - 1;
			end
			if (((1807 - 886) <= (2982 - (446 + 1434))) and (v95 == (1283 - (1040 + 243)))) then
				v96 = true;
				if (((14045 - 9339) >= (2810 - (559 + 1288))) and (v89:CastTime() > (1931 - (609 + 1322))) and v12:IsMoving()) then
					if (((v89 == v15.Mage.Frost.Blizzard) and v12:BuffUp(v15.Mage.Frost.FreezingRain)) or ((1414 - (13 + 441)) <= (3273 - 2397))) then
						v96 = true;
					else
						return false;
					end
				end
				v95 = 2 - 1;
			end
		end
	end, 318 - 254);
	local v41;
	v41 = v9.AddCoreOverride("Spell.CooldownRemains", function(v98, v99, v100)
		if (((v98 == v15.Mage.Frost.Blizzard) and v12:IsCasting(v98)) or ((77 + 1989) == (3384 - 2452))) then
			return 3 + 5;
		elseif (((2115 + 2710) < (14371 - 9528)) and (v98 == v15.Mage.Frost.Ebonbolt) and v12:IsCasting(v98)) then
			return 25 + 20;
		else
			return v41(v98, v99, v100);
		end
	end, 117 - 53);
	local v42;
	v42 = v9.AddCoreOverride("Player.BuffStackP", function(v101, v102, v103, v104)
		local v105 = 0 + 0;
		local v106;
		while true do
			if ((v105 == (0 + 0)) or ((2786 + 1091) >= (3810 + 727))) then
				v106 = v12:BuffStack(v102);
				if ((v102 == v102.Mage.Frost.IciclesBuff) or ((4222 + 93) < (2159 - (153 + 280)))) then
					return (v101:IsCasting(v102.Mage.Frost.GlacialSpike) and (0 - 0)) or math.min(v106 + ((v101:IsCasting(v102.Mage.Frost.Frostbolt) and (1 + 0)) or (0 + 0)), 3 + 2);
				elseif ((v102 == v102.Mage.Frost.GlacialSpikeBuff) or ((3339 + 340) < (453 + 172))) then
					return (v101:IsCasting(v102.Mage.Frost.GlacialSpike) and (0 - 0)) or v106;
				elseif ((v102 == v102.Mage.Frost.WintersReachBuff) or ((2859 + 1766) < (1299 - (89 + 578)))) then
					return (v101:IsCasting(v102.Mage.Frost.Flurry) and (0 + 0)) or v106;
				elseif ((v102 == v102.Mage.Frost.FingersofFrostBuff) or ((171 - 88) > (2829 - (572 + 477)))) then
					if (((74 + 472) <= (647 + 430)) and v102.Mage.Frost.IceLance:InFlight()) then
						if ((v106 == (0 + 0)) or ((1082 - (84 + 2)) > (7088 - 2787))) then
							return 0 + 0;
						else
							return v106 - (843 - (497 + 345));
						end
					else
						return v106;
					end
				else
					return v106;
				end
				break;
			end
		end
	end, 2 + 62);
	local v43;
	v43 = v9.AddCoreOverride("Player.BuffUpP", function(v107, v108, v109, v110)
		local v111 = 0 + 0;
		local v112;
		while true do
			if (((5403 - (605 + 728)) > (491 + 196)) and (v111 == (0 - 0))) then
				v112 = v12:BuffUp(v108);
				if ((v108 == v108.Mage.Frost.FingersofFrostBuff) or ((31 + 625) >= (12311 - 8981))) then
					if (v108.Mage.Frost.IceLance:InFlight() or ((2247 + 245) <= (927 - 592))) then
						return v12:BuffStack(v108) >= (1 + 0);
					else
						return v112;
					end
				else
					return v112;
				end
				break;
			end
		end
	end, 553 - (457 + 32));
	local v44;
	v44 = v9.AddCoreOverride("Player.BuffDownP", function(v113, v114, v115, v116)
		local v117 = 0 + 0;
		local v118;
		while true do
			if (((5724 - (832 + 570)) >= (2414 + 148)) and (v117 == (0 + 0))) then
				v118 = v12:BuffDown(v114);
				if ((v114 == v114.Mage.Frost.FingersofFrostBuff) or ((12870 - 9233) >= (1817 + 1953))) then
					if (v114.Mage.Frost.IceLance:InFlight() or ((3175 - (588 + 208)) > (12338 - 7760))) then
						return v12:BuffStack(v114) == (1800 - (884 + 916));
					else
						return v118;
					end
				else
					return v118;
				end
				break;
			end
		end
	end, 133 - 69);
	local v45;
	v45 = v9.AddCoreOverride("Target.DebuffStack", function(v119, v120, v121, v122)
		local v123 = v45(v119, v120, v121, v122);
		if ((v120 == v120.Mage.Frost.WintersChillDebuff) or ((281 + 202) > (1396 - (232 + 421)))) then
			if (((4343 - (1569 + 320)) > (142 + 436)) and v120.Mage.Frost.Flurry:InFlight()) then
				return 1 + 1;
			elseif (((3133 - 2203) < (5063 - (316 + 289))) and v120.Mage.Frost.IceLance:InFlight()) then
				if (((1732 - 1070) <= (45 + 927)) and (v123 == (1453 - (666 + 787)))) then
					return 425 - (360 + 65);
				else
					return v123 - (1 + 0);
				end
			else
				return v123;
			end
		else
			return v123;
		end
	end, 318 - (79 + 175));
	local v46;
	v46 = v9.AddCoreOverride("Target.DebuffRemains", function(v124, v125, v126, v127)
		local v128 = 0 - 0;
		local v129;
		while true do
			if (((3411 + 959) == (13395 - 9025)) and (v128 == (0 - 0))) then
				v129 = v46(v124, v125, v126, v127);
				if ((v125 == v125.Mage.Frost.WintersChillDebuff) or ((5661 - (503 + 396)) <= (1042 - (92 + 89)))) then
					return (v125.Mage.Frost.Flurry:InFlight() and (10 - 4)) or v129;
				else
					return v129;
				end
				break;
			end
		end
	end, 33 + 31);
	local v47;
	v47 = v9.AddCoreOverride("Player.AffectingCombat", function(v130)
		return v15.Mage.Frost.Frostbolt:InFlight() or v47(v130);
	end, 38 + 26);
end;
return v0["Epix_Mage_Mage.lua"]();

