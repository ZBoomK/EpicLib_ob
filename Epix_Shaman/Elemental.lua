local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2981 - (38 + 127)) < (15 - 4))) then
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
		if (((3606 + 93) < (7249 - 2543)) and v99.CleanseSpirit:IsAvailable()) then
			v103.DispellableDebuffs = v103.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v105();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v9:RegisterForEvent(function()
		local v139 = 785 - (222 + 563);
		while true do
			if (((5829 - 3183) >= (631 + 245)) and (v139 == (191 - (23 + 167)))) then
				v99.LavaBurst:RegisterInFlight();
				break;
			end
			if (((2412 - (690 + 1108)) <= (1149 + 2035)) and (v139 == (0 + 0))) then
				v99.PrimordialWave:RegisterInFlightEffect(328010 - (40 + 808));
				v99.PrimordialWave:RegisterInFlight();
				v139 = 1 + 0;
			end
		end
	end, "LEARNED_SPELL_IN_TAB");
	v99.PrimordialWave:RegisterInFlightEffect(1251069 - 923907);
	v99.PrimordialWave:RegisterInFlight();
	v99.LavaBurst:RegisterInFlight();
	local v106 = 10620 + 491;
	local v107 = 5878 + 5233;
	local v108, v109;
	local v110, v111;
	local v112 = 0 + 0;
	local v113 = 571 - (47 + 524);
	local function v114()
		return (26 + 14) - (v28() - v104.LastT302pcBuff);
	end
	local function v115(v140)
		return (v140:DebuffRefreshable(v99.FlameShockDebuff));
	end
	local function v116(v141)
		return v141:DebuffRefreshable(v99.FlameShockDebuff) and (v141:DebuffRemains(v99.FlameShockDebuff) < (v141:TimeToDie() - (13 - 8)));
	end
	local function v117(v142)
		return v142:DebuffRefreshable(v99.FlameShockDebuff) and (v142:DebuffRemains(v99.FlameShockDebuff) < (v142:TimeToDie() - (7 - 2))) and (v142:DebuffRemains(v99.FlameShockDebuff) > (0 - 0));
	end
	local function v118(v143)
		return (v143:DebuffRemains(v99.FlameShockDebuff));
	end
	local function v119(v144)
		return v144:DebuffRemains(v99.FlameShockDebuff) > (1728 - (1165 + 561));
	end
	local function v120(v145)
		return (v145:DebuffRemains(v99.LightningRodDebuff));
	end
	local function v121()
		local v146 = 0 + 0;
		local v147;
		while true do
			if (((9681 - 6555) == (1193 + 1933)) and (v146 == (479 - (341 + 138)))) then
				v147 = v13:Maelstrom();
				if (not v13:IsCasting() or ((591 + 1596) >= (10223 - 5269))) then
					return v147;
				elseif (v13:IsCasting(v99.ElementalBlast) or ((4203 - (89 + 237)) == (11500 - 7925))) then
					return v147 - (157 - 82);
				elseif (((1588 - (581 + 300)) > (1852 - (855 + 365))) and v13:IsCasting(v99.Icefury)) then
					return v147 + (59 - 34);
				elseif (v13:IsCasting(v99.LightningBolt) or ((179 + 367) >= (3919 - (1030 + 205)))) then
					return v147 + 10 + 0;
				elseif (((1363 + 102) <= (4587 - (156 + 130))) and v13:IsCasting(v99.LavaBurst)) then
					return v147 + (27 - 15);
				elseif (((2871 - 1167) > (2918 - 1493)) and v13:IsCasting(v99.ChainLightning)) then
					return v147 + ((2 + 2) * v113);
				else
					return v147;
				end
				break;
			end
		end
	end
	local function v122()
		local v148 = 0 + 0;
		local v149;
		while true do
			if ((v148 == (70 - (10 + 59))) or ((195 + 492) == (20851 - 16617))) then
				if (not v13:IsCasting() or ((4493 - (671 + 492)) < (1138 + 291))) then
					return v149;
				elseif (((2362 - (369 + 846)) >= (89 + 246)) and v13:IsCasting(v99.LavaBurst)) then
					return true;
				elseif (((2932 + 503) > (4042 - (1036 + 909))) and v13:IsCasting(v99.ElementalBlast)) then
					return false;
				elseif (v13:IsCasting(v99.Icefury) or ((2998 + 772) >= (6784 - 2743))) then
					return false;
				elseif (v13:IsCasting(v99.LightningBolt) or ((3994 - (11 + 192)) <= (815 + 796))) then
					return false;
				elseif (v13:IsCasting(v99.ChainLightning) or ((4753 - (135 + 40)) <= (4865 - 2857))) then
					return false;
				else
					return v149;
				end
				break;
			end
			if (((679 + 446) <= (4573 - 2497)) and (v148 == (0 - 0))) then
				if (not v99.MasteroftheElements:IsAvailable() or ((919 - (50 + 126)) >= (12249 - 7850))) then
					return false;
				end
				v149 = v13:BuffUp(v99.MasteroftheElementsBuff);
				v148 = 1 + 0;
			end
		end
	end
	local function v123()
		local v150 = 1413 - (1233 + 180);
		local v151;
		while true do
			if (((2124 - (522 + 447)) < (3094 - (107 + 1314))) and (v150 == (1 + 0))) then
				if (not v13:IsCasting() or ((7081 - 4757) <= (246 + 332))) then
					return v151;
				elseif (((7480 - 3713) == (14904 - 11137)) and v13:IsCasting(v99.Stormkeeper)) then
					return true;
				else
					return v151;
				end
				break;
			end
			if (((5999 - (716 + 1194)) == (70 + 4019)) and (v150 == (0 + 0))) then
				if (((4961 - (74 + 429)) >= (3228 - 1554)) and not v99.Stormkeeper:IsAvailable()) then
					return false;
				end
				v151 = v13:BuffUp(v99.StormkeeperBuff);
				v150 = 1 + 0;
			end
		end
	end
	local function v124()
		if (((2224 - 1252) <= (1004 + 414)) and not v99.Icefury:IsAvailable()) then
			return false;
		end
		local v152 = v13:BuffUp(v99.IcefuryBuff);
		if (not v13:IsCasting() or ((15223 - 10285) < (11773 - 7011))) then
			return v152;
		elseif (v13:IsCasting(v99.Icefury) or ((2937 - (279 + 154)) > (5042 - (454 + 324)))) then
			return true;
		else
			return v152;
		end
	end
	local function v125()
		if (((1694 + 459) == (2170 - (12 + 5))) and v99.CleanseSpirit:IsReady() and v35 and v103.DispellableFriendlyUnit(14 + 11)) then
			if (v24(v101.CleanseSpiritFocus) or ((1291 - 784) >= (958 + 1633))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v126()
		if (((5574 - (277 + 816)) == (19147 - 14666)) and v97 and (v13:HealthPercentage() <= v98)) then
			if (v99.HealingSurge:IsReady() or ((3511 - (1058 + 125)) < (130 + 563))) then
				if (((5303 - (815 + 160)) == (18569 - 14241)) and v24(v99.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v127()
		local v153 = 0 - 0;
		while true do
			if (((379 + 1209) >= (3893 - 2561)) and ((1898 - (41 + 1857)) == v153)) then
				if ((v99.AstralShift:IsReady() and v71 and (v13:HealthPercentage() <= v77)) or ((6067 - (1222 + 671)) > (10979 - 6731))) then
					if (v24(v99.AstralShift) or ((6591 - 2005) <= (1264 - (229 + 953)))) then
						return "astral_shift defensive 1";
					end
				end
				if (((5637 - (1111 + 663)) == (5442 - (874 + 705))) and v99.AncestralGuidance:IsReady() and v70 and v103.AreUnitsBelowHealthPercentage(v75, v76)) then
					if (v24(v99.AncestralGuidance) or ((40 + 242) <= (29 + 13))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v153 = 1 - 0;
			end
			if (((130 + 4479) >= (1445 - (642 + 37))) and (v153 == (1 + 0))) then
				if ((v99.HealingStreamTotem:IsReady() and v72 and v103.AreUnitsBelowHealthPercentage(v78, v79)) or ((185 + 967) == (6246 - 3758))) then
					if (((3876 - (233 + 221)) > (7746 - 4396)) and v24(v99.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((772 + 105) > (1917 - (718 + 823))) and v100.Healthstone:IsReady() and v92 and (v13:HealthPercentage() <= v94)) then
					if (v24(v101.Healthstone) or ((1963 + 1155) <= (2656 - (266 + 539)))) then
						return "healthstone defensive 3";
					end
				end
				v153 = 5 - 3;
			end
			if (((1227 - (636 + 589)) == v153) or ((391 - 226) >= (7202 - 3710))) then
				if (((3130 + 819) < (1765 + 3091)) and v91 and (v13:HealthPercentage() <= v93)) then
					local v222 = 1015 - (657 + 358);
					while true do
						if ((v222 == (0 - 0)) or ((9741 - 5465) < (4203 - (1151 + 36)))) then
							if (((4530 + 160) > (1085 + 3040)) and (v95 == "Refreshing Healing Potion")) then
								if (v100.RefreshingHealingPotion:IsReady() or ((149 - 99) >= (2728 - (1552 + 280)))) then
									if (v24(v101.RefreshingHealingPotion) or ((2548 - (64 + 770)) >= (2009 + 949))) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v95 == "Dreamwalker's Healing Potion") or ((3384 - 1893) < (115 + 529))) then
								if (((1947 - (157 + 1086)) < (1974 - 987)) and v100.DreamwalkersHealingPotion:IsReady()) then
									if (((16283 - 12565) > (2923 - 1017)) and v24(v101.RefreshingHealingPotion)) then
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
		end
	end
	local function v128()
		v30 = v103.HandleTopTrinket(v102, v33, 54 - 14, nil);
		if (v30 or ((1777 - (599 + 220)) > (7238 - 3603))) then
			return v30;
		end
		v30 = v103.HandleBottomTrinket(v102, v33, 1971 - (1813 + 118), nil);
		if (((2560 + 941) <= (5709 - (841 + 376))) and v30) then
			return v30;
		end
	end
	local function v129()
		local v154 = 0 - 0;
		while true do
			if ((v154 == (1 + 0)) or ((9394 - 5952) < (3407 - (464 + 395)))) then
				if (((7378 - 4503) >= (704 + 760)) and v99.ElementalBlast:IsCastable() and v39) then
					if (v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast)) or ((5634 - (467 + 370)) >= (10110 - 5217))) then
						return "elemental_blast precombat 6";
					end
				end
				if ((v13:IsCasting(v99.ElementalBlast) and v47 and ((v64 and v34) or not v64) and v99.PrimordialWave:IsAvailable()) or ((405 + 146) > (7089 - 5021))) then
					if (((330 + 1784) > (2195 - 1251)) and v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave))) then
						return "primordial_wave precombat 8";
					end
				end
				v154 = 522 - (150 + 370);
			end
			if ((v154 == (1285 - (74 + 1208))) or ((5563 - 3301) >= (14683 - 11587))) then
				if ((v13:IsCasting(v99.LavaBurst) and v40 and v99.FlameShock:IsReady()) or ((1605 + 650) >= (3927 - (14 + 376)))) then
					if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((6654 - 2817) < (846 + 460))) then
						return "flameshock precombat 14";
					end
				end
				if (((2592 + 358) == (2814 + 136)) and v13:IsCasting(v99.LavaBurst) and v47 and ((v64 and v34) or not v64) and v99.PrimordialWave:IsAvailable()) then
					if (v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave)) or ((13838 - 9115) < (2482 + 816))) then
						return "primordial_wave precombat 16";
					end
				end
				break;
			end
			if (((1214 - (23 + 55)) >= (364 - 210)) and (v154 == (2 + 0))) then
				if ((v13:IsCasting(v99.ElementalBlast) and v40 and not v99.PrimordialWave:IsAvailable() and v99.FlameShock:IsReady()) or ((244 + 27) > (7361 - 2613))) then
					if (((1492 + 3248) >= (4053 - (652 + 249))) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flameshock precombat 10";
					end
				end
				if ((v99.LavaBurst:IsCastable() and v44 and not v13:IsCasting(v99.LavaBurst) and (not v99.ElementalBlast:IsAvailable() or (v99.ElementalBlast:IsAvailable() and not v99.ElementalBlast:IsAvailable()))) or ((6899 - 4321) >= (5258 - (708 + 1160)))) then
					if (((111 - 70) <= (3028 - 1367)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lavaburst precombat 12";
					end
				end
				v154 = 30 - (10 + 17);
			end
			if (((135 + 466) < (5292 - (1400 + 332))) and (v154 == (0 - 0))) then
				if (((2143 - (242 + 1666)) < (294 + 393)) and v99.Stormkeeper:IsCastable() and (v99.Stormkeeper:CooldownRemains() == (0 + 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107)) then
					if (((3877 + 672) > (2093 - (850 + 90))) and v24(v99.Stormkeeper)) then
						return "stormkeeper precombat 2";
					end
				end
				if ((v99.Icefury:IsCastable() and (v99.Icefury:CooldownRemains() == (0 - 0)) and v42) or ((6064 - (360 + 1030)) < (4135 + 537))) then
					if (((10352 - 6684) < (6274 - 1713)) and v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury))) then
						return "icefury precombat 4";
					end
				end
				v154 = 1662 - (909 + 752);
			end
		end
	end
	local function v130()
		local v155 = 1223 - (109 + 1114);
		while true do
			if ((v155 == (14 - 6)) or ((178 + 277) == (3847 - (6 + 236)))) then
				if ((v99.FlameShock:IsCastable() and v40) or ((1678 + 985) == (2666 + 646))) then
					if (((10086 - 5809) <= (7816 - 3341)) and v103.CastCycle(v99.FlameShock, v111, v115, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flame_shock moving aoe 86";
					end
					if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((2003 - (1076 + 57)) == (196 + 993))) then
						return "flame_shock moving aoe 86";
					end
				end
				if (((2242 - (579 + 110)) <= (248 + 2885)) and v99.FrostShock:IsCastable() and v41) then
					if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((1978 + 259) >= (1864 + 1647))) then
						return "frost_shock moving aoe 88";
					end
				end
				break;
			end
			if ((v155 == (411 - (174 + 233))) or ((3698 - 2374) > (5300 - 2280))) then
				if ((v99.ElementalBlast:IsAvailable() and v39 and (v112 == (2 + 1)) and not v99.EchoesofGreatSundering:IsAvailable()) or ((4166 - (663 + 511)) == (1679 + 202))) then
					if (((675 + 2431) > (4704 - 3178)) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
						return "elemental_blast aoe 46";
					end
				end
				if (((1831 + 1192) < (9111 - 5241)) and v99.EarthShock:IsReady() and v38 and (v99.EchoesofGreatSundering:IsAvailable())) then
					local v223 = 0 - 0;
					while true do
						if (((69 + 74) > (143 - 69)) and (v223 == (0 + 0))) then
							if (((2 + 16) < (2834 - (478 + 244))) and v103.CastTargetIf(v99.EarthShock, v111, "min", v120, nil, not v16:IsSpellInRange(v99.EarthShock))) then
								return "earth_shock aoe 48";
							end
							if (((1614 - (440 + 77)) <= (741 + 887)) and v24(v99.EarthShock, not v16:IsSpellInRange(v99.EarthShock))) then
								return "earth_shock aoe 48";
							end
							break;
						end
					end
				end
				if (((16946 - 12316) == (6186 - (655 + 901))) and v99.EarthShock:IsReady() and v38 and (v99.EchoesofGreatSundering:IsAvailable())) then
					if (((657 + 2883) > (2055 + 628)) and v24(v99.EarthShock, not v16:IsSpellInRange(v99.EarthShock))) then
						return "earth_shock aoe 50";
					end
				end
				if (((3238 + 1556) >= (13193 - 9918)) and v99.Icefury:IsAvailable() and (v99.Icefury:CooldownRemains() == (1445 - (695 + 750))) and v42 and v13:BuffDown(v99.AscendanceBuff) and v99.ElectrifiedShocks:IsAvailable() and ((v99.LightningRod:IsAvailable() and (v112 < (16 - 11)) and not v122()) or (v99.DeeplyRootedElements:IsAvailable() and (v112 == (3 - 0))))) then
					if (((5968 - 4484) == (1835 - (285 + 66))) and v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury))) then
						return "icefury aoe 52";
					end
				end
				if (((3337 - 1905) < (4865 - (682 + 628))) and v99.FrostShock:IsCastable() and v41 and v13:BuffDown(v99.AscendanceBuff) and v124() and v99.ElectrifiedShocks:IsAvailable() and (v16:DebuffDown(v99.ElectrifiedShocksDebuff) or (v13:BuffRemains(v99.IcefuryBuff) < v13:GCD())) and ((v99.LightningRod:IsAvailable() and (v112 < (1 + 4)) and not v122()) or (v99.DeeplyRootedElements:IsAvailable() and (v112 == (302 - (176 + 123)))))) then
					if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((446 + 619) > (2596 + 982))) then
						return "frost_shock moving aoe 54";
					end
				end
				v155 = 274 - (239 + 30);
			end
			if ((v155 == (1 + 2)) or ((4609 + 186) < (2490 - 1083))) then
				if (((5780 - 3927) < (5128 - (306 + 9))) and v99.Earthquake:IsReady() and v37 and (v51 == "player") and not v99.EchoesofGreatSundering:IsAvailable() and not v99.ElementalBlast:IsAvailable() and (v112 == (10 - 7)) and (v113 == (1 + 2))) then
					if (v24(v101.EarthquakePlayer, not v16:IsInRange(25 + 15)) or ((1358 + 1463) < (6951 - 4520))) then
						return "earthquake aoe 38";
					end
				end
				if ((v99.Earthquake:IsReady() and v37 and (v51 == "cursor") and (v13:BuffUp(v99.EchoesofGreatSunderingBuff))) or ((4249 - (1140 + 235)) < (1388 + 793))) then
					if (v24(v101.EarthquakeCursor, not v16:IsInRange(37 + 3)) or ((691 + 1998) <= (395 - (33 + 19)))) then
						return "earthquake aoe 40";
					end
				end
				if ((v99.Earthquake:IsReady() and v37 and (v51 == "player") and (v13:BuffUp(v99.EchoesofGreatSunderingBuff))) or ((675 + 1194) == (6021 - 4012))) then
					if (v24(v101.EarthquakePlayer, not v16:IsInRange(18 + 22)) or ((6953 - 3407) < (2178 + 144))) then
						return "earthquake aoe 40";
					end
				end
				if ((v99.ElementalBlast:IsAvailable() and v39 and (v99.EchoesofGreatSundering:IsAvailable())) or ((2771 - (586 + 103)) == (435 + 4338))) then
					local v224 = 0 - 0;
					while true do
						if (((4732 - (1309 + 179)) > (1904 - 849)) and (v224 == (0 + 0))) then
							if (v103.CastTargetIf(v99.ElementalBlast, v111, "min", v120, nil, not v16:IsSpellInRange(v99.ElementalBlast)) or ((8897 - 5584) <= (1343 + 435))) then
								return "elemental_blast aoe 42";
							end
							if (v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast)) or ((3019 - 1598) >= (4192 - 2088))) then
								return "elemental_blast aoe 42";
							end
							break;
						end
					end
				end
				if (((2421 - (295 + 314)) <= (7979 - 4730)) and v99.ElementalBlast:IsAvailable() and v39 and (v99.EchoesofGreatSundering:IsAvailable())) then
					if (((3585 - (1300 + 662)) <= (6145 - 4188)) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
						return "elemental_blast aoe 44";
					end
				end
				v155 = 1759 - (1178 + 577);
			end
			if (((2292 + 2120) == (13042 - 8630)) and (v155 == (1411 - (851 + 554)))) then
				if (((1548 + 202) >= (2334 - 1492)) and v99.LavaBeam:IsAvailable() and v43 and (v112 >= (12 - 6)) and v13:BuffUp(v99.SurgeofPowerBuff) and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) then
					if (((4674 - (115 + 187)) > (1417 + 433)) and v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam))) then
						return "lava_beam aoe 66";
					end
				end
				if (((220 + 12) < (3235 - 2414)) and v99.ChainLightning:IsAvailable() and v36 and (v112 >= (1167 - (160 + 1001))) and v13:BuffUp(v99.SurgeofPowerBuff)) then
					if (((454 + 64) < (623 + 279)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
						return "chain_lightning aoe 68";
					end
				end
				if (((6128 - 3134) > (1216 - (237 + 121))) and v99.LavaBurst:IsAvailable() and v44 and v13:BuffUp(v99.LavaSurgeBuff) and v99.DeeplyRootedElements:IsAvailable() and v13:BuffUp(v99.WindspeakersLavaResurgenceBuff)) then
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((4652 - (525 + 372)) <= (1734 - 819))) then
						return "lava_burst aoe 70";
					end
				end
				if (((12964 - 9018) > (3885 - (96 + 46))) and v99.LavaBeam:IsAvailable() and v43 and v122() and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) then
					if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((2112 - (643 + 134)) >= (1194 + 2112))) then
						return "lava_beam aoe 72";
					end
				end
				if (((11614 - 6770) > (8364 - 6111)) and v99.LavaBurst:IsAvailable() and v44 and (v112 == (3 + 0)) and v99.MasteroftheElements:IsAvailable()) then
					if (((886 - 434) == (923 - 471)) and v103.CastCycle(v99.LavaBurst, v111, v118, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 74";
					end
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((5276 - (316 + 403)) < (1388 + 699))) then
						return "lava_burst aoe 74";
					end
				end
				v155 = 19 - 12;
			end
			if (((1401 + 2473) == (9755 - 5881)) and (v155 == (4 + 1))) then
				if ((v99.LavaBurst:IsAvailable() and v44 and v99.MasteroftheElements:IsAvailable() and not v122() and (v123() or (v13:HasTier(10 + 20, 6 - 4) and (v114() < (14 - 11)))) and (v121() < ((((124 - 64) - ((1 + 4) * v99.EyeoftheStorm:TalentRank())) - ((3 - 1) * v25(v99.FlowofPower:IsAvailable()))) - (1 + 9))) and (v112 < (14 - 9))) or ((1955 - (12 + 5)) > (19167 - 14232))) then
					if (v103.CastCycle(v99.LavaBurst, v111, v118, not v16:IsSpellInRange(v99.LavaBurst)) or ((9078 - 4823) < (7276 - 3853))) then
						return "lava_burst aoe 56";
					end
					if (((3605 - 2151) <= (506 + 1985)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 56";
					end
				end
				if ((v99.LavaBeam:IsAvailable() and v43 and (v123())) or ((6130 - (1656 + 317)) <= (2498 + 305))) then
					if (((3889 + 964) >= (7928 - 4946)) and v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam))) then
						return "lava_beam aoe 58";
					end
				end
				if (((20345 - 16211) > (3711 - (5 + 349))) and v99.ChainLightning:IsAvailable() and v36 and (v123())) then
					if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((16230 - 12813) < (3805 - (266 + 1005)))) then
						return "chain_lightning aoe 60";
					end
				end
				if ((v99.LavaBeam:IsAvailable() and v43 and v13:BuffUp(v99.Power) and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) or ((1794 + 928) <= (559 - 395))) then
					if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((3169 - 761) < (3805 - (561 + 1135)))) then
						return "lava_beam aoe 62";
					end
				end
				if ((v99.ChainLightning:IsAvailable() and v36 and (v122())) or ((42 - 9) == (4782 - 3327))) then
					if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((1509 - (507 + 559)) >= (10074 - 6059))) then
						return "chain_lightning aoe 64";
					end
				end
				v155 = 18 - 12;
			end
			if (((3770 - (212 + 176)) > (1071 - (250 + 655))) and (v155 == (0 - 0))) then
				if ((v99.FireElemental:IsReady() and v53 and ((v59 and v33) or not v59) and (v90 < v107)) or ((489 - 209) == (4785 - 1726))) then
					if (((3837 - (1869 + 87)) > (4484 - 3191)) and v24(v99.FireElemental)) then
						return "fire_elemental aoe 2";
					end
				end
				if (((4258 - (484 + 1417)) == (5051 - 2694)) and v99.StormElemental:IsReady() and v55 and ((v60 and v33) or not v60) and (v90 < v107)) then
					if (((205 - 82) == (896 - (48 + 725))) and v24(v99.StormElemental)) then
						return "storm_elemental aoe 4";
					end
				end
				if ((v99.Stormkeeper:IsAvailable() and (v99.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and not v123()) or ((2832 - 1776) >= (1972 + 1420))) then
					if (v24(v99.Stormkeeper) or ((2888 - 1807) < (301 + 774))) then
						return "stormkeeper aoe 7";
					end
				end
				if ((v99.TotemicRecall:IsCastable() and (v99.LiquidMagmaTotem:CooldownRemains() > (14 + 31)) and v49) or ((1902 - (152 + 701)) >= (5743 - (430 + 881)))) then
					if (v24(v99.TotemicRecall) or ((1826 + 2942) <= (1741 - (557 + 338)))) then
						return "totemic_recall aoe 8";
					end
				end
				if ((v99.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and (v66 == "cursor")) or ((993 + 2365) <= (4001 - 2581))) then
					if (v24(v101.LiquidMagmaTotemCursor, not v16:IsInRange(140 - 100)) or ((9933 - 6194) <= (6476 - 3471))) then
						return "liquid_magma_totem aoe 10";
					end
				end
				v155 = 802 - (499 + 302);
			end
			if ((v155 == (873 - (39 + 827))) or ((4579 - 2920) >= (4765 - 2631))) then
				if ((v99.LavaBurst:IsAvailable() and v44 and v13:BuffUp(v99.LavaSurgeBuff) and v99.DeeplyRootedElements:IsAvailable()) or ((12948 - 9688) < (3615 - 1260))) then
					if (v103.CastCycle(v99.LavaBurst, v111, v118, not v16:IsSpellInRange(v99.LavaBurst)) or ((58 + 611) == (12360 - 8137))) then
						return "lava_burst aoe 76";
					end
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((271 + 1421) < (930 - 342))) then
						return "lava_burst aoe 76";
					end
				end
				if ((v99.Icefury:IsAvailable() and (v99.Icefury:CooldownRemains() == (104 - (103 + 1))) and v42 and v99.ElectrifiedShocks:IsAvailable() and (v113 < (559 - (475 + 79)))) or ((10369 - 5572) < (11683 - 8032))) then
					if (v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury)) or ((540 + 3637) > (4269 + 581))) then
						return "icefury aoe 78";
					end
				end
				if ((v99.FrostShock:IsCastable() and v41 and v124() and v99.ElectrifiedShocks:IsAvailable() and v16:DebuffDown(v99.ElectrifiedShocksDebuff) and (v112 < (1508 - (1395 + 108))) and v99.UnrelentingCalamity:IsAvailable()) or ((1164 - 764) > (2315 - (7 + 1197)))) then
					if (((1331 + 1720) > (351 + 654)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
						return "frost_shock aoe 80";
					end
				end
				if (((4012 - (27 + 292)) <= (12840 - 8458)) and v99.LavaBeam:IsAvailable() and v43 and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime())) then
					if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((4185 - 903) > (17194 - 13094))) then
						return "lava_beam aoe 82";
					end
				end
				if ((v99.ChainLightning:IsAvailable() and v36) or ((7060 - 3480) < (5415 - 2571))) then
					if (((228 - (43 + 96)) < (18315 - 13825)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
						return "chain_lightning aoe 84";
					end
				end
				v155 = 17 - 9;
			end
			if ((v155 == (1 + 0)) or ((1408 + 3575) < (3573 - 1765))) then
				if (((1468 + 2361) > (7063 - 3294)) and v99.LiquidMagmaTotem:IsReady() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and (v66 == "player")) then
					if (((468 + 1017) <= (213 + 2691)) and v24(v101.LiquidMagmaTotemPlayer, not v16:IsInRange(1791 - (1414 + 337)))) then
						return "liquid_magma_totem aoe 11";
					end
				end
				if (((6209 - (1642 + 298)) == (11128 - 6859)) and v99.PrimordialWave:IsAvailable() and v47 and ((v64 and v34) or not v64) and v13:BuffDown(v99.PrimordialWaveBuff) and v13:BuffUp(v99.SurgeofPowerBuff) and v13:BuffDown(v99.SplinteredElementsBuff)) then
					local v225 = 0 - 0;
					while true do
						if (((1148 - 761) <= (916 + 1866)) and (v225 == (0 + 0))) then
							if (v103.CastTargetIf(v99.PrimordialWave, v111, "min", v118, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil) or ((2871 - (357 + 615)) <= (644 + 273))) then
								return "primordial_wave aoe 12";
							end
							if (v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave)) or ((10580 - 6268) <= (751 + 125))) then
								return "primordial_wave aoe 12";
							end
							break;
						end
					end
				end
				if (((4783 - 2551) <= (2077 + 519)) and v99.PrimordialWave:IsAvailable() and v47 and ((v64 and v34) or not v64) and v13:BuffDown(v99.PrimordialWaveBuff) and v99.DeeplyRootedElements:IsAvailable() and not v99.SurgeofPower:IsAvailable() and v13:BuffDown(v99.SplinteredElementsBuff)) then
					local v226 = 0 + 0;
					while true do
						if (((1317 + 778) < (4987 - (384 + 917))) and (v226 == (697 - (128 + 569)))) then
							if (v103.CastTargetIf(v99.PrimordialWave, v111, "min", v118, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil) or ((3138 - (1407 + 136)) >= (6361 - (687 + 1200)))) then
								return "primordial_wave aoe 14";
							end
							if (v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave)) or ((6329 - (556 + 1154)) < (10138 - 7256))) then
								return "primordial_wave aoe 14";
							end
							break;
						end
					end
				end
				if ((v99.PrimordialWave:IsAvailable() and v47 and ((v64 and v34) or not v64) and v13:BuffDown(v99.PrimordialWaveBuff) and v99.MasteroftheElements:IsAvailable() and not v99.LightningRod:IsAvailable()) or ((389 - (9 + 86)) >= (5252 - (275 + 146)))) then
					if (((330 + 1699) <= (3148 - (29 + 35))) and v103.CastTargetIf(v99.PrimordialWave, v111, "min", v118, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil)) then
						return "primordial_wave aoe 16";
					end
					if (v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave)) or ((9027 - 6990) == (7228 - 4808))) then
						return "primordial_wave aoe 16";
					end
				end
				if (((19679 - 15221) > (2543 + 1361)) and v99.FlameShock:IsCastable()) then
					local v227 = 1012 - (53 + 959);
					while true do
						if (((844 - (312 + 96)) >= (213 - 90)) and (v227 == (286 - (147 + 138)))) then
							if (((1399 - (813 + 86)) < (1642 + 174)) and v99.MasteroftheElements:IsAvailable() and v40 and not v99.LightningRod:IsAvailable() and (v99.FlameShockDebuff:AuraActiveCount() < (10 - 4))) then
								if (((4066 - (18 + 474)) == (1206 + 2368)) and v103.CastCycle(v99.FlameShock, v111, v116, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 22";
								end
								if (((721 - 500) < (1476 - (860 + 226))) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 22";
								end
							end
							if ((v99.DeeplyRootedElements:IsAvailable() and v40 and not v99.SurgeofPower:IsAvailable() and (v99.FlameShockDebuff:AuraActiveCount() < (309 - (121 + 182)))) or ((273 + 1940) <= (2661 - (988 + 252)))) then
								local v236 = 0 + 0;
								while true do
									if (((958 + 2100) < (6830 - (49 + 1921))) and (v236 == (890 - (223 + 667)))) then
										if (v103.CastCycle(v99.FlameShock, v111, v116, not v16:IsSpellInRange(v99.FlameShock)) or ((1348 - (51 + 1)) >= (7652 - 3206))) then
											return "flame_shock aoe 24";
										end
										if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((2982 - 1589) > (5614 - (146 + 979)))) then
											return "flame_shock aoe 24";
										end
										break;
									end
								end
							end
							v227 = 1 + 1;
						end
						if ((v227 == (608 - (311 + 294))) or ((12337 - 7913) < (12 + 15))) then
							if ((v99.DeeplyRootedElements:IsAvailable() and v40 and not v99.SurgeofPower:IsAvailable()) or ((3440 - (496 + 947)) > (5173 - (1233 + 125)))) then
								local v237 = 0 + 0;
								while true do
									if (((3109 + 356) > (364 + 1549)) and ((1645 - (963 + 682)) == v237)) then
										if (((612 + 121) < (3323 - (504 + 1000))) and v103.CastCycle(v99.FlameShock, v111, v117, not v16:IsSpellInRange(v99.FlameShock))) then
											return "flame_shock aoe 30";
										end
										if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((2960 + 1435) == (4331 + 424))) then
											return "flame_shock aoe 30";
										end
										break;
									end
								end
							end
							break;
						end
						if ((v227 == (1 + 1)) or ((5593 - 1800) < (2024 + 345))) then
							if ((v13:BuffUp(v99.SurgeofPowerBuff) and v40 and (not v99.LightningRod:IsAvailable() or v99.SkybreakersFieryDemise:IsAvailable())) or ((2376 + 1708) == (447 - (156 + 26)))) then
								local v238 = 0 + 0;
								while true do
									if (((6818 - 2460) == (4522 - (149 + 15))) and ((960 - (890 + 70)) == v238)) then
										if (v103.CastCycle(v99.FlameShock, v111, v117, not v16:IsSpellInRange(v99.FlameShock)) or ((3255 - (39 + 78)) < (1475 - (14 + 468)))) then
											return "flame_shock aoe 26";
										end
										if (((7322 - 3992) > (6492 - 4169)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
											return "flame_shock aoe 26";
										end
										break;
									end
								end
							end
							if ((v99.MasteroftheElements:IsAvailable() and v40 and not v99.LightningRod:IsAvailable()) or ((1871 + 1755) == (2396 + 1593))) then
								if (v103.CastCycle(v99.FlameShock, v111, v117, not v16:IsSpellInRange(v99.FlameShock)) or ((195 + 721) == (1207 + 1464))) then
									return "flame_shock aoe 28";
								end
								if (((72 + 200) == (520 - 248)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
									return "flame_shock aoe 28";
								end
							end
							v227 = 3 + 0;
						end
						if (((14930 - 10681) <= (123 + 4716)) and (v227 == (51 - (12 + 39)))) then
							if (((2584 + 193) < (9905 - 6705)) and v13:BuffUp(v99.SurgeofPowerBuff) and v40 and v99.LightningRod:IsAvailable() and v99.WindspeakersLavaResurgence:IsAvailable() and (v16:DebuffRemains(v99.FlameShockDebuff) < (v16:TimeToDie() - (3 - 2)))) then
								local v239 = 0 + 0;
								while true do
									if (((51 + 44) < (4962 - 3005)) and (v239 == (0 + 0))) then
										if (((3991 - 3165) < (3427 - (1596 + 114))) and v103.CastCycle(v99.FlameShock, v111, v116, not v16:IsSpellInRange(v99.FlameShock))) then
											return "flame_shock aoe 18";
										end
										if (((3722 - 2296) >= (1818 - (164 + 549))) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
											return "flame_shock aoe 18";
										end
										break;
									end
								end
							end
							if (((4192 - (1059 + 379)) <= (4195 - 816)) and v13:BuffUp(v99.SurgeofPowerBuff) and v40 and (not v99.LightningRod:IsAvailable() or v99.SkybreakersFieryDemise:IsAvailable()) and (v99.FlameShockDebuff:AuraActiveCount() < (4 + 2))) then
								local v240 = 0 + 0;
								while true do
									if ((v240 == (392 - (145 + 247))) or ((3223 + 704) == (653 + 760))) then
										if (v103.CastCycle(v99.FlameShock, v111, v116, not v16:IsSpellInRange(v99.FlameShock)) or ((3421 - 2267) <= (152 + 636))) then
											return "flame_shock aoe 20";
										end
										if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((1416 + 227) > (5485 - 2106))) then
											return "flame_shock aoe 20";
										end
										break;
									end
								end
							end
							v227 = 721 - (254 + 466);
						end
					end
				end
				v155 = 562 - (544 + 16);
			end
			if ((v155 == (5 - 3)) or ((3431 - (294 + 334)) > (4802 - (236 + 17)))) then
				if ((v99.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v107)) or ((95 + 125) >= (2353 + 669))) then
					if (((10627 - 7805) == (13360 - 10538)) and v24(v99.Ascendance)) then
						return "ascendance aoe 32";
					end
				end
				if ((v99.LavaBurst:IsAvailable() and v44 and v13:BuffUp(v99.LavaSurgeBuff) and v99.MasteroftheElements:IsAvailable() and not v122() and (v121() >= (((31 + 29) - ((5 + 0) * v99.EyeoftheStorm:TalentRank())) - ((796 - (413 + 381)) * v25(v99.FlowofPower:IsAvailable())))) and ((not v99.EchoesofGreatSundering:IsAvailable() and not v99.LightningRod:IsAvailable()) or v13:BuffUp(v99.EchoesofGreatSunderingBuff)) and ((v13:BuffDown(v99.AscendanceBuff) and (v112 > (1 + 2)) and not v99.UnrelentingCalamity:IsAvailable()) or (v113 == (5 - 2)))) or ((2755 - 1694) == (3827 - (582 + 1388)))) then
					if (((4702 - 1942) > (977 + 387)) and v103.CastCycle(v99.LavaBurst, v111, v118, not v16:IsSpellInRange(v99.LavaBurst))) then
						return "lava_burst aoe 34";
					end
					if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((5266 - (326 + 38)) <= (10634 - 7039))) then
						return "lava_burst aoe 34";
					end
				end
				if ((v99.Earthquake:IsReady() and v37 and (v51 == "cursor") and not v99.EchoesofGreatSundering:IsAvailable() and (v112 > (3 - 0)) and (v113 > (623 - (47 + 573)))) or ((1358 + 2494) == (1244 - 951))) then
					if (v24(v101.EarthquakeCursor, not v16:IsInRange(64 - 24)) or ((3223 - (1269 + 395)) == (5080 - (76 + 416)))) then
						return "earthquake aoe 36";
					end
				end
				if ((v99.Earthquake:IsReady() and v37 and (v51 == "player") and not v99.EchoesofGreatSundering:IsAvailable() and (v112 > (446 - (319 + 124))) and (v113 > (6 - 3))) or ((5491 - (564 + 443)) == (2181 - 1393))) then
					if (((5026 - (337 + 121)) >= (11447 - 7540)) and v24(v101.EarthquakePlayer, not v16:IsInRange(133 - 93))) then
						return "earthquake aoe 36";
					end
				end
				if (((3157 - (1261 + 650)) < (1469 + 2001)) and v99.Earthquake:IsReady() and v37 and (v51 == "cursor") and not v99.EchoesofGreatSundering:IsAvailable() and not v99.ElementalBlast:IsAvailable() and (v112 == (3 - 0)) and (v113 == (1820 - (772 + 1045)))) then
					if (((574 + 3494) >= (1116 - (102 + 42))) and v24(v101.EarthquakeCursor, not v16:IsInRange(1884 - (1524 + 320)))) then
						return "earthquake aoe 38";
					end
				end
				v155 = 1273 - (1049 + 221);
			end
		end
	end
	local function v131()
		if (((649 - (18 + 138)) < (9528 - 5635)) and v99.FireElemental:IsCastable() and v53 and ((v59 and v33) or not v59) and (v90 < v107)) then
			if (v24(v99.FireElemental) or ((2575 - (67 + 1035)) >= (3680 - (136 + 212)))) then
				return "fire_elemental single_target 2";
			end
		end
		if ((v99.StormElemental:IsCastable() and v55 and ((v60 and v33) or not v60) and (v90 < v107)) or ((17214 - 13163) <= (927 + 230))) then
			if (((557 + 47) < (4485 - (240 + 1364))) and v24(v99.StormElemental)) then
				return "storm_elemental single_target 4";
			end
		end
		if ((v99.TotemicRecall:IsCastable() and v49 and (v99.LiquidMagmaTotem:CooldownRemains() > (1127 - (1050 + 32))) and ((v99.LavaSurge:IsAvailable() and v99.SplinteredElements:IsAvailable()) or ((v112 > (3 - 2)) and (v113 > (1 + 0))))) or ((1955 - (331 + 724)) == (273 + 3104))) then
			if (((5103 - (269 + 375)) > (1316 - (267 + 458))) and v24(v99.TotemicRecall)) then
				return "totemic_recall single_target 7";
			end
		end
		if (((1057 + 2341) >= (4605 - 2210)) and v99.LiquidMagmaTotem:IsCastable() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and (v66 == "cursor") and ((v99.LavaSurge:IsAvailable() and v99.SplinteredElements:IsAvailable()) or (v99.FlameShockDebuff:AuraActiveCount() == (818 - (667 + 151))) or (v16:DebuffRemains(v99.FlameShockDebuff) < (1503 - (1410 + 87))) or ((v112 > (1898 - (1504 + 393))) and (v113 > (2 - 1))))) then
			if (v24(v101.LiquidMagmaTotemCursor, not v16:IsInRange(103 - 63)) or ((2979 - (461 + 335)) >= (361 + 2463))) then
				return "liquid_magma_totem single_target 8";
			end
		end
		if (((3697 - (1730 + 31)) == (3603 - (728 + 939))) and v99.LiquidMagmaTotem:IsCastable() and v54 and ((v61 and v33) or not v61) and (v90 < v107) and (v66 == "player") and ((v99.LavaSurge:IsAvailable() and v99.SplinteredElements:IsAvailable()) or (v99.FlameShockDebuff:AuraActiveCount() == (0 - 0)) or (v16:DebuffRemains(v99.FlameShockDebuff) < (11 - 5)) or ((v112 > (2 - 1)) and (v113 > (1069 - (138 + 930)))))) then
			if (v24(v101.LiquidMagmaTotemPlayer, not v16:IsInRange(37 + 3)) or ((3778 + 1054) < (3697 + 616))) then
				return "liquid_magma_totem single_target 8";
			end
		end
		if (((16692 - 12604) > (5640 - (459 + 1307))) and v99.PrimordialWave:IsAvailable() and v47 and v64 and (v90 < v107) and v34 and v13:BuffDown(v99.PrimordialWaveBuff) and v13:BuffDown(v99.SplinteredElementsBuff)) then
			if (((6202 - (474 + 1396)) == (7564 - 3232)) and v103.CastTargetIf(v99.PrimordialWave, v111, "min", v118, nil, not v16:IsSpellInRange(v99.PrimordialWave), nil, nil)) then
				return "primordial_wave single_target 10";
			end
			if (((3748 + 251) >= (10 + 2890)) and v24(v99.PrimordialWave, not v16:IsSpellInRange(v99.PrimordialWave))) then
				return "primordial_wave single_target 10";
			end
		end
		if ((v99.FlameShock:IsCastable() and v40 and (v112 == (2 - 1)) and v16:DebuffRefreshable(v99.FlameShockDebuff) and v13:BuffDown(v99.SurgeofPowerBuff) and (not v122() or (not v123() and ((v99.ElementalBlast:IsAvailable() and (v121() < ((12 + 78) - ((26 - 18) * v99.EyeoftheStorm:TalentRank())))) or (v121() < ((261 - 201) - ((596 - (562 + 29)) * v99.EyeoftheStorm:TalentRank()))))))) or ((2153 + 372) > (5483 - (374 + 1045)))) then
			if (((3460 + 911) == (13572 - 9201)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
				return "flame_shock single_target 12";
			end
		end
		if ((v99.FlameShock:IsCastable() and v40 and (v99.FlameShockDebuff:AuraActiveCount() == (638 - (448 + 190))) and (v112 > (1 + 0)) and (v113 > (1 + 0)) and (v99.DeeplyRootedElements:IsAvailable() or v99.Ascendance:IsAvailable() or v99.PrimordialWave:IsAvailable() or v99.SearingFlames:IsAvailable() or v99.MagmaChamber:IsAvailable()) and ((not v122() and (v123() or (v99.Stormkeeper:CooldownRemains() > (0 + 0)))) or not v99.SurgeofPower:IsAvailable())) or ((1022 - 756) > (15492 - 10506))) then
			local v164 = 1494 - (1307 + 187);
			while true do
				if (((7895 - 5904) >= (2165 - 1240)) and (v164 == (0 - 0))) then
					if (((1138 - (232 + 451)) < (1961 + 92)) and v103.CastTargetIf(v99.FlameShock, v111, "min", v118, nil, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flame_shock single_target 14";
					end
					if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((730 + 96) == (5415 - (510 + 54)))) then
						return "flame_shock single_target 14";
					end
					break;
				end
			end
		end
		if (((368 - 185) == (219 - (13 + 23))) and v99.FlameShock:IsCastable() and v40 and (v112 > (1 - 0)) and (v113 > (1 - 0)) and (v99.DeeplyRootedElements:IsAvailable() or v99.Ascendance:IsAvailable() or v99.PrimordialWave:IsAvailable() or v99.SearingFlames:IsAvailable() or v99.MagmaChamber:IsAvailable()) and ((v13:BuffUp(v99.SurgeofPowerBuff) and not v123() and v99.Stormkeeper:IsAvailable()) or not v99.SurgeofPower:IsAvailable())) then
			local v165 = 0 - 0;
			while true do
				if (((2247 - (830 + 258)) <= (6307 - 4519)) and (v165 == (0 + 0))) then
					if (v103.CastTargetIf(v99.FlameShock, v111, "min", v118, v115, not v16:IsSpellInRange(v99.FlameShock)) or ((2984 + 523) > (5759 - (860 + 581)))) then
						return "flame_shock single_target 16";
					end
					if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((11342 - 8267) <= (2354 + 611))) then
						return "flame_shock single_target 16";
					end
					break;
				end
			end
		end
		if (((1606 - (237 + 4)) <= (4726 - 2715)) and v99.Stormkeeper:IsAvailable() and (v99.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and v13:BuffDown(v99.AscendanceBuff) and not v123() and (v121() >= (219 - 103)) and v99.ElementalBlast:IsAvailable() and v99.SurgeofPower:IsAvailable() and v99.SwellingMaelstrom:IsAvailable() and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.PrimordialSurge:IsAvailable()) then
			if (v24(v99.Stormkeeper) or ((2273 + 503) > (2054 + 1521))) then
				return "stormkeeper single_target 18";
			end
		end
		if ((v99.Stormkeeper:IsAvailable() and (v99.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and v13:BuffDown(v99.AscendanceBuff) and not v123() and v13:BuffUp(v99.SurgeofPowerBuff) and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.PrimordialSurge:IsAvailable()) or ((1096 + 1458) == (2614 + 2190))) then
			if (((4003 - (85 + 1341)) == (4396 - 1819)) and v24(v99.Stormkeeper)) then
				return "stormkeeper single_target 20";
			end
		end
		if ((v99.Stormkeeper:IsAvailable() and (v99.Stormkeeper:CooldownRemains() == (0 - 0)) and not v13:BuffUp(v99.StormkeeperBuff) and v48 and ((v65 and v34) or not v65) and (v90 < v107) and v13:BuffDown(v99.AscendanceBuff) and not v123() and (not v99.SurgeofPower:IsAvailable() or not v99.ElementalBlast:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.EchooftheElements:IsAvailable() or v99.PrimordialSurge:IsAvailable())) or ((378 - (45 + 327)) >= (3564 - 1675))) then
			if (((1008 - (444 + 58)) <= (823 + 1069)) and v24(v99.Stormkeeper)) then
				return "stormkeeper single_target 22";
			end
		end
		if ((v99.Ascendance:IsCastable() and v52 and ((v58 and v33) or not v58) and (v90 < v107) and not v123()) or ((346 + 1662) > (1085 + 1133))) then
			if (((1098 - 719) <= (5879 - (64 + 1668))) and v24(v99.Ascendance)) then
				return "ascendance single_target 24";
			end
		end
		if ((v99.LightningBolt:IsAvailable() and v45 and v123() and v13:BuffUp(v99.SurgeofPowerBuff)) or ((6487 - (1227 + 746)) <= (3101 - 2092))) then
			if (v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt)) or ((6487 - 2991) == (1686 - (415 + 79)))) then
				return "lightning_bolt single_target 26";
			end
		end
		if ((v99.LavaBeam:IsCastable() and v43 and (v112 > (1 + 0)) and (v113 > (492 - (142 + 349))) and v123() and not v99.SurgeofPower:IsAvailable()) or ((90 + 118) == (4067 - 1108))) then
			if (((2126 + 2151) >= (926 + 387)) and v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam))) then
				return "lava_beam single_target 28";
			end
		end
		if (((7045 - 4458) < (5038 - (1710 + 154))) and v99.ChainLightning:IsAvailable() and v36 and (v112 > (319 - (200 + 118))) and (v113 > (1 + 0)) and v123() and not v99.SurgeofPower:IsAvailable()) then
			if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((7203 - 3083) <= (3259 - 1061))) then
				return "chain_lightning single_target 30";
			end
		end
		if ((v99.LavaBurst:IsAvailable() and v44 and v123() and not v122() and not v99.SurgeofPower:IsAvailable() and v99.MasteroftheElements:IsAvailable()) or ((1419 + 177) == (849 + 9))) then
			if (((1729 + 1491) == (515 + 2705)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst single_target 32";
			end
		end
		if ((v99.LightningBolt:IsAvailable() and v45 and v123() and not v99.SurgeofPower:IsAvailable() and v122()) or ((3037 - 1635) > (4870 - (363 + 887)))) then
			if (((4494 - 1920) == (12251 - 9677)) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 34";
			end
		end
		if (((278 + 1520) < (6451 - 3694)) and v99.LightningBolt:IsAvailable() and v45 and v123() and not v99.SurgeofPower:IsAvailable() and not v99.MasteroftheElements:IsAvailable()) then
			if (v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt)) or ((258 + 119) > (4268 - (674 + 990)))) then
				return "lightning_bolt single_target 36";
			end
		end
		if (((163 + 405) < (373 + 538)) and v99.LightningBolt:IsAvailable() and v45 and v13:BuffUp(v99.SurgeofPowerBuff) and v99.LightningRod:IsAvailable()) then
			if (((5206 - 1921) < (5283 - (507 + 548))) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 38";
			end
		end
		if (((4753 - (289 + 548)) > (5146 - (821 + 997))) and v99.Icefury:IsAvailable() and (v99.Icefury:CooldownRemains() == (255 - (195 + 60))) and v42 and v99.ElectrifiedShocks:IsAvailable() and v99.LightningRod:IsAvailable() and v99.LightningRod:IsAvailable()) then
			if (((673 + 1827) < (5340 - (251 + 1250))) and v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury))) then
				return "icefury single_target 40";
			end
		end
		if (((1485 - 978) == (349 + 158)) and v99.FrostShock:IsCastable() and v41 and v124() and v99.ElectrifiedShocks:IsAvailable() and ((v16:DebuffRemains(v99.ElectrifiedShocksDebuff) < (1034 - (809 + 223))) or (v13:BuffRemains(v99.IcefuryBuff) <= v13:GCD())) and v99.LightningRod:IsAvailable()) then
			if (((350 - 110) <= (9504 - 6339)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 42";
			end
		end
		if (((2757 - 1923) >= (593 + 212)) and v99.FrostShock:IsCastable() and v41 and v124() and v99.ElectrifiedShocks:IsAvailable() and (v121() >= (27 + 23)) and (v16:DebuffRemains(v99.ElectrifiedShocksDebuff) < ((619 - (14 + 603)) * v13:GCD())) and v123() and v99.LightningRod:IsAvailable()) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((3941 - (118 + 11)) < (375 + 1941))) then
				return "frost_shock single_target 44";
			end
		end
		if ((v99.LavaBeam:IsCastable() and v43 and (v112 > (1 + 0)) and (v113 > (2 - 1)) and v122() and (v13:BuffRemains(v99.AscendanceBuff) > v99.LavaBeam:CastTime()) and not v13:HasTier(980 - (551 + 398), 3 + 1)) or ((944 + 1708) <= (1246 + 287))) then
			if (v24(v99.LavaBeam, not v16:IsSpellInRange(v99.LavaBeam)) or ((13381 - 9783) < (3364 - 1904))) then
				return "lava_beam single_target 46";
			end
		end
		if ((v99.FrostShock:IsCastable() and v41 and v124() and v123() and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.PrimordialSurge:IsAvailable() and v99.ElementalBlast:IsAvailable() and (((v121() >= (20 + 41)) and (v121() < (297 - 222)) and (v99.LavaBurst:CooldownRemains() > v13:GCD())) or ((v121() >= (14 + 35)) and (v121() < (152 - (40 + 49))) and (v99.LavaBurst:CooldownRemains() > (0 - 0))))) or ((4606 - (99 + 391)) < (986 + 206))) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((14844 - 11467) <= (2235 - 1332))) then
				return "frost_shock single_target 48";
			end
		end
		if (((3873 + 103) >= (1154 - 715)) and v99.FrostShock:IsCastable() and v41 and v124() and not v99.LavaSurge:IsAvailable() and not v99.EchooftheElements:IsAvailable() and not v99.ElementalBlast:IsAvailable() and (((v121() >= (1640 - (1032 + 572))) and (v121() < (467 - (203 + 214))) and (v99.LavaBurst:CooldownRemains() > v13:GCD())) or ((v121() >= (1841 - (568 + 1249))) and (v121() < (30 + 8)) and (v99.LavaBurst:CooldownRemains() > (0 - 0))))) then
			if (((14492 - 10740) == (5058 - (913 + 393))) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 50";
			end
		end
		if (((11425 - 7379) > (3807 - 1112)) and v99.LavaBurst:IsAvailable() and v44 and v13:BuffUp(v99.WindspeakersLavaResurgenceBuff) and (v99.EchooftheElements:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.PrimordialSurge:IsAvailable() or ((v121() >= (473 - (269 + 141))) and v99.MasteroftheElements:IsAvailable()) or ((v121() >= (84 - 46)) and v13:BuffUp(v99.EchoesofGreatSunderingBuff) and (v112 > (1982 - (362 + 1619))) and (v113 > (1626 - (950 + 675)))) or not v99.ElementalBlast:IsAvailable())) then
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((1367 + 2178) == (4376 - (216 + 963)))) then
				return "lava_burst single_target 52";
			end
		end
		if (((3681 - (485 + 802)) > (932 - (432 + 127))) and v99.LavaBurst:IsAvailable() and v44 and v13:BuffUp(v99.LavaSurgeBuff) and (v99.EchooftheElements:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.PrimordialSurge:IsAvailable() or not v99.MasteroftheElements:IsAvailable() or not v99.ElementalBlast:IsAvailable())) then
			if (((5228 - (1065 + 8)) <= (2351 + 1881)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst single_target 54";
			end
		end
		if ((v99.LavaBurst:IsAvailable() and v44 and v13:BuffUp(v99.AscendanceBuff) and (v13:HasTier(1632 - (635 + 966), 3 + 1) or not v99.ElementalBlast:IsAvailable())) or ((3623 - (5 + 37)) == (8637 - 5164))) then
			if (((2079 + 2916) > (5299 - 1951)) and v103.CastCycle(v99.LavaBurst, v111, v119, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst single_target 56";
			end
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((353 + 401) > (7738 - 4014))) then
				return "lava_burst single_target 56";
			end
		end
		if (((822 - 605) >= (106 - 49)) and v99.LavaBurst:IsAvailable() and v44 and v13:BuffDown(v99.AscendanceBuff) and (not v99.ElementalBlast:IsAvailable() or not v99.MountainsWillFall:IsAvailable()) and not v99.LightningRod:IsAvailable() and v13:HasTier(73 - 42, 3 + 1)) then
			if (v103.CastCycle(v99.LavaBurst, v111, v119, not v16:IsSpellInRange(v99.LavaBurst)) or ((2599 - (318 + 211)) >= (19864 - 15827))) then
				return "lava_burst single_target 58";
			end
			if (((4292 - (963 + 624)) == (1157 + 1548)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst single_target 58";
			end
		end
		if (((907 - (518 + 328)) == (142 - 81)) and v99.LavaBurst:IsAvailable() and v44 and v99.MasteroftheElements:IsAvailable() and not v122() and not v99.LightningRod:IsAvailable()) then
			if (v103.CastCycle(v99.LavaBurst, v111, v119, not v16:IsSpellInRange(v99.LavaBurst)) or ((1116 - 417) >= (1613 - (301 + 16)))) then
				return "lava_burst single_target 60";
			end
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((5225 - 3442) >= (10155 - 6539))) then
				return "lava_burst single_target 60";
			end
		end
		if ((v99.LavaBurst:IsAvailable() and v44 and v99.MasteroftheElements:IsAvailable() and not v122() and ((v121() >= (195 - 120)) or ((v121() >= (46 + 4)) and not v99.ElementalBlast:IsAvailable())) and v99.SwellingMaelstrom:IsAvailable() and (v121() <= (74 + 56))) or ((8353 - 4440) > (2724 + 1803))) then
			if (((417 + 3959) > (2597 - 1780)) and v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst single_target 62";
			end
		end
		if (((1569 + 3292) > (1843 - (829 + 190))) and v99.Earthquake:IsReady() and v37 and (v51 == "cursor") and v13:BuffUp(v99.EchoesofGreatSunderingBuff) and ((not v99.ElementalBlast:IsAvailable() and (v112 < (7 - 5))) or (v112 > (1 - 0)))) then
			if (v24(v101.EarthquakeCursor, not v16:IsInRange(55 - 15)) or ((3435 - 2052) >= (506 + 1625))) then
				return "earthquake single_target 64";
			end
		end
		if ((v99.Earthquake:IsReady() and v37 and (v51 == "player") and v13:BuffUp(v99.EchoesofGreatSunderingBuff) and ((not v99.ElementalBlast:IsAvailable() and (v112 < (1 + 1))) or (v112 > (2 - 1)))) or ((1771 + 105) >= (3154 - (520 + 93)))) then
			if (((2058 - (259 + 17)) <= (218 + 3554)) and v24(v101.EarthquakePlayer, not v16:IsInRange(15 + 25))) then
				return "earthquake single_target 64";
			end
		end
		if ((v99.Earthquake:IsReady() and v37 and (v51 == "cursor") and (v112 > (3 - 2)) and (v113 > (592 - (396 + 195))) and not v99.EchoesofGreatSundering:IsAvailable() and not v99.ElementalBlast:IsAvailable()) or ((13636 - 8936) < (2574 - (440 + 1321)))) then
			if (((5028 - (1059 + 770)) < (18727 - 14677)) and v24(v101.EarthquakeCursor, not v16:IsInRange(585 - (424 + 121)))) then
				return "earthquake single_target 66";
			end
		end
		if ((v99.Earthquake:IsReady() and v37 and (v51 == "player") and (v112 > (1 + 0)) and (v113 > (1348 - (641 + 706))) and not v99.EchoesofGreatSundering:IsAvailable() and not v99.ElementalBlast:IsAvailable()) or ((1961 + 2990) < (4870 - (249 + 191)))) then
			if (((418 - 322) == (43 + 53)) and v24(v101.EarthquakePlayer, not v16:IsInRange(154 - 114))) then
				return "earthquake single_target 66";
			end
		end
		if ((v99.ElementalBlast:IsAvailable() and v39 and (not v99.MasteroftheElements:IsAvailable() or (v122() and v16:DebuffUp(v99.ElectrifiedShocksDebuff)))) or ((3166 - (183 + 244)) > (197 + 3811))) then
			if (v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast)) or ((753 - (434 + 296)) == (3618 - 2484))) then
				return "elemental_blast single_target 68";
			end
		end
		if ((v99.FrostShock:IsCastable() and v41 and v124() and v122() and (v121() < (622 - (169 + 343))) and (v99.LavaBurst:ChargesFractional() < (1 + 0)) and v99.ElectrifiedShocks:IsAvailable() and v99.ElementalBlast:IsAvailable() and not v99.LightningRod:IsAvailable()) or ((4737 - 2044) >= (12066 - 7955))) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((3536 + 780) <= (6085 - 3939))) then
				return "frost_shock single_target 70";
			end
		end
		if ((v99.ElementalBlast:IsAvailable() and v39 and (v122() or v99.LightningRod:IsAvailable())) or ((4669 - (651 + 472)) <= (2123 + 686))) then
			if (((2116 + 2788) > (2643 - 477)) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
				return "elemental_blast single_target 72";
			end
		end
		if (((592 - (397 + 86)) >= (966 - (423 + 453))) and v99.EarthShock:IsReady() and v38) then
			if (((507 + 4471) > (383 + 2522)) and v24(v99.EarthShock, not v16:IsSpellInRange(v99.EarthShock))) then
				return "earth_shock single_target 74";
			end
		end
		if ((v99.FrostShock:IsCastable() and v41 and v124() and v99.ElectrifiedShocks:IsAvailable() and v122() and not v99.LightningRod:IsAvailable() and (v112 > (1 + 0)) and (v113 > (1 + 0))) or ((2704 + 322) <= (3470 - (50 + 1140)))) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((1429 + 224) <= (655 + 453))) then
				return "frost_shock single_target 76";
			end
		end
		if (((181 + 2728) > (3746 - 1137)) and v99.LavaBurst:IsAvailable() and v44 and v13:BuffUp(v99.FluxMeltingBuff) and (v112 > (1 + 0))) then
			if (((1353 - (157 + 439)) > (337 - 143)) and v103.CastCycle(v99.LavaBurst, v111, v119, not v16:IsSpellInRange(v99.LavaBurst))) then
				return "lava_burst single_target 78";
			end
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((102 - 71) >= (4135 - 2737))) then
				return "lava_burst single_target 78";
			end
		end
		if (((4114 - (782 + 136)) <= (5727 - (112 + 743))) and v99.FrostShock:IsCastable() and v41 and v124() and v99.FluxMelting:IsAvailable() and v13:BuffDown(v99.FluxMeltingBuff)) then
			if (((4497 - (1026 + 145)) == (571 + 2755)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 80";
			end
		end
		if (((2151 - (493 + 225)) <= (14254 - 10376)) and v99.FrostShock:IsCastable() and v41 and v124() and ((v99.ElectrifiedShocks:IsAvailable() and (v16:DebuffRemains(v99.ElectrifiedShocksDebuff) < (2 + 0))) or (v13:BuffRemains(v99.IcefuryBuff) < (15 - 9)))) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((31 + 1552) == (4958 - 3223))) then
				return "frost_shock single_target 82";
			end
		end
		if ((v99.LavaBurst:IsAvailable() and v44 and (v99.EchooftheElements:IsAvailable() or v99.LavaSurge:IsAvailable() or v99.PrimordialSurge:IsAvailable() or not v99.ElementalBlast:IsAvailable() or not v99.MasteroftheElements:IsAvailable() or v123())) or ((868 + 2113) == (3926 - 1576))) then
			if (v103.CastCycle(v99.LavaBurst, v111, v119, not v16:IsSpellInRange(v99.LavaBurst)) or ((6061 - (210 + 1385)) <= (2182 - (1201 + 488)))) then
				return "lava_burst single_target 84";
			end
			if (v24(v99.LavaBurst, not v16:IsSpellInRange(v99.LavaBurst)) or ((1579 + 968) <= (3533 - 1546))) then
				return "lava_burst single_target 84";
			end
		end
		if (((5310 - 2349) > (3325 - (352 + 233))) and v99.ElementalBlast:IsAvailable() and v39) then
			if (((8932 - 5236) >= (1965 + 1647)) and v24(v99.ElementalBlast, not v16:IsSpellInRange(v99.ElementalBlast))) then
				return "elemental_blast single_target 86";
			end
		end
		if ((v99.ChainLightning:IsAvailable() and v36 and v122() and v99.UnrelentingCalamity:IsAvailable() and (v112 > (2 - 1)) and (v113 > (575 - (489 + 85)))) or ((4471 - (277 + 1224)) == (3371 - (663 + 830)))) then
			if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((3244 + 449) < (4840 - 2863))) then
				return "chain_lightning single_target 88";
			end
		end
		if ((v99.LightningBolt:IsAvailable() and v45 and v122() and v99.UnrelentingCalamity:IsAvailable()) or ((1805 - (461 + 414)) > (353 + 1748))) then
			if (((1662 + 2491) > (295 + 2791)) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 90";
			end
		end
		if ((v99.Icefury:IsAvailable() and (v99.Icefury:CooldownRemains() == (0 + 0)) and v42) or ((4904 - (172 + 78)) <= (6530 - 2480))) then
			if (v24(v99.Icefury, not v16:IsSpellInRange(v99.Icefury)) or ((958 + 1644) < (2158 - 662))) then
				return "icefury single_target 92";
			end
		end
		if ((v99.ChainLightning:IsAvailable() and v36 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v99.LightningRodDebuff) and (v16:DebuffUp(v99.ElectrifiedShocksDebuff) or v122()) and (v112 > (1 + 0)) and (v113 > (1 + 0))) or ((1708 - 688) > (2879 - 591))) then
			if (((83 + 245) == (182 + 146)) and v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning))) then
				return "chain_lightning single_target 94";
			end
		end
		if (((538 + 973) < (15158 - 11350)) and v99.LightningBolt:IsAvailable() and v45 and v15:IsActive() and (v15:Name() == "Greater Storm Elemental") and v16:DebuffUp(v99.LightningRodDebuff) and (v16:DebuffUp(v99.ElectrifiedShocksDebuff) or v122())) then
			if (v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt)) or ((5847 - 3337) > (1509 + 3410))) then
				return "lightning_bolt single_target 96";
			end
		end
		if (((2720 + 2043) == (5210 - (133 + 314))) and v99.FrostShock:IsCastable() and v41 and v124() and v122() and v13:BuffDown(v99.LavaSurgeBuff) and not v99.ElectrifiedShocks:IsAvailable() and not v99.FluxMelting:IsAvailable() and (v99.LavaBurst:ChargesFractional() < (1 + 0)) and v99.EchooftheElements:IsAvailable()) then
			if (((4350 - (199 + 14)) > (6615 - 4767)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 98";
			end
		end
		if (((3985 - (647 + 902)) <= (9423 - 6289)) and v99.FrostShock:IsCastable() and v41 and v124() and (v99.FluxMelting:IsAvailable() or (v99.ElectrifiedShocks:IsAvailable() and not v99.LightningRod:IsAvailable()))) then
			if (((3956 - (85 + 148)) == (5012 - (426 + 863))) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 100";
			end
		end
		if ((v99.ChainLightning:IsAvailable() and v36 and v122() and v13:BuffDown(v99.LavaSurgeBuff) and (v99.LavaBurst:ChargesFractional() < (4 - 3)) and v99.EchooftheElements:IsAvailable() and (v112 > (1655 - (873 + 781))) and (v113 > (1 - 0))) or ((10926 - 6880) >= (1789 + 2527))) then
			if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((7418 - 5410) < (2764 - 835))) then
				return "chain_lightning single_target 102";
			end
		end
		if (((7078 - 4694) > (3722 - (414 + 1533))) and v99.LightningBolt:IsAvailable() and v45 and v122() and v13:BuffDown(v99.LavaSurgeBuff) and (v99.LavaBurst:ChargesFractional() < (1 + 0)) and v99.EchooftheElements:IsAvailable()) then
			if (v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt)) or ((5098 - (443 + 112)) <= (5855 - (888 + 591)))) then
				return "lightning_bolt single_target 104";
			end
		end
		if (((1880 - 1152) == (42 + 686)) and v99.FrostShock:IsCastable() and v41 and v124() and not v99.ElectrifiedShocks:IsAvailable() and not v99.FluxMelting:IsAvailable()) then
			if (v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock)) or ((4052 - 2976) > (1824 + 2847))) then
				return "frost_shock single_target 106";
			end
		end
		if (((896 + 955) >= (41 + 337)) and v99.ChainLightning:IsAvailable() and v36 and (v112 > (1 - 0)) and (v113 > (1 - 0))) then
			if (v24(v99.ChainLightning, not v16:IsSpellInRange(v99.ChainLightning)) or ((3626 - (136 + 1542)) >= (11398 - 7922))) then
				return "chain_lightning single_target 108";
			end
		end
		if (((4759 + 35) >= (1324 - 491)) and v99.LightningBolt:IsAvailable() and v45) then
			if (((2960 + 1130) == (4576 - (68 + 418))) and v24(v99.LightningBolt, not v16:IsSpellInRange(v99.LightningBolt))) then
				return "lightning_bolt single_target 110";
			end
		end
		if ((v99.FlameShock:IsCastable() and v40 and (v13:IsMoving())) or ((10187 - 6429) == (4532 - 2034))) then
			local v166 = 0 + 0;
			while true do
				if ((v166 == (1092 - (770 + 322))) or ((155 + 2518) < (456 + 1119))) then
					if (v103.CastCycle(v99.FlameShock, v111, v115, not v16:IsSpellInRange(v99.FlameShock)) or ((508 + 3213) <= (2081 - 626))) then
						return "flame_shock single_target 112";
					end
					if (((1810 - 876) < (6182 - 3912)) and v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock))) then
						return "flame_shock single_target 112";
					end
					break;
				end
			end
		end
		if ((v99.FlameShock:IsCastable() and v40) or ((5929 - 4317) == (700 + 555))) then
			if (v24(v99.FlameShock, not v16:IsSpellInRange(v99.FlameShock)) or ((6519 - 2167) < (2018 + 2188))) then
				return "flame_shock single_target 114";
			end
		end
		if ((v99.FrostShock:IsCastable() and v41) or ((1754 + 1106) <= (142 + 39))) then
			if (((12132 - 8910) >= (2120 - 593)) and v24(v99.FrostShock, not v16:IsSpellInRange(v99.FrostShock))) then
				return "frost_shock single_target 116";
			end
		end
	end
	local function v132()
		local v156 = 0 + 0;
		while true do
			if (((6932 - 5427) <= (7011 - 4890)) and (v156 == (1 + 0))) then
				if (((3681 - 2937) == (1575 - (762 + 69))) and v30) then
					return v30;
				end
				if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((6408 - 4429) >= (2444 + 392))) then
					if (((1187 + 646) <= (6453 - 3785)) and v24(v99.AncestralSpirit, nil, true)) then
						return "ancestral_spirit";
					end
				end
				v156 = 1 + 1;
			end
			if (((59 + 3627) == (14361 - 10675)) and (v156 == (157 - (8 + 149)))) then
				if (((4787 - (1199 + 121)) > (806 - 329)) and v73 and v99.EarthShield:IsCastable() and v13:BuffDown(v99.EarthShieldBuff) and ((v74 == "Earth Shield") or (v99.ElementalOrbit:IsAvailable() and v13:BuffUp(v99.LightningShield)))) then
					if (v24(v99.EarthShield) or ((7422 - 4134) >= (1458 + 2083))) then
						return "earth_shield main 2";
					end
				elseif ((v73 and v99.LightningShield:IsCastable() and v13:BuffDown(v99.LightningShieldBuff) and ((v74 == "Lightning Shield") or (v99.ElementalOrbit:IsAvailable() and v13:BuffUp(v99.EarthShield)))) or ((12696 - 9139) == (10534 - 5994))) then
					if (v24(v99.LightningShield) or ((231 + 30) > (3074 - (518 + 1289)))) then
						return "lightning_shield main 2";
					end
				end
				v30 = v126();
				v156 = 1 - 0;
			end
			if (((169 + 1103) < (5634 - 1776)) and (v156 == (2 + 0))) then
				if (((4133 - (304 + 165)) == (3459 + 205)) and v99.AncestralSpirit:IsCastable() and v99.AncestralSpirit:IsReady() and not v13:AffectingCombat() and v14:Exists() and v14:IsDeadOrGhost() and v14:IsAPlayer() and not v13:CanAttack(v14)) then
					if (((2101 - (54 + 106)) >= (2419 - (1618 + 351))) and v24(v101.AncestralSpiritMouseover)) then
						return "ancestral_spirit mouseover";
					end
				end
				v108, v109 = v29();
				v156 = 3 + 0;
			end
			if ((v156 == (1019 - (10 + 1006))) or ((1167 + 3479) < (46 + 278))) then
				if (((12426 - 8593) == (4866 - (912 + 121))) and v99.ImprovedFlametongueWeapon:IsAvailable() and v50 and (not v108 or (v109 < (283529 + 316471))) and v99.FlametongueWeapon:IsAvailable()) then
					if (v24(v99.FlamentongueWeapon) or ((2529 - (1140 + 149)) > (2157 + 1213))) then
						return "flametongue_weapon enchant";
					end
				end
				if ((not v13:AffectingCombat() and v31 and v103.TargetIsValid()) or ((3306 - 825) == (871 + 3811))) then
					v30 = v129();
					if (((16177 - 11450) >= (389 - 181)) and v30) then
						return v30;
					end
				end
				break;
			end
		end
	end
	local function v133()
		local v157 = 0 + 0;
		while true do
			if (((971 - 691) < (4037 - (165 + 21))) and (v157 == (114 - (61 + 50)))) then
				if ((v99.Purge:IsReady() and v96 and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v103.UnitHasMagicBuff(v16)) or ((1239 + 1768) > (15223 - 12029))) then
					if (v24(v99.Purge, not v16:IsSpellInRange(v99.Purge)) or ((4303 - 2167) >= (1158 + 1788))) then
						return "purge damage";
					end
				end
				if (((3625 - (1295 + 165)) <= (576 + 1945)) and v103.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
					local v228 = 0 + 0;
					local v229;
					while true do
						if (((4258 - (819 + 578)) > (2063 - (331 + 1071))) and (v228 == (743 - (588 + 155)))) then
							if (((5807 - (546 + 736)) > (6456 - (1834 + 103))) and (v90 < v107) and v57 and ((v63 and v33) or not v63)) then
								if (((1955 + 1223) > (2899 - 1927)) and v99.BloodFury:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff) or (v99.Ascendance:CooldownRemains() > (1816 - (1536 + 230))))) then
									if (((5257 - (128 + 363)) == (1014 + 3752)) and v24(v99.BloodFury)) then
										return "blood_fury main 2";
									end
								end
								if ((v99.Berserking:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff))) or ((6829 - 4084) > (808 + 2320))) then
									if (v24(v99.Berserking) or ((1895 - 751) >= (13559 - 8953))) then
										return "berserking main 4";
									end
								end
								if (((8107 - 4769) >= (191 + 86)) and v99.Fireblood:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff) or (v99.Ascendance:CooldownRemains() > (1059 - (615 + 394))))) then
									if (((2357 + 253) > (2440 + 120)) and v24(v99.Fireblood)) then
										return "fireblood main 6";
									end
								end
								if ((v99.AncestralCall:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff) or (v99.Ascendance:CooldownRemains() > (152 - 102)))) or ((5415 - 4221) > (3734 - (59 + 592)))) then
									if (((2027 - 1111) >= (1375 - 628)) and v24(v99.AncestralCall)) then
										return "ancestral_call main 8";
									end
								end
								if ((v99.BagofTricks:IsCastable() and (not v99.Ascendance:IsAvailable() or v13:BuffUp(v99.AscendanceBuff))) or ((1723 + 721) > (3125 - (70 + 101)))) then
									if (((7149 - 4257) < (2492 + 1022)) and v24(v99.BagofTricks)) then
										return "bag_of_tricks main 10";
									end
								end
							end
							if (((1338 - 805) == (774 - (123 + 118))) and (v90 < v107)) then
								if (((145 + 450) <= (43 + 3370)) and v56 and ((v33 and v62) or not v62)) then
									v30 = v128();
									if (((4477 - (653 + 746)) >= (4845 - 2254)) and v30) then
										return v30;
									end
								end
							end
							v228 = 1 - 0;
						end
						if (((8564 - 5365) < (1779 + 2251)) and (v228 == (1 + 0))) then
							if (((679 + 98) < (255 + 1823)) and v99.NaturesSwiftness:IsCastable() and v46) then
								if (((265 + 1431) <= (5594 - 3312)) and v24(v99.NaturesSwiftness)) then
									return "natures_swiftness main 12";
								end
							end
							v229 = v103.HandleDPSPotion(v13:BuffUp(v99.AscendanceBuff));
							v228 = 2 + 0;
						end
						if ((v228 == (4 - 1)) or ((2995 - (885 + 349)) >= (1956 + 506))) then
							if (((12411 - 7860) > (6771 - 4443)) and true) then
								local v241 = 968 - (915 + 53);
								while true do
									if (((4626 - (768 + 33)) >= (1788 - 1321)) and ((0 - 0) == v241)) then
										v30 = v131();
										if (v30 or ((3218 - (287 + 41)) == (1404 - (638 + 209)))) then
											return v30;
										end
										v241 = 1 + 0;
									end
									if ((v241 == (1687 - (96 + 1590))) or ((6442 - (741 + 931)) == (1427 + 1477))) then
										if (v24(v99.Pool) or ((11119 - 7216) == (21191 - 16655))) then
											return "Pool for SingleTarget()";
										end
										break;
									end
								end
							end
							break;
						end
						if (((1757 + 2336) <= (2082 + 2763)) and (v228 == (1 + 1))) then
							if (((5953 - 4384) <= (1186 + 2461)) and v229) then
								return v229;
							end
							if ((v32 and (v112 > (1 + 1)) and (v113 > (8 - 6))) or ((3631 + 415) >= (5421 - (64 + 430)))) then
								local v242 = 0 + 0;
								while true do
									if (((4986 - (106 + 257)) >= (1976 + 811)) and (v242 == (721 - (496 + 225)))) then
										v30 = v130();
										if (((4567 - 2333) >= (5991 - 4761)) and v30) then
											return v30;
										end
										v242 = 1659 - (256 + 1402);
									end
									if ((v242 == (1900 - (30 + 1869))) or ((1712 - (213 + 1156)) == (1974 - (96 + 92)))) then
										if (((438 + 2132) > (3308 - (142 + 757))) and v24(v99.Pool)) then
											return "Pool for Aoe()";
										end
										break;
									end
								end
							end
							v228 = 3 + 0;
						end
					end
				end
				break;
			end
			if ((v157 == (1 + 1)) or ((2688 - (32 + 47)) >= (5211 - (1053 + 924)))) then
				if (v17 or ((2971 + 62) >= (6942 - 2911))) then
					if (v84 or ((3049 - (685 + 963)) == (9491 - 4823))) then
						v30 = v125();
						if (((4328 - 1552) >= (3030 - (541 + 1168))) and v30) then
							return v30;
						end
					end
				end
				if ((v99.GreaterPurge:IsAvailable() and v96 and v99.GreaterPurge:IsReady() and v35 and v83 and not v13:IsCasting() and not v13:IsChanneling() and v103.UnitHasMagicBuff(v16)) or ((2084 - (645 + 952)) > (3141 - (669 + 169)))) then
					if (v24(v99.GreaterPurge, not v16:IsSpellInRange(v99.GreaterPurge)) or ((15598 - 11095) == (7517 - 4055))) then
						return "greater_purge damage";
					end
				end
				v157 = 2 + 1;
			end
			if (((122 + 431) <= (2308 - (181 + 584))) and (v157 == (1395 - (665 + 730)))) then
				v30 = v127();
				if (((5807 - 3792) == (4109 - 2094)) and v30) then
					return v30;
				end
				v157 = 1351 - (540 + 810);
			end
			if ((v157 == (3 - 2)) or ((11659 - 7418) <= (1856 + 476))) then
				if (v85 or ((2567 - (166 + 37)) < (3038 - (22 + 1859)))) then
					if (v80 or ((2939 - (843 + 929)) > (1540 - (30 + 232)))) then
						v30 = v103.HandleAfflicted(v99.CleanseSpirit, v101.CleanseSpiritMouseover, 114 - 74);
						if (v30 or ((1922 - (55 + 722)) <= (2322 - 1240))) then
							return v30;
						end
					end
					if (v81 or ((4780 - (78 + 1597)) == (1073 + 3808))) then
						v30 = v103.HandleAfflicted(v99.TremorTotem, v99.TremorTotem, 28 + 2);
						if (v30 or ((1580 + 307) > (5427 - (305 + 244)))) then
							return v30;
						end
					end
					if (v82 or ((3792 + 295) > (4221 - (95 + 10)))) then
						local v234 = 0 + 0;
						while true do
							if (((3504 - 2398) <= (1731 - 465)) and (v234 == (762 - (592 + 170)))) then
								v30 = v103.HandleAfflicted(v99.PoisonCleansingTotem, v99.PoisonCleansingTotem, 104 - 74);
								if (((7923 - 4768) < (2168 + 2482)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
				end
				if (((1469 + 2305) >= (4440 - 2601)) and v86) then
					v30 = v103.HandleIncorporeal(v99.Hex, v101.HexMouseOver, 5 + 25, true);
					if (((5209 - 2398) == (3318 - (353 + 154))) and v30) then
						return v30;
					end
				end
				v157 = 2 - 0;
			end
		end
	end
	local function v134()
		local v158 = 0 - 0;
		while true do
			if (((1481 + 665) > (879 + 243)) and (v158 == (0 + 0))) then
				v36 = EpicSettings.Settings['useChainlightning'];
				v37 = EpicSettings.Settings['useEarthquake'];
				v38 = EpicSettings.Settings['useEarthshock'];
				v39 = EpicSettings.Settings['useElementalBlast'];
				v158 = 1 - 0;
			end
			if ((v158 == (7 - 3)) or ((130 - 74) == (3702 - (7 + 79)))) then
				v54 = EpicSettings.Settings['useLiquidMagmaTotem'];
				v53 = EpicSettings.Settings['useFireElemental'];
				v55 = EpicSettings.Settings['useStormElemental'];
				v58 = EpicSettings.Settings['ascendanceWithCD'];
				v158 = 3 + 2;
			end
			if ((v158 == (183 - (24 + 157))) or ((4831 - 2410) < (1326 - 704))) then
				v44 = EpicSettings.Settings['useLavaBurst'];
				v45 = EpicSettings.Settings['useLightningBolt'];
				v46 = EpicSettings.Settings['useNaturesSwiftness'];
				v47 = EpicSettings.Settings['usePrimordialWave'];
				v158 = 1 + 2;
			end
			if (((2717 - 1708) <= (1510 - (262 + 118))) and (v158 == (1088 - (1038 + 45)))) then
				v61 = EpicSettings.Settings['liquidMagmaTotemWithCD'];
				v59 = EpicSettings.Settings['fireElementalWithCD'];
				v60 = EpicSettings.Settings['stormElementalWithCD'];
				v64 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v158 = 12 - 6;
			end
			if (((2988 - (19 + 211)) < (3093 - (88 + 25))) and (v158 == (7 - 4))) then
				v48 = EpicSettings.Settings['useStormkeeper'];
				v49 = EpicSettings.Settings['useTotemicRecall'];
				v50 = EpicSettings.Settings['useWeaponEnchant'];
				v52 = EpicSettings.Settings['useAscendance'];
				v158 = 2 + 2;
			end
			if ((v158 == (1 + 0)) or ((1122 - (1007 + 29)) >= (977 + 2649))) then
				v40 = EpicSettings.Settings['useFlameShock'];
				v41 = EpicSettings.Settings['useFrostShock'];
				v42 = EpicSettings.Settings['useIceFury'];
				v43 = EpicSettings.Settings['useLavaBeam'];
				v158 = 4 - 2;
			end
			if (((11327 - 8932) == (534 + 1861)) and (v158 == (817 - (340 + 471)))) then
				v65 = EpicSettings.Settings['stormkeeperWithMiniCD'];
				break;
			end
		end
	end
	local function v135()
		local v159 = 0 - 0;
		while true do
			if (((4369 - (276 + 313)) > (6612 - 3903)) and (v159 == (5 + 0))) then
				v82 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((1 + 1) == v159) or ((23 + 214) >= (4245 - (495 + 1477)))) then
				v77 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
				v78 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
				v79 = EpicSettings.Settings['healingStreamTotemGroup'] or (403 - (342 + 61));
				v51 = EpicSettings.Settings['earthquakeSetting'] or "";
				v159 = 2 + 1;
			end
			if (((165 - (4 + 161)) == v159) or ((1250 + 790) <= (2206 - 1503))) then
				v67 = EpicSettings.Settings['useWindShear'];
				v68 = EpicSettings.Settings['useCapacitorTotem'];
				v69 = EpicSettings.Settings['useThunderstorm'];
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v159 = 2 - 1;
			end
			if (((3776 - (322 + 175)) <= (4530 - (173 + 390))) and (v159 == (1 + 2))) then
				v66 = EpicSettings.Settings['liquidMagmaTotemSetting'] or "";
				v73 = EpicSettings.Settings['autoShield'];
				v74 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v97 = EpicSettings.Settings['healOOC'];
				v159 = 318 - (203 + 111);
			end
			if (((1 + 3) == v159) or ((1402 + 586) == (2559 - 1682))) then
				v98 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
				v96 = EpicSettings.Settings['usePurgeTarget'];
				v80 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v81 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v159 = 711 - (57 + 649);
			end
			if (((4675 - (328 + 56)) > (612 + 1300)) and (v159 == (513 - (433 + 79)))) then
				v71 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useHealingStreamTotem'];
				v75 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v76 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
				v159 = 6 - 4;
			end
		end
	end
	local function v136()
		local v160 = 0 - 0;
		while true do
			if (((1461 + 542) < (2084 + 255)) and ((1038 - (562 + 474)) == v160)) then
				v62 = EpicSettings.Settings['trinketsWithCD'];
				v63 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v160 = 6 - 3;
			end
			if (((879 - 447) == (1337 - (76 + 829))) and (v160 == (1677 - (1506 + 167)))) then
				v86 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v160 == (5 - 2)) or ((1411 - (58 + 208)) >= (741 + 512))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v93 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v85 = EpicSettings.Settings['handleAfflicted'];
				v160 = 16 - 12;
			end
			if (((3755 - (258 + 79)) > (269 + 1849)) and (v160 == (0 - 0))) then
				v90 = EpicSettings.Settings['fightRemainsCheck'] or (1470 - (1219 + 251));
				v87 = EpicSettings.Settings['InterruptWithStun'];
				v88 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v89 = EpicSettings.Settings['InterruptThreshold'];
				v160 = 1672 - (1231 + 440);
			end
			if (((3124 - (34 + 24)) <= (2256 + 1634)) and (v160 == (1 - 0))) then
				v84 = EpicSettings.Settings['DispelDebuffs'];
				v83 = EpicSettings.Settings['DispelBuffs'];
				v56 = EpicSettings.Settings['useTrinkets'];
				v57 = EpicSettings.Settings['useRacials'];
				v160 = 1 + 1;
			end
		end
	end
	local function v137()
		local v161 = 0 - 0;
		while true do
			if ((v161 == (3 - 2)) or ((7881 - 4883) >= (10992 - 7711))) then
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v34 = EpicSettings.Toggles['minicds'];
				v161 = 4 - 2;
			end
			if ((v161 == (1592 - (877 + 712))) or ((2784 + 1865) <= (3386 - (242 + 512)))) then
				if (v13:AffectingCombat() or v84 or ((8066 - 4206) > (5499 - (92 + 535)))) then
					local v230 = 0 + 0;
					local v231;
					while true do
						if ((v230 == (0 - 0)) or ((251 + 3747) == (8352 - 6054))) then
							v231 = v84 and v99.CleanseSpirit:IsReady() and v35;
							v30 = v103.FocusUnit(v231, v101, 20 + 0, nil, 18 + 7);
							v230 = 1 + 0;
						end
						if ((v230 == (1 - 0)) or ((12 - 4) >= (4524 - (1476 + 309)))) then
							if (((3874 - (299 + 985)) == (616 + 1974)) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if (v103.TargetIsValid() or v13:AffectingCombat() or ((268 - 186) >= (1963 - (86 + 7)))) then
					local v232 = 0 - 0;
					while true do
						if (((250 + 2374) < (5437 - (672 + 208))) and (v232 == (0 + 0))) then
							v106 = v9.BossFightRemains();
							v107 = v106;
							v232 = 133 - (14 + 118);
						end
						if ((v232 == (446 - (339 + 106))) or ((2491 + 640) > (1782 + 1760))) then
							if (((3972 - (440 + 955)) >= (1555 + 23)) and (v107 == (19960 - 8849))) then
								v107 = v9.FightRemains(v110, false);
							end
							break;
						end
					end
				end
				if (((1362 + 2741) <= (11380 - 6809)) and not v13:IsChanneling() and not v13:IsChanneling()) then
					if (v17 or ((1024 + 471) == (5140 - (260 + 93)))) then
						if (v84 or ((291 + 19) > (10142 - 5708))) then
							local v235 = 0 - 0;
							while true do
								if (((4142 - (1181 + 793)) <= (1110 + 3250)) and (v235 == (307 - (105 + 202)))) then
									v30 = v125();
									if (((797 + 197) == (1804 - (352 + 458))) and v30) then
										return v30;
									end
									break;
								end
							end
						end
					end
					if (((6672 - 5017) > (1024 - 623)) and v85) then
						if (((2966 + 97) <= (10014 - 6588)) and v80) then
							v30 = v103.HandleAfflicted(v99.CleanseSpirit, v101.CleanseSpiritMouseover, 989 - (438 + 511));
							if (((2842 - (1262 + 121)) > (1832 - (728 + 340))) and v30) then
								return v30;
							end
						end
						if (v81 or ((2431 - (816 + 974)) > (13276 - 8942))) then
							v30 = v103.HandleAfflicted(v99.TremorTotem, v99.TremorTotem, 107 - 77);
							if (((3738 - (163 + 176)) >= (6433 - 4173)) and v30) then
								return v30;
							end
						end
						if (v82 or ((1806 - 1413) >= (1282 + 2960))) then
							v30 = v103.HandleAfflicted(v99.PoisonCleansingTotem, v99.PoisonCleansingTotem, 1840 - (1564 + 246));
							if (((1334 - (124 + 221)) < (3320 + 1539)) and v30) then
								return v30;
							end
						end
					end
					if (v13:AffectingCombat() or ((5246 - (115 + 336)) < (2089 - 1140))) then
						v30 = v133();
						if (((792 + 3050) == (3888 - (45 + 1))) and v30) then
							return v30;
						end
					else
						v30 = v132();
						if (((95 + 1652) <= (5591 - (1282 + 708))) and v30) then
							return v30;
						end
					end
				end
				break;
			end
			if ((v161 == (1214 - (583 + 629))) or ((134 + 670) > (11276 - 6917))) then
				if (((2448 + 2222) >= (4793 - (943 + 227))) and v13:IsDeadOrGhost()) then
					return v30;
				end
				v110 = v13:GetEnemiesInRange(18 + 22);
				v111 = v16:GetEnemiesInSplashRange(1636 - (1539 + 92));
				if (((4011 - (706 + 1240)) < (2802 - (81 + 177))) and v32) then
					local v233 = 0 - 0;
					while true do
						if (((1568 - (212 + 45)) <= (11235 - 7876)) and ((1946 - (708 + 1238)) == v233)) then
							v112 = #v110;
							v113 = v27(v16:GetEnemiesInSplashRangeCount(1 + 4), v112);
							break;
						end
					end
				else
					v112 = 1 + 0;
					v113 = 1668 - (586 + 1081);
				end
				v161 = 514 - (348 + 163);
			end
			if (((2441 + 276) <= (3436 - (215 + 65))) and ((0 - 0) == v161)) then
				v135();
				v134();
				v136();
				v31 = EpicSettings.Toggles['ooc'];
				v161 = 1860 - (1541 + 318);
			end
		end
	end
	local function v138()
		v99.FlameShockDebuff:RegisterAuraTracking();
		v105();
		v21.Print("Elemental Shaman by Epic. Supported by xKaneto.");
	end
	v21.SetAPL(233 + 29, v137, v138);
end;
return v0["Epix_Shaman_Elemental.lua"]();

