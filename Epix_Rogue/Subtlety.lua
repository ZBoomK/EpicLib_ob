local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1952 + 2679) == (1205 + 843))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Rogue_Subtlety.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Target;
	local v14 = v9.Spell;
	local v15 = v9.MultiSpell;
	local v16 = v9.Item;
	local v17 = v9.Utils.BoolToInt;
	local v18 = v9.Cast;
	local v19 = v9.CastLeftNameplate;
	local v20 = v9.CastPooling;
	local v21 = v9.CastQueue;
	local v22 = v9.CastQueuePooling;
	local v23 = v9.Commons.Everyone.num;
	local v24 = v9.Commons.Everyone.bool;
	local v25 = pairs;
	local v26 = table.insert;
	local v27 = math.min;
	local v28 = math.max;
	local v29 = math.abs;
	local v30 = v9.Commons.Everyone;
	local v31 = v9.Commons.Rogue;
	local v32 = v9.Macro;
	local v33 = v14.Rogue.Subtlety;
	local v34 = v16.Rogue.Subtlety;
	local v35 = v32.Rogue.Subtlety;
	local v36 = false;
	local v37 = false;
	local v38 = false;
	local v39 = false;
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
	local v62 = {v34.Mirror:ID(),v34.WitherbarksBranch:ID(),v34.AshesoftheEmbersoul:ID()};
	local v63, v64, v65, v66;
	local v67, v68, v69, v70;
	local v71;
	local v72, v73, v74;
	local v75, v76;
	local v77, v78, v79, v80;
	local v81;
	v33.Eviscerate:RegisterDamageFormula(function()
		return v12:AttackPowerDamageMod() * v77 * (667.176 - (89 + 578)) * (1.21 + 0) * ((v33.Nightstalker:IsAvailable() and v12:StealthUp(true, false) and (1.08 - 0)) or (1050 - (572 + 477))) * ((v33.DeeperStratagem:IsAvailable() and (1.05 + 0)) or (1 + 0)) * ((v33.DarkShadow:IsAvailable() and v12:BuffUp(v33.ShadowDanceBuff) and (1.3 + 0)) or (87 - (84 + 2))) * ((v12:BuffUp(v33.SymbolsofDeath) and (1.1 - 0)) or (1 + 0)) * ((v12:BuffUp(v33.FinalityEviscerateBuff) and (843.3 - (497 + 345))) or (1 + 0)) * (1 + 0 + (v12:MasteryPct() / (1433 - (605 + 728)))) * (1 + 0 + (v12:VersatilityDmgPct() / (222 - 122))) * ((v13:DebuffUp(v33.FindWeaknessDebuff) and (1.5 + 0)) or (3 - 2));
	end);
	local function v82(v107, v108)
		if (not v72 or ((3529 + 385) == (6025 - 3850))) then
			v72 = v107;
			v73 = v108 or (0 + 0);
		end
	end
	local function v83(v109)
		if (not v74 or ((5271 - (457 + 32)) < (509 + 690))) then
			v74 = v109;
		end
	end
	local function v84()
		if (((v40 == "On Bosses not in Dungeons") and v12:IsInDungeonArea()) or ((6266 - (832 + 570)) < (1792 + 110))) then
			return false;
		elseif (((1262 + 3577) >= (13093 - 9393)) and (v40 ~= "Always") and not v13:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v85()
		if ((v69 < (1 + 1)) or ((1871 - (588 + 208)) > (5169 - 3251))) then
			return false;
		elseif (((2196 - (884 + 916)) <= (7963 - 4159)) and (v41 == "Always")) then
			return true;
		elseif (((v41 == "On Bosses") and v13:IsInBossList()) or ((2418 + 1751) == (2840 - (232 + 421)))) then
			return true;
		elseif (((3295 - (1569 + 320)) == (345 + 1061)) and (v41 == "Auto")) then
			if (((291 + 1240) < (14392 - 10121)) and (v12:InstanceDifficulty() == (621 - (316 + 289))) and (v13:NPCID() == (363776 - 224809))) then
				return true;
			elseif (((30 + 605) == (2088 - (666 + 787))) and ((v13:NPCID() == (167394 - (360 + 65))) or (v13:NPCID() == (156046 + 10925)) or (v13:NPCID() == (167224 - (79 + 175))))) then
				return true;
			elseif (((5318 - 1945) <= (2775 + 781)) and ((v13:NPCID() == (562364 - 378901)) or (v13:NPCID() == (353724 - 170053)))) then
				return true;
			end
		end
		return false;
	end
	local function v86(v110, v111, v112, v113)
		local v114 = 899 - (503 + 396);
		local v115;
		local v116;
		local v117;
		while true do
			if ((v114 == (181 - (92 + 89))) or ((6384 - 3093) < (1683 + 1597))) then
				v115, v116 = nil, v112;
				v117 = v13:GUID();
				v114 = 1 + 0;
			end
			if (((17176 - 12790) >= (120 + 753)) and (v114 == (2 - 1))) then
				for v187, v188 in v25(v113) do
					if (((804 + 117) <= (527 + 575)) and (v188:GUID() ~= v117) and v30.UnitIsCycleValid(v188, v116, -v188:DebuffRemains(v110)) and v111(v188)) then
						v115, v116 = v188, v188:TimeToDie();
					end
				end
				if (((14332 - 9626) >= (121 + 842)) and v115 and (v13:GUID() == v115:GUID())) then
					v9.Press(v110);
				elseif (v42 or ((1464 - 504) <= (2120 - (485 + 759)))) then
					local v196 = 0 - 0;
					while true do
						if (((1190 - (442 + 747)) == v196) or ((3201 - (832 + 303)) == (1878 - (88 + 858)))) then
							if (((1471 + 3354) < (4009 + 834)) and v115 and (v13:GUID() == v115:GUID())) then
								v9.Press(v110);
							end
							break;
						end
						if ((v196 == (0 + 0)) or ((4666 - (766 + 23)) >= (22397 - 17860))) then
							v115, v116 = nil, v112;
							for v210, v211 in v25(v68) do
								if (((v211:GUID() ~= v117) and v30.UnitIsCycleValid(v211, v116, -v211:DebuffRemains(v110)) and v111(v211)) or ((5900 - 1585) < (4547 - 2821))) then
									v115, v116 = v211, v211:TimeToDie();
								end
							end
							v196 = 3 - 2;
						end
					end
				end
				break;
			end
		end
	end
	local function v87()
		return (1093 - (1036 + 37)) + (v33.Vigor:TalentRank() * (18 + 7)) + (v23(v33.ThistleTea:IsAvailable()) * (38 - 18)) + (v23(v33.Shadowcraft:IsAvailable()) * (16 + 4));
	end
	local function v88()
		return v33.ShadowDance:ChargesFractional() >= ((1480.75 - (641 + 839)) + v17(v33.ShadowDanceTalent:IsAvailable()));
	end
	local function v89()
		return v79 >= (916 - (910 + 3));
	end
	local function v90()
		return v12:BuffUp(v33.SliceandDice) or (v69 >= v31.CPMaxSpend());
	end
	local function v91()
		return v33.Premeditation:IsAvailable() and (v69 < (12 - 7));
	end
	local function v92(v118)
		return (v12:BuffUp(v33.ThistleTea) and (v69 == (1685 - (1466 + 218)))) or (v118 and ((v69 == (1 + 0)) or (v13:DebuffUp(v33.Rupture) and (v69 >= (1150 - (556 + 592))))));
	end
	local function v93()
		return (not v12:BuffUp(v33.TheRotten) or not v12:HasTier(11 + 19, 810 - (329 + 479))) and (not v33.ColdBlood:IsAvailable() or (v33.ColdBlood:CooldownRemains() < (858 - (174 + 680))) or (v33.ColdBlood:CooldownRemains() > (34 - 24)));
	end
	local function v94(v119)
		return v12:BuffUp(v33.ShadowDanceBuff) and (v119:TimeSinceLastCast() < v33.ShadowDance:TimeSinceLastCast());
	end
	local function v95()
		return ((v94(v33.Shadowstrike) or v94(v33.ShurikenStorm)) and (v94(v33.Eviscerate) or v94(v33.BlackPowder) or v94(v33.Rupture))) or not v33.DanseMacabre:IsAvailable();
	end
	local function v96()
		return (not v34.WitherbarksBranch:IsEquipped() and not v34.AshesoftheEmbersoul:IsEquipped()) or (not v34.WitherbarksBranch:IsEquipped() and (v34.WitherbarksBranch:CooldownRemains() <= (16 - 8))) or (v34.WitherbarksBranch:IsEquipped() and (v34.WitherbarksBranch:CooldownRemains() <= (6 + 2))) or v34.BandolierOfTwistedBlades:IsEquipped() or v33.InvigoratingShadowdust:IsAvailable();
	end
	local function v97(v120, v121)
		local v122 = v12:BuffUp(v33.ShadowDanceBuff);
		local v123 = v12:BuffRemains(v33.ShadowDanceBuff);
		local v124 = v12:BuffRemains(v33.SymbolsofDeath);
		local v125 = v78;
		local v126 = v33.ColdBlood:CooldownRemains();
		local v127 = v33.SymbolsofDeath:CooldownRemains();
		local v128 = v12:BuffUp(v33.PremeditationBuff) or (v121 and v33.Premeditation:IsAvailable());
		if ((v121 and (v121:ID() == v33.ShadowDance:ID())) or ((4418 - (396 + 343)) < (56 + 569))) then
			local v178 = 1477 - (29 + 1448);
			while true do
				if ((v178 == (1390 - (135 + 1254))) or ((17423 - 12798) < (2950 - 2318))) then
					if (v33.TheFirstDance:IsAvailable() or ((56 + 27) > (3307 - (389 + 1138)))) then
						v125 = v27(v12:ComboPointsMax(), v78 + (578 - (102 + 472)));
					end
					if (((516 + 30) <= (598 + 479)) and v12:HasTier(28 + 2, 1547 - (320 + 1225))) then
						v124 = v28(v124, 10 - 4);
					end
					break;
				end
				if ((v178 == (0 + 0)) or ((2460 - (157 + 1307)) > (6160 - (821 + 1038)))) then
					v122 = true;
					v123 = (19 - 11) + v33.ImprovedShadowDance:TalentRank();
					v178 = 1 + 0;
				end
			end
		end
		if (((7229 - 3159) > (256 + 431)) and v121 and (v121:ID() == v33.Vanish:ID())) then
			v126 = v27(0 - 0, v33.ColdBlood:CooldownRemains() - ((1041 - (834 + 192)) * v33.InvigoratingShadowdust:TalentRank()));
			v127 = v27(0 + 0, v33.SymbolsofDeath:CooldownRemains() - ((4 + 11) * v33.InvigoratingShadowdust:TalentRank()));
		end
		if ((v33.Rupture:IsCastable() and v33.Rupture:IsReady()) or ((15 + 641) >= (5158 - 1828))) then
			if ((v13:DebuffDown(v33.Rupture) and (v13:TimeToDie() > (310 - (300 + 4)))) or ((666 + 1826) <= (876 - 541))) then
				if (((4684 - (112 + 250)) >= (1022 + 1540)) and v120) then
					return v33.Rupture;
				else
					if ((v33.Rupture:IsReady() and v18(v33.Rupture)) or ((9111 - 5474) >= (2160 + 1610))) then
						return "Cast Rupture";
					end
					v83(v33.Rupture);
				end
			end
		end
		if ((not v12:StealthUp(true, true) and not v91() and (v69 < (4 + 2)) and not v122 and v9.BossFilteredFightRemains(">", v12:BuffRemains(v33.SliceandDice)) and (v12:BuffRemains(v33.SliceandDice) < ((1 + 0 + v12:ComboPoints()) * (1.8 + 0)))) or ((1768 + 611) > (5992 - (1001 + 413)))) then
			if (v120 or ((1076 - 593) > (1625 - (244 + 638)))) then
				return v33.SliceandDice;
			else
				local v189 = 693 - (627 + 66);
				while true do
					if (((7311 - 4857) > (1180 - (512 + 90))) and (v189 == (1906 - (1665 + 241)))) then
						if (((1647 - (373 + 344)) < (2011 + 2447)) and v33.SliceandDice:IsReady() and v18(v33.SliceandDice)) then
							return "Cast Slice and Dice Premed";
						end
						v83(v33.SliceandDice);
						break;
					end
				end
			end
		end
		if (((176 + 486) <= (2563 - 1591)) and (not v92(v122) or v81) and (v13:TimeToDie() > (9 - 3)) and v13:DebuffRefreshable(v33.Rupture, v75)) then
			if (((5469 - (35 + 1064)) == (3180 + 1190)) and v120) then
				return v33.Rupture;
			else
				if ((v33.Rupture:IsReady() and v18(v33.Rupture)) or ((10188 - 5426) <= (4 + 857))) then
					return "Cast Rupture";
				end
				v83(v33.Rupture);
			end
		end
		if ((v12:BuffUp(v33.FinalityRuptureBuff) and v122 and (v69 <= (1240 - (298 + 938))) and not v94(v33.Rupture)) or ((2671 - (233 + 1026)) == (5930 - (636 + 1030)))) then
			if (v120 or ((1620 + 1548) < (2103 + 50))) then
				return v33.Rupture;
			else
				if ((v33.Rupture:IsReady() and v18(v33.Rupture)) or ((1479 + 3497) < (90 + 1242))) then
					return "Cast Rupture Finality";
				end
				v83(v33.Rupture);
			end
		end
		if (((4849 - (55 + 166)) == (897 + 3731)) and v33.ColdBlood:IsReady() and v95(v122, v128) and v33.SecretTechnique:IsReady()) then
			local v179 = 0 + 0;
			while true do
				if ((v179 == (0 - 0)) or ((351 - (36 + 261)) == (690 - 295))) then
					if (((1450 - (34 + 1334)) == (32 + 50)) and v120) then
						return v33.ColdBlood;
					end
					if (v18(v33.ColdBlood) or ((452 + 129) < (1565 - (1035 + 248)))) then
						return "Cast Cold Blood (SecTec)";
					end
					break;
				end
			end
		end
		if (v33.SecretTechnique:IsReady() or ((4630 - (20 + 1)) < (1300 + 1195))) then
			if (((1471 - (134 + 185)) == (2285 - (549 + 584))) and v95(v122, v128) and (not v33.ColdBlood:IsAvailable() or v12:BuffUp(v33.ColdBlood) or (v126 > (v123 - (687 - (314 + 371)))) or not v33.ImprovedShadowDance:IsAvailable())) then
				local v190 = 0 - 0;
				while true do
					if (((2864 - (478 + 490)) <= (1813 + 1609)) and (v190 == (1172 - (786 + 386)))) then
						if (v120 or ((3206 - 2216) > (2999 - (1055 + 324)))) then
							return v33.SecretTechnique;
						end
						if (v18(v33.SecretTechnique) or ((2217 - (1093 + 247)) > (4173 + 522))) then
							return "Cast Secret Technique";
						end
						break;
					end
				end
			end
		end
		if (((283 + 2408) >= (7348 - 5497)) and not v92(v122) and v33.Rupture:IsCastable()) then
			local v180 = 0 - 0;
			while true do
				if ((v180 == (0 - 0)) or ((7501 - 4516) >= (1728 + 3128))) then
					if (((16472 - 12196) >= (4118 - 2923)) and not v120 and v37 and not v81 and (v69 >= (2 + 0))) then
						local v197 = 0 - 0;
						local v198;
						while true do
							if (((3920 - (364 + 324)) <= (12856 - 8166)) and (v197 == (2 - 1))) then
								v86(v33.Rupture, v198, (1 + 1) * v125, v70);
								break;
							end
							if (((0 - 0) == v197) or ((1434 - 538) >= (9554 - 6408))) then
								v198 = nil;
								function v198(v212)
									return v30.CanDoTUnit(v212, v76) and v212:DebuffRefreshable(v33.Rupture, v75);
								end
								v197 = 1269 - (1249 + 19);
							end
						end
					end
					if (((2763 + 298) >= (11513 - 8555)) and v65 and (v13:DebuffRemains(v33.Rupture) < (v127 + (1096 - (686 + 400)))) and (v127 <= (4 + 1)) and v31.CanDoTUnit(v13, v76) and v13:FilteredTimeToDie(">", (234 - (73 + 156)) + v127, -v13:DebuffRemains(v33.Rupture))) then
						if (((16 + 3171) >= (1455 - (721 + 90))) and v120) then
							return v33.Rupture;
						else
							if (((8 + 636) <= (2285 - 1581)) and v33.Rupture:IsReady() and v18(v33.Rupture)) then
								return "Cast Rupture 2";
							end
							v83(v33.Rupture);
						end
					end
					break;
				end
			end
		end
		if (((1428 - (224 + 246)) > (1533 - 586)) and v33.BlackPowder:IsCastable() and not v81 and (v69 >= (5 - 2))) then
			if (((815 + 3677) >= (64 + 2590)) and v120) then
				return v33.BlackPowder;
			else
				local v191 = 0 + 0;
				while true do
					if (((6842 - 3400) >= (5001 - 3498)) and (v191 == (513 - (203 + 310)))) then
						if ((v33.BlackPowder:IsReady() and v18(v33.BlackPowder)) or ((5163 - (1238 + 755)) <= (103 + 1361))) then
							return "Cast Black Powder";
						end
						v83(v33.BlackPowder);
						break;
					end
				end
			end
		end
		if ((v33.Eviscerate:IsCastable() and v65) or ((6331 - (709 + 825)) == (8085 - 3697))) then
			if (((802 - 251) <= (1545 - (196 + 668))) and v120) then
				return v33.Eviscerate;
			else
				if (((12938 - 9661) > (842 - 435)) and v33.Eviscerate:IsReady() and v18(v33.Eviscerate)) then
					return "Cast Eviscerate";
				end
				v83(v33.Eviscerate);
			end
		end
		return false;
	end
	local function v98(v129, v130)
		local v131 = 833 - (171 + 662);
		local v132;
		local v133;
		local v134;
		local v135;
		local v136;
		local v137;
		local v138;
		local v139;
		local v140;
		local v141;
		while true do
			if (((4788 - (4 + 89)) >= (4959 - 3544)) and (v131 == (2 + 3))) then
				if ((v33.Backstab:IsCastable() and not v137 and (v133 >= (13 - 10)) and v12:BuffUp(v33.ShadowBlades) and not v94(v33.Backstab) and v33.DanseMacabre:IsAvailable() and (v69 <= (2 + 1)) and not v134) or ((4698 - (35 + 1451)) <= (2397 - (28 + 1425)))) then
					if (v129 or ((5089 - (941 + 1052)) <= (1725 + 73))) then
						if (((5051 - (822 + 692)) == (5049 - 1512)) and v130) then
							return v33.Backstab;
						else
							return {v33.Backstab,v33.Stealth};
						end
					elseif (((3797 + 40) >= (541 + 1029)) and v21(v33.Backstab, v33.Stealth)) then
						return "Cast Backstab (Stealth)";
					end
				end
				if (v33.Gloomblade:IsAvailable() or ((7179 - 4229) == (4245 - (114 + 319)))) then
					if (((6780 - 2057) >= (2969 - 651)) and not v137 and (v133 >= (2 + 1)) and v12:BuffUp(v33.ShadowBlades) and not v94(v33.Gloomblade) and v33.DanseMacabre:IsAvailable() and (v69 <= (5 - 1))) then
						if (v129 or ((4247 - 2220) > (4815 - (556 + 1407)))) then
							if (v130 or ((2342 - (741 + 465)) > (4782 - (170 + 295)))) then
								return v33.Gloomblade;
							else
								return {v33.Gloomblade,v33.Stealth};
							end
						elseif (((11689 - 6941) == (3936 + 812)) and v21(v33.Gloomblade, v33.Stealth)) then
							return "Cast Gloomblade (Danse)";
						end
					end
				end
				if (((2396 + 1340) <= (2685 + 2055)) and not v94(v33.Shadowstrike) and v12:BuffUp(v33.ShadowBlades)) then
					if (v129 or ((4620 - (957 + 273)) <= (819 + 2241))) then
						return v33.Shadowstrike;
					elseif (v18(v33.Shadowstrike) or ((400 + 599) > (10261 - 7568))) then
						return "Cast Shadowstrike (Danse)";
					end
				end
				v131 = 15 - 9;
			end
			if (((1414 - 951) < (2975 - 2374)) and (v131 == (1782 - (389 + 1391)))) then
				v139 = v12:BuffUp(v31.VanishBuffSpell()) or (v130 and (v130:ID() == v33.Vanish:ID()));
				if ((v130 and (v130:ID() == v33.ShadowDance:ID())) or ((1370 + 813) < (72 + 615))) then
					v132 = true;
					v133 = (18 - 10) + v33.ImprovedShadowDance:TalentRank();
					if (((5500 - (783 + 168)) == (15267 - 10718)) and v33.TheRotten:IsAvailable() and v12:HasTier(30 + 0, 313 - (309 + 2))) then
						v134 = true;
					end
					if (((14346 - 9674) == (5884 - (1090 + 122))) and v33.TheFirstDance:IsAvailable()) then
						v135 = v27(v12:ComboPointsMax(), v78 + 2 + 2);
						v136 = v12:ComboPointsMax() - v135;
					end
				end
				v140 = v31.EffectiveComboPoints(v135);
				v131 = 9 - 6;
			end
			if (((0 + 0) == v131) or ((4786 - (628 + 490)) < (71 + 324))) then
				v132 = v12:BuffUp(v33.ShadowDanceBuff);
				v133 = v12:BuffRemains(v33.ShadowDanceBuff);
				v134 = v12:BuffUp(v33.TheRottenBuff);
				v131 = 2 - 1;
			end
			if ((v131 == (27 - 21)) or ((4940 - (431 + 343)) == (918 - 463))) then
				if ((not v137 and (v69 >= (11 - 7))) or ((3515 + 934) == (341 + 2322))) then
					if (v129 or ((5972 - (556 + 1139)) < (3004 - (6 + 9)))) then
						return v33.ShurikenStorm;
					elseif (v18(v33.ShurikenStorm) or ((160 + 710) >= (2126 + 2023))) then
						return "Cast Shuriken Storm";
					end
				end
				if (((2381 - (28 + 141)) < (1233 + 1950)) and v141) then
					if (((5734 - 1088) > (2120 + 872)) and v129) then
						return v33.Shadowstrike;
					elseif (((2751 - (486 + 831)) < (8082 - 4976)) and v18(v33.Shadowstrike)) then
						return "Cast Shadowstrike";
					end
				end
				return false;
			end
			if (((2767 - 1981) < (572 + 2451)) and (v131 == (9 - 6))) then
				v141 = v33.Shadowstrike:IsCastable() or v138 or v139 or v132 or v12:BuffUp(v33.SepsisBuff);
				if (v138 or v139 or ((3705 - (668 + 595)) < (67 + 7))) then
					v141 = v141 and v13:IsInRange(6 + 19);
				else
					v141 = v141 and v65;
				end
				if (((12367 - 7832) == (4825 - (23 + 267))) and v141 and v138 and ((v69 < (1948 - (1129 + 815))) or v81)) then
					if (v129 or ((3396 - (371 + 16)) <= (3855 - (1326 + 424)))) then
						return v33.Shadowstrike;
					elseif (((3465 - 1635) < (13407 - 9738)) and v18(v33.Shadowstrike)) then
						return "Cast Shadowstrike (Stealth)";
					end
				end
				v131 = 122 - (88 + 30);
			end
			if ((v131 == (775 - (720 + 51))) or ((3181 - 1751) >= (5388 - (421 + 1355)))) then
				if (((4426 - 1743) >= (1209 + 1251)) and (v140 >= v31.CPMaxSpend())) then
					return v97(v129, v130);
				end
				if ((v12:BuffUp(v33.ShurikenTornado) and (v136 <= (1085 - (286 + 797)))) or ((6594 - 4790) >= (5424 - 2149))) then
					return v97(v129, v130);
				end
				if ((v79 <= ((440 - (397 + 42)) + v23(v33.DeeperStratagem:IsAvailable() or v33.SecretStratagem:IsAvailable()))) or ((443 + 974) > (4429 - (24 + 776)))) then
					return v97(v129, v130);
				end
				v131 = 7 - 2;
			end
			if (((5580 - (222 + 563)) > (885 - 483)) and (v131 == (1 + 0))) then
				v135, v136 = v78, v79;
				v137 = v12:BuffUp(v33.PremeditationBuff) or (v130 and v33.Premeditation:IsAvailable());
				v138 = v12:BuffUp(v31.StealthSpell()) or (v130 and (v130:ID() == v31.StealthSpell():ID()));
				v131 = 192 - (23 + 167);
			end
		end
	end
	local function v99(v142, v143)
		local v144 = 1798 - (690 + 1108);
		local v145;
		local v146;
		while true do
			if (((1737 + 3076) > (2941 + 624)) and (v144 == (850 - (40 + 808)))) then
				v71 = v21(unpack(v146));
				if (((645 + 3267) == (14959 - 11047)) and v71) then
					return "| " .. v146[2 + 0]:Name();
				end
				v144 = 2 + 1;
			end
			if (((1547 + 1274) <= (5395 - (47 + 524))) and (v144 == (0 + 0))) then
				v145 = v98(true, v142);
				if (((4750 - 3012) <= (3282 - 1087)) and (v142:ID() == v33.Vanish:ID()) and (not v43 or not v145)) then
					local v193 = 0 - 0;
					while true do
						if (((1767 - (1165 + 561)) <= (90 + 2928)) and (v193 == (0 - 0))) then
							if (((819 + 1326) <= (4583 - (341 + 138))) and v18(v33.Vanish, nil)) then
								return "Cast Vanish";
							end
							return false;
						end
					end
				elseif (((726 + 1963) < (9998 - 5153)) and (v142:ID() == v33.Shadowmeld:ID()) and (not v44 or not v145)) then
					if (v18(v33.Shadowmeld, nil) or ((2648 - (89 + 237)) > (8434 - 5812))) then
						return "Cast Shadowmeld";
					end
					return false;
				elseif (((v142:ID() == v33.ShadowDance:ID()) and (not v45 or not v145)) or ((9545 - 5011) == (2963 - (581 + 300)))) then
					if (v18(v33.ShadowDance, nil) or ((2791 - (855 + 365)) > (4434 - 2567))) then
						return "Cast Shadow Dance";
					end
					return false;
				end
				v144 = 1 + 0;
			end
			if ((v144 == (1238 - (1030 + 205))) or ((2492 + 162) >= (2788 + 208))) then
				return false;
			end
			if (((4264 - (156 + 130)) > (4780 - 2676)) and (v144 == (1 - 0))) then
				v146 = {v142,v145};
				if (((1747 + 1248) > (1610 - (10 + 59))) and v143 and (v12:EnergyPredicted() < v143)) then
					v82(v146, v143);
					return false;
				end
				v144 = 1 + 1;
			end
		end
	end
	local function v100()
		local v147 = 0 - 0;
		local v148;
		local v149;
		local v150;
		while true do
			if (((4412 - (671 + 492)) > (759 + 194)) and (v147 == (1217 - (369 + 846)))) then
				if ((v38 and v33.ShadowDance:IsAvailable() and v84() and v33.ShadowDance:IsReady()) or ((867 + 2406) > (3903 + 670))) then
					if ((not v12:BuffUp(v33.ShadowDance) and v9.BossFilteredFightRemains("<=", (1953 - (1036 + 909)) + ((3 + 0) * v23(v33.Subterfuge:IsAvailable())))) or ((5289 - 2138) < (1487 - (11 + 192)))) then
						if (v18(v33.ShadowDance) or ((935 + 915) == (1704 - (135 + 40)))) then
							return "Cast Shadow Dance";
						end
					end
				end
				if (((1989 - 1168) < (1280 + 843)) and v38 and v33.GoremawsBite:IsAvailable() and v33.GoremawsBite:IsReady()) then
					if (((1986 - 1084) < (3485 - 1160)) and v90() and (v79 >= (179 - (50 + 126))) and (not v33.ShadowDance:IsReady() or (v33.ShadowDance:IsAvailable() and v12:BuffUp(v33.ShadowDance) and not v33.InvigoratingShadowdust:IsAvailable()) or ((v69 < (11 - 7)) and not v33.InvigoratingShadowdust:IsAvailable()) or v33.TheRotten:IsAvailable())) then
						if (((190 + 668) <= (4375 - (1233 + 180))) and v18(v33.GoremawsBite)) then
							return "Cast Goremaw's Bite";
						end
					end
				end
				if (v33.ThistleTea:IsReady() or ((4915 - (522 + 447)) < (2709 - (107 + 1314)))) then
					if ((((v33.SymbolsofDeath:CooldownRemains() >= (2 + 1)) or v12:BuffUp(v33.SymbolsofDeath)) and not v12:BuffUp(v33.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (304 - 204)) and ((v79 >= (1 + 1)) or (v69 >= (5 - 2)))) or ((v33.ThistleTea:ChargesFractional() >= ((7.75 - 5) - ((1910.15 - (716 + 1194)) * v33.InvigoratingShadowdust:TalentRank()))) and v33.Vanish:IsReady() and v12:BuffUp(v33.ShadowDance) and v13:DebuffUp(v33.Rupture) and (v69 < (1 + 2))))) or ((v12:BuffRemains(v33.ShadowDance) >= (1 + 3)) and not v12:BuffUp(v33.ThistleTea) and (v69 >= (506 - (74 + 429)))) or (not v12:BuffUp(v33.ThistleTea) and v9.BossFilteredFightRemains("<=", (11 - 5) * v33.ThistleTea:Charges())) or ((1607 + 1635) == (1297 - 730))) then
						if (v18(v33.ThistleTea, nil, nil) or ((600 + 247) >= (3893 - 2630))) then
							return "Thistle Tea";
						end
					end
				end
				v148 = v30.HandleDPSPotion(v9.BossFilteredFightRemains("<", 74 - 44) or (v12:BuffUp(v33.SymbolsofDeath) and (v12:BuffUp(v33.ShadowBlades) or (v33.ShadowBlades:CooldownRemains() <= (443 - (279 + 154))))));
				v147 = 781 - (454 + 324);
			end
			if ((v147 == (1 + 0)) or ((2270 - (12 + 5)) == (998 + 853))) then
				if ((v38 and v33.ShadowBlades:IsReady()) or ((5317 - 3230) > (877 + 1495))) then
					if ((v90() and ((v77 <= (1094 - (277 + 816))) or v12:HasTier(132 - 101, 1187 - (1058 + 125))) and (v12:BuffUp(v33.Flagellation) or v12:BuffUp(v33.FlagellationPersistBuff) or not v33.Flagellation:IsAvailable())) or ((834 + 3611) < (5124 - (815 + 160)))) then
						if (v18(v33.ShadowBlades, nil) or ((7800 - 5982) == (201 - 116))) then
							return "Cast Shadow Blades";
						end
					end
				end
				if (((151 + 479) < (6217 - 4090)) and v38 and v33.EchoingReprimand:IsCastable() and v33.EchoingReprimand:IsAvailable()) then
					if ((v90() and (v79 >= (1901 - (41 + 1857)))) or ((3831 - (1222 + 671)) == (6497 - 3983))) then
						if (((6115 - 1860) >= (1237 - (229 + 953))) and v18(v33.EchoingReprimand, nil, nil)) then
							return "Cast Echoing Reprimand";
						end
					end
				end
				if (((4773 - (1111 + 663)) > (2735 - (874 + 705))) and v38 and v33.ShurikenTornado:IsAvailable() and v33.ShurikenTornado:IsReady()) then
					if (((329 + 2021) > (789 + 366)) and v90() and v12:BuffUp(v33.SymbolsofDeath) and (v77 <= (3 - 1)) and not v12:BuffUp(v33.Premeditation) and (not v33.Flagellation:IsAvailable() or (v33.Flagellation:CooldownRemains() > (1 + 19))) and (v69 >= (682 - (642 + 37)))) then
						if (((919 + 3110) <= (777 + 4076)) and v18(v33.ShurikenTornado, nil)) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				if ((v38 and v33.ShurikenTornado:IsAvailable() and v33.ShurikenTornado:IsReady()) or ((1295 - 779) > (3888 - (233 + 221)))) then
					if (((9355 - 5309) >= (2670 + 363)) and v90() and not v12:BuffUp(v33.ShadowDance) and not v12:BuffUp(v33.Flagellation) and not v12:BuffUp(v33.FlagellationPersistBuff) and not v12:BuffUp(v33.ShadowBlades) and (v69 <= (1543 - (718 + 823)))) then
						if (v18(v33.ShurikenTornado, nil) or ((1711 + 1008) <= (2252 - (266 + 539)))) then
							return "Cast Shuriken Tornado";
						end
					end
				end
				v147 = 5 - 3;
			end
			if ((v147 == (1229 - (636 + 589))) or ((9812 - 5678) < (8097 - 4171))) then
				if ((v33.Fireblood:IsCastable() and v149 and v48) or ((130 + 34) >= (1012 + 1773))) then
					if (v18(v33.Fireblood, nil) or ((1540 - (657 + 358)) == (5583 - 3474))) then
						return "Cast Fireblood";
					end
				end
				if (((75 - 42) == (1220 - (1151 + 36))) and v33.AncestralCall:IsCastable() and v149 and v48) then
					if (((2950 + 104) <= (1056 + 2959)) and v18(v33.AncestralCall, nil)) then
						return "Cast Ancestral Call";
					end
				end
				v150 = v30.HandleTopTrinket(v62, v38, 119 - 79, nil);
				if (((3703 - (1552 + 280)) < (4216 - (64 + 770))) and v150) then
					return v150;
				end
				v147 = 4 + 1;
			end
			if (((2935 - 1642) <= (385 + 1781)) and (v147 == (1243 - (157 + 1086)))) then
				if ((v38 and v33.ColdBlood:IsReady() and not v33.SecretTechnique:IsAvailable() and (v78 >= (10 - 5))) or ((11295 - 8716) < (187 - 64))) then
					if (v18(v33.ColdBlood, nil) or ((1153 - 307) >= (3187 - (599 + 220)))) then
						return "Cast Cold Blood";
					end
				end
				if ((v38 and v33.Sepsis:IsAvailable() and v33.Sepsis:IsReady()) or ((7989 - 3977) <= (5289 - (1813 + 118)))) then
					if (((1093 + 401) <= (4222 - (841 + 376))) and v90() and v13:FilteredTimeToDie(">=", 21 - 5) and (v12:BuffUp(v33.PerforatedVeins) or not v33.PerforatedVeins:IsAvailable())) then
						if (v18(v33.Sepsis, nil, nil) or ((723 + 2388) == (5824 - 3690))) then
							return "Cast Sepsis";
						end
					end
				end
				if (((3214 - (464 + 395)) == (6043 - 3688)) and v38 and v33.Flagellation:IsAvailable() and v33.Flagellation:IsReady()) then
					if ((v90() and (v77 >= (3 + 2)) and (v13:TimeToDie() > (847 - (467 + 370))) and ((v96() and (v33.ShadowBlades:CooldownRemains() <= (5 - 2))) or v9.BossFilteredFightRemains("<=", 21 + 7) or ((v33.ShadowBlades:CooldownRemains() >= (47 - 33)) and v33.InvigoratingShadowdust:IsAvailable() and v33.ShadowDance:IsAvailable())) and (not v33.InvigoratingShadowdust:IsAvailable() or v33.Sepsis:IsAvailable() or not v33.ShadowDance:IsAvailable() or ((v33.InvigoratingShadowdust:TalentRank() == (1 + 1)) and (v69 >= (4 - 2))) or (v33.SymbolsofDeath:CooldownRemains() <= (523 - (150 + 370))) or (v12:BuffRemains(v33.SymbolsofDeath) > (1285 - (74 + 1208))))) or ((1446 - 858) <= (2048 - 1616))) then
						if (((3414 + 1383) >= (4285 - (14 + 376))) and v18(v33.Flagellation, nil, nil)) then
							return "Cast Flagellation";
						end
					end
				end
				if (((6203 - 2626) == (2315 + 1262)) and v38 and v33.SymbolsofDeath:IsReady()) then
					if (((3333 + 461) > (3523 + 170)) and v90() and (not v12:BuffUp(v33.TheRotten) or not v12:HasTier(87 - 57, 2 + 0)) and (v12:BuffRemains(v33.SymbolsofDeath) <= (81 - (23 + 55))) and (not v33.Flagellation:IsAvailable() or (v33.Flagellation:CooldownRemains() > (23 - 13)) or ((v12:BuffRemains(v33.ShadowDance) >= (2 + 0)) and v33.InvigoratingShadowdust:IsAvailable()) or (v33.Flagellation:IsReady() and (v77 >= (5 + 0)) and not v33.InvigoratingShadowdust:IsAvailable()))) then
						if (v18(v33.SymbolsofDeath, nil) or ((1976 - 701) == (1290 + 2810))) then
							return "Cast Symbols of Death";
						end
					end
				end
				v147 = 902 - (652 + 249);
			end
			if ((v147 == (7 - 4)) or ((3459 - (708 + 1160)) >= (9717 - 6137))) then
				if (((1792 - 809) <= (1835 - (10 + 17))) and v148) then
					return v148;
				end
				v149 = v12:BuffUp(v33.ShadowBlades) or (not v33.ShadowBlades:IsAvailable() and v12:BuffUp(v33.SymbolsofDeath)) or v9.BossFilteredFightRemains("<", 5 + 15);
				if ((v33.BloodFury:IsCastable() and v149 and v48) or ((3882 - (1400 + 332)) <= (2295 - 1098))) then
					if (((5677 - (242 + 1666)) >= (502 + 671)) and v18(v33.BloodFury, nil)) then
						return "Cast Blood Fury";
					end
				end
				if (((545 + 940) == (1266 + 219)) and v33.Berserking:IsCastable() and v149 and v48) then
					if (v18(v33.Berserking, nil) or ((4255 - (850 + 90)) <= (4872 - 2090))) then
						return "Cast Berserking";
					end
				end
				v147 = 1394 - (360 + 1030);
			end
			if ((v147 == (5 + 0)) or ((2472 - 1596) >= (4077 - 1113))) then
				v150 = v30.HandleBottomTrinket(v62, v38, 1701 - (909 + 752), nil);
				if (v150 or ((3455 - (109 + 1114)) > (4571 - 2074))) then
					return v150;
				end
				if (v33.ThistleTea:IsReady() or ((822 + 1288) <= (574 - (6 + 236)))) then
					if (((2323 + 1363) > (2554 + 618)) and ((((v33.SymbolsofDeath:CooldownRemains() >= (6 - 3)) or v12:BuffUp(v33.SymbolsofDeath)) and not v12:BuffUp(v33.ThistleTea) and (((v12:EnergyDeficitPredicted() >= (174 - 74)) and ((v12:ComboPointsDeficit() >= (1135 - (1076 + 57))) or (v69 >= (1 + 2)))) or ((v33.ThistleTea:ChargesFractional() >= (691.75 - (579 + 110))) and v12:BuffUp(v33.ShadowDanceBuff)))) or ((v12:BuffRemains(v33.ShadowDanceBuff) >= (1 + 3)) and not v12:BuffUp(v33.ThistleTea) and (v69 >= (3 + 0))) or (not v12:BuffUp(v33.ThistleTea) and v9.BossFilteredFightRemains("<=", (4 + 2) * v33.ThistleTea:Charges())))) then
						if (v18(v33.ThistleTea, nil, nil) or ((4881 - (174 + 233)) < (2290 - 1470))) then
							return "Thistle Tea";
						end
					end
				end
				return false;
			end
		end
	end
	local function v101(v151)
		local v152 = 0 - 0;
		while true do
			if (((1903 + 2376) >= (4056 - (663 + 511))) and ((1 + 0) == v152)) then
				return false;
			end
			if ((v152 == (0 + 0)) or ((6255 - 4226) >= (2133 + 1388))) then
				if ((v38 and not (v30.IsSoloMode() and v12:IsTanking(v13))) or ((4795 - 2758) >= (11236 - 6594))) then
					local v194 = 0 + 0;
					while true do
						if (((3347 - 1627) < (3178 + 1280)) and ((0 + 0) == v194)) then
							if (v33.Vanish:IsCastable() or ((1158 - (478 + 244)) > (3538 - (440 + 77)))) then
								if (((325 + 388) <= (3100 - 2253)) and ((v79 > (1557 - (655 + 901))) or (v12:BuffUp(v33.ShadowBlades) and v33.InvigoratingShadowdust:IsAvailable())) and not v88() and ((v33.Flagellation:CooldownRemains() >= (12 + 48)) or not v33.Flagellation:IsAvailable() or v9.BossFilteredFightRemains("<=", (23 + 7) * v33.Vanish:Charges())) and ((v33.SymbolsofDeath:CooldownRemains() > (3 + 0)) or not v12:HasTier(120 - 90, 1447 - (695 + 750))) and ((v33.SecretTechnique:CooldownRemains() >= (34 - 24)) or not v33.SecretTechnique:IsAvailable() or ((v33.Vanish:Charges() >= (2 - 0)) and v33.InvigoratingShadowdust:IsAvailable() and (v12:BuffUp(v33.TheRotten) or not v33.TheRotten:IsAvailable())))) then
									local v213 = 0 - 0;
									while true do
										if (((2505 - (285 + 66)) <= (9396 - 5365)) and (v213 == (1310 - (682 + 628)))) then
											v71 = v99(v33.Vanish, v151);
											if (((744 + 3871) == (4914 - (176 + 123))) and v71) then
												return "Vanish Macro " .. v71;
											end
											break;
										end
									end
								end
							end
							if ((v48 and v46 and (v12:Energy() < (17 + 23)) and v33.Shadowmeld:IsCastable()) or ((2750 + 1040) == (769 - (239 + 30)))) then
								if (((25 + 64) < (213 + 8)) and v20(v33.Shadowmeld, v12:EnergyTimeToX(70 - 30))) then
									return "Pool for Shadowmeld";
								end
							end
							v194 = 2 - 1;
						end
						if (((2369 - (306 + 9)) >= (4958 - 3537)) and (v194 == (1 + 0))) then
							if (((425 + 267) < (1472 + 1586)) and v48 and v33.Shadowmeld:IsCastable() and v65 and not v12:IsMoving() and (v12:EnergyPredicted() >= (114 - 74)) and (v12:EnergyDeficitPredicted() >= (1385 - (1140 + 235))) and not v88() and (v79 > (3 + 1))) then
								local v209 = 0 + 0;
								while true do
									if ((v209 == (0 + 0)) or ((3306 - (33 + 19)) == (598 + 1057))) then
										v71 = v99(v33.Shadowmeld, v151);
										if (v71 or ((3884 - 2588) == (2163 + 2747))) then
											return "Shadowmeld Macro " .. v71;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (((6604 - 3236) == (3159 + 209)) and v65 and v33.ShadowDance:IsCastable()) then
					if (((3332 - (586 + 103)) < (348 + 3467)) and (v13:DebuffUp(v33.Rupture) or v33.InvigoratingShadowdust:IsAvailable()) and v93() and (not v33.TheFirstDance:IsAvailable() or (v79 >= (12 - 8)) or v12:BuffUp(v33.ShadowBlades)) and ((v89() and v88()) or ((v12:BuffUp(v33.ShadowBlades) or (v12:BuffUp(v33.SymbolsofDeath) and not v33.Sepsis:IsAvailable()) or ((v12:BuffRemains(v33.SymbolsofDeath) >= (1492 - (1309 + 179))) and not v12:HasTier(54 - 24, 1 + 1)) or (not v12:BuffUp(v33.SymbolsofDeath) and v12:HasTier(80 - 50, 2 + 0))) and (v33.SecretTechnique:CooldownRemains() < ((21 - 11) + ((23 - 11) * v23(not v33.InvigoratingShadowdust:IsAvailable() or v12:HasTier(639 - (295 + 314), 4 - 2)))))))) then
						v71 = v99(v33.ShadowDance, v151);
						if (((3875 - (1300 + 662)) > (1547 - 1054)) and v71) then
							return "ShadowDance Macro 1 " .. v71;
						end
					end
				end
				v152 = 1756 - (1178 + 577);
			end
		end
	end
	local function v102(v153)
		local v154 = not v153 or (v12:EnergyPredicted() >= v153);
		if (((2470 + 2285) > (10133 - 6705)) and v37 and v33.ShurikenStorm:IsCastable() and (v69 >= ((1407 - (851 + 554)) + v17((v33.Gloomblade:IsAvailable() and (v12:BuffRemains(v33.LingeringShadowBuff) >= (6 + 0))) or v12:BuffUp(v33.PerforatedVeinsBuff))))) then
			if (((3829 - 2448) <= (5144 - 2775)) and v154 and v18(v33.ShurikenStorm)) then
				return "Cast Shuriken Storm";
			end
			v82(v33.ShurikenStorm, v153);
		end
		if (v65 or ((5145 - (115 + 187)) == (3128 + 956))) then
			if (((4421 + 248) > (1430 - 1067)) and v33.Gloomblade:IsCastable()) then
				if ((v154 and v18(v33.Gloomblade)) or ((3038 - (160 + 1001)) >= (2746 + 392))) then
					return "Cast Gloomblade";
				end
				v82(v33.Gloomblade, v153);
			elseif (((3272 + 1470) >= (7422 - 3796)) and v33.Backstab:IsCastable()) then
				local v195 = 358 - (237 + 121);
				while true do
					if ((v195 == (897 - (525 + 372))) or ((8607 - 4067) == (3009 - 2093))) then
						if ((v154 and v18(v33.Backstab)) or ((1298 - (96 + 46)) > (5122 - (643 + 134)))) then
							return "Cast Backstab";
						end
						v82(v33.Backstab, v153);
						break;
					end
				end
			end
		end
		return false;
	end
	local v103 = {{v33.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end},{v33.KidneyShot,"Cast Kidney Shot (Interrupt)",function()
		return v78 > (0 - 0);
	end},{v33.CheapShot,"Cast Cheap Shot (Interrupt)",function()
		return v12:StealthUp(true, true);
	end}};
	local function v104()
		v40 = EpicSettings.Settings['BurnShadowDance'];
		v41 = EpicSettings.Settings['UsePriorityRotation'];
		v42 = EpicSettings.Settings['RangedMultiDoT'];
		v43 = EpicSettings.Settings['StealthMacroVanish'];
		v44 = EpicSettings.Settings['StealthMacroShadowmeld'];
		v45 = EpicSettings.Settings['StealthMacroShadowDance'];
		v46 = EpicSettings.Settings['PoolForShadowmeld'];
		v47 = EpicSettings.Settings['EviscerateDMGOffset'] or (3 - 2);
		v48 = EpicSettings.Settings['UseRacials'];
		v49 = EpicSettings.Settings['UseHealingPotion'];
		v50 = EpicSettings.Settings['HealingPotionName'];
		v51 = EpicSettings.Settings['HealingPotionHP'] or (4 - 3);
		v52 = EpicSettings.Settings['DispelBuffs'];
		v53 = EpicSettings.Settings['UseHealthstone'];
		v54 = EpicSettings.Settings['HealthstoneHP'] or (1 - 0);
		v55 = EpicSettings.Settings['InterruptWithStun'];
		v56 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v57 = EpicSettings.Settings['InterruptThreshold'];
		v58 = EpicSettings.Settings['AutoFocusTank'];
		v59 = EpicSettings.Settings['AutoTricksTank'];
		v60 = EpicSettings.Settings['UsageStealthOOC'];
		v61 = EpicSettings.Settings['StealthRange'] or (0 + 0);
	end
	local function v105()
		v104();
		v36 = EpicSettings.Toggles['ooc'];
		v37 = EpicSettings.Toggles['aoe'];
		v38 = EpicSettings.Toggles['cds'];
		v39 = EpicSettings.Toggles['dispel'];
		v72 = nil;
		v74 = nil;
		v73 = 0 - 0;
		v63 = (v33.AcrobaticStrikes:IsAvailable() and (1 + 7)) or (14 - 9);
		v64 = (v33.AcrobaticStrikes:IsAvailable() and (30 - (12 + 5))) or (38 - 28);
		v65 = v13:IsInMeleeRange(v63);
		v66 = v13:IsInMeleeRange(v64);
		if (((4772 - 2535) < (9031 - 4782)) and v37) then
			local v181 = 0 - 0;
			while true do
				if ((v181 == (1 + 0)) or ((4656 - (1656 + 317)) < (21 + 2))) then
					v69 = #v68;
					v70 = v12:GetEnemiesInMeleeRange(v63);
					break;
				end
				if (((559 + 138) <= (2196 - 1370)) and (v181 == (0 - 0))) then
					v67 = v12:GetEnemiesInRange(384 - (5 + 349));
					v68 = v12:GetEnemiesInMeleeRange(v64);
					v181 = 4 - 3;
				end
			end
		else
			v67 = {};
			v68 = {};
			v69 = 1272 - (266 + 1005);
			v70 = {};
		end
		v78 = v12:ComboPoints();
		v77 = v31.EffectiveComboPoints(v78);
		v79 = v12:ComboPointsDeficit();
		v81 = v85();
		v80 = v12:EnergyMax() - v87();
		if (((729 + 376) <= (4012 - 2836)) and v12:BuffUp(v33.ShurikenTornado, nil, true) and (v78 < v31.CPMaxSpend())) then
			local v182 = v31.TimeToNextTornado();
			if (((4447 - 1068) <= (5508 - (561 + 1135))) and ((v182 <= v12:GCDRemains()) or (v29(v12:GCDRemains() - v182) < (0.25 - 0)))) then
				local v192 = v69 + v23(v12:BuffUp(v33.ShadowBlades));
				v78 = v27(v78 + v192, v31.CPMaxSpend());
				v79 = v28(v79 - v192, 0 - 0);
				if ((v77 < v31.CPMaxSpend()) or ((1854 - (507 + 559)) >= (4054 - 2438))) then
					v77 = v78;
				end
			end
		end
		v75 = ((12 - 8) + (v77 * (392 - (212 + 176)))) * (905.3 - (250 + 655));
		v76 = v33.Eviscerate:Damage() * v47;
		if (((5055 - 3201) <= (5903 - 2524)) and not v12:AffectingCombat() and v58) then
			local v183 = v30.FocusUnit(false, nil, nil, "TANK", 31 - 11, v33.TricksoftheTrade);
			if (((6505 - (1869 + 87)) == (15777 - 11228)) and v183) then
				return v183;
			end
		end
		if ((Focus and v59 and (v30.UnitGroupRole(Focus) == "TANK") and v33.TricksoftheTrade:IsCastable()) or ((4923 - (484 + 1417)) >= (6481 - 3457))) then
			if (((8077 - 3257) > (2971 - (48 + 725))) and Press(v35.TricksoftheTradeFocus)) then
				return "tricks of the trade tank";
			end
		end
		v71 = v31.CrimsonVial();
		if (v71 or ((1733 - 672) >= (13122 - 8231))) then
			return v71;
		end
		v71 = v31.Feint();
		if (((793 + 571) <= (11953 - 7480)) and v71) then
			return v71;
		end
		v31.Poisons();
		if ((not v12:AffectingCombat() and v36) or ((1007 + 2588) <= (1 + 2))) then
			local v184 = 853 - (152 + 701);
			while true do
				if ((v184 == (1312 - (430 + 881))) or ((1790 + 2882) == (4747 - (557 + 338)))) then
					if (((461 + 1098) == (4392 - 2833)) and v30.TargetIsValid() and (v13:IsSpellInRange(v33.Shadowstrike) or v65)) then
						if (v12:StealthUp(true, true) or ((6134 - 4382) <= (2093 - 1305))) then
							local v207 = 0 - 0;
							while true do
								if ((v207 == (801 - (499 + 302))) or ((4773 - (39 + 827)) == (488 - 311))) then
									v72 = v98(true);
									if (((7749 - 4279) > (2204 - 1649)) and v72) then
										if (((type(v72) == "table") and (#v72 > (1 - 0))) or ((84 + 888) == (1887 - 1242))) then
											if (((510 + 2672) >= (3346 - 1231)) and v22(nil, unpack(v72))) then
												return "Stealthed Macro Cast or Pool (OOC): " .. v72[105 - (103 + 1)]:Name();
											end
										elseif (((4447 - (475 + 79)) < (9574 - 5145)) and v20(v72)) then
											return "Stealthed Cast or Pool (OOC): " .. v72:Name();
										end
									end
									break;
								end
							end
						elseif ((v78 >= (16 - 11)) or ((371 + 2496) < (1677 + 228))) then
							v71 = v97();
							if (v71 or ((3299 - (1395 + 108)) >= (11788 - 7737))) then
								return v71 .. " (OOC)";
							end
						elseif (((2823 - (7 + 1197)) <= (1638 + 2118)) and v33.Backstab:IsCastable()) then
							if (((211 + 393) == (923 - (27 + 292))) and v18(v33.Backstab)) then
								return "Cast Backstab (OOC)";
							end
						end
					end
					return;
				end
				if ((v184 == (0 - 0)) or ((5717 - 1233) == (3774 - 2874))) then
					if ((v33.Stealth:IsCastable() and (v60 == "Always")) or ((8792 - 4333) <= (2119 - 1006))) then
						local v199 = 139 - (43 + 96);
						while true do
							if (((14815 - 11183) > (7682 - 4284)) and (v199 == (0 + 0))) then
								v71 = v31.Stealth(v31.StealthSpell());
								if (((1153 + 2929) <= (9717 - 4800)) and v71) then
									return v71;
								end
								break;
							end
						end
					elseif (((1852 + 2980) >= (2597 - 1211)) and v33.Stealth:IsCastable() and (v60 == "Distance") and v13:IsInRange(v61)) then
						local v208 = 0 + 0;
						while true do
							if (((11 + 126) == (1888 - (1414 + 337))) and (v208 == (1940 - (1642 + 298)))) then
								v71 = v31.Stealth(v31.StealthSpell());
								if (v71 or ((4092 - 2522) >= (12462 - 8130))) then
									return v71;
								end
								break;
							end
						end
					end
					if ((not v12:BuffUp(v33.ShadowDanceBuff) and not v12:BuffUp(v31.VanishBuffSpell())) or ((12060 - 7996) <= (599 + 1220))) then
						local v200 = 0 + 0;
						while true do
							if ((v200 == (972 - (357 + 615))) or ((3500 + 1486) < (3862 - 2288))) then
								v71 = v31.Stealth(v31.StealthSpell());
								if (((3793 + 633) > (368 - 196)) and v71) then
									return v71;
								end
								break;
							end
						end
					end
					v184 = 1 + 0;
				end
			end
		end
		if (((40 + 546) > (286 + 169)) and v30.TargetIsValid()) then
			local v185 = 1301 - (384 + 917);
			local v186;
			while true do
				if (((1523 - (128 + 569)) == (2369 - (1407 + 136))) and (v185 == (1887 - (687 + 1200)))) then
					if ((not v12:IsCasting() and not v12:IsChanneling()) or ((5729 - (556 + 1154)) > (15623 - 11182))) then
						local v201 = 95 - (9 + 86);
						local v202;
						while true do
							if (((2438 - (275 + 146)) < (693 + 3568)) and (v201 == (65 - (29 + 35)))) then
								v202 = v30.Interrupt(v33.Blind, 66 - 51, BlindInterrupt);
								if (((14086 - 9370) > (353 - 273)) and v202) then
									return v202;
								end
								v202 = v30.Interrupt(v33.Blind, 10 + 5, BlindInterrupt, MouseOver, v35.BlindMouseover);
								if (v202 or ((4519 - (53 + 959)) == (3680 - (312 + 96)))) then
									return v202;
								end
								v201 = 3 - 1;
							end
							if ((v201 == (285 - (147 + 138))) or ((1775 - (813 + 86)) >= (2779 + 296))) then
								v202 = v30.Interrupt(v33.Kick, 14 - 6, true);
								if (((4844 - (18 + 474)) > (862 + 1692)) and v202) then
									return v202;
								end
								v202 = v30.Interrupt(v33.Kick, 25 - 17, true, MouseOver, v35.KickMouseover);
								if (v202 or ((5492 - (860 + 226)) < (4346 - (121 + 182)))) then
									return v202;
								end
								v201 = 1 + 0;
							end
							if ((v201 == (1242 - (988 + 252))) or ((214 + 1675) >= (1060 + 2323))) then
								v202 = v30.InterruptWithStun(v33.CheapShot, 1978 - (49 + 1921), v12:StealthUp(false, false));
								if (((2782 - (223 + 667)) <= (2786 - (51 + 1))) and v202) then
									return v202;
								end
								v202 = v30.InterruptWithStun(v33.KidneyShot, 13 - 5, v12:ComboPoints() > (0 - 0));
								if (((3048 - (146 + 979)) < (626 + 1592)) and v202) then
									return v202;
								end
								break;
							end
						end
					end
					if (((2778 - (311 + 294)) > (1056 - 677)) and v52 and v39 and v33.Shiv:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and v30.UnitHasEnrageBuff(v13)) then
						if (Press(v33.Shiv, not IsInMeleeRange) or ((1098 + 1493) == (4852 - (496 + 947)))) then
							return "shiv dispel enrage";
						end
					end
					if (((5872 - (1233 + 125)) > (1349 + 1975)) and v34.Healthstone:IsReady() and v53 and (v12:HealthPercentage() <= v54)) then
						if (Press(v35.Healthstone, nil, nil, true) or ((187 + 21) >= (918 + 3910))) then
							return "healthstone defensive 3";
						end
					end
					v185 = 1646 - (963 + 682);
				end
				if ((v185 == (5 + 0)) or ((3087 - (504 + 1000)) > (2403 + 1164))) then
					v71 = v102(v80);
					if (v71 or ((1196 + 117) == (75 + 719))) then
						return "Build: " .. v71;
					end
					if (((4679 - 1505) > (2480 + 422)) and v38) then
						local v203 = 0 + 0;
						while true do
							if (((4302 - (156 + 26)) <= (2455 + 1805)) and (v203 == (1 - 0))) then
								if ((v33.BagofTricks:IsReady() and v48) or ((1047 - (149 + 15)) > (5738 - (890 + 70)))) then
									if (v18(v33.BagofTricks, nil) or ((3737 - (39 + 78)) >= (5373 - (14 + 468)))) then
										return "Cast Bag of Tricks";
									end
								end
								break;
							end
							if (((9363 - 5105) > (2618 - 1681)) and (v203 == (0 + 0))) then
								if ((v33.ArcaneTorrent:IsReady() and v65 and (v12:EnergyDeficitPredicted() >= (10 + 5 + v12:EnergyRegen())) and v48) or ((1035 + 3834) < (410 + 496))) then
									if (v18(v33.ArcaneTorrent, nil) or ((321 + 904) > (8092 - 3864))) then
										return "Cast Arcane Torrent";
									end
								end
								if (((3290 + 38) > (7864 - 5626)) and v33.ArcanePulse:IsReady() and v65 and v48) then
									if (((97 + 3742) > (1456 - (12 + 39))) and v18(v33.ArcanePulse, nil)) then
										return "Cast Arcane Pulse";
									end
								end
								v203 = 1 + 0;
							end
						end
					end
					v185 = 18 - 12;
				end
				if ((v185 == (6 - 4)) or ((384 + 909) <= (267 + 240))) then
					if ((v33.SliceandDice:IsCastable() and (v69 < v31.CPMaxSpend()) and (v12:BuffRemains(v33.SliceandDice) < v12:GCD()) and v9.BossFilteredFightRemains(">", 14 - 8) and (v78 >= (3 + 1))) or ((13995 - 11099) < (2515 - (1596 + 114)))) then
						local v204 = 0 - 0;
						while true do
							if (((3029 - (164 + 549)) == (3754 - (1059 + 379))) and (v204 == (0 - 0))) then
								if ((v33.SliceandDice:IsReady() and v18(v33.SliceandDice)) or ((1332 + 1238) == (259 + 1274))) then
									return "Cast Slice and Dice (Low Duration)";
								end
								v83(v33.SliceandDice);
								break;
							end
						end
					end
					if (v12:StealthUp(true, true) or ((1275 - (145 + 247)) == (1198 + 262))) then
						v72 = v98(true);
						if (v72 or ((2135 + 2484) <= (2961 - 1962))) then
							if (((type(v72) == "table") and (#v72 > (1 + 0))) or ((2938 + 472) > (6682 - 2566))) then
								if (v22(nil, unpack(v72)) or ((1623 - (254 + 466)) >= (3619 - (544 + 16)))) then
									return "Stealthed Macro " .. v72[2 - 1]:Name() .. "|" .. v72[630 - (294 + 334)]:Name();
								end
							elseif ((v12:BuffUp(v33.ShurikenTornado) and (v78 ~= v12:ComboPoints()) and ((v72 == v33.BlackPowder) or (v72 == v33.Eviscerate) or (v72 == v33.Rupture) or (v72 == v33.SliceandDice))) or ((4229 - (236 + 17)) < (1232 + 1625))) then
								if (((3838 + 1092) > (8688 - 6381)) and v22(nil, v33.ShurikenTornado, v72)) then
									return "Stealthed Tornado Cast  " .. v72:Name();
								end
							elseif ((type(v72) ~= "boolean") or ((19155 - 15109) < (665 + 626))) then
								if (v20(v72) or ((3493 + 748) == (4339 - (413 + 381)))) then
									return "Stealthed Cast " .. v72:Name();
								end
							end
						end
						v18(v33.PoolEnergy);
						return "Stealthed Pooling";
					end
					v186 = nil;
					v185 = 1 + 2;
				end
				if ((v185 == (1 - 0)) or ((10514 - 6466) > (6202 - (582 + 1388)))) then
					if ((v49 and (v12:HealthPercentage() <= v51)) or ((2981 - 1231) >= (2487 + 986))) then
						if (((3530 - (326 + 38)) == (9365 - 6199)) and (v50 == "Refreshing Healing Potion")) then
							if (((2516 - 753) < (4344 - (47 + 573))) and v34.RefreshingHealingPotion:IsReady()) then
								if (((21 + 36) <= (11564 - 8841)) and Press(v35.RefreshingHealingPotion, nil, nil, true)) then
									return "refreshing healing potion defensive 4";
								end
							end
						end
						if ((v50 == "Dreamwalker's Healing Potion") or ((3359 - 1289) == (2107 - (1269 + 395)))) then
							if (v34.DreamwalkersHealingPotion:IsReady() or ((3197 - (76 + 416)) == (1836 - (319 + 124)))) then
								if (Press(v35.RefreshingHealingPotion, nil, nil, true) or ((10517 - 5916) < (1068 - (564 + 443)))) then
									return "dreamwalker's healing potion defensive 4";
								end
							end
						end
					end
					v71 = v100();
					if (v71 or ((3848 - 2458) >= (5202 - (337 + 121)))) then
						return "CDs: " .. v71;
					end
					v185 = 5 - 3;
				end
				if (((19 - 13) == v185) or ((3914 - (1261 + 650)) > (1623 + 2211))) then
					if ((v72 and v65) or ((247 - 91) > (5730 - (772 + 1045)))) then
						if (((28 + 167) == (339 - (102 + 42))) and (type(v72) == "table") and (#v72 > (1845 - (1524 + 320)))) then
							if (((4375 - (1049 + 221)) >= (1952 - (18 + 138))) and v22(v12:EnergyTimeToX(v73), unpack(v72))) then
								return "Macro pool towards " .. v72[2 - 1]:Name() .. " at " .. v73;
							end
						elseif (((5481 - (67 + 1035)) >= (2479 - (136 + 212))) and v72:IsCastable()) then
							v73 = v28(v73, v72:Cost());
							if (((16334 - 12490) >= (1637 + 406)) and v20(v72, v12:EnergyTimeToX(v73))) then
								return "Pool towards: " .. v72:Name() .. " at " .. v73;
							end
						end
					end
					if ((v33.ShurikenToss:IsCastable() and v13:IsInRange(28 + 2) and not v66 and not v12:StealthUp(true, true) and not v12:BuffUp(v33.Sprint) and (v12:EnergyDeficitPredicted() < (1624 - (240 + 1364))) and ((v79 >= (1083 - (1050 + 32))) or (v12:EnergyTimeToMax() <= (3.2 - 2)))) or ((1912 + 1320) <= (3786 - (331 + 724)))) then
						if (((396 + 4509) == (5549 - (269 + 375))) and v20(v33.ShurikenToss)) then
							return "Cast Shuriken Toss";
						end
					end
					break;
				end
				if ((v185 == (729 - (267 + 458))) or ((1287 + 2849) >= (8482 - 4071))) then
					if ((v79 <= (819 - (667 + 151))) or (v9.BossFilteredFightRemains("<=", 1498 - (1410 + 87)) and (v77 >= (1900 - (1504 + 393)))) or ((7995 - 5037) == (10421 - 6404))) then
						v71 = v97();
						if (((2024 - (461 + 335)) >= (104 + 709)) and v71) then
							return "Finish: " .. v71;
						end
					end
					if (((v69 >= (1765 - (1730 + 31))) and (v77 >= (1671 - (728 + 939)))) or ((12236 - 8781) > (8215 - 4165))) then
						local v205 = 0 - 0;
						while true do
							if (((1311 - (138 + 930)) == (223 + 20)) and (v205 == (0 + 0))) then
								v71 = v97();
								if (v71 or ((233 + 38) > (6418 - 4846))) then
									return "Finish: " .. v71;
								end
								break;
							end
						end
					end
					if (((4505 - (459 + 1307)) < (5163 - (474 + 1396))) and v74) then
						v82(v74);
					end
					v185 = 8 - 3;
				end
				if ((v185 == (3 + 0)) or ((13 + 3929) < (3248 - 2114))) then
					if (not v33.Vigor:IsAvailable() or v33.Shadowcraft:IsAvailable() or ((342 + 2351) == (16601 - 11628))) then
						v186 = v12:EnergyDeficitPredicted() <= v87();
					else
						v186 = v12:EnergyPredicted() >= v87();
					end
					if (((9358 - 7212) == (2737 - (562 + 29))) and (v186 or v33.InvigoratingShadowdust:IsAvailable())) then
						v71 = v101(v80);
						if (v71 or ((1914 + 330) == (4643 - (374 + 1045)))) then
							return "Stealth CDs: " .. v71;
						end
					end
					if ((v77 >= v31.CPMaxSpend()) or ((3882 + 1022) <= (5949 - 4033))) then
						local v206 = 638 - (448 + 190);
						while true do
							if (((30 + 60) <= (481 + 584)) and (v206 == (0 + 0))) then
								v71 = v97();
								if (((18462 - 13660) == (14920 - 10118)) and v71) then
									return "Finish: " .. v71;
								end
								break;
							end
						end
					end
					v185 = 1498 - (1307 + 187);
				end
			end
		end
	end
	local function v106()
		local v177 = 0 - 0;
		while true do
			if ((v177 == (0 - 0)) or ((6990 - 4710) <= (1194 - (232 + 451)))) then
				v9.Print("Subtlety Rogue by Epic BoomK");
				EpicSettings.SetupVersion("Subtlety Rogue  X v 10.2.5.00 By BoomK");
				break;
			end
		end
	end
	v9.SetAPL(250 + 11, v105, v106);
end;
return v0["Epix_Rogue_Subtlety.lua"]();

