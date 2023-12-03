local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((v5 == 0) or (503 > 1075)) then
			v6 = v0[v4];
			if (not v6 or (1894 < 1406)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((1572 >= 1531) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0["Epix_Paladin_Protection.lua"] = function(...)
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
	local v28 = string['format'];
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
	local v96 = v19['Paladin']['Protection'];
	local v97 = v20['Paladin']['Protection'];
	local v98 = v24['Paladin']['Protection'];
	local v99 = {};
	local v100;
	local v101;
	local v102, v103;
	local v104, v105;
	local v106 = v21['Commons']['Everyone'];
	local function v107()
		if (v96['CleanseToxins']:IsAvailable() or (4687 < 4542)) then
			v106['DispellableDebuffs'] = v13.MergeTable(v106.DispellableDiseaseDebuffs, v106.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v107();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v108(v123)
		return v123:DebuffRemains(v96.JudgmentDebuff);
	end
	local function v109()
		return v15:BuffDown(v96.RetributionAura) and v15:BuffDown(v96.DevotionAura) and v15:BuffDown(v96.ConcentrationAura) and v15:BuffDown(v96.CrusaderAura);
	end
	local function v110()
		if ((3291 > 1667) and v96['CleanseToxins']:IsReady() and v33 and v106.DispellableFriendlyUnit(25)) then
			if (v25(v98.CleanseToxinsFocus) or (873 == 2034)) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v111()
		if ((v94 and (v15:HealthPercentage() <= v95)) or (2816 < 11)) then
			if ((3699 < 4706) and v96['FlashofLight']:IsReady()) then
				if ((2646 >= 876) and v25(v96.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v112()
		local v124 = 0;
		while true do
			if ((614 <= 3184) and (1 == v124)) then
				v29 = v106.HandleBottomTrinket(v99, v32, 40, nil);
				if ((3126 == 3126) and v29) then
					return v29;
				end
				break;
			end
			if ((v124 == 0) or (2187 >= 4954)) then
				v29 = v106.HandleTopTrinket(v99, v32, 40, nil);
				if (v29 or (3877 == 3575)) then
					return v29;
				end
				v124 = 1;
			end
		end
	end
	local function v113()
		local v125 = 0;
		while true do
			if ((707 > 632) and (v125 == 1)) then
				if ((v96['GuardianofAncientKings']:IsCastable() and (v15:HealthPercentage() <= v67) and v57 and v15:BuffDown(v96.ArdentDefenderBuff)) or (546 >= 2684)) then
					if ((1465 <= 4301) and v25(v96.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((1704 > 1425) and v96['ArdentDefender']:IsCastable() and (v15:HealthPercentage() <= v65) and v55 and v15:BuffDown(v96.GuardianofAncientKingsBuff)) then
					if (v25(v96.ArdentDefender) or (687 == 4234)) then
						return "ardent_defender defensive 6";
					end
				end
				v125 = 2;
			end
			if ((v125 == 0) or (3330 < 1429)) then
				if ((1147 >= 335) and (v15:HealthPercentage() <= v66) and v56 and v96['DivineShield']:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) then
					if ((3435 > 2097) and v25(v96.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((v15:HealthPercentage() <= v68) and v58 and v96['LayonHands']:IsCastable() and v15:DebuffDown(v96.ForbearanceDebuff)) or (3770 >= 4041)) then
					if (v25(v98.LayonHandsPlayer) or (3791 <= 1611)) then
						return "lay_on_hands defensive 2";
					end
				end
				v125 = 1;
			end
			if ((v125 == 3) or (4578 <= 2008)) then
				if ((1125 <= 2076) and v97['Healthstone']:IsReady() and v90 and (v15:HealthPercentage() <= v92)) then
					if (v25(v98.Healthstone) or (743 >= 4399)) then
						return "healthstone defensive";
					end
				end
				if ((1155 < 1673) and v89 and (v15:HealthPercentage() <= v91)) then
					local v200 = 0;
					while true do
						if ((v200 == 0) or (2324 <= 578)) then
							if ((3767 == 3767) and (v93 == "Refreshing Healing Potion")) then
								if ((4089 == 4089) and v97['RefreshingHealingPotion']:IsReady()) then
									if ((4458 >= 1674) and v25(v98.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((972 <= 1418) and (v93 == "Dreamwalker's Healing Potion")) then
								if (v97['DreamwalkersHealingPotion']:IsReady() or (4938 < 4762)) then
									if (v25(v98.RefreshingHealingPotion) or (2504 > 4264)) then
										return "dreamwalkers healing potion defensive";
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((2153 == 2153) and (v125 == 2)) then
				if ((v96['WordofGlory']:IsReady() and (v15:HealthPercentage() <= v69) and v59 and not v15:HealingAbsorbed()) or (507 >= 2591)) then
					if ((4481 == 4481) and ((v15:BuffRemains(v96.ShieldoftheRighteousBuff) >= 5) or v15:BuffUp(v96.DivinePurposeBuff) or v15:BuffUp(v96.ShiningLightFreeBuff))) then
						if (v25(v98.WordofGloryPlayer) or (2328 < 693)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((4328 == 4328) and v96['ShieldoftheRighteous']:IsCastable() and (v15:HolyPower() > 2) and v15:BuffRefreshable(v96.ShieldoftheRighteousBuff) and v60 and (v100 or (v15:HealthPercentage() <= v70))) then
					if ((1588 >= 1332) and v25(v96.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v125 = 3;
			end
		end
	end
	local function v114()
		local v126 = 0;
		while true do
			if ((v126 == 0) or (4174 > 4248)) then
				if (not v14 or not v14:Exists() or not v14:IsInRange(30) or (4586 <= 82)) then
					return;
				end
				if ((3863 == 3863) and v14) then
					local v201 = 0;
					while true do
						if ((1 == v201) or (282 <= 42)) then
							if ((4609 >= 766) and v96['BlessingofSacrifice']:IsCastable() and v64 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v74)) then
								if (v25(v98.BlessingofSacrificeFocus) or (1152 == 2488)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if ((3422 > 3350) and v96['BlessingofProtection']:IsCastable() and v63 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v73)) then
								if ((877 > 376) and v25(v98.BlessingofProtectionFocus)) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if ((0 == v201) or (3118 <= 1851)) then
							if ((v96['WordofGlory']:IsReady() and v62 and v15:BuffUp(v96.ShiningLightFreeBuff) and (v14:HealthPercentage() <= v72)) or (165 >= 3492)) then
								if ((3949 < 4856) and v25(v98.WordofGloryFocus)) then
									return "word_of_glory defensive focus";
								end
							end
							if ((v96['LayonHands']:IsCastable() and v61 and v14:DebuffDown(v96.ForbearanceDebuff) and (v14:HealthPercentage() <= v71)) or (4276 < 3016)) then
								if ((4690 > 4125) and v25(v98.LayonHandsFocus)) then
									return "lay_on_hands defensive focus";
								end
							end
							v201 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v127 = 0;
		while true do
			if ((v127 == 1) or (50 >= 896)) then
				if ((v96['Consecration']:IsCastable() and v36) or (1714 >= 2958)) then
					if (v25(v96.Consecration, not v17:IsInRange(8)) or (1491 < 644)) then
						return "consecration";
					end
				end
				if ((704 < 987) and v96['AvengersShield']:IsCastable() and v34) then
					if ((3718 > 1906) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
						return "avengers_shield precombat 10";
					end
				end
				v127 = 2;
			end
			if ((2 == v127) or (958 > 3635)) then
				if ((3501 <= 4492) and v96['Judgment']:IsReady() and v40) then
					if (v25(v96.Judgment, not v17:IsSpellInRange(v96.Judgment)) or (3442 < 2548)) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if ((2875 >= 1464) and (v127 == 0)) then
				if (((v84 < FightRemains) and v96['LightsJudgment']:IsCastable() and v87 and ((v88 and v32) or not v88)) or (4797 >= 4893)) then
					if (v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment)) or (551 > 2068)) then
						return "lights_judgment precombat 4";
					end
				end
				if ((2114 > 944) and (v84 < FightRemains) and v96['ArcaneTorrent']:IsCastable() and v87 and ((v88 and v32) or not v88) and (HolyPower < 5)) then
					if (v25(v96.ArcaneTorrent, not v17:IsInRange(8)) or (2262 >= 3096)) then
						return "arcane_torrent precombat 6";
					end
				end
				v127 = 1;
			end
		end
	end
	local function v116()
		local v128 = 0;
		local v129;
		while true do
			if ((v128 == 3) or (2255 >= 3537)) then
				if ((v96['MomentofGlory']:IsCastable() and v45 and ((v51 and v32) or not v51) and ((v15:BuffRemains(v96.SentinelBuff) < 15) or (((v10.CombatTime() > 10) or (v96['Sentinel']:CooldownRemains() > 15) or (v96['AvengingWrath']:CooldownRemains() > 15)) and (v96['AvengersShield']:CooldownRemains() > 0) and (v96['Judgment']:CooldownRemains() > 0) and (v96['HammerofWrath']:CooldownRemains() > 0)))) or (3837 < 1306)) then
					if ((2950 == 2950) and v25(v96.MomentofGlory, not v17:IsInRange(8))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if ((v43 and ((v49 and v32) or not v49) and v96['DivineToll']:IsReady() and (v104 >= 3)) or (4723 < 3298)) then
					if ((1136 >= 154) and v25(v96.DivineToll, not v17:IsInRange(30))) then
						return "divine_toll cooldowns 12";
					end
				end
				v128 = 4;
			end
			if ((v128 == 1) or (271 > 4748)) then
				if ((4740 >= 3152) and v96['AvengingWrath']:IsCastable() and v41 and ((v47 and v32) or not v47)) then
					if (v25(v96.AvengingWrath, not v17:IsInRange(8)) or (2578 >= 3390)) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if ((41 <= 1661) and v96['Sentinel']:IsCastable() and v46 and ((v52 and v32) or not v52)) then
					if ((601 < 3560) and v25(v96.Sentinel, not v17:IsInRange(8))) then
						return "sentinel cooldowns 8";
					end
				end
				v128 = 2;
			end
			if ((235 < 687) and (v128 == 2)) then
				v129 = v106.HandleDPSPotion(v15:BuffUp(v96.AvengingWrathBuff));
				if ((4549 > 1153) and v129) then
					return v129;
				end
				v128 = 3;
			end
			if ((v128 == 0) or (4674 < 4672)) then
				if ((3668 < 4561) and v96['AvengersShield']:IsCastable() and v34 and (v10.CombatTime() < 2) and v15:HasTier(29, 2)) then
					if (v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield)) or (455 == 3605)) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v96['LightsJudgment']:IsCastable() and v87 and ((v88 and v32) or not v88) and (v105 >= 2)) or (2663 == 3312)) then
					if ((4277 <= 4475) and v25(v96.LightsJudgment, not v17:IsSpellInRange(v96.LightsJudgment))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v128 = 1;
			end
			if ((v128 == 4) or (870 == 1189)) then
				if ((1553 <= 3133) and v96['BastionofLight']:IsCastable() and v42 and ((v48 and v32) or not v48) and (v15:BuffUp(v96.AvengingWrathBuff) or (v96['AvengingWrath']:CooldownRemains() <= 30))) then
					if (v25(v96.BastionofLight, not v17:IsInRange(8)) or (2237 >= 3511)) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v130 = 0;
		while true do
			if ((v130 == 0) or (1324 > 3020)) then
				if ((v96['Consecration']:IsCastable() and v36 and (v15:BuffStack(v96.SanctificationBuff) == 5)) or (2992 == 1881)) then
					if ((3106 > 1526) and v25(v96.Consecration, not v17:IsInRange(8))) then
						return "consecration standard 2";
					end
				end
				if ((3023 < 3870) and v96['ShieldoftheRighteous']:IsCastable() and v60 and ((v15:HolyPower() > 2) or v15:BuffUp(v96.BastionofLightBuff) or v15:BuffUp(v96.DivinePurposeBuff)) and (v15:BuffDown(v96.SanctificationBuff) or (v15:BuffStack(v96.SanctificationBuff) < 5))) then
					if ((143 > 74) and v25(v96.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if ((18 < 2112) and v96['Judgment']:IsReady() and v40 and (v104 > 3) and (v15:BuffStack(v96.BulwarkofRighteousFuryBuff) >= 3) and (v15:HolyPower() < 3)) then
					if ((1097 <= 1628) and v106.CastCycle(v96.Judgment, v102, v108, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment standard 6";
					end
				end
				v130 = 1;
			end
			if ((4630 == 4630) and (v130 == 6)) then
				if ((3540 > 2683) and v96['Consecration']:IsCastable() and v36 and (v15:BuffDown(v96.SanctificationEmpowerBuff))) then
					if ((4794 >= 3275) and v25(v96.Consecration, not v17:IsInRange(8))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if ((1484 == 1484) and (v130 == 3)) then
				if ((1432 < 3555) and v96['HammerofWrath']:IsReady() and v39) then
					if (v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath)) or (1065 > 3578)) then
						return "hammer_of_wrath standard 20";
					end
				end
				if ((v96['Judgment']:IsReady() and v40) or (4795 < 1407)) then
					if ((1853 < 4813) and v106.CastCycle(v96.Judgment, v102, v108, not v17:IsSpellInRange(v96.Judgment))) then
						return "judgment standard 22";
					end
				end
				if ((v96['Consecration']:IsCastable() and v36 and v15:BuffDown(v96.ConsecrationBuff) and ((v15:BuffStack(v96.SanctificationBuff) < 5) or not v15:HasTier(31, 2))) or (2821 < 2431)) then
					if (v25(v96.Consecration, not v17:IsInRange(8)) or (2874 < 2181)) then
						return "consecration standard 24";
					end
				end
				v130 = 4;
			end
			if ((v130 == 1) or (2689 <= 343)) then
				if ((v96['Judgment']:IsReady() and v40 and v15:BuffDown(v96.SanctificationEmpowerBuff) and v15:HasTier(31, 2)) or (1869 == 2009)) then
					if (v106.CastCycle(v96.Judgment, v102, v108, not v17:IsSpellInRange(v96.Judgment)) or (3546 < 2322)) then
						return "judgment standard 8";
					end
				end
				if ((v96['HammerofWrath']:IsReady() and v39) or (2082 == 4773)) then
					if ((3244 > 1055) and v25(v96.HammerofWrath, not v17:IsSpellInRange(v96.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v96['Judgment']:IsReady() and v40 and ((v96['Judgment']:Charges() >= 2) or (v96['Judgment']:FullRechargeTime() <= v15:GCD()))) or (3313 <= 1778)) then
					if (v106.CastCycle(v96.Judgment, v102, v108, not v17:IsSpellInRange(v96.Judgment)) or (1421 >= 2104)) then
						return "judgment standard 12";
					end
				end
				v130 = 2;
			end
			if ((1812 <= 3249) and (v130 == 4)) then
				if ((1623 <= 1957) and (v84 < FightRemains) and v44 and ((v50 and v32) or not v50) and v96['EyeofTyr']:IsCastable() and v96['InmostLight']:IsAvailable() and (v104 >= 3)) then
					if ((4412 == 4412) and v25(v96.EyeofTyr, not v17:IsInRange(8))) then
						return "eye_of_tyr standard 26";
					end
				end
				if ((1750 >= 842) and v96['BlessedHammer']:IsCastable() and v35) then
					if ((4372 > 1850) and v25(v96.BlessedHammer, not v17:IsInRange(8))) then
						return "blessed_hammer standard 28";
					end
				end
				if ((232 < 821) and v96['HammeroftheRighteous']:IsCastable() and v38) then
					if ((518 < 902) and v25(v96.HammeroftheRighteous, not v17:IsInRange(8))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v130 = 5;
			end
			if ((2994 > 858) and (v130 == 5)) then
				if ((v96['CrusaderStrike']:IsCastable() and v37) or (3755 <= 915)) then
					if ((3946 > 3743) and v25(v96.CrusaderStrike, not v17:IsSpellInRange(v96.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((v84 < FightRemains) and v44 and ((v50 and v32) or not v50) and v96['EyeofTyr']:IsCastable() and not v96['InmostLight']:IsAvailable()) or (1335 >= 3306)) then
					if ((4844 > 2253) and v25(v96.EyeofTyr, not v17:IsInRange(8))) then
						return "eye_of_tyr standard 34";
					end
				end
				if ((452 == 452) and v96['ArcaneTorrent']:IsCastable() and v87 and ((v88 and v32) or not v88) and (HolyPower < 5)) then
					if (v25(v96.ArcaneTorrent, not v17:IsInRange(8)) or (4557 < 2087)) then
						return "arcane_torrent standard 36";
					end
				end
				v130 = 6;
			end
			if ((3874 == 3874) and (v130 == 2)) then
				if ((v96['AvengersShield']:IsCastable() and v34 and ((v105 > 2) or v15:BuffUp(v96.MomentofGloryBuff))) or (1938 > 4935)) then
					if (v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield)) or (4255 < 3423)) then
						return "avengers_shield standard 14";
					end
				end
				if ((1454 <= 2491) and v43 and ((v49 and v32) or not v49) and v96['DivineToll']:IsReady()) then
					if (v25(v96.DivineToll, not v17:IsInRange(30)) or (4157 <= 2803)) then
						return "divine_toll standard 16";
					end
				end
				if ((4853 >= 2982) and v96['AvengersShield']:IsCastable() and v34) then
					if ((4134 > 3357) and v25(v96.AvengersShield, not v17:IsSpellInRange(v96.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				v130 = 3;
			end
		end
	end
	local function v118()
		local v131 = 0;
		while true do
			if ((v131 == 1) or (3417 < 2534)) then
				v37 = EpicSettings['Settings']['useCrusaderStrike'];
				v38 = EpicSettings['Settings']['useHammeroftheRighteous'];
				v39 = EpicSettings['Settings']['useHammerofWrath'];
				v131 = 2;
			end
			if ((5 == v131) or (2722 <= 164)) then
				v49 = EpicSettings['Settings']['divineTollWithCD'];
				v50 = EpicSettings['Settings']['eyeofTyrWithCD'];
				v51 = EpicSettings['Settings']['momentofGloryWithCD'];
				v131 = 6;
			end
			if ((v131 == 4) or (2408 < 2109)) then
				v46 = EpicSettings['Settings']['useSentinel'];
				v47 = EpicSettings['Settings']['avengingWrathWithCD'];
				v48 = EpicSettings['Settings']['bastionofLightWithCD'];
				v131 = 5;
			end
			if ((v131 == 0) or (33 == 1455)) then
				v34 = EpicSettings['Settings']['useAvengersShield'];
				v35 = EpicSettings['Settings']['useBlessedHammer'];
				v36 = EpicSettings['Settings']['useConsecration'];
				v131 = 1;
			end
			if ((6 == v131) or (443 >= 4015)) then
				v52 = EpicSettings['Settings']['sentinelWithCD'];
				break;
			end
			if ((3382 > 166) and (v131 == 2)) then
				v40 = EpicSettings['Settings']['useJudgment'];
				v41 = EpicSettings['Settings']['useAvengingWrath'];
				v42 = EpicSettings['Settings']['useBastionofLight'];
				v131 = 3;
			end
			if ((v131 == 3) or (280 == 3059)) then
				v43 = EpicSettings['Settings']['useDivineToll'];
				v44 = EpicSettings['Settings']['useEyeofTyr'];
				v45 = EpicSettings['Settings']['useMomentOfGlory'];
				v131 = 4;
			end
		end
	end
	local function v119()
		local v132 = 0;
		while true do
			if ((1881 > 1293) and (v132 == 4)) then
				v69 = EpicSettings['Settings']['wordofGloryHP'];
				v70 = EpicSettings['Settings']['shieldoftheRighteousHP'];
				v71 = EpicSettings['Settings']['layOnHandsFocusHP'];
				v72 = EpicSettings['Settings']['wordofGloryFocusHP'];
				v132 = 5;
			end
			if ((2357 == 2357) and (v132 == 3)) then
				v65 = EpicSettings['Settings']['ardentDefenderHP'];
				v66 = EpicSettings['Settings']['divineShieldHP'];
				v67 = EpicSettings['Settings']['guardianofAncientKingsHP'];
				v68 = EpicSettings['Settings']['layonHandsHP'];
				v132 = 4;
			end
			if ((123 == 123) and (0 == v132)) then
				v53 = EpicSettings['Settings']['useRebuke'];
				v54 = EpicSettings['Settings']['useHammerofJustice'];
				v55 = EpicSettings['Settings']['useArdentDefender'];
				v56 = EpicSettings['Settings']['useDivineShield'];
				v132 = 1;
			end
			if ((v132 == 2) or (1056 >= 3392)) then
				v61 = EpicSettings['Settings']['useLayOnHandsFocus'];
				v62 = EpicSettings['Settings']['useWordofGloryFocus'];
				v63 = EpicSettings['Settings']['useBlessingOfProtectionFocus'];
				v64 = EpicSettings['Settings']['useBlessingOfSacrificeFocus'];
				v132 = 3;
			end
			if ((v132 == 5) or (1081 < 1075)) then
				v73 = EpicSettings['Settings']['blessingofProtectionFocusHP'];
				v74 = EpicSettings['Settings']['blessingofSacrificeFocusHP'];
				v75 = EpicSettings['Settings']['useCleanseToxinsWithAfflicted'];
				v76 = EpicSettings['Settings']['useWordofGloryWithAfflicted'];
				break;
			end
			if ((v132 == 1) or (1049 >= 4432)) then
				v57 = EpicSettings['Settings']['useGuardianofAncientKings'];
				v58 = EpicSettings['Settings']['useLayOnHands'];
				v59 = EpicSettings['Settings']['useWordofGloryPlayer'];
				v60 = EpicSettings['Settings']['useShieldoftheRighteous'];
				v132 = 2;
			end
		end
	end
	local function v120()
		local v133 = 0;
		while true do
			if ((v133 == 3) or (4768 <= 846)) then
				v92 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v91 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v93 = EpicSettings['Settings']['HealingPotionName'] or "";
				v79 = EpicSettings['Settings']['handleAfflicted'];
				v133 = 4;
			end
			if ((v133 == 4) or (3358 <= 1420)) then
				v80 = EpicSettings['Settings']['HandleIncorporeal'];
				v94 = EpicSettings['Settings']['HealOOC'];
				v95 = EpicSettings['Settings']['HealOOCHP'] or 0;
				break;
			end
			if ((v133 == 2) or (3739 <= 3005)) then
				v86 = EpicSettings['Settings']['trinketsWithCD'];
				v88 = EpicSettings['Settings']['racialsWithCD'];
				v90 = EpicSettings['Settings']['useHealthstone'];
				v89 = EpicSettings['Settings']['useHealingPotion'];
				v133 = 3;
			end
			if ((v133 == 0) or (1659 >= 2134)) then
				v84 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v81 = EpicSettings['Settings']['InterruptWithStun'];
				v82 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v83 = EpicSettings['Settings']['InterruptThreshold'];
				v133 = 1;
			end
			if ((v133 == 1) or (3260 < 2355)) then
				v78 = EpicSettings['Settings']['DispelDebuffs'];
				v77 = EpicSettings['Settings']['DispelBuffs'];
				v85 = EpicSettings['Settings']['useTrinkets'];
				v87 = EpicSettings['Settings']['useRacials'];
				v133 = 2;
			end
		end
	end
	local function v121()
		local v134 = 0;
		local v135;
		while true do
			if ((v134 == 0) or (669 == 4223)) then
				v119();
				v118();
				v120();
				v30 = EpicSettings['Toggles']['ooc'];
				v31 = EpicSettings['Toggles']['aoe'];
				v32 = EpicSettings['Toggles']['cds'];
				v134 = 1;
			end
			if ((v134 == 4) or (1692 < 588)) then
				if (v14 or (4797 < 3651)) then
					if (v78 or (4177 > 4850)) then
						local v211 = 0;
						while true do
							if ((v211 == 0) or (400 > 1111)) then
								v135 = v110();
								if ((3051 > 1005) and v135) then
									return v135;
								end
								break;
							end
						end
					end
				end
				v135 = v114();
				if ((3693 <= 4382) and v135) then
					return v135;
				end
				if ((v96['Redemption']:IsCastable() and v96['Redemption']:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or (3282 > 4100)) then
					if (v25(v98.RedemptionMouseover) or (3580 < 2844)) then
						return "redemption mouseover";
					end
				end
				if ((89 < 4490) and v15:AffectingCombat()) then
					if ((v96['Intercession']:IsCastable() and (v15:HolyPower() >= 3) and v96['Intercession']:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or (4983 < 1808)) then
						if ((3829 > 3769) and v25(v98.IntercessionMouseover)) then
							return "Intercession";
						end
					end
				end
				if ((1485 <= 2904) and v106.TargetIsValid() and not v15:AffectingCombat() and v30) then
					local v202 = 0;
					while true do
						if ((4269 == 4269) and (v202 == 0)) then
							v135 = v115();
							if ((387 <= 2782) and v135) then
								return v135;
							end
							break;
						end
					end
				end
				v134 = 5;
			end
			if ((v134 == 5) or (1899 <= 917)) then
				if (v106.TargetIsValid() or (4312 <= 876)) then
					local v203 = 0;
					while true do
						if ((2232 <= 2596) and (0 == v203)) then
							if ((2095 < 3686) and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
								if (v15:AffectingCombat() or (1595 >= 4474)) then
									if (v96['Intercession']:IsCastable() or (4619 < 2882)) then
										if (v25(v96.Intercession, not v17:IsInRange(30), true) or (294 >= 4831)) then
											return "intercession";
										end
									end
								elseif ((2029 <= 3084) and v96['Redemption']:IsCastable()) then
									if (v25(v96.Redemption, not v17:IsInRange(30), true) or (2037 == 2420)) then
										return "redemption";
									end
								end
							end
							if ((4458 > 3904) and v106.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
								local v212 = 0;
								while true do
									if ((436 >= 123) and (v212 == 1)) then
										if ((500 < 1816) and v85 and ((v32 and v86) or not v86) and v17:IsInRange(8)) then
											local v215 = 0;
											while true do
												if ((3574 == 3574) and (v215 == 0)) then
													v135 = v112();
													if ((221 < 390) and v135) then
														return v135;
													end
													break;
												end
											end
										end
										v135 = v117();
										v212 = 2;
									end
									if ((0 == v212) or (2213 <= 1421)) then
										if ((3058 < 4860) and v101) then
											local v216 = 0;
											while true do
												if ((v216 == 0) or (1296 >= 4446)) then
													v135 = v113();
													if (v135 or (1393 > 4489)) then
														return v135;
													end
													break;
												end
											end
										end
										if ((v84 < FightRemains) or (4424 < 27)) then
											local v217 = 0;
											while true do
												if ((v217 == 0) or (1997 > 3815)) then
													v135 = v116();
													if ((3465 > 1913) and v135) then
														return v135;
													end
													break;
												end
											end
										end
										v212 = 1;
									end
									if ((733 < 1819) and (2 == v212)) then
										if (v135 or (4395 == 4755)) then
											return v135;
										end
										if (v25(v96.Pool) or (3793 < 2369)) then
											return "Wait/Pool Resources";
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v134 == 2) or (4084 == 265)) then
				v101 = v15:IsTankingAoE(8) or v15:IsTanking(v17);
				if ((4358 == 4358) and not v15:AffectingCombat() and v15:IsMounted()) then
					if ((v96['CrusaderAura']:IsCastable() and (v15:BuffDown(v96.CrusaderAura))) or (3138 < 993)) then
						if ((3330 > 2323) and v25(v96.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if (v15:AffectingCombat() or v78 or (3626 == 3989)) then
					local v204 = 0;
					local v205;
					while true do
						if ((v204 == 0) or (916 == 2671)) then
							v205 = v78 and v96['CleanseToxins']:IsReady() and v33;
							v135 = v106.FocusUnit(v205, v98, 20, nil, 25);
							v204 = 1;
						end
						if ((272 == 272) and (v204 == 1)) then
							if ((4249 <= 4839) and v135) then
								return v135;
							end
							break;
						end
					end
				end
				v135 = v106.FocusUnitWithDebuffFromList(v19['Paladin'].FreedomDebuffList, 40, 25);
				if ((2777 < 3200) and v135) then
					return v135;
				end
				if ((95 < 1957) and v96['BlessingofFreedom']:IsReady() and v106.UnitHasDebuffFromList(v14, v19['Paladin'].FreedomDebuffList)) then
					if ((826 < 1717) and v25(v98.BlessingofFreedomFocus)) then
						return "blessing_of_freedom combat";
					end
				end
				v134 = 3;
			end
			if ((1426 >= 1105) and (v134 == 3)) then
				if ((2754 <= 3379) and (v106.TargetIsValid() or v15:AffectingCombat())) then
					local v206 = 0;
					while true do
						if ((v206 == 0) or (3927 == 1413)) then
							BossFightRemains = v10.BossFightRemains(nil, true);
							FightRemains = BossFightRemains;
							v206 = 1;
						end
						if ((v206 == 1) or (1154 <= 788)) then
							if ((FightRemains == 11111) or (1643 > 3379)) then
								FightRemains = v10.FightRemains(v102, false);
							end
							break;
						end
					end
				end
				if (not v15:AffectingCombat() or (2803 > 4549)) then
					if ((v96['DevotionAura']:IsCastable() and (v109())) or (220 >= 3022)) then
						if ((2822 == 2822) and v25(v96.DevotionAura)) then
							return "devotion_aura";
						end
					end
				end
				if (v79 or (1061 == 1857)) then
					local v207 = 0;
					while true do
						if ((2760 > 1364) and (v207 == 0)) then
							if (v75 or (4902 <= 3595)) then
								local v213 = 0;
								while true do
									if ((v213 == 0) or (3852 == 293)) then
										v135 = v106.HandleAfflicted(v96.CleanseToxins, v98.CleanseToxinsMouseover, 40);
										if (v135 or (1559 == 4588)) then
											return v135;
										end
										break;
									end
								end
							end
							if ((v15:BuffUp(v96.ShiningLightFreeBuff) and v76) or (4484 == 788)) then
								local v214 = 0;
								while true do
									if ((4568 >= 3907) and (v214 == 0)) then
										v135 = v106.HandleAfflicted(v96.WordofGlory, v98.WordofGloryMouseover, 40, true);
										if ((1246 < 3470) and v135) then
											return v135;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if ((4068 >= 972) and v80) then
					local v208 = 0;
					while true do
						if ((493 < 3893) and (v208 == 1)) then
							v135 = v106.HandleIncorporeal(v96.TurnEvil, v98.TurnEvilMouseOver, 30, true);
							if (v135 or (1473 >= 3332)) then
								return v135;
							end
							break;
						end
						if ((v208 == 0) or (4051 <= 1157)) then
							v135 = v106.HandleIncorporeal(v96.Repentance, v98.RepentanceMouseOver, 30, true);
							if ((604 < 2881) and v135) then
								return v135;
							end
							v208 = 1;
						end
					end
				end
				v135 = v111();
				if (v135 or (900 == 3377)) then
					return v135;
				end
				v134 = 4;
			end
			if ((4459 > 591) and (v134 == 1)) then
				v33 = EpicSettings['Toggles']['dispel'];
				if ((3398 >= 2395) and v15:IsDeadOrGhost()) then
					return;
				end
				v102 = v15:GetEnemiesInMeleeRange(10);
				v103 = v15:GetEnemiesInRange(30);
				if (v31 or (2183 >= 2824)) then
					local v209 = 0;
					while true do
						if ((1936 == 1936) and (v209 == 0)) then
							v104 = #v102;
							v105 = #v103;
							break;
						end
					end
				else
					local v210 = 0;
					while true do
						if ((v210 == 0) or (4832 < 4313)) then
							v104 = 1;
							v105 = 1;
							break;
						end
					end
				end
				v100 = v15:ActiveMitigationNeeded();
				v134 = 2;
			end
		end
	end
	local function v122()
		local v136 = 0;
		while true do
			if ((4088 > 3874) and (v136 == 0)) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v107();
				break;
			end
		end
	end
	v21.SetAPL(66, v121, v122);
end;
return v0["Epix_Paladin_Protection.lua"]();

