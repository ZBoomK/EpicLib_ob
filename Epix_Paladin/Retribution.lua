local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1773 - (1755 + 18);
	local v6;
	while true do
		if (((2950 - (559 + 1288)) == (3034 - (609 + 1322))) and (v5 == (454 - (13 + 441)))) then
			v6 = v0[v4];
			if (((6827 - 5000) < (7030 - 4346)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 4 - 3;
		end
		if (((111 + 2864) > (5320 - 3855)) and (v5 == (1 + 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Paladin_Retribution.lua"] = function(...)
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
	local v28 = math.min;
	local v29 = math.max;
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v97 = v21.Commons.Everyone;
	local v98 = v19.Paladin.Retribution;
	local v99 = v20.Paladin.Retribution;
	local v100 = {};
	local function v101()
		if (v98.CleanseToxins:IsAvailable() or ((747 + 957) < (4489 - 2976))) then
			v97.DispellableDebuffs = v13.MergeTable(v97.DispellableDiseaseDebuffs, v97.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v101();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v102 = v24.Paladin.Retribution;
	local v103;
	local v104;
	local v105 = 6081 + 5030;
	local v106 = 20435 - 9324;
	local v107;
	local v108 = 0 + 0;
	local v109 = 0 + 0;
	local v110;
	v10:RegisterForEvent(function()
		local v126 = 0 + 0;
		while true do
			if (((577 + 110) == (673 + 14)) and (v126 == (433 - (153 + 280)))) then
				v105 = 32083 - 20972;
				v106 = 9976 + 1135;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		local v127 = 0 + 0;
		local v128;
		local v129;
		while true do
			if ((v127 == (1 + 0)) or ((596 + 60) >= (2413 + 917))) then
				if ((v128 > v129) or ((3793 - 1301) <= (208 + 127))) then
					return v128;
				end
				return v129;
			end
			if (((4989 - (89 + 578)) >= (1831 + 731)) and (v127 == (0 - 0))) then
				v128 = v15:GCDRemains();
				v129 = v28(v98.CrusaderStrike:CooldownRemains(), v98.BladeofJustice:CooldownRemains(), v98.Judgment:CooldownRemains(), (v98.HammerofWrath:IsUsable() and v98.HammerofWrath:CooldownRemains()) or (1059 - (572 + 477)), v98.WakeofAshes:CooldownRemains());
				v127 = 1 + 0;
			end
		end
	end
	local function v112()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local function v113()
		if ((v98.CleanseToxins:IsReady() and v97.DispellableFriendlyUnit(16 + 9)) or ((435 + 3202) >= (3856 - (84 + 2)))) then
			local v143 = 0 - 0;
			while true do
				if (((0 + 0) == v143) or ((3221 - (497 + 345)) > (118 + 4460))) then
					v97.Wait(1 + 0);
					if (v25(v102.CleanseToxinsFocus) or ((1816 - (605 + 728)) > (531 + 212))) then
						return "cleanse_toxins dispel";
					end
					break;
				end
			end
		end
	end
	local function v114()
		if (((5455 - 3001) > (27 + 551)) and v94 and (v15:HealthPercentage() <= v95)) then
			if (((3438 - 2508) < (4019 + 439)) and v98.FlashofLight:IsReady()) then
				if (((1833 - 1171) <= (734 + 238)) and v25(v98.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v115()
		local v130 = 489 - (457 + 32);
		while true do
			if (((1855 + 2515) == (5772 - (832 + 570))) and (v130 == (0 + 0))) then
				if (v16:Exists() or ((1242 + 3520) <= (3046 - 2185))) then
					if ((v98.WordofGlory:IsReady() and v64 and (v16:HealthPercentage() <= v72)) or ((681 + 731) == (5060 - (588 + 208)))) then
						if (v25(v102.WordofGloryMouseover) or ((8538 - 5370) < (3953 - (884 + 916)))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v14 or not v14:Exists() or not v14:IsInRange(62 - 32) or ((2886 + 2090) < (1985 - (232 + 421)))) then
					return;
				end
				v130 = 1890 - (1569 + 320);
			end
			if (((1136 + 3492) == (880 + 3748)) and (v130 == (3 - 2))) then
				if (v14 or ((659 - (316 + 289)) == (1033 - 638))) then
					local v197 = 0 + 0;
					while true do
						if (((1535 - (666 + 787)) == (507 - (360 + 65))) and (v197 == (0 + 0))) then
							if ((v98.WordofGlory:IsReady() and v63 and (v14:HealthPercentage() <= v71)) or ((835 - (79 + 175)) < (444 - 162))) then
								if (v25(v102.WordofGloryFocus) or ((3597 + 1012) < (7647 - 5152))) then
									return "word_of_glory defensive focus";
								end
							end
							if (((2218 - 1066) == (2051 - (503 + 396))) and v98.LayonHands:IsCastable() and v62 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v70)) then
								if (((2077 - (92 + 89)) <= (6638 - 3216)) and v25(v102.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v197 = 1 + 0;
						end
						if ((v197 == (1 + 0)) or ((3876 - 2886) > (222 + 1398))) then
							if ((v98.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) or ((1999 - 1122) > (4097 + 598))) then
								if (((1286 + 1405) >= (5637 - 3786)) and v25(v102.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((v98.BlessingofProtection:IsCastable() and v65 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) or ((373 + 2612) >= (7405 - 2549))) then
								if (((5520 - (485 + 759)) >= (2765 - 1570)) and v25(v102.BlessingofProtectionFocus)) then
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
	local function v116()
		local v131 = 1189 - (442 + 747);
		while true do
			if (((4367 - (832 + 303)) <= (5636 - (88 + 858))) and (v131 == (0 + 0))) then
				v30 = v97.HandleTopTrinket(v100, v33, 34 + 6, nil);
				if (v30 or ((37 + 859) >= (3935 - (766 + 23)))) then
					return v30;
				end
				v131 = 4 - 3;
			end
			if (((4186 - 1125) >= (7793 - 4835)) and (v131 == (3 - 2))) then
				v30 = v97.HandleBottomTrinket(v100, v33, 1113 - (1036 + 37), nil);
				if (((2260 + 927) >= (1253 - 609)) and v30) then
					return v30;
				end
				break;
			end
		end
	end
	local function v117()
		local v132 = 0 + 0;
		while true do
			if (((2124 - (641 + 839)) <= (1617 - (910 + 3))) and (v132 == (0 - 0))) then
				if (((2642 - (1466 + 218)) > (436 + 511)) and v98.ArcaneTorrent:IsCastable() and v87 and ((v88 and v33) or not v88) and v98.FinalReckoning:IsAvailable()) then
					if (((5640 - (556 + 592)) >= (944 + 1710)) and v25(v98.ArcaneTorrent, not v17:IsInRange(816 - (329 + 479)))) then
						return "arcane_torrent precombat 0";
					end
				end
				if (((4296 - (174 + 680)) >= (5164 - 3661)) and v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56)) then
					if (v25(v98.ShieldofVengeance, not v17:IsInRange(16 - 8)) or ((2264 + 906) <= (2203 - (396 + 343)))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v132 = 1 + 0;
			end
			if ((v132 == (1481 - (29 + 1448))) or ((6186 - (135 + 1254)) == (16530 - 12142))) then
				if (((2572 - 2021) <= (454 + 227)) and v98.CrusaderStrike:IsCastable() and v37) then
					if (((4804 - (389 + 1138)) > (981 - (102 + 472))) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if (((4431 + 264) >= (785 + 630)) and (v132 == (2 + 0))) then
				if ((v98.TemplarsVerdict:IsReady() and v48 and (v108 >= (1549 - (320 + 1225)))) or ((5717 - 2505) <= (578 + 366))) then
					if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((4560 - (157 + 1307)) <= (3657 - (821 + 1038)))) then
						return "templars verdict precombat 4";
					end
				end
				if (((8824 - 5287) == (387 + 3150)) and v98.BladeofJustice:IsCastable() and v35) then
					if (((6815 - 2978) >= (585 + 985)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				v132 = 7 - 4;
			end
			if ((v132 == (1027 - (834 + 192))) or ((188 + 2762) == (979 + 2833))) then
				if (((102 + 4621) >= (3590 - 1272)) and v98.JusticarsVengeance:IsAvailable() and v98.JusticarsVengeance:IsReady() and v44 and (v108 >= (308 - (300 + 4)))) then
					if (v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance)) or ((542 + 1485) > (7465 - 4613))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if ((v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsReady() and v48 and (v108 >= (366 - (112 + 250)))) or ((453 + 683) > (10814 - 6497))) then
					if (((2721 + 2027) == (2456 + 2292)) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				v132 = 2 + 0;
			end
			if (((1853 + 1883) <= (3522 + 1218)) and (v132 == (1417 - (1001 + 413)))) then
				if ((v98.Judgment:IsCastable() and v43) or ((7559 - 4169) <= (3942 - (244 + 638)))) then
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((1692 - (627 + 66)) > (8023 - 5330))) then
						return "judgment precombat 6";
					end
				end
				if (((1065 - (512 + 90)) < (2507 - (1665 + 241))) and v98.HammerofWrath:IsReady() and v42) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((2900 - (373 + 344)) < (310 + 377))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v132 = 2 + 2;
			end
		end
	end
	local function v118()
		local v133 = v97.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15.BuffStack(v98.Crusade) == (26 - 16))) or (v106 < (41 - 16)));
		if (((5648 - (35 + 1064)) == (3310 + 1239)) and v133) then
			return v133;
		end
		if (((9995 - 5323) == (19 + 4653)) and v98.LightsJudgment:IsCastable() and v87 and ((v88 and v33) or not v88)) then
			if (v25(v98.LightsJudgment, not v17:IsInRange(1276 - (298 + 938))) or ((4927 - (233 + 1026)) < (2061 - (636 + 1030)))) then
				return "lights_judgment cooldowns 4";
			end
		end
		if ((v98.Fireblood:IsCastable() and v87 and ((v88 and v33) or not v88) and (v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) == (6 + 4))))) or ((4070 + 96) == (136 + 319))) then
			if (v25(v98.Fireblood, not v17:IsInRange(1 + 9)) or ((4670 - (55 + 166)) == (517 + 2146))) then
				return "fireblood cooldowns 6";
			end
		end
		if ((v85 and ((v33 and v86) or not v86) and v17:IsInRange(1 + 7)) or ((16334 - 12057) < (3286 - (36 + 261)))) then
			local v144 = 0 - 0;
			while true do
				if (((1368 - (34 + 1334)) == v144) or ((335 + 535) >= (3224 + 925))) then
					v30 = v116();
					if (((3495 - (1035 + 248)) < (3204 - (20 + 1))) and v30) then
						return v30;
					end
					break;
				end
			end
		end
		if (((2421 + 2225) > (3311 - (134 + 185))) and v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56) and (v106 > (1148 - (549 + 584))) and (not v98.ExecutionSentence:IsAvailable() or v17:DebuffDown(v98.ExecutionSentence))) then
			if (((2119 - (314 + 371)) < (10662 - 7556)) and v25(v98.ShieldofVengeance)) then
				return "shield_of_vengeance cooldowns 10";
			end
		end
		if (((1754 - (478 + 490)) < (1602 + 1421)) and v98.ExecutionSentence:IsCastable() and v41 and ((v15:BuffDown(v98.CrusadeBuff) and (v98.Crusade:CooldownRemains() > (1187 - (786 + 386)))) or (v15:BuffStack(v98.CrusadeBuff) == (32 - 22)) or (v98.AvengingWrath:CooldownRemains() < (1379.75 - (1055 + 324))) or (v98.AvengingWrath:CooldownRemains() > (1355 - (1093 + 247)))) and (((v108 >= (4 + 0)) and (v10.CombatTime() < (1 + 4))) or ((v108 >= (11 - 8)) and (v10.CombatTime() > (16 - 11))) or ((v108 >= (5 - 3)) and v98.DivineAuxiliary:IsAvailable())) and (((v106 > (19 - 11)) and not v98.ExecutionersWill:IsAvailable()) or (v106 > (5 + 7)))) then
			if (v25(v98.ExecutionSentence, not v17:IsSpellInRange(v98.ExecutionSentence)) or ((9407 - 6965) < (255 - 181))) then
				return "execution_sentence cooldowns 16";
			end
		end
		if (((3420 + 1115) == (11597 - 7062)) and v98.AvengingWrath:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v108 >= (692 - (364 + 324))) and (v10.CombatTime() < (13 - 8))) or ((v108 >= (6 - 3)) and (v10.CombatTime() > (2 + 3))) or ((v108 >= (8 - 6)) and v98.DivineAuxiliary:IsAvailable() and ((v98.ExecutionSentence:IsAvailable() and ((v98.ExecutionSentence:CooldownRemains() == (0 - 0)) or (v98.ExecutionSentence:CooldownRemains() > (45 - 30)) or not v98.ExecutionSentence:IsReady())) or (v98.FinalReckoning:IsAvailable() and ((v98.FinalReckoning:CooldownRemains() == (1268 - (1249 + 19))) or (v98.FinalReckoning:CooldownRemains() > (28 + 2)) or not v98.FinalReckoning:IsReady())))))) then
			if (v25(v98.AvengingWrath, not v17:IsInRange(38 - 28)) or ((4095 - (686 + 400)) <= (1652 + 453))) then
				return "avenging_wrath cooldowns 12";
			end
		end
		if (((2059 - (73 + 156)) < (18 + 3651)) and v98.Crusade:IsCastable() and v50 and ((v33 and v54) or not v54) and (v15:BuffRemains(v98.CrusadeBuff) < v15:GCD()) and (((v108 >= (816 - (721 + 90))) and (v10.CombatTime() < (1 + 4))) or ((v108 >= (9 - 6)) and (v10.CombatTime() > (475 - (224 + 246)))))) then
			if (v25(v98.Crusade, not v17:IsInRange(16 - 6)) or ((2632 - 1202) >= (656 + 2956))) then
				return "crusade cooldowns 14";
			end
		end
		if (((64 + 2619) >= (1807 + 653)) and v98.FinalReckoning:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v108 >= (7 - 3)) and (v10.CombatTime() < (26 - 18))) or ((v108 >= (516 - (203 + 310))) and (v10.CombatTime() >= (2001 - (1238 + 755)))) or ((v108 >= (1 + 1)) and v98.DivineAuxiliary:IsAvailable())) and ((v98.AvengingWrath:CooldownRemains() > (1544 - (709 + 825))) or (v98.Crusade:CooldownDown() and (v15:BuffDown(v98.CrusadeBuff) or (v15:BuffStack(v98.CrusadeBuff) >= (18 - 8))))) and ((v107 > (0 - 0)) or (v108 == (869 - (196 + 668))) or ((v108 >= (7 - 5)) and v98.DivineAuxiliary:IsAvailable()))) then
			if ((v96 == "player") or ((3736 - 1932) >= (4108 - (171 + 662)))) then
				if (v25(v102.FinalReckoningPlayer, not v17:IsInRange(103 - (4 + 89))) or ((4966 - 3549) > (1322 + 2307))) then
					return "final_reckoning cooldowns 18";
				end
			end
			if (((21060 - 16265) > (158 + 244)) and (v96 == "cursor")) then
				if (((6299 - (35 + 1451)) > (5018 - (28 + 1425))) and v25(v102.FinalReckoningCursor, not v17:IsInRange(2013 - (941 + 1052)))) then
					return "final_reckoning cooldowns 18";
				end
			end
		end
	end
	local function v119()
		local v134 = 0 + 0;
		while true do
			if (((5426 - (822 + 692)) == (5584 - 1672)) and ((1 + 0) == v134)) then
				if (((3118 - (45 + 252)) <= (4774 + 50)) and v98.JusticarsVengeance:IsReady() and v44 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (2 + 1))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (24 - 14))))) then
					if (((2171 - (114 + 319)) <= (3151 - 956)) and v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((52 - 11) <= (1924 + 1094)) and v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsCastable() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (4 - 1))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (20 - 10))))) then
					if (((4108 - (556 + 1407)) <= (5310 - (741 + 465))) and v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict))) then
						return "final verdict finishers 6";
					end
				end
				v134 = 467 - (170 + 295);
			end
			if (((1417 + 1272) < (4451 + 394)) and (v134 == (4 - 2))) then
				if ((v98.TemplarsVerdict:IsReady() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (3 + 0))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (7 + 3))))) or ((1315 + 1007) > (3852 - (957 + 273)))) then
					if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((1213 + 3321) == (834 + 1248))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
			if ((v134 == (0 - 0)) or ((4139 - 2568) > (5702 - 3835))) then
				v110 = ((v104 >= (14 - 11)) or ((v104 >= (1782 - (389 + 1391))) and not v98.DivineArbiter:IsAvailable()) or v15:BuffUp(v98.EmpyreanPowerBuff)) and v15:BuffDown(v98.EmpyreanLegacyBuff) and not (v15:BuffUp(v98.DivineArbiterBuff) and (v15:BuffStack(v98.DivineArbiterBuff) > (16 + 8)));
				if ((v98.DivineStorm:IsReady() and v39 and v110 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (1 + 2))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (22 - 12))))) or ((3605 - (783 + 168)) >= (10054 - 7058))) then
					if (((3913 + 65) > (2415 - (309 + 2))) and v25(v98.DivineStorm, not v17:IsInRange(30 - 20))) then
						return "divine_storm finishers 2";
					end
				end
				v134 = 1213 - (1090 + 122);
			end
		end
	end
	local function v120()
		local v135 = 0 + 0;
		while true do
			if (((10058 - 7063) > (1055 + 486)) and (v135 == (1118 - (628 + 490)))) then
				if (((583 + 2666) > (2359 - 1406)) and ((v108 >= (22 - 17)) or (v15:BuffUp(v98.EchoesofWrathBuff) and v15:HasTier(805 - (431 + 343), 7 - 3) and v98.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v98.JudgmentDebuff) or (v108 == (11 - 7))) and v15:BuffUp(v98.DivineResonanceBuff) and not v15:HasTier(25 + 6, 1 + 1)))) then
					local v198 = 1695 - (556 + 1139);
					while true do
						if ((v198 == (15 - (6 + 9))) or ((600 + 2673) > (2343 + 2230))) then
							v30 = v119();
							if (v30 or ((3320 - (28 + 141)) < (498 + 786))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (3 - 0)) and v15:HasTier(22 + 9, 1319 - (486 + 831))) or ((4814 - 2964) == (5382 - 3853))) then
					if (((156 + 665) < (6712 - 4589)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 1";
					end
				end
				if (((2165 - (668 + 595)) < (2093 + 232)) and v98.WakeofAshes:IsCastable() and v47 and (v108 <= (1 + 1)) and ((v98.AvengingWrath:CooldownRemains() > (0 - 0)) or (v98.Crusade:CooldownRemains() > (290 - (23 + 267))) or not v98.Crusade:IsAvailable() or not v98.AvengingWrath:IsReady()) and (not v98.ExecutionSentence:IsAvailable() or (v98.ExecutionSentence:CooldownRemains() > (1948 - (1129 + 815))) or (v106 < (395 - (371 + 16))) or not v98.ExecutionSentence:IsReady())) then
					if (((2608 - (1326 + 424)) <= (5609 - 2647)) and v25(v98.WakeofAshes, not v17:IsInRange(36 - 26))) then
						return "wake_of_ashes generators 2";
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (121 - (88 + 30))) and v15:HasTier(802 - (720 + 51), 4 - 2)) or ((5722 - (421 + 1355)) < (2124 - 836))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((1593 + 1649) == (1650 - (286 + 797)))) then
						return "blade_of_justice generators 4";
					end
				end
				v135 = 3 - 2;
			end
			if ((v135 == (2 - 0)) or ((1286 - (397 + 42)) >= (395 + 868))) then
				if ((v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (803 - (24 + 776))) or not v98.HolyBlade:IsAvailable()) and (((v104 >= (2 - 0)) and not v98.CrusadingStrikes:IsAvailable()) or (v104 >= (789 - (222 + 563))))) or ((4963 - 2710) == (1333 + 518))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((2277 - (23 + 167)) > (4170 - (690 + 1108)))) then
						return "blade_of_justice generators 10";
					end
				end
				if ((v98.HammerofWrath:IsReady() and v42 and ((v104 < (1 + 1)) or not v98.BlessedChampion:IsAvailable() or v15:HasTier(25 + 5, 852 - (40 + 808))) and ((v108 <= (1 + 2)) or (v17:HealthPercentage() > (76 - 56)) or not v98.VanguardsMomentum:IsAvailable())) or ((4249 + 196) < (2195 + 1954))) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((997 + 821) == (656 - (47 + 524)))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if (((409 + 221) < (5814 - 3687)) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (5 - 1))) then
					if (v25(v98.TemplarSlash, not v17:IsSpellInRange(v98.TemplarSlash)) or ((4419 - 2481) == (4240 - (1165 + 561)))) then
						return "templar_slash generators 14";
					end
				end
				if (((127 + 4128) >= (170 - 115)) and v98.Judgment:IsReady() and v43 and v17:DebuffDown(v98.JudgmentDebuff) and ((v108 <= (2 + 1)) or not v98.BoundlessJudgment:IsAvailable())) then
					if (((3478 - (341 + 138)) > (313 + 843)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 16";
					end
				end
				v135 = 5 - 2;
			end
			if (((2676 - (89 + 237)) > (3715 - 2560)) and (v135 == (8 - 4))) then
				if (((4910 - (581 + 300)) <= (6073 - (855 + 365))) and v98.CrusaderStrike:IsCastable() and v37 and (v98.CrusaderStrike:ChargesFractional() >= (2.75 - 1)) and ((v108 <= (1 + 1)) or ((v108 <= (1238 - (1030 + 205))) and (v98.BladeofJustice:CooldownRemains() > (v109 * (2 + 0)))) or ((v108 == (4 + 0)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (288 - (156 + 130)))) and (v98.Judgment:CooldownRemains() > (v109 * (4 - 2)))))) then
					if (v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike)) or ((869 - 353) > (7032 - 3598))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v119();
				if (((1067 + 2979) >= (1769 + 1264)) and v30) then
					return v30;
				end
				if ((v98.TemplarSlash:IsReady() and v45) or ((2788 - (10 + 59)) <= (410 + 1037))) then
					if (v25(v98.TemplarSlash, not v17:IsInRange(49 - 39)) or ((5297 - (671 + 492)) < (3126 + 800))) then
						return "templar_slash generators 28";
					end
				end
				v135 = 1220 - (369 + 846);
			end
			if (((1 + 2) == v135) or ((140 + 24) >= (4730 - (1036 + 909)))) then
				if ((v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (3 + 0)) or not v98.HolyBlade:IsAvailable())) or ((881 - 356) == (2312 - (11 + 192)))) then
					if (((17 + 16) == (208 - (135 + 40))) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				if (((7399 - 4345) <= (2421 + 1594)) and ((v17:HealthPercentage() <= (44 - 24)) or v15:BuffUp(v98.AvengingWrathBuff) or v15:BuffUp(v98.CrusadeBuff) or v15:BuffUp(v98.EmpyreanPowerBuff))) then
					local v199 = 0 - 0;
					while true do
						if (((2047 - (50 + 126)) < (9417 - 6035)) and (v199 == (0 + 0))) then
							v30 = v119();
							if (((2706 - (1233 + 180)) <= (3135 - (522 + 447))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v98.Consecration:IsCastable() and v36 and v17:DebuffDown(v98.ConsecrationDebuff) and (v104 >= (1423 - (107 + 1314)))) or ((1197 + 1382) < (374 - 251))) then
					if (v25(v98.Consecration, not v17:IsInRange(5 + 5)) or ((1679 - 833) >= (9369 - 7001))) then
						return "consecration generators 22";
					end
				end
				if ((v98.DivineHammer:IsCastable() and v38 and (v104 >= (1912 - (716 + 1194)))) or ((69 + 3943) <= (360 + 2998))) then
					if (((1997 - (74 + 429)) <= (5796 - 2791)) and v25(v98.DivineHammer, not v17:IsInRange(5 + 5))) then
						return "divine_hammer generators 24";
					end
				end
				v135 = 8 - 4;
			end
			if (((1 + 0) == v135) or ((9590 - 6479) == (5276 - 3142))) then
				if (((2788 - (279 + 154)) == (3133 - (454 + 324))) and v98.DivineToll:IsCastable() and v40 and (v108 <= (2 + 0)) and ((v98.AvengingWrath:CooldownRemains() > (32 - (12 + 5))) or (v98.Crusade:CooldownRemains() > (9 + 6)) or (v106 < (20 - 12)))) then
					if (v25(v98.DivineToll, not v17:IsInRange(12 + 18)) or ((1681 - (277 + 816)) <= (1845 - 1413))) then
						return "divine_toll generators 6";
					end
				end
				if (((5980 - (1058 + 125)) >= (731 + 3164)) and v98.Judgment:IsReady() and v43 and v17:DebuffUp(v98.ExpurgationDebuff) and v15:BuffDown(v98.EchoesofWrathBuff) and v15:HasTier(1006 - (815 + 160), 8 - 6)) then
					if (((8490 - 4913) == (854 + 2723)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 7";
					end
				end
				if (((11090 - 7296) > (5591 - (41 + 1857))) and (v108 >= (1896 - (1222 + 671))) and v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (25 - 15))) then
					local v200 = 0 - 0;
					while true do
						if ((v200 == (1182 - (229 + 953))) or ((3049 - (1111 + 663)) == (5679 - (874 + 705)))) then
							v30 = v119();
							if (v30 or ((223 + 1368) >= (2443 + 1137))) then
								return v30;
							end
							break;
						end
					end
				end
				if (((2043 - 1060) <= (51 + 1757)) and v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (683 - (642 + 37))) and (v104 >= (1 + 1))) then
					if (v25(v98.TemplarSlash, not v17:IsInRange(2 + 8)) or ((5398 - 3248) <= (1651 - (233 + 221)))) then
						return "templar_slash generators 8";
					end
				end
				v135 = 4 - 2;
			end
			if (((3318 + 451) >= (2714 - (718 + 823))) and (v135 == (4 + 2))) then
				if (((2290 - (266 + 539)) == (4204 - 2719)) and v98.ArcaneTorrent:IsCastable() and ((v88 and v33) or not v88) and v87 and (v108 < (1230 - (636 + 589))) and (v84 < v106)) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(23 - 13)) or ((6837 - 3522) <= (2205 + 577))) then
						return "arcane_torrent generators 28";
					end
				end
				if ((v98.Consecration:IsCastable() and v36) or ((319 + 557) >= (3979 - (657 + 358)))) then
					if (v25(v98.Consecration, not v17:IsInRange(26 - 16)) or ((5084 - 2852) > (3684 - (1151 + 36)))) then
						return "consecration generators 30";
					end
				end
				if ((v98.DivineHammer:IsCastable() and v38) or ((2038 + 72) <= (88 + 244))) then
					if (((11007 - 7321) > (5004 - (1552 + 280))) and v25(v98.DivineHammer, not v17:IsInRange(844 - (64 + 770)))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if ((v135 == (4 + 1)) or ((10156 - 5682) < (146 + 674))) then
				if (((5522 - (157 + 1086)) >= (5768 - 2886)) and v98.TemplarStrike:IsReady() and v46) then
					if (v25(v98.TemplarStrike, not v17:IsInRange(43 - 33)) or ((3111 - 1082) >= (4805 - 1284))) then
						return "templar_strike generators 30";
					end
				end
				if ((v98.Judgment:IsReady() and v43 and ((v108 <= (822 - (599 + 220))) or not v98.BoundlessJudgment:IsAvailable())) or ((4056 - 2019) >= (6573 - (1813 + 118)))) then
					if (((1258 + 462) < (5675 - (841 + 376))) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 32";
					end
				end
				if ((v98.HammerofWrath:IsReady() and v42 and ((v108 <= (3 - 0)) or (v17:HealthPercentage() > (5 + 15)) or not v98.VanguardsMomentum:IsAvailable())) or ((1190 - 754) > (3880 - (464 + 395)))) then
					if (((1829 - 1116) <= (407 + 440)) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((2991 - (467 + 370)) <= (8329 - 4298)) and v98.CrusaderStrike:IsCastable() and v37) then
					if (((3388 + 1227) == (15820 - 11205)) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v135 = 1 + 5;
			end
		end
	end
	local function v121()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (525 - (150 + 370))) or ((5072 - (74 + 1208)) == (1229 - 729))) then
				v55 = EpicSettings.Settings['finalReckoningWithCD'];
				v56 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if (((422 - 333) < (158 + 63)) and ((391 - (14 + 376)) == v136)) then
				v39 = EpicSettings.Settings['useDivineStorm'];
				v40 = EpicSettings.Settings['useDivineToll'];
				v41 = EpicSettings.Settings['useExecutionSentence'];
				v42 = EpicSettings.Settings['useHammerofWrath'];
				v136 = 3 - 1;
			end
			if (((1330 + 724) >= (1249 + 172)) and (v136 == (4 + 0))) then
				v51 = EpicSettings.Settings['useFinalReckoning'];
				v52 = EpicSettings.Settings['useShieldofVengeance'];
				v53 = EpicSettings.Settings['avengingWrathWithCD'];
				v54 = EpicSettings.Settings['crusadeWithCD'];
				v136 = 14 - 9;
			end
			if (((521 + 171) < (3136 - (23 + 55))) and (v136 == (4 - 2))) then
				v43 = EpicSettings.Settings['useJudgment'];
				v44 = EpicSettings.Settings['useJusticarsVengeance'];
				v45 = EpicSettings.Settings['useTemplarSlash'];
				v46 = EpicSettings.Settings['useTemplarStrike'];
				v136 = 3 + 0;
			end
			if ((v136 == (3 + 0)) or ((5044 - 1790) == (521 + 1134))) then
				v47 = EpicSettings.Settings['useWakeofAshes'];
				v48 = EpicSettings.Settings['useVerdict'];
				v49 = EpicSettings.Settings['useAvengingWrath'];
				v50 = EpicSettings.Settings['useCrusade'];
				v136 = 905 - (652 + 249);
			end
			if ((v136 == (0 - 0)) or ((3164 - (708 + 1160)) == (13327 - 8417))) then
				v35 = EpicSettings.Settings['useBladeofJustice'];
				v36 = EpicSettings.Settings['useConsecration'];
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v38 = EpicSettings.Settings['useDivineHammer'];
				v136 = 1 - 0;
			end
		end
	end
	local function v122()
		local v137 = 27 - (10 + 17);
		while true do
			if (((757 + 2611) == (5100 - (1400 + 332))) and (v137 == (0 - 0))) then
				v57 = EpicSettings.Settings['useRebuke'];
				v58 = EpicSettings.Settings['useHammerofJustice'];
				v59 = EpicSettings.Settings['useDivineProtection'];
				v137 = 1909 - (242 + 1666);
			end
			if (((1131 + 1512) < (1399 + 2416)) and (v137 == (3 + 0))) then
				v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v67 = EpicSettings.Settings['divineProtectionHP'] or (940 - (850 + 90));
				v68 = EpicSettings.Settings['divineShieldHP'] or (0 - 0);
				v137 = 1394 - (360 + 1030);
			end
			if (((1693 + 220) > (1390 - 897)) and (v137 == (2 - 0))) then
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useWordofGloryMouseover'];
				v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v137 = 1664 - (909 + 752);
			end
			if (((5978 - (109 + 1114)) > (6275 - 2847)) and (v137 == (2 + 2))) then
				v69 = EpicSettings.Settings['layonHandsHP'] or (242 - (6 + 236));
				v70 = EpicSettings.Settings['layonHandsFocusHP'] or (0 + 0);
				v71 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 + 0);
				v137 = 11 - 6;
			end
			if (((2412 - 1031) <= (3502 - (1076 + 57))) and (v137 == (1 + 0))) then
				v60 = EpicSettings.Settings['useDivineShield'];
				v61 = EpicSettings.Settings['useLayonHands'];
				v62 = EpicSettings.Settings['useLayonHandsFocus'];
				v137 = 691 - (579 + 110);
			end
			if ((v137 == (1 + 4)) or ((4282 + 561) == (2168 + 1916))) then
				v72 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (407 - (174 + 233));
				v73 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 - 0);
				v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 - 0);
				v137 = 3 + 3;
			end
			if (((5843 - (663 + 511)) > (324 + 39)) and (v137 == (2 + 4))) then
				v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v96 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
		end
	end
	local function v123()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (1 + 0)) or ((4419 - 2542) >= (7596 - 4458))) then
				v78 = EpicSettings.Settings['DispelDebuffs'];
				v77 = EpicSettings.Settings['DispelBuffs'];
				v85 = EpicSettings.Settings['useTrinkets'];
				v87 = EpicSettings.Settings['useRacials'];
				v138 = 1 + 1;
			end
			if (((9229 - 4487) >= (2585 + 1041)) and ((1 + 3) == v138)) then
				v80 = EpicSettings.Settings['HandleIncorporeal'];
				v94 = EpicSettings.Settings['HealOOC'];
				v95 = EpicSettings.Settings['HealOOCHP'] or (722 - (478 + 244));
				break;
			end
			if ((v138 == (519 - (440 + 77))) or ((2065 + 2475) == (3352 - 2436))) then
				v86 = EpicSettings.Settings['trinketsWithCD'];
				v88 = EpicSettings.Settings['racialsWithCD'];
				v90 = EpicSettings.Settings['useHealthstone'];
				v89 = EpicSettings.Settings['useHealingPotion'];
				v138 = 1559 - (655 + 901);
			end
			if ((v138 == (1 + 2)) or ((885 + 271) > (2934 + 1411))) then
				v92 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v91 = EpicSettings.Settings['healingPotionHP'] or (1445 - (695 + 750));
				v93 = EpicSettings.Settings['HealingPotionName'] or "";
				v79 = EpicSettings.Settings['handleAfflicted'];
				v138 = 13 - 9;
			end
			if (((3452 - 1215) < (17088 - 12839)) and (v138 == (351 - (285 + 66)))) then
				v84 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v81 = EpicSettings.Settings['InterruptWithStun'];
				v82 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v83 = EpicSettings.Settings['InterruptThreshold'];
				v138 = 1311 - (682 + 628);
			end
		end
	end
	local function v124()
		local v139 = 0 + 0;
		while true do
			if ((v139 == (304 - (176 + 123))) or ((1123 + 1560) < (17 + 6))) then
				if (((966 - (239 + 30)) <= (225 + 601)) and v80) then
					local v201 = 0 + 0;
					while true do
						if (((1955 - 850) <= (3668 - 2492)) and (v201 == (316 - (306 + 9)))) then
							v30 = v97.HandleIncorporeal(v98.TurnEvil, v102.TurnEvilMouseOver, 104 - 74, true);
							if (((588 + 2791) <= (2339 + 1473)) and v30) then
								return v30;
							end
							break;
						end
						if ((v201 == (0 + 0)) or ((2253 - 1465) >= (2991 - (1140 + 235)))) then
							v30 = v97.HandleIncorporeal(v98.Repentance, v102.RepentanceMouseOver, 20 + 10, true);
							if (((1701 + 153) <= (868 + 2511)) and v30) then
								return v30;
							end
							v201 = 53 - (33 + 19);
						end
					end
				end
				v30 = v114();
				if (((1643 + 2906) == (13634 - 9085)) and v30) then
					return v30;
				end
				if ((v78 and v34) or ((1332 + 1690) >= (5930 - 2906))) then
					local v202 = 0 + 0;
					while true do
						if (((5509 - (586 + 103)) > (201 + 1997)) and (v202 == (0 - 0))) then
							if (v14 or ((2549 - (1309 + 179)) >= (8829 - 3938))) then
								local v210 = 0 + 0;
								while true do
									if (((3663 - 2299) <= (3379 + 1094)) and (v210 == (0 - 0))) then
										v30 = v113();
										if (v30 or ((7163 - 3568) <= (612 - (295 + 314)))) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v16 and v16:Exists() and v16:IsAPlayer() and (v97.UnitHasCurseDebuff(v16) or v97.UnitHasPoisonDebuff(v16))) or ((11475 - 6803) == (5814 - (1300 + 662)))) then
								if (((4895 - 3336) == (3314 - (1178 + 577))) and v98.CleanseToxins:IsReady()) then
									if (v25(v102.CleanseToxinsMouseover) or ((910 + 842) <= (2329 - 1541))) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v139 = 1411 - (851 + 554);
			end
			if ((v139 == (6 + 0)) or ((10835 - 6928) == (384 - 207))) then
				v30 = v115();
				if (((3772 - (115 + 187)) > (426 + 129)) and v30) then
					return v30;
				end
				if ((not v15:AffectingCombat() and v31 and v97.TargetIsValid()) or ((921 + 51) == (2541 - 1896))) then
					local v203 = 1161 - (160 + 1001);
					while true do
						if (((2784 + 398) >= (1460 + 655)) and ((0 - 0) == v203)) then
							v30 = v117();
							if (((4251 - (237 + 121)) < (5326 - (525 + 372))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v15:AffectingCombat() and v97.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((5435 - 2568) < (6259 - 4354))) then
					local v204 = 142 - (96 + 46);
					while true do
						if ((v204 == (778 - (643 + 134))) or ((649 + 1147) >= (9713 - 5662))) then
							if (((6010 - 4391) <= (3603 + 153)) and v59 and v98.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v67)) then
								if (((1184 - 580) == (1234 - 630)) and v25(v98.DivineProtection)) then
									return "divine_protection defensive";
								end
							end
							if ((v99.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) or ((5203 - (316 + 403)) == (599 + 301))) then
								if (v25(v102.Healthstone) or ((12259 - 7800) <= (403 + 710))) then
									return "healthstone defensive";
								end
							end
							v204 = 4 - 2;
						end
						if (((2574 + 1058) > (1096 + 2302)) and ((13 - 9) == v204)) then
							if (((19494 - 15412) <= (10214 - 5297)) and v25(v98.Pool)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((277 + 4555) >= (2728 - 1342)) and (v204 == (0 + 0))) then
							if (((403 - 266) == (154 - (12 + 5))) and v61 and (v15:HealthPercentage() <= v69) and v98.LayonHands:IsReady() and v15:DebuffDown(v98.ForbearanceDebuff)) then
								if (v25(v98.LayonHands) or ((6097 - 4527) >= (9242 - 4910))) then
									return "lay_on_hands_player defensive";
								end
							end
							if ((v60 and (v15:HealthPercentage() <= v68) and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) or ((8638 - 4574) <= (4510 - 2691))) then
								if (v25(v98.DivineShield) or ((1012 + 3974) < (3547 - (1656 + 317)))) then
									return "divine_shield defensive";
								end
							end
							v204 = 1 + 0;
						end
						if (((3547 + 879) > (456 - 284)) and (v204 == (9 - 7))) then
							if (((940 - (5 + 349)) > (2161 - 1706)) and v89 and (v15:HealthPercentage() <= v91)) then
								local v211 = 1271 - (266 + 1005);
								while true do
									if (((545 + 281) == (2818 - 1992)) and (v211 == (0 - 0))) then
										if ((v93 == "Refreshing Healing Potion") or ((5715 - (561 + 1135)) > (5787 - 1346))) then
											if (((6629 - 4612) < (5327 - (507 + 559))) and v99.RefreshingHealingPotion:IsReady()) then
												if (((11833 - 7117) > (247 - 167)) and v25(v102.RefreshingHealingPotion)) then
													return "refreshing healing potion defensive";
												end
											end
										end
										if ((v93 == "Dreamwalker's Healing Potion") or ((3895 - (212 + 176)) == (4177 - (250 + 655)))) then
											if (v99.DreamwalkersHealingPotion:IsReady() or ((2388 - 1512) >= (5373 - 2298))) then
												if (((6808 - 2456) > (4510 - (1869 + 87))) and v25(v102.RefreshingHealingPotion)) then
													return "dreamwalkers healing potion defensive";
												end
											end
										end
										break;
									end
								end
							end
							if ((v84 < v106) or ((15281 - 10875) < (5944 - (484 + 1417)))) then
								local v212 = 0 - 0;
								while true do
									if ((v212 == (0 - 0)) or ((2662 - (48 + 725)) >= (5526 - 2143))) then
										v30 = v118();
										if (((5075 - 3183) <= (1589 + 1145)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							v204 = 7 - 4;
						end
						if (((539 + 1384) < (647 + 1571)) and (v204 == (856 - (152 + 701)))) then
							v30 = v120();
							if (((3484 - (430 + 881)) > (146 + 233)) and v30) then
								return v30;
							end
							v204 = 899 - (557 + 338);
						end
					end
				end
				break;
			end
			if ((v139 == (1 + 2)) or ((7301 - 4710) == (11937 - 8528))) then
				if (((11992 - 7478) > (7163 - 3839)) and v34) then
					local v205 = 801 - (499 + 302);
					while true do
						if ((v205 == (866 - (39 + 827))) or ((573 - 365) >= (10782 - 5954))) then
							v30 = v97.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 158 - 118, 37 - 12);
							if (v30 or ((136 + 1447) > (10440 - 6873))) then
								return v30;
							end
							v205 = 1 + 0;
						end
						if ((v205 == (1 - 0)) or ((1417 - (103 + 1)) == (1348 - (475 + 79)))) then
							if (((6861 - 3687) > (9286 - 6384)) and v98.BlessingofFreedom:IsReady() and v97.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
								if (((533 + 3587) <= (3750 + 510)) and v25(v102.BlessingofFreedomFocus)) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				v107 = v111();
				if (not v15:AffectingCombat() or ((2386 - (1395 + 108)) > (13903 - 9125))) then
					if ((v98.RetributionAura:IsCastable() and (v112())) or ((4824 - (7 + 1197)) >= (2133 + 2758))) then
						if (((1486 + 2772) > (1256 - (27 + 292))) and v25(v98.RetributionAura)) then
							return "retribution_aura";
						end
					end
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((14267 - 9398) < (1155 - 249))) then
					if (v15:AffectingCombat() or ((5137 - 3912) > (8337 - 4109))) then
						if (((6337 - 3009) > (2377 - (43 + 96))) and v98.Intercession:IsCastable()) then
							if (((15659 - 11820) > (3176 - 1771)) and v25(v98.Intercession, not v17:IsInRange(25 + 5), true)) then
								return "intercession target";
							end
						end
					elseif (v98.Redemption:IsCastable() or ((366 + 927) <= (1001 - 494))) then
						if (v25(v98.Redemption, not v17:IsInRange(12 + 18), true) or ((5427 - 2531) < (254 + 551))) then
							return "redemption target";
						end
					end
				end
				v139 = 1 + 3;
			end
			if (((4067 - (1414 + 337)) == (4256 - (1642 + 298))) and (v139 == (0 - 0))) then
				v122();
				v121();
				v123();
				v31 = EpicSettings.Toggles['ooc'];
				v139 = 2 - 1;
			end
			if ((v139 == (2 - 1)) or ((846 + 1724) == (1193 + 340))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((1855 - (357 + 615)) == (1025 + 435))) then
					return v30;
				end
				v139 = 4 - 2;
			end
			if ((v139 == (4 + 0)) or ((9898 - 5279) <= (799 + 200))) then
				if ((v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((232 + 3178) > (2588 + 1528))) then
					if (v25(v102.RedemptionMouseover) or ((2204 - (384 + 917)) >= (3756 - (128 + 569)))) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((5519 - (1407 + 136)) < (4744 - (687 + 1200)))) then
					if (((6640 - (556 + 1154)) > (8116 - 5809)) and v98.Intercession:IsCastable() and (v15:HolyPower() >= (98 - (9 + 86))) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if (v25(v102.IntercessionMouseover) or ((4467 - (275 + 146)) < (210 + 1081))) then
							return "Intercession mouseover";
						end
					end
				end
				if (v97.TargetIsValid() or v15:AffectingCombat() or ((4305 - (29 + 35)) == (15711 - 12166))) then
					local v206 = 0 - 0;
					while true do
						if (((8 - 6) == v206) or ((2637 + 1411) > (5244 - (53 + 959)))) then
							v108 = v15:HolyPower();
							break;
						end
						if (((408 - (312 + 96)) == v206) or ((3037 - 1287) >= (3758 - (147 + 138)))) then
							v105 = v10.BossFightRemains(nil, true);
							v106 = v105;
							v206 = 900 - (813 + 86);
						end
						if (((2862 + 304) == (5865 - 2699)) and (v206 == (493 - (18 + 474)))) then
							if (((595 + 1168) < (12154 - 8430)) and (v106 == (12197 - (860 + 226)))) then
								v106 = v10.FightRemains(v103, false);
							end
							v109 = v15:GCD();
							v206 = 305 - (121 + 182);
						end
					end
				end
				if (((8 + 49) <= (3963 - (988 + 252))) and v79) then
					local v207 = 0 + 0;
					while true do
						if ((v207 == (0 + 0)) or ((4040 - (49 + 1921)) == (1333 - (223 + 667)))) then
							if (v75 or ((2757 - (51 + 1)) == (2397 - 1004))) then
								v30 = v97.HandleAfflicted(v98.CleanseToxins, v102.CleanseToxinsMouseover, 85 - 45);
								if (v30 or ((5726 - (146 + 979)) < (18 + 43))) then
									return v30;
								end
							end
							if ((v76 and (v108 > (607 - (311 + 294)))) or ((3876 - 2486) >= (2010 + 2734))) then
								local v213 = 1443 - (496 + 947);
								while true do
									if ((v213 == (1358 - (1233 + 125))) or ((813 + 1190) > (3440 + 394))) then
										v30 = v97.HandleAfflicted(v98.WordofGlory, v102.WordofGloryMouseover, 8 + 32, true);
										if (v30 or ((1801 - (963 + 682)) > (3266 + 647))) then
											return v30;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v139 = 1509 - (504 + 1000);
			end
			if (((132 + 63) == (178 + 17)) and (v139 == (1 + 1))) then
				v103 = v15:GetEnemiesInMeleeRange(11 - 3);
				if (((2653 + 452) >= (1045 + 751)) and v32) then
					v104 = #v103;
				else
					v103 = {};
					v104 = 183 - (156 + 26);
				end
				if (((2523 + 1856) >= (3333 - 1202)) and not v15:AffectingCombat() and v15:IsMounted()) then
					if (((4008 - (149 + 15)) >= (3003 - (890 + 70))) and v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) then
						if (v25(v98.CrusaderAura) or ((3349 - (39 + 78)) <= (3213 - (14 + 468)))) then
							return "crusader_aura";
						end
					end
				end
				if (((10786 - 5881) == (13709 - 8804)) and (v15:AffectingCombat() or (v78 and v98.CleanseToxins:IsAvailable()))) then
					local v208 = 0 + 0;
					local v209;
					while true do
						if (((0 + 0) == v208) or ((879 + 3257) >= (1993 + 2418))) then
							v209 = v78 and v98.CleanseToxins:IsReady() and v34;
							v30 = v97.FocusUnit(v209, v102, 6 + 14, nil, 47 - 22);
							v208 = 1 + 0;
						end
						if ((v208 == (3 - 2)) or ((75 + 2883) == (4068 - (12 + 39)))) then
							if (((1143 + 85) >= (2516 - 1703)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				v139 = 10 - 7;
			end
		end
	end
	local function v125()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (0 + 0)) or ((8761 - 5306) > (2698 + 1352))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v101();
				break;
			end
		end
	end
	v21.SetAPL(338 - 268, v124, v125);
end;
return v0["Epix_Paladin_Retribution.lua"]();

