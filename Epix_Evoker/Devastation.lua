local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1429 - (455 + 974);
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((2731 - (27 + 656)) == (2649 + 382))) then
			v6 = v0[v4];
			if (not v6 or ((438 + 761) >= (1201 + 968))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1 - 0)) or ((2547 - (340 + 1571)) == (751 + 1151))) then
			return v6(...);
		end
	end
end
v0["Epix_Evoker_Devastation.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Target;
	local v15 = v12.Focus;
	local v16 = v12.Pet;
	local v17 = v10.Spell;
	local v18 = v10.Item;
	local v19 = EpicLib;
	local v20 = v19.Cast;
	local v21 = v19.CastPooling;
	local v22 = v19.CastAnnotated;
	local v23 = v19.CastSuggested;
	local v24 = v19.Press;
	local v25 = v19.Macro;
	local v26 = v19.Commons.Evoker;
	local v27 = v19.Commons.Everyone.num;
	local v28 = v19.Commons.Everyone.bool;
	local v29 = math.max;
	local v30 = v17.Evoker.Devastation;
	local v31 = v18.Evoker.Devastation;
	local v32 = v25.Evoker.Devastation;
	local v33 = {};
	local v34 = v19.Commons.Everyone;
	local v35 = false;
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
	local v62;
	local v63;
	local v64;
	local v65;
	local v66;
	local v67 = v13:GetEquipment();
	local v68 = (v67[1785 - (1733 + 39)] and v18(v67[35 - 22])) or v18(1034 - (125 + 909));
	local v69 = (v67[1962 - (1096 + 852)] and v18(v67[7 + 7])) or v18(0 - 0);
	local v70;
	local v71;
	local v72;
	local v73 = ((v30.EssenceAttunement:IsAvailable()) and (2 + 0)) or (513 - (409 + 103));
	local v74 = 238 - (46 + 190);
	local v75, v76, v77;
	local v78;
	local v79, v80;
	local v81 = 99 - (51 + 44);
	local v82 = 4 + 9;
	local v83 = v30.BlastFurnace:TalentRank();
	local v84;
	local v85;
	local v86 = false;
	local v87 = 12428 - (1114 + 203);
	local v88 = 11837 - (228 + 498);
	local v89;
	local v90;
	local v91 = 0 + 0;
	local v92 = 0 + 0;
	local v93 = 664 - (174 + 489);
	local v94 = 2 - 1;
	local v95;
	local function v96()
		local v110;
		if (UnitInRaid("player") or ((6744 - (830 + 1075)) <= (3804 - (303 + 221)))) then
			v110 = v12.Raid;
		elseif (UnitInParty("player") or ((4943 - (231 + 1038)) <= (1635 + 327))) then
			v110 = v12.Party;
		else
			return false;
		end
		local v111 = nil;
		for v125, v126 in pairs(v110) do
			if ((v126:Exists() and (UnitGroupRolesAssigned(v125) == "HEALER")) or ((3056 - (171 + 991)) < (5794 - 4388))) then
				v111 = v126;
			end
		end
		return v111;
	end
	v10:RegisterForEvent(function()
		v67 = v13:GetEquipment();
		v68 = (v67[34 - 21] and v18(v67[32 - 19])) or v18(0 + 0);
		v69 = (v67[48 - 34] and v18(v67[40 - 26])) or v18(0 - 0);
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v73 = ((v30.EssenceAttunement:IsAvailable()) and (6 - 4)) or (1249 - (111 + 1137));
		v83 = v30.BlastFurnace:TalentRank();
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v112 = 158 - (91 + 67);
		local v113;
		while true do
			if (((4678 - 3106) >= (382 + 1149)) and (v112 == (523 - (423 + 100)))) then
				v113 = false;
				v87 = 78 + 11033;
				v112 = 2 - 1;
			end
			if ((v112 == (1 + 0)) or ((5458 - (326 + 445)) < (19821 - 15279))) then
				v88 = 24753 - 13642;
				for v150 in pairs(v26.FirestormTracker) do
					v26.FirestormTracker[v150] = nil;
				end
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v97()
		if (((7681 - 4390) > (2378 - (530 + 181))) and (v30.Firestorm:TimeSinceLastCast() > (893 - (614 + 267)))) then
			return false;
		end
		if (v26.FirestormTracker[v14:GUID()] or ((905 - (19 + 13)) == (3310 - 1276))) then
			if ((v26.FirestormTracker[v14:GUID()] > (GetTime() - (4.5 - 2))) or ((8044 - 5228) < (3 + 8))) then
				return true;
			end
		end
		return false;
	end
	local function v98()
		local v114 = 0 - 0;
		while true do
			if (((7670 - 3971) < (6518 - (1293 + 519))) and (v114 == (3 - 1))) then
				if (((6908 - 4262) >= (1675 - 799)) and v30.LivingFlame:IsCastable() and not v30.Firestorm:IsAvailable()) then
					if (((2647 - 2033) <= (7500 - 4316)) and v24(v30.LivingFlame, not v14:IsInRange(14 + 11), v90)) then
						return "living_flame precombat";
					end
				end
				if (((638 + 2488) == (7262 - 4136)) and v30.AzureStrike:IsCastable()) then
					if (v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike)) or ((506 + 1681) >= (1646 + 3308))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
			if ((v114 == (0 + 0)) or ((4973 - (709 + 387)) == (5433 - (673 + 1185)))) then
				if (((2050 - 1343) > (2029 - 1397)) and (v65 == "Auto")) then
					if ((v30.SourceofMagic:IsCastable() and v15:IsInRange(41 - 16) and (v95 == v15:GUID()) and (v15:BuffRemains(v30.SourceofMagicBuff) < (215 + 85))) or ((408 + 138) >= (3623 - 939))) then
						if (((360 + 1105) <= (8575 - 4274)) and v20(v32.SourceofMagicFocus)) then
							return "source_of_magic precombat";
						end
					end
				end
				if (((3344 - 1640) > (3305 - (446 + 1434))) and (v65 == "Selected")) then
					local v152 = 1283 - (1040 + 243);
					local v153;
					while true do
						if ((v152 == (0 - 0)) or ((2534 - (559 + 1288)) == (6165 - (609 + 1322)))) then
							v153 = v34.NamedUnit(479 - (13 + 441), v66);
							if ((v153 and v30.SourceofMagic:IsCastable() and (v153:BuffRemains(v30.SourceofMagicBuff) < (1121 - 821))) or ((8722 - 5392) < (7117 - 5688))) then
								if (((43 + 1104) >= (1216 - 881)) and v20(v32.SourceofMagicName)) then
									return "source_of_magic precombat";
								end
							end
							break;
						end
					end
				end
				v114 = 1 + 0;
			end
			if (((1506 + 1929) > (6222 - 4125)) and (v114 == (1 + 0))) then
				v85 = (1 - 0) * v84;
				if (v30.Firestorm:IsCastable() or ((2493 + 1277) >= (2248 + 1793))) then
					if (v24(v30.Firestorm, not v14:IsInRange(18 + 7), v90) or ((3184 + 607) <= (1577 + 34))) then
						return "firestorm precombat";
					end
				end
				v114 = 435 - (153 + 280);
			end
		end
	end
	local function v99()
		local v115 = 0 - 0;
		while true do
			if ((v115 == (0 + 0)) or ((1808 + 2770) <= (1051 + 957))) then
				if (((1021 + 104) <= (1505 + 571)) and v30.ObsidianScales:IsCastable() and v13:BuffDown(v30.ObsidianScales) and (v13:HealthPercentage() < v61) and v60) then
					if (v24(v30.ObsidianScales) or ((1131 - 388) >= (2719 + 1680))) then
						return "obsidian_scales defensives";
					end
				end
				if (((1822 - (89 + 578)) < (1196 + 477)) and v31.Healthstone:IsReady() and v50 and (v13:HealthPercentage() <= v51)) then
					if (v24(v32.Healthstone, nil, nil, true) or ((4831 - 2507) <= (1627 - (572 + 477)))) then
						return "healthstone defensive 3";
					end
				end
				v115 = 1 + 0;
			end
			if (((2261 + 1506) == (450 + 3317)) and ((87 - (84 + 2)) == v115)) then
				if (((6738 - 2649) == (2946 + 1143)) and v30.RenewingBlaze:IsCastable() and (v13:HealthPercentage() < v59) and v58) then
					if (((5300 - (497 + 345)) >= (43 + 1631)) and v20(v30.RenewingBlaze, nil, nil)) then
						return "RenewingBlaze main 6";
					end
				end
				if (((165 + 807) <= (2751 - (605 + 728))) and v44 and (v13:HealthPercentage() <= v46)) then
					if ((v45 == "Refreshing Healing Potion") or ((3524 + 1414) < (10586 - 5824))) then
						if (v31.RefreshingHealingPotion:IsReady() or ((115 + 2389) > (15764 - 11500))) then
							if (((1941 + 212) == (5964 - 3811)) and v24(v32.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v100()
		if ((v79 and ((v72 >= (3 + 0)) or v13:BuffDown(v30.SpoilsofNeltharusVers) or ((v80 + ((493 - (457 + 32)) * v27(v30.EternitySurge:CooldownRemains() <= ((v89 * (1 + 1)) + v27(v30.FireBreath:CooldownRemains() <= (v89 * (1404 - (832 + 570)))))))) <= (17 + 1)))) or (v88 <= (6 + 14)) or ((1793 - 1286) >= (1249 + 1342))) then
			ShouldReturn = v34.HandleTopTrinket(v33, v37, 836 - (588 + 208), nil);
			if (((12077 - 7596) == (6281 - (884 + 916))) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v34.HandleBottomTrinket(v33, v37, 83 - 43, nil);
			if (ShouldReturn or ((1350 + 978) < (1346 - (232 + 421)))) then
				return ShouldReturn;
			end
		end
	end
	local function v101()
		local v116 = 1889 - (1569 + 320);
		while true do
			if (((1062 + 3266) == (823 + 3505)) and (v116 == (3 - 2))) then
				v93 = v91;
				if (((2193 - (316 + 289)) >= (3486 - 2154)) and v24(v30.EternitySurge, not v14:IsInRange(2 + 28), true)) then
					return "eternity_surge empower " .. v91;
				end
				break;
			end
			if ((v116 == (1453 - (666 + 787))) or ((4599 - (360 + 65)) > (3971 + 277))) then
				if (v30.EternitySurge:CooldownDown() or ((4840 - (79 + 175)) <= (128 - 46))) then
					return nil;
				end
				if (((3015 + 848) == (11840 - 7977)) and ((v72 <= ((1 - 0) + v27(v30.EternitysSpan:IsAvailable()))) or ((v80 < ((900.75 - (503 + 396)) * v84)) and (v80 >= ((182 - (92 + 89)) * v84))) or (v79 and ((v72 == (9 - 4)) or (not v30.EternitysSpan:IsAvailable() and (v72 >= (4 + 2))) or (v30.EternitysSpan:IsAvailable() and (v72 >= (5 + 3))))))) then
					v91 = 3 - 2;
				elseif ((v72 <= (1 + 1 + ((4 - 2) * v27(v30.EternitysSpan:IsAvailable())))) or ((v80 < ((2.5 + 0) * v84)) and (v80 >= ((1.75 + 0) * v84))) or ((858 - 576) <= (6 + 36))) then
					v91 = 2 - 0;
				elseif (((5853 - (485 + 759)) >= (1772 - 1006)) and ((v72 <= ((1192 - (442 + 747)) + ((1138 - (832 + 303)) * v27(v30.EternitysSpan:IsAvailable())))) or not v30.FontofMagic:IsAvailable() or ((v80 <= ((949.25 - (88 + 858)) * v84)) and (v80 >= ((1.5 + 1) * v84))))) then
					v91 = 3 + 0;
				else
					v91 = 1 + 3;
				end
				v116 = 790 - (766 + 23);
			end
		end
	end
	local function v102()
		if (v30.FireBreath:CooldownDown() or ((5687 - 4535) == (3402 - 914))) then
			return nil;
		end
		local v117 = v14:DebuffRemains(v30.FireBreath);
		if (((9015 - 5593) > (11370 - 8020)) and ((v79 and (v72 <= (1075 - (1036 + 37)))) or ((v72 == (1 + 0)) and not v30.EverburningFlame:IsAvailable()) or ((v80 < ((1.75 - 0) * v84)) and (v80 >= ((1 + 0) * v84))))) then
			v92 = 1481 - (641 + 839);
		elseif (((1790 - (910 + 3)) > (958 - 582)) and ((not v97() and v30.EverburningFlame:IsAvailable() and (v72 <= (1687 - (1466 + 218)))) or ((v72 == (1 + 1)) and not v30.EverburningFlame:IsAvailable()) or ((v80 < ((1150.5 - (556 + 592)) * v84)) and (v80 >= ((1.75 + 0) * v84))))) then
			v92 = 810 - (329 + 479);
		elseif (not v30.FontofMagic:IsAvailable() or (v97() and v30.EverburningFlame:IsAvailable() and (v72 <= (857 - (174 + 680)))) or ((v80 <= ((10.25 - 7) * v84)) and (v80 >= ((3.5 - 1) * v84))) or ((2227 + 891) <= (2590 - (396 + 343)))) then
			v92 = 1 + 2;
		else
			v92 = 1481 - (29 + 1448);
		end
		v94 = v92;
		if (v22(v30.FireBreath, false, "1", not v14:IsInRange(1419 - (135 + 1254)), nil) or ((621 - 456) >= (16304 - 12812))) then
			return "fire_breath empower " .. v92 .. " main 12";
		end
	end
	local function v103()
		local v118 = 0 + 0;
		while true do
			if (((5476 - (389 + 1138)) < (5430 - (102 + 472))) and (v118 == (1 + 0))) then
				if (v79 or not v30.Dragonrage:IsAvailable() or ((v30.Dragonrage:CooldownRemains() > v81) and ((v13:BuffRemains(v30.PowerSwellBuff) < v85) or (not v30.Volatility:IsAvailable() and (v72 == (2 + 1)))) and (v13:BuffRemains(v30.BlazingShardsBuff) < v85) and ((v14:TimeToDie() >= (8 + 0)) or (v88 < (1575 - (320 + 1225))))) or ((7611 - 3335) < (1846 + 1170))) then
					local v154 = v101();
					if (((6154 - (157 + 1307)) > (5984 - (821 + 1038))) and v154) then
						return v154;
					end
				end
				if ((v30.DeepBreath:IsCastable() and v37 and not v79 and (v13:EssenceDeficit() > (7 - 4)) and v34.TargetIsMouseover()) or ((6 + 44) >= (1590 - 694))) then
					if (v24(v32.DeepBreathCursor, not v14:IsInRange(12 + 18)) or ((4248 - 2534) >= (3984 - (834 + 192)))) then
						return "deep_breath aoe 6";
					end
				end
				if ((v30.ShatteringStar:IsCastable() and ((v13:BuffStack(v30.EssenceBurstBuff) < v73) or not v30.ArcaneVigor:IsAvailable())) or ((95 + 1396) < (166 + 478))) then
					if (((16 + 688) < (1528 - 541)) and v24(v30.ShatteringStar, not v14:IsSpellInRange(v30.ShatteringStar))) then
						return "shattering_star aoe 8";
					end
				end
				v118 = 306 - (300 + 4);
			end
			if (((993 + 2725) > (4989 - 3083)) and (v118 == (364 - (112 + 250)))) then
				if (v30.Firestorm:IsCastable() or ((382 + 576) > (9106 - 5471))) then
					if (((2006 + 1495) <= (2324 + 2168)) and v24(v30.Firestorm, not v14:IsInRange(19 + 6), v90)) then
						return "firestorm aoe 10";
					end
				end
				if ((v30.Pyre:IsReady() and ((v72 >= (3 + 2)) or ((v72 >= (3 + 1)) and ((v13:BuffDown(v30.EssenceBurstBuff) and v13:BuffDown(v30.IridescenceBlueBuff)) or not v30.EternitysSpan:IsAvailable())) or ((v72 >= (1418 - (1001 + 413))) and v30.Volatility:IsAvailable()) or ((v72 >= (6 - 3)) and v30.Volatility:IsAvailable() and v30.ChargedBlast:IsAvailable() and v13:BuffDown(v30.EssenceBurstBuff) and v13:BuffDown(v30.IridescenceBlueBuff)) or ((v72 >= (885 - (244 + 638))) and v30.Volatility:IsAvailable() and not v30.ChargedBlast:IsAvailable() and (v13:BuffUp(v30.IridescenceRedBuff) or v13:BuffDown(v30.EssenceBurstBuff))) or (v13:BuffStack(v30.ChargedBlastBuff) >= (708 - (627 + 66))))) or ((10255 - 6813) < (3150 - (512 + 90)))) then
					if (((4781 - (1665 + 241)) >= (2181 - (373 + 344))) and v24(v30.Pyre, not v14:IsSpellInRange(v30.Pyre))) then
						return "pyre aoe 14";
					end
				end
				if ((v30.LivingFlame:IsCastable() and v13:BuffUp(v30.BurnoutBuff) and v13:BuffUp(v30.LeapingFlamesBuff) and v13:BuffDown(v30.EssenceBurstBuff) and (v13:Essence() < (v13:EssenceMax() - (1 + 0)))) or ((1270 + 3527) >= (12906 - 8013))) then
					if (v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90) or ((932 - 381) > (3167 - (35 + 1064)))) then
						return "living_flame aoe 14";
					end
				end
				v118 = 3 + 0;
			end
			if (((4522 - 2408) > (4 + 940)) and ((1239 - (298 + 938)) == v118)) then
				if (v30.Disintegrate:IsReady() or ((3521 - (233 + 1026)) >= (4762 - (636 + 1030)))) then
					if (v24(v30.Disintegrate, not v14:IsSpellInRange(v30.Disintegrate), v90) or ((1153 + 1102) >= (3455 + 82))) then
						return "disintegrate aoe 20";
					end
				end
				if ((v30.LivingFlame:IsCastable() and v30.Snapfire:IsAvailable() and v13:BuffUp(v30.BurnoutBuff)) or ((1140 + 2697) < (89 + 1217))) then
					if (((3171 - (55 + 166)) == (572 + 2378)) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90)) then
						return "living_flame aoe 22";
					end
				end
				if (v30.AzureStrike:IsCastable() or ((475 + 4248) < (12595 - 9297))) then
					if (((1433 - (36 + 261)) >= (269 - 115)) and v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike))) then
						return "azure_strike aoe 24";
					end
				end
				break;
			end
			if ((v118 == (1368 - (34 + 1334))) or ((105 + 166) > (3690 + 1058))) then
				if (((6023 - (1035 + 248)) >= (3173 - (20 + 1))) and v30.Dragonrage:IsCastable() and Cds and ((v14:TimeToDie() >= (17 + 15)) or (v88 < (349 - (134 + 185))))) then
					if (v24(v30.Dragonrage) or ((3711 - (549 + 584)) >= (4075 - (314 + 371)))) then
						return "dragonrage aoe 2";
					end
				end
				if (((140 - 99) <= (2629 - (478 + 490))) and v30.TipTheScales:IsCastable() and v37 and v79 and ((v72 <= (2 + 1 + ((1175 - (786 + 386)) * v27(v30.EternitysSpan:IsAvailable())))) or v30.FireBreath:CooldownDown())) then
					if (((1946 - 1345) < (4939 - (1055 + 324))) and v24(v30.TipTheScales)) then
						return "tip_the_scales aoe 4";
					end
				end
				if (((1575 - (1093 + 247)) < (611 + 76)) and (not v30.Dragonrage:IsAvailable() or (v78 > v81) or not v30.Animosity:IsAvailable()) and ((((v13:BuffRemains(v30.PowerSwellBuff) < v85) or (not v30.Volatility:IsAvailable() and (v72 == (1 + 2)))) and (v13:BuffRemains(v30.BlazingShardsBuff) < v85)) or v79) and ((v14:TimeToDie() >= (31 - 23)) or (v88 < (101 - 71)))) then
					local v155 = 0 - 0;
					local v156;
					while true do
						if (((11431 - 6882) > (411 + 742)) and (v155 == (0 - 0))) then
							v156 = v102();
							if (v156 or ((16110 - 11436) < (3523 + 1149))) then
								return v156;
							end
							break;
						end
					end
				end
				v118 = 2 - 1;
			end
		end
	end
	local function v104()
		local v119 = 688 - (364 + 324);
		while true do
			if (((10055 - 6387) < (10944 - 6383)) and (v119 == (1 + 2))) then
				if ((v30.Pyre:IsReady() and v97() and v30.RagingInferno:IsAvailable() and (v13:BuffStack(v30.ChargedBlastBuff) == (83 - 63)) and (v72 >= (2 - 0))) or ((1381 - 926) == (4873 - (1249 + 19)))) then
					if (v24(v30.Pyre, not v14:IsSpellInRange(v30.Pyre)) or ((2404 + 259) == (12891 - 9579))) then
						return "pyre st 22";
					end
				end
				if (((5363 - (686 + 400)) <= (3512 + 963)) and v30.Disintegrate:IsReady()) then
					if (v24(v30.Disintegrate, not v14:IsSpellInRange(v30.Disintegrate), v90) or ((1099 - (73 + 156)) == (6 + 1183))) then
						return "disintegrate st 24";
					end
				end
				if (((2364 - (721 + 90)) <= (36 + 3097)) and v30.Firestorm:IsCastable() and not v79 and v14:DebuffDown(v30.ShatteringStar)) then
					if (v24(v30.Firestorm, not v14:IsInRange(81 - 56), v90) or ((2707 - (224 + 246)) >= (5687 - 2176))) then
						return "firestorm st 26";
					end
				end
				if ((v30.DeepBreath:IsCastable() and v37 and not v79 and (v72 >= (3 - 1)) and v34.TargetIsMouseover()) or ((241 + 1083) > (72 + 2948))) then
					if (v24(v32.DeepBreathCursor, not v14:IsInRange(23 + 7)) or ((5947 - 2955) == (6259 - 4378))) then
						return "deep_breath st 28";
					end
				end
				v119 = 517 - (203 + 310);
			end
			if (((5099 - (1238 + 755)) > (107 + 1419)) and (v119 == (1536 - (709 + 825)))) then
				if (((5569 - 2546) < (5637 - 1767)) and v30.Animosity:IsAvailable() and v79 and (v80 < (v89 + v85)) and ((v80 - v30.EternitySurge:CooldownRemains()) > (v85 * v27(v13:BuffDown(v30.TipTheScales))))) then
					if (((1007 - (196 + 668)) > (291 - 217)) and v24(v30.Pool)) then
						return "Wait for ES st 14";
					end
				end
				if (((36 - 18) < (2945 - (171 + 662))) and v30.LivingFlame:IsCastable() and v79 and (v80 < ((v73 - v13:BuffStack(v30.EssenceBurstBuff)) * v89)) and v13:BuffUp(v30.BurnoutBuff)) then
					if (((1190 - (4 + 89)) <= (5705 - 4077)) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90)) then
						return "living_flame st 16";
					end
				end
				if (((1686 + 2944) == (20336 - 15706)) and v30.AzureStrike:IsCastable() and v79 and (v80 < ((v73 - v13:BuffStack(v30.EssenceBurstBuff)) * v89))) then
					if (((1389 + 2151) > (4169 - (35 + 1451))) and v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike))) then
						return "azure_strike st 18";
					end
				end
				if (((6247 - (28 + 1425)) >= (5268 - (941 + 1052))) and v30.LivingFlame:IsCastable() and v13:BuffUp(v30.BurnoutBuff) and ((v13:BuffUp(v30.LeapingFlamesBuff) and v13:BuffDown(v30.EssenceBurstBuff)) or (v13:BuffDown(v30.LeapingFlamesBuff) and (v13:BuffStack(v30.EssenceBurstBuff) < v73))) and (v13:Essence() < (v13:EssenceMax() - (1 + 0)))) then
					if (((2998 - (822 + 692)) == (2118 - 634)) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90)) then
						return "living_flame st 20";
					end
				end
				v119 = 2 + 1;
			end
			if (((1729 - (45 + 252)) < (3518 + 37)) and (v119 == (2 + 2))) then
				if ((v30.DeepBreath:IsCastable() and v37 and not v79 and v30.ImminentDestruction:IsAvailable() and v14:DebuffDown(v30.ShatteringStar) and v34.TargetIsMouseover()) or ((2591 - 1526) > (4011 - (114 + 319)))) then
					if (v24(v32.DeepBreathCursor, not v14:IsInRange(43 - 13)) or ((6144 - 1349) < (897 + 510))) then
						return "deep_breath st 30";
					end
				end
				if (((2760 - 907) < (10084 - 5271)) and v30.LivingFlame:IsCastable()) then
					if (v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90) or ((4784 - (556 + 1407)) < (3637 - (741 + 465)))) then
						return "living_flame st 32";
					end
				end
				if (v30.AzureStrike:IsCastable() or ((3339 - (170 + 295)) < (1150 + 1031))) then
					if (v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike)) or ((2470 + 219) <= (844 - 501))) then
						return "azure_strike st 34";
					end
				end
				break;
			end
			if ((v119 == (1 + 0)) or ((1199 + 670) == (1138 + 871))) then
				if ((v30.Disintegrate:IsReady() and (v80 > (1249 - (957 + 273))) and (v30.FireBreath:CooldownRemains() > (8 + 20)) and v30.EyeofInfinity:IsAvailable() and v13:HasTier(13 + 17, 7 - 5)) or ((9344 - 5798) < (7092 - 4770))) then
					if (v20(v30.Disintegrate, nil, nil, not v14:IsSpellInRange(v30.Disintegrate)) or ((10309 - 8227) == (6553 - (389 + 1391)))) then
						return "disintegrate st 9";
					end
				end
				if (((2036 + 1208) > (110 + 945)) and v30.ShatteringStar:IsCastable() and ((v13:BuffStack(v30.EssenceBurstBuff) < v73) or not v30.ArcaneVigor:IsAvailable())) then
					if (v24(v30.ShatteringStar, not v14:IsSpellInRange(v30.ShatteringStar)) or ((7542 - 4229) <= (2729 - (783 + 168)))) then
						return "shattering_star st 10";
					end
				end
				if (((not v30.Dragonrage:IsAvailable() or (v78 > v82) or not v30.Animosity:IsAvailable()) and ((v13:BuffRemains(v30.BlazingShardsBuff) < v85) or v79) and ((v14:TimeToDie() >= (26 - 18)) or (v88 < (30 + 0)))) or ((1732 - (309 + 2)) >= (6460 - 4356))) then
					local v157 = 1212 - (1090 + 122);
					local v158;
					while true do
						if (((588 + 1224) <= (10911 - 7662)) and (v157 == (0 + 0))) then
							v158 = v101();
							if (((2741 - (628 + 490)) <= (351 + 1606)) and v158) then
								return v158;
							end
							break;
						end
					end
				end
				if (((10923 - 6511) == (20162 - 15750)) and v30.Animosity:IsAvailable() and v79 and (v80 < (v89 + (v85 * v27(v13:BuffDown(v30.TipTheScales))))) and ((v80 - v30.FireBreath:CooldownRemains()) >= (v85 * v27(v13:BuffDown(v30.TipTheScales))))) then
					if (((2524 - (431 + 343)) >= (1700 - 858)) and v24(v30.Pool)) then
						return "Wait for FB st 12";
					end
				end
				v119 = 5 - 3;
			end
			if (((3454 + 918) > (237 + 1613)) and (v119 == (1695 - (556 + 1139)))) then
				if (((247 - (6 + 9)) < (151 + 670)) and v30.Firestorm:IsCastable() and (v13:BuffUp(v30.SnapfireBuff))) then
					if (((266 + 252) < (1071 - (28 + 141))) and v24(v30.Firestorm, not v14:IsInRange(10 + 15), v90)) then
						return "firestorm st 4";
					end
				end
				if (((3694 - 700) > (608 + 250)) and v30.Dragonrage:IsCastable() and v37 and (((v30.FireBreath:CooldownRemains() < v89) and (v30.EternitySurge:CooldownRemains() < ((1319 - (486 + 831)) * v89))) or (v88 < (78 - 48)))) then
					if (v24(v30.Dragonrage) or ((13219 - 9464) <= (173 + 742))) then
						return "dragonrage st 6";
					end
				end
				if (((12476 - 8530) > (5006 - (668 + 595))) and v30.TipTheScales:IsCastable() and v37 and ((v79 and v30.EternitySurge:CooldownUp() and v30.FireBreath:CooldownDown() and not v30.EverburningFlame:IsAvailable()) or (v30.EverburningFlame:IsAvailable() and v30.FireBreath:CooldownUp()))) then
					if (v24(v30.TipTheScales) or ((1202 + 133) >= (667 + 2639))) then
						return "tip_the_scales st 8";
					end
				end
				if (((13209 - 8365) > (2543 - (23 + 267))) and (not v30.Dragonrage:IsAvailable() or (v78 > v82) or not v30.Animosity:IsAvailable()) and ((v13:BuffRemains(v30.BlazingShardsBuff) < v85) or v79) and ((v14:TimeToDie() >= (1952 - (1129 + 815))) or (v88 < (417 - (371 + 16))))) then
					local v159 = 1750 - (1326 + 424);
					local v160;
					while true do
						if (((855 - 403) == (1651 - 1199)) and (v159 == (118 - (88 + 30)))) then
							v160 = v102();
							if (v160 or ((5328 - (720 + 51)) < (4642 - 2555))) then
								return v160;
							end
							break;
						end
					end
				end
				v119 = 1777 - (421 + 1355);
			end
		end
	end
	local function v105()
		local v120 = 0 - 0;
		while true do
			if (((1903 + 1971) == (4957 - (286 + 797))) and (v120 == (0 - 0))) then
				if ((v40 == "Player Only") or ((3209 - 1271) > (5374 - (397 + 42)))) then
					if ((v30.VerdantEmbrace:IsReady() and (v13:HealthPercentage() < v42)) or ((1329 + 2926) < (4223 - (24 + 776)))) then
						if (((2239 - 785) <= (3276 - (222 + 563))) and v20(v32.VerdantEmbracePlayer, nil)) then
							return "verdant_embrace main 40";
						end
					end
				end
				if ((v40 == "Everyone") or (v40 == "Not Tank") or ((9158 - 5001) <= (2019 + 784))) then
					if (((5043 - (23 + 167)) >= (4780 - (690 + 1108))) and v30.VerdantEmbrace:IsReady() and (v15:HealthPercentage() < v42)) then
						if (((1492 + 2642) > (2769 + 588)) and v20(v32.VerdantEmbraceFocus, nil)) then
							return "verdant_embrace main 40";
						end
					end
				end
				v120 = 849 - (40 + 808);
			end
			if (((1 + 0) == v120) or ((13066 - 9649) < (2422 + 112))) then
				if ((v41 == "Player Only") or ((1440 + 1282) <= (90 + 74))) then
					if ((v30.EmeraldBlossom:IsReady() and (v13:HealthPercentage() < v43)) or ((2979 - (47 + 524)) < (1369 + 740))) then
						if (v20(v32.EmeraldBlossomPlayer, nil) or ((90 - 57) == (2175 - 720))) then
							return "emerald_blossom main 42";
						end
					end
				end
				if ((v41 == "Everyone") or ((1009 - 566) >= (5741 - (1165 + 561)))) then
					if (((101 + 3281) > (514 - 348)) and v30.EmeraldBlossom:IsReady() and (v15:HealthPercentage() < v43)) then
						if (v20(v32.EmeraldBlossomFocus, nil) or ((107 + 173) == (3538 - (341 + 138)))) then
							return "emerald_blossom main 42";
						end
					end
				end
				break;
			end
		end
	end
	local function v106()
		local v121 = 0 + 0;
		while true do
			if (((3881 - 2000) > (1619 - (89 + 237))) and (v121 == (0 - 0))) then
				if (((4961 - 2604) == (3238 - (581 + 300))) and (not v15 or not v15:Exists() or not v15:IsInRange(1250 - (855 + 365)) or not v34.DispellableFriendlyUnit())) then
					return;
				end
				if (((291 - 168) == (41 + 82)) and v30.Expunge:IsReady() and (v34.UnitHasPoisonDebuff(v15))) then
					if (v24(v32.ExpungeFocus) or ((2291 - (1030 + 205)) >= (3185 + 207))) then
						return "Expunge dispel";
					end
				end
				v121 = 1 + 0;
			end
			if ((v121 == (287 - (156 + 130))) or ((2456 - 1375) < (1811 - 736))) then
				if ((v30.OppressingRoar:IsReady() and v57 and v34.UnitHasEnrageBuff(v14)) or ((2147 - 1098) >= (1168 + 3264))) then
					if (v24(v30.OppressingRoar) or ((2781 + 1987) <= (915 - (10 + 59)))) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
		end
	end
	local function v107()
		local v122 = 0 + 0;
		while true do
			if (((19 - 15) == v122) or ((4521 - (671 + 492)) <= (1131 + 289))) then
				v56 = EpicSettings.Settings['InterruptThreshold'] or (1215 - (369 + 846));
				v57 = EpicSettings.Settings['UseOppressingRoar'];
				v58 = EpicSettings.Settings['UseRenewingBlaze'];
				v59 = EpicSettings.Settings['RenewingBlazeHP'] or (0 + 0);
				v122 = 5 + 0;
			end
			if ((v122 == (1946 - (1036 + 909))) or ((2973 + 766) <= (5045 - 2040))) then
				v44 = EpicSettings.Settings['UseHealingPotion'];
				v45 = EpicSettings.Settings['HealingPotionName'] or "";
				v46 = EpicSettings.Settings['HealingPotionHP'] or (203 - (11 + 192));
				v47 = EpicSettings.Settings['UseBlessingOfTheBronze'];
				v122 = 2 + 0;
			end
			if (((178 - (135 + 40)) == v122) or ((4019 - 2360) >= (1287 + 847))) then
				v52 = EpicSettings.Settings['HandleAfflicted'];
				v53 = EpicSettings.Settings['HandleIncorporeal'];
				v54 = EpicSettings.Settings['InterruptWithStun'];
				v55 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v122 = 8 - 4;
			end
			if ((v122 == (2 - 0)) or ((3436 - (50 + 126)) < (6557 - 4202))) then
				v48 = EpicSettings.Settings['DispelDebuffs'];
				v49 = EpicSettings.Settings['DispelBuffs'];
				v50 = EpicSettings.Settings['UseHealthstone'];
				v51 = EpicSettings.Settings['HealthstoneHP'] or (0 + 0);
				v122 = 1416 - (1233 + 180);
			end
			if ((v122 == (974 - (522 + 447))) or ((2090 - (107 + 1314)) == (1960 + 2263))) then
				v60 = EpicSettings.Settings['UseObsidianScales'];
				v61 = EpicSettings.Settings['ObsidianScalesHP'] or (0 - 0);
				v62 = EpicSettings.Settings['UseHover'];
				v63 = EpicSettings.Settings['HoverTime'] or (0 + 0);
				v122 = 11 - 5;
			end
			if ((v122 == (23 - 17)) or ((3602 - (716 + 1194)) < (11 + 577))) then
				v64 = EpicSettings.Settings['LandslideUsage'] or "";
				v65 = EpicSettings.Settings['SourceOfMagicUsage'] or "";
				v66 = EpicSettings.Settings['SourceOfMagicName'] or "";
				break;
			end
			if ((v122 == (0 + 0)) or ((5300 - (74 + 429)) < (7042 - 3391))) then
				v40 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v41 = EpicSettings.Settings['EmeraldBlossomUsage'] or "";
				v42 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 + 0);
				v43 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 - 0);
				v122 = 1 + 0;
			end
		end
	end
	local function v108()
		local v123 = 0 - 0;
		while true do
			if ((v123 == (19 - 11)) or ((4610 - (279 + 154)) > (5628 - (454 + 324)))) then
				if (v13:AffectingCombat() or ((315 + 85) > (1128 - (12 + 5)))) then
					local v161 = 0 + 0;
					local v162;
					while true do
						if (((7773 - 4722) > (372 + 633)) and (v161 == (1093 - (277 + 816)))) then
							v162 = v99();
							if (((15780 - 12087) <= (5565 - (1058 + 125))) and v162) then
								return v162;
							end
							break;
						end
					end
				end
				if (v13:AffectingCombat() or v35 or ((616 + 2666) > (5075 - (815 + 160)))) then
					if ((not v13:IsCasting() and not v13:IsChanneling()) or ((15360 - 11780) < (6751 - 3907))) then
						local v176 = v34.Interrupt(v30.Quell, 3 + 7, true);
						if (((260 - 171) < (6388 - (41 + 1857))) and v176) then
							return v176;
						end
						v176 = v34.InterruptWithStun(v30.TailSwipe, 1901 - (1222 + 671));
						if (v176 or ((12878 - 7895) < (2598 - 790))) then
							return v176;
						end
						v176 = v34.Interrupt(v30.Quell, 1192 - (229 + 953), true, Mouseover, v32.QuellMouseover);
						if (((5603 - (1111 + 663)) > (5348 - (874 + 705))) and v176) then
							return v176;
						end
					end
					v78 = v29(v30.Dragonrage:CooldownRemains(), v30.EternitySurge:CooldownRemains() - ((1 + 1) * v89), v30.FireBreath:CooldownRemains() - v89);
					if (((1014 + 471) <= (6035 - 3131)) and v30.Unravel:IsReady() and v14:EnemyAbsorb()) then
						if (((121 + 4148) == (4948 - (642 + 37))) and v24(v30.Unravel, not v14:IsSpellInRange(v30.Unravel))) then
							return "unravel main 4";
						end
					end
					if (((89 + 298) <= (446 + 2336)) and (v49 or v48)) then
						local v177 = v106();
						if (v177 or ((4767 - 2868) <= (1371 - (233 + 221)))) then
							return v177;
						end
					end
					if (v52 or ((9970 - 5658) <= (772 + 104))) then
						local v178 = 1541 - (718 + 823);
						while true do
							if (((1405 + 827) <= (3401 - (266 + 539))) and (v178 == (0 - 0))) then
								ShouldReturn = v34.HandleAfflicted(v30.Expunge, v32.ExpungeMouseover, 1265 - (636 + 589));
								if (((4973 - 2878) < (7602 - 3916)) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
						end
					end
					if (v53 or ((1264 + 331) >= (1626 + 2848))) then
						ShouldReturn = v34.HandleIncorporeal(v30.Sleepwalk, v32.SleepwalkMouseover, 1045 - (657 + 358), true);
						if (ShouldReturn or ((12229 - 7610) < (6565 - 3683))) then
							return ShouldReturn;
						end
					end
					if ((v38 and v13:AffectingCombat()) or ((1481 - (1151 + 36)) >= (4666 + 165))) then
						local v179 = 0 + 0;
						local v180;
						while true do
							if (((6059 - 4030) <= (4916 - (1552 + 280))) and ((834 - (64 + 770)) == v179)) then
								v180 = v105();
								if (v180 or ((1384 + 653) == (5493 - 3073))) then
									return v180;
								end
								break;
							end
						end
					end
					if (((792 + 3666) > (5147 - (157 + 1086))) and v62 and v13:AffectingCombat()) then
						if (((872 - 436) >= (538 - 415)) and ((GetTime() - LastStationaryTime) > v63)) then
							if (((766 - 266) < (2477 - 661)) and v30.Hover:IsReady()) then
								if (((4393 - (599 + 220)) == (7117 - 3543)) and v24(v30.Hover)) then
									return "hover main 2";
								end
							end
						end
					end
					if (((2152 - (1813 + 118)) < (286 + 104)) and (v65 == "Auto")) then
						if ((v30.SourceofMagic:IsCastable() and v15:IsInRange(1242 - (841 + 376)) and (v95 == v15:GUID()) and (v15:BuffRemains(v30.SourceofMagicBuff) < (420 - 120))) or ((515 + 1698) <= (3878 - 2457))) then
							if (((3917 - (464 + 395)) < (12472 - 7612)) and v20(v32.SourceofMagicFocus)) then
								return "source_of_magic precombat";
							end
						end
					end
					if ((v65 == "Selected") or ((623 + 673) >= (5283 - (467 + 370)))) then
						local v181 = v34.NamedUnit(51 - 26, v66);
						if ((v181 and v30.SourceofMagic:IsCastable() and (v181:BuffRemains(v30.SourceofMagicBuff) < (221 + 79))) or ((4775 - 3382) > (701 + 3788))) then
							if (v20(v32.SourceofMagicName) or ((10292 - 5868) < (547 - (150 + 370)))) then
								return "source_of_magic precombat";
							end
						end
					end
					local v163 = v34.HandleDPSPotion(v13:BuffUp(v30.IridescenceBlueBuff));
					if (v163 or ((3279 - (74 + 1208)) > (9383 - 5568))) then
						return v163;
					end
					if (((16433 - 12968) > (1362 + 551)) and v37) then
						local v182 = v100();
						if (((1123 - (14 + 376)) < (3154 - 1335)) and v182) then
							return v182;
						end
					end
					if ((v72 >= (2 + 1)) or ((3861 + 534) == (4535 + 220))) then
						local v183 = 0 - 0;
						local v184;
						while true do
							if ((v183 == (1 + 0)) or ((3871 - (23 + 55)) < (5614 - 3245))) then
								if (v24(v30.Pool) or ((2726 + 1358) == (238 + 27))) then
									return "Pool for Aoe()";
								end
								break;
							end
							if (((6756 - 2398) == (1371 + 2987)) and (v183 == (901 - (652 + 249)))) then
								v184 = v103();
								if (v184 or ((8397 - 5259) < (2861 - (708 + 1160)))) then
									return v184;
								end
								v183 = 2 - 1;
							end
						end
					end
					local v164 = v104();
					if (((6071 - 2741) > (2350 - (10 + 17))) and v164) then
						return v164;
					end
				end
				if (v24(v30.Pool) or ((815 + 2811) == (5721 - (1400 + 332)))) then
					return "Pool for ST()";
				end
				break;
			end
			if (((9 - 4) == v123) or ((2824 - (242 + 1666)) == (1143 + 1528))) then
				if (((100 + 172) == (232 + 40)) and (v34.TargetIsValid() or v13:AffectingCombat())) then
					local v165 = 940 - (850 + 90);
					while true do
						if (((7441 - 3192) <= (6229 - (360 + 1030))) and (v165 == (1 + 0))) then
							if (((7838 - 5061) < (4402 - 1202)) and (v88 == (12772 - (909 + 752)))) then
								v88 = v10.FightRemains(v70, false);
							end
							break;
						end
						if (((1318 - (109 + 1114)) < (3582 - 1625)) and ((0 + 0) == v165)) then
							v87 = v10.BossFightRemains(nil, true);
							v88 = v87;
							v165 = 243 - (6 + 236);
						end
					end
				end
				v89 = v13:GCD() + 0.25 + 0;
				v84 = v13:SpellHaste();
				v123 = 5 + 1;
			end
			if (((1947 - 1121) < (2998 - 1281)) and ((1140 - (1076 + 57)) == v123)) then
				if (((235 + 1191) >= (1794 - (579 + 110))) and v38 and v35 and not v13:AffectingCombat()) then
					local v166 = v105();
					if (((218 + 2536) <= (2988 + 391)) and v166) then
						return v166;
					end
				end
				if ((v62 and (v35 or v13:AffectingCombat())) or ((2085 + 1842) == (1820 - (174 + 233)))) then
					if (((GetTime() - LastStationaryTime) > v63) or ((3223 - 2069) <= (1382 - 594))) then
						if ((v30.Hover:IsReady() and v13:BuffDown(v30.Hover)) or ((731 + 912) > (4553 - (663 + 511)))) then
							if (v24(v30.Hover) or ((2501 + 302) > (988 + 3561))) then
								return "hover main 2";
							end
						end
					end
				end
				if ((not v13:AffectingCombat() and v35 and not v13:IsCasting()) or ((678 - 458) >= (1830 + 1192))) then
					local v167 = v98();
					if (((6643 - 3821) == (6831 - 4009)) and v167) then
						return v167;
					end
				end
				v123 = 4 + 4;
			end
			if ((v123 == (5 - 2)) or ((757 + 304) == (170 + 1687))) then
				if (((3482 - (478 + 244)) > (1881 - (440 + 77))) and v13:IsChanneling(v30.FireBreath)) then
					local v168 = 0 + 0;
					local v169;
					while true do
						if (((0 - 0) == v168) or ((6458 - (655 + 901)) <= (667 + 2928))) then
							v169 = GetTime() - v13:CastStart();
							if ((v169 >= v13:EmpowerCastTime(v94)) or ((2949 + 903) == (198 + 95))) then
								v10.EpicSettingsS = v30.FireBreath.ReturnID;
								return "Stopping Fire Breath";
							end
							break;
						end
					end
				end
				if (v13:IsChanneling(v30.EternitySurge) or ((6280 - 4721) == (6033 - (695 + 750)))) then
					local v170 = 0 - 0;
					local v171;
					while true do
						if ((v170 == (0 - 0)) or ((18033 - 13549) == (1139 - (285 + 66)))) then
							v171 = GetTime() - v13:CastStart();
							if (((10648 - 6080) >= (5217 - (682 + 628))) and (v171 >= v13:EmpowerCastTime(v93))) then
								v10.EpicSettingsS = v30.EternitySurge.ReturnID;
								return "Stopping EternitySurge";
							end
							break;
						end
					end
				end
				v90 = v13:BuffRemains(v30.HoverBuff) < (1 + 1);
				v123 = 303 - (176 + 123);
			end
			if (((522 + 724) < (2518 + 952)) and (v123 == (273 - (239 + 30)))) then
				v70 = v13:GetEnemiesInRange(7 + 18);
				v71 = v14:GetEnemiesInSplashRange(8 + 0);
				if (((7199 - 3131) >= (3032 - 2060)) and v36) then
					v72 = v14:GetEnemiesInSplashRangeCount(323 - (306 + 9));
				else
					v72 = 3 - 2;
				end
				v123 = 1 + 4;
			end
			if (((303 + 190) < (1874 + 2019)) and (v123 == (5 - 3))) then
				if (v13:IsDeadOrGhost() or ((2848 - (1140 + 235)) >= (2121 + 1211))) then
					return;
				end
				if ((v48 and v30.Expunge:IsReady() and v34.DispellableFriendlyUnit()) or ((3715 + 336) <= (297 + 860))) then
					local v172 = 52 - (33 + 19);
					local v173;
					local v174;
					while true do
						if (((219 + 385) < (8635 - 5754)) and ((0 + 0) == v172)) then
							v173 = v48;
							v174 = v34.FocusUnit(v173, v32, 58 - 28);
							v172 = 1 + 0;
						end
						if ((v172 == (690 - (586 + 103))) or ((82 + 818) == (10396 - 7019))) then
							if (((5947 - (1309 + 179)) > (1066 - 475)) and v174) then
								return v174;
							end
							break;
						end
					end
				elseif (((1479 + 1919) >= (6431 - 4036)) and v96() and (v15:BuffRemains(v30.SourceofMagicBuff) < (227 + 73))) then
					local v185 = 0 - 0;
					while true do
						if ((v185 == (0 - 0)) or ((2792 - (295 + 314)) >= (6935 - 4111))) then
							v95 = v96():GUID();
							if (((3898 - (1300 + 662)) == (6079 - 4143)) and (v65 == "Auto") and (v96():BuffRemains(v30.SourceofMagicBuff) < (2055 - (1178 + 577))) and v30.SourceofMagic:IsCastable()) then
								local v191 = 0 + 0;
								while true do
									if ((v191 == (0 - 0)) or ((6237 - (851 + 554)) < (3814 + 499))) then
										ShouldReturn = v34.FocusSpecifiedUnit(v96(), 69 - 44);
										if (((8878 - 4790) > (4176 - (115 + 187))) and ShouldReturn) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							break;
						end
					end
				elseif (((3318 + 1014) == (4102 + 230)) and v38) then
					if (((15758 - 11759) >= (4061 - (160 + 1001))) and (((v40 == "Everyone") and v30.VerdantEmbrace:IsReady()) or ((v41 == "Everyone") and v30.EmeraldBlossom:IsReady()))) then
						local v190 = 0 + 0;
						while true do
							if ((v190 == (0 + 0)) or ((5169 - 2644) > (4422 - (237 + 121)))) then
								ShouldReturn = v34.FocusUnit(false, nil, nil, nil);
								if (((5268 - (525 + 372)) == (8286 - 3915)) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
						end
					elseif (((v40 == "Not Tank") and v30.VerdantEmbrace:IsReady()) or ((873 - 607) > (5128 - (96 + 46)))) then
						local v192 = 777 - (643 + 134);
						local v193;
						local v194;
						while true do
							if (((719 + 1272) >= (2217 - 1292)) and (v192 == (3 - 2))) then
								if (((437 + 18) < (4028 - 1975)) and (v193:HealthPercentage() < v194:HealthPercentage())) then
									ShouldReturn = v34.FocusUnit(false, nil, nil, "HEALER");
									if (ShouldReturn or ((1688 - 862) == (5570 - (316 + 403)))) then
										return ShouldReturn;
									end
								end
								if (((122 + 61) == (503 - 320)) and (v194:HealthPercentage() < v193:HealthPercentage())) then
									local v195 = 0 + 0;
									while true do
										if (((2918 - 1759) <= (1268 + 520)) and (v195 == (0 + 0))) then
											ShouldReturn = v34.FocusUnit(false, nil, nil, "DAMAGER");
											if (ShouldReturn or ((12151 - 8644) > (20622 - 16304))) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								break;
							end
							if ((v192 == (0 - 0)) or ((177 + 2898) <= (5836 - 2871))) then
								v193 = v34.GetFocusUnit(false, nil, "HEALER") or v13;
								v194 = v34.GetFocusUnit(false, nil, "DAMAGER") or v13;
								v192 = 1 + 0;
							end
						end
					end
				end
				if (((4015 - 2650) <= (2028 - (12 + 5))) and not v13:IsMoving()) then
					LastStationaryTime = GetTime();
				end
				v123 = 11 - 8;
			end
			if ((v123 == (0 - 0)) or ((5900 - 3124) > (8865 - 5290))) then
				v107();
				v35 = EpicSettings.Toggles['ooc'];
				v36 = EpicSettings.Toggles['aoe'];
				v123 = 1 + 0;
			end
			if ((v123 == (1974 - (1656 + 317))) or ((2276 + 278) == (3850 + 954))) then
				v37 = EpicSettings.Toggles['cds'];
				v38 = EpicSettings.Toggles['heal'];
				v39 = EpicSettings.Toggles['dispel'];
				v123 = 4 - 2;
			end
			if (((12682 - 10105) == (2931 - (5 + 349))) and (v123 == (28 - 22))) then
				v85 = (1272 - (266 + 1005)) * v84;
				if ((v34.TargetIsValid() and v35) or v13:AffectingCombat() or ((4 + 2) >= (6445 - 4556))) then
					local v175 = 0 - 0;
					while true do
						if (((2202 - (561 + 1135)) <= (2464 - 572)) and (v175 == (0 - 0))) then
							v79 = v13:BuffUp(v30.Dragonrage);
							v80 = (v79 and v13:BuffRemains(v30.Dragonrage)) or (1066 - (507 + 559));
							break;
						end
					end
				end
				if (not v13:AffectingCombat() or ((5038 - 3030) > (6859 - 4641))) then
					if (((767 - (212 + 176)) <= (5052 - (250 + 655))) and v47 and v30.BlessingoftheBronze:IsCastable() and (v13:BuffDown(v30.BlessingoftheBronzeBuff, true) or v34.GroupBuffMissing(v30.BlessingoftheBronzeBuff))) then
						if (v24(v30.BlessingoftheBronze) or ((12309 - 7795) <= (1762 - 753))) then
							return "blessing_of_the_bronze precombat";
						end
					end
				end
				v123 = 10 - 3;
			end
		end
	end
	local function v109()
		local v124 = 1956 - (1869 + 87);
		while true do
			if ((v124 == (0 - 0)) or ((5397 - (484 + 1417)) == (2554 - 1362))) then
				v34.DispellableDebuffs = v34.DispellablePoisonDebuffs;
				v19.Print("Devastation Evoker by Epic BoomK.");
				v124 = 1 - 0;
			end
			if ((v124 == (774 - (48 + 725))) or ((339 - 131) == (7938 - 4979))) then
				EpicSettings.SetupVersion("Devastation Evoker X v 10.2.00 By BoomK");
				break;
			end
		end
	end
	v19.SetAPL(853 + 614, v108, v109);
end;
return v0["Epix_Evoker_Devastation.lua"]();

