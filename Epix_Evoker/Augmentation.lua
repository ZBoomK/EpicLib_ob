local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((5266 - (991 + 564)) < (660 + 348))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Evoker_Augmentation.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.MouseOver;
	local v14 = v11.Pet;
	local v15 = v11.Target;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Utils;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.CastAnnotated;
	local v24 = v21.CastPooling;
	local v25 = v21.Macro;
	local v26 = v21.Press;
	local v27 = v21.Commons.Everyone.num;
	local v28 = v21.Commons.Everyone.bool;
	local v29 = 1559 - (1381 + 178);
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v72 = v17.Evoker.Augmentation;
	local v73 = v19.Evoker.Augmentation;
	local v74 = v25.Evoker.Augmentation;
	local v75 = {};
	local v76 = v21.Commons.Everyone;
	local v77 = {};
	local v78 = ((v72.FontofMagic:IsAvailable()) and (4 + 0)) or (3 + 0);
	local v79 = ((v72.FontofMagic:IsAvailable()) and (0.8 + 0)) or (3 - 2);
	local v80 = 5757 + 5354;
	local v81 = 11581 - (381 + 89);
	local v82 = 1 + 0;
	local v83 = 1 + 0;
	local v84 = {{v72.TailSwipe,"Cast Tail Swipe (Interrupt)",function()
		return true;
	end},{v72.WingBuffet,"Cast Wing Buffet (Interrupt)",function()
		return true;
	end}};
	v9:RegisterForEvent(function()
		v80 = 43727 - 32616;
		v81 = 12837 - (1668 + 58);
	end, "PLAYER_REGEN_ENABLED");
	v9:RegisterForEvent(function()
		v78 = ((v72.FontofMagic:IsAvailable()) and (630 - (512 + 114))) or (7 - 4);
		v79 = ((v72.FontofMagic:IsAvailable()) and (0.8 - 0)) or (3 - 2);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v85;
	local function v86()
	end
	local v87;
	local function v88()
		local v99;
		if (UnitInRaid("player") or ((489 + 560) <= (170 + 736))) then
			v99 = v11.Raid;
		elseif (((3924 + 589) > (9194 - 6468)) and UnitInParty("player")) then
			v99 = v11.Party;
		else
			return false;
		end
		local v100 = nil;
		for v113, v114 in pairs(v99) do
			if ((v114:Exists() and (UnitGroupRolesAssigned(v113) == "HEALER") and v114:IsInRange(2019 - (109 + 1885)) and (v114:HealthPercentage() > (1469 - (1269 + 200))) and v114:BuffDown(v72.SourceofMagicBuff)) or ((2838 - 1357) >= (3473 - (98 + 717)))) then
				local v128 = 826 - (802 + 24);
				while true do
					if ((v128 == (0 - 0)) or ((4066 - 846) == (202 + 1162))) then
						v100 = v114;
						v87 = v114:GUID();
						break;
					end
				end
			end
		end
		return v100;
	end
	local v89;
	local function v90()
		local v101 = 0 + 0;
		local v102;
		while true do
			if ((v101 == (1 + 0)) or ((228 + 826) > (9436 - 6044))) then
				if ((v102 == v12) or ((2254 - 1578) >= (588 + 1054))) then
					local v145 = 0 + 0;
					while true do
						if (((3412 + 724) > (1743 + 654)) and (v145 == (0 + 0))) then
							v89 = v12:GUID();
							return v12;
						end
					end
				else
					for v156, v157 in pairs(v102) do
						if ((v157:Exists() and (v157:IsTankingAoE(1441 - (797 + 636)) or v157:IsTanking(v15)) and (UnitGroupRolesAssigned(v156) == "TANK") and v157:IsInRange(121 - 96) and (v157:HealthPercentage() > (1619 - (1427 + 192)))) or ((1502 + 2832) == (9855 - 5610))) then
							local v167 = 0 + 0;
							while true do
								if ((v167 == (0 + 0)) or ((4602 - (192 + 134)) <= (4307 - (316 + 960)))) then
									v89 = v157:GUID();
									return v157;
								end
							end
						end
					end
				end
				return nil;
			end
			if ((v101 == (0 + 0)) or ((3691 + 1091) <= (1109 + 90))) then
				v102 = nil;
				if (UnitInRaid("player") or ((18595 - 13731) < (2453 - (83 + 468)))) then
					v102 = v11.Raid;
				elseif (((6645 - (1202 + 604)) >= (17272 - 13572)) and UnitInParty("player")) then
					v102 = v11.Party;
				else
					v102 = v12;
				end
				v101 = 1 - 0;
			end
		end
	end
	local function v91()
		if ((v72.BlessingoftheBronze:IsCastable() and v53 and (v12:BuffDown(v72.BlessingoftheBronzeBuff, true) or v76.GroupBuffMissing(v72.BlessingoftheBronzeBuff))) or ((2976 - 1901) > (2243 - (45 + 280)))) then
			if (((383 + 13) <= (3324 + 480)) and v22(v72.BlessingoftheBronze, nil)) then
				return "blessing_of_the_bronze precombat";
			end
		end
		if ((v38 == "Auto") or ((1523 + 2646) == (1211 + 976))) then
			if (((248 + 1158) == (2603 - 1197)) and v72.SourceofMagic:IsCastable() and v16:IsInRange(1936 - (340 + 1571)) and (v87 == v16:GUID()) and (v16:BuffRemains(v72.SourceofMagicBuff) < (119 + 181))) then
				if (((3303 - (1733 + 39)) < (11736 - 7465)) and v22(v74.SourceofMagicFocus)) then
					return "source_of_magic precombat";
				end
			end
		end
		if (((1669 - (125 + 909)) == (2583 - (1096 + 852))) and (v38 == "Selected")) then
			local v116 = v76.NamedUnit(12 + 13, v39);
			if (((4816 - 1443) <= (3450 + 106)) and v116 and v72.SourceofMagic:IsCastable() and (v116:BuffRemains(v72.SourceofMagicBuff) < (812 - (409 + 103)))) then
				if (v22(v74.SourceofMagicName) or ((3527 - (46 + 190)) < (3375 - (51 + 44)))) then
					return "source_of_magic precombat";
				end
			end
		end
		if (((1238 + 3148) >= (2190 - (1114 + 203))) and v72.BlackAttunement:IsCastable() and v12:BuffDown(v72.BlackAttunementBuff)) then
			if (((1647 - (228 + 498)) <= (239 + 863)) and v22(v72.BlackAttunement)) then
				return "black_attunement precombat";
			end
		end
		if (((2600 + 2106) >= (1626 - (174 + 489))) and v72.BronzeAttunement:IsCastable() and v12:BuffDown(v72.BronzeAttunementBuff) and v12:BuffUp(v72.BlackAttunementBuff) and not v12:BuffUp(v72.BlackAttunementBuff, false)) then
			if (v22(v72.BronzeAttunement) or ((2501 - 1541) <= (2781 - (830 + 1075)))) then
				return "bronze_attunement precombat";
			end
		end
		if ((v35 == "Auto") or ((2590 - (303 + 221)) == (2201 - (231 + 1038)))) then
			if (((4021 + 804) < (6005 - (171 + 991))) and v72.BlisteringScales:IsCastable() and v16:IsInRange(102 - 77) and (v16:BuffStack(v72.BlisteringScalesBuff) <= v36) and (v89 == v16:GUID())) then
				if (v22(v74.BlisteringScalesFocus, nil, nil) or ((10410 - 6533) >= (11321 - 6784))) then
					return "blistering_scales precombat 2";
				end
			end
		end
		if ((v35 == "Selected") or ((3454 + 861) < (6050 - 4324))) then
			local v117 = 0 - 0;
			local v118;
			while true do
				if ((v117 == (0 - 0)) or ((11372 - 7693) < (1873 - (111 + 1137)))) then
					v118 = v76.NamedUnit(183 - (91 + 67), v37);
					if ((v72.BlisteringScales:IsCastable() and (v118:BuffStack(v72.BlisteringScalesBuff) <= v36)) or ((13765 - 9140) < (158 + 474))) then
						if (v22(v74.BlisteringScalesName, nil, nil) or ((606 - (423 + 100)) > (13 + 1767))) then
							return "blistering_scales precombat 2";
						end
					end
					break;
				end
			end
		end
		if (((1511 - 965) <= (562 + 515)) and v72.EbonMight:IsReady()) then
			if (v22(v72.EbonMight, nil) or ((1767 - (326 + 445)) > (18769 - 14468))) then
				return "ebon_might precombat 8";
			end
		end
		if (((9067 - 4997) > (1603 - 916)) and v72.LivingFlame:IsCastable()) then
			if (v22(v72.LivingFlame, nil, nil, not v15:IsSpellInRange(v72.LivingFlame)) or ((1367 - (530 + 181)) >= (4211 - (614 + 267)))) then
				return "living_flame precombat 10";
			end
		end
	end
	local function v92()
		if (not v16 or not v16:Exists() or not v16:IsInRange(62 - (19 + 13)) or not v76.DispellableFriendlyUnit() or ((4055 - 1563) <= (780 - 445))) then
			return;
		end
		if (((12346 - 8024) >= (666 + 1896)) and v72.Expunge:IsReady() and (v76.UnitHasPoisonDebuff(v16))) then
			if (v26(v74.ExpungeFocus) or ((6396 - 2759) >= (7818 - 4048))) then
				return "Expunge dispel";
			end
		end
		if ((v72.OppressingRoar:IsReady() and v61 and v76.UnitHasEnrageBuff(v15)) or ((4191 - (1293 + 519)) > (9340 - 4762))) then
			if (v26(v72.OppressingRoar) or ((1260 - 777) > (1420 - 677))) then
				return "Oppressing Roar dispel";
			end
		end
	end
	local function v93()
		if (((10581 - 8127) > (1361 - 783)) and v72.BlessingoftheBronze:IsCastable() and v53 and (v12:BuffDown(v72.BlessingoftheBronzeBuff, true) or v76.GroupBuffMissing(v72.BlessingoftheBronzeBuff))) then
			if (((493 + 437) < (910 + 3548)) and v22(v72.BlessingoftheBronze, nil)) then
				return "blessing_of_the_bronze precombat";
			end
		end
		if (((1537 - 875) <= (225 + 747)) and (v38 == "Auto")) then
			if (((1452 + 2918) == (2731 + 1639)) and v72.SourceofMagic:IsCastable() and v16:IsInRange(1121 - (709 + 387)) and (v87 == v16:GUID()) and (v16:BuffRemains(v72.SourceofMagicBuff) < (2158 - (673 + 1185)))) then
				if (v22(v74.SourceofMagicFocus) or ((13810 - 9048) <= (2764 - 1903))) then
					return "source_of_magic precombat";
				end
			end
		end
		if ((v38 == "Selected") or ((2322 - 910) == (3050 + 1214))) then
			local v119 = v76.NamedUnit(19 + 6, v39);
			if ((v119 and v72.SourceofMagic:IsCastable() and (v119:BuffRemains(v72.SourceofMagicBuff) < (405 - 105))) or ((779 + 2389) < (4292 - 2139))) then
				if (v22(v74.SourceofMagicName) or ((9767 - 4791) < (3212 - (446 + 1434)))) then
					return "source_of_magic precombat";
				end
			end
		end
		if (((5911 - (1040 + 243)) == (13812 - 9184)) and (v35 == "Auto")) then
			if ((v72.BlisteringScales:IsCastable() and v16:IsInRange(1872 - (559 + 1288)) and (v16:BuffStack(v72.BlisteringScalesBuff) <= v36) and (v89 == v16:GUID())) or ((1985 - (609 + 1322)) == (849 - (13 + 441)))) then
				if (((306 - 224) == (214 - 132)) and v22(v74.BlisteringScalesFocus, nil, nil)) then
					return "blistering_scales main 34";
				end
			end
		end
		if ((v35 == "Selected") or ((2893 - 2312) < (11 + 271))) then
			local v120 = 0 - 0;
			local v121;
			while true do
				if ((v120 == (0 + 0)) or ((2020 + 2589) < (7403 - 4908))) then
					v121 = v76.NamedUnit(14 + 11, v37);
					if (((2118 - 966) == (762 + 390)) and v72.BlisteringScales:IsCastable() and (v121:BuffStack(v72.BlisteringScalesBuff) <= v36)) then
						if (((1055 + 841) <= (2459 + 963)) and v22(v74.BlisteringScalesName, nil, nil)) then
							return "blistering_scales main 34";
						end
					end
					break;
				end
			end
		end
	end
	local function v94()
		if ((v45 == "Player Only") or ((832 + 158) > (1585 + 35))) then
			if ((v72.VerdantEmbrace:IsReady() and (v12:HealthPercentage() < v47)) or ((1310 - (153 + 280)) > (13557 - 8862))) then
				if (((2416 + 275) >= (731 + 1120)) and v22(v74.VerdantEmbracePlayer, nil)) then
					return "verdant_embrace main 40";
				end
			end
		end
		if ((v45 == "Everyone") or (v45 == "Not Tank") or ((1563 + 1422) >= (4407 + 449))) then
			if (((3099 + 1177) >= (1819 - 624)) and v72.VerdantEmbrace:IsReady() and (v16:HealthPercentage() < v47)) then
				if (((1998 + 1234) <= (5357 - (89 + 578))) and v22(v74.VerdantEmbraceFocus, nil)) then
					return "verdant_embrace main 40";
				end
			end
		end
		if ((v46 == "Player Only") or ((641 + 255) >= (6539 - 3393))) then
			if (((4110 - (572 + 477)) >= (399 + 2559)) and v72.EmeraldBlossom:IsReady() and (v12:HealthPercentage() < v48)) then
				if (((1913 + 1274) >= (77 + 567)) and v22(v74.EmeraldBlossomPlayer, nil)) then
					return "emerald_blossom main 42";
				end
			end
		end
		if (((730 - (84 + 2)) <= (1159 - 455)) and (v46 == "Everyone")) then
			if (((691 + 267) > (1789 - (497 + 345))) and v72.EmeraldBlossom:IsReady() and (v16:HealthPercentage() < v48)) then
				if (((115 + 4377) >= (449 + 2205)) and v22(v74.EmeraldBlossomFocus, nil)) then
					return "emerald_blossom main 42";
				end
			end
		end
	end
	local function v95()
		local v103 = 1333 - (605 + 728);
		local v104;
		while true do
			if (((2456 + 986) >= (3341 - 1838)) and (v103 == (1 + 5))) then
				if ((v32 and v68 and v72.TimeSkip:IsCastable() and ((v72.FireBreath:CooldownRemains() + v72.Upheaval:CooldownRemains() + v72.Prescience:CooldownRemains()) > (129 - 94))) or ((2858 + 312) <= (4056 - 2592))) then
					if (v67 or ((3622 + 1175) == (4877 - (457 + 32)))) then
						if (((234 + 317) <= (2083 - (832 + 570))) and v12:BuffUp(v72.HoverBuff)) then
							if (((3088 + 189) > (107 + 300)) and v22(v72.TimeSkip, nil)) then
								return "time_skip main 24";
							end
						elseif (((16614 - 11919) >= (682 + 733)) and v22(v72.Hover, nil)) then
							return "hover main 24";
						end
					elseif (v22(v72.TimeSkip, nil) or ((4008 - (588 + 208)) <= (2544 - 1600))) then
						return "time_skip main 24";
					end
				end
				if ((v72.FireBreath:IsCastable() and not v72.AncientFlame:IsAvailable() and (v12:BuffRemains(v72.EbonMightSelfBuff) > v12:EmpowerCastTime(1801 - (884 + 916)))) or ((6481 - 3385) <= (1043 + 755))) then
					local v147 = 653 - (232 + 421);
					while true do
						if (((5426 - (1569 + 320)) == (868 + 2669)) and (v147 == (0 + 0))) then
							v83 = 3 - 2;
							if (((4442 - (316 + 289)) >= (4109 - 2539)) and v23(v72.FireBreath, false, "1", not v15:IsInRange(2 + 23), nil)) then
								return "fire_breath empower 1 main 26";
							end
							break;
						end
					end
				end
				if ((v72.FireBreath:IsCastable() and v72.AncientFlame:IsAvailable() and (v12:BuffRemains(v72.EbonMightSelfBuff) > v12:EmpowerCastTime(v78))) or ((4403 - (666 + 787)) == (4237 - (360 + 65)))) then
					local v148 = 0 + 0;
					while true do
						if (((4977 - (79 + 175)) >= (3654 - 1336)) and (v148 == (0 + 0))) then
							v83 = v78;
							if (v23(v72.FireBreath, false, v78, not v15:IsInRange(76 - 51), nil) or ((3903 - 1876) > (3751 - (503 + 396)))) then
								return "fire_breath empower " .. v78 .. " main 28";
							end
							break;
						end
					end
				end
				v103 = 188 - (92 + 89);
			end
			if ((v103 == (5 - 2)) or ((583 + 553) > (2556 + 1761))) then
				if (((18593 - 13845) == (650 + 4098)) and v72.FireBreath:IsCastable() and (v12:BuffUp(v72.TipTheScales))) then
					v83 = 2 - 1;
					if (((3260 + 476) <= (2264 + 2476)) and v23(v72.FireBreath, false, "1", not v15:IsInRange(75 - 50), nil)) then
						return "fire_breath empower 1 main 12";
					end
				end
				if ((v72.Upheaval:IsCastable() and v72.TimeSkip:IsAvailable() and not v72.InterwovenThreads:IsAvailable() and (v72.TimeSkip:CooldownRemains() <= v12:EmpowerCastTime(1 + 0)) and (v12:BuffRemains(v72.EbonMightSelfBuff) > v12:EmpowerCastTime(1 - 0))) or ((4634 - (485 + 759)) <= (7080 - 4020))) then
					local v149 = 1189 - (442 + 747);
					while true do
						if ((v149 == (1135 - (832 + 303))) or ((1945 - (88 + 858)) > (821 + 1872))) then
							v82 = 1 + 0;
							if (((20 + 443) < (1390 - (766 + 23))) and v23(v72.Upheaval, false, "1", not v15:IsInRange(123 - 98), nil)) then
								return "upheaval emopwer 1 main 16";
							end
							break;
						end
					end
				end
				if ((v32 and v72.BreathofEons:IsCastable() and (v12:BuffUp(v72.EbonMightSelfBuff) or (v72.EbonMight:CooldownRemains() < (5 - 1)))) or ((5751 - 3568) < (2331 - 1644))) then
					if (((5622 - (1036 + 37)) == (3226 + 1323)) and (v66 == "@Cursor")) then
						if (((9097 - 4425) == (3676 + 996)) and v26(v74.BreathofEonsCursor, not v15:IsInRange(1510 - (641 + 839)))) then
							return "breath_of_eons main 18";
						end
					elseif ((v66 == "Confirmation") or ((4581 - (910 + 3)) < (1006 - 611))) then
						if (v22(v72.BreathofEons, nil, nil, not v15:IsInRange(1714 - (1466 + 218))) or ((1915 + 2251) == (1603 - (556 + 592)))) then
							return "breath_of_eons main 18";
						end
					end
				end
				v103 = 2 + 2;
			end
			if ((v103 == (810 - (329 + 479))) or ((5303 - (174 + 680)) == (9150 - 6487))) then
				if ((v32 and v72.TipTheScales:IsCastable() and (v72.FireBreath:CooldownRemains() < v12:GCD())) or ((8865 - 4588) < (2135 + 854))) then
					if (v22(v72.TipTheScales, nil) or ((1609 - (396 + 343)) >= (368 + 3781))) then
						return "tip_the_scales main 10";
					end
				end
				if (((3689 - (29 + 1448)) < (4572 - (135 + 1254))) and v72.FireBreath:IsCastable() and not v72.LeapingFlames:IsAvailable() and v72.TimeSkip:IsAvailable() and not v72.InterwovenThreads:IsAvailable() and (v72.TimeSkip:CooldownRemains() <= v12:EmpowerCastTime(3 - 2)) and (v12:BuffRemains(v72.EbonMightSelfBuff) > v12:EmpowerCastTime(4 - 3))) then
					local v150 = 0 + 0;
					while true do
						if (((6173 - (389 + 1138)) > (3566 - (102 + 472))) and ((0 + 0) == v150)) then
							v83 = 1 + 0;
							if (((1338 + 96) < (4651 - (320 + 1225))) and v23(v72.FireBreath, false, "1", not v15:IsInRange(44 - 19), nil)) then
								return "fire_breath empower 1 main 12";
							end
							break;
						end
					end
				end
				if (((481 + 305) < (4487 - (157 + 1307))) and v72.FireBreath:IsCastable() and v72.LeapingFlames:IsAvailable() and v72.TimeSkip:IsAvailable() and not v72.InterwovenThreads:IsAvailable() and (v72.TimeSkip:CooldownRemains() <= v12:EmpowerCastTime(v78)) and (v12:BuffRemains(v72.EbonMightSelfBuff) > v12:EmpowerCastTime(v78))) then
					local v151 = 1859 - (821 + 1038);
					while true do
						if ((v151 == (0 - 0)) or ((268 + 2174) < (131 - 57))) then
							v83 = v78;
							if (((1688 + 2847) == (11240 - 6705)) and v23(v72.FireBreath, false, v78, not v15:IsInRange(1051 - (834 + 192)), nil)) then
								return "fire_breath empower " .. v78 .. " main 14";
							end
							break;
						end
					end
				end
				v103 = 1 + 2;
			end
			if (((3 + 5) == v103) or ((65 + 2944) <= (3261 - 1156))) then
				if (((2134 - (300 + 4)) < (980 + 2689)) and v72.LivingFlame:IsCastable() and (not v12:IsMoving() or v72.PupilofAlexstrasza:IsAvailable())) then
					if (v22(v72.LivingFlame, nil, nil, not v15:IsSpellInRange(v72.LivingFlame)) or ((3743 - 2313) >= (3974 - (112 + 250)))) then
						return "living_flame main 42";
					end
				end
				if (((1070 + 1613) >= (6162 - 3702)) and v72.AzureStrike:IsCastable() and not v72.PupilofAlexstrasza:IsAvailable()) then
					if (v22(v72.AzureStrike, nil, nil, not v15:IsSpellInRange(v72.AzureStrike)) or ((1034 + 770) >= (1694 + 1581))) then
						return "azure_strike main 44";
					end
				end
				break;
			end
			if (((6 + 1) == v103) or ((703 + 714) > (2696 + 933))) then
				if (((6209 - (1001 + 413)) > (896 - 494)) and v72.Upheaval:IsCastable() and (v12:BuffRemains(v72.EbonMightSelfBuff) > v12:EmpowerCastTime(883 - (244 + 638)))) then
					local v152 = 694 - (627 + 66);
					if (((14340 - 9527) > (4167 - (512 + 90))) and (EnemiesCount8ySplash > (1907 - (1665 + 241))) and (EnemiesCount8ySplash < (721 - (373 + 344))) and (v12:BuffRemains(v72.EbonMightSelfBuff) > v12:EmpowerCastTime(1 + 1))) then
						v152 = 1 + 1;
					elseif (((10318 - 6406) == (6619 - 2707)) and (EnemiesCount8ySplash > (1102 - (35 + 1064))) and (EnemiesCount8ySplash < (5 + 1)) and (v12:BuffRemains(v72.EbonMightSelfBuff) > v12:EmpowerCastTime(6 - 3))) then
						v152 = 1 + 2;
					elseif (((4057 - (298 + 938)) <= (6083 - (233 + 1026))) and (EnemiesCount8ySplash > (1671 - (636 + 1030))) and (v12:BuffRemains(v72.EbonMightSelfBuff) > v12:EmpowerCastTime(v78))) then
						v152 = v78;
					end
					v82 = v152;
					if (((889 + 849) <= (2145 + 50)) and v23(v72.Upheaval, false, v152, not v15:IsInRange(8 + 17), nil)) then
						return "upheaval empower " .. v152 .. " main 30";
					end
				end
				if (((3 + 38) <= (3239 - (55 + 166))) and v72.DeepBreath:IsCastable() and not v72.BreathofEons:IsAvailable()) then
					if (((416 + 1729) <= (413 + 3691)) and v22(v72.DeepBreath, nil, nil, not v15:IsInRange(114 - 84))) then
						return "deep_breath main 32";
					end
				end
				if (((2986 - (36 + 261)) < (8472 - 3627)) and v72.Eruption:IsReady() and ((v12:BuffRemains(v72.EbonMightSelfBuff) > v72.Eruption:CastTime()) or (v12:EssenceTimeToMax() < v72.Eruption:CastTime()) or v12:BuffUp(v72.EssenceBurstBuff))) then
					if (v22(v72.Eruption, nil, nil, not v15:IsInRange(1393 - (34 + 1334))) or ((893 + 1429) > (2038 + 584))) then
						return "eruption main 36";
					end
				end
				v103 = 1291 - (1035 + 248);
			end
			if ((v103 == (25 - (20 + 1))) or ((2363 + 2171) == (2401 - (134 + 185)))) then
				if ((((v72.TemporalWoundDebuff:AuraActiveCount() > (1133 - (549 + 584))) or (v72.BreathofEons:CooldownRemains() > (715 - (314 + 371)))) and (v66 ~= "Manual")) or (v81 < (102 - 72)) or (v12:BuffUp(v72.EbonMightSelfBuff) and (v66 == "Manual")) or ((2539 - (478 + 490)) > (990 + 877))) then
					local v153 = 1172 - (786 + 386);
					while true do
						if ((v153 == (0 - 0)) or ((4033 - (1055 + 324)) >= (4336 - (1093 + 247)))) then
							ShouldReturn = v76.HandleTopTrinket(v75, v32, 36 + 4, nil);
							if (((419 + 3559) > (8353 - 6249)) and ShouldReturn) then
								return ShouldReturn;
							end
							v153 = 3 - 2;
						end
						if (((8522 - 5527) > (3872 - 2331)) and (v153 == (1 + 0))) then
							ShouldReturn = v76.HandleBottomTrinket(v75, v32, 154 - 114, nil);
							if (((11198 - 7949) > (719 + 234)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v104 = v76.HandleDPSPotion((v72.TemporalWoundDebuff:AuraActiveCount() > (0 - 0)) or (v72.BreathofEons:CooldownRemains() > (718 - (364 + 324))) or (v81 < (82 - 52)));
				if (v104 or ((7853 - 4580) > (1516 + 3057))) then
					return v104;
				end
				v103 = 20 - 15;
			end
			if ((v103 == (1 - 0)) or ((9569 - 6418) < (2552 - (1249 + 19)))) then
				if ((v72.RenewingBlaze:IsCastable() and (v12:HealthPercentage() < v63) and v62) or ((1670 + 180) == (5951 - 4422))) then
					if (((1907 - (686 + 400)) < (1666 + 457)) and v22(v72.RenewingBlaze, nil, nil)) then
						return "RenewingBlaze main 6";
					end
				end
				if (((1131 - (73 + 156)) < (11 + 2314)) and v72.ObsidianScales:IsCastable() and (v12:HealthPercentage() < v65) and v64 and v12:BuffDown(v72.ObsidianScales)) then
					if (((1669 - (721 + 90)) <= (34 + 2928)) and v22(v72.ObsidianScales, nil, nil)) then
						return "obsidianscales main 6";
					end
				end
				if ((v72.EbonMight:IsReady() and v12:BuffRefreshable(v72.EbonMightSelfBuff, 12 - 8)) or ((4416 - (224 + 246)) < (2086 - 798))) then
					if (v22(v72.EbonMight, nil) or ((5968 - 2726) == (103 + 464))) then
						return "ebon_might main 8";
					end
				end
				v103 = 1 + 1;
			end
			if ((v103 == (4 + 1)) or ((1683 - 836) >= (4202 - 2939))) then
				if ((v72.LivingFlame:IsReady() and v12:BuffUp(v72.LeapingFlamesBuff) and (v72.FireBreathDebuff:AuraActiveCount() > (513 - (203 + 310)))) or ((4246 - (1238 + 755)) == (130 + 1721))) then
					if (v22(v72.LivingFlame, nil, nil, not v15:IsSpellInRange(v72.LivingFlame)) or ((3621 - (709 + 825)) > (4370 - 1998))) then
						return "living_flame main 22";
					end
				end
				if (v72.Unravel:IsReady() or ((6474 - 2029) < (5013 - (196 + 668)))) then
					if (v22(v72.Unravel, nil, nil, not v15:IsSpellInRange(v72.Unravel)) or ((7177 - 5359) == (176 - 91))) then
						return "unravel main 2";
					end
				end
				if (((1463 - (171 + 662)) < (2220 - (4 + 89))) and v72.LivingFlame:IsReady() and (v9.CombatTime() < (v72.LivingFlame:CastTime() * (6 - 4)))) then
					if (v22(v72.LivingFlame, nil, nil, not v15:IsSpellInRange(v72.LivingFlame)) or ((706 + 1232) == (11042 - 8528))) then
						return "living_flame main 4";
					end
				end
				v103 = 3 + 3;
			end
			if (((5741 - (35 + 1451)) >= (1508 - (28 + 1425))) and (v103 == (1993 - (941 + 1052)))) then
				if (((2876 + 123) > (2670 - (822 + 692))) and (v55 or v54)) then
					local v154 = v92();
					if (((3355 - 1005) > (545 + 610)) and v154) then
						return v154;
					end
				end
				if (((4326 - (45 + 252)) <= (4802 + 51)) and v69) then
					if (((GetTime() - v29) > v70) or ((178 + 338) > (8357 - 4923))) then
						if (((4479 - (114 + 319)) >= (4353 - 1320)) and v72.Hover:IsReady()) then
							if (v26(v72.Hover) or ((3483 - 764) <= (923 + 524))) then
								return "hover main 2";
							end
						end
					end
				end
				if ((v33 and v12:AffectingCombat()) or ((6158 - 2024) < (8225 - 4299))) then
					local v155 = v94();
					if (v155 or ((2127 - (556 + 1407)) >= (3991 - (741 + 465)))) then
						return v155;
					end
				end
				v103 = 466 - (170 + 295);
			end
		end
	end
	local function v96()
		local v105 = 0 + 0;
		while true do
			if ((v105 == (6 + 0)) or ((1292 - 767) == (1749 + 360))) then
				v71 = EpicSettings.Settings['LandslideUsage'] or "";
				break;
			end
			if (((22 + 11) == (19 + 14)) and (v105 == (1234 - (957 + 273)))) then
				v59 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v60 = EpicSettings.Settings['InterruptThreshold'] or (0 + 0);
				v61 = EpicSettings.Settings['UseOppressingRoar'];
				v62 = EpicSettings.Settings['UseRenewingBlaze'];
				v63 = EpicSettings.Settings['RenewingBlazeHP'] or (0 + 0);
				v64 = EpicSettings.Settings['UseObsidianScales'];
				v105 = 19 - 14;
			end
			if (((8047 - 4993) <= (12263 - 8248)) and (v105 == (9 - 7))) then
				v47 = EpicSettings.Settings['VerdantEmbraceHP'] or (1780 - (389 + 1391));
				v48 = EpicSettings.Settings['EmeraldBlossomHP'] or (0 + 0);
				v49 = EpicSettings.Settings['UseRacials'];
				v50 = EpicSettings.Settings['UseHealingPotion'];
				v51 = EpicSettings.Settings['HealingPotionName'] or "";
				v52 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v105 = 6 - 3;
			end
			if (((2822 - (783 + 168)) < (11350 - 7968)) and (v105 == (0 + 0))) then
				v35 = EpicSettings.Settings['BlisteringScalesUsage'] or "";
				v36 = EpicSettings.Settings['BlisteringScalesRefresh'] or (311 - (309 + 2));
				v37 = EpicSettings.Settings['BlisteringScalesName'] or "0";
				v38 = EpicSettings.Settings['SourceOfMagicUsage'] or "";
				v39 = EpicSettings.Settings['SourceOfMagicName'] or "";
				v40 = EpicSettings.Settings['PrescienceUsage'] or "";
				v105 = 2 - 1;
			end
			if (((2505 - (1090 + 122)) <= (703 + 1463)) and ((16 - 11) == v105)) then
				v65 = EpicSettings.Settings['ObsidianScalesHP'] or (0 + 0);
				v66 = EpicSettings.Settings['BreathofEonsUsage'] or "";
				v67 = EpicSettings.Settings['UseHoverTimeSkip'];
				v68 = EpicSettings.Settings['UseTimeSkip'];
				v69 = EpicSettings.Settings['UseHover'];
				v70 = EpicSettings.Settings['HoverTime'] or (1118 - (628 + 490));
				v105 = 2 + 4;
			end
			if (((7 - 4) == v105) or ((11785 - 9206) < (897 - (431 + 343)))) then
				v53 = EpicSettings.Settings['UseBlessingOfTheBronze'];
				v54 = EpicSettings.Settings['DispelDebuffs'];
				v55 = EpicSettings.Settings['DispelBuffs'];
				v56 = EpicSettings.Settings['UseHealthstone'];
				v57 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
				v58 = EpicSettings.Settings['InterruptWithStun'];
				v105 = 11 - 7;
			end
			if ((v105 == (1 + 0)) or ((109 + 737) >= (4063 - (556 + 1139)))) then
				v41 = EpicSettings.Settings['PrescienceName1'] or "";
				v42 = EpicSettings.Settings['PrescienceName2'] or "";
				v43 = EpicSettings.Settings['PrescienceName3'] or "";
				v44 = EpicSettings.Settings['PrescienceName4'] or "";
				v45 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
				v46 = EpicSettings.Settings['EmeraldBlossomUsage'] or "";
				v105 = 17 - (6 + 9);
			end
		end
	end
	local function v97()
		v96();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['heal'];
		v34 = EpicSettings.Toggles['dispel'];
		if (v12:IsDeadOrGhost() or ((735 + 3277) <= (1721 + 1637))) then
			return;
		end
		if (((1663 - (28 + 141)) <= (1164 + 1841)) and v54 and v72.Expunge:IsReady() and v76.DispellableFriendlyUnit()) then
			local v122 = 0 - 0;
			local v123;
			local v124;
			while true do
				if ((v122 == (1 + 0)) or ((4428 - (486 + 831)) == (5553 - 3419))) then
					if (((8291 - 5936) == (446 + 1909)) and v124) then
						return v124 .. " for Dispelling";
					end
					break;
				end
				if ((v122 == (0 - 0)) or ((1851 - (668 + 595)) <= (389 + 43))) then
					v123 = v54;
					v124 = v76.FocusUnit(v123, v74, 7 + 23);
					v122 = 2 - 1;
				end
			end
		elseif (((5087 - (23 + 267)) >= (5839 - (1129 + 815))) and v88() and (v16:BuffRemains(v72.SourceofMagicBuff) < (687 - (371 + 16))) and (v38 == "Auto") and (v88():BuffRemains(v72.SourceofMagicBuff) < (2050 - (1326 + 424))) and v72.SourceofMagic:IsCastable()) then
			local v144 = 0 - 0;
			while true do
				if (((13071 - 9494) == (3695 - (88 + 30))) and (v144 == (772 - (720 + 51)))) then
					if (((8439 - 4645) > (5469 - (421 + 1355))) and ShouldReturn) then
						return ShouldReturn .. " for SoM";
					end
					break;
				end
				if ((v144 == (0 - 0)) or ((627 + 648) == (5183 - (286 + 797)))) then
					v87 = v88():GUID();
					ShouldReturn = v76.FocusSpecifiedUnit(v88(), 91 - 66);
					v144 = 1 - 0;
				end
			end
		elseif ((v90() and (v35 == "Auto") and (v90():BuffStack(v72.BlisteringScalesBuff) <= v36) and v72.BlisteringScales:IsCastable()) or ((2030 - (397 + 42)) >= (1119 + 2461))) then
			v89 = v90():GUID();
			ShouldReturn = v76.FocusSpecifiedUnit(v90(), 825 - (24 + 776));
			if (((1514 - 531) <= (2593 - (222 + 563))) and ShouldReturn) then
				return ShouldReturn .. " for Blistering";
			end
		elseif ((v33 and (v45 == "Everyone") and v72.VerdantEmbrace:IsReady()) or ((4737 - 2587) <= (862 + 335))) then
			ShouldReturn = v76.FocusUnit(false, nil, nil, nil);
			if (((3959 - (23 + 167)) >= (2971 - (690 + 1108))) and ShouldReturn) then
				return ShouldReturn .. " for Verdant Embrace";
			end
		elseif (((536 + 949) == (1225 + 260)) and v33 and (v46 == "Everyone") and v72.EmeraldBlossom:IsReady()) then
			local v168 = 848 - (40 + 808);
			while true do
				if (((0 + 0) == v168) or ((12676 - 9361) <= (2659 + 123))) then
					ShouldReturn = v76.FocusUnit(false, nil, nil, nil);
					if (ShouldReturn or ((464 + 412) >= (1626 + 1338))) then
						return ShouldReturn .. " for Emerald Blossom";
					end
					break;
				end
			end
		elseif ((v33 and (v45 == "Not Tank") and v72.VerdantEmbrace:IsReady()) or ((2803 - (47 + 524)) > (1621 + 876))) then
			local v169 = 0 - 0;
			local v170;
			local v171;
			while true do
				if ((v169 == (0 - 0)) or ((4812 - 2702) <= (2058 - (1165 + 561)))) then
					v170 = v76.GetFocusUnit(false, nil, "HEALER") or v12;
					v171 = v76.GetFocusUnit(false, nil, "DAMAGER") or v12;
					v169 = 1 + 0;
				end
				if (((11416 - 7730) > (1211 + 1961)) and (v169 == (480 - (341 + 138)))) then
					if ((v170:HealthPercentage() < v171:HealthPercentage()) or ((1208 + 3266) < (1692 - 872))) then
						ShouldReturn = v76.FocusUnit(false, nil, nil, "HEALER");
						if (((4605 - (89 + 237)) >= (9271 - 6389)) and ShouldReturn) then
							return ShouldReturn .. " for Healing Healer";
						end
					elseif ((v171:HealthPercentage() < v170:HealthPercentage()) or ((4271 - 2242) >= (4402 - (581 + 300)))) then
						ShouldReturn = v76.FocusUnit(false, nil, nil, "DAMAGER");
						if (ShouldReturn or ((3257 - (855 + 365)) >= (11025 - 6383))) then
							return ShouldReturn .. " for Healing Damager";
						end
					end
					break;
				end
			end
		end
		if (((562 + 1158) < (5693 - (1030 + 205))) and not v12:IsMoving()) then
			v29 = GetTime();
		end
		Enemies25y = v12:GetEnemiesInRange(24 + 1);
		Enemies8ySplash = v15:GetEnemiesInSplashRange(8 + 0);
		if (v31 or ((722 - (156 + 130)) > (6864 - 3843))) then
			EnemiesCount8ySplash = v15:GetEnemiesInSplashRangeCount(13 - 5);
		else
			EnemiesCount8ySplash = 1 - 0;
		end
		if (((188 + 525) <= (494 + 353)) and (v76.TargetIsValid() or v12:AffectingCombat())) then
			v80 = v9.BossFightRemains();
			v81 = v80;
			if (((2223 - (10 + 59)) <= (1141 + 2890)) and (v81 == (54719 - 43608))) then
				v81 = v9.FightRemains(Enemies25y, false);
			end
		end
		if (((5778 - (671 + 492)) == (3674 + 941)) and v33 and v30 and not v12:AffectingCombat()) then
			local v125 = v94();
			if (v125 or ((5005 - (369 + 846)) == (133 + 367))) then
				return v125;
			end
		end
		if (((76 + 13) < (2166 - (1036 + 909))) and v69 and (v30 or v12:AffectingCombat())) then
			if (((1634 + 420) >= (2385 - 964)) and ((GetTime() - v29) > v70)) then
				if (((895 - (11 + 192)) < (1546 + 1512)) and v72.Hover:IsReady() and v12:BuffDown(v72.Hover)) then
					if (v26(v72.Hover) or ((3429 - (135 + 40)) == (4009 - 2354))) then
						return "hover main 2";
					end
				end
			end
		end
		if (v30 or v12:AffectingCombat() or ((782 + 514) == (10816 - 5906))) then
			local v126 = 0 - 0;
			while true do
				if (((3544 - (50 + 126)) == (9378 - 6010)) and (v126 == (0 + 0))) then
					ShouldReturn = v93();
					if (((4056 - (1233 + 180)) < (4784 - (522 + 447))) and ShouldReturn) then
						return ShouldReturn;
					end
					break;
				end
			end
		end
		if (((3334 - (107 + 1314)) > (229 + 264)) and v76.TargetIsValid()) then
			local v127 = 0 - 0;
			while true do
				if (((2020 + 2735) > (6807 - 3379)) and (v127 == (11 - 8))) then
					if (((3291 - (716 + 1194)) <= (41 + 2328)) and v12:IsChanneling(v72.Upheaval)) then
						local v159 = 0 + 0;
						local v160;
						while true do
							if ((v159 == (503 - (74 + 429))) or ((9342 - 4499) == (2025 + 2059))) then
								v160 = GetTime() - v12:CastStart();
								if (((10687 - 6018) > (257 + 106)) and (v160 >= v12:EmpowerCastTime(v82))) then
									v9.EpicSettingsS = 3085 - 2084;
									return "Stopping Upheaval";
								end
								break;
							end
						end
					end
					if (v23(v72.Pool, false, "WAIT") or ((4640 - 2763) >= (3571 - (279 + 154)))) then
						return "Wait/Pool";
					end
					break;
				end
				if (((5520 - (454 + 324)) >= (2853 + 773)) and (v127 == (17 - (12 + 5)))) then
					if ((not v12:AffectingCombat() and not v12:IsCasting() and v30) or ((2448 + 2092) == (2333 - 1417))) then
						local v161 = 0 + 0;
						local v162;
						while true do
							if ((v161 == (1093 - (277 + 816))) or ((4939 - 3783) > (5528 - (1058 + 125)))) then
								v162 = v91();
								if (((420 + 1817) < (5224 - (815 + 160))) and v162) then
									return v162;
								end
								break;
							end
						end
					end
					if ((not v12:IsCasting() and not v12:IsChanneling()) or ((11511 - 8828) < (54 - 31))) then
						local v163 = v76.Interrupt(v72.Quell, 3 + 7, true);
						if (((2037 - 1340) <= (2724 - (41 + 1857))) and v163) then
							return v163;
						end
						v163 = v76.InterruptWithStun(v72.TailSwipe, 1901 - (1222 + 671));
						if (((2855 - 1750) <= (1689 - 513)) and v163) then
							return v163;
						end
						v163 = v76.Interrupt(v72.Quell, 1192 - (229 + 953), true, v13, v74.QuellMouseover);
						if (((5153 - (1111 + 663)) <= (5391 - (874 + 705))) and v163) then
							return v163;
						end
					end
					v127 = 1 + 0;
				end
				if ((v127 == (2 + 0)) or ((1637 - 849) >= (46 + 1570))) then
					if (((2533 - (642 + 37)) <= (771 + 2608)) and (v12:AffectingCombat() or v30)) then
						local v164 = v95();
						if (((728 + 3821) == (11421 - 6872)) and v164) then
							return v164;
						end
					end
					if (v12:IsChanneling(v72.FireBreath) or ((3476 - (233 + 221)) >= (6992 - 3968))) then
						local v165 = 0 + 0;
						local v166;
						while true do
							if (((6361 - (718 + 823)) > (1384 + 814)) and (v165 == (805 - (266 + 539)))) then
								v166 = GetTime() - v12:CastStart();
								if ((v166 >= v12:EmpowerCastTime(v83)) or ((3003 - 1942) >= (6116 - (636 + 589)))) then
									local v173 = 0 - 0;
									while true do
										if (((2813 - 1449) <= (3545 + 928)) and (v173 == (0 + 0))) then
											v9.EpicSettingsS = 2015 - (657 + 358);
											return "Stopping Fire Breath";
										end
									end
								end
								break;
							end
						end
					end
					v127 = 7 - 4;
				end
				if ((v127 == (2 - 1)) or ((4782 - (1151 + 36)) <= (3 + 0))) then
					if ((v73.Healthstone:IsReady() and v56 and (v12:HealthPercentage() <= v57)) or ((1229 + 3443) == (11503 - 7651))) then
						if (((3391 - (1552 + 280)) == (2393 - (64 + 770))) and v26(v74.Healthstone, nil, nil, true)) then
							return "healthstone defensive 3";
						end
					end
					if ((v50 and (v12:HealthPercentage() <= v52)) or ((1190 + 562) <= (1788 - 1000))) then
						if ((v51 == "Refreshing Healing Potion") or ((694 + 3213) == (1420 - (157 + 1086)))) then
							if (((6945 - 3475) > (2430 - 1875)) and v73.RefreshingHealingPotion:IsReady()) then
								if (v26(v74.RefreshingHealingPotion, nil, nil, true) or ((1490 - 518) == (879 - 234))) then
									return "refreshing healing potion defensive 4";
								end
							end
						end
					end
					v127 = 821 - (599 + 220);
				end
			end
		end
	end
	local function v98()
		v72.FireBreathDebuff:RegisterAuraTracking();
		v72.TemporalWoundDebuff:RegisterAuraTracking();
		v76.DispellableDebuffs = v76.DispellablePoisonDebuffs;
		v21.Print("Augmentation Evoker by Epic BoomK.");
		EpicSettings.SetupVersion("Augmentation Evoker X v 10.2.01 By BoomK");
	end
	v21.SetAPL(2932 - 1459, v97, v98);
end;
return v0["Epix_Evoker_Augmentation.lua"]();

