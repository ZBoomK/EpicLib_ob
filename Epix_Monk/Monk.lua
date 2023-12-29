local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((2314 + 1628) <= (18205 - 13218)) and (v5 == (3 - 2))) then
			return v6(...);
		end
		if (((5443 - (814 + 45)) == (11294 - 6710)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((1406 + 2573) >= (2553 - (261 + 624))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_Monk_Monk.lua"] = function(...)
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
	local v22 = C_Timer;
	local v23 = table.remove;
	local v24 = table.insert;
	local v25 = GetTime;
	if (((1648 - (1020 + 60)) > (1851 - (630 + 793))) and not v16.Monk) then
		v16.Monk = {};
	end
	v16.Monk.Commons = {AncestralCall=v16(930995 - 656257, nil, 4 - 3),ArcaneTorrent=v16(9865 + 15181, nil, 6 - 4),BagofTricks=v16(314158 - (760 + 987), nil, 1916 - (1789 + 124)),Berserking=v16(27063 - (745 + 21), nil, 2 + 2),BloodFury=v16(56606 - 36034, nil, 19 - 14),GiftoftheNaaru=v16(487 + 59060, nil, 5 + 1),Fireblood=v16(266276 - (87 + 968), nil, 30 - 23),LightsJudgment=v16(231940 + 23707, nil, 17 - 9),QuakingPalm=v16(108492 - (447 + 966), nil, 24 - 15),Shadowmeld=v16(60801 - (1703 + 114), nil, 711 - (376 + 325)),CracklingJadeLightning=v16(193298 - 75346, nil, 33 - 22),ExpelHarm=v16(92049 + 230052, nil, 26 - 14),LegSweep=v16(119395 - (9 + 5), nil, 389 - (85 + 291)),Provoke=v16(116811 - (243 + 1022), nil, 53 - 39),Resuscitate=v16(95018 + 20160, nil, 1195 - (1123 + 57)),RisingSunKick=v16(87409 + 20019, nil, 270 - (163 + 91)),Roll=v16(111062 - (1869 + 61), nil, 5 + 12),TigerPalm=v16(354948 - 254168, nil, 27 - 9),TouchofDeath=v16(44077 + 278032, nil, 25 - 6),Transcendence=v16(95471 + 6172, nil, 1494 - (1329 + 145)),TranscendenceTransfer=v16(120967 - (140 + 831), nil, 1871 - (1409 + 441)),Vivify=v16(117388 - (15 + 703), nil, 11 + 11),BonedustBrew=v16(386714 - (262 + 176), nil, 1744 - (345 + 1376)),Celerity=v16(115861 - (198 + 490), nil, 105 - 81),ChiBurst=v16(297404 - 173418, nil, 1231 - (696 + 510)),ChiTorpedo=v16(241204 - 126196, nil, 1288 - (1091 + 171)),ChiWave=v16(18522 + 96576, nil, 84 - 57),DampenHarm=v16(405514 - 283236, nil, 402 - (123 + 251)),Detox=v16(1084046 - 865882, nil, 727 - (208 + 490)),Disable=v16(9797 + 106298, nil, 14 + 16),DiffuseMagic=v16(123619 - (660 + 176), nil, 4 + 27),EyeoftheTiger=v16(196809 - (14 + 188), nil, 707 - (534 + 141)),InnerStrengthBuff=v16(105236 + 156533, nil, 30 + 3),Paralysis=v16(110642 + 4436, nil, 71 - 37),RingOfPeace=v16(185503 - 68659, nil, 98 - 63),RushingJadeWind=v16(62744 + 54103, nil, 23 + 13),SpearHandStrike=v16(117101 - (115 + 281), nil, 85 - 48),SummonWhiteTigerStatue=v16(321810 + 66876, nil, 91 - 53),TigerTailSweep=v16(969311 - 704963, nil, 906 - (550 + 317)),TigersLust=v16(168809 - 51968, nil, 56 - 16),BonedustBrewBuff=v16(1079440 - 693164, nil, 326 - (134 + 151)),DampenHarmBuff=v16(123943 - (970 + 695), nil, 79 - 37),RushingJadeWindBuff=v16(118837 - (582 + 1408), nil, 149 - 106),FortifyingBrewBuff=v16(144950 - 29747, nil, 399 - 293),CalltoDominanceBuff=v16(405204 - (1195 + 629), nil, 198 - 48),DomineeringArroganceBuff=v16(411902 - (187 + 54), nil, 931 - (162 + 618)),TheEmperorsCapacitorBuff=v16(164702 + 70352, nil, 30 + 14),PoolEnergy=v16(2132510 - 1132600, nil, 75 - 30),ImpTouchofDeath=v16(25186 + 296927, nil, 1784 - (1373 + 263)),StrengthofSpirit=v16(388276 - (451 + 549), nil, 48 + 101)};
	v16.Monk.Windwalker = v19(v16.Monk.Commons, {BlackoutKick=v16(156844 - 56060, nil, 78 - 31),FlyingSerpentKick=v16(102929 - (746 + 638), nil, 19 + 29),FlyingSerpentKickLand=v16(174688 - 59631, nil, 390 - (218 + 123)),SpinningCraneKick=v16(103127 - (1535 + 46), nil, 50 + 0),BonedustBrew=v16(55895 + 330381, nil, 611 - (306 + 254)),CraneVortex=v16(24073 + 364775, nil, 101 - 49),DanceofChiji=v16(326668 - (899 + 568), nil, 100 + 52),FastFeet=v16(940880 - 552071, nil, 656 - (268 + 335)),FaelineHarmony=v16(391702 - (60 + 230), nil, 626 - (426 + 146)),FaelineStomp=v16(46503 + 341690, nil, 1511 - (282 + 1174)),FistsofFury=v16(114467 - (569 + 242), nil, 161 - 105),HitCombo=v16(11251 + 185489, nil, 1081 - (706 + 318)),InvokeXuenTheWhiteTiger=v16(125155 - (721 + 530), nil, 1329 - (945 + 326)),MarkoftheCrane=v16(550521 - 330164, nil, 53 + 6),Serenity=v16(152873 - (271 + 429), nil, 56 + 4),ShadowboxingTreads=v16(394482 - (1408 + 92), nil, 1147 - (461 + 625)),StormEarthAndFire=v16(138927 - (993 + 295), nil, 4 + 58),StormEarthAndFireFixate=v16(222942 - (418 + 753), nil, 24 + 39),StrikeoftheWindlord=v16(40502 + 352481, nil, 19 + 45),TeachingsoftheMonastery=v16(29480 + 87165, nil, 594 - (406 + 123)),Thunderfist=v16(394754 - (1749 + 20), nil, 16 + 50),WhirlingDragonPunch=v16(153497 - (1249 + 73), nil, 24 + 43),XuensBattlegear=v16(394138 - (466 + 679), nil, 163 - 95),Skyreach=v16(1124027 - 731036, nil, 2037 - (106 + 1794)),Skytouch=v16(128137 + 276907, nil, 35 + 103),InvokersDelightBuff=v16(1147489 - 758826, nil, 376 - 237),DrinkingHornCover=v16(391484 - (4 + 110), nil, 724 - (57 + 527)),JadeIgnition=v16(394406 - (41 + 1386), nil, 244 - (17 + 86)),HiddenMastersForbiddenTouchBuff=v16(144642 + 68472, nil, 316 - 174),PressurePointBuff=v16(977329 - 639847, nil, 309 - (122 + 44)),FaeExposureDebuff=v16(683011 - 287597, nil, 477 - 333),SkyreachCritDebuff=v16(319738 + 73309, nil, 21 + 124),KicksofFlowingMomentumBuff=v16(800099 - 405155, nil, 211 - (30 + 35)),FistsofFlowingMomentumBuff=v16(271453 + 123496, nil, 1404 - (1043 + 214)),FortifyingBrew=v16(920344 - 676909, nil, 1281 - (323 + 889)),TouchofKarma=v16(329645 - 207175, nil, 650 - (361 + 219)),BlackoutKickBuff=v16(117088 - (53 + 267), nil, 17 + 54),ChiEnergyBuff=v16(393470 - (15 + 398), nil, 1054 - (18 + 964)),DanceofChijiBuff=v16(1224098 - 898896, nil, 43 + 30),HitComboBuff=v16(123954 + 72787, nil, 924 - (20 + 830)),PowerStrikesBuff=v16(101410 + 28504, nil, 201 - (116 + 10)),SerenityBuff=v16(11241 + 140932, nil, 814 - (542 + 196)),StormEarthAndFireBuff=v16(295057 - 157418, nil, 23 + 54),TeachingsoftheMonasteryBuff=v16(102676 + 99414, nil, 29 + 49),WhirlingDragonPunchBuff=v16(518432 - 321690, nil, 202 - 123),MarkoftheCraneDebuff=v16(229838 - (1126 + 425), nil, 485 - (118 + 287)),SkyreachExhaustionDebuff=v16(1540478 - 1147428, nil, 1202 - (118 + 1003)),KicksofFlowingMomentumBuff=v16(1155776 - 760832, nil, 459 - (142 + 235)),FistsofFlowingMomentumBuff=v16(1791693 - 1396744, nil, 19 + 64),BlackoutReinforcementBuff=v16(425431 - (553 + 424), nil, 288 - 135)});
	v16.Monk.Brewmaster = v19(v16.Monk.Commons, {BlackoutKick=v16(181049 + 24474, nil, 84 + 0),BreathOfFire=v16(67065 + 48116, nil, 37 + 48),Clash=v16(185205 + 139107, nil, 186 - 100),InvokeNiuzaoTheBlackOx=v16(369404 - 236826, nil, 194 - 107),KegSmash=v16(35260 + 85993, nil, 425 - 337),SpinningCraneKick=v16(323482 - (239 + 514), nil, 32 + 57),BreathOfFireDotDebuff=v16(125054 - (797 + 532), nil, 66 + 24),BlackoutCombo=v16(66370 + 130366, nil, 213 - 122),BlackoutComboBuff=v16(229765 - (373 + 829), nil, 823 - (476 + 255)),BlackOxBrew=v16(116529 - (369 + 761), nil, 54 + 39),BobAndWeave=v16(509524 - 229009, nil, 178 - 84),CelestialFlames=v16(325415 - (64 + 174), nil, 14 + 81),ExplodingKeg=v16(481531 - 156378, nil, 432 - (144 + 192)),HighTolerance=v16(196953 - (42 + 174), nil, 73 + 24),LightBrewing=v16(269298 + 55795, nil, 42 + 56),SpecialDelivery=v16(198234 - (363 + 1141), nil, 1679 - (1183 + 397)),Spitfire=v16(738497 - 495917, nil, 74 + 26),SummonBlackOxStatue=v16(86193 + 29122, nil, 2076 - (1913 + 62)),WeaponsOfOrder=v16(243841 + 143343, nil, 269 - 167),CelestialBrew=v16(324440 - (565 + 1368), nil, 387 - 284),ElusiveBrawlerBuff=v16(197291 - (1477 + 184), nil, 141 - 37),FortifyingBrew=v16(107341 + 7862, nil, 961 - (564 + 292)),PurifyingBrew=v16(206329 - 86747, nil, 322 - 215),PurifiedChiBuff=v16(325396 - (244 + 60), nil, 84 + 24),Shuffle=v16(215955 - (41 + 435), nil, 1110 - (938 + 63)),HealingElixir=v16(94044 + 28237, nil, 1235 - (936 + 189)),CharredPassions=v16(111283 + 226857, nil, 1724 - (1565 + 48)),MightyPour=v16(208785 + 129209, nil, 1250 - (782 + 356)),HeavyStagger=v16(124540 - (176 + 91), nil, 294 - 181),ModerateStagger=v16(183155 - 58881, nil, 1206 - (975 + 117)),LightStagger=v16(126150 - (157 + 1718), nil, 94 + 21)});
	v16.Monk.Mistweaver = v19(v16.Monk.Commons, {BlackoutKick=v16(357775 - 256991, nil, 396 - 280),EnvelopingMist=v16(125700 - (697 + 321), nil, 318 - 201),EssenceFont=v16(406428 - 214591, nil, 271 - 153),EssenceFontBuff=v16(74673 + 117167, nil, 222 - 103),InvokeYulonTheJadeSerpent=v16(332150 - 208246, nil, 1347 - (322 + 905)),LifeCocoon=v16(117460 - (602 + 9), nil, 1310 - (449 + 740)),RenewingMist=v16(116023 - (826 + 46), nil, 1069 - (245 + 702)),Revival=v16(364374 - 249064, nil, 40 + 83),SoothingMist=v16(117073 - (260 + 1638), nil, 564 - (382 + 58)),SpinningCraneKick=v16(325766 - 224220, nil, 104 + 21),TeachingsOfTheMonasteryBuff=v16(417659 - 215569, nil, 374 - 248),ThunderFocusTea=v16(117885 - (902 + 303), nil, 278 - 151),InvokeChiJiTheRedCrane=v16(783238 - 458041, nil, 11 + 117),LifecyclesEnvelopingMistBuff=v16(199609 - (1121 + 569), nil, 343 - (22 + 192)),LifecyclesVivifyBuff=v16(198599 - (483 + 200), nil, 1593 - (1404 + 59)),ManaTea=v16(541622 - 343714, nil, 175 - 44),RefreshingJadeWind=v16(197490 - (468 + 297), nil, 694 - (334 + 228)),SongOfChiJi=v16(670880 - 471982, nil, 308 - 175),SummonJadeSerpentStatue=v16(209136 - 93823, nil, 39 + 95),FortifyingBrew=v16(243671 - (141 + 95), nil, 133 + 2),Reawaken=v16(545820 - 333769, nil, 326 - 190)});
	if (((313 + 1021) <= (12638 - 8025)) and not v18.Monk) then
		v18.Monk = {};
	end
	v18.Monk.Commons = {AlgetharPuzzleBox=v18(136171 + 57530, {(18 - 5),(177 - (92 + 71))}),BeacontotheBeyond=v18(100747 + 103216, {(778 - (574 + 191)),(34 - 20)}),DragonfireBombDispenser=v18(103491 + 99119, {(140 - (55 + 71)),(1804 - (573 + 1217))}),EruptingSpearFragment=v18(536627 - 342858, {(20 - 7),(40 - 26)}),IrideusFragment=v18(270108 - 76365, {(18 - 5),(62 - (25 + 23))}),ManicGrieftorch=v18(37635 + 156673, {(43 - 30),(26 - 12)}),AshesoftheEmbersoul=v18(207264 - (11 + 86), {(298 - (175 + 110)),(69 - 55)}),MirrorofFracturedTomorrows=v18(209377 - (503 + 1293), {(10 + 3),(10 + 4)}),NeltharionsCalltoDominance=v18(62671 + 141531, {(546 - (43 + 490)),(53 - 39)}),WitherbarksBranch=v18(110858 - (240 + 619), {(20 - 7),(1758 - (1344 + 400))}),RefreshingHealingPotion=v18(191785 - (255 + 150)),Healthstone=v18(4342 + 1170),Djaruun=v18(108451 + 94118)};
	v18.Monk.Windwalker = v19(v18.Monk.Commons, {});
	v18.Monk.Brewmaster = v19(v18.Monk.Commons, {});
	v18.Monk.Mistweaver = v19(v18.Monk.Commons, {});
	if (not v21.Monk or ((7968 - 6103) >= (6553 - 4524))) then
		v21.Monk = {};
	end
	v21.Monk.Commons = {Healthstone=v21(1760 - (404 + 1335)),Djaruun=v21(428 - (183 + 223)),RefreshingHealingPotion=v21(27 - 4),AlgetharPuzzleBox=v21(16 + 8),BonedustBrewPlayer=v21(9 + 16),BonedustBrewCursor=v21(363 - (10 + 327)),DetoxMouseover=v21(19 + 8),RingOfPeaceCursor=v21(347 - (118 + 220)),SpearHandStrikeMouseover=v21(4 + 6),SummonWhiteTigerStatuePlayer=v21(460 - (108 + 341)),SummonWhiteTigerStatueCursor=v21(6 + 6),TigerPalmMouseover=v21(54 - 41),DetoxFocus=v21(1507 - (711 + 782)),ParalysisMouseover=v21(28 - 13)};
	v21.Monk.Windwalker = v19(v21.Monk.Commons, {SummonWhiteTigerStatueM=v21(485 - (270 + 199)),BonedustBrewM=v21(6 + 11),TrinketTop=v21(1847 - (580 + 1239)),TrinketBottom=v21(85 - 56),StopFoF=v16(29 + 1)});
	v21.Monk.Brewmaster = v19(v21.Monk.Commons, {ExplodingKegPlayer=v21(1 + 17),ExplodingKegCursor=v21(9 + 10)});
	v21.Monk.Mistweaver = v19(v21.Monk.Commons, {});
	local v38 = v16.Monk.Brewmaster;
	local v39 = v16.Monk.Windwalker;
	local v40;
	v40 = v10.AddCoreOverride("Spell.IsCastable", function(v53, v54, v55, v56, v57, v58)
		local v59 = 0 - 0;
		local v60;
		while true do
			if (((3076 + 1874) >= (2783 - (645 + 522))) and (v59 == (1790 - (1010 + 780)))) then
				v60 = v40(v53, v54, v55, v56, v57, v58);
				if (((1725 + 0) == (8217 - 6492)) and (v53 == v38.TouchOfDeath)) then
					return v60 and v53:IsUsable();
				else
					return v60;
				end
				break;
			end
		end
	end, 785 - 517);
	local v41 = 116905 - (1045 + 791);
	local v42 = 314524 - 190269;
	local v43 = v16(428332 - 147817, nil, 642 - (351 + 154));
	local v44 = 1574 - (1281 + 293);
	local v45 = {};
	local v46 = {};
	local function v47(v61)
		local v62 = (276 - (28 + 238)) + ((v43:IsAvailable() and (6 - 3)) or (1559 - (1381 + 178)));
		v44 = v44 + v61;
		v22.After(v62, function()
			v44 = v44 - v61;
		end);
	end
	local function v48(v63)
		local v64 = 0 + 0;
		while true do
			if (((1177 + 282) <= (1059 + 1423)) and (v64 == (0 - 0))) then
				if ((#v45 == (6 + 4)) or ((3166 - (381 + 89)) >= (4019 + 513))) then
					v23(v45, 7 + 3);
				end
				v24(v45, 1 - 0, v63);
				break;
			end
		end
	end
	local function v49(v65)
		while (#v46 > (1156 - (1074 + 82))) and (v46[#v46][1 - 0] < (v25() - (1790 - (214 + 1570)))) do
			v23(v46, #v46);
		end
		v24(v46, 1456 - (990 + 465), {v25(),v65});
	end
	v13.StaggerFull = function(v66)
		return v44;
	end;
	v13.StaggerLastTickDamage = function(v67, v68)
		local v69 = 0 + 0;
		local v70;
		while true do
			if (((4124 - 3076) >= (1778 - (1668 + 58))) and (v69 == (627 - (512 + 114)))) then
				for v95 = 2 - 1, v68 do
					v70 = v70 + v45[v95];
				end
				return v70;
			end
			if (((6114 - 3156) < (15668 - 11165)) and (v69 == (0 + 0))) then
				v70 = 0 + 0;
				if ((v68 > #v45) or ((2378 + 357) == (4415 - 3106))) then
					v68 = #v45;
				end
				v69 = 1995 - (109 + 1885);
			end
		end
	end;
	v13.IncomingDamageTaken = function(v71, v72)
		local v73 = 1469 - (1269 + 200);
		local v74 = v72 / (1916 - 916);
		for v89 = 816 - (98 + 717), #v46 do
			if ((v46[v89][827 - (802 + 24)] > (v25() - v74)) or ((7122 - 2992) <= (3732 - 777))) then
				v73 = v73 + v46[v89][1 + 1];
			end
		end
		return v73;
	end;
	v10:RegisterForCombatEvent(function(...)
		local v75 = 0 + 0;
		local v76;
		while true do
			if ((v75 == (0 + 0)) or ((424 + 1540) <= (3727 - 2387))) then
				v76 = {...};
				if (((894 + 1605) == (1018 + 1481)) and (#v76 == (19 + 4))) then
					local v96 = 0 + 0;
					local v97;
					local v98;
					local v99;
					local v100;
					while true do
						if ((v96 == (0 + 0)) or ((3688 - (797 + 636)) < (106 - 84))) then
							v97, v97, v97, v97, v97, v97, v97, v98, v97, v97, v97, v97, v97, v97, v97, v97, v97, v97, v99, v97, v97, v100 = ...;
							if (((v98 == v13:GUID()) and (v99 == v41)) or ((2705 - (1427 + 192)) >= (487 + 918))) then
								v47(v100);
							end
							break;
						end
					end
				else
					local v101, v101, v101, v101, v101, v101, v101, v102, v101, v101, v101, v101, v101, v101, v101, v103, v101, v101, v104 = ...;
					if (((v102 == v13:GUID()) and (v103 == v41)) or ((5499 - 3130) == (383 + 43))) then
						v47(v104);
					end
				end
				break;
			end
		end
	end, "SPELL_ABSORBED");
	v10:RegisterForCombatEvent(function(...)
		local v77 = 0 + 0;
		local v78;
		local v79;
		local v80;
		local v81;
		while true do
			if (((326 - (192 + 134)) == v77) or ((4352 - (316 + 960)) > (1772 + 1411))) then
				v78, v78, v78, v78, v78, v78, v78, v79, v78, v78, v78, v80, v78, v78, v81 = ...;
				if (((928 + 274) > (978 + 80)) and (v79 == v13:GUID()) and (v80 == v42) and (v81 > (0 - 0))) then
					v48(v81);
				end
				break;
			end
		end
	end, "SPELL_PERIODIC_DAMAGE");
	v10:RegisterForCombatEvent(function(...)
		local v82 = 551 - (83 + 468);
		local v83;
		local v84;
		local v85;
		while true do
			if (((5517 - (1202 + 604)) > (15661 - 12306)) and (v82 == (0 - 0))) then
				v83, v83, v83, v83, v83, v83, v83, v84, v83, v83, v83, v83, v83, v83, v85 = ...;
				if (((v11.Persistent.Player.Spec[2 - 1] == (593 - (45 + 280))) and (v84 == v13:GUID()) and (v85 ~= nil) and (v85 > (0 + 0))) or ((792 + 114) >= (814 + 1415))) then
					v49(v85);
				end
				break;
			end
		end
	end, "SWING_DAMAGE", "SPELL_DAMAGE", "SPELL_PERIODIC_DAMAGE");
	v10:RegisterForEvent(function()
		if (((713 + 575) > (221 + 1030)) and (#v45 > (0 - 0))) then
			for v91 = 1911 - (340 + 1571), #v45 do
				v45[v91] = nil;
			end
		end
		if ((#v46 > (0 + 0)) or ((6285 - (1733 + 39)) < (9210 - 5858))) then
			for v93 = 1034 - (125 + 909), #v46 do
				v46[v93] = nil;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
end;
return v0["Epix_Monk_Monk.lua"]();

