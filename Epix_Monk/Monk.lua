local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1612 - (10 + 8)) > (330 - 244)) and (v5 == (443 - (416 + 26)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((1320 + 1754) == (897 - 390))) then
			v6 = v0[v4];
			if (not v6 or ((808 - (145 + 293)) > (3587 - (44 + 386)))) then
				return v1(v4, ...);
			end
			v5 = 1487 - (998 + 488);
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
	if (((96 + 206) <= (412 + 90)) and not v16.Monk) then
		v16.Monk = {};
	end
	v16.Monk.Commons = {AncestralCall=v16(275510 - (201 + 571), nil, 1139 - (116 + 1022)),ArcaneTorrent=v16(104273 - 79227, nil, 2 + 0),BagofTricks=v16(1140515 - 828104, nil, 10 - 7),Berserking=v16(27156 - (814 + 45), nil, 9 - 5),BloodFury=v16(1109 + 19463, nil, 2 + 3),GiftoftheNaaru=v16(60432 - (261 + 624), nil, 10 - 4),Fireblood=v16(266301 - (1020 + 60), nil, 1430 - (630 + 793)),LightsJudgment=v16(866302 - 610655, nil, 37 - 29),QuakingPalm=v16(42172 + 64907, nil, 30 - 21),Shadowmeld=v16(60731 - (760 + 987), nil, 1923 - (1789 + 124)),CracklingJadeLightning=v16(118718 - (745 + 21), nil, 4 + 7),ExpelHarm=v16(886307 - 564206, nil, 46 - 34),LegSweep=v16(977 + 118404, nil, 11 + 2),Provoke=v16(116601 - (87 + 968), nil, 61 - 47),Resuscitate=v16(104497 + 10681, nil, 33 - 18),RisingSunKick=v16(108841 - (447 + 966), nil, 43 - 27),Roll=v16(110949 - (1703 + 114), nil, 718 - (376 + 325)),TigerPalm=v16(165157 - 64377, nil, 55 - 37),TouchofDeath=v16(92052 + 230057, nil, 41 - 22),Transcendence=v16(101657 - (9 + 5), nil, 396 - (85 + 291)),TranscendenceTransfer=v16(121261 - (243 + 1022), nil, 79 - 58),Vivify=v16(96249 + 20421, nil, 1202 - (1123 + 57)),BonedustBrew=v16(314291 + 71985, nil, 277 - (163 + 91)),Celerity=v16(117103 - (1869 + 61), nil, 7 + 17),ChiBurst=v16(436680 - 312694, nil, 38 - 13),ChiTorpedo=v16(15738 + 99270, nil, 34 - 8),ChiWave=v16(108109 + 6989, nil, 1501 - (1329 + 145)),DampenHarm=v16(123249 - (140 + 831), nil, 1878 - (1409 + 441)),Detox=v16(218882 - (15 + 703), nil, 14 + 15),Disable=v16(116533 - (262 + 176), nil, 1751 - (345 + 1376)),DiffuseMagic=v16(123471 - (198 + 490), nil, 136 - 105),EyeoftheTiger=v16(471599 - 274992, nil, 1238 - (696 + 510)),InnerStrengthBuff=v16(549004 - 287235, nil, 1295 - (1091 + 171)),Paralysis=v16(18519 + 96559, nil, 106 - 72),RingOfPeace=v16(387493 - 270649, nil, 409 - (123 + 251)),RushingJadeWind=v16(580607 - 463760, nil, 734 - (208 + 490)),SpearHandStrike=v16(9849 + 106856, nil, 17 + 20),SummonWhiteTigerStatue=v16(389522 - (660 + 176), nil, 5 + 33),TigerTailSweep=v16(264550 - (14 + 188), nil, 714 - (534 + 141)),TigersLust=v16(46973 + 69868, nil, 36 + 4),BonedustBrewBuff=v16(371383 + 14893, nil, 85 - 44),DampenHarmBuff=v16(194130 - 71852, nil, 117 - 75),RushingJadeWindBuff=v16(62744 + 54103, nil, 28 + 15),FortifyingBrewBuff=v16(115599 - (115 + 281), nil, 246 - 140),CalltoDominanceBuff=v16(333976 + 69404, nil, 362 - 212),DomineeringArroganceBuff=v16(1509478 - 1097817, nil, 1018 - (550 + 317)),TheEmperorsCapacitorBuff=v16(339601 - 104547, nil, 61 - 17),PoolEnergy=v16(2794228 - 1794318, nil, 330 - (134 + 151)),ImpTouchofDeath=v16(323778 - (970 + 695), nil, 282 - 134),StrengthofSpirit=v16(389266 - (582 + 1408), nil, 516 - 367)};
	v16.Monk.Windwalker = v19(v16.Monk.Commons, {BlackoutKick=v16(126807 - 26023, nil, 177 - 130),FlyingSerpentKick=v16(103369 - (1195 + 629), nil, 63 - 15),FlyingSerpentKickLand=v16(115298 - (187 + 54), nil, 829 - (162 + 618)),SpinningCraneKick=v16(71154 + 30392, nil, 34 + 16),BonedustBrew=v16(823811 - 437535, nil, 85 - 34),CraneVortex=v16(30404 + 358444, nil, 1688 - (1373 + 263)),DanceofChiji=v16(326201 - (451 + 549), nil, 48 + 104),FastFeet=v16(605083 - 216274, nil, 88 - 35),FaelineHarmony=v16(392796 - (746 + 638), nil, 21 + 33),FaelineStomp=v16(589386 - 201193, nil, 396 - (218 + 123)),FistsofFury=v16(115237 - (1535 + 46), nil, 56 + 0),HitCombo=v16(28469 + 168271, nil, 617 - (306 + 254)),InvokeXuenTheWhiteTiger=v16(7671 + 116233, nil, 113 - 55),MarkoftheCrane=v16(221824 - (899 + 568), nil, 39 + 20),Serenity=v16(368243 - 216070, nil, 663 - (268 + 335)),ShadowboxingTreads=v16(393272 - (60 + 230), nil, 633 - (426 + 146)),StormEarthAndFire=v16(16489 + 121150, nil, 1518 - (282 + 1174)),StormEarthAndFireFixate=v16(222582 - (569 + 242), nil, 181 - 118),StrikeoftheWindlord=v16(22474 + 370509, nil, 1088 - (706 + 318)),TeachingsoftheMonastery=v16(117896 - (721 + 530), nil, 1336 - (945 + 326)),Thunderfist=v16(981801 - 588816, nil, 59 + 7),WhirlingDragonPunch=v16(152875 - (271 + 429), nil, 62 + 5),XuensBattlegear=v16(394493 - (1408 + 92), nil, 1154 - (461 + 625)),Skyreach=v16(394279 - (993 + 295), nil, 8 + 129),Skytouch=v16(406215 - (418 + 753), nil, 53 + 85),InvokersDelightBuff=v16(40057 + 348606, nil, 41 + 98),DrinkingHornCover=v16(98910 + 292460, nil, 669 - (406 + 123)),JadeIgnition=v16(394748 - (1749 + 20), nil, 34 + 107),HiddenMastersForbiddenTouchBuff=v16(214436 - (1249 + 73), nil, 51 + 91),PressurePointBuff=v16(338627 - (466 + 679), nil, 343 - 200),FaeExposureDebuff=v16(1130957 - 735543, nil, 2044 - (106 + 1794)),SkyreachCritDebuff=v16(124342 + 268705, nil, 37 + 108),FortifyingBrew=v16(718717 - 475282, nil, 186 - 117),TouchofKarma=v16(122584 - (4 + 110), nil, 654 - (57 + 527)),BlackoutKickBuff=v16(118195 - (41 + 1386), nil, 174 - (17 + 86)),ChiEnergyBuff=v16(266770 + 126287, nil, 159 - 87),DanceofChijiBuff=v16(941766 - 616564, nil, 239 - (122 + 44)),HitComboBuff=v16(339836 - 143095, nil, 245 - 171),PowerStrikesBuff=v16(105683 + 24231, nil, 11 + 64),SerenityBuff=v16(308280 - 156107, nil, 141 - (30 + 35)),StormEarthAndFireBuff=v16(94601 + 43038, nil, 1334 - (1043 + 214)),TeachingsoftheMonasteryBuff=v16(764033 - 561943, nil, 1290 - (323 + 889)),WhirlingDragonPunchBuff=v16(529558 - 332816, nil, 659 - (361 + 219)),MarkoftheCraneDebuff=v16(228607 - (53 + 267), nil, 19 + 61),SkyreachExhaustionDebuff=v16(393463 - (15 + 398), nil, 1063 - (18 + 964)),KicksofFlowingMomentumBuff=v16(1486615 - 1091671, nil, 48 + 34),FistsofFlowingMomentumBuff=v16(248833 + 146116, nil, 933 - (20 + 830)),BlackoutReinforcementBuff=v16(331325 + 93129, nil, 279 - (116 + 10))});
	v16.Monk.Brewmaster = v19(v16.Monk.Commons, {BlackoutKick=v16(15182 + 190341, nil, 822 - (542 + 196)),BreathOfFire=v16(246914 - 131733, nil, 25 + 60),Clash=v16(164773 + 159539, nil, 31 + 55),InvokeNiuzaoTheBlackOx=v16(349354 - 216776, nil, 222 - 135),KegSmash=v16(122804 - (1126 + 425), nil, 493 - (118 + 287)),SpinningCraneKick=v16(1264869 - 942140, nil, 1210 - (118 + 1003)),BreathOfFireDotDebuff=v16(362072 - 238347, nil, 467 - (142 + 235)),BlackoutCombo=v16(892496 - 695760, nil, 20 + 71),BlackoutComboBuff=v16(229540 - (553 + 424), nil, 173 - 81),BlackOxBrew=v16(101657 + 13742, nil, 93 + 0),BobAndWeave=v16(163332 + 117183, nil, 40 + 54),CelestialFlames=v16(185699 + 139478, nil, 205 - 110),ExplodingKeg=v16(905978 - 580825, nil, 214 - 118),HighTolerance=v16(57210 + 139527, nil, 468 - 371),LightBrewing=v16(325846 - (239 + 514), nil, 35 + 63),SpecialDelivery=v16(198059 - (797 + 532), nil, 72 + 27),Spitfire=v16(81835 + 160745, nil, 235 - 135),SummonBlackOxStatue=v16(116517 - (373 + 829), nil, 832 - (476 + 255)),WeaponsOfOrder=v16(388314 - (369 + 761), nil, 60 + 42),CelestialBrew=v16(585797 - 263290, nil, 194 - 91),ElusiveBrawlerBuff=v16(195868 - (64 + 174), nil, 15 + 89),FortifyingBrew=v16(170608 - 55405, nil, 441 - (144 + 192)),PurifyingBrew=v16(119798 - (42 + 174), nil, 81 + 26),PurifiedChiBuff=v16(269298 + 55794, nil, 46 + 62),Shuffle=v16(216983 - (363 + 1141), nil, 1689 - (1183 + 397)),HealingElixir=v16(372265 - 249984, nil, 81 + 29),CharredPassions=v16(252746 + 85394, nil, 2086 - (1913 + 62)),MightyPour=v16(212862 + 125132, nil, 296 - 184),HeavyStagger=v16(126206 - (565 + 1368), nil, 424 - 311),ModerateStagger=v16(125935 - (1477 + 184), nil, 155 - 41),LightStagger=v16(115794 + 8481, nil, 971 - (564 + 292))});
	v16.Monk.Mistweaver = v19(v16.Monk.Commons, {BlackoutKick=v16(173895 - 73111, nil, 349 - 233),EnvelopingMist=v16(124986 - (244 + 60), nil, 90 + 27),EssenceFont=v16(192313 - (41 + 435), nil, 1119 - (938 + 63)),EssenceFontBuff=v16(147540 + 44300, nil, 1244 - (936 + 189)),InvokeYulonTheJadeSerpent=v16(40777 + 83127, nil, 1733 - (1565 + 48)),LifeCocoon=v16(72180 + 44669, nil, 1259 - (782 + 356)),RenewingMist=v16(115418 - (176 + 91), nil, 317 - 195),Revival=v16(169945 - 54635, nil, 1215 - (975 + 117)),SoothingMist=v16(117050 - (157 + 1718), nil, 101 + 23),SpinningCraneKick=v16(360480 - 258934, nil, 427 - 302),TeachingsOfTheMonasteryBuff=v16(203108 - (697 + 321), nil, 343 - 217),ThunderFocusTea=v16(247199 - 130519, nil, 292 - 165),InvokeChiJiTheRedCrane=v16(126581 + 198616, nil, 239 - 111),LifecyclesEnvelopingMistBuff=v16(530563 - 332644, nil, 1356 - (322 + 905)),LifecyclesVivifyBuff=v16(198527 - (602 + 9), nil, 1319 - (449 + 740)),ManaTea=v16(198780 - (826 + 46), nil, 1078 - (245 + 702)),RefreshingJadeWind=v16(621643 - 424918, nil, 43 + 89),SongOfChiJi=v16(200796 - (260 + 1638), nil, 573 - (382 + 58)),SummonJadeSerpentStatue=v16(369932 - 254619, nil, 112 + 22),FortifyingBrew=v16(503106 - 259671, nil, 401 - 266),Reawaken=v16(213256 - (902 + 303), nil, 298 - 162)});
	if (not v18.Monk or ((11601 - 6784) < (356 + 3779))) then
		v18.Monk = {};
	end
	v18.Monk.Commons = {AlgetharPuzzleBox=v18(195391 - (1121 + 569), {(696 - (483 + 200)),(38 - 24)}),BeacontotheBeyond=v18(274131 - 70168, {(575 - (334 + 228)),(32 - 18)}),DragonfireBombDispenser=v18(367462 - 164852, {(250 - (141 + 95)),(35 - 21)}),EruptingSpearFragment=v18(465803 - 272034, {(35 - 22),(8 + 6)}),IrideusFragment=v18(272837 - 79094, {(176 - (92 + 71)),(23 - 9)}),ManicGrieftorch=v18(195073 - (574 + 191), {(32 - 19),(863 - (254 + 595))}),AshesoftheEmbersoul=v18(207293 - (55 + 71), {(1803 - (573 + 1217)),(2 + 12)}),MirrorofFracturedTomorrows=v18(334495 - 126914, {(37 - 24),(2 + 12)}),NeltharionsCalltoDominance=v18(295673 - 91471, {(61 - (25 + 23)),(1900 - (927 + 959))}),WitherbarksBranch=v18(370795 - 260796, {(24 - 11),(33 - 19)}),RefreshingHealingPotion=v18(191665 - (175 + 110)),Healthstone=v18(13916 - 8404),DreamwalkersHealingPotion=v18(1021089 - 814066),Djaruun=v18(204365 - (503 + 1293))};
	v18.Monk.Windwalker = v19(v18.Monk.Commons, {});
	v18.Monk.Brewmaster = v19(v18.Monk.Commons, {});
	v18.Monk.Mistweaver = v19(v18.Monk.Commons, {});
	if (((759 - 487) == (197 + 75)) and not v21.Monk) then
		v21.Monk = {};
	end
	v21.Monk.Commons = {Healthstone=v21(1082 - (810 + 251)),Djaruun=v21(16 + 6),RefreshingHealingPotion=v21(8 + 15),AlgetharPuzzleBox=v21(22 + 2),BonedustBrewPlayer=v21(558 - (43 + 490)),BonedustBrewCursor=v21(759 - (711 + 22)),DetoxMouseover=v21(104 - 77),RingOfPeaceCursor=v21(868 - (240 + 619)),SpearHandStrikeMouseover=v21(3 + 7),SummonWhiteTigerStatuePlayer=v21(17 - 6),SummonWhiteTigerStatueCursor=v21(1 + 11),TigerPalmMouseover=v21(1757 - (1344 + 400)),DetoxFocus=v21(419 - (255 + 150)),ParalysisMouseover=v21(12 + 3)};
	v21.Monk.Windwalker = v19(v21.Monk.Commons, {SummonWhiteTigerStatueM=v21(9 + 7),BonedustBrewM=v21(72 - 55),TrinketTop=v21(90 - 62),TrinketBottom=v21(1768 - (404 + 1335)),StopFoF=v16(436 - (183 + 223))});
	v21.Monk.Brewmaster = v19(v21.Monk.Commons, {ExplodingKegPlayer=v21(21 - 3),ExplodingKegCursor=v21(13 + 6)});
	v21.Monk.Mistweaver = v19(v21.Monk.Commons, {});
	local v38 = v16.Monk.Brewmaster;
	local v39 = v16.Monk.Windwalker;
	local v40;
	v40 = v10.AddCoreOverride("Spell.IsCastable", function(v53, v54, v55, v56, v57, v58)
		local v59 = v40(v53, v54, v55, v56, v57, v58);
		if (((36 + 64) <= (3460 - (10 + 327))) and (v53 == v38.TouchOfDeath)) then
			return v59 and v53:IsUsable();
		else
			return v59;
		end
	end, 187 + 81);
	local v41 = 115407 - (118 + 220);
	local v42 = 41409 + 82846;
	local v43 = v16(280964 - (108 + 341), nil, 62 + 75);
	local v44 = 0 - 0;
	local v45 = {};
	local v46 = {};
	local function v47(v60)
		local v61 = (1503 - (711 + 782)) + ((v43:IsAvailable() and (5 - 2)) or (469 - (270 + 199)));
		v44 = v44 + v60;
		v22.After(v61, function()
			v44 = v44 - v60;
		end);
	end
	local function v48(v62)
		if ((#v45 == (4 + 6)) or ((3188 - (580 + 1239)) > (14824 - 9837))) then
			v23(v45, 10 + 0);
		end
		v24(v45, 1 + 0, v62);
	end
	local function v49(v63)
		local v64 = 0 + 0;
		while true do
			if ((v64 == (0 - 0)) or ((537 + 326) >= (5751 - (645 + 522)))) then
				while (#v46 > (1790 - (1010 + 780))) and (v46[#v46][1 + 0] < (v25() - (28 - 22))) do
					v23(v46, #v46);
				end
				v24(v46, 2 - 1, {v25(),v63});
				break;
			end
		end
	end
	v13.StaggerFull = function(v65)
		return v44;
	end;
	v13.StaggerLastTickDamage = function(v66, v67)
		local v68 = 0 - 0;
		if ((v67 > #v45) or ((1229 - (351 + 154)) >= (3242 - (1281 + 293)))) then
			v67 = #v45;
		end
		for v86 = 267 - (28 + 238), v67 do
			v68 = v68 + v45[v86];
		end
		return v68;
	end;
	v13.IncomingDamageTaken = function(v69, v70)
		local v71 = 0 - 0;
		local v72;
		local v73;
		while true do
			if (((1987 - (1381 + 178)) < (1693 + 111)) and (v71 == (1 + 0))) then
				for v92 = 1 + 0, #v46 do
					if ((v46[v92][3 - 2] > (v25() - v73)) or ((1723 + 1602) > (5083 - (381 + 89)))) then
						v72 = v72 + v46[v92][2 + 0];
					end
				end
				return v72;
			end
			if ((v71 == (0 + 0)) or ((8479 - 3529) <= (5709 - (1074 + 82)))) then
				v72 = 0 - 0;
				v73 = v70 / (2784 - (214 + 1570));
				v71 = 1456 - (990 + 465);
			end
		end
	end;
	v10:RegisterForCombatEvent(function(...)
		local v74 = 0 + 0;
		local v75;
		while true do
			if (((1160 + 1505) <= (3825 + 108)) and (v74 == (0 - 0))) then
				v75 = {...};
				if (((3899 - (512 + 114)) == (8533 - 5260)) and (#v75 == (47 - 24))) then
					local v93, v93, v93, v93, v93, v93, v93, v94, v93, v93, v93, v93, v93, v93, v93, v93, v93, v93, v95, v93, v93, v96 = ...;
					if (((13306 - 9482) > (191 + 218)) and (v94 == v13:GUID()) and (v95 == v41)) then
						v47(v96);
					end
				else
					local v97 = 0 + 0;
					local v98;
					local v99;
					local v100;
					local v101;
					while true do
						if (((1815 + 272) == (7039 - 4952)) and (v97 == (1994 - (109 + 1885)))) then
							v98, v98, v98, v98, v98, v98, v98, v99, v98, v98, v98, v98, v98, v98, v98, v100, v98, v98, v101 = ...;
							if (((v99 == v13:GUID()) and (v100 == v41)) or ((4873 - (1269 + 200)) > (8630 - 4127))) then
								v47(v101);
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
		local v76, v76, v76, v76, v76, v76, v76, v77, v76, v76, v76, v78, v76, v76, v79 = ...;
		if (((v77 == v13:GUID()) and (v78 == v42) and (v79 > (815 - (98 + 717)))) or ((4332 - (802 + 24)) <= (2256 - 947))) then
			v48(v79);
		end
	end, "SPELL_PERIODIC_DAMAGE");
	v10:RegisterForCombatEvent(function(...)
		local v80, v80, v80, v80, v80, v80, v80, v81, v80, v80, v80, v80, v80, v80, v82 = ...;
		if (((3732 - 777) == (437 + 2518)) and (v11.Persistent.Player.Spec[1 + 0] == (45 + 223)) and (v81 == v13:GUID()) and (v82 ~= nil) and (v82 > (0 + 0))) then
			v49(v82);
		end
	end, "SWING_DAMAGE", "SPELL_DAMAGE", "SPELL_PERIODIC_DAMAGE");
	v10:RegisterForEvent(function()
		if ((#v45 > (0 - 0)) or ((9680 - 6777) == (535 + 960))) then
			for v88 = 0 + 0, #v45 do
				v45[v88] = nil;
			end
		end
		if (((3750 + 796) >= (1655 + 620)) and (#v46 > (0 + 0))) then
			for v90 = 1433 - (797 + 636), #v46 do
				v46[v90] = nil;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
end;
return v0["Epix_Monk_Monk.lua"]();

