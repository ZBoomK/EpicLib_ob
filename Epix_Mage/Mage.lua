local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2509 - (550 + 1391)) > (909 - 481)) and not v5) then
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
	if (((2027 - 693) <= (6397 - (599 + 1185))) and not v15.Mage) then
		v15.Mage = {};
	end
	v15.Mage.Commons = {AncestralCall=v15(110794 + 163944, nil, 1 + 0),BagofTricks=v15(312985 - (507 + 67), nil, 1751 - (1013 + 736)),Berserking=v15(21773 + 4524, nil, 7 - 4),BloodFury=v15(123578 - 89876, nil, 871 - (550 + 317)),Fireblood=v15(383186 - 117965, nil, 7 - 2),LightsJudgment=v15(714400 - 458753, nil, 291 - (134 + 151)),ArcaneExplosion=v15(3114 - (970 + 695), nil, 12 - 5),ArcaneIntellect=v15(3449 - (582 + 1408), nil, 27 - 19),Blink=v16(10 - 1, 7359 - 5406, 214477 - (1195 + 629)),Frostbolt=v15(152 - 36, nil, 251 - (187 + 54)),FrostNova=v15(902 - (162 + 618), nil, 8 + 3),Polymorph=v15(79 + 39, nil, 25 - 13),SlowFall=v15(218 - 88, nil, 2 + 11),TimeWarp=v15(81989 - (1373 + 263), nil, 1014 - (451 + 549)),AlterTime=v15(108034 + 234211, nil, 23 - 8),BlastWave=v15(265512 - 107531, nil, 1400 - (746 + 638)),Counterspell=v15(805 + 1334, nil, 25 - 8),DragonsBreath=v15(32002 - (218 + 123), nil, 1599 - (1535 + 46)),FocusMagic=v15(319302 + 2056, nil, 3 + 16),GreaterInvisibility=v15(111519 - (306 + 254), nil, 4 + 52),IceBlock=v15(89173 - 43735, nil, 1487 - (899 + 568)),IceColdAbility=v15(272555 + 142103, nil, 387 - 227),IceColdTalent=v15(415262 - (268 + 335), nil, 451 - (60 + 230)),IceFloes=v15(109411 - (426 + 146), nil, 3 + 18),IceNova=v15(159453 - (282 + 1174), nil, 833 - (569 + 242)),Invisibility=v15(190 - 124, nil, 2 + 21),MassBarrier=v15(415684 - (706 + 318), nil, 1275 - (721 + 530)),Meteor=v15(154832 - (945 + 326), nil, 62 - 37),MirrorImage=v15(49245 + 6097, nil, 726 - (271 + 429)),RemoveCurse=v15(437 + 38, nil, 1527 - (1408 + 92)),RingOfFrost=v15(114810 - (461 + 625), nil, 1316 - (993 + 295)),RuneofPower=v15(6024 + 109987, nil, 1200 - (418 + 753)),ShiftingPower=v15(145654 + 236786, nil, 4 + 26),Spellsteal=v15(8906 + 21543, nil, 8 + 23),TemporalWarp=v15(387068 - (406 + 123), nil, 1801 - (1749 + 20)),ArcaneIntellectBuff=v15(347 + 1112, nil, 1355 - (1249 + 73)),BerserkingBuff=v15(9382 + 16915, nil, 1179 - (466 + 679)),BloodFuryBuff=v15(49485 - 28913, nil, 100 - 65),RuneofPowerBuff=v15(117914 - (106 + 1794), nil, 12 + 24),TemporalWarpBuff=v15(97710 + 288830, nil, 109 - 72),Pool=v15(2707697 - 1707787, nil, 314 - (4 + 110))};
	v15.Mage.Arcane = v18(v15.Mage.Commons, {ArcaneBlast=v15(31035 - (57 + 527), nil, 1465 - (41 + 1386)),FireBlast=v15(319939 - (17 + 86), nil, 27 + 12),Amplification=v15(527707 - 291079, nil, 115 - 75),ArcaneBarrage=v15(44591 - (122 + 44), nil, 70 - 29),ArcaneBombardment=v15(1275836 - 891255, nil, 35 + 7),ArcaneEcho=v15(49495 + 292736, nil, 86 - 43),ArcaneFamiliar=v15(205087 - (30 + 35), nil, 31 + 13),ArcaneHarmony=v15(385709 - (1043 + 214), nil, 169 - 124),ArcaneMissiles=v15(6355 - (323 + 889), nil, 123 - 77),ArcaneOrb=v15(154206 - (361 + 219), nil, 367 - (53 + 267)),ArcanePower=v15(72688 + 249051, nil, 461 - (15 + 398)),ArcaneSurge=v15(366332 - (18 + 964), nil, 184 - 135),ArcingCleave=v15(134067 + 97497, nil, 98 + 57),CascadingPower=v15(385126 - (20 + 830), nil, 40 + 10),ChargedOrb=v15(384777 - (116 + 10), nil, 4 + 47),ConjureManaGem=v15(1497 - (542 + 196), nil, 110 - 58),Concentration=v15(112244 + 272130, nil, 27 + 26),Enlightened=v15(115689 + 205698, nil, 142 - 88),Evocation=v15(30896 - 18845, nil, 1606 - (1126 + 425)),NetherTempest=v15(115328 - (118 + 287), nil, 223 - 166),NetherPrecision=v15(384903 - (118 + 1003), nil, 169 - 111),OrbBarrage=v15(385235 - (142 + 235), nil, 267 - 208),Overpowered=v15(33759 + 121388, nil, 1037 - (553 + 424)),PresenceofMind=v15(387693 - 182668, nil, 54 + 7),PrismaticBarrier=v15(233562 + 1888, nil, 37 + 25),RadiantSpark=v15(159878 + 216225, nil, 36 + 27),Resonance=v15(444478 - 239450, nil, 178 - 114),RuleofThrees=v15(591899 - 327545, nil, 19 + 46),SiphonStorm=v15(1856644 - 1472457, nil, 819 - (239 + 514)),Slipstream=v15(83047 + 153410, nil, 1396 - (797 + 532)),Supernova=v15(114791 + 43189, nil, 23 + 45),TimeAnomaly=v15(901101 - 517858, nil, 1271 - (373 + 829)),TouchoftheMagi=v15(322238 - (476 + 255), nil, 1200 - (369 + 761)),ArcaneArtilleryBuff=v15(245464 + 178867, nil, 275 - 123),ArcaneFamiliarBuff=v15(398189 - 188063, nil, 309 - (64 + 174)),ArcaneHarmonyBuff=v15(54756 + 329699, nil, 106 - 34),ArcaneOverloadBuff=v15(409358 - (144 + 192), nil, 289 - (42 + 174)),ArcaneSurgeBuff=v15(274473 + 90889, nil, 62 + 12),ClearcastingBuff=v15(112042 + 151683, nil, 1579 - (363 + 1141)),ConcentrationBuff=v15(385959 - (1183 + 397), nil, 231 - 155),NetherPrecisionBuff=v15(281331 + 102452, nil, 58 + 19),PresenceofMindBuff=v15(207000 - (1913 + 62), nil, 50 + 28),RuleofThreesBuff=v15(700936 - 436162, nil, 2012 - (565 + 1368)),SiphonStormBuff=v15(1445126 - 1060859, nil, 1741 - (1477 + 184)),NetherTempestDebuff=v15(156591 - 41668, nil, 76 + 5),RadiantSparkDebuff=v15(376959 - (564 + 292), nil, 140 - 58),RadiantSparkVulnerability=v15(1133640 - 757536, nil, 387 - (244 + 60)),TouchoftheMagiDebuff=v15(162105 + 48719, nil, 560 - (41 + 435))});
	v15.Mage.Fire = v18(v15.Mage.Commons, {Fireball=v15(1134 - (938 + 63), nil, 66 + 19),Flamestrike=v15(3245 - (936 + 189), nil, 29 + 57),AlexstraszasFury=v15(237483 - (1565 + 48), nil, 54 + 33),BlazingBarrier=v15(236451 - (782 + 356), nil, 355 - (176 + 91)),Combustion=v15(495843 - 305524, nil, 130 - 41),FeeltheBurn=v15(384483 - (975 + 117), nil, 1965 - (157 + 1718)),FireBlast=v16(74 + 17, 386419 - 277566, 791684 - 560117, 320854 - (697 + 321)),Firestarter=v15(558516 - 353490, nil, 194 - 102),FlameOn=v15(472669 - 267640, nil, 37 + 56),FlamePatch=v15(384168 - 179131, nil, 251 - 157),FromTheAshes=v15(343571 - (322 + 905), nil, 706 - (602 + 9)),FueltheFire=v15(417283 - (449 + 740), nil, 1026 - (826 + 46)),Hyperthermia=v15(384807 - (245 + 702), nil, 303 - 207),ImprovedScorch=v15(123317 + 260287, nil, 1995 - (260 + 1638)),Kindling=v15(155588 - (382 + 58), nil, 314 - 216),LivingBomb=v15(36942 + 7515, nil, 204 - 105),PhoenixFlames=v15(765568 - 508027, nil, 1305 - (902 + 303)),Pyroblast=v15(24955 - 13589, nil, 243 - 142),Scorch=v15(254 + 2694, nil, 1792 - (1121 + 569)),SearingTouch=v15(269858 - (22 + 192), nil, 786 - (483 + 200)),SunKingsBlessing=v15(385349 - (1404 + 59), nil, 284 - 180),TemperedFlames=v15(515648 - 131989, nil, 870 - (468 + 297)),CombustionBuff=v15(190881 - (334 + 228), nil, 357 - 251),FeeltheBurnBuff=v15(888675 - 505280, nil, 193 - 86),FlameAccelerantBuff=v15(57724 + 145553, nil, 344 - (141 + 95)),FlamesFuryBuff=v15(402711 + 7253, nil, 280 - 171),HeatingUpBuff=v15(115644 - 67537, nil, 26 + 84),HotStreakBuff=v15(131810 - 83702, nil, 79 + 32),HyperthermiaBuff=v15(199893 + 183981, nil, 156 - 44),SunKingsBlessingBuff=v15(226436 + 157446, nil, 276 - (92 + 71)),FuryoftheSunKingBuff=v15(189617 + 194266, nil, 191 - 77),CharringEmbersDebuff=v15(409430 - (574 + 191), nil, 95 + 20),IgniteDebuff=v15(31702 - 19048, nil, 60 + 56),ImprovedScorchDebuff=v15(384457 - (254 + 595), nil, 243 - (55 + 71))});
	v15.Mage.Frost = v18(v15.Mage.Commons, {ConeofCold=v15(158 - 38, nil, 1908 - (573 + 1217)),IciclesBuff=v15(569041 - 363568, nil, 10 + 109),WintersChillDebuff=v15(367975 - 139617, nil, 1059 - (714 + 225)),FireBlast=v15(934689 - 614853, nil, 168 - 47),Blizzard=v15(20609 + 169747, nil, 176 - 54),BoneChilling=v15(206572 - (118 + 688), nil, 171 - (25 + 23)),ChainReaction=v15(53905 + 224404, nil, 2010 - (927 + 959)),ColdestSnap=v15(1407326 - 989833, nil, 857 - (16 + 716)),CometStorm=v15(296500 - 142905, nil, 223 - (11 + 86)),Ebonbolt=v15(628176 - 370639, nil, 412 - (175 + 110)),Flurry=v15(112641 - 68027, nil, 631 - 503),FreezingRain=v15(272029 - (503 + 1293), nil, 360 - 231),FreezingWinds=v15(276323 + 105780, nil, 1191 - (810 + 251)),Frostbite=v15(137492 + 60629, nil, 41 + 90),FrozenOrb=v16(119 + 13, 85247 - (43 + 490), 198882 - (711 + 22)),GlacialSpike=v15(772813 - 573027, nil, 992 - (240 + 619)),IceBarrier=v15(2758 + 8668, nil, 212 - 78),IceCaller=v15(15663 + 220999, nil, 1879 - (1344 + 400)),IceLance=v15(30860 - (255 + 150), nil, 108 + 28),IcyVeins=v15(6678 + 5794, nil, 585 - 448),RayofFrost=v15(662201 - 457180, nil, 1877 - (404 + 1335)),SlickIce=v15(382550 - (183 + 223), nil, 168 - 29),Snowstorm=v15(252914 + 128792, nil, 51 + 89),SplinteringCold=v15(379386 - (10 + 327), nil, 99 + 42),SplittingIce=v15(56715 - (118 + 220), nil, 47 + 94),SummonWaterElemental=v15(32136 - (108 + 341), nil, 64 + 78),Freeze=v15(141187 - 107792, nil, 1636 - (711 + 782)),WaterJet=v15(258854 - 123825, nil, 613 - (270 + 199)),BrainFreezeBuff=v15(61741 + 128705, nil, 1964 - (580 + 1239)),FingersofFrostBuff=v15(132419 - 87875, nil, 140 + 6),FreezingRainBuff=v15(9708 + 260524, nil, 65 + 82),FreezingWindsBuff=v15(997667 - 615561, nil, 92 + 56),GlacialSpikeBuff=v15(201011 - (645 + 522), nil, 1939 - (1010 + 780)),IcyVeinsBuff=v15(12466 + 6, nil, 714 - 564),SnowstormBuff=v15(1118033 - 736511, nil, 1987 - (1045 + 791)),FrostbiteDebuff=v15(958749 - 579989, nil, 233 - 80)});
	if (not v17.Mage or ((2370 - (351 + 154)) >= (3603 - (1281 + 293)))) then
		v17.Mage = {};
	end
	v17.Mage.Commons = {Dreambinder=v17(208882 - (28 + 238)),Iridal=v17(465487 - 257166),Healthstone=v17(7071 - (1381 + 178)),RefreshingHealingPotion=v17(179503 + 11877),DreamwalkersHealingPotion=v17(166931 + 40092)};
	v17.Mage.Arcane = v18(v17.Mage.Commons, {ManaGem=v17(15697 + 21102)});
	v17.Mage.Fire = v18(v17.Mage.Commons, {});
	v17.Mage.Frost = v18(v17.Mage.Commons, {});
	if (((17064 - 12114) >= (838 + 778)) and not v20.Mage) then
		v20.Mage = {};
	end
	v20.Mage.Commons = {Healthstone=v20(479 - (381 + 89)),RefreshingHealingPotion=v20(9 + 1),UseWeapon=v20(69 + 32),CounterspellMouseover=v20(18 - 7),PolymorphMouseover=v20(1168 - (1074 + 82)),RemoveCurseMouseover=v20(28 - 15),RemoveCurseFocus=v20(1798 - (214 + 1570)),StopCasting=v20(1470 - (990 + 465))};
	v20.Mage.Arcane = v18(v20.Mage.Commons, {ManaGem=v20(7 + 9),CancelPOM=v20(8 + 9)});
	v20.Mage.Fire = v18(v20.Mage.Commons, {FlamestrikeCursor=v20(18 + 0),MeteorCursor=v20(74 - 55),FireBlastMacro=v20(1749 - (1668 + 58))});
	v20.Mage.Frost = v18(v20.Mage.Commons, {BlizzardCursor=v20(646 - (512 + 114)),IceLanceMouseover=v20(54 - 33),FreezePet=v20(45 - 23),FrozenOrbCast=v20(83 - 59)});
	local v35 = v15.Mage.Frost.RuneofPower:BaseDuration();
	local v36;
	v36 = v9.AddCoreOverride("Player.AffectingCombat", function(v48)
		return v15.Mage.Arcane.ArcaneBlast:InFlight() or v36(v48);
	end, 29 + 33);
	v9.AddCoreOverride("Spell.IsCastable", function(v49, v50, v51, v52, v53, v54)
		local v55 = 0 + 0;
		local v56;
		local v57;
		while true do
			if (((1500 + 225) == (5818 - 4093)) and (v55 == (1996 - (109 + 1885)))) then
				if (((2928 - (1269 + 200)) <= (4757 - 2275)) and (v49 == v15.Mage.Arcane.PresenceofMind)) then
					return v57 and v12:BuffDown(v15.Mage.Arcane.PresenceofMind);
				elseif ((v49 == v15.Mage.Arcane.RadiantSpark) or ((3511 - (98 + 717)) >= (5358 - (802 + 24)))) then
					return v57 and not v12:IsCasting(v49);
				elseif (((1807 - 759) >= (65 - 13)) and (v49 == v15.Mage.Arcane.ShiftingPower)) then
					return v57 and not v12:IsCasting(v49);
				elseif (((437 + 2521) < (3460 + 1043)) and (v49 == v15.Mage.Arcane.TouchoftheMagi)) then
					return v57 and not v12:IsCasting(v49);
				elseif ((v49 == v15.Mage.Arcane.ConjureManaGem) or ((450 + 2285) == (283 + 1026))) then
					local v139 = v17.Mage.Arcane.ManaGem;
					local v140 = v139:CooldownRemains();
					return v57 and not v12:IsCasting(v49) and not (v139:IsReady() or (v140 > (0 - 0)));
				elseif ((v49 == v15.Mage.Arcane.ArcaneSurge) or ((13772 - 9642) <= (1057 + 1898))) then
					return v49:IsLearned() and v49:CooldownUp() and v56;
				else
					return v57;
				end
				break;
			end
			if ((v55 == (0 + 0)) or ((1621 + 343) <= (975 + 365))) then
				if (((1167 + 1332) == (3932 - (797 + 636))) and (v49:CastTime() > (0 - 0)) and v12:IsMoving()) then
					return false;
				end
				v56 = true;
				v55 = 1620 - (1427 + 192);
			end
			if ((v55 == (1 + 0)) or ((5235 - 2980) < (20 + 2))) then
				if (v51 or ((493 + 593) >= (1731 - (192 + 134)))) then
					local v133 = v53 or v13;
					v56 = v133:IsInRange(v51, v52);
				end
				v57 = v49:IsLearned() and (v49:CooldownRemains(v50, v54 or "Auto") == (1276 - (316 + 960))) and v56 and (v12:Mana() >= v49:Cost());
				v55 = 2 + 0;
			end
		end
	end, 48 + 14);
	local v37;
	v37 = v9.AddCoreOverride("Player.BuffStack", function(v58, v59, v60, v61)
		local v62 = 0 + 0;
		local v63;
		while true do
			if ((v62 == (0 - 0)) or ((2920 - (83 + 468)) == (2232 - (1202 + 604)))) then
				v63 = v37(v58, v59, v60, v61);
				if (((v59 == v59.Mage.Fire.PyroclasmBuff) and v58:IsCasting(v59.Mage.Fire.Pyroblast)) or ((14359 - 11283) > (5296 - 2113))) then
					return 0 - 0;
				else
					return v63;
				end
				break;
			end
		end
	end, 388 - (45 + 280));
	local v38;
	v38 = v9.AddCoreOverride("Player.BuffRemains", function(v64, v65, v66, v67)
		local v68 = v38(v64, v65, v66, v67);
		if (((1161 + 41) > (925 + 133)) and (v65 == v65.Mage.Fire.PyroclasmBuff) and v64:IsCasting(v65.Mage.Fire.Pyroblast)) then
			return 0 + 0;
		end
		return v68;
	end, 35 + 28);
	v9.AddCoreOverride("Spell.IsReady", function(v69, v70, v71, v72, v73, v74)
		local v75 = 0 + 0;
		local v76;
		local v77;
		while true do
			if (((6871 - 3160) > (5266 - (340 + 1571))) and (v75 == (0 + 0))) then
				v76 = v69:IsCastable() and v69:IsUsableP();
				v77 = true;
				v75 = 1773 - (1733 + 39);
			end
			if ((v75 == (2 - 1)) or ((1940 - (125 + 909)) >= (4177 - (1096 + 852)))) then
				if (((578 + 710) > (1786 - 535)) and (v69:CastTime() > (0 + 0)) and v12:IsMoving()) then
					if ((v69 == v15.Mage.Fire.Scorch) or ((v69 == v15.Mage.Fire.Pyroblast) and v12:BuffUp(v15.Mage.Fire.HotStreakBuff)) or ((v69 == v15.Mage.Fire.Flamestrike) and v12:BuffUp(v15.Mage.Fire.HotStreakBuff)) or ((5025 - (409 + 103)) < (3588 - (46 + 190)))) then
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
	end, 158 - (51 + 44));
	v9.AddCoreOverride("Spell.IsCastable", function(v78, v79, v80, v81, v82, v83)
		local v84 = 0 + 0;
		local v85;
		local v86;
		while true do
			if (((1318 - (1114 + 203)) == v84) or ((2791 - (228 + 498)) >= (693 + 2503))) then
				if (v80 or ((2418 + 1958) <= (2144 - (174 + 489)))) then
					local v134 = v82 or v13;
					v85 = v134:IsInRange(v80, v81);
				end
				v86 = v78:IsLearned() and (v78:CooldownRemains(v79, v83 or "Auto") == (0 - 0)) and v85;
				v84 = 1907 - (830 + 1075);
			end
			if ((v84 == (526 - (303 + 221))) or ((4661 - (231 + 1038)) >= (3951 + 790))) then
				if (((4487 - (171 + 991)) >= (8877 - 6723)) and (v78 == v15.Mage.Fire.RadiantSpark)) then
					return v86 and not v12:IsCasting(v78);
				elseif ((v78 == v15.Mage.Fire.ShiftingPower) or ((3477 - 2182) >= (8067 - 4834))) then
					return v86 and not v12:IsCasting(v78);
				else
					return v86;
				end
				break;
			end
			if (((3504 + 873) > (5755 - 4113)) and (v84 == (0 - 0))) then
				if (((7613 - 2890) > (4191 - 2835)) and (v78:CastTime() > (1248 - (111 + 1137))) and v12:IsMoving()) then
					return false;
				end
				v85 = true;
				v84 = 159 - (91 + 67);
			end
		end
	end, 187 - 124);
	local v39;
	v39 = v9.AddCoreOverride("Player.AffectingCombat", function(v87)
		return v39(v87) or v12:IsCasting(v15.Mage.Fire.Pyroblast) or v12:IsCasting(v15.Mage.Fire.Fireball);
	end, 16 + 47);
	v9.AddCoreOverride("Spell.InFlightRemains", function(v88)
		return v88:TravelTime() - v88:TimeSinceLastCast();
	end, 586 - (423 + 100));
	local v40;
	v40 = v9.AddCoreOverride("Spell.IsCastable", function(v89, v90, v91, v92, v93, v94)
		local v95 = 0 + 0;
		local v96;
		local v97;
		while true do
			if ((v95 == (2 - 1)) or ((2156 + 1980) <= (4204 - (326 + 445)))) then
				v97 = true;
				if (((18525 - 14280) <= (10316 - 5685)) and v91) then
					local v135 = 0 - 0;
					local v136;
					while true do
						if (((4987 - (530 + 181)) >= (4795 - (614 + 267))) and (v135 == (32 - (19 + 13)))) then
							v136 = v93 or v13;
							v97 = v136:IsInRange(v91, v92);
							break;
						end
					end
				end
				v95 = 2 - 0;
			end
			if (((461 - 263) <= (12469 - 8104)) and ((1 + 1) == v95)) then
				if (((8409 - 3627) > (9697 - 5021)) and (v89 == v15.Mage.Frost.GlacialSpike)) then
					return v89:IsLearned() and v97 and v96 and not v12:IsCasting(v89) and (v12:BuffUp(v15.Mage.Frost.GlacialSpikeBuff) or (v12:BuffStack(v15.Mage.Frost.IciclesBuff) == (1817 - (1293 + 519))));
				else
					local v137 = 0 - 0;
					local v138;
					while true do
						if (((12699 - 7835) > (4201 - 2004)) and (v137 == (0 - 0))) then
							v138 = v40(v89, v90, v91, v92, v93, v94);
							if ((v89 == v15.Mage.Frost.SummonWaterElemental) or ((8716 - 5016) == (1328 + 1179))) then
								return v138 and not v14:IsActive();
							elseif (((913 + 3561) >= (636 - 362)) and (v89 == v15.Mage.Frost.RuneofPower)) then
								return v138 and not v12:IsCasting(v89) and v12:BuffDown(v15.Mage.Frost.RuneofPowerBuff);
							elseif ((v89 == v15.Mage.Frost.MirrorsofTorment) or ((438 + 1456) <= (468 + 938))) then
								return v138 and not v12:IsCasting(v89);
							elseif (((983 + 589) >= (2627 - (709 + 387))) and (v89 == v15.Mage.Frost.RadiantSpark)) then
								return v138 and not v12:IsCasting(v89);
							elseif ((v89 == v15.Mage.Frost.ShiftingPower) or ((6545 - (673 + 1185)) < (13172 - 8630))) then
								return v138 and not v12:IsCasting(v89);
							elseif (((10567 - 7276) > (2742 - 1075)) and (v89 == v15.Mage.Frost.Deathborne)) then
								return v138 and not v12:IsCasting(v89);
							else
								return v138;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v95 == (0 + 0)) or ((653 + 220) == (2746 - 712))) then
				v96 = true;
				if (((v89:CastTime() > (0 + 0)) and v12:IsMoving()) or ((5614 - 2798) < (21 - 10))) then
					if (((5579 - (446 + 1434)) < (5989 - (1040 + 243))) and (v89 == v15.Mage.Frost.Blizzard) and v12:BuffUp(v15.Mage.Frost.FreezingRain)) then
						v96 = true;
					else
						return false;
					end
				end
				v95 = 2 - 1;
			end
		end
	end, 1911 - (559 + 1288));
	local v41;
	v41 = v9.AddCoreOverride("Spell.CooldownRemains", function(v98, v99, v100)
		if (((4577 - (609 + 1322)) >= (1330 - (13 + 441))) and (v98 == v15.Mage.Frost.Blizzard) and v12:IsCasting(v98)) then
			return 29 - 21;
		elseif (((1608 - 994) <= (15857 - 12673)) and (v98 == v15.Mage.Frost.Ebonbolt) and v12:IsCasting(v98)) then
			return 2 + 43;
		else
			return v41(v98, v99, v100);
		end
	end, 232 - 168);
	local v42;
	v42 = v9.AddCoreOverride("Player.BuffStackP", function(v101, v102, v103, v104)
		local v105 = v12:BuffStack(v102);
		if (((1111 + 2015) == (1370 + 1756)) and (v102 == v102.Mage.Frost.IciclesBuff)) then
			return (v101:IsCasting(v102.Mage.Frost.GlacialSpike) and (0 - 0)) or math.min(v105 + ((v101:IsCasting(v102.Mage.Frost.Frostbolt) and (1 + 0)) or (0 - 0)), 4 + 1);
		elseif ((v102 == v102.Mage.Frost.GlacialSpikeBuff) or ((1217 + 970) >= (3560 + 1394))) then
			return (v101:IsCasting(v102.Mage.Frost.GlacialSpike) and (0 + 0)) or v105;
		elseif ((v102 == v102.Mage.Frost.WintersReachBuff) or ((3794 + 83) == (4008 - (153 + 280)))) then
			return (v101:IsCasting(v102.Mage.Frost.Flurry) and (0 - 0)) or v105;
		elseif (((635 + 72) > (250 + 382)) and (v102 == v102.Mage.Frost.FingersofFrostBuff)) then
			if (v102.Mage.Frost.IceLance:InFlight() or ((286 + 260) >= (2436 + 248))) then
				if (((1062 + 403) <= (6548 - 2247)) and (v105 == (0 + 0))) then
					return 667 - (89 + 578);
				else
					return v105 - (1 + 0);
				end
			else
				return v105;
			end
		else
			return v105;
		end
	end, 132 - 68);
	local v43;
	v43 = v9.AddCoreOverride("Player.BuffUpP", function(v106, v107, v108, v109)
		local v110 = v12:BuffUp(v107);
		if (((2753 - (572 + 477)) > (193 + 1232)) and (v107 == v107.Mage.Frost.FingersofFrostBuff)) then
			if (v107.Mage.Frost.IceLance:InFlight() or ((413 + 274) == (506 + 3728))) then
				return v12:BuffStack(v107) >= (87 - (84 + 2));
			else
				return v110;
			end
		else
			return v110;
		end
	end, 104 - 40);
	local v44;
	v44 = v9.AddCoreOverride("Player.BuffDownP", function(v111, v112, v113, v114)
		local v115 = 0 + 0;
		local v116;
		while true do
			if ((v115 == (842 - (497 + 345))) or ((86 + 3244) < (242 + 1187))) then
				v116 = v12:BuffDown(v112);
				if (((2480 - (605 + 728)) >= (240 + 95)) and (v112 == v112.Mage.Frost.FingersofFrostBuff)) then
					if (((7636 - 4201) > (97 + 2000)) and v112.Mage.Frost.IceLance:InFlight()) then
						return v12:BuffStack(v112) == (0 - 0);
					else
						return v116;
					end
				else
					return v116;
				end
				break;
			end
		end
	end, 58 + 6);
	local v45;
	v45 = v9.AddCoreOverride("Target.DebuffStack", function(v117, v118, v119, v120)
		local v121 = 0 - 0;
		local v122;
		while true do
			if ((v121 == (0 + 0)) or ((4259 - (457 + 32)) >= (1715 + 2326))) then
				v122 = v45(v117, v118, v119, v120);
				if ((v118 == v118.Mage.Frost.WintersChillDebuff) or ((5193 - (832 + 570)) <= (1518 + 93))) then
					if (v118.Mage.Frost.Flurry:InFlight() or ((1194 + 3384) <= (7105 - 5097))) then
						return 1 + 1;
					elseif (((1921 - (588 + 208)) <= (5595 - 3519)) and v118.Mage.Frost.IceLance:InFlight()) then
						if ((v122 == (1800 - (884 + 916))) or ((1555 - 812) >= (2551 + 1848))) then
							return 653 - (232 + 421);
						else
							return v122 - (1890 - (1569 + 320));
						end
					else
						return v122;
					end
				else
					return v122;
				end
				break;
			end
		end
	end, 16 + 48);
	local v46;
	v46 = v9.AddCoreOverride("Target.DebuffRemains", function(v123, v124, v125, v126)
		local v127 = 0 + 0;
		local v128;
		while true do
			if (((3892 - 2737) < (2278 - (316 + 289))) and (v127 == (0 - 0))) then
				v128 = v46(v123, v124, v125, v126);
				if ((v124 == v124.Mage.Frost.WintersChillDebuff) or ((108 + 2216) <= (2031 - (666 + 787)))) then
					return (v124.Mage.Frost.Flurry:InFlight() and (431 - (360 + 65))) or v128;
				else
					return v128;
				end
				break;
			end
		end
	end, 60 + 4);
	local v47;
	v47 = v9.AddCoreOverride("Player.AffectingCombat", function(v129)
		return v15.Mage.Frost.Frostbolt:InFlight() or v47(v129);
	end, 318 - (79 + 175));
end;
return v0["Epix_Mage_Mage.lua"]();

