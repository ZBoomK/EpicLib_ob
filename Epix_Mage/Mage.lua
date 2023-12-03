local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((569 - (159 + 310)) <= (8198 - 5075)) and not v5) then
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
	if (not v15.Mage or ((2304 - (39 + 896)) > (10479 - 5492))) then
		v15.Mage = {};
	end
	v15.Mage.Commons = {AncestralCall=v15(436179 - 161441, nil, 2 - 1),BagofTricks=v15(167757 + 144654, nil, 2 + 0),Berserking=v15(26693 - (115 + 281), nil, 6 - 3),BloodFury=v15(17033 + 3539, nil, 9 - 5),Fireblood=v15(972512 - 707291, nil, 872 - (550 + 317)),LightsJudgment=v15(369353 - 113706, nil, 8 - 2),ArcaneExplosion=v15(4049 - 2600, nil, 292 - (134 + 151)),ArcaneIntellect=v15(3124 - (970 + 695), nil, 15 - 7),Blink=v16(1999 - (582 + 1408), 6773 - 4820, 267564 - 54911),Frostbolt=v15(437 - 321, nil, 1834 - (1195 + 629)),FrostNova=v15(160 - 38, nil, 252 - (187 + 54)),Polymorph=v15(898 - (162 + 618), nil, 9 + 3),SlowFall=v15(87 + 43, nil, 27 - 14),TimeWarp=v15(135088 - 54735, nil, 2 + 12),AlterTime=v15(343881 - (1373 + 263), nil, 1015 - (451 + 549)),BlastWave=v15(49869 + 108112, nil, 24 - 8),Counterspell=v15(3594 - 1455, nil, 1401 - (746 + 638)),DragonsBreath=v15(11916 + 19745, nil, 27 - 9),FocusMagic=v15(321699 - (218 + 123), nil, 1600 - (1535 + 46)),GreaterInvisibility=v15(110249 + 710, nil, 9 + 47),IceBlock=v15(45998 - (306 + 254), nil, 2 + 18),IceColdAbility=v15(813783 - 399125, nil, 1627 - (899 + 568)),IceColdTalent=v15(272556 + 142103, nil, 389 - 228),IceFloes=v15(109442 - (268 + 335), nil, 311 - (60 + 230)),IceNova=v15(158569 - (426 + 146), nil, 3 + 19),Invisibility=v15(1522 - (282 + 1174), nil, 834 - (569 + 242)),MassBarrier=v15(1194467 - 779807, nil, 2 + 22),Meteor=v15(154585 - (706 + 318), nil, 1276 - (721 + 530)),MirrorImage=v15(56613 - (945 + 326), nil, 64 - 38),RemoveCurse=v15(423 + 52, nil, 727 - (271 + 429)),RingOfFrost=v15(104468 + 9256, nil, 1528 - (1408 + 92)),RuneofPower=v15(117097 - (461 + 625), nil, 1317 - (993 + 295)),ShiftingPower=v15(19859 + 362581, nil, 1201 - (418 + 753)),Spellsteal=v15(11597 + 18852, nil, 4 + 27),TemporalWarp=v15(113057 + 273482, nil, 9 + 23),ArcaneIntellectBuff=v15(1988 - (406 + 123), nil, 1802 - (1749 + 20)),BerserkingBuff=v15(6247 + 20050, nil, 1356 - (1249 + 73)),BloodFuryBuff=v15(7340 + 13232, nil, 1180 - (466 + 679)),RuneofPowerBuff=v15(279068 - 163054, nil, 102 - 66),TemporalWarpBuff=v15(388440 - (106 + 1794), nil, 12 + 25),Pool=v15(252757 + 747153, nil, 590 - 390)};
	v15.Mage.Arcane = v18(v15.Mage.Commons, {ArcaneBlast=v15(82459 - 52008, nil, 152 - (4 + 110)),FireBlast=v15(320420 - (57 + 527), nil, 1466 - (41 + 1386)),Amplification=v15(236731 - (17 + 86), nil, 28 + 12),ArcaneBarrage=v15(99072 - 54647, nil, 118 - 77),ArcaneBombardment=v15(384747 - (122 + 44), nil, 71 - 29),ArcaneEcho=v15(1135341 - 793110, nil, 35 + 8),ArcaneFamiliar=v15(29651 + 175371, nil, 88 - 44),ArcaneHarmony=v15(384517 - (30 + 35), nil, 31 + 14),ArcaneMissiles=v15(6400 - (1043 + 214), nil, 173 - 127),ArcaneOrb=v15(154838 - (323 + 889), nil, 126 - 79),ArcanePower=v15(322319 - (361 + 219), nil, 368 - (53 + 267)),ArcaneSurge=v15(82540 + 282810, nil, 462 - (15 + 398)),CascadingPower=v15(385258 - (18 + 964), nil, 188 - 138),ChargedOrb=v15(222699 + 161952, nil, 33 + 18),ConjureManaGem=v15(1609 - (20 + 830), nil, 41 + 11),Concentration=v15(384500 - (116 + 10), nil, 4 + 49),Enlightened=v15(322125 - (542 + 196), nil, 115 - 61),Evocation=v15(3520 + 8531, nil, 28 + 27),NetherTempest=v15(41369 + 73554, nil, 150 - 93),NetherPrecision=v15(983936 - 600154, nil, 1609 - (1126 + 425)),OrbBarrage=v15(385263 - (118 + 287), nil, 231 - 172),Overpowered=v15(156268 - (118 + 1003), nil, 175 - 115),PresenceofMind=v15(205402 - (142 + 235), nil, 276 - 215),PrismaticBarrier=v15(51232 + 184218, nil, 1039 - (553 + 424)),RadiantSpark=v15(711194 - 335091, nil, 56 + 7),Resonance=v15(203384 + 1644, nil, 38 + 26),RuleofThrees=v15(112375 + 151979, nil, 38 + 27),SiphonStorm=v15(832876 - 448689, nil, 183 - 117),Slipstream=v15(529437 - 292980, nil, 20 + 47),Supernova=v15(763463 - 605483, nil, 821 - (239 + 514)),TimeAnomaly=v15(134599 + 248644, nil, 1398 - (797 + 532)),TouchoftheMagi=v15(233612 + 87895, nil, 24 + 46),ArcaneArtilleryBuff=v15(997710 - 573379, nil, 1354 - (373 + 829)),ArcaneFamiliarBuff=v15(210857 - (476 + 255), nil, 1201 - (369 + 761)),ArcaneHarmonyBuff=v15(222397 + 162058, nil, 130 - 58),ArcaneOverloadBuff=v15(775098 - 366076, nil, 311 - (64 + 174)),ArcaneSurgeBuff=v15(52037 + 313325, nil, 108 - 34),ClearcastingBuff=v15(264061 - (144 + 192), nil, 291 - (42 + 174)),ConcentrationBuff=v15(288759 + 95620, nil, 63 + 13),NetherPrecisionBuff=v15(163048 + 220735, nil, 1581 - (363 + 1141)),PresenceofMindBuff=v15(206605 - (1183 + 397), nil, 237 - 159),RuleofThreesBuff=v15(194092 + 70682, nil, 60 + 19),SiphonStormBuff=v15(386242 - (1913 + 62), nil, 51 + 29),NetherTempestDebuff=v15(304235 - 189312, nil, 2014 - (565 + 1368)),RadiantSparkDebuff=v15(1414423 - 1038320, nil, 1743 - (1477 + 184)),RadiantSparkVulnerability=v15(512472 - 136368, nil, 78 + 5),TouchoftheMagiDebuff=v15(211680 - (564 + 292), nil, 144 - 60)});
	v15.Mage.Fire = v18(v15.Mage.Commons, {Fireball=v15(400 - 267, nil, 389 - (244 + 60)),Flamestrike=v15(1631 + 489, nil, 562 - (41 + 435)),AlexstraszasFury=v15(236871 - (938 + 63), nil, 67 + 20),BlazingBarrier=v15(236438 - (936 + 189), nil, 29 + 59),Combustion=v15(191932 - (1565 + 48), nil, 55 + 34),FeeltheBurn=v15(384529 - (782 + 356), nil, 357 - (176 + 91)),FireBlast=v16(236 - 145, 160428 - 51575, 232659 - (975 + 117), 321711 - (157 + 1718)),Firestarter=v15(166390 + 38636, nil, 326 - 234),FlameOn=v15(700955 - 495926, nil, 1111 - (697 + 321)),FlamePatch=v15(558546 - 353509, nil, 199 - 105),FromTheAshes=v15(789233 - 446889, nil, 37 + 58),FueltheFire=v15(779616 - 363522, nil, 412 - 258),Hyperthermia=v15(385087 - (322 + 905), nil, 707 - (602 + 9)),ImprovedScorch=v15(384793 - (449 + 740), nil, 969 - (826 + 46)),Kindling=v15(156095 - (245 + 702), nil, 309 - 211),LivingBomb=v15(14292 + 30165, nil, 1997 - (260 + 1638)),PhoenixFlames=v15(257981 - (382 + 58), nil, 320 - 220),Pyroblast=v15(9445 + 1921, nil, 208 - 107),Scorch=v15(8763 - 5815, nil, 1307 - (902 + 303)),SearingTouch=v15(592041 - 322397, nil, 247 - 144),SunKingsBlessing=v15(32988 + 350898, nil, 1794 - (1121 + 569)),TemperedFlames=v15(383873 - (22 + 192), nil, 788 - (483 + 200)),CombustionBuff=v15(191782 - (1404 + 59), nil, 290 - 184),FeeltheBurnBuff=v15(515293 - 131898, nil, 872 - (468 + 297)),FlameAccelerantBuff=v15(203839 - (334 + 228), nil, 364 - 256),FlamesFuryBuff=v15(950259 - 540295, nil, 197 - 88),HeatingUpBuff=v15(13661 + 34446, nil, 346 - (141 + 95)),HotStreakBuff=v15(47257 + 851, nil, 285 - 174),HyperthermiaBuff=v15(922799 - 538925, nil, 27 + 85),SunKingsBlessingBuff=v15(1051790 - 667908, nil, 80 + 33),FuryoftheSunKingBuff=v15(199898 + 183985, nil, 159 - 45),CharringEmbersDebuff=v15(241055 + 167610, nil, 278 - (92 + 71)),IgniteDebuff=v15(6251 + 6403, nil, 194 - 78),ImprovedScorchDebuff=v15(384373 - (574 + 191), nil, 97 + 20)});
	v15.Mage.Frost = v18(v15.Mage.Commons, {ConeofCold=v15(300 - 180, nil, 61 + 57),IciclesBuff=v15(206322 - (254 + 595), nil, 245 - (55 + 71)),WintersChillDebuff=v15(300837 - 72479, nil, 1910 - (573 + 1217)),FireBlast=v15(885760 - 565924, nil, 10 + 111),Blizzard=v15(306738 - 116382, nil, 1061 - (714 + 225)),BoneChilling=v15(601330 - 395564, nil, 170 - 47),ChainReaction=v15(30131 + 248178, nil, 179 - 55),ColdestSnap=v15(418299 - (118 + 688), nil, 173 - (25 + 23)),CometStorm=v15(29750 + 123845, nil, 2012 - (927 + 959)),Ebonbolt=v15(868130 - 610593, nil, 859 - (16 + 716)),Flurry=v15(86122 - 41508, nil, 225 - (11 + 86)),FreezingRain=v15(659144 - 388911, nil, 414 - (175 + 110)),FreezingWinds=v15(964731 - 582628, nil, 641 - 511),Frostbite=v15(199917 - (503 + 1293), nil, 365 - 234),FrozenOrb=v16(96 + 36, 85775 - (810 + 251), 137511 + 60638),GlacialSpike=v15(61315 + 138471, nil, 120 + 13),IceBarrier=v15(11959 - (43 + 490), nil, 867 - (711 + 22)),IceCaller=v15(915457 - 678795, nil, 994 - (240 + 619)),IceLance=v15(7350 + 23105, nil, 215 - 79),IcyVeins=v15(826 + 11646, nil, 1881 - (1344 + 400)),RayofFrost=v15(205426 - (255 + 150), nil, 109 + 29),SlickIce=v15(204591 + 177553, nil, 593 - 454),Snowstorm=v15(1232880 - 851174, nil, 1879 - (404 + 1335)),SplinteringCold=v15(379455 - (183 + 223), nil, 171 - 30),SplittingIce=v15(37355 + 19022, nil, 51 + 90),SummonWaterElemental=v15(32024 - (10 + 327), nil, 99 + 43),Freeze=v15(33733 - (118 + 220), nil, 48 + 95),WaterJet=v15(135478 - (108 + 341), nil, 65 + 79),BrainFreezeBuff=v15(805168 - 614722, nil, 1638 - (711 + 782)),FingersofFrostBuff=v15(85391 - 40847, nil, 615 - (270 + 199)),FreezingRainBuff=v15(87606 + 182626, nil, 1966 - (580 + 1239)),FreezingWindsBuff=v15(1135919 - 753813, nil, 142 + 6),GlacialSpikeBuff=v15(7180 + 192664, nil, 65 + 84),IcyVeinsBuff=v15(32563 - 20091, nil, 94 + 56),SnowstormBuff=v15(382689 - (645 + 522), nil, 1941 - (1010 + 780)),FrostbiteDebuff=v15(378573 + 187, nil, 728 - 575)});
	if (not v17.Mage or ((2528 - 1665) >= (6420 - (1045 + 791)))) then
		v17.Mage = {};
	end
	v17.Mage.Commons = {Healthstone=v17(13952 - 8440),RefreshingHealingPotion=v17(292227 - 100847),DreamwalkersHealingPotion=v17(207528 - (351 + 154))};
	v17.Mage.Arcane = v18(v17.Mage.Commons, {ManaGem=v17(38373 - (1281 + 293))});
	v17.Mage.Fire = v18(v17.Mage.Commons, {});
	v17.Mage.Frost = v18(v17.Mage.Commons, {});
	if (not v20.Mage or ((990 - (28 + 238)) >= (3726 - 2058))) then
		v20.Mage = {};
	end
	v20.Mage.Commons = {Healthstone=v20(1568 - (1381 + 178)),RefreshingHealingPotion=v20(10 + 0),CounterspellMouseover=v20(9 + 2),PolymorphMouseover=v20(6 + 6),RemoveCurseMouseover=v20(44 - 31),RemoveCurseFocus=v20(8 + 6),StopCasting=v20(485 - (381 + 89))};
	v20.Mage.Arcane = v18(v20.Mage.Commons, {ManaGem=v20(15 + 1),CancelPOM=v20(12 + 5)});
	v20.Mage.Fire = v18(v20.Mage.Commons, {FlamestrikeCursor=v20(30 - 12),MeteorCursor=v20(1175 - (1074 + 82)),FireBlastMacro=v20(50 - 27)});
	v20.Mage.Frost = v18(v20.Mage.Commons, {BlizzardCursor=v20(1804 - (214 + 1570)),IceLanceMouseover=v20(1476 - (990 + 465)),FreezePet=v20(10 + 12),FrozenOrbCast=v20(11 + 13)});
	local v35 = v15.Mage.Frost.RuneofPower:BaseDuration();
	local v36;
	v36 = v9.AddCoreOverride("Player.AffectingCombat", function(v48)
		return v15.Mage.Arcane.ArcaneBlast:InFlight() or v36(v48);
	end, 61 + 1);
	v9.AddCoreOverride("Spell.IsCastable", function(v49, v50, v51, v52, v53, v54)
		local v55 = 0 - 0;
		local v56;
		local v57;
		while true do
			if (((2154 - (1668 + 58)) < (2430 - (512 + 114))) and (v55 == (5 - 3))) then
				if ((v49 == v15.Mage.Arcane.PresenceofMind) or ((6873 - 3548) > (16051 - 11438))) then
					return v57 and v12:BuffDown(v15.Mage.Arcane.PresenceofMind);
				elseif ((v49 == v15.Mage.Arcane.RadiantSpark) or ((2303 + 2647) <= (853 + 3700))) then
					return v57 and not v12:IsCasting(v49);
				elseif (((2317 + 348) <= (13265 - 9332)) and (v49 == v15.Mage.Arcane.ShiftingPower)) then
					return v57 and not v12:IsCasting(v49);
				elseif (((5267 - (109 + 1885)) == (4742 - (1269 + 200))) and (v49 == v15.Mage.Arcane.TouchoftheMagi)) then
					return v57 and not v12:IsCasting(v49);
				elseif (((7329 - 3505) > (1224 - (98 + 717))) and (v49 == v15.Mage.Arcane.ConjureManaGem)) then
					local v138 = 826 - (802 + 24);
					local v139;
					local v140;
					while true do
						if (((3598 - 1511) == (2635 - 548)) and (v138 == (1 + 0))) then
							return v57 and not v12:IsCasting(v49) and not (v139:IsReady() or (v140 > (0 + 0)));
						end
						if ((v138 == (0 + 0)) or ((735 + 2669) > (12527 - 8024))) then
							v139 = v17.Mage.Arcane.ManaGem;
							v140 = v139:CooldownRemains();
							v138 = 3 - 2;
						end
					end
				elseif ((v49 == v15.Mage.Arcane.ArcaneSurge) or ((1254 + 2252) <= (533 + 776))) then
					return v49:IsLearned() and v49:CooldownUp() and v56;
				else
					return v57;
				end
				break;
			end
			if (((2438 + 517) == (2149 + 806)) and (v55 == (1 + 0))) then
				if (v51 or ((4336 - (797 + 636)) == (7258 - 5763))) then
					local v136 = 1619 - (1427 + 192);
					local v137;
					while true do
						if (((1576 + 2970) >= (5282 - 3007)) and (v136 == (0 + 0))) then
							v137 = v53 or v13;
							v56 = v137:IsInRange(v51, v52);
							break;
						end
					end
				end
				v57 = v49:IsLearned() and (v49:CooldownRemains(v50, v54 or "Auto") == (0 + 0)) and v56 and (v12:Mana() >= v49:Cost());
				v55 = 328 - (192 + 134);
			end
			if (((2095 - (316 + 960)) >= (13 + 9)) and (v55 == (0 + 0))) then
				if (((2923 + 239) == (12088 - 8926)) and (v49:CastTime() > (551 - (83 + 468))) and v12:IsMoving()) then
					return false;
				end
				v56 = true;
				v55 = 1807 - (1202 + 604);
			end
		end
	end, 289 - 227);
	local v37;
	v37 = v9.AddCoreOverride("Player.BuffStack", function(v58, v59, v60, v61)
		local v62 = 0 - 0;
		local v63;
		while true do
			if ((v62 == (0 - 0)) or ((2694 - (45 + 280)) > (4275 + 154))) then
				v63 = v37(v58, v59, v60, v61);
				if (((3578 + 517) >= (1163 + 2020)) and (v59 == v59.Mage.Fire.PyroclasmBuff) and v58:IsCasting(v59.Mage.Fire.Pyroblast)) then
					return 0 + 0;
				else
					return v63;
				end
				break;
			end
		end
	end, 12 + 51);
	local v38;
	v38 = v9.AddCoreOverride("Player.BuffRemains", function(v64, v65, v66, v67)
		local v68 = v38(v64, v65, v66, v67);
		if (((v65 == v65.Mage.Fire.PyroclasmBuff) and v64:IsCasting(v65.Mage.Fire.Pyroblast)) or ((6871 - 3160) < (2919 - (340 + 1571)))) then
			return 0 + 0;
		end
		return v68;
	end, 1835 - (1733 + 39));
	v9.AddCoreOverride("Spell.IsReady", function(v69, v70, v71, v72, v73, v74)
		local v75 = 0 - 0;
		local v76;
		local v77;
		while true do
			if ((v75 == (1035 - (125 + 909))) or ((2997 - (1096 + 852)) <= (407 + 499))) then
				if (((6444 - 1931) > (2645 + 81)) and (v69:CastTime() > (512 - (409 + 103))) and v12:IsMoving()) then
					if ((v69 == v15.Mage.Fire.Scorch) or ((v69 == v15.Mage.Fire.Pyroblast) and v12:BuffUp(v15.Mage.Fire.HotStreakBuff)) or ((v69 == v15.Mage.Fire.Flamestrike) and v12:BuffUp(v15.Mage.Fire.HotStreakBuff)) or ((1717 - (46 + 190)) >= (2753 - (51 + 44)))) then
						v77 = true;
					else
						return false;
					end
				else
					return v76;
				end
				break;
			end
			if (((0 + 0) == v75) or ((4537 - (1114 + 203)) == (2090 - (228 + 498)))) then
				v76 = v69:IsCastable() and v69:IsUsableP();
				v77 = true;
				v75 = 1 + 0;
			end
		end
	end, 35 + 28);
	v9.AddCoreOverride("Spell.IsCastable", function(v78, v79, v80, v81, v82, v83)
		if (((v78:CastTime() > (663 - (174 + 489))) and v12:IsMoving()) or ((2745 - 1691) > (5297 - (830 + 1075)))) then
			return false;
		end
		local v84 = true;
		if (v80 or ((1200 - (303 + 221)) >= (2911 - (231 + 1038)))) then
			local v131 = 0 + 0;
			local v132;
			while true do
				if (((5298 - (171 + 991)) > (9878 - 7481)) and (v131 == (0 - 0))) then
					v132 = v82 or v13;
					v84 = v132:IsInRange(v80, v81);
					break;
				end
			end
		end
		local v85 = v78:IsLearned() and (v78:CooldownRemains(v79, v83 or "Auto") == (0 - 0)) and v84;
		if ((v78 == v15.Mage.Fire.RadiantSpark) or ((3469 + 865) == (14880 - 10635))) then
			return v85 and not v12:IsCasting(v78);
		elseif ((v78 == v15.Mage.Fire.ShiftingPower) or ((12335 - 8059) <= (4885 - 1854))) then
			return v85 and not v12:IsCasting(v78);
		else
			return v85;
		end
	end, 194 - 131);
	local v39;
	v39 = v9.AddCoreOverride("Player.AffectingCombat", function(v86)
		return v39(v86) or v12:IsCasting(v15.Mage.Fire.Pyroblast) or v12:IsCasting(v15.Mage.Fire.Fireball);
	end, 1311 - (111 + 1137));
	v9.AddCoreOverride("Spell.InFlightRemains", function(v87)
		return v87:TravelTime() - v87:TimeSinceLastCast();
	end, 221 - (91 + 67));
	local v40;
	v40 = v9.AddCoreOverride("Spell.IsCastable", function(v88, v89, v90, v91, v92, v93)
		local v94 = true;
		if (((v88:CastTime() > (0 - 0)) and v12:IsMoving()) or ((1194 + 3588) <= (1722 - (423 + 100)))) then
			if (((v88 == v15.Mage.Frost.Blizzard) and v12:BuffUp(v15.Mage.Frost.FreezingRain)) or ((35 + 4829) < (5266 - 3364))) then
				v94 = true;
			else
				return false;
			end
		end
		local v95 = true;
		if (((2523 + 2316) >= (4471 - (326 + 445))) and v90) then
			local v133 = 0 - 0;
			local v134;
			while true do
				if ((v133 == (0 - 0)) or ((2508 - 1433) > (2629 - (530 + 181)))) then
					v134 = v92 or v13;
					v95 = v134:IsInRange(v90, v91);
					break;
				end
			end
		end
		if (((1277 - (614 + 267)) <= (3836 - (19 + 13))) and (v88 == v15.Mage.Frost.GlacialSpike)) then
			return v88:IsLearned() and v95 and v94 and not v12:IsCasting(v88) and (v12:BuffUp(v15.Mage.Frost.GlacialSpikeBuff) or (v12:BuffStack(v15.Mage.Frost.IciclesBuff) == (7 - 2)));
		else
			local v135 = v40(v88, v89, v90, v91, v92, v93);
			if ((v88 == v15.Mage.Frost.SummonWaterElemental) or ((9714 - 5545) == (6247 - 4060))) then
				return v135 and not v14:IsActive();
			elseif (((366 + 1040) == (2472 - 1066)) and (v88 == v15.Mage.Frost.RuneofPower)) then
				return v135 and not v12:IsCasting(v88) and v12:BuffDown(v15.Mage.Frost.RuneofPowerBuff);
			elseif (((3174 - 1643) < (6083 - (1293 + 519))) and (v88 == v15.Mage.Frost.MirrorsofTorment)) then
				return v135 and not v12:IsCasting(v88);
			elseif (((1295 - 660) == (1657 - 1022)) and (v88 == v15.Mage.Frost.RadiantSpark)) then
				return v135 and not v12:IsCasting(v88);
			elseif (((6449 - 3076) <= (15333 - 11777)) and (v88 == v15.Mage.Frost.ShiftingPower)) then
				return v135 and not v12:IsCasting(v88);
			elseif ((v88 == v15.Mage.Frost.Deathborne) or ((7752 - 4461) < (1738 + 1542))) then
				return v135 and not v12:IsCasting(v88);
			else
				return v135;
			end
		end
	end, 14 + 50);
	local v41;
	v41 = v9.AddCoreOverride("Spell.CooldownRemains", function(v96, v97, v98)
		if (((10190 - 5804) >= (202 + 671)) and (v96 == v15.Mage.Frost.Blizzard) and v12:IsCasting(v96)) then
			return 3 + 5;
		elseif (((576 + 345) <= (2198 - (709 + 387))) and (v96 == v15.Mage.Frost.Ebonbolt) and v12:IsCasting(v96)) then
			return 1903 - (673 + 1185);
		else
			return v41(v96, v97, v98);
		end
	end, 185 - 121);
	local v42;
	v42 = v9.AddCoreOverride("Player.BuffStackP", function(v99, v100, v101, v102)
		local v103 = 0 - 0;
		local v104;
		while true do
			if (((7742 - 3036) >= (689 + 274)) and ((0 + 0) == v103)) then
				v104 = v12:BuffStack(v100);
				if ((v100 == v100.Mage.Frost.IciclesBuff) or ((1296 - 336) <= (216 + 660))) then
					return (v99:IsCasting(v100.Mage.Frost.GlacialSpike) and (0 - 0)) or math.min(v104 + ((v99:IsCasting(v100.Mage.Frost.Frostbolt) and (1 - 0)) or (1880 - (446 + 1434))), 1288 - (1040 + 243));
				elseif ((v100 == v100.Mage.Frost.GlacialSpikeBuff) or ((6166 - 4100) == (2779 - (559 + 1288)))) then
					return (v99:IsCasting(v100.Mage.Frost.GlacialSpike) and (1931 - (609 + 1322))) or v104;
				elseif (((5279 - (13 + 441)) < (18097 - 13254)) and (v100 == v100.Mage.Frost.WintersReachBuff)) then
					return (v99:IsCasting(v100.Mage.Frost.Flurry) and (0 - 0)) or v104;
				elseif ((v100 == v100.Mage.Frost.FingersofFrostBuff) or ((19309 - 15432) >= (169 + 4368))) then
					if (v100.Mage.Frost.IceLance:InFlight() or ((15671 - 11356) < (614 + 1112))) then
						if ((v104 == (0 + 0)) or ((10917 - 7238) < (343 + 282))) then
							return 0 - 0;
						else
							return v104 - (1 + 0);
						end
					else
						return v104;
					end
				else
					return v104;
				end
				break;
			end
		end
	end, 36 + 28);
	local v43;
	v43 = v9.AddCoreOverride("Player.BuffUpP", function(v105, v106, v107, v108)
		local v109 = 0 + 0;
		local v110;
		while true do
			if ((v109 == (0 + 0)) or ((4526 + 99) < (1065 - (153 + 280)))) then
				v110 = v12:BuffUp(v106);
				if ((v106 == v106.Mage.Frost.FingersofFrostBuff) or ((239 - 156) > (1599 + 181))) then
					if (((216 + 330) <= (564 + 513)) and v106.Mage.Frost.IceLance:InFlight()) then
						return v12:BuffStack(v106) >= (1 + 0);
					else
						return v110;
					end
				else
					return v110;
				end
				break;
			end
		end
	end, 47 + 17);
	local v44;
	v44 = v9.AddCoreOverride("Player.BuffDownP", function(v111, v112, v113, v114)
		local v115 = 0 - 0;
		local v116;
		while true do
			if (((0 + 0) == v115) or ((1663 - (89 + 578)) > (3073 + 1228))) then
				v116 = v12:BuffDown(v112);
				if (((8461 - 4391) > (1736 - (572 + 477))) and (v112 == v112.Mage.Frost.FingersofFrostBuff)) then
					if (v112.Mage.Frost.IceLance:InFlight() or ((89 + 567) >= (1999 + 1331))) then
						return v12:BuffStack(v112) == (0 + 0);
					else
						return v116;
					end
				else
					return v116;
				end
				break;
			end
		end
	end, 150 - (84 + 2));
	local v45;
	v45 = v9.AddCoreOverride("Target.DebuffStack", function(v117, v118, v119, v120)
		local v121 = v45(v117, v118, v119, v120);
		if ((v118 == v118.Mage.Frost.WintersChillDebuff) or ((4106 - 1614) <= (242 + 93))) then
			if (((5164 - (497 + 345)) >= (66 + 2496)) and v118.Mage.Frost.Flurry:InFlight()) then
				return 1 + 1;
			elseif (v118.Mage.Frost.IceLance:InFlight() or ((4970 - (605 + 728)) >= (2690 + 1080))) then
				if ((v121 == (0 - 0)) or ((110 + 2269) > (16925 - 12347))) then
					return 0 + 0;
				else
					return v121 - (2 - 1);
				end
			else
				return v121;
			end
		else
			return v121;
		end
	end, 49 + 15);
	local v46;
	v46 = v9.AddCoreOverride("Target.DebuffRemains", function(v122, v123, v124, v125)
		local v126 = v46(v122, v123, v124, v125);
		if ((v123 == v123.Mage.Frost.WintersChillDebuff) or ((972 - (457 + 32)) > (316 + 427))) then
			return (v123.Mage.Frost.Flurry:InFlight() and (1408 - (832 + 570))) or v126;
		else
			return v126;
		end
	end, 61 + 3);
	local v47;
	v47 = v9.AddCoreOverride("Player.AffectingCombat", function(v127)
		return v15.Mage.Frost.Frostbolt:InFlight() or v47(v127);
	end, 17 + 47);
end;
return v0["Epix_Mage_Mage.lua"]();

