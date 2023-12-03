local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((v5 == 0) or (1667 >= 3291)) then
			v6 = v0[v4];
			if (not v6 or (873 == 2034)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (2816 < 11)) then
			return v6(...);
		end
	end
end
v0["Epix_Warrior_Arms.lua"] = function(...)
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
	local v92;
	local v93;
	local v94 = v10['Commons']['Everyone'];
	local v95 = v14:GetEquipment();
	local v96 = (v95[13] and v19(v95[13])) or v19(0);
	local v97 = (v95[14] and v19(v95[14])) or v19(0);
	local v98 = v18['Warrior']['Arms'];
	local v99 = v19['Warrior']['Arms'];
	local v100 = v23['Warrior']['Arms'];
	local v101 = {};
	local v102;
	local v103 = 11111;
	local v104 = 11111;
	v10:RegisterForEvent(function()
		local v124 = 0;
		while true do
			if ((3699 < 4706) and (v124 == 0)) then
				v103 = 11111;
				v104 = 11111;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v125 = 0;
		while true do
			if ((2646 >= 876) and (v125 == 1)) then
				v97 = (v95[14] and v19(v95[14])) or v19(0);
				break;
			end
			if ((614 <= 3184) and (v125 == 0)) then
				v95 = v14:GetEquipment();
				v96 = (v95[13] and v19(v95[13])) or v19(0);
				v125 = 1;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	local v105;
	local v106;
	local function v107()
		local v126 = 0;
		local v127;
		while true do
			if ((3126 == 3126) and (v126 == 0)) then
				v127 = UnitGetTotalAbsorbs(v15);
				if ((v127 > 0) or (2187 >= 4954)) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v108(v128)
		return (v128:HealthPercentage() > 20) or (v98['Massacre']:IsAvailable() and (v128:HealthPercentage() < 35));
	end
	local function v109(v129)
		return (v129:DebuffStack(v98.ExecutionersPrecisionDebuff) == 2) or (v129:DebuffRemains(v98.DeepWoundsDebuff) <= v14:GCD()) or (v98['Dreadnaught']:IsAvailable() and v98['Battlelord']:IsAvailable() and (v106 <= 2));
	end
	local function v110(v130)
		return v14:BuffUp(v98.SuddenDeathBuff) or ((v106 <= 2) and ((v130:HealthPercentage() < 20) or (v98['Massacre']:IsAvailable() and (v130:HealthPercentage() < 35)))) or v14:BuffUp(v98.SweepingStrikes);
	end
	local function v111()
		local v131 = 0;
		while true do
			if ((2 == v131) or (3877 == 3575)) then
				if ((707 > 632) and v98['Intervene']:IsCastable() and v68 and (v17:HealthPercentage() <= v78) and (v17:UnitName() ~= v14:UnitName())) then
					if (v24(v100.InterveneFocus) or (546 >= 2684)) then
						return "intervene defensive";
					end
				end
				if ((1465 <= 4301) and v98['DefensiveStance']:IsCastable() and v14:BuffDown(v98.DefensiveStance, true) and v69 and (v14:HealthPercentage() <= v79)) then
					if ((1704 > 1425) and v24(v98.DefensiveStance)) then
						return "defensive_stance defensive";
					end
				end
				v131 = 3;
			end
			if ((0 == v131) or (687 == 4234)) then
				if ((v98['BitterImmunity']:IsReady() and v64 and (v14:HealthPercentage() <= v73)) or (3330 < 1429)) then
					if ((1147 >= 335) and v24(v98.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if ((3435 > 2097) and v98['DieByTheSword']:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) then
					if (v24(v98.DieByTheSword) or (3770 >= 4041)) then
						return "die_by_the_sword defensive";
					end
				end
				v131 = 1;
			end
			if ((v131 == 4) or (3791 <= 1611)) then
				if ((v71 and (v14:HealthPercentage() <= v81)) or (4578 <= 2008)) then
					local v194 = 0;
					while true do
						if ((1125 <= 2076) and (v194 == 0)) then
							if ((v87 == "Refreshing Healing Potion") or (743 >= 4399)) then
								if ((1155 < 1673) and v99['RefreshingHealingPotion']:IsReady()) then
									if (v24(v100.RefreshingHealingPotion) or (2324 <= 578)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((3767 == 3767) and (v87 == "Dreamwalker's Healing Potion")) then
								if ((4089 == 4089) and v99['DreamwalkersHealingPotion']:IsReady()) then
									if ((4458 >= 1674) and v24(v100.RefreshingHealingPotion)) then
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
			if ((972 <= 1418) and (v131 == 1)) then
				if ((v98['IgnorePain']:IsCastable() and v66 and (v14:HealthPercentage() <= v75)) or (4938 < 4762)) then
					if (v24(v98.IgnorePain, nil, nil, true) or (2504 > 4264)) then
						return "ignore_pain defensive";
					end
				end
				if ((2153 == 2153) and v98['RallyingCry']:IsCastable() and v67 and v14:BuffDown(v98.AspectsFavorBuff) and v14:BuffDown(v98.RallyingCry) and (((v14:HealthPercentage() <= v76) and v94.IsSoloMode()) or v94.AreUnitsBelowHealthPercentage(v76, v77))) then
					if (v24(v98.RallyingCry) or (507 >= 2591)) then
						return "rallying_cry defensive";
					end
				end
				v131 = 2;
			end
			if ((4481 == 4481) and (v131 == 3)) then
				if ((v98['BattleStance']:IsCastable() and v14:BuffDown(v98.BattleStance, true) and v69 and (v14:HealthPercentage() > v82)) or (2328 < 693)) then
					if ((4328 == 4328) and v24(v98.BattleStance)) then
						return "battle_stance after defensive stance defensive";
					end
				end
				if ((1588 >= 1332) and v99['Healthstone']:IsReady() and v70 and (v14:HealthPercentage() <= v80)) then
					if (v24(v100.Healthstone) or (4174 > 4248)) then
						return "healthstone defensive 3";
					end
				end
				v131 = 4;
			end
		end
	end
	local function v112()
		local v132 = 0;
		while true do
			if ((v132 == 1) or (4586 <= 82)) then
				v28 = v94.HandleBottomTrinket(v101, v31, 40, nil);
				if ((3863 == 3863) and v28) then
					return v28;
				end
				break;
			end
			if ((v132 == 0) or (282 <= 42)) then
				v28 = v94.HandleTopTrinket(v101, v31, 40, nil);
				if ((4609 >= 766) and v28) then
					return v28;
				end
				v132 = 1;
			end
		end
	end
	local function v113()
		local v133 = 0;
		while true do
			if ((0 == v133) or (1152 == 2488)) then
				if ((3422 > 3350) and v102) then
					local v195 = 0;
					while true do
						if ((877 > 376) and (v195 == 0)) then
							if ((v98['Skullsplitter']:IsCastable() and v45) or (3118 <= 1851)) then
								if (v24(v98.Skullsplitter) or (165 >= 3492)) then
									return "skullsplitter precombat";
								end
							end
							if ((3949 < 4856) and (v91 < v104) and v98['ColossusSmash']:IsCastable() and v37 and ((v55 and v31) or not v55)) then
								if (v24(v98.ColossusSmash) or (4276 < 3016)) then
									return "colossus_smash precombat";
								end
							end
							v195 = 1;
						end
						if ((4690 > 4125) and (v195 == 1)) then
							if (((v91 < v104) and v98['Warbreaker']:IsCastable() and v50 and ((v58 and v31) or not v58)) or (50 >= 896)) then
								if (v24(v98.Warbreaker) or (1714 >= 2958)) then
									return "warbreaker precombat";
								end
							end
							if ((v98['Overpower']:IsCastable() and v41) or (1491 < 644)) then
								if ((704 < 987) and v24(v98.Overpower)) then
									return "overpower precombat";
								end
							end
							break;
						end
					end
				end
				if ((3718 > 1906) and v35 and v98['Charge']:IsCastable()) then
					if (v24(v98.Charge) or (958 > 3635)) then
						return "charge precombat";
					end
				end
				break;
			end
		end
	end
	local function v114()
		local v134 = 0;
		while true do
			if ((3501 <= 4492) and (v134 == 0)) then
				if ((v98['Execute']:IsReady() and v38 and v14:BuffUp(v98.JuggernautBuff) and (v14:BuffRemains(v98.JuggernautBuff) < v14:GCD())) or (3442 < 2548)) then
					if ((2875 >= 1464) and v24(v98.Execute, not v102)) then
						return "execute hac 67";
					end
				end
				if ((v98['ThunderClap']:IsReady() and v48 and (v106 > 2) and v98['BloodandThunder']:IsAvailable() and v98['Rend']:IsAvailable() and v15:DebuffRefreshable(v98.RendDebuff)) or (4797 >= 4893)) then
					if (v24(v98.ThunderClap, not v102) or (551 > 2068)) then
						return "thunder_clap hac 68";
					end
				end
				if ((2114 > 944) and v98['SweepingStrikes']:IsCastable() and v47 and (v106 >= 2) and ((v98['Bladestorm']:CooldownRemains() > 15) or not v98['Bladestorm']:IsAvailable())) then
					if (v24(v98.SweepingStrikes, not v15:IsInMeleeRange(v27)) or (2262 >= 3096)) then
						return "sweeping_strikes hac 68";
					end
				end
				if ((v98['Rend']:IsReady() and v42 and (v106 == 1) and ((v15:HealthPercentage() > 20) or (v98['Massacre']:IsAvailable() and (v15:HealthPercentage() < 35)))) or (v98['TideofBlood']:IsAvailable() and (v98['Skullsplitter']:CooldownRemains() <= v14:GCD()) and ((v98['ColossusSmash']:CooldownRemains() < v14:GCD()) or v15:DebuffUp(v98.ColossusSmashDebuff)) and (v15:DebuffRemains(v98.RendDebuff) < (21 * 0.85))) or (2255 >= 3537)) then
					if (v24(v98.Rend, not v102) or (3837 < 1306)) then
						return "rend hac 70";
					end
				end
				if ((2950 == 2950) and (v91 < v104) and v32 and ((v53 and v31) or not v53) and v98['Avatar']:IsCastable()) then
					if (v24(v98.Avatar, not v102) or (4723 < 3298)) then
						return "avatar hac 71";
					end
				end
				if ((1136 >= 154) and (v91 < v104) and v98['Warbreaker']:IsCastable() and v50 and ((v58 and v31) or not v58) and (v106 > 1)) then
					if (v24(v98.Warbreaker, not v102) or (271 > 4748)) then
						return "warbreaker hac 72";
					end
				end
				v134 = 1;
			end
			if ((4740 >= 3152) and (v134 == 3)) then
				if ((v98['MortalStrike']:IsReady() and v40) or (2578 >= 3390)) then
					if ((41 <= 1661) and v94.CastCycle(v98.MortalStrike, v105, v109, not v102)) then
						return "mortal_strike hac 83";
					end
				end
				if ((601 < 3560) and v98['Execute']:IsReady() and v38 and (v14:BuffUp(v98.SuddenDeathBuff) or ((v106 <= 2) and ((v15:HealthPercentage() < 20) or (v98['Massacre']:IsAvailable() and (v15:HealthPercentage() < 35)))) or v14:BuffUp(v98.SweepingStrikes))) then
					if ((235 < 687) and v94.CastCycle(v98.Execute, v105, v110, not v102)) then
						return "execute hac 84";
					end
				end
				if ((4549 > 1153) and (v91 < v104) and v49 and ((v57 and v31) or not v57) and v98['ThunderousRoar']:IsCastable()) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (4674 < 4672)) then
						return "thunderous_roar hac 85";
					end
				end
				if ((3668 < 4561) and v98['Shockwave']:IsCastable() and v44 and (v106 > 2) and (v98['SonicBoom']:IsAvailable() or v15:IsCasting())) then
					if (v24(v98.Shockwave, not v15:IsInMeleeRange(v27)) or (455 == 3605)) then
						return "shockwave hac 86";
					end
				end
				if ((v98['Overpower']:IsCastable() and v41 and (v106 == 1) and (((v98['Overpower']:Charges() == 2) and not v98['Battlelord']:IsAvailable() and (v15:Debuffdown(v98.ColossusSmashDebuff) or (v14:RagePercentage() < 25))) or v98['Battlelord']:IsAvailable())) or (2663 == 3312)) then
					if ((4277 <= 4475) and v24(v98.Overpower, not v102)) then
						return "overpower hac 87";
					end
				end
				if ((v98['Slam']:IsReady() and v46 and (v106 == 1) and not v98['Battlelord']:IsAvailable() and (v14:RagePercentage() > 70)) or (870 == 1189)) then
					if ((1553 <= 3133) and v24(v98.Slam, not v102)) then
						return "slam hac 88";
					end
				end
				v134 = 4;
			end
			if ((v134 == 4) or (2237 >= 3511)) then
				if ((v98['Overpower']:IsCastable() and v41 and (((v98['Overpower']:Charges() == 2) and (not v98['TestofMight']:IsAvailable() or (v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or v98['Battlelord']:IsAvailable())) or (v14:Rage() < 70))) or (1324 > 3020)) then
					if (v24(v98.Overpower, not v102) or (2992 == 1881)) then
						return "overpower hac 89";
					end
				end
				if ((3106 > 1526) and v98['ThunderClap']:IsReady() and v48 and (v106 > 2)) then
					if ((3023 < 3870) and v24(v98.ThunderClap, not v102)) then
						return "thunder_clap hac 90";
					end
				end
				if ((143 > 74) and v98['MortalStrike']:IsReady() and v40) then
					if ((18 < 2112) and v24(v98.MortalStrike, not v102)) then
						return "mortal_strike hac 91";
					end
				end
				if ((1097 <= 1628) and v98['Rend']:IsReady() and v42 and (v106 == 1) and v15:DebuffRefreshable(v98.RendDebuff)) then
					if ((4630 == 4630) and v24(v98.Rend, not v102)) then
						return "rend hac 92";
					end
				end
				if ((3540 > 2683) and v98['Whirlwind']:IsReady() and v51 and (v98['StormofSwords']:IsAvailable() or (v98['FervorofBattle']:IsAvailable() and (v106 > 1)))) then
					if ((4794 >= 3275) and v24(v98.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return "whirlwind hac 93";
					end
				end
				if ((1484 == 1484) and v98['Cleave']:IsReady() and v36 and not v98['CrushingForce']:IsAvailable()) then
					if ((1432 < 3555) and v24(v98.Cleave, not v102)) then
						return "cleave hac 94";
					end
				end
				v134 = 5;
			end
			if ((v134 == 1) or (1065 > 3578)) then
				if (((v91 < v104) and v37 and ((v55 and v31) or not v55) and v98['ColossusSmash']:IsCastable()) or (4795 < 1407)) then
					if ((1853 < 4813) and v94.CastCycle(v98.ColossusSmash, v105, v108, not v102)) then
						return "colossus_smash hac 73";
					end
				end
				if (((v91 < v104) and v37 and ((v55 and v31) or not v55) and v98['ColossusSmash']:IsCastable()) or (2821 < 2431)) then
					if (v24(v98.ColossusSmash, not v102) or (2874 < 2181)) then
						return "colossus_smash hac 74";
					end
				end
				if (((v91 < v104) and v49 and ((v57 and v31) or not v57) and v98['ThunderousRoar']:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or ((v106 > 1) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0)))) or (2689 <= 343)) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (1869 == 2009)) then
						return "thunderous_roar hac 75";
					end
				end
				if (((v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == "player") and v98['SpearofBastion']:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or (3546 < 2322)) then
					if (v24(v100.SpearOfBastionPlayer, not v15:IsSpellInRange(v98.SpearofBastion)) or (2082 == 4773)) then
						return "spear_of_bastion hac 76";
					end
				end
				if ((3244 > 1055) and (v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == "cursor") and v98['SpearofBastion']:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if (v24(v100.SpearOfBastionCursor, not v15:IsSpellInRange(v98.SpearofBastion)) or (3313 <= 1778)) then
						return "spear_of_bastion hac 76";
					end
				end
				if (((v91 < v104) and v34 and ((v54 and v31) or not v54) and v98['Bladestorm']:IsCastable() and v98['Unhinged']:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or (1421 >= 2104)) then
					if ((1812 <= 3249) and v24(v98.Bladestorm, not v102)) then
						return "bladestorm hac 77";
					end
				end
				v134 = 2;
			end
			if ((1623 <= 1957) and (v134 == 5)) then
				if ((4412 == 4412) and v98['IgnorePain']:IsReady() and v66 and v98['Battlelord']:IsAvailable() and v98['AngerManagement']:IsAvailable() and (v14:Rage() > 30) and ((v15:HealthPercentage() < 20) or (v98['Massacre']:IsAvailable() and (v15:HealthPercentage() < 35)))) then
					if ((1750 >= 842) and v24(v98.IgnorePain, not v102)) then
						return "ignore_pain hac 95";
					end
				end
				if ((4372 > 1850) and v98['Slam']:IsReady() and v46 and v98['CrushingForce']:IsAvailable() and (v14:Rage() > 30) and ((v98['FervorofBattle']:IsAvailable() and (v106 == 1)) or not v98['FervorofBattle']:IsAvailable())) then
					if ((232 < 821) and v24(v98.Slam, not v102)) then
						return "slam hac 96";
					end
				end
				if ((518 < 902) and v98['Shockwave']:IsCastable() and v44 and (v98['SonicBoom']:IsAvailable())) then
					if ((2994 > 858) and v24(v98.Shockwave, not v15:IsInMeleeRange(v27))) then
						return "shockwave hac 97";
					end
				end
				if ((v31 and (v91 < v104) and v34 and ((v54 and v31) or not v54) and v98['Bladestorm']:IsCastable()) or (3755 <= 915)) then
					if ((3946 > 3743) and v24(v98.Bladestorm, not v102)) then
						return "bladestorm hac 98";
					end
				end
				break;
			end
			if ((v134 == 2) or (1335 >= 3306)) then
				if ((4844 > 2253) and (v91 < v104) and v34 and ((v54 and v31) or not v54) and v98['Bladestorm']:IsCastable() and (((v106 > 1) and (v14:BuffUp(v98.TestofMightBuff) or (not v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or ((v106 > 1) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0)))) then
					if ((452 == 452) and v24(v98.Bladestorm, not v102)) then
						return "bladestorm hac 78";
					end
				end
				if ((v98['Cleave']:IsReady() and v36 and ((v106 > 2) or (not v98['Battlelord']:IsAvailable() and v14:BuffUp(v98.MercilessBonegrinderBuff) and (v98['MortalStrike']:CooldownRemains() > v14:GCD())))) or (4557 < 2087)) then
					if ((3874 == 3874) and v24(v98.Cleave, not v102)) then
						return "cleave hac 79";
					end
				end
				if ((v98['Whirlwind']:IsReady() and v51 and ((v106 > 2) or (v98['StormofSwords']:IsAvailable() and (v14:BuffUp(v98.MercilessBonegrinderBuff) or v14:BuffUp(v98.HurricaneBuff))))) or (1938 > 4935)) then
					if (v24(v98.Whirlwind, not v15:IsInMeleeRange(v27)) or (4255 < 3423)) then
						return "whirlwind hac 80";
					end
				end
				if ((1454 <= 2491) and v98['Skullsplitter']:IsCastable() and v45 and ((v14:Rage() < 40) or (v98['TideofBlood']:IsAvailable() and (v15:DebuffRemains(v98.RendDebuff) > 0) and ((v14:BuffUp(v98.SweepingStrikes) and (v106 > 2)) or v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))))) then
					if (v24(v98.Skullsplitter, not v15:IsInMeleeRange(v27)) or (4157 <= 2803)) then
						return "sweeping_strikes execute 81";
					end
				end
				if ((4853 >= 2982) and v98['MortalStrike']:IsReady() and v40 and v14:BuffUp(v98.SweepingStrikes) and (v14:BuffStack(v98.CrushingAdvanceBuff) == 3)) then
					if ((4134 > 3357) and v24(v98.MortalStrike, not v102)) then
						return "mortal_strike hac 81.5";
					end
				end
				if ((v98['Overpower']:IsCastable() and v41 and v14:BuffUp(v98.SweepingStrikes) and v98['Dreadnaught']:IsAvailable()) or (3417 < 2534)) then
					if (v24(v98.Overpower, not v102) or (2722 <= 164)) then
						return "overpower hac 82";
					end
				end
				v134 = 3;
			end
		end
	end
	local function v115()
		local v135 = 0;
		while true do
			if ((v135 == 2) or (2408 < 2109)) then
				if ((v98['Skullsplitter']:IsCastable() and v45 and ((v98['TestofMight']:IsAvailable() and (v14:RagePercentage() <= 30)) or (not v98['TestofMight']:IsAvailable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v98['ColossusSmash']:CooldownRemains() > 5)) and (v14:RagePercentage() <= 30)))) or (33 == 1455)) then
					if (v24(v98.Skullsplitter, not v15:IsInMeleeRange(v27)) or (443 >= 4015)) then
						return "skullsplitter execute 57";
					end
				end
				if ((3382 > 166) and (v91 < v104) and v49 and ((v57 and v31) or not v57) and v98['ThunderousRoar']:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (280 == 3059)) then
						return "thunderous_roar execute 57";
					end
				end
				if ((1881 > 1293) and (v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == "player") and v98['SpearofBastion']:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) then
					if ((2357 == 2357) and v24(v100.SpearOfBastionPlayer, not v15:IsSpellInRange(v98.SpearofBastion))) then
						return "spear_of_bastion execute 57";
					end
				end
				v135 = 3;
			end
			if ((123 == 123) and (1 == v135)) then
				if (((v91 < v104) and v50 and ((v58 and v31) or not v58) and v98['Warbreaker']:IsCastable()) or (1056 >= 3392)) then
					if (v24(v98.Warbreaker, not v102) or (1081 < 1075)) then
						return "warbreaker execute 54";
					end
				end
				if (((v91 < v104) and v37 and ((v55 and v31) or not v55) and v98['ColossusSmash']:IsCastable()) or (1049 >= 4432)) then
					if (v24(v98.ColossusSmash, not v102) or (4768 <= 846)) then
						return "colossus_smash execute 55";
					end
				end
				if ((v98['Execute']:IsReady() and v38 and v14:BuffUp(v98.SuddenDeathBuff) and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0)) or (3358 <= 1420)) then
					if (v24(v98.Execute, not v102) or (3739 <= 3005)) then
						return "execute execute 56";
					end
				end
				v135 = 2;
			end
			if ((v135 == 5) or (1659 >= 2134)) then
				if ((v98['Overpower']:IsCastable() and v41) or (3260 < 2355)) then
					if (v24(v98.Overpower, not v102) or (669 == 4223)) then
						return "overpower execute 64";
					end
				end
				if (((v91 < v104) and v34 and ((v54 and v31) or not v54) and v98['Bladestorm']:IsCastable()) or (1692 < 588)) then
					if (v24(v98.Bladestorm, not v102) or (4797 < 3651)) then
						return "bladestorm execute 65";
					end
				end
				break;
			end
			if ((3 == v135) or (4177 > 4850)) then
				if (((v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == "cursor") and v98['SpearofBastion']:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) or (400 > 1111)) then
					if ((3051 > 1005) and v24(v100.SpearOfBastionCursor, not v15:IsSpellInRange(v98.SpearofBastion))) then
						return "spear_of_bastion execute 57";
					end
				end
				if ((3693 <= 4382) and v98['Cleave']:IsReady() and v36 and (v106 > 2) and (v15:DebuffRemains(v98.DeepWoundsDebuff) < v14:GCD())) then
					if (v24(v98.Cleave, not v102) or (3282 > 4100)) then
						return "cleave execute 58";
					end
				end
				if ((v98['MortalStrike']:IsReady() and v40 and ((v15:DebuffStack(v98.ExecutionersPrecisionDebuff) == 2) or (v15:DebuffRemains(v98.DeepWoundsDebuff) <= v14:GCD()))) or (3580 < 2844)) then
					if ((89 < 4490) and v24(v98.MortalStrike, not v102)) then
						return "mortal_strike execute 59";
					end
				end
				v135 = 4;
			end
			if ((v135 == 0) or (4983 < 1808)) then
				if ((3829 > 3769) and (v91 < v104) and v47 and v98['SweepingStrikes']:IsCastable() and (v106 > 1)) then
					if ((1485 <= 2904) and v24(v98.SweepingStrikes, not v15:IsInMeleeRange(v27))) then
						return "sweeping_strikes execute 51";
					end
				end
				if ((4269 == 4269) and v98['Rend']:IsReady() and v42 and (v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) and not v98['Bloodletting']:IsAvailable() and ((not v98['Warbreaker']:IsAvailable() and (v98['ColossusSmash']:CooldownRemains() < 4)) or (v98['Warbreaker']:IsAvailable() and (v98['Warbreaker']:CooldownRemains() < 4))) and (v15:TimeToDie() > 12)) then
					if ((387 <= 2782) and v24(v98.Rend, not v102)) then
						return "rend execute 52";
					end
				end
				if (((v91 < v104) and v32 and ((v53 and v31) or not v53) and v98['Avatar']:IsCastable() and (v98['ColossusSmash']:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff) or (v104 < 20))) or (1899 <= 917)) then
					if (v24(v98.Avatar, not v102) or (4312 <= 876)) then
						return "avatar execute 53";
					end
				end
				v135 = 1;
			end
			if ((2232 <= 2596) and (v135 == 4)) then
				if ((2095 < 3686) and v98['Overpower']:IsCastable() and v41 and (v14:Rage() < 40) and (v14:BuffStack(v98.MartialProwessBuff) < 2)) then
					if (v24(v98.Overpower, not v102) or (1595 >= 4474)) then
						return "overpower execute 60";
					end
				end
				if ((v98['Execute']:IsReady() and v38) or (4619 < 2882)) then
					if (v24(v98.Execute, not v102) or (294 >= 4831)) then
						return "execute execute 62";
					end
				end
				if ((2029 <= 3084) and v98['Shockwave']:IsCastable() and v44 and (v98['SonicBoom']:IsAvailable() or v15:IsCasting())) then
					if (v24(v98.Shockwave, not v15:IsInMeleeRange(v27)) or (2037 == 2420)) then
						return "shockwave execute 63";
					end
				end
				v135 = 5;
			end
		end
	end
	local function v116()
		local v136 = 0;
		while true do
			if ((4458 > 3904) and (7 == v136)) then
				if ((436 >= 123) and v98['ThunderClap']:IsReady() and v48 and v98['Battlelord']:IsAvailable() and v98['BloodandThunder']:IsAvailable()) then
					if ((500 < 1816) and v24(v98.ThunderClap, not v102)) then
						return "thunder_clap single_target 118";
					end
				end
				if ((3574 == 3574) and v98['Overpower']:IsCastable() and v41 and ((v15:DebuffDown(v98.ColossusSmashDebuff) and (v14:RagePercentage() < 50) and not v98['Battlelord']:IsAvailable()) or (v14:RagePercentage() < 25))) then
					if ((221 < 390) and v24(v98.Overpower, not v102)) then
						return "overpower single_target 119";
					end
				end
				if ((v98['Whirlwind']:IsReady() and v51 and v14:BuffUp(v98.MercilessBonegrinderBuff)) or (2213 <= 1421)) then
					if ((3058 < 4860) and v24(v98.Whirlwind, not v15:IsInRange(8))) then
						return "whirlwind single_target 120";
					end
				end
				v136 = 8;
			end
			if ((v136 == 3) or (1296 >= 4446)) then
				if ((v98['Skullsplitter']:IsCastable() and v45 and not v98['TestofMight']:IsAvailable() and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0) and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v98['ColossusSmash']:CooldownRemains() > 3))) or (1393 > 4489)) then
					if (v24(v98.Skullsplitter, not v102) or (4424 < 27)) then
						return "skullsplitter single_target 105";
					end
				end
				if ((v98['Skullsplitter']:IsCastable() and v45 and v98['TestofMight']:IsAvailable() and (v15:DebuffRemains(v98.DeepWoundsDebuff) > 0)) or (1997 > 3815)) then
					if ((3465 > 1913) and v24(v98.Skullsplitter, not v102)) then
						return "skullsplitter single_target 106";
					end
				end
				if ((733 < 1819) and (v91 < v104) and v49 and ((v57 and v31) or not v57) and v98['ThunderousRoar']:IsCastable() and (v14:BuffUp(v98.TestofMightBuff) or (v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff) and (v14:RagePercentage() < 33)) or (not v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) then
					if (v24(v98.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (4395 == 4755)) then
						return "thunderous_roar single_target 107";
					end
				end
				v136 = 4;
			end
			if ((v136 == 0) or (3793 < 2369)) then
				if (((v91 < v104) and v47 and v98['SweepingStrikes']:IsCastable() and (v106 > 1)) or (4084 == 265)) then
					if ((4358 == 4358) and v24(v98.SweepingStrikes, not v15:IsInMeleeRange(v27))) then
						return "sweeping_strikes single_target 97";
					end
				end
				if ((v98['Execute']:IsReady() and (v14:BuffUp(v98.SuddenDeathBuff))) or (3138 < 993)) then
					if ((3330 > 2323) and v24(v98.Execute, not v102)) then
						return "execute single_target 98";
					end
				end
				if ((v98['MortalStrike']:IsReady() and v40) or (3626 == 3989)) then
					if (v24(v98.MortalStrike, not v102) or (916 == 2671)) then
						return "mortal_strike single_target 99";
					end
				end
				v136 = 1;
			end
			if ((272 == 272) and (v136 == 1)) then
				if ((4249 <= 4839) and v98['Rend']:IsReady() and v42 and ((v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) or (v98['TideofBlood']:IsAvailable() and (v98['Skullsplitter']:CooldownRemains() <= v14:GCD()) and ((v98['ColossusSmash']:CooldownRemains() <= v14:GCD()) or v15:DebuffUp(v98.ColossusSmashDebuff)) and (v15:DebuffRemains(v98.RendDebuff) < (v98['RendDebuff']:BaseDuration() * 0.85))))) then
					if ((2777 < 3200) and v24(v98.Rend, not v102)) then
						return "rend single_target 100";
					end
				end
				if ((95 < 1957) and (v91 < v104) and v32 and ((v53 and v31) or not v53) and v98['Avatar']:IsCastable() and ((v98['WarlordsTorment']:IsAvailable() and (v14:RagePercentage() < 33) and (v98['ColossusSmash']:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff) or v14:BuffUp(v98.TestofMightBuff))) or (not v98['WarlordsTorment']:IsAvailable() and (v98['ColossusSmash']:CooldownUp() or v15:DebuffUp(v98.ColossusSmashDebuff))))) then
					if ((826 < 1717) and v24(v98.Avatar, not v102)) then
						return "avatar single_target 101";
					end
				end
				if ((1426 >= 1105) and (v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == "player") and v98['SpearofBastion']:IsCastable() and ((v98['ColossusSmash']:CooldownRemains() <= v14:GCD()) or (v98['Warbreaker']:CooldownRemains() <= v14:GCD()))) then
					if ((2754 <= 3379) and v24(v100.SpearOfBastionPlayer, not v15:IsSpellInRange(v98.SpearofBastion))) then
						return "spear_of_bastion single_target 102";
					end
				end
				v136 = 2;
			end
			if ((v136 == 9) or (3927 == 1413)) then
				if ((v98['Rend']:IsReady() and v42 and v15:DebuffRefreshable(v98.RendDebuff) and not v98['CrushingForce']:IsAvailable()) or (1154 <= 788)) then
					if (v24(v98.Rend, not v102) or (1643 > 3379)) then
						return "rend single_target 124";
					end
				end
				break;
			end
			if ((6 == v136) or (2803 > 4549)) then
				if ((v98['Slam']:IsReady() and v46 and ((v98['CrushingForce']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff) and (v14:Rage() >= 60) and v98['TestofMight']:IsAvailable()) or v98['ImprovedSlam']:IsAvailable()) and (not v98['FervorofBattle']:IsAvailable() or (v98['FervorofBattle']:IsAvailable() and (v106 == 1)))) or (220 >= 3022)) then
					if ((2822 == 2822) and v24(v98.Slam, not v102)) then
						return "slam single_target 115";
					end
				end
				if ((v98['Whirlwind']:IsReady() and v51 and (v98['StormofSwords']:IsAvailable() or (v98['FervorofBattle']:IsAvailable() and (v106 > 1)))) or (1061 == 1857)) then
					if ((2760 > 1364) and v24(v98.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return "whirlwind single_target 116";
					end
				end
				if ((v98['Slam']:IsReady() and v46 and (v98['CrushingForce']:IsAvailable() or (not v98['CrushingForce']:IsAvailable() and (v14:Rage() >= 30))) and (not v98['FervorofBattle']:IsAvailable() or (v98['FervorofBattle']:IsAvailable() and (v106 == 1)))) or (4902 <= 3595)) then
					if (v24(v98.Slam, not v102) or (3852 == 293)) then
						return "slam single_target 117";
					end
				end
				v136 = 7;
			end
			if ((5 == v136) or (1559 == 4588)) then
				if ((v98['Shockwave']:IsCastable() and v44 and (v98['SonicBoom']:IsAvailable() or v15:IsCasting())) or (4484 == 788)) then
					if ((4568 >= 3907) and v24(v98.Shockwave, not v15:IsInMeleeRange(v27))) then
						return "shockwave single_target 111";
					end
				end
				if ((1246 < 3470) and v98['Whirlwind']:IsReady() and v51 and v98['StormofSwords']:IsAvailable() and v98['TestofMight']:IsAvailable() and (v98['ColossusSmash']:CooldownRemains() > (v14:GCD() * 7))) then
					if ((4068 >= 972) and v24(v98.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return "whirlwind single_target 113";
					end
				end
				if ((493 < 3893) and v98['Overpower']:IsCastable() and v41 and (((v98['Overpower']:Charges() == 2) and not v98['Battlelord']:IsAvailable() and (v15:DebuffUp(v98.ColossusSmashDebuff) or (v14:RagePercentage() < 25))) or v98['Battlelord']:IsAvailable())) then
					if (v24(v98.Overpower, not v102) or (1473 >= 3332)) then
						return "overpower single_target 114";
					end
				end
				v136 = 6;
			end
			if ((4 == v136) or (4051 <= 1157)) then
				if ((604 < 2881) and v98['Whirlwind']:IsReady() and v51 and v98['StormofSwords']:IsAvailable() and v98['TestofMight']:IsAvailable() and (v14:RagePercentage() > 80) and v15:DebuffUp(v98.ColossusSmashDebuff)) then
					if (v24(v98.Whirlwind, not v15:IsInMeleeRange(v27)) or (900 == 3377)) then
						return "whirlwind single_target 108";
					end
				end
				if ((4459 > 591) and v98['ThunderClap']:IsReady() and v48 and (v15:DebuffRemains(v98.RendDebuff) <= v14:GCD()) and not v98['TideofBlood']:IsAvailable()) then
					if ((3398 >= 2395) and v24(v98.ThunderClap, not v102)) then
						return "thunder_clap single_target 109";
					end
				end
				if (((v91 < v104) and v34 and ((v54 and v31) or not v54) and v98['Bladestorm']:IsCastable() and ((v98['Hurricane']:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))) or (v98['Unhinged']:IsAvailable() and (v14:BuffUp(v98.TestofMightBuff) or (not v98['TestofMight']:IsAvailable() and v15:DebuffUp(v98.ColossusSmashDebuff)))))) or (2183 >= 2824)) then
					if ((1936 == 1936) and v24(v98.Bladestorm, not v102)) then
						return "bladestorm single_target 110";
					end
				end
				v136 = 5;
			end
			if ((v136 == 2) or (4832 < 4313)) then
				if ((4088 > 3874) and (v91 < v104) and v84 and ((v56 and v31) or not v56) and (v85 == "cursor") and v98['SpearofBastion']:IsCastable() and ((v98['ColossusSmash']:CooldownRemains() <= v14:GCD()) or (v98['Warbreaker']:CooldownRemains() <= v14:GCD()))) then
					if ((4332 == 4332) and v24(v100.SpearOfBastionCursor, not v15:IsSpellInRange(v98.SpearofBastion))) then
						return "spear_of_bastion single_target 102";
					end
				end
				if ((3999 >= 2900) and (v91 < v104) and v50 and ((v58 and v31) or not v58) and v98['Warbreaker']:IsCastable()) then
					if (v24(v98.Warbreaker, not v15:IsInRange(8)) or (2525 > 4064)) then
						return "warbreaker single_target 103";
					end
				end
				if ((4371 == 4371) and (v91 < v104) and v37 and ((v55 and v31) or not v55) and v98['ColossusSmash']:IsCastable()) then
					if (v24(v98.ColossusSmash, not v102) or (266 > 4986)) then
						return "colossus_smash single_target 104";
					end
				end
				v136 = 3;
			end
			if ((1991 >= 925) and (v136 == 8)) then
				if ((455 < 2053) and v98['Cleave']:IsReady() and v36 and v14:HasTier(29, 2) and not v98['CrushingForce']:IsAvailable()) then
					if (v24(v98.Cleave, not v102) or (826 == 4851)) then
						return "cleave single_target 121";
					end
				end
				if ((183 == 183) and (v91 < v104) and v34 and ((v54 and v31) or not v54) and v98['Bladestorm']:IsCastable()) then
					if ((1159 <= 1788) and v24(v98.Bladestorm, not v102)) then
						return "bladestorm single_target 122";
					end
				end
				if ((v98['Cleave']:IsReady() and v36) or (3507 > 4318)) then
					if (v24(v98.Cleave, not v102) or (3075 <= 2965)) then
						return "cleave single_target 123";
					end
				end
				v136 = 9;
			end
		end
	end
	local function v117()
		local v137 = 0;
		while true do
			if ((1365 <= 2011) and (v137 == 0)) then
				if (not v14:AffectingCombat() or (2776 > 3575)) then
					local v196 = 0;
					while true do
						if ((v196 == 0) or (2554 == 4804)) then
							if ((2577 == 2577) and v98['BattleStance']:IsCastable() and v14:BuffDown(v98.BattleStance, true)) then
								if (v24(v98.BattleStance) or (6 >= 1889)) then
									return "battle_stance";
								end
							end
							if ((506 <= 1892) and v98['BattleShout']:IsCastable() and v33 and (v14:BuffDown(v98.BattleShoutBuff, true) or v94.GroupBuffMissing(v98.BattleShoutBuff))) then
								if (v24(v98.BattleShout) or (2008 > 2218)) then
									return "battle_shout precombat";
								end
							end
							break;
						end
					end
				end
				if ((379 <= 4147) and v94.TargetIsValid() and v29) then
					if (not v14:AffectingCombat() or (4514 <= 1009)) then
						local v202 = 0;
						while true do
							if ((0 == v202) or (3496 == 1192)) then
								v28 = v113();
								if (v28 or (208 == 2959)) then
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
	local function v118()
		local v138 = 0;
		while true do
			if ((4277 >= 1313) and (v138 == 0)) then
				v28 = v111();
				if ((2587 < 3174) and v28) then
					return v28;
				end
				v138 = 1;
			end
			if ((v138 == 1) or (4120 <= 2198)) then
				if (v86 or (1596 == 858)) then
					local v197 = 0;
					while true do
						if ((3220 == 3220) and (v197 == 0)) then
							v28 = v94.HandleIncorporeal(v98.StormBolt, v100.StormBoltMouseover, 20, true);
							if (v28 or (1402 > 3620)) then
								return v28;
							end
							v197 = 1;
						end
						if ((2574 == 2574) and (v197 == 1)) then
							v28 = v94.HandleIncorporeal(v98.IntimidatingShout, v100.IntimidatingShoutMouseover, 8, true);
							if ((1798 < 2757) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (v94.TargetIsValid() or (377 > 2604)) then
					local v198 = 0;
					local v199;
					while true do
						if ((568 < 911) and (v198 == 1)) then
							if ((3285 < 4228) and v102 and v92 and ((v60 and v31) or not v60) and (v91 < v104)) then
								local v205 = 0;
								while true do
									if ((3916 > 3328) and (v205 == 2)) then
										if ((2500 < 3839) and v98['Fireblood']:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff))) then
											if ((507 == 507) and v24(v98.Fireblood)) then
												return "fireblood main 43";
											end
										end
										if ((240 <= 3165) and v98['AncestralCall']:IsCastable() and (v15:DebuffUp(v98.ColossusSmashDebuff))) then
											if ((834 >= 805) and v24(v98.AncestralCall)) then
												return "ancestral_call main 44";
											end
										end
										v205 = 3;
									end
									if ((v205 == 0) or (3812 < 2316)) then
										if ((v98['BloodFury']:IsCastable() and v15:DebuffUp(v98.ColossusSmashDebuff)) or (2652 <= 1533)) then
											if (v24(v98.BloodFury) or (3598 < 1460)) then
												return "blood_fury main 39";
											end
										end
										if ((v98['Berserking']:IsCastable() and (v15:DebuffRemains(v98.ColossusSmashDebuff) > 6)) or (4116 < 1192)) then
											if (v24(v98.Berserking) or (3377 <= 903)) then
												return "berserking main 40";
											end
										end
										v205 = 1;
									end
									if ((3976 >= 439) and (v205 == 1)) then
										if ((3752 == 3752) and v98['ArcaneTorrent']:IsCastable() and (v98['MortalStrike']:CooldownRemains() > 1.5) and (v14:Rage() < 50)) then
											if ((4046 > 2695) and v24(v98.ArcaneTorrent, not v15:IsInRange(8))) then
												return "arcane_torrent main 41";
											end
										end
										if ((v98['LightsJudgment']:IsCastable() and v15:DebuffDown(v98.ColossusSmashDebuff) and not v98['MortalStrike']:CooldownUp()) or (3545 == 3197)) then
											if ((2394 > 373) and v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment))) then
												return "lights_judgment main 42";
											end
										end
										v205 = 2;
									end
									if ((4155 <= 4232) and (v205 == 3)) then
										if ((v98['BagofTricks']:IsCastable() and v15:DebuffDown(v98.ColossusSmashDebuff) and not v98['MortalStrike']:CooldownUp()) or (3581 == 3473)) then
											if ((4995 > 3348) and v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks))) then
												return "bag_of_tricks main 10";
											end
										end
										break;
									end
								end
							end
							if ((v91 < v104) or (754 > 3724)) then
								if ((217 >= 57) and v93 and ((v31 and v59) or not v59)) then
									local v208 = 0;
									while true do
										if ((0 == v208) or (2070 >= 4037)) then
											v28 = v112();
											if ((2705 == 2705) and v28) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if ((61 == 61) and v39 and v98['HeroicThrow']:IsCastable() and not v15:IsInRange(30)) then
								if (v24(v98.HeroicThrow, not v15:IsInRange(30)) or (699 >= 1296)) then
									return "heroic_throw main";
								end
							end
							v198 = 2;
						end
						if ((v198 == 0) or (1783 >= 3616)) then
							if ((v35 and v98['Charge']:IsCastable() and not v102) or (3913 > 4527)) then
								if ((4376 > 817) and v24(v98.Charge, not v15:IsSpellInRange(v98.Charge))) then
									return "charge main 34";
								end
							end
							v199 = v94.HandleDPSPotion(v15:DebuffUp(v98.ColossusSmashDebuff));
							if ((4861 > 824) and v199) then
								return v199;
							end
							v198 = 1;
						end
						if ((v198 == 3) or (1383 >= 2131)) then
							v28 = v116();
							if (v28 or (1876 >= 2541)) then
								return v28;
							end
							if ((1782 <= 3772) and v20.CastAnnotated(v98.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v198 == 2) or (4700 < 813)) then
							if ((3199 < 4050) and v98['WreckingThrow']:IsCastable() and v52 and v15:AffectingCombat() and v107()) then
								if (v24(v98.WreckingThrow, not v15:IsInRange(30)) or (4951 < 4430)) then
									return "wrecking_throw main";
								end
							end
							if ((96 == 96) and v30 and (v106 > 2)) then
								local v206 = 0;
								while true do
									if ((0 == v206) or (2739 > 4008)) then
										v28 = v114();
										if (v28 or (23 == 1134)) then
											return v28;
										end
										break;
									end
								end
							end
							if ((v98['Massacre']:IsAvailable() and (v15:HealthPercentage() < 35)) or (v15:HealthPercentage() < 20) or (2693 >= 4111)) then
								local v207 = 0;
								while true do
									if ((v207 == 0) or (4316 <= 2146)) then
										v28 = v115();
										if (v28 or (3546 <= 2809)) then
											return v28;
										end
										break;
									end
								end
							end
							v198 = 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v139 = 0;
		while true do
			if ((4904 > 2166) and (v139 == 6)) then
				v56 = EpicSettings['Settings']['spearOfBastionWithCD'];
				v57 = EpicSettings['Settings']['thunderousRoarWithCD'];
				v58 = EpicSettings['Settings']['warbreakerWithCD'];
				break;
			end
			if ((109 >= 90) and (v139 == 0)) then
				v33 = EpicSettings['Settings']['useBattleShout'];
				v35 = EpicSettings['Settings']['useCharge'];
				v36 = EpicSettings['Settings']['useCleave'];
				v38 = EpicSettings['Settings']['useExecute'];
				v139 = 1;
			end
			if ((4978 > 2905) and (3 == v139)) then
				v48 = EpicSettings['Settings']['useThunderClap'];
				v51 = EpicSettings['Settings']['useWhirlwind'];
				v52 = EpicSettings['Settings']['useWreckingThrow'];
				v32 = EpicSettings['Settings']['useAvatar'];
				v139 = 4;
			end
			if ((v139 == 5) or (3026 <= 2280)) then
				v50 = EpicSettings['Settings']['useWarbreaker'];
				v53 = EpicSettings['Settings']['avatarWithCD'];
				v54 = EpicSettings['Settings']['bladestormWithCD'];
				v55 = EpicSettings['Settings']['colossusSmashWithCD'];
				v139 = 6;
			end
			if ((v139 == 2) or (1653 <= 1108)) then
				v44 = EpicSettings['Settings']['useShockwave'];
				v45 = EpicSettings['Settings']['useSkullsplitter'];
				v46 = EpicSettings['Settings']['useSlam'];
				v47 = EpicSettings['Settings']['useSweepingStrikes'];
				v139 = 3;
			end
			if ((2909 > 2609) and (v139 == 4)) then
				v34 = EpicSettings['Settings']['useBladestorm'];
				v37 = EpicSettings['Settings']['useColossusSmash'];
				v84 = EpicSettings['Settings']['useSpearOfBastion'];
				v49 = EpicSettings['Settings']['useThunderousRoar'];
				v139 = 5;
			end
			if ((757 > 194) and (v139 == 1)) then
				v39 = EpicSettings['Settings']['useHeroicThrow'];
				v40 = EpicSettings['Settings']['useMortalStrike'];
				v41 = EpicSettings['Settings']['useOverpower'];
				v42 = EpicSettings['Settings']['useRend'];
				v139 = 2;
			end
		end
	end
	local function v120()
		local v140 = 0;
		while true do
			if ((v140 == 3) or (31 >= 1398)) then
				v82 = EpicSettings['Settings']['unstanceHP'] or 0;
				v74 = EpicSettings['Settings']['dieByTheSwordHP'] or 0;
				v75 = EpicSettings['Settings']['ignorePainHP'] or 0;
				v78 = EpicSettings['Settings']['interveneHP'] or 0;
				v140 = 4;
			end
			if ((3196 <= 4872) and (v140 == 1)) then
				v69 = EpicSettings['Settings']['useDefensiveStance'];
				v65 = EpicSettings['Settings']['useDieByTheSword'];
				v66 = EpicSettings['Settings']['useIgnorePain'];
				v68 = EpicSettings['Settings']['useIntervene'];
				v140 = 2;
			end
			if ((3326 == 3326) and (4 == v140)) then
				v77 = EpicSettings['Settings']['rallyingCryGroup'] or 0;
				v76 = EpicSettings['Settings']['rallyingCryHP'] or 0;
				v83 = EpicSettings['Settings']['victoryRushHP'] or 0;
				v85 = EpicSettings['Settings']['spearSetting'] or "player";
				break;
			end
			if ((1433 <= 3878) and (v140 == 0)) then
				v61 = EpicSettings['Settings']['usePummel'];
				v62 = EpicSettings['Settings']['useStormBolt'];
				v63 = EpicSettings['Settings']['useIntimidatingShout'];
				v64 = EpicSettings['Settings']['useBitterImmunity'];
				v140 = 1;
			end
			if ((v140 == 2) or (1583 == 1735)) then
				v67 = EpicSettings['Settings']['useRallyingCry'];
				v72 = EpicSettings['Settings']['useVictoryRush'];
				v73 = EpicSettings['Settings']['bitterImmunityHP'] or 0;
				v79 = EpicSettings['Settings']['defensiveStanceHP'] or 0;
				v140 = 3;
			end
		end
	end
	local function v121()
		local v141 = 0;
		while true do
			if ((3 == v141) or (2981 == 2350)) then
				v87 = EpicSettings['Settings']['HealingPotionName'] or "";
				v86 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
			if ((v141 == 1) or (4466 <= 493)) then
				v93 = EpicSettings['Settings']['useTrinkets'];
				v92 = EpicSettings['Settings']['useRacials'];
				v59 = EpicSettings['Settings']['trinketsWithCD'];
				v60 = EpicSettings['Settings']['racialsWithCD'];
				v141 = 2;
			end
			if ((v141 == 2) or (2547 <= 1987)) then
				v70 = EpicSettings['Settings']['useHealthstone'];
				v71 = EpicSettings['Settings']['useHealingPotion'];
				v80 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v81 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v141 = 3;
			end
			if ((2961 > 2740) and (v141 == 0)) then
				v91 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v88 = EpicSettings['Settings']['InterruptWithStun'];
				v89 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v90 = EpicSettings['Settings']['InterruptThreshold'];
				v141 = 1;
			end
		end
	end
	local function v122()
		local v142 = 0;
		while true do
			if ((3696 >= 3612) and (v142 == 3)) then
				v102 = v15:IsInMeleeRange(v27);
				if (v94.TargetIsValid() or v14:AffectingCombat() or (2970 == 1878)) then
					local v200 = 0;
					while true do
						if ((v200 == 0) or (3693 < 1977)) then
							v103 = v10.BossFightRemains(nil, true);
							v104 = v103;
							v200 = 1;
						end
						if ((1 == v200) or (930 > 2101)) then
							if ((4153 > 3086) and (v104 == 11111)) then
								v104 = v10.FightRemains(v105, false);
							end
							break;
						end
					end
				end
				if (not v14:IsChanneling() or (4654 <= 4050)) then
					if (v14:AffectingCombat() or (2602 < 1496)) then
						local v203 = 0;
						while true do
							if ((v203 == 0) or (1020 > 2288)) then
								v28 = v118();
								if ((328 == 328) and v28) then
									return v28;
								end
								break;
							end
						end
					else
						local v204 = 0;
						while true do
							if ((1511 < 3808) and (0 == v204)) then
								v28 = v117();
								if (v28 or (2510 > 4919)) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((4763 == 4763) and (v142 == 1)) then
				v29 = EpicSettings['Toggles']['ooc'];
				v30 = EpicSettings['Toggles']['aoe'];
				v31 = EpicSettings['Toggles']['cds'];
				v142 = 2;
			end
			if ((4137 > 1848) and (2 == v142)) then
				if ((2436 <= 3134) and v14:IsDeadOrGhost()) then
					return;
				end
				if ((3723 == 3723) and v98['IntimidatingShout']:IsAvailable()) then
					v27 = 8;
				end
				if (v30 or (4046 >= 4316)) then
					local v201 = 0;
					while true do
						if ((v201 == 0) or (2008 < 1929)) then
							v105 = v14:GetEnemiesInMeleeRange(v27);
							v106 = #v105;
							break;
						end
					end
				else
					v106 = 1;
				end
				v142 = 3;
			end
			if ((2384 > 1775) and (v142 == 0)) then
				v120();
				v119();
				v121();
				v142 = 1;
			end
		end
	end
	local function v123()
		v20.Print("Arms Warrior by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(71, v122, v123);
end;
return v0["Epix_Warrior_Arms.lua"]();

