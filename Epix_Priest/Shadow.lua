local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((2980 - (1347 + 301)) < (6100 - (251 + 873))) and (v5 == (789 - (45 + 744)))) then
			v6 = v0[v4];
			if (((17638 - 13010) == (6162 - (709 + 825))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (1 - 0)) or ((918 - (196 + 668)) == (1559 - 1164))) then
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
	local v28 = 0 - 0;
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
	local v79 = v18.Priest.Shadow;
	local v80 = v19.Priest.Shadow;
	local v81 = v21.Priest.Shadow;
	local v82 = {};
	local v83, v84, v85;
	local v86, v87;
	local v88 = v20.Commons.Everyone;
	local v89;
	local v90 = 11944 - (171 + 662);
	local v91 = 11204 - (4 + 89);
	local v92 = false;
	local v93 = false;
	local v94 = 0 - 0;
	local v95 = false;
	local v96 = false;
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = ((v79.Mindbender:IsAvailable()) and v79.Mindbender) or v79.Shadowfiend;
	local v101 = false;
	local v102 = 0 + 0;
	local v103 = false;
	local v104 = nil;
	local v105;
	local v106;
	v10:RegisterForEvent(function()
		local v144 = 0 - 0;
		while true do
			if (((33 + 49) == (1568 - (35 + 1451))) and (v144 == (1458 - (28 + 1425)))) then
				v104 = nil;
				break;
			end
			if ((v144 == (1995 - (941 + 1052))) or ((558 + 23) < (1796 - (822 + 692)))) then
				v94 = 0 - 0;
				v95 = false;
				v96 = false;
				v144 = 2 + 1;
			end
			if ((v144 == (301 - (45 + 252))) or ((4561 + 48) < (859 + 1636))) then
				v101 = false;
				v102 = 0 - 0;
				v103 = false;
				v144 = 438 - (114 + 319);
			end
			if (((1653 - 501) == (1475 - 323)) and (v144 == (1 + 0))) then
				v93 = false;
				VarMindSearCutoff = 2 - 0;
				VarPoolAmount = 125 - 65;
				v144 = 1965 - (556 + 1407);
			end
			if (((3102 - (741 + 465)) <= (3887 - (170 + 295))) and (v144 == (0 + 0))) then
				v90 = 10206 + 905;
				v91 = 27355 - 16244;
				v92 = false;
				v144 = 1 + 0;
			end
			if ((v144 == (2 + 1)) or ((561 + 429) > (2850 - (957 + 273)))) then
				v97 = false;
				v98 = false;
				v99 = false;
				v144 = 2 + 2;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v107()
		v88.DispellableDebuffs = v88.DispellableDiseaseDebuffs;
	end
	v10:RegisterForEvent(function()
		v107();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v10:RegisterForEvent(function()
		v100 = ((v79.Mindbender:IsAvailable()) and v79.Mindbender) or v79.Shadowfiend;
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v147 = 0 + 0;
		while true do
			if ((v147 == (0 - 0)) or ((2310 - 1433) > (14340 - 9645))) then
				v79.ShadowCrash:RegisterInFlightEffect(1017006 - 811620);
				v79.ShadowCrash:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v79.ShadowCrash:RegisterInFlightEffect(207166 - (389 + 1391));
	v79.ShadowCrash:RegisterInFlight();
	local function v108()
		local v148 = 0 + 0;
		local v149;
		while true do
			if (((281 + 2410) >= (4213 - 2362)) and (v148 == (952 - (783 + 168)))) then
				if (v13:BuffUp(v79.DarkEvangelismBuff) or ((10018 - 7033) >= (4777 + 79))) then
					v149 = v149 * ((312 - (309 + 2)) + ((0.01 - 0) * v13:BuffStack(v79.DarkEvangelismBuff)));
				end
				if (((5488 - (1090 + 122)) >= (388 + 807)) and (v13:BuffUp(v79.DevouredFearBuff) or v13:BuffUp(v79.DevouredPrideBuff))) then
					v149 = v149 * (3.05 - 2);
				end
				v148 = 2 + 0;
			end
			if (((4350 - (628 + 490)) <= (841 + 3849)) and (v148 == (0 - 0))) then
				v149 = 4 - 3;
				if (v13:BuffUp(v79.DarkAscensionBuff) or ((1670 - (431 + 343)) >= (6353 - 3207))) then
					v149 = v149 * (2.25 - 1);
				end
				v148 = 1 + 0;
			end
			if (((392 + 2669) >= (4653 - (556 + 1139))) and (v148 == (18 - (6 + 9)))) then
				if (((584 + 2603) >= (330 + 314)) and v79.Voidtouched:IsAvailable()) then
					v149 = v149 * (170.06 - (28 + 141));
				end
				return v149;
			end
			if (((250 + 394) <= (868 - 164)) and (v148 == (2 + 0))) then
				if (((2275 - (486 + 831)) > (2464 - 1517)) and v79.DistortedReality:IsAvailable()) then
					v149 = v149 * (3.2 - 2);
				end
				if (((849 + 3643) >= (8391 - 5737)) and v13:BuffUp(v79.MindDevourerBuff)) then
					v149 = v149 * (1264.2 - (668 + 595));
				end
				v148 = 3 + 0;
			end
		end
	end
	v79.DevouringPlague:RegisterPMultiplier(v79.DevouringPlagueDebuff, v108);
	local function v109(v150, v151)
		if (((694 + 2748) >= (4098 - 2595)) and v151) then
			return v150:DebuffUp(v79.ShadowWordPainDebuff) and v150:DebuffUp(v79.VampiricTouchDebuff) and v150:DebuffUp(v79.DevouringPlagueDebuff);
		else
			return v150:DebuffUp(v79.ShadowWordPainDebuff) and v150:DebuffUp(v79.VampiricTouchDebuff);
		end
	end
	local function v110(v152, v153)
		local v154 = 290 - (23 + 267);
		local v155;
		local v156;
		while true do
			if ((v154 == (1946 - (1129 + 815))) or ((3557 - (371 + 16)) <= (3214 - (1326 + 424)))) then
				return v156;
			end
			if ((v154 == (1 - 0)) or ((17529 - 12732) == (4506 - (88 + 30)))) then
				v156 = nil;
				for v216, v217 in pairs(v152) do
					local v218 = 771 - (720 + 51);
					local v219;
					while true do
						if (((1225 - 674) <= (2457 - (421 + 1355))) and (v218 == (0 - 0))) then
							v219 = v217:TimeToDie();
							if (((1610 + 1667) > (1490 - (286 + 797))) and v153) then
								if (((17163 - 12468) >= (2343 - 928)) and ((v219 * v25(v217:DebuffRefreshable(v79.VampiricTouchDebuff))) > v155)) then
									local v234 = 439 - (397 + 42);
									while true do
										if ((v234 == (0 + 0)) or ((4012 - (24 + 776)) <= (1453 - 509))) then
											v155 = v219;
											v156 = v217;
											break;
										end
									end
								end
							elseif ((v219 > v155) or ((3881 - (222 + 563)) <= (3961 - 2163))) then
								local v235 = 0 + 0;
								while true do
									if (((3727 - (23 + 167)) == (5335 - (690 + 1108))) and (v235 == (0 + 0))) then
										v155 = v219;
										v156 = v217;
										break;
									end
								end
							end
							break;
						end
					end
				end
				v154 = 2 + 0;
			end
			if (((4685 - (40 + 808)) >= (259 + 1311)) and (v154 == (0 - 0))) then
				if (not v152 or ((2820 + 130) == (2017 + 1795))) then
					return nil;
				end
				v155 = 0 + 0;
				v154 = 572 - (47 + 524);
			end
		end
	end
	local function v111(v157)
		return (v157:DebuffRemains(v79.ShadowWordPainDebuff));
	end
	local function v112(v158)
		return (v158:TimeToDie());
	end
	local function v113(v159)
		return (v159:DebuffRemains(v79.VampiricTouchDebuff));
	end
	local function v114(v160)
		return v160:DebuffRefreshable(v79.VampiricTouchDebuff) and (v160:TimeToDie() >= (8 + 4)) and (((v79.ShadowCrash:CooldownRemains() >= v160:DebuffRemains(v79.VampiricTouchDebuff)) and not v79.ShadowCrash:InFlight()) or v97 or not v79.WhisperingShadows:IsAvailable());
	end
	local function v115(v161)
		return not v79.DistortedReality:IsAvailable() or (v87 == (2 - 1)) or (v161:DebuffRemains(v79.DevouringPlagueDebuff) <= v106) or (v13:InsanityDeficit() <= (23 - 7));
	end
	local function v116(v162)
		return (v162:DebuffRemains(v79.DevouringPlagueDebuff) <= v106) or not v79.DistortedReality:IsAvailable();
	end
	local function v117(v163)
		return ((v163:DebuffRemains(v79.DevouringPlagueDebuff) > v79.MindBlast:ExecuteTime()) and (v79.MindBlast:FullRechargeTime() <= (v106 + v79.MindBlast:ExecuteTime()))) or (v102 <= (v79.MindBlast:ExecuteTime() + v106));
	end
	local function v118(v164)
		return v109(v164, true) and (v164:DebuffRemains(v79.DevouringPlagueDebuff) >= v79.Mindgames:CastTime());
	end
	local function v119(v165)
		return v165:DebuffRefreshable(v79.VampiricTouchDebuff) or ((v165:DebuffRemains(v79.VampiricTouchDebuff) <= v165:TimeToDie()) and v13:BuffDown(v79.VoidformBuff));
	end
	local function v120(v166)
		return ((v166:HealthPercentage() < (45 - 25)) and ((v100:CooldownRemains() >= (1736 - (1165 + 561))) or not v79.InescapableTorment:IsAvailable())) or (v101 and v79.InescapableTorment:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff);
	end
	local function v121(v167)
		return (v167:HealthPercentage() < (1 + 19)) or v13:BuffUp(v79.DeathspeakerBuff) or v13:HasTier(95 - 64, 1 + 1);
	end
	local function v122(v168)
		return v168:HealthPercentage() < (499 - (341 + 138));
	end
	local function v123(v169)
		return v169:DebuffUp(v79.DevouringPlagueDebuff) and (v102 <= (1 + 1)) and v101 and v79.InescapableTorment:IsAvailable() and (v87 <= (14 - 7));
	end
	local function v111(v170)
		return (v170:DebuffRemains(v79.ShadowWordPainDebuff));
	end
	local function v124(v171)
		return v171:DebuffRemains(v79.DevouringPlagueDebuff) >= (328.5 - (89 + 237));
	end
	local function v125(v172)
		return v172:DebuffRefreshable(v79.VampiricTouchDebuff) and (v172:TimeToDie() >= (57 - 39)) and (v172:DebuffUp(v79.VampiricTouchDebuff) or not v96);
	end
	local function v126(v173)
		local v174 = 0 - 0;
		while true do
			if (((5604 - (581 + 300)) >= (3538 - (855 + 365))) and ((0 - 0) == v174)) then
				if ((v79.ShadowCrash:CooldownRemains() >= v173:DebuffRemains(v79.VampiricTouchDebuff)) or v97 or ((662 + 1365) > (4087 - (1030 + 205)))) then
					return v173:DebuffRefreshable(v79.VampiricTouchDebuff) and (v173:TimeToDie() >= (17 + 1)) and (v173:DebuffUp(v79.VampiricTouchDebuff) or not v96);
				end
				return nil;
			end
		end
	end
	local function v127(v175)
		return (v109(v175, false));
	end
	local function v128()
		local v176 = 0 + 0;
		local v177;
		while true do
			if ((v176 == (287 - (156 + 130))) or ((2581 - 1445) > (7275 - 2958))) then
				v177 = v13:IsInParty() and not v13:IsInRaid();
				if (((9724 - 4976) == (1252 + 3496)) and v79.ShadowCrash:IsCastable() and not v177) then
					if (((2179 + 1557) <= (4809 - (10 + 59))) and (v76 == "Confirm")) then
						if (v23(v79.ShadowCrash, not v14:IsInRange(12 + 28)) or ((16694 - 13304) <= (4223 - (671 + 492)))) then
							return "shadow_crash precombat 8";
						end
					elseif ((v76 == "Enemy Under Cursor") or ((796 + 203) > (3908 - (369 + 846)))) then
						if (((123 + 340) < (513 + 88)) and v17:Exists() and v13:CanAttack(v17)) then
							if (v23(v81.ShadowCrashCursor, not v14:IsInRange(1985 - (1036 + 909))) or ((1736 + 447) < (1152 - 465))) then
								return "shadow_crash precombat 8";
							end
						end
					elseif (((4752 - (11 + 192)) == (2299 + 2250)) and (v76 == "At Cursor")) then
						if (((4847 - (135 + 40)) == (11319 - 6647)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(25 + 15))) then
							return "shadow_crash precombat 8";
						end
					end
				end
				v176 = 4 - 2;
			end
			if (((2 - 0) == v176) or ((3844 - (50 + 126)) < (1099 - 704))) then
				if ((v79.VampiricTouch:IsCastable() and (not v79.ShadowCrash:IsAvailable() or (v79.ShadowCrash:CooldownDown() and not v79.ShadowCrash:InFlight()) or v177)) or ((923 + 3243) == (1868 - (1233 + 180)))) then
					if (v23(v79.VampiricTouch, not v14:IsSpellInRange(v79.VampiricTouch), true) or ((5418 - (522 + 447)) == (4084 - (107 + 1314)))) then
						return "vampiric_touch precombat 14";
					end
				end
				if ((v79.ShadowWordPain:IsCastable() and not v79.Misery:IsAvailable()) or ((1985 + 2292) < (9107 - 6118))) then
					if (v23(v79.ShadowWordPain, not v14:IsSpellInRange(v79.ShadowWordPain)) or ((370 + 500) >= (8238 - 4089))) then
						return "shadow_word_pain precombat 16";
					end
				end
				break;
			end
			if (((8752 - 6540) < (5093 - (716 + 1194))) and (v176 == (0 + 0))) then
				v104 = v14:GUID();
				if (((498 + 4148) > (3495 - (74 + 429))) and v79.ArcaneTorrent:IsCastable() and v30) then
					if (((2765 - 1331) < (1540 + 1566)) and v23(v79.ArcaneTorrent, not v14:IsSpellInRange(v79.ArcaneTorrent))) then
						return "arcane_torrent precombat 6";
					end
				end
				v176 = 2 - 1;
			end
		end
	end
	local function v129()
		local v178 = 0 + 0;
		while true do
			if (((2422 - 1636) < (7474 - 4451)) and (v178 == (433 - (279 + 154)))) then
				v92 = v109(v14, false) or (v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable());
				v93 = v109(v14, true);
				v178 = 779 - (454 + 324);
			end
			if ((v178 == (1 + 0)) or ((2459 - (12 + 5)) < (40 + 34))) then
				v99 = ((v79.VoidEruption:CooldownRemains() <= (v13:GCD() * (7 - 4))) and v79.VoidEruption:IsAvailable()) or (v79.DarkAscension:CooldownUp() and v79.DarkAscension:IsAvailable()) or (v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (2 + 2)) and v13:BuffDown(v79.VoidformBuff));
				break;
			end
		end
	end
	local function v130()
		local v179 = 1093 - (277 + 816);
		local v180;
		while true do
			if (((19378 - 14843) == (5718 - (1058 + 125))) and (v179 == (1 + 1))) then
				v96 = ((v79.VampiricTouchDebuff:AuraActiveCount() + ((983 - (815 + 160)) * v25(v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable()))) >= v94) or not v95;
				if ((v97 and v79.WhisperingShadows:IsAvailable()) or ((12910 - 9901) <= (4996 - 2891))) then
					v97 = (v94 - v79.VampiricTouchDebuff:AuraActiveCount()) < (1 + 3);
				end
				v179 = 8 - 5;
			end
			if (((3728 - (41 + 1857)) < (5562 - (1222 + 671))) and (v179 == (7 - 4))) then
				v98 = ((v79.VampiricTouchDebuff:AuraActiveCount() + ((11 - 3) * v25(not v97))) >= v94) or not v95;
				break;
			end
			if (((1183 - (229 + 953)) == v179) or ((3204 - (1111 + 663)) >= (5191 - (874 + 705)))) then
				v180 = v110(v85, true);
				if (((376 + 2307) >= (1679 + 781)) and v180 and (v180:TimeToDie() >= (37 - 19))) then
					v95 = true;
				end
				v179 = 1 + 1;
			end
			if ((v179 == (679 - (642 + 37))) or ((412 + 1392) >= (524 + 2751))) then
				v94 = v27(v87, v78);
				v95 = false;
				v179 = 2 - 1;
			end
		end
	end
	local function v131()
		if (v13:BuffUp(v79.VoidformBuff) or v13:BuffUp(v79.PowerInfusionBuff) or v13:BuffUp(v79.DarkAscensionBuff) or (v91 < (474 - (233 + 221))) or ((3276 - 1859) > (3195 + 434))) then
			local v209 = 1541 - (718 + 823);
			while true do
				if (((3018 + 1777) > (1207 - (266 + 539))) and (v209 == (0 - 0))) then
					v89 = v88.HandleTopTrinket(v82, v30, 1265 - (636 + 589), nil);
					if (((11424 - 6611) > (7352 - 3787)) and v89) then
						return v89;
					end
					v209 = 1 + 0;
				end
				if (((1422 + 2490) == (4927 - (657 + 358))) and (v209 == (2 - 1))) then
					v89 = v88.HandleBottomTrinket(v82, v30, 91 - 51, nil);
					if (((4008 - (1151 + 36)) <= (4659 + 165)) and v89) then
						return v89;
					end
					break;
				end
			end
		end
	end
	local function v132()
		if (((457 + 1281) <= (6555 - 4360)) and v79.ShadowCrash:IsCastable() and (v14:DebuffDown(v79.VampiricTouchDebuff))) then
			if (((1873 - (1552 + 280)) <= (3852 - (64 + 770))) and (v76 == "Confirm")) then
				if (((1457 + 688) <= (9316 - 5212)) and v23(v79.ShadowCrash, not v14:IsInRange(8 + 32))) then
					return "shadow_crash opener 2";
				end
			elseif (((3932 - (157 + 1086)) < (9697 - 4852)) and (v76 == "Enemy Under Cursor")) then
				if ((v17:Exists() and v13:CanAttack(v17)) or ((10169 - 7847) > (4021 - 1399))) then
					if (v23(v81.ShadowCrashCursor, not v14:IsInRange(54 - 14)) or ((5353 - (599 + 220)) == (4145 - 2063))) then
						return "shadow_crash opener 2";
					end
				end
			elseif ((v76 == "At Cursor") or ((3502 - (1813 + 118)) > (1365 + 502))) then
				if (v23(v81.ShadowCrashCursor, not v14:IsInRange(1257 - (841 + 376))) or ((3718 - 1064) >= (696 + 2300))) then
					return "shadow_crash opener 2";
				end
			end
		end
		if (((10857 - 6879) > (2963 - (464 + 395))) and v79.VampiricTouch:IsCastable() and v14:DebuffDown(v79.VampiricTouchDebuff) and (v79.ShadowCrash:CooldownDown() or not v79.ShadowCrash:IsAvailable())) then
			if (((7686 - 4691) > (741 + 800)) and v22(v79.VampiricTouch, nil, nil, not v14:IsSpellInRange(v79.VampiricTouch))) then
				return "vampiric_touch opener 3";
			end
		end
		if (((4086 - (467 + 370)) > (1968 - 1015)) and v100:IsCastable() and v30) then
			if (v23(v100) or ((2403 + 870) > (15676 - 11103))) then
				return "mindbender opener 4";
			end
		end
		if (v79.DarkAscension:IsCastable() or ((492 + 2659) < (2986 - 1702))) then
			if (v23(v79.DarkAscension) or ((2370 - (150 + 370)) == (2811 - (74 + 1208)))) then
				return "dark_ascension opener 6";
			end
		end
		if (((2019 - 1198) < (10068 - 7945)) and v79.VoidEruption:IsAvailable()) then
			local v210 = 0 + 0;
			while true do
				if (((1292 - (14 + 376)) < (4032 - 1707)) and (v210 == (1 + 0))) then
					if (((754 + 104) <= (2825 + 137)) and v79.VoidEruption:IsCastable()) then
						if (v23(v79.VoidEruption, not v14:IsInRange(117 - 77), true) or ((2969 + 977) < (1366 - (23 + 55)))) then
							return "void_eruption opener 12";
						end
					end
					break;
				end
				if ((v210 == (0 - 0)) or ((2164 + 1078) == (510 + 57))) then
					if ((v79.ShadowWordDeath:IsCastable() and v79.InescapableTorment:IsAvailable() and v13:PrevGCDP(1 - 0, v79.MindBlast) and (v79.ShadowWordDeath:TimeSinceLastCast() > (7 + 13))) or ((1748 - (652 + 249)) >= (3379 - 2116))) then
						if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((4121 - (708 + 1160)) == (5024 - 3173))) then
							return "shadow_word_death opener 8";
						end
					end
					if (v79.MindBlast:IsCastable() or ((3804 - 1717) > (2399 - (10 + 17)))) then
						if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((999 + 3446) < (5881 - (1400 + 332)))) then
							return "mind_blast opener 10";
						end
					end
					v210 = 1 - 0;
				end
			end
		end
		v89 = v131();
		if (v89 or ((3726 - (242 + 1666)) == (37 + 48))) then
			return v89;
		end
		if (((231 + 399) < (1813 + 314)) and v79.VoidBolt:IsCastable()) then
			if (v23(v79.VoidBolt, not v14:IsInRange(980 - (850 + 90))) or ((3394 - 1456) == (3904 - (360 + 1030)))) then
				return "void_bolt opener 16";
			end
		end
		if (((3766 + 489) >= (154 - 99)) and v79.DevouringPlague:IsReady()) then
			if (((4125 - 1126) > (2817 - (909 + 752))) and v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague))) then
				return "devouring_plague opener 18";
			end
		end
		if (((3573 - (109 + 1114)) > (2114 - 959)) and v79.MindBlast:IsCastable()) then
			if (((1569 + 2460) <= (5095 - (6 + 236))) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
				return "mind_blast opener 20";
			end
		end
		if (v79.MindSpike:IsCastable() or ((326 + 190) > (2765 + 669))) then
			if (((9541 - 5495) >= (5297 - 2264)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
				return "mind_spike opener 22";
			end
		end
		if (v79.MindFlay:IsCastable() or ((3852 - (1076 + 57)) <= (238 + 1209))) then
			if (v23(v79.MindFlay, not v14:IsSpellInRange(v79.MindFlay), true) or ((4823 - (579 + 110)) < (310 + 3616))) then
				return "mind_flay opener 24";
			end
		end
	end
	local function v133()
		local v181 = 0 + 0;
		while true do
			if ((v181 == (0 + 0)) or ((571 - (174 + 233)) >= (7779 - 4994))) then
				if ((v79.VampiricTouch:IsCastable() and (v13:BuffUp(v79.UnfurlingDarknessBuff))) or ((921 - 396) == (938 + 1171))) then
					if (((1207 - (663 + 511)) == (30 + 3)) and v88.CastTargetIf(v79.VampiricTouch, v84, "min", v113, nil, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, nil, true)) then
						return "vampiric_touch filler 2";
					end
				end
				if (((664 + 2390) <= (12378 - 8363)) and v79.ShadowWordDeath:IsReady()) then
					if (((1133 + 738) < (7962 - 4580)) and v88.CastCycle(v79.ShadowWordDeath, v84, v121, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
						return "shadow_word_death filler 4";
					end
				end
				if (((3129 - 1836) <= (1034 + 1132)) and v79.MindSpikeInsanity:IsReady()) then
					if (v23(v79.MindSpikeInsanity, not v14:IsSpellInRange(v79.MindSpikeInsanity), true) or ((5019 - 2440) < (88 + 35))) then
						return "mind_spike_insanity filler 6";
					end
				end
				v181 = 1 + 0;
			end
			if ((v181 == (723 - (478 + 244))) or ((1363 - (440 + 77)) >= (1077 + 1291))) then
				if ((v79.MindFlay:IsCastable() and (v13:BuffUp(v79.MindFlayInsanityBuff))) or ((14683 - 10671) <= (4914 - (655 + 901)))) then
					if (((278 + 1216) <= (2301 + 704)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
						return "mind_flay filler 8";
					end
				end
				if (v79.Mindgames:IsReady() or ((2101 + 1010) == (8596 - 6462))) then
					if (((3800 - (695 + 750)) == (8041 - 5686)) and v23(v79.Mindgames, not v14:IsInRange(61 - 21), true)) then
						return "mindgames filler 10";
					end
				end
				if ((v79.ShadowWordDeath:IsReady() and v79.InescapableTorment:IsAvailable() and v101) or ((2364 - 1776) <= (783 - (285 + 66)))) then
					if (((11181 - 6384) >= (5205 - (682 + 628))) and v88.CastTargetIf(v79.ShadowWordDeath, v84, "min", v112, nil, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
						return "shadow_word_death filler 12";
					end
				end
				v181 = 1 + 1;
			end
			if (((3876 - (176 + 123)) == (1497 + 2080)) and (v181 == (2 + 0))) then
				if (((4063 - (239 + 30)) > (1004 + 2689)) and v79.DivineStar:IsReady() and (v16:HealthPercentage() < v65) and v64) then
					if (v23(v81.DivineStarPlayer, not v16:IsInRange(29 + 1)) or ((2256 - 981) == (12791 - 8691))) then
						return "divine_star heal";
					end
				end
				if ((v79.Halo:IsReady() and v88.TargetIsValid() and v14:IsInRange(345 - (306 + 9)) and v61 and v88.AreUnitsBelowHealthPercentage(v62, v63, v79.FlashHeal)) or ((5551 - 3960) >= (623 + 2957))) then
					if (((604 + 379) <= (871 + 937)) and v23(v79.Halo, nil, true)) then
						return "halo heal";
					end
				end
				if (v79.MindSpike:IsCastable() or ((6148 - 3998) <= (2572 - (1140 + 235)))) then
					if (((2399 + 1370) >= (1076 + 97)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
						return "mind_spike filler 16";
					end
				end
				v181 = 1 + 2;
			end
			if (((1537 - (33 + 19)) == (537 + 948)) and (v181 == (11 - 7))) then
				if ((v79.ShadowWordDeath:IsReady() and v13:IsMoving()) or ((1461 + 1854) <= (5455 - 2673))) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((822 + 54) >= (3653 - (586 + 103)))) then
						return "shadow_word_death movement filler 26";
					end
				end
				if ((v79.ShadowWordPain:IsReady() and v13:IsMoving()) or ((204 + 2028) > (7687 - 5190))) then
					if (v88.CastTargetIf(v79.ShadowWordPain, v84, "min", v111, nil, not v14:IsSpellInRange(v79.ShadowWordPain)) or ((3598 - (1309 + 179)) <= (598 - 266))) then
						return "shadow_word_pain filler 28";
					end
				end
				break;
			end
			if (((1605 + 2081) > (8518 - 5346)) and (v181 == (3 + 0))) then
				if (v105:IsCastable() or ((9505 - 5031) < (1633 - 813))) then
					if (((4888 - (295 + 314)) >= (7078 - 4196)) and v23(v105, not v14:IsSpellInRange(v105), true)) then
						return "mind_flay filler 18";
					end
				end
				if (v79.ShadowCrash:IsCastable() or ((3991 - (1300 + 662)) >= (11056 - 7535))) then
					if ((v76 == "Confirm") or ((3792 - (1178 + 577)) >= (2411 + 2231))) then
						if (((5084 - 3364) < (5863 - (851 + 554))) and v23(v79.ShadowCrash, not v14:IsInRange(36 + 4))) then
							return "shadow_crash filler 20";
						end
					elseif ((v76 == "Enemy Under Cursor") or ((1208 - 772) > (6560 - 3539))) then
						if (((1015 - (115 + 187)) <= (649 + 198)) and v17:Exists() and v13:CanAttack(v17)) then
							if (((2040 + 114) <= (15884 - 11853)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(1201 - (160 + 1001)))) then
								return "shadow_crash filler 20";
							end
						end
					elseif (((4038 + 577) == (3185 + 1430)) and (v76 == "At Cursor")) then
						if (v23(v81.ShadowCrashCursor, not v14:IsInRange(81 - 41)) or ((4148 - (237 + 121)) == (1397 - (525 + 372)))) then
							return "shadow_crash filler 20";
						end
					end
				end
				if (((168 - 79) < (725 - 504)) and v79.ShadowWordDeath:IsReady()) then
					if (((2196 - (96 + 46)) >= (2198 - (643 + 134))) and v88.CastCycle(v79.ShadowWordDeath, v84, v122, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
						return "shadow_word_death filler 22";
					end
				end
				v181 = 2 + 2;
			end
		end
	end
	local function v134()
		local v182 = 0 - 0;
		while true do
			if (((2568 - 1876) < (2933 + 125)) and (v182 == (3 - 1))) then
				if ((v79.DivineStar:IsReady() and (v87 > (1 - 0)) and v80.BelorrelostheSuncaller:IsEquipped() and (v80.BelorrelostheSuncaller:CooldownRemains() <= v106)) or ((3973 - (316 + 403)) == (1101 + 554))) then
					if (v23(v81.DivineStarPlayer, not v16:IsInRange(82 - 52)) or ((469 + 827) == (12365 - 7455))) then
						return "divine_star cds 16";
					end
				end
				if (((2387 + 981) == (1086 + 2282)) and v79.VoidEruption:IsCastable() and v100:CooldownDown() and ((v101 and (v100:CooldownRemains() >= (13 - 9))) or not v79.Mindbender:IsAvailable() or ((v87 > (9 - 7)) and not v79.InescapableTorment:IsAvailable())) and ((v79.MindBlast:Charges() == (0 - 0)) or (v10.CombatTime() > (1 + 14)))) then
					if (((5202 - 2559) < (187 + 3628)) and v23(v79.VoidEruption)) then
						return "void_eruption cds 20";
					end
				end
				v182 = 8 - 5;
			end
			if (((1930 - (12 + 5)) > (1914 - 1421)) and (v182 == (5 - 2))) then
				if (((10107 - 5352) > (8500 - 5072)) and v79.DarkAscension:IsCastable() and not v13:IsCasting(v79.DarkAscension) and ((v101 and (v100:CooldownRemains() >= (1 + 3))) or (not v79.Mindbender:IsAvailable() and v100:CooldownDown()) or ((v87 > (1975 - (1656 + 317))) and not v79.InescapableTorment:IsAvailable()))) then
					if (((1231 + 150) <= (1899 + 470)) and v23(v79.DarkAscension)) then
						return "dark_ascension cds 22";
					end
				end
				if (v30 or ((12877 - 8034) == (20099 - 16015))) then
					local v220 = 354 - (5 + 349);
					while true do
						if (((22176 - 17507) > (1634 - (266 + 1005))) and (v220 == (0 + 0))) then
							v89 = v131();
							if (v89 or ((6404 - 4527) >= (4130 - 992))) then
								return v89;
							end
							break;
						end
					end
				end
				break;
			end
			if (((6438 - (561 + 1135)) >= (4724 - 1098)) and (v182 == (0 - 0))) then
				if ((v79.Fireblood:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (1074 - (507 + 559))))) or ((11392 - 6852) == (2832 - 1916))) then
					if (v23(v79.Fireblood) or ((1544 - (212 + 176)) > (5250 - (250 + 655)))) then
						return "fireblood cds 4";
					end
				end
				if (((6100 - 3863) < (7424 - 3175)) and v79.Berserking:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (18 - 6)))) then
					if (v23(v79.Berserking) or ((4639 - (1869 + 87)) < (79 - 56))) then
						return "berserking cds 6";
					end
				end
				v182 = 1902 - (484 + 1417);
			end
			if (((1493 - 796) <= (1383 - 557)) and (v182 == (774 - (48 + 725)))) then
				if (((1805 - 700) <= (3154 - 1978)) and v79.BloodFury:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (9 + 6)))) then
					if (((9029 - 5650) <= (1067 + 2745)) and v23(v79.BloodFury)) then
						return "blood_fury cds 8";
					end
				end
				if ((v79.AncestralCall:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (5 + 10)))) or ((1641 - (152 + 701)) >= (2927 - (430 + 881)))) then
					if (((711 + 1143) <= (4274 - (557 + 338))) and v23(v79.AncestralCall)) then
						return "ancestral_call cds 10";
					end
				end
				v182 = 1 + 1;
			end
		end
	end
	local function v135()
		local v183 = 0 - 0;
		while true do
			if (((15929 - 11380) == (12085 - 7536)) and (v183 == (8 - 4))) then
				if ((v79.VoidTorrent:IsCastable() and not v97) or ((3823 - (499 + 302)) >= (3890 - (39 + 827)))) then
					if (((13305 - 8485) > (4908 - 2710)) and v88.CastCycle(v79.VoidTorrent, v84, v124, not v14:IsSpellInRange(v79.VoidTorrent), nil, nil, v81.VoidTorrentMouseover, true)) then
						return "void_torrent main 28";
					end
				end
				v89 = v133();
				if (v89 or ((4214 - 3153) >= (7508 - 2617))) then
					return v89;
				end
				break;
			end
			if (((117 + 1247) <= (13091 - 8618)) and (v183 == (1 + 2))) then
				if ((v79.ShadowWordDeath:IsReady() and (v13:BuffStack(v79.DeathsTormentBuff) > (13 - 4)) and v13:HasTier(135 - (103 + 1), 558 - (475 + 79)) and (not v97 or not v79.ShadowCrash:IsAvailable())) or ((7771 - 4176) <= (9 - 6))) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((604 + 4068) == (3391 + 461))) then
						return "shadow_word_death main 22";
					end
				end
				if (((3062 - (1395 + 108)) == (4536 - 2977)) and v79.ShadowWordDeath:IsReady() and v92 and v79.InescapableTorment:IsAvailable() and v101 and ((not v79.InsidiousIre:IsAvailable() and not v79.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff)) and not v13:HasTier(1235 - (7 + 1197), 1 + 1)) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((612 + 1140) <= (1107 - (27 + 292)))) then
						return "shadow_word_death main 24";
					end
				end
				if (v79.VampiricTouch:IsCastable() or ((11448 - 7541) == (225 - 48))) then
					if (((14552 - 11082) > (1094 - 539)) and v88.CastTargetIf(v79.VampiricTouch, v84, "min", v113, v114, not v14:IsSpellInRange(v79.VampiricTouch))) then
						return "vampiric_touch main 26";
					end
				end
				if ((v79.MindBlast:IsCastable() and (v13:BuffDown(v79.MindDevourerBuff) or (v79.VoidEruption:CooldownUp() and v79.VoidEruption:IsAvailable()))) or ((1850 - 878) == (784 - (43 + 96)))) then
					if (((12979 - 9797) >= (4781 - 2666)) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
						return "mind_blast main 26";
					end
				end
				v183 = 4 + 0;
			end
			if (((1100 + 2793) < (8753 - 4324)) and (v183 == (0 + 0))) then
				v129();
				if ((v30 and ((v91 < (56 - 26)) or ((v14:TimeToDie() > (5 + 10)) and (not v97 or (v87 > (1 + 1)))))) or ((4618 - (1414 + 337)) < (3845 - (1642 + 298)))) then
					local v221 = 0 - 0;
					while true do
						if (((0 - 0) == v221) or ((5329 - 3533) >= (1334 + 2717))) then
							v89 = v134();
							if (((1260 + 359) <= (4728 - (357 + 615))) and v89) then
								return v89;
							end
							break;
						end
					end
				end
				if (((424 + 180) == (1481 - 877)) and v100:IsCastable() and v92 and ((v91 < (26 + 4)) or (v14:TimeToDie() > (32 - 17))) and (not v79.DarkAscension:IsAvailable() or (v79.DarkAscension:CooldownRemains() < v106) or (v91 < (12 + 3)))) then
					if (v23(v100) or ((305 + 4179) == (566 + 334))) then
						return "mindbender main 2";
					end
				end
				if (v79.DevouringPlague:IsReady() or ((5760 - (384 + 917)) <= (1810 - (128 + 569)))) then
					if (((5175 - (1407 + 136)) > (5285 - (687 + 1200))) and v88.CastCycle(v79.DevouringPlague, v84, v115, not v14:IsSpellInRange(v79.DevouringPlague))) then
						return "devouring_plague main 4";
					end
				end
				v183 = 1711 - (556 + 1154);
			end
			if (((14360 - 10278) <= (5012 - (9 + 86))) and (v183 == (423 - (275 + 146)))) then
				if (((786 + 4046) >= (1450 - (29 + 35))) and v79.DevouringPlague:IsReady() and (v91 <= (v79.DevouringPlagueDebuff:BaseDuration() + (17 - 13)))) then
					if (((408 - 271) == (604 - 467)) and v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague))) then
						return "devouring_plague main 14";
					end
				end
				if ((v79.DevouringPlague:IsReady() and ((v13:InsanityDeficit() <= (14 + 6)) or (v13:BuffUp(v79.VoidformBuff) and (v79.VoidBolt:CooldownRemains() > v13:BuffRemains(v79.VoidformBuff)) and (v79.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v79.VoidformBuff) + (1014 - (53 + 959))))) or (v13:BuffUp(v79.MindDevourerBuff) and (v13:PMultiplier(v79.DevouringPlague) < (409.2 - (312 + 96)))))) or ((2724 - 1154) >= (4617 - (147 + 138)))) then
					if (v88.CastCycle(v79.DevouringPlague, v84, v115, not v14:IsSpellInRange(v79.DevouringPlague), nil, nil, v81.DevouringPlagueMouseover) or ((4963 - (813 + 86)) <= (1644 + 175))) then
						return "devouring_plague main 16";
					end
				end
				if ((v79.ShadowWordDeath:IsReady() and (v13:HasTier(57 - 26, 494 - (18 + 474)))) or ((1683 + 3303) < (5137 - 3563))) then
					if (((5512 - (860 + 226)) > (475 - (121 + 182))) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
						return "shadow_word_death main 18";
					end
				end
				if (((73 + 513) > (1695 - (988 + 252))) and v79.ShadowCrash:IsCastable() and not v97 and (v14:DebuffRefreshable(v79.VampiricTouchDebuff) or ((v13:BuffStack(v79.DeathsTormentBuff) > (2 + 7)) and v13:HasTier(10 + 21, 1974 - (49 + 1921))))) then
					if (((1716 - (223 + 667)) == (878 - (51 + 1))) and (v76 == "Confirm")) then
						if (v23(v79.ShadowCrash, not v14:IsInRange(68 - 28)) or ((8605 - 4586) > (5566 - (146 + 979)))) then
							return "shadow_crash main 20";
						end
					elseif (((570 + 1447) < (4866 - (311 + 294))) and (v76 == "Enemy Under Cursor")) then
						if (((13151 - 8435) > (34 + 46)) and v17:Exists() and v13:CanAttack(v17)) then
							if (v23(v81.ShadowCrashCursor, not v14:IsInRange(1483 - (496 + 947))) or ((4865 - (1233 + 125)) == (1328 + 1944))) then
								return "shadow_crash main 20";
							end
						end
					elseif ((v76 == "At Cursor") or ((786 + 90) >= (585 + 2490))) then
						if (((5997 - (963 + 682)) > (2132 + 422)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(1544 - (504 + 1000)))) then
							return "shadow_crash main 20";
						end
					end
				end
				v183 = 3 + 0;
			end
			if ((v183 == (1 + 0)) or ((416 + 3990) < (5961 - 1918))) then
				if ((v79.ShadowWordDeath:IsReady() and (v13:HasTier(27 + 4, 3 + 1) or (v101 and v79.InescapableTorment:IsAvailable() and v13:HasTier(213 - (156 + 26), 2 + 0))) and v14:DebuffUp(v79.DevouringPlagueDebuff)) or ((2954 - 1065) >= (3547 - (149 + 15)))) then
					if (((2852 - (890 + 70)) <= (2851 - (39 + 78))) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
						return "shadow_word_death main 6";
					end
				end
				if (((2405 - (14 + 468)) < (4877 - 2659)) and v79.MindBlast:IsCastable() and v101 and v79.InescapableTorment:IsAvailable() and (v102 > v79.MindBlast:ExecuteTime()) and (v87 <= (19 - 12))) then
					if (((1122 + 1051) > (228 + 151)) and v88.CastCycle(v79.MindBlast, v84, v117, not v14:IsSpellInRange(v79.MindBlast), nil, nil, v81.MindBlastMouseover, true)) then
						return "mind_blast main 8";
					end
				end
				if (v79.ShadowWordDeath:IsReady() or ((551 + 2040) == (1540 + 1869))) then
					if (((1183 + 3331) > (6362 - 3038)) and v88.CastCycle(v79.ShadowWordDeath, v84, v123, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
						return "shadow_word_death main 10";
					end
				end
				if ((v79.VoidBolt:IsCastable() and v92) or ((206 + 2) >= (16965 - 12137))) then
					if (v23(v79.VoidBolt, not v14:IsInRange(2 + 38)) or ((1634 - (12 + 39)) > (3319 + 248))) then
						return "void_bolt main 12";
					end
				end
				v183 = 5 - 3;
			end
		end
	end
	local function v136()
		local v184 = 0 - 0;
		while true do
			if (((1 + 0) == v184) or ((692 + 621) == (2013 - 1219))) then
				if (((2115 + 1059) > (14024 - 11122)) and v79.DevouringPlague:IsReady() and (v14:DebuffRemains(v79.DevouringPlagueDebuff) <= (1714 - (1596 + 114))) and (v79.VoidTorrent:CooldownRemains() < (v13:GCD() * (4 - 2)))) then
					if (((4833 - (164 + 549)) <= (5698 - (1059 + 379))) and v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague))) then
						return "devouring_plague pl_torrent 6";
					end
				end
				if ((v79.MindBlast:IsCastable() and not v13:PrevGCD(1 - 0, v79.MindBlast)) or ((458 + 425) > (806 + 3972))) then
					if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((4012 - (145 + 247)) >= (4014 + 877))) then
						return "mind_blast pl_torrent 8";
					end
				end
				v184 = 1 + 1;
			end
			if (((12623 - 8365) > (180 + 757)) and (v184 == (0 + 0))) then
				if (v79.VoidBolt:IsCastable() or ((7905 - 3036) < (1626 - (254 + 466)))) then
					if (v23(v79.VoidBolt, not v14:IsInRange(600 - (544 + 16))) or ((3893 - 2668) > (4856 - (294 + 334)))) then
						return "void_bolt pl_torrent 2";
					end
				end
				if (((3581 - (236 + 17)) > (965 + 1273)) and v79.VampiricTouch:IsCastable() and (v14:DebuffRemains(v79.VampiricTouchDebuff) <= (5 + 1)) and (v79.VoidTorrent:CooldownRemains() < (v13:GCD() * (7 - 5)))) then
					if (((18175 - 14336) > (724 + 681)) and v23(v79.VampiricTouch, not v14:IsSpellInRange(v79.VampiricTouch), true)) then
						return "vampiric_touch pl_torrent 4";
					end
				end
				v184 = 1 + 0;
			end
			if (((796 - (413 + 381)) == v184) or ((55 + 1238) <= (1078 - 571))) then
				if ((v79.VoidTorrent:IsCastable() and (v109(v14, false) or v13:BuffUp(v79.VoidformBuff))) or ((7522 - 4626) < (2775 - (582 + 1388)))) then
					if (((3945 - 1629) == (1658 + 658)) and v23(v79.VoidTorrent, not v14:IsSpellInRange(v79.VoidTorrent), true)) then
						return "void_torrent pl_torrent 10";
					end
				end
				break;
			end
		end
	end
	local function v137()
		local v185 = 364 - (326 + 38);
		while true do
			if (((8 - 5) == v185) or ((3668 - 1098) == (2153 - (47 + 573)))) then
				if ((v105:IsCastable() and v13:BuffUp(v79.MindFlayInsanityBuff) and v92 and (v79.MindBlast:FullRechargeTime() >= (v13:GCD() * (2 + 1))) and v79.IdolOfCthun:IsAvailable() and (v79.VoidTorrent:CooldownDown() or not v79.VoidTorrent:IsAvailable())) or ((3749 - 2866) == (2369 - 909))) then
					if (v23(v105, not v14:IsSpellInRange(v105), true) or ((6283 - (1269 + 395)) <= (1491 - (76 + 416)))) then
						return "mind_flay aoe 22";
					end
				end
				if ((v79.MindBlast:IsCastable() and v96 and (v13:BuffDown(v79.MindDevourerBuff) or (v79.VoidEruption:CooldownUp() and v79.VoidEruption:IsAvailable()))) or ((3853 - (319 + 124)) > (9408 - 5292))) then
					if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((1910 - (564 + 443)) >= (8468 - 5409))) then
						return "mind_blast aoe 24";
					end
				end
				if ((v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (461 - (337 + 121))) and (not v97 or ((v87 / (v79.VampiricTouchDebuff:AuraActiveCount() + v87)) < (2.5 - 1))) and ((v13:Insanity() >= (166 - 116)) or v14:DebuffUp(v79.DevouringPlagueDebuff) or v13:BuffUp(v79.DarkReveriesBuff) or v13:BuffUp(v79.VoidformBuff) or v13:BuffUp(v79.DarkAscensionBuff))) or ((5887 - (1261 + 650)) < (1209 + 1648))) then
					local v222 = 0 - 0;
					while true do
						if (((6747 - (772 + 1045)) > (326 + 1981)) and (v222 == (144 - (102 + 42)))) then
							v89 = v136();
							if (v89 or ((5890 - (1524 + 320)) < (2561 - (1049 + 221)))) then
								return v89;
							end
							break;
						end
					end
				end
				if ((v79.VoidTorrent:IsCastable() and not v79.PsychicLink:IsAvailable()) or ((4397 - (18 + 138)) == (8677 - 5132))) then
					if (v88.CastCycle(v79.VoidTorrent, v84, v127, not v14:IsSpellInRange(v79.VoidTorrent), nil, nil, v81.VoidTorrentMouseover, true) or ((5150 - (67 + 1035)) > (4580 - (136 + 212)))) then
						return "void_torrent aoe 26";
					end
				end
				v185 = 16 - 12;
			end
			if ((v185 == (0 + 0)) or ((1614 + 136) >= (5077 - (240 + 1364)))) then
				v130();
				if (((4248 - (1050 + 32)) == (11304 - 8138)) and v79.VampiricTouch:IsCastable() and (((v94 > (0 + 0)) and not v98 and not v79.ShadowCrash:InFlight()) or not v79.WhisperingShadows:IsAvailable())) then
					if (((2818 - (331 + 724)) < (301 + 3423)) and v88.CastCycle(v79.VampiricTouch, v84, v125, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, v81.VampiricTouchMouseover, true)) then
						return "vampiric_touch aoe 2";
					end
				end
				if (((701 - (269 + 375)) <= (3448 - (267 + 458))) and v79.ShadowCrash:IsCastable() and not v97) then
					if ((v76 == "Confirm") or ((644 + 1426) == (851 - 408))) then
						if (v23(v79.ShadowCrash, not v14:IsInRange(858 - (667 + 151))) or ((4202 - (1410 + 87)) == (3290 - (1504 + 393)))) then
							return "shadow_crash aoe 4";
						end
					elseif ((v76 == "Enemy Under Cursor") or ((12436 - 7835) < (158 - 97))) then
						if ((v17:Exists() and v13:CanAttack(v17)) or ((2186 - (461 + 335)) >= (607 + 4137))) then
							if (v23(v81.ShadowCrashCursor, not v14:IsInRange(1801 - (1730 + 31))) or ((3670 - (728 + 939)) > (13578 - 9744))) then
								return "shadow_crash aoe 4";
							end
						end
					elseif ((v76 == "At Cursor") or ((315 - 159) > (8965 - 5052))) then
						if (((1263 - (138 + 930)) == (179 + 16)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(32 + 8))) then
							return "shadow_crash aoe 4";
						end
					end
				end
				if (((2662 + 443) >= (7333 - 5537)) and v30 and ((v91 < (1796 - (459 + 1307))) or ((v14:TimeToDie() > (1885 - (474 + 1396))) and (not v97 or (v87 > (2 - 0)))))) then
					local v223 = 0 + 0;
					while true do
						if (((15 + 4364) >= (6103 - 3972)) and (v223 == (0 + 0))) then
							v89 = v134();
							if (((12832 - 8988) >= (8909 - 6866)) and v89) then
								return v89;
							end
							break;
						end
					end
				end
				v185 = 592 - (562 + 29);
			end
			if (((4 + 0) == v185) or ((4651 - (374 + 1045)) <= (2162 + 569))) then
				if (((15231 - 10326) == (5543 - (448 + 190))) and v105:IsCastable() and v13:BuffUp(v79.MindFlayInsanityBuff) and v79.IdolOfCthun:IsAvailable()) then
					if (v23(v105, not v14:IsSpellInRange(v105), true) or ((1336 + 2800) >= (1992 + 2419))) then
						return "mind_flay aoe 28";
					end
				end
				v89 = v133();
				if (v89 or ((1928 + 1030) == (15444 - 11427))) then
					return v89;
				end
				break;
			end
			if (((3815 - 2587) >= (2307 - (1307 + 187))) and ((3 - 2) == v185)) then
				if ((v100:IsCastable() and ((v14:DebuffUp(v79.ShadowWordPainDebuff) and v96) or (v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable())) and ((v91 < (70 - 40)) or (v14:TimeToDie() > (45 - 30))) and (not v79.DarkAscension:IsAvailable() or (v79.DarkAscension:CooldownRemains() < v106) or (v91 < (698 - (232 + 451))))) or ((3300 + 155) > (3578 + 472))) then
					if (((807 - (510 + 54)) == (489 - 246)) and v23(v100)) then
						return "mindbender aoe 6";
					end
				end
				if ((v79.MindBlast:IsCastable() and ((v79.MindBlast:FullRechargeTime() <= (v106 + v79.MindBlast:CastTime())) or (v102 <= (v79.MindBlast:CastTime() + v106))) and v101 and v79.InescapableTorment:IsAvailable() and (v102 > v79.MindBlast:CastTime()) and (v87 <= (43 - (13 + 23))) and v13:BuffDown(v79.MindDevourerBuff)) or ((528 - 257) > (2258 - 686))) then
					if (((4975 - 2236) < (4381 - (830 + 258))) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
						return "mind_blast aoe 8";
					end
				end
				if ((v79.ShadowWordDeath:IsReady() and (v102 <= (6 - 4)) and v101 and v79.InescapableTorment:IsAvailable() and (v87 <= (5 + 2))) or ((3354 + 588) < (2575 - (860 + 581)))) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((9933 - 7240) == (3947 + 1026))) then
						return "shadow_word_death aoe 10";
					end
				end
				if (((2387 - (237 + 4)) == (5043 - 2897)) and v79.VoidBolt:IsCastable()) then
					if (v23(v79.VoidBolt, not v14:IsInRange(101 - 61)) or ((4254 - 2010) == (2639 + 585))) then
						return "void_bolt aoe 12";
					end
				end
				v185 = 2 + 0;
			end
			if (((7 - 5) == v185) or ((2105 + 2799) <= (1043 + 873))) then
				if (((1516 - (85 + 1341)) <= (1817 - 752)) and v79.DevouringPlague:IsReady() and (not v99 or (v13:InsanityDeficit() <= (56 - 36)) or (v13:BuffUp(v79.VoidformBuff) and (v79.VoidBolt:CooldownRemains() > v13:BuffRemains(v79.VoidformBuff)) and (v79.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v79.VoidformBuff) + (374 - (45 + 327))))))) then
					if (((9060 - 4258) == (5304 - (444 + 58))) and v88.CastCycle(v79.DevouringPlague, v84, v116, not v14:IsSpellInRange(v79.DevouringPlague), nil, nil, v81.DevouringPlagueMouseover)) then
						return "devouring_plague aoe 14";
					end
				end
				if ((v79.VampiricTouch:IsCastable() and (((v94 > (0 + 0)) and not v79.ShadowCrash:InFlight()) or not v79.WhisperingShadows:IsAvailable())) or ((393 + 1887) <= (250 + 261))) then
					if (v88.CastCycle(v79.VampiricTouch, v84, v126, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, v81.VampiricTouchMouseover, true) or ((4856 - 3180) <= (2195 - (64 + 1668)))) then
						return "vampiric_touch aoe 16";
					end
				end
				if (((5842 - (1227 + 746)) == (11892 - 8023)) and v79.ShadowWordDeath:IsReady() and v96 and v79.InescapableTorment:IsAvailable() and v101 and ((not v79.InsidiousIre:IsAvailable() and not v79.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff))) then
					if (((2148 - 990) <= (3107 - (415 + 79))) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
						return "shadow_word_death aoe 18";
					end
				end
				if ((v79.MindSpikeInsanity:IsReady() and v92 and (v79.MindBlast:FullRechargeTime() >= (v13:GCD() * (1 + 2))) and v79.IdolOfCthun:IsAvailable() and (v79.VoidTorrent:CooldownDown() or not v79.VoidTorrent:IsAvailable())) or ((2855 - (142 + 349)) <= (857 + 1142))) then
					if (v23(v79.MindSpikeInsanity, not v14:IsInRange(54 - 14), true) or ((2446 + 2476) < (137 + 57))) then
						return "mind_spike_insanity aoe 20";
					end
				end
				v185 = 7 - 4;
			end
		end
	end
	local function v138()
		local v186 = 1864 - (1710 + 154);
		while true do
			if ((v186 == (318 - (200 + 118))) or ((829 + 1262) < (53 - 22))) then
				if ((v79.Fade:IsReady() and v50 and (v13:HealthPercentage() <= v51)) or ((3604 - 1174) >= (4329 + 543))) then
					if (v23(v79.Fade, nil, nil, true) or ((4719 + 51) < (932 + 803))) then
						return "fade defensive";
					end
				end
				if ((v79.Dispersion:IsCastable() and (v13:HealthPercentage() < v48) and v49) or ((709 + 3730) <= (5091 - 2741))) then
					if (v23(v79.Dispersion) or ((5729 - (363 + 887)) < (7798 - 3332))) then
						return "dispersion defensive";
					end
				end
				v186 = 4 - 3;
			end
			if (((394 + 2153) > (2866 - 1641)) and (v186 == (2 + 0))) then
				if (((6335 - (674 + 990)) > (767 + 1907)) and v32) then
					if ((v79.FlashHeal:IsCastable() and (v13:HealthPercentage() <= v67) and v66) or ((1513 + 2183) < (5273 - 1946))) then
						if (v23(v81.FlashHealPlayer) or ((5597 - (507 + 548)) == (3807 - (289 + 548)))) then
							return "flash_heal defensive";
						end
					end
					if (((2070 - (821 + 997)) <= (2232 - (195 + 60))) and v79.Renew:IsCastable() and (v13:HealthPercentage() <= v69) and v68) then
						if (v23(v81.RenewPlayer) or ((387 + 1049) == (5276 - (251 + 1250)))) then
							return "renew defensive";
						end
					end
					if ((v79.PowerWordShield:IsCastable() and (v13:HealthPercentage() <= v71) and v70) or ((4739 - 3121) < (640 + 290))) then
						if (((5755 - (809 + 223)) > (6059 - 1906)) and v23(v81.PowerWordShieldPlayer)) then
							return "power_word_shield defensive";
						end
					end
				end
				if ((v80.Healthstone:IsReady() and v52 and (v13:HealthPercentage() <= v53)) or ((10973 - 7319) >= (15388 - 10734))) then
					if (((701 + 250) <= (784 + 712)) and v23(v81.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				v186 = 620 - (14 + 603);
			end
			if (((132 - (118 + 11)) == v186) or ((281 + 1455) == (476 + 95))) then
				if ((v34 and (v13:HealthPercentage() <= v36)) or ((2610 - 1714) > (5718 - (551 + 398)))) then
					if ((v35 == "Refreshing Healing Potion") or ((661 + 384) <= (363 + 657))) then
						if (v80.RefreshingHealingPotion:IsReady() or ((943 + 217) <= (1219 - 891))) then
							if (((8774 - 4966) > (948 + 1976)) and v23(v81.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((15446 - 11555) < (1359 + 3560)) and ((90 - (40 + 49)) == v186)) then
				if ((v79.DesperatePrayer:IsCastable() and (v13:HealthPercentage() <= v47) and v46) or ((8507 - 6273) <= (1992 - (99 + 391)))) then
					if (v23(v79.DesperatePrayer) or ((2078 + 434) < (1898 - 1466))) then
						return "desperate_prayer defensive";
					end
				end
				if ((v79.VampiricEmbrace:IsReady() and v88.TargetIsValid() and v14:IsInRange(74 - 44) and v73 and v88.AreUnitsBelowHealthPercentage(v74, v75, v79.FlashHeal)) or ((1801 + 47) == (2276 - 1411))) then
					if (v23(v79.VampiricEmbrace, nil, true) or ((6286 - (1032 + 572)) <= (4958 - (203 + 214)))) then
						return "vampiric_embrace defensive";
					end
				end
				v186 = 1819 - (568 + 1249);
			end
		end
	end
	local function v139()
		if (((GetTime() - v28) > v40) or ((2368 + 658) >= (9717 - 5671))) then
			local v211 = 0 - 0;
			while true do
				if (((3314 - (913 + 393)) > (1801 - 1163)) and ((0 - 0) == v211)) then
					if (((2185 - (269 + 141)) <= (7190 - 3957)) and v79.BodyandSoul:IsAvailable() and v79.PowerWordShield:IsReady() and v39 and v13:BuffDown(v79.AngelicFeatherBuff) and v13:BuffDown(v79.BodyandSoulBuff)) then
						if (v23(v81.PowerWordShieldPlayer) or ((6524 - (362 + 1619)) == (3622 - (950 + 675)))) then
							return "power_word_shield_player move";
						end
					end
					if ((v79.AngelicFeather:IsReady() and v38 and v13:BuffDown(v79.AngelicFeatherBuff) and v13:BuffDown(v79.BodyandSoulBuff) and v13:BuffDown(v79.AngelicFeatherBuff)) or ((1196 + 1906) < (1907 - (216 + 963)))) then
						if (((1632 - (485 + 802)) == (904 - (432 + 127))) and v23(v81.AngelicFeatherPlayer)) then
							return "angelic_feather_player move";
						end
					end
					break;
				end
			end
		end
	end
	local function v140()
		if ((v79.PurifyDisease:IsReady() and v31 and (v88.UnitHasDispellableDebuffByPlayer(v16) or v88.DispellableFriendlyUnit(1098 - (1065 + 8)))) or ((1571 + 1256) < (1979 - (635 + 966)))) then
			if (v23(v81.PurifyDiseaseFocus) or ((2500 + 976) < (2639 - (5 + 37)))) then
				return "purify_disease dispel";
			end
		end
	end
	local function v141()
		v33 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or "";
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v37 = EpicSettings.Settings['UsePowerWordFortitude'];
		v38 = EpicSettings.Settings['UseAngelicFeather'];
		v39 = EpicSettings.Settings['UseBodyAndSoul'];
		v40 = EpicSettings.Settings['MovementDelay'] or (0 + 0);
		v41 = EpicSettings.Settings['DispelDebuffs'];
		v42 = EpicSettings.Settings['DispelBuffs'];
		v43 = EpicSettings.Settings['InterruptWithStun'];
		v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v45 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v46 = EpicSettings.Settings['UseDesperatePrayer'];
		v47 = EpicSettings.Settings['DesperatePrayerHP'] or (0 + 0);
		v48 = EpicSettings.Settings['DispersionHP'] or (0 - 0);
		v49 = EpicSettings.Settings['UseDispersion'];
		v50 = EpicSettings.Settings['UseFade'];
		v51 = EpicSettings.Settings['FadeHP'] or (0 - 0);
		v52 = EpicSettings.Settings['UseHealthstone'];
		v53 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v54 = EpicSettings.Settings['PowerInfusionUsage'] or "";
		v55 = EpicSettings.Settings['PowerInfusionTarget'] or "";
		v56 = EpicSettings.Settings['PowerInfusionHP'] or (0 - 0);
		v57 = EpicSettings.Settings['PowerInfusionGroup'] or (0 + 0);
		v58 = EpicSettings.Settings['PIName1'] or "";
		v59 = EpicSettings.Settings['PIName2'] or "";
		v60 = EpicSettings.Settings['PIName3'] or "";
		v61 = EpicSettings.Settings['UseHalo'];
		v62 = EpicSettings.Settings['HaloHP'] or (529 - (318 + 211));
		v63 = EpicSettings.Settings['HaloGroup'] or (0 - 0);
		v64 = EpicSettings.Settings['UseDivineStar'];
		v65 = EpicSettings.Settings['DivineStarHP'] or (1587 - (963 + 624));
		v66 = EpicSettings.Settings['UseFlashHeal'];
		v67 = EpicSettings.Settings['FlashHealHP'] or (0 + 0);
		v68 = EpicSettings.Settings['UseRenew'];
		v69 = EpicSettings.Settings['RenewHP'] or (846 - (518 + 328));
		v70 = EpicSettings.Settings['UsePowerWordShield'];
		v71 = EpicSettings.Settings['PowerWordShieldHP'] or (0 - 0);
		v72 = EpicSettings.Settings['UseShadowform'];
		v73 = EpicSettings.Settings['UseVampiricEmbrace'];
		v74 = EpicSettings.Settings['VampiricEmbraceHP'] or (0 - 0);
		v75 = EpicSettings.Settings['VampiricEmbraceGroup'] or (317 - (301 + 16));
		v76 = EpicSettings.Settings['ShadowCrashUsage'] or "";
		v77 = EpicSettings.Settings['VampiricTouchUsage'] or "";
		v78 = EpicSettings.Settings['VampiricTouchMax'] or (0 - 0);
	end
	local function v142()
		local v207 = 0 - 0;
		while true do
			if (((8034 - 4955) < (4343 + 451)) and (v207 == (0 + 0))) then
				v141();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['dispel'];
				v207 = 1 - 0;
			end
			if (((2921 + 1933) > (425 + 4039)) and ((3 - 2) == v207)) then
				v32 = EpicSettings.Toggles['heal'];
				v83 = v13:GetEnemiesInRange(10 + 20);
				v84 = v13:GetEnemiesInRange(1059 - (829 + 190));
				v85 = v14:GetEnemiesInSplashRange(35 - 25);
				v207 = 2 - 0;
			end
			if ((v207 == (3 - 0)) or ((12201 - 7289) == (891 + 2867))) then
				if (((42 + 84) <= (10568 - 7086)) and not v13:AffectingCombat() and v29) then
					local v224 = 0 + 0;
					while true do
						if ((v224 == (615 - (520 + 93))) or ((2650 - (259 + 17)) == (252 + 4122))) then
							if (((567 + 1008) == (5332 - 3757)) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
								if (v23(v79.Resurrection, nil, true) or ((2825 - (396 + 195)) == (4221 - 2766))) then
									return "resurrection";
								end
							end
							break;
						end
						if ((v224 == (1761 - (440 + 1321))) or ((2896 - (1059 + 770)) > (8226 - 6447))) then
							if (((2706 - (424 + 121)) >= (171 + 763)) and v79.PowerWordFortitude:IsCastable() and v37 and (v13:BuffDown(v79.PowerWordFortitudeBuff, true) or v88.GroupBuffMissing(v79.PowerWordFortitudeBuff))) then
								if (((2959 - (641 + 706)) == (639 + 973)) and v23(v81.PowerWordFortitudePlayer)) then
									return "power_word_fortitude";
								end
							end
							if (((4792 - (249 + 191)) >= (12341 - 9508)) and HandleAfflicted) then
								local v232 = 0 + 0;
								while true do
									if (((0 - 0) == v232) or ((3649 - (183 + 244)) < (151 + 2922))) then
										v89 = v88.HandleAfflicted(v79.PurifyDisease, v81.PurifyDiseaseMouseover, 770 - (434 + 296));
										if (((2373 - 1629) <= (3454 - (169 + 343))) and v89) then
											return v89;
										end
										break;
									end
								end
							end
							v224 = 1 + 0;
						end
						if ((v224 == (1 - 0)) or ((5379 - 3546) <= (1084 + 238))) then
							if ((v79.PowerWordFortitude:IsCastable() and (v13:BuffDown(v79.PowerWordFortitudeBuff, true) or v88.GroupBuffMissing(v79.PowerWordFortitudeBuff))) or ((9832 - 6365) <= (2178 - (651 + 472)))) then
								if (((2677 + 864) == (1528 + 2013)) and v23(v81.PowerWordFortitudePlayer)) then
									return "power_word_fortitude";
								end
							end
							if ((v79.Shadowform:IsCastable() and (v13:BuffDown(v79.ShadowformBuff)) and v72) or ((4340 - 783) >= (4486 - (397 + 86)))) then
								if (v23(v79.Shadowform) or ((1533 - (423 + 453)) >= (170 + 1498))) then
									return "shadowform";
								end
							end
							v224 = 1 + 1;
						end
					end
				end
				if ((v13:IsMoving() and (v13:AffectingCombat() or v29)) or ((897 + 130) > (3079 + 779))) then
					local v225 = 0 + 0;
					while true do
						if ((v225 == (1190 - (50 + 1140))) or ((3159 + 495) < (266 + 184))) then
							v89 = v139();
							if (((118 + 1773) < (6394 - 1941)) and v89) then
								return v89;
							end
							break;
						end
					end
				end
				if (v88.TargetIsValid() or v13:AffectingCombat() or ((2273 + 867) < (2725 - (157 + 439)))) then
					local v226 = 0 - 0;
					while true do
						if (((9 - 6) == v226) or ((7557 - 5002) < (2158 - (782 + 136)))) then
							v105 = ((v13:BuffUp(v79.MindFlayInsanityBuff)) and v79.MindFlayInsanity) or v79.MindFlay;
							v106 = v13:GCD() + (855.25 - (112 + 743));
							break;
						end
						if ((v226 == (1172 - (1026 + 145))) or ((812 + 3915) <= (5440 - (493 + 225)))) then
							if (((2720 - 1980) < (3004 + 1933)) and (v91 == (29789 - 18678))) then
								v91 = v10.FightRemains(v85, false);
							end
							v101 = v100:TimeSinceLastCast() <= (1 + 14);
							v226 = 5 - 3;
						end
						if (((1065 + 2593) >= (467 - 187)) and (v226 == (1597 - (210 + 1385)))) then
							v102 = (1704 - (1201 + 488)) - v100:TimeSinceLastCast();
							if ((v102 < (0 + 0)) or ((1574 - 689) >= (1848 - 817))) then
								v102 = 585 - (352 + 233);
							end
							v226 = 7 - 4;
						end
						if (((1934 + 1620) >= (1492 - 967)) and (v226 == (574 - (489 + 85)))) then
							v90 = v10.BossFightRemains(nil, true);
							v91 = v90;
							v226 = 1502 - (277 + 1224);
						end
					end
				end
				if (((3907 - (663 + 830)) <= (2611 + 361)) and v88.TargetIsValid()) then
					local v227 = 0 - 0;
					while true do
						if (((4404 - (461 + 414)) <= (594 + 2944)) and (v227 == (0 + 0))) then
							if ((not v13:AffectingCombat() and v29) or ((273 + 2588) < (452 + 6))) then
								local v233 = 250 - (172 + 78);
								while true do
									if (((2768 - 1051) <= (1666 + 2859)) and (v233 == (0 - 0))) then
										v89 = v128();
										if (v89 or ((867 + 2311) <= (510 + 1014))) then
											return v89;
										end
										break;
									end
								end
							end
							if (((7126 - 2872) > (465 - 95)) and (v13:AffectingCombat() or v29)) then
								v89 = v138();
								if (v89 or ((411 + 1224) == (983 + 794))) then
									return v89;
								end
								if ((not v13:IsCasting() and not v13:IsChanneling()) or ((1189 + 2149) >= (15894 - 11901))) then
									local v236 = 0 - 0;
									while true do
										if (((354 + 800) <= (843 + 632)) and (v236 == (447 - (133 + 314)))) then
											v89 = v88.Interrupt(v79.Silence, 6 + 24, true);
											if (v89 or ((2823 - (199 + 14)) < (4403 - 3173))) then
												return v89;
											end
											v236 = 1550 - (647 + 902);
										end
										if ((v236 == (5 - 3)) or ((1681 - (85 + 148)) == (4372 - (426 + 863)))) then
											v89 = v88.InterruptWithStun(v79.PsychicScream, 37 - 29);
											if (((4793 - (873 + 781)) > (1226 - 310)) and v89) then
												return v89;
											end
											break;
										end
										if (((7977 - 5023) == (1224 + 1730)) and (v236 == (3 - 2))) then
											v89 = v88.Interrupt(v79.Silence, 42 - 12, true, v17, v81.SilenceMouseover);
											if (((347 - 230) <= (4839 - (414 + 1533))) and v89) then
												return v89;
											end
											v236 = 2 + 0;
										end
									end
								end
								v97 = false;
								v99 = ((v79.VoidEruption:CooldownRemains() <= (v13:GCD() * (558 - (443 + 112)))) and v79.VoidEruption:IsAvailable()) or (v79.DarkAscension:CooldownUp() and v79.DarkAscension:IsAvailable()) or (v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (1483 - (888 + 591))) and v13:BuffDown(v79.VoidformBuff));
								if ((v104 == nil) or ((1170 - 717) > (266 + 4396))) then
									v104 = v14:GUID();
								end
								if (((4971 - 3651) > (233 + 362)) and (v103 == false) and v29 and (v14:GUID() == v104) and not v109(v14, true)) then
									v89 = v132();
									if (v89 or ((1548 + 1651) < (64 + 526))) then
										return v89;
									end
									if (v23(v79.Pool) or ((9133 - 4340) < (55 - 25))) then
										return "Pool for Opener()";
									end
								else
									v103 = true;
								end
								if (v16 or ((3374 - (136 + 1542)) <= (3472 - 2413))) then
									if (((2326 + 17) == (3725 - 1382)) and v41) then
										local v238 = 0 + 0;
										while true do
											if ((v238 == (486 - (68 + 418))) or ((2827 - 1784) > (6515 - 2924))) then
												v89 = v140();
												if (v89 or ((2495 + 395) >= (5171 - (770 + 322)))) then
													return v89;
												end
												break;
											end
										end
									end
								end
								if (((258 + 4216) <= (1380 + 3390)) and v79.DispelMagic:IsReady() and v31 and v42 and not v13:IsCasting() and not v13:IsChanneling() and v88.UnitHasMagicBuff(v14)) then
									if (v23(v79.DispelMagic, not v14:IsSpellInRange(v79.DispelMagic)) or ((675 + 4267) == (5583 - 1680))) then
										return "dispel_magic damage";
									end
								end
								if ((v87 > (3 - 1)) or (v86 > (7 - 4)) or ((912 - 664) > (2699 + 2146))) then
									local v237 = 0 - 0;
									while true do
										if (((753 + 816) == (962 + 607)) and (v237 == (1 + 0))) then
											if (v23(v79.Pool) or ((18552 - 13625) <= (4473 - 1252))) then
												return "Pool for AoE()";
											end
											break;
										end
										if (((0 + 0) == v237) or ((8199 - 6419) > (9212 - 6425))) then
											v89 = v137();
											if (v89 or ((1620 + 2317) <= (6086 - 4856))) then
												return v89;
											end
											v237 = 832 - (762 + 69);
										end
									end
								end
								v89 = v135();
								if (v89 or ((8538 - 5901) < (1470 + 236))) then
									return v89;
								end
							end
							v227 = 1 + 0;
						end
						if (((2 - 1) == v227) or ((840 + 1829) <= (39 + 2370))) then
							if (v23(v79.Pool) or ((5458 - 4057) > (4853 - (8 + 149)))) then
								return "Pool for Main()";
							end
							break;
						end
					end
				end
				break;
			end
			if ((v207 == (1322 - (1199 + 121))) or ((5550 - 2270) < (2982 - 1661))) then
				if (((2029 + 2898) >= (8220 - 5917)) and AOE) then
					local v228 = 0 - 0;
					while true do
						if (((3063 + 399) >= (2839 - (518 + 1289))) and (v228 == (0 - 0))) then
							v86 = #v83;
							v87 = v14:GetEnemiesInSplashRangeCount(2 + 8);
							break;
						end
					end
				else
					local v229 = 0 - 0;
					while true do
						if ((v229 == (0 + 0)) or ((1546 - (304 + 165)) >= (1899 + 112))) then
							v86 = 161 - (54 + 106);
							v87 = 1970 - (1618 + 351);
							break;
						end
					end
				end
				if (((1089 + 454) < (3431 - (10 + 1006))) and v13:IsDeadOrGhost()) then
					return;
				end
				if (not v13:IsMoving() or ((1116 + 3328) < (283 + 1732))) then
					v28 = GetTime();
				end
				if (v13:AffectingCombat() or v41 or ((13616 - 9416) == (3365 - (912 + 121)))) then
					local v230 = 0 + 0;
					local v231;
					while true do
						if ((v230 == (1289 - (1140 + 149))) or ((818 + 460) >= (1753 - 437))) then
							v231 = v41 and v79.Purify:IsReady();
							v89 = v88.FocusUnit(v231, nil, nil, nil, 4 + 16, v79.FlashHeal);
							v230 = 3 - 2;
						end
						if (((2028 - 946) == (187 + 895)) and (v230 == (3 - 2))) then
							if (((1514 - (165 + 21)) <= (4989 - (61 + 50))) and v89) then
								return v89;
							end
							break;
						end
					end
				end
				v207 = 2 + 1;
			end
		end
	end
	local function v143()
		v107();
		v79.VampiricTouchDebuff:RegisterAuraTracking();
		v20.Print("Shadow Priest by Epic BoomK");
		EpicSettings.SetupVersion("Shadow Priest X v 10.2.01 By BoomK");
	end
	v20.SetAPL(1229 - 971, v142, v143);
end;
return v0["Epix_Priest_Shadow.lua"]();

