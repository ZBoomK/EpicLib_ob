local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4006 + 545) > (5094 - (832 + 192))) and not v5) then
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
		if (((1958 - (1090 + 820)) == (43 + 5)) and v100.CleanseSpirit:IsAvailable()) then
			v104.DispellableDebuffs = v104.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		local v146 = 1541 - (718 + 823);
		while true do
			if (((722 + 425) >= (1140 - (266 + 539))) and (v146 == (0 - 0))) then
				v100.PrimordialWave:RegisterInFlightEffect(328387 - (636 + 589));
				v100.PrimordialWave:RegisterInFlight();
				v146 = 2 - 1;
			end
			if (((7084 - 3649) > (1662 + 435)) and (v146 == (1 + 0))) then
				v100.LavaBurst:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v100.PrimordialWave:RegisterInFlightEffect(328177 - (657 + 358));
	v100.PrimordialWave:RegisterInFlight();
	v100.LavaBurst:RegisterInFlight();
	local v107 = 29419 - 18308;
	local v108 = 25313 - 14202;
	local v109, v110;
	local v111, v112;
	local v113 = 1187 - (1151 + 36);
	local v114 = 0 + 0;
	local v115 = 0 + 0;
	local v116 = 0 - 0;
	local v117 = 1832 - (1552 + 280);
	local function v118()
		return (874 - (64 + 770)) - (v28() - v115);
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v147 = 0 + 0;
		local v148;
		local v149;
		local v150;
		while true do
			if ((v147 == (0 - 0)) or ((670 + 3100) >= (5284 - (157 + 1086)))) then
				v148, v149, v149, v149, v150 = select(15 - 7, ...);
				if (((v148 == v13:GUID()) and (v150 == (839308 - 647674))) or ((5815 - 2024) <= (2198 - 587))) then
					local v249 = 819 - (599 + 220);
					while true do
						if ((v249 == (0 - 0)) or ((6509 - (1813 + 118)) <= (1468 + 540))) then
							v116 = v28();
							C_Timer.After(1217.1 - (841 + 376), function()
								if (((1575 - 450) <= (483 + 1593)) and (v116 ~= v117)) then
									v115 = v116;
								end
							end);
							break;
						end
					end
				end
				break;
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v119(v151)
		return (v151:DebuffRefreshable(v100.FlameShockDebuff));
	end
	local function v120(v152)
		return v152:DebuffRefreshable(v100.FlameShockDebuff) and (v152:DebuffRemains(v100.FlameShockDebuff) < (v152:TimeToDie() - (13 - 8)));
	end
	local function v121(v153)
		return v153:DebuffRefreshable(v100.FlameShockDebuff) and (v153:DebuffRemains(v100.FlameShockDebuff) < (v153:TimeToDie() - (864 - (464 + 395)))) and (v153:DebuffRemains(v100.FlameShockDebuff) > (0 - 0));
	end
	local function v122(v154)
		return (v154:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v123(v155)
		return v155:DebuffRemains(v100.FlameShockDebuff) > (1 + 1);
	end
	local function v124(v156)
		return (v156:DebuffRemains(v100.LightningRodDebuff));
	end
	local function v125()
		local v157 = v13:Maelstrom();
		if (not v13:IsCasting() or ((1580 - (467 + 370)) >= (9090 - 4691))) then
			return v157;
		elseif (((848 + 307) < (5735 - 4062)) and v13:IsCasting(v100.ElementalBlast)) then
			return v157 - (12 + 63);
		elseif (v13:IsCasting(v100.Icefury) or ((5406 - 3082) <= (1098 - (150 + 370)))) then
			return v157 + (1307 - (74 + 1208));
		elseif (((9264 - 5497) == (17865 - 14098)) and v13:IsCasting(v100.LightningBolt)) then
			return v157 + 8 + 2;
		elseif (((4479 - (14 + 376)) == (7091 - 3002)) and v13:IsCasting(v100.LavaBurst)) then
			return v157 + 8 + 4;
		elseif (((3917 + 541) >= (1597 + 77)) and v13:IsCasting(v100.ChainLightning)) then
			return v157 + ((11 - 7) * v114);
		else
			return v157;
		end
	end
	local function v126(v158)
		local v159 = v158:IsReady();
		if (((732 + 240) <= (1496 - (23 + 55))) and ((v158 == v100.Stormkeeper) or (v158 == v100.ElementalBlast) or (v158 == v100.Icefury))) then
			local v189 = 0 - 0;
			local v190;
			while true do
				if ((v189 == (0 + 0)) or ((4435 + 503) < (7383 - 2621))) then
					v190 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
					return v159 and v190 and not v13:IsCasting(v158);
				end
			end
		elseif ((v158 == v100.LavaBeam) or ((788 + 1716) > (5165 - (652 + 249)))) then
			local v246 = 0 - 0;
			local v247;
			while true do
				if (((4021 - (708 + 1160)) == (5844 - 3691)) and (v246 == (0 - 0))) then
					v247 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
					return v159 and v247;
				end
			end
		elseif ((v158 == v100.LightningBolt) or (v158 == v100.ChainLightning) or ((534 - (10 + 17)) >= (582 + 2009))) then
			local v262 = 1732 - (1400 + 332);
			local v263;
			while true do
				if (((8594 - 4113) == (6389 - (242 + 1666))) and (v262 == (0 + 0))) then
					v263 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.StormkeeperBuff) or not v13:IsMoving();
					return v159 and v263;
				end
			end
		elseif ((v158 == v100.LavaBurst) or ((854 + 1474) < (591 + 102))) then
			local v271 = 940 - (850 + 90);
			local v272;
			local v273;
			local v274;
			local v275;
			while true do
				if (((7580 - 3252) == (5718 - (360 + 1030))) and (v271 == (0 + 0))) then
					v272 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.LavaSurgeBuff) or not v13:IsMoving();
					v273 = v13:BuffUp(v100.LavaSurgeBuff);
					v271 = 2 - 1;
				end
				if (((2184 - 596) >= (2993 - (909 + 752))) and (v271 == (1224 - (109 + 1114)))) then
					v274 = (v100.LavaBurst:Charges() >= (1 - 0)) and not v13:IsCasting(v100.LavaBurst);
					v275 = (v100.LavaBurst:Charges() == (1 + 1)) and v13:IsCasting(v100.LavaBurst);
					v271 = 244 - (6 + 236);
				end
				if ((v271 == (2 + 0)) or ((3360 + 814) > (10018 - 5770))) then
					return v159 and v272 and (v273 or v274 or v275);
				end
			end
		elseif ((v158 == v100.PrimordialWave) or ((8010 - 3424) <= (1215 - (1076 + 57)))) then
			return v159 and v33 and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffDown(v100.LavaSurgeBuff);
		else
			return v159;
		end
	end
	local function v127()
		local v160 = 0 + 0;
		local v161;
		while true do
			if (((4552 - (579 + 110)) == (305 + 3558)) and (v160 == (0 + 0))) then
				if (not v100.MasteroftheElements:IsAvailable() or ((150 + 132) <= (449 - (174 + 233)))) then
					return false;
				end
				v161 = v13:BuffUp(v100.MasteroftheElementsBuff);
				v160 = 2 - 1;
			end
			if (((8088 - 3479) >= (341 + 425)) and ((1175 - (663 + 511)) == v160)) then
				if (not v13:IsCasting() or ((1028 + 124) == (541 + 1947))) then
					return v161;
				elseif (((10549 - 7127) > (2029 + 1321)) and v13:IsCasting(v105.LavaBurst)) then
					return true;
				elseif (((2064 - 1187) > (909 - 533)) and (v13:IsCasting(v105.ElementalBlast) or v13:IsCasting(v100.Icefury) or v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning))) then
					return false;
				else
					return v161;
				end
				break;
			end
		end
	end
	local function v128()
		local v162 = 0 + 0;
		local v163;
		while true do
			if ((v162 == (1 - 0)) or ((2223 + 895) <= (170 + 1681))) then
				if (not v13:IsCasting() or ((887 - (478 + 244)) >= (4009 - (440 + 77)))) then
					return v163 > (0 + 0);
				elseif (((14453 - 10504) < (6412 - (655 + 901))) and (v163 == (1 + 0)) and (v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning))) then
					return false;
				else
					return v163 > (0 + 0);
				end
				break;
			end
			if ((v162 == (0 + 0)) or ((17226 - 12950) < (4461 - (695 + 750)))) then
				if (((16015 - 11325) > (6365 - 2240)) and not v100.PoweroftheMaelstrom:IsAvailable()) then
					return false;
				end
				v163 = v13:BuffStack(v100.PoweroftheMaelstromBuff);
				v162 = 3 - 2;
			end
		end
	end
	local function v129()
		if (not v100.Stormkeeper:IsAvailable() or ((401 - (285 + 66)) >= (2088 - 1192))) then
			return false;
		end
		local v164 = v13:BuffUp(v100.StormkeeperBuff);
		if (not v13:IsCasting() or ((3024 - (682 + 628)) >= (477 + 2481))) then
			return v164;
		elseif (v13:IsCasting(v100.Stormkeeper) or ((1790 - (176 + 123)) < (270 + 374))) then
			return true;
		else
			return v164;
		end
	end
	local function v130()
		if (((511 + 193) < (1256 - (239 + 30))) and not v100.Icefury:IsAvailable()) then
			return false;
		end
		local v165 = v13:BuffUp(v100.IcefuryBuff);
		if (((1011 + 2707) > (1832 + 74)) and not v13:IsCasting()) then
			return v165;
		elseif (v13:IsCasting(v100.Icefury) or ((1695 - 737) > (11340 - 7705))) then
			return true;
		else
			return v165;
		end
	end
	local v131 = 315 - (306 + 9);
	local function v132()
		if (((12217 - 8716) <= (782 + 3710)) and v100.CleanseSpirit:IsReady() and v35 and v104.UnitHasDispellableDebuffByPlayer(v17)) then
			if ((v131 == (0 + 0)) or ((1657 + 1785) < (7286 - 4738))) then
				v131 = v28();
			end
			if (((4250 - (1140 + 235)) >= (932 + 532)) and v104.Wait(459 + 41, v131)) then
				local v248 = 0 + 0;
				while true do
					if ((v248 == (52 - (33 + 19))) or ((1733 + 3064) >= (14665 - 9772))) then
						if (v24(v102.CleanseSpiritFocus) or ((243 + 308) > (4055 - 1987))) then
							return "cleanse_spirit dispel";
						end
						v131 = 0 + 0;
						break;
					end
				end
			end
		end
	end
	local function v133()
		if (((2803 - (586 + 103)) > (86 + 858)) and v98 and (v13:HealthPercentage() <= v99)) then
			if (v100.HealingSurge:IsReady() or ((6963 - 4701) >= (4584 - (1309 + 179)))) then
				if (v24(v100.HealingSurge) or ((4070 - 1815) >= (1540 + 1997))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v134()
		local v166 = 0 - 0;
		while true do
			if ((v166 == (0 + 0)) or ((8152 - 4315) < (2602 - 1296))) then
				if (((3559 - (295 + 314)) == (7245 - 4295)) and v100.AstralShift:IsReady() and v71 and (v13:HealthPercentage() <= v77)) then
					if (v24(v100.AstralShift) or ((6685 - (1300 + 662)) < (10356 - 7058))) then
						return "astral_shift defensive 1";
					end
				end
				if (((2891 - (1178 + 577)) >= (80 + 74)) and v100.AncestralGuidance:IsReady() and v70 and v104.AreUnitsBelowHealthPercentage(v75, v76, v100.HealingSurge)) then
					if (v24(v100.AncestralGuidance) or ((801 - 530) > (6153 - (851 + 554)))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v166 = 1 + 0;
			end
			if (((13145 - 8405) >= (6845 - 3693)) and (v166 == (303 - (115 + 187)))) then
				if ((v100.HealingStreamTotem:IsReady() and v72 and v104.AreUnitsBelowHealthPercentage(v78, v79, v100.HealingSurge)) or ((1975 + 603) >= (3210 + 180))) then
					if (((161 - 120) <= (2822 - (160 + 1001))) and v24(v100.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((526 + 75) < (2457 + 1103)) and v101.Healthstone:IsReady() and v93 and (v13:HealthPercentage() <= v95)) then
					if (((481 - 246) < (1045 - (237 + 121))) and v24(v102.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v166 = 899 - (525 + 372);
			end
			if (((8623 - 4074) > (3788 - 2635)) and (v166 == (144 - (96 + 46)))) then
				if ((v92 and (v13:HealthPercentage() <= v94)) or ((5451 - (643 + 134)) < (1687 + 2985))) then
					if (((8794 - 5126) < (16933 - 12372)) and (v96 == "Refreshing Healing Potion")) then
						if (v101.RefreshingHealingPotion:IsReady() or ((437 + 18) == (7074 - 3469))) then
							if (v24(v102.RefreshingHealingPotion) or ((5443 - 2780) == (4031 - (316 + 403)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if (((2843 + 1434) <= (12303 - 7828)) and (v96 == "Dreamwalker's Healing Potion")) then
						if (v101.DreamwalkersHealingPotion:IsReady() or ((315 + 555) == (2994 - 1805))) then
							if (((1101 + 452) <= (1010 + 2123)) and v24(v102.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v135()
		v30 = v104.HandleTopTrinket(v103, v33, 138 - 98, nil);
		if (v30 or ((10683 - 8446) >= (7293 - 3782))) then
			return v30;
		end
		v30 = v104.HandleBottomTrinket(v103, v33, 3 + 37, nil);
		if (v30 or ((2605 - 1281) > (148 + 2872))) then
			return v30;
		end
	end
	local function v136()
		local v167 = 0 - 0;
		while true do
			if ((v167 == (18 - (12 + 5))) or ((11620 - 8628) == (4013 - 2132))) then
				if (((6602 - 3496) > (3784 - 2258)) and v126(v100.ElementalBlast) and v39) then
					if (((614 + 2409) < (5843 - (1656 + 317))) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast precombat 6";
					end
				end
				if (((128 + 15) > (60 + 14)) and v13:IsCasting(v100.ElementalBlast) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) then
					if (((47 - 29) < (10394 - 8282)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 8";
					end
				end
				v167 = 356 - (5 + 349);
			end
			if (((5210 - 4113) <= (2899 - (266 + 1005))) and (v167 == (2 + 0))) then
				if (((15798 - 11168) == (6095 - 1465)) and v13:IsCasting(v100.ElementalBlast) and v40 and not v100.PrimordialWave:IsAvailable() and v100.FlameShock:IsViable()) then
					if (((5236 - (561 + 1135)) > (3495 - 812)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if (((15758 - 10964) >= (4341 - (507 + 559))) and v126(v100.LavaBurst) and v44 and not v13:IsCasting(v100.LavaBurst) and (not v100.ElementalBlast:IsAvailable() or (v100.ElementalBlast:IsAvailable() and not v100.ElementalBlast:IsAvailable()))) then
					if (((3723 - 2239) == (4589 - 3105)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v167 = 391 - (212 + 176);
			end
			if (((2337 - (250 + 655)) < (9694 - 6139)) and (v167 == (5 - 2))) then
				if ((v13:IsCasting(v100.LavaBurst) and v40 and v100.FlameShock:IsReady()) or ((1666 - 601) > (5534 - (1869 + 87)))) then
					if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((16631 - 11836) < (3308 - (484 + 1417)))) then
						return "flameshock precombat 14";
					end
				end
				if (((3971 - 2118) < (8065 - 3252)) and v13:IsCasting(v100.LavaBurst) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) then
					if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((3594 - (48 + 725)) < (3971 - 1540))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
			if ((v167 == (0 - 0)) or ((1671 + 1203) < (5828 - 3647))) then
				if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108)) or ((784 + 1905) <= (1196 - (152 + 701)))) then
					if (v24(v100.Stormkeeper) or ((3180 - (430 + 881)) == (770 + 1239))) then
						return "stormkeeper precombat 2";
					end
				end
				if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (895 - (557 + 338))) and v42) or ((1049 + 2497) < (6543 - 4221))) then
					if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((7290 - 5208) == (12680 - 7907))) then
						return "icefury precombat 4";
					end
				end
				v167 = 2 - 1;
			end
		end
	end
	local function v137()
		if (((4045 - (499 + 302)) > (1921 - (39 + 827))) and v100.FireElemental:IsReady() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) then
			if (v24(v100.FireElemental) or ((9145 - 5832) <= (3970 - 2192))) then
				return "fire_elemental aoe 2";
			end
		end
		if ((v100.StormElemental:IsReady() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) or ((5643 - 4222) >= (3230 - 1126))) then
			if (((156 + 1656) <= (9509 - 6260)) and v24(v100.StormElemental)) then
				return "storm_elemental aoe 4";
			end
		end
		if (((260 + 1363) <= (3096 - 1139)) and v126(v100.Stormkeeper) and not v129() and v48 and ((v65 and v34) or not v65) and (v90 < v108)) then
			if (((4516 - (103 + 1)) == (4966 - (475 + 79))) and v24(v100.Stormkeeper)) then
				return "stormkeeper aoe 7";
			end
		end
		if (((3783 - 2033) >= (2694 - 1852)) and v100.TotemicRecall:IsCastable() and (v100.LiquidMagmaTotem:CooldownRemains() > (6 + 39)) and v49) then
			if (((3848 + 524) > (3353 - (1395 + 108))) and v24(v100.TotemicRecall)) then
				return "totemic_recall aoe 8";
			end
		end
		if (((674 - 442) < (2025 - (7 + 1197))) and v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "cursor")) then
			if (((226 + 292) < (315 + 587)) and v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(359 - (27 + 292)))) then
				return "liquid_magma_totem aoe cursor 10";
			end
		end
		if (((8773 - 5779) > (1093 - 235)) and v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "player")) then
			if (v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(167 - 127)) or ((7404 - 3649) <= (1742 - 827))) then
				return "liquid_magma_totem aoe player 11";
			end
		end
		if (((4085 - (43 + 96)) > (15268 - 11525)) and v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffUp(v100.SurgeofPowerBuff) and v13:BuffDown(v100.SplinteredElementsBuff)) then
			if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((3018 - 1683) >= (2744 + 562))) then
				return "primordial_wave aoe 12";
			end
			if (((1368 + 3476) > (4452 - 2199)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
				return "primordial_wave aoe 12";
			end
		end
		if (((174 + 278) == (846 - 394)) and v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.DeeplyRootedElements:IsAvailable() and not v100.SurgeofPower:IsAvailable() and v13:BuffDown(v100.SplinteredElementsBuff)) then
			if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((1435 + 3122) < (154 + 1933))) then
				return "primordial_wave aoe 14";
			end
			if (((5625 - (1414 + 337)) == (5814 - (1642 + 298))) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
				return "primordial_wave aoe 14";
			end
		end
		if ((v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.MasteroftheElements:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((5051 - 3113) > (14197 - 9262))) then
			local v191 = 0 - 0;
			while true do
				if ((v191 == (0 + 0)) or ((3311 + 944) < (4395 - (357 + 615)))) then
					if (((1021 + 433) <= (6112 - 3621)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 16";
					end
					if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((3562 + 595) <= (6006 - 3203))) then
						return "primordial_wave aoe 16";
					end
					break;
				end
			end
		end
		if (((3882 + 971) >= (203 + 2779)) and v100.FlameShock:IsCastable()) then
			local v192 = 0 + 0;
			while true do
				if (((5435 - (384 + 917)) > (4054 - (128 + 569))) and (v192 == (1543 - (1407 + 136)))) then
					if ((v13:BuffUp(v100.SurgeofPowerBuff) and v40 and v100.LightningRod:IsAvailable() and v100.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v100.FlameShockDebuff) < (v16:TimeToDie() - (1903 - (687 + 1200)))) and (v111 < (1715 - (556 + 1154)))) or ((12021 - 8604) < (2629 - (9 + 86)))) then
						local v264 = 421 - (275 + 146);
						while true do
							if ((v264 == (0 + 0)) or ((2786 - (29 + 35)) <= (726 - 562))) then
								if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((7192 - 4784) < (9310 - 7201))) then
									return "flame_shock aoe 18";
								end
								if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((22 + 11) == (2467 - (53 + 959)))) then
									return "flame_shock aoe 18";
								end
								break;
							end
						end
					end
					if ((v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < (414 - (312 + 96)))) or ((768 - 325) >= (4300 - (147 + 138)))) then
						local v265 = 899 - (813 + 86);
						while true do
							if (((3057 + 325) > (306 - 140)) and (v265 == (492 - (18 + 474)))) then
								if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((95 + 185) == (9983 - 6924))) then
									return "flame_shock aoe 20";
								end
								if (((2967 - (860 + 226)) > (1596 - (121 + 182))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 20";
								end
								break;
							end
						end
					end
					v192 = 1 + 0;
				end
				if (((3597 - (988 + 252)) == (267 + 2090)) and (v192 == (1 + 1))) then
					if (((2093 - (49 + 1921)) == (1013 - (223 + 667))) and v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable())) then
						if (v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock)) or ((1108 - (51 + 1)) >= (5837 - 2445))) then
							return "flame_shock aoe 26";
						end
						if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((2314 - 1233) < (2200 - (146 + 979)))) then
							return "flame_shock aoe 26";
						end
					end
					if ((v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable()) or ((297 + 752) >= (5037 - (311 + 294)))) then
						local v266 = 0 - 0;
						while true do
							if ((v266 == (0 + 0)) or ((6211 - (496 + 947)) <= (2204 - (1233 + 125)))) then
								if (v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock)) or ((1363 + 1995) <= (1274 + 146))) then
									return "flame_shock aoe 28";
								end
								if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((711 + 3028) <= (4650 - (963 + 682)))) then
									return "flame_shock aoe 28";
								end
								break;
							end
						end
					end
					v192 = 3 + 0;
				end
				if ((v192 == (1507 - (504 + 1000))) or ((1118 + 541) >= (1944 + 190))) then
					if ((v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable()) or ((308 + 2952) < (3472 - 1117))) then
						if (v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock)) or ((572 + 97) == (2456 + 1767))) then
							return "flame_shock aoe 30";
						end
						if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((1874 - (156 + 26)) < (339 + 249))) then
							return "flame_shock aoe 30";
						end
					end
					break;
				end
				if ((v192 == (1 - 0)) or ((4961 - (149 + 15)) < (4611 - (890 + 70)))) then
					if ((v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (123 - (39 + 78)))) or ((4659 - (14 + 468)) > (10665 - 5815))) then
						local v267 = 0 - 0;
						while true do
							if ((v267 == (0 + 0)) or ((241 + 159) > (237 + 874))) then
								if (((1378 + 1673) > (264 + 741)) and v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 22";
								end
								if (((7068 - 3375) <= (4331 + 51)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 22";
								end
								break;
							end
						end
					end
					if ((v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (21 - 15))) or ((83 + 3199) > (4151 - (12 + 39)))) then
						if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((3331 + 249) < (8802 - 5958))) then
							return "flame_shock aoe 24";
						end
						if (((316 - 227) < (1332 + 3158)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
							return "flame_shock aoe 24";
						end
					end
					v192 = 2 + 0;
				end
			end
		end
		if ((v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108)) or ((12635 - 7652) < (1205 + 603))) then
			if (((18504 - 14675) > (5479 - (1596 + 114))) and v24(v100.Ascendance)) then
				return "ascendance aoe 32";
			end
		end
		if (((3876 - 2391) <= (3617 - (164 + 549))) and v126(v100.LavaBurst) and (v114 == (1441 - (1059 + 379))) and not v100.LightningRod:IsAvailable() and v13:HasTier(38 - 7, 3 + 1)) then
			local v193 = 0 + 0;
			while true do
				if (((4661 - (145 + 247)) == (3503 + 766)) and (v193 == (0 + 0))) then
					if (((1147 - 760) <= (534 + 2248)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 34";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1636 + 263) <= (1488 - 571))) then
						return "lava_burst aoe 34";
					end
					break;
				end
			end
		end
		if ((v37 and v100.Earthquake:IsReady() and v127() and (((v13:BuffStack(v100.MagmaChamberBuff) > (735 - (254 + 466))) and (v114 >= ((567 - (544 + 16)) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.SplinteredElements:IsAvailable() and (v114 >= ((31 - 21) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.MountainsWillFall:IsAvailable() and (v114 >= (637 - (294 + 334))))) and not v100.LightningRod:IsAvailable() and v13:HasTier(284 - (236 + 17), 2 + 2)) or ((3357 + 955) <= (3298 - 2422))) then
			local v194 = 0 - 0;
			while true do
				if (((1150 + 1082) <= (2139 + 457)) and ((794 - (413 + 381)) == v194)) then
					if (((89 + 2006) < (7839 - 4153)) and (v51 == "cursor")) then
						if (v24(v102.EarthquakeCursor, not v16:IsInRange(103 - 63)) or ((3565 - (582 + 1388)) >= (7622 - 3148))) then
							return "earthquake aoe 36";
						end
					end
					if ((v51 == "player") or ((3307 + 1312) < (3246 - (326 + 38)))) then
						if (v24(v102.EarthquakePlayer, not v16:IsInRange(118 - 78)) or ((419 - 125) >= (5451 - (47 + 573)))) then
							return "earthquake aoe 36";
						end
					end
					break;
				end
			end
		end
		if (((716 + 1313) <= (13097 - 10013)) and v126(v100.LavaBeam) and v43 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (9 - 3))) or (v127() and ((v114 < (1670 - (1269 + 395))) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(523 - (76 + 416), 447 - (319 + 124))) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((4656 - 2619) == (3427 - (564 + 443)))) then
				return "lava_beam aoe 38";
			end
		end
		if (((12341 - 7883) > (4362 - (337 + 121))) and v126(v100.ChainLightning) and v36 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (17 - 11))) or (v127() and ((v114 < (19 - 13)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(1942 - (1261 + 650), 2 + 2)) then
			if (((694 - 258) >= (1940 - (772 + 1045))) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 40";
			end
		end
		if (((71 + 429) < (1960 - (102 + 42))) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and not v100.LightningRod:IsAvailable() and v13:HasTier(1875 - (1524 + 320), 1274 - (1049 + 221))) then
			if (((3730 - (18 + 138)) == (8747 - 5173)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 42";
			end
			if (((1323 - (67 + 1035)) < (738 - (136 + 212))) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 42";
			end
		end
		if ((v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.MasteroftheElements:IsAvailable() and not v127() and (v125() >= (((254 - 194) - ((5 + 0) * v100.EyeoftheStorm:TalentRank())) - ((2 + 0) * v25(v100.FlowofPower:IsAvailable())))) and ((not v100.EchoesofGreatSundering:IsAvailable() and not v100.LightningRod:IsAvailable()) or v13:BuffUp(v100.EchoesofGreatSunderingBuff)) and ((not v13:BuffUp(v100.AscendanceBuff) and (v114 > (1607 - (240 + 1364))) and v100.UnrelentingCalamity:IsAvailable()) or ((v114 > (1085 - (1050 + 32))) and not v100.UnrelentingCalamity:IsAvailable()) or (v114 == (10 - 7)))) or ((1310 + 903) <= (2476 - (331 + 724)))) then
			local v195 = 0 + 0;
			while true do
				if (((3702 - (269 + 375)) < (5585 - (267 + 458))) and ((0 + 0) == v195)) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((2492 - 1196) >= (5264 - (667 + 151)))) then
						return "lava_burst aoe 44";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((2890 - (1410 + 87)) > (6386 - (1504 + 393)))) then
						return "lava_burst aoe 44";
					end
					break;
				end
			end
		end
		if ((v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and (v114 > (8 - 5)) and ((v114 > (7 - 4)) or (v113 > (799 - (461 + 335))))) or ((566 + 3858) < (1788 - (1730 + 31)))) then
			local v196 = 1667 - (728 + 939);
			while true do
				if ((v196 == (0 - 0)) or ((4050 - 2053) > (8740 - 4925))) then
					if (((4533 - (138 + 930)) > (1749 + 164)) and (v51 == "cursor")) then
						if (((574 + 159) < (1559 + 260)) and v24(v102.EarthquakeCursor, not v16:IsInRange(163 - 123))) then
							return "earthquake aoe 46";
						end
					end
					if ((v51 == "player") or ((6161 - (459 + 1307)) == (6625 - (474 + 1396)))) then
						if (v24(v102.EarthquakePlayer, not v16:IsInRange(69 - 29)) or ((3555 + 238) < (8 + 2361))) then
							return "earthquake aoe 46";
						end
					end
					break;
				end
			end
		end
		if ((v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v114 == (8 - 5)) and ((v114 == (1 + 2)) or (v113 == (9 - 6)))) or ((17810 - 13726) == (856 - (562 + 29)))) then
			if (((3716 + 642) == (5777 - (374 + 1045))) and (v51 == "cursor")) then
				if (v24(v102.EarthquakeCursor, not v16:IsInRange(32 + 8)) or ((9744 - 6606) < (1631 - (448 + 190)))) then
					return "earthquake aoe 48";
				end
			end
			if (((1076 + 2254) > (1049 + 1274)) and (v51 == "player")) then
				if (v24(v102.EarthquakePlayer, not v16:IsInRange(27 + 13)) or ((13941 - 10315) == (12394 - 8405))) then
					return "earthquake aoe 48";
				end
			end
		end
		if ((v37 and v100.Earthquake:IsReady() and (v13:BuffUp(v100.EchoesofGreatSunderingBuff))) or ((2410 - (1307 + 187)) == (10591 - 7920))) then
			local v197 = 0 - 0;
			while true do
				if (((833 - 561) == (955 - (232 + 451))) and (v197 == (0 + 0))) then
					if (((3754 + 495) <= (5403 - (510 + 54))) and (v51 == "cursor")) then
						if (((5594 - 2817) < (3236 - (13 + 23))) and v24(v102.EarthquakeCursor, not v16:IsInRange(77 - 37))) then
							return "earthquake aoe 50";
						end
					end
					if (((136 - 41) < (3555 - 1598)) and (v51 == "player")) then
						if (((1914 - (830 + 258)) < (6056 - 4339)) and v24(v102.EarthquakePlayer, not v16:IsInRange(26 + 14))) then
							return "earthquake aoe 50";
						end
					end
					break;
				end
			end
		end
		if (((1214 + 212) >= (2546 - (860 + 581))) and v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) then
			if (((10158 - 7404) <= (2682 + 697)) and v104.CastTargetIf(v100.ElementalBlast, v112, "min", v124, nil, not v16:IsSpellInRange(v100.ElementalBlast), nil, nil)) then
				return "elemental_blast aoe 52";
			end
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((4168 - (237 + 4)) == (3320 - 1907))) then
				return "elemental_blast aoe 52";
			end
		end
		if ((v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) or ((2919 - 1765) <= (1493 - 705))) then
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((1345 + 298) > (1941 + 1438))) then
				return "elemental_blast aoe 54";
			end
		end
		if ((v126(v100.ElementalBlast) and v39 and (v114 == (11 - 8)) and not v100.EchoesofGreatSundering:IsAvailable()) or ((1203 + 1600) > (2475 + 2074))) then
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((1646 - (85 + 1341)) >= (5156 - 2134))) then
				return "elemental_blast aoe 56";
			end
		end
		if (((7969 - 5147) == (3194 - (45 + 327))) and v126(v100.EarthShock) and v38 and v100.EchoesofGreatSundering:IsAvailable()) then
			local v198 = 0 - 0;
			while true do
				if ((v198 == (502 - (444 + 58))) or ((462 + 599) == (320 + 1537))) then
					if (((1350 + 1410) > (3952 - 2588)) and v104.CastTargetIf(v100.EarthShock, v112, "min", v124, nil, not v16:IsSpellInRange(v100.EarthShock), nil, nil)) then
						return "earth_shock aoe 58";
					end
					if (v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock)) or ((6634 - (64 + 1668)) <= (5568 - (1227 + 746)))) then
						return "earth_shock aoe 58";
					end
					break;
				end
			end
		end
		if ((v126(v100.EarthShock) and v38 and v100.EchoesofGreatSundering:IsAvailable()) or ((11839 - 7987) == (543 - 250))) then
			if (v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock)) or ((2053 - (415 + 79)) == (118 + 4470))) then
				return "earth_shock aoe 60";
			end
		end
		if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (491 - (142 + 349))) and v42 and not v13:BuffUp(v100.AscendanceBuff) and v100.ElectrifiedShocks:IsAvailable() and ((v100.LightningRod:IsAvailable() and (v114 < (3 + 2)) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (3 - 0))))) or ((2229 + 2255) == (556 + 232))) then
			if (((12440 - 7872) >= (5771 - (1710 + 154))) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury aoe 62";
			end
		end
		if (((1564 - (200 + 118)) < (1375 + 2095)) and v126(v100.FrostShock) and v41 and not v13:BuffUp(v100.AscendanceBuff) and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and (not v16:DebuffUp(v100.ElectrifiedShocksDebuff) or (v13:BuffRemains(v100.IcefuryBuff) < v13:GCD())) and ((v100.LightningRod:IsAvailable() and (v114 < (8 - 3)) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (4 - 1))))) then
			if (((3615 + 453) >= (962 + 10)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock aoe 64";
			end
		end
		if (((265 + 228) < (622 + 3271)) and v126(v100.LavaBurst) and v100.MasteroftheElements:IsAvailable() and not v127() and (v129() or ((v118() < (6 - 3)) and v13:HasTier(1280 - (363 + 887), 2 - 0))) and (v125() < ((((285 - 225) - ((1 + 4) * v100.EyeoftheStorm:TalentRank())) - ((4 - 2) * v25(v100.FlowofPower:IsAvailable()))) - (7 + 3))) and (v114 < (1669 - (674 + 990)))) then
			local v199 = 0 + 0;
			while true do
				if ((v199 == (0 + 0)) or ((2334 - 861) >= (4387 - (507 + 548)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((4888 - (289 + 548)) <= (2975 - (821 + 997)))) then
						return "lava_burst aoe 66";
					end
					if (((859 - (195 + 60)) < (775 + 2106)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 66";
					end
					break;
				end
			end
		end
		if ((v126(v100.LavaBeam) and v43 and (v129())) or ((2401 - (251 + 1250)) == (9893 - 6516))) then
			if (((3064 + 1395) > (1623 - (809 + 223))) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 68";
			end
		end
		if (((4958 - 1560) >= (7192 - 4797)) and v126(v100.ChainLightning) and v36 and (v129())) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((7217 - 5034) >= (2080 + 744))) then
				return "chain_lightning aoe 70";
			end
		end
		if (((1014 + 922) == (2553 - (14 + 603))) and v126(v100.LavaBeam) and v43 and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((4961 - (118 + 11)) < (698 + 3615))) then
				return "lava_beam aoe 72";
			end
		end
		if (((3405 + 683) > (11289 - 7415)) and v126(v100.ChainLightning) and v36 and v128()) then
			if (((5281 - (551 + 398)) == (2738 + 1594)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
				return "chain_lightning aoe 74";
			end
		end
		if (((1424 + 2575) >= (2357 + 543)) and v126(v100.LavaBeam) and v43 and (v114 >= (22 - 16)) and v13:BuffUp(v100.SurgeofPowerBuff) and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((5817 - 3292) > (1318 + 2746))) then
				return "lava_beam aoe 76";
			end
		end
		if (((17352 - 12981) == (1207 + 3164)) and v126(v100.ChainLightning) and v36 and (v114 >= (95 - (40 + 49))) and v13:BuffUp(v100.SurgeofPowerBuff)) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((1012 - 746) > (5476 - (99 + 391)))) then
				return "chain_lightning aoe 78";
			end
		end
		if (((1647 + 344) >= (4066 - 3141)) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff)) then
			if (((1126 - 671) < (2000 + 53)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst aoe 80";
			end
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((2173 - 1347) == (6455 - (1032 + 572)))) then
				return "lava_burst aoe 80";
			end
		end
		if (((600 - (203 + 214)) == (2000 - (568 + 1249))) and v126(v100.LavaBeam) and v43 and v127() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
			if (((907 + 252) <= (4294 - 2506)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 82";
			end
		end
		if ((v126(v100.LavaBurst) and (v114 == (11 - 8)) and v100.MasteroftheElements:IsAvailable()) or ((4813 - (913 + 393)) > (12193 - 7875))) then
			local v200 = 0 - 0;
			while true do
				if ((v200 == (410 - (269 + 141))) or ((6839 - 3764) <= (4946 - (362 + 1619)))) then
					if (((2990 - (950 + 675)) <= (776 + 1235)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 84";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((3955 - (216 + 963)) > (4862 - (485 + 802)))) then
						return "lava_burst aoe 84";
					end
					break;
				end
			end
		end
		if ((v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable()) or ((3113 - (432 + 127)) == (5877 - (1065 + 8)))) then
			local v201 = 0 + 0;
			while true do
				if (((4178 - (635 + 966)) == (1853 + 724)) and (v201 == (42 - (5 + 37)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((14 - 8) >= (786 + 1103))) then
						return "lava_burst aoe 86";
					end
					if (((800 - 294) <= (886 + 1006)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 86";
					end
					break;
				end
			end
		end
		if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 - 0)) and v42 and v100.ElectrifiedShocks:IsAvailable() and (v114 < (18 - 13))) or ((3786 - 1778) > (5303 - 3085))) then
			if (((273 + 106) <= (4676 - (318 + 211))) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury aoe 88";
			end
		end
		if ((v126(v100.FrostShock) and v41 and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and not v16:DebuffUp(v100.ElectrifiedShocksDebuff) and (v114 < (24 - 19)) and v100.UnrelentingCalamity:IsAvailable()) or ((6101 - (963 + 624)) <= (432 + 577))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((4342 - (518 + 328)) == (2778 - 1586))) then
				return "frost_shock aoe 90";
			end
		end
		if ((v126(v100.LavaBeam) and v43 and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((332 - 124) == (3276 - (301 + 16)))) then
			if (((12535 - 8258) >= (3687 - 2374)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam aoe 92";
			end
		end
		if (((6750 - 4163) < (2875 + 299)) and v126(v100.ChainLightning) and v36) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((2340 + 1780) <= (4692 - 2494))) then
				return "chain_lightning aoe 94";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and v13:IsMoving() and v16:DebuffRefreshable(v100.FlameShockDebuff)) or ((961 + 635) == (82 + 776))) then
			if (((10237 - 7017) == (1040 + 2180)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock aoe 96";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v13:IsMoving()) or ((2421 - (829 + 190)) > (12915 - 9295))) then
			if (((3256 - 682) == (3558 - 984)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock aoe 98";
			end
		end
	end
	local function v138()
		local v168 = 0 - 0;
		while true do
			if (((427 + 1371) < (901 + 1856)) and (v168 == (21 - 14))) then
				if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (v127() or v100.LightningRod:IsAvailable())) or ((356 + 21) > (3217 - (520 + 93)))) then
					if (((844 - (259 + 17)) < (53 + 858)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast single_target 72";
					end
				end
				if (((1183 + 2102) < (14313 - 10085)) and v100.EarthShock:IsReady() and v38) then
					if (((4507 - (396 + 195)) > (9655 - 6327)) and v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock))) then
						return "earth_shock single_target 74";
					end
				end
				if (((4261 - (440 + 1321)) < (5668 - (1059 + 770))) and v126(v100.FrostShock) and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and v127() and not v100.LightningRod:IsAvailable() and (v113 > (4 - 3)) and (v114 > (546 - (424 + 121)))) then
					if (((93 + 414) == (1854 - (641 + 706))) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 76";
					end
				end
				if (((96 + 144) <= (3605 - (249 + 191))) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.DeeplyRootedElements:IsAvailable())) then
					local v250 = 0 - 0;
					while true do
						if (((373 + 461) >= (3102 - 2297)) and (v250 == (427 - (183 + 244)))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((188 + 3624) < (3046 - (434 + 296)))) then
								return "lava_burst single_target 78";
							end
							if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((8462 - 5810) <= (2045 - (169 + 343)))) then
								return "lava_burst single_target 78";
							end
							break;
						end
					end
				end
				if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.FluxMelting:IsAvailable() and v13:BuffDown(v100.FluxMeltingBuff)) or ((3155 + 443) < (2568 - 1108))) then
					if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((12081 - 7965) < (977 + 215))) then
						return "frost_shock single_target 80";
					end
				end
				v168 = 22 - 14;
			end
			if ((v168 == (1128 - (651 + 472))) or ((2553 + 824) <= (390 + 513))) then
				if (((4852 - 876) >= (922 - (397 + 86))) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or ((v125() >= (939 - (423 + 453))) and v100.MasteroftheElements:IsAvailable()) or ((v125() >= (4 + 34)) and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and (v113 > (1 + 0)) and (v114 > (1 + 0))) or not v100.ElementalBlast:IsAvailable())) then
					if (((2995 + 757) == (3352 + 400)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 52";
					end
				end
				if (((5236 - (50 + 1140)) > (2330 + 365)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.LavaSurgeBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or not v100.ElementalBlast:IsAvailable())) then
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((2094 + 1451) == (199 + 2998))) then
						return "lava_burst single_target 54";
					end
				end
				if (((3437 - 1043) > (270 + 103)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.AscendanceBuff) and (v13:HasTier(627 - (157 + 439), 6 - 2) or not v100.ElementalBlast:IsAvailable())) then
					if (((13806 - 9651) <= (12517 - 8285)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 56";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((4499 - (782 + 136)) == (4328 - (112 + 743)))) then
						return "lava_burst single_target 56";
					end
				end
				if (((6166 - (1026 + 145)) > (575 + 2773)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffDown(v100.AscendanceBuff) and (not v100.ElementalBlast:IsAvailable() or not v100.MountainsWillFall:IsAvailable()) and not v100.LightningRod:IsAvailable() and v13:HasTier(749 - (493 + 225), 14 - 10)) then
					local v251 = 0 + 0;
					while true do
						if (((0 - 0) == v251) or ((15 + 739) > (10642 - 6918))) then
							if (((64 + 153) >= (95 - 38)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst single_target 58";
							end
							if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((3665 - (210 + 1385)) >= (5726 - (1201 + 488)))) then
								return "lava_burst single_target 58";
							end
							break;
						end
					end
				end
				if (((1677 + 1028) == (4810 - 2105)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and not v100.LightningRod:IsAvailable()) then
					if (((109 - 48) == (646 - (352 + 233))) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 60";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1689 - 990) >= (706 + 590))) then
						return "lava_burst single_target 60";
					end
				end
				v168 = 17 - 11;
			end
			if ((v168 == (584 - (489 + 85))) or ((3284 - (277 + 1224)) >= (5109 - (663 + 830)))) then
				if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable() and (v113 > (2 - 1)) and (v114 > (876 - (461 + 414)))) or ((656 + 3257) > (1812 + 2715))) then
					if (((417 + 3959) > (806 + 11)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning single_target 102";
					end
				end
				if (((5111 - (172 + 78)) > (1328 - 504)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable()) then
					if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((1995 - 612) >= (582 + 1549))) then
						return "lightning_bolt single_target 104";
					end
				end
				if ((v100.FrostShock:IsCastable() and v41 and v130() and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable()) or ((627 + 1249) >= (4257 - 1716))) then
					if (((2242 - 460) <= (949 + 2823)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 106";
					end
				end
				if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (1 + 0)) and (v114 > (1 + 0))) or ((18709 - 14009) < (1894 - 1081))) then
					if (((981 + 2218) < (2313 + 1737)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning single_target 108";
					end
				end
				if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45) or ((5398 - (133 + 314)) < (771 + 3659))) then
					if (((309 - (199 + 14)) == (343 - 247)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt single_target 110";
					end
				end
				v168 = 1560 - (647 + 902);
			end
			if ((v168 == (0 - 0)) or ((2972 - (85 + 148)) > (5297 - (426 + 863)))) then
				if ((v100.FireElemental:IsCastable() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) or ((107 - 84) == (2788 - (873 + 781)))) then
					if (v24(v100.FireElemental) or ((3605 - 912) >= (11102 - 6991))) then
						return "fire_elemental single_target 2";
					end
				end
				if ((v100.StormElemental:IsCastable() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) or ((1789 + 2527) <= (7927 - 5781))) then
					if (v24(v100.StormElemental) or ((5081 - 1535) <= (8340 - 5531))) then
						return "storm_elemental single_target 4";
					end
				end
				if (((6851 - (414 + 1533)) > (1878 + 288)) and v100.TotemicRecall:IsCastable() and v49 and (v100.LiquidMagmaTotem:CooldownRemains() > (600 - (443 + 112))) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or ((v113 > (1480 - (888 + 591))) and (v114 > (2 - 1))))) then
					if (((7 + 102) >= (338 - 248)) and v24(v100.TotemicRecall)) then
						return "totemic_recall single_target 6";
					end
				end
				if (((1944 + 3034) > (1406 + 1499)) and v100.LiquidMagmaTotem:IsCastable() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (0 + 0)) or (v16:DebuffRemains(v100.FlameShockDebuff) < (11 - 5)) or ((v113 > (1 - 0)) and (v114 > (1679 - (136 + 1542)))))) then
					local v252 = 0 - 0;
					while true do
						if ((v252 == (0 + 0)) or ((4811 - 1785) <= (1651 + 629))) then
							if ((v66 == "cursor") or ((2139 - (68 + 418)) <= (3003 - 1895))) then
								if (((5277 - 2368) > (2253 + 356)) and v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(1132 - (770 + 322)))) then
									return "liquid_magma_totem single_target cursor 8";
								end
							end
							if (((44 + 713) > (57 + 137)) and (v66 == "player")) then
								if (v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(6 + 34)) or ((44 - 13) >= (2710 - 1312))) then
									return "liquid_magma_totem single_target player 8";
								end
							end
							break;
						end
					end
				end
				if (((8704 - 5508) <= (17920 - 13048)) and v126(v100.PrimordialWave) and v100.PrimordialWave:IsCastable() and v47 and ((v64 and v34) or not v64) and not v13:BuffUp(v100.PrimordialWaveBuff) and not v13:BuffUp(v100.SplinteredElementsBuff)) then
					if (((1853 + 1473) == (4983 - 1657)) and v104.CastCycle(v100.PrimordialWave, v112, v122, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave single_target 10";
					end
					if (((688 + 745) <= (2378 + 1500)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave single_target 10";
					end
				end
				v168 = 1 + 0;
			end
			if ((v168 == (7 - 5)) or ((2198 - 615) == (587 + 1148))) then
				if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (not v100.SurgeofPower:IsAvailable() or not v100.ElementalBlast:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.EchooftheElements:IsAvailable() or v100.PrimordialSurge:IsAvailable())) or ((9854 - 6873) == (967 + 1383))) then
					if (v24(v100.Stormkeeper) or ((22099 - 17633) <= (1324 - (762 + 69)))) then
						return "stormkeeper single_target 22";
					end
				end
				if ((v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108) and not v129()) or ((8247 - 5700) <= (1712 + 275))) then
					if (((1918 + 1043) > (6627 - 3887)) and v24(v100.Ascendance)) then
						return "ascendance single_target 24";
					end
				end
				if (((1163 + 2533) >= (58 + 3554)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and v13:BuffUp(v100.SurgeofPowerBuff)) then
					if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((11571 - 8601) == (2035 - (8 + 149)))) then
						return "lightning_bolt single_target 26";
					end
				end
				if ((v126(v100.LavaBeam) and v43 and (v113 > (1321 - (1199 + 121))) and (v114 > (1 - 0)) and v129() and not v100.SurgeofPower:IsAvailable()) or ((8337 - 4644) < (814 + 1163))) then
					if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((3319 - 2389) > (4875 - 2774))) then
						return "lava_beam single_target 28";
					end
				end
				if (((3675 + 478) > (4893 - (518 + 1289))) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (1 - 0)) and (v114 > (1 + 0)) and v129() and not v100.SurgeofPower:IsAvailable()) then
					if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((6797 - 2143) <= (2983 + 1067))) then
						return "chain_lightning single_target 30";
					end
				end
				v168 = 472 - (304 + 165);
			end
			if ((v168 == (6 + 0)) or ((2762 - (54 + 106)) < (3465 - (1618 + 351)))) then
				if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and ((v125() >= (53 + 22)) or ((v125() >= (1066 - (10 + 1006))) and not v100.ElementalBlast:IsAvailable())) and v100.SwellingMaelstrom:IsAvailable() and (v125() <= (33 + 97))) or ((143 + 877) > (7417 - 5129))) then
					if (((1361 - (912 + 121)) == (155 + 173)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 62";
					end
				end
				if (((2800 - (1140 + 149)) < (2437 + 1371)) and v100.Earthquake:IsReady() and v37 and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (2 - 0))) or (v113 > (1 + 0)))) then
					local v253 = 0 - 0;
					while true do
						if ((v253 == (0 - 0)) or ((433 + 2077) > (17069 - 12150))) then
							if (((4949 - (165 + 21)) == (4874 - (61 + 50))) and (v51 == "cursor")) then
								if (((1705 + 2432) > (8808 - 6960)) and v24(v102.EarthquakeCursor, not v16:IsInRange(80 - 40))) then
									return "earthquake single_target 64";
								end
							end
							if (((958 + 1478) <= (4594 - (1295 + 165))) and (v51 == "player")) then
								if (((850 + 2873) == (1497 + 2226)) and v24(v102.EarthquakePlayer, not v16:IsInRange(1437 - (819 + 578)))) then
									return "earthquake single_target 64";
								end
							end
							break;
						end
					end
				end
				if ((v100.Earthquake:IsReady() and v37 and (v113 > (1403 - (331 + 1071))) and (v114 > (744 - (588 + 155))) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) or ((5328 - (546 + 736)) >= (6253 - (1834 + 103)))) then
					if ((v51 == "cursor") or ((1236 + 772) < (5754 - 3825))) then
						if (((4150 - (1536 + 230)) > (2266 - (128 + 363))) and v24(v102.EarthquakeCursor, not v16:IsInRange(9 + 31))) then
							return "earthquake single_target 66";
						end
					end
					if ((v51 == "player") or ((11302 - 6759) <= (1131 + 3245))) then
						if (((1205 - 477) == (2143 - 1415)) and v24(v102.EarthquakePlayer, not v16:IsInRange(97 - 57))) then
							return "earthquake single_target 66";
						end
					end
				end
				if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (not v100.MasteroftheElements:IsAvailable() or (v127() and v16:DebuffUp(v100.ElectrifiedShocksDebuff)))) or ((739 + 337) > (5680 - (615 + 394)))) then
					if (((1672 + 179) >= (361 + 17)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast single_target 68";
					end
				end
				if ((v126(v100.FrostShock) and v41 and v130() and v127() and (v125() < (335 - 225)) and (v100.LavaBurst:ChargesFractional() < (4 - 3)) and v100.ElectrifiedShocks:IsAvailable() and v100.ElementalBlast:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((2599 - (59 + 592)) >= (7695 - 4219))) then
					if (((8828 - 4034) >= (588 + 245)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 70";
					end
				end
				v168 = 178 - (70 + 101);
			end
			if (((10110 - 6020) == (2901 + 1189)) and (v168 == (27 - 16))) then
				if ((v100.FlameShock:IsCastable() and v40 and (v13:IsMoving())) or ((3999 - (123 + 118)) == (605 + 1893))) then
					local v254 = 0 + 0;
					while true do
						if ((v254 == (1399 - (653 + 746))) or ((4998 - 2325) < (2269 - 694))) then
							if (v104.CastCycle(v100.FlameShock, v112, v119, not v16:IsSpellInRange(v100.FlameShock)) or ((9962 - 6241) <= (642 + 813))) then
								return "flame_shock single_target 112";
							end
							if (((598 + 336) < (1983 + 287)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
								return "flame_shock single_target 112";
							end
							break;
						end
					end
				end
				if ((v100.FlameShock:IsCastable() and v40) or ((198 + 1414) == (196 + 1059))) then
					if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((10668 - 6316) < (4004 + 202))) then
						return "flame_shock single_target 114";
					end
				end
				if ((v100.FrostShock:IsCastable() and v41) or ((5283 - 2423) <= (1415 - (885 + 349)))) then
					if (((2559 + 663) >= (4163 - 2636)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 116";
					end
				end
				break;
			end
			if (((4377 - 2872) <= (3089 - (915 + 53))) and (v168 == (804 - (768 + 33)))) then
				if (((2848 - 2104) == (1309 - 565)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v129() and not v127() and not v100.SurgeofPower:IsAvailable() and v100.MasteroftheElements:IsAvailable()) then
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((2307 - (287 + 41)) >= (3683 - (638 + 209)))) then
						return "lava_burst single_target 32";
					end
				end
				if (((953 + 880) <= (4354 - (96 + 1590))) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and v127()) then
					if (((5358 - (741 + 931)) == (1811 + 1875)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt single_target 34";
					end
				end
				if (((9877 - 6410) > (2228 - 1751)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and not v100.MasteroftheElements:IsAvailable()) then
					if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((1411 + 1877) >= (1522 + 2019))) then
						return "lightning_bolt single_target 36";
					end
				end
				if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v13:BuffUp(v100.SurgeofPowerBuff) and v100.LightningRod:IsAvailable()) or ((1134 + 2423) == (17228 - 12688))) then
					if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((85 + 176) > (619 + 648))) then
						return "lightning_bolt single_target 38";
					end
				end
				if (((5188 - 3916) < (3463 + 395)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (494 - (64 + 430))) and v42 and v100.ElectrifiedShocks:IsAvailable() and v100.LightningRod:IsAvailable() and v100.LightningRod:IsAvailable()) then
					if (((3636 + 28) == (4027 - (106 + 257))) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
						return "icefury single_target 40";
					end
				end
				v168 = 3 + 1;
			end
			if (((2662 - (496 + 225)) >= (920 - 470)) and (v168 == (43 - 34))) then
				if ((v126(v100.Icefury) and v100.Icefury:IsCastable() and v42) or ((6304 - (256 + 1402)) < (2223 - (30 + 1869)))) then
					if (((5202 - (213 + 1156)) == (4021 - (96 + 92))) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
						return "icefury single_target 92";
					end
				end
				if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128()) and (v113 > (1 + 0)) and (v114 > (900 - (142 + 757)))) or ((1011 + 229) > (1378 + 1992))) then
					if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((2560 - (32 + 47)) == (6659 - (1053 + 924)))) then
						return "chain_lightning single_target 94";
					end
				end
				if (((4631 + 96) >= (358 - 150)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128())) then
					if (((1928 - (685 + 963)) < (7830 - 3979)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt single_target 96";
					end
				end
				if ((v100.FrostShock:IsCastable() and v41 and v130() and v127() and v13:BuffDown(v100.LavaSurgeBuff) and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable() and (v100.LavaBurst:ChargesFractional() < (1 - 0)) and v100.EchooftheElements:IsAvailable()) or ((4716 - (541 + 1168)) > (4791 - (645 + 952)))) then
					if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((2974 - (669 + 169)) >= (10204 - 7258))) then
						return "frost_shock single_target 98";
					end
				end
				if (((4701 - 2536) <= (852 + 1669)) and v100.FrostShock:IsCastable() and v41 and v130() and (v100.FluxMelting:IsAvailable() or (v100.ElectrifiedShocks:IsAvailable() and not v100.LightningRod:IsAvailable()))) then
					if (((632 + 2229) > (1426 - (181 + 584))) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 100";
					end
				end
				v168 = 1405 - (665 + 730);
			end
			if (((13041 - 8516) > (9215 - 4696)) and (v168 == (1351 - (540 + 810)))) then
				if (((12705 - 9527) > (2672 - 1700)) and v100.FlameShock:IsCastable() and v40 and (v113 == (1 + 0)) and v16:DebuffRefreshable(v100.FlameShockDebuff) and ((v16:DebuffRemains(v100.FlameShockDebuff) < v100.PrimordialWave:CooldownRemains()) or not v100.PrimordialWave:IsAvailable()) and v13:BuffDown(v100.SurgeofPowerBuff) and (not v127() or (not v129() and ((v100.ElementalBlast:IsAvailable() and (v125() < ((293 - (166 + 37)) - ((1889 - (22 + 1859)) * v100.EyeoftheStorm:TalentRank())))) or (v125() < ((1832 - (843 + 929)) - ((267 - (30 + 232)) * v100.EyeoftheStorm:TalentRank()))))))) then
					if (((13612 - 8846) == (5543 - (55 + 722))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 12";
					end
				end
				if ((v100.FlameShock:IsCastable() and v40 and (v100.FlameShockDebuff:AuraActiveCount() == (0 - 0)) and (v113 > (1676 - (78 + 1597))) and (v114 > (1 + 0)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((not v127() and (v129() or (v100.Stormkeeper:CooldownRemains() > (0 + 0)))) or not v100.SurgeofPower:IsAvailable())) or ((2298 + 447) > (3677 - (305 + 244)))) then
					if (v104.CastTargetIf(v100.FlameShock, v112, "min", v122, nil, not v16:IsSpellInRange(v100.FlameShock)) or ((1062 + 82) >= (4711 - (95 + 10)))) then
						return "flame_shock single_target 14";
					end
					if (((2364 + 974) >= (877 - 600)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 14";
					end
				end
				if (((3570 - 960) > (3322 - (592 + 170))) and v100.FlameShock:IsCastable() and v40 and (v113 > (3 - 2)) and (v114 > (2 - 1)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v100.SurgeofPowerBuff) and not v129() and v100.Stormkeeper:IsAvailable()) or not v100.SurgeofPower:IsAvailable())) then
					local v255 = 0 + 0;
					while true do
						if (((0 + 0) == v255) or ((2883 - 1689) > (501 + 2582))) then
							if (((1697 - 781) >= (1254 - (353 + 154))) and v104.CastTargetIf(v100.FlameShock, v112, "min", v122, v119, not v16:IsSpellInRange(v100.FlameShock))) then
								return "flame_shock single_target 16";
							end
							if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((3252 - 808) > (4035 - 1081))) then
								return "flame_shock single_target 16";
							end
							break;
						end
					end
				end
				if (((1996 + 896) < (2752 + 762)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (v125() >= (166 - 50)) and v100.ElementalBlast:IsAvailable() and v100.SurgeofPower:IsAvailable() and v100.SwellingMaelstrom:IsAvailable() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
					if (((1008 - 475) == (1242 - 709)) and v24(v100.Stormkeeper)) then
						return "stormkeeper single_target 18";
					end
				end
				if (((681 - (7 + 79)) <= (1597 + 1816)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (181 - (24 + 157))) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and v13:BuffUp(v100.SurgeofPowerBuff) and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
					if (((6142 - 3064) >= (5527 - 2936)) and v24(v100.Stormkeeper)) then
						return "stormkeeper single_target 20";
					end
				end
				v168 = 1 + 1;
			end
			if (((8617 - 5418) < (4410 - (262 + 118))) and (v168 == (1087 - (1038 + 45)))) then
				if (((1680 - 903) < (2308 - (19 + 211))) and v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (115 - (88 + 25))) or (v13:BuffRemains(v100.IcefuryBuff) <= v13:GCD())) and v100.LightningRod:IsAvailable()) then
					if (((4318 - 2622) <= (1133 + 1149)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 42";
					end
				end
				if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and (v125() >= (47 + 3)) and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < ((1038 - (1007 + 29)) * v13:GCD())) and v129() and v100.LightningRod:IsAvailable()) or ((475 + 1286) >= (6017 - 3555))) then
					if (((21524 - 16973) > (519 + 1809)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 44";
					end
				end
				if (((4636 - (340 + 471)) >= (1176 - 709)) and v100.LavaBeam:IsCastable() and v43 and (v113 > (590 - (276 + 313))) and (v114 > (2 - 1)) and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime()) and not v13:HasTier(29 + 2, 2 + 2)) then
					if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((271 + 2619) == (2529 - (495 + 1477)))) then
						return "lava_beam single_target 46";
					end
				end
				if ((v100.FrostShock:IsCastable() and v41 and v130() and v129() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable() and v100.ElementalBlast:IsAvailable() and (((v125() >= (182 - 121)) and (v125() < (50 + 25)) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (452 - (342 + 61))) and (v125() < (28 + 35)) and (v100.LavaBurst:CooldownRemains() > (165 - (4 + 161)))))) or ((2921 + 1849) == (9115 - 6211))) then
					if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((10258 - 6355) == (5033 - (322 + 175)))) then
						return "frost_shock single_target 48";
					end
				end
				if (((4656 - (173 + 390)) <= (1195 + 3650)) and v100.FrostShock:IsCastable() and v41 and v130() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (((v125() >= (350 - (203 + 111))) and (v125() < (4 + 46)) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (17 + 7)) and (v125() < (110 - 72)) and (v100.LavaBurst:CooldownRemains() > (0 + 0))))) then
					if (((2275 - (57 + 649)) <= (4031 - (328 + 56))) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 50";
					end
				end
				v168 = 2 + 3;
			end
			if ((v168 == (520 - (433 + 79))) or ((371 + 3675) >= (3978 + 949))) then
				if (((15545 - 10922) >= (13179 - 10392)) and v100.FrostShock:IsCastable() and v41 and v130() and ((v100.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (2 + 0))) or (v13:BuffRemains(v100.IcefuryBuff) < (6 + 0)))) then
					if (((3270 - (562 + 474)) >= (2869 - 1639)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock single_target 82";
					end
				end
				if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.ElementalBlast:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or v129())) or ((698 - 355) == (2691 - (76 + 829)))) then
					local v256 = 1673 - (1506 + 167);
					while true do
						if (((4827 - 2257) > (2675 - (58 + 208))) and (v256 == (0 + 0))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((1860 + 749) >= (1859 + 1375))) then
								return "lava_burst single_target 84";
							end
							if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((12373 - 9340) >= (4368 - (258 + 79)))) then
								return "lava_burst single_target 84";
							end
							break;
						end
					end
				end
				if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39) or ((178 + 1223) == (9820 - 5152))) then
					if (((4246 - (1219 + 251)) >= (2992 - (1231 + 440))) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast single_target 86";
					end
				end
				if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v128() and v100.UnrelentingCalamity:IsAvailable() and (v113 > (59 - (34 + 24))) and (v114 > (1 + 0))) or ((909 - 422) > (1007 + 1296))) then
					if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((13676 - 9173) == (11098 - 7636))) then
						return "chain_lightning single_target 88";
					end
				end
				if (((1453 - 900) <= (5169 - 3626)) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v128() and v100.UnrelentingCalamity:IsAvailable()) then
					if (((4399 - 2384) == (3604 - (877 + 712))) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
						return "lightning_bolt single_target 90";
					end
				end
				v168 = 6 + 3;
			end
		end
	end
	local function v139()
		if ((v73 and v100.EarthShield:IsCastable() and v13:BuffDown(v100.EarthShieldBuff) and ((v74 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.LightningShield)))) or ((4995 - (242 + 512)) <= (4873 - 2541))) then
			if (v24(v100.EarthShield) or ((2991 - (92 + 535)) < (911 + 246))) then
				return "earth_shield main 2";
			end
		elseif ((v73 and v100.LightningShield:IsCastable() and v13:BuffDown(v100.LightningShieldBuff) and ((v74 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.EarthShield)))) or ((2403 - 1236) > (80 + 1198))) then
			if (v24(v100.LightningShield) or ((4161 - 3016) <= (1061 + 21))) then
				return "lightning_shield main 2";
			end
		end
		v30 = v133();
		if (v30 or ((2150 + 955) == (685 + 4196))) then
			return v30;
		end
		if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((3760 - 1873) > (7434 - 2556))) then
			if (v24(v100.AncestralSpirit, nil, true) or ((5872 - (1476 + 309)) > (5400 - (299 + 985)))) then
				return "ancestral_spirit";
			end
		end
		if (((263 + 843) <= (4149 - 2883)) and v100.AncestralSpirit:IsCastable() and v100.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) then
			if (((3248 - (86 + 7)) < (19003 - 14353)) and v24(v102.AncestralSpiritMouseover)) then
				return "ancestral_spirit mouseover";
			end
		end
		v109, v110 = v29();
		if (((359 + 3415) >= (2719 - (672 + 208))) and v100.ImprovedFlametongueWeapon:IsAvailable() and v100.FlametongueWeapon:IsCastable() and v50 and (not v109 or (v110 < (257135 + 342865))) and v100.FlametongueWeapon:IsAvailable()) then
			if (((2943 - (14 + 118)) == (3256 - (339 + 106))) and v24(v100.FlametongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if (((1708 + 438) > (565 + 557)) and not v13:AffectingCombat() and v31 and v104.TargetIsValid()) then
			local v202 = 1395 - (440 + 955);
			while true do
				if ((v202 == (0 + 0)) or ((100 - 44) == (1200 + 2416))) then
					v30 = v136();
					if (v30 or ((6027 - 3606) < (427 + 195))) then
						return v30;
					end
					break;
				end
			end
		end
	end
	local function v140()
		local v169 = 353 - (260 + 93);
		while true do
			if (((946 + 63) <= (2584 - 1454)) and (v169 == (1 - 0))) then
				if (((4732 - (1181 + 793)) < (759 + 2221)) and v85) then
					if (v80 or ((393 - (105 + 202)) >= (2907 + 719))) then
						v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 850 - (352 + 458));
						if (((9656 - 7261) == (6122 - 3727)) and v30) then
							return v30;
						end
					end
					if (((3660 + 120) > (7918 - 5209)) and v81) then
						v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 979 - (438 + 511));
						if (v30 or ((1620 - (1262 + 121)) >= (3341 - (728 + 340)))) then
							return v30;
						end
					end
					if (v82 or ((3830 - (816 + 974)) <= (2153 - 1450))) then
						v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 107 - 77);
						if (((3618 - (163 + 176)) <= (11292 - 7325)) and v30) then
							return v30;
						end
					end
				end
				if (v86 or ((9136 - 7148) == (265 + 612))) then
					local v257 = 1810 - (1564 + 246);
					while true do
						if (((4636 - (124 + 221)) > (1307 + 605)) and (v257 == (451 - (115 + 336)))) then
							v30 = v104.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 66 - 36, true);
							if (((413 + 1590) < (2385 - (45 + 1))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				v169 = 1 + 1;
			end
			if (((2422 - (1282 + 708)) == (1644 - (583 + 629))) and (v169 == (0 + 0))) then
				v30 = v134();
				if (v30 or ((2961 - 1816) >= (657 + 596))) then
					return v30;
				end
				v169 = 1171 - (943 + 227);
			end
			if (((1495 + 1923) > (3749 - (1539 + 92))) and (v169 == (1948 - (706 + 1240)))) then
				if (((3324 - (81 + 177)) <= (10990 - 7100)) and v17) then
					if (v84 or ((3255 - (212 + 45)) >= (10975 - 7694))) then
						v30 = v132();
						if (v30 or ((6595 - (708 + 1238)) <= (219 + 2413))) then
							return v30;
						end
					end
				end
				if ((v100.GreaterPurge:IsAvailable() and v97 and v100.GreaterPurge:IsReady() and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) or ((1263 + 2597) > (6539 - (586 + 1081)))) then
					if (v24(v100.GreaterPurge, not v16:IsSpellInRange(v100.GreaterPurge)) or ((4509 - (348 + 163)) == (2064 + 234))) then
						return "greater_purge damage";
					end
				end
				v169 = 283 - (215 + 65);
			end
			if (((7 - 4) == v169) or ((1867 - (1541 + 318)) >= (2430 + 309))) then
				if (((1310 + 1280) == (1952 + 638)) and v100.Purge:IsReady() and v97 and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) then
					if (v24(v100.Purge, not v16:IsSpellInRange(v100.Purge)) or ((1832 - (1036 + 714)) >= (1233 + 637))) then
						return "purge damage";
					end
				end
				if (((1450 + 1174) < (5837 - (883 + 397))) and v104.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
					if (((v90 < v108) and v57 and ((v63 and v33) or not v63)) or ((3721 - (563 + 27)) > (13858 - 10316))) then
						local v268 = 1986 - (1369 + 617);
						while true do
							if (((4064 - (85 + 1402)) >= (544 + 1034)) and (v268 == (0 - 0))) then
								if (((4506 - (274 + 129)) <= (4788 - (12 + 205))) and v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (46 + 4)))) then
									if (v24(v100.BloodFury) or ((5796 - 4301) == (4633 + 154))) then
										return "blood_fury main 2";
									end
								end
								if ((v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) or ((694 - (27 + 357)) > (4914 - (91 + 389)))) then
									if (((2465 - (90 + 207)) <= (168 + 4192)) and v24(v100.Berserking)) then
										return "berserking main 4";
									end
								end
								v268 = 862 - (706 + 155);
							end
							if (((2789 - (730 + 1065)) == (2557 - (1339 + 224))) and (v268 == (2 + 0))) then
								if (((1474 + 181) > (596 - 195)) and v100.BagofTricks:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) then
									if (((3906 - (268 + 575)) <= (4720 - (919 + 375))) and v24(v100.BagofTricks)) then
										return "bag_of_tricks main 10";
									end
								end
								break;
							end
							if (((4011 - 2552) > (1735 - (180 + 791))) and (v268 == (1806 - (323 + 1482)))) then
								if ((v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (1968 - (1177 + 741))))) or ((43 + 598) > (16252 - 11918))) then
									if (((1309 + 2090) >= (5048 - 2788)) and v24(v100.Fireblood)) then
										return "fireblood main 6";
									end
								end
								if ((v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (5 + 45)))) or ((502 - (96 + 13)) >= (6163 - (962 + 959)))) then
									if (((2469 - 1480) < (861 + 3998)) and v24(v100.AncestralCall)) then
										return "ancestral_call main 8";
									end
								end
								v268 = 1353 - (461 + 890);
							end
						end
					end
					if ((v90 < v108) or ((3518 + 1277) < (3697 - 2748))) then
						if (((4085 - (19 + 224)) == (3483 + 359)) and v56 and ((v33 and v62) or not v62)) then
							v30 = v135();
							if (((1945 - (37 + 161)) <= (1299 + 2302)) and v30) then
								return v30;
							end
						end
					end
					if ((v100.NaturesSwiftness:IsCastable() and v46) or ((312 + 492) > (4300 + 59))) then
						if (((4731 - (60 + 1)) >= (4546 - (826 + 97))) and v24(v100.NaturesSwiftness)) then
							return "natures_swiftness main 12";
						end
					end
					local v258 = v104.HandleDPSPotion(v13:BuffUp(v100.AscendanceBuff));
					if (((2000 + 65) < (9144 - 6600)) and v258) then
						return v258;
					end
					if (((2700 - 1389) <= (4044 - (375 + 310))) and v32 and (v113 > (2001 - (1864 + 135))) and (v114 > (4 - 2))) then
						local v269 = 0 + 0;
						while true do
							if (((909 + 1808) <= (7754 - 4598)) and (v269 == (1131 - (314 + 817)))) then
								v30 = v137();
								if (((614 + 467) < (4738 - (32 + 182))) and v30) then
									return v30;
								end
								v269 = 1 + 0;
							end
							if (((1537 - 1097) >= (136 - (39 + 26))) and (v269 == (145 - (54 + 90)))) then
								if (((5132 - (45 + 153)) > (1583 + 1024)) and v24(v100.Pool)) then
									return "Pool for Aoe()";
								end
								break;
							end
						end
					end
					if (true or ((1952 - (457 + 95)) > (3096 + 20))) then
						v30 = v138();
						if (((1095 - 570) < (4016 - 2354)) and v30) then
							return v30;
						end
						if (v24(v100.Pool) or ((3167 - 2291) > (1143 + 1407))) then
							return "Pool for SingleTarget()";
						end
					end
				end
				break;
			end
		end
	end
	local function v141()
		local v170 = 0 - 0;
		while true do
			if (((660 - 441) <= (3204 - (485 + 263))) and ((711 - (575 + 132)) == v170)) then
				v52 = EpicSettings.Settings['useAscendance'];
				v54 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v53 = EpicSettings.Settings['useFireElemental'];
				v55 = EpicSettings.Settings['useStormElemental'];
				v170 = 866 - (750 + 111);
			end
			if (((1016 - (445 + 565)) == v170) or ((3396 + 823) == (165 + 985))) then
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v65 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if ((v170 == (2 - 0)) or ((998 + 1991) <= (532 - (189 + 121)))) then
				v44 = EpicSettings.Settings['useLavaBurst'];
				v45 = EpicSettings.Settings['useLightningBolt'];
				v46 = EpicSettings.Settings['useNaturesSwiftness'];
				v47 = EpicSettings.Settings['usePrimordialWave'];
				v170 = 1 + 2;
			end
			if (((3605 - (634 + 713)) > (1779 - (493 + 45))) and (v170 == (968 - (493 + 475)))) then
				v36 = EpicSettings.Settings['useChainlightning'];
				v37 = EpicSettings.Settings['useEarthquake'];
				v38 = EpicSettings.Settings['useEarthShock'];
				v39 = EpicSettings.Settings['useElementalBlast'];
				v170 = 1 + 0;
			end
			if (((825 - (158 + 626)) < (2003 + 2256)) and (v170 == (8 - 3))) then
				v58 = EpicSettings.Settings['ascendanceWithCD'];
				v61 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v59 = EpicSettings.Settings['fireElementalWithCD'];
				v60 = EpicSettings.Settings['stormElementalWithCD'];
				v170 = 2 + 4;
			end
			if ((v170 == (1 + 0)) or ((3021 - (1035 + 56)) < (1015 - (114 + 845)))) then
				v40 = EpicSettings.Settings['useFlameShock'];
				v41 = EpicSettings.Settings['useFrostShock'];
				v42 = EpicSettings.Settings['useIceFury'];
				v43 = EpicSettings.Settings['useLavaBeam'];
				v170 = 1 + 1;
			end
			if (((8531 - 5198) == (2802 + 531)) and (v170 == (1052 - (179 + 870)))) then
				v48 = EpicSettings.Settings['useStormkeeper'];
				v49 = EpicSettings.Settings['useTotemicRecall'];
				v50 = EpicSettings.Settings['useWeaponEnchant'];
				v91 = EpicSettings.Settings['useWeapon'];
				v170 = 4 - 0;
			end
		end
	end
	local function v142()
		local v171 = 878 - (827 + 51);
		while true do
			if ((v171 == (2 - 1)) or ((1115 + 1110) == (493 - (95 + 378)))) then
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v71 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v171 = 1 + 1;
			end
			if ((v171 == (7 - 2)) or ((766 + 106) >= (4103 - (334 + 677)))) then
				v98 = EpicSettings.Settings['healOOC'];
				v99 = EpicSettings.Settings['healOOCHP'] or (0 - 0);
				v97 = EpicSettings.Settings['usePurgeTarget'];
				v171 = 1062 - (1049 + 7);
			end
			if (((19231 - 14827) >= (6117 - 2865)) and ((0 + 0) == v171)) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v171 = 2 - 1;
			end
			if (((2217 - 1110) > (355 + 441)) and (v171 == (1426 - (1004 + 416)))) then
				v80 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v81 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v82 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((2916 - (1621 + 336)) == (2898 - (337 + 1602))) and (v171 == (1520 - (1014 + 503)))) then
				v78 = EpicSettings.Settings['healingStreamTotemHP'] or (1015 - (446 + 569));
				v79 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v51 = EpicSettings.Settings['earthquakeSetting'] or "";
				v171 = 11 - 7;
			end
			if ((v171 == (1 + 1)) or ((508 - 263) >= (45 + 2159))) then
				v75 = EpicSettings.Settings['ancestralGuidanceHP'] or (505 - (223 + 282));
				v76 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v77 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
				v171 = 4 - 1;
			end
			if (((3832 - (623 + 47)) >= (2114 - (32 + 13))) and (v171 == (3 + 1))) then
				v66 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v73 = EpicSettings.Settings['autoShield'];
				v74 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v171 = 5 + 0;
			end
		end
	end
	local function v143()
		v90 = EpicSettings.Settings['fightRemainsCheck'] or (1801 - (1070 + 731));
		v87 = EpicSettings.Settings['InterruptWithStun'];
		v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v89 = EpicSettings.Settings['InterruptThreshold'];
		v84 = EpicSettings.Settings['DispelDebuffs'];
		v83 = EpicSettings.Settings['DispelBuffs'];
		v56 = EpicSettings.Settings['useTrinkets'];
		v57 = EpicSettings.Settings['useRacials'];
		v62 = EpicSettings.Settings['trinketsWithCD'];
		v63 = EpicSettings.Settings['racialsWithCD'];
		v93 = EpicSettings.Settings['useHealthstone'];
		v92 = EpicSettings.Settings['useHealingPotion'];
		v95 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v94 = EpicSettings.Settings['healingPotionHP'] or (1404 - (1257 + 147));
		v96 = EpicSettings.Settings['HealingPotionName'] or "";
		v85 = EpicSettings.Settings['handleAfflicted'];
		v86 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v144()
		local v185 = 0 + 0;
		while true do
			if ((v185 == (1 - 0)) or ((439 - (98 + 35)) > (1293 + 1788))) then
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v185 = 6 - 4;
			end
			if ((v185 == (13 - 9)) or ((3284 + 229) < (2382 + 324))) then
				if (((1304 + 1674) < (4196 - (395 + 162))) and v35 and v84) then
					if (((3239 + 443) >= (4829 - (816 + 1125))) and v13:AffectingCombat() and v100.CleanseSpirit:IsAvailable()) then
						local v270 = v84 and v100.CleanseSpirit:IsReady() and v35;
						v30 = v104.FocusUnit(v270, nil, 28 - 8, nil, 1173 - (701 + 447), v100.HealingSurge);
						if (((228 - 79) < (836 - 357)) and v30) then
							return v30;
						end
					end
					if (((2361 - (391 + 950)) >= (1527 - 960)) and v100.CleanseSpirit:IsAvailable()) then
						if ((v14 and v14:Exists() and v14:IsAPlayer() and v104.UnitHasCurseDebuff(v14)) or ((1836 - 1103) > (6083 - 3614))) then
							if (((1752 + 745) == (1453 + 1044)) and v100.CleanseSpirit:IsReady()) then
								if (((14263 - 10362) == (5423 - (251 + 1271))) and v24(v102.CleanseSpiritMouseover)) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
				end
				if (((179 + 22) < (1111 - 696)) and (v104.TargetIsValid() or v13:AffectingCombat())) then
					local v259 = 0 - 0;
					while true do
						if (((0 - 0) == v259) or ((1392 - (1147 + 112)) == (446 + 1338))) then
							v107 = v9.BossFightRemains();
							v108 = v107;
							v259 = 1 - 0;
						end
						if ((v259 == (1 + 0)) or ((704 - (335 + 362)) >= (291 + 19))) then
							if (((7514 - 2522) > (780 - 494)) and (v108 == (41286 - 30175))) then
								v108 = v9.FightRemains(v111, false);
							end
							break;
						end
					end
				end
				if ((not v13:IsChanneling() and not v13:IsCasting()) or ((12469 - 9908) == (11049 - 7156))) then
					local v260 = 566 - (237 + 329);
					while true do
						if (((15621 - 11259) >= (937 + 484)) and (v260 == (0 + 0))) then
							if (((1199 - (408 + 716)) <= (13472 - 9926)) and v85) then
								local v276 = 821 - (344 + 477);
								while true do
									if (((457 + 2223) <= (5179 - (1188 + 573))) and (v276 == (0 - 0))) then
										if (v80 or ((4178 + 110) < (9330 - 6454))) then
											local v279 = 0 - 0;
											while true do
												if (((6088 - 3626) >= (2676 - (508 + 1021))) and ((0 + 0) == v279)) then
													v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 1206 - (228 + 938));
													if (v30 or ((5599 - (332 + 353)) < (3021 - 541))) then
														return v30;
													end
													break;
												end
											end
										end
										if (v81 or ((4081 - 2522) == (1175 + 65))) then
											local v280 = 0 + 0;
											while true do
												if (((2263 - 1697) == (989 - (18 + 405))) and (v280 == (0 + 0))) then
													v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 16 + 14);
													if (((5975 - 2054) >= (3987 - (194 + 784))) and v30) then
														return v30;
													end
													break;
												end
											end
										end
										v276 = 1771 - (694 + 1076);
									end
									if (((3967 - (122 + 1782)) >= (1551 + 97)) and (v276 == (1 + 0))) then
										if (((960 + 106) >= (325 + 127)) and v82) then
											v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 87 - 57);
											if (((4608 + 366) >= (4625 - (214 + 1756))) and v30) then
												return v30;
											end
										end
										break;
									end
								end
							end
							if (v13:AffectingCombat() or ((13153 - 10432) <= (100 + 807))) then
								local v277 = 0 + 0;
								while true do
									if (((5022 - (217 + 368)) >= (9157 - 6126)) and (v277 == (0 + 0))) then
										if ((v33 and v91 and (v101.Dreambinder:IsEquippedAndReady() or v101.Iridal:IsEquippedAndReady())) or ((3317 + 1153) < (100 + 2849))) then
											if (v24(v102.UseWeapon, nil) or ((2469 - (844 + 45)) == (2710 - (242 + 42)))) then
												return "Using Weapon Macro";
											end
										end
										v30 = v140();
										v277 = 1 - 0;
									end
									if ((v277 == (2 - 1)) or ((4911 - (132 + 1068)) == (802 - 299))) then
										if (v30 or ((2043 - (214 + 1409)) == (3340 + 978))) then
											return v30;
										end
										break;
									end
								end
							else
								local v278 = 1634 - (497 + 1137);
								while true do
									if ((v278 == (940 - (9 + 931))) or ((4447 - (181 + 108)) <= (20 + 13))) then
										v30 = v139();
										if (v30 or ((243 - 144) > (14088 - 9344))) then
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
				break;
			end
			if (((1025 + 3316) == (2707 + 1634)) and ((476 - (296 + 180)) == v185)) then
				v142();
				v141();
				v143();
				v185 = 1404 - (1183 + 220);
			end
			if (((1520 - (1037 + 228)) <= (2583 - 987)) and (v185 == (5 - 3))) then
				v35 = EpicSettings.Toggles['dispel'];
				v34 = EpicSettings.Toggles['minicds'];
				if (v13:IsDeadOrGhost() or ((15146 - 10713) < (2369 - (527 + 207)))) then
					return v30;
				end
				v185 = 530 - (187 + 340);
			end
			if ((v185 == (1873 - (1298 + 572))) or ((10693 - 6393) < (3414 - (144 + 26)))) then
				v111 = v13:GetEnemiesInRange(99 - 59);
				v112 = v16:GetEnemiesInSplashRange(11 - 6);
				if (v32 or ((1263 + 2271) > (12747 - 8070))) then
					v113 = #v111;
					v114 = v27(v16:GetEnemiesInSplashRangeCount(11 - 6), v113);
				else
					local v261 = 0 - 0;
					while true do
						if ((v261 == (0 + 0)) or ((6594 - 1735) < (2801 + 198))) then
							v113 = 1 + 0;
							v114 = 203 - (5 + 197);
							break;
						end
					end
				end
				v185 = 690 - (339 + 347);
			end
		end
	end
	local function v145()
		local v186 = 0 - 0;
		while true do
			if (((16644 - 11918) > (2783 - (365 + 11))) and ((1 + 0) == v186)) then
				v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if ((v186 == (0 - 0)) or ((3013 - 1729) > (4593 - (837 + 87)))) then
				v100.FlameShockDebuff:RegisterAuraTracking();
				v106();
				v186 = 1 - 0;
			end
		end
	end
	v21.SetAPL(1932 - (837 + 833), v144, v145);
end;
return v0["Epix_Shaman_Elemental.lua"]();

