local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((435 + 829) < (6163 - 3923)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((32 + 3859) >= (1205 + 329)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1056 - (87 + 968);
		end
		if (((17352 - 13410) == (3577 + 365)) and (v5 == (2 - 1))) then
			return v6(...);
		end
	end
end
v0["Epix_DeathKnight_DeathKnight.lua"] = function(...)
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
	if (not v16.DeathKnight or ((4695 - (447 + 966)) > (12940 - 8213))) then
		v16.DeathKnight = {};
	end
	v16.DeathKnight.Commons = {CleavingStrikes=v16(318733 - (1703 + 114), nil, 710 - (376 + 325)),DeathStrike=v16(81936 - 31938, nil, 30 - 20),EmpowerRuneWeapon=v16(13594 + 33974, nil, 24 - 13),IceboundFortitude=v16(48806 - (9 + 5), nil, 388 - (85 + 291)),IcyTalons=v16(196143 - (243 + 1022), nil, 49 - 36),RaiseDead=v16(38431 + 8154, nil, 1194 - (1123 + 57)),RunicAttenuation=v16(168509 + 38595, nil, 269 - (163 + 91)),SacrificialPact=v16(329504 - (1869 + 61), nil, 5 + 11),SoulReaper=v16(1209086 - 865792, nil, 25 - 8),UnholyGround=v16(51214 + 323051, nil, 24 - 6),AbominationLimbBuff=v16(359994 + 23275, nil, 1493 - (1329 + 145)),DeathAndDecayBuff=v16(189261 - (140 + 831), nil, 1870 - (1409 + 441)),DeathsDueBuff=v16(324883 - (15 + 703), nil, 10 + 11),EmpowerRuneWeaponBuff=v16(48006 - (262 + 176), nil, 1743 - (345 + 1376)),IcyTalonsBuff=v16(195567 - (198 + 490), nil, 101 - 78),UnholyStrengthBuff=v16(128006 - 74641, nil, 1230 - (696 + 510)),DeathStrikeBuff=v16(213016 - 111448, nil, 1287 - (1091 + 171)),BloodPlagueDebuff=v16(8864 + 46214, nil, 81 - 55),FrostFeverDebuff=v16(182713 - 127618, nil, 401 - (123 + 251)),SoulReaperDebuff=v16(1705811 - 1362517, nil, 726 - (208 + 490)),VirulentPlagueDebuff=v16(16167 + 175420, nil, 13 + 16),MarkofFyralathDebuff=v16(415368 - (660 + 176)),AncestralCall=v16(33009 + 241729, nil, 203 - (14 + 188)),ArcanePulse=v16(261039 - (534 + 141), nil, 1 + 1),ArcaneTorrent=v16(44770 + 5843, nil, 3 + 0),BagofTricks=v16(656545 - 344134, nil, 5 - 1),Berserking=v16(73764 - 47467, nil, 3 + 2),BloodFury=v16(13099 + 7473, nil, 402 - (115 + 281)),Fireblood=v16(616913 - 351692, nil, 6 + 1),LightsJudgment=v16(617835 - 362188, nil, 29 - 21),DeathAndDecay=v16(44132 - (550 + 317), nil, 43 - 13),DeathCoil=v16(66822 - 19281, nil, 86 - 55),AbominationLimb=v16(383554 - (134 + 151), nil, 1697 - (970 + 695)),AntiMagicShell=v16(92943 - 44236, nil, 2023 - (582 + 1408)),AntiMagicZone=v16(177051 - 125999, nil, 42 - 8),Asphyxiate=v16(834924 - 613362, nil, 1859 - (1195 + 629)),Assimilation=v16(495119 - 120736, nil, 277 - (187 + 54)),ChainsofIce=v16(46304 - (162 + 618), nil, 26 + 11),MindFreeze=v16(31656 + 15872, nil, 80 - 42),Pool=v16(1681040 - 681130, nil, 4 + 35)};
	v16.DeathKnight.Blood = v19(v16.DeathKnight.Commons, {BloodBoil=v16(52478 - (1373 + 263), nil, 1040 - (451 + 549)),BloodTap=v16(69982 + 151717, nil, 63 - 22),Blooddrinker=v16(347780 - 140849, nil, 1426 - (746 + 638)),Bonestorm=v16(73328 + 121516, nil, 65 - 22),Coagulopathy=v16(391818 - (218 + 123), nil, 1625 - (1535 + 46)),Consumption=v16(272402 + 1754, nil, 7 + 38),DancingRuneWeapon=v16(49588 - (306 + 254), nil, 3 + 43),DeathsCaress=v16(383268 - 187976, nil, 1514 - (899 + 568)),GorefiendsGrasp=v16(71120 + 37079, nil, 116 - 68),HeartStrike=v16(207533 - (268 + 335), nil, 339 - (60 + 230)),Heartbreaker=v16(222108 - (426 + 146), nil, 6 + 44),InsatiableBlade=v16(379093 - (282 + 1174), nil, 862 - (569 + 242)),Marrowrend=v16(562240 - 367058, nil, 3 + 49),RapidDecomposition=v16(195686 - (706 + 318), nil, 1304 - (721 + 530)),RelishinBlood=v16(318881 - (945 + 326), nil, 134 - 80),RuneTap=v16(173230 + 21449, nil, 755 - (271 + 429)),SanguineGround=v16(359595 + 31863, nil, 1556 - (1408 + 92)),ShatteringBone=v16(378726 - (461 + 625), nil, 1345 - (993 + 295)),TighteningGrasp=v16(10748 + 196222, nil, 1229 - (418 + 753)),Tombstone=v16(83715 + 136094, nil, 7 + 52),VampiricBlood=v16(16155 + 39078, nil, 16 + 44),BoneShieldBuff=v16(195710 - (406 + 123), nil, 1830 - (1749 + 20)),CoagulopathyBuff=v16(92987 + 298494, nil, 1384 - (1249 + 73)),CrimsonScourgeBuff=v16(28949 + 52192, nil, 1208 - (466 + 679)),DancingRuneWeaponBuff=v16(195458 - 114202, nil, 182 - 118),HemostasisBuff=v16(275847 - (106 + 1794), nil, 21 + 44),IceboundFortitudeBuff=v16(12334 + 36458, nil, 194 - 128),RuneTapBuff=v16(527178 - 332499, nil, 181 - (4 + 110)),VampiricBloodBuff=v16(55817 - (57 + 527), nil, 1495 - (41 + 1386)),VampiricStrengthBuff=v16(408459 - (17 + 86), nil, 47 + 22)});
	v16.DeathKnight.Frost = v19(v16.DeathKnight.Commons, {FrostStrike=v16(109594 - 60451, nil, 202 - 132),HowlingBlast=v16(49350 - (122 + 44), nil, 122 - 51),Avalanche=v16(687187 - 480045, nil, 59 + 13),BitingCold=v16(54531 + 322525, nil, 147 - 74),BreathofSindragosa=v16(152344 - (30 + 35), nil, 51 + 23),ChillStreak=v16(306649 - (1043 + 214), nil, 283 - 208),ColdHeart=v16(282420 - (323 + 889), nil, 204 - 128),Everfrost=v16(377518 - (361 + 219), nil, 397 - (53 + 267)),FatalFixation=v16(91536 + 313630, nil, 491 - (15 + 398)),Frostscythe=v16(208212 - (18 + 964), nil, 297 - 218),FrostwyrmsFury=v16(161706 + 117596, nil, 51 + 29),GatheringStorm=v16(195762 - (20 + 830), nil, 64 + 17),GlacialAdvance=v16(195039 - (116 + 10), nil, 7 + 75),HornofWinter=v16(58068 - (542 + 196), nil, 177 - 94),Icebreaker=v16(114748 + 278202, nil, 43 + 41),Icecap=v16(74559 + 132567, nil, 223 - 138),ImprovedObliterate=v16(813228 - 496030, nil, 1637 - (1126 + 425)),MightoftheFrozenWastes=v16(81738 - (118 + 287), nil, 340 - 253),Obliterate=v16(50141 - (118 + 1003), nil, 257 - 169),Obliteration=v16(281615 - (142 + 235), nil, 403 - 314),PillarofFrost=v16(11156 + 40115, nil, 1067 - (553 + 424)),RageoftheFrozenChampion=v16(713034 - 335958, nil, 81 + 10),RemorselessWinter=v16(195193 + 1577, nil, 54 + 38),ShatteringBlade=v16(88018 + 119039, nil, 54 + 39),UnleashedFrenzy=v16(817090 - 440185, nil, 261 - 167),ColdHeartBuff=v16(629638 - 348429, nil, 28 + 67),GatheringStormBuff=v16(1023581 - 811776, nil, 849 - (239 + 514)),KillingMachineBuff=v16(17956 + 33168, nil, 1426 - (797 + 532)),PillarofFrostBuff=v16(37255 + 14016, nil, 34 + 64),RimeBuff=v16(138845 - 79793, nil, 1301 - (373 + 829)),UnleashedFrenzyBuff=v16(377638 - (476 + 255), nil),RazoriceDebuff=v16(52844 - (369 + 761), nil, 59 + 42)});
	v16.DeathKnight.Unholy = v19(v16.DeathKnight.Commons, {Apocalypse=v16(500776 - 225077, nil, 192 - 90),ArmyoftheDamned=v16(277075 - (64 + 174), nil, 15 + 88),ArmyoftheDead=v16(63162 - 20512, nil, 440 - (144 + 192)),BurstingSores=v16(207480 - (42 + 174), nil, 79 + 26),ClawingShadows=v16(171731 + 35580, nil, 46 + 60),CoilofDevastation=v16(391774 - (363 + 1141), nil, 1687 - (1183 + 397)),CommanderoftheDead=v16(1188082 - 797823, nil, 80 + 28),DarkTransformation=v16(47509 + 16051, nil, 2084 - (1913 + 62)),Defile=v16(95903 + 56377, nil, 291 - 181),EbonFever=v16(209202 - (565 + 1368), nil, 417 - 306),Epidemic=v16(208978 - (1477 + 184), nil, 152 - 40),EternalAgony=v16(363634 + 26634, nil, 969 - (564 + 292)),FesteringStrike=v16(148296 - 62348, nil, 343 - 229),Festermight=v16(377894 - (244 + 60), nil, 89 + 26),GhoulishFrenzy=v16(378063 - (41 + 435), nil, 1117 - (938 + 63)),ImprovedDeathCoil=v16(290389 + 87191, nil, 1242 - (936 + 189)),InfectedClaws=v16(68214 + 139058, nil, 1731 - (1565 + 48)),Morbidity=v16(233245 + 144347, nil, 1257 - (782 + 356)),Outbreak=v16(77842 - (176 + 91), nil, 312 - 192),Pestilence=v16(408590 - 131356, nil, 1213 - (975 + 117)),Plaguebringer=v16(392050 - (157 + 1718), nil, 100 + 22),RaiseDead=v16(165369 - 118785, nil, 420 - 297),RottenTouch=v16(391293 - (697 + 321), nil, 337 - 213),ScourgeStrike=v16(116714 - 61624, nil, 288 - 163),SummonGargoyle=v17(79 + 122, 92195 - 42989, 555842 - 348493),Superstrain=v16(391510 - (322 + 905), nil, 737 - (602 + 9)),UnholyAssault=v16(208478 - (449 + 740), nil, 999 - (826 + 46)),UnholyBlight=v16(116936 - (245 + 702), nil, 404 - 276),UnholyCommand=v16(101887 + 215054, nil, 2027 - (260 + 1638)),UnholyPact=v16(319670 - (382 + 58), nil, 417 - 287),VileContagion=v16(324305 + 65974, nil, 270 - 139),CommanderoftheDeadBuff=v16(1160089 - 769829, nil, 1337 - (902 + 303)),FestermightBuff=v16(829054 - 451463, nil, 320 - 187),PlaguebringerBuff=v16(33529 + 356649, nil, 1824 - (1121 + 569)),RunicCorruptionBuff=v16(51674 - (22 + 192), nil, 818 - (483 + 200)),SuddenDoomBuff=v16(82803 - (1404 + 59), nil, 372 - 236),UnholyAssaultBuff=v16(278601 - 71312, nil, 902 - (468 + 297)),DeathRotDebuff=v16(378102 - (334 + 228), nil, 465 - 327),FesteringWoundDebuff=v16(450393 - 256083, nil, 251 - 112),RottenTouchDebuff=v16(110825 + 279451, nil, 376 - (141 + 95)),UnholyBlightDebuff=v16(113942 + 2052, nil, 362 - 221)});
	if (not v18.DeathKnight or ((9564 - 5585) < (810 + 2647))) then
		v18.DeathKnight = {};
	end
	v18.DeathKnight.Commons = {AlgetharPuzzleBox=v18(530717 - 337016, {(7 + 6),(9 + 5)}),IrideusFragment=v18(193906 - (92 + 71), {(21 - 8),(12 + 2)}),VialofAnimatedBlood=v18(399909 - 240284, {(862 - (254 + 595)),(18 - 4)}),Fyralath=v18(208238 - (573 + 1217), {(1 + 12),(953 - (714 + 225))})};
	v18.DeathKnight.Blood = v19(v18.DeathKnight.Commons, {});
	v18.DeathKnight.Frost = v19(v18.DeathKnight.Commons, {});
	v18.DeathKnight.Unholy = v19(v18.DeathKnight.Commons, {});
	if (((1250 - 822) < (2514 - 710)) and not v21.DeathKnight) then
		v21.DeathKnight = {};
	end
	v21.DeathKnight.Commons = {Healthstone=v21(3 + 18),DaDCursor=v21(12 - 3),DaDPlayer=v21(816 - (118 + 688)),DefileCursor=v21(59 - (25 + 23)),DefilePlayer=v21(3 + 9)};
	v21.DeathKnight.Blood = v19(v21.DeathKnight.Commons, {});
	v21.DeathKnight.Unholy = v19(v21.DeathKnight.Commons, {});
	v21.DeathKnight.Frost = v19(v21.DeathKnight.Commons, {});
	local v34 = {(143768 - 101118),(106346 - 51256),(505666 - 298355),(109234 - 65969),(154076 - (503 + 1293)),(56100 + 21475),(80494 + 35495),(41038 + 4486),(4447 - (711 + 22)),(344153 - (240 + 619)),(177638 - 65965)};
	v10.GhoulTable = {SummonedGhoul=nil,SummonExpiration=nil,SummonedGargoyle=nil,GargoyleExpiration=nil,ApocMagusExpiration=(0 + 0),ArmyMagusExpiration=(1744 - (1344 + 400))};
	v10:RegisterForSelfCombatEvent(function(v44, v44, v44, v44, v44, v44, v44, v45, v44, v44, v44, v46)
		local v47 = 405 - (255 + 150);
		while true do
			if ((v47 == (0 + 0)) or ((1781 + 1544) > (19709 - 15096))) then
				if ((v46 == (150465 - 103880)) or ((6689 - (404 + 1335)) <= (4959 - (183 + 223)))) then
					local v72 = 0 - 0;
					while true do
						if (((1766 + 899) <= (1416 + 2517)) and (v72 == (337 - (10 + 327)))) then
							v10.GhoulTable.SummonedGhoul = v45;
							v10.GhoulTable.SummonExpiration = GetTime() + 42 + 18;
							break;
						end
					end
				end
				if (((3611 - (118 + 220)) == (1091 + 2182)) and ((v46 == (49655 - (108 + 341))) or (v46 == (93128 + 114221)))) then
					local v73 = 0 - 0;
					while true do
						if (((5317 - (711 + 782)) > (783 - 374)) and (v73 == (469 - (270 + 199)))) then
							v10.GhoulTable.SummonedGargoyle = v45;
							v10.GhoulTable.GargoyleExpiration = GetTime() + 9 + 16;
							break;
						end
					end
				end
				break;
			end
		end
	end, "SPELL_SUMMON");
	v10:RegisterForSelfCombatEvent(function(v48, v48, v48, v48, v48, v48, v48, v48, v48, v48, v48, v49)
		if (((3906 - (580 + 1239)) == (6203 - 4116)) and (v49 == (313211 + 14363))) then
			local v67 = 0 + 0;
			while true do
				if ((v67 == (0 + 0)) or ((8887 - 5483) > (2798 + 1705))) then
					v10.GhoulTable.SummonedGhoul = nil;
					v10.GhoulTable.SummonExpiration = nil;
					break;
				end
			end
		end
		if ((v13:HasTier(1198 - (645 + 522), 1794 - (1010 + 780)) and ((v10.GhoulTable.ApocMagusExpiration > (0 + 0)) or (v10.GhoulTable.ArmyMagusExpiration > (0 - 0)))) or ((10274 - 6768) <= (3145 - (1045 + 791)))) then
			if (((7479 - 4524) == (4512 - 1557)) and (v49 == (86453 - (351 + 154)))) then
				if (v10.GhoulTable:ApocMagusActive() or ((4477 - (1281 + 293)) == (1761 - (28 + 238)))) then
					v10.GhoulTable.ApocMagusExpiration = v10.GhoulTable.ApocMagusExpiration + (2 - 1);
				end
				if (((6105 - (1381 + 178)) >= (2134 + 141)) and v10.GhoulTable:ArmyMagusActive()) then
					v10.GhoulTable.ArmyMagusExpiration = v10.GhoulTable.ArmyMagusExpiration + 1 + 0;
				end
			end
			for v70, v71 in pairs(v34) do
				if (((350 + 469) >= (75 - 53)) and (v71 == v49)) then
					local v76 = 0 + 0;
					while true do
						if (((3632 - (381 + 89)) == (2805 + 357)) and (v76 == (0 + 0))) then
							if (v10.GhoulTable:ApocMagusActive() or ((4057 - 1688) > (5585 - (1074 + 82)))) then
								v10.GhoulTable.ApocMagusExpiration = v10.GhoulTable.ApocMagusExpiration + (0.5 - 0);
							end
							if (((5879 - (214 + 1570)) >= (4638 - (990 + 465))) and v10.GhoulTable:ArmyMagusActive()) then
								v10.GhoulTable.ArmyMagusExpiration = v10.GhoulTable.ArmyMagusExpiration + 0.5 + 0;
							end
							break;
						end
					end
				end
			end
		end
		if ((v13:HasTier(14 + 17, 2 + 0) and (v49 == (1085021 - 809322))) or ((5437 - (1668 + 58)) < (1634 - (512 + 114)))) then
			v10.GhoulTable.ApocMagusExpiration = GetTime() + (52 - 32);
		end
		if ((v13:HasTier(63 - 32, 6 - 4) and (v49 == (19842 + 22808))) or ((197 + 852) <= (788 + 118))) then
			v10.GhoulTable.ArmyMagusExpiration = GetTime() + (101 - 71);
		end
	end, "SPELL_CAST_SUCCESS");
	v10:RegisterForCombatEvent(function(v50, v50, v50, v50, v50, v50, v50, v51)
		local v52 = 1994 - (109 + 1885);
		while true do
			if (((5982 - (1269 + 200)) > (5224 - 2498)) and (v52 == (815 - (98 + 717)))) then
				if ((v51 == v10.GhoulTable.SummonedGhoul) or ((2307 - (802 + 24)) >= (4583 - 1925))) then
					local v77 = 0 - 0;
					while true do
						if ((v77 == (0 + 0)) or ((2474 + 746) == (225 + 1139))) then
							v10.GhoulTable.SummonedGhoul = nil;
							v10.GhoulTable.SummonExpiration = nil;
							break;
						end
					end
				end
				if ((v51 == v10.GhoulTable.SummonedGargoyle) or ((228 + 826) > (9436 - 6044))) then
					local v78 = 0 - 0;
					while true do
						if (((0 + 0) == v78) or ((276 + 400) >= (1355 + 287))) then
							v10.GhoulTable.SummonedGargoyle = nil;
							v10.GhoulTable.GargoyleExpiration = nil;
							break;
						end
					end
				end
				break;
			end
		end
	end, "UNIT_DESTROYED");
	v10.GhoulTable.GhoulRemains = function(v53)
		local v54 = 0 + 0;
		while true do
			if (((1932 + 2204) > (3830 - (797 + 636))) and (v54 == (0 - 0))) then
				if ((v10.GhoulTable.SummonExpiration == nil) or ((5953 - (1427 + 192)) == (1471 + 2774))) then
					return 0 - 0;
				end
				return v10.GhoulTable.SummonExpiration - GetTime();
			end
		end
	end;
	v10.GhoulTable.GhoulActive = function(v55)
		return (v10.GhoulTable.SummonedGhoul ~= nil) and (v10.GhoulTable:GhoulRemains() > (0 + 0));
	end;
	v10.GhoulTable.GargRemains = function(v56)
		local v57 = 0 + 0;
		while true do
			if ((v57 == (326 - (192 + 134))) or ((5552 - (316 + 960)) <= (1687 + 1344))) then
				if ((v10.GhoulTable.GargoyleExpiration == nil) or ((3691 + 1091) <= (1109 + 90))) then
					return 0 - 0;
				end
				return v10.GhoulTable.GargoyleExpiration - GetTime();
			end
		end
	end;
	v10.GhoulTable.GargActive = function(v58)
		return (v10.GhoulTable.SummonedGargoyle ~= nil) and (v10.GhoulTable:GargRemains() > (551 - (83 + 468)));
	end;
	v10.GhoulTable.ArmyMagusRemains = function(v59)
		return v10.GhoulTable.ArmyMagusExpiration - GetTime();
	end;
	v10.GhoulTable.ArmyMagusActive = function(v60)
		return v10.GhoulTable:ArmyMagusRemains() > (1806 - (1202 + 604));
	end;
	v10.GhoulTable.ApocMagusRemains = function(v61)
		return v10.GhoulTable.ApocMagusExpiration - GetTime();
	end;
	v10.GhoulTable.ApocMagusActive = function(v62)
		return v10.GhoulTable.ApocMagusRemains() > (0 - 0);
	end;
end;
return v0["Epix_DeathKnight_DeathKnight.lua"]();

