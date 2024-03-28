local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((2195 + 489) > (1977 - 1431)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Shaman_Elemental.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.MouseOver;
	local v15 = v11.Pet;
	local v16 = v11.Target;
	local v17 = v11.Focus;
	local v18 = v9.Spell;
	local v19 = v9.MultiSpell;
	local v20 = v9.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Macro;
	local v24 = v21.Press;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = math.max;
	local v28 = GetTime;
	local v29 = GetWeaponEnchantInfo;
	local v30;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v98;
	local v99;
	local v100 = v18.Shaman.Elemental;
	local v101 = v20.Shaman.Elemental;
	local v102 = v23.Shaman.Elemental;
	local v103 = {};
	local v104 = v21.Commons.Everyone;
	local v105 = v21.Commons.Shaman;
	local function v106()
		if (((1000 + 465) <= (8939 - 4638)) and v100.CleanseSpirit:IsAvailable()) then
			v104.DispellableDebuffs = v104.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		v100.PrimordialWave:RegisterInFlightEffect(9208 + 317954);
		v100.PrimordialWave:RegisterInFlight();
		v100.LavaBurst:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v100.PrimordialWave:RegisterInFlightEffect(327841 - (642 + 37));
	v100.PrimordialWave:RegisterInFlight();
	v100.LavaBurst:RegisterInFlight();
	local v107 = 2534 + 8577;
	local v108 = 1778 + 9333;
	local v109, v110;
	local v111, v112;
	local v113 = 0 - 0;
	local v114 = 454 - (233 + 221);
	local v115 = 0 - 0;
	local v116 = 0 + 0;
	local v117 = 1541 - (718 + 823);
	local function v118()
		return (26 + 14) - (v28() - v115);
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v146, v147, v147, v147, v148 = select(813 - (266 + 539), ...);
		if (((4824 - 3120) > (2650 - (636 + 589))) and (v146 == v13:GUID()) and (v148 == (454893 - 263259))) then
			local v181 = 0 - 0;
			while true do
				if ((v181 == (0 + 0)) or ((250 + 437) == (5249 - (657 + 358)))) then
					v116 = v28();
					C_Timer.After(0.1 - 0, function()
						if ((v116 ~= v117) or ((7586 - 4256) < (2616 - (1151 + 36)))) then
							v115 = v116;
						end
					end);
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v119(v149)
		return (v149:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v120(v150)
		return v150:DebuffRefreshable(v100.FlameShockDebuff) and (v150:DebuffRemains(v100.FlameShockDebuff) < (v150:TimeToDie() - (5 + 0)));
	end
	local function v121(v151)
		return v151:DebuffRefreshable(v100.FlameShockDebuff) and (v151:DebuffRemains(v100.FlameShockDebuff) < (v151:TimeToDie() - (2 + 3))) and (v151:DebuffRemains(v100.FlameShockDebuff) > (0 - 0));
	end
	local function v122(v152)
		return (v152:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v123(v153)
		return v153:DebuffRemains(v100.FlameShockDebuff) > (1834 - (1552 + 280));
	end
	local function v124(v154)
		return (v154:DebuffRemains(v100.LightningRodDebuff));
	end
	local function v125()
		local v155 = 834 - (64 + 770);
		local v156;
		while true do
			if (((779 + 368) >= (760 - 425)) and (v155 == (0 + 0))) then
				v156 = v13:Maelstrom();
				if (((4678 - (157 + 1086)) > (4196 - 2099)) and not v13:IsCasting()) then
					return v156;
				elseif (v13:IsCasting(v100.ElementalBlast) or ((16511 - 12741) >= (6198 - 2157))) then
					return v156 - (101 - 26);
				elseif (v13:IsCasting(v100.Icefury) or ((4610 - (599 + 220)) <= (3207 - 1596))) then
					return v156 + (1956 - (1813 + 118));
				elseif (v13:IsCasting(v100.LightningBolt) or ((3347 + 1231) <= (3225 - (841 + 376)))) then
					return v156 + (14 - 4);
				elseif (((262 + 863) <= (5666 - 3590)) and v13:IsCasting(v100.LavaBurst)) then
					return v156 + (871 - (464 + 395));
				elseif (v13:IsCasting(v100.ChainLightning) or ((1906 - 1163) >= (2113 + 2286))) then
					return v156 + ((841 - (467 + 370)) * v114);
				else
					return v156;
				end
				break;
			end
		end
	end
	local function v126(v157)
		local v158 = 0 - 0;
		local v159;
		while true do
			if (((848 + 307) < (5735 - 4062)) and (v158 == (0 + 0))) then
				v159 = v157:IsReady();
				if ((v157 == v100.Stormkeeper) or (v157 == v100.ElementalBlast) or (v157 == v100.Icefury) or ((5406 - 3082) <= (1098 - (150 + 370)))) then
					local v243 = 1282 - (74 + 1208);
					local v244;
					while true do
						if (((9264 - 5497) == (17865 - 14098)) and (v243 == (0 + 0))) then
							v244 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
							return v159 and v244 and not v13:IsCasting(v157);
						end
					end
				elseif (((4479 - (14 + 376)) == (7091 - 3002)) and (v157 == v100.LavaBeam)) then
					local v262 = 0 + 0;
					local v263;
					while true do
						if (((3917 + 541) >= (1597 + 77)) and (v262 == (0 - 0))) then
							v263 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
							return v159 and v263;
						end
					end
				elseif (((732 + 240) <= (1496 - (23 + 55))) and ((v157 == v100.LightningBolt) or (v157 == v100.ChainLightning))) then
					local v266 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.StormkeeperBuff) or not v13:IsMoving();
					return v159 and v266;
				elseif ((v157 == v100.LavaBurst) or ((11702 - 6764) < (3178 + 1584))) then
					local v275 = 0 + 0;
					local v276;
					local v277;
					local v278;
					local v279;
					while true do
						if (((1 - 0) == v275) or ((788 + 1716) > (5165 - (652 + 249)))) then
							v278 = (v100.LavaBurst:Charges() >= (2 - 1)) and not v13:IsCasting(v100.LavaBurst);
							v279 = (v100.LavaBurst:Charges() == (1870 - (708 + 1160))) and v13:IsCasting(v100.LavaBurst);
							v275 = 5 - 3;
						end
						if (((3925 - 1772) == (2180 - (10 + 17))) and (v275 == (1 + 1))) then
							return v159 and v276 and (v277 or v278 or v279);
						end
						if ((v275 == (1732 - (1400 + 332))) or ((971 - 464) >= (4499 - (242 + 1666)))) then
							v276 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.LavaSurgeBuff) or not v13:IsMoving();
							v277 = v13:BuffUp(v100.LavaSurgeBuff);
							v275 = 1 + 0;
						end
					end
				elseif (((1643 + 2838) == (3819 + 662)) and (v157 == v100.PrimordialWave)) then
					return v159 and v33 and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffDown(v100.LavaSurgeBuff);
				else
					return v159;
				end
				break;
			end
		end
	end
	local function v127()
		if (not v100.MasteroftheElements:IsAvailable() or ((3268 - (850 + 90)) < (1213 - 520))) then
			return false;
		end
		local v160 = v13:BuffUp(v100.MasteroftheElementsBuff);
		if (((5718 - (360 + 1030)) == (3831 + 497)) and not v13:IsCasting()) then
			return v160;
		elseif (((4481 - 2893) >= (1832 - 500)) and v13:IsCasting(v105.LavaBurst)) then
			return true;
		elseif (v13:IsCasting(v105.ElementalBlast) or v13:IsCasting(v100.Icefury) or v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning) or ((5835 - (909 + 752)) > (5471 - (109 + 1114)))) then
			return false;
		else
			return v160;
		end
	end
	local function v128()
		local v161 = 0 - 0;
		local v162;
		while true do
			if ((v161 == (0 + 0)) or ((4828 - (6 + 236)) <= (52 + 30))) then
				if (((3110 + 753) == (9110 - 5247)) and not v100.PoweroftheMaelstrom:IsAvailable()) then
					return false;
				end
				v162 = v13:BuffStack(v100.PoweroftheMaelstromBuff);
				v161 = 1 - 0;
			end
			if ((v161 == (1134 - (1076 + 57))) or ((47 + 235) <= (731 - (579 + 110)))) then
				if (((364 + 4245) >= (678 + 88)) and not v13:IsCasting()) then
					return v162 > (0 + 0);
				elseif (((v162 == (408 - (174 + 233))) and (v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning))) or ((3217 - 2065) == (4366 - 1878))) then
					return false;
				else
					return v162 > (0 + 0);
				end
				break;
			end
		end
	end
	local function v129()
		if (((4596 - (663 + 511)) > (2989 + 361)) and not v100.Stormkeeper:IsAvailable()) then
			return false;
		end
		local v163 = v13:BuffUp(v100.StormkeeperBuff);
		if (((191 + 686) > (1159 - 783)) and not v13:IsCasting()) then
			return v163;
		elseif (v13:IsCasting(v100.Stormkeeper) or ((1889 + 1229) <= (4357 - 2506))) then
			return true;
		else
			return v163;
		end
	end
	local function v130()
		if (not v100.Icefury:IsAvailable() or ((399 - 234) >= (1667 + 1825))) then
			return false;
		end
		local v164 = v13:BuffUp(v100.IcefuryBuff);
		if (((7685 - 3736) < (3461 + 1395)) and not v13:IsCasting()) then
			return v164;
		elseif (v13:IsCasting(v100.Icefury) or ((391 + 3885) < (3738 - (478 + 244)))) then
			return true;
		else
			return v164;
		end
	end
	local v131 = 517 - (440 + 77);
	local function v132()
		if (((2133 + 2557) > (15097 - 10972)) and v100.CleanseSpirit:IsReady() and v35 and (v104.UnitHasDispellableDebuffByPlayer(v17) or v104.DispellableFriendlyUnit(1581 - (655 + 901)))) then
			local v182 = 0 + 0;
			while true do
				if (((0 + 0) == v182) or ((34 + 16) >= (3609 - 2713))) then
					if ((v131 == (1445 - (695 + 750))) or ((5852 - 4138) >= (4564 - 1606))) then
						v131 = v28();
					end
					if (v104.Wait(2010 - 1510, v131) or ((1842 - (285 + 66)) < (1500 - 856))) then
						local v264 = 1310 - (682 + 628);
						while true do
							if (((114 + 590) < (1286 - (176 + 123))) and (v264 == (0 + 0))) then
								if (((2697 + 1021) > (2175 - (239 + 30))) and v24(v102.CleanseSpiritFocus)) then
									return "cleanse_spirit dispel";
								end
								v131 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v133()
		if ((v98 and (v13:HealthPercentage() <= v99)) or ((921 + 37) > (6433 - 2798))) then
			if (((10922 - 7421) <= (4807 - (306 + 9))) and v100.HealingSurge:IsReady()) then
				if (v24(v100.HealingSurge) or ((12011 - 8569) < (444 + 2104))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v134()
		local v165 = 0 + 0;
		while true do
			if (((1384 + 1491) >= (4186 - 2722)) and ((1375 - (1140 + 235)) == v165)) then
				if ((v100.AstralShift:IsReady() and v71 and (v13:HealthPercentage() <= v77)) or ((3053 + 1744) >= (4487 + 406))) then
					if (v24(v100.AstralShift) or ((142 + 409) > (2120 - (33 + 19)))) then
						return "astral_shift defensive 1";
					end
				end
				if (((764 + 1350) > (2829 - 1885)) and v100.AncestralGuidance:IsReady() and v70 and v104.AreUnitsBelowHealthPercentage(v75, v76, v100.HealingSurge)) then
					if (v24(v100.AncestralGuidance) or ((997 + 1265) >= (6071 - 2975))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v165 = 1 + 0;
			end
			if (((691 - (586 + 103)) == v165) or ((206 + 2049) >= (10888 - 7351))) then
				if ((v92 and (v13:HealthPercentage() <= v94)) or ((5325 - (1309 + 179)) < (2357 - 1051))) then
					local v245 = 0 + 0;
					while true do
						if (((7922 - 4972) == (2229 + 721)) and (v245 == (0 - 0))) then
							if ((v96 == "Refreshing Healing Potion") or ((9410 - 4687) < (3907 - (295 + 314)))) then
								if (((2790 - 1654) >= (2116 - (1300 + 662))) and v101.RefreshingHealingPotion:IsReady()) then
									if (v24(v102.RefreshingHealingPotion) or ((850 - 579) > (6503 - (1178 + 577)))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((2462 + 2278) >= (9317 - 6165)) and (v96 == "Dreamwalker's Healing Potion")) then
								if (v101.DreamwalkersHealingPotion:IsReady() or ((3983 - (851 + 554)) >= (2998 + 392))) then
									if (((113 - 72) <= (3607 - 1946)) and v24(v102.RefreshingHealingPotion)) then
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
			if (((903 - (115 + 187)) < (2727 + 833)) and (v165 == (1 + 0))) then
				if (((926 - 691) < (1848 - (160 + 1001))) and v100.HealingStreamTotem:IsReady() and v72 and v104.AreUnitsBelowHealthPercentage(v78, v79, v100.HealingSurge)) then
					if (((3980 + 569) > (796 + 357)) and v24(v100.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v101.Healthstone:IsReady() and v93 and (v13:HealthPercentage() <= v95)) or ((9567 - 4893) < (5030 - (237 + 121)))) then
					if (((4565 - (525 + 372)) < (8646 - 4085)) and v24(v102.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v165 = 6 - 4;
			end
		end
	end
	local function v135()
		local v166 = 142 - (96 + 46);
		while true do
			if ((v166 == (778 - (643 + 134))) or ((165 + 290) == (8643 - 5038))) then
				v30 = v104.HandleBottomTrinket(v103, v33, 148 - 108, nil);
				if (v30 or ((2554 + 109) == (6499 - 3187))) then
					return v30;
				end
				break;
			end
			if (((8742 - 4465) <= (5194 - (316 + 403))) and (v166 == (0 + 0))) then
				v30 = v104.HandleTopTrinket(v103, v33, 109 - 69, nil);
				if (v30 or ((315 + 555) == (2994 - 1805))) then
					return v30;
				end
				v166 = 1 + 0;
			end
		end
	end
	local function v136()
		local v167 = 0 + 0;
		while true do
			if (((5381 - 3828) <= (14962 - 11829)) and (v167 == (5 - 2))) then
				if ((v13:IsCasting(v100.LavaBurst) and v40 and v100.FlameShock:IsReady()) or ((129 + 2108) >= (6911 - 3400))) then
					if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((65 + 1259) > (8885 - 5865))) then
						return "flameshock precombat 14";
					end
				end
				if ((v13:IsCasting(v100.LavaBurst) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) or ((3009 - (12 + 5)) == (7305 - 5424))) then
					if (((6626 - 3520) > (3243 - 1717)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
			if (((7496 - 4473) < (786 + 3084)) and (v167 == (1974 - (1656 + 317)))) then
				if (((128 + 15) > (60 + 14)) and v126(v100.ElementalBlast) and v39) then
					if (((47 - 29) < (10394 - 8282)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast precombat 6";
					end
				end
				if (((1451 - (5 + 349)) <= (7732 - 6104)) and v13:IsCasting(v100.ElementalBlast) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) then
					if (((5901 - (266 + 1005)) == (3052 + 1578)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 8";
					end
				end
				v167 = 6 - 4;
			end
			if (((4660 - 1120) > (4379 - (561 + 1135))) and (v167 == (0 - 0))) then
				if (((15758 - 10964) >= (4341 - (507 + 559))) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108)) then
					if (((4589 - 3105) == (1872 - (212 + 176))) and v24(v100.Stormkeeper)) then
						return "stormkeeper precombat 2";
					end
				end
				if (((2337 - (250 + 655)) < (9694 - 6139)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v42) then
					if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((1666 - 601) > (5534 - (1869 + 87)))) then
						return "icefury precombat 4";
					end
				end
				v167 = 3 - 2;
			end
			if ((v167 == (1903 - (484 + 1417))) or ((10277 - 5482) < (2357 - 950))) then
				if (((2626 - (48 + 725)) < (7862 - 3049)) and v13:IsCasting(v100.ElementalBlast) and v40 and not v100.PrimordialWave:IsAvailable() and v100.FlameShock:IsViable()) then
					if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((7568 - 4747) < (1413 + 1018))) then
						return "flameshock precombat 10";
					end
				end
				if ((v126(v100.LavaBurst) and v44 and not v13:IsCasting(v100.LavaBurst) and (not v100.ElementalBlast:IsAvailable() or (v100.ElementalBlast:IsAvailable() and not v100.ElementalBlast:IsAvailable()))) or ((7680 - 4806) < (611 + 1570))) then
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((784 + 1905) <= (1196 - (152 + 701)))) then
						return "lavaburst precombat 12";
					end
				end
				v167 = 1314 - (430 + 881);
			end
		end
	end
	local function v137()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (902 - (557 + 338))) or ((553 + 1316) == (5661 - 3652))) then
				if ((v126(v100.LavaBeam) and v43 and v127() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((12417 - 8871) < (6168 - 3846))) then
					if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((4486 - 2404) == (5574 - (499 + 302)))) then
						return "lava_beam aoe 82";
					end
				end
				if (((4110 - (39 + 827)) > (2912 - 1857)) and v126(v100.LavaBurst) and (v114 == (6 - 3)) and v100.MasteroftheElements:IsAvailable()) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((13158 - 9845) <= (2729 - 951))) then
						return "lava_burst aoe 84";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((122 + 1299) >= (6158 - 4054))) then
						return "lava_burst aoe 84";
					end
				end
				if (((290 + 1522) <= (5140 - 1891)) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable()) then
					if (((1727 - (103 + 1)) <= (2511 - (475 + 79))) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 86";
					end
					if (((9537 - 5125) == (14118 - 9706)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 86";
					end
				end
				if (((227 + 1523) >= (742 + 100)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (1503 - (1395 + 108))) and v42 and v100.ElectrifiedShocks:IsAvailable() and (v114 < (14 - 9))) then
					if (((5576 - (7 + 1197)) > (807 + 1043)) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
						return "icefury aoe 88";
					end
				end
				if (((81 + 151) < (1140 - (27 + 292))) and v126(v100.FrostShock) and v41 and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and not v16:DebuffUp(v100.ElectrifiedShocksDebuff) and (v114 < (14 - 9)) and v100.UnrelentingCalamity:IsAvailable()) then
					if (((660 - 142) < (3782 - 2880)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock aoe 90";
					end
				end
				v168 = 15 - 7;
			end
			if (((5701 - 2707) > (997 - (43 + 96))) and (v168 == (4 - 3))) then
				if ((v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "player")) or ((8489 - 4734) <= (760 + 155))) then
					if (((1115 + 2831) > (7397 - 3654)) and v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(16 + 24))) then
						return "liquid_magma_totem aoe player 11";
					end
				end
				if ((v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffUp(v100.SurgeofPowerBuff) and v13:BuffDown(v100.SplinteredElementsBuff)) or ((2501 - 1166) >= (1041 + 2265))) then
					if (((356 + 4488) > (4004 - (1414 + 337))) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 12";
					end
					if (((2392 - (1642 + 298)) == (1177 - 725)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave aoe 12";
					end
				end
				if ((v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.DeeplyRootedElements:IsAvailable() and not v100.SurgeofPower:IsAvailable() and v13:BuffDown(v100.SplinteredElementsBuff)) or ((13109 - 8552) < (6193 - 4106))) then
					local v246 = 0 + 0;
					while true do
						if (((3015 + 859) == (4846 - (357 + 615))) and (v246 == (0 + 0))) then
							if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((4755 - 2817) > (4229 + 706))) then
								return "primordial_wave aoe 14";
							end
							if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((9118 - 4863) < (2738 + 685))) then
								return "primordial_wave aoe 14";
							end
							break;
						end
					end
				end
				if (((99 + 1355) <= (1566 + 925)) and v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.MasteroftheElements:IsAvailable() and not v100.LightningRod:IsAvailable()) then
					local v247 = 1301 - (384 + 917);
					while true do
						if ((v247 == (697 - (128 + 569))) or ((5700 - (1407 + 136)) <= (4690 - (687 + 1200)))) then
							if (((6563 - (556 + 1154)) >= (10490 - 7508)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
								return "primordial_wave aoe 16";
							end
							if (((4229 - (9 + 86)) > (3778 - (275 + 146))) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
								return "primordial_wave aoe 16";
							end
							break;
						end
					end
				end
				if (v100.FlameShock:IsCastable() or ((556 + 2861) < (2598 - (29 + 35)))) then
					local v248 = 0 - 0;
					while true do
						if ((v248 == (0 - 0)) or ((12016 - 9294) <= (107 + 57))) then
							if ((v13:BuffUp(v100.SurgeofPowerBuff) and v40 and v100.LightningRod:IsAvailable() and v100.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v100.FlameShockDebuff) < (v16:TimeToDie() - (1028 - (53 + 959)))) and (v111 < (413 - (312 + 96)))) or ((4178 - 1770) < (2394 - (147 + 138)))) then
								local v269 = 899 - (813 + 86);
								while true do
									if (((0 + 0) == v269) or ((60 - 27) == (1947 - (18 + 474)))) then
										if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((150 + 293) >= (13104 - 9089))) then
											return "flame_shock aoe 18";
										end
										if (((4468 - (860 + 226)) > (469 - (121 + 182))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 18";
										end
										break;
									end
								end
							end
							if ((v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < (1 + 5))) or ((1520 - (988 + 252)) == (346 + 2713))) then
								if (((590 + 1291) > (3263 - (49 + 1921))) and v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 20";
								end
								if (((3247 - (223 + 667)) == (2409 - (51 + 1))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 20";
								end
							end
							v248 = 1 - 0;
						end
						if (((263 - 140) == (1248 - (146 + 979))) and (v248 == (1 + 0))) then
							if ((v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (611 - (311 + 294)))) or ((2944 - 1888) >= (1437 + 1955))) then
								if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((2524 - (496 + 947)) < (2433 - (1233 + 125)))) then
									return "flame_shock aoe 22";
								end
								if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((426 + 623) >= (3977 + 455))) then
									return "flame_shock aoe 22";
								end
							end
							if ((v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (2 + 4))) or ((6413 - (963 + 682)) <= (707 + 139))) then
								local v270 = 1504 - (504 + 1000);
								while true do
									if (((0 + 0) == v270) or ((3059 + 299) <= (134 + 1286))) then
										if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((5513 - 1774) <= (2568 + 437))) then
											return "flame_shock aoe 24";
										end
										if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((965 + 694) >= (2316 - (156 + 26)))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v248 = 2 + 0;
						end
						if (((2 - 0) == v248) or ((3424 - (149 + 15)) < (3315 - (890 + 70)))) then
							if ((v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable())) or ((786 - (39 + 78)) == (4705 - (14 + 468)))) then
								local v271 = 0 - 0;
								while true do
									if ((v271 == (0 - 0)) or ((873 + 819) < (354 + 234))) then
										if (v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock)) or ((1020 + 3777) < (1649 + 2002))) then
											return "flame_shock aoe 26";
										end
										if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((1095 + 3082) > (9283 - 4433))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if ((v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable()) or ((396 + 4) > (3903 - 2792))) then
								if (((78 + 2973) > (1056 - (12 + 39))) and v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 28";
								end
								if (((3436 + 257) <= (13563 - 9181)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 28";
								end
							end
							v248 = 10 - 7;
						end
						if ((v248 == (1 + 2)) or ((1728 + 1554) > (10396 - 6296))) then
							if ((v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable()) or ((2385 + 1195) < (13744 - 10900))) then
								local v272 = 1710 - (1596 + 114);
								while true do
									if (((232 - 143) < (5203 - (164 + 549))) and (v272 == (1438 - (1059 + 379)))) then
										if (v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock)) or ((6186 - 1203) < (938 + 870))) then
											return "flame_shock aoe 30";
										end
										if (((646 + 3183) > (4161 - (145 + 247))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 30";
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v168 = 2 + 0;
			end
			if (((687 + 798) <= (8609 - 5705)) and (v168 == (1 + 3))) then
				if (((3678 + 591) == (6931 - 2662)) and v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
					local v249 = 720 - (254 + 466);
					while true do
						if (((947 - (544 + 16)) <= (8841 - 6059)) and (v249 == (628 - (294 + 334)))) then
							if (v104.CastTargetIf(v100.ElementalBlast, v112, "min", v124, nil, not v16:IsSpellInRange(v100.ElementalBlast), nil, nil) or ((2152 - (236 + 17)) <= (396 + 521))) then
								return "elemental_blast aoe 52";
							end
							if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((3357 + 955) <= (3298 - 2422))) then
								return "elemental_blast aoe 52";
							end
							break;
						end
					end
				end
				if (((10567 - 8335) <= (1337 + 1259)) and v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
					if (((1726 + 369) < (4480 - (413 + 381))) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast aoe 54";
					end
				end
				if ((v126(v100.ElementalBlast) and v39 and (v114 == (1 + 2)) and not v100.EchoesofGreatSundering:IsAvailable()) or ((3392 - 1797) >= (11621 - 7147))) then
					if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((6589 - (582 + 1388)) < (4909 - 2027))) then
						return "elemental_blast aoe 56";
					end
				end
				if ((v126(v100.EarthShock) and v38 and v100.EchoesofGreatSundering:IsAvailable()) or ((211 + 83) >= (5195 - (326 + 38)))) then
					local v250 = 0 - 0;
					while true do
						if (((2895 - 866) <= (3704 - (47 + 573))) and (v250 == (0 + 0))) then
							if (v104.CastTargetIf(v100.EarthShock, v112, "min", v124, nil, not v16:IsSpellInRange(v100.EarthShock), nil, nil) or ((8651 - 6614) == (3927 - 1507))) then
								return "earth_shock aoe 58";
							end
							if (((6122 - (1269 + 395)) > (4396 - (76 + 416))) and v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock))) then
								return "earth_shock aoe 58";
							end
							break;
						end
					end
				end
				if (((879 - (319 + 124)) >= (280 - 157)) and v126(v100.EarthShock) and v38 and v100.EchoesofGreatSundering:IsAvailable()) then
					if (((1507 - (564 + 443)) < (5026 - 3210)) and v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock))) then
						return "earth_shock aoe 60";
					end
				end
				v168 = 463 - (337 + 121);
			end
			if (((10471 - 6897) == (11905 - 8331)) and (v168 == (1911 - (1261 + 650)))) then
				if (((94 + 127) < (621 - 231)) and v100.FireElemental:IsReady() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) then
					if (v24(v100.FireElemental) or ((4030 - (772 + 1045)) <= (201 + 1220))) then
						return "fire_elemental aoe 2";
					end
				end
				if (((3202 - (102 + 42)) < (6704 - (1524 + 320))) and v100.StormElemental:IsReady() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) then
					if (v24(v100.StormElemental) or ((2566 - (1049 + 221)) >= (4602 - (18 + 138)))) then
						return "storm_elemental aoe 4";
					end
				end
				if ((v126(v100.Stormkeeper) and not v129() and v48 and ((v65 and v34) or not v65) and (v90 < v108)) or ((3409 - 2016) > (5591 - (67 + 1035)))) then
					if (v24(v100.Stormkeeper) or ((4772 - (136 + 212)) < (114 - 87))) then
						return "stormkeeper aoe 7";
					end
				end
				if ((v100.TotemicRecall:IsCastable() and (v100.LiquidMagmaTotem:CooldownRemains() > (37 + 8)) and v49) or ((1841 + 156) > (5419 - (240 + 1364)))) then
					if (((4547 - (1050 + 32)) > (6830 - 4917)) and v24(v100.TotemicRecall)) then
						return "totemic_recall aoe 8";
					end
				end
				if (((434 + 299) < (2874 - (331 + 724))) and v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "cursor")) then
					if (v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(4 + 36)) or ((5039 - (269 + 375)) == (5480 - (267 + 458)))) then
						return "liquid_magma_totem aoe cursor 10";
					end
				end
				v168 = 1 + 0;
			end
			if ((v168 == (11 - 5)) or ((4611 - (667 + 151)) < (3866 - (1410 + 87)))) then
				if ((v126(v100.LavaBeam) and v43 and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((5981 - (1504 + 393)) == (716 - 451))) then
					if (((11306 - 6948) == (5154 - (461 + 335))) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 72";
					end
				end
				if ((v126(v100.ChainLightning) and v36 and v128()) or ((402 + 2736) < (2754 - (1730 + 31)))) then
					if (((4997 - (728 + 939)) > (8227 - 5904)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 74";
					end
				end
				if ((v126(v100.LavaBeam) and v43 and (v114 >= (11 - 5)) and v13:BuffUp(v100.SurgeofPowerBuff) and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((8307 - 4681) == (5057 - (138 + 930)))) then
					if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((838 + 78) == (2089 + 582))) then
						return "lava_beam aoe 76";
					end
				end
				if (((234 + 38) == (1110 - 838)) and v126(v100.ChainLightning) and v36 and (v114 >= (1772 - (459 + 1307))) and v13:BuffUp(v100.SurgeofPowerBuff)) then
					if (((6119 - (474 + 1396)) <= (8449 - 3610)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 78";
					end
				end
				if (((2603 + 174) < (11 + 3189)) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff)) then
					local v251 = 0 - 0;
					while true do
						if (((13 + 82) < (6532 - 4575)) and (v251 == (0 - 0))) then
							if (((1417 - (562 + 29)) < (1464 + 253)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							if (((2845 - (374 + 1045)) >= (875 + 230)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							break;
						end
					end
				end
				v168 = 21 - 14;
			end
			if (((3392 - (448 + 190)) <= (1091 + 2288)) and (v168 == (3 + 2))) then
				if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 + 0)) and v42 and not v13:BuffUp(v100.AscendanceBuff) and v100.ElectrifiedShocks:IsAvailable() and ((v100.LightningRod:IsAvailable() and (v114 < (19 - 14)) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (8 - 5))))) or ((5421 - (1307 + 187)) == (5603 - 4190))) then
					if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((2701 - 1547) <= (2415 - 1627))) then
						return "icefury aoe 62";
					end
				end
				if ((v126(v100.FrostShock) and v41 and not v13:BuffUp(v100.AscendanceBuff) and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and (not v16:DebuffUp(v100.ElectrifiedShocksDebuff) or (v13:BuffRemains(v100.IcefuryBuff) < v13:GCD())) and ((v100.LightningRod:IsAvailable() and (v114 < (688 - (232 + 451))) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (3 + 0))))) or ((1452 + 191) > (3943 - (510 + 54)))) then
					if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((5647 - 2844) > (4585 - (13 + 23)))) then
						return "frost_shock aoe 64";
					end
				end
				if ((v126(v100.LavaBurst) and v100.MasteroftheElements:IsAvailable() and not v127() and (v129() or ((v118() < (5 - 2)) and v13:HasTier(43 - 13, 3 - 1))) and (v125() < ((((1148 - (830 + 258)) - ((17 - 12) * v100.EyeoftheStorm:TalentRank())) - ((2 + 0) * v25(v100.FlowofPower:IsAvailable()))) - (9 + 1))) and (v114 < (1446 - (860 + 581)))) or ((811 - 591) >= (2399 + 623))) then
					local v252 = 241 - (237 + 4);
					while true do
						if (((6631 - 3809) == (7139 - 4317)) and ((0 - 0) == v252)) then
							if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((869 + 192) == (1067 + 790))) then
								return "lava_burst aoe 66";
							end
							if (((10420 - 7660) > (586 + 778)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 66";
							end
							break;
						end
					end
				end
				if ((v126(v100.LavaBeam) and v43 and (v129())) or ((2667 + 2235) <= (5021 - (85 + 1341)))) then
					if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((6572 - 2720) == (827 - 534))) then
						return "lava_beam aoe 68";
					end
				end
				if ((v126(v100.ChainLightning) and v36 and (v129())) or ((1931 - (45 + 327)) == (8657 - 4069))) then
					if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((4986 - (444 + 58)) == (343 + 445))) then
						return "chain_lightning aoe 70";
					end
				end
				v168 = 2 + 4;
			end
			if (((2234 + 2334) >= (11322 - 7415)) and (v168 == (1735 - (64 + 1668)))) then
				if (((3219 - (1227 + 746)) < (10665 - 7195)) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and not v100.LightningRod:IsAvailable() and v13:HasTier(57 - 26, 498 - (415 + 79))) then
					local v253 = 0 + 0;
					while true do
						if (((4559 - (142 + 349)) >= (417 + 555)) and (v253 == (0 - 0))) then
							if (((245 + 248) < (2743 + 1150)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 42";
							end
							if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((4010 - 2537) >= (5196 - (1710 + 154)))) then
								return "lava_burst aoe 42";
							end
							break;
						end
					end
				end
				if ((v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.MasteroftheElements:IsAvailable() and not v127() and (v125() >= (((378 - (200 + 118)) - ((2 + 3) * v100.EyeoftheStorm:TalentRank())) - ((2 - 0) * v25(v100.FlowofPower:IsAvailable())))) and ((not v100.EchoesofGreatSundering:IsAvailable() and not v100.LightningRod:IsAvailable()) or v13:BuffUp(v100.EchoesofGreatSunderingBuff)) and ((not v13:BuffUp(v100.AscendanceBuff) and (v114 > (4 - 1)) and v100.UnrelentingCalamity:IsAvailable()) or ((v114 > (3 + 0)) and not v100.UnrelentingCalamity:IsAvailable()) or (v114 == (3 + 0)))) or ((2175 + 1876) <= (185 + 972))) then
					if (((1308 - 704) < (4131 - (363 + 887))) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 44";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1571 - 671) == (16073 - 12696))) then
						return "lava_burst aoe 44";
					end
				end
				if (((689 + 3770) > (1382 - 791)) and v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and (v114 > (3 + 0)) and ((v114 > (1667 - (674 + 990))) or (v113 > (1 + 2)))) then
					local v254 = 0 + 0;
					while true do
						if (((5385 - 1987) >= (3450 - (507 + 548))) and (v254 == (837 - (289 + 548)))) then
							if ((v51 == "cursor") or ((4001 - (821 + 997)) >= (3079 - (195 + 60)))) then
								if (((521 + 1415) == (3437 - (251 + 1250))) and v24(v102.EarthquakeCursor, not v16:IsInRange(117 - 77))) then
									return "earthquake aoe 46";
								end
							end
							if ((v51 == "player") or ((3321 + 1511) < (5345 - (809 + 223)))) then
								if (((5965 - 1877) > (11634 - 7760)) and v24(v102.EarthquakePlayer, not v16:IsInRange(132 - 92))) then
									return "earthquake aoe 46";
								end
							end
							break;
						end
					end
				end
				if (((3191 + 1141) == (2269 + 2063)) and v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v114 == (620 - (14 + 603))) and ((v114 == (132 - (118 + 11))) or (v113 == (1 + 2)))) then
					local v255 = 0 + 0;
					while true do
						if (((11653 - 7654) >= (3849 - (551 + 398))) and (v255 == (0 + 0))) then
							if ((v51 == "cursor") or ((899 + 1626) > (3303 + 761))) then
								if (((16255 - 11884) == (10071 - 5700)) and v24(v102.EarthquakeCursor, not v16:IsInRange(13 + 27))) then
									return "earthquake aoe 48";
								end
							end
							if ((v51 == "player") or ((1055 - 789) > (1377 + 3609))) then
								if (((2080 - (40 + 49)) >= (3522 - 2597)) and v24(v102.EarthquakePlayer, not v16:IsInRange(530 - (99 + 391)))) then
									return "earthquake aoe 48";
								end
							end
							break;
						end
					end
				end
				if (((377 + 78) < (9024 - 6971)) and v37 and v100.Earthquake:IsReady() and (v13:BuffUp(v100.EchoesofGreatSunderingBuff))) then
					local v256 = 0 - 0;
					while true do
						if ((v256 == (0 + 0)) or ((2173 - 1347) == (6455 - (1032 + 572)))) then
							if (((600 - (203 + 214)) == (2000 - (568 + 1249))) and (v51 == "cursor")) then
								if (((907 + 252) <= (4294 - 2506)) and v24(v102.EarthquakeCursor, not v16:IsInRange(154 - 114))) then
									return "earthquake aoe 50";
								end
							end
							if ((v51 == "player") or ((4813 - (913 + 393)) > (12193 - 7875))) then
								if (v24(v102.EarthquakePlayer, not v16:IsInRange(56 - 16)) or ((3485 - (269 + 141)) <= (6594 - 3629))) then
									return "earthquake aoe 50";
								end
							end
							break;
						end
					end
				end
				v168 = 1985 - (362 + 1619);
			end
			if (((2990 - (950 + 675)) <= (776 + 1235)) and (v168 == (1187 - (216 + 963)))) then
				if ((v126(v100.LavaBeam) and v43 and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((4063 - (485 + 802)) > (4134 - (432 + 127)))) then
					if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((3627 - (1065 + 8)) == (2669 + 2135))) then
						return "lava_beam aoe 92";
					end
				end
				if (((4178 - (635 + 966)) == (1853 + 724)) and v126(v100.ChainLightning) and v36) then
					if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((48 - (5 + 37)) >= (4697 - 2808))) then
						return "chain_lightning aoe 94";
					end
				end
				if (((211 + 295) <= (2994 - 1102)) and v100.FlameShock:IsCastable() and v40 and v13:IsMoving() and v16:DebuffRefreshable(v100.FlameShockDebuff)) then
					if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((940 + 1068) > (4608 - 2390))) then
						return "flame_shock aoe 96";
					end
				end
				if (((1436 - 1057) <= (7820 - 3673)) and v100.FrostShock:IsCastable() and v41 and v13:IsMoving()) then
					if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((10792 - 6278) <= (726 + 283))) then
						return "frost_shock aoe 98";
					end
				end
				break;
			end
			if ((v168 == (531 - (318 + 211))) or ((17202 - 13706) == (2779 - (963 + 624)))) then
				if ((v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108)) or ((89 + 119) == (3805 - (518 + 328)))) then
					if (((9970 - 5693) >= (2097 - 784)) and v24(v100.Ascendance)) then
						return "ascendance aoe 32";
					end
				end
				if (((2904 - (301 + 16)) < (9302 - 6128)) and v126(v100.LavaBurst) and (v114 == (8 - 5)) and not v100.LightningRod:IsAvailable() and v13:HasTier(80 - 49, 4 + 0)) then
					local v257 = 0 + 0;
					while true do
						if ((v257 == (0 - 0)) or ((2479 + 1641) <= (210 + 1988))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((5074 - 3478) == (277 + 581))) then
								return "lava_burst aoe 34";
							end
							if (((4239 - (829 + 190)) == (11488 - 8268)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 34";
							end
							break;
						end
					end
				end
				if ((v37 and v100.Earthquake:IsReady() and v127() and (((v13:BuffStack(v100.MagmaChamberBuff) > (18 - 3)) and (v114 >= ((9 - 2) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.SplinteredElements:IsAvailable() and (v114 >= ((24 - 14) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.MountainsWillFall:IsAvailable() and (v114 >= (3 + 6)))) and not v100.LightningRod:IsAvailable() and v13:HasTier(11 + 20, 12 - 8)) or ((1323 + 79) > (4233 - (520 + 93)))) then
					local v258 = 276 - (259 + 17);
					while true do
						if (((149 + 2425) == (927 + 1647)) and (v258 == (0 - 0))) then
							if (((2389 - (396 + 195)) < (7998 - 5241)) and (v51 == "cursor")) then
								if (v24(v102.EarthquakeCursor, not v16:IsInRange(1801 - (440 + 1321))) or ((2206 - (1059 + 770)) > (12041 - 9437))) then
									return "earthquake aoe 36";
								end
							end
							if (((1113 - (424 + 121)) < (167 + 744)) and (v51 == "player")) then
								if (((4632 - (641 + 706)) < (1675 + 2553)) and v24(v102.EarthquakePlayer, not v16:IsInRange(480 - (249 + 191)))) then
									return "earthquake aoe 36";
								end
							end
							break;
						end
					end
				end
				if (((17059 - 13143) > (1487 + 1841)) and v126(v100.LavaBeam) and v43 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (22 - 16))) or (v127() and ((v114 < (433 - (183 + 244))) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(2 + 29, 734 - (434 + 296))) then
					if (((7977 - 5477) < (4351 - (169 + 343))) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 38";
					end
				end
				if (((445 + 62) == (892 - 385)) and v126(v100.ChainLightning) and v36 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (17 - 11))) or (v127() and ((v114 < (5 + 1)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(87 - 56, 1127 - (651 + 472))) then
					if (((182 + 58) <= (1366 + 1799)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 40";
					end
				end
				v168 = 3 - 0;
			end
		end
	end
	local function v138()
		if (((1317 - (397 + 86)) >= (1681 - (423 + 453))) and v100.FireElemental:IsCastable() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) then
			if (v24(v100.FireElemental) or ((388 + 3424) < (306 + 2010))) then
				return "fire_elemental single_target 2";
			end
		end
		if ((v100.StormElemental:IsCastable() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) or ((2316 + 336) <= (1224 + 309))) then
			if (v24(v100.StormElemental) or ((3214 + 384) < (2650 - (50 + 1140)))) then
				return "storm_elemental single_target 4";
			end
		end
		if ((v100.TotemicRecall:IsCastable() and v49 and (v100.LiquidMagmaTotem:CooldownRemains() > (39 + 6)) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or ((v113 > (1 + 0)) and (v114 > (1 + 0))))) or ((5910 - 1794) < (863 + 329))) then
			if (v24(v100.TotemicRecall) or ((3973 - (157 + 439)) <= (1569 - 666))) then
				return "totemic_recall single_target 6";
			end
		end
		if (((13211 - 9235) >= (1298 - 859)) and v100.LiquidMagmaTotem:IsCastable() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (918 - (782 + 136))) or (v16:DebuffRemains(v100.FlameShockDebuff) < (861 - (112 + 743))) or ((v113 > (1172 - (1026 + 145))) and (v114 > (1 + 0))))) then
			if (((4470 - (493 + 225)) == (13791 - 10039)) and (v66 == "cursor")) then
				if (((2462 + 1584) > (7225 - 4530)) and v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(1 + 39))) then
					return "liquid_magma_totem single_target cursor 8";
				end
			end
			if ((v66 == "player") or ((10130 - 6585) == (931 + 2266))) then
				if (((3999 - 1605) > (1968 - (210 + 1385))) and v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(1729 - (1201 + 488)))) then
					return "liquid_magma_totem single_target player 8";
				end
			end
		end
		if (((2576 + 1579) <= (7526 - 3294)) and v126(v100.PrimordialWave) and v100.PrimordialWave:IsCastable() and v47 and ((v64 and v34) or not v64) and not v13:BuffUp(v100.PrimordialWaveBuff) and not v13:BuffUp(v100.SplinteredElementsBuff)) then
			local v183 = 0 - 0;
			while true do
				if (((585 - (352 + 233)) == v183) or ((8654 - 5073) == (1890 + 1583))) then
					if (((14201 - 9206) > (3922 - (489 + 85))) and v104.CastCycle(v100.PrimordialWave, v112, v122, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave single_target 10";
					end
					if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((2255 - (277 + 1224)) > (5217 - (663 + 830)))) then
						return "primordial_wave single_target 10";
					end
					break;
				end
			end
		end
		if (((191 + 26) >= (139 - 82)) and v100.FlameShock:IsCastable() and v40 and (v113 == (876 - (461 + 414))) and v16:DebuffRefreshable(v100.FlameShockDebuff) and ((v16:DebuffRemains(v100.FlameShockDebuff) < v100.PrimordialWave:CooldownRemains()) or not v100.PrimordialWave:IsAvailable()) and v13:BuffDown(v100.SurgeofPowerBuff) and (not v127() or (not v129() and ((v100.ElementalBlast:IsAvailable() and (v125() < ((16 + 74) - ((4 + 4) * v100.EyeoftheStorm:TalentRank())))) or (v125() < ((6 + 54) - ((5 + 0) * v100.EyeoftheStorm:TalentRank()))))))) then
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((2320 - (172 + 78)) >= (6509 - 2472))) then
				return "flame_shock single_target 12";
			end
		end
		if (((996 + 1709) == (3903 - 1198)) and v100.FlameShock:IsCastable() and v40 and (v100.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v113 > (1 + 0)) and (v114 > (1 - 0)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((not v127() and (v129() or (v100.Stormkeeper:CooldownRemains() > (0 - 0)))) or not v100.SurgeofPower:IsAvailable())) then
			local v184 = 0 + 0;
			while true do
				if (((34 + 27) == (22 + 39)) and ((0 - 0) == v184)) then
					if (v104.CastTargetIf(v100.FlameShock, v112, "min", v122, nil, not v16:IsSpellInRange(v100.FlameShock)) or ((1628 - 929) >= (398 + 898))) then
						return "flame_shock single_target 14";
					end
					if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((1019 + 764) >= (4063 - (133 + 314)))) then
						return "flame_shock single_target 14";
					end
					break;
				end
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and (v113 > (1 + 0)) and (v114 > (214 - (199 + 14))) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v100.SurgeofPowerBuff) and not v129() and v100.Stormkeeper:IsAvailable()) or not v100.SurgeofPower:IsAvailable())) or ((14007 - 10094) > (6076 - (647 + 902)))) then
			if (((13158 - 8782) > (1050 - (85 + 148))) and v104.CastTargetIf(v100.FlameShock, v112, "min", v122, v119, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 16";
			end
			if (((6150 - (426 + 863)) > (3856 - 3032)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 16";
			end
		end
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (1654 - (873 + 781))) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (v125() >= (155 - 39)) and v100.ElementalBlast:IsAvailable() and v100.SurgeofPower:IsAvailable() and v100.SwellingMaelstrom:IsAvailable() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) or ((3734 - 2351) >= (883 + 1248))) then
			if (v24(v100.Stormkeeper) or ((6930 - 5054) >= (3641 - 1100))) then
				return "stormkeeper single_target 18";
			end
		end
		if (((5291 - 3509) <= (5719 - (414 + 1533))) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and v13:BuffUp(v100.SurgeofPowerBuff) and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
			if (v24(v100.Stormkeeper) or ((5255 - (443 + 112)) < (2292 - (888 + 591)))) then
				return "stormkeeper single_target 20";
			end
		end
		if (((8265 - 5066) < (232 + 3818)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (not v100.SurgeofPower:IsAvailable() or not v100.ElementalBlast:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.EchooftheElements:IsAvailable() or v100.PrimordialSurge:IsAvailable())) then
			if (v24(v100.Stormkeeper) or ((1933 + 3018) < (2143 + 2287))) then
				return "stormkeeper single_target 22";
			end
		end
		if (((11 + 85) == (182 - 86)) and v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108) and not v129()) then
			if (v24(v100.Ascendance) or ((5073 - 2334) > (5686 - (136 + 1542)))) then
				return "ascendance single_target 24";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and v13:BuffUp(v100.SurgeofPowerBuff)) or ((75 - 52) == (1126 + 8))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((4282 - 1589) >= (2976 + 1135))) then
				return "lightning_bolt single_target 26";
			end
		end
		if ((v126(v100.LavaBeam) and v43 and (v113 > (487 - (68 + 418))) and (v114 > (2 - 1)) and v129() and not v100.SurgeofPower:IsAvailable()) or ((7830 - 3514) <= (1853 + 293))) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((4638 - (770 + 322)) <= (162 + 2647))) then
				return "lava_beam single_target 28";
			end
		end
		if (((1419 + 3485) > (296 + 1870)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (1 - 0)) and (v114 > (1 - 0)) and v129() and not v100.SurgeofPower:IsAvailable()) then
			if (((296 - 187) >= (331 - 241)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 30";
			end
		end
		if (((2773 + 2205) > (4352 - 1447)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v129() and not v127() and not v100.SurgeofPower:IsAvailable() and v100.MasteroftheElements:IsAvailable()) then
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1452 + 1574) <= (1398 + 882))) then
				return "lava_burst single_target 32";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and v127()) or ((1296 + 357) <= (4172 - 3064))) then
			if (((4039 - 1130) > (882 + 1727)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 34";
			end
		end
		if (((3487 - 2730) > (641 - 447)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and not v100.MasteroftheElements:IsAvailable()) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((13 + 18) >= (6917 - 5519))) then
				return "lightning_bolt single_target 36";
			end
		end
		if (((4027 - (762 + 69)) <= (15775 - 10903)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v13:BuffUp(v100.SurgeofPowerBuff) and v100.LightningRod:IsAvailable()) then
			if (((2866 + 460) == (2154 + 1172)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 38";
			end
		end
		if (((3465 - 2032) <= (1221 + 2657)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 + 0)) and v42 and v100.ElectrifiedShocks:IsAvailable() and v100.LightningRod:IsAvailable() and v100.LightningRod:IsAvailable()) then
			if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((6167 - 4584) == (1892 - (8 + 149)))) then
				return "icefury single_target 40";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (1322 - (1199 + 121))) or (v13:BuffRemains(v100.IcefuryBuff) <= v13:GCD())) and v100.LightningRod:IsAvailable()) or ((5044 - 2063) == (5305 - 2955))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((1839 + 2627) <= (1759 - 1266))) then
				return "frost_shock single_target 42";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and (v125() >= (116 - 66)) and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < ((2 + 0) * v13:GCD())) and v129() and v100.LightningRod:IsAvailable()) or ((4354 - (518 + 1289)) <= (3407 - 1420))) then
			if (((393 + 2568) > (4001 - 1261)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 44";
			end
		end
		if (((2723 + 973) >= (4081 - (304 + 165))) and v100.LavaBeam:IsCastable() and v43 and (v113 > (1 + 0)) and (v114 > (161 - (54 + 106))) and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime()) and not v13:HasTier(2000 - (1618 + 351), 3 + 1)) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((3986 - (10 + 1006)) == (472 + 1406))) then
				return "lava_beam single_target 46";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v129() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable() and v100.ElementalBlast:IsAvailable() and (((v125() >= (9 + 52)) and (v125() < (242 - 167)) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (1082 - (912 + 121))) and (v125() < (30 + 33)) and (v100.LavaBurst:CooldownRemains() > (1289 - (1140 + 149)))))) or ((2364 + 1329) < (2635 - 658))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((173 + 757) > (7190 - 5089))) then
				return "frost_shock single_target 48";
			end
		end
		if (((7788 - 3635) > (533 + 2553)) and v100.FrostShock:IsCastable() and v41 and v130() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (((v125() >= (124 - 88)) and (v125() < (236 - (165 + 21))) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (135 - (61 + 50))) and (v125() < (16 + 22)) and (v100.LavaBurst:CooldownRemains() > (0 - 0))))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((9378 - 4724) <= (1592 + 2458))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or ((v125() >= (1523 - (1295 + 165))) and v100.MasteroftheElements:IsAvailable()) or ((v125() >= (9 + 29)) and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and (v113 > (1 + 0)) and (v114 > (1398 - (819 + 578)))) or not v100.ElementalBlast:IsAvailable())) or ((4004 - (331 + 1071)) < (2239 - (588 + 155)))) then
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((2302 - (546 + 736)) > (4225 - (1834 + 103)))) then
				return "lava_burst single_target 52";
			end
		end
		if (((202 + 126) == (978 - 650)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.LavaSurgeBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or not v100.ElementalBlast:IsAvailable())) then
			if (((3277 - (1536 + 230)) < (4299 - (128 + 363))) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 54";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.AscendanceBuff) and (v13:HasTier(7 + 24, 9 - 5) or not v100.ElementalBlast:IsAvailable())) or ((649 + 1861) > (8148 - 3229))) then
			local v185 = 0 - 0;
			while true do
				if (((11568 - 6805) == (3269 + 1494)) and (v185 == (1009 - (615 + 394)))) then
					if (((3735 + 402) > (1762 + 86)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					if (((7425 - 4989) <= (14215 - 11081)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					break;
				end
			end
		end
		if (((4374 - (59 + 592)) == (8242 - 4519)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffDown(v100.AscendanceBuff) and (not v100.ElementalBlast:IsAvailable() or not v100.MountainsWillFall:IsAvailable()) and not v100.LightningRod:IsAvailable() and v13:HasTier(56 - 25, 3 + 1)) then
			if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((4217 - (70 + 101)) >= (10669 - 6353))) then
				return "lava_burst single_target 58";
			end
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1424 + 584) < (4844 - 2915))) then
				return "lava_burst single_target 58";
			end
		end
		if (((2625 - (123 + 118)) > (430 + 1345)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and not v100.LightningRod:IsAvailable()) then
			if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((57 + 4486) <= (5775 - (653 + 746)))) then
				return "lava_burst single_target 60";
			end
			if (((1361 - 633) == (1048 - 320)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 60";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and ((v125() >= (200 - 125)) or ((v125() >= (23 + 27)) and not v100.ElementalBlast:IsAvailable())) and v100.SwellingMaelstrom:IsAvailable() and (v125() <= (84 + 46))) or ((940 + 136) > (573 + 4098))) then
			if (((289 + 1562) >= (926 - 548)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 62";
			end
		end
		if ((v100.Earthquake:IsReady() and v37 and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (2 + 0))) or (v113 > (1 - 0)))) or ((3182 - (885 + 349)) >= (2761 + 715))) then
			if (((13073 - 8279) >= (2423 - 1590)) and (v51 == "cursor")) then
				if (((5058 - (915 + 53)) == (4891 - (768 + 33))) and v24(v102.EarthquakeCursor, not v16:IsInRange(153 - 113))) then
					return "earthquake single_target 64";
				end
			end
			if ((v51 == "player") or ((6615 - 2857) == (2826 - (287 + 41)))) then
				if (v24(v102.EarthquakePlayer, not v16:IsInRange(887 - (638 + 209))) or ((1389 + 1284) < (3261 - (96 + 1590)))) then
					return "earthquake single_target 64";
				end
			end
		end
		if ((v100.Earthquake:IsReady() and v37 and (v113 > (1673 - (741 + 931))) and (v114 > (1 + 0)) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) or ((10601 - 6880) <= (6797 - 5342))) then
			if (((401 + 533) < (976 + 1294)) and (v51 == "cursor")) then
				if (v24(v102.EarthquakeCursor, not v16:IsInRange(13 + 27)) or ((6117 - 4505) == (408 + 847))) then
					return "earthquake single_target 66";
				end
			end
			if ((v51 == "player") or ((2125 + 2227) < (17156 - 12950))) then
				if (v24(v102.EarthquakePlayer, not v16:IsInRange(36 + 4)) or ((3354 - (64 + 430)) <= (180 + 1))) then
					return "earthquake single_target 66";
				end
			end
		end
		if (((3585 - (106 + 257)) >= (1083 + 444)) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (not v100.MasteroftheElements:IsAvailable() or (v127() and v16:DebuffUp(v100.ElectrifiedShocksDebuff)))) then
			if (((2226 - (496 + 225)) <= (4336 - 2215)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 68";
			end
		end
		if (((3624 - 2880) == (2402 - (256 + 1402))) and v126(v100.FrostShock) and v41 and v130() and v127() and (v125() < (2009 - (30 + 1869))) and (v100.LavaBurst:ChargesFractional() < (1370 - (213 + 1156))) and v100.ElectrifiedShocks:IsAvailable() and v100.ElementalBlast:IsAvailable() and not v100.LightningRod:IsAvailable()) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((2167 - (96 + 92)) >= (484 + 2352))) then
				return "frost_shock single_target 70";
			end
		end
		if (((2732 - (142 + 757)) <= (2174 + 494)) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (v127() or v100.LightningRod:IsAvailable())) then
			if (((1507 + 2179) == (3765 - (32 + 47))) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 72";
			end
		end
		if (((5444 - (1053 + 924)) > (468 + 9)) and v100.EarthShock:IsReady() and v38) then
			if (v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock)) or ((5662 - 2374) >= (5189 - (685 + 963)))) then
				return "earth_shock single_target 74";
			end
		end
		if ((v126(v100.FrostShock) and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and v127() and not v100.LightningRod:IsAvailable() and (v113 > (1 - 0)) and (v114 > (1 - 0))) or ((5266 - (541 + 1168)) == (6137 - (645 + 952)))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((1099 - (669 + 169)) > (4388 - 3121))) then
				return "frost_shock single_target 76";
			end
		end
		if (((2761 - 1489) < (1303 + 2555)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.DeeplyRootedElements:IsAvailable())) then
			local v186 = 0 + 0;
			while true do
				if (((4429 - (181 + 584)) == (5059 - (665 + 730))) and (v186 == (0 - 0))) then
					if (((3958 - 2017) >= (1800 - (540 + 810))) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 78";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((18575 - 13929) < (890 - 566))) then
						return "lava_burst single_target 78";
					end
					break;
				end
			end
		end
		if (((3051 + 782) == (4036 - (166 + 37))) and v100.FrostShock:IsCastable() and v41 and v130() and v100.FluxMelting:IsAvailable() and v13:BuffDown(v100.FluxMeltingBuff)) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3121 - (22 + 1859)) > (5142 - (843 + 929)))) then
				return "frost_shock single_target 80";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and ((v100.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (264 - (30 + 232)))) or (v13:BuffRemains(v100.IcefuryBuff) < (17 - 11)))) or ((3258 - (55 + 722)) == (10049 - 5367))) then
			if (((6402 - (78 + 1597)) >= (46 + 162)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 82";
			end
		end
		if (((255 + 25) < (3224 + 627)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.ElementalBlast:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or v129())) then
			local v187 = 549 - (305 + 244);
			while true do
				if ((v187 == (0 + 0)) or ((3112 - (95 + 10)) > (2262 + 932))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((6768 - 4632) >= (4030 - 1084))) then
						return "lava_burst single_target 84";
					end
					if (((2927 - (592 + 170)) <= (8792 - 6271)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 84";
					end
					break;
				end
			end
		end
		if (((7184 - 4323) > (309 + 352)) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39) then
			if (((1762 + 2763) > (10912 - 6393)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if (((516 + 2662) > (1801 - 829)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v128() and v100.UnrelentingCalamity:IsAvailable() and (v113 > (508 - (353 + 154))) and (v114 > (1 - 0))) then
			if (((6511 - 1745) == (3289 + 1477)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 88";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v128() and v100.UnrelentingCalamity:IsAvailable()) or ((2150 + 595) > (2064 + 1064))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((1652 - 508) >= (8718 - 4112))) then
				return "lightning_bolt single_target 90";
			end
		end
		if (((7781 - 4443) >= (363 - (7 + 79))) and v126(v100.Icefury) and v100.Icefury:IsCastable() and v42) then
			if (((1221 + 1389) > (2741 - (24 + 157))) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 92";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128()) and (v113 > (1 - 0)) and (v114 > (2 - 1))) or ((340 + 854) > (8304 - 5221))) then
			if (((1296 - (262 + 118)) >= (1830 - (1038 + 45))) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 94";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128())) or ((5285 - 2841) > (3184 - (19 + 211)))) then
			if (((3005 - (88 + 25)) < (8946 - 5432)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 96";
			end
		end
		if (((265 + 268) == (498 + 35)) and v100.FrostShock:IsCastable() and v41 and v130() and v127() and v13:BuffDown(v100.LavaSurgeBuff) and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable() and (v100.LavaBurst:ChargesFractional() < (1037 - (1007 + 29))) and v100.EchooftheElements:IsAvailable()) then
			if (((161 + 434) <= (8342 - 4929)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 98";
			end
		end
		if (((14557 - 11479) >= (578 + 2013)) and v100.FrostShock:IsCastable() and v41 and v130() and (v100.FluxMelting:IsAvailable() or (v100.ElectrifiedShocks:IsAvailable() and not v100.LightningRod:IsAvailable()))) then
			if (((4010 - (340 + 471)) < (10150 - 6120)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 100";
			end
		end
		if (((1366 - (276 + 313)) < (5072 - 2994)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable() and (v113 > (1 + 0)) and (v114 > (1 + 0))) then
			if (((3668 - (495 + 1477)) <= (6832 - 4550)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 102";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable()) or ((2164 - (342 + 61)) >= (1077 + 1385))) then
			if (((4716 - (4 + 161)) > (1426 + 902)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 104";
			end
		end
		if (((12006 - 8181) >= (1227 - 760)) and v100.FrostShock:IsCastable() and v41 and v130() and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable()) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3387 - (322 + 175)) == (1120 - (173 + 390)))) then
				return "frost_shock single_target 106";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (1 + 0)) and (v114 > (315 - (203 + 111)))) or ((296 + 4474) == (2048 + 856))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((11390 - 7487) == (4098 + 438))) then
				return "chain_lightning single_target 108";
			end
		end
		if (((4799 - (57 + 649)) <= (5229 - (328 + 56))) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45) then
			if (((502 + 1067) <= (4159 - (433 + 79))) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 110";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and (v13:IsMoving())) or ((371 + 3675) >= (3978 + 949))) then
			if (((15545 - 10922) >= (13179 - 10392)) and v104.CastCycle(v100.FlameShock, v112, v119, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 112";
			end
			if (((1629 + 605) >= (1096 + 134)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 112";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40) or ((1379 - (562 + 474)) == (4166 - 2380))) then
			if (((5236 - 2666) > (3314 - (76 + 829))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 114";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41) or ((4282 - (1506 + 167)) >= (6074 - 2840))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3299 - (58 + 208)) >= (2381 + 1650))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v139()
		if ((v73 and v100.EarthShield:IsCastable() and v13:BuffDown(v100.EarthShieldBuff) and ((v74 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.LightningShield)))) or ((999 + 402) == (2683 + 1985))) then
			if (((11325 - 8549) >= (1658 - (258 + 79))) and v24(v100.EarthShield)) then
				return "earth_shield main 2";
			end
		elseif ((v73 and v100.LightningShield:IsCastable() and v13:BuffDown(v100.LightningShieldBuff) and ((v74 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.EarthShield)))) or ((62 + 425) > (4844 - 2541))) then
			if (v24(v100.LightningShield) or ((5973 - (1219 + 251)) == (5133 - (1231 + 440)))) then
				return "lightning_shield main 2";
			end
		end
		v30 = v133();
		if (((611 - (34 + 24)) <= (895 + 648)) and v30) then
			return v30;
		end
		if (((3761 - 1746) == (881 + 1134)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) then
			if (v24(v100.AncestralSpirit, nil, true) or ((12880 - 8639) <= (7475 - 5143))) then
				return "ancestral_spirit";
			end
		end
		if ((v100.AncestralSpirit:IsCastable() and v100.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) or ((6214 - 3850) < (3876 - 2719))) then
			if (v24(v102.AncestralSpiritMouseover) or ((2548 - 1381) > (2867 - (877 + 712)))) then
				return "ancestral_spirit mouseover";
			end
		end
		v109, v110 = v29();
		if ((v100.ImprovedFlametongueWeapon:IsAvailable() and v100.FlametongueWeapon:IsCastable() and v50 and (not v109 or (v110 < (359246 + 240754))) and v100.FlametongueWeapon:IsAvailable()) or ((1899 - (242 + 512)) <= (2260 - 1178))) then
			if (v24(v100.FlametongueWeapon) or ((3732 - (92 + 535)) == (3843 + 1038))) then
				return "flametongue_weapon enchant";
			end
		end
		if ((not v13:AffectingCombat() and v31 and v104.TargetIsValid()) or ((3886 - 1999) > (306 + 4572))) then
			v30 = v136();
			if (v30 or ((14854 - 10767) > (4036 + 80))) then
				return v30;
			end
		end
	end
	local function v140()
		local v169 = 0 + 0;
		while true do
			if (((156 + 950) <= (2522 - 1256)) and (v169 == (0 - 0))) then
				v30 = v134();
				if (((4940 - (1476 + 309)) < (5934 - (299 + 985))) and v30) then
					return v30;
				end
				v169 = 1 + 0;
			end
			if (((12371 - 8597) >= (1932 - (86 + 7))) and (v169 == (12 - 9))) then
				if (((268 + 2543) == (3691 - (672 + 208))) and v100.Purge:IsReady() and v97 and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) then
					if (((920 + 1226) > (1254 - (14 + 118))) and v24(v100.Purge, not v16:IsSpellInRange(v100.Purge))) then
						return "purge damage";
					end
				end
				if ((v104.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((501 - (339 + 106)) == (2877 + 739))) then
					if (((v90 < v108) and v57 and ((v63 and v33) or not v63)) or ((1218 + 1203) < (2017 - (440 + 955)))) then
						local v265 = 0 + 0;
						while true do
							if (((1812 - 803) <= (375 + 755)) and (v265 == (0 - 0))) then
								if (((1889 + 869) < (3333 - (260 + 93))) and v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (47 + 3)))) then
									if (v24(v100.BloodFury) or ((196 - 110) >= (6547 - 2921))) then
										return "blood_fury main 2";
									end
								end
								if (((4369 - (1181 + 793)) == (610 + 1785)) and v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) then
									if (((4087 - (105 + 202)) > (2172 + 537)) and v24(v100.Berserking)) then
										return "berserking main 4";
									end
								end
								v265 = 811 - (352 + 458);
							end
							if ((v265 == (7 - 5)) or ((605 - 368) >= (2201 + 72))) then
								if ((v100.BagofTricks:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) or ((5962 - 3922) <= (1652 - (438 + 511)))) then
									if (((4662 - (1262 + 121)) <= (5035 - (728 + 340))) and v24(v100.BagofTricks)) then
										return "bag_of_tricks main 10";
									end
								end
								break;
							end
							if ((v265 == (1791 - (816 + 974))) or ((6090 - 4102) == (3156 - 2279))) then
								if (((4630 - (163 + 176)) > (5442 - 3530)) and v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (229 - 179)))) then
									if (((605 + 1398) < (4149 - (1564 + 246))) and v24(v100.Fireblood)) then
										return "fireblood main 6";
									end
								end
								if (((777 - (124 + 221)) == (296 + 136)) and v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (501 - (115 + 336))))) then
									if (v24(v100.AncestralCall) or ((2521 - 1376) >= (259 + 994))) then
										return "ancestral_call main 8";
									end
								end
								v265 = 48 - (45 + 1);
							end
						end
					end
					if (((185 + 3233) > (4108 - (1282 + 708))) and (v90 < v108)) then
						if (((4278 - (583 + 629)) <= (648 + 3242)) and v56 and ((v33 and v62) or not v62)) then
							local v267 = 0 - 0;
							while true do
								if ((v267 == (0 + 0)) or ((4168 - (943 + 227)) >= (1435 + 1846))) then
									v30 = v135();
									if (v30 or ((6280 - (1539 + 92)) <= (4578 - (706 + 1240)))) then
										return v30;
									end
									break;
								end
							end
						end
					end
					if ((v100.NaturesSwiftness:IsCastable() and v46) or ((4118 - (81 + 177)) > (13764 - 8892))) then
						if (v24(v100.NaturesSwiftness) or ((4255 - (212 + 45)) == (7686 - 5388))) then
							return "natures_swiftness main 12";
						end
					end
					local v259 = v104.HandleDPSPotion(v13:BuffUp(v100.AscendanceBuff));
					if (v259 or ((1954 - (708 + 1238)) >= (228 + 2511))) then
						return v259;
					end
					if (((848 + 1742) == (4257 - (586 + 1081))) and v32 and (v113 > (513 - (348 + 163))) and (v114 > (2 + 0))) then
						v30 = v137();
						if (v30 or ((362 - (215 + 65)) >= (4764 - 2894))) then
							return v30;
						end
						if (((4483 - (1541 + 318)) < (4042 + 515)) and v24(v100.Pool)) then
							return "Pool for Aoe()";
						end
					end
					if (true or ((1583 + 1548) > (2670 + 872))) then
						v30 = v138();
						if (((4327 - (1036 + 714)) >= (1040 + 538)) and v30) then
							return v30;
						end
						if (((2266 + 1837) <= (5851 - (883 + 397))) and v24(v100.Pool)) then
							return "Pool for SingleTarget()";
						end
					end
				end
				break;
			end
			if ((v169 == (591 - (563 + 27))) or ((5849 - 4354) == (6773 - (1369 + 617)))) then
				if (v85 or ((1797 - (85 + 1402)) > (1529 + 2905))) then
					local v260 = 0 - 0;
					while true do
						if (((2571 - (274 + 129)) <= (4577 - (12 + 205))) and ((0 + 0) == v260)) then
							if (((3853 - 2859) == (962 + 32)) and v80) then
								local v273 = 384 - (27 + 357);
								while true do
									if (((2135 - (91 + 389)) > (698 - (90 + 207))) and (v273 == (0 + 0))) then
										v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 901 - (706 + 155));
										if (((4858 - (730 + 1065)) <= (4989 - (1339 + 224))) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if (((743 + 716) > (681 + 83)) and v81) then
								v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 44 - 14);
								if (v30 or ((1484 - (268 + 575)) > (5628 - (919 + 375)))) then
									return v30;
								end
							end
							v260 = 2 - 1;
						end
						if (((4370 - (180 + 791)) >= (4065 - (323 + 1482))) and ((1919 - (1177 + 741)) == v260)) then
							if (v82 or ((26 + 367) >= (15907 - 11665))) then
								local v274 = 0 + 0;
								while true do
									if (((2208 - 1219) < (407 + 4452)) and ((109 - (96 + 13)) == v274)) then
										v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 1951 - (962 + 959));
										if (v30 or ((11977 - 7182) < (168 + 781))) then
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
				if (((5193 - (461 + 890)) == (2819 + 1023)) and v86) then
					local v261 = 0 - 0;
					while true do
						if (((1990 - (19 + 224)) <= (3264 + 337)) and (v261 == (198 - (37 + 161)))) then
							v30 = v104.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 11 + 19, true);
							if (v30 or ((312 + 492) > (4300 + 59))) then
								return v30;
							end
							break;
						end
					end
				end
				v169 = 63 - (60 + 1);
			end
			if (((5593 - (826 + 97)) >= (3509 + 114)) and (v169 == (6 - 4))) then
				if (((4254 - 2189) < (3229 - (375 + 310))) and v17) then
					if (((3310 - (1864 + 135)) <= (8666 - 5307)) and v84) then
						v30 = v132();
						if (((602 + 2115) <= (1056 + 2100)) and v30) then
							return v30;
						end
						if (((2655 - 1574) < (5655 - (314 + 817))) and v14 and v14:Exists() and not v13:CanAttack(v14) and v104.UnitHasDispellableDebuffByPlayer(v14)) then
							if (((250 + 190) >= (285 - (32 + 182))) and v100.CleanseSpirit:IsCastable()) then
								if (((3647 + 1287) > (9111 - 6504)) and v24(v102.CleanseSpiritMouseover, not v14:IsSpellInRange(v100.PurifySpirit))) then
									return "purify_spirit dispel mouseover";
								end
							end
						end
					end
				end
				if ((v100.GreaterPurge:IsAvailable() and v97 and v100.GreaterPurge:IsReady() and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) or ((1465 - (39 + 26)) > (3260 - (54 + 90)))) then
					if (((723 - (45 + 153)) < (1009 + 653)) and v24(v100.GreaterPurge, not v16:IsSpellInRange(v100.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v169 = 555 - (457 + 95);
			end
		end
	end
	local function v141()
		local v170 = 0 + 0;
		while true do
			if ((v170 == (6 - 3)) or ((2117 - 1241) > (9220 - 6670))) then
				v45 = EpicSettings.Settings['useLightningBolt'];
				v46 = EpicSettings.Settings['useNaturesSwiftness'];
				v47 = EpicSettings.Settings['usePrimordialWave'];
				v170 = 2 + 2;
			end
			if (((755 - 536) <= (7414 - 4958)) and (v170 == (756 - (485 + 263)))) then
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v65 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if ((v170 == (708 - (575 + 132))) or ((5080 - (750 + 111)) == (2160 - (445 + 565)))) then
				v39 = EpicSettings.Settings['useElementalBlast'];
				v40 = EpicSettings.Settings['useFlameShock'];
				v41 = EpicSettings.Settings['useFrostShock'];
				v170 = 2 + 0;
			end
			if ((v170 == (2 + 5)) or ((5279 - 2290) <= (75 + 147))) then
				v61 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v59 = EpicSettings.Settings['fireElementalWithCD'];
				v60 = EpicSettings.Settings['stormElementalWithCD'];
				v170 = 318 - (189 + 121);
			end
			if (((560 + 1698) > (2588 - (634 + 713))) and ((542 - (493 + 45)) == v170)) then
				v48 = EpicSettings.Settings['useStormkeeper'];
				v49 = EpicSettings.Settings['useTotemicRecall'];
				v50 = EpicSettings.Settings['useWeaponEnchant'];
				v170 = 973 - (493 + 475);
			end
			if (((11 + 30) < (5043 - (158 + 626))) and (v170 == (3 + 2))) then
				v91 = EpicSettings.Settings['useWeapon'];
				v52 = EpicSettings.Settings['useAscendance'];
				v54 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v170 = 9 - 3;
			end
			if ((v170 == (0 + 0)) or ((105 + 1825) < (1147 - (1035 + 56)))) then
				v36 = EpicSettings.Settings['useChainlightning'];
				v37 = EpicSettings.Settings['useEarthquake'];
				v38 = EpicSettings.Settings['useEarthShock'];
				v170 = 960 - (114 + 845);
			end
			if (((1299 + 2034) == (8531 - 5198)) and (v170 == (6 + 0))) then
				v53 = EpicSettings.Settings['useFireElemental'];
				v55 = EpicSettings.Settings['useStormElemental'];
				v58 = EpicSettings.Settings['ascendanceWithCD'];
				v170 = 1056 - (179 + 870);
			end
			if (((2 - 0) == v170) or ((3103 - (827 + 51)) == (52 - 32))) then
				v42 = EpicSettings.Settings['useIceFury'];
				v43 = EpicSettings.Settings['useLavaBeam'];
				v44 = EpicSettings.Settings['useLavaBurst'];
				v170 = 2 + 1;
			end
		end
	end
	local function v142()
		local v171 = 473 - (95 + 378);
		while true do
			if ((v171 == (1 + 0)) or ((1234 - 362) >= (2716 + 376))) then
				v71 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v75 = EpicSettings.Settings['ancestralGuidanceHP'] or (1011 - (334 + 677));
				v76 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
				v171 = 1058 - (1049 + 7);
			end
			if (((19231 - 14827) >= (6117 - 2865)) and (v171 == (2 + 2))) then
				v99 = EpicSettings.Settings['healOOCHP'] or (0 - 0);
				v97 = EpicSettings.Settings['usePurgeTarget'];
				v80 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v81 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v171 = 10 - 5;
			end
			if (((493 + 614) > (2216 - (1004 + 416))) and ((1960 - (1621 + 336)) == v171)) then
				v66 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v73 = EpicSettings.Settings['autoShield'];
				v74 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v98 = EpicSettings.Settings['healOOC'];
				v171 = 1943 - (337 + 1602);
			end
			if (((2476 - (1014 + 503)) == (1974 - (446 + 569))) and (v171 == (1 + 4))) then
				v82 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if ((v171 == (5 - 3)) or ((83 + 162) >= (4576 - 2372))) then
				v77 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
				v78 = EpicSettings.Settings['healingStreamTotemHP'] or (505 - (223 + 282));
				v79 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v51 = EpicSettings.Settings['earthquakeSetting'] or "";
				v171 = 4 - 1;
			end
			if (((4612 - 1450) >= (2739 - (623 + 47))) and (v171 == (45 - (32 + 13)))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v171 = 1 + 0;
			end
		end
	end
	local function v143()
		local v172 = 0 + 0;
		while true do
			if ((v172 == (1805 - (1070 + 731))) or ((293 + 13) > (4485 - (1257 + 147)))) then
				v95 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v94 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v172 = 138 - (98 + 35);
			end
			if ((v172 == (1 + 0)) or ((12441 - 8928) < (9106 - 6400))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v84 = EpicSettings.Settings['DispelDebuffs'];
				v83 = EpicSettings.Settings['DispelBuffs'];
				v172 = 2 + 0;
			end
			if (((2621 + 357) < (1594 + 2045)) and (v172 == (559 - (395 + 162)))) then
				v56 = EpicSettings.Settings['useTrinkets'];
				v57 = EpicSettings.Settings['useRacials'];
				v62 = EpicSettings.Settings['trinketsWithCD'];
				v172 = 3 + 0;
			end
			if (((5623 - (816 + 1125)) >= (4120 - 1232)) and (v172 == (1153 - (701 + 447)))) then
				v85 = EpicSettings.Settings['handleAfflicted'];
				v86 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((228 - 79) < (836 - 357)) and (v172 == (1344 - (391 + 950)))) then
				v63 = EpicSettings.Settings['racialsWithCD'];
				v93 = EpicSettings.Settings['useHealthstone'];
				v92 = EpicSettings.Settings['useHealingPotion'];
				v172 = 10 - 6;
			end
			if (((2556 - 1536) >= (1397 - 830)) and (v172 == (0 + 0))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v172 = 3 - 2;
			end
		end
	end
	local function v144()
		v142();
		v141();
		v143();
		v31 = EpicSettings.Toggles['ooc'];
		v32 = EpicSettings.Toggles['aoe'];
		v33 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		v34 = EpicSettings.Toggles['minicds'];
		if (v13:IsDeadOrGhost() or ((2255 - (251 + 1271)) > (2199 + 270))) then
			return v30;
		end
		v111 = v13:GetEnemiesInRange(107 - 67);
		v112 = v16:GetEnemiesInSplashRange(12 - 7);
		if (((4134 - 1637) == (3756 - (1147 + 112))) and v32) then
			local v188 = 0 + 0;
			while true do
				if (((7922 - 4021) == (1013 + 2888)) and (v188 == (697 - (335 + 362)))) then
					v113 = #v111;
					v114 = v27(v16:GetEnemiesInSplashRangeCount(5 + 0), v113);
					break;
				end
			end
		else
			v113 = 1 - 0;
			v114 = 2 - 1;
		end
		if (((746 - 545) < (2020 - 1605)) and v35 and v84) then
			if ((v13:AffectingCombat() and v100.CleanseSpirit:IsAvailable()) or ((377 - 244) == (2350 - (237 + 329)))) then
				local v240 = v84 and v100.CleanseSpirit:IsReady() and v35;
				v30 = v104.FocusUnit(v240, nil, 71 - 51, nil, 17 + 8, v100.HealingSurge);
				if (v30 or ((4 + 3) >= (1434 - (408 + 716)))) then
					return v30;
				end
			end
			if (((18966 - 13974) > (1107 - (344 + 477))) and v100.CleanseSpirit:IsAvailable()) then
				if ((v14 and v14:Exists() and v14:IsAPlayer() and v104.UnitHasCurseDebuff(v14)) or ((436 + 2125) == (5654 - (1188 + 573)))) then
					if (((11430 - 7068) >= (1385 + 36)) and v100.CleanseSpirit:IsReady()) then
						if (((243 - 168) <= (5480 - 1934)) and v24(v102.CleanseSpiritMouseover)) then
							return "cleanse_spirit mouseover";
						end
					end
				end
			end
		end
		if (((6628 - 3948) <= (4947 - (508 + 1021))) and (v104.TargetIsValid() or v13:AffectingCombat())) then
			v107 = v9.BossFightRemains();
			v108 = v107;
			if ((v108 == (10442 + 669)) or ((5454 - (228 + 938)) < (3561 - (332 + 353)))) then
				v108 = v9.FightRemains(v111, false);
			end
		end
		if (((2999 - 537) >= (3003 - 1856)) and not v13:IsChanneling() and not v13:IsCasting()) then
			if (v85 or ((4656 + 258) < (1244 + 1236))) then
				local v241 = 0 - 0;
				while true do
					if (((424 - (18 + 405)) == v241) or ((715 + 844) == (627 + 613))) then
						if (((861 - 295) == (1544 - (194 + 784))) and v82) then
							v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 1800 - (694 + 1076));
							if (((5825 - (122 + 1782)) >= (2832 + 177)) and v30) then
								return v30;
							end
						end
						break;
					end
					if (((1923 + 140) >= (1484 + 164)) and (v241 == (0 + 0))) then
						if (((3122 - 2056) >= (419 + 33)) and v80) then
							v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 2010 - (214 + 1756));
							if (((24044 - 19070) >= (293 + 2362)) and v30) then
								return v30;
							end
						end
						if (v81 or ((150 + 2571) <= (1492 - (217 + 368)))) then
							local v268 = 0 - 0;
							while true do
								if (((2922 + 1515) >= (2249 + 782)) and (v268 == (0 + 0))) then
									v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 919 - (844 + 45));
									if (v30 or ((4754 - (242 + 42)) < (5902 - 2953))) then
										return v30;
									end
									break;
								end
							end
						end
						v241 = 2 - 1;
					end
				end
			end
			if (v13:AffectingCombat() or ((2780 - (132 + 1068)) == (3873 - 1447))) then
				if ((v33 and v91 and (v101.Dreambinder:IsEquippedAndReady() or v101.Iridal:IsEquippedAndReady())) or ((5334 - (214 + 1409)) == (390 + 113))) then
					if (v24(v102.UseWeapon, nil) or ((2054 - (497 + 1137)) == (5258 - (9 + 931)))) then
						return "Using Weapon Macro";
					end
				end
				v30 = v140();
				if (v30 or ((4447 - (181 + 108)) <= (20 + 13))) then
					return v30;
				end
			else
				local v242 = 0 - 0;
				while true do
					if ((v242 == (0 - 0)) or ((24 + 75) > (2958 + 1786))) then
						v30 = v139();
						if (((4817 - (296 + 180)) == (5744 - (1183 + 220))) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
	end
	local function v145()
		local v178 = 1265 - (1037 + 228);
		while true do
			if (((412 - 157) <= (4599 - 3003)) and (v178 == (0 - 0))) then
				v100.FlameShockDebuff:RegisterAuraTracking();
				v106();
				v178 = 735 - (527 + 207);
			end
			if ((v178 == (528 - (187 + 340))) or ((6303 - (1298 + 572)) < (4065 - 2430))) then
				v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(432 - (144 + 26), v144, v145);
end;
return v0["Epix_Shaman_Elemental.lua"]();

