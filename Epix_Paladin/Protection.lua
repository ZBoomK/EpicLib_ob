local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((886 + 686) > (3165 - (1607 + 27))) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (1726 - (1668 + 58))) or ((5313 - (512 + 114)) < (11841 - 7299))) then
			v6 = v0[v4];
			if (((6803 - 3512) > (5800 - 4133)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_Paladin_Protection.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Focus;
	local v15 = v12.Player;
	local v16 = v12.MouseOver;
	local v17 = v12.Target;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Bind;
	local v24 = v21.Macro;
	local v25 = v21.Press;
	local v26 = v21.Commons.Everyone.num;
	local v27 = v21.Commons.Everyone.bool;
	local v28 = string.format;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34;
	local v35;
	local v36;
	local v37;
	local v38;
	local v39;
	local v40;
	local v41;
	local v42;
	local v43;
	local v44;
	local v45;
	local v46;
	local v47;
	local v48;
	local v49;
	local v50;
	local v51;
	local v52;
	local v53;
	local v54;
	local v55;
	local v56;
	local v57;
	local v58;
	local v59;
	local v60;
	local v61;
	local v62;
	local v63;
	local v64;
	local v65;
	local v66;
	local v67;
	local v68;
	local v69;
	local v70;
	local v71;
	local v72;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80;
	local v81;
	local v82;
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96 = v19.Paladin.Protection;
	local v97 = v20.Paladin.Protection;
	local v98 = v24.Paladin.Protection;
	local v99 = {};
	local v100;
	local v101;
	local v102, v103;
	local v104, v105;
	local v106 = v21.Commons.Everyone;
	local v107 = 2080 + 9031;
	local v108 = 9660 + 1451;
	local v109 = 0 - 0;
	v10:RegisterForEvent(function()
		local v126 = 1994 - (109 + 1885);
		while true do
			if ((v126 == (1469 - (1269 + 200))) or ((1672 - 799) == (2849 - (98 + 717)))) then
				v107 = 11937 - (802 + 24);
				v108 = 19160 - 8049;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v110()
		if (v96.CleanseToxins:IsAvailable() or ((3556 - 740) < (2 + 9))) then
			v106.DispellableDebuffs = v13.MergeTable(v106.DispellableDiseaseDebuffs, v106.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v110();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v111(v127)
		return v127:DebuffRemains(v96.JudgmentDebuff);
	end
	local function v112()
		return v15:BuffDown(v96.RetributionAura) and v15:BuffDown(v96.DevotionAura) and v15:BuffDown(v96.ConcentrationAura) and v15:BuffDown(v96.CrusaderAura);
	end
	local function v113()
		if (((2843 + 856) < (773 + 3933)) and v96.CleanseToxins:IsReady() and v33 and v106.DispellableFriendlyUnit(6 + 19)) then
			if (((7360 - 4714) >= (2921 - 2045)) and v25(v98.CleanseToxinsFocus)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v114()
		if (((220 + 394) <= (1297 + 1887)) and v94 and (v15:HealthPercentage() <= v95)) then
			if (((2579 + 547) == (2274 + 852)) and v96.FlashofLight:IsReady()) then
				if (v25(v96.FlashofLight) or ((1022 + 1165) >= (6387 - (797 + 636)))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v115()
		v29 = v106.HandleTopTrinket(v99, v32, 194 - 154, nil);
		if (v29 or ((5496 - (1427 + 192)) == (1239 + 2336))) then
			return v29;
		end
		v29 = v106.HandleBottomTrinket(v99, v32, 92 - 52, nil);
		if (((636 + 71) > (287 + 345)) and v29) then
			return v29;
		end
	end
	local function v116()
		local v128 = 326 - (192 + 134);
		while true do
			if ((v128 == (1278 - (316 + 960))) or ((304 + 242) >= (2072 + 612))) then
				if (((1355 + 110) <= (16442 - 12141)) and v96.WordofGlory:IsReady() and (v15:HealthPercentage() <= v69) and v59 and not v15:HealingAbsorbed()) then
					if (((2255 - (83 + 468)) > (3231 - (1202 + 604))) and ((v15:BuffRemains(v96.ShieldoftheRighteousBuff) >= (23 - 18)) or v15:BuffUp(v96.DivinePurposeBuff) or v15:BuffUp(v96.ShiningLightFreeBuff))) then
						if (v25(v98.WordofGloryPlayer) or ((1143 - 456) == (11722 - 7488))) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v96.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (327 - (45 + 280))) and v15:BuffRefreshable(v96.ShieldoftheRighteousBuff) and v60 and (v100 or (v15:HealthPercentage() <= v70))) or ((3215 + 115) < (1249 + 180))) then
					if (((419 + 728) >= (186 + 149)) and v25(v96.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v128 = 1 + 2;
			end
			if (((6360 - 2925) > (4008 - (340 + 1571))) and (v128 == (0 + 0))) then
				if (((v15:HealthPercentage() <= v66) and v56 and v96.DivineShield:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) or ((5542 - (1733 + 39)) >= (11104 - 7063))) then
					if (v25(v96.DivineShield) or ((4825 - (125 + 909)) <= (3559 - (1096 + 852)))) then
						return "divine_shield defensive";
					end
				end
				if (((v15:HealthPercentage() <= v68) and v58 and v96.LayonHands:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) or ((2054 + 2524) <= (2867 - 859))) then
					if (((1092 + 33) <= (2588 - (409 + 103))) and v25(v98.LayonHandsPlayer)) then
						return "lay_on_hands defensive 2";
					end
				end
				v128 = 237 - (46 + 190);
			end
			if (((98 - (51 + 44)) == v128) or ((210 + 533) >= (5716 - (1114 + 203)))) then
				if (((1881 - (228 + 498)) < (363 + 1310)) and v97.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
					if (v25(v98.Healthstone) or ((1284 + 1040) <= (1241 - (174 + 489)))) then
						return "healthstone defensive";
					end
				end
				if (((9814 - 6047) == (5672 - (830 + 1075))) and v89 and (v15:HealthPercentage() <= v91)) then
					if (((4613 - (303 + 221)) == (5358 - (231 + 1038))) and (v93 == "Refreshing Healing Potion")) then
						if (((3715 + 743) >= (2836 - (171 + 991))) and v97.RefreshingHealingPotion:IsReady()) then
							if (((4005 - 3033) <= (3807 - 2389)) and v25(v98.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v93 == "Dreamwalker's Healing Potion") or ((12322 - 7384) < (3812 + 950))) then
						if (v97.DreamwalkersHealingPotion:IsReady() or ((8777 - 6273) > (12300 - 8036))) then
							if (((3470 - 1317) == (6655 - 4502)) and v25(v98.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v128 == (1249 - (111 + 1137))) or ((665 - (91 + 67)) >= (7711 - 5120))) then
				if (((1119 + 3362) == (5004 - (423 + 100))) and v96.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v67) and v57 and v15:BuffDown(v96.ArdentDefenderBuff)) then
					if (v25(v96.GuardianofAncientKings) or ((17 + 2311) < (1918 - 1225))) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if (((2256 + 2072) == (5099 - (326 + 445))) and v96.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v65) and v55 and v15:BuffDown(v96.GuardianofAncientKingsBuff)) then
					if (((6929 - 5341) >= (2967 - 1635)) and v25(v96.ArdentDefender)) then
						return "ardent_defender defensive 6";
					end
				end
				v128 = 4 - 2;
			end
		end
	end
	local function v117()
		local v129 = 711 - (530 + 181);
		while true do
			if ((v129 == (881 - (614 + 267))) or ((4206 - (19 + 13)) > (6913 - 2665))) then
				if (not v14 or not v14:Exists() or not v14:IsInRange(69 - 39) or ((13100 - 8514) <= (22 + 60))) then
					return;
				end
				if (((6793 - 2930) == (8011 - 4148)) and v14) then
					local v206 = 1812 - (1293 + 519);
					while true do
						if (((0 - 0) == v206) or ((736 - 454) <= (80 - 38))) then
							if (((19874 - 15265) >= (1804 - 1038)) and v96.WordofGlory:IsReady() and v62 and v15:BuffUp(v96.ShiningLightFreeBuff) and (v14:HealthPercentage() <= v72)) then
								if (v25(v98.WordofGloryFocus) or ((611 + 541) == (508 + 1980))) then
									return "word_of_glory defensive focus";
								end
							end
							if (((7950 - 4528) > (775 + 2575)) and v96.LayonHands:IsCastable() and v61 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v71)) then
								if (((292 + 585) > (235 + 141)) and v25(v98.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v206 = 1097 - (709 + 387);
						end
						if ((v206 == (1859 - (673 + 1185))) or ((9042 - 5924) <= (5943 - 4092))) then
							if ((v96.BlessingofSacrifice:IsCastable() and v64 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) or ((271 - 106) >= (2498 + 994))) then
								if (((2951 + 998) < (6555 - 1699)) and v25(v98.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((v96.BlessingofProtection:IsCastable() and v63 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) or ((1051 + 3225) < (6013 - 2997))) then
								if (((9206 - 4516) > (6005 - (446 + 1434))) and v25(v98.BlessingofProtectionFocus)) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		if (((v84 < v108) and v96.LightsJudgment:IsCastable() and v87 and ((v88 and v32) or not v88)) or ((1333 - (1040 + 243)) >= (2674 - 1778))) then
			if (v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment)) or ((3561 - (559 + 1288)) >= (4889 - (609 + 1322)))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((v84 < v108) and v96.ArcaneTorrent:IsCastable() and v87 and ((v88 and v32) or not v88) and (v109 < (459 - (13 + 441)))) or ((5571 - 4080) < (1686 - 1042))) then
			if (((3506 - 2802) < (37 + 950)) and v25(v96.ArcaneTorrent, not v17:IsInRange(29 - 21))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((1321 + 2397) > (836 + 1070)) and v96.Consecration:IsCastable() and v36) then
			if (v25(v96.Consecration, not v17:IsInRange(23 - 15)) or ((525 + 433) > (6685 - 3050))) then
				return "consecration";
			end
		end
		if (((2315 + 1186) <= (2499 + 1993)) and v96.AvengersShield:IsCastable() and v34) then
			if (v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield)) or ((2474 + 968) < (2140 + 408))) then
				return "avengers_shield precombat 10";
			end
		end
		if (((2813 + 62) >= (1897 - (153 + 280))) and v96.Judgment:IsReady() and v40) then
			if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((13851 - 9054) >= (4393 + 500))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v119()
		local v130 = 0 + 0;
		local v131;
		while true do
			if ((v130 == (2 + 1)) or ((501 + 50) > (1499 + 569))) then
				if (((3218 - 1104) > (584 + 360)) and v96.MomentofGlory:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v96.SentinelBuff) < (682 - (89 + 578))) or (((v10.CombatTime() > (8 + 2)) or (v96.Sentinel:CooldownRemains() > (30 - 15)) or (v96.AvengingWrath:CooldownRemains() > (1064 - (572 + 477)))) and (v96.AvengersShield:CooldownRemains() > (0 + 0)) and (v96.Judgment:CooldownRemains() > (0 + 0)) and (v96.HammerofWrath:CooldownRemains() > (0 + 0))))) then
					if (v25(v96.MomentofGlory, not v17:IsInRange(94 - (84 + 2))) or ((3727 - 1465) >= (2231 + 865))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if ((v43 and ((v49 and v32) or not v49) and v96.DivineToll:IsReady() and (v104 >= (845 - (497 + 345)))) or ((58 + 2197) >= (598 + 2939))) then
					if (v25(v96.DivineToll, not v17:IsInRange(1363 - (605 + 728))) or ((2738 + 1099) < (2903 - 1597))) then
						return "divine_toll cooldowns 12";
					end
				end
				v130 = 1 + 3;
			end
			if (((10906 - 7956) == (2660 + 290)) and (v130 == (10 - 6))) then
				if ((v96.BastionofLight:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v96.AvengingWrathBuff) or (v96.AvengingWrath:CooldownRemains() <= (23 + 7)))) or ((5212 - (457 + 32)) < (1400 + 1898))) then
					if (((2538 - (832 + 570)) >= (146 + 8)) and v25(v96.BastionofLight, not v17:IsInRange(3 + 5))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if ((v130 == (3 - 2)) or ((131 + 140) > (5544 - (588 + 208)))) then
				if (((12775 - 8035) >= (4952 - (884 + 916))) and v96.AvengingWrath:IsCastable() and v41 and ((v47 and v32) or not v47)) then
					if (v25(v96.AvengingWrath, not v17:IsInRange(16 - 8)) or ((1495 + 1083) >= (4043 - (232 + 421)))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if (((1930 - (1569 + 320)) <= (408 + 1253)) and v96.Sentinel:IsCastable() and v46 and ((v52 and v32) or not v52)) then
					if (((115 + 486) < (11996 - 8436)) and v25(v96.Sentinel, not v17:IsInRange(613 - (316 + 289)))) then
						return "sentinel cooldowns 8";
					end
				end
				v130 = 5 - 3;
			end
			if (((11 + 224) < (2140 - (666 + 787))) and (v130 == (425 - (360 + 65)))) then
				if (((4252 + 297) > (1407 - (79 + 175))) and v96.AvengersShield:IsCastable() and v34 and (v10.CombatTime() < (2 - 0)) and v15:HasTier(23 + 6, 5 - 3)) then
					if (v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield)) or ((9001 - 4327) < (5571 - (503 + 396)))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if (((3849 - (92 + 89)) < (8847 - 4286)) and v96.LightsJudgment:IsCastable() and v87 and ((v88 and v32) or not v88) and (v105 >= (2 + 0))) then
					if (v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment)) or ((270 + 185) == (14117 - 10512))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v130 = 1 + 0;
			end
			if ((v130 == (4 - 2)) or ((2324 + 339) == (1582 + 1730))) then
				v131 = v106.HandleDPSPotion(v15:BuffUp(v96.AvengingWrathBuff));
				if (((13026 - 8749) <= (559 + 3916)) and v131) then
					return v131;
				end
				v130 = 4 - 1;
			end
		end
	end
	local function v120()
		local v132 = 1244 - (485 + 759);
		while true do
			if ((v132 == (0 - 0)) or ((2059 - (442 + 747)) == (2324 - (832 + 303)))) then
				if (((2499 - (88 + 858)) <= (955 + 2178)) and v96.Consecration:IsCastable() and v36 and (v15:BuffStack(v96.SanctificationBuff) == (5 + 0))) then
					if (v25(v96.Consecration, not v17:IsInRange(1 + 7)) or ((3026 - (766 + 23)) >= (17332 - 13821))) then
						return "consecration standard 2";
					end
				end
				if ((v96.ShieldoftheRighteous:IsCastable() and v60 and ((v15:HolyPower() > (2 - 0)) or v15:BuffUp(v96.BastionofLightBuff) or v15:BuffUp(v96.DivinePurposeBuff)) and (v15:BuffDown(v96.SanctificationBuff) or (v15:BuffStack(v96.SanctificationBuff) < (13 - 8)))) or ((4493 - 3169) > (4093 - (1036 + 37)))) then
					if (v25(v96.ShieldoftheRighteous) or ((2122 + 870) == (3662 - 1781))) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((2444 + 662) > (3006 - (641 + 839))) and v96.Judgment:IsReady() and v40 and (v104 > (916 - (910 + 3))) and (v15:BuffStack(v96.BulwarkofRighteousFuryBuff) >= (7 - 4)) and (v15:HolyPower() < (1687 - (1466 + 218)))) then
					local v207 = 0 + 0;
					while true do
						if (((4171 - (556 + 592)) < (1377 + 2493)) and (v207 == (808 - (329 + 479)))) then
							if (((997 - (174 + 680)) > (253 - 179)) and v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment))) then
								return "judgment standard 6";
							end
							if (((37 - 19) < (1508 + 604)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v132 = 740 - (396 + 343);
			end
			if (((98 + 999) <= (3105 - (29 + 1448))) and (v132 == (1393 - (135 + 1254)))) then
				if (((17442 - 12812) == (21618 - 16988)) and (v84 < v108) and v44 and ((v50 and v32) or not v50) and v96.EyeofTyr:IsCastable() and v96.InmostLight:IsAvailable() and (v104 >= (2 + 1))) then
					if (((5067 - (389 + 1138)) > (3257 - (102 + 472))) and v25(v96.EyeofTyr, not v17:IsInRange(8 + 0))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((2659 + 2135) >= (3054 + 221)) and v96.BlessedHammer:IsCastable() and v35) then
					if (((3029 - (320 + 1225)) == (2641 - 1157)) and v25(v96.BlessedHammer, not v17:IsInRange(5 + 3))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((2896 - (157 + 1307)) < (5414 - (821 + 1038))) and v96.HammeroftheRighteous:IsCastable() and v38) then
					if (v25(v96.HammeroftheRighteous, not v17:IsInRange(19 - 11)) or ((117 + 948) > (6355 - 2777))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v132 = 2 + 3;
			end
			if ((v132 == (2 - 1)) or ((5821 - (834 + 192)) < (90 + 1317))) then
				if (((476 + 1377) < (104 + 4709)) and v96.Judgment:IsReady() and v40 and v15:BuffDown(v96.SanctificationEmpowerBuff) and v15:HasTier(47 - 16, 306 - (300 + 4))) then
					local v208 = 0 + 0;
					while true do
						if ((v208 == (0 - 0)) or ((3183 - (112 + 250)) < (970 + 1461))) then
							if (v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment)) or ((7199 - 4325) < (1250 + 931))) then
								return "judgment standard 8";
							end
							if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((1391 + 1298) <= (257 + 86))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if ((v96.HammerofWrath:IsReady() and v39) or ((927 + 942) == (1493 + 516))) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((4960 - (1001 + 413)) < (5177 - 2855))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v96.Judgment:IsReady() and v40 and ((v96.Judgment:Charges() >= (884 - (244 + 638))) or (v96.Judgment:FullRechargeTime() <= v15:GCD()))) or ((2775 - (627 + 66)) == (14221 - 9448))) then
					local v209 = 602 - (512 + 90);
					while true do
						if (((5150 - (1665 + 241)) > (1772 - (373 + 344))) and (v209 == (0 + 0))) then
							if (v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment)) or ((877 + 2436) <= (4689 - 2911))) then
								return "judgment standard 12";
							end
							if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or ((2404 - 983) >= (3203 - (35 + 1064)))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v132 = 2 + 0;
			end
			if (((3876 - 2064) <= (13 + 3236)) and (v132 == (1238 - (298 + 938)))) then
				if (((2882 - (233 + 1026)) <= (3623 - (636 + 1030))) and v96.AvengersShield:IsCastable() and v34 and ((v105 > (2 + 0)) or v15:BuffUp(v96.MomentofGloryBuff))) then
					if (((4310 + 102) == (1311 + 3101)) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if (((119 + 1631) >= (1063 - (55 + 166))) and v43 and ((v49 and v32) or not v49) and v96.DivineToll:IsReady()) then
					if (((848 + 3524) > (187 + 1663)) and v25(v96.DivineToll, not v17:IsInRange(114 - 84))) then
						return "divine_toll standard 16";
					end
				end
				if (((529 - (36 + 261)) < (1435 - 614)) and v96.AvengersShield:IsCastable() and v34) then
					if (((1886 - (34 + 1334)) < (347 + 555)) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				v132 = 3 + 0;
			end
			if (((4277 - (1035 + 248)) > (879 - (20 + 1))) and (v132 == (3 + 2))) then
				if ((v96.CrusaderStrike:IsCastable() and v37) or ((4074 - (134 + 185)) <= (2048 - (549 + 584)))) then
					if (((4631 - (314 + 371)) > (12849 - 9106)) and v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((v84 < v108) and v44 and ((v50 and v32) or not v50) and v96.EyeofTyr:IsCastable() and not v96.InmostLight:IsAvailable()) or ((2303 - (478 + 490)) >= (1752 + 1554))) then
					if (((6016 - (786 + 386)) > (7297 - 5044)) and v25(v96.EyeofTyr, not v17:IsInRange(1387 - (1055 + 324)))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((1792 - (1093 + 247)) == (402 + 50)) and v96.ArcaneTorrent:IsCastable() and v87 and ((v88 and v32) or not v88) and (v109 < (1 + 4))) then
					if (v25(v96.ArcaneTorrent, not v17:IsInRange(31 - 23)) or ((15465 - 10908) < (5938 - 3851))) then
						return "arcane_torrent standard 36";
					end
				end
				v132 = 15 - 9;
			end
			if (((1379 + 2495) == (14924 - 11050)) and (v132 == (10 - 7))) then
				if ((v96.HammerofWrath:IsReady() and v39) or ((1462 + 476) > (12620 - 7685))) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or ((4943 - (364 + 324)) < (9383 - 5960))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((3488 - 2034) <= (826 + 1665)) and v96.Judgment:IsReady() and v40) then
					local v210 = 0 - 0;
					while true do
						if ((v210 == (0 - 0)) or ((12625 - 8468) <= (4071 - (1249 + 19)))) then
							if (((4381 + 472) >= (11607 - 8625)) and v106.CastCycle(v96.Judgment, v102, v111, not v17:IsSpellInRange(v96.Judgment))) then
								return "judgment standard 22";
							end
							if (((5220 - (686 + 400)) > (2634 + 723)) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if ((v96.Consecration:IsCastable() and v36 and v15:BuffDown(v96.ConsecrationBuff) and ((v15:BuffStack(v96.SanctificationBuff) < (234 - (73 + 156))) or not v15:HasTier(1 + 30, 813 - (721 + 90)))) or ((39 + 3378) < (8227 - 5693))) then
					if (v25(v96.Consecration, not v17:IsInRange(478 - (224 + 246))) or ((4409 - 1687) <= (301 - 137))) then
						return "consecration standard 24";
					end
				end
				v132 = 1 + 3;
			end
			if ((v132 == (1 + 5)) or ((1769 + 639) < (4192 - 2083))) then
				if ((v96.Consecration:IsCastable() and v36 and (v15:BuffDown(v96.SanctificationEmpowerBuff))) or ((109 - 76) == (1968 - (203 + 310)))) then
					if (v25(v96.Consecration, not v17:IsInRange(2001 - (1238 + 755))) or ((31 + 412) >= (5549 - (709 + 825)))) then
						return "consecration standard 38";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v133 = 0 - 0;
		while true do
			if (((4926 - 1544) > (1030 - (196 + 668))) and ((0 - 0) == v133)) then
				v34 = EpicSettings.Settings['useAvengersShield'];
				v35 = EpicSettings.Settings['useBlessedHammer'];
				v36 = EpicSettings.Settings['useConsecration'];
				v133 = 1 - 0;
			end
			if ((v133 == (836 - (171 + 662))) or ((373 - (4 + 89)) == (10721 - 7662))) then
				v43 = EpicSettings.Settings['useDivineToll'];
				v44 = EpicSettings.Settings['useEyeofTyr'];
				v45 = EpicSettings.Settings['useMomentOfGlory'];
				v133 = 2 + 2;
			end
			if (((8261 - 6380) > (508 + 785)) and (v133 == (1488 - (35 + 1451)))) then
				v40 = EpicSettings.Settings['useJudgment'];
				v41 = EpicSettings.Settings['useAvengingWrath'];
				v42 = EpicSettings.Settings['useBastionofLight'];
				v133 = 1456 - (28 + 1425);
			end
			if (((4350 - (941 + 1052)) == (2261 + 96)) and (v133 == (1519 - (822 + 692)))) then
				v49 = EpicSettings.Settings['divineTollWithCD'];
				v50 = EpicSettings.Settings['eyeofTyrWithCD'];
				v51 = EpicSettings.Settings['momentofGloryWithCD'];
				v133 = 7 - 1;
			end
			if (((58 + 65) == (420 - (45 + 252))) and (v133 == (1 + 0))) then
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v38 = EpicSettings.Settings['useHammeroftheRighteous'];
				v39 = EpicSettings.Settings['useHammerofWrath'];
				v133 = 1 + 1;
			end
			if (((14 - 8) == v133) or ((1489 - (114 + 319)) >= (4869 - 1477))) then
				v52 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if (((4 - 0) == v133) or ((690 + 391) < (1601 - 526))) then
				v46 = EpicSettings.Settings['useSentinel'];
				v47 = EpicSettings.Settings['avengingWrathWithCD'];
				v48 = EpicSettings.Settings['bastionofLightWithCD'];
				v133 = 10 - 5;
			end
		end
	end
	local function v122()
		local v134 = 1963 - (556 + 1407);
		while true do
			if ((v134 == (1211 - (741 + 465))) or ((1514 - (170 + 295)) >= (2336 + 2096))) then
				v68 = EpicSettings.Settings['layonHandsHP'];
				v69 = EpicSettings.Settings['wordofGloryHP'];
				v70 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v134 = 6 + 0;
			end
			if ((v134 == (7 - 4)) or ((3953 + 815) <= (543 + 303))) then
				v62 = EpicSettings.Settings['useWordofGloryFocus'];
				v63 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v64 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v134 = 3 + 1;
			end
			if ((v134 == (1230 - (957 + 273))) or ((899 + 2459) <= (569 + 851))) then
				v53 = EpicSettings.Settings['useRebuke'];
				v54 = EpicSettings.Settings['useHammerofJustice'];
				v55 = EpicSettings.Settings['useArdentDefender'];
				v134 = 3 - 2;
			end
			if ((v134 == (2 - 1)) or ((11420 - 7681) <= (14879 - 11874))) then
				v56 = EpicSettings.Settings['useDivineShield'];
				v57 = EpicSettings.Settings['useGuardianofAncientKings'];
				v58 = EpicSettings.Settings['useLayOnHands'];
				v134 = 1782 - (389 + 1391);
			end
			if ((v134 == (2 + 0)) or ((173 + 1486) >= (4858 - 2724))) then
				v59 = EpicSettings.Settings['useWordofGloryPlayer'];
				v60 = EpicSettings.Settings['useShieldoftheRighteous'];
				v61 = EpicSettings.Settings['useLayOnHandsFocus'];
				v134 = 954 - (783 + 168);
			end
			if ((v134 == (19 - 13)) or ((3207 + 53) < (2666 - (309 + 2)))) then
				v71 = EpicSettings.Settings['layOnHandsFocusHP'];
				v72 = EpicSettings.Settings['wordofGloryFocusHP'];
				v73 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v134 = 21 - 14;
			end
			if ((v134 == (1216 - (1090 + 122))) or ((217 + 452) == (14182 - 9959))) then
				v65 = EpicSettings.Settings['ardentDefenderHP'];
				v66 = EpicSettings.Settings['divineShieldHP'];
				v67 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v134 = 4 + 1;
			end
			if ((v134 == (1125 - (628 + 490))) or ((304 + 1388) < (1455 - 867))) then
				v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
		end
	end
	local function v123()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (777 - (431 + 343))) or ((9687 - 4890) < (10561 - 6910))) then
				v88 = EpicSettings.Settings['racialsWithCD'];
				v90 = EpicSettings.Settings['useHealthstone'];
				v89 = EpicSettings.Settings['useHealingPotion'];
				v135 = 4 + 0;
			end
			if ((v135 == (1 + 0)) or ((5872 - (556 + 1139)) > (4865 - (6 + 9)))) then
				v83 = EpicSettings.Settings['InterruptThreshold'];
				v78 = EpicSettings.Settings['DispelDebuffs'];
				v77 = EpicSettings.Settings['DispelBuffs'];
				v135 = 1 + 1;
			end
			if ((v135 == (3 + 1)) or ((569 - (28 + 141)) > (431 + 680))) then
				v92 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v91 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v93 = EpicSettings.Settings['HealingPotionName'] or "";
				v135 = 1322 - (486 + 831);
			end
			if (((7939 - 4888) > (3538 - 2533)) and (v135 == (2 + 4))) then
				v95 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if (((4956 - (668 + 595)) <= (3944 + 438)) and ((1 + 1) == v135)) then
				v85 = EpicSettings.Settings['useTrinkets'];
				v87 = EpicSettings.Settings['useRacials'];
				v86 = EpicSettings.Settings['trinketsWithCD'];
				v135 = 8 - 5;
			end
			if ((v135 == (295 - (23 + 267))) or ((5226 - (1129 + 815)) > (4487 - (371 + 16)))) then
				v79 = EpicSettings.Settings['handleAfflicted'];
				v80 = EpicSettings.Settings['HandleIncorporeal'];
				v94 = EpicSettings.Settings['HealOOC'];
				v135 = 1756 - (1326 + 424);
			end
			if ((v135 == (0 - 0)) or ((13082 - 9502) < (2962 - (88 + 30)))) then
				v84 = EpicSettings.Settings['fightRemainsCheck'] or (771 - (720 + 51));
				v81 = EpicSettings.Settings['InterruptWithStun'];
				v82 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v135 = 2 - 1;
			end
		end
	end
	local function v124()
		v122();
		v121();
		v123();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (((1865 - (421 + 1355)) < (7407 - 2917)) and v15:IsDeadOrGhost()) then
			return v29;
		end
		v102 = v15:GetEnemiesInMeleeRange(4 + 4);
		v103 = v15:GetEnemiesInRange(1113 - (286 + 797));
		if (v31 or ((18215 - 13232) < (2994 - 1186))) then
			local v143 = 439 - (397 + 42);
			while true do
				if (((1196 + 2633) > (4569 - (24 + 776))) and (v143 == (0 - 0))) then
					v104 = #v102;
					v105 = #v103;
					break;
				end
			end
		else
			local v144 = 785 - (222 + 563);
			while true do
				if (((3271 - 1786) <= (2091 + 813)) and (v144 == (190 - (23 + 167)))) then
					v104 = 1799 - (690 + 1108);
					v105 = 1 + 0;
					break;
				end
			end
		end
		v100 = v15:ActiveMitigationNeeded();
		v101 = v15:IsTankingAoE(7 + 1) or v15:IsTanking(v17);
		if (((5117 - (40 + 808)) == (703 + 3566)) and not v15:AffectingCombat() and v15:IsMounted()) then
			if (((1479 - 1092) <= (2659 + 123)) and v96.CrusaderAura:IsCastable() and (v15:BuffDown(v96.CrusaderAura))) then
				if (v25(v96.CrusaderAura) or ((1005 + 894) <= (503 + 414))) then
					return "crusader_aura";
				end
			end
		end
		if (v15:AffectingCombat() or v78 or ((4883 - (47 + 524)) <= (569 + 307))) then
			local v145 = v78 and v96.CleanseToxins:IsReady() and v33;
			v29 = v106.FocusUnit(v145, v98, 54 - 34, nil, 37 - 12);
			if (((5090 - 2858) <= (4322 - (1165 + 561))) and v29) then
				return v29;
			end
		end
		if (((63 + 2032) < (11416 - 7730)) and v33) then
			local v146 = 0 + 0;
			while true do
				if ((v146 == (479 - (341 + 138))) or ((431 + 1164) >= (9232 - 4758))) then
					v29 = v106.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 366 - (89 + 237), 80 - 55);
					if (v29 or ((9724 - 5105) < (3763 - (581 + 300)))) then
						return v29;
					end
					v146 = 1221 - (855 + 365);
				end
				if ((v146 == (2 - 1)) or ((96 + 198) >= (6066 - (1030 + 205)))) then
					if (((1905 + 124) <= (2869 + 215)) and v96.BlessingofFreedom:IsReady() and v106.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
						if (v25(v98.BlessingofFreedomFocus) or ((2323 - (156 + 130)) == (5498 - 3078))) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
			end
		end
		if (((7513 - 3055) > (7995 - 4091)) and (v106.TargetIsValid() or v15:AffectingCombat())) then
			v107 = v10.BossFightRemains(nil, true);
			v108 = v107;
			if (((115 + 321) >= (72 + 51)) and (v108 == (11180 - (10 + 59)))) then
				v108 = v10.FightRemains(v102, false);
			end
			v109 = v15:HolyPower();
		end
		if (((142 + 358) < (8943 - 7127)) and not v15:AffectingCombat()) then
			if (((4737 - (671 + 492)) == (2846 + 728)) and v96.DevotionAura:IsCastable() and (v112())) then
				if (((1436 - (369 + 846)) < (104 + 286)) and v25(v96.DevotionAura)) then
					return "devotion_aura";
				end
			end
		end
		if (v79 or ((1889 + 324) <= (3366 - (1036 + 909)))) then
			local v147 = 0 + 0;
			while true do
				if (((5134 - 2076) < (5063 - (11 + 192))) and (v147 == (0 + 0))) then
					if (v75 or ((1471 - (135 + 40)) >= (10771 - 6325))) then
						local v211 = 0 + 0;
						while true do
							if ((v211 == (0 - 0)) or ((2088 - 695) > (4665 - (50 + 126)))) then
								v29 = v106.HandleAfflicted(v96.CleanseToxins, v98.CleanseToxinsMouseover, 111 - 71);
								if (v29 or ((980 + 3444) < (1440 - (1233 + 180)))) then
									return v29;
								end
								break;
							end
						end
					end
					if ((v15:BuffUp(v96.ShiningLightFreeBuff) and v76) or ((2966 - (522 + 447)) > (5236 - (107 + 1314)))) then
						local v212 = 0 + 0;
						while true do
							if (((10558 - 7093) > (813 + 1100)) and (v212 == (0 - 0))) then
								v29 = v106.HandleAfflicted(v96.WordofGlory, v98.WordofGloryMouseover, 158 - 118, true);
								if (((2643 - (716 + 1194)) < (32 + 1787)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if (v80 or ((471 + 3924) == (5258 - (74 + 429)))) then
			v29 = v106.HandleIncorporeal(v96.Repentance, v98.RepentanceMouseOver, 57 - 27, true);
			if (v29 or ((1880 + 1913) < (5422 - 3053))) then
				return v29;
			end
			v29 = v106.HandleIncorporeal(v96.TurnEvil, v98.TurnEvilMouseOver, 22 + 8, true);
			if (v29 or ((12590 - 8506) == (655 - 390))) then
				return v29;
			end
		end
		v29 = v114();
		if (((4791 - (279 + 154)) == (5136 - (454 + 324))) and v29) then
			return v29;
		end
		if (v14 or ((2469 + 669) < (1010 - (12 + 5)))) then
			if (((1796 + 1534) > (5918 - 3595)) and v78) then
				v29 = v113();
				if (v29 or ((1340 + 2286) == (5082 - (277 + 816)))) then
					return v29;
				end
			end
		end
		v29 = v117();
		if (v29 or ((3913 - 2997) == (3854 - (1058 + 125)))) then
			return v29;
		end
		if (((51 + 221) == (1247 - (815 + 160))) and v96.Redemption:IsCastable() and v96.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
			if (((18230 - 13981) <= (11486 - 6647)) and v25(v98.RedemptionMouseover)) then
				return "redemption mouseover";
			end
		end
		if (((663 + 2114) < (9354 - 6154)) and v15:AffectingCombat()) then
			if (((1993 - (41 + 1857)) < (3850 - (1222 + 671))) and v96.Intercession:IsCastable() and (v15:HolyPower() >= (7 - 4)) and v96.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (((1186 - 360) < (2899 - (229 + 953))) and v25(v98.IntercessionMouseover)) then
					return "Intercession";
				end
			end
		end
		if (((3200 - (1111 + 663)) >= (2684 - (874 + 705))) and v106.TargetIsValid() and not v15:AffectingCombat() and v30) then
			v29 = v118();
			if (((386 + 2368) <= (2306 + 1073)) and v29) then
				return v29;
			end
		end
		if (v106.TargetIsValid() or ((8162 - 4235) == (40 + 1373))) then
			if ((v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((1833 - (642 + 37)) <= (180 + 608))) then
				if (v15:AffectingCombat() or ((263 + 1380) > (8483 - 5104))) then
					if (v96.Intercession:IsCastable() or ((3257 - (233 + 221)) > (10518 - 5969))) then
						if (v25(v96.Intercession, not v17:IsInRange(27 + 3), true) or ((1761 - (718 + 823)) >= (1902 + 1120))) then
							return "intercession";
						end
					end
				elseif (((3627 - (266 + 539)) == (7989 - 5167)) and v96.Redemption:IsCastable()) then
					if (v25(v96.Redemption, not v17:IsInRange(1255 - (636 + 589)), true) or ((2518 - 1457) == (3830 - 1973))) then
						return "redemption";
					end
				end
			end
			if (((2188 + 572) > (496 + 868)) and v106.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
				local v205 = 1015 - (657 + 358);
				while true do
					if ((v205 == (2 - 1)) or ((11167 - 6265) <= (4782 - (1151 + 36)))) then
						if ((v85 and ((v32 and v86) or not v86) and v17:IsInRange(8 + 0)) or ((1013 + 2839) == (875 - 582))) then
							local v213 = 1832 - (1552 + 280);
							while true do
								if (((834 - (64 + 770)) == v213) or ((1059 + 500) == (10414 - 5826))) then
									v29 = v115();
									if (v29 or ((797 + 3687) == (2031 - (157 + 1086)))) then
										return v29;
									end
									break;
								end
							end
						end
						v29 = v120();
						v205 = 3 - 1;
					end
					if (((20006 - 15438) >= (5993 - 2086)) and (v205 == (2 - 0))) then
						if (((2065 - (599 + 220)) < (6910 - 3440)) and v29) then
							return v29;
						end
						if (((5999 - (1813 + 118)) >= (711 + 261)) and v25(v96.Pool)) then
							return "Wait/Pool Resources";
						end
						break;
					end
					if (((1710 - (841 + 376)) < (5454 - 1561)) and (v205 == (0 + 0))) then
						if (v101 or ((4020 - 2547) >= (4191 - (464 + 395)))) then
							local v214 = 0 - 0;
							while true do
								if ((v214 == (0 + 0)) or ((4888 - (467 + 370)) <= (2390 - 1233))) then
									v29 = v116();
									if (((444 + 160) < (9876 - 6995)) and v29) then
										return v29;
									end
									break;
								end
							end
						end
						if ((v84 < v108) or ((141 + 759) == (7856 - 4479))) then
							v29 = v119();
							if (((4979 - (150 + 370)) > (1873 - (74 + 1208))) and v29) then
								return v29;
							end
						end
						v205 = 2 - 1;
					end
				end
			end
		end
	end
	local function v125()
		local v140 = 0 - 0;
		while true do
			if (((2418 + 980) >= (2785 - (14 + 376))) and ((0 - 0) == v140)) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v110();
				break;
			end
		end
	end
	v21.SetAPL(43 + 23, v124, v125);
end;
return v0["Epix_Paladin_Protection.lua"]();

