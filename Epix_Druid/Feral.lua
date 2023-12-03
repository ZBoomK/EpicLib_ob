local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((8923 - 5568) >= (4850 - (1339 + 659))) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Druid_Feral.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.MouseOver;
	local v14 = v11.Pet;
	local v15 = v11.Target;
	local v16 = v9.Spell;
	local v17 = v9.MultiSpell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Cast;
	local v21 = v19.CastPooling;
	local v22 = v19.Macro;
	local v23 = v19.Press;
	local v24 = v19.Commons.Everyone.num;
	local v25 = v19.Commons.Everyone.bool;
	local v26 = math.floor;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = v19.Commons.Everyone;
	local v32 = v16.Druid.Feral;
	local v33 = v18.Druid.Feral;
	local v34 = {v33.AshesoftheEmbersoul:ID(),v33.BandolierofTwistedBlades:ID(),v33.MydasTalisman:ID(),v33.WitherbarksBranch:ID()};
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
	local v62 = v22.Druid.Feral;
	local v63, v64, v65, v66, v67, v68, v69;
	local v70, v71;
	local v72, v73;
	local v74 = 18084 - 6973;
	local v75 = 25892 - 14781;
	local v76, v77;
	local v78, v79;
	local v80, v81;
	local v82, v83;
	local v84 = (v32.Incarnation:IsAvailable() and v32.Incarnation) or v32.Berserk;
	v9:RegisterForEvent(function()
		v84 = (v32.Incarnation:IsAvailable() and v32.Incarnation) or v32.Berserk;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v9:RegisterForEvent(function()
		local v126 = 0 - 0;
		while true do
			if ((v126 == (0 + 0)) or ((1844 - 795) <= (1878 - 972))) then
				v74 = 12923 - (1293 + 519);
				v75 = 22669 - 11558;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		local v127 = 0 - 0;
		while true do
			if (((8629 - 4116) > (11754 - 9028)) and (v127 == (0 - 0))) then
				v32.AdaptiveSwarm:RegisterInFlightEffect(207561 + 184328);
				v32.AdaptiveSwarm:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v32.AdaptiveSwarm:RegisterInFlightEffect(79953 + 311936);
	v32.AdaptiveSwarm:RegisterInFlight();
	local function v85()
		return (v12:StealthUp(true, true) and (2.6 - 1)) or (1 + 0);
	end
	v32.Rake:RegisterPMultiplier(v32.RakeDebuff, v85);
	v32.Shred:RegisterDamageFormula(function()
		return v12:AttackPowerDamageMod() * (0.7762 + 0) * ((v12:StealthUp(true) and (1.6 + 0)) or (1097 - (709 + 387))) * ((1859 - (673 + 1185)) + (v12:VersatilityDmgPct() / (290 - 190)));
	end);
	v32.Thrash:RegisterDamageFormula(function()
		return (v12:AttackPowerDamageMod() * (0.1272 - 0)) + (v12:AttackPowerDamageMod() * (0.4055 - 0));
	end);
	local v86 = {v32.Rake,v32.LIMoonfire,v32.Thrash,v32.BrutalSlash,v32.Swipe,v32.Shred,v32.FeralFrenzy};
	local function v87(v128, v129)
		for v199, v200 in pairs(v128) do
			if (v200:DebuffRefreshable(v129) or ((2764 - (1040 + 243)) >= (7933 - 5275))) then
				return true;
			end
		end
		return false;
	end
	local function v88(v130)
		local v131 = 1847 - (559 + 1288);
		local v132;
		while true do
			if ((v131 == (1932 - (609 + 1322))) or ((3674 - (13 + 441)) == (5096 - 3732))) then
				return v132;
			end
			if ((v131 == (0 - 0)) or ((5249 - 4195) > (127 + 3265))) then
				v132 = nil;
				for v212, v213 in pairs(v130) do
					local v214 = 0 - 0;
					local v215;
					while true do
						if ((v214 == (0 + 0)) or ((297 + 379) >= (4872 - 3230))) then
							v215 = v213:PMultiplier(v32.Rake);
							if (((2264 + 1872) > (4408 - 2011)) and (not v132 or (v215 < v132))) then
								v132 = v215;
							end
							break;
						end
					end
				end
				v131 = 1 + 0;
			end
		end
	end
	local function v89(v133)
		if (not v32.Bloodtalons:IsAvailable() or ((2411 + 1923) == (3051 + 1194))) then
			return false;
		end
		return v133:TimeSinceLastCast() < math.min(5 + 0, v32.BloodtalonsBuff:TimeSinceLastAppliedOnPlayer());
	end
	local function v90(v134)
		return not v89(v134);
	end
	function CountActiveBtTriggers()
		local v135 = 0 + 0;
		for v201 = 434 - (153 + 280), #v86 do
			if (v89(v86[v201]) or ((12347 - 8071) <= (2722 + 309))) then
				v135 = v135 + 1 + 0;
			end
		end
		return v135;
	end
	local function v91(v136, v137)
		local v138 = 0 + 0;
		local v139;
		local v140;
		local v141;
		local v142;
		local v143;
		local v144;
		local v145;
		local v146;
		while true do
			if ((v138 == (3 + 0)) or ((3466 + 1316) <= (1825 - 626))) then
				return v146;
			end
			if ((v138 == (2 + 0)) or ((5531 - (89 + 578)) < (1359 + 543))) then
				if (((10059 - 5220) >= (4749 - (572 + 477))) and (v144 > v140)) then
					v144 = v140;
				end
				v145 = v144 / v141;
				if (not v142 or ((145 + 930) > (1152 + 766))) then
					v142 = 0 + 0;
				end
				v146 = v145 - v142;
				v138 = 89 - (84 + 2);
			end
			if (((652 - 256) <= (2741 + 1063)) and (v138 == (842 - (497 + 345)))) then
				if (not v137 or ((107 + 4062) == (370 + 1817))) then
					v137 = v15;
				end
				v139 = 1333 - (605 + 728);
				v140 = 0 + 0;
				v141 = 0 - 0;
				v138 = 1 + 0;
			end
			if (((5198 - 3792) == (1268 + 138)) and (v138 == (2 - 1))) then
				if (((1156 + 375) < (4760 - (457 + 32))) and (v136 == v32.Rip)) then
					local v216 = 0 + 0;
					while true do
						if (((2037 - (832 + 570)) == (599 + 36)) and (v216 == (0 + 0))) then
							v139 = (13 - 9) + (v72 * (2 + 2));
							v140 = 827.2 - (588 + 208);
							v216 = 2 - 1;
						end
						if (((5173 - (884 + 916)) <= (7444 - 3888)) and (v216 == (1 + 0))) then
							v141 = v136:TickTime();
							break;
						end
					end
				else
					local v217 = 653 - (232 + 421);
					while true do
						if ((v217 == (1890 - (1569 + 320))) or ((808 + 2483) < (624 + 2656))) then
							v141 = v136:TickTime();
							break;
						end
						if (((14779 - 10393) >= (1478 - (316 + 289))) and ((0 - 0) == v217)) then
							v139 = v136:BaseDuration();
							v140 = v136:MaxDuration();
							v217 = 1 + 0;
						end
					end
				end
				v142 = v137:DebuffTicksRemain(v136);
				v143 = v137:DebuffRemains(v136);
				v144 = v139 + v143;
				v138 = 1455 - (666 + 787);
			end
		end
	end
	local function v92(v147)
		if (((1346 - (360 + 65)) <= (1030 + 72)) and not v147) then
			return 254 - (79 + 175);
		end
		local v148 = 0 - 0;
		local v149 = nil;
		for v202, v203 in pairs(v147) do
			local v204 = 0 + 0;
			local v205;
			while true do
				if (((14424 - 9718) >= (1854 - 891)) and (v204 == (899 - (503 + 396)))) then
					v205 = v203:TimeToDie();
					if ((v205 > v148) or ((1141 - (92 + 89)) <= (1698 - 822))) then
						local v225 = 0 + 0;
						while true do
							if ((v225 == (0 + 0)) or ((8090 - 6024) == (128 + 804))) then
								v148 = v205;
								v149 = v203;
								break;
							end
						end
					end
					break;
				end
			end
		end
		return v148, v149;
	end
	local function v93(v150)
		return ((2 - 1) + v150:DebuffStack(v32.AdaptiveSwarmDebuff)) * v24(v150:DebuffStack(v32.AdaptiveSwarmDebuff) < (3 + 0)) * v150:TimeToDie();
	end
	local function v94(v151)
		return ((2 + 1) * v24(v151:DebuffRefreshable(v32.LIMoonfireDebuff))) + v24(v151:DebuffUp(v32.LIMoonfireDebuff));
	end
	local function v95(v152)
		return ((75 - 50) * v24(v12:PMultiplier(v32.Rake) < v152:PMultiplier(v32.Rake))) + v152:DebuffRemains(v32.RakeDebuff);
	end
	local function v96(v153)
		return (v91(v32.RakeDebuff, v153));
	end
	local function v97(v154)
		return (v154:TimeToDie());
	end
	local function v98(v155)
		return v155:DebuffStack(v32.AdaptiveSwarmDebuff) < (1 + 2);
	end
	local function v99(v156)
		return (v32.BrutalSlash:FullRechargeTime() < (5 - 1)) or (v156:TimeToDie() < (1249 - (485 + 759)));
	end
	local function v100(v157)
		return ((v32.BrutalSlash:FullRechargeTime() < (8 - 4)) or (v157:TimeToDie() < (1194 - (442 + 747)))) and v90(v32.BrutalSlash) and (v12:BuffUp(v84) or v63);
	end
	local function v101(v158)
		return (v75 < (1140 - (832 + 303))) or ((v12:BuffUp(v32.SmolderingFrenzyBuff) or not v12:HasTier(977 - (88 + 858), 2 + 2)) and (v158:DebuffRemains(v32.Rip) > ((4 + 0) - v24(v32.AshamanesGuidance:IsAvailable()))) and v12:BuffUp(v32.TigersFury) and (v72 < (1 + 1)) and (v158:DebuffUp(v32.DireFixationDebuff) or not v32.DireFixation:IsAvailable() or (v83 > (790 - (766 + 23)))) and (((v158:TimeToDie() < v75) and (v158:TimeToDie() > ((24 - 19) - v24(v32.AshamanesGuidance:IsAvailable())))) or (v158:TimeToDie() == v75)));
	end
	local function v102(v159)
		return (v159:DebuffRefreshable(v32.LIMoonfireDebuff));
	end
	local function v103(v160)
		return (v91(v32.LIMoonfireDebuff, v160));
	end
	local function v104(v161)
		return ((v72 < (3 - 0)) or ((v9.CombatTime() < (26 - 16)) and (v72 < (13 - 9)))) and (not v32.DireFixation:IsAvailable() or v161:DebuffUp(v32.DireFixationDebuff) or (v83 > (1074 - (1036 + 37)))) and (((v161:TimeToDie() < v75) and (v15:TimeToDie() > (5 + 1))) or (v161:TimeToDie() == v75)) and not ((v83 == (1 - 0)) and v32.ConvokeTheSpirits:IsAvailable());
	end
	local function v105(v162)
		return v12:PMultiplier(v32.Rake) > v15:PMultiplier(v32.Rake);
	end
	local function v106(v163)
		return (v163:DebuffRefreshable(v32.RakeDebuff) or (v12:BuffUp(v32.SuddenAmbushBuff) and (v12:PMultiplier(v32.Rake) > v163:PMultiplier(v32.Rake)))) and v90(v32.Rake);
	end
	local function v107(v164)
		return v164:DebuffRemains(v32.Rip) > (4 + 1);
	end
	local function v108(v165)
		return (v165:DebuffDown(v32.AdaptiveSwarmDebuff) or (v165:DebuffRemains(v32.AdaptiveSwarmDebuff) < (1482 - (641 + 839)))) and (v165:DebuffStack(v32.AdaptiveSwarmDebuff) < (916 - (910 + 3))) and not v32.AdaptiveSwarm:InFlight() and (v165:TimeToDie() > (12 - 7));
	end
	local function v109(v166)
		return (v166:DebuffRefreshable(v32.LIMoonfireDebuff));
	end
	local function v110(v167)
		return (v12:BuffUp(v32.SuddenAmbushBuff) and (v12:PMultiplier(v32.Rake) > v167:PMultiplier(v32.Rake))) or v167:DebuffRefreshable(v32.RakeDebuff);
	end
	local function v111(v168)
		return v12:BuffUp(v32.SuddenAmbushBuff) and (v12:PMultiplier(v32.Rake) > v168:PMultiplier(v32.Rake));
	end
	local function v112(v169)
		return v12:PMultiplier(v32.Rake) > v169:PMultiplier(v32.Rake);
	end
	local function v113(v170)
		return ((v12:HasTier(1715 - (1466 + 218), 1 + 1) and (v32.FeralFrenzy:CooldownRemains() < (1150 - (556 + 592))) and (v170:DebuffRemains(v32.Rip) < (4 + 6))) or (((v9.CombatTime() < (816 - (329 + 479))) or v12:BuffUp(v32.BloodtalonsBuff) or not v32.Bloodtalons:IsAvailable() or (v12:BuffUp(v84) and (v170:DebuffRemains(v32.Rip) < (856 - (174 + 680))))) and v170:DebuffRefreshable(v32.Rip))) and (not v32.PrimalWrath:IsAvailable() or (v83 == (3 - 2))) and not (v12:BuffUp(v32.SmolderingFrenzyBuff) and (v170:DebuffRemains(v32.Rip) > (3 - 1)));
	end
	local function v114(v171)
		return (v171:DebuffRefreshable(v32.ThrashDebuff));
	end
	local function v115()
		if (((3445 + 1380) < (5582 - (396 + 343))) and v32.CatForm:IsCastable() and v49) then
			if (v23(v32.CatForm) or ((344 + 3533) >= (6014 - (29 + 1448)))) then
				return "cat_form precombat 2";
			end
		end
		if (v32.HeartOfTheWild:IsCastable() or ((5704 - (135 + 1254)) < (6502 - 4776))) then
			if (v23(v32.HeartOfTheWild) or ((17177 - 13498) < (417 + 208))) then
				return "heart_of_the_wild precombat 4";
			end
		end
		if ((v32.Prowl:IsCastable() and (v50 == "Always")) or ((6152 - (389 + 1138)) < (1206 - (102 + 472)))) then
			if (v23(v32.Prowl) or ((79 + 4) > (988 + 792))) then
				return "prowl precombat 4";
			end
		elseif (((510 + 36) <= (2622 - (320 + 1225))) and v32.Prowl:IsCastable() and (v50 == "Distance") and v15:IsInRange(v51)) then
			if (v23(v32.Prowl) or ((1772 - 776) > (2632 + 1669))) then
				return "prowl precombat 4";
			end
		end
		if (((5534 - (157 + 1307)) > (2546 - (821 + 1038))) and v52 and v32.WildCharge:IsCastable() and not v15:IsInRange(19 - 11)) then
			if (v23(v32.WildCharge, not v15:IsInRange(4 + 24)) or ((1164 - 508) >= (1239 + 2091))) then
				return "wild_charge precombat 6";
			end
		end
		if (v32.Rake:IsReady() or ((6176 - 3684) <= (1361 - (834 + 192)))) then
			if (((275 + 4047) >= (658 + 1904)) and v23(v32.Rake, not v78)) then
				return "rake precombat 8";
			end
		end
	end
	local function v116()
		v63 = v32.Bloodtalons:IsAvailable() and (v12:BuffStack(v32.BloodtalonsBuff) <= (1 + 0));
		local v172 = v12:IsInParty() and not v12:IsInRaid();
		v64 = (v83 == (1 - 0)) and not v172;
		v65 = (v75 > (v32.ConvokeTheSpirits:CooldownRemains() + (307 - (300 + 4)))) and ((v32.AshamanesGuidance:IsAvailable() and (v75 < (v32.ConvokeTheSpirits:CooldownRemains() + 17 + 43))) or (not v32.AshamanesGuidance:IsAvailable() and (v75 < (v32.ConvokeTheSpirits:CooldownRemains() + (31 - 19)))));
		v66 = (v75 > ((392 - (112 + 250)) + (v84:CooldownRemains() / (1.6 + 0)))) and ((v32.BerserkHeartoftheLion:IsAvailable() and (v75 < ((225 - 135) + (v84:CooldownRemains() / (1.6 + 0))))) or (not v32.BerserkHeartoftheLion:IsAvailable() and (v75 < (94 + 86 + v84:CooldownRemains()))));
		v67 = true;
		v68 = true;
		v69 = true;
		v70 = true;
		local v173 = v9.CombatTime();
		local v174 = v173 + v75;
		v71 = (v70 or v33.WitherbarksBranch:IsEquipped() or v33.AshesoftheEmbersoul:IsEquipped() or ((v174 > (113 + 37)) and (v174 < (100 + 100))) or ((v174 > (201 + 69)) and (v174 < (1709 - (1001 + 413)))) or ((v174 > (880 - 485)) and (v174 < (1282 - (244 + 638)))) or ((v174 > (1183 - (627 + 66))) and (v174 < (1474 - 979)))) and v32.ConvokeTheSpirits:IsAvailable() and not v172 and (v83 == (603 - (512 + 90))) and v12:HasTier(1937 - (1665 + 241), 719 - (373 + 344));
	end
	local function v117()
		if ((v32.Thrash:IsCastable() and v15:DebuffRefreshable(v32.ThrashDebuff) and (not v32.DireFixation:IsAvailable() or (v32.DireFixation:IsAvailable() and v15:DebuffUp(v32.DireFixationDebuff))) and v12:BuffUp(v32.Clearcasting) and not v32.ThrashingClaws:IsAvailable()) or ((1641 + 1996) >= (998 + 2772))) then
			if (v23(v32.Thrash, not v79) or ((6274 - 3895) > (7746 - 3168))) then
				return "thrash builder 2";
			end
		end
		if ((v32.Shred:IsReady() and (v12:BuffUp(v32.Clearcasting) or (v32.DireFixation:IsAvailable() and v15:DebuffDown(v32.DireFixationDebuff))) and not (v63 and v89(v32.Shred))) or ((1582 - (35 + 1064)) > (541 + 202))) then
			if (((5250 - 2796) > (3 + 575)) and v23(v32.Shred, not v78)) then
				return "shred builder 4";
			end
		end
		if (((2166 - (298 + 938)) < (5717 - (233 + 1026))) and v32.BrutalSlash:IsReady() and (v32.BrutalSlash:FullRechargeTime() < (1670 - (636 + 1030))) and not (v63 and v89(v32.BrutalSlash))) then
			if (((339 + 323) <= (950 + 22)) and v23(v32.BrutalSlash, not v79)) then
				return "brutal_slash builder 6";
			end
		end
		if (((1299 + 3071) == (296 + 4074)) and not v32.Rake:IsReady() and (v15:DebuffRefreshable(v32.RakeDebuff) or (v12:BuffUp(v32.SuddenAmbushBuff) and (v12:PMultiplier(v32.Rake) > v15:PMultiplier(v32.Rake)) and (v15:DebuffRemains(v32.RakeDebuff) > (227 - (55 + 166))))) and v12:BuffDown(v32.Clearcasting) and not (v63 and v89(v32.Rake))) then
			if (v23(v32.Pool) or ((923 + 3839) <= (87 + 774))) then
				return "Pool for Rake in Builder()";
			end
		end
		if ((v32.Shadowmeld:IsCastable() and v32.Rake:IsReady() and v12:BuffDown(v32.SuddenAmbushBuff) and (v15:DebuffRefreshable(v32.RakeDebuff) or (v15:PMultiplier(v32.Rake) < (3.4 - 2))) and not (v63 and v89(v32.Rake)) and v12:BuffDown(v32.Prowl)) or ((1709 - (36 + 261)) == (7456 - 3192))) then
			if (v23(v32.Shadowmeld) or ((4536 - (34 + 1334)) < (828 + 1325))) then
				return "shadowmeld builder 4";
			end
		end
		if ((v32.Rake:IsReady() and (v15:DebuffRefreshable(v32.RakeDebuff) or (v12:BuffUp(v32.SuddenAmbushBuff) and (v12:PMultiplier(v32.Rake) > v15:PMultiplier(v32.Rake)))) and not (v63 and v89(v32.Rake))) or ((3867 + 1109) < (2615 - (1035 + 248)))) then
			if (((4649 - (20 + 1)) == (2412 + 2216)) and v23(v32.Rake, not v78)) then
				return "rake builder 6";
			end
		end
		if (v32.LIMoonfire:IsReady() or ((373 - (134 + 185)) == (1528 - (549 + 584)))) then
			if (((767 - (314 + 371)) == (281 - 199)) and v31.CastCycle(v32.LIMoonfire, v82, v109, not v15:IsSpellInRange(v32.LIMoonfire), nil, nil, v62.MoonfireMouseover)) then
				return "moonfire_cat builder 8";
			end
		end
		if ((v32.Thrash:IsCastable() and v15:DebuffRefreshable(v32.ThrashDebuff) and not v32.ThrashingClaws:IsAvailable()) or ((1549 - (478 + 490)) < (150 + 132))) then
			if (v23(v32.Thrash, not v79) or ((5781 - (786 + 386)) < (8081 - 5586))) then
				return "thrash builder 10";
			end
		end
		if (((2531 - (1055 + 324)) == (2492 - (1093 + 247))) and v32.BrutalSlash:IsReady() and not (v63 and v89(v32.BrutalSlash))) then
			if (((1685 + 211) <= (360 + 3062)) and v23(v32.BrutalSlash, not v79)) then
				return "brutal_slash builder 12";
			end
		end
		if ((v32.Swipe:IsReady() and ((v83 > (3 - 2)) or v32.WildSlashes:IsAvailable())) or ((3359 - 2369) > (4609 - 2989))) then
			if (v23(v32.Swipe, not v79) or ((2203 - 1326) > (1671 + 3024))) then
				return "swipe builder 14";
			end
		end
		if (((10366 - 7675) >= (6379 - 4528)) and v32.Shred:IsReady() and not (v63 and v89(v32.Shred))) then
			if (v23(v32.Shred, not v78) or ((2251 + 734) >= (12418 - 7562))) then
				return "shred builder 16";
			end
		end
		if (((4964 - (364 + 324)) >= (3275 - 2080)) and v32.LIMoonfire:IsReady() and v63 and v90(v32.LIMoonfire)) then
			if (((7755 - 4523) <= (1555 + 3135)) and v23(v32.LIMoonfire, not v15:IsSpellInRange(v32.LIMoonfire))) then
				return "moonfire_cat builder 18";
			end
		end
		if ((v32.Swipe:IsReady() and v63 and v90(v32.Swipe)) or ((3748 - 2852) >= (5038 - 1892))) then
			if (((9296 - 6235) >= (4226 - (1249 + 19))) and v23(v32.Swipe, not v79)) then
				return "swipe builder 20";
			end
		end
		if (((2877 + 310) >= (2506 - 1862)) and v32.Rake:IsReady() and v63 and v90(v32.Rake) and (v12:PMultiplier(v32.Rake) >= v15:PMultiplier(v32.Rake))) then
			if (((1730 - (686 + 400)) <= (553 + 151)) and v23(v32.Rake, not v78)) then
				return "rake builder 22";
			end
		end
		if (((1187 - (73 + 156)) > (5 + 942)) and v32.Thrash:IsCastable() and v63 and v90(v32.Thrash)) then
			if (((5303 - (721 + 90)) >= (30 + 2624)) and v23(v32.Thrash, not v79)) then
				return "thrash builder 24";
			end
		end
	end
	local function v118()
		if (((11175 - 7733) >= (1973 - (224 + 246))) and v32.BrutalSlash:IsReady()) then
			if (v31.CastTargetIf(v32.BrutalSlash, v82, "min", v97, v99, not v79) or ((5135 - 1965) <= (2694 - 1230))) then
				return "brutal_slash aoe_builder 2";
			end
		end
		if ((v32.Thrash:IsReady() and (v12:BuffUp(v32.Clearcasting) or (((v83 > (2 + 8)) or ((v83 > (1 + 4)) and not v32.DoubleClawedRake:IsAvailable())) and not v32.ThrashingClaws:IsAvailable()))) or ((3524 + 1273) == (8723 - 4335))) then
			if (((1833 - 1282) <= (1194 - (203 + 310))) and v31.CastCycle(v32.Thrash, v82, v114, not v79)) then
				return "thrash aoe_builder 4";
			end
		end
		if (((5270 - (1238 + 755)) > (29 + 378)) and v32.Shadowmeld:IsReady() and v32.Rake:IsReady() and v12:BuffDown(v32.SuddenAmbushBuff) and (v87(v82, v32.RakeDebuff) or (v88(v82) < (1535.4 - (709 + 825)))) and v12:BuffDown(v32.Prowl) and v12:BuffDown(v32.ApexPredatorsCravingBuff)) then
			if (((8651 - 3956) >= (2060 - 645)) and v23(v32.Shadowmeld)) then
				return "shadowmeld aoe_builder 6";
			end
		end
		if ((v32.Shadowmeld:IsReady() and v32.Rake:IsReady() and v12:BuffDown(v32.SuddenAmbushBuff) and (v88(v82) < (865.4 - (196 + 668))) and v12:BuffDown(v32.Prowl) and v12:BuffDown(v32.ApexPredatorsCravingBuff)) or ((12681 - 9469) <= (1955 - 1011))) then
			if (v23(v32.Shadowmeld) or ((3929 - (171 + 662)) <= (1891 - (4 + 89)))) then
				return "shadowmeld aoe_builder 8";
			end
		end
		if (((12397 - 8860) == (1288 + 2249)) and v32.Rake:IsReady() and (v12:BuffUp(v32.SuddenAmbushBuff))) then
			if (((16852 - 13015) >= (616 + 954)) and v31.CastTargetIf(v32.Rake, v80, "max", v96, v105, not v78)) then
				return "rake aoe_builder 10";
			end
		end
		if (v32.Rake:IsReady() or ((4436 - (35 + 1451)) == (5265 - (28 + 1425)))) then
			if (((6716 - (941 + 1052)) >= (2223 + 95)) and v31.CastCycle(v32.Rake, v80, v110, not v78, nil, nil, v62.RakeMouseover)) then
				return "rake aoe_builder 12";
			end
		end
		if ((v32.Thrash:IsReady() and (v15:DebuffRefreshable(v32.ThrashDebuff))) or ((3541 - (822 + 692)) > (4071 - 1219))) then
			if (v23(v32.Thrash, not v79) or ((536 + 600) > (4614 - (45 + 252)))) then
				return "thrash aoe_builder 14";
			end
		end
		if (((4698 + 50) == (1635 + 3113)) and v32.BrutalSlash:IsReady()) then
			if (((9092 - 5356) <= (5173 - (114 + 319))) and v23(v32.BrutalSlash, not v79)) then
				return "brutal_slash aoe_builder 16";
			end
		end
		if ((v32.LIMoonfire:IsReady() and (v83 < (6 - 1))) or ((4343 - 953) <= (1951 + 1109))) then
			if (v31.CastTargetIf(v32.LIMoonfire, v82, "max", v94, v102, not v15:IsSpellInRange(v32.LIMoonfire)) or ((1487 - 488) > (5642 - 2949))) then
				return "moonfire_cat aoe_builders 18";
			end
		end
		if (((2426 - (556 + 1407)) < (1807 - (741 + 465))) and v32.Swipe:IsReady()) then
			if (v23(v32.Swipe, not v79) or ((2648 - (170 + 295)) < (362 + 325))) then
				return "swipe aoe_builder 20";
			end
		end
		if (((4179 + 370) == (11199 - 6650)) and v32.LIMoonfire:IsReady()) then
			if (((3873 + 799) == (2997 + 1675)) and v31.CastTargetIf(v32.LIMoonfire, v82, "max", v94, v102, not v15:IsSpellInRange(v32.LIMoonfire))) then
				return "moonfire_cat aoe_builders 22";
			end
		end
		if ((v32.Shred:IsReady() and ((v83 < (3 + 1)) or v32.DireFixation:IsAvailable()) and v12:BuffDown(v32.SuddenAmbushBuff) and not (v69 and v32.WildSlashes:IsAvailable())) or ((4898 - (957 + 273)) < (106 + 289))) then
			if (v31.CastTargetIf(v32.Shred, v80, "max", v97, nil, not v78) or ((1668 + 2498) == (1733 - 1278))) then
				return "shred aoe_builder 24";
			end
		end
		if (v32.Thrash:IsReady() or ((11723 - 7274) == (8134 - 5471))) then
			if (v23(v32.Thrash, not v79) or ((21178 - 16901) < (4769 - (389 + 1391)))) then
				return "thrash aoe_builder 26";
			end
		end
	end
	local function v119()
		if ((v32.PrimalWrath:IsCastable() and (v15:DebuffRefreshable(v32.PrimalWrath) or v32.TearOpenWounds:IsAvailable() or ((v83 > (3 + 1)) and not v32.RampantFerocity:IsAvailable())) and (v83 > (1 + 0)) and v32.PrimalWrath:IsAvailable()) or ((1980 - 1110) >= (5100 - (783 + 168)))) then
			if (((7423 - 5211) < (3131 + 52)) and v21(v32.PrimalWrath, v12:EnergyTimeToX(331 - (309 + 2)))) then
				return "primal_wrath finisher 2";
			end
		end
		if (((14267 - 9621) > (4204 - (1090 + 122))) and v32.Rip:IsReady()) then
			if (((465 + 969) < (10431 - 7325)) and v31.CastCycle(v32.Rip, v80, v113, not v15:IsInRange(6 + 2), nil, nil, v62.RipMouseover)) then
				return "rip finisher 4";
			end
		end
		if (((1904 - (628 + 490)) < (543 + 2480)) and v32.FerociousBite:IsReady() and v12:BuffDown(v32.ApexPredatorsCravingBuff) and (v12:BuffDown(v84) or (v12:BuffUp(v84) and not v32.SouloftheForest:IsAvailable()))) then
			if ((not v32.TigersFury:IsReady() and v12:BuffDown(v32.ApexPredatorsCravingBuff)) or ((6045 - 3603) < (338 - 264))) then
				if (((5309 - (431 + 343)) == (9158 - 4623)) and v21(v32.FerociousBite, v12:EnergyTimeToX(144 - 94))) then
					return "ferocious_bite finisher 6";
				end
			elseif ((v12:Energy() >= (40 + 10)) or ((385 + 2624) <= (3800 - (556 + 1139)))) then
				if (((1845 - (6 + 9)) < (672 + 2997)) and v31.CastTargetIf(v32.FerociousBite, v80, "max", v97, nil, not v78)) then
					return "ferocious_bite finisher 8";
				end
			end
		end
		if ((v32.FerociousBite:IsReady() and ((v12:BuffUp(v84) and v32.SouloftheForest:IsAvailable()) or v12:BuffUp(v32.ApexPredatorsCravingBuff))) or ((733 + 697) >= (3781 - (28 + 141)))) then
			if (((1040 + 1643) >= (3036 - 576)) and v31.CastTargetIf(v32.FerociousBite, v80, "max", v97, nil, not v78)) then
				return "ferocious_bite finisher 10";
			end
		end
	end
	local function v120()
		local v175 = 0 + 0;
		while true do
			if ((v175 == (1318 - (486 + 831))) or ((4694 - 2890) >= (11530 - 8255))) then
				if ((v32.Shadowmeld:IsCastable() and not (v89(v32.Rake) and (CountActiveBtTriggers() == (1 + 1))) and v32.Rake:IsReady() and v12:BuffDown(v32.SuddenAmbushBuff) and (v15:DebuffRefreshable(v32.RakeDebuff) or (v15:PMultiplier(v32.Rake) < (3.4 - 2))) and v12:BuffDown(v32.Prowl)) or ((2680 - (668 + 595)) > (3266 + 363))) then
					if (((967 + 3828) > (1096 - 694)) and v23(v32.Shadowmeld)) then
						return "shadowmeld berserk 6";
					end
				end
				if (((5103 - (23 + 267)) > (5509 - (1129 + 815))) and v32.Rake:IsReady() and not (v89(v32.Rake) and (CountActiveBtTriggers() == (389 - (371 + 16)))) and ((v15:DebuffRemains(v32.RakeDebuff) < (1753 - (1326 + 424))) or (v12:BuffUp(v32.SuddenAmbushBuff) and (v12:PMultiplier(v32.Rake) > v15:PMultiplier(v32.Rake))))) then
					if (((7408 - 3496) == (14295 - 10383)) and v23(v32.Rake, not v78)) then
						return "rake berserk 8";
					end
				end
				if (((2939 - (88 + 30)) <= (5595 - (720 + 51))) and v32.Shred:IsReady() and (CountActiveBtTriggers() == (4 - 2)) and v90(v32.Shred)) then
					if (((3514 - (421 + 1355)) <= (3621 - 1426)) and v23(v32.Shred, not v78)) then
						return "shred berserk 10";
					end
				end
				if (((21 + 20) <= (4101 - (286 + 797))) and v32.BrutalSlash:IsReady() and (CountActiveBtTriggers() == (7 - 5)) and v90(v32.BrutalSlash)) then
					if (((3552 - 1407) <= (4543 - (397 + 42))) and v23(v32.BrutalSlash, not v79)) then
						return "brutal_slash berserk 12";
					end
				end
				v175 = 1 + 1;
			end
			if (((3489 - (24 + 776)) < (7464 - 2619)) and (v175 == (785 - (222 + 563)))) then
				if ((v32.FerociousBite:IsReady() and (v72 == (11 - 6)) and v67 and (v83 > (1 + 0))) or ((2512 - (23 + 167)) > (4420 - (690 + 1108)))) then
					if (v31.CastTargetIf(v32.FerociousBite, v80, "max", v97, v107, not v78) or ((1636 + 2898) == (1718 + 364))) then
						return "ferocious_bite berserk 2";
					end
				end
				if (((v72 == (853 - (40 + 808))) and not ((v12:BuffStack(v32.OverflowingPowerBuff) <= (1 + 0)) and (CountActiveBtTriggers() == (7 - 5)) and (v12:BuffStack(v32.BloodtalonsBuff) <= (1 + 0)) and v12:HasTier(16 + 14, 3 + 1))) or ((2142 - (47 + 524)) > (1212 + 655))) then
					local v218 = 0 - 0;
					local v219;
					while true do
						if ((v218 == (0 - 0)) or ((6052 - 3398) >= (4722 - (1165 + 561)))) then
							v219 = v119();
							if (((119 + 3859) > (6516 - 4412)) and v219) then
								return v219;
							end
							break;
						end
					end
				end
				if (((1143 + 1852) > (2020 - (341 + 138))) and (v83 > (1 + 0))) then
					local v220 = 0 - 0;
					local v221;
					while true do
						if (((3575 - (89 + 237)) > (3065 - 2112)) and (v220 == (0 - 0))) then
							v221 = v118();
							if (v221 or ((4154 - (581 + 300)) > (5793 - (855 + 365)))) then
								return v221;
							end
							v220 = 2 - 1;
						end
						if ((v220 == (1 + 0)) or ((4386 - (1030 + 205)) < (1206 + 78))) then
							if (v23(v32.Pool) or ((1721 + 129) == (1815 - (156 + 130)))) then
								return "Wait for AoeBuilder()";
							end
							break;
						end
					end
				end
				if (((1865 - 1044) < (3577 - 1454)) and v32.Prowl:IsReady() and not (v89(v32.Rake) and (CountActiveBtTriggers() == (3 - 1))) and v32.Rake:IsReady() and v12:BuffDown(v32.SuddenAmbushBuff) and (v15:DebuffRefreshable(v32.RakeDebuff) or (v15:PMultiplier(v32.Rake) < (1.4 + 0))) and v12:BuffDown(v32.Shadowmeld)) then
					if (((526 + 376) < (2394 - (10 + 59))) and v23(v32.Prowl)) then
						return "prowl berserk 4";
					end
				end
				v175 = 1 + 0;
			end
			if (((4225 - 3367) <= (4125 - (671 + 492))) and (v175 == (3 + 0))) then
				if (v32.Shred:IsReady() or ((5161 - (369 + 846)) < (341 + 947))) then
					if (v23(v32.Shred, not v78) or ((2767 + 475) == (2512 - (1036 + 909)))) then
						return "shred berserk 22";
					end
				end
				break;
			end
			if ((v175 == (2 + 0)) or ((1421 - 574) >= (1466 - (11 + 192)))) then
				if ((v32.LIMoonfire:IsReady() and (CountActiveBtTriggers() == (2 + 0)) and v90(v32.LIMoonfire)) or ((2428 - (135 + 40)) == (4484 - 2633))) then
					if (v23(v32.LIMoonfire, not v15:IsSpellInRange(v32.LIMoonfire)) or ((1258 + 829) > (5225 - 2853))) then
						return "moonfire_cat berserk 14";
					end
				end
				if ((v32.Thrash:IsReady() and (CountActiveBtTriggers() == (2 - 0)) and v90(v32.Thrash) and not v32.ThrashingClaws:IsAvailable() and v63) or ((4621 - (50 + 126)) < (11552 - 7403))) then
					if (v23(v32.Thrash, not v79) or ((403 + 1415) == (1498 - (1233 + 180)))) then
						return "thrash berserk 16";
					end
				end
				if (((1599 - (522 + 447)) < (3548 - (107 + 1314))) and v32.LIMoonfire:IsReady()) then
					if (v31.CastCycle(v32.LIMoonfire, v82, v109, not v15:IsSpellInRange(v32.LIMoonfire), nil, nil, v62.MoonfireMouseover) or ((900 + 1038) == (7660 - 5146))) then
						return "moonfire_cat berserk 18";
					end
				end
				if (((1808 + 2447) >= (109 - 54)) and v32.BrutalSlash:IsReady() and (v32.BrutalSlash:Charges() > (3 - 2)) and (not v32.DireFixation:IsAvailable() or v15:DebuffUp(v32.DireFixationDebuff))) then
					if (((4909 - (716 + 1194)) > (20 + 1136)) and v23(v32.BrutalSlash, not v79)) then
						return "brutal_slash berserk 20";
					end
				end
				v175 = 1 + 2;
			end
		end
	end
	local function v121()
		local v176, v177 = v92(v82);
		if (((2853 - (74 + 429)) > (2228 - 1073)) and v32.Incarnation:IsReady() and v29 and (((v176 < v75) and (v176 > (13 + 12))) or (v176 == v75))) then
			if (((9222 - 5193) <= (3434 + 1419)) and v23(v32.Incarnation, not v78)) then
				return "incarnation cooldown 6";
			end
		end
		if ((v32.Berserk:IsReady() and v29 and ((v75 < (76 - 51)) or (v32.ConvokeTheSpirits:IsAvailable() and ((v75 < v32.ConvokeTheSpirits:CooldownRemains()) or (v71 and ((v32.FeralFrenzy:IsReady() and ((v72 < (7 - 4)) or ((v9.CombatTime() < (443 - (279 + 154))) and (v72 < (782 - (454 + 324)))))) or ((v9.CombatTime() < (8 + 2)) and (v72 < (21 - (12 + 5))))) and (v32.ConvokeTheSpirits:CooldownRemains() < (6 + 4))))))) or ((1314 - 798) > (1269 + 2165))) then
			if (((5139 - (277 + 816)) >= (12960 - 9927)) and v23(v32.Berserk, not v78)) then
				return "berserk cooldown 8";
			end
		end
		if ((v32.Berserk:IsReady() and v29 and not v71 and not (not v32.FranticMomentum:IsAvailable() and v33.WitherbarksBranch:IsEquipped() and (v83 == (1184 - (1058 + 125)))) and (not v66 or (v66 and not v65) or (v65 and (v32.ConvokeTheSpirits:CooldownRemains() < (2 + 8)) and (not v12:HasTier(1006 - (815 + 160), 8 - 6) or (v12:HasTier(73 - 42, 1 + 1) and v12:BuffUp(v32.SmolderingFrenzyBuff))))) and (((v15:TimeToDie() < v75) and (v15:TimeToDie() > (52 - 34))) or (v15:TimeToDie() == v75))) or ((4617 - (41 + 1857)) <= (3340 - (1222 + 671)))) then
			if (v23(v32.Berserk, not v78) or ((10684 - 6550) < (5642 - 1716))) then
				return "berserk cooldown 10";
			end
		end
		if ((v32.Berserk:IsReady() and ((v75 < (1205 - (229 + 953))) or ((((v9.CombatTime() + (1892 - (1111 + 663))) % (1699 - (874 + 705))) < (5 + 25)) and not v32.FranticMomentum:IsAvailable() and (v33.WitherbarksBranch:IsEquipped() or v33.AshesoftheEmbersoul:IsEquipped()) and (v83 == (1 + 0))))) or ((340 - 176) >= (79 + 2706))) then
			if (v23(v32.Berserk, not v78) or ((1204 - (642 + 37)) == (481 + 1628))) then
				return "berserk cooldown 12";
			end
		end
		if (((6 + 27) == (82 - 49)) and v32.Berserking:IsCastable() and v29 and (not v64 or v12:BuffUp(v84))) then
			if (((3508 - (233 + 221)) <= (9284 - 5269)) and v23(v32.Berserking, not v78)) then
				return "berserking cooldown 12";
			end
		end
		if (((1647 + 224) < (4923 - (718 + 823))) and v32.ConvokeTheSpirits:IsReady() and v29) then
			if (((814 + 479) <= (2971 - (266 + 539))) and v23(v32.ConvokeTheSpirits, not v78)) then
				return "convoke_the_spirits cooldown 16";
			end
		end
		if ((v32.ConvokeTheSpirits:IsReady() and v29 and v12:BuffUp(v32.SmolderingFrenzyBuff) and (v12:BuffRemains(v32.SmolderingFrenzyBuff) < ((13.1 - 8) - v24(v32.AshamanesGuidance:IsAvailable())))) or ((3804 - (636 + 589)) < (291 - 168))) then
			if (v23(v32.ConvokeTheSpirits, not v78) or ((1744 - 898) >= (1877 + 491))) then
				return "convoke_the_spirits cooldown 26";
			end
		end
		ShouldReturn = v31.HandleTopTrinket(v34, v29 and (v12:BuffUp(v32.HeartOfTheWild) or v12:BuffUp(v32.Incarnation) or v12:BloodlustUp()), 15 + 25, nil);
		if (ShouldReturn or ((5027 - (657 + 358)) <= (8891 - 5533))) then
			return ShouldReturn;
		end
		ShouldReturn = v31.HandleBottomTrinket(v34, v29 and (v12:BuffUp(v32.HeartOfTheWild) or v12:BuffUp(v32.Incarnation) or v12:BloodlustUp()), 91 - 51, nil);
		if (((2681 - (1151 + 36)) <= (2902 + 103)) and ShouldReturn) then
			return ShouldReturn;
		end
		if ((v29 and v33.Djaruun:IsEquippedAndReady()) or ((818 + 2293) == (6372 - 4238))) then
			if (((4187 - (1552 + 280)) == (3189 - (64 + 770))) and v23(v62.Djaruun, not v78)) then
				return "djaruun_pillar_of_the_elder_flame main 4";
			end
		end
	end
	local function v122()
		v35 = EpicSettings.Settings['UseRacials'];
		v36 = EpicSettings.Settings['UseHealingPotion'] or (0 + 0);
		v37 = EpicSettings.Settings['HealingPotionName'] or "";
		v38 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v39 = EpicSettings.Settings['UseMarkOfTheWild'];
		v40 = EpicSettings.Settings['DispelDebuffs'];
		v41 = EpicSettings.Settings['DispelBuffs'];
		v42 = EpicSettings.Settings['UseHealthstone'];
		v43 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
		v44 = EpicSettings.Settings['HandleAfflicted'];
		v45 = EpicSettings.Settings['HandleIncorporeal'];
		v46 = EpicSettings.Settings['InterruptWithStun'];
		v47 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v48 = EpicSettings.Settings['InterruptThreshold'] or (1243 - (157 + 1086));
		v49 = EpicSettings.Settings['UseCatFormOOC'];
		v50 = EpicSettings.Settings['UsageProwlOOC'] or "";
		v51 = EpicSettings.Settings['ProwlRange'] or (0 - 0);
		v52 = EpicSettings.Settings['UseWildCharge'];
		v53 = EpicSettings.Settings['UseBarkskin'];
		v54 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
		v55 = EpicSettings.Settings['UseNaturesVigil'];
		v56 = EpicSettings.Settings['NaturesVigilHP'] or (0 - 0);
		v57 = EpicSettings.Settings['UseRenewal'];
		v58 = EpicSettings.Settings['RenewalHP'] or (0 - 0);
		FrenziedRegenerationHP = EpicSettings.Settings['FrenziedRegenerationHP'] or (819 - (599 + 220));
		UseFrenziedRegeneration = EpicSettings.Settings['UseFrenziedRegeneration'];
		SurvivalInstinctsHP = EpicSettings.Settings['SurvivalInstinctsHP'] or (0 - 0);
		UseSurvivalInstincts = EpicSettings.Settings['UseSurvivalInstincts'];
		v59 = EpicSettings.Settings['UseRegrowth'];
		v60 = EpicSettings.Settings['UseRegrowthMouseover'];
		v61 = EpicSettings.Settings['RegrowthHP'] or (1931 - (1813 + 118));
	end
	local function v123()
		local v196 = v26((1.5 + 0) * v32.AstralInfluence:TalentRank());
		v76 = (1222 - (841 + 376)) + v196;
		v77 = (10 - 2) + v196;
		if (v28 or ((137 + 451) <= (1179 - 747))) then
			v80 = v12:GetEnemiesInMeleeRange(v76);
			v82 = v12:GetEnemiesInMeleeRange(v77);
			v81 = #v80;
			v83 = #v82;
		else
			local v206 = 859 - (464 + 395);
			while true do
				if (((12310 - 7513) >= (1871 + 2024)) and (v206 == (838 - (467 + 370)))) then
					v81 = 1 - 0;
					v83 = 1 + 0;
					break;
				end
				if (((12261 - 8684) == (559 + 3018)) and (v206 == (0 - 0))) then
					v80 = {};
					v82 = {};
					v206 = 521 - (150 + 370);
				end
			end
		end
		v72 = v12:ComboPoints();
		v73 = v12:ComboPointsDeficit();
		v78 = v15:IsInRange(v76);
		v79 = v15:IsInRange(v77);
		if (((5076 - (74 + 1208)) > (9083 - 5390)) and (v31.TargetIsValid() or v12:AffectingCombat())) then
			local v207 = 0 - 0;
			while true do
				if ((v207 == (0 + 0)) or ((1665 - (14 + 376)) == (7111 - 3011))) then
					v74 = v9.BossFightRemains(nil, true);
					v75 = v74;
					v207 = 1 + 0;
				end
				if ((v207 == (1 + 0)) or ((1518 + 73) >= (10489 - 6909))) then
					if (((740 + 243) <= (1886 - (23 + 55))) and (v75 == (26332 - 15221))) then
						v75 = v9.FightRemains(v82, false);
					end
					break;
				end
			end
		end
	end
	local function v124()
		local v197 = 0 + 0;
		while true do
			if ((v197 == (2 + 0)) or ((3333 - 1183) <= (377 + 820))) then
				if (((4670 - (652 + 249)) >= (3139 - 1966)) and (v12:BuffUp(v32.TravelForm) or v12:IsMounted())) then
					return;
				end
				v123();
				if (((3353 - (708 + 1160)) == (4030 - 2545)) and v13 and v13:Exists() and v13:IsAPlayer() and v13:IsDeadOrGhost() and not v12:CanAttack(v13)) then
					if (v12:AffectingCombat() or ((6043 - 2728) <= (2809 - (10 + 17)))) then
						if (v32.Rebirth:IsReady() or ((197 + 679) >= (4696 - (1400 + 332)))) then
							if (v23(v62.RebirthMouseover, nil, true) or ((4280 - 2048) > (4405 - (242 + 1666)))) then
								return "rebirth";
							end
						end
					elseif (v23(v62.ReviveMouseover, nil, true) or ((903 + 1207) <= (122 + 210))) then
						return "revive";
					end
				end
				v197 = 3 + 0;
			end
			if (((4626 - (850 + 90)) > (5555 - 2383)) and (v197 == (1391 - (360 + 1030)))) then
				v29 = EpicSettings.Toggles['cds'];
				v30 = EpicSettings.Toggles['dispel'];
				if (v12:IsDeadOrGhost() or ((3960 + 514) < (2314 - 1494))) then
					return;
				end
				v197 = 2 - 0;
			end
			if (((5940 - (909 + 752)) >= (4105 - (109 + 1114))) and (v197 == (6 - 2))) then
				if ((v31.TargetIsValid() and v15:IsInRange(5 + 6)) or ((2271 - (6 + 236)) >= (2219 + 1302))) then
					local v222 = 0 + 0;
					while true do
						if ((v222 == (2 - 1)) or ((3557 - 1520) >= (5775 - (1076 + 57)))) then
							if (((283 + 1437) < (5147 - (579 + 110))) and v23(v32.Pool)) then
								return "Pool Energy";
							end
							break;
						end
						if ((v222 == (0 + 0)) or ((386 + 50) > (1604 + 1417))) then
							if (((1120 - (174 + 233)) <= (2365 - 1518)) and not v12:AffectingCombat() and v27) then
								local v226 = 0 - 0;
								local v227;
								while true do
									if (((958 + 1196) <= (5205 - (663 + 511))) and (v226 == (0 + 0))) then
										v227 = v115();
										if (((1002 + 3613) == (14228 - 9613)) and v227) then
											return v227;
										end
										break;
									end
								end
							end
							if (v12:AffectingCombat() or v27 or ((2296 + 1494) == (1177 - 677))) then
								if (((215 - 126) < (106 + 115)) and not v12:IsCasting() and not v12:IsChanneling()) then
									local v228 = 0 - 0;
									local v229;
									while true do
										if (((1464 + 590) >= (130 + 1291)) and ((723 - (478 + 244)) == v228)) then
											v229 = v31.Interrupt(v32.SkullBash, 527 - (440 + 77), true, v13, v62.SkullBashMouseover);
											if (((315 + 377) < (11192 - 8134)) and v229) then
												return v229;
											end
											v228 = 1558 - (655 + 901);
										end
										if ((v228 == (1 + 1)) or ((2492 + 762) == (1118 + 537))) then
											v229 = v31.InterruptWithStun(v32.MightyBash, 32 - 24);
											if (v229 or ((2741 - (695 + 750)) == (16766 - 11856))) then
												return v229;
											end
											v228 = 3 - 0;
										end
										if (((13545 - 10177) == (3719 - (285 + 66))) and (v228 == (8 - 4))) then
											if (((3953 - (682 + 628)) < (615 + 3200)) and v12:BuffUp(v32.CatForm) and (v12:ComboPoints() > (299 - (176 + 123)))) then
												local v238 = 0 + 0;
												while true do
													if (((1388 + 525) > (762 - (239 + 30))) and (v238 == (0 + 0))) then
														v229 = v31.InterruptWithStun(v32.Maim, 8 + 0);
														if (((8415 - 3660) > (10694 - 7266)) and v229) then
															return v229;
														end
														break;
													end
												end
											end
											break;
										end
										if (((1696 - (306 + 9)) <= (8266 - 5897)) and (v228 == (0 + 0))) then
											v229 = v31.Interrupt(v32.SkullBash, 7 + 3, true);
											if (v229 or ((2332 + 2511) == (11678 - 7594))) then
												return v229;
											end
											v228 = 1376 - (1140 + 235);
										end
										if (((2972 + 1697) > (333 + 30)) and ((1 + 2) == v228)) then
											v229 = v31.InterruptWithStun(v32.IncapacitatingRoar, 60 - (33 + 19));
											if (v229 or ((678 + 1199) >= (9405 - 6267))) then
												return v229;
											end
											v228 = 2 + 2;
										end
									end
								end
								if (((9299 - 4557) >= (3401 + 225)) and v41 and v30 and v32.Soothe:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v31.UnitHasEnrageBuff(v15)) then
									if (v23(v32.Soothe, not v78) or ((5229 - (586 + 103)) == (84 + 832))) then
										return "dispel";
									end
								end
								if ((v32.Prowl:IsCastable() and (v12:BuffDown(v84))) or ((3558 - 2402) > (5833 - (1309 + 179)))) then
									if (((4037 - 1800) < (1850 + 2399)) and v23(v32.Prowl)) then
										return "prowl main 2";
									end
								end
								if (v32.CatForm:IsCastable() or ((7205 - 4522) < (18 + 5))) then
									if (((1480 - 783) <= (1645 - 819)) and v23(v32.CatForm)) then
										return "cat_form main 4";
									end
								end
								if (((1714 - (295 + 314)) <= (2888 - 1712)) and v12:AffectingCombat()) then
									if (((5341 - (1300 + 662)) <= (11970 - 8158)) and (v12:HealthPercentage() <= v56) and v55 and v32.NaturesVigil:IsReady()) then
										if (v23(v32.NaturesVigil, nil, nil, true) or ((2543 - (1178 + 577)) >= (840 + 776))) then
											return "natures_vigil defensive 2";
										end
									end
									if (((5480 - 3626) <= (4784 - (851 + 554))) and (v12:HealthPercentage() <= v58) and v57 and v32.Renewal:IsReady()) then
										if (((4023 + 526) == (12615 - 8066)) and v23(v32.Renewal, nil, nil, true)) then
											return "renewal defensive 2";
										end
									end
									if (((v12:HealthPercentage() <= FrenziedRegenerationHP) and UseFrenziedRegeneration and v32.FrenziedRegeneration:IsReady()) or ((6562 - 3540) >= (3326 - (115 + 187)))) then
										if (((3692 + 1128) > (2081 + 117)) and v23(v32.FrenziedRegeneration, nil, nil, true)) then
											return "FrenziedRegeneration defensive 2";
										end
									end
									if (((v12:HealthPercentage() <= SurvivalInstinctsHP) and UseSurvivalInstincts and v32.SurvivalInstincts:IsReady()) or ((4181 - 3120) >= (6052 - (160 + 1001)))) then
										if (((1194 + 170) <= (3087 + 1386)) and v23(v32.SurvivalInstincts, nil, nil, true)) then
											return "SurvivalInstincts defensive 2";
										end
									end
									if ((v32.Regrowth:IsCastable() and v59 and v12:BuffUp(v32.PredatorySwiftnessBuff) and (v12:HealthPercentage() <= v61)) or ((7359 - 3764) <= (361 - (237 + 121)))) then
										if (v23(v62.RegrowthPlayer) or ((5569 - (525 + 372)) == (7302 - 3450))) then
											return "regrowth defensive 4";
										end
									end
									if (((5122 - 3563) == (1701 - (96 + 46))) and (v12:HealthPercentage() <= v54) and v53 and v32.Barkskin:IsReady()) then
										if (v23(v32.Barkskin, nil, nil, true) or ((2529 - (643 + 134)) <= (285 + 503))) then
											return "barkskin defensive 6";
										end
									end
									if ((v33.Healthstone:IsReady() and v42 and (v12:HealthPercentage() <= v43)) or ((9368 - 5461) == (656 - 479))) then
										if (((3328 + 142) > (1089 - 534)) and v23(v62.Healthstone, nil, nil, true)) then
											return "healthstone defensive 3";
										end
									end
									if ((v36 and (v12:HealthPercentage() <= v38)) or ((1986 - 1014) == (1364 - (316 + 403)))) then
										if (((2116 + 1066) >= (5814 - 3699)) and (v37 == "Refreshing Healing Potion")) then
											if (((1407 + 2486) < (11153 - 6724)) and v33.RefreshingHealingPotion:IsReady()) then
												if (v23(v62.RefreshingHealingPotion, nil, nil, true) or ((2032 + 835) < (614 + 1291))) then
													return "refreshing healing potion defensive 4";
												end
											end
										end
									end
								end
								if ((v60 and v32.Regrowth:IsReady() and v12:BuffUp(v32.PredatorySwiftnessBuff)) or ((6222 - 4426) >= (19346 - 15295))) then
									if (((3362 - 1743) <= (216 + 3540)) and (v12:HealthPercentage() > v61) and v12:IsInParty() and not v12:IsInRaid()) then
										if (((1188 - 584) == (30 + 574)) and v13 and v13:Exists() and (v13:HealthPercentage() <= v61) and not v13:IsDeadOrGhost() and not v12:CanAttack(v13)) then
											if (v23(v62.RegrowthMouseover) or ((13192 - 8708) == (917 - (12 + 5)))) then
												return "regrowth_mouseover";
											end
										end
									end
								end
								v116();
								if ((v32.TigersFury:IsCastable() and ((not v12:HasTier(120 - 89, 8 - 4) and v32.ConvokeTheSpirits:IsAvailable()) or v12:BuffDown(v32.TigersFury) or (v12:EnergyDeficit() > (138 - 73)) or (v12:HasTier(76 - 45, 1 + 1) and v32.FeralFrenzy:CooldownUp()) or ((v75 < (1988 - (1656 + 317))) and v32.Predator:IsAvailable()))) or ((3974 + 485) <= (892 + 221))) then
									if (((9657 - 6025) > (16723 - 13325)) and v23(v32.TigersFury, not v78)) then
										return "tigers_fury main 6";
									end
								end
								if (((4436 - (5 + 349)) <= (23354 - 18437)) and v32.Rake:IsReady() and (v12:StealthUp(false, true))) then
									if (((6103 - (266 + 1005)) >= (914 + 472)) and v31.CastCycle(v32.Rake, v80, v112, not v78, nil, nil, v62.RakeMouseover)) then
										return "rake main 10";
									end
								end
								if (((467 - 330) == (179 - 42)) and v32.AdaptiveSwarm:IsReady() and v32.UnbridledSwarm:IsAvailable() and (v83 <= (1697 - (561 + 1135))) and (v12:BuffStack(v32.AdaptiveSwarmHeal) < (5 - 1)) and (v12:BuffRemains(v32.AdaptiveSwarmHeal) > (12 - 8))) then
									if (v23(v62.AdaptiveSwarmPlayer) or ((2636 - (507 + 559)) >= (10870 - 6538))) then
										return "adaptive_swarm self main 14";
									end
								end
								if ((v32.AdaptiveSwarm:IsReady() and (not v32.UnbridledSwarm:IsAvailable() or (v83 == (3 - 2)))) or ((4452 - (212 + 176)) <= (2724 - (250 + 655)))) then
									if (v31.CastCycle(v32.AdaptiveSwarm, v82, v108, not v15:IsSpellInRange(v32.AdaptiveSwarm), nil, nil, v62.AdaptiveSwarmMouseover) or ((13596 - 8610) < (2749 - 1175))) then
										return "adaptive_swarm main 12";
									end
								end
								if (((6924 - 2498) > (2128 - (1869 + 87))) and v32.AdaptiveSwarm:IsReady() and v32.UnbridledSwarm:IsAvailable() and (v83 > (3 - 2))) then
									if (((2487 - (484 + 1417)) > (975 - 520)) and v31.CastTargetIf(v32.AdaptiveSwarm, v82, "max", v93, v98, not v15:IsSpellInRange(v32.AdaptiveSwarm))) then
										return "adaptive_swarm main 13";
									end
								end
								if (((1383 - 557) == (1599 - (48 + 725))) and v29 and ((v9.CombatTime() > (4 - 1)) or not v32.DireFixation:IsAvailable() or (v15:DebuffUp(v32.DireFixationDebuff) and (v72 < (10 - 6))) or (v83 > (1 + 0))) and not ((v83 == (2 - 1)) and v32.ConvokeTheSpirits:IsAvailable())) then
									local v230 = v121();
									if (v230 or ((1125 + 2894) > (1295 + 3146))) then
										return v230;
									end
								end
								if (((2870 - (152 + 701)) < (5572 - (430 + 881))) and v29 and v15:DebuffUp(v32.Rip)) then
									local v231 = v121();
									if (((1807 + 2909) > (975 - (557 + 338))) and v231) then
										return v231;
									end
								end
								if (v32.FeralFrenzy:IsReady() or ((1037 + 2470) == (9220 - 5948))) then
									if (v31.CastTargetIf(v32.FeralFrenzy, v80, "max", v97, v104, not v78) or ((3067 - 2191) >= (8169 - 5094))) then
										return "feral_frenzy main 20";
									end
								end
								if (((9378 - 5026) > (3355 - (499 + 302))) and v32.FeralFrenzy:IsReady() and (v72 < (869 - (39 + 827))) and v15:DebuffUp(v32.DireFixationDebuff) and v15:DebuffUp(v32.Rip) and (v83 == (2 - 1)) and v32.ConvokeTheSpirits:IsAvailable()) then
									if (v23(v32.FeralFrenzy, not v78) or ((9840 - 5434) < (16058 - 12015))) then
										return "feral_frenzy main 21";
									end
								end
								if ((v32.FerociousBite:IsReady() and v12:BuffUp(v32.ApexPredatorsCravingBuff) and ((v83 == (1 - 0)) or not v32.PrimalWrath:IsAvailable() or v12:BuffDown(v32.SabertoothBuff)) and not (v63 and (CountActiveBtTriggers() == (1 + 1)))) or ((5528 - 3639) >= (542 + 2841))) then
									if (((2993 - 1101) <= (2838 - (103 + 1))) and v31.CastTargetIf(v32.FerociousBite, v80, "max", v97, nil, not v78)) then
										return "ferocious_bite main 16";
									end
								end
								if (((2477 - (475 + 79)) < (4794 - 2576)) and v12:BuffUp(v84)) then
									local v232 = 0 - 0;
									local v233;
									while true do
										if (((281 + 1892) > (334 + 45)) and ((1503 - (1395 + 108)) == v232)) then
											v233 = v120();
											if (v233 or ((7539 - 4948) == (4613 - (7 + 1197)))) then
												return v233;
											end
											v232 = 1 + 0;
										end
										if (((1576 + 2938) > (3643 - (27 + 292))) and (v232 == (2 - 1))) then
											if (v23(v32.Pool) or ((264 - 56) >= (20247 - 15419))) then
												return "Wait for Berserk()";
											end
											break;
										end
									end
								end
								if (((v72 == (7 - 3)) and v12:BuffUp(v32.PredatorRevealedBuff) and (v12:EnergyDeficit() > (76 - 36)) and (v83 == (140 - (43 + 96)))) or ((6457 - 4874) > (8064 - 4497))) then
									if (v23(v32.Pool) or ((1090 + 223) == (225 + 569))) then
										return "Wait for Finisher()";
									end
								end
								if (((6272 - 3098) > (1113 + 1789)) and (v72 >= (7 - 3))) then
									local v234 = v119();
									if (((1298 + 2822) <= (313 + 3947)) and v234) then
										return v234;
									end
								end
								if (((v83 > (1752 - (1414 + 337))) and (v72 < (1944 - (1642 + 298)))) or ((2301 - 1418) > (13745 - 8967))) then
									local v235 = v118();
									if (v235 or ((10742 - 7122) >= (1610 + 3281))) then
										return v235;
									end
								end
								if (((3313 + 945) > (1909 - (357 + 615))) and v12:BuffDown(v84) and (v83 == (1 + 0)) and (v72 < (9 - 5))) then
									local v236 = 0 + 0;
									local v237;
									while true do
										if ((v236 == (0 - 0)) or ((3895 + 974) < (62 + 844))) then
											v237 = v117();
											if (v237 or ((770 + 455) > (5529 - (384 + 917)))) then
												return v237;
											end
											break;
										end
									end
								end
							end
							v222 = 698 - (128 + 569);
						end
					end
				end
				break;
			end
			if (((4871 - (1407 + 136)) > (4125 - (687 + 1200))) and (v197 == (1710 - (556 + 1154)))) then
				v122();
				v27 = EpicSettings.Toggles['ooc'];
				v28 = EpicSettings.Toggles['aoe'];
				v197 = 3 - 2;
			end
			if (((3934 - (9 + 86)) > (1826 - (275 + 146))) and (v197 == (1 + 2))) then
				if (v44 or ((1357 - (29 + 35)) <= (2246 - 1739))) then
					local v223 = 0 - 0;
					while true do
						if ((v223 == (0 - 0)) or ((1887 + 1009) < (1817 - (53 + 959)))) then
							ShouldReturn = v31.HandleAfflicted(v32.RemoveCorruption, v62.RemoveCorruptionMouseover, 448 - (312 + 96));
							if (((4019 - 1703) == (2601 - (147 + 138))) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (v45 or ((3469 - (813 + 86)) == (1386 + 147))) then
					ShouldReturn = v31.HandleIncorporeal(v32.Hibernate, v62.HibernateMouseover, 55 - 25, true);
					if (ShouldReturn or ((1375 - (18 + 474)) == (493 + 967))) then
						return ShouldReturn;
					end
				end
				if ((not v12:AffectingCombat() and v27) or ((15075 - 10456) <= (2085 - (860 + 226)))) then
					local v224 = 303 - (121 + 182);
					while true do
						if ((v224 == (0 + 0)) or ((4650 - (988 + 252)) > (465 + 3651))) then
							if ((v39 and v32.MarkOfTheWild:IsCastable() and (v12:BuffDown(v32.MarkOfTheWild, true) or v31.GroupBuffMissing(v32.MarkOfTheWild))) or ((283 + 620) >= (5029 - (49 + 1921)))) then
								if (v23(v62.MarkOfTheWildPlayer) or ((4866 - (223 + 667)) < (2909 - (51 + 1)))) then
									return "mark_of_the_wild";
								end
							end
							if (((8485 - 3555) > (4939 - 2632)) and v32.CatForm:IsCastable()) then
								if (v23(v32.CatForm) or ((5171 - (146 + 979)) < (365 + 926))) then
									return "cat_form ooc";
								end
							end
							break;
						end
					end
				end
				v197 = 609 - (311 + 294);
			end
		end
	end
	local function v125()
		local v198 = 0 - 0;
		while true do
			if ((v198 == (1 + 0)) or ((5684 - (496 + 947)) == (4903 - (1233 + 125)))) then
				EpicSettings.SetupVersion("Feral Druid X v 10.2.00 By BoomK");
				break;
			end
			if ((v198 == (0 + 0)) or ((3632 + 416) > (805 + 3427))) then
				v32.Rip:RegisterAuraTracking();
				v19.Print("Feral Druid by Epic BoomK");
				v198 = 1646 - (963 + 682);
			end
		end
	end
	v19.SetAPL(86 + 17, v124, v125);
end;
return v0["Epix_Druid_Feral.lua"]();

