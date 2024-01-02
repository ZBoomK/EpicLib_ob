local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1827 - 1388) == (258 + 181)) and (v5 == (0 - 0))) then
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
	v16.Monk.Commons = {AncestralCall=v16(276161 - (630 + 793), nil, 3 - 2),ArcaneTorrent=v16(118586 - 93540, nil, 1 + 1),BagofTricks=v16(1075644 - 763233, nil, 1750 - (760 + 987)),Berserking=v16(28210 - (1789 + 124), nil, 770 - (745 + 21)),BloodFury=v16(7077 + 13495, nil, 13 - 8),GiftoftheNaaru=v16(233573 - 174026, nil, 1 + 5),Fireblood=v16(208231 + 56990, nil, 1062 - (87 + 968)),LightsJudgment=v16(1125343 - 869696, nil, 8 + 0),QuakingPalm=v16(242056 - 134977, nil, 1422 - (447 + 966)),Shadowmeld=v16(161477 - 102493, nil, 1827 - (1703 + 114)),CracklingJadeLightning=v16(118653 - (376 + 325), nil, 17 - 6),ExpelHarm=v16(991097 - 668996, nil, 4 + 8),LegSweep=v16(262934 - 143553, nil, 27 - (9 + 5)),Provoke=v16(115922 - (85 + 291), nil, 1279 - (243 + 1022)),Resuscitate=v16(438272 - 323094, nil, 13 + 2),RisingSunKick=v16(108608 - (1123 + 57), nil, 14 + 2),Roll=v16(109386 - (163 + 91), nil, 1947 - (1869 + 61)),TigerPalm=v16(28156 + 72624, nil, 63 - 45),TouchofDeath=v16(494743 - 172634, nil, 3 + 16),Transcendence=v16(139681 - 38038, nil, 19 + 1),TranscendenceTransfer=v16(121470 - (1329 + 145), nil, 992 - (140 + 831)),Vivify=v16(118520 - (1409 + 441), nil, 740 - (15 + 703)),BonedustBrew=v16(178887 + 207389, nil, 461 - (262 + 176)),Celerity=v16(116894 - (345 + 1376), nil, 712 - (198 + 490)),ChiBurst=v16(547765 - 423779, nil, 59 - 34),ChiTorpedo=v16(116214 - (696 + 510), nil, 54 - 28),ChiWave=v16(116360 - (1091 + 171), nil, 5 + 22),DampenHarm=v16(384972 - 262694, nil, 92 - 64),Detox=v16(218538 - (123 + 251), nil, 144 - 115),Disable=v16(116793 - (208 + 490), nil, 3 + 27),DiffuseMagic=v16(54694 + 68089, nil, 867 - (660 + 176)),EyeoftheTiger=v16(23622 + 172985, nil, 234 - (14 + 188)),InnerStrengthBuff=v16(262444 - (534 + 141), nil, 14 + 19),Paralysis=v16(101792 + 13286, nil, 33 + 1),RingOfPeace=v16(245552 - 128708, nil, 55 - 20),RushingJadeWind=v16(327760 - 210913, nil, 20 + 16),SpearHandStrike=v16(74308 + 42397, nil, 433 - (115 + 281)),SummonWhiteTigerStatue=v16(904097 - 515411, nil, 32 + 6),TigerTailSweep=v16(638864 - 374516, nil, 142 - 103),TigersLust=v16(117708 - (550 + 317), nil, 57 - 17),BonedustBrewBuff=v16(542939 - 156663, nil, 114 - 73),DampenHarmBuff=v16(122563 - (134 + 151), nil, 1707 - (970 + 695)),RushingJadeWindBuff=v16(222971 - 106124, nil, 2033 - (582 + 1408)),FortifyingBrewBuff=v16(399532 - 284329, nil, 133 - 27),CalltoDominanceBuff=v16(1520079 - 1116699, nil, 1974 - (1195 + 629)),DomineeringArroganceBuff=v16(544420 - 132759, nil, 392 - (187 + 54)),TheEmperorsCapacitorBuff=v16(235834 - (162 + 618), nil, 31 + 13),PoolEnergy=v16(665980 + 333930, nil, 95 - 50),ImpTouchofDeath=v16(541533 - 219420, nil, 12 + 136),StrengthofSpirit=v16(388912 - (1373 + 263), nil, 1149 - (451 + 549))};
	v16.Monk.Windwalker = v19(v16.Monk.Commons, {BlackoutKick=v16(31814 + 68970, nil, 72 - 25),FlyingSerpentKick=v16(170662 - 69117, nil, 1432 - (746 + 638)),FlyingSerpentKickLand=v16(43301 + 71756, nil, 73 - 24),SpinningCraneKick=v16(101887 - (218 + 123), nil, 1631 - (1535 + 46)),BonedustBrew=v16(383804 + 2472, nil, 8 + 43),CraneVortex=v16(389408 - (306 + 254), nil, 4 + 48),DanceofChiji=v16(638220 - 313019, nil, 1619 - (899 + 568)),FastFeet=v16(255564 + 133245, nil, 128 - 75),FaelineHarmony=v16(392015 - (268 + 335), nil, 344 - (60 + 230)),FaelineStomp=v16(388765 - (426 + 146), nil, 7 + 48),FistsofFury=v16(115112 - (282 + 1174), nil, 867 - (569 + 242)),HitCombo=v16(566728 - 369988, nil, 4 + 53),InvokeXuenTheWhiteTiger=v16(124928 - (706 + 318), nil, 1309 - (721 + 530)),MarkoftheCrane=v16(221628 - (945 + 326), nil, 146 - 87),Serenity=v16(135407 + 16766, nil, 760 - (271 + 429)),ShadowboxingTreads=v16(360995 + 31987, nil, 1561 - (1408 + 92)),StormEarthAndFire=v16(138725 - (461 + 625), nil, 1350 - (993 + 295)),StormEarthAndFireFixate=v16(11516 + 210255, nil, 1234 - (418 + 753)),StrikeoftheWindlord=v16(149669 + 243314, nil, 7 + 57),TeachingsoftheMonastery=v16(34117 + 82528, nil, 17 + 48),Thunderfist=v16(393514 - (406 + 123), nil, 1835 - (1749 + 20)),WhirlingDragonPunch=v16(36146 + 116029, nil, 1389 - (1249 + 73)),XuensBattlegear=v16(140208 + 252785, nil, 1213 - (466 + 679)),Skyreach=v16(945327 - 552336, nil, 391 - 254),Skytouch=v16(406944 - (106 + 1794), nil, 44 + 94),InvokersDelightBuff=v16(98246 + 290417, nil, 410 - 271),DrinkingHornCover=v16(1059806 - 668436, nil, 254 - (4 + 110)),JadeIgnition=v16(393563 - (57 + 527), nil, 1568 - (41 + 1386)),HiddenMastersForbiddenTouchBuff=v16(213217 - (17 + 86), nil, 97 + 45),PressurePointBuff=v16(752622 - 415140, nil, 414 - 271),FaeExposureDebuff=v16(395580 - (122 + 44), nil, 248 - 104),SkyreachCritDebuff=v16(1303921 - 910874, nil, 118 + 27),FortifyingBrew=v16(35207 + 208228, nil, 139 - 70),TouchofKarma=v16(122535 - (30 + 35), nil, 49 + 21),BlackoutKickBuff=v16(118025 - (1043 + 214), nil, 268 - 197),ChiEnergyBuff=v16(394269 - (323 + 889), nil, 193 - 121),DanceofChijiBuff=v16(325782 - (361 + 219), nil, 393 - (53 + 267)),HitComboBuff=v16(44448 + 152293, nil, 487 - (15 + 398)),PowerStrikesBuff=v16(130896 - (18 + 964), nil, 282 - 207),SerenityBuff=v16(88103 + 64070, nil, 48 + 28),StormEarthAndFireBuff=v16(138489 - (20 + 830), nil, 61 + 16),TeachingsoftheMonasteryBuff=v16(202216 - (116 + 10), nil, 6 + 72),WhirlingDragonPunchBuff=v16(197480 - (542 + 196), nil, 168 - 89),MarkoftheCraneDebuff=v16(66664 + 161623, nil, 41 + 39),SkyreachExhaustionDebuff=v16(141485 + 251565, nil, 213 - 132),KicksofFlowingMomentumBuff=v16(1012553 - 617609, nil, 1633 - (1126 + 425)),FistsofFlowingMomentumBuff=v16(395354 - (118 + 287), nil, 325 - 242),BlackoutReinforcementBuff=v16(425575 - (118 + 1003), nil, 447 - 294)});
	v16.Monk.Brewmaster = v19(v16.Monk.Commons, {BlackoutKick=v16(205900 - (142 + 235), nil, 380 - 296),BreathOfFire=v16(25063 + 90118, nil, 1062 - (553 + 424)),Clash=v16(613259 - 288947, nil, 76 + 10),InvokeNiuzaoTheBlackOx=v16(131515 + 1063, nil, 51 + 36),KegSmash=v16(51544 + 69709, nil, 51 + 37),SpinningCraneKick=v16(699642 - 376913, nil, 247 - 158),BreathOfFireDotDebuff=v16(277025 - 153300, nil, 27 + 63),BlackoutCombo=v16(950758 - 754022, nil, 844 - (239 + 514)),BlackoutComboBuff=v16(80274 + 148289, nil, 1421 - (797 + 532)),BlackOxBrew=v16(83851 + 31548, nil, 32 + 61),BobAndWeave=v16(659561 - 379046, nil, 1296 - (373 + 829)),CelestialFlames=v16(325908 - (476 + 255), nil, 1225 - (369 + 761)),ExplodingKeg=v16(188092 + 137061, nil, 174 - 78),HighTolerance=v16(372817 - 176080, nil, 335 - (64 + 174)),LightBrewing=v16(46301 + 278792, nil, 144 - 46),SpecialDelivery=v16(197066 - (144 + 192), nil, 315 - (42 + 174)),Spitfire=v16(182235 + 60345, nil, 83 + 17),SummonBlackOxStatue=v16(48991 + 66324, nil, 1605 - (363 + 1141)),WeaponsOfOrder=v16(388764 - (1183 + 397), nil, 310 - 208),CelestialBrew=v16(236413 + 86094, nil, 77 + 26),ElusiveBrawlerBuff=v16(197605 - (1913 + 62), nil, 66 + 38),FortifyingBrew=v16(304977 - 189774, nil, 2038 - (565 + 1368)),PurifyingBrew=v16(449716 - 330134, nil, 1768 - (1477 + 184)),PurifiedChiBuff=v16(442964 - 117872, nil, 101 + 7),Shuffle=v16(216335 - (564 + 292), nil, 187 - 78),HealingElixir=v16(368575 - 246294, nil, 414 - (244 + 60)),CharredPassions=v16(260000 + 78140, nil, 587 - (41 + 435)),MightyPour=v16(338995 - (938 + 63), nil, 87 + 25),HeavyStagger=v16(125398 - (936 + 189), nil, 38 + 75),ModerateStagger=v16(125887 - (1565 + 48), nil, 71 + 43),LightStagger=v16(125413 - (782 + 356), nil, 382 - (176 + 91))});
	v16.Monk.Mistweaver = v19(v16.Monk.Commons, {BlackoutKick=v16(262575 - 161791, nil, 170 - 54),EnvelopingMist=v16(125774 - (975 + 117), nil, 1992 - (157 + 1718)),EssenceFont=v16(155687 + 36150, nil, 418 - 300),EssenceFontBuff=v16(655865 - 464025, nil, 1137 - (697 + 321)),InvokeYulonTheJadeSerpent=v16(337529 - 213625, nil, 254 - 134),LifeCocoon=v16(269381 - 152532, nil, 48 + 73),RenewingMist=v16(215753 - 100602, nil, 326 - 204),Revival=v16(116537 - (322 + 905), nil, 734 - (602 + 9)),SoothingMist=v16(116364 - (449 + 740), nil, 996 - (826 + 46)),SpinningCraneKick=v16(102493 - (245 + 702), nil, 394 - 269),TeachingsOfTheMonasteryBuff=v16(124738 + 263285, nil, 2024 - (260 + 1638)),ThunderFocusTea=v16(117120 - (382 + 58), nil, 407 - 280),InvokeChiJiTheRedCrane=v16(270225 + 54972, nil, 264 - 136),LifecyclesEnvelopingMistBuff=v16(588335 - 390416, nil, 1334 - (902 + 303)),LifecyclesVivifyBuff=v16(434552 - 236636, nil, 313 - 183),ManaTea=v16(9908 + 105386, nil, 1821 - (1121 + 569)),RefreshingJadeWind=v16(196939 - (22 + 192), nil, 815 - (483 + 200)),SongOfChiJi=v16(200361 - (1404 + 59), nil, 363 - 230),SummonJadeSerpentStatue=v16(154983 - 39670, nil, 899 - (468 + 297)),Upwelling=v16(275525 - (334 + 228), nil, 461 - 324),CloudedFocus=v16(899457 - 511410, nil, 250 - 112),ChiBurst=v16(35208 + 88778, nil, 375 - (141 + 95)),SheilunsGift=v16(392424 + 7067, nil, 360 - 220),FortifyingBrew=v16(585196 - 341761, nil, 32 + 103),Reawaken=v16(580994 - 368943, nil, 96 + 40),ChiHarmonyBuff=v16(220496 + 202943, nil, 198 - 57),ZenPulse=v16(73191 + 50890, nil, 305 - (92 + 71)),FaelineStomp=v16(191746 + 196447, nil, 240 - 97),AncientConcordance=v16(389505 - (574 + 191), nil, 119 + 25)});
	if (((11484 - 6900) == (2342 + 2242)) and not v18.Monk) then
		v18.Monk = {};
	end
	v18.Monk.Commons = {AlgetharPuzzleBox=v18(194550 - (254 + 595), {(16 - 3),(38 - 24)}),BeacontotheBeyond=v18(15519 + 188444, {(952 - (714 + 225)),(19 - 5)}),DragonfireBombDispenser=v18(21936 + 180674, {(820 - (118 + 688)),(3 + 11)}),EruptingSpearFragment=v18(195655 - (927 + 959), {(745 - (16 + 716)),(111 - (11 + 86))}),IrideusFragment=v18(472572 - 278829, {(32 - 19),(1810 - (503 + 1293))}),ManicGrieftorch=v18(542663 - 348355, {(1074 - (810 + 251)),(5 + 9)}),AshesoftheEmbersoul=v18(186752 + 20415, {(746 - (711 + 22)),(873 - (240 + 619))}),MirrorofFracturedTomorrows=v18(50092 + 157489, {(1 + 12),(419 - (255 + 150))}),NeltharionsCalltoDominance=v18(160845 + 43357, {(55 - 42),(1753 - (404 + 1335))}),WitherbarksBranch=v18(110405 - (183 + 223), {(9 + 4),(351 - (10 + 327))}),RefreshingHealingPotion=v18(133275 + 58105),Healthstone=v18(5850 - (118 + 220)),DreamwalkersHealingPotion=v18(68992 + 138031),Djaruun=v18(203018 - (108 + 341))};
	v18.Monk.Windwalker = v19(v18.Monk.Commons, {});
	v18.Monk.Brewmaster = v19(v18.Monk.Commons, {});
	v18.Monk.Mistweaver = v19(v18.Monk.Commons, {});
	if (((1788 + 2191) >= (7051 - 5383)) and not v21.Monk) then
		v21.Monk = {};
	end
	v21.Monk.Commons = {Healthstone=v21(1514 - (711 + 782)),Djaruun=v21(41 - 19),RefreshingHealingPotion=v21(492 - (270 + 199)),AlgetharPuzzleBox=v21(8 + 16),BonedustBrewPlayer=v21(1844 - (580 + 1239)),BonedustBrewCursor=v21(77 - 51),DetoxMouseover=v21(26 + 1),RingOfPeaceCursor=v21(1 + 8),SpearHandStrikeMouseover=v21(5 + 5),SummonWhiteTigerStatuePlayer=v21(28 - 17),SummonWhiteTigerStatueCursor=v21(8 + 4),TigerPalmMouseover=v21(1180 - (645 + 522)),DetoxFocus=v21(1804 - (1010 + 780)),ParalysisMouseover=v21(15 + 0)};
	v21.Monk.Windwalker = v19(v21.Monk.Commons, {SummonWhiteTigerStatueM=v21(76 - 60),BonedustBrewM=v21(49 - 32),TrinketTop=v21(1864 - (1045 + 791)),TrinketBottom=v21(72 - 43),StopFoF=v16(45 - 15)});
	v21.Monk.Brewmaster = v19(v21.Monk.Commons, {ExplodingKegPlayer=v21(523 - (351 + 154)),ExplodingKegCursor=v21(1593 - (1281 + 293))});
	v21.Monk.Mistweaver = v19(v21.Monk.Commons, {});
	local v38 = v16.Monk.Brewmaster;
	local v39 = v16.Monk.Windwalker;
	local v40;
	v40 = v10.AddCoreOverride("Spell.IsCastable", function(v53, v54, v55, v56, v57, v58)
		local v59 = 266 - (28 + 238);
		local v60;
		while true do
			if (((1268 - 700) > (1987 - (1381 + 178))) and (v59 == (0 + 0))) then
				v60 = v40(v53, v54, v55, v56, v57, v58);
				if (((1076 + 258) <= (1968 + 2645)) and (v53 == v38.TouchOfDeath)) then
					return v60 and v53:IsUsable();
				else
					return v60;
				end
				break;
			end
		end
	end, 923 - 655);
	local v41 = 59614 + 55455;
	local v42 = 124725 - (381 + 89);
	local v43 = v16(248758 + 31757, nil, 93 + 44);
	local v44 = 0 - 0;
	local v45 = {};
	local v46 = {};
	local function v47(v61)
		local v62 = (1166 - (1074 + 82)) + ((v43:IsAvailable() and (6 - 3)) or (1784 - (214 + 1570)));
		v44 = v44 + v61;
		v22.After(v62, function()
			v44 = v44 - v61;
		end);
	end
	local function v48(v63)
		local v64 = 1455 - (990 + 465);
		while true do
			if ((v64 == (0 + 0)) or ((812 + 1053) >= (1974 + 55))) then
				if (((19480 - 14530) >= (3342 - (1668 + 58))) and (#v45 == (636 - (512 + 114)))) then
					v23(v45, 26 - 16);
				end
				v24(v45, 1 - 0, v63);
				break;
			end
		end
	end
	local function v49(v65)
		while (#v46 > (0 - 0)) and (v46[#v46][1 + 0] < (v25() - (2 + 4))) do
			v23(v46, #v46);
		end
		v24(v46, 1 + 0, {v25(),v65});
	end
	v13.StaggerFull = function(v66)
		return v44;
	end;
	v13.StaggerLastTickDamage = function(v67, v68)
		local v69 = 1469 - (1269 + 200);
		local v70;
		while true do
			if (((3306 - 1581) == (2540 - (98 + 717))) and (v69 == (827 - (802 + 24)))) then
				for v92 = 1 - 0, v68 do
					v70 = v70 + v45[v92];
				end
				return v70;
			end
			if (((1841 - 382) <= (367 + 2115)) and (v69 == (0 + 0))) then
				v70 = 0 + 0;
				if ((v68 > #v45) or ((582 + 2114) >= (12607 - 8075))) then
					v68 = #v45;
				end
				v69 = 3 - 2;
			end
		end
	end;
	v13.IncomingDamageTaken = function(v71, v72)
		local v73 = 0 + 0;
		local v74 = v72 / (408 + 592);
		for v90 = 1 + 0, #v46 do
			if (((763 + 285) >= (25 + 27)) and (v46[v90][1434 - (797 + 636)] > (v25() - v74))) then
				v73 = v73 + v46[v90][9 - 7];
			end
		end
		return v73;
	end;
	v10:RegisterForCombatEvent(function(...)
		local v75 = 1619 - (1427 + 192);
		local v76;
		while true do
			if (((1025 + 1933) < (10454 - 5951)) and (v75 == (0 + 0))) then
				v76 = {...};
				if ((#v76 == (349 - (192 + 134))) or ((4011 - (316 + 960)) == (729 + 580))) then
					local v93 = 0 + 0;
					local v94;
					local v95;
					local v96;
					local v97;
					while true do
						if (((0 + 0) == v93) or ((15789 - 11659) <= (3506 - (83 + 468)))) then
							v94, v94, v94, v94, v94, v94, v94, v95, v94, v94, v94, v94, v94, v94, v94, v94, v94, v94, v96, v94, v94, v97 = ...;
							if (((v95 == v13:GUID()) and (v96 == v41)) or ((3770 - (1202 + 604)) <= (6255 - 4915))) then
								v47(v97);
							end
							break;
						end
					end
				else
					local v98 = 0 - 0;
					local v99;
					local v100;
					local v101;
					local v102;
					while true do
						if (((6918 - 4419) == (2824 - (45 + 280))) and ((0 + 0) == v98)) then
							v99, v99, v99, v99, v99, v99, v99, v100, v99, v99, v99, v99, v99, v99, v99, v101, v99, v99, v102 = ...;
							if (((v100 == v13:GUID()) and (v101 == v41)) or ((1971 + 284) < (9 + 13))) then
								v47(v102);
							end
							break;
						end
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
			if ((v77 == (0 + 0)) or ((2010 - 924) >= (3316 - (340 + 1571)))) then
				v78, v78, v78, v78, v78, v78, v78, v79, v78, v78, v78, v80, v78, v78, v81 = ...;
				if (((v79 == v13:GUID()) and (v80 == v42) and (v81 > (0 + 0))) or ((4141 - (1733 + 39)) == (1170 - 744))) then
					v48(v81);
				end
				break;
			end
		end
	end, "SPELL_PERIODIC_DAMAGE");
	v10:RegisterForCombatEvent(function(...)
		local v82 = 1034 - (125 + 909);
		local v83;
		local v84;
		local v85;
		while true do
			if (((1948 - (1096 + 852)) == v82) or ((1380 + 1696) > (4544 - 1361))) then
				v83, v83, v83, v83, v83, v83, v83, v84, v83, v83, v83, v83, v83, v83, v85 = ...;
				if (((1166 + 36) > (1570 - (409 + 103))) and (v11.Persistent.Player.Spec[237 - (46 + 190)] == (363 - (51 + 44))) and (v84 == v13:GUID()) and (v85 ~= nil) and (v85 > (0 + 0))) then
					v49(v85);
				end
				break;
			end
		end
	end, "SWING_DAMAGE", "SPELL_DAMAGE", "SPELL_PERIODIC_DAMAGE");
	v10:RegisterForEvent(function()
		local v86 = 1317 - (1114 + 203);
		while true do
			if (((4437 - (228 + 498)) > (727 + 2628)) and (v86 == (0 + 0))) then
				if ((#v45 > (663 - (174 + 489))) or ((2360 - 1454) >= (4134 - (830 + 1075)))) then
					for v103 = 524 - (303 + 221), #v45 do
						v45[v103] = nil;
					end
				end
				if (((2557 - (231 + 1038)) > (1043 + 208)) and (#v46 > (1162 - (171 + 991)))) then
					for v105 = 0 - 0, #v46 do
						v46[v105] = nil;
					end
				end
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
end;
return v0["Epix_Monk_Monk.lua"]();

