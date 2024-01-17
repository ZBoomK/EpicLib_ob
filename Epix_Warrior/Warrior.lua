local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1822 + 2664) < (3378 - (1228 + 618)))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Warrior_Warrior.lua"] = function(...)
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
	if (((2827 - 1423) <= (12797 - 9577)) and not v15.Warrior) then
		v15.Warrior = {};
	end
	v15.Warrior.Commons = {AncestralCall=v15(275690 - (802 + 150), nil, 2 - 1),ArcaneTorrent=v15(91809 - 41196, nil, 2 + 0),BagofTricks=v15(313408 - (915 + 82), nil, 8 - 5),Berserking=v15(15320 + 10977, nil, 4 - 0),BloodFury=v15(21759 - (1069 + 118), nil, 10 - 5),Fireblood=v15(580163 - 314942, nil, 2 + 4),LightsJudgment=v15(454233 - 198586, nil, 7 + 0),WarStomp=v15(21340 - (368 + 423), nil, 25 - 17),BattleShout=v15(6691 - (10 + 8), nil, 34 - 25),Charge=v15(542 - (416 + 26), nil, 31 - 21),Hamstring=v15(736 + 979, nil, 305 - 132),HeroicThrow=v15(58193 - (145 + 293), nil, 441 - (44 + 386)),IgnorePain=v15(191942 - (998 + 488), nil, 23 + 49),Pummel=v15(5365 + 1187, nil, 784 - (201 + 571)),Slam=v15(2602 - (116 + 1022), nil, 53 - 40),VictoryRush=v15(20209 + 14219, nil, 51 - 37),DefensiveStance=v15(1371458 - 985250, nil, 874 - (814 + 45)),Avatar=v16(39 - 23, 5797 + 101777, 141742 + 259408),AvatarBuff=v16(902 - (261 + 624), 191168 - 83594, 402230 - (1020 + 60)),BerserkerRage=v15(19922 - (630 + 793), nil, 60 - 42),BerserkersTorment=v15(1847138 - 1457015, nil, 8 + 11),BitterImmunity=v15(1321309 - 937547, nil, 1767 - (760 + 987)),BloodandThunder=v15(386190 - (1789 + 124), nil, 787 - (745 + 21)),DoubleTime=v15(35713 + 68114, nil, 60 - 38),CrushingForce=v15(1501397 - 1118633, nil, 1 + 22),FrothingBerserker=v15(169250 + 46321, nil, 1079 - (87 + 968)),ImmovableObject=v15(1735716 - 1341409, nil, 23 + 2),Intervene=v15(7710 - 4299, nil, 1560 - (447 + 966)),IntimidatingShout=v15(14361 - 9115, nil, 1843 - (1703 + 114)),HeroicLeap=v15(7245 - (376 + 325), nil, 43 - 16),ImpendingVictory=v15(622066 - 419898, nil, 9 + 19),OverwhelmingRage=v15(843038 - 460271, nil, 43 - (9 + 5)),RallyingCry=v15(97838 - (85 + 291), nil, 1295 - (243 + 1022)),RumblingEarth=v15(1047713 - 772374, nil, 26 + 5),Shockwave=v15(48148 - (1123 + 57), nil, 27 + 5),SonicBoom=v15(390979 - (163 + 91), nil, 1963 - (1869 + 61)),ChampionsSpear=v15(105066 + 271013, nil, 119 - 85),SpellReflection=v15(36739 - 12819, nil, 5 + 30),StormBolt=v15(147827 - 40257, nil, 34 + 2),ThunderClap=v16(1511 - (1329 + 145), 7314 - (140 + 831), 398569 - (1409 + 441)),ThunderousRoar=v15(385036 - (15 + 703), nil, 18 + 20),TitanicThrow=v15(384528 - (262 + 176), nil, 1760 - (345 + 1376)),WarMachineBuff=v15(262920 - (198 + 490), nil, 176 - 136),WreckingThrow=v15(921361 - 537251, nil, 1247 - (696 + 510)),BattleShoutBuff=v15(13994 - 7321, nil, 1304 - (1091 + 171)),AspectsFavorBuff=v15(65536 + 341718, nil, 135 - 92),Pool=v15(3316035 - 2316125, nil, 418 - (123 + 251))};
	v15.Warrior.Arms = v18(v15.Warrior.Commons, {BattleStance=v15(1918830 - 1532666, nil, 743 - (208 + 490)),Execute=v16(4 + 42, 72698 + 90503, 281836 - (660 + 176)),Whirlwind=v15(202 + 1478, nil, 249 - (14 + 188)),AngerManagement=v15(152953 - (534 + 141), nil, 20 + 28),Battlelord=v15(341991 + 44639, nil, 48 + 1),BattlelordBuff=v15(812522 - 425891, nil, 79 - 29),BlademastersTorment=v15(1094354 - 704216, nil, 33 + 27),Bladestorm=v16(39 + 22, 228243 - (115 + 281), 906628 - 516854),Bloodletting=v15(317230 + 65924, nil, 422 - 247),Cleave=v15(3098 - 2253, nil, 929 - (550 + 317)),ColossusSmash=v16(90 - 27, 234878 - 67773, 732603 - 470442),ColossusSmashDebuff=v15(208371 - (134 + 151), nil, 1729 - (970 + 695)),DieByTheSword=v15(225244 - 107206, nil, 2055 - (582 + 1408)),Dreadnaught=v15(909156 - 647006, nil, 82 - 16),ExecutionersPrecision=v15(1456974 - 1070340, nil, 1891 - (1195 + 629)),ExecutionersPrecisionDebuff=v15(511320 - 124687, nil, 309 - (187 + 54)),FervorofBattle=v15(203096 - (162 + 618), nil, 49 + 20),Hurricane=v15(260131 + 130432, nil, 149 - 79),HurricaneBuff=v15(656641 - 266060, nil, 6 + 65),ImprovedSlam=v15(401841 - (1373 + 263), nil, 1176 - (451 + 549)),Juggernaut=v15(120991 + 262301, nil, 113 - 40),JuggernautBuff=v15(644183 - 260891, nil, 1458 - (746 + 638)),MartialProwessBuff=v15(2779 + 4605, nil, 113 - 38),Massacre=v15(281342 - (218 + 123), nil, 1657 - (1535 + 46)),MercilessBonegrinder=v15(380864 + 2453, nil, 12 + 65),MercilessBonegrinderBuff=v15(383876 - (306 + 254), nil, 5 + 73),MortalStrike=v15(24127 - 11833, nil, 1546 - (899 + 568)),Overpower=v15(4854 + 2530, nil, 193 - 113),Rend=v15(1375 - (268 + 335), nil, 371 - (60 + 230)),RendDebuff=v15(389111 - (426 + 146), nil, 10 + 72),Skullsplitter=v15(262099 - (282 + 1174), nil, 894 - (569 + 242)),StormofSwords=v15(1110503 - 724991, nil, 5 + 79),SuddenDeath=v15(30749 - (706 + 318), nil, 1336 - (721 + 530)),SuddenDeathBuff=v15(53708 - (945 + 326), nil, 214 - 128),SweepingStrikes=v15(231983 + 28725, nil, 787 - (271 + 429)),SweepingStrikesBuff=v15(239487 + 21221, nil, 1588 - (1408 + 92)),TestofMight=v15(386094 - (461 + 625), nil, 1377 - (993 + 295)),TestofMightBuff=v15(19992 + 365021, nil, 1261 - (418 + 753)),TideofBlood=v15(147146 + 239211, nil, 10 + 81),Unhinged=v15(113083 + 273545, nil, 24 + 68),Warbreaker=v15(262690 - (406 + 123), nil, 1862 - (1749 + 20)),WarlordsTorment=v15(92669 + 297471, nil, 1416 - (1249 + 73)),CrushingAdvanceBuff=v15(146324 + 263814, nil, 1240 - (466 + 679)),DeepWoundsDebuff=v15(630509 - 368394, nil, 274 - 178)});
	v15.Warrior.Fury = v18(v15.Warrior.Commons, {BerserkerStance=v15(388096 - (106 + 1794), nil, 31 + 66),Bloodbath=v15(84706 + 250390, nil, 289 - 191),CrushingBlow=v15(907422 - 572325, nil, 213 - (4 + 110)),Execute=v16(684 - (57 + 527), 6735 - (41 + 1386), 280838 - (17 + 86)),Whirlwind=v15(129233 + 61178, nil, 224 - 123),AngerManagement=v15(440988 - 288710, nil, 268 - (122 + 44)),Annihilator=v15(663150 - 279234, nil, 341 - 238),AshenJuggernaut=v15(319322 + 73214, nil, 16 + 88),AshenJuggernautBuff=v15(795223 - 402686, nil, 170 - (30 + 35)),Bloodthirst=v15(16414 + 7467, nil, 1363 - (1043 + 214)),ColdSteelHotBlood=v15(1451617 - 1067658, nil, 1319 - (323 + 889)),DancingBlades=v15(1054270 - 662587, nil, 688 - (361 + 219)),DancingBladesBuff=v15(392008 - (53 + 267), nil, 25 + 84),EnragedRegeneration=v15(184777 - (15 + 398), nil, 1092 - (18 + 964)),Frenzy=v15(1261269 - 926192, nil, 65 + 46),FrenzyBuff=v15(211114 + 123968, nil, 962 - (20 + 830)),ImprovedWhilwind=v15(10109 + 2841, nil, 239 - (116 + 10)),Massacre=v15(15240 + 191075, nil, 916 - (542 + 196)),MeatCleaver=v15(601078 - 320686, nil, 34 + 80),MeatCleaverBuff=v15(43562 + 42177, nil, 42 + 73),OdynsFury=v15(1014665 - 629606, nil, 297 - 181),Onslaught=v15(317271 - (1126 + 425), nil, 522 - (118 + 287)),RagingBlow=v15(334268 - 248980, nil, 1239 - (118 + 1003)),Rampage=v15(539537 - 355170, nil, 496 - (142 + 235)),Ravager=v15(1038499 - 809579, nil, 27 + 93),RecklessAbandon=v15(397726 - (553 + 424), nil, 228 - 107),Recklessness=v15(1515 + 204, nil, 122 + 0),RecklessnessBuff=v15(1001 + 718, nil, 53 + 70),StormofSwords=v15(222091 + 166812, nil, 268 - 144),SuddenDeath=v15(782177 - 501456, nil, 279 - 154),SuddenDeathBuff=v15(81648 + 199128, nil, 608 - 482),Tenderize=v15(389686 - (239 + 514), nil, 45 + 82),TitanicRage=v15(395658 - (797 + 532), nil, 94 + 34),TitansTorment=v15(131614 + 258521, nil, 302 - 173),WrathandFury=v15(394138 - (373 + 829), nil, 861 - (476 + 255)),BloodcrazeBuff=v15(395081 - (369 + 761), nil, 76 + 55),EnrageBuff=v15(334872 - 150510, nil, 249 - 117),FuriousBloodthirstBuff=v15(423449 - (64 + 174), nil, 25 + 149),MercilessAssaultBuff=v15(607159 - 197176, nil, 469 - (144 + 192))});
	v15.Warrior.Protection = v18(v15.Warrior.Commons, {BattleStance=v15(386380 - (42 + 174), nil, 101 + 33),Devastate=v15(16769 + 3474, nil, 58 + 77),Execute=v15(164705 - (363 + 1141), nil, 1716 - (1183 + 397)),ShieldBlock=v15(7808 - 5243, nil, 101 + 36),ShieldSlam=v15(17881 + 6041, nil, 2113 - (1913 + 62)),BarbaricTraining=v15(246039 + 144636, nil, 367 - 228),Bolster=v15(281934 - (565 + 1368), nil, 526 - 386),BoomingVoice=v15(204404 - (1477 + 184), nil, 191 - 50),ChampionsBulwark=v15(359962 + 26366, nil, 998 - (564 + 292)),DemoralizingShout=v15(2001 - 841, nil, 430 - 287),EnduringDefenses=v15(386331 - (244 + 60), nil, 111 + 33),HeavyRepercussions=v15(203653 - (41 + 435), nil, 1146 - (938 + 63)),ImpenetrableWall=v15(295381 + 88691, nil, 1273 - (936 + 189)),Juggernaut=v15(129655 + 264312, nil, 1762 - (1565 + 48)),LastStand=v15(8015 + 4960, nil, 1288 - (782 + 356)),Massacre=v15(281268 - (176 + 91), nil, 393 - 242),Ravager=v15(337385 - 108465, nil, 1244 - (975 + 117)),Rend=v15(395937 - (157 + 1718), nil, 125 + 28),Revenge=v15(23329 - 16757, nil, 526 - 372),SeismicReverberation=v15(383974 - (697 + 321), nil, 422 - 267),ShieldCharge=v15(817682 - 431730, nil, 359 - 203),ShieldWall=v15(340 + 531, nil, 293 - 136),SuddenDeath=v15(79684 - 49959, nil, 1385 - (322 + 905)),SuddenDeathBuff=v15(53048 - (602 + 9), nil, 1348 - (449 + 740)),UnnervingFocus=v15(384914 - (826 + 46), nil, 1107 - (245 + 702)),UnstoppableForce=v15(870050 - 594714, nil, 52 + 109),AvatarBuff=v15(403048 - (260 + 1638), nil, 602 - (382 + 58)),EarthenTenacityBuff=v15(1316008 - 905790, nil, 136 + 27),FervidBuff=v15(879416 - 453899, nil, 526 - 349),LastStandBuff=v15(14180 - (902 + 303), nil, 359 - 195),RallyingCryBuff=v15(234739 - 137276, nil, 15 + 150),RevengeBuff=v15(6992 - (1121 + 569), nil, 380 - (22 + 192)),SeeingRedBuff=v15(387169 - (483 + 200), nil, 1630 - (1404 + 59)),ShieldBlockBuff=v15(362355 - 229951, nil, 225 - 57),ShieldWallBuff=v15(1636 - (468 + 297), nil, 731 - (334 + 228)),ViolentOutburstBuff=v15(1303585 - 917107, nil, 394 - 224),VanguardsDeterminationBuff=v15(714676 - 320620, nil, 49 + 122),RendDebuff=v15(388775 - (141 + 95), nil, 169 + 3)});
	if (((2931 - 1792) <= (5317 - 3105)) and not v17.Warrior) then
		v17.Warrior = {};
	end
	v17.Warrior.Commons = {Healthstone=v17(1292 + 4220),RefreshingHealingPotion=v17(524358 - 332978),DreamwalkersHealingPotion=v17(145536 + 61487),AlgetharPuzzleBox=v17(100865 + 92836, {(8 + 5),(7 + 7)}),ManicGrieftorch=v17(326689 - 132381, {(11 + 2),(8 + 6)})};
	v17.Warrior.Arms = v18(v17.Warrior.Commons, {});
	v17.Warrior.Fury = v18(v17.Warrior.Commons, {});
	v17.Warrior.Protection = v18(v17.Warrior.Commons, {});
	if (not v20.Warrior or ((2029 - (254 + 595)) >= (4339 - (55 + 71)))) then
		v20.Warrior = {};
	end
	v20.Warrior.Commons = {Healthstone=v20(11 - 2),RefreshingHealingPotion=v20(1800 - (573 + 1217)),InterveneFocus=v20(30 - 19),PummelMouseover=v20(1 + 11),StormBoltMouseover=v20(20 - 7),ChampionsSpearPlayer=v20(953 - (714 + 225)),ChampionsSpearCursor=v20(43 - 28),IntimidatingShoutMouseover=v20(21 - 5)};
	v20.Warrior.Arms = v18(v20.Warrior.Commons, {});
	v20.Warrior.Fury = v18(v20.Warrior.Commons, {RavagerPlayer=v20(2 + 15),RavagerCursor=v20(25 - 7)});
	v20.Warrior.Protection = v18(v20.Warrior.Commons, {RavagerPlayer=v20(825 - (118 + 688)),RavagerCursor=v20(68 - (25 + 23))});
	local v33;
	v33 = v9.AddCoreOverride("Spell.IsCastable", function(v37, v38, v39, v40, v41, v42)
		local v43 = 0 + 0;
		local v44;
		while true do
			if (((6539 - (927 + 959)) > (10361 - 7287)) and (v43 == (732 - (16 + 716)))) then
				v44 = v33(v37, v38, v39, v40, v41, v42);
				if (((714 - 344) >= (293 - (11 + 86))) and (v37 == v15.Warrior.Arms.Charge)) then
					return v44 and (v37:Charges() >= (2 - 1)) and ((v12:AffectingCombat() and not v13:IsInRange(293 - (175 + 110)) and v13:IsInRange(62 - 37)) or not v12:AffectingCombat());
				else
					return v44;
				end
				break;
			end
		end
	end, 350 - 279);
	local v34;
	v34 = v9.AddCoreOverride("Spell.IsCastable", function(v45, v46, v47, v48, v49, v50)
		local v51 = v34(v45, v46, v47, v48, v49, v50);
		if ((v45 == v15.Warrior.Fury.Charge) or ((4964 - (503 + 1293)) < (1401 - 899))) then
			return v51 and (v45:Charges() >= (1 + 0)) and ((v12:AffectingCombat() and not v13:IsInRange(1069 - (810 + 251)) and v13:IsInRange(18 + 7)) or not v12:AffectingCombat());
		else
			return v51;
		end
	end, 23 + 49);
	local v35;
	v35 = v9.AddCoreOverride("Spell.IsReady", function(v52, v53, v54, v55, v56, v57)
		local v58 = 0 + 0;
		local v59;
		while true do
			if (((972 - (43 + 490)) == (1172 - (711 + 22))) and (v58 == (0 - 0))) then
				v59 = v35(v52, v53, v54, v55, v56, v57);
				if ((v52 == v15.Warrior.Fury.Rampage) or ((2123 - (240 + 619)) < (66 + 206))) then
					if (((4967 - 1844) < (258 + 3633)) and v12:PrevGCDP(1745 - (1344 + 400), v15.Warrior.Fury.Bladestorm)) then
						return v52:IsCastable() and (v12:Rage() >= v52:Cost());
					else
						return v59;
					end
				else
					return v59;
				end
				break;
			end
		end
	end, 477 - (255 + 150));
	local v36;
	v36 = v9.AddCoreOverride("Spell.IsCastable", function(v60, v61, v62, v63, v64, v65)
		local v66 = v36(v60, v61, v62, v63, v64, v65);
		if (((3106 + 836) <= (2670 + 2317)) and (v60 == v15.Warrior.Protection.Charge)) then
			return v66 and (v60:Charges() >= (4 - 3)) and not v13:IsInRange(25 - 17);
		elseif (((6323 - (404 + 1335)) == (4990 - (183 + 223))) and ((v60 == v15.Warrior.Protection.HeroicThrow) or (v60 == v15.Warrior.Protection.TitanicThrow))) then
			return v66 and not v13:IsInRange(9 - 1);
		elseif (((2637 + 1342) >= (601 + 1067)) and (v60 == v15.Warrior.Protection.Avatar)) then
			return v66 and (v12:BuffDown(v15.Warrior.Protection.AvatarBuff));
		elseif (((905 - (10 + 327)) > (299 + 129)) and (v60 == v15.Warrior.Protection.Intervene)) then
			return v66 and (v12:IsInParty() or v12:IsInRaid());
		else
			return v66;
		end
	end, 411 - (118 + 220));
end;
return v0["Epix_Warrior_Warrior.lua"]();

