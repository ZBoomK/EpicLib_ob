local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((8 + 538) >= (670 + 2014))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Paladin_Retribution.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Focus;
	local v14 = v11.Player;
	local v15 = v11.MouseOver;
	local v16 = v11.Target;
	local v17 = v11.Pet;
	local v18 = v9.Spell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Bind;
	local v23 = v20.Macro;
	local v24 = v20.Press;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27 = math.min;
	local v28 = math.max;
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
	local v98 = v20.Commons.Everyone;
	local v99 = v18.Paladin.Retribution;
	local v100 = v19.Paladin.Retribution;
	local v101 = {};
	local function v102()
		if (((1988 - (423 + 100)) <= (31 + 4270)) and v99.CleanseToxins:IsAvailable()) then
			v98.DispellableDebuffs = v12.MergeTable(v98.DispellableDiseaseDebuffs, v98.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v102();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v103 = v23.Paladin.Retribution;
	local v104;
	local v105;
	local v106 = 30764 - 19653;
	local v107 = 5792 + 5319;
	local v108;
	local v109 = 771 - (326 + 445);
	local v110 = 0 - 0;
	local v111;
	v9:RegisterForEvent(function()
		local v128 = 0 - 0;
		while true do
			if (((3977 - 2273) > (2136 - (530 + 181))) and (v128 == (881 - (614 + 267)))) then
				v106 = 11143 - (19 + 13);
				v107 = 18084 - 6973;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v112()
		local v129 = v14:GCDRemains();
		local v130 = v27(v99.CrusaderStrike:CooldownRemains(), v99.BladeofJustice:CooldownRemains(), v99.Judgment:CooldownRemains(), (v99.HammerofWrath:IsUsable() and v99.HammerofWrath:CooldownRemains()) or (23 - 13), v99.WakeofAshes:CooldownRemains());
		if ((v129 > v130) or ((1962 - 1275) == (1100 + 3134))) then
			return v129;
		end
		return v130;
	end
	local function v113()
		return v14:BuffDown(v99.RetributionAura) and v14:BuffDown(v99.DevotionAura) and v14:BuffDown(v99.ConcentrationAura) and v14:BuffDown(v99.CrusaderAura);
	end
	local v114 = 0 - 0;
	local function v115()
		if ((v99.CleanseToxins:IsReady() and (v98.UnitHasDispellableDebuffByPlayer(v13) or v98.DispellableFriendlyUnit(51 - 26))) or ((5142 - (1293 + 519)) < (2915 - 1486))) then
			local v142 = 0 - 0;
			while true do
				if (((2193 - 1046) >= (1444 - 1109)) and (v142 == (0 - 0))) then
					if (((1820 + 1615) > (428 + 1669)) and (v114 == (0 - 0))) then
						v114 = GetTime();
					end
					if (v98.Wait(116 + 384, v114) or ((1253 + 2517) >= (2526 + 1515))) then
						if (v24(v103.CleanseToxinsFocus) or ((4887 - (709 + 387)) <= (3469 - (673 + 1185)))) then
							return "cleanse_toxins dispel";
						end
						v114 = 0 - 0;
					end
					break;
				end
			end
		end
	end
	local function v116()
		if ((v95 and (v14:HealthPercentage() <= v96)) or ((14700 - 10122) <= (3303 - 1295))) then
			if (((805 + 320) <= (1552 + 524)) and v99.FlashofLight:IsReady()) then
				if (v24(v99.FlashofLight) or ((1002 - 259) >= (1081 + 3318))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v117()
		local v131 = 0 - 0;
		while true do
			if (((2266 - 1111) < (3553 - (446 + 1434))) and (v131 == (1284 - (1040 + 243)))) then
				if (v13 or ((6936 - 4612) <= (2425 - (559 + 1288)))) then
					if (((5698 - (609 + 1322)) == (4221 - (13 + 441))) and v99.WordofGlory:IsReady() and v64 and (v13:HealthPercentage() <= v72)) then
						if (((15279 - 11190) == (10710 - 6621)) and v24(v103.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((22202 - 17744) >= (63 + 1611)) and v99.LayonHands:IsCastable() and v63 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v71) and v14:AffectingCombat()) then
						if (((3529 - 2557) <= (504 + 914)) and v24(v103.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v99.BlessingofSacrifice:IsCastable() and v67 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v75)) or ((2164 + 2774) < (14131 - 9369))) then
						if (v24(v103.BlessingofSacrificeFocus) or ((1371 + 1133) > (7842 - 3578))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((1424 + 729) == (1198 + 955)) and v99.BlessingofProtection:IsCastable() and v66 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v74)) then
						if (v24(v103.BlessingofProtectionFocus) or ((365 + 142) >= (2176 + 415))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if (((4385 + 96) == (4914 - (153 + 280))) and (v131 == (0 - 0))) then
				if (v15:Exists() or ((2091 + 237) < (274 + 419))) then
					if (((2265 + 2063) == (3928 + 400)) and v99.WordofGlory:IsReady() and v65 and (v15:HealthPercentage() <= v73)) then
						if (((1151 + 437) >= (2027 - 695)) and v24(v103.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v13 or not v13:Exists() or not v13:IsInRange(19 + 11) or ((4841 - (89 + 578)) > (3035 + 1213))) then
					return;
				end
				v131 = 1 - 0;
			end
		end
	end
	local function v118()
		v29 = v98.HandleTopTrinket(v101, v32, 1089 - (572 + 477), nil);
		if (v29 or ((619 + 3967) <= (50 + 32))) then
			return v29;
		end
		v29 = v98.HandleBottomTrinket(v101, v32, 5 + 35, nil);
		if (((3949 - (84 + 2)) == (6366 - 2503)) and v29) then
			return v29;
		end
	end
	local function v119()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (843 - (497 + 345))) or ((8 + 274) <= (8 + 34))) then
				if (((5942 - (605 + 728)) >= (547 + 219)) and v99.JusticarsVengeance:IsAvailable() and v99.JusticarsVengeance:IsReady() and v45 and (v109 >= (8 - 4))) then
					if (v24(v99.JusticarsVengeance, not v16:IsSpellInRange(v99.JusticarsVengeance)) or ((53 + 1099) == (9198 - 6710))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if (((3085 + 337) > (9281 - 5931)) and v99.FinalVerdict:IsAvailable() and v99.FinalVerdict:IsReady() and v49 and (v109 >= (4 + 0))) then
					if (((1366 - (457 + 32)) > (160 + 216)) and v24(v99.FinalVerdict, not v16:IsSpellInRange(v99.FinalVerdict))) then
						return "final verdict precombat 3";
					end
				end
				v132 = 1404 - (832 + 570);
			end
			if ((v132 == (0 + 0)) or ((814 + 2304) <= (6550 - 4699))) then
				if ((v99.ArcaneTorrent:IsCastable() and v88 and ((v89 and v32) or not v89) and v99.FinalReckoning:IsAvailable()) or ((80 + 85) >= (4288 - (588 + 208)))) then
					if (((10643 - 6694) < (6656 - (884 + 916))) and v24(v99.ArcaneTorrent, not v16:IsInRange(16 - 8))) then
						return "arcane_torrent precombat 0";
					end
				end
				if ((v99.ShieldofVengeance:IsCastable() and v53 and ((v32 and v57) or not v57)) or ((2480 + 1796) < (3669 - (232 + 421)))) then
					if (((6579 - (1569 + 320)) > (1013 + 3112)) and v24(v99.ShieldofVengeance, not v16:IsInRange(2 + 6))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v132 = 3 - 2;
			end
			if ((v132 == (609 - (316 + 289))) or ((130 - 80) >= (42 + 854))) then
				if ((v99.CrusaderStrike:IsCastable() and v38) or ((3167 - (666 + 787)) >= (3383 - (360 + 65)))) then
					if (v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike)) or ((1394 + 97) < (898 - (79 + 175)))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if (((1109 - 405) < (771 + 216)) and (v132 == (5 - 3))) then
				if (((7160 - 3442) > (2805 - (503 + 396))) and v99.TemplarsVerdict:IsReady() and v49 and (v109 >= (185 - (92 + 89)))) then
					if (v24(v99.TemplarsVerdict, not v16:IsSpellInRange(v99.TemplarsVerdict)) or ((1858 - 900) > (1865 + 1770))) then
						return "templars verdict precombat 4";
					end
				end
				if (((2073 + 1428) <= (17591 - 13099)) and v99.BladeofJustice:IsCastable() and v36) then
					if (v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice)) or ((471 + 2971) < (5809 - 3261))) then
						return "blade_of_justice precombat 5";
					end
				end
				v132 = 3 + 0;
			end
			if (((1374 + 1501) >= (4458 - 2994)) and (v132 == (1 + 2))) then
				if ((v99.Judgment:IsCastable() and v44) or ((7314 - 2517) >= (6137 - (485 + 759)))) then
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((1274 - 723) > (3257 - (442 + 747)))) then
						return "judgment precombat 6";
					end
				end
				if (((3249 - (832 + 303)) > (1890 - (88 + 858))) and v99.HammerofWrath:IsReady() and v43) then
					if (v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath)) or ((690 + 1572) >= (2563 + 533))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v132 = 1 + 3;
			end
		end
	end
	local function v120()
		local v133 = 789 - (766 + 23);
		local v134;
		while true do
			if ((v133 == (19 - 15)) or ((3083 - 828) >= (9318 - 5781))) then
				if ((v99.Crusade:IsCastable() and v51 and ((v32 and v55) or not v55) and (v14:BuffRemains(v99.CrusadeBuff) < v14:GCD()) and (((v109 >= (16 - 11)) and (v9.CombatTime() < (1078 - (1036 + 37)))) or ((v109 >= (3 + 0)) and (v9.CombatTime() > (9 - 4))))) or ((3019 + 818) < (2786 - (641 + 839)))) then
					if (((3863 - (910 + 3)) == (7520 - 4570)) and v24(v99.Crusade, not v16:IsInRange(1694 - (1466 + 218)))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v99.FinalReckoning:IsCastable() and v52 and ((v32 and v56) or not v56) and (((v109 >= (2 + 2)) and (v9.CombatTime() < (1156 - (556 + 592)))) or ((v109 >= (2 + 1)) and (v9.CombatTime() >= (816 - (329 + 479)))) or ((v109 >= (856 - (174 + 680))) and v99.DivineAuxiliary:IsAvailable())) and ((v99.AvengingWrath:CooldownRemains() > (34 - 24)) or (v99.Crusade:CooldownDown() and (v14:BuffDown(v99.CrusadeBuff) or (v14:BuffStack(v99.CrusadeBuff) >= (20 - 10))))) and ((v108 > (0 + 0)) or (v109 == (744 - (396 + 343))) or ((v109 >= (1 + 1)) and v99.DivineAuxiliary:IsAvailable()))) or ((6200 - (29 + 1448)) < (4687 - (135 + 1254)))) then
					if (((4279 - 3143) >= (718 - 564)) and (v97 == "player")) then
						if (v24(v103.FinalReckoningPlayer, not v16:IsInRange(7 + 3)) or ((1798 - (389 + 1138)) > (5322 - (102 + 472)))) then
							return "final_reckoning cooldowns 18";
						end
					end
					if (((4474 + 266) >= (1748 + 1404)) and (v97 == "cursor")) then
						if (v24(v103.FinalReckoningCursor, not v16:IsInRange(19 + 1)) or ((4123 - (320 + 1225)) >= (6034 - 2644))) then
							return "final_reckoning cooldowns 18";
						end
					end
				end
				break;
			end
			if (((26 + 15) <= (3125 - (157 + 1307))) and (v133 == (1861 - (821 + 1038)))) then
				if (((1499 - 898) < (390 + 3170)) and v86 and ((v32 and v87) or not v87) and v16:IsInRange(13 - 5)) then
					local v197 = 0 + 0;
					while true do
						if (((582 - 347) < (1713 - (834 + 192))) and (v197 == (0 + 0))) then
							v29 = v118();
							if (((1168 + 3381) > (25 + 1128)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v99.ShieldofVengeance:IsCastable() and v53 and ((v32 and v57) or not v57) and (v107 > (23 - 8)) and (not v99.ExecutionSentence:IsAvailable() or v16:DebuffDown(v99.ExecutionSentence))) or ((4978 - (300 + 4)) < (1248 + 3424))) then
					if (((9601 - 5933) < (4923 - (112 + 250))) and v24(v99.ShieldofVengeance)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v133 = 2 + 1;
			end
			if ((v133 == (7 - 4)) or ((261 + 194) == (1865 + 1740))) then
				if ((v99.ExecutionSentence:IsCastable() and v42 and ((v14:BuffDown(v99.CrusadeBuff) and (v99.Crusade:CooldownRemains() > (12 + 3))) or (v14:BuffStack(v99.CrusadeBuff) == (5 + 5)) or (v99.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v99.AvengingWrath:CooldownRemains() > (1429 - (1001 + 413)))) and (((v109 >= (8 - 4)) and (v9.CombatTime() < (887 - (244 + 638)))) or ((v109 >= (696 - (627 + 66))) and (v9.CombatTime() > (14 - 9))) or ((v109 >= (604 - (512 + 90))) and v99.DivineAuxiliary:IsAvailable())) and (((v107 > (1914 - (1665 + 241))) and not v99.ExecutionersWill:IsAvailable()) or (v107 > (729 - (373 + 344))))) or ((1202 + 1461) == (877 + 2435))) then
					if (((11281 - 7004) <= (7572 - 3097)) and v24(v99.ExecutionSentence, not v16:IsSpellInRange(v99.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if ((v99.AvengingWrath:IsCastable() and v50 and ((v32 and v54) or not v54) and (((v109 >= (1103 - (35 + 1064))) and (v9.CombatTime() < (4 + 1))) or ((v109 >= (6 - 3)) and (v9.CombatTime() > (1 + 4))) or ((v109 >= (1238 - (298 + 938))) and v99.DivineAuxiliary:IsAvailable() and ((v99.ExecutionSentence:IsAvailable() and ((v99.ExecutionSentence:CooldownRemains() == (1259 - (233 + 1026))) or (v99.ExecutionSentence:CooldownRemains() > (1681 - (636 + 1030))) or not v99.ExecutionSentence:IsReady())) or (v99.FinalReckoning:IsAvailable() and ((v99.FinalReckoning:CooldownRemains() == (0 + 0)) or (v99.FinalReckoning:CooldownRemains() > (30 + 0)) or not v99.FinalReckoning:IsReady())))))) or ((259 + 611) == (81 + 1108))) then
					if (((1774 - (55 + 166)) <= (608 + 2525)) and v24(v99.AvengingWrath, not v16:IsInRange(2 + 8))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v133 = 15 - 11;
			end
			if ((v133 == (297 - (36 + 261))) or ((3912 - 1675) >= (4879 - (34 + 1334)))) then
				v134 = v98.HandleDPSPotion(v14:BuffUp(v99.AvengingWrathBuff) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.Crusade) == (4 + 6))) or (v107 < (20 + 5)));
				if (v134 or ((2607 - (1035 + 248)) > (3041 - (20 + 1)))) then
					return v134;
				end
				v133 = 1 + 0;
			end
			if ((v133 == (320 - (134 + 185))) or ((4125 - (549 + 584)) == (2566 - (314 + 371)))) then
				if (((10662 - 7556) > (2494 - (478 + 490))) and v99.LightsJudgment:IsCastable() and v88 and ((v89 and v32) or not v89)) then
					if (((1602 + 1421) < (5042 - (786 + 386))) and v24(v99.LightsJudgment, not v16:IsInRange(129 - 89))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if (((1522 - (1055 + 324)) > (1414 - (1093 + 247))) and v99.Fireblood:IsCastable() and v88 and ((v89 and v32) or not v89) and (v14:BuffUp(v99.AvengingWrathBuff) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) == (9 + 1))))) then
					if (((2 + 16) < (8385 - 6273)) and v24(v99.Fireblood, not v16:IsInRange(33 - 23))) then
						return "fireblood cooldowns 6";
					end
				end
				v133 = 5 - 3;
			end
		end
	end
	local function v121()
		v111 = ((v105 >= (7 - 4)) or ((v105 >= (1 + 1)) and not v99.DivineArbiter:IsAvailable()) or v14:BuffUp(v99.EmpyreanPowerBuff)) and v14:BuffDown(v99.EmpyreanLegacyBuff) and not (v14:BuffUp(v99.DivineArbiterBuff) and (v14:BuffStack(v99.DivineArbiterBuff) > (92 - 68)));
		if (((3781 - 2684) <= (1228 + 400)) and v99.DivineStorm:IsReady() and v40 and v111 and (not v99.Crusade:IsAvailable() or (v99.Crusade:CooldownRemains() > (v110 * (7 - 4))) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (698 - (364 + 324)))))) then
			if (((12692 - 8062) == (11110 - 6480)) and v24(v99.DivineStorm, not v16:IsInRange(4 + 6))) then
				return "divine_storm finishers 2";
			end
		end
		if (((14812 - 11272) > (4296 - 1613)) and v99.JusticarsVengeance:IsReady() and v45 and (not v99.Crusade:IsAvailable() or (v99.Crusade:CooldownRemains() > (v110 * (8 - 5))) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (1278 - (1249 + 19)))))) then
			if (((4328 + 466) >= (12747 - 9472)) and v24(v99.JusticarsVengeance, not v16:IsSpellInRange(v99.JusticarsVengeance))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if (((2570 - (686 + 400)) == (1165 + 319)) and v99.FinalVerdict:IsAvailable() and v99.FinalVerdict:IsCastable() and v49 and (not v99.Crusade:IsAvailable() or (v99.Crusade:CooldownRemains() > (v110 * (232 - (73 + 156)))) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (1 + 9))))) then
			if (((2243 - (721 + 90)) < (40 + 3515)) and v24(v99.FinalVerdict, not v16:IsSpellInRange(v99.FinalVerdict))) then
				return "final verdict finishers 6";
			end
		end
		if ((v99.TemplarsVerdict:IsReady() and v49 and (not v99.Crusade:IsAvailable() or (v99.Crusade:CooldownRemains() > (v110 * (9 - 6))) or (v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (480 - (224 + 246)))))) or ((1725 - 660) > (6587 - 3009))) then
			if (v24(v99.TemplarsVerdict, not v16:IsSpellInRange(v99.TemplarsVerdict)) or ((870 + 3925) < (34 + 1373))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v122()
		local v135 = 0 + 0;
		while true do
			if (((3683 - 1830) < (16016 - 11203)) and (v135 == (513 - (203 + 310)))) then
				if ((v109 >= (1998 - (1238 + 755))) or (v14:BuffUp(v99.EchoesofWrathBuff) and v14:HasTier(3 + 28, 1538 - (709 + 825)) and v99.CrusadingStrikes:IsAvailable()) or ((v16:DebuffUp(v99.JudgmentDebuff) or (v109 == (7 - 3))) and v14:BuffUp(v99.DivineResonanceBuff) and not v14:HasTier(44 - 13, 866 - (196 + 668))) or ((11138 - 8317) < (5035 - 2604))) then
					local v198 = 833 - (171 + 662);
					while true do
						if ((v198 == (93 - (4 + 89))) or ((10073 - 7199) < (795 + 1386))) then
							v29 = v121();
							if (v29 or ((11810 - 9121) <= (135 + 208))) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v99.BladeofJustice:IsCastable() and v36 and not v16:DebuffUp(v99.ExpurgationDebuff) and (v109 <= (1489 - (35 + 1451))) and v14:HasTier(1484 - (28 + 1425), 1995 - (941 + 1052))) or ((1793 + 76) == (3523 - (822 + 692)))) then
					if (v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice)) or ((5061 - 1515) < (1094 + 1228))) then
						return "blade_of_justice generators 1";
					end
				end
				if ((v99.WakeofAshes:IsCastable() and v48 and (v109 <= (299 - (45 + 252))) and ((v99.AvengingWrath:CooldownRemains() > (0 + 0)) or (v99.Crusade:CooldownRemains() > (0 + 0)) or not v99.Crusade:IsAvailable() or not v99.AvengingWrath:IsReady()) and (not v99.ExecutionSentence:IsAvailable() or (v99.ExecutionSentence:CooldownRemains() > (9 - 5)) or (v107 < (441 - (114 + 319))) or not v99.ExecutionSentence:IsReady())) or ((2988 - 906) == (6115 - 1342))) then
					if (((2069 + 1175) > (1571 - 516)) and v24(v99.WakeofAshes, not v16:IsInRange(20 - 10))) then
						return "wake_of_ashes generators 2";
					end
				end
				if ((v99.BladeofJustice:IsCastable() and v36 and not v16:DebuffUp(v99.ExpurgationDebuff) and (v109 <= (1966 - (556 + 1407))) and v14:HasTier(1237 - (741 + 465), 467 - (170 + 295))) or ((1746 + 1567) <= (1634 + 144))) then
					if (v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice)) or ((3498 - 2077) >= (1745 + 359))) then
						return "blade_of_justice generators 4";
					end
				end
				v135 = 1 + 0;
			end
			if (((1027 + 785) <= (4479 - (957 + 273))) and (v135 == (1 + 2))) then
				if (((650 + 973) <= (7457 - 5500)) and v99.BladeofJustice:IsCastable() and v36 and ((v109 <= (7 - 4)) or not v99.HolyBlade:IsAvailable())) then
					if (((13476 - 9064) == (21846 - 17434)) and v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				if (((3530 - (389 + 1391)) >= (529 + 313)) and ((v16:HealthPercentage() <= (3 + 17)) or v14:BuffUp(v99.AvengingWrathBuff) or v14:BuffUp(v99.CrusadeBuff) or v14:BuffUp(v99.EmpyreanPowerBuff))) then
					v29 = v121();
					if (((9953 - 5581) > (2801 - (783 + 168))) and v29) then
						return v29;
					end
				end
				if (((778 - 546) < (808 + 13)) and v99.Consecration:IsCastable() and v37 and v16:DebuffDown(v99.ConsecrationDebuff) and (v105 >= (313 - (309 + 2)))) then
					if (((1590 - 1072) < (2114 - (1090 + 122))) and v24(v99.Consecration, not v16:IsInRange(4 + 6))) then
						return "consecration generators 22";
					end
				end
				if (((10055 - 7061) > (588 + 270)) and v99.DivineHammer:IsCastable() and v39 and (v105 >= (1120 - (628 + 490)))) then
					if (v24(v99.DivineHammer, not v16:IsInRange(2 + 8)) or ((9297 - 5542) <= (4181 - 3266))) then
						return "divine_hammer generators 24";
					end
				end
				v135 = 778 - (431 + 343);
			end
			if (((7969 - 4023) > (10828 - 7085)) and (v135 == (4 + 1))) then
				if ((v99.TemplarStrike:IsReady() and v47) or ((171 + 1164) >= (5001 - (556 + 1139)))) then
					if (((4859 - (6 + 9)) > (413 + 1840)) and v24(v99.TemplarStrike, not v16:IsInRange(6 + 4))) then
						return "templar_strike generators 30";
					end
				end
				if (((621 - (28 + 141)) == (176 + 276)) and v99.Judgment:IsReady() and v44 and ((v109 <= (3 - 0)) or not v99.BoundlessJudgment:IsAvailable())) then
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((3228 + 1329) < (3404 - (486 + 831)))) then
						return "judgment generators 32";
					end
				end
				if (((10081 - 6207) == (13638 - 9764)) and v99.HammerofWrath:IsReady() and v43 and ((v109 <= (1 + 2)) or (v16:HealthPercentage() > (63 - 43)) or not v99.VanguardsMomentum:IsAvailable())) then
					if (v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath)) or ((3201 - (668 + 595)) > (4441 + 494))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if ((v99.CrusaderStrike:IsCastable() and v38) or ((858 + 3397) < (9334 - 5911))) then
					if (((1744 - (23 + 267)) <= (4435 - (1129 + 815))) and v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v135 = 393 - (371 + 16);
			end
			if ((v135 == (1751 - (1326 + 424))) or ((7873 - 3716) <= (10242 - 7439))) then
				if (((4971 - (88 + 30)) >= (3753 - (720 + 51))) and v99.DivineToll:IsCastable() and v41 and (v109 <= (4 - 2)) and ((v99.AvengingWrath:CooldownRemains() > (1791 - (421 + 1355))) or (v99.Crusade:CooldownRemains() > (24 - 9)) or (v107 < (4 + 4)))) then
					if (((5217 - (286 + 797)) > (12271 - 8914)) and v24(v99.DivineToll, not v16:IsInRange(49 - 19))) then
						return "divine_toll generators 6";
					end
				end
				if ((v99.Judgment:IsReady() and v44 and v16:DebuffUp(v99.ExpurgationDebuff) and v14:BuffDown(v99.EchoesofWrathBuff) and v14:HasTier(470 - (397 + 42), 1 + 1)) or ((4217 - (24 + 776)) < (3903 - 1369))) then
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((3507 - (222 + 563)) <= (360 - 196))) then
						return "judgment generators 7";
					end
				end
				if (((v109 >= (3 + 0)) and v14:BuffUp(v99.CrusadeBuff) and (v14:BuffStack(v99.CrusadeBuff) < (200 - (23 + 167)))) or ((4206 - (690 + 1108)) < (761 + 1348))) then
					v29 = v121();
					if (v29 or ((28 + 5) == (2303 - (40 + 808)))) then
						return v29;
					end
				end
				if ((v99.TemplarSlash:IsReady() and v46 and ((v99.TemplarStrike:TimeSinceLastCast() + v110) < (1 + 3)) and (v105 >= (7 - 5))) or ((424 + 19) >= (2125 + 1890))) then
					if (((1855 + 1527) > (737 - (47 + 524))) and v24(v99.TemplarSlash, not v16:IsInRange(7 + 3))) then
						return "templar_slash generators 8";
					end
				end
				v135 = 5 - 3;
			end
			if ((v135 == (8 - 2)) or ((638 - 358) == (4785 - (1165 + 561)))) then
				if (((56 + 1825) > (4004 - 2711)) and v99.ArcaneTorrent:IsCastable() and ((v89 and v32) or not v89) and v88 and (v109 < (2 + 3)) and (v85 < v107)) then
					if (((2836 - (341 + 138)) == (637 + 1720)) and v24(v99.ArcaneTorrent, not v16:IsInRange(20 - 10))) then
						return "arcane_torrent generators 28";
					end
				end
				if (((449 - (89 + 237)) == (395 - 272)) and v99.Consecration:IsCastable() and v37) then
					if (v24(v99.Consecration, not v16:IsInRange(21 - 11)) or ((1937 - (581 + 300)) >= (4612 - (855 + 365)))) then
						return "consecration generators 30";
					end
				end
				if ((v99.DivineHammer:IsCastable() and v39) or ((2567 - 1486) < (352 + 723))) then
					if (v24(v99.DivineHammer, not v16:IsInRange(1245 - (1030 + 205))) or ((985 + 64) >= (4123 + 309))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if ((v135 == (290 - (156 + 130))) or ((10833 - 6065) <= (1425 - 579))) then
				if ((v99.CrusaderStrike:IsCastable() and v38 and (v99.CrusaderStrike:ChargesFractional() >= (1.75 - 0)) and ((v109 <= (1 + 1)) or ((v109 <= (2 + 1)) and (v99.BladeofJustice:CooldownRemains() > (v110 * (71 - (10 + 59))))) or ((v109 == (2 + 2)) and (v99.BladeofJustice:CooldownRemains() > (v110 * (9 - 7))) and (v99.Judgment:CooldownRemains() > (v110 * (1165 - (671 + 492))))))) or ((2674 + 684) <= (2635 - (369 + 846)))) then
					if (v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike)) or ((990 + 2749) <= (2565 + 440))) then
						return "crusader_strike generators 26";
					end
				end
				v29 = v121();
				if (v29 or ((3604 - (1036 + 909)) >= (1697 + 437))) then
					return v29;
				end
				if ((v99.TemplarSlash:IsReady() and v46) or ((5473 - 2213) < (2558 - (11 + 192)))) then
					if (v24(v99.TemplarSlash, not v16:IsInRange(6 + 4)) or ((844 - (135 + 40)) == (10231 - 6008))) then
						return "templar_slash generators 28";
					end
				end
				v135 = 4 + 1;
			end
			if ((v135 == (4 - 2)) or ((2535 - 843) < (764 - (50 + 126)))) then
				if ((v99.BladeofJustice:IsCastable() and v36 and ((v109 <= (8 - 5)) or not v99.HolyBlade:IsAvailable()) and (((v105 >= (1 + 1)) and not v99.CrusadingStrikes:IsAvailable()) or (v105 >= (1417 - (1233 + 180))))) or ((5766 - (522 + 447)) < (5072 - (107 + 1314)))) then
					if (v24(v99.BladeofJustice, not v16:IsSpellInRange(v99.BladeofJustice)) or ((1939 + 2238) > (14778 - 9928))) then
						return "blade_of_justice generators 10";
					end
				end
				if ((v99.HammerofWrath:IsReady() and v43 and ((v105 < (1 + 1)) or not v99.BlessedChampion:IsAvailable() or v14:HasTier(59 - 29, 15 - 11)) and ((v109 <= (1913 - (716 + 1194))) or (v16:HealthPercentage() > (1 + 19)) or not v99.VanguardsMomentum:IsAvailable())) or ((43 + 357) > (1614 - (74 + 429)))) then
					if (((5885 - 2834) > (499 + 506)) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath generators 12";
					end
				end
				if (((8453 - 4760) <= (3101 + 1281)) and v99.TemplarSlash:IsReady() and v46 and ((v99.TemplarStrike:TimeSinceLastCast() + v110) < (12 - 8))) then
					if (v24(v99.TemplarSlash, not v16:IsSpellInRange(v99.TemplarSlash)) or ((8114 - 4832) > (4533 - (279 + 154)))) then
						return "templar_slash generators 14";
					end
				end
				if ((v99.Judgment:IsReady() and v44 and v16:DebuffDown(v99.JudgmentDebuff) and ((v109 <= (781 - (454 + 324))) or not v99.BoundlessJudgment:IsAvailable())) or ((2817 + 763) < (2861 - (12 + 5)))) then
					if (((48 + 41) < (11440 - 6950)) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
						return "judgment generators 16";
					end
				end
				v135 = 2 + 1;
			end
		end
	end
	local function v123()
		local v136 = 1093 - (277 + 816);
		while true do
			if ((v136 == (0 - 0)) or ((6166 - (1058 + 125)) < (339 + 1469))) then
				v34 = EpicSettings.Settings['swapAuras'];
				v35 = EpicSettings.Settings['useWeapon'];
				v36 = EpicSettings.Settings['useBladeofJustice'];
				v136 = 976 - (815 + 160);
			end
			if (((16428 - 12599) > (8946 - 5177)) and (v136 == (1 + 0))) then
				v37 = EpicSettings.Settings['useConsecration'];
				v38 = EpicSettings.Settings['useCrusaderStrike'];
				v39 = EpicSettings.Settings['useDivineHammer'];
				v136 = 5 - 3;
			end
			if (((3383 - (41 + 1857)) <= (4797 - (1222 + 671))) and (v136 == (7 - 4))) then
				v43 = EpicSettings.Settings['useHammerofWrath'];
				v44 = EpicSettings.Settings['useJudgment'];
				v45 = EpicSettings.Settings['useJusticarsVengeance'];
				v136 = 5 - 1;
			end
			if (((5451 - (229 + 953)) == (6043 - (1111 + 663))) and ((1584 - (874 + 705)) == v136)) then
				v49 = EpicSettings.Settings['useVerdict'];
				v50 = EpicSettings.Settings['useAvengingWrath'];
				v51 = EpicSettings.Settings['useCrusade'];
				v136 = 1 + 5;
			end
			if (((265 + 122) <= (5782 - 3000)) and (v136 == (1 + 3))) then
				v46 = EpicSettings.Settings['useTemplarSlash'];
				v47 = EpicSettings.Settings['useTemplarStrike'];
				v48 = EpicSettings.Settings['useWakeofAshes'];
				v136 = 684 - (642 + 37);
			end
			if ((v136 == (2 + 5)) or ((304 + 1595) <= (2302 - 1385))) then
				v55 = EpicSettings.Settings['crusadeWithCD'];
				v56 = EpicSettings.Settings['finalReckoningWithCD'];
				v57 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if ((v136 == (456 - (233 + 221))) or ((9970 - 5658) <= (772 + 104))) then
				v40 = EpicSettings.Settings['useDivineStorm'];
				v41 = EpicSettings.Settings['useDivineToll'];
				v42 = EpicSettings.Settings['useExecutionSentence'];
				v136 = 1544 - (718 + 823);
			end
			if (((1405 + 827) <= (3401 - (266 + 539))) and (v136 == (16 - 10))) then
				v52 = EpicSettings.Settings['useFinalReckoning'];
				v53 = EpicSettings.Settings['useShieldofVengeance'];
				v54 = EpicSettings.Settings['avengingWrathWithCD'];
				v136 = 1232 - (636 + 589);
			end
		end
	end
	local function v124()
		local v137 = 0 - 0;
		while true do
			if (((4320 - 2225) < (2922 + 764)) and (v137 == (2 + 1))) then
				v67 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v68 = EpicSettings.Settings['divineProtectionHP'] or (1015 - (657 + 358));
				v69 = EpicSettings.Settings['divineShieldHP'] or (0 - 0);
				v137 = 8 - 4;
			end
			if ((v137 == (1188 - (1151 + 36))) or ((1541 + 54) >= (1177 + 3297))) then
				v61 = EpicSettings.Settings['useDivineShield'];
				v62 = EpicSettings.Settings['useLayonHands'];
				v63 = EpicSettings.Settings['useLayonHandsFocus'];
				v137 = 5 - 3;
			end
			if ((v137 == (1836 - (1552 + 280))) or ((5453 - (64 + 770)) < (1957 + 925))) then
				v70 = EpicSettings.Settings['layonHandsHP'] or (0 - 0);
				v71 = EpicSettings.Settings['layonHandsFocusHP'] or (0 + 0);
				v72 = EpicSettings.Settings['wordofGloryFocusHP'] or (1243 - (157 + 1086));
				v137 = 10 - 5;
			end
			if ((v137 == (26 - 20)) or ((450 - 156) >= (6593 - 1762))) then
				v76 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v77 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v97 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if (((2848 - (599 + 220)) <= (6141 - 3057)) and ((1933 - (1813 + 118)) == v137)) then
				v64 = EpicSettings.Settings['useWordofGloryFocus'];
				v65 = EpicSettings.Settings['useWordofGloryMouseover'];
				v66 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v137 = 3 + 0;
			end
			if ((v137 == (1222 - (841 + 376))) or ((2854 - 817) == (563 + 1857))) then
				v73 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
				v74 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (859 - (464 + 395));
				v75 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 - 0);
				v137 = 3 + 3;
			end
			if (((5295 - (467 + 370)) > (8067 - 4163)) and (v137 == (0 + 0))) then
				v58 = EpicSettings.Settings['useRebuke'];
				v59 = EpicSettings.Settings['useHammerofJustice'];
				v60 = EpicSettings.Settings['useDivineProtection'];
				v137 = 3 - 2;
			end
		end
	end
	local function v125()
		local v138 = 0 + 0;
		while true do
			if (((1014 - 578) >= (643 - (150 + 370))) and (v138 == (1286 - (74 + 1208)))) then
				v81 = EpicSettings.Settings['HandleIncorporeal'];
				v95 = EpicSettings.Settings['HealOOC'];
				v96 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
				break;
			end
			if (((2371 - 1871) < (1293 + 523)) and (v138 == (390 - (14 + 376)))) then
				v85 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v82 = EpicSettings.Settings['InterruptWithStun'];
				v83 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v84 = EpicSettings.Settings['InterruptThreshold'];
				v138 = 1 + 0;
			end
			if (((3140 + 434) == (3409 + 165)) and (v138 == (2 - 1))) then
				v79 = EpicSettings.Settings['DispelDebuffs'];
				v78 = EpicSettings.Settings['DispelBuffs'];
				v86 = EpicSettings.Settings['useTrinkets'];
				v88 = EpicSettings.Settings['useRacials'];
				v138 = 2 + 0;
			end
			if (((299 - (23 + 55)) < (924 - 534)) and ((3 + 0) == v138)) then
				v93 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v92 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v94 = EpicSettings.Settings['HealingPotionName'] or "";
				v80 = EpicSettings.Settings['handleAfflicted'];
				v138 = 2 + 2;
			end
			if ((v138 == (903 - (652 + 249))) or ((5922 - 3709) <= (3289 - (708 + 1160)))) then
				v87 = EpicSettings.Settings['trinketsWithCD'];
				v89 = EpicSettings.Settings['racialsWithCD'];
				v91 = EpicSettings.Settings['useHealthstone'];
				v90 = EpicSettings.Settings['useHealingPotion'];
				v138 = 8 - 5;
			end
		end
	end
	local function v126()
		local v139 = 0 - 0;
		while true do
			if (((3085 - (10 + 17)) < (1092 + 3768)) and (v139 == (1734 - (1400 + 332)))) then
				v104 = v14:GetEnemiesInMeleeRange(15 - 7);
				if (v31 or ((3204 - (242 + 1666)) >= (1903 + 2543))) then
					v105 = #v104;
				else
					local v199 = 0 + 0;
					while true do
						if ((v199 == (0 + 0)) or ((2333 - (850 + 90)) > (7861 - 3372))) then
							v104 = {};
							v105 = 1391 - (360 + 1030);
							break;
						end
					end
				end
				if ((not v14:AffectingCombat() and v14:IsMounted()) or ((3916 + 508) < (76 - 49))) then
					if ((v99.CrusaderAura:IsCastable() and (v14:BuffDown(v99.CrusaderAura)) and v34) or ((2747 - 750) > (5476 - (909 + 752)))) then
						if (((4688 - (109 + 1114)) > (3502 - 1589)) and v24(v99.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				v108 = v112();
				v139 = 2 + 1;
			end
			if (((975 - (6 + 236)) < (1147 + 672)) and (v139 == (0 + 0))) then
				v124();
				v123();
				v125();
				v30 = EpicSettings.Toggles['ooc'];
				v139 = 2 - 1;
			end
			if ((v139 == (6 - 2)) or ((5528 - (1076 + 57)) == (782 + 3973))) then
				if (v14:AffectingCombat() or (v79 and v99.CleanseToxins:IsAvailable()) or ((4482 - (579 + 110)) < (188 + 2181))) then
					local v200 = 0 + 0;
					local v201;
					while true do
						if ((v200 == (0 + 0)) or ((4491 - (174 + 233)) == (740 - 475))) then
							v201 = v79 and v99.CleanseToxins:IsReady() and v33;
							v29 = v98.FocusUnit(v201, nil, 35 - 15, nil, 12 + 13, v99.FlashofLight);
							v200 = 1175 - (663 + 511);
						end
						if (((3888 + 470) == (947 + 3411)) and (v200 == (2 - 1))) then
							if (v29 or ((1901 + 1237) < (2337 - 1344))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((8061 - 4731) > (1109 + 1214)) and v33) then
					local v202 = 0 - 0;
					while true do
						if ((v202 == (1 + 0)) or ((332 + 3294) == (4711 - (478 + 244)))) then
							if ((v99.BlessingofFreedom:IsReady() and v98.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) or ((1433 - (440 + 77)) == (1215 + 1456))) then
								if (((995 - 723) == (1828 - (655 + 901))) and v24(v103.BlessingofFreedomFocus)) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if (((788 + 3461) <= (3705 + 1134)) and (v202 == (0 + 0))) then
							v29 = v98.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 161 - 121, 1470 - (695 + 750), v99.FlashofLight);
							if (((9482 - 6705) < (4938 - 1738)) and v29) then
								return v29;
							end
							v202 = 3 - 2;
						end
					end
				end
				if (((446 - (285 + 66)) < (4561 - 2604)) and (v98.TargetIsValid() or v14:AffectingCombat())) then
					local v203 = 1310 - (682 + 628);
					while true do
						if (((134 + 692) < (2016 - (176 + 123))) and (v203 == (0 + 0))) then
							v106 = v9.BossFightRemains(nil, true);
							v107 = v106;
							v203 = 1 + 0;
						end
						if (((1695 - (239 + 30)) >= (301 + 804)) and (v203 == (1 + 0))) then
							if (((4874 - 2120) <= (10541 - 7162)) and (v107 == (11426 - (306 + 9)))) then
								v107 = v9.FightRemains(v104, false);
							end
							v110 = v14:GCD();
							v203 = 6 - 4;
						end
						if ((v203 == (1 + 1)) or ((2410 + 1517) == (681 + 732))) then
							v109 = v14:HolyPower();
							break;
						end
					end
				end
				if (v80 or ((3299 - 2145) <= (2163 - (1140 + 235)))) then
					local v204 = 0 + 0;
					while true do
						if ((v204 == (0 + 0)) or ((422 + 1221) > (3431 - (33 + 19)))) then
							if (v76 or ((1013 + 1790) > (13634 - 9085))) then
								local v210 = 0 + 0;
								while true do
									if ((v210 == (0 - 0)) or ((207 + 13) >= (3711 - (586 + 103)))) then
										v29 = v98.HandleAfflicted(v99.CleanseToxins, v103.CleanseToxinsMouseover, 4 + 36);
										if (((8687 - 5865) == (4310 - (1309 + 179))) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							if ((v77 and (v109 > (2 - 0))) or ((462 + 599) == (4987 - 3130))) then
								local v211 = 0 + 0;
								while true do
									if (((5864 - 3104) > (2717 - 1353)) and ((609 - (295 + 314)) == v211)) then
										v29 = v98.HandleAfflicted(v99.WordofGlory, v103.WordofGloryMouseover, 98 - 58, true);
										if (v29 or ((6864 - (1300 + 662)) <= (11288 - 7693))) then
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
				v139 = 1760 - (1178 + 577);
			end
			if ((v139 == (1 + 0)) or ((11387 - 7535) == (1698 - (851 + 554)))) then
				v31 = EpicSettings.Toggles['aoe'];
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((1379 + 180) == (12724 - 8136))) then
					return v29;
				end
				v139 = 3 - 1;
			end
			if ((v139 == (307 - (115 + 187))) or ((3434 + 1050) == (746 + 42))) then
				if (((18000 - 13432) >= (5068 - (160 + 1001))) and v81) then
					local v205 = 0 + 0;
					while true do
						if (((860 + 386) < (7103 - 3633)) and ((358 - (237 + 121)) == v205)) then
							v29 = v98.HandleIncorporeal(v99.Repentance, v103.RepentanceMouseOver, 927 - (525 + 372), true);
							if (((7712 - 3644) >= (3193 - 2221)) and v29) then
								return v29;
							end
							v205 = 143 - (96 + 46);
						end
						if (((1270 - (643 + 134)) < (1406 + 2487)) and ((2 - 1) == v205)) then
							v29 = v98.HandleIncorporeal(v99.TurnEvil, v103.TurnEvilMouseOver, 111 - 81, true);
							if (v29 or ((1413 + 60) >= (6538 - 3206))) then
								return v29;
							end
							break;
						end
					end
				end
				v29 = v116();
				if (v29 or ((8280 - 4229) <= (1876 - (316 + 403)))) then
					return v29;
				end
				if (((402 + 202) < (7920 - 5039)) and v79 and v33) then
					if (v13 or ((326 + 574) == (8504 - 5127))) then
						local v207 = 0 + 0;
						while true do
							if (((1438 + 3021) > (2047 - 1456)) and ((0 - 0) == v207)) then
								v29 = v115();
								if (((7058 - 3660) >= (138 + 2257)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if ((v15 and v15:Exists() and not v14:CanAttack(v15) and (v98.UnitHasCurseDebuff(v15) or v98.UnitHasPoisonDebuff(v15))) or ((4297 - 2114) >= (138 + 2686))) then
						if (((5695 - 3759) == (1953 - (12 + 5))) and v99.CleanseToxins:IsReady()) then
							if (v24(v103.CleanseToxinsMouseover) or ((18767 - 13935) < (9201 - 4888))) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				v139 = 12 - 6;
			end
			if (((10137 - 6049) > (787 + 3087)) and (v139 == (1976 - (1656 + 317)))) then
				if (((3861 + 471) == (3472 + 860)) and not v14:AffectingCombat()) then
					if (((10633 - 6634) >= (14272 - 11372)) and v99.RetributionAura:IsCastable() and (v113()) and v34) then
						if (v24(v99.RetributionAura) or ((2879 - (5 + 349)) > (19303 - 15239))) then
							return "retribution_aura";
						end
					end
				end
				if (((5642 - (266 + 1005)) == (2881 + 1490)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
					if (v14:AffectingCombat() or ((907 - 641) > (6564 - 1578))) then
						if (((3687 - (561 + 1135)) >= (1204 - 279)) and v99.Intercession:IsCastable()) then
							if (((1495 - 1040) < (3119 - (507 + 559))) and v24(v99.Intercession, not v16:IsInRange(75 - 45), true)) then
								return "intercession target";
							end
						end
					elseif (v99.Redemption:IsCastable() or ((2554 - 1728) == (5239 - (212 + 176)))) then
						if (((1088 - (250 + 655)) == (498 - 315)) and v24(v99.Redemption, not v16:IsInRange(52 - 22), true)) then
							return "redemption target";
						end
					end
				end
				if (((1812 - 653) <= (3744 - (1869 + 87))) and v99.Redemption:IsCastable() and v99.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if (v24(v103.RedemptionMouseover) or ((12163 - 8656) > (6219 - (484 + 1417)))) then
						return "redemption mouseover";
					end
				end
				if (v14:AffectingCombat() or ((6590 - 3515) <= (4968 - 2003))) then
					if (((2138 - (48 + 725)) <= (3285 - 1274)) and v99.Intercession:IsCastable() and (v14:HolyPower() >= (7 - 4)) and v99.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
						if (v24(v103.IntercessionMouseover) or ((1614 + 1162) > (9553 - 5978))) then
							return "Intercession mouseover";
						end
					end
				end
				v139 = 2 + 2;
			end
			if ((v139 == (2 + 4)) or ((3407 - (152 + 701)) == (6115 - (430 + 881)))) then
				v29 = v117();
				if (((987 + 1590) == (3472 - (557 + 338))) and v29) then
					return v29;
				end
				if ((not v14:AffectingCombat() and v30 and v98.TargetIsValid()) or ((2 + 4) >= (5322 - 3433))) then
					local v206 = 0 - 0;
					while true do
						if (((1344 - 838) <= (4077 - 2185)) and (v206 == (801 - (499 + 302)))) then
							v29 = v119();
							if (v29 or ((2874 - (39 + 827)) > (6122 - 3904))) then
								return v29;
							end
							break;
						end
					end
				end
				if (((845 - 466) <= (16471 - 12324)) and v14:AffectingCombat() and v98.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					if ((v62 and (v14:HealthPercentage() <= v70) and v99.LayonHands:IsReady() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((6930 - 2416) <= (87 + 922))) then
						if (v24(v99.LayonHands) or ((10232 - 6736) == (191 + 1001))) then
							return "lay_on_hands_player defensive";
						end
					end
					if ((v61 and (v14:HealthPercentage() <= v69) and v99.DivineShield:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((328 - 120) == (3063 - (103 + 1)))) then
						if (((4831 - (475 + 79)) >= (2838 - 1525)) and v24(v99.DivineShield)) then
							return "divine_shield defensive";
						end
					end
					if (((8278 - 5691) < (411 + 2763)) and v60 and v99.DivineProtection:IsCastable() and (v14:HealthPercentage() <= v68)) then
						if (v24(v99.DivineProtection) or ((3626 + 494) <= (3701 - (1395 + 108)))) then
							return "divine_protection defensive";
						end
					end
					if ((v100.Healthstone:IsReady() and v91 and (v14:HealthPercentage() <= v93)) or ((4644 - 3048) == (2062 - (7 + 1197)))) then
						if (((1404 + 1816) == (1124 + 2096)) and v24(v103.Healthstone)) then
							return "healthstone defensive";
						end
					end
					if ((v90 and (v14:HealthPercentage() <= v92)) or ((1721 - (27 + 292)) > (10607 - 6987))) then
						local v208 = 0 - 0;
						while true do
							if (((10794 - 8220) == (5075 - 2501)) and (v208 == (0 - 0))) then
								if (((1937 - (43 + 96)) < (11246 - 8489)) and (v94 == "Refreshing Healing Potion")) then
									if (v100.RefreshingHealingPotion:IsReady() or ((851 - 474) > (2161 + 443))) then
										if (((161 + 407) < (1800 - 889)) and v24(v103.RefreshingHealingPotion)) then
											return "refreshing healing potion defensive";
										end
									end
								end
								if (((1259 + 2026) < (7923 - 3695)) and (v94 == "Dreamwalker's Healing Potion")) then
									if (((1233 + 2683) > (245 + 3083)) and v100.DreamwalkersHealingPotion:IsReady()) then
										if (((4251 - (1414 + 337)) < (5779 - (1642 + 298))) and v24(v103.RefreshingHealingPotion)) then
											return "dreamwalkers healing potion defensive";
										end
									end
								end
								break;
							end
						end
					end
					if (((1321 - 814) == (1458 - 951)) and (v85 < v107)) then
						local v209 = 0 - 0;
						while true do
							if (((79 + 161) <= (2463 + 702)) and (v209 == (972 - (357 + 615)))) then
								v29 = v120();
								if (((586 + 248) >= (1974 - 1169)) and v29) then
									return v29;
								end
								v209 = 1 + 0;
							end
							if ((v209 == (2 - 1)) or ((3049 + 763) < (158 + 2158))) then
								if ((v32 and v100.FyralathTheDreamrender:IsEquippedAndReady() and v35) or ((1667 + 985) <= (2834 - (384 + 917)))) then
									if (v24(v103.UseWeapon) or ((4295 - (128 + 569)) < (3003 - (1407 + 136)))) then
										return "Fyralath The Dreamrender used";
									end
								end
								break;
							end
						end
					end
					v29 = v122();
					if (v29 or ((6003 - (687 + 1200)) < (2902 - (556 + 1154)))) then
						return v29;
					end
					if (v24(v99.Pool) or ((11880 - 8503) <= (998 - (9 + 86)))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
		end
	end
	local function v127()
		local v140 = 421 - (275 + 146);
		while true do
			if (((647 + 3329) >= (503 - (29 + 35))) and (v140 == (0 - 0))) then
				v20.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v102();
				break;
			end
		end
	end
	v20.SetAPL(209 - 139, v126, v127);
end;
return v0["Epix_Paladin_Retribution.lua"]();

