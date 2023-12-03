local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((v5 == 0) or (696 > 2654)) then
			v6 = v0[v4];
			if ((372 <= 921) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((3699 < 4706) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0["Epix_Paladin_Retribution.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10['Unit'];
	local v13 = v10['Utils'];
	local v14 = v12['Focus'];
	local v15 = v12['Player'];
	local v16 = v12['MouseOver'];
	local v17 = v12['Target'];
	local v18 = v12['Pet'];
	local v19 = v10['Spell'];
	local v20 = v10['Item'];
	local v21 = EpicLib;
	local v22 = v21['Cast'];
	local v23 = v21['Bind'];
	local v24 = v21['Macro'];
	local v25 = v21['Press'];
	local v26 = v21['Commons']['Everyone']['num'];
	local v27 = v21['Commons']['Everyone']['bool'];
	local v28 = math['min'];
	local v29 = math['max'];
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
	local v95 = v21['Commons']['Everyone'];
	local v96 = v19['Paladin']['Retribution'];
	local v97 = v20['Paladin']['Retribution'];
	local v98 = {};
	local function v99()
		if ((2646 >= 876) and v96['CleanseToxins']:IsAvailable()) then
			v95['DispellableDebuffs'] = v13.MergeTable(v95.DispellableDiseaseDebuffs, v95.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v99();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v100 = v24['Paladin']['Retribution'];
	local v101;
	local v102;
	local v103 = 11111;
	local v104 = 11111;
	local v105;
	local v106 = 0;
	local v107 = 0;
	local v108;
	v10:RegisterForEvent(function()
		local v124 = 0;
		while true do
			if ((614 <= 3184) and (v124 == 0)) then
				v103 = 11111;
				v104 = 11111;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v109()
		local v125 = 0;
		local v126;
		local v127;
		while true do
			if ((3126 == 3126) and (v125 == 1)) then
				if ((v126 > v127) or (2187 >= 4954)) then
					return v126;
				end
				return v127;
			end
			if ((v125 == 0) or (3877 == 3575)) then
				v126 = v15:GCDRemains();
				v127 = v28(v96['CrusaderStrike']:CooldownRemains(), v96['BladeofJustice']:CooldownRemains(), v96['Judgment']:CooldownRemains(), (v96['HammerofWrath']:IsUsable() and v96['HammerofWrath']:CooldownRemains()) or 10, v96['WakeofAshes']:CooldownRemains());
				v125 = 1;
			end
		end
	end
	local function v110()
		return v15:BuffDown(v96.RetributionAura) and v15:BuffDown(v96.DevotionAura) and v15:BuffDown(v96.ConcentrationAura) and v15:BuffDown(v96.CrusaderAura);
	end
	local function v111()
		if ((707 > 632) and v96['CleanseToxins']:IsReady() and v34 and v95.DispellableFriendlyUnit(25)) then
			if (v25(v100.CleanseToxinsFocus) or (546 >= 2684)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v112()
		if ((1465 <= 4301) and v92 and (v15:HealthPercentage() <= v93)) then
			if ((1704 > 1425) and v96['FlashofLight']:IsReady()) then
				if (v25(v96.FlashofLight) or (687 == 4234)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v113()
		local v128 = 0;
		while true do
			if ((v128 == 0) or (3330 < 1429)) then
				if ((1147 >= 335) and (not v14 or not v14:Exists() or not v14:IsInRange(30))) then
					return;
				end
				if ((3435 > 2097) and v14) then
					local v194 = 0;
					while true do
						if ((v194 == 1) or (3770 >= 4041)) then
							if ((v96['BlessingofSacrifice']:IsCastable() and v65 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v72)) or (3791 <= 1611)) then
								if (v25(v100.BlessingofSacrificeFocus) or (4578 <= 2008)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((1125 <= 2076) and v96['BlessingofProtection']:IsCastable() and v64 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v71)) then
								if (v25(v100.BlessingofProtectionFocus) or (743 >= 4399)) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if ((1155 < 1673) and (0 == v194)) then
							if ((v96['WordofGlory']:IsReady() and v63 and (v14:HealthPercentage() <= v70)) or (2324 <= 578)) then
								if ((3767 == 3767) and v25(v100.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if ((4089 == 4089) and v96['LayonHands']:IsCastable() and v62 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v69)) then
								if ((4458 >= 1674) and v25(v100.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v194 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v114()
		local v129 = 0;
		while true do
			if ((972 <= 1418) and (v129 == 1)) then
				v30 = v95.HandleBottomTrinket(v98, v33, 40, nil);
				if (v30 or (4938 < 4762)) then
					return v30;
				end
				break;
			end
			if ((v129 == 0) or (2504 > 4264)) then
				v30 = v95.HandleTopTrinket(v98, v33, 40, nil);
				if ((2153 == 2153) and v30) then
					return v30;
				end
				v129 = 1;
			end
		end
	end
	local function v115()
		local v130 = 0;
		while true do
			if ((v130 == 1) or (507 >= 2591)) then
				if ((4481 == 4481) and v96['FinalVerdict']:IsAvailable() and v96['FinalVerdict']:IsReady() and v48 and (v106 >= 4)) then
					if (v25(v96.FinalVerdict, not v17:IsSpellInRange(v96.FinalVerdict)) or (2328 < 693)) then
						return "final verdict precombat 3";
					end
				end
				if ((4328 == 4328) and v96['TemplarsVerdict']:IsReady() and v48 and (v106 >= 4)) then
					if ((1588 >= 1332) and v25(v96.TemplarsVerdict, not v17:IsSpellInRange(v96.TemplarsVerdict))) then
						return "templars verdict precombat 4";
					end
				end
				v130 = 2;
			end
			if ((v130 == 3) or (4174 > 4248)) then
				if ((v96['HammerofWrath']:IsReady() and v42) or (4586 <= 82)) then
					if ((3863 == 3863) and v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				if ((v96['CrusaderStrike']:IsCastable() and v37) or (282 <= 42)) then
					if ((4609 >= 766) and v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v130 == 2) or (1152 == 2488)) then
				if ((3422 > 3350) and v96['BladeofJustice']:IsCastable() and v35) then
					if ((877 > 376) and v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice))) then
						return "blade_of_justice precombat 5";
					end
				end
				if ((v96['Judgment']:IsCastable() and v43) or (3118 <= 1851)) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or (165 >= 3492)) then
						return "judgment precombat 6";
					end
				end
				v130 = 3;
			end
			if ((3949 < 4856) and (v130 == 0)) then
				if ((v96['ShieldofVengeance']:IsCastable() and v52 and ((v33 and v56) or not v56)) or (4276 < 3016)) then
					if ((4690 > 4125) and v25(v96.ShieldofVengeance)) then
						return "shield_of_vengeance precombat 1";
					end
				end
				if ((v96['JusticarsVengeance']:IsAvailable() and v96['JusticarsVengeance']:IsReady() and v44 and (v106 >= 4)) or (50 >= 896)) then
					if (v25(v96.JusticarsVengeance, not v17:IsSpellInRange(v96.JusticarsVengeance)) or (1714 >= 2958)) then
						return "juscticars vengeance precombat 2";
					end
				end
				v130 = 1;
			end
		end
	end
	local function v116()
		local v131 = 0;
		local v132;
		while true do
			if ((0 == v131) or (1491 < 644)) then
				v132 = v95.HandleDPSPotion(v15:BuffUp(v96.AvengingWrathBuff) or (v15:BuffUp(v96.CrusadeBuff) and (v15.BuffStack(v96.Crusade) == 10)) or (v104 < 25));
				if ((704 < 987) and v132) then
					return v132;
				end
				v131 = 1;
			end
			if ((3718 > 1906) and (v131 == 2)) then
				if ((v83 and ((v33 and v84) or not v84) and v17:IsInRange(8)) or (958 > 3635)) then
					local v195 = 0;
					while true do
						if ((3501 <= 4492) and (v195 == 0)) then
							v30 = v114();
							if (v30 or (3442 < 2548)) then
								return v30;
							end
							break;
						end
					end
				end
				if ((2875 >= 1464) and v96['ShieldofVengeance']:IsCastable() and v52 and ((v33 and v56) or not v56) and (v104 > 15) and (not v96['ExecutionSentence']:IsAvailable() or v17:DebuffDown(v96.ExecutionSentence))) then
					if (v25(v96.ShieldofVengeance) or (4797 >= 4893)) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v131 = 3;
			end
			if ((v131 == 4) or (551 > 2068)) then
				if ((2114 > 944) and v96['Crusade']:IsCastable() and v50 and ((v33 and v54) or not v54) and (((v106 >= 4) and (v10.CombatTime() < 5)) or ((v106 >= 3) and (v10.CombatTime() >= 5)))) then
					if (v25(v96.Crusade, not v17:IsInRange(10)) or (2262 >= 3096)) then
						return "crusade cooldowns 14";
					end
				end
				if ((v96['FinalReckoning']:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v106 >= 4) and (v10.CombatTime() < 8)) or ((v106 >= 3) and (v10.CombatTime() >= 8)) or ((v106 >= 2) and v96['DivineAuxiliary']:IsAvailable())) and ((v96['AvengingWrath']:CooldownRemains() > 10) or (v96['Crusade']:CooldownDown() and (v15:BuffDown(v96.CrusadeBuff) or (v15:BuffStack(v96.CrusadeBuff) >= 10)))) and ((v105 > 0) or (v106 == 5) or ((v106 >= 2) and v96['DivineAuxiliary']:IsAvailable()))) or (2255 >= 3537)) then
					local v196 = 0;
					while true do
						if ((v196 == 0) or (3837 < 1306)) then
							if ((2950 == 2950) and (v94 == "player")) then
								if (v25(v100.FinalReckoningPlayer, not v17:IsInRange(10)) or (4723 < 3298)) then
									return "final_reckoning cooldowns 18";
								end
							end
							if ((1136 >= 154) and (v94 == "cursor")) then
								if (v25(v100.FinalReckoningCursor, not v17:IsInRange(20)) or (271 > 4748)) then
									return "final_reckoning cooldowns 18";
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((4740 >= 3152) and (v131 == 3)) then
				if ((v96['ExecutionSentence']:IsCastable() and v41 and ((v15:BuffDown(v96.CrusadeBuff) and (v96['Crusade']:CooldownRemains() > 15)) or (v15:BuffStack(v96.CrusadeBuff) == 10) or (v96['AvengingWrath']:CooldownRemains() < 0.75) or (v96['AvengingWrath']:CooldownRemains() > 15)) and (((v106 >= 4) and (v10.CombatTime() < 5)) or ((v106 >= 3) and (v10.CombatTime() > 5)) or ((v106 >= 2) and v96['DivineAuxiliary']:IsAvailable())) and (((v104 > 8) and not v96['ExecutionersWill']:IsAvailable()) or (v104 > 12))) or (2578 >= 3390)) then
					if ((41 <= 1661) and v25(v96.ExecutionSentence, not v17:IsSpellInRange(v96.ExecutionSentence))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if ((601 < 3560) and v96['AvengingWrath']:IsCastable() and v49 and ((v33 and v53) or not v53) and (((v106 >= 4) and (v10.CombatTime() < 5)) or ((v106 >= 3) and (v10.CombatTime() > 5)) or ((v106 >= 2) and v96['DivineAuxiliary']:IsAvailable() and (v96['ExecutionSentence']:CooldownUp() or v96['FinalReckoning']:CooldownUp())))) then
					if ((235 < 687) and v25(v96.AvengingWrath, not v17:IsInRange(10))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v131 = 4;
			end
			if ((4549 > 1153) and (v131 == 1)) then
				if ((v96['LightsJudgment']:IsCastable() and v85 and ((v86 and v33) or not v86)) or (4674 < 4672)) then
					if ((3668 < 4561) and v25(v96.LightsJudgment, not v17:IsInRange(40))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v96['Fireblood']:IsCastable() and v85 and ((v86 and v33) or not v86) and (v15:BuffUp(v96.AvengingWrathBuff) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) == 10)))) or (455 == 3605)) then
					if (v25(v96.Fireblood, not v17:IsInRange(10)) or (2663 == 3312)) then
						return "fireblood cooldowns 6";
					end
				end
				v131 = 2;
			end
		end
	end
	local function v117()
		local v133 = 0;
		while true do
			if ((4277 <= 4475) and (v133 == 2)) then
				if ((v96['TemplarsVerdict']:IsReady() and v48 and (not v96['Crusade']:IsAvailable() or (v96['Crusade']:CooldownRemains() > (v107 * 3)) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)))) or (870 == 1189)) then
					if ((1553 <= 3133) and v25(v96.TemplarsVerdict, not v17:IsSpellInRange(v96.TemplarsVerdict))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
			if ((v133 == 0) or (2237 >= 3511)) then
				v108 = ((v102 >= 3) or ((v102 >= 2) and not v96['DivineArbiter']:IsAvailable()) or v15:BuffUp(v96.EmpyreanPowerBuff)) and v15:BuffDown(v96.EmpyreanLegacyBuff) and not (v15:BuffUp(v96.DivineArbiterBuff) and (v15:BuffStack(v96.DivineArbiterBuff) > 24));
				if ((v96['DivineStorm']:IsReady() and v39 and v108 and (not v96['Crusade']:IsAvailable() or (v96['Crusade']:CooldownRemains() > (v107 * 3)) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)))) or (1324 > 3020)) then
					if (v25(v96.DivineStorm, not v17:IsInRange(10)) or (2992 == 1881)) then
						return "divine_storm finishers 2";
					end
				end
				v133 = 1;
			end
			if ((3106 > 1526) and (v133 == 1)) then
				if ((3023 < 3870) and v96['JusticarsVengeance']:IsReady() and v44 and (not v96['Crusade']:IsAvailable() or (v96['Crusade']:CooldownRemains() > (v107 * 3)) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)))) then
					if ((143 > 74) and v25(v96.JusticarsVengeance, not v17:IsSpellInRange(v96.JusticarsVengeance))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if ((18 < 2112) and v96['FinalVerdict']:IsAvailable() and v96['FinalVerdict']:IsCastable() and v48 and (not v96['Crusade']:IsAvailable() or (v96['Crusade']:CooldownRemains() > (v107 * 3)) or (v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)))) then
					if ((1097 <= 1628) and v25(v96.FinalVerdict, not v17:IsSpellInRange(v96.FinalVerdict))) then
						return "final verdict finishers 6";
					end
				end
				v133 = 2;
			end
		end
	end
	local function v118()
		local v134 = 0;
		while true do
			if ((4630 == 4630) and (v134 == 3)) then
				if ((3540 > 2683) and v96['TemplarSlash']:IsReady() and v45 and ((v96['TemplarStrike']:TimeSinceLastCast() + v107) < 4)) then
					if ((4794 >= 3275) and v25(v96.TemplarSlash, not v17:IsSpellInRange(v96.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if ((1484 == 1484) and v96['Judgment']:IsReady() and v43 and v17:DebuffDown(v96.JudgmentDebuff) and ((v106 <= 3) or not v96['BoundlessJudgment']:IsAvailable())) then
					if ((1432 < 3555) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment generators 16";
					end
				end
				if ((v96['BladeofJustice']:IsCastable() and v35 and ((v106 <= 3) or not v96['HolyBlade']:IsAvailable())) or (1065 > 3578)) then
					if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or (4795 < 1407)) then
						return "blade_of_justice generators 18";
					end
				end
				v134 = 4;
			end
			if ((1853 < 4813) and (v134 == 7)) then
				if ((v96['Judgment']:IsReady() and v43 and ((v106 <= 3) or not v96['BoundlessJudgment']:IsAvailable())) or (2821 < 2431)) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or (2874 < 2181)) then
						return "judgment generators 32";
					end
				end
				if ((v96['HammerofWrath']:IsReady() and v42 and ((v106 <= 3) or (v17:HealthPercentage() > 20) or not v96['VanguardsMomentum']:IsAvailable())) or (2689 <= 343)) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or (1869 == 2009)) then
						return "hammer_of_wrath generators 34";
					end
				end
				if ((v96['CrusaderStrike']:IsCastable() and v37) or (3546 < 2322)) then
					if (v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike)) or (2082 == 4773)) then
						return "crusader_strike generators 26";
					end
				end
				v134 = 8;
			end
			if ((3244 > 1055) and (v134 == 4)) then
				if ((v96['Judgment']:IsReady() and v43 and v17:DebuffDown(v96.JudgmentDebuff) and ((v106 <= 3) or not v96['BoundlessJudgment']:IsAvailable())) or (3313 <= 1778)) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or (1421 >= 2104)) then
						return "judgment generators 20";
					end
				end
				if ((1812 <= 3249) and ((v17:HealthPercentage() <= 20) or v15:BuffUp(v96.AvengingWrathBuff) or v15:BuffUp(v96.CrusadeBuff) or v15:BuffUp(v96.EmpyreanPowerBuff))) then
					local v197 = 0;
					while true do
						if ((1623 <= 1957) and (0 == v197)) then
							v30 = v117();
							if ((4412 == 4412) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((1750 >= 842) and v96['Consecration']:IsCastable() and v36 and v17:DebuffDown(v96.ConsecrationDebuff) and (v102 >= 2)) then
					if ((4372 > 1850) and v25(v96.Consecration, not v17:IsInRange(10))) then
						return "consecration generators 22";
					end
				end
				v134 = 5;
			end
			if ((232 < 821) and (v134 == 8)) then
				if ((518 < 902) and v96['ArcaneTorrent']:IsCastable() and ((v86 and v33) or not v86) and v85 and (v106 < 5) and (v82 < v104)) then
					if ((2994 > 858) and v25(v96.ArcaneTorrent, not v17:IsInRange(10))) then
						return "arcane_torrent generators 28";
					end
				end
				if ((v96['Consecration']:IsCastable() and v36) or (3755 <= 915)) then
					if ((3946 > 3743) and v25(v96.Consecration, not v17:IsInRange(10))) then
						return "consecration generators 30";
					end
				end
				if ((v96['DivineHammer']:IsCastable() and v38) or (1335 >= 3306)) then
					if ((4844 > 2253) and v25(v96.DivineHammer, not v17:IsInRange(10))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if ((452 == 452) and (v134 == 2)) then
				if ((v96['TemplarSlash']:IsReady() and v45 and ((v96['TemplarStrike']:TimeSinceLastCast() + v107) < 4) and (v102 >= 2)) or (4557 < 2087)) then
					if ((3874 == 3874) and v25(v96.TemplarSlash, not v17:IsInRange(10))) then
						return "templar_slash generators 8";
					end
				end
				if ((v96['BladeofJustice']:IsCastable() and v35 and ((v106 <= 3) or not v96['HolyBlade']:IsAvailable()) and (((v102 >= 2) and not v96['CrusadingStrikes']:IsAvailable()) or (v102 >= 4))) or (1938 > 4935)) then
					if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or (4255 < 3423)) then
						return "blade_of_justice generators 10";
					end
				end
				if ((1454 <= 2491) and v96['HammerofWrath']:IsReady() and v42 and ((v102 < 2) or not v96['BlessedChampion']:IsAvailable() or v15:HasTier(30, 4)) and ((v106 <= 3) or (v17:HealthPercentage() > 20) or not v96['VanguardsMomentum']:IsAvailable())) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or (4157 <= 2803)) then
						return "hammer_of_wrath generators 12";
					end
				end
				v134 = 3;
			end
			if ((4853 >= 2982) and (v134 == 5)) then
				if ((4134 > 3357) and v96['DivineHammer']:IsCastable() and v38 and (v102 >= 2)) then
					if (v25(v96.DivineHammer, not v17:IsInRange(10)) or (3417 < 2534)) then
						return "divine_hammer generators 24";
					end
				end
				if ((v96['CrusaderStrike']:IsCastable() and v37 and (v96['CrusaderStrike']:ChargesFractional() >= 1.75) and ((v106 <= 2) or ((v106 <= 3) and (v96['BladeofJustice']:CooldownRemains() > (v107 * 2))) or ((v106 == 4) and (v96['BladeofJustice']:CooldownRemains() > (v107 * 2)) and (v96['Judgment']:CooldownRemains() > (v107 * 2))))) or (2722 <= 164)) then
					if (v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike)) or (2408 < 2109)) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v117();
				v134 = 6;
			end
			if ((v134 == 1) or (33 == 1455)) then
				if ((v96['DivineToll']:IsCastable() and v40 and (v106 <= 2) and ((v96['AvengingWrath']:CooldownRemains() > 15) or (v96['Crusade']:CooldownRemains() > 15) or (v104 < 8))) or (443 >= 4015)) then
					if ((3382 > 166) and v25(v96.DivineToll, not v17:IsInRange(30))) then
						return "divine_toll generators 6";
					end
				end
				if ((v96['Judgment']:IsReady() and v43 and v17:DebuffUp(v96.ExpurgationDebuff) and v15:BuffDown(v96.EchoesofWrathBuff) and v15:HasTier(31, 2)) or (280 == 3059)) then
					if ((1881 > 1293) and v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment generators 7";
					end
				end
				if ((2357 == 2357) and (v106 >= 3) and v15:BuffUp(v96.CrusadeBuff) and (v15:BuffStack(v96.CrusadeBuff) < 10)) then
					local v198 = 0;
					while true do
						if ((123 == 123) and (v198 == 0)) then
							v30 = v117();
							if (v30 or (1056 >= 3392)) then
								return v30;
							end
							break;
						end
					end
				end
				v134 = 2;
			end
			if ((v134 == 0) or (1081 < 1075)) then
				if ((v106 >= 5) or (v15:BuffUp(v96.EchoesofWrathBuff) and v15:HasTier(31, 4) and v96['CrusadingStrikes']:IsAvailable()) or ((v17:DebuffUp(v96.JudgmentDebuff) or (v106 == 4)) and v15:BuffUp(v96.DivineResonanceBuff) and not v15:HasTier(31, 2)) or (1049 >= 4432)) then
					local v199 = 0;
					while true do
						if ((v199 == 0) or (4768 <= 846)) then
							v30 = v117();
							if (v30 or (3358 <= 1420)) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v96['WakeofAshes']:IsCastable() and v47 and (v106 <= 2) and (v96['AvengingWrath']:CooldownDown() or v96['Crusade']:CooldownDown()) and (not v96['ExecutionSentence']:IsAvailable() or (v96['ExecutionSentence']:CooldownRemains() > 4) or (v104 < 8))) or (3739 <= 3005)) then
					if (v25(v96.WakeofAshes, not v17:IsInRange(10)) or (1659 >= 2134)) then
						return "wake_of_ashes generators 2";
					end
				end
				if ((v96['BladeofJustice']:IsCastable() and v35 and not v17:DebuffUp(v96.ExpurgationDebuff) and (v106 <= 3) and v15:HasTier(31, 2)) or (3260 < 2355)) then
					if (v25(v96.BladeofJustice, not v17:IsSpellInRange(v96.BladeofJustice)) or (669 == 4223)) then
						return "blade_of_justice generators 4";
					end
				end
				v134 = 1;
			end
			if ((v134 == 6) or (1692 < 588)) then
				if (v30 or (4797 < 3651)) then
					return v30;
				end
				if ((v96['TemplarSlash']:IsReady() and v45) or (4177 > 4850)) then
					if (v25(v96.TemplarSlash, not v17:IsInRange(10)) or (400 > 1111)) then
						return "templar_slash generators 28";
					end
				end
				if ((3051 > 1005) and v96['TemplarStrike']:IsReady() and v46) then
					if ((3693 <= 4382) and v25(v96.TemplarStrike, not v17:IsInRange(10))) then
						return "templar_strike generators 30";
					end
				end
				v134 = 7;
			end
		end
	end
	local function v119()
		local v135 = 0;
		while true do
			if ((v135 == 3) or (3282 > 4100)) then
				v47 = EpicSettings['Settings']['useWakeofAshes'];
				v48 = EpicSettings['Settings']['useVerdict'];
				v49 = EpicSettings['Settings']['useAvengingWrath'];
				v50 = EpicSettings['Settings']['useCrusade'];
				v135 = 4;
			end
			if ((2 == v135) or (3580 < 2844)) then
				v43 = EpicSettings['Settings']['useJudgment'];
				v44 = EpicSettings['Settings']['useJusticarsVengeance'];
				v45 = EpicSettings['Settings']['useTemplarSlash'];
				v46 = EpicSettings['Settings']['useTemplarStrike'];
				v135 = 3;
			end
			if ((89 < 4490) and (v135 == 1)) then
				v39 = EpicSettings['Settings']['useDivineStorm'];
				v40 = EpicSettings['Settings']['useDivineToll'];
				v41 = EpicSettings['Settings']['useExecutionSentence'];
				v42 = EpicSettings['Settings']['useHammerofWrath'];
				v135 = 2;
			end
			if ((v135 == 5) or (4983 < 1808)) then
				v55 = EpicSettings['Settings']['finalReckoningWithCD'];
				v56 = EpicSettings['Settings']['shieldofVengeanceWithCD'];
				break;
			end
			if ((3829 > 3769) and (v135 == 0)) then
				v35 = EpicSettings['Settings']['useBladeofJustice'];
				v36 = EpicSettings['Settings']['useConsecration'];
				v37 = EpicSettings['Settings']['useCrusaderStrike'];
				v38 = EpicSettings['Settings']['useDivineHammer'];
				v135 = 1;
			end
			if ((1485 <= 2904) and (4 == v135)) then
				v51 = EpicSettings['Settings']['useFinalReckoning'];
				v52 = EpicSettings['Settings']['useShieldofVengeance'];
				v53 = EpicSettings['Settings']['avengingWrathWithCD'];
				v54 = EpicSettings['Settings']['crusadeWithCD'];
				v135 = 5;
			end
		end
	end
	local function v120()
		local v136 = 0;
		while true do
			if ((4269 == 4269) and (1 == v136)) then
				v61 = EpicSettings['Settings']['useLayonHands'];
				v62 = EpicSettings['Settings']['useLayonHandsFocus'];
				v63 = EpicSettings['Settings']['useWordofGloryFocus'];
				v64 = EpicSettings['Settings']['useBlessingOfProtectionFocus'];
				v136 = 2;
			end
			if ((387 <= 2782) and (v136 == 4)) then
				v73 = EpicSettings['Settings']['useCleanseToxinsWithAfflicted'];
				v74 = EpicSettings['Settings']['useWordofGloryWithAfflicted'];
				v94 = EpicSettings['Settings']['finalReckoningSetting'] or "";
				break;
			end
			if ((v136 == 0) or (1899 <= 917)) then
				v57 = EpicSettings['Settings']['useRebuke'];
				v58 = EpicSettings['Settings']['useHammerofJustice'];
				v59 = EpicSettings['Settings']['useDivineProtection'];
				v60 = EpicSettings['Settings']['useDivineShield'];
				v136 = 1;
			end
			if ((v136 == 2) or (4312 <= 876)) then
				v65 = EpicSettings['Settings']['useBlessingOfSacrificeFocus'];
				v66 = EpicSettings['Settings']['divineProtectionHP'] or 0;
				v67 = EpicSettings['Settings']['divineShieldHP'] or 0;
				v68 = EpicSettings['Settings']['layonHandsHP'] or 0;
				v136 = 3;
			end
			if ((2232 <= 2596) and (v136 == 3)) then
				v69 = EpicSettings['Settings']['layonHandsFocusHP'] or 0;
				v70 = EpicSettings['Settings']['wordofGloryFocusHP'] or 0;
				v71 = EpicSettings['Settings']['blessingofProtectionFocusHP'] or 0;
				v72 = EpicSettings['Settings']['blessingofSacrificeFocusHP'] or 0;
				v136 = 4;
			end
		end
	end
	local function v121()
		local v137 = 0;
		while true do
			if ((2095 < 3686) and (v137 == 6)) then
				v93 = EpicSettings['Settings']['HealOOCHP'] or 0;
				break;
			end
			if ((v137 == 1) or (1595 >= 4474)) then
				v81 = EpicSettings['Settings']['InterruptThreshold'];
				v76 = EpicSettings['Settings']['DispelDebuffs'];
				v75 = EpicSettings['Settings']['DispelBuffs'];
				v137 = 2;
			end
			if ((v137 == 3) or (4619 < 2882)) then
				v86 = EpicSettings['Settings']['racialsWithCD'];
				v88 = EpicSettings['Settings']['useHealthstone'];
				v87 = EpicSettings['Settings']['useHealingPotion'];
				v137 = 4;
			end
			if ((v137 == 2) or (294 >= 4831)) then
				v83 = EpicSettings['Settings']['useTrinkets'];
				v85 = EpicSettings['Settings']['useRacials'];
				v84 = EpicSettings['Settings']['trinketsWithCD'];
				v137 = 3;
			end
			if ((2029 <= 3084) and (v137 == 5)) then
				v77 = EpicSettings['Settings']['handleAfflicted'];
				v78 = EpicSettings['Settings']['HandleIncorporeal'];
				v92 = EpicSettings['Settings']['HealOOC'];
				v137 = 6;
			end
			if ((v137 == 4) or (2037 == 2420)) then
				v90 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v89 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v91 = EpicSettings['Settings']['HealingPotionName'] or "";
				v137 = 5;
			end
			if ((4458 > 3904) and (v137 == 0)) then
				v82 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v79 = EpicSettings['Settings']['InterruptWithStun'];
				v80 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v137 = 1;
			end
		end
	end
	local function v122()
		local v138 = 0;
		local v139;
		while true do
			if ((436 >= 123) and (v138 == 4)) then
				if ((500 < 1816) and not v15:AffectingCombat()) then
					if ((3574 == 3574) and v96['RetributionAura']:IsCastable() and (v110())) then
						if ((221 < 390) and v25(v96.RetributionAura)) then
							return "retribution_aura";
						end
					end
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or (2213 <= 1421)) then
					if ((3058 < 4860) and v15:AffectingCombat()) then
						if (v96['Intercession']:IsCastable() or (1296 >= 4446)) then
							if (v25(v96.Intercession, not v17:IsInRange(30), true) or (1393 > 4489)) then
								return "intercession target";
							end
						end
					elseif (v96['Redemption']:IsCastable() or (4424 < 27)) then
						if (v25(v96.Redemption, not v17:IsInRange(30), true) or (1997 > 3815)) then
							return "redemption target";
						end
					end
				end
				if ((3465 > 1913) and v96['Redemption']:IsCastable() and v96['Redemption']:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if ((733 < 1819) and v25(v100.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or (4395 == 4755)) then
					if ((v96['Intercession']:IsCastable() and (v15:HolyPower() >= 3) and v96['Intercession']:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or (3793 < 2369)) then
						if (v25(v100.IntercessionMouseover) or (4084 == 265)) then
							return "Intercession mouseover";
						end
					end
				end
				v138 = 5;
			end
			if ((4358 == 4358) and (v138 == 7)) then
				if ((not v15:AffectingCombat() and v31 and v95.TargetIsValid()) or (3138 < 993)) then
					local v200 = 0;
					while true do
						if ((3330 > 2323) and (v200 == 0)) then
							v139 = v115();
							if (v139 or (3626 == 3989)) then
								return v139;
							end
							break;
						end
					end
				end
				if ((v15:AffectingCombat() and v95.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) or (916 == 2671)) then
					local v201 = 0;
					while true do
						if ((272 == 272) and (v201 == 2)) then
							if ((4249 <= 4839) and v87 and (v15:HealthPercentage() <= v89)) then
								local v209 = 0;
								while true do
									if ((2777 < 3200) and (v209 == 0)) then
										if ((95 < 1957) and (v91 == "Refreshing Healing Potion")) then
											if ((826 < 1717) and v97['RefreshingHealingPotion']:IsReady()) then
												if ((1426 >= 1105) and v25(v100.RefreshingHealingPotion)) then
													return "refreshing healing potion defensive";
												end
											end
										end
										if ((2754 <= 3379) and (v91 == "Dreamwalker's Healing Potion")) then
											if (v97['DreamwalkersHealingPotion']:IsReady() or (3927 == 1413)) then
												if (v25(v100.RefreshingHealingPotion) or (1154 <= 788)) then
													return "dreamwalkers healing potion defensive";
												end
											end
										end
										break;
									end
								end
							end
							if ((v82 < v104) or (1643 > 3379)) then
								local v210 = 0;
								while true do
									if ((v210 == 0) or (2803 > 4549)) then
										v139 = v116();
										if (v139 or (220 >= 3022)) then
											return v139;
										end
										break;
									end
								end
							end
							v201 = 3;
						end
						if ((2822 == 2822) and (v201 == 4)) then
							if (v25(v96.Pool) or (1061 == 1857)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((2760 > 1364) and (v201 == 0)) then
							if ((UseLayOnHands and (v15:HealthPercentage() <= v68) and v96['LayonHands']:IsReady() and v15:DebuffDown(v96.ForbearanceDebuff)) or (4902 <= 3595)) then
								if (v25(v96.LayonHands) or (3852 == 293)) then
									return "lay_on_hands_player defensive";
								end
							end
							if ((v60 and (v15:HealthPercentage() <= v67) and v96['DivineShield']:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) or (1559 == 4588)) then
								if (v25(v96.DivineShield) or (4484 == 788)) then
									return "divine_shield defensive";
								end
							end
							v201 = 1;
						end
						if ((4568 >= 3907) and (1 == v201)) then
							if ((1246 < 3470) and v59 and v96['DivineProtection']:IsCastable() and (v15:HealthPercentage() <= v66)) then
								if ((4068 >= 972) and v25(v96.DivineProtection)) then
									return "divine_protection defensive";
								end
							end
							if ((493 < 3893) and v97['Healthstone']:IsReady() and v88 and (v15:HealthPercentage() <= v90)) then
								if (v25(v100.Healthstone) or (1473 >= 3332)) then
									return "healthstone defensive";
								end
							end
							v201 = 2;
						end
						if ((v201 == 3) or (4051 <= 1157)) then
							v139 = v118();
							if ((604 < 2881) and v139) then
								return v139;
							end
							v201 = 4;
						end
					end
				end
				break;
			end
			if ((0 == v138) or (900 == 3377)) then
				v120();
				v119();
				v121();
				v31 = EpicSettings['Toggles']['ooc'];
				v138 = 1;
			end
			if ((4459 > 591) and (v138 == 3)) then
				v139 = v95.FocusUnitWithDebuffFromList(v19['Paladin'].FreedomDebuffList, 40, 25);
				if ((3398 >= 2395) and v139) then
					return v139;
				end
				if ((v96['BlessingofFreedom']:IsReady() and v95.UnitHasDebuffFromList(v14, v19['Paladin'].FreedomDebuffList)) or (2183 >= 2824)) then
					if ((1936 == 1936) and v25(v100.BlessingofFreedomFocus)) then
						return "blessing_of_freedom combat";
					end
				end
				v105 = v109();
				v138 = 4;
			end
			if ((v138 == 6) or (4832 < 4313)) then
				if ((4088 > 3874) and v139) then
					return v139;
				end
				if ((4332 == 4332) and v14) then
					if ((3999 >= 2900) and v76) then
						local v208 = 0;
						while true do
							if ((v208 == 0) or (2525 > 4064)) then
								v139 = v111();
								if ((4371 == 4371) and v139) then
									return v139;
								end
								break;
							end
						end
					end
				end
				v139 = v113();
				if (v139 or (266 > 4986)) then
					return v139;
				end
				v138 = 7;
			end
			if ((1991 >= 925) and (2 == v138)) then
				v101 = v15:GetEnemiesInMeleeRange(10);
				if ((455 < 2053) and v32) then
					v102 = #v101;
				else
					local v202 = 0;
					while true do
						if ((v202 == 0) or (826 == 4851)) then
							v101 = {};
							v102 = 1;
							break;
						end
					end
				end
				if ((183 == 183) and not v15:AffectingCombat() and v15:IsMounted()) then
					if ((1159 <= 1788) and v96['CrusaderAura']:IsCastable() and (v15:BuffDown(v96.CrusaderAura))) then
						if (v25(v96.CrusaderAura) or (3507 > 4318)) then
							return "crusader_aura";
						end
					end
				end
				if (v15:AffectingCombat() or v76 or (3075 <= 2965)) then
					local v203 = 0;
					local v204;
					while true do
						if ((1365 <= 2011) and (v203 == 0)) then
							v204 = v76 and v96['CleanseToxins']:IsReady() and v34;
							v139 = v95.FocusUnit(v204, v100, 20, nil, 25);
							v203 = 1;
						end
						if ((v203 == 1) or (2776 > 3575)) then
							if (v139 or (2554 == 4804)) then
								return v139;
							end
							break;
						end
					end
				end
				v138 = 3;
			end
			if ((2577 == 2577) and (v138 == 1)) then
				v32 = EpicSettings['Toggles']['aoe'];
				v33 = EpicSettings['Toggles']['cds'];
				v34 = EpicSettings['Toggles']['dispel'];
				if (v15:IsDeadOrGhost() or (6 >= 1889)) then
					return;
				end
				v138 = 2;
			end
			if ((506 <= 1892) and (v138 == 5)) then
				if (v95.TargetIsValid() or v15:AffectingCombat() or (2008 > 2218)) then
					local v205 = 0;
					while true do
						if ((379 <= 4147) and (v205 == 0)) then
							v103 = v10.BossFightRemains(nil, true);
							v104 = v103;
							v205 = 1;
						end
						if ((v205 == 2) or (4514 <= 1009)) then
							v106 = v15:HolyPower();
							break;
						end
						if ((v205 == 1) or (3496 == 1192)) then
							if ((v104 == 11111) or (208 == 2959)) then
								v104 = v10.FightRemains(v101, false);
							end
							v107 = v15:GCD();
							v205 = 2;
						end
					end
				end
				if ((4277 >= 1313) and v77) then
					local v206 = 0;
					while true do
						if ((2587 < 3174) and (v206 == 0)) then
							if (v73 or (4120 <= 2198)) then
								local v211 = 0;
								while true do
									if ((v211 == 0) or (1596 == 858)) then
										v139 = v95.HandleAfflicted(v96.CleanseToxins, v100.CleanseToxinsMouseover, 40);
										if ((3220 == 3220) and v139) then
											return v139;
										end
										break;
									end
								end
							end
							if ((v74 and (v106 > 2)) or (1402 > 3620)) then
								local v212 = 0;
								while true do
									if ((2574 == 2574) and (v212 == 0)) then
										v139 = v95.HandleAfflicted(v96.WordofGlory, v100.WordofGloryMouseover, 40, true);
										if ((1798 < 2757) and v139) then
											return v139;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (v78 or (377 > 2604)) then
					local v207 = 0;
					while true do
						if ((568 < 911) and (v207 == 0)) then
							v139 = v95.HandleIncorporeal(v96.Repentance, v100.RepentanceMouseOver, 30, true);
							if ((3285 < 4228) and v139) then
								return v139;
							end
							v207 = 1;
						end
						if ((3916 > 3328) and (1 == v207)) then
							v139 = v95.HandleIncorporeal(v96.TurnEvil, v100.TurnEvilMouseOver, 30, true);
							if ((2500 < 3839) and v139) then
								return v139;
							end
							break;
						end
					end
				end
				v139 = v112();
				v138 = 6;
			end
		end
	end
	local function v123()
		local v140 = 0;
		while true do
			if ((507 == 507) and (v140 == 0)) then
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v99();
				break;
			end
		end
	end
	v21.SetAPL(70, v122, OnInit);
end;
return v0["Epix_Paladin_Retribution.lua"]();

