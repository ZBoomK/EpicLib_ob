local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((5520 - (1228 + 618)) >= (1038 - 522)) and (v5 == (3 - 2))) then
			return v6(...);
		end
		if (((3267 - (802 + 150)) == (6232 - 3917)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((2288 + 855) > (4745 - (915 + 82)))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
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
	if (not v16.Warrior or ((929 + 665) > (2867 - 687))) then
		v16.Warrior = {};
	end
	v16.Warrior.Commons = {AncestralCall=v16(275925 - (1069 + 118), nil, 2 - 1),ArcaneTorrent=v16(110714 - 60101, nil, 1 + 1),BagofTricks=v16(555091 - 242680, nil, 3 + 0),Berserking=v16(27088 - (368 + 423), nil, 12 - 8),BloodFury=v16(20590 - (10 + 8), nil, 19 - 14),Fireblood=v16(265663 - (416 + 26), nil, 19 - 13),LightsJudgment=v16(109712 + 145935, nil, 12 - 5),WarStomp=v16(20987 - (145 + 293), nil, 438 - (44 + 386)),BattleShout=v16(8159 - (998 + 488), nil, 3 + 6),Charge=v16(82 + 18, nil, 782 - (201 + 571)),Hamstring=v16(2853 - (116 + 1022), nil, 720 - 547),HeroicThrow=v16(33901 + 23854, nil, 40 - 29),IgnorePain=v16(676326 - 485870, nil, 931 - (814 + 45)),Pummel=v16(16143 - 9591, nil, 1 + 11),Slam=v16(518 + 946, nil, 898 - (261 + 624)),VictoryRush=v16(61181 - 26753, nil, 1094 - (1020 + 60)),DefensiveStance=v16(387631 - (630 + 793), nil, 50 - 35),Avatar=v17(75 - 59, 42367 + 65207, 1381177 - 980027),AvatarBuff=v17(1764 - (760 + 987), 109487 - (1789 + 124), 401916 - (745 + 21)),BerserkerRage=v16(6364 + 12135, nil, 49 - 31),BerserkersTorment=v16(1530263 - 1140140, nil, 1 + 18),BitterImmunity=v16(301301 + 82461, nil, 1075 - (87 + 968)),BloodandThunder=v16(1691565 - 1307288, nil, 20 + 1),DoubleTime=v16(234705 - 130878, nil, 1435 - (447 + 966)),CrushingForce=v16(1047874 - 665110, nil, 1840 - (1703 + 114)),FrothingBerserker=v16(216272 - (376 + 325), nil, 38 - 14),ImmovableObject=v16(1213273 - 818966, nil, 8 + 17),Intervene=v16(7512 - 4101, nil, 161 - (9 + 5)),IntimidatingShout=v16(5622 - (85 + 291), nil, 1291 - (243 + 1022)),HeroicLeap=v16(24900 - 18356, nil, 23 + 4),ImpendingVictory=v16(203348 - (1123 + 57), nil, 23 + 5),OverwhelmingRage=v16(383021 - (163 + 91), nil, 1959 - (1869 + 61)),RallyingCry=v16(27229 + 70233, nil, 105 - 75),RumblingEarth=v16(422907 - 147568, nil, 5 + 26),Shockwave=v16(64545 - 17577, nil, 31 + 1),SonicBoom=v16(392199 - (1329 + 145), nil, 1004 - (140 + 831)),SpearofBastion=v16(377929 - (1409 + 441), nil, 752 - (15 + 703)),SpellReflection=v16(11078 + 12842, nil, 473 - (262 + 176)),StormBolt=v16(109291 - (345 + 1376), nil, 724 - (198 + 490)),ThunderClap=v17(163 - 126, 15214 - 8871, 397925 - (696 + 510)),ThunderousRoar=v16(806024 - 421706, nil, 1300 - (1091 + 171)),TitanicThrow=v16(61809 + 322281, nil, 122 - 83),WarMachineBuff=v16(869648 - 607416, nil, 414 - (123 + 251)),WreckingThrow=v16(1908623 - 1524513, nil, 739 - (208 + 490)),BattleShoutBuff=v16(564 + 6109, nil, 19 + 23),AspectsFavorBuff=v16(408090 - (660 + 176), nil, 6 + 37),Pool=v16(1000112 - (14 + 188), nil, 719 - (534 + 141))};
	v16.Warrior.Arms = v19(v16.Warrior.Commons, {BattleStance=v16(155245 + 230919, nil, 40 + 5),Execute=v17(45 + 1, 342974 - 179773, 446121 - 165121),Whirlwind=v16(4712 - 3032, nil, 26 + 21),AngerManagement=v16(96958 + 55320, nil, 444 - (115 + 281)),Battlelord=v16(899315 - 512685, nil, 41 + 8),BattlelordBuff=v16(934391 - 547760, nil, 183 - 133),BlademastersTorment=v16(391005 - (550 + 317), nil, 86 - 26),Bladestorm=v17(85 - 24, 636713 - 408866, 390059 - (134 + 151)),Bloodletting=v16(384819 - (970 + 695), nil, 333 - 158),Cleave=v16(2835 - (582 + 1408), nil, 214 - 152),ColossusSmash=v17(78 - 15, 629711 - 462606, 263985 - (1195 + 629)),ColossusSmashDebuff=v16(275192 - 67106, nil, 305 - (187 + 54)),DieByTheSword=v16(118818 - (162 + 618), nil, 46 + 19),Dreadnaught=v16(174603 + 87547, nil, 140 - 74),ExecutionersPrecision=v16(650005 - 263371, nil, 6 + 61),ExecutionersPrecisionDebuff=v16(388269 - (1373 + 263), nil, 1068 - (451 + 549)),FervorofBattle=v16(63864 + 138452, nil, 106 - 37),Hurricane=v16(656404 - 265841, nil, 1454 - (746 + 638)),HurricaneBuff=v16(146991 + 243590, nil, 107 - 36),ImprovedSlam=v16(400546 - (218 + 123), nil, 1757 - (1535 + 46)),Juggernaut=v16(380840 + 2452, nil, 11 + 62),JuggernautBuff=v16(383852 - (306 + 254), nil, 5 + 69),MartialProwessBuff=v16(14491 - 7107, nil, 1542 - (899 + 568)),Massacre=v16(184702 + 96299, nil, 183 - 107),MercilessBonegrinder=v16(383920 - (268 + 335), nil, 367 - (60 + 230)),MercilessBonegrinderBuff=v16(383888 - (426 + 146), nil, 10 + 68),MortalStrike=v16(13750 - (282 + 1174), nil, 890 - (569 + 242)),Overpower=v16(21269 - 13885, nil, 5 + 75),Rend=v16(1796 - (706 + 318), nil, 1332 - (721 + 530)),RendDebuff=v16(389810 - (945 + 326), nil, 204 - 122),Skullsplitter=v16(231926 + 28717, nil, 783 - (271 + 429)),StormofSwords=v16(354133 + 31379, nil, 1584 - (1408 + 92)),SuddenDeath=v16(30811 - (461 + 625), nil, 1373 - (993 + 295)),SuddenDeathBuff=v16(2723 + 49714, nil, 1257 - (418 + 753)),SweepingStrikes=v16(99292 + 161416, nil, 9 + 78),SweepingStrikesBuff=v16(76253 + 184455, nil, 23 + 65),TestofMight=v16(385537 - (406 + 123), nil, 1858 - (1749 + 20)),TestofMightBuff=v16(91451 + 293562, nil, 1412 - (1249 + 73)),TideofBlood=v16(137840 + 248517, nil, 1236 - (466 + 679)),Unhinged=v16(930021 - 543393, nil, 263 - 171),Warbreaker=v16(264061 - (106 + 1794), nil, 30 + 63),WarlordsTorment=v16(98620 + 291520, nil, 277 - 183),CrushingAdvanceBuff=v16(1110629 - 700491, nil, 209 - (4 + 110)),DeepWoundsDebuff=v16(262699 - (57 + 527), nil, 1523 - (41 + 1386))});
	v16.Warrior.Fury = v19(v16.Warrior.Commons, {BerserkerStance=v16(386299 - (17 + 86), nil, 66 + 31),Bloodbath=v16(747302 - 412206, nil, 283 - 185),CrushingBlow=v16(335263 - (122 + 44), nil, 170 - 71),Execute=v17(331 - 231, 4318 + 990, 40601 + 240134),Whirlwind=v16(385745 - 195334, nil, 166 - (30 + 35)),AngerManagement=v16(104663 + 47615, nil, 1359 - (1043 + 214)),Annihilator=v16(1451454 - 1067538, nil, 1315 - (323 + 889)),AshenJuggernaut=v16(1056566 - 664030, nil, 684 - (361 + 219)),AshenJuggernautBuff=v16(392857 - (53 + 267), nil, 24 + 81),Bloodthirst=v16(24294 - (15 + 398), nil, 1088 - (18 + 964)),ColdSteelHotBlood=v16(1445267 - 1061308, nil, 62 + 45),DancingBlades=v16(246775 + 144908, nil, 958 - (20 + 830)),DancingBladesBuff=v16(305748 + 85940, nil, 235 - (116 + 10)),EnragedRegeneration=v16(13619 + 170745, nil, 848 - (542 + 196)),Frenzy=v16(718307 - 383230, nil, 33 + 78),FrenzyBuff=v16(170245 + 164837, nil, 41 + 71),ImprovedWhilwind=v16(34124 - 21174, nil, 289 - 176),Massacre=v16(207866 - (1126 + 425), nil, 583 - (118 + 287)),MeatCleaver=v16(1098938 - 818546, nil, 1235 - (118 + 1003)),MeatCleaverBuff=v16(250909 - 165170, nil, 492 - (142 + 235)),OdynsFury=v16(1746827 - 1361768, nil, 26 + 90),Onslaught=v16(316697 - (553 + 424), nil, 221 - 104),RagingBlow=v16(75132 + 10156, nil, 118 + 0),Rampage=v16(107349 + 77018, nil, 51 + 68),Ravager=v16(130730 + 98190, nil, 260 - 140),RecklessAbandon=v16(1105467 - 708718, nil, 270 - 149),Recklessness=v16(500 + 1219, nil, 589 - 467),RecklessnessBuff=v16(2472 - (239 + 514), nil, 44 + 79),StormofSwords=v16(390232 - (797 + 532), nil, 91 + 33),SuddenDeath=v16(94702 + 186019, nil, 293 - 168),SuddenDeathBuff=v16(281978 - (373 + 829), nil, 857 - (476 + 255)),Tenderize=v16(390063 - (369 + 761), nil, 74 + 53),TitanicRage=v16(716254 - 321925, nil, 242 - 114),TitansTorment=v16(390373 - (64 + 174), nil, 19 + 110),WrathandFury=v16(581914 - 188978, nil, 466 - (144 + 192)),BloodcrazeBuff=v16(394167 - (42 + 174), nil, 99 + 32),EnrageBuff=v16(152721 + 31641, nil, 57 + 75),FuriousBloodthirstBuff=v16(424715 - (363 + 1141), nil, 1754 - (1183 + 397)),MercilessAssaultBuff=v16(1248129 - 838146, nil, 98 + 35)});
	v16.Warrior.Protection = v19(v16.Warrior.Commons, {BattleStance=v16(288641 + 97523, nil, 2109 - (1913 + 62)),Devastate=v16(12749 + 7494, nil, 357 - 222),Execute=v16(165134 - (565 + 1368), nil, 511 - 375),ShieldBlock=v16(4226 - (1477 + 184), nil, 186 - 49),ShieldSlam=v16(22290 + 1632, nil, 994 - (564 + 292)),BarbaricTraining=v16(674080 - 283405, nil, 418 - 279),Bolster=v16(280305 - (244 + 60), nil, 108 + 32),BoomingVoice=v16(203219 - (41 + 435), nil, 1142 - (938 + 63)),ChampionsBulwark=v16(297116 + 89212, nil, 1267 - (936 + 189)),DemoralizingShout=v16(382 + 778, nil, 1756 - (1565 + 48)),EnduringDefenses=v16(238456 + 147571, nil, 1282 - (782 + 356)),HeavyRepercussions=v16(203444 - (176 + 91), nil, 377 - 232),ImpenetrableWall=v16(566049 - 181977, nil, 1240 - (975 + 117)),Juggernaut=v16(395842 - (157 + 1718), nil, 121 + 28),LastStand=v16(46060 - 33085, nil, 512 - 362),Massacre=v16(282019 - (697 + 321), nil, 411 - 260),Ravager=v16(484992 - 256072, nil, 350 - 198),Rend=v16(153386 + 240676, nil, 286 - 133),Revenge=v16(17617 - 11045, nil, 1381 - (322 + 905)),SeismicReverberation=v16(383567 - (602 + 9), nil, 1344 - (449 + 740)),ShieldCharge=v16(386824 - (826 + 46), nil, 1103 - (245 + 702)),ShieldWall=v16(2752 - 1881, nil, 51 + 106),SuddenDeath=v16(31623 - (260 + 1638), nil, 598 - (382 + 58)),SuddenDeathBuff=v16(168221 - 115784, nil, 133 + 26),UnnervingFocus=v16(793699 - 409657, nil, 475 - 315),UnstoppableForce=v16(276541 - (902 + 303), nil, 353 - 192),AvatarBuff=v16(966171 - 565021, nil, 14 + 148),EarthenTenacityBuff=v16(411908 - (1121 + 569), nil, 377 - (22 + 192)),FervidBuff=v16(426200 - (483 + 200), nil, 1640 - (1404 + 59)),LastStandBuff=v16(35509 - 22534, nil, 219 - 55),RallyingCryBuff=v16(98228 - (468 + 297), nil, 727 - (334 + 228)),RevengeBuff=v16(17883 - 12581, nil, 384 - 218),SeeingRedBuff=v16(700947 - 314461, nil, 48 + 119),ShieldBlockBuff=v16(132640 - (141 + 95), nil, 166 + 2),ShieldWallBuff=v16(2241 - 1370, nil, 405 - 236),ViolentOutburstBuff=v16(90528 + 295950, nil, 465 - 295),VanguardsDeterminationBuff=v16(277018 + 117038, nil, 90 + 81),RendDebuff=v16(547157 - 158618, nil, 102 + 70)});
	if (((3237 - (92 + 71)) == (1519 + 1555)) and not v18.Warrior) then
		v18.Warrior = {};
	end
	v18.Warrior.Commons = {Healthstone=v18(9266 - 3754),RefreshingHealingPotion=v18(192145 - (574 + 191)),DreamwalkersHealingPotion=v18(170766 + 36257),AlgetharPuzzleBox=v18(485280 - 291579, {(862 - (254 + 595)),(18 - 4)}),ManicGrieftorch=v18(196098 - (573 + 1217), {(1 + 12),(953 - (714 + 225))})};
	v18.Warrior.Arms = v19(v18.Warrior.Commons, {});
	v18.Warrior.Fury = v19(v18.Warrior.Commons, {});
	v18.Warrior.Protection = v19(v18.Warrior.Commons, {});
	if (((1081 - 711) >= (272 - 76)) and not v21.Warrior) then
		v21.Warrior = {};
	end
	v21.Warrior.Commons = {Healthstone=v21(1 + 8),RefreshingHealingPotion=v21(14 - 4),InterveneFocus=v21(817 - (118 + 688)),PummelMouseover=v21(60 - (25 + 23)),StormBoltMouseover=v21(3 + 10),SpearOfBastionPlayer=v21(1900 - (927 + 959)),SpearOfBastionCursor=v21(50 - 35),IntimidatingShoutMouseover=v21(748 - (16 + 716))};
	v21.Warrior.Arms = v19(v21.Warrior.Commons, {});
	v21.Warrior.Fury = v19(v21.Warrior.Commons, {RavagerPlayer=v21(32 - 15),RavagerCursor=v21(115 - (11 + 86))});
	v21.Warrior.Protection = v19(v21.Warrior.Commons, {RavagerPlayer=v21(45 - 26),RavagerCursor=v21(305 - (175 + 110))});
	local v34;
	v34 = v10.AddCoreOverride("Spell.IsCastable", function(v38, v39, v40, v41, v42, v43)
		local v44 = v34(v38, v39, v40, v41, v42, v43);
		if ((v38 == v16.Warrior.Arms.Charge) or ((7998 - 4830) < (2475 - 1973))) then
			return v44 and (v38:Charges() >= (1797 - (503 + 1293))) and ((v13:AffectingCombat() and not v14:IsInRange(22 - 14) and v14:IsInRange(19 + 6)) or not v13:AffectingCombat());
		else
			return v44;
		end
	end, 1132 - (810 + 251));
	local v35;
	v35 = v10.AddCoreOverride("Spell.IsCastable", function(v45, v46, v47, v48, v49, v50)
		local v51 = v35(v45, v46, v47, v48, v49, v50);
		if (((305 + 134) == (135 + 304)) and (v45 == v16.Warrior.Fury.Charge)) then
			return v51 and (v45:Charges() >= (1 + 0)) and ((v13:AffectingCombat() and not v14:IsInRange(541 - (43 + 490)) and v14:IsInRange(758 - (711 + 22))) or not v13:AffectingCombat());
		else
			return v51;
		end
	end, 278 - 206);
	local v36;
	v36 = v10.AddCoreOverride("Spell.IsReady", function(v52, v53, v54, v55, v56, v57)
		local v58 = v36(v52, v53, v54, v55, v56, v57);
		if ((v52 == v16.Warrior.Fury.Rampage) or ((2123 - (240 + 619)) < (66 + 206))) then
			if (((4967 - 1844) < (258 + 3633)) and v13:PrevGCDP(1745 - (1344 + 400), v16.Warrior.Fury.Bladestorm)) then
				return v52:IsCastable() and (v13:Rage() >= v52:Cost());
			else
				return v58;
			end
		else
			return v58;
		end
	end, 477 - (255 + 150));
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v59, v60, v61, v62, v63, v64)
		local v65 = v37(v59, v60, v61, v62, v63, v64);
		if (((3106 + 836) <= (2670 + 2317)) and (v59 == v16.Warrior.Protection.Charge)) then
			return v65 and (v59:Charges() >= (4 - 3)) and not v14:IsInRange(25 - 17);
		elseif (((6323 - (404 + 1335)) == (4990 - (183 + 223))) and ((v59 == v16.Warrior.Protection.HeroicThrow) or (v59 == v16.Warrior.Protection.TitanicThrow))) then
			return v65 and not v14:IsInRange(9 - 1);
		elseif (((2637 + 1342) >= (601 + 1067)) and (v59 == v16.Warrior.Protection.Avatar)) then
			return v65 and (v13:BuffDown(v16.Warrior.Protection.AvatarBuff));
		elseif (((905 - (10 + 327)) > (299 + 129)) and (v59 == v16.Warrior.Protection.Intervene)) then
			return v65 and (v13:IsInParty() or v13:IsInRaid());
		else
			return v65;
		end
	end, 411 - (118 + 220));
end;
return v0["Epix_Warrior_Warrior.lua"]();

