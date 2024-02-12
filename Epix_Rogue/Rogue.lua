local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1696 - (196 + 446)) <= (6732 - 3261)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Rogue_Rogue.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v11.MouseOver;
	local v15 = v9.Spell;
	local v16 = v9.MultiSpell;
	local v17 = v9.Item;
	local v18 = v9.Utils.MergeTableByKey;
	local v19 = v9.Commons.Everyone;
	local v20 = v9.Macro;
	local v21 = math.min;
	local v22 = pairs;
	local v23 = C_Timer;
	local v24 = math.max;
	local v25 = math.abs;
	local v22 = v22;
	local v26 = table.insert;
	local v27 = UnitAttackSpeed;
	local v28 = GetTime;
	local v29 = {};
	v9.Commons.Rogue = v29;
	if (not v15.Rogue or ((2475 - (826 + 46)) <= (1623 - (245 + 702)))) then
		v15.Rogue = {};
	end
	v15.Rogue.Commons = {Sanguine=v15(715762 - 489252, nil, 1 + 0),AncestralCall=v15(276636 - (260 + 1638), nil, 442 - (382 + 58)),ArcanePulse=v15(835266 - 574902, nil, 3 + 0),ArcaneTorrent=v15(51762 - 26716, nil, 11 - 7),BagofTricks=v15(313616 - (902 + 303), nil, 10 - 5),Berserking=v15(63336 - 37039, nil, 1 + 5),BloodFury=v15(22262 - (1121 + 569), nil, 221 - (22 + 192)),Fireblood=v15(265904 - (483 + 200), nil, 1471 - (1404 + 59)),LightsJudgment=v15(699638 - 443991, nil, 11 - 2),Shadowmeld=v15(59749 - (468 + 297), nil, 572 - (334 + 228)),CloakofShadows=v15(105318 - 74094, nil, 25 - 14),CrimsonVial=v15(336087 - 150776, nil, 4 + 8),Evasion=v15(5513 - (141 + 95), nil, 13 + 0),Feint=v15(5060 - 3094, nil, 33 - 19),Blind=v15(491 + 1603, nil, 41 - 26),CheapShot=v15(1289 + 544, nil, 9 + 7),Kick=v15(2486 - 720, nil, 11 + 6),KidneyShot=v15(571 - (92 + 71), nil, 9 + 9),Sap=v15(11382 - 4612, nil, 784 - (574 + 191)),Shiv=v15(4899 + 1039, nil, 50 - 30),SliceandDice=v15(161152 + 154344, nil, 870 - (254 + 595)),Shadowstep=v15(36680 - (55 + 71), nil, 28 - 6),Sprint=v15(4773 - (573 + 1217), nil, 63 - 40),TricksoftheTrade=v15(4409 + 53525, nil, 38 - 14),CripplingPoison=v15(4347 - (714 + 225), nil, 72 - 47),DeadlyPoison=v15(3934 - 1111, nil, 3 + 23),InstantPoison=v15(456949 - 141365, nil, 833 - (118 + 688)),AmplifyingPoison=v15(381712 - (25 + 23), nil, 6 + 22),NumbingPoison=v15(7647 - (927 + 959), nil, 97 - 68),WoundPoison=v15(9411 - (16 + 716), nil, 57 - 27),AtrophicPoison=v15(381734 - (11 + 86), nil, 75 - 44),AcrobaticStrikes=v15(197209 - (175 + 110), nil, 80 - 48),Alacrity=v15(954582 - 761043, nil, 1829 - (503 + 1293)),ColdBlood=v15(1067534 - 685289, nil, 25 + 9),DeeperStratagem=v15(194592 - (810 + 251)),EchoingReprimand=v15(267609 + 118007, nil, 12 + 24),EchoingReprimand2=v15(291673 + 31885, nil, 570 - (43 + 490)),EchoingReprimand3=v15(324292 - (711 + 22), nil, 146 - 108),EchoingReprimand4=v15(324419 - (240 + 619), nil, 10 + 29),EchoingReprimand5=v15(564442 - 209604, nil, 3 + 37),FindWeakness=v15(92767 - (1344 + 400), nil, 446 - (255 + 150)),FindWeaknessDebuff=v15(249079 + 67141, nil, 23 + 19),ImprovedAmbush=v15(1630501 - 1248881, nil, 138 - 95),MarkedforDeath=v15(139358 - (404 + 1335), nil, 450 - (183 + 223)),Nightstalker=v15(17111 - 3049, nil, 30 + 15),ResoundingClarity=v15(137337 + 244285, nil, 383 - (10 + 327)),SealFate=v15(9882 + 4308, nil, 385 - (118 + 220)),Sepsis=v15(128439 + 256969, nil, 497 - (108 + 341)),SepsisBuff=v15(168848 + 207091, nil, 207 - 158),ShadowDance=v15(186806 - (711 + 782), nil, 95 - 45),ShadowDanceTalent=v15(395399 - (270 + 199), nil, 17 + 34),ShadowDanceBuff=v15(187241 - (580 + 1239)),Subterfuge=v15(321679 - 213471, nil, 51 + 2),SubterfugeBuff=v15(4139 + 111053, nil, 24 + 30),ThistleTea=v15(996406 - 614783, nil, 199 + 121),Vigor=v15(16150 - (645 + 522)),Stealth=v15(3574 - (1010 + 780), nil, 57 + 0),Stealth2=v15(548759 - 433568, nil, 169 - 111),Vanish=v15(3692 - (1045 + 791), nil, 148 - 89),VanishBuff=v15(17294 - 5967, nil, 565 - (351 + 154)),VanishBuff2=v15(116767 - (1281 + 293), nil, 327 - (28 + 238)),PoolEnergy=v15(2234271 - 1234361, nil, 1621 - (1381 + 178))};
	v15.Rogue.Assassination = v18(v15.Rogue.Commons, {Ambush=v15(8138 + 538, nil, 51 + 12),AmbushOverride=v15(183430 + 246593),AmplifyingPoisonDebuff=v15(1321788 - 938374, nil, 34 + 30),AmplifyingPoisonDebuffDeathmark=v15(394798 - (381 + 89), nil, 58 + 7),CripplingPoisonDebuff=v15(2306 + 1103, nil, 112 - 46),DeadlyPoisonDebuff=v15(3974 - (1074 + 82), nil, 146 - 79),DeadlyPoisonDebuffDeathmark=v15(396108 - (214 + 1570), nil, 1523 - (990 + 465)),Envenom=v15(13458 + 19187, nil, 31 + 38),FanofKnives=v15(50298 + 1425, nil, 275 - 205),Garrote=v15(2429 - (1668 + 58), nil, 697 - (512 + 114)),GarroteDeathmark=v15(940736 - 579906, nil, 148 - 76),Mutilate=v15(4624 - 3295, nil, 34 + 39),PoisonedKnife=v15(34737 + 150828, nil, 65 + 9),Rupture=v15(6553 - 4610, nil, 2069 - (109 + 1885)),RuptureDeathmark=v15(362295 - (1269 + 200), nil, 145 - 69),WoundPoisonDebuff=v15(9495 - (98 + 717), nil, 903 - (802 + 24)),ArterialPrecision=v15(691163 - 290380, nil, 97 - 19),AtrophicPoisonDebuff=v15(57949 + 334439, nil, 61 + 18),BlindsideBuff=v15(19900 + 101253, nil, 18 + 62),CausticSpatter=v15(1173909 - 751934),CausticSpatterDebuff=v15(1407189 - 985213),CrimsonTempest=v15(43425 + 77986, nil, 33 + 48),CutToTheChase=v15(42618 + 9049, nil, 60 + 22),DashingScoundrel=v15(178256 + 203541, nil, 1516 - (797 + 636)),Deathmark=v15(1748872 - 1388678, nil, 1703 - (1427 + 192)),Doomblade=v15(132247 + 249426, nil, 197 - 112),DragonTemperedBlades=v15(343188 + 38613, nil, 39 + 47),Elusiveness=v15(79334 - (192 + 134)),Exsanguinate=v15(202082 - (316 + 960), nil, 49 + 39),ImprovedGarrote=v15(294512 + 87120, nil, 83 + 6),ImprovedGarroteBuff=v15(1500151 - 1107750, nil, 641 - (83 + 468)),ImprovedGarroteAura=v15(394209 - (1202 + 604), nil, 424 - 333),IndiscriminateCarnage=v15(635440 - 253638, nil, 254 - 162),IndiscriminateCarnageAura=v15(386079 - (45 + 280)),IndiscriminateCarnageBuff=v15(372321 + 13426),InternalBleeding=v15(135378 + 19575, nil, 34 + 59),Kingsbane=v15(213394 + 172233, nil, 17 + 77),LightweightShiv=v15(731418 - 336435),MasterAssassin=v15(257900 - (340 + 1571), nil, 38 + 57),MasterAssassinBuff=v15(258507 - (1733 + 39), nil, 263 - 167),PreyontheWeak=v15(132545 - (125 + 909), nil, 2045 - (1096 + 852)),PreyontheWeakDebuff=v15(114795 + 141114, nil, 139 - 41),SerratedBoneSpike=v15(373836 + 11588, nil, 611 - (409 + 103)),SerratedBoneSpikeDebuff=v15(394272 - (46 + 190), nil, 195 - (51 + 44)),ShivDebuff=v15(90114 + 229390, nil, 1418 - (1114 + 203)),VenomRush=v15(152878 - (228 + 498), nil, 23 + 79),ScentOfBlood=v15(210929 + 170870, nil, 1059 - (174 + 489)),ScentOfBloodBuff=v15(1026694 - 632614),ShroudedSuffocation=v15(387383 - (830 + 1075))});
	v15.Rogue.Outlaw = v18(v15.Rogue.Commons, {AdrenalineRush=v15(14274 - (303 + 221), nil, 1372 - (231 + 1038)),Ambush=v15(7230 + 1446, nil, 1266 - (171 + 991)),AmbushOverride=v15(1772213 - 1342190),BetweentheEyes=v15(846754 - 531413, nil, 262 - 157),BladeFlurry=v15(11107 + 2770, nil, 371 - 265),Dispatch=v15(6052 - 3954, nil, 171 - 64),Elusiveness=v15(244236 - 165228),Opportunity=v15(196875 - (111 + 1137)),PistolShot=v15(185921 - (91 + 67), nil, 327 - 217),RolltheBones=v15(78721 + 236787, nil, 634 - (423 + 100)),SinisterStrike=v15(1357 + 191958, nil, 309 - 197),Audacity=v15(199026 + 182819, nil, 884 - (326 + 445)),AudacityBuff=v15(1685672 - 1299402, nil, 253 - 139),BladeRush=v15(634622 - 362745, nil, 826 - (530 + 181)),CountTheOdds=v15(382863 - (614 + 267), nil, 148 - (19 + 13)),Dreadblades=v15(558502 - 215360, nil, 272 - 155),FanTheHammer=v15(1090783 - 708937, nil, 31 + 87),GhostlyStrike=v15(346348 - 149411, nil, 246 - 127),GreenskinsWickers=v15(388635 - (1293 + 519), nil, 244 - 124),GreenskinsWickersBuff=v15(1029056 - 634925, nil, 231 - 110),HiddenOpportunity=v15(1652749 - 1269468, nil, 287 - 165),ImprovedAdrenalineRush=v15(209432 + 185990, nil, 26 + 97),ImprovedBetweenTheEyes=v15(547150 - 311666, nil, 29 + 95),KeepItRolling=v15(126900 + 255089, nil, 79 + 46),KillingSpree=v15(52786 - (709 + 387), nil, 1984 - (673 + 1185)),LoadedDice=v15(742929 - 486759, nil, 407 - 280),LoadedDiceBuff=v15(421488 - 165317, nil, 92 + 36),PreyontheWeak=v15(98265 + 33246, nil, 173 - 44),PreyontheWeakDebuff=v15(62852 + 193057, nil, 259 - 129),QuickDraw=v15(386594 - 189656, nil, 2011 - (446 + 1434)),SummarilyDispatched=v15(383273 - (1040 + 243), nil, 393 - 261),SwiftSlasher=v15(383835 - (559 + 1288), nil, 2064 - (609 + 1322)),TakeEmBySurpriseBuff=v15(386361 - (13 + 441), nil, 500 - 366),Weaponmaster=v15(525792 - 325059, nil, 672 - 537),UnderhandedUpperhand=v15(15789 + 408255),DeftManeuvers=v15(1386905 - 1005027),Crackshot=v15(150489 + 273214),Gouge=v15(779 + 997, nil, 403 - 267),Broadside=v15(105807 + 87549, nil, 251 - 114),BuriedTreasure=v15(131958 + 67642, nil, 77 + 61),GrandMelee=v15(138930 + 54428, nil, 117 + 22),RuthlessPrecision=v15(189178 + 4179, nil, 573 - (153 + 280)),SkullandCrossbones=v15(576373 - 376770, nil, 127 + 14),TrueBearing=v15(76347 + 117012, nil, 75 + 67),ViciousFollowup=v15(358345 + 36534, nil, 104 + 39)});
	v15.Rogue.Subtlety = v18(v15.Rogue.Commons, {Backstab=v15(80 - 27, nil, 90 + 54),BlackPowder=v15(319842 - (89 + 578), nil, 104 + 41),Elusiveness=v15(164255 - 85247),Eviscerate=v15(197868 - (572 + 477), nil, 20 + 127),Rupture=v15(1167 + 776, nil, 18 + 130),ShadowBlades=v15(121557 - (84 + 2), nil, 245 - 96),Shadowstrike=v15(133593 + 51845, nil, 992 - (497 + 345)),ShurikenStorm=v15(5062 + 192773, nil, 26 + 125),ShurikenToss=v15(115347 - (605 + 728), nil, 109 + 43),SymbolsofDeath=v15(471964 - 259681, nil, 8 + 145),DanseMacabre=v15(1414295 - 1031767, nil, 139 + 15),DanseMacabreBuff=v15(1091543 - 697574, nil, 118 + 37),DeeperDaggers=v15(383006 - (457 + 32), nil, 67 + 89),DeeperDaggersBuff=v15(384807 - (832 + 570), nil, 148 + 9),DarkBrew=v15(99748 + 282756, nil, 559 - 401),DarkShadow=v15(118349 + 127338, nil, 955 - (588 + 208)),EnvelopingShadows=v15(641744 - 403640, nil, 1960 - (884 + 916)),Finality=v15(800846 - 418321, nil, 94 + 67),FinalityBlackPowderBuff=v15(386601 - (232 + 421), nil, 2051 - (1569 + 320)),FinalityEviscerateBuff=v15(94690 + 291259, nil, 31 + 132),FinalityRuptureBuff=v15(1300583 - 914632, nil, 769 - (316 + 289)),Flagellation=v15(1006856 - 622225, nil, 8 + 157),FlagellationPersistBuff=v15(396211 - (666 + 787), nil, 591 - (360 + 65)),Gloomblade=v15(187622 + 13136, nil, 421 - (79 + 175)),GoremawsBite=v15(672663 - 246072, nil, 148 + 41),ImprovedShadowDance=v15(1207633 - 813661, nil, 323 - 155),ImprovedShurikenStorm=v15(320850 - (503 + 396), nil, 350 - (92 + 89)),InvigoratingShadowdust=v15(742078 - 359555),LingeringShadow=v15(196174 + 186350, nil, 101 + 69),LingeringShadowBuff=v15(1511474 - 1125514, nil, 24 + 147),MasterofShadows=v15(449130 - 252154, nil, 151 + 21),PerforatedVeins=v15(182704 + 199814, nil, 526 - 353),PerforatedVeinsBuff=v15(49207 + 345047, nil, 264 - 90),PreyontheWeak=v15(132755 - (485 + 759), nil, 404 - 229),PreyontheWeakDebuff=v15(257098 - (442 + 747), nil, 1311 - (832 + 303)),Premeditation=v15(344106 - (88 + 858), nil, 54 + 123),PremeditationBuff=v15(284010 + 59163, nil, 8 + 170),SecretStratagem=v15(395109 - (766 + 23), nil, 883 - 704),SecretTechnique=v15(383927 - 103208, nil, 474 - 294),Shadowcraft=v15(1447874 - 1021280),ShadowFocus=v15(109282 - (1036 + 37), nil, 129 + 52),ShurikenTornado=v15(541228 - 263303, nil, 144 + 38),SilentStorm=v15(387202 - (641 + 839), nil, 1096 - (910 + 3)),SilentStormBuff=v15(983320 - 597598, nil, 1868 - (1466 + 218)),TheFirstDance=v15(175795 + 206710, nil, 1333 - (556 + 592)),TheRotten=v15(135843 + 246172, nil, 994 - (329 + 479)),TheRottenBuff=v15(395057 - (174 + 680), nil, 642 - 455),Weaponmaster=v15(401151 - 207614, nil, 135 + 53)});
	if (((4172 - (396 + 343)) <= (366 + 3770)) and not v17.Rogue) then
		v17.Rogue = {};
	end
	v17.Rogue.Commons = {AlgetharPuzzleBox=v17(195178 - (29 + 1448), {(48 - 35),(10 + 4)}),ManicGrieftorch=v17(195835 - (389 + 1138), {(13 + 0),(14 + 0)}),WindscarWhetstone=v17(139031 - (320 + 1225), {(8 + 5),(1873 - (821 + 1038))}),Healthstone=v17(13752 - 8240),RefreshingHealingPotion=v17(20930 + 170450),DreamwalkersHealingPotion=v17(367727 - 160704)};
	v17.Rogue.Assassination = v18(v17.Rogue.Commons, {AlgetharPuzzleBox=v17(72068 + 121633, {(1039 - (834 + 192)),(4 + 10)}),AshesoftheEmbersoul=v17(4448 + 202719, {(317 - (300 + 4)),(36 - 22)}),WitherbarksBranch=v17(110361 - (112 + 250), {(32 - 19),(8 + 6)})});
	v17.Rogue.Outlaw = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(145321 + 48987, {(10 + 3),(30 - 16)}),WindscarWhetstone=v17(138368 - (244 + 638), {(38 - 25),(1920 - (1665 + 241))}),BeaconToTheBeyond=v17(204680 - (373 + 344), {(4 + 9),(23 - 9)}),DragonfireBombDispenser=v17(203709 - (35 + 1064), {(27 - 14),(1250 - (298 + 938))})});
	v17.Rogue.Subtlety = v18(v17.Rogue.Commons, {ManicGrieftorch=v17(195567 - (233 + 1026), {(7 + 6),(5 + 9)}),StormEatersBoon=v17(13128 + 181174, {(3 + 10),(53 - 39)}),BeaconToTheBeyond=v17(204260 - (36 + 261), {(1381 - (34 + 1334)),(11 + 3)}),AshesoftheEmbersoul=v17(208450 - (1035 + 248), {(7 + 6),(1147 - (549 + 584))}),WitherbarksBranch=v17(110684 - (314 + 371), {(981 - (478 + 490)),(1186 - (786 + 386))}),BandolierOfTwistedBlades=v17(671006 - 463841, {(1353 - (1093 + 247)),(2 + 12)}),Mirror=v17(824133 - 616552, {(36 - 23),(5 + 9)})});
	if (((16353 - 12108) <= (15962 - 11331)) and not v20.Rogue) then
		v20.Rogue = {};
	end
	v20.Rogue.Commons = {Healthstone=v20(16 + 5),BlindMouseover=v20(22 - 13),CheapShotMouseover=v20(698 - (364 + 324)),KickMouseover=v20(30 - 19),KidneyShotMouseover=v20(28 - 16),TricksoftheTradeFocus=v20(5 + 8),WindscarWhetstone=v20(108 - 82),RefreshingHealingPotion=v20(45 - 16)};
	v20.Rogue.Outlaw = v18(v20.Rogue.Commons, {Dispatch=v20(42 - 28),PistolShotMouseover=v20(1283 - (1249 + 19)),SinisterStrikeMouseover=v20(25 + 2)});
	v20.Rogue.Assassination = v18(v20.Rogue.Commons, {GarroteMouseOver=v20(108 - 80)});
	v20.Rogue.Subtlety = v18(v20.Rogue.Commons, {SecretTechnique=v20(1102 - (686 + 400)),ShadowDance=v20(14 + 3),ShadowDanceSymbol=v20(255 - (73 + 156)),VanishShadowstrike=v20(1 + 17),ShurikenStormSD=v20(830 - (721 + 90)),ShurikenStormVanish=v20(1 + 19),GloombladeSD=v20(71 - 49),GloombladeVanish=v20(493 - (224 + 246)),BackstabMouseover=v20(38 - 14),RuptureMouseover=v20(46 - 21)});
	v29.StealthSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.Stealth2) or v15.Rogue.Commons.Stealth;
	end;
	v29.VanishBuffSpell = function()
		return (v15.Rogue.Commons.Subterfuge:IsAvailable() and v15.Rogue.Commons.VanishBuff2) or v15.Rogue.Commons.VanishBuff;
	end;
	v29.Stealth = function(v49, v50)
		if (((776 + 3500) >= (94 + 3820)) and EpicSettings.Settings['StealthOOC'] and (v15.Rogue.Commons.Stealth:IsCastable() or v15.Rogue.Commons.Stealth2:IsCastable()) and v12:StealthDown()) then
			if (((146 + 52) <= (8678 - 4313)) and v9.Press(v49, nil)) then
				return "Cast Stealth (OOC)";
			end
		end
		return false;
	end;
	do
		local v51 = v15.Rogue.Commons;
		local v52 = v51.CrimsonVial;
		v29.CrimsonVial = function()
			local v113 = 0 - 0;
			local v114;
			while true do
				if (((5295 - (203 + 310)) > (6669 - (1238 + 755))) and (v113 == (0 + 0))) then
					v114 = EpicSettings.Settings['CrimsonVialHP'] or (1534 - (709 + 825));
					if (((8963 - 4099) > (3200 - 1003)) and v52:IsCastable() and v52:IsReady() and (v12:HealthPercentage() <= v114)) then
						if (v9.Cast(v52, nil) or ((4564 - (196 + 668)) == (9898 - 7391))) then
							return "Cast Crimson Vial (Defensives)";
						end
					end
					v113 = 1 - 0;
				end
				if (((5307 - (171 + 662)) >= (367 - (4 + 89))) and (v113 == (3 - 2))) then
					return false;
				end
			end
		end;
	end
	do
		local v54 = v15.Rogue.Commons;
		local v55 = v54.Feint;
		v29.Feint = function()
			local v115 = 0 + 0;
			local v116;
			while true do
				if ((v115 == (0 - 0)) or ((743 + 1151) <= (2892 - (35 + 1451)))) then
					v116 = EpicSettings.Settings['FeintHP'] or (1453 - (28 + 1425));
					if (((3565 - (941 + 1052)) >= (1469 + 62)) and v55:IsCastable() and v12:BuffDown(v55) and (v12:HealthPercentage() <= v116)) then
						if (v9.Cast(v55, nil) or ((6201 - (822 + 692)) < (6483 - 1941))) then
							return "Cast Feint (Defensives)";
						end
					end
					break;
				end
			end
		end;
	end
	do
		local v57 = 0 + 0;
		local v58;
		local v59;
		local v60;
		while true do
			if (((3588 - (45 + 252)) > (1650 + 17)) and (v57 == (1 + 0))) then
				v60 = nil;
				function v60(v151)
					if ((not v12:AffectingCombat() and v12:BuffRefreshable(v151)) or ((2124 - 1251) == (2467 - (114 + 319)))) then
						if (v9.Press(v151, nil, true) or ((4042 - 1226) < (13 - 2))) then
							return "poison";
						end
					end
				end
				v57 = 2 + 0;
			end
			if (((5510 - 1811) < (9859 - 5153)) and (v57 == (1965 - (556 + 1407)))) then
				v29.Poisons = function()
					local v152 = 1206 - (741 + 465);
					while true do
						if (((3111 - (170 + 295)) >= (462 + 414)) and (v152 == (1 + 0))) then
							if (((1511 - 897) <= (2640 + 544)) and v12:BuffDown(v15.Rogue.Commons.CripplingPoison)) then
								if (((2005 + 1121) == (1771 + 1355)) and v15.Rogue.Commons.AtrophicPoison:IsAvailable()) then
									local v224 = 1230 - (957 + 273);
									local v225;
									while true do
										if ((v224 == (0 + 0)) or ((876 + 1311) >= (18876 - 13922))) then
											v225 = v60(v15.Rogue.Commons.AtrophicPoison);
											if (v225 or ((10216 - 6339) == (10919 - 7344))) then
												return v225;
											end
											break;
										end
									end
								elseif (((3500 - 2793) > (2412 - (389 + 1391))) and v15.Rogue.Commons.NumbingPoison:IsAvailable()) then
									local v230 = v60(v15.Rogue.Commons.NumbingPoison);
									if (v230 or ((343 + 203) >= (280 + 2404))) then
										return v230;
									end
								else
									local v231 = v60(v15.Rogue.Commons.CripplingPoison);
									if (((3335 - 1870) <= (5252 - (783 + 168))) and v231) then
										return v231;
									end
								end
							else
								local v219 = v60(v15.Rogue.Commons.CripplingPoison);
								if (((5718 - 4014) > (1402 + 23)) and v219) then
									return v219;
								end
							end
							break;
						end
						if ((v152 == (311 - (309 + 2))) or ((2109 - 1422) == (5446 - (1090 + 122)))) then
							v59 = v12:BuffUp(v15.Rogue.Commons.WoundPoison);
							if (v15.Rogue.Assassination.DragonTemperedBlades:IsAvailable() or ((1080 + 2250) < (4799 - 3370))) then
								local v220 = v60((v59 and v15.Rogue.Commons.WoundPoison) or v15.Rogue.Commons.DeadlyPoison);
								if (((785 + 362) >= (1453 - (628 + 490))) and v220) then
									return v220;
								end
								if (((616 + 2819) > (5191 - 3094)) and v15.Rogue.Commons.AmplifyingPoison:IsAvailable()) then
									local v226 = 0 - 0;
									while true do
										if ((v226 == (774 - (431 + 343))) or ((7613 - 3843) >= (11690 - 7649))) then
											v220 = v60(v15.Rogue.Commons.AmplifyingPoison);
											if (v220 or ((2995 + 796) <= (207 + 1404))) then
												return v220;
											end
											break;
										end
									end
								else
									v220 = v60(v15.Rogue.Commons.InstantPoison);
									if (v220 or ((6273 - (556 + 1139)) <= (2023 - (6 + 9)))) then
										return v220;
									end
								end
							elseif (((206 + 919) <= (1064 + 1012)) and v59) then
								local v227 = v60(v15.Rogue.Commons.WoundPoison);
								if (v227 or ((912 - (28 + 141)) >= (1704 + 2695))) then
									return v227;
								end
							elseif (((1425 - 270) < (1185 + 488)) and v15.Rogue.Commons.AmplifyingPoison:IsAvailable() and v12:BuffDown(v15.Rogue.Commons.DeadlyPoison)) then
								local v232 = v60(v15.Rogue.Commons.AmplifyingPoison);
								if (v232 or ((3641 - (486 + 831)) <= (1503 - 925))) then
									return v232;
								end
							elseif (((13262 - 9495) == (712 + 3055)) and v15.Rogue.Commons.DeadlyPoison:IsAvailable()) then
								local v233 = 0 - 0;
								local v234;
								while true do
									if (((5352 - (668 + 595)) == (3680 + 409)) and (v233 == (0 + 0))) then
										v234 = v60(v15.Rogue.Commons.DeadlyPoison);
										if (((12157 - 7699) >= (1964 - (23 + 267))) and v234) then
											return v234;
										end
										break;
									end
								end
							else
								local v235 = v60(v15.Rogue.Commons.InstantPoison);
								if (((2916 - (1129 + 815)) <= (1805 - (371 + 16))) and v235) then
									return v235;
								end
							end
							v152 = 1751 - (1326 + 424);
						end
					end
				end;
				break;
			end
			if ((v57 == (0 - 0)) or ((18044 - 13106) < (4880 - (88 + 30)))) then
				v58 = 771 - (720 + 51);
				v59 = false;
				v57 = 2 - 1;
			end
		end
	end
	v29.MfDSniping = function(v61)
		if (v61:IsCastable() or ((4280 - (421 + 1355)) > (7034 - 2770))) then
			local v135, v136 = nil, 30 + 30;
			local v137 = (v14:IsInRange(1113 - (286 + 797)) and v14:TimeToDie()) or (40617 - 29506);
			for v139, v140 in v22(v12:GetEnemiesInRange(49 - 19)) do
				local v141 = v140:TimeToDie();
				if (((2592 - (397 + 42)) == (673 + 1480)) and not v140:IsMfDBlacklisted() and (v141 < (v12:ComboPointsDeficit() * (801.5 - (24 + 776)))) and (v141 < v136)) then
					if (((v137 - v141) > (1 - 0)) or ((1292 - (222 + 563)) >= (5708 - 3117))) then
						v135, v136 = v140, v141;
					else
						v135, v136 = v14, v137;
					end
				end
			end
			if (((3227 + 1254) == (4671 - (23 + 167))) and v135 and (v135:GUID() ~= v13:GUID())) then
				v9.Press(v135, v61);
			end
		end
	end;
	v29.CanDoTUnit = function(v62, v63)
		return v19.CanDoTUnit(v62, v63);
	end;
	do
		local v64 = v15.Rogue.Assassination;
		local v65 = v15.Rogue.Subtlety;
		local function v66()
			if ((v64.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) or ((4126 - (690 + 1108)) < (251 + 442))) then
				return 1 + 0 + ((848.05 - (40 + 808)) * v64.Nightstalker:TalentRank());
			end
			return 1 + 0;
		end
		local function v67()
			local v117 = 0 - 0;
			while true do
				if (((4137 + 191) == (2290 + 2038)) and (v117 == (0 + 0))) then
					if (((2159 - (47 + 524)) >= (865 + 467)) and v64.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v64.ImprovedGarroteAura, nil, true) or v12:BuffUp(v64.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v64.SepsisBuff, nil, true))) then
						return 2.5 - 1;
					end
					return 1 - 0;
				end
			end
		end
		v64.Rupture:RegisterPMultiplier(v66, {v65.FinalityRuptureBuff,(1.3 + 0)});
		v64.Garrote:RegisterPMultiplier(v66, v67);
		v64.CrimsonTempest:RegisterPMultiplier(v66);
	end
	do
		local v68 = 0 - 0;
		local v69;
		local v70;
		local v71;
		while true do
			if (((1 + 0) == v68) or ((4653 - (341 + 138)) > (1147 + 3101))) then
				v71 = v15(813778 - 419458);
				v29.CPMaxSpend = function()
					return (331 - (89 + 237)) + ((v69:IsAvailable() and (3 - 2)) or (0 - 0)) + ((v70:IsAvailable() and (882 - (581 + 300))) or (1220 - (855 + 365))) + ((v71:IsAvailable() and (2 - 1)) or (0 + 0));
				end;
				break;
			end
			if ((v68 == (1235 - (1030 + 205))) or ((4306 + 280) <= (77 + 5))) then
				v69 = v15(193817 - (156 + 130));
				v70 = v15(895974 - 501653);
				v68 = 1 - 0;
			end
		end
	end
	v29.CPSpend = function()
		return v21(v12:ComboPoints(), v29.CPMaxSpend());
	end;
	do
		v29.AnimachargedCP = function()
			local v118 = 0 - 0;
			while true do
				if (((1018 + 2845) == (2253 + 1610)) and (v118 == (69 - (10 + 59)))) then
					if (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2) or ((80 + 202) <= (206 - 164))) then
						return 1165 - (671 + 492);
					elseif (((3670 + 939) >= (1981 - (369 + 846))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3)) then
						return 1 + 2;
					elseif (v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4) or ((984 + 168) == (4433 - (1036 + 909)))) then
						return 4 + 0;
					elseif (((5744 - 2322) > (3553 - (11 + 192))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5)) then
						return 3 + 2;
					end
					return -(176 - (135 + 40));
				end
			end
		end;
		v29.EffectiveComboPoints = function(v119)
			if (((2124 - 1247) > (227 + 149)) and (((v119 == (4 - 2)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand2)) or ((v119 == (4 - 1)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand3)) or ((v119 == (180 - (50 + 126))) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand4)) or ((v119 == (13 - 8)) and v12:BuffUp(v15.Rogue.Commons.EchoingReprimand5)))) then
				return 2 + 5;
			end
			return v119;
		end;
	end
	do
		local v74 = v15.Rogue.Assassination.DeadlyPoisonDebuff;
		local v75 = v15.Rogue.Assassination.WoundPoisonDebuff;
		local v76 = v15.Rogue.Assassination.AmplifyingPoisonDebuff;
		local v77 = v15.Rogue.Assassination.CripplingPoisonDebuff;
		local v78 = v15.Rogue.Assassination.AtrophicPoisonDebuff;
		v29.Poisoned = function(v120)
			return ((v120:DebuffUp(v74) or v120:DebuffUp(v76) or v120:DebuffUp(v77) or v120:DebuffUp(v75) or v120:DebuffUp(v78)) and true) or false;
		end;
	end
	do
		local v80 = v15.Rogue.Assassination.Garrote;
		local v81 = v15.Rogue.Assassination.GarroteDeathmark;
		local v82 = v15.Rogue.Assassination.Rupture;
		local v83 = v15.Rogue.Assassination.RuptureDeathmark;
		local v84 = v15.Rogue.Assassination.InternalBleeding;
		local v85 = 1413 - (1233 + 180);
		v29.PoisonedBleeds = function()
			local v121 = 969 - (522 + 447);
			while true do
				if ((v121 == (1422 - (107 + 1314))) or ((1447 + 1671) <= (5640 - 3789))) then
					return v85;
				end
				if ((v121 == (0 + 0)) or ((327 - 162) >= (13816 - 10324))) then
					v85 = 1910 - (716 + 1194);
					for v195, v196 in v22(v12:GetEnemiesInRange(1 + 49)) do
						if (((423 + 3526) < (5359 - (74 + 429))) and v29.Poisoned(v196)) then
							local v206 = 0 - 0;
							while true do
								if ((v206 == (1 + 0)) or ((9787 - 5511) < (2134 + 882))) then
									if (((14459 - 9769) > (10199 - 6074)) and v196:DebuffUp(v84)) then
										v85 = v85 + (434 - (279 + 154));
									end
									break;
								end
								if ((v206 == (778 - (454 + 324))) or ((40 + 10) >= (913 - (12 + 5)))) then
									if (v196:DebuffUp(v80) or ((925 + 789) >= (7536 - 4578))) then
										local v228 = 0 + 0;
										while true do
											if ((v228 == (1093 - (277 + 816))) or ((6371 - 4880) < (1827 - (1058 + 125)))) then
												v85 = v85 + 1 + 0;
												if (((1679 - (815 + 160)) < (4234 - 3247)) and v196:DebuffUp(v81)) then
													v85 = v85 + (2 - 1);
												end
												break;
											end
										end
									end
									if (((887 + 2831) > (5571 - 3665)) and v196:DebuffUp(v82)) then
										v85 = v85 + (1899 - (41 + 1857));
										if (v196:DebuffUp(v83) or ((2851 - (1222 + 671)) > (9394 - 5759))) then
											v85 = v85 + (1 - 0);
										end
									end
									v206 = 1183 - (229 + 953);
								end
							end
						end
					end
					v121 = 1775 - (1111 + 663);
				end
			end
		end;
	end
	do
		local v87 = v28();
		v29.RtBRemains = function(v122)
			local v123 = (v87 - v28()) - v9.RecoveryOffset(v122);
			return ((v123 >= (1579 - (874 + 705))) and v123) or (0 + 0);
		end;
		v9:RegisterForSelfCombatEvent(function(v124, v124, v124, v124, v124, v124, v124, v124, v124, v124, v124, v125)
			if (((2389 + 1112) <= (9336 - 4844)) and (v125 == (8880 + 306628))) then
				v87 = v28() + (709 - (642 + 37));
			end
		end, "SPELL_AURA_APPLIED");
		v9:RegisterForSelfCombatEvent(function(v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v126, v127)
			if ((v127 == (71939 + 243569)) or ((551 + 2891) < (6397 - 3849))) then
				v87 = v28() + v21(494 - (233 + 221), (69 - 39) + v29.RtBRemains(true));
			end
		end, "SPELL_AURA_REFRESH");
		v9:RegisterForSelfCombatEvent(function(v128, v128, v128, v128, v128, v128, v128, v128, v128, v128, v128, v129)
			if (((2531 + 344) >= (3005 - (718 + 823))) and (v129 == (198538 + 116970))) then
				v87 = v28();
			end
		end, "SPELL_AURA_REMOVED");
	end
	do
		local v89 = 805 - (266 + 539);
		local v90;
		while true do
			if ((v89 == (8 - 5)) or ((6022 - (636 + 589)) >= (11614 - 6721))) then
				v9:RegisterForSelfCombatEvent(function(v153, v153, v153, v153, v153, v153, v153, v154, v153, v153, v153, v155)
					if ((v155 == (250415 - 129004)) or ((437 + 114) > (752 + 1316))) then
						if (((3129 - (657 + 358)) > (2499 - 1555)) and (v90.CrimsonTempest[v154] ~= nil)) then
							v90.CrimsonTempest[v154] = nil;
						end
					elseif ((v155 == (1601 - 898)) or ((3449 - (1151 + 36)) >= (2990 + 106))) then
						if ((v90.Garrote[v154] ~= nil) or ((593 + 1662) >= (10562 - 7025))) then
							v90.Garrote[v154] = nil;
						end
					elseif ((v155 == (3775 - (1552 + 280))) or ((4671 - (64 + 770)) < (887 + 419))) then
						if (((6696 - 3746) == (524 + 2426)) and (v90.Rupture[v154] ~= nil)) then
							v90.Rupture[v154] = nil;
						end
					end
				end, "SPELL_AURA_REMOVED");
				v9:RegisterForCombatEvent(function(v156, v156, v156, v156, v156, v156, v156, v157)
					if ((v90.CrimsonTempest[v157] ~= nil) or ((5966 - (157 + 1086)) < (6601 - 3303))) then
						v90.CrimsonTempest[v157] = nil;
					end
					if (((4975 - 3839) >= (236 - 82)) and (v90.Garrote[v157] ~= nil)) then
						v90.Garrote[v157] = nil;
					end
					if ((v90.Rupture[v157] ~= nil) or ((369 - 98) > (5567 - (599 + 220)))) then
						v90.Rupture[v157] = nil;
					end
				end, "UNIT_DIED", "UNIT_DESTROYED");
				break;
			end
			if (((9439 - 4699) >= (5083 - (1813 + 118))) and (v89 == (0 + 0))) then
				v90 = {CrimsonTempest={},Garrote={},Rupture={}};
				v29.Exsanguinated = function(v158, v159)
					local v160 = 1217 - (841 + 376);
					local v161;
					local v162;
					while true do
						if ((v160 == (0 - 0)) or ((599 + 1979) >= (9253 - 5863))) then
							v161 = v158:GUID();
							if (((900 - (464 + 395)) <= (4262 - 2601)) and not v161) then
								return false;
							end
							v160 = 1 + 0;
						end
						if (((1438 - (467 + 370)) < (7356 - 3796)) and (v160 == (2 + 0))) then
							return false;
						end
						if (((805 - 570) < (108 + 579)) and (v160 == (2 - 1))) then
							v162 = v159:ID();
							if (((5069 - (150 + 370)) > (2435 - (74 + 1208))) and (v162 == (298625 - 177214))) then
								return v90.CrimsonTempest[v161] or false;
							elseif ((v162 == (3333 - 2630)) or ((3326 + 1348) < (5062 - (14 + 376)))) then
								return v90.Garrote[v161] or false;
							elseif (((6361 - 2693) < (2952 + 1609)) and (v162 == (1707 + 236))) then
								return v90.Rupture[v161] or false;
							end
							v160 = 2 + 0;
						end
					end
				end;
				v89 = 2 - 1;
			end
			if ((v89 == (2 + 0)) or ((533 - (23 + 55)) == (8543 - 4938))) then
				v9:RegisterForSelfCombatEvent(function(v163, v163, v163, v163, v163, v163, v163, v164, v163, v163, v163, v165)
					if ((v165 == (133999 + 66807)) or ((2392 + 271) == (5134 - 1822))) then
						for v207, v208 in v22(v90) do
							for v213, v214 in v22(v208) do
								if (((1346 + 2931) <= (5376 - (652 + 249))) and (v213 == v164)) then
									v208[v213] = true;
								end
							end
						end
					end
				end, "SPELL_CAST_SUCCESS");
				v9:RegisterForSelfCombatEvent(function(v166, v166, v166, v166, v166, v166, v166, v167, v166, v166, v166, v168)
					if ((v168 == (324914 - 203503)) or ((2738 - (708 + 1160)) == (3227 - 2038))) then
						v90.CrimsonTempest[v167] = false;
					elseif (((2831 - 1278) <= (3160 - (10 + 17))) and (v168 == (158 + 545))) then
						v90.Garrote[v167] = false;
					elseif ((v168 == (3675 - (1400 + 332))) or ((4290 - 2053) >= (5419 - (242 + 1666)))) then
						v90.Rupture[v167] = false;
					end
				end, "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH");
				v89 = 2 + 1;
			end
			if ((v89 == (1 + 0)) or ((1129 + 195) > (3960 - (850 + 90)))) then
				v29.WillLoseExsanguinate = function(v169, v170)
					if (v29.Exsanguinated(v169, v170) or ((5239 - 2247) == (3271 - (360 + 1030)))) then
						return true;
					end
					return false;
				end;
				v29.ExsanguinatedRate = function(v171, v172)
					local v173 = 0 + 0;
					while true do
						if (((8766 - 5660) > (2098 - 572)) and (v173 == (1661 - (909 + 752)))) then
							if (((4246 - (109 + 1114)) < (7085 - 3215)) and v29.Exsanguinated(v171, v172)) then
								return 1 + 1;
							end
							return 243 - (6 + 236);
						end
					end
				end;
				v89 = 2 + 0;
			end
		end
	end
	do
		local v91 = 0 + 0;
		local v92;
		local v93;
		local v94;
		while true do
			if (((337 - 194) > (128 - 54)) and ((1135 - (1076 + 57)) == v91)) then
				v9:RegisterForSelfCombatEvent(function(v174, v174, v174, v174, v174, v174, v174, v174, v174, v174, v174, v175, v174, v174, v176, v177)
					if (((3 + 15) < (2801 - (579 + 110))) and (v175 == (14667 + 171096))) then
						if (((970 + 127) <= (865 + 763)) and ((v28() - v94) > (407.5 - (174 + 233)))) then
							local v216 = 0 - 0;
							while true do
								if (((8126 - 3496) == (2059 + 2571)) and ((1174 - (663 + 511)) == v216)) then
									v93 = v21(v29.CPMaxSpend(), v12:ComboPoints() + v176 + (v24(0 + 0, v176 - (1 + 0)) * v21(5 - 3, v12:BuffStack(v92) - (1 + 0))));
									v94 = v28();
									break;
								end
							end
						end
					end
				end, "SPELL_ENERGIZE");
				break;
			end
			if (((8334 - 4794) > (6494 - 3811)) and (v91 == (0 + 0))) then
				v92 = v15(380760 - 185133);
				v93 = 0 + 0;
				v91 = 1 + 0;
			end
			if (((5516 - (478 + 244)) >= (3792 - (440 + 77))) and ((1 + 0) == v91)) then
				v94 = v28();
				v29.FanTheHammerCP = function()
					if (((5431 - 3947) == (3040 - (655 + 901))) and ((v28() - v94) < (0.5 + 0)) and (v93 > (0 + 0))) then
						if (((967 + 465) < (14321 - 10766)) and (v93 > v12:ComboPoints())) then
							return v93;
						else
							v93 = 1445 - (695 + 750);
						end
					end
					return 0 - 0;
				end;
				v91 = 2 - 0;
			end
		end
	end
	do
		local v95, v96 = 0 - 0, 351 - (285 + 66);
		local v97 = v15(647872 - 369947);
		v29.TimeToNextTornado = function()
			local v130 = 1310 - (682 + 628);
			local v131;
			while true do
				if ((v130 == (1 + 0)) or ((1364 - (176 + 123)) > (1497 + 2081))) then
					if ((v28() == v95) or ((3479 + 1316) < (1676 - (239 + 30)))) then
						return 0 + 0;
					elseif (((1781 + 72) < (8518 - 3705)) and ((v28() - v95) < (0.1 - 0)) and (v131 < (315.25 - (306 + 9)))) then
						return 3 - 2;
					elseif ((((v131 > (0.9 + 0)) or (v131 == (0 + 0))) and ((v28() - v95) > (0.75 + 0))) or ((8066 - 5245) < (3806 - (1140 + 235)))) then
						return 0.1 + 0;
					end
					return v131;
				end
				if ((v130 == (0 + 0)) or ((738 + 2136) < (2233 - (33 + 19)))) then
					if (not v12:BuffUp(v97, nil, true) or ((971 + 1718) <= (1028 - 685))) then
						return 0 + 0;
					end
					v131 = v12:BuffRemains(v97, nil, true) % (1 - 0);
					v130 = 1 + 0;
				end
			end
		end;
		v9:RegisterForSelfCombatEvent(function(v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v132, v133)
			local v134 = 689 - (586 + 103);
			while true do
				if ((v134 == (0 + 0)) or ((5753 - 3884) == (3497 - (1309 + 179)))) then
					if ((v133 == (384067 - 171324)) or ((1544 + 2002) < (6235 - 3913))) then
						v95 = v28();
					elseif ((v133 == (149433 + 48402)) or ((4423 - 2341) == (9510 - 4737))) then
						v96 = v28();
					end
					if (((3853 - (295 + 314)) > (2591 - 1536)) and (v96 == v95)) then
						v95 = 1962 - (1300 + 662);
					end
					break;
				end
			end
		end, "SPELL_CAST_SUCCESS");
	end
	do
		local v99 = 0 - 0;
		local v100;
		while true do
			if ((v99 == (1756 - (1178 + 577))) or ((1721 + 1592) <= (5256 - 3478))) then
				v9:RegisterForSelfCombatEvent(function()
					local v178 = 1405 - (851 + 554);
					while true do
						if ((v178 == (1 + 0)) or ((3940 - 2519) >= (4569 - 2465))) then
							v100.LastOH = v28();
							break;
						end
						if (((2114 - (115 + 187)) <= (2489 + 760)) and (v178 == (0 + 0))) then
							v100.Counter = 0 - 0;
							v100.LastMH = v28();
							v178 = 1162 - (160 + 1001);
						end
					end
				end, "PLAYER_ENTERING_WORLD");
				v9:RegisterForSelfCombatEvent(function(v179, v179, v179, v179, v179, v179, v179, v179, v179, v179, v179, v180)
					if (((1420 + 203) <= (1351 + 606)) and (v180 == (403102 - 206191))) then
						v100.Counter = 358 - (237 + 121);
					end
				end, "SPELL_ENERGIZE");
				v99 = 899 - (525 + 372);
			end
			if (((8364 - 3952) == (14495 - 10083)) and ((144 - (96 + 46)) == v99)) then
				v9:RegisterForSelfCombatEvent(function(v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v181, v182)
					v100.Counter = v100.Counter + (778 - (643 + 134));
					if (((632 + 1118) >= (2018 - 1176)) and v182) then
						v100.LastOH = v28();
					else
						v100.LastMH = v28();
					end
				end, "SWING_DAMAGE");
				v9:RegisterForSelfCombatEvent(function(v184, v184, v184, v184, v184, v184, v184, v184, v184, v184, v184, v184, v184, v184, v184, v185)
					if (((16231 - 11859) > (1775 + 75)) and v185) then
						v100.LastOH = v28();
					else
						v100.LastMH = v28();
					end
				end, "SWING_MISSED");
				break;
			end
			if (((454 - 222) < (1678 - 857)) and (v99 == (719 - (316 + 403)))) then
				v100 = {Counter=(0 + 0),LastMH=(0 - 0),LastOH=(0 + 0)};
				v29.TimeToSht = function(v186)
					local v187 = 0 - 0;
					local v188;
					local v189;
					local v190;
					local v191;
					local v192;
					local v193;
					while true do
						if (((368 + 150) < (291 + 611)) and (v187 == (10 - 7))) then
							table.sort(v192);
							v193 = v21(23 - 18, v24(1 - 0, v186 - v100.Counter));
							v187 = 1 + 3;
						end
						if (((5893 - 2899) > (42 + 816)) and (v187 == (11 - 7))) then
							return v192[v193] - v28();
						end
						if ((v187 == (19 - (12 + 5))) or ((14584 - 10829) <= (1951 - 1036))) then
							v192 = {};
							for v217 = 0 - 0, 4 - 2 do
								local v218 = 0 + 0;
								while true do
									if (((5919 - (1656 + 317)) > (3336 + 407)) and (v218 == (0 + 0))) then
										v26(v192, v190 + (v217 * v188));
										v26(v192, v191 + (v217 * v189));
										break;
									end
								end
							end
							v187 = 7 - 4;
						end
						if ((v187 == (0 - 0)) or ((1689 - (5 + 349)) >= (15702 - 12396))) then
							if (((6115 - (266 + 1005)) > (1485 + 768)) and (v100.Counter >= v186)) then
								return 0 - 0;
							end
							v188, v189 = v27("player");
							v187 = 1 - 0;
						end
						if (((2148 - (561 + 1135)) == (588 - 136)) and (v187 == (3 - 2))) then
							v190 = v24(v100.LastMH + v188, v28());
							v191 = v24(v100.LastOH + v189, v28());
							v187 = 1068 - (507 + 559);
						end
					end
				end;
				v99 = 2 - 1;
			end
		end
	end
	do
		local v101 = 0 - 0;
		local v102;
		local v103;
		local v104;
		while true do
			if ((v101 == (389 - (212 + 176))) or ((5462 - (250 + 655)) < (5691 - 3604))) then
				v104 = nil;
				function v104()
					local v194 = 0 - 0;
					while true do
						if (((6060 - 2186) == (5830 - (1869 + 87))) and (v194 == (3 - 2))) then
							if ((v103 > (1901 - (484 + 1417))) or ((4153 - 2215) > (8270 - 3335))) then
								v23.After(776 - (48 + 725), v104);
							end
							break;
						end
						if ((v194 == (0 - 0)) or ((11415 - 7160) < (1990 + 1433))) then
							if (((3885 - 2431) <= (698 + 1793)) and not v12:AffectingCombat()) then
								v102 = v12:CritChancePct();
								v9.Debug("Base Crit Set to: " .. v102);
							end
							if ((v103 == nil) or (v103 < (0 + 0)) or ((5010 - (152 + 701)) <= (4114 - (430 + 881)))) then
								v103 = 0 + 0;
							else
								v103 = v103 - (896 - (557 + 338));
							end
							v194 = 1 + 0;
						end
					end
				end
				v101 = 5 - 3;
			end
			if (((16993 - 12140) >= (7922 - 4940)) and (v101 == (0 - 0))) then
				v102 = v12:CritChancePct();
				v103 = 801 - (499 + 302);
				v101 = 867 - (39 + 827);
			end
			if (((11411 - 7277) > (7497 - 4140)) and (v101 == (7 - 5))) then
				v9:RegisterForEvent(function()
					if ((v103 == (0 - 0)) or ((293 + 3124) < (7416 - 4882))) then
						v23.After(1 + 2, v104);
						v103 = 2 - 0;
					end
				end, "PLAYER_EQUIPMENT_CHANGED");
				v29.BaseAttackCrit = function()
					return v102;
				end;
				break;
			end
		end
	end
	do
		local v105 = 104 - (103 + 1);
		local v106;
		local v107;
		local v108;
		local v109;
		while true do
			if ((v105 == (556 - (475 + 79))) or ((5884 - 3162) <= (524 - 360))) then
				v109 = nil;
				function v109()
					if ((v106.ImprovedGarrote:IsAvailable() and (v12:BuffUp(v106.ImprovedGarroteAura, nil, true) or v12:BuffUp(v106.ImprovedGarroteBuff, nil, true) or v12:BuffUp(v106.SepsisBuff, nil, true))) or ((312 + 2096) < (1857 + 252))) then
						return 1504.5 - (1395 + 108);
					end
					return 2 - 1;
				end
				v105 = 1207 - (7 + 1197);
			end
			if ((v105 == (0 + 0)) or ((12 + 21) == (1774 - (27 + 292)))) then
				v106 = v15.Rogue.Assassination;
				v107 = v15.Rogue.Subtlety;
				v105 = 2 - 1;
			end
			if ((v105 == (1 - 0)) or ((1857 - 1414) >= (7917 - 3902))) then
				v108 = nil;
				function v108()
					if (((6440 - 3058) > (305 - (43 + 96))) and v106.Nightstalker:IsAvailable() and v12:StealthUp(true, false, true)) then
						return (4 - 3) + ((0.05 - 0) * v106.Nightstalker:TalentRank());
					end
					return 1 + 0;
				end
				v105 = 1 + 1;
			end
			if (((5 - 2) == v105) or ((108 + 172) == (5732 - 2673))) then
				v106.Rupture:RegisterPMultiplier(v108, {v107.FinalityRuptureBuff,(1752.3 - (1414 + 337))});
				v106.Garrote:RegisterPMultiplier(v108, v109);
				break;
			end
		end
	end
end;
return v0["Epix_Rogue_Rogue.lua"]();

