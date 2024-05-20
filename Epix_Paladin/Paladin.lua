local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((4944 - (226 + 1044)) >= (2246 - 1730)) and (v5 == (118 - (32 + 85)))) then
			return v6(...);
		end
		if (((2269 + 46) == (514 + 1801)) and (v5 == (957 - (892 + 65)))) then
			v6 = v0[v4];
			if (not v6 or ((7497 - 4354) > (6927 - 3179))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
	end
end
v0["Epix_Paladin_Paladin.lua"] = function(...)
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
	if (not v16.Paladin or ((1944 - (87 + 263)) > (2360 - (67 + 113)))) then
		v16.Paladin = {};
	end
	v16.Paladin.Commons = {AncestralCall=v16(201458 + 73280, nil, 2 - 1),ArcanePulse=v16(191486 + 68878, nil, 7 - 5),ArcaneTorrent=v16(156097 - (802 + 150), nil, 7 - 4),BagofTricks=v16(566701 - 254290, nil, 3 + 1),Berserking=v16(27294 - (915 + 82), nil, 14 - 9),BloodFury=v16(11985 + 8587, nil, 7 - 1),Fireblood=v16(266408 - (1069 + 118), nil, 15 - 8),GiftoftheNaaru=v16(130245 - 70703, nil, 2 + 6),LightsJudgment=v16(454233 - 198586, nil, 9 + 0),BlessingofFreedom=v16(1835 - (368 + 423), nil, 31 - 21),BlessingofProtection=v16(1040 - (10 + 8), nil, 42 - 31),BlessingofSacrifice=v16(7382 - (416 + 26), nil, 478 - 328),Consecration=v16(11404 + 15169, nil, 20 - 8),CrusaderStrike=v16(35833 - (145 + 293), nil, 443 - (44 + 386)),CleanseToxins=v16(215130 - (998 + 488), nil, 5 + 9),DivineShield=v16(526 + 116, nil, 787 - (201 + 571)),DivineSteed=v16(191922 - (116 + 1022), nil, 66 - 50),Intercession=v16(229540 + 161514, nil, 62 - 45),FlashofLight=v16(70133 - 50383, nil, 877 - (814 + 45)),HammerofJustice=v16(2101 - 1248, nil, 2 + 17),HandofReckoning=v16(21951 + 40173, nil, 905 - (261 + 624)),Judgment=v16(36023 - 15752, nil, 1101 - (1020 + 60)),Rebuke=v16(97654 - (630 + 793), nil, 74 - 52),Redemption=v16(34696 - 27368, nil, 10 + 13),ShieldoftheRighteous=v16(184547 - 130947, nil, 1771 - (760 + 987)),WordofGlory=v16(87586 - (1789 + 124), nil, 791 - (745 + 21)),AvengingWrath=v16(10968 + 20916, nil, 71 - 45),BlindingLight=v16(454031 - 338281, nil, 1 + 26),HammerofWrath=v16(19059 + 5216, nil, 1083 - (87 + 968)),HolyAvenger=v16(465765 - 359956, nil, 27 + 2),LayonHands=v16(1430 - 797, nil, 1443 - (447 + 966)),Seraphim=v16(416840 - 264578, nil, 1848 - (1703 + 114)),ZealotsParagon=v16(391843 - (376 + 325), nil, 51 - 19),Repentance=v16(61742 - 41676, nil, 44 + 108),TurnEvil=v16(22742 - 12416, nil, 165 - (9 + 5)),ConcentrationAura=v16(318296 - (85 + 291), nil, 1298 - (243 + 1022)),CrusaderAura=v16(122614 - 90391, nil, 29 + 5),DevotionAura=v16(1645 - (1123 + 57), nil, 29 + 6),RetributionAura=v16(183689 - (163 + 91), nil, 1966 - (1869 + 61)),AvengingWrathBuff=v16(8908 + 22976, nil, 130 - 93),BlessingofDuskBuff=v16(591534 - 206408, nil, 6 + 32),ConsecrationBuff=v16(258867 - 70497, nil, 37 + 2),DivinePurposeBuff=v16(225293 - (1329 + 145), nil, 1011 - (140 + 831)),HolyAvengerBuff=v16(107659 - (1409 + 441), nil, 759 - (15 + 703)),SeraphimBuff=v16(70514 + 81748, nil, 480 - (262 + 176)),ShieldoftheRighteousBuff=v16(134124 - (345 + 1376), nil, 731 - (198 + 490)),ConsecrationDebuff=v16(902333 - 698091, nil, 105 - 61),JudgmentDebuff=v16(198483 - (696 + 510), nil, 94 - 49),ForbearanceDebuff=v16(27033 - (1091 + 171), nil, 8 + 38),Entangled=v16(1286273 - 877717, nil, 490 - 342),BlackoutBarrelDebuff=v16(258712 - (123 + 251), nil, 740 - 591),MarkofFyralathDebuff=v16(415230 - (208 + 490), nil, 14 + 146),Pool=v16(445406 + 554504, nil, 883 - (660 + 176))};
	v16.Paladin.Protection = v19(v16.Paladin.Commons, {Judgment=v16(33134 + 242645, nil, 250 - (14 + 188)),ArdentDefender=v16(32525 - (534 + 141), nil, 20 + 29),AvengersShield=v16(28248 + 3687, nil, 49 + 1),BastionofLight=v16(796430 - 417456, nil, 80 - 29),BlessedHammer=v16(572282 - 368263, nil, 28 + 24),CrusadersJudgment=v16(129905 + 74118, nil, 449 - (115 + 281)),DivineToll=v16(873603 - 498027, nil, 45 + 9),EyeofTyr=v16(935704 - 548530, nil, 201 - 146),GuardianofAncientKings=v17(1008 - (550 + 317), 125202 - 38543, 298882 - 86241),HammeroftheRighteous=v16(149770 - 96175, nil, 341 - (134 + 151)),InmostLight=v16(407422 - (970 + 695), nil, 108 - 51),MomentOfGlory=v16(329183 - (582 + 1408), nil, 201 - 143),RighteousProtector=v16(256769 - 52695, nil, 222 - 163),Sentinel=v16(391363 - (1195 + 629), nil, 79 - 19),AllyoftheLightBuff=v16(394955 - (187 + 54), nil, 841 - (162 + 618)),ArdentDefenderBuff=v16(22318 + 9532, nil, 42 + 20),BastionofLightBuff=v16(808238 - 429264, nil, 105 - 42),BulwarkofRighteousFuryBuff=v16(26402 + 311260, nil, 1794 - (1373 + 263)),GuardianofAncientKingsBuff=v17(1140 - (451 + 549), 27355 + 59304, 330922 - 118281),MomentOfGloryBuff=v16(549900 - 222707, nil, 1448 - (746 + 638)),SanctificationBuff=v16(159799 + 264817, nil, 233 - 79),SanctificationEmpowerBuff=v16(424963 - (218 + 123), nil, 1736 - (1535 + 46)),SentinelBuff=v16(387047 + 2492, nil, 10 + 55),ShiningLightFreeBuff=v16(328070 - (306 + 254), nil, 5 + 61)});
	v16.Paladin.Retribution = v19(v16.Paladin.Commons, {TemplarsVerdict=v16(167317 - 82061, nil, 1534 - (899 + 568)),AshestoDust=v16(251943 + 131357, nil, 164 - 96),BladeofJustice=v16(185178 - (268 + 335), nil, 359 - (60 + 230)),BladeofWrath=v16(232404 - (426 + 146), nil, 9 + 61),BlessedChampion=v16(404466 - (282 + 1174), nil, 882 - (569 + 242)),BoundlessJudgment=v16(1167441 - 762163, nil, 5 + 67),Crusade=v16(232919 - (706 + 318), nil, 1324 - (721 + 530)),CrusadingStrikes=v16(405813 - (945 + 326), nil, 184 - 110),DivineArbiter=v16(359760 + 44546, nil, 775 - (271 + 429)),DivineAuxiliary=v16(373098 + 33060, nil, 1576 - (1408 + 92)),DivineHammer=v16(199120 - (461 + 625), nil, 1365 - (993 + 295)),DivineResonance=v16(19941 + 364086, nil, 1249 - (418 + 753)),DivineProtection=v16(153818 + 250058, nil, 9 + 70),DivineStorm=v16(15615 + 37770, nil, 21 + 59),DivineToll=v16(376105 - (406 + 123), nil, 1850 - (1749 + 20)),EmpyreanLegacy=v16(91964 + 295206, nil, 1404 - (1249 + 73)),EmpyreanPower=v16(116568 + 210164, nil, 1228 - (466 + 679)),ExecutionSentence=v16(826343 - 482816, nil, 240 - 156),ExecutionersWill=v16(408840 - (106 + 1794), nil, 27 + 58),ExecutionersWrath=v16(97875 + 289321, nil, 253 - 167),Exorcism=v16(1037642 - 654457, nil, 201 - (4 + 110)),Expurgation=v16(383928 - (57 + 527), nil, 1515 - (41 + 1386)),FinalReckoning=v16(343824 - (17 + 86), nil, 61 + 28),FinalVerdict=v16(854865 - 471537, nil, 260 - 170),FiresofJustice=v16(203482 - (122 + 44), nil, 156 - 65),HolyBlade=v16(1271725 - 888383, nil, 75 + 17),Jurisdiction=v16(58279 + 344692, nil, 188 - 95),JusticarsVengeance=v16(215726 - (30 + 35), nil, 65 + 29),RadiantDecree=v16(384726 - (1043 + 214), nil, 358 - 263),RadiantDecreeTalent=v16(385264 - (323 + 889), nil, 257 - 161),RighteousVerdict=v16(268190 - (361 + 219), nil, 417 - (53 + 267)),ShieldofVengeance=v16(41719 + 142943, nil, 511 - (15 + 398)),TemplarSlash=v16(407629 - (18 + 964), nil, 372 - 273),TemplarStrike=v16(235916 + 171564, nil, 64 + 36),VanguardsMomentum=v16(384164 - (20 + 830), nil, 79 + 22),VanguardofJustice=v16(406671 - (116 + 10), nil, 13 + 158),WakeofAshes=v16(256675 - (542 + 196), nil, 218 - 116),Zeal=v16(78719 + 190850, nil, 53 + 50),CrusadeBuff=v16(83475 + 148420, nil, 273 - 169),DivineArbiterBuff=v16(1043398 - 636423, nil, 1656 - (1126 + 425)),DivineResonanceBuff=v16(384434 - (118 + 287), nil, 415 - 309),EchoesofWrathBuff=v16(424711 - (118 + 1003), nil, 456 - 300),EmpyreanLegacyBuff=v16(387555 - (142 + 235), nil, 485 - 378),EmpyreanPowerBuff=v16(71094 + 255639, nil, 1085 - (553 + 424)),ExpurgationDebuff=v16(724890 - 341544, nil, 139 + 18)});
	v16.Paladin.Holy = v19(v16.Paladin.Commons, {AuraMastery=v16(31566 + 255, nil, 64 + 45),Absolution=v16(90143 + 121913, nil, 63 + 47),BlessingofSummer=v16(841158 - 453151, nil, 309 - 198),BlessingofAutumn=v16(868771 - 480761, nil, 33 + 79),BlessingofWinter=v16(1875124 - 1487113, nil, 866 - (239 + 514)),BlessingofSpring=v16(136275 + 251738, nil, 1443 - (797 + 532)),BlessingofSacrifice=v16(5043 + 1897, nil, 39 + 76),BeaconofVirtue=v16(470309 - 270284, nil, 1318 - (373 + 829)),Cleanse=v16(5718 - (476 + 255), nil, 1247 - (369 + 761)),DivineFavor=v16(121650 + 88644, nil, 214 - 96),DivineProtection=v16(943 - 445, nil, 357 - (64 + 174)),DivineToll=v16(53491 + 322085, nil, 177 - 57),HolyLight=v16(82662 - (144 + 192), nil, 337 - (42 + 174)),HolyShock=v16(15381 + 5092, nil, 102 + 20),InfusionofLightBuff=v16(23005 + 31144, nil, 1627 - (363 + 1141)),LightofDawn=v16(86802 - (1183 + 397), nil, 377 - 253),LightoftheMartyr=v16(134879 + 49119, nil, 94 + 31),Judgment=v16(277748 - (1913 + 62), nil, 80 + 46),Daybreak=v16(1096434 - 682264, nil, 2075 - (565 + 1368)),HandofDivinity=v16(1557971 - 1143698, nil, 1804 - (1477 + 184)),BarrierofFaith=v16(201714 - 53675, nil, 135 + 9),TyrsDeliverance=v16(201508 - (564 + 292), nil, 249 - 104),BeaconofLight=v16(161447 - 107884, nil, 450 - (244 + 60)),BeaconofFaith=v16(120650 + 36260, nil, 623 - (41 + 435)),AvengingCrusader=v16(217332 - (938 + 63), nil, 98 + 29),Awakening=v16(249158 - (936 + 189), nil, 43 + 85),BestowFaith=v16(224919 - (1565 + 48), nil, 80 + 49),CrusadersMight=v16(198064 - (782 + 356), nil, 397 - (176 + 91)),EmpyreanLegacyBuff=v16(1008726 - 621548, nil, 192 - 61),GlimmerofLight=v16(327058 - (975 + 117), nil, 2007 - (157 + 1718)),GlimmerofLightBuff=v16(233144 + 54136, nil, 472 - 339),GoldenPath=v16(1289329 - 912201, nil, 1152 - (697 + 321)),HolyPrism=v16(311000 - 196835, nil, 285 - 150),LightsHammer=v16(263177 - 149019, nil, 53 + 83),JudgmentofLight=v16(344336 - 160558, nil, 367 - 230),JudgmentofLightDebuff=v16(198168 - (322 + 905), nil, 749 - (602 + 9)),UnendingLightBuff=v16(395898 - (449 + 740), nil, 1011 - (826 + 46)),ShieldoftheRighteousHoly=v16(416038 - (245 + 702), nil, 483 - 330)});
	if (((989 + 2085) == (4972 - (260 + 1638))) and not v18.Paladin) then
		v18.Paladin = {};
	end
	v18.Paladin.Commons = {Healthstone=v18(5952 - (382 + 58)),ElementalPotionOfPower=v18(613989 - 422600),RefreshingHealingPotion=v18(159029 + 32351),DreamwalkersHealingPotion=v18(427853 - 220830),AlgetharPuzzleBox=v18(575796 - 382095, {(27 - 14),(2 + 12)}),WindscarWhetstone=v18(139176 - (1121 + 569), {(696 - (483 + 200)),(38 - 24)}),FyralathTheDreamrender=v18(277471 - 71023)};
	v18.Paladin.Protection = v19(v18.Paladin.Commons, {});
	v18.Paladin.Retribution = v19(v18.Paladin.Commons, {});
	v18.Paladin.Holy = v19(v18.Paladin.Commons, {});
	if (((1135 - (468 + 297)) >= (758 - (334 + 228))) and not v21.Paladin) then
		v21.Paladin = {};
	end
	v21.Paladin.Commons = {Healthstone=v21(30 - 21),RefreshingHealingPotion=v21(23 - 13),UseWeapon=v21(182 - 81),BlessingofProtectionMouseover=v21(4 + 7),BlessingofProtectionFocus=v21(265 - (141 + 95)),BlessingofFreedomMouseover=v21(12 + 0),BlessingofSacrificeFocus=v21(77 - 47),CleanseToxinsFocus=v21(66 - 38),CleanseToxinsMouseover=v21(4 + 9),CrusaderStrikeMouseover=v21(38 - 24),FlashofLightFocus=v21(11 + 4),FlashofLightPlayer=v21(9 + 7),IntercessionMouseover=v21(23 - 6),LayonHandsFocus=v21(11 + 7),LayonHandsPlayer=v21(182 - (92 + 71)),LayonHandsMouseover=v21(10 + 10),JudgmentMouseover=v21(34 - 13),HammerofJusticeMouseover=v21(787 - (574 + 191)),RebukeMouseover=v21(19 + 4),RedemptionMouseover=v21(82 - 49),RepentanceMouseOver=v21(16 + 15),TurnEvilMouseOver=v21(881 - (254 + 595)),WordofGloryFocus=v21(150 - (55 + 71)),WordofGloryPlayer=v21(32 - 7),WordofGloryMouseover=v21(1864 - (573 + 1217)),RepentanceMouseover=v21(135 - 86),BlessingofFreedomFocus=v21(7 + 76)};
	v21.Paladin.Protection = v19(v21.Paladin.Commons, {AvengersShieldMouseover=v21(41 - 15)});
	v21.Paladin.Retribution = v19(v21.Paladin.Commons, {FinalReckoningPlayer=v21(979 - (714 + 225)),FinalReckoningCursor=v21(119 - 78)});
	v21.Paladin.Holy = v19(v21.Paladin.Commons, {BeaconofVirtueFocus=v21(83 - 23),BlessingofSummerPlayer=v21(7 + 54),BlessingofSummerFocus=v21(89 - 27),BlessingofSacrificeFocus=v21(869 - (118 + 688)),BlessingofSacrificeMouseover=v21(112 - (25 + 23)),CleanseFocus=v21(13 + 52),CleanseMouseover=v21(1952 - (927 + 959)),DivineTollFocus=v21(225 - 158),HolyLightFocus=v21(800 - (16 + 716)),HolyShockFocus=v21(132 - 63),HolyShockMouseover=v21(167 - (11 + 86)),HolyPrismPlayer=v21(173 - 102),LightoftheMartyrFocus=v21(357 - (175 + 110)),LightsHammerPlayer=v21(183 - 110),LightsHammercursor=v21(369 - 294),HolyLightMouseover=v21(1872 - (503 + 1293)),FlashofLightMouseover=v21(214 - 137),BeaconofLightMacro=v21(58 + 21),BeaconofFaithMacro=v21(1141 - (810 + 251)),BlessingofFreedomPlayer=v21(57 + 25)});
	v16.Paladin.FreedomDebuffList = {v16(232880 + 25458),v16(425230 - (711 + 22)),v16(408888 - (240 + 619)),v16(678435 - 251935),v16(280593 - (1344 + 400))};
	v16.Paladin.FreedomDebuffTankList = {v16(321810 + 86746)};
end;
return v0["Epix_Paladin_Paladin.lua"]();

