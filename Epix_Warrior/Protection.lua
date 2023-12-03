local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((4825 < 4843) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (3877 >= 4537)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (4315 < 1726)) then
			return v6(...);
		end
	end
end
v0["Epix_Warrior_Protection.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC['DBC'];
	local v10 = EpicLib;
	local v11 = v10['Unit'];
	local v12 = v10['Utils'];
	local v13 = v11['Player'];
	local v14 = v11['Target'];
	local v15 = v11['TargetTarget'];
	local v16 = v11['Focus'];
	local v17 = v10['Spell'];
	local v18 = v10['Item'];
	local v19 = EpicLib;
	local v20 = v19['Bind'];
	local v21 = v19['Cast'];
	local v22 = v19['Macro'];
	local v23 = v19['Press'];
	local v24 = v19['Commons']['Everyone']['num'];
	local v25 = v19['Commons']['Everyone']['bool'];
	local v26 = UnitIsUnit;
	local v27 = math['floor'];
	local v28 = 5;
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
	local v94 = 11111;
	local v95 = 11111;
	local v96;
	local v97 = v19['Commons']['Everyone'];
	local v98 = v17['Warrior']['Protection'];
	local v99 = v18['Warrior']['Protection'];
	local v100 = v22['Warrior']['Protection'];
	local v101 = {};
	local v102;
	local v103;
	local v104;
	local function v105()
		local v123 = 0;
		local v124;
		while true do
			if ((v123 == 0) or (3679 < 625)) then
				v124 = UnitGetTotalAbsorbs(v14);
				if ((v124 > 0) or (4625 < 632)) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v106()
		return v13:IsTankingAoE(16) or v13:IsTanking(v14) or v14:IsDummy();
	end
	local function v107()
		if (v13:BuffUp(v98.IgnorePain) or (83 > 1780)) then
			local v141 = 0;
			local v142;
			local v143;
			local v144;
			while true do
				if ((546 <= 1077) and (v141 == 1)) then
					v144 = v143['points'][1];
					return v144 < v142;
				end
				if ((v141 == 0) or (996 > 4301)) then
					v142 = v13:AttackPowerDamageMod() * 3.5 * (1 + (v13:VersatilityDmgPct() / 100));
					v143 = v13:AuraInfo(v98.IgnorePain, nil, true);
					v141 = 1;
				end
			end
		else
			return true;
		end
	end
	local function v108()
		if ((4070 > 687) and v13:BuffUp(v98.IgnorePain)) then
			local v145 = 0;
			local v146;
			while true do
				if ((v145 == 0) or (656 >= 3330)) then
					v146 = v13:BuffInfo(v98.IgnorePain, nil, true);
					return v146['points'][1];
				end
			end
		else
			return 0;
		end
	end
	local function v109()
		return v106() and v98['ShieldBlock']:IsReady() and (((v13:BuffRemains(v98.ShieldBlockBuff) <= 18) and v98['EnduringDefenses']:IsAvailable()) or (v13:BuffRemains(v98.ShieldBlockBuff) <= 12));
	end
	local function v110(v125)
		local v126 = 0;
		local v127;
		local v128;
		local v129;
		while true do
			if ((0 == v126) or (2492 <= 335)) then
				v127 = 80;
				if ((4322 >= 2562) and ((v127 < 35) or (v13:Rage() < 35))) then
					return false;
				end
				v126 = 1;
			end
			if ((v126 == 1) or (3637 >= 3770)) then
				v128 = false;
				v129 = (v13:Rage() >= 35) and not v109();
				v126 = 2;
			end
			if ((2 == v126) or (2379 > 4578)) then
				if ((v129 and (((v13:Rage() + v125) >= v127) or v98['DemoralizingShout']:IsReady())) or (483 > 743)) then
					v128 = true;
				end
				if ((2454 > 578) and v128) then
					if ((930 < 4458) and v106() and v107()) then
						if ((662 <= 972) and v23(v98.IgnorePain, nil, nil, true)) then
							return "ignore_pain rage capped";
						end
					elseif ((4370 == 4370) and v23(v98.Revenge, not v102)) then
						return "revenge rage capped";
					end
				end
				break;
			end
		end
	end
	local function v111()
		local v130 = 0;
		while true do
			if ((v130 == 3) or (4762 <= 861)) then
				if ((v99['Healthstone']:IsReady() and v70 and (v13:HealthPercentage() <= v82)) or (1412 == 4264)) then
					if (v23(v100.Healthstone) or (3168 < 2153)) then
						return "healthstone defensive 3";
					end
				end
				if ((v71 and (v13:HealthPercentage() <= v83)) or (4976 < 1332)) then
					local v195 = 0;
					while true do
						if ((4628 == 4628) and (0 == v195)) then
							if ((v89 == "Refreshing Healing Potion") or (54 == 395)) then
								if ((82 == 82) and v99['RefreshingHealingPotion']:IsReady()) then
									if (v23(v100.RefreshingHealingPotion) or (581 < 282)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v89 == "Dreamwalker's Healing Potion") or (4609 < 2495)) then
								if ((1152 == 1152) and v99['DreamwalkersHealingPotion']:IsReady()) then
									if ((1896 <= 3422) and v23(v100.RefreshingHealingPotion)) then
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
			if ((1 == v130) or (990 > 1620)) then
				if ((v98['IgnorePain']:IsReady() and v66 and (v13:HealthPercentage() <= v77) and v107()) or (877 > 4695)) then
					if ((2691 >= 1851) and v23(v98.IgnorePain, nil, nil, true)) then
						return "ignore_pain defensive";
					end
				end
				if ((v98['RallyingCry']:IsReady() and v67 and v13:BuffDown(v98.AspectsFavorBuff) and v13:BuffDown(v98.RallyingCry) and (((v13:HealthPercentage() <= v78) and v97.IsSoloMode()) or v97.AreUnitsBelowHealthPercentage(v78, v79))) or (2985 >= 4856)) then
					if ((4276 >= 1195) and v23(v98.RallyingCry)) then
						return "rallying_cry defensive";
					end
				end
				v130 = 2;
			end
			if ((3232 <= 4690) and (v130 == 0)) then
				if ((v98['BitterImmunity']:IsReady() and v62 and (v13:HealthPercentage() <= v73)) or (896 >= 3146)) then
					if ((3061 >= 2958) and v23(v98.BitterImmunity)) then
						return "bitter_immunity defensive";
					end
				end
				if ((3187 >= 644) and v98['LastStand']:IsCastable() and v65 and ((v13:HealthPercentage() <= v76) or v13:ActiveMitigationNeeded())) then
					if ((644 <= 704) and v23(v98.LastStand)) then
						return "last_stand defensive";
					end
				end
				v130 = 1;
			end
			if ((958 > 947) and (v130 == 2)) then
				if ((4492 >= 2654) and v98['Intervene']:IsReady() and v68 and (v16:HealthPercentage() <= v80) and (v16:UnitName() ~= v13:UnitName())) then
					if ((3442 >= 1503) and v23(v100.InterveneFocus)) then
						return "intervene defensive";
					end
				end
				if ((v98['ShieldWall']:IsCastable() and v63 and v13:BuffDown(v98.ShieldWallBuff) and ((v13:HealthPercentage() <= v74) or v13:ActiveMitigationNeeded())) or (3170 <= 1464)) then
					if (v23(v98.ShieldWall) or (4797 == 4388)) then
						return "shield_wall defensive";
					end
				end
				v130 = 3;
			end
		end
	end
	local function v112()
		local v131 = 0;
		while true do
			if ((551 <= 681) and (v131 == 1)) then
				v29 = v97.HandleBottomTrinket(v101, v32, 40, nil);
				if ((3277 > 407) and v29) then
					return v29;
				end
				break;
			end
			if ((4695 >= 1415) and (0 == v131)) then
				v29 = v97.HandleTopTrinket(v101, v32, 40, nil);
				if (v29 or (3212 <= 944)) then
					return v29;
				end
				v131 = 1;
			end
		end
	end
	local function v113()
		if (v14:IsInMeleeRange(v28) or (3096 <= 1798)) then
			if ((3537 == 3537) and v98['ThunderClap']:IsCastable() and v47) then
				if ((3837 >= 1570) and v23(v98.ThunderClap)) then
					return "thunder_clap precombat";
				end
			end
		elseif ((v36 and v98['Charge']:IsCastable() and not v14:IsInRange(8)) or (2950 == 3812)) then
			if ((4723 >= 2318) and v23(v98.Charge, not v14:IsSpellInRange(v98.Charge))) then
				return "charge precombat";
			end
		end
	end
	local function v114()
		local v132 = 0;
		while true do
			if ((v132 == 1) or (2027 > 2852)) then
				if ((v98['ThunderClap']:IsCastable() and v47 and v13:BuffUp(v98.ViolentOutburstBuff) and (v104 > 5) and v13:BuffUp(v98.AvatarBuff) and v98['UnstoppableForce']:IsAvailable()) or (1136 > 4317)) then
					local v196 = 0;
					while true do
						if ((4748 == 4748) and (v196 == 0)) then
							v110(5);
							if ((3736 <= 4740) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
								return "thunder_clap aoe 4";
							end
							break;
						end
					end
				end
				if ((v98['Revenge']:IsReady() and v42 and (v13:Rage() >= 70) and v98['SeismicReverberation']:IsAvailable() and (v104 >= 3)) or (3390 <= 3060)) then
					if (v23(v98.Revenge, not v102) or (999 > 2693)) then
						return "revenge aoe 6";
					end
				end
				v132 = 2;
			end
			if ((463 < 601) and (v132 == 0)) then
				if ((v98['ThunderClap']:IsCastable() and v47 and (v14:DebuffRemains(v98.RendDebuff) <= 1)) or (2183 < 687)) then
					local v197 = 0;
					while true do
						if ((4549 == 4549) and (v197 == 0)) then
							v110(5);
							if ((4672 == 4672) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
								return "thunder_clap aoe 2";
							end
							break;
						end
					end
				end
				if ((v98['ShieldSlam']:IsCastable() and v44 and ((v13:HasTier(30, 2) and (v104 <= 7)) or v13:BuffUp(v98.EarthenTenacityBuff))) or (3668 < 395)) then
					if (v23(v98.ShieldSlam, not v102) or (4166 == 455)) then
						return "shield_slam aoe 3";
					end
				end
				v132 = 1;
			end
			if ((v132 == 3) or (4449 == 2663)) then
				if ((v98['Revenge']:IsReady() and v42 and ((v13:Rage() >= 30) or ((v13:Rage() >= 40) and v98['BarbaricTraining']:IsAvailable()))) or (4277 < 2989)) then
					if (v23(v98.Revenge, not v102) or (870 >= 4149)) then
						return "revenge aoe 12";
					end
				end
				break;
			end
			if ((2212 < 3183) and (v132 == 2)) then
				if ((4646 > 2992) and v98['ShieldSlam']:IsCastable() and v44 and ((v13:Rage() <= 60) or (v13:BuffUp(v98.ViolentOutburstBuff) and (v104 <= 7)))) then
					local v198 = 0;
					while true do
						if ((1434 < 3106) and (v198 == 0)) then
							v110(20);
							if ((786 < 3023) and v23(v98.ShieldSlam, not v102)) then
								return "shield_slam aoe 8";
							end
							break;
						end
					end
				end
				if ((v98['ThunderClap']:IsCastable() and v47) or (2442 < 74)) then
					local v199 = 0;
					while true do
						if ((4535 == 4535) and (v199 == 0)) then
							v110(5);
							if (v23(v98.ThunderClap, not v14:IsInMeleeRange(v28)) or (3009 <= 2105)) then
								return "thunder_clap aoe 10";
							end
							break;
						end
					end
				end
				v132 = 3;
			end
		end
	end
	local function v115()
		local v133 = 0;
		while true do
			if ((1830 < 3669) and (v133 == 0)) then
				if ((v98['ShieldSlam']:IsCastable() and v44) or (1430 >= 3612)) then
					local v200 = 0;
					while true do
						if ((2683 >= 2460) and (v200 == 0)) then
							v110(20);
							if (v23(v98.ShieldSlam, not v102) or (1804 >= 3275)) then
								return "shield_slam generic 2";
							end
							break;
						end
					end
				end
				if ((v98['ThunderClap']:IsCastable() and v47 and (v14:DebuffRemains(v98.RendDebuff) <= 1) and v13:BuffDown(v98.ViolentOutburstBuff)) or (1417 > 3629)) then
					local v201 = 0;
					while true do
						if ((4795 > 402) and (v201 == 0)) then
							v110(5);
							if ((4813 > 3565) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
								return "thunder_clap generic 4";
							end
							break;
						end
					end
				end
				if ((3912 == 3912) and v98['Execute']:IsReady() and v39 and v13:BuffUp(v98.SuddenDeathBuff) and v98['SuddenDeath']:IsAvailable()) then
					if ((2821 <= 4824) and v23(v98.Execute, not v102)) then
						return "execute generic 6";
					end
				end
				if ((1738 <= 2195) and v98['Execute']:IsReady() and v39 and (v104 == 1) and (v98['Massacre']:IsAvailable() or v98['Juggernaut']:IsAvailable()) and (v13:Rage() >= 50)) then
					if ((41 <= 3018) and v23(v98.Execute, not v102)) then
						return "execute generic 6";
					end
				end
				v133 = 1;
			end
			if ((2145 <= 4104) and (v133 == 2)) then
				if ((2689 < 4845) and v98['Revenge']:IsReady() and v42 and (v14:HealthPercentage() > 20)) then
					if (v23(v98.Revenge, not v102) or (2322 > 2622)) then
						return "revenge generic 18";
					end
				end
				if ((v98['ThunderClap']:IsCastable() and v47 and ((v104 >= 1) or (v98['ShieldSlam']:CooldownDown() and v13:BuffUp(v98.ViolentOutburstBuff)))) or (4534 == 2082)) then
					local v202 = 0;
					while true do
						if ((v202 == 0) or (1571 > 1867)) then
							v110(5);
							if (v23(v98.ThunderClap, not v14:IsInMeleeRange(v28)) or (2654 >= 2996)) then
								return "thunder_clap generic 20";
							end
							break;
						end
					end
				end
				if ((3978 > 2104) and v98['Devastate']:IsCastable() and v38) then
					if ((2995 > 1541) and v23(v98.Devastate, not v102)) then
						return "devastate generic 22";
					end
				end
				break;
			end
			if ((3249 > 953) and (v133 == 1)) then
				if ((v98['Execute']:IsReady() and v39 and (v104 == 1) and (v13:Rage() >= 50)) or (3273 > 4573)) then
					if (v23(v98.Execute, not v102) or (3151 < 1284)) then
						return "execute generic 10";
					end
				end
				if ((v98['ThunderClap']:IsCastable() and v47 and ((v104 > 1) or (v98['ShieldSlam']:CooldownDown() and not v13:BuffUp(v98.ViolentOutburstBuff)))) or (1850 == 1529)) then
					local v203 = 0;
					while true do
						if ((821 < 2123) and (0 == v203)) then
							v110(5);
							if ((902 < 2325) and v23(v98.ThunderClap, not v14:IsInMeleeRange(v28))) then
								return "thunder_clap generic 12";
							end
							break;
						end
					end
				end
				if ((858 <= 2962) and v98['Revenge']:IsReady() and v42 and (((v13:Rage() >= 60) and (v14:HealthPercentage() > 20)) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() <= 20) and (v13:Rage() <= 18) and v98['ShieldSlam']:CooldownDown()) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() > 20)) or ((((v13:Rage() >= 60) and (v14:HealthPercentage() > 35)) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() <= 35) and (v13:Rage() <= 18) and v98['ShieldSlam']:CooldownDown()) or (v13:BuffUp(v98.RevengeBuff) and (v14:HealthPercentage() > 35))) and v98['Massacre']:IsAvailable()))) then
					if (v23(v98.Revenge, not v102) or (3946 < 1288)) then
						return "revenge generic 14";
					end
				end
				if ((v98['Execute']:IsReady() and v39 and (v104 == 1)) or (3242 == 567)) then
					if (v23(v98.Execute, not v102) or (847 >= 1263)) then
						return "execute generic 16";
					end
				end
				v133 = 2;
			end
		end
	end
	local function v116()
		local v134 = 0;
		while true do
			if ((v134 == 0) or (2253 == 1851)) then
				if (not v13:AffectingCombat() or (2087 > 2372)) then
					local v204 = 0;
					while true do
						if ((v204 == 0) or (4445 < 4149)) then
							if ((v98['BattleShout']:IsCastable() and v35 and (v13:BuffDown(v98.BattleShoutBuff, true) or v97.GroupBuffMissing(v98.BattleShoutBuff))) or (1818 == 85)) then
								if ((630 < 2127) and v23(v98.BattleShout)) then
									return "battle_shout precombat";
								end
							end
							if ((v96 and v98['BattleStance']:IsCastable() and not v13:BuffUp(v98.BattleStance)) or (1938 == 2514)) then
								if ((4255 >= 55) and v23(v98.BattleStance)) then
									return "battle_stance precombat";
								end
							end
							break;
						end
					end
				end
				if ((2999 > 1156) and v97.TargetIsValid() and v30) then
					if ((2350 > 1155) and not v13:AffectingCombat()) then
						local v210 = 0;
						while true do
							if ((4029 <= 4853) and (0 == v210)) then
								v29 = v113();
								if (v29 or (516 > 3434)) then
									return v29;
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
	local function v117()
		local v135 = 0;
		while true do
			if ((4046 >= 3033) and (v135 == 1)) then
				if (v88 or (2719 <= 1447)) then
					local v205 = 0;
					while true do
						if ((1 == v205) or (4134 < 3926)) then
							v29 = v97.HandleIncorporeal(v98.IntimidatingShout, v100.IntimidatingShoutMouseover, 8, true);
							if (v29 or (164 >= 2785)) then
								return v29;
							end
							break;
						end
						if ((v205 == 0) or (525 == 2109)) then
							v29 = v97.HandleIncorporeal(v98.StormBolt, v100.StormBoltMouseover, 20, true);
							if ((33 == 33) and v29) then
								return v29;
							end
							v205 = 1;
						end
					end
				end
				if ((3054 <= 4015) and v97.TargetIsValid()) then
					local v206 = 0;
					local v207;
					while true do
						if ((1871 < 3382) and (4 == v206)) then
							if ((1293 <= 2166) and v106() and v65 and v98['LastStand']:IsCastable() and v13:BuffDown(v98.ShieldWallBuff) and (((v14:HealthPercentage() >= 90) and v98['UnnervingFocus']:IsAvailable()) or ((v14:HealthPercentage() <= 20) and v98['UnnervingFocus']:IsAvailable()) or v98['Bolster']:IsAvailable() or v13:HasTier(30, 2))) then
								if (v23(v98.LastStand) or (2579 < 123)) then
									return "last_stand defensive";
								end
							end
							if (((v93 < v95) and v41 and ((v53 and v32) or not v53) and (v86 == "player") and v98['Ravager']:IsCastable()) or (846 >= 2368)) then
								local v213 = 0;
								while true do
									if ((v213 == 0) or (4012 <= 3358)) then
										v110(10);
										if ((1494 <= 3005) and v23(v100.RavagerPlayer, not v102)) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							if (((v93 < v95) and v41 and ((v53 and v32) or not v53) and (v86 == "cursor") and v98['Ravager']:IsCastable()) or (3111 == 2134)) then
								local v214 = 0;
								while true do
									if ((2355 == 2355) and (v214 == 0)) then
										v110(10);
										if (v23(v100.RavagerCursor, not v102) or (588 <= 432)) then
											return "ravager main 24";
										end
										break;
									end
								end
							end
							v206 = 5;
						end
						if ((4797 >= 3895) and (v206 == 7)) then
							if ((3577 == 3577) and (v93 < v95) and v98['ShieldCharge']:IsCastable() and v43 and ((v54 and v32) or not v54)) then
								if ((3794 > 3693) and v23(v98.ShieldCharge, not v14:IsSpellInRange(v98.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							if ((v109() and v64) or (1275 == 4100)) then
								if (v23(v98.ShieldBlock) or (1591 >= 3580)) then
									return "shield_block main 38";
								end
							end
							if ((983 <= 1808) and (v104 > 3)) then
								local v215 = 0;
								while true do
									if ((v215 == 1) or (2150 <= 1197)) then
										if ((3769 >= 1173) and v19.CastAnnotated(v98.Pool, false, "WAIT")) then
											return "Pool for Aoe()";
										end
										break;
									end
									if ((1485 == 1485) and (v215 == 0)) then
										v29 = v114();
										if (v29 or (3315 <= 2782)) then
											return v29;
										end
										v215 = 1;
									end
								end
							end
							v206 = 8;
						end
						if ((v206 == 3) or (876 >= 2964)) then
							v207 = v97.HandleDPSPotion(v14:BuffUp(v98.AvatarBuff));
							if (v207 or (2232 > 2497)) then
								return v207;
							end
							if ((v98['IgnorePain']:IsReady() and v66 and v107() and (v14:HealthPercentage() >= 20) and (((v13:RageDeficit() <= 15) and v98['ShieldSlam']:CooldownUp()) or ((v13:RageDeficit() <= 40) and v98['ShieldCharge']:CooldownUp() and v98['ChampionsBulwark']:IsAvailable()) or ((v13:RageDeficit() <= 20) and v98['ShieldCharge']:CooldownUp()) or ((v13:RageDeficit() <= 30) and v98['DemoralizingShout']:CooldownUp() and v98['BoomingVoice']:IsAvailable()) or ((v13:RageDeficit() <= 20) and v98['Avatar']:CooldownUp()) or ((v13:RageDeficit() <= 45) and v98['DemoralizingShout']:CooldownUp() and v98['BoomingVoice']:IsAvailable() and v13:BuffUp(v98.LastStandBuff) and v98['UnnervingFocus']:IsAvailable()) or ((v13:RageDeficit() <= 30) and v98['Avatar']:CooldownUp() and v13:BuffUp(v98.LastStandBuff) and v98['UnnervingFocus']:IsAvailable()) or (v13:RageDeficit() <= 20) or ((v13:RageDeficit() <= 40) and v98['ShieldSlam']:CooldownUp() and v13:BuffUp(v98.ViolentOutburstBuff) and v98['HeavyRepercussions']:IsAvailable() and v98['ImpenetrableWall']:IsAvailable()) or ((v13:RageDeficit() <= 55) and v98['ShieldSlam']:CooldownUp() and v13:BuffUp(v98.ViolentOutburstBuff) and v13:BuffUp(v98.LastStandBuff) and v98['UnnervingFocus']:IsAvailable() and v98['HeavyRepercussions']:IsAvailable() and v98['ImpenetrableWall']:IsAvailable()) or ((v13:RageDeficit() <= 17) and v98['ShieldSlam']:CooldownUp() and v98['HeavyRepercussions']:IsAvailable()) or ((v13:RageDeficit() <= 18) and v98['ShieldSlam']:CooldownUp() and v98['ImpenetrableWall']:IsAvailable()))) or (2110 <= 332)) then
								if ((3686 > 3172) and v23(v98.IgnorePain, nil, nil, true)) then
									return "ignore_pain main 20";
								end
							end
							v206 = 4;
						end
						if ((v206 == 0) or (4474 < 820)) then
							if ((4279 >= 2882) and v96 and (v13:HealthPercentage() <= v81)) then
								if ((v98['DefensiveStance']:IsCastable() and not v13:BuffUp(v98.DefensiveStance)) or (2029 >= 3521)) then
									if (v23(v98.DefensiveStance) or (2037 >= 4642)) then
										return "defensive_stance while tanking";
									end
								end
							end
							if ((1720 < 4458) and v96 and (v13:HealthPercentage() > v81)) then
								if ((v98['BattleStance']:IsCastable() and not v13:BuffUp(v98.BattleStance)) or (436 > 3021)) then
									if ((713 <= 847) and v23(v98.BattleStance)) then
										return "battle_stance while not tanking";
									end
								end
							end
							if ((2154 <= 4031) and v43 and ((v54 and v32) or not v54) and (v93 < v95) and v98['ShieldCharge']:IsCastable() and not v102) then
								if ((4615 == 4615) and v23(v98.ShieldCharge, not v14:IsSpellInRange(v98.ShieldCharge))) then
									return "shield_charge main 34";
								end
							end
							v206 = 1;
						end
						if ((v206 == 5) or (3790 == 500)) then
							if ((89 < 221) and v98['DemoralizingShout']:IsCastable() and v37 and v98['BoomingVoice']:IsAvailable()) then
								local v216 = 0;
								while true do
									if ((2054 >= 1421) and (v216 == 0)) then
										v110(30);
										if ((692 < 3058) and v23(v98.DemoralizingShout, not v102)) then
											return "demoralizing_shout main 28";
										end
										break;
									end
								end
							end
							if (((v93 < v95) and v46 and ((v55 and v32) or not v55) and (v87 == "player") and v98['SpearofBastion']:IsCastable()) or (3254 == 1655)) then
								local v217 = 0;
								while true do
									if ((v217 == 0) or (1296 == 4910)) then
										v110(20);
										if ((3368 == 3368) and v23(v100.SpearOfBastionPlayer, not v102)) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							if ((2643 < 3815) and (v93 < v95) and v46 and ((v55 and v32) or not v55) and (v87 == "cursor") and v98['SpearofBastion']:IsCastable()) then
								local v218 = 0;
								while true do
									if ((1913 > 493) and (v218 == 0)) then
										v110(20);
										if ((4755 > 3428) and v23(v100.SpearOfBastionCursor, not v102)) then
											return "spear_of_bastion main 28";
										end
										break;
									end
								end
							end
							v206 = 6;
						end
						if ((1381 <= 2369) and (v206 == 6)) then
							if (((v93 < v95) and v48 and ((v56 and v32) or not v56) and v98['ThunderousRoar']:IsCastable()) or (4843 == 4084)) then
								if ((4669 > 363) and v23(v98.ThunderousRoar, not v14:IsInMeleeRange(v28))) then
									return "thunderous_roar main 30";
								end
							end
							if ((v98['ShieldSlam']:IsCastable() and v44 and v13:BuffUp(v98.FervidBuff)) or (1877 >= 3138)) then
								if ((4742 >= 3626) and v23(v98.ShieldSlam, not v102)) then
									return "shield_slam main 31";
								end
							end
							if ((v98['Shockwave']:IsCastable() and v45 and v13:BuffUp(v98.AvatarBuff) and v98['UnstoppableForce']:IsAvailable() and not v98['RumblingEarth']:IsAvailable()) or (v98['SonicBoom']:IsAvailable() and v98['RumblingEarth']:IsAvailable() and (v104 >= 3) and v14:IsCasting()) or (4540 == 916)) then
								local v219 = 0;
								while true do
									if ((0 == v219) or (1156 > 4345)) then
										v110(10);
										if ((2237 < 4249) and v23(v98.Shockwave, not v14:IsInMeleeRange(v28))) then
											return "shockwave main 32";
										end
										break;
									end
								end
							end
							v206 = 7;
						end
						if ((v206 == 8) or (2683 < 23)) then
							v29 = v115();
							if ((697 <= 826) and v29) then
								return v29;
							end
							if ((1105 <= 1176) and v19.CastAnnotated(v98.Pool, false, "WAIT")) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((3379 <= 3812) and (v206 == 2)) then
							if ((v98['WreckingThrow']:IsCastable() and v49 and v14:AffectingCombat() and v105()) or (788 >= 1616)) then
								if ((1854 <= 3379) and v23(v98.WreckingThrow, not v14:IsInRange(30))) then
									return "wrecking_throw main";
								end
							end
							if ((4549 == 4549) and (v93 < v95) and v34 and ((v52 and v32) or not v52) and v98['Avatar']:IsCastable()) then
								if (v23(v98.Avatar) or (3022 >= 3024)) then
									return "avatar main 2";
								end
							end
							if ((4820 > 2198) and (v93 < v95) and v51 and ((v58 and v32) or not v58)) then
								local v220 = 0;
								while true do
									if ((v220 == 0) or (1061 >= 4891)) then
										if ((1364 <= 4473) and v98['BloodFury']:IsCastable()) then
											if (v23(v98.BloodFury) or (3595 <= 3)) then
												return "blood_fury main 4";
											end
										end
										if (v98['Berserking']:IsCastable() or (4672 == 3852)) then
											if ((1559 == 1559) and v23(v98.Berserking)) then
												return "berserking main 6";
											end
										end
										v220 = 1;
									end
									if ((v220 == 1) or (1752 <= 788)) then
										if (v98['ArcaneTorrent']:IsCastable() or (3907 == 177)) then
											if ((3470 > 555) and v23(v98.ArcaneTorrent)) then
												return "arcane_torrent main 8";
											end
										end
										if (v98['LightsJudgment']:IsCastable() or (972 == 645)) then
											if ((3182 >= 2115) and v23(v98.LightsJudgment)) then
												return "lights_judgment main 10";
											end
										end
										v220 = 2;
									end
									if ((3893 < 4429) and (3 == v220)) then
										if (v98['BagofTricks']:IsCastable() or (2867 < 1905)) then
											if (v23(v98.BagofTricks) or (1796 >= 4051)) then
												return "ancestral_call main 16";
											end
										end
										break;
									end
									if ((1619 <= 3756) and (v220 == 2)) then
										if ((604 == 604) and v98['Fireblood']:IsCastable()) then
											if (v23(v98.Fireblood) or (4484 == 900)) then
												return "fireblood main 12";
											end
										end
										if (v98['AncestralCall']:IsCastable() or (4459 <= 1113)) then
											if ((3632 > 3398) and v23(v98.AncestralCall)) then
												return "ancestral_call main 14";
											end
										end
										v220 = 3;
									end
								end
							end
							v206 = 3;
						end
						if ((4082 <= 4917) and (v206 == 1)) then
							if ((4832 >= 1386) and v36 and v98['Charge']:IsCastable() and not v102) then
								if ((137 == 137) and v23(v98.Charge, not v14:IsSpellInRange(v98.Charge))) then
									return "charge main 34";
								end
							end
							if ((v93 < v95) or (1570 >= 4332)) then
								if ((v50 and ((v32 and v57) or not v57)) or (4064 <= 1819)) then
									local v221 = 0;
									while true do
										if ((v221 == 0) or (4986 < 1574)) then
											v29 = v112();
											if ((4426 > 172) and v29) then
												return v29;
											end
											break;
										end
									end
								end
							end
							if ((586 > 455) and v40 and v98['HeroicThrow']:IsCastable() and not v14:IsInRange(30)) then
								if ((826 == 826) and v23(v98.HeroicThrow, not v14:IsInRange(30))) then
									return "heroic_throw main";
								end
							end
							v206 = 2;
						end
					end
				end
				break;
			end
			if ((v135 == 0) or (4019 > 4441)) then
				v29 = v111();
				if ((2017 < 4261) and v29) then
					return v29;
				end
				v135 = 1;
			end
		end
	end
	local function v118()
		local v136 = 0;
		while true do
			if ((4716 > 80) and (2 == v136)) then
				v45 = EpicSettings['Settings']['useShockwave'];
				v47 = EpicSettings['Settings']['useThunderClap'];
				v49 = EpicSettings['Settings']['useWreckingThrow'];
				v34 = EpicSettings['Settings']['useAvatar'];
				v136 = 3;
			end
			if ((4 == v136) or (3507 == 3272)) then
				v52 = EpicSettings['Settings']['avatarWithCD'];
				v53 = EpicSettings['Settings']['ravagerWithCD'];
				v54 = EpicSettings['Settings']['shieldChargeWithCD'];
				v55 = EpicSettings['Settings']['spearOfBastionWithCD'];
				v136 = 5;
			end
			if ((1 == v136) or (876 >= 3075)) then
				v39 = EpicSettings['Settings']['useExecute'];
				v40 = EpicSettings['Settings']['useHeroicThrow'];
				v42 = EpicSettings['Settings']['useRevenge'];
				v44 = EpicSettings['Settings']['useShieldSlam'];
				v136 = 2;
			end
			if ((4352 > 2554) and (v136 == 5)) then
				v56 = EpicSettings['Settings']['thunderousRoarWithCD'];
				break;
			end
			if ((v136 == 0) or (4406 < 4043)) then
				v35 = EpicSettings['Settings']['useBattleShout'];
				v36 = EpicSettings['Settings']['useCharge'];
				v37 = EpicSettings['Settings']['useDemoralizingShout'];
				v38 = EpicSettings['Settings']['useDevastate'];
				v136 = 1;
			end
			if ((v136 == 3) or (1889 >= 3383)) then
				v41 = EpicSettings['Settings']['useRavager'];
				v43 = EpicSettings['Settings']['useShieldCharge'];
				v46 = EpicSettings['Settings']['useSpearOfBastion'];
				v48 = EpicSettings['Settings']['useThunderousRoar'];
				v136 = 4;
			end
		end
	end
	local function v119()
		local v137 = 0;
		while true do
			if ((1892 <= 2734) and (v137 == 5)) then
				v76 = EpicSettings['Settings']['lastStandHP'] or 0;
				v79 = EpicSettings['Settings']['rallyingCryGroup'] or 0;
				v78 = EpicSettings['Settings']['rallyingCryHP'] or 0;
				v137 = 6;
			end
			if ((1923 < 2218) and (v137 == 1)) then
				v62 = EpicSettings['Settings']['useBitterImmunity'];
				v66 = EpicSettings['Settings']['useIgnorePain'];
				v68 = EpicSettings['Settings']['useIntervene'];
				v137 = 2;
			end
			if ((2173 > 379) and (4 == v137)) then
				v73 = EpicSettings['Settings']['bitterImmunityHP'] or 0;
				v77 = EpicSettings['Settings']['ignorePainHP'] or 0;
				v80 = EpicSettings['Settings']['interveneHP'] or 0;
				v137 = 5;
			end
			if ((v137 == 2) or (2591 == 3409)) then
				v65 = EpicSettings['Settings']['useLastStand'];
				v67 = EpicSettings['Settings']['useRallyingCry'];
				v64 = EpicSettings['Settings']['useShieldBlock'];
				v137 = 3;
			end
			if ((4514 > 3324) and (v137 == 6)) then
				v75 = EpicSettings['Settings']['shieldBlockHP'] or 0;
				v74 = EpicSettings['Settings']['shieldWallHP'] or 0;
				v85 = EpicSettings['Settings']['victoryRushHP'] or 0;
				v137 = 7;
			end
			if ((v137 == 7) or (208 >= 4828)) then
				v81 = EpicSettings['Settings']['defensiveStanceHP'] or 0;
				v86 = EpicSettings['Settings']['ravagerSetting'] or "";
				v87 = EpicSettings['Settings']['spearSetting'] or "";
				break;
			end
			if ((v137 == 3) or (1583 > 3567)) then
				v63 = EpicSettings['Settings']['useShieldWall'];
				v72 = EpicSettings['Settings']['useVictoryRush'];
				v96 = EpicSettings['Settings']['useChangeStance'];
				v137 = 4;
			end
			if ((v137 == 0) or (1313 == 794)) then
				v59 = EpicSettings['Settings']['usePummel'];
				v60 = EpicSettings['Settings']['useStormBolt'];
				v61 = EpicSettings['Settings']['useIntimidatingShout'];
				v137 = 1;
			end
		end
	end
	local function v120()
		local v138 = 0;
		while true do
			if ((3174 > 2902) and (v138 == 3)) then
				v89 = EpicSettings['Settings']['HealingPotionName'] or "";
				v88 = EpicSettings['Settings']['HandleIncorporeal'];
				break;
			end
			if ((4120 <= 4260) and (v138 == 0)) then
				v93 = EpicSettings['Settings']['fightRemainsCheck'] or 0;
				v90 = EpicSettings['Settings']['InterruptWithStun'];
				v91 = EpicSettings['Settings']['InterruptOnlyWhitelist'];
				v92 = EpicSettings['Settings']['InterruptThreshold'];
				v138 = 1;
			end
			if ((v138 == 2) or (883 > 4778)) then
				v70 = EpicSettings['Settings']['useHealthstone'];
				v71 = EpicSettings['Settings']['useHealingPotion'];
				v82 = EpicSettings['Settings']['healthstoneHP'] or 0;
				v83 = EpicSettings['Settings']['healingPotionHP'] or 0;
				v138 = 3;
			end
			if ((v138 == 1) or (3620 >= 4891)) then
				v50 = EpicSettings['Settings']['useTrinkets'];
				v51 = EpicSettings['Settings']['useRacials'];
				v57 = EpicSettings['Settings']['trinketsWithCD'];
				v58 = EpicSettings['Settings']['racialsWithCD'];
				v138 = 2;
			end
		end
	end
	local function v121()
		local v139 = 0;
		while true do
			if ((4258 > 937) and (v139 == 4)) then
				if (not v13:IsChanneling() or (4869 < 906)) then
					if (v13:AffectingCombat() or (1225 > 4228)) then
						local v211 = 0;
						while true do
							if ((3328 > 2238) and (v211 == 0)) then
								v29 = v117();
								if ((3839 > 1405) and v29) then
									return v29;
								end
								break;
							end
						end
					else
						local v212 = 0;
						while true do
							if ((v212 == 0) or (1293 <= 507)) then
								v29 = v116();
								if (v29 or (2896 < 805)) then
									return v29;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((2316 == 2316) and (v139 == 0)) then
				v119();
				v118();
				v120();
				v139 = 1;
			end
			if ((v139 == 3) or (2570 == 1533)) then
				if (v31 or (883 == 1460)) then
					local v208 = 0;
					while true do
						if ((0 == v208) or (4619 <= 999)) then
							v103 = v13:GetEnemiesInMeleeRange(v28);
							v104 = #v103;
							break;
						end
					end
				else
					v104 = 1;
				end
				v102 = v14:IsInMeleeRange(v28);
				if (v97.TargetIsValid() or v13:AffectingCombat() or (3410 > 4116)) then
					local v209 = 0;
					while true do
						if ((v209 == 1) or (903 >= 3059)) then
							if ((v95 == 11111) or (3976 < 2857)) then
								v95 = v10.FightRemains(v103, false);
							end
							break;
						end
						if ((4930 > 2307) and (v209 == 0)) then
							v94 = v10.BossFightRemains(nil, true);
							v95 = v94;
							v209 = 1;
						end
					end
				end
				v139 = 4;
			end
			if ((2 == v139) or (4046 < 1291)) then
				v33 = EpicSettings['Toggles']['kick'];
				if (v13:IsDeadOrGhost() or (4241 == 3545)) then
					return;
				end
				if (v98['IntimidatingShout']:IsAvailable() or (4048 > 4232)) then
					v28 = 8;
				end
				v139 = 3;
			end
			if ((v139 == 1) or (1750 >= 3473)) then
				v30 = EpicSettings['Toggles']['ooc'];
				v31 = EpicSettings['Toggles']['aoe'];
				v32 = EpicSettings['Toggles']['cds'];
				v139 = 2;
			end
		end
	end
	local function v122()
		v19.Print("Protection Warrior by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(73, v121, v122);
end;
return v0["Epix_Warrior_Protection.lua"]();

