local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1274 - (215 + 1059);
	local v6;
	while true do
		if (((1381 - (171 + 991)) <= (10743 - 8136)) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if (((9180 - 5501) < (3609 + 900)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((3181 - 2078) <= (2869 - 1089)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 3 - 2;
		end
	end
end
v0["Epix_Druid_Balance.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.MouseOver;
	local v15 = v12.Pet;
	local v16 = v12.Target;
	local v17 = v10.Spell;
	local v18 = v10.MultiSpell;
	local v19 = v10.Item;
	local v20 = v10.Macro;
	local v21 = v10.Bind;
	local v22 = v10.AoEON;
	local v23 = v10.CDsON;
	local v24 = v10.Cast;
	local v25 = v10.Press;
	local v26 = v10.Commons.Everyone.num;
	local v27 = v10.Commons.Everyone.bool;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32;
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
	local function v47()
		v32 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or (1248 - (111 + 1137));
		v36 = EpicSettings.Settings['HealingPotionHP'] or (158 - (91 + 67));
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v39 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (523 - (423 + 100));
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
		v42 = EpicSettings.Settings['OutOfCombatHealing'];
		v43 = EpicSettings.Settings['MarkOfTheWild'];
		v44 = EpicSettings.Settings['MoonkinFormOOC'];
		v45 = EpicSettings.Settings['BarkskinHP'] or (0 - 0);
		v46 = EpicSettings.Settings['NaturesVigilHP'] or (0 + 0);
	end
	local v48 = v10.Commons.Everyone;
	local v49 = v17.Druid.Balance;
	local v50 = v19.Druid.Balance;
	local v51 = {v50.MirrorofFracturedTomorrows:ID()};
	local v52 = v20.Druid.Balance;
	local v53 = v13:GetEquipment();
	local v54 = (v53[56 - 43] and v19(v53[28 - 15])) or v19(0 - 0);
	local v55 = (v53[725 - (530 + 181)] and v19(v53[895 - (614 + 267)])) or v19(32 - (19 + 13));
	local v56 = false;
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
	local v74 = v10.Druid;
	local v75 = 18084 - 6973;
	local v76 = 25892 - 14781;
	local v77 = (v49.IncarnationTalent:IsAvailable() and v49.Incarnation) or v49.CelestialAlignment;
	local v78 = false;
	local v79 = false;
	local v80 = false;
	local v81 = false;
	local v82 = false;
	local v83 = false;
	local v84 = false;
	v10:RegisterForEvent(function()
		local v113 = 0 - 0;
		while true do
			if (((698 + 1986) > (959 - 413)) and (v113 == (1 - 0))) then
				v55 = (v53[1826 - (1293 + 519)] and v19(v53[28 - 14])) or v19(0 - 0);
				v56 = false;
				break;
			end
			if (((2801 - 1336) <= (18546 - 14245)) and (v113 == (0 - 0))) then
				v53 = v13:GetEquipment();
				v54 = (v53[7 + 6] and v19(v53[3 + 10])) or v19(0 - 0);
				v113 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		local v114 = 0 + 0;
		while true do
			if (((1065 + 639) > (2521 - (709 + 387))) and (v114 == (1859 - (673 + 1185)))) then
				v76 = 32223 - 21112;
				break;
			end
			if ((v114 == (0 - 0)) or ((1129 - 442) == (3029 + 1205))) then
				v56 = false;
				v75 = 8303 + 2808;
				v114 = 1 - 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v115 = 0 + 0;
		while true do
			if ((v115 == (0 - 0)) or ((6536 - 3206) < (3309 - (446 + 1434)))) then
				v77 = (v49.IncarnationTalent:IsAvailable() and v49.Incarnation) or v49.CelestialAlignment;
				v56 = false;
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v85, v86;
	local function v87(v116)
		local v117 = 1283 - (1040 + 243);
		local v118;
		while true do
			if (((3423 - 2276) >= (2182 - (559 + 1288))) and (v117 == (1931 - (609 + 1322)))) then
				v118 = 454 - (13 + 441);
				if (((12835 - 9400) > (5492 - 3395)) and (v116 == v49.Wrath)) then
					local v166 = 0 - 0;
					while true do
						if ((v166 == (1 + 0)) or ((13691 - 9921) >= (1436 + 2605))) then
							if ((v49.SouloftheForest:IsAvailable() and v13:BuffUp(v49.EclipseSolar)) or ((1662 + 2129) <= (4780 - 3169))) then
								v118 = v118 * (1.6 + 0);
							end
							break;
						end
						if ((v166 == (0 - 0)) or ((3027 + 1551) <= (1117 + 891))) then
							v118 = 6 + 2;
							if (((945 + 180) <= (2032 + 44)) and v49.WildSurges:IsAvailable()) then
								v118 = v118 + (435 - (153 + 280));
							end
							v166 = 2 - 1;
						end
					end
				elseif ((v116 == v49.Starfire) or ((668 + 75) >= (1737 + 2662))) then
					v118 = 6 + 4;
					if (((1049 + 106) < (1213 + 460)) and v49.WildSurges:IsAvailable()) then
						v118 = v118 + (2 - 0);
					end
					if (v13:BuffUp(v49.WarriorofEluneBuff) or ((1437 + 887) <= (1245 - (89 + 578)))) then
						v118 = v118 * (1.4 + 0);
					end
					if (((7831 - 4064) == (4816 - (572 + 477))) and v49.SouloftheForest:IsAvailable() and v13:BuffUp(v49.EclipseLunar)) then
						local v176 = 0 + 0;
						local v177;
						while true do
							if (((2454 + 1635) == (489 + 3600)) and (v176 == (87 - (84 + 2)))) then
								v118 = v118 * v177;
								break;
							end
							if (((7346 - 2888) >= (1206 + 468)) and (v176 == (842 - (497 + 345)))) then
								v177 = 1 + 0 + ((0.2 + 0) * v86);
								if (((2305 - (605 + 728)) <= (1012 + 406)) and (v177 > (1.6 - 0))) then
									v177 = 1.6 + 0;
								end
								v176 = 3 - 2;
							end
						end
					end
				end
				v117 = 1 + 0;
			end
			if ((v117 == (2 - 1)) or ((3729 + 1209) < (5251 - (457 + 32)))) then
				return v118;
			end
		end
	end
	local function v88(v119)
		local v120 = 0 + 0;
		local v121;
		while true do
			if ((v120 == (1402 - (832 + 570))) or ((2359 + 145) > (1112 + 3152))) then
				v121 = v119:DebuffRemains(v49.SunfireDebuff);
				return v119:DebuffRefreshable(v49.SunfireDebuff) and (v121 < (6 - 4)) and ((v119:TimeToDie() - v121) > (3 + 3));
			end
		end
	end
	local function v89(v122)
		return v122:DebuffRefreshable(v49.SunfireDebuff) and (v13:AstralPowerDeficit() > (v64 + v49.Sunfire:EnergizeAmount()));
	end
	local function v90(v123)
		local v124 = 796 - (588 + 208);
		local v125;
		while true do
			if (((5802 - 3649) == (3953 - (884 + 916))) and ((0 - 0) == v124)) then
				v125 = v123:DebuffRemains(v49.MoonfireDebuff);
				return v123:DebuffRefreshable(v49.MoonfireDebuff) and (v125 < (2 + 0)) and ((v123:TimeToDie() - v125) > (659 - (232 + 421)));
			end
		end
	end
	local function v91(v126)
		return v126:DebuffRefreshable(v49.MoonfireDebuff) and (v13:AstralPowerDeficit() > (v64 + v49.Moonfire:EnergizeAmount()));
	end
	local function v92(v127)
		local v128 = v127:DebuffRemains(v49.StellarFlareDebuff);
		return v127:DebuffRefreshable(v49.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v64 + v49.StellarFlare:EnergizeAmount())) and (v128 < (1891 - (1569 + 320))) and ((v127:TimeToDie() - v128) > (2 + 6));
	end
	local function v93(v129)
		return v129:DebuffRefreshable(v49.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v64 + v49.StellarFlare:EnergizeAmount()));
	end
	local function v94(v130)
		return v130:DebuffRefreshable(v49.SunfireDebuff) and ((v130:TimeToDie() - v16:DebuffRemains(v49.SunfireDebuff)) > ((2 + 4) - (v86 / (6 - 4)))) and (v13:AstralPowerDeficit() > (v64 + v49.Sunfire:EnergizeAmount()));
	end
	local function v95(v131)
		return v131:DebuffRefreshable(v49.MoonfireDebuff) and ((v131:TimeToDie() - v16:DebuffRemains(v49.MoonfireDebuff)) > (611 - (316 + 289))) and (v13:AstralPowerDeficit() > (v64 + v49.Moonfire:EnergizeAmount()));
	end
	local function v96(v132)
		return v132:DebuffRefreshable(v49.StellarFlareDebuff) and (((v132:TimeToDie() - v132:DebuffRemains(v49.StellarFlareDebuff)) - v132:GetEnemiesInSplashRangeCount(20 - 12)) > (1 + 7 + v86));
	end
	local function v97(v133)
		return v133:DebuffRemains(v49.MoonfireDebuff) > ((v133:DebuffRemains(v49.SunfireDebuff) * (1475 - (666 + 787))) / (443 - (360 + 65)));
	end
	local function v98()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (255 - (79 + 175))) or ((799 - 292) >= (2022 + 569))) then
				v80 = v13:BuffUp(v49.EclipseLunar) and v13:BuffDown(v49.EclipseSolar);
				v81 = v13:BuffUp(v49.EclipseSolar) and v13:BuffDown(v49.EclipseLunar);
				v134 = 5 - 3;
			end
			if (((8629 - 4148) == (5380 - (503 + 396))) and (v134 == (184 - (92 + 89)))) then
				v84 = not v78 and (v49.Wrath:Count() > (0 - 0)) and (v49.Starfire:Count() > (0 + 0));
				break;
			end
			if (((0 + 0) == v134) or ((9116 - 6788) < (95 + 598))) then
				v78 = v13:BuffUp(v49.EclipseSolar) or v13:BuffUp(v49.EclipseLunar);
				v79 = v13:BuffUp(v49.EclipseSolar) and v13:BuffUp(v49.EclipseLunar);
				v134 = 2 - 1;
			end
			if (((3777 + 551) == (2068 + 2260)) and (v134 == (5 - 3))) then
				v82 = (not v78 and (((v49.Starfire:Count() == (0 + 0)) and (v49.Wrath:Count() > (0 - 0))) or v13:IsCasting(v49.Wrath))) or v81;
				v83 = (not v78 and (((v49.Wrath:Count() == (1244 - (485 + 759))) and (v49.Starfire:Count() > (0 - 0))) or v13:IsCasting(v49.Starfire))) or v80;
				v134 = 1192 - (442 + 747);
			end
		end
	end
	local function v99()
		local v135 = 1135 - (832 + 303);
		while true do
			if (((2534 - (88 + 858)) >= (406 + 926)) and ((1 + 0) == v135)) then
				v61 = v61 + v26(v54:IsReady() or (v54:CooldownRemains() > (0 + 0)));
				v61 = v61 + (v26(v55:IsReady() or (v55:CooldownRemains() > (789 - (766 + 23)))) * (9 - 7));
				v135 = 2 - 0;
			end
			if ((v135 == (0 - 0)) or ((14166 - 9992) > (5321 - (1036 + 37)))) then
				v57 = (not v49.CelestialAlignment:IsAvailable() and not v49.IncarnationTalent:IsAvailable()) or not v23();
				v61 = 0 + 0;
				v135 = 1 - 0;
			end
			if (((2 + 0) == v135) or ((6066 - (641 + 839)) <= (995 - (910 + 3)))) then
				v56 = true;
				break;
			end
		end
	end
	local function v100()
		local v136 = 0 - 0;
		while true do
			if (((5547 - (1466 + 218)) == (1776 + 2087)) and (v136 == (1149 - (556 + 592)))) then
				if ((v49.Wrath:IsCastable() and not v13:IsCasting(v49.Wrath)) or ((101 + 181) <= (850 - (329 + 479)))) then
					if (((5463 - (174 + 680)) >= (2632 - 1866)) and v25(v49.Wrath, not v16:IsSpellInRange(v49.Wrath), v73)) then
						return "wrath";
					end
				end
				if ((v49.Wrath:IsCastable() and ((v13:IsCasting(v49.Wrath) and (v49.Wrath:Count() == (3 - 1))) or (v13:PrevGCD(1 + 0, v49.Wrath) and (v49.Wrath:Count() == (740 - (396 + 343)))))) or ((102 + 1050) == (3965 - (29 + 1448)))) then
					if (((4811 - (135 + 1254)) > (12620 - 9270)) and v25(v49.Wrath, not v16:IsSpellInRange(v49.Wrath), v73)) then
						return "wrath";
					end
				end
				v136 = 9 - 7;
			end
			if (((585 + 292) > (1903 - (389 + 1138))) and (v136 == (574 - (102 + 472)))) then
				if ((v49.MarkOfTheWild:IsCastable() and v48.GroupBuffMissing(v49.MarkOfTheWild)) or ((2943 + 175) <= (1027 + 824))) then
					if (v24(v49.MarkOfTheWild, v43) or ((154 + 11) >= (5037 - (320 + 1225)))) then
						return "mark_of_the_wild precombat";
					end
				end
				if (((7029 - 3080) < (2972 + 1884)) and v49.MoonkinForm:IsCastable()) then
					if (v25(v49.MoonkinForm) or ((5740 - (157 + 1307)) < (4875 - (821 + 1038)))) then
						return "moonkin_form";
					end
				end
				v136 = 2 - 1;
			end
			if (((513 + 4177) > (7326 - 3201)) and (v136 == (1 + 1))) then
				if (v49.StellarFlare:IsCastable() or ((123 - 73) >= (1922 - (834 + 192)))) then
					if (v24(v49.StellarFlare, nil, nil, not v16:IsSpellInRange(v49.StellarFlare)) or ((109 + 1605) >= (760 + 2198))) then
						return "stellar_flare precombat 6";
					end
				end
				if ((v49.Starfire:IsCastable() and not v49.StellarFlare:IsAvailable()) or ((33 + 1458) < (997 - 353))) then
					if (((1008 - (300 + 4)) < (264 + 723)) and v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire))) then
						return "starfire precombat 8";
					end
				end
				break;
			end
		end
	end
	local function v101()
		local v137 = 0 - 0;
		while true do
			if (((4080 - (112 + 250)) > (760 + 1146)) and (v137 == (2 - 1))) then
				if (v49.Sunfire:IsCastable() or ((549 + 409) > (1880 + 1755))) then
					if (((2619 + 882) <= (2228 + 2264)) and v48.CastCycle(v49.Sunfire, v85, v97, not v16:IsSpellInRange(v49.Sunfire))) then
						return "sunfire fallthru 6";
					end
				end
				if (v49.Moonfire:IsCastable() or ((2557 + 885) < (3962 - (1001 + 413)))) then
					if (((6411 - 3536) >= (2346 - (244 + 638))) and v25(v49.Moonfire, not v16:IsSpellInRange(v49.Moonfire))) then
						return "moonfire fallthru 8";
					end
				end
				break;
			end
			if (((693 - (627 + 66)) == v137) or ((14293 - 9496) >= (5495 - (512 + 90)))) then
				if ((v49.Starfall:IsReady() and v62) or ((2457 - (1665 + 241)) > (2785 - (373 + 344)))) then
					if (((954 + 1160) > (250 + 694)) and v25(v49.Starfall, not v16:IsInRange(118 - 73))) then
						return "starfall fallthru 2";
					end
				end
				if (v49.Starsurge:IsReady() or ((3827 - 1565) >= (4195 - (35 + 1064)))) then
					if (v25(v49.Starsurge, not v16:IsSpellInRange(v49.Starsurge)) or ((1641 + 614) >= (7567 - 4030))) then
						return "starsurge fallthru 4";
					end
				end
				v137 = 1 + 0;
			end
		end
	end
	local function v102()
		local v138 = 1236 - (298 + 938);
		local v139;
		local v140;
		local v141;
		while true do
			if ((v138 == (1262 - (233 + 1026))) or ((5503 - (636 + 1030)) < (668 + 638))) then
				if (((2882 + 68) == (877 + 2073)) and v49.AstralCommunion:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.AstralCommunion:EnergizeAmount()))) then
					if (v24(v49.AstralCommunion) or ((320 + 4403) < (3519 - (55 + 166)))) then
						return "astral_communion st 32";
					end
				end
				if (((221 + 915) >= (16 + 138)) and v49.ForceOfNature:IsCastable() and v23() and (v13:AstralPowerDeficit() > (v64 + v49.ForceOfNature:EnergizeAmount()))) then
					if (v24(v49.ForceOfNature, nil, not v16:IsInRange(171 - 126)) or ((568 - (36 + 261)) > (8303 - 3555))) then
						return "force_of_nature st 34";
					end
				end
				if (((6108 - (34 + 1334)) >= (1212 + 1940)) and v49.FuryOfElune:IsCastable() and (((v16:TimeToDie() > (2 + 0)) and ((v72 > (1286 - (1035 + 248))) or ((v77:CooldownRemains() > (51 - (20 + 1))) and (v70 <= (146 + 134))) or ((v70 >= (879 - (134 + 185))) and (v13:AstralPowerP() > (1183 - (549 + 584)))))) or (v76 < (695 - (314 + 371))))) then
					if (v24(v49.FuryOfElune, nil, not v16:IsSpellInRange(v49.FuryOfElune)) or ((8850 - 6272) >= (4358 - (478 + 490)))) then
						return "fury_of_elune st 36";
					end
				end
				if (((22 + 19) <= (2833 - (786 + 386))) and v49.Starfall:IsReady() and (v13:BuffUp(v49.StarweaversWarp))) then
					if (((1946 - 1345) < (4939 - (1055 + 324))) and v24(v49.Starfall, nil, not v16:IsInRange(1385 - (1093 + 247)))) then
						return "starfall st 38";
					end
				end
				v139 = (v49.Starlord:IsAvailable() and (v13:BuffStack(v49.StarlordBuff) < (3 + 0))) or (((v13:BuffStack(v49.BOATArcaneBuff) + v13:BuffStack(v49.BOATNatureBuff)) > (1 + 1)) and (v13:BuffRemains(v49.StarlordBuff) > (15 - 11)));
				if (((797 - 562) < (1954 - 1267)) and v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < (4 - 2)) and v139) then
					if (((1619 + 2930) > (4441 - 3288)) and v10.CastAnnotated(v52.CancelStarlord, false, "CANCEL")) then
						return "cancel_buff starlord st 39";
					end
				end
				v138 = 13 - 9;
			end
			if ((v138 == (4 + 0)) or ((11952 - 7278) < (5360 - (364 + 324)))) then
				if (((10055 - 6387) < (10944 - 6383)) and v49.Starsurge:IsReady() and v139) then
					if (v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge)) or ((151 + 304) == (15084 - 11479))) then
						return "starsurge st 40";
					end
				end
				if (v49.Sunfire:IsCastable() or ((4264 - 1601) == (10058 - 6746))) then
					if (((5545 - (1249 + 19)) <= (4040 + 435)) and v48.CastCycle(v49.Sunfire, v85, v89, not v16:IsSpellInRange(v49.Sunfire))) then
						return "sunfire st 42";
					end
				end
				if (v49.Moonfire:IsCastable() or ((3386 - 2516) == (2275 - (686 + 400)))) then
					if (((1219 + 334) <= (3362 - (73 + 156))) and v48.CastCycle(v49.Moonfire, v85, v91, not v16:IsSpellInRange(v49.Moonfire))) then
						return "moonfire st 44";
					end
				end
				if (v49.StellarFlare:IsCastable() or ((11 + 2226) >= (4322 - (721 + 90)))) then
					if (v48.CastCycle(v49.StellarFlare, v85, v93, not v16:IsSpellInRange(v49.StellarFlare)) or ((15 + 1309) > (9805 - 6785))) then
						return "stellar_flare st 46";
					end
				end
				if ((v49.NewMoon:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.NewMoon:EnergizeAmount())) and (v71 or ((v49.NewMoon:ChargesFractional() > (472.5 - (224 + 246))) and (v70 <= (842 - 322)) and (v77:CooldownRemains() > (18 - 8))) or (v76 < (2 + 8)))) or ((72 + 2920) == (1382 + 499))) then
					if (((6174 - 3068) > (5078 - 3552)) and v24(v49.NewMoon, nil, nil, not v16:IsSpellInRange(v49.NewMoon))) then
						return "new_moon st 48";
					end
				end
				if (((3536 - (203 + 310)) < (5863 - (1238 + 755))) and v49.HalfMoon:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.HalfMoon:EnergizeAmount())) and ((v13:BuffRemains(v49.EclipseLunar) > v49.HalfMoon:ExecuteTime()) or (v13:BuffRemains(v49.EclipseSolar) > v49.HalfMoon:ExecuteTime())) and (v71 or ((v49.HalfMoon:ChargesFractional() > (1.5 + 1)) and (v70 <= (2054 - (709 + 825))) and (v77:CooldownRemains() > (18 - 8))) or (v76 < (14 - 4)))) then
					if (((1007 - (196 + 668)) > (291 - 217)) and v24(v49.HalfMoon, nil, nil, not v16:IsSpellInRange(v49.HalfMoon))) then
						return "half_moon st 50";
					end
				end
				v138 = 10 - 5;
			end
			if (((851 - (171 + 662)) < (2205 - (4 + 89))) and (v138 == (17 - 12))) then
				if (((400 + 697) <= (7150 - 5522)) and v49.FullMoon:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.FullMoon:EnergizeAmount())) and ((v13:BuffRemains(v49.EclipseLunar) > v49.FullMoon:ExecuteTime()) or (v13:BuffRemains(v49.EclipseSolar) > v49.FullMoon:ExecuteTime())) and (v71 or ((v49.HalfMoon:ChargesFractional() > (1.5 + 1)) and (v70 <= (2006 - (35 + 1451))) and (v77:CooldownRemains() > (1463 - (28 + 1425)))) or (v76 < (2003 - (941 + 1052))))) then
					if (((4440 + 190) == (6144 - (822 + 692))) and v24(v49.FullMoon, nil, nil, not v16:IsSpellInRange(v49.FullMoon))) then
						return "full_moon st 52";
					end
				end
				v140 = v13:BuffUp(v49.StarweaversWeft) or (v13:AstralPowerDeficit() < (v64 + v87(v49.Wrath) + ((v87(v49.Starfire) + v64) * (v26(v13:BuffRemains(v49.EclipseSolar) < (v13:GCD() * (3 - 0))))))) or (v49.AstralCommunion:IsAvailable() and (v49.AstralCommunion:CooldownRemains() < (2 + 1))) or (v76 < (302 - (45 + 252)));
				if (((3503 + 37) > (924 + 1759)) and v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < (4 - 2)) and v140) then
					if (((5227 - (114 + 319)) >= (4701 - 1426)) and v25(v52.CancelStarlord, false, "CANCEL")) then
						return "cancel_buff starlord st 53";
					end
				end
				if (((1900 - 416) == (947 + 537)) and v49.Starsurge:IsReady() and v140) then
					if (((2132 - 700) < (7448 - 3893)) and v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge))) then
						return "starsurge st 54";
					end
				end
				if ((v49.Wrath:IsCastable() and not v13:IsMoving()) or ((3028 - (556 + 1407)) > (4784 - (741 + 465)))) then
					if (v24(v49.Wrath, nil, nil, not v16:IsSpellInRange(v49.Wrath)) or ((5260 - (170 + 295)) < (742 + 665))) then
						return "wrath st 60";
					end
				end
				v141 = v101();
				v138 = 6 + 0;
			end
			if (((4561 - 2708) < (3990 + 823)) and (v138 == (2 + 0))) then
				if ((v49.WarriorofElune:IsCastable() and v60 and (v67 or (v13:BuffRemains(v49.EclipseSolar) < (4 + 3)))) or ((4051 - (957 + 273)) < (651 + 1780))) then
					if (v24(v49.WarriorofElune) or ((1151 + 1723) < (8310 - 6129))) then
						return "warrior_of_elune st 20";
					end
				end
				if ((v49.Starfire:IsCastable() and v67 and (v60 or v13:BuffUp(v49.EclipseSolar))) or ((7085 - 4396) <= (1047 - 704))) then
					if (v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire)) or ((9254 - 7385) == (3789 - (389 + 1391)))) then
						return "starfire st 24";
					end
				end
				if ((v49.Wrath:IsCastable() and v67) or ((2225 + 1321) < (242 + 2080))) then
					if (v24(v49.Wrath, nil, nil, not v16:IsSpellInRange(v49.Wrath)) or ((4739 - 2657) == (5724 - (783 + 168)))) then
						return "wrath st 26";
					end
				end
				v69 = (v72 > (13 - 9)) or (((v77:CooldownRemains() > (30 + 0)) or v57) and ((v13:BuffRemains(v49.EclipseLunar) > (315 - (309 + 2))) or (v13:BuffRemains(v49.EclipseSolar) > (12 - 8))));
				if (((4456 - (1090 + 122)) > (343 + 712)) and v49.Starsurge:IsReady() and v49.ConvokeTheSpirits:IsAvailable() and v49.ConvokeTheSpirits:IsCastable() and v69) then
					if (v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge)) or ((11126 - 7813) <= (1217 + 561))) then
						return "starsurge st 28";
					end
				end
				if ((v49.ConvokeTheSpirits:IsCastable() and v23() and v69) or ((2539 - (628 + 490)) >= (378 + 1726))) then
					if (((4485 - 2673) <= (14847 - 11598)) and v24(v49.ConvokeTheSpirits, nil, not v16:IsInRange(814 - (431 + 343)))) then
						return "convoke_the_spirits st 30";
					end
				end
				v138 = 5 - 2;
			end
			if (((4695 - 3072) <= (1547 + 410)) and (v138 == (1 + 0))) then
				if (((6107 - (556 + 1139)) == (4427 - (6 + 9))) and v49.Starsurge:IsReady() and (v70 >= (103 + 457)) and v13:BuffUp(v49.StarweaversWeft)) then
					if (((897 + 853) >= (1011 - (28 + 141))) and v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge))) then
						return "starsurge st 13";
					end
				end
				if (((1694 + 2678) > (2283 - 433)) and v49.Starfire:IsReady() and v13:BuffUp(v49.DreamstateBuff) and v65 and v80) then
					if (((165 + 67) < (2138 - (486 + 831))) and v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire))) then
						return "starfire st 14";
					end
				end
				if (((1347 - 829) < (3175 - 2273)) and v49.Wrath:IsReady() and v13:BuffUp(v49.DreamstateBuff) and v65 and v13:BuffUp(v49.EclipseSolar)) then
					if (((566 + 2428) > (2712 - 1854)) and v24(v49.Wrath, nil, nil, not v16:IsSpellInRange(v49.Wrath))) then
						return "wrath st 15";
					end
				end
				if (v30 or ((5018 - (668 + 595)) <= (824 + 91))) then
					local v167 = 0 + 0;
					while true do
						if (((10761 - 6815) > (4033 - (23 + 267))) and (v167 == (1944 - (1129 + 815)))) then
							if ((v49.CelestialAlignment:IsCastable() and v65) or ((1722 - (371 + 16)) >= (5056 - (1326 + 424)))) then
								if (((9174 - 4330) > (8232 - 5979)) and v25(v49.CelestialAlignment)) then
									return "celestial_alignment st 16";
								end
							end
							if (((570 - (88 + 30)) == (1223 - (720 + 51))) and v49.Incarnation:IsCastable() and v65) then
								if (v25(v49.Incarnation) or ((10136 - 5579) < (3863 - (421 + 1355)))) then
									return "incarnation st 18";
								end
							end
							break;
						end
					end
				end
				v60 = ((v70 < (857 - 337)) and (v77:CooldownRemains() > (3 + 2)) and (v86 < (1086 - (286 + 797)))) or v13:HasTier(113 - 82, 2 - 0);
				v67 = v84 or (v60 and v13:BuffUp(v49.EclipseSolar) and (v13:BuffRemains(v49.EclipseSolar) < v49.Starfire:CastTime())) or (not v60 and v13:BuffUp(v49.EclipseLunar) and (v13:BuffRemains(v49.EclipseLunar) < v49.Wrath:CastTime()));
				v138 = 441 - (397 + 42);
			end
			if (((1210 + 2664) == (4674 - (24 + 776))) and (v138 == (8 - 2))) then
				if (v141 or ((2723 - (222 + 563)) > (10873 - 5938))) then
					return v141;
				end
				if (v10.CastAnnotated(v49.Pool, false, "MOVING") or ((3064 + 1191) < (3613 - (23 + 167)))) then
					return "Pool ST due to movement and no fallthru";
				end
				break;
			end
			if (((3252 - (690 + 1108)) <= (899 + 1592)) and (v138 == (0 + 0))) then
				if (v49.Sunfire:IsCastable() or ((5005 - (40 + 808)) <= (462 + 2341))) then
					if (((18557 - 13704) >= (2851 + 131)) and v48.CastCycle(v49.Sunfire, v85, v88, not v16:IsSpellInRange(v49.Sunfire))) then
						return "sunfire st 2";
					end
				end
				v65 = v30 and (v77:CooldownRemains() < (3 + 2)) and not v71 and (((v16:TimeToDie() > (9 + 6)) and (v70 < (1051 - (47 + 524)))) or (v76 < (17 + 8 + ((27 - 17) * v26(v49.Incarnation:IsAvailable())))));
				if (((6181 - 2047) > (7655 - 4298)) and v49.Moonfire:IsCastable()) then
					if (v48.CastCycle(v49.Moonfire, v85, v90, not v16:IsSpellInRange(v49.Moonfire)) or ((5143 - (1165 + 561)) < (76 + 2458))) then
						return "moonfire st 6";
					end
				end
				if (v49.StellarFlare:IsCastable() or ((8430 - 5708) <= (63 + 101))) then
					if (v48.CastCycle(v49.StellarFlare, v85, v92, not v16:IsSpellInRange(v49.StellarFlare)) or ((2887 - (341 + 138)) < (570 + 1539))) then
						return "stellar_flare st 10";
					end
				end
				if ((v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < (3 - 1)) and (((v70 >= (876 - (89 + 237))) and not v71 and v13:BuffUp(v49.StarweaversWarp)) or ((v70 >= (1801 - 1241)) and v13:BuffUp(v49.StarweaversWeft)))) or ((69 - 36) == (2336 - (581 + 300)))) then
					if (v10.CastAnnotated(v52.CancelStarlord, false, "CANCEL") or ((1663 - (855 + 365)) >= (9536 - 5521))) then
						return "cancel_buff starlord st 11";
					end
				end
				if (((1105 + 2277) > (1401 - (1030 + 205))) and v49.Starfall:IsReady() and (v70 >= (517 + 33)) and not v71 and v13:BuffUp(v49.StarweaversWarp)) then
					if (v24(v49.Starfall, nil, not v16:IsInRange(42 + 3)) or ((566 - (156 + 130)) == (6950 - 3891))) then
						return "starfall st 12";
					end
				end
				v138 = 1 - 0;
			end
		end
	end
	local function v103()
		local v142 = v13:IsInParty() and not v13:IsInRaid();
		if (((3852 - 1971) > (341 + 952)) and v49.Moonfire:IsCastable() and v142) then
			if (((1375 + 982) == (2426 - (10 + 59))) and v48.CastCycle(v49.Moonfire, v85, v95, not v16:IsSpellInRange(v49.Moonfire))) then
				return "moonfire aoe 2";
			end
		end
		v66 = v23() and (v77:CooldownRemains() < (2 + 3)) and not v71 and (((v16:TimeToDie() > (49 - 39)) and (v70 < (1663 - (671 + 492)))) or (v76 < (20 + 5 + ((1225 - (369 + 846)) * v26(v49.Incarnation:IsAvailable())))));
		if (((33 + 90) == (105 + 18)) and v49.Sunfire:IsCastable()) then
			if (v48.CastCycle(v49.Sunfire, v85, v94, not v16:IsSpellInRange(v49.Sunfire)) or ((3001 - (1036 + 909)) >= (2697 + 695))) then
				return "sunfire aoe 4";
			end
		end
		if ((v49.Moonfire:IsCastable() and not v142) or ((1814 - 733) < (1278 - (11 + 192)))) then
			if (v48.CastCycle(v49.Moonfire, v85, v95, not v16:IsSpellInRange(v49.Moonfire)) or ((531 + 518) >= (4607 - (135 + 40)))) then
				return "moonfire aoe 6";
			end
		end
		if ((v49.StellarFlare:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.StellarFlare:EnergizeAmount())) and (v86 < (((26 - 15) - v49.UmbralIntensity:TalentRank()) - v49.AstralSmolder:TalentRank())) and v66) or ((2874 + 1894) <= (1863 - 1017))) then
			if (v48.CastCycle(v49.StellarFlare, v85, v96, not v16:IsSpellInRange(v49.StellarFlare)) or ((5033 - 1675) <= (1596 - (50 + 126)))) then
				return "stellar_flare aoe 9";
			end
		end
		local v143 = (v66 and ((v49.OrbitalStrike:IsAvailable() and (v13:AstralPowerDeficit() < (v64 + ((22 - 14) * v86)))) or v13:BuffUp(v49.TouchtheCosmos))) or (v13:AstralPowerDeficit() < (v64 + 2 + 6 + ((1425 - (1233 + 180)) * v26((v13:BuffRemains(v49.EclipseLunar) < (973 - (522 + 447))) or (v13:BuffRemains(v49.EclipseSolar) < (1425 - (107 + 1314)))))));
		if ((v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < (1 + 1)) and v143) or ((11392 - 7653) <= (1277 + 1728))) then
			if (v10.CastAnnotated(v52.CancelStarlord, false, "CANCEL") or ((3294 - 1635) >= (8443 - 6309))) then
				return "cancel_buff starlord aoe 9.5";
			end
		end
		if ((v49.Starfall:IsReady() and v143) or ((5170 - (716 + 1194)) < (41 + 2314))) then
			if (v24(v49.Starfall, nil, not v16:IsInRange(5 + 40)) or ((1172 - (74 + 429)) == (8146 - 3923))) then
				return "starfall aoe 10";
			end
		end
		if ((v49.Starfire:IsReady() and v13:BuffUp(v49.DreamstateBuff) and v66 and v13:BuffUp(v49.EclipseLunar)) or ((839 + 853) < (1345 - 757))) then
			if (v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire)) or ((3394 + 1403) < (11255 - 7604))) then
				return "starfire aoe 11";
			end
		end
		if (v30 or ((10327 - 6150) > (5283 - (279 + 154)))) then
			local v156 = 778 - (454 + 324);
			while true do
				if (((0 + 0) == v156) or ((417 - (12 + 5)) > (600 + 511))) then
					if (((7773 - 4722) > (372 + 633)) and v49.CelestialAlignment:IsCastable() and v66) then
						if (((4786 - (277 + 816)) <= (18724 - 14342)) and v25(v49.CelestialAlignment)) then
							return "celestial_alignment aoe 10";
						end
					end
					if ((v49.Incarnation:IsCastable() and v66) or ((4465 - (1058 + 125)) > (769 + 3331))) then
						if (v25(v49.Incarnation) or ((4555 - (815 + 160)) < (12202 - 9358))) then
							return "celestial_alignment aoe 12";
						end
					end
					break;
				end
			end
		end
		if (((211 - 122) < (1072 + 3418)) and v49.WarriorofElune:IsCastable()) then
			if (v25(v49.WarriorofElune) or ((14566 - 9583) < (3706 - (41 + 1857)))) then
				return "warrior_of_elune aoe 14";
			end
		end
		local v144 = v86 < (1896 - (1222 + 671));
		if (((9896 - 6067) > (5417 - 1648)) and v49.Starfire:IsCastable() and v144 and (v84 or (v13:BuffRemains(v49.EclipseSolar) < v49.Starfire:CastTime()))) then
			if (((2667 - (229 + 953)) <= (4678 - (1111 + 663))) and v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire))) then
				return "starfire aoe 17";
			end
		end
		if (((5848 - (874 + 705)) == (598 + 3671)) and v49.Wrath:IsCastable() and not v144 and (v84 or (v13:BuffRemains(v49.EclipseLunar) < v49.Wrath:CastTime()))) then
			if (((265 + 122) <= (5782 - 3000)) and v24(v49.Wrath, nil, nil, not v16:IsSpellInRange(v49.Wrath))) then
				return "wrath aoe 18";
			end
		end
		if ((v49.WildMushroom:IsCastable() and (v13:AstralPowerDeficit() > (v64 + 1 + 19)) and (not v49.WaningTwilight:IsAvailable() or ((v16:DebuffRemains(v49.FungalGrowthDebuff) < (681 - (642 + 37))) and (v16:TimeToDie() > (2 + 5)) and not v13:PrevGCDP(1 + 0, v49.WildMushroom)))) or ((4767 - 2868) <= (1371 - (233 + 221)))) then
			if (v24(v49.WildMushroom, nil, not v16:IsSpellInRange(v49.WildMushroom)) or ((9970 - 5658) <= (772 + 104))) then
				return "wild_mushroom aoe 20";
			end
		end
		if (((3773 - (718 + 823)) <= (1634 + 962)) and v49.FuryOfElune:IsCastable() and (((v16:TimeToDie() > (807 - (266 + 539))) and ((v72 > (8 - 5)) or ((v77:CooldownRemains() > (1255 - (636 + 589))) and (v70 <= (664 - 384))) or ((v70 >= (1155 - 595)) and (v13:AstralPowerP() > (40 + 10))))) or (v76 < (4 + 6)))) then
			if (((3110 - (657 + 358)) < (9759 - 6073)) and v24(v49.FuryOfElune, nil, not v16:IsSpellInRange(v49.FuryOfElune))) then
				return "fury_of_elune aoe 22";
			end
		end
		local v145 = (v16:TimeToDie() > (8 - 4)) and (v13:BuffUp(v49.StarweaversWarp) or (v49.Starlord:IsAvailable() and (v13:BuffStack(v49.StarlordBuff) < (1190 - (1151 + 36)))));
		if ((v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < (2 + 0)) and v145) or ((420 + 1175) >= (13361 - 8887))) then
			if (v10.CastAnnotated(v52.CancelStarlord, false, "CANCEL") or ((6451 - (1552 + 280)) < (3716 - (64 + 770)))) then
				return "cancel_buff starlord aoe 23";
			end
		end
		if ((v49.Starfall:IsReady() and v145) or ((200 + 94) >= (10966 - 6135))) then
			if (((361 + 1668) <= (4327 - (157 + 1086))) and v24(v49.Starfall, nil, not v16:IsInRange(90 - 45))) then
				return "starfall aoe 24";
			end
		end
		if ((v49.FullMoon:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.FullMoon:EnergizeAmount())) and ((v13:BuffRemains(v49.EclipseLunar) > v49.FullMoon:ExecuteTime()) or (v13:BuffRemains(v49.EclipseSolar) > v49.FullMoon:ExecuteTime())) and (v71 or ((v49.HalfMoon:ChargesFractional() > (8.5 - 6)) and (v70 <= (797 - 277)) and (v77:CooldownRemains() > (13 - 3))) or (v76 < (829 - (599 + 220))))) or ((4056 - 2019) == (4351 - (1813 + 118)))) then
			if (((3259 + 1199) > (5121 - (841 + 376))) and v24(v49.FullMoon, nil, nil, not v16:IsSpellInRange(v49.FullMoon))) then
				return "full_moon aoe 26";
			end
		end
		if (((610 - 174) >= (29 + 94)) and v49.Starsurge:IsReady() and v13:BuffUp(v49.StarweaversWeft) and (v86 < (8 - 5))) then
			if (((1359 - (464 + 395)) < (4660 - 2844)) and v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge))) then
				return "starsurge aoe 30";
			end
		end
		if (((1717 + 1857) == (4411 - (467 + 370))) and v49.StellarFlare:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.StellarFlare:EnergizeAmount())) and (v86 < (((22 - 11) - v49.UmbralIntensity:TalentRank()) - v49.AstralSmolder:TalentRank()))) then
			if (((163 + 58) < (1336 - 946)) and v48.CastCycle(v49.StellarFlare, v85, v96, not v16:IsSpellInRange(v49.StellarFlare))) then
				return "stellar_flare aoe 32";
			end
		end
		if ((v49.AstralCommunion:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.AstralCommunion:EnergizeAmount()))) or ((346 + 1867) <= (3305 - 1884))) then
			if (((3578 - (150 + 370)) < (6142 - (74 + 1208))) and v24(v49.ForceOfNature)) then
				return "astral_communion aoe 34";
			end
		end
		if ((v49.ConvokeTheSpirits:IsCastable() and v23() and (v13:AstralPowerP() < (122 - 72)) and (v86 < ((14 - 11) + v26(v49.ElunesGuidance:IsAvailable()))) and ((v13:BuffRemains(v49.EclipseLunar) > (3 + 1)) or (v13:BuffRemains(v49.EclipseSolar) > (394 - (14 + 376))))) or ((2247 - 951) >= (2877 + 1569))) then
			if (v24(v49.ConvokeTheSpirits, nil, not v16:IsInRange(36 + 4)) or ((1329 + 64) > (13153 - 8664))) then
				return "convoke_the_spirits aoe 36";
			end
		end
		if ((v49.NewMoon:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.NewMoon:EnergizeAmount()))) or ((3329 + 1095) < (105 - (23 + 55)))) then
			if (v24(v49.NewMoon, nil, nil, not v16:IsSpellInRange(v49.NewMoon)) or ((4732 - 2735) > (2546 + 1269))) then
				return "new_moon aoe 38";
			end
		end
		if (((3112 + 353) > (2965 - 1052)) and v49.HalfMoon:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.HalfMoon:EnergizeAmount())) and ((v13:BuffRemains(v49.EclipseLunar) > v49.FullMoon:ExecuteTime()) or (v13:BuffRemains(v49.EclipseSolar) > v49.FullMoon:ExecuteTime()))) then
			if (((231 + 502) < (2720 - (652 + 249))) and v24(v49.HalfMoon, nil, nil, not v16:IsSpellInRange(v49.HalfMoon))) then
				return "half_moon aoe 40";
			end
		end
		if ((v49.ForceOfNature:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49.ForceOfNature:EnergizeAmount()))) or ((11761 - 7366) == (6623 - (708 + 1160)))) then
			if (v24(v49.ForceOfNature, nil, not v16:IsInRange(122 - 77)) or ((6915 - 3122) < (2396 - (10 + 17)))) then
				return "force_of_nature aoe 42";
			end
		end
		if ((v49.Starsurge:IsReady() and v13:BuffUp(v49.StarweaversWeft) and (v86 < (4 + 13))) or ((5816 - (1400 + 332)) == (508 - 243))) then
			if (((6266 - (242 + 1666)) == (1865 + 2493)) and v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge))) then
				return "starsurge aoe 44";
			end
		end
		local v146 = 0 + 0;
		local v147 = 0 + 0;
		if (v13:BuffUp(v49.EclipseLunar) or ((4078 - (850 + 90)) < (1738 - 745))) then
			local v157 = 1390 - (360 + 1030);
			local v158;
			local v159;
			local v160;
			while true do
				if (((2947 + 383) > (6556 - 4233)) and (v157 == (1 - 0))) then
					v160 = (v159 - (1676 - (909 + 752))) / (1225 - (109 + 1114));
					break;
				end
				if (((0 - 0) == v157) or ((1412 + 2214) == (4231 - (6 + 236)))) then
					v158 = v13:BuffInfo(v49.EclipseLunar, nil, true);
					v159 = v158.points[1 + 0];
					v157 = 1 + 0;
				end
			end
		end
		if (v13:BuffUp(v49.EclipseSolar) or ((2160 - 1244) == (4665 - 1994))) then
			local v161 = 1133 - (1076 + 57);
			local v162;
			local v163;
			local v164;
			while true do
				if (((45 + 227) == (961 - (579 + 110))) and (v161 == (1 + 0))) then
					v164 = (v163 - (14 + 1)) / (2 + 0);
					break;
				end
				if (((4656 - (174 + 233)) <= (13516 - 8677)) and (v161 == (0 - 0))) then
					v162 = v13:BuffInfo(v49.EclipseSolar, nil, true);
					v163 = v162.points[1 + 0];
					v161 = 1175 - (663 + 511);
				end
			end
		end
		if (((2478 + 299) < (695 + 2505)) and v49.Starfire:IsCastable() and not v13:IsMoving() and (((v86 > ((9 - 6) - (v26(v13:BuffUp(v49.DreamstateBuff) or (v146 > v147))))) and v13:BuffUp(v49.EclipseLunar)) or v80)) then
			if (((58 + 37) < (4607 - 2650)) and v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire))) then
				return "starfire aoe 46";
			end
		end
		if (((1999 - 1173) < (820 + 897)) and v49.Wrath:IsCastable() and not v13:IsMoving()) then
			if (((2775 - 1349) >= (788 + 317)) and v25(v49.Wrath, not v16:IsSpellInRange(v49.Wrath))) then
				return "wrath aoe 48";
			end
		end
		local v148 = v101();
		if (((252 + 2502) <= (4101 - (478 + 244))) and v148) then
			return v148;
		end
		if (v10.CastAnnotated(v49.Pool, false, "MOVING") or ((4444 - (440 + 77)) == (643 + 770))) then
			return "Pool AoE due to movement and no fallthru";
		end
	end
	local function v104()
		local v149 = 0 - 0;
		local v150;
		while true do
			if ((v149 == (1556 - (655 + 901))) or ((214 + 940) <= (604 + 184))) then
				v150 = v48.HandleTopTrinket(v51, v30, 28 + 12, nil);
				if (v150 or ((6618 - 4975) > (4824 - (695 + 750)))) then
					return v150;
				end
				v149 = 3 - 2;
			end
			if ((v149 == (1 - 0)) or ((11272 - 8469) > (4900 - (285 + 66)))) then
				v150 = v48.HandleBottomTrinket(v51, v30, 93 - 53, nil);
				if (v150 or ((1530 - (682 + 628)) >= (488 + 2534))) then
					return v150;
				end
				break;
			end
		end
	end
	local function v105()
		C_Timer.After(299.15 - (176 + 123), function()
			v85 = v16:GetEnemiesInSplashRange(5 + 5);
			v47();
			v28 = EpicSettings.Toggles['ooc'];
			v29 = EpicSettings.Toggles['aoe'];
			v30 = EpicSettings.Toggles['cds'];
			v31 = EpicSettings.Toggles['toggle'];
			if (((2048 + 774) == (3091 - (239 + 30))) and v13:IsDeadOrGhost()) then
				if (v25(v49.Nothing, nil, nil) or ((289 + 772) == (1785 + 72))) then
					return "Dead";
				end
			end
			v85 = v16:GetEnemiesInSplashRange(17 - 7);
			if (((8610 - 5850) > (1679 - (306 + 9))) and v29) then
				v86 = v16:GetEnemiesInSplashRangeCount(34 - 24);
			else
				v86 = 1 + 0;
			end
			if ((not v13:IsChanneling() and v31) or ((3008 + 1894) <= (1731 + 1864))) then
				local v165 = 0 - 0;
				while true do
					if ((v165 == (1375 - (1140 + 235))) or ((2452 + 1400) == (269 + 24))) then
						if (v13:AffectingCombat() or ((401 + 1158) == (4640 - (33 + 19)))) then
							local v170 = 0 + 0;
							while true do
								if (((2 - 1) == v170) or ((1976 + 2508) == (1545 - 757))) then
									if (((4284 + 284) >= (4596 - (586 + 103))) and (v13:HealthPercentage() <= v38) and v37 and v50.Healthstone:IsReady()) then
										if (((114 + 1132) < (10682 - 7212)) and v25(v52.Healthstone, nil, nil, true)) then
											return "healthstone defensive 4";
										end
									end
									break;
								end
								if (((5556 - (1309 + 179)) >= (1754 - 782)) and (v170 == (0 + 0))) then
									if (((1323 - 830) < (2941 + 952)) and (v13:HealthPercentage() <= v46) and v49.NaturesVigil:IsReady()) then
										if (v25(v49.NaturesVigil, nil, nil, true) or ((3129 - 1656) >= (6639 - 3307))) then
											return "barkskin defensive 2";
										end
									end
									if (((v13:HealthPercentage() <= v45) and v49.Barkskin:IsReady()) or ((4660 - (295 + 314)) <= (2841 - 1684))) then
										if (((2566 - (1300 + 662)) < (9046 - 6165)) and v25(v49.Barkskin, nil, nil, true)) then
											return "barkskin defensive 2";
										end
									end
									v170 = 1756 - (1178 + 577);
								end
							end
						end
						if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or ((468 + 432) == (9983 - 6606))) then
							local v171 = 1405 - (851 + 554);
							local v172;
							while true do
								if (((3944 + 515) > (1638 - 1047)) and ((0 - 0) == v171)) then
									v172 = v48.DeadFriendlyUnitsCount();
									if (((3700 - (115 + 187)) >= (1835 + 560)) and v13:AffectingCombat()) then
										if (v49.Rebirth:IsCastable() or ((2067 + 116) >= (11128 - 8304))) then
											if (((3097 - (160 + 1001)) == (1694 + 242)) and v25(v49.Rebirth, nil, true)) then
												return "rebirth";
											end
										end
									elseif (v49.Revive:IsCastable() or ((3334 + 1498) < (8829 - 4516))) then
										if (((4446 - (237 + 121)) > (4771 - (525 + 372))) and v25(v49.Revive, not v16:IsInRange(75 - 35), true)) then
											return "revive";
										end
									end
									break;
								end
							end
						end
						v165 = 3 - 2;
					end
					if (((4474 - (96 + 46)) == (5109 - (643 + 134))) and (v165 == (1 + 1))) then
						if (((9588 - 5589) >= (10766 - 7866)) and not v13:AffectingCombat()) then
							if ((v49.MoonkinForm:IsCastable() and v44) or ((2422 + 103) > (7975 - 3911))) then
								if (((8934 - 4563) == (5090 - (316 + 403))) and v25(v49.MoonkinForm)) then
									return "moonkin_form ooc";
								end
							end
						end
						if ((v48.TargetIsValid() and v28) or v13:AffectingCombat() or ((177 + 89) > (13708 - 8722))) then
							local v173 = 0 + 0;
							local v174;
							while true do
								if (((5013 - 3022) >= (656 + 269)) and (v173 == (2 + 2))) then
									if (((1576 - 1121) < (9804 - 7751)) and v62 and v29) then
										local v178 = 0 - 0;
										local v179;
										while true do
											if ((v178 == (0 + 0)) or ((1625 - 799) == (237 + 4614))) then
												v179 = v103();
												if (((538 - 355) == (200 - (12 + 5))) and v179) then
													return v179;
												end
												v178 = 3 - 2;
											end
											if (((2472 - 1313) <= (3800 - 2012)) and (v178 == (2 - 1))) then
												if (v10.CastAnnotated(v49.Pool, false, "WAIT/AoE") or ((712 + 2795) > (6291 - (1656 + 317)))) then
													return "Wait for AoE";
												end
												break;
											end
										end
									end
									if (true or ((2741 + 334) <= (2376 + 589))) then
										local v180 = 0 - 0;
										local v181;
										while true do
											if (((6717 - 5352) <= (2365 - (5 + 349))) and (v180 == (4 - 3))) then
												if (v10.CastAnnotated(v49.Pool, false, "WAIT/ST") or ((4047 - (266 + 1005)) > (2356 + 1219))) then
													return "Wait for ST";
												end
												break;
											end
											if ((v180 == (0 - 0)) or ((3361 - 807) == (6500 - (561 + 1135)))) then
												v181 = v102();
												if (((3358 - 781) == (8470 - 5893)) and v181) then
													return v181;
												end
												v180 = 1067 - (507 + 559);
											end
										end
									end
									break;
								end
								if ((v173 == (2 - 1)) or ((18 - 12) >= (2277 - (212 + 176)))) then
									v62 = (v86 > ((906 - (250 + 655)) + v26(not v49.AetherialKindling:IsAvailable() and not v49.Starweaver:IsAvailable()))) and v49.Starfall:IsAvailable();
									v63 = v86 > (2 - 1);
									v173 = 2 - 0;
								end
								if (((791 - 285) <= (3848 - (1869 + 87))) and (v173 == (6 - 4))) then
									v64 = ((1907 - (484 + 1417)) / v13:SpellHaste()) + v26(v49.NaturesBalance:IsAvailable()) + (v26(v49.OrbitBreaker:IsAvailable()) * v26(v16:DebuffUp(v49.MoonfireDebuff)) * v26(v74.OrbitBreakerStacks > ((57 - 30) - ((2 - 0) * v26(v13:BuffUp(v49.SolsticeBuff))))) * (813 - (48 + 725)));
									if ((v49.Berserking:IsCastable() and v23() and ((v72 >= (32 - 12)) or v57 or (v76 < (39 - 24)))) or ((1167 + 841) > (5927 - 3709))) then
										if (((107 + 272) <= (1209 + 2938)) and v24(v49.Berserking, v32)) then
											return "berserking main 2";
										end
									end
									v173 = 856 - (152 + 701);
								end
								if ((v173 == (1314 - (430 + 881))) or ((1729 + 2785) <= (1904 - (557 + 338)))) then
									v174 = v104();
									if (v174 or ((1034 + 2462) == (3358 - 2166))) then
										return v174;
									end
									v173 = 13 - 9;
								end
								if ((v173 == (0 - 0)) or ((448 - 240) == (3760 - (499 + 302)))) then
									v98();
									if (((5143 - (39 + 827)) >= (3624 - 2311)) and not v13:AffectingCombat()) then
										local v182 = 0 - 0;
										local v183;
										while true do
											if (((10275 - 7688) < (4872 - 1698)) and (v182 == (0 + 0))) then
												v183 = v100();
												if (v183 or ((12058 - 7938) <= (352 + 1846))) then
													return v183;
												end
												break;
											end
										end
									end
									v173 = 1 - 0;
								end
							end
						end
						break;
					end
					if ((v165 == (105 - (103 + 1))) or ((2150 - (475 + 79)) == (1854 - 996))) then
						if (((10304 - 7084) == (417 + 2803)) and v48.TargetIsValid() and not v56) then
							v99();
						end
						if (v48.TargetIsValid() or v13:AffectingCombat() or ((1234 + 168) > (5123 - (1395 + 108)))) then
							local v175 = 0 - 0;
							while true do
								if (((3778 - (7 + 1197)) == (1123 + 1451)) and (v175 == (1 + 0))) then
									v76 = v75;
									if (((2117 - (27 + 292)) < (8078 - 5321)) and (v76 == (14169 - 3058))) then
										v76 = v10.FightRemains(v85, false);
									end
									v175 = 8 - 6;
								end
								if ((v175 == (3 - 1)) or ((717 - 340) > (2743 - (43 + 96)))) then
									v70 = 0 - 0;
									if (((1284 - 716) < (756 + 155)) and v49.PrimordialArcanicPulsar:IsAvailable()) then
										local v184 = v13:BuffInfo(v49.PAPBuff, false, true);
										if (((928 + 2357) < (8356 - 4128)) and (v184 ~= nil)) then
											v70 = v184.points[1 + 0];
										end
									end
									v175 = 5 - 2;
								end
								if (((1233 + 2683) > (245 + 3083)) and (v175 == (1755 - (1414 + 337)))) then
									if (((4440 - (1642 + 298)) < (10007 - 6168)) and v71) then
										v72 = (v49.IncarnationTalent:IsAvailable() and v13:BuffRemains(v49.IncarnationBuff)) or v13:BuffRemains(v49.CABuff);
									end
									break;
								end
								if (((1458 - 951) == (1504 - 997)) and (v175 == (0 + 0))) then
									v73 = true;
									v75 = v10.BossFightRemains();
									v175 = 1 + 0;
								end
								if (((1212 - (357 + 615)) <= (2222 + 943)) and (v175 == (6 - 3))) then
									v71 = v13:BuffUp(v49.CABuff) or v13:BuffUp(v49.IncarnationBuff);
									v72 = 0 + 0;
									v175 = 8 - 4;
								end
							end
						end
						v165 = 2 + 0;
					end
				end
			end
		end);
	end
	local function v106()
		v10.Print("Balance Druid Rotation by Epic. Supported by Gojira");
	end
	v10.SetAPL(7 + 95, v105, v106);
end;
return v0["Epix_Druid_Balance.lua"]();

