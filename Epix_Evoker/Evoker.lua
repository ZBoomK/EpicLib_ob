local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((11935 - 8965) > (1031 + 303)) and (v5 == (652 - (494 + 157)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((1432 + 597) >= (319 + 3455))) then
			v6 = v0[v4];
			if (((1703 + 2118) > (2686 - (660 + 176))) and not v6) then
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
	if (not v16.Evoker or ((1818 - (14 + 188)) == (3044 - (534 + 141)))) then
		v16.Evoker = {};
	end
	v16.Evoker.Commons = {TailSwipe=v16(148333 + 220637, nil, 1 + 0),WingBuffet=v16(343442 + 13772, nil, 3 - 1),AzureStrike=v16(576256 - 213287, nil, 8 - 5),BlessingoftheBronze=v16(195643 + 168699, nil, 3 + 1),DeepBreath=v16(357606 - (115 + 281), nil, 11 - 6),Disintegrate=v16(295572 + 61423, nil, 14 - 8),EmeraldBlossom=v16(1305061 - 949148, nil, 874 - (550 + 317)),FireBreath=v17(138 - 42, 502081 - 144873, 1068234 - 685968),LivingFlame=v16(361754 - (134 + 151), nil, 1673 - (970 + 695)),OppressingRoar=v16(709955 - 337907, nil, 2092 - (582 + 1408)),Expunge=v16(1267877 - 902292, nil, 129 - 26),Sleepwalk=v16(1359645 - 998839, nil, 1928 - (1195 + 629)),RenewingBlaze=v16(495074 - 120726, nil, 346 - (187 + 54)),Hover=v16(359047 - (162 + 618), nil, 75 + 31),AncientFlame=v16(246429 + 123561, nil, 18 - 9),BlastFurnace=v16(631304 - 255794, nil, 1 + 9),LeapingFlames=v16(371575 - (1373 + 263), nil, 1011 - (451 + 549)),ObsidianScales=v16(114874 + 249042, nil, 18 - 6),ScarletAdaptation=v16(625993 - 253524, nil, 1397 - (746 + 638)),SourceofMagic=v16(139042 + 230417, nil, 20 - 6),TipTheScales=v16(370894 - (218 + 123), nil, 1596 - (1535 + 46)),Unravel=v16(366075 + 2357, nil, 3 + 13),VerdantEmbrace=v16(361555 - (306 + 254), nil, 2 + 15),AncientFlameBuff=v16(737096 - 361513, nil, 1485 - (899 + 568)),BlessingoftheBronzeBuff=v16(250923 + 130825, nil, 45 - 26),FireBreathDebuff=v16(357812 - (268 + 335), nil, 310 - (60 + 230)),HoverBuff=v16(358839 - (426 + 146), nil, 3 + 18),LeapingFlamesBuff=v16(372357 - (282 + 1174), nil, 833 - (569 + 242)),PowerInfusionBuff=v16(28978 - 18918, nil, 2 + 21),ScarletAdaptationBuff=v16(373494 - (706 + 318), nil, 1275 - (721 + 530)),SourceofMagicBuff=v16(370730 - (945 + 326), nil, 62 - 37),SpoilsofNeltharusCrit=v16(339870 + 42084, nil, 726 - (271 + 429)),SpoilsofNeltharusHaste=v16(350865 + 31090, nil, 1527 - (1408 + 92)),SpoilsofNeltharusMastery=v16(383042 - (461 + 625), nil, 1316 - (993 + 295)),SpoilsofNeltharusVers=v16(19834 + 362123, nil, 1200 - (418 + 753)),Quell=v16(133809 + 217529, nil, 4 + 26),Pool=v16(292457 + 707453, nil, 8 + 23)};
	v16.Evoker.Augmentation = v19(v16.Evoker.Commons, {BlackAttunement=v16(403793 - (406 + 123), nil, 1801 - (1749 + 20)),BronzeAttunement=v16(95787 + 307478, nil, 1355 - (1249 + 73)),BlisteringScales=v16(128732 + 232095, nil, 1179 - (466 + 679)),BreathofEons=v16(970922 - 567291, nil, 100 - 65),DreamofSpring=v16(416869 - (106 + 1794), nil, 12 + 24),EbonMight=v16(99887 + 295265, nil, 109 - 72),Eruption=v16(1070069 - 674909, nil, 152 - (4 + 110)),FontofMagic=v16(408667 - (57 + 527), nil, 1466 - (41 + 1386)),InterwovenThreads=v16(412816 - (17 + 86), nil, 28 + 12),Prescience=v16(912810 - 503499, nil, 118 - 77),PupilofAlexstrasza=v16(407980 - (122 + 44), nil, 71 - 29),TimeSkip=v16(1343499 - 938522, nil, 35 + 8),Upheaval=v16(59020 + 349072, nil, 88 - 44),BlackAttunementBuff=v16(403329 - (30 + 35), nil, 31 + 14),BlisteringScalesBuff=v16(362084 - (1043 + 214), nil, 173 - 127),BronzeAttunementBuff=v16(404477 - (323 + 889), nil, 126 - 79),EbonMightOtherBuff=v16(395732 - (361 + 219), nil, 368 - (53 + 267)),EbonMightSelfBuff=v16(89306 + 305990, nil, 462 - (15 + 398)),EssenceBurstBuff=v16(393250 - (18 + 964), nil, 188 - 138),PrescienceBuff=v16(237426 + 172663, nil, 158 + 92),TemporalWoundDebuff=v16(410410 - (20 + 830), nil, 40 + 11)});
	v16.Evoker.Devastation = v19(v16.Evoker.Commons, {Animosity=v16(375923 - (116 + 10), nil, 4 + 48),ArcaneVigor=v16(387080 - (542 + 196), nil, 113 - 60),Burnout=v16(109740 + 266061, nil, 28 + 26),Catalyze=v16(139049 + 247234, nil, 144 - 89),Causality=v16(963413 - 587636, nil, 1607 - (1126 + 425)),ChargedBlast=v16(370860 - (118 + 287), nil, 223 - 166),Dragonrage=v16(376208 - (118 + 1003), nil, 169 - 111),EngulfingBlaze=v16(371214 - (142 + 235), nil, 267 - 208),EssenceAttunement=v16(81753 + 293969, nil, 1037 - (553 + 424)),EternitySurge=v17(183 - 86, 316314 + 42759, 379345 + 3066),EternitysSpan=v16(218787 + 156970, nil, 26 + 35),EventHorizon=v16(234804 + 176360, nil, 134 - 72),EverburningFlame=v16(1033218 - 662399, nil, 140 - 77),EyeofInfinity=v16(107412 + 261963, nil, 309 - 245),FeedtheFlames=v16(370599 - (239 + 514), nil, 23 + 42),Firestorm=v16(370176 - (797 + 532), nil, 48 + 18),FontofMagic=v16(126772 + 249011, nil, 157 - 90),ImminentDestruction=v16(371983 - (373 + 829), nil, 799 - (476 + 255)),Pyre=v16(358341 - (369 + 761), nil, 40 + 29),RagingInferno=v16(736834 - 331175, nil, 132 - 62),RubyEmbers=v16(366175 - (64 + 174), nil, 11 + 60),Scintillation=v16(549163 - 178342, nil, 408 - (144 + 192)),ShatteringStar=v16(370668 - (42 + 174), nil, 55 + 18),Snapfire=v16(307147 + 63636, nil, 32 + 42),Tyranny=v16(378392 - (363 + 1141), nil, 1655 - (1183 + 397)),Volatility=v16(1123633 - 754544, nil, 56 + 20),BlazingShardsBuff=v16(306344 + 103504, nil, 2052 - (1913 + 62)),BurnoutBuff=v16(236673 + 139129, nil, 206 - 128),ChargedBlastBuff=v16(372387 - (565 + 1368), nil, 297 - 218),EmeraldTranceBuff=v16(425816 - (1477 + 184), nil, XXXXX),EssenceBurstBuff=v16(490009 - 130391, nil, 75 + 5),IridescenceBlueBuff=v17(954 - (564 + 292), 666702 - 280303, 1203768 - 804398),IridescenceRedBuff=v16(386657 - (244 + 60), nil, 63 + 18),LimitlessPotentialBuff=v16(394878 - (41 + 435), nil, 1083 - (938 + 63)),PowerSwellBuff=v16(289827 + 87023, nil, 1208 - (936 + 189)),SnapfireBuff=v16(122037 + 248781, nil, 1697 - (1565 + 48)),LivingFlameDebuff=v16(223305 + 138195, nil, 1223 - (782 + 356))});
	v16.Evoker.Preservation = v19(v16.Evoker.Commons, {DreamBreath=v17(366 - (176 + 91), 927330 - 571394, 563900 - 181286),DreamFlight=v16(360908 - (975 + 117), nil, 1961 - (157 + 1718)),Echo=v16(295685 + 68658, nil, 308 - 221),MassReturn=v16(1234799 - 873621, nil, 1106 - (697 + 321)),Spiritbloom=v17(272 - 172, 778009 - 410783, 882341 - 499610),Stasis=v16(144229 + 226308, nil, 166 - 77),StasisReactivate=v16(993375 - 622811, nil, 1317 - (322 + 905)),TemporalAnomaly=v16(374472 - (602 + 9), nil, 1280 - (449 + 740)),TimeDilation=v16(358042 - (826 + 46), nil, 1039 - (245 + 702)),Reversion=v17(319 - 218, 117708 + 248447, 369262 - (260 + 1638)),Rewind=v16(363974 - (382 + 58), nil, 298 - 205),FontofMagic=v16(312260 + 63523, nil, 138 - 71),CauterizingFlame=v16(1112500 - 738249, nil, 1299 - (902 + 303)),EssenceBurstBuff=v16(810847 - 441548, nil, 226 - 132),StasisBuff=v16(31843 + 338719, nil, 1785 - (1121 + 569))});
	if (not v18.Evoker or ((1468 - (22 + 192)) >= (2408 - (483 + 200)))) then
		v18.Evoker = {};
	end
	v18.Evoker.Commons = {Healthstone=v18(6975 - (1404 + 59)),CrimsonAspirantsBadgeofFerocity=v18(551313 - 349864, {(778 - (468 + 297)),(47 - 33)}),BelorrelostheSuncaller=v18(480205 - 273033, {(4 + 9),(14 + 0)}),DragonfireBombDispenser=v18(521519 - 318909, {(4 + 9),(10 + 4)}),NymuesUnravelingSpindle=v18(108632 + 99983, {(8 + 5),(7 + 7)}),Dreambinder=v18(350745 - 142129, {(14 + 2)}),Iridal=v18(521907 - 313586, {(865 - (254 + 595))}),KharnalexTheFirstLight=v18(195645 - (55 + 71)),SpoilsofNeltharus=v18(255274 - 61501, {(35 - 22),(21 - 7)}),ShadowedOrbofTorment=v18(187367 - (714 + 225), {(17 - 4),(20 - 6)}),RefreshingHealingPotion=v18(192186 - (118 + 688))};
	v18.Evoker.Devastation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Preservation = v19(v18.Evoker.Commons, {});
	v18.Evoker.Augmentation = v19(v18.Evoker.Commons, {});
	if (not v21.Evoker or ((457 - (25 + 23)) >= (741 + 3083))) then
		v21.Evoker = {};
	end
	v21.Evoker.Commons = {Healthstone=v21(1923 - (927 + 959)),AzureStrikeMouseover=v21(128 - 90),DeepBreathCursor=v21(771 - (16 + 716)),CauterizingFlameFocus=v21(77 - 37),EmeraldBlossomFocus=v21(138 - (11 + 86)),FireBreathMacro=v21(102 - 60),LivingFlameFocus=v21(328 - (175 + 110)),QuellMouseover=v21(110 - 66),VerdantEmbraceFocus=v21(49 - 39),RefreshingHealingPotion=v21(1829 - (503 + 1293)),ExpungeMouseover=v21(94 - 60),ExpungeFocus=v21(26 + 9),SleepwalkMouseover=v21(1097 - (810 + 251)),VerdantEmbracePlayer=v21(21 + 8),EmeraldBlossomPlayer=v21(10 + 21),SourceofMagicFocus=v21(20 + 2),SourceofMagicName=v21(556 - (43 + 490))};
	v21.Evoker.Devastation = v19(v21.Evoker.Commons, {EternitySurgeMacro=v21(744 - (711 + 22))});
	v21.Evoker.Preservation = v19(v21.Evoker.Commons, {DreamBreathMacro=v21(46 - 34),DreamFlightCursor=v21(872 - (240 + 619)),EchoFocus=v21(4 + 10),SpiritbloomFocus=v21(23 - 8),TimeDilationFocus=v21(2 + 14),TipTheScalesDreamBreath=v21(1761 - (1344 + 400)),TipTheScalesSpiritbloom=v21(423 - (255 + 150)),ReversionFocus=v21(15 + 4),EchoMouseover=v21(25 + 21),LivingFlameMouseover=v21(200 - 153)});
	v21.Evoker.Augmentation = v19(v21.Evoker.Commons, {BlisteringScalesFocus=v21(64 - 44),BlisteringScalesName=v21(1760 - (404 + 1335)),PrescienceName1=v21(430 - (183 + 223)),PrescienceName2=v21(30 - 5),PrescienceName3=v21(18 + 8),PrescienceName4=v21(10 + 17),PrescienceFocus=v21(365 - (10 + 327)),BreathofEonsCursor=v21(32 + 13)});
	v20.Commons.Evoker = {};
	local v35 = v20.Commons.Evoker;
	v35.FirestormTracker = {};
	v10:RegisterForEvent(function(v42, v43, v44)
		if (((2425 - (118 + 220)) == (696 + 1391)) and (v43 ~= "player")) then
			return;
		end
		if ((v44 == "ESSENCE") or ((3853 - (108 + 341)) > (2023 + 2480))) then
			v11.Persistent.Player.LastPowerUpdate = GetTime();
		end
	end, "UNIT_POWER_UPDATE");
	v10:RegisterForSelfCombatEvent(function(v45, v45, v45, v45, v45, v45, v45, v46, v45, v45, v45, v47)
		if ((v47 == (1561641 - 1192267)) or ((4999 - (711 + 782)) <= (2508 - 1199))) then
			v35.FirestormTracker[v46] = GetTime();
		end
	end, "SPELL_DAMAGE");
	v10:RegisterForCombatEvent(function(v48, v48, v48, v48, v48, v48, v48, v49)
		if (((3424 - (270 + 199)) == (958 + 1997)) and v35.FirestormTracker[v49]) then
			v35.FirestormTracker[v49] = nil;
		end
	end, "UNIT_DIED", "UNIT_DESTROYED");
	local v37;
	v37 = v10.AddCoreOverride("Spell.IsCastable", function(v50, v51, v52, v53, v54, v55)
		local v56 = 1819 - (580 + 1239);
		local v57;
		local v58;
		while true do
			if ((v56 == (2 - 1)) or ((2776 + 127) == (54 + 1441))) then
				v58 = v37(v50, v51, v52, v53, v54, v55);
				if (((1981 + 2565) >= (5939 - 3664)) and (v50 == v16.Evoker.Devastation.Firestorm)) then
					return v58 and not v13:IsCasting(v50);
				elseif (((509 + 310) >= (1189 - (645 + 522))) and (v50 == v16.Evoker.Devastation.TipTheScales)) then
					return v58 and not v13:BuffUp(v50);
				else
					return v58;
				end
				break;
			end
			if (((4952 - (1010 + 780)) == (3161 + 1)) and (v56 == (0 - 0))) then
				v57 = true;
				if (v52 or ((6942 - 4573) > (6265 - (1045 + 791)))) then
					local v144 = v54 or v14;
					v57 = v144:IsInRange(v52, v53);
				end
				v56 = 2 - 1;
			end
		end
	end, 2239 - 772);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v59 = 505 - (351 + 154);
		local v60;
		local v61;
		local v62;
		local v63;
		while true do
			if (((5669 - (1281 + 293)) >= (3449 - (28 + 238))) and (v59 == (6 - 3))) then
				return (v60 * v62) - (GetTime() - v63);
			end
			if ((v59 == (1561 - (1381 + 178))) or ((3481 + 230) < (813 + 195))) then
				v62 = (1 + 0) / v61;
				v63 = v11.Persistent.Player.LastPowerUpdate;
				v59 = 10 - 7;
			end
			if ((v59 == (1 + 0)) or ((1519 - (381 + 89)) <= (804 + 102))) then
				v61 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (((3053 + 1460) > (4669 - 1943)) and (not v61 or (v61 < (1156.2 - (1074 + 82))))) then
					v61 = 0.2 - 0;
				end
				v59 = 1786 - (214 + 1570);
			end
			if ((v59 == (1455 - (990 + 465))) or ((611 + 870) >= (1157 + 1501))) then
				v60 = v13:EssenceDeficit();
				if ((v60 == (0 + 0)) or ((12672 - 9452) == (3090 - (1668 + 58)))) then
					return 626 - (512 + 114);
				end
				v59 = 2 - 1;
			end
		end
	end, 3032 - 1565);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v64)
		local v65 = v13:Essence();
		if ((v65 >= v64) or ((3667 - 2613) > (1578 + 1814))) then
			return 0 + 0;
		end
		local v66 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		local v67 = (1 + 0) / v66;
		local v68 = v11.Persistent.Player.LastPowerUpdate;
		return ((v64 - v65) * v67) - (GetTime() - v68);
	end, 4947 - 3480);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v69 = 1994 - (109 + 1885);
		local v70;
		local v71;
		local v72;
		local v73;
		while true do
			if ((v69 == (1471 - (1269 + 200))) or ((1295 - 619) >= (2457 - (98 + 717)))) then
				v72 = (827 - (802 + 24)) / v71;
				v73 = v11.Persistent.Player.LastPowerUpdate;
				v69 = 5 - 2;
			end
			if (((5223 - 1087) > (354 + 2043)) and ((1 + 0) == v69)) then
				v71 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				if (not v71 or (v71 < (0.2 + 0)) or ((935 + 3399) == (11809 - 7564))) then
					v71 = 0.2 - 0;
				end
				v69 = 1 + 1;
			end
			if ((v69 == (0 + 0)) or ((3528 + 748) <= (2204 + 827))) then
				v70 = v13:EssenceDeficit();
				if ((v70 == (0 + 0)) or ((6215 - (797 + 636)) <= (5821 - 4622))) then
					return 1619 - (1427 + 192);
				end
				v69 = 1 + 0;
			end
			if ((v69 == (6 - 3)) or ((4373 + 491) < (862 + 1040))) then
				return (v70 * v72) - (GetTime() - v73);
			end
		end
	end, 1794 - (192 + 134));
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v74)
		local v75 = 1276 - (316 + 960);
		local v76;
		local v77;
		local v78;
		local v79;
		while true do
			if (((2693 + 2146) >= (2856 + 844)) and (v75 == (1 + 0))) then
				v77 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
				v78 = (3 - 2) / v77;
				v75 = 553 - (83 + 468);
			end
			if (((1806 - (1202 + 604)) == v75) or ((5018 - 3943) > (3191 - 1273))) then
				v76 = v13:Essence();
				if (((1096 - 700) <= (4129 - (45 + 280))) and (v76 >= v74)) then
					return 0 + 0;
				end
				v75 = 1 + 0;
			end
			if ((v75 == (1 + 1)) or ((2307 + 1862) == (385 + 1802))) then
				v79 = v11.Persistent.Player.LastPowerUpdate;
				return ((v74 - v76) * v78) - (GetTime() - v79);
			end
		end
	end, 2717 - 1249);
	local v38;
	v38 = v10.AddCoreOverride("Spell.IsCastable", function(v80, v81, v82, v83, v84, v85)
		local v86 = true;
		if (((3317 - (340 + 1571)) == (555 + 851)) and v82) then
			local v137 = 1772 - (1733 + 39);
			local v138;
			while true do
				if (((4206 - 2675) < (5305 - (125 + 909))) and (v137 == (1948 - (1096 + 852)))) then
					v138 = v84 or v14;
					v86 = v138:IsInRange(v82, v83);
					break;
				end
			end
		end
		local v87 = v38(v80, v81, v82, v83, v84, v85);
		if (((285 + 350) == (906 - 271)) and ((v80 == v16.Evoker.Augmentation.TipTheScales) or (v80 == v16.Evoker.Augmentation.Upheaval) or (v80 == v16.Evoker.Augmentation.FireBreath))) then
			return v87 and not v13:BuffUp(v80);
		else
			return v87;
		end
	end, 1429 + 44);
	local v39;
	v39 = v10.AddCoreOverride("Spell.IsReady", function(v88, v89, v90, v91, v92, v93)
		local v94 = true;
		if (((3885 - (409 + 103)) <= (3792 - (46 + 190))) and v90) then
			local v139 = 95 - (51 + 44);
			local v140;
			while true do
				if ((v139 == (0 + 0)) or ((4608 - (1114 + 203)) < (4006 - (228 + 498)))) then
					v140 = v92 or v14;
					v94 = v140:IsInRange(v90, v91);
					break;
				end
			end
		end
		local v95 = v39(v88, v89, v90, v91, v92, v93);
		if (((951 + 3435) >= (483 + 390)) and (v88 == v16.Evoker.Augmentation.Eruption)) then
			return v95 and (v13:EssenceP() >= (665 - (174 + 489)));
		elseif (((2399 - 1478) <= (3007 - (830 + 1075))) and (v88 == v16.Evoker.Augmentation.EbonMight)) then
			return v95 and not v13:IsCasting(v88);
		elseif (((5230 - (303 + 221)) >= (2232 - (231 + 1038))) and (v88 == v16.Evoker.Augmentation.Unravel)) then
			return v95 and v14:EnemyAbsorb();
		else
			return v95;
		end
	end, 1228 + 245);
	local v40;
	v40 = v10.AddCoreOverride("Player.IsMoving", function(v96)
		local v97 = 1162 - (171 + 991);
		local v98;
		while true do
			if ((v97 == (0 - 0)) or ((2577 - 1617) <= (2185 - 1309))) then
				v98 = v40(v96);
				return v98 and v13:BuffDown(v16.Evoker.Augmentation.HoverBuff);
			end
		end
	end, 1179 + 294);
	local v41;
	v41 = v10.AddCoreOverride("Player.BuffRemains", function(v99, v100, v101, v102)
		if ((v100 == v100.Evoker.Augmentation.EbonMightSelfBuff) or ((7242 - 5176) == (2688 - 1756))) then
			return (v99:IsCasting(v100.Evoker.Augmentation.EbonMight) and (16 - 6)) or v41(v99, v100, v101, v102);
		else
			return v41(v99, v100, v101, v102);
		end
	end, 4553 - 3080);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v103, v104)
		local v105 = 1248 - (111 + 1137);
		local v106;
		local v107;
		local v108;
		while true do
			if (((4983 - (91 + 67)) < (14413 - 9570)) and (v105 == (1 + 0))) then
				v108 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (527 - (423 + 100))) or (1 + 2);
				if (not v104 or ((10734 - 6857) >= (2365 + 2172))) then
					v104 = v108;
				end
				v105 = 773 - (326 + 445);
			end
			if ((v105 == (0 - 0)) or ((9612 - 5297) < (4028 - 2302))) then
				v106 = v13:SpellHaste();
				v107 = ((v16.Evoker.Augmentation.FontofMagic:IsAvailable()) and (711.8 - (530 + 181))) or (882 - (614 + 267));
				v105 = 33 - (19 + 13);
			end
			if ((v105 == (2 - 0)) or ((8572 - 4893) < (1785 - 1160))) then
				return (1 + 0 + ((0.75 - 0) * (v104 - (1 - 0)))) * v106 * v107;
			end
		end
	end, 3285 - (1293 + 519));
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v109, v110)
		local v111 = v13:SpellHaste();
		local v112 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (0.8 - 0)) or (2 - 1);
		local v113 = ((v16.Evoker.Devastation.FontofMagic:IsAvailable()) and (7 - 3)) or (12 - 9);
		if (not v110 or ((10895 - 6270) < (335 + 297))) then
			v110 = v113;
		end
		return (1 + 0 + ((0.75 - 0) * (v110 - (1 + 0)))) * v111 * v112;
	end, 488 + 979);
	v10.AddCoreOverride("Player.EmpowerCastTime", function(v114, v115)
		local v116 = v13:SpellHaste();
		local v117 = 1 + 0;
		local v118 = ((v16.Evoker.Preservation.FontofMagic:IsAvailable()) and (1100 - (709 + 387))) or (1861 - (673 + 1185));
		if (not v115 or ((240 - 157) > (5715 - 3935))) then
			v115 = v118;
		end
		return ((1 - 0) + ((0.75 + 0) * (v115 - (1 + 0)))) * v116 * v117;
	end, 1981 - 513);
	v10.AddCoreOverride("Player.EssenceP", function()
		local v119 = 0 + 0;
		local v120;
		while true do
			if (((1088 - 542) <= (2114 - 1037)) and (v119 == (1880 - (446 + 1434)))) then
				v120 = v13:Essence();
				if ((not v13:IsCasting() and not v13:IsChanneling()) or ((2279 - (1040 + 243)) > (12836 - 8535))) then
					return v120;
				elseif (((5917 - (559 + 1288)) > (2618 - (609 + 1322))) and v13:IsCasting(v16.Evoker.Augmentation.Eruption) and v13:BuffDown(v16.Evoker.Augmentation.EssenceBurstBuff)) then
					return v120 - (456 - (13 + 441));
				else
					return v120;
				end
				break;
			end
		end
	end, 5504 - 4031);
	v10.AddCoreOverride("Player.EssenceTimeToMax", function()
		local v121 = v13:EssenceDeficit();
		if ((v121 == (0 - 0)) or ((3267 - 2611) >= (124 + 3206))) then
			return 0 - 0;
		end
		local v122 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		if (not v122 or (v122 < (0.2 + 0)) or ((1092 + 1400) <= (994 - 659))) then
			v122 = 0.2 + 0;
		end
		local v123 = (1 - 0) / v122;
		local v124 = v11.Persistent.Player.LastPowerUpdate;
		return (v121 * v123) - (GetTime() - v124);
	end, 974 + 499);
	v10.AddCoreOverride("Player.EssenceTimeToX", function(v125)
		local v126 = v13:Essence();
		if (((2404 + 1918) >= (1841 + 721)) and (v126 >= v125)) then
			return 0 + 0;
		end
		local v127 = GetPowerRegenForPowerType(Enum.PowerType.Essence);
		local v128 = (1 + 0) / v127;
		local v129 = v11.Persistent.Player.LastPowerUpdate;
		return ((v125 - v126) * v128) - (GetTime() - v129);
	end, 1906 - (153 + 280));
end;
return v0["Epix_Evoker_Evoker.lua"]();

