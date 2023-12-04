local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((304 + 843) == (883 - 548))) then
			return v6(...);
		end
		if (((5812 - 2377) > (3196 - (35 + 1064))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((8066 - 4296) >= (17 + 4024))) then
				return v1(v4, ...);
			end
			v5 = 1237 - (298 + 938);
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
	local v28 = 1259 - (233 + 1026);
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
	local v90 = 12777 - (636 + 1030);
	local v91 = 5681 + 5430;
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
		local v144 = 0 + 0;
		while true do
			if ((v144 == (224 - (55 + 166))) or ((735 + 3056) <= (163 + 1448))) then
				v101 = false;
				v102 = 0 - 0;
				v103 = false;
				v104 = nil;
				break;
			end
			if ((v144 == (297 - (36 + 261))) or ((8005 - 3427) <= (3376 - (34 + 1334)))) then
				v90 = 4272 + 6839;
				v91 = 8634 + 2477;
				v92 = false;
				v93 = false;
				v144 = 1284 - (1035 + 248);
			end
			if (((1146 - (20 + 1)) <= (1082 + 994)) and (v144 == (321 - (134 + 185)))) then
				v96 = false;
				v97 = false;
				v98 = false;
				v99 = false;
				v144 = 1136 - (549 + 584);
			end
			if ((v144 == (686 - (314 + 371))) or ((2550 - 1807) >= (5367 - (478 + 490)))) then
				VarMindSearCutoff = 2 + 0;
				VarPoolAmount = 1232 - (786 + 386);
				v94 = 0 - 0;
				v95 = false;
				v144 = 1381 - (1055 + 324);
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
		v79.ShadowCrash:RegisterInFlightEffect(206726 - (1093 + 247));
		v79.ShadowCrash:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v79.ShadowCrash:RegisterInFlightEffect(182513 + 22873);
	v79.ShadowCrash:RegisterInFlight();
	local function v108()
		local v147 = 1 + 0;
		if (((4585 - 3430) < (5677 - 4004)) and v13:BuffUp(v79.DarkAscensionBuff)) then
			v147 = v147 * (2.25 - 1);
		end
		if (v13:BuffUp(v79.DarkEvangelismBuff) or ((5839 - 3515) <= (206 + 372))) then
			v147 = v147 * ((3 - 2) + ((0.01 - 0) * v13:BuffStack(v79.DarkEvangelismBuff)));
		end
		if (((2841 + 926) == (9633 - 5866)) and (v13:BuffUp(v79.DevouredFearBuff) or v13:BuffUp(v79.DevouredPrideBuff))) then
			v147 = v147 * (689.05 - (364 + 324));
		end
		if (((11209 - 7120) == (9811 - 5722)) and v79.DistortedReality:IsAvailable()) then
			v147 = v147 * (1.2 + 0);
		end
		if (((18653 - 14195) >= (2680 - 1006)) and v13:BuffUp(v79.MindDevourerBuff)) then
			v147 = v147 * (2.2 - 1);
		end
		if (((2240 - (1249 + 19)) <= (1280 + 138)) and v79.Voidtouched:IsAvailable()) then
			v147 = v147 * (3.06 - 2);
		end
		return v147;
	end
	v79.DevouringPlague:RegisterPMultiplier(v79.DevouringPlagueDebuff, v108);
	local function v109(v148, v149)
		if (v149 or ((6024 - (686 + 400)) < (3737 + 1025))) then
			return v148:DebuffUp(v79.ShadowWordPainDebuff) and v148:DebuffUp(v79.VampiricTouchDebuff) and v148:DebuffUp(v79.DevouringPlagueDebuff);
		else
			return v148:DebuffUp(v79.ShadowWordPainDebuff) and v148:DebuffUp(v79.VampiricTouchDebuff);
		end
	end
	local function v110(v150, v151)
		if (not v150 or ((2733 - (73 + 156)) > (21 + 4243))) then
			return nil;
		end
		local v152 = 811 - (721 + 90);
		local v153 = nil;
		for v184, v185 in pairs(v150) do
			local v186 = v185:TimeToDie();
			if (((25 + 2128) == (6990 - 4837)) and v151) then
				if (((v186 * v25(v185:DebuffRefreshable(v79.VampiricTouchDebuff))) > v152) or ((977 - (224 + 246)) >= (4197 - 1606))) then
					v152 = v186;
					v153 = v185;
				end
			elseif (((8250 - 3769) == (813 + 3668)) and (v186 > v152)) then
				local v216 = 0 + 0;
				while true do
					if ((v216 == (0 + 0)) or ((4628 - 2300) < (2305 - 1612))) then
						v152 = v186;
						v153 = v185;
						break;
					end
				end
			end
		end
		return v153;
	end
	local function v111(v154)
		return (v154:DebuffRemains(v79.ShadowWordPainDebuff));
	end
	local function v112(v155)
		return (v155:TimeToDie());
	end
	local function v113(v156)
		return (v156:DebuffRemains(v79.VampiricTouchDebuff));
	end
	local function v114(v157)
		return v157:DebuffRefreshable(v79.VampiricTouchDebuff) and (v157:TimeToDie() >= (525 - (203 + 310))) and (((v79.ShadowCrash:CooldownRemains() >= v157:DebuffRemains(v79.VampiricTouchDebuff)) and not v79.ShadowCrash:InFlight()) or v97 or not v79.WhisperingShadows:IsAvailable());
	end
	local function v115(v158)
		return not v79.DistortedReality:IsAvailable() or (v87 == (1994 - (1238 + 755))) or (v158:DebuffRemains(v79.DevouringPlagueDebuff) <= v106) or (v13:InsanityDeficit() <= (2 + 14));
	end
	local function v116(v159)
		return (v159:DebuffRemains(v79.DevouringPlagueDebuff) <= v106) or not v79.DistortedReality:IsAvailable();
	end
	local function v117(v160)
		return ((v160:DebuffRemains(v79.DevouringPlagueDebuff) > v79.MindBlast:ExecuteTime()) and (v79.MindBlast:FullRechargeTime() <= (v106 + v79.MindBlast:ExecuteTime()))) or (v102 <= (v79.MindBlast:ExecuteTime() + v106));
	end
	local function v118(v161)
		return v109(v161, true) and (v161:DebuffRemains(v79.DevouringPlagueDebuff) >= v79.Mindgames:CastTime());
	end
	local function v119(v162)
		return v162:DebuffRefreshable(v79.VampiricTouchDebuff) or ((v162:DebuffRemains(v79.VampiricTouchDebuff) <= v162:TimeToDie()) and v13:BuffDown(v79.VoidformBuff));
	end
	local function v120(v163)
		return ((v163:HealthPercentage() < (1554 - (709 + 825))) and ((v100:CooldownRemains() >= (18 - 8)) or not v79.InescapableTorment:IsAvailable())) or (v101 and v79.InescapableTorment:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff);
	end
	local function v121(v164)
		return (v164:HealthPercentage() < (29 - 9)) or v13:BuffUp(v79.DeathspeakerBuff) or v13:HasTier(895 - (196 + 668), 7 - 5);
	end
	local function v122(v165)
		return v165:HealthPercentage() < (41 - 21);
	end
	local function v123(v166)
		return v166:DebuffUp(v79.DevouringPlagueDebuff) and (v102 <= (835 - (171 + 662))) and v101 and v79.InescapableTorment:IsAvailable() and (v87 <= (100 - (4 + 89)));
	end
	local function v111(v167)
		return (v167:DebuffRemains(v79.ShadowWordPainDebuff));
	end
	local function v124(v168)
		return v168:DebuffRemains(v79.DevouringPlagueDebuff) >= (6.5 - 4);
	end
	local function v125(v169)
		return v169:DebuffRefreshable(v79.VampiricTouchDebuff) and (v169:TimeToDie() >= (7 + 11)) and (v169:DebuffUp(v79.VampiricTouchDebuff) or not v96);
	end
	local function v126(v170)
		if (((19009 - 14681) == (1698 + 2630)) and ((v79.ShadowCrash:CooldownRemains() >= v170:DebuffRemains(v79.VampiricTouchDebuff)) or v97)) then
			return v170:DebuffRefreshable(v79.VampiricTouchDebuff) and (v170:TimeToDie() >= (1504 - (35 + 1451))) and (v170:DebuffUp(v79.VampiricTouchDebuff) or not v96);
		end
		return nil;
	end
	local function v127(v171)
		return (v109(v171, false));
	end
	local function v128()
		local v172 = 1453 - (28 + 1425);
		local v173;
		while true do
			if (((3581 - (941 + 1052)) >= (1278 + 54)) and (v172 == (1515 - (822 + 692)))) then
				v173 = v13:IsInParty() and not v13:IsInRaid();
				if ((v79.ShadowCrash:IsCastable() and not v173) or ((5958 - 1784) > (2001 + 2247))) then
					if ((v76 == "Confirm") or ((4883 - (45 + 252)) <= (82 + 0))) then
						if (((1330 + 2533) == (9401 - 5538)) and v23(v79.ShadowCrash, not v14:IsInRange(473 - (114 + 319)))) then
							return "shadow_crash precombat 8";
						end
					elseif ((v76 == "Enemy Under Cursor") or ((404 - 122) <= (53 - 11))) then
						if (((2939 + 1670) >= (1140 - 374)) and v17:Exists() and v13:CanAttack(v17)) then
							if (v23(v81.ShadowCrashCursor, not v14:IsInRange(83 - 43)) or ((3115 - (556 + 1407)) == (3694 - (741 + 465)))) then
								return "shadow_crash precombat 8";
							end
						end
					elseif (((3887 - (170 + 295)) > (1766 + 1584)) and (v76 == "At Cursor")) then
						if (((806 + 71) > (925 - 549)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(34 + 6))) then
							return "shadow_crash precombat 8";
						end
					end
				end
				v172 = 2 + 0;
			end
			if (((2 + 0) == v172) or ((4348 - (957 + 273)) <= (496 + 1355))) then
				if ((v79.VampiricTouch:IsCastable() and (not v79.ShadowCrash:IsAvailable() or (v79.ShadowCrash:CooldownDown() and not v79.ShadowCrash:InFlight()) or v173)) or ((67 + 98) >= (13306 - 9814))) then
					if (((10406 - 6457) < (14832 - 9976)) and v23(v79.VampiricTouch, not v14:IsSpellInRange(v79.VampiricTouch), true)) then
						return "vampiric_touch precombat 14";
					end
				end
				if ((v79.ShadowWordPain:IsCastable() and not v79.Misery:IsAvailable()) or ((21173 - 16897) < (4796 - (389 + 1391)))) then
					if (((2943 + 1747) > (430 + 3695)) and v23(v79.ShadowWordPain, not v14:IsSpellInRange(v79.ShadowWordPain))) then
						return "shadow_word_pain precombat 16";
					end
				end
				break;
			end
			if ((v172 == (0 - 0)) or ((1001 - (783 + 168)) >= (3006 - 2110))) then
				v104 = v14:GUID();
				if ((v79.ArcaneTorrent:IsCastable() and v30) or ((1686 + 28) >= (3269 - (309 + 2)))) then
					if (v23(v79.ArcaneTorrent, not v14:IsSpellInRange(v79.ArcaneTorrent)) or ((4578 - 3087) < (1856 - (1090 + 122)))) then
						return "arcane_torrent precombat 6";
					end
				end
				v172 = 1 + 0;
			end
		end
	end
	local function v129()
		local v174 = 0 - 0;
		while true do
			if (((482 + 222) < (2105 - (628 + 490))) and (v174 == (0 + 0))) then
				v92 = v109(v14, false) or (v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable());
				v93 = v109(v14, true);
				v174 = 2 - 1;
			end
			if (((16991 - 13273) > (2680 - (431 + 343))) and (v174 == (1 - 0))) then
				v99 = ((v79.VoidEruption:CooldownRemains() <= (v13:GCD() * (8 - 5))) and v79.VoidEruption:IsAvailable()) or (v79.DarkAscension:CooldownUp() and v79.DarkAscension:IsAvailable()) or (v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (4 + 0)) and v13:BuffDown(v79.VoidformBuff));
				break;
			end
		end
	end
	local function v130()
		local v175 = 0 + 0;
		local v176;
		while true do
			if ((v175 == (1695 - (556 + 1139))) or ((973 - (6 + 9)) > (666 + 2969))) then
				v94 = v27(v87, v78);
				v95 = false;
				v175 = 1 + 0;
			end
			if (((3670 - (28 + 141)) <= (1740 + 2752)) and (v175 == (2 - 0))) then
				v96 = ((v79.VampiricTouchDebuff:AuraActiveCount() + ((6 + 2) * v25(v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable()))) >= v94) or not v95;
				if ((v97 and v79.WhisperingShadows:IsAvailable()) or ((4759 - (486 + 831)) < (6630 - 4082))) then
					v97 = (v94 - v79.VampiricTouchDebuff:AuraActiveCount()) < (13 - 9);
				end
				v175 = 1 + 2;
			end
			if (((9090 - 6215) >= (2727 - (668 + 595))) and (v175 == (1 + 0))) then
				v176 = v110(v85, true);
				if ((v176 and (v176:TimeToDie() >= (4 + 14))) or ((13081 - 8284) >= (5183 - (23 + 267)))) then
					v95 = true;
				end
				v175 = 1946 - (1129 + 815);
			end
			if ((v175 == (390 - (371 + 16))) or ((2301 - (1326 + 424)) > (3916 - 1848))) then
				v98 = ((v79.VampiricTouchDebuff:AuraActiveCount() + ((29 - 21) * v25(not v97))) >= v94) or not v95;
				break;
			end
		end
	end
	local function v131()
		if (((2232 - (88 + 30)) > (1715 - (720 + 51))) and (v13:BuffUp(v79.VoidformBuff) or v13:BuffUp(v79.PowerInfusionBuff) or v13:BuffUp(v79.DarkAscensionBuff) or (v91 < (44 - 24)))) then
			local v188 = 1776 - (421 + 1355);
			while true do
				if (((1 - 0) == v188) or ((1112 + 1150) >= (4179 - (286 + 797)))) then
					v89 = v88.HandleBottomTrinket(v82, CDs, 146 - 106, nil);
					if (v89 or ((3734 - 1479) >= (3976 - (397 + 42)))) then
						return v89;
					end
					break;
				end
				if (((0 + 0) == v188) or ((4637 - (24 + 776)) < (2011 - 705))) then
					v89 = v88.HandleTopTrinket(v82, CDs, 825 - (222 + 563), nil);
					if (((6499 - 3549) == (2124 + 826)) and v89) then
						return v89;
					end
					v188 = 191 - (23 + 167);
				end
			end
		end
	end
	local function v132()
		if ((v79.ShadowCrash:IsCastable() and (v14:DebuffDown(v79.VampiricTouchDebuff))) or ((6521 - (690 + 1108)) < (1190 + 2108))) then
			if (((938 + 198) >= (1002 - (40 + 808))) and (v76 == "Confirm")) then
				if (v23(v79.ShadowCrash, not v14:IsInRange(7 + 33)) or ((1036 - 765) > (4539 + 209))) then
					return "shadow_crash opener 2";
				end
			elseif (((2508 + 2232) >= (1729 + 1423)) and (v76 == "Enemy Under Cursor")) then
				if ((v17:Exists() and v13:CanAttack(v17)) or ((3149 - (47 + 524)) >= (2200 + 1190))) then
					if (((112 - 71) <= (2483 - 822)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(91 - 51))) then
						return "shadow_crash opener 2";
					end
				end
			elseif (((2327 - (1165 + 561)) < (106 + 3454)) and (v76 == "At Cursor")) then
				if (((727 - 492) < (263 + 424)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(519 - (341 + 138)))) then
					return "shadow_crash opener 2";
				end
			end
		end
		if (((1228 + 3321) > (2379 - 1226)) and v79.VampiricTouch:IsCastable() and v14:DebuffDown(v79.VampiricTouchDebuff) and (v79.ShadowCrash:CooldownDown() or not v79.ShadowCrash:IsAvailable())) then
			if (v22(v79.VampiricTouch, nil, nil, not v14:IsSpellInRange(v79.VampiricTouch)) or ((5000 - (89 + 237)) < (15029 - 10357))) then
				return "vampiric_touch opener 3";
			end
		end
		if (((7722 - 4054) < (5442 - (581 + 300))) and v100:IsCastable() and v30) then
			if (v23(v100) or ((1675 - (855 + 365)) == (8562 - 4957))) then
				return "mindbender opener 4";
			end
		end
		if (v79.DarkAscension:IsCastable() or ((870 + 1793) == (4547 - (1030 + 205)))) then
			if (((4016 + 261) <= (4163 + 312)) and v23(v79.DarkAscension)) then
				return "dark_ascension opener 6";
			end
		end
		if (v79.VoidEruption:IsAvailable() or ((1156 - (156 + 130)) == (2701 - 1512))) then
			local v189 = 0 - 0;
			while true do
				if (((3180 - 1627) <= (826 + 2307)) and (v189 == (1 + 0))) then
					if (v79.VoidEruption:IsCastable() or ((2306 - (10 + 59)) >= (993 + 2518))) then
						if (v23(v79.VoidEruption, not v14:IsInRange(196 - 156), true) or ((2487 - (671 + 492)) > (2405 + 615))) then
							return "void_eruption opener 12";
						end
					end
					break;
				end
				if ((v189 == (1215 - (369 + 846))) or ((793 + 2199) == (1606 + 275))) then
					if (((5051 - (1036 + 909)) > (1214 + 312)) and v79.ShadowWordDeath:IsCastable() and v79.InescapableTorment:IsAvailable() and v13:PrevGCDP(1 - 0, v79.MindBlast) and (v79.ShadowWordDeath:TimeSinceLastCast() > (223 - (11 + 192)))) then
						if (((1528 + 1495) < (4045 - (135 + 40))) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
							return "shadow_word_death opener 8";
						end
					end
					if (((346 - 203) > (45 + 29)) and v79.MindBlast:IsCastable()) then
						if (((39 - 21) < (3165 - 1053)) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
							return "mind_blast opener 10";
						end
					end
					v189 = 177 - (50 + 126);
				end
			end
		end
		v89 = v131();
		if (((3054 - 1957) <= (361 + 1267)) and v89) then
			return v89;
		end
		if (((6043 - (1233 + 180)) == (5599 - (522 + 447))) and v79.VoidBolt:IsCastable()) then
			if (((4961 - (107 + 1314)) > (1246 + 1437)) and v23(v79.VoidBolt, not v14:IsInRange(121 - 81))) then
				return "void_bolt opener 16";
			end
		end
		if (((2037 + 2757) >= (6503 - 3228)) and v79.DevouringPlague:IsReady()) then
			if (((5871 - 4387) == (3394 - (716 + 1194))) and v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague))) then
				return "devouring_plague opener 18";
			end
		end
		if (((25 + 1407) < (381 + 3174)) and v79.MindBlast:IsCastable()) then
			if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((1568 - (74 + 429)) > (6901 - 3323))) then
				return "mind_blast opener 20";
			end
		end
		if (v79.MindSpike:IsCastable() or ((2377 + 2418) < (3220 - 1813))) then
			if (((1311 + 542) < (14837 - 10024)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
				return "mind_spike opener 22";
			end
		end
		if (v79.MindFlay:IsCastable() or ((6974 - 4153) < (2864 - (279 + 154)))) then
			if (v23(v79.MindFlay, not v14:IsSpellInRange(v79.MindFlay), true) or ((3652 - (454 + 324)) < (1716 + 465))) then
				return "mind_flay opener 24";
			end
		end
	end
	local function v133()
		if ((v79.VampiricTouch:IsCastable() and (v13:BuffUp(v79.UnfurlingDarknessBuff))) or ((2706 - (12 + 5)) <= (185 + 158))) then
			if (v88.CastTargetIf(v79.VampiricTouch, v84, "min", v113, nil, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, nil, true) or ((4761 - 2892) == (743 + 1266))) then
				return "vampiric_touch filler 2";
			end
		end
		if (v79.ShadowWordDeath:IsReady() or ((4639 - (277 + 816)) < (9921 - 7599))) then
			if (v88.CastCycle(v79.ShadowWordDeath, v84, v121, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover) or ((3265 - (1058 + 125)) == (895 + 3878))) then
				return "shadow_word_death filler 4";
			end
		end
		if (((4219 - (815 + 160)) > (4526 - 3471)) and v79.MindSpikeInsanity:IsReady()) then
			if (v23(v79.MindSpikeInsanity, not v14:IsSpellInRange(v79.MindSpikeInsanity), true) or ((7864 - 4551) <= (425 + 1353))) then
				return "mind_spike_insanity filler 6";
			end
		end
		if ((v79.MindFlay:IsCastable() and (v13:BuffUp(v79.MindFlayInsanityBuff))) or ((4153 - 2732) >= (4002 - (41 + 1857)))) then
			if (((3705 - (1222 + 671)) <= (8397 - 5148)) and v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true)) then
				return "mind_flay filler 8";
			end
		end
		if (((2332 - 709) <= (3139 - (229 + 953))) and v79.Mindgames:IsReady()) then
			if (((6186 - (1111 + 663)) == (5991 - (874 + 705))) and v23(v79.Mindgames, not v14:IsInRange(6 + 34), true)) then
				return "mindgames filler 10";
			end
		end
		if (((1194 + 556) >= (1749 - 907)) and v79.ShadowWordDeath:IsReady() and v79.InescapableTorment:IsAvailable() and v101) then
			if (((124 + 4248) > (2529 - (642 + 37))) and v88.CastTargetIf(v79.ShadowWordDeath, v84, "min", v112, nil, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover)) then
				return "shadow_word_death filler 12";
			end
		end
		if (((53 + 179) < (132 + 689)) and v79.DivineStar:IsReady() and (v16:HealthPercentage() < v65) and v64) then
			if (((1300 - 782) < (1356 - (233 + 221))) and v23(v81.DivineStarPlayer, not v16:IsInRange(69 - 39))) then
				return "divine_star heal";
			end
		end
		if (((2636 + 358) > (2399 - (718 + 823))) and v79.Halo:IsReady() and v88.TargetIsValid() and v14:IsInRange(19 + 11) and v61 and v88.AreUnitsBelowHealthPercentage(v62, v63)) then
			if (v23(v79.Halo, nil, true) or ((4560 - (266 + 539)) <= (2590 - 1675))) then
				return "halo heal";
			end
		end
		if (((5171 - (636 + 589)) > (8884 - 5141)) and v79.MindSpike:IsCastable()) then
			if (v23(v79.MindSpike, not v14:IsSpellInRange(v79.MindSpike), true) or ((2753 - 1418) >= (2620 + 686))) then
				return "mind_spike filler 16";
			end
		end
		if (((1760 + 3084) > (3268 - (657 + 358))) and v105:IsCastable()) then
			if (((1196 - 744) == (1029 - 577)) and v23(v105, not v14:IsSpellInRange(v105), true)) then
				return "mind_flay filler 18";
			end
		end
		if (v79.ShadowCrash:IsCastable() or ((5744 - (1151 + 36)) < (2016 + 71))) then
			if (((1019 + 2855) == (11569 - 7695)) and (v76 == "Confirm")) then
				if (v23(v79.ShadowCrash, not v14:IsInRange(1872 - (1552 + 280))) or ((2772 - (64 + 770)) > (3351 + 1584))) then
					return "shadow_crash filler 20";
				end
			elseif ((v76 == "Enemy Under Cursor") or ((9659 - 5404) < (608 + 2815))) then
				if (((2697 - (157 + 1086)) <= (4985 - 2494)) and v17:Exists() and v13:CanAttack(v17)) then
					if (v23(v81.ShadowCrashCursor, not v14:IsInRange(175 - 135)) or ((6376 - 2219) <= (3824 - 1021))) then
						return "shadow_crash filler 20";
					end
				end
			elseif (((5672 - (599 + 220)) >= (5937 - 2955)) and (v76 == "At Cursor")) then
				if (((6065 - (1813 + 118)) > (2454 + 903)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(1257 - (841 + 376)))) then
					return "shadow_crash filler 20";
				end
			end
		end
		if (v79.ShadowWordDeath:IsReady() or ((4787 - 1370) < (589 + 1945))) then
			if (v88.CastCycle(v79.ShadowWordDeath, v84, v122, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover) or ((7429 - 4707) <= (1023 - (464 + 395)))) then
				return "shadow_word_death filler 22";
			end
		end
		if ((v79.ShadowWordDeath:IsReady() and v13:IsMoving()) or ((6179 - 3771) < (1013 + 1096))) then
			if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((870 - (467 + 370)) == (3006 - 1551))) then
				return "shadow_word_death movement filler 26";
			end
		end
		if ((v79.ShadowWordPain:IsReady() and v13:IsMoving()) or ((326 + 117) >= (13763 - 9748))) then
			if (((528 + 2854) > (386 - 220)) and v88.CastTargetIf(v79.ShadowWordPain, v84, "min", v111, nil, not v14:IsSpellInRange(v79.ShadowWordPain))) then
				return "shadow_word_pain filler 28";
			end
		end
	end
	local function v134()
		local v177 = 520 - (150 + 370);
		while true do
			if ((v177 == (1285 - (74 + 1208))) or ((688 - 408) == (14507 - 11448))) then
				if (((1339 + 542) > (1683 - (14 + 376))) and v79.DarkAscension:IsCastable() and not v13:IsCasting(v79.DarkAscension) and ((v101 and (v100:CooldownRemains() >= (6 - 2))) or (not v79.Mindbender:IsAvailable() and v100:CooldownDown()) or ((v87 > (2 + 0)) and not v79.InescapableTorment:IsAvailable()))) then
					if (((2071 + 286) == (2248 + 109)) and v23(v79.DarkAscension)) then
						return "dark_ascension cds 22";
					end
				end
				if (((360 - 237) == (93 + 30)) and v30) then
					local v217 = 78 - (23 + 55);
					while true do
						if ((v217 == (0 - 0)) or ((705 + 351) >= (3047 + 345))) then
							v89 = v131();
							if (v89 or ((1675 - 594) < (339 + 736))) then
								return v89;
							end
							break;
						end
					end
				end
				break;
			end
			if (((901 - (652 + 249)) == v177) or ((2807 - 1758) >= (6300 - (708 + 1160)))) then
				if ((v79.Fireblood:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (21 - 13)))) or ((8692 - 3924) <= (873 - (10 + 17)))) then
					if (v23(v79.Fireblood) or ((755 + 2603) <= (3152 - (1400 + 332)))) then
						return "fireblood cds 4";
					end
				end
				if ((v79.Berserking:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (22 - 10)))) or ((5647 - (242 + 1666)) <= (1286 + 1719))) then
					if (v23(v79.Berserking) or ((609 + 1050) >= (1819 + 315))) then
						return "berserking cds 6";
					end
				end
				v177 = 941 - (850 + 90);
			end
			if ((v177 == (3 - 1)) or ((4650 - (360 + 1030)) < (2085 + 270))) then
				if ((v79.DivineStar:IsReady() and (v87 > (2 - 1)) and v80.BelorrelostheSuncaller:IsEquipped() and (v80.BelorrelostheSuncaller:CooldownRemains() <= v106)) or ((919 - 250) == (5884 - (909 + 752)))) then
					if (v23(v81.DivineStarPlayer, not v16:IsInRange(1253 - (109 + 1114))) or ((3097 - 1405) < (229 + 359))) then
						return "divine_star cds 16";
					end
				end
				if ((v79.VoidEruption:IsCastable() and v100:CooldownDown() and ((v101 and (v100:CooldownRemains() >= (246 - (6 + 236)))) or not v79.Mindbender:IsAvailable() or ((v87 > (2 + 0)) and not v79.InescapableTorment:IsAvailable())) and ((v79.MindBlast:Charges() == (0 + 0)) or (v10.CombatTime() > (35 - 20)))) or ((8378 - 3581) < (4784 - (1076 + 57)))) then
					if (v23(v79.VoidEruption) or ((687 + 3490) > (5539 - (579 + 110)))) then
						return "void_eruption cds 20";
					end
				end
				v177 = 1 + 2;
			end
			if ((v177 == (1 + 0)) or ((213 + 187) > (1518 - (174 + 233)))) then
				if (((8522 - 5471) > (1763 - 758)) and v79.BloodFury:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (7 + 8)))) then
					if (((4867 - (663 + 511)) <= (3910 + 472)) and v23(v79.BloodFury)) then
						return "blood_fury cds 8";
					end
				end
				if ((v79.AncestralCall:IsCastable() and (v13:BuffUp(v79.PowerInfusionBuff) or (v91 <= (4 + 11)))) or ((10118 - 6836) > (2483 + 1617))) then
					if (v23(v79.AncestralCall) or ((8428 - 4848) < (6884 - 4040))) then
						return "ancestral_call cds 10";
					end
				end
				v177 = 1 + 1;
			end
		end
	end
	local function v135()
		v129();
		if (((172 - 83) < (3200 + 1290)) and v30 and ((v91 < (3 + 27)) or ((v14:TimeToDie() > (737 - (478 + 244))) and (not v97 or (v87 > (519 - (440 + 77))))))) then
			local v190 = 0 + 0;
			while true do
				if (((0 - 0) == v190) or ((6539 - (655 + 901)) < (336 + 1472))) then
					v89 = v134();
					if (((2932 + 897) > (2545 + 1224)) and v89) then
						return v89;
					end
					break;
				end
			end
		end
		if (((5982 - 4497) <= (4349 - (695 + 750))) and v100:IsCastable() and v92 and ((v91 < (102 - 72)) or (v14:TimeToDie() > (22 - 7))) and (not v79.DarkAscension:IsAvailable() or (v79.DarkAscension:CooldownRemains() < v106) or (v91 < (60 - 45)))) then
			if (((4620 - (285 + 66)) == (9951 - 5682)) and v23(v100)) then
				return "mindbender main 2";
			end
		end
		if (((1697 - (682 + 628)) <= (449 + 2333)) and v79.DevouringPlague:IsReady()) then
			if (v88.CastCycle(v79.DevouringPlague, v84, v115, not v14:IsSpellInRange(v79.DevouringPlague)) or ((2198 - (176 + 123)) <= (384 + 533))) then
				return "devouring_plague main 4";
			end
		end
		if ((v79.ShadowWordDeath:IsReady() and (v13:HasTier(23 + 8, 273 - (239 + 30)) or (v101 and v79.InescapableTorment:IsAvailable() and v13:HasTier(9 + 22, 2 + 0))) and v14:DebuffUp(v79.DevouringPlagueDebuff)) or ((7631 - 3319) <= (2732 - 1856))) then
			if (((2547 - (306 + 9)) <= (9058 - 6462)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
				return "shadow_word_death main 6";
			end
		end
		if (((365 + 1730) < (2262 + 1424)) and v79.MindBlast:IsCastable() and v101 and v79.InescapableTorment:IsAvailable() and (v102 > v79.MindBlast:ExecuteTime()) and (v87 <= (4 + 3))) then
			if (v88.CastCycle(v79.MindBlast, v84, v117, not v14:IsSpellInRange(v79.MindBlast), nil, nil, v81.MindBlastMouseover, true) or ((4561 - 2966) >= (5849 - (1140 + 235)))) then
				return "mind_blast main 8";
			end
		end
		if (v79.ShadowWordDeath:IsReady() or ((2940 + 1679) < (2643 + 239))) then
			if (v88.CastCycle(v79.ShadowWordDeath, v84, v123, not v14:IsSpellInRange(v79.ShadowWordDeath), nil, nil, v81.ShadowWordDeathMouseover) or ((76 + 218) >= (4883 - (33 + 19)))) then
				return "shadow_word_death main 10";
			end
		end
		if (((733 + 1296) <= (9243 - 6159)) and v79.VoidBolt:IsCastable() and v92) then
			if (v23(v79.VoidBolt, not v14:IsInRange(18 + 22)) or ((3994 - 1957) == (2270 + 150))) then
				return "void_bolt main 12";
			end
		end
		if (((5147 - (586 + 103)) > (356 + 3548)) and v79.DevouringPlague:IsReady() and (v91 <= (v79.DevouringPlagueDebuff:BaseDuration() + (12 - 8)))) then
			if (((1924 - (1309 + 179)) >= (221 - 98)) and v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague))) then
				return "devouring_plague main 14";
			end
		end
		if (((218 + 282) < (4876 - 3060)) and v79.DevouringPlague:IsReady() and ((v13:InsanityDeficit() <= (16 + 4)) or (v13:BuffUp(v79.VoidformBuff) and (v79.VoidBolt:CooldownRemains() > v13:BuffRemains(v79.VoidformBuff)) and (v79.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v79.VoidformBuff) + (3 - 1)))) or (v13:BuffUp(v79.MindDevourerBuff) and (v13:PMultiplier(v79.DevouringPlague) < (1.2 - 0))))) then
			if (((4183 - (295 + 314)) == (8777 - 5203)) and v88.CastCycle(v79.DevouringPlague, v84, v115, not v14:IsSpellInRange(v79.DevouringPlague), nil, nil, v81.DevouringPlagueMouseover)) then
				return "devouring_plague main 16";
			end
		end
		if (((2183 - (1300 + 662)) < (1224 - 834)) and v79.ShadowWordDeath:IsReady() and (v13:HasTier(1786 - (1178 + 577), 2 + 0))) then
			if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((6541 - 4328) <= (2826 - (851 + 554)))) then
				return "shadow_word_death main 18";
			end
		end
		if (((2705 + 353) < (13478 - 8618)) and v79.ShadowCrash:IsCastable() and not v97 and (v14:DebuffRefreshable(v79.VampiricTouchDebuff) or ((v13:BuffStack(v79.DeathsTormentBuff) > (19 - 10)) and v13:HasTier(333 - (115 + 187), 4 + 0)))) then
			if ((v76 == "Confirm") or ((1227 + 69) >= (17520 - 13074))) then
				if (v23(v79.ShadowCrash, not v14:IsInRange(1201 - (160 + 1001))) or ((1219 + 174) > (3098 + 1391))) then
					return "shadow_crash main 20";
				end
			elseif ((v76 == "Enemy Under Cursor") or ((9056 - 4632) < (385 - (237 + 121)))) then
				if ((v17:Exists() and v13:CanAttack(v17)) or ((2894 - (525 + 372)) > (7232 - 3417))) then
					if (((11384 - 7919) > (2055 - (96 + 46))) and v23(v81.ShadowCrashCursor, not v14:IsInRange(817 - (643 + 134)))) then
						return "shadow_crash main 20";
					end
				end
			elseif (((265 + 468) < (4361 - 2542)) and (v76 == "At Cursor")) then
				if (v23(v81.ShadowCrashCursor, not v14:IsInRange(148 - 108)) or ((4215 + 180) == (9331 - 4576))) then
					return "shadow_crash main 20";
				end
			end
		end
		if ((v79.ShadowWordDeath:IsReady() and (v13:BuffStack(v79.DeathsTormentBuff) > (17 - 8)) and v13:HasTier(750 - (316 + 403), 3 + 1) and (not v97 or not v79.ShadowCrash:IsAvailable())) or ((10428 - 6635) < (857 + 1512))) then
			if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((10284 - 6200) == (188 + 77))) then
				return "shadow_word_death main 22";
			end
		end
		if (((1405 + 2953) == (15100 - 10742)) and v79.ShadowWordDeath:IsReady() and v92 and v79.InescapableTorment:IsAvailable() and v101 and ((not v79.InsidiousIre:IsAvailable() and not v79.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff)) and not v13:HasTier(148 - 117, 3 - 1)) then
			if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((180 + 2958) < (1954 - 961))) then
				return "shadow_word_death main 24";
			end
		end
		if (((163 + 3167) > (6834 - 4511)) and v79.VampiricTouch:IsCastable()) then
			if (v88.CastTargetIf(v79.VampiricTouch, v84, "min", v113, v114, not v14:IsSpellInRange(v79.VampiricTouch)) or ((3643 - (12 + 5)) == (15493 - 11504))) then
				return "vampiric_touch main 26";
			end
		end
		if ((v79.MindBlast:IsCastable() and (v13:BuffDown(v79.MindDevourerBuff) or (v79.VoidEruption:CooldownUp() and v79.VoidEruption:IsAvailable()))) or ((1953 - 1037) == (5677 - 3006))) then
			if (((674 - 402) == (56 + 216)) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
				return "mind_blast main 26";
			end
		end
		if (((6222 - (1656 + 317)) <= (4313 + 526)) and v79.VoidTorrent:IsCastable() and not v97) then
			if (((2226 + 551) < (8508 - 5308)) and v88.CastCycle(v79.VoidTorrent, v84, v124, not v14:IsSpellInRange(v79.VoidTorrent), nil, nil, v81.VoidTorrentMouseover, true)) then
				return "void_torrent main 28";
			end
		end
		v89 = v133();
		if (((467 - 372) < (2311 - (5 + 349))) and v89) then
			return v89;
		end
	end
	local function v136()
		local v178 = 0 - 0;
		while true do
			if (((2097 - (266 + 1005)) < (1132 + 585)) and (v178 == (6 - 4))) then
				if (((1877 - 451) >= (2801 - (561 + 1135))) and v79.VoidTorrent:IsCastable() and (v109(v14, false) or v13:BuffUp(v79.VoidformBuff))) then
					if (((3588 - 834) <= (11107 - 7728)) and v23(v79.VoidTorrent, not v14:IsSpellInRange(v79.VoidTorrent), true)) then
						return "void_torrent pl_torrent 10";
					end
				end
				break;
			end
			if ((v178 == (1067 - (507 + 559))) or ((9853 - 5926) == (4369 - 2956))) then
				if ((v79.DevouringPlague:IsReady() and (v14:DebuffRemains(v79.DevouringPlagueDebuff) <= (392 - (212 + 176))) and (v79.VoidTorrent:CooldownRemains() < (v13:GCD() * (907 - (250 + 655))))) or ((3146 - 1992) <= (1376 - 588))) then
					if (v23(v79.DevouringPlague, not v14:IsSpellInRange(v79.DevouringPlague)) or ((2570 - 927) > (5335 - (1869 + 87)))) then
						return "devouring_plague pl_torrent 6";
					end
				end
				if ((v79.MindBlast:IsCastable() and not v13:PrevGCD(3 - 2, v79.MindBlast)) or ((4704 - (484 + 1417)) > (9749 - 5200))) then
					if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((368 - 148) >= (3795 - (48 + 725)))) then
						return "mind_blast pl_torrent 8";
					end
				end
				v178 = 2 - 0;
			end
			if (((7570 - 4748) == (1641 + 1181)) and (v178 == (0 - 0))) then
				if (v79.VoidBolt:IsCastable() or ((297 + 764) == (542 + 1315))) then
					if (((3613 - (152 + 701)) > (2675 - (430 + 881))) and v23(v79.VoidBolt, not v14:IsInRange(16 + 24))) then
						return "void_bolt pl_torrent 2";
					end
				end
				if ((v79.VampiricTouch:IsCastable() and (v14:DebuffRemains(v79.VampiricTouchDebuff) <= (901 - (557 + 338))) and (v79.VoidTorrent:CooldownRemains() < (v13:GCD() * (1 + 1)))) or ((13813 - 8911) <= (12588 - 8993))) then
					if (v23(v79.VampiricTouch, not v14:IsSpellInRange(v79.VampiricTouch), true) or ((10233 - 6381) == (631 - 338))) then
						return "vampiric_touch pl_torrent 4";
					end
				end
				v178 = 802 - (499 + 302);
			end
		end
	end
	local function v137()
		local v179 = 866 - (39 + 827);
		while true do
			if ((v179 == (7 - 4)) or ((3481 - 1922) == (18222 - 13634))) then
				if ((v79.VampiricTouch:IsCastable() and (((v94 > (0 - 0)) and not v79.ShadowCrash:InFlight()) or not v79.WhisperingShadows:IsAvailable())) or ((384 + 4100) == (2306 - 1518))) then
					if (((731 + 3837) >= (6181 - 2274)) and v88.CastCycle(v79.VampiricTouch, v84, v126, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, v81.VampiricTouchMouseover, true)) then
						return "vampiric_touch aoe 16";
					end
				end
				if (((1350 - (103 + 1)) < (4024 - (475 + 79))) and v79.ShadowWordDeath:IsReady() and v96 and v79.InescapableTorment:IsAvailable() and v101 and ((not v79.InsidiousIre:IsAvailable() and not v79.IdolOfYoggSaron:IsAvailable()) or v13:BuffUp(v79.DeathspeakerBuff))) then
					if (((8793 - 4725) >= (3110 - 2138)) and v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath))) then
						return "shadow_word_death aoe 18";
					end
				end
				if (((64 + 429) < (3427 + 466)) and v79.MindSpikeInsanity:IsReady() and v92 and (v79.MindBlast:FullRechargeTime() >= (v13:GCD() * (1506 - (1395 + 108)))) and v79.IdolOfCthun:IsAvailable() and (v79.VoidTorrent:CooldownDown() or not v79.VoidTorrent:IsAvailable())) then
					if (v23(v79.MindSpikeInsanity, not v14:IsInRange(116 - 76), true) or ((2677 - (7 + 1197)) >= (1453 + 1879))) then
						return "mind_spike_insanity aoe 20";
					end
				end
				v179 = 2 + 2;
			end
			if ((v179 == (319 - (27 + 292))) or ((11870 - 7819) <= (1475 - 318))) then
				v130();
				if (((2532 - 1928) < (5681 - 2800)) and v79.VampiricTouch:IsCastable() and (((v94 > (0 - 0)) and not v98 and not v79.ShadowCrash:InFlight()) or not v79.WhisperingShadows:IsAvailable())) then
					if (v88.CastCycle(v79.VampiricTouch, v84, v125, not v14:IsSpellInRange(v79.VampiricTouch), nil, nil, v81.VampiricTouchMouseover, true) or ((1039 - (43 + 96)) == (13775 - 10398))) then
						return "vampiric_touch aoe 2";
					end
				end
				if (((10080 - 5621) > (491 + 100)) and v79.ShadowCrash:IsCastable() and not v97) then
					if (((960 + 2438) >= (4733 - 2338)) and (v76 == "Confirm")) then
						if (v23(v79.ShadowCrash, not v14:IsInRange(16 + 24)) or ((4091 - 1908) >= (890 + 1934))) then
							return "shadow_crash aoe 4";
						end
					elseif (((142 + 1794) == (3687 - (1414 + 337))) and (v76 == "Enemy Under Cursor")) then
						if ((v17:Exists() and v13:CanAttack(v17)) or ((6772 - (1642 + 298)) < (11242 - 6929))) then
							if (((11760 - 7672) > (11496 - 7622)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(14 + 26))) then
								return "shadow_crash aoe 4";
							end
						end
					elseif (((3371 + 961) == (5304 - (357 + 615))) and (v76 == "At Cursor")) then
						if (((2808 + 1191) >= (7115 - 4215)) and v23(v81.ShadowCrashCursor, not v14:IsInRange(35 + 5))) then
							return "shadow_crash aoe 4";
						end
					end
				end
				v179 = 2 - 1;
			end
			if ((v179 == (5 + 1)) or ((172 + 2353) > (2555 + 1509))) then
				if (((5672 - (384 + 917)) == (5068 - (128 + 569))) and v89) then
					return v89;
				end
				break;
			end
			if ((v179 == (1547 - (1407 + 136))) or ((2153 - (687 + 1200)) > (6696 - (556 + 1154)))) then
				if (((7004 - 5013) >= (1020 - (9 + 86))) and v105:IsCastable() and v13:BuffUp(v79.MindFlayInsanityBuff) and v92 and (v79.MindBlast:FullRechargeTime() >= (v13:GCD() * (424 - (275 + 146)))) and v79.IdolOfCthun:IsAvailable() and (v79.VoidTorrent:CooldownDown() or not v79.VoidTorrent:IsAvailable())) then
					if (((74 + 381) < (2117 - (29 + 35))) and v23(v105, not v14:IsSpellInRange(v105), true)) then
						return "mind_flay aoe 22";
					end
				end
				if ((v79.MindBlast:IsCastable() and v96 and (v13:BuffDown(v79.MindDevourerBuff) or (v79.VoidEruption:CooldownUp() and v79.VoidEruption:IsAvailable()))) or ((3660 - 2834) == (14489 - 9638))) then
					if (((807 - 624) == (120 + 63)) and v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true)) then
						return "mind_blast aoe 24";
					end
				end
				if (((2171 - (53 + 959)) <= (2196 - (312 + 96))) and v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (4 - 1)) and (not v97 or ((v87 / (v79.VampiricTouchDebuff:AuraActiveCount() + v87)) < (286.5 - (147 + 138)))) and ((v13:Insanity() >= (949 - (813 + 86))) or v14:DebuffUp(v79.DevouringPlagueDebuff) or v13:BuffUp(v79.DarkReveriesBuff) or v13:BuffUp(v79.VoidformBuff) or v13:BuffUp(v79.DarkAscensionBuff))) then
					local v218 = 0 + 0;
					while true do
						if ((v218 == (0 - 0)) or ((3999 - (18 + 474)) > (1457 + 2861))) then
							v89 = v136();
							if (v89 or ((10036 - 6961) <= (4051 - (860 + 226)))) then
								return v89;
							end
							break;
						end
					end
				end
				v179 = 308 - (121 + 182);
			end
			if (((169 + 1196) <= (3251 - (988 + 252))) and (v179 == (1 + 0))) then
				if ((v30 and ((v91 < (10 + 20)) or ((v14:TimeToDie() > (1985 - (49 + 1921))) and (not v97 or (v87 > (892 - (223 + 667))))))) or ((2828 - (51 + 1)) > (6153 - 2578))) then
					v89 = v134();
					if (v89 or ((5468 - 2914) == (5929 - (146 + 979)))) then
						return v89;
					end
				end
				if (((728 + 1849) == (3182 - (311 + 294))) and v100:IsCastable() and ((v14:DebuffUp(v79.ShadowWordPainDebuff) and v96) or (v79.ShadowCrash:InFlight() and v79.WhisperingShadows:IsAvailable())) and ((v91 < (83 - 53)) or (v14:TimeToDie() > (7 + 8))) and (not v79.DarkAscension:IsAvailable() or (v79.DarkAscension:CooldownRemains() < v106) or (v91 < (1458 - (496 + 947))))) then
					if (v23(v100) or ((1364 - (1233 + 125)) >= (767 + 1122))) then
						return "mindbender aoe 6";
					end
				end
				if (((454 + 52) <= (360 + 1532)) and v79.MindBlast:IsCastable() and ((v79.MindBlast:FullRechargeTime() <= (v106 + v79.MindBlast:CastTime())) or (v102 <= (v79.MindBlast:CastTime() + v106))) and v101 and v79.InescapableTorment:IsAvailable() and (v102 > v79.MindBlast:CastTime()) and (v87 <= (1652 - (963 + 682))) and v13:BuffDown(v79.MindDevourerBuff)) then
					if (v23(v79.MindBlast, not v14:IsSpellInRange(v79.MindBlast), true) or ((1676 + 332) > (3722 - (504 + 1000)))) then
						return "mind_blast aoe 8";
					end
				end
				v179 = 2 + 0;
			end
			if (((346 + 33) <= (392 + 3755)) and (v179 == (2 - 0))) then
				if ((v79.ShadowWordDeath:IsReady() and (v102 <= (2 + 0)) and v101 and v79.InescapableTorment:IsAvailable() and (v87 <= (5 + 2))) or ((4696 - (156 + 26)) <= (582 + 427))) then
					if (v23(v79.ShadowWordDeath, not v14:IsSpellInRange(v79.ShadowWordDeath)) or ((5468 - 1972) == (1356 - (149 + 15)))) then
						return "shadow_word_death aoe 10";
					end
				end
				if (v79.VoidBolt:IsCastable() or ((1168 - (890 + 70)) == (3076 - (39 + 78)))) then
					if (((4759 - (14 + 468)) >= (2887 - 1574)) and v23(v79.VoidBolt, not v14:IsInRange(111 - 71))) then
						return "void_bolt aoe 12";
					end
				end
				if (((1335 + 1252) < (1906 + 1268)) and v79.DevouringPlague:IsReady() and (not v99 or (v13:InsanityDeficit() <= (5 + 15)) or (v13:BuffUp(v79.VoidformBuff) and (v79.VoidBolt:CooldownRemains() > v13:BuffRemains(v79.VoidformBuff)) and (v79.VoidBolt:CooldownRemains() <= (v13:BuffRemains(v79.VoidformBuff) + 1 + 1))))) then
					if (v88.CastCycle(v79.DevouringPlague, v84, v116, not v14:IsSpellInRange(v79.DevouringPlague), nil, nil, v81.DevouringPlagueMouseover) or ((1080 + 3040) <= (4206 - 2008))) then
						return "devouring_plague aoe 14";
					end
				end
				v179 = 3 + 0;
			end
			if ((v179 == (17 - 12)) or ((41 + 1555) == (909 - (12 + 39)))) then
				if (((2996 + 224) == (9966 - 6746)) and v79.VoidTorrent:IsCastable() and not v79.PsychicLink:IsAvailable()) then
					if (v88.CastCycle(v79.VoidTorrent, v84, v127, not v14:IsSpellInRange(v79.VoidTorrent), nil, nil, v81.VoidTorrentMouseover, true) or ((4993 - 3591) > (1074 + 2546))) then
						return "void_torrent aoe 26";
					end
				end
				if (((1355 + 1219) == (6526 - 3952)) and v105:IsCastable() and v13:BuffUp(v79.MindFlayInsanityBuff) and v79.IdolOfCthun:IsAvailable()) then
					if (((1198 + 600) < (13323 - 10566)) and v23(v105, not v14:IsSpellInRange(v105), true)) then
						return "mind_flay aoe 28";
					end
				end
				v89 = v133();
				v179 = 1716 - (1596 + 114);
			end
		end
	end
	local function v138()
		local v180 = 0 - 0;
		while true do
			if ((v180 == (716 - (164 + 549))) or ((1815 - (1059 + 379)) > (3232 - 628))) then
				if (((295 + 273) < (154 + 757)) and v34 and (v13:HealthPercentage() <= v36)) then
					if (((3677 - (145 + 247)) < (3470 + 758)) and (v35 == "Refreshing Healing Potion")) then
						if (((1810 + 2106) > (9866 - 6538)) and v80.RefreshingHealingPotion:IsReady()) then
							if (((480 + 2020) < (3307 + 532)) and v23(v81.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if (((823 - 316) == (1227 - (254 + 466))) and (v180 == (562 - (544 + 16)))) then
				if (((762 - 522) <= (3793 - (294 + 334))) and v32) then
					if (((1087 - (236 + 17)) >= (348 + 457)) and v79.FlashHeal:IsCastable() and (v13:HealthPercentage() <= v67) and v66) then
						if (v23(v81.FlashHealPlayer) or ((2968 + 844) < (8722 - 6406))) then
							return "flash_heal defensive";
						end
					end
					if ((v79.Renew:IsCastable() and (v13:HealthPercentage() <= v69) and v68) or ((12555 - 9903) <= (790 + 743))) then
						if (v23(v81.RenewPlayer) or ((2964 + 634) < (2254 - (413 + 381)))) then
							return "renew defensive";
						end
					end
					if ((v79.PowerWordShield:IsCastable() and (v13:HealthPercentage() <= v71) and v70) or ((174 + 3942) < (2534 - 1342))) then
						if (v23(v81.PowerWordShieldPlayer) or ((8771 - 5394) <= (2873 - (582 + 1388)))) then
							return "power_word_shield defensive";
						end
					end
				end
				if (((6773 - 2797) >= (315 + 124)) and v80.Healthstone:IsReady() and v52 and (v13:HealthPercentage() <= v53)) then
					if (((4116 - (326 + 38)) == (11099 - 7347)) and v23(v81.Healthstone, nil, nil, true)) then
						return "healthstone defensive 3";
					end
				end
				v180 = 3 - 0;
			end
			if (((4666 - (47 + 573)) > (950 + 1745)) and (v180 == (0 - 0))) then
				if ((v79.Fade:IsReady() and v50 and (v13:HealthPercentage() <= v51)) or ((5753 - 2208) == (4861 - (1269 + 395)))) then
					if (((2886 - (76 + 416)) > (816 - (319 + 124))) and v23(v79.Fade, nil, nil, true)) then
						return "fade defensive";
					end
				end
				if (((9497 - 5342) <= (5239 - (564 + 443))) and v79.Dispersion:IsCastable() and (v13:HealthPercentage() < v48) and v49) then
					if (v23(v79.Dispersion) or ((9913 - 6332) == (3931 - (337 + 121)))) then
						return "dispersion defensive";
					end
				end
				v180 = 2 - 1;
			end
			if (((16638 - 11643) > (5259 - (1261 + 650))) and (v180 == (1 + 0))) then
				if ((v79.DesperatePrayer:IsCastable() and (v13:HealthPercentage() <= v47) and v46) or ((1201 - 447) > (5541 - (772 + 1045)))) then
					if (((31 + 186) >= (201 - (102 + 42))) and v23(v79.DesperatePrayer)) then
						return "desperate_prayer defensive";
					end
				end
				if ((v79.VampiricEmbrace:IsReady() and v88.TargetIsValid() and v14:IsInRange(1874 - (1524 + 320)) and v73 and v88.AreUnitsBelowHealthPercentage(v74, v75)) or ((3340 - (1049 + 221)) >= (4193 - (18 + 138)))) then
					if (((6621 - 3916) == (3807 - (67 + 1035))) and v23(v79.VampiricEmbrace, nil, true)) then
						return "vampiric_embrace defensive";
					end
				end
				v180 = 350 - (136 + 212);
			end
		end
	end
	local function v139()
		if (((259 - 198) == (49 + 12)) and ((GetTime() - v28) > v40)) then
			local v191 = 0 + 0;
			while true do
				if ((v191 == (1604 - (240 + 1364))) or ((1781 - (1050 + 32)) >= (4627 - 3331))) then
					if ((v79.BodyandSoul:IsAvailable() and v79.PowerWordShield:IsReady() and v39 and v13:BuffDown(v79.AngelicFeatherBuff) and v13:BuffDown(v79.BodyandSoulBuff)) or ((1055 + 728) >= (4671 - (331 + 724)))) then
						if (v23(v81.PowerWordShieldPlayer) or ((316 + 3597) > (5171 - (269 + 375)))) then
							return "power_word_shield_player move";
						end
					end
					if (((5101 - (267 + 458)) > (255 + 562)) and v79.AngelicFeather:IsReady() and v38 and v13:BuffDown(v79.AngelicFeatherBuff) and v13:BuffDown(v79.BodyandSoulBuff) and v13:BuffDown(v79.AngelicFeatherBuff)) then
						if (((9347 - 4486) > (1642 - (667 + 151))) and v23(v81.AngelicFeatherPlayer)) then
							return "angelic_feather_player move";
						end
					end
					break;
				end
			end
		end
	end
	local function v140()
		if ((v79.PurifyDisease:IsReady() and v31 and v88.DispellableFriendlyUnit()) or ((2880 - (1410 + 87)) >= (4028 - (1504 + 393)))) then
			if (v23(v81.PurifyDiseaseFocus) or ((5070 - 3194) >= (6592 - 4051))) then
				return "purify_disease dispel";
			end
		end
	end
	local function v141()
		local v181 = 796 - (461 + 335);
		while true do
			if (((228 + 1554) <= (5533 - (1730 + 31))) and (v181 == (1671 - (728 + 939)))) then
				v53 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v54 = EpicSettings.Settings['PowerInfusionUsage'] or "";
				v55 = EpicSettings.Settings['PowerInfusionTarget'] or "";
				v56 = EpicSettings.Settings['PowerInfusionHP'] or (0 - 0);
				v57 = EpicSettings.Settings['PowerInfusionGroup'] or (0 - 0);
				v181 = 1073 - (138 + 930);
			end
			if ((v181 == (7 + 0)) or ((3675 + 1025) < (697 + 116))) then
				v68 = EpicSettings.Settings['UseRenew'];
				v69 = EpicSettings.Settings['RenewHP'] or (0 - 0);
				v70 = EpicSettings.Settings['UsePowerWordShield'];
				v71 = EpicSettings.Settings['PowerWordShieldHP'] or (1766 - (459 + 1307));
				v72 = EpicSettings.Settings['UseShadowform'];
				v181 = 1878 - (474 + 1396);
			end
			if (((5585 - 2386) < (3796 + 254)) and ((1 + 5) == v181)) then
				v63 = EpicSettings.Settings['HaloGroup'] or (0 - 0);
				v64 = EpicSettings.Settings['UseDivineStar'];
				v65 = EpicSettings.Settings['DivineStarHP'] or (0 + 0);
				v66 = EpicSettings.Settings['UseFlashHeal'];
				v67 = EpicSettings.Settings['FlashHealHP'] or (0 - 0);
				v181 = 30 - 23;
			end
			if ((v181 == (594 - (562 + 29))) or ((4221 + 730) < (5849 - (374 + 1045)))) then
				v48 = EpicSettings.Settings['DispersionHP'] or (0 + 0);
				v49 = EpicSettings.Settings['UseDispersion'];
				v50 = EpicSettings.Settings['UseFade'];
				v51 = EpicSettings.Settings['FadeHP'] or (0 - 0);
				v52 = EpicSettings.Settings['UseHealthstone'];
				v181 = 642 - (448 + 190);
			end
			if (((31 + 65) == (44 + 52)) and (v181 == (6 + 2))) then
				v73 = EpicSettings.Settings['UseVampiricEmbrace'];
				v74 = EpicSettings.Settings['VampiricEmbraceHP'] or (0 - 0);
				v75 = EpicSettings.Settings['VampiricEmbraceGroup'] or (0 - 0);
				v76 = EpicSettings.Settings['ShadowCrashUsage'] or "";
				v77 = EpicSettings.Settings['VampiricTouchUsage'] or "";
				v181 = 1503 - (1307 + 187);
			end
			if ((v181 == (35 - 26)) or ((6412 - 3673) > (12289 - 8281))) then
				v78 = EpicSettings.Settings['VampiricTouchMax'] or (683 - (232 + 451));
				break;
			end
			if (((1 + 0) == v181) or ((21 + 2) == (1698 - (510 + 54)))) then
				v38 = EpicSettings.Settings['UseAngelicFeather'];
				v39 = EpicSettings.Settings['UseBodyAndSoul'];
				v40 = EpicSettings.Settings['MovementDelay'] or (0 - 0);
				v41 = EpicSettings.Settings['DispelDebuffs'];
				v42 = EpicSettings.Settings['DispelBuffs'];
				v181 = 38 - (13 + 23);
			end
			if ((v181 == (0 - 0)) or ((3868 - 1175) >= (7469 - 3358))) then
				v33 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or "";
				v36 = EpicSettings.Settings['HealingPotionHP'] or (1088 - (830 + 258));
				v37 = EpicSettings.Settings['UsePowerWordFortitude'];
				v181 = 3 - 2;
			end
			if ((v181 == (4 + 1)) or ((3673 + 643) <= (3587 - (860 + 581)))) then
				v58 = EpicSettings.Settings['PIName1'] or "";
				v59 = EpicSettings.Settings['PIName2'] or "";
				v60 = EpicSettings.Settings['PIName3'] or "";
				v61 = EpicSettings.Settings['UseHalo'];
				v62 = EpicSettings.Settings['HaloHP'] or (0 - 0);
				v181 = 5 + 1;
			end
			if ((v181 == (243 - (237 + 4))) or ((8333 - 4787) <= (7106 - 4297))) then
				v43 = EpicSettings.Settings['InterruptWithStun'];
				v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v45 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
				v46 = EpicSettings.Settings['UseDesperatePrayer'];
				v47 = EpicSettings.Settings['DesperatePrayerHP'] or (0 + 0);
				v181 = 2 + 1;
			end
		end
	end
	local function v142()
		local v182 = 0 - 0;
		while true do
			if (((2105 + 2799) > (1179 + 987)) and ((1426 - (85 + 1341)) == v182)) then
				v141();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['cds'];
				v182 = 1 - 0;
			end
			if (((307 - 198) >= (462 - (45 + 327))) and (v182 == (7 - 3))) then
				if (((5480 - (444 + 58)) > (1263 + 1642)) and not v13:AffectingCombat() and v29) then
					local v219 = 0 + 0;
					while true do
						if ((v219 == (0 + 0)) or ((8769 - 5743) <= (4012 - (64 + 1668)))) then
							if ((v79.PowerWordFortitude:IsCastable() and v37 and (v13:BuffDown(v79.PowerWordFortitudeBuff, true) or v88.GroupBuffMissing(v79.PowerWordFortitudeBuff))) or ((3626 - (1227 + 746)) <= (3405 - 2297))) then
								if (((5398 - 2489) > (3103 - (415 + 79))) and v23(v81.PowerWordFortitudePlayer)) then
									return "power_word_fortitude";
								end
							end
							if (((20 + 737) > (685 - (142 + 349))) and HandleAfflicted) then
								v89 = v88.HandleAfflicted(v79.PurifyDisease, v81.PurifyDiseaseMouseover, 18 + 22);
								if (v89 or ((42 - 11) >= (695 + 703))) then
									return v89;
								end
							end
							v219 = 1 + 0;
						end
						if (((8703 - 5507) <= (6736 - (1710 + 154))) and (v219 == (319 - (200 + 118)))) then
							if (((1318 + 2008) == (5814 - 2488)) and v79.PowerWordFortitude:IsCastable() and (v13:BuffDown(v79.PowerWordFortitudeBuff, true) or v88.GroupBuffMissing(v79.PowerWordFortitudeBuff))) then
								if (((2125 - 692) <= (3446 + 432)) and v23(v81.PowerWordFortitudePlayer)) then
									return "power_word_fortitude";
								end
							end
							if ((v79.Shadowform:IsCastable() and (v13:BuffDown(v79.ShadowformBuff)) and v72) or ((1566 + 17) == (932 + 803))) then
								if (v23(v79.Shadowform) or ((477 + 2504) == (5091 - 2741))) then
									return "shadowform";
								end
							end
							v219 = 1252 - (363 + 887);
						end
						if ((v219 == (2 - 0)) or ((21257 - 16791) <= (77 + 416))) then
							if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((5959 - 3412) <= (1358 + 629))) then
								if (((4625 - (674 + 990)) > (786 + 1954)) and v23(v79.Resurrection, nil, true)) then
									return "resurrection";
								end
							end
							break;
						end
					end
				end
				if (((1513 + 2183) >= (5724 - 2112)) and v13:IsMoving() and (v13:AffectingCombat() or v29)) then
					local v220 = 1055 - (507 + 548);
					while true do
						if ((v220 == (837 - (289 + 548))) or ((4788 - (821 + 997)) == (2133 - (195 + 60)))) then
							v89 = v139();
							if (v89 or ((994 + 2699) < (3478 - (251 + 1250)))) then
								return v89;
							end
							break;
						end
					end
				end
				if (v88.TargetIsValid() or v13:AffectingCombat() or ((2724 - 1794) > (1444 + 657))) then
					local v221 = 1032 - (809 + 223);
					while true do
						if (((6059 - 1906) > (9267 - 6181)) and (v221 == (0 - 0))) then
							v90 = v10.BossFightRemains(nil, true);
							v91 = v90;
							v221 = 1 + 0;
						end
						if ((v221 == (1 + 0)) or ((5271 - (14 + 603)) <= (4179 - (118 + 11)))) then
							if ((v91 == (1798 + 9313)) or ((2168 + 434) < (4359 - 2863))) then
								v91 = v10.FightRemains(v85, false);
							end
							v101 = v100:TimeSinceLastCast() <= (964 - (551 + 398));
							v221 = 2 + 0;
						end
						if ((v221 == (2 + 1)) or ((829 + 191) > (8509 - 6221))) then
							v105 = ((v13:BuffUp(v79.MindFlayInsanityBuff)) and v79.MindFlayInsanity) or v79.MindFlay;
							v106 = v13:GCD() + (0.25 - 0);
							break;
						end
						if (((107 + 221) == (1302 - 974)) and (v221 == (1 + 1))) then
							v102 = (104 - (40 + 49)) - v100:TimeSinceLastCast();
							if (((5754 - 4243) < (4298 - (99 + 391))) and (v102 < (0 + 0))) then
								v102 = 0 - 0;
							end
							v221 = 7 - 4;
						end
					end
				end
				v182 = 5 + 0;
			end
			if ((v182 == (2 - 1)) or ((4114 - (1032 + 572)) > (5336 - (203 + 214)))) then
				v31 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['heal'];
				v83 = v13:GetEnemiesInRange(1847 - (568 + 1249));
				v182 = 2 + 0;
			end
			if (((11439 - 6676) == (18397 - 13634)) and (v182 == (1309 - (913 + 393)))) then
				if (((11682 - 7545) > (2610 - 762)) and v13:IsDeadOrGhost()) then
					return;
				end
				if (((2846 - (269 + 141)) <= (6970 - 3836)) and not v13:IsMoving()) then
					v28 = GetTime();
				end
				if (((5704 - (362 + 1619)) == (5348 - (950 + 675))) and (v13:AffectingCombat() or v41)) then
					local v222 = 0 + 0;
					local v223;
					while true do
						if ((v222 == (1180 - (216 + 963))) or ((5333 - (485 + 802)) >= (4875 - (432 + 127)))) then
							if (v89 or ((3081 - (1065 + 8)) < (1072 + 857))) then
								return v89;
							end
							break;
						end
						if (((3985 - (635 + 966)) > (1277 + 498)) and ((42 - (5 + 37)) == v222)) then
							v223 = v41 and v79.Purify:IsReady();
							v89 = v88.FocusUnit(v223, nil, nil, nil);
							v222 = 2 - 1;
						end
					end
				end
				v182 = 2 + 2;
			end
			if ((v182 == (7 - 2)) or ((2126 + 2417) <= (9092 - 4716))) then
				if (((2760 - 2032) == (1372 - 644)) and v88.TargetIsValid()) then
					local v224 = 0 - 0;
					while true do
						if ((v224 == (1 + 0)) or ((1605 - (318 + 211)) > (22983 - 18312))) then
							if (((3438 - (963 + 624)) >= (162 + 216)) and v23(v79.Pool)) then
								return "Pool for Main()";
							end
							break;
						end
						if ((v224 == (846 - (518 + 328))) or ((4540 - 2592) >= (5555 - 2079))) then
							if (((5111 - (301 + 16)) >= (2441 - 1608)) and not v13:AffectingCombat() and v29) then
								v89 = v128();
								if (((11486 - 7396) == (10672 - 6582)) and v89) then
									return v89;
								end
							end
							if (v13:AffectingCombat() or v29 or ((3404 + 354) == (1419 + 1079))) then
								local v227 = 0 - 0;
								while true do
									if ((v227 == (1 + 0)) or ((255 + 2418) < (5007 - 3432))) then
										v97 = false;
										v99 = ((v79.VoidEruption:CooldownRemains() <= (v13:GCD() * (1 + 2))) and v79.VoidEruption:IsAvailable()) or (v79.DarkAscension:CooldownUp() and v79.DarkAscension:IsAvailable()) or (v79.VoidTorrent:IsAvailable() and v79.PsychicLink:IsAvailable() and (v79.VoidTorrent:CooldownRemains() <= (1023 - (829 + 190))) and v13:BuffDown(v79.VoidformBuff));
										if ((v104 == nil) or ((13276 - 9555) <= (1841 - 386))) then
											v104 = v14:GUID();
										end
										v227 = 2 - 0;
									end
									if (((2319 - 1385) < (538 + 1732)) and (v227 == (1 + 1))) then
										if (((v103 == false) and v29 and (v14:GUID() == v104) and not v109(v14, true)) or ((4892 - 3280) == (1185 + 70))) then
											v89 = v132();
											if (v89 or ((4965 - (520 + 93)) < (4482 - (259 + 17)))) then
												return v89;
											end
											if (v23(v79.Pool) or ((165 + 2695) <= (66 + 115))) then
												return "Pool for Opener()";
											end
										else
											v103 = true;
										end
										if (((10907 - 7685) >= (2118 - (396 + 195))) and v16) then
											if (((4366 - 2861) <= (3882 - (440 + 1321))) and v41) then
												local v229 = 1829 - (1059 + 770);
												while true do
													if (((3440 - 2696) == (1289 - (424 + 121))) and (v229 == (0 + 0))) then
														v89 = v140();
														if (v89 or ((3326 - (641 + 706)) >= (1124 + 1712))) then
															return v89;
														end
														break;
													end
												end
											end
										end
										if (((2273 - (249 + 191)) <= (11622 - 8954)) and v79.DispelMagic:IsReady() and v31 and v42 and not v13:IsCasting() and not v13:IsChanneling() and v88.UnitHasMagicBuff(v14)) then
											if (((1647 + 2039) == (14206 - 10520)) and v23(v79.DispelMagic, not v14:IsSpellInRange(v79.DispelMagic))) then
												return "dispel_magic damage";
											end
										end
										v227 = 430 - (183 + 244);
									end
									if (((171 + 3296) > (1207 - (434 + 296))) and (v227 == (0 - 0))) then
										v89 = v138();
										if (v89 or ((3800 - (169 + 343)) >= (3105 + 436))) then
											return v89;
										end
										if ((not v13:IsCasting() and not v13:IsChanneling()) or ((6258 - 2701) == (13326 - 8786))) then
											local v228 = 0 + 0;
											while true do
												if ((v228 == (2 - 1)) or ((1384 - (651 + 472)) > (958 + 309))) then
													v89 = v88.Interrupt(v79.Silence, 13 + 17, true, v17, v81.SilenceMouseover);
													if (((1552 - 280) < (4341 - (397 + 86))) and v89) then
														return v89;
													end
													v228 = 878 - (423 + 453);
												end
												if (((373 + 3291) == (483 + 3181)) and ((2 + 0) == v228)) then
													v89 = v88.InterruptWithStun(v79.PsychicScream, 7 + 1);
													if (((1734 + 207) >= (1640 - (50 + 1140))) and v89) then
														return v89;
													end
													break;
												end
												if ((v228 == (0 + 0)) or ((2744 + 1902) < (21 + 303))) then
													v89 = v88.Interrupt(v79.Silence, 43 - 13, true);
													if (((2774 + 1059) == (4429 - (157 + 439))) and v89) then
														return v89;
													end
													v228 = 1 - 0;
												end
											end
										end
										v227 = 3 - 2;
									end
									if ((v227 == (8 - 5)) or ((2158 - (782 + 136)) > (4225 - (112 + 743)))) then
										if ((v87 > (1173 - (1026 + 145))) or (v86 > (1 + 2)) or ((3199 - (493 + 225)) == (17209 - 12527))) then
											v89 = v137();
											if (((2876 + 1851) >= (557 - 349)) and v89) then
												return v89;
											end
											if (((6 + 274) < (11005 - 7154)) and v23(v79.Pool)) then
												return "Pool for AoE()";
											end
										end
										v89 = v135();
										if (v89 or ((876 + 2131) > (5336 - 2142))) then
											return v89;
										end
										break;
									end
								end
							end
							v224 = 1596 - (210 + 1385);
						end
					end
				end
				break;
			end
			if ((v182 == (1691 - (1201 + 488))) or ((1324 + 812) >= (5239 - 2293))) then
				v84 = v13:GetEnemiesInRange(71 - 31);
				v85 = v14:GetEnemiesInSplashRange(595 - (352 + 233));
				if (((5232 - 3067) <= (1372 + 1149)) and AOE) then
					local v225 = 0 - 0;
					while true do
						if (((3435 - (489 + 85)) > (2162 - (277 + 1224))) and (v225 == (1493 - (663 + 830)))) then
							v86 = #v83;
							v87 = v14:GetEnemiesInSplashRangeCount(9 + 1);
							break;
						end
					end
				else
					local v226 = 0 - 0;
					while true do
						if (((5400 - (461 + 414)) > (758 + 3761)) and (v226 == (0 + 0))) then
							v86 = 1 + 0;
							v87 = 1 + 0;
							break;
						end
					end
				end
				v182 = 253 - (172 + 78);
			end
		end
	end
	local function v143()
		local v183 = 0 - 0;
		while true do
			if (((1170 + 2008) > (1402 - 430)) and (v183 == (1 + 0))) then
				v20.Print("Shadow Priest by Epic BoomK");
				EpicSettings.SetupVersion("Shadow Priest X v 10.2.01 By BoomK");
				break;
			end
			if (((1592 + 3174) == (7984 - 3218)) and ((0 - 0) == v183)) then
				v107();
				v79.VampiricTouchDebuff:RegisterAuraTracking();
				v183 = 1 + 0;
			end
		end
	end
	v20.SetAPL(143 + 115, v142, v143);
end;
return v0["Epix_Priest_Shadow.lua"]();

