local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 76 - (46 + 30);
	local v6;
	while true do
		if ((v5 == (3 - 2)) or ((2999 - (666 + 739)) > (5895 - 3715))) then
			return v6(...);
		end
		if (((5461 - 2387) == (3050 + 24)) and (v5 == (791 - (368 + 423)))) then
			v6 = v0[v4];
			if (((1162 - 792) >= (214 - (10 + 8))) and not v6) then
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
	if (not v16.Warrior or ((3610 - (416 + 26)) < (1602 - 1100))) then
		v16.Warrior = {};
	end
	v16.Warrior.Commons = {AncestralCall=v16(117905 + 156833, nil, 1 - 0),ArcaneTorrent=v16(51051 - (145 + 293), nil, 432 - (44 + 386)),BagofTricks=v16(313897 - (998 + 488), nil, 1 + 2),Berserking=v16(21533 + 4764, nil, 776 - (201 + 571)),BloodFury=v16(21710 - (116 + 1022), nil, 20 - 15),Fireblood=v16(155679 + 109542, nil, 21 - 15),LightsJudgment=v16(907824 - 652177, nil, 866 - (814 + 45)),WarStomp=v16(50631 - 30082, nil, 1 + 7),BattleShout=v16(2358 + 4315, nil, 894 - (261 + 624)),Charge=v16(177 - 77, nil, 1090 - (1020 + 60)),Hamstring=v16(3138 - (630 + 793), nil, 585 - 412),HeroicThrow=v16(273455 - 215700, nil, 5 + 6),IgnorePain=v16(655748 - 465292, nil, 1819 - (760 + 987)),Pummel=v16(8465 - (1789 + 124), nil, 778 - (745 + 21)),Slam=v16(504 + 960, nil, 35 - 22),VictoryRush=v16(135044 - 100616, nil, 1 + 13),DefensiveStance=v16(303221 + 82987, nil, 1070 - (87 + 968)),Avatar=v17(70 - 54, 97599 + 9975, 906819 - 505669),AvatarBuff=v17(1430 - (447 + 966), 294500 - 186926, 402967 - (1703 + 114)),BerserkerRage=v16(19200 - (376 + 325), nil, 29 - 11),BerserkersTorment=v16(1200399 - 810276, nil, 6 + 13),BitterImmunity=v16(845229 - 461467, nil, 34 - (9 + 5)),BloodandThunder=v16(384653 - (85 + 291), nil, 1286 - (243 + 1022)),DoubleTime=v16(395080 - 291253, nil, 19 + 3),CrushingForce=v16(383944 - (1123 + 57), nil, 19 + 4),FrothingBerserker=v16(215825 - (163 + 91), nil, 1954 - (1869 + 61)),ImmovableObject=v16(110159 + 284148, nil, 87 - 62),Intervene=v16(5238 - 1827, nil, 21 + 126),IntimidatingShout=v16(7208 - 1962, nil, 25 + 1),HeroicLeap=v16(8018 - (1329 + 145), nil, 998 - (140 + 831)),ImpendingVictory=v16(204018 - (1409 + 441), nil, 746 - (15 + 703)),OverwhelmingRage=v16(177262 + 205505, nil, 467 - (262 + 176)),RallyingCry=v16(99183 - (345 + 1376), nil, 718 - (198 + 490)),RumblingEarth=v16(1216436 - 941097, nil, 74 - 43),Shockwave=v16(48174 - (696 + 510), nil, 66 - 34),SonicBoom=v16(391987 - (1091 + 171), nil, 6 + 27),SpearofBastion=v16(1184024 - 807945, nil, 112 - 78),SpellReflection=v16(24294 - (123 + 251), nil, 173 - 138),StormBolt=v16(108268 - (208 + 490), nil, 4 + 32),ThunderClap=v17(17 + 20, 7179 - (660 + 176), 47664 + 349055),ThunderousRoar=v16(384520 - (14 + 188), nil, 713 - (534 + 141)),TitanicThrow=v16(154411 + 229679, nil, 35 + 4),WarMachineBuff=v16(252122 + 10110, nil, 84 - 44),WreckingThrow=v16(609820 - 225710, nil, 114 - 73),BattleShoutBuff=v16(3584 + 3089, nil, 27 + 15),AspectsFavorBuff=v16(407650 - (115 + 281), nil, 99 - 56),Pool=v16(827868 + 172042, nil, 105 - 61)};
	v16.Warrior.Arms = v19(v16.Warrior.Commons, {BattleStance=v16(1415986 - 1029822, nil, 912 - (550 + 317)),Execute=v17(66 - 20, 229390 - 66189, 785248 - 504248),Whirlwind=v16(1965 - (134 + 151), nil, 1712 - (970 + 695)),AngerManagement=v16(290582 - 138304, nil, 2038 - (582 + 1408)),Battlelord=v16(1340862 - 954232, nil, 60 - 11),BattlelordBuff=v16(1456963 - 1070332, nil, 1874 - (1195 + 629)),BlademastersTorment=v16(515956 - 125818, nil, 301 - (187 + 54)),Bladestorm=v17(841 - (162 + 618), 159652 + 68195, 259605 + 130169),Bloodletting=v16(817152 - 433998, nil, 294 - 119),Cleave=v16(67 + 778, nil, 1698 - (1373 + 263)),ColossusSmash=v17(1063 - (451 + 549), 52749 + 114356, 407988 - 145827),ColossusSmashDebuff=v16(349721 - 141635, nil, 1448 - (746 + 638)),DieByTheSword=v16(44423 + 73615, nil, 98 - 33),Dreadnaught=v16(262491 - (218 + 123), nil, 1647 - (1535 + 46)),ExecutionersPrecision=v16(384160 + 2474, nil, 10 + 57),ExecutionersPrecisionDebuff=v16(387193 - (306 + 254), nil, 5 + 63),FervorofBattle=v16(397053 - 194737, nil, 1536 - (899 + 568)),Hurricane=v16(256717 + 133846, nil, 169 - 99),HurricaneBuff=v16(391184 - (268 + 335), nil, 361 - (60 + 230)),ImprovedSlam=v16(400777 - (426 + 146), nil, 22 + 154),Juggernaut=v16(384748 - (282 + 1174), nil, 884 - (569 + 242)),JuggernautBuff=v16(1104108 - 720816, nil, 5 + 69),MartialProwessBuff=v16(8408 - (706 + 318), nil, 1326 - (721 + 530)),Massacre=v16(282272 - (945 + 326), nil, 189 - 113),MercilessBonegrinder=v16(341083 + 42234, nil, 777 - (271 + 429)),MercilessBonegrinderBuff=v16(352115 + 31201, nil, 1578 - (1408 + 92)),MortalStrike=v16(13380 - (461 + 625), nil, 1367 - (993 + 295)),Overpower=v16(384 + 7000, nil, 1251 - (418 + 753)),Rend=v16(295 + 477, nil, 9 + 72),RendDebuff=v16(113642 + 274897, nil, 21 + 61),Skullsplitter=v16(261172 - (406 + 123), nil, 1852 - (1749 + 20)),StormofSwords=v16(91570 + 293942, nil, 1406 - (1249 + 73)),SuddenDeath=v16(10605 + 19120, nil, 1230 - (466 + 679)),SuddenDeathBuff=v16(126135 - 73698, nil, 245 - 159),SweepingStrikes=v16(262608 - (106 + 1794), nil, 28 + 59),SweepingStrikesBuff=v16(65902 + 194806, nil, 259 - 171),TestofMight=v16(1042578 - 657570, nil, 203 - (4 + 110)),TestofMightBuff=v16(385597 - (57 + 527), nil, 1517 - (41 + 1386)),TideofBlood=v16(386460 - (17 + 86), nil, 62 + 29),Unhinged=v16(862224 - 475596, nil, 266 - 174),Warbreaker=v16(262327 - (122 + 44), nil, 160 - 67),WarlordsTorment=v16(1294278 - 904138, nil, 77 + 17),CrushingAdvanceBuff=v16(59316 + 350822, nil, 192 - 97),DeepWoundsDebuff=v16(262180 - (30 + 35), nil, 66 + 30)});
	v16.Warrior.Fury = v19(v16.Warrior.Commons, {BerserkerStance=v16(387453 - (1043 + 214), nil, 366 - 269),Bloodbath=v16(336308 - (323 + 889), nil, 263 - 165),CrushingBlow=v16(335677 - (361 + 219), nil, 419 - (53 + 267)),Execute=v17(23 + 77, 5721 - (15 + 398), 281717 - (18 + 964)),Whirlwind=v16(716729 - 526318, nil, 59 + 42),AngerManagement=v16(95941 + 56337, nil, 952 - (20 + 830)),Annihilator=v16(299681 + 84235, nil, 229 - (116 + 10)),AshenJuggernaut=v16(28996 + 363540, nil, 842 - (542 + 196)),AshenJuggernautBuff=v16(841484 - 448947, nil, 31 + 74),Bloodthirst=v16(12134 + 11747, nil, 39 + 67),ColdSteelHotBlood=v16(1011766 - 627807, nil, 274 - 167),DancingBlades=v16(393234 - (1126 + 425), nil, 513 - (118 + 287)),DancingBladesBuff=v16(1535139 - 1143451, nil, 1230 - (118 + 1003)),EnragedRegeneration=v16(539528 - 355164, nil, 487 - (142 + 235)),Frenzy=v16(1520083 - 1185006, nil, 25 + 86),FrenzyBuff=v16(336059 - (553 + 424), nil, 211 - 99),ImprovedWhilwind=v16(11408 + 1542, nil, 113 + 0),MeatCleaver=v16(163260 + 117132, nil, 49 + 65),MeatCleaverBuff=v16(48963 + 36776, nil, 249 - 134),OdynsFury=v16(1072895 - 687836, nil, 259 - 143),Onslaught=v16(91809 + 223911, nil, 565 - 448),RagingBlow=v16(86041 - (239 + 514), nil, 42 + 76),Rampage=v16(185696 - (797 + 532), nil, 87 + 32),Ravager=v16(77227 + 151693, nil, 282 - 162),RecklessAbandon=v16(397951 - (373 + 829), nil, 852 - (476 + 255)),Recklessness=v16(2849 - (369 + 761), nil, 71 + 51),RecklessnessBuff=v16(3121 - 1402, nil, 232 - 109),StormofSwords=v16(389141 - (64 + 174), nil, 18 + 106),SuddenDeath=v16(415730 - 135009, nil, 461 - (144 + 192)),SuddenDeathBuff=v16(280992 - (42 + 174), nil, 95 + 31),Tenderize=v16(322182 + 66751, nil, 54 + 73),TitanicRage=v16(395833 - (363 + 1141), nil, 1708 - (1183 + 397)),TitansTorment=v16(1187705 - 797570, nil, 95 + 34),WrathandFury=v16(293703 + 99233, nil, 2105 - (1913 + 62)),BloodcrazeBuff=v16(248102 + 145849, nil, 346 - 215),EnrageBuff=v16(186295 - (565 + 1368), nil, 496 - 364),FuriousBloodthirstBuff=v16(424872 - (1477 + 184), nil, 236 - 62),MercilessAssaultBuff=v16(382003 + 27980, nil, 989 - (564 + 292))});
	v16.Warrior.Protection = v19(v16.Warrior.Commons, {BattleStance=v16(666297 - 280133, nil, 403 - 269),Devastate=v16(20547 - (244 + 60), nil, 104 + 31),Execute=v16(163677 - (41 + 435), nil, 1137 - (938 + 63)),ShieldBlock=v16(1973 + 592, nil, 1262 - (936 + 189)),ShieldSlam=v16(7873 + 16049, nil, 1751 - (1565 + 48)),BarbaricTraining=v16(241327 + 149348, nil, 1277 - (782 + 356)),Bolster=v16(280268 - (176 + 91), nil, 364 - 224),BoomingVoice=v16(298804 - 96061, nil, 1233 - (975 + 117)),ChampionsBulwark=v16(388203 - (157 + 1718), nil, 116 + 26),DemoralizingShout=v16(4117 - 2957, nil, 488 - 345),EnduringDefenses=v16(387045 - (697 + 321), nil, 391 - 247),HeavyRepercussions=v16(430453 - 227276, nil, 334 - 189),ImpenetrableWall=v16(149498 + 234574, nil, 276 - 128),Juggernaut=v16(1056111 - 662144, nil, 1376 - (322 + 905)),LastStand=v16(13586 - (602 + 9), nil, 1339 - (449 + 740)),Massacre=v16(281873 - (826 + 46), nil, 1098 - (245 + 702)),Ravager=v16(723377 - 494457, nil, 49 + 103),Rend=v16(395960 - (260 + 1638), nil, 593 - (382 + 58)),Revenge=v16(21083 - 14511, nil, 128 + 26),SeismicReverberation=v16(791454 - 408498, nil, 460 - 305),ShieldCharge=v16(387157 - (902 + 303), nil, 341 - 185),ShieldWall=v16(2097 - 1226, nil, 14 + 143),SuddenDeath=v16(31415 - (1121 + 569), nil, 372 - (22 + 192)),SuddenDeathBuff=v16(53120 - (483 + 200), nil, 1622 - (1404 + 59)),UnnervingFocus=v16(1051022 - 666980, nil, 215 - 55),UnstoppableForce=v16(276101 - (468 + 297), nil, 723 - (334 + 228)),AvatarBuff=v16(1353074 - 951924, nil, 374 - 212),EarthenTenacityBuff=v16(743989 - 333771, nil, 47 + 116),FervidBuff=v16(425753 - (141 + 95), nil, 174 + 3),LastStandBuff=v16(33397 - 20422, nil, 393 - 229),RallyingCryBuff=v16(22830 + 74633, nil, 452 - 287),RevengeBuff=v16(3728 + 1574, nil, 87 + 79),SeeingRedBuff=v16(544266 - 157780, nil, 99 + 68),ShieldBlockBuff=v16(132567 - (92 + 71), nil, 83 + 85),ShieldWallBuff=v16(1464 - 593, nil, 934 - (574 + 191)),ViolentOutburstBuff=v16(318792 + 67686, nil, 425 - 255),VanguardsDeterminationBuff=v16(201280 + 192776, nil, 1020 - (254 + 595)),RendDebuff=v16(388665 - (55 + 71), nil, 225 - 53)});
	if (((2229 - (573 + 1217)) == (1215 - 776)) and not v18.Warrior) then
		v18.Warrior = {};
	end
	v18.Warrior.Commons = {Healthstone=v18(420 + 5092),RefreshingHealingPotion=v18(308389 - 117009),DreamwalkersHealingPotion=v18(207962 - (714 + 225)),AlgetharPuzzleBox=v18(566072 - 372371, {(2 + 11),(820 - (118 + 688))}),ManicGrieftorch=v18(194356 - (25 + 23), {(1899 - (927 + 959)),(746 - (16 + 716))})};
	v18.Warrior.Arms = v19(v18.Warrior.Commons, {});
	v18.Warrior.Fury = v19(v18.Warrior.Commons, {});
	v18.Warrior.Protection = v19(v18.Warrior.Commons, {});
	if (not v21.Warrior or ((2439 - 1175) < (369 - (11 + 86)))) then
		v21.Warrior = {};
	end
	v21.Warrior.Commons = {Healthstone=v21(21 - 12),RefreshingHealingPotion=v21(295 - (175 + 110)),InterveneFocus=v21(27 - 16),PummelMouseover=v21(59 - 47),StormBoltMouseover=v21(1809 - (503 + 1293)),SpearOfBastionPlayer=v21(39 - 25),SpearOfBastionCursor=v21(11 + 4),IntimidatingShoutMouseover=v21(1077 - (810 + 251))};
	v21.Warrior.Arms = v19(v21.Warrior.Commons, {});
	v21.Warrior.Fury = v19(v21.Warrior.Commons, {RavagerPlayer=v21(12 + 5),RavagerCursor=v21(6 + 12)});
	v21.Warrior.Protection = v19(v21.Warrior.Commons, {RavagerPlayer=v21(18 + 1),RavagerCursor=v21(553 - (43 + 490))});
	local v34;
	v34 = v10.AddCoreOverride("Spell.IsCastable", function(v38, v39, v40, v41, v42, v43)
		local v44 = 733 - (711 + 22);
		local v45;
		while true do
			if (((12080 - 8957) < (4750 - (240 + 619))) and (v44 == (0 + 0))) then
				v45 = v34(v38, v39, v40, v41, v42, v43);
				if (((6269 - 2327) <= (331 + 4656)) and (v38 == v16.Warrior.Arms.Charge)) then
					return v45 and (v38:Charges() >= (1745 - (1344 + 400))) and ((v13:AffectingCombat() and not v14:IsInRange(413 - (255 + 150)) and v14:IsInRange(20 + 5)) or not v13:AffectingCombat());
				else
					return v45;
				end
				break;
			end
		end
	end, 39 + 32);
	local v35;
	v35 = v10.AddCoreOverride("Spell.IsCastable", function(v46, v47, v48, v49, v50, v51)
		local v52 = 0 - 0;
		local v53;
		while true do
			if (((14805 - 10221) == (6323 - (404 + 1335))) and (v52 == (406 - (183 + 223)))) then
				v53 = v35(v46, v47, v48, v49, v50, v51);
				if (((4841 - 862) >= (1106 + 562)) and (v46 == v16.Warrior.Fury.Charge)) then
					return v53 and (v46:Charges() >= (1 + 0)) and ((v13:AffectingCombat() and not v14:IsInRange(345 - (10 + 327)) and v14:IsInRange(18 + 7)) or not v13:AffectingCombat());
				else
					return v53;
				end
				break;
			end
		end
	end, 410 - (118 + 220));
	local v36;
	v36 = v10.AddCoreOverride("Spell.IsReady", function(v54, v55, v56, v57, v58, v59)
		local v60 = 0 + 0;
		local v61;
		while true do
			if (((1017 - (108 + 341)) > (193 + 235)) and (v60 == (0 - 0))) then
				v61 = v36(v54, v55, v56, v57, v58, v59);
				if (((2827 - (711 + 782)) <= (8843 - 4230)) and (v54 == v16.Warrior.Fury.Rampage)) then
					if (v13:PrevGCDP(470 - (270 + 199), v16.Warrior.Fury.Bladestorm) or ((605 + 1260) >= (3848 - (580 + 1239)))) then
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
	end, 213 - 141);
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v62, v63, v64, v65, v66, v67)
		local v68 = 0 + 0;
		local v69;
		while true do
			if (((178 + 4772) >= (704 + 912)) and (v68 == (0 - 0))) then
				v69 = v37(v62, v63, v64, v65, v66, v67);
				if (((1072 + 653) == (2892 - (645 + 522))) and (v62 == v16.Warrior.Protection.Charge)) then
					return v69 and (v62:Charges() >= (1791 - (1010 + 780))) and not v14:IsInRange(8 + 0);
				elseif (((6950 - 5491) <= (7273 - 4791)) and ((v62 == v16.Warrior.Protection.HeroicThrow) or (v62 == v16.Warrior.Protection.TitanicThrow))) then
					return v69 and not v14:IsInRange(1844 - (1045 + 791));
				elseif ((v62 == v16.Warrior.Protection.Avatar) or ((6824 - 4128) >= (6919 - 2387))) then
					return v69 and (v13:BuffDown(v16.Warrior.Protection.AvatarBuff));
				elseif (((1553 - (351 + 154)) >= (1626 - (1281 + 293))) and (v62 == v16.Warrior.Protection.Intervene)) then
					return v69 and (v13:IsInParty() or v13:IsInRaid());
				else
					return v69;
				end
				break;
			end
		end
	end, 339 - (28 + 238));
end;
return v0["Epix_Warrior_Warrior.lua"]();

