local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1 - 0)) or ((1357 - 282) > (284 + 1634))) then
			return v6(...);
		end
		if (((305 + 91) <= (625 + 3179)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((11597 - 7428) == (7293 - 5106))) then
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
	local v96;
	local v97;
	local v98 = v19.Paladin.Protection;
	local v99 = v20.Paladin.Protection;
	local v100 = v24.Paladin.Protection;
	local v101 = {};
	local v102;
	local v103;
	local v104, v105;
	local v106, v107;
	local v108 = v21.Commons.Everyone;
	local v109 = 4523 + 6588;
	local v110 = 9166 + 1945;
	local v111 = 0 + 0;
	v10:RegisterForEvent(function()
		v109 = 5188 + 5923;
		v110 = 12544 - (797 + 636);
	end, "PLAYER_REGEN_ENABLED");
	local function v112()
		if (((6826 - 5420) == (3025 - (1427 + 192))) and v98.CleanseToxins:IsAvailable()) then
			v108.DispellableDebuffs = v13.MergeTable(v108.DispellableDiseaseDebuffs, v108.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v112();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v113(v129)
		return v129:DebuffRemains(v98.JudgmentDebuff);
	end
	local function v114()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local v115 = 0 + 0;
	local function v116()
		if (((3554 - 2023) < (3840 + 431)) and v98.CleanseToxins:IsReady() and v108.DispellableFriendlyUnit(12 + 13)) then
			if (((961 - (192 + 134)) == (1911 - (316 + 960))) and (v115 == (0 + 0))) then
				v115 = GetTime();
			end
			if (((2603 + 770) <= (3287 + 269)) and v108.Wait(1911 - 1411, v115)) then
				local v212 = 551 - (83 + 468);
				while true do
					if ((v212 == (1806 - (1202 + 604))) or ((15363 - 12072) < (5458 - 2178))) then
						if (((12143 - 7757) >= (1198 - (45 + 280))) and v25(v100.CleanseToxinsFocus)) then
							return "cleanse_toxins dispel";
						end
						v115 = 0 + 0;
						break;
					end
				end
			end
		end
	end
	local function v117()
		if (((805 + 116) <= (403 + 699)) and v96 and (v15:HealthPercentage() <= v97)) then
			if (((2605 + 2101) >= (170 + 793)) and v98.FlashofLight:IsReady()) then
				if (v25(v98.FlashofLight) or ((1777 - 817) <= (2787 - (340 + 1571)))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		local v130 = 0 + 0;
		while true do
			if ((v130 == (1772 - (1733 + 39))) or ((5677 - 3611) == (1966 - (125 + 909)))) then
				v29 = v108.HandleTopTrinket(v101, v32, 1988 - (1096 + 852), nil);
				if (((2165 + 2660) < (6915 - 2072)) and v29) then
					return v29;
				end
				v130 = 1 + 0;
			end
			if ((v130 == (513 - (409 + 103))) or ((4113 - (46 + 190)) >= (4632 - (51 + 44)))) then
				v29 = v108.HandleBottomTrinket(v101, v32, 12 + 28, nil);
				if (v29 or ((5632 - (1114 + 203)) < (2452 - (228 + 498)))) then
					return v29;
				end
				break;
			end
		end
	end
	local function v119()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (0 + 0)) or ((4342 - (174 + 489)) < (1628 - 1003))) then
				if (((v15:HealthPercentage() <= v67) and v56 and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) or ((6530 - (830 + 1075)) < (1156 - (303 + 221)))) then
					if (v25(v98.DivineShield) or ((1352 - (231 + 1038)) > (1484 + 296))) then
						return "divine_shield defensive";
					end
				end
				if (((1708 - (171 + 991)) <= (4438 - 3361)) and (v15:HealthPercentage() <= v69) and v58 and v98.LayonHands:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
					if (v25(v100.LayonHandsPlayer) or ((2674 - 1678) > (10732 - 6431))) then
						return "lay_on_hands defensive 2";
					end
				end
				v131 = 1 + 0;
			end
			if (((14266 - 10196) > (1981 - 1294)) and (v131 == (2 - 0))) then
				if ((v98.WordofGlory:IsReady() and (v15:HealthPercentage() <= v70) and v59 and not v15:HealingAbsorbed()) or ((2027 - 1371) >= (4578 - (111 + 1137)))) then
					if ((v15:BuffRemains(v98.ShieldoftheRighteousBuff) >= (163 - (91 + 67))) or v15:BuffUp(v98.DivinePurposeBuff) or v15:BuffUp(v98.ShiningLightFreeBuff) or ((7416 - 4924) <= (84 + 251))) then
						if (((4845 - (423 + 100)) >= (18 + 2544)) and v25(v100.WordofGloryPlayer)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v98.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (5 - 3)) and v15:BuffRefreshable(v98.ShieldoftheRighteousBuff) and v60 and (v102 or (v15:HealthPercentage() <= v71))) or ((1896 + 1741) >= (4541 - (326 + 445)))) then
					if (v25(v98.ShieldoftheRighteous) or ((10381 - 8002) > (10198 - 5620))) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v131 = 6 - 3;
			end
			if ((v131 == (714 - (530 + 181))) or ((1364 - (614 + 267)) > (775 - (19 + 13)))) then
				if (((3993 - 1539) > (1346 - 768)) and v99.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) then
					if (((2656 - 1726) < (1158 + 3300)) and v25(v100.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if (((1163 - 501) <= (2015 - 1043)) and v91 and (v15:HealthPercentage() <= v93)) then
					if (((6182 - (1293 + 519)) == (8916 - 4546)) and (v95 == "Refreshing Healing Potion")) then
						if (v99.RefreshingHealingPotion:IsReady() or ((12433 - 7671) <= (1646 - 785))) then
							if (v25(v100.RefreshingHealingPotion) or ((6088 - 4676) == (10044 - 5780))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v95 == "Dreamwalker's Healing Potion") or ((1678 + 1490) < (440 + 1713))) then
						if (v99.DreamwalkersHealingPotion:IsReady() or ((11561 - 6585) < (308 + 1024))) then
							if (((1538 + 3090) == (2893 + 1735)) and v25(v100.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v131 == (1097 - (709 + 387))) or ((1912 - (673 + 1185)) == (1145 - 750))) then
				if (((262 - 180) == (134 - 52)) and v98.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v98.ArdentDefenderBuff)) then
					if (v25(v98.GuardianofAncientKings) or ((416 + 165) < (211 + 71))) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v98.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v66) and v55 and v15:BuffDown(v98.GuardianofAncientKingsBuff)) or ((6222 - 1613) < (613 + 1882))) then
					if (((2296 - 1144) == (2260 - 1108)) and v25(v98.ArdentDefender)) then
						return "ardent_defender defensive 6";
					end
				end
				v131 = 1882 - (446 + 1434);
			end
		end
	end
	local function v120()
		local v132 = 1283 - (1040 + 243);
		while true do
			if (((5658 - 3762) <= (5269 - (559 + 1288))) and (v132 == (1932 - (609 + 1322)))) then
				if (v14 or ((1444 - (13 + 441)) > (6053 - 4433))) then
					local v215 = 0 - 0;
					while true do
						if ((v215 == (4 - 3)) or ((33 + 844) > (17051 - 12356))) then
							if (((956 + 1735) >= (812 + 1039)) and v98.BlessingofSacrifice:IsCastable() and v65 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) then
								if (v25(v100.BlessingofSacrificeFocus) or ((8858 - 5873) >= (2658 + 2198))) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if (((7863 - 3587) >= (791 + 404)) and v98.BlessingofProtection:IsCastable() and v64 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) then
								if (((1798 + 1434) <= (3370 + 1320)) and v25(v100.BlessingofProtectionFocus)) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if ((v215 == (0 + 0)) or ((877 + 19) >= (3579 - (153 + 280)))) then
							if (((8838 - 5777) >= (2656 + 302)) and v98.WordofGlory:IsReady() and v62 and v15:BuffUp(v98.ShiningLightFreeBuff) and (v14:HealthPercentage() <= v73)) then
								if (((1259 + 1928) >= (338 + 306)) and v25(v100.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if (((585 + 59) <= (511 + 193)) and v98.LayonHands:IsCastable() and v61 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v72)) then
								if (((1458 - 500) > (586 + 361)) and v25(v100.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v215 = 668 - (89 + 578);
						end
					end
				end
				break;
			end
			if (((3209 + 1283) >= (5517 - 2863)) and (v132 == (1049 - (572 + 477)))) then
				if (((465 + 2977) >= (902 + 601)) and v16:Exists()) then
					if ((v98.WordofGlory:IsReady() and v63 and (v16:HealthPercentage() <= v74)) or ((379 + 2791) <= (1550 - (84 + 2)))) then
						if (v25(v100.WordofGloryMouseover) or ((7905 - 3108) == (3162 + 1226))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((1393 - (497 + 345)) <= (18 + 663)) and (not v14 or not v14:Exists() or not v14:IsInRange(6 + 24))) then
					return;
				end
				v132 = 1334 - (605 + 728);
			end
		end
	end
	local function v121()
		if (((2339 + 938) > (904 - 497)) and (v86 < v110) and v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90)) then
			if (((216 + 4479) >= (5231 - 3816)) and v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((v86 < v110) and v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (5 + 0))) or ((8898 - 5686) <= (713 + 231))) then
			if (v25(v98.ArcaneTorrent, not v17:IsInRange(497 - (457 + 32))) or ((1314 + 1782) <= (3200 - (832 + 570)))) then
				return "arcane_torrent precombat 6";
			end
		end
		if (((3333 + 204) == (923 + 2614)) and v98.Consecration:IsCastable() and v36) then
			if (((13578 - 9741) >= (757 + 813)) and v25(v98.Consecration, not v17:IsInRange(804 - (588 + 208)))) then
				return "consecration";
			end
		end
		if ((v98.AvengersShield:IsCastable() and v34) or ((7950 - 5000) == (5612 - (884 + 916)))) then
			if (((9887 - 5164) >= (1345 + 973)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
				return "avengers_shield precombat 10";
			end
		end
		if ((v98.Judgment:IsReady() and v40) or ((2680 - (232 + 421)) > (4741 - (1569 + 320)))) then
			if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((279 + 857) > (821 + 3496))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v122()
		local v133 = 0 - 0;
		local v134;
		while true do
			if (((5353 - (316 + 289)) == (12428 - 7680)) and ((1 + 1) == v133)) then
				v134 = v108.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff));
				if (((5189 - (666 + 787)) <= (5165 - (360 + 65))) and v134) then
					return v134;
				end
				v133 = 3 + 0;
			end
			if (((254 - (79 + 175)) == v133) or ((5345 - 1955) <= (2388 + 672))) then
				if ((v98.AvengersShield:IsCastable() and v34 and (v10.CombatTime() < (5 - 3)) and v15:HasTier(55 - 26, 901 - (503 + 396))) or ((1180 - (92 + 89)) > (5223 - 2530))) then
					if (((238 + 225) < (356 + 245)) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v98.LightsJudgment:IsCastable() and v89 and ((v90 and v32) or not v90) and (v107 >= (7 - 5))) or ((299 + 1884) < (1566 - 879))) then
					if (((3969 + 580) == (2173 + 2376)) and v25(v98.LightsJudgment, not v17:IsSpellInRange(v98.LightsJudgment))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v133 = 2 - 1;
			end
			if (((584 + 4088) == (7124 - 2452)) and (v133 == (1248 - (485 + 759)))) then
				if ((v98.BastionofLight:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v98.AvengingWrathBuff) or (v98.AvengingWrath:CooldownRemains() <= (69 - 39)))) or ((4857 - (442 + 747)) < (1530 - (832 + 303)))) then
					if (v25(v98.BastionofLight, not v17:IsInRange(954 - (88 + 858))) or ((1270 + 2896) == (377 + 78))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if ((v133 == (1 + 0)) or ((5238 - (766 + 23)) == (13146 - 10483))) then
				if ((v98.AvengingWrath:IsCastable() and v41 and ((v47 and v32) or not v47)) or ((5849 - 1572) < (7874 - 4885))) then
					if (v25(v98.AvengingWrath, not v17:IsInRange(27 - 19)) or ((1943 - (1036 + 37)) >= (2942 + 1207))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if (((4307 - 2095) < (2504 + 679)) and v98.Sentinel:IsCastable() and v46 and ((v52 and v32) or not v52)) then
					if (((6126 - (641 + 839)) > (3905 - (910 + 3))) and v25(v98.Sentinel, not v17:IsInRange(20 - 12))) then
						return "sentinel cooldowns 8";
					end
				end
				v133 = 1686 - (1466 + 218);
			end
			if (((660 + 774) < (4254 - (556 + 592))) and (v133 == (2 + 1))) then
				if (((1594 - (329 + 479)) < (3877 - (174 + 680))) and v98.MomentofGlory:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v98.SentinelBuff) < (51 - 36)) or (((v10.CombatTime() > (20 - 10)) or (v98.Sentinel:CooldownRemains() > (11 + 4)) or (v98.AvengingWrath:CooldownRemains() > (754 - (396 + 343)))) and (v98.AvengersShield:CooldownRemains() > (0 + 0)) and (v98.Judgment:CooldownRemains() > (1477 - (29 + 1448))) and (v98.HammerofWrath:CooldownRemains() > (1389 - (135 + 1254)))))) then
					if (v25(v98.MomentofGlory, not v17:IsInRange(30 - 22)) or ((11401 - 8959) < (50 + 24))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if (((6062 - (389 + 1138)) == (5109 - (102 + 472))) and v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady() and (v106 >= (3 + 0))) then
					if (v25(v98.DivineToll, not v17:IsInRange(17 + 13)) or ((2806 + 203) <= (3650 - (320 + 1225)))) then
						return "divine_toll cooldowns 12";
					end
				end
				v133 = 6 - 2;
			end
		end
	end
	local function v123()
		local v135 = 0 + 0;
		while true do
			if (((3294 - (157 + 1307)) < (5528 - (821 + 1038))) and (v135 == (0 - 0))) then
				if ((v98.Consecration:IsCastable() and v36 and (v15:BuffStack(v98.SanctificationBuff) == (1 + 4))) or ((2540 - 1110) >= (1344 + 2268))) then
					if (((6649 - 3966) >= (3486 - (834 + 192))) and v25(v98.Consecration, not v17:IsInRange(1 + 7))) then
						return "consecration standard 2";
					end
				end
				if ((v98.ShieldoftheRighteous:IsCastable() and v60 and ((v15:HolyPower() > (1 + 1)) or v15:BuffUp(v98.BastionofLightBuff) or v15:BuffUp(v98.DivinePurposeBuff)) and (v15:BuffDown(v98.SanctificationBuff) or (v15:BuffStack(v98.SanctificationBuff) < (1 + 4)))) or ((2794 - 990) >= (3579 - (300 + 4)))) then
					if (v25(v98.ShieldoftheRighteous) or ((379 + 1038) > (9499 - 5870))) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((5157 - (112 + 250)) > (161 + 241)) and v98.Judgment:IsReady() and v40 and (v106 > (7 - 4)) and (v15:BuffStack(v98.BulwarkofRighteousFuryBuff) >= (2 + 1)) and (v15:HolyPower() < (2 + 1))) then
					local v216 = 0 + 0;
					while true do
						if (((2387 + 2426) > (2649 + 916)) and (v216 == (1414 - (1001 + 413)))) then
							if (((8723 - 4811) == (4794 - (244 + 638))) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 6";
							end
							if (((3514 - (627 + 66)) <= (14373 - 9549)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				v135 = 603 - (512 + 90);
			end
			if (((3644 - (1665 + 241)) <= (2912 - (373 + 344))) and (v135 == (1 + 0))) then
				if (((11 + 30) <= (7960 - 4942)) and v98.Judgment:IsReady() and v40 and v15:BuffDown(v98.SanctificationEmpowerBuff) and v15:HasTier(52 - 21, 1101 - (35 + 1064))) then
					if (((1561 + 584) <= (8780 - 4676)) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment standard 8";
					end
					if (((11 + 2678) < (6081 - (298 + 938))) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment standard 8";
					end
				end
				if ((v98.HammerofWrath:IsReady() and v39) or ((3581 - (233 + 1026)) > (4288 - (636 + 1030)))) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((2319 + 2215) == (2034 + 48))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v98.Judgment:IsReady() and v40 and ((v98.Judgment:Charges() >= (1 + 1)) or (v98.Judgment:FullRechargeTime() <= v15:GCD()))) or ((107 + 1464) > (2088 - (55 + 166)))) then
					local v217 = 0 + 0;
					while true do
						if ((v217 == (0 + 0)) or ((10135 - 7481) >= (3293 - (36 + 261)))) then
							if (((6956 - 2978) > (3472 - (34 + 1334))) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 12";
							end
							if (((1152 + 1843) > (1198 + 343)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v135 = 1285 - (1035 + 248);
			end
			if (((3270 - (20 + 1)) > (497 + 456)) and ((322 - (134 + 185)) == v135)) then
				if ((v98.HammerofWrath:IsReady() and v39) or ((4406 - (549 + 584)) > (5258 - (314 + 371)))) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((10817 - 7666) < (2252 - (478 + 490)))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if ((v98.Judgment:IsReady() and v40) or ((981 + 869) == (2701 - (786 + 386)))) then
					local v218 = 0 - 0;
					while true do
						if (((2200 - (1055 + 324)) < (3463 - (1093 + 247))) and (v218 == (0 + 0))) then
							if (((95 + 807) < (9230 - 6905)) and v108.CastCycle(v98.Judgment, v104, v113, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 22";
							end
							if (((2911 - 2053) <= (8428 - 5466)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if ((v98.Consecration:IsCastable() and v36 and v15:BuffDown(v98.ConsecrationBuff) and ((v15:BuffStack(v98.SanctificationBuff) < (12 - 7)) or not v15:HasTier(12 + 19, 7 - 5))) or ((13600 - 9654) < (972 + 316))) then
					if (v25(v98.Consecration, not v17:IsInRange(20 - 12)) or ((3930 - (364 + 324)) == (1554 - 987))) then
						return "consecration standard 24";
					end
				end
				v135 = 9 - 5;
			end
			if (((2 + 3) == v135) or ((3544 - 2697) >= (2022 - 759))) then
				if ((v98.CrusaderStrike:IsCastable() and v37) or ((6842 - 4589) == (3119 - (1249 + 19)))) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((1884 + 203) > (9232 - 6860))) then
						return "crusader_strike standard 32";
					end
				end
				if (((v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and not v98.InmostLight:IsAvailable()) or ((5531 - (686 + 400)) < (3256 + 893))) then
					if (v25(v98.EyeofTyr, not v17:IsInRange(237 - (73 + 156))) or ((9 + 1809) == (896 - (721 + 90)))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((8 + 622) < (6905 - 4778)) and v98.ArcaneTorrent:IsCastable() and v89 and ((v90 and v32) or not v90) and (v111 < (475 - (224 + 246)))) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(12 - 4)) or ((3567 - 1629) == (457 + 2057))) then
						return "arcane_torrent standard 36";
					end
				end
				v135 = 1 + 5;
			end
			if (((3126 + 1129) >= (109 - 54)) and (v135 == (12 - 8))) then
				if (((3512 - (203 + 310)) > (3149 - (1238 + 755))) and (v86 < v110) and v44 and ((v50 and v32) or not v50) and v98.EyeofTyr:IsCastable() and v98.InmostLight:IsAvailable() and (v106 >= (1 + 2))) then
					if (((3884 - (709 + 825)) > (2127 - 972)) and v25(v98.EyeofTyr, not v17:IsInRange(11 - 3))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((4893 - (196 + 668)) <= (19160 - 14307)) and v98.BlessedHammer:IsCastable() and v35) then
					if (v25(v98.BlessedHammer, not v17:IsInRange(16 - 8)) or ((1349 - (171 + 662)) > (3527 - (4 + 89)))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((14180 - 10134) >= (1105 + 1928)) and v98.HammeroftheRighteous:IsCastable() and v38) then
					if (v25(v98.HammeroftheRighteous, not v17:IsInRange(35 - 27)) or ((1067 + 1652) <= (2933 - (35 + 1451)))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v135 = 1458 - (28 + 1425);
			end
			if ((v135 == (1999 - (941 + 1052))) or ((3964 + 170) < (5440 - (822 + 692)))) then
				if ((v98.Consecration:IsCastable() and v36 and (v15:BuffDown(v98.SanctificationEmpowerBuff))) or ((233 - 69) >= (1312 + 1473))) then
					if (v25(v98.Consecration, not v17:IsInRange(305 - (45 + 252))) or ((520 + 5) == (726 + 1383))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if (((80 - 47) == (466 - (114 + 319))) and (v135 == (2 - 0))) then
				if (((3912 - 858) <= (2560 + 1455)) and v98.AvengersShield:IsCastable() and v34 and ((v107 > (2 - 0)) or v15:BuffUp(v98.MomentofGloryBuff))) then
					if (((3920 - 2049) < (5345 - (556 + 1407))) and v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if (((2499 - (741 + 465)) <= (2631 - (170 + 295))) and v43 and ((v49 and v32) or not v49) and v98.DivineToll:IsReady()) then
					if (v25(v98.DivineToll, not v17:IsInRange(16 + 14)) or ((2369 + 210) < (302 - 179))) then
						return "divine_toll standard 16";
					end
				end
				if ((v98.AvengersShield:IsCastable() and v34) or ((702 + 144) >= (1519 + 849))) then
					if (v25(v98.AvengersShield, not v17:IsSpellInRange(v98.AvengersShield)) or ((2272 + 1740) <= (4588 - (957 + 273)))) then
						return "avengers_shield standard 18";
					end
				end
				v135 = 1 + 2;
			end
		end
	end
	local function v124()
		local v136 = 0 + 0;
		while true do
			if (((5692 - 4198) <= (7918 - 4913)) and (v136 == (0 - 0))) then
				v34 = EpicSettings.Settings['useAvengersShield'];
				v35 = EpicSettings.Settings['useBlessedHammer'];
				v36 = EpicSettings.Settings['useConsecration'];
				v136 = 4 - 3;
			end
			if ((v136 == (1782 - (389 + 1391))) or ((1952 + 1159) == (223 + 1911))) then
				v40 = EpicSettings.Settings['useJudgment'];
				v41 = EpicSettings.Settings['useAvengingWrath'];
				v42 = EpicSettings.Settings['useBastionofLight'];
				v136 = 6 - 3;
			end
			if (((3306 - (783 + 168)) == (7903 - 5548)) and (v136 == (3 + 0))) then
				v43 = EpicSettings.Settings['useDivineToll'];
				v44 = EpicSettings.Settings['useEyeofTyr'];
				v45 = EpicSettings.Settings['useMomentOfGlory'];
				v136 = 315 - (309 + 2);
			end
			if ((v136 == (18 - 12)) or ((1800 - (1090 + 122)) <= (141 + 291))) then
				v52 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if (((16110 - 11313) >= (2666 + 1229)) and (v136 == (1119 - (628 + 490)))) then
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v38 = EpicSettings.Settings['useHammeroftheRighteous'];
				v39 = EpicSettings.Settings['useHammerofWrath'];
				v136 = 1 + 1;
			end
			if (((8855 - 5278) == (16346 - 12769)) and (v136 == (778 - (431 + 343)))) then
				v46 = EpicSettings.Settings['useSentinel'];
				v47 = EpicSettings.Settings['avengingWrathWithCD'];
				v48 = EpicSettings.Settings['bastionofLightWithCD'];
				v136 = 10 - 5;
			end
			if (((10975 - 7181) > (2918 + 775)) and (v136 == (1 + 4))) then
				v49 = EpicSettings.Settings['divineTollWithCD'];
				v50 = EpicSettings.Settings['eyeofTyrWithCD'];
				v51 = EpicSettings.Settings['momentofGloryWithCD'];
				v136 = 1701 - (556 + 1139);
			end
		end
	end
	local function v125()
		v53 = EpicSettings.Settings['useRebuke'];
		v54 = EpicSettings.Settings['useHammerofJustice'];
		v55 = EpicSettings.Settings['useArdentDefender'];
		v56 = EpicSettings.Settings['useDivineShield'];
		v57 = EpicSettings.Settings['useGuardianofAncientKings'];
		v58 = EpicSettings.Settings['useLayOnHands'];
		v59 = EpicSettings.Settings['useWordofGloryPlayer'];
		v60 = EpicSettings.Settings['useShieldoftheRighteous'];
		v61 = EpicSettings.Settings['useLayOnHandsFocus'];
		v62 = EpicSettings.Settings['useWordofGloryFocus'];
		v63 = EpicSettings.Settings['useWordofGloryMouseover'];
		v64 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v65 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v66 = EpicSettings.Settings['ardentDefenderHP'];
		v67 = EpicSettings.Settings['divineShieldHP'];
		v68 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v69 = EpicSettings.Settings['layonHandsHP'];
		v70 = EpicSettings.Settings['wordofGloryHP'];
		v71 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v72 = EpicSettings.Settings['layOnHandsFocusHP'];
		v73 = EpicSettings.Settings['wordofGloryFocusHP'];
		v74 = EpicSettings.Settings['wordofGloryMouseoverHP'];
		v75 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v126()
		v86 = EpicSettings.Settings['fightRemainsCheck'] or (15 - (6 + 9));
		v83 = EpicSettings.Settings['InterruptWithStun'];
		v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v85 = EpicSettings.Settings['InterruptThreshold'];
		v80 = EpicSettings.Settings['DispelDebuffs'];
		v79 = EpicSettings.Settings['DispelBuffs'];
		v87 = EpicSettings.Settings['useTrinkets'];
		v89 = EpicSettings.Settings['useRacials'];
		v88 = EpicSettings.Settings['trinketsWithCD'];
		v90 = EpicSettings.Settings['racialsWithCD'];
		v92 = EpicSettings.Settings['useHealthstone'];
		v91 = EpicSettings.Settings['useHealingPotion'];
		v94 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v93 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
		v95 = EpicSettings.Settings['HealingPotionName'] or "";
		v81 = EpicSettings.Settings['handleAfflicted'];
		v82 = EpicSettings.Settings['HandleIncorporeal'];
		v96 = EpicSettings.Settings['HealOOC'];
		v97 = EpicSettings.Settings['HealOOCHP'] or (169 - (28 + 141));
	end
	local function v127()
		v125();
		v124();
		v126();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (v15:IsDeadOrGhost() or ((494 + 781) == (5060 - 960))) then
			return v29;
		end
		v104 = v15:GetEnemiesInMeleeRange(6 + 2);
		v105 = v15:GetEnemiesInRange(1347 - (486 + 831));
		if (v31 or ((4140 - 2549) >= (12603 - 9023))) then
			local v184 = 0 + 0;
			while true do
				if (((3107 - 2124) <= (3071 - (668 + 595))) and (v184 == (0 + 0))) then
					v106 = #v104;
					v107 = #v105;
					break;
				end
			end
		else
			local v185 = 0 + 0;
			while true do
				if ((v185 == (0 - 0)) or ((2440 - (23 + 267)) <= (3141 - (1129 + 815)))) then
					v106 = 388 - (371 + 16);
					v107 = 1751 - (1326 + 424);
					break;
				end
			end
		end
		v102 = v15:ActiveMitigationNeeded();
		v103 = v15:IsTankingAoE(14 - 6) or v15:IsTanking(v17);
		if (((13772 - 10003) >= (1291 - (88 + 30))) and not v15:AffectingCombat() and v15:IsMounted()) then
			if (((2256 - (720 + 51)) == (3303 - 1818)) and v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) then
				if (v25(v98.CrusaderAura) or ((5091 - (421 + 1355)) <= (4588 - 1806))) then
					return "crusader_aura";
				end
			end
		end
		if (v15:AffectingCombat() or (v80 and v98.CleanseToxins:IsAvailable()) or ((431 + 445) >= (4047 - (286 + 797)))) then
			local v186 = 0 - 0;
			local v187;
			while true do
				if ((v186 == (1 - 0)) or ((2671 - (397 + 42)) > (780 + 1717))) then
					if (v29 or ((2910 - (24 + 776)) <= (510 - 178))) then
						return v29;
					end
					break;
				end
				if (((4471 - (222 + 563)) > (6988 - 3816)) and (v186 == (0 + 0))) then
					v187 = v80 and v98.CleanseToxins:IsReady() and v33;
					v29 = v108.FocusUnit(v187, v100, 210 - (23 + 167), nil, 1823 - (690 + 1108));
					v186 = 1 + 0;
				end
			end
		end
		if ((v33 and v80) or ((3691 + 783) < (1668 - (40 + 808)))) then
			local v188 = 0 + 0;
			while true do
				if (((16362 - 12083) >= (2755 + 127)) and ((1 + 0) == v188)) then
					if ((v98.BlessingofFreedom:IsReady() and v108.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((1113 + 916) >= (4092 - (47 + 524)))) then
						if (v25(v100.BlessingofFreedomFocus) or ((1322 + 715) >= (12689 - 8047))) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
				if (((2571 - 851) < (10166 - 5708)) and (v188 == (1726 - (1165 + 561)))) then
					v29 = v108.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 2 + 38, 77 - 52);
					if (v29 or ((167 + 269) > (3500 - (341 + 138)))) then
						return v29;
					end
					v188 = 1 + 0;
				end
			end
		end
		if (((1471 - 758) <= (1173 - (89 + 237))) and (v108.TargetIsValid() or v15:AffectingCombat())) then
			local v189 = 0 - 0;
			while true do
				if (((4534 - 2380) <= (4912 - (581 + 300))) and ((1221 - (855 + 365)) == v189)) then
					if (((10961 - 6346) == (1507 + 3108)) and (v110 == (12346 - (1030 + 205)))) then
						v110 = v10.FightRemains(v104, false);
					end
					v111 = v15:HolyPower();
					break;
				end
				if ((v189 == (0 + 0)) or ((3526 + 264) == (786 - (156 + 130)))) then
					v109 = v10.BossFightRemains(nil, true);
					v110 = v109;
					v189 = 2 - 1;
				end
			end
		end
		if (((149 - 60) < (452 - 231)) and not v15:AffectingCombat()) then
			if (((542 + 1512) >= (829 + 592)) and v98.DevotionAura:IsCastable() and (v114())) then
				if (((761 - (10 + 59)) < (865 + 2193)) and v25(v98.DevotionAura)) then
					return "devotion_aura";
				end
			end
		end
		if (v81 or ((16025 - 12771) == (2818 - (671 + 492)))) then
			if (v77 or ((1032 + 264) == (6125 - (369 + 846)))) then
				local v213 = 0 + 0;
				while true do
					if (((2875 + 493) == (5313 - (1036 + 909))) and (v213 == (0 + 0))) then
						v29 = v108.HandleAfflicted(v98.CleanseToxins, v100.CleanseToxinsMouseover, 67 - 27);
						if (((2846 - (11 + 192)) < (1928 + 1887)) and v29) then
							return v29;
						end
						break;
					end
				end
			end
			if (((2088 - (135 + 40)) > (1194 - 701)) and v15:BuffUp(v98.ShiningLightFreeBuff) and v78) then
				local v214 = 0 + 0;
				while true do
					if (((10475 - 5720) > (5138 - 1710)) and (v214 == (176 - (50 + 126)))) then
						v29 = v108.HandleAfflicted(v98.WordofGlory, v100.WordofGloryMouseover, 111 - 71, true);
						if (((306 + 1075) <= (3782 - (1233 + 180))) and v29) then
							return v29;
						end
						break;
					end
				end
			end
		end
		if (v82 or ((5812 - (522 + 447)) == (5505 - (107 + 1314)))) then
			v29 = v108.HandleIncorporeal(v98.Repentance, v100.RepentanceMouseOver, 14 + 16, true);
			if (((14226 - 9557) > (155 + 208)) and v29) then
				return v29;
			end
			v29 = v108.HandleIncorporeal(v98.TurnEvil, v100.TurnEvilMouseOver, 59 - 29, true);
			if (v29 or ((7426 - 5549) >= (5048 - (716 + 1194)))) then
				return v29;
			end
		end
		v29 = v117();
		if (((81 + 4661) >= (389 + 3237)) and v29) then
			return v29;
		end
		if ((v80 and v33) or ((5043 - (74 + 429)) == (1766 - 850))) then
			local v190 = 0 + 0;
			while true do
				if ((v190 == (0 - 0)) or ((818 + 338) > (13395 - 9050))) then
					if (((5530 - 3293) < (4682 - (279 + 154))) and v14) then
						local v219 = 778 - (454 + 324);
						while true do
							if ((v219 == (0 + 0)) or ((2700 - (12 + 5)) < (13 + 10))) then
								v29 = v116();
								if (((1775 - 1078) <= (306 + 520)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if (((2198 - (277 + 816)) <= (5024 - 3848)) and v16 and v16:Exists() and v16:IsAPlayer() and (v108.UnitHasCurseDebuff(v16) or v108.UnitHasPoisonDebuff(v16))) then
						if (((4562 - (1058 + 125)) <= (715 + 3097)) and v98.CleanseToxins:IsReady()) then
							if (v25(v100.CleanseToxinsMouseover) or ((1763 - (815 + 160)) >= (6933 - 5317))) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
					break;
				end
			end
		end
		v29 = v120();
		if (((4400 - 2546) <= (807 + 2572)) and v29) then
			return v29;
		end
		if (((13297 - 8748) == (6447 - (41 + 1857))) and v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
			if (v25(v100.RedemptionMouseover) or ((4915 - (1222 + 671)) >= (7815 - 4791))) then
				return "redemption mouseover";
			end
		end
		if (((6928 - 2108) > (3380 - (229 + 953))) and v15:AffectingCombat()) then
			if ((v98.Intercession:IsCastable() and (v15:HolyPower() >= (1777 - (1111 + 663))) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((2640 - (874 + 705)) >= (685 + 4206))) then
				if (((931 + 433) <= (9297 - 4824)) and v25(v100.IntercessionMouseover)) then
					return "Intercession";
				end
			end
		end
		if ((v108.TargetIsValid() and not v15:AffectingCombat() and v30) or ((102 + 3493) <= (682 - (642 + 37)))) then
			local v191 = 0 + 0;
			while true do
				if ((v191 == (0 + 0)) or ((11730 - 7058) == (4306 - (233 + 221)))) then
					v29 = v121();
					if (((3604 - 2045) == (1373 + 186)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (v108.TargetIsValid() or ((3293 - (718 + 823)) <= (496 + 292))) then
			local v192 = 805 - (266 + 539);
			while true do
				if ((v192 == (0 - 0)) or ((5132 - (636 + 589)) == (419 - 242))) then
					if (((7157 - 3687) > (440 + 115)) and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
						if (v15:AffectingCombat() or ((354 + 618) == (1660 - (657 + 358)))) then
							if (((8424 - 5242) >= (4818 - 2703)) and v98.Intercession:IsCastable()) then
								if (((5080 - (1151 + 36)) < (4278 + 151)) and v25(v98.Intercession, not v17:IsInRange(8 + 22), true)) then
									return "intercession";
								end
							end
						elseif (v98.Redemption:IsCastable() or ((8561 - 5694) < (3737 - (1552 + 280)))) then
							if (v25(v98.Redemption, not v17:IsInRange(864 - (64 + 770)), true) or ((1220 + 576) >= (9195 - 5144))) then
								return "redemption";
							end
						end
					end
					if (((288 + 1331) <= (4999 - (157 + 1086))) and v108.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
						local v220 = 0 - 0;
						while true do
							if (((2645 - 2041) == (926 - 322)) and (v220 == (1 - 0))) then
								if ((v87 and ((v32 and v88) or not v88) and v17:IsInRange(827 - (599 + 220))) or ((8929 - 4445) == (2831 - (1813 + 118)))) then
									v29 = v118();
									if (v29 or ((3260 + 1199) <= (2330 - (841 + 376)))) then
										return v29;
									end
								end
								v29 = v123();
								v220 = 2 - 0;
							end
							if (((844 + 2788) > (9274 - 5876)) and (v220 == (861 - (464 + 395)))) then
								if (((10475 - 6393) <= (2362 + 2555)) and v29) then
									return v29;
								end
								if (((5669 - (467 + 370)) >= (2863 - 1477)) and v25(v98.Pool)) then
									return "Wait/Pool Resources";
								end
								break;
							end
							if (((101 + 36) == (469 - 332)) and ((0 + 0) == v220)) then
								if (v103 or ((3652 - 2082) >= (4852 - (150 + 370)))) then
									v29 = v119();
									if (v29 or ((5346 - (74 + 1208)) <= (4473 - 2654))) then
										return v29;
									end
								end
								if ((v86 < v110) or ((23646 - 18660) < (1120 + 454))) then
									v29 = v122();
									if (((4816 - (14 + 376)) > (297 - 125)) and v29) then
										return v29;
									end
								end
								v220 = 1 + 0;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v128()
		local v181 = 0 + 0;
		while true do
			if (((559 + 27) > (1333 - 878)) and (v181 == (0 + 0))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v112();
				break;
			end
		end
	end
	v21.SetAPL(144 - (23 + 55), v127, v128);
end;
return v0["Epix_Paladin_Protection.lua"]();

