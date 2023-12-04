local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (1167 - (645 + 522))) or ((4159 - (1010 + 780)) == (426 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((14653 - 11577) > (9327 - 6144))) then
				return v1(v4, ...);
			end
			v5 = 1837 - (1045 + 791);
		end
		if (((3042 - 1840) > (1615 - 557)) and (v5 == (506 - (351 + 154)))) then
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
	local v65 = v13:GetEquipment();
	local v66 = (v65[1587 - (1281 + 293)] and v18(v65[279 - (28 + 238)])) or v18(0 - 0);
	local v67 = (v65[1573 - (1381 + 178)] and v18(v65[14 + 0])) or v18(0 + 0);
	local v68;
	local v69;
	local v70;
	local v71 = ((v30.EssenceAttunement:IsAvailable()) and (1 + 1)) or (3 - 2);
	local v72 = 2 + 0;
	local v73, v74, v75;
	local v76;
	local v77, v78;
	local v79 = 474 - (381 + 89);
	local v80 = 12 + 1;
	local v81 = v30.BlastFurnace:TalentRank();
	local v82;
	local v83;
	local v84 = false;
	local v85 = 7515 + 3596;
	local v86 = 19032 - 7921;
	local v87;
	local v88;
	local v89 = 1156 - (1074 + 82);
	local v90 = 0 - 0;
	local v91 = 1785 - (214 + 1570);
	local v92 = 1456 - (990 + 465);
	local v93;
	local function v94()
		local v108 = 0 + 0;
		local v109;
		local v110;
		while true do
			if (((1615 + 2096) > (3263 + 92)) and (v108 == (7 - 5))) then
				return v110;
			end
			if ((v108 == (1727 - (1668 + 58))) or ((1532 - (512 + 114)) >= (5811 - 3582))) then
				v110 = nil;
				for v152, v153 in pairs(v109) do
					if (((2662 - 1374) > (4352 - 3101)) and v153:Exists() and (UnitGroupRolesAssigned(v152) == "HEALER")) then
						v110 = v153;
					end
				end
				v108 = 1 + 1;
			end
			if ((v108 == (0 + 0)) or ((3924 + 589) < (11305 - 7953))) then
				v109 = nil;
				if (UnitInRaid("player") or ((4059 - (109 + 1885)) >= (4665 - (1269 + 200)))) then
					v109 = v12.Raid;
				elseif (UnitInParty("player") or ((8387 - 4011) <= (2296 - (98 + 717)))) then
					v109 = v12.Party;
				else
					return false;
				end
				v108 = 827 - (802 + 24);
			end
		end
	end
	v10:RegisterForEvent(function()
		local v111 = 0 - 0;
		while true do
			if ((v111 == (1 - 0)) or ((501 + 2891) >= (3643 + 1098))) then
				v67 = (v65[3 + 11] and v18(v65[4 + 10])) or v18(0 - 0);
				break;
			end
			if (((11087 - 7762) >= (771 + 1383)) and (v111 == (0 + 0))) then
				v65 = v13:GetEquipment();
				v66 = (v65[11 + 2] and v18(v65[10 + 3])) or v18(0 + 0);
				v111 = 1434 - (797 + 636);
			end
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		v71 = ((v30.EssenceAttunement:IsAvailable()) and (9 - 7)) or (1620 - (1427 + 192));
		v81 = v30.BlastFurnace:TalentRank();
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v112 = 0 + 0;
		local v113;
		while true do
			if (((2 - 1) == v112) or ((1165 + 130) >= (1466 + 1767))) then
				v86 = 11437 - (192 + 134);
				for v154 in pairs(v26.FirestormTracker) do
					v26.FirestormTracker[v154] = nil;
				end
				break;
			end
			if (((5653 - (316 + 960)) > (914 + 728)) and (v112 == (0 + 0))) then
				v113 = false;
				v85 = 10270 + 841;
				v112 = 3 - 2;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v95()
		local v114 = 551 - (83 + 468);
		while true do
			if (((6529 - (1202 + 604)) > (6330 - 4974)) and (v114 == (1 - 0))) then
				return false;
			end
			if ((v114 == (0 - 0)) or ((4461 - (45 + 280)) <= (3314 + 119))) then
				if (((3709 + 536) <= (1691 + 2940)) and (v30.Firestorm:TimeSinceLastCast() > (7 + 5))) then
					return false;
				end
				if (((753 + 3523) >= (7247 - 3333)) and v26.FirestormTracker[v14:GUID()]) then
					if (((2109 - (340 + 1571)) <= (1722 + 2643)) and (v26.FirestormTracker[v14:GUID()] > (GetTime() - (1774.5 - (1733 + 39))))) then
						return true;
					end
				end
				v114 = 2 - 1;
			end
		end
	end
	local function v96()
		local v115 = 1034 - (125 + 909);
		while true do
			if (((6730 - (1096 + 852)) > (2098 + 2578)) and (v115 == (2 - 0))) then
				if (((4718 + 146) > (2709 - (409 + 103))) and v30.LivingFlame:IsCastable() and not v30.Firestorm:IsAvailable()) then
					if (v24(v30.LivingFlame, not v14:IsInRange(261 - (46 + 190)), v88) or ((3795 - (51 + 44)) == (708 + 1799))) then
						return "living_flame precombat";
					end
				end
				if (((5791 - (1114 + 203)) >= (1000 - (228 + 498))) and v30.AzureStrike:IsCastable()) then
					if (v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike)) or ((411 + 1483) <= (777 + 629))) then
						return "azure_strike precombat";
					end
				end
				break;
			end
			if (((2235 - (174 + 489)) >= (3988 - 2457)) and ((1905 - (830 + 1075)) == v115)) then
				if ((v63 == "Auto") or ((5211 - (303 + 221)) < (5811 - (231 + 1038)))) then
					if (((2743 + 548) > (2829 - (171 + 991))) and v30.SourceofMagic:IsCastable() and v15:IsInRange(102 - 77) and (v93 == v15:GUID()) and (v15:BuffRemains(v30.SourceofMagicBuff) < (805 - 505))) then
						if (v20(v32.SourceofMagicFocus) or ((2178 - 1305) == (1628 + 406))) then
							return "source_of_magic precombat";
						end
					end
				end
				if ((v63 == "Selected") or ((9871 - 7055) < (31 - 20))) then
					local v170 = 0 - 0;
					local v171;
					while true do
						if (((11434 - 7735) < (5954 - (111 + 1137))) and (v170 == (158 - (91 + 67)))) then
							v171 = v34.NamedUnit(74 - 49, v64);
							if (((661 + 1985) >= (1399 - (423 + 100))) and v171 and v30.SourceofMagic:IsCastable() and (v171:BuffRemains(v30.SourceofMagicBuff) < (3 + 297))) then
								if (((1699 - 1085) <= (1660 + 1524)) and v20(v32.SourceofMagicName)) then
									return "source_of_magic precombat";
								end
							end
							break;
						end
					end
				end
				v115 = 772 - (326 + 445);
			end
			if (((13641 - 10515) == (6963 - 3837)) and (v115 == (2 - 1))) then
				v83 = (712 - (530 + 181)) * v82;
				if (v30.Firestorm:IsCastable() or ((3068 - (614 + 267)) >= (4986 - (19 + 13)))) then
					if (v24(v30.Firestorm, not v14:IsInRange(40 - 15), v88) or ((9034 - 5157) == (10212 - 6637))) then
						return "firestorm precombat";
					end
				end
				v115 = 1 + 1;
			end
		end
	end
	local function v97()
		local v116 = 0 - 0;
		while true do
			if (((1465 - 758) > (2444 - (1293 + 519))) and (v116 == (0 - 0))) then
				if ((v30.ObsidianScales:IsCastable() and v13:BuffDown(v30.ObsidianScales) and (v13:HealthPercentage() < v59) and v58) or ((1425 - 879) >= (5132 - 2448))) then
					if (((6317 - 4852) <= (10131 - 5830)) and v24(v30.ObsidianScales)) then
						return "obsidian_scales defensives";
					end
				end
				if (((903 + 801) > (291 + 1134)) and v31.Healthstone:IsReady() and v50 and (v13:HealthPercentage() <= v51)) then
					if (v24(v32.Healthstone, nil, nil, true) or ((1596 - 909) == (979 + 3255))) then
						return "healthstone defensive 3";
					end
				end
				v116 = 1 + 0;
			end
			if ((v116 == (1 + 0)) or ((4426 - (709 + 387)) < (3287 - (673 + 1185)))) then
				if (((3326 - 2179) >= (1075 - 740)) and v30.RenewingBlaze:IsCastable() and (v13:HealthPercentage() < v57) and v56) then
					if (((5651 - 2216) > (1500 + 597)) and v20(v30.RenewingBlaze, nil, nil)) then
						return "RenewingBlaze main 6";
					end
				end
				if ((v44 and (v13:HealthPercentage() <= v46)) or ((2817 + 953) >= (5455 - 1414))) then
					if ((v45 == "Refreshing Healing Potion") or ((932 + 2859) <= (3211 - 1600))) then
						if (v31.RefreshingHealingPotion:IsReady() or ((8986 - 4408) <= (3888 - (446 + 1434)))) then
							if (((2408 - (1040 + 243)) <= (6196 - 4120)) and v24(v32.RefreshingHealingPotion, nil, nil, true)) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v98()
		if ((v77 and ((v70 >= (1850 - (559 + 1288))) or v13:BuffDown(v30.SpoilsofNeltharusVers) or ((v78 + ((1935 - (609 + 1322)) * v27(v30.EternitySurge:CooldownRemains() <= ((v87 * (456 - (13 + 441))) + v27(v30.FireBreath:CooldownRemains() <= (v87 * (7 - 5))))))) <= (47 - 29)))) or (v86 <= (99 - 79)) or ((28 + 715) >= (15976 - 11577))) then
			ShouldReturn = v34.HandleTopTrinket(v33, v37, 15 + 25, nil);
			if (((507 + 648) < (4964 - 3291)) and ShouldReturn) then
				return ShouldReturn;
			end
			ShouldReturn = v34.HandleBottomTrinket(v33, v37, 22 + 18, nil);
			if (ShouldReturn or ((4274 - 1950) <= (383 + 195))) then
				return ShouldReturn;
			end
		end
	end
	local function v99()
		if (((2096 + 1671) == (2707 + 1060)) and v30.EternitySurge:CooldownDown()) then
			return nil;
		end
		if (((3434 + 655) == (4001 + 88)) and ((v70 <= ((434 - (153 + 280)) + v27(v30.EternitysSpan:IsAvailable()))) or ((v78 < ((2.75 - 1) * v82)) and (v78 >= ((1 + 0) * v82))) or (v77 and ((v70 == (2 + 3)) or (not v30.EternitysSpan:IsAvailable() and (v70 >= (4 + 2))) or (v30.EternitysSpan:IsAvailable() and (v70 >= (8 + 0))))))) then
			v89 = 1 + 0;
		elseif (((6788 - 2330) >= (1035 + 639)) and ((v70 <= ((669 - (89 + 578)) + ((2 + 0) * v27(v30.EternitysSpan:IsAvailable())))) or ((v78 < ((3.5 - 1) * v82)) and (v78 >= ((1050.75 - (572 + 477)) * v82))))) then
			v89 = 1 + 1;
		elseif (((584 + 388) <= (170 + 1248)) and ((v70 <= ((89 - (84 + 2)) + ((4 - 1) * v27(v30.EternitysSpan:IsAvailable())))) or not v30.FontofMagic:IsAvailable() or ((v78 <= ((3.25 + 0) * v82)) and (v78 >= ((844.5 - (497 + 345)) * v82))))) then
			v89 = 1 + 2;
		else
			v89 = 1 + 3;
		end
		v91 = v89;
		if (v24(v30.EternitySurge, not v14:IsInRange(1363 - (605 + 728)), true) or ((3524 + 1414) < (10586 - 5824))) then
			return "eternity_surge empower " .. v89;
		end
	end
	local function v100()
		local v117 = 0 + 0;
		local v118;
		while true do
			if ((v117 == (0 - 0)) or ((2258 + 246) > (11813 - 7549))) then
				if (((1626 + 527) == (2642 - (457 + 32))) and v30.FireBreath:CooldownDown()) then
					return nil;
				end
				v118 = v14:DebuffRemains(v30.FireBreath);
				v117 = 1 + 0;
			end
			if ((v117 == (1404 - (832 + 570))) or ((478 + 29) >= (676 + 1915))) then
				if (((15857 - 11376) == (2159 + 2322)) and v22(v30.FireBreath, false, "1", not v14:IsInRange(826 - (588 + 208)), nil)) then
					return "fire_breath empower " .. v90 .. " main 12";
				end
				break;
			end
			if ((v117 == (2 - 1)) or ((4128 - (884 + 916)) < (1450 - 757))) then
				if (((2510 + 1818) == (4981 - (232 + 421))) and ((v77 and (v70 <= (1891 - (1569 + 320)))) or ((v70 == (1 + 0)) and not v30.EverburningFlame:IsAvailable()) or ((v78 < ((1.75 + 0) * v82)) and (v78 >= ((3 - 2) * v82))))) then
					v90 = 606 - (316 + 289);
				elseif (((4156 - 2568) >= (62 + 1270)) and ((not v95() and v30.EverburningFlame:IsAvailable() and (v70 <= (1456 - (666 + 787)))) or ((v70 == (427 - (360 + 65))) and not v30.EverburningFlame:IsAvailable()) or ((v78 < ((2.5 + 0) * v82)) and (v78 >= ((255.75 - (79 + 175)) * v82))))) then
					v90 = 2 - 0;
				elseif (not v30.FontofMagic:IsAvailable() or (v95() and v30.EverburningFlame:IsAvailable() and (v70 <= (3 + 0))) or ((v78 <= ((8.25 - 5) * v82)) and (v78 >= ((3.5 - 1) * v82))) or ((5073 - (503 + 396)) > (4429 - (92 + 89)))) then
					v90 = 5 - 2;
				else
					v90 = 3 + 1;
				end
				v92 = v90;
				v117 = 2 + 0;
			end
		end
	end
	local function v101()
		local v119 = 0 - 0;
		while true do
			if ((v119 == (1 + 0)) or ((10456 - 5870) <= (72 + 10))) then
				if (((1846 + 2017) == (11765 - 7902)) and v30.DeepBreath:IsCastable() and v37 and not v77 and (v13:EssenceDeficit() > (1 + 2)) and v34.TargetIsMouseover()) then
					if (v24(v32.DeepBreathCursor, not v14:IsInRange(45 - 15)) or ((1526 - (485 + 759)) <= (97 - 55))) then
						return "deep_breath aoe 6";
					end
				end
				if (((5798 - (442 + 747)) >= (1901 - (832 + 303))) and v30.ShatteringStar:IsCastable() and ((v13:BuffStack(v30.EssenceBurstBuff) < v71) or not v30.ArcaneVigor:IsAvailable())) then
					if (v24(v30.ShatteringStar, not v14:IsSpellInRange(v30.ShatteringStar)) or ((2098 - (88 + 858)) == (759 + 1729))) then
						return "shattering_star aoe 8";
					end
				end
				if (((2833 + 589) > (138 + 3212)) and v30.Firestorm:IsCastable()) then
					if (((1666 - (766 + 23)) > (1856 - 1480)) and v24(v30.Firestorm, not v14:IsInRange(33 - 8), v88)) then
						return "firestorm aoe 10";
					end
				end
				if ((v30.Pyre:IsReady() and ((v70 >= (13 - 8)) or ((v70 >= (13 - 9)) and ((v13:BuffDown(v30.EssenceBurstBuff) and v13:BuffDown(v30.IridescenceBlueBuff)) or not v30.EternitysSpan:IsAvailable())) or ((v70 >= (1077 - (1036 + 37))) and v30.Volatility:IsAvailable()) or ((v70 >= (3 + 0)) and v30.Volatility:IsAvailable() and v30.ChargedBlast:IsAvailable() and v13:BuffDown(v30.EssenceBurstBuff) and v13:BuffDown(v30.IridescenceBlueBuff)) or ((v70 >= (5 - 2)) and v30.Volatility:IsAvailable() and not v30.ChargedBlast:IsAvailable() and (v13:BuffUp(v30.IridescenceRedBuff) or v13:BuffDown(v30.EssenceBurstBuff))) or (v13:BuffStack(v30.ChargedBlastBuff) >= (12 + 3)))) or ((4598 - (641 + 839)) <= (2764 - (910 + 3)))) then
					if (v24(v30.Pyre, not v14:IsSpellInRange(v30.Pyre)) or ((420 - 255) >= (5176 - (1466 + 218)))) then
						return "pyre aoe 14";
					end
				end
				v119 = 1 + 1;
			end
			if (((5097 - (556 + 592)) < (1727 + 3129)) and (v119 == (810 - (329 + 479)))) then
				if ((v30.LivingFlame:IsCastable() and v13:BuffUp(v30.BurnoutBuff) and v13:BuffUp(v30.LeapingFlamesBuff) and v13:BuffDown(v30.EssenceBurstBuff) and (v13:Essence() < (v13:EssenceMax() - (855 - (174 + 680))))) or ((14693 - 10417) < (6250 - 3234))) then
					if (((3349 + 1341) > (4864 - (396 + 343))) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88)) then
						return "living_flame aoe 14";
					end
				end
				if (v30.Disintegrate:IsReady() or ((5 + 45) >= (2373 - (29 + 1448)))) then
					if (v24(v30.Disintegrate, not v14:IsSpellInRange(v30.Disintegrate), v88) or ((3103 - (135 + 1254)) >= (11143 - 8185))) then
						return "disintegrate aoe 20";
					end
				end
				if ((v30.LivingFlame:IsCastable() and v30.Snapfire:IsAvailable() and v13:BuffUp(v30.BurnoutBuff)) or ((6961 - 5470) < (430 + 214))) then
					if (((2231 - (389 + 1138)) < (1561 - (102 + 472))) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88)) then
						return "living_flame aoe 22";
					end
				end
				if (((3509 + 209) > (1057 + 849)) and v30.AzureStrike:IsCastable()) then
					if (v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike)) or ((894 + 64) > (5180 - (320 + 1225)))) then
						return "azure_strike aoe 24";
					end
				end
				break;
			end
			if (((6232 - 2731) <= (2749 + 1743)) and (v119 == (1464 - (157 + 1307)))) then
				if ((v30.Dragonrage:IsCastable() and Cds and ((v14:TimeToDie() >= (1891 - (821 + 1038))) or (v86 < (74 - 44)))) or ((377 + 3065) < (4525 - 1977))) then
					if (((1070 + 1805) >= (3628 - 2164)) and v24(v30.Dragonrage)) then
						return "dragonrage aoe 2";
					end
				end
				if ((v30.TipTheScales:IsCastable() and v37 and v77 and ((v70 <= ((1029 - (834 + 192)) + ((1 + 2) * v27(v30.EternitysSpan:IsAvailable())))) or v30.FireBreath:CooldownDown())) or ((1232 + 3565) >= (106 + 4787))) then
					if (v24(v30.TipTheScales) or ((853 - 302) > (2372 - (300 + 4)))) then
						return "tip_the_scales aoe 4";
					end
				end
				if (((565 + 1549) > (2471 - 1527)) and (not v30.Dragonrage:IsAvailable() or (v76 > v79) or not v30.Animosity:IsAvailable()) and ((((v13:BuffRemains(v30.PowerSwellBuff) < v83) or (not v30.Volatility:IsAvailable() and (v70 == (365 - (112 + 250))))) and (v13:BuffRemains(v30.BlazingShardsBuff) < v83)) or v77) and ((v14:TimeToDie() >= (4 + 4)) or (v86 < (75 - 45)))) then
					local v172 = v100();
					if (v172 or ((1296 + 966) >= (1602 + 1494))) then
						return v172;
					end
				end
				if (v77 or not v30.Dragonrage:IsAvailable() or ((v30.Dragonrage:CooldownRemains() > v79) and ((v13:BuffRemains(v30.PowerSwellBuff) < v83) or (not v30.Volatility:IsAvailable() and (v70 == (3 + 0)))) and (v13:BuffRemains(v30.BlazingShardsBuff) < v83) and ((v14:TimeToDie() >= (4 + 4)) or (v86 < (23 + 7)))) or ((3669 - (1001 + 413)) >= (7887 - 4350))) then
					local v173 = v99();
					if (v173 or ((4719 - (244 + 638)) < (1999 - (627 + 66)))) then
						return v173;
					end
				end
				v119 = 2 - 1;
			end
		end
	end
	local function v102()
		local v120 = 602 - (512 + 90);
		while true do
			if (((4856 - (1665 + 241)) == (3667 - (373 + 344))) and (v120 == (1 + 0))) then
				if ((v30.Disintegrate:IsReady() and (v78 > (6 + 13)) and (v30.FireBreath:CooldownRemains() > (73 - 45)) and v30.EyeofInfinity:IsAvailable() and v13:HasTier(50 - 20, 1101 - (35 + 1064))) or ((3437 + 1286) < (7055 - 3757))) then
					if (((5 + 1131) >= (1390 - (298 + 938))) and v20(v30.Disintegrate, nil, nil, not v14:IsSpellInRange(v30.Disintegrate))) then
						return "disintegrate st 9";
					end
				end
				if ((v30.ShatteringStar:IsCastable() and ((v13:BuffStack(v30.EssenceBurstBuff) < v71) or not v30.ArcaneVigor:IsAvailable())) or ((1530 - (233 + 1026)) > (6414 - (636 + 1030)))) then
					if (((2424 + 2316) >= (3079 + 73)) and v24(v30.ShatteringStar, not v14:IsSpellInRange(v30.ShatteringStar))) then
						return "shattering_star st 10";
					end
				end
				if (((not v30.Dragonrage:IsAvailable() or (v76 > v80) or not v30.Animosity:IsAvailable()) and ((v13:BuffRemains(v30.BlazingShardsBuff) < v83) or v77) and ((v14:TimeToDie() >= (3 + 5)) or (v86 < (3 + 27)))) or ((2799 - (55 + 166)) >= (657 + 2733))) then
					local v174 = v99();
					if (((5 + 36) <= (6343 - 4682)) and v174) then
						return v174;
					end
				end
				if (((898 - (36 + 261)) < (6225 - 2665)) and v30.Animosity:IsAvailable() and v77 and (v78 < (v87 + (v83 * v27(v13:BuffDown(v30.TipTheScales))))) and ((v78 - v30.FireBreath:CooldownRemains()) >= (v83 * v27(v13:BuffDown(v30.TipTheScales))))) then
					if (((1603 - (34 + 1334)) < (265 + 422)) and v24(v30.Pool)) then
						return "Wait for FB st 12";
					end
				end
				v120 = 2 + 0;
			end
			if (((5832 - (1035 + 248)) > (1174 - (20 + 1))) and (v120 == (0 + 0))) then
				if ((v30.Firestorm:IsCastable() and (v13:BuffUp(v30.SnapfireBuff))) or ((4993 - (134 + 185)) < (5805 - (549 + 584)))) then
					if (((4353 - (314 + 371)) < (15657 - 11096)) and v24(v30.Firestorm, not v14:IsInRange(993 - (478 + 490)), v88)) then
						return "firestorm st 4";
					end
				end
				if ((v30.Dragonrage:IsCastable() and v37 and (((v30.FireBreath:CooldownRemains() < v87) and (v30.EternitySurge:CooldownRemains() < ((2 + 0) * v87))) or (v86 < (1202 - (786 + 386))))) or ((1473 - 1018) == (4984 - (1055 + 324)))) then
					if (v24(v30.Dragonrage) or ((4003 - (1093 + 247)) == (2944 + 368))) then
						return "dragonrage st 6";
					end
				end
				if (((450 + 3827) <= (17766 - 13291)) and v30.TipTheScales:IsCastable() and v37 and ((v77 and v30.EternitySurge:CooldownUp() and v30.FireBreath:CooldownDown() and not v30.EverburningFlame:IsAvailable()) or (v30.EverburningFlame:IsAvailable() and v30.FireBreath:CooldownUp()))) then
					if (v24(v30.TipTheScales) or ((2952 - 2082) == (3382 - 2193))) then
						return "tip_the_scales st 8";
					end
				end
				if (((3902 - 2349) <= (1115 + 2018)) and (not v30.Dragonrage:IsAvailable() or (v76 > v80) or not v30.Animosity:IsAvailable()) and ((v13:BuffRemains(v30.BlazingShardsBuff) < v83) or v77) and ((v14:TimeToDie() >= (30 - 22)) or (v86 < (103 - 73)))) then
					local v175 = 0 + 0;
					local v176;
					while true do
						if ((v175 == (0 - 0)) or ((2925 - (364 + 324)) >= (9624 - 6113))) then
							v176 = v100();
							if (v176 or ((3177 - 1853) > (1001 + 2019))) then
								return v176;
							end
							break;
						end
					end
				end
				v120 = 4 - 3;
			end
			if ((v120 == (5 - 1)) or ((9086 - 6094) == (3149 - (1249 + 19)))) then
				if (((2804 + 302) > (5939 - 4413)) and v30.DeepBreath:IsCastable() and v37 and not v77 and v30.ImminentDestruction:IsAvailable() and v14:DebuffDown(v30.ShatteringStar) and v34.TargetIsMouseover()) then
					if (((4109 - (686 + 400)) < (3037 + 833)) and v24(v32.DeepBreathCursor, not v14:IsInRange(259 - (73 + 156)))) then
						return "deep_breath st 30";
					end
				end
				if (((1 + 142) > (885 - (721 + 90))) and v30.LivingFlame:IsCastable()) then
					if (((1 + 17) < (6857 - 4745)) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88)) then
						return "living_flame st 32";
					end
				end
				if (((1567 - (224 + 246)) <= (2636 - 1008)) and v30.AzureStrike:IsCastable()) then
					if (((8524 - 3894) == (840 + 3790)) and v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike))) then
						return "azure_strike st 34";
					end
				end
				break;
			end
			if (((85 + 3455) > (1971 + 712)) and ((5 - 2) == v120)) then
				if (((15953 - 11159) >= (3788 - (203 + 310))) and v30.Pyre:IsReady() and v95() and v30.RagingInferno:IsAvailable() and (v13:BuffStack(v30.ChargedBlastBuff) == (2013 - (1238 + 755))) and (v70 >= (1 + 1))) then
					if (((3018 - (709 + 825)) == (2734 - 1250)) and v24(v30.Pyre, not v14:IsSpellInRange(v30.Pyre))) then
						return "pyre st 22";
					end
				end
				if (((2085 - 653) < (4419 - (196 + 668))) and v30.Disintegrate:IsReady()) then
					if (v24(v30.Disintegrate, not v14:IsSpellInRange(v30.Disintegrate), v88) or ((4204 - 3139) > (7411 - 3833))) then
						return "disintegrate st 24";
					end
				end
				if ((v30.Firestorm:IsCastable() and not v77 and v14:DebuffDown(v30.ShatteringStar)) or ((5628 - (171 + 662)) < (1500 - (4 + 89)))) then
					if (((6494 - 4641) < (1753 + 3060)) and v24(v30.Firestorm, not v14:IsInRange(109 - 84), v88)) then
						return "firestorm st 26";
					end
				end
				if ((v30.DeepBreath:IsCastable() and v37 and not v77 and (v70 >= (1 + 1)) and v34.TargetIsMouseover()) or ((4307 - (35 + 1451)) < (3884 - (28 + 1425)))) then
					if (v24(v32.DeepBreathCursor, not v14:IsInRange(2023 - (941 + 1052))) or ((2756 + 118) < (3695 - (822 + 692)))) then
						return "deep_breath st 28";
					end
				end
				v120 = 5 - 1;
			end
			if ((v120 == (1 + 1)) or ((2986 - (45 + 252)) <= (340 + 3))) then
				if ((v30.Animosity:IsAvailable() and v77 and (v78 < (v87 + v83)) and ((v78 - v30.EternitySurge:CooldownRemains()) > (v83 * v27(v13:BuffDown(v30.TipTheScales))))) or ((644 + 1225) == (4889 - 2880))) then
					if (v24(v30.Pool) or ((3979 - (114 + 319)) < (3333 - 1011))) then
						return "Wait for ES st 14";
					end
				end
				if ((v30.LivingFlame:IsCastable() and v77 and (v78 < ((v71 - v13:BuffStack(v30.EssenceBurstBuff)) * v87)) and v13:BuffUp(v30.BurnoutBuff)) or ((2667 - 585) == (3043 + 1730))) then
					if (((4832 - 1588) > (2210 - 1155)) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88)) then
						return "living_flame st 16";
					end
				end
				if ((v30.AzureStrike:IsCastable() and v77 and (v78 < ((v71 - v13:BuffStack(v30.EssenceBurstBuff)) * v87))) or ((5276 - (556 + 1407)) <= (2984 - (741 + 465)))) then
					if (v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike)) or ((1886 - (170 + 295)) >= (1109 + 995))) then
						return "azure_strike st 18";
					end
				end
				if (((1665 + 147) <= (7998 - 4749)) and v30.LivingFlame:IsCastable() and v13:BuffUp(v30.BurnoutBuff) and ((v13:BuffUp(v30.LeapingFlamesBuff) and v13:BuffDown(v30.EssenceBurstBuff)) or (v13:BuffDown(v30.LeapingFlamesBuff) and (v13:BuffStack(v30.EssenceBurstBuff) < v71))) and (v13:Essence() < (v13:EssenceMax() - (1 + 0)))) then
					if (((1041 + 582) <= (1109 + 848)) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v88)) then
						return "living_flame st 20";
					end
				end
				v120 = 1233 - (957 + 273);
			end
		end
	end
	local function v103()
		if (((1181 + 3231) == (1767 + 2645)) and (v40 == "Player Only")) then
			if (((6668 - 4918) >= (2218 - 1376)) and v30.VerdantEmbrace:IsReady() and (v13:HealthPercentage() < v42)) then
				if (((13353 - 8981) > (9160 - 7310)) and v20(v32.VerdantEmbracePlayer, nil)) then
					return "verdant_embrace main 40";
				end
			end
		end
		if (((2012 - (389 + 1391)) < (516 + 305)) and ((v40 == "Everyone") or (v40 == "Not Tank"))) then
			if (((54 + 464) < (2053 - 1151)) and v30.VerdantEmbrace:IsReady() and (v15:HealthPercentage() < v42)) then
				if (((3945 - (783 + 168)) > (2879 - 2021)) and v20(v32.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace main 40";
				end
			end
		end
		if ((v41 == "Player Only") or ((3694 + 61) <= (1226 - (309 + 2)))) then
			if (((12117 - 8171) > (4955 - (1090 + 122))) and v30.EmeraldBlossom:IsReady() and (v13:HealthPercentage() < v43)) then
				if (v20(v32.EmeraldBlossomPlayer, nil) or ((433 + 902) >= (11102 - 7796))) then
					return "emerald_blossom main 42";
				end
			end
		end
		if (((3316 + 1528) > (3371 - (628 + 490))) and (v41 == "Everyone")) then
			if (((82 + 370) == (1118 - 666)) and v30.EmeraldBlossom:IsReady() and (v15:HealthPercentage() < v43)) then
				if (v20(v32.EmeraldBlossomFocus, nil) or ((20825 - 16268) < (2861 - (431 + 343)))) then
					return "emerald_blossom main 42";
				end
			end
		end
	end
	local function v104()
		local v121 = 0 - 0;
		while true do
			if (((11207 - 7333) == (3061 + 813)) and (v121 == (0 + 0))) then
				if (not v15 or not v15:Exists() or not v15:IsInRange(1725 - (556 + 1139)) or not v34.DispellableFriendlyUnit() or ((1953 - (6 + 9)) > (904 + 4031))) then
					return;
				end
				if ((v30.Expunge:IsReady() and (v34.UnitHasPoisonDebuff(v15))) or ((2180 + 2075) < (3592 - (28 + 141)))) then
					if (((564 + 890) <= (3074 - 583)) and v24(v32.ExpungeFocus)) then
						return "Expunge dispel";
					end
				end
				v121 = 1 + 0;
			end
			if ((v121 == (1318 - (486 + 831))) or ((10817 - 6660) <= (9868 - 7065))) then
				if (((918 + 3935) >= (9428 - 6446)) and v30.OppressingRoar:IsReady() and v55 and v34.UnitHasEnrageBuff(v14)) then
					if (((5397 - (668 + 595)) > (3021 + 336)) and v24(v30.OppressingRoar)) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
		end
	end
	local function v105()
		v40 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
		v41 = EpicSettings.Settings['EmeraldBlossomUsage'] or "";
		v42 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 + 0);
		v43 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 - 0);
		v44 = EpicSettings.Settings['UseHealingPotion'];
		v45 = EpicSettings.Settings['HealingPotionName'] or "";
		v46 = EpicSettings.Settings['HealingPotionHP'] or (290 - (23 + 267));
		v47 = EpicSettings.Settings['UseBlessingOfTheBronze'];
		v48 = EpicSettings.Settings['DispelDebuffs'];
		v49 = EpicSettings.Settings['DispelBuffs'];
		v50 = EpicSettings.Settings['UseHealthstone'];
		v51 = EpicSettings.Settings['HealthstoneHP'] or (1944 - (1129 + 815));
		v52 = EpicSettings.Settings['InterruptWithStun'];
		v53 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v54 = EpicSettings.Settings['InterruptThreshold'] or (387 - (371 + 16));
		v55 = EpicSettings.Settings['UseOppressingRoar'];
		v56 = EpicSettings.Settings['UseRenewingBlaze'];
		v57 = EpicSettings.Settings['RenewingBlazeHP'] or (1750 - (1326 + 424));
		v58 = EpicSettings.Settings['UseObsidianScales'];
		v59 = EpicSettings.Settings['ObsidianScalesHP'] or (0 - 0);
		v60 = EpicSettings.Settings['UseHover'];
		v61 = EpicSettings.Settings['HoverTime'] or (0 - 0);
		v62 = EpicSettings.Settings['LandslideUsage'] or "";
		v63 = EpicSettings.Settings['SourceOfMagicUsage'] or "";
		v64 = EpicSettings.Settings['SourceOfMagicName'] or "";
	end
	local function v106()
		v105();
		v35 = EpicSettings.Toggles['ooc'];
		v36 = EpicSettings.Toggles['aoe'];
		v37 = EpicSettings.Toggles['cds'];
		v38 = EpicSettings.Toggles['heal'];
		v39 = EpicSettings.Toggles['dispel'];
		if (v13:IsDeadOrGhost() or ((3535 - (88 + 30)) < (3305 - (720 + 51)))) then
			return;
		end
		if ((v48 and v30.Expunge:IsReady() and v34.DispellableFriendlyUnit()) or ((6054 - 3332) <= (1940 - (421 + 1355)))) then
			local v141 = 0 - 0;
			local v142;
			local v143;
			while true do
				if (((0 + 0) == v141) or ((3491 - (286 + 797)) < (7709 - 5600))) then
					v142 = v48;
					v143 = v34.FocusUnit(v142, v32, 49 - 19);
					v141 = 440 - (397 + 42);
				end
				if ((v141 == (1 + 0)) or ((833 - (24 + 776)) == (2241 - 786))) then
					if (v143 or ((1228 - (222 + 563)) >= (8846 - 4831))) then
						return v143;
					end
					break;
				end
			end
		elseif (((2435 + 947) > (356 - (23 + 167))) and v94() and (v15:BuffRemains(v30.SourceofMagicBuff) < (2098 - (690 + 1108)))) then
			local v156 = 0 + 0;
			while true do
				if (((0 + 0) == v156) or ((1128 - (40 + 808)) == (504 + 2555))) then
					v93 = v94():GUID();
					if (((7192 - 5311) > (1236 + 57)) and (v63 == "Auto") and (v94():BuffRemains(v30.SourceofMagicBuff) < (159 + 141)) and v30.SourceofMagic:IsCastable()) then
						ShouldReturn = v34.FocusSpecifiedUnit(v94(), 14 + 11);
						if (((2928 - (47 + 524)) == (1530 + 827)) and ShouldReturn) then
							return ShouldReturn;
						end
					end
					break;
				end
			end
		elseif (((336 - 213) == (183 - 60)) and v38) then
			if (((v40 == "Everyone") and v30.VerdantEmbrace:IsReady()) or ((v41 == "Everyone") and v30.EmeraldBlossom:IsReady()) or ((2408 - 1352) >= (5118 - (1165 + 561)))) then
				ShouldReturn = v34.FocusUnit(false, nil, nil, nil);
				if (ShouldReturn or ((33 + 1048) < (3329 - 2254))) then
					return ShouldReturn;
				end
			elseif (((v40 == "Not Tank") and v30.VerdantEmbrace:IsReady()) or ((401 + 648) >= (4911 - (341 + 138)))) then
				local v180 = v34.GetFocusUnit(false, nil, "HEALER") or v13;
				local v181 = v34.GetFocusUnit(false, nil, "DAMAGER") or v13;
				if ((v180:HealthPercentage() < v181:HealthPercentage()) or ((1288 + 3480) <= (1745 - 899))) then
					local v182 = 326 - (89 + 237);
					while true do
						if (((0 - 0) == v182) or ((7069 - 3711) <= (2301 - (581 + 300)))) then
							ShouldReturn = v34.FocusUnit(false, nil, nil, "HEALER");
							if (ShouldReturn or ((4959 - (855 + 365)) <= (7137 - 4132))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if ((v181:HealthPercentage() < v180:HealthPercentage()) or ((542 + 1117) >= (3369 - (1030 + 205)))) then
					ShouldReturn = v34.FocusUnit(false, nil, nil, "DAMAGER");
					if (ShouldReturn or ((3061 + 199) < (2191 + 164))) then
						return ShouldReturn;
					end
				end
			end
		end
		if (not v13:IsMoving() or ((955 - (156 + 130)) == (9595 - 5372))) then
			LastStationaryTime = GetTime();
		end
		if (v13:IsChanneling(v30.FireBreath) or ((2851 - 1159) < (1204 - 616))) then
			local v144 = GetTime() - v13:CastStart();
			if ((v144 >= v13:EmpowerCastTime(v92)) or ((1265 + 3532) < (2130 + 1521))) then
				v10.EpicSettingsS = v30.FireBreath.ReturnID;
				return "Stopping Fire Breath";
			end
		end
		if (v13:IsChanneling(v30.EternitySurge) or ((4246 - (10 + 59)) > (1372 + 3478))) then
			local v145 = GetTime() - v13:CastStart();
			if ((v145 >= v13:EmpowerCastTime(v91)) or ((1969 - 1569) > (2274 - (671 + 492)))) then
				local v159 = 0 + 0;
				while true do
					if (((4266 - (369 + 846)) > (267 + 738)) and (v159 == (0 + 0))) then
						v10.EpicSettingsS = v30.EternitySurge.ReturnID;
						return "Stopping EternitySurge";
					end
				end
			end
		end
		v88 = v13:BuffRemains(v30.HoverBuff) < (1947 - (1036 + 909));
		v68 = v13:GetEnemiesInRange(20 + 5);
		v69 = v14:GetEnemiesInSplashRange(13 - 5);
		if (((3896 - (11 + 192)) <= (2215 + 2167)) and v36) then
			v70 = v14:GetEnemiesInSplashRangeCount(183 - (135 + 40));
		else
			v70 = 2 - 1;
		end
		if (v34.TargetIsValid() or v13:AffectingCombat() or ((1979 + 1303) > (9032 - 4932))) then
			v85 = v10.BossFightRemains(nil, true);
			v86 = v85;
			if ((v86 == (16656 - 5545)) or ((3756 - (50 + 126)) < (7919 - 5075))) then
				v86 = v10.FightRemains(v68, false);
			end
		end
		v87 = v13:GCD() + 0.25 + 0;
		v82 = v13:SpellHaste();
		v83 = (1414 - (1233 + 180)) * v82;
		if (((1058 - (522 + 447)) < (5911 - (107 + 1314))) and ((v34.TargetIsValid() and v35) or v13:AffectingCombat())) then
			v77 = v13:BuffUp(v30.Dragonrage);
			v78 = (v77 and v13:BuffRemains(v30.Dragonrage)) or (0 + 0);
		end
		if (not v13:AffectingCombat() or ((15183 - 10200) < (768 + 1040))) then
			if (((7603 - 3774) > (14912 - 11143)) and v47 and v30.BlessingoftheBronze:IsCastable() and (v13:BuffDown(v30.BlessingoftheBronzeBuff, true) or v34.GroupBuffMissing(v30.BlessingoftheBronzeBuff))) then
				if (((3395 - (716 + 1194)) <= (50 + 2854)) and v24(v30.BlessingoftheBronze)) then
					return "blessing_of_the_bronze precombat";
				end
			end
		end
		if (((458 + 3811) == (4772 - (74 + 429))) and v38 and v35 and not v13:AffectingCombat()) then
			local v146 = 0 - 0;
			local v147;
			while true do
				if (((192 + 195) <= (6367 - 3585)) and (v146 == (0 + 0))) then
					v147 = v103();
					if (v147 or ((5854 - 3955) <= (2266 - 1349))) then
						return v147;
					end
					break;
				end
			end
		end
		if ((v60 and (v35 or v13:AffectingCombat())) or ((4745 - (279 + 154)) <= (1654 - (454 + 324)))) then
			if (((1757 + 475) <= (2613 - (12 + 5))) and ((GetTime() - LastStationaryTime) > v61)) then
				if (((1130 + 965) < (9391 - 5705)) and v30.Hover:IsReady() and v13:BuffDown(v30.Hover)) then
					if (v24(v30.Hover) or ((590 + 1005) >= (5567 - (277 + 816)))) then
						return "hover main 2";
					end
				end
			end
		end
		if ((not v13:AffectingCombat() and v35 and not v13:IsCasting()) or ((19737 - 15118) < (4065 - (1058 + 125)))) then
			local v148 = v96();
			if (v148 or ((56 + 238) >= (5806 - (815 + 160)))) then
				return v148;
			end
		end
		if (((8705 - 6676) <= (7320 - 4236)) and v13:AffectingCombat()) then
			local v149 = v97();
			if (v149 or ((486 + 1551) == (7074 - 4654))) then
				return v149;
			end
		end
		if (((6356 - (41 + 1857)) > (5797 - (1222 + 671))) and (v13:AffectingCombat() or v35)) then
			if (((1126 - 690) >= (175 - 52)) and not v13:IsCasting() and not v13:IsChanneling()) then
				local v160 = 1182 - (229 + 953);
				local v161;
				while true do
					if (((2274 - (1111 + 663)) < (3395 - (874 + 705))) and (v160 == (0 + 0))) then
						v161 = v34.Interrupt(v30.Quell, 7 + 3, true);
						if (((7428 - 3854) == (101 + 3473)) and v161) then
							return v161;
						end
						v160 = 680 - (642 + 37);
					end
					if (((51 + 170) < (63 + 327)) and (v160 == (4 - 2))) then
						v161 = v34.Interrupt(v30.Quell, 464 - (233 + 221), true, Mouseover, v32.QuellMouseover);
						if (v161 or ((5117 - 2904) <= (1251 + 170))) then
							return v161;
						end
						break;
					end
					if (((4599 - (718 + 823)) < (3059 + 1801)) and ((806 - (266 + 539)) == v160)) then
						v161 = v34.InterruptWithStun(v30.TailSwipe, 22 - 14);
						if (v161 or ((2521 - (636 + 589)) >= (10553 - 6107))) then
							return v161;
						end
						v160 = 3 - 1;
					end
				end
			end
			v76 = v29(v30.Dragonrage:CooldownRemains(), v30.EternitySurge:CooldownRemains() - ((2 + 0) * v87), v30.FireBreath:CooldownRemains() - v87);
			if ((v30.Unravel:IsReady() and v14:EnemyAbsorb()) or ((507 + 886) > (5504 - (657 + 358)))) then
				if (v24(v30.Unravel, not v14:IsSpellInRange(v30.Unravel)) or ((11713 - 7289) < (61 - 34))) then
					return "unravel main 4";
				end
			end
			if (v49 or v48 or ((3184 - (1151 + 36)) > (3685 + 130))) then
				local v162 = 0 + 0;
				local v163;
				while true do
					if (((10347 - 6882) > (3745 - (1552 + 280))) and (v162 == (834 - (64 + 770)))) then
						v163 = v104();
						if (((498 + 235) < (4128 - 2309)) and v163) then
							return v163;
						end
						break;
					end
				end
			end
			if ((v38 and v13:AffectingCombat()) or ((781 + 3614) == (5998 - (157 + 1086)))) then
				local v164 = v103();
				if (v164 or ((7591 - 3798) < (10375 - 8006))) then
					return v164;
				end
			end
			if ((v60 and v13:AffectingCombat()) or ((6264 - 2180) == (361 - 96))) then
				if (((5177 - (599 + 220)) == (8678 - 4320)) and ((GetTime() - LastStationaryTime) > v61)) then
					if (v30.Hover:IsReady() or ((5069 - (1813 + 118)) < (726 + 267))) then
						if (((4547 - (841 + 376)) > (3254 - 931)) and v24(v30.Hover)) then
							return "hover main 2";
						end
					end
				end
			end
			if ((v63 == "Auto") or ((843 + 2783) == (10887 - 6898))) then
				if ((v30.SourceofMagic:IsCastable() and v15:IsInRange(884 - (464 + 395)) and (v93 == v15:GUID()) and (v15:BuffRemains(v30.SourceofMagicBuff) < (769 - 469))) or ((440 + 476) == (3508 - (467 + 370)))) then
					if (((561 - 289) == (200 + 72)) and v20(v32.SourceofMagicFocus)) then
						return "source_of_magic precombat";
					end
				end
			end
			if (((14565 - 10316) <= (755 + 4084)) and (v63 == "Selected")) then
				local v165 = v34.NamedUnit(58 - 33, v64);
				if (((3297 - (150 + 370)) < (4482 - (74 + 1208))) and v165 and v30.SourceofMagic:IsCastable() and (v165:BuffRemains(v30.SourceofMagicBuff) < (737 - 437))) then
					if (((450 - 355) < (1393 + 564)) and v20(v32.SourceofMagicName)) then
						return "source_of_magic precombat";
					end
				end
			end
			local v150 = v34.HandleDPSPotion(v13:BuffUp(v30.IridescenceBlueBuff));
			if (((1216 - (14 + 376)) < (2977 - 1260)) and v150) then
				return v150;
			end
			if (((923 + 503) >= (971 + 134)) and v37) then
				local v166 = v98();
				if (((2627 + 127) <= (9900 - 6521)) and v166) then
					return v166;
				end
			end
			if ((v70 >= (3 + 0)) or ((4005 - (23 + 55)) == (3348 - 1935))) then
				local v167 = 0 + 0;
				local v168;
				while true do
					if ((v167 == (1 + 0)) or ((1788 - 634) <= (248 + 540))) then
						if (v24(v30.Pool) or ((2544 - (652 + 249)) > (9042 - 5663))) then
							return "Pool for Aoe()";
						end
						break;
					end
					if ((v167 == (1868 - (708 + 1160))) or ((7608 - 4805) > (8293 - 3744))) then
						v168 = v101();
						if (v168 or ((247 - (10 + 17)) >= (679 + 2343))) then
							return v168;
						end
						v167 = 1733 - (1400 + 332);
					end
				end
			end
			local v151 = v102();
			if (((5412 - 2590) == (4730 - (242 + 1666))) and v151) then
				return v151;
			end
		end
		if (v24(v30.Pool) or ((455 + 606) == (681 + 1176))) then
			return "Pool for ST()";
		end
	end
	local function v107()
		v34.DispellableDebuffs = v34.DispellablePoisonDebuffs;
		v19.Print("Devastation Evoker by Epic BoomK.");
		EpicSettings.SetupVersion("Devastation Evoker X v 10.2.01 By BoomK");
	end
	v19.SetAPL(1251 + 216, v106, v107);
end;
return v0["Epix_Evoker_Devastation.lua"]();

