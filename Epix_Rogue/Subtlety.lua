local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((2460 - 1406) <= (4182 - (530 + 181))) and (v5 == (881 - (614 + 267)))) then
			v6 = v0[v4];
			if (not v6 or ((1635 - (19 + 13)) <= (1099 - 423))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if (((9806 - 6373) <= (1075 + 3061)) and (v5 == (1 - 0))) then
			return v6(...);
		end
	end
end
v0["Epix_Rogue_Subtlety.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Focus;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Utils.BoolToInt;
	local v20 = v10.Cast;
	local v21 = v10.Press;
	local v22 = v10.CastLeftNameplate;
	local v23 = v10.CastPooling;
	local v24 = v10.CastQueue;
	local v25 = v10.CastQueuePooling;
	local v26 = v10.Commons.Everyone.num;
	local v27 = v10.Commons.Everyone.bool;
	local v28 = pairs;
	local v29 = table.insert;
	local v30 = math.min;
	local v31 = math.max;
	local v32 = math.abs;
	local v33 = v10.Commons.Everyone;
	local v34 = v10.Commons.Rogue;
	local v35 = v10.Macro;
	local v36 = v16.Rogue.Subtlety;
	local v37 = v18.Rogue.Subtlety;
	local v38 = v35.Rogue.Subtlety;
	local v39 = false;
	local v40 = false;
	local v41 = false;
	local v42 = false;
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
	local v65 = {v37.Mirror:ID(),v37.WitherbarksBranch:ID(),v37.AshesoftheEmbersoul:ID()};
	local v66, v67, v68, v69;
	local v70, v71, v72, v73;
	local v74;
	local v75, v76, v77;
	local v78, v79;
	local v80, v81, v82, v83;
	local v84;
	v36.Eviscerate:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v80 * (0.176 - 0) * (1.21 - 0) * ((v36.Nightstalker:IsAvailable() and v13:StealthUp(true, false) and (4.08 - 3)) or (2 - 1)) * ((v36.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1 + 0)) * ((v36.DarkShadow:IsAvailable() and v13:BuffUp(v36.ShadowDanceBuff) and (2.3 - 1)) or (1 + 0)) * ((v13:BuffUp(v36.SymbolsofDeath) and (1.1 + 0)) or (1 + 0)) * ((v13:BuffUp(v36.FinalityEviscerateBuff) and (1097.3 - (709 + 387))) or (1859 - (673 + 1185))) * ((2 - 1) + (v13:MasteryPct() / (321 - 221))) * ((1 - 0) + (v13:VersatilityDmgPct() / (72 + 28))) * ((v14:DebuffUp(v36.FindWeaknessDebuff) and (1.5 + 0)) or (1 - 0));
	end);
	local function v85(v110, v111)
		if (((1043 + 3202) <= (9233 - 4602)) and not v75) then
			local v183 = 0 - 0;
			while true do
				if (((6156 - (446 + 1434)) >= (5197 - (1040 + 243))) and (v183 == (0 - 0))) then
					v75 = v110;
					v76 = v111 or (1847 - (559 + 1288));
					break;
				end
			end
		end
	end
	local function v86(v112)
		if (((2129 - (609 + 1322)) <= (4819 - (13 + 441))) and not v77) then
			v77 = v112;
		end
	end
	local function v87()
		if (((17869 - 13087) > (12248 - 7572)) and (v43 == "On Bosses not in Dungeons") and v13:IsInDungeonArea()) then
			return false;
		elseif (((24224 - 19360) > (82 + 2115)) and (v43 ~= "Always") and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v88()
		if ((v72 < (7 - 5)) or ((1315 + 2385) == (1099 + 1408))) then
			return false;
		elseif (((13276 - 8802) >= (150 + 124)) and (v44 == "Always")) then
			return true;
		elseif (((v44 == "On Bosses") and v14:IsInBossList()) or ((3483 - 1589) <= (930 + 476))) then
			return true;
		elseif (((875 + 697) >= (1101 + 430)) and (v44 == "Auto")) then
			if (((v13:InstanceDifficulty() == (14 + 2)) and (v14:NPCID() == (135964 + 3003))) or ((5120 - (153 + 280)) < (13115 - 8573))) then
				return true;
			elseif (((2955 + 336) > (659 + 1008)) and ((v14:NPCID() == (87378 + 79591)) or (v14:NPCID() == (151523 + 15448)) or (v14:NPCID() == (120987 + 45983)))) then
				return true;
			elseif ((v14:NPCID() == (279361 - 95898)) or (v14:NPCID() == (113520 + 70151)) or ((1540 - (89 + 578)) == (1454 + 580))) then
				return true;
			end
		end
		return false;
	end
	local function v89(v113, v114, v115, v116)
		local v117, v118 = nil, v115;
		local v119 = v14:GUID();
		for v180, v181 in v28(v116) do
			if (((v181:GUID() ~= v119) and v33.UnitIsCycleValid(v181, v118, -v181:DebuffRemains(v113)) and v114(v181)) or ((5853 - 3037) < (1060 - (572 + 477)))) then
				v117, v118 = v181, v181:TimeToDie();
			end
		end
		if (((499 + 3200) < (2825 + 1881)) and v117 and (v14:GUID() == v117:GUID())) then
			v10.Press(v113);
		elseif (((316 + 2330) >= (962 - (84 + 2))) and v45) then
			local v193 = 0 - 0;
			while true do
				if (((443 + 171) <= (4026 - (497 + 345))) and (v193 == (1 + 0))) then
					if (((529 + 2597) == (4459 - (605 + 728))) and v117 and (v14:GUID() == v117:GUID())) then
						v10.Press(v113);
					end
					break;
				end
				if ((v193 == (0 + 0)) or ((4861 - 2674) >= (228 + 4726))) then
					v117, v118 = nil, v115;
					for v212, v213 in v28(v71) do
						if (((v213:GUID() ~= v119) and v33.UnitIsCycleValid(v213, v118, -v213:DebuffRemains(v113)) and v114(v213)) or ((14334 - 10457) == (3223 + 352))) then
							v117, v118 = v213, v213:TimeToDie();
						end
					end
					v193 = 2 - 1;
				end
			end
		end
	end
	local function v90()
		return 16 + 4 + (v36.Vigor:TalentRank() * (514 - (457 + 32))) + (v26(v36.ThistleTea:IsAvailable()) * (9 + 11)) + (v26(v36.Shadowcraft:IsAvailable()) * (1422 - (832 + 570)));
	end
	local function v91()
		return v36.ShadowDance:ChargesFractional() >= (0.75 + 0 + v19(v36.ShadowDanceTalent:IsAvailable()));
	end
	local function v92()
		return v82 >= (1 + 2);
	end
	local function v93()
		return v13:BuffUp(v36.SliceandDice) or (v72 >= v34.CPMaxSpend());
	end
	local function v94()
		return v36.Premeditation:IsAvailable() and (v72 < (17 - 12));
	end
	local function v95(v120)
		return (v13:BuffUp(v36.ThistleTea) and (v72 == (1 + 0))) or (v120 and ((v72 == (797 - (588 + 208))) or (v14:DebuffUp(v36.Rupture) and (v72 >= (5 - 3)))));
	end
	local function v96()
		return (not v13:BuffUp(v36.TheRotten) or not v13:HasTier(1830 - (884 + 916), 3 - 1)) and (not v36.ColdBlood:IsAvailable() or (v36.ColdBlood:CooldownRemains() < (3 + 1)) or (v36.ColdBlood:CooldownRemains() > (663 - (232 + 421))));
	end
	local function v97(v121)
		return v13:BuffUp(v36.ShadowDanceBuff) and (v121:TimeSinceLastCast() < v36.ShadowDance:TimeSinceLastCast());
	end
	local function v98()
		return ((v97(v36.Shadowstrike) or v97(v36.ShurikenStorm)) and (v97(v36.Eviscerate) or v97(v36.BlackPowder) or v97(v36.Rupture))) or not v36.DanseMacabre:IsAvailable();
	end
	local function v99()
		return (not v37.WitherbarksBranch:IsEquipped() and not v37.AshesoftheEmbersoul:IsEquipped()) or (not v37.WitherbarksBranch:IsEquipped() and (v37.WitherbarksBranch:CooldownRemains() <= (1897 - (1569 + 320)))) or (v37.WitherbarksBranch:IsEquipped() and (v37.WitherbarksBranch:CooldownRemains() <= (2 + 6))) or v37.BandolierOfTwistedBlades:IsEquipped() or v36.InvigoratingShadowdust:IsAvailable();
	end
	local function v100(v122, v123)
		local v124 = v13:BuffUp(v36.ShadowDanceBuff);
		local v125 = v13:BuffRemains(v36.ShadowDanceBuff);
		local v126 = v13:BuffRemains(v36.SymbolsofDeath);
		local v127 = v81;
		local v128 = v36.ColdBlood:CooldownRemains();
		local v129 = v36.SymbolsofDeath:CooldownRemains();
		local v130 = v13:BuffUp(v36.PremeditationBuff) or (v123 and v36.Premeditation:IsAvailable());
		if (((135 + 572) > (2129 - 1497)) and v123 and (v123:ID() == v36.ShadowDance:ID())) then
			local v184 = 605 - (316 + 289);
			while true do
				if ((v184 == (0 - 0)) or ((26 + 520) >= (4137 - (666 + 787)))) then
					v124 = true;
					v125 = (433 - (360 + 65)) + v36.ImprovedShadowDance:TalentRank();
					v184 = 1 + 0;
				end
				if (((1719 - (79 + 175)) <= (6781 - 2480)) and (v184 == (1 + 0))) then
					if (((5223 - 3519) > (2744 - 1319)) and v36.TheFirstDance:IsAvailable()) then
						v127 = v30(v13:ComboPointsMax(), v81 + (903 - (503 + 396)));
					end
					if (v13:HasTier(211 - (92 + 89), 3 - 1) or ((353 + 334) == (2506 + 1728))) then
						v126 = v31(v126, 23 - 17);
					end
					break;
				end
			end
		end
		if ((v123 and (v123:ID() == v36.Vanish:ID())) or ((456 + 2874) < (3257 - 1828))) then
			local v185 = 0 + 0;
			while true do
				if (((548 + 599) >= (1020 - 685)) and (v185 == (0 + 0))) then
					v128 = v30(0 - 0, v36.ColdBlood:CooldownRemains() - ((1259 - (485 + 759)) * v36.InvigoratingShadowdust:TalentRank()));
					v129 = v30(0 - 0, v36.SymbolsofDeath:CooldownRemains() - ((1204 - (442 + 747)) * v36.InvigoratingShadowdust:TalentRank()));
					break;
				end
			end
		end
		if (((4570 - (832 + 303)) > (3043 - (88 + 858))) and v36.Rupture:IsCastable() and v36.Rupture:IsReady()) then
			if ((v14:DebuffDown(v36.Rupture) and (v14:TimeToDie() > (2 + 4))) or ((3121 + 649) >= (167 + 3874))) then
				if (v122 or ((4580 - (766 + 23)) <= (7953 - 6342))) then
					return v36.Rupture;
				else
					local v202 = 0 - 0;
					while true do
						if ((v202 == (0 - 0)) or ((15537 - 10959) <= (3081 - (1036 + 37)))) then
							if (((798 + 327) <= (4042 - 1966)) and v36.Rupture:IsReady() and v20(v36.Rupture)) then
								return "Cast Rupture";
							end
							v86(v36.Rupture);
							break;
						end
					end
				end
			end
		end
		if ((not v13:StealthUp(true, true) and not v94() and (v72 < (5 + 1)) and not v124 and v10.BossFilteredFightRemains(">", v13:BuffRemains(v36.SliceandDice)) and (v13:BuffRemains(v36.SliceandDice) < (((1481 - (641 + 839)) + v13:ComboPoints()) * (914.8 - (910 + 3))))) or ((1893 - 1150) >= (6083 - (1466 + 218)))) then
			if (((531 + 624) < (2821 - (556 + 592))) and v122) then
				return v36.SliceandDice;
			else
				local v194 = 0 + 0;
				while true do
					if ((v194 == (808 - (329 + 479))) or ((3178 - (174 + 680)) <= (1985 - 1407))) then
						if (((7807 - 4040) == (2690 + 1077)) and v36.SliceandDice:IsReady() and v20(v36.SliceandDice)) then
							return "Cast Slice and Dice Premed";
						end
						v86(v36.SliceandDice);
						break;
					end
				end
			end
		end
		if (((4828 - (396 + 343)) == (362 + 3727)) and (not v95(v124) or v84) and (v14:TimeToDie() > (1483 - (29 + 1448))) and v14:DebuffRefreshable(v36.Rupture, v78)) then
			if (((5847 - (135 + 1254)) >= (6306 - 4632)) and v122) then
				return v36.Rupture;
			else
				local v195 = 0 - 0;
				while true do
					if (((648 + 324) <= (2945 - (389 + 1138))) and ((574 - (102 + 472)) == v195)) then
						if ((v36.Rupture:IsReady() and v20(v36.Rupture)) or ((4660 + 278) < (2641 + 2121))) then
							return "Cast Rupture";
						end
						v86(v36.Rupture);
						break;
					end
				end
			end
		end
		if ((v13:BuffUp(v36.FinalityRuptureBuff) and v124 and (v72 <= (4 + 0)) and not v97(v36.Rupture)) or ((4049 - (320 + 1225)) > (7590 - 3326))) then
			if (((1318 + 835) == (3617 - (157 + 1307))) and v122) then
				return v36.Rupture;
			else
				if ((v36.Rupture:IsReady() and v20(v36.Rupture)) or ((2366 - (821 + 1038)) >= (6464 - 3873))) then
					return "Cast Rupture Finality";
				end
				v86(v36.Rupture);
			end
		end
		if (((491 + 3990) == (7959 - 3478)) and v36.ColdBlood:IsReady() and v98(v124, v130) and v36.SecretTechnique:IsReady()) then
			local v186 = 0 + 0;
			while true do
				if ((v186 == (0 - 0)) or ((3354 - (834 + 192)) < (45 + 648))) then
					if (((1111 + 3217) == (93 + 4235)) and v122) then
						return v36.ColdBlood;
					end
					if (((2459 - 871) >= (1636 - (300 + 4))) and v20(v36.ColdBlood)) then
						return "Cast Cold Blood (SecTec)";
					end
					break;
				end
			end
		end
		if (v36.SecretTechnique:IsReady() or ((1115 + 3059) > (11120 - 6872))) then
			if ((v98(v124, v130) and (not v36.ColdBlood:IsAvailable() or v13:BuffUp(v36.ColdBlood) or (v128 > (v125 - (364 - (112 + 250)))) or not v36.ImprovedShadowDance:IsAvailable())) or ((1829 + 2757) <= (205 - 123))) then
				if (((2214 + 1649) == (1998 + 1865)) and v122) then
					return v36.SecretTechnique;
				end
				if (v20(v36.SecretTechnique) or ((211 + 71) <= (21 + 21))) then
					return "Cast Secret Technique";
				end
			end
		end
		if (((3424 + 1185) >= (2180 - (1001 + 413))) and not v95(v124) and v36.Rupture:IsCastable()) then
			local v187 = 0 - 0;
			while true do
				if (((882 - (244 + 638)) == v187) or ((1845 - (627 + 66)) == (7413 - 4925))) then
					if (((4024 - (512 + 90)) > (5256 - (1665 + 241))) and not v122 and v40 and not v84 and (v72 >= (719 - (373 + 344)))) then
						local v204 = 0 + 0;
						local v205;
						while true do
							if (((233 + 644) > (991 - 615)) and (v204 == (1 - 0))) then
								v89(v36.Rupture, v205, (1101 - (35 + 1064)) * v127, v73);
								break;
							end
							if (((0 + 0) == v204) or ((6670 - 3552) <= (8 + 1843))) then
								v205 = nil;
								function v205(v214)
									return v33.CanDoTUnit(v214, v79) and v214:DebuffRefreshable(v36.Rupture, v78);
								end
								v204 = 1237 - (298 + 938);
							end
						end
					end
					if ((v68 and (v14:DebuffRemains(v36.Rupture) < (v129 + (1269 - (233 + 1026)))) and (v129 <= (1671 - (636 + 1030))) and v34.CanDoTUnit(v14, v79) and v14:FilteredTimeToDie(">", 3 + 2 + v129, -v14:DebuffRemains(v36.Rupture))) or ((162 + 3) >= (1038 + 2454))) then
						if (((267 + 3682) < (5077 - (55 + 166))) and v122) then
							return v36.Rupture;
						else
							if ((v36.Rupture:IsReady() and v20(v36.Rupture)) or ((829 + 3447) < (304 + 2712))) then
								return "Cast Rupture 2";
							end
							v86(v36.Rupture);
						end
					end
					break;
				end
			end
		end
		if (((17911 - 13221) > (4422 - (36 + 261))) and v36.BlackPowder:IsCastable() and not v84 and (v72 >= (4 - 1))) then
			if (v122 or ((1418 - (34 + 1334)) >= (345 + 551))) then
				return v36.BlackPowder;
			else
				local v196 = 0 + 0;
				while true do
					if ((v196 == (1283 - (1035 + 248))) or ((1735 - (20 + 1)) >= (1542 + 1416))) then
						if ((v36.BlackPowder:IsReady() and v20(v36.BlackPowder)) or ((1810 - (134 + 185)) < (1777 - (549 + 584)))) then
							return "Cast Black Powder";
						end
						v86(v36.BlackPowder);
						break;
					end
				end
			end
		end
		if (((1389 - (314 + 371)) < (3388 - 2401)) and v36.Eviscerate:IsCastable() and v68) then
			if (((4686 - (478 + 490)) > (1010 + 896)) and v122) then
				return v36.Eviscerate;
			else
				if ((v36.Eviscerate:IsReady() and v20(v36.Eviscerate)) or ((2130 - (786 + 386)) > (11773 - 8138))) then
					return "Cast Eviscerate";
				end
				v86(v36.Eviscerate);
			end
		end
		return false;
	end
	local function v101(v131, v132)
		local v133 = v13:BuffUp(v36.ShadowDanceBuff);
		local v134 = v13:BuffRemains(v36.ShadowDanceBuff);
		local v135 = v13:BuffUp(v36.TheRottenBuff);
		local v136, v137 = v81, v82;
		local v138 = v13:BuffUp(v36.PremeditationBuff) or (v132 and v36.Premeditation:IsAvailable());
		local v139 = v13:BuffUp(v34.StealthSpell()) or (v132 and (v132:ID() == v34.StealthSpell():ID()));
		local v140 = v13:BuffUp(v34.VanishBuffSpell()) or (v132 and (v132:ID() == v36.Vanish:ID()));
		if (((4880 - (1055 + 324)) <= (5832 - (1093 + 247))) and v132 and (v132:ID() == v36.ShadowDance:ID())) then
			v133 = true;
			v134 = 8 + 0 + v36.ImprovedShadowDance:TalentRank();
			if ((v36.TheRotten:IsAvailable() and v13:HasTier(4 + 26, 7 - 5)) or ((11681 - 8239) < (7250 - 4702))) then
				v135 = true;
			end
			if (((7224 - 4349) >= (521 + 943)) and v36.TheFirstDance:IsAvailable()) then
				v136 = v30(v13:ComboPointsMax(), v81 + (15 - 11));
				v137 = v13:ComboPointsMax() - v136;
			end
		end
		local v141 = v34.EffectiveComboPoints(v136);
		local v142 = v36.Shadowstrike:IsCastable() or v139 or v140 or v133 or v13:BuffUp(v36.SepsisBuff);
		if (v139 or v140 or ((16534 - 11737) >= (3690 + 1203))) then
			v142 = v142 and v14:IsInRange(63 - 38);
		else
			v142 = v142 and v68;
		end
		if ((v142 and v139 and ((v72 < (692 - (364 + 324))) or v84)) or ((1510 - 959) > (4962 - 2894))) then
			if (((701 + 1413) > (3949 - 3005)) and v131) then
				return v36.Shadowstrike;
			elseif (v20(v36.Shadowstrike) or ((3621 - 1359) >= (9402 - 6306))) then
				return "Cast Shadowstrike (Stealth)";
			end
		end
		if ((v141 >= v34.CPMaxSpend()) or ((3523 - (1249 + 19)) >= (3193 + 344))) then
			return v100(v131, v132);
		end
		if ((v13:BuffUp(v36.ShurikenTornado) and (v137 <= (7 - 5))) or ((4923 - (686 + 400)) < (1025 + 281))) then
			return v100(v131, v132);
		end
		if (((3179 - (73 + 156)) == (14 + 2936)) and (v82 <= ((812 - (721 + 90)) + v26(v36.DeeperStratagem:IsAvailable() or v36.SecretStratagem:IsAvailable())))) then
			return v100(v131, v132);
		end
		if ((v36.Backstab:IsCastable() and not v138 and (v134 >= (1 + 2)) and v13:BuffUp(v36.ShadowBlades) and not v97(v36.Backstab) and v36.DanseMacabre:IsAvailable() and (v72 <= (9 - 6)) and not v135) or ((5193 - (224 + 246)) < (5342 - 2044))) then
			if (((2091 - 955) >= (28 + 126)) and v131) then
				if (v132 or ((7 + 264) > (3488 + 1260))) then
					return v36.Backstab;
				else
					return {v36.Backstab,v36.Stealth};
				end
			elseif (((5253 - (203 + 310)) >= (5145 - (1238 + 755))) and v24(v36.Backstab, v36.Stealth)) then
				return "Cast Backstab (Stealth)";
			end
		end
		if (v36.Gloomblade:IsAvailable() or ((181 + 2397) >= (4924 - (709 + 825)))) then
			if (((75 - 34) <= (2419 - 758)) and not v138 and (v134 >= (867 - (196 + 668))) and v13:BuffUp(v36.ShadowBlades) and not v97(v36.Gloomblade) and v36.DanseMacabre:IsAvailable() and (v72 <= (15 - 11))) then
				if (((1244 - 643) < (4393 - (171 + 662))) and v131) then
					if (((328 - (4 + 89)) < (2407 - 1720)) and v132) then
						return v36.Gloomblade;
					else
						return {v36.Gloomblade,v36.Stealth};
					end
				elseif (((1784 + 2765) > (2639 - (35 + 1451))) and v24(v36.Gloomblade, v36.Stealth)) then
					return "Cast Gloomblade (Danse)";
				end
			end
		end
		if ((not v97(v36.Shadowstrike) and v13:BuffUp(v36.ShadowBlades)) or ((6127 - (28 + 1425)) < (6665 - (941 + 1052)))) then
			if (((3518 + 150) < (6075 - (822 + 692))) and v131) then
				return v36.Shadowstrike;
			elseif (v20(v36.Shadowstrike) or ((649 - 194) == (1699 + 1906))) then
				return "Cast Shadowstrike (Danse)";
			end
		end
		if ((not v138 and (v72 >= (301 - (45 + 252)))) or ((2635 + 28) == (1140 + 2172))) then
			if (((10408 - 6131) <= (4908 - (114 + 319))) and v131) then
				return v36.ShurikenStorm;
			elseif (v20(v36.ShurikenStorm) or ((1249 - 379) == (1522 - 333))) then
				return "Cast Shuriken Storm";
			end
		end
		if (((991 + 562) <= (4667 - 1534)) and v142) then
			if (v131 or ((4687 - 2450) >= (5474 - (556 + 1407)))) then
				return v36.Shadowstrike;
			elseif (v20(v36.Shadowstrike) or ((2530 - (741 + 465)) > (3485 - (170 + 295)))) then
				return "Cast Shadowstrike";
			end
		end
		return false;
	end
	local function v102(v143, v144)
		local v145 = 0 + 0;
		local v146;
		local v147;
		while true do
			if ((v145 == (3 + 0)) or ((7366 - 4374) == (1560 + 321))) then
				return false;
			end
			if (((1992 + 1114) > (865 + 661)) and (v145 == (1232 - (957 + 273)))) then
				v74 = v24(unpack(v147));
				if (((809 + 2214) < (1550 + 2320)) and v74) then
					return "| " .. v147[7 - 5]:Name();
				end
				v145 = 7 - 4;
			end
			if (((436 - 293) > (366 - 292)) and (v145 == (1780 - (389 + 1391)))) then
				v146 = v101(true, v143);
				if (((12 + 6) < (220 + 1892)) and (v143:ID() == v36.Vanish:ID()) and (not v46 or not v146)) then
					if (((2497 - 1400) <= (2579 - (783 + 168))) and v20(v36.Vanish, nil)) then
						return "Cast Vanish";
					end
					return false;
				elseif (((15539 - 10909) == (4555 + 75)) and (v143:ID() == v36.Shadowmeld:ID()) and (not v47 or not v146)) then
					local v206 = 311 - (309 + 2);
					while true do
						if (((10871 - 7331) > (3895 - (1090 + 122))) and (v206 == (0 + 0))) then
							if (((16100 - 11306) >= (2242 + 1033)) and v20(v36.Shadowmeld, nil)) then
								return "Cast Shadowmeld";
							end
							return false;
						end
					end
				elseif (((2602 - (628 + 490)) == (267 + 1217)) and (v143:ID() == v36.ShadowDance:ID()) and (not v48 or not v146)) then
					if (((3544 - 2112) < (16246 - 12691)) and v20(v36.ShadowDance, nil)) then
						return "Cast Shadow Dance";
					end
					return false;
				end
				v145 = 775 - (431 + 343);
			end
			if ((v145 == (1 - 0)) or ((3080 - 2015) > (2827 + 751))) then
				v147 = {v143,v146};
				if ((v144 and (v13:EnergyPredicted() < v144)) or ((4810 - (6 + 9)) < (258 + 1149))) then
					local v199 = 0 + 0;
					while true do
						if (((2022 - (28 + 141)) < (1865 + 2948)) and (v199 == (0 - 0))) then
							v85(v147, v144);
							return false;
						end
					end
				end
				v145 = 2 + 0;
			end
		end
	end
	local function v103()
		local v148 = 1317 - (486 + 831);
		local v149;
		local v150;
		local v151;
		while true do
			if ((v148 == (2 - 1)) or ((9931 - 7110) < (460 + 1971))) then
				if ((v41 and v36.SymbolsofDeath:IsReady()) or ((9087 - 6213) < (3444 - (668 + 595)))) then
					if ((v93() and (not v13:BuffUp(v36.TheRotten) or not v13:HasTier(27 + 3, 1 + 1)) and (v13:BuffRemains(v36.SymbolsofDeath) <= (8 - 5)) and (not v36.Flagellation:IsAvailable() or (v36.Flagellation:CooldownRemains() > (300 - (23 + 267))) or ((v13:BuffRemains(v36.ShadowDance) >= (1946 - (1129 + 815))) and v36.InvigoratingShadowdust:IsAvailable()) or (v36.Flagellation:IsReady() and (v80 >= (392 - (371 + 16))) and not v36.InvigoratingShadowdust:IsAvailable()))) or ((4439 - (1326 + 424)) <= (649 - 306))) then
						if (v20(v36.SymbolsofDeath, nil) or ((6829 - 4960) == (2127 - (88 + 30)))) then
							return "Cast Symbols of Death";
						end
					end
				end
				if ((v41 and v36.ShadowBlades:IsReady()) or ((4317 - (720 + 51)) < (5165 - 2843))) then
					if ((v93() and ((v80 <= (1777 - (421 + 1355))) or v13:HasTier(50 - 19, 2 + 2)) and (v13:BuffUp(v36.Flagellation) or v13:BuffUp(v36.FlagellationPersistBuff) or not v36.Flagellation:IsAvailable())) or ((3165 - (286 + 797)) == (17448 - 12675))) then
						if (((5373 - 2129) > (1494 - (397 + 42))) and v20(v36.ShadowBlades, nil)) then
							return "Cast Shadow Blades";
						end
					end
				end
				if ((v41 and v36.EchoingReprimand:IsCastable() and v36.EchoingReprimand:IsAvailable()) or ((1035 + 2278) <= (2578 - (24 + 776)))) then
					if ((v93() and (v82 >= (4 - 1))) or ((2206 - (222 + 563)) >= (4635 - 2531))) then
						if (((1305 + 507) <= (3439 - (23 + 167))) and v20(v36.EchoingReprimand, nil, nil)) then
							return "Cast Echoing Reprimand";
						end
					end
				end
				v148 = 1800 - (690 + 1108);
			end
			if (((586 + 1037) <= (1615 + 342)) and (v148 == (853 - (40 + 808)))) then
				if (((727 + 3685) == (16871 - 12459)) and v36.Berserking:IsCastable() and v150 and v51) then
					if (((1673 + 77) >= (446 + 396)) and v20(v36.Berserking, nil)) then
						return "Cast Berserking";
					end
				end
				if (((2398 + 1974) > (2421 - (47 + 524))) and v36.Fireblood:IsCastable() and v150 and v51) then
					if (((151 + 81) < (2244 - 1423)) and v20(v36.Fireblood, nil)) then
						return "Cast Fireblood";
					end
				end
				if (((774 - 256) < (2056 - 1154)) and v36.AncestralCall:IsCastable() and v150 and v51) then
					if (((4720 - (1165 + 561)) > (26 + 832)) and v20(v36.AncestralCall, nil)) then
						return "Cast Ancestral Call";
					end
				end
				v148 = 18 - 12;
			end
			if ((v148 == (0 + 0)) or ((4234 - (341 + 138)) <= (247 + 668))) then
				if (((8143 - 4197) > (4069 - (89 + 237))) and v41 and v36.ColdBlood:IsReady() and not v36.SecretTechnique:IsAvailable() and (v81 >= (16 - 11))) then
					if (v20(v36.ColdBlood, nil) or ((2810 - 1475) >= (4187 - (581 + 300)))) then
						return "Cast Cold Blood";
					end
				end
				if (((6064 - (855 + 365)) > (5351 - 3098)) and v41 and v36.Sepsis:IsAvailable() and v36.Sepsis:IsReady()) then
					if (((148 + 304) == (1687 - (1030 + 205))) and v93() and v14:FilteredTimeToDie(">=", 16 + 0) and (v13:BuffUp(v36.PerforatedVeins) or not v36.PerforatedVeins:IsAvailable())) then
						if (v20(v36.Sepsis, nil, nil) or ((4240 + 317) < (2373 - (156 + 130)))) then
							return "Cast Sepsis";
						end
					end
				end
				if (((8802 - 4928) == (6528 - 2654)) and v41 and v36.Flagellation:IsAvailable() and v36.Flagellation:IsReady()) then
					if ((v93() and (v80 >= (10 - 5)) and (v14:TimeToDie() > (3 + 7)) and ((v99() and (v36.ShadowBlades:CooldownRemains() <= (2 + 1))) or v10.BossFilteredFightRemains("<=", 97 - (10 + 59)) or ((v36.ShadowBlades:CooldownRemains() >= (4 + 10)) and v36.InvigoratingShadowdust:IsAvailable() and v36.ShadowDance:IsAvailable())) and (not v36.InvigoratingShadowdust:IsAvailable() or v36.Sepsis:IsAvailable() or not v36.ShadowDance:IsAvailable() or ((v36.InvigoratingShadowdust:TalentRank() == (9 - 7)) and (v72 >= (1165 - (671 + 492)))) or (v36.SymbolsofDeath:CooldownRemains() <= (3 + 0)) or (v13:BuffRemains(v36.SymbolsofDeath) > (1218 - (369 + 846))))) or ((514 + 1424) > (4212 + 723))) then
						if (v20(v36.Flagellation, nil, nil) or ((6200 - (1036 + 909)) < (2722 + 701))) then
							return "Cast Flagellation";
						end
					end
				end
				v148 = 1 - 0;
			end
			if (((1657 - (11 + 192)) <= (1259 + 1232)) and (v148 == (178 - (135 + 40)))) then
				if ((v41 and v36.GoremawsBite:IsAvailable() and v36.GoremawsBite:IsReady()) or ((10071 - 5914) <= (1690 + 1113))) then
					if (((10690 - 5837) >= (4469 - 1487)) and v93() and (v82 >= (179 - (50 + 126))) and (not v36.ShadowDance:IsReady() or (v36.ShadowDance:IsAvailable() and v13:BuffUp(v36.ShadowDance) and not v36.InvigoratingShadowdust:IsAvailable()) or ((v72 < (11 - 7)) and not v36.InvigoratingShadowdust:IsAvailable()) or v36.TheRotten:IsAvailable())) then
						if (((915 + 3219) > (4770 - (1233 + 180))) and v20(v36.GoremawsBite)) then
							return "Cast Goremaw's Bite";
						end
					end
				end
				if (v36.ThistleTea:IsReady() or ((4386 - (522 + 447)) < (3955 - (107 + 1314)))) then
					if ((((v36.SymbolsofDeath:CooldownRemains() >= (2 + 1)) or v13:BuffUp(v36.SymbolsofDeath)) and not v13:BuffUp(v36.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (304 - 204)) and ((v82 >= (1 + 1)) or (v72 >= (5 - 2)))) or ((v36.ThistleTea:ChargesFractional() >= ((7.75 - 5) - ((1910.15 - (716 + 1194)) * v36.InvigoratingShadowdust:TalentRank()))) and v36.Vanish:IsReady() and v13:BuffUp(v36.ShadowDance) and v14:DebuffUp(v36.Rupture) and (v72 < (1 + 2))))) or ((v13:BuffRemains(v36.ShadowDance) >= (1 + 3)) and not v13:BuffUp(v36.ThistleTea) and (v72 >= (506 - (74 + 429)))) or (not v13:BuffUp(v36.ThistleTea) and v10.BossFilteredFightRemains("<=", (11 - 5) * v36.ThistleTea:Charges())) or ((1350 + 1372) <= (375 - 211))) then
						if (v20(v36.ThistleTea, nil, nil) or ((1704 + 704) < (6501 - 4392))) then
							return "Thistle Tea";
						end
					end
				end
				v149 = v33.HandleDPSPotion(v10.BossFilteredFightRemains("<", 74 - 44) or (v13:BuffUp(v36.SymbolsofDeath) and (v13:BuffUp(v36.ShadowBlades) or (v36.ShadowBlades:CooldownRemains() <= (443 - (279 + 154))))));
				v148 = 782 - (454 + 324);
			end
			if ((v148 == (4 + 0)) or ((50 - (12 + 5)) == (785 + 670))) then
				if (v149 or ((1128 - 685) >= (1484 + 2531))) then
					return v149;
				end
				v150 = v13:BuffUp(v36.ShadowBlades) or (not v36.ShadowBlades:IsAvailable() and v13:BuffUp(v36.SymbolsofDeath)) or v10.BossFilteredFightRemains("<", 1113 - (277 + 816));
				if (((14451 - 11069) > (1349 - (1058 + 125))) and v36.BloodFury:IsCastable() and v150 and v51) then
					if (v20(v36.BloodFury, nil) or ((53 + 227) == (4034 - (815 + 160)))) then
						return "Cast Blood Fury";
					end
				end
				v148 = 21 - 16;
			end
			if (((4465 - 2584) > (309 + 984)) and (v148 == (17 - 11))) then
				v151 = v33.HandleTopTrinket(v65, v41, 1938 - (41 + 1857), nil);
				if (((4250 - (1222 + 671)) == (6091 - 3734)) and v151) then
					return v151;
				end
				v151 = v33.HandleBottomTrinket(v65, v41, 57 - 17, nil);
				v148 = 1189 - (229 + 953);
			end
			if (((1897 - (1111 + 663)) == (1702 - (874 + 705))) and (v148 == (1 + 6))) then
				if (v151 or ((721 + 335) >= (7050 - 3658))) then
					return v151;
				end
				if (v36.ThistleTea:IsReady() or ((31 + 1050) < (1754 - (642 + 37)))) then
					if ((((v36.SymbolsofDeath:CooldownRemains() >= (1 + 2)) or v13:BuffUp(v36.SymbolsofDeath)) and not v13:BuffUp(v36.ThistleTea) and (((v13:EnergyDeficitPredicted() >= (16 + 84)) and ((v13:ComboPointsDeficit() >= (4 - 2)) or (v72 >= (457 - (233 + 221))))) or ((v36.ThistleTea:ChargesFractional() >= (4.75 - 2)) and v13:BuffUp(v36.ShadowDanceBuff)))) or ((v13:BuffRemains(v36.ShadowDanceBuff) >= (4 + 0)) and not v13:BuffUp(v36.ThistleTea) and (v72 >= (1544 - (718 + 823)))) or (not v13:BuffUp(v36.ThistleTea) and v10.BossFilteredFightRemains("<=", (4 + 2) * v36.ThistleTea:Charges())) or ((1854 - (266 + 539)) >= (12547 - 8115))) then
						if (v20(v36.ThistleTea, nil, nil) or ((5993 - (636 + 589)) <= (2008 - 1162))) then
							return "Thistle Tea";
						end
					end
				end
				return false;
			end
			if ((v148 == (3 - 1)) or ((2662 + 696) <= (516 + 904))) then
				if ((v41 and v36.ShurikenTornado:IsAvailable() and v36.ShurikenTornado:IsReady()) or ((4754 - (657 + 358)) <= (7956 - 4951))) then
					if ((v93() and v13:BuffUp(v36.SymbolsofDeath) and (v80 <= (4 - 2)) and not v13:BuffUp(v36.Premeditation) and (not v36.Flagellation:IsAvailable() or (v36.Flagellation:CooldownRemains() > (1207 - (1151 + 36)))) and (v72 >= (3 + 0))) or ((437 + 1222) >= (6372 - 4238))) then
						if (v20(v36.ShurikenTornado, nil) or ((5092 - (1552 + 280)) < (3189 - (64 + 770)))) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				if ((v41 and v36.ShurikenTornado:IsAvailable() and v36.ShurikenTornado:IsReady()) or ((455 + 214) == (9586 - 5363))) then
					if ((v93() and not v13:BuffUp(v36.ShadowDance) and not v13:BuffUp(v36.Flagellation) and not v13:BuffUp(v36.FlagellationPersistBuff) and not v13:BuffUp(v36.ShadowBlades) and (v72 <= (1 + 1))) or ((2935 - (157 + 1086)) < (1176 - 588))) then
						if (v20(v36.ShurikenTornado, nil) or ((21009 - 16212) < (5600 - 1949))) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				if ((v41 and v36.ShadowDance:IsAvailable() and v87() and v36.ShadowDance:IsReady()) or ((5701 - 1524) > (5669 - (599 + 220)))) then
					if ((not v13:BuffUp(v36.ShadowDance) and v10.BossFilteredFightRemains("<=", (15 - 7) + ((1934 - (1813 + 118)) * v26(v36.Subterfuge:IsAvailable())))) or ((293 + 107) > (2328 - (841 + 376)))) then
						if (((4274 - 1223) > (234 + 771)) and v20(v36.ShadowDance)) then
							return "Cast Shadow Dance";
						end
					end
				end
				v148 = 8 - 5;
			end
		end
	end
	local function v104(v152)
		local v153 = 859 - (464 + 395);
		while true do
			if (((9477 - 5784) <= (2105 + 2277)) and ((838 - (467 + 370)) == v153)) then
				return false;
			end
			if ((v153 == (0 - 0)) or ((2410 + 872) > (14054 - 9954))) then
				if ((v41 and not (v33.IsSoloMode() and v13:IsTanking(v14))) or ((559 + 3021) < (6616 - 3772))) then
					local v200 = 520 - (150 + 370);
					while true do
						if (((1371 - (74 + 1208)) < (11043 - 6553)) and (v200 == (4 - 3))) then
							if ((v51 and v36.Shadowmeld:IsCastable() and v68 and not v13:IsMoving() and (v13:EnergyPredicted() >= (29 + 11)) and (v13:EnergyDeficitPredicted() >= (400 - (14 + 376))) and not v91() and (v82 > (6 - 2))) or ((3225 + 1758) < (1589 + 219))) then
								v74 = v102(v36.Shadowmeld, v152);
								if (((3652 + 177) > (11043 - 7274)) and v74) then
									return "Shadowmeld Macro " .. v74;
								end
							end
							break;
						end
						if (((1118 + 367) <= (2982 - (23 + 55))) and (v200 == (0 - 0))) then
							if (((2849 + 1420) == (3834 + 435)) and v36.Vanish:IsCastable()) then
								if (((599 - 212) <= (876 + 1906)) and ((v82 > (902 - (652 + 249))) or (v13:BuffUp(v36.ShadowBlades) and v36.InvigoratingShadowdust:IsAvailable())) and not v91() and ((v36.Flagellation:CooldownRemains() >= (160 - 100)) or not v36.Flagellation:IsAvailable() or v10.BossFilteredFightRemains("<=", (1898 - (708 + 1160)) * v36.Vanish:Charges())) and ((v36.SymbolsofDeath:CooldownRemains() > (8 - 5)) or not v13:HasTier(54 - 24, 29 - (10 + 17))) and ((v36.SecretTechnique:CooldownRemains() >= (3 + 7)) or not v36.SecretTechnique:IsAvailable() or ((v36.Vanish:Charges() >= (1734 - (1400 + 332))) and v36.InvigoratingShadowdust:IsAvailable() and (v13:BuffUp(v36.TheRotten) or not v36.TheRotten:IsAvailable())))) then
									local v216 = 0 - 0;
									while true do
										if ((v216 == (1908 - (242 + 1666))) or ((813 + 1086) <= (337 + 580))) then
											v74 = v102(v36.Vanish, v152);
											if (v74 or ((3675 + 637) <= (1816 - (850 + 90)))) then
												return "Vanish Macro " .. v74;
											end
											break;
										end
									end
								end
							end
							if (((3908 - 1676) <= (3986 - (360 + 1030))) and v51 and v49 and (v13:Energy() < (36 + 4)) and v36.Shadowmeld:IsCastable()) then
								if (((5912 - 3817) < (5070 - 1384)) and v23(v36.Shadowmeld, v13:EnergyTimeToX(1701 - (909 + 752)))) then
									return "Pool for Shadowmeld";
								end
							end
							v200 = 1224 - (109 + 1114);
						end
					end
				end
				if ((v68 and v36.ShadowDance:IsCastable()) or ((2920 - 1325) >= (1742 + 2732))) then
					if (((v14:DebuffUp(v36.Rupture) or v36.InvigoratingShadowdust:IsAvailable()) and v96() and (not v36.TheFirstDance:IsAvailable() or (v82 >= (246 - (6 + 236))) or v13:BuffUp(v36.ShadowBlades)) and ((v92() and v91()) or ((v13:BuffUp(v36.ShadowBlades) or (v13:BuffUp(v36.SymbolsofDeath) and not v36.Sepsis:IsAvailable()) or ((v13:BuffRemains(v36.SymbolsofDeath) >= (3 + 1)) and not v13:HasTier(25 + 5, 4 - 2)) or (not v13:BuffUp(v36.SymbolsofDeath) and v13:HasTier(52 - 22, 1135 - (1076 + 57)))) and (v36.SecretTechnique:CooldownRemains() < (2 + 8 + ((701 - (579 + 110)) * v26(not v36.InvigoratingShadowdust:IsAvailable() or v13:HasTier(3 + 27, 2 + 0)))))))) or ((2452 + 2167) < (3289 - (174 + 233)))) then
						v74 = v102(v36.ShadowDance, v152);
						if (v74 or ((821 - 527) >= (8479 - 3648))) then
							return "ShadowDance Macro 1 " .. v74;
						end
					end
				end
				v153 = 1 + 0;
			end
		end
	end
	local function v105(v154)
		local v155 = 1174 - (663 + 511);
		local v156;
		while true do
			if (((1811 + 218) <= (670 + 2414)) and (v155 == (0 - 0))) then
				v156 = not v154 or (v13:EnergyPredicted() >= v154);
				if ((v40 and v36.ShurikenStorm:IsCastable() and (v72 >= (2 + 0 + v19((v36.Gloomblade:IsAvailable() and (v13:BuffRemains(v36.LingeringShadowBuff) >= (13 - 7))) or v13:BuffUp(v36.PerforatedVeinsBuff))))) or ((4930 - 2893) == (1155 + 1265))) then
					local v201 = 0 - 0;
					while true do
						if (((3178 + 1280) > (357 + 3547)) and (v201 == (722 - (478 + 244)))) then
							if (((953 - (440 + 77)) >= (56 + 67)) and v156 and v20(v36.ShurikenStorm)) then
								return "Cast Shuriken Storm";
							end
							v85(v36.ShurikenStorm, v154);
							break;
						end
					end
				end
				v155 = 3 - 2;
			end
			if (((2056 - (655 + 901)) < (337 + 1479)) and (v155 == (1 + 0))) then
				if (((2414 + 1160) == (14398 - 10824)) and v68) then
					if (((1666 - (695 + 750)) < (1331 - 941)) and v36.Gloomblade:IsCastable()) then
						if ((v156 and v20(v36.Gloomblade)) or ((3414 - 1201) <= (5714 - 4293))) then
							return "Cast Gloomblade";
						end
						v85(v36.Gloomblade, v154);
					elseif (((3409 - (285 + 66)) < (11329 - 6469)) and v36.Backstab:IsCastable()) then
						if ((v156 and v20(v36.Backstab)) or ((2606 - (682 + 628)) >= (717 + 3729))) then
							return "Cast Backstab";
						end
						v85(v36.Backstab, v154);
					end
				end
				return false;
			end
		end
	end
	local v106 = {{v36.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v36.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v81 > (315 - (306 + 9));
	end},{v36.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v13:StealthUp(true, true);
	end}};
	local function v107()
		v43 = EpicSettings.Settings['BurnShadowDance'];
		v44 = EpicSettings.Settings['UsePriorityRotation'];
		v45 = EpicSettings.Settings['RangedMultiDoT'];
		v46 = EpicSettings.Settings['StealthMacroVanish'];
		v47 = EpicSettings.Settings['StealthMacroShadowmeld'];
		v48 = EpicSettings.Settings['StealthMacroShadowDance'];
		v49 = EpicSettings.Settings['PoolForShadowmeld'];
		v50 = EpicSettings.Settings['EviscerateDMGOffset'] or (2 - 1);
		v51 = EpicSettings.Settings['UseRacials'];
		v52 = EpicSettings.Settings['UseHealingPotion'];
		v53 = EpicSettings.Settings['HealingPotionName'];
		v54 = EpicSettings.Settings['HealingPotionHP'] or (1376 - (1140 + 235));
		v55 = EpicSettings.Settings['DispelBuffs'];
		v56 = EpicSettings.Settings['UseHealthstone'];
		v57 = EpicSettings.Settings['HealthstoneHP'] or (1 + 0);
		v58 = EpicSettings.Settings['InterruptWithStun'];
		v59 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v60 = EpicSettings.Settings['InterruptThreshold'];
		v61 = EpicSettings.Settings['AutoFocusTank'];
		v62 = EpicSettings.Settings['AutoTricksTank'];
		v63 = EpicSettings.Settings['UsageStealthOOC'];
		v64 = EpicSettings.Settings['StealthRange'] or (0 + 0);
	end
	local function v108()
		v107();
		v39 = EpicSettings.Toggles['ooc'];
		v40 = EpicSettings.Toggles['aoe'];
		v41 = EpicSettings.Toggles['cds'];
		v42 = EpicSettings.Toggles['dispel'];
		v75 = nil;
		v77 = nil;
		v76 = 0 + 0;
		v66 = (v36.AcrobaticStrikes:IsAvailable() and (60 - (33 + 19))) or (2 + 3);
		v67 = (v36.AcrobaticStrikes:IsAvailable() and (38 - 25)) or (5 + 5);
		v68 = v14:IsInMeleeRange(v66);
		v69 = v14:IsInMeleeRange(v67);
		if (v40 or ((2731 - 1338) > (4210 + 279))) then
			v70 = v13:GetEnemiesInRange(719 - (586 + 103));
			v71 = v13:GetEnemiesInMeleeRange(v67);
			v72 = #v71;
			v73 = v13:GetEnemiesInMeleeRange(v66);
		else
			v70 = {};
			v71 = {};
			v72 = 1 + 0;
			v73 = {};
		end
		v81 = v13:ComboPoints();
		v80 = v34.EffectiveComboPoints(v81);
		v82 = v13:ComboPointsDeficit();
		v84 = v88();
		v83 = v13:EnergyMax() - v90();
		if ((v13:BuffUp(v36.ShurikenTornado, nil, true) and (v81 < v34.CPMaxSpend())) or ((13619 - 9195) < (1515 - (1309 + 179)))) then
			local v188 = v34.TimeToNextTornado();
			if ((v188 <= v13:GCDRemains()) or (v32(v13:GCDRemains() - v188) < (0.25 - 0)) or ((870 + 1127) > (10245 - 6430))) then
				local v197 = 0 + 0;
				local v198;
				while true do
					if (((7362 - 3897) > (3811 - 1898)) and ((610 - (295 + 314)) == v197)) then
						v82 = v31(v82 - v198, 0 - 0);
						if (((2695 - (1300 + 662)) < (5711 - 3892)) and (v80 < v34.CPMaxSpend())) then
							v80 = v81;
						end
						break;
					end
					if ((v197 == (1755 - (1178 + 577))) or ((2283 + 2112) == (14056 - 9301))) then
						v198 = v72 + v26(v13:BuffUp(v36.ShadowBlades));
						v81 = v30(v81 + v198, v34.CPMaxSpend());
						v197 = 1406 - (851 + 554);
					end
				end
			end
		end
		v78 = (4 + 0 + (v80 * (10 - 6))) * (0.3 - 0);
		v79 = v36.Eviscerate:Damage() * v50;
		if ((not v13:AffectingCombat() and v61) or ((4095 - (115 + 187)) < (1815 + 554))) then
			local v189 = 0 + 0;
			local v190;
			while true do
				if ((v189 == (0 - 0)) or ((5245 - (160 + 1001)) == (232 + 33))) then
					v190 = v33.FocusUnit(false, nil, nil, "TANK", 14 + 6, v36.TricksoftheTrade);
					if (((8921 - 4563) == (4716 - (237 + 121))) and v190) then
						return v190;
					end
					break;
				end
			end
		end
		if ((v15 and v62 and (v33.UnitGroupRole(v15) == "TANK") and v36.TricksoftheTrade:IsCastable()) or ((4035 - (525 + 372)) < (1881 - 888))) then
			if (((10941 - 7611) > (2465 - (96 + 46))) and v21(v38.TricksoftheTradeFocus)) then
				return "tricks of the trade tank";
			end
		end
		v74 = v34.CrimsonVial();
		if (v74 or ((4403 - (643 + 134)) == (1441 + 2548))) then
			return v74;
		end
		v74 = v34.Feint();
		if (v74 or ((2196 - 1280) == (9916 - 7245))) then
			return v74;
		end
		v34.Poisons();
		if (((261 + 11) == (533 - 261)) and not v13:AffectingCombat() and v39) then
			if (((8685 - 4436) <= (5558 - (316 + 403))) and v36.Stealth:IsCastable() and (v63 == "Always")) then
				v74 = v34.Stealth(v34.StealthSpell());
				if (((1846 + 931) < (8798 - 5598)) and v74) then
					return v74;
				end
			elseif (((35 + 60) < (4928 - 2971)) and v36.Stealth:IsCastable() and (v63 == "Distance") and v14:IsInRange(v64)) then
				v74 = v34.Stealth(v34.StealthSpell());
				if (((586 + 240) < (554 + 1163)) and v74) then
					return v74;
				end
			end
			if (((4940 - 3514) >= (5277 - 4172)) and not v13:BuffUp(v36.ShadowDanceBuff) and not v13:BuffUp(v34.VanishBuffSpell())) then
				v74 = v34.Stealth(v34.StealthSpell());
				if (((5720 - 2966) <= (194 + 3185)) and v74) then
					return v74;
				end
			end
			if ((v33.TargetIsValid() and (v14:IsSpellInRange(v36.Shadowstrike) or v68)) or ((7730 - 3803) == (70 + 1343))) then
				if (v13:StealthUp(true, true) or ((3395 - 2241) <= (805 - (12 + 5)))) then
					local v203 = 0 - 0;
					while true do
						if (((0 - 0) == v203) or ((3492 - 1849) > (8379 - 5000))) then
							v75 = v101(true);
							if (v75 or ((569 + 2234) > (6522 - (1656 + 317)))) then
								if (((type(v75) == "table") and (#v75 > (1 + 0))) or ((177 + 43) >= (8035 - 5013))) then
									if (((13888 - 11066) == (3176 - (5 + 349))) and v25(nil, unpack(v75))) then
										return "Stealthed Macro Cast or Pool (OOC): " .. v75[4 - 3]:Name();
									end
								elseif (v23(v75) or ((2332 - (266 + 1005)) == (1224 + 633))) then
									return "Stealthed Cast or Pool (OOC): " .. v75:Name();
								end
							end
							break;
						end
					end
				elseif (((9417 - 6657) > (1795 - 431)) and (v81 >= (1701 - (561 + 1135)))) then
					v74 = v100();
					if (v74 or ((6387 - 1485) <= (11817 - 8222))) then
						return v74 .. " (OOC)";
					end
				elseif (v36.Backstab:IsCastable() or ((4918 - (507 + 559)) == (735 - 442))) then
					if (v20(v36.Backstab) or ((4821 - 3262) == (4976 - (212 + 176)))) then
						return "Cast Backstab (OOC)";
					end
				end
			end
			return;
		end
		if (v33.TargetIsValid() or ((5389 - (250 + 655)) == (2148 - 1360))) then
			local v191 = 0 - 0;
			local v192;
			while true do
				if (((7146 - 2578) >= (5863 - (1869 + 87))) and (v191 == (6 - 4))) then
					v192 = nil;
					if (((3147 - (484 + 1417)) < (7437 - 3967)) and (not v36.Vigor:IsAvailable() or v36.Shadowcraft:IsAvailable())) then
						v192 = v13:EnergyDeficitPredicted() <= v90();
					else
						v192 = v13:EnergyPredicted() >= v90();
					end
					if (((6817 - 2749) >= (1745 - (48 + 725))) and (v192 or v36.InvigoratingShadowdust:IsAvailable())) then
						local v207 = 0 - 0;
						while true do
							if (((1322 - 829) < (2263 + 1630)) and (v207 == (0 - 0))) then
								v74 = v104(v83);
								if (v74 or ((413 + 1060) >= (972 + 2360))) then
									return "Stealth CDs: " .. v74;
								end
								break;
							end
						end
					end
					if ((v80 >= v34.CPMaxSpend()) or ((4904 - (152 + 701)) <= (2468 - (430 + 881)))) then
						local v208 = 0 + 0;
						while true do
							if (((1499 - (557 + 338)) < (852 + 2029)) and (v208 == (0 - 0))) then
								v74 = v100();
								if (v74 or ((3151 - 2251) == (8971 - 5594))) then
									return "Finish: " .. v74;
								end
								break;
							end
						end
					end
					v191 = 6 - 3;
				end
				if (((5260 - (499 + 302)) > (1457 - (39 + 827))) and (v191 == (10 - 6))) then
					if (((7588 - 4190) >= (9512 - 7117)) and v74) then
						return "Build: " .. v74;
					end
					if (v41 or ((3350 - 1167) >= (242 + 2582))) then
						if (((5666 - 3730) == (310 + 1626)) and v36.ArcaneTorrent:IsReady() and v68 and (v13:EnergyDeficitPredicted() >= ((23 - 8) + v13:EnergyRegen())) and v51) then
							if (v20(v36.ArcaneTorrent, nil) or ((4936 - (103 + 1)) < (4867 - (475 + 79)))) then
								return "Cast Arcane Torrent";
							end
						end
						if (((8837 - 4749) > (12396 - 8522)) and v36.ArcanePulse:IsReady() and v68 and v51) then
							if (((560 + 3772) == (3813 + 519)) and v20(v36.ArcanePulse, nil)) then
								return "Cast Arcane Pulse";
							end
						end
						if (((5502 - (1395 + 108)) >= (8439 - 5539)) and v36.BagofTricks:IsReady() and v51) then
							if (v20(v36.BagofTricks, nil) or ((3729 - (7 + 1197)) > (1772 + 2292))) then
								return "Cast Bag of Tricks";
							end
						end
					end
					if (((1526 + 2845) == (4690 - (27 + 292))) and v75 and v68) then
						if (((type(v75) == "table") and (#v75 > (2 - 1))) or ((339 - 73) > (20910 - 15924))) then
							if (((3926 - 1935) >= (1761 - 836)) and v25(v13:EnergyTimeToX(v76), unpack(v75))) then
								return "Macro pool towards " .. v75[140 - (43 + 96)]:Name() .. " at " .. v76;
							end
						elseif (((1856 - 1401) < (4641 - 2588)) and v75:IsCastable()) then
							local v215 = 0 + 0;
							while true do
								if ((v215 == (0 + 0)) or ((1632 - 806) == (1860 + 2991))) then
									v76 = v31(v76, v75:Cost());
									if (((342 - 159) == (58 + 125)) and v23(v75, v13:EnergyTimeToX(v76))) then
										return "Pool towards: " .. v75:Name() .. " at " .. v76;
									end
									break;
								end
							end
						end
					end
					if (((85 + 1074) <= (3539 - (1414 + 337))) and v36.ShurikenToss:IsCastable() and v14:IsInRange(1970 - (1642 + 298)) and not v69 and not v13:StealthUp(true, true) and not v13:BuffUp(v36.Sprint) and (v13:EnergyDeficitPredicted() < (52 - 32)) and ((v82 >= (2 - 1)) or (v13:EnergyTimeToMax() <= (2.2 - 1)))) then
						if (v23(v36.ShurikenToss) or ((1155 + 2352) > (3360 + 958))) then
							return "Cast Shuriken Toss";
						end
					end
					break;
				end
				if ((v191 == (975 - (357 + 615))) or ((2159 + 916) <= (7274 - 4309))) then
					if (((1170 + 195) <= (4309 - 2298)) and ((v82 <= (1 + 0)) or (v10.BossFilteredFightRemains("<=", 1 + 0) and (v80 >= (2 + 1))))) then
						local v209 = 1301 - (384 + 917);
						while true do
							if ((v209 == (697 - (128 + 569))) or ((4319 - (1407 + 136)) > (5462 - (687 + 1200)))) then
								v74 = v100();
								if (v74 or ((4264 - (556 + 1154)) == (16900 - 12096))) then
									return "Finish: " .. v74;
								end
								break;
							end
						end
					end
					if (((2672 - (9 + 86)) == (2998 - (275 + 146))) and (v72 >= (1 + 3)) and (v80 >= (68 - (29 + 35)))) then
						v74 = v100();
						if (v74 or ((26 - 20) >= (5641 - 3752))) then
							return "Finish: " .. v74;
						end
					end
					if (((2233 - 1727) <= (1233 + 659)) and v77) then
						v85(v77);
					end
					v74 = v105(v83);
					v191 = 1016 - (53 + 959);
				end
				if ((v191 == (408 - (312 + 96))) or ((3484 - 1476) > (2503 - (147 + 138)))) then
					if (((1278 - (813 + 86)) <= (3748 + 399)) and not v13:IsCasting() and not v13:IsChanneling()) then
						local v210 = v33.Interrupt(v36.Kick, 14 - 6, true);
						if (v210 or ((5006 - (18 + 474)) <= (341 + 668))) then
							return v210;
						end
						v210 = v33.Interrupt(v36.Kick, 25 - 17, true, MouseOver, v38.KickMouseover);
						if (v210 or ((4582 - (860 + 226)) == (1495 - (121 + 182)))) then
							return v210;
						end
						v210 = v33.Interrupt(v36.Blind, 2 + 13, BlindInterrupt);
						if (v210 or ((1448 - (988 + 252)) == (335 + 2624))) then
							return v210;
						end
						v210 = v33.Interrupt(v36.Blind, 5 + 10, BlindInterrupt, MouseOver, v38.BlindMouseover);
						if (((6247 - (49 + 1921)) >= (2203 - (223 + 667))) and v210) then
							return v210;
						end
						v210 = v33.InterruptWithStun(v36.CheapShot, 60 - (51 + 1), v13:StealthUp(false, false));
						if (((4452 - 1865) < (6796 - 3622)) and v210) then
							return v210;
						end
						v210 = v33.InterruptWithStun(v36.KidneyShot, 1133 - (146 + 979), v13:ComboPoints() > (0 + 0));
						if (v210 or ((4725 - (311 + 294)) <= (6129 - 3931))) then
							return v210;
						end
					end
					if ((v55 and v42 and v36.Shiv:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v33.UnitHasEnrageBuff(v14)) or ((677 + 919) == (2301 - (496 + 947)))) then
						if (((4578 - (1233 + 125)) == (1307 + 1913)) and v21(v36.Shiv, not v68)) then
							return "shiv dispel enrage";
						end
					end
					if ((v37.Healthstone:IsReady() and v56 and (v13:HealthPercentage() <= v57)) or ((1258 + 144) > (688 + 2932))) then
						if (((4219 - (963 + 682)) == (2149 + 425)) and v21(v38.Healthstone, nil, nil, true)) then
							return "healthstone defensive 3";
						end
					end
					if (((3302 - (504 + 1000)) < (1857 + 900)) and v52 and (v13:HealthPercentage() <= v54)) then
						local v211 = 0 + 0;
						while true do
							if ((v211 == (0 + 0)) or ((555 - 178) > (2225 + 379))) then
								if (((331 + 237) < (1093 - (156 + 26))) and (v53 == "Refreshing Healing Potion")) then
									if (((1893 + 1392) < (6614 - 2386)) and v37.RefreshingHealingPotion:IsReady()) then
										if (((4080 - (149 + 15)) > (4288 - (890 + 70))) and v21(v38.RefreshingHealingPotion, nil, nil, true)) then
											return "refreshing healing potion defensive 4";
										end
									end
								end
								if (((2617 - (39 + 78)) < (4321 - (14 + 468))) and (v53 == "Dreamwalker's Healing Potion")) then
									if (((1114 - 607) == (1417 - 910)) and v37.DreamwalkersHealingPotion:IsReady()) then
										if (((124 + 116) <= (1901 + 1264)) and v21(v38.RefreshingHealingPotion, nil, nil, true)) then
											return "dreamwalker's healing potion defensive 4";
										end
									end
								end
								break;
							end
						end
					end
					v191 = 1 + 0;
				end
				if (((377 + 457) >= (211 + 594)) and (v191 == (1 - 0))) then
					v74 = v103();
					if (v74 or ((3768 + 44) < (8138 - 5822))) then
						return "CDs: " .. v74;
					end
					if ((v36.SliceandDice:IsCastable() and (v72 < v34.CPMaxSpend()) and (v13:BuffRemains(v36.SliceandDice) < v13:GCD()) and v10.BossFilteredFightRemains(">", 1 + 5) and (v81 >= (55 - (12 + 39)))) or ((2468 + 184) <= (4745 - 3212))) then
						if ((v36.SliceandDice:IsReady() and v20(v36.SliceandDice)) or ((12814 - 9216) < (433 + 1027))) then
							return "Cast Slice and Dice (Low Duration)";
						end
						v86(v36.SliceandDice);
					end
					if (v13:StealthUp(true, true) or ((2167 + 1949) < (3022 - 1830))) then
						v75 = v101(true);
						if (v75 or ((2250 + 1127) <= (4363 - 3460))) then
							if (((5686 - (1596 + 114)) >= (1145 - 706)) and (type(v75) == "table") and (#v75 > (714 - (164 + 549)))) then
								if (((5190 - (1059 + 379)) == (4658 - 906)) and v25(nil, unpack(v75))) then
									return "Stealthed Macro " .. v75[1 + 0]:Name() .. "|" .. v75[1 + 1]:Name();
								end
							elseif (((4438 - (145 + 247)) > (2212 + 483)) and v13:BuffUp(v36.ShurikenTornado) and (v81 ~= v13:ComboPoints()) and ((v75 == v36.BlackPowder) or (v75 == v36.Eviscerate) or (v75 == v36.Rupture) or (v75 == v36.SliceandDice))) then
								if (v25(nil, v36.ShurikenTornado, v75) or ((1639 + 1906) == (9478 - 6281))) then
									return "Stealthed Tornado Cast  " .. v75:Name();
								end
							elseif (((460 + 1934) > (322 + 51)) and (type(v75) ~= "boolean")) then
								if (((6746 - 2591) <= (4952 - (254 + 466))) and v23(v75)) then
									return "Stealthed Cast " .. v75:Name();
								end
							end
						end
						v20(v36.PoolEnergy);
						return "Stealthed Pooling";
					end
					v191 = 562 - (544 + 16);
				end
			end
		end
	end
	local function v109()
		local v179 = 0 - 0;
		while true do
			if ((v179 == (628 - (294 + 334))) or ((3834 - (236 + 17)) == (1498 + 1975))) then
				v10.Print("Subtlety Rogue by Epic BoomK");
				EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.00 By BoomK");
				break;
			end
		end
	end
	v10.SetAPL(204 + 57, v108, v109);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

