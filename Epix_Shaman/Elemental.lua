local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((1761 - (1293 + 164)) <= (123 + 502)) and not v5) then
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
	local v99 = v18.Shaman.Elemental;
	local v100 = v20.Shaman.Elemental;
	local v101 = v23.Shaman.Elemental;
	local v102 = {};
	local v103 = v21.Commons.Everyone;
	local v104 = v21.Commons.Shaman;
	local function v105()
		if (v99.CleanseSpirit:IsAvailable() or ((1817 - (1058 + 125)) == (453 + 1963))) then
			v103.DispellableDebuffs = v103.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v105();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		local v144 = 975 - (815 + 160);
		while true do
			if (((4732 - 3629) < (4225 - 2445)) and (v144 == (0 + 0))) then
				v99.PrimordialWave:RegisterInFlightEffect(956342 - 629180);
				v99.PrimordialWave:RegisterInFlight();
				v144 = 1899 - (41 + 1857);
			end
			if (((4577 - (1222 + 671)) > (1410 - 864)) and (v144 == (1 - 0))) then
				v99.LavaBurst:RegisterInFlight();
				break;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v99.PrimordialWave:RegisterInFlightEffect(328344 - (229 + 953));
	v99.PrimordialWave:RegisterInFlight();
	v99.LavaBurst:RegisterInFlight();
	local v106 = 12885 - (1111 + 663);
	local v107 = 12690 - (874 + 705);
	local v108, v109;
	local v110, v111;
	local v112 = 0 + 0;
	local v113 = 0 + 0;
	local v114 = 0 - 0;
	local v115 = 0 + 0;
	local v116 = 679 - (642 + 37);
	local function v117()
		return (10 + 30) - (v28() - v114);
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v145 = 0 + 0;
		local v146;
		local v147;
		local v148;
		while true do
			if (((3678 - 2213) <= (4755 - (233 + 221))) and (v145 == (0 - 0))) then
				v146, v147, v147, v147, v148 = select(8 + 0, ...);
				if (((3245 - (718 + 823)) > (897 + 528)) and (v146 == v13:GUID()) and (v148 == (192439 - (266 + 539)))) then
					local v235 = 0 - 0;
					while true do
						if ((v235 == (1225 - (636 + 589))) or ((1630 - 943) == (8732 - 4498))) then
							v115 = v28();
							C_Timer.After(0.1 + 0, function()
								if ((v115 ~= v116) or ((1210 + 2120) < (2444 - (657 + 358)))) then
									v114 = v115;
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
	local function v118(v149)
		return (v149:DebuffRefreshable(v99.FlameShockDebuff));
	end
	local function v119(v150)
		return v150:DebuffRefreshable(v99.FlameShockDebuff) and (v150:DebuffRemains(v99.FlameShockDebuff) < (v150:TimeToDie() - (13 - 8)));
	end
	local function v120(v151)
		return v151:DebuffRefreshable(v99.FlameShockDebuff) and (v151:DebuffRemains(v99.FlameShockDebuff) < (v151:TimeToDie() - (11 - 6))) and (v151:DebuffRemains(v99.FlameShockDebuff) > (1187 - (1151 + 36)));
	end
	local function v121(v152)
		return (v152:DebuffRemains(v99.FlameShockDebuff));
	end
	local function v122(v153)
		return v153:DebuffRemains(v99.FlameShockDebuff) > (2 + 0);
	end
	local function v123(v154)
		return (v154:DebuffRemains(v99.LightningRodDebuff));
	end
	local function v124()
		local v155 = v13:Maelstrom();
		if (((302 + 845) >= (1000 - 665)) and not v13:IsCasting()) then
			return v155;
		elseif (((5267 - (1552 + 280)) > (2931 - (64 + 770))) and v13:IsCasting(v99.ElementalBlast)) then
			return v155 - (51 + 24);
		elseif (v13:IsCasting(v99.Icefury) or ((8558 - 4788) >= (718 + 3323))) then
			return v155 + (1268 - (157 + 1086));
		elseif (v13:IsCasting(v99.LightningBolt) or ((7587 - 3796) <= (7055 - 5444))) then
			return v155 + (15 - 5);
		elseif (v13:IsCasting(v99.LavaBurst) or ((6248 - 1670) <= (2827 - (599 + 220)))) then
			return v155 + (23 - 11);
		elseif (((3056 - (1813 + 118)) <= (1518 + 558)) and v13:IsCasting(v99.ChainLightning)) then
			return v155 + ((1221 - (841 + 376)) * v113);
		else
			return v155;
		end
	end
	local function v125(v156)
		local v157 = v156:IsReady();
		if ((v156 == v99.Stormkeeper) or (v156 == v99.ElementalBlast) or (v156 == v99.Icefury) or ((1040 - 297) >= (1022 + 3377))) then
			local v187 = v13:BuffUp(v99.SpiritwalkersGraceBuff) or not v13:IsMoving();
			return v157 and v187 and not v13:IsCasting(v156);
		elseif (((3152 - 1997) < (2532 - (464 + 395))) and (v156 == v99.LavaBeam)) then
			local v232 = v13:BuffUp(v99.SpiritwalkersGraceBuff) or not v13:IsMoving();
			return v157 and v232;
		elseif ((v156 == v99.LightningBolt) or (v156 == v99.ChainLightning) or ((5964 - 3640) <= (278 + 300))) then
			local v255 = v13:BuffUp(v99.SpiritwalkersGraceBuff) or v13:BuffUp(v99.StormkeeperBuff) or not v13:IsMoving();
			return v157 and v255;
		elseif (((4604 - (467 + 370)) == (7784 - 4017)) and (v156 == v99.LavaBurst)) then
			local v257 = 0 + 0;
			local v258;
			local v259;
			local v260;
			local v261;
			while true do
				if (((14017 - 9928) == (638 + 3451)) and (v257 == (2 - 1))) then
					v260 = (v99.LavaBurst:Charges() >= (521 - (150 + 370))) and not v13:IsCasting(v99.LavaBurst);
					v261 = (v99.LavaBurst:Charges() == (1284 - (74 + 1208))) and v13:IsCasting(v99.LavaBurst);
					v257 = 4 - 2;
				end
				if (((21142 - 16684) >= (1192 + 482)) and (v257 == (392 - (14 + 376)))) then
					return v157 and v258 and (v259 or v260 or v261);
				end
				if (((1685 - 713) <= (918 + 500)) and (v257 == (0 + 0))) then
					v258 = v13:BuffUp(v99.SpiritwalkersGraceBuff) or v13:BuffUp(v99.LavaSurgeBuff) or not v13:IsMoving();
					v259 = v13:BuffUp(v99.LavaSurgeBuff);
					v257 = 1 + 0;
				end
			end
		elseif ((v156 == v99.PrimordialWave) or ((14468 - 9530) < (3583 + 1179))) then
			return v157 and v33 and v13:BuffDown(v99.PrimordialWaveBuff) and v13:BuffDown(v99.LavaSurgeBuff);
		else
			return v157;
		end
	end
	local function v126()
		local v158 = 78 - (23 + 55);
		local v159;
		while true do
			if ((v158 == (2 - 1)) or ((1671 + 833) > (3830 + 434))) then
				if (((3337 - 1184) == (678 + 1475)) and not v13:IsCasting()) then
					return v159;
				elseif (v13:IsCasting(v104.LavaBurst) or ((1408 - (652 + 249)) >= (6933 - 4342))) then
					return true;
				elseif (((6349 - (708 + 1160)) == (12163 - 7682)) and (v13:IsCasting(v104.ElementalBlast) or v13:IsCasting(v99.Icefury) or v13:IsCasting(v99.LightningBolt) or v13:IsCasting(v99.ChainLightning))) then
					return false;
				else
					return v159;
				end
				break;
			end
			if ((v158 == (0 - 0)) or ((2355 - (10 + 17)) < (156 + 537))) then
				if (((6060 - (1400 + 332)) == (8301 - 3973)) and not v99.MasteroftheElements:IsAvailable()) then
					return false;
				end
				v159 = v13:BuffUp(v99.MasteroftheElementsBuff);
				v158 = 1909 - (242 + 1666);
			end
		end
	end
	local function v127()
		local v160 = 0 + 0;
		local v161;
		while true do
			if (((582 + 1006) >= (1136 + 196)) and (v160 == (940 - (850 + 90)))) then
				if (not v99.PoweroftheMaelstrom:IsAvailable() or ((7310 - 3136) > (5638 - (360 + 1030)))) then
					return false;
				end
				v161 = v13:BuffStack(v99.PoweroftheMaelstromBuff);
				v160 = 1 + 0;
			end
			if ((v160 == (2 - 1)) or ((6308 - 1722) <= (1743 - (909 + 752)))) then
				if (((5086 - (109 + 1114)) == (7072 - 3209)) and not v13:IsCasting()) then
					return v161 > (0 + 0);
				elseif (((v161 == (243 - (6 + 236))) and (v13:IsCasting(v99.LightningBolt) or v13:IsCasting(v99.ChainLightning))) or ((178 + 104) <= (34 + 8))) then
					return false;
				else
					return v161 > (0 - 0);
				end
				break;
			end
		end
	end
	local function v128()
		if (((8049 - 3440) >= (1899 - (1076 + 57))) and not v99.Stormkeeper:IsAvailable()) then
			return false;
		end
		local v162 = v13:BuffUp(v99.StormkeeperBuff);
		if (not v13:IsCasting() or ((190 + 962) == (3177 - (579 + 110)))) then
			return v162;
		elseif (((271 + 3151) > (2962 + 388)) and v13:IsCasting(v99.Stormkeeper)) then
			return true;
		else
			return v162;
		end
	end
	local function v129()
		if (((466 + 411) > (783 - (174 + 233))) and not v99.Icefury:IsAvailable()) then
			return false;
		end
		local v163 = v13:BuffUp(v99.IcefuryBuff);
		if (not v13:IsCasting() or ((8709 - 5591) <= (3248 - 1397))) then
			return v163;
		elseif (v13:IsCasting(v99.Icefury) or ((74 + 91) >= (4666 - (663 + 511)))) then
			return true;
		else
			return v163;
		end
	end
	local function v130()
		if (((3523 + 426) < (1055 + 3801)) and v99.CleanseSpirit:IsReady() and v35 and v103.DispellableFriendlyUnit(77 - 52)) then
			if (v24(v101.CleanseSpiritFocus) or ((2590 + 1686) < (7100 - 4084))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v131()
		if (((11353 - 6663) > (1969 + 2156)) and v97 and (v13:HealthPercentage() <= v98)) then
			if (v99.HealingSurge:IsReady() or ((97 - 47) >= (639 + 257))) then
				if (v24(v99.HealingSurge) or ((157 + 1557) >= (3680 - (478 + 244)))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v132()
		local v164 = 517 - (440 + 77);
		while true do
			if ((v164 == (1 + 1)) or ((5457 - 3966) < (2200 - (655 + 901)))) then
				if (((131 + 573) < (756 + 231)) and v91 and (v13:HealthPercentage() <= v93)) then
					local v236 = 0 + 0;
					while true do
						if (((14978 - 11260) > (3351 - (695 + 750))) and ((0 - 0) == v236)) then
							if ((v95 == "Refreshing Healing Potion") or ((1478 - 520) > (14619 - 10984))) then
								if (((3852 - (285 + 66)) <= (10470 - 5978)) and v100.RefreshingHealingPotion:IsReady()) then
									if (v24(v101.RefreshingHealingPotion) or ((4752 - (682 + 628)) < (411 + 2137))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((3174 - (176 + 123)) >= (613 + 851)) and (v95 == "Dreamwalker's Healing Potion")) then
								if (v100.DreamwalkersHealingPotion:IsReady() or ((3480 + 1317) >= (5162 - (239 + 30)))) then
									if (v24(v101.RefreshingHealingPotion) or ((150 + 401) > (1988 + 80))) then
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
			if (((3741 - 1627) > (2945 - 2001)) and ((316 - (306 + 9)) == v164)) then
				if ((v99.HealingStreamTotem:IsReady() and v72 and v103.AreUnitsBelowHealthPercentage(v78, v79)) or ((7893 - 5631) >= (539 + 2557))) then
					if (v24(v99.HealingStreamTotem) or ((1384 + 871) >= (1703 + 1834))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v100.Healthstone:IsReady() and v92 and (v13:HealthPercentage() <= v94)) or ((10971 - 7134) < (2681 - (1140 + 235)))) then
					if (((1878 + 1072) == (2706 + 244)) and v24(v101.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				v164 = 1 + 1;
			end
			if (((52 - (33 + 19)) == v164) or ((1706 + 3017) < (9884 - 6586))) then
				if (((501 + 635) >= (301 - 147)) and v99.AstralShift:IsReady() and v71 and (v13:HealthPercentage() <= v77)) then
					if (v24(v99.AstralShift) or ((255 + 16) > (5437 - (586 + 103)))) then
						return "astral_shift defensive 1";
					end
				end
				if (((432 + 4308) >= (9703 - 6551)) and v99.AncestralGuidance:IsReady() and v70 and v103.AreUnitsBelowHealthPercentage(v75, v76)) then
					if (v24(v99.AncestralGuidance) or ((4066 - (1309 + 179)) >= (6120 - 2730))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v164 = 1 + 0;
			end
		end
	end
	local function v133()
		v30 = v103.HandleTopTrinket(v102, v33, 107 - 67, nil);
		if (((31 + 10) <= (3528 - 1867)) and v30) then
			return v30;
		end
		v30 = v103.HandleBottomTrinket(v102, v33, 79 - 39, nil);
		if (((1210 - (295 + 314)) < (8744 - 5184)) and v30) then
			return v30;
		end
	end
	local function v134()
		local v165 = 1962 - (1300 + 662);
		while true do
			if (((737 - 502) < (2442 - (1178 + 577))) and (v165 == (1 + 0))) then
				if (((13447 - 8898) > (2558 - (851 + 554))) and v125(v99.ElementalBlast) and v39) then
					if (v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast)) or ((4134 + 540) < (12956 - 8284))) then
						return "elemental_blast precombat 6";
					end
				end
				if (((7966 - 4298) < (4863 - (115 + 187))) and v13:IsCasting(v99.ElementalBlast) and v47 and ((v64 and v34) or not v64) and v125(v99.PrimordialWave)) then
					if (v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave)) or ((349 + 106) == (3413 + 192))) then
						return "primordial_wave precombat 8";
					end
				end
				v165 = 7 - 5;
			end
			if (((1161 - (160 + 1001)) == v165) or ((2330 + 333) == (2286 + 1026))) then
				if (((8754 - 4477) <= (4833 - (237 + 121))) and v125(v99.Stormkeeper) and (v99.Stormkeeper:CooldownRemains() == (897 - (525 + 372))) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107)) then
					if (v24(v99.Stormkeeper) or ((1649 - 779) == (3906 - 2717))) then
						return "stormkeeper precombat 2";
					end
				end
				if (((1695 - (96 + 46)) <= (3910 - (643 + 134))) and v125(v99.Icefury) and (v99.Icefury:CooldownRemains() == (0 + 0)) and v42) then
					if (v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury)) or ((5363 - 3126) >= (13035 - 9524))) then
						return "icefury precombat 4";
					end
				end
				v165 = 1 + 0;
			end
			if ((v165 == (3 - 1)) or ((2705 - 1381) > (3739 - (316 + 403)))) then
				if ((v13:IsCasting(v99.ElementalBlast) and v40 and not v99.PrimordialWave:IsAvailable() and v99.FlameShock:IsViable()) or ((1989 + 1003) == (5171 - 3290))) then
					if (((1123 + 1983) > (3842 - 2316)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if (((2143 + 880) < (1248 + 2622)) and v125(v99.LavaBurst) and v44 and not v13:IsCasting(v99.LavaBurst) and (not v99.ElementalBlast:IsAvailable() or (v99.ElementalBlast:IsAvailable() and not v99.ElementalBlast:IsAvailable()))) then
					if (((495 - 352) > (353 - 279)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v165 = 5 - 2;
			end
			if (((2 + 16) < (4157 - 2045)) and (v165 == (1 + 2))) then
				if (((3227 - 2130) <= (1645 - (12 + 5))) and v13:IsCasting(v99.LavaBurst) and v40 and v99.FlameShock:IsReady()) then
					if (((17983 - 13353) == (9878 - 5248)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flameshock precombat 14";
					end
				end
				if (((7524 - 3984) > (6653 - 3970)) and v13:IsCasting(v99.LavaBurst) and v47 and ((v64 and v34) or not v64) and v125(v99.PrimordialWave)) then
					if (((973 + 3821) >= (5248 - (1656 + 317))) and v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v166 = 0 + 0;
		while true do
			if (((1190 + 294) == (3945 - 2461)) and (v166 == (0 - 0))) then
				if (((1786 - (5 + 349)) < (16885 - 13330)) and v99.FireElemental:IsReady() and v53 and ((v59 and v33) or not v59) and (v90 < v107)) then
					if (v24(v99.FireElemental) or ((2336 - (266 + 1005)) > (2358 + 1220))) then
						return "fire_elemental aoe 2";
					end
				end
				if ((v99.StormElemental:IsReady() and v55 and ((v60 and v33) or not v60) and (v90 < v107)) or ((16360 - 11565) < (1852 - 445))) then
					if (((3549 - (561 + 1135)) < (6271 - 1458)) and v24(v99.StormElemental)) then
						return "storm_elemental aoe 4";
					end
				end
				if ((v125(v99.Stormkeeper) and not v128() and v48 and ((v65 and v34) or not v65) and (v90 < v107)) or ((9272 - 6451) < (3497 - (507 + 559)))) then
					if (v24(v99.Stormkeeper) or ((7211 - 4337) < (6745 - 4564))) then
						return "stormkeeper aoe 7";
					end
				end
				if ((v99.TotemicRecall:IsCastable() and (v99.LiquidMagmaTotem:CooldownRemains() > (433 - (212 + 176))) and v49) or ((3594 - (250 + 655)) <= (935 - 592))) then
					if (v24(v99.TotemicRecall) or ((3265 - 1396) == (3142 - 1133))) then
						return "totemic_recall aoe 8";
					end
				end
				if ((v99.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and (v66 == "cursor")) or ((5502 - (1869 + 87)) < (8053 - 5731))) then
					if (v24(v101.LiquidMagmaTotemCursor, not v16:IsInRange(1941 - (484 + 1417))) or ((4462 - 2380) == (7998 - 3225))) then
						return "liquid_magma_totem aoe cursor 10";
					end
				end
				if (((4017 - (48 + 725)) > (1723 - 668)) and v99.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and (v66 == "player")) then
					if (v24(v101.LiquidMagmaTotemPlayer, not v16:IsInRange(107 - 67)) or ((1926 + 1387) <= (4751 - 2973))) then
						return "liquid_magma_totem aoe player 11";
					end
				end
				v166 = 1 + 0;
			end
			if ((v166 == (2 + 2)) or ((2274 - (152 + 701)) >= (3415 - (430 + 881)))) then
				if (((694 + 1118) <= (4144 - (557 + 338))) and v125(v99.EarthShock) and v38 and v99.EchoesofGreatSundering:IsAvailable()) then
					if (((480 + 1143) <= (5514 - 3557)) and v24(v99.EarthShock, not v16:IsSpellInRange(v99.EarthShock))) then
						return "earth_shock aoe 60";
					end
				end
				if (((15449 - 11037) == (11721 - 7309)) and v125(v99.Icefury) and (v99.Icefury:CooldownRemains() == (0 - 0)) and v42 and not v13:BuffUp(v99.AscendanceBuff) and v99.ElectrifiedShocks:IsAvailable() and ((v99.LightningRod:IsAvailable() and (v113 < (806 - (499 + 302))) and not v126()) or (v99.DeeplyRootedElements:IsAvailable() and (v113 == (869 - (39 + 827)))))) then
					if (((4830 - 3080) >= (1880 - 1038)) and v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury))) then
						return "icefury aoe 62";
					end
				end
				if (((17364 - 12992) > (2840 - 990)) and v125(v99.FrostShock) and v41 and not v13:BuffUp(v99.AscendanceBuff) and v13:BuffUp(v99.IcefuryBuff) and v99.ElectrifiedShocks:IsAvailable() and (not v16:DebuffUp(v99.ElectrifiedShocksDebuff) or (v13:BuffRemains(v99.IcefuryBuff) < v13:GCD())) and ((v99.LightningRod:IsAvailable() and (v113 < (1 + 4)) and not v126()) or (v99.DeeplyRootedElements:IsAvailable() and (v113 == (8 - 5))))) then
					if (((38 + 194) < (1298 - 477)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
						return "frost_shock aoe 64";
					end
				end
				if (((622 - (103 + 1)) < (1456 - (475 + 79))) and v125(v99.LavaBurst) and v99.MasteroftheElements:IsAvailable() and not v126() and (v128() or ((v117() < (6 - 3)) and v13:HasTier(96 - 66, 1 + 1))) and (v124() < ((((53 + 7) - ((1508 - (1395 + 108)) * v99.EyeoftheStorm:TalentRank())) - ((5 - 3) * v25(v99.FlowofPower:IsAvailable()))) - (1214 - (7 + 1197)))) and (v113 < (3 + 2))) then
					local v237 = 0 + 0;
					while true do
						if (((3313 - (27 + 292)) > (2514 - 1656)) and (v237 == (0 - 0))) then
							if (v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst)) or ((15747 - 11992) <= (1804 - 889))) then
								return "lava_burst aoe 66";
							end
							if (((7515 - 3569) > (3882 - (43 + 96))) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst aoe 66";
							end
							break;
						end
					end
				end
				if ((v125(v99.LavaBeam) and v43 and (v128())) or ((5445 - 4110) >= (7474 - 4168))) then
					if (((4020 + 824) > (637 + 1616)) and v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam))) then
						return "lava_beam aoe 68";
					end
				end
				if (((892 - 440) == (174 + 278)) and v125(v99.ChainLightning) and v36 and (v128())) then
					if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((8539 - 3982) < (658 + 1429))) then
						return "chain_lightning aoe 70";
					end
				end
				v166 = 1 + 4;
			end
			if (((5625 - (1414 + 337)) == (5814 - (1642 + 298))) and (v166 == (15 - 9))) then
				if ((v125(v99.LavaBurst) and (v113 == (8 - 5)) and v99.MasteroftheElements:IsAvailable()) or ((5751 - 3813) > (1625 + 3310))) then
					if (v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst)) or ((3311 + 944) < (4395 - (357 + 615)))) then
						return "lava_burst aoe 84";
					end
					if (((1021 + 433) <= (6112 - 3621)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 84";
					end
				end
				if ((v125(v99.LavaBurst) and v13:BuffUp(v99.LavaSurgeBuff) and v99.DeeplyRootedElements:IsAvailable()) or ((3562 + 595) <= (6006 - 3203))) then
					if (((3882 + 971) >= (203 + 2779)) and v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 86";
					end
					if (((2599 + 1535) > (4658 - (384 + 917))) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 86";
					end
				end
				if ((v125(v99.Icefury) and (v99.Icefury:CooldownRemains() == (697 - (128 + 569))) and v42 and v99.ElectrifiedShocks:IsAvailable() and (v113 < (1548 - (1407 + 136)))) or ((5304 - (687 + 1200)) < (4244 - (556 + 1154)))) then
					if (v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury)) or ((9576 - 6854) <= (259 - (9 + 86)))) then
						return "icefury aoe 88";
					end
				end
				if ((v125(v99.FrostShock) and v41 and v13:BuffUp(v99.IcefuryBuff) and v99.ElectrifiedShocks:IsAvailable() and not v16:DebuffUp(v99.ElectrifiedShocksDebuff) and (v113 < (426 - (275 + 146))) and v99.UnrelentingCalamity:IsAvailable()) or ((392 + 2016) < (2173 - (29 + 35)))) then
					if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((146 - 113) == (4345 - 2890))) then
						return "frost_shock aoe 90";
					end
				end
				if ((v125(v99.LavaBeam) and v43 and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) or ((1955 - 1512) >= (2616 + 1399))) then
					if (((4394 - (53 + 959)) > (574 - (312 + 96))) and v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam))) then
						return "lava_beam aoe 92";
					end
				end
				if ((v125(v99.ChainLightning) and v36) or ((485 - 205) == (3344 - (147 + 138)))) then
					if (((2780 - (813 + 86)) > (1169 + 124)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
						return "chain_lightning aoe 94";
					end
				end
				v166 = 12 - 5;
			end
			if (((2849 - (18 + 474)) == (796 + 1561)) and (v166 == (16 - 11))) then
				if (((1209 - (860 + 226)) == (426 - (121 + 182))) and v125(v99.LavaBeam) and v43 and v127() and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) then
					if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((130 + 926) >= (4632 - (988 + 252)))) then
						return "lava_beam aoe 72";
					end
				end
				if ((v125(v99.ChainLightning) and v36 and v127()) or ((123 + 958) < (337 + 738))) then
					if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((3019 - (49 + 1921)) >= (5322 - (223 + 667)))) then
						return "chain_lightning aoe 74";
					end
				end
				if ((v125(v99.LavaBeam) and v43 and (v113 >= (58 - (51 + 1))) and v13:BuffUp(v99.SurgeofPowerBuff) and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) or ((8206 - 3438) <= (1811 - 965))) then
					if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((4483 - (146 + 979)) <= (401 + 1019))) then
						return "lava_beam aoe 76";
					end
				end
				if ((v125(v99.ChainLightning) and v36 and (v113 >= (611 - (311 + 294))) and v13:BuffUp(v99.SurgeofPowerBuff)) or ((10426 - 6687) <= (1273 + 1732))) then
					if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((3102 - (496 + 947)) >= (3492 - (1233 + 125)))) then
						return "chain_lightning aoe 78";
					end
				end
				if ((v125(v99.LavaBurst) and v13:BuffUp(v99.LavaSurgeBuff) and v99.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v99.WindspeakersLavaResurgenceBuff)) or ((1323 + 1937) < (2113 + 242))) then
					local v238 = 0 + 0;
					while true do
						if ((v238 == (1645 - (963 + 682))) or ((559 + 110) == (5727 - (504 + 1000)))) then
							if (v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst)) or ((1140 + 552) < (536 + 52))) then
								return "lava_burst aoe 80";
							end
							if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((453 + 4344) < (5383 - 1732))) then
								return "lava_burst aoe 80";
							end
							break;
						end
					end
				end
				if ((v125(v99.LavaBeam) and v43 and v126() and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) or ((3569 + 608) > (2821 + 2029))) then
					if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((582 - (156 + 26)) > (641 + 470))) then
						return "lava_beam aoe 82";
					end
				end
				v166 = 8 - 2;
			end
			if (((3215 - (149 + 15)) > (1965 - (890 + 70))) and (v166 == (124 - (39 + 78)))) then
				if (((4175 - (14 + 468)) <= (9635 - 5253)) and v99.FlameShock:IsCastable() and v40 and v13:IsMoving() and v16:DebuffRefreshable(v99.FlameShockDebuff)) then
					if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((9173 - 5891) > (2116 + 1984))) then
						return "flame_shock aoe 96";
					end
				end
				if ((v99.FrostShock:IsCastable() and v41 and v13:IsMoving()) or ((2150 + 1430) < (605 + 2239))) then
					if (((41 + 48) < (1177 + 3313)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
						return "frost_shock aoe 98";
					end
				end
				break;
			end
			if ((v166 == (1 - 0)) or ((4925 + 58) < (6353 - 4545))) then
				if (((97 + 3732) > (3820 - (12 + 39))) and v125(v99.PrimordialWave) and v13:BuffDown(v99.PrimordialWaveBuff) and v13:BuffUp(v99.SurgeofPowerBuff) and v13:BuffDown(v99.SplinteredElementsBuff)) then
					local v239 = 0 + 0;
					while true do
						if (((4596 - 3111) <= (10342 - 7438)) and (v239 == (0 + 0))) then
							if (((2248 + 2021) == (10824 - 6555)) and v103.CastTargetIf(v99.PrimordialWave, v111, "min", v121, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil)) then
								return "primordial_wave aoe 12";
							end
							if (((258 + 129) <= (13444 - 10662)) and v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave))) then
								return "primordial_wave aoe 12";
							end
							break;
						end
					end
				end
				if ((v125(v99.PrimordialWave) and v13:BuffDown(v99.PrimordialWaveBuff) and v99.DeeplyRootedElements:IsAvailable() and not v99.SurgeofPower:IsAvailable() and v13:BuffDown(v99.SplinteredElementsBuff)) or ((3609 - (1596 + 114)) <= (2394 - 1477))) then
					local v240 = 713 - (164 + 549);
					while true do
						if ((v240 == (1438 - (1059 + 379))) or ((5353 - 1041) <= (454 + 422))) then
							if (((377 + 1855) <= (2988 - (145 + 247))) and v103.CastTargetIf(v99.PrimordialWave, v111, "min", v121, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil)) then
								return "primordial_wave aoe 14";
							end
							if (((1720 + 375) < (1704 + 1982)) and v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave))) then
								return "primordial_wave aoe 14";
							end
							break;
						end
					end
				end
				if ((v125(v99.PrimordialWave) and v13:BuffDown(v99.PrimordialWaveBuff) and v99.MasteroftheElements:IsAvailable() and not v99.LightningRod:IsAvailable()) or ((4728 - 3133) >= (859 + 3615))) then
					if (v103.CastTargetIf(v99.PrimordialWave, v111, "min", v121, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil) or ((3979 + 640) < (4679 - 1797))) then
						return "primordial_wave aoe 16";
					end
					if (v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave)) or ((1014 - (254 + 466)) >= (5391 - (544 + 16)))) then
						return "primordial_wave aoe 16";
					end
				end
				if (((6448 - 4419) <= (3712 - (294 + 334))) and v99.FlameShock:IsCastable()) then
					local v241 = 253 - (236 + 17);
					while true do
						if (((2 + 1) == v241) or ((1586 + 451) == (9113 - 6693))) then
							if (((21106 - 16648) > (2011 + 1893)) and v99.DeeplyRootedElements:IsAvailable() and v40 and not v99.SurgeofPower:IsAvailable()) then
								if (((360 + 76) >= (917 - (413 + 381))) and v103.CastCycle(v99.FlameShock, v111, v120, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 30";
								end
								if (((22 + 478) < (3861 - 2045)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 30";
								end
							end
							break;
						end
						if (((9283 - 5709) == (5544 - (582 + 1388))) and (v241 == (1 - 0))) then
							if (((159 + 62) < (754 - (326 + 38))) and v99.MasteroftheElements:IsAvailable() and v40 and not v99.LightningRod:IsAvailable() and (v99.FlameShockDebuff:AuraActiveCount() < (17 - 11))) then
								if (v103.CastCycle(v99.FlameShock, v111, v119, not v16:IsSpellInRange(v99.FlameShock)) or ((3158 - 945) <= (2041 - (47 + 573)))) then
									return "flame_shock aoe 22";
								end
								if (((1078 + 1980) < (20640 - 15780)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 22";
								end
							end
							if ((v99.DeeplyRootedElements:IsAvailable() and v40 and not v99.SurgeofPower:IsAvailable() and (v99.FlameShockDebuff:AuraActiveCount() < (9 - 3))) or ((2960 - (1269 + 395)) >= (4938 - (76 + 416)))) then
								if (v103.CastCycle(v99.FlameShock, v111, v119, not v16:IsSpellInRange(v99.FlameShock)) or ((1836 - (319 + 124)) > (10261 - 5772))) then
									return "flame_shock aoe 24";
								end
								if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((5431 - (564 + 443)) < (74 - 47))) then
									return "flame_shock aoe 24";
								end
							end
							v241 = 460 - (337 + 121);
						end
						if ((v241 == (5 - 3)) or ((6652 - 4655) > (5726 - (1261 + 650)))) then
							if (((1466 + 1999) > (3047 - 1134)) and v13:BuffUp(v99.SurgeofPowerBuff) and v40 and (not v99.LightningRod:IsAvailable() or v99.SkybreakersFieryDemise:IsAvailable())) then
								local v266 = 1817 - (772 + 1045);
								while true do
									if (((104 + 629) < (1963 - (102 + 42))) and ((1844 - (1524 + 320)) == v266)) then
										if (v103.CastCycle(v99.FlameShock, v111, v120, not v16:IsSpellInRange(v99.FlameShock)) or ((5665 - (1049 + 221)) == (4911 - (18 + 138)))) then
											return "flame_shock aoe 26";
										end
										if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((9284 - 5491) < (3471 - (67 + 1035)))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if ((v99.MasteroftheElements:IsAvailable() and v40 and not v99.LightningRod:IsAvailable() and not v99.SurgeofPower:IsAvailable()) or ((4432 - (136 + 212)) == (1126 - 861))) then
								if (((3492 + 866) == (4018 + 340)) and v103.CastCycle(v99.FlameShock, v111, v120, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 28";
								end
								if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((4742 - (240 + 1364)) < (2075 - (1050 + 32)))) then
									return "flame_shock aoe 28";
								end
							end
							v241 = 10 - 7;
						end
						if (((1970 + 1360) > (3378 - (331 + 724))) and (v241 == (0 + 0))) then
							if ((v13:BuffUp(v99.SurgeofPowerBuff) and v40 and v99.LightningRod:IsAvailable() and v99.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v99.FlameShockDebuff) < (v16:TimeToDie() - (660 - (269 + 375)))) and (v110 < (730 - (267 + 458)))) or ((1128 + 2498) == (7670 - 3681))) then
								if (v103.CastCycle(v99.FlameShock, v111, v119, not v16:IsSpellInRange(v99.FlameShock)) or ((1734 - (667 + 151)) == (4168 - (1410 + 87)))) then
									return "flame_shock aoe 18";
								end
								if (((2169 - (1504 + 393)) == (735 - 463)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 18";
								end
							end
							if (((11023 - 6774) <= (5635 - (461 + 335))) and v13:BuffUp(v99.SurgeofPowerBuff) and v40 and (not v99.LightningRod:IsAvailable() or v99.SkybreakersFieryDemise:IsAvailable()) and (v99.FlameShockDebuff:AuraActiveCount() < (1 + 5))) then
								local v267 = 1761 - (1730 + 31);
								while true do
									if (((4444 - (728 + 939)) < (11333 - 8133)) and ((0 - 0) == v267)) then
										if (((217 - 122) < (3025 - (138 + 930))) and v103.CastCycle(v99.FlameShock, v111, v119, not v16:IsSpellInRange(v99.FlameShock))) then
											return "flame_shock aoe 20";
										end
										if (((755 + 71) < (1343 + 374)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
											return "flame_shock aoe 20";
										end
										break;
									end
								end
							end
							v241 = 1 + 0;
						end
					end
				end
				if (((5822 - 4396) >= (2871 - (459 + 1307))) and v99.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v107)) then
					if (((4624 - (474 + 1396)) <= (5900 - 2521)) and v24(v99.Ascendance)) then
						return "ascendance aoe 32";
					end
				end
				if ((v125(v99.LavaBurst) and (v113 == (3 + 0)) and not v99.LightningRod:IsAvailable() and v13:HasTier(1 + 30, 11 - 7)) or ((498 + 3429) == (4716 - 3303))) then
					if (v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst)) or ((5032 - 3878) <= (1379 - (562 + 29)))) then
						return "lava_burst aoe 34";
					end
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((1401 + 242) > (4798 - (374 + 1045)))) then
						return "lava_burst aoe 34";
					end
				end
				v166 = 2 + 0;
			end
			if ((v166 == (5 - 3)) or ((3441 - (448 + 190)) > (1469 + 3080))) then
				if ((v37 and v99.Earthquake:IsReady() and v126() and (((v13:BuffStack(v99.MagmaChamberBuff) > (7 + 8)) and (v113 >= ((5 + 2) - v25(v99.UnrelentingCalamity:IsAvailable())))) or (v99.SplinteredElements:IsAvailable() and (v113 >= ((38 - 28) - v25(v99.UnrelentingCalamity:IsAvailable())))) or (v99.MountainsWillFall:IsAvailable() and (v113 >= (27 - 18)))) and not v99.LightningRod:IsAvailable() and v13:HasTier(1525 - (1307 + 187), 15 - 11)) or ((515 - 295) >= (9266 - 6244))) then
					local v242 = 683 - (232 + 451);
					while true do
						if (((2695 + 127) == (2493 + 329)) and (v242 == (564 - (510 + 54)))) then
							if ((v51 == "cursor") or ((2137 - 1076) == (1893 - (13 + 23)))) then
								if (((5380 - 2620) > (1959 - 595)) and v24(v101.EarthquakeCursor, not v16:IsInRange(72 - 32))) then
									return "earthquake aoe 36";
								end
							end
							if ((v51 == "player") or ((5990 - (830 + 258)) <= (12681 - 9086))) then
								if (v24(v101.EarthquakePlayer, not v16:IsInRange(26 + 14)) or ((3278 + 574) == (1734 - (860 + 581)))) then
									return "earthquake aoe 36";
								end
							end
							break;
						end
					end
				end
				if ((v125(v99.LavaBeam) and v43 and v128() and ((v13:BuffUp(v99.SurgeofPowerBuff) and (v113 >= (22 - 16))) or (v126() and ((v113 < (5 + 1)) or not v99.SurgeofPower:IsAvailable()))) and not v99.LightningRod:IsAvailable() and v13:HasTier(272 - (237 + 4), 9 - 5)) or ((3943 - 2384) == (8698 - 4110))) then
					if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((3671 + 813) == (453 + 335))) then
						return "lava_beam aoe 38";
					end
				end
				if (((17245 - 12677) >= (1677 + 2230)) and v125(v99.ChainLightning) and v36 and v128() and ((v13:BuffUp(v99.SurgeofPowerBuff) and (v113 >= (4 + 2))) or (v126() and ((v113 < (1432 - (85 + 1341))) or not v99.SurgeofPower:IsAvailable()))) and not v99.LightningRod:IsAvailable() and v13:HasTier(52 - 21, 11 - 7)) then
					if (((1618 - (45 + 327)) < (6548 - 3078)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
						return "chain_lightning aoe 40";
					end
				end
				if (((4570 - (444 + 58)) >= (423 + 549)) and v125(v99.LavaBurst) and v13:BuffUp(v99.LavaSurgeBuff) and not v99.LightningRod:IsAvailable() and v13:HasTier(6 + 25, 2 + 2)) then
					local v243 = 0 - 0;
					while true do
						if (((2225 - (64 + 1668)) < (5866 - (1227 + 746))) and (v243 == (0 - 0))) then
							if (v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst)) or ((2733 - 1260) >= (3826 - (415 + 79)))) then
								return "lava_burst aoe 42";
							end
							if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((105 + 3946) <= (1648 - (142 + 349)))) then
								return "lava_burst aoe 42";
							end
							break;
						end
					end
				end
				if (((259 + 345) < (3961 - 1080)) and v125(v99.LavaBurst) and v13:BuffUp(v99.LavaSurgeBuff) and v99.MasteroftheElements:IsAvailable() and not v126() and (v124() >= (((30 + 30) - ((4 + 1) * v99.EyeoftheStorm:TalentRank())) - ((5 - 3) * v25(v99.FlowofPower:IsAvailable())))) and ((not v99.EchoesofGreatSundering:IsAvailable() and not v99.LightningRod:IsAvailable()) or v13:BuffUp(v99.EchoesofGreatSunderingBuff)) and ((not v13:BuffUp(v99.AscendanceBuff) and (v113 > (1867 - (1710 + 154))) and v99.UnrelentingCalamity:IsAvailable()) or ((v113 > (321 - (200 + 118))) and not v99.UnrelentingCalamity:IsAvailable()) or (v113 == (2 + 1)))) then
					local v244 = 0 - 0;
					while true do
						if ((v244 == (0 - 0)) or ((800 + 100) == (3341 + 36))) then
							if (((2393 + 2066) > (95 + 496)) and v103.CastCycle(v99.LavaBurst, v111, v121, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst aoe 44";
							end
							if (((7361 - 3963) >= (3645 - (363 + 887))) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst aoe 44";
							end
							break;
						end
					end
				end
				if ((v37 and v99.Earthquake:IsReady() and not v99.EchoesofGreatSundering:IsAvailable() and (v113 > (5 - 2)) and ((v113 > (14 - 11)) or (v112 > (1 + 2)))) or ((5107 - 2924) >= (1930 + 894))) then
					local v245 = 1664 - (674 + 990);
					while true do
						if (((556 + 1380) == (793 + 1143)) and ((0 - 0) == v245)) then
							if ((v51 == "cursor") or ((5887 - (507 + 548)) < (5150 - (289 + 548)))) then
								if (((5906 - (821 + 997)) > (4129 - (195 + 60))) and v24(v101.EarthquakeCursor, not v16:IsInRange(11 + 29))) then
									return "earthquake aoe 46";
								end
							end
							if (((5833 - (251 + 1250)) == (12690 - 8358)) and (v51 == "player")) then
								if (((2748 + 1251) >= (3932 - (809 + 223))) and v24(v101.EarthquakePlayer, not v16:IsInRange(58 - 18))) then
									return "earthquake aoe 46";
								end
							end
							break;
						end
					end
				end
				v166 = 8 - 5;
			end
			if ((v166 == (9 - 6)) or ((1860 + 665) > (2129 + 1935))) then
				if (((4988 - (14 + 603)) == (4500 - (118 + 11))) and v37 and v99.Earthquake:IsReady() and not v99.EchoesofGreatSundering:IsAvailable() and not v99.ElementalBlast:IsAvailable() and (v113 == (1 + 2)) and ((v113 == (3 + 0)) or (v112 == (8 - 5)))) then
					if ((v51 == "cursor") or ((1215 - (551 + 398)) > (3152 + 1834))) then
						if (((709 + 1282) >= (752 + 173)) and v24(v101.EarthquakeCursor, not v16:IsInRange(148 - 108))) then
							return "earthquake aoe 48";
						end
					end
					if (((1048 - 593) < (666 + 1387)) and (v51 == "player")) then
						if (v24(v101.EarthquakePlayer, not v16:IsInRange(158 - 118)) or ((229 + 597) == (4940 - (40 + 49)))) then
							return "earthquake aoe 48";
						end
					end
				end
				if (((696 - 513) == (673 - (99 + 391))) and v37 and v99.Earthquake:IsReady() and (v13:BuffUp(v99.EchoesofGreatSunderingBuff))) then
					if (((959 + 200) <= (7859 - 6071)) and (v51 == "cursor")) then
						if (v24(v101.EarthquakeCursor, not v16:IsInRange(99 - 59)) or ((3417 + 90) > (11361 - 7043))) then
							return "earthquake aoe 50";
						end
					end
					if ((v51 == "player") or ((4679 - (1032 + 572)) <= (3382 - (203 + 214)))) then
						if (((3182 - (568 + 1249)) <= (1574 + 437)) and v24(v101.EarthquakePlayer, not v16:IsInRange(96 - 56))) then
							return "earthquake aoe 50";
						end
					end
				end
				if ((v125(v99.ElementalBlast) and v39 and v99.EchoesofGreatSundering:IsAvailable()) or ((10722 - 7946) > (4881 - (913 + 393)))) then
					if (v103.CastTargetIf(v99.ElementalBlast, v111, "min", v123, nil, not v16:IsSpellInRange(v99.ElementalBlast), nil, nil) or ((7212 - 4658) == (6787 - 1983))) then
						return "elemental_blast aoe 52";
					end
					if (((2987 - (269 + 141)) == (5731 - 3154)) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
						return "elemental_blast aoe 52";
					end
				end
				if ((v125(v99.ElementalBlast) and v39 and v99.EchoesofGreatSundering:IsAvailable()) or ((1987 - (362 + 1619)) >= (3514 - (950 + 675)))) then
					if (((196 + 310) <= (3071 - (216 + 963))) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
						return "elemental_blast aoe 54";
					end
				end
				if ((v125(v99.ElementalBlast) and v39 and (v113 == (1290 - (485 + 802))) and not v99.EchoesofGreatSundering:IsAvailable()) or ((2567 - (432 + 127)) > (3291 - (1065 + 8)))) then
					if (((211 + 168) <= (5748 - (635 + 966))) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
						return "elemental_blast aoe 56";
					end
				end
				if ((v125(v99.EarthShock) and v38 and v99.EchoesofGreatSundering:IsAvailable()) or ((3246 + 1268) <= (1051 - (5 + 37)))) then
					local v246 = 0 - 0;
					while true do
						if (((0 + 0) == v246) or ((5533 - 2037) == (558 + 634))) then
							if (v103.CastTargetIf(v99.EarthShock, v111, "min", v123, nil, not v16:IsSpellInRange(v99.EarthShock), nil, nil) or ((431 - 223) == (11218 - 8259))) then
								return "earth_shock aoe 58";
							end
							if (((8065 - 3788) >= (3139 - 1826)) and v24(v99.EarthShock, not v16:IsSpellInRange(v99.EarthShock))) then
								return "earth_shock aoe 58";
							end
							break;
						end
					end
				end
				v166 = 3 + 1;
			end
		end
	end
	local function v136()
		local v167 = 529 - (318 + 211);
		while true do
			if (((12729 - 10142) < (4761 - (963 + 624))) and (v167 == (1 + 1))) then
				if ((v125(v99.Stormkeeper) and (v99.Stormkeeper:CooldownRemains() == (846 - (518 + 328))) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and v13:BuffDown(v99.AscendanceBuff) and not v128() and (v124() >= (270 - 154)) and v99.ElementalBlast:IsAvailable() and v99.SurgeofPower:IsAvailable() and v99.SwellingMaelstrom:IsAvailable() and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.PrimordialSurge:IsAvailable()) or ((6585 - 2465) <= (2515 - (301 + 16)))) then
					if (v24(v99.Stormkeeper) or ((4677 - 3081) == (2409 - 1551))) then
						return "stormkeeper single_target 18";
					end
				end
				if (((8402 - 5182) == (2917 + 303)) and v125(v99.Stormkeeper) and (v99.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and v13:BuffDown(v99.AscendanceBuff) and not v128() and v13:BuffUp(v99.SurgeofPowerBuff) and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.PrimordialSurge:IsAvailable()) then
					if (v24(v99.Stormkeeper) or ((2992 - 1590) > (2178 + 1442))) then
						return "stormkeeper single_target 20";
					end
				end
				if (((245 + 2329) == (8183 - 5609)) and v125(v99.Stormkeeper) and (v99.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and v13:BuffDown(v99.AscendanceBuff) and not v128() and (not v99.SurgeofPower:IsAvailable() or not v99.ElementalBlast:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.EchooftheElements:IsAvailable() or v99.PrimordialSurge:IsAvailable())) then
					if (((2817 - (829 + 190)) < (9836 - 7079)) and v24(v99.Stormkeeper)) then
						return "stormkeeper single_target 22";
					end
				end
				if ((v99.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v107) and not v128()) or ((476 - 99) > (3599 - 995))) then
					if (((1410 - 842) < (216 + 695)) and v24(v99.Ascendance)) then
						return "ascendance single_target 24";
					end
				end
				v167 = 1 + 2;
			end
			if (((9970 - 6685) < (3990 + 238)) and (v167 == (613 - (520 + 93)))) then
				if (((4192 - (259 + 17)) > (192 + 3136)) and v99.FireElemental:IsCastable() and v53 and ((v59 and v33) or not v59) and (v90 < v107)) then
					if (((900 + 1600) < (12996 - 9157)) and v24(v99.FireElemental)) then
						return "fire_elemental single_target 2";
					end
				end
				if (((1098 - (396 + 195)) == (1470 - 963)) and v99.StormElemental:IsCastable() and v55 and ((v60 and v33) or not v60) and (v90 < v107)) then
					if (((2001 - (440 + 1321)) <= (4994 - (1059 + 770))) and v24(v99.StormElemental)) then
						return "storm_elemental single_target 4";
					end
				end
				if (((3856 - 3022) >= (1350 - (424 + 121))) and v99.TotemicRecall:IsCastable() and v49 and (v99.LiquidMagmaTotem:CooldownRemains() > (9 + 36)) and ((v99.LavaSurge:IsAvailable() and v99.SplinteredElements:IsAvailable()) or ((v112 > (1348 - (641 + 706))) and (v113 > (1 + 0))))) then
					if (v24(v99.TotemicRecall) or ((4252 - (249 + 191)) < (10089 - 7773))) then
						return "totemic_recall single_target 6";
					end
				end
				if ((v99.LiquidMagmaTotem:IsCastable() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and ((v99.LavaSurge:IsAvailable() and v99.SplinteredElements:IsAvailable()) or (v99.FlameShockDebuff:AuraActiveCount() == (0 + 0)) or (v16:DebuffRemains(v99.FlameShockDebuff) < (22 - 16)) or ((v112 > (428 - (183 + 244))) and (v113 > (1 + 0))))) or ((3382 - (434 + 296)) <= (4891 - 3358))) then
					if ((v66 == "cursor") or ((4110 - (169 + 343)) < (1280 + 180))) then
						if (v24(v101.LiquidMagmaTotemCursor, not v16:IsInRange(70 - 30)) or ((12081 - 7965) < (977 + 215))) then
							return "liquid_magma_totem single_target cursor 8";
						end
					end
					if ((v66 == "player") or ((9577 - 6200) <= (2026 - (651 + 472)))) then
						if (((3005 + 971) >= (190 + 249)) and v24(v101.LiquidMagmaTotemPlayer, not v16:IsInRange(48 - 8))) then
							return "liquid_magma_totem single_target player 8";
						end
					end
				end
				v167 = 484 - (397 + 86);
			end
			if (((4628 - (423 + 453)) == (382 + 3370)) and (v167 == (1 + 6))) then
				if (((3533 + 513) > (2151 + 544)) and v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v13:BuffDown(v99.AscendanceBuff) and (not v99.ElementalBlast:IsAvailable() or not v99.MountainsWillFall:IsAvailable()) and not v99.LightningRod:IsAvailable() and v13:HasTier(28 + 3, 1194 - (50 + 1140))) then
					local v247 = 0 + 0;
					while true do
						if ((v247 == (0 + 0)) or ((221 + 3324) == (4590 - 1393))) then
							if (((1733 + 661) > (969 - (157 + 439))) and v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst single_target 58";
							end
							if (((7224 - 3069) <= (14061 - 9829)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst single_target 58";
							end
							break;
						end
					end
				end
				if ((v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v99.MasteroftheElements:IsAvailable() and not v126() and not v99.LightningRod:IsAvailable()) or ((10592 - 7011) == (4391 - (782 + 136)))) then
					local v248 = 855 - (112 + 743);
					while true do
						if (((6166 - (1026 + 145)) > (575 + 2773)) and ((718 - (493 + 225)) == v248)) then
							if (v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst)) or ((2771 - 2017) > (2266 + 1458))) then
								return "lava_burst single_target 60";
							end
							if (((581 - 364) >= (2 + 55)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst single_target 60";
							end
							break;
						end
					end
				end
				if ((v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v99.MasteroftheElements:IsAvailable() and not v126() and ((v124() >= (214 - 139)) or ((v124() >= (15 + 35)) and not v99.ElementalBlast:IsAvailable())) and v99.SwellingMaelstrom:IsAvailable() and (v124() <= (217 - 87))) or ((3665 - (210 + 1385)) >= (5726 - (1201 + 488)))) then
					if (((1677 + 1028) == (4810 - 2105)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst single_target 62";
					end
				end
				if (((109 - 48) == (646 - (352 + 233))) and v99.Earthquake:IsReady() and v37 and v13:BuffUp(v99.EchoesofGreatSunderingBuff) and ((not v99.ElementalBlast:IsAvailable() and (v112 < (4 - 2))) or (v112 > (1 + 0)))) then
					local v249 = 0 - 0;
					while true do
						if ((v249 == (574 - (489 + 85))) or ((2200 - (277 + 1224)) >= (2789 - (663 + 830)))) then
							if ((v51 == "cursor") or ((1567 + 216) >= (8854 - 5238))) then
								if (v24(v101.EarthquakeCursor, not v16:IsInRange(915 - (461 + 414))) or ((656 + 3257) > (1812 + 2715))) then
									return "earthquake single_target 64";
								end
							end
							if (((417 + 3959) > (806 + 11)) and (v51 == "player")) then
								if (((5111 - (172 + 78)) > (1328 - 504)) and v24(v101.EarthquakePlayer, not v16:IsInRange(15 + 25))) then
									return "earthquake single_target 64";
								end
							end
							break;
						end
					end
				end
				v167 = 10 - 2;
			end
			if ((v167 == (4 + 9)) or ((462 + 921) >= (3570 - 1439))) then
				if ((v99.FrostShock:IsCastable() and v41 and v129() and not v99.ElectrifiedShocks:IsAvailable() and not v99.FluxMelting:IsAvailable()) or ((2361 - 485) >= (639 + 1902))) then
					if (((986 + 796) <= (1343 + 2429)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
						return "frost_shock single_target 106";
					end
				end
				if ((v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and (v112 > (3 - 2)) and (v113 > (2 - 1))) or ((1442 + 3258) < (465 + 348))) then
					if (((3646 - (133 + 314)) < (705 + 3345)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
						return "chain_lightning single_target 108";
					end
				end
				if ((v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45) or ((5164 - (199 + 14)) < (15858 - 11428))) then
					if (((1645 - (647 + 902)) == (288 - 192)) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
						return "lightning_bolt single_target 110";
					end
				end
				if ((v99.FlameShock:IsCastable() and v40 and (v13:IsMoving())) or ((2972 - (85 + 148)) > (5297 - (426 + 863)))) then
					local v250 = 0 - 0;
					while true do
						if ((v250 == (1654 - (873 + 781))) or ((30 - 7) == (3062 - 1928))) then
							if (v103.CastCycle(v99.FlameShock, v111, v118, not v16:IsSpellInRange(v99.FlameShock)) or ((1116 + 1577) >= (15187 - 11076))) then
								return "flame_shock single_target 112";
							end
							if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((6185 - 1869) <= (6372 - 4226))) then
								return "flame_shock single_target 112";
							end
							break;
						end
					end
				end
				v167 = 1961 - (414 + 1533);
			end
			if ((v167 == (4 + 0)) or ((4101 - (443 + 112)) <= (4288 - (888 + 591)))) then
				if (((12671 - 7767) > (124 + 2042)) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v128() and not v99.SurgeofPower:IsAvailable() and v126()) then
					if (((410 - 301) >= (36 + 54)) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
						return "lightning_bolt single_target 34";
					end
				end
				if (((2408 + 2570) > (311 + 2594)) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v128() and not v99.SurgeofPower:IsAvailable() and not v99.MasteroftheElements:IsAvailable()) then
					if (v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt)) or ((5766 - 2740) <= (4223 - 1943))) then
						return "lightning_bolt single_target 36";
					end
				end
				if ((v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v13:BuffUp(v99.SurgeofPowerBuff) and v99.LightningRod:IsAvailable()) or ((3331 - (136 + 1542)) <= (3633 - 2525))) then
					if (((2888 + 21) > (4148 - 1539)) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
						return "lightning_bolt single_target 38";
					end
				end
				if (((548 + 209) > (680 - (68 + 418))) and v125(v99.Icefury) and (v99.Icefury:CooldownRemains() == (0 - 0)) and v42 and v99.ElectrifiedShocks:IsAvailable() and v99.LightningRod:IsAvailable() and v99.LightningRod:IsAvailable()) then
					if (v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury)) or ((55 - 24) >= (1207 + 191))) then
						return "icefury single_target 40";
					end
				end
				v167 = 1097 - (770 + 322);
			end
			if (((185 + 3011) <= (1410 + 3462)) and (v167 == (2 + 12))) then
				if (((4758 - 1432) == (6448 - 3122)) and v99.FlameShock:IsCastable() and v40) then
					if (((3902 - 2469) <= (14264 - 10386)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flame_shock single_target 114";
					end
				end
				if ((v99.FrostShock:IsCastable() and v41) or ((882 + 701) == (2599 - 864))) then
					if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((1430 + 1551) == (1441 + 909))) then
						return "frost_shock single_target 116";
					end
				end
				break;
			end
			if ((v167 == (8 + 2)) or ((16817 - 12351) <= (684 - 191))) then
				if ((v99.FrostShock:IsCastable() and v41 and v129() and ((v99.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v99.ElectrifiedShocksDebuff) < (1 + 1))) or (v13:BuffRemains(v99.IcefuryBuff) < (27 - 21)))) or ((8419 - 5872) <= (818 + 1169))) then
					if (((14652 - 11691) > (3571 - (762 + 69))) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
						return "frost_shock single_target 82";
					end
				end
				if (((11967 - 8271) >= (3112 + 500)) and v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and (v99.EchooftheElements:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.PrimordialSurge:IsAvailable() or not v99.ElementalBlast:IsAvailable() or not v99.MasteroftheElements:IsAvailable() or v128())) then
					if (v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst)) or ((1923 + 1047) == (4542 - 2664))) then
						return "lava_burst single_target 84";
					end
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((1162 + 2531) < (32 + 1945))) then
						return "lava_burst single_target 84";
					end
				end
				if ((v125(v99.ElementalBlast) and v99.ElementalBlast:IsCastable() and v39) or ((3623 - 2693) > (2258 - (8 + 149)))) then
					if (((5473 - (1199 + 121)) > (5221 - 2135)) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
						return "elemental_blast single_target 86";
					end
				end
				if ((v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and v127() and v99.UnrelentingCalamity:IsAvailable() and (v112 > (2 - 1)) and (v113 > (1 + 0))) or ((16611 - 11957) <= (9397 - 5347))) then
					if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((2302 + 300) < (3303 - (518 + 1289)))) then
						return "chain_lightning single_target 88";
					end
				end
				v167 = 18 - 7;
			end
			if ((v167 == (1 + 4)) or ((1489 - 469) > (1686 + 602))) then
				if (((797 - (304 + 165)) == (310 + 18)) and v99.FrostShock:IsCastable() and v41 and v129() and v99.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v99.ElectrifiedShocksDebuff) < (162 - (54 + 106))) or (v13:BuffRemains(v99.IcefuryBuff) <= v13:GCD())) and v99.LightningRod:IsAvailable()) then
					if (((3480 - (1618 + 351)) < (2686 + 1122)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
						return "frost_shock single_target 42";
					end
				end
				if ((v99.FrostShock:IsCastable() and v41 and v129() and v99.ElectrifiedShocks:IsAvailable() and (v124() >= (1066 - (10 + 1006))) and (v16:DebuffRemains(v99.ElectrifiedShocksDebuff) < ((1 + 1) * v13:GCD())) and v128() and v99.LightningRod:IsAvailable()) or ((352 + 2158) > (15946 - 11027))) then
					if (((5796 - (912 + 121)) == (2251 + 2512)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
						return "frost_shock single_target 44";
					end
				end
				if (((5426 - (1140 + 149)) > (1183 + 665)) and v99.LavaBeam:IsCastable() and v43 and (v112 > (1 - 0)) and (v113 > (1 + 0)) and v127() and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime()) and not v13:HasTier(106 - 75, 7 - 3)) then
					if (((421 + 2015) <= (10875 - 7741)) and v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam))) then
						return "lava_beam single_target 46";
					end
				end
				if (((3909 - (165 + 21)) == (3834 - (61 + 50))) and v99.FrostShock:IsCastable() and v41 and v129() and v128() and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.PrimordialSurge:IsAvailable() and v99.ElementalBlast:IsAvailable() and (((v124() >= (26 + 35)) and (v124() < (357 - 282)) and (v99.LavaBurst:CooldownRemains() > v13:GCD())) or ((v124() >= (98 - 49)) and (v124() < (25 + 38)) and (v99.LavaBurst:CooldownRemains() > (1460 - (1295 + 165)))))) then
					if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((924 + 3122) >= (1736 + 2580))) then
						return "frost_shock single_target 48";
					end
				end
				v167 = 1403 - (819 + 578);
			end
			if ((v167 == (1405 - (331 + 1071))) or ((2751 - (588 + 155)) < (3211 - (546 + 736)))) then
				if (((4321 - (1834 + 103)) > (1092 + 683)) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v128() and v13:BuffUp(v99.SurgeofPowerBuff)) then
					if (v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt)) or ((13552 - 9009) <= (6142 - (1536 + 230)))) then
						return "lightning_bolt single_target 26";
					end
				end
				if (((1219 - (128 + 363)) == (155 + 573)) and v125(v99.LavaBeam) and v43 and (v112 > (2 - 1)) and (v113 > (1 + 0)) and v128() and not v99.SurgeofPower:IsAvailable()) then
					if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((1781 - 705) > (13751 - 9080))) then
						return "lava_beam single_target 28";
					end
				end
				if (((4495 - 2644) >= (260 + 118)) and v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and (v112 > (1010 - (615 + 394))) and (v113 > (1 + 0)) and v128() and not v99.SurgeofPower:IsAvailable()) then
					if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((1857 + 91) >= (10596 - 7120))) then
						return "chain_lightning single_target 30";
					end
				end
				if (((21744 - 16950) >= (1484 - (59 + 592))) and v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v128() and not v126() and not v99.SurgeofPower:IsAvailable() and v99.MasteroftheElements:IsAvailable()) then
					if (((9055 - 4965) == (7531 - 3441)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst single_target 32";
					end
				end
				v167 = 3 + 1;
			end
			if ((v167 == (183 - (70 + 101))) or ((9289 - 5531) == (1772 + 726))) then
				if ((v99.FrostShock:IsCastable() and v41 and v129() and v126() and v13:BuffDown(v99.LavaSurgeBuff) and not v99.ElectrifiedShocks:IsAvailable() and not v99.FluxMelting:IsAvailable() and (v99.LavaBurst:ChargesFractional() < (2 - 1)) and v99.EchooftheElements:IsAvailable()) or ((2914 - (123 + 118)) < (382 + 1193))) then
					if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((47 + 3674) <= (2854 - (653 + 746)))) then
						return "frost_shock single_target 98";
					end
				end
				if (((1746 - 812) < (3270 - 1000)) and v99.FrostShock:IsCastable() and v41 and v129() and (v99.FluxMelting:IsAvailable() or (v99.ElectrifiedShocks:IsAvailable() and not v99.LightningRod:IsAvailable()))) then
					if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((4315 - 2703) == (554 + 701))) then
						return "frost_shock single_target 100";
					end
				end
				if ((v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and v126() and v13:BuffDown(v99.LavaSurgeBuff) and (v99.LavaBurst:ChargesFractional() < (1 + 0)) and v99.EchooftheElements:IsAvailable() and (v112 > (1 + 0)) and (v113 > (1 + 0))) or ((680 + 3672) < (10310 - 6104))) then
					if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((2723 + 137) <= (334 - 153))) then
						return "chain_lightning single_target 102";
					end
				end
				if (((4456 - (885 + 349)) >= (1213 + 314)) and v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v126() and v13:BuffDown(v99.LavaSurgeBuff) and (v99.LavaBurst:ChargesFractional() < (2 - 1)) and v99.EchooftheElements:IsAvailable()) then
					if (((4377 - 2872) <= (3089 - (915 + 53))) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
						return "lightning_bolt single_target 104";
					end
				end
				v167 = 814 - (768 + 33);
			end
			if (((2848 - 2104) == (1309 - 565)) and (v167 == (336 - (287 + 41)))) then
				if ((v99.Earthquake:IsReady() and v37 and (v112 > (848 - (638 + 209))) and (v113 > (1 + 0)) and not v99.EchoesofGreatSundering:IsAvailable() and not v99.ElementalBlast:IsAvailable()) or ((3665 - (96 + 1590)) >= (4508 - (741 + 931)))) then
					if (((901 + 932) <= (7601 - 4933)) and (v51 == "cursor")) then
						if (((17220 - 13534) == (1582 + 2104)) and v24(v101.EarthquakeCursor, not v16:IsInRange(18 + 22))) then
							return "earthquake single_target 66";
						end
					end
					if (((1106 + 2361) > (1809 - 1332)) and (v51 == "player")) then
						if (v24(v101.EarthquakePlayer, not v16:IsInRange(13 + 27)) or ((1606 + 1682) >= (14444 - 10903))) then
							return "earthquake single_target 66";
						end
					end
				end
				if ((v125(v99.ElementalBlast) and v99.ElementalBlast:IsCastable() and v39 and (not v99.MasteroftheElements:IsAvailable() or (v126() and v16:DebuffUp(v99.ElectrifiedShocksDebuff)))) or ((3192 + 365) == (5034 - (64 + 430)))) then
					if (v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast)) or ((259 + 2) > (1630 - (106 + 257)))) then
						return "elemental_blast single_target 68";
					end
				end
				if (((902 + 370) < (4579 - (496 + 225))) and v125(v99.FrostShock) and v41 and v129() and v126() and (v124() < (224 - 114)) and (v99.LavaBurst:ChargesFractional() < (4 - 3)) and v99.ElectrifiedShocks:IsAvailable() and v99.ElementalBlast:IsAvailable() and not v99.LightningRod:IsAvailable()) then
					if (((5322 - (256 + 1402)) == (5563 - (30 + 1869))) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
						return "frost_shock single_target 70";
					end
				end
				if (((3310 - (213 + 1156)) >= (638 - (96 + 92))) and v125(v99.ElementalBlast) and v99.ElementalBlast:IsCastable() and v39 and (v126() or v99.LightningRod:IsAvailable())) then
					if (v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast)) or ((792 + 3854) < (1223 - (142 + 757)))) then
						return "elemental_blast single_target 72";
					end
				end
				v167 = 8 + 1;
			end
			if (((1567 + 2266) == (3912 - (32 + 47))) and (v167 == (1983 - (1053 + 924)))) then
				if ((v99.FrostShock:IsCastable() and v41 and v129() and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.ElementalBlast:IsAvailable() and (((v124() >= (36 + 0)) and (v124() < (86 - 36)) and (v99.LavaBurst:CooldownRemains() > v13:GCD())) or ((v124() >= (1672 - (685 + 963))) and (v124() < (76 - 38)) and (v99.LavaBurst:CooldownRemains() > (0 - 0))))) or ((2949 - (541 + 1168)) > (4967 - (645 + 952)))) then
					if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((3319 - (669 + 169)) == (16218 - 11536))) then
						return "frost_shock single_target 50";
					end
				end
				if (((10264 - 5537) >= (71 + 137)) and v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v13:BuffUp(v99.WindspeakersLavaResurgenceBuff) and (v99.EchooftheElements:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.PrimordialSurge:IsAvailable() or ((v124() >= (14 + 49)) and v99.MasteroftheElements:IsAvailable()) or ((v124() >= (803 - (181 + 584))) and v13:BuffUp(v99.EchoesofGreatSunderingBuff) and (v112 > (1396 - (665 + 730))) and (v113 > (2 - 1))) or not v99.ElementalBlast:IsAvailable())) then
					if (((571 - 291) < (5201 - (540 + 810))) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst single_target 52";
					end
				end
				if ((v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v13:BuffUp(v99.LavaSurgeBuff) and (v99.EchooftheElements:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.PrimordialSurge:IsAvailable() or not v99.MasteroftheElements:IsAvailable() or not v99.ElementalBlast:IsAvailable())) or ((12022 - 9015) > (8781 - 5587))) then
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((1700 + 436) >= (3149 - (166 + 37)))) then
						return "lava_burst single_target 54";
					end
				end
				if (((4046 - (22 + 1859)) <= (4293 - (843 + 929))) and v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and v13:BuffUp(v99.AscendanceBuff) and (v13:HasTier(293 - (30 + 232), 11 - 7) or not v99.ElementalBlast:IsAvailable())) then
					local v251 = 777 - (55 + 722);
					while true do
						if (((6141 - 3280) > (2336 - (78 + 1597))) and (v251 == (0 + 0))) then
							if (((4117 + 408) > (3783 + 736)) and v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst single_target 56";
							end
							if (((3727 - (305 + 244)) > (902 + 70)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst single_target 56";
							end
							break;
						end
					end
				end
				v167 = 112 - (95 + 10);
			end
			if (((3375 + 1391) == (15103 - 10337)) and (v167 == (14 - 3))) then
				if ((v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v127() and v99.UnrelentingCalamity:IsAvailable()) or ((3507 - (592 + 170)) > (10909 - 7781))) then
					if (v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt)) or ((2872 - 1728) >= (2148 + 2458))) then
						return "lightning_bolt single_target 90";
					end
				end
				if (((1300 + 2038) >= (668 - 391)) and v125(v99.Icefury) and v99.Icefury:IsCastable() and v42) then
					if (((424 + 2186) > (4744 - 2184)) and v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury))) then
						return "icefury single_target 92";
					end
				end
				if ((v125(v99.ChainLightning) and v99.ChainLightning:IsCastable() and v36 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v99.LightningRodDebuff) and (v16:DebuffUp(v99.ElectrifiedShocksDebuff) or v127()) and (v112 > (508 - (353 + 154))) and (v113 > (1 - 0))) or ((1630 - 436) > (2128 + 955))) then
					if (((718 + 198) >= (493 + 254)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
						return "chain_lightning single_target 94";
					end
				end
				if ((v125(v99.LightningBolt) and v99.LightningBolt:IsCastable() and v45 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v99.LightningRodDebuff) and (v16:DebuffUp(v99.ElectrifiedShocksDebuff) or v127())) or ((3531 - 1087) > (5591 - 2637))) then
					if (((6741 - 3849) < (3600 - (7 + 79))) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
						return "lightning_bolt single_target 96";
					end
				end
				v167 = 6 + 6;
			end
			if (((714 - (24 + 157)) == (1063 - 530)) and (v167 == (18 - 9))) then
				if (((170 + 425) <= (9193 - 5780)) and v99.EarthShock:IsReady() and v38) then
					if (((3458 - (262 + 118)) >= (3674 - (1038 + 45))) and v24(v99.EarthShock, not v16:IsSpellInRange(v99.EarthShock))) then
						return "earth_shock single_target 74";
					end
				end
				if (((6918 - 3719) < (4260 - (19 + 211))) and v125(v99.FrostShock) and v41 and v129() and v99.ElectrifiedShocks:IsAvailable() and v126() and not v99.LightningRod:IsAvailable() and (v112 > (114 - (88 + 25))) and (v113 > (2 - 1))) then
					if (((386 + 391) < (1940 + 138)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
						return "frost_shock single_target 76";
					end
				end
				if (((2732 - (1007 + 29)) <= (615 + 1667)) and v125(v99.LavaBurst) and v99.LavaBurst:IsCastable() and v44 and (v99.DeeplyRootedElements:IsAvailable())) then
					local v252 = 0 - 0;
					while true do
						if ((v252 == (0 - 0)) or ((393 + 1368) >= (3273 - (340 + 471)))) then
							if (((11462 - 6911) > (2917 - (276 + 313))) and v103.CastCycle(v99.LavaBurst, v111, v122, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst single_target 78";
							end
							if (((9337 - 5512) >= (431 + 36)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
								return "lava_burst single_target 78";
							end
							break;
						end
					end
				end
				if ((v99.FrostShock:IsCastable() and v41 and v129() and v99.FluxMelting:IsAvailable() and v13:BuffDown(v99.FluxMeltingBuff)) or ((1226 + 1664) == (53 + 504))) then
					if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((6742 - (495 + 1477)) == (8694 - 5790))) then
						return "frost_shock single_target 80";
					end
				end
				v167 = 7 + 3;
			end
			if ((v167 == (404 - (342 + 61))) or ((1707 + 2196) == (4701 - (4 + 161)))) then
				if (((2506 + 1587) <= (15208 - 10363)) and v125(v99.PrimordialWave) and v99.PrimordialWave:IsCastable() and v47 and ((v64 and v34) or not v64) and not v13:BuffUp(v99.PrimordialWaveBuff) and not v13:BuffUp(v99.SplinteredElementsBuff)) then
					if (((4123 - 2554) <= (4144 - (322 + 175))) and v103.CastCycle(v99.PrimordialWave, v111, v121, not v16:IsSpellInRange(v99.PrimordialWave))) then
						return "primordial_wave single_target 10";
					end
					if (v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave)) or ((4609 - (173 + 390)) >= (1215 + 3712))) then
						return "primordial_wave single_target 10";
					end
				end
				if (((4937 - (203 + 111)) >= (173 + 2614)) and v99.FlameShock:IsCastable() and v40 and (v112 == (1 + 0)) and v16:DebuffRefreshable(v99.FlameShockDebuff) and ((v16:DebuffRemains(v99.FlameShockDebuff) < v99.PrimordialWave:CooldownRemains()) or not v99.PrimordialWave:IsAvailable()) and v13:BuffDown(v99.SurgeofPowerBuff) and (not v126() or (not v128() and ((v99.ElementalBlast:IsAvailable() and (v124() < ((262 - 172) - ((8 + 0) * v99.EyeoftheStorm:TalentRank())))) or (v124() < ((766 - (57 + 649)) - ((389 - (328 + 56)) * v99.EyeoftheStorm:TalentRank()))))))) then
					if (((715 + 1519) >= (1742 - (433 + 79))) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flame_shock single_target 12";
					end
				end
				if ((v99.FlameShock:IsCastable() and v40 and (v99.FlameShockDebuff:AuraActiveCount() == (0 + 0)) and (v112 > (1 + 0)) and (v113 > (3 - 2)) and (v99.DeeplyRootedElements:IsAvailable() or v99.Ascendance:IsAvailable() or v99.PrimordialWave:IsAvailable() or v99.SearingFlames:IsAvailable() or v99.MagmaChamber:IsAvailable()) and ((not v126() and (v128() or (v99.Stormkeeper:CooldownRemains() > (0 - 0)))) or not v99.SurgeofPower:IsAvailable())) or ((251 + 92) == (1592 + 194))) then
					local v253 = 1036 - (562 + 474);
					while true do
						if (((5995 - 3425) > (4907 - 2498)) and (v253 == (905 - (76 + 829)))) then
							if (v103.CastTargetIf(v99.FlameShock, v111, "min", v121, nil, not v16:IsSpellInRange(v99.FlameShock)) or ((4282 - (1506 + 167)) >= (6074 - 2840))) then
								return "flame_shock single_target 14";
							end
							if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((3299 - (58 + 208)) >= (2381 + 1650))) then
								return "flame_shock single_target 14";
							end
							break;
						end
					end
				end
				if ((v99.FlameShock:IsCastable() and v40 and (v112 > (1 + 0)) and (v113 > (1 + 0)) and (v99.DeeplyRootedElements:IsAvailable() or v99.Ascendance:IsAvailable() or v99.PrimordialWave:IsAvailable() or v99.SearingFlames:IsAvailable() or v99.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v99.SurgeofPowerBuff) and not v128() and v99.Stormkeeper:IsAvailable()) or not v99.SurgeofPower:IsAvailable())) or ((5715 - 4314) == (5005 - (258 + 79)))) then
					if (((353 + 2423) >= (2778 - 1457)) and v103.CastTargetIf(v99.FlameShock, v111, "min", v121, v118, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flame_shock single_target 16";
					end
					if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((1957 - (1219 + 251)) > (3974 - (1231 + 440)))) then
						return "flame_shock single_target 16";
					end
				end
				v167 = 60 - (34 + 24);
			end
		end
	end
	local function v137()
		local v168 = 0 + 0;
		while true do
			if ((v168 == (5 - 2)) or ((1968 + 2535) == (10514 - 7052))) then
				if (((1772 - 1219) <= (4056 - 2513)) and v99.ImprovedFlametongueWeapon:IsAvailable() and v99.FlametongueWeapon:IsCastable() and v50 and (not v108 or (v109 < (2010178 - 1410178))) and v99.FlametongueWeapon:IsAvailable()) then
					if (((4399 - 2384) == (3604 - (877 + 712))) and v24(v99.FlametongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if ((not v13:AffectingCombat() and v31 and v103.TargetIsValid()) or ((2540 + 1701) <= (3086 - (242 + 512)))) then
					v30 = v134();
					if (v30 or ((4940 - 2576) < (1784 - (92 + 535)))) then
						return v30;
					end
				end
				break;
			end
			if ((v168 == (1 + 0)) or ((2403 - 1236) > (80 + 1198))) then
				if (v30 or ((4161 - 3016) <= (1061 + 21))) then
					return v30;
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((2150 + 955) == (685 + 4196))) then
					if (v24(v99.AncestralSpirit, nil, true) or ((3760 - 1873) > (7434 - 2556))) then
						return "ancestral_spirit";
					end
				end
				v168 = 1787 - (1476 + 309);
			end
			if (((1284 - (299 + 985)) == v168) or ((971 + 3116) > (13492 - 9376))) then
				if (((1199 - (86 + 7)) <= (5173 - 3907)) and v73 and v99.EarthShield:IsCastable() and v13:BuffDown(v99.EarthShieldBuff) and ((v74 == "Earth Shield") or (v99.ElementalOrbit:IsAvailable() and v13:BuffUp(v99.LightningShield)))) then
					if (((300 + 2855) < (5530 - (672 + 208))) and v24(v99.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif (((1618 + 2156) >= (1971 - (14 + 118))) and v73 and v99.LightningShield:IsCastable() and v13:BuffDown(v99.LightningShieldBuff) and ((v74 == "Lightning Shield") or (v99.ElementalOrbit:IsAvailable() and v13:BuffUp(v99.EarthShield)))) then
					if (((3256 - (339 + 106)) == (2237 + 574)) and v24(v99.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				v30 = v131();
				v168 = 1 + 0;
			end
			if (((3541 - (440 + 955)) > (1106 + 16)) and ((3 - 1) == v168)) then
				if ((v99.AncestralSpirit:IsCastable() and v99.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) or ((19 + 37) == (9002 - 5386))) then
					if (v24(v101.AncestralSpiritMouseover) or ((1659 + 762) < (975 - (260 + 93)))) then
						return "ancestral_spirit mouseover";
					end
				end
				v108, v109 = v29();
				v168 = 3 + 0;
			end
		end
	end
	local function v138()
		v30 = v132();
		if (((2307 - 1298) <= (2040 - 910)) and v30) then
			return v30;
		end
		if (((4732 - (1181 + 793)) < (759 + 2221)) and v85) then
			if (v80 or ((393 - (105 + 202)) >= (2907 + 719))) then
				local v233 = 810 - (352 + 458);
				while true do
					if (((9656 - 7261) == (6122 - 3727)) and (v233 == (0 + 0))) then
						v30 = v103.HandleAfflicted(v99.CleanseSpirit, v101.CleanseSpiritMouseover, 116 - 76);
						if (((4729 - (438 + 511)) > (4092 - (1262 + 121))) and v30) then
							return v30;
						end
						break;
					end
				end
			end
			if (v81 or ((1305 - (728 + 340)) >= (4063 - (816 + 974)))) then
				v30 = v103.HandleAfflicted(v99.TremorTotem, v99.TremorTotem, 91 - 61);
				if (v30 or ((7341 - 5301) <= (1042 - (163 + 176)))) then
					return v30;
				end
			end
			if (((9333 - 6054) <= (18230 - 14263)) and v82) then
				local v234 = 0 + 0;
				while true do
					if ((v234 == (1810 - (1564 + 246))) or ((2333 - (124 + 221)) == (600 + 277))) then
						v30 = v103.HandleAfflicted(v99.PoisonCleansingTotem, v99.PoisonCleansingTotem, 481 - (115 + 336));
						if (((9450 - 5159) > (394 + 1518)) and v30) then
							return v30;
						end
						break;
					end
				end
			end
		end
		if (((2049 - (45 + 1)) < (127 + 2212)) and v86) then
			v30 = v103.HandleIncorporeal(v99.Hex, v101.HexMouseOver, 2020 - (1282 + 708), true);
			if (((1644 - (583 + 629)) == (72 + 360)) and v30) then
				return v30;
			end
		end
		if (v17 or ((2961 - 1816) >= (657 + 596))) then
			if (((4588 - (943 + 227)) > (926 + 1192)) and v84) then
				v30 = v130();
				if (((4697 - (1539 + 92)) <= (5836 - (706 + 1240))) and v30) then
					return v30;
				end
			end
		end
		if ((v99.GreaterPurge:IsAvailable() and v96 and v99.GreaterPurge:IsReady() and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v103.UnitHasMagicBuff(v16)) or ((3256 - (81 + 177)) >= (9269 - 5988))) then
			if (v24(v99.GreaterPurge, not v16:IsSpellInRange(v99.GreaterPurge)) or ((4906 - (212 + 45)) <= (8804 - 6172))) then
				return "greater_purge damage";
			end
		end
		if ((v99.Purge:IsReady() and v96 and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v103.UnitHasMagicBuff(v16)) or ((5806 - (708 + 1238)) > (406 + 4466))) then
			if (v24(v99.Purge, not v16:IsSpellInRange(v99.Purge)) or ((1308 + 2690) == (3965 - (586 + 1081)))) then
				return "purge damage";
			end
		end
		if ((v103.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) or ((519 - (348 + 163)) >= (2460 + 279))) then
			local v188 = 280 - (215 + 65);
			local v189;
			while true do
				if (((6599 - 4009) == (4449 - (1541 + 318))) and ((2 + 0) == v188)) then
					if (v189 or ((42 + 40) >= (1410 + 460))) then
						return v189;
					end
					if (((4374 - (1036 + 714)) < (3004 + 1553)) and v32 and (v112 > (2 + 0)) and (v113 > (1282 - (883 + 397)))) then
						v30 = v135();
						if (v30 or ((3721 - (563 + 27)) > (13858 - 10316))) then
							return v30;
						end
						if (((4563 - (1369 + 617)) >= (3065 - (85 + 1402))) and v24(v99.Pool)) then
							return "Pool for Aoe()";
						end
					end
					v188 = 2 + 1;
				end
				if (((10590 - 6487) <= (4974 - (274 + 129))) and (v188 == (217 - (12 + 205)))) then
					if (((v90 < v107) and v57 and ((v63 and v33) or not v63)) or ((1365 + 130) == (18561 - 13774))) then
						if ((v99.BloodFury:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff) or (v99.Ascendance:CooldownRemains() > (49 + 1)))) or ((694 - (27 + 357)) > (4914 - (91 + 389)))) then
							if (((2465 - (90 + 207)) <= (168 + 4192)) and v24(v99.BloodFury)) then
								return "blood_fury main 2";
							end
						end
						if (((1855 - (706 + 155)) == (2789 - (730 + 1065))) and v99.Berserking:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff))) then
							if (((3218 - (1339 + 224)) > (204 + 197)) and v24(v99.Berserking)) then
								return "berserking main 4";
							end
						end
						if (((2727 + 336) <= (5100 - 1674)) and v99.Fireblood:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff) or (v99.Ascendance:CooldownRemains() > (893 - (268 + 575))))) then
							if (((2753 - (919 + 375)) > (2100 - 1336)) and v24(v99.Fireblood)) then
								return "fireblood main 6";
							end
						end
						if ((v99.AncestralCall:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff) or (v99.Ascendance:CooldownRemains() > (1021 - (180 + 791))))) or ((2446 - (323 + 1482)) > (6252 - (1177 + 741)))) then
							if (((223 + 3176) >= (8474 - 6214)) and v24(v99.AncestralCall)) then
								return "ancestral_call main 8";
							end
						end
						if ((v99.BagofTricks:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff))) or ((152 + 241) >= (9474 - 5232))) then
							if (((83 + 906) < (4968 - (96 + 13))) and v24(v99.BagofTricks)) then
								return "bag_of_tricks main 10";
							end
						end
					end
					if ((v90 < v107) or ((6716 - (962 + 959)) < (2370 - 1421))) then
						if (((681 + 3161) == (5193 - (461 + 890))) and v56 and ((v33 and v62) or not v62)) then
							local v262 = 0 + 0;
							while true do
								if (((6806 - 5059) <= (3844 - (19 + 224))) and (v262 == (0 + 0))) then
									v30 = v133();
									if (v30 or ((1002 - (37 + 161)) > (1572 + 2787))) then
										return v30;
									end
									break;
								end
							end
						end
					end
					v188 = 1 + 0;
				end
				if (((4606 + 64) >= (3684 - (60 + 1))) and (v188 == (924 - (826 + 97)))) then
					if (((2000 + 65) < (9144 - 6600)) and v99.NaturesSwiftness:IsCastable() and v46) then
						if (((2700 - 1389) <= (4044 - (375 + 310))) and v24(v99.NaturesSwiftness)) then
							return "natures_swiftness main 12";
						end
					end
					v189 = v103.HandleDPSPotion(v13:BuffUp(v99.AscendanceBuff));
					v188 = 2001 - (1864 + 135);
				end
				if (((7010 - 4293) <= (699 + 2457)) and (v188 == (2 + 1))) then
					if (((2655 - 1574) < (5655 - (314 + 817))) and true) then
						v30 = v136();
						if (((250 + 190) >= (285 - (32 + 182))) and v30) then
							return v30;
						end
						if (((3647 + 1287) > (9111 - 6504)) and v24(v99.Pool)) then
							return "Pool for SingleTarget()";
						end
					end
					break;
				end
			end
		end
	end
	local function v139()
		local v169 = 65 - (39 + 26);
		while true do
			if ((v169 == (148 - (54 + 90))) or ((1598 - (45 + 153)) > (1891 + 1225))) then
				v54 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v53 = EpicSettings.Settings['useFireElemental'];
				v55 = EpicSettings.Settings['useStormElemental'];
				v58 = EpicSettings.Settings['ascendanceWithCD'];
				v169 = 557 - (457 + 95);
			end
			if (((522 + 3) < (3468 - 1806)) and (v169 == (4 - 2))) then
				v44 = EpicSettings.Settings['useLavaBurst'];
				v45 = EpicSettings.Settings['useLightningBolt'];
				v46 = EpicSettings.Settings['useNaturesSwiftness'];
				v47 = EpicSettings.Settings['usePrimordialWave'];
				v169 = 10 - 7;
			end
			if ((v169 == (2 + 1)) or ((3021 - 2145) > (7698 - 5148))) then
				v48 = EpicSettings.Settings['useStormkeeper'];
				v49 = EpicSettings.Settings['useTotemicRecall'];
				v50 = EpicSettings.Settings['useWeaponEnchant'];
				v52 = EpicSettings.Settings['useAscendance'];
				v169 = 752 - (485 + 263);
			end
			if (((926 - (575 + 132)) <= (3317 - (750 + 111))) and (v169 == (1011 - (445 + 565)))) then
				v40 = EpicSettings.Settings['useFlameShock'];
				v41 = EpicSettings.Settings['useFrostShock'];
				v42 = EpicSettings.Settings['useIceFury'];
				v43 = EpicSettings.Settings['useLavaBeam'];
				v169 = 2 + 0;
			end
			if ((v169 == (0 + 0)) or ((7452 - 3233) == (384 + 766))) then
				v36 = EpicSettings.Settings['useChainlightning'];
				v37 = EpicSettings.Settings['useEarthquake'];
				v38 = EpicSettings.Settings['UseEarthShock'];
				v39 = EpicSettings.Settings['useElementalBlast'];
				v169 = 311 - (189 + 121);
			end
			if ((v169 == (2 + 3)) or ((4336 - (634 + 713)) <= (760 - (493 + 45)))) then
				v61 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v59 = EpicSettings.Settings['fireElementalWithCD'];
				v60 = EpicSettings.Settings['stormElementalWithCD'];
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v169 = 974 - (493 + 475);
			end
			if (((577 + 1681) > (2025 - (158 + 626))) and ((3 + 3) == v169)) then
				v65 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
		end
	end
	local function v140()
		local v170 = 0 - 0;
		while true do
			if (((10 + 31) < (230 + 4029)) and (v170 == (1094 - (1035 + 56)))) then
				v78 = EpicSettings.Settings['healingStreamTotemHP'] or (959 - (114 + 845));
				v79 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v51 = EpicSettings.Settings['earthquakeSetting'] or "";
				v170 = 10 - 6;
			end
			if (((5 + 0) == v170) or ((2979 - (179 + 870)) < (78 - 22))) then
				v97 = EpicSettings.Settings['healOOC'];
				v98 = EpicSettings.Settings['healOOCHP'] or (878 - (827 + 51));
				v96 = EpicSettings.Settings['usePurgeTarget'];
				v170 = 15 - 9;
			end
			if (((1670 + 1663) == (3806 - (95 + 378))) and (v170 == (1 + 3))) then
				v66 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v73 = EpicSettings.Settings['autoShield'];
				v74 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v170 = 7 - 2;
			end
			if ((v170 == (2 + 0)) or ((3236 - (334 + 677)) == (74 - 54))) then
				v75 = EpicSettings.Settings['ancestralGuidanceHP'] or (1056 - (1049 + 7));
				v76 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
				v77 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
				v170 = 1 + 2;
			end
			if ((v170 == (0 - 0)) or ((1746 - 874) >= (1377 + 1715))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v170 = 1421 - (1004 + 416);
			end
			if (((6361 - (1621 + 336)) >= (5191 - (337 + 1602))) and ((1523 - (1014 + 503)) == v170)) then
				v80 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v81 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v82 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((2122 - (446 + 569)) > (34 + 762)) and (v170 == (2 - 1))) then
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v71 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v170 = 1 + 1;
			end
		end
	end
	local function v141()
		v90 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v87 = EpicSettings.Settings['InterruptWithStun'];
		v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v89 = EpicSettings.Settings['InterruptThreshold'];
		v84 = EpicSettings.Settings['DispelDebuffs'];
		v83 = EpicSettings.Settings['DispelBuffs'];
		v56 = EpicSettings.Settings['useTrinkets'];
		v57 = EpicSettings.Settings['useRacials'];
		v62 = EpicSettings.Settings['trinketsWithCD'];
		v63 = EpicSettings.Settings['racialsWithCD'];
		v92 = EpicSettings.Settings['useHealthstone'];
		v91 = EpicSettings.Settings['useHealingPotion'];
		v94 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
		v93 = EpicSettings.Settings['healingPotionHP'] or (505 - (223 + 282));
		v95 = EpicSettings.Settings['HealingPotionName'] or "";
		v85 = EpicSettings.Settings['handleAfflicted'];
		v86 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v142()
		local v184 = 0 + 0;
		while true do
			if (((1526 - 567) == (1398 - 439)) and (v184 == (672 - (623 + 47)))) then
				if (v13:IsDeadOrGhost() or ((290 - (32 + 13)) >= (1236 + 968))) then
					return v30;
				end
				v110 = v13:GetEnemiesInRange(33 + 7);
				v111 = v16:GetEnemiesInSplashRange(1806 - (1070 + 731));
				if (((3022 + 140) >= (3473 - (1257 + 147))) and v32) then
					local v254 = 0 + 0;
					while true do
						if ((v254 == (0 - 0)) or ((439 - (98 + 35)) > (1293 + 1788))) then
							v112 = #v110;
							v113 = v27(v16:GetEnemiesInSplashRangeCount(17 - 12), v112);
							break;
						end
					end
				else
					v112 = 3 - 2;
					v113 = 1 + 0;
				end
				v184 = 3 + 0;
			end
			if ((v184 == (2 + 1)) or ((4070 - (395 + 162)) < (2380 + 326))) then
				if (((4919 - (816 + 1125)) < (5191 - 1552)) and v35 and v84) then
					if (((4830 - (701 + 447)) >= (4448 - 1560)) and v13:AffectingCombat() and v99.CleanseSpirit:IsAvailable()) then
						local v256 = v84 and v99.CleanseSpirit:IsReady() and v35;
						v30 = v103.FocusUnit(v256, v101, 34 - 14, nil, 1366 - (391 + 950));
						if (((401 - 252) < (1200 - 721)) and v30) then
							return v30;
						end
					end
					if (((2513 - 1493) >= (398 + 169)) and v99.CleanseSpirit:IsAvailable()) then
						if ((v14 and v14:Exists() and v14:IsAPlayer() and v103.UnitHasCurseDebuff(v14)) or ((427 + 306) > (9027 - 6558))) then
							if (((4019 - (251 + 1271)) == (2224 + 273)) and v99.CleanseSpirit:IsReady()) then
								if (((10444 - 6543) == (9767 - 5866)) and v24(v101.CleanseSpiritMouseover)) then
									return "cleanse_spirit mouseover";
								end
							end
						end
					end
				end
				if (((332 - 131) < (1674 - (1147 + 112))) and (v103.TargetIsValid() or v13:AffectingCombat())) then
					v106 = v9.BossFightRemains();
					v107 = v106;
					if ((v107 == (2776 + 8335)) or ((269 - 136) == (464 + 1320))) then
						v107 = v9.FightRemains(v110, false);
					end
				end
				if ((not v13:IsChanneling() and not v13:IsCasting()) or ((704 - (335 + 362)) >= (291 + 19))) then
					if (((7514 - 2522) > (780 - 494)) and v85) then
						if (v80 or ((9516 - 6955) == (18954 - 15061))) then
							local v263 = 0 - 0;
							while true do
								if (((4928 - (237 + 329)) >= (5088 - 3667)) and (v263 == (0 + 0))) then
									v30 = v103.HandleAfflicted(v99.CleanseSpirit, v101.CleanseSpiritMouseover, 22 + 18);
									if (((1199 - (408 + 716)) <= (13472 - 9926)) and v30) then
										return v30;
									end
									break;
								end
							end
						end
						if (((3501 - (344 + 477)) <= (582 + 2836)) and v81) then
							local v264 = 1761 - (1188 + 573);
							while true do
								if (((0 - 0) == v264) or ((4178 + 110) < (9330 - 6454))) then
									v30 = v103.HandleAfflicted(v99.TremorTotem, v99.TremorTotem, 46 - 16);
									if (((6088 - 3626) >= (2676 - (508 + 1021))) and v30) then
										return v30;
									end
									break;
								end
							end
						end
						if (v82 or ((4618 + 296) < (3646 - (228 + 938)))) then
							local v265 = 685 - (332 + 353);
							while true do
								if ((v265 == (0 - 0)) or ((4081 - 2522) == (1175 + 65))) then
									v30 = v103.HandleAfflicted(v99.PoisonCleansingTotem, v99.PoisonCleansingTotem, 16 + 14);
									if (((2263 - 1697) == (989 - (18 + 405))) and v30) then
										return v30;
									end
									break;
								end
							end
						end
					end
					if (((1797 + 2124) >= (1521 + 1488)) and v13:AffectingCombat()) then
						v30 = v138();
						if (((3143 - 1080) >= (2626 - (194 + 784))) and v30) then
							return v30;
						end
					else
						v30 = v137();
						if (((2836 - (694 + 1076)) >= (2356 - (122 + 1782))) and v30) then
							return v30;
						end
					end
				end
				break;
			end
			if (((4681 + 293) >= (2475 + 180)) and (v184 == (1 + 0))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v34 = EpicSettings.Toggles['minicds'];
				v184 = 2 + 0;
			end
			if ((v184 == (0 - 0)) or ((2521 + 200) <= (2877 - (214 + 1756)))) then
				v140();
				v139();
				v141();
				v31 = EpicSettings.Toggles['ooc'];
				v184 = 4 - 3;
			end
		end
	end
	local function v143()
		v99.FlameShockDebuff:RegisterAuraTracking();
		v105();
		v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(29 + 233, v142, v143);
end;
return v0["Epix_Shaman_Elemental.lua"]();

