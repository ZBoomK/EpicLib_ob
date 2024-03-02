local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((1538 + 1146) > (283 + 263)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((727 + 738) <= (3196 + 1105)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1415 - (1001 + 413);
		end
		if (((3799 - 2095) > (2307 - (244 + 638))) and (v5 == (694 - (627 + 66)))) then
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
	local v90 = 11713 - (512 + 90);
	local v91 = 13017 - (1665 + 241);
	local v92 = false;
	local v93 = false;
	local v94 = 717 - (373 + 344);
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
		local v144 = 0 + 0;
		while true do
			if ((v144 == (2 - 1)) or ((1162 - 475) == (5333 - (35 + 1064)))) then
				v93 = false;
				VarMindSearCutoff = 2 + 0;
				VarPoolAmount = 128 - 68;
				v144 = 1 + 1;
			end
			if ((v144 == (1239 - (298 + 938))) or ((4589 - (233 + 1026)) < (3095 - (636 + 1030)))) then
				v97 = false;
				v98 = false;
				v99 = false;
				v144 = 3 + 1;
			end
			if (((1121 + 26) >= (100 + 235)) and (v144 == (0 + 0))) then
				v90 = 11332 - (55 + 166);
				v91 = 2154 + 8957;
				v92 = false;
				v144 = 1 + 0;
			end
			if (((13118 - 9683) > (2394 - (36 + 261))) and (v144 == (3 - 1))) then
				v94 = 1368 - (34 + 1334);
				v95 = false;
				v96 = false;
				v144 = 2 + 1;
			end
			if ((v144 == (4 + 1)) or ((5053 - (1035 + 248)) >= (4062 - (20 + 1)))) then
				v104 = nil;
				break;
			end
			if (((3 + 1) == v144) or ((4110 - (134 + 185)) <= (2744 - (549 + 584)))) then
				v101 = false;
				v102 = 685 - (314 + 371);
				v103 = false;
				v144 = 17 - 12;
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
		local v147 = 968 - (478 + 490);
		while true do
			if ((v147 == (0 + 0)) or ((5750 - (786 + 386)) <= (6503 - 4495))) then
				v79.ShadowCrash:RegisterInFlightEffect(206765 - (1055 + 324));
				v79.ShadowCrash:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v79.ShadowCrash:RegisterInFlightEffect(206726 - (1093 + 247));
	v79.ShadowCrash:RegisterInFlight();
	local function v108()
		local v148 = 0 + 0;
		local v149;
		while true do
			if (((119 + 1006) <= (8242 - 6166)) and (v148 == (6 - 4))) then
				if (v79.DistortedReality:IsAvailable() or ((2113 - 1370) >= (11054 - 6655))) then
					v149 = v149 * (1.2 + 0);
				end
				if (((4449 - 3294) < (5766 - 4093)) and v13:BuffUp(v79.MindDevourerBuff)) then
					v149 = v149 * (1.2 + 0);
				end
				v148 = 7 - 4;
			end
			if ((v148 == (688 - (364 + 324))) or ((6370 - 4046) <= (1386 - 808))) then
				v149 = 1 + 0;
				if (((15762 - 11995) == (6032 - 2265)) and v13:BuffUp(v79.DarkAscensionBuff)) then
					v149 = v149 * (2.25 - 1);
				end
				v148 = 1269 - (1249 + 19);
			end
			if (((3691 + 398) == (15916 - 11827)) and (v148 == (1089 - (686 + 400)))) then
				if (((3498 + 960) >= (1903 - (73 + 156))) and v79.Voidtouched:IsAvailable()) then
					v149 = v149 * (1.06 + 0);
				end
				return v149;
			end
			if (((1783 - (721 + 90)) <= (16 + 1402)) and ((3 - 2) == v148)) then
				if (v13:BuffUp(v79.DarkEvangelismBuff) or ((5408 - (224 + 246)) < (7714 - 2952))) then
					v149 = v149 * ((1 - 0) + ((0.01 + 0) * v13:BuffStack(v79.DarkEvangelismBuff)));
				end
				if (v13:BuffUp(v79.DevouredFearBuff) or v13:BuffUp(v79.DevouredPrideBuff) or ((60 + 2444) > (3132 + 1132))) then
					v149 = v149 * (1.05 - 0);
				end
				v148 = 6 - 4;
			end
		end
	end
	v79.DevouringPlague:RegisterPMultiplier(v79.DevouringPlagueDebuff, v108);
	local function v109(v150, v151)
		if (((2666 - (203 + 310)) == (4146 - (1238 + 755))) and v151) then
			return v150:DebuffUp(v79.ShadowWordPainDebuff) and v150:DebuffUp(v79.VampiricTouchDebuff) and v150:DebuffUp(v79.DevouringPlagueDebuff);
		else
			return v150:DebuffUp(v79.ShadowWordPainDebuff) and v150:DebuffUp(v79.VampiricTouchDebuff);
		end
	end
	local function v110(v152, v153)
		local v154 = 0 + 0;
		local v155;
		local v156;
		while true do
			if ((v154 == (1534 - (709 + 825))) or ((934 - 427) >= (3774 - 1183))) then
				if (((5345 - (196 + 668)) == (17692 - 13211)) and not v152) then
					return nil;
				end
				v155 = 0 - 0;
				v154 = 834 - (171 + 662);
			end
			if ((v154 == (94 - (4 + 89))) or ((8159 - 5831) < (253 + 440))) then
				v156 = nil;
				for v213, v214 in pairs(v152) do
					local v215 = 0 - 0;
					local v216;
					while true do
						if (((1698 + 2630) == (5814 - (35 + 1451))) and (v215 == (1453 - (28 + 1425)))) then
							v216 = v214:TimeToDie();
							if (((3581 - (941 + 1052)) >= (1278 + 54)) and v153) then
								if (((v216 * v25(v214:DebuffRefreshable(v79.VampiricTouchDebuff))) > v155) or ((5688 - (822 + 692)) > (6064 - 1816))) then
									local v230 = 0 + 0;
									while true do
										if ((v230 == (297 - (45 + 252))) or ((4538 + 48) <= (29 + 53))) then
											v155 = v216;
											v156 = v214;
											break;
										end
									end
								end
							elseif (((9401 - 5538) == (4296 - (114 + 319))) and (v216 > v155)) then
								local v231 = 0 - 0;
								while true do
									if ((v231 == (0 - 0)) or ((180 + 102) <= (61 - 19))) then
										v155 = v216;
										v156 = v214;
										break;
									end
								end
							end
							break;
						end
					end
				end
				v154 = 3 - 1;
			end
			if (((6572 - (556 + 1407)) >= (1972 - (741 + 465))) and (v154 == (467 - (170 + 295)))) then
				return v156;
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
		return v160:DebuffRefreshable(v79.VampiricTouchDebuff) and (v160:TimeToDie() >= (7 + 5)) and (((v79.ShadowCrash:CooldownRemains() >= v160:DebuffRemains(v79.VampiricTouchDebuff)) and not v79.ShadowCrash:InFlight()) or v97 or not v79.WhisperingShadows:IsAvailable());
	end
	local function v115(v161)
		return not v79.DistortedReality:IsAvailable() or (v87 == (1 + 0)) or (v161:DebuffRemains(v79.DevouringPlagueDebuff) <= v106) or (v13:InsanityDeficit() <= (39 - 23));
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
		return ((v166:HealthPercentage() < (17 + 3)) and ((v100:CooldownRemains() >= (7 + 3)) or not v79.InescapableTorment:IsAvailable())) or (v101 and v79.InescapableTorment:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff);
	end
	local function v121(v167)
		return (v167:HealthPercentage() < (12 + 8)) or v13:BuffUp(v79.DeathspeakerBuff) or v13:HasTier(1261 - (957 + 273), 1 + 1);
	end
	local function v122(v168)
		return v168:HealthPercentage() < (9 + 11);
	end
	local function v123(v169)
		return v169:DebuffUp(v79.DevouringPlagueDebuff) and (v102 <= (7 - 5)) and v101 and v79.InescapableTorment:IsAvailable() and (v87 <= (18 - 11));
	end
	local function v111(v170)
		return (v170:DebuffRemains(v79.ShadowWordPainDebuff));
	end
	local function v124(v171)
		return v171:DebuffRemains(v79.DevouringPlagueDebuff) >= (5.5 - 3);
	end
	local function v125(v172)
		return v172:DebuffRefreshable(v79.VampiricTouchDebuff) and (v172:TimeToDie() >= (89 - 71)) and (v172:DebuffUp(v79.VampiricTouchDebuff) or not v96);
	end
	local function v126(v173)
		local v174 = 1780 - (389 + 1391);
		while true do
			if ((v174 == (0 + 0)) or ((120 + 1032) == (5664 - 3176))) then
				if (((4373 - (783 + 168)) > (11243 - 7893)) and ((v79.ShadowCrash:CooldownRemains() >= v173:DebuffRemains(v79.VampiricTouchDebuff)) or v97)) then
					return v173:DebuffRefreshable(v79.VampiricTouchDebuff) and (v173:TimeToDie() >= (18 + 0)) and (v173:DebuffUp(v79.VampiricTouchDebuff) or not v96);
				end
				return nil;
			end
		end
	end
	local function v127(v175)
		return (v109(v175, false));
	end
	local function v128()
		v104 = v14:GUID();
		if (((1188 - (309 + 2)) > (1154 - 778)) and v79.ArcaneTorrent:IsCastable() and v30) then
			if (v23(v79.ArcaneTorrent, not v14:IsSpellInRange(v79.ArcaneTorrent)) or ((4330 - (1090 + 122)) <= (601 + 1250))) then
				return "arcane_torrent precombat 6";
			end
		end
		local v176 = v13:IsInParty() and not v13:IsInRaid();
		if ((v79.ShadowCrash:IsCastable() and not v176) or ((554 - 389) >= (2390 + 1102))) then
			if (((5067 - (628 + 490)) < (871 + 3985)) and (v76 == "Confirm")) then
				if (v23(v79.ShadowCrash, not v14:IsInRange(99 - 59)) or ((19541 - 15265) < (3790 - (431 + 343)))) then
					return "shadow_crash precombat 8";
				end
			elseif (((9471 - 4781) > (11933 - 7808)) and (v76 == "Enemy Under Cursor")) then
				if ((v17:Exists() and v13:CanAttack(v17)) or ((40 + 10) >= (115 + 781))) then
					if (v23(v81.ShadowCrashCursor, not v14:IsInRange(1735 - (556 + 1139))) or ((1729 - (6 + 9)) >= (542 + 2416))) then
						return "shadow_crash precombat 8";
					end
				end
			elseif ((v76 == "At Cursor") or ((764 + 727) < (813 - (28 + 141)))) then
				if (((273 + 431) < (1217 - 230)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(29 + 11))) then
					return "shadow_crash precombat 8";
				end
			end
		end
		if (((5035 - (486 + 831)) > (4959 - 3053)) and v79.VampiricTouch:IsCastable() and (not v79.ShadowCrash:IsAvailable() or (v79.ShadowCrash:CooldownDown() and not v79.ShadowCrash:InFlight()) or v176)) then
			if (v23(v79.VampiricTouch, not v14:IsSpellInRange(v79.VampiricTouch), true) or ((3372 - 2414) > (687 + 2948))) then
				return "vampiric_touch precombat 14";
			end
		end
		if (((11070 - 7569) <= (5755 - (668 + 595))) and v79.ShadowWordPain:IsCastable() and not v79.Misery:IsAvailable()) then
			if (v23(v79.ShadowWordPain, not v14:IsSpellInRange(v79.ShadowWordPain)) or ((3098 + 344) < (514 + 2034))) then
				return "shadow_word_pain precombat 16";
			end
		end
	end
	local function v129()
		local v177 = 0 - 0;
		while true do
			if (((3165 - (23 + 267)) >= (3408 - (1129 + 815))) and (v177 == (388 - (371 + 16)))) then
				v99 = ((v79.VoidEruption:CooldownRemains() <= (v13:GCD() * (1753 - (1326 + 424)))) and v79.VoidEruption:IsAvailable()) or (v79.DarkAscension:CooldownUp() and v79.DarkAscension:IsAvailable()) or (v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (7 - 3)) and v13:BuffDown(v79.VoidformBuff));
				break;
			end
			if ((v177 == (0 - 0)) or ((4915 - (88 + 30)) >= (5664 - (720 + 51)))) then
				v92 = v109(v14, false) or (v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable());
				v93 = v109(v14, true);
				v177 = 2 - 1;
			end
		end
	end
	local function v130()
		v94 = v27(v87, v78);
		v95 = false;
		local v178 = v110(v85, true);
		if ((v178 and (v178:TimeToDie() >= (1794 - (421 + 1355)))) or ((908 - 357) > (1016 + 1052))) then
			v95 = true;
		end
		v96 = ((v79.VampiricTouchDebuff:AuraActiveCount() + ((1091 - (286 + 797)) * v25(v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable()))) >= v94) or not v95;
		if (((7727 - 5613) > (1563 - 619)) and v97 and v79.WhisperingShadows:IsAvailable()) then
			v97 = (v94 - v79.VampiricTouchDebuff:AuraActiveCount()) < (443 - (397 + 42));
		end
		v98 = ((v79.VampiricTouchDebuff:AuraActiveCount() + ((3 + 5) * v25(not v97))) >= v94) or not v95;
	end
	local function v131()
		if (v13:BuffUp(v79.VoidformBuff) or v13:BuffUp(v79.PowerInfusionBuff) or v13:BuffUp(v79.DarkAscensionBuff) or (v91 < (820 - (24 + 776))) or ((3484 - 1222) >= (3881 - (222 + 563)))) then
			local v207 = 0 - 0;
			while true do
				if ((v207 == (0 + 0)) or ((2445 - (23 + 167)) >= (5335 - (690 + 1108)))) then
					v89 = v88.HandleTopTrinket(v82, CDs, 15 + 25, nil);
					if (v89 or ((3165 + 672) < (2154 - (40 + 808)))) then
						return v89;
					end
					v207 = 1 + 0;
				end
				if (((11280 - 8330) == (2820 + 130)) and (v207 == (1 + 0))) then
					v89 = v88.HandleBottomTrinket(v82, CDs, 22 + 18, nil);
					if (v89 or ((5294 - (47 + 524)) < (2141 + 1157))) then
						return v89;
					end
					break;
				end
			end
		end
	end
	local function v132()
		local v179 = 0 - 0;
		while true do
			if (((1698 - 562) >= (350 - 196)) and ((1728 - (1165 + 561)) == v179)) then
				if (v79.DevouringPlague:IsReady() or ((9 + 262) > (14705 - 9957))) then
					if (((1809 + 2931) >= (3631 - (341 + 138))) and v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague))) then
						return "devouring_plague opener 18";
					end
				end
				if (v79.MindBlast:IsCastable() or ((696 + 1882) >= (6996 - 3606))) then
					if (((367 - (89 + 237)) <= (5343 - 3682)) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
						return "mind_blast opener 20";
					end
				end
				if (((1265 - 664) < (4441 - (581 + 300))) and v79.MindSpike:IsCastable()) then
					if (((1455 - (855 + 365)) < (1631 - 944)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
						return "mind_spike opener 22";
					end
				end
				if (((1486 + 3063) > (2388 - (1030 + 205))) and v79.MindFlay:IsCastable()) then
					if (v23(v79.MindFlay, not v14:IsSpellInRange(v79.MindFlay), true) or ((4388 + 286) < (4347 + 325))) then
						return "mind_flay opener 24";
					end
				end
				break;
			end
			if (((3954 - (156 + 130)) < (10363 - 5802)) and ((1 - 0) == v179)) then
				if (v79.VoidEruption:IsAvailable() or ((931 - 476) == (950 + 2655))) then
					if ((v79.ShadowWordDeath:IsCastable() and v79.InescapableTorment:IsAvailable() and v13:PrevGCDP(1 + 0, v79.MindBlast) and (v79.ShadowWordDeath:TimeSinceLastCast() > (89 - (10 + 59)))) or ((754 + 1909) == (16310 - 12998))) then
						if (((5440 - (671 + 492)) <= (3563 + 912)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
							return "shadow_word_death opener 8";
						end
					end
					if (v79.MindBlast:IsCastable() or ((2085 - (369 + 846)) == (315 + 874))) then
						if (((1326 + 227) <= (5078 - (1036 + 909))) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
							return "mind_blast opener 10";
						end
					end
					if (v79.VoidEruption:IsCastable() or ((1779 + 458) >= (5894 - 2383))) then
						if (v23(v79.VoidEruption, not v14:IsInRange(243 - (11 + 192)), true) or ((670 + 654) > (3195 - (135 + 40)))) then
							return "void_eruption opener 12";
						end
					end
				end
				v89 = v131();
				if (v89 or ((7249 - 4257) == (1134 + 747))) then
					return v89;
				end
				if (((6842 - 3736) > (2287 - 761)) and v79.VoidBolt:IsCastable()) then
					if (((3199 - (50 + 126)) < (10776 - 6906)) and v23(v79.VoidBolt, not v14:IsInRange(9 + 31))) then
						return "void_bolt opener 16";
					end
				end
				v179 = 1415 - (1233 + 180);
			end
			if (((1112 - (522 + 447)) > (1495 - (107 + 1314))) and (v179 == (0 + 0))) then
				if (((54 - 36) < (898 + 1214)) and v79.ShadowCrash:IsCastable() and (v14:DebuffDown(v79.VampiricTouchDebuff))) then
					if (((2177 - 1080) <= (6441 - 4813)) and (v76 == "Confirm")) then
						if (((6540 - (716 + 1194)) == (80 + 4550)) and v23(v79.ShadowCrash, not v14:IsInRange(5 + 35))) then
							return "shadow_crash opener 2";
						end
					elseif (((4043 - (74 + 429)) > (5175 - 2492)) and (v76 == "Enemy Under Cursor")) then
						if (((2377 + 2417) >= (7496 - 4221)) and v17:Exists() and v13:CanAttack(v17)) then
							if (((1050 + 434) == (4575 - 3091)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(98 - 58))) then
								return "shadow_crash opener 2";
							end
						end
					elseif (((1865 - (279 + 154)) < (4333 - (454 + 324))) and (v76 == "At Cursor")) then
						if (v23(v81.ShadowCrashCursor, not v14:IsInRange(32 + 8)) or ((1082 - (12 + 5)) > (1930 + 1648))) then
							return "shadow_crash opener 2";
						end
					end
				end
				if ((v79.VampiricTouch:IsCastable() and v14:DebuffDown(v79.VampiricTouchDebuff) and (v79.ShadowCrash:CooldownDown() or not v79.ShadowCrash:IsAvailable())) or ((12217 - 7422) < (520 + 887))) then
					if (((2946 - (277 + 816)) < (20566 - 15753)) and v22(v79.VampiricTouch, nil, nil, not v14:IsSpellInRange(v79.VampiricTouch))) then
						return "vampiric_touch opener 3";
					end
				end
				if ((v100:IsCastable() and v30) or ((4004 - (1058 + 125)) < (456 + 1975))) then
					if (v23(v100) or ((3849 - (815 + 160)) < (9357 - 7176))) then
						return "mindbender opener 4";
					end
				end
				if (v79.DarkAscension:IsCastable() or ((6383 - 3694) <= (82 + 261))) then
					if (v23(v79.DarkAscension) or ((5463 - 3594) == (3907 - (41 + 1857)))) then
						return "dark_ascension opener 6";
					end
				end
				v179 = 1894 - (1222 + 671);
			end
		end
	end
	local function v133()
		local v180 = 0 - 0;
		while true do
			if ((v180 == (2 - 0)) or ((4728 - (229 + 953)) < (4096 - (1111 + 663)))) then
				if ((v79.DivineStar:IsReady() and (v16:HealthPercentage() < v65) and v64) or ((3661 - (874 + 705)) == (669 + 4104))) then
					if (((2214 + 1030) > (2192 - 1137)) and v23(v81.DivineStarPlayer, not v16:IsInRange(1 + 29))) then
						return "divine_star heal";
					end
				end
				if ((v79.Halo:IsReady() and v88.TargetIsValid() and v14:IsInRange(709 - (642 + 37)) and v61 and v88.AreUnitsBelowHealthPercentage(v62, v63, v79.FlashHeal)) or ((756 + 2557) <= (285 + 1493))) then
					if (v23(v79.Halo, nil, true) or ((3567 - 2146) >= (2558 - (233 + 221)))) then
						return "halo heal";
					end
				end
				if (((4189 - 2377) <= (2860 + 389)) and v79.MindSpike:IsCastable()) then
					if (((3164 - (718 + 823)) <= (1232 + 725)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
						return "mind_spike filler 16";
					end
				end
				v180 = 808 - (266 + 539);
			end
			if (((12491 - 8079) == (5637 - (636 + 589))) and (v180 == (6 - 3))) then
				if (((3609 - 1859) >= (668 + 174)) and v105:IsCastable()) then
					if (((1589 + 2783) > (2865 - (657 + 358))) and v23(v105, not v14:IsSpellInRange(v105), true)) then
						return "mind_flay filler 18";
					end
				end
				if (((613 - 381) < (1870 - 1049)) and v79.ShadowCrash:IsCastable()) then
					if (((1705 - (1151 + 36)) < (872 + 30)) and (v76 == "Confirm")) then
						if (((788 + 2206) > (2562 - 1704)) and v23(v79.ShadowCrash, not v14:IsInRange(1872 - (1552 + 280)))) then
							return "shadow_crash filler 20";
						end
					elseif ((v76 == "Enemy Under Cursor") or ((4589 - (64 + 770)) <= (622 + 293))) then
						if (((8957 - 5011) > (665 + 3078)) and v17:Exists() and v13:CanAttack(v17)) then
							if (v23(v81.ShadowCrashCursor, not v14:IsInRange(1283 - (157 + 1086))) or ((2672 - 1337) >= (14479 - 11173))) then
								return "shadow_crash filler 20";
							end
						end
					elseif (((7430 - 2586) > (3074 - 821)) and (v76 == "At Cursor")) then
						if (((1271 - (599 + 220)) == (899 - 447)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(1971 - (1813 + 118)))) then
							return "shadow_crash filler 20";
						end
					end
				end
				if (v79.ShadowWordDeath:IsReady() or ((3332 + 1225) < (3304 - (841 + 376)))) then
					if (((5428 - 1554) == (900 + 2974)) and v88.CastCycle(v79.ShadowWordDeath, v84, v122, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
						return "shadow_word_death filler 22";
					end
				end
				v180 = 10 - 6;
			end
			if ((v180 == (859 - (464 + 395))) or ((4973 - 3035) > (2370 + 2565))) then
				if ((v79.VampiricTouch:IsCastable() and (v13:BuffUp(v79.UnfurlingDarknessBuff))) or ((5092 - (467 + 370)) < (7073 - 3650))) then
					if (((1068 + 386) <= (8539 - 6048)) and v88.CastTargetIf(v79.VampiricTouch, v84, "min", v113, nil, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, nil, true)) then
						return "vampiric_touch filler 2";
					end
				end
				if (v79.ShadowWordDeath:IsReady() or ((649 + 3508) <= (6521 - 3718))) then
					if (((5373 - (150 + 370)) >= (4264 - (74 + 1208))) and v88.CastCycle(v79.ShadowWordDeath, v84, v121, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
						return "shadow_word_death filler 4";
					end
				end
				if (((10167 - 6033) > (15920 - 12563)) and v79.MindSpikeInsanity:IsReady()) then
					if (v23(v79.MindSpikeInsanity, not v14:IsSpellInRange(v79.MindSpikeInsanity), true) or ((2432 + 985) < (2924 - (14 + 376)))) then
						return "mind_spike_insanity filler 6";
					end
				end
				v180 = 1 - 0;
			end
			if ((v180 == (3 + 1)) or ((2392 + 330) <= (157 + 7))) then
				if ((v79.ShadowWordDeath:IsReady() and v13:IsMoving()) or ((7055 - 4647) < (1587 + 522))) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((111 - (23 + 55)) == (3448 - 1993))) then
						return "shadow_word_death movement filler 26";
					end
				end
				if ((v79.ShadowWordPain:IsReady() and v13:IsMoving()) or ((296 + 147) >= (3606 + 409))) then
					if (((5243 - 1861) > (53 + 113)) and v88.CastTargetIf(v79.ShadowWordPain, v84, "min", v111, nil, not v14:IsSpellInRange(v79.ShadowWordPain))) then
						return "shadow_word_pain filler 28";
					end
				end
				break;
			end
			if ((v180 == (902 - (652 + 249))) or ((749 - 469) == (4927 - (708 + 1160)))) then
				if (((5105 - 3224) > (2357 - 1064)) and v79.MindFlay:IsCastable() and (v13:BuffUp(v79.MindFlayInsanityBuff))) then
					if (((2384 - (10 + 17)) == (530 + 1827)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
						return "mind_flay filler 8";
					end
				end
				if (((1855 - (1400 + 332)) == (235 - 112)) and v79.Mindgames:IsReady()) then
					if (v23(v79.Mindgames, not v14:IsInRange(1948 - (242 + 1666)), true) or ((452 + 604) >= (1244 + 2148))) then
						return "mindgames filler 10";
					end
				end
				if ((v79.ShadowWordDeath:IsReady() and v79.InescapableTorment:IsAvailable() and v101) or ((922 + 159) < (2015 - (850 + 90)))) then
					if (v88.CastTargetIf(v79.ShadowWordDeath, v84, "min", v112, nil, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover) or ((1836 - 787) >= (5822 - (360 + 1030)))) then
						return "shadow_word_death filler 12";
					end
				end
				v180 = 2 + 0;
			end
		end
	end
	local function v134()
		local v181 = 0 - 0;
		while true do
			if ((v181 == (0 - 0)) or ((6429 - (909 + 752)) <= (2069 - (109 + 1114)))) then
				if ((v79.Fireblood:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (14 - 6)))) or ((1308 + 2050) <= (1662 - (6 + 236)))) then
					if (v23(v79.Fireblood) or ((2356 + 1383) <= (2419 + 586))) then
						return "fireblood cds 4";
					end
				end
				if ((v79.Berserking:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (27 - 15)))) or ((2897 - 1238) >= (3267 - (1076 + 57)))) then
					if (v23(v79.Berserking) or ((537 + 2723) < (3044 - (579 + 110)))) then
						return "berserking cds 6";
					end
				end
				v181 = 1 + 0;
			end
			if ((v181 == (2 + 0)) or ((356 + 313) == (4630 - (174 + 233)))) then
				if ((v79.DivineStar:IsReady() and (v87 > (2 - 1)) and v80.BelorrelostheSuncaller:IsEquipped() and (v80.BelorrelostheSuncaller:CooldownRemains() <= v106)) or ((2969 - 1277) < (262 + 326))) then
					if (v23(v81.DivineStarPlayer, not v16:IsInRange(1204 - (663 + 511))) or ((4280 + 517) < (793 + 2858))) then
						return "divine_star cds 16";
					end
				end
				if ((v79.VoidEruption:IsCastable() and v100:CooldownDown() and ((v101 and (v100:CooldownRemains() >= (12 - 8))) or not v79.Mindbender:IsAvailable() or ((v87 > (2 + 0)) and not v79.InescapableTorment:IsAvailable())) and ((v79.MindBlast:Charges() == (0 - 0)) or (v10.CombatTime() > (36 - 21)))) or ((1994 + 2183) > (9439 - 4589))) then
					if (v23(v79.VoidEruption) or ((286 + 114) > (102 + 1009))) then
						return "void_eruption cds 20";
					end
				end
				v181 = 725 - (478 + 244);
			end
			if (((3568 - (440 + 77)) > (457 + 548)) and (v181 == (3 - 2))) then
				if (((5249 - (655 + 901)) <= (813 + 3569)) and v79.BloodFury:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (12 + 3)))) then
					if (v23(v79.BloodFury) or ((2217 + 1065) > (16517 - 12417))) then
						return "blood_fury cds 8";
					end
				end
				if ((v79.AncestralCall:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (1460 - (695 + 750))))) or ((12224 - 8644) < (4388 - 1544))) then
					if (((357 - 268) < (4841 - (285 + 66))) and v23(v79.AncestralCall)) then
						return "ancestral_call cds 10";
					end
				end
				v181 = 4 - 2;
			end
			if ((v181 == (1313 - (682 + 628))) or ((804 + 4179) < (2107 - (176 + 123)))) then
				if (((1602 + 2227) > (2734 + 1035)) and v79.DarkAscension:IsCastable() and not v13:IsCasting(v79.DarkAscension) and ((v101 and (v100:CooldownRemains() >= (273 - (239 + 30)))) or (not v79.Mindbender:IsAvailable() and v100:CooldownDown()) or ((v87 > (1 + 1)) and not v79.InescapableTorment:IsAvailable()))) then
					if (((1428 + 57) <= (5139 - 2235)) and v23(v79.DarkAscension)) then
						return "dark_ascension cds 22";
					end
				end
				if (((13318 - 9049) == (4584 - (306 + 9))) and v30) then
					local v217 = 0 - 0;
					while true do
						if (((68 + 319) <= (1707 + 1075)) and (v217 == (0 + 0))) then
							v89 = v131();
							if (v89 or ((5430 - 3531) <= (2292 - (1140 + 235)))) then
								return v89;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v135()
		v129();
		if ((v30 and ((v91 < (20 + 10)) or ((v14:TimeToDie() > (14 + 1)) and (not v97 or (v87 > (1 + 1)))))) or ((4364 - (33 + 19)) <= (317 + 559))) then
			local v208 = 0 - 0;
			while true do
				if (((984 + 1248) <= (5090 - 2494)) and (v208 == (0 + 0))) then
					v89 = v134();
					if (((2784 - (586 + 103)) < (336 + 3350)) and v89) then
						return v89;
					end
					break;
				end
			end
		end
		if ((v100:IsCastable() and v92 and ((v91 < (92 - 62)) or (v14:TimeToDie() > (1503 - (1309 + 179)))) and (not v79.DarkAscension:IsAvailable() or (v79.DarkAscension:CooldownRemains() < v106) or (v91 < (27 - 12)))) or ((695 + 900) >= (12015 - 7541))) then
			if (v23(v100) or ((3489 + 1130) < (6123 - 3241))) then
				return "mindbender main 2";
			end
		end
		if (v79.DevouringPlague:IsReady() or ((585 - 291) >= (5440 - (295 + 314)))) then
			if (((4983 - 2954) <= (5046 - (1300 + 662))) and v88.CastCycle(v79.DevouringPlague, v84, v115, not v14:IsSpellInRange(v79.DevouringPlague))) then
				return "devouring_plague main 4";
			end
		end
		if ((v79.ShadowWordDeath:IsReady() and (v13:HasTier(97 - 66, 1759 - (1178 + 577)) or (v101 and v79.InescapableTorment:IsAvailable() and v13:HasTier(17 + 14, 5 - 3))) and v14:DebuffUp(v79.DevouringPlagueDebuff)) or ((3442 - (851 + 554)) == (2140 + 280))) then
			if (((12363 - 7905) > (8478 - 4574)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
				return "shadow_word_death main 6";
			end
		end
		if (((738 - (115 + 187)) >= (95 + 28)) and v79.MindBlast:IsCastable() and v101 and v79.InescapableTorment:IsAvailable() and (v102 > v79.MindBlast:ExecuteTime()) and (v87 <= (7 + 0))) then
			if (((1970 - 1470) < (2977 - (160 + 1001))) and v88.CastCycle(v79.MindBlast, v84, v117, not v14:IsSpellInRange(v79.MindBlast), nil, nil, v81.MindBlastMouseover, true)) then
				return "mind_blast main 8";
			end
		end
		if (((3127 + 447) == (2466 + 1108)) and v79.ShadowWordDeath:IsReady()) then
			if (((452 - 231) < (748 - (237 + 121))) and v88.CastCycle(v79.ShadowWordDeath, v84, v123, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
				return "shadow_word_death main 10";
			end
		end
		if ((v79.VoidBolt:IsCastable() and v92) or ((3110 - (525 + 372)) <= (2693 - 1272))) then
			if (((10047 - 6989) < (5002 - (96 + 46))) and v23(v79.VoidBolt, not v14:IsInRange(817 - (643 + 134)))) then
				return "void_bolt main 12";
			end
		end
		if ((v79.DevouringPlague:IsReady() and (v91 <= (v79.DevouringPlagueDebuff:BaseDuration() + 2 + 2))) or ((3107 - 1811) >= (16506 - 12060))) then
			if (v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague)) or ((1336 + 57) > (8809 - 4320))) then
				return "devouring_plague main 14";
			end
		end
		if ((v79.DevouringPlague:IsReady() and ((v13:InsanityDeficit() <= (40 - 20)) or (v13:BuffUp(v79.VoidformBuff) and (v79.VoidBolt:CooldownRemains() > v13:BuffRemains(v79.VoidformBuff)) and (v79.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v79.VoidformBuff) + (721 - (316 + 403))))) or (v13:BuffUp(v79.MindDevourerBuff) and (v13:PMultiplier(v79.DevouringPlague) < (1.2 + 0))))) or ((12163 - 7739) < (10 + 17))) then
			if (v88.CastCycle(v79.DevouringPlague, v84, v115, not v14:IsSpellInRange(v79.DevouringPlague), nil, nil, v81.DevouringPlagueMouseover) or ((5028 - 3031) > (2704 + 1111))) then
				return "devouring_plague main 16";
			end
		end
		if (((1117 + 2348) > (6628 - 4715)) and v79.ShadowWordDeath:IsReady() and (v13:HasTier(148 - 117, 3 - 1))) then
			if (((42 + 691) < (3580 - 1761)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
				return "shadow_word_death main 18";
			end
		end
		if ((v79.ShadowCrash:IsCastable() and not v97 and (v14:DebuffRefreshable(v79.VampiricTouchDebuff) or ((v13:BuffStack(v79.DeathsTormentBuff) > (1 + 8)) and v13:HasTier(91 - 60, 21 - (12 + 5))))) or ((17070 - 12675) == (10145 - 5390))) then
			if ((v76 == "Confirm") or ((8062 - 4269) < (5874 - 3505))) then
				if (v23(v79.ShadowCrash, not v14:IsInRange(9 + 31)) or ((6057 - (1656 + 317)) == (237 + 28))) then
					return "shadow_crash main 20";
				end
			elseif (((3493 + 865) == (11587 - 7229)) and (v76 == "Enemy Under Cursor")) then
				if ((v17:Exists() and v13:CanAttack(v17)) or ((15443 - 12305) < (1347 - (5 + 349)))) then
					if (((15816 - 12486) > (3594 - (266 + 1005))) and v23(v81.ShadowCrashCursor, not v14:IsInRange(27 + 13))) then
						return "shadow_crash main 20";
					end
				end
			elseif ((v76 == "At Cursor") or ((12372 - 8746) == (5250 - 1261))) then
				if (v23(v81.ShadowCrashCursor, not v14:IsInRange(1736 - (561 + 1135))) or ((1192 - 276) == (8779 - 6108))) then
					return "shadow_crash main 20";
				end
			end
		end
		if (((1338 - (507 + 559)) == (682 - 410)) and v79.ShadowWordDeath:IsReady() and (v13:BuffStack(v79.DeathsTormentBuff) > (27 - 18)) and v13:HasTier(419 - (212 + 176), 909 - (250 + 655)) and (not v97 or not v79.ShadowCrash:IsAvailable())) then
			if (((11586 - 7337) <= (8454 - 3615)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
				return "shadow_word_death main 22";
			end
		end
		if (((4344 - 1567) < (5156 - (1869 + 87))) and v79.ShadowWordDeath:IsReady() and v92 and v79.InescapableTorment:IsAvailable() and v101 and ((not v79.InsidiousIre:IsAvailable() and not v79.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff)) and not v13:HasTier(107 - 76, 1903 - (484 + 1417))) then
			if (((203 - 108) < (3279 - 1322)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
				return "shadow_word_death main 24";
			end
		end
		if (((1599 - (48 + 725)) < (2804 - 1087)) and v79.VampiricTouch:IsCastable()) then
			if (((3825 - 2399) >= (643 + 462)) and v88.CastTargetIf(v79.VampiricTouch, v84, "min", v113, v114, not v14:IsSpellInRange(v79.VampiricTouch))) then
				return "vampiric_touch main 26";
			end
		end
		if (((7359 - 4605) <= (946 + 2433)) and v79.MindBlast:IsCastable() and (v13:BuffDown(v79.MindDevourerBuff) or (v79.VoidEruption:CooldownUp() and v79.VoidEruption:IsAvailable()))) then
			if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((1145 + 2782) == (2266 - (152 + 701)))) then
				return "mind_blast main 26";
			end
		end
		if ((v79.VoidTorrent:IsCastable() and not v97) or ((2465 - (430 + 881)) <= (302 + 486))) then
			if (v88.CastCycle(v79.VoidTorrent, v84, v124, not v14:IsSpellInRange(v79.VoidTorrent), nil, nil, v81.VoidTorrentMouseover, true) or ((2538 - (557 + 338)) > (999 + 2380))) then
				return "void_torrent main 28";
			end
		end
		v89 = v133();
		if (v89 or ((7898 - 5095) > (15929 - 11380))) then
			return v89;
		end
	end
	local function v136()
		local v182 = 0 - 0;
		while true do
			if ((v182 == (2 - 1)) or ((1021 - (499 + 302)) >= (3888 - (39 + 827)))) then
				if (((7789 - 4967) == (6302 - 3480)) and v79.DevouringPlague:IsReady() and (v14:DebuffRemains(v79.DevouringPlagueDebuff) <= (15 - 11)) and (v79.VoidTorrent:CooldownRemains() < (v13:GCD() * (2 - 0)))) then
					if (v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague)) or ((91 + 970) == (5435 - 3578))) then
						return "devouring_plague pl_torrent 6";
					end
				end
				if (((442 + 2318) > (2157 - 793)) and v79.MindBlast:IsCastable() and not v13:PrevGCD(105 - (103 + 1), v79.MindBlast)) then
					if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((5456 - (475 + 79)) <= (7771 - 4176))) then
						return "mind_blast pl_torrent 8";
					end
				end
				v182 = 6 - 4;
			end
			if ((v182 == (1 + 1)) or ((3391 + 461) == (1796 - (1395 + 108)))) then
				if ((v79.VoidTorrent:IsCastable() and (v109(v14, false) or v13:BuffUp(v79.VoidformBuff))) or ((4536 - 2977) == (5792 - (7 + 1197)))) then
					if (v23(v79.VoidTorrent, not v14:IsSpellInRange(v79.VoidTorrent), true) or ((1956 + 2528) == (275 + 513))) then
						return "void_torrent pl_torrent 10";
					end
				end
				break;
			end
			if (((4887 - (27 + 292)) >= (11448 - 7541)) and ((0 - 0) == v182)) then
				if (((5225 - 3979) < (6843 - 3373)) and v79.VoidBolt:IsCastable()) then
					if (((7747 - 3679) >= (1111 - (43 + 96))) and v23(v79.VoidBolt, not v14:IsInRange(163 - 123))) then
						return "void_bolt pl_torrent 2";
					end
				end
				if (((1114 - 621) < (3231 + 662)) and v79.VampiricTouch:IsCastable() and (v14:DebuffRemains(v79.VampiricTouchDebuff) <= (2 + 4)) and (v79.VoidTorrent:CooldownRemains() < (v13:GCD() * (3 - 1)))) then
					if (v23(v79.VampiricTouch, not v14:IsSpellInRange(v79.VampiricTouch), true) or ((565 + 908) >= (6243 - 2911))) then
						return "vampiric_touch pl_torrent 4";
					end
				end
				v182 = 1 + 0;
			end
		end
	end
	local function v137()
		local v183 = 0 + 0;
		while true do
			if ((v183 == (1751 - (1414 + 337))) or ((5991 - (1642 + 298)) <= (3016 - 1859))) then
				v130();
				if (((1737 - 1133) < (8549 - 5668)) and v79.VampiricTouch:IsCastable() and (((v94 > (0 + 0)) and not v98 and not v79.ShadowCrash:InFlight()) or not v79.WhisperingShadows:IsAvailable())) then
					if (v88.CastCycle(v79.VampiricTouch, v84, v125, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, v81.VampiricTouchMouseover, true) or ((701 + 199) == (4349 - (357 + 615)))) then
						return "vampiric_touch aoe 2";
					end
				end
				if (((3131 + 1328) > (1449 - 858)) and v79.ShadowCrash:IsCastable() and not v97) then
					if (((2912 + 486) >= (5132 - 2737)) and (v76 == "Confirm")) then
						if (v23(v79.ShadowCrash, not v14:IsInRange(32 + 8)) or ((149 + 2034) >= (1776 + 1048))) then
							return "shadow_crash aoe 4";
						end
					elseif (((3237 - (384 + 917)) == (2633 - (128 + 569))) and (v76 == "Enemy Under Cursor")) then
						if ((v17:Exists() and v13:CanAttack(v17)) or ((6375 - (1407 + 136)) < (6200 - (687 + 1200)))) then
							if (((5798 - (556 + 1154)) > (13628 - 9754)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(135 - (9 + 86)))) then
								return "shadow_crash aoe 4";
							end
						end
					elseif (((4753 - (275 + 146)) == (705 + 3627)) and (v76 == "At Cursor")) then
						if (((4063 - (29 + 35)) >= (12852 - 9952)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(119 - 79))) then
							return "shadow_crash aoe 4";
						end
					end
				end
				if ((v30 and ((v91 < (132 - 102)) or ((v14:TimeToDie() > (10 + 5)) and (not v97 or (v87 > (1014 - (53 + 959))))))) or ((2933 - (312 + 96)) > (7053 - 2989))) then
					v89 = v134();
					if (((4656 - (147 + 138)) == (5270 - (813 + 86))) and v89) then
						return v89;
					end
				end
				v183 = 1 + 0;
			end
			if (((1 - 0) == v183) or ((758 - (18 + 474)) > (1683 + 3303))) then
				if (((6498 - 4507) >= (2011 - (860 + 226))) and v100:IsCastable() and ((v14:DebuffUp(v79.ShadowWordPainDebuff) and v96) or (v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable())) and ((v91 < (333 - (121 + 182))) or (v14:TimeToDie() > (2 + 13))) and (not v79.DarkAscension:IsAvailable() or (v79.DarkAscension:CooldownRemains() < v106) or (v91 < (1255 - (988 + 252))))) then
					if (((52 + 403) < (644 + 1409)) and v23(v100)) then
						return "mindbender aoe 6";
					end
				end
				if ((v79.MindBlast:IsCastable() and ((v79.MindBlast:FullRechargeTime() <= (v106 + v79.MindBlast:CastTime())) or (v102 <= (v79.MindBlast:CastTime() + v106))) and v101 and v79.InescapableTorment:IsAvailable() and (v102 > v79.MindBlast:CastTime()) and (v87 <= (1977 - (49 + 1921))) and v13:BuffDown(v79.MindDevourerBuff)) or ((1716 - (223 + 667)) == (4903 - (51 + 1)))) then
					if (((314 - 131) == (391 - 208)) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
						return "mind_blast aoe 8";
					end
				end
				if (((2284 - (146 + 979)) <= (505 + 1283)) and v79.ShadowWordDeath:IsReady() and (v102 <= (607 - (311 + 294))) and v101 and v79.InescapableTorment:IsAvailable() and (v87 <= (19 - 12))) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((1486 + 2021) > (5761 - (496 + 947)))) then
						return "shadow_word_death aoe 10";
					end
				end
				if (v79.VoidBolt:IsCastable() or ((4433 - (1233 + 125)) <= (1204 + 1761))) then
					if (((1225 + 140) <= (383 + 1628)) and v23(v79.VoidBolt, not v14:IsInRange(1685 - (963 + 682)))) then
						return "void_bolt aoe 12";
					end
				end
				v183 = 2 + 0;
			end
			if ((v183 == (1508 - (504 + 1000))) or ((1870 + 906) > (3256 + 319))) then
				if ((v105:IsCastable() and v13:BuffUp(v79.MindFlayInsanityBuff) and v79.IdolOfCthun:IsAvailable()) or ((242 + 2312) == (7083 - 2279))) then
					if (((2202 + 375) == (1499 + 1078)) and v23(v105, not v14:IsSpellInRange(v105), true)) then
						return "mind_flay aoe 28";
					end
				end
				v89 = v133();
				if (v89 or ((188 - (156 + 26)) >= (1089 + 800))) then
					return v89;
				end
				break;
			end
			if (((790 - 284) <= (2056 - (149 + 15))) and (v183 == (963 - (890 + 70)))) then
				if ((v105:IsCastable() and v13:BuffUp(v79.MindFlayInsanityBuff) and v92 and (v79.MindBlast:FullRechargeTime() >= (v13:GCD() * (120 - (39 + 78)))) and v79.IdolOfCthun:IsAvailable() and (v79.VoidTorrent:CooldownDown() or not v79.VoidTorrent:IsAvailable())) or ((2490 - (14 + 468)) > (4877 - 2659))) then
					if (((1059 - 680) <= (2140 + 2007)) and v23(v105, not v14:IsSpellInRange(v105), true)) then
						return "mind_flay aoe 22";
					end
				end
				if ((v79.MindBlast:IsCastable() and v96 and (v13:BuffDown(v79.MindDevourerBuff) or (v79.VoidEruption:CooldownUp() and v79.VoidEruption:IsAvailable()))) or ((2711 + 1803) <= (215 + 794))) then
					if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((1579 + 1917) == (313 + 879))) then
						return "mind_blast aoe 24";
					end
				end
				if ((v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (5 - 2)) and (not v97 or ((v87 / (v79.VampiricTouchDebuff:AuraActiveCount() + v87)) < (1.5 + 0))) and ((v13:Insanity() >= (175 - 125)) or v14:DebuffUp(v79.DevouringPlagueDebuff) or v13:BuffUp(v79.DarkReveriesBuff) or v13:BuffUp(v79.VoidformBuff) or v13:BuffUp(v79.DarkAscensionBuff))) or ((6 + 202) == (3010 - (12 + 39)))) then
					v89 = v136();
					if (((3980 + 297) >= (4064 - 2751)) and v89) then
						return v89;
					end
				end
				if (((9213 - 6626) < (941 + 2233)) and v79.VoidTorrent:IsCastable() and not v79.PsychicLink:IsAvailable()) then
					if (v88.CastCycle(v79.VoidTorrent, v84, v127, not v14:IsSpellInRange(v79.VoidTorrent), nil, nil, v81.VoidTorrentMouseover, true) or ((2169 + 1951) <= (5573 - 3375))) then
						return "void_torrent aoe 26";
					end
				end
				v183 = 3 + 1;
			end
			if ((v183 == (9 - 7)) or ((3306 - (1596 + 114)) == (2239 - 1381))) then
				if (((3933 - (164 + 549)) == (4658 - (1059 + 379))) and v79.DevouringPlague:IsReady() and (not v99 or (v13:InsanityDeficit() <= (24 - 4)) or (v13:BuffUp(v79.VoidformBuff) and (v79.VoidBolt:CooldownRemains() > v13:BuffRemains(v79.VoidformBuff)) and (v79.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v79.VoidformBuff) + 2 + 0))))) then
					if (v88.CastCycle(v79.DevouringPlague, v84, v116, not v14:IsSpellInRange(v79.DevouringPlague), nil, nil, v81.DevouringPlagueMouseover) or ((237 + 1165) > (4012 - (145 + 247)))) then
						return "devouring_plague aoe 14";
					end
				end
				if (((2113 + 461) == (1190 + 1384)) and v79.VampiricTouch:IsCastable() and (((v94 > (0 - 0)) and not v79.ShadowCrash:InFlight()) or not v79.WhisperingShadows:IsAvailable())) then
					if (((345 + 1453) < (2375 + 382)) and v88.CastCycle(v79.VampiricTouch, v84, v126, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, v81.VampiricTouchMouseover, true)) then
						return "vampiric_touch aoe 16";
					end
				end
				if ((v79.ShadowWordDeath:IsReady() and v96 and v79.InescapableTorment:IsAvailable() and v101 and ((not v79.InsidiousIre:IsAvailable() and not v79.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff))) or ((612 - 235) > (3324 - (254 + 466)))) then
					if (((1128 - (544 + 16)) < (2895 - 1984)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
						return "shadow_word_death aoe 18";
					end
				end
				if (((3913 - (294 + 334)) < (4481 - (236 + 17))) and v79.MindSpikeInsanity:IsReady() and v92 and (v79.MindBlast:FullRechargeTime() >= (v13:GCD() * (2 + 1))) and v79.IdolOfCthun:IsAvailable() and (v79.VoidTorrent:CooldownDown() or not v79.VoidTorrent:IsAvailable())) then
					if (((3049 + 867) > (12533 - 9205)) and v23(v79.MindSpikeInsanity, not v14:IsInRange(189 - 149), true)) then
						return "mind_spike_insanity aoe 20";
					end
				end
				v183 = 2 + 1;
			end
		end
	end
	local function v138()
		local v184 = 0 + 0;
		while true do
			if (((3294 - (413 + 381)) < (162 + 3677)) and ((3 - 1) == v184)) then
				if (((1316 - 809) == (2477 - (582 + 1388))) and v32) then
					local v218 = 0 - 0;
					while true do
						if (((172 + 68) <= (3529 - (326 + 38))) and (v218 == (0 - 0))) then
							if (((1189 - 355) >= (1425 - (47 + 573))) and v79.FlashHeal:IsCastable() and (v13:HealthPercentage() <= v67) and v66) then
								if (v23(v81.FlashHealPlayer) or ((1344 + 2468) < (9836 - 7520))) then
									return "flash_heal defensive";
								end
							end
							if ((v79.Renew:IsCastable() and (v13:HealthPercentage() <= v69) and v68) or ((4304 - 1652) <= (3197 - (1269 + 395)))) then
								if (v23(v81.RenewPlayer) or ((4090 - (76 + 416)) < (1903 - (319 + 124)))) then
									return "renew defensive";
								end
							end
							v218 = 2 - 1;
						end
						if (((1008 - (564 + 443)) == v218) or ((11394 - 7278) < (1650 - (337 + 121)))) then
							if ((v79.PowerWordShield:IsCastable() and (v13:HealthPercentage() <= v71) and v70) or ((9894 - 6517) <= (3007 - 2104))) then
								if (((5887 - (1261 + 650)) >= (186 + 253)) and v23(v81.PowerWordShieldPlayer)) then
									return "power_word_shield defensive";
								end
							end
							break;
						end
					end
				end
				if (((5979 - 2227) == (5569 - (772 + 1045))) and v80.Healthstone:IsReady() and v52 and (v13:HealthPercentage() <= v53)) then
					if (((571 + 3475) > (2839 - (102 + 42))) and v23(v81.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				v184 = 1847 - (1524 + 320);
			end
			if ((v184 == (1273 - (1049 + 221))) or ((3701 - (18 + 138)) == (7825 - 4628))) then
				if (((3496 - (67 + 1035)) > (721 - (136 + 212))) and v34 and (v13:HealthPercentage() <= v36)) then
					if (((17656 - 13501) <= (3391 + 841)) and (v35 == "Refreshing Healing Potion")) then
						if (v80.RefreshingHealingPotion:IsReady() or ((3302 + 279) == (5077 - (240 + 1364)))) then
							if (((6077 - (1050 + 32)) > (11954 - 8606)) and v23(v81.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((0 + 0) == v184) or ((1809 - (331 + 724)) > (301 + 3423))) then
				if (((861 - (269 + 375)) >= (782 - (267 + 458))) and v79.Fade:IsReady() and v50 and (v13:HealthPercentage() <= v51)) then
					if (v23(v79.Fade, nil, nil, true) or ((644 + 1426) >= (7762 - 3725))) then
						return "fade defensive";
					end
				end
				if (((3523 - (667 + 151)) == (4202 - (1410 + 87))) and v79.Dispersion:IsCastable() and (v13:HealthPercentage() < v48) and v49) then
					if (((1958 - (1504 + 393)) == (164 - 103)) and v23(v79.Dispersion)) then
						return "dispersion defensive";
					end
				end
				v184 = 2 - 1;
			end
			if ((v184 == (797 - (461 + 335))) or ((90 + 609) >= (3057 - (1730 + 31)))) then
				if ((v79.DesperatePrayer:IsCastable() and (v13:HealthPercentage() <= v47) and v46) or ((3450 - (728 + 939)) >= (12806 - 9190))) then
					if (v23(v79.DesperatePrayer) or ((7936 - 4023) > (10372 - 5845))) then
						return "desperate_prayer defensive";
					end
				end
				if (((5444 - (138 + 930)) > (747 + 70)) and v79.VampiricEmbrace:IsReady() and v88.TargetIsValid() and v14:IsInRange(24 + 6) and v73 and v88.AreUnitsBelowHealthPercentage(v74, v75, v79.FlashHeal)) then
					if (((4167 + 694) > (3364 - 2540)) and v23(v79.VampiricEmbrace, nil, true)) then
						return "vampiric_embrace defensive";
					end
				end
				v184 = 1768 - (459 + 1307);
			end
		end
	end
	local function v139()
		if (((GetTime() - v28) > v40) or ((3253 - (474 + 1396)) >= (3720 - 1589))) then
			if ((v79.BodyandSoul:IsAvailable() and v79.PowerWordShield:IsReady() and v39 and v13:BuffDown(v79.AngelicFeatherBuff) and v13:BuffDown(v79.BodyandSoulBuff)) or ((1759 + 117) >= (9 + 2532))) then
				if (((5104 - 3322) <= (478 + 3294)) and v23(v81.PowerWordShieldPlayer)) then
					return "power_word_shield_player move";
				end
			end
			if ((v79.AngelicFeather:IsReady() and v38 and v13:BuffDown(v79.AngelicFeatherBuff) and v13:BuffDown(v79.BodyandSoulBuff) and v13:BuffDown(v79.AngelicFeatherBuff)) or ((15689 - 10989) < (3545 - 2732))) then
				if (((3790 - (562 + 29)) < (3453 + 597)) and v23(v81.AngelicFeatherPlayer)) then
					return "angelic_feather_player move";
				end
			end
		end
	end
	local function v140()
		if ((v79.PurifyDisease:IsReady() and v31 and v88.DispellableFriendlyUnit()) or ((6370 - (374 + 1045)) < (3507 + 923))) then
			if (((297 - 201) == (734 - (448 + 190))) and v23(v81.PurifyDiseaseFocus)) then
				return "purify_disease dispel";
			end
		end
	end
	local function v141()
		v33 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or "";
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v37 = EpicSettings.Settings['UsePowerWordFortitude'];
		v38 = EpicSettings.Settings['UseAngelicFeather'];
		v39 = EpicSettings.Settings['UseBodyAndSoul'];
		v40 = EpicSettings.Settings['MovementDelay'] or (0 + 0);
		v41 = EpicSettings.Settings['DispelDebuffs'];
		v42 = EpicSettings.Settings['DispelBuffs'];
		v43 = EpicSettings.Settings['InterruptWithStun'];
		v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v45 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v46 = EpicSettings.Settings['UseDesperatePrayer'];
		v47 = EpicSettings.Settings['DesperatePrayerHP'] or (0 - 0);
		v48 = EpicSettings.Settings['DispersionHP'] or (0 - 0);
		v49 = EpicSettings.Settings['UseDispersion'];
		v50 = EpicSettings.Settings['UseFade'];
		v51 = EpicSettings.Settings['FadeHP'] or (1494 - (1307 + 187));
		v52 = EpicSettings.Settings['UseHealthstone'];
		v53 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v54 = EpicSettings.Settings['PowerInfusionUsage'] or "";
		v55 = EpicSettings.Settings['PowerInfusionTarget'] or "";
		v56 = EpicSettings.Settings['PowerInfusionHP'] or (0 - 0);
		v57 = EpicSettings.Settings['PowerInfusionGroup'] or (0 - 0);
		v58 = EpicSettings.Settings['PIName1'] or "";
		v59 = EpicSettings.Settings['PIName2'] or "";
		v60 = EpicSettings.Settings['PIName3'] or "";
		v61 = EpicSettings.Settings['UseHalo'];
		v62 = EpicSettings.Settings['HaloHP'] or (683 - (232 + 451));
		v63 = EpicSettings.Settings['HaloGroup'] or (0 + 0);
		v64 = EpicSettings.Settings['UseDivineStar'];
		v65 = EpicSettings.Settings['DivineStarHP'] or (0 + 0);
		v66 = EpicSettings.Settings['UseFlashHeal'];
		v67 = EpicSettings.Settings['FlashHealHP'] or (564 - (510 + 54));
		v68 = EpicSettings.Settings['UseRenew'];
		v69 = EpicSettings.Settings['RenewHP'] or (0 - 0);
		v70 = EpicSettings.Settings['UsePowerWordShield'];
		v71 = EpicSettings.Settings['PowerWordShieldHP'] or (36 - (13 + 23));
		v72 = EpicSettings.Settings['UseShadowform'];
		v73 = EpicSettings.Settings['UseVampiricEmbrace'];
		v74 = EpicSettings.Settings['VampiricEmbraceHP'] or (0 - 0);
		v75 = EpicSettings.Settings['VampiricEmbraceGroup'] or (0 - 0);
		v76 = EpicSettings.Settings['ShadowCrashUsage'] or "";
		v77 = EpicSettings.Settings['VampiricTouchUsage'] or "";
		v78 = EpicSettings.Settings['VampiricTouchMax'] or (0 - 0);
	end
	local function v142()
		local v205 = 1088 - (830 + 258);
		while true do
			if ((v205 == (3 - 2)) or ((1714 + 1025) > (3411 + 597))) then
				v32 = EpicSettings.Toggles['heal'];
				v83 = v13:GetEnemiesInRange(1471 - (860 + 581));
				v84 = v13:GetEnemiesInRange(147 - 107);
				v85 = v14:GetEnemiesInSplashRange(8 + 2);
				v205 = 243 - (237 + 4);
			end
			if ((v205 == (4 - 2)) or ((57 - 34) == (2149 - 1015))) then
				if (AOE or ((2205 + 488) >= (2362 + 1749))) then
					local v219 = 0 - 0;
					while true do
						if ((v219 == (0 + 0)) or ((2348 + 1968) <= (3572 - (85 + 1341)))) then
							v86 = #v83;
							v87 = v14:GetEnemiesInSplashRangeCount(17 - 7);
							break;
						end
					end
				else
					local v220 = 0 - 0;
					while true do
						if (((372 - (45 + 327)) == v220) or ((6691 - 3145) <= (3311 - (444 + 58)))) then
							v86 = 1 + 0;
							v87 = 1 + 0;
							break;
						end
					end
				end
				if (((2398 + 2506) > (6276 - 4110)) and v13:IsDeadOrGhost()) then
					return;
				end
				if (((1841 - (64 + 1668)) >= (2063 - (1227 + 746))) and not v13:IsMoving()) then
					v28 = GetTime();
				end
				if (((15300 - 10322) > (5391 - 2486)) and (v13:AffectingCombat() or v41)) then
					local v221 = 494 - (415 + 79);
					local v222;
					while true do
						if ((v221 == (0 + 0)) or ((3517 - (142 + 349)) <= (977 + 1303))) then
							v222 = v41 and v79.Purify:IsReady();
							v89 = v88.FocusUnit(v222, nil, nil, nil, 27 - 7, v79.FlashHeal);
							v221 = 1 + 0;
						end
						if ((v221 == (1 + 0)) or ((4501 - 2848) <= (2972 - (1710 + 154)))) then
							if (((3227 - (200 + 118)) > (1034 + 1575)) and v89) then
								return v89;
							end
							break;
						end
					end
				end
				v205 = 5 - 2;
			end
			if (((1122 - 365) > (173 + 21)) and (v205 == (3 + 0))) then
				if ((not v13:AffectingCombat() and v29) or ((17 + 14) >= (224 + 1174))) then
					local v223 = 0 - 0;
					while true do
						if (((4446 - (363 + 887)) <= (8506 - 3634)) and (v223 == (4 - 3))) then
							if (((514 + 2812) == (7782 - 4456)) and v79.PowerWordFortitude:IsCastable() and (v13:BuffDown(v79.PowerWordFortitudeBuff, true) or v88.GroupBuffMissing(v79.PowerWordFortitudeBuff))) then
								if (((980 + 453) <= (5542 - (674 + 990))) and v23(v81.PowerWordFortitudePlayer)) then
									return "power_word_fortitude";
								end
							end
							if ((v79.Shadowform:IsCastable() and (v13:BuffDown(v79.ShadowformBuff)) and v72) or ((454 + 1129) == (711 + 1024))) then
								if (v23(v79.Shadowform) or ((4725 - 1744) == (3405 - (507 + 548)))) then
									return "shadowform";
								end
							end
							v223 = 839 - (289 + 548);
						end
						if ((v223 == (1820 - (821 + 997))) or ((4721 - (195 + 60)) <= (133 + 360))) then
							if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((4048 - (251 + 1250)) <= (5820 - 3833))) then
								if (((2035 + 926) > (3772 - (809 + 223))) and v23(v79.Resurrection, nil, true)) then
									return "resurrection";
								end
							end
							break;
						end
						if (((5393 - 1697) >= (10847 - 7235)) and (v223 == (0 - 0))) then
							if ((v79.PowerWordFortitude:IsCastable() and v37 and (v13:BuffDown(v79.PowerWordFortitudeBuff, true) or v88.GroupBuffMissing(v79.PowerWordFortitudeBuff))) or ((2188 + 782) == (984 + 894))) then
								if (v23(v81.PowerWordFortitudePlayer) or ((4310 - (14 + 603)) < (2106 - (118 + 11)))) then
									return "power_word_fortitude";
								end
							end
							if (HandleAfflicted or ((151 + 779) > (1750 + 351))) then
								local v227 = 0 - 0;
								while true do
									if (((5102 - (551 + 398)) > (1951 + 1135)) and (v227 == (0 + 0))) then
										v89 = v88.HandleAfflicted(v79.PurifyDisease, v81.PurifyDiseaseMouseover, 33 + 7);
										if (v89 or ((17308 - 12654) <= (9331 - 5281))) then
											return v89;
										end
										break;
									end
								end
							end
							v223 = 1 + 0;
						end
					end
				end
				if ((v13:IsMoving() and (v13:AffectingCombat() or v29)) or ((10329 - 7727) < (414 + 1082))) then
					local v224 = 89 - (40 + 49);
					while true do
						if ((v224 == (0 - 0)) or ((1510 - (99 + 391)) > (1893 + 395))) then
							v89 = v139();
							if (((1441 - 1113) == (812 - 484)) and v89) then
								return v89;
							end
							break;
						end
					end
				end
				if (((1472 + 39) < (10019 - 6211)) and (v88.TargetIsValid() or v13:AffectingCombat())) then
					local v225 = 1604 - (1032 + 572);
					while true do
						if ((v225 == (419 - (203 + 214))) or ((4327 - (568 + 1249)) > (3849 + 1070))) then
							v102 = (36 - 21) - v100:TimeSinceLastCast();
							if (((18397 - 13634) == (6069 - (913 + 393))) and (v102 < (0 - 0))) then
								v102 = 0 - 0;
							end
							v225 = 413 - (269 + 141);
						end
						if (((9201 - 5064) > (3829 - (362 + 1619))) and (v225 == (1628 - (950 + 675)))) then
							v105 = ((v13:BuffUp(v79.MindFlayInsanityBuff)) and v79.MindFlayInsanity) or v79.MindFlay;
							v106 = v13:GCD() + 0.25 + 0;
							break;
						end
						if (((3615 - (216 + 963)) <= (4421 - (485 + 802))) and (v225 == (560 - (432 + 127)))) then
							if (((4796 - (1065 + 8)) == (2068 + 1655)) and (v91 == (12712 - (635 + 966)))) then
								v91 = v10.FightRemains(v85, false);
							end
							v101 = v100:TimeSinceLastCast() <= (11 + 4);
							v225 = 44 - (5 + 37);
						end
						if ((v225 == (0 - 0)) or ((1684 + 2362) >= (6831 - 2515))) then
							v90 = v10.BossFightRemains(nil, true);
							v91 = v90;
							v225 = 1 + 0;
						end
					end
				end
				if (v88.TargetIsValid() or ((4172 - 2164) < (7313 - 5384))) then
					local v226 = 0 - 0;
					while true do
						if (((5699 - 3315) > (1277 + 498)) and (v226 == (530 - (318 + 211)))) then
							if (v23(v79.Pool) or ((22353 - 17810) <= (5963 - (963 + 624)))) then
								return "Pool for Main()";
							end
							break;
						end
						if (((312 + 416) == (1574 - (518 + 328))) and (v226 == (0 - 0))) then
							if ((not v13:AffectingCombat() and v29) or ((1719 - 643) > (4988 - (301 + 16)))) then
								local v228 = 0 - 0;
								while true do
									if (((5198 - 3347) >= (986 - 608)) and (v228 == (0 + 0))) then
										v89 = v128();
										if (v89 or ((1107 + 841) >= (7420 - 3944))) then
											return v89;
										end
										break;
									end
								end
							end
							if (((2885 + 1909) >= (80 + 753)) and (v13:AffectingCombat() or v29)) then
								local v229 = 0 - 0;
								while true do
									if (((1321 + 2769) == (5109 - (829 + 190))) and (v229 == (7 - 5))) then
										if ((v79.DispelMagic:IsReady() and v31 and v42 and not v13:IsCasting() and not v13:IsChanneling() and v88.UnitHasMagicBuff(v14)) or ((4754 - 996) == (3452 - 954))) then
											if (v23(v79.DispelMagic, not v14:IsSpellInRange(v79.DispelMagic)) or ((6639 - 3966) < (374 + 1201))) then
												return "dispel_magic damage";
											end
										end
										if ((v87 > (1 + 1)) or (v86 > (8 - 5)) or ((3512 + 209) <= (2068 - (520 + 93)))) then
											local v232 = 276 - (259 + 17);
											while true do
												if (((54 + 880) < (817 + 1453)) and ((0 - 0) == v232)) then
													v89 = v137();
													if (v89 or ((2203 - (396 + 195)) == (3641 - 2386))) then
														return v89;
													end
													v232 = 1762 - (440 + 1321);
												end
												if ((v232 == (1830 - (1059 + 770))) or ((20124 - 15772) < (4751 - (424 + 121)))) then
													if (v23(v79.Pool) or ((522 + 2338) <= (1528 - (641 + 706)))) then
														return "Pool for AoE()";
													end
													break;
												end
											end
										end
										v89 = v135();
										if (((1277 + 1945) >= (1967 - (249 + 191))) and v89) then
											return v89;
										end
										break;
									end
									if (((6556 - 5051) <= (948 + 1173)) and (v229 == (3 - 2))) then
										v99 = ((v79.VoidEruption:CooldownRemains() <= (v13:GCD() * (430 - (183 + 244)))) and v79.VoidEruption:IsAvailable()) or (v79.DarkAscension:CooldownUp() and v79.DarkAscension:IsAvailable()) or (v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (1 + 3)) and v13:BuffDown(v79.VoidformBuff));
										if (((1474 - (434 + 296)) == (2373 - 1629)) and (v104 == nil)) then
											v104 = v14:GUID();
										end
										if (((v103 == false) and v29 and (v14:GUID() == v104) and not v109(v14, true)) or ((2491 - (169 + 343)) >= (2487 + 349))) then
											v89 = v132();
											if (((3224 - 1391) <= (7830 - 5162)) and v89) then
												return v89;
											end
											if (((3020 + 666) == (10453 - 6767)) and v23(v79.Pool)) then
												return "Pool for Opener()";
											end
										else
											v103 = true;
										end
										if (((4590 - (651 + 472)) > (361 + 116)) and v16) then
											if (v41 or ((1419 + 1869) >= (4321 - 780))) then
												local v234 = 483 - (397 + 86);
												while true do
													if ((v234 == (876 - (423 + 453))) or ((362 + 3195) == (599 + 3941))) then
														v89 = v140();
														if (v89 or ((228 + 33) > (1012 + 255))) then
															return v89;
														end
														break;
													end
												end
											end
										end
										v229 = 2 + 0;
									end
									if (((2462 - (50 + 1140)) < (3335 + 523)) and (v229 == (0 + 0))) then
										v89 = v138();
										if (((228 + 3436) == (5261 - 1597)) and v89) then
											return v89;
										end
										if (((1405 + 536) >= (1046 - (157 + 439))) and not v13:IsCasting() and not v13:IsChanneling()) then
											local v233 = 0 - 0;
											while true do
												if ((v233 == (6 - 4)) or ((13742 - 9096) < (1242 - (782 + 136)))) then
													v89 = v88.InterruptWithStun(v79.PsychicScream, 863 - (112 + 743));
													if (((5004 - (1026 + 145)) == (658 + 3175)) and v89) then
														return v89;
													end
													break;
												end
												if ((v233 == (719 - (493 + 225))) or ((4557 - 3317) > (2050 + 1320))) then
													v89 = v88.Interrupt(v79.Silence, 80 - 50, true, v17, v81.SilenceMouseover);
													if (v89 or ((48 + 2433) == (13380 - 8698))) then
														return v89;
													end
													v233 = 1 + 1;
												end
												if (((7897 - 3170) >= (1803 - (210 + 1385))) and (v233 == (1689 - (1201 + 488)))) then
													v89 = v88.Interrupt(v79.Silence, 19 + 11, true);
													if (((497 - 217) < (6906 - 3055)) and v89) then
														return v89;
													end
													v233 = 586 - (352 + 233);
												end
											end
										end
										v97 = false;
										v229 = 2 - 1;
									end
								end
							end
							v226 = 1 + 0;
						end
					end
				end
				break;
			end
			if ((v205 == (0 - 0)) or ((3581 - (489 + 85)) > (4695 - (277 + 1224)))) then
				v141();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['cds'];
				v31 = EpicSettings.Toggles['dispel'];
				v205 = 1494 - (663 + 830);
			end
		end
	end
	local function v143()
		v107();
		v79.VampiricTouchDebuff:RegisterAuraTracking();
		v20.Print("Shadow Priest by Epic BoomK");
		EpicSettings.SetupVersion("Shadow Priest X v 10.2.01 By BoomK");
	end
	v20.SetAPL(227 + 31, v142, v143);
end;
return v0["Epix_Priest_Shadow.lua"]();

