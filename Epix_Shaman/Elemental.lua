local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((30 + 3649) < (2457 - (1552 + 280)))) then
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
		if (v100.CleanseSpirit:IsAvailable() or ((5459 - (64 + 770)) < (430 + 202))) then
			v104.DispellableDebuffs = v104.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v106();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		local v146 = 0 - 0;
		while true do
			if ((v146 == (1 + 0)) or ((1326 - (157 + 1086)) > (3562 - 1782))) then
				v100.LavaBurst:RegisterInFlight();
				break;
			end
			if (((2391 - 1845) <= (1652 - 575)) and (v146 == (0 - 0))) then
				v100.PrimordialWave:RegisterInFlightEffect(327981 - (599 + 220));
				v100.PrimordialWave:RegisterInFlight();
				v146 = 1 - 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v100.PrimordialWave:RegisterInFlightEffect(329093 - (1813 + 118));
	v100.PrimordialWave:RegisterInFlight();
	v100.LavaBurst:RegisterInFlight();
	local v107 = 8122 + 2989;
	local v108 = 12328 - (841 + 376);
	local v109, v110;
	local v111, v112;
	local v113 = 0 - 0;
	local v114 = 0 + 0;
	local v115 = 0 - 0;
	local v116 = 859 - (464 + 395);
	local v117 = 0 - 0;
	local function v118()
		return (20 + 20) - (v28() - v115);
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v147 = 837 - (467 + 370);
		local v148;
		local v149;
		local v150;
		while true do
			if ((v147 == (0 - 0)) or ((732 + 264) > (14743 - 10442))) then
				v148, v149, v149, v149, v150 = select(2 + 6, ...);
				if (((9469 - 5399) > (1207 - (150 + 370))) and (v148 == v13:GUID()) and (v150 == (192916 - (74 + 1208)))) then
					local v247 = 0 - 0;
					while true do
						if ((v247 == (0 - 0)) or ((467 + 189) >= (3720 - (14 + 376)))) then
							v116 = v28();
							C_Timer.After(0.1 - 0, function()
								if ((v116 ~= v117) or ((1613 + 879) <= (295 + 40))) then
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
		return v152:DebuffRefreshable(v100.FlameShockDebuff) and (v152:DebuffRemains(v100.FlameShockDebuff) < (v152:TimeToDie() - (5 + 0)));
	end
	local function v121(v153)
		return v153:DebuffRefreshable(v100.FlameShockDebuff) and (v153:DebuffRemains(v100.FlameShockDebuff) < (v153:TimeToDie() - (14 - 9))) and (v153:DebuffRemains(v100.FlameShockDebuff) > (0 + 0));
	end
	local function v122(v154)
		return (v154:DebuffRemains(v100.FlameShockDebuff));
	end
	local function v123(v155)
		return v155:DebuffRemains(v100.FlameShockDebuff) > (80 - (23 + 55));
	end
	local function v124(v156)
		return (v156:DebuffRemains(v100.LightningRodDebuff));
	end
	local function v125()
		local v157 = 0 - 0;
		local v158;
		while true do
			if (((2885 + 1437) >= (2301 + 261)) and (v157 == (0 - 0))) then
				v158 = v13:Maelstrom();
				if (not v13:IsCasting() or ((1145 + 2492) >= (4671 - (652 + 249)))) then
					return v158;
				elseif (v13:IsCasting(v100.ElementalBlast) or ((6366 - 3987) > (6446 - (708 + 1160)))) then
					return v158 - (203 - 128);
				elseif (v13:IsCasting(v100.Icefury) or ((880 - 397) > (770 - (10 + 17)))) then
					return v158 + 6 + 19;
				elseif (((4186 - (1400 + 332)) > (1108 - 530)) and v13:IsCasting(v100.LightningBolt)) then
					return v158 + (1918 - (242 + 1666));
				elseif (((398 + 532) < (1634 + 2824)) and v13:IsCasting(v100.LavaBurst)) then
					return v158 + 11 + 1;
				elseif (((1602 - (850 + 90)) <= (1701 - 729)) and v13:IsCasting(v100.ChainLightning)) then
					return v158 + ((1394 - (360 + 1030)) * v114);
				else
					return v158;
				end
				break;
			end
		end
	end
	local function v126(v159)
		local v160 = 0 + 0;
		local v161;
		while true do
			if (((12334 - 7964) == (6012 - 1642)) and (v160 == (1661 - (909 + 752)))) then
				v161 = v159:IsReady();
				if ((v159 == v100.Stormkeeper) or (v159 == v100.ElementalBlast) or (v159 == v100.Icefury) or ((5985 - (109 + 1114)) <= (1576 - 715))) then
					local v248 = 0 + 0;
					local v249;
					while true do
						if ((v248 == (242 - (6 + 236))) or ((890 + 522) == (3433 + 831))) then
							v249 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
							return v161 and v249 and not v13:IsCasting(v159);
						end
					end
				elseif ((v159 == v100.LavaBeam) or ((7471 - 4303) < (3760 - 1607))) then
					local v259 = 1133 - (1076 + 57);
					local v260;
					while true do
						if ((v259 == (0 + 0)) or ((5665 - (579 + 110)) < (106 + 1226))) then
							v260 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or not v13:IsMoving();
							return v161 and v260;
						end
					end
				elseif (((4092 + 536) == (2457 + 2171)) and ((v159 == v100.LightningBolt) or (v159 == v100.ChainLightning))) then
					local v267 = 407 - (174 + 233);
					local v268;
					while true do
						if ((v267 == (0 - 0)) or ((94 - 40) == (176 + 219))) then
							v268 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.StormkeeperBuff) or not v13:IsMoving();
							return v161 and v268;
						end
					end
				elseif (((1256 - (663 + 511)) == (74 + 8)) and (v159 == v100.LavaBurst)) then
					local v273 = 0 + 0;
					local v274;
					local v275;
					local v276;
					local v277;
					while true do
						if ((v273 == (5 - 3)) or ((352 + 229) < (663 - 381))) then
							return v161 and v274 and (v275 or v276 or v277);
						end
						if ((v273 == (0 - 0)) or ((2200 + 2409) < (4856 - 2361))) then
							v274 = v13:BuffUp(v100.SpiritwalkersGraceBuff) or v13:BuffUp(v100.LavaSurgeBuff) or not v13:IsMoving();
							v275 = v13:BuffUp(v100.LavaSurgeBuff);
							v273 = 1 + 0;
						end
						if (((106 + 1046) == (1874 - (478 + 244))) and (v273 == (518 - (440 + 77)))) then
							v276 = (v100.LavaBurst:Charges() >= (1 + 0)) and not v13:IsCasting(v100.LavaBurst);
							v277 = (v100.LavaBurst:Charges() == (7 - 5)) and v13:IsCasting(v100.LavaBurst);
							v273 = 1558 - (655 + 901);
						end
					end
				elseif (((352 + 1544) <= (2620 + 802)) and (v159 == v100.PrimordialWave)) then
					return v161 and v33 and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffDown(v100.LavaSurgeBuff);
				else
					return v161;
				end
				break;
			end
		end
	end
	local function v127()
		local v162 = 0 + 0;
		local v163;
		while true do
			if ((v162 == (0 - 0)) or ((2435 - (695 + 750)) > (5531 - 3911))) then
				if (not v100.MasteroftheElements:IsAvailable() or ((1353 - 476) > (18882 - 14187))) then
					return false;
				end
				v163 = v13:BuffUp(v100.MasteroftheElementsBuff);
				v162 = 352 - (285 + 66);
			end
			if (((6272 - 3581) >= (3161 - (682 + 628))) and (v162 == (1 + 0))) then
				if (not v13:IsCasting() or ((3284 - (176 + 123)) >= (2032 + 2824))) then
					return v163;
				elseif (((3102 + 1174) >= (1464 - (239 + 30))) and v13:IsCasting(v105.LavaBurst)) then
					return true;
				elseif (((879 + 2353) <= (4508 + 182)) and (v13:IsCasting(v105.ElementalBlast) or v13:IsCasting(v100.Icefury) or v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning))) then
					return false;
				else
					return v163;
				end
				break;
			end
		end
	end
	local function v128()
		local v164 = 0 - 0;
		local v165;
		while true do
			if ((v164 == (2 - 1)) or ((1211 - (306 + 9)) >= (10978 - 7832))) then
				if (((533 + 2528) >= (1815 + 1143)) and not v13:IsCasting()) then
					return v165 > (0 + 0);
				elseif (((9113 - 5926) >= (2019 - (1140 + 235))) and (v165 == (1 + 0)) and (v13:IsCasting(v100.LightningBolt) or v13:IsCasting(v100.ChainLightning))) then
					return false;
				else
					return v165 > (0 + 0);
				end
				break;
			end
			if (((166 + 478) <= (756 - (33 + 19))) and ((0 + 0) == v164)) then
				if (((2871 - 1913) > (418 + 529)) and not v100.PoweroftheMaelstrom:IsAvailable()) then
					return false;
				end
				v165 = v13:BuffStack(v100.PoweroftheMaelstromBuff);
				v164 = 1 - 0;
			end
		end
	end
	local function v129()
		if (((4213 + 279) >= (3343 - (586 + 103))) and not v100.Stormkeeper:IsAvailable()) then
			return false;
		end
		local v166 = v13:BuffUp(v100.StormkeeperBuff);
		if (((314 + 3128) >= (4627 - 3124)) and not v13:IsCasting()) then
			return v166;
		elseif (v13:IsCasting(v100.Stormkeeper) or ((4658 - (1309 + 179)) <= (2642 - 1178))) then
			return true;
		else
			return v166;
		end
	end
	local function v130()
		if (not v100.Icefury:IsAvailable() or ((2088 + 2709) == (11784 - 7396))) then
			return false;
		end
		local v167 = v13:BuffUp(v100.IcefuryBuff);
		if (((417 + 134) <= (1446 - 765)) and not v13:IsCasting()) then
			return v167;
		elseif (((6529 - 3252) > (1016 - (295 + 314))) and v13:IsCasting(v100.Icefury)) then
			return true;
		else
			return v167;
		end
	end
	local v131 = 0 - 0;
	local function v132()
		if (((6657 - (1300 + 662)) >= (4443 - 3028)) and v100.CleanseSpirit:IsReady() and v35 and v104.DispellableFriendlyUnit(1780 - (1178 + 577))) then
			local v182 = 0 + 0;
			while true do
				if ((v182 == (0 - 0)) or ((4617 - (851 + 554)) <= (835 + 109))) then
					if ((v131 == (0 - 0)) or ((6723 - 3627) <= (2100 - (115 + 187)))) then
						v131 = v28();
					end
					if (((2709 + 828) == (3349 + 188)) and v104.Wait(1970 - 1470, v131)) then
						if (((4998 - (160 + 1001)) >= (1374 + 196)) and v24(v102.CleanseSpiritFocus)) then
							return "cleanse_spirit dispel";
						end
						v131 = 0 + 0;
					end
					break;
				end
			end
		end
	end
	local function v133()
		if ((v98 and (v13:HealthPercentage() <= v99)) or ((6039 - 3089) == (4170 - (237 + 121)))) then
			if (((5620 - (525 + 372)) >= (4394 - 2076)) and v100.HealingSurge:IsReady()) then
				if (v24(v100.HealingSurge) or ((6659 - 4632) > (2994 - (96 + 46)))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v134()
		if ((v100.AstralShift:IsReady() and v71 and (v13:HealthPercentage() <= v77)) or ((1913 - (643 + 134)) > (1559 + 2758))) then
			if (((11384 - 6636) == (17627 - 12879)) and v24(v100.AstralShift)) then
				return "astral_shift defensive 1";
			end
		end
		if (((3583 + 153) <= (9302 - 4562)) and v100.AncestralGuidance:IsReady() and v70 and v104.AreUnitsBelowHealthPercentage(v75, v76, v100.HealingSurge)) then
			if (v24(v100.AncestralGuidance) or ((6929 - 3539) <= (3779 - (316 + 403)))) then
				return "ancestral_guidance defensive 2";
			end
		end
		if ((v100.HealingStreamTotem:IsReady() and v72 and v104.AreUnitsBelowHealthPercentage(v78, v79, v100.HealingSurge)) or ((665 + 334) > (7403 - 4710))) then
			if (((168 + 295) < (1513 - 912)) and v24(v100.HealingStreamTotem)) then
				return "healing_stream_totem defensive 3";
			end
		end
		if ((v101.Healthstone:IsReady() and v93 and (v13:HealthPercentage() <= v95)) or ((1547 + 636) < (222 + 465))) then
			if (((15762 - 11213) == (21725 - 17176)) and v24(v102.Healthstone)) then
				return "healthstone defensive 3";
			end
		end
		if (((9705 - 5033) == (268 + 4404)) and v92 and (v13:HealthPercentage() <= v94)) then
			local v183 = 0 - 0;
			while true do
				if ((v183 == (0 + 0)) or ((10791 - 7123) < (412 - (12 + 5)))) then
					if ((v96 == "Refreshing Healing Potion") or ((16180 - 12014) == (970 - 515))) then
						if (v101.RefreshingHealingPotion:IsReady() or ((9456 - 5007) == (6603 - 3940))) then
							if (v24(v102.RefreshingHealingPotion) or ((869 + 3408) < (4962 - (1656 + 317)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v96 == "Dreamwalker's Healing Potion") or ((776 + 94) >= (3325 + 824))) then
						if (((5881 - 3669) < (15665 - 12482)) and v101.DreamwalkersHealingPotion:IsReady()) then
							if (((5000 - (5 + 349)) > (14211 - 11219)) and v24(v102.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v135()
		local v168 = 1271 - (266 + 1005);
		while true do
			if (((945 + 489) < (10597 - 7491)) and (v168 == (0 - 0))) then
				v30 = v104.HandleTopTrinket(v103, v33, 1736 - (561 + 1135), nil);
				if (((1023 - 237) < (9936 - 6913)) and v30) then
					return v30;
				end
				v168 = 1067 - (507 + 559);
			end
			if ((v168 == (2 - 1)) or ((7552 - 5110) < (462 - (212 + 176)))) then
				v30 = v104.HandleBottomTrinket(v103, v33, 945 - (250 + 655), nil);
				if (((12366 - 7831) == (7924 - 3389)) and v30) then
					return v30;
				end
				break;
			end
		end
	end
	local function v136()
		local v169 = 0 - 0;
		while true do
			if ((v169 == (1956 - (1869 + 87))) or ((10436 - 7427) <= (4006 - (484 + 1417)))) then
				if (((3922 - 2092) < (6148 - 2479)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (773 - (48 + 725))) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108)) then
					if (v24(v100.Stormkeeper) or ((2336 - 906) >= (9690 - 6078))) then
						return "stormkeeper precombat 2";
					end
				end
				if (((1560 + 1123) >= (6574 - 4114)) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 + 0)) and v42) then
					if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((526 + 1278) >= (4128 - (152 + 701)))) then
						return "icefury precombat 4";
					end
				end
				v169 = 1312 - (430 + 881);
			end
			if ((v169 == (2 + 1)) or ((2312 - (557 + 338)) > (1073 + 2556))) then
				if (((13512 - 8717) > (1407 - 1005)) and v13:IsCasting(v100.LavaBurst) and v40 and v100.FlameShock:IsReady()) then
					if (((12786 - 7973) > (7682 - 4117)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
						return "flameshock precombat 14";
					end
				end
				if (((4713 - (499 + 302)) == (4778 - (39 + 827))) and v13:IsCasting(v100.LavaBurst) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) then
					if (((7787 - 4966) <= (10773 - 5949)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
			if (((6903 - 5165) <= (3369 - 1174)) and (v169 == (1 + 1))) then
				if (((119 - 78) <= (483 + 2535)) and v13:IsCasting(v100.ElementalBlast) and v40 and not v100.PrimordialWave:IsAvailable() and v100.FlameShock:IsViable()) then
					if (((3394 - 1249) <= (4208 - (103 + 1))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if (((3243 - (475 + 79)) < (10473 - 5628)) and v126(v100.LavaBurst) and v44 and not v13:IsCasting(v100.LavaBurst) and (not v100.ElementalBlast:IsAvailable() or (v100.ElementalBlast:IsAvailable() and not v100.ElementalBlast:IsAvailable()))) then
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((7430 - 5108) > (339 + 2283))) then
						return "lavaburst precombat 12";
					end
				end
				v169 = 3 + 0;
			end
			if ((v169 == (1504 - (1395 + 108))) or ((13193 - 8659) == (3286 - (7 + 1197)))) then
				if ((v126(v100.ElementalBlast) and v39) or ((685 + 886) > (652 + 1215))) then
					if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((2973 - (27 + 292)) >= (8778 - 5782))) then
						return "elemental_blast precombat 6";
					end
				end
				if (((5072 - 1094) > (8823 - 6719)) and v13:IsCasting(v100.ElementalBlast) and v47 and ((v64 and v34) or not v64) and v126(v100.PrimordialWave)) then
					if (((5905 - 2910) > (2934 - 1393)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave precombat 8";
					end
				end
				v169 = 141 - (43 + 96);
			end
		end
	end
	local function v137()
		local v170 = 0 - 0;
		while true do
			if (((7345 - 4096) > (791 + 162)) and (v170 == (2 + 5))) then
				if ((v126(v100.LavaBeam) and v43 and v127() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((6468 - 3195) > (1753 + 2820))) then
					if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((5905 - 2754) < (405 + 879))) then
						return "lava_beam aoe 82";
					end
				end
				if ((v126(v100.LavaBurst) and (v114 == (1 + 2)) and v100.MasteroftheElements:IsAvailable()) or ((3601 - (1414 + 337)) == (3469 - (1642 + 298)))) then
					local v250 = 0 - 0;
					while true do
						if (((2361 - 1540) < (6299 - 4176)) and (v250 == (0 + 0))) then
							if (((702 + 200) < (3297 - (357 + 615))) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 84";
							end
							if (((603 + 255) <= (7267 - 4305)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
								return "lava_burst aoe 84";
							end
							break;
						end
					end
				end
				if ((v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable()) or ((3382 + 564) < (2759 - 1471))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((2593 + 649) == (39 + 528))) then
						return "lava_burst aoe 86";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((533 + 314) >= (2564 - (384 + 917)))) then
						return "lava_burst aoe 86";
					end
				end
				if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (697 - (128 + 569))) and v42 and v100.ElectrifiedShocks:IsAvailable() and (v114 < (1548 - (1407 + 136)))) or ((4140 - (687 + 1200)) == (3561 - (556 + 1154)))) then
					if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((7342 - 5255) > (2467 - (9 + 86)))) then
						return "icefury aoe 88";
					end
				end
				if ((v126(v100.FrostShock) and v41 and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and not v16:DebuffUp(v100.ElectrifiedShocksDebuff) and (v114 < (426 - (275 + 146))) and v100.UnrelentingCalamity:IsAvailable()) or ((723 + 3722) < (4213 - (29 + 35)))) then
					if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((8057 - 6239) == (253 - 168))) then
						return "frost_shock aoe 90";
					end
				end
				v170 = 35 - 27;
			end
			if (((411 + 219) < (3139 - (53 + 959))) and ((409 - (312 + 96)) == v170)) then
				if ((v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "player")) or ((3363 - 1425) == (2799 - (147 + 138)))) then
					if (((5154 - (813 + 86)) >= (50 + 5)) and v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(74 - 34))) then
						return "liquid_magma_totem aoe player 11";
					end
				end
				if (((3491 - (18 + 474)) > (390 + 766)) and v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v13:BuffUp(v100.SurgeofPowerBuff) and v13:BuffDown(v100.SplinteredElementsBuff)) then
					local v251 = 0 - 0;
					while true do
						if (((3436 - (860 + 226)) > (1458 - (121 + 182))) and ((0 + 0) == v251)) then
							if (((5269 - (988 + 252)) <= (549 + 4304)) and v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil)) then
								return "primordial_wave aoe 12";
							end
							if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((162 + 354) > (5404 - (49 + 1921)))) then
								return "primordial_wave aoe 12";
							end
							break;
						end
					end
				end
				if (((4936 - (223 + 667)) >= (3085 - (51 + 1))) and v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.DeeplyRootedElements:IsAvailable() and not v100.SurgeofPower:IsAvailable() and v13:BuffDown(v100.SplinteredElementsBuff)) then
					if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((4679 - 1960) <= (3098 - 1651))) then
						return "primordial_wave aoe 14";
					end
					if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((5259 - (146 + 979)) < (1109 + 2817))) then
						return "primordial_wave aoe 14";
					end
				end
				if ((v126(v100.PrimordialWave) and v13:BuffDown(v100.PrimordialWaveBuff) and v100.MasteroftheElements:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((769 - (311 + 294)) >= (7766 - 4981))) then
					if (v104.CastTargetIf(v100.PrimordialWave, v112, "min", v122, nil, not v16:IsSpellInRange(v100.PrimordialWave), nil, nil) or ((223 + 302) == (3552 - (496 + 947)))) then
						return "primordial_wave aoe 16";
					end
					if (((1391 - (1233 + 125)) == (14 + 19)) and v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave))) then
						return "primordial_wave aoe 16";
					end
				end
				if (((2740 + 314) <= (763 + 3252)) and v100.FlameShock:IsCastable()) then
					local v252 = 1645 - (963 + 682);
					while true do
						if (((1562 + 309) < (4886 - (504 + 1000))) and (v252 == (2 + 0))) then
							if (((1178 + 115) <= (205 + 1961)) and v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable())) then
								local v269 = 0 - 0;
								while true do
									if ((v269 == (0 + 0)) or ((1500 + 1079) < (305 - (156 + 26)))) then
										if (v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock)) or ((488 + 358) >= (3704 - 1336))) then
											return "flame_shock aoe 26";
										end
										if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((4176 - (149 + 15)) <= (4318 - (890 + 70)))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if (((1611 - (39 + 78)) <= (3487 - (14 + 468))) and v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and not v100.SurgeofPower:IsAvailable()) then
								if (v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock)) or ((6841 - 3730) == (5964 - 3830))) then
									return "flame_shock aoe 28";
								end
								if (((1216 + 1139) == (1415 + 940)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 28";
								end
							end
							v252 = 1 + 2;
						end
						if (((1 + 0) == v252) or ((155 + 433) <= (826 - 394))) then
							if (((4742 + 55) >= (13687 - 9792)) and v100.MasteroftheElements:IsAvailable() and v40 and not v100.LightningRod:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (1 + 5))) then
								local v270 = 51 - (12 + 39);
								while true do
									if (((3328 + 249) == (11071 - 7494)) and (v270 == (0 - 0))) then
										if (((1125 + 2669) > (1944 + 1749)) and v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 22";
										end
										if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((3233 - 1958) == (2731 + 1369))) then
											return "flame_shock aoe 22";
										end
										break;
									end
								end
							end
							if ((v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable() and (v100.FlameShockDebuff:AuraActiveCount() < (28 - 22))) or ((3301 - (1596 + 114)) >= (9346 - 5766))) then
								local v271 = 713 - (164 + 549);
								while true do
									if (((2421 - (1059 + 379)) <= (2244 - 436)) and (v271 == (0 + 0))) then
										if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((363 + 1787) <= (1589 - (145 + 247)))) then
											return "flame_shock aoe 24";
										end
										if (((3093 + 676) >= (543 + 630)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v252 = 5 - 3;
						end
						if (((285 + 1200) == (1280 + 205)) and ((0 - 0) == v252)) then
							if ((v13:BuffUp(v100.SurgeofPowerBuff) and v40 and v100.LightningRod:IsAvailable() and v100.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v100.FlameShockDebuff) < (v16:TimeToDie() - (736 - (254 + 466)))) and (v111 < (565 - (544 + 16)))) or ((10535 - 7220) <= (3410 - (294 + 334)))) then
								if (v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock)) or ((1129 - (236 + 17)) >= (1278 + 1686))) then
									return "flame_shock aoe 18";
								end
								if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((1738 + 494) > (9403 - 6906))) then
									return "flame_shock aoe 18";
								end
							end
							if ((v13:BuffUp(v100.SurgeofPowerBuff) and v40 and (not v100.LightningRod:IsAvailable() or v100.SkybreakersFieryDemise:IsAvailable()) and (v100.FlameShockDebuff:AuraActiveCount() < (28 - 22))) or ((1087 + 1023) <= (274 + 58))) then
								if (((4480 - (413 + 381)) > (134 + 3038)) and v104.CastCycle(v100.FlameShock, v112, v120, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 20";
								end
								if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((9515 - 5041) < (2130 - 1310))) then
									return "flame_shock aoe 20";
								end
							end
							v252 = 1971 - (582 + 1388);
						end
						if (((7290 - 3011) >= (2063 + 819)) and (v252 == (367 - (326 + 38)))) then
							if ((v100.DeeplyRootedElements:IsAvailable() and v40 and not v100.SurgeofPower:IsAvailable()) or ((6001 - 3972) >= (5026 - 1505))) then
								if (v104.CastCycle(v100.FlameShock, v112, v121, not v16:IsSpellInRange(v100.FlameShock)) or ((2657 - (47 + 573)) >= (1637 + 3005))) then
									return "flame_shock aoe 30";
								end
								if (((7304 - 5584) < (7235 - 2777)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
									return "flame_shock aoe 30";
								end
							end
							break;
						end
					end
				end
				v170 = 1666 - (1269 + 395);
			end
			if ((v170 == (500 - (76 + 416))) or ((879 - (319 + 124)) > (6905 - 3884))) then
				if (((1720 - (564 + 443)) <= (2344 - 1497)) and v126(v100.LavaBeam) and v43 and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (((2612 - (337 + 121)) <= (11811 - 7780)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 92";
					end
				end
				if (((15373 - 10758) == (6526 - (1261 + 650))) and v126(v100.ChainLightning) and v36) then
					if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((1604 + 2186) == (796 - 296))) then
						return "chain_lightning aoe 94";
					end
				end
				if (((1906 - (772 + 1045)) < (32 + 189)) and v100.FlameShock:IsCastable() and v40 and v13:IsMoving() and v16:DebuffRefreshable(v100.FlameShockDebuff)) then
					if (((2198 - (102 + 42)) >= (3265 - (1524 + 320))) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock aoe 96";
					end
				end
				if (((1962 - (1049 + 221)) < (3214 - (18 + 138))) and v100.FrostShock:IsCastable() and v41 and v13:IsMoving()) then
					if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((7964 - 4710) == (2757 - (67 + 1035)))) then
						return "frost_shock aoe 98";
					end
				end
				break;
			end
			if ((v170 == (353 - (136 + 212))) or ((5507 - 4211) == (3934 + 976))) then
				if (((3105 + 263) == (4972 - (240 + 1364))) and v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (1082 - (1050 + 32))) and v42 and not v13:BuffUp(v100.AscendanceBuff) and v100.ElectrifiedShocks:IsAvailable() and ((v100.LightningRod:IsAvailable() and (v114 < (17 - 12)) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (2 + 1))))) then
					if (((3698 - (331 + 724)) < (308 + 3507)) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
						return "icefury aoe 62";
					end
				end
				if (((2557 - (269 + 375)) > (1218 - (267 + 458))) and v126(v100.FrostShock) and v41 and not v13:BuffUp(v100.AscendanceBuff) and v13:BuffUp(v100.IcefuryBuff) and v100.ElectrifiedShocks:IsAvailable() and (not v16:DebuffUp(v100.ElectrifiedShocksDebuff) or (v13:BuffRemains(v100.IcefuryBuff) < v13:GCD())) and ((v100.LightningRod:IsAvailable() and (v114 < (2 + 3)) and not v127()) or (v100.DeeplyRootedElements:IsAvailable() and (v114 == (5 - 2))))) then
					if (((5573 - (667 + 151)) > (4925 - (1410 + 87))) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
						return "frost_shock aoe 64";
					end
				end
				if (((3278 - (1504 + 393)) <= (6403 - 4034)) and v126(v100.LavaBurst) and v100.MasteroftheElements:IsAvailable() and not v127() and (v129() or ((v118() < (7 - 4)) and v13:HasTier(826 - (461 + 335), 1 + 1))) and (v125() < ((((1821 - (1730 + 31)) - ((1672 - (728 + 939)) * v100.EyeoftheStorm:TalentRank())) - ((6 - 4) * v25(v100.FlowofPower:IsAvailable()))) - (20 - 10))) and (v114 < (11 - 6))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((5911 - (138 + 930)) == (3733 + 351))) then
						return "lava_burst aoe 66";
					end
					if (((3651 + 1018) > (312 + 51)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 66";
					end
				end
				if ((v126(v100.LavaBeam) and v43 and (v129())) or ((7664 - 5787) >= (4904 - (459 + 1307)))) then
					if (((6612 - (474 + 1396)) >= (6331 - 2705)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 68";
					end
				end
				if ((v126(v100.ChainLightning) and v36 and (v129())) or ((4255 + 285) == (3 + 913))) then
					if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((3311 - 2155) > (551 + 3794))) then
						return "chain_lightning aoe 70";
					end
				end
				v170 = 19 - 13;
			end
			if (((9755 - 7518) < (4840 - (562 + 29))) and (v170 == (0 + 0))) then
				if ((v100.FireElemental:IsReady() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) or ((4102 - (374 + 1045)) < (19 + 4))) then
					if (((2163 - 1466) <= (1464 - (448 + 190))) and v24(v100.FireElemental)) then
						return "fire_elemental aoe 2";
					end
				end
				if (((357 + 748) <= (531 + 645)) and v100.StormElemental:IsReady() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) then
					if (((2202 + 1177) <= (14656 - 10844)) and v24(v100.StormElemental)) then
						return "storm_elemental aoe 4";
					end
				end
				if ((v126(v100.Stormkeeper) and not v129() and v48 and ((v65 and v34) or not v65) and (v90 < v108)) or ((2448 - 1660) >= (3110 - (1307 + 187)))) then
					if (((7352 - 5498) <= (7911 - 4532)) and v24(v100.Stormkeeper)) then
						return "stormkeeper aoe 7";
					end
				end
				if (((13947 - 9398) == (5232 - (232 + 451))) and v100.TotemicRecall:IsCastable() and (v100.LiquidMagmaTotem:CooldownRemains() > (43 + 2)) and v49) then
					if (v24(v100.TotemicRecall) or ((2670 + 352) >= (3588 - (510 + 54)))) then
						return "totemic_recall aoe 8";
					end
				end
				if (((9711 - 4891) > (2234 - (13 + 23))) and v100.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and (v66 == "cursor")) then
					if (v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(77 - 37)) or ((1524 - 463) >= (8886 - 3995))) then
						return "liquid_magma_totem aoe cursor 10";
					end
				end
				v170 = 1089 - (830 + 258);
			end
			if (((4811 - 3447) <= (2799 + 1674)) and (v170 == (4 + 0))) then
				if ((v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) or ((5036 - (860 + 581)) <= (10 - 7))) then
					if (v104.CastTargetIf(v100.ElementalBlast, v112, "min", v124, nil, not v16:IsSpellInRange(v100.ElementalBlast), nil, nil) or ((3708 + 964) == (4093 - (237 + 4)))) then
						return "elemental_blast aoe 52";
					end
					if (((3663 - 2104) == (3943 - 2384)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
						return "elemental_blast aoe 52";
					end
				end
				if ((v126(v100.ElementalBlast) and v39 and v100.EchoesofGreatSundering:IsAvailable()) or ((3321 - 1569) <= (645 + 143))) then
					if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((2244 + 1663) == (668 - 491))) then
						return "elemental_blast aoe 54";
					end
				end
				if (((1489 + 1981) > (302 + 253)) and v126(v100.ElementalBlast) and v39 and (v114 == (1429 - (85 + 1341))) and not v100.EchoesofGreatSundering:IsAvailable()) then
					if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((1658 - 686) == (1821 - 1176))) then
						return "elemental_blast aoe 56";
					end
				end
				if (((3554 - (45 + 327)) >= (3991 - 1876)) and v126(v100.EarthShock) and v38 and v100.EchoesofGreatSundering:IsAvailable()) then
					local v253 = 502 - (444 + 58);
					while true do
						if (((1692 + 2201) < (763 + 3666)) and (v253 == (0 + 0))) then
							if (v104.CastTargetIf(v100.EarthShock, v112, "min", v124, nil, not v16:IsSpellInRange(v100.EarthShock), nil, nil) or ((8308 - 5441) < (3637 - (64 + 1668)))) then
								return "earth_shock aoe 58";
							end
							if (v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock)) or ((3769 - (1227 + 746)) >= (12451 - 8400))) then
								return "earth_shock aoe 58";
							end
							break;
						end
					end
				end
				if (((3004 - 1385) <= (4250 - (415 + 79))) and v126(v100.EarthShock) and v38 and v100.EchoesofGreatSundering:IsAvailable()) then
					if (((16 + 588) == (1095 - (142 + 349))) and v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock))) then
						return "earth_shock aoe 60";
					end
				end
				v170 = 3 + 2;
			end
			if ((v170 == (7 - 1)) or ((2229 + 2255) == (635 + 265))) then
				if ((v126(v100.LavaBeam) and v43 and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) or ((12143 - 7684) <= (2977 - (1710 + 154)))) then
					if (((3950 - (200 + 118)) > (1347 + 2051)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
						return "lava_beam aoe 72";
					end
				end
				if (((7136 - 3054) <= (7292 - 2375)) and v126(v100.ChainLightning) and v36 and v128()) then
					if (((4294 + 538) >= (1371 + 15)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 74";
					end
				end
				if (((74 + 63) == (22 + 115)) and v126(v100.LavaBeam) and v43 and (v114 >= (12 - 6)) and v13:BuffUp(v100.SurgeofPowerBuff) and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime())) then
					if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((2820 - (363 + 887)) >= (7563 - 3231))) then
						return "lava_beam aoe 76";
					end
				end
				if ((v126(v100.ChainLightning) and v36 and (v114 >= (28 - 22)) and v13:BuffUp(v100.SurgeofPowerBuff)) or ((628 + 3436) <= (4255 - 2436))) then
					if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((3407 + 1579) < (3238 - (674 + 990)))) then
						return "chain_lightning aoe 78";
					end
				end
				if (((1269 + 3157) > (71 + 101)) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff)) then
					if (((928 - 342) > (1510 - (507 + 548))) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 80";
					end
					if (((1663 - (289 + 548)) == (2644 - (821 + 997))) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 80";
					end
				end
				v170 = 262 - (195 + 60);
			end
			if (((1 + 2) == v170) or ((5520 - (251 + 1250)) > (13010 - 8569))) then
				if (((1386 + 631) < (5293 - (809 + 223))) and v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and not v100.LightningRod:IsAvailable() and v13:HasTier(45 - 14, 11 - 7)) then
					if (((15593 - 10877) > (59 + 21)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 42";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1837 + 1670) == (3889 - (14 + 603)))) then
						return "lava_burst aoe 42";
					end
				end
				if ((v126(v100.LavaBurst) and v13:BuffUp(v100.LavaSurgeBuff) and v100.MasteroftheElements:IsAvailable() and not v127() and (v125() >= (((189 - (118 + 11)) - ((1 + 4) * v100.EyeoftheStorm:TalentRank())) - ((2 + 0) * v25(v100.FlowofPower:IsAvailable())))) and ((not v100.EchoesofGreatSundering:IsAvailable() and not v100.LightningRod:IsAvailable()) or v13:BuffUp(v100.EchoesofGreatSunderingBuff)) and ((not v13:BuffUp(v100.AscendanceBuff) and (v114 > (8 - 5)) and v100.UnrelentingCalamity:IsAvailable()) or ((v114 > (952 - (551 + 398))) and not v100.UnrelentingCalamity:IsAvailable()) or (v114 == (2 + 1)))) or ((312 + 564) >= (2499 + 576))) then
					if (((16185 - 11833) > (5884 - 3330)) and v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst aoe 44";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1429 + 2977) < (16049 - 12006))) then
						return "lava_burst aoe 44";
					end
				end
				if ((v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and (v114 > (1 + 2)) and ((v114 > (92 - (40 + 49))) or (v113 > (11 - 8)))) or ((2379 - (99 + 391)) >= (2799 + 584))) then
					if (((8317 - 6425) <= (6770 - 4036)) and (v51 == "cursor")) then
						if (((1874 + 49) < (5836 - 3618)) and v24(v102.EarthquakeCursor, not v16:IsInRange(1644 - (1032 + 572)))) then
							return "earthquake aoe 46";
						end
					end
					if (((2590 - (203 + 214)) > (2196 - (568 + 1249))) and (v51 == "player")) then
						if (v24(v102.EarthquakePlayer, not v16:IsInRange(32 + 8)) or ((6223 - 3632) == (13167 - 9758))) then
							return "earthquake aoe 46";
						end
					end
				end
				if (((5820 - (913 + 393)) > (9386 - 6062)) and v37 and v100.Earthquake:IsReady() and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (v114 == (3 - 0)) and ((v114 == (413 - (269 + 141))) or (v113 == (6 - 3)))) then
					local v254 = 1981 - (362 + 1619);
					while true do
						if ((v254 == (1625 - (950 + 675))) or ((81 + 127) >= (6007 - (216 + 963)))) then
							if ((v51 == "cursor") or ((2870 - (485 + 802)) > (4126 - (432 + 127)))) then
								if (v24(v102.EarthquakeCursor, not v16:IsInRange(1113 - (1065 + 8))) or ((730 + 583) == (2395 - (635 + 966)))) then
									return "earthquake aoe 48";
								end
							end
							if (((2283 + 891) > (2944 - (5 + 37))) and (v51 == "player")) then
								if (((10246 - 6126) <= (1773 + 2487)) and v24(v102.EarthquakePlayer, not v16:IsInRange(63 - 23))) then
									return "earthquake aoe 48";
								end
							end
							break;
						end
					end
				end
				if ((v37 and v100.Earthquake:IsReady() and (v13:BuffUp(v100.EchoesofGreatSunderingBuff))) or ((414 + 469) > (9928 - 5150))) then
					local v255 = 0 - 0;
					while true do
						if ((v255 == (0 - 0)) or ((8655 - 5035) >= (3517 + 1374))) then
							if (((4787 - (318 + 211)) > (4610 - 3673)) and (v51 == "cursor")) then
								if (v24(v102.EarthquakeCursor, not v16:IsInRange(1627 - (963 + 624))) or ((2082 + 2787) < (1752 - (518 + 328)))) then
									return "earthquake aoe 50";
								end
							end
							if ((v51 == "player") or ((2855 - 1630) > (6757 - 2529))) then
								if (((3645 - (301 + 16)) > (6559 - 4321)) and v24(v102.EarthquakePlayer, not v16:IsInRange(112 - 72))) then
									return "earthquake aoe 50";
								end
							end
							break;
						end
					end
				end
				v170 = 10 - 6;
			end
			if (((3478 + 361) > (798 + 607)) and (v170 == (3 - 1))) then
				if ((v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108)) or ((778 + 515) <= (49 + 458))) then
					if (v24(v100.Ascendance) or ((9207 - 6311) < (260 + 545))) then
						return "ascendance aoe 32";
					end
				end
				if (((3335 - (829 + 190)) == (8263 - 5947)) and v126(v100.LavaBurst) and (v114 == (3 - 0)) and not v100.LightningRod:IsAvailable() and v13:HasTier(42 - 11, 9 - 5)) then
					local v256 = 0 + 0;
					while true do
						if (((0 + 0) == v256) or ((7800 - 5230) == (1447 + 86))) then
							if (v104.CastCycle(v100.LavaBurst, v112, v122, not v16:IsSpellInRange(v100.LavaBurst)) or ((1496 - (520 + 93)) == (1736 - (259 + 17)))) then
								return "lava_burst aoe 34";
							end
							if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((267 + 4352) <= (360 + 639))) then
								return "lava_burst aoe 34";
							end
							break;
						end
					end
				end
				if ((v37 and v100.Earthquake:IsReady() and v127() and (((v13:BuffStack(v100.MagmaChamberBuff) > (50 - 35)) and (v114 >= ((598 - (396 + 195)) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.SplinteredElements:IsAvailable() and (v114 >= ((29 - 19) - v25(v100.UnrelentingCalamity:IsAvailable())))) or (v100.MountainsWillFall:IsAvailable() and (v114 >= (1770 - (440 + 1321))))) and not v100.LightningRod:IsAvailable() and v13:HasTier(1860 - (1059 + 770), 18 - 14)) or ((3955 - (424 + 121)) > (751 + 3365))) then
					if ((v51 == "cursor") or ((2250 - (641 + 706)) >= (1212 + 1847))) then
						if (v24(v102.EarthquakeCursor, not v16:IsInRange(480 - (249 + 191))) or ((17320 - 13344) < (1276 + 1581))) then
							return "earthquake aoe 36";
						end
					end
					if (((19001 - 14071) > (2734 - (183 + 244))) and (v51 == "player")) then
						if (v24(v102.EarthquakePlayer, not v16:IsInRange(2 + 38)) or ((4776 - (434 + 296)) < (4119 - 2828))) then
							return "earthquake aoe 36";
						end
					end
				end
				if ((v126(v100.LavaBeam) and v43 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (518 - (169 + 343)))) or (v127() and ((v114 < (6 + 0)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(54 - 23, 11 - 7)) or ((3475 + 766) == (10053 - 6508))) then
					if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((5171 - (651 + 472)) > (3199 + 1033))) then
						return "lava_beam aoe 38";
					end
				end
				if ((v126(v100.ChainLightning) and v36 and v129() and ((v13:BuffUp(v100.SurgeofPowerBuff) and (v114 >= (3 + 3))) or (v127() and ((v114 < (7 - 1)) or not v100.SurgeofPower:IsAvailable()))) and not v100.LightningRod:IsAvailable() and v13:HasTier(514 - (397 + 86), 880 - (423 + 453))) or ((178 + 1572) >= (458 + 3015))) then
					if (((2765 + 401) == (2527 + 639)) and v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning))) then
						return "chain_lightning aoe 40";
					end
				end
				v170 = 3 + 0;
			end
		end
	end
	local function v138()
		if (((2953 - (50 + 1140)) < (3219 + 505)) and v100.FireElemental:IsCastable() and v53 and ((v59 and v33) or not v59) and (v90 < v108)) then
			if (((34 + 23) <= (170 + 2553)) and v24(v100.FireElemental)) then
				return "fire_elemental single_target 2";
			end
		end
		if ((v100.StormElemental:IsCastable() and v55 and ((v60 and v33) or not v60) and (v90 < v108)) or ((2972 - 902) == (321 + 122))) then
			if (v24(v100.StormElemental) or ((3301 - (157 + 439)) == (2421 - 1028))) then
				return "storm_elemental single_target 4";
			end
		end
		if ((v100.TotemicRecall:IsCastable() and v49 and (v100.LiquidMagmaTotem:CooldownRemains() > (149 - 104)) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or ((v113 > (2 - 1)) and (v114 > (919 - (782 + 136)))))) or ((5456 - (112 + 743)) < (1232 - (1026 + 145)))) then
			if (v24(v100.TotemicRecall) or ((239 + 1151) >= (5462 - (493 + 225)))) then
				return "totemic_recall single_target 6";
			end
		end
		if ((v100.LiquidMagmaTotem:IsCastable() and v54 and ((v61 and v33) or not v61) and (v90 < v108) and ((v100.LavaSurge:IsAvailable() and v100.SplinteredElements:IsAvailable()) or (v100.FlameShockDebuff:AuraActiveCount() == (0 - 0)) or (v16:DebuffRemains(v100.FlameShockDebuff) < (4 + 2)) or ((v113 > (2 - 1)) and (v114 > (1 + 0))))) or ((5723 - 3720) > (1117 + 2717))) then
			local v184 = 0 - 0;
			while true do
				if ((v184 == (1595 - (210 + 1385))) or ((1845 - (1201 + 488)) > (2426 + 1487))) then
					if (((346 - 151) == (349 - 154)) and (v66 == "cursor")) then
						if (((3690 - (352 + 233)) >= (4340 - 2544)) and v24(v102.LiquidMagmaTotemCursor, not v16:IsInRange(22 + 18))) then
							return "liquid_magma_totem single_target cursor 8";
						end
					end
					if (((12450 - 8071) >= (2705 - (489 + 85))) and (v66 == "player")) then
						if (((5345 - (277 + 1224)) >= (3536 - (663 + 830))) and v24(v102.LiquidMagmaTotemPlayer, not v16:IsInRange(36 + 4))) then
							return "liquid_magma_totem single_target player 8";
						end
					end
					break;
				end
			end
		end
		if ((v126(v100.PrimordialWave) and v100.PrimordialWave:IsCastable() and v47 and ((v64 and v34) or not v64) and not v13:BuffUp(v100.PrimordialWaveBuff) and not v13:BuffUp(v100.SplinteredElementsBuff)) or ((7914 - 4682) <= (3606 - (461 + 414)))) then
			local v185 = 0 + 0;
			while true do
				if (((1963 + 2942) == (468 + 4437)) and (v185 == (0 + 0))) then
					if (v104.CastCycle(v100.PrimordialWave, v112, v122, not v16:IsSpellInRange(v100.PrimordialWave)) or ((4386 - (172 + 78)) >= (7112 - 2701))) then
						return "primordial_wave single_target 10";
					end
					if (v24(v100.PrimordialWave, not v16:IsSpellInRange(v100.PrimordialWave)) or ((1089 + 1869) == (5796 - 1779))) then
						return "primordial_wave single_target 10";
					end
					break;
				end
			end
		end
		if (((335 + 893) >= (272 + 541)) and v100.FlameShock:IsCastable() and v40 and (v113 == (1 - 0)) and v16:DebuffRefreshable(v100.FlameShockDebuff) and ((v16:DebuffRemains(v100.FlameShockDebuff) < v100.PrimordialWave:CooldownRemains()) or not v100.PrimordialWave:IsAvailable()) and v13:BuffDown(v100.SurgeofPowerBuff) and (not v127() or (not v129() and ((v100.ElementalBlast:IsAvailable() and (v125() < ((113 - 23) - ((3 + 5) * v100.EyeoftheStorm:TalentRank())))) or (v125() < ((34 + 26) - ((2 + 3) * v100.EyeoftheStorm:TalentRank()))))))) then
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((13753 - 10298) > (9435 - 5385))) then
				return "flame_shock single_target 12";
			end
		end
		if (((75 + 168) == (139 + 104)) and v100.FlameShock:IsCastable() and v40 and (v100.FlameShockDebuff:AuraActiveCount() == (447 - (133 + 314))) and (v113 > (1 + 0)) and (v114 > (214 - (199 + 14))) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((not v127() and (v129() or (v100.Stormkeeper:CooldownRemains() > (0 - 0)))) or not v100.SurgeofPower:IsAvailable())) then
			local v186 = 1549 - (647 + 902);
			while true do
				if ((v186 == (0 - 0)) or ((504 - (85 + 148)) > (2861 - (426 + 863)))) then
					if (((12818 - 10079) < (4947 - (873 + 781))) and v104.CastTargetIf(v100.FlameShock, v112, "min", v122, nil, not v16:IsSpellInRange(v100.FlameShock))) then
						return "flame_shock single_target 14";
					end
					if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((5278 - 1336) < (3062 - 1928))) then
						return "flame_shock single_target 14";
					end
					break;
				end
			end
		end
		if ((v100.FlameShock:IsCastable() and v40 and (v113 > (1 + 0)) and (v114 > (3 - 2)) and (v100.DeeplyRootedElements:IsAvailable() or v100.Ascendance:IsAvailable() or v100.PrimordialWave:IsAvailable() or v100.SearingFlames:IsAvailable() or v100.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v100.SurgeofPowerBuff) and not v129() and v100.Stormkeeper:IsAvailable()) or not v100.SurgeofPower:IsAvailable())) or ((3858 - 1165) == (14766 - 9793))) then
			if (((4093 - (414 + 1533)) == (1861 + 285)) and v104.CastTargetIf(v100.FlameShock, v112, "min", v122, v119, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 16";
			end
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((2799 - (443 + 112)) == (4703 - (888 + 591)))) then
				return "flame_shock single_target 16";
			end
		end
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (v125() >= (7 + 109)) and v100.ElementalBlast:IsAvailable() and v100.SurgeofPower:IsAvailable() and v100.SwellingMaelstrom:IsAvailable() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) or ((18470 - 13566) <= (748 + 1168))) then
			if (((44 + 46) <= (114 + 951)) and v24(v100.Stormkeeper)) then
				return "stormkeeper single_target 18";
			end
		end
		if (((9150 - 4348) == (8894 - 4092)) and v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (1678 - (136 + 1542))) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and v13:BuffUp(v100.SurgeofPowerBuff) and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable()) then
			if (v24(v100.Stormkeeper) or ((7476 - 5196) <= (508 + 3))) then
				return "stormkeeper single_target 20";
			end
		end
		if ((v126(v100.Stormkeeper) and (v100.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v100.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v108) and v13:BuffDown(v100.AscendanceBuff) and not v129() and (not v100.SurgeofPower:IsAvailable() or not v100.ElementalBlast:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.EchooftheElements:IsAvailable() or v100.PrimordialSurge:IsAvailable())) or ((1213 + 463) <= (949 - (68 + 418)))) then
			if (((10487 - 6618) == (7019 - 3150)) and v24(v100.Stormkeeper)) then
				return "stormkeeper single_target 22";
			end
		end
		if (((1000 + 158) <= (3705 - (770 + 322))) and v100.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v108) and not v129()) then
			if (v24(v100.Ascendance) or ((137 + 2227) <= (579 + 1420))) then
				return "ascendance single_target 24";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and v13:BuffUp(v100.SurgeofPowerBuff)) or ((672 + 4250) < (276 - 82))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((4054 - 1963) < (84 - 53))) then
				return "lightning_bolt single_target 26";
			end
		end
		if ((v126(v100.LavaBeam) and v43 and (v113 > (3 - 2)) and (v114 > (1 + 0)) and v129() and not v100.SurgeofPower:IsAvailable()) or ((3640 - 1210) >= (2338 + 2534))) then
			if (v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam)) or ((2925 + 1845) < (1360 + 375))) then
				return "lava_beam single_target 28";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (3 - 2)) and (v114 > (1 - 0)) and v129() and not v100.SurgeofPower:IsAvailable()) or ((1501 + 2938) <= (10825 - 8475))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((14805 - 10326) < (1837 + 2629))) then
				return "chain_lightning single_target 30";
			end
		end
		if (((12603 - 10056) > (2056 - (762 + 69))) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v129() and not v127() and not v100.SurgeofPower:IsAvailable() and v100.MasteroftheElements:IsAvailable()) then
			if (((15125 - 10454) > (2304 + 370)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 32";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and v127()) or ((2393 + 1303) < (8046 - 4719))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((1430 + 3112) == (48 + 2922))) then
				return "lightning_bolt single_target 34";
			end
		end
		if (((981 - 729) <= (2134 - (8 + 149))) and v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v129() and not v100.SurgeofPower:IsAvailable() and not v100.MasteroftheElements:IsAvailable()) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((2756 - (1199 + 121)) == (6387 - 2612))) then
				return "lightning_bolt single_target 36";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v13:BuffUp(v100.SurgeofPowerBuff) and v100.LightningRod:IsAvailable()) or ((3652 - 2034) < (383 + 547))) then
			if (((16858 - 12135) > (9636 - 5483)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 38";
			end
		end
		if ((v126(v100.Icefury) and (v100.Icefury:CooldownRemains() == (0 + 0)) and v42 and v100.ElectrifiedShocks:IsAvailable() and v100.LightningRod:IsAvailable() and v100.LightningRod:IsAvailable()) or ((5461 - (518 + 1289)) >= (7981 - 3327))) then
			if (((127 + 824) <= (2184 - 688)) and v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury))) then
				return "icefury single_target 40";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (2 + 0)) or (v13:BuffRemains(v100.IcefuryBuff) <= v13:GCD())) and v100.LightningRod:IsAvailable()) or ((2205 - (304 + 165)) == (540 + 31))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((1056 - (54 + 106)) > (6738 - (1618 + 351)))) then
				return "frost_shock single_target 42";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and (v125() >= (36 + 14)) and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < ((1018 - (10 + 1006)) * v13:GCD())) and v129() and v100.LightningRod:IsAvailable()) or ((263 + 782) <= (143 + 877))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3760 - 2600) <= (1361 - (912 + 121)))) then
				return "frost_shock single_target 44";
			end
		end
		if (((1800 + 2008) > (4213 - (1140 + 149))) and v100.LavaBeam:IsCastable() and v43 and (v113 > (1 + 0)) and (v114 > (1 - 0)) and v128() and (v13:BuffRemains(v100.AscendanceBuff) > v100.LavaBeam:CastTime()) and not v13:HasTier(6 + 25, 13 - 9)) then
			if (((7297 - 3406) < (849 + 4070)) and v24(v100.LavaBeam, not v16:IsSpellInRange(v100.LavaBeam))) then
				return "lava_beam single_target 46";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v129() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.PrimordialSurge:IsAvailable() and v100.ElementalBlast:IsAvailable() and (((v125() >= (211 - 150)) and (v125() < (261 - (165 + 21))) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (160 - (61 + 50))) and (v125() < (26 + 37)) and (v100.LavaBurst:CooldownRemains() > (0 - 0))))) or ((4501 - 2267) <= (591 + 911))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3972 - (1295 + 165)) < (99 + 333))) then
				return "frost_shock single_target 48";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and not v100.LavaSurge:IsAvailable() and not v100.EchooftheElements:IsAvailable() and not v100.ElementalBlast:IsAvailable() and (((v125() >= (15 + 21)) and (v125() < (1447 - (819 + 578))) and (v100.LavaBurst:CooldownRemains() > v13:GCD())) or ((v125() >= (1426 - (331 + 1071))) and (v125() < (781 - (588 + 155))) and (v100.LavaBurst:CooldownRemains() > (1282 - (546 + 736)))))) or ((3785 - (1834 + 103)) == (533 + 332))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((13966 - 9284) <= (6307 - (1536 + 230)))) then
				return "frost_shock single_target 50";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.WindspeakersLavaResurgenceBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or ((v125() >= (554 - (128 + 363))) and v100.MasteroftheElements:IsAvailable()) or ((v125() >= (9 + 29)) and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and (v113 > (2 - 1)) and (v114 > (1 + 0))) or not v100.ElementalBlast:IsAvailable())) or ((5012 - 1986) >= (11911 - 7865))) then
			if (((4877 - 2869) > (438 + 200)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 52";
			end
		end
		if (((2784 - (615 + 394)) <= (2919 + 314)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.LavaSurgeBuff) and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or not v100.ElementalBlast:IsAvailable())) then
			if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((4330 + 213) == (6087 - 4090))) then
				return "lava_burst single_target 54";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffUp(v100.AscendanceBuff) and (v13:HasTier(140 - 109, 655 - (59 + 592)) or not v100.ElementalBlast:IsAvailable())) or ((6867 - 3765) < (1340 - 612))) then
			local v187 = 0 + 0;
			while true do
				if (((516 - (70 + 101)) == (852 - 507)) and (v187 == (0 + 0))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((7099 - 4272) < (619 - (123 + 118)))) then
						return "lava_burst single_target 56";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((842 + 2634) < (33 + 2564))) then
						return "lava_burst single_target 56";
					end
					break;
				end
			end
		end
		if (((4478 - (653 + 746)) < (8966 - 4172)) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v13:BuffDown(v100.AscendanceBuff) and (not v100.ElementalBlast:IsAvailable() or not v100.MountainsWillFall:IsAvailable()) and not v100.LightningRod:IsAvailable() and v13:HasTier(44 - 13, 10 - 6)) then
			local v188 = 0 + 0;
			while true do
				if (((3106 + 1748) > (3899 + 565)) and (v188 == (0 + 0))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((767 + 4145) == (9212 - 5454))) then
						return "lava_burst single_target 58";
					end
					if (((120 + 6) <= (6432 - 2950)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 58";
					end
					break;
				end
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and not v100.LightningRod:IsAvailable()) or ((3608 - (885 + 349)) == (3474 + 900))) then
			local v189 = 0 - 0;
			while true do
				if (((4581 - 3006) == (2543 - (915 + 53))) and (v189 == (801 - (768 + 33)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((8553 - 6319) == (2561 - 1106))) then
						return "lava_burst single_target 60";
					end
					if (v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst)) or ((1395 - (287 + 41)) > (2626 - (638 + 209)))) then
						return "lava_burst single_target 60";
					end
					break;
				end
			end
		end
		if (((1123 + 1038) >= (2620 - (96 + 1590))) and v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and v100.MasteroftheElements:IsAvailable() and not v127() and ((v125() >= (1747 - (741 + 931))) or ((v125() >= (25 + 25)) and not v100.ElementalBlast:IsAvailable())) and v100.SwellingMaelstrom:IsAvailable() and (v125() <= (370 - 240))) then
			if (((7530 - 5918) == (692 + 920)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
				return "lava_burst single_target 62";
			end
		end
		if (((1871 + 2481) >= (903 + 1930)) and v100.Earthquake:IsReady() and v37 and v13:BuffUp(v100.EchoesofGreatSunderingBuff) and ((not v100.ElementalBlast:IsAvailable() and (v113 < (7 - 5))) or (v113 > (1 + 0)))) then
			if ((v51 == "cursor") or ((1574 + 1648) < (12535 - 9462))) then
				if (((668 + 76) <= (3436 - (64 + 430))) and v24(v102.EarthquakeCursor, not v16:IsInRange(40 + 0))) then
					return "earthquake single_target 64";
				end
			end
			if ((v51 == "player") or ((2196 - (106 + 257)) <= (938 + 384))) then
				if (v24(v102.EarthquakePlayer, not v16:IsInRange(761 - (496 + 225))) or ((7089 - 3622) <= (5139 - 4084))) then
					return "earthquake single_target 64";
				end
			end
		end
		if (((5199 - (256 + 1402)) == (5440 - (30 + 1869))) and v100.Earthquake:IsReady() and v37 and (v113 > (1370 - (213 + 1156))) and (v114 > (189 - (96 + 92))) and not v100.EchoesofGreatSundering:IsAvailable() and not v100.ElementalBlast:IsAvailable()) then
			if ((v51 == "cursor") or ((606 + 2951) >= (4902 - (142 + 757)))) then
				if (v24(v102.EarthquakeCursor, not v16:IsInRange(33 + 7)) or ((269 + 388) >= (1747 - (32 + 47)))) then
					return "earthquake single_target 66";
				end
			end
			if ((v51 == "player") or ((3004 - (1053 + 924)) > (3779 + 79))) then
				if (v24(v102.EarthquakePlayer, not v16:IsInRange(68 - 28)) or ((5302 - (685 + 963)) < (915 - 465))) then
					return "earthquake single_target 66";
				end
			end
		end
		if (((2948 - 1057) < (6162 - (541 + 1168))) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (not v100.MasteroftheElements:IsAvailable() or (v127() and v16:DebuffUp(v100.ElectrifiedShocksDebuff)))) then
			if (v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast)) or ((4737 - (645 + 952)) < (2967 - (669 + 169)))) then
				return "elemental_blast single_target 68";
			end
		end
		if ((v126(v100.FrostShock) and v41 and v130() and v127() and (v125() < (381 - 271)) and (v100.LavaBurst:ChargesFractional() < (1 - 0)) and v100.ElectrifiedShocks:IsAvailable() and v100.ElementalBlast:IsAvailable() and not v100.LightningRod:IsAvailable()) or ((863 + 1692) < (274 + 966))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((5492 - (181 + 584)) <= (6117 - (665 + 730)))) then
				return "frost_shock single_target 70";
			end
		end
		if (((2132 - 1392) < (10067 - 5130)) and v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39 and (v127() or v100.LightningRod:IsAvailable())) then
			if (((5008 - (540 + 810)) >= (1119 - 839)) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 72";
			end
		end
		if ((v100.EarthShock:IsReady() and v38) or ((2433 - 1548) >= (821 + 210))) then
			if (((3757 - (166 + 37)) >= (2406 - (22 + 1859))) and v24(v100.EarthShock, not v16:IsSpellInRange(v100.EarthShock))) then
				return "earth_shock single_target 74";
			end
		end
		if (((4186 - (843 + 929)) <= (3234 - (30 + 232))) and v126(v100.FrostShock) and v41 and v130() and v100.ElectrifiedShocks:IsAvailable() and v127() and not v100.LightningRod:IsAvailable() and (v113 > (2 - 1)) and (v114 > (778 - (55 + 722)))) then
			if (((7574 - 4045) <= (5213 - (78 + 1597))) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 76";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.DeeplyRootedElements:IsAvailable())) or ((629 + 2232) < (417 + 41))) then
			local v190 = 0 + 0;
			while true do
				if (((2266 - (305 + 244)) <= (4198 + 327)) and (v190 == (105 - (95 + 10)))) then
					if (v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst)) or ((2251 + 927) <= (4829 - 3305))) then
						return "lava_burst single_target 78";
					end
					if (((5819 - 1565) > (1132 - (592 + 170))) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 78";
					end
					break;
				end
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v100.FluxMelting:IsAvailable() and v13:BuffDown(v100.FluxMeltingBuff)) or ((5702 - 4067) == (4462 - 2685))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((1556 + 1782) >= (1555 + 2438))) then
				return "frost_shock single_target 80";
			end
		end
		if (((2786 - 1632) <= (240 + 1235)) and v100.FrostShock:IsCastable() and v41 and v130() and ((v100.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v100.ElectrifiedShocksDebuff) < (3 - 1))) or (v13:BuffRemains(v100.IcefuryBuff) < (513 - (353 + 154))))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((3474 - 864) < (1680 - 450))) then
				return "frost_shock single_target 82";
			end
		end
		if ((v126(v100.LavaBurst) and v100.LavaBurst:IsCastable() and v44 and (v100.EchooftheElements:IsAvailable() or v100.LavaSurge:IsAvailable() or v100.PrimordialSurge:IsAvailable() or not v100.ElementalBlast:IsAvailable() or not v100.MasteroftheElements:IsAvailable() or v129())) or ((1000 + 448) == (2415 + 668))) then
			local v191 = 0 + 0;
			while true do
				if (((4535 - 1396) > (1733 - 817)) and (v191 == (0 - 0))) then
					if (((3040 - (7 + 79)) == (1382 + 1572)) and v104.CastCycle(v100.LavaBurst, v112, v123, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 84";
					end
					if (((298 - (24 + 157)) <= (5770 - 2878)) and v24(v100.LavaBurst, not v16:IsSpellInRange(v100.LavaBurst))) then
						return "lava_burst single_target 84";
					end
					break;
				end
			end
		end
		if ((v126(v100.ElementalBlast) and v100.ElementalBlast:IsCastable() and v39) or ((966 - 513) > (1325 + 3337))) then
			if (((3555 - 2235) > (975 - (262 + 118))) and v24(v100.ElementalBlast, not v16:IsSpellInRange(v100.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v128() and v100.UnrelentingCalamity:IsAvailable() and (v113 > (1084 - (1038 + 45))) and (v114 > (1 - 0))) or ((3429 - (19 + 211)) < (703 - (88 + 25)))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((12203 - 7410) < (15 + 15))) then
				return "chain_lightning single_target 88";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v128() and v100.UnrelentingCalamity:IsAvailable()) or ((1583 + 113) <= (2095 - (1007 + 29)))) then
			if (((632 + 1711) == (5726 - 3383)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v126(v100.Icefury) and v100.Icefury:IsCastable() and v42) or ((4932 - 3889) > (801 + 2790))) then
			if (v24(v100.Icefury, not v16:IsSpellInRange(v100.Icefury)) or ((3701 - (340 + 471)) >= (10273 - 6194))) then
				return "icefury single_target 92";
			end
		end
		if (((5063 - (276 + 313)) <= (11644 - 6874)) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128()) and (v113 > (1 + 0)) and (v114 > (1 + 0))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((464 + 4478) == (5875 - (495 + 1477)))) then
				return "chain_lightning single_target 94";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v100.LightningRodDebuff) and (v16:DebuffUp(v100.ElectrifiedShocksDebuff) or v128())) or ((742 - 494) > (3174 + 1671))) then
			if (((1972 - (342 + 61)) == (687 + 882)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 96";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and v127() and v13:BuffDown(v100.LavaSurgeBuff) and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable() and (v100.LavaBurst:ChargesFractional() < (166 - (4 + 161))) and v100.EchooftheElements:IsAvailable()) or ((3017 + 1910) <= (10110 - 6889))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((4678 - 2898) > (3284 - (322 + 175)))) then
				return "frost_shock single_target 98";
			end
		end
		if ((v100.FrostShock:IsCastable() and v41 and v130() and (v100.FluxMelting:IsAvailable() or (v100.ElectrifiedShocks:IsAvailable() and not v100.LightningRod:IsAvailable()))) or ((4500 - (173 + 390)) <= (304 + 926))) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((2951 - (203 + 111)) < (106 + 1600))) then
				return "frost_shock single_target 100";
			end
		end
		if ((v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable() and (v113 > (2 - 1)) and (v114 > (1 + 0))) or ((3375 - (57 + 649)) <= (2793 - (328 + 56)))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((448 + 953) > (5208 - (433 + 79)))) then
				return "chain_lightning single_target 102";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45 and v127() and v13:BuffDown(v100.LavaSurgeBuff) and (v100.LavaBurst:ChargesFractional() < (1 + 0)) and v100.EchooftheElements:IsAvailable()) or ((2648 + 632) < (4441 - 3120))) then
			if (((23299 - 18372) >= (1680 + 623)) and v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt))) then
				return "lightning_bolt single_target 104";
			end
		end
		if (((3085 + 377) >= (2068 - (562 + 474))) and v100.FrostShock:IsCastable() and v41 and v130() and not v100.ElectrifiedShocks:IsAvailable() and not v100.FluxMelting:IsAvailable()) then
			if (v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock)) or ((2512 - 1435) >= (4097 - 2086))) then
				return "frost_shock single_target 106";
			end
		end
		if (((2448 - (76 + 829)) < (4088 - (1506 + 167))) and v126(v100.ChainLightning) and v100.ChainLightning:IsCastable() and v36 and (v113 > (1 - 0)) and (v114 > (267 - (58 + 208)))) then
			if (v24(v100.ChainLightning, not v16:IsSpellInRange(v100.ChainLightning)) or ((2625 + 1819) < (1436 + 579))) then
				return "chain_lightning single_target 108";
			end
		end
		if ((v126(v100.LightningBolt) and v100.LightningBolt:IsCastable() and v45) or ((2414 + 1786) == (9513 - 7181))) then
			if (v24(v100.LightningBolt, not v16:IsSpellInRange(v100.LightningBolt)) or ((1615 - (258 + 79)) >= (167 + 1149))) then
				return "lightning_bolt single_target 110";
			end
		end
		if (((2275 - 1193) == (2552 - (1219 + 251))) and v100.FlameShock:IsCastable() and v40 and (v13:IsMoving())) then
			if (((2999 - (1231 + 440)) <= (4936 - (34 + 24))) and v104.CastCycle(v100.FlameShock, v112, v119, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 112";
			end
			if (((2371 + 1716) >= (2529 - 1174)) and v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock))) then
				return "flame_shock single_target 112";
			end
		end
		if ((v100.FlameShock:IsCastable() and v40) or ((258 + 332) > (14123 - 9473))) then
			if (v24(v100.FlameShock, not v16:IsSpellInRange(v100.FlameShock)) or ((12098 - 8324) <= (9640 - 5973))) then
				return "flame_shock single_target 114";
			end
		end
		if (((4254 - 2984) < (4685 - 2539)) and v100.FrostShock:IsCastable() and v41) then
			if (((6152 - (877 + 712)) >= (34 + 22)) and v24(v100.FrostShock, not v16:IsSpellInRange(v100.FrostShock))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v139()
		if ((v73 and v100.EarthShield:IsCastable() and v13:BuffDown(v100.EarthShieldBuff) and ((v74 == "Earth Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.LightningShield)))) or ((1200 - (242 + 512)) == (1299 - 677))) then
			if (((2696 - (92 + 535)) > (795 + 214)) and v24(v100.EarthShield)) then
				return "earth_shield main 2";
			end
		elseif (((24 - 12) < (264 + 3944)) and v73 and v100.LightningShield:IsCastable() and v13:BuffDown(v100.LightningShieldBuff) and ((v74 == "Lightning Shield") or (v100.ElementalOrbit:IsAvailable() and v13:BuffUp(v100.EarthShield)))) then
			if (v24(v100.LightningShield) or ((10867 - 7877) <= (2922 + 58))) then
				return "lightning_shield main 2";
			end
		end
		v30 = v133();
		if (v30 or ((1783 + 792) >= (600 + 3675))) then
			return v30;
		end
		if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((7225 - 3599) <= (1990 - 684))) then
			if (((3153 - (1476 + 309)) < (5064 - (299 + 985))) and v24(v100.AncestralSpirit, nil, true)) then
				return "ancestral_spirit";
			end
		end
		if ((v100.AncestralSpirit:IsCastable() and v100.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) or ((753 + 2416) == (7451 - 5178))) then
			if (((2574 - (86 + 7)) <= (13400 - 10121)) and v24(v102.AncestralSpiritMouseover)) then
				return "ancestral_spirit mouseover";
			end
		end
		v109, v110 = v29();
		if ((v100.ImprovedFlametongueWeapon:IsAvailable() and v100.FlametongueWeapon:IsCastable() and v50 and (not v109 or (v110 < (57007 + 542993))) and v100.FlametongueWeapon:IsAvailable()) or ((1943 - (672 + 208)) <= (376 + 501))) then
			if (((2446 - (14 + 118)) == (2759 - (339 + 106))) and v24(v100.FlametongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if (((736 + 188) >= (240 + 237)) and not v13:AffectingCombat() and v31 and v104.TargetIsValid()) then
			local v192 = 1395 - (440 + 955);
			while true do
				if (((1787 + 26) <= (6786 - 3008)) and (v192 == (0 + 0))) then
					v30 = v136();
					if (((10332 - 6182) == (2843 + 1307)) and v30) then
						return v30;
					end
					break;
				end
			end
		end
	end
	local function v140()
		local v171 = 353 - (260 + 93);
		while true do
			if (((405 + 27) <= (6878 - 3871)) and (v171 == (3 - 1))) then
				if (v17 or ((2382 - (1181 + 793)) > (693 + 2028))) then
					if (v84 or ((3725 - (105 + 202)) < (2002 + 495))) then
						v30 = v132();
						if (((2545 - (352 + 458)) < (8744 - 6575)) and v30) then
							return v30;
						end
					end
				end
				if (((9945 - 6055) >= (3158 + 104)) and v100.GreaterPurge:IsAvailable() and v97 and v100.GreaterPurge:IsReady() and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) then
					if (v24(v100.GreaterPurge, not v16:IsSpellInRange(v100.GreaterPurge)) or ((12732 - 8376) >= (5598 - (438 + 511)))) then
						return "greater_purge damage";
					end
				end
				v171 = 1386 - (1262 + 121);
			end
			if (((4972 - (728 + 340)) == (5694 - (816 + 974))) and (v171 == (0 - 0))) then
				v30 = v134();
				if (v30 or ((10292 - 7432) >= (4128 - (163 + 176)))) then
					return v30;
				end
				v171 = 2 - 1;
			end
			if ((v171 == (13 - 10)) or ((329 + 757) > (6259 - (1564 + 246)))) then
				if (((5326 - (124 + 221)) > (373 + 173)) and v100.Purge:IsReady() and v97 and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v104.UnitHasMagicBuff(v16)) then
					if (v24(v100.Purge, not v16:IsSpellInRange(v100.Purge)) or ((2817 - (115 + 336)) <= (17 - 9))) then
						return "purge damage";
					end
				end
				if ((v104.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((534 + 2056) == (2910 - (45 + 1)))) then
					if (((v90 < v108) and v57 and ((v63 and v33) or not v63)) or ((142 + 2482) > (6139 - (1282 + 708)))) then
						if ((v100.BloodFury:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (1262 - (583 + 629))))) or ((436 + 2182) >= (11628 - 7133))) then
							if (v24(v100.BloodFury) or ((1303 + 1182) >= (4301 - (943 + 227)))) then
								return "blood_fury main 2";
							end
						end
						if ((v100.Berserking:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) or ((1226 + 1578) <= (4416 - (1539 + 92)))) then
							if (v24(v100.Berserking) or ((6517 - (706 + 1240)) == (3673 - (81 + 177)))) then
								return "berserking main 4";
							end
						end
						if ((v100.Fireblood:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (141 - 91)))) or ((4698 - (212 + 45)) > (16012 - 11225))) then
							if (((3866 - (708 + 1238)) == (160 + 1760)) and v24(v100.Fireblood)) then
								return "fireblood main 6";
							end
						end
						if ((v100.AncestralCall:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff) or (v100.Ascendance:CooldownRemains() > (17 + 33)))) or ((2314 - (586 + 1081)) == (4988 - (348 + 163)))) then
							if (((3430 + 389) == (4099 - (215 + 65))) and v24(v100.AncestralCall)) then
								return "ancestral_call main 8";
							end
						end
						if ((v100.BagofTricks:IsCastable() and (not v100.Ascendance:IsAvailable() or v13:BuffUp(v100.AscendanceBuff))) or ((3735 - 2269) > (6219 - (1541 + 318)))) then
							if (v24(v100.BagofTricks) or ((13 + 1) > (503 + 491))) then
								return "bag_of_tricks main 10";
							end
						end
					end
					if (((303 + 98) <= (2484 - (1036 + 714))) and (v90 < v108)) then
						if ((v56 and ((v33 and v62) or not v62)) or ((1429 + 738) >= (1893 + 1533))) then
							v30 = v135();
							if (((2044 - (883 + 397)) < (3875 - (563 + 27))) and v30) then
								return v30;
							end
						end
					end
					if (((9777 - 7278) == (4485 - (1369 + 617))) and v100.NaturesSwiftness:IsCastable() and v46) then
						if (v24(v100.NaturesSwiftness) or ((2179 - (85 + 1402)) >= (1701 + 3232))) then
							return "natures_swiftness main 12";
						end
					end
					local v257 = v104.HandleDPSPotion(v13:BuffUp(v100.AscendanceBuff));
					if (v257 or ((8140 - 4986) <= (2663 - (274 + 129)))) then
						return v257;
					end
					if ((v32 and (v113 > (219 - (12 + 205))) and (v114 > (2 + 0))) or ((10224 - 7587) > (3048 + 101))) then
						local v261 = 384 - (27 + 357);
						while true do
							if (((480 - (91 + 389)) == v261) or ((4289 - (90 + 207)) < (93 + 2314))) then
								v30 = v137();
								if (v30 or ((3763 - (706 + 155)) > (6654 - (730 + 1065)))) then
									return v30;
								end
								v261 = 1564 - (1339 + 224);
							end
							if (((854 + 825) < (3881 + 478)) and ((1 - 0) == v261)) then
								if (((2756 - (268 + 575)) < (5964 - (919 + 375))) and v24(v100.Pool)) then
									return "Pool for Aoe()";
								end
								break;
							end
						end
					end
					if (true or ((7825 - 4979) < (1850 - (180 + 791)))) then
						local v262 = 1805 - (323 + 1482);
						while true do
							if (((6506 - (1177 + 741)) == (301 + 4287)) and (v262 == (3 - 2))) then
								if (v24(v100.Pool) or ((134 + 213) == (4612 - 2547))) then
									return "Pool for SingleTarget()";
								end
								break;
							end
							if ((v262 == (0 + 0)) or ((1420 - (96 + 13)) > (4618 - (962 + 959)))) then
								v30 = v138();
								if (v30 or ((6786 - 4069) > (672 + 3123))) then
									return v30;
								end
								v262 = 1352 - (461 + 890);
							end
						end
					end
				end
				break;
			end
			if ((v171 == (1 + 0)) or ((4211 - 3130) < (634 - (19 + 224)))) then
				if (v85 or ((110 + 11) > (3636 - (37 + 161)))) then
					local v258 = 0 + 0;
					while true do
						if (((28 + 43) < (1923 + 26)) and (v258 == (61 - (60 + 1)))) then
							if (((5177 - (826 + 97)) == (4120 + 134)) and v80) then
								local v272 = 0 - 0;
								while true do
									if (((6584 - 3388) >= (3235 - (375 + 310))) and (v272 == (1999 - (1864 + 135)))) then
										v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 103 - 63);
										if (((544 + 1912) < (1397 + 2779)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if (v81 or ((2825 - 1675) == (4583 - (314 + 817)))) then
								v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 18 + 12);
								if (((2089 - (32 + 182)) < (1669 + 589)) and v30) then
									return v30;
								end
							end
							v258 = 3 - 2;
						end
						if (((1238 - (39 + 26)) > (185 - (54 + 90))) and (v258 == (199 - (45 + 153)))) then
							if (v82 or ((34 + 22) >= (3760 - (457 + 95)))) then
								v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 30 + 0);
								if (((9002 - 4689) > (8151 - 4778)) and v30) then
									return v30;
								end
							end
							break;
						end
					end
				end
				if (v86 or ((16245 - 11752) == (998 + 1227))) then
					v30 = v104.HandleIncorporeal(v100.Hex, v102.HexMouseOver, 103 - 73, true);
					if (((9370 - 6266) >= (3840 - (485 + 263))) and v30) then
						return v30;
					end
				end
				v171 = 709 - (575 + 132);
			end
		end
	end
	local function v141()
		local v172 = 861 - (750 + 111);
		while true do
			if (((4558 - (445 + 565)) > (2494 + 604)) and (v172 == (1 + 4))) then
				v91 = EpicSettings.Settings['useWeapon'];
				v52 = EpicSettings.Settings['useAscendance'];
				v54 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v172 = 10 - 4;
			end
			if ((v172 == (3 + 5)) or ((3562 - (189 + 121)) == (125 + 378))) then
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v65 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
			if (((6080 - (634 + 713)) > (2604 - (493 + 45))) and (v172 == (972 - (493 + 475)))) then
				v48 = EpicSettings.Settings['useStormkeeper'];
				v49 = EpicSettings.Settings['useTotemicRecall'];
				v50 = EpicSettings.Settings['useWeaponEnchant'];
				v172 = 2 + 3;
			end
			if (((4333 - (158 + 626)) >= (431 + 485)) and (v172 == (2 - 0))) then
				v42 = EpicSettings.Settings['useIceFury'];
				v43 = EpicSettings.Settings['useLavaBeam'];
				v44 = EpicSettings.Settings['useLavaBurst'];
				v172 = 1 + 2;
			end
			if (((1 + 5) == v172) or ((3280 - (1035 + 56)) <= (1204 - (114 + 845)))) then
				v53 = EpicSettings.Settings['useFireElemental'];
				v55 = EpicSettings.Settings['useStormElemental'];
				v58 = EpicSettings.Settings['ascendanceWithCD'];
				v172 = 3 + 4;
			end
			if ((v172 == (17 - 10)) or ((1168 + 221) > (4974 - (179 + 870)))) then
				v61 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v59 = EpicSettings.Settings['fireElementalWithCD'];
				v60 = EpicSettings.Settings['stormElementalWithCD'];
				v172 = 10 - 2;
			end
			if (((5047 - (827 + 51)) >= (8147 - 5066)) and (v172 == (2 + 1))) then
				v45 = EpicSettings.Settings['useLightningBolt'];
				v46 = EpicSettings.Settings['useNaturesSwiftness'];
				v47 = EpicSettings.Settings['usePrimordialWave'];
				v172 = 477 - (95 + 378);
			end
			if (((26 + 323) <= (1266 - 372)) and (v172 == (0 + 0))) then
				v36 = EpicSettings.Settings['useChainlightning'];
				v37 = EpicSettings.Settings['useEarthquake'];
				v38 = EpicSettings.Settings['useEarthShock'];
				v172 = 1012 - (334 + 677);
			end
			if (((2736 - 2005) <= (4034 - (1049 + 7))) and (v172 == (4 - 3))) then
				v39 = EpicSettings.Settings['useElementalBlast'];
				v40 = EpicSettings.Settings['useFlameShock'];
				v41 = EpicSettings.Settings['useFrostShock'];
				v172 = 3 - 1;
			end
		end
	end
	local function v142()
		local v173 = 0 + 0;
		while true do
			if (((10 - 6) == v173) or ((1786 - 894) > (1733 + 2159))) then
				v99 = EpicSettings.Settings['healOOCHP'] or (1420 - (1004 + 416));
				v97 = EpicSettings.Settings['usePurgeTarget'];
				v80 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v81 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v173 = 1962 - (1621 + 336);
			end
			if ((v173 == (1941 - (337 + 1602))) or ((5983 - (1014 + 503)) == (1915 - (446 + 569)))) then
				v77 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
				v78 = EpicSettings.Settings['healingStreamTotemHP'] or (0 - 0);
				v79 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v51 = EpicSettings.Settings['earthquakeSetting'] or "";
				v173 = 5 - 2;
			end
			if ((v173 == (1 + 2)) or ((2589 - (223 + 282)) >= (84 + 2804))) then
				v66 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v73 = EpicSettings.Settings['autoShield'];
				v74 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v98 = EpicSettings.Settings['healOOC'];
				v173 = 5 - 1;
			end
			if (((698 - 219) < (2533 - (623 + 47))) and (v173 == (46 - (32 + 13)))) then
				v71 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v75 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v76 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v173 = 1803 - (1070 + 731);
			end
			if ((v173 == (0 + 0)) or ((3832 - (1257 + 147)) >= (1601 + 2437))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v173 = 1 - 0;
			end
			if (((138 - (98 + 35)) == v173) or ((1208 + 1670) > (10259 - 7362))) then
				v82 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
		end
	end
	local function v143()
		local v174 = 0 - 0;
		while true do
			if ((v174 == (1 + 0)) or ((2173 + 296) > (1610 + 2066))) then
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v84 = EpicSettings.Settings['DispelDebuffs'];
				v83 = EpicSettings.Settings['DispelBuffs'];
				v174 = 559 - (395 + 162);
			end
			if (((205 + 28) < (2428 - (816 + 1125))) and (v174 == (2 - 0))) then
				v56 = EpicSettings.Settings['useTrinkets'];
				v57 = EpicSettings.Settings['useRacials'];
				v62 = EpicSettings.Settings['trinketsWithCD'];
				v174 = 1151 - (701 + 447);
			end
			if (((3809 - 1336) >= (351 - 150)) and ((1346 - (391 + 950)) == v174)) then
				v85 = EpicSettings.Settings['handleAfflicted'];
				v86 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((11102 - 6982) >= (332 - 199)) and (v174 == (9 - 5))) then
				v95 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v94 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v174 = 18 - 13;
			end
			if (((4602 - (251 + 1271)) >= (1769 + 217)) and (v174 == (0 - 0))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v174 = 1 - 0;
			end
			if ((v174 == (1262 - (1147 + 112))) or ((360 + 1079) > (7185 - 3647))) then
				v63 = EpicSettings.Settings['racialsWithCD'];
				v93 = EpicSettings.Settings['useHealthstone'];
				v92 = EpicSettings.Settings['useHealingPotion'];
				v174 = 2 + 2;
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
		if (v13:IsDeadOrGhost() or ((1116 - (335 + 362)) < (7 + 0))) then
			return v30;
		end
		v111 = v13:GetEnemiesInRange(60 - 20);
		v112 = v16:GetEnemiesInSplashRange(13 - 8);
		if (((10478 - 7658) == (13730 - 10910)) and v32) then
			v113 = #v111;
			v114 = v27(v16:GetEnemiesInSplashRangeCount(14 - 9), v113);
		else
			local v193 = 566 - (237 + 329);
			while true do
				if ((v193 == (0 - 0)) or ((2876 + 1486) <= (1930 + 1597))) then
					v113 = 1125 - (408 + 716);
					v114 = 3 - 2;
					break;
				end
			end
		end
		if (((3434 - (344 + 477)) <= (457 + 2223)) and v35 and v84) then
			local v194 = 1761 - (1188 + 573);
			while true do
				if ((v194 == (0 - 0)) or ((1444 + 38) >= (13911 - 9623))) then
					if ((v13:AffectingCombat() and v100.CleanseSpirit:IsAvailable()) or ((3805 - 1343) > (10946 - 6520))) then
						local v263 = v84 and v100.CleanseSpirit:IsReady() and v35;
						v30 = v104.FocusUnit(v263, nil, 1549 - (508 + 1021), nil, 24 + 1, v100.HealingSurge);
						if (((5940 - (228 + 938)) == (5459 - (332 + 353))) and v30) then
							return v30;
						end
					end
					if (((689 - 123) <= (2513 - 1553)) and v100.CleanseSpirit:IsAvailable()) then
						if ((v14 and v14:Exists() and v14:IsAPlayer() and v104.UnitHasCurseDebuff(v14)) or ((2758 + 152) <= (968 + 962))) then
							if (v100.CleanseSpirit:IsReady() or ((75 - 56) > (875 - (18 + 405)))) then
								if (v24(v102.CleanseSpiritMouseover) or ((416 + 491) > (1593 + 1559))) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
					break;
				end
			end
		end
		if (v104.TargetIsValid() or v13:AffectingCombat() or ((3817 - 1312) > (5448 - (194 + 784)))) then
			v107 = v9.BossFightRemains();
			v108 = v107;
			if ((v108 == (12881 - (694 + 1076))) or ((5615 - (122 + 1782)) > (3823 + 239))) then
				v108 = v9.FightRemains(v111, false);
			end
		end
		if (((392 + 28) == (379 + 41)) and not v13:IsChanneling() and not v13:IsCasting()) then
			local v195 = 0 + 0;
			while true do
				if ((v195 == (0 - 0)) or ((31 + 2) >= (5464 - (214 + 1756)))) then
					if (v85 or ((6124 - 4857) == (524 + 4220))) then
						local v264 = 0 + 0;
						while true do
							if (((3013 - (217 + 368)) < (11413 - 7635)) and (v264 == (0 + 0))) then
								if (v80 or ((2186 + 760) <= (54 + 1542))) then
									v30 = v104.HandleAfflicted(v100.CleanseSpirit, v102.CleanseSpiritMouseover, 929 - (844 + 45));
									if (((4717 - (242 + 42)) > (6259 - 3132)) and v30) then
										return v30;
									end
								end
								if (((9996 - 5696) >= (3933 - (132 + 1068))) and v81) then
									local v278 = 0 - 0;
									while true do
										if (((6452 - (214 + 1409)) == (3736 + 1093)) and (v278 == (1634 - (497 + 1137)))) then
											v30 = v104.HandleAfflicted(v100.TremorTotem, v100.TremorTotem, 970 - (9 + 931));
											if (((1972 - (181 + 108)) <= (2815 + 1911)) and v30) then
												return v30;
											end
											break;
										end
									end
								end
								v264 = 2 - 1;
							end
							if (((14359 - 9524) >= (866 + 2803)) and (v264 == (1 + 0))) then
								if (((3327 - (296 + 180)) > (3262 - (1183 + 220))) and v82) then
									v30 = v104.HandleAfflicted(v100.PoisonCleansingTotem, v100.PoisonCleansingTotem, 1295 - (1037 + 228));
									if (((6228 - 2380) > (6694 - 4371)) and v30) then
										return v30;
									end
								end
								break;
							end
						end
					end
					if (((9690 - 6854) > (1203 - (527 + 207))) and v13:AffectingCombat()) then
						local v265 = 527 - (187 + 340);
						while true do
							if (((1871 - (1298 + 572)) == v265) or ((5212 - 3116) <= (710 - (144 + 26)))) then
								if (v30 or ((7931 - 4748) < (6168 - 3523))) then
									return v30;
								end
								break;
							end
							if (((1155 + 2075) <= (10248 - 6488)) and (v265 == (0 - 0))) then
								if (((18556 - 14728) == (1945 + 1883)) and v33 and v91 and (v101.Dreambinder:IsEquippedAndReady() or v101.Iridal:IsEquippedAndReady())) then
									if (((751 - 197) == (518 + 36)) and v24(v102.UseWeapon, nil)) then
										return "Using Weapon Macro";
									end
								end
								v30 = v140();
								v265 = 1 + 0;
							end
						end
					else
						local v266 = 202 - (5 + 197);
						while true do
							if ((v266 == (686 - (339 + 347))) or ((5808 - 3245) == (605 - 433))) then
								v30 = v139();
								if (((4265 - (365 + 11)) >= (125 + 6)) and v30) then
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
	end
	local function v145()
		v100.FlameShockDebuff:RegisterAuraTracking();
		v106();
		v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(1007 - 745, v144, v145);
end;
return v0["Epix_Shaman_Elemental.lua"]();

