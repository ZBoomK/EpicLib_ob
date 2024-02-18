local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((318 + 1086) <= (1891 + 1329)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Druid_Druid.lua"] = function(...)
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
	if (((4158 - 3019) <= (7854 - 5642)) and not v15.Druid) then
		v15.Druid = {};
	end
	v15.Druid.Commons = {Nothing=v15(859 - (814 + 45), nil, 0 - 0),Berserking=v15(1418 + 24879, nil, 1 + 0),Shadowmeld=v15(59869 - (261 + 624), nil, 3 - 1),Barkskin=v15(23892 - (1020 + 60), nil, 1426 - (630 + 793)),BearForm=v15(18593 - 13106, nil, 18 - 14),CatForm=v15(303 + 465, nil, 17 - 12),FerociousBite=v15(24315 - (760 + 987), nil, 1919 - (1789 + 124)),MarkOfTheWild=v15(1892 - (745 + 21), nil, 3 + 4),MarkoftheWildBuff=v15(3097 - 1971),Moonfire=v15(34992 - 26071, nil, 1 + 7),Prowl=v15(4095 + 1120, nil, 1064 - (87 + 968)),Rebirth=v15(90169 - 69685, nil, 10 + 0),Regrowth=v15(20200 - 11264, nil, 1424 - (447 + 966)),Rejuvenation=v15(2118 - 1344, nil, 1829 - (1703 + 114)),Revive=v15(51470 - (376 + 325), nil, 21 - 8),Shred=v15(16064 - 10843, nil, 5 + 9),Soothe=v15(6404 - 3496, nil, 29 - (9 + 5)),TravelForm=v15(1159 - (85 + 291), nil, 1281 - (243 + 1022)),AstralInfluence=v15(751613 - 554089, nil, 176 + 37),AstralCommunion=v15(203539 - (1123 + 57), nil, 14 + 3),ConvokeTheSpirits=v15(391782 - (163 + 91), nil, 1948 - (1869 + 61)),FrenziedRegeneration=v15(6382 + 16460, nil, 66 - 47),HeartOfTheWild=v15(490665 - 171211, nil, 3 + 17),Innervate=v15(40080 - 10914, nil, 20 + 1),IncapacitatingRoar=v15(1573 - (1329 + 145), nil, 993 - (140 + 831)),ImprovedNaturesCure=v15(394228 - (1409 + 441), nil, 741 - (15 + 703)),Ironfur=v15(88954 + 103127, nil, 462 - (262 + 176)),NaturesVigil=v15(126695 - (345 + 1376), nil, 713 - (198 + 490)),Maim=v15(99713 - 77143, nil, 62 - 36),MightyBash=v15(6417 - (696 + 510), nil, 56 - 29),MoonkinForm=v16(1469 - (1091 + 171), 4001 + 20857, 622190 - 424565),PoPHealBuff=v15(1311066 - 915730, nil, 402 - (123 + 251)),Rake=v15(9053 - 7231, nil, 727 - (208 + 490)),Renewal=v15(9134 + 99104, nil, 14 + 16),RemoveCorruption=v15(3618 - (660 + 176), nil, 4 + 27),Rip=v15(1281 - (14 + 188), nil, 707 - (534 + 141)),SkullBash=v15(42952 + 63887, nil, 30 + 3),StampedingRoar=v15(74766 + 2998, nil, 71 - 37),Starfire=v15(308241 - 114088, nil, 98 - 63),Starsurge=v16(111 + 95, 50093 + 28581, 198022 - (115 + 281)),Sunfire=v15(217256 - 123854, nil, 30 + 6),SurvivalInstincts=v15(148233 - 86897, nil, 135 - 98),Swiftmend=v15(19429 - (550 + 317), nil, 54 - 16),Swipe=v16(288 - 83, 298408 - 191623, 214056 - (134 + 151), 215429 - (970 + 695)),Typhoon=v15(252781 - 120312, nil, 2029 - (582 + 1408)),Thrash=v16(728 - 518, 97836 - 20078, 402573 - 295743),WildCharge=v16(2028 - (1195 + 629), 22454 - 5475, 49617 - (187 + 54), 103197 - (162 + 618)),Wildgrowth=v15(33941 + 14497, nil, 27 + 13),UrsolsVortex=v15(219226 - 116433, nil, 68 - 27),MassEntanglement=v15(8004 + 94355, nil, 1678 - (1373 + 263)),FrenziedRegenerationBuff=v15(23842 - (451 + 549), nil, 14 + 29),IronfurBuff=v15(298926 - 106845, nil, 73 - 29),SuddenAmbushBuff=v15(342082 - (746 + 638), nil, 17 + 28),MoonfireDebuff=v15(250230 - 85418, nil, 387 - (218 + 123)),RakeDebuff=v15(157303 - (1535 + 46), nil, 47 + 0),SunfireDebuff=v15(23850 + 140965, nil, 608 - (306 + 254)),ThrashDebuff=v16(13 + 190, 209658 - 102828, 193557 - (899 + 568)),Hibernate=v15(1734 + 903, nil, 503 - 295),Pool=v15(1000513 - (268 + 335), nil, 339 - (60 + 230))};
	v15.Druid.Balance = v18(v15.Druid.Commons, {EclipseLunar=v15(49090 - (426 + 146), nil, 6 + 44),EclipseSolar=v15(49973 - (282 + 1174), nil, 862 - (569 + 242)),Wrath=v15(550147 - 359163, nil, 3 + 49),AetherialKindling=v15(328565 - (706 + 318), nil, 1304 - (721 + 530)),AstralCommunion=v15(401907 - (945 + 326), nil, 134 - 80),AstralSmolder=v15(350641 + 43417, nil, 755 - (271 + 429)),BalanceofAllThings=v15(361974 + 32074, nil, 1556 - (1408 + 92)),CelestialAlignment=v16(1288 - (461 + 625), 195511 - (993 + 295), 19909 + 363501),ElunesGuidance=v15(395162 - (418 + 753), nil, 22 + 35),ForceOfNature=v15(21194 + 184442, nil, 17 + 41),FungalGrowth=v15(99321 + 293678, nil, 588 - (406 + 123)),FuryOfElune=v15(204539 - (1749 + 20), nil, 15 + 45),Incarnation=v16(1523 - (1249 + 73), 36591 + 65969, 391559 - (466 + 679)),IncarnationTalent=v15(947786 - 553773, nil, 174 - 113),NaturesBalance=v15(204330 - (106 + 1794), nil, 20 + 42),OrbitBreaker=v15(96865 + 286332, nil, 185 - 122),OrbitalStrike=v15(1057120 - 666742, nil, 178 - (4 + 110)),PowerofGoldrinn=v15(394630 - (57 + 527), nil, 1492 - (41 + 1386)),PrimordialArcanicPulsar=v15(394063 - (17 + 86), nil, 45 + 21),RattleTheStars=v15(878562 - 484608, nil, 193 - 126),Solstice=v15(343813 - (122 + 44), nil, 117 - 49),SouloftheForest=v15(378546 - 264439, nil, 57 + 12),Starfall=v15(27628 + 163406, nil, 141 - 71),Starlord=v15(202410 - (30 + 35), nil, 49 + 22),Starweaver=v15(395197 - (1043 + 214), nil, 272 - 200),StellarFlare=v15(203559 - (323 + 889), nil, 195 - 122),TwinMoons=v15(280200 - (361 + 219), nil, 394 - (53 + 267)),UmbralEmbrace=v15(88959 + 304801, nil, 488 - (15 + 398)),UmbralIntensity=v15(384177 - (18 + 964), nil, 285 - 209),WaningTwilight=v15(228086 + 165870, nil, 49 + 28),WarriorofElune=v15(203275 - (20 + 830), nil, 61 + 17),WildMushroom=v15(88873 - (116 + 10), nil, 6 + 73),WildSurges=v15(407628 - (542 + 196)),FullMoon=v15(587982 - 313699, nil, 24 + 56),HalfMoon=v15(139354 + 134928, nil, 30 + 51),NewMoon=v15(722755 - 448474, nil, 210 - 128),BOATArcaneBuff=v15(395601 - (1126 + 425), nil, 488 - (118 + 287)),BOATNatureBuff=v15(1544393 - 1150344, nil, 1205 - (118 + 1003)),CABuff=v15(1122022 - 738612, nil, 462 - (142 + 235)),IncarnationBuff=v16(907 - 707, 22316 + 80244, 391391 - (553 + 424)),PAPBuff=v15(744963 - 351002, nil, 76 + 10),RattledStarsBuff=v15(390796 + 3159, nil, 51 + 36),SolsticeBuff=v15(146082 + 197566, nil, 51 + 37),StarfallBuff=v15(414141 - 223107, nil, 247 - 158),StarlordBuff=v15(626280 - 346571, nil, 27 + 63),StarweaversWarp=v15(1903787 - 1509845, nil, 844 - (239 + 514)),StarweaversWeft=v15(138358 + 255586, nil, 1421 - (797 + 532)),UmbralEmbraceBuff=v15(286115 + 107648, nil, 32 + 61),WarriorofEluneBuff=v15(475952 - 273527, nil, 1296 - (373 + 829)),FungalGrowthDebuff=v15(82012 - (476 + 255), nil, 1225 - (369 + 761)),StellarFlareDebuff=v15(117053 + 85294, nil, 174 - 78),GatheringStarstuff=v15(747412 - 353000, nil, 335 - (64 + 174)),TouchTheCosmos=v15(56174 + 338240, nil, 144 - 46),BOATArcaneLegBuff=v15(340282 - (144 + 192), nil, 315 - (42 + 174)),BOATNatureLegBuff=v15(255377 + 84566, nil, 83 + 17),OnethsClearVisionBuff=v15(144361 + 195436, nil, 1605 - (363 + 1141)),OnethsPerceptionBuff=v15(341380 - (1183 + 397), nil, 310 - 208),TimewornDreambinderBuff=v15(249272 + 90777, nil, 77 + 26),DreamstateBuff=v15(426223 - (1913 + 62))});
	v15.Druid.Feral = v18(v15.Druid.Commons, {AdaptiveSwarm=v15(246803 + 145085, nil, 274 - 170),ApexPredatorsCraving=v15(393814 - (565 + 1368), nil, 394 - 289),AshamanesGuidance=v15(393209 - (1477 + 184), nil, 143 - 37),Berserk=v15(99652 + 7299, nil, 963 - (564 + 292)),BerserkHeartoftheLion=v15(674942 - 283768, nil, 325 - 217),Bloodtalons=v15(319743 - (244 + 60), nil, 84 + 25),BrutalSlash=v15(202504 - (41 + 435), nil, 1111 - (938 + 63)),CircleofLifeandDeath=v15(307877 + 92443, nil, 1236 - (936 + 189)),DireFixation=v15(137469 + 280241, nil, 1725 - (1565 + 48)),DoubleClawedRake=v15(241960 + 149740, nil, 1251 - (782 + 356)),FeralFrenzy=v15(275104 - (176 + 91), nil, 296 - 182),Incarnation=v15(151128 - 48585, nil, 1207 - (975 + 117)),LionsStrength=v15(393847 - (157 + 1718), nil, 95 + 21),LunarInspiration=v15(552297 - 396717, nil, 399 - 282),LIMoonfire=v15(156643 - (697 + 321), nil, 321 - 203),MomentofClarity=v15(500136 - 264068, nil, 273 - 154),Predator=v15(78636 + 123385, nil, 224 - 104),PrimalWrath=v15(765024 - 479643, nil, 1348 - (322 + 905)),RampantFerocity=v15(392320 - (602 + 9), nil, 1311 - (449 + 740)),RipandTear=v15(392219 - (826 + 46), nil, 1070 - (245 + 702)),Sabertooth=v15(638409 - 436378, nil, 40 + 84),SouloftheForest=v15(160374 - (260 + 1638), nil, 565 - (382 + 58)),Swipe=v15(342574 - 235789, nil, 105 + 21),TearOpenWounds=v15(809701 - 417916, nil, 377 - 250),ThrashingClaws=v15(406505 - (902 + 303), nil, 280 - 152),TigersFury=v15(12565 - 7348, nil, 12 + 117),UnbridledSwarm=v15(393641 - (1121 + 569), nil, 344 - (22 + 192)),WildSlashes=v15(391547 - (483 + 200), nil, 1594 - (1404 + 59)),FranticMomentum=v15(1072459 - 680584, nil, 283 - 72),ApexPredatorsCravingBuff=v15(392647 - (468 + 297), nil, 694 - (334 + 228)),BloodtalonsBuff=v15(489595 - 344443, nil, 308 - 175),Clearcasting=v15(246111 - 110411, nil, 39 + 95),OverflowingPowerBuff=v15(405425 - (141 + 95), nil, 133 + 2),PredatorRevealedBuff=v15(1051399 - 642931, nil, 326 - 190),PredatorySwiftnessBuff=v15(16249 + 53120, nil, 375 - 238),SabertoothBuff=v15(275377 + 116345, nil, 72 + 66),SuddenAmbushBuff=v15(551994 - 160020, nil, 82 + 57),SmolderingFrenzyBuff=v15(422914 - (92 + 71), nil, 105 + 107),AdaptiveSwarmDebuff=v15(658881 - 266992, nil, 905 - (574 + 191)),AdaptiveSwarmHeal=v15(323257 + 68634, nil, 353 - 212),DireFixationDebuff=v15(213363 + 204350, nil, 991 - (254 + 595)),LIMoonfireDebuff=v15(155751 - (55 + 71), nil, 187 - 44),ThrashDebuff=v15(407023 - (573 + 1217), nil, 398 - 254)});
	v15.Druid.Guardian = v18(v15.Druid.Commons, {Mangle=v15(2581 + 31336, nil, 233 - 88),Berserk=v15(51273 - (714 + 225), nil, 426 - 280),BristlingFur=v15(217258 - 61423, nil, 16 + 131),DreamofCenarius=v15(538808 - 166689, nil, 954 - (118 + 688)),FlashingClaws=v15(393475 - (25 + 23), nil, 29 + 120),FuryofNature=v15(372581 - (927 + 959), nil, 505 - 355),Incarnation=v15(103290 - (16 + 716), nil, 291 - 140),LayeredMane=v15(384818 - (11 + 86), nil, 370 - 218),LunarBeam=v15(204351 - (175 + 110), nil, 385 - 232),Maul=v15(33573 - 26766, nil, 1950 - (503 + 1293)),Pulverize=v15(224298 - 143985, nil, 113 + 42),RageoftheSleeper=v15(201912 - (810 + 251), nil, 109 + 47),Raze=v15(122839 + 277415, nil, 142 + 15),ReinforcedFur=v15(394151 - (43 + 490), nil, 891 - (711 + 22)),SouloftheForest=v15(613021 - 454544, nil, 1018 - (240 + 619)),Swipe=v15(51586 + 162185, nil, 254 - 94),ThornsofIron=v15(26488 + 373734, nil, 1905 - (1344 + 400)),ToothandClaw=v15(135693 - (255 + 150), nil, 128 + 34),ViciousCycle=v15(199159 + 172840, nil, 696 - 533),VulnerableFlesh=v15(1203526 - 830908, nil, 1903 - (404 + 1335)),Growl=v15(7201 - (183 + 223), nil, 255 - 45),BerserkBuff=v15(33351 + 16983, nil, 60 + 105),DreamofCenariusBuff=v15(372489 - (10 + 327), nil, 116 + 50),GalacticGuardianBuff=v15(214046 - (118 + 220), nil, 56 + 111),GoreBuff=v15(94111 - (108 + 341), nil, 76 + 92),IncarnationBuff=v15(433595 - 331037, nil, 1662 - (711 + 782)),ToothandClawBuff=v15(259347 - 124061, nil, 639 - (270 + 199)),ViciousCycleMaulBuff=v15(120603 + 251412, nil, 1990 - (580 + 1239)),ViciousCycleMangleBuff=v15(1105933 - 733914, nil, 165 + 7),ToothandClawDebuff=v15(4872 + 130729, nil, 76 + 97)});
	v15.Druid.Restoration = v18(v15.Druid.Commons, {EclipseLunar=v15(126678 - 78160, nil, 109 + 65),EclipseSolar=v15(49684 - (645 + 522), nil, 1965 - (1010 + 780)),Efflorescence=v15(145134 + 71, nil, 838 - 662),Lifebloom=v16(583 - 384, 35599 - (1045 + 791), 477274 - 288724),NaturesCure=v15(135017 - 46594, nil, 682 - (351 + 154)),Revitalize=v15(213614 - (1281 + 293), nil, 444 - (28 + 238)),Starfire=v15(441594 - 243966, nil, 1738 - (1381 + 178)),Starsurge=v15(185361 + 12265, nil, 146 + 34),Wrath=v15(2208 + 2968, nil, 623 - 442),Abundance=v15(107438 + 99945, nil, 652 - (381 + 89)),AdaptiveSwarm=v15(347523 + 44365, nil, 124 + 59),BalanceAffinity=v15(338540 - 140908, nil, 1340 - (1074 + 82)),CenarionWard=v15(224299 - 121948, nil, 1969 - (214 + 1570)),FeralAffinity=v15(198945 - (990 + 465), nil, 77 + 109),Flourish=v15(86033 + 111688, nil, 182 + 5),IronBark=v15(402769 - 300427, nil, 1914 - (1668 + 58)),NaturesSwiftness=v15(132784 - (512 + 114), nil, 492 - 303),Reforestation=v15(811134 - 418778, nil, 661 - 471),SoulOfTheForest=v15(73726 + 84752, nil, 36 + 155),Tranquility=v15(644 + 96, nil, 647 - 455),UnbridledSwarm=v15(393945 - (109 + 1885), nil, 1662 - (1269 + 200)),Undergrowth=v15(751925 - 359624, nil, 1009 - (98 + 717)),AdaptiveSwarmHeal=v15(392717 - (802 + 24), nil, 336 - 141),IncarnationBuff=v15(148622 - 30943, nil, 29 + 167),SoulOfTheForestBuff=v15(87672 + 26436, nil, 33 + 164),AdaptiveSwarmDebuff=v15(84534 + 307355, nil, 550 - 352),GroveGuardians=v15(342456 - 239763, nil, 75 + 134)});
	if (not v17.Druid or ((481 + 699) >= (3476 + 737))) then
		v17.Druid = {};
	end
	v17.Druid.Commons = {RefreshingHealingPotion=v17(139159 + 52221),DreamwalkersHealingPotion=v17(96657 + 110366),Healthstone=v17(6945 - (797 + 636)),Djaruun=v17(983545 - 780976),MirrorofFracturedTomorrows=v17(209200 - (1427 + 192), {(29 - 16),(7 + 7)}),AshesoftheEmbersoul=v17(207493 - (192 + 134), {(8 + 5),(13 + 1)}),BandolierofTwistedBlades=v17(791992 - 584827, {(1819 - (1202 + 604)),(23 - 9)}),MydasTalisman=v17(438343 - 280024, {(13 + 0),(6 + 8)}),WitherbarksBranch=v17(60870 + 49129, {(23 - 10),(6 + 8)})};
	v17.Druid.Balance = v18(v17.Druid.Commons, {});
	v17.Druid.Feral = v18(v17.Druid.Commons, {});
	v17.Druid.Guardian = v18(v17.Druid.Commons, {});
	v17.Druid.Restoration = v18(v17.Druid.Commons, {});
	if (((6425 - (1733 + 39)) > (8447 - 5373)) and not v20.Druid) then
		v20.Druid = {};
	end
	v20.Druid.Commons = {InnervatePlayer=v20(1075 - (125 + 909)),MarkOfTheWildPlayer=v20(1990 - (1096 + 852)),MoonfireMouseover=v20(20 + 23),RakeMouseover=v20(62 - 18),RipMouseover=v20(44 + 1),RebirthMouseover=v20(558 - (409 + 103)),ReviveMouseover=v20(283 - (46 + 190)),RegrowthMouseover=v20(105 - (51 + 44)),RejuvenationFocus=v20(4 + 8),RejuvenationMouseover=v20(1330 - (1114 + 203)),SunfireMouseover=v20(740 - (228 + 498)),SwiftmendFocus=v20(4 + 11),SwiftmendMouseover=v20(9 + 7),SwiftmendPlayer=v20(680 - (174 + 489)),SkullBashMouseover=v20(46 - 28),WildgrowthFocus=v20(1924 - (830 + 1075)),UrsolsVortexCursor=v20(544 - (303 + 221)),HibernateMouseover=v20(1308 - (231 + 1038)),RegrowthPlayer=v20(43 + 8),CancelStarlord=v20(1214 - (171 + 991)),Healthstone=v20(86 - 65),Djaruun=v20(58 - 36),RefreshingHealingPotion=v20(124 - 74)};
	v20.Druid.Balance = v18(v20.Druid.Commons, {StellarFlareMouseover=v20(21 + 4)});
	v20.Druid.Feral = v18(v20.Druid.Commons, {AdaptiveSwarmMouseover=v20(91 - 65),PrimalWrathMouseover=v20(77 - 50),RemoveCorruptionMouseover=v20(78 - 29),AdaptiveSwarmPlayer=v20(163 - 110)});
	v20.Druid.Guardian = v18(v20.Druid.Commons, {PulverizeMouseover=v20(1276 - (111 + 1137)),ThrashMouseover=v20(187 - (91 + 67))});
	v20.Druid.Restoration = v18(v20.Druid.Commons, {AdaptiveSwarmFocus=v20(89 - 59),CenarionWardFocus=v20(8 + 23),EfflorescenceCursor=v20(555 - (423 + 100)),IronBarkFocus=v20(1 + 32),LifebloomFocus=v20(94 - 60),NaturesCureFocus=v20(19 + 16),NaturesCureMouseover=v20(807 - (326 + 445)),EfflorescencePlayer=v20(161 - 124),WildgrowthMouseover=v20(84 - 46),GroveGuardiansFocus=v20(93 - 53),RegrowthFocus=v20(759 - (530 + 181))});
	local v36 = v15.Druid.Feral;
	local v37 = v15.Druid.Restoration;
	local v38 = v15.Druid.Balance;
	v9.AddCoreOverride("Player.AstralPowerP", function()
		local v45 = v12:AstralPower();
		if (((1251 - (614 + 267)) >= (228 - (19 + 13))) and not v12:IsCasting()) then
			return v45;
		elseif (v12:IsCasting(v15.Druid.Balance.Wrath) or v12:IsCasting(v15.Druid.Balance.Starfire) or v12:IsCasting(v15.Druid.Balance.StellarFlare) or ((5155 - 1987) < (1169 - 667))) then
			return v45 + (22 - 14);
		elseif (((115 + 324) == (771 - 332)) and v12:IsCasting(v15.Druid.Balance.NewMoon)) then
			return v45 + (20 - 10);
		elseif (v12:IsCasting(v15.Druid.Balance.HalfMoon) or ((3076 - (1293 + 519)) < (554 - 282))) then
			return v45 + (52 - 32);
		elseif (((5971 - 2848) < (16778 - 12887)) and v12:IsCasting(v15.Druid.Balance.FullMoon)) then
			return v45 + (94 - 54);
		else
			return v45;
		end
	end, 55 + 47);
	v9.AddCoreOverride("Spell.EnergizeAmount", function(v46)
		local v47 = 0 + 0;
		if (((9158 - 5216) <= (1153 + 3834)) and (v46 == v38.StellarFlare)) then
			v47 = 4 + 8;
		elseif (((2865 + 1719) == (5680 - (709 + 387))) and (v46 == v38.AstralCommunion)) then
			v47 = 1918 - (673 + 1185);
		elseif (((11539 - 7560) >= (5356 - 3688)) and (v46 == v38.ForceofNature)) then
			v47 = 32 - 12;
		elseif (((407 + 161) > (320 + 108)) and (v46 == v38.Sunfire)) then
			v47 = 10 - 2;
		elseif (((328 + 1006) <= (9197 - 4584)) and (v46 == v38.Moonfire)) then
			v47 = 11 - 5;
		elseif ((v46 == v38.NewMoon) or ((3745 - (446 + 1434)) >= (3312 - (1040 + 243)))) then
			v47 = 35 - 23;
		elseif (((6797 - (559 + 1288)) >= (3547 - (609 + 1322))) and (v46 == v38.HalfMoon)) then
			v47 = 478 - (13 + 441);
		elseif (((6445 - 4720) == (4518 - 2793)) and (v46 == v38.FullMoon)) then
			v47 = 249 - 199;
		end
		return v47;
	end, 4 + 98);
	local v39;
	v39 = v9.AddCoreOverride("Spell.IsCastable", function(v48, v49, v50, v51, v52, v53)
		local v54 = 0 - 0;
		local v55;
		local v56;
		while true do
			if (((519 + 940) <= (1088 + 1394)) and (v54 == (2 - 1))) then
				v56 = v39(v48, v49, v50, v51, v52, v53);
				if ((v48 == v15.Druid.Balance.MoonkinForm) or ((1476 + 1220) >= (8334 - 3802))) then
					return v56 and v12:BuffDown(v48);
				elseif (((693 + 355) >= (29 + 23)) and (v48 == v15.Druid.Balance.StellarFlare)) then
					return v56 and not v12:IsCasting(v48);
				elseif (((2126 + 832) < (3781 + 722)) and ((v48 == v15.Druid.Balance.Wrath) or (v48 == v15.Druid.Balance.Starfire))) then
					return v56 and not (v12:IsCasting(v48) and (v48:Count() == (1 + 0)));
				elseif ((v48 == v15.Druid.Balance.WarriorofElune) or ((3168 - (153 + 280)) == (3779 - 2470))) then
					return v56 and v12:BuffDown(v48);
				elseif ((v48 == v15.Druid.Balance.NewMoon) or (v48 == v15.Druid.Balance.HalfMoon) or (v48 == v15.Druid.Balance.FullMoon) or ((3708 + 422) <= (1167 + 1788))) then
					return v56 and not v12:IsCasting(v48);
				else
					return v56;
				end
				break;
			end
			if ((v54 == (0 + 0)) or ((1783 + 181) <= (971 + 369))) then
				v55 = true;
				if (((3804 - 1305) == (1545 + 954)) and v50) then
					local v83 = v52 or v13;
					v55 = v83:IsInRange(v50, v51);
				end
				v54 = 668 - (89 + 578);
			end
		end
	end, 73 + 29);
	local v40;
	v40 = v9.AddCoreOverride("Spell.IsCastable", function(v57, v58, v59, v60, v61, v62)
		local v63 = 0 - 0;
		local v64;
		while true do
			if ((v63 == (1049 - (572 + 477))) or ((305 + 1950) < (14 + 8))) then
				v64 = v40(v57, v58, v59, v60, v61, v62);
				if ((v57 == v15.Druid.Feral.CatForm) or (v57 == v15.Druid.Feral.MoonkinForm) or ((130 + 956) >= (1491 - (84 + 2)))) then
					return v64 and v12:BuffDown(v57);
				elseif ((v57 == v15.Druid.Feral.Prowl) or ((3903 - 1534) == (307 + 119))) then
					return v64 and v57:IsUsable() and not v12:StealthUp(true, true);
				else
					return v64;
				end
				break;
			end
		end
	end, 945 - (497 + 345));
	local v41;
	v41 = v9.AddCoreOverride("Spell.IsCastable", function(v65, v66, v67, v68, v69, v70)
		local v71 = v41(v65, v66, v67, v68, v69, v70);
		if ((v65 == v15.Druid.Restoration.CatForm) or (v65 == v15.Druid.Restoration.MoonkinForm) or ((79 + 2997) > (539 + 2644))) then
			return v71 and v12:BuffDown(v65);
		else
			return v71;
		end
	end, 1438 - (605 + 728));
	v9.Druid = {};
	v9.Druid.FullMoonLastCast = nil;
	v9.Druid.OrbitBreakerStacks = 0 + 0;
	v9:RegisterForSelfCombatEvent(function(v72, v73, v73, v73, v73, v73, v73, v73, v73, v73, v73, v74)
		local v75 = 0 - 0;
		while true do
			if (((56 + 1146) > (3911 - 2853)) and (v75 == (0 + 0))) then
				if (((10281 - 6570) > (2534 + 821)) and (v74 == (202986 - (457 + 32)))) then
					v9.Druid.OrbitBreakerStacks = v9.Druid.OrbitBreakerStacks + 1 + 0;
				end
				if ((v74 == (275685 - (832 + 570))) or ((854 + 52) >= (582 + 1647))) then
					if (((4557 - 3269) > (603 + 648)) and (not v15.Druid.Balance.NewMoon:IsAvailable() or (v15.Druid.Balance.NewMoon:IsAvailable() and ((v9.Druid.FullMoonLastCast == nil) or ((v72 - v9.Druid.FullMoonLastCast) > (797.5 - (588 + 208))))))) then
						v9.Druid.OrbitBreakerStacks = 0 - 0;
					end
				end
				break;
			end
		end
	end, "SPELL_DAMAGE");
	v9:RegisterForSelfCombatEvent(function(v76, v77, v77, v77, v77, v77, v77, v77, v77, v77, v77, v78)
		if ((v78 == (276083 - (884 + 916))) or ((9448 - 4935) < (1944 + 1408))) then
			v9.Druid.FullMoonLastCast = v76;
		end
	end, "SPELL_CAST_SUCCESS");
end;
return v0["Epix_Druid_Druid.lua"]();

