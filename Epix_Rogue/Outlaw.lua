local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((6979 - 4480) == (1808 + 691)) and (v5 == (1061 - (810 + 251)))) then
			v6 = v0[v4];
			if (not v6 or ((1565 + 690) < (7 + 15))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (534 - (43 + 490))) or ((1819 - (711 + 22)) >= (5434 - 4029))) then
			return v6(...);
		end
	end
end
v0["Epix_Rogue_Outlaw.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Utils;
	local v13 = v10.Unit;
	local v14 = v13.Player;
	local v15 = v13.Target;
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = v10.Macro;
	local v20 = v10.Commons.Everyone.num;
	local v21 = v10.Commons.Everyone.bool;
	local v22 = math.min;
	local v23 = math.abs;
	local v24 = math.max;
	local v25 = false;
	local v26 = false;
	local v27 = false;
	local v28;
	local v29;
	local v30;
	local v31;
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
	local function v78()
		v28 = EpicSettings.Settings['UseRacials'];
		v30 = EpicSettings.Settings['UseHealingPotion'];
		v31 = EpicSettings.Settings['HealingPotionName'] or (859 - (240 + 619));
		v32 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
		v33 = EpicSettings.Settings['UseHealthstone'];
		v34 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v35 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
		v36 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (1744 - (1344 + 400));
		v37 = EpicSettings.Settings['InterruptThreshold'] or (405 - (255 + 150));
		v51 = EpicSettings.Settings['VanishOffGCD'];
		v52 = EpicSettings.Settings['ShadowDanceOffGCD'];
		v53 = EpicSettings.Settings['ThistleTeaOffGCD'];
		v54 = EpicSettings.Settings['ColdBloodOffGCD'];
		v55 = EpicSettings.Settings['MarkedforDeathOffGCD'];
		v56 = EpicSettings.Settings['CrimsonVialHP'] or (0 + 0);
		v57 = EpicSettings.Settings['FeintHP'] or (0 + 0);
		v58 = EpicSettings.Settings['StealthOOC'];
		v63 = EpicSettings.Settings['RolltheBonesLogic'];
		v66 = EpicSettings.Settings['UseDPSVanish'];
		v69 = EpicSettings.Settings['BladeFlurryGCD'];
		v70 = EpicSettings.Settings['BladeRushGCD'];
		v71 = EpicSettings.Settings['GhostlyStrikeGCD'];
		v73 = EpicSettings.Settings['KeepItRollingGCD'];
		v74 = EpicSettings.Settings['AdrenalineRushOffGCD'];
		v75 = EpicSettings.Settings['EchoingReprimand'];
		v76 = EpicSettings.Settings['UseSoloVanish'];
		v77 = EpicSettings.Settings['sepsis'];
	end
	local v79 = v10.Commons.Everyone;
	local v80 = v10.Commons.Rogue;
	local v81 = v16.Rogue.Outlaw;
	local v82 = v18.Rogue.Outlaw;
	local v83 = v19.Rogue.Outlaw;
	local v84 = {v82.ManicGrieftorch:ID(),v82.DragonfireBombDispenser:ID(),v82.BeaconToTheBeyond:ID()};
	local v85 = v14:GetEquipment();
	local v86 = (v85[419 - (183 + 223)] and v18(v85[15 - 2])) or v18(0 + 0);
	local v87 = (v85[6 + 8] and v18(v85[351 - (10 + 327)])) or v18(0 + 0);
	v10:RegisterForEvent(function()
		v85 = v14:GetEquipment();
		v86 = (v85[351 - (118 + 220)] and v18(v85[5 + 8])) or v18(449 - (108 + 341));
		v87 = (v85[7 + 7] and v18(v85[59 - 45])) or v18(1493 - (711 + 782));
	end, "PLAYER_EQUIPMENT_CHANGED");
	v81.Dispatch:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v80.CPSpend() * (0.3 - 0) * (470 - (270 + 199)) * (1 + 0 + (v14:VersatilityDmgPct() / (1919 - (580 + 1239)))) * ((v15:DebuffUp(v81.GhostlyStrike) and (2.1 - 1)) or (1 + 0));
	end);
	local v88, v89, v90;
	local v91;
	local v92 = 1 + 5;
	local v93;
	local v94, v95, v96;
	local v97, v98, v99, v100, v101;
	local v102 = {{v81.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v103, v104 = 1790 - (1010 + 780), 0 + 0;
	local function v105(v144)
		local v145 = v14:EnergyTimeToMaxPredicted(nil, v144);
		if ((v145 < v103) or ((v145 - v103) > (0.5 - 0)) or ((6942 - 4573) == (2262 - (1045 + 791)))) then
			v103 = v145;
		end
		return v103;
	end
	local function v106()
		local v146 = 0 - 0;
		local v147;
		while true do
			if (((1 - 0) == v146) or ((3581 - (351 + 154)) > (4757 - (1281 + 293)))) then
				return v104;
			end
			if (((1468 - (28 + 238)) > (2363 - 1305)) and (v146 == (1559 - (1381 + 178)))) then
				v147 = v14:EnergyPredicted();
				if (((3481 + 230) > (2706 + 649)) and ((v147 > v104) or ((v147 - v104) > (4 + 5)))) then
					v104 = v147;
				end
				v146 = 3 - 2;
			end
		end
	end
	local v107 = {v81.Broadside,v81.BuriedTreasure,v81.GrandMelee,v81.RuthlessPrecision,v81.SkullandCrossbones,v81.TrueBearing};
	local function v108(v148, v149)
		local v150 = 0 - 0;
		local v151;
		while true do
			if ((v150 == (1784 - (214 + 1570))) or ((2361 - (990 + 465)) >= (919 + 1310))) then
				if (((561 + 727) > (1217 + 34)) and not v11.APLVar.RtB_List) then
					v11.APLVar.RtB_List = {};
				end
				if (not v11.APLVar.RtB_List[v148] or ((17760 - 13247) < (5078 - (1668 + 58)))) then
					v11.APLVar.RtB_List[v148] = {};
				end
				v150 = 627 - (512 + 114);
			end
			if ((v150 == (5 - 3)) or ((4268 - 2203) >= (11120 - 7924))) then
				return v11.APLVar.RtB_List[v148][v151];
			end
			if ((v150 == (1 + 0)) or ((820 + 3556) <= (1288 + 193))) then
				v151 = table.concat(v149);
				if ((v148 == "All") or ((11440 - 8048) >= (6735 - (109 + 1885)))) then
					if (((4794 - (1269 + 200)) >= (4128 - 1974)) and not v11.APLVar.RtB_List[v148][v151]) then
						local v176 = 815 - (98 + 717);
						for v180 = 827 - (802 + 24), #v149 do
							if (v14:BuffUp(v107[v149[v180]]) or ((2233 - 938) >= (4082 - 849))) then
								v176 = v176 + 1 + 0;
							end
						end
						v11.APLVar.RtB_List[v148][v151] = ((v176 == #v149) and true) or false;
					end
				elseif (((3363 + 1014) > (270 + 1372)) and not v11.APLVar.RtB_List[v148][v151]) then
					local v178 = 0 + 0;
					while true do
						if (((13139 - 8416) > (4521 - 3165)) and (v178 == (0 + 0))) then
							v11.APLVar.RtB_List[v148][v151] = false;
							for v185 = 1 + 0, #v149 do
								if (v14:BuffUp(v107[v149[v185]]) or ((3412 + 724) <= (2497 + 936))) then
									v11.APLVar.RtB_List[v148][v151] = true;
									break;
								end
							end
							break;
						end
					end
				end
				v150 = 1 + 1;
			end
		end
	end
	local function v109()
		if (((5678 - (797 + 636)) <= (22485 - 17854)) and not v11.APLVar.RtB_Buffs) then
			v11.APLVar.RtB_Buffs = {};
			v11.APLVar.RtB_Buffs.Total = 1619 - (1427 + 192);
			v11.APLVar.RtB_Buffs.Normal = 0 + 0;
			v11.APLVar.RtB_Buffs.Shorter = 0 - 0;
			v11.APLVar.RtB_Buffs.Longer = 0 + 0;
			local v166 = v80.RtBRemains();
			for v169 = 1 + 0, #v107 do
				local v170 = 326 - (192 + 134);
				local v171;
				while true do
					if (((5552 - (316 + 960)) >= (2179 + 1735)) and (v170 == (0 + 0))) then
						v171 = v14:BuffRemains(v107[v169]);
						if (((184 + 14) <= (16687 - 12322)) and (v171 > (551 - (83 + 468)))) then
							local v181 = 1806 - (1202 + 604);
							while true do
								if (((22323 - 17541) > (7781 - 3105)) and (v181 == (0 - 0))) then
									v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + (326 - (45 + 280));
									if (((4695 + 169) > (1920 + 277)) and (v171 == v166)) then
										v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + 1 + 0;
									elseif ((v171 > v166) or ((2048 + 1652) == (441 + 2066))) then
										v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + (1 - 0);
									else
										v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + (1912 - (340 + 1571));
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
		return v11.APLVar.RtB_Buffs.Total;
	end
	local function v110()
		local v152 = 0 + 0;
		while true do
			if (((6246 - (1733 + 39)) >= (752 - 478)) and ((1034 - (125 + 909)) == v152)) then
				if (not v11.APLVar.RtB_Reroll or ((3842 - (1096 + 852)) <= (631 + 775))) then
					if (((2244 - 672) >= (1485 + 46)) and (v63 == "1+ Buff")) then
						v11.APLVar.RtB_Reroll = ((v109() <= (512 - (409 + 103))) and true) or false;
					elseif ((v63 == "Broadside") or ((4923 - (46 + 190)) < (4637 - (51 + 44)))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.Broadside) and true) or false;
					elseif (((929 + 2362) > (2984 - (1114 + 203))) and (v63 == "Buried Treasure")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.BuriedTreasure) and true) or false;
					elseif ((v63 == "Grand Melee") or ((1599 - (228 + 498)) == (441 + 1593))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.GrandMelee) and true) or false;
					elseif ((v63 == "Skull and Crossbones") or ((1556 + 1260) < (674 - (174 + 489)))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.SkullandCrossbones) and true) or false;
					elseif (((9636 - 5937) < (6611 - (830 + 1075))) and (v63 == "Ruthless Precision")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.RuthlessPrecision) and true) or false;
					elseif (((3170 - (303 + 221)) >= (2145 - (231 + 1038))) and (v63 == "True Bearing")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v81.TrueBearing) and true) or false;
					else
						local v196 = 0 + 0;
						while true do
							if (((1776 - (171 + 991)) <= (13121 - 9937)) and ((5 - 3) == v196)) then
								if (((7800 - 4674) == (2502 + 624)) and v81.Crackshot:IsAvailable() and v14:HasTier(108 - 77, 11 - 7) and (v109() <= ((1 - 0) + v20(v14:BuffUp(v81.LoadedDiceBuff)))) and (v81.HiddenOpportunity:IsAvailable() or v14:BuffDown(v81.Broadside))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if ((not v81.Crackshot:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and not v14:BuffUp(v81.SkullandCrossbones) and (v109() < ((6 - 4) + v20(v14:BuffUp(v81.GrandMelee)))) and (v90 < (1250 - (111 + 1137)))) or ((2345 - (91 + 67)) >= (14744 - 9790))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v196 = 1 + 2;
							end
							if ((v196 == (526 - (423 + 100))) or ((28 + 3849) == (9898 - 6323))) then
								if (((369 + 338) > (1403 - (326 + 445))) and (v11.APLVar.RtB_Reroll or ((v11.APLVar.RtB_Buffs.Normal == (0 - 0)) and (v11.APLVar.RtB_Buffs.Longer >= (2 - 1)) and (v109() < (11 - 6)) and (v80.RtBRemains() <= (750 - (530 + 181)))))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if (v15:FilteredTimeToDie("<", 893 - (614 + 267)) or v10.BossFilteredFightRemains("<", 44 - (19 + 13)) or ((887 - 341) >= (6254 - 3570))) then
									v11.APLVar.RtB_Reroll = false;
								end
								break;
							end
							if (((4184 - 2719) <= (1118 + 3183)) and (v196 == (0 - 0))) then
								v11.APLVar.RtB_Reroll = false;
								v109();
								v196 = 1 - 0;
							end
							if (((3516 - (1293 + 519)) > (2907 - 1482)) and (v196 == (2 - 1))) then
								if (((v109() <= (3 - 1)) and v14:BuffUp(v81.BuriedTreasure) and v14:BuffDown(v81.GrandMelee) and (v90 < (8 - 6))) or ((1618 - 931) == (2243 + 1991))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if ((v81.Crackshot:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and not v14:HasTier(7 + 24, 9 - 5) and ((not v14:BuffUp(v81.TrueBearing) and v81.HiddenOpportunity:IsAvailable()) or (not v14:BuffUp(v81.Broadside) and not v81.HiddenOpportunity:IsAvailable())) and (v109() <= (1 + 0))) or ((1107 + 2223) < (894 + 535))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v196 = 1098 - (709 + 387);
							end
						end
					end
				end
				return v11.APLVar.RtB_Reroll;
			end
		end
	end
	local function v111()
		return v94 >= ((v80.CPMaxSpend() - (1859 - (673 + 1185))) - v20((v14:StealthUp(true, true)) and v81.Crackshot:IsAvailable()));
	end
	local function v112()
		return (v81.HiddenOpportunity:IsAvailable() or (v96 >= ((5 - 3) + v20(v81.ImprovedAmbush:IsAvailable()) + v20(v14:BuffUp(v81.Broadside))))) and (v97 >= (160 - 110));
	end
	local function v113()
		return not v26 or (v90 < (2 - 0)) or (v14:BuffRemains(v81.BladeFlurry) > (1 + 0 + v20(v81.KillingSpree:IsAvailable())));
	end
	local function v114()
		return v66 and (not v14:IsTanking(v15) or v76);
	end
	local function v115()
		return not v81.ShadowDanceTalent:IsAvailable() and ((v81.FanTheHammer:TalentRank() + v20(v81.QuickDraw:IsAvailable()) + v20(v81.Audacity:IsAvailable())) < (v20(v81.CountTheOdds:IsAvailable()) + v20(v81.KeepItRolling:IsAvailable())));
	end
	local function v116()
		return v14:BuffUp(v81.BetweentheEyes) and (not v81.HiddenOpportunity:IsAvailable() or (v14:BuffDown(v81.AudacityBuff) and ((v81.FanTheHammer:TalentRank() < (2 + 0)) or v14:BuffDown(v81.Opportunity)))) and not v81.Crackshot:IsAvailable();
	end
	local function v117()
		local v153 = 0 - 0;
		while true do
			if (((282 + 865) >= (667 - 332)) and (v153 == (0 - 0))) then
				if (((5315 - (446 + 1434)) > (3380 - (1040 + 243))) and v81.Vanish:IsCastable() and v81.Vanish:IsReady() and v114() and v81.HiddenOpportunity:IsAvailable() and not v81.Crackshot:IsAvailable() and not v14:BuffUp(v81.Audacity) and (v115() or (v14:BuffStack(v81.Opportunity) < (17 - 11))) and v112()) then
					if (v10.Cast(v81.Vanish, v66) or ((5617 - (559 + 1288)) >= (5972 - (609 + 1322)))) then
						return "Cast Vanish (HO)";
					end
				end
				if ((v81.Vanish:IsCastable() and v81.Vanish:IsReady() and v114() and (not v81.HiddenOpportunity:IsAvailable() or v81.Crackshot:IsAvailable()) and v111()) or ((4245 - (13 + 441)) <= (6019 - 4408))) then
					if (v10.Cast(v81.Vanish, v66) or ((11991 - 7413) <= (10000 - 7992))) then
						return "Cast Vanish (Finish)";
					end
				end
				v153 = 1 + 0;
			end
			if (((4085 - 2960) <= (738 + 1338)) and (v153 == (1 + 0))) then
				if ((v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and v81.Crackshot:IsAvailable() and v111()) or ((2204 - 1461) >= (2408 + 1991))) then
					if (((2123 - 968) < (1107 + 566)) and v10.Cast(v81.ShadowDance)) then
						return "Cast Shadow Dance";
					end
				end
				if ((v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and not v81.KeepItRolling:IsAvailable() and v116() and v14:BuffUp(v81.SliceandDice) and (v111() or v81.HiddenOpportunity:IsAvailable()) and (not v81.HiddenOpportunity:IsAvailable() or not v81.Vanish:IsReady())) or ((1293 + 1031) <= (416 + 162))) then
					if (((3163 + 604) == (3686 + 81)) and v10.Cast(v81.ShadowDance)) then
						return "Cast Shadow Dance";
					end
				end
				v153 = 435 - (153 + 280);
			end
			if (((11807 - 7718) == (3672 + 417)) and (v153 == (1 + 1))) then
				if (((2333 + 2125) >= (1520 + 154)) and v81.ShadowDance:IsAvailable() and v81.ShadowDance:IsCastable() and v81.KeepItRolling:IsAvailable() and v116() and ((v81.KeepItRolling:CooldownRemains() <= (22 + 8)) or ((v81.KeepItRolling:CooldownRemains() >= (182 - 62)) and (v111() or v81.HiddenOpportunity:IsAvailable())))) then
					if (((601 + 371) <= (2085 - (89 + 578))) and v10.Cast(v81.ShadowDance)) then
						return "Cast Shadow Dance";
					end
				end
				if ((v81.Shadowmeld:IsAvailable() and v81.Shadowmeld:IsReady()) or ((3528 + 1410) < (9899 - 5137))) then
					if ((v81.Crackshot:IsAvailable() and v111()) or (not v81.Crackshot:IsAvailable() and ((v81.CountTheOdds:IsAvailable() and v111()) or v81.HiddenOpportunity:IsAvailable())) or ((3553 - (572 + 477)) > (576 + 3688))) then
						if (((1293 + 860) == (257 + 1896)) and v10.Cast(v81.Shadowmeld, v28)) then
							return "Cast Shadowmeld";
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		v91 = v79.HandleTopTrinket(v84, v27, 126 - (84 + 2), nil);
		if (v91 or ((834 - 327) >= (1867 + 724))) then
			return v91;
		end
		v91 = v79.HandleBottomTrinket(v84, v27, 882 - (497 + 345), nil);
		if (((115 + 4366) == (758 + 3723)) and v91) then
			return v91;
		end
	end
	local function v119()
		local v154 = 1333 - (605 + 728);
		while true do
			if ((v154 == (2 + 0)) or ((5175 - 2847) < (32 + 661))) then
				if (((16001 - 11673) == (3902 + 426)) and v27 and v81.ThistleTea:IsAvailable() and v81.ThistleTea:IsCastable() and not v14:BuffUp(v81.ThistleTea) and ((v99 >= (277 - 177)) or v10.BossFilteredFightRemains("<", v81.ThistleTea:Charges() * (5 + 1)))) then
					if (((2077 - (457 + 32)) >= (566 + 766)) and v10.Cast(v81.ThistleTea)) then
						return "Cast Thistle Tea";
					end
				end
				if (v81.BloodFury:IsCastable() or ((5576 - (832 + 570)) > (4002 + 246))) then
					if (v10.Cast(v81.BloodFury, v28) or ((1196 + 3390) <= (289 - 207))) then
						return "Cast Blood Fury";
					end
				end
				if (((1861 + 2002) == (4659 - (588 + 208))) and v81.Berserking:IsCastable()) then
					if (v10.Cast(v81.Berserking, v28) or ((759 - 477) <= (1842 - (884 + 916)))) then
						return "Cast Berserking";
					end
				end
				if (((9648 - 5039) >= (445 + 321)) and v81.Fireblood:IsCastable()) then
					if (v10.Cast(v81.Fireblood, v28) or ((1805 - (232 + 421)) == (4377 - (1569 + 320)))) then
						return "Cast Fireblood";
					end
				end
				v154 = 1 + 2;
			end
			if (((651 + 2771) > (11288 - 7938)) and (v154 == (605 - (316 + 289)))) then
				if (((2295 - 1418) > (18 + 358)) and v27 and v81.AdrenalineRush:IsCastable() and (not v14:BuffUp(v81.AdrenalineRush) or (v14:StealthUp(true, true) and v81.Crackshot:IsAvailable() and v81.ImprovedAdrenalineRush:IsAvailable())) and ((v95 <= (1455 - (666 + 787))) or not v81.ImprovedAdrenalineRush:IsAvailable())) then
					if (v10.Cast(v81.AdrenalineRush) or ((3543 - (360 + 65)) <= (1730 + 121))) then
						return "Cast Adrenaline Rush";
					end
				end
				if ((v81.BladeFlurry:IsReady() and (v90 >= ((256 - (79 + 175)) - v20(v81.UnderhandedUpperhand:IsAvailable()))) and (v14:BuffRemains(v81.BladeFlurry) < v14:GCDRemains())) or (v81.DeftManeuvers:IsAvailable() and (v90 >= (7 - 2)) and not v111()) or ((129 + 36) >= (10703 - 7211))) then
					if (((7604 - 3655) < (5755 - (503 + 396))) and v69) then
						v10.CastSuggested(v81.BladeFlurry);
					elseif (v10.Cast(v81.BladeFlurry) or ((4457 - (92 + 89)) < (5850 - 2834))) then
						return "Cast Blade Flurry";
					end
				end
				if (((2406 + 2284) > (2442 + 1683)) and v81.RolltheBones:IsReady()) then
					if (v110() or (v80.RtBRemains() <= (v20(v14:HasTier(121 - 90, 1 + 3)) + (v20((v81.ShadowDance:CooldownRemains() <= (2 - 1)) or (v81.Vanish:CooldownRemains() <= (1 + 0))) * (3 + 3)))) or ((152 - 102) >= (112 + 784))) then
						if (v10.Cast(v81.RolltheBones) or ((2613 - 899) >= (4202 - (485 + 759)))) then
							return "Cast Roll the Bones";
						end
					end
				end
				if ((v81.KeepItRolling:IsReady() and not v110() and (v109() >= ((6 - 3) + v20(v14:HasTier(1220 - (442 + 747), 1139 - (832 + 303))))) and (v14:BuffDown(v81.ShadowDance) or (v109() >= (952 - (88 + 858))))) or ((455 + 1036) < (533 + 111))) then
					if (((29 + 675) < (1776 - (766 + 23))) and v10.Cast(v81.KeepItRolling)) then
						return "Cast Keep it Rolling";
					end
				end
				v154 = 4 - 3;
			end
			if (((5084 - 1366) > (5021 - 3115)) and (v154 == (10 - 7))) then
				if (v81.AncestralCall:IsCastable() or ((2031 - (1036 + 37)) > (2578 + 1057))) then
					if (((6817 - 3316) <= (3534 + 958)) and v10.Cast(v81.AncestralCall, v28)) then
						return "Cast Ancestral Call";
					end
				end
				v91 = v118();
				if (v91 or ((4922 - (641 + 839)) < (3461 - (910 + 3)))) then
					return v91;
				end
				break;
			end
			if (((7329 - 4454) >= (3148 - (1466 + 218))) and (v154 == (1 + 0))) then
				if ((v81.GhostlyStrike:IsAvailable() and v81.GhostlyStrike:IsReady()) or ((5945 - (556 + 592)) >= (1740 + 3153))) then
					if (v10.Cast(v81.GhostlyStrike) or ((1359 - (329 + 479)) > (2922 - (174 + 680)))) then
						return "Cast Ghostly Strike";
					end
				end
				if (((7263 - 5149) > (1956 - 1012)) and v27 and v81.Sepsis:IsAvailable() and v81.Sepsis:IsReady()) then
					if ((v81.Crackshot:IsAvailable() and v81.BetweentheEyes:IsReady() and v111() and not v14:StealthUp(true, true)) or (not v81.Crackshot:IsAvailable() and v15:FilteredTimeToDie(">", 8 + 3) and v14:BuffUp(v81.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 750 - (396 + 343)) or ((201 + 2061) >= (4573 - (29 + 1448)))) then
						if (v10.Cast(v81.Sepsis) or ((3644 - (135 + 1254)) >= (13324 - 9787))) then
							return "Cast Sepsis";
						end
					end
				end
				if ((v81.BladeRush:IsReady() and (v100 > (18 - 14)) and not v14:StealthUp(true, true)) or ((2558 + 1279) < (2833 - (389 + 1138)))) then
					if (((3524 - (102 + 472)) == (2784 + 166)) and v10.Cast(v81.BladeRush)) then
						return "Cast Blade Rush";
					end
				end
				if (not v14:StealthUp(true, true, true) or ((2620 + 2103) < (3076 + 222))) then
					local v175 = 1545 - (320 + 1225);
					while true do
						if (((2021 - 885) >= (95 + 59)) and (v175 == (1464 - (157 + 1307)))) then
							v91 = v117();
							if (v91 or ((2130 - (821 + 1038)) > (11846 - 7098))) then
								return v91;
							end
							break;
						end
					end
				end
				v154 = 1 + 1;
			end
		end
	end
	local function v120()
		local v155 = 0 - 0;
		while true do
			if (((1764 + 2976) >= (7812 - 4660)) and (v155 == (1026 - (834 + 192)))) then
				if ((v81.BladeFlurry:IsReady() and v81.BladeFlurry:IsCastable() and v26 and v81.Subterfuge:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and (v90 >= (1 + 1)) and (v14:BuffRemains(v81.BladeFlurry) <= v14:GCDRemains())) or ((662 + 1916) >= (73 + 3317))) then
					if (((63 - 22) <= (1965 - (300 + 4))) and v69) then
						v10.Press(v81.BladeFlurry);
					elseif (((161 + 440) < (9319 - 5759)) and v10.Press(v81.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (((597 - (112 + 250)) < (274 + 413)) and v81.ColdBlood:IsCastable() and v14:BuffDown(v81.ColdBlood) and v15:IsSpellInRange(v81.Dispatch) and v111()) then
					if (((11395 - 6846) > (661 + 492)) and v10.Cast(v81.ColdBlood)) then
						return "Cast Cold Blood";
					end
				end
				v155 = 1 + 0;
			end
			if ((v155 == (1 + 0)) or ((2318 + 2356) < (3471 + 1201))) then
				if (((5082 - (1001 + 413)) < (10170 - 5609)) and v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and v111() and v81.Crackshot:IsAvailable()) then
					if (v10.Press(v81.BetweentheEyes) or ((1337 - (244 + 638)) == (4298 - (627 + 66)))) then
						return "Cast Between the Eyes";
					end
				end
				if ((v81.Dispatch:IsCastable() and v15:IsSpellInRange(v81.Dispatch) and v111()) or ((7934 - 5271) == (3914 - (512 + 90)))) then
					if (((6183 - (1665 + 241)) <= (5192 - (373 + 344))) and v10.Press(v81.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				v155 = 1 + 1;
			end
			if ((v155 == (1 + 1)) or ((2294 - 1424) == (2011 - 822))) then
				if (((2652 - (35 + 1064)) <= (2280 + 853)) and v81.PistolShot:IsCastable() and v15:IsSpellInRange(v81.PistolShot) and v81.Crackshot:IsAvailable() and (v81.FanTheHammer:TalentRank() >= (4 - 2)) and (v14:BuffStack(v81.Opportunity) >= (1 + 5)) and ((v14:BuffUp(v81.Broadside) and (v95 <= (1237 - (298 + 938)))) or v14:BuffUp(v81.GreenskinsWickersBuff))) then
					if (v10.Press(v81.PistolShot) or ((3496 - (233 + 1026)) >= (5177 - (636 + 1030)))) then
						return "Cast Pistol Shot";
					end
				end
				if ((v81.Ambush:IsCastable() and v15:IsSpellInRange(v81.Ambush) and v81.HiddenOpportunity:IsAvailable()) or ((677 + 647) > (2950 + 70))) then
					if (v10.Press(v81.Ambush) or ((889 + 2103) == (128 + 1753))) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v121()
		local v156 = 221 - (55 + 166);
		while true do
			if (((602 + 2504) > (154 + 1372)) and (v156 == (3 - 2))) then
				if (((3320 - (36 + 261)) < (6768 - 2898)) and v81.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v89, ">", v14:BuffRemains(v81.SliceandDice), true) or (v14:BuffRemains(v81.SliceandDice) == (1368 - (34 + 1334)))) and (v14:BuffRemains(v81.SliceandDice) < ((1 + 0 + v95) * (1.8 + 0)))) then
					if (((1426 - (1035 + 248)) > (95 - (20 + 1))) and v10.Press(v81.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if (((10 + 8) < (2431 - (134 + 185))) and v81.KillingSpree:IsCastable() and v15:IsSpellInRange(v81.KillingSpree) and (v15:DebuffUp(v81.GhostlyStrike) or not v81.GhostlyStrike:IsAvailable())) then
					if (((2230 - (549 + 584)) <= (2313 - (314 + 371))) and v10.Cast(v81.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v156 = 6 - 4;
			end
			if (((5598 - (478 + 490)) == (2453 + 2177)) and (v156 == (1174 - (786 + 386)))) then
				if (((11466 - 7926) > (4062 - (1055 + 324))) and v81.ColdBlood:IsCastable() and v14:BuffDown(v81.ColdBlood) and v15:IsSpellInRange(v81.Dispatch)) then
					if (((6134 - (1093 + 247)) >= (2911 + 364)) and v10.Cast(v81.ColdBlood, v54)) then
						return "Cast Cold Blood";
					end
				end
				if (((157 + 1327) == (5891 - 4407)) and v81.Dispatch:IsCastable() and v15:IsSpellInRange(v81.Dispatch)) then
					if (((4859 - 3427) < (10115 - 6560)) and v10.Press(v81.Dispatch)) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if ((v156 == (0 - 0)) or ((379 + 686) > (13783 - 10205))) then
				if ((v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and not v81.Crackshot:IsAvailable() and ((v14:BuffRemains(v81.BetweentheEyes) < (13 - 9)) or v81.ImprovedBetweenTheEyes:IsAvailable() or v81.GreenskinsWickers:IsAvailable() or v14:HasTier(23 + 7, 9 - 5)) and v14:BuffDown(v81.GreenskinsWickers)) or ((5483 - (364 + 324)) < (3857 - 2450))) then
					if (((4446 - 2593) < (1596 + 3217)) and v10.Press(v81.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if ((v81.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v81.BetweentheEyes) and v81.Crackshot:IsAvailable() and (v81.Vanish:CooldownRemains() > (188 - 143)) and (v81.ShadowDance:CooldownRemains() > (18 - 6))) or ((8567 - 5746) < (3699 - (1249 + 19)))) then
					if (v10.Press(v81.BetweentheEyes) or ((2595 + 279) < (8489 - 6308))) then
						return "Cast Between the Eyes";
					end
				end
				v156 = 1087 - (686 + 400);
			end
		end
	end
	local function v122()
		if ((v27 and v81.EchoingReprimand:IsReady()) or ((2110 + 579) <= (572 - (73 + 156)))) then
			if (v10.Cast(v81.EchoingReprimand, nil, v75) or ((9 + 1860) == (2820 - (721 + 90)))) then
				return "Cast Echoing Reprimand";
			end
		end
		if ((v81.Ambush:IsCastable() and v81.HiddenOpportunity:IsAvailable() and v14:BuffUp(v81.AudacityBuff)) or ((40 + 3506) < (7539 - 5217))) then
			if (v10.Press(v81.Ambush) or ((2552 - (224 + 246)) == (7731 - 2958))) then
				return "Cast Ambush (High-Prio Buffed)";
			end
		end
		if (((5972 - 2728) > (192 + 863)) and v81.FanTheHammer:IsAvailable() and v81.Audacity:IsAvailable() and v81.HiddenOpportunity:IsAvailable() and v14:BuffUp(v81.Opportunity) and v14:BuffDown(v81.AudacityBuff)) then
			if (v10.Press(v81.PistolShot) or ((79 + 3234) <= (1306 + 472))) then
				return "Cast Pistol Shot (Audacity)";
			end
		end
		if ((v14:BuffUp(v81.GreenskinsWickersBuff) and ((not v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity)) or (v14:BuffRemains(v81.GreenskinsWickersBuff) < (1.5 - 0)))) or ((4728 - 3307) >= (2617 - (203 + 310)))) then
			if (((3805 - (1238 + 755)) <= (227 + 3022)) and v10.Press(v81.PistolShot)) then
				return "Cast Pistol Shot (GSW Dump)";
			end
		end
		if (((3157 - (709 + 825)) <= (3606 - 1649)) and v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and ((v14:BuffStack(v81.Opportunity) >= (8 - 2)) or (v14:BuffRemains(v81.Opportunity) < (866 - (196 + 668))))) then
			if (((17419 - 13007) == (9138 - 4726)) and v10.Press(v81.PistolShot)) then
				return "Cast Pistol Shot (FtH Dump)";
			end
		end
		if (((2583 - (171 + 662)) >= (935 - (4 + 89))) and v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and (v96 > ((3 - 2) + (v20(v81.QuickDraw:IsAvailable()) * v81.FanTheHammer:TalentRank()))) and ((not v81.Vanish:IsReady() and not v81.ShadowDance:IsReady()) or v14:StealthUp(true, true) or not v81.Crackshot:IsAvailable() or (v81.FanTheHammer:TalentRank() <= (1 + 0)))) then
			if (((19202 - 14830) > (726 + 1124)) and v10.Press(v81.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((1718 - (35 + 1451)) < (2274 - (28 + 1425))) and not v81.FanTheHammer:IsAvailable() and v14:BuffUp(v81.Opportunity) and ((v100 > (1994.5 - (941 + 1052))) or (v96 <= (1 + 0 + v20(v14:BuffUp(v81.Broadside)))) or v81.QuickDraw:IsAvailable() or (v81.Audacity:IsAvailable() and v14:BuffDown(v81.AudacityBuff)))) then
			if (((2032 - (822 + 692)) < (1287 - 385)) and v10.Press(v81.PistolShot)) then
				return "Cast Pistol Shot";
			end
		end
		if (((1411 + 1583) > (1155 - (45 + 252))) and v81.SinisterStrike:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike)) then
			if (v10.Press(v81.SinisterStrike) or ((3716 + 39) <= (315 + 600))) then
				return "Cast Sinister Strike";
			end
		end
	end
	local function v123()
		v78();
		v25 = EpicSettings.Toggles['ooc'];
		v26 = EpicSettings.Toggles['aoe'];
		v27 = EpicSettings.Toggles['cds'];
		v92 = (v81.AcrobaticStrikes:IsAvailable() and (24 - 14)) or (439 - (114 + 319));
		v95 = v14:ComboPoints();
		v94 = v80.EffectiveComboPoints(v95);
		v96 = v14:ComboPointsDeficit();
		v101 = (v14:BuffUp(v81.AdrenalineRush, nil, true) and -(71 - 21)) or (0 - 0);
		v97 = v106();
		v98 = v14:EnergyRegen();
		v100 = v105(v101);
		v99 = v14:EnergyDeficitPredicted(nil, v101);
		if (((2516 + 1430) > (5576 - 1833)) and v26) then
			v88 = v14:GetEnemiesInRange(62 - 32);
			v89 = v14:GetEnemiesInRange(v92);
			v90 = #v89;
		else
			v90 = 1964 - (556 + 1407);
		end
		v91 = v80.CrimsonVial();
		if (v91 or ((2541 - (741 + 465)) >= (3771 - (170 + 295)))) then
			return v91;
		end
		v80.Poisons();
		if (((2553 + 2291) > (2070 + 183)) and v82.Healthstone:IsReady() and (v14:HealthPercentage() < v34) and not (v14:IsChanneling() or v14:IsCasting())) then
			if (((1112 - 660) == (375 + 77)) and v10.Cast(v83.Healthstone)) then
				return "Healthstone ";
			end
		end
		if ((v82.RefreshingHealingPotion:IsReady() and (v14:HealthPercentage() < v32) and not (v14:IsChanneling() or v14:IsCasting())) or ((2923 + 1634) < (1182 + 905))) then
			if (((5104 - (957 + 273)) == (1037 + 2837)) and v10.Cast(v83.RefreshingHealingPotion)) then
				return "RefreshingHealingPotion ";
			end
		end
		if ((v81.Feint:IsCastable() and (v14:HealthPercentage() <= v57) and not (v14:IsChanneling() or v14:IsCasting())) or ((776 + 1162) > (18804 - 13869))) then
			if (v10.Cast(v81.Feint) or ((11212 - 6957) < (10455 - 7032))) then
				return "Cast Feint (Defensives)";
			end
		end
		if (((7199 - 5745) <= (4271 - (389 + 1391))) and not v14:AffectingCombat() and not v14:IsMounted() and v58) then
			local v167 = 0 + 0;
			while true do
				if (((0 + 0) == v167) or ((9463 - 5306) <= (3754 - (783 + 168)))) then
					v91 = v80.Stealth(v81.Stealth2, nil);
					if (((16287 - 11434) >= (2934 + 48)) and v91) then
						return "Stealth (OOC): " .. v91;
					end
					break;
				end
			end
		end
		if (((4445 - (309 + 2)) > (10308 - 6951)) and not v14:AffectingCombat() and (v81.Vanish:TimeSinceLastCast() > (1213 - (1090 + 122))) and v15:IsInRange(3 + 5) and v25) then
			if ((v79.TargetIsValid() and v15:IsInRange(33 - 23) and not (v14:IsChanneling() or v14:IsCasting())) or ((2339 + 1078) < (3652 - (628 + 490)))) then
				local v172 = 0 + 0;
				while true do
					if ((v172 == (2 - 1)) or ((12439 - 9717) <= (938 - (431 + 343)))) then
						if (v79.TargetIsValid() or ((4863 - 2455) < (6100 - 3991))) then
							local v183 = 0 + 0;
							while true do
								if (((1 + 0) == v183) or ((1728 - (556 + 1139)) == (1470 - (6 + 9)))) then
									if ((v81.SliceandDice:IsReady() and (v14:BuffRemains(v81.SliceandDice) < ((1 + 0 + v95) * (1.8 + 0)))) or ((612 - (28 + 141)) >= (1556 + 2459))) then
										if (((4174 - 792) > (118 + 48)) and v10.Press(v81.SliceandDice)) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (v14:StealthUp(true, false) or ((1597 - (486 + 831)) == (7960 - 4901))) then
										v91 = v120();
										if (((6622 - 4741) > (245 + 1048)) and v91) then
											return "Stealth (Opener): " .. v91;
										end
										if (((7452 - 5095) == (3620 - (668 + 595))) and v81.KeepItRolling:IsAvailable() and v81.GhostlyStrike:IsReady() and v81.EchoingReprimand:IsAvailable()) then
											if (((111 + 12) == (25 + 98)) and v10.Press(v81.GhostlyStrike)) then
												return "Cast Ghostly Strike KiR (Opener)";
											end
										end
										if (v81.Ambush:IsCastable() or ((2879 - 1823) >= (3682 - (23 + 267)))) then
											if (v10.Cast(v81.Ambush) or ((3025 - (1129 + 815)) < (1462 - (371 + 16)))) then
												return "Cast Ambush (Opener)";
											end
										end
									elseif (v111() or ((2799 - (1326 + 424)) >= (8393 - 3961))) then
										v91 = v121();
										if (v91 or ((17423 - 12655) <= (964 - (88 + 30)))) then
											return "Finish (Opener): " .. v91;
										end
									end
									v183 = 773 - (720 + 51);
								end
								if (((0 - 0) == v183) or ((5134 - (421 + 1355)) <= (2342 - 922))) then
									if ((v81.AdrenalineRush:IsReady() and v81.ImprovedAdrenalineRush:IsAvailable() and (v95 <= (1 + 1))) or ((4822 - (286 + 797)) <= (10985 - 7980))) then
										if (v10.Cast(v81.AdrenalineRush) or ((2747 - 1088) >= (2573 - (397 + 42)))) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									if ((v81.RolltheBones:IsReady() and not v14:DebuffUp(v81.Dreadblades) and ((v109() == (0 + 0)) or v110())) or ((4060 - (24 + 776)) < (3628 - 1273))) then
										if (v10.Cast(v81.RolltheBones) or ((1454 - (222 + 563)) == (9304 - 5081))) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									v183 = 1 + 0;
								end
								if ((v183 == (192 - (23 + 167))) or ((3490 - (690 + 1108)) < (213 + 375))) then
									if (v81.SinisterStrike:IsCastable() or ((3957 + 840) < (4499 - (40 + 808)))) then
										if (v10.Cast(v81.SinisterStrike) or ((688 + 3489) > (18546 - 13696))) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
							end
						end
						return;
					end
					if ((v172 == (0 + 0)) or ((212 + 188) > (610 + 501))) then
						if (((3622 - (47 + 524)) > (653 + 352)) and v81.BladeFlurry:IsReady() and v14:BuffDown(v81.BladeFlurry) and v81.UnderhandedUpperhand:IsAvailable() and not v14:StealthUp(true, true)) then
							if (((10094 - 6401) <= (6551 - 2169)) and v10.Cast(v81.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (not v14:StealthUp(true, false) or ((7484 - 4202) > (5826 - (1165 + 561)))) then
							v91 = v80.Stealth(v80.StealthSpell());
							if (v91 or ((107 + 3473) < (8808 - 5964))) then
								return v91;
							end
						end
						v172 = 1 + 0;
					end
				end
			end
		end
		if (((568 - (341 + 138)) < (1213 + 3277)) and v81.FanTheHammer:IsAvailable() and (v81.PistolShot:TimeSinceLastCast() < v14:GCDRemains())) then
			v95 = v24(v95, v80.FanTheHammerCP());
		end
		if (v79.TargetIsValid() or ((10283 - 5300) < (2134 - (89 + 237)))) then
			local v168 = 0 - 0;
			while true do
				if (((8060 - 4231) > (4650 - (581 + 300))) and (v168 == (1221 - (855 + 365)))) then
					v91 = v122();
					if (((3527 - 2042) <= (949 + 1955)) and v91) then
						return "Build: " .. v91;
					end
					if (((5504 - (1030 + 205)) == (4008 + 261)) and v81.ArcaneTorrent:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike) and (v99 > (14 + 1 + v98))) then
						if (((673 - (156 + 130)) <= (6321 - 3539)) and v10.Cast(v81.ArcaneTorrent, v28)) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v81.ArcanePulse:IsCastable() and v15:IsSpellInRange(v81.SinisterStrike)) or ((3200 - 1301) <= (1877 - 960))) then
						if (v10.Cast(v81.ArcanePulse) or ((1137 + 3175) <= (511 + 365))) then
							return "Cast Arcane Pulse";
						end
					end
					v168 = 71 - (10 + 59);
				end
				if (((632 + 1600) <= (12784 - 10188)) and (v168 == (1165 - (671 + 492)))) then
					if (((1668 + 427) < (4901 - (369 + 846))) and v81.LightsJudgment:IsCastable() and v15:IsInMeleeRange(2 + 3)) then
						if (v10.Cast(v81.LightsJudgment, v28) or ((1362 + 233) >= (6419 - (1036 + 909)))) then
							return "Cast Lights Judgment";
						end
					end
					if ((v81.BagofTricks:IsCastable() and v15:IsInMeleeRange(4 + 1)) or ((7754 - 3135) < (3085 - (11 + 192)))) then
						if (v10.Cast(v81.BagofTricks, v28) or ((149 + 145) >= (5006 - (135 + 40)))) then
							return "Cast Bag of Tricks";
						end
					end
					if (((4915 - 2886) <= (1859 + 1225)) and v81.PistolShot:IsCastable() and v15:IsSpellInRange(v81.PistolShot) and not v15:IsInRange(v92) and not v14:StealthUp(true, true) and (v99 < (54 - 29)) and ((v96 >= (1 - 0)) or (v100 <= (177.2 - (50 + 126))))) then
						if (v10.Cast(v81.PistolShot) or ((5672 - 3635) == (536 + 1884))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (((5871 - (1233 + 180)) > (4873 - (522 + 447))) and v81.SinisterStrike:IsCastable()) then
						if (((1857 - (107 + 1314)) >= (58 + 65)) and v10.Cast(v81.SinisterStrike)) then
							return "Cast Sinister Strike Filler";
						end
					end
					break;
				end
				if (((1523 - 1023) < (772 + 1044)) and (v168 == (0 - 0))) then
					v91 = v119();
					if (((14140 - 10566) == (5484 - (716 + 1194))) and v91) then
						return "CDs: " .. v91;
					end
					if (((4 + 217) < (42 + 348)) and (v14:StealthUp(true, true) or v14:BuffUp(v81.Shadowmeld))) then
						v91 = v120();
						if (v91 or ((2716 - (74 + 429)) <= (2741 - 1320))) then
							return "Stealth: " .. v91;
						end
					end
					if (((1516 + 1542) < (11125 - 6265)) and v111()) then
						v91 = v121();
						if (v91 or ((917 + 379) >= (13706 - 9260))) then
							return "Finish: " .. v91;
						end
					end
					v168 = 2 - 1;
				end
			end
		end
	end
	local function v124()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(693 - (279 + 154), v123, v124);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

