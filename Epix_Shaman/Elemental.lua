local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1025 - (832 + 192))) or ((5240 - (1090 + 820)) < (1258 + 171))) then
			return v6(...);
		end
		if (((2688 - (718 + 823)) >= (211 + 124)) and (v5 == (805 - (266 + 539)))) then
			v6 = v0[v4];
			if (((9725 - 6290) > (3322 - (636 + 589))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
	end
end
v0["Epix_Shaman_Elemental.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.MouseOver;
	local v16 = v12.Pet;
	local v17 = v12.Target;
	local v18 = v12.Focus;
	local v19 = v10.Spell;
	local v20 = v10.MultiSpell;
	local v21 = v10.Item;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Macro;
	local v25 = v22.Press;
	local v26 = v22.Commons.Everyone.num;
	local v27 = v22.Commons.Everyone.bool;
	local v28 = math.max;
	local v29 = GetTime;
	local v30 = GetWeaponEnchantInfo;
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
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
	local v100 = v19.Shaman.Elemental;
	local v101 = v21.Shaman.Elemental;
	local v102 = v24.Shaman.Elemental;
	local v103 = {};
	local v104 = v22.Commons.Everyone;
	local v105 = v22.Commons.Shaman;
	local function v106()
		if (v100.CleanseSpirit:IsAvailable() or ((7775 - 4005) >= (3203 + 838))) then
			v104.DispellableDebuffs = v104.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		local v145 = 0 + 0;
		while true do
			if ((v145 == (1015 - (657 + 358))) or ((10037 - 6246) <= (3670 - 2059))) then
				v100.PrimordialWave:RegisterInFlightEffect(328349 - (1151 + 36));
				v100.PrimordialWave:RegisterInFlight();
				v145 = 1 + 0;
			end
			if ((v145 == (1 + 0)) or ((13671 - 9093) <= (3840 - (1552 + 280)))) then
				v100.LavaBurst:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v100.PrimordialWave:RegisterInFlightEffect(327996 - (64 + 770));
	v100.PrimordialWave:RegisterInFlight();
	v100.LavaBurst:RegisterInFlight();
	local v107 = 7544 + 3567;
	local v108 = 25222 - 14111;
	local v109, v110;
	local v111, v112;
	local v113 = 0 + 0;
	local v114 = 1243 - (157 + 1086);
	local v115 = 0 - 0;
	local v116 = 0 - 0;
	local v117 = 0 - 0;
	local function v118()
		return (54 - 14) - (v29() - v115);
	end
	v10:RegisterForSelfCombatEvent(function(...)
		local v146 = 819 - (599 + 220);
		local v147;
		local v148;
		local v149;
		while true do
			if (((2240 - 1115) <= (4007 - (1813 + 118))) and (v146 == (0 + 0))) then
				v147, v148, v148, v148, v149 = select(1225 - (841 + 376), ...);
				if (((v147 == v14:GUID()) and (v149 == (268526 - 76892))) or ((173 + 570) >= (12007 - 7608))) then
					v116 = v29();
					C_Timer.After(859.1 - (464 + 395), function()
						if (((2964 - 1809) < (804 + 869)) and (v116 ~= v117)) then
							v115 = v116;
						end
					end);
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v119(v150)
		return (v150:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v120(v151)
		return v151:DebuffRefreshable(v100.FlameShockDebuff) and (v151:DebuffRemains(v100.FlameShockDebuff) < (v151:TimeToDie() - (842 - (467 + 370))));
	end
	local function v121(v152)
		return v152:DebuffRefreshable(v100.FlameShockDebuff) and (v152:DebuffRemains(v100.FlameShockDebuff) < (v152:TimeToDie() - (9 - 4))) and (v152:DebuffRemains(v100.FlameShockDebuff) > (0 + 0));
	end
	local function v122(v153)
		return (v153:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v123(v154)
		return v154:DebuffRemains(v100.FlameShockDebuff) > (6 - 4);
	end
	local function v124(v155)
		return (v155:DebuffRemains(v100.LightningRodDebuff));
	end
	local function v125()
		local v156 = 0 + 0;
		local v157;
		while true do
			if ((v156 == (0 - 0)) or ((2844 - (150 + 370)) <= (1860 - (74 + 1208)))) then
				v157 = v14:Maelstrom();
				if (((9264 - 5497) == (17865 - 14098)) and not v14:IsCasting()) then
					return v157;
				elseif (((2910 + 1179) == (4479 - (14 + 376))) and v14:IsCasting(v100.ElementalBlast)) then
					return v157 - (130 - 55);
				elseif (((2885 + 1573) >= (1471 + 203)) and v14:IsCasting(v100.Icefury)) then
					return v157 + 24 + 1;
				elseif (((2848 - 1876) <= (1067 + 351)) and v14:IsCasting(v100.LightningBolt)) then
					return v157 + (88 - (23 + 55));
				elseif (v14:IsCasting(v100.LavaBurst) or ((11702 - 6764) < (3178 + 1584))) then
					return v157 + 11 + 1;
				elseif (v14:IsCasting(v100.ChainLightning) or ((3881 - 1377) > (1342 + 2922))) then
					return v157 + ((905 - (652 + 249)) * v114);
				else
					return v157;
				end
				break;
			end
		end
	end
	local function v126(v158)
		local v159 = v158:IsReady();
		if (((5761 - 3608) == (4021 - (708 + 1160))) and ((v158 == v100.Stormkeeper) or (v158 == v100.ElementalBlast) or (v158 == v100.Icefury))) then
			local v180 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or not v14:IsMoving();
			return v159 and v180 and not v14:IsCasting(v158);
		elseif ((v158 == v100.LavaBeam) or ((1376 - 869) >= (4723 - 2132))) then
			local v244 = 27 - (10 + 17);
			local v245;
			while true do
				if (((1007 + 3474) == (6213 - (1400 + 332))) and (v244 == (0 - 0))) then
					v245 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or not v14:IsMoving();
					return v159 and v245;
				end
			end
		elseif ((v158 == v100.LightningBolt) or (v158 == v100.ChainLightning) or ((4236 - (242 + 1666)) < (297 + 396))) then
			local v257 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or v14:BuffUp(v100.StormkeeperBuff) or not v14:IsMoving();
			return v159 and v257;
		elseif (((1587 + 2741) == (3689 + 639)) and (v158 == v100.LavaBurst)) then
			local v260 = 940 - (850 + 90);
			local v261;
			local v262;
			local v263;
			local v264;
			while true do
				if (((2781 - 1193) >= (2722 - (360 + 1030))) and (v260 == (2 + 0))) then
					return v159 and v261 and (v262 or v263 or v264);
				end
				if ((v260 == (0 - 0)) or ((5742 - 1568) > (5909 - (909 + 752)))) then
					v261 = v14:BuffUp(v100.SpiritwalkersGraceBuff) or v14:BuffUp(v100.LavaSurgeBuff) or not v14:IsMoving();
					v262 = v14:BuffUp(v100.LavaSurgeBuff);
					v260 = 1224 - (109 + 1114);
				end
				if ((v260 == (1 - 0)) or ((1786 + 2800) <= (324 - (6 + 236)))) then
					v263 = (v100.LavaBurst:Charges() >= (1 + 0)) and not v14:IsCasting(v100.LavaBurst);
					v264 = (v100.LavaBurst:Charges() == (2 + 0)) and v14:IsCasting(v100.LavaBurst);
					v260 = 4 - 2;
				end
			end
		elseif (((6747 - 2884) == (4996 - (1076 + 57))) and (v158 == v100.PrimordialWave)) then
			return v159 and v34 and v14:BuffDown(v100.PrimordialWaveBuff) and v14:BuffDown(v100.LavaSurgeBuff);
		else
			return v159;
		end
	end
	local function v127()
		local v160 = 0 + 0;
		local v161;
		while true do
			if ((v160 == (690 - (579 + 110))) or ((23 + 259) <= (38 + 4))) then
				if (((2447 + 2162) >= (1173 - (174 + 233))) and not v14:IsCasting()) then
					return v161;
				elseif (v14:IsCasting(v105.LavaBurst) or ((3217 - 2065) == (4366 - 1878))) then
					return true;
				elseif (((1522 + 1900) > (4524 - (663 + 511))) and (v14:IsCasting(v105.ElementalBlast) or v14:IsCasting(v100.Icefury) or v14:IsCasting(v100.LightningBolt) or v14:IsCasting(v100.ChainLightning))) then
					return false;
				else
					return v161;
				end
				break;
			end
			if (((783 + 94) > (82 + 294)) and (v160 == (0 - 0))) then
				if (not v100.MasteroftheElements:IsAvailable() or ((1889 + 1229) <= (4357 - 2506))) then
					return false;
				end
				v161 = v14:BuffUp(v100.MasteroftheElementsBuff);
				v160 = 2 - 1;
			end
		end
	end
	local function v128()
		if (not v100.PoweroftheMaelstrom:IsAvailable() or ((79 + 86) >= (6796 - 3304))) then
			return false;
		end
		local v162 = v14:BuffStack(v100.PoweroftheMaelstromBuff);
		if (((2815 + 1134) < (444 + 4412)) and not v14:IsCasting()) then
			return v162 > (722 - (478 + 244));
		elseif (((v162 == (518 - (440 + 77))) and (v14:IsCasting(v100.LightningBolt) or v14:IsCasting(v100.ChainLightning))) or ((1945 + 2331) < (11038 - 8022))) then
			return false;
		else
			return v162 > (1556 - (655 + 901));
		end
	end
	local function v129()
		local v163 = 0 + 0;
		local v164;
		while true do
			if (((3591 + 1099) > (2786 + 1339)) and (v163 == (0 - 0))) then
				if (not v100.Stormkeeper:IsAvailable() or ((1495 - (695 + 750)) >= (3059 - 2163))) then
					return false;
				end
				v164 = v14:BuffUp(v100.StormkeeperBuff);
				v163 = 1 - 0;
			end
			if ((v163 == (3 - 2)) or ((2065 - (285 + 66)) >= (6895 - 3937))) then
				if (not v14:IsCasting() or ((2801 - (682 + 628)) < (104 + 540))) then
					return v164;
				elseif (((1003 - (176 + 123)) < (413 + 574)) and v14:IsCasting(v100.Stormkeeper)) then
					return true;
				else
					return v164;
				end
				break;
			end
		end
	end
	local function v130()
		local v165 = 0 + 0;
		local v166;
		while true do
			if (((3987 - (239 + 30)) > (519 + 1387)) and ((1 + 0) == v165)) then
				if (not v14:IsCasting() or ((1695 - 737) > (11340 - 7705))) then
					return v166;
				elseif (((3816 - (306 + 9)) <= (15675 - 11183)) and v14:IsCasting(v100.Icefury)) then
					return true;
				else
					return v166;
				end
				break;
			end
			if ((v165 == (0 + 0)) or ((2112 + 1330) < (1227 + 1321))) then
				if (((8221 - 5346) >= (2839 - (1140 + 235))) and not v100.Icefury:IsAvailable()) then
					return false;
				end
				v166 = v14:BuffUp(v100.IcefuryBuff);
				v165 = 1 + 0;
			end
		end
	end
	local function v131()
		if ((v100.CleanseSpirit:IsReady() and v36 and v104.DispellableFriendlyUnit(23 + 2)) or ((1232 + 3565) >= (4945 - (33 + 19)))) then
			if (v25(v102.CleanseSpiritFocus) or ((199 + 352) > (6198 - 4130))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v132()
		if (((932 + 1182) > (1851 - 907)) and v98 and (v14:HealthPercentage() <= v99)) then
			if (v100.HealingSurge:IsReady() or ((2122 + 140) >= (3785 - (586 + 103)))) then
				if (v25(v100.HealingSurge) or ((206 + 2049) >= (10888 - 7351))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v133()
		if ((v100.AstralShift:IsReady() and v72 and (v14:HealthPercentage() <= v78)) or ((5325 - (1309 + 179)) < (2357 - 1051))) then
			if (((1284 + 1666) == (7922 - 4972)) and v25(v100.AstralShift)) then
				return "astral_shift defensive 1";
			end
		end
		if ((v100.AncestralGuidance:IsReady() and v71 and v104.AreUnitsBelowHealthPercentage(v76, v77)) or ((3568 + 1155) < (7006 - 3708))) then
			if (((2263 - 1127) >= (763 - (295 + 314))) and v25(v100.AncestralGuidance)) then
				return "ancestral_guidance defensive 2";
			end
		end
		if ((v100.HealingStreamTotem:IsReady() and v73 and v104.AreUnitsBelowHealthPercentage(v79, v80)) or ((665 - 394) > (6710 - (1300 + 662)))) then
			if (((14884 - 10144) >= (4907 - (1178 + 577))) and v25(v100.HealingStreamTotem)) then
				return "healing_stream_totem defensive 3";
			end
		end
		if ((v101.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) or ((1339 + 1239) >= (10021 - 6631))) then
			if (((1446 - (851 + 554)) <= (1469 + 192)) and v25(v102.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if (((1666 - 1065) < (7731 - 4171)) and v92 and (v14:HealthPercentage() <= v94)) then
			if (((537 - (115 + 187)) < (527 + 160)) and (v96 == "Refreshing Healing Potion")) then
				if (((4307 + 242) > (4543 - 3390)) and v101.RefreshingHealingPotion:IsReady()) then
					if (v25(v102.RefreshingHealingPotion) or ((5835 - (160 + 1001)) < (4088 + 584))) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
			if (((2531 + 1137) < (9336 - 4775)) and (v96 == "Dreamwalker's Healing Potion")) then
				if (v101.DreamwalkersHealingPotion:IsReady() or ((813 - (237 + 121)) == (4502 - (525 + 372)))) then
					if (v25(v102.RefreshingHealingPotion) or ((5048 - 2385) == (10881 - 7569))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v134()
		local v167 = 142 - (96 + 46);
		while true do
			if (((5054 - (643 + 134)) <= (1616 + 2859)) and (v167 == (2 - 1))) then
				v31 = v104.HandleBottomTrinket(v103, v34, 148 - 108, nil);
				if (v31 or ((835 + 35) == (2332 - 1143))) then
					return v31;
				end
				break;
			end
			if (((3174 - 1621) <= (3852 - (316 + 403))) and (v167 == (0 + 0))) then
				v31 = v104.HandleTopTrinket(v103, v34, 109 - 69, nil);
				if (v31 or ((809 + 1428) >= (8841 - 5330))) then
					return v31;
				end
				v167 = 1 + 0;
			end
		end
	end
	local function v135()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (6 - 4)) or ((6323 - 4999) > (6273 - 3253))) then
				if ((v14:IsCasting(v100.ElementalBlast) and v41 and not v100.PrimordialWave:IsAvailable() and v100.FlameShock:IsViable()) or ((172 + 2820) == (3702 - 1821))) then
					if (((152 + 2954) > (4489 - 2963)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if (((3040 - (12 + 5)) < (15031 - 11161)) and v126(v100.LavaBurst) and v45 and not v14:IsCasting(v100.LavaBurst) and (not v100.ElementalBlast:IsAvailable() or (v100.ElementalBlast:IsAvailable() and not v100.ElementalBlast:IsAvailable()))) then
					if (((304 - 161) > (156 - 82)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v168 = 7 - 4;
			end
			if (((4 + 14) < (4085 - (1656 + 317))) and (v168 == (0 + 0))) then
				if (((880 + 217) <= (4328 - 2700)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108)) then
					if (((4984 - (5 + 349)) == (21991 - 17361)) and v25(v100.Stormkeeper)) then
						return "stormkeeper precombat 2";
					end
				end
				if (((4811 - (266 + 1005)) > (1769 + 914)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v43) then
					if (((6310 - 1516) >= (4971 - (561 + 1135))) and v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury))) then
						return "icefury precombat 4";
					end
				end
				v168 = 1 - 0;
			end
			if (((4877 - 3393) == (2550 - (507 + 559))) and (v168 == (2 - 1))) then
				if (((4428 - 2996) < (3943 - (212 + 176))) and v126(v100.ElementalBlast) and v40) then
					if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((1970 - (250 + 655)) > (9756 - 6178))) then
						return "elemental_blast precombat 6";
					end
				end
				if ((v14:IsCasting(v100.ElementalBlast) and v48 and ((v65 and v35) or not v65) and v126(v100.PrimordialWave)) or ((8378 - 3583) < (2201 - 794))) then
					if (((3809 - (1869 + 87)) < (16693 - 11880)) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 8";
					end
				end
				v168 = 1903 - (484 + 1417);
			end
			if ((v168 == (6 - 3)) or ((4727 - 1906) < (3204 - (48 + 725)))) then
				if ((v14:IsCasting(v100.LavaBurst) and v41 and v100.FlameShock:IsReady()) or ((4694 - 1820) < (5851 - 3670))) then
					if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((1563 + 1126) <= (916 - 573))) then
						return "flameshock precombat 14";
					end
				end
				if ((v14:IsCasting(v100.LavaBurst) and v48 and ((v65 and v35) or not v65) and v126(v100.PrimordialWave)) or ((524 + 1345) == (586 + 1423))) then
					if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((4399 - (152 + 701)) < (3633 - (430 + 881)))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
		end
	end
	local function v136()
		local v169 = 0 + 0;
		while true do
			if ((v169 == (895 - (557 + 338))) or ((616 + 1466) == (13450 - 8677))) then
				if (((11359 - 8115) > (2802 - 1747)) and v100.FireElemental:IsReady() and v54 and ((v60 and v34) or not v60) and (v91 < v108)) then
					if (v25(v100.FireElemental) or ((7139 - 3826) <= (2579 - (499 + 302)))) then
						return "fire_elemental aoe 2";
					end
				end
				if ((v100.StormElemental:IsReady() and v56 and ((v61 and v34) or not v61) and (v91 < v108)) or ((2287 - (39 + 827)) >= (5808 - 3704))) then
					if (((4046 - 2234) <= (12904 - 9655)) and v25(v100.StormElemental)) then
						return "storm_elemental aoe 4";
					end
				end
				if (((2490 - 867) <= (168 + 1789)) and v126(v100.Stormkeeper) and not v129() and v49 and ((v66 and v35) or not v66) and (v91 < v108)) then
					if (((12913 - 8501) == (706 + 3706)) and v25(v100.Stormkeeper)) then
						return "stormkeeper aoe 7";
					end
				end
				if (((2769 - 1019) >= (946 - (103 + 1))) and v100.TotemicRecall:IsCastable() and (v100.LiquidMagmaTotem:CooldownRemains() > (599 - (475 + 79))) and v50) then
					if (((9451 - 5079) > (5920 - 4070)) and v25(v100.TotemicRecall)) then
						return "totemic_recall aoe 8";
					end
				end
				v169 = 1 + 0;
			end
			if (((205 + 27) < (2324 - (1395 + 108))) and (v169 == (8 - 5))) then
				if (((1722 - (7 + 1197)) < (394 + 508)) and v38 and v100.Earthquake:IsReady() and v127() and (((v14:BuffStack(v100.MagmaChamberBuff) > (6 + 9)) and (v114 >= ((326 - (27 + 292)) - v26(v100.UnrelentingCalamity:IsAvailable())))) or (v100.SplinteredElements:IsAvailable() and (v114 >= ((29 - 19) - v26(v100.UnrelentingCalamity:IsAvailable())))) or (v100.MountainsWillFall:IsAvailable() and (v114 >= (10 - 1)))) and not v100.LightningRod:IsAvailable() and v14:HasTier(129 - 98, 7 - 3)) then
					local v246 = 0 - 0;
					while true do
						if (((3133 - (43 + 96)) > (3499 - 2641)) and ((0 - 0) == v246)) then
							if ((v52 == "cursor") or ((3116 + 639) <= (259 + 656))) then
								if (((7798 - 3852) > (1435 + 2308)) and v25(v102.EarthquakeCursor, not v17:IsInRange(74 - 34))) then
									return "earthquake aoe 36";
								end
							end
							if ((v52 == "player") or ((421 + 914) >= (243 + 3063))) then
								if (((6595 - (1414 + 337)) > (4193 - (1642 + 298))) and v25(v102.EarthquakePlayer, not v17:IsInRange(104 - 64))) then
									return "earthquake aoe 36";
								end
							end
							break;
						end
					end
				end
				if (((1300 - 848) == (1341 - 889)) and v126(v100.LavaBeam) and v44 and v129() and ((v14:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (2 + 4))) or (v127() and ((v114 < (5 + 1)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v14:HasTier(1003 - (357 + 615), 3 + 1)) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((11181 - 6624) < (1789 + 298))) then
						return "lava_beam aoe 38";
					end
				end
				if (((8301 - 4427) == (3099 + 775)) and v126(v100.ChainLightning) and v37 and v129() and ((v14:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (1 + 5))) or (v127() and ((v114 < (4 + 2)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v14:HasTier(1332 - (384 + 917), 701 - (128 + 569))) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((3481 - (1407 + 136)) > (6822 - (687 + 1200)))) then
						return "chain_lightning aoe 40";
					end
				end
				if ((v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and not v100.LightningRod:IsAvailable() and v14:HasTier(1741 - (556 + 1154), 14 - 10)) or ((4350 - (9 + 86)) < (3844 - (275 + 146)))) then
					if (((237 + 1217) <= (2555 - (29 + 35))) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 42";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((18423 - 14266) <= (8372 - 5569))) then
						return "lava_burst aoe 42";
					end
				end
				v169 = 17 - 13;
			end
			if (((3161 + 1692) >= (3994 - (53 + 959))) and (v169 == (415 - (312 + 96)))) then
				if (((7174 - 3040) > (3642 - (147 + 138))) and v126(v100.LavaBeam) and v44 and (v129())) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((4316 - (813 + 86)) < (2290 + 244))) then
						return "lava_beam aoe 68";
					end
				end
				if ((v126(v100.ChainLightning) and v37 and (v129())) or ((5042 - 2320) <= (656 - (18 + 474)))) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((813 + 1595) < (6883 - 4774))) then
						return "chain_lightning aoe 70";
					end
				end
				if ((v126(v100.LavaBeam) and v44 and v128() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((1119 - (860 + 226)) == (1758 - (121 + 182)))) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((55 + 388) >= (5255 - (988 + 252)))) then
						return "lava_beam aoe 72";
					end
				end
				if (((383 + 2999) > (52 + 114)) and v126(v100.ChainLightning) and v37 and v128()) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((2250 - (49 + 1921)) == (3949 - (223 + 667)))) then
						return "chain_lightning aoe 74";
					end
				end
				v169 = 60 - (51 + 1);
			end
			if (((3237 - 1356) > (2768 - 1475)) and ((1131 - (146 + 979)) == v169)) then
				if (((666 + 1691) == (2962 - (311 + 294))) and v126(v100.EarthShock) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
					if (((342 - 219) == (53 + 70)) and v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock))) then
						return "earth_shock aoe 60";
					end
				end
				if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (1443 - (496 + 947))) and v43 and not v14:BuffUp(v100.AscendanceBuff) and v100.ElectrifiedShocks:IsAvailable() and ((v100.LightningRod:IsAvailable() and (v114 < (1363 - (1233 + 125))) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (2 + 1))))) or ((948 + 108) >= (645 + 2747))) then
					if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((2726 - (963 + 682)) < (898 + 177))) then
						return "icefury aoe 62";
					end
				end
				if ((v126(v100.FrostShock) and v42 and not v14:BuffUp(v100.AscendanceBuff) and v14:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and (not v17:DebuffUp(v100.ElectrifiedShocksDebuff) or (v14:BuffRemains(v100.IcefuryBuff) < v14:GCD())) and ((v100.LightningRod:IsAvailable() and (v114 < (1509 - (504 + 1000))) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (3 + 0))))) or ((956 + 93) >= (419 + 4013))) then
					if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((7030 - 2262) <= (723 + 123))) then
						return "frost_shock aoe 64";
					end
				end
				if ((v126(v100.LavaBurst) and v100.MasteroftheElements:IsAvailable() and not v127() and (v129() or ((v118() < (2 + 1)) and v14:HasTier(212 - (156 + 26), 2 + 0))) and (v125() < ((((93 - 33) - ((169 - (149 + 15)) * v100.EyeoftheStorm:TalentRank())) - ((962 - (890 + 70)) * v26(v100.FlowofPower:IsAvailable()))) - (127 - (39 + 78)))) and (v114 < (487 - (14 + 468)))) or ((7384 - 4026) <= (3968 - 2548))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((1930 + 1809) <= (1805 + 1200))) then
						return "lava_burst aoe 66";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((353 + 1306) >= (964 + 1170))) then
						return "lava_burst aoe 66";
					end
				end
				v169 = 2 + 5;
			end
			if ((v169 == (9 - 4)) or ((3223 + 37) < (8275 - 5920))) then
				if ((v126(v100.ElementalBlast) and v40 and v100.EchoesofGreatSundering:IsAvailable()) or ((17 + 652) == (4274 - (12 + 39)))) then
					if (v104.CastTargetIf(v100.ElementalBlast, v112, "min", v124, nil, not v17:IsSpellInRange(v100.ElementalBlast), nil, nil) or ((1575 + 117) < (1819 - 1231))) then
						return "elemental_blast aoe 52";
					end
					if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((17084 - 12287) < (1083 + 2568))) then
						return "elemental_blast aoe 52";
					end
				end
				if ((v126(v100.ElementalBlast) and v40 and v100.EchoesofGreatSundering:IsAvailable()) or ((2199 + 1978) > (12298 - 7448))) then
					if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((267 + 133) > (5369 - 4258))) then
						return "elemental_blast aoe 54";
					end
				end
				if (((4761 - (1596 + 114)) > (2623 - 1618)) and v126(v100.ElementalBlast) and v40 and (v114 == (716 - (164 + 549))) and not v100.EchoesofGreatSundering:IsAvailable()) then
					if (((5131 - (1059 + 379)) <= (5440 - 1058)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast aoe 56";
					end
				end
				if ((v126(v100.EarthShock) and v39 and v100.EchoesofGreatSundering:IsAvailable()) or ((1701 + 1581) > (692 + 3408))) then
					local v247 = 392 - (145 + 247);
					while true do
						if ((v247 == (0 + 0)) or ((1655 + 1925) < (8431 - 5587))) then
							if (((18 + 71) < (3868 + 622)) and v104.CastTargetIf(v100.EarthShock, v112, "min", v124, nil, not v17:IsSpellInRange(v100.EarthShock), nil, nil)) then
								return "earth_shock aoe 58";
							end
							if (v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock)) or ((8090 - 3107) < (2528 - (254 + 466)))) then
								return "earth_shock aoe 58";
							end
							break;
						end
					end
				end
				v169 = 566 - (544 + 16);
			end
			if (((12168 - 8339) > (4397 - (294 + 334))) and (v169 == (262 - (236 + 17)))) then
				if (((641 + 844) <= (2261 + 643)) and v126(v100.LavaBurst) and (v114 == (10 - 7)) and v100.MasteroftheElements:IsAvailable()) then
					local v248 = 0 - 0;
					while true do
						if (((2198 + 2071) == (3517 + 752)) and (v248 == (794 - (413 + 381)))) then
							if (((17 + 370) <= (5916 - 3134)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 84";
							end
							if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((4932 - 3033) <= (2887 - (582 + 1388)))) then
								return "lava_burst aoe 84";
							end
							break;
						end
					end
				end
				if ((v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable()) or ((7346 - 3034) <= (628 + 248))) then
					if (((2596 - (326 + 38)) <= (7679 - 5083)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 86";
					end
					if (((2990 - 895) < (4306 - (47 + 573))) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 86";
					end
				end
				if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 + 0)) and v43 and v100.ElectrifiedShocks:IsAvailable() and (v114 < (21 - 16))) or ((2588 - 993) >= (6138 - (1269 + 395)))) then
					if (v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury)) or ((5111 - (76 + 416)) < (3325 - (319 + 124)))) then
						return "icefury aoe 88";
					end
				end
				if ((v126(v100.FrostShock) and v42 and v14:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and not v17:DebuffUp(v100.ElectrifiedShocksDebuff) and (v114 < (11 - 6)) and v100.UnrelentingCalamity:IsAvailable()) or ((1301 - (564 + 443)) >= (13374 - 8543))) then
					if (((2487 - (337 + 121)) <= (9035 - 5951)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock aoe 90";
					end
				end
				v169 = 33 - 23;
			end
			if ((v169 == (1915 - (1261 + 650))) or ((862 + 1175) == (3856 - 1436))) then
				if (((6275 - (772 + 1045)) > (551 + 3353)) and v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and v100.MasteroftheElements:IsAvailable() and not v127() and (v125() >= (((204 - (102 + 42)) - ((1849 - (1524 + 320)) * v100.EyeoftheStorm:TalentRank())) - ((1272 - (1049 + 221)) * v26(v100.FlowofPower:IsAvailable())))) and ((not v100.EchoesofGreatSundering:IsAvailable() and not v100.LightningRod:IsAvailable()) or v14:BuffUp(v100.EchoesofGreatSunderingBuff)) and ((not v14:BuffUp(v100.AscendanceBuff) and (v114 > (159 - (18 + 138))) and v100.UnrelentingCalamity:IsAvailable()) or ((v114 > (7 - 4)) and not v100.UnrelentingCalamity:IsAvailable()) or (v114 == (1105 - (67 + 1035))))) then
					if (((784 - (136 + 212)) >= (522 - 399)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 44";
					end
					if (((401 + 99) < (1675 + 141)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 44";
					end
				end
				if (((5178 - (240 + 1364)) == (4656 - (1050 + 32))) and v38 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and (v114 > (10 - 7)) and ((v114 > (2 + 1)) or (v113 > (1058 - (331 + 724))))) then
					local v249 = 0 + 0;
					while true do
						if (((865 - (269 + 375)) < (1115 - (267 + 458))) and (v249 == (0 + 0))) then
							if ((v52 == "cursor") or ((4255 - 2042) <= (2239 - (667 + 151)))) then
								if (((4555 - (1410 + 87)) < (6757 - (1504 + 393))) and v25(v102.EarthquakeCursor, not v17:IsInRange(108 - 68))) then
									return "earthquake aoe 46";
								end
							end
							if ((v52 == "player") or ((3362 - 2066) >= (5242 - (461 + 335)))) then
								if (v25(v102.EarthquakePlayer, not v17:IsInRange(6 + 34)) or ((3154 - (1730 + 31)) > (6156 - (728 + 939)))) then
									return "earthquake aoe 46";
								end
							end
							break;
						end
					end
				end
				if ((v38 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v114 == (10 - 7)) and ((v114 == (5 - 2)) or (v113 == (6 - 3)))) or ((5492 - (138 + 930)) < (25 + 2))) then
					local v250 = 0 + 0;
					while true do
						if ((v250 == (0 + 0)) or ((8154 - 6157) > (5581 - (459 + 1307)))) then
							if (((5335 - (474 + 1396)) > (3340 - 1427)) and (v52 == "cursor")) then
								if (((687 + 46) < (6 + 1813)) and v25(v102.EarthquakeCursor, not v17:IsInRange(114 - 74))) then
									return "earthquake aoe 48";
								end
							end
							if ((v52 == "player") or ((557 + 3838) == (15873 - 11118))) then
								if (v25(v102.EarthquakePlayer, not v17:IsInRange(174 - 134)) or ((4384 - (562 + 29)) < (2020 + 349))) then
									return "earthquake aoe 48";
								end
							end
							break;
						end
					end
				end
				if ((v38 and v100.Earthquake:IsReady() and (v14:BuffUp(v100.EchoesofGreatSunderingBuff))) or ((5503 - (374 + 1045)) == (210 + 55))) then
					if (((13532 - 9174) == (4996 - (448 + 190))) and (v52 == "cursor")) then
						if (v25(v102.EarthquakeCursor, not v17:IsInRange(13 + 27)) or ((1417 + 1721) < (647 + 346))) then
							return "earthquake aoe 50";
						end
					end
					if (((12803 - 9473) > (7217 - 4894)) and (v52 == "player")) then
						if (v25(v102.EarthquakePlayer, not v17:IsInRange(1534 - (1307 + 187))) or ((14379 - 10753) == (9339 - 5350))) then
							return "earthquake aoe 50";
						end
					end
				end
				v169 = 15 - 10;
			end
			if ((v169 == (685 - (232 + 451))) or ((875 + 41) == (2360 + 311))) then
				if (((836 - (510 + 54)) == (547 - 275)) and v126(v100.PrimordialWave) and v14:BuffDown(v100.PrimordialWaveBuff) and v100.MasteroftheElements:IsAvailable() and not v100.LightningRod:IsAvailable()) then
					if (((4285 - (13 + 23)) <= (9432 - 4593)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 16";
					end
					if (((3990 - 1213) < (5814 - 2614)) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave aoe 16";
					end
				end
				if (((1183 - (830 + 258)) < (6903 - 4946)) and v100.FlameShock:IsCastable()) then
					local v251 = 0 + 0;
					while true do
						if (((703 + 123) < (3158 - (860 + 581))) and (v251 == (0 - 0))) then
							if (((1132 + 294) >= (1346 - (237 + 4))) and v14:BuffUp(v100.SurgeofPowerBuff) and v41 and v100.LightningRod:IsAvailable() and v100.WindspeakersLavaResurgence:IsAvailable() and (v17:DebuffRemains(v100.FlameShockDebuff) < (v17:TimeToDie() - (37 - 21))) and (v111 < (12 - 7))) then
								if (((5221 - 2467) <= (2766 + 613)) and v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 18";
								end
								if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((2256 + 1671) == (5334 - 3921))) then
									return "flame_shock aoe 18";
								end
							end
							if ((v14:BuffUp(v100.SurgeofPowerBuff) and v41 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or ((628 + 526) <= (2214 - (85 + 1341)))) then
								local v265 = 0 - 0;
								while true do
									if ((v265 == (0 - 0)) or ((2015 - (45 + 327)) > (6375 - 2996))) then
										if (v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock)) or ((3305 - (444 + 58)) > (1977 + 2572))) then
											return "flame_shock aoe 20";
										end
										if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((38 + 182) >= (1478 + 1544))) then
											return "flame_shock aoe 20";
										end
										break;
									end
								end
							end
							v251 = 2 - 1;
						end
						if (((4554 - (64 + 1668)) == (4795 - (1227 + 746))) and (v251 == (2 - 1))) then
							if ((v100.MasteroftheElements:IsAvailable() and v41 and not v100.LightningRod:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (10 - 4))) or ((1555 - (415 + 79)) == (48 + 1809))) then
								local v266 = 491 - (142 + 349);
								while true do
									if (((1183 + 1577) > (1875 - 511)) and (v266 == (0 + 0))) then
										if (v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock)) or ((3454 + 1448) <= (9790 - 6195))) then
											return "flame_shock aoe 22";
										end
										if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((5716 - (1710 + 154)) == (611 - (200 + 118)))) then
											return "flame_shock aoe 22";
										end
										break;
									end
								end
							end
							if ((v100.DeeplyRootedElements:IsAvailable() and v41 and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or ((2725 - 1166) == (6804 - 2216))) then
								local v267 = 0 + 0;
								while true do
									if ((v267 == (0 + 0)) or ((2407 + 2077) == (126 + 662))) then
										if (((9896 - 5328) >= (5157 - (363 + 887))) and v104.CastCycle(v100.FlameShock, v112, v120, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 24";
										end
										if (((2175 - 929) < (16516 - 13046)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v251 = 1 + 1;
						end
						if (((9518 - 5450) >= (665 + 307)) and ((1667 - (674 + 990)) == v251)) then
							if (((142 + 351) < (1594 + 2299)) and v100.DeeplyRootedElements:IsAvailable() and v41 and not v100.SurgeofPower:IsAvailable()) then
								if (v104.CastCycle(v100.FlameShock, v112, v121, not v17:IsSpellInRange(v100.FlameShock)) or ((2334 - 861) >= (4387 - (507 + 548)))) then
									return "flame_shock aoe 30";
								end
								if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((4888 - (289 + 548)) <= (2975 - (821 + 997)))) then
									return "flame_shock aoe 30";
								end
							end
							break;
						end
						if (((859 - (195 + 60)) < (775 + 2106)) and ((1503 - (251 + 1250)) == v251)) then
							if ((v14:BuffUp(v100.SurgeofPowerBuff) and v41 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable())) or ((2636 - 1736) == (2321 + 1056))) then
								local v268 = 1032 - (809 + 223);
								while true do
									if (((6506 - 2047) > (1774 - 1183)) and (v268 == (0 - 0))) then
										if (((2503 + 895) >= (1255 + 1140)) and v104.CastCycle(v100.FlameShock, v112, v121, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 26";
										end
										if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((2800 - (14 + 603)) >= (2953 - (118 + 11)))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if (((314 + 1622) == (1613 + 323)) and v100.MasteroftheElements:IsAvailable() and v41 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable()) then
								local v269 = 0 - 0;
								while true do
									if ((v269 == (949 - (551 + 398))) or ((3054 + 1778) < (1535 + 2778))) then
										if (((3323 + 765) > (14407 - 10533)) and v104.CastCycle(v100.FlameShock, v112, v121, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 28";
										end
										if (((9981 - 5649) == (1405 + 2927)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 28";
										end
										break;
									end
								end
							end
							v251 = 11 - 8;
						end
					end
				end
				if (((1105 + 2894) >= (2989 - (40 + 49))) and v100.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v108)) then
					if (v25(v100.Ascendance) or ((9615 - 7090) > (4554 - (99 + 391)))) then
						return "ascendance aoe 32";
					end
				end
				if (((3616 + 755) == (19214 - 14843)) and v126(v100.LavaBurst) and (v114 == (7 - 4)) and not v100.LightningRod:IsAvailable() and v14:HasTier(31 + 0, 10 - 6)) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst)) or ((1870 - (1032 + 572)) > (5403 - (203 + 214)))) then
						return "lava_burst aoe 34";
					end
					if (((3808 - (568 + 1249)) >= (724 + 201)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 34";
					end
				end
				v169 = 6 - 3;
			end
			if (((1757 - 1302) < (3359 - (913 + 393))) and (v169 == (28 - 18))) then
				if ((v126(v100.LavaBeam) and v44 and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((1166 - 340) == (5261 - (269 + 141)))) then
					if (((406 - 223) == (2164 - (362 + 1619))) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 92";
					end
				end
				if (((2784 - (950 + 675)) <= (690 + 1098)) and v126(v100.ChainLightning) and v37) then
					if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((4686 - (216 + 963)) > (5605 - (485 + 802)))) then
						return "chain_lightning aoe 94";
					end
				end
				if ((v100.FlameShock:IsCastable() and v41 and v14:IsMoving() and v17:DebuffRefreshable(v100.FlameShockDebuff)) or ((3634 - (432 + 127)) <= (4038 - (1065 + 8)))) then
					if (((759 + 606) <= (3612 - (635 + 966))) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock aoe 96";
					end
				end
				if ((v100.FrostShock:IsCastable() and v42 and v14:IsMoving()) or ((1996 + 780) > (3617 - (5 + 37)))) then
					if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((6351 - 3797) == (1999 + 2805))) then
						return "frost_shock aoe 98";
					end
				end
				break;
			end
			if (((4078 - 1501) == (1206 + 1371)) and (v169 == (1 - 0))) then
				if ((v100.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "cursor")) or ((22 - 16) >= (3562 - 1673))) then
					if (((1209 - 703) <= (1361 + 531)) and v25(v102.LiquidMagmaTotemCursor, not v17:IsInRange(569 - (318 + 211)))) then
						return "liquid_magma_totem aoe cursor 10";
					end
				end
				if ((v100.LiquidMagmaTotem:IsReady() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and (v67 == "player")) or ((9880 - 7872) > (3805 - (963 + 624)))) then
					if (((162 + 217) <= (4993 - (518 + 328))) and v25(v102.LiquidMagmaTotemPlayer, not v17:IsInRange(93 - 53))) then
						return "liquid_magma_totem aoe player 11";
					end
				end
				if ((v126(v100.PrimordialWave) and v14:BuffDown(v100.PrimordialWaveBuff) and v14:BuffUp(v100.SurgeofPowerBuff) and v14:BuffDown(v100.SplinteredElementsBuff)) or ((7215 - 2701) <= (1326 - (301 + 16)))) then
					if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((10246 - 6750) == (3347 - 2155))) then
						return "primordial_wave aoe 12";
					end
					if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((542 - 334) == (2681 + 278))) then
						return "primordial_wave aoe 12";
					end
				end
				if (((2429 + 1848) >= (2802 - 1489)) and v126(v100.PrimordialWave) and v14:BuffDown(v100.PrimordialWaveBuff) and v100.DeeplyRootedElements:IsAvailable() and not v100.SurgeofPower:IsAvailable() and v14:BuffDown(v100.SplinteredElementsBuff)) then
					if (((1557 + 1030) < (303 + 2871)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v17:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 14";
					end
					if (v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave)) or ((13098 - 8978) <= (710 + 1488))) then
						return "primordial_wave aoe 14";
					end
				end
				v169 = 1021 - (829 + 190);
			end
			if (((28 - 20) == v169) or ((2019 - 423) == (1185 - 327))) then
				if (((7998 - 4778) == (764 + 2456)) and v126(v100.LavaBeam) and v44 and (v114 >= (2 + 4)) and v14:BuffUp(v100.SurgeofPowerBuff) and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((4255 - 2853) > (3416 + 204))) then
						return "lava_beam aoe 76";
					end
				end
				if (((3187 - (520 + 93)) == (2850 - (259 + 17))) and v126(v100.ChainLightning) and v37 and (v114 >= (1 + 5)) and v14:BuffUp(v100.SurgeofPowerBuff)) then
					if (((647 + 1151) < (9333 - 6576)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 78";
					end
				end
				if ((v126(v100.LavaBurst) and v14:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable() and v14:BuffUp(v100.WindspeakersLavaResurgenceBuff)) or ((968 - (396 + 195)) > (7555 - 4951))) then
					local v252 = 1761 - (440 + 1321);
					while true do
						if (((2397 - (1059 + 770)) < (4212 - 3301)) and (v252 == (545 - (424 + 121)))) then
							if (((599 + 2686) < (5575 - (641 + 706))) and v104.CastCycle(v100.LavaBurst, v112, v122, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							if (((1551 + 2365) > (3768 - (249 + 191))) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 80";
							end
							break;
						end
					end
				end
				if (((10890 - 8390) < (1715 + 2124)) and v126(v100.LavaBeam) and v44 and v127() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (((1954 - 1447) == (934 - (183 + 244))) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 82";
					end
				end
				v169 = 1 + 8;
			end
		end
	end
	local function v137()
		if (((970 - (434 + 296)) <= (10100 - 6935)) and v100.FireElemental:IsCastable() and v54 and ((v60 and v34) or not v60) and (v91 < v108)) then
			if (((1346 - (169 + 343)) >= (706 + 99)) and v25(v100.FireElemental)) then
				return "fire_elemental single_target 2";
			end
		end
		if ((v100.StormElemental:IsCastable() and v56 and ((v61 and v34) or not v61) and (v91 < v108)) or ((6707 - 2895) < (6797 - 4481))) then
			if (v25(v100.StormElemental) or ((2173 + 479) <= (4347 - 2814))) then
				return "storm_elemental single_target 4";
			end
		end
		if ((v100.TotemicRecall:IsCastable() and v50 and (v100.LiquidMagmaTotem:CooldownRemains() > (1168 - (651 + 472))) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or ((v113 > (1 + 0)) and (v114 > (1 + 0))))) or ((4390 - 792) < (1943 - (397 + 86)))) then
			if (v25(v100.TotemicRecall) or ((4992 - (423 + 453)) < (122 + 1070))) then
				return "totemic_recall single_target 6";
			end
		end
		if ((v100.LiquidMagmaTotem:IsCastable() and v55 and ((v62 and v34) or not v62) and (v91 < v108) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (0 + 0)) or (v17:DebuffRemains(v100.FlameShockDebuff) < (6 + 0)) or ((v113 > (1 + 0)) and (v114 > (1 + 0))))) or ((4567 - (50 + 1140)) <= (781 + 122))) then
			if (((2348 + 1628) >= (28 + 411)) and (v67 == "cursor")) then
				if (((5387 - 1635) == (2715 + 1037)) and v25(v102.LiquidMagmaTotemCursor, not v17:IsInRange(636 - (157 + 439)))) then
					return "liquid_magma_totem single_target cursor 8";
				end
			end
			if (((7034 - 2988) > (8954 - 6259)) and (v67 == "player")) then
				if (v25(v102.LiquidMagmaTotemPlayer, not v17:IsInRange(118 - 78)) or ((4463 - (782 + 136)) == (4052 - (112 + 743)))) then
					return "liquid_magma_totem single_target player 8";
				end
			end
		end
		if (((3565 - (1026 + 145)) > (65 + 308)) and v126(v100.PrimordialWave) and v100.PrimordialWave:IsCastable() and v48 and ((v65 and v35) or not v65) and not v14:BuffUp(v100.PrimordialWaveBuff) and not v14:BuffUp(v100.SplinteredElementsBuff)) then
			local v181 = 718 - (493 + 225);
			while true do
				if (((15272 - 11117) <= (2575 + 1657)) and (v181 == (0 - 0))) then
					if (v104.CastCycle(v100.PrimordialWave, v112, v122, not v17:IsSpellInRange(v100.PrimordialWave)) or ((69 + 3512) == (9924 - 6451))) then
						return "primordial_wave single_target 10";
					end
					if (((1455 + 3540) > (5593 - 2245)) and v25(v100.PrimordialWave, not v17:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave single_target 10";
					end
					break;
				end
			end
		end
		if ((v100.FlameShock:IsCastable() and v41 and (v113 == (1596 - (210 + 1385))) and v17:DebuffRefreshable(v100.FlameShockDebuff) and ((v17:DebuffRemains(v100.FlameShockDebuff) < v100.PrimordialWave:CooldownRemains()) or not v100.PrimordialWave:IsAvailable()) and v14:BuffDown(v100.SurgeofPowerBuff) and (not v127() or (not v129() and ((v100.ElementalBlast:IsAvailable() and (v125() < ((1779 - (1201 + 488)) - ((5 + 3) * v100.EyeoftheStorm:TalentRank())))) or (v125() < ((106 - 46) - ((8 - 3) * v100.EyeoftheStorm:TalentRank()))))))) or ((1339 - (352 + 233)) > (8999 - 5275))) then
			if (((119 + 98) >= (162 - 105)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v100.FlameShock:IsCastable() and v41 and (v100.FlameShockDebuff:AuraActiveCount() == (574 - (489 + 85))) and (v113 > (1502 - (277 + 1224))) and (v114 > (1494 - (663 + 830))) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((not v127() and (v129() or (v100.Stormkeeper:CooldownRemains() > (0 + 0)))) or not v100.SurgeofPower:IsAvailable())) or ((5068 - 2998) >= (4912 - (461 + 414)))) then
			if (((454 + 2251) == (1083 + 1622)) and v104.CastTargetIf(v100.FlameShock, v112, "min", v122, nil, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 14";
			end
			if (((6 + 55) == (61 + 0)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 14";
			end
		end
		if ((v100.FlameShock:IsCastable() and v41 and (v113 > (251 - (172 + 78))) and (v114 > (1 - 0)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((v14:BuffUp(v100.SurgeofPowerBuff) and not v129() and v100.Stormkeeper:IsAvailable()) or not v100.SurgeofPower:IsAvailable())) or ((258 + 441) >= (1870 - 574))) then
			local v182 = 0 + 0;
			while true do
				if ((v182 == (0 + 0)) or ((2986 - 1203) >= (4551 - 935))) then
					if (v104.CastTargetIf(v100.FlameShock, v112, "min", v122, v119, not v17:IsSpellInRange(v100.FlameShock)) or ((984 + 2929) > (2504 + 2023))) then
						return "flame_shock single_target 16";
					end
					if (((1558 + 2818) > (3252 - 2435)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 16";
					end
					break;
				end
			end
		end
		if (((11325 - 6464) > (253 + 571)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 + 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v129() and (v125() >= (563 - (133 + 314))) and v100.ElementalBlast:IsAvailable() and v100.SurgeofPower:IsAvailable() and v100.SwellingMaelstrom:IsAvailable() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
			if (v25(v100.Stormkeeper) or ((241 + 1142) >= (2344 - (199 + 14)))) then
				return "stormkeeper single_target 18";
			end
		end
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v129() and v14:BuffUp(v100.SurgeofPowerBuff) and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) or ((3425 - (647 + 902)) >= (7640 - 5099))) then
			if (((2015 - (85 + 148)) <= (5061 - (426 + 863))) and v25(v100.Stormkeeper)) then
				return "stormkeeper single_target 20";
			end
		end
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v14:BuffUp(v100.StormkeeperBuff) and v49 and ((v66 and v35) or not v66) and (v91 < v108) and v14:BuffDown(v100.AscendanceBuff) and not v129() and (not v100.SurgeofPower:IsAvailable() or not v100.ElementalBlast:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.EchooftheElements:IsAvailable() or v100.PrimordialSurge:IsAvailable())) or ((6354 - (873 + 781)) < (1088 - 275))) then
			if (((8639 - 5440) < (1678 + 2372)) and v25(v100.Stormkeeper)) then
				return "stormkeeper single_target 22";
			end
		end
		if ((v100.Ascendance:IsCastable() and v53 and ((v59 and v34) or not v59) and (v91 < v108) and not v129()) or ((18290 - 13339) < (6349 - 1919))) then
			if (((284 - 188) == (2043 - (414 + 1533))) and v25(v100.Ascendance)) then
				return "ascendance single_target 24";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v129() and v14:BuffUp(v100.SurgeofPowerBuff)) or ((2375 + 364) > (4563 - (443 + 112)))) then
			if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((1502 - (888 + 591)) == (2930 - 1796))) then
				return "lightning_bolt single_target 26";
			end
		end
		if ((v126(v100.LavaBeam) and v44 and (v113 > (1 + 0)) and (v114 > (3 - 2)) and v129() and not v100.SurgeofPower:IsAvailable()) or ((1052 + 1641) >= (1989 + 2122))) then
			if (v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam)) or ((462 + 3854) <= (4089 - 1943))) then
				return "lava_beam single_target 28";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and (v113 > (1 - 0)) and (v114 > (1679 - (136 + 1542))) and v129() and not v100.SurgeofPower:IsAvailable()) or ((11627 - 8081) <= (2788 + 21))) then
			if (((7797 - 2893) > (1568 + 598)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 30";
			end
		end
		if (((595 - (68 + 418)) >= (243 - 153)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v129() and not v127() and not v100.SurgeofPower:IsAvailable() and v100.MasteroftheElements:IsAvailable()) then
			if (((9031 - 4053) > (2508 + 397)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 32";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v129() and not v100.SurgeofPower:IsAvailable() and v127()) or ((4118 - (770 + 322)) <= (132 + 2148))) then
			if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((479 + 1174) <= (152 + 956))) then
				return "lightning_bolt single_target 34";
			end
		end
		if (((4161 - 1252) > (5058 - 2449)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v129() and not v100.SurgeofPower:IsAvailable() and not v100.MasteroftheElements:IsAvailable()) then
			if (((2061 - 1304) > (713 - 519)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 36";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v14:BuffUp(v100.SurgeofPowerBuff) and v100.LightningRod:IsAvailable()) or ((18 + 13) >= (2094 - 696))) then
			if (((1534 + 1662) <= (2987 + 1885)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 38";
			end
		end
		if (((2607 + 719) == (12524 - 9198)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v43 and v100.ElectrifiedShocks:IsAvailable() and v100.LightningRod:IsAvailable() and v100.LightningRod:IsAvailable()) then
			if (((485 + 948) <= (17863 - 13985)) and v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 40";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v100.ElectrifiedShocks:IsAvailable() and ((v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < (6 - 4)) or (v14:BuffRemains(v100.IcefuryBuff) <= v14:GCD())) and v100.LightningRod:IsAvailable()) or ((652 + 931) == (8585 - 6850))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((3812 - (762 + 69)) == (7609 - 5259))) then
				return "frost_shock single_target 42";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v100.ElectrifiedShocks:IsAvailable() and (v125() >= (44 + 6)) and (v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < ((2 + 0) * v14:GCD())) and v129() and v100.LightningRod:IsAvailable()) or ((10801 - 6335) <= (156 + 337))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((41 + 2506) <= (7741 - 5754))) then
				return "frost_shock single_target 44";
			end
		end
		if (((3118 - (8 + 149)) > (4060 - (1199 + 121))) and v100.LavaBeam:IsCastable() and v44 and (v113 > (1 - 0)) and (v114 > (2 - 1)) and v128() and (v14:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime()) and not v14:HasTier(13 + 18, 13 - 9)) then
			if (((8576 - 4880) >= (3196 + 416)) and v25(v100.LavaBeam, not v17:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam single_target 46";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and v129() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable() and v100.ElementalBlast:IsAvailable() and (((v125() >= (1868 - (518 + 1289))) and (v125() < (128 - 53)) and (v100.LavaBurst:CooldownRemains() > v14:GCD())) or ((v125() >= (7 + 42)) and (v125() < (91 - 28)) and (v100.LavaBurst:CooldownRemains() > (0 + 0))))) or ((3439 - (304 + 165)) == (1773 + 105))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((3853 - (54 + 106)) < (3946 - (1618 + 351)))) then
				return "frost_shock single_target 48";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (((v125() >= (26 + 10)) and (v125() < (1066 - (10 + 1006))) and (v100.LavaBurst:CooldownRemains() > v14:GCD())) or ((v125() >= (7 + 17)) and (v125() < (6 + 32)) and (v100.LavaBurst:CooldownRemains() > (0 - 0))))) or ((1963 - (912 + 121)) > (993 + 1108))) then
			if (((5442 - (1140 + 149)) > (1975 + 1111)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffUp(v100.WindspeakersLavaResurgenceBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or ((v125() >= (83 - 20)) and v100.MasteroftheElements:IsAvailable()) or ((v125() >= (8 + 30)) and v14:BuffUp(v100.EchoesofGreatSunderingBuff) and (v113 > (3 - 2)) and (v114 > (1 - 0))) or not v100.ElementalBlast:IsAvailable())) or ((803 + 3851) <= (14054 - 10004))) then
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((2788 - (165 + 21)) < (1607 - (61 + 50)))) then
				return "lava_burst single_target 52";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffUp(v100.LavaSurgeBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or not v100.ElementalBlast:IsAvailable())) or ((421 + 599) > (10905 - 8617))) then
			if (((660 - 332) == (129 + 199)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 54";
			end
		end
		if (((2971 - (1295 + 165)) < (869 + 2939)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffUp(v100.AscendanceBuff) and (v14:HasTier(13 + 18, 1401 - (819 + 578)) or not v100.ElementalBlast:IsAvailable())) then
			local v183 = 1402 - (331 + 1071);
			while true do
				if ((v183 == (743 - (588 + 155))) or ((3792 - (546 + 736)) > (6856 - (1834 + 103)))) then
					if (((2930 + 1833) == (14208 - 9445)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					if (((5903 - (1536 + 230)) > (2339 - (128 + 363))) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					break;
				end
			end
		end
		if (((518 + 1918) <= (7796 - 4662)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v14:BuffDown(v100.AscendanceBuff) and (not v100.ElementalBlast:IsAvailable() or not v100.MountainsWillFall:IsAvailable()) and not v100.LightningRod:IsAvailable() and v14:HasTier(9 + 22, 6 - 2)) then
			local v184 = 0 - 0;
			while true do
				if (((9042 - 5319) == (2555 + 1168)) and (v184 == (1009 - (615 + 394)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst)) or ((3653 + 393) >= (4114 + 202))) then
						return "lava_burst single_target 58";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((6121 - 4113) < (8749 - 6820))) then
						return "lava_burst single_target 58";
					end
					break;
				end
			end
		end
		if (((3035 - (59 + 592)) > (3929 - 2154)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v100.MasteroftheElements:IsAvailable() and not v127() and not v100.LightningRod:IsAvailable()) then
			local v185 = 0 - 0;
			while true do
				if ((v185 == (0 + 0)) or ((4714 - (70 + 101)) <= (10817 - 6441))) then
					if (((517 + 211) == (1828 - 1100)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 60";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((1317 - (123 + 118)) > (1131 + 3540))) then
						return "lava_burst single_target 60";
					end
					break;
				end
			end
		end
		if (((24 + 1827) >= (1777 - (653 + 746))) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and v100.MasteroftheElements:IsAvailable() and not v127() and ((v125() >= (139 - 64)) or ((v125() >= (72 - 22)) and not v100.ElementalBlast:IsAvailable())) and v100.SwellingMaelstrom:IsAvailable() and (v125() <= (348 - 218))) then
			if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((860 + 1088) >= (2224 + 1252))) then
				return "lava_burst single_target 62";
			end
		end
		if (((4188 + 606) >= (103 + 730)) and v100.Earthquake:IsReady() and v38 and v14:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (1 + 1))) or (v113 > (2 - 1)))) then
			local v186 = 0 + 0;
			while true do
				if (((7556 - 3466) == (5324 - (885 + 349))) and (v186 == (0 + 0))) then
					if ((v52 == "cursor") or ((10248 - 6490) == (7266 - 4768))) then
						if (v25(v102.EarthquakeCursor, not v17:IsInRange(1008 - (915 + 53))) or ((3474 - (768 + 33)) < (6030 - 4455))) then
							return "earthquake single_target 64";
						end
					end
					if ((v52 == "player") or ((6550 - 2829) <= (1783 - (287 + 41)))) then
						if (((1781 - (638 + 209)) < (1180 + 1090)) and v25(v102.EarthquakePlayer, not v17:IsInRange(1726 - (96 + 1590)))) then
							return "earthquake single_target 64";
						end
					end
					break;
				end
			end
		end
		if ((v100.Earthquake:IsReady() and v38 and (v113 > (1673 - (741 + 931))) and (v114 > (1 + 0)) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) or ((4592 - 2980) == (5863 - 4608))) then
			local v187 = 0 + 0;
			while true do
				if ((v187 == (0 + 0)) or ((1388 + 2964) < (15960 - 11754))) then
					if ((v52 == "cursor") or ((930 + 1930) <= (89 + 92))) then
						if (((13143 - 9921) >= (1371 + 156)) and v25(v102.EarthquakeCursor, not v17:IsInRange(534 - (64 + 430)))) then
							return "earthquake single_target 66";
						end
					end
					if (((1494 + 11) <= (2484 - (106 + 257))) and (v52 == "player")) then
						if (((528 + 216) == (1465 - (496 + 225))) and v25(v102.EarthquakePlayer, not v17:IsInRange(81 - 41))) then
							return "earthquake single_target 66";
						end
					end
					break;
				end
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v40 and (not v100.MasteroftheElements:IsAvailable() or (v127() and v17:DebuffUp(v100.ElectrifiedShocksDebuff)))) or ((9640 - 7661) >= (4494 - (256 + 1402)))) then
			if (((3732 - (30 + 1869)) <= (4037 - (213 + 1156))) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 68";
			end
		end
		if (((3874 - (96 + 92)) == (628 + 3058)) and v126(v100.FrostShock) and v42 and v130() and v127() and (v125() < (1009 - (142 + 757))) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.ElectrifiedShocks:IsAvailable() and v100.ElementalBlast:IsAvailable() and not v100.LightningRod:IsAvailable()) then
			if (((1417 + 2050) > (556 - (32 + 47))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 70";
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v40 and (v127() or v100.LightningRod:IsAvailable())) or ((5265 - (1053 + 924)) >= (3469 + 72))) then
			if (v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast)) or ((6125 - 2568) == (6188 - (685 + 963)))) then
				return "elemental_blast single_target 72";
			end
		end
		if ((v100.EarthShock:IsReady() and v39) or ((530 - 269) > (1975 - 708))) then
			if (((2981 - (541 + 1168)) < (5455 - (645 + 952))) and v25(v100.EarthShock, not v17:IsSpellInRange(v100.EarthShock))) then
				return "earth_shock single_target 74";
			end
		end
		if (((4502 - (669 + 169)) == (12692 - 9028)) and v126(v100.FrostShock) and v42 and v130() and v100.ElectrifiedShocks:IsAvailable() and v127() and not v100.LightningRod:IsAvailable() and (v113 > (1 - 0)) and (v114 > (1 + 0))) then
			if (((429 + 1512) >= (1215 - (181 + 584))) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 76";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and (v100.DeeplyRootedElements:IsAvailable())) or ((6041 - (665 + 730)) < (933 - 609))) then
			local v188 = 0 - 0;
			while true do
				if (((5183 - (540 + 810)) == (15324 - 11491)) and (v188 == (0 - 0))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst)) or ((987 + 253) > (3573 - (166 + 37)))) then
						return "lava_burst single_target 78";
					end
					if (v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst)) or ((4362 - (22 + 1859)) == (6454 - (843 + 929)))) then
						return "lava_burst single_target 78";
					end
					break;
				end
			end
		end
		if (((4989 - (30 + 232)) >= (594 - 386)) and v100.FrostShock:IsCastable() and v42 and v130() and v100.FluxMelting:IsAvailable() and v14:BuffDown(v100.FluxMeltingBuff)) then
			if (((1057 - (55 + 722)) < (8266 - 4415)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 80";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and ((v100.ElectrifiedShocks:IsAvailable() and (v17:DebuffRemains(v100.ElectrifiedShocksDebuff) < (1677 - (78 + 1597)))) or (v14:BuffRemains(v100.IcefuryBuff) < (2 + 4)))) or ((2736 + 271) > (2674 + 520))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((2685 - (305 + 244)) >= (2734 + 212))) then
				return "frost_shock single_target 82";
			end
		end
		if (((2270 - (95 + 10)) <= (1786 + 735)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v45 and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.ElementalBlast:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or v129())) then
			if (((9066 - 6205) > (904 - 243)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 84";
			end
			if (((5287 - (592 + 170)) > (15761 - 11242)) and v25(v100.LavaBurst, not v17:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 84";
			end
		end
		if (((7981 - 4803) > (454 + 518)) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v40) then
			if (((1855 + 2911) == (11508 - 6742)) and v25(v100.ElementalBlast, not v17:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and v128() and v100.UnrelentingCalamity:IsAvailable() and (v113 > (1 + 0)) and (v114 > (1 - 0))) or ((3252 - (353 + 154)) > (4163 - 1035))) then
			if (v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning)) or ((1562 - 418) >= (3178 + 1428))) then
				return "chain_lightning single_target 88";
			end
		end
		if (((2615 + 723) >= (183 + 94)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v128() and v100.UnrelentingCalamity:IsAvailable()) then
			if (((3771 - 1161) > (4845 - 2285)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v126(v100.Icefury) and v100.Icefury:IsCastable() and v43) or ((2783 - 1589) > (3169 - (7 + 79)))) then
			if (((429 + 487) >= (928 - (24 + 157))) and v25(v100.Icefury, not v17:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 92";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v100.LightningRodDebuff) and (v17:DebuffUp(v100.ElectrifiedShocksDebuff) or v128()) and (v113 > (1 - 0)) and (v114 > (2 - 1))) or ((695 + 1749) > (7957 - 5003))) then
			if (((3272 - (262 + 118)) < (4597 - (1038 + 45))) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 94";
			end
		end
		if (((1152 - 619) == (763 - (19 + 211))) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v16:IsActive() and (v16:Name() == "Greater Storm Elemental") and v17:DebuffUp(v100.LightningRodDebuff) and (v17:DebuffUp(v100.ElectrifiedShocksDebuff) or v128())) then
			if (((708 - (88 + 25)) <= (8689 - 5276)) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 96";
			end
		end
		if (((1528 + 1550) >= (2419 + 172)) and v100.FrostShock:IsCastable() and v42 and v130() and v127() and v14:BuffDown(v100.LavaSurgeBuff) and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable() and (v100.LavaBurst:ChargesFractional() < (1037 - (1007 + 29))) and v100.EchooftheElements:IsAvailable()) then
			if (((862 + 2337) < (9850 - 5820)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 98";
			end
		end
		if (((3674 - 2897) < (464 + 1614)) and v100.FrostShock:IsCastable() and v42 and v130() and (v100.FluxMelting:IsAvailable() or (v100.ElectrifiedShocks:IsAvailable() and not v100.LightningRod:IsAvailable()))) then
			if (((2507 - (340 + 471)) <= (5747 - 3465)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 100";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and v127() and v14:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (590 - (276 + 313))) and v100.EchooftheElements:IsAvailable() and (v113 > (2 - 1)) and (v114 > (1 + 0))) or ((747 + 1014) >= (231 + 2231))) then
			if (((6523 - (495 + 1477)) > (6969 - 4641)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 102";
			end
		end
		if (((2506 + 1319) >= (870 - (342 + 61))) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46 and v127() and v14:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable()) then
			if (v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt)) or ((3055 - (4 + 161)) == (342 + 215))) then
				return "lightning_bolt single_target 104";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42 and v130() and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable()) or ((14973 - 10203) == (7632 - 4728))) then
			if (v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock)) or ((4400 - (322 + 175)) == (5099 - (173 + 390)))) then
				return "frost_shock single_target 106";
			end
		end
		if (((1010 + 3083) <= (5159 - (203 + 111))) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v37 and (v113 > (1 + 0)) and (v114 > (1 + 0))) then
			if (((4578 - 3009) <= (3295 + 352)) and v25(v100.ChainLightning, not v17:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning single_target 108";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v46) or ((4752 - (57 + 649)) >= (5311 - (328 + 56)))) then
			if (((1479 + 3144) >= (3299 - (433 + 79))) and v25(v100.LightningBolt, not v17:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 110";
			end
		end
		if (((205 + 2029) >= (993 + 237)) and v100.FlameShock:IsCastable() and v41 and (v14:IsMoving())) then
			if (v104.CastCycle(v100.FlameShock, v112, v119, not v17:IsSpellInRange(v100.FlameShock)) or ((1153 - 810) == (8445 - 6659))) then
				return "flame_shock single_target 112";
			end
			if (((1874 + 696) > (2147 + 262)) and v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 112";
			end
		end
		if ((v100.FlameShock:IsCastable() and v41) or ((3645 - (562 + 474)) >= (7544 - 4310))) then
			if (v25(v100.FlameShock, not v17:IsSpellInRange(v100.FlameShock)) or ((6179 - 3146) >= (4936 - (76 + 829)))) then
				return "flame_shock single_target 114";
			end
		end
		if ((v100.FrostShock:IsCastable() and v42) or ((3074 - (1506 + 167)) == (8768 - 4100))) then
			if (((3042 - (58 + 208)) >= (781 + 540)) and v25(v100.FrostShock, not v17:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v138()
		local v170 = 0 + 0;
		while true do
			if ((v170 == (2 + 0)) or ((1986 - 1499) > (2640 - (258 + 79)))) then
				if ((v100.AncestralSpirit:IsCastable() and v100.AncestralSpirit:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((572 + 3931) == (7283 - 3821))) then
					if (((2023 - (1219 + 251)) <= (3214 - (1231 + 440))) and v25(v102.AncestralSpiritMouseover)) then
						return "ancestral_spirit mouseover";
					end
				end
				v109, v110 = v30();
				v170 = 61 - (34 + 24);
			end
			if (((1169 + 846) == (3761 - 1746)) and (v170 == (0 + 0))) then
				if ((v74 and v100.EarthShield:IsCastable() and v14:BuffDown(v100.EarthShieldBuff) and ((v75 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v14:BuffUp(v100.LightningShield)))) or ((12880 - 8639) <= (7475 - 5143))) then
					if (v25(v100.EarthShield) or ((6214 - 3850) < (3876 - 2719))) then
						return "earth_shield main 2";
					end
				elseif ((v74 and v100.LightningShield:IsCastable() and v14:BuffDown(v100.LightningShieldBuff) and ((v75 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v14:BuffUp(v100.EarthShield)))) or ((2548 - 1381) > (2867 - (877 + 712)))) then
					if (v25(v100.LightningShield) or ((686 + 459) <= (1836 - (242 + 512)))) then
						return "lightning_shield main 2";
					end
				end
				v31 = v132();
				v170 = 1 - 0;
			end
			if ((v170 == (630 - (92 + 535))) or ((2445 + 660) == (10053 - 5172))) then
				if ((v100.ImprovedFlametongueWeapon:IsAvailable() and v100.FlamentongueWeapon:IsCastable() and v51 and (not v109 or (v110 < (37552 + 562448))) and v100.FlametongueWeapon:IsAvailable()) or ((6858 - 4971) > (4783 + 95))) then
					if (v25(v100.FlamentongueWeapon) or ((2830 + 1257) > (578 + 3538))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((2203 - 1097) <= (1929 - 663)) and not v14:AffectingCombat() and v32 and v104.TargetIsValid()) then
					v31 = v135();
					if (((4940 - (1476 + 309)) < (5934 - (299 + 985))) and v31) then
						return v31;
					end
				end
				break;
			end
			if (((897 + 2877) >= (6028 - 4189)) and (v170 == (94 - (86 + 7)))) then
				if (((11487 - 8676) == (268 + 2543)) and v31) then
					return v31;
				end
				if (((3026 - (672 + 208)) > (481 + 641)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) then
					if (v25(v100.AncestralSpirit, nil, true) or ((188 - (14 + 118)) == (4061 - (339 + 106)))) then
						return "ancestral_spirit";
					end
				end
				v170 = 2 + 0;
			end
		end
	end
	local function v139()
		local v171 = 0 + 0;
		while true do
			if ((v171 == (1396 - (440 + 955))) or ((2386 + 35) < (1117 - 495))) then
				if (((335 + 674) <= (2813 - 1683)) and v86) then
					local v253 = 0 + 0;
					while true do
						if (((3111 - (260 + 93)) < (2792 + 188)) and ((0 - 0) == v253)) then
							if (v81 or ((155 - 69) >= (5600 - (1181 + 793)))) then
								local v270 = 0 + 0;
								while true do
									if (((2702 - (105 + 202)) == (1920 + 475)) and (v270 == (810 - (352 + 458)))) then
										v31 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 161 - 121);
										if (((9663 - 5883) > (2623 + 86)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							if (v82 or ((692 - 455) >= (3222 - (438 + 511)))) then
								local v271 = 1383 - (1262 + 121);
								while true do
									if ((v271 == (1068 - (728 + 340))) or ((3830 - (816 + 974)) <= (2153 - 1450))) then
										v31 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 107 - 77);
										if (((3618 - (163 + 176)) <= (11292 - 7325)) and v31) then
											return v31;
										end
										break;
									end
								end
							end
							v253 = 4 - 3;
						end
						if ((v253 == (1 + 0)) or ((3798 - (1564 + 246)) == (1222 - (124 + 221)))) then
							if (((2932 + 1359) > (2363 - (115 + 336))) and v83) then
								v31 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 66 - 36);
								if (((413 + 1590) < (2385 - (45 + 1))) and v31) then
									return v31;
								end
							end
							break;
						end
					end
				end
				if (((24 + 408) == (2422 - (1282 + 708))) and v87) then
					v31 = v104.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 1242 - (583 + 629), true);
					if (v31 or ((191 + 954) >= (3241 - 1988))) then
						return v31;
					end
				end
				v171 = 2 + 0;
			end
			if (((4588 - (943 + 227)) > (926 + 1192)) and (v171 == (1631 - (1539 + 92)))) then
				v31 = v133();
				if (((5012 - (706 + 1240)) <= (4148 - (81 + 177))) and v31) then
					return v31;
				end
				v171 = 2 - 1;
			end
			if ((v171 == (260 - (212 + 45))) or ((10028 - 7030) >= (5227 - (708 + 1238)))) then
				if ((v100.Purge:IsReady() and v97 and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v104.UnitHasMagicBuff(v17)) or ((387 + 4262) <= (861 + 1771))) then
					if (v25(v100.Purge, not v17:IsSpellInRange(v100.Purge)) or ((5527 - (586 + 1081)) > (5383 - (348 + 163)))) then
						return "purge damage";
					end
				end
				if ((v104.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((3591 + 407) == (2578 - (215 + 65)))) then
					if (((v91 < v108) and v58 and ((v64 and v34) or not v64)) or ((19 - 11) >= (4598 - (1541 + 318)))) then
						if (((2298 + 292) == (1310 + 1280)) and v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (38 + 12)))) then
							if (v25(v100.BloodFury) or ((1832 - (1036 + 714)) >= (1233 + 637))) then
								return "blood_fury main 2";
							end
						end
						if (((1450 + 1174) < (5837 - (883 + 397))) and v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff))) then
							if (v25(v100.Berserking) or ((3721 - (563 + 27)) > (13858 - 10316))) then
								return "berserking main 4";
							end
						end
						if (((4563 - (1369 + 617)) >= (3065 - (85 + 1402))) and v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (18 + 32)))) then
							if (((10590 - 6487) <= (4974 - (274 + 129))) and v25(v100.Fireblood)) then
								return "fireblood main 6";
							end
						end
						if ((v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (267 - (12 + 205))))) or ((1365 + 130) == (18561 - 13774))) then
							if (v25(v100.AncestralCall) or ((301 + 9) > (4818 - (27 + 357)))) then
								return "ancestral_call main 8";
							end
						end
						if (((2648 - (91 + 389)) <= (4657 - (90 + 207))) and v100.BagofTricks:IsCastable() and (not v100.Ascendance:IsAvailable() or v14:BuffUp(v100.AscendanceBuff))) then
							if (((39 + 955) == (1855 - (706 + 155))) and v25(v100.BagofTricks)) then
								return "bag_of_tricks main 10";
							end
						end
					end
					if (((3450 - (730 + 1065)) > (1964 - (1339 + 224))) and (v91 < v108)) then
						if (((1558 + 1505) <= (3050 + 376)) and v57 and ((v34 and v63) or not v63)) then
							v31 = v134();
							if (((2171 - 712) > (1607 - (268 + 575))) and v31) then
								return v31;
							end
						end
					end
					if ((v100.NaturesSwiftness:IsCastable() and v47) or ((1935 - (919 + 375)) > (11917 - 7583))) then
						if (((4370 - (180 + 791)) >= (4065 - (323 + 1482))) and v25(v100.NaturesSwiftness)) then
							return "natures_swiftness main 12";
						end
					end
					local v254 = v104.HandleDPSPotion(v14:BuffUp(v100.AscendanceBuff));
					if (v254 or ((2311 - (1177 + 741)) >= (279 + 3963))) then
						return v254;
					end
					if (((3708 - 2719) < (1870 + 2989)) and v33 and (v113 > (3 - 1)) and (v114 > (1 + 1))) then
						local v258 = 109 - (96 + 13);
						while true do
							if ((v258 == (1921 - (962 + 959))) or ((11977 - 7182) < (168 + 781))) then
								v31 = v136();
								if (((5193 - (461 + 890)) == (2819 + 1023)) and v31) then
									return v31;
								end
								v258 = 3 - 2;
							end
							if (((1990 - (19 + 224)) <= (3264 + 337)) and (v258 == (199 - (37 + 161)))) then
								if (v25(v100.Pool) or ((290 + 514) > (1690 + 2669))) then
									return "Pool for Aoe()";
								end
								break;
							end
						end
					end
					if (((4606 + 64) >= (3684 - (60 + 1))) and true) then
						v31 = v137();
						if (((2988 - (826 + 97)) < (2464 + 80)) and v31) then
							return v31;
						end
						if (((4712 - 3401) <= (6919 - 3560)) and v25(v100.Pool)) then
							return "Pool for SingleTarget()";
						end
					end
				end
				break;
			end
			if (((3402 - (375 + 310)) <= (5155 - (1864 + 135))) and (v171 == (4 - 2))) then
				if (((240 + 841) < (1514 + 3010)) and v18) then
					if (((1081 - 641) >= (1202 - (314 + 817))) and v85) then
						v31 = v131();
						if (((2799 + 2135) > (2821 - (32 + 182))) and v31) then
							return v31;
						end
					end
				end
				if ((v100.GreaterPurge:IsAvailable() and v97 and v100.GreaterPurge:IsReady() and v36 and v84 and not v14:IsCasting() and not v14:IsChanneling() and v104.UnitHasMagicBuff(v17)) or ((1035 + 365) > (10890 - 7774))) then
					if (((590 - (39 + 26)) < (1806 - (54 + 90))) and v25(v100.GreaterPurge, not v17:IsSpellInRange(v100.GreaterPurge))) then
						return "greater_purge damage";
					end
				end
				v171 = 201 - (45 + 153);
			end
		end
	end
	local function v140()
		local v172 = 0 + 0;
		while true do
			if ((v172 == (555 - (457 + 95))) or ((871 + 5) > (5322 - 2772))) then
				v49 = EpicSettings.Settings['useStormkeeper'];
				v50 = EpicSettings.Settings['useTotemicRecall'];
				v51 = EpicSettings.Settings['useWeaponEnchant'];
				v53 = EpicSettings.Settings['useAscendance'];
				v172 = 9 - 5;
			end
			if (((791 - 572) <= (1101 + 1355)) and ((3 - 2) == v172)) then
				v41 = EpicSettings.Settings['useFlameShock'];
				v42 = EpicSettings.Settings['useFrostShock'];
				v43 = EpicSettings.Settings['useIceFury'];
				v44 = EpicSettings.Settings['useLavaBeam'];
				v172 = 5 - 3;
			end
			if ((v172 == (752 - (485 + 263))) or ((4926 - (575 + 132)) == (2011 - (750 + 111)))) then
				v55 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v54 = EpicSettings.Settings['useFireElemental'];
				v56 = EpicSettings.Settings['useStormElemental'];
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v172 = 1015 - (445 + 565);
			end
			if ((v172 == (0 + 0)) or ((429 + 2560) <= (391 - 169))) then
				v37 = EpicSettings.Settings['useChainlightning'];
				v38 = EpicSettings.Settings['useEarthquake'];
				v39 = EpicSettings.Settings['UseEarthShock'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v172 = 1 + 0;
			end
			if (((2568 - (189 + 121)) > (308 + 933)) and (v172 == (1349 - (634 + 713)))) then
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLightningBolt'];
				v47 = EpicSettings.Settings['useNaturesSwiftness'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v172 = 541 - (493 + 45);
			end
			if (((1009 - (493 + 475)) < (1089 + 3170)) and (v172 == (790 - (158 + 626)))) then
				v66 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if (((3 + 2) == v172) or ((3191 - 1261) < (13 + 43))) then
				v62 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v60 = EpicSettings.Settings['fireElementalWithCD'];
				v61 = EpicSettings.Settings['stormElementalWithCD'];
				v65 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v172 = 1 + 5;
			end
		end
	end
	local function v141()
		local v173 = 1091 - (1035 + 56);
		while true do
			if (((4292 - (114 + 845)) == (1299 + 2034)) and (v173 == (15 - 9))) then
				v81 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v82 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v83 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((3 + 0) == v173) or ((3274 - (179 + 870)) == (28 - 8))) then
				v79 = EpicSettings.Settings['healingStreamTotemHP'] or (878 - (827 + 51));
				v80 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
				v52 = EpicSettings.Settings['earthquakeSetting'] or "";
				v173 = 3 + 1;
			end
			if ((v173 == (474 - (95 + 378))) or ((64 + 808) >= (4380 - 1288))) then
				v71 = EpicSettings.Settings['useAncestralGuidance'];
				v72 = EpicSettings.Settings['useAstralShift'];
				v73 = EpicSettings.Settings['useHealingStreamTotem'];
				v173 = 2 + 0;
			end
			if (((5415 - (334 + 677)) >= (12174 - 8922)) and ((1058 - (1049 + 7)) == v173)) then
				v76 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 - 0);
				v77 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
				v78 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
				v173 = 7 - 4;
			end
			if (((2217 - 1110) > (355 + 441)) and (v173 == (1424 - (1004 + 416)))) then
				v67 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v74 = EpicSettings.Settings['autoShield'];
				v75 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v173 = 1962 - (1621 + 336);
			end
			if (((2898 - (337 + 1602)) == (2476 - (1014 + 503))) and (v173 == (1015 - (446 + 569)))) then
				v68 = EpicSettings.Settings['useWindShear'];
				v69 = EpicSettings.Settings['useCapacitorTotem'];
				v70 = EpicSettings.Settings['useThunderstorm'];
				v173 = 1 + 0;
			end
			if ((v173 == (14 - 9)) or ((83 + 162) >= (4576 - 2372))) then
				v98 = EpicSettings.Settings['healOOC'];
				v99 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
				v97 = EpicSettings.Settings['usePurgeTarget'];
				v173 = 511 - (223 + 282);
			end
		end
	end
	local function v142()
		local v174 = 0 + 0;
		while true do
			if (((5034 - 1872) >= (3017 - 948)) and ((674 - (623 + 47)) == v174)) then
				v87 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v174 == (46 - (32 + 13))) or ((172 + 134) > (2500 + 581))) then
				v85 = EpicSettings.Settings['DispelDebuffs'];
				v84 = EpicSettings.Settings['DispelBuffs'];
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v174 = 1803 - (1070 + 731);
			end
			if ((v174 == (2 + 0)) or ((4917 - (1257 + 147)) < (1073 + 1633))) then
				v63 = EpicSettings.Settings['trinketsWithCD'];
				v64 = EpicSettings.Settings['racialsWithCD'];
				v93 = EpicSettings.Settings['useHealthstone'];
				v92 = EpicSettings.Settings['useHealingPotion'];
				v174 = 5 - 2;
			end
			if (((3111 - (98 + 35)) < (1527 + 2112)) and (v174 == (0 - 0))) then
				v91 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v88 = EpicSettings.Settings['InterruptWithStun'];
				v89 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v90 = EpicSettings.Settings['InterruptThreshold'];
				v174 = 1 + 0;
			end
			if (((3240 + 442) >= (1265 + 1623)) and (v174 == (560 - (395 + 162)))) then
				v95 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v94 = EpicSettings.Settings['healingPotionHP'] or (1941 - (816 + 1125));
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v86 = EpicSettings.Settings['handleAfflicted'];
				v174 = 5 - 1;
			end
		end
	end
	local function v143()
		local v175 = 1148 - (701 + 447);
		while true do
			if (((228 - 79) < (836 - 357)) and (v175 == (1344 - (391 + 950)))) then
				if (((2748 - 1728) >= (1420 - 853)) and v36 and v85) then
					if ((v14:AffectingCombat() and v100.CleanseSpirit:IsAvailable()) or ((1805 - 1072) > (1732 + 737))) then
						local v259 = v85 and v100.CleanseSpirit:IsReady() and v36;
						v31 = v104.FocusUnit(v259, v102, 12 + 8, nil, 91 - 66);
						if (((4019 - (251 + 1271)) == (2224 + 273)) and v31) then
							return v31;
						end
					end
					if (((10444 - 6543) == (9767 - 5866)) and v100.CleanseSpirit:IsAvailable()) then
						if (((332 - 131) < (1674 - (1147 + 112))) and v15 and v15:Exists() and v15:IsAPlayer() and v104.UnitHasCurseDebuff(v15)) then
							if (v100.CleanseSpirit:IsReady() or ((34 + 99) == (3623 - 1839))) then
								if (v25(v102.CleanseSpiritMouseover) or ((2 + 5) >= (1007 - (335 + 362)))) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
				end
				if (((4679 + 313) > (430 - 144)) and (v104.TargetIsValid() or v14:AffectingCombat())) then
					local v255 = 0 - 0;
					while true do
						if ((v255 == (0 - 0)) or ((12469 - 9908) == (11049 - 7156))) then
							v107 = v10.BossFightRemains();
							v108 = v107;
							v255 = 567 - (237 + 329);
						end
						if (((15621 - 11259) >= (937 + 484)) and (v255 == (1 + 0))) then
							if (((1199 - (408 + 716)) <= (13472 - 9926)) and (v108 == (11932 - (344 + 477)))) then
								v108 = v10.FightRemains(v111, false);
							end
							break;
						end
					end
				end
				if (((457 + 2223) <= (5179 - (1188 + 573))) and not v14:IsChanneling() and not v14:IsCasting()) then
					local v256 = 0 - 0;
					while true do
						if (((0 + 0) == v256) or ((13911 - 9623) < (4445 - 1569))) then
							if (((6088 - 3626) >= (2676 - (508 + 1021))) and v86) then
								local v272 = 0 + 0;
								while true do
									if ((v272 == (1166 - (228 + 938))) or ((5599 - (332 + 353)) < (3021 - 541))) then
										if (v81 or ((4081 - 2522) == (1175 + 65))) then
											local v275 = 0 + 0;
											while true do
												if (((2263 - 1697) == (989 - (18 + 405))) and ((0 + 0) == v275)) then
													v31 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 21 + 19);
													if (((5975 - 2054) >= (3987 - (194 + 784))) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										if (((3833 - (694 + 1076)) >= (3552 - (122 + 1782))) and v82) then
											local v276 = 0 + 0;
											while true do
												if (((994 + 72) >= (407 + 45)) and (v276 == (0 + 0))) then
													v31 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 87 - 57);
													if (((4608 + 366) >= (4625 - (214 + 1756))) and v31) then
														return v31;
													end
													break;
												end
											end
										end
										v272 = 4 - 3;
									end
									if (((1 + 0) == v272) or ((150 + 2571) <= (1492 - (217 + 368)))) then
										if (((13404 - 8967) >= (1996 + 1035)) and v83) then
											local v277 = 0 + 0;
											while true do
												if ((v277 == (0 + 0)) or ((5359 - (844 + 45)) < (3233 - (242 + 42)))) then
													v31 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 60 - 30);
													if (v31 or ((3673 - 2093) == (3626 - (132 + 1068)))) then
														return v31;
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							if (v14:AffectingCombat() or ((5924 - 2213) == (2126 - (214 + 1409)))) then
								local v273 = 0 + 0;
								while true do
									if ((v273 == (1634 - (497 + 1137))) or ((1360 - (9 + 931)) == (4607 - (181 + 108)))) then
										v31 = v139();
										if (v31 or ((2477 + 1681) <= (81 - 48))) then
											return v31;
										end
										break;
									end
								end
							else
								local v274 = 0 - 0;
								while true do
									if (((0 + 0) == v274) or ((62 + 37) > (5220 - (296 + 180)))) then
										v31 = v138();
										if (((5744 - (1183 + 220)) == (5606 - (1037 + 228))) and v31) then
											return v31;
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
			if (((412 - 157) <= (4599 - 3003)) and (v175 == (3 - 2))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v36 = EpicSettings.Toggles['dispel'];
				v35 = EpicSettings.Toggles['minicds'];
				v175 = 736 - (527 + 207);
			end
			if ((v175 == (527 - (187 + 340))) or ((6303 - (1298 + 572)) < (4065 - 2430))) then
				v141();
				v140();
				v142();
				v32 = EpicSettings.Toggles['ooc'];
				v175 = 171 - (144 + 26);
			end
			if ((v175 == (4 - 2)) or ((10028 - 5728) < (1160 + 2084))) then
				if (v14:IsDeadOrGhost() or ((9632 - 6098) > (10857 - 6180))) then
					return v31;
				end
				v111 = v14:GetEnemiesInRange(193 - 153);
				v112 = v17:GetEnemiesInSplashRange(3 + 2);
				if (v33 or ((6594 - 1735) < (2801 + 198))) then
					v113 = #v111;
					v114 = v28(v17:GetEnemiesInSplashRangeCount(2 + 3), v113);
				else
					v113 = 203 - (5 + 197);
					v114 = 687 - (339 + 347);
				end
				v175 = 6 - 3;
			end
		end
	end
	local function v144()
		local v176 = 0 - 0;
		while true do
			if (((5102 - (365 + 11)) > (2281 + 126)) and (v176 == (3 - 2))) then
				v22.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if ((v176 == (0 - 0)) or ((2208 - (837 + 87)) > (6221 - 2552))) then
				v100.FlameShockDebuff:RegisterAuraTracking();
				v106();
				v176 = 1671 - (837 + 833);
			end
		end
	end
	v22.SetAPL(56 + 206, v143, v144);
end;
return v0["Epix_Shaman_Elemental.lua"]();

