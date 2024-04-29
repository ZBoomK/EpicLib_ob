local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1813 - (979 + 834);
	local v6;
	while true do
		if (((925 + 2295) > (760 - (5 + 25))) and (v5 == (1187 - (1069 + 118)))) then
			v6 = v0[v4];
			if (((3616 - 2022) > (187 - 101)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 - 0)) or ((3050 + 24) == (1298 - (368 + 423)))) then
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
	if (not v16.Warrior or ((1162 - 792) > (3175 - (10 + 8)))) then
		v16.Warrior = {};
	end
	v16.Warrior.Commons = {AncestralCall=v16(1056843 - 782105, nil, 443 - (416 + 26)),ArcaneTorrent=v16(161603 - 110990, nil, 1 + 1),BagofTricks=v16(552790 - 240379, nil, 441 - (145 + 293)),Berserking=v16(26727 - (44 + 386), nil, 1490 - (998 + 488)),BloodFury=v16(6536 + 14036, nil, 5 + 0),Fireblood=v16(265993 - (201 + 571), nil, 1144 - (116 + 1022)),LightsJudgment=v16(1064326 - 808679, nil, 5 + 2),WarStomp=v16(75017 - 54468, nil, 28 - 20),BattleShout=v16(7532 - (814 + 45), nil, 21 - 12),Charge=v16(6 + 94, nil, 4 + 6),Hamstring=v16(2600 - (261 + 624), nil, 307 - 134),HeroicThrow=v16(58835 - (1020 + 60), nil, 1434 - (630 + 793)),IgnorePain=v16(645391 - 454935, nil, 340 - 268),Pummel=v16(2581 + 3971, nil, 41 - 29),Slam=v16(3211 - (760 + 987), nil, 1926 - (1789 + 124)),VictoryRush=v16(35194 - (745 + 21), nil, 5 + 9),DefensiveStance=v16(1062707 - 676499, nil, 58 - 43),Avatar=v17(1 + 15, 84459 + 23115, 402205 - (87 + 968)),AvatarBuff=v17(74 - 57, 97599 + 9975, 906819 - 505669),BerserkerRage=v16(19912 - (447 + 966), nil, 49 - 31),BerserkersTorment=v16(391940 - (1703 + 114), nil, 720 - (376 + 325)),BitterImmunity=v16(628906 - 245144, nil, 61 - 41),BloodandThunder=v16(109818 + 274459, nil, 46 - 25),DoubleTime=v16(103841 - (9 + 5), nil, 398 - (85 + 291)),CrushingForce=v16(384029 - (243 + 1022), nil, 87 - 64),FrothingBerserker=v16(177839 + 37732, nil, 1204 - (1123 + 57)),ImmovableObject=v16(320826 + 73481, nil, 279 - (163 + 91)),Intervene=v16(5341 - (1869 + 61), nil, 42 + 105),IntimidatingShout=v16(18476 - 13230, nil, 39 - 13),HeroicLeap=v16(896 + 5648, nil, 37 - 10),ImpendingVictory=v16(189891 + 12277, nil, 1502 - (1329 + 145)),OverwhelmingRage=v16(383738 - (140 + 831), nil, 1879 - (1409 + 441)),RallyingCry=v16(98180 - (15 + 703), nil, 14 + 16),RumblingEarth=v16(275777 - (262 + 176), nil, 1752 - (345 + 1376)),Shockwave=v16(47656 - (198 + 490), nil, 141 - 109),SonicBoom=v16(937229 - 546504, nil, 1239 - (696 + 510)),ChampionsSpear=v16(788745 - 412666, nil, 1296 - (1091 + 171)),SpellReflection=v16(3850 + 20070, nil, 110 - 75),StormBolt=v16(356738 - 249168, nil, 410 - (123 + 251)),ThunderClap=v17(183 - 146, 7041 - (208 + 490), 33477 + 363242),ThunderousRoar=v16(171193 + 213125, nil, 874 - (660 + 176)),TitanicThrow=v16(46147 + 337943, nil, 241 - (14 + 188)),WarMachineBuff=v16(262907 - (534 + 141), nil, 17 + 23),WreckingThrow=v16(339762 + 44348, nil, 40 + 1),ChampionsMightBuff=v16(811797 - 425511, nil, 285 - 105),BattleShoutBuff=v16(18717 - 12044, nil, 23 + 19),AspectsFavorBuff=v16(259305 + 147949, nil, 439 - (115 + 281)),RallyingCryBuff=v16(226702 - 129239, nil, 137 + 28),HurricaneBuff=v16(943938 - 553357, nil, 260 - 189),ThunderousRoarDebuff=v16(398231 - (550 + 317), nil, 262 - 80),Pool=v16(1405447 - 405537, nil, 122 - 78)};
	v16.Warrior.Arms = v19(v16.Warrior.Commons, {BattleStance=v16(386449 - (134 + 151), nil, 1710 - (970 + 695)),Execute=v17(87 - 41, 165191 - (582 + 1408), 974529 - 693529),Whirlwind=v16(2113 - 433, nil, 177 - 130),AngerManagement=v16(154102 - (1195 + 629), nil, 63 - 15),Battlelord=v16(386871 - (187 + 54), nil, 829 - (162 + 618)),BattlelordBuff=v16(270912 + 115719, nil, 34 + 16),BlademastersTorment=v16(832047 - 441909, nil, 100 - 40),Bladestorm=v17(5 + 56, 229483 - (1373 + 263), 390774 - (451 + 549)),Bloodletting=v16(120947 + 262207, nil, 272 - 97),Cleave=v16(1420 - 575, nil, 1446 - (746 + 638)),ColossusSmash=v17(24 + 39, 253712 - 86607, 262502 - (218 + 123)),ColossusSmashDebuff=v16(209667 - (1535 + 46), nil, 64 + 0),DieByTheSword=v16(17081 + 100957, nil, 625 - (306 + 254)),Dreadnaught=v16(16230 + 245920, nil, 128 - 62),ExecutionersPrecision=v16(388101 - (899 + 568), nil, 45 + 22),ExecutionersPrecisionDebuff=v16(935614 - 548981, nil, 671 - (268 + 335)),FervorofBattle=v16(202606 - (60 + 230), nil, 641 - (426 + 146)),Hurricane=v16(46787 + 343776, nil, 1526 - (282 + 1174)),ImprovedSlam=v16(401016 - (569 + 242), nil, 506 - 330),ImprovedSweepingStrikes=v16(21912 + 361243, nil, 1206 - (706 + 318)),Juggernaut=v16(384543 - (721 + 530), nil, 1344 - (945 + 326)),JuggernautBuff=v16(957585 - 574293, nil, 66 + 8),MartialProwessBuff=v16(8084 - (271 + 429), nil, 69 + 6),Massacre=v16(282501 - (1408 + 92), nil, 1162 - (461 + 625)),MercilessBonegrinder=v16(384605 - (993 + 295), nil, 4 + 73),MercilessBonegrinderBuff=v16(384487 - (418 + 753), nil, 30 + 48),MortalStrike=v16(1268 + 11026, nil, 24 + 55),Overpower=v16(1867 + 5517, nil, 609 - (406 + 123)),Rend=v16(2541 - (1749 + 20), nil, 20 + 61),RendDebuff=v16(389861 - (1249 + 73), nil, 30 + 52),SharpenedBlades=v16(384486 - (466 + 679), nil, 442 - 258),Skullsplitter=v16(745487 - 484844, nil, 1983 - (106 + 1794)),StormofSwords=v16(121958 + 263554, nil, 22 + 62),SuddenDeath=v16(87759 - 58034, nil, 230 - 145),SuddenDeathBuff=v16(52551 - (4 + 110), nil, 670 - (57 + 527)),SweepingStrikes=v16(262135 - (41 + 1386), nil, 190 - (17 + 86)),SweepingStrikesBuff=v16(176944 + 83764, nil, 196 - 108),TestofMight=v16(1114961 - 729953, nil, 255 - (122 + 44)),TestofMightBuff=v16(665045 - 280032, nil, 298 - 208),TideofBlood=v16(314296 + 72061, nil, 14 + 77),Unhinged=v16(783253 - 396625, nil, 157 - (30 + 35)),Warbreaker=v16(180187 + 81974, nil, 1350 - (1043 + 214)),WarlordsTorment=v16(1474985 - 1084845, nil, 1306 - (323 + 889)),CollateralDamageBuff=v16(901115 - 566332, nil, 763 - (361 + 219)),StrikeVulnerabilitiesBuff=v16(394493 - (53 + 267), nil, 41 + 140),CrushingAdvanceBuff=v16(410551 - (15 + 398), nil, 1077 - (18 + 964)),DeepWoundsDebuff=v16(986632 - 724517, nil, 56 + 40)});
	v16.Warrior.Fury = v19(v16.Warrior.Commons, {BerserkerStance=v16(243318 + 142878, nil, 947 - (20 + 830)),Bloodbath=v16(261573 + 73523, nil, 224 - (116 + 10)),CrushingBlow=v16(24753 + 310344, nil, 837 - (542 + 196)),Execute=v17(214 - 114, 1551 + 3757, 142633 + 138102),Whirlwind=v16(68542 + 121869, nil, 265 - 164),AngerManagement=v16(390408 - 238130, nil, 1653 - (1126 + 425)),Annihilator=v16(384321 - (118 + 287), nil, 403 - 300),AshenJuggernaut=v16(393657 - (118 + 1003), nil, 304 - 200),Bloodthirst=v16(24258 - (142 + 235), nil, 480 - 374),ColdSteelHotBlood=v16(83546 + 300413, nil, 1084 - (553 + 424)),DancingBlades=v16(740655 - 348972, nil, 96 + 12),EnragedRegeneration=v16(182886 + 1478, nil, 65 + 45),Frenzy=v16(142438 + 192639, nil, 64 + 47),FrenzyBuff=v16(726422 - 391340, nil, 311 - 199),ImprovedWhilwind=v16(28995 - 16045, nil, 33 + 80),Massacre=v16(997050 - 790735, nil, 931 - (239 + 514)),MeatCleaver=v16(98477 + 181915, nil, 1443 - (797 + 532)),OdynsFury=v16(279790 + 105269, nil, 40 + 76),Onslaught=v16(742338 - 426618, nil, 1319 - (373 + 829)),RagingBlow=v16(86019 - (476 + 255), nil, 1248 - (369 + 761)),Rampage=v16(106652 + 77715, nil, 215 - 96),Ravager=v16(433804 - 204884, nil, 358 - (64 + 174)),RecklessAbandon=v16(56507 + 340242, nil, 179 - 58),Recklessness=v16(2055 - (144 + 192), nil, 338 - (42 + 174)),StormofSwords=v16(292157 + 96746, nil, 103 + 21),SuddenDeath=v16(119263 + 161458, nil, 1629 - (363 + 1141)),Tenderize=v16(390513 - (1183 + 397), nil, 386 - 259),TitanicRage=v16(289062 + 105267, nil, 96 + 32),TitansTorment=v16(392110 - (1913 + 62), nil, 82 + 47),WrathandFury=v16(1040221 - 647285, nil, 2063 - (565 + 1368)),AshenJuggernautBuff=v16(1476227 - 1083690, nil, 1766 - (1477 + 184)),BloodcrazeBuff=v16(536790 - 142839, nil, 123 + 8),DancingBladesBuff=v16(392544 - (564 + 292), nil, 187 - 78),EnrageBuff=v16(555697 - 371335, nil, 436 - (244 + 60)),FuriousBloodthirstBuff=v16(325412 + 97799, nil, 650 - (41 + 435)),MeatCleaverBuff=v16(86740 - (938 + 63), nil, 89 + 26),MercilessAssaultBuff=v16(411108 - (936 + 189), nil, 44 + 89),RecklessnessBuff=v16(3332 - (1565 + 48), nil, 76 + 47),SuddenDeathBuff=v16(281914 - (782 + 356), nil, 393 - (176 + 91)),GushingWoundDebuff=v16(1003161 - 618119, nil, 263 - 84)});
	v16.Warrior.Protection = v19(v16.Warrior.Commons, {BattleStance=v16(387256 - (975 + 117), nil, 2009 - (157 + 1718)),Devastate=v16(16429 + 3814, nil, 479 - 344),Execute=v16(557953 - 394752, nil, 1154 - (697 + 321)),ShieldBlock=v16(6987 - 4422, nil, 290 - 153),ShieldSlam=v16(55149 - 31227, nil, 54 + 84),BarbaricTraining=v16(731990 - 341315, nil, 372 - 233),Bolster=v16(281228 - (322 + 905), nil, 751 - (602 + 9)),BoomingVoice=v16(203932 - (449 + 740), nil, 1013 - (826 + 46)),ChampionsBulwark=v16(387275 - (245 + 702), nil, 448 - 306),DemoralizingShout=v16(373 + 787, nil, 2041 - (260 + 1638)),EnduringDefenses=v16(386467 - (382 + 58), nil, 461 - 317),HeavyRepercussions=v16(168832 + 34345, nil, 299 - 154),ImpenetrableWall=v16(1141694 - 757622, nil, 1353 - (902 + 303)),Juggernaut=v16(865010 - 471043, nil, 358 - 209),LastStand=v16(1115 + 11860, nil, 1840 - (1121 + 569)),Massacre=v16(281215 - (22 + 192), nil, 834 - (483 + 200)),Ravager=v16(230383 - (1404 + 59), nil, 415 - 263),Rend=v16(529630 - 135568, nil, 918 - (468 + 297)),Revenge=v16(7134 - (334 + 228), nil, 519 - 365),SeismicReverberation=v16(887657 - 504701, nil, 281 - 126),ShieldCharge=v16(109597 + 276355, nil, 392 - (141 + 95)),ShieldWall=v16(856 + 15, nil, 403 - 246),SuddenDeath=v16(71456 - 41731, nil, 38 + 120),SuddenDeathBuff=v16(143671 - 91234, nil, 112 + 47),UnnervingFocus=v16(199981 + 184061, nil, 225 - 65),UnstoppableForce=v16(162410 + 112926, nil, 324 - (92 + 71)),AvatarBuff=v16(198146 + 203004, nil, 271 - 109),EarthenTenacityBuff=v16(410983 - (574 + 191), nil, 135 + 28),FervidBuff=v16(1066050 - 640533, nil, 91 + 86),LastStandBuff=v16(13824 - (254 + 595), nil, 290 - (55 + 71)),RevengeBuff=v16(6984 - 1682, nil, 1956 - (573 + 1217)),SeeingRedBuff=v16(1070342 - 683856, nil, 13 + 154),ShieldBlockBuff=v16(213355 - 80951, nil, 1107 - (714 + 225)),ShieldWallBuff=v16(2545 - 1674, nil, 234 - 65),ViolentOutburstBuff=v16(41842 + 344636, nil, 246 - 76),VanguardsDeterminationBuff=v16(394862 - (118 + 688), nil, 219 - (25 + 23)),RendDebuff=v16(75255 + 313284, nil, 2058 - (927 + 959))});
	if (((1017 - 715) <= (1234 - (16 + 716))) and not v18.Warrior) then
		v18.Warrior = {};
	end
	v18.Warrior.Commons = {Healthstone=v18(10639 - 5127),RefreshingHealingPotion=v18(191477 - (11 + 86)),DreamwalkersHealingPotion=v18(504964 - 297941),AlgetharPuzzleBox=v18(193986 - (175 + 110), {(64 - 51),(39 - 25)}),ManicGrieftorch=v18(140517 + 53791, {(10 + 3),(13 + 1)}),FyralathTheDreamrender=v18(206981 - (43 + 490))};
	v18.Warrior.Arms = v19(v18.Warrior.Commons, {});
	v18.Warrior.Fury = v19(v18.Warrior.Commons, {});
	v18.Warrior.Protection = v19(v18.Warrior.Commons, {});
	if (not v21.Warrior or ((5550 - (711 + 22)) < (15995 - 11860))) then
		v21.Warrior = {};
	end
	v21.Warrior.Commons = {Healthstone=v21(868 - (240 + 619)),RefreshingHealingPotion=v21(3 + 7),UseWeapon=v21(160 - 59),InterveneFocus=v21(1 + 10),PummelMouseover=v21(1756 - (1344 + 400)),StormBoltMouseover=v21(418 - (255 + 150)),ChampionsSpearPlayer=v21(12 + 2),ChampionsSpearCursor=v21(9 + 6),IntimidatingShoutMouseover=v21(68 - 52)};
	v21.Warrior.Arms = v19(v21.Warrior.Commons, {});
	v21.Warrior.Fury = v19(v21.Warrior.Commons, {RavagerPlayer=v21(54 - 37),RavagerCursor=v21(1757 - (404 + 1335))});
	v21.Warrior.Protection = v19(v21.Warrior.Commons, {RavagerPlayer=v21(425 - (183 + 223)),RavagerCursor=v21(24 - 4)});
	local v34;
	v34 = v10.AddCoreOverride("Spell.IsCastable", function(v38, v39, v40, v41, v42, v43)
		local v44 = 0 + 0;
		local v45;
		while true do
			if (((98 + 174) == (609 - (10 + 327))) and (v44 == (0 + 0))) then
				v45 = v34(v38, v39, v40, v41, v42, v43);
				if (((438 - (118 + 220)) <= (1041 + 2082)) and (v38 == v16.Warrior.Arms.Charge)) then
					return v45 and (v38:Charges() >= (450 - (108 + 341))) and ((v13:AffectingCombat() and not v14:IsInRange(4 + 4) and v14:IsInRange(105 - 80)) or not v13:AffectingCombat());
				else
					return v45;
				end
				break;
			end
		end
	end, 1564 - (711 + 782));
	local v35;
	v35 = v10.AddCoreOverride("Spell.IsCastable", function(v46, v47, v48, v49, v50, v51)
		local v52 = v35(v46, v47, v48, v49, v50, v51);
		if ((v46 == v16.Warrior.Fury.Charge) or ((2624 - 1255) > (5456 - (270 + 199)))) then
			return v52 and (v46:Charges() >= (1 + 0)) and ((v13:AffectingCombat() and not v14:IsInRange(1827 - (580 + 1239)) and v14:IsInRange(74 - 49)) or not v13:AffectingCombat());
		else
			return v52;
		end
	end, 69 + 3);
	local v36;
	v36 = v10.AddCoreOverride("Spell.IsReady", function(v53, v54, v55, v56, v57, v58)
		local v59 = 0 + 0;
		local v60;
		while true do
			if ((v59 == (0 + 0)) or ((2252 - 1389) >= (2848 + 1736))) then
				v60 = v36(v53, v54, v55, v56, v57, v58);
				if ((v53 == v16.Warrior.Fury.Rampage) or ((1891 - (645 + 522)) >= (3458 - (1010 + 780)))) then
					if (((428 + 0) < (8594 - 6790)) and v13:PrevGCDP(2 - 1, v16.Warrior.Fury.Bladestorm)) then
						return v53:IsCastable() and (v13:Rage() >= v53:Cost());
					else
						return v60;
					end
				else
					return v60;
				end
				break;
			end
		end
	end, 1908 - (1045 + 791));
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v61, v62, v63, v64, v65, v66)
		local v67 = 0 - 0;
		local v68;
		while true do
			if ((v67 == (0 - 0)) or ((3830 - (351 + 154)) > (6187 - (1281 + 293)))) then
				v68 = v37(v61, v62, v63, v64, v65, v66);
				if ((v61 == v16.Warrior.Protection.Charge) or ((5216 - (28 + 238)) <= (10172 - 5619))) then
					return v68 and (v61:Charges() >= (1560 - (1381 + 178))) and not v14:IsInRange(8 + 0);
				elseif (((2149 + 516) <= (1678 + 2255)) and ((v61 == v16.Warrior.Protection.HeroicThrow) or (v61 == v16.Warrior.Protection.TitanicThrow))) then
					return v68 and not v14:IsInRange(27 - 19);
				elseif (((1696 + 1577) == (3743 - (381 + 89))) and (v61 == v16.Warrior.Protection.Avatar)) then
					return v68 and (v13:BuffDown(v16.Warrior.Protection.AvatarBuff));
				elseif (((3392 + 432) > (277 + 132)) and (v61 == v16.Warrior.Protection.Intervene)) then
					return v68 and (v13:IsInParty() or v13:IsInRaid());
				else
					return v68;
				end
				break;
			end
		end
	end, 124 - 51);
end;
return v0["Epix_Warrior_Warrior.lua"]();

