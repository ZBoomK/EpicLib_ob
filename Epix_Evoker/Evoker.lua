local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((5028 - (71 + 3)) == (2856 + 47))) then
			return v6(...);
		end
		if (((7547 - 4463) > (52 - 12)) and (v5 == (241 - (187 + 54)))) then
			v6 = v0[v4];
			if (((4192 - (162 + 618)) > (574 + 245)) and not v6) then
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
	if (((6743 - 3581) <= (5784 - 2343)) and not v16.Evoker) then
		v16.Evoker = {};
	end
	v16.Evoker.Commons = {TailSwipe=v16(28850 + 340120, nil, 1637 - (1373 + 263)),WingBuffet=v16(358214 - (451 + 549), nil, 1 + 1),AzureStrike=v16(564870 - 201901, nil, 4 - 1),BlessingoftheBronze=v16(365726 - (746 + 638), nil, 2 + 2),DeepBreath=v16(542346 - 185136, nil, 346 - (218 + 123)),Disintegrate=v16(358576 - (1535 + 46), nil, 6 + 0),EmeraldBlossom=v16(51502 + 304411, nil, 567 - (306 + 254)),FireBreath=v17(6 + 90, 701035 - 343827, 383733 - (899 + 568)),LivingFlame=v16(237594 + 123875, nil, 19 - 11),OppressingRoar=v16(372651 - (268 + 335), nil, 392 - (60 + 230)),Expunge=v16(366157 - (426 + 146), nil, 13 + 90),Sleepwalk=v16(362262 - (282 + 1174), nil, 915 - (569 + 242)),RenewingBlaze=v16(1078344 - 703996, nil, 7 + 98),Hover=v16(359291 - (706 + 318), nil, 1357 - (721 + 530)),AncientFlame=v16(371261 - (945 + 326), nil, 22 - 13),BlastFurnace=v16(334136 + 41374, nil, 710 - (271 + 429)),LeapingFlames=v16(339827 + 30112, nil, 1511 - (1408 + 92)),ObsidianScales=v16(365002 - (461 + 625), nil, 1300 - (993 + 295)),ScarletAdaptation=v16(19341 + 353128, nil, 1184 - (418 + 753)),SourceofMagic=v16(140710 + 228749, nil, 2 + 12),TipTheScales=v16(108381 + 262172, nil, 4 + 11),Unravel=v16(368961 - (406 + 123), nil, 1785 - (1749 + 20)),VerdantEmbrace=v16(85746 + 275249, nil, 1339 - (1249 + 73)),AncientFlameBuff=v16(133996 + 241587, nil, 1163 - (466 + 679)),BlessingoftheBronzeBuff=v16(918283 - 536535, nil, 54 - 35),FireBreathDebuff=v16(359109 - (106 + 1794), nil, 7 + 13),HoverBuff=v16(90563 + 267704, nil, 61 - 40),LeapingFlamesBuff=v16(1004377 - 633476, nil, 136 - (4 + 110)),PowerInfusionBuff=v16(10644 - (57 + 527), nil, 1450 - (41 + 1386)),ScarletAdaptationBuff=v16(372573 - (17 + 86), nil, 17 + 7),SourceofMagicBuff=v16(823935 - 454476, nil, 72 - 47),SpoilsofNeltharusCrit=v16(382120 - (122 + 44), nil, 44 - 18),SpoilsofNeltharusHaste=v16(1267124 - 885169, nil, 22 + 5),SpoilsofNeltharusMastery=v16(55240 + 326716, nil, 56 - 28),SpoilsofNeltharusVers=v16(382022 - (30 + 35), nil, 20 + 9),Quell=v16(352595 - (1043 + 214), nil, 113 - 83),Pool=v16(1001122 - (323 + 889), nil, 83 - 52)};
	v16.Evoker.Augmentation = v19(v16.Evoker.Commons, {BlackAttunement=v16(403844 - (361 + 219), nil, 352 - (53 + 267)),BronzeAttunement=v16(91106 + 312159, nil, 446 - (15 + 398)),BlisteringScales=v16(361809 - (18 + 964), nil, 127 - 93),BreathofEons=v16(233688 + 169943, nil, 23 + 12),DreamofSpring=v16(415819 - (20 + 830), nil, 29 + 7),EbonMight=v16(395278 - (116 + 10), nil, 3 + 34),Eruption=v16(395898 - (542 + 196), nil, 81 - 43),FontofMagic=v16(119167 + 288916, nil, 20 + 19),InterwovenThreads=v16(148563 + 264150, nil, 105 - 65),Prescience=v16(1049387 - 640076, nil, 1592 - (1126 + 425)),PupilofAlexstrasza=v16(408219 - (118 + 287), nil, 164 - 122),TimeSkip=v16(406098 - (118 + 1003), nil, 125 - 82),Upheaval=v16(408469 - (142 + 235), nil, 199 - 155),BlackAttunementBuff=v16(87746 + 315518, nil, 1022 - (553 + 424)),BlisteringScalesBuff=v16(682308 - 321481, nil, 41 + 5),BronzeAttunementBuff=v16(400032 + 3233, nil, 28 + 19),EbonMightOtherBuff=v16(167976 + 227176, nil, 28 + 20),EbonMightSelfBuff=v16(856959 - 461663, nil, 136 - 87),EssenceBurstBuff=v16(878304 - 486036, nil, 15 + 35),PrescienceBuff=v16(1981820 - 1571731, nil, 1003 - (239 + 514)),TemporalWoundDebuff=v16(143842 + 265718, nil, 1380 - (797 + 532))});
	v16.Evoker.Devastation = v19(v16.Evoker.Commons, {Animosity=v16(273060 + 102737, nil, 18 + 34),ArcaneVigor=v16(908388 - 522046, nil, 1255 - (373 + 829)),Burnout=v16(376532 - (476 + 255), nil, 1184 - (369 + 761)),Catalyze=v16(223454 + 162829, nil, 99 - 44),Causality=v16(712099 - 336322, nil, 294 - (64 + 174)),ChargedBlast=v16(52762 + 317693, nil, 84 - 27),Dragonrage=v16(375423 - (144 + 192), nil, 274 - (42 + 174)),EngulfingBlaze=v16(278586 + 92251, nil, 49 + 10),EssenceAttunement=v16(159623 + 216099, nil, 1564 - (363 + 1141)),EternitySurge=v17(1677 - (1183 + 397), 1093141 - 734068, 280325 + 102086),EternitysSpan=v16(280863 + 94894, nil, 2036 - (1913 + 62)),EventHorizon=v16(258943 + 152221, nil, 163 - 101),EverburningFlame=v16(372752 - (565 + 1368), nil, 236 - 173),EyeofInfinity=v16(371036 - (1477 + 184), nil, 87 - 23),FeedtheFlames=v16(344605 + 25241, nil, 921 - (564 + 292)),Firestorm=v16(636418 - 267571, nil, 198 - 132),FontofMagic=v16(376087 - (244 + 60), nil, 52 + 15),ImminentDestruction=v16(371257 - (41 + 435), nil, 1069 - (938 + 63)),Pyre=v16(274723 + 82488, nil, 1194 - (936 + 189)),RagingInferno=v16(133503 + 272156, nil, 1683 - (1565 + 48)),RubyEmbers=v16(226046 + 139891, nil, 1209 - (782 + 356)),Scintillation=v16(371088 - (176 + 91), nil, 187 - 115),ShatteringStar=v16(545975 - 175523, nil, 1165 - (975 + 117)),Snapfire=v16(372658 - (157 + 1718), nil, 61 + 13),Tyranny=v16(1337923 - 961035, nil, 256 - 181),Volatility=v16(370107 - (697 + 321), nil, 206 - 130),BlazingShardsBuff=v16(868308 - 458460, nil, 177 - 100),BurnoutBuff=v16(146279 + 229523, nil, 145 - 67),ChargedBlastBuff=v16(993080 - 622626, nil, 1306 - (322 + 905)),EmeraldTranceBuff=v16(424766 - (602 + 9), nil, 1319 - (449 + 740)),EssenceBurstBuff=v16(360490 - (826 + 46), nil, 1027 - (245 + 702)),IridescenceBlueBuff=v17(309 - 211, 124216 + 262183, 401268 - (260 + 1638)),IridescenceRedBuff=v16(386793 - (382 + 58), nil, 259 - 178),LimitlessPotentialBuff=v16(327731 + 66671, nil, 169 - 87),PowerSwellBuff=v16(1120226 - 743376, nil, 1288 - (902 + 303)),SnapfireBuff=v16(814183 - 443365, nil, 202 - 118),LivingFlameDebuff=v16(31065 + 330435, nil, 1775 - (1121 + 569))});
	v16.Evoker.Preservation = v19(v16.Evoker.Commons, {DreamBreath=v17(313 - (22 + 192), 356619 - (483 + 200), 384077 - (1404 + 59)),DreamFlight=v16(984722 - 624906, nil, 115 - 29),Echo=v16(365108 - (468 + 297), nil, 649 - (334 + 228)),MassReturn=v16(1218248 - 857070, nil, 203 - 115),Spiritbloom=v17(181 - 81, 104279 + 262947, 382967 - (141 + 95)),Stasis=v16(363982 + 6555, nil, 228 - 139),StasisReactivate=v16(890803 - 520239, nil, 22 + 68),TemporalAnomaly=v16(1024334 - 650473, nil, 64 + 27),TimeDilation=v16(185988 + 171182, nil, 128 - 36),Reversion=v17(60 + 41, 366318 - (92 + 71), 181458 + 185906),Rewind=v16(611208 - 247674, nil, 858 - (574 + 191)),FontofMagic=v16(309970 + 65813, nil, 167 - 100),CauterizingFlame=v16(191164 + 183087, nil, 1792 - (254 + 595)),EssenceBurstBuff=v16(369425 - (55 + 71), nil, 123 - 29),StasisBuff=v16(372352 - (573 + 1217), nil, 263 - 168)});
	if (((359 + 4347) > (7136 - 2707)) and not v18.Evoker) then
		v18.Evoker = {};
	end
	v18.Evoker.Commons = {Healthstone=v18(6451 - (714 + 225)),CrimsonAspirantsBadgeofFerocity=v18(588714 - 387265, {(2 + 11),(820 - (118 + 688))}),BelorrelostheSuncaller=v18(207220 - (25 + 23), {(1899 - (927 + 959)),(746 - (16 + 716))}),DragonfireBombDispenser=v18(391119 - 188509, {(31 - 18),(35 - 21)}),NymuesUnravelingSpindle=v18(1028941 - 820326, {(36 - 23),(1075 - (810 + 251))}),Dreambinder=v18(144775 + 63841, {(15 + 1)}),Iridal=v18(208854 - (43 + 490), {(61 - 45)}),KharnalexTheFirstLight=v18(196378 - (240 + 619)),SpoilsofNeltharus=v18(46760 + 147013, {(1 + 12),(419 - (255 + 150))}),ShadowedOrbofTorment=v18(146845 + 39583, {(55 - 42),(1753 - (404 + 1335))}),RefreshingHealingPotion=v18(191786 - (183 + 223))};
	v18.Evoker.Devastation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Preservation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Augmentation = v19(v18.Evoker.Commons, {});
	if (((3472 - 618) < (2714 + 1381)) and not v21.Evoker) then
		v21.Evoker = {};
	end
	v21.Evoker.Commons = {Healthstone=v21(14 + 23),AzureStrikeMouseover=v21(375 - (10 + 327)),DeepBreathCursor=v21(28 + 11),CauterizingFlameFocus=v21(378 - (118 + 220)),EmeraldBlossomFocus=v21(14 + 27),FireBreathMacro=v21(491 - (108 + 341)),LivingFlameFocus=v21(20 + 23),QuellMouseover=v21(185 - 141),VerdantEmbraceFocus=v21(1503 - (711 + 782)),RefreshingHealingPotion=v21(63 - 30),ExpungeMouseover=v21(503 - (270 + 199)),ExpungeFocus=v21(12 + 23),SleepwalkMouseover=v21(1855 - (580 + 1239)),VerdantEmbracePlayer=v21(85 - 56),EmeraldBlossomPlayer=v21(30 + 1),SourceofMagicFocus=v21(1 + 21),SourceofMagicName=v21(11 + 12)};
	v21.Evoker.Devastation = v19(v21.Evoker.Commons, {EternitySurgeMacro=v21(28 - 17)});
	v21.Evoker.Preservation = v19(v21.Evoker.Commons, {DreamBreathMacro=v21(8 + 4),DreamFlightCursor=v21(1180 - (645 + 522)),EchoFocus=v21(1804 - (1010 + 780)),SpiritbloomFocus=v21(15 + 0),TimeDilationFocus=v21(76 - 60),TipTheScalesDreamBreath=v21(49 - 32),TipTheScalesSpiritbloom=v21(1854 - (1045 + 791)),ReversionFocus=v21(47 - 28),EchoMouseover=v21(69 - 23),LivingFlameMouseover=v21(552 - (351 + 154))});
	v21.Evoker.Augmentation = v19(v21.Evoker.Commons, {BlisteringScalesFocus=v21(1594 - (1281 + 293)),BlisteringScalesName=v21(287 - (28 + 238)),PrescienceName1=v21(53 - 29),PrescienceName2=v21(1584 - (1381 + 178)),PrescienceName3=v21(25 + 1),PrescienceName4=v21(22 + 5),PrescienceFocus=v21(12 + 16),BreathofEonsCursor=v21(155 - 110)});
	v20.Commons.Evoker = {};
	local v35 = v20.Commons.Evoker;
	v35.FirestormTracker = {};
	v10:RegisterForEvent(function(v42, v43, v44)
		local v45 = 0 + 0;
		while true do
			if ((v45 == (470 - (381 + 89))) or ((939 + 119) >= (813 + 389))) then
				if (((6356 - 2645) > (4511 - (1074 + 82))) and (v43 ~= "player")) then
					return;
				end
				if ((v44 == "ESSENCE") or ((1985 - 1079) >= (4013 - (214 + 1570)))) then
					v11.Persistent.Player.LastPowerUpdate = GetTime();
				end
				break;
			end
		end
	end, "UNIT_POWER_UPDATE");
	v10:RegisterForSelfCombatEvent(function(v46, v46, v46, v46, v46, v46, v46, v47, v46, v46, v46, v48)
		if (((2743 - (990 + 465)) > (516 + 735)) and (v48 == (160723 + 208651))) then
			v35.FirestormTracker[v47] = GetTime();
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForCombatEvent(function(v49, v49, v49, v49, v49, v49, v49, v50)
		if (v35.FirestormTracker[v50] or ((4389 + 124) < (13191 - 9839))) then
			v35.FirestormTracker[v50] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v51, v52, v53, v54, v55, v56)
		local v57 = 1726 - (1668 + 58);
		local v58;
		local v59;
		while true do
			if ((v57 == (627 - (512 + 114))) or ((5383 - 3318) >= (6606 - 3410))) then
				v59 = v37(v51, v52, v53, v54, v55, v56);
				if ((v51 == v16.Evoker.Devastation.Firestorm) or ((15226 - 10850) <= (689 + 792))) then
					return v59 and not v13:IsCasting(v51);
				elseif ((v51 == v16.Evoker.Devastation.TipTheScales) or ((635 + 2757) >= (4122 + 619))) then
					return v59 and not v13:BuffUp(v51);
				else
					return v59;
				end
				break;
			end
			if (((11215 - 7890) >= (4148 - (109 + 1885))) and (v57 == (1469 - (1269 + 200)))) then
				v58 = true;
				if (v53 or ((2482 - 1187) >= (4048 - (98 + 717)))) then
					local v144 = 826 - (802 + 24);
					local v145;
					while true do
						if (((7547 - 3170) > (2073 - 431)) and (v144 == (0 + 0))) then
							v145 = v55 or v14;
							v58 = v145:IsInRange(v53, v54);
							break;
						end
					end
				end
				v57 = 1 + 0;
			end
		end
	end, 241 + 1226);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v60 = 0 + 0;
		local v61;
		local v62;
		local v63;
		local v64;
		while true do
			if (((13139 - 8416) > (4521 - 3165)) and (v60 == (2 + 1))) then
				return (v61 * v63) - (GetTime() - v64);
			end
			if ((v60 == (0 + 0)) or ((3412 + 724) <= (2497 + 936))) then
				v61 = v13:EssenceDeficit();
				if (((1982 + 2263) <= (6064 - (797 + 636))) and (v61 == (0 - 0))) then
					return 1619 - (1427 + 192);
				end
				v60 = 1 + 0;
			end
			if (((9927 - 5651) >= (3519 + 395)) and (v60 == (1 + 1))) then
				v63 = (327 - (192 + 134)) / v62;
				v64 = v11.Persistent.Player.LastPowerUpdate;
				v60 = 1279 - (316 + 960);
			end
			if (((111 + 87) <= (3369 + 996)) and (v60 == (1 + 0))) then
				v62 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (((18281 - 13499) > (5227 - (83 + 468))) and (not v62 or (v62 < (1806.2 - (1202 + 604))))) then
					v62 = 0.2 - 0;
				end
				v60 = 2 - 0;
			end
		end
	end, 4061 - 2594);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v65)
		local v66 = 325 - (45 + 280);
		local v67;
		local v68;
		local v69;
		local v70;
		while true do
			if (((4695 + 169) > (1920 + 277)) and (v66 == (1 + 1))) then
				v70 = v11.Persistent.Player.LastPowerUpdate;
				return ((v65 - v67) * v69) - (GetTime() - v70);
			end
			if ((v66 == (1 + 0)) or ((651 + 3049) == (4642 - 2135))) then
				v68 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v69 = (1912 - (340 + 1571)) / v68;
				v66 = 1 + 1;
			end
			if (((6246 - (1733 + 39)) >= (752 - 478)) and (v66 == (1034 - (125 + 909)))) then
				v67 = v13:Essence();
				if ((v67 >= v65) or ((3842 - (1096 + 852)) <= (631 + 775))) then
					return 0 - 0;
				end
				v66 = 1 + 0;
			end
		end
	end, 1979 - (409 + 103));
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v71 = 236 - (46 + 190);
		local v72;
		local v73;
		local v74;
		local v75;
		while true do
			if (((1667 - (51 + 44)) >= (432 + 1099)) and (v71 == (1320 - (1114 + 203)))) then
				return (v72 * v74) - (GetTime() - v75);
			end
			if ((v71 == (728 - (228 + 498))) or ((1016 + 3671) < (2510 + 2032))) then
				v74 = (664 - (174 + 489)) / v73;
				v75 = v11.Persistent.Player.LastPowerUpdate;
				v71 = 7 - 4;
			end
			if (((5196 - (830 + 1075)) > (2191 - (303 + 221))) and (v71 == (1269 - (231 + 1038)))) then
				v72 = v13:EssenceDeficit();
				if ((v72 == (0 + 0)) or ((2035 - (171 + 991)) == (8382 - 6348))) then
					return 0 - 0;
				end
				v71 = 2 - 1;
			end
			if ((v71 == (1 + 0)) or ((9871 - 7055) < (31 - 20))) then
				v73 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (((5962 - 2263) < (14547 - 9841)) and (not v73 or (v73 < (1248.2 - (111 + 1137))))) then
					v73 = 158.2 - (91 + 67);
				end
				v71 = 5 - 3;
			end
		end
	end, 367 + 1101);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v76)
		local v77 = v13:Essence();
		if (((3169 - (423 + 100)) >= (7 + 869)) and (v77 >= v76)) then
			return 0 - 0;
		end
		local v78 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		local v79 = (1 + 0) / v78;
		local v80 = v11.Persistent.Player.LastPowerUpdate;
		return ((v76 - v77) * v79) - (GetTime() - v80);
	end, 2239 - (326 + 445));
	local v38;
	v38 = v10.AddCoreOverride("Spell.IsCastable", function(v81, v82, v83, v84, v85, v86)
		local v87 = 0 - 0;
		local v88;
		local v89;
		while true do
			if (((1367 - 753) <= (7432 - 4248)) and (v87 == (711 - (530 + 181)))) then
				v88 = true;
				if (((4007 - (614 + 267)) == (3158 - (19 + 13))) and v83) then
					local v146 = 0 - 0;
					local v147;
					while true do
						if (((0 - 0) == v146) or ((6247 - 4060) >= (1287 + 3667))) then
							v147 = v85 or v14;
							v88 = v147:IsInRange(v83, v84);
							break;
						end
					end
				end
				v87 = 1 - 0;
			end
			if ((v87 == (1 - 0)) or ((5689 - (1293 + 519)) == (7294 - 3719))) then
				v89 = v38(v81, v82, v83, v84, v85, v86);
				if (((1845 - 1138) > (1208 - 576)) and ((v81 == v16.Evoker.Augmentation.TipTheScales) or (v81 == v16.Evoker.Augmentation.Upheaval) or (v81 == v16.Evoker.Augmentation.FireBreath))) then
					return v89 and not v13:BuffUp(v81);
				else
					return v89;
				end
				break;
			end
		end
	end, 6351 - 4878);
	local v39;
	v39 = v10.AddCoreOverride("Spell.IsReady", function(v90, v91, v92, v93, v94, v95)
		local v96 = 0 - 0;
		local v97;
		local v98;
		while true do
			if ((v96 == (0 + 0)) or ((112 + 434) >= (6236 - 3552))) then
				v97 = true;
				if (((339 + 1126) <= (1429 + 2872)) and v92) then
					local v148 = 0 + 0;
					local v149;
					while true do
						if (((2800 - (709 + 387)) > (3283 - (673 + 1185))) and (v148 == (0 - 0))) then
							v149 = v94 or v14;
							v97 = v149:IsInRange(v92, v93);
							break;
						end
					end
				end
				v96 = 3 - 2;
			end
			if ((v96 == (1 - 0)) or ((492 + 195) == (3164 + 1070))) then
				v98 = v39(v90, v91, v92, v93, v94, v95);
				if ((v90 == v16.Evoker.Augmentation.Eruption) or ((4496 - 1166) < (351 + 1078))) then
					return v98 and (v13:EssenceP() >= (3 - 1));
				elseif (((2251 - 1104) >= (2215 - (446 + 1434))) and (v90 == v16.Evoker.Augmentation.EbonMight)) then
					return v98 and not v13:IsCasting(v90);
				elseif (((4718 - (1040 + 243)) > (6258 - 4161)) and (v90 == v16.Evoker.Augmentation.Unravel)) then
					return v98 and v14:EnemyAbsorb();
				else
					return v98;
				end
				break;
			end
		end
	end, 3320 - (559 + 1288));
	local v40;
	v40 = v10.AddCoreOverride("Player.IsMoving", function(v99)
		local v100 = v40(v99);
		return v100 and v13:BuffDown(v16.Evoker.Augmentation.HoverBuff);
	end, 3404 - (609 + 1322));
	local v41;
	v41 = v10.AddCoreOverride("Player.BuffRemains", function(v101, v102, v103, v104)
		if ((v102 == v102.Evoker.Augmentation.EbonMightSelfBuff) or ((4224 - (13 + 441)) >= (15100 - 11059))) then
			return (v101:IsCasting(v102.Evoker.Augmentation.EbonMight) and (26 - 16)) or v41(v101, v102, v103, v104);
		else
			return v41(v101, v102, v103, v104);
		end
	end, 7336 - 5863);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v105, v106)
		local v107 = 0 + 0;
		local v108;
		local v109;
		local v110;
		while true do
			if ((v107 == (7 - 5)) or ((1347 + 2444) <= (706 + 905))) then
				return ((2 - 1) + ((0.75 + 0) * (v106 - (1 - 0)))) * v108 * v109;
			end
			if ((v107 == (1 + 0)) or ((2547 + 2031) <= (1443 + 565))) then
				v110 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (4 + 0)) or (3 + 0);
				if (((1558 - (153 + 280)) <= (5994 - 3918)) and not v106) then
					v106 = v110;
				end
				v107 = 2 + 0;
			end
			if ((v107 == (0 + 0)) or ((389 + 354) >= (3993 + 406))) then
				v108 = v13:SpellHaste();
				v109 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (0.8 + 0)) or (1 - 0);
				v107 = 1 + 0;
			end
		end
	end, 2140 - (89 + 578));
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v111, v112)
		local v113 = 0 + 0;
		local v114;
		local v115;
		local v116;
		while true do
			if (((2400 - 1245) < (2722 - (572 + 477))) and ((1 + 1) == v113)) then
				return (1 + 0 + ((0.75 + 0) * (v112 - (87 - (84 + 2))))) * v114 * v115;
			end
			if ((v113 == (0 - 0)) or ((1675 + 649) <= (1420 - (497 + 345)))) then
				v114 = v13:SpellHaste();
				v115 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (0.8 + 0)) or (1 + 0);
				v113 = 1334 - (605 + 728);
			end
			if (((2688 + 1079) == (8374 - 4607)) and ((1 + 0) == v113)) then
				v116 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (14 - 10)) or (3 + 0);
				if (((11328 - 7239) == (3088 + 1001)) and not v112) then
					v112 = v116;
				end
				v113 = 491 - (457 + 32);
			end
		end
	end, 623 + 844);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v117, v118)
		local v119 = 1402 - (832 + 570);
		local v120;
		local v121;
		local v122;
		while true do
			if (((4200 + 258) >= (437 + 1237)) and ((0 - 0) == v119)) then
				v120 = v13:SpellHaste();
				v121 = 1 + 0;
				v119 = 797 - (588 + 208);
			end
			if (((2619 - 1647) <= (3218 - (884 + 916))) and (v119 == (1 - 0))) then
				v122 = ((v16.Evoker.Preservation.FontofMagic:IsAvailable()) and (3 + 1)) or (656 - (232 + 421));
				if (not v118 or ((6827 - (1569 + 320)) < (1169 + 3593))) then
					v118 = v122;
				end
				v119 = 1 + 1;
			end
			if ((v119 == (6 - 4)) or ((3109 - (316 + 289)) > (11161 - 6897))) then
				return (1 + 0 + ((1453.75 - (666 + 787)) * (v118 - (426 - (360 + 65))))) * v120 * v121;
			end
		end
	end, 1372 + 96);
	v10.AddCoreOverride("Player.EssenceP", function()
		local v123 = 254 - (79 + 175);
		local v124;
		while true do
			if (((3394 - 1241) == (1681 + 472)) and ((0 - 0) == v123)) then
				v124 = v13:Essence();
				if ((not v13:IsCasting() and not v13:IsChanneling()) or ((975 - 468) >= (3490 - (503 + 396)))) then
					return v124;
				elseif (((4662 - (92 + 89)) == (8692 - 4211)) and v13:IsCasting(v16.Evoker.Augmentation.Eruption) and v13:BuffDown(v16.Evoker.Augmentation.EssenceBurstBuff)) then
					return v124 - (2 + 0);
				else
					return v124;
				end
				break;
			end
		end
	end, 872 + 601);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v125 = v13:EssenceDeficit();
		if ((v125 == (0 - 0)) or ((319 + 2009) < (1579 - 886))) then
			return 0 + 0;
		end
		local v126 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		if (((2068 + 2260) == (13181 - 8853)) and (not v126 or (v126 < (0.2 + 0)))) then
			v126 = 0.2 - 0;
		end
		local v127 = (1245 - (485 + 759)) / v126;
		local v128 = v11.Persistent.Player.LastPowerUpdate;
		return (v125 * v127) - (GetTime() - v128);
	end, 3408 - 1935);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v129)
		local v130 = v13:Essence();
		if (((2777 - (442 + 747)) >= (2467 - (832 + 303))) and (v130 >= v129)) then
			return 946 - (88 + 858);
		end
		local v131 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		local v132 = (1 + 0) / v131;
		local v133 = v11.Persistent.Player.LastPowerUpdate;
		return ((v129 - v130) * v132) - (GetTime() - v133);
	end, 1220 + 253);
end;
return v0["Epix_Evoker_Evoker.lua"]();

