local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1773 - (1755 + 18);
	local v6;
	while true do
		if (((6016 - (559 + 1288)) >= (4118 - (609 + 1322))) and (v5 == (455 - (13 + 441)))) then
			return v6(...);
		end
		if (((5253 - 3847) == (3682 - 2276)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (((58 + 1473) < (15511 - 11240)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_DemonHunter_Vengeance.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v13.MouseOver;
	local v17 = v10.Spell;
	local v18 = v10.Item;
	local v19 = EpicLib;
	local v20 = v19.Press;
	local v21 = v19.Macro;
	local v22 = v19.Commons.Everyone;
	local v23 = v10.Utils.MergeTableByKey;
	local v24 = v22.num;
	local v25 = v22.bool;
	local v26 = GetTime;
	local v27 = math.max;
	local v28 = math.min;
	local v29;
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
	local v79;
	local v80;
	local v81 = v17.DemonHunter.Vengeance;
	local v82 = v18.DemonHunter.Vengeance;
	local v83 = v21.DemonHunter.Vengeance;
	local v84 = {};
	local v85, v86;
	local v87 = 0 + 0;
	local v88, v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94 = true;
	local v95 = 32972 - 21861;
	local v96 = 6081 + 5030;
	local v97 = {(112007 + 57414),(121734 + 47691),(165281 + 3651),(489234 - 319808),(66898 + 102531),(153753 + 15675),(257993 - 88563)};
	v10:RegisterForEvent(function()
		local v115 = 0 + 0;
		while true do
			if (((1302 - (89 + 578)) == (454 + 181)) and (v115 == (0 - 0))) then
				v95 = 12160 - (572 + 477);
				v96 = 1499 + 9612;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v98()
		v85 = v14:BuffStack(v81.SoulFragments);
		if (((2025 + 1348) <= (425 + 3131)) and (v81.SpiritBomb:TimeSinceLastCast() < v14:GCD())) then
			v87 = 86 - (84 + 2);
		end
		if ((v87 == (0 - 0)) or ((2371 + 920) < (4122 - (497 + 345)))) then
			local v133 = 0 + 0;
			local v134;
			while true do
				if (((742 + 3644) >= (2206 - (605 + 728))) and (v133 == (0 + 0))) then
					v134 = ((v14:BuffUp(v81.MetamorphosisBuff)) and (1 - 0)) or (0 + 0);
					if (((3405 - 2484) <= (994 + 108)) and v81.SoulCarver:IsAvailable() and (v81.SoulCarver:TimeSinceLastCast() < v14:GCD()) and (v81.SoulCarver.LastCastTime ~= v86)) then
						local v194 = 0 - 0;
						while true do
							if (((3554 + 1152) >= (1452 - (457 + 32))) and (v194 == (0 + 0))) then
								v87 = v28(v85 + (1404 - (832 + 570)), 5 + 0);
								v86 = v81.SoulCarver.LastCastTime;
								break;
							end
						end
					elseif ((v81.Fracture:IsAvailable() and (v81.Fracture:TimeSinceLastCast() < v14:GCD()) and (v81.Fracture.LastCastTime ~= v86)) or ((251 + 709) <= (3099 - 2223))) then
						local v195 = 0 + 0;
						while true do
							if ((v195 == (796 - (588 + 208))) or ((5568 - 3502) == (2732 - (884 + 916)))) then
								v87 = v28(v85 + (3 - 1) + v134, 3 + 2);
								v86 = v81.Fracture.LastCastTime;
								break;
							end
						end
					elseif (((5478 - (232 + 421)) < (6732 - (1569 + 320))) and (v81.Shear:TimeSinceLastCast() < v14:GCD()) and (v81.Fracture.Shear ~= v86)) then
						local v197 = 0 + 0;
						while true do
							if ((v197 == (0 + 0)) or ((13064 - 9187) >= (5142 - (316 + 289)))) then
								v87 = v28(v85 + (2 - 1) + v134, 1 + 4);
								v86 = v81.Shear.LastCastTime;
								break;
							end
						end
					elseif (v81.SoulSigils:IsAvailable() or ((5768 - (666 + 787)) < (2151 - (360 + 65)))) then
						local v199 = 0 + 0;
						local v200;
						local v201;
						while true do
							if ((v199 == (255 - (79 + 175))) or ((5800 - 2121) < (488 + 137))) then
								if ((v81.ElysianDecree:IsAvailable() and (v200 == v81.ElysianDecree.LastCastTime) and (v201 < v14:GCD()) and (v200 ~= v86)) or ((14176 - 9551) < (1216 - 584))) then
									local v207 = v28(v93, 902 - (503 + 396));
									v87 = v28(v85 + v207, 186 - (92 + 89));
									v86 = v200;
								elseif (((v201 < v14:GCD()) and (v200 ~= v86)) or ((160 - 77) > (913 + 867))) then
									v87 = v28(v85 + 1 + 0, 19 - 14);
									v86 = v200;
								end
								break;
							end
							if (((75 + 471) <= (2455 - 1378)) and (v199 == (0 + 0))) then
								v200 = v27(v81.SigilOfFlame.LastCastTime, v81.SigilOfSilence.LastCastTime, v81.SigilOfChains.LastCastTime, v81.ElysianDecree.LastCastTime);
								v201 = v28(v81.SigilOfFlame:TimeSinceLastCast(), v81.SigilOfSilence:TimeSinceLastCast(), v81.SigilOfChains:TimeSinceLastCast(), v81.ElysianDecree:TimeSinceLastCast());
								v199 = 1 + 0;
							end
						end
					elseif ((v81.Fallout:IsAvailable() and (v81.ImmolationAura:TimeSinceLastCast() < v14:GCD()) and (v81.ImmolationAura.LastCastTime ~= v86)) or ((3033 - 2037) > (537 + 3764))) then
						local v203 = 0 - 0;
						local v204;
						while true do
							if (((5314 - (485 + 759)) > (1589 - 902)) and (v203 == (1190 - (442 + 747)))) then
								v86 = v81.ImmolationAura.LastCastTime;
								break;
							end
							if ((v203 == (1135 - (832 + 303))) or ((1602 - (88 + 858)) >= (1015 + 2315))) then
								v204 = (0.6 + 0) * v28(v93, 1 + 4);
								v87 = v28(v85 + v204, 794 - (766 + 23));
								v203 = 4 - 3;
							end
						end
					elseif ((v81.BulkExtraction:IsAvailable() and (v81.BulkExtraction:TimeSinceLastCast() < v14:GCD()) and (v81.BulkExtraction.LastCastTime ~= v86)) or ((3407 - 915) <= (882 - 547))) then
						local v205 = 0 - 0;
						local v206;
						while true do
							if (((5395 - (1036 + 37)) >= (1817 + 745)) and (v205 == (0 - 0))) then
								v206 = v28(v93, 4 + 1);
								v87 = v28(v85 + v206, 1485 - (641 + 839));
								v205 = 914 - (910 + 3);
							end
							if ((v205 == (2 - 1)) or ((5321 - (1466 + 218)) >= (1733 + 2037))) then
								v86 = v81.BulkExtraction.LastCastTime;
								break;
							end
						end
					end
					break;
				end
			end
		else
			local v135 = v14:PrevGCD(1149 - (556 + 592));
			local v136 = {v81.SoulCarver,v81.Fracture,v81.Shear,v81.BulkExtraction};
			if (v81.SoulSigils:IsAvailable() or ((4930 - 2551) > (3269 + 1309))) then
				local v180 = 739 - (396 + 343);
				while true do
					if ((v180 == (1 + 0)) or ((1960 - (29 + 1448)) > (2132 - (135 + 1254)))) then
						v23(v136, v81.SigilOfChains);
						v23(v136, v81.ElysianDecree);
						break;
					end
					if (((9244 - 6790) > (2698 - 2120)) and (v180 == (0 + 0))) then
						v23(v136, v81.SigilOfFlame);
						v23(v136, v81.SigilOfSilence);
						v180 = 1528 - (389 + 1138);
					end
				end
			end
			if (((1504 - (102 + 472)) < (4207 + 251)) and v81.Fallout:IsAvailable()) then
				v23(v136, v81.ImmolationAura);
			end
			for v140, v141 in pairs(v136) do
				if (((368 + 294) <= (907 + 65)) and (v135 == v141:ID()) and (v141:TimeSinceLastCast() >= v14:GCD())) then
					v87 = 1545 - (320 + 1225);
					break;
				end
			end
		end
		if (((7779 - 3409) == (2674 + 1696)) and (v87 > v85)) then
			v85 = v87;
		elseif ((v87 > (1464 - (157 + 1307))) or ((6621 - (821 + 1038)) <= (2148 - 1287))) then
			v87 = 0 + 0;
		end
	end
	local function v99()
		local v116 = 0 - 0;
		while true do
			if ((v116 == (0 + 0)) or ((3499 - 2087) == (5290 - (834 + 192)))) then
				if ((v81.Felblade:TimeSinceLastCast() < v14:GCD()) or (v81.InfernalStrike:TimeSinceLastCast() < v14:GCD()) or ((202 + 2966) < (553 + 1600))) then
					local v191 = 0 + 0;
					while true do
						if ((v191 == (1 - 0)) or ((5280 - (300 + 4)) < (356 + 976))) then
							return;
						end
						if (((12114 - 7486) == (4990 - (112 + 250))) and (v191 == (0 + 0))) then
							v88 = true;
							v89 = true;
							v191 = 2 - 1;
						end
					end
				end
				v88 = v15:IsInMeleeRange(3 + 2);
				v116 = 1 + 0;
			end
			if ((v116 == (1 + 0)) or ((27 + 27) == (294 + 101))) then
				v89 = v88 or (v93 > (1414 - (1001 + 413)));
				break;
			end
		end
	end
	local function v100(v117)
		return (v117:DebuffRemains(v81.FieryBrandDebuff));
	end
	local function v101(v118)
		return (v118:DebuffUp(v81.FieryBrandDebuff));
	end
	local function v102()
		local v119 = 0 - 0;
		while true do
			if (((964 - (244 + 638)) == (775 - (627 + 66))) and ((0 - 0) == v119)) then
				v29 = v22.HandleTopTrinket(v84, v32, 642 - (512 + 90), nil);
				if (v29 or ((2487 - (1665 + 241)) < (999 - (373 + 344)))) then
					return v29;
				end
				v119 = 1 + 0;
			end
			if ((v119 == (1 + 0)) or ((12157 - 7548) < (4221 - 1726))) then
				v29 = v22.HandleBottomTrinket(v84, v32, 1139 - (35 + 1064), nil);
				if (((839 + 313) == (2464 - 1312)) and v29) then
					return v29;
				end
				break;
			end
		end
	end
	local function v103()
		local v120 = 0 + 0;
		while true do
			if (((3132 - (298 + 938)) <= (4681 - (233 + 1026))) and (v120 == (1668 - (636 + 1030)))) then
				if ((v81.Shear:IsCastable() and v39 and v88) or ((507 + 483) > (1583 + 37))) then
					if (v20(v81.Shear) or ((261 + 616) > (318 + 4377))) then
						return "shear precombat 10";
					end
				end
				break;
			end
			if (((2912 - (55 + 166)) >= (359 + 1492)) and (v120 == (1 + 0))) then
				if ((v81.InfernalStrike:IsCastable() and v38) or ((11399 - 8414) >= (5153 - (36 + 261)))) then
					if (((7477 - 3201) >= (2563 - (34 + 1334))) and v20(v83.InfernalStrikePlayer, not v15:IsInMeleeRange(4 + 4))) then
						return "infernal_strike precombat 6";
					end
				end
				if (((2512 + 720) <= (5973 - (1035 + 248))) and v81.Fracture:IsCastable() and v36 and v88) then
					if (v20(v81.Fracture) or ((917 - (20 + 1)) >= (1640 + 1506))) then
						return "fracture precombat 8";
					end
				end
				v120 = 321 - (134 + 185);
			end
			if (((4194 - (549 + 584)) >= (3643 - (314 + 371))) and (v120 == (0 - 0))) then
				if (((4155 - (478 + 490)) >= (342 + 302)) and v40 and not v14:IsMoving() and v81.SigilOfFlame:IsCastable()) then
					if (((1816 - (786 + 386)) <= (2280 - 1576)) and ((v78 == "player") or v81.ConcentratedSigils:IsAvailable())) then
						if (((2337 - (1055 + 324)) > (2287 - (1093 + 247))) and v20(v83.SigilOfFlamePlayer, not v15:IsInMeleeRange(8 + 0))) then
							return "sigil_of_flame precombat 2";
						end
					elseif (((473 + 4019) >= (10536 - 7882)) and (v78 == "cursor")) then
						if (((11681 - 8239) >= (4276 - 2773)) and v20(v83.SigilOfFlameCursor, not v15:IsInRange(75 - 45))) then
							return "sigil_of_flame precombat 2";
						end
					end
				end
				if ((v81.ImmolationAura:IsCastable() and v37) or ((1128 + 2042) <= (5639 - 4175))) then
					if (v20(v81.ImmolationAura, not v15:IsInMeleeRange(27 - 19)) or ((3618 + 1179) == (11221 - 6833))) then
						return "immolation_aura precombat 4";
					end
				end
				v120 = 689 - (364 + 324);
			end
		end
	end
	local function v104()
		local v121 = 0 - 0;
		while true do
			if (((1322 - 771) <= (226 + 455)) and (v121 == (0 - 0))) then
				if (((5247 - 1970) > (1235 - 828)) and v81.DemonSpikes:IsCastable() and v59 and v14:BuffDown(v81.DemonSpikesBuff) and v14:BuffDown(v81.MetamorphosisBuff) and (((v93 == (1269 - (1249 + 19))) and v14:BuffDown(v81.FieryBrandDebuff)) or (v93 > (1 + 0)))) then
					if (((18275 - 13580) >= (2501 - (686 + 400))) and (v81.DemonSpikes:ChargesFractional() > (1.9 + 0))) then
						if (v20(v81.DemonSpikes) or ((3441 - (73 + 156)) <= (5 + 939))) then
							return "demon_spikes defensives (Capped)";
						end
					elseif (v90 or (v14:HealthPercentage() <= v62) or ((3907 - (721 + 90)) <= (21 + 1777))) then
						if (((11483 - 7946) == (4007 - (224 + 246))) and v20(v81.DemonSpikes)) then
							return "demon_spikes defensives (Danger)";
						end
					end
				end
				if (((6215 - 2378) >= (2890 - 1320)) and v81.Metamorphosis:IsCastable() and v61 and (v14:HealthPercentage() <= v64) and (v14:BuffDown(v81.MetamorphosisBuff) or (v15:TimeToDie() < (3 + 12)))) then
					if (v20(v83.MetamorphosisPlayer) or ((71 + 2879) == (2800 + 1012))) then
						return "metamorphosis defensives";
					end
				end
				v121 = 1 - 0;
			end
			if (((15717 - 10994) >= (2831 - (203 + 310))) and (v121 == (1995 - (1238 + 755)))) then
				if ((v73 and (v14:HealthPercentage() <= v75)) or ((142 + 1885) > (4386 - (709 + 825)))) then
					local v192 = 0 - 0;
					while true do
						if ((v192 == (0 - 0)) or ((2000 - (196 + 668)) > (17044 - 12727))) then
							if (((9834 - 5086) == (5581 - (171 + 662))) and (v77 == "Refreshing Healing Potion")) then
								if (((3829 - (4 + 89)) <= (16613 - 11873)) and v82.RefreshingHealingPotion:IsReady()) then
									if (v20(v83.RefreshingHealingPotion) or ((1235 + 2155) <= (13440 - 10380))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v77 == "Dreamwalker's Healing Potion") or ((392 + 607) > (4179 - (35 + 1451)))) then
								if (((1916 - (28 + 1425)) < (2594 - (941 + 1052))) and v82.DreamwalkersHealingPotion:IsReady()) then
									if (v20(v83.RefreshingHealingPotion) or ((2094 + 89) < (2201 - (822 + 692)))) then
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
			if (((6493 - 1944) == (2143 + 2406)) and (v121 == (298 - (45 + 252)))) then
				if (((4623 + 49) == (1608 + 3064)) and v81.FieryBrand:IsCastable() and v60 and (v90 or (v14:HealthPercentage() <= v63))) then
					if (v20(v81.FieryBrand, not v15:IsSpellInRange(v81.FieryBrand)) or ((8926 - 5258) < (828 - (114 + 319)))) then
						return "fiery_brand defensives";
					end
				end
				if ((v82.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v76)) or ((5980 - 1814) == (583 - 128))) then
					if (v20(v83.Healthstone) or ((2837 + 1612) == (3967 - 1304))) then
						return "healthstone defensive";
					end
				end
				v121 = 3 - 1;
			end
		end
	end
	local function v105()
		if ((v81.SigilOfChains:IsCastable() and v47 and not v14:IsMoving() and v81.CycleofBinding:IsAvailable() and v81.SigilOfChains:IsAvailable()) or ((6240 - (556 + 1407)) < (4195 - (741 + 465)))) then
			if ((v78 == "player") or v81.ConcentratedSigils:IsAvailable() or ((1335 - (170 + 295)) >= (2187 + 1962))) then
				if (((2032 + 180) < (7836 - 4653)) and v20(v83.SigilOfChainsPlayer, not v15:IsInMeleeRange(7 + 1))) then
					return "sigil_of_chains player filler 2";
				end
			elseif (((2980 + 1666) > (1695 + 1297)) and (v78 == "cursor")) then
				if (((2664 - (957 + 273)) < (831 + 2275)) and v20(v83.SigilOfChainsCursor, not v15:IsInRange(13 + 17))) then
					return "sigil_of_chains cursor filler 2";
				end
			end
		end
		if (((2994 - 2208) < (7966 - 4943)) and v81.SigilOfMisery:IsCastable() and v48 and not v14:IsMoving() and v81.CycleofBinding:IsAvailable() and v81.SigilOfMisery:IsAvailable()) then
			if ((v78 == "player") or v81.ConcentratedSigils:IsAvailable() or ((7458 - 5016) < (366 - 292))) then
				if (((6315 - (389 + 1391)) == (2846 + 1689)) and v20(v83.SigilOfMiseryPlayer, not v15:IsInMeleeRange(1 + 7))) then
					return "sigil_of_misery player filler 4";
				end
			elseif ((v78 == "cursor") or ((6850 - 3841) <= (3056 - (783 + 168)))) then
				if (((6141 - 4311) < (3609 + 60)) and v20(v83.SigilOfMiseryCursor, not v15:IsInRange(341 - (309 + 2)))) then
					return "sigil_of_misery cursor filler 4";
				end
			end
		end
		if ((v81.SigilOfSilence:IsCastable() and v46 and not v14:IsMoving() and v81.CycleofBinding:IsAvailable() and v81.SigilOfSilence:IsAvailable()) or ((4391 - 2961) >= (4824 - (1090 + 122)))) then
			if (((870 + 1813) >= (8261 - 5801)) and ((v78 == "player") or v81.ConcentratedSigils:IsAvailable())) then
				if (v20(v83.SigilOfSilencePlayer, not v15:IsInMeleeRange(6 + 2)) or ((2922 - (628 + 490)) >= (588 + 2687))) then
					return "sigil_of_silence player filler 6";
				end
			elseif ((v78 == "cursor") or ((3507 - 2090) > (16584 - 12955))) then
				if (((5569 - (431 + 343)) > (811 - 409)) and v20(v83.SigilOfSilenceCursor, not v15:IsInRange(86 - 56))) then
					return "sigil_of_silence cursor filler 6";
				end
			end
		end
		if (((3803 + 1010) > (456 + 3109)) and v81.ThrowGlaive:IsCastable() and v43) then
			if (((5607 - (556 + 1139)) == (3927 - (6 + 9))) and v20(v81.ThrowGlaive, not v15:IsSpellInRange(v81.ThrowGlaive))) then
				return "throw_glaive filler 8";
			end
		end
	end
	local function v106()
		local v122 = 0 + 0;
		local v123;
		while true do
			if (((1446 + 1375) <= (4993 - (28 + 141))) and (v122 == (0 + 0))) then
				if (((2144 - 406) <= (1555 + 640)) and v81.FelDevastation:IsReady() and (v70 < v96) and v50 and ((v32 and v54) or not v54) and (v81.CollectiveAnguish:IsAvailable() or v81.StoketheFlames:IsAvailable())) then
					if (((1358 - (486 + 831)) <= (7853 - 4835)) and v20(v81.FelDevastation, not v15:IsInMeleeRange(27 - 19))) then
						return "fel_devastation big_aoe 2";
					end
				end
				if (((406 + 1739) <= (12976 - 8872)) and v81.TheHunt:IsCastable() and (v70 < v96) and v52 and ((v32 and v56) or not v56)) then
					if (((3952 - (668 + 595)) < (4360 + 485)) and v20(v81.TheHunt, not v15:IsInRange(11 + 39))) then
						return "the_hunt big_aoe 4";
					end
				end
				if ((v81.ElysianDecree:IsCastable() and (v70 < v96) and v49 and not v14:IsMoving() and ((v32 and v53) or not v53) and (v93 > v58)) or ((6332 - 4010) > (2912 - (23 + 267)))) then
					if ((v57 == "player") or ((6478 - (1129 + 815)) == (2469 - (371 + 16)))) then
						if (v20(v83.ElysianDecreePlayer, not v15:IsInMeleeRange(1758 - (1326 + 424))) or ((2975 - 1404) > (6822 - 4955))) then
							return "elysian_decree big_aoe 6 (Player)";
						end
					elseif ((v57 == "cursor") or ((2772 - (88 + 30)) >= (3767 - (720 + 51)))) then
						if (((8848 - 4870) > (3880 - (421 + 1355))) and v20(v83.ElysianDecreeCursor, not v15:IsInRange(49 - 19))) then
							return "elysian_decree big_aoe 6 (Cursor)";
						end
					end
				end
				if (((1472 + 1523) > (2624 - (286 + 797))) and v81.FelDevastation:IsReady() and (v70 < v96) and v50 and ((v32 and v54) or not v54)) then
					if (((11877 - 8628) > (1577 - 624)) and v20(v81.FelDevastation, not v15:IsInMeleeRange(447 - (397 + 42)))) then
						return "fel_devastation big_aoe 8";
					end
				end
				v122 = 1 + 0;
			end
			if ((v122 == (802 - (24 + 776))) or ((5042 - 1769) > (5358 - (222 + 563)))) then
				if ((v81.SoulCleave:IsReady() and (v85 < (1 - 0)) and v41) or ((2269 + 882) < (1474 - (23 + 167)))) then
					if (v20(v81.SoulCleave, not v88) or ((3648 - (690 + 1108)) == (552 + 977))) then
						return "soul_cleave big_aoe 18";
					end
				end
				v123 = v105();
				if (((678 + 143) < (2971 - (40 + 808))) and v123) then
					return v123;
				end
				break;
			end
			if (((149 + 753) < (8890 - 6565)) and (v122 == (1 + 0))) then
				if (((454 + 404) <= (1625 + 1337)) and v81.SoulCarver:IsCastable() and v51 and ((v32 and v55) or not v55)) then
					if (v20(v81.SoulCarver, not v88) or ((4517 - (47 + 524)) < (836 + 452))) then
						return "soul_carver big_aoe 10";
					end
				end
				if ((v81.SpiritBomb:IsReady() and (v85 >= (10 - 6)) and v42) or ((4847 - 1605) == (1292 - 725))) then
					if (v20(v81.SpiritBomb, not v15:IsInMeleeRange(1734 - (1165 + 561))) or ((26 + 821) >= (3911 - 2648))) then
						return "spirit_bomb big_aoe 12";
					end
				end
				if ((v81.Fracture:IsCastable() and v36) or ((860 + 1393) == (2330 - (341 + 138)))) then
					if (v20(v81.Fracture, not v88) or ((564 + 1523) > (4894 - 2522))) then
						return "fracture big_aoe 14";
					end
				end
				if ((v81.Shear:IsCastable() and v39) or ((4771 - (89 + 237)) < (13347 - 9198))) then
					if (v20(v81.Shear, not v88) or ((3827 - 2009) == (966 - (581 + 300)))) then
						return "shear big_aoe 16";
					end
				end
				v122 = 1222 - (855 + 365);
			end
		end
	end
	local function v107()
		local v124 = 0 - 0;
		while true do
			if (((206 + 424) < (3362 - (1030 + 205))) and (v124 == (1 + 0))) then
				if ((v81.SoulCarver:IsCastable() and v51 and ((v32 and v55) or not v55)) or ((1803 + 135) == (2800 - (156 + 130)))) then
					if (((9668 - 5413) >= (92 - 37)) and v20(v81.SoulCarver, not v15:IsInMeleeRange(16 - 8))) then
						return "soul_carver fiery_demise 10";
					end
				end
				if (((791 + 2208) > (675 + 481)) and v81.SpiritBomb:IsReady() and (v93 == (70 - (10 + 59))) and (v85 >= (2 + 3)) and v42) then
					if (((11573 - 9223) > (2318 - (671 + 492))) and v20(v81.SpiritBomb, not v15:IsInMeleeRange(7 + 1))) then
						return "spirit_bomb fiery_demise 12";
					end
				end
				if (((5244 - (369 + 846)) <= (1285 + 3568)) and v81.SpiritBomb:IsReady() and (v93 > (1 + 0)) and (v93 <= (1950 - (1036 + 909))) and (v85 >= (4 + 0)) and v42) then
					if (v20(v81.SpiritBomb, not v15:IsInMeleeRange(13 - 5)) or ((719 - (11 + 192)) > (1736 + 1698))) then
						return "spirit_bomb fiery_demise 14";
					end
				end
				if (((4221 - (135 + 40)) >= (7348 - 4315)) and v81.SpiritBomb:IsReady() and (v93 >= (4 + 2)) and (v85 >= (6 - 3)) and v42) then
					if (v20(v81.SpiritBomb, not v15:IsInMeleeRange(11 - 3)) or ((2895 - (50 + 126)) <= (4029 - 2582))) then
						return "spirit_bomb fiery_demise 16";
					end
				end
				v124 = 1 + 1;
			end
			if ((v124 == (1415 - (1233 + 180))) or ((5103 - (522 + 447)) < (5347 - (107 + 1314)))) then
				if ((v81.TheHunt:IsCastable() and v52 and ((v32 and v56) or not v56) and (v70 < v96)) or ((77 + 87) >= (8486 - 5701))) then
					if (v20(v81.TheHunt, not v15:IsInRange(13 + 17)) or ((1042 - 517) == (8344 - 6235))) then
						return "the_hunt fiery_demise 18";
					end
				end
				if (((1943 - (716 + 1194)) == (1 + 32)) and v81.ElysianDecree:IsCastable() and v49 and not v14:IsMoving() and ((v32 and v53) or not v53) and (v70 < v96) and (v93 > v58)) then
					if (((328 + 2726) <= (4518 - (74 + 429))) and (v57 == "player")) then
						if (((3609 - 1738) < (1677 + 1705)) and v20(v83.ElysianDecreePlayer, not v15:IsInMeleeRange(18 - 10))) then
							return "elysian_decree fiery_demise 20 (Player)";
						end
					elseif (((915 + 378) <= (6677 - 4511)) and (v57 == "cursor")) then
						if (v20(v83.ElysianDecreeCursor, not v15:IsInRange(74 - 44)) or ((3012 - (279 + 154)) < (901 - (454 + 324)))) then
							return "elysian_decree fiery_demise 20 (Cursor)";
						end
					end
				end
				if ((v81.SoulCleave:IsReady() and (v14:FuryDeficit() <= (24 + 6)) and not v94 and v41) or ((863 - (12 + 5)) >= (1277 + 1091))) then
					if (v20(v81.SoulCleave, not v88) or ((10222 - 6210) <= (1241 + 2117))) then
						return "soul_cleave fiery_demise 22";
					end
				end
				break;
			end
			if (((2587 - (277 + 816)) <= (12840 - 9835)) and (v124 == (1183 - (1058 + 125)))) then
				if ((v81.ImmolationAura:IsCastable() and v37) or ((584 + 2527) == (3109 - (815 + 160)))) then
					if (((10104 - 7749) == (5590 - 3235)) and v20(v81.ImmolationAura, not v15:IsInMeleeRange(2 + 6))) then
						return "immolation_aura fiery_demise 2";
					end
				end
				if ((v81.SigilOfFlame:IsCastable() and v40 and not v14:IsMoving() and (v89 or not v81.ConcentratedSigils:IsAvailable()) and v15:DebuffRefreshable(v81.SigilOfFlameDebuff)) or ((1718 - 1130) <= (2330 - (41 + 1857)))) then
					if (((6690 - (1222 + 671)) >= (10066 - 6171)) and (v81.ConcentratedSigils:IsAvailable() or (v78 == "player"))) then
						if (((5141 - 1564) == (4759 - (229 + 953))) and v20(v83.SigilOfFlamePlayer, not v15:IsInMeleeRange(1782 - (1111 + 663)))) then
							return "sigil_of_flame fiery_demise 4 (Player)";
						end
					elseif (((5373 - (874 + 705)) > (517 + 3176)) and (v78 == "cursor")) then
						if (v20(v83.SigilOfFlameCursor, not v15:IsInRange(21 + 9)) or ((2650 - 1375) == (116 + 3984))) then
							return "sigil_of_flame fiery_demise 4 (Cursor)";
						end
					end
				end
				if ((v81.Felblade:IsCastable() and v35 and (v81.FelDevastation:CooldownRemains() <= (v81.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (729 - (642 + 37)))) or ((363 + 1228) >= (573 + 3007))) then
					if (((2467 - 1484) <= (2262 - (233 + 221))) and v20(v81.Felblade, not v88)) then
						return "felblade fiery_demise 6";
					end
				end
				if ((v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96)) or ((4971 - 2821) <= (1054 + 143))) then
					if (((5310 - (718 + 823)) >= (739 + 434)) and v20(v81.FelDevastation, not v15:IsInMeleeRange(813 - (266 + 539)))) then
						return "fel_devastation fiery_demise 8";
					end
				end
				v124 = 2 - 1;
			end
		end
	end
	local function v108()
		local v125 = 1225 - (636 + 589);
		while true do
			if (((3525 - 2040) == (3062 - 1577)) and (v125 == (4 + 0))) then
				if ((v81.SpiritBomb:IsReady() and (v14:FuryDeficit() < (11 + 19)) and (((v93 >= (1017 - (657 + 358))) and (v85 >= (13 - 8))) or ((v93 >= (13 - 7)) and (v85 >= (1191 - (1151 + 36))))) and not v94 and v42) or ((3202 + 113) <= (732 + 2050))) then
					if (v20(v81.SpiritBomb, not v15:IsInMeleeRange(23 - 15)) or ((2708 - (1552 + 280)) >= (3798 - (64 + 770)))) then
						return "spirit_bomb maintenance 18";
					end
				end
				if ((v81.SoulCleave:IsReady() and (v14:FuryDeficit() < (21 + 9)) and (v85 <= (6 - 3)) and not v94 and v41) or ((397 + 1835) > (3740 - (157 + 1086)))) then
					if (v20(v81.SoulCleave, not v88) or ((4223 - 2113) <= (1453 - 1121))) then
						return "soul_cleave maintenance 20";
					end
				end
				break;
			end
			if (((5653 - 1967) > (4328 - 1156)) and (v125 == (819 - (599 + 220)))) then
				if ((v81.FieryBrand:IsCastable() and v79 and v60 and ((v15:DebuffDown(v81.FieryBrandDebuff) and ((v81.SigilOfFlame:CooldownRemains() < (v81.SigilOfFlame:ExecuteTime() + v14:GCDRemains())) or (v81.SoulCarver:CooldownRemains() < (v81.SoulCarver:ExecuteTime() + v14:GCDRemains())) or (v81.FelDevastation:CooldownRemains() < (v81.FelDevastation:ExecuteTime() + v14:GCDRemains())))) or (v81.DownInFlames:IsAvailable() and (v81.FieryBrand:FullRechargeTime() < (v81.FieryBrand:ExecuteTime() + v14:GCDRemains()))))) or ((8909 - 4435) < (2751 - (1813 + 118)))) then
					if (((3128 + 1151) >= (4099 - (841 + 376))) and v20(v81.FieryBrand, not v15:IsSpellInRange(v81.FieryBrand))) then
						return "fiery_brand maintenance 2";
					end
				end
				if ((v81.SigilOfFlame:IsCastable() and not v14:IsMoving()) or ((2842 - 813) >= (818 + 2703))) then
					if (v81.ConcentratedSigils:IsAvailable() or (v78 == "player") or ((5559 - 3522) >= (5501 - (464 + 395)))) then
						if (((4414 - 2694) < (2141 + 2317)) and v20(v83.SigilOfFlamePlayer, not v15:IsInMeleeRange(845 - (467 + 370)))) then
							return "sigil_of_flame maintenance 4 (Player)";
						end
					elseif ((v78 == "cursor") or ((900 - 464) > (2218 + 803))) then
						if (((2444 - 1731) <= (133 + 714)) and v20(v83.SigilOfFlameCursor, not v15:IsInRange(69 - 39))) then
							return "sigil_of_flame maintenance 4 (Cursor)";
						end
					end
				end
				v125 = 521 - (150 + 370);
			end
			if (((3436 - (74 + 1208)) <= (9914 - 5883)) and (v125 == (9 - 7))) then
				if (((3284 + 1331) == (5005 - (14 + 376))) and v81.BulkExtraction:IsCastable() and v33 and v14:PrevGCD(1 - 0, v81.SpiritBomb)) then
					if (v20(v81.BulkExtraction, not v88) or ((2453 + 1337) == (440 + 60))) then
						return "bulk_extraction maintenance 10";
					end
				end
				if (((85 + 4) < (647 - 426)) and v81.Felblade:IsCastable() and v35 and (v14:FuryDeficit() >= (31 + 9))) then
					if (((2132 - (23 + 55)) >= (3367 - 1946)) and v20(v81.Felblade, not v88)) then
						return "felblade maintenance 12";
					end
				end
				v125 = 3 + 0;
			end
			if (((622 + 70) < (4740 - 1682)) and (v125 == (1 + 2))) then
				if ((v81.Fracture:IsCastable() and v36 and (v81.FelDevastation:CooldownRemains() <= (v81.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (951 - (652 + 249)))) or ((8708 - 5454) == (3523 - (708 + 1160)))) then
					if (v20(v81.Fracture, not v88) or ((3517 - 2221) == (8951 - 4041))) then
						return "fracture maintenance 14";
					end
				end
				if (((3395 - (10 + 17)) == (757 + 2611)) and v81.Shear:IsCastable() and v39 and (v81.FelDevastation:CooldownRemains() <= (v81.FelDevastation:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (1782 - (1400 + 332)))) then
					if (((5069 - 2426) < (5723 - (242 + 1666))) and v20(v81.Shear, not v88)) then
						return "shear maintenance 16";
					end
				end
				v125 = 2 + 2;
			end
			if (((702 + 1211) > (421 + 72)) and (v125 == (941 - (850 + 90)))) then
				if (((8327 - 3572) > (4818 - (360 + 1030))) and v81.SpiritBomb:IsReady() and (v85 >= (5 + 0)) and v42) then
					if (((3897 - 2516) <= (3258 - 889)) and v20(v81.SpiritBomb, not v15:IsInMeleeRange(1669 - (909 + 752)))) then
						return "spirit_bomb maintenance 6";
					end
				end
				if ((v81.ImmolationAura:IsCastable() and v37) or ((6066 - (109 + 1114)) == (7476 - 3392))) then
					if (((1818 + 2851) > (605 - (6 + 236))) and v20(v81.ImmolationAura, not v15:IsInMeleeRange(6 + 2))) then
						return "immolation_aura maintenance 8";
					end
				end
				v125 = 2 + 0;
			end
		end
	end
	local function v109()
		if ((v81.TheHunt:IsCastable() and v52 and ((v32 and v56) or not v56) and (v70 < v96)) or ((4426 - 2549) >= (5480 - 2342))) then
			if (((5875 - (1076 + 57)) >= (597 + 3029)) and v20(v81.TheHunt, not v15:IsInRange(719 - (579 + 110)))) then
				return "the_hunt single_target 2";
			end
		end
		if ((v81.SoulCarver:IsCastable() and v51 and ((v32 and v55) or not v55)) or ((359 + 4181) == (810 + 106))) then
			if (v20(v81.SoulCarver, not v88) or ((614 + 542) > (4752 - (174 + 233)))) then
				return "soul_carver single_target 4";
			end
		end
		if (((6248 - 4011) < (7457 - 3208)) and v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96) and (v81.CollectiveAnguish:IsAvailable() or (v81.StoketheFlames:IsAvailable() and v81.BurningBlood:IsAvailable()))) then
			if (v20(v81.FelDevastation, not v15:IsInMeleeRange(4 + 4)) or ((3857 - (663 + 511)) < (21 + 2))) then
				return "fel_devastation single_target 6";
			end
		end
		if (((152 + 545) <= (2546 - 1720)) and v81.ElysianDecree:IsCastable() and v49 and not v14:IsMoving() and ((v32 and v53) or not v53) and (v70 < v96) and (v93 > v58)) then
			if (((670 + 435) <= (2768 - 1592)) and (v57 == "player")) then
				if (((8179 - 4800) <= (1820 + 1992)) and v20(v83.ElysianDecreePlayer, not v15:IsInMeleeRange(15 - 7))) then
					return "elysian_decree single_target 8 (Player)";
				end
			elseif ((v57 == "cursor") or ((562 + 226) >= (148 + 1468))) then
				if (((2576 - (478 + 244)) <= (3896 - (440 + 77))) and v20(v83.ElysianDecreeCursor, not v15:IsInRange(14 + 16))) then
					return "elysian_decree single_target 8 (Cursor)";
				end
			end
		end
		if (((16649 - 12100) == (6105 - (655 + 901))) and v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96)) then
			if (v20(v81.FelDevastation, not v15:IsInMeleeRange(2 + 6)) or ((2314 + 708) >= (2042 + 982))) then
				return "fel_devastation single_target 10";
			end
		end
		if (((19418 - 14598) > (3643 - (695 + 750))) and v81.SoulCleave:IsReady() and v81.FocusedCleave:IsAvailable() and not v94 and v41) then
			if (v20(v81.SoulCleave, not v88) or ((3622 - 2561) >= (7547 - 2656))) then
				return "soul_cleave single_target 12";
			end
		end
		if (((5485 - 4121) <= (4824 - (285 + 66))) and v81.Fracture:IsCastable() and v36) then
			if (v20(v81.Fracture, not v88) or ((8380 - 4785) <= (1313 - (682 + 628)))) then
				return "fracture single_target 14";
			end
		end
		if ((v81.Shear:IsCastable() and v39) or ((754 + 3918) == (4151 - (176 + 123)))) then
			if (((653 + 906) == (1131 + 428)) and v20(v81.Shear, not v88)) then
				return "shear single_target 16";
			end
		end
		if ((v81.SoulCleave:IsReady() and not v94 and v41) or ((2021 - (239 + 30)) <= (215 + 573))) then
			if (v20(v81.SoulCleave, not v88) or ((3756 + 151) == (313 - 136))) then
				return "soul_cleave single_target 18";
			end
		end
		v29 = v105();
		if (((10826 - 7356) > (870 - (306 + 9))) and v29) then
			return v29;
		end
	end
	local function v110()
		if ((v81.TheHunt:IsCastable() and v52 and ((v32 and v56) or not v56) and (v70 < v96)) or ((3391 - 2419) == (113 + 532))) then
			if (((1953 + 1229) >= (1019 + 1096)) and v20(v81.TheHunt, not v15:IsInRange(85 - 55))) then
				return "the_hunt small_aoe 2";
			end
		end
		if (((5268 - (1140 + 235)) < (2819 + 1610)) and v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96) and (v81.CollectiveAnguish:IsAvailable() or (v81.StoketheFlames:IsAvailable() and v81.BurningBlood:IsAvailable()))) then
			if (v20(v81.FelDevastation, not v15:IsInMeleeRange(8 + 0)) or ((736 + 2131) < (1957 - (33 + 19)))) then
				return "fel_devastation small_aoe 4";
			end
		end
		if ((v81.ElysianDecree:IsCastable() and v49 and not v14:IsMoving() and ((v32 and v53) or not v53) and (v70 < v96) and (v93 > v58)) or ((649 + 1147) >= (12141 - 8090))) then
			if (((714 + 905) <= (7365 - 3609)) and (v57 == "player")) then
				if (((567 + 37) == (1293 - (586 + 103))) and v20(v83.ElysianDecreePlayer, not v15:IsInMeleeRange(1 + 7))) then
					return "elysian_decree small_aoe 6 (Player)";
				end
			elseif ((v57 == "cursor") or ((13804 - 9320) == (2388 - (1309 + 179)))) then
				if (v20(v83.ElysianDecreeCursor, not v15:IsInRange(54 - 24)) or ((1941 + 2518) <= (2988 - 1875))) then
					return "elysian_decree small_aoe 6 (Cursor)";
				end
			end
		end
		if (((2744 + 888) > (7219 - 3821)) and v81.FelDevastation:IsReady() and v50 and ((v32 and v54) or not v54) and (v70 < v96)) then
			if (((8133 - 4051) <= (5526 - (295 + 314))) and v20(v81.FelDevastation, not v15:IsInMeleeRange(19 - 11))) then
				return "fel_devastation small_aoe 8";
			end
		end
		if (((6794 - (1300 + 662)) >= (4352 - 2966)) and v81.SoulCarver:IsCastable() and v51 and ((v32 and v55) or not v55)) then
			if (((1892 - (1178 + 577)) == (72 + 65)) and v20(v81.SoulCarver, not v88)) then
				return "soul_carver small_aoe 10";
			end
		end
		if ((v81.SpiritBomb:IsReady() and (v85 >= (14 - 9)) and v42) or ((2975 - (851 + 554)) >= (3831 + 501))) then
			if (v20(v81.SpiritBomb, not v15:IsInMeleeRange(22 - 14)) or ((8826 - 4762) <= (2121 - (115 + 187)))) then
				return "spirit_bomb small_aoe 12";
			end
		end
		if ((v81.SoulCleave:IsReady() and v81.FocusedCleave:IsAvailable() and (v85 <= (2 + 0)) and v41) or ((4721 + 265) < (6202 - 4628))) then
			if (((5587 - (160 + 1001)) > (151 + 21)) and v20(v81.SoulCleave, not v88)) then
				return "soul_cleave small_aoe 14";
			end
		end
		if (((405 + 181) > (931 - 476)) and v81.Fracture:IsCastable() and v36) then
			if (((1184 - (237 + 121)) == (1723 - (525 + 372))) and v20(v81.Fracture, not v88)) then
				return "fracture small_aoe 16";
			end
		end
		if ((v81.Shear:IsCastable() and v39) or ((7619 - 3600) > (14591 - 10150))) then
			if (((2159 - (96 + 46)) < (5038 - (643 + 134))) and v20(v81.Shear, not v88)) then
				return "shear small_aoe 18";
			end
		end
		if (((1703 + 3013) > (191 - 111)) and v81.SoulCleave:IsReady() and (v85 <= (7 - 5)) and v41) then
			if (v20(v81.SoulCleave, not v88) or ((3364 + 143) == (6421 - 3149))) then
				return "soul_cleave small_aoe 20";
			end
		end
		v29 = v105();
		if (v29 or ((1790 - 914) >= (3794 - (316 + 403)))) then
			return v29;
		end
	end
	local function v111()
		local v126 = 0 + 0;
		while true do
			if (((11965 - 7613) > (924 + 1630)) and (v126 == (7 - 4))) then
				v51 = EpicSettings.Settings['useSoulCarver'];
				v52 = EpicSettings.Settings['useTheHunt'];
				v53 = EpicSettings.Settings['elysianDecreeWithCD'];
				v54 = EpicSettings.Settings['felDevastationWithCD'];
				v55 = EpicSettings.Settings['soulCarverWithCD'];
				v56 = EpicSettings.Settings['theHuntWithCD'];
				v126 = 3 + 1;
			end
			if ((v126 == (1 + 0)) or ((15266 - 10860) < (19308 - 15265))) then
				v39 = EpicSettings.Settings['useShear'];
				v40 = EpicSettings.Settings['useSigilOfFlame'];
				v41 = EpicSettings.Settings['useSoulCleave'];
				v42 = EpicSettings.Settings['useSpiritBomb'];
				v43 = EpicSettings.Settings['useThrowGlaive'];
				v44 = EpicSettings.Settings['useChaosNova'];
				v126 = 3 - 1;
			end
			if ((v126 == (1 + 1)) or ((3718 - 1829) >= (166 + 3217))) then
				v45 = EpicSettings.Settings['useDisrupt'];
				v46 = EpicSettings.Settings['useSigilOfSilence'];
				v47 = EpicSettings.Settings['useSigilOfChains'];
				v48 = EpicSettings.Settings['useSigilOfMisery'];
				v49 = EpicSettings.Settings['useElysianDecree'];
				v50 = EpicSettings.Settings['useFelDevastation'];
				v126 = 8 - 5;
			end
			if (((1909 - (12 + 5)) <= (10618 - 7884)) and (v126 == (10 - 5))) then
				v78 = EpicSettings.Settings['sigilSetting'] or "player";
				v57 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v58 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
				v79 = EpicSettings.Settings['fieryBrandOffensively'];
				v80 = EpicSettings.Settings['metamorphosisOffensively'];
				break;
			end
			if (((4768 - 2845) < (451 + 1767)) and (v126 == (1973 - (1656 + 317)))) then
				v33 = EpicSettings.Settings['useBulkExtraction'];
				v34 = EpicSettings.Settings['useConsumeMagic'];
				v35 = EpicSettings.Settings['useFelblade'];
				v36 = EpicSettings.Settings['useFracture'];
				v37 = EpicSettings.Settings['useImmolationAura'];
				v38 = EpicSettings.Settings['useInfernalStrike'];
				v126 = 1 + 0;
			end
			if (((1742 + 431) > (1007 - 628)) and (v126 == (19 - 15))) then
				v59 = EpicSettings.Settings['useDemonSpikes'];
				v60 = EpicSettings.Settings['useFieryBrand'];
				v61 = EpicSettings.Settings['useMetamorphosis'];
				v62 = EpicSettings.Settings['demonSpikesHP'] or (354 - (5 + 349));
				v63 = EpicSettings.Settings['fieryBrandHP'] or (0 - 0);
				v64 = EpicSettings.Settings['metamorphosisHP'] or (1271 - (266 + 1005));
				v126 = 4 + 1;
			end
		end
	end
	local function v112()
		local v127 = 0 - 0;
		while true do
			if ((v127 == (2 - 0)) or ((4287 - (561 + 1135)) == (4441 - 1032))) then
				v73 = EpicSettings.Settings['useHealingPotion'];
				v76 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v75 = EpicSettings.Settings['healingPotionHP'] or (1066 - (507 + 559));
				v77 = EpicSettings.Settings['HealingPotionName'] or "";
				v127 = 7 - 4;
			end
			if (((13960 - 9446) > (3712 - (212 + 176))) and (v127 == (905 - (250 + 655)))) then
				v70 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v65 = EpicSettings.Settings['dispelBuffs'];
				v67 = EpicSettings.Settings['InterruptWithStun'];
				v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v127 = 1 - 0;
			end
			if (((1 - 0) == v127) or ((2164 - (1869 + 87)) >= (16745 - 11917))) then
				v69 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['useTrinkets'];
				v72 = EpicSettings.Settings['trinketsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v127 = 1903 - (484 + 1417);
			end
			if (((6 - 3) == v127) or ((2652 - 1069) > (4340 - (48 + 725)))) then
				v66 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v113()
		v111();
		v112();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		if (v14:IsDeadOrGhost() or ((2144 - 831) == (2130 - 1336))) then
			return v29;
		end
		v92 = v14:GetEnemiesInMeleeRange(5 + 3);
		if (((8482 - 5308) > (813 + 2089)) and v31) then
			v93 = #v92;
		else
			v93 = 1 + 0;
		end
		v98();
		v99();
		v90 = v14:ActiveMitigationNeeded();
		v91 = v14:IsTankingAoE(861 - (152 + 701)) or v14:IsTanking(v15);
		if (((5431 - (430 + 881)) <= (1632 + 2628)) and (v22.TargetIsValid() or v14:AffectingCombat())) then
			v95 = v10.BossFightRemains(nil, true);
			v96 = v95;
			if ((v96 == (12006 - (557 + 338))) or ((261 + 622) > (13464 - 8686))) then
				v96 = v10.FightRemains(v92, false);
			end
		end
		if (v66 or ((12676 - 9056) >= (12994 - 8103))) then
			local v137 = 0 - 0;
			while true do
				if (((5059 - (499 + 302)) > (1803 - (39 + 827))) and ((0 - 0) == v137)) then
					v29 = v22.HandleIncorporeal(v81.Imprison, v83.ImprisonMouseover, 44 - 24);
					if (v29 or ((19338 - 14469) < (1390 - 484))) then
						return v29;
					end
					break;
				end
			end
		end
		if ((v22.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((105 + 1120) > (12374 - 8146))) then
			v94 = (v81.FelDevastation:CooldownRemains() < (v81.SoulCleave:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < (8 + 42));
			if (((5266 - 1938) > (2342 - (103 + 1))) and v81.ThrowGlaive:IsCastable() and v43 and v12.ValueIsInArray(v97, v15:NPCID())) then
				if (((4393 - (475 + 79)) > (3037 - 1632)) and v20(v81.ThrowGlaive, not v15:IsSpellInRange(v81.ThrowGlaive))) then
					return "fodder to the flames on those filthy demons";
				end
			end
			if ((v81.ThrowGlaive:IsReady() and v43 and v12.ValueIsInArray(v97, v16:NPCID())) or ((4137 - 2844) <= (66 + 441))) then
				if (v20(v83.ThrowGlaiveMouseover, not v15:IsSpellInRange(v81.ThrowGlaive)) or ((2549 + 347) < (2308 - (1395 + 108)))) then
					return "fodder to the flames react per mouseover";
				end
			end
			if (((6739 - 4423) == (3520 - (7 + 1197))) and not v14:AffectingCombat() and v30) then
				local v181 = 0 + 0;
				while true do
					if ((v181 == (0 + 0)) or ((2889 - (27 + 292)) == (4491 - 2958))) then
						v29 = v103();
						if (v29 or ((1125 - 242) == (6122 - 4662))) then
							return v29;
						end
						break;
					end
				end
			end
			if ((v81.ConsumeMagic:IsAvailable() and v34 and v81.ConsumeMagic:IsReady() and v65 and not v14:IsCasting() and not v14:IsChanneling() and v22.UnitHasMagicBuff(v15)) or ((9108 - 4489) <= (1901 - 902))) then
				if (v20(v81.ConsumeMagic, not v15:IsSpellInRange(v81.ConsumeMagic)) or ((3549 - (43 + 96)) > (16789 - 12673))) then
					return "greater_purge damage";
				end
			end
			if (v91 or ((2041 - 1138) >= (2539 + 520))) then
				local v182 = 0 + 0;
				while true do
					if (((0 - 0) == v182) or ((1524 + 2452) < (5353 - 2496))) then
						v29 = v104();
						if (((1553 + 3377) > (170 + 2137)) and v29) then
							return v29;
						end
						break;
					end
				end
			end
			if ((v81.InfernalStrike:IsCastable() and (v38 or (v81.InfernalStrike:ChargesFractional() > (1752.9 - (1414 + 337)))) and (v81.InfernalStrike:TimeSinceLastCast() > (1942 - (1642 + 298)))) or ((10546 - 6500) < (3713 - 2422))) then
				if (v20(v83.InfernalStrikePlayer, not v15:IsInMeleeRange(23 - 15)) or ((1396 + 2845) == (2759 + 786))) then
					return "infernal_strike main 2";
				end
			end
			if (((v70 < v96) and v81.Metamorphosis:IsCastable() and v61 and v80 and v14:BuffDown(v81.MetamorphosisBuff) and v15:DebuffDown(v81.FieryBrandDebuff)) or ((5020 - (357 + 615)) > (2971 + 1261))) then
				if (v20(v83.MetamorphosisPlayer, not v88) or ((4294 - 2544) >= (2976 + 497))) then
					return "metamorphosis main 4";
				end
			end
			local v138 = v22.HandleDPSPotion();
			if (((6784 - 3618) == (2533 + 633)) and v138) then
				return v138;
			end
			if (((120 + 1643) < (2341 + 1383)) and (v70 < v96)) then
				if (((1358 - (384 + 917)) <= (3420 - (128 + 569))) and v71 and ((v32 and v72) or not v72)) then
					local v193 = 1543 - (1407 + 136);
					while true do
						if ((v193 == (1887 - (687 + 1200))) or ((3780 - (556 + 1154)) == (1558 - 1115))) then
							v29 = v102();
							if (v29 or ((2800 - (9 + 86)) == (1814 - (275 + 146)))) then
								return v29;
							end
							break;
						end
					end
				end
			end
			if ((v81.FieryDemise:IsAvailable() and (v81.FieryBrandDebuff:AuraActiveCount() > (1 + 0))) or ((4665 - (29 + 35)) < (270 - 209))) then
				local v183 = 0 - 0;
				local v184;
				while true do
					if ((v183 == (0 - 0)) or ((906 + 484) >= (5756 - (53 + 959)))) then
						v184 = v107();
						if (v184 or ((2411 - (312 + 96)) > (6653 - 2819))) then
							return v184;
						end
						break;
					end
				end
			end
			local v139 = v108();
			if (v139 or ((441 - (147 + 138)) > (4812 - (813 + 86)))) then
				return v139;
			end
			if (((177 + 18) == (360 - 165)) and (v93 <= (493 - (18 + 474)))) then
				local v185 = 0 + 0;
				local v186;
				while true do
					if (((10134 - 7029) >= (2882 - (860 + 226))) and (v185 == (303 - (121 + 182)))) then
						v186 = v109();
						if (((540 + 3839) >= (3371 - (988 + 252))) and v186) then
							return v186;
						end
						break;
					end
				end
			end
			if (((435 + 3409) >= (640 + 1403)) and (v93 > (1971 - (49 + 1921))) and (v93 <= (895 - (223 + 667)))) then
				local v187 = 52 - (51 + 1);
				local v188;
				while true do
					if (((0 - 0) == v187) or ((6920 - 3688) <= (3856 - (146 + 979)))) then
						v188 = v110();
						if (((1385 + 3520) == (5510 - (311 + 294))) and v188) then
							return v188;
						end
						break;
					end
				end
			end
			if ((v93 >= (16 - 10)) or ((1752 + 2384) >= (5854 - (496 + 947)))) then
				local v189 = 1358 - (1233 + 125);
				local v190;
				while true do
					if (((0 + 0) == v189) or ((2654 + 304) == (764 + 3253))) then
						v190 = v106();
						if (((2873 - (963 + 682)) >= (679 + 134)) and v190) then
							return v190;
						end
						break;
					end
				end
			end
		end
	end
	local function v114()
		local v131 = 1504 - (504 + 1000);
		while true do
			if ((v131 == (0 + 0)) or ((3147 + 308) > (383 + 3667))) then
				v19.Print("Vengeance Demon Hunter by Epic. Supported by xKaneto.");
				v81.FieryBrandDebuff:RegisterAuraTracking();
				break;
			end
		end
	end
	v19.SetAPL(856 - 275, v113, v114);
end;
return v0["Epix_DemonHunter_Vengeance.lua"]();

