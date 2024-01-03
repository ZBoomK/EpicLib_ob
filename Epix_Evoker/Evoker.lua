local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((5057 - 1233) >= (650 - (187 + 54))) and (v5 == (781 - (162 + 618)))) then
			return v6(...);
		end
		if (((1463 + 624) == (1391 + 696)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((5722 - 2318) > (353 + 4150))) then
				return v1(v4, ...);
			end
			v5 = 1637 - (1373 + 263);
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
	if (not v16.Evoker or ((4506 - (451 + 549)) <= (414 + 895))) then
		v16.Evoker = {};
	end
	v16.Evoker.Commons = {TailSwipe=v16(574209 - 205239, nil, 1 - 0),WingBuffet=v16(358598 - (746 + 638), nil, 1 + 1),AzureStrike=v16(551089 - 188120, nil, 344 - (218 + 123)),BlessingoftheBronze=v16(365923 - (1535 + 46), nil, 4 + 0),DeepBreath=v16(51689 + 305521, nil, 565 - (306 + 254)),Disintegrate=v16(22101 + 334894, nil, 11 - 5),EmeraldBlossom=v16(357380 - (899 + 568), nil, 5 + 2),FireBreath=v17(232 - 136, 357811 - (268 + 335), 382556 - (60 + 230)),LivingFlame=v16(362041 - (426 + 146), nil, 1 + 7),OppressingRoar=v16(373504 - (282 + 1174), nil, 913 - (569 + 242)),Expunge=v16(1053102 - 687517, nil, 6 + 97),Sleepwalk=v16(361830 - (706 + 318), nil, 1355 - (721 + 530)),RenewingBlaze=v16(375619 - (945 + 326), nil, 262 - 157),Hover=v16(318793 + 39474, nil, 806 - (271 + 429)),AncientFlame=v16(339874 + 30116, nil, 1509 - (1408 + 92)),BlastFurnace=v16(376596 - (461 + 625), nil, 1298 - (993 + 295)),LeapingFlames=v16(19210 + 350729, nil, 1182 - (418 + 753)),ObsidianScales=v16(138599 + 225317, nil, 2 + 10),ScarletAdaptation=v16(108941 + 263528, nil, 4 + 9),SourceofMagic=v16(369988 - (406 + 123), nil, 1783 - (1749 + 20)),TipTheScales=v16(88017 + 282536, nil, 1337 - (1249 + 73)),Unravel=v16(131445 + 236987, nil, 1161 - (466 + 679)),VerdantEmbrace=v16(868362 - 507367, nil, 48 - 31),AncientFlameBuff=v16(377483 - (106 + 1794), nil, 6 + 12),BlessingoftheBronzeBuff=v16(96498 + 285250, nil, 55 - 36),FireBreathDebuff=v16(967300 - 610091, nil, 134 - (4 + 110)),HoverBuff=v16(358851 - (57 + 527), nil, 1448 - (41 + 1386)),LeapingFlamesBuff=v16(371004 - (17 + 86), nil, 15 + 7),PowerInfusionBuff=v16(22434 - 12374, nil, 66 - 43),ScarletAdaptationBuff=v16(372636 - (122 + 44), nil, 40 - 16),SourceofMagicBuff=v16(1225669 - 856210, nil, 21 + 4),SpoilsofNeltharusCrit=v16(55240 + 326714, nil, 52 - 26),SpoilsofNeltharusHaste=v16(382020 - (30 + 35), nil, 19 + 8),SpoilsofNeltharusMastery=v16(383213 - (1043 + 214), nil, 105 - 77),SpoilsofNeltharusVers=v16(383169 - (323 + 889), nil, 77 - 48),Quell=v16(351918 - (361 + 219), nil, 350 - (53 + 267)),Pool=v16(225900 + 774010, nil, 444 - (15 + 398))};
	v16.Evoker.Augmentation = v19(v16.Evoker.Commons, {BlackAttunement=v16(404246 - (18 + 964), nil, 120 - 88),BronzeAttunement=v16(233476 + 169789, nil, 21 + 12),BlisteringScales=v16(361677 - (20 + 830), nil, 27 + 7),BreathofEons=v16(403757 - (116 + 10), nil, 3 + 32),DreamofSpring=v16(415707 - (542 + 196), nil, 76 - 40),EbonMight=v16(115391 + 279761, nil, 19 + 18),Eruption=v16(142245 + 252915, nil, 99 - 61),FontofMagic=v16(1046238 - 638155, nil, 1590 - (1126 + 425)),InterwovenThreads=v16(413118 - (118 + 287), nil, 156 - 116),Prescience=v16(410432 - (118 + 1003), nil, 119 - 78),PupilofAlexstrasza=v16(408191 - (142 + 235), nil, 190 - 148),TimeSkip=v16(88119 + 316858, nil, 1020 - (553 + 424)),Upheaval=v16(771684 - 363592, nil, 39 + 5),BlackAttunementBuff=v16(400031 + 3233, nil, 27 + 18),BlisteringScalesBuff=v16(153384 + 207443, nil, 27 + 19),BronzeAttunementBuff=v16(874236 - 470971, nil, 130 - 83),EbonMightOtherBuff=v16(884761 - 489609, nil, 14 + 34),EbonMightSelfBuff=v16(1910330 - 1515034, nil, 802 - (239 + 514)),EssenceBurstBuff=v16(137769 + 254499, nil, 1379 - (797 + 532)),PrescienceBuff=v16(297978 + 112111, nil, 85 + 165),TemporalWoundDebuff=v16(962979 - 553419, nil, 1253 - (373 + 829))});
	v16.Evoker.Devastation = v19(v16.Evoker.Commons, {Animosity=v16(376528 - (476 + 255), nil, 1182 - (369 + 761)),ArcaneVigor=v16(223489 + 162853, nil, 96 - 43),Burnout=v16(712144 - 336343, nil, 292 - (64 + 174)),Catalyze=v16(55016 + 331267, nil, 81 - 26),Causality=v16(376113 - (144 + 192), nil, 272 - (42 + 174)),ChargedBlast=v16(278299 + 92156, nil, 48 + 9),Dragonrage=v16(159353 + 215734, nil, 1562 - (363 + 1141)),EngulfingBlaze=v16(372417 - (1183 + 397), nil, 179 - 120),EssenceAttunement=v16(275422 + 100300, nil, 45 + 15),EternitySurge=v17(2072 - (1913 + 62), 226137 + 132936, 1012358 - 629947),EternitysSpan=v16(377690 - (565 + 1368), nil, 229 - 168),EventHorizon=v16(412825 - (1477 + 184), nil, 83 - 21),EverburningFlame=v16(345512 + 25307, nil, 919 - (564 + 292)),EyeofInfinity=v16(637329 - 267954, nil, 192 - 128),FeedtheFlames=v16(370150 - (244 + 60), nil, 50 + 15),Firestorm=v16(369323 - (41 + 435), nil, 1067 - (938 + 63)),FontofMagic=v16(289007 + 86776, nil, 1192 - (936 + 189)),ImminentDestruction=v16(122025 + 248756, nil, 1681 - (1565 + 48)),Pyre=v16(220656 + 136555, nil, 1207 - (782 + 356)),RagingInferno=v16(405926 - (176 + 91), nil, 182 - 112),RubyEmbers=v16(539321 - 173384, nil, 1163 - (975 + 117)),Scintillation=v16(372696 - (157 + 1718), nil, 59 + 13),ShatteringStar=v16(1315076 - 944624, nil, 249 - 176),Snapfire=v16(371801 - (697 + 321), nil, 201 - 127),Tyranny=v16(798479 - 421591, nil, 172 - 97),Volatility=v16(143666 + 225423, nil, 142 - 66),BlazingShardsBuff=v16(1098684 - 688836, nil, 1304 - (322 + 905)),BurnoutBuff=v16(376413 - (602 + 9), nil, 1267 - (449 + 740)),ChargedBlastBuff=v16(371326 - (826 + 46), nil, 1026 - (245 + 702)),EmeraldTranceBuff=v16(1340312 - 916157, nil, XXXXX),EssenceBurstBuff=v16(115607 + 244011, nil, 1978 - (260 + 1638)),IridescenceBlueBuff=v17(538 - (382 + 58), 1239595 - 853196, 331859 + 67511),IridescenceRedBuff=v16(798475 - 412122, nil, 240 - 159),LimitlessPotentialBuff=v16(395607 - (902 + 303), nil, 179 - 97),PowerSwellBuff=v16(907644 - 530794, nil, 8 + 75),SnapfireBuff=v16(372508 - (1121 + 569), nil, 298 - (22 + 192)),LivingFlameDebuff=v16(362183 - (483 + 200), nil, 1548 - (1404 + 59))});
	v16.Evoker.Preservation = v19(v16.Evoker.Commons, {DreamBreath=v17(270 - 171, 478388 - 122452, 383379 - (468 + 297)),DreamFlight=v16(360378 - (334 + 228), nil, 289 - 203),Echo=v16(844514 - 480171, nil, 157 - 70),MassReturn=v16(102562 + 258616, nil, 324 - (141 + 95)),Spiritbloom=v17(99 + 1, 945242 - 578016, 920052 - 537321),Stasis=v16(86794 + 283743, nil, 243 - 154),StasisReactivate=v16(260504 + 110060, nil, 47 + 43),TemporalAnomaly=v16(526487 - 152626, nil, 54 + 37),TimeDilation=v16(357333 - (92 + 71), nil, 46 + 46),Reversion=v17(169 - 68, 366920 - (574 + 191), 303026 + 64338),Rewind=v16(910763 - 547229, nil, 48 + 45),FontofMagic=v16(376632 - (254 + 595), nil, 193 - (55 + 71)),CauterizingFlame=v16(493036 - 118785, nil, 2733 - (573 + 1217)),EssenceBurstBuff=v16(1022744 - 653445, nil, 8 + 86),StasisBuff=v16(597122 - 226560, nil, 1034 - (714 + 225))});
	if (((8635 - 5680) == (4119 - 1164)) and not v18.Evoker) then
		v18.Evoker = {};
	end
	v18.Evoker.Commons = {Healthstone=v18(597 + 4915),CrimsonAspirantsBadgeofFerocity=v18(291687 - 90238, {(61 - (25 + 23)),(1900 - (927 + 959))}),BelorrelostheSuncaller=v18(698355 - 491183, {(24 - 11),(33 - 19)}),DragonfireBombDispenser=v18(202895 - (175 + 110), {(64 - 51),(39 - 25)}),NymuesUnravelingSpindle=v18(150863 + 57752, {(10 + 3),(13 + 1)}),Dreambinder=v18(209149 - (43 + 490), {(61 - 45)}),Iridal=v18(209180 - (240 + 619), {(25 - 9)}),KharnalexTheFirstLight=v18(12940 + 182579),SpoilsofNeltharus=v18(195517 - (1344 + 400), {(11 + 2),(59 - 45)}),ShadowedOrbofTorment=v18(602147 - 415719, {(419 - (183 + 223)),(10 + 4)}),RefreshingHealingPotion=v18(68874 + 122506)};
	v18.Evoker.Devastation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Preservation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Augmentation = v19(v18.Evoker.Commons, {});
	if (not v21.Evoker or ((3240 - (10 + 327)) == (1042 + 453))) then
		v21.Evoker = {};
	end
	v21.Evoker.Commons = {Healthstone=v21(375 - (118 + 220)),AzureStrikeMouseover=v21(13 + 25),DeepBreathCursor=v21(488 - (108 + 341)),CauterizingFlameFocus=v21(18 + 22),EmeraldBlossomFocus=v21(173 - 132),FireBreathMacro=v21(1535 - (711 + 782)),LivingFlameFocus=v21(82 - 39),QuellMouseover=v21(513 - (270 + 199)),VerdantEmbraceFocus=v21(4 + 6),RefreshingHealingPotion=v21(1852 - (580 + 1239)),ExpungeMouseover=v21(100 - 66),ExpungeFocus=v21(34 + 1),SleepwalkMouseover=v21(2 + 34),VerdantEmbracePlayer=v21(13 + 16),EmeraldBlossomPlayer=v21(80 - 49),SourceofMagicFocus=v21(14 + 8),SourceofMagicName=v21(1190 - (645 + 522))};
	v21.Evoker.Devastation = v19(v21.Evoker.Commons, {EternitySurgeMacro=v21(1801 - (1010 + 780))});
	v21.Evoker.Preservation = v19(v21.Evoker.Commons, {DreamBreathMacro=v21(12 + 0),DreamFlightCursor=v21(61 - 48),EchoFocus=v21(41 - 27),SpiritbloomFocus=v21(1851 - (1045 + 791)),TimeDilationFocus=v21(40 - 24),TipTheScalesDreamBreath=v21(25 - 8),TipTheScalesSpiritbloom=v21(523 - (351 + 154)),ReversionFocus=v21(1593 - (1281 + 293)),EchoMouseover=v21(312 - (28 + 238)),LivingFlameMouseover=v21(104 - 57)});
	v21.Evoker.Augmentation = v19(v21.Evoker.Commons, {BlisteringScalesFocus=v21(1579 - (1381 + 178)),BlisteringScalesName=v21(20 + 1),PrescienceName1=v21(20 + 4),PrescienceName2=v21(11 + 14),PrescienceName3=v21(89 - 63),PrescienceName4=v21(14 + 13),PrescienceFocus=v21(498 - (381 + 89)),BreathofEonsCursor=v21(40 + 5)});
	v20.Commons.Evoker = {};
	local v35 = v20.Commons.Evoker;
	v35.FirestormTracker = {};
	v10:RegisterForEvent(function(v42, v43, v44)
		if (((3075 + 1471) >= (3897 - 1622)) and (v43 ~= "player")) then
			return;
		end
		if (((1975 - (1074 + 82)) >= (47 - 25)) and (v44 == "ESSENCE")) then
			v11.Persistent.Player.LastPowerUpdate = GetTime();
		end
	end, "UNIT_POWER_UPDATE");
	v10:RegisterForSelfCombatEvent(function(v45, v45, v45, v45, v45, v45, v45, v46, v45, v45, v45, v47)
		if (((4946 - (214 + 1570)) == (4617 - (990 + 465))) and (v47 == (152272 + 217102))) then
			v35.FirestormTracker[v46] = GetTime();
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForCombatEvent(function(v48, v48, v48, v48, v48, v48, v48, v49)
		if (v35.FirestormTracker[v49] or ((1031 + 1338) > (4307 + 122))) then
			v35.FirestormTracker[v49] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v50, v51, v52, v53, v54, v55)
		local v56 = true;
		if (((16115 - 12020) >= (4909 - (1668 + 58))) and v52) then
			local v138 = 626 - (512 + 114);
			local v139;
			while true do
				if ((v138 == (0 - 0)) or ((7671 - 3960) < (3507 - 2499))) then
					v139 = v54 or v14;
					v56 = v139:IsInRange(v52, v53);
					break;
				end
			end
		end
		local v57 = v37(v50, v51, v52, v53, v54, v55);
		if ((v50 == v16.Evoker.Devastation.Firestorm) or ((489 + 560) <= (170 + 736))) then
			return v57 and not v13:IsCasting(v50);
		elseif (((3924 + 589) > (9194 - 6468)) and (v50 == v16.Evoker.Devastation.TipTheScales)) then
			return v57 and not v13:BuffUp(v50);
		else
			return v57;
		end
	end, 3461 - (109 + 1885));
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v58 = 1469 - (1269 + 200);
		local v59;
		local v60;
		local v61;
		local v62;
		while true do
			if ((v58 == (5 - 2)) or ((2296 - (98 + 717)) >= (3484 - (802 + 24)))) then
				return (v59 * v61) - (GetTime() - v62);
			end
			if ((v58 == (0 - 0)) or ((4066 - 846) == (202 + 1162))) then
				v59 = v13:EssenceDeficit();
				if ((v59 == (0 + 0)) or ((174 + 880) > (732 + 2660))) then
					return 0 - 0;
				end
				v58 = 3 - 2;
			end
			if ((v58 == (1 + 1)) or ((276 + 400) >= (1355 + 287))) then
				v61 = (1 + 0) / v60;
				v62 = v11.Persistent.Player.LastPowerUpdate;
				v58 = 2 + 1;
			end
			if (((5569 - (797 + 636)) > (11638 - 9241)) and (v58 == (1620 - (1427 + 192)))) then
				v60 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (not v60 or (v60 < (0.2 + 0)) or ((10062 - 5728) == (3816 + 429))) then
					v60 = 0.2 + 0;
				end
				v58 = 328 - (192 + 134);
			end
		end
	end, 2743 - (316 + 960));
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v63)
		local v64 = 0 + 0;
		local v65;
		local v66;
		local v67;
		local v68;
		while true do
			if ((v64 == (1 + 0)) or ((3953 + 323) <= (11587 - 8556))) then
				v66 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v67 = (552 - (83 + 468)) / v66;
				v64 = 1808 - (1202 + 604);
			end
			if ((v64 == (0 - 0)) or ((7958 - 3176) <= (3319 - 2120))) then
				v65 = v13:Essence();
				if ((v65 >= v63) or ((5189 - (45 + 280)) < (1836 + 66))) then
					return 0 + 0;
				end
				v64 = 1 + 0;
			end
			if (((2678 + 2161) >= (651 + 3049)) and (v64 == (3 - 1))) then
				v68 = v11.Persistent.Player.LastPowerUpdate;
				return ((v63 - v65) * v67) - (GetTime() - v68);
			end
		end
	end, 3378 - (340 + 1571));
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v69 = 0 + 0;
		local v70;
		local v71;
		local v72;
		local v73;
		while true do
			if ((v69 == (1774 - (1733 + 39))) or ((2953 - 1878) > (2952 - (125 + 909)))) then
				v72 = (1949 - (1096 + 852)) / v71;
				v73 = v11.Persistent.Player.LastPowerUpdate;
				v69 = 2 + 1;
			end
			if (((564 - 168) <= (3690 + 114)) and (v69 == (513 - (409 + 103)))) then
				v71 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (not v71 or (v71 < (236.2 - (46 + 190))) or ((4264 - (51 + 44)) == (617 + 1570))) then
					v71 = 1317.2 - (1114 + 203);
				end
				v69 = 728 - (228 + 498);
			end
			if (((305 + 1101) == (777 + 629)) and (v69 == (666 - (174 + 489)))) then
				return (v70 * v72) - (GetTime() - v73);
			end
			if (((3988 - 2457) < (6176 - (830 + 1075))) and (v69 == (524 - (303 + 221)))) then
				v70 = v13:EssenceDeficit();
				if (((1904 - (231 + 1038)) == (530 + 105)) and (v70 == (1162 - (171 + 991)))) then
					return 0 - 0;
				end
				v69 = 2 - 1;
			end
		end
	end, 3663 - 2195);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v74)
		local v75 = 0 + 0;
		local v76;
		local v77;
		local v78;
		local v79;
		while true do
			if (((11823 - 8450) <= (10258 - 6702)) and (v75 == (1 - 0))) then
				v77 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v78 = (3 - 2) / v77;
				v75 = 1250 - (111 + 1137);
			end
			if ((v75 == (160 - (91 + 67))) or ((9794 - 6503) < (819 + 2461))) then
				v79 = v11.Persistent.Player.LastPowerUpdate;
				return ((v74 - v76) * v78) - (GetTime() - v79);
			end
			if (((4909 - (423 + 100)) >= (7 + 866)) and (v75 == (0 - 0))) then
				v76 = v13:Essence();
				if (((481 + 440) <= (1873 - (326 + 445))) and (v76 >= v74)) then
					return 0 - 0;
				end
				v75 = 2 - 1;
			end
		end
	end, 3426 - 1958);
	local v38;
	v38 = v10.AddCoreOverride("Spell.IsCastable", function(v80, v81, v82, v83, v84, v85)
		local v86 = true;
		if (((5417 - (530 + 181)) >= (1844 - (614 + 267))) and v82) then
			local v140 = 32 - (19 + 13);
			local v141;
			while true do
				if ((v140 == (0 - 0)) or ((2237 - 1277) <= (2502 - 1626))) then
					v141 = v84 or v14;
					v86 = v141:IsInRange(v82, v83);
					break;
				end
			end
		end
		local v87 = v38(v80, v81, v82, v83, v84, v85);
		if ((v80 == v16.Evoker.Augmentation.TipTheScales) or (v80 == v16.Evoker.Augmentation.Upheaval) or (v80 == v16.Evoker.Augmentation.FireBreath) or ((537 + 1529) == (1638 - 706))) then
			return v87 and not v13:BuffUp(v80);
		else
			return v87;
		end
	end, 3054 - 1581);
	local v39;
	v39 = v10.AddCoreOverride("Spell.IsReady", function(v88, v89, v90, v91, v92, v93)
		local v94 = true;
		if (((6637 - (1293 + 519)) < (9881 - 5038)) and v90) then
			local v142 = v92 or v14;
			v94 = v142:IsInRange(v90, v91);
		end
		local v95 = v39(v88, v89, v90, v91, v92, v93);
		if ((v88 == v16.Evoker.Augmentation.Eruption) or ((10122 - 6245) >= (8675 - 4138))) then
			return v95 and (v13:EssenceP() >= (8 - 6));
		elseif ((v88 == v16.Evoker.Augmentation.EbonMight) or ((10164 - 5849) < (915 + 811))) then
			return v95 and not v13:IsCasting(v88);
		elseif ((v88 == v16.Evoker.Augmentation.Unravel) or ((751 + 2928) < (1451 - 826))) then
			return v95 and v14:EnemyAbsorb();
		else
			return v95;
		end
	end, 341 + 1132);
	local v40;
	v40 = v10.AddCoreOverride("Player.IsMoving", function(v96)
		local v97 = v40(v96);
		return v97 and v13:BuffDown(v16.Evoker.Augmentation.HoverBuff);
	end, 490 + 983);
	local v41;
	v41 = v10.AddCoreOverride("Player.BuffRemains", function(v98, v99, v100, v101)
		if ((v99 == v99.Evoker.Augmentation.EbonMightSelfBuff) or ((2891 + 1734) < (1728 - (709 + 387)))) then
			return (v98:IsCasting(v99.Evoker.Augmentation.EbonMight) and (1868 - (673 + 1185))) or v41(v98, v99, v100, v101);
		else
			return v41(v98, v99, v100, v101);
		end
	end, 4271 - 2798);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v102, v103)
		local v104 = 0 - 0;
		local v105;
		local v106;
		local v107;
		while true do
			if ((v104 == (0 - 0)) or ((60 + 23) > (1331 + 449))) then
				v105 = v13:SpellHaste();
				v106 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (0.8 - 0)) or (1 + 0);
				v104 = 1 - 0;
			end
			if (((1071 - 525) <= (2957 - (446 + 1434))) and (v104 == (1284 - (1040 + 243)))) then
				v107 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (11 - 7)) or (1850 - (559 + 1288));
				if (not v103 or ((2927 - (609 + 1322)) > (4755 - (13 + 441)))) then
					v103 = v107;
				end
				v104 = 7 - 5;
			end
			if (((10660 - 6590) > (3421 - 2734)) and (v104 == (1 + 1))) then
				return ((3 - 2) + ((0.75 + 0) * (v103 - (1 + 0)))) * v105 * v106;
			end
		end
	end, 4371 - 2898);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v108, v109)
		local v110 = 0 + 0;
		local v111;
		local v112;
		local v113;
		while true do
			if ((v110 == (1 - 0)) or ((434 + 222) >= (1853 + 1477))) then
				v113 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (3 + 1)) or (3 + 0);
				if (not v109 or ((2439 + 53) <= (768 - (153 + 280)))) then
					v109 = v113;
				end
				v110 = 5 - 3;
			end
			if (((3881 + 441) >= (1012 + 1550)) and (v110 == (2 + 0))) then
				return (1 + 0 + ((0.75 + 0) * (v109 - (1 - 0)))) * v111 * v112;
			end
			if ((v110 == (0 + 0)) or ((4304 - (89 + 578)) >= (2694 + 1076))) then
				v111 = v13:SpellHaste();
				v112 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (0.8 - 0)) or (1050 - (572 + 477));
				v110 = 1 + 0;
			end
		end
	end, 881 + 586);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v114, v115)
		local v116 = v13:SpellHaste();
		local v117 = 1 + 0;
		local v118 = ((v16.Evoker.Preservation.FontofMagic:IsAvailable()) and (90 - (84 + 2))) or (4 - 1);
		if (not v115 or ((1714 + 665) > (5420 - (497 + 345)))) then
			v115 = v118;
		end
		return (1 + 0 + ((0.75 + 0) * (v115 - (1334 - (605 + 728))))) * v116 * v117;
	end, 1048 + 420);
	v10.AddCoreOverride("Player.EssenceP", function()
		local v119 = v13:Essence();
		if ((not v13:IsCasting() and not v13:IsChanneling()) or ((1073 - 590) > (35 + 708))) then
			return v119;
		elseif (((9072 - 6618) > (522 + 56)) and v13:IsCasting(v16.Evoker.Augmentation.Eruption) and v13:BuffDown(v16.Evoker.Augmentation.EssenceBurstBuff)) then
			return v119 - (5 - 3);
		else
			return v119;
		end
	end, 1113 + 360);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v120 = 489 - (457 + 32);
		local v121;
		local v122;
		local v123;
		local v124;
		while true do
			if (((395 + 535) < (5860 - (832 + 570))) and (v120 == (0 + 0))) then
				v121 = v13:EssenceDeficit();
				if (((173 + 489) <= (3439 - 2467)) and (v121 == (0 + 0))) then
					return 796 - (588 + 208);
				end
				v120 = 2 - 1;
			end
			if (((6170 - (884 + 916)) == (9148 - 4778)) and (v120 == (2 + 0))) then
				v123 = (654 - (232 + 421)) / v122;
				v124 = v11.Persistent.Player.LastPowerUpdate;
				v120 = 1892 - (1569 + 320);
			end
			if ((v120 == (1 + 0)) or ((905 + 3857) <= (2901 - 2040))) then
				v122 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (not v122 or (v122 < (605.2 - (316 + 289))) or ((3696 - 2284) == (197 + 4067))) then
					v122 = 1453.2 - (666 + 787);
				end
				v120 = 427 - (360 + 65);
			end
			if ((v120 == (3 + 0)) or ((3422 - (79 + 175)) < (3394 - 1241))) then
				return (v121 * v123) - (GetTime() - v124);
			end
		end
	end, 1150 + 323);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v125)
		local v126 = 0 - 0;
		local v127;
		local v128;
		local v129;
		local v130;
		while true do
			if ((v126 == (1 - 0)) or ((5875 - (503 + 396)) < (1513 - (92 + 89)))) then
				v128 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v129 = (1 - 0) / v128;
				v126 = 2 + 0;
			end
			if (((2740 + 1888) == (18123 - 13495)) and ((0 + 0) == v126)) then
				v127 = v13:Essence();
				if ((v127 >= v125) or ((122 - 68) == (345 + 50))) then
					return 0 + 0;
				end
				v126 = 2 - 1;
			end
			if (((11 + 71) == (124 - 42)) and (v126 == (1246 - (485 + 759)))) then
				v130 = v11.Persistent.Player.LastPowerUpdate;
				return ((v125 - v127) * v129) - (GetTime() - v130);
			end
		end
	end, 3408 - 1935);
end;
return v0["Epix_Evoker_Evoker.lua"]();

