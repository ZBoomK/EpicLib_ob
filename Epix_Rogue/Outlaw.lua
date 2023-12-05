local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1238 - (561 + 677);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((776 + 891) >= (617 + 2674))) then
			v6 = v0[v4];
			if (not v6 or ((759 + 114) == (6860 - 4826))) then
				return v1(v4, ...);
			end
			v5 = 1995 - (109 + 1885);
		end
		if ((v5 == (1470 - (1269 + 200))) or ((5397 - 2581) < (826 - (98 + 717)))) then
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
		local v126 = 826 - (802 + 24);
		while true do
			if (((6378 - 2679) < (5943 - 1237)) and (v126 == (1 + 2))) then
				v51 = EpicSettings.Settings['VanishOffGCD'];
				v52 = EpicSettings.Settings['ShadowDanceOffGCD'];
				v53 = EpicSettings.Settings['ThistleTeaOffGCD'];
				v126 = 4 + 0;
			end
			if (((435 + 2211) >= (189 + 687)) and (v126 == (11 - 7))) then
				v54 = EpicSettings.Settings['ColdBloodOffGCD'];
				v55 = EpicSettings.Settings['MarkedforDeathOffGCD'];
				v56 = EpicSettings.Settings['CrimsonVialHP'] or (0 - 0);
				v126 = 2 + 3;
			end
			if (((250 + 364) <= (2627 + 557)) and (v126 == (6 + 2))) then
				v75 = EpicSettings.Settings['EchoingReprimand'];
				v76 = EpicSettings.Settings['UseSoloVanish'];
				v77 = EpicSettings.Settings['sepsis'];
				break;
			end
			if (((1460 + 1666) == (4559 - (797 + 636))) and (v126 == (0 - 0))) then
				v28 = EpicSettings.Settings['UseRacials'];
				v30 = EpicSettings.Settings['UseHealingPotion'];
				v31 = EpicSettings.Settings['HealingPotionName'] or (1619 - (1427 + 192));
				v126 = 1 + 0;
			end
			if ((v126 == (16 - 9)) or ((1966 + 221) >= (2246 + 2708))) then
				v71 = EpicSettings.Settings['GhostlyStrikeGCD'];
				v73 = EpicSettings.Settings['KeepItRollingGCD'];
				v74 = EpicSettings.Settings['AdrenalineRushOffGCD'];
				v126 = 334 - (192 + 134);
			end
			if ((v126 == (1278 - (316 + 960))) or ((2158 + 1719) == (2759 + 816))) then
				v35 = EpicSettings.Settings['InterruptWithStun'] or (0 + 0);
				v36 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (0 - 0);
				v37 = EpicSettings.Settings['InterruptThreshold'] or (551 - (83 + 468));
				v126 = 1809 - (1202 + 604);
			end
			if (((3300 - 2593) > (1051 - 419)) and (v126 == (2 - 1))) then
				v32 = EpicSettings.Settings['HealingPotionHP'] or (325 - (45 + 280));
				v33 = EpicSettings.Settings['UseHealthstone'];
				v34 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v126 = 2 + 0;
			end
			if ((v126 == (3 + 3)) or ((303 + 243) >= (473 + 2211))) then
				v66 = EpicSettings.Settings['UseDPSVanish'];
				v69 = EpicSettings.Settings['BladeFlurryGCD'];
				v70 = EpicSettings.Settings['BladeRushGCD'];
				v126 = 12 - 5;
			end
			if (((3376 - (340 + 1571)) <= (1697 + 2604)) and (v126 == (1777 - (1733 + 39)))) then
				v57 = EpicSettings.Settings['FeintHP'] or (0 - 0);
				v58 = EpicSettings.Settings['StealthOOC'];
				v63 = EpicSettings.Settings['RolltheBonesLogic'];
				v126 = 1040 - (125 + 909);
			end
		end
	end
	local v79 = v10.Commons.Everyone;
	v10.Commons.Rogue = {};
	local v81 = v10.Commons.Rogue;
	local v82 = v16.Rogue.Outlaw;
	local v83 = v18.Rogue.Outlaw;
	local v84 = v19.Rogue.Outlaw;
	local v85 = {v83.ManicGrieftorch:ID(),v83.DragonfireBombDispenser:ID(),v83.BeaconToTheBeyond:ID()};
	local v86 = v14:GetEquipment();
	local v87 = (v86[13 + 0] and v18(v86[525 - (409 + 103)])) or v18(236 - (46 + 190));
	local v88 = (v86[109 - (51 + 44)] and v18(v86[4 + 10])) or v18(1317 - (1114 + 203));
	v10:RegisterForEvent(function()
		local v127 = 726 - (228 + 498);
		while true do
			if (((370 + 1334) > (788 + 637)) and ((664 - (174 + 489)) == v127)) then
				v88 = (v86[36 - 22] and v18(v86[1919 - (830 + 1075)])) or v18(524 - (303 + 221));
				break;
			end
			if ((v127 == (1269 - (231 + 1038))) or ((573 + 114) == (5396 - (171 + 991)))) then
				v86 = v14:GetEquipment();
				v87 = (v86[53 - 40] and v18(v86[34 - 21])) or v18(0 - 0);
				v127 = 1 + 0;
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v82.Dispatch:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v81.CPSpend() * (0.3 - 0) * (2 - 1) * ((1 - 0) + (v14:VersatilityDmgPct() / (309 - 209))) * ((v15:DebuffUp(v82.GhostlyStrike) and (1249.1 - (111 + 1137))) or (159 - (91 + 67)));
	end);
	local v89, v90, v91;
	local v92;
	local v93 = 17 - 11;
	local v94;
	local v95, v96, v97;
	local v98, v99, v100, v101, v102;
	local v103 = {{v82.Blind,"Cast Blind (Interrupt)",function()
		return true;
	end}};
	local v104, v105 = 0 + 0, 771 - (326 + 445);
	local function v106(v128)
		local v129 = 0 - 0;
		local v130;
		while true do
			if ((v129 == (0 - 0)) or ((7772 - 4442) < (2140 - (530 + 181)))) then
				v130 = v14:EnergyTimeToMaxPredicted(nil, v128);
				if (((2028 - (614 + 267)) >= (367 - (19 + 13))) and ((v130 < v104) or ((v130 - v104) > (0.5 - 0)))) then
					v104 = v130;
				end
				v129 = 2 - 1;
			end
			if (((9812 - 6377) > (545 + 1552)) and (v129 == (1 - 0))) then
				return v104;
			end
		end
	end
	local function v107()
		local v131 = 0 - 0;
		local v132;
		while true do
			if ((v131 == (1813 - (1293 + 519))) or ((7691 - 3921) >= (10550 - 6509))) then
				return v105;
			end
			if (((0 - 0) == v131) or ((16347 - 12556) <= (3794 - 2183))) then
				v132 = v14:EnergyPredicted();
				if ((v132 > v105) or ((v132 - v105) > (5 + 4)) or ((934 + 3644) <= (4665 - 2657))) then
					v105 = v132;
				end
				v131 = 1 + 0;
			end
		end
	end
	local v108 = {v82.Broadside,v82.BuriedTreasure,v82.GrandMelee,v82.RuthlessPrecision,v82.SkullandCrossbones,v82.TrueBearing};
	local function v109(v133, v134)
		local v135 = 0 - 0;
		local v136;
		while true do
			if (((805 + 320) <= (1552 + 524)) and (v135 == (2 - 0))) then
				return v11.APLVar.RtB_List[v133][v136];
			end
			if ((v135 == (1 + 0)) or ((1481 - 738) >= (8634 - 4235))) then
				v136 = table.concat(v134);
				if (((3035 - (446 + 1434)) < (2956 - (1040 + 243))) and (v133 == "All")) then
					if (not v11.APLVar.RtB_List[v133][v136] or ((6936 - 4612) <= (2425 - (559 + 1288)))) then
						local v179 = 1931 - (609 + 1322);
						local v180;
						while true do
							if (((4221 - (13 + 441)) == (14076 - 10309)) and (v179 == (2 - 1))) then
								v11.APLVar.RtB_List[v133][v136] = ((v180 == #v134) and true) or false;
								break;
							end
							if (((20365 - 16276) == (153 + 3936)) and (v179 == (0 - 0))) then
								v180 = 0 + 0;
								for v192 = 1 + 0, #v134 do
									if (((13229 - 8771) >= (917 + 757)) and v14:BuffUp(v108[v134[v192]])) then
										v180 = v180 + (1 - 0);
									end
								end
								v179 = 1 + 0;
							end
						end
					end
				elseif (((541 + 431) <= (1019 + 399)) and not v11.APLVar.RtB_List[v133][v136]) then
					v11.APLVar.RtB_List[v133][v136] = false;
					for v185 = 1 + 0, #v134 do
						if (v14:BuffUp(v108[v134[v185]]) or ((4832 + 106) < (5195 - (153 + 280)))) then
							v11.APLVar.RtB_List[v133][v136] = true;
							break;
						end
					end
				end
				v135 = 5 - 3;
			end
			if ((v135 == (0 + 0)) or ((989 + 1515) > (2232 + 2032))) then
				if (((1954 + 199) == (1561 + 592)) and not v11.APLVar.RtB_List) then
					v11.APLVar.RtB_List = {};
				end
				if (not v11.APLVar.RtB_List[v133] or ((771 - 264) >= (1602 + 989))) then
					v11.APLVar.RtB_List[v133] = {};
				end
				v135 = 668 - (89 + 578);
			end
		end
	end
	local function v110()
		if (((3202 + 1279) == (9315 - 4834)) and not v11.APLVar.RtB_Buffs) then
			v11.APLVar.RtB_Buffs = {};
			v11.APLVar.RtB_Buffs.Total = 1049 - (572 + 477);
			v11.APLVar.RtB_Buffs.Normal = 0 + 0;
			v11.APLVar.RtB_Buffs.Shorter = 0 + 0;
			v11.APLVar.RtB_Buffs.Longer = 0 + 0;
			local v151 = v81.RtBRemains();
			for v173 = 87 - (84 + 2), #v108 do
				local v174 = 0 - 0;
				local v175;
				while true do
					if ((v174 == (0 + 0)) or ((3170 - (497 + 345)) < (18 + 675))) then
						v175 = v14:BuffRemains(v108[v173]);
						if (((732 + 3596) == (5661 - (605 + 728))) and (v175 > (0 + 0))) then
							local v186 = 0 - 0;
							while true do
								if (((73 + 1515) >= (4924 - 3592)) and (v186 == (0 + 0))) then
									v11.APLVar.RtB_Buffs.Total = v11.APLVar.RtB_Buffs.Total + (2 - 1);
									if ((v175 == v151) or ((3152 + 1022) > (4737 - (457 + 32)))) then
										v11.APLVar.RtB_Buffs.Normal = v11.APLVar.RtB_Buffs.Normal + 1 + 0;
									elseif ((v175 > v151) or ((5988 - (832 + 570)) <= (78 + 4))) then
										v11.APLVar.RtB_Buffs.Longer = v11.APLVar.RtB_Buffs.Longer + 1 + 0;
									else
										v11.APLVar.RtB_Buffs.Shorter = v11.APLVar.RtB_Buffs.Shorter + (3 - 2);
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
	local function v111()
		local v137 = 0 + 0;
		while true do
			if (((4659 - (588 + 208)) == (10411 - 6548)) and (v137 == (1800 - (884 + 916)))) then
				if (not v11.APLVar.RtB_Reroll or ((589 - 307) <= (25 + 17))) then
					if (((5262 - (232 + 421)) >= (2655 - (1569 + 320))) and (v63 == "1+ Buff")) then
						v11.APLVar.RtB_Reroll = ((v110() <= (0 + 0)) and true) or false;
					elseif ((v63 == "Broadside") or ((219 + 933) == (8383 - 5895))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v82.Broadside) and true) or false;
					elseif (((4027 - (316 + 289)) > (8769 - 5419)) and (v63 == "Buried Treasure")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v82.BuriedTreasure) and true) or false;
					elseif (((41 + 836) > (1829 - (666 + 787))) and (v63 == "Grand Melee")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v82.GrandMelee) and true) or false;
					elseif ((v63 == "Skull and Crossbones") or ((3543 - (360 + 65)) <= (1730 + 121))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v82.SkullandCrossbones) and true) or false;
					elseif ((v63 == "Ruthless Precision") or ((419 - (79 + 175)) >= (5505 - 2013))) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v82.RuthlessPrecision) and true) or false;
					elseif (((3082 + 867) < (14884 - 10028)) and (v63 == "True Bearing")) then
						v11.APLVar.RtB_Reroll = (not v14:BuffUp(v82.TrueBearing) and true) or false;
					else
						local v204 = 0 - 0;
						while true do
							if ((v204 == (899 - (503 + 396))) or ((4457 - (92 + 89)) < (5850 - 2834))) then
								v11.APLVar.RtB_Reroll = false;
								v110();
								v204 = 1 + 0;
							end
							if (((2776 + 1914) > (16154 - 12029)) and ((1 + 1) == v204)) then
								if ((v82.Crackshot:IsAvailable() and v14:HasTier(70 - 39, 4 + 0) and (v110() <= (1 + 0 + v20(v14:BuffUp(v82.LoadedDiceBuff)))) and (v82.HiddenOpportunity:IsAvailable() or v14:BuffDown(v82.Broadside))) or ((152 - 102) >= (112 + 784))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if ((not v82.Crackshot:IsAvailable() and v82.HiddenOpportunity:IsAvailable() and not v14:BuffUp(v82.SkullandCrossbones) and (v110() < ((2 - 0) + v20(v14:BuffUp(v82.GrandMelee)))) and (v91 < (1246 - (485 + 759)))) or ((3965 - 2251) >= (4147 - (442 + 747)))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v204 = 1138 - (832 + 303);
							end
							if ((v204 == (949 - (88 + 858))) or ((455 + 1036) < (533 + 111))) then
								if (((29 + 675) < (1776 - (766 + 23))) and (v11.APLVar.RtB_Reroll or ((v11.APLVar.RtB_Buffs.Normal == (0 - 0)) and (v11.APLVar.RtB_Buffs.Longer >= (1 - 0)) and (v110() < (13 - 8)) and (v81.RtBRemains() <= (132 - 93))))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if (((4791 - (1036 + 37)) > (1352 + 554)) and (v15:FilteredTimeToDie("<", 23 - 11) or v10.BossFilteredFightRemains("<", 10 + 2))) then
									v11.APLVar.RtB_Reroll = false;
								end
								break;
							end
							if ((v204 == (1481 - (641 + 839))) or ((1871 - (910 + 3)) > (9266 - 5631))) then
								if (((5185 - (1466 + 218)) <= (2065 + 2427)) and (v110() <= (1150 - (556 + 592))) and v14:BuffUp(v82.BuriedTreasure) and v14:BuffDown(v82.GrandMelee) and (v91 < (1 + 1))) then
									v11.APLVar.RtB_Reroll = true;
								end
								if ((v82.Crackshot:IsAvailable() and v82.HiddenOpportunity:IsAvailable() and not v14:HasTier(839 - (329 + 479), 858 - (174 + 680)) and ((not v14:BuffUp(v82.TrueBearing) and v82.HiddenOpportunity:IsAvailable()) or (not v14:BuffUp(v82.Broadside) and not v82.HiddenOpportunity:IsAvailable())) and (v110() <= (3 - 2))) or ((7133 - 3691) < (1820 + 728))) then
									v11.APLVar.RtB_Reroll = true;
								end
								v204 = 741 - (396 + 343);
							end
						end
					end
				end
				return v11.APLVar.RtB_Reroll;
			end
		end
	end
	local function v112()
		return v95 >= ((v81.CPMaxSpend() - (1 + 0)) - v20((v14:StealthUp(true, true)) and v82.Crackshot:IsAvailable()));
	end
	local function v113()
		return (v82.HiddenOpportunity:IsAvailable() or (v97 >= ((1479 - (29 + 1448)) + v20(v82.ImprovedAmbush:IsAvailable()) + v20(v14:BuffUp(v82.Broadside))))) and (v98 >= (1439 - (135 + 1254)));
	end
	local function v114()
		return not v26 or (v91 < (7 - 5)) or (v14:BuffRemains(v82.BladeFlurry) > ((4 - 3) + v20(v82.KillingSpree:IsAvailable())));
	end
	local function v115()
		return v66 and (not v14:IsTanking(v15) or v76);
	end
	local function v116()
		return not v82.ShadowDanceTalent:IsAvailable() and ((v82.FanTheHammer:TalentRank() + v20(v82.QuickDraw:IsAvailable()) + v20(v82.Audacity:IsAvailable())) < (v20(v82.CountTheOdds:IsAvailable()) + v20(v82.KeepItRolling:IsAvailable())));
	end
	local function v117()
		return v14:BuffUp(v82.BetweentheEyes) and (not v82.HiddenOpportunity:IsAvailable() or (v14:BuffDown(v82.AudacityBuff) and ((v82.FanTheHammer:TalentRank() < (2 + 0)) or v14:BuffDown(v82.Opportunity)))) and not v82.Crackshot:IsAvailable();
	end
	local function v118()
		if (((4402 - (389 + 1138)) >= (2038 - (102 + 472))) and v82.Vanish:IsCastable() and v82.Vanish:IsReady() and v115() and v82.HiddenOpportunity:IsAvailable() and not v82.Crackshot:IsAvailable() and not v14:BuffUp(v82.Audacity) and (v116() or (v14:BuffStack(v82.Opportunity) < (6 + 0))) and v113()) then
			if (v10.Cast(v82.Vanish, v66) or ((2661 + 2136) >= (4563 + 330))) then
				return "Cast Vanish (HO)";
			end
		end
		if ((v82.Vanish:IsCastable() and v82.Vanish:IsReady() and v115() and (not v82.HiddenOpportunity:IsAvailable() or v82.Crackshot:IsAvailable()) and v112()) or ((2096 - (320 + 1225)) > (3681 - 1613))) then
			if (((1294 + 820) > (2408 - (157 + 1307))) and v10.Cast(v82.Vanish, v66)) then
				return "Cast Vanish (Finish)";
			end
		end
		if ((v82.ShadowDance:IsAvailable() and v82.ShadowDance:IsCastable() and v82.Crackshot:IsAvailable() and v112()) or ((4121 - (821 + 1038)) >= (7724 - 4628))) then
			if (v10.Cast(v82.ShadowDance) or ((247 + 2008) >= (6282 - 2745))) then
				return "Cast Shadow Dance";
			end
		end
		if ((v82.ShadowDance:IsAvailable() and v82.ShadowDance:IsCastable() and not v82.KeepItRolling:IsAvailable() and v117() and v14:BuffUp(v82.SliceandDice) and (v112() or v82.HiddenOpportunity:IsAvailable()) and (not v82.HiddenOpportunity:IsAvailable() or not v82.Vanish:IsReady())) or ((1428 + 2409) < (3236 - 1930))) then
			if (((3976 - (834 + 192)) == (188 + 2762)) and v10.Cast(v82.ShadowDance)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v82.ShadowDance:IsAvailable() and v82.ShadowDance:IsCastable() and v82.KeepItRolling:IsAvailable() and v117() and ((v82.KeepItRolling:CooldownRemains() <= (8 + 22)) or ((v82.KeepItRolling:CooldownRemains() >= (3 + 117)) and (v112() or v82.HiddenOpportunity:IsAvailable())))) or ((7316 - 2593) < (3602 - (300 + 4)))) then
			if (((304 + 832) >= (402 - 248)) and v10.Cast(v82.ShadowDance)) then
				return "Cast Shadow Dance";
			end
		end
		if ((v82.Shadowmeld:IsAvailable() and v82.Shadowmeld:IsReady()) or ((633 - (112 + 250)) > (1893 + 2855))) then
			if (((11874 - 7134) >= (1806 + 1346)) and ((v82.Crackshot:IsAvailable() and v112()) or (not v82.Crackshot:IsAvailable() and ((v82.CountTheOdds:IsAvailable() and v112()) or v82.HiddenOpportunity:IsAvailable())))) then
				if (v10.Cast(v82.Shadowmeld, v28) or ((1334 + 1244) >= (2536 + 854))) then
					return "Cast Shadowmeld";
				end
			end
		end
	end
	local function v119()
		local v138 = 0 + 0;
		while true do
			if (((31 + 10) <= (3075 - (1001 + 413))) and (v138 == (2 - 1))) then
				v92 = v79.HandleBottomTrinket(v85, v27, 922 - (244 + 638), nil);
				if (((1294 - (627 + 66)) < (10607 - 7047)) and v92) then
					return v92;
				end
				break;
			end
			if (((837 - (512 + 90)) < (2593 - (1665 + 241))) and (v138 == (717 - (373 + 344)))) then
				v92 = v79.HandleTopTrinket(v85, v27, 19 + 21, nil);
				if (((1204 + 3345) > (3041 - 1888)) and v92) then
					return v92;
				end
				v138 = 1 - 0;
			end
		end
	end
	local function v120()
		if ((v27 and v82.AdrenalineRush:IsCastable() and (not v14:BuffUp(v82.AdrenalineRush) or (v14:StealthUp(true, true) and v82.Crackshot:IsAvailable() and v82.ImprovedAdrenalineRush:IsAvailable())) and ((v96 <= (1101 - (35 + 1064))) or not v82.ImprovedAdrenalineRush:IsAvailable())) or ((3401 + 1273) < (9995 - 5323))) then
			if (((15 + 3653) < (5797 - (298 + 938))) and v10.Cast(v82.AdrenalineRush)) then
				return "Cast Adrenaline Rush";
			end
		end
		if ((v82.BladeFlurry:IsReady() and (v91 >= ((1261 - (233 + 1026)) - v20(v82.UnderhandedUpperhand:IsAvailable()))) and (v14:BuffRemains(v82.BladeFlurry) < v14:GCDRemains())) or (v82.DeftManeuvers:IsAvailable() and (v91 >= (1671 - (636 + 1030))) and not v112()) or ((233 + 222) == (3522 + 83))) then
			if (v69 or ((792 + 1871) == (224 + 3088))) then
				v10.CastSuggested(v82.BladeFlurry);
			elseif (((4498 - (55 + 166)) <= (868 + 3607)) and v10.Cast(v82.BladeFlurry)) then
				return "Cast Blade Flurry";
			end
		end
		if (v82.RolltheBones:IsReady() or ((88 + 782) == (4540 - 3351))) then
			if (((1850 - (36 + 261)) <= (5478 - 2345)) and (v111() or (v81.RtBRemains() <= (v20(v14:HasTier(1399 - (34 + 1334), 2 + 2)) + (v20((v82.ShadowDance:CooldownRemains() <= (1 + 0)) or (v82.Vanish:CooldownRemains() <= (1284 - (1035 + 248)))) * (27 - (20 + 1))))))) then
				if (v10.Cast(v82.RolltheBones) or ((1166 + 1071) >= (3830 - (134 + 185)))) then
					return "Cast Roll the Bones";
				end
			end
		end
		if ((v82.KeepItRolling:IsReady() and not v111() and (v110() >= ((1136 - (549 + 584)) + v20(v14:HasTier(716 - (314 + 371), 13 - 9)))) and (v14:BuffDown(v82.ShadowDance) or (v110() >= (974 - (478 + 490))))) or ((702 + 622) > (4192 - (786 + 386)))) then
			if (v10.Cast(v82.KeepItRolling) or ((9690 - 6698) == (3260 - (1055 + 324)))) then
				return "Cast Keep it Rolling";
			end
		end
		if (((4446 - (1093 + 247)) > (1357 + 169)) and v82.GhostlyStrike:IsAvailable() and v82.GhostlyStrike:IsReady()) then
			if (((318 + 2705) < (15364 - 11494)) and v10.Cast(v82.GhostlyStrike)) then
				return "Cast Ghostly Strike";
			end
		end
		if (((484 - 341) > (210 - 136)) and v27 and v82.Sepsis:IsAvailable() and v82.Sepsis:IsReady()) then
			if (((45 - 27) < (752 + 1360)) and ((v82.Crackshot:IsAvailable() and v82.BetweentheEyes:IsReady() and v112() and not v14:StealthUp(true, true)) or (not v82.Crackshot:IsAvailable() and v15:FilteredTimeToDie(">", 42 - 31) and v14:BuffUp(v82.BetweentheEyes)) or v10.BossFilteredFightRemains("<", 37 - 26))) then
				if (((828 + 269) <= (4163 - 2535)) and v10.Cast(v82.Sepsis)) then
					return "Cast Sepsis";
				end
			end
		end
		if (((5318 - (364 + 324)) == (12692 - 8062)) and v82.BladeRush:IsReady() and (v101 > (9 - 5)) and not v14:StealthUp(true, true)) then
			if (((1174 + 2366) > (11226 - 8543)) and v10.Cast(v82.BladeRush)) then
				return "Cast Blade Rush";
			end
		end
		if (((7677 - 2883) >= (9946 - 6671)) and not v14:StealthUp(true, true, true)) then
			v92 = v118();
			if (((2752 - (1249 + 19)) == (1340 + 144)) and v92) then
				return v92;
			end
		end
		if (((5573 - 4141) < (4641 - (686 + 400))) and v27 and v82.ThistleTea:IsAvailable() and v82.ThistleTea:IsCastable() and not v14:BuffUp(v82.ThistleTea) and ((v100 >= (79 + 21)) or v10.BossFilteredFightRemains("<", v82.ThistleTea:Charges() * (235 - (73 + 156))))) then
			if (v10.Cast(v82.ThistleTea) or ((6 + 1059) > (4389 - (721 + 90)))) then
				return "Cast Thistle Tea";
			end
		end
		if (v82.BloodFury:IsCastable() or ((54 + 4741) < (4568 - 3161))) then
			if (((2323 - (224 + 246)) < (7796 - 2983)) and v10.Cast(v82.BloodFury, v28)) then
				return "Cast Blood Fury";
			end
		end
		if (v82.Berserking:IsCastable() or ((5193 - 2372) < (441 + 1990))) then
			if (v10.Cast(v82.Berserking, v28) or ((69 + 2805) < (1602 + 579))) then
				return "Cast Berserking";
			end
		end
		if (v82.Fireblood:IsCastable() or ((5345 - 2656) <= (1141 - 798))) then
			if (v10.Cast(v82.Fireblood, v28) or ((2382 - (203 + 310)) == (4002 - (1238 + 755)))) then
				return "Cast Fireblood";
			end
		end
		if (v82.AncestralCall:IsCastable() or ((248 + 3298) < (3856 - (709 + 825)))) then
			if (v10.Cast(v82.AncestralCall, v28) or ((3836 - 1754) == (6952 - 2179))) then
				return "Cast Ancestral Call";
			end
		end
		v92 = v119();
		if (((4108 - (196 + 668)) > (4165 - 3110)) and v92) then
			return v92;
		end
	end
	local function v121()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (833 - (171 + 662))) or ((3406 - (4 + 89)) <= (6231 - 4453))) then
				if ((v82.BladeFlurry:IsReady() and v82.BladeFlurry:IsCastable() and v26 and v82.Subterfuge:IsAvailable() and v82.HiddenOpportunity:IsAvailable() and (v91 >= (1 + 1)) and (v14:BuffRemains(v82.BladeFlurry) <= v14:GCDRemains())) or ((6241 - 4820) >= (826 + 1278))) then
					if (((3298 - (35 + 1451)) <= (4702 - (28 + 1425))) and v69) then
						v10.Press(v82.BladeFlurry);
					elseif (((3616 - (941 + 1052)) <= (1877 + 80)) and v10.Press(v82.BladeFlurry)) then
						return "Cast Blade Flurry";
					end
				end
				if (((5926 - (822 + 692)) == (6298 - 1886)) and v82.ColdBlood:IsCastable() and v14:BuffDown(v82.ColdBlood) and v15:IsSpellInRange(v82.Dispatch) and v112()) then
					if (((825 + 925) >= (1139 - (45 + 252))) and v10.Cast(v82.ColdBlood)) then
						return "Cast Cold Blood";
					end
				end
				v139 = 1 + 0;
			end
			if (((1505 + 2867) > (4502 - 2652)) and (v139 == (434 - (114 + 319)))) then
				if (((332 - 100) < (1051 - 230)) and v82.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v82.BetweentheEyes) and v112() and v82.Crackshot:IsAvailable()) then
					if (((331 + 187) < (1343 - 441)) and v10.Press(v82.BetweentheEyes)) then
						return "Cast Between the Eyes";
					end
				end
				if (((6273 - 3279) > (2821 - (556 + 1407))) and v82.Dispatch:IsCastable() and v15:IsSpellInRange(v82.Dispatch) and v112()) then
					if (v10.Press(v82.Dispatch) or ((4961 - (741 + 465)) <= (1380 - (170 + 295)))) then
						return "Cast Dispatch";
					end
				end
				v139 = 2 + 0;
			end
			if (((3625 + 321) > (9215 - 5472)) and (v139 == (2 + 0))) then
				if ((v82.PistolShot:IsCastable() and v15:IsSpellInRange(v82.PistolShot) and v82.Crackshot:IsAvailable() and (v82.FanTheHammer:TalentRank() >= (2 + 0)) and (v14:BuffStack(v82.Opportunity) >= (4 + 2)) and ((v14:BuffUp(v82.Broadside) and (v96 <= (1231 - (957 + 273)))) or v14:BuffUp(v82.GreenskinsWickersBuff))) or ((358 + 977) >= (1324 + 1982))) then
					if (((18457 - 13613) > (5937 - 3684)) and v10.Press(v82.PistolShot)) then
						return "Cast Pistol Shot";
					end
				end
				if (((1380 - 928) == (2238 - 1786)) and v82.Ambush:IsCastable() and v15:IsSpellInRange(v82.Ambush) and v82.HiddenOpportunity:IsAvailable()) then
					if (v10.Press(v82.Ambush) or ((6337 - (389 + 1391)) < (1310 + 777))) then
						return "Cast Ambush";
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v140 = 0 + 0;
		while true do
			if (((8819 - 4945) == (4825 - (783 + 168))) and (v140 == (0 - 0))) then
				if ((v82.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v82.BetweentheEyes) and not v82.Crackshot:IsAvailable() and ((v14:BuffRemains(v82.BetweentheEyes) < (4 + 0)) or v82.ImprovedBetweenTheEyes:IsAvailable() or v82.GreenskinsWickers:IsAvailable() or v14:HasTier(341 - (309 + 2), 12 - 8)) and v14:BuffDown(v82.GreenskinsWickers)) or ((3150 - (1090 + 122)) > (1600 + 3335))) then
					if (v10.Press(v82.BetweentheEyes) or ((14290 - 10035) < (2343 + 1080))) then
						return "Cast Between the Eyes";
					end
				end
				if (((2572 - (628 + 490)) <= (447 + 2044)) and v82.BetweentheEyes:IsCastable() and v15:IsSpellInRange(v82.BetweentheEyes) and v82.Crackshot:IsAvailable() and (v82.Vanish:CooldownRemains() > (111 - 66)) and (v82.ShadowDance:CooldownRemains() > (54 - 42))) then
					if (v10.Press(v82.BetweentheEyes) or ((4931 - (431 + 343)) <= (5660 - 2857))) then
						return "Cast Between the Eyes";
					end
				end
				v140 = 2 - 1;
			end
			if (((3834 + 1019) >= (382 + 2600)) and (v140 == (1697 - (556 + 1139)))) then
				if (((4149 - (6 + 9)) > (615 + 2742)) and v82.ColdBlood:IsCastable() and v14:BuffDown(v82.ColdBlood) and v15:IsSpellInRange(v82.Dispatch)) then
					if (v10.Cast(v82.ColdBlood, v54) or ((1751 + 1666) < (2703 - (28 + 141)))) then
						return "Cast Cold Blood";
					end
				end
				if ((v82.Dispatch:IsCastable() and v15:IsSpellInRange(v82.Dispatch)) or ((1055 + 1667) <= (201 - 37))) then
					if (v10.Press(v82.Dispatch) or ((1706 + 702) < (3426 - (486 + 831)))) then
						return "Cast Dispatch";
					end
				end
				break;
			end
			if ((v140 == (2 - 1)) or ((115 - 82) == (275 + 1180))) then
				if ((v82.SliceandDice:IsCastable() and (v10.FilteredFightRemains(v90, ">", v14:BuffRemains(v82.SliceandDice), true) or (v14:BuffRemains(v82.SliceandDice) == (0 - 0))) and (v14:BuffRemains(v82.SliceandDice) < (((1264 - (668 + 595)) + v96) * (1.8 + 0)))) or ((90 + 353) >= (10949 - 6934))) then
					if (((3672 - (23 + 267)) > (2110 - (1129 + 815))) and v10.Press(v82.SliceandDice)) then
						return "Cast Slice and Dice";
					end
				end
				if ((v82.KillingSpree:IsCastable() and v15:IsSpellInRange(v82.KillingSpree) and (v15:DebuffUp(v82.GhostlyStrike) or not v82.GhostlyStrike:IsAvailable())) or ((667 - (371 + 16)) == (4809 - (1326 + 424)))) then
					if (((3562 - 1681) > (4724 - 3431)) and v10.Cast(v82.KillingSpree)) then
						return "Cast Killing Spree";
					end
				end
				v140 = 120 - (88 + 30);
			end
		end
	end
	local function v123()
		local v141 = 771 - (720 + 51);
		while true do
			if (((5243 - 2886) == (4133 - (421 + 1355))) and ((4 - 1) == v141)) then
				if (((61 + 62) == (1206 - (286 + 797))) and not v82.FanTheHammer:IsAvailable() and v14:BuffUp(v82.Opportunity) and ((v101 > (3.5 - 2)) or (v97 <= ((1 - 0) + v20(v14:BuffUp(v82.Broadside)))) or v82.QuickDraw:IsAvailable() or (v82.Audacity:IsAvailable() and v14:BuffDown(v82.AudacityBuff)))) then
					if (v10.Press(v82.PistolShot) or ((1495 - (397 + 42)) >= (1060 + 2332))) then
						return "Cast Pistol Shot";
					end
				end
				if ((v82.SinisterStrike:IsCastable() and v15:IsSpellInRange(v82.SinisterStrike)) or ((1881 - (24 + 776)) < (1656 - 581))) then
					if (v10.Press(v82.SinisterStrike) or ((1834 - (222 + 563)) >= (9764 - 5332))) then
						return "Cast Sinister Strike";
					end
				end
				break;
			end
			if ((v141 == (1 + 0)) or ((4958 - (23 + 167)) <= (2644 - (690 + 1108)))) then
				if ((v82.FanTheHammer:IsAvailable() and v82.Audacity:IsAvailable() and v82.HiddenOpportunity:IsAvailable() and v14:BuffUp(v82.Opportunity) and v14:BuffDown(v82.AudacityBuff)) or ((1212 + 2146) <= (1172 + 248))) then
					if (v10.Press(v82.PistolShot) or ((4587 - (40 + 808)) <= (495 + 2510))) then
						return "Cast Pistol Shot (Audacity)";
					end
				end
				if ((v14:BuffUp(v82.GreenskinsWickersBuff) and ((not v82.FanTheHammer:IsAvailable() and v14:BuffUp(v82.Opportunity)) or (v14:BuffRemains(v82.GreenskinsWickersBuff) < (3.5 - 2)))) or ((1586 + 73) >= (1129 + 1005))) then
					if (v10.Press(v82.PistolShot) or ((1788 + 1472) < (2926 - (47 + 524)))) then
						return "Cast Pistol Shot (GSW Dump)";
					end
				end
				v141 = 2 + 0;
			end
			if ((v141 == (5 - 3)) or ((999 - 330) == (9630 - 5407))) then
				if ((v82.FanTheHammer:IsAvailable() and v14:BuffUp(v82.Opportunity) and ((v14:BuffStack(v82.Opportunity) >= (1732 - (1165 + 561))) or (v14:BuffRemains(v82.Opportunity) < (1 + 1)))) or ((5240 - 3548) < (225 + 363))) then
					if (v10.Press(v82.PistolShot) or ((5276 - (341 + 138)) < (986 + 2665))) then
						return "Cast Pistol Shot (FtH Dump)";
					end
				end
				if ((v82.FanTheHammer:IsAvailable() and v14:BuffUp(v82.Opportunity) and (v97 > ((1 - 0) + (v20(v82.QuickDraw:IsAvailable()) * v82.FanTheHammer:TalentRank()))) and ((not v82.Vanish:IsReady() and not v82.ShadowDance:IsReady()) or v14:StealthUp(true, true) or not v82.Crackshot:IsAvailable() or (v82.FanTheHammer:TalentRank() <= (327 - (89 + 237))))) or ((13437 - 9260) > (10210 - 5360))) then
					if (v10.Press(v82.PistolShot) or ((1281 - (581 + 300)) > (2331 - (855 + 365)))) then
						return "Cast Pistol Shot";
					end
				end
				v141 = 6 - 3;
			end
			if (((997 + 2054) > (2240 - (1030 + 205))) and (v141 == (0 + 0))) then
				if (((3436 + 257) <= (4668 - (156 + 130))) and v27 and v82.EchoingReprimand:IsReady()) then
					if (v10.Cast(v82.EchoingReprimand, nil, v75) or ((7457 - 4175) > (6910 - 2810))) then
						return "Cast Echoing Reprimand";
					end
				end
				if ((v82.Ambush:IsCastable() and v82.HiddenOpportunity:IsAvailable() and v14:BuffUp(v82.AudacityBuff)) or ((7332 - 3752) < (750 + 2094))) then
					if (((52 + 37) < (4559 - (10 + 59))) and v10.Press(v82.Ambush)) then
						return "Cast Ambush (High-Prio Buffed)";
					end
				end
				v141 = 1 + 0;
			end
		end
	end
	local function v124()
		v78();
		v25 = EpicSettings.Toggles['ooc'];
		v26 = EpicSettings.Toggles['aoe'];
		v27 = EpicSettings.Toggles['cds'];
		v93 = (v82.AcrobaticStrikes:IsAvailable() and (49 - 39)) or (1169 - (671 + 492));
		v96 = v14:ComboPoints();
		v95 = v81.EffectiveComboPoints(v96);
		v97 = v14:ComboPointsDeficit();
		v102 = (v14:BuffUp(v82.AdrenalineRush, nil, true) and -(40 + 10)) or (1215 - (369 + 846));
		v98 = v107();
		v99 = v14:EnergyRegen();
		v101 = v106(v102);
		v100 = v14:EnergyDeficitPredicted(nil, v102);
		if (v26 or ((1320 + 3663) < (1543 + 265))) then
			local v152 = 1945 - (1036 + 909);
			while true do
				if (((3045 + 784) > (6327 - 2558)) and ((204 - (11 + 192)) == v152)) then
					v91 = #v90;
					break;
				end
				if (((751 + 734) <= (3079 - (135 + 40))) and (v152 == (0 - 0))) then
					v89 = v14:GetEnemiesInRange(19 + 11);
					v90 = v14:GetEnemiesInRange(v93);
					v152 = 2 - 1;
				end
			end
		else
			v91 = 1 - 0;
		end
		v92 = v81.CrimsonVial();
		if (((4445 - (50 + 126)) == (11887 - 7618)) and v92) then
			return v92;
		end
		v81.Poisons();
		if (((86 + 301) <= (4195 - (1233 + 180))) and v83.Healthstone:IsReady() and (v14:HealthPercentage() < v34) and not (v14:IsChanneling() or v14:IsCasting())) then
			if (v10.Cast(v84.Healthstone) or ((2868 - (522 + 447)) <= (2338 - (107 + 1314)))) then
				return "Healthstone ";
			end
		end
		if ((v83.RefreshingHealingPotion:IsReady() and (v14:HealthPercentage() < v32) and not (v14:IsChanneling() or v14:IsCasting())) or ((2001 + 2311) <= (2669 - 1793))) then
			if (((948 + 1284) <= (5154 - 2558)) and v10.Cast(v84.RefreshingHealingPotion)) then
				return "RefreshingHealingPotion ";
			end
		end
		if (((8289 - 6194) < (5596 - (716 + 1194))) and v82.Feint:IsCastable() and (v14:HealthPercentage() <= v57) and not (v14:IsChanneling() or v14:IsCasting())) then
			if (v10.Cast(v82.Feint) or ((28 + 1567) >= (480 + 3994))) then
				return "Cast Feint (Defensives)";
			end
		end
		if ((not v14:AffectingCombat() and not v14:IsMounted() and v58) or ((5122 - (74 + 429)) < (5559 - 2677))) then
			v92 = v81.Stealth(v82.Stealth2, nil);
			if (v92 or ((146 + 148) >= (11058 - 6227))) then
				return "Stealth (OOC): " .. v92;
			end
		end
		if (((1436 + 593) <= (9507 - 6423)) and not v14:AffectingCombat() and (v82.Vanish:TimeSinceLastCast() > (2 - 1)) and v15:IsInRange(441 - (279 + 154)) and v25) then
			if ((v79.TargetIsValid() and v15:IsInRange(788 - (454 + 324)) and not (v14:IsChanneling() or v14:IsCasting())) or ((1603 + 434) == (2437 - (12 + 5)))) then
				local v176 = 0 + 0;
				while true do
					if (((11358 - 6900) > (1443 + 2461)) and ((1093 - (277 + 816)) == v176)) then
						if (((1862 - 1426) >= (1306 - (1058 + 125))) and v82.BladeFlurry:IsReady() and v14:BuffDown(v82.BladeFlurry) and v82.UnderhandedUpperhand:IsAvailable() and not v14:StealthUp(true, true)) then
							if (((94 + 406) < (2791 - (815 + 160))) and v10.Cast(v82.BladeFlurry)) then
								return "Blade Flurry (Opener)";
							end
						end
						if (((15334 - 11760) == (8483 - 4909)) and not v14:StealthUp(true, false)) then
							local v188 = 0 + 0;
							while true do
								if (((645 - 424) < (2288 - (41 + 1857))) and (v188 == (1893 - (1222 + 671)))) then
									v92 = v81.Stealth(v81.StealthSpell());
									if (v92 or ((5719 - 3506) <= (2042 - 621))) then
										return v92;
									end
									break;
								end
							end
						end
						v176 = 1183 - (229 + 953);
					end
					if (((4832 - (1111 + 663)) < (6439 - (874 + 705))) and ((1 + 0) == v176)) then
						if (v79.TargetIsValid() or ((885 + 411) >= (9241 - 4795))) then
							local v189 = 0 + 0;
							while true do
								if ((v189 == (681 - (642 + 37))) or ((318 + 1075) > (719 + 3770))) then
									if (v82.SinisterStrike:IsCastable() or ((11107 - 6683) < (481 - (233 + 221)))) then
										if (v10.Cast(v82.SinisterStrike) or ((4617 - 2620) > (3358 + 457))) then
											return "Cast Sinister Strike (Opener)";
										end
									end
									break;
								end
								if (((5006 - (718 + 823)) > (1204 + 709)) and ((805 - (266 + 539)) == v189)) then
									if (((2074 - 1341) < (3044 - (636 + 589))) and v82.AdrenalineRush:IsReady() and v82.ImprovedAdrenalineRush:IsAvailable() and (v96 <= (4 - 2))) then
										if (v10.Cast(v82.AdrenalineRush) or ((9064 - 4669) == (3769 + 986))) then
											return "Cast Adrenaline Rush (Opener)";
										end
									end
									if ((v82.RolltheBones:IsReady() and not v14:DebuffUp(v82.Dreadblades) and ((v110() == (0 + 0)) or v111())) or ((4808 - (657 + 358)) < (6272 - 3903))) then
										if (v10.Cast(v82.RolltheBones) or ((9304 - 5220) == (1452 - (1151 + 36)))) then
											return "Cast Roll the Bones (Opener)";
										end
									end
									v189 = 1 + 0;
								end
								if (((1146 + 3212) == (13014 - 8656)) and (v189 == (1833 - (1552 + 280)))) then
									if ((v82.SliceandDice:IsReady() and (v14:BuffRemains(v82.SliceandDice) < (((835 - (64 + 770)) + v96) * (1.8 + 0)))) or ((7123 - 3985) < (177 + 816))) then
										if (((4573 - (157 + 1086)) > (4649 - 2326)) and v10.Press(v82.SliceandDice)) then
											return "Cast Slice and Dice (Opener)";
										end
									end
									if (v14:StealthUp(true, false) or ((15880 - 12254) == (6118 - 2129))) then
										local v197 = 0 - 0;
										while true do
											if ((v197 == (819 - (599 + 220))) or ((1823 - 907) == (4602 - (1813 + 118)))) then
												v92 = v121();
												if (((199 + 73) == (1489 - (841 + 376))) and v92) then
													return "Stealth (Opener): " .. v92;
												end
												v197 = 1 - 0;
											end
											if (((988 + 3261) <= (13208 - 8369)) and (v197 == (860 - (464 + 395)))) then
												if (((7126 - 4349) < (1537 + 1663)) and v82.KeepItRolling:IsAvailable() and v82.GhostlyStrike:IsReady() and v82.EchoingReprimand:IsAvailable()) then
													if (((932 - (467 + 370)) < (4044 - 2087)) and v10.Press(v82.GhostlyStrike)) then
														return "Cast Ghostly Strike KiR (Opener)";
													end
												end
												if (((607 + 219) < (5885 - 4168)) and v82.Ambush:IsCastable()) then
													if (((223 + 1203) >= (2570 - 1465)) and v10.Cast(v82.Ambush)) then
														return "Cast Ambush (Opener)";
													end
												end
												break;
											end
										end
									elseif (((3274 - (150 + 370)) <= (4661 - (74 + 1208))) and v112()) then
										local v201 = 0 - 0;
										while true do
											if ((v201 == (0 - 0)) or ((2795 + 1132) == (1803 - (14 + 376)))) then
												v92 = v122();
												if (v92 or ((2000 - 846) <= (510 + 278))) then
													return "Finish (Opener): " .. v92;
												end
												break;
											end
										end
									end
									v189 = 2 + 0;
								end
							end
						end
						return;
					end
				end
			end
		end
		if ((v82.FanTheHammer:IsAvailable() and (v82.PistolShot:TimeSinceLastCast() < v14:GCDRemains())) or ((1567 + 76) > (9900 - 6521))) then
			v96 = v24(v96, v81.FanTheHammerCP());
		end
		if (v79.TargetIsValid() or ((2109 + 694) > (4627 - (23 + 55)))) then
			local v153 = 0 - 0;
			while true do
				if ((v153 == (1 + 0)) or ((198 + 22) >= (4685 - 1663))) then
					v92 = v123();
					if (((888 + 1934) == (3723 - (652 + 249))) and v92) then
						return "Build: " .. v92;
					end
					if ((v82.ArcaneTorrent:IsCastable() and v15:IsSpellInRange(v82.SinisterStrike) and (v100 > ((40 - 25) + v99))) or ((2929 - (708 + 1160)) == (5040 - 3183))) then
						if (((5032 - 2272) > (1391 - (10 + 17))) and v10.Cast(v82.ArcaneTorrent, v28)) then
							return "Cast Arcane Torrent";
						end
					end
					if ((v82.ArcanePulse:IsCastable() and v15:IsSpellInRange(v82.SinisterStrike)) or ((1101 + 3801) <= (5327 - (1400 + 332)))) then
						if (v10.Cast(v82.ArcanePulse) or ((7387 - 3535) == (2201 - (242 + 1666)))) then
							return "Cast Arcane Pulse";
						end
					end
					v153 = 1 + 1;
				end
				if ((v153 == (0 + 0)) or ((1329 + 230) == (5528 - (850 + 90)))) then
					v92 = v120();
					if (v92 or ((7853 - 3369) == (2178 - (360 + 1030)))) then
						return "CDs: " .. v92;
					end
					if (((4043 + 525) >= (11027 - 7120)) and (v14:StealthUp(true, true) or v14:BuffUp(v82.Shadowmeld))) then
						local v183 = 0 - 0;
						while true do
							if (((2907 - (909 + 752)) < (4693 - (109 + 1114))) and (v183 == (0 - 0))) then
								v92 = v121();
								if (((1584 + 2484) >= (1214 - (6 + 236))) and v92) then
									return "Stealth: " .. v92;
								end
								break;
							end
						end
					end
					if (((311 + 182) < (3134 + 759)) and v112()) then
						local v184 = 0 - 0;
						while true do
							if (((0 - 0) == v184) or ((2606 - (1076 + 57)) >= (548 + 2784))) then
								v92 = v122();
								if (v92 or ((4740 - (579 + 110)) <= (92 + 1065))) then
									return "Finish: " .. v92;
								end
								break;
							end
						end
					end
					v153 = 1 + 0;
				end
				if (((321 + 283) < (3288 - (174 + 233))) and (v153 == (5 - 3))) then
					if ((v82.LightsJudgment:IsCastable() and v15:IsInMeleeRange(8 - 3)) or ((401 + 499) == (4551 - (663 + 511)))) then
						if (((3978 + 481) > (129 + 462)) and v10.Cast(v82.LightsJudgment, v28)) then
							return "Cast Lights Judgment";
						end
					end
					if (((10475 - 7077) >= (1451 + 944)) and v82.BagofTricks:IsCastable() and v15:IsInMeleeRange(11 - 6)) then
						if (v10.Cast(v82.BagofTricks, v28) or ((5284 - 3101) >= (1348 + 1476))) then
							return "Cast Bag of Tricks";
						end
					end
					if (((3768 - 1832) == (1380 + 556)) and v82.PistolShot:IsCastable() and v15:IsSpellInRange(v82.PistolShot) and not v15:IsInRange(v93) and not v14:StealthUp(true, true) and (v100 < (3 + 22)) and ((v97 >= (723 - (478 + 244))) or (v101 <= (518.2 - (440 + 77))))) then
						if (v10.Cast(v82.PistolShot) or ((2197 + 2635) < (15785 - 11472))) then
							return "Cast Pistol Shot (OOR)";
						end
					end
					if (((5644 - (655 + 901)) > (719 + 3155)) and v82.SinisterStrike:IsCastable()) then
						if (((3317 + 1015) == (2926 + 1406)) and v10.Cast(v82.SinisterStrike)) then
							return "Cast Sinister Strike Filler";
						end
					end
					break;
				end
			end
		end
	end
	local function v125()
		v10.Print("Outlaw Rogue by Epic. Supported by Gojira");
	end
	v10.SetAPL(1047 - 787, v124, v125);
end;
return v0["Epix_Rogue_Outlaw.lua"]();

