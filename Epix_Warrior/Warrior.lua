local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 590 - (294 + 296);
	local v6;
	while true do
		if (((6388 - 3168) > (2353 - 1623)) and (v5 == (30 - (5 + 25)))) then
			v6 = v0[v4];
			if (((2781 - (1069 + 118)) > (194 - 108)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (1 + 0)) or ((5461 - 2387) == (503 + 4))) then
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
	if (not v16.Warrior or ((1161 - (368 + 423)) > (9921 - 6764))) then
		v16.Warrior = {};
	end
	v16.Warrior.Commons = {AncestralCall=v16(274756 - (10 + 8), nil, 3 - 2),ArcaneTorrent=v16(51055 - (416 + 26), nil, 6 - 4),BagofTricks=v16(134072 + 178339, nil, 4 - 1),Berserking=v16(26735 - (145 + 293), nil, 434 - (44 + 386)),BloodFury=v16(22058 - (998 + 488), nil, 2 + 3),Fireblood=v16(217169 + 48052, nil, 778 - (201 + 571)),LightsJudgment=v16(256785 - (116 + 1022), nil, 29 - 22),WarStomp=v16(12062 + 8487, nil, 29 - 21),BattleShout=v16(23696 - 17023, nil, 868 - (814 + 45)),Charge=v16(246 - 146, nil, 1 + 9),Hamstring=v16(606 + 1109, nil, 1058 - (261 + 624)),HeroicThrow=v16(102636 - 44881, nil, 1091 - (1020 + 60)),IgnorePain=v16(191879 - (630 + 793), nil, 243 - 171),Pummel=v16(31022 - 24470, nil, 5 + 7),Slam=v16(5040 - 3576, nil, 1760 - (760 + 987)),VictoryRush=v16(36341 - (1789 + 124), nil, 780 - (745 + 21)),DefensiveStance=v16(132843 + 253365, nil, 40 - 25),Avatar=v17(62 - 46, 880 + 106694, 314952 + 86198),AvatarBuff=v17(1072 - (87 + 968), 473534 - 365960, 363950 + 37200),BerserkerRage=v16(41817 - 23318, nil, 1431 - (447 + 966)),BerserkersTorment=v16(1068021 - 677898, nil, 1836 - (1703 + 114)),BitterImmunity=v16(384463 - (376 + 325), nil, 32 - 12),BloodandThunder=v16(1182411 - 798134, nil, 7 + 14),DoubleTime=v16(228677 - 124850, nil, 36 - (9 + 5)),CrushingForce=v16(383140 - (85 + 291), nil, 1288 - (243 + 1022)),FrothingBerserker=v16(820286 - 604715, nil, 20 + 4),ImmovableObject=v16(395487 - (1123 + 57), nil, 21 + 4),Intervene=v16(3665 - (163 + 91), nil, 2077 - (1869 + 61)),IntimidatingShout=v16(1466 + 3780, nil, 91 - 65),HeroicLeap=v16(10050 - 3506, nil, 4 + 23),ImpendingVictory=v16(277828 - 75660, nil, 27 + 1),OverwhelmingRage=v16(384241 - (1329 + 145), nil, 1000 - (140 + 831)),RallyingCry=v16(99312 - (1409 + 441), nil, 748 - (15 + 703)),RumblingEarth=v16(127511 + 147828, nil, 469 - (262 + 176)),Shockwave=v16(48689 - (345 + 1376), nil, 720 - (198 + 490)),SonicBoom=v16(1726207 - 1335482, nil, 78 - 45),ChampionsSpear=v16(377285 - (696 + 510), nil, 70 - 36),SpellReflection=v16(25182 - (1091 + 171), nil, 6 + 29),StormBolt=v16(338666 - 231096, nil, 119 - 83),ThunderClap=v17(411 - (123 + 251), 31518 - 25175, 397417 - (208 + 490)),ThunderousRoar=v16(32431 + 351887, nil, 17 + 21),TitanicThrow=v16(384926 - (660 + 176), nil, 5 + 34),WarMachineBuff=v16(262434 - (14 + 188), nil, 715 - (534 + 141)),WreckingThrow=v16(154419 + 229691, nil, 37 + 4),ChampionsMightBuff=v16(371393 + 14893, nil, 378 - 198),BattleShoutBuff=v16(10594 - 3921, nil, 117 - 75),AspectsFavorBuff=v16(218686 + 188568, nil, 28 + 15),Pool=v16(1000306 - (115 + 281), nil, 102 - 58)};
	v16.Warrior.Arms = v19(v16.Warrior.Commons, {BattleStance=v16(319722 + 66442, nil, 108 - 63),Execute=v17(168 - 122, 164068 - (550 + 317), 405983 - 124983),Whirlwind=v16(2361 - 681, nil, 131 - 84),AngerManagement=v16(152563 - (134 + 151), nil, 1713 - (970 + 695)),Battlelord=v16(737781 - 351151, nil, 2039 - (582 + 1408)),BattlelordBuff=v16(1340866 - 954235, nil, 62 - 12),BlademastersTorment=v16(1470179 - 1080041, nil, 1884 - (1195 + 629)),Bladestorm=v17(80 - 19, 228088 - (187 + 54), 390554 - (162 + 618)),Bloodletting=v16(268475 + 114679, nil, 117 + 58),Cleave=v16(1802 - 957, nil, 103 - 41),ColossusSmash=v17(5 + 58, 168741 - (1373 + 263), 263161 - (451 + 549)),ColossusSmashDebuff=v16(65685 + 142401, nil, 98 - 34),DieByTheSword=v16(198381 - 80343, nil, 1449 - (746 + 638)),Dreadnaught=v16(98657 + 163493, nil, 99 - 33),ExecutionersPrecision=v16(386975 - (218 + 123), nil, 1648 - (1535 + 46)),ExecutionersPrecisionDebuff=v16(384159 + 2474, nil, 10 + 58),FervorofBattle=v16(202876 - (306 + 254), nil, 5 + 64),Hurricane=v16(766495 - 375932, nil, 1537 - (899 + 568)),HurricaneBuff=v16(256729 + 133852, nil, 171 - 100),ImprovedSlam=v16(400808 - (268 + 335), nil, 466 - (60 + 230)),Juggernaut=v16(383864 - (426 + 146), nil, 9 + 64),JuggernautBuff=v16(384748 - (282 + 1174), nil, 885 - (569 + 242)),MartialProwessBuff=v16(21269 - 13885, nil, 5 + 70),Massacre=v16(282025 - (706 + 318), nil, 1327 - (721 + 530)),MercilessBonegrinder=v16(384588 - (945 + 326), nil, 191 - 114),MercilessBonegrinderBuff=v16(341082 + 42234, nil, 778 - (271 + 429)),MortalStrike=v16(11294 + 1000, nil, 1579 - (1408 + 92)),Overpower=v16(8470 - (461 + 625), nil, 1368 - (993 + 295)),Rend=v16(41 + 731, nil, 1252 - (418 + 753)),RendDebuff=v16(147977 + 240562, nil, 9 + 73),Skullsplitter=v16(76234 + 184409, nil, 21 + 62),StormofSwords=v16(386041 - (406 + 123), nil, 1853 - (1749 + 20)),SuddenDeath=v16(7061 + 22664, nil, 1407 - (1249 + 73)),SuddenDeathBuff=v16(18708 + 33729, nil, 1231 - (466 + 679)),SweepingStrikes=v16(627125 - 366417, nil, 248 - 161),SweepingStrikesBuff=v16(262608 - (106 + 1794), nil, 28 + 60),TestofMight=v16(97322 + 287686, nil, 262 - 173),TestofMightBuff=v16(1042592 - 657579, nil, 204 - (4 + 110)),TideofBlood=v16(386941 - (57 + 527), nil, 1518 - (41 + 1386)),Unhinged=v16(386731 - (17 + 86), nil, 63 + 29),Warbreaker=v16(584648 - 322487, nil, 269 - 176),WarlordsTorment=v16(390306 - (122 + 44), nil, 161 - 67),CrushingAdvanceBuff=v16(1360620 - 950482, nil, 78 + 17),DeepWoundsDebuff=v16(37908 + 224207, nil, 194 - 98)});
	v16.Warrior.Fury = v19(v16.Warrior.Commons, {BerserkerStance=v16(386261 - (30 + 35), nil, 67 + 30),Bloodbath=v16(336353 - (1043 + 214), nil, 370 - 272),CrushingBlow=v16(336309 - (323 + 889), nil, 266 - 167),Execute=v17(680 - (361 + 219), 5628 - (53 + 267), 63424 + 217311),Whirlwind=v16(190824 - (15 + 398), nil, 1083 - (18 + 964)),AngerManagement=v16(573192 - 420914, nil, 60 + 42),Annihilator=v16(241881 + 142035, nil, 953 - (20 + 830)),AshenJuggernaut=v16(306410 + 86126, nil, 230 - (116 + 10)),Bloodthirst=v16(1765 + 22116, nil, 844 - (542 + 196)),ColdSteelHotBlood=v16(823096 - 439137, nil, 32 + 75),DancingBlades=v16(199002 + 192681, nil, 39 + 69),EnragedRegeneration=v16(485815 - 301451, nil, 282 - 172),Frenzy=v16(336628 - (1126 + 425), nil, 516 - (118 + 287)),FrenzyBuff=v16(1313284 - 978202, nil, 1233 - (118 + 1003)),ImprovedWhilwind=v16(37897 - 24947, nil, 490 - (142 + 235)),Massacre=v16(935951 - 729636, nil, 39 + 139),MeatCleaver=v16(281369 - (553 + 424), nil, 215 - 101),OdynsFury=v16(339205 + 45854, nil, 116 + 0),Onslaught=v16(183830 + 131890, nil, 50 + 67),RagingBlow=v16(48706 + 36582, nil, 255 - 137),Rampage=v16(513704 - 329337, nil, 266 - 147),Ravager=v16(66569 + 162351, nil, 579 - 459),RecklessAbandon=v16(397502 - (239 + 514), nil, 43 + 78),Recklessness=v16(3048 - (797 + 532), nil, 89 + 33),StormofSwords=v16(131198 + 257705, nil, 291 - 167),SuddenDeath=v16(281923 - (373 + 829), nil, 856 - (476 + 255)),Tenderize=v16(390063 - (369 + 761), nil, 74 + 53),TitanicRage=v16(716254 - 321925, nil, 242 - 114),TitansTorment=v16(390373 - (64 + 174), nil, 19 + 110),WrathandFury=v16(581914 - 188978, nil, 466 - (144 + 192)),AshenJuggernautBuff=v16(392753 - (42 + 174), nil, 79 + 26),BloodcrazeBuff=v16(326338 + 67613, nil, 56 + 75),DancingBladesBuff=v16(393192 - (363 + 1141), nil, 1689 - (1183 + 397)),EnrageBuff=v16(561261 - 376899, nil, 97 + 35),FuriousBloodthirstBuff=v16(316333 + 106878, nil, 2149 - (1913 + 62)),MeatCleaverBuff=v16(53997 + 31742, nil, 304 - 189),MercilessAssaultBuff=v16(411916 - (565 + 1368), nil, 500 - 367),RecklessnessBuff=v16(3380 - (1477 + 184), nil, 166 - 43),SuddenDeathBuff=v16(261614 + 19162, nil, 982 - (564 + 292)),GushingWoundDebuff=v16(664361 - 279319, nil, 539 - 360)});
	v16.Warrior.Protection = v19(v16.Warrior.Commons, {BattleStance=v16(386468 - (244 + 60), nil, 104 + 30),Devastate=v16(20719 - (41 + 435), nil, 1136 - (938 + 63)),Execute=v16(125515 + 37686, nil, 1261 - (936 + 189)),ShieldBlock=v16(845 + 1720, nil, 1750 - (1565 + 48)),ShieldSlam=v16(14778 + 9144, nil, 1276 - (782 + 356)),BarbaricTraining=v16(390942 - (176 + 91), nil, 361 - 222),Bolster=v16(412668 - 132667, nil, 1232 - (975 + 117)),BoomingVoice=v16(204618 - (157 + 1718), nil, 115 + 26),ChampionsBulwark=v16(1371435 - 985107, nil, 485 - 343),DemoralizingShout=v16(2178 - (697 + 321), nil, 389 - 246),EnduringDefenses=v16(817841 - 431814, nil, 331 - 187),HeavyRepercussions=v16(79086 + 124091, nil, 271 - 126),ImpenetrableWall=v16(1029586 - 645514, nil, 1375 - (322 + 905)),Juggernaut=v16(394578 - (602 + 9), nil, 1338 - (449 + 740)),LastStand=v16(13847 - (826 + 46), nil, 1097 - (245 + 702)),Massacre=v16(887951 - 606950, nil, 49 + 102),Ravager=v16(230818 - (260 + 1638), nil, 592 - (382 + 58)),Rend=v16(1264179 - 870117, nil, 128 + 25),Revenge=v16(13581 - 7009, nil, 457 - 303),SeismicReverberation=v16(384161 - (902 + 303), nil, 339 - 184),ShieldCharge=v16(929566 - 543614, nil, 14 + 142),ShieldWall=v16(2561 - (1121 + 569), nil, 371 - (22 + 192)),SuddenDeath=v16(30408 - (483 + 200), nil, 1621 - (1404 + 59)),SuddenDeathBuff=v16(143506 - 91069, nil, 212 - 53),UnnervingFocus=v16(384807 - (468 + 297), nil, 722 - (334 + 228)),UnstoppableForce=v16(928704 - 653368, nil, 372 - 211),AvatarBuff=v16(727543 - 326393, nil, 47 + 115),EarthenTenacityBuff=v16(410454 - (141 + 95), nil, 161 + 2),FervidBuff=v16(1095283 - 669766, nil, 425 - 248),LastStandBuff=v16(3040 + 9935, nil, 449 - 285),RallyingCryBuff=v16(68516 + 28947, nil, 86 + 79),RevengeBuff=v16(7465 - 2163, nil, 98 + 68),SeeingRedBuff=v16(386649 - (92 + 71), nil, 83 + 84),ShieldBlockBuff=v16(222610 - 90206, nil, 933 - (574 + 191)),ShieldWallBuff=v16(719 + 152, nil, 423 - 254),ViolentOutburstBuff=v16(197409 + 189069, nil, 1019 - (254 + 595)),VanguardsDeterminationBuff=v16(394182 - (55 + 71), nil, 224 - 53),RendDebuff=v16(390329 - (573 + 1217), nil, 476 - 304)});
	if (((23 + 279) <= (808 - 306)) and not v18.Warrior) then
		v18.Warrior = {};
	end
	v18.Warrior.Commons = {Healthstone=v18(6451 - (714 + 225)),RefreshingHealingPotion=v18(559289 - 367909),DreamwalkersHealingPotion=v18(288623 - 81600),AlgetharPuzzleBox=v18(20971 + 172730, {(819 - (118 + 688)),(3 + 11)}),ManicGrieftorch=v18(196194 - (927 + 959), {(745 - (16 + 716)),(111 - (11 + 86))}),FyralathTheDreamrender=v18(503561 - 297113)};
	v18.Warrior.Arms = v19(v18.Warrior.Commons, {});
	v18.Warrior.Fury = v19(v18.Warrior.Commons, {});
	v18.Warrior.Protection = v19(v18.Warrior.Commons, {});
	if (not v21.Warrior or ((5102 - (175 + 110)) < (10439 - 6304))) then
		v21.Warrior = {};
	end
	v21.Warrior.Commons = {Healthstone=v21(44 - 35),RefreshingHealingPotion=v21(1806 - (503 + 1293)),UseWeapon=v21(58 - 37),InterveneFocus=v21(8 + 3),PummelMouseover=v21(1073 - (810 + 251)),StormBoltMouseover=v21(10 + 3),ChampionsSpearPlayer=v21(5 + 9),ChampionsSpearCursor=v21(14 + 1),IntimidatingShoutMouseover=v21(549 - (43 + 490))};
	v21.Warrior.Arms = v19(v21.Warrior.Commons, {});
	v21.Warrior.Fury = v19(v21.Warrior.Commons, {RavagerPlayer=v21(750 - (711 + 22)),RavagerCursor=v21(69 - 51)});
	v21.Warrior.Protection = v19(v21.Warrior.Commons, {RavagerPlayer=v21(878 - (240 + 619)),RavagerCursor=v21(5 + 15)});
	local v34;
	v34 = v10.AddCoreOverride("Spell.IsCastable", function(v38, v39, v40, v41, v42, v43)
		local v44 = v34(v38, v39, v40, v41, v42, v43);
		if (((431 - 159) == (19 + 253)) and (v38 == v16.Warrior.Arms.Charge)) then
			return v44 and (v38:Charges() >= (1745 - (1344 + 400))) and ((v13:AffectingCombat() and not v14:IsInRange(413 - (255 + 150)) and v14:IsInRange(20 + 5)) or not v13:AffectingCombat());
		else
			return v44;
		end
	end, 39 + 32);
	local v35;
	v35 = v10.AddCoreOverride("Spell.IsCastable", function(v45, v46, v47, v48, v49, v50)
		local v51 = 0 - 0;
		local v52;
		while true do
			if (((322 - 222) <= (4862 - (404 + 1335))) and (v51 == (406 - (183 + 223)))) then
				v52 = v35(v45, v46, v47, v48, v49, v50);
				if ((v45 == v16.Warrior.Fury.Charge) or ((1665 - 296) > (3305 + 1682))) then
					return v52 and (v45:Charges() >= (1 + 0)) and ((v13:AffectingCombat() and not v14:IsInRange(345 - (10 + 327)) and v14:IsInRange(18 + 7)) or not v13:AffectingCombat());
				else
					return v52;
				end
				break;
			end
		end
	end, 410 - (118 + 220));
	local v36;
	v36 = v10.AddCoreOverride("Spell.IsReady", function(v53, v54, v55, v56, v57, v58)
		local v59 = 0 + 0;
		local v60;
		while true do
			if ((v59 == (449 - (108 + 341))) or ((388 + 475) >= (19380 - 14796))) then
				v60 = v36(v53, v54, v55, v56, v57, v58);
				if ((v53 == v16.Warrior.Fury.Rampage) or ((2217 - (711 + 782)) >= (3197 - 1529))) then
					if (((897 - (270 + 199)) < (585 + 1219)) and v13:PrevGCDP(1820 - (580 + 1239), v16.Warrior.Fury.Bladestorm)) then
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
	end, 213 - 141);
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v61, v62, v63, v64, v65, v66)
		local v67 = v37(v61, v62, v63, v64, v65, v66);
		if ((v61 == v16.Warrior.Protection.Charge) or ((3180 + 145) > (166 + 4447))) then
			return v67 and (v61:Charges() >= (1 + 0)) and not v14:IsInRange(20 - 12);
		elseif ((v61 == v16.Warrior.Protection.HeroicThrow) or (v61 == v16.Warrior.Protection.TitanicThrow) or ((3076 + 1874) <= (5720 - (645 + 522)))) then
			return v67 and not v14:IsInRange(1798 - (1010 + 780));
		elseif (((2664 + 1) <= (18736 - 14803)) and (v61 == v16.Warrior.Protection.Avatar)) then
			return v67 and (v13:BuffDown(v16.Warrior.Protection.AvatarBuff));
		elseif (((9591 - 6318) == (5109 - (1045 + 791))) and (v61 == v16.Warrior.Protection.Intervene)) then
			return v67 and (v13:IsInParty() or v13:IsInRaid());
		else
			return v67;
		end
	end, 184 - 111);
end;
return v0["Epix_Warrior_Warrior.lua"]();

