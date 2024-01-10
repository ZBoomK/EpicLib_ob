local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((627 - 355) == (792 - 520)) and not v5) then
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
	if (((246 - 146) <= (169 + 2954)) and not v15.Monk) then
		v15.Monk = {};
	end
	v15.Monk.Commons = {AncestralCall=v15(97076 + 177662, nil, 886 - (261 + 624)),ArcaneTorrent=v15(44509 - 19463, nil, 1082 - (1020 + 60)),BagofTricks=v15(313834 - (630 + 793), nil, 9 - 6),Berserking=v15(124509 - 98212, nil, 2 + 2),BloodFury=v15(70830 - 50258, nil, 1752 - (760 + 987)),GiftoftheNaaru=v15(61460 - (1789 + 124), nil, 772 - (745 + 21)),Fireblood=v15(91227 + 173994, nil, 19 - 12),LightsJudgment=v15(1002779 - 747132, nil, 1 + 7),QuakingPalm=v15(84071 + 23008, nil, 1064 - (87 + 968)),Shadowmeld=v15(259644 - 200660, nil, 10 + 0),CracklingJadeLightning=v15(266636 - 148684, nil, 1424 - (447 + 966)),ExpelHarm=v15(881800 - 559699, nil, 1829 - (1703 + 114)),LegSweep=v15(120082 - (376 + 325), nil, 21 - 8),Provoke=v15(355532 - 239986, nil, 5 + 9),Resuscitate=v15(253677 - 138499, nil, 29 - (9 + 5)),RisingSunKick=v15(107804 - (85 + 291), nil, 1281 - (243 + 1022)),Roll=v15(415266 - 306134, nil, 15 + 2),TigerPalm=v15(101960 - (1123 + 57), nil, 15 + 3),TouchofDeath=v15(322363 - (163 + 91), nil, 1949 - (1869 + 61)),Transcendence=v15(28397 + 73246, nil, 70 - 50),TranscendenceTransfer=v15(184307 - 64311, nil, 3 + 18),Vivify=v15(160333 - 43663, nil, 21 + 1),BonedustBrew=v15(387750 - (1329 + 145), nil, 994 - (140 + 831)),Celerity=v15(117023 - (1409 + 441), nil, 742 - (15 + 703)),ChiBurst=v15(57419 + 66567, nil, 463 - (262 + 176)),ChiTorpedo=v15(116729 - (345 + 1376), nil, 714 - (198 + 490)),ChiWave=v15(508498 - 393400, nil, 64 - 37),DampenHarm=v15(123484 - (696 + 510), nil, 58 - 30),Detox=v15(219426 - (1091 + 171), nil, 5 + 24),Disable=v15(365506 - 249411, nil, 99 - 69),DiffuseMagic=v15(123157 - (123 + 251), nil, 154 - 123),EyeoftheTiger=v15(197305 - (208 + 490), nil, 3 + 29),InnerStrengthBuff=v15(116604 + 145165, nil, 869 - (660 + 176)),Paralysis=v15(13826 + 101252, nil, 236 - (14 + 188)),RingOfPeace=v15(117519 - (534 + 141), nil, 15 + 20),RushingJadeWind=v15(103357 + 13490, nil, 35 + 1),SpearHandStrike=v15(245260 - 128555, nil, 58 - 21),SummonWhiteTigerStatue=v15(1090281 - 701595, nil, 21 + 17),TigerTailSweep=v15(168314 + 96034, nil, 435 - (115 + 281)),TigersLust=v15(271776 - 154935, nil, 34 + 6),BonedustBrewBuff=v15(933533 - 547257, nil, 150 - 109),DampenHarmBuff=v15(123145 - (550 + 317), nil, 60 - 18),RushingJadeWindBuff=v15(164236 - 47389, nil, 120 - 77),FortifyingBrewBuff=v15(115488 - (134 + 151), nil, 1771 - (970 + 695)),CalltoDominanceBuff=v15(769744 - 366364, nil, 2140 - (582 + 1408)),DomineeringArroganceBuff=v15(1427672 - 1016011, nil, 189 - 38),TheEmperorsCapacitorBuff=v15(885767 - 650713, nil, 1868 - (1195 + 629)),PoolEnergy=v15(1322379 - 322469, nil, 286 - (187 + 54)),ImpTouchofDeath=v15(322893 - (162 + 618), nil, 104 + 44),StrengthofSpirit=v15(257942 + 129334, nil, 317 - 168)};
	v15.Monk.Windwalker = v18(v15.Monk.Commons, {BlackoutKick=v15(169436 - 68652, nil, 4 + 43),FlyingSerpentKick=v15(103181 - (1373 + 263), nil, 1048 - (451 + 549)),FlyingSerpentKickLand=v15(36319 + 78738, nil, 75 - 26),SpinningCraneKick=v15(170664 - 69118, nil, 1434 - (746 + 638)),BonedustBrew=v15(145371 + 240905, nil, 77 - 26),CraneVortex=v15(389189 - (218 + 123), nil, 1633 - (1535 + 46)),DanceofChiji=v15(323120 + 2081, nil, 22 + 130),FastFeet=v15(389369 - (306 + 254), nil, 4 + 49),FaelineHarmony=v15(768162 - 376750, nil, 1521 - (899 + 568)),FaelineStomp=v15(255160 + 133033, nil, 133 - 78),FistsofFury=v15(114259 - (268 + 335), nil, 346 - (60 + 230)),HitCombo=v15(197312 - (426 + 146), nil, 7 + 50),InvokeXuenTheWhiteTiger=v15(125360 - (282 + 1174), nil, 869 - (569 + 242)),MarkoftheCrane=v15(634759 - 414402, nil, 4 + 55),Serenity=v15(153197 - (706 + 318), nil, 1311 - (721 + 530)),ShadowboxingTreads=v15(394253 - (945 + 326), nil, 152 - 91),StormEarthAndFire=v15(122474 + 15165, nil, 762 - (271 + 429)),StormEarthAndFireFixate=v15(203720 + 18051, nil, 1563 - (1408 + 92)),StrikeoftheWindlord=v15(394069 - (461 + 625), nil, 1352 - (993 + 295)),TeachingsoftheMonastery=v15(6057 + 110588, nil, 1236 - (418 + 753)),Thunderfist=v15(149670 + 243315, nil, 7 + 59),WhirlingDragonPunch=v15(44509 + 107666, nil, 17 + 50),XuensBattlegear=v15(393522 - (406 + 123), nil, 1837 - (1749 + 20)),Skyreach=v15(93346 + 299645, nil, 1459 - (1249 + 73)),Skytouch=v15(144507 + 260537, nil, 1283 - (466 + 679)),InvokersDelightBuff=v15(934916 - 546253, nil, 397 - 258),DrinkingHornCover=v15(393270 - (106 + 1794), nil, 45 + 95),JadeIgnition=v15(99337 + 293642, nil, 416 - 275),HiddenMastersForbiddenTouchBuff=v15(577099 - 363985, nil, 256 - (4 + 110)),PressurePointBuff=v15(338066 - (57 + 527), nil, 1570 - (41 + 1386)),FaeExposureDebuff=v15(395517 - (17 + 86), nil, 98 + 46),SkyreachCritDebuff=v15(876539 - 483492, nil, 419 - 274),FortifyingBrew=v15(243601 - (122 + 44), nil, 118 - 49),TouchofKarma=v15(406290 - 283820, nil, 57 + 13),BlackoutKickBuff=v15(16888 + 99880, nil, 143 - 72),ChiEnergyBuff=v15(393122 - (30 + 35), nil, 50 + 22),DanceofChijiBuff=v15(326459 - (1043 + 214), nil, 275 - 202),HitComboBuff=v15(197953 - (323 + 889), nil, 199 - 125),PowerStrikesBuff=v15(130494 - (361 + 219), nil, 395 - (53 + 267)),SerenityBuff=v15(34379 + 117794, nil, 489 - (15 + 398)),StormEarthAndFireBuff=v15(138621 - (18 + 964), nil, 289 - 212),TeachingsoftheMonasteryBuff=v15(117003 + 85087, nil, 50 + 28),WhirlingDragonPunchBuff=v15(197592 - (20 + 830), nil, 62 + 17),MarkoftheCraneDebuff=v15(228413 - (116 + 10), nil, 6 + 74),SkyreachExhaustionDebuff=v15(393788 - (542 + 196), nil, 173 - 92),KicksofFlowingMomentumBuff=v15(115330 + 279614, nil, 42 + 40),FistsofFlowingMomentumBuff=v15(142169 + 252780, nil, 218 - 135),BlackoutReinforcementBuff=v15(1088210 - 663756, nil, 1704 - (1126 + 425))});
	v15.Monk.Brewmaster = v18(v15.Monk.Commons, {BlackoutKick=v15(205928 - (118 + 287), nil, 328 - 244),BreathOfFire=v15(116302 - (118 + 1003), nil, 248 - 163),Clash=v15(324689 - (142 + 235), nil, 390 - 304),InvokeNiuzaoTheBlackOx=v15(28848 + 103730, nil, 1064 - (553 + 424)),KegSmash=v15(229283 - 108030, nil, 78 + 10),SpinningCraneKick=v15(320141 + 2588, nil, 52 + 37),BreathOfFireDotDebuff=v15(52595 + 71130, nil, 52 + 38),BlackoutCombo=v15(426502 - 229766, nil, 253 - 162),BlackoutComboBuff=v15(511762 - 283199, nil, 27 + 65),BlackOxBrew=v15(557684 - 442285, nil, 846 - (239 + 514)),BobAndWeave=v15(98520 + 181995, nil, 1423 - (797 + 532)),CelestialFlames=v15(236279 + 88898, nil, 33 + 62),ExplodingKeg=v15(764516 - 439363, nil, 1298 - (373 + 829)),HighTolerance=v15(197468 - (476 + 255), nil, 1227 - (369 + 761)),LightBrewing=v15(188058 + 137035, nil, 177 - 79),SpecialDelivery=v15(372804 - 176074, nil, 337 - (64 + 174)),Spitfire=v15(34550 + 208030, nil, 148 - 48),SummonBlackOxStatue=v15(115651 - (144 + 192), nil, 317 - (42 + 174)),WeaponsOfOrder=v15(290866 + 96318, nil, 85 + 17),CelestialBrew=v15(137015 + 185492, nil, 1607 - (363 + 1141)),ElusiveBrawlerBuff=v15(197210 - (1183 + 397), nil, 316 - 212),FortifyingBrew=v15(84450 + 30753, nil, 79 + 26),PurifyingBrew=v15(121557 - (1913 + 62), nil, 68 + 39),PurifiedChiBuff=v15(860617 - 535525, nil, 2041 - (565 + 1368)),Shuffle=v15(810359 - 594880, nil, 1770 - (1477 + 184)),HealingElixir=v15(166617 - 44336, nil, 103 + 7),CharredPassions=v15(338996 - (564 + 292), nil, 191 - 80),MightyPour=v15(1018770 - 680776, nil, 416 - (244 + 60)),HeavyStagger=v15(95555 + 28718, nil, 589 - (41 + 435)),ModerateStagger=v15(125275 - (938 + 63), nil, 88 + 26),LightStagger=v15(125400 - (936 + 189), nil, 38 + 77)});
	v15.Monk.Mistweaver = v18(v15.Monk.Commons, {BlackoutKick=v15(102397 - (1565 + 48), nil, 72 + 44),EnvelopingMist=v15(125820 - (782 + 356), nil, 384 - (176 + 91)),EssenceFont=v15(499798 - 307961, nil, 173 - 55),EssenceFontBuff=v15(192932 - (975 + 117), nil, 1994 - (157 + 1718)),InvokeYulonTheJadeSerpent=v15(100555 + 23349, nil, 425 - 305),LifeCocoon=v15(399484 - 282635, nil, 1139 - (697 + 321)),RenewingMist=v15(313685 - 198534, nil, 258 - 136),Revival=v15(265833 - 150523, nil, 48 + 75),SoothingMist=v15(215798 - 100623, nil, 332 - 208),SpinningCraneKick=v15(102773 - (322 + 905), nil, 736 - (602 + 9)),TeachingsOfTheMonasteryBuff=v15(389212 - (449 + 740), nil, 998 - (826 + 46)),ThunderFocusTea=v15(117627 - (245 + 702), nil, 401 - 274),InvokeChiJiTheRedCrane=v15(104541 + 220656, nil, 2026 - (260 + 1638)),LifecyclesEnvelopingMistBuff=v15(198359 - (382 + 58), nil, 413 - 284),LifecyclesVivifyBuff=v15(164460 + 33456, nil, 268 - 138),ManaTea=v15(342723 - 227429, nil, 1336 - (902 + 303)),RefreshingJadeWind=v15(431937 - 235212, nil, 317 - 185),SongOfChiJi=v15(17092 + 181806, nil, 1823 - (1121 + 569)),SummonJadeSerpentStatue=v15(115527 - (22 + 192), nil, 817 - (483 + 200)),Upwelling=v15(276426 - (1404 + 59), nil, 374 - 237),CloudedFocus=v15(521545 - 133498, nil, 903 - (468 + 297)),ChiBurst=v15(124548 - (334 + 228), nil, 468 - 329),SheilunsGift=v15(925984 - 526493, nil, 253 - 113),Restoral=v15(110353 + 278262, nil, 381 - (141 + 95)),FortifyingBrew=v15(239129 + 4306, nil, 347 - 212),Reawaken=v15(509752 - 297701, nil, 32 + 104),ChiHarmonyBuff=v15(1160171 - 736732, nil, 100 + 41),ZenPulse=v15(64613 + 59468, nil, 199 - 57),FaelineStomp=v15(228979 + 159214, nil, 306 - (92 + 71)),AncientConcordance=v15(192016 + 196724, nil, 241 - 97)});
	if (not v17.Monk or ((2134 - (574 + 191)) > (4114 + 873))) then
		v17.Monk = {};
	end
	v17.Monk.Commons = {AlgetharPuzzleBox=v17(485280 - 291579, {(862 - (254 + 595)),(18 - 4)}),BeacontotheBeyond=v17(205753 - (573 + 1217), {(1 + 12),(953 - (714 + 225))}),DragonfireBombDispenser=v17(592108 - 389498, {(2 + 12),(820 - (118 + 688))}),EruptingSpearFragment=v17(193817 - (25 + 23), {(1899 - (927 + 959)),(746 - (16 + 716))}),IrideusFragment=v17(374002 - 180259, {(31 - 18),(35 - 21)}),ManicGrieftorch=v17(958375 - 764067, {(36 - 23),(1075 - (810 + 251))}),AshesoftheEmbersoul=v17(143770 + 63397, {(12 + 1),(747 - (711 + 22))}),MirrorofFracturedTomorrows=v17(802966 - 595385, {(4 + 9),(1 + 13)}),NeltharionsCalltoDominance=v17(205946 - (1344 + 400), {(11 + 2),(59 - 45)}),WitherbarksBranch=v17(355287 - 245288, {(419 - (183 + 223)),(10 + 4)}),RefreshingHealingPotion=v17(68874 + 122506),Healthstone=v17(5849 - (10 + 327)),DreamwalkersHealingPotion=v17(144169 + 62854),Djaruun=v17(202907 - (118 + 220))};
	v17.Monk.Windwalker = v18(v17.Monk.Commons, {});
	v17.Monk.Brewmaster = v18(v17.Monk.Commons, {});
	v17.Monk.Mistweaver = v18(v17.Monk.Commons, {});
	if (not v20.Monk or ((288 + 575) >= (5033 - (108 + 341)))) then
		v20.Monk = {};
	end
	v20.Monk.Commons = {Healthstone=v20(10 + 11),Djaruun=v20(92 - 70),RefreshingHealingPotion=v20(1516 - (711 + 782)),AlgetharPuzzleBox=v20(45 - 21),BonedustBrewPlayer=v20(494 - (270 + 199)),BonedustBrewCursor=v20(9 + 17),DetoxMouseover=v20(1846 - (580 + 1239)),RingOfPeaceCursor=v20(26 - 17),SpearHandStrikeMouseover=v20(10 + 0),SummonWhiteTigerStatuePlayer=v20(1 + 10),SummonWhiteTigerStatueCursor=v20(6 + 6),TigerPalmMouseover=v20(33 - 20),DetoxFocus=v20(9 + 5),ParalysisMouseover=v20(1182 - (645 + 522))};
	v20.Monk.Windwalker = v18(v20.Monk.Commons, {SummonWhiteTigerStatueM=v20(1806 - (1010 + 780)),BonedustBrewM=v20(17 + 0),TrinketTop=v20(133 - 105),TrinketBottom=v20(84 - 55),StopFoF=v15(1866 - (1045 + 791))});
	v20.Monk.Brewmaster = v18(v20.Monk.Commons, {ExplodingKegPlayer=v20(45 - 27),ExplodingKegCursor=v20(28 - 9)});
	v20.Monk.Mistweaver = v18(v20.Monk.Commons, {RenewingMistFocus=v20(547 - (351 + 154)),SummonJadeSerpentStatuePlayer=v20(1617 - (1281 + 293)),SummonJadeSerpentStatueCursor=v20(310 - (28 + 238)),SoothingMistFocus=v20(100 - 55),VivifyFocus=v20(1605 - (1381 + 178)),SheilunsGiftFocus=v20(45 + 2),EnvelopingMistFocus=v20(39 + 9),ZenPulseFocus=v20(21 + 28)});
	local v37 = v15.Monk.Brewmaster;
	local v38 = v15.Monk.Windwalker;
	local v39;
	v39 = v9.AddCoreOverride("Spell.IsCastable", function(v52, v53, v54, v55, v56, v57)
		local v58 = 0 - 0;
		local v59;
		while true do
			if ((v58 == (0 + 0)) or ((1194 - (381 + 89)) >= (1480 + 188))) then
				v59 = v39(v52, v53, v54, v55, v56, v57);
				if (((290 + 138) < (3089 - 1285)) and (v52 == v37.TouchOfDeath)) then
					return v59 and v52:IsUsable();
				else
					return v59;
				end
				break;
			end
		end
	end, 1424 - (1074 + 82));
	local v40 = 252170 - 137101;
	local v41 = 126039 - (214 + 1570);
	local v42 = v15(281970 - (990 + 465), nil, 57 + 80);
	local v43 = 0 + 0;
	local v44 = {};
	local v45 = {};
	local function v46(v60)
		local v61 = 0 + 0;
		local v62;
		while true do
			if (((0 - 0) == v61) or ((5051 - (1668 + 58)) > (5239 - (512 + 114)))) then
				v62 = (26 - 16) + ((v42:IsAvailable() and (5 - 2)) or (0 - 0));
				v43 = v43 + v60;
				v61 = 1 + 0;
			end
			if ((v61 == (1 + 0)) or ((4304 + 646) <= (15357 - 10804))) then
				v21.After(v62, function()
					v43 = v43 - v60;
				end);
				break;
			end
		end
	end
	local function v47(v63)
		local v64 = 1994 - (109 + 1885);
		while true do
			if (((4134 - (1269 + 200)) <= (7538 - 3605)) and (v64 == (815 - (98 + 717)))) then
				if (((4099 - (802 + 24)) == (5644 - 2371)) and (#v44 == (12 - 2))) then
					v22(v44, 2 + 8);
				end
				v23(v44, 1 + 0, v63);
				break;
			end
		end
	end
	local function v48(v65)
		local v66 = 0 + 0;
		while true do
			if (((825 + 2999) > (1137 - 728)) and ((0 - 0) == v66)) then
				while (#v45 > (0 + 0)) and (v45[#v45][1 + 0] < (v24() - (5 + 1))) do
					v22(v45, #v45);
				end
				v23(v45, 1 + 0, {v24(),v65});
				break;
			end
		end
	end
	v12.StaggerFull = function(v67)
		return v43;
	end;
	v12.StaggerLastTickDamage = function(v68, v69)
		local v70 = 0 - 0;
		local v71;
		while true do
			if (((3706 - (1427 + 192)) == (724 + 1363)) and (v70 == (2 - 1))) then
				for v97 = 1 + 0, v69 do
					v71 = v71 + v44[v97];
				end
				return v71;
			end
			if ((v70 == (0 + 0)) or ((3730 - (192 + 134)) > (5779 - (316 + 960)))) then
				v71 = 0 + 0;
				if ((v69 > #v44) or ((2706 + 800) <= (1210 + 99))) then
					v69 = #v44;
				end
				v70 = 3 - 2;
			end
		end
	end;
	v12.IncomingDamageTaken = function(v72, v73)
		local v74 = 551 - (83 + 468);
		local v75;
		local v76;
		while true do
			if (((4761 - (1202 + 604)) == (13794 - 10839)) and (v74 == (1 - 0))) then
				for v98 = 2 - 1, #v45 do
					if ((v45[v98][326 - (45 + 280)] > (v24() - v76)) or ((2802 + 101) == (1307 + 188))) then
						v75 = v75 + v45[v98][1 + 1];
					end
				end
				return v75;
			end
			if (((2516 + 2030) >= (401 + 1874)) and (v74 == (0 - 0))) then
				v75 = 1911 - (340 + 1571);
				v76 = v73 / (395 + 605);
				v74 = 1773 - (1733 + 39);
			end
		end
	end;
	v9:RegisterForCombatEvent(function(...)
		local v77 = {...};
		if (((1853 - (125 + 909)) >= (1970 - (1096 + 852))) and (#v77 == (11 + 12))) then
			local v89, v89, v89, v89, v89, v89, v89, v90, v89, v89, v89, v89, v89, v89, v89, v89, v89, v89, v91, v89, v89, v92 = ...;
			if (((4515 - 1353) == (3067 + 95)) and (v90 == v12:GUID()) and (v91 == v40)) then
				v46(v92);
			end
		else
			local v93, v93, v93, v93, v93, v93, v93, v94, v93, v93, v93, v93, v93, v93, v93, v95, v93, v93, v96 = ...;
			if (((v94 == v12:GUID()) and (v95 == v40)) or ((2881 - (409 + 103)) > (4665 - (46 + 190)))) then
				v46(v96);
			end
		end
	end, "SPELL_ABSORBED");
	v9:RegisterForCombatEvent(function(...)
		local v78, v78, v78, v78, v78, v78, v78, v79, v78, v78, v78, v80, v78, v78, v81 = ...;
		if (((4190 - (51 + 44)) >= (898 + 2285)) and (v79 == v12:GUID()) and (v80 == v41) and (v81 > (1317 - (1114 + 203)))) then
			v47(v81);
		end
	end, "SPELL_PERIODIC_DAMAGE");
	v9:RegisterForCombatEvent(function(...)
		local v82, v82, v82, v82, v82, v82, v82, v83, v82, v82, v82, v82, v82, v82, v84 = ...;
		if (((v10.Persistent.Player.Spec[727 - (228 + 498)] == (59 + 209)) and (v83 == v12:GUID()) and (v84 ~= nil) and (v84 > (0 + 0))) or ((4374 - (174 + 489)) < (2626 - 1618))) then
			v48(v84);
		end
	end, "SWING_DAMAGE", "SPELL_DAMAGE", "SPELL_PERIODIC_DAMAGE");
	v9:RegisterForEvent(function()
		local v85 = 1905 - (830 + 1075);
		while true do
			if ((v85 == (524 - (303 + 221))) or ((2318 - (231 + 1038)) <= (755 + 151))) then
				if (((5675 - (171 + 991)) > (11234 - 8508)) and (#v44 > (0 - 0))) then
					for v99 = 0 - 0, #v44 do
						v44[v99] = nil;
					end
				end
				if ((#v45 > (0 + 0)) or ((5191 - 3710) >= (7667 - 5009))) then
					for v101 = 0 - 0, #v45 do
						v45[v101] = nil;
					end
				end
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
end;
return v0["Epix_Monk_Monk.lua"]();

