local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 952 - (802 + 150);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((1036 - 464) >= (3266 + 1220))) then
			v6 = v0[v4];
			if (((2401 - (915 + 82)) == (3975 - 2571)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 - 0)) or ((4935 - (1069 + 118)) < (5017 - 2805))) then
			return v6(...);
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
	if (not v16.Warrior or ((2581 - 1401) == (379 + 1801))) then
		v16.Warrior = {};
	end
	v16.Warrior.Commons = {AncestralCall=v16(488153 - 213415, nil, 1 + 0),ArcaneTorrent=v16(51404 - (368 + 423), nil, 6 - 4),BagofTricks=v16(312429 - (10 + 8), nil, 11 - 8),Berserking=v16(26739 - (416 + 26), nil, 12 - 8),BloodFury=v16(8829 + 11743, nil, 8 - 3),Fireblood=v16(265659 - (145 + 293), nil, 436 - (44 + 386)),LightsJudgment=v16(257133 - (998 + 488), nil, 3 + 4),WarStomp=v16(16826 + 3723, nil, 780 - (201 + 571)),BattleShout=v16(7811 - (116 + 1022), nil, 37 - 28),Charge=v16(59 + 41, nil, 36 - 26),Hamstring=v16(6090 - 4375, nil, 1032 - (814 + 45)),HeroicThrow=v16(142306 - 84551, nil, 1 + 10),IgnorePain=v16(67296 + 123160, nil, 957 - (261 + 624)),Pummel=v16(11643 - 5091, nil, 1092 - (1020 + 60)),Slam=v16(2887 - (630 + 793), nil, 43 - 30),VictoryRush=v16(163008 - 128580, nil, 6 + 8),DefensiveStance=v16(1329731 - 943523, nil, 1762 - (760 + 987)),Avatar=v17(1929 - (1789 + 124), 108340 - (745 + 21), 137982 + 263168),AvatarBuff=v17(46 - 29, 421960 - 314386, 3280 + 397870),BerserkerRage=v16(14524 + 3975, nil, 1073 - (87 + 968)),BerserkersTorment=v16(1717299 - 1327176, nil, 18 + 1),BitterImmunity=v16(867512 - 483750, nil, 1433 - (447 + 966)),BloodandThunder=v16(1052016 - 667739, nil, 1838 - (1703 + 114)),DoubleTime=v16(104528 - (376 + 325), nil, 35 - 13),CrushingForce=v16(1177755 - 794991, nil, 7 + 16),FrothingBerserker=v16(474791 - 259220, nil, 38 - (9 + 5)),ImmovableObject=v16(394683 - (85 + 291), nil, 1290 - (243 + 1022)),Intervene=v16(12979 - 9568, nil, 122 + 25),IntimidatingShout=v16(6426 - (1123 + 57), nil, 22 + 4),HeroicLeap=v16(6798 - (163 + 91), nil, 1957 - (1869 + 61)),ImpendingVictory=v16(56481 + 145687, nil, 98 - 70),OverwhelmingRage=v16(587911 - 205144, nil, 4 + 25),RallyingCry=v16(133936 - 36474, nil, 29 + 1),RumblingEarth=v16(276813 - (1329 + 145), nil, 1002 - (140 + 831)),Shockwave=v16(48818 - (1409 + 441), nil, 750 - (15 + 703)),SonicBoom=v16(180947 + 209778, nil, 471 - (262 + 176)),ChampionsSpear=v16(377800 - (345 + 1376), nil, 722 - (198 + 490)),SpellReflection=v16(105677 - 81757, nil, 83 - 48),StormBolt=v16(108776 - (696 + 510), nil, 75 - 39),ThunderClap=v17(1299 - (1091 + 171), 1021 + 5322, 1249006 - 852287),ThunderousRoar=v16(1274526 - 890208, nil, 412 - (123 + 251)),TitanicThrow=v16(1908524 - 1524434, nil, 737 - (208 + 490)),WarMachineBuff=v16(22129 + 240103, nil, 18 + 22),WreckingThrow=v16(384946 - (660 + 176), nil, 5 + 36),ChampionsMightBuff=v16(386488 - (14 + 188), nil, 855 - (534 + 141)),BattleShoutBuff=v16(2683 + 3990, nil, 38 + 4),AspectsFavorBuff=v16(391553 + 15701, nil, 90 - 47),RallyingCryBuff=v16(154734 - 57271, nil, 462 - 297),HurricaneBuff=v16(209733 + 180848, nil, 46 + 25),ThunderousRoarDebuff=v16(397760 - (115 + 281), nil, 423 - 241),Pool=v16(827868 + 172042, nil, 105 - 61)};
	v16.Warrior.Arms = v19(v16.Warrior.Commons, {BattleStance=v16(1415986 - 1029822, nil, 912 - (550 + 317)),Execute=v17(66 - 20, 229390 - 66189, 785248 - 504248),Whirlwind=v16(1965 - (134 + 151), nil, 1712 - (970 + 695)),AngerManagement=v16(290582 - 138304, nil, 2038 - (582 + 1408)),Battlelord=v16(1340862 - 954232, nil, 60 - 11),BattlelordBuff=v16(1456963 - 1070332, nil, 1874 - (1195 + 629)),BlademastersTorment=v16(515956 - 125818, nil, 301 - (187 + 54)),Bladestorm=v17(841 - (162 + 618), 159652 + 68195, 259605 + 130169),Bloodletting=v16(817152 - 433998, nil, 294 - 119),Cleave=v16(67 + 778, nil, 1698 - (1373 + 263)),ColossusSmash=v17(1063 - (451 + 549), 52749 + 114356, 407988 - 145827),ColossusSmashDebuff=v16(349721 - 141635, nil, 1448 - (746 + 638)),DieByTheSword=v16(44423 + 73615, nil, 98 - 33),Dreadnaught=v16(262491 - (218 + 123), nil, 1647 - (1535 + 46)),ExecutionersPrecision=v16(384160 + 2474, nil, 10 + 57),ExecutionersPrecisionDebuff=v16(387193 - (306 + 254), nil, 5 + 63),FervorofBattle=v16(397053 - 194737, nil, 1536 - (899 + 568)),Hurricane=v16(256717 + 133846, nil, 169 - 99),ImprovedSlam=v16(400808 - (268 + 335), nil, 466 - (60 + 230)),ImprovedSweepingStrikes=v16(383727 - (426 + 146), nil, 22 + 160),Juggernaut=v16(384748 - (282 + 1174), nil, 884 - (569 + 242)),JuggernautBuff=v16(1104108 - 720816, nil, 5 + 69),MartialProwessBuff=v16(8408 - (706 + 318), nil, 1326 - (721 + 530)),Massacre=v16(282272 - (945 + 326), nil, 189 - 113),MercilessBonegrinder=v16(341083 + 42234, nil, 777 - (271 + 429)),MercilessBonegrinderBuff=v16(352115 + 31201, nil, 1578 - (1408 + 92)),MortalStrike=v16(13380 - (461 + 625), nil, 1367 - (993 + 295)),Overpower=v16(384 + 7000, nil, 1251 - (418 + 753)),Rend=v16(295 + 477, nil, 9 + 72),RendDebuff=v16(113642 + 274897, nil, 21 + 61),SharpenedBlades=v16(383870 - (406 + 123), nil, 1953 - (1749 + 20)),Skullsplitter=v16(61910 + 198733, nil, 1405 - (1249 + 73)),StormofSwords=v16(137539 + 247973, nil, 1229 - (466 + 679)),SuddenDeath=v16(71502 - 41777, nil, 243 - 158),SuddenDeathBuff=v16(54337 - (106 + 1794), nil, 28 + 58),SweepingStrikes=v16(65902 + 194806, nil, 256 - 169),SweepingStrikesBuff=v16(705981 - 445273, nil, 202 - (4 + 110)),TestofMight=v16(385592 - (57 + 527), nil, 1516 - (41 + 1386)),TestofMightBuff=v16(385116 - (17 + 86), nil, 62 + 28),TideofBlood=v16(861619 - 475262, nil, 263 - 172),Unhinged=v16(386794 - (122 + 44), nil, 158 - 66),Warbreaker=v16(869711 - 607550, nil, 76 + 17),WarlordsTorment=v16(56423 + 333717, nil, 189 - 95),CollateralDamageBuff=v16(334848 - (30 + 35), nil, 126 + 57),StrikeVulnerabilitiesBuff=v16(395430 - (1043 + 214), nil, 684 - 503),CrushingAdvanceBuff=v16(411350 - (323 + 889), nil, 255 - 160),DeepWoundsDebuff=v16(262695 - (361 + 219), nil, 416 - (53 + 267))});
	v16.Warrior.Fury = v19(v16.Warrior.Commons, {BerserkerStance=v16(87250 + 298946, nil, 510 - (15 + 398)),Bloodbath=v16(336078 - (18 + 964), nil, 368 - 270),CrushingBlow=v16(194009 + 141088, nil, 63 + 36),Execute=v17(950 - (20 + 830), 4144 + 1164, 280861 - (116 + 10)),Whirlwind=v16(14066 + 176345, nil, 839 - (542 + 196)),AngerManagement=v16(326439 - 174161, nil, 30 + 72),Annihilator=v16(195056 + 188860, nil, 38 + 65),AshenJuggernaut=v16(1034367 - 641831, nil, 266 - 162),Bloodthirst=v16(25432 - (1126 + 425), nil, 511 - (118 + 287)),ColdSteelHotBlood=v16(1504847 - 1120888, nil, 1228 - (118 + 1003)),DancingBlades=v16(1146233 - 754550, nil, 485 - (142 + 235)),EnragedRegeneration=v16(836370 - 652006, nil, 24 + 86),Frenzy=v16(336054 - (553 + 424), nil, 209 - 98),FrenzyBuff=v16(295180 + 39902, nil, 112 + 0),ImprovedWhilwind=v16(7541 + 5409, nil, 49 + 64),Massacre=v16(117821 + 88494, nil, 385 - 207),MeatCleaver=v16(781260 - 500868, nil, 254 - 140),OdynsFury=v16(111973 + 273086, nil, 560 - 444),Onslaught=v16(316473 - (239 + 514), nil, 42 + 75),RagingBlow=v16(86617 - (797 + 532), nil, 86 + 32),Rampage=v16(62197 + 122170, nil, 279 - 160),Ravager=v16(230122 - (373 + 829), nil, 851 - (476 + 255)),RecklessAbandon=v16(397879 - (369 + 761), nil, 70 + 51),Recklessness=v16(3121 - 1402, nil, 230 - 108),StormofSwords=v16(389141 - (64 + 174), nil, 18 + 106),SuddenDeath=v16(415730 - 135009, nil, 461 - (144 + 192)),Tenderize=v16(389149 - (42 + 174), nil, 96 + 31),TitanicRage=v16(326651 + 67678, nil, 55 + 73),TitansTorment=v16(391639 - (363 + 1141), nil, 1709 - (1183 + 397)),WrathandFury=v16(1196232 - 803296, nil, 96 + 34),AshenJuggernautBuff=v16(293405 + 99132, nil, 2080 - (1913 + 62)),BloodcrazeBuff=v16(248102 + 145849, nil, 346 - 215),DancingBladesBuff=v16(393621 - (565 + 1368), nil, 409 - 300),EnrageBuff=v16(186023 - (1477 + 184), nil, 179 - 47),FuriousBloodthirstBuff=v16(394328 + 28883, nil, 1030 - (564 + 292)),MeatCleaverBuff=v16(147935 - 62196, nil, 346 - 231),MercilessAssaultBuff=v16(410287 - (244 + 60), nil, 103 + 30),RecklessnessBuff=v16(2195 - (41 + 435), nil, 1124 - (938 + 63)),SuddenDeathBuff=v16(215939 + 64837, nil, 1251 - (936 + 189)),GushingWoundDebuff=v16(126718 + 258324, nil, 1792 - (1565 + 48))});
	v16.Warrior.Protection = v19(v16.Warrior.Commons, {BattleStance=v16(238540 + 147624, nil, 1272 - (782 + 356)),Devastate=v16(20510 - (176 + 91), nil, 351 - 216),Execute=v16(240527 - 77326, nil, 1228 - (975 + 117)),ShieldBlock=v16(4440 - (157 + 1718), nil, 112 + 25),ShieldSlam=v16(84921 - 60999, nil, 471 - 333),BarbaricTraining=v16(391693 - (697 + 321), nil, 378 - 239),Bolster=v16(593213 - 313212, nil, 322 - 182),BoomingVoice=v16(78917 + 123826, nil, 264 - 123),ChampionsBulwark=v16(1035633 - 649305, nil, 1369 - (322 + 905)),DemoralizingShout=v16(1771 - (602 + 9), nil, 1332 - (449 + 740)),EnduringDefenses=v16(386899 - (826 + 46), nil, 1091 - (245 + 702)),HeavyRepercussions=v16(642030 - 438853, nil, 47 + 98),ImpenetrableWall=v16(385970 - (260 + 1638), nil, 588 - (382 + 58)),Juggernaut=v16(1263874 - 869907, nil, 124 + 25),LastStand=v16(26815 - 13840, nil, 445 - 295),Massacre=v16(282206 - (902 + 303), nil, 331 - 180),Ravager=v16(551354 - 322434, nil, 14 + 138),Rend=v16(395752 - (1121 + 569), nil, 367 - (22 + 192)),Revenge=v16(7255 - (483 + 200), nil, 1617 - (1404 + 59)),SeismicReverberation=v16(1048050 - 665094, nil, 208 - 53),ShieldCharge=v16(386717 - (468 + 297), nil, 718 - (334 + 228)),ShieldWall=v16(2937 - 2066, nil, 363 - 206),SuddenDeath=v16(53910 - 24185, nil, 45 + 113),SuddenDeathBuff=v16(52673 - (141 + 95), nil, 157 + 2),UnnervingFocus=v16(988526 - 604484, nil, 384 - 224),UnstoppableForce=v16(64494 + 210842, nil, 441 - 280),AvatarBuff=v16(282005 + 119145, nil, 85 + 77),EarthenTenacityBuff=v16(577686 - 167468, nil, 97 + 66),FervidBuff=v16(425680 - (92 + 71), nil, 88 + 89),LastStandBuff=v16(21814 - 8839, nil, 929 - (574 + 191)),RevengeBuff=v16(4374 + 928, nil, 415 - 249),SeeingRedBuff=v16(197413 + 189073, nil, 1016 - (254 + 595)),ShieldBlockBuff=v16(132530 - (55 + 71), nil, 220 - 52),ShieldWallBuff=v16(2661 - (573 + 1217), nil, 467 - 298),ViolentOutburstBuff=v16(29406 + 357072, nil, 273 - 103),VanguardsDeterminationBuff=v16(394995 - (714 + 225), nil, 499 - 328),RendDebuff=v16(541686 - 153147, nil, 19 + 153)});
	if (((5922 - 1832) < (5459 - (118 + 688))) and not v18.Warrior) then
		v18.Warrior = {};
	end
	v18.Warrior.Commons = {Healthstone=v18(5560 - (25 + 23)),RefreshingHealingPotion=v18(37068 + 154312),DreamwalkersHealingPotion=v18(208909 - (927 + 959)),PotionOfWitheringDreams=v18(697913 - 490872),AlgetharPuzzleBox=v18(194433 - (16 + 716), {(110 - (11 + 86)),(299 - (175 + 110))}),ManicGrieftorch=v18(490587 - 296279, {(1809 - (503 + 1293)),(11 + 3)}),FyralathTheDreamrender=v18(207509 - (810 + 251))};
	v18.Warrior.Arms = v19(v18.Warrior.Commons, {});
	v18.Warrior.Fury = v19(v18.Warrior.Commons, {});
	v18.Warrior.Protection = v19(v18.Warrior.Commons, {});
	if (not v21.Warrior or ((1841 + 811) < (61 + 135))) then
		v21.Warrior = {};
	end
	v21.Warrior.Commons = {Healthstone=v21(9 + 0),RefreshingHealingPotion=v21(543 - (43 + 490)),UseWeapon=v21(834 - (711 + 22)),InterveneFocus=v21(42 - 31),PummelMouseover=v21(871 - (240 + 619)),StormBoltMouseover=v21(4 + 9),ChampionsSpearPlayer=v21(21 - 7),ChampionsSpearCursor=v21(1 + 14),IntimidatingShoutMouseover=v21(1760 - (1344 + 400))};
	v21.Warrior.Arms = v19(v21.Warrior.Commons, {});
	v21.Warrior.Fury = v19(v21.Warrior.Commons, {RavagerPlayer=v21(422 - (255 + 150)),RavagerCursor=v21(15 + 3)});
	v21.Warrior.Protection = v19(v21.Warrior.Commons, {RavagerPlayer=v21(11 + 8),RavagerCursor=v21(85 - 65)});
	local v34;
	v34 = v10.AddCoreOverride("Spell.IsCastable", function(v38, v39, v40, v41, v42, v43)
		local v44 = v34(v38, v39, v40, v41, v42, v43);
		if (((13355 - 9220) < (6556 - (404 + 1335))) and (v38 == v16.Warrior.Arms.Charge)) then
			return v44 and (v38:Charges() >= (407 - (183 + 223))) and ((v13:AffectingCombat() and not v14:IsInRange(9 - 1) and v14:IsInRange(17 + 8)) or not v13:AffectingCombat());
		else
			return v44;
		end
	end, 26 + 45);
	local v35;
	v35 = v10.AddCoreOverride("Spell.IsCastable", function(v45, v46, v47, v48, v49, v50)
		local v51 = 337 - (10 + 327);
		local v52;
		while true do
			if (((190 + 82) == (610 - (118 + 220))) and (v51 == (0 + 0))) then
				v52 = v35(v45, v46, v47, v48, v49, v50);
				if (((549 - (108 + 341)) <= (1403 + 1720)) and (v45 == v16.Warrior.Fury.Charge)) then
					return v52 and (v45:Charges() >= (4 - 3)) and ((v13:AffectingCombat() and not v14:IsInRange(1501 - (711 + 782)) and v14:IsInRange(47 - 22)) or not v13:AffectingCombat());
				else
					return v52;
				end
				break;
			end
		end
	end, 541 - (270 + 199));
	local v36;
	v36 = v10.AddCoreOverride("Spell.IsReady", function(v53, v54, v55, v56, v57, v58)
		local v59 = v36(v53, v54, v55, v56, v57, v58);
		if ((v53 == v16.Warrior.Fury.Rampage) or ((444 + 925) > (6806 - (580 + 1239)))) then
			if (v13:PrevGCDP(2 - 1, v16.Warrior.Fury.Bladestorm) or ((826 + 37) >= (165 + 4419))) then
				return v53:IsCastable() and (v13:Rage() >= v53:Cost());
			else
				return v59;
			end
		else
			return v59;
		end
	end, 32 + 40);
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v60, v61, v62, v63, v64, v65)
		local v66 = v37(v60, v61, v62, v63, v64, v65);
		if ((v60 == v16.Warrior.Protection.Charge) or ((1889 - 1165) >= (1037 + 631))) then
			return v66 and (v60:Charges() >= (1168 - (645 + 522))) and not v14:IsInRange(1798 - (1010 + 780));
		elseif (((428 + 0) < (8594 - 6790)) and ((v60 == v16.Warrior.Protection.HeroicThrow) or (v60 == v16.Warrior.Protection.TitanicThrow))) then
			return v66 and not v14:IsInRange(23 - 15);
		elseif ((v60 == v16.Warrior.Protection.Avatar) or ((5161 - (1045 + 791)) > (11676 - 7063))) then
			return v66 and (v13:BuffDown(v16.Warrior.Protection.AvatarBuff));
		elseif ((v60 == v16.Warrior.Protection.Intervene) or ((7558 - 2608) <= (5058 - (351 + 154)))) then
			return v66 and (v13:IsInParty() or v13:IsInRaid());
		else
			return v66;
		end
	end, 1647 - (1281 + 293));
end;
return v0["Epix_Warrior_Warrior.lua"]();

