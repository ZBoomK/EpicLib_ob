local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((348 - 152) >= (368 + 2))) then
			return v6(...);
		end
		if ((v5 == (791 - (368 + 423))) or ((9955 - 6787) < (520 - (10 + 8)))) then
			v6 = v0[v4];
			if (((1688 - 1249) == (881 - (416 + 26))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
	end
end
v0["Epix_Warrior_Warrior.lua"] = function(...)
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
	if (not v16.Warrior or ((543 + 721) < (480 - 208))) then
		v16.Warrior = {};
	end
	v16.Warrior.Commons = {AncestralCall=v16(275176 - (145 + 293), nil, 431 - (44 + 386)),ArcaneTorrent=v16(52099 - (998 + 488), nil, 1 + 1),BagofTricks=v16(255809 + 56602, nil, 775 - (201 + 571)),Berserking=v16(27435 - (116 + 1022), nil, 16 - 12),BloodFury=v16(12076 + 8496, nil, 18 - 13),Fireblood=v16(941823 - 676602, nil, 865 - (814 + 45)),LightsJudgment=v16(629905 - 374258, nil, 1 + 6),WarStomp=v16(7261 + 13288, nil, 893 - (261 + 624)),BattleShout=v16(11858 - 5185, nil, 1089 - (1020 + 60)),Charge=v16(1523 - (630 + 793), nil, 33 - 23),Hamstring=v16(8120 - 6405, nil, 69 + 104),HeroicThrow=v16(198852 - 141097, nil, 1758 - (760 + 987)),IgnorePain=v16(192369 - (1789 + 124), nil, 838 - (745 + 21)),Pummel=v16(2254 + 4298, nil, 32 - 20),Slam=v16(5742 - 4278, nil, 1 + 12),VictoryRush=v16(27031 + 7397, nil, 1069 - (87 + 968)),DefensiveStance=v16(1700065 - 1313857, nil, 14 + 1),Avatar=v17(36 - 20, 108987 - (447 + 966), 1098209 - 697059),AvatarBuff=v17(1834 - (1703 + 114), 108275 - (376 + 325), 657402 - 256252),BerserkerRage=v16(56920 - 38421, nil, 6 + 12),BerserkersTorment=v16(859239 - 469116, nil, 33 - (9 + 5)),BitterImmunity=v16(384138 - (85 + 291), nil, 1285 - (243 + 1022)),BloodandThunder=v16(1462242 - 1077965, nil, 18 + 3),DoubleTime=v16(105007 - (1123 + 57), nil, 18 + 4),CrushingForce=v16(383018 - (163 + 91), nil, 1953 - (1869 + 61)),FrothingBerserker=v16(60225 + 155346, nil, 84 - 60),ImmovableObject=v16(605636 - 211329, nil, 4 + 21),Intervene=v16(4687 - 1276, nil, 139 + 8),IntimidatingShout=v16(6720 - (1329 + 145), nil, 997 - (140 + 831)),HeroicLeap=v16(8394 - (1409 + 441), nil, 745 - (15 + 703)),ImpendingVictory=v16(93625 + 108543, nil, 466 - (262 + 176)),OverwhelmingRage=v16(384488 - (345 + 1376), nil, 717 - (198 + 490)),RallyingCry=v16(430583 - 333121, nil, 71 - 41),RumblingEarth=v16(276545 - (696 + 510), nil, 64 - 33),Shockwave=v16(48230 - (1091 + 171), nil, 6 + 26),SonicBoom=v16(1230135 - 839410, nil, 109 - 76),ChampionsSpear=v16(376453 - (123 + 251), nil, 168 - 134),SpellReflection=v16(24618 - (208 + 490), nil, 3 + 32),StormBolt=v16(47917 + 59653, nil, 872 - (660 + 176)),ThunderClap=v17(5 + 32, 6545 - (14 + 188), 397394 - (534 + 141)),ThunderousRoar=v16(154503 + 229815, nil, 34 + 4),TitanicThrow=v16(369282 + 14808, nil, 81 - 42),WarMachineBuff=v16(416324 - 154092, nil, 112 - 72),WreckingThrow=v16(206258 + 177852, nil, 27 + 14),ChampionsMightBuff=v16(386682 - (115 + 281), nil, 418 - 238),BattleShoutBuff=v16(5525 + 1148, nil, 100 - 58),AspectsFavorBuff=v16(1493319 - 1086065, nil, 910 - (550 + 317)),RallyingCryBuff=v16(140812 - 43349, nil, 231 - 66),Pool=v16(2794228 - 1794318, nil, 329 - (134 + 151))};
	v16.Warrior.Arms = v19(v16.Warrior.Commons, {BattleStance=v16(387829 - (970 + 695), nil, 85 - 40),Execute=v17(2036 - (582 + 1408), 565993 - 402792, 353560 - 72560),Whirlwind=v16(6330 - 4650, nil, 1871 - (1195 + 629)),AngerManagement=v16(201386 - 49108, nil, 289 - (187 + 54)),Battlelord=v16(387410 - (162 + 618), nil, 35 + 14),BattlelordBuff=v16(257512 + 129119, nil, 106 - 56),BlademastersTorment=v16(655896 - 265758, nil, 5 + 55),Bladestorm=v17(1697 - (1373 + 263), 228847 - (451 + 549), 123037 + 266737),Bloodletting=v16(596283 - 213129, nil, 294 - 119),Cleave=v16(2229 - (746 + 638), nil, 24 + 38),ColossusSmash=v17(95 - 32, 167446 - (218 + 123), 263742 - (1535 + 46)),ColossusSmashDebuff=v16(206755 + 1331, nil, 10 + 54),DieByTheSword=v16(118598 - (306 + 254), nil, 5 + 60),Dreadnaught=v16(514480 - 252330, nil, 1533 - (899 + 568)),ExecutionersPrecision=v16(254135 + 132499, nil, 161 - 94),ExecutionersPrecisionDebuff=v16(387236 - (268 + 335), nil, 358 - (60 + 230)),FervorofBattle=v16(202888 - (426 + 146), nil, 9 + 60),Hurricane=v16(392019 - (282 + 1174), nil, 881 - (569 + 242)),HurricaneBuff=v16(1125105 - 734524, nil, 5 + 66),ImprovedSlam=v16(401229 - (706 + 318), nil, 1427 - (721 + 530)),Juggernaut=v16(384563 - (945 + 326), nil, 182 - 109),JuggernautBuff=v16(341061 + 42231, nil, 774 - (271 + 429)),MartialProwessBuff=v16(6783 + 601, nil, 1575 - (1408 + 92)),Massacre=v16(282087 - (461 + 625), nil, 1364 - (993 + 295)),MercilessBonegrinder=v16(19904 + 363413, nil, 1248 - (418 + 753)),MercilessBonegrinderBuff=v16(145987 + 237329, nil, 9 + 69),MortalStrike=v16(3596 + 8698, nil, 20 + 59),Overpower=v16(7913 - (406 + 123), nil, 1849 - (1749 + 20)),Rend=v16(184 + 588, nil, 1403 - (1249 + 73)),RendDebuff=v16(138618 + 249921, nil, 1227 - (466 + 679)),Skullsplitter=v16(626968 - 366325, nil, 237 - 154),StormofSwords=v16(387412 - (106 + 1794), nil, 27 + 57),SuddenDeath=v16(7514 + 22211, nil, 250 - 165),SuddenDeathBuff=v16(141996 - 89559, nil, 200 - (4 + 110)),SweepingStrikes=v16(261292 - (57 + 527), nil, 1514 - (41 + 1386)),SweepingStrikesBuff=v16(260811 - (17 + 86), nil, 60 + 28),TestofMight=v16(858611 - 473603, nil, 257 - 168),TestofMightBuff=v16(385179 - (122 + 44), nil, 155 - 65),TideofBlood=v16(1281727 - 895370, nil, 75 + 16),Unhinged=v16(55915 + 330713, nil, 185 - 93),Warbreaker=v16(262226 - (30 + 35), nil, 64 + 29),WarlordsTorment=v16(391397 - (1043 + 214), nil, 355 - 261),CrushingAdvanceBuff=v16(411350 - (323 + 889), nil, 255 - 160),DeepWoundsDebuff=v16(262695 - (361 + 219), nil, 416 - (53 + 267))});
	v16.Warrior.Fury = v19(v16.Warrior.Commons, {BerserkerStance=v16(87250 + 298946, nil, 510 - (15 + 398)),Bloodbath=v16(336078 - (18 + 964), nil, 368 - 270),CrushingBlow=v16(194009 + 141088, nil, 63 + 36),Execute=v17(950 - (20 + 830), 4144 + 1164, 280861 - (116 + 10)),Whirlwind=v16(14066 + 176345, nil, 839 - (542 + 196)),AngerManagement=v16(326439 - 174161, nil, 30 + 72),Annihilator=v16(195056 + 188860, nil, 38 + 65),AshenJuggernaut=v16(1034367 - 641831, nil, 266 - 162),Bloodthirst=v16(25432 - (1126 + 425), nil, 511 - (118 + 287)),ColdSteelHotBlood=v16(1504847 - 1120888, nil, 1228 - (118 + 1003)),DancingBlades=v16(1146233 - 754550, nil, 485 - (142 + 235)),EnragedRegeneration=v16(836370 - 652006, nil, 24 + 86),Frenzy=v16(336054 - (553 + 424), nil, 209 - 98),FrenzyBuff=v16(295180 + 39902, nil, 112 + 0),ImprovedWhilwind=v16(7541 + 5409, nil, 49 + 64),Massacre=v16(117821 + 88494, nil, 385 - 207),MeatCleaver=v16(781260 - 500868, nil, 254 - 140),OdynsFury=v16(111973 + 273086, nil, 560 - 444),Onslaught=v16(316473 - (239 + 514), nil, 42 + 75),RagingBlow=v16(86617 - (797 + 532), nil, 86 + 32),Rampage=v16(62197 + 122170, nil, 279 - 160),Ravager=v16(230122 - (373 + 829), nil, 851 - (476 + 255)),RecklessAbandon=v16(397879 - (369 + 761), nil, 70 + 51),Recklessness=v16(3121 - 1402, nil, 230 - 108),StormofSwords=v16(389141 - (64 + 174), nil, 18 + 106),SuddenDeath=v16(415730 - 135009, nil, 461 - (144 + 192)),Tenderize=v16(389149 - (42 + 174), nil, 96 + 31),TitanicRage=v16(326651 + 67678, nil, 55 + 73),TitansTorment=v16(391639 - (363 + 1141), nil, 1709 - (1183 + 397)),WrathandFury=v16(1196232 - 803296, nil, 96 + 34),AshenJuggernautBuff=v16(293405 + 99132, nil, 2080 - (1913 + 62)),BloodcrazeBuff=v16(248102 + 145849, nil, 346 - 215),DancingBladesBuff=v16(393621 - (565 + 1368), nil, 409 - 300),EnrageBuff=v16(186023 - (1477 + 184), nil, 179 - 47),FuriousBloodthirstBuff=v16(394328 + 28883, nil, 1030 - (564 + 292)),MeatCleaverBuff=v16(147935 - 62196, nil, 346 - 231),MercilessAssaultBuff=v16(410287 - (244 + 60), nil, 103 + 30),RecklessnessBuff=v16(2195 - (41 + 435), nil, 1124 - (938 + 63)),SuddenDeathBuff=v16(215939 + 64837, nil, 1251 - (936 + 189)),GushingWoundDebuff=v16(126718 + 258324, nil, 1792 - (1565 + 48))});
	v16.Warrior.Protection = v19(v16.Warrior.Commons, {BattleStance=v16(238540 + 147624, nil, 1272 - (782 + 356)),Devastate=v16(20510 - (176 + 91), nil, 351 - 216),Execute=v16(240527 - 77326, nil, 1228 - (975 + 117)),ShieldBlock=v16(4440 - (157 + 1718), nil, 112 + 25),ShieldSlam=v16(84921 - 60999, nil, 471 - 333),BarbaricTraining=v16(391693 - (697 + 321), nil, 378 - 239),Bolster=v16(593213 - 313212, nil, 322 - 182),BoomingVoice=v16(78917 + 123826, nil, 264 - 123),ChampionsBulwark=v16(1035633 - 649305, nil, 1369 - (322 + 905)),DemoralizingShout=v16(1771 - (602 + 9), nil, 1332 - (449 + 740)),EnduringDefenses=v16(386899 - (826 + 46), nil, 1091 - (245 + 702)),HeavyRepercussions=v16(642030 - 438853, nil, 47 + 98),ImpenetrableWall=v16(385970 - (260 + 1638), nil, 588 - (382 + 58)),Juggernaut=v16(1263874 - 869907, nil, 124 + 25),LastStand=v16(26815 - 13840, nil, 445 - 295),Massacre=v16(282206 - (902 + 303), nil, 331 - 180),Ravager=v16(551354 - 322434, nil, 14 + 138),Rend=v16(395752 - (1121 + 569), nil, 367 - (22 + 192)),Revenge=v16(7255 - (483 + 200), nil, 1617 - (1404 + 59)),SeismicReverberation=v16(1048050 - 665094, nil, 208 - 53),ShieldCharge=v16(386717 - (468 + 297), nil, 718 - (334 + 228)),ShieldWall=v16(2937 - 2066, nil, 363 - 206),SuddenDeath=v16(53910 - 24185, nil, 45 + 113),SuddenDeathBuff=v16(52673 - (141 + 95), nil, 157 + 2),UnnervingFocus=v16(988526 - 604484, nil, 384 - 224),UnstoppableForce=v16(64494 + 210842, nil, 441 - 280),AvatarBuff=v16(282005 + 119145, nil, 85 + 77),EarthenTenacityBuff=v16(577686 - 167468, nil, 97 + 66),FervidBuff=v16(425680 - (92 + 71), nil, 88 + 89),LastStandBuff=v16(21814 - 8839, nil, 929 - (574 + 191)),RevengeBuff=v16(4374 + 928, nil, 415 - 249),SeeingRedBuff=v16(197413 + 189073, nil, 1016 - (254 + 595)),ShieldBlockBuff=v16(132530 - (55 + 71), nil, 220 - 52),ShieldWallBuff=v16(2661 - (573 + 1217), nil, 467 - 298),ViolentOutburstBuff=v16(29406 + 357072, nil, 273 - 103),VanguardsDeterminationBuff=v16(394995 - (714 + 225), nil, 499 - 328),RendDebuff=v16(541686 - 153147, nil, 19 + 153)});
	if (((4521 - 1398) < (4697 - (118 + 688))) and not v18.Warrior) then
		v18.Warrior = {};
	end
	v18.Warrior.Commons = {Healthstone=v18(5560 - (25 + 23)),RefreshingHealingPotion=v18(37068 + 154312),DreamwalkersHealingPotion=v18(208909 - (927 + 959)),AlgetharPuzzleBox=v18(652946 - 459245, {(24 - 11),(33 - 19)}),ManicGrieftorch=v18(194593 - (175 + 110), {(64 - 51),(39 - 25)}),FyralathTheDreamrender=v18(149296 + 57152)};
	v18.Warrior.Arms = v19(v18.Warrior.Commons, {});
	v18.Warrior.Fury = v19(v18.Warrior.Commons, {});
	v18.Warrior.Protection = v19(v18.Warrior.Commons, {});
	if (((5003 - (810 + 251)) <= (3461 + 1526)) and not v21.Warrior) then
		v21.Warrior = {};
	end
	v21.Warrior.Commons = {Healthstone=v21(3 + 6),RefreshingHealingPotion=v21(10 + 0),UseWeapon=v21(634 - (43 + 490)),InterveneFocus=v21(744 - (711 + 22)),PummelMouseover=v21(46 - 34),StormBoltMouseover=v21(872 - (240 + 619)),ChampionsSpearPlayer=v21(4 + 10),ChampionsSpearCursor=v21(23 - 8),IntimidatingShoutMouseover=v21(2 + 14)};
	v21.Warrior.Arms = v19(v21.Warrior.Commons, {});
	v21.Warrior.Fury = v19(v21.Warrior.Commons, {RavagerPlayer=v21(1761 - (1344 + 400)),RavagerCursor=v21(423 - (255 + 150))});
	v21.Warrior.Protection = v19(v21.Warrior.Commons, {RavagerPlayer=v21(15 + 4),RavagerCursor=v21(11 + 9)});
	local v34;
	v34 = v10.AddCoreOverride("Spell.IsCastable", function(v38, v39, v40, v41, v42, v43)
		local v44 = 0 - 0;
		local v45;
		while true do
			if (((14805 - 10221) == (6323 - (404 + 1335))) and (v44 == (406 - (183 + 223)))) then
				v45 = v34(v38, v39, v40, v41, v42, v43);
				if (((4841 - 862) >= (1106 + 562)) and (v38 == v16.Warrior.Arms.Charge)) then
					return v45 and (v38:Charges() >= (1 + 0)) and ((v13:AffectingCombat() and not v14:IsInRange(345 - (10 + 327)) and v14:IsInRange(18 + 7)) or not v13:AffectingCombat());
				else
					return v45;
				end
				break;
			end
		end
	end, 409 - (118 + 220));
	local v35;
	v35 = v10.AddCoreOverride("Spell.IsCastable", function(v46, v47, v48, v49, v50, v51)
		local v52 = 0 + 0;
		local v53;
		while true do
			if (((1017 - (108 + 341)) > (193 + 235)) and ((0 - 0) == v52)) then
				v53 = v35(v46, v47, v48, v49, v50, v51);
				if (((2827 - (711 + 782)) <= (8843 - 4230)) and (v46 == v16.Warrior.Fury.Charge)) then
					return v53 and (v46:Charges() >= (470 - (270 + 199))) and ((v13:AffectingCombat() and not v14:IsInRange(3 + 5) and v14:IsInRange(1844 - (580 + 1239))) or not v13:AffectingCombat());
				else
					return v53;
				end
				break;
			end
		end
	end, 213 - 141);
	local v36;
	v36 = v10.AddCoreOverride("Spell.IsReady", function(v54, v55, v56, v57, v58, v59)
		local v60 = 0 + 0;
		local v61;
		while true do
			if ((v60 == (0 + 0)) or ((813 + 1052) >= (5297 - 3268))) then
				v61 = v36(v54, v55, v56, v57, v58, v59);
				if (((3076 + 1874) >= (2783 - (645 + 522))) and (v54 == v16.Warrior.Fury.Rampage)) then
					if (((3515 - (1010 + 780)) == (1725 + 0)) and v13:PrevGCDP(4 - 3, v16.Warrior.Fury.Bladestorm)) then
						return v54:IsCastable() and (v13:Rage() >= v54:Cost());
					else
						return v61;
					end
				else
					return v61;
				end
				break;
			end
		end
	end, 210 - 138);
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v62, v63, v64, v65, v66, v67)
		local v68 = 1836 - (1045 + 791);
		local v69;
		while true do
			if (((3692 - 2233) <= (3789 - 1307)) and ((505 - (351 + 154)) == v68)) then
				v69 = v37(v62, v63, v64, v65, v66, v67);
				if ((v62 == v16.Warrior.Protection.Charge) or ((4270 - (1281 + 293)) >= (4798 - (28 + 238)))) then
					return v69 and (v62:Charges() >= (2 - 1)) and not v14:IsInRange(1567 - (1381 + 178));
				elseif (((983 + 65) >= (42 + 10)) and ((v62 == v16.Warrior.Protection.HeroicThrow) or (v62 == v16.Warrior.Protection.TitanicThrow))) then
					return v69 and not v14:IsInRange(4 + 4);
				elseif (((10197 - 7239) < (2333 + 2170)) and (v62 == v16.Warrior.Protection.Avatar)) then
					return v69 and (v13:BuffDown(v16.Warrior.Protection.AvatarBuff));
				elseif ((v62 == v16.Warrior.Protection.Intervene) or ((3205 - (381 + 89)) == (1161 + 148))) then
					return v69 and (v13:IsInParty() or v13:IsInRaid());
				else
					return v69;
				end
				break;
			end
		end
	end, 50 + 23);
end;
return v0["Epix_Warrior_Warrior.lua"]();

