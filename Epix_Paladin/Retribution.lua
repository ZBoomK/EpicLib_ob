local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (87 - (36 + 51))) or ((15864 - 12185) < (1472 - 847))) then
			v6 = v0[v4];
			if (not v6 or ((2450 + 2175) < (129 + 503))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if ((v5 == (1 + 0)) or ((28 + 55) > (1113 + 667))) then
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
		if (((1642 - (709 + 387)) <= (2935 - (673 + 1185))) and v98.CleanseToxins:IsAvailable()) then
			v97.DispellableDebuffs = v13.MergeTable(v97.DispellableDiseaseDebuffs, v97.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v101();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v102 = v24.Paladin.Retribution;
	local v103;
	local v104;
	local v105 = 32223 - 21112;
	local v106 = 35679 - 24568;
	local v107;
	local v108 = 0 - 0;
	local v109 = 0 + 0;
	local v110;
	v10:RegisterForEvent(function()
		local v127 = 0 + 0;
		while true do
			if ((v127 == (0 - 0)) or ((245 + 751) > (8575 - 4274))) then
				v105 = 21810 - 10699;
				v106 = 12991 - (446 + 1434);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v111()
		local v128 = v15:GCDRemains();
		local v129 = v28(v98.CrusaderStrike:CooldownRemains(), v98.BladeofJustice:CooldownRemains(), v98.Judgment:CooldownRemains(), (v98.HammerofWrath:IsUsable() and v98.HammerofWrath:CooldownRemains()) or (1293 - (1040 + 243)), v98.WakeofAshes:CooldownRemains());
		if (((12147 - 8077) > (2534 - (559 + 1288))) and (v128 > v129)) then
			return v128;
		end
		return v129;
	end
	local function v112()
		return v15:BuffDown(v98.RetributionAura) and v15:BuffDown(v98.DevotionAura) and v15:BuffDown(v98.ConcentrationAura) and v15:BuffDown(v98.CrusaderAura);
	end
	local v113 = 1931 - (609 + 1322);
	local function v114()
		if ((v98.CleanseToxins:IsReady() and v97.DispellableFriendlyUnit(479 - (13 + 441))) or ((2451 - 1795) >= (8722 - 5392))) then
			local v154 = 0 - 0;
			while true do
				if ((v154 == (0 + 0)) or ((9050 - 6558) <= (119 + 216))) then
					if (((1894 + 2428) >= (7602 - 5040)) and (v113 == (0 + 0))) then
						v113 = GetTime();
					end
					if (v97.Wait(919 - 419, v113) or ((2405 + 1232) >= (2097 + 1673))) then
						local v205 = 0 + 0;
						while true do
							if ((v205 == (0 + 0)) or ((2328 + 51) > (5011 - (153 + 280)))) then
								if (v25(v102.CleanseToxinsFocus) or ((1394 - 911) > (668 + 75))) then
									return "cleanse_toxins dispel";
								end
								v113 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v115()
		if (((1285 + 1169) > (525 + 53)) and v94 and (v15:HealthPercentage() <= v95)) then
			if (((674 + 256) < (6788 - 2330)) and v98.FlashofLight:IsReady()) then
				if (((410 + 252) <= (1639 - (89 + 578))) and v25(v98.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v116()
		if (((3122 + 1248) == (9085 - 4715)) and v16:Exists()) then
			if ((v98.WordofGlory:IsReady() and v64 and (v16:HealthPercentage() <= v72)) or ((5811 - (572 + 477)) <= (117 + 744))) then
				if (v25(v102.WordofGloryMouseover) or ((848 + 564) == (509 + 3755))) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v14 or not v14:Exists() or not v14:IsInRange(116 - (84 + 2)) or ((5220 - 2052) < (1552 + 601))) then
			return;
		end
		if (v14 or ((5818 - (497 + 345)) < (35 + 1297))) then
			local v155 = 0 + 0;
			while true do
				if (((5961 - (605 + 728)) == (3302 + 1326)) and (v155 == (1 - 0))) then
					if ((v98.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) or ((3 + 51) == (1460 - 1065))) then
						if (((74 + 8) == (226 - 144)) and v25(v102.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v98.BlessingofProtection:IsCastable() and v65 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) or ((439 + 142) < (771 - (457 + 32)))) then
						if (v25(v102.BlessingofProtectionFocus) or ((1956 + 2653) < (3897 - (832 + 570)))) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
				if (((1086 + 66) == (301 + 851)) and (v155 == (0 - 0))) then
					if (((914 + 982) <= (4218 - (588 + 208))) and v98.WordofGlory:IsReady() and v63 and (v14:HealthPercentage() <= v71)) then
						if (v25(v102.WordofGloryFocus) or ((2668 - 1678) > (3420 - (884 + 916)))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v98.LayonHands:IsCastable() and v62 and v14:DebuffDown(v98.ForbearanceDebuff) and (v14:HealthPercentage() <= v70)) or ((1835 - 958) > (2723 + 1972))) then
						if (((3344 - (232 + 421)) >= (3740 - (1569 + 320))) and v25(v102.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					v155 = 1 + 0;
				end
			end
		end
	end
	local function v117()
		v30 = v97.HandleTopTrinket(v100, v33, 8 + 32, nil);
		if (v30 or ((10058 - 7073) >= (5461 - (316 + 289)))) then
			return v30;
		end
		v30 = v97.HandleBottomTrinket(v100, v33, 104 - 64, nil);
		if (((198 + 4078) >= (2648 - (666 + 787))) and v30) then
			return v30;
		end
	end
	local function v118()
		local v130 = 425 - (360 + 65);
		while true do
			if (((3021 + 211) <= (4944 - (79 + 175))) and ((2 - 0) == v130)) then
				if ((v98.TemplarsVerdict:IsReady() and v48 and (v108 >= (4 + 0))) or ((2746 - 1850) >= (6058 - 2912))) then
					if (((3960 - (503 + 396)) >= (3139 - (92 + 89))) and v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict))) then
						return "templars verdict precombat 4";
					end
				end
				if (((6182 - 2995) >= (331 + 313)) and v98.BladeofJustice:IsCastable() and v35) then
					if (((382 + 262) <= (2756 - 2052)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				v130 = 1 + 2;
			end
			if (((2183 - 1225) > (827 + 120)) and (v130 == (0 + 0))) then
				if (((13680 - 9188) >= (332 + 2322)) and v98.ArcaneTorrent:IsCastable() and v87 and ((v88 and v33) or not v88) and v98.FinalReckoning:IsAvailable()) then
					if (((5248 - 1806) >= (2747 - (485 + 759))) and v25(v98.ArcaneTorrent, not v17:IsInRange(18 - 10))) then
						return "arcane_torrent precombat 0";
					end
				end
				if ((v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56)) or ((4359 - (442 + 747)) <= (2599 - (832 + 303)))) then
					if (v25(v98.ShieldofVengeance, not v17:IsInRange(954 - (88 + 858))) or ((1463 + 3334) == (3632 + 756))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v130 = 1 + 0;
			end
			if (((1340 - (766 + 23)) <= (3361 - 2680)) and (v130 == (1 - 0))) then
				if (((8633 - 5356) > (1381 - 974)) and v98.JusticarsVengeance:IsAvailable() and v98.JusticarsVengeance:IsReady() and v44 and (v108 >= (1077 - (1036 + 37)))) then
					if (((3329 + 1366) >= (2755 - 1340)) and v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if ((v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsReady() and v48 and (v108 >= (4 + 0))) or ((4692 - (641 + 839)) <= (1857 - (910 + 3)))) then
					if (v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict)) or ((7892 - 4796) <= (3482 - (1466 + 218)))) then
						return "final verdict precombat 3";
					end
				end
				v130 = 1 + 1;
			end
			if (((4685 - (556 + 592)) == (1258 + 2279)) and (v130 == (811 - (329 + 479)))) then
				if (((4691 - (174 + 680)) >= (5394 - 3824)) and v98.Judgment:IsCastable() and v43) then
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((6114 - 3164) == (2722 + 1090))) then
						return "judgment precombat 6";
					end
				end
				if (((5462 - (396 + 343)) >= (206 + 2112)) and v98.HammerofWrath:IsReady() and v42) then
					if (v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath)) or ((3504 - (29 + 1448)) > (4241 - (135 + 1254)))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v130 = 14 - 10;
			end
			if (((18 - 14) == v130) or ((758 + 378) > (5844 - (389 + 1138)))) then
				if (((5322 - (102 + 472)) == (4481 + 267)) and v98.CrusaderStrike:IsCastable() and v37) then
					if (((2072 + 1664) <= (4420 + 320)) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v131 = 1545 - (320 + 1225);
		local v132;
		while true do
			if ((v131 == (1 - 0)) or ((2075 + 1315) <= (4524 - (157 + 1307)))) then
				if ((v98.LightsJudgment:IsCastable() and v87 and ((v88 and v33) or not v88)) or ((2858 - (821 + 1038)) > (6718 - 4025))) then
					if (((51 + 412) < (1067 - 466)) and v25(v98.LightsJudgment, not v17:IsInRange(15 + 25))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v98.Fireblood:IsCastable() and v87 and ((v88 and v33) or not v88) and (v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) == (24 - 14))))) or ((3209 - (834 + 192)) < (44 + 643))) then
					if (((1168 + 3381) == (98 + 4451)) and v25(v98.Fireblood, not v17:IsInRange(15 - 5))) then
						return "fireblood cooldowns 6";
					end
				end
				v131 = 306 - (300 + 4);
			end
			if (((1248 + 3424) == (12229 - 7557)) and (v131 == (364 - (112 + 250)))) then
				if ((v85 and ((v33 and v86) or not v86) and v17:IsInRange(4 + 4)) or ((9188 - 5520) < (227 + 168))) then
					local v194 = 0 + 0;
					while true do
						if ((v194 == (0 + 0)) or ((2066 + 2100) == (339 + 116))) then
							v30 = v117();
							if (v30 or ((5863 - (1001 + 413)) == (5938 - 3275))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v98.ShieldofVengeance:IsCastable() and v52 and ((v33 and v56) or not v56) and (v106 > (897 - (244 + 638))) and (not v98.ExecutionSentence:IsAvailable() or v17:DebuffDown(v98.ExecutionSentence))) or ((4970 - (627 + 66)) < (8905 - 5916))) then
					if (v25(v98.ShieldofVengeance) or ((1472 - (512 + 90)) >= (6055 - (1665 + 241)))) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v131 = 720 - (373 + 344);
			end
			if (((998 + 1214) < (843 + 2340)) and (v131 == (10 - 6))) then
				if (((7861 - 3215) > (4091 - (35 + 1064))) and v98.Crusade:IsCastable() and v50 and ((v33 and v54) or not v54) and (v15:BuffRemains(v98.CrusadeBuff) < v15:GCD()) and (((v108 >= (4 + 1)) and (v10.CombatTime() < (10 - 5))) or ((v108 >= (1 + 2)) and (v10.CombatTime() > (1241 - (298 + 938)))))) then
					if (((2693 - (233 + 1026)) < (4772 - (636 + 1030))) and v25(v98.Crusade, not v17:IsInRange(6 + 4))) then
						return "crusade cooldowns 14";
					end
				end
				if (((768 + 18) < (899 + 2124)) and v98.FinalReckoning:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v108 >= (1 + 3)) and (v10.CombatTime() < (229 - (55 + 166)))) or ((v108 >= (1 + 2)) and (v10.CombatTime() >= (1 + 7))) or ((v108 >= (7 - 5)) and v98.DivineAuxiliary:IsAvailable())) and ((v98.AvengingWrath:CooldownRemains() > (307 - (36 + 261))) or (v98.Crusade:CooldownDown() and (v15:BuffDown(v98.CrusadeBuff) or (v15:BuffStack(v98.CrusadeBuff) >= (17 - 7))))) and ((v107 > (1368 - (34 + 1334))) or (v108 == (2 + 3)) or ((v108 >= (2 + 0)) and v98.DivineAuxiliary:IsAvailable()))) then
					local v195 = 1283 - (1035 + 248);
					while true do
						if ((v195 == (21 - (20 + 1))) or ((1273 + 1169) < (393 - (134 + 185)))) then
							if (((5668 - (549 + 584)) == (5220 - (314 + 371))) and (v96 == "player")) then
								if (v25(v102.FinalReckoningPlayer, not v17:IsInRange(34 - 24)) or ((3977 - (478 + 490)) <= (1116 + 989))) then
									return "final_reckoning cooldowns 18";
								end
							end
							if (((3002 - (786 + 386)) < (11883 - 8214)) and (v96 == "cursor")) then
								if (v25(v102.FinalReckoningCursor, not v17:IsInRange(1399 - (1055 + 324))) or ((2770 - (1093 + 247)) >= (3210 + 402))) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((283 + 2400) >= (9766 - 7306)) and (v131 == (9 - 6))) then
				if ((v98.ExecutionSentence:IsCastable() and v41 and ((v15:BuffDown(v98.CrusadeBuff) and (v98.Crusade:CooldownRemains() > (42 - 27))) or (v15:BuffStack(v98.CrusadeBuff) == (25 - 15)) or (v98.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v98.AvengingWrath:CooldownRemains() > (57 - 42))) and (((v108 >= (13 - 9)) and (v10.CombatTime() < (4 + 1))) or ((v108 >= (7 - 4)) and (v10.CombatTime() > (693 - (364 + 324)))) or ((v108 >= (5 - 3)) and v98.DivineAuxiliary:IsAvailable())) and (((v106 > (19 - 11)) and not v98.ExecutionersWill:IsAvailable()) or (v106 > (4 + 8)))) or ((7548 - 5744) >= (5245 - 1970))) then
					if (v25(v98.ExecutionSentence, not v17:IsSpellInRange(v98.ExecutionSentence)) or ((4303 - 2886) > (4897 - (1249 + 19)))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((4329 + 466) > (1564 - 1162)) and v98.AvengingWrath:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v108 >= (1090 - (686 + 400))) and (v10.CombatTime() < (4 + 1))) or ((v108 >= (232 - (73 + 156))) and (v10.CombatTime() > (1 + 4))) or ((v108 >= (813 - (721 + 90))) and v98.DivineAuxiliary:IsAvailable() and ((v98.ExecutionSentence:IsAvailable() and ((v98.ExecutionSentence:CooldownRemains() == (0 + 0)) or (v98.ExecutionSentence:CooldownRemains() > (48 - 33)) or not v98.ExecutionSentence:IsReady())) or (v98.FinalReckoning:IsAvailable() and ((v98.FinalReckoning:CooldownRemains() == (470 - (224 + 246))) or (v98.FinalReckoning:CooldownRemains() > (48 - 18)) or not v98.FinalReckoning:IsReady())))))) then
					if (((8861 - 4048) > (647 + 2918)) and v25(v98.AvengingWrath, not v17:IsInRange(1 + 9))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v131 = 3 + 1;
			end
			if (((7777 - 3865) == (13018 - 9106)) and ((513 - (203 + 310)) == v131)) then
				v132 = v97.HandleDPSPotion(v15:BuffUp(v98.AvengingWrathBuff) or (v15:BuffUp(v98.CrusadeBuff) and (v15.BuffStack(v98.Crusade) == (2003 - (1238 + 755)))) or (v106 < (2 + 23)));
				if (((4355 - (709 + 825)) <= (8889 - 4065)) and v132) then
					return v132;
				end
				v131 = 1 - 0;
			end
		end
	end
	local function v120()
		v110 = ((v104 >= (867 - (196 + 668))) or ((v104 >= (7 - 5)) and not v98.DivineArbiter:IsAvailable()) or v15:BuffUp(v98.EmpyreanPowerBuff)) and v15:BuffDown(v98.EmpyreanLegacyBuff) and not (v15:BuffUp(v98.DivineArbiterBuff) and (v15:BuffStack(v98.DivineArbiterBuff) > (49 - 25)));
		if (((2571 - (171 + 662)) <= (2288 - (4 + 89))) and v98.DivineStorm:IsReady() and v39 and v110 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (10 - 7))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (4 + 6))))) then
			if (((180 - 139) <= (1184 + 1834)) and v25(v98.DivineStorm, not v17:IsInRange(1496 - (35 + 1451)))) then
				return "divine_storm finishers 2";
			end
		end
		if (((3598 - (28 + 1425)) <= (6097 - (941 + 1052))) and v98.JusticarsVengeance:IsReady() and v44 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (3 + 0))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (1524 - (822 + 692)))))) then
			if (((3838 - 1149) < (2283 + 2562)) and v25(v98.JusticarsVengeance, not v17:IsSpellInRange(v98.JusticarsVengeance))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if ((v98.FinalVerdict:IsAvailable() and v98.FinalVerdict:IsCastable() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (300 - (45 + 252)))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (10 + 0))))) or ((800 + 1522) > (6380 - 3758))) then
			if (v25(v98.FinalVerdict, not v17:IsSpellInRange(v98.FinalVerdict)) or ((4967 - (114 + 319)) == (2988 - 906))) then
				return "final verdict finishers 6";
			end
		end
		if ((v98.TemplarsVerdict:IsReady() and v48 and (not v98.Crusade:IsAvailable() or (v98.Crusade:CooldownRemains() > (v109 * (3 - 0))) or (v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (7 + 3))))) or ((2340 - 769) > (3911 - 2044))) then
			if (v25(v98.TemplarsVerdict, not v17:IsSpellInRange(v98.TemplarsVerdict)) or ((4617 - (556 + 1407)) >= (4202 - (741 + 465)))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v121()
		local v133 = 465 - (170 + 295);
		while true do
			if (((2096 + 1882) > (1933 + 171)) and (v133 == (9 - 5))) then
				if (((2483 + 512) > (989 + 552)) and v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (2 + 1)) or not v98.HolyBlade:IsAvailable())) then
					if (((4479 - (957 + 273)) > (255 + 698)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				if ((v17:HealthPercentage() <= (9 + 11)) or v15:BuffUp(v98.AvengingWrathBuff) or v15:BuffUp(v98.CrusadeBuff) or v15:BuffUp(v98.EmpyreanPowerBuff) or ((12471 - 9198) > (12050 - 7477))) then
					local v196 = 0 - 0;
					while true do
						if ((v196 == (0 - 0)) or ((4931 - (389 + 1391)) < (806 + 478))) then
							v30 = v120();
							if (v30 or ((193 + 1657) == (3480 - 1951))) then
								return v30;
							end
							break;
						end
					end
				end
				if (((1772 - (783 + 168)) < (7124 - 5001)) and v98.Consecration:IsCastable() and v36 and v17:DebuffDown(v98.ConsecrationDebuff) and (v104 >= (2 + 0))) then
					if (((1213 - (309 + 2)) < (7139 - 4814)) and v25(v98.Consecration, not v17:IsInRange(1222 - (1090 + 122)))) then
						return "consecration generators 22";
					end
				end
				v133 = 2 + 3;
			end
			if (((2881 - 2023) <= (2028 + 934)) and (v133 == (1119 - (628 + 490)))) then
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (1 + 2)) and v15:HasTier(76 - 45, 9 - 7)) or ((4720 - (431 + 343)) < (2601 - 1313))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((9378 - 6136) == (448 + 119))) then
						return "blade_of_justice generators 4";
					end
				end
				if ((v98.DivineToll:IsCastable() and v40 and (v108 <= (1 + 1)) and ((v98.AvengingWrath:CooldownRemains() > (1710 - (556 + 1139))) or (v98.Crusade:CooldownRemains() > (30 - (6 + 9))) or (v106 < (2 + 6)))) or ((434 + 413) >= (1432 - (28 + 141)))) then
					if (v25(v98.DivineToll, not v17:IsInRange(12 + 18)) or ((2780 - 527) == (1311 + 540))) then
						return "divine_toll generators 6";
					end
				end
				if ((v98.Judgment:IsReady() and v43 and v17:DebuffUp(v98.ExpurgationDebuff) and v15:BuffDown(v98.EchoesofWrathBuff) and v15:HasTier(1348 - (486 + 831), 5 - 3)) or ((7347 - 5260) > (449 + 1923))) then
					if (v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment)) or ((14054 - 9609) < (5412 - (668 + 595)))) then
						return "judgment generators 7";
					end
				end
				v133 = 2 + 0;
			end
			if ((v133 == (2 + 4)) or ((4957 - 3139) == (375 - (23 + 267)))) then
				if (((2574 - (1129 + 815)) < (2514 - (371 + 16))) and v30) then
					return v30;
				end
				if ((v98.TemplarSlash:IsReady() and v45) or ((3688 - (1326 + 424)) == (4761 - 2247))) then
					if (((15548 - 11293) >= (173 - (88 + 30))) and v25(v98.TemplarSlash, not v17:IsInRange(781 - (720 + 51)))) then
						return "templar_slash generators 28";
					end
				end
				if (((6670 - 3671) > (2932 - (421 + 1355))) and v98.TemplarStrike:IsReady() and v46) then
					if (((3876 - 1526) > (568 + 587)) and v25(v98.TemplarStrike, not v17:IsInRange(1093 - (286 + 797)))) then
						return "templar_strike generators 30";
					end
				end
				v133 = 25 - 18;
			end
			if (((6672 - 2643) <= (5292 - (397 + 42))) and (v133 == (0 + 0))) then
				if ((v108 >= (805 - (24 + 776))) or (v15:BuffUp(v98.EchoesofWrathBuff) and v15:HasTier(47 - 16, 789 - (222 + 563)) and v98.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v98.JudgmentDebuff) or (v108 == (8 - 4))) and v15:BuffUp(v98.DivineResonanceBuff) and not v15:HasTier(23 + 8, 192 - (23 + 167))) or ((2314 - (690 + 1108)) > (1239 + 2195))) then
					local v197 = 0 + 0;
					while true do
						if (((4894 - (40 + 808)) >= (500 + 2533)) and (v197 == (0 - 0))) then
							v30 = v120();
							if (v30 or ((2599 + 120) <= (766 + 681))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and not v17:DebuffUp(v98.ExpurgationDebuff) and (v108 <= (2 + 1)) and v15:HasTier(602 - (47 + 524), 2 + 0)) or ((11300 - 7166) < (5870 - 1944))) then
					if (v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice)) or ((373 - 209) >= (4511 - (1165 + 561)))) then
						return "blade_of_justice generators 1";
					end
				end
				if ((v98.WakeofAshes:IsCastable() and v47 and (v108 <= (1 + 1)) and ((v98.AvengingWrath:CooldownRemains() > (0 - 0)) or (v98.Crusade:CooldownRemains() > (0 + 0)) or not v98.Crusade:IsAvailable() or not v98.AvengingWrath:IsReady()) and (not v98.ExecutionSentence:IsAvailable() or (v98.ExecutionSentence:CooldownRemains() > (483 - (341 + 138))) or (v106 < (3 + 5)) or not v98.ExecutionSentence:IsReady())) or ((1083 - 558) == (2435 - (89 + 237)))) then
					if (((105 - 72) == (69 - 36)) and v25(v98.WakeofAshes, not v17:IsInRange(891 - (581 + 300)))) then
						return "wake_of_ashes generators 2";
					end
				end
				v133 = 1221 - (855 + 365);
			end
			if (((7253 - 4199) <= (1311 + 2704)) and (v133 == (1238 - (1030 + 205)))) then
				if (((1757 + 114) < (3147 + 235)) and v98.HammerofWrath:IsReady() and v42 and ((v104 < (288 - (156 + 130))) or not v98.BlessedChampion:IsAvailable() or v15:HasTier(68 - 38, 6 - 2)) and ((v108 <= (5 - 2)) or (v17:HealthPercentage() > (6 + 14)) or not v98.VanguardsMomentum:IsAvailable())) then
					if (((754 + 539) <= (2235 - (10 + 59))) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if ((v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (2 + 2))) or ((12700 - 10121) < (1286 - (671 + 492)))) then
					if (v25(v98.TemplarSlash, not v17:IsSpellInRange(v98.TemplarSlash)) or ((674 + 172) >= (3583 - (369 + 846)))) then
						return "templar_slash generators 14";
					end
				end
				if ((v98.Judgment:IsReady() and v43 and v17:DebuffDown(v98.JudgmentDebuff) and ((v108 <= (1 + 2)) or not v98.BoundlessJudgment:IsAvailable())) or ((3424 + 588) <= (5303 - (1036 + 909)))) then
					if (((1188 + 306) <= (5045 - 2040)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 16";
					end
				end
				v133 = 207 - (11 + 192);
			end
			if ((v133 == (3 + 2)) or ((3286 - (135 + 40)) == (5170 - 3036))) then
				if (((1420 + 935) == (5187 - 2832)) and v98.DivineHammer:IsCastable() and v38 and (v104 >= (2 - 0))) then
					if (v25(v98.DivineHammer, not v17:IsInRange(186 - (50 + 126))) or ((1637 - 1049) <= (96 + 336))) then
						return "divine_hammer generators 24";
					end
				end
				if (((6210 - (1233 + 180)) >= (4864 - (522 + 447))) and v98.CrusaderStrike:IsCastable() and v37 and (v98.CrusaderStrike:ChargesFractional() >= (1422.75 - (107 + 1314))) and ((v108 <= (1 + 1)) or ((v108 <= (8 - 5)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (1 + 1)))) or ((v108 == (7 - 3)) and (v98.BladeofJustice:CooldownRemains() > (v109 * (7 - 5))) and (v98.Judgment:CooldownRemains() > (v109 * (1912 - (716 + 1194))))))) then
					if (((62 + 3515) == (384 + 3193)) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v120();
				v133 = 509 - (74 + 429);
			end
			if (((7318 - 3524) > (1831 + 1862)) and (v133 == (18 - 10))) then
				if ((v98.ArcaneTorrent:IsCastable() and ((v88 and v33) or not v88) and v87 and (v108 < (4 + 1)) and (v84 < v106)) or ((3930 - 2655) == (10137 - 6037))) then
					if (v25(v98.ArcaneTorrent, not v17:IsInRange(443 - (279 + 154))) or ((2369 - (454 + 324)) >= (2817 + 763))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((1000 - (12 + 5)) <= (975 + 833)) and v98.Consecration:IsCastable() and v36) then
					if (v25(v98.Consecration, not v17:IsInRange(25 - 15)) or ((795 + 1355) <= (2290 - (277 + 816)))) then
						return "consecration generators 30";
					end
				end
				if (((16105 - 12336) >= (2356 - (1058 + 125))) and v98.DivineHammer:IsCastable() and v38) then
					if (((279 + 1206) == (2460 - (815 + 160))) and v25(v98.DivineHammer, not v17:IsInRange(42 - 32))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if ((v133 == (4 - 2)) or ((791 + 2524) <= (8132 - 5350))) then
				if (((v108 >= (1901 - (41 + 1857))) and v15:BuffUp(v98.CrusadeBuff) and (v15:BuffStack(v98.CrusadeBuff) < (1903 - (1222 + 671)))) or ((2263 - 1387) >= (4260 - 1296))) then
					v30 = v120();
					if (v30 or ((3414 - (229 + 953)) > (4271 - (1111 + 663)))) then
						return v30;
					end
				end
				if ((v98.TemplarSlash:IsReady() and v45 and ((v98.TemplarStrike:TimeSinceLastCast() + v109) < (1583 - (874 + 705))) and (v104 >= (1 + 1))) or ((1440 + 670) <= (689 - 357))) then
					if (((104 + 3582) > (3851 - (642 + 37))) and v25(v98.TemplarSlash, not v17:IsInRange(3 + 7))) then
						return "templar_slash generators 8";
					end
				end
				if ((v98.BladeofJustice:IsCastable() and v35 and ((v108 <= (1 + 2)) or not v98.HolyBlade:IsAvailable()) and (((v104 >= (4 - 2)) and not v98.CrusadingStrikes:IsAvailable()) or (v104 >= (458 - (233 + 221))))) or ((10345 - 5871) < (722 + 98))) then
					if (((5820 - (718 + 823)) >= (1814 + 1068)) and v25(v98.BladeofJustice, not v17:IsSpellInRange(v98.BladeofJustice))) then
						return "blade_of_justice generators 10";
					end
				end
				v133 = 808 - (266 + 539);
			end
			if ((v133 == (19 - 12)) or ((3254 - (636 + 589)) >= (8357 - 4836))) then
				if ((v98.Judgment:IsReady() and v43 and ((v108 <= (5 - 2)) or not v98.BoundlessJudgment:IsAvailable())) or ((1615 + 422) >= (1687 + 2955))) then
					if (((2735 - (657 + 358)) < (11803 - 7345)) and v25(v98.Judgment, not v17:IsSpellInRange(v98.Judgment))) then
						return "judgment generators 32";
					end
				end
				if ((v98.HammerofWrath:IsReady() and v42 and ((v108 <= (6 - 3)) or (v17:HealthPercentage() > (1207 - (1151 + 36))) or not v98.VanguardsMomentum:IsAvailable())) or ((422 + 14) > (795 + 2226))) then
					if (((2129 - 1416) <= (2679 - (1552 + 280))) and v25(v98.HammerofWrath, not v17:IsSpellInRange(v98.HammerofWrath))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((2988 - (64 + 770)) <= (2737 + 1294)) and v98.CrusaderStrike:IsCastable() and v37) then
					if (((10476 - 5861) == (820 + 3795)) and v25(v98.CrusaderStrike, not v17:IsSpellInRange(v98.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v133 = 1251 - (157 + 1086);
			end
		end
	end
	local function v122()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (21 - 16)) or ((5813 - 2023) == (682 - 182))) then
				v55 = EpicSettings.Settings['finalReckoningWithCD'];
				v56 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if (((908 - (599 + 220)) < (439 - 218)) and (v134 == (1931 - (1813 + 118)))) then
				v35 = EpicSettings.Settings['useBladeofJustice'];
				v36 = EpicSettings.Settings['useConsecration'];
				v37 = EpicSettings.Settings['useCrusaderStrike'];
				v38 = EpicSettings.Settings['useDivineHammer'];
				v134 = 1 + 0;
			end
			if (((3271 - (841 + 376)) >= (1990 - 569)) and (v134 == (1 + 2))) then
				v47 = EpicSettings.Settings['useWakeofAshes'];
				v48 = EpicSettings.Settings['useVerdict'];
				v49 = EpicSettings.Settings['useAvengingWrath'];
				v50 = EpicSettings.Settings['useCrusade'];
				v134 = 10 - 6;
			end
			if (((1551 - (464 + 395)) < (7847 - 4789)) and (v134 == (1 + 1))) then
				v43 = EpicSettings.Settings['useJudgment'];
				v44 = EpicSettings.Settings['useJusticarsVengeance'];
				v45 = EpicSettings.Settings['useTemplarSlash'];
				v46 = EpicSettings.Settings['useTemplarStrike'];
				v134 = 840 - (467 + 370);
			end
			if ((v134 == (8 - 4)) or ((2389 + 865) == (5673 - 4018))) then
				v51 = EpicSettings.Settings['useFinalReckoning'];
				v52 = EpicSettings.Settings['useShieldofVengeance'];
				v53 = EpicSettings.Settings['avengingWrathWithCD'];
				v54 = EpicSettings.Settings['crusadeWithCD'];
				v134 = 1 + 4;
			end
			if ((v134 == (2 - 1)) or ((1816 - (150 + 370)) == (6192 - (74 + 1208)))) then
				v39 = EpicSettings.Settings['useDivineStorm'];
				v40 = EpicSettings.Settings['useDivineToll'];
				v41 = EpicSettings.Settings['useExecutionSentence'];
				v42 = EpicSettings.Settings['useHammerofWrath'];
				v134 = 4 - 2;
			end
		end
	end
	local function v123()
		local v135 = 0 - 0;
		while true do
			if (((2397 + 971) == (3758 - (14 + 376))) and (v135 == (6 - 2))) then
				v73 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 + 0);
				v74 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 + 0);
				v75 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v76 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v135 = 5 + 0;
			end
			if (((7744 - 5101) < (2870 + 945)) and (v135 == (81 - (23 + 55)))) then
				v69 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
				v70 = EpicSettings.Settings['layonHandsFocusHP'] or (0 + 0);
				v71 = EpicSettings.Settings['wordofGloryFocusHP'] or (0 + 0);
				v72 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
				v135 = 2 + 2;
			end
			if (((2814 - (652 + 249)) > (1319 - 826)) and ((1868 - (708 + 1160)) == v135)) then
				v57 = EpicSettings.Settings['useRebuke'];
				v58 = EpicSettings.Settings['useHammerofJustice'];
				v59 = EpicSettings.Settings['useDivineProtection'];
				v60 = EpicSettings.Settings['useDivineShield'];
				v135 = 2 - 1;
			end
			if (((8669 - 3914) > (3455 - (10 + 17))) and ((1 + 1) == v135)) then
				v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v67 = EpicSettings.Settings['divineProtectionHP'] or (1732 - (1400 + 332));
				v68 = EpicSettings.Settings['divineShieldHP'] or (0 - 0);
				v135 = 1911 - (242 + 1666);
			end
			if (((591 + 790) <= (869 + 1500)) and (v135 == (1 + 0))) then
				v61 = EpicSettings.Settings['useLayonHands'];
				v62 = EpicSettings.Settings['useLayonHandsFocus'];
				v63 = EpicSettings.Settings['useWordofGloryFocus'];
				v64 = EpicSettings.Settings['useWordofGloryMouseover'];
				v135 = 942 - (850 + 90);
			end
			if ((v135 == (8 - 3)) or ((6233 - (360 + 1030)) == (3615 + 469))) then
				v96 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
		end
	end
	local function v124()
		v84 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v81 = EpicSettings.Settings['InterruptWithStun'];
		v82 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v83 = EpicSettings.Settings['InterruptThreshold'];
		v78 = EpicSettings.Settings['DispelDebuffs'];
		v77 = EpicSettings.Settings['DispelBuffs'];
		v85 = EpicSettings.Settings['useTrinkets'];
		v87 = EpicSettings.Settings['useRacials'];
		v86 = EpicSettings.Settings['trinketsWithCD'];
		v88 = EpicSettings.Settings['racialsWithCD'];
		v90 = EpicSettings.Settings['useHealthstone'];
		v89 = EpicSettings.Settings['useHealingPotion'];
		v92 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v91 = EpicSettings.Settings['healingPotionHP'] or (1661 - (909 + 752));
		v93 = EpicSettings.Settings['HealingPotionName'] or "";
		v79 = EpicSettings.Settings['handleAfflicted'];
		v80 = EpicSettings.Settings['HandleIncorporeal'];
		v94 = EpicSettings.Settings['HealOOC'];
		v95 = EpicSettings.Settings['HealOOCHP'] or (1223 - (109 + 1114));
	end
	local function v125()
		local v150 = 0 - 0;
		while true do
			if (((1818 + 2851) > (605 - (6 + 236))) and ((3 + 1) == v150)) then
				if ((v98.Redemption:IsCastable() and v98.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((1511 + 366) >= (7400 - 4262))) then
					if (((8282 - 3540) >= (4759 - (1076 + 57))) and v25(v102.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((747 + 3793) == (1605 - (579 + 110)))) then
					if ((v98.Intercession:IsCastable() and (v15:HolyPower() >= (1 + 2)) and v98.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((1023 + 133) > (2307 + 2038))) then
						if (((2644 - (174 + 233)) < (11868 - 7619)) and v25(v102.IntercessionMouseover)) then
							return "Intercession mouseover";
						end
					end
				end
				if (v97.TargetIsValid() or v15:AffectingCombat() or ((4708 - 2025) < (11 + 12))) then
					local v198 = 1174 - (663 + 511);
					while true do
						if (((622 + 75) <= (180 + 646)) and ((5 - 3) == v198)) then
							v108 = v15:HolyPower();
							break;
						end
						if (((670 + 435) <= (2768 - 1592)) and (v198 == (0 - 0))) then
							v105 = v10.BossFightRemains(nil, true);
							v106 = v105;
							v198 = 1 + 0;
						end
						if (((6576 - 3197) <= (2717 + 1095)) and (v198 == (1 + 0))) then
							if ((v106 == (11833 - (478 + 244))) or ((1305 - (440 + 77)) >= (735 + 881))) then
								v106 = v10.FightRemains(v103, false);
							end
							v109 = v15:GCD();
							v198 = 7 - 5;
						end
					end
				end
				if (((3410 - (655 + 901)) <= (627 + 2752)) and v79) then
					if (((3483 + 1066) == (3072 + 1477)) and v75) then
						local v206 = 0 - 0;
						while true do
							if ((v206 == (1445 - (695 + 750))) or ((10319 - 7297) >= (4666 - 1642))) then
								v30 = v97.HandleAfflicted(v98.CleanseToxins, v102.CleanseToxinsMouseover, 160 - 120);
								if (((5171 - (285 + 66)) > (5123 - 2925)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					if ((v76 and (v108 > (1312 - (682 + 628)))) or ((172 + 889) >= (5190 - (176 + 123)))) then
						local v207 = 0 + 0;
						while true do
							if (((990 + 374) <= (4742 - (239 + 30))) and ((0 + 0) == v207)) then
								v30 = v97.HandleAfflicted(v98.WordofGlory, v102.WordofGloryMouseover, 39 + 1, true);
								if (v30 or ((6362 - 2767) <= (8 - 5))) then
									return v30;
								end
								break;
							end
						end
					end
				end
				v150 = 320 - (306 + 9);
			end
			if ((v150 == (0 - 0)) or ((813 + 3859) == (2364 + 1488))) then
				v123();
				v122();
				v124();
				v31 = EpicSettings.Toggles['ooc'];
				v150 = 1 + 0;
			end
			if (((4457 - 2898) == (2934 - (1140 + 235))) and (v150 == (2 + 0))) then
				v103 = v15:GetEnemiesInMeleeRange(8 + 0);
				if (v32 or ((450 + 1302) <= (840 - (33 + 19)))) then
					v104 = #v103;
				else
					v103 = {};
					v104 = 1 + 0;
				end
				if ((not v15:AffectingCombat() and v15:IsMounted()) or ((11710 - 7803) == (78 + 99))) then
					if (((6804 - 3334) > (521 + 34)) and v98.CrusaderAura:IsCastable() and (v15:BuffDown(v98.CrusaderAura))) then
						if (v25(v98.CrusaderAura) or ((1661 - (586 + 103)) == (59 + 586))) then
							return "crusader_aura";
						end
					end
				end
				if (((9796 - 6614) >= (3603 - (1309 + 179))) and (v15:AffectingCombat() or (v78 and v98.CleanseToxins:IsAvailable()))) then
					local v199 = v78 and v98.CleanseToxins:IsReady() and v34;
					v30 = v97.FocusUnit(v199, v102, 36 - 16, nil, 11 + 14);
					if (((10454 - 6561) < (3346 + 1083)) and v30) then
						return v30;
					end
				end
				v150 = 5 - 2;
			end
			if (((9 - 4) == v150) or ((3476 - (295 + 314)) < (4679 - 2774))) then
				if (v80 or ((3758 - (1300 + 662)) >= (12720 - 8669))) then
					local v200 = 1755 - (1178 + 577);
					while true do
						if (((841 + 778) <= (11103 - 7347)) and ((1405 - (851 + 554)) == v200)) then
							v30 = v97.HandleIncorporeal(v98.Repentance, v102.RepentanceMouseOver, 27 + 3, true);
							if (((1674 - 1070) == (1311 - 707)) and v30) then
								return v30;
							end
							v200 = 303 - (115 + 187);
						end
						if ((v200 == (1 + 0)) or ((4245 + 239) == (3546 - 2646))) then
							v30 = v97.HandleIncorporeal(v98.TurnEvil, v102.TurnEvilMouseOver, 1191 - (160 + 1001), true);
							if (v30 or ((3901 + 558) <= (768 + 345))) then
								return v30;
							end
							break;
						end
					end
				end
				v30 = v115();
				if (((7434 - 3802) > (3756 - (237 + 121))) and v30) then
					return v30;
				end
				if (((4979 - (525 + 372)) <= (9321 - 4404)) and v78 and v34) then
					local v201 = 0 - 0;
					while true do
						if (((4974 - (96 + 46)) >= (2163 - (643 + 134))) and (v201 == (0 + 0))) then
							if (((328 - 191) == (508 - 371)) and v14) then
								local v208 = 0 + 0;
								while true do
									if (((0 - 0) == v208) or ((3209 - 1639) >= (5051 - (316 + 403)))) then
										v30 = v114();
										if (v30 or ((2702 + 1362) <= (5001 - 3182))) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v16 and v16:Exists() and v16:IsAPlayer() and (v97.UnitHasCurseDebuff(v16) or v97.UnitHasPoisonDebuff(v16))) or ((1802 + 3184) < (3963 - 2389))) then
								if (((3137 + 1289) > (56 + 116)) and v98.CleanseToxins:IsReady()) then
									if (((2030 - 1444) > (2173 - 1718)) and v25(v102.CleanseToxinsMouseover)) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v150 = 12 - 6;
			end
			if (((48 + 778) == (1625 - 799)) and ((1 + 5) == v150)) then
				v30 = v116();
				if (v30 or ((11824 - 7805) > (4458 - (12 + 5)))) then
					return v30;
				end
				if (((7833 - 5816) < (9091 - 4830)) and not v15:AffectingCombat() and v31 and v97.TargetIsValid()) then
					local v202 = 0 - 0;
					while true do
						if (((11694 - 6978) > (17 + 63)) and (v202 == (1973 - (1656 + 317)))) then
							v30 = v118();
							if (v30 or ((3126 + 381) == (2622 + 650))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v15:AffectingCombat() and v97.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or ((2329 - 1453) >= (15133 - 12058))) then
					local v203 = 354 - (5 + 349);
					while true do
						if (((20671 - 16319) > (3825 - (266 + 1005))) and (v203 == (0 + 0))) then
							if ((v61 and (v15:HealthPercentage() <= v69) and v98.LayonHands:IsReady() and v15:DebuffDown(v98.ForbearanceDebuff)) or ((15033 - 10627) < (5322 - 1279))) then
								if (v25(v98.LayonHands) or ((3585 - (561 + 1135)) >= (4407 - 1024))) then
									return "lay_on_hands_player defensive";
								end
							end
							if (((6219 - 4327) <= (3800 - (507 + 559))) and v60 and (v15:HealthPercentage() <= v68) and v98.DivineShield:IsCastable() and v15:DebuffDown(v98.ForbearanceDebuff)) then
								if (((4825 - 2902) < (6859 - 4641)) and v25(v98.DivineShield)) then
									return "divine_shield defensive";
								end
							end
							v203 = 389 - (212 + 176);
						end
						if (((3078 - (250 + 655)) > (1033 - 654)) and (v203 == (2 - 0))) then
							if ((v89 and (v15:HealthPercentage() <= v91)) or ((4053 - 1462) == (5365 - (1869 + 87)))) then
								if (((15656 - 11142) > (5225 - (484 + 1417))) and (v93 == "Refreshing Healing Potion")) then
									if (v99.RefreshingHealingPotion:IsReady() or ((445 - 237) >= (8090 - 3262))) then
										if (v25(v102.RefreshingHealingPotion) or ((2356 - (48 + 725)) > (5826 - 2259))) then
											return "refreshing healing potion defensive";
										end
									end
								end
								if ((v93 == "Dreamwalker's Healing Potion") or ((3522 - 2209) == (462 + 332))) then
									if (((8482 - 5308) > (813 + 2089)) and v99.DreamwalkersHealingPotion:IsReady()) then
										if (((1201 + 2919) <= (5113 - (152 + 701))) and v25(v102.RefreshingHealingPotion)) then
											return "dreamwalkers healing potion defensive";
										end
									end
								end
							end
							if ((v84 < v106) or ((2194 - (430 + 881)) > (1830 + 2948))) then
								v30 = v119();
								if (v30 or ((4515 - (557 + 338)) >= (1446 + 3445))) then
									return v30;
								end
							end
							v203 = 8 - 5;
						end
						if (((14910 - 10652) > (2488 - 1551)) and (v203 == (6 - 3))) then
							v30 = v121();
							if (v30 or ((5670 - (499 + 302)) < (1772 - (39 + 827)))) then
								return v30;
							end
							v203 = 10 - 6;
						end
						if ((v203 == (2 - 1)) or ((4865 - 3640) > (6490 - 2262))) then
							if (((285 + 3043) > (6550 - 4312)) and v59 and v98.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v67)) then
								if (((615 + 3224) > (2223 - 818)) and v25(v98.DivineProtection)) then
									return "divine_protection defensive";
								end
							end
							if ((v99.Healthstone:IsReady() and v90 and (v15:HealthPercentage() <= v92)) or ((1397 - (103 + 1)) <= (1061 - (475 + 79)))) then
								if (v25(v102.Healthstone) or ((6260 - 3364) < (2576 - 1771))) then
									return "healthstone defensive";
								end
							end
							v203 = 1 + 1;
						end
						if (((2039 + 277) == (3819 - (1395 + 108))) and (v203 == (11 - 7))) then
							if (v25(v98.Pool) or ((3774 - (7 + 1197)) == (669 + 864))) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if ((v150 == (1 + 0)) or ((1202 - (27 + 292)) == (4278 - 2818))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((5889 - 1270) <= (4189 - 3190))) then
					return v30;
				end
				v150 = 3 - 1;
			end
			if (((5 - 2) == v150) or ((3549 - (43 + 96)) > (16789 - 12673))) then
				if (v34 or ((2041 - 1138) >= (2539 + 520))) then
					local v204 = 0 + 0;
					while true do
						if ((v204 == (1 - 0)) or ((1524 + 2452) < (5353 - 2496))) then
							if (((1553 + 3377) > (170 + 2137)) and v98.BlessingofFreedom:IsReady() and v97.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
								if (v25(v102.BlessingofFreedomFocus) or ((5797 - (1414 + 337)) < (3231 - (1642 + 298)))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if ((v204 == (0 - 0)) or ((12200 - 7959) == (10519 - 6974))) then
							v30 = v97.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 14 + 26, 20 + 5);
							if (v30 or ((5020 - (357 + 615)) > (2971 + 1261))) then
								return v30;
							end
							v204 = 2 - 1;
						end
					end
				end
				v107 = v111();
				if (not v15:AffectingCombat() or ((1500 + 250) >= (7442 - 3969))) then
					if (((2533 + 633) == (216 + 2950)) and v98.RetributionAura:IsCastable() and (v112())) then
						if (((1109 + 654) < (5025 - (384 + 917))) and v25(v98.RetributionAura)) then
							return "retribution_aura";
						end
					end
				end
				if (((754 - (128 + 569)) <= (4266 - (1407 + 136))) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					if (v15:AffectingCombat() or ((3957 - (687 + 1200)) == (2153 - (556 + 1154)))) then
						if (v98.Intercession:IsCastable() or ((9516 - 6811) == (1488 - (9 + 86)))) then
							if (v25(v98.Intercession, not v17:IsInRange(451 - (275 + 146)), true) or ((749 + 3852) < (125 - (29 + 35)))) then
								return "intercession target";
							end
						end
					elseif (v98.Redemption:IsCastable() or ((6160 - 4770) >= (14169 - 9425))) then
						if (v25(v98.Redemption, not v17:IsInRange(132 - 102), true) or ((1305 + 698) > (4846 - (53 + 959)))) then
							return "redemption target";
						end
					end
				end
				v150 = 412 - (312 + 96);
			end
		end
	end
	local function v126()
		local v151 = 0 - 0;
		while true do
			if ((v151 == (285 - (147 + 138))) or ((1055 - (813 + 86)) > (3537 + 376))) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v101();
				break;
			end
		end
	end
	v21.SetAPL(129 - 59, v125, v126);
end;
return v0["Epix_Paladin_Retribution.lua"]();

