local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((20054 - 15237) >= (258 + 181)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((4488 - 3224) < (1131 - (814 + 45)))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if (((169 + 2954) < (1375 + 2516)) and (v5 == (886 - (261 + 624)))) then
			return v6(...);
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
	if (((7005 - 3063) <= (6067 - (1020 + 60))) and not v16.Monk) then
		v16.Monk = {};
	end
	v16.Monk.Commons = {AncestralCall=v16(276161 - (630 + 793), nil, 3 - 2),ArcaneTorrent=v16(118586 - 93540, nil, 1 + 1),BagofTricks=v16(1075644 - 763233, nil, 1750 - (760 + 987)),Berserking=v16(28210 - (1789 + 124), nil, 770 - (745 + 21)),BloodFury=v16(7077 + 13495, nil, 13 - 8),GiftoftheNaaru=v16(233573 - 174026, nil, 1 + 5),Fireblood=v16(208231 + 56990, nil, 1062 - (87 + 968)),LightsJudgment=v16(1125343 - 869696, nil, 8 + 0),QuakingPalm=v16(242056 - 134977, nil, 1422 - (447 + 966)),Shadowmeld=v16(161477 - 102493, nil, 1827 - (1703 + 114)),CracklingJadeLightning=v16(118653 - (376 + 325), nil, 17 - 6),ExpelHarm=v16(991097 - 668996, nil, 4 + 8),LegSweep=v16(262934 - 143553, nil, 27 - (9 + 5)),Provoke=v16(115922 - (85 + 291), nil, 1279 - (243 + 1022)),Resuscitate=v16(438272 - 323094, nil, 13 + 2),RisingSunKick=v16(108608 - (1123 + 57), nil, 14 + 2),Roll=v16(109386 - (163 + 91), nil, 1947 - (1869 + 61)),TigerPalm=v16(28156 + 72624, nil, 63 - 45),TouchofDeath=v16(494743 - 172634, nil, 3 + 16),Transcendence=v16(139681 - 38038, nil, 19 + 1),TranscendenceTransfer=v16(121470 - (1329 + 145), nil, 992 - (140 + 831)),Vivify=v16(118520 - (1409 + 441), nil, 740 - (15 + 703)),BonedustBrew=v16(178887 + 207389, nil, 461 - (262 + 176)),Celerity=v16(116894 - (345 + 1376), nil, 712 - (198 + 490)),ChiBurst=v16(547765 - 423779, nil, 59 - 34),ChiTorpedo=v16(116214 - (696 + 510), nil, 54 - 28),ChiWave=v16(116360 - (1091 + 171), nil, 5 + 22),DampenHarm=v16(384972 - 262694, nil, 92 - 64),Detox=v16(218538 - (123 + 251), nil, 144 - 115),Disable=v16(116793 - (208 + 490), nil, 3 + 27),DiffuseMagic=v16(54694 + 68089, nil, 867 - (660 + 176)),EyeoftheTiger=v16(23622 + 172985, nil, 234 - (14 + 188)),InnerStrengthBuff=v16(262444 - (534 + 141), nil, 14 + 19),Paralysis=v16(101792 + 13286, nil, 33 + 1),RingOfPeace=v16(245552 - 128708, nil, 55 - 20),RushingJadeWind=v16(327760 - 210913, nil, 20 + 16),SpearHandStrike=v16(74308 + 42397, nil, 433 - (115 + 281)),SummonWhiteTigerStatue=v16(904097 - 515411, nil, 32 + 6),TigerTailSweep=v16(638864 - 374516, nil, 142 - 103),TigersLust=v16(117708 - (550 + 317), nil, 57 - 17),BonedustBrewBuff=v16(542939 - 156663, nil, 114 - 73),DampenHarmBuff=v16(122563 - (134 + 151), nil, 1707 - (970 + 695)),RushingJadeWindBuff=v16(222971 - 106124, nil, 2033 - (582 + 1408)),CalltoDominanceBuff=v16(1398953 - 995573, nil, 188 - 38),DomineeringArroganceBuff=v16(1551285 - 1139624, nil, 1975 - (1195 + 629)),TheEmperorsCapacitorBuff=v16(310858 - 75804, nil, 285 - (187 + 54)),PoolEnergy=v16(1000690 - (162 + 618), nil, 32 + 13),ImpTouchofDeath=v16(214541 + 107572, nil, 315 - 167),StrengthofSpirit=v16(651084 - 263808, nil, 12 + 137)};
	v16.Monk.Windwalker = v19(v16.Monk.Commons, {BlackoutKick=v16(102420 - (1373 + 263), nil, 1047 - (451 + 549)),FlyingSerpentKick=v16(32054 + 69491, nil, 74 - 26),FlyingSerpentKickLand=v16(193371 - 78314, nil, 1433 - (746 + 638)),SpinningCraneKick=v16(38216 + 63330, nil, 75 - 25),BonedustBrew=v16(386617 - (218 + 123), nil, 1632 - (1535 + 46)),CraneVortex=v16(386360 + 2488, nil, 8 + 44),DanceofChiji=v16(325761 - (306 + 254), nil, 10 + 142),FastFeet=v16(763053 - 374244, nil, 1520 - (899 + 568)),FaelineHarmony=v16(257275 + 134137, nil, 130 - 76),FaelineStomp=v16(388796 - (268 + 335), nil, 345 - (60 + 230)),FistsofFury=v16(114228 - (426 + 146), nil, 7 + 49),HitCombo=v16(198196 - (282 + 1174), nil, 868 - (569 + 242)),InvokeXuenTheWhiteTiger=v16(356916 - 233012, nil, 4 + 54),MarkoftheCrane=v16(221381 - (706 + 318), nil, 1310 - (721 + 530)),Serenity=v16(153444 - (945 + 326), nil, 149 - 89),ShadowboxingTreads=v16(349683 + 43299, nil, 761 - (271 + 429)),StormEarthAndFire=v16(126436 + 11203, nil, 1562 - (1408 + 92)),StormEarthAndFireFixate=v16(222857 - (461 + 625), nil, 1351 - (993 + 295)),StrikeoftheWindlord=v16(20406 + 372577, nil, 1235 - (418 + 753)),TeachingsoftheMonastery=v16(44425 + 72220, nil, 7 + 58),Thunderfist=v16(114942 + 278043, nil, 17 + 49),WhirlingDragonPunch=v16(152704 - (406 + 123), nil, 1836 - (1749 + 20)),XuensBattlegear=v16(93347 + 299646, nil, 1390 - (1249 + 73)),Skyreach=v16(140207 + 252784, nil, 1282 - (466 + 679)),Skytouch=v16(974321 - 569277, nil, 394 - 256),InvokersDelightBuff=v16(390563 - (106 + 1794), nil, 44 + 95),DrinkingHornCover=v16(98931 + 292439, nil, 413 - 273),JadeIgnition=v16(1064163 - 671184, nil, 255 - (4 + 110)),HiddenMastersForbiddenTouchBuff=v16(213698 - (57 + 527), nil, 1569 - (41 + 1386)),PressurePointBuff=v16(337585 - (17 + 86), nil, 98 + 45),FaeExposureDebuff=v16(881818 - 486404, nil, 416 - 272),SkyreachCritDebuff=v16(393213 - (122 + 44), nil, 250 - 105),KicksofFlowingMomentumBuff=v16(1310214 - 915270, nil, 119 + 27),FistsofFlowingMomentumBuff=v16(57119 + 337830, nil, 297 - 150),FortifyingBrew=v16(243500 - (30 + 35), nil, 48 + 21),TouchofKarma=v16(123727 - (1043 + 214), nil, 264 - 194),BlackoutKickBuff=v16(117980 - (323 + 889), nil, 190 - 119),ChiEnergyBuff=v16(393637 - (361 + 219), nil, 392 - (53 + 267)),DanceofChijiBuff=v16(73470 + 251732, nil, 486 - (15 + 398)),HitComboBuff=v16(197723 - (18 + 964), nil, 278 - 204),PowerStrikesBuff=v16(75216 + 54698, nil, 48 + 27),SerenityBuff=v16(153023 - (20 + 830), nil, 60 + 16),StormEarthAndFireBuff=v16(137765 - (116 + 10), nil, 6 + 71),TeachingsoftheMonasteryBuff=v16(202828 - (542 + 196), nil, 167 - 89),WhirlingDragonPunchBuff=v16(57452 + 139290, nil, 41 + 38),MarkoftheCraneDebuff=v16(82176 + 146111, nil, 210 - 130),SkyreachExhaustionDebuff=v16(1007697 - 614647, nil, 1632 - (1126 + 425)),KicksofFlowingMomentumBuff=v16(395349 - (118 + 287), nil, 321 - 239),FistsofFlowingMomentumBuff=v16(396070 - (118 + 1003), nil, 242 - 159),BlackoutReinforcementBuff=v16(424831 - (142 + 235), nil, 694 - 541)});
	v16.Monk.Brewmaster = v19(v16.Monk.Commons, {BlackoutKick=v16(44720 + 160803, nil, 1061 - (553 + 424)),BreathOfFire=v16(217802 - 102621, nil, 75 + 10),Clash=v16(321712 + 2600, nil, 51 + 35),InvokeNiuzaoTheBlackOx=v16(56358 + 76220, nil, 50 + 37),KegSmash=v16(262863 - 141610, nil, 244 - 156),SpinningCraneKick=v16(722603 - 399874, nil, 26 + 63),BreathOfFireDotDebuff=v16(597920 - 474195, nil, 843 - (239 + 514)),BlackoutCombo=v16(69096 + 127640, nil, 1420 - (797 + 532)),BlackoutComboBuff=v16(166078 + 62485, nil, 32 + 60),BlackOxBrew=v16(271331 - 155932, nil, 1295 - (373 + 829)),BobAndWeave=v16(281246 - (476 + 255), nil, 1224 - (369 + 761)),CelestialFlames=v16(188106 + 137071, nil, 172 - 77),ExplodingKeg=v16(616165 - 291012, nil, 334 - (64 + 174)),HighTolerance=v16(28020 + 168717, nil, 143 - 46),LightBrewing=v16(325429 - (144 + 192), nil, 314 - (42 + 174)),SpecialDelivery=v16(147791 + 48939, nil, 83 + 16),Spitfire=v16(103059 + 139521, nil, 1604 - (363 + 1141)),SummonBlackOxStatue=v16(116895 - (1183 + 397), nil, 307 - 206),WeaponsOfOrder=v16(283824 + 103360, nil, 77 + 25),CelestialBrew=v16(324482 - (1913 + 62), nil, 65 + 38),ElusiveBrawlerBuff=v16(517892 - 322262, nil, 2037 - (565 + 1368)),FortifyingBrew=v16(433247 - 318044, nil, 1766 - (1477 + 184)),FortifyingBrewBuff=v16(156972 - 41769, nil, 99 + 7),PurifyingBrew=v16(120438 - (564 + 292), nil, 184 - 77),PurifiedChiBuff=v16(979881 - 654789, nil, 412 - (244 + 60)),Shuffle=v16(165685 + 49794, nil, 585 - (41 + 435)),HealingElixir=v16(123282 - (938 + 63), nil, 85 + 25),CharredPassions=v16(339265 - (936 + 189), nil, 37 + 74),MightyPour=v16(339607 - (1565 + 48), nil, 70 + 42),HeavyStagger=v16(125411 - (782 + 356), nil, 380 - (176 + 91)),ModerateStagger=v16(323774 - 199500, nil, 167 - 53),LightStagger=v16(125367 - (975 + 117), nil, 1990 - (157 + 1718))});
	v16.Monk.Mistweaver = v19(v16.Monk.Commons, {BlackoutKick=v16(81792 + 18992, nil, 411 - 295),EnvelopingMist=v16(426264 - 301582, nil, 1135 - (697 + 321)),EssenceFont=v16(522588 - 330751, nil, 249 - 131),EssenceFontBuff=v16(442264 - 250424, nil, 47 + 72),InvokeYulonTheJadeSerpent=v16(232153 - 108249, nil, 321 - 201),LifeCocoon=v16(118076 - (322 + 905), nil, 732 - (602 + 9)),RenewingMist=v16(116340 - (449 + 740), nil, 994 - (826 + 46)),Revival=v16(116257 - (245 + 702), nil, 388 - 265),SoothingMist=v16(37026 + 78149, nil, 2022 - (260 + 1638)),SpinningCraneKick=v16(101986 - (382 + 58), nil, 401 - 276),TeachingsOfTheMonasteryBuff=v16(167928 + 34162, nil, 259 - 133),ThunderFocusTea=v16(346843 - 230163, nil, 1332 - (902 + 303)),InvokeChiJiTheRedCrane=v16(714015 - 388818, nil, 308 - 180),LifecyclesEnvelopingMistBuff=v16(17008 + 180911, nil, 1819 - (1121 + 569)),LifecyclesVivifyBuff=v16(198130 - (22 + 192), nil, 813 - (483 + 200)),ManaTea=v16(199371 - (1404 + 59), nil, 358 - 227),RefreshingJadeWind=v16(264404 - 67679, nil, 897 - (468 + 297)),SongOfChiJi=v16(199460 - (334 + 228), nil, 448 - 315),SummonJadeSerpentStatue=v16(267285 - 151972, nil, 242 - 108),FortifyingBrew=v16(69127 + 174308, nil, 371 - (141 + 95)),Reawaken=v16(208300 + 3751, nil, 349 - 213)});
	if (((11019 - 6435) == (1074 + 3510)) and not v18.Monk) then
		v18.Monk = {};
	end
	v18.Monk.Commons = {AlgetharPuzzleBox=v18(530717 - 337016, {(7 + 6),(9 + 5)}),BeacontotheBeyond=v18(204126 - (92 + 71), {(21 - 8),(12 + 2)}),DragonfireBombDispenser=v18(507600 - 304990, {(863 - (254 + 595)),(18 - 4)}),EruptingSpearFragment=v18(195559 - (573 + 1217), {(1 + 12),(953 - (714 + 225))}),IrideusFragment=v18(566194 - 372451, {(2 + 11),(820 - (118 + 688))}),ManicGrieftorch=v18(194356 - (25 + 23), {(1899 - (927 + 959)),(746 - (16 + 716))}),AshesoftheEmbersoul=v18(399916 - 192749, {(31 - 18),(35 - 21)}),MirrorofFracturedTomorrows=v18(1023841 - 816260, {(36 - 23),(1075 - (810 + 251))}),NeltharionsCalltoDominance=v18(141712 + 62490, {(12 + 1),(747 - (711 + 22))}),WitherbarksBranch=v18(425498 - 315499, {(4 + 9),(1 + 13)}),RefreshingHealingPotion=v18(193124 - (1344 + 400)),Healthstone=v18(5917 - (255 + 150)),Djaruun=v18(159559 + 43010)};
	v18.Monk.Windwalker = v19(v18.Monk.Commons, {});
	v18.Monk.Brewmaster = v19(v18.Monk.Commons, {});
	v18.Monk.Mistweaver = v19(v18.Monk.Commons, {});
	if (((2131 + 1848) >= (7126 - 5458)) and not v21.Monk) then
		v21.Monk = {};
	end
	v21.Monk.Commons = {Healthstone=v21(67 - 46),Djaruun=v21(1761 - (404 + 1335)),RefreshingHealingPotion=v21(429 - (183 + 223)),AlgetharPuzzleBox=v21(28 - 4),BonedustBrewPlayer=v21(17 + 8),BonedustBrewCursor=v21(10 + 16),DetoxMouseover=v21(364 - (10 + 327)),RingOfPeaceCursor=v21(7 + 2),SpearHandStrikeMouseover=v21(348 - (118 + 220)),SummonWhiteTigerStatuePlayer=v21(4 + 7),SummonWhiteTigerStatueCursor=v21(461 - (108 + 341)),TigerPalmMouseover=v21(6 + 7),DetoxFocus=v21(59 - 45),ParalysisMouseover=v21(1508 - (711 + 782))};
	v21.Monk.Windwalker = v19(v21.Monk.Commons, {SummonWhiteTigerStatueM=v21(30 - 14),BonedustBrewM=v21(486 - (270 + 199)),TrinketTop=v21(10 + 18),TrinketBottom=v21(1848 - (580 + 1239)),StopFoF=v16(89 - 59)});
	v21.Monk.Brewmaster = v19(v21.Monk.Commons, {ExplodingKegPlayer=v21(18 + 0),ExplodingKegCursor=v21(1 + 18)});
	v21.Monk.Mistweaver = v19(v21.Monk.Commons, {});
	local v38 = v16.Monk.Brewmaster;
	local v39 = v16.Monk.Windwalker;
	local v40;
	v40 = v10.AddCoreOverride("Spell.IsCastable", function(v53, v54, v55, v56, v57, v58)
		local v59 = v40(v53, v54, v55, v56, v57, v58);
		if (((248 + 320) > (1117 - 689)) and (v53 == v38.TouchOfDeath)) then
			return v59 and v53:IsUsable();
		else
			return v59;
		end
	end, 167 + 101);
	local v41 = 116236 - (645 + 522);
	local v42 = 126045 - (1010 + 780);
	local v43 = v16(280377 + 138, nil, 652 - 515);
	local v44 = 0 - 0;
	local v45 = {};
	local v46 = {};
	local function v47(v60)
		local v61 = 1836 - (1045 + 791);
		local v62;
		while true do
			if (((3376 - 2042) <= (7043 - 2430)) and (v61 == (505 - (351 + 154)))) then
				v62 = (1584 - (1281 + 293)) + ((v43:IsAvailable() and (269 - (28 + 238))) or (0 - 0));
				v44 = v44 + v60;
				v61 = 1560 - (1381 + 178);
			end
			if ((v61 == (1 + 0)) or ((1504 + 361) >= (866 + 1163))) then
				v22.After(v62, function()
					v44 = v44 - v60;
				end);
				break;
			end
		end
	end
	local function v48(v63)
		if (((17064 - 12114) >= (838 + 778)) and (#v45 == (480 - (381 + 89)))) then
			v23(v45, 9 + 1);
		end
		v24(v45, 1 + 0, v63);
	end
	local function v49(v64)
		while (#v46 > (0 - 0)) and (v46[#v46][1157 - (1074 + 82)] < (v25() - (12 - 6))) do
			v23(v46, #v46);
		end
		v24(v46, 1785 - (214 + 1570), {v25(),v64});
	end
	v13.StaggerFull = function(v65)
		return v44;
	end;
	v13.StaggerLastTickDamage = function(v66, v67)
		local v68 = 0 + 0;
		local v69;
		while true do
			if (((1678 + 47) == (6788 - 5063)) and (v68 == (1727 - (1668 + 58)))) then
				for v99 = 627 - (512 + 114), v67 do
					v69 = v69 + v45[v99];
				end
				return v69;
			end
			if (((3803 - 2344) <= (5130 - 2648)) and (v68 == (0 - 0))) then
				v69 = 0 + 0;
				if ((v67 > #v45) or ((505 + 2191) >= (3940 + 592))) then
					v67 = #v45;
				end
				v68 = 3 - 2;
			end
		end
	end;
	v13.IncomingDamageTaken = function(v70, v71)
		local v72 = 1994 - (109 + 1885);
		local v73;
		local v74;
		while true do
			if (((2517 - (1269 + 200)) >= (99 - 47)) and (v72 == (815 - (98 + 717)))) then
				v73 = 826 - (802 + 24);
				v74 = v71 / (1724 - 724);
				v72 = 1 - 0;
			end
			if (((437 + 2521) < (3460 + 1043)) and (v72 == (1 + 0))) then
				for v100 = 1 + 0, #v46 do
					if ((v46[v100][2 - 1] > (v25() - v74)) or ((9120 - 6385) == (469 + 840))) then
						v73 = v73 + v46[v100][1 + 1];
					end
				end
				return v73;
			end
		end
	end;
	v10:RegisterForCombatEvent(function(...)
		local v75 = {...};
		if ((#v75 == (17 + 6)) or ((1929 + 2201) <= (4388 - (797 + 636)))) then
			local v90, v90, v90, v90, v90, v90, v90, v91, v90, v90, v90, v90, v90, v90, v90, v90, v90, v90, v92, v90, v90, v93 = ...;
			if (((v91 == v13:GUID()) and (v92 == v41)) or ((9535 - 7571) <= (2959 - (1427 + 192)))) then
				v47(v93);
			end
		else
			local v94 = 0 + 0;
			local v95;
			local v96;
			local v97;
			local v98;
			while true do
				if (((5801 - 3302) == (2247 + 252)) and (v94 == (0 + 0))) then
					v95, v95, v95, v95, v95, v95, v95, v96, v95, v95, v95, v95, v95, v95, v95, v97, v95, v95, v98 = ...;
					if (((v96 == v13:GUID()) and (v97 == v41)) or ((2581 - (192 + 134)) < (1298 - (316 + 960)))) then
						v47(v98);
					end
					break;
				end
			end
		end
	end, "SPELL_ABSORBED");
	v10:RegisterForCombatEvent(function(...)
		local v76 = 0 + 0;
		local v77;
		local v78;
		local v79;
		local v80;
		while true do
			if ((v76 == (0 + 0)) or ((1004 + 82) >= (5371 - 3966))) then
				v77, v77, v77, v77, v77, v77, v77, v78, v77, v77, v77, v79, v77, v77, v80 = ...;
				if (((v78 == v13:GUID()) and (v79 == v42) and (v80 > (551 - (83 + 468)))) or ((4175 - (1202 + 604)) == (1988 - 1562))) then
					v48(v80);
				end
				break;
			end
		end
	end, "SPELL_PERIODIC_DAMAGE");
	v10:RegisterForCombatEvent(function(...)
		local v81 = 0 - 0;
		local v82;
		local v83;
		local v84;
		while true do
			if ((v81 == (0 - 0)) or ((3401 - (45 + 280)) > (3073 + 110))) then
				v82, v82, v82, v82, v82, v82, v82, v83, v82, v82, v82, v82, v82, v82, v84 = ...;
				if (((1051 + 151) > (387 + 671)) and (v11.Persistent.Player.Spec[1 + 0] == (48 + 220)) and (v83 == v13:GUID()) and (v84 ~= nil) and (v84 > (0 - 0))) then
					v49(v84);
				end
				break;
			end
		end
	end, "SWING_DAMAGE", "SPELL_DAMAGE", "SPELL_PERIODIC_DAMAGE");
	v10:RegisterForEvent(function()
		local v85 = 1911 - (340 + 1571);
		while true do
			if (((1464 + 2247) > (5127 - (1733 + 39))) and (v85 == (0 - 0))) then
				if ((#v45 > (1034 - (125 + 909))) or ((2854 - (1096 + 852)) >= (1000 + 1229))) then
					for v101 = 0 - 0, #v45 do
						v45[v101] = nil;
					end
				end
				if (((1250 + 38) > (1763 - (409 + 103))) and (#v46 > (236 - (46 + 190)))) then
					for v103 = 95 - (51 + 44), #v46 do
						v46[v103] = nil;
					end
				end
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
end;
return v0["Epix_Monk_Monk.lua"]();

