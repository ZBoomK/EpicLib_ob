local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((11538 - 8568) > (5360 - 4026)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Evoker_Evoker.lua"] = function(...)
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
	if (not v15.Evoker or ((1568 + 461) >= (4425 - (494 + 157)))) then
		v15.Evoker = {};
	end
	v15.Evoker.Commons = {TailSwipe=v15(816394 - 447424, nil, 1 + 0),WingBuffet=v15(30144 + 327070, nil, 1 + 1),AzureStrike=v15(363805 - (660 + 176), nil, 1 + 2),BlessingoftheBronze=v15(364544 - (14 + 188), nil, 679 - (534 + 141)),DeepBreath=v15(143605 + 213605, nil, 5 + 0),Disintegrate=v15(343231 + 13764, nil, 12 - 6),EmeraldBlossom=v15(565054 - 209141, nil, 19 - 12),FireBreath=v16(52 + 44, 227440 + 129768, 382662 - (115 + 281)),LivingFlame=v15(840789 - 479320, nil, 7 + 1),OppressingRoar=v15(899148 - 527100, nil, 373 - 271),Expunge=v15(366452 - (550 + 317), nil, 148 - 45),Sleepwalk=v15(507139 - 146333, nil, 290 - 186),RenewingBlaze=v15(374633 - (134 + 151), nil, 1770 - (970 + 695)),Hover=v15(683657 - 325390, nil, 2096 - (582 + 1408)),AncientFlame=v15(1283153 - 913163, nil, 10 - 1),BlastFurnace=v15(1415055 - 1039545, nil, 1834 - (1195 + 629)),LeapingFlames=v15(489242 - 119303, nil, 252 - (187 + 54)),ObsidianScales=v15(364696 - (162 + 618), nil, 9 + 3),ScarletAdaptation=v15(248080 + 124389, nil, 27 - 14),SourceofMagic=v15(621130 - 251671, nil, 2 + 12),TipTheScales=v15(372189 - (1373 + 263), nil, 1015 - (451 + 549)),Unravel=v15(116300 + 252132, nil, 24 - 8),VerdantEmbrace=v15(606710 - 245715, nil, 1401 - (746 + 638)),AncientFlameBuff=v15(141346 + 234237, nil, 27 - 9),BlessingoftheBronzeBuff=v15(382089 - (218 + 123), nil, 1600 - (1535 + 46)),FireBreathDebuff=v15(354923 + 2286, nil, 3 + 17),HoverBuff=v15(358827 - (306 + 254), nil, 2 + 19),LeapingFlamesBuff=v15(727908 - 357007, nil, 1489 - (899 + 568)),PowerInfusionBuff=v15(6613 + 3447, nil, 55 - 32),ScarletAdaptationBuff=v15(373073 - (268 + 335), nil, 314 - (60 + 230)),SourceofMagicBuff=v15(370031 - (426 + 146), nil, 3 + 22),SpoilsofNeltharusCrit=v15(383410 - (282 + 1174), nil, 837 - (569 + 242)),SpoilsofNeltharusHaste=v15(1100257 - 718302, nil, 2 + 25),SpoilsofNeltharusMastery=v15(382980 - (706 + 318), nil, 1279 - (721 + 530)),SpoilsofNeltharusVers=v15(383228 - (945 + 326), nil, 72 - 43),Quell=v15(312628 + 38710, nil, 730 - (271 + 429)),Pool=v15(918520 + 81390, nil, 1531 - (1408 + 92))};
	v15.Evoker.Augmentation = v18(v15.Evoker.Commons, {BlackAttunement=v15(404350 - (461 + 625), nil, 1320 - (993 + 295)),BronzeAttunement=v15(20940 + 382325, nil, 1204 - (418 + 753)),BlisteringScales=v15(137422 + 223405, nil, 4 + 30),BreathofEons=v15(118056 + 285575, nil, 9 + 26),DreamofSpring=v15(415498 - (406 + 123), nil, 1805 - (1749 + 20)),EbonMight=v15(93859 + 301293, nil, 1359 - (1249 + 73)),Eruption=v15(140981 + 254179, nil, 1183 - (466 + 679)),FontofMagic=v15(981631 - 573548, nil, 111 - 72),InterwovenThreads=v15(414613 - (106 + 1794), nil, 13 + 27),Prescience=v15(103466 + 305845, nil, 120 - 79),PupilofAlexstrasza=v15(1104335 - 696521, nil, 156 - (4 + 110)),TimeSkip=v15(405561 - (57 + 527), nil, 1470 - (41 + 1386)),Upheaval=v15(408195 - (17 + 86), nil, 30 + 14),BlackAttunementBuff=v15(899324 - 496060, nil, 130 - 85),BlisteringScalesBuff=v15(360993 - (122 + 44), nil, 79 - 33),BronzeAttunementBuff=v15(1337819 - 934554, nil, 39 + 8),EbonMightOtherBuff=v15(57148 + 338004, nil, 97 - 49),EbonMightSelfBuff=v15(395361 - (30 + 35), nil, 34 + 15),EssenceBurstBuff=v15(393525 - (1043 + 214), nil, 189 - 139),PrescienceBuff=v15(411301 - (323 + 889), nil, 672 - 422),TemporalWoundDebuff=v15(410140 - (361 + 219), nil, 371 - (53 + 267))});
	v15.Evoker.Devastation = v18(v15.Evoker.Commons, {Animosity=v15(84901 + 290896, nil, 465 - (15 + 398)),ArcaneVigor=v15(387324 - (18 + 964), nil, 199 - 146),Burnout=v15(217575 + 158226, nil, 35 + 19),Catalyze=v15(387133 - (20 + 830), nil, 43 + 12),Causality=v15(375903 - (116 + 10), nil, 5 + 51),ChargedBlast=v15(371193 - (542 + 196), nil, 121 - 64),Dragonrage=v15(109532 + 265555, nil, 30 + 28),EngulfingBlaze=v15(133489 + 237348, nil, 155 - 96),EssenceAttunement=v15(963272 - 587550, nil, 1611 - (1126 + 425)),EternitySurge=v16(502 - (118 + 287), 1407312 - 1048239, 383532 - (118 + 1003)),EternitysSpan=v15(1099626 - 723869, nil, 438 - (142 + 235)),EventHorizon=v15(1865253 - 1454089, nil, 14 + 48),EverburningFlame=v15(371796 - (553 + 424), nil, 118 - 55),EyeofInfinity=v15(325389 + 43986, nil, 64 + 0),FeedtheFlames=v15(215345 + 154501, nil, 28 + 37),Firestorm=v15(210638 + 158209, nil, 142 - 76),FontofMagic=v15(1047049 - 671266, nil, 149 - 82),ImminentDestruction=v15(107821 + 262960, nil, 328 - 260),Pyre=v15(357964 - (239 + 514), nil, 25 + 44),RagingInferno=v15(406988 - (797 + 532), nil, 51 + 19),RubyEmbers=v15(123450 + 242487, nil, 166 - 95),Scintillation=v15(372023 - (373 + 829), nil, 803 - (476 + 255)),ShatteringStar=v15(371582 - (369 + 761), nil, 43 + 30),Snapfire=v15(673486 - 302703, nil, 140 - 66),Tyranny=v15(377126 - (64 + 174), nil, 11 + 64),Volatility=v15(546597 - 177508, nil, 412 - (144 + 192)),BlazingShardsBuff=v15(410064 - (42 + 174), nil, 58 + 19),BurnoutBuff=v15(311304 + 64498, nil, 34 + 44),ChargedBlastBuff=v15(371958 - (363 + 1141), nil, 1659 - (1183 + 397)),EmeraldTranceBuff=v15(1291273 - 867118, nil, 96 + 34),EssenceBurstBuff=v15(268799 + 90819, nil, 2055 - (1913 + 62)),IridescenceBlueBuff=v16(62 + 36, 1022915 - 636516, 401303 - (565 + 1368)),IridescenceRedBuff=v15(1452971 - 1066618, nil, 1742 - (1477 + 184)),LimitlessPotentialBuff=v15(537404 - 143002, nil, 77 + 5),PowerSwellBuff=v15(377706 - (564 + 292), nil, 142 - 59),SnapfireBuff=v15(1117707 - 746889, nil, 388 - (244 + 60)),LivingFlameDebuff=v15(277962 + 83538, nil, 561 - (41 + 435))});
	v15.Evoker.Preservation = v18(v15.Evoker.Commons, {DreamBreath=v16(1100 - (938 + 63), 273743 + 82193, 383739 - (936 + 189)),DreamFlight=v15(118416 + 241400, nil, 1699 - (1565 + 48)),Echo=v15(225061 + 139282, nil, 1225 - (782 + 356)),MassReturn=v15(361445 - (176 + 91), nil, 229 - 141),Spiritbloom=v16(147 - 47, 368318 - (975 + 117), 384606 - (157 + 1718)),Stasis=v15(300711 + 69826, nil, 315 - 226),StasisReactivate=v15(1266888 - 896324, nil, 1108 - (697 + 321)),TemporalAnomaly=v15(1018445 - 644584, nil, 192 - 101),TimeDilation=v15(823413 - 466243, nil, 36 + 56),Reversion=v16(189 - 88, 981555 - 615400, 368591 - (322 + 905)),Rewind=v15(364145 - (602 + 9), nil, 1282 - (449 + 740)),FontofMagic=v15(376655 - (826 + 46), nil, 1014 - (245 + 702)),CauterizingFlame=v15(1182617 - 808366, nil, 304 + 639),EssenceBurstBuff=v15(371197 - (260 + 1638), nil, 534 - (382 + 58)),StasisBuff=v15(1188789 - 818227, nil, 79 + 16)});
	if (((7896 - 4075) > (5499 - 3649)) and not v17.Evoker) then
		v17.Evoker = {};
	end
	v17.Evoker.Commons = {Healthstone=v17(6717 - (902 + 303)),CrimsonAspirantsBadgeofFerocity=v17(442309 - 240860, {(2 + 11),(228 - (22 + 192))}),BelorrelostheSuncaller=v17(207855 - (483 + 200), {(35 - 22),(779 - (468 + 297))}),DragonfireBombDispenser=v17(203172 - (334 + 228), {(29 - 16),(4 + 10)}),NymuesUnravelingSpindle=v17(208851 - (141 + 95), {(33 - 20),(4 + 10)}),Dreambinder=v17(571582 - 362966, {(9 + 7)}),Iridal=v17(293366 - 85045, {(179 - (92 + 71))}),KharnalexTheFirstLight=v17(96576 + 98943),SpoilsofNeltharus=v17(325790 - 132017, {(11 + 2),(8 + 6)}),ShadowedOrbofTorment=v17(187277 - (254 + 595), {(16 - 3),(38 - 24)}),RefreshingHealingPotion=v17(14562 + 176818),PotionOfWitheringDreams=v17(333625 - 126584)};
	v17.Evoker.Devastation = v18(v17.Evoker.Commons, {});
	v17.Evoker.Preservation = v18(v17.Evoker.Commons, {});
	v17.Evoker.Augmentation = v18(v17.Evoker.Commons, {});
	if (not v20.Evoker or ((2555 - (714 + 225)) == (6922 - 4553))) then
		v20.Evoker = {};
	end
	v20.Evoker.Commons = {Healthstone=v20(51 - 14),AzureStrikeMouseover=v20(5 + 33),DeepBreathCursor=v20(55 - 16),CauterizingFlameFocus=v20(846 - (118 + 688)),EmeraldBlossomFocus=v20(89 - (25 + 23)),FireBreathMacro=v20(9 + 33),LivingFlameFocus=v20(1929 - (927 + 959)),QuellMouseover=v20(148 - 104),VerdantEmbraceFocus=v20(742 - (16 + 716)),RefreshingHealingPotion=v20(63 - 30),ExpungeMouseover=v20(131 - (11 + 86)),ExpungeFocus=v20(85 - 50),SleepwalkMouseover=v20(321 - (175 + 110)),VerdantEmbracePlayer=v20(72 - 43),EmeraldBlossomPlayer=v20(152 - 121),SourceofMagicFocus=v20(1818 - (503 + 1293)),SourceofMagicName=v20(64 - 41)};
	v20.Evoker.Devastation = v18(v20.Evoker.Commons, {EternitySurgeMacro=v20(8 + 3)});
	v20.Evoker.Preservation = v18(v20.Evoker.Commons, {DreamBreathMacro=v20(1073 - (810 + 251)),DreamFlightCursor=v20(10 + 3),EchoFocus=v20(5 + 9),SpiritbloomFocus=v20(14 + 1),TimeDilationFocus=v20(549 - (43 + 490)),TipTheScalesDreamBreath=v20(750 - (711 + 22)),TipTheScalesSpiritbloom=v20(69 - 51),ReversionFocus=v20(878 - (240 + 619)),EchoMouseover=v20(12 + 34),LivingFlameMouseover=v20(74 - 27)});
	v20.Evoker.Augmentation = v18(v20.Evoker.Commons, {BlisteringScalesFocus=v20(2 + 18),BlisteringScalesName=v20(1765 - (1344 + 400)),PrescienceName1=v20(429 - (255 + 150)),PrescienceName2=v20(20 + 5),PrescienceName3=v20(14 + 12),PrescienceName4=v20(115 - 88),PrescienceFocus=v20(90 - 62),BreathofEonsCursor=v20(1784 - (404 + 1335))});
	v19.Commons.Evoker = {};
	local v34 = v19.Commons.Evoker;
	v34.FirestormTracker = {};
	v9:RegisterForEvent(function(v41, v42, v43)
		local v44 = 406 - (183 + 223);
		while true do
			if ((v44 == (0 - 0)) or ((831 + 423) >= (621 + 1104))) then
				if ((v42 ~= "player") or ((746 - (10 + 327)) >= (2663 + 1161))) then
					return;
				end
				if (((2425 - (118 + 220)) == (696 + 1391)) and (v43 == "ESSENCE")) then
					v10.Persistent.Player.LastPowerUpdate = GetTime();
				end
				break;
			end
		end
	end, "UNIT_POWER_UPDATE");
	v9:RegisterForSelfCombatEvent(function(v45, v45, v45, v45, v45, v45, v45, v46, v45, v45, v45, v47)
		if ((v47 == (369823 - (108 + 341))) or ((1529 + 1875) > (19037 - 14534))) then
			v34.FirestormTracker[v46] = GetTime();
		end
	end, "SPELL_DAMAGE");
	v9:RegisterForCombatEvent(function(v48, v48, v48, v48, v48, v48, v48, v49)
		if (v34.FirestormTracker[v49] or ((4999 - (711 + 782)) <= (2508 - 1199))) then
			v34.FirestormTracker[v49] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	local v36;
	v36 = v9.AddCoreOverride("Spell.IsCastable", function(v50, v51, v52, v53, v54, v55)
		local v56 = 469 - (270 + 199);
		local v57;
		local v58;
		while true do
			if (((958 + 1997) == (4774 - (580 + 1239))) and (v56 == (2 - 1))) then
				v58 = v36(v50, v51, v52, v53, v54, v55);
				if ((v50 == v15.Evoker.Devastation.Firestorm) or ((2776 + 127) == (54 + 1441))) then
					return v58 and not v12:IsCasting(v50);
				elseif (((1981 + 2565) >= (5939 - 3664)) and (v50 == v15.Evoker.Devastation.TipTheScales)) then
					return v58 and not v12:BuffUp(v50);
				else
					return v58;
				end
				break;
			end
			if (((509 + 310) >= (1189 - (645 + 522))) and (v56 == (1790 - (1010 + 780)))) then
				v57 = true;
				if (((3161 + 1) == (15063 - 11901)) and v52) then
					local v139 = v54 or v13;
					v57 = v139:IsInRange(v52, v53);
				end
				v56 = 2 - 1;
			end
		end
	end, 3303 - (1045 + 791));
	v9.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v59 = v12:EssenceDeficit();
		if ((v59 == (0 - 0)) or ((3616 - 1247) > (4934 - (351 + 154)))) then
			return 1574 - (1281 + 293);
		end
		local v60 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		if (((4361 - (28 + 238)) >= (7111 - 3928)) and (not v60 or (v60 < (1559.2 - (1381 + 178))))) then
			v60 = 0.2 + 0;
		end
		local v61 = (1 + 0) / v60;
		local v62 = v10.Persistent.Player.LastPowerUpdate;
		return (v59 * v61) - (GetTime() - v62);
	end, 626 + 841);
	v9.AddCoreOverride("Player.EssenceTimeToX", function(v63)
		local v64 = 0 - 0;
		local v65;
		local v66;
		local v67;
		local v68;
		while true do
			if ((v64 == (1 + 0)) or ((4181 - (381 + 89)) < (894 + 114))) then
				v66 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v67 = (1 + 0) / v66;
				v64 = 2 - 0;
			end
			if ((v64 == (1158 - (1074 + 82))) or ((2298 - 1249) <= (2690 - (214 + 1570)))) then
				v68 = v10.Persistent.Player.LastPowerUpdate;
				return ((v63 - v65) * v67) - (GetTime() - v68);
			end
			if (((5968 - (990 + 465)) > (1124 + 1602)) and (v64 == (0 + 0))) then
				v65 = v12:Essence();
				if ((v65 >= v63) or ((1441 + 40) >= (10460 - 7802))) then
					return 1726 - (1668 + 58);
				end
				v64 = 627 - (512 + 114);
			end
		end
	end, 3824 - 2357);
	v9.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v69 = 0 - 0;
		local v70;
		local v71;
		local v72;
		local v73;
		while true do
			if (((6 - 4) == v69) or ((1498 + 1722) == (256 + 1108))) then
				v72 = (1 + 0) / v71;
				v73 = v10.Persistent.Player.LastPowerUpdate;
				v69 = 10 - 7;
			end
			if ((v69 == (1997 - (109 + 1885))) or ((2523 - (1269 + 200)) > (6501 - 3109))) then
				return (v70 * v72) - (GetTime() - v73);
			end
			if ((v69 == (815 - (98 + 717))) or ((1502 - (802 + 24)) >= (2831 - 1189))) then
				v70 = v12:EssenceDeficit();
				if (((5223 - 1087) > (354 + 2043)) and (v70 == (0 + 0))) then
					return 0 + 0;
				end
				v69 = 1 + 0;
			end
			if ((v69 == (2 - 1)) or ((14452 - 10118) == (1519 + 2726))) then
				v71 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (not v71 or (v71 < (0.2 + 0)) or ((3528 + 748) <= (2204 + 827))) then
					v71 = 0.2 + 0;
				end
				v69 = 1435 - (797 + 636);
			end
		end
	end, 7127 - 5659);
	v9.AddCoreOverride("Player.EssenceTimeToX", function(v74)
		local v75 = v12:Essence();
		if ((v75 >= v74) or ((6401 - (1427 + 192)) <= (416 + 783))) then
			return 0 - 0;
		end
		local v76 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		local v77 = (1 + 0) / v76;
		local v78 = v10.Persistent.Player.LastPowerUpdate;
		return ((v74 - v75) * v77) - (GetTime() - v78);
	end, 666 + 802);
	local v37;
	v37 = v9.AddCoreOverride("Spell.IsCastable", function(v79, v80, v81, v82, v83, v84)
		local v85 = 326 - (192 + 134);
		local v86;
		local v87;
		while true do
			if ((v85 == (1277 - (316 + 960))) or ((2707 + 2157) < (1468 + 434))) then
				v87 = v37(v79, v80, v81, v82, v83, v84);
				if (((4473 + 366) >= (14145 - 10445)) and ((v79 == v15.Evoker.Augmentation.TipTheScales) or (v79 == v15.Evoker.Augmentation.Upheaval) or (v79 == v15.Evoker.Augmentation.FireBreath))) then
					return v87 and not v12:BuffUp(v79);
				else
					return v87;
				end
				break;
			end
			if ((v85 == (551 - (83 + 468))) or ((2881 - (1202 + 604)) > (8953 - 7035))) then
				v86 = true;
				if (((658 - 262) <= (10532 - 6728)) and v81) then
					local v140 = v83 or v13;
					v86 = v140:IsInRange(v81, v82);
				end
				v85 = 326 - (45 + 280);
			end
		end
	end, 1422 + 51);
	local v38;
	v38 = v9.AddCoreOverride("Spell.IsReady", function(v88, v89, v90, v91, v92, v93)
		local v94 = 0 + 0;
		local v95;
		local v96;
		while true do
			if ((v94 == (0 + 0)) or ((2307 + 1862) == (385 + 1802))) then
				v95 = true;
				if (((2603 - 1197) == (3317 - (340 + 1571))) and v90) then
					local v141 = 0 + 0;
					local v142;
					while true do
						if (((3303 - (1733 + 39)) < (11736 - 7465)) and ((1034 - (125 + 909)) == v141)) then
							v142 = v92 or v13;
							v95 = v142:IsInRange(v90, v91);
							break;
						end
					end
				end
				v94 = 1949 - (1096 + 852);
			end
			if (((285 + 350) == (906 - 271)) and (v94 == (1 + 0))) then
				v96 = v38(v88, v89, v90, v91, v92, v93);
				if (((3885 - (409 + 103)) <= (3792 - (46 + 190))) and (v88 == v15.Evoker.Augmentation.Eruption)) then
					return v96 and (v12:EssenceP() >= (97 - (51 + 44)));
				elseif ((v88 == v15.Evoker.Augmentation.EbonMight) or ((929 + 2362) < (4597 - (1114 + 203)))) then
					return v96 and not v12:IsCasting(v88);
				elseif (((5112 - (228 + 498)) >= (190 + 683)) and (v88 == v15.Evoker.Augmentation.Unravel)) then
					return v96 and v13:EnemyAbsorb();
				else
					return v96;
				end
				break;
			end
		end
	end, 814 + 659);
	local v39;
	v39 = v9.AddCoreOverride("Player.IsMoving", function(v97)
		local v98 = 663 - (174 + 489);
		local v99;
		while true do
			if (((2399 - 1478) <= (3007 - (830 + 1075))) and ((524 - (303 + 221)) == v98)) then
				v99 = v39(v97);
				return v99 and v12:BuffDown(v15.Evoker.Augmentation.HoverBuff);
			end
		end
	end, 2742 - (231 + 1038));
	local v40;
	v40 = v9.AddCoreOverride("Player.BuffRemains", function(v100, v101, v102, v103)
		if (((3922 + 784) >= (2125 - (171 + 991))) and (v101 == v101.Evoker.Augmentation.EbonMightSelfBuff)) then
			return (v100:IsCasting(v101.Evoker.Augmentation.EbonMight) and (41 - 31)) or v40(v100, v101, v102, v103);
		else
			return v40(v100, v101, v102, v103);
		end
	end, 3955 - 2482);
	v9.AddCoreOverride("Player.EmpowerCastTime", function(v104, v105)
		local v106 = v12:SpellHaste();
		local v107 = ((v15.Evoker.Augmentation.FontofMagic:IsAvailable()) and (0.8 - 0)) or (1 + 0);
		local v108 = ((v15.Evoker.Augmentation.FontofMagic:IsAvailable()) and (13 - 9)) or (8 - 5);
		if (not v105 or ((1547 - 587) <= (2707 - 1831))) then
			v105 = v108;
		end
		return ((1249 - (111 + 1137)) + ((158.75 - (91 + 67)) * (v105 - (2 - 1)))) * v106 * v107;
	end, 368 + 1105);
	v9.AddCoreOverride("Player.EmpowerCastTime", function(v109, v110)
		local v111 = 523 - (423 + 100);
		local v112;
		local v113;
		local v114;
		while true do
			if ((v111 == (1 + 1)) or ((5719 - 3653) == (486 + 446))) then
				return ((772 - (326 + 445)) + ((0.75 - 0) * (v110 - (2 - 1)))) * v112 * v113;
			end
			if (((11262 - 6437) < (5554 - (530 + 181))) and (v111 == (882 - (614 + 267)))) then
				v114 = ((v15.Evoker.Devastation.FontofMagic:IsAvailable()) and (36 - (19 + 13))) or (4 - 1);
				if (not v110 or ((9034 - 5157) >= (12960 - 8423))) then
					v110 = v114;
				end
				v111 = 1 + 1;
			end
			if ((v111 == (0 - 0)) or ((8948 - 4633) < (3538 - (1293 + 519)))) then
				v112 = v12:SpellHaste();
				v113 = ((v15.Evoker.Devastation.FontofMagic:IsAvailable()) and (0.8 - 0)) or (2 - 1);
				v111 = 1 - 0;
			end
		end
	end, 6325 - 4858);
	v9.AddCoreOverride("Player.EmpowerCastTime", function(v115, v116)
		local v117 = 0 - 0;
		local v118;
		local v119;
		local v120;
		while true do
			if ((v117 == (1 + 0)) or ((751 + 2928) < (1451 - 826))) then
				v120 = ((v15.Evoker.Preservation.FontofMagic:IsAvailable()) and (1 + 3)) or (1 + 2);
				if (not v116 or ((2891 + 1734) < (1728 - (709 + 387)))) then
					v116 = v120;
				end
				v117 = 1860 - (673 + 1185);
			end
			if ((v117 == (5 - 3)) or ((266 - 183) > (2928 - 1148))) then
				return (1 + 0 + ((0.75 + 0) * (v116 - (1 - 0)))) * v118 * v119;
			end
			if (((135 + 411) <= (2146 - 1069)) and (v117 == (0 - 0))) then
				v118 = v12:SpellHaste();
				v119 = 1881 - (446 + 1434);
				v117 = 1284 - (1040 + 243);
			end
		end
	end, 4381 - 2913);
	v9.AddCoreOverride("Player.EssenceP", function()
		local v121 = v12:Essence();
		if ((not v12:IsCasting() and not v12:IsChanneling()) or ((2843 - (559 + 1288)) > (6232 - (609 + 1322)))) then
			return v121;
		elseif (((4524 - (13 + 441)) > (2567 - 1880)) and v12:IsCasting(v15.Evoker.Augmentation.Eruption) and v12:BuffDown(v15.Evoker.Augmentation.EssenceBurstBuff)) then
			return v121 - (5 - 3);
		else
			return v121;
		end
	end, 7336 - 5863);
	v9.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v122 = v12:EssenceDeficit();
		if ((v122 == (0 + 0)) or ((2382 - 1726) >= (1183 + 2147))) then
			return 0 + 0;
		end
		local v123 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		if (not v123 or (v123 < (0.2 - 0)) or ((1364 + 1128) <= (615 - 280))) then
			v123 = 0.2 + 0;
		end
		local v124 = (1 + 0) / v123;
		local v125 = v10.Persistent.Player.LastPowerUpdate;
		return (v122 * v124) - (GetTime() - v125);
	end, 1059 + 414);
	v9.AddCoreOverride("Player.EssenceTimeToX", function(v126)
		local v127 = v12:Essence();
		if (((3629 + 693) >= (2507 + 55)) and (v127 >= v126)) then
			return 433 - (153 + 280);
		end
		local v128 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		local v129 = (2 - 1) / v128;
		local v130 = v10.Persistent.Player.LastPowerUpdate;
		return ((v126 - v127) * v129) - (GetTime() - v130);
	end, 1323 + 150);
end;
return v0["Epix_Evoker_Evoker.lua"]();

