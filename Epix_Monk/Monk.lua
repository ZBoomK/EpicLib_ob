local v0 = ...;
local v1 = {};
local v2 = require;
local function v3(v5, ...)
	local v6 = 209 - (133 + 76);
	local v7;
	while true do
		if (((6141 - (1594 + 61)) > (2233 - (108 + 1553))) and (v6 == (513 - (232 + 281)))) then
			v7 = v1[v5];
			if (((2657 - (976 + 277)) == (2361 - (892 + 65))) and not v7) then
				return v2(v5, v0, ...);
			end
			v6 = 2 - 1;
		end
		if ((v6 == (1 - 0)) or ((6880 - 3132) < (2562 - (87 + 263)))) then
			return v7(v0, ...);
		end
	end
end
v1["Epix_Monk_Monk.lua"] = function(...)
	local v8, v9 = ...;
	local v10 = EpicDBC.DBC;
	local v11 = EpicLib;
	local v12 = EpicCache;
	local v13 = v11.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v13.Pet;
	local v17 = v11.Spell;
	local v18 = v11.MultiSpell;
	local v19 = v11.Item;
	local v20 = v11.Utils.MergeTableByKey;
	local v21 = EpicLib;
	local v22 = v21.Macro;
	local v23 = C_Timer;
	local v24 = table.remove;
	local v25 = table.insert;
	local v26 = GetTime;
	if (not v17.Monk or ((1360 - (67 + 113)) == (1599 + 581))) then
		v17.Monk = {};
	end
	v17.Monk.Commons = {AncestralCall=v17(674526 - 399788, nil, 1 + 0),ArcaneTorrent=v17(99545 - 74499, nil, 954 - (802 + 150)),BagofTricks=v17(841116 - 528705, nil, 5 - 2),Berserking=v17(19142 + 7155, nil, 1001 - (915 + 82)),BloodFury=v17(58251 - 37679, nil, 3 + 2),GiftoftheNaaru=v17(78312 - 18765, nil, 1193 - (1069 + 118)),Fireblood=v17(601709 - 336488, nil, 14 - 7),LightsJudgment=v17(44444 + 211203, nil, 13 - 5),QuakingPalm=v17(106223 + 856, nil, 800 - (368 + 423)),Shadowmeld=v17(185367 - 126383, nil, 28 - (10 + 8)),CracklingJadeLightning=v17(453729 - 335777, nil, 453 - (416 + 26)),ExpelHarm=v17(1028442 - 706341, nil, 6 + 6),LegSweep=v17(211236 - 91855, nil, 451 - (145 + 293)),MysticTouch=v17(9077 - (44 + 386), nil, 1664 - (998 + 488)),Provoke=v17(36709 + 78837, nil, 12 + 2),Resuscitate=v17(115950 - (201 + 571), nil, 1153 - (116 + 1022)),RisingSunKick=v17(447251 - 339823, nil, 10 + 6),Roll=v17(398407 - 289275, nil, 60 - 43),TigerPalm=v17(101639 - (814 + 45), nil, 44 - 26),TouchofDeath=v17(17357 + 304752, nil, 7 + 12),Transcendence=v17(102528 - (261 + 624), nil, 35 - 15),TranscendenceTransfer=v17(121076 - (1020 + 60), nil, 1444 - (630 + 793)),Vivify=v17(395355 - 278685, nil, 104 - 82),BonedustBrew=v17(152130 + 234146, nil, 78 - 55),Celerity=v17(116920 - (760 + 987), nil, 1937 - (1789 + 124)),ChiBurst=v17(124752 - (745 + 21), nil, 9 + 16),ChiTorpedo=v17(316461 - 201453, nil, 101 - 75),ChiWave=v17(942 + 114156, nil, 22 + 5),DampenHarm=v17(123333 - (87 + 968), nil, 123 - 95),Detox=v17(104744 + 10706, nil, 65 - 36),Disable=v17(117508 - (447 + 966), nil, 82 - 52),DiffuseMagic=v17(124600 - (1703 + 114), nil, 732 - (376 + 325)),EyeoftheTiger=v17(322197 - 125590, nil, 98 - 66),ImprovedDetox=v17(111131 + 277743, nil, 321 - 175),InnerStrengthBuff=v17(261783 - (9 + 5), nil, 409 - (85 + 291)),Paralysis=v17(116343 - (243 + 1022), nil, 129 - 95),RingOfPeace=v17(96393 + 20451, nil, 1215 - (1123 + 57)),RushingJadeWind=v17(95072 + 21775, nil, 290 - (163 + 91)),SpearHandStrike=v17(118635 - (1869 + 61), nil, 11 + 26),SummonWhiteTigerStatue=v17(1368957 - 980271, nil, 58 - 20),TigerTailSweep=v17(36173 + 228175, nil, 52 - 13),TigersLust=v17(109746 + 7095, nil, 1514 - (1329 + 145)),BonedustBrewBuff=v17(387247 - (140 + 831), nil, 1891 - (1409 + 441)),DampenHarmBuff=v17(122996 - (15 + 703), nil, 20 + 22),RushingJadeWindBuff=v17(117285 - (262 + 176), nil, 1764 - (345 + 1376)),FortifyingBrewBuff=v17(115891 - (198 + 490), nil, 468 - 362),Bursting=v17(576748 - 336305, nil, 1376 - (696 + 510)),CalltoDominanceBuff=v17(846003 - 442623, nil, 1412 - (1091 + 171)),DomineeringArroganceBuff=v17(66246 + 345415, nil, 475 - 324),TheEmperorsCapacitorBuff=v17(779517 - 544463, nil, 418 - (123 + 251)),PoolEnergy=v17(4968504 - 3968594, nil, 743 - (208 + 490)),ImpTouchofDeath=v17(27182 + 294931, nil, 66 + 82),StrengthofSpirit=v17(388112 - (660 + 176), nil, 18 + 131),MysticTouchDebuff=v17(113948 - (14 + 188), nil, 839 - (534 + 141))};
	v17.Monk.Windwalker = v20(v17.Monk.Commons, {BlackoutKick=v17(40517 + 60267, nil, 42 + 5),FlyingSerpentKick=v17(97630 + 3915, nil, 100 - 52),FlyingSerpentKickLand=v17(182666 - 67609, nil, 137 - 88),SpinningCraneKick=v17(54528 + 47018, nil, 32 + 18),BonedustBrew=v17(386672 - (115 + 281), nil, 118 - 67),CraneVortex=v17(321944 + 66904, nil, 125 - 73),DanceofChiji=v17(1192447 - 867246, nil, 1019 - (550 + 317)),FastFeet=v17(561743 - 172934, nil, 73 - 20),JadefireHarmony=v17(1093792 - 702380, nil, 339 - (134 + 151)),JadefireStomp=v17(389858 - (970 + 695), nil, 104 - 49),FistsofFury=v17(115646 - (582 + 1408), nil, 194 - 138),HitCombo=v17(247542 - 50802, nil, 214 - 157),InvokeXuenTheWhiteTiger=v17(125728 - (1195 + 629), nil, 76 - 18),MarkoftheCrane=v17(220598 - (187 + 54), nil, 839 - (162 + 618)),Serenity=v17(106628 + 45545, nil, 40 + 20),ShadowboxingTreads=v17(838112 - 445130, nil, 102 - 41),StormEarthAndFire=v17(10762 + 126877, nil, 1698 - (1373 + 263)),StormEarthAndFireFixate=v17(222771 - (451 + 549), nil, 20 + 43),StrikeoftheWindlord=v17(611579 - 218596, nil, 107 - 43),TeachingsoftheMonastery=v17(118029 - (746 + 638), nil, 25 + 40),Thunderfist=v17(596662 - 203677, nil, 407 - (218 + 123)),WhirlingDragonPunch=v17(153756 - (1535 + 46), nil, 67 + 0),XuensBattlegear=v17(56867 + 336126, nil, 628 - (306 + 254)),FortifyingBrew=v17(15071 + 228364, nil, 134 - 65),TouchofKarma=v17(123937 - (899 + 568), nil, 47 + 23),BlackoutKickBuff=v17(282567 - 165799, nil, 674 - (268 + 335)),ChiEnergyBuff=v17(393347 - (60 + 230), nil, 644 - (426 + 146)),DanceofChijiBuff=v17(38957 + 286245, nil, 1529 - (282 + 1174)),HitComboBuff=v17(197552 - (569 + 242), nil, 212 - 138),PowerStrikesBuff=v17(7430 + 122484, nil, 1099 - (706 + 318)),SerenityBuff=v17(153424 - (721 + 530), nil, 1347 - (945 + 326)),StormEarthAndFireBuff=v17(343865 - 206226, nil, 69 + 8),TeachingsoftheMonasteryBuff=v17(202790 - (271 + 429), nil, 72 + 6),WhirlingDragonPunchBuff=v17(198242 - (1408 + 92), nil, 1165 - (461 + 625)),MarkoftheCraneDebuff=v17(229575 - (993 + 295), nil, 5 + 75),SkyreachExhaustionDebuff=v17(394221 - (418 + 753), nil, 31 + 50),KicksofFlowingMomentumBuff=v17(40704 + 354240, nil, 24 + 58),FistsofFlowingMomentumBuff=v17(99814 + 295135, nil, 612 - (406 + 123))});
	v17.Monk.Brewmaster = v20(v17.Monk.Commons, {BlackoutKick=v17(207292 - (1749 + 20), nil, 20 + 64),BreathOfFire=v17(116503 - (1249 + 73), nil, 31 + 54),Clash=v17(325457 - (466 + 679), nil, 206 - 120),InvokeNiuzaoTheBlackOx=v17(379197 - 246619, nil, 1987 - (106 + 1794)),KegSmash=v17(38359 + 82894, nil, 23 + 65),SpinningCraneKick=v17(952825 - 630096, nil, 240 - 151),BreathOfFireDotDebuff=v17(123839 - (4 + 110), nil, 674 - (57 + 527)),BlackoutCombo=v17(198163 - (41 + 1386), nil, 194 - (17 + 86)),BlackoutComboBuff=v17(155127 + 73436, nil, 204 - 112),BlackOxBrew=v17(334189 - 218790, nil, 259 - (122 + 44)),BobAndWeave=v17(484542 - 204027, nil, 311 - 217),CelestialFlames=v17(264527 + 60650, nil, 14 + 81),ExplodingKeg=v17(658713 - 333560, nil, 161 - (30 + 35)),HighTolerance=v17(135220 + 61517, nil, 1354 - (1043 + 214)),LightBrewing=v17(1229064 - 903971, nil, 1310 - (323 + 889)),SpecialDelivery=v17(529526 - 332796, nil, 679 - (361 + 219)),Spitfire=v17(242900 - (53 + 267), nil, 23 + 77),SummonBlackOxStatue=v17(115728 - (15 + 398), nil, 1083 - (18 + 964)),WeaponsOfOrder=v17(1457406 - 1070222, nil, 60 + 42),CelestialBrew=v17(203192 + 119315, nil, 953 - (20 + 830)),ElusiveBrawlerBuff=v17(152707 + 42923, nil, 230 - (116 + 10)),FortifyingBrew=v17(8510 + 106693, nil, 843 - (542 + 196)),PurifyingBrew=v17(256348 - 136766, nil, 32 + 75),PurifiedChiBuff=v17(165169 + 159923, nil, 39 + 69),Shuffle=v17(567806 - 352327, nil, 279 - 170),HealingElixir=v17(123832 - (1126 + 425), nil, 515 - (118 + 287)),CharredPassions=v17(1325269 - 987129, nil, 1232 - (118 + 1003)),MightyPour=v17(989116 - 651122, nil, 489 - (142 + 235)),HeavyStagger=v17(563766 - 439493, nil, 25 + 88),ModerateStagger=v17(125251 - (553 + 424), nil, 215 - 101),LightStagger=v17(109476 + 14799, nil, 115 + 0)});
	v17.Monk.Mistweaver = v20(v17.Monk.Commons, {BlackoutKick=v17(58683 + 42101, nil, 50 + 66),EnvelopingMist=v17(71203 + 53479, nil, 253 - 136),EssenceFont=v17(534518 - 342681, nil, 264 - 146),EssenceFontBuff=v18(35 + 84, 1662463 - 1318457, 192593 - (239 + 514)),InvokeYulonTheJadeSerpent=v17(113132 + 208986, nil, 1449 - (797 + 532)),LifeCocoon=v17(84905 + 31944, nil, 41 + 80),RenewingMist=v17(270749 - 155598, nil, 1324 - (373 + 829)),RenewingMistBuff=v17(120342 - (476 + 255), nil, 1293 - (369 + 761)),Revival=v17(66704 + 48606, nil, 223 - 100),SoothingMist=v17(218256 - 103081, nil, 362 - (64 + 174)),SpinningCraneKick=v17(14463 + 87083, nil, 185 - 60),AncientTeachings=v17(388359 - (144 + 192), nil, 342 - (42 + 174)),AncientTeachingsBuff=v17(291499 + 96527, nil, 165 + 34),ThunderFocusTea=v17(49571 + 67109, nil, 1631 - (363 + 1141)),InvokeChiJiTheRedCrane=v17(326777 - (1183 + 397), nil, 389 - 261),InvokeChiJiBuff=v17(252036 + 91784, nil, 120 + 40),LifecyclesEnvelopingMistBuff=v17(199894 - (1913 + 62), nil, 82 + 47),LifecyclesVivifyBuff=v17(523943 - 326027, nil, 2063 - (565 + 1368)),ManaTea=v17(433590 - 318296, nil, 1792 - (1477 + 184)),ManaTeaBuff=v17(269665 - 71757, nil, 137 + 10),ManaTeaCharges=v17(116723 - (564 + 292), nil, 285 - 119),RefreshingJadeWind=v17(592962 - 396237, nil, 436 - (244 + 60)),SongOfChiJi=v17(152935 + 45963, nil, 609 - (41 + 435)),SummonJadeSerpentStatue=v17(116314 - (938 + 63), nil, 104 + 30),Upwelling=v17(276088 - (936 + 189), nil, 46 + 91),CloudedFocus=v17(389660 - (1565 + 48), nil, 86 + 52),ChiBurst=v17(125124 - (782 + 356), nil, 406 - (176 + 91)),SheilunsGift=v17(1040805 - 641314, nil, 206 - 66),Restoral=v17(389707 - (975 + 117), nil, 2020 - (157 + 1718)),TeachingsoftheMonastery=v17(94664 + 21981, nil, 571 - 410),TeachingsoftheMonasteryBuff=v17(690907 - 488817, nil, 1180 - (697 + 321)),VivaciousVivificationBuff=v17(1070263 - 677380, nil, 349 - 184),FortifyingBrew=v17(561210 - 317775, nil, 53 + 82),Reawaken=v17(397310 - 185259, nil, 364 - 228),ChiHarmonyBuff=v17(424666 - (322 + 905), nil, 752 - (602 + 9)),ZenPulse=v17(125270 - (449 + 740), nil, 1014 - (826 + 46)),JadefireStomp=v17(389140 - (245 + 702), nil, 451 - 308),AncientConcordance=v17(124968 + 263772, nil, 2042 - (260 + 1638))});
	if (((4530 - (382 + 58)) < (14926 - 10273)) and not v19.Monk) then
		v19.Monk = {};
	end
	v19.Monk.Commons = {AlgetharPuzzleBox=v19(160957 + 32744, {(38 - 25),(30 - 16)}),BeacontotheBeyond=v19(491245 - 287282, {(1703 - (1121 + 569)),(697 - (483 + 200))}),DragonfireBombDispenser=v19(204073 - (1404 + 59), {(18 - 4),(576 - (334 + 228))}),EruptingSpearFragment=v19(653580 - 459811, {(23 - 10),(250 - (141 + 95))}),IrideusFragment=v19(190316 + 3427, {(30 - 17),(38 - 24)}),ManicGrieftorch=v19(136597 + 57711, {(18 - 5),(177 - (92 + 71))}),AshesoftheEmbersoul=v19(102329 + 104838, {(778 - (574 + 191)),(34 - 20)}),MirrorofFracturedTomorrows=v19(106030 + 101551, {(139 - (55 + 71)),(1804 - (573 + 1217))}),NeltharionsCalltoDominance=v19(565521 - 361319, {(20 - 7),(40 - 26)}),WitherbarksBranch=v19(153355 - 43356, {(18 - 5),(62 - (25 + 23))}),RefreshingHealingPotion=v19(37068 + 154312),Healthstone=v19(7398 - (927 + 959)),DreamwalkersHealingPotion=v19(697853 - 490830),AeratedManaPotion=v19(192118 - (16 + 716)),PotionOfWitheringDreams=v19(399673 - 192632),Djaruun=v19(202666 - (11 + 86)),Dreambinder=v19(508850 - 300234),Iridal=v19(208606 - (175 + 110))};
	v19.Monk.Windwalker = v20(v19.Monk.Commons, {});
	v19.Monk.Brewmaster = v20(v19.Monk.Commons, {});
	v19.Monk.Mistweaver = v20(v19.Monk.Commons, {});
	if (not v22.Monk or ((6695 - 4043) < (966 - 770))) then
		v22.Monk = {};
	end
	v22.Monk.Commons = {Healthstone=v22(1817 - (503 + 1293)),Djaruun=v22(61 - 39),RefreshingHealingPotion=v22(17 + 6),ManaPotion=v22(1131 - (810 + 251)),AlgetharPuzzleBox=v22(17 + 7),UseWeapon=v22(31 + 70),BonedustBrewPlayer=v22(23 + 2),BonedustBrewCursor=v22(559 - (43 + 490)),DetoxMouseover=v22(760 - (711 + 22)),RingOfPeaceCursor=v22(34 - 25),SpearHandStrikeMouseover=v22(869 - (240 + 619)),SummonWhiteTigerStatuePlayer=v22(3 + 8),SummonWhiteTigerStatueCursor=v22(18 - 6),TigerPalmMouseover=v22(1 + 12),DetoxFocus=v22(1758 - (1344 + 400)),ParalysisMouseover=v22(420 - (255 + 150))};
	v22.Monk.Windwalker = v20(v22.Monk.Commons, {SummonWhiteTigerStatueM=v22(13 + 3),BonedustBrewM=v22(10 + 7),TrinketTop=v22(119 - 91),TrinketBottom=v22(93 - 64),StopFoF=v17(1769 - (404 + 1335))});
	v22.Monk.Brewmaster = v20(v22.Monk.Commons, {ExplodingKegPlayer=v22(424 - (183 + 223)),ExplodingKegCursor=v22(22 - 3)});
	v22.Monk.Mistweaver = v20(v22.Monk.Commons, {RenewingMistFocus=v22(28 + 14),SummonJadeSerpentStatuePlayer=v22(16 + 27),SummonJadeSerpentStatueCursor=v22(381 - (10 + 327)),SoothingMistFocus=v22(32 + 13),VivifyFocus=v22(384 - (118 + 220)),EnvelopingMistFocus=v22(16 + 32),ZenPulseFocus=v22(498 - (108 + 341)),RenewingMistMouseover=v22(23 + 27),SoothingMistMouseover=v22(215 - 164),VivifyMouseover=v22(1545 - (711 + 782)),EnvelopingMistMouseover=v22(101 - 48),ResuscitateMouseover=v22(523 - (270 + 199)),LifeCocoonFocus=v22(18 + 37),StopEssenceFont=v17(1875 - (580 + 1239))});
end;
return v1["Epix_Monk_Monk.lua"](...);

