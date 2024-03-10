local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((4003 + 242) <= (2772 + 1859)) and (v5 == (679 - (356 + 322)))) then
			return v6(...);
		end
		if (((13023 - 8747) >= (489 + 3425)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((1442 - (485 + 759)) <= (10100 - 5735)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1190 - (442 + 747);
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
	local v28 = 1135 - (832 + 303);
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
	local v90 = 12057 - (88 + 858);
	local v91 = 3387 + 7724;
	local v92 = false;
	local v93 = false;
	local v94 = 0 + 0;
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
		local v144 = 789 - (766 + 23);
		while true do
			if (((23607 - 18825) > (6394 - 1718)) and (v144 == (2 - 1))) then
				VarMindSearCutoff = 6 - 4;
				VarPoolAmount = 1133 - (1036 + 37);
				v94 = 0 + 0;
				v95 = false;
				v144 = 3 - 1;
			end
			if (((3827 + 1037) > (3677 - (641 + 839))) and ((915 - (910 + 3)) == v144)) then
				v96 = false;
				v97 = false;
				v98 = false;
				v99 = false;
				v144 = 7 - 4;
			end
			if ((v144 == (1684 - (1466 + 218))) or ((1701 + 1999) == (3655 - (556 + 592)))) then
				v90 = 3952 + 7159;
				v91 = 11919 - (329 + 479);
				v92 = false;
				v93 = false;
				v144 = 855 - (174 + 680);
			end
			if (((15373 - 10899) >= (567 - 293)) and (v144 == (3 + 0))) then
				v101 = false;
				v102 = 739 - (396 + 343);
				v103 = false;
				v104 = nil;
				break;
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
			if ((v147 == (1477 - (29 + 1448))) or ((3283 - (135 + 1254)) <= (5296 - 3890))) then
				v79.ShadowCrash:RegisterInFlightEffect(958972 - 753586);
				v79.ShadowCrash:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v79.ShadowCrash:RegisterInFlightEffect(136877 + 68509);
	v79.ShadowCrash:RegisterInFlight();
	local function v108()
		local v148 = 1528 - (389 + 1138);
		if (((2146 - (102 + 472)) >= (1445 + 86)) and v13:BuffUp(v79.DarkAscensionBuff)) then
			v148 = v148 * (1.25 + 0);
		end
		if (v13:BuffUp(v79.DarkEvangelismBuff) or ((4371 + 316) < (6087 - (320 + 1225)))) then
			v148 = v148 * ((1 - 0) + ((0.01 + 0) * v13:BuffStack(v79.DarkEvangelismBuff)));
		end
		if (((4755 - (157 + 1307)) > (3526 - (821 + 1038))) and (v13:BuffUp(v79.DevouredFearBuff) or v13:BuffUp(v79.DevouredPrideBuff))) then
			v148 = v148 * (2.05 - 1);
		end
		if (v79.DistortedReality:IsAvailable() or ((96 + 777) == (3612 - 1578))) then
			v148 = v148 * (1.2 + 0);
		end
		if (v13:BuffUp(v79.MindDevourerBuff) or ((6979 - 4163) < (1037 - (834 + 192)))) then
			v148 = v148 * (1.2 + 0);
		end
		if (((950 + 2749) < (102 + 4604)) and v79.Voidtouched:IsAvailable()) then
			v148 = v148 * (1.06 - 0);
		end
		return v148;
	end
	v79.DevouringPlague:RegisterPMultiplier(v79.DevouringPlagueDebuff, v108);
	local function v109(v149, v150)
		if (((2950 - (300 + 4)) >= (234 + 642)) and v150) then
			return v149:DebuffUp(v79.ShadowWordPainDebuff) and v149:DebuffUp(v79.VampiricTouchDebuff) and v149:DebuffUp(v79.DevouringPlagueDebuff);
		else
			return v149:DebuffUp(v79.ShadowWordPainDebuff) and v149:DebuffUp(v79.VampiricTouchDebuff);
		end
	end
	local function v110(v151, v152)
		if (((1607 - 993) <= (3546 - (112 + 250))) and not v151) then
			return nil;
		end
		local v153 = 0 + 0;
		local v154 = nil;
		for v184, v185 in pairs(v151) do
			local v186 = 0 - 0;
			local v187;
			while true do
				if (((1791 + 1335) == (1617 + 1509)) and ((0 + 0) == v186)) then
					v187 = v185:TimeToDie();
					if (v152 or ((1085 + 1102) >= (3681 + 1273))) then
						if (((v187 * v25(v185:DebuffRefreshable(v79.VampiricTouchDebuff))) > v153) or ((5291 - (1001 + 413)) == (7972 - 4397))) then
							local v220 = 882 - (244 + 638);
							while true do
								if (((1400 - (627 + 66)) > (1882 - 1250)) and ((602 - (512 + 90)) == v220)) then
									v153 = v187;
									v154 = v185;
									break;
								end
							end
						end
					elseif ((v187 > v153) or ((2452 - (1665 + 241)) >= (3401 - (373 + 344)))) then
						local v221 = 0 + 0;
						while true do
							if (((388 + 1077) <= (11344 - 7043)) and (v221 == (0 - 0))) then
								v153 = v187;
								v154 = v185;
								break;
							end
						end
					end
					break;
				end
			end
		end
		return v154;
	end
	local function v111(v155)
		return (v155:DebuffRemains(v79.ShadowWordPainDebuff));
	end
	local function v112(v156)
		return (v156:TimeToDie());
	end
	local function v113(v157)
		return (v157:DebuffRemains(v79.VampiricTouchDebuff));
	end
	local function v114(v158)
		return v158:DebuffRefreshable(v79.VampiricTouchDebuff) and (v158:TimeToDie() >= (1111 - (35 + 1064))) and (((v79.ShadowCrash:CooldownRemains() >= v158:DebuffRemains(v79.VampiricTouchDebuff)) and not v79.ShadowCrash:InFlight()) or v97 or not v79.WhisperingShadows:IsAvailable());
	end
	local function v115(v159)
		return not v79.DistortedReality:IsAvailable() or (v87 == (1 + 0)) or (v159:DebuffRemains(v79.DevouringPlagueDebuff) <= v106) or (v13:InsanityDeficit() <= (34 - 18));
	end
	local function v116(v160)
		return (v160:DebuffRemains(v79.DevouringPlagueDebuff) <= v106) or not v79.DistortedReality:IsAvailable();
	end
	local function v117(v161)
		return ((v161:DebuffRemains(v79.DevouringPlagueDebuff) > v79.MindBlast:ExecuteTime()) and (v79.MindBlast:FullRechargeTime() <= (v106 + v79.MindBlast:ExecuteTime()))) or (v102 <= (v79.MindBlast:ExecuteTime() + v106));
	end
	local function v118(v162)
		return v109(v162, true) and (v162:DebuffRemains(v79.DevouringPlagueDebuff) >= v79.Mindgames:CastTime());
	end
	local function v119(v163)
		return v163:DebuffRefreshable(v79.VampiricTouchDebuff) or ((v163:DebuffRemains(v79.VampiricTouchDebuff) <= v163:TimeToDie()) and v13:BuffDown(v79.VoidformBuff));
	end
	local function v120(v164)
		return ((v164:HealthPercentage() < (1 + 19)) and ((v100:CooldownRemains() >= (1246 - (298 + 938))) or not v79.InescapableTorment:IsAvailable())) or (v101 and v79.InescapableTorment:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff);
	end
	local function v121(v165)
		return (v165:HealthPercentage() < (1279 - (233 + 1026))) or v13:BuffUp(v79.DeathspeakerBuff) or v13:HasTier(1697 - (636 + 1030), 2 + 0);
	end
	local function v122(v166)
		return v166:HealthPercentage() < (20 + 0);
	end
	local function v123(v167)
		return v167:DebuffUp(v79.DevouringPlagueDebuff) and (v102 <= (1 + 1)) and v101 and v79.InescapableTorment:IsAvailable() and (v87 <= (1 + 6));
	end
	local function v111(v168)
		return (v168:DebuffRemains(v79.ShadowWordPainDebuff));
	end
	local function v124(v169)
		return v169:DebuffRemains(v79.DevouringPlagueDebuff) >= (223.5 - (55 + 166));
	end
	local function v125(v170)
		return v170:DebuffRefreshable(v79.VampiricTouchDebuff) and (v170:TimeToDie() >= (4 + 14)) and (v170:DebuffUp(v79.VampiricTouchDebuff) or not v96);
	end
	local function v126(v171)
		local v172 = 0 + 0;
		while true do
			if (((6507 - 4803) > (1722 - (36 + 261))) and ((0 - 0) == v172)) then
				if ((v79.ShadowCrash:CooldownRemains() >= v171:DebuffRemains(v79.VampiricTouchDebuff)) or v97 or ((2055 - (34 + 1334)) == (1628 + 2606))) then
					return v171:DebuffRefreshable(v79.VampiricTouchDebuff) and (v171:TimeToDie() >= (14 + 4)) and (v171:DebuffUp(v79.VampiricTouchDebuff) or not v96);
				end
				return nil;
			end
		end
	end
	local function v127(v173)
		return (v109(v173, false));
	end
	local function v128()
		local v174 = 1283 - (1035 + 248);
		local v175;
		while true do
			if ((v174 == (23 - (20 + 1))) or ((1735 + 1595) < (1748 - (134 + 185)))) then
				if (((2280 - (549 + 584)) >= (1020 - (314 + 371))) and v79.VampiricTouch:IsCastable() and (not v79.ShadowCrash:IsAvailable() or (v79.ShadowCrash:CooldownDown() and not v79.ShadowCrash:InFlight()) or v175)) then
					if (((11792 - 8357) > (3065 - (478 + 490))) and v23(v79.VampiricTouch, not v14:IsSpellInRange(v79.VampiricTouch), true)) then
						return "vampiric_touch precombat 14";
					end
				end
				if ((v79.ShadowWordPain:IsCastable() and not v79.Misery:IsAvailable()) or ((1998 + 1772) >= (5213 - (786 + 386)))) then
					if (v23(v79.ShadowWordPain, not v14:IsSpellInRange(v79.ShadowWordPain)) or ((12278 - 8487) <= (2990 - (1055 + 324)))) then
						return "shadow_word_pain precombat 16";
					end
				end
				break;
			end
			if ((v174 == (1341 - (1093 + 247))) or ((4069 + 509) <= (212 + 1796))) then
				v175 = v13:IsInParty() and not v13:IsInRaid();
				if (((4466 - 3341) <= (7045 - 4969)) and v79.ShadowCrash:IsCastable() and not v175) then
					if ((v76 == "Confirm") or ((2113 - 1370) >= (11054 - 6655))) then
						if (((411 + 744) < (6444 - 4771)) and v23(v79.ShadowCrash, not v14:IsInRange(137 - 97))) then
							return "shadow_crash precombat 8";
						end
					elseif ((v76 == "Enemy Under Cursor") or ((1753 + 571) <= (1477 - 899))) then
						if (((4455 - (364 + 324)) == (10326 - 6559)) and v17:Exists() and v13:CanAttack(v17)) then
							if (((9811 - 5722) == (1356 + 2733)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(167 - 127))) then
								return "shadow_crash precombat 8";
							end
						end
					elseif (((7139 - 2681) >= (5083 - 3409)) and (v76 == "At Cursor")) then
						if (((2240 - (1249 + 19)) <= (1280 + 138)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(155 - 115))) then
							return "shadow_crash precombat 8";
						end
					end
				end
				v174 = 1088 - (686 + 400);
			end
			if ((v174 == (0 + 0)) or ((5167 - (73 + 156)) < (23 + 4739))) then
				v104 = v14:GUID();
				if ((v79.ArcaneTorrent:IsCastable() and v30) or ((3315 - (721 + 90)) > (48 + 4216))) then
					if (((6990 - 4837) == (2623 - (224 + 246))) and v23(v79.ArcaneTorrent, not v14:IsSpellInRange(v79.ArcaneTorrent))) then
						return "arcane_torrent precombat 6";
					end
				end
				v174 = 1 - 0;
			end
		end
	end
	local function v129()
		v92 = v109(v14, false) or (v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable());
		v93 = v109(v14, true);
		v99 = ((v79.VoidEruption:CooldownRemains() <= (v13:GCD() * (5 - 2))) and v79.VoidEruption:IsAvailable()) or (v79.DarkAscension:CooldownUp() and v79.DarkAscension:IsAvailable()) or (v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (1 + 3)) and v13:BuffDown(v79.VoidformBuff));
	end
	local function v130()
		local v176 = 0 + 0;
		local v177;
		while true do
			if ((v176 == (0 + 0)) or ((1007 - 500) >= (8622 - 6031))) then
				v94 = v27(v87, v78);
				v95 = false;
				v176 = 514 - (203 + 310);
			end
			if (((6474 - (1238 + 755)) == (314 + 4167)) and (v176 == (1535 - (709 + 825)))) then
				v177 = v110(v85, true);
				if ((v177 and (v177:TimeToDie() >= (32 - 14))) or ((3390 - 1062) < (1557 - (196 + 668)))) then
					v95 = true;
				end
				v176 = 7 - 5;
			end
			if (((8964 - 4636) == (5161 - (171 + 662))) and (v176 == (96 - (4 + 89)))) then
				v98 = ((v79.VampiricTouchDebuff:AuraActiveCount() + ((27 - 19) * v25(not v97))) >= v94) or not v95;
				break;
			end
			if (((579 + 1009) >= (5850 - 4518)) and (v176 == (1 + 1))) then
				v96 = ((v79.VampiricTouchDebuff:AuraActiveCount() + ((1494 - (35 + 1451)) * v25(v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable()))) >= v94) or not v95;
				if ((v97 and v79.WhisperingShadows:IsAvailable()) or ((5627 - (28 + 1425)) > (6241 - (941 + 1052)))) then
					v97 = (v94 - v79.VampiricTouchDebuff:AuraActiveCount()) < (4 + 0);
				end
				v176 = 1517 - (822 + 692);
			end
		end
	end
	local function v131()
		if (v13:BuffUp(v79.VoidformBuff) or v13:BuffUp(v79.PowerInfusionBuff) or v13:BuffUp(v79.DarkAscensionBuff) or (v91 < (28 - 8)) or ((2161 + 2425) <= (379 - (45 + 252)))) then
			local v189 = 0 + 0;
			while true do
				if (((1330 + 2533) == (9401 - 5538)) and (v189 == (433 - (114 + 319)))) then
					v89 = v88.HandleTopTrinket(v82, v30, 57 - 17, nil);
					if (v89 or ((360 - 78) <= (27 + 15))) then
						return v89;
					end
					v189 = 1 - 0;
				end
				if (((9656 - 5047) >= (2729 - (556 + 1407))) and (v189 == (1207 - (741 + 465)))) then
					v89 = v88.HandleBottomTrinket(v82, v30, 505 - (170 + 295), nil);
					if (v89 or ((607 + 545) == (2286 + 202))) then
						return v89;
					end
					break;
				end
			end
		end
	end
	local function v132()
		if (((8424 - 5002) > (2778 + 572)) and v79.ShadowCrash:IsCastable() and (v14:DebuffDown(v79.VampiricTouchDebuff))) then
			if (((563 + 314) > (213 + 163)) and (v76 == "Confirm")) then
				if (v23(v79.ShadowCrash, not v14:IsInRange(1270 - (957 + 273))) or ((834 + 2284) <= (741 + 1110))) then
					return "shadow_crash opener 2";
				end
			elseif ((v76 == "Enemy Under Cursor") or ((628 - 463) >= (9202 - 5710))) then
				if (((12061 - 8112) < (24045 - 19189)) and v17:Exists() and v13:CanAttack(v17)) then
					if (v23(v81.ShadowCrashCursor, not v14:IsInRange(1820 - (389 + 1391))) or ((2683 + 1593) < (314 + 2702))) then
						return "shadow_crash opener 2";
					end
				end
			elseif (((10677 - 5987) > (5076 - (783 + 168))) and (v76 == "At Cursor")) then
				if (v23(v81.ShadowCrashCursor, not v14:IsInRange(134 - 94)) or ((50 + 0) >= (1207 - (309 + 2)))) then
					return "shadow_crash opener 2";
				end
			end
		end
		if ((v79.VampiricTouch:IsCastable() and v14:DebuffDown(v79.VampiricTouchDebuff) and (v79.ShadowCrash:CooldownDown() or not v79.ShadowCrash:IsAvailable())) or ((5263 - 3549) >= (4170 - (1090 + 122)))) then
			if (v22(v79.VampiricTouch, nil, nil, not v14:IsSpellInRange(v79.VampiricTouch)) or ((484 + 1007) < (2162 - 1518))) then
				return "vampiric_touch opener 3";
			end
		end
		if (((482 + 222) < (2105 - (628 + 490))) and v100:IsCastable() and v30) then
			if (((667 + 3051) > (4718 - 2812)) and v23(v100)) then
				return "mindbender opener 4";
			end
		end
		if (v79.DarkAscension:IsCastable() or ((4377 - 3419) > (4409 - (431 + 343)))) then
			if (((7070 - 3569) <= (12994 - 8502)) and v23(v79.DarkAscension)) then
				return "dark_ascension opener 6";
			end
		end
		if (v79.VoidEruption:IsAvailable() or ((2720 + 722) < (326 + 2222))) then
			local v190 = 1695 - (556 + 1139);
			while true do
				if (((2890 - (6 + 9)) >= (269 + 1195)) and (v190 == (1 + 0))) then
					if (v79.VoidEruption:IsCastable() or ((4966 - (28 + 141)) >= (1896 + 2997))) then
						if (v23(v79.VoidEruption, not v14:IsInRange(49 - 9), true) or ((391 + 160) > (3385 - (486 + 831)))) then
							return "void_eruption opener 12";
						end
					end
					break;
				end
				if (((5501 - 3387) > (3323 - 2379)) and (v190 == (0 + 0))) then
					if ((v79.ShadowWordDeath:IsCastable() and v79.InescapableTorment:IsAvailable() and v13:PrevGCDP(3 - 2, v79.MindBlast) and (v79.ShadowWordDeath:TimeSinceLastCast() > (1283 - (668 + 595)))) or ((2036 + 226) >= (625 + 2471))) then
						if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((6149 - 3894) >= (3827 - (23 + 267)))) then
							return "shadow_word_death opener 8";
						end
					end
					if (v79.MindBlast:IsCastable() or ((5781 - (1129 + 815)) < (1693 - (371 + 16)))) then
						if (((4700 - (1326 + 424)) == (5587 - 2637)) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
							return "mind_blast opener 10";
						end
					end
					v190 = 3 - 2;
				end
			end
		end
		v89 = v131();
		if (v89 or ((4841 - (88 + 30)) < (4069 - (720 + 51)))) then
			return v89;
		end
		if (((2526 - 1390) >= (1930 - (421 + 1355))) and v79.VoidBolt:IsCastable()) then
			if (v23(v79.VoidBolt, not v14:IsInRange(65 - 25)) or ((134 + 137) > (5831 - (286 + 797)))) then
				return "void_bolt opener 16";
			end
		end
		if (((17327 - 12587) >= (5220 - 2068)) and v79.DevouringPlague:IsReady()) then
			if (v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague)) or ((3017 - (397 + 42)) >= (1059 + 2331))) then
				return "devouring_plague opener 18";
			end
		end
		if (((841 - (24 + 776)) <= (2558 - 897)) and v79.MindBlast:IsCastable()) then
			if (((1386 - (222 + 563)) < (7843 - 4283)) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
				return "mind_blast opener 20";
			end
		end
		if (((170 + 65) < (877 - (23 + 167))) and v79.MindSpike:IsCastable()) then
			if (((6347 - (690 + 1108)) > (416 + 737)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
				return "mind_spike opener 22";
			end
		end
		if (v79.MindFlay:IsCastable() or ((3856 + 818) < (5520 - (40 + 808)))) then
			if (((604 + 3064) < (17441 - 12880)) and v23(v79.MindFlay, not v14:IsSpellInRange(v79.MindFlay), true)) then
				return "mind_flay opener 24";
			end
		end
	end
	local function v133()
		if ((v79.VampiricTouch:IsCastable() and (v13:BuffUp(v79.UnfurlingDarknessBuff))) or ((435 + 20) == (1908 + 1697))) then
			if (v88.CastTargetIf(v79.VampiricTouch, v84, "min", v113, nil, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, nil, true) or ((1461 + 1202) == (3883 - (47 + 524)))) then
				return "vampiric_touch filler 2";
			end
		end
		if (((2776 + 1501) <= (12232 - 7757)) and v79.ShadowWordDeath:IsReady()) then
			if (v88.CastCycle(v79.ShadowWordDeath, v84, v121, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover) or ((1300 - 430) == (2711 - 1522))) then
				return "shadow_word_death filler 4";
			end
		end
		if (((3279 - (1165 + 561)) <= (94 + 3039)) and v79.MindSpikeInsanity:IsReady()) then
			if (v23(v79.MindSpikeInsanity, not v14:IsSpellInRange(v79.MindSpikeInsanity), true) or ((6928 - 4691) >= (1340 + 2171))) then
				return "mind_spike_insanity filler 6";
			end
		end
		if ((v79.MindFlay:IsCastable() and (v13:BuffUp(v79.MindFlayInsanityBuff))) or ((1803 - (341 + 138)) > (816 + 2204))) then
			if (v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true) or ((6174 - 3182) == (2207 - (89 + 237)))) then
				return "mind_flay filler 8";
			end
		end
		if (((9991 - 6885) > (3212 - 1686)) and v79.Mindgames:IsReady()) then
			if (((3904 - (581 + 300)) < (5090 - (855 + 365))) and v23(v79.Mindgames, not v14:IsInRange(95 - 55), true)) then
				return "mindgames filler 10";
			end
		end
		if (((47 + 96) > (1309 - (1030 + 205))) and v79.ShadowWordDeath:IsReady() and v79.InescapableTorment:IsAvailable() and v101) then
			if (((17 + 1) < (1965 + 147)) and v88.CastTargetIf(v79.ShadowWordDeath, v84, "min", v112, nil, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
				return "shadow_word_death filler 12";
			end
		end
		if (((1383 - (156 + 130)) <= (3698 - 2070)) and v79.DivineStar:IsReady() and (v16:HealthPercentage() < v65) and v64) then
			if (((7803 - 3173) == (9482 - 4852)) and v23(v81.DivineStarPlayer, not v16:IsInRange(8 + 22))) then
				return "divine_star heal";
			end
		end
		if (((2065 + 1475) > (2752 - (10 + 59))) and v79.Halo:IsReady() and v88.TargetIsValid() and v14:IsInRange(9 + 21) and v61 and v88.AreUnitsBelowHealthPercentage(v62, v63, v79.FlashHeal)) then
			if (((23609 - 18815) >= (4438 - (671 + 492))) and v23(v79.Halo, nil, true)) then
				return "halo heal";
			end
		end
		if (((1182 + 302) == (2699 - (369 + 846))) and v79.MindSpike:IsCastable()) then
			if (((380 + 1052) < (3034 + 521)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
				return "mind_spike filler 16";
			end
		end
		if (v105:IsCastable() or ((3010 - (1036 + 909)) > (2845 + 733))) then
			if (v23(v105, not v14:IsSpellInRange(v105), true) or ((8050 - 3255) < (1610 - (11 + 192)))) then
				return "mind_flay filler 18";
			end
		end
		if (((937 + 916) < (4988 - (135 + 40))) and v79.ShadowCrash:IsCastable()) then
			if ((v76 == "Confirm") or ((6834 - 4013) < (1466 + 965))) then
				if (v23(v79.ShadowCrash, not v14:IsInRange(88 - 48)) or ((4307 - 1433) < (2357 - (50 + 126)))) then
					return "shadow_crash filler 20";
				end
			elseif ((v76 == "Enemy Under Cursor") or ((7487 - 4798) <= (76 + 267))) then
				if ((v17:Exists() and v13:CanAttack(v17)) or ((3282 - (1233 + 180)) == (2978 - (522 + 447)))) then
					if (v23(v81.ShadowCrashCursor, not v14:IsInRange(1461 - (107 + 1314))) or ((1646 + 1900) < (7075 - 4753))) then
						return "shadow_crash filler 20";
					end
				end
			elseif ((v76 == "At Cursor") or ((885 + 1197) == (9478 - 4705))) then
				if (((12835 - 9591) > (2965 - (716 + 1194))) and v23(v81.ShadowCrashCursor, not v14:IsInRange(1 + 39))) then
					return "shadow_crash filler 20";
				end
			end
		end
		if (v79.ShadowWordDeath:IsReady() or ((355 + 2958) <= (2281 - (74 + 429)))) then
			if (v88.CastCycle(v79.ShadowWordDeath, v84, v122, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover) or ((2741 - 1320) >= (1043 + 1061))) then
				return "shadow_word_death filler 22";
			end
		end
		if (((4147 - 2335) <= (2299 + 950)) and v79.ShadowWordDeath:IsReady() and v13:IsMoving()) then
			if (((5003 - 3380) <= (4838 - 2881)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
				return "shadow_word_death movement filler 26";
			end
		end
		if (((4845 - (279 + 154)) == (5190 - (454 + 324))) and v79.ShadowWordPain:IsReady() and v13:IsMoving()) then
			if (((1377 + 373) >= (859 - (12 + 5))) and v88.CastTargetIf(v79.ShadowWordPain, v84, "min", v111, nil, not v14:IsSpellInRange(v79.ShadowWordPain))) then
				return "shadow_word_pain filler 28";
			end
		end
	end
	local function v134()
		local v178 = 0 + 0;
		while true do
			if (((11139 - 6767) > (684 + 1166)) and (v178 == (1093 - (277 + 816)))) then
				if (((991 - 759) < (2004 - (1058 + 125))) and v79.Fireblood:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (2 + 6)))) then
					if (((1493 - (815 + 160)) < (3870 - 2968)) and v23(v79.Fireblood)) then
						return "fireblood cds 4";
					end
				end
				if (((7107 - 4113) > (205 + 653)) and v79.Berserking:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (35 - 23)))) then
					if (v23(v79.Berserking) or ((5653 - (41 + 1857)) <= (2808 - (1222 + 671)))) then
						return "berserking cds 6";
					end
				end
				v178 = 2 - 1;
			end
			if (((5671 - 1725) > (4925 - (229 + 953))) and (v178 == (1777 - (1111 + 663)))) then
				if ((v79.DarkAscension:IsCastable() and not v13:IsCasting(v79.DarkAscension) and ((v101 and (v100:CooldownRemains() >= (1583 - (874 + 705)))) or (not v79.Mindbender:IsAvailable() and v100:CooldownDown()) or ((v87 > (1 + 1)) and not v79.InescapableTorment:IsAvailable()))) or ((911 + 424) >= (6871 - 3565))) then
					if (((137 + 4707) > (2932 - (642 + 37))) and v23(v79.DarkAscension)) then
						return "dark_ascension cds 22";
					end
				end
				if (((104 + 348) == (73 + 379)) and v30) then
					v89 = v131();
					if (v89 or ((11441 - 6884) < (2541 - (233 + 221)))) then
						return v89;
					end
				end
				break;
			end
			if (((8957 - 5083) == (3410 + 464)) and (v178 == (1543 - (718 + 823)))) then
				if ((v79.DivineStar:IsReady() and (v87 > (1 + 0)) and v80.BelorrelostheSuncaller:IsEquipped() and (v80.BelorrelostheSuncaller:CooldownRemains() <= v106)) or ((2743 - (266 + 539)) > (13971 - 9036))) then
					if (v23(v81.DivineStarPlayer, not v16:IsInRange(1255 - (636 + 589))) or ((10100 - 5845) < (7059 - 3636))) then
						return "divine_star cds 16";
					end
				end
				if (((1153 + 301) <= (905 + 1586)) and v79.VoidEruption:IsCastable() and v100:CooldownDown() and ((v101 and (v100:CooldownRemains() >= (1019 - (657 + 358)))) or not v79.Mindbender:IsAvailable() or ((v87 > (4 - 2)) and not v79.InescapableTorment:IsAvailable())) and ((v79.MindBlast:Charges() == (0 - 0)) or (v10.CombatTime() > (1202 - (1151 + 36))))) then
					if (v23(v79.VoidEruption) or ((4015 + 142) <= (737 + 2066))) then
						return "void_eruption cds 20";
					end
				end
				v178 = 8 - 5;
			end
			if (((6685 - (1552 + 280)) >= (3816 - (64 + 770))) and (v178 == (1 + 0))) then
				if (((9384 - 5250) > (597 + 2760)) and v79.BloodFury:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (1258 - (157 + 1086))))) then
					if (v23(v79.BloodFury) or ((6838 - 3421) < (11098 - 8564))) then
						return "blood_fury cds 8";
					end
				end
				if ((v79.AncestralCall:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (22 - 7)))) or ((3714 - 992) <= (983 - (599 + 220)))) then
					if (v23(v79.AncestralCall) or ((4795 - 2387) < (4040 - (1813 + 118)))) then
						return "ancestral_call cds 10";
					end
				end
				v178 = 2 + 0;
			end
		end
	end
	local function v135()
		local v179 = 1217 - (841 + 376);
		while true do
			if ((v179 == (0 - 0)) or ((8 + 25) == (3971 - 2516))) then
				v129();
				if ((v30 and ((v91 < (889 - (464 + 395))) or ((v14:TimeToDie() > (38 - 23)) and (not v97 or (v87 > (1 + 1)))))) or ((1280 - (467 + 370)) >= (8296 - 4281))) then
					v89 = v134();
					if (((2483 + 899) > (568 - 402)) and v89) then
						return v89;
					end
				end
				if ((v100:IsCastable() and v92 and ((v91 < (5 + 25)) or (v14:TimeToDie() > (34 - 19))) and (not v79.DarkAscension:IsAvailable() or (v79.DarkAscension:CooldownRemains() < v106) or (v91 < (535 - (150 + 370))))) or ((1562 - (74 + 1208)) == (7523 - 4464))) then
					if (((8920 - 7039) > (921 + 372)) and v23(v100)) then
						return "mindbender main 2";
					end
				end
				if (((2747 - (14 + 376)) == (4087 - 1730)) and v79.DevouringPlague:IsReady()) then
					if (((80 + 43) == (109 + 14)) and v88.CastCycle(v79.DevouringPlague, v84, v115, not v14:IsSpellInRange(v79.DevouringPlague))) then
						return "devouring_plague main 4";
					end
				end
				v179 = 1 + 0;
			end
			if ((v179 == (8 - 5)) or ((795 + 261) >= (3470 - (23 + 55)))) then
				if ((v79.ShadowWordDeath:IsReady() and (v13:BuffStack(v79.DeathsTormentBuff) > (20 - 11)) and v13:HasTier(21 + 10, 4 + 0) and (not v97 or not v79.ShadowCrash:IsAvailable())) or ((1675 - 594) < (339 + 736))) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((1950 - (652 + 249)) >= (11860 - 7428))) then
						return "shadow_word_death main 22";
					end
				end
				if ((v79.ShadowWordDeath:IsReady() and v92 and v79.InescapableTorment:IsAvailable() and v101 and ((not v79.InsidiousIre:IsAvailable() and not v79.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff)) and not v13:HasTier(1899 - (708 + 1160), 5 - 3)) or ((8692 - 3924) <= (873 - (10 + 17)))) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((755 + 2603) <= (3152 - (1400 + 332)))) then
						return "shadow_word_death main 24";
					end
				end
				if (v79.VampiricTouch:IsCastable() or ((7171 - 3432) <= (4913 - (242 + 1666)))) then
					if (v88.CastTargetIf(v79.VampiricTouch, v84, "min", v113, v114, not v14:IsSpellInRange(v79.VampiricTouch)) or ((710 + 949) >= (783 + 1351))) then
						return "vampiric_touch main 26";
					end
				end
				if ((v79.MindBlast:IsCastable() and (v13:BuffDown(v79.MindDevourerBuff) or (v79.VoidEruption:CooldownUp() and v79.VoidEruption:IsAvailable()))) or ((2779 + 481) < (3295 - (850 + 90)))) then
					if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((1171 - 502) == (5613 - (360 + 1030)))) then
						return "mind_blast main 26";
					end
				end
				v179 = 4 + 0;
			end
			if ((v179 == (5 - 3)) or ((2327 - 635) < (2249 - (909 + 752)))) then
				if ((v79.DevouringPlague:IsReady() and (v91 <= (v79.DevouringPlagueDebuff:BaseDuration() + (1227 - (109 + 1114))))) or ((8781 - 3984) < (1422 + 2229))) then
					if (v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague)) or ((4419 - (6 + 236)) > (3056 + 1794))) then
						return "devouring_plague main 14";
					end
				end
				if ((v79.DevouringPlague:IsReady() and ((v13:InsanityDeficit() <= (17 + 3)) or (v13:BuffUp(v79.VoidformBuff) and (v79.VoidBolt:CooldownRemains() > v13:BuffRemains(v79.VoidformBuff)) and (v79.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v79.VoidformBuff) + (4 - 2)))) or (v13:BuffUp(v79.MindDevourerBuff) and (v13:PMultiplier(v79.DevouringPlague) < (1.2 - 0))))) or ((1533 - (1076 + 57)) > (183 + 928))) then
					if (((3740 - (579 + 110)) > (80 + 925)) and v88.CastCycle(v79.DevouringPlague, v84, v115, not v14:IsSpellInRange(v79.DevouringPlague), nil, nil, v81.DevouringPlagueMouseover)) then
						return "devouring_plague main 16";
					end
				end
				if (((3266 + 427) <= (2326 + 2056)) and v79.ShadowWordDeath:IsReady() and (v13:HasTier(438 - (174 + 233), 5 - 3))) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((5760 - 2478) > (1824 + 2276))) then
						return "shadow_word_death main 18";
					end
				end
				if ((v79.ShadowCrash:IsCastable() and not v97 and (v14:DebuffRefreshable(v79.VampiricTouchDebuff) or ((v13:BuffStack(v79.DeathsTormentBuff) > (1183 - (663 + 511))) and v13:HasTier(28 + 3, 1 + 3)))) or ((11037 - 7457) < (1723 + 1121))) then
					if (((209 - 120) < (10869 - 6379)) and (v76 == "Confirm")) then
						if (v23(v79.ShadowCrash, not v14:IsInRange(20 + 20)) or ((9698 - 4715) < (1289 + 519))) then
							return "shadow_crash main 20";
						end
					elseif (((351 + 3478) > (4491 - (478 + 244))) and (v76 == "Enemy Under Cursor")) then
						if (((2002 - (440 + 77)) <= (1321 + 1583)) and v17:Exists() and v13:CanAttack(v17)) then
							if (((15624 - 11355) == (5825 - (655 + 901))) and v23(v81.ShadowCrashCursor, not v14:IsInRange(8 + 32))) then
								return "shadow_crash main 20";
							end
						end
					elseif (((297 + 90) <= (1879 + 903)) and (v76 == "At Cursor")) then
						if (v23(v81.ShadowCrashCursor, not v14:IsInRange(161 - 121)) or ((3344 - (695 + 750)) <= (3131 - 2214))) then
							return "shadow_crash main 20";
						end
					end
				end
				v179 = 3 - 0;
			end
			if ((v179 == (15 - 11)) or ((4663 - (285 + 66)) <= (2041 - 1165))) then
				if (((3542 - (682 + 628)) <= (419 + 2177)) and v79.VoidTorrent:IsCastable() and not v97) then
					if (((2394 - (176 + 123)) < (1542 + 2144)) and v88.CastCycle(v79.VoidTorrent, v84, v124, not v14:IsSpellInRange(v79.VoidTorrent), nil, nil, v81.VoidTorrentMouseover, true)) then
						return "void_torrent main 28";
					end
				end
				v89 = v133();
				if (v89 or ((1157 + 438) >= (4743 - (239 + 30)))) then
					return v89;
				end
				break;
			end
			if ((v179 == (1 + 0)) or ((4440 + 179) < (5100 - 2218))) then
				if ((v79.ShadowWordDeath:IsReady() and (v13:HasTier(96 - 65, 319 - (306 + 9)) or (v101 and v79.InescapableTorment:IsAvailable() and v13:HasTier(108 - 77, 1 + 1))) and v14:DebuffUp(v79.DevouringPlagueDebuff)) or ((181 + 113) >= (2326 + 2505))) then
					if (((5801 - 3772) <= (4459 - (1140 + 235))) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
						return "shadow_word_death main 6";
					end
				end
				if ((v79.MindBlast:IsCastable() and v101 and v79.InescapableTorment:IsAvailable() and (v102 > v79.MindBlast:ExecuteTime()) and (v87 <= (5 + 2))) or ((1868 + 169) == (622 + 1798))) then
					if (((4510 - (33 + 19)) > (1410 + 2494)) and v88.CastCycle(v79.MindBlast, v84, v117, not v14:IsSpellInRange(v79.MindBlast), nil, nil, v81.MindBlastMouseover, true)) then
						return "mind_blast main 8";
					end
				end
				if (((1306 - 870) >= (55 + 68)) and v79.ShadowWordDeath:IsReady()) then
					if (((980 - 480) < (1703 + 113)) and v88.CastCycle(v79.ShadowWordDeath, v84, v123, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
						return "shadow_word_death main 10";
					end
				end
				if (((4263 - (586 + 103)) == (326 + 3248)) and v79.VoidBolt:IsCastable() and v92) then
					if (((680 - 459) < (1878 - (1309 + 179))) and v23(v79.VoidBolt, not v14:IsInRange(72 - 32))) then
						return "void_bolt main 12";
					end
				end
				v179 = 1 + 1;
			end
		end
	end
	local function v136()
		local v180 = 0 - 0;
		while true do
			if ((v180 == (1 + 0)) or ((4701 - 2488) <= (2831 - 1410))) then
				if (((3667 - (295 + 314)) < (11937 - 7077)) and v79.DevouringPlague:IsReady() and (v14:DebuffRemains(v79.DevouringPlagueDebuff) <= (1966 - (1300 + 662))) and (v79.VoidTorrent:CooldownRemains() < (v13:GCD() * (6 - 4)))) then
					if (v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague)) or ((3051 - (1178 + 577)) >= (2309 + 2137))) then
						return "devouring_plague pl_torrent 6";
					end
				end
				if ((v79.MindBlast:IsCastable() and not v13:PrevGCD(2 - 1, v79.MindBlast)) or ((2798 - (851 + 554)) > (3970 + 519))) then
					if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((12269 - 7845) < (58 - 31))) then
						return "mind_blast pl_torrent 8";
					end
				end
				v180 = 304 - (115 + 187);
			end
			if (((2 + 0) == v180) or ((1891 + 106) > (15033 - 11218))) then
				if (((4626 - (160 + 1001)) > (1674 + 239)) and v79.VoidTorrent:IsCastable() and (v109(v14, false) or v13:BuffUp(v79.VoidformBuff))) then
					if (((506 + 227) < (3723 - 1904)) and v23(v79.VoidTorrent, not v14:IsSpellInRange(v79.VoidTorrent), true)) then
						return "void_torrent pl_torrent 10";
					end
				end
				break;
			end
			if ((v180 == (358 - (237 + 121))) or ((5292 - (525 + 372)) == (9014 - 4259))) then
				if (v79.VoidBolt:IsCastable() or ((12462 - 8669) < (2511 - (96 + 46)))) then
					if (v23(v79.VoidBolt, not v14:IsInRange(817 - (643 + 134))) or ((1475 + 2609) == (635 - 370))) then
						return "void_bolt pl_torrent 2";
					end
				end
				if (((16179 - 11821) == (4180 + 178)) and v79.VampiricTouch:IsCastable() and (v14:DebuffRemains(v79.VampiricTouchDebuff) <= (11 - 5)) and (v79.VoidTorrent:CooldownRemains() < (v13:GCD() * (3 - 1)))) then
					if (v23(v79.VampiricTouch, not v14:IsSpellInRange(v79.VampiricTouch), true) or ((3857 - (316 + 403)) < (661 + 332))) then
						return "vampiric_touch pl_torrent 4";
					end
				end
				v180 = 2 - 1;
			end
		end
	end
	local function v137()
		local v181 = 0 + 0;
		while true do
			if (((8386 - 5056) > (1647 + 676)) and (v181 == (2 + 2))) then
				if ((v105:IsCastable() and v13:BuffUp(v79.MindFlayInsanityBuff) and v79.IdolOfCthun:IsAvailable()) or ((12563 - 8937) == (19050 - 15061))) then
					if (v23(v105, not v14:IsSpellInRange(v105), true) or ((1902 - 986) == (153 + 2518))) then
						return "mind_flay aoe 28";
					end
				end
				v89 = v133();
				if (((535 - 263) == (14 + 258)) and v89) then
					return v89;
				end
				break;
			end
			if (((12500 - 8251) <= (4856 - (12 + 5))) and (v181 == (11 - 8))) then
				if (((5924 - 3147) < (6802 - 3602)) and v105:IsCastable() and v13:BuffUp(v79.MindFlayInsanityBuff) and v92 and (v79.MindBlast:FullRechargeTime() >= (v13:GCD() * (7 - 4))) and v79.IdolOfCthun:IsAvailable() and (v79.VoidTorrent:CooldownDown() or not v79.VoidTorrent:IsAvailable())) then
					if (((20 + 75) < (3930 - (1656 + 317))) and v23(v105, not v14:IsSpellInRange(v105), true)) then
						return "mind_flay aoe 22";
					end
				end
				if (((737 + 89) < (1376 + 341)) and v79.MindBlast:IsCastable() and v96 and (v13:BuffDown(v79.MindDevourerBuff) or (v79.VoidEruption:CooldownUp() and v79.VoidEruption:IsAvailable()))) then
					if (((3791 - 2365) >= (5438 - 4333)) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
						return "mind_blast aoe 24";
					end
				end
				if (((3108 - (5 + 349)) <= (16049 - 12670)) and v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (1274 - (266 + 1005))) and (not v97 or ((v87 / (v79.VampiricTouchDebuff:AuraActiveCount() + v87)) < (1.5 + 0))) and ((v13:Insanity() >= (170 - 120)) or v14:DebuffUp(v79.DevouringPlagueDebuff) or v13:BuffUp(v79.DarkReveriesBuff) or v13:BuffUp(v79.VoidformBuff) or v13:BuffUp(v79.DarkAscensionBuff))) then
					v89 = v136();
					if (v89 or ((5169 - 1242) == (3109 - (561 + 1135)))) then
						return v89;
					end
				end
				if ((v79.VoidTorrent:IsCastable() and not v79.PsychicLink:IsAvailable()) or ((1503 - 349) <= (2590 - 1802))) then
					if (v88.CastCycle(v79.VoidTorrent, v84, v127, not v14:IsSpellInRange(v79.VoidTorrent), nil, nil, v81.VoidTorrentMouseover, true) or ((2709 - (507 + 559)) > (8478 - 5099))) then
						return "void_torrent aoe 26";
					end
				end
				v181 = 12 - 8;
			end
			if ((v181 == (388 - (212 + 176))) or ((3708 - (250 + 655)) > (12404 - 7855))) then
				v130();
				if ((v79.VampiricTouch:IsCastable() and (((v94 > (0 - 0)) and not v98 and not v79.ShadowCrash:InFlight()) or not v79.WhisperingShadows:IsAvailable())) or ((344 - 124) >= (4978 - (1869 + 87)))) then
					if (((9787 - 6965) == (4723 - (484 + 1417))) and v88.CastCycle(v79.VampiricTouch, v84, v125, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, v81.VampiricTouchMouseover, true)) then
						return "vampiric_touch aoe 2";
					end
				end
				if ((v79.ShadowCrash:IsCastable() and not v97) or ((2274 - 1213) == (3112 - 1255))) then
					if (((3533 - (48 + 725)) > (2227 - 863)) and (v76 == "Confirm")) then
						if (v23(v79.ShadowCrash, not v14:IsInRange(107 - 67)) or ((2849 + 2053) <= (9607 - 6012))) then
							return "shadow_crash aoe 4";
						end
					elseif ((v76 == "Enemy Under Cursor") or ((1079 + 2773) == (86 + 207))) then
						if ((v17:Exists() and v13:CanAttack(v17)) or ((2412 - (152 + 701)) == (5899 - (430 + 881)))) then
							if (v23(v81.ShadowCrashCursor, not v14:IsInRange(16 + 24)) or ((5379 - (557 + 338)) == (233 + 555))) then
								return "shadow_crash aoe 4";
							end
						end
					elseif (((12872 - 8304) >= (13681 - 9774)) and (v76 == "At Cursor")) then
						if (((3310 - 2064) < (7478 - 4008)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(841 - (499 + 302)))) then
							return "shadow_crash aoe 4";
						end
					end
				end
				if (((4934 - (39 + 827)) >= (2682 - 1710)) and v30 and ((v91 < (67 - 37)) or ((v14:TimeToDie() > (59 - 44)) and (not v97 or (v87 > (2 - 0)))))) then
					local v215 = 0 + 0;
					while true do
						if (((1442 - 949) < (623 + 3270)) and (v215 == (0 - 0))) then
							v89 = v134();
							if (v89 or ((1577 - (103 + 1)) >= (3886 - (475 + 79)))) then
								return v89;
							end
							break;
						end
					end
				end
				v181 = 2 - 1;
			end
			if ((v181 == (3 - 2)) or ((524 + 3527) <= (1019 + 138))) then
				if (((2107 - (1395 + 108)) < (8383 - 5502)) and v100:IsCastable() and ((v14:DebuffUp(v79.ShadowWordPainDebuff) and v96) or (v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable())) and ((v91 < (1234 - (7 + 1197))) or (v14:TimeToDie() > (7 + 8))) and (not v79.DarkAscension:IsAvailable() or (v79.DarkAscension:CooldownRemains() < v106) or (v91 < (6 + 9)))) then
					if (v23(v100) or ((1219 - (27 + 292)) == (9895 - 6518))) then
						return "mindbender aoe 6";
					end
				end
				if (((5685 - 1226) > (2478 - 1887)) and v79.MindBlast:IsCastable() and ((v79.MindBlast:FullRechargeTime() <= (v106 + v79.MindBlast:CastTime())) or (v102 <= (v79.MindBlast:CastTime() + v106))) and v101 and v79.InescapableTorment:IsAvailable() and (v102 > v79.MindBlast:CastTime()) and (v87 <= (13 - 6)) and v13:BuffDown(v79.MindDevourerBuff)) then
					if (((6471 - 3073) >= (2534 - (43 + 96))) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
						return "mind_blast aoe 8";
					end
				end
				if ((v79.ShadowWordDeath:IsReady() and (v102 <= (8 - 6)) and v101 and v79.InescapableTorment:IsAvailable() and (v87 <= (15 - 8))) or ((1812 + 371) >= (798 + 2026))) then
					if (((3826 - 1890) == (742 + 1194)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
						return "shadow_word_death aoe 10";
					end
				end
				if (v79.VoidBolt:IsCastable() or ((9055 - 4223) < (1358 + 2955))) then
					if (((300 + 3788) > (5625 - (1414 + 337))) and v23(v79.VoidBolt, not v14:IsInRange(1980 - (1642 + 298)))) then
						return "void_bolt aoe 12";
					end
				end
				v181 = 4 - 2;
			end
			if (((12462 - 8130) == (12855 - 8523)) and ((1 + 1) == v181)) then
				if (((3112 + 887) >= (3872 - (357 + 615))) and v79.DevouringPlague:IsReady() and (not v99 or (v13:InsanityDeficit() <= (15 + 5)) or (v13:BuffUp(v79.VoidformBuff) and (v79.VoidBolt:CooldownRemains() > v13:BuffRemains(v79.VoidformBuff)) and (v79.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v79.VoidformBuff) + (4 - 2)))))) then
					if (v88.CastCycle(v79.DevouringPlague, v84, v116, not v14:IsSpellInRange(v79.DevouringPlague), nil, nil, v81.DevouringPlagueMouseover) or ((2164 + 361) > (8708 - 4644))) then
						return "devouring_plague aoe 14";
					end
				end
				if (((3496 + 875) == (298 + 4073)) and v79.VampiricTouch:IsCastable() and (((v94 > (0 + 0)) and not v79.ShadowCrash:InFlight()) or not v79.WhisperingShadows:IsAvailable())) then
					if (v88.CastCycle(v79.VampiricTouch, v84, v126, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, v81.VampiricTouchMouseover, true) or ((1567 - (384 + 917)) > (5683 - (128 + 569)))) then
						return "vampiric_touch aoe 16";
					end
				end
				if (((3534 - (1407 + 136)) >= (2812 - (687 + 1200))) and v79.ShadowWordDeath:IsReady() and v96 and v79.InescapableTorment:IsAvailable() and v101 and ((not v79.InsidiousIre:IsAvailable() and not v79.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff))) then
					if (((2165 - (556 + 1154)) < (7222 - 5169)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
						return "shadow_word_death aoe 18";
					end
				end
				if ((v79.MindSpikeInsanity:IsReady() and v92 and (v79.MindBlast:FullRechargeTime() >= (v13:GCD() * (98 - (9 + 86)))) and v79.IdolOfCthun:IsAvailable() and (v79.VoidTorrent:CooldownDown() or not v79.VoidTorrent:IsAvailable())) or ((1247 - (275 + 146)) == (789 + 4062))) then
					if (((247 - (29 + 35)) == (810 - 627)) and v23(v79.MindSpikeInsanity, not v14:IsInRange(119 - 79), true)) then
						return "mind_spike_insanity aoe 20";
					end
				end
				v181 = 13 - 10;
			end
		end
	end
	local function v138()
		if (((755 + 404) <= (2800 - (53 + 959))) and v79.Fade:IsReady() and v50 and (v13:HealthPercentage() <= v51)) then
			if (v23(v79.Fade, nil, nil, true) or ((3915 - (312 + 96)) > (7494 - 3176))) then
				return "fade defensive";
			end
		end
		if ((v79.Dispersion:IsCastable() and (v13:HealthPercentage() < v48) and v49) or ((3360 - (147 + 138)) <= (3864 - (813 + 86)))) then
			if (((1234 + 131) <= (3725 - 1714)) and v23(v79.Dispersion)) then
				return "dispersion defensive";
			end
		end
		if ((v79.DesperatePrayer:IsCastable() and (v13:HealthPercentage() <= v47) and v46) or ((3268 - (18 + 474)) > (1207 + 2368))) then
			if (v23(v79.DesperatePrayer) or ((8335 - 5781) == (5890 - (860 + 226)))) then
				return "desperate_prayer defensive";
			end
		end
		if (((2880 - (121 + 182)) == (318 + 2259)) and v79.VampiricEmbrace:IsReady() and v88.TargetIsValid() and v14:IsInRange(1270 - (988 + 252)) and v73 and v88.AreUnitsBelowHealthPercentage(v74, v75, v79.FlashHeal)) then
			if (v23(v79.VampiricEmbrace, nil, true) or ((1 + 5) >= (592 + 1297))) then
				return "vampiric_embrace defensive";
			end
		end
		if (((2476 - (49 + 1921)) <= (2782 - (223 + 667))) and v32) then
			if ((v79.FlashHeal:IsCastable() and (v13:HealthPercentage() <= v67) and v66) or ((2060 - (51 + 1)) > (3817 - 1599))) then
				if (((811 - 432) <= (5272 - (146 + 979))) and v23(v81.FlashHealPlayer)) then
					return "flash_heal defensive";
				end
			end
			if ((v79.Renew:IsCastable() and (v13:HealthPercentage() <= v69) and v68) or ((1274 + 3240) <= (1614 - (311 + 294)))) then
				if (v23(v81.RenewPlayer) or ((9749 - 6253) == (505 + 687))) then
					return "renew defensive";
				end
			end
			if ((v79.PowerWordShield:IsCastable() and (v13:HealthPercentage() <= v71) and v70) or ((1651 - (496 + 947)) == (4317 - (1233 + 125)))) then
				if (((1736 + 2541) >= (1178 + 135)) and v23(v81.PowerWordShieldPlayer)) then
					return "power_word_shield defensive";
				end
			end
		end
		if (((492 + 2095) < (4819 - (963 + 682))) and v80.Healthstone:IsReady() and v52 and (v13:HealthPercentage() <= v53)) then
			if (v23(v81.Healthstone, nil, nil, true) or ((3439 + 681) <= (3702 - (504 + 1000)))) then
				return "healthstone defensive 3";
			end
		end
		if ((v34 and (v13:HealthPercentage() <= v36)) or ((1075 + 521) == (782 + 76))) then
			if (((304 + 2916) == (4748 - 1528)) and (v35 == "Refreshing Healing Potion")) then
				if (v80.RefreshingHealingPotion:IsReady() or ((1198 + 204) > (2106 + 1514))) then
					if (((2756 - (156 + 26)) == (1483 + 1091)) and v23(v81.RefreshingHealingPotion, nil, nil, true)) then
						return "refreshing healing potion defensive 4";
					end
				end
			end
		end
	end
	local function v139()
		if (((2812 - 1014) < (2921 - (149 + 15))) and ((GetTime() - v28) > v40)) then
			if ((v79.BodyandSoul:IsAvailable() and v79.PowerWordShield:IsReady() and v39 and v13:BuffDown(v79.AngelicFeatherBuff) and v13:BuffDown(v79.BodyandSoulBuff)) or ((1337 - (890 + 70)) > (2721 - (39 + 78)))) then
				if (((1050 - (14 + 468)) < (2003 - 1092)) and v23(v81.PowerWordShieldPlayer)) then
					return "power_word_shield_player move";
				end
			end
			if (((9181 - 5896) < (2182 + 2046)) and v79.AngelicFeather:IsReady() and v38 and v13:BuffDown(v79.AngelicFeatherBuff) and v13:BuffDown(v79.BodyandSoulBuff) and v13:BuffDown(v79.AngelicFeatherBuff)) then
				if (((2352 + 1564) > (707 + 2621)) and v23(v81.AngelicFeatherPlayer)) then
					return "angelic_feather_player move";
				end
			end
		end
	end
	local function v140()
		if (((1130 + 1370) < (1006 + 2833)) and v79.PurifyDisease:IsReady() and v31 and v88.UnitHasDispellableDebuffByPlayer(v16)) then
			if (((970 - 463) == (502 + 5)) and v23(v81.PurifyDiseaseFocus)) then
				return "purify_disease dispel";
			end
		end
	end
	local function v141()
		local v182 = 0 - 0;
		while true do
			if (((7 + 233) <= (3216 - (12 + 39))) and (v182 == (6 + 0))) then
				v63 = EpicSettings.Settings['HaloGroup'] or (0 - 0);
				v64 = EpicSettings.Settings['UseDivineStar'];
				v65 = EpicSettings.Settings['DivineStarHP'] or (0 - 0);
				v66 = EpicSettings.Settings['UseFlashHeal'];
				v67 = EpicSettings.Settings['FlashHealHP'] or (0 + 0);
				v182 = 4 + 3;
			end
			if (((2114 - 1280) >= (537 + 268)) and (v182 == (19 - 15))) then
				v53 = EpicSettings.Settings['HealthstoneHP'] or (1710 - (1596 + 114));
				v54 = EpicSettings.Settings['PowerInfusionUsage'] or "";
				v55 = EpicSettings.Settings['PowerInfusionTarget'] or "";
				v56 = EpicSettings.Settings['PowerInfusionHP'] or (0 - 0);
				v57 = EpicSettings.Settings['PowerInfusionGroup'] or (713 - (164 + 549));
				v182 = 1443 - (1059 + 379);
			end
			if ((v182 == (3 - 0)) or ((1976 + 1836) < (391 + 1925))) then
				v48 = EpicSettings.Settings['DispersionHP'] or (392 - (145 + 247));
				v49 = EpicSettings.Settings['UseDispersion'];
				v50 = EpicSettings.Settings['UseFade'];
				v51 = EpicSettings.Settings['FadeHP'] or (0 + 0);
				v52 = EpicSettings.Settings['UseHealthstone'];
				v182 = 2 + 2;
			end
			if ((v182 == (0 - 0)) or ((509 + 2143) <= (1321 + 212))) then
				v33 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or "";
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
				v37 = EpicSettings.Settings['UsePowerWordFortitude'];
				v182 = 721 - (254 + 466);
			end
			if (((565 - (544 + 16)) == v182) or ((11434 - 7836) < (2088 - (294 + 334)))) then
				v58 = EpicSettings.Settings['PIName1'] or "";
				v59 = EpicSettings.Settings['PIName2'] or "";
				v60 = EpicSettings.Settings['PIName3'] or "";
				v61 = EpicSettings.Settings['UseHalo'];
				v62 = EpicSettings.Settings['HaloHP'] or (253 - (236 + 17));
				v182 = 3 + 3;
			end
			if ((v182 == (6 + 1)) or ((15501 - 11385) < (5643 - 4451))) then
				v68 = EpicSettings.Settings['UseRenew'];
				v69 = EpicSettings.Settings['RenewHP'] or (0 + 0);
				v70 = EpicSettings.Settings['UsePowerWordShield'];
				v71 = EpicSettings.Settings['PowerWordShieldHP'] or (0 + 0);
				v72 = EpicSettings.Settings['UseShadowform'];
				v182 = 802 - (413 + 381);
			end
			if ((v182 == (1 + 7)) or ((7182 - 3805) <= (2345 - 1442))) then
				v73 = EpicSettings.Settings['UseVampiricEmbrace'];
				v74 = EpicSettings.Settings['VampiricEmbraceHP'] or (1970 - (582 + 1388));
				v75 = EpicSettings.Settings['VampiricEmbraceGroup'] or (0 - 0);
				v76 = EpicSettings.Settings['ShadowCrashUsage'] or "";
				v77 = EpicSettings.Settings['VampiricTouchUsage'] or "";
				v182 = 7 + 2;
			end
			if (((4340 - (326 + 38)) >= (1298 - 859)) and (v182 == (12 - 3))) then
				v78 = EpicSettings.Settings['VampiricTouchMax'] or (620 - (47 + 573));
				break;
			end
			if (((1323 + 2429) == (15934 - 12182)) and (v182 == (2 - 0))) then
				v43 = EpicSettings.Settings['InterruptWithStun'];
				v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v45 = EpicSettings.Settings['InterruptThreshold'] or (1664 - (1269 + 395));
				v46 = EpicSettings.Settings['UseDesperatePrayer'];
				v47 = EpicSettings.Settings['DesperatePrayerHP'] or (492 - (76 + 416));
				v182 = 446 - (319 + 124);
			end
			if (((9248 - 5202) > (3702 - (564 + 443))) and (v182 == (2 - 1))) then
				v38 = EpicSettings.Settings['UseAngelicFeather'];
				v39 = EpicSettings.Settings['UseBodyAndSoul'];
				v40 = EpicSettings.Settings['MovementDelay'] or (458 - (337 + 121));
				v41 = EpicSettings.Settings['DispelDebuffs'];
				v42 = EpicSettings.Settings['DispelBuffs'];
				v182 = 5 - 3;
			end
		end
	end
	local function v142()
		local v183 = 0 - 0;
		while true do
			if ((v183 == (1911 - (1261 + 650))) or ((1500 + 2045) == (5095 - 1898))) then
				v141();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['dispel'];
				v183 = 1818 - (772 + 1045);
			end
			if (((338 + 2056) > (517 - (102 + 42))) and (v183 == (1845 - (1524 + 320)))) then
				v32 = EpicSettings.Toggles['heal'];
				v83 = v13:GetEnemiesInRange(1300 - (1049 + 221));
				v84 = v13:GetEnemiesInRange(196 - (18 + 138));
				v85 = v14:GetEnemiesInSplashRange(24 - 14);
				v183 = 1104 - (67 + 1035);
			end
			if (((4503 - (136 + 212)) <= (17983 - 13751)) and (v183 == (3 + 0))) then
				if ((not v13:AffectingCombat() and v29) or ((3302 + 279) == (5077 - (240 + 1364)))) then
					local v216 = 1082 - (1050 + 32);
					while true do
						if (((17835 - 12840) > (1981 + 1367)) and (v216 == (1055 - (331 + 724)))) then
							if ((v79.PowerWordFortitude:IsCastable() and v37 and (v13:BuffDown(v79.PowerWordFortitudeBuff, true) or v88.GroupBuffMissing(v79.PowerWordFortitudeBuff))) or ((61 + 693) > (4368 - (269 + 375)))) then
								if (((942 - (267 + 458)) >= (18 + 39)) and v23(v81.PowerWordFortitudePlayer)) then
									return "power_word_fortitude";
								end
							end
							if (HandleAfflicted or ((3980 - 1910) >= (4855 - (667 + 151)))) then
								local v223 = 1497 - (1410 + 87);
								while true do
									if (((4602 - (1504 + 393)) == (7311 - 4606)) and (v223 == (0 - 0))) then
										v89 = v88.HandleAfflicted(v79.PurifyDisease, v81.PurifyDiseaseMouseover, 836 - (461 + 335));
										if (((8 + 53) == (1822 - (1730 + 31))) and v89) then
											return v89;
										end
										break;
									end
								end
							end
							v216 = 1668 - (728 + 939);
						end
						if ((v216 == (3 - 2)) or ((1417 - 718) >= (2969 - 1673))) then
							if ((v79.PowerWordFortitude:IsCastable() and (v13:BuffDown(v79.PowerWordFortitudeBuff, true) or v88.GroupBuffMissing(v79.PowerWordFortitudeBuff))) or ((2851 - (138 + 930)) >= (3305 + 311))) then
								if (v23(v81.PowerWordFortitudePlayer) or ((3060 + 853) > (3880 + 647))) then
									return "power_word_fortitude";
								end
							end
							if (((17868 - 13492) > (2583 - (459 + 1307))) and v79.Shadowform:IsCastable() and (v13:BuffDown(v79.ShadowformBuff)) and v72) then
								if (((6731 - (474 + 1396)) > (1438 - 614)) and v23(v79.Shadowform)) then
									return "shadowform";
								end
							end
							v216 = 2 + 0;
						end
						if ((v216 == (1 + 1)) or ((3961 - 2578) >= (271 + 1860))) then
							if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((6262 - 4386) >= (11081 - 8540))) then
								if (((2373 - (562 + 29)) <= (3216 + 556)) and v23(v79.Resurrection, nil, true)) then
									return "resurrection";
								end
							end
							break;
						end
					end
				end
				if ((v13:IsMoving() and (v13:AffectingCombat() or v29)) or ((6119 - (374 + 1045)) < (644 + 169))) then
					v89 = v139();
					if (((9933 - 6734) < (4688 - (448 + 190))) and v89) then
						return v89;
					end
				end
				if (v88.TargetIsValid() or v13:AffectingCombat() or ((1599 + 3352) < (2000 + 2430))) then
					v90 = v10.BossFightRemains(nil, true);
					v91 = v90;
					if (((63 + 33) == (369 - 273)) and (v91 == (34525 - 23414))) then
						v91 = v10.FightRemains(v85, false);
					end
					v101 = v100:TimeSinceLastCast() <= (1509 - (1307 + 187));
					v102 = (59 - 44) - v100:TimeSinceLastCast();
					if ((v102 < (0 - 0)) or ((8398 - 5659) > (4691 - (232 + 451)))) then
						v102 = 0 + 0;
					end
					v105 = ((v13:BuffUp(v79.MindFlayInsanityBuff)) and v79.MindFlayInsanity) or v79.MindFlay;
					v106 = v13:GCD() + 0.25 + 0;
				end
				if (v88.TargetIsValid() or ((587 - (510 + 54)) == (2284 - 1150))) then
					if ((not v13:AffectingCombat() and v29) or ((2729 - (13 + 23)) >= (8013 - 3902))) then
						v89 = v128();
						if (v89 or ((6201 - 1885) <= (3898 - 1752))) then
							return v89;
						end
					end
					if (v13:AffectingCombat() or v29 or ((4634 - (830 + 258)) <= (9908 - 7099))) then
						v89 = v138();
						if (((3069 + 1835) > (1843 + 323)) and v89) then
							return v89;
						end
						if (((1550 - (860 + 581)) >= (331 - 241)) and not v13:IsCasting() and not v13:IsChanneling()) then
							v89 = v88.Interrupt(v79.Silence, 24 + 6, true);
							if (((5219 - (237 + 4)) > (6827 - 3922)) and v89) then
								return v89;
							end
							v89 = v88.Interrupt(v79.Silence, 75 - 45, true, v17, v81.SilenceMouseover);
							if (v89 or ((5737 - 2711) <= (1867 + 413))) then
								return v89;
							end
							v89 = v88.InterruptWithStun(v79.PsychicScream, 5 + 3);
							if (v89 or ((6240 - 4587) <= (476 + 632))) then
								return v89;
							end
						end
						v97 = false;
						v99 = ((v79.VoidEruption:CooldownRemains() <= (v13:GCD() * (2 + 1))) and v79.VoidEruption:IsAvailable()) or (v79.DarkAscension:CooldownUp() and v79.DarkAscension:IsAvailable()) or (v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (1430 - (85 + 1341))) and v13:BuffDown(v79.VoidformBuff));
						if (((4963 - 2054) > (7368 - 4759)) and (v104 == nil)) then
							v104 = v14:GUID();
						end
						if (((1129 - (45 + 327)) > (365 - 171)) and (v103 == false) and v29 and (v14:GUID() == v104) and not v109(v14, true)) then
							local v222 = 502 - (444 + 58);
							while true do
								if ((v222 == (0 + 0)) or ((6 + 25) >= (684 + 714))) then
									v89 = v132();
									if (((9261 - 6065) <= (6604 - (64 + 1668))) and v89) then
										return v89;
									end
									v222 = 1974 - (1227 + 746);
								end
								if (((10223 - 6897) == (6172 - 2846)) and (v222 == (495 - (415 + 79)))) then
									if (((37 + 1396) <= (4369 - (142 + 349))) and v23(v79.Pool)) then
										return "Pool for Opener()";
									end
									break;
								end
							end
						else
							v103 = true;
						end
						if (v16 or ((679 + 904) == (2385 - 650))) then
							if (v41 or ((1482 + 1499) == (1656 + 694))) then
								local v224 = 0 - 0;
								while true do
									if ((v224 == (1864 - (1710 + 154))) or ((4784 - (200 + 118)) <= (196 + 297))) then
										v89 = v140();
										if (v89 or ((4452 - 1905) <= (2946 - 959))) then
											return v89;
										end
										break;
									end
								end
							end
						end
						if (((2631 + 330) > (2711 + 29)) and v79.DispelMagic:IsReady() and v31 and v42 and not v13:IsCasting() and not v13:IsChanneling() and v88.UnitHasMagicBuff(v14)) then
							if (((1984 + 1712) >= (577 + 3035)) and v23(v79.DispelMagic, not v14:IsSpellInRange(v79.DispelMagic))) then
								return "dispel_magic damage";
							end
						end
						if ((v87 > (4 - 2)) or (v86 > (1253 - (363 + 887))) or ((5186 - 2216) == (8938 - 7060))) then
							v89 = v137();
							if (v89 or ((571 + 3122) < (4625 - 2648))) then
								return v89;
							end
							if (v23(v79.Pool) or ((636 + 294) > (3765 - (674 + 990)))) then
								return "Pool for AoE()";
							end
						end
						v89 = v135();
						if (((1191 + 2962) > (1263 + 1823)) and v89) then
							return v89;
						end
					end
					if (v23(v79.Pool) or ((7377 - 2723) <= (5105 - (507 + 548)))) then
						return "Pool for Main()";
					end
				end
				break;
			end
			if ((v183 == (839 - (289 + 548))) or ((4420 - (821 + 997)) < (1751 - (195 + 60)))) then
				if (AOE or ((275 + 745) > (3789 - (251 + 1250)))) then
					v86 = #v83;
					v87 = v14:GetEnemiesInSplashRangeCount(29 - 19);
				else
					local v217 = 0 + 0;
					while true do
						if (((1360 - (809 + 223)) == (478 - 150)) and (v217 == (0 - 0))) then
							v86 = 3 - 2;
							v87 = 1 + 0;
							break;
						end
					end
				end
				if (((792 + 719) < (4425 - (14 + 603))) and v13:IsDeadOrGhost()) then
					return;
				end
				if (not v13:IsMoving() or ((2639 - (118 + 11)) > (796 + 4123))) then
					v28 = GetTime();
				end
				if (((3968 + 795) == (13880 - 9117)) and (v13:AffectingCombat() or v41)) then
					local v218 = 949 - (551 + 398);
					local v219;
					while true do
						if (((2615 + 1522) > (658 + 1190)) and (v218 == (0 + 0))) then
							v219 = v41 and v79.Purify:IsReady();
							v89 = v88.FocusUnit(v219, nil, nil, nil, 74 - 54, v79.FlashHeal);
							v218 = 2 - 1;
						end
						if (((790 + 1646) <= (12441 - 9307)) and (v218 == (1 + 0))) then
							if (((3812 - (40 + 49)) == (14177 - 10454)) and v89) then
								return v89;
							end
							break;
						end
					end
				end
				v183 = 493 - (99 + 391);
			end
		end
	end
	local function v143()
		v107();
		v79.VampiricTouchDebuff:RegisterAuraTracking();
		v20.Print("Shadow Priest by Epic BoomK");
		EpicSettings.SetupVersion("Shadow Priest X v 10.2.01 By BoomK");
	end
	v20.SetAPL(214 + 44, v142, v143);
end;
return v0["Epix_Priest_Shadow.lua"]();

