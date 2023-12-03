local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2831 - 1237) > (2163 + 17))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Monk_Monk.lua"] = function(...)
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
	local v21 = C_Timer;
	local v22 = table.remove;
	local v23 = table.insert;
	local v24 = GetTime;
	if (((3865 - (368 + 423)) == (9660 - 6586)) and not v15.Monk) then
		v15.Monk = {};
	end
	v15.Monk.Commons = {AncestralCall=v15(274756 - (10 + 8), nil, 3 - 2),ArcaneTorrent=v15(25488 - (416 + 26), nil, 6 - 4),BagofTricks=v15(134072 + 178339, nil, 4 - 1),Berserking=v15(26735 - (145 + 293), nil, 434 - (44 + 386)),BloodFury=v15(22058 - (998 + 488), nil, 2 + 3),GiftoftheNaaru=v15(48759 + 10788, nil, 778 - (201 + 571)),Fireblood=v15(266359 - (116 + 1022), nil, 29 - 22),LightsJudgment=v15(150059 + 105588, nil, 29 - 21),QuakingPalm=v15(380246 - 273167, nil, 868 - (814 + 45)),Shadowmeld=v15(145334 - 86350, nil, 1 + 9),CracklingJadeLightning=v15(41677 + 76275, nil, 896 - (261 + 624)),ExpelHarm=v15(572404 - 250303, nil, 1092 - (1020 + 60)),LegSweep=v15(120804 - (630 + 793), nil, 43 - 30),Provoke=v15(547082 - 431536, nil, 6 + 8),Resuscitate=v15(396562 - 281384, nil, 1762 - (760 + 987)),RisingSunKick=v15(109341 - (1789 + 124), nil, 782 - (745 + 21)),Roll=v15(37538 + 71594, nil, 46 - 29),TigerPalm=v15(395311 - 294531, nil, 1 + 17),TouchofDeath=v15(252895 + 69214, nil, 1074 - (87 + 968)),Transcendence=v15(447426 - 345783, nil, 19 + 1),TranscendenceTransfer=v15(271256 - 151260, nil, 1434 - (447 + 966)),Vivify=v15(319401 - 202731, nil, 1839 - (1703 + 114)),BonedustBrew=v15(386977 - (376 + 325), nil, 37 - 14),Celerity=v15(354384 - 239211, nil, 7 + 17),ChiBurst=v15(273076 - 149090, nil, 39 - (9 + 5)),ChiTorpedo=v15(115384 - (85 + 291), nil, 1291 - (243 + 1022)),ChiWave=v15(437968 - 322870, nil, 23 + 4),DampenHarm=v15(123458 - (1123 + 57), nil, 23 + 5),Detox=v15(218418 - (163 + 91), nil, 1959 - (1869 + 61)),Disable=v15(32434 + 83661, nil, 105 - 75),DiffuseMagic=v15(188588 - 65805, nil, 5 + 26),EyeoftheTiger=v15(270186 - 73579, nil, 31 + 1),InnerStrengthBuff=v15(263243 - (1329 + 145), nil, 1004 - (140 + 831)),Paralysis=v15(116928 - (1409 + 441), nil, 752 - (15 + 703)),RingOfPeace=v15(54112 + 62732, nil, 473 - (262 + 176)),RushingJadeWind=v15(118568 - (345 + 1376), nil, 724 - (198 + 490)),SpearHandStrike=v15(515598 - 398893, nil, 88 - 51),SummonWhiteTigerStatue=v15(389892 - (696 + 510), nil, 79 - 41),TigerTailSweep=v15(265610 - (1091 + 171), nil, 7 + 32),TigersLust=v15(367855 - 251014, nil, 132 - 92),BonedustBrewBuff=v15(386650 - (123 + 251), nil, 203 - 162),DampenHarmBuff=v15(122976 - (208 + 490), nil, 4 + 38),RushingJadeWindBuff=v15(52049 + 64798, nil, 879 - (660 + 176)),CalltoDominanceBuff=v15(48464 + 354916, nil, 352 - (14 + 188)),DomineeringArroganceBuff=v15(412336 - (534 + 141), nil, 61 + 90),TheEmperorsCapacitorBuff=v15(207916 + 27138, nil, 43 + 1),PoolEnergy=v15(2101356 - 1101446, nil, 71 - 26),ImpTouchofDeath=v15(903541 - 581428, nil, 80 + 68),StrengthofSpirit=v15(246584 + 140692, nil, 545 - (115 + 281))};
	v15.Monk.Windwalker = v18(v15.Monk.Commons, {BlackoutKick=v15(234426 - 133642, nil, 39 + 8),FlyingSerpentKick=v15(245409 - 143864, nil, 175 - 127),FlyingSerpentKickLand=v15(115924 - (550 + 317), nil, 70 - 21),SpinningCraneKick=v15(142730 - 41184, nil, 139 - 89),BonedustBrew=v15(386561 - (134 + 151), nil, 1716 - (970 + 695)),CraneVortex=v15(742013 - 353165, nil, 2042 - (582 + 1408)),DanceofChiji=v15(1127822 - 802621, nil, 190 - 38),FastFeet=v15(1465171 - 1076362, nil, 1877 - (1195 + 629)),FaelineHarmony=v15(517641 - 126229, nil, 295 - (187 + 54)),FaelineStomp=v15(388973 - (162 + 618), nil, 39 + 16),FistsofFury=v15(75700 + 37956, nil, 119 - 63),HitCombo=v15(330757 - 134017, nil, 5 + 52),InvokeXuenTheWhiteTiger=v15(125540 - (1373 + 263), nil, 1058 - (451 + 549)),MarkoftheCrane=v15(69559 + 150798, nil, 91 - 32),Serenity=v15(255751 - 103578, nil, 1444 - (746 + 638)),ShadowboxingTreads=v15(147894 + 245088, nil, 92 - 31),StormEarthAndFire=v15(137980 - (218 + 123), nil, 1643 - (1535 + 46)),StormEarthAndFireFixate=v15(220352 + 1419, nil, 10 + 53),StrikeoftheWindlord=v15(393543 - (306 + 254), nil, 4 + 60),TeachingsoftheMonastery=v15(228920 - 112275, nil, 1532 - (899 + 568)),Thunderfist=v15(258309 + 134676, nil, 159 - 93),WhirlingDragonPunch=v15(152778 - (268 + 335), nil, 357 - (60 + 230)),XuensBattlegear=v15(393565 - (426 + 146), nil, 9 + 59),Skyreach=v15(394447 - (282 + 1174), nil, 948 - (569 + 242)),Skytouch=v15(1166767 - 761723, nil, 8 + 130),InvokersDelightBuff=v15(389687 - (706 + 318), nil, 1390 - (721 + 530)),DrinkingHornCover=v15(392641 - (945 + 326), nil, 349 - 209),JadeIgnition=v15(349681 + 43298, nil, 841 - (271 + 429)),HiddenMastersForbiddenTouchBuff=v15(195768 + 17346, nil, 1642 - (1408 + 92)),PressurePointBuff=v15(338568 - (461 + 625), nil, 1431 - (993 + 295)),FaeExposureDebuff=v15(20533 + 374881, nil, 1315 - (418 + 753)),SkyreachCritDebuff=v15(149694 + 243353, nil, 15 + 130),KicksofFlowingMomentumBuff=v15(115515 + 279429, nil, 37 + 109),FistsofFlowingMomentumBuff=v15(395478 - (406 + 123), nil, 1916 - (1749 + 20)),FortifyingBrew=v15(57823 + 185612, nil, 1391 - (1249 + 73)),TouchofKarma=v15(43694 + 78776, nil, 1215 - (466 + 679)),BlackoutKickBuff=v15(280881 - 164113, nil, 203 - 132),ChiEnergyBuff=v15(394957 - (106 + 1794), nil, 23 + 49),DanceofChijiBuff=v15(82205 + 242997, nil, 215 - 142),HitComboBuff=v15(532762 - 336021, nil, 188 - (4 + 110)),PowerStrikesBuff=v15(130498 - (57 + 527), nil, 1502 - (41 + 1386)),SerenityBuff=v15(152276 - (17 + 86), nil, 52 + 24),StormEarthAndFireBuff=v15(306950 - 169311, nil, 222 - 145),TeachingsoftheMonasteryBuff=v15(202256 - (122 + 44), nil, 134 - 56),WhirlingDragonPunchBuff=v15(652685 - 455943, nil, 65 + 14),MarkoftheCraneDebuff=v15(33016 + 195271, nil, 162 - 82),SkyreachExhaustionDebuff=v15(393115 - (30 + 35), nil, 56 + 25),KicksofFlowingMomentumBuff=v15(396201 - (1043 + 214), nil, 309 - 227),FistsofFlowingMomentumBuff=v15(396161 - (323 + 889), nil, 222 - 139),BlackoutReinforcementBuff=v15(425034 - (361 + 219), nil, 473 - (53 + 267))});
	v15.Monk.Brewmaster = v18(v15.Monk.Commons, {BlackoutKick=v15(46432 + 159091, nil, 497 - (15 + 398)),BreathOfFire=v15(116163 - (18 + 964), nil, 319 - 234),Clash=v15(187765 + 136547, nil, 55 + 31),InvokeNiuzaoTheBlackOx=v15(133428 - (20 + 830), nil, 68 + 19),KegSmash=v15(121379 - (116 + 10), nil, 7 + 81),SpinningCraneKick=v15(323467 - (542 + 196), nil, 190 - 101),BreathOfFireDotDebuff=v15(36130 + 87595, nil, 46 + 44),BlackoutCombo=v15(70819 + 125917, nil, 239 - 148),BlackoutComboBuff=v15(585987 - 357424, nil, 1643 - (1126 + 425)),BlackOxBrew=v15(115804 - (118 + 287), nil, 364 - 271),BobAndWeave=v15(281636 - (118 + 1003), nil, 275 - 181),CelestialFlames=v15(325554 - (142 + 235), nil, 430 - 335),ExplodingKeg=v15(70750 + 254403, nil, 1073 - (553 + 424)),HighTolerance=v15(372021 - 175284, nil, 86 + 11),LightBrewing=v15(322486 + 2607, nil, 58 + 40),SpecialDelivery=v15(83628 + 113102, nil, 57 + 42),Spitfire=v15(525887 - 283307, nil, 278 - 178),SummonBlackOxStatue=v15(258195 - 142880, nil, 30 + 71),WeaponsOfOrder=v15(1871128 - 1483944, nil, 855 - (239 + 514)),CelestialBrew=v15(113268 + 209239, nil, 1432 - (797 + 532)),ElusiveBrawlerBuff=v15(142148 + 53482, nil, 36 + 68),FortifyingBrew=v15(270870 - 155667, nil, 1307 - (373 + 829)),FortifyingBrewBuff=v15(115934 - (476 + 255), nil, 1236 - (369 + 761)),PurifyingBrew=v15(69175 + 50407, nil, 193 - 86),PurifiedChiBuff=v15(616050 - 290958, nil, 346 - (64 + 174)),Shuffle=v15(30690 + 184789, nil, 160 - 51),HealingElixir=v15(122617 - (144 + 192), nil, 326 - (42 + 174)),CharredPassions=v15(254023 + 84117, nil, 92 + 19),MightyPour=v15(143595 + 194399, nil, 1616 - (363 + 1141)),HeavyStagger=v15(125853 - (1183 + 397), nil, 343 - 230),ModerateStagger=v15(91099 + 33175, nil, 86 + 28),LightStagger=v15(126250 - (1913 + 62), nil, 73 + 42)});
	v15.Monk.Mistweaver = v18(v15.Monk.Commons, {BlackoutKick=v15(266805 - 166021, nil, 2049 - (565 + 1368)),EnvelopingMist=v15(468895 - 344213, nil, 1778 - (1477 + 184)),EssenceFont=v15(261393 - 69556, nil, 110 + 8),EssenceFontBuff=v15(192696 - (564 + 292), nil, 204 - 85),InvokeYulonTheJadeSerpent=v15(373467 - 249563, nil, 424 - (244 + 60)),LifeCocoon=v15(89847 + 27002, nil, 597 - (41 + 435)),RenewingMist=v15(116152 - (938 + 63), nil, 94 + 28),Revival=v15(116435 - (936 + 189), nil, 41 + 82),SoothingMist=v15(116788 - (1565 + 48), nil, 77 + 47),SpinningCraneKick=v15(102684 - (782 + 356), nil, 392 - (176 + 91)),TeachingsOfTheMonasteryBuff=v15(526511 - 324421, nil, 185 - 59),ThunderFocusTea=v15(117772 - (975 + 117), nil, 2002 - (157 + 1718)),InvokeChiJiTheRedCrane=v15(263915 + 61282, nil, 454 - 326),LifecyclesEnvelopingMistBuff=v15(676647 - 478728, nil, 1147 - (697 + 321)),LifecyclesVivifyBuff=v15(539148 - 341232, nil, 275 - 145),ManaTea=v15(456253 - 258345, nil, 51 + 80),RefreshingJadeWind=v15(368595 - 171870, nil, 353 - 221),SongOfChiJi=v15(200125 - (322 + 905), nil, 744 - (602 + 9)),SummonJadeSerpentStatue=v15(116502 - (449 + 740), nil, 1006 - (826 + 46)),FortifyingBrew=v15(244382 - (245 + 702), nil, 426 - 291),Reawaken=v15(68168 + 143883, nil, 2034 - (260 + 1638))});
	if (((810 - (382 + 58)) >= (628 - 432)) and not v17.Monk) then
		v17.Monk = {};
	end
	v17.Monk.Commons = {AlgetharPuzzleBox=v17(160957 + 32744, {(38 - 25),(30 - 16)}),BeacontotheBeyond=v17(491245 - 287282, {(1703 - (1121 + 569)),(697 - (483 + 200))}),DragonfireBombDispenser=v17(204073 - (1404 + 59), {(18 - 4),(576 - (334 + 228))}),EruptingSpearFragment=v17(653580 - 459811, {(23 - 10),(250 - (141 + 95))}),IrideusFragment=v17(190316 + 3427, {(30 - 17),(38 - 24)}),ManicGrieftorch=v17(136597 + 57711, {(18 - 5),(177 - (92 + 71))}),AshesoftheEmbersoul=v17(102329 + 104838, {(778 - (574 + 191)),(34 - 20)}),MirrorofFracturedTomorrows=v17(106030 + 101551, {(139 - (55 + 71)),(1804 - (573 + 1217))}),NeltharionsCalltoDominance=v17(565521 - 361319, {(20 - 7),(40 - 26)}),WitherbarksBranch=v17(153355 - 43356, {(18 - 5),(62 - (25 + 23))}),RefreshingHealingPotion=v17(37068 + 154312),Healthstone=v17(7398 - (927 + 959)),Djaruun=v17(682839 - 480270)};
	v17.Monk.Windwalker = v18(v17.Monk.Commons, {});
	v17.Monk.Brewmaster = v18(v17.Monk.Commons, {});
	v17.Monk.Mistweaver = v18(v17.Monk.Commons, {});
	if (not v20.Monk or ((3900 - (16 + 716)) < (968 - 466))) then
		v20.Monk = {};
	end
	v20.Monk.Commons = {Healthstone=v20(118 - (11 + 86)),Djaruun=v20(53 - 31),RefreshingHealingPotion=v20(308 - (175 + 110)),AlgetharPuzzleBox=v20(60 - 36),BonedustBrewPlayer=v20(123 - 98),BonedustBrewCursor=v20(1822 - (503 + 1293)),DetoxMouseover=v20(75 - 48),RingOfPeaceCursor=v20(7 + 2),SpearHandStrikeMouseover=v20(1071 - (810 + 251)),SummonWhiteTigerStatuePlayer=v20(8 + 3),SummonWhiteTigerStatueCursor=v20(4 + 8),TigerPalmMouseover=v20(12 + 1),DetoxFocus=v20(547 - (43 + 490)),ParalysisMouseover=v20(748 - (711 + 22))};
	v20.Monk.Windwalker = v18(v20.Monk.Commons, {SummonWhiteTigerStatueM=v20(61 - 45),BonedustBrewM=v20(876 - (240 + 619)),TrinketTop=v20(7 + 21),TrinketBottom=v20(45 - 16),StopFoF=v15(2 + 28)});
	v20.Monk.Brewmaster = v18(v20.Monk.Commons, {ExplodingKegPlayer=v20(1762 - (1344 + 400)),ExplodingKegCursor=v20(424 - (255 + 150))});
	v20.Monk.Mistweaver = v18(v20.Monk.Commons, {});
	local v37 = v15.Monk.Brewmaster;
	local v38 = v15.Monk.Windwalker;
	local v39;
	v39 = v9.AddCoreOverride("Spell.IsCastable", function(v52, v53, v54, v55, v56, v57)
		local v58 = 0 + 0;
		local v59;
		while true do
			if (((236 + 203) == (1875 - 1436)) and (v58 == (0 - 0))) then
				v59 = v39(v52, v53, v54, v55, v56, v57);
				if ((v52 == v37.TouchOfDeath) or ((3003 - (404 + 1335)) < (678 - (183 + 223)))) then
					return v59 and v52:IsUsable();
				else
					return v59;
				end
				break;
			end
		end
	end, 325 - 57);
	local v40 = 76244 + 38825;
	local v41 = 44717 + 79538;
	local v42 = v15(280852 - (10 + 327), nil, 96 + 41);
	local v43 = 338 - (118 + 220);
	local v44 = {};
	local v45 = {};
	local function v46(v60)
		local v61 = 4 + 6 + ((v42:IsAvailable() and (452 - (108 + 341))) or (0 + 0));
		v43 = v43 + v60;
		v21.After(v61, function()
			v43 = v43 - v60;
		end);
	end
	local function v47(v62)
		local v63 = 0 - 0;
		while true do
			if (((4616 - (711 + 782)) < (7458 - 3567)) and (v63 == (469 - (270 + 199)))) then
				if (((1278 + 2664) <= (6806 - (580 + 1239))) and (#v44 == (29 - 19))) then
					v22(v44, 10 + 0);
				end
				v23(v44, 1 + 0, v62);
				break;
			end
		end
	end
	local function v48(v64)
		while (#v45 > (0 + 0)) and (v45[#v45][2 - 1] < (v24() - (4 + 2))) do
			v22(v45, #v45);
		end
		v23(v45, 1168 - (645 + 522), {v24(),v64});
	end
	v12.StaggerFull = function(v65)
		return v43;
	end;
	v12.StaggerLastTickDamage = function(v66, v67)
		local v68 = 0 - 0;
		if (((13433 - 8849) == (6420 - (1045 + 791))) and (v67 > #v44)) then
			v67 = #v44;
		end
		for v87 = 2 - 1, v67 do
			v68 = v68 + v44[v87];
		end
		return v68;
	end;
	v12.IncomingDamageTaken = function(v69, v70)
		local v71 = 0 - 0;
		local v72 = v70 / (1505 - (351 + 154));
		for v88 = 1575 - (1281 + 293), #v45 do
			if (((4245 - (28 + 238)) >= (3726 - 2058)) and (v45[v88][1560 - (1381 + 178)] > (v24() - v72))) then
				v71 = v71 + v45[v88][2 + 0];
			end
		end
		return v71;
	end;
	v9:RegisterForCombatEvent(function(...)
		local v73 = {...};
		if (((243 + 325) > (1475 - 1047)) and (#v73 == (12 + 11))) then
			local v89, v89, v89, v89, v89, v89, v89, v90, v89, v89, v89, v89, v89, v89, v89, v89, v89, v89, v91, v89, v89, v92 = ...;
			if (((1804 - (381 + 89)) <= (4091 + 522)) and (v90 == v12:GUID()) and (v91 == v40)) then
				v46(v92);
			end
		else
			local v93 = 0 + 0;
			local v94;
			local v95;
			local v96;
			local v97;
			while true do
				if ((v93 == (0 - 0)) or ((3021 - (1074 + 82)) >= (4446 - 2417))) then
					v94, v94, v94, v94, v94, v94, v94, v95, v94, v94, v94, v94, v94, v94, v94, v96, v94, v94, v97 = ...;
					if (((6734 - (214 + 1570)) >= (3071 - (990 + 465))) and (v95 == v12:GUID()) and (v96 == v40)) then
						v46(v97);
					end
					break;
				end
			end
		end
	end, "SPELL_ABSORBED");
	v9:RegisterForCombatEvent(function(...)
		local v74 = 0 + 0;
		local v75;
		local v76;
		local v77;
		local v78;
		while true do
			if (((751 + 974) == (1678 + 47)) and (v74 == (0 - 0))) then
				v75, v75, v75, v75, v75, v75, v75, v76, v75, v75, v75, v77, v75, v75, v78 = ...;
				if (((3185 - (1668 + 58)) <= (3108 - (512 + 114))) and (v76 == v12:GUID()) and (v77 == v41) and (v78 > (0 - 0))) then
					v47(v78);
				end
				break;
			end
		end
	end, "SPELL_PERIODIC_DAMAGE");
	v9:RegisterForCombatEvent(function(...)
		local v79 = 0 - 0;
		local v80;
		local v81;
		local v82;
		while true do
			if ((v79 == (0 - 0)) or ((1255 + 1441) >= (849 + 3683))) then
				v80, v80, v80, v80, v80, v80, v80, v81, v80, v80, v80, v80, v80, v80, v82 = ...;
				if (((912 + 136) >= (175 - 123)) and (v10.Persistent.Player.Spec[1995 - (109 + 1885)] == (1737 - (1269 + 200))) and (v81 == v12:GUID()) and (v82 ~= nil) and (v82 > (0 - 0))) then
					v48(v82);
				end
				break;
			end
		end
	end, "SWING_DAMAGE", "SPELL_DAMAGE", "SPELL_PERIODIC_DAMAGE");
	v9:RegisterForEvent(function()
		local v83 = 815 - (98 + 717);
		while true do
			if (((3784 - (802 + 24)) < (7765 - 3262)) and (v83 == (0 - 0))) then
				if ((#v44 > (0 + 0)) or ((2102 + 633) == (216 + 1093))) then
					for v98 = 0 + 0, #v44 do
						v44[v98] = nil;
					end
				end
				if ((#v45 > (0 - 0)) or ((13772 - 9642) <= (1057 + 1898))) then
					for v100 = 0 + 0, #v45 do
						v45[v100] = nil;
					end
				end
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
end;
return v0["Epix_Monk_Monk.lua"]();

