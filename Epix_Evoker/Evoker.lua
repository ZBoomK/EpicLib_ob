local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1551 - (226 + 1325);
	local v6;
	while true do
		if (((2517 + 645) <= (2412 + 1029)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if (((10036 - 5330) > (7445 - 3016)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((4490 - (1373 + 263)) < (5095 - (451 + 549))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	if (not v16.Evoker or ((1646 - 588) >= (2019 - 817))) then
		v16.Evoker = {};
	end
	v16.Evoker.Commons = {TailSwipe=v16(370354 - (746 + 638), nil, 1 + 0),WingBuffet=v16(542351 - 185137, nil, 343 - (218 + 123)),AzureStrike=v16(364550 - (1535 + 46), nil, 3 + 0),BlessingoftheBronze=v16(52721 + 311621, nil, 564 - (306 + 254)),DeepBreath=v16(22114 + 335096, nil, 9 - 4),Disintegrate=v16(358462 - (899 + 568), nil, 4 + 2),EmeraldBlossom=v16(861275 - 505362, nil, 610 - (268 + 335)),FireBreath=v17(386 - (60 + 230), 357780 - (426 + 146), 45793 + 336473),LivingFlame=v16(362925 - (282 + 1174), nil, 819 - (569 + 242)),OppressingRoar=v16(1071719 - 699671, nil, 6 + 96),Expunge=v16(366609 - (706 + 318), nil, 1354 - (721 + 530)),Sleepwalk=v16(362077 - (945 + 326), nil, 259 - 155),RenewingBlaze=v16(333102 + 41246, nil, 805 - (271 + 429)),Hover=v16(329105 + 29162, nil, 1606 - (1408 + 92)),AncientFlame=v16(371076 - (461 + 625), nil, 1297 - (993 + 295)),BlastFurnace=v16(19499 + 356011, nil, 1181 - (418 + 753)),LeapingFlames=v16(140893 + 229046, nil, 2 + 9),ObsidianScales=v16(106440 + 257476, nil, 4 + 8),ScarletAdaptation=v16(372998 - (406 + 123), nil, 1782 - (1749 + 20)),SourceofMagic=v16(87757 + 281702, nil, 1336 - (1249 + 73)),TipTheScales=v16(132202 + 238351, nil, 1160 - (466 + 679)),Unravel=v16(886251 - 517819, nil, 45 - 29),VerdantEmbrace=v16(362895 - (106 + 1794), nil, 6 + 11),AncientFlameBuff=v16(94940 + 280643, nil, 52 - 34),BlessingoftheBronzeBuff=v16(1033750 - 652002, nil, 133 - (4 + 110)),FireBreathDebuff=v16(357793 - (57 + 527), nil, 1447 - (41 + 1386)),HoverBuff=v16(358370 - (17 + 86), nil, 15 + 6),LeapingFlamesBuff=v16(827151 - 456250, nil, 63 - 41),PowerInfusionBuff=v16(10226 - (122 + 44), nil, 39 - 16),ScarletAdaptationBuff=v16(1235658 - 863188, nil, 20 + 4),SourceofMagicBuff=v16(53432 + 316027, nil, 50 - 25),SpoilsofNeltharusCrit=v16(382019 - (30 + 35), nil, 18 + 8),SpoilsofNeltharusHaste=v16(383212 - (1043 + 214), nil, 102 - 75),SpoilsofNeltharusMastery=v16(383168 - (323 + 889), nil, 75 - 47),SpoilsofNeltharusVers=v16(382537 - (361 + 219), nil, 349 - (53 + 267)),Quell=v16(79375 + 271963, nil, 443 - (15 + 398)),Pool=v16(1000892 - (18 + 964), nil, 116 - 85)};
	v16.Evoker.Augmentation = v19(v16.Evoker.Commons, {BlackAttunement=v16(233475 + 169789, nil, 21 + 11),BronzeAttunement=v16(404115 - (20 + 830), nil, 26 + 7),BlisteringScales=v16(360953 - (116 + 10), nil, 3 + 31),BreathofEons=v16(404369 - (542 + 196), nil, 75 - 40),DreamofSpring=v16(121178 + 293791, nil, 19 + 17),EbonMight=v16(142242 + 252910, nil, 97 - 60),Eruption=v16(1013107 - 617947, nil, 1589 - (1126 + 425)),FontofMagic=v16(408488 - (118 + 287), nil, 152 - 113),InterwovenThreads=v16(413834 - (118 + 1003), nil, 117 - 77),Prescience=v16(409688 - (142 + 235), nil, 185 - 144),PupilofAlexstrasza=v16(88736 + 319078, nil, 1019 - (553 + 424)),TimeSkip=v16(765794 - 360817, nil, 38 + 5),Upheaval=v16(404820 + 3272, nil, 26 + 18),BlackAttunementBuff=v16(171424 + 231840, nil, 26 + 19),BlisteringScalesBuff=v16(782234 - 421407, nil, 127 - 81),BronzeAttunementBuff=v16(902927 - 499662, nil, 14 + 33),EbonMightOtherBuff=v16(1909634 - 1514482, nil, 801 - (239 + 514)),EbonMightSelfBuff=v16(138833 + 256463, nil, 1378 - (797 + 532)),EssenceBurstBuff=v16(285028 + 107240, nil, 17 + 33),PrescienceBuff=v16(964223 - 554134, nil, 1452 - (373 + 829)),TemporalWoundDebuff=v16(410291 - (476 + 255), nil, 1181 - (369 + 761))});
	v16.Evoker.Devastation = v19(v16.Evoker.Commons, {Animosity=v16(217389 + 158408, nil, 93 - 41),ArcaneVigor=v16(732119 - 345777, nil, 291 - (64 + 174)),Burnout=v16(53523 + 322278, nil, 79 - 25),Catalyze=v16(386619 - (144 + 192), nil, 271 - (42 + 174)),Causality=v16(282297 + 93480, nil, 47 + 9),ChargedBlast=v16(157385 + 213070, nil, 1561 - (363 + 1141)),Dragonrage=v16(376667 - (1183 + 397), nil, 176 - 118),EngulfingBlaze=v16(271841 + 98996, nil, 45 + 14),EssenceAttunement=v16(377697 - (1913 + 62), nil, 38 + 22),EternitySurge=v17(256 - 159, 361006 - (565 + 1368), 1438146 - 1055735),EternitysSpan=v16(377418 - (1477 + 184), nil, 82 - 21),EventHorizon=v16(383103 + 28061, nil, 918 - (564 + 292)),EverburningFlame=v16(639820 - 269001, nil, 189 - 126),EyeofInfinity=v16(369679 - (244 + 60), nil, 50 + 14),FeedtheFlames=v16(370322 - (41 + 435), nil, 1066 - (938 + 63)),Firestorm=v16(283672 + 85175, nil, 1191 - (936 + 189)),FontofMagic=v16(123671 + 252112, nil, 1680 - (1565 + 48)),ImminentDestruction=v16(229038 + 141743, nil, 1206 - (782 + 356)),Pyre=v16(357478 - (176 + 91), nil, 179 - 110),RagingInferno=v16(597864 - 192205, nil, 1162 - (975 + 117)),RubyEmbers=v16(367812 - (157 + 1718), nil, 58 + 13),Scintillation=v16(1316386 - 945565, nil, 245 - 173),ShatteringStar=v16(371470 - (697 + 321), nil, 198 - 125),Snapfire=v16(785544 - 414761, nil, 170 - 96),Tyranny=v16(146702 + 230186, nil, 140 - 65),Volatility=v16(989421 - 620332, nil, 1303 - (322 + 905)),BlazingShardsBuff=v16(410459 - (602 + 9), nil, 1266 - (449 + 740)),BurnoutBuff=v16(376674 - (826 + 46), nil, 1025 - (245 + 702)),ChargedBlastBuff=v16(1170619 - 800165, nil, 26 + 53),EmeraldTranceBuff=v16(426053 - (260 + 1638), nil, XXXXX),EssenceBurstBuff=v16(360058 - (382 + 58), nil, 256 - 176),IridescenceBlueBuff=v17(82 + 16, 798570 - 412171, 1187170 - 787800),IridescenceRedBuff=v16(387558 - (902 + 303), nil, 177 - 96),LimitlessPotentialBuff=v16(949918 - 555516, nil, 8 + 74),PowerSwellBuff=v16(378540 - (1121 + 569), nil, 297 - (22 + 192)),SnapfireBuff=v16(371501 - (483 + 200), nil, 1547 - (1404 + 59)),LivingFlameDebuff=v16(989330 - 627830, nil, 114 - 29)});
	v16.Evoker.Preservation = v19(v16.Evoker.Commons, {DreamBreath=v17(864 - (468 + 297), 356498 - (334 + 228), 1290552 - 907938),DreamFlight=v16(834021 - 474205, nil, 155 - 69),Echo=v16(103461 + 260882, nil, 323 - (141 + 95)),MassReturn=v16(354789 + 6389, nil, 226 - 138),Spiritbloom=v17(240 - 140, 86018 + 281208, 1048636 - 665905),Stasis=v16(260485 + 110052, nil, 47 + 42),StasisReactivate=v16(521843 - 151279, nil, 54 + 36),TemporalAnomaly=v16(374024 - (92 + 71), nil, 45 + 46),TimeDilation=v16(600509 - 243339, nil, 857 - (574 + 191)),Reversion=v17(84 + 17, 917329 - 551174, 187646 + 179718),Rewind=v16(364383 - (254 + 595), nil, 219 - (55 + 71)),FontofMagic=v16(495053 - 119270, nil, 1857 - (573 + 1217)),EssenceBurstBuff=v16(1022744 - 653445, nil, 8 + 86),StasisBuff=v16(597122 - 226560, nil, 1034 - (714 + 225))});
	if (((10844 - 7133) > (4676 - 1321)) and not v18.Evoker) then
		v18.Evoker = {};
	end
	v18.Evoker.Commons = {Healthstone=v18(597 + 4915),CrimsonAspirantsBadgeofFerocity=v18(291687 - 90238, {(61 - (25 + 23)),(1900 - (927 + 959))}),BelorrelostheSuncaller=v18(698355 - 491183, {(24 - 11),(33 - 19)}),DragonfireBombDispenser=v18(202895 - (175 + 110), {(64 - 51),(39 - 25)}),NymuesUnravelingSpindle=v18(150863 + 57752, {(10 + 3),(13 + 1)}),Dreambinder=v18(209149 - (43 + 490), {(61 - 45)}),Iridal=v18(209180 - (240 + 619), {(25 - 9)}),KharnalexTheFirstLight=v18(12940 + 182579),SpoilsofNeltharus=v18(195517 - (1344 + 400), {(11 + 2),(59 - 45)}),ShadowedOrbofTorment=v18(602147 - 415719, {(419 - (183 + 223)),(10 + 4)}),RefreshingHealingPotion=v18(68874 + 122506)};
	v18.Evoker.Devastation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Preservation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Augmentation = v19(v18.Evoker.Commons, {});
	if (not v21.Evoker or ((1243 - (10 + 327)) >= (1553 + 676))) then
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
		local v45 = 0 + 0;
		while true do
			if (((2206 - 918) > (2407 - (1074 + 82))) and (v45 == (0 - 0))) then
				if ((v43 ~= "player") or ((6297 - (214 + 1570)) < (4807 - (990 + 465)))) then
					return;
				end
				if ((v44 == "ESSENCE") or ((852 + 1213) >= (1391 + 1805))) then
					v11.Persistent.Player.LastPowerUpdate = GetTime();
				end
				break;
			end
		end
	end, "UNIT_POWER_UPDATE");
	v10:RegisterForSelfCombatEvent(function(v46, v46, v46, v46, v46, v46, v46, v47, v46, v46, v46, v48)
		if ((v48 == (359198 + 10176)) or ((17221 - 12845) <= (3207 - (1668 + 58)))) then
			v35.FirestormTracker[v47] = GetTime();
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForCombatEvent(function(v49, v49, v49, v49, v49, v49, v49, v50)
		if (v35.FirestormTracker[v50] or ((4018 - (512 + 114)) >= (12360 - 7619))) then
			v35.FirestormTracker[v50] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v51, v52, v53, v54, v55, v56)
		local v57 = 0 - 0;
		local v58;
		local v59;
		while true do
			if (((11569 - 8244) >= (1003 + 1151)) and (v57 == (1 + 0))) then
				v59 = v37(v51, v52, v53, v54, v55, v56);
				if ((v51 == v16.Evoker.Devastation.Firestorm) or ((1126 + 169) >= (10904 - 7671))) then
					return v59 and not v13:IsCasting(v51);
				elseif (((6371 - (109 + 1885)) > (3111 - (1269 + 200))) and (v51 == v16.Evoker.Devastation.TipTheScales)) then
					return v59 and not v13:BuffUp(v51);
				else
					return v59;
				end
				break;
			end
			if (((9052 - 4329) > (2171 - (98 + 717))) and (v57 == (826 - (802 + 24)))) then
				v58 = true;
				if (v53 or ((7132 - 2996) <= (4335 - 902))) then
					local v146 = 0 + 0;
					local v147;
					while true do
						if (((3262 + 983) <= (761 + 3870)) and (v146 == (0 + 0))) then
							v147 = v55 or v14;
							v58 = v147:IsInRange(v53, v54);
							break;
						end
					end
				end
				v57 = 2 - 1;
			end
		end
	end, 4892 - 3425);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v60 = 0 + 0;
		local v61;
		local v62;
		local v63;
		local v64;
		while true do
			if (((1741 + 2535) >= (3229 + 685)) and (v60 == (1 + 0))) then
				v62 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (((93 + 105) <= (5798 - (797 + 636))) and (not v62 or (v62 < (0.2 - 0)))) then
					v62 = 1619.2 - (1427 + 192);
				end
				v60 = 1 + 1;
			end
			if (((11102 - 6320) > (4204 + 472)) and (v60 == (1 + 1))) then
				v63 = (327 - (192 + 134)) / v62;
				v64 = v11.Persistent.Player.LastPowerUpdate;
				v60 = 1279 - (316 + 960);
			end
			if (((2707 + 2157) > (1696 + 501)) and (v60 == (0 + 0))) then
				v61 = v13:EssenceDeficit();
				if ((v61 == (0 - 0)) or ((4251 - (83 + 468)) == (4313 - (1202 + 604)))) then
					return 0 - 0;
				end
				v60 = 1 - 0;
			end
			if (((12387 - 7913) >= (599 - (45 + 280))) and (v60 == (3 + 0))) then
				return (v61 * v63) - (GetTime() - v64);
			end
		end
	end, 1282 + 185);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v65)
		local v66 = 0 + 0;
		local v67;
		local v68;
		local v69;
		local v70;
		while true do
			if ((v66 == (2 + 0)) or ((334 + 1560) <= (2603 - 1197))) then
				v70 = v11.Persistent.Player.LastPowerUpdate;
				return ((v65 - v67) * v69) - (GetTime() - v70);
			end
			if (((3483 - (340 + 1571)) >= (604 + 927)) and (v66 == (1772 - (1733 + 39)))) then
				v67 = v13:Essence();
				if ((v67 >= v65) or ((12879 - 8192) < (5576 - (125 + 909)))) then
					return 1948 - (1096 + 852);
				end
				v66 = 1 + 0;
			end
			if (((4699 - 1408) > (1617 + 50)) and (v66 == (513 - (409 + 103)))) then
				v68 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v69 = (237 - (46 + 190)) / v68;
				v66 = 97 - (51 + 44);
			end
		end
	end, 414 + 1053);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v71 = 1317 - (1114 + 203);
		local v72;
		local v73;
		local v74;
		local v75;
		while true do
			if ((v71 == (727 - (228 + 498))) or ((190 + 683) == (1124 + 910))) then
				v73 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (not v73 or (v73 < (663.2 - (174 + 489))) or ((7336 - 4520) < (1916 - (830 + 1075)))) then
					v73 = 524.2 - (303 + 221);
				end
				v71 = 1271 - (231 + 1038);
			end
			if (((3083 + 616) < (5868 - (171 + 991))) and (v71 == (8 - 6))) then
				v74 = (2 - 1) / v73;
				v75 = v11.Persistent.Player.LastPowerUpdate;
				v71 = 7 - 4;
			end
			if (((2118 + 528) >= (3070 - 2194)) and (v71 == (8 - 5))) then
				return (v72 * v74) - (GetTime() - v75);
			end
			if (((989 - 375) <= (9842 - 6658)) and (v71 == (1248 - (111 + 1137)))) then
				v72 = v13:EssenceDeficit();
				if (((3284 - (91 + 67)) == (9303 - 6177)) and (v72 == (0 + 0))) then
					return 523 - (423 + 100);
				end
				v71 = 1 + 0;
			end
		end
	end, 4064 - 2596);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v76)
		local v77 = 0 + 0;
		local v78;
		local v79;
		local v80;
		local v81;
		while true do
			if ((v77 == (773 - (326 + 445))) or ((9543 - 7356) >= (11036 - 6082))) then
				v81 = v11.Persistent.Player.LastPowerUpdate;
				return ((v76 - v78) * v80) - (GetTime() - v81);
			end
			if ((v77 == (0 - 0)) or ((4588 - (530 + 181)) == (4456 - (614 + 267)))) then
				v78 = v13:Essence();
				if (((739 - (19 + 13)) > (1028 - 396)) and (v78 >= v76)) then
					return 0 - 0;
				end
				v77 = 2 - 1;
			end
			if ((v77 == (1 + 0)) or ((959 - 413) >= (5565 - 2881))) then
				v79 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v80 = (1813 - (1293 + 519)) / v79;
				v77 = 3 - 1;
			end
		end
	end, 3832 - 2364);
	local v38;
	v38 = v10.AddCoreOverride("Spell.IsCastable", function(v82, v83, v84, v85, v86, v87)
		local v88 = 0 - 0;
		local v89;
		local v90;
		while true do
			if (((6317 - 4852) <= (10131 - 5830)) and (v88 == (1 + 0))) then
				v90 = v38(v82, v83, v84, v85, v86, v87);
				if (((348 + 1356) > (3310 - 1885)) and ((v82 == v16.Evoker.Augmentation.TipTheScales) or (v82 == v16.Evoker.Augmentation.Upheaval) or (v82 == v16.Evoker.Augmentation.FireBreath))) then
					return v90 and not v13:BuffUp(v82);
				else
					return v90;
				end
				break;
			end
			if ((v88 == (0 + 0)) or ((229 + 458) == (2646 + 1588))) then
				v89 = true;
				if (v84 or ((4426 - (709 + 387)) < (3287 - (673 + 1185)))) then
					local v148 = 0 - 0;
					local v149;
					while true do
						if (((3682 - 2535) >= (551 - 216)) and (v148 == (0 + 0))) then
							v149 = v86 or v14;
							v89 = v149:IsInRange(v84, v85);
							break;
						end
					end
				end
				v88 = 1 + 0;
			end
		end
	end, 1987 - 514);
	local v39;
	v39 = v10.AddCoreOverride("Spell.IsReady", function(v91, v92, v93, v94, v95, v96)
		local v97 = 0 + 0;
		local v98;
		local v99;
		while true do
			if (((6849 - 3414) > (4116 - 2019)) and (v97 == (1880 - (446 + 1434)))) then
				v98 = true;
				if (v93 or ((5053 - (1040 + 243)) >= (12060 - 8019))) then
					local v150 = 1847 - (559 + 1288);
					local v151;
					while true do
						if ((v150 == (1931 - (609 + 1322))) or ((4245 - (13 + 441)) <= (6019 - 4408))) then
							v151 = v95 or v14;
							v98 = v151:IsInRange(v93, v94);
							break;
						end
					end
				end
				v97 = 2 - 1;
			end
			if ((v97 == (4 - 3)) or ((171 + 4407) <= (7292 - 5284))) then
				v99 = v39(v91, v92, v93, v94, v95, v96);
				if (((400 + 725) <= (910 + 1166)) and (v91 == v16.Evoker.Augmentation.Eruption)) then
					return v99 and (v13:EssenceP() >= (5 - 3));
				elseif ((v91 == v16.Evoker.Augmentation.EbonMight) or ((407 + 336) >= (8090 - 3691))) then
					return v99 and not v13:IsCasting(v91);
				elseif (((764 + 391) < (931 + 742)) and (v91 == v16.Evoker.Augmentation.Unravel)) then
					return v99 and v14:EnemyAbsorb();
				else
					return v99;
				end
				break;
			end
		end
	end, 1059 + 414);
	local v40;
	v40 = v10.AddCoreOverride("Player.IsMoving", function(v100)
		local v101 = 0 + 0;
		local v102;
		while true do
			if ((v101 == (0 + 0)) or ((2757 - (153 + 280)) <= (1668 - 1090))) then
				v102 = v40(v100);
				return v102 and v13:BuffDown(v16.Evoker.Augmentation.HoverBuff);
			end
		end
	end, 1323 + 150);
	local v41;
	v41 = v10.AddCoreOverride("Player.BuffRemains", function(v103, v104, v105, v106)
		if (((1488 + 2279) == (1972 + 1795)) and (v104 == v104.Evoker.Augmentation.EbonMightSelfBuff)) then
			return (v103:IsCasting(v104.Evoker.Augmentation.EbonMight) and (10 + 0)) or v41(v103, v104, v105, v106);
		else
			return v41(v103, v104, v105, v106);
		end
	end, 1068 + 405);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v107, v108)
		local v109 = 0 - 0;
		local v110;
		local v111;
		local v112;
		while true do
			if (((2528 + 1561) == (4756 - (89 + 578))) and ((2 + 0) == v109)) then
				return ((1 - 0) + ((1049.75 - (572 + 477)) * (v108 - (1 + 0)))) * v110 * v111;
			end
			if (((2676 + 1782) >= (200 + 1474)) and (v109 == (87 - (84 + 2)))) then
				v112 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (6 - 2)) or (3 + 0);
				if (((1814 - (497 + 345)) <= (37 + 1381)) and not v108) then
					v108 = v112;
				end
				v109 = 1 + 1;
			end
			if ((v109 == (1333 - (605 + 728))) or ((3524 + 1414) < (10586 - 5824))) then
				v110 = v13:SpellHaste();
				v111 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (0.8 + 0)) or (3 - 2);
				v109 = 1 + 0;
			end
		end
	end, 4080 - 2607);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v113, v114)
		local v115 = 0 + 0;
		local v116;
		local v117;
		local v118;
		while true do
			if ((v115 == (490 - (457 + 32))) or ((1063 + 1441) > (5666 - (832 + 570)))) then
				v118 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (4 + 0)) or (1 + 2);
				if (((7618 - 5465) == (1038 + 1115)) and not v114) then
					v114 = v118;
				end
				v115 = 798 - (588 + 208);
			end
			if ((v115 == (0 - 0)) or ((2307 - (884 + 916)) >= (5424 - 2833))) then
				v116 = v13:SpellHaste();
				v117 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (0.8 + 0)) or (654 - (232 + 421));
				v115 = 1890 - (1569 + 320);
			end
			if (((1100 + 3381) == (852 + 3629)) and (v115 == (6 - 4))) then
				return ((606 - (316 + 289)) + ((0.75 - 0) * (v114 - (1 + 0)))) * v116 * v117;
			end
		end
	end, 2920 - (666 + 787));
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v119, v120)
		local v121 = v13:SpellHaste();
		local v122 = 426 - (360 + 65);
		local v123 = ((v16.Evoker.Preservation.FontofMagic:IsAvailable()) and (4 + 0)) or (257 - (79 + 175));
		if (not v120 or ((3670 - 1342) < (541 + 152))) then
			v120 = v123;
		end
		return ((2 - 1) + ((0.75 - 0) * (v120 - (900 - (503 + 396))))) * v121 * v122;
	end, 1649 - (92 + 89));
	v10.AddCoreOverride("Player.EssenceP", function()
		local v124 = 0 - 0;
		local v125;
		while true do
			if (((2220 + 2108) == (2562 + 1766)) and (v124 == (0 - 0))) then
				v125 = v13:Essence();
				if (((218 + 1370) >= (3036 - 1704)) and not v13:IsCasting() and not v13:IsChanneling()) then
					return v125;
				elseif ((v13:IsCasting(v16.Evoker.Augmentation.Eruption) and v13:BuffDown(v16.Evoker.Augmentation.EssenceBurstBuff)) or ((3642 + 532) > (2029 + 2219))) then
					return v125 - (5 - 3);
				else
					return v125;
				end
				break;
			end
		end
	end, 184 + 1289);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v126 = v13:EssenceDeficit();
		if ((v126 == (0 - 0)) or ((5830 - (485 + 759)) <= (189 - 107))) then
			return 1189 - (442 + 747);
		end
		local v127 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		if (((4998 - (832 + 303)) == (4809 - (88 + 858))) and (not v127 or (v127 < (0.2 + 0)))) then
			v127 = 0.2 + 0;
		end
		local v128 = (1 + 0) / v127;
		local v129 = v11.Persistent.Player.LastPowerUpdate;
		return (v126 * v128) - (GetTime() - v129);
	end, 2262 - (766 + 23));
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v130)
		local v131 = v13:Essence();
		if ((v131 >= v130) or ((1392 - 1110) <= (56 - 14))) then
			return 0 - 0;
		end
		local v132 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		local v133 = (3 - 2) / v132;
		local v134 = v11.Persistent.Player.LastPowerUpdate;
		return ((v130 - v131) * v133) - (GetTime() - v134);
	end, 2546 - (1036 + 37));
end;
return v0["Epix_Evoker_Evoker.lua"]();

