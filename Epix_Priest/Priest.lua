local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((9891 - 6217) >= (935 - 419)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if (((3312 - (915 + 82)) == (6555 - 4240)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((4132 - 989) > (4935 - (1069 + 118)))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
	end
end
v0["Epix_Priest_Priest.lua"] = function(...)
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
	local v22 = UnitPower;
	local v23 = Enum.PowerType.Insanity;
	if (not v16.Priest or ((3486 - 1892) > (379 + 1801))) then
		v16.Priest = {};
	end
	v16.Priest.Commons = {AncestralCall=v16(488153 - 213415, nil, 1 + 0),ArcanePulse=v16(261155 - (368 + 423), nil, 6 - 4),ArcaneTorrent=v16(232651 - (10 + 8), nil, 11 - 8),BagofTricks=v16(312853 - (416 + 26), nil, 12 - 8),Berserking=v16(11286 + 15011, nil, 8 - 3),BerserkingBuff=v16(26735 - (145 + 293), nil, 436 - (44 + 386)),BloodFury=v16(22058 - (998 + 488), nil, 3 + 4),BloodFuryBuff=v16(16845 + 3727, nil, 780 - (201 + 571)),Fireblood=v16(266359 - (116 + 1022), nil, 37 - 28),LightsJudgment=v16(150059 + 105588, nil, 36 - 26),DesperatePrayer=v16(68308 - 49072, nil, 870 - (814 + 45)),DispelMagic=v16(1300 - 772, nil, 1 + 11),Fade=v16(208 + 378, nil, 898 - (261 + 624)),HolyNova=v16(234855 - 102698, nil, 1094 - (1020 + 60)),MassDispel=v16(33798 - (630 + 793), nil, 50 - 35),MindBlast=v16(38313 - 30221, nil, 7 + 9),MindSear=v16(165420 - 117375, nil, 1764 - (760 + 987)),PowerInfusion=v16(11973 - (1789 + 124), nil, 784 - (745 + 21)),PowerInfusionBuff=v16(3461 + 6599, nil, 51 - 32),PowerWordFortitude=v16(84577 - 63015, nil, 1 + 19),PowerWordShield=v16(14 + 3, nil, 1076 - (87 + 968)),PsychicScream=v16(35752 - 27630, nil, 20 + 2),Purify=v16(1191 - 664, nil, 1436 - (447 + 966)),ImprovedPurify=v16(1069414 - 678782, nil, 1841 - (1703 + 114)),ShadowWordDeath=v16(33080 - (376 + 325), nil, 40 - 15),ShadowWordPain=v16(1812 - 1223, nil, 8 + 18),ShadowWordPainDebuff=v16(1296 - 707, nil, 41 - (9 + 5)),Smite=v16(961 - (85 + 291), nil, 1293 - (243 + 1022)),Resurrection=v16(7633 - 5627, nil, 24 + 5),Mindgames=v16(377081 - (1123 + 57), nil, 25 + 5),Shadowfiend=v16(34687 - (163 + 91), nil, 1961 - (1869 + 61)),ShackleUndead=v16(2650 + 6834, nil, 112 - 80),DominateMind=v16(315428 - 110064, nil, 5 + 28),BodyandSoul=v16(88128 - 23999, nil, 95 + 6),BodyandSoulBuff=v16(66555 - (1329 + 145), nil, 1073 - (140 + 831)),AngelicFeather=v16(123386 - (1409 + 441), nil, 815 - (15 + 703)),AngelicFeatherBuff=v16(56294 + 65263, nil, 536 - (262 + 176)),FlashHeal=v16(3782 - (345 + 1376), nil, 797 - (198 + 490)),Renew=v16(613 - 474, nil, 311 - 181),RenewBuff=v16(1345 - (696 + 510), nil, 274 - 143),PowerWordFortitudeBuff=v16(22824 - (1091 + 171), nil, 6 + 28),Pool=v16(3148056 - 2148146, nil, 116 - 81)};
	v16.Priest.Shadow = v19(v16.Priest.Commons, {MindFlay=v16(15781 - (123 + 251), nil, 178 - 142),Shadowform=v16(233396 - (208 + 490), nil, 4 + 33),VampiricTouch=v16(15553 + 19361, nil, 874 - (660 + 176)),VoidBolt=v16(24684 + 180764, nil, 241 - (14 + 188)),VoidEruption=v16(228935 - (534 + 141), nil, 17 + 23),AncientMadness=v16(301842 + 39398, nil, 40 + 1),Damnation=v16(717412 - 376038, nil, 65 - 23),DarkAscension=v16(1097078 - 705969, nil, 24 + 19),DarkVoid=v16(167676 + 95670, nil, 440 - (115 + 281)),DeathSpeaker=v16(912985 - 520478, nil, 38 + 7),DevouringPlague=v16(810740 - 475273, nil, 168 - 122),Dispersion=v16(48452 - (550 + 317), nil, 67 - 20),DistortedReality=v16(574941 - 165897, nil, 134 - 86),DivineStar=v16(122406 - (134 + 151), nil, 1714 - (970 + 695)),FortressOfTheMind=v16(368661 - 175466, nil, 2040 - (582 + 1408)),Halo=v16(418402 - 297758, nil, 63 - 12),HungeringVoid=v16(1300904 - 955686, nil, 1876 - (1195 + 629)),IdolOfCthun=v16(499042 - 121693, nil, 294 - (187 + 54)),IdolOfYoggSaron=v16(374053 - (162 + 618), nil, 128 + 54),InescapableTorment=v16(248718 + 124709, nil, 114 - 60),InsidiousIre=v16(627440 - 254228, nil, 15 + 168),MentalDecay=v16(377630 - (1373 + 263), nil, 1055 - (451 + 549)),Mindbender=v16(63188 + 136986, nil, 86 - 30),MindDevourer=v16(627225 - 254023, nil, 1441 - (746 + 638)),MindFlayInsanity=v16(147300 + 244103, nil, 87 - 29),MindFlayInsanityTalent=v16(391740 - (218 + 123), nil, 1640 - (1535 + 46)),MindMelt=v16(388588 + 2502, nil, 9 + 51),MindSpike=v16(74070 - (306 + 254), nil, 4 + 57),MindSpikeInsanity=v16(799668 - 392202, nil, 1529 - (899 + 568)),Misery=v16(156805 + 81753, nil, 152 - 89),PsychicLink=v16(200087 - (268 + 335), nil, 354 - (60 + 230)),PurifyDisease=v16(214206 - (426 + 146), nil, 8 + 57),ScreamsOfTheVoid=v16(377223 - (282 + 1174), nil, 877 - (569 + 242)),SearingNightmare=v16(983391 - 642006, nil, 4 + 63),ShadowCrash=v16(206409 - (706 + 318), nil, 1319 - (721 + 530)),ShadowyInsight=v16(377252 - (945 + 326), nil, 171 - 102),Silence=v16(13781 + 1706, nil, 770 - (271 + 429)),SurgeOfDarkness=v16(149226 + 13222, nil, 1571 - (1408 + 92)),SurrenderToMadness=v16(321038 - (461 + 625), nil, 1360 - (993 + 295)),TwistofFate=v16(5668 + 103474, nil, 1244 - (418 + 753)),UnfurlingDarkness=v16(129975 + 211298, nil, 8 + 66),VoidTorrent=v16(76972 + 186193, nil, 19 + 56),Voidtouched=v16(407959 - (406 + 123), nil, 1845 - (1749 + 20)),WhisperingShadows=v16(96621 + 310156, nil, 1399 - (1249 + 73)),VampiricEmbrace=v16(5454 + 9832, nil, 1326 - (466 + 679)),DarkAscensionBuff=v16(940800 - 549691, nil, 223 - 145),DarkEvangelismBuff=v16(392999 - (106 + 1794), nil, 25 + 54),DarkThoughtBuff=v16(86250 + 254957, nil, 236 - 156),DeathsTormentBuff=v16(1147517 - 723757, nil, 298 - (4 + 110)),DeathspeakerBuff=v16(393095 - (57 + 527), nil, 1508 - (41 + 1386)),DevouredFearBuff=v16(373422 - (17 + 86), nil, 56 + 26),DevouredPrideBuff=v16(832537 - 459221, nil, 240 - 157),MindDevourerBuff=v16(373370 - (122 + 44), nil, 144 - 60),MindFlayInsanityBuff=v16(1298461 - 907060, nil, 70 + 15),MindSpikeInsanityBuff=v16(58929 + 348539, nil, 173 - 87),ShadowformBuff=v16(232763 - (30 + 35), nil, 60 + 27),ShadowyInsightBuff=v16(377238 - (1043 + 214), nil, 332 - 244),SurgeOfDarknessBuff=v16(88372 - (323 + 889), nil, 239 - 150),UnfurlingDarknessBuff=v16(341862 - (361 + 219), nil, 410 - (53 + 267)),VoidformBuff=v16(43885 + 150364, nil, 504 - (15 + 398)),DevouringPlagueDebuff=v16(336449 - (18 + 964), nil, 346 - 254),HungeringVoidDebuff=v16(199869 + 145350, nil, 59 + 34),VampiricTouchDebuff=v16(35764 - (20 + 830), nil, 74 + 20),DarkReveriesBuff=v16(395089 - (116 + 10), nil, 8 + 87),GatheringShadowsBuff=v16(395699 - (542 + 196), nil, 205 - 109)});
	v16.Priest.Discipline = v19(v16.Priest.Commons, {AtonementBuff=v16(56764 + 137620, nil, 51 + 48),BindingHeals=v16(132567 + 235708, nil, 263 - 163),DarkReprimand=v16(1025948 - 625779, nil, 1654 - (1126 + 425)),DivineStar=v16(111149 - (118 + 287), nil, 407 - 303),DivineStarShadow=v16(123242 - (118 + 1003), nil, 307 - 202),EmbraceShadow=v16(373362 - (142 + 235), nil, 480 - 374),Evangelism=v16(53590 + 192697, nil, 1084 - (553 + 424)),Expiation=v16(739046 - 348214, nil, 96 + 12),Halo=v16(119551 + 966, nil, 65 + 45),HaloShadow=v16(51285 + 69359, nil, 64 + 47),HarshDiscipline=v16(809014 - 435834, nil, 311 - 199),HarshDisciplineBuff=v16(835568 - 462387, nil, 33 + 80),LeapofFaith=v16(354354 - 281029, nil, 867 - (239 + 514)),LightsWrath=v16(131064 + 242114, nil, 1444 - (797 + 532)),LuminousBarrier=v16(197252 + 74214, nil, 40 + 76),MassResurrection=v16(498550 - 286514, nil, 1319 - (373 + 829)),Mindbender=v16(123771 - (476 + 255), nil, 1248 - (369 + 761)),PainSuppression=v16(19209 + 13997, nil, 215 - 96),PainfulPunishment=v16(740351 - 349665, nil, 358 - (64 + 174)),Penance=v16(6771 + 40769, nil, 179 - 58),PurgeTheWicked=v16(204533 - (144 + 192), nil, 338 - (42 + 174)),PurgeTheWickedDebuff=v16(153412 + 50801, nil, 102 + 21),PowerWordBarrier=v16(26603 + 36015, nil, 1628 - (363 + 1141)),PowerWordLife=v16(375061 - (1183 + 397), nil, 380 - 255),PowerWordRadiance=v16(142584 + 51925, nil, 95 + 31),PowerWordSolace=v16(131225 - (1913 + 62), nil, 80 + 47),RadiantProvidenceBuff=v16(1087083 - 676445, nil, 2061 - (565 + 1368)),Rapture=v16(178770 - 131234, nil, 1790 - (1477 + 184)),RhapsodyBuff=v16(532273 - 141637, nil, 123 + 9),Schism=v16(215477 - (564 + 292), nil, 228 - 95),ShadowCovenant=v16(949062 - 634195, nil, 438 - (244 + 60)),ShadowCovenantBuff=v16(247671 + 74434, nil, 611 - (41 + 435)),ShadowFiend=v16(35434 - (938 + 63), nil, 105 + 31),ShatteredPerceptions=v16(392237 - (936 + 189), nil, 46 + 91),SpiritShell=v16(111577 - (1565 + 48), nil, 86 + 52),SurgeofLight=v16(115393 - (782 + 356), nil, 406 - (176 + 91)),TwilightEquilibrium=v16(1017915 - 627210, nil, 206 - 66),TEHolyBuff=v16(391798 - (975 + 117), nil, 2016 - (157 + 1718)),TEShadowBuff=v16(317080 + 73627, nil, 503 - 361),VoidShift=v16(372540 - 263572, nil, 1161 - (697 + 321)),WrathUnleashed=v16(1064537 - 673756, nil, 304 - 160),UltimatePenitence=v16(971609 - 550156, nil, 73 + 112)});
	v16.Priest.Holy = v19(v16.Priest.Commons, {CircleofHealing=v16(383880 - 178997, nil, 394 - 247),DivineHymn=v16(66070 - (322 + 905), nil, 759 - (602 + 9)),EmpyrealBlaze=v16(373805 - (449 + 740), nil, 1021 - (826 + 46)),EmpyrealBlazeBuff=v16(373564 - (245 + 702), nil, 473 - 323),GuardianSpirit=v16(15363 + 32425, nil, 2050 - (260 + 1638)),Heal=v16(2500 - (382 + 58), nil, 490 - 337),HolyFire=v16(12393 + 2521, nil, 318 - 164),HolyFireDebuff=v16(44333 - 29419, nil, 1360 - (902 + 303)),HolyWordChastise=v16(194588 - 105963, nil, 378 - 221),HolyWordSanctify=v16(2996 + 31865, nil, 1848 - (1121 + 569)),HolyWordSerenity=v16(2264 - (22 + 192), nil, 842 - (483 + 200)),LeapofFaith=v16(74788 - (1404 + 59), nil, 437 - 277),Lightweaver=v16(525504 - 134512, nil, 926 - (468 + 297)),LightweaverBuff=v16(391555 - (334 + 228), nil, 546 - 384),MassResurrection=v16(491480 - 279444, nil, 295 - 132),SymbolofHope=v16(18430 + 46471, nil, 400 - (141 + 95)),SurgeofLight=v16(112234 + 2021, nil, 424 - 259),PowerWordLife=v16(897815 - 524334, nil, 39 + 127),PrayerofHealing=v16(1632 - 1036, nil, 118 + 49),PrayerofMending=v16(17224 + 15852, nil, 236 - 68),PrayerofMendingBuff=v16(24559 + 17076, nil, 332 - (92 + 71)),Apotheosis=v16(98880 + 101303, nil, 292 - 118),DivineStar=v16(111509 - (574 + 191), nil, 145 + 30),Halo=v16(301931 - 181414, nil, 90 + 86),HolyWordSalvation=v16(266051 - (254 + 595), nil, 303 - (55 + 71)),PrayerCircle=v16(423380 - 102003, nil, 1968 - (573 + 1217)),PrayerCircleBuff=v16(890033 - 568654, nil, 14 + 165),RhapsodyBuff=v16(629469 - 238833, nil, 1119 - (714 + 225))});
	if (((8983 - 5909) == (4285 - 1211)) and not v18.Priest) then
		v18.Priest = {};
	end
	v18.Priest.Commons = {Healthstone=v18(597 + 4915),RefreshingHealingPotion=v18(277108 - 85728),BeacontotheBeyond=v18(204769 - (118 + 688), {(3 + 10),(47 - 33)}),BelorrelostheSuncaller=v18(207904 - (16 + 716), {(110 - (11 + 86)),(299 - (175 + 110))}),DesperateInvokersCodex=v18(490593 - 296283, {(1809 - (503 + 1293)),(11 + 3)}),EruptingSpearFragment=v18(194830 - (810 + 251), {(4 + 9),(547 - (43 + 490))}),NymuesUnravelingSpindle=v18(209348 - (711 + 22), {(872 - (240 + 619)),(21 - 7)}),VoidmendersShadowgem=v18(7281 + 102726, {(418 - (255 + 150)),(8 + 6)}),Dreambinder=v18(891328 - 682712, {(1755 - (404 + 1335))}),Iridal=v18(208727 - (183 + 223), {(11 + 5)})};
	v18.Priest.Shadow = v19(v18.Priest.Commons, {});
	v18.Priest.Discipline = v19(v18.Priest.Commons, {});
	v18.Priest.Holy = v19(v18.Priest.Commons, {});
	if (((134 + 236) >= (533 - (10 + 327))) and not v21.Priest) then
		v21.Priest = {};
	end
	v21.Priest.Commons = {AngelicFeatherPlayer=v21(14 + 5),PowerInfusionPlayer=v21(366 - (118 + 220)),PowerWordShieldPlayer=v21(10 + 19),FlashHealFocus=v21(479 - (108 + 341)),PowerInfusionFocus=v21(14 + 17),PowerWordLifeFocus=v21(135 - 103),PurifyFocus=v21(1526 - (711 + 782)),RenewFocus=v21(64 - 30),DominateMindMouseover=v21(478 - (270 + 199)),LeapofFaithMouseover=v21(4 + 6),PowerWordLifeMouseover=v21(1830 - (580 + 1239)),PowerWordShieldMouseover=v21(35 - 23),PurifyMouseover=v21(13 + 0),ShadowWordDeathMouseover=v21(1 + 13),ShadowWordPainMouseover=v21(7 + 8),ShackleUndeadMouseover=v21(41 - 25),MassDispelCursor=v21(11 + 6),Healthstone=v21(1202 - (645 + 522)),PowerWordFortitudePlayer=v21(1808 - (1010 + 780)),RefreshingHealingPotion=v21(36 + 0),HaloPlayer=v21(1429 - 1129),DivineStarPlayer=v21(882 - 581),PowerWordShieldFocus=v21(2142 - (1045 + 791))};
	v21.Priest.Shadow = v19(v21.Priest.Commons, {PurifyDiseaseFocus=v21(764 - 462),FlashHealPlayer=v21(462 - 159),RenewPlayer=v21(809 - (351 + 154)),ShadowCrashCursor=v21(1879 - (1281 + 293))});
	v21.Priest.Discipline = v19(v21.Priest.Commons, {DarkReprimandFocus=v21(304 - (28 + 238)),DarkReprimandMouseover=v21(86 - 47),FlashHealMouseover=v21(1600 - (1381 + 178)),PainSuppressionFocus=v21(41 + 2),PainSuppressionMouseover=v21(36 + 8),PenanceFocus=v21(20 + 25),PenanceMouseover=v21(158 - 112),PowerWordBarrierCursor=v21(25 + 22),PowerWordRadianceFocus=v21(520 - (381 + 89)),PowerWordRadiancePlayer=v21(46 + 5),PurgeTheWickedMouseover=v21(36 + 16),RaptureFocus=v21(90 - 37),ShadowCovenantFocus=v21(1211 - (1074 + 82)),RenewMouseover=v21(122 - 66)});
	v21.Priest.Holy = v19(v21.Priest.Commons, {CircleofHealingFocus=v21(1811 - (214 + 1570)),GuardianSpiritFocus=v21(1475 - (990 + 465)),HealFocus=v21(9 + 12),HolyWordSerenityFocus=v21(10 + 12),PrayerofHealingFocus=v21(23 + 0),PrayerofMendingFocus=v21(94 - 70),HolyWordSerenityMouseover=v21(1751 - (1668 + 58)),HolyWordSanctifyCursor=v21(652 - (512 + 114))});
	v10.AddCoreOverride("Player.Insanity", function()
		local v37 = v22("Player", v23);
		if (not v13:IsCasting() or ((8259 - 5091) < (1037 - 535))) then
			return v37;
		elseif (((1527 - 1088) == (205 + 234)) and v13:IsCasting(v16.Priest.Shadow.MindBlast)) then
			return v37 + 2 + 4;
		elseif (v13:IsCasting(v16.Priest.Shadow.VampiricTouch) or v13:IsCasting(v16.Priest.Shadow.MindSpike) or ((1099 + 165) < (917 - 645))) then
			return v37 + (1998 - (109 + 1885));
		elseif (((4592 - (1269 + 200)) < (7457 - 3566)) and v13:IsCasting(v16.Priest.Shadow.MindFlay)) then
			return v37 + ((827 - (98 + 717)) / v16.Priest.Shadow.MindFlay:BaseDuration());
		elseif (((4768 - (802 + 24)) <= (8599 - 3612)) and v13:IsCasting(v16.Priest.Shadow.DarkVoid)) then
			return v37 + (18 - 3);
		elseif (((677 + 3907) == (3522 + 1062)) and v13:IsCasting(v16.Priest.Shadow.DarkAscension)) then
			return v37 + 5 + 25;
		elseif (((859 + 3120) >= (4640 - 2972)) and v13:IsCasting(v16.Priest.Shadow.VoidTorrent)) then
			return v37 + ((200 - 140) / v16.Priest.Shadow.VoidTorrent:BaseDuration());
		else
			return v37;
		end
	end, 93 + 165);
	local v36;
	v36 = v10.AddCoreOverride("Spell.IsCastable", function(v38, v39, v40, v41, v42, v43)
		local v44 = v36(v38, v39, v40, v41, v42, v43);
		if (((232 + 336) > (354 + 74)) and (v38 == v16.Priest.Shadow.VampiricTouch)) then
			return v44 and not v16.Priest.Shadow.ShadowCrash:InFlight() and (v16.Priest.Shadow.UnfurlingDarkness:IsAvailable() or not v13:IsCasting(v38));
		elseif (((970 + 364) <= (2154 + 2459)) and (v38 == v16.Priest.Shadow.MindBlast)) then
			return v44 and ((v38:Charges() >= (1435 - (797 + 636))) or not v13:IsCasting(v38));
		elseif ((v38 == v16.Priest.Shadow.VoidEruption) or ((9055 - 7190) >= (3648 - (1427 + 192)))) then
			return v44 and not v13:IsCasting(v38);
		elseif (((1716 + 3234) >= (3751 - 2135)) and (v38 == v16.Priest.Shadow.VoidBolt)) then
			return v44 or v13:IsCasting(v16.Priest.Shadow.VoidEruption);
		else
			return v44;
		end
	end, 232 + 26);
end;
return v0["Epix_Priest_Priest.lua"]();

