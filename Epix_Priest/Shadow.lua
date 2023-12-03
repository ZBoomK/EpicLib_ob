local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 + 0)) or ((767 + 291) >= (1829 - 627))) then
			v6 = v0[v4];
			if (((2294 + 1417) > (4022 - (89 + 578))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 - 0)) or ((1955 - (572 + 477)) >= (301 + 1928))) then
			return v6(...);
		end
	end
end
v0["Epix_Priest_Shadow.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Pet;
	local v16 = v12.Focus;
	local v17 = v12.MouseOver;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Macro;
	local v22 = v20.Cast;
	local v23 = v20.Press;
	local v24 = v20.PressCursor;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27 = math.min;
	local v28 = 0 + 0;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
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
	local v80 = v18.Priest.Shadow;
	local v81 = v19.Priest.Shadow;
	local v82 = v21.Priest.Shadow;
	local v83 = {};
	local v84, v85, v86;
	local v87, v88;
	local v89 = v20.Commons.Everyone;
	local v90;
	local v91 = 1327 + 9784;
	local v92 = 11197 - (84 + 2);
	local v93 = false;
	local v94 = false;
	local v95 = 0 - 0;
	local v96 = false;
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = false;
	local v101 = ((v80.Mindbender:IsAvailable()) and v80.Mindbender) or v80.Shadowfiend;
	local v102 = false;
	local v103 = 0 + 0;
	local v104 = false;
	local v105 = nil;
	local v106;
	local v107;
	v10:RegisterForEvent(function()
		v91 = 11953 - (497 + 345);
		v92 = 285 + 10826;
		v93 = false;
		v94 = false;
		VarMindSearCutoff = 1 + 1;
		VarPoolAmount = 1393 - (605 + 728);
		v95 = 0 + 0;
		v96 = false;
		v97 = false;
		v98 = false;
		v99 = false;
		v100 = false;
		v102 = false;
		v103 = 0 - 0;
		v104 = false;
		v105 = nil;
	end, "PLAYER_REGEN_ENABLED");
	local function v108()
		v89.DispellableDebuffs = v89.DispellableDiseaseDebuffs;
	end
	v10:RegisterForEvent(function()
		v108();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		v101 = ((v80.Mindbender:IsAvailable()) and v80.Mindbender) or v80.Shadowfiend;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		v80.ShadowCrash:RegisterInFlightEffect(9413 + 195973);
		v80.ShadowCrash:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v80.ShadowCrash:RegisterInFlightEffect(759360 - 553974);
	v80.ShadowCrash:RegisterInFlight();
	local function v109()
		local v147 = 1 + 0;
		if (((3568 - 2280) > (945 + 306)) and v13:BuffUp(v80.DarkAscensionBuff)) then
			v147 = v147 * (490.25 - (457 + 32));
		end
		if (v13:BuffUp(v80.DarkEvangelismBuff) or ((1915 + 2598) < (4754 - (832 + 570)))) then
			v147 = v147 * (1 + 0 + ((0.01 + 0) * v13:BuffStack(v80.DarkEvangelismBuff)));
		end
		if (v13:BuffUp(v80.DevouredFearBuff) or v13:BuffUp(v80.DevouredPrideBuff) or ((7307 - 5242) >= (1540 + 1656))) then
			v147 = v147 * (797.05 - (588 + 208));
		end
		if (v80.DistortedReality:IsAvailable() or ((11794 - 7418) <= (3281 - (884 + 916)))) then
			v147 = v147 * (1.2 - 0);
		end
		if (v13:BuffUp(v80.MindDevourerBuff) or ((1967 + 1425) >= (5394 - (232 + 421)))) then
			v147 = v147 * (1890.2 - (1569 + 320));
		end
		if (((816 + 2509) >= (410 + 1744)) and v80.Voidtouched:IsAvailable()) then
			v147 = v147 * (3.06 - 2);
		end
		return v147;
	end
	v80.DevouringPlague:RegisterPMultiplier(v80.DevouringPlagueDebuff, v109);
	local function v110(v148, v149)
		if (v149 or ((1900 - (316 + 289)) >= (8462 - 5229))) then
			return v148:DebuffUp(v80.ShadowWordPainDebuff) and v148:DebuffUp(v80.VampiricTouchDebuff) and v148:DebuffUp(v80.DevouringPlagueDebuff);
		else
			return v148:DebuffUp(v80.ShadowWordPainDebuff) and v148:DebuffUp(v80.VampiricTouchDebuff);
		end
	end
	local function v111(v150, v151)
		if (((203 + 4174) > (3095 - (666 + 787))) and not v150) then
			return nil;
		end
		local v152 = 425 - (360 + 65);
		local v153 = nil;
		for v203, v204 in pairs(v150) do
			local v205 = 0 + 0;
			local v206;
			while true do
				if (((4977 - (79 + 175)) > (2138 - 782)) and (v205 == (0 + 0))) then
					v206 = v204:TimeToDie();
					if (v151 or ((12677 - 8541) <= (6611 - 3178))) then
						if (((5144 - (503 + 396)) <= (4812 - (92 + 89))) and ((v206 * v25(v204:DebuffRefreshable(v80.VampiricTouchDebuff))) > v152)) then
							v152 = v206;
							v153 = v204;
						end
					elseif (((8294 - 4018) >= (2008 + 1906)) and (v206 > v152)) then
						v152 = v206;
						v153 = v204;
					end
					break;
				end
			end
		end
		return v153;
	end
	local function v112(v154)
		return (v154:DebuffRemains(v80.ShadowWordPainDebuff));
	end
	local function v113(v155)
		return (v155:TimeToDie());
	end
	local function v114(v156)
		return (v156:DebuffRemains(v80.VampiricTouchDebuff));
	end
	local function v115(v157)
		return v157:DebuffRefreshable(v80.VampiricTouchDebuff) and (v157:TimeToDie() >= (8 + 4)) and (((v80.ShadowCrash:CooldownRemains() >= v157:DebuffRemains(v80.VampiricTouchDebuff)) and not v80.ShadowCrash:InFlight()) or v98 or not v80.WhisperingShadows:IsAvailable());
	end
	local function v116(v158)
		return not v80.DistortedReality:IsAvailable() or (v88 == (3 - 2)) or (v158:DebuffRemains(v80.DevouringPlagueDebuff) <= v107) or (v13:InsanityDeficit() <= (3 + 13));
	end
	local function v117(v159)
		return (v159:DebuffRemains(v80.DevouringPlagueDebuff) <= v107) or not v80.DistortedReality:IsAvailable();
	end
	local function v118(v160)
		return ((v160:DebuffRemains(v80.DevouringPlagueDebuff) > v80.MindBlast:ExecuteTime()) and (v80.MindBlast:FullRechargeTime() <= (v107 + v80.MindBlast:ExecuteTime()))) or (v103 <= (v80.MindBlast:ExecuteTime() + v107));
	end
	local function v119(v161)
		return v110(v161, true) and (v161:DebuffRemains(v80.DevouringPlagueDebuff) >= v80.Mindgames:CastTime());
	end
	local function v120(v162)
		return v162:DebuffRefreshable(v80.VampiricTouchDebuff) or ((v162:DebuffRemains(v80.VampiricTouchDebuff) <= v162:TimeToDie()) and v13:BuffDown(v80.VoidformBuff));
	end
	local function v121(v163)
		return ((v163:HealthPercentage() < (45 - 25)) and ((v101:CooldownRemains() >= (9 + 1)) or not v80.InescapableTorment:IsAvailable())) or (v102 and v80.InescapableTorment:IsAvailable()) or v13:BuffUp(v80.DeathspeakerBuff);
	end
	local function v122(v164)
		return (v164:HealthPercentage() < (10 + 10)) or v13:BuffUp(v80.DeathspeakerBuff) or v13:HasTier(94 - 63, 1 + 1);
	end
	local function v123(v165)
		return v165:HealthPercentage() < (30 - 10);
	end
	local function v124(v166)
		return v166:DebuffUp(v80.DevouringPlagueDebuff) and (v103 <= (1246 - (485 + 759))) and v102 and v80.InescapableTorment:IsAvailable() and (v88 <= (16 - 9));
	end
	local function v112(v167)
		return (v167:DebuffRemains(v80.ShadowWordPainDebuff));
	end
	local function v125(v168)
		return v168:DebuffRemains(v80.DevouringPlagueDebuff) >= (1191.5 - (442 + 747));
	end
	local function v126(v169)
		return v169:DebuffRefreshable(v80.VampiricTouchDebuff) and (v169:TimeToDie() >= (1153 - (832 + 303))) and (v169:DebuffUp(v80.VampiricTouchDebuff) or not v97);
	end
	local function v127(v170)
		local v171 = 946 - (88 + 858);
		while true do
			if (((61 + 137) <= (3613 + 752)) and (v171 == (0 + 0))) then
				if (((5571 - (766 + 23)) > (23084 - 18408)) and ((v80.ShadowCrash:CooldownRemains() >= v170:DebuffRemains(v80.VampiricTouchDebuff)) or v98)) then
					return v170:DebuffRefreshable(v80.VampiricTouchDebuff) and (v170:TimeToDie() >= (24 - 6)) and (v170:DebuffUp(v80.VampiricTouchDebuff) or not v97);
				end
				return nil;
			end
		end
	end
	local function v128(v172)
		return (v110(v172, false));
	end
	local function v129()
		v105 = v14:GUID();
		if (((12814 - 7950) > (7456 - 5259)) and v80.ArcaneTorrent:IsCastable() and v30) then
			if (v23(v80.ArcaneTorrent, not v14:IsSpellInRange(v80.ArcaneTorrent)) or ((4773 - (1036 + 37)) == (1778 + 729))) then
				return "arcane_torrent precombat 6";
			end
		end
		local v173 = v13:IsInParty() and not v13:IsInRaid();
		if (((8712 - 4238) >= (216 + 58)) and v80.ShadowCrash:IsCastable() and not v173) then
			if ((v77 == "Confirm") or ((3374 - (641 + 839)) <= (2319 - (910 + 3)))) then
				if (((4007 - 2435) >= (3215 - (1466 + 218))) and v23(v80.ShadowCrash, not v14:IsInRange(19 + 21))) then
					return "shadow_crash precombat 8";
				end
			elseif ((v77 == "Enemy Under Cursor") or ((5835 - (556 + 592)) < (1616 + 2926))) then
				if (((4099 - (329 + 479)) > (2521 - (174 + 680))) and v17:Exists() and v13:CanAttack(v17)) then
					if (v23(v82.ShadowCrashCursor, not v14:IsInRange(137 - 97)) or ((1808 - 935) == (1453 + 581))) then
						return "shadow_crash precombat 8";
					end
				end
			elseif ((v77 == "At Cursor") or ((3555 - (396 + 343)) < (1 + 10))) then
				if (((5176 - (29 + 1448)) < (6095 - (135 + 1254))) and v23(v82.ShadowCrashCursor, not v14:IsInRange(150 - 110))) then
					return "shadow_crash precombat 8";
				end
			end
		end
		if (((12354 - 9708) >= (584 + 292)) and v80.VampiricTouch:IsCastable() and (not v80.ShadowCrash:IsAvailable() or (v80.ShadowCrash:CooldownDown() and not v80.ShadowCrash:InFlight()) or v173)) then
			if (((2141 - (389 + 1138)) <= (3758 - (102 + 472))) and v23(v80.VampiricTouch, not v14:IsSpellInRange(v80.VampiricTouch), true)) then
				return "vampiric_touch precombat 14";
			end
		end
		if (((2950 + 176) == (1734 + 1392)) and v80.ShadowWordPain:IsCastable() and not v80.Misery:IsAvailable()) then
			if (v23(v80.ShadowWordPain, not v14:IsSpellInRange(v80.ShadowWordPain)) or ((2040 + 147) >= (6499 - (320 + 1225)))) then
				return "shadow_word_pain precombat 16";
			end
		end
	end
	local function v130()
		local v174 = 0 - 0;
		while true do
			if ((v174 == (1 + 0)) or ((5341 - (157 + 1307)) == (5434 - (821 + 1038)))) then
				v100 = ((v80.VoidEruption:CooldownRemains() <= (v13:GCD() * (7 - 4))) and v80.VoidEruption:IsAvailable()) or (v80.DarkAscension:CooldownUp() and v80.DarkAscension:IsAvailable()) or (v80.VoidTorrent:IsAvailable() and v80.PsychicLink:IsAvailable() and (v80.VoidTorrent:CooldownRemains() <= (1 + 3)) and v13:BuffDown(v80.VoidformBuff));
				break;
			end
			if (((1255 - 548) > (236 + 396)) and (v174 == (0 - 0))) then
				v93 = v110(v14, false) or (v80.ShadowCrash:InFlight() and v80.WhisperingShadows:IsAvailable());
				v94 = v110(v14, true);
				v174 = 1027 - (834 + 192);
			end
		end
	end
	local function v131()
		v95 = v27(v88, v79);
		v96 = false;
		local v175 = v111(v86, true);
		if ((v175 and (v175:TimeToDie() >= (2 + 16))) or ((141 + 405) >= (58 + 2626))) then
			v96 = true;
		end
		v97 = ((v80.VampiricTouchDebuff:AuraActiveCount() + ((12 - 4) * v25(v80.ShadowCrash:InFlight() and v80.WhisperingShadows:IsAvailable()))) >= v95) or not v96;
		if (((1769 - (300 + 4)) <= (1149 + 3152)) and v98 and v80.WhisperingShadows:IsAvailable()) then
			v98 = (v95 - v80.VampiricTouchDebuff:AuraActiveCount()) < (10 - 6);
		end
		v99 = ((v80.VampiricTouchDebuff:AuraActiveCount() + ((370 - (112 + 250)) * v25(not v98))) >= v95) or not v96;
	end
	local function v132()
		if (((680 + 1024) > (3569 - 2144)) and (v13:BuffUp(v80.VoidformBuff) or v13:BuffUp(v80.PowerInfusionBuff) or v13:BuffUp(v80.DarkAscensionBuff) or (v92 < (12 + 8)))) then
			local v208 = 0 + 0;
			while true do
				if ((v208 == (1 + 0)) or ((341 + 346) == (3146 + 1088))) then
					v90 = v89.HandleBottomTrinket(v83, CDs, 1454 - (1001 + 413), nil);
					if (v90 or ((7425 - 4095) < (2311 - (244 + 638)))) then
						return v90;
					end
					break;
				end
				if (((1840 - (627 + 66)) >= (998 - 663)) and ((602 - (512 + 90)) == v208)) then
					v90 = v89.HandleTopTrinket(v83, CDs, 1946 - (1665 + 241), nil);
					if (((4152 - (373 + 344)) > (946 + 1151)) and v90) then
						return v90;
					end
					v208 = 1 + 0;
				end
			end
		end
	end
	local function v133()
		if ((v80.ShadowCrash:IsCastable() and (v14:DebuffDown(v80.VampiricTouchDebuff))) or ((9944 - 6174) >= (6838 - 2797))) then
			if ((v77 == "Confirm") or ((4890 - (35 + 1064)) <= (1173 + 438))) then
				if (v23(v80.ShadowCrash, not v14:IsInRange(85 - 45)) or ((19 + 4559) <= (3244 - (298 + 938)))) then
					return "shadow_crash opener 2";
				end
			elseif (((2384 - (233 + 1026)) <= (3742 - (636 + 1030))) and (v77 == "Enemy Under Cursor")) then
				if ((v17:Exists() and v13:CanAttack(v17)) or ((380 + 363) >= (4297 + 102))) then
					if (((344 + 811) < (114 + 1559)) and v23(v82.ShadowCrashCursor, not v14:IsInRange(261 - (55 + 166)))) then
						return "shadow_crash opener 2";
					end
				end
			elseif ((v77 == "At Cursor") or ((451 + 1873) <= (59 + 519))) then
				if (((14386 - 10619) == (4064 - (36 + 261))) and v23(v82.ShadowCrashCursor, not v14:IsInRange(69 - 29))) then
					return "shadow_crash opener 2";
				end
			end
		end
		if (((5457 - (34 + 1334)) == (1572 + 2517)) and v80.VampiricTouch:IsCastable() and v14:DebuffDown(v80.VampiricTouchDebuff) and (v80.ShadowCrash:CooldownDown() or not v80.ShadowCrash:IsAvailable())) then
			if (((3464 + 994) >= (2957 - (1035 + 248))) and v22(v80.VampiricTouch, nil, nil, not v14:IsSpellInRange(v80.VampiricTouch))) then
				return "vampiric_touch opener 3";
			end
		end
		if (((993 - (20 + 1)) <= (739 + 679)) and v101:IsCastable() and v30) then
			if (v23(v101) or ((5257 - (134 + 185)) < (5895 - (549 + 584)))) then
				return "mindbender opener 4";
			end
		end
		if (v80.DarkAscension:IsCastable() or ((3189 - (314 + 371)) > (14638 - 10374))) then
			if (((3121 - (478 + 490)) == (1141 + 1012)) and v23(v80.DarkAscension)) then
				return "dark_ascension opener 6";
			end
		end
		if (v80.VoidEruption:IsAvailable() or ((1679 - (786 + 386)) >= (8392 - 5801))) then
			local v209 = 1379 - (1055 + 324);
			while true do
				if (((5821 - (1093 + 247)) == (3982 + 499)) and (v209 == (1 + 0))) then
					if (v80.VoidEruption:IsCastable() or ((9242 - 6914) < (2351 - 1658))) then
						if (((12315 - 7987) == (10875 - 6547)) and v23(v80.VoidEruption, not v14:IsInRange(15 + 25), true)) then
							return "void_eruption opener 12";
						end
					end
					break;
				end
				if (((6117 - 4529) >= (4590 - 3258)) and (v209 == (0 + 0))) then
					if ((v80.ShadowWordDeath:IsCastable() and v80.InescapableTorment:IsAvailable() and v13:PrevGCDP(2 - 1, v80.MindBlast) and (v80.ShadowWordDeath:TimeSinceLastCast() > (708 - (364 + 324)))) or ((11442 - 7268) > (10193 - 5945))) then
						if (v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath)) or ((1520 + 3066) <= (342 - 260))) then
							return "shadow_word_death opener 8";
						end
					end
					if (((6186 - 2323) == (11732 - 7869)) and v80.MindBlast:IsCastable()) then
						if (v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true) or ((1550 - (1249 + 19)) <= (38 + 4))) then
							return "mind_blast opener 10";
						end
					end
					v209 = 3 - 2;
				end
			end
		end
		v90 = v132();
		if (((5695 - (686 + 400)) >= (602 + 164)) and v90) then
			return v90;
		end
		if (v80.VoidBolt:IsCastable() or ((1381 - (73 + 156)) == (12 + 2476))) then
			if (((4233 - (721 + 90)) > (38 + 3312)) and v23(v80.VoidBolt, not v14:IsInRange(129 - 89))) then
				return "void_bolt opener 16";
			end
		end
		if (((1347 - (224 + 246)) > (608 - 232)) and v80.DevouringPlague:IsReady()) then
			if (v23(v80.DevouringPlague, not v14:IsSpellInRange(v80.DevouringPlague)) or ((5740 - 2622) <= (336 + 1515))) then
				return "devouring_plague opener 18";
			end
		end
		if (v80.MindBlast:IsCastable() or ((4 + 161) >= (2565 + 927))) then
			if (((7850 - 3901) < (16159 - 11303)) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
				return "mind_blast opener 20";
			end
		end
		if (v80.MindSpike:IsCastable() or ((4789 - (203 + 310)) < (5009 - (1238 + 755)))) then
			if (((328 + 4362) > (5659 - (709 + 825))) and v23(v80.MindSpike, not v14:IsSpellInRange(v80.MindSpike), true)) then
				return "mind_spike opener 22";
			end
		end
		if (v80.MindFlay:IsCastable() or ((92 - 42) >= (1304 - 408))) then
			if (v23(v80.MindFlay, not v14:IsSpellInRange(v80.MindFlay), true) or ((2578 - (196 + 668)) >= (11678 - 8720))) then
				return "mind_flay opener 24";
			end
		end
	end
	local function v134()
		if ((v80.VampiricTouch:IsCastable() and (v13:BuffUp(v80.UnfurlingDarknessBuff))) or ((3088 - 1597) < (1477 - (171 + 662)))) then
			if (((797 - (4 + 89)) < (3459 - 2472)) and v89.CastTargetIf(v80.VampiricTouch, v85, "min", v114, nil, not v14:IsSpellInRange(v80.VampiricTouch), nil, nil, nil, true)) then
				return "vampiric_touch filler 2";
			end
		end
		if (((1354 + 2364) > (8371 - 6465)) and v80.ShadowWordDeath:IsReady()) then
			if (v89.CastCycle(v80.ShadowWordDeath, v85, v122, not v14:IsSpellInRange(v80.ShadowWordDeath), nil, nil, v82.ShadowWordDeathMouseover) or ((376 + 582) > (5121 - (35 + 1451)))) then
				return "shadow_word_death filler 4";
			end
		end
		if (((4954 - (28 + 1425)) <= (6485 - (941 + 1052))) and v80.MindSpikeInsanity:IsReady()) then
			if (v23(v80.MindSpikeInsanity, not v14:IsSpellInRange(v80.MindSpikeInsanity), true) or ((3301 + 141) < (4062 - (822 + 692)))) then
				return "mind_spike_insanity filler 6";
			end
		end
		if (((4104 - 1229) >= (690 + 774)) and v80.MindFlay:IsCastable() and (v13:BuffUp(v80.MindFlayInsanityBuff))) then
			if (v23(v80.MindSpike, not v14:IsSpellInRange(v80.MindSpike), true) or ((5094 - (45 + 252)) >= (4842 + 51))) then
				return "mind_flay filler 8";
			end
		end
		if (v80.Mindgames:IsReady() or ((190 + 361) > (5032 - 2964))) then
			if (((2547 - (114 + 319)) > (1355 - 411)) and v23(v80.Mindgames, not v14:IsInRange(51 - 11), true)) then
				return "mindgames filler 10";
			end
		end
		if ((v80.ShadowWordDeath:IsReady() and v80.InescapableTorment:IsAvailable() and v102) or ((1442 + 820) >= (4612 - 1516))) then
			if (v89.CastTargetIf(v80.ShadowWordDeath, v85, "min", v113, nil, not v14:IsSpellInRange(v80.ShadowWordDeath), nil, nil, v82.ShadowWordDeathMouseover) or ((4724 - 2469) >= (5500 - (556 + 1407)))) then
				return "shadow_word_death filler 12";
			end
		end
		if ((v80.DivineStar:IsReady() and (v16:HealthPercentage() < DivineStarHP) and v66) or ((5043 - (741 + 465)) < (1771 - (170 + 295)))) then
			if (((1555 + 1395) == (2710 + 240)) and v23(v82.DivineStarPlayer, not v16:IsInRange(73 - 43))) then
				return "divine_star heal";
			end
		end
		if ((v80.Halo:IsReady() and v89.TargetIsValid() and v14:IsInRange(25 + 5) and v63 and v89.AreUnitsBelowHealthPercentage(v64, v65)) or ((3029 + 1694) < (1868 + 1430))) then
			if (((2366 - (957 + 273)) >= (42 + 112)) and v23(v80.Halo, nil, true)) then
				return "halo heal";
			end
		end
		if (v80.MindSpike:IsCastable() or ((109 + 162) > (18091 - 13343))) then
			if (((12490 - 7750) >= (9627 - 6475)) and v23(v80.MindSpike, not v14:IsSpellInRange(v80.MindSpike), true)) then
				return "mind_spike filler 16";
			end
		end
		if (v106:IsCastable() or ((12765 - 10187) >= (5170 - (389 + 1391)))) then
			if (((26 + 15) <= (173 + 1488)) and v23(v106, not v14:IsSpellInRange(v106), true)) then
				return "mind_flay filler 18";
			end
		end
		if (((1368 - 767) < (4511 - (783 + 168))) and v80.ShadowCrash:IsCastable()) then
			if (((788 - 553) < (676 + 11)) and (v77 == "Confirm")) then
				if (((4860 - (309 + 2)) > (3540 - 2387)) and v23(v80.ShadowCrash, not v14:IsInRange(1252 - (1090 + 122)))) then
					return "shadow_crash filler 20";
				end
			elseif ((v77 == "Enemy Under Cursor") or ((1516 + 3158) < (15690 - 11018))) then
				if (((2511 + 1157) < (5679 - (628 + 490))) and v17:Exists() and v13:CanAttack(v17)) then
					if (v23(v82.ShadowCrashCursor, not v14:IsInRange(8 + 32)) or ((1126 - 671) == (16474 - 12869))) then
						return "shadow_crash filler 20";
					end
				end
			elseif ((v77 == "At Cursor") or ((3437 - (431 + 343)) == (6688 - 3376))) then
				if (((12372 - 8095) <= (3536 + 939)) and v23(v82.ShadowCrashCursor, not v14:IsInRange(6 + 34))) then
					return "shadow_crash filler 20";
				end
			end
		end
		if (v80.ShadowWordDeath:IsReady() or ((2565 - (556 + 1139)) == (1204 - (6 + 9)))) then
			if (((285 + 1268) <= (1605 + 1528)) and v89.CastCycle(v80.ShadowWordDeath, v85, v123, not v14:IsSpellInRange(v80.ShadowWordDeath), nil, nil, v82.ShadowWordDeathMouseover)) then
				return "shadow_word_death filler 22";
			end
		end
		if ((v80.ShadowWordDeath:IsReady() and v13:IsMoving()) or ((2406 - (28 + 141)) >= (1360 + 2151))) then
			if (v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath)) or ((1633 - 309) > (2139 + 881))) then
				return "shadow_word_death movement filler 26";
			end
		end
		if ((v80.ShadowWordPain:IsReady() and v13:IsMoving()) or ((4309 - (486 + 831)) == (4894 - 3013))) then
			if (((10935 - 7829) > (289 + 1237)) and v89.CastTargetIf(v80.ShadowWordPain, v85, "min", v112, nil, not v14:IsSpellInRange(v80.ShadowWordPain))) then
				return "shadow_word_pain filler 28";
			end
		end
	end
	local function v135()
		local v176 = 0 - 0;
		while true do
			if (((4286 - (668 + 595)) < (3483 + 387)) and (v176 == (1 + 0))) then
				if (((389 - 246) > (364 - (23 + 267))) and v80.BloodFury:IsCastable() and (v13:BuffUp(v80.PowerInfusionBuff) or (v92 <= (1959 - (1129 + 815))))) then
					if (((405 - (371 + 16)) < (3862 - (1326 + 424))) and v23(v80.BloodFury)) then
						return "blood_fury cds 8";
					end
				end
				if (((2077 - 980) <= (5949 - 4321)) and v80.AncestralCall:IsCastable() and (v13:BuffUp(v80.PowerInfusionBuff) or (v92 <= (133 - (88 + 30))))) then
					if (((5401 - (720 + 51)) == (10299 - 5669)) and v23(v80.AncestralCall)) then
						return "ancestral_call cds 10";
					end
				end
				v176 = 1778 - (421 + 1355);
			end
			if (((5840 - 2300) > (1318 + 1365)) and (v176 == (1086 - (286 + 797)))) then
				if (((17525 - 12731) >= (5424 - 2149)) and v80.DarkAscension:IsCastable() and not v13:IsCasting(v80.DarkAscension) and ((v102 and (v101:CooldownRemains() >= (443 - (397 + 42)))) or (not v80.Mindbender:IsAvailable() and v101:CooldownDown()) or ((v88 > (1 + 1)) and not v80.InescapableTorment:IsAvailable()))) then
					if (((2284 - (24 + 776)) == (2285 - 801)) and v23(v80.DarkAscension)) then
						return "dark_ascension cds 22";
					end
				end
				if (((2217 - (222 + 563)) < (7832 - 4277)) and v30) then
					local v214 = 0 + 0;
					while true do
						if (((190 - (23 + 167)) == v214) or ((2863 - (690 + 1108)) > (1291 + 2287))) then
							v90 = v132();
							if (v90 or ((3956 + 839) < (2255 - (40 + 808)))) then
								return v90;
							end
							break;
						end
					end
				end
				break;
			end
			if (((306 + 1547) < (18404 - 13591)) and (v176 == (2 + 0))) then
				if ((v80.DivineStar:IsReady() and (v88 > (1 + 0)) and v81.BelorrelostheSuncaller:IsEquipped() and (v81.BelorrelostheSuncaller:CooldownRemains() <= v107)) or ((1547 + 1274) < (3002 - (47 + 524)))) then
					if (v23(v82.DivineStarPlayer, not v16:IsInRange(20 + 10)) or ((7856 - 4982) < (3260 - 1079))) then
						return "divine_star cds 16";
					end
				end
				if ((v80.VoidEruption:IsCastable() and v101:CooldownDown() and ((v102 and (v101:CooldownRemains() >= (8 - 4))) or not v80.Mindbender:IsAvailable() or ((v88 > (1728 - (1165 + 561))) and not v80.InescapableTorment:IsAvailable())) and ((v80.MindBlast:Charges() == (0 + 0)) or (v10.CombatTime() > (46 - 31)))) or ((1026 + 1663) <= (822 - (341 + 138)))) then
					if (v23(v80.VoidEruption) or ((505 + 1364) == (4145 - 2136))) then
						return "void_eruption cds 20";
					end
				end
				v176 = 329 - (89 + 237);
			end
			if ((v176 == (0 - 0)) or ((7465 - 3919) < (3203 - (581 + 300)))) then
				if ((v80.Fireblood:IsCastable() and (v13:BuffUp(v80.PowerInfusionBuff) or (v92 <= (1228 - (855 + 365))))) or ((4944 - 2862) == (1559 + 3214))) then
					if (((4479 - (1030 + 205)) > (991 + 64)) and v23(v80.Fireblood)) then
						return "fireblood cds 4";
					end
				end
				if ((v80.Berserking:IsCastable() and (v13:BuffUp(v80.PowerInfusionBuff) or (v92 <= (12 + 0)))) or ((3599 - (156 + 130)) <= (4039 - 2261))) then
					if (v23(v80.Berserking) or ((2394 - 973) >= (4308 - 2204))) then
						return "berserking cds 6";
					end
				end
				v176 = 1 + 0;
			end
		end
	end
	local function v136()
		local v177 = 0 + 0;
		while true do
			if (((1881 - (10 + 59)) <= (919 + 2330)) and (v177 == (19 - 15))) then
				if (((2786 - (671 + 492)) <= (1558 + 399)) and v80.ShadowWordDeath:IsReady() and (v13:BuffStack(v80.DeathsTormentBuff) > (1224 - (369 + 846))) and v13:HasTier(9 + 22, 4 + 0) and (not v98 or not v80.ShadowCrash:IsAvailable())) then
					if (((6357 - (1036 + 909)) == (3508 + 904)) and v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath))) then
						return "shadow_word_death main 22";
					end
				end
				if (((2938 - 1188) >= (1045 - (11 + 192))) and v80.ShadowWordDeath:IsReady() and v93 and v80.InescapableTorment:IsAvailable() and v102 and ((not v80.InsidiousIre:IsAvailable() and not v80.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v80.DeathspeakerBuff)) and not v13:HasTier(16 + 15, 177 - (135 + 40))) then
					if (((10592 - 6220) > (1116 + 734)) and v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath))) then
						return "shadow_word_death main 24";
					end
				end
				if (((510 - 278) < (1230 - 409)) and v80.VampiricTouch:IsCastable()) then
					if (((694 - (50 + 126)) < (2511 - 1609)) and v89.CastTargetIf(v80.VampiricTouch, v85, "min", v114, v115, not v14:IsSpellInRange(v80.VampiricTouch))) then
						return "vampiric_touch main 26";
					end
				end
				v177 = 2 + 3;
			end
			if (((4407 - (1233 + 180)) > (1827 - (522 + 447))) and (v177 == (1427 - (107 + 1314)))) then
				if (v90 or ((1743 + 2012) <= (2788 - 1873))) then
					return v90;
				end
				break;
			end
			if (((1676 + 2270) > (7432 - 3689)) and (v177 == (11 - 8))) then
				if ((v80.DevouringPlague:IsReady() and ((v13:InsanityDeficit() <= (1930 - (716 + 1194))) or (v13:BuffUp(v80.VoidformBuff) and (v80.VoidBolt:CooldownRemains() > v13:BuffRemains(v80.VoidformBuff)) and (v80.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v80.VoidformBuff) + 1 + 1))) or (v13:BuffUp(v80.MindDevourerBuff) and (v13:PMultiplier(v80.DevouringPlague) < (1.2 + 0))))) or ((1838 - (74 + 429)) >= (6377 - 3071))) then
					if (((2401 + 2443) > (5157 - 2904)) and v89.CastCycle(v80.DevouringPlague, v85, v116, not v14:IsSpellInRange(v80.DevouringPlague), nil, nil, v82.DevouringPlagueMouseover)) then
						return "devouring_plague main 16";
					end
				end
				if (((320 + 132) == (1393 - 941)) and v80.ShadowWordDeath:IsReady() and (v13:HasTier(76 - 45, 435 - (279 + 154)))) then
					if (v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath)) or ((5335 - (454 + 324)) < (1642 + 445))) then
						return "shadow_word_death main 18";
					end
				end
				if (((3891 - (12 + 5)) == (2089 + 1785)) and v80.ShadowCrash:IsCastable() and not v98 and (v14:DebuffRefreshable(v80.VampiricTouchDebuff) or ((v13:BuffStack(v80.DeathsTormentBuff) > (22 - 13)) and v13:HasTier(12 + 19, 1097 - (277 + 816))))) then
					if ((v77 == "Confirm") or ((8281 - 6343) > (6118 - (1058 + 125)))) then
						if (v23(v80.ShadowCrash, not v14:IsInRange(8 + 32)) or ((5230 - (815 + 160)) < (14686 - 11263))) then
							return "shadow_crash main 20";
						end
					elseif (((3451 - 1997) <= (595 + 1896)) and (v77 == "Enemy Under Cursor")) then
						if ((v17:Exists() and v13:CanAttack(v17)) or ((12151 - 7994) <= (4701 - (41 + 1857)))) then
							if (((6746 - (1222 + 671)) >= (7707 - 4725)) and v23(v82.ShadowCrashCursor, not v14:IsInRange(57 - 17))) then
								return "shadow_crash main 20";
							end
						end
					elseif (((5316 - (229 + 953)) > (5131 - (1111 + 663))) and (v77 == "At Cursor")) then
						if (v23(v82.ShadowCrashCursor, not v14:IsInRange(1619 - (874 + 705))) or ((479 + 2938) < (1729 + 805))) then
							return "shadow_crash main 20";
						end
					end
				end
				v177 = 7 - 3;
			end
			if ((v177 == (0 + 0)) or ((3401 - (642 + 37)) <= (38 + 126))) then
				v130();
				if ((v30 and ((v92 < (5 + 25)) or ((v14:TimeToDie() > (37 - 22)) and (not v98 or (v88 > (456 - (233 + 221))))))) or ((5568 - 3160) < (1857 + 252))) then
					v90 = v135();
					if (v90 or ((1574 - (718 + 823)) == (916 + 539))) then
						return v90;
					end
				end
				if ((v101:IsCastable() and v93 and ((v92 < (835 - (266 + 539))) or (v14:TimeToDie() > (42 - 27))) and (not v80.DarkAscension:IsAvailable() or (v80.DarkAscension:CooldownRemains() < v107) or (v92 < (1240 - (636 + 589))))) or ((1051 - 608) >= (8280 - 4265))) then
					if (((2681 + 701) > (61 + 105)) and v23(v101)) then
						return "mindbender main 2";
					end
				end
				v177 = 1016 - (657 + 358);
			end
			if ((v177 == (13 - 8)) or ((637 - 357) == (4246 - (1151 + 36)))) then
				if (((1817 + 64) > (340 + 953)) and v80.MindBlast:IsCastable() and (v13:BuffDown(v80.MindDevourerBuff) or (v80.VoidEruption:CooldownUp() and v80.VoidEruption:IsAvailable()))) then
					if (((7038 - 4681) == (4189 - (1552 + 280))) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
						return "mind_blast main 26";
					end
				end
				if (((957 - (64 + 770)) == (84 + 39)) and v80.VoidTorrent:IsCastable() and not v98) then
					if (v89.CastCycle(v80.VoidTorrent, v85, v125, not v14:IsSpellInRange(v80.VoidTorrent), nil, nil, v82.VoidTorrentMouseover, true) or ((2397 - 1341) >= (603 + 2789))) then
						return "void_torrent main 28";
					end
				end
				v90 = v134();
				v177 = 1249 - (157 + 1086);
			end
			if ((v177 == (1 - 0)) or ((4734 - 3653) < (1648 - 573))) then
				if (v80.DevouringPlague:IsReady() or ((1431 - 382) >= (5251 - (599 + 220)))) then
					if (v89.CastCycle(v80.DevouringPlague, v85, v116, not v14:IsSpellInRange(v80.DevouringPlague)) or ((9494 - 4726) <= (2777 - (1813 + 118)))) then
						return "devouring_plague main 4";
					end
				end
				if ((v80.ShadowWordDeath:IsReady() and (v13:HasTier(23 + 8, 1221 - (841 + 376)) or (v102 and v80.InescapableTorment:IsAvailable() and v13:HasTier(43 - 12, 1 + 1))) and v14:DebuffUp(v80.DevouringPlagueDebuff)) or ((9165 - 5807) <= (2279 - (464 + 395)))) then
					if (v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath)) or ((9595 - 5856) <= (1444 + 1561))) then
						return "shadow_word_death main 6";
					end
				end
				if ((v80.MindBlast:IsCastable() and v102 and v80.InescapableTorment:IsAvailable() and (v103 > v80.MindBlast:ExecuteTime()) and (v88 <= (844 - (467 + 370)))) or ((3427 - 1768) >= (1567 + 567))) then
					if (v89.CastCycle(v80.MindBlast, v85, v118, not v14:IsSpellInRange(v80.MindBlast), nil, nil, v82.MindBlastMouseover, true) or ((11175 - 7915) < (368 + 1987))) then
						return "mind_blast main 8";
					end
				end
				v177 = 4 - 2;
			end
			if ((v177 == (522 - (150 + 370))) or ((1951 - (74 + 1208)) == (10386 - 6163))) then
				if (v80.ShadowWordDeath:IsReady() or ((8024 - 6332) < (419 + 169))) then
					if (v89.CastCycle(v80.ShadowWordDeath, v85, v124, not v14:IsSpellInRange(v80.ShadowWordDeath), nil, nil, v82.ShadowWordDeathMouseover) or ((5187 - (14 + 376)) < (6332 - 2681))) then
						return "shadow_word_death main 10";
					end
				end
				if ((v80.VoidBolt:IsCastable() and v93) or ((2703 + 1474) > (4261 + 589))) then
					if (v23(v80.VoidBolt, not v14:IsInRange(39 + 1)) or ((1172 - 772) > (836 + 275))) then
						return "void_bolt main 12";
					end
				end
				if (((3129 - (23 + 55)) > (2381 - 1376)) and v80.DevouringPlague:IsReady() and (v92 <= (v80.DevouringPlagueDebuff:BaseDuration() + 3 + 1))) then
					if (((3317 + 376) <= (6794 - 2412)) and v23(v80.DevouringPlague, not v14:IsSpellInRange(v80.DevouringPlague))) then
						return "devouring_plague main 14";
					end
				end
				v177 = 1 + 2;
			end
		end
	end
	local function v137()
		local v178 = 901 - (652 + 249);
		while true do
			if ((v178 == (2 - 1)) or ((5150 - (708 + 1160)) > (11129 - 7029))) then
				if ((v80.DevouringPlague:IsReady() and (v14:DebuffRemains(v80.DevouringPlagueDebuff) <= (6 - 2)) and (v80.VoidTorrent:CooldownRemains() < (v13:GCD() * (29 - (10 + 17))))) or ((805 + 2775) < (4576 - (1400 + 332)))) then
					if (((170 - 81) < (6398 - (242 + 1666))) and v23(v80.DevouringPlague, not v14:IsSpellInRange(v80.DevouringPlague))) then
						return "devouring_plague pl_torrent 6";
					end
				end
				if ((v80.MindBlast:IsCastable() and not v13:PrevGCD(1 + 0, v80.MindBlast)) or ((1827 + 3156) < (1541 + 267))) then
					if (((4769 - (850 + 90)) > (6600 - 2831)) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
						return "mind_blast pl_torrent 8";
					end
				end
				v178 = 1392 - (360 + 1030);
			end
			if (((1315 + 170) <= (8196 - 5292)) and (v178 == (0 - 0))) then
				if (((5930 - (909 + 752)) == (5492 - (109 + 1114))) and v80.VoidBolt:IsCastable()) then
					if (((707 - 320) <= (1083 + 1699)) and v23(v80.VoidBolt, not v14:IsInRange(282 - (6 + 236)))) then
						return "void_bolt pl_torrent 2";
					end
				end
				if ((v80.VampiricTouch:IsCastable() and (v14:DebuffRemains(v80.VampiricTouchDebuff) <= (4 + 2)) and (v80.VoidTorrent:CooldownRemains() < (v13:GCD() * (2 + 0)))) or ((4478 - 2579) <= (1601 - 684))) then
					if (v23(v80.VampiricTouch, not v14:IsSpellInRange(v80.VampiricTouch), true) or ((5445 - (1076 + 57)) <= (145 + 731))) then
						return "vampiric_touch pl_torrent 4";
					end
				end
				v178 = 690 - (579 + 110);
			end
			if (((177 + 2055) <= (2296 + 300)) and (v178 == (2 + 0))) then
				if (((2502 - (174 + 233)) < (10295 - 6609)) and v80.VoidTorrent:IsCastable() and (v110(v14, false) or v13:BuffUp(v80.VoidformBuff))) then
					if (v23(v80.VoidTorrent, not v14:IsSpellInRange(v80.VoidTorrent), true) or ((2799 - 1204) >= (1990 + 2484))) then
						return "void_torrent pl_torrent 10";
					end
				end
				break;
			end
		end
	end
	local function v138()
		v131();
		if ((v80.VampiricTouch:IsCastable() and (((v95 > (1174 - (663 + 511))) and not v99 and not v80.ShadowCrash:InFlight()) or not v80.WhisperingShadows:IsAvailable())) or ((4121 + 498) < (626 + 2256))) then
			if (v89.CastCycle(v80.VampiricTouch, v85, v126, not v14:IsSpellInRange(v80.VampiricTouch), nil, nil, v82.VampiricTouchMouseover, true) or ((906 - 612) >= (2926 + 1905))) then
				return "vampiric_touch aoe 2";
			end
		end
		if (((4776 - 2747) <= (7465 - 4381)) and v80.ShadowCrash:IsCastable() and not v98) then
			if ((v77 == "Confirm") or ((973 + 1064) == (4710 - 2290))) then
				if (((3178 + 1280) > (357 + 3547)) and v23(v80.ShadowCrash, not v14:IsInRange(762 - (478 + 244)))) then
					return "shadow_crash aoe 4";
				end
			elseif (((953 - (440 + 77)) >= (56 + 67)) and (v77 == "Enemy Under Cursor")) then
				if (((1830 - 1330) < (3372 - (655 + 901))) and v17:Exists() and v13:CanAttack(v17)) then
					if (((663 + 2911) == (2737 + 837)) and v23(v82.ShadowCrashCursor, not v14:IsInRange(28 + 12))) then
						return "shadow_crash aoe 4";
					end
				end
			elseif (((890 - 669) < (1835 - (695 + 750))) and (v77 == "At Cursor")) then
				if (v23(v82.ShadowCrashCursor, not v14:IsInRange(136 - 96)) or ((3414 - 1201) <= (5714 - 4293))) then
					return "shadow_crash aoe 4";
				end
			end
		end
		if (((3409 - (285 + 66)) < (11329 - 6469)) and v30 and ((v92 < (1340 - (682 + 628))) or ((v14:TimeToDie() > (3 + 12)) and (not v98 or (v88 > (301 - (176 + 123))))))) then
			v90 = v135();
			if (v90 or ((543 + 753) >= (3226 + 1220))) then
				return v90;
			end
		end
		if ((v101:IsCastable() and ((v14:DebuffUp(v80.ShadowWordPainDebuff) and v97) or (v80.ShadowCrash:InFlight() and v80.WhisperingShadows:IsAvailable())) and ((v92 < (299 - (239 + 30))) or (v14:TimeToDie() > (5 + 10))) and (not v80.DarkAscension:IsAvailable() or (v80.DarkAscension:CooldownRemains() < v107) or (v92 < (15 + 0)))) or ((2464 - 1071) > (14004 - 9515))) then
			if (v23(v101) or ((4739 - (306 + 9)) < (94 - 67))) then
				return "mindbender aoe 6";
			end
		end
		if ((v80.MindBlast:IsCastable() and ((v80.MindBlast:FullRechargeTime() <= (v107 + v80.MindBlast:CastTime())) or (v103 <= (v80.MindBlast:CastTime() + v107))) and v102 and v80.InescapableTorment:IsAvailable() and (v103 > v80.MindBlast:CastTime()) and (v88 <= (2 + 5)) and v13:BuffDown(v80.MindDevourerBuff)) or ((1226 + 771) > (1837 + 1978))) then
			if (((9908 - 6443) > (3288 - (1140 + 235))) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
				return "mind_blast aoe 8";
			end
		end
		if (((467 + 266) < (1669 + 150)) and v80.ShadowWordDeath:IsReady() and (v103 <= (1 + 1)) and v102 and v80.InescapableTorment:IsAvailable() and (v88 <= (59 - (33 + 19)))) then
			if (v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath)) or ((1587 + 2808) == (14251 - 9496))) then
				return "shadow_word_death aoe 10";
			end
		end
		if (v80.VoidBolt:IsCastable() or ((1671 + 2122) < (4645 - 2276))) then
			if (v23(v80.VoidBolt, not v14:IsInRange(38 + 2)) or ((4773 - (586 + 103)) == (25 + 240))) then
				return "void_bolt aoe 12";
			end
		end
		if (((13416 - 9058) == (5846 - (1309 + 179))) and v80.DevouringPlague:IsReady() and (not v100 or (v13:InsanityDeficit() <= (36 - 16)) or (v13:BuffUp(v80.VoidformBuff) and (v80.VoidBolt:CooldownRemains() > v13:BuffRemains(v80.VoidformBuff)) and (v80.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v80.VoidformBuff) + 1 + 1))))) then
			if (v89.CastCycle(v80.DevouringPlague, v85, v117, not v14:IsSpellInRange(v80.DevouringPlague), nil, nil, v82.DevouringPlagueMouseover) or ((8427 - 5289) < (751 + 242))) then
				return "devouring_plague aoe 14";
			end
		end
		if (((7075 - 3745) > (4628 - 2305)) and v80.VampiricTouch:IsCastable() and (((v95 > (609 - (295 + 314))) and not v80.ShadowCrash:InFlight()) or not v80.WhisperingShadows:IsAvailable())) then
			if (v89.CastCycle(v80.VampiricTouch, v85, v127, not v14:IsSpellInRange(v80.VampiricTouch), nil, nil, v82.VampiricTouchMouseover, true) or ((8906 - 5280) == (5951 - (1300 + 662)))) then
				return "vampiric_touch aoe 16";
			end
		end
		if ((v80.ShadowWordDeath:IsReady() and v97 and v80.InescapableTorment:IsAvailable() and v102 and ((not v80.InsidiousIre:IsAvailable() and not v80.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v80.DeathspeakerBuff))) or ((2876 - 1960) == (4426 - (1178 + 577)))) then
			if (((142 + 130) == (803 - 531)) and v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath))) then
				return "shadow_word_death aoe 18";
			end
		end
		if (((5654 - (851 + 554)) <= (4280 + 559)) and v80.MindSpikeInsanity:IsReady() and v93 and (v80.MindBlast:FullRechargeTime() >= (v13:GCD() * (8 - 5))) and v80.IdolOfCthun:IsAvailable() and (v80.VoidTorrent:CooldownDown() or not v80.VoidTorrent:IsAvailable())) then
			if (((6030 - 3253) < (3502 - (115 + 187))) and v23(v80.MindSpikeInsanity, not v14:IsInRange(31 + 9), true)) then
				return "mind_spike_insanity aoe 20";
			end
		end
		if (((90 + 5) < (7711 - 5754)) and v106:IsCastable() and v13:BuffUp(v80.MindFlayInsanityBuff) and v93 and (v80.MindBlast:FullRechargeTime() >= (v13:GCD() * (1164 - (160 + 1001)))) and v80.IdolOfCthun:IsAvailable() and (v80.VoidTorrent:CooldownDown() or not v80.VoidTorrent:IsAvailable())) then
			if (((723 + 103) < (1185 + 532)) and v23(v106, not v14:IsSpellInRange(v106), true)) then
				return "mind_flay aoe 22";
			end
		end
		if (((2918 - 1492) >= (1463 - (237 + 121))) and v80.MindBlast:IsCastable() and v97 and (v13:BuffDown(v80.MindDevourerBuff) or (v80.VoidEruption:CooldownUp() and v80.VoidEruption:IsAvailable()))) then
			if (((3651 - (525 + 372)) <= (6405 - 3026)) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
				return "mind_blast aoe 24";
			end
		end
		if ((v80.VoidTorrent:IsAvailable() and v80.PsychicLink:IsAvailable() and (v80.VoidTorrent:CooldownRemains() <= (9 - 6)) and (not v98 or ((v88 / (v80.VampiricTouchDebuff:AuraActiveCount() + v88)) < (143.5 - (96 + 46)))) and ((v13:Insanity() >= (827 - (643 + 134))) or v14:DebuffUp(v80.DevouringPlagueDebuff) or v13:BuffUp(v80.DarkReveriesBuff) or v13:BuffUp(v80.VoidformBuff) or v13:BuffUp(v80.DarkAscensionBuff))) or ((1418 + 2509) == (3387 - 1974))) then
			v90 = v137();
			if (v90 or ((4284 - 3130) <= (756 + 32))) then
				return v90;
			end
		end
		if ((v80.VoidTorrent:IsCastable() and not v80.PsychicLink:IsAvailable()) or ((3223 - 1580) > (6906 - 3527))) then
			if (v89.CastCycle(v80.VoidTorrent, v85, v128, not v14:IsSpellInRange(v80.VoidTorrent), nil, nil, v82.VoidTorrentMouseover, true) or ((3522 - (316 + 403)) > (3024 + 1525))) then
				return "void_torrent aoe 26";
			end
		end
		if ((v106:IsCastable() and v13:BuffUp(v80.MindFlayInsanityBuff) and v80.IdolOfCthun:IsAvailable()) or ((604 - 384) >= (1093 + 1929))) then
			if (((7106 - 4284) == (2000 + 822)) and v23(v106, not v14:IsSpellInRange(v106), true)) then
				return "mind_flay aoe 28";
			end
		end
		v90 = v134();
		if (v90 or ((342 + 719) == (6434 - 4577))) then
			return v90;
		end
	end
	local function v139()
		local v179 = 0 - 0;
		while true do
			if (((5733 - 2973) > (79 + 1285)) and (v179 == (1 - 0))) then
				if ((v80.DesperatePrayer:IsCastable() and (v13:HealthPercentage() <= v49) and v48) or ((240 + 4662) <= (10576 - 6981))) then
					if (v23(v80.DesperatePrayer) or ((3869 - (12 + 5)) == (1137 - 844))) then
						return "desperate_prayer defensive";
					end
				end
				if ((v80.VampiricEmbrace:IsReady() and v89.TargetIsValid() and v14:IsInRange(64 - 34) and v74 and v89.AreUnitsBelowHealthPercentage(v75, v76)) or ((3313 - 1754) == (11377 - 6789))) then
					if (v23(v80.VampiricEmbrace, nil, true) or ((911 + 3573) == (2761 - (1656 + 317)))) then
						return "vampiric_embrace defensive";
					end
				end
				v179 = 2 + 0;
			end
			if (((3661 + 907) >= (10388 - 6481)) and (v179 == (14 - 11))) then
				if (((1600 - (5 + 349)) < (16481 - 13011)) and v34 and (v13:HealthPercentage() <= v36)) then
					if (((5339 - (266 + 1005)) >= (641 + 331)) and (v35 == "Refreshing Healing Potion")) then
						if (((1681 - 1188) < (5124 - 1231)) and v81.RefreshingHealingPotion:IsReady()) then
							if (v23(v82.RefreshingHealingPotion, nil, nil, true) or ((3169 - (561 + 1135)) >= (4341 - 1009))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if ((v179 == (6 - 4)) or ((5117 - (507 + 559)) <= (2903 - 1746))) then
				if (((1867 - 1263) < (3269 - (212 + 176))) and v32) then
					local v215 = 905 - (250 + 655);
					while true do
						if ((v215 == (2 - 1)) or ((1572 - 672) == (5283 - 1906))) then
							if (((6415 - (1869 + 87)) > (2049 - 1458)) and v80.PowerWordShield:IsCastable() and (v13:HealthPercentage() <= v72) and v71) then
								if (((5299 - (484 + 1417)) >= (5133 - 2738)) and v23(v82.PowerWordShieldPlayer)) then
									return "power_word_shield defensive";
								end
							end
							break;
						end
						if ((v215 == (0 - 0)) or ((2956 - (48 + 725)) >= (4612 - 1788))) then
							if (((5193 - 3257) == (1126 + 810)) and v80.FlashHeal:IsCastable() and (v13:HealthPercentage() <= v68) and v67) then
								if (v23(v82.FlashHealPlayer) or ((12912 - 8080) < (1208 + 3105))) then
									return "flash_heal defensive";
								end
							end
							if (((1192 + 2896) > (4727 - (152 + 701))) and v80.Renew:IsCastable() and (v13:HealthPercentage() <= v70) and v69) then
								if (((5643 - (430 + 881)) == (1659 + 2673)) and v23(v82.RenewPlayer)) then
									return "renew defensive";
								end
							end
							v215 = 896 - (557 + 338);
						end
					end
				end
				if (((1182 + 2817) >= (8172 - 5272)) and v81.Healthstone:IsReady() and v54 and (v13:HealthPercentage() <= v55)) then
					if (v23(v82.Healthstone, nil, nil, true) or ((8841 - 6316) > (10796 - 6732))) then
						return "healthstone defensive 3";
					end
				end
				v179 = 6 - 3;
			end
			if (((5172 - (499 + 302)) == (5237 - (39 + 827))) and (v179 == (0 - 0))) then
				if ((v80.Fade:IsReady() and v52 and (v13:HealthPercentage() <= v53)) or ((593 - 327) > (19803 - 14817))) then
					if (((3056 - 1065) >= (80 + 845)) and v23(v80.Fade, nil, nil, true)) then
						return "fade defensive";
					end
				end
				if (((1331 - 876) < (329 + 1724)) and v80.Dispersion:IsCastable() and (v13:HealthPercentage() < v50) and v51) then
					if (v23(v80.Dispersion) or ((1306 - 480) == (4955 - (103 + 1)))) then
						return "dispersion defensive";
					end
				end
				v179 = 555 - (475 + 79);
			end
		end
	end
	local function v140()
		if (((395 - 212) == (585 - 402)) and ((GetTime() - v28) > v40)) then
			if (((150 + 1009) <= (1574 + 214)) and v80.BodyandSoul:IsAvailable() and v80.PowerWordShield:IsReady() and v39 and v13:BuffDown(v80.AngelicFeatherBuff) and v13:BuffDown(v80.BodyandSoulBuff)) then
				if (v23(v82.PowerWordShieldPlayer) or ((5010 - (1395 + 108)) > (12565 - 8247))) then
					return "power_word_shield_player move";
				end
			end
			if ((v80.AngelicFeather:IsReady() and v38 and v13:BuffDown(v80.AngelicFeatherBuff) and v13:BuffDown(v80.BodyandSoulBuff) and v13:BuffDown(v80.AngelicFeatherBuff)) or ((4279 - (7 + 1197)) <= (1293 + 1672))) then
				if (((477 + 888) <= (2330 - (27 + 292))) and v23(v82.AngelicFeatherPlayer)) then
					return "angelic_feather_player move";
				end
			end
		end
	end
	local function v141()
		if ((v80.PurifyDisease:IsReady() and v31 and v89.DispellableFriendlyUnit()) or ((8134 - 5358) > (4559 - 984))) then
			if (v23(v82.PurifyDiseaseFocus) or ((10710 - 8156) == (9473 - 4669))) then
				return "purify_disease dispel";
			end
		end
	end
	local function v142()
		v33 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or "";
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v37 = EpicSettings.Settings['UsePowerWordFortitude'];
		v38 = EpicSettings.Settings['UseAngelicFeather'];
		v39 = EpicSettings.Settings['UseBodyAndSoul'];
		v40 = EpicSettings.Settings['MovementDelay'] or (139 - (43 + 96));
		v41 = EpicSettings.Settings['DispelDebuffs'];
		v42 = EpicSettings.Settings['DispelBuffs'];
		v43 = EpicSettings.Settings['HandleAfflicted'];
		v44 = EpicSettings.Settings['HandleIncorporeal'];
		v45 = EpicSettings.Settings['InterruptWithStun'];
		v46 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v47 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v48 = EpicSettings.Settings['UseDesperatePrayer'];
		v49 = EpicSettings.Settings['DesperatePrayerHP'] or (0 - 0);
		v50 = EpicSettings.Settings['DispersionHP'] or (0 + 0);
		v51 = EpicSettings.Settings['UseDispersion'];
		v52 = EpicSettings.Settings['UseFade'];
		v53 = EpicSettings.Settings['FadeHP'] or (0 + 0);
		v54 = EpicSettings.Settings['UseHealthstone'];
		v55 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v56 = EpicSettings.Settings['PowerInfusionUsage'] or "";
		v57 = EpicSettings.Settings['PowerInfusionTarget'] or "";
		v58 = EpicSettings.Settings['PowerInfusionHP'] or (0 + 0);
		v59 = EpicSettings.Settings['PowerInfusionGroup'] or (0 - 0);
		v60 = EpicSettings.Settings['PIName1'] or "";
		v61 = EpicSettings.Settings['PIName2'] or "";
		v62 = EpicSettings.Settings['PIName3'] or "";
		v63 = EpicSettings.Settings['UseHalo'];
		v64 = EpicSettings.Settings['HaloHP'] or (0 + 0);
		v65 = EpicSettings.Settings['HaloGroup'] or (0 + 0);
		v66 = EpicSettings.Settings['UseDivineStar'];
		v67 = EpicSettings.Settings['UseFlashHeal'];
		v68 = EpicSettings.Settings['FlashHealHP'] or (1751 - (1414 + 337));
		v69 = EpicSettings.Settings['UseRenew'];
		v70 = EpicSettings.Settings['RenewHP'] or (1940 - (1642 + 298));
		v71 = EpicSettings.Settings['UsePowerWordShield'];
		v72 = EpicSettings.Settings['PowerWordShieldHP'] or (0 - 0);
		v73 = EpicSettings.Settings['UseShadowform'];
		v74 = EpicSettings.Settings['UseVampiricEmbrace'];
		v75 = EpicSettings.Settings['VampiricEmbraceHP'] or (0 - 0);
		v76 = EpicSettings.Settings['VampiricEmbraceGroup'] or (0 - 0);
		v77 = EpicSettings.Settings['ShadowCrashUsage'] or "";
		v78 = EpicSettings.Settings['VampiricTouchUsage'] or "";
		v79 = EpicSettings.Settings['VampiricTouchMax'] or (0 + 0);
	end
	local function v143()
		local v202 = 0 + 0;
		while true do
			if (((3549 - (357 + 615)) == (1809 + 768)) and (v202 == (0 - 0))) then
				v142();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['dispel'];
				v202 = 1 + 0;
			end
			if (((2 - 1) == v202) or ((5 + 1) >= (129 + 1760))) then
				v32 = EpicSettings.Toggles['heal'];
				v84 = v13:GetEnemiesInRange(19 + 11);
				v85 = v13:GetEnemiesInRange(1341 - (384 + 917));
				v86 = v14:GetEnemiesInSplashRange(707 - (128 + 569));
				v202 = 1545 - (1407 + 136);
			end
			if (((2393 - (687 + 1200)) <= (3602 - (556 + 1154))) and ((10 - 7) == v202)) then
				if ((not v13:AffectingCombat() and v29) or ((2103 - (9 + 86)) > (2639 - (275 + 146)))) then
					if (((62 + 317) <= (4211 - (29 + 35))) and v80.PowerWordFortitude:IsCastable() and v37 and (v13:BuffDown(v80.PowerWordFortitudeBuff, true) or v89.GroupBuffMissing(v80.PowerWordFortitudeBuff))) then
						if (v23(v82.PowerWordFortitudePlayer) or ((20005 - 15491) <= (3013 - 2004))) then
							return "power_word_fortitude";
						end
					end
					if (v43 or ((15433 - 11937) == (777 + 415))) then
						v90 = v89.HandleAfflicted(v80.PurifyDisease, v82.PurifyDiseaseMouseover, 1052 - (53 + 959));
						if (v90 or ((616 - (312 + 96)) == (5135 - 2176))) then
							return v90;
						end
					end
					if (((4562 - (147 + 138)) >= (2212 - (813 + 86))) and v80.PowerWordFortitude:IsCastable() and (v13:BuffDown(v80.PowerWordFortitudeBuff, true) or v89.GroupBuffMissing(v80.PowerWordFortitudeBuff))) then
						if (((2338 + 249) < (5880 - 2706)) and v23(v82.PowerWordFortitudePlayer)) then
							return "power_word_fortitude";
						end
					end
					if ((v80.Shadowform:IsCastable() and (v13:BuffDown(v80.ShadowformBuff)) and v73) or ((4612 - (18 + 474)) <= (742 + 1456))) then
						if (v23(v80.Shadowform) or ((5209 - 3613) == (1944 - (860 + 226)))) then
							return "shadowform";
						end
					end
					if (((3523 - (121 + 182)) == (397 + 2823)) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
						if (v23(v80.Resurrection, nil, true) or ((2642 - (988 + 252)) > (409 + 3211))) then
							return "resurrection";
						end
					end
				end
				if (((807 + 1767) == (4544 - (49 + 1921))) and v13:IsMoving() and (v13:AffectingCombat() or v29)) then
					local v216 = 890 - (223 + 667);
					while true do
						if (((1850 - (51 + 1)) < (4744 - 1987)) and (v216 == (0 - 0))) then
							v90 = v140();
							if (v90 or ((1502 - (146 + 979)) > (735 + 1869))) then
								return v90;
							end
							break;
						end
					end
				end
				if (((1173 - (311 + 294)) < (2540 - 1629)) and (v89.TargetIsValid() or v13:AffectingCombat())) then
					v91 = v10.BossFightRemains(nil, true);
					v92 = v91;
					if (((1392 + 1893) < (5671 - (496 + 947))) and (v92 == (12469 - (1233 + 125)))) then
						v92 = v10.FightRemains(v86, false);
					end
					v102 = v101:TimeSinceLastCast() <= (7 + 8);
					v103 = (14 + 1) - v101:TimeSinceLastCast();
					if (((745 + 3171) > (4973 - (963 + 682))) and (v103 < (0 + 0))) then
						v103 = 1504 - (504 + 1000);
					end
					v106 = ((v13:BuffUp(v80.MindFlayInsanityBuff)) and v80.MindFlayInsanity) or v80.MindFlay;
					v107 = v13:GCD() + 0.25 + 0;
				end
				if (((2277 + 223) < (363 + 3476)) and v89.TargetIsValid()) then
					if (((746 - 239) == (434 + 73)) and not v13:AffectingCombat() and v29) then
						local v219 = 0 + 0;
						while true do
							if (((422 - (156 + 26)) <= (1824 + 1341)) and (v219 == (0 - 0))) then
								v90 = v129();
								if (((998 - (149 + 15)) >= (1765 - (890 + 70))) and v90) then
									return v90;
								end
								break;
							end
						end
					end
					if (v13:AffectingCombat() or v29 or ((3929 - (39 + 78)) < (2798 - (14 + 468)))) then
						local v220 = 0 - 0;
						while true do
							if ((v220 == (11 - 7)) or ((1369 + 1283) <= (921 + 612))) then
								v90 = v136();
								if (v90 or ((765 + 2833) < (660 + 800))) then
									return v90;
								end
								break;
							end
							if ((v220 == (0 + 0)) or ((7878 - 3762) < (1179 + 13))) then
								v90 = v139();
								if (v90 or ((11866 - 8489) <= (23 + 880))) then
									return v90;
								end
								if (((4027 - (12 + 39)) >= (409 + 30)) and not v13:IsCasting() and not v13:IsChanneling()) then
									v90 = v89.Interrupt(v80.Silence, 92 - 62, true);
									if (((13362 - 9610) == (1113 + 2639)) and v90) then
										return v90;
									end
									v90 = v89.Interrupt(v80.Silence, 16 + 14, true, v17, v82.SilenceMouseover);
									if (((10259 - 6213) > (1796 + 899)) and v90) then
										return v90;
									end
									v90 = v89.InterruptWithStun(v80.PsychicScream, 38 - 30);
									if (v90 or ((5255 - (1596 + 114)) == (8346 - 5149))) then
										return v90;
									end
								end
								v220 = 714 - (164 + 549);
							end
							if (((3832 - (1059 + 379)) > (462 - 89)) and ((2 + 0) == v220)) then
								v100 = ((v80.VoidEruption:CooldownRemains() <= (v13:GCD() * (1 + 2))) and v80.VoidEruption:IsAvailable()) or (v80.DarkAscension:CooldownUp() and v80.DarkAscension:IsAvailable()) or (v80.VoidTorrent:IsAvailable() and v80.PsychicLink:IsAvailable() and (v80.VoidTorrent:CooldownRemains() <= (396 - (145 + 247))) and v13:BuffDown(v80.VoidformBuff));
								if (((3410 + 745) <= (1956 + 2276)) and (v105 == nil)) then
									v105 = v14:GUID();
								end
								if (((v104 == false) and v29 and (v14:GUID() == v105) and not v110(v14, true)) or ((10616 - 7035) == (667 + 2806))) then
									v90 = v133();
									if (((4303 + 692) > (5435 - 2087)) and v90) then
										return v90;
									end
									if (v23(v80.Pool) or ((1474 - (254 + 466)) > (4284 - (544 + 16)))) then
										return "Pool for Opener()";
									end
								else
									v104 = true;
								end
								v220 = 9 - 6;
							end
							if (((845 - (294 + 334)) >= (310 - (236 + 17))) and (v220 == (2 + 1))) then
								if (v16 or ((1612 + 458) >= (15203 - 11166))) then
									if (((12806 - 10101) == (1393 + 1312)) and v41) then
										v90 = v141();
										if (((51 + 10) == (855 - (413 + 381))) and v90) then
											return v90;
										end
									end
								end
								if ((v80.DispelMagic:IsReady() and v31 and v42 and not v13:IsCasting() and not v13:IsChanneling() and v89.UnitHasMagicBuff(v14)) or ((30 + 669) >= (2755 - 1459))) then
									if (v23(v80.DispelMagic, not v14:IsSpellInRange(v80.DispelMagic)) or ((4631 - 2848) >= (5586 - (582 + 1388)))) then
										return "dispel_magic damage";
									end
								end
								if ((v88 > (2 - 0)) or (v87 > (3 + 0)) or ((4277 - (326 + 38)) > (13391 - 8864))) then
									v90 = v138();
									if (((6246 - 1870) > (1437 - (47 + 573))) and v90) then
										return v90;
									end
									if (((1714 + 3147) > (3499 - 2675)) and v23(v80.Pool)) then
										return "Pool for AoE()";
									end
								end
								v220 = 5 - 1;
							end
							if (((1665 - (1269 + 395)) == v220) or ((1875 - (76 + 416)) >= (2574 - (319 + 124)))) then
								if (v43 or ((4288 - 2412) >= (3548 - (564 + 443)))) then
									local v221 = 0 - 0;
									while true do
										if (((2240 - (337 + 121)) <= (11052 - 7280)) and (v221 == (0 - 0))) then
											v90 = v89.HandleAfflicted(v80.PurifyDisease, v82.PurifyDiseaseMouseover, 1951 - (1261 + 650));
											if (v90 or ((1989 + 2711) < (1294 - 481))) then
												return v90;
											end
											break;
										end
									end
								end
								if (((5016 - (772 + 1045)) < (572 + 3478)) and v44) then
									v90 = v89.HandleIncorporeal(v80.DominateMind, v82.DominateMindMouseover, 174 - (102 + 42), true);
									if (v90 or ((6795 - (1524 + 320)) < (5700 - (1049 + 221)))) then
										return v90;
									end
									v90 = v89.HandleIncorporeal(v80.ShackleUndead, v82.ShackleUndeadMouseover, 186 - (18 + 138), true);
									if (((234 - 138) == (1198 - (67 + 1035))) and v90) then
										return v90;
									end
								end
								v98 = false;
								v220 = 350 - (136 + 212);
							end
						end
					end
					if (v23(v80.Pool) or ((11638 - 8899) > (3211 + 797))) then
						return "Pool for Main()";
					end
				end
				break;
			end
			if (((2 + 0) == v202) or ((1627 - (240 + 1364)) == (2216 - (1050 + 32)))) then
				if (AOE or ((9615 - 6922) >= (2432 + 1679))) then
					v87 = #v84;
					v88 = v14:GetEnemiesInSplashRangeCount(1065 - (331 + 724));
				else
					v87 = 1 + 0;
					v88 = 645 - (269 + 375);
				end
				if (v13:IsDeadOrGhost() or ((5041 - (267 + 458)) <= (668 + 1478))) then
					return;
				end
				if (not v13:IsMoving() or ((6818 - 3272) <= (3627 - (667 + 151)))) then
					v28 = GetTime();
				end
				if (((6401 - (1410 + 87)) > (4063 - (1504 + 393))) and (v13:AffectingCombat() or v41)) then
					local v217 = 0 - 0;
					local v218;
					while true do
						if (((282 - 173) >= (886 - (461 + 335))) and ((0 + 0) == v217)) then
							v218 = v41 and v80.Purify:IsReady();
							v90 = v89.FocusUnit(v218, nil, nil, nil);
							v217 = 1762 - (1730 + 31);
						end
						if (((6645 - (728 + 939)) > (10288 - 7383)) and (v217 == (1 - 0))) then
							if (v90 or ((6932 - 3906) <= (3348 - (138 + 930)))) then
								return v90;
							end
							break;
						end
					end
				end
				v202 = 3 + 0;
			end
		end
	end
	local function v144()
		v108();
		v80.VampiricTouchDebuff:RegisterAuraTracking();
		v20.Print("Shadow Priest by Epic BoomK");
		EpicSettings.SetupVersion("Shadow Priest X v 10.2.00 By BoomK");
	end
	v20.SetAPL(202 + 56, v143, v144);
end;
return v0["Epix_Priest_Shadow.lua"]();

