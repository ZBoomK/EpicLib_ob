local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((1572 > 1531) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (4687 < 4542)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((3291 > 1667) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0["Epix_Warrior_Fury.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10['Unit'];
	local v13 = v10['Utils'];
	local v14 = v12['Player'];
	local v15 = v12['Target'];
	local v16 = v12['TargetTarget'];
	local v17 = v12['Focus'];
	local v18 = v10['Spell'];
	local v19 = v10['Item'];
	local v20 = EpicLib;
	local v21 = v20['Bind'];
	local v22 = v20['Cast'];
	local v23 = v20['Macro'];
	local v24 = v20['Press'];
	local v25 = v20['Commons']['Everyone']['num'];
	local v26 = v20['Commons']['Everyone']['bool'];
	local v27 = 5;
	local v28;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32;
	local v33;
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
	local v92 = v20['Commons']['Everyone'];
	local v93 = v18['Warrior']['Fury'];
	local v94 = v19['Warrior']['Fury'];
	local v95 = v23['Warrior']['Fury'];
	local v96 = {};
	local v97 = 11111;
	local v98 = 11111;
	v10:RegisterForEvent(function()
		local v115 = 0;
		while true do
			if ((v115 == 0) or (873 == 2034)) then
				v97 = 11111;
				v98 = 11111;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v99, v100;
	local v101;
	local function v102()
		local v116 = 0;
		local v117;
		while true do
			if ((v116 == 0) or (2816 < 11)) then
				v117 = UnitGetTotalAbsorbs(v15);
				if ((3699 < 4706) and (v117 > 0)) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v103()
		local v118 = 0;
		while true do
			if ((2646 >= 876) and (v118 == 4)) then
				if ((614 <= 3184) and v71 and (v14:HealthPercentage() <= v81)) then
					local v180 = 0;
					while true do
						if ((3126 == 3126) and (v180 == 0)) then
							if ((v87 == "Refreshing Healing Potion") or (2187 >= 4954)) then
								if (v94['RefreshingHealingPotion']:IsReady() or (3877 == 3575)) then
									if ((707 > 632) and v24(v95.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v87 == "Dreamwalker's Healing Potion") or (546 >= 2684)) then
								if ((1465 <= 4301) and v94['DreamwalkersHealingPotion']:IsReady()) then
									if ((1704 > 1425) and v24(v95.RefreshingHealingPotion)) then
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
			if ((v118 == 3) or (687 == 4234)) then
				if ((v93['BerserkerStance']:IsCastable() and v69 and (v14:HealthPercentage() > v82) and v14:BuffDown(v93.BerserkerStance, true)) or (3330 < 1429)) then
					if ((1147 >= 335) and v24(v93.BerserkerStance)) then
						return "berserker_stance after defensive stance defensive";
					end
				end
				if ((3435 > 2097) and v94['Healthstone']:IsReady() and v70 and (v14:HealthPercentage() <= v80)) then
					if (v24(v95.Healthstone) or (3770 >= 4041)) then
						return "healthstone defensive 3";
					end
				end
				v118 = 4;
			end
			if ((v118 == 0) or (3791 <= 1611)) then
				if ((v93['BitterImmunity']:IsReady() and v64 and (v14:HealthPercentage() <= v73)) or (4578 <= 2008)) then
					if ((1125 <= 2076) and v24(v93.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if ((v93['EnragedRegeneration']:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) or (743 >= 4399)) then
					if ((1155 < 1673) and v24(v93.EnragedRegeneration)) then
						return "enraged_regeneration defensive";
					end
				end
				v118 = 1;
			end
			if ((v118 == 1) or (2324 <= 578)) then
				if ((3767 == 3767) and v93['IgnorePain']:IsCastable() and v66 and (v14:HealthPercentage() <= v75)) then
					if ((4089 == 4089) and v24(v93.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((4458 >= 1674) and v93['RallyingCry']:IsCastable() and v67 and v14:BuffDown(v93.AspectsFavorBuff) and v14:BuffDown(v93.RallyingCry) and (((v14:HealthPercentage() <= v76) and v92.IsSoloMode()) or v92.AreUnitsBelowHealthPercentage(v76, v77))) then
					if ((972 <= 1418) and v24(v93.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v118 = 2;
			end
			if ((v118 == 2) or (4938 < 4762)) then
				if ((v93['Intervene']:IsCastable() and v68 and (v17:HealthPercentage() <= v78) and (v17:UnitName() ~= v14:UnitName())) or (2504 > 4264)) then
					if ((2153 == 2153) and v24(v95.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if ((v93['DefensiveStance']:IsCastable() and v69 and (v14:HealthPercentage() <= v79) and v14:BuffDown(v93.DefensiveStance, true)) or (507 >= 2591)) then
					if ((4481 == 4481) and v24(v93.DefensiveStance)) then
						return "defensive_stance defensive";
					end
				end
				v118 = 3;
			end
		end
	end
	local function v104()
		local v119 = 0;
		while true do
			if ((1 == v119) or (2328 < 693)) then
				v28 = v92.HandleBottomTrinket(v96, v31, 40, nil);
				if ((4328 == 4328) and v28) then
					return v28;
				end
				break;
			end
			if ((1588 >= 1332) and (0 == v119)) then
				v28 = v92.HandleTopTrinket(v96, v31, 40, nil);
				if (v28 or (4174 > 4248)) then
					return v28;
				end
				v119 = 1;
			end
		end
	end
	local function v105()
		local v120 = 0;
		while true do
			if ((v120 == 1) or (4586 <= 82)) then
				if ((3863 == 3863) and v93['Bloodthirst']:IsCastable() and v35 and v101) then
					if (v24(v93.Bloodthirst, not v101) or (282 <= 42)) then
						return "bloodthirst precombat 10";
					end
				end
				if ((4609 >= 766) and v36 and v93['Charge']:IsReady() and not v101) then
					if (v24(v93.Charge, not v15:IsSpellInRange(v93.Charge)) or (1152 == 2488)) then
						return "charge precombat 12";
					end
				end
				break;
			end
			if ((3422 > 3350) and (v120 == 0)) then
				if ((877 > 376) and v32 and ((v53 and v31) or not v53) and (v91 < v98) and v93['Avatar']:IsCastable() and not v93['TitansTorment']:IsAvailable()) then
					if (v24(v93.Avatar, not v101) or (3118 <= 1851)) then
						return "avatar precombat 6";
					end
				end
				if ((v45 and ((v56 and v31) or not v56) and (v91 < v98) and v93['Recklessness']:IsCastable() and not v93['RecklessAbandon']:IsAvailable()) or (165 >= 3492)) then
					if ((3949 < 4856) and v24(v93.Recklessness, not v101)) then
						return "recklessness precombat 8";
					end
				end
				v120 = 1;
			end
		end
	end
	local function v106()
		local v121 = 0;
		local v122;
		while true do
			if ((v121 == 5) or (4276 < 3016)) then
				if ((4690 > 4125) and v93['Slam']:IsReady() and v46 and (v93['Annihilator']:IsAvailable())) then
					if (v24(v93.Slam, not v101) or (50 >= 896)) then
						return "slam single_target 48";
					end
				end
				if ((v93['Bloodbath']:IsCastable() and v34) or (1714 >= 2958)) then
					if (v24(v93.Bloodbath, not v101) or (1491 < 644)) then
						return "bloodbath single_target 50";
					end
				end
				if ((704 < 987) and v93['RagingBlow']:IsCastable() and v42) then
					if ((3718 > 1906) and v24(v93.RagingBlow, not v101)) then
						return "raging_blow single_target 52";
					end
				end
				if ((v93['CrushingBlow']:IsCastable() and v37 and v14:BuffDown(v93.FuriousBloodthirstBuff)) or (958 > 3635)) then
					if ((3501 <= 4492) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow single_target 54";
					end
				end
				if ((v93['Bloodthirst']:IsCastable() and v35) or (3442 < 2548)) then
					if ((2875 >= 1464) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 56";
					end
				end
				v121 = 6;
			end
			if ((v121 == 2) or (4797 >= 4893)) then
				if ((v93['Execute']:IsReady() and v38 and ((v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff) and v14:BuffUp(v93.AshenJuggernautBuff)) or ((v14:BuffRemains(v93.SuddenDeathBuff) <= v14:GCD()) and (((v15:HealthPercentage() > 35) and v93['Massacre']:IsAvailable()) or (v15:HealthPercentage() > 20))))) or (551 > 2068)) then
					if ((2114 > 944) and v24(v93.Execute, not v101)) then
						return "execute single_target 22";
					end
				end
				if ((v93['Rampage']:IsReady() and v43 and v93['RecklessAbandon']:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > 85))) or (2262 >= 3096)) then
					if (v24(v93.Rampage, not v101) or (2255 >= 3537)) then
						return "rampage single_target 24";
					end
				end
				if ((v93['Execute']:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) or (3837 < 1306)) then
					if ((2950 == 2950) and v24(v93.Execute, not v101)) then
						return "execute single_target 26";
					end
				end
				if ((v93['Rampage']:IsReady() and v43 and v93['AngerManagement']:IsAvailable()) or (4723 < 3298)) then
					if ((1136 >= 154) and v24(v93.Rampage, not v101)) then
						return "rampage single_target 28";
					end
				end
				if ((v93['Execute']:IsReady() and v38) or (271 > 4748)) then
					if ((4740 >= 3152) and v24(v93.Execute, not v101)) then
						return "execute single_target 29";
					end
				end
				v121 = 3;
			end
			if ((v121 == 3) or (2578 >= 3390)) then
				if ((41 <= 1661) and v93['Bloodbath']:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93['RecklessAbandon']:IsAvailable() and not v93['WrathandFury']:IsAvailable()) then
					if ((601 < 3560) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath single_target 30";
					end
				end
				if ((235 < 687) and v93['Rampage']:IsReady() and v43 and (v15:HealthPercentage() < 35) and v93['Massacre']:IsAvailable()) then
					if ((4549 > 1153) and v24(v93.Rampage, not v101)) then
						return "rampage single_target 32";
					end
				end
				if ((v93['Bloodthirst']:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93['Annihilator']:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff))) and v14:BuffDown(v93.FuriousBloodthirstBuff)) or (4674 < 4672)) then
					if ((3668 < 4561) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 34";
					end
				end
				if ((v93['RagingBlow']:IsCastable() and v42 and (v93['RagingBlow']:Charges() > 1) and v93['WrathandFury']:IsAvailable()) or (455 == 3605)) then
					if (v24(v93.RagingBlow, not v101) or (2663 == 3312)) then
						return "raging_blow single_target 36";
					end
				end
				if ((4277 <= 4475) and v93['CrushingBlow']:IsCastable() and v37 and (v93['CrushingBlow']:Charges() > 1) and v93['WrathandFury']:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if (v24(v93.CrushingBlow, not v101) or (870 == 1189)) then
						return "crushing_blow single_target 38";
					end
				end
				v121 = 4;
			end
			if ((1553 <= 3133) and (v121 == 0)) then
				if ((v93['Whirlwind']:IsCastable() and v49 and (v100 > 1) and v93['ImprovedWhilwind']:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) or (2237 >= 3511)) then
					if (v24(v93.Whirlwind, not v15:IsInMeleeRange(v27)) or (1324 > 3020)) then
						return "whirlwind single_target 2";
					end
				end
				if ((v93['Execute']:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) or (2992 == 1881)) then
					if ((3106 > 1526) and v24(v93.Execute, not v101)) then
						return "execute single_target 4";
					end
				end
				if ((3023 < 3870) and v40 and ((v54 and v31) or not v54) and v93['OdynsFury']:IsCastable() and (v91 < v98) and v14:BuffUp(v93.EnrageBuff) and ((v93['DancingBlades']:IsAvailable() and (v14:BuffRemains(v93.DancingBladesBuff) < 5)) or not v93['DancingBlades']:IsAvailable())) then
					if ((143 > 74) and v24(v93.OdynsFury, not v15:IsInMeleeRange(v27))) then
						return "odyns_fury single_target 6";
					end
				end
				if ((18 < 2112) and v93['Rampage']:IsReady() and v43 and v93['AngerManagement']:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > 85))) then
					if ((1097 <= 1628) and v24(v93.Rampage, not v101)) then
						return "rampage single_target 8";
					end
				end
				v122 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * 20) + (v14:BuffStack(v93.MercilessAssaultBuff) * 10) + (v14:BuffStack(v93.BloodcrazeBuff) * 15);
				v121 = 1;
			end
			if ((4630 == 4630) and (v121 == 1)) then
				if ((3540 > 2683) and ((v122 >= 95) or (not v93['ColdSteelHotBlood']:IsAvailable() and v14:HasTier(30, 4)))) then
					local v181 = 0;
					while true do
						if ((4794 >= 3275) and (v181 == 0)) then
							if ((1484 == 1484) and v93['Bloodbath']:IsCastable() and v34) then
								if ((1432 < 3555) and v24(v93.Bloodbath, not v101)) then
									return "bloodbath single_target 10";
								end
							end
							if ((v93['Bloodthirst']:IsCastable() and v35) or (1065 > 3578)) then
								if (v24(v93.Bloodthirst, not v101) or (4795 < 1407)) then
									return "bloodthirst single_target 12";
								end
							end
							break;
						end
					end
				end
				if ((1853 < 4813) and v93['Bloodbath']:IsCastable() and v34 and v14:HasTier(31, 2)) then
					if (v24(v93.Bloodbath, not v101) or (2821 < 2431)) then
						return "bloodbath single_target 14";
					end
				end
				if ((v48 and ((v58 and v31) or not v58) and (v91 < v98) and v93['ThunderousRoar']:IsCastable() and v14:BuffUp(v93.EnrageBuff)) or (2874 < 2181)) then
					if (v24(v93.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (2689 <= 343)) then
						return "thunderous_roar single_target 16";
					end
				end
				if ((v93['Onslaught']:IsReady() and v41 and (v14:BuffUp(v93.EnrageBuff) or v93['Tenderize']:IsAvailable())) or (1869 == 2009)) then
					if (v24(v93.Onslaught, not v101) or (3546 < 2322)) then
						return "onslaught single_target 18";
					end
				end
				if ((v93['CrushingBlow']:IsCastable() and v37 and v93['WrathandFury']:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff)) or (2082 == 4773)) then
					if ((3244 > 1055) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow single_target 20";
					end
				end
				v121 = 2;
			end
			if ((v121 == 6) or (3313 <= 1778)) then
				if ((v30 and v93['Whirlwind']:IsCastable() and v49) or (1421 >= 2104)) then
					if ((1812 <= 3249) and v24(v93.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return "whirlwind single_target 58";
					end
				end
				break;
			end
			if ((1623 <= 1957) and (v121 == 4)) then
				if ((4412 == 4412) and v93['Bloodbath']:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93['WrathandFury']:IsAvailable())) then
					if ((1750 >= 842) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath single_target 40";
					end
				end
				if ((4372 > 1850) and v93['CrushingBlow']:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93['RecklessAbandon']:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if ((232 < 821) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow single_target 42";
					end
				end
				if ((518 < 902) and v93['Bloodthirst']:IsCastable() and v35 and not v93['WrathandFury']:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if ((2994 > 858) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst single_target 44";
					end
				end
				if ((v93['RagingBlow']:IsCastable() and v42 and (v93['RagingBlow']:Charges() > 1)) or (3755 <= 915)) then
					if ((3946 > 3743) and v24(v93.RagingBlow, not v101)) then
						return "raging_blow single_target 46";
					end
				end
				if ((v93['Rampage']:IsReady() and v43) or (1335 >= 3306)) then
					if ((4844 > 2253) and v24(v93.Rampage, not v101)) then
						return "rampage single_target 47";
					end
				end
				v121 = 5;
			end
		end
	end
	local function v107()
		local v123 = 0;
		local v124;
		while true do
			if ((452 == 452) and (v123 == 6)) then
				if ((v93['Bloodbath']:IsCastable() and v34) or (4557 < 2087)) then
					if ((3874 == 3874) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath multi_target 46";
					end
				end
				if ((v93['RagingBlow']:IsCastable() and v42) or (1938 > 4935)) then
					if (v24(v93.RagingBlow, not v101) or (4255 < 3423)) then
						return "raging_blow multi_target 48";
					end
				end
				if ((1454 <= 2491) and v93['CrushingBlow']:IsCastable() and v37) then
					if (v24(v93.CrushingBlow, not v101) or (4157 <= 2803)) then
						return "crushing_blow multi_target 50";
					end
				end
				if ((4853 >= 2982) and v93['Whirlwind']:IsCastable() and v49) then
					if ((4134 > 3357) and v24(v93.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return "whirlwind multi_target 52";
					end
				end
				break;
			end
			if ((v123 == 4) or (3417 < 2534)) then
				if ((v93['RagingBlow']:IsCastable() and v42 and (v93['RagingBlow']:Charges() > 1) and v93['WrathandFury']:IsAvailable()) or (2722 <= 164)) then
					if (v24(v93.RagingBlow, not v101) or (2408 < 2109)) then
						return "raging_blow multi_target 30";
					end
				end
				if ((v93['CrushingBlow']:IsCastable() and v37 and (v93['CrushingBlow']:Charges() > 1) and v93['WrathandFury']:IsAvailable()) or (33 == 1455)) then
					if (v24(v93.CrushingBlow, not v101) or (443 >= 4015)) then
						return "crushing_blow multi_target 32";
					end
				end
				if ((3382 > 166) and v93['Bloodbath']:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93['WrathandFury']:IsAvailable())) then
					if (v24(v93.Bloodbath, not v101) or (280 == 3059)) then
						return "bloodbath multi_target 34";
					end
				end
				if ((1881 > 1293) and v93['CrushingBlow']:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93['RecklessAbandon']:IsAvailable()) then
					if ((2357 == 2357) and v24(v93.CrushingBlow, not v101)) then
						return "crushing_blow multi_target 36";
					end
				end
				v123 = 5;
			end
			if ((123 == 123) and (v123 == 2)) then
				if ((v93['CrushingBlow']:IsCastable() and v93['WrathandFury']:IsAvailable() and v37 and v14:BuffUp(v93.EnrageBuff)) or (1056 >= 3392)) then
					if (v24(v93.CrushingBlow, not v101) or (1081 < 1075)) then
						return "crushing_blow multi_target 14";
					end
				end
				if ((v93['Execute']:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) or (1049 >= 4432)) then
					if (v24(v93.Execute, not v101) or (4768 <= 846)) then
						return "execute multi_target 16";
					end
				end
				if ((v93['OdynsFury']:IsCastable() and ((v54 and v31) or not v54) and v40 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) or (3358 <= 1420)) then
					if (v24(v93.OdynsFury, not v15:IsInMeleeRange(v27)) or (3739 <= 3005)) then
						return "odyns_fury multi_target 18";
					end
				end
				if ((v93['Rampage']:IsReady() and v43 and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or ((v14:Rage() > 110) and v93['OverwhelmingRage']:IsAvailable()) or ((v14:Rage() > 80) and not v93['OverwhelmingRage']:IsAvailable()))) or (1659 >= 2134)) then
					if (v24(v93.Rampage, not v101) or (3260 < 2355)) then
						return "rampage multi_target 20";
					end
				end
				v123 = 3;
			end
			if ((v123 == 0) or (669 == 4223)) then
				if ((v93['Recklessness']:IsCastable() and ((v56 and v31) or not v56) and v45 and (v91 < v98) and ((v100 > 1) or (v98 < 12))) or (1692 < 588)) then
					if (v24(v93.Recklessness, not v101) or (4797 < 3651)) then
						return "recklessness multi_target 2";
					end
				end
				if ((v93['OdynsFury']:IsCastable() and ((v54 and v31) or not v54) and v40 and (v91 < v98) and (v100 > 1) and v93['TitanicRage']:IsAvailable() and (v14:BuffDown(v93.MeatCleaverBuff) or v14:BuffUp(v93.AvatarBuff) or v14:BuffUp(v93.RecklessnessBuff))) or (4177 > 4850)) then
					if (v24(v93.OdynsFury, not v15:IsInMeleeRange(v27)) or (400 > 1111)) then
						return "odyns_fury multi_target 4";
					end
				end
				if ((3051 > 1005) and v93['Whirlwind']:IsCastable() and v49 and (v100 > 1) and v93['ImprovedWhilwind']:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) then
					if ((3693 <= 4382) and v24(v93.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return "whirlwind multi_target 6";
					end
				end
				if ((v93['Execute']:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) or (3282 > 4100)) then
					if (v24(v93.Execute, not v101) or (3580 < 2844)) then
						return "execute multi_target 8";
					end
				end
				v123 = 1;
			end
			if ((89 < 4490) and (5 == v123)) then
				if ((v93['Bloodthirst']:IsCastable() and v35 and not v93['WrathandFury']:IsAvailable()) or (4983 < 1808)) then
					if ((3829 > 3769) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst multi_target 38";
					end
				end
				if ((1485 <= 2904) and v93['RagingBlow']:IsCastable() and v42 and (v93['RagingBlow']:Charges() > 1)) then
					if ((4269 == 4269) and v24(v93.RagingBlow, not v101)) then
						return "raging_blow multi_target 40";
					end
				end
				if ((387 <= 2782) and v93['Rampage']:IsReady() and v43) then
					if (v24(v93.Rampage, not v101) or (1899 <= 917)) then
						return "rampage multi_target 42";
					end
				end
				if ((v93['Slam']:IsReady() and v46 and (v93['Annihilator']:IsAvailable())) or (4312 <= 876)) then
					if ((2232 <= 2596) and v24(v93.Slam, not v101)) then
						return "slam multi_target 44";
					end
				end
				v123 = 6;
			end
			if ((2095 < 3686) and (3 == v123)) then
				if ((v93['Execute']:IsReady() and v38) or (1595 >= 4474)) then
					if (v24(v93.Execute, not v101) or (4619 < 2882)) then
						return "execute multi_target 22";
					end
				end
				if ((v93['Bloodbath']:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93['RecklessAbandon']:IsAvailable() and not v93['WrathandFury']:IsAvailable()) or (294 >= 4831)) then
					if ((2029 <= 3084) and v24(v93.Bloodbath, not v101)) then
						return "bloodbath multi_target 24";
					end
				end
				if ((v93['Bloodthirst']:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93['Annihilator']:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff)))) or (2037 == 2420)) then
					if ((4458 > 3904) and v24(v93.Bloodthirst, not v101)) then
						return "bloodthirst multi_target 26";
					end
				end
				if ((436 >= 123) and v93['Onslaught']:IsReady() and v41 and ((not v93['Annihilator']:IsAvailable() and v14:BuffUp(v93.EnrageBuff)) or v93['Tenderize']:IsAvailable())) then
					if ((500 < 1816) and v24(v93.Onslaught, not v101)) then
						return "onslaught multi_target 28";
					end
				end
				v123 = 4;
			end
			if ((3574 == 3574) and (v123 == 1)) then
				if ((221 < 390) and v93['ThunderousRoar']:IsCastable() and ((v58 and v31) or not v58) and v48 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) then
					if (v24(v93.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (2213 <= 1421)) then
						return "thunderous_roar multi_target 10";
					end
				end
				if ((3058 < 4860) and v93['OdynsFury']:IsCastable() and ((v54 and v31) or not v54) and v40 and (v91 < v98) and (v100 > 1) and v14:BuffUp(v93.EnrageBuff)) then
					if (v24(v93.OdynsFury, not v15:IsInMeleeRange(v27)) or (1296 >= 4446)) then
						return "odyns_fury multi_target 12";
					end
				end
				v124 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * 20) + (v14:BuffStack(v93.MercilessAssaultBuff) * 10) + (v14:BuffStack(v93.BloodcrazeBuff) * 15);
				if (((v124 >= 95) and v14:HasTier(30, 4)) or (1393 > 4489)) then
					local v182 = 0;
					while true do
						if ((v182 == 0) or (4424 < 27)) then
							if ((v93['Bloodbath']:IsCastable() and v34) or (1997 > 3815)) then
								if ((3465 > 1913) and v24(v93.Bloodbath, not v101)) then
									return "bloodbath multi_target 14";
								end
							end
							if ((733 < 1819) and v93['Bloodthirst']:IsCastable() and v35) then
								if (v24(v93.Bloodthirst, not v101) or (4395 == 4755)) then
									return "bloodthirst multi_target 16";
								end
							end
							break;
						end
					end
				end
				v123 = 2;
			end
		end
	end
	local function v108()
		local v125 = 0;
		while true do
			if ((v125 == 1) or (3793 < 2369)) then
				if (v86 or (4084 == 265)) then
					local v183 = 0;
					while true do
						if ((4358 == 4358) and (0 == v183)) then
							v28 = v92.HandleIncorporeal(v93.StormBolt, v95.StormBoltMouseover, 20, true);
							if (v28 or (3138 < 993)) then
								return v28;
							end
							v183 = 1;
						end
						if ((3330 > 2323) and (v183 == 1)) then
							v28 = v92.HandleIncorporeal(v93.IntimidatingShout, v95.IntimidatingShoutMouseover, 8, true);
							if (v28 or (3626 == 3989)) then
								return v28;
							end
							break;
						end
					end
				end
				if (v92.TargetIsValid() or (916 == 2671)) then
					local v184 = 0;
					local v185;
					while true do
						if ((272 == 272) and (v184 == 0)) then
							if ((4249 <= 4839) and v36 and v93['Charge']:IsCastable()) then
								if ((2777 < 3200) and v24(v93.Charge, not v15:IsSpellInRange(v93.Charge))) then
									return "charge main 2";
								end
							end
							v185 = v92.HandleDPSPotion(v15:BuffUp(v93.RecklessnessBuff));
							if ((95 < 1957) and v185) then
								return v185;
							end
							if ((826 < 1717) and (v91 < v98)) then
								if ((1426 >= 1105) and v52 and ((v31 and v60) or not v60)) then
									local v195 = 0;
									while true do
										if ((2754 <= 3379) and (v195 == 0)) then
											v28 = v104();
											if (v28 or (3927 == 1413)) then
												return v28;
											end
											break;
										end
									end
								end
							end
							v184 = 1;
						end
						if ((1 == v184) or (1154 <= 788)) then
							if (((v91 < v98) and v51 and ((v59 and v31) or not v59)) or (1643 > 3379)) then
								local v192 = 0;
								while true do
									if ((v192 == 1) or (2803 > 4549)) then
										if ((v93['LightsJudgment']:IsCastable() and v14:BuffDown(v93.RecklessnessBuff)) or (220 >= 3022)) then
											if ((2822 == 2822) and v24(v93.LightsJudgment, not v15:IsSpellInRange(v93.LightsJudgment))) then
												return "lights_judgment main 16";
											end
										end
										if (v93['Fireblood']:IsCastable() or (1061 == 1857)) then
											if ((2760 > 1364) and v24(v93.Fireblood, not v101)) then
												return "fireblood main 18";
											end
										end
										v192 = 2;
									end
									if ((v192 == 2) or (4902 <= 3595)) then
										if (v93['AncestralCall']:IsCastable() or (3852 == 293)) then
											if (v24(v93.AncestralCall, not v101) or (1559 == 4588)) then
												return "ancestral_call main 20";
											end
										end
										if ((v93['BagofTricks']:IsCastable() and v14:BuffDown(v93.RecklessnessBuff) and v14:BuffUp(v93.EnrageBuff)) or (4484 == 788)) then
											if ((4568 >= 3907) and v22(v93.BagofTricks, not v15:IsSpellInRange(v93.BagofTricks))) then
												return "bag_of_tricks main 22";
											end
										end
										break;
									end
									if ((1246 < 3470) and (v192 == 0)) then
										if ((4068 >= 972) and v93['BloodFury']:IsCastable()) then
											if ((493 < 3893) and v24(v93.BloodFury, not v101)) then
												return "blood_fury main 12";
											end
										end
										if ((v93['Berserking']:IsCastable() and v14:BuffUp(v93.RecklessnessBuff)) or (1473 >= 3332)) then
											if (v24(v93.Berserking, not v101) or (4051 <= 1157)) then
												return "berserking main 14";
											end
										end
										v192 = 1;
									end
								end
							end
							if ((604 < 2881) and (v91 < v98)) then
								local v193 = 0;
								while true do
									if ((v193 == 1) or (900 == 3377)) then
										if ((4459 > 591) and v93['Recklessness']:IsCastable() and v45 and ((v56 and v31) or not v56) and (not v93['Annihilator']:IsAvailable() or (v10.FightRemains() < 12))) then
											if ((3398 >= 2395) and v24(v93.Recklessness, not v101)) then
												return "recklessness main 27";
											end
										end
										if ((v93['Ravager']:IsCastable() and (v84 == "player") and v44 and ((v55 and v31) or not v55) and ((v93['Avatar']:CooldownRemains() < 3) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < 10))) or (2183 >= 2824)) then
											if ((1936 == 1936) and v24(v95.RavagerPlayer, not v101)) then
												return "ravager main 28";
											end
										end
										v193 = 2;
									end
									if ((v193 == 3) or (4832 < 4313)) then
										if ((4088 > 3874) and v93['SpearofBastion']:IsCastable() and (v85 == "cursor") and v47 and ((v57 and v31) or not v57) and v14:BuffUp(v93.EnrageBuff) and (v14:BuffUp(v93.RecklessnessBuff) or v14:BuffUp(v93.AvatarBuff) or (v98 < 20) or (v100 > 1) or not v93['TitansTorment']:IsAvailable() or not v14:HasTier(31, 2))) then
											if ((4332 == 4332) and v24(v95.SpearOfBastionCursor, not v101)) then
												return "spear_of_bastion main 31";
											end
										end
										break;
									end
									if ((3999 >= 2900) and (v193 == 2)) then
										if ((v93['Ravager']:IsCastable() and (v84 == "cursor") and v44 and ((v55 and v31) or not v55) and ((v93['Avatar']:CooldownRemains() < 3) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < 10))) or (2525 > 4064)) then
											if ((4371 == 4371) and v24(v95.RavagerCursor, not v101)) then
												return "ravager main 28";
											end
										end
										if ((v93['SpearofBastion']:IsCastable() and (v85 == "player") and v47 and ((v57 and v31) or not v57) and v14:BuffUp(v93.EnrageBuff) and (v14:BuffUp(v93.RecklessnessBuff) or v14:BuffUp(v93.AvatarBuff) or (v98 < 20) or (v100 > 1) or not v93['TitansTorment']:IsAvailable() or not v14:HasTier(31, 2))) or (266 > 4986)) then
											if ((1991 >= 925) and v24(v95.SpearOfBastionPlayer, not v101)) then
												return "spear_of_bastion main 30";
											end
										end
										v193 = 3;
									end
									if ((455 < 2053) and (v193 == 0)) then
										if ((v93['Avatar']:IsCastable() and v32 and ((v53 and v31) or not v53) and ((v93['TitansTorment']:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.AvatarBuff) and (v93['OdynsFury']:CooldownRemains() > 0)) or (v93['BerserkersTorment']:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.AvatarBuff)) or (not v93['TitansTorment']:IsAvailable() and not v93['BerserkersTorment']:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v98 < 20))))) or (826 == 4851)) then
											if ((183 == 183) and v24(v93.Avatar, not v101)) then
												return "avatar main 24";
											end
										end
										if ((1159 <= 1788) and v93['Recklessness']:IsCastable() and v45 and ((v56 and v31) or not v56) and ((v93['Annihilator']:IsAvailable() and (v93['Avatar']:CooldownRemains() < 1)) or (v93['Avatar']:CooldownRemains() > 40) or not v93['Avatar']:IsAvailable() or (v98 < 12))) then
											if (v24(v93.Recklessness, not v101) or (3507 > 4318)) then
												return "recklessness main 26";
											end
										end
										v193 = 1;
									end
								end
							end
							if ((v39 and v93['HeroicThrow']:IsCastable() and not v15:IsInRange(30)) or (3075 <= 2965)) then
								if ((1365 <= 2011) and v24(v93.HeroicThrow, not v15:IsInRange(30))) then
									return "heroic_throw main";
								end
							end
							if ((v93['WreckingThrow']:IsCastable() and v50 and v15:AffectingCombat() and v102()) or (2776 > 3575)) then
								if (v24(v93.WreckingThrow, not v15:IsInRange(30)) or (2554 == 4804)) then
									return "wrecking_throw main";
								end
							end
							v184 = 2;
						end
						if ((2577 == 2577) and (v184 == 2)) then
							if ((v30 and (v100 > 2)) or (6 >= 1889)) then
								local v194 = 0;
								while true do
									if ((506 <= 1892) and (v194 == 0)) then
										v28 = v107();
										if (v28 or (2008 > 2218)) then
											return v28;
										end
										break;
									end
								end
							end
							v28 = v106();
							if ((379 <= 4147) and v28) then
								return v28;
							end
							if (v20.CastAnnotated(v93.Pool, false, "WAIT") or (4514 <= 1009)) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if ((v125 == 0) or (3496 == 1192)) then
				v28 = v103();
				if (v28 or (208 == 2959)) then
					return v28;
				end
				v125 = 1;
			end
		end
	end
	local function v109()
		local v126 = 0;
		while true do
			if ((4277 >= 1313) and (v126 == 0)) then
				if ((2587 < 3174) and not v14:AffectingCombat()) then
					local v186 = 0;
					while true do
						if ((v186 == 0) or (4120 <= 2198)) then
							if ((v93['BerserkerStance']:IsCastable() and v14:BuffDown(v93.BerserkerStance, true)) or (1596 == 858)) then
								if ((3220 == 3220) and v24(v93.BerserkerStance)) then
									return "berserker_stance";
								end
							end
							if ((v93['BattleShout']:IsCastable() and v33 and (v14:BuffDown(v93.BattleShoutBuff, true) or v92.GroupBuffMissing(v93.BattleShoutBuff))) or (1402 > 3620)) then
								if ((2574 == 2574) and v24(v93.BattleShout)) then
									return "battle_shout precombat";
								end
							end
							break;
						end
					end
				end
				if ((1798 < 2757) and v92.TargetIsValid() and v29) then
					if (not v14:AffectingCombat() or (377 > 2604)) then
						local v189 = 0;
						while true do
							if ((568 < 911) and (v189 == 0)) then
								v28 = v105();
								if ((3285 < 4228) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v110()
		local v127 = 0;
		while true do
			if ((3916 > 3328) and (v127 == 4)) then
				v50 = EpicSettings['Settings']['useWreckingThrow'];
				v32 = EpicSettings['Settings']['useAvatar'];
				v40 = EpicSettings['Settings']['useOdynsFury'];
				v127 = 5;
			end
			if ((2500 < 3839) and (v127 == 1)) then
				v36 = EpicSettings['Settings']['useCharge'];
				v37 = EpicSettings['Settings']['useCrushingBlow'];
				v38 = EpicSettings['Settings']['useExecute'];
				v127 = 2;
			end
			if ((507 == 507) and (v127 == 6)) then
				v48 = EpicSettings['Settings']['useThunderousRoar'];
				v53 = EpicSettings['Settings']['avatarWithCD'];
				v54 = EpicSettings['Settings']['odynFuryWithCD'];
				v127 = 7;
			end
			if ((240 <= 3165) and (v127 == 0)) then
				v33 = EpicSettings['Settings']['useBattleShout'];
				v34 = EpicSettings['Settings']['useBloodbath'];
				v35 = EpicSettings['Settings']['useBloodthirst'];
				v127 = 1;
			end
			if ((834 >= 805) and (v127 == 3)) then
				v43 = EpicSettings['Settings']['useRampage'];
				v46 = EpicSettings['Settings']['useSlam'];
				v49 = EpicSettings['Settings']['useWhirlwind'];
				v127 = 4;
			end
			if ((v127 == 5) or (3812 < 2316)) then
				v44 = EpicSettings['Settings']['useRavager'];
				v45 = EpicSettings['Settings']['useRecklessness'];
				v47 = EpicSettings['Settings']['useSpearOfBastion'];
				v127 = 6;
			end
			if ((v127 == 8) or (2652 <= 1533)) then
				v58 = EpicSettings['Settings']['thunderousRoarWithCD'];
				break;
			end
			if ((v127 == 2) or (3598 < 1460)) then
				v39 = EpicSettings['Settings']['useHeroicThrow'];
				v41 = EpicSettings['Settings']['useOnslaught'];
				v42 = EpicSettings['Settings']['useRagingBlow'];
				v127 = 3;
			end
			if ((v127 == 7) or (4116 < 1192)) then
				v55 = EpicSettings['Settings']['ravagerWithCD'];
				v56 = EpicSettings['Settings']['recklessnessWithCD'];
				v57 = EpicSettings['Settings']['spearOfBastionWithCD'];
				v127 = 8;
			end
		end
	end
	local function v111()
		local v128 = 0;
		while true do
			if ((v128 == 1) or (3377 <= 903)) then
				v65 = EpicSettings['Settings']['useEnragedRegeneration'];
				v66 = EpicSettings['Settings']['useIgnorePain'];
				v67 = EpicSettings['Settings']['useRallyingCry'];
				v68 = EpicSettings['Settings']['useIntervene'];
				v128 = 2;
			end
			if ((3976 >= 439) and (v128 == 0)) then
				v61 = EpicSettings['Settings']['usePummel'];
				v62 = EpicSettings['Settings']['useStormBolt'];
				v63 = EpicSettings['Settings']['useIntimidatingShout'];
				v64 = EpicSettings['Settings']['useBitterImmunity'];
				v128 = 1;
			end
			if ((3752 == 3752) and (v128 == 3)) then
				v75 = EpicSettings['Settings']['ignorePainHP'] or 0;
				v76 = EpicSettings['Settings']['rallyingCryHP'] or 0;
				v77 = EpicSettings['Settings']['rallyingCryGroup'] or 0;
				v78 = EpicSettings['Settings']['interveneHP'] or 0;
				v128 = 4;
			end
			if ((4046 > 2695) and (v128 == 5)) then
				v85 = EpicSettings['Settings']['spearSetting'] or "player";
				break;
			end
			if ((v128 == 2) or (3545 == 3197)) then
				v69 = EpicSettings['Settings']['useDefensiveStance'];
				v72 = EpicSettings['Settings']['useVictoryRush'];
				v73 = EpicSettings['Settings']['bitterImmunityHP'] or 0;
				v74 = EpicSettings['Settings']['enragedRegenerationHP'] or 0;
				v128 = 3;
			end
			if ((2394 > 373) and (v128 == 4)) then
				v79 = EpicSettings['Settings']['defensiveStanceHP'] or 0;
				v82 = EpicSettings['Settings']['unstanceHP'] or 0;
				v83 = EpicSettings['Settings']['victoryRushHP'] or 0;
				v84 = EpicSettings['Settings']['ravagerSetting'] or "player";
				v128 = 5;
			end
		end
	end
	local function v112()
		local v129 = 0;
		while true do
			if ((4155 <= 4232) and (v129 == 1)) then
				v52 = EpicSettings['Settings']['useTrinkets'];
				v51 = EpicSettings['Settings']['useRacials'];
				v60 = EpicSettings['Settings']['trinketsWithCD'];
				v59 = EpicSettings['Settings']['racialsWithCD'];
				v129 = 2;
			end
			if ((v129 == 3) or (3581 == 3473)) then
				v87 = EpicSettings['Settings']['HealingPotionName'] or "";
				v86 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
			if ((4995 > 3348) and (v129 == 2)) then
				v70 = EpicSettings['Settings']['useHealthstone'];
				v71 = EpicSettings['Settings']['useHealingPotion'];
				v80 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v81 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v129 = 3;
			end
			if ((v129 == 0) or (754 > 3724)) then
				v91 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v88 = EpicSettings['Settings']['InterruptWithStun'];
				v89 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v90 = EpicSettings['Settings']['InterruptThreshold'];
				v129 = 1;
			end
		end
	end
	local function v113()
		local v130 = 0;
		while true do
			if ((217 >= 57) and (v130 == 0)) then
				v111();
				v110();
				v112();
				v29 = EpicSettings['Toggles']['ooc'];
				v130 = 1;
			end
			if ((v130 == 1) or (2070 >= 4037)) then
				v30 = EpicSettings['Toggles']['aoe'];
				v31 = EpicSettings['Toggles']['cds'];
				if ((2705 == 2705) and v14:IsDeadOrGhost()) then
					return;
				end
				if ((61 == 61) and v93['IntimidatingShout']:IsAvailable()) then
					v27 = 8;
				end
				v130 = 2;
			end
			if ((v130 == 2) or (699 >= 1296)) then
				if (v30 or (1783 >= 3616)) then
					local v187 = 0;
					while true do
						if ((0 == v187) or (3913 > 4527)) then
							v99 = v14:GetEnemiesInMeleeRange(v27);
							v100 = #v99;
							break;
						end
					end
				else
					v100 = 1;
				end
				v101 = v15:IsInMeleeRange(5);
				if ((4376 > 817) and (v92.TargetIsValid() or v14:AffectingCombat())) then
					local v188 = 0;
					while true do
						if ((4861 > 824) and (v188 == 0)) then
							v97 = v10.BossFightRemains(nil, true);
							v98 = v97;
							v188 = 1;
						end
						if ((v188 == 1) or (1383 >= 2131)) then
							if ((v98 == 11111) or (1876 >= 2541)) then
								v98 = v10.FightRemains(v99, false);
							end
							break;
						end
					end
				end
				if ((1782 <= 3772) and not v14:IsChanneling()) then
					if (v14:AffectingCombat() or (4700 < 813)) then
						local v190 = 0;
						while true do
							if ((3199 < 4050) and (0 == v190)) then
								v28 = v108();
								if (v28 or (4951 < 4430)) then
									return v28;
								end
								break;
							end
						end
					else
						local v191 = 0;
						while true do
							if ((96 == 96) and (0 == v191)) then
								v28 = v109();
								if (v28 or (2739 > 4008)) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v114()
		v20.Print("Fury Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(72, v113, v114);
end;
return v0["Epix_Warrior_Fury.lua"]();

