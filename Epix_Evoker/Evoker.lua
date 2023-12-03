local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((5597 - (899 + 568)) <= (3257 + 1697)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((2878 - (268 + 335)) > (4836 - (60 + 230)))) then
				return v1(v4, ...);
			end
			v5 = 573 - (426 + 146);
		end
		if (((99 + 720) >= (1478 - (282 + 1174))) and (v5 == (812 - (569 + 242)))) then
			return v6(...);
		end
	end
end
v0["Epix_Evoker_Evoker.lua"] = function(...)
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
	if (((9108 - 5946) == (181 + 2981)) and not v16.Evoker) then
		v16.Evoker = {};
	end
	v16.Evoker.Commons = {TailSwipe=v16(369994 - (706 + 318), nil, 1252 - (721 + 530)),WingBuffet=v16(358485 - (945 + 326), nil, 4 - 2),AzureStrike=v16(322977 + 39992, nil, 703 - (271 + 429)),BlessingoftheBronze=v16(334686 + 29656, nil, 1504 - (1408 + 92)),DeepBreath=v16(358296 - (461 + 625), nil, 1293 - (993 + 295)),Disintegrate=v16(18538 + 338457, nil, 1177 - (418 + 753)),EmeraldBlossom=v16(135551 + 220362, nil, 1 + 6),FireBreath=v17(29 + 67, 90276 + 266932, 382795 - (406 + 123)),LivingFlame=v16(363238 - (1749 + 20), nil, 2 + 6),OppressingRoar=v16(373370 - (1249 + 73), nil, 37 + 65),Expunge=v16(366730 - (466 + 679), nil, 247 - 144),Sleepwalk=v16(1031972 - 671166, nil, 2004 - (106 + 1794)),RenewingBlaze=v16(118426 + 255922, nil, 27 + 78),Hover=v16(1057748 - 699481, nil, 286 - 180),AncientFlame=v16(370104 - (4 + 110), nil, 593 - (57 + 527)),BlastFurnace=v16(376937 - (41 + 1386), nil, 113 - (17 + 86)),LeapingFlames=v16(251079 + 118860, nil, 24 - 13),ObsidianScales=v16(1053880 - 689964, nil, 178 - (122 + 44)),ScarletAdaptation=v16(643377 - 270908, nil, 43 - 30),SourceofMagic=v16(300550 + 68909, nil, 3 + 11),TipTheScales=v16(750687 - 380134, nil, 80 - (30 + 35)),Unravel=v16(253228 + 115204, nil, 1273 - (1043 + 214)),VerdantEmbrace=v16(1364798 - 1003803, nil, 1229 - (323 + 889)),AncientFlameBuff=v16(1010934 - 635351, nil, 598 - (361 + 219)),BlessingoftheBronzeBuff=v16(382068 - (53 + 267), nil, 5 + 14),FireBreathDebuff=v16(357622 - (15 + 398), nil, 1002 - (18 + 964)),HoverBuff=v16(1348559 - 990292, nil, 13 + 8),LeapingFlamesBuff=v16(233682 + 137219, nil, 872 - (20 + 830)),PowerInfusionBuff=v16(7853 + 2207, nil, 149 - (116 + 10)),ScarletAdaptationBuff=v16(27514 + 344956, nil, 762 - (542 + 196)),SourceofMagicBuff=v16(792012 - 422553, nil, 8 + 17),SpoilsofNeltharusCrit=v16(194059 + 187895, nil, 10 + 16),SpoilsofNeltharusHaste=v16(1006486 - 624531, nil, 69 - 42),SpoilsofNeltharusMastery=v16(383507 - (1126 + 425), nil, 433 - (118 + 287)),SpoilsofNeltharusVers=v16(1497001 - 1115044, nil, 1150 - (118 + 1003)),Quell=v16(1028166 - 676828, nil, 407 - (142 + 235)),Pool=v16(4536110 - 3536200, nil, 7 + 24)};
	v16.Evoker.Augmentation = v19(v16.Evoker.Commons, {BlackAttunement=v16(404241 - (553 + 424), nil, 60 - 28),BronzeAttunement=v16(355243 + 48022, nil, 33 + 0),BlisteringScales=v16(210094 + 150733, nil, 15 + 19),BreathofEons=v16(230502 + 173129, nil, 75 - 40),DreamofSpring=v16(1156234 - 741265, nil, 80 - 44),EbonMight=v16(114908 + 280244, nil, 178 - 141),Eruption=v16(395913 - (239 + 514), nil, 14 + 24),FontofMagic=v16(409412 - (797 + 532), nil, 29 + 10),InterwovenThreads=v16(139230 + 273483, nil, 94 - 54),Prescience=v16(410513 - (373 + 829), nil, 772 - (476 + 255)),PupilofAlexstrasza=v16(408944 - (369 + 761), nil, 25 + 17),TimeSkip=v16(735595 - 330618, nil, 80 - 37),Upheaval=v16(408330 - (64 + 174), nil, 7 + 37),BlackAttunementBuff=v16(597208 - 193944, nil, 381 - (144 + 192)),BlisteringScalesBuff=v16(361043 - (42 + 174), nil, 35 + 11),BronzeAttunementBuff=v16(334054 + 69211, nil, 20 + 27),EbonMightOtherBuff=v16(396656 - (363 + 1141), nil, 1628 - (1183 + 397)),EbonMightSelfBuff=v16(1203417 - 808121, nil, 36 + 13),EssenceBurstBuff=v16(293204 + 99064, nil, 2025 - (1913 + 62)),PrescienceBuff=v16(258266 + 151823, nil, 661 - 411),TemporalWoundDebuff=v16(411493 - (565 + 1368), nil, 191 - 140)});
	v16.Evoker.Devastation = v19(v16.Evoker.Commons, {Animosity=v16(377458 - (1477 + 184), nil, 70 - 18),ArcaneVigor=v16(359976 + 26366, nil, 909 - (564 + 292)),Burnout=v16(648417 - 272616, nil, 162 - 108),Catalyze=v16(386587 - (244 + 60), nil, 43 + 12),Causality=v16(376253 - (41 + 435), nil, 1057 - (938 + 63)),ChargedBlast=v16(284909 + 85546, nil, 1182 - (936 + 189)),Dragonrage=v16(123442 + 251645, nil, 1671 - (1565 + 48)),EngulfingBlaze=v16(229073 + 141764, nil, 1197 - (782 + 356)),EssenceAttunement=v16(375989 - (176 + 91), nil, 156 - 96),EternitySurge=v17(142 - 45, 360165 - (975 + 117), 384286 - (157 + 1718)),EternitysSpan=v16(304948 + 70809, nil, 216 - 155),EventHorizon=v16(1405692 - 994528, nil, 1080 - (697 + 321)),EverburningFlame=v16(1010158 - 639339, nil, 133 - 70),EyeofInfinity=v16(851550 - 482175, nil, 25 + 39),FeedtheFlames=v16(692964 - 323118, nil, 174 - 109),Firestorm=v16(370074 - (322 + 905), nil, 677 - (602 + 9)),FontofMagic=v16(376972 - (449 + 740), nil, 939 - (826 + 46)),ImminentDestruction=v16(371728 - (245 + 702), nil, 214 - 146),Pyre=v16(114833 + 242378, nil, 1967 - (260 + 1638)),RagingInferno=v16(406099 - (382 + 58), nil, 224 - 154),RubyEmbers=v16(304078 + 61859, nil, 146 - 75),Scintillation=v16(1102304 - 731483, nil, 1277 - (902 + 303)),ShatteringStar=v16(813379 - 442927, nil, 175 - 102),Snapfire=v16(31862 + 338921, nil, 1764 - (1121 + 569)),Tyranny=v16(377102 - (22 + 192), nil, 758 - (483 + 200)),Volatility=v16(370552 - (1404 + 59), nil, 207 - 131),BlazingShardsBuff=v16(550846 - 140998, nil, 842 - (468 + 297)),BurnoutBuff=v16(376364 - (334 + 228), nil, 263 - 185),ChargedBlastBuff=v16(858678 - 488224, nil, 142 - 63),EmeraldTranceBuff=v16(120445 + 303710, nil, XXXXX),EssenceBurstBuff=v16(359854 - (141 + 95), nil, 79 + 1),IridescenceBlueBuff=v17(251 - 153, 928869 - 542470, 93548 + 305822),IridescenceRedBuff=v16(1058560 - 672207, nil, 57 + 24),LimitlessPotentialBuff=v16(205375 + 189027, nil, 114 - 32),PowerSwellBuff=v16(222288 + 154562, nil, 246 - (92 + 71)),SnapfireBuff=v16(183164 + 187654, nil, 140 - 56),LivingFlameDebuff=v16(362265 - (574 + 191), nil, 71 + 14)});
	v16.Evoker.Preservation = v19(v16.Evoker.Commons, {DreamBreath=v17(247 - 148, 181808 + 174128, 383463 - (254 + 595)),DreamFlight=v16(359942 - (55 + 71), nil, 112 - 26),Echo=v16(366133 - (573 + 1217), nil, 240 - 153),MassReturn=v16(27481 + 333697, nil, 141 - 53),Spiritbloom=v17(1039 - (714 + 225), 1073181 - 705955, 533589 - 150858),Stasis=v16(40116 + 330421, nil, 128 - 39),StasisReactivate=v16(371370 - (118 + 688), nil, 138 - (25 + 23)),TemporalAnomaly=v16(72412 + 301449, nil, 1977 - (927 + 959)),TimeDilation=v16(1203983 - 846813, nil, 824 - (16 + 716)),Reversion=v17(194 - 93, 366252 - (11 + 86), 896063 - 528699),Rewind=v16(363819 - (175 + 110), nil, 234 - 141),FontofMagic=v16(1853455 - 1477672, nil, 1863 - (503 + 1293)),EssenceBurstBuff=v16(1031379 - 662080, nil, 68 + 26),StasisBuff=v16(371623 - (810 + 251), nil, 66 + 29)});
	if (not v18.Evoker or ((728 + 1641) > (3993 + 436))) then
		v18.Evoker = {};
	end
	v18.Evoker.Commons = {Healthstone=v18(6045 - (43 + 490)),CrimsonAspirantsBadgeofFerocity=v18(202182 - (711 + 22), {(872 - (240 + 619)),(21 - 7)}),BelorrelostheSuncaller=v18(13711 + 193461, {(418 - (255 + 150)),(8 + 6)}),DragonfireBombDispenser=v18(865667 - 663057, {(1752 - (404 + 1335)),(16 - 2)}),NymuesUnravelingSpindle=v18(138226 + 70389, {(350 - (10 + 327)),(352 - (118 + 220))}),Dreambinder=v18(69523 + 139093, {(8 + 8)}),Iridal=v18(880740 - 672419, {(30 - 14)}),KharnalexTheFirstLight=v18(195988 - (270 + 199)),SpoilsofNeltharus=v18(62819 + 130954, {(38 - 25),(1 + 13)}),ShadowedOrbofTorment=v18(81213 + 105215, {(9 + 4),(1804 - (1010 + 780))}),RefreshingHealingPotion=v18(191286 + 94)};
	v18.Evoker.Devastation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Preservation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Augmentation = v19(v18.Evoker.Commons, {});
	if (((19508 - 15413) >= (9327 - 6144)) and not v21.Evoker) then
		v21.Evoker = {};
	end
	v21.Evoker.Commons = {Healthstone=v21(1873 - (1045 + 791)),AzureStrikeMouseover=v21(95 - 57),DeepBreathCursor=v21(58 - 19),CauterizingFlameFocus=v21(545 - (351 + 154)),EmeraldBlossomFocus=v21(1615 - (1281 + 293)),FireBreathMacro=v21(308 - (28 + 238)),LivingFlameFocus=v21(95 - 52),QuellMouseover=v21(1603 - (1381 + 178)),VerdantEmbraceFocus=v21(10 + 0),RefreshingHealingPotion=v21(27 + 6),ExpungeMouseover=v21(15 + 19),ExpungeFocus=v21(120 - 85),SleepwalkMouseover=v21(19 + 17),VerdantEmbracePlayer=v21(499 - (381 + 89)),EmeraldBlossomPlayer=v21(28 + 3),SourceofMagicFocus=v21(15 + 7),SourceofMagicName=v21(39 - 16)};
	v21.Evoker.Devastation = v19(v21.Evoker.Commons, {EternitySurgeMacro=v21(1167 - (1074 + 82))});
	v21.Evoker.Preservation = v19(v21.Evoker.Commons, {DreamBreathMacro=v21(25 - 13),DreamFlightCursor=v21(1797 - (214 + 1570)),EchoFocus=v21(1469 - (990 + 465)),SpiritbloomFocus=v21(7 + 8),TimeDilationFocus=v21(7 + 9),TipTheScalesDreamBreath=v21(17 + 0),TipTheScalesSpiritbloom=v21(70 - 52),ReversionFocus=v21(1745 - (1668 + 58))});
	v21.Evoker.Augmentation = v19(v21.Evoker.Commons, {BlisteringScalesFocus=v21(646 - (512 + 114)),BlisteringScalesName=v21(54 - 33),PrescienceName1=v21(49 - 25),PrescienceName2=v21(86 - 61),PrescienceName3=v21(13 + 13),PrescienceName4=v21(6 + 21),PrescienceFocus=v21(25 + 3),BreathofEonsCursor=v21(151 - 106)});
	v20.Commons.Evoker = {};
	local v35 = v20.Commons.Evoker;
	v35.FirestormTracker = {};
	v10:RegisterForEvent(function(v42, v43, v44)
		local v45 = 1994 - (109 + 1885);
		while true do
			if ((v45 == (1469 - (1269 + 200))) or ((7112 - 3401) < (1823 - (98 + 717)))) then
				if ((v43 ~= "player") or ((1875 - (802 + 24)) <= (1562 - 656))) then
					return;
				end
				if (((5699 - 1186) > (403 + 2323)) and (v44 == "ESSENCE")) then
					v11.Persistent.Player.LastPowerUpdate = GetTime();
				end
				break;
			end
		end
	end, "UNIT_POWER_UPDATE");
	v10:RegisterForSelfCombatEvent(function(v46, v46, v46, v46, v46, v46, v46, v47, v46, v46, v46, v48)
		if ((v48 == (283799 + 85575)) or ((244 + 1237) >= (574 + 2084))) then
			v35.FirestormTracker[v47] = GetTime();
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForCombatEvent(function(v49, v49, v49, v49, v49, v49, v49, v50)
		if (v35.FirestormTracker[v50] or ((8957 - 5737) == (4548 - 3184))) then
			v35.FirestormTracker[v50] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v51, v52, v53, v54, v55, v56)
		local v57 = true;
		if (v53 or ((377 + 677) > (1381 + 2011))) then
			local v140 = 0 + 0;
			local v141;
			while true do
				if ((v140 == (0 + 0)) or ((316 + 360) >= (3075 - (797 + 636)))) then
					v141 = v55 or v14;
					v57 = v141:IsInRange(v53, v54);
					break;
				end
			end
		end
		local v58 = v37(v51, v52, v53, v54, v55, v56);
		if (((20081 - 15945) > (4016 - (1427 + 192))) and (v51 == v16.Evoker.Devastation.Firestorm)) then
			return v58 and not v13:IsCasting(v51);
		elseif ((v51 == v16.Evoker.Devastation.TipTheScales) or ((1502 + 2832) == (9855 - 5610))) then
			return v58 and not v13:BuffUp(v51);
		else
			return v58;
		end
	end, 1319 + 148);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v59 = 0 + 0;
		local v60;
		local v61;
		local v62;
		local v63;
		while true do
			if ((v59 == (327 - (192 + 134))) or ((5552 - (316 + 960)) <= (1687 + 1344))) then
				v61 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (not v61 or (v61 < (0.2 + 0)) or ((4421 + 361) <= (4583 - 3384))) then
					v61 = 551.2 - (83 + 468);
				end
				v59 = 1808 - (1202 + 604);
			end
			if ((v59 == (9 - 7)) or ((8095 - 3231) < (5266 - 3364))) then
				v62 = (326 - (45 + 280)) / v61;
				v63 = v11.Persistent.Player.LastPowerUpdate;
				v59 = 3 + 0;
			end
			if (((4228 + 611) >= (1352 + 2348)) and (v59 == (0 + 0))) then
				v60 = v13:EssenceDeficit();
				if ((v60 == (0 + 0)) or ((1990 - 915) > (3829 - (340 + 1571)))) then
					return 0 + 0;
				end
				v59 = 1773 - (1733 + 39);
			end
			if (((1088 - 692) <= (4838 - (125 + 909))) and (v59 == (1951 - (1096 + 852)))) then
				return (v60 * v62) - (GetTime() - v63);
			end
		end
	end, 659 + 808);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v64)
		local v65 = v13:Essence();
		if ((v65 >= v64) or ((5953 - 1784) == (2122 + 65))) then
			return 512 - (409 + 103);
		end
		local v66 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		local v67 = (237 - (46 + 190)) / v66;
		local v68 = v11.Persistent.Player.LastPowerUpdate;
		return ((v64 - v65) * v67) - (GetTime() - v68);
	end, 1562 - (51 + 44));
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v69 = 0 + 0;
		local v70;
		local v71;
		local v72;
		local v73;
		while true do
			if (((2723 - (1114 + 203)) == (2132 - (228 + 498))) and (v69 == (1 + 1))) then
				v72 = (1 + 0) / v71;
				v73 = v11.Persistent.Player.LastPowerUpdate;
				v69 = 666 - (174 + 489);
			end
			if (((3988 - 2457) < (6176 - (830 + 1075))) and ((527 - (303 + 221)) == v69)) then
				return (v70 * v72) - (GetTime() - v73);
			end
			if (((1904 - (231 + 1038)) == (530 + 105)) and (v69 == (1163 - (171 + 991)))) then
				v71 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (((13900 - 10527) <= (9548 - 5992)) and (not v71 or (v71 < (0.2 - 0)))) then
					v71 = 0.2 + 0;
				end
				v69 = 6 - 4;
			end
			if ((v69 == (0 - 0)) or ((5304 - 2013) < (10139 - 6859))) then
				v70 = v13:EssenceDeficit();
				if (((5634 - (111 + 1137)) >= (1031 - (91 + 67))) and (v70 == (0 - 0))) then
					return 0 + 0;
				end
				v69 = 524 - (423 + 100);
			end
		end
	end, 11 + 1457);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v74)
		local v75 = 0 - 0;
		local v76;
		local v77;
		local v78;
		local v79;
		while true do
			if (((481 + 440) <= (1873 - (326 + 445))) and (v75 == (4 - 3))) then
				v77 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v78 = (2 - 1) / v77;
				v75 = 4 - 2;
			end
			if (((5417 - (530 + 181)) >= (1844 - (614 + 267))) and ((34 - (19 + 13)) == v75)) then
				v79 = v11.Persistent.Player.LastPowerUpdate;
				return ((v74 - v76) * v78) - (GetTime() - v79);
			end
			if ((v75 == (0 - 0)) or ((2237 - 1277) <= (2502 - 1626))) then
				v76 = v13:Essence();
				if ((v76 >= v74) or ((537 + 1529) == (1638 - 706))) then
					return 0 - 0;
				end
				v75 = 1813 - (1293 + 519);
			end
		end
	end, 2995 - 1527);
	local v38;
	v38 = v10.AddCoreOverride("Spell.IsCastable", function(v80, v81, v82, v83, v84, v85)
		local v86 = true;
		if (((12597 - 7772) < (9261 - 4418)) and v82) then
			local v142 = 0 - 0;
			local v143;
			while true do
				if ((v142 == (0 - 0)) or ((2054 + 1823) >= (926 + 3611))) then
					v143 = v84 or v14;
					v86 = v143:IsInRange(v82, v83);
					break;
				end
			end
		end
		local v87 = v38(v80, v81, v82, v83, v84, v85);
		if ((v80 == v16.Evoker.Augmentation.TipTheScales) or (v80 == v16.Evoker.Augmentation.Upheaval) or (v80 == v16.Evoker.Augmentation.FireBreath) or ((10025 - 5710) < (399 + 1327))) then
			return v87 and not v13:BuffUp(v80);
		else
			return v87;
		end
	end, 490 + 983);
	local v39;
	v39 = v10.AddCoreOverride("Spell.IsReady", function(v88, v89, v90, v91, v92, v93)
		local v94 = 0 + 0;
		local v95;
		local v96;
		while true do
			if ((v94 == (1097 - (709 + 387))) or ((5537 - (673 + 1185)) < (1812 - 1187))) then
				v96 = v39(v88, v89, v90, v91, v92, v93);
				if ((v88 == v16.Evoker.Augmentation.Eruption) or ((14851 - 10226) < (1039 - 407))) then
					return v96 and (v13:EssenceP() >= (2 + 0));
				elseif ((v88 == v16.Evoker.Augmentation.EbonMight) or ((63 + 20) > (2403 - 623))) then
					return v96 and not v13:IsCasting(v88);
				elseif (((135 + 411) <= (2146 - 1069)) and (v88 == v16.Evoker.Augmentation.Unravel)) then
					return v96 and v14:EnemyAbsorb();
				else
					return v96;
				end
				break;
			end
			if ((v94 == (0 - 0)) or ((2876 - (446 + 1434)) > (5584 - (1040 + 243)))) then
				v95 = true;
				if (((12147 - 8077) > (2534 - (559 + 1288))) and v90) then
					local v150 = 1931 - (609 + 1322);
					local v151;
					while true do
						if ((v150 == (454 - (13 + 441))) or ((2451 - 1795) >= (8722 - 5392))) then
							v151 = v92 or v14;
							v95 = v151:IsInRange(v90, v91);
							break;
						end
					end
				end
				v94 = 4 - 3;
			end
		end
	end, 55 + 1418);
	local v40;
	v40 = v10.AddCoreOverride("Player.IsMoving", function(v97)
		local v98 = v40(v97);
		return v98 and v13:BuffDown(v16.Evoker.Augmentation.HoverBuff);
	end, 5349 - 3876);
	local v41;
	v41 = v10.AddCoreOverride("Player.BuffRemains", function(v99, v100, v101, v102)
		if ((v100 == v100.Evoker.Augmentation.EbonMightSelfBuff) or ((886 + 1606) <= (147 + 188))) then
			return (v99:IsCasting(v100.Evoker.Augmentation.EbonMight) and (29 - 19)) or v41(v99, v100, v101, v102);
		else
			return v41(v99, v100, v101, v102);
		end
	end, 807 + 666);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v103, v104)
		local v105 = 0 - 0;
		local v106;
		local v107;
		local v108;
		while true do
			if (((2858 + 1464) >= (1425 + 1137)) and (v105 == (1 + 0))) then
				v108 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (4 + 0)) or (3 + 0);
				if (not v104 or ((4070 - (153 + 280)) >= (10886 - 7116))) then
					v104 = v108;
				end
				v105 = 2 + 0;
			end
			if ((v105 == (1 + 1)) or ((1245 + 1134) > (4155 + 423))) then
				return (1 + 0 + ((0.75 - 0) * (v104 - (1 + 0)))) * v106 * v107;
			end
			if ((v105 == (667 - (89 + 578))) or ((346 + 137) > (1544 - 801))) then
				v106 = v13:SpellHaste();
				v107 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (1049.8 - (572 + 477))) or (1 + 0);
				v105 = 1 + 0;
			end
		end
	end, 176 + 1297);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v109, v110)
		local v111 = 86 - (84 + 2);
		local v112;
		local v113;
		local v114;
		while true do
			if (((4043 - 1589) > (417 + 161)) and (v111 == (843 - (497 + 345)))) then
				v114 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (1 + 3)) or (1 + 2);
				if (((2263 - (605 + 728)) < (3181 + 1277)) and not v110) then
					v110 = v114;
				end
				v111 = 3 - 1;
			end
			if (((31 + 631) <= (3593 - 2621)) and (v111 == (0 + 0))) then
				v112 = v13:SpellHaste();
				v113 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (0.8 - 0)) or (1 + 0);
				v111 = 490 - (457 + 32);
			end
			if (((1855 + 2515) == (5772 - (832 + 570))) and (v111 == (2 + 0))) then
				return (1 + 0 + ((0.75 - 0) * (v110 - (1 + 0)))) * v112 * v113;
			end
		end
	end, 2263 - (588 + 208));
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v115, v116)
		local v117 = 0 - 0;
		local v118;
		local v119;
		local v120;
		while true do
			if ((v117 == (1800 - (884 + 916))) or ((9969 - 5207) <= (500 + 361))) then
				v118 = v13:SpellHaste();
				v119 = 654 - (232 + 421);
				v117 = 1890 - (1569 + 320);
			end
			if ((v117 == (1 + 1)) or ((269 + 1143) == (14368 - 10104))) then
				return ((606 - (316 + 289)) + ((0.75 - 0) * (v116 - (1 + 0)))) * v118 * v119;
			end
			if ((v117 == (1454 - (666 + 787))) or ((3593 - (360 + 65)) < (2013 + 140))) then
				v120 = ((v16.Evoker.Preservation.FontofMagic:IsAvailable()) and (258 - (79 + 175))) or (4 - 1);
				if (not v116 or ((3883 + 1093) < (4082 - 2750))) then
					v116 = v120;
				end
				v117 = 3 - 1;
			end
		end
	end, 2367 - (503 + 396));
	v10.AddCoreOverride("Player.EssenceP", function()
		local v121 = 181 - (92 + 89);
		local v122;
		while true do
			if (((8977 - 4349) == (2374 + 2254)) and (v121 == (0 + 0))) then
				v122 = v13:Essence();
				if ((not v13:IsCasting() and not v13:IsChanneling()) or ((211 - 157) == (55 + 340))) then
					return v122;
				elseif (((186 - 104) == (72 + 10)) and v13:IsCasting(v16.Evoker.Augmentation.Eruption) and v13:BuffDown(v16.Evoker.Augmentation.EssenceBurstBuff)) then
					return v122 - (1 + 1);
				else
					return v122;
				end
				break;
			end
		end
	end, 4485 - 3012);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v123 = 0 + 0;
		local v124;
		local v125;
		local v126;
		local v127;
		while true do
			if (((1 - 0) == v123) or ((1825 - (485 + 759)) < (652 - 370))) then
				v125 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (not v125 or (v125 < (1189.2 - (442 + 747))) or ((5744 - (832 + 303)) < (3441 - (88 + 858)))) then
					v125 = 0.2 + 0;
				end
				v123 = 2 + 0;
			end
			if (((48 + 1104) == (1941 - (766 + 23))) and (v123 == (14 - 11))) then
				return (v124 * v126) - (GetTime() - v127);
			end
			if (((2592 - 696) <= (9015 - 5593)) and (v123 == (0 - 0))) then
				v124 = v13:EssenceDeficit();
				if ((v124 == (1073 - (1036 + 37))) or ((702 + 288) > (3154 - 1534))) then
					return 0 + 0;
				end
				v123 = 1481 - (641 + 839);
			end
			if (((915 - (910 + 3)) == v123) or ((2235 - 1358) > (6379 - (1466 + 218)))) then
				v126 = (1 + 0) / v125;
				v127 = v11.Persistent.Player.LastPowerUpdate;
				v123 = 1151 - (556 + 592);
			end
		end
	end, 524 + 949);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v128)
		local v129 = 808 - (329 + 479);
		local v130;
		local v131;
		local v132;
		local v133;
		while true do
			if (((3545 - (174 + 680)) >= (6360 - 4509)) and ((1 - 0) == v129)) then
				v131 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v132 = (1 + 0) / v131;
				v129 = 741 - (396 + 343);
			end
			if (((0 + 0) == v129) or ((4462 - (29 + 1448)) >= (6245 - (135 + 1254)))) then
				v130 = v13:Essence();
				if (((16108 - 11832) >= (5579 - 4384)) and (v130 >= v128)) then
					return 0 + 0;
				end
				v129 = 1528 - (389 + 1138);
			end
			if (((3806 - (102 + 472)) <= (4426 + 264)) and (v129 == (2 + 0))) then
				v133 = v11.Persistent.Player.LastPowerUpdate;
				return ((v128 - v130) * v132) - (GetTime() - v133);
			end
		end
	end, 1374 + 99);
end;
return v0["Epix_Evoker_Evoker.lua"]();

