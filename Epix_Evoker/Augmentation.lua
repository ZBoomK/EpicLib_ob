local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 258 - (93 + 165);
	local v6;
	while true do
		if (((11686 - 6980) >= (995 - (19 + 13))) and (v5 == (1 - 0))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((2742 - 1782) <= (228 + 648))) then
			v6 = v0[v4];
			if (not v6 or ((3632 - 1566) == (1932 - 1000))) then
				return v1(v4, ...);
			end
			v5 = 1813 - (1293 + 519);
		end
	end
end
v0["Epix_Evoker_Augmentation.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.MouseOver;
	local v15 = v12.Pet;
	local v16 = v12.Target;
	local v17 = v12.Focus;
	local v18 = v10.Spell;
	local v19 = v10.MultiSpell;
	local v20 = v10.Item;
	local v21 = v10.Utils;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.CastAnnotated;
	local v25 = v22.CastPooling;
	local v26 = v22.Macro;
	local v27 = v22.Press;
	local v28 = v22.Commons.Everyone.num;
	local v29 = v22.Commons.Everyone.bool;
	local v30 = 0 - 0;
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
	local v75 = v18.Evoker.Augmentation;
	local v76 = v20.Evoker.Augmentation;
	local v77 = v26.Evoker.Augmentation;
	local v78 = {};
	local v79 = v22.Commons.Everyone;
	local v80 = {};
	local v81 = ((v75.FontofMagic:IsAvailable()) and (9 - 5)) or (5 - 2);
	local v82 = ((v75.FontofMagic:IsAvailable()) and (0.8 - 0)) or (2 - 1);
	local v83 = 5885 + 5226;
	local v84 = 2267 + 8844;
	local v85 = 2 - 1;
	local v86 = 1 + 0;
	local v87 = {{v75.TailSwipe,"Cast Tail Swipe (Interrupt)",function()
		return true;
	end},{v75.WingBuffet,"Cast Wing Buffet (Interrupt)",function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		v83 = 8303 + 2808;
		v84 = 15001 - 3890;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForEvent(function()
		local v102 = 0 + 0;
		while true do
			if (((9620 - 4795) < (9506 - 4663)) and ((1880 - (446 + 1434)) == v102)) then
				v81 = ((v75.FontofMagic:IsAvailable()) and (1287 - (1040 + 243))) or (8 - 5);
				v82 = ((v75.FontofMagic:IsAvailable()) and (1847.8 - (559 + 1288))) or (1932 - (609 + 1322));
				break;
			end
		end
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local v88;
	local function v89()
	end
	local v90;
	local function v91()
		local v103 = 454 - (13 + 441);
		local v104;
		local v105;
		while true do
			if ((v103 == (0 - 0)) or ((10155 - 6278) >= (22596 - 18059))) then
				v104 = nil;
				if (UnitInRaid("player") or ((161 + 4154) < (6268 - 4542))) then
					v104 = v12.Raid;
				elseif (UnitInParty("player") or ((1307 + 2372) < (274 + 351))) then
					v104 = v12.Party;
				else
					return false;
				end
				v103 = 2 - 1;
			end
			if ((v103 == (1 + 0)) or ((8505 - 3880) < (418 + 214))) then
				v105 = nil;
				for v140, v141 in pairs(v104) do
					if ((v141:Exists() and (UnitGroupRolesAssigned(v140) == "HEALER") and v141:IsInRange(14 + 11) and (v141:HealthPercentage() > (0 + 0))) or ((70 + 13) > (1742 + 38))) then
						local v169 = 433 - (153 + 280);
						while true do
							if (((1576 - 1030) <= (967 + 110)) and (v169 == (0 + 0))) then
								v105 = v141;
								v90 = v141:GUID();
								break;
							end
						end
					end
				end
				v103 = 2 + 0;
			end
			if (((2 + 0) == v103) or ((722 + 274) > (6548 - 2247))) then
				return v105;
			end
		end
	end
	local v92;
	local function v93()
		local v106 = 0 + 0;
		local v107;
		while true do
			if (((4737 - (89 + 578)) > (491 + 196)) and (v106 == (0 - 0))) then
				v107 = nil;
				if (UnitInRaid("player") or ((1705 - (572 + 477)) >= (450 + 2880))) then
					v107 = v12.Raid;
				elseif (UnitInParty("player") or ((1496 + 996) <= (40 + 295))) then
					v107 = v12.Party;
				else
					v107 = v13;
				end
				v106 = 87 - (84 + 2);
			end
			if (((7122 - 2800) >= (1846 + 716)) and (v106 == (843 - (497 + 345)))) then
				if ((v107 == v13) or ((94 + 3543) >= (638 + 3132))) then
					local v144 = 1333 - (605 + 728);
					while true do
						if ((v144 == (0 + 0)) or ((5288 - 2909) > (210 + 4368))) then
							v92 = v13:GUID();
							return v13;
						end
					end
				else
					for v170, v171 in pairs(v107) do
						if ((v171:Exists() and (v171:IsTankingAoE(29 - 21) or v171:IsTanking(v16)) and (UnitGroupRolesAssigned(v170) == "TANK") and v171:IsInRange(23 + 2) and (v171:HealthPercentage() > (0 - 0))) or ((365 + 118) > (1232 - (457 + 32)))) then
							local v175 = 0 + 0;
							while true do
								if (((3856 - (832 + 570)) > (545 + 33)) and (v175 == (0 + 0))) then
									v92 = v171:GUID();
									return v171;
								end
							end
						end
					end
				end
				return nil;
			end
		end
	end
	local function v94()
		local v108 = 0 - 0;
		while true do
			if (((448 + 482) < (5254 - (588 + 208))) and (v108 == (2 - 1))) then
				if (((2462 - (884 + 916)) <= (2034 - 1062)) and (v39 == "Selected")) then
					local v145 = v79.NamedUnit(15 + 10, v40);
					if (((5023 - (232 + 421)) == (6259 - (1569 + 320))) and v145 and v75.SourceofMagic:IsCastable() and (v145:BuffRemains(v75.SourceofMagicBuff) < (74 + 226))) then
						if (v23(v77.SourceofMagicName) or ((905 + 3857) <= (2901 - 2040))) then
							return "source_of_magic precombat";
						end
					end
				end
				if ((v75.BlackAttunement:IsCastable() and v13:BuffDown(v75.BlackAttunementBuff)) or ((2017 - (316 + 289)) == (11161 - 6897))) then
					if (v23(v75.BlackAttunement) or ((147 + 3021) < (3606 - (666 + 787)))) then
						return "black_attunement precombat";
					end
				end
				v108 = 427 - (360 + 65);
			end
			if ((v108 == (0 + 0)) or ((5230 - (79 + 175)) < (2099 - 767))) then
				if (((3612 + 1016) == (14185 - 9557)) and v75.BlessingoftheBronze:IsCastable() and v54 and (v13:BuffDown(v75.BlessingoftheBronzeBuff, true) or v79.GroupBuffMissing(v75.BlessingoftheBronzeBuff))) then
					if (v23(v75.BlessingoftheBronze, nil) or ((103 - 49) == (1294 - (503 + 396)))) then
						return "blessing_of_the_bronze precombat";
					end
				end
				if (((263 - (92 + 89)) == (158 - 76)) and (v39 == "Auto")) then
					if ((v75.SourceofMagic:IsCastable() and v17:IsInRange(13 + 12) and (v90 == v17:GUID()) and (v17:BuffRemains(v75.SourceofMagicBuff) < (178 + 122))) or ((2275 - 1694) < (39 + 243))) then
						if (v23(v77.SourceofMagicFocus) or ((10508 - 5899) < (2177 + 318))) then
							return "source_of_magic precombat";
						end
					end
				end
				v108 = 1 + 0;
			end
			if (((3508 - 2356) == (144 + 1008)) and (v108 == (5 - 1))) then
				if (((3140 - (485 + 759)) <= (7917 - 4495)) and v75.EbonMight:IsReady()) then
					if (v23(v75.EbonMight, nil) or ((2179 - (442 + 747)) > (2755 - (832 + 303)))) then
						return "ebon_might precombat 8";
					end
				end
				if (v75.LivingFlame:IsCastable() or ((1823 - (88 + 858)) > (1431 + 3264))) then
					if (((2228 + 463) >= (77 + 1774)) and v23(v75.LivingFlame, nil, nil, not v16:IsSpellInRange(v75.LivingFlame))) then
						return "living_flame precombat 10";
					end
				end
				break;
			end
			if ((v108 == (791 - (766 + 23))) or ((14736 - 11751) >= (6640 - 1784))) then
				if (((11265 - 6989) >= (4055 - 2860)) and v75.BronzeAttunement:IsCastable() and v13:BuffDown(v75.BronzeAttunementBuff) and v13:BuffUp(v75.BlackAttunementBuff) and not v13:BuffUp(v75.BlackAttunementBuff, false)) then
					if (((4305 - (1036 + 37)) <= (3326 + 1364)) and v23(v75.BronzeAttunement)) then
						return "bronze_attunement precombat";
					end
				end
				if ((v36 == "Auto") or ((1744 - 848) >= (2475 + 671))) then
					if (((4541 - (641 + 839)) >= (3871 - (910 + 3))) and v75.BlisteringScales:IsCastable() and v17:IsInRange(63 - 38) and (v17:BuffStack(v75.BlisteringScalesBuff) <= v37) and (v92 == v17:GUID())) then
						if (((4871 - (1466 + 218)) >= (296 + 348)) and v23(v77.BlisteringScalesFocus, nil, nil)) then
							return "blistering_scales precombat 2";
						end
					end
				end
				v108 = 1151 - (556 + 592);
			end
			if (((230 + 414) <= (1512 - (329 + 479))) and (v108 == (857 - (174 + 680)))) then
				if (((3291 - 2333) > (1962 - 1015)) and (v36 == "Selected")) then
					local v146 = v79.NamedUnit(18 + 7, v38);
					if (((5231 - (396 + 343)) >= (235 + 2419)) and v75.BlisteringScales:IsCastable() and (v146:BuffStack(v75.BlisteringScalesBuff) <= v37)) then
						if (((4919 - (29 + 1448)) >= (2892 - (135 + 1254))) and v23(v77.BlisteringScalesName, nil, nil)) then
							return "blistering_scales precombat 2";
						end
					end
				end
				if ((v33 and v75.TipTheScales:IsCastable()) or ((11942 - 8772) <= (6835 - 5371))) then
					if (v23(v75.TipTheScales, nil) or ((3197 + 1600) == (5915 - (389 + 1138)))) then
						return "tip_the_scales precombat 6";
					end
				end
				v108 = 578 - (102 + 472);
			end
		end
	end
	local function v95()
		local v109 = 0 + 0;
		while true do
			if (((306 + 245) <= (635 + 46)) and (v109 == (1546 - (320 + 1225)))) then
				if (((5833 - 2556) > (250 + 157)) and v75.OppressingRoar:IsReady() and v64 and v79.UnitHasEnrageBuff(v16)) then
					if (((6159 - (157 + 1307)) >= (3274 - (821 + 1038))) and v27(v75.OppressingRoar)) then
						return "Oppressing Roar dispel";
					end
				end
				break;
			end
			if ((v109 == (0 - 0)) or ((352 + 2860) <= (1676 - 732))) then
				if (not v17 or not v17:Exists() or not v17:IsInRange(12 + 18) or not v79.DispellableFriendlyUnit() or ((7673 - 4577) <= (2824 - (834 + 192)))) then
					return;
				end
				if (((225 + 3312) == (908 + 2629)) and v75.Expunge:IsReady() and (v79.UnitHasPoisonDebuff(v17))) then
					if (((83 + 3754) >= (2432 - 862)) and v27(v77.ExpungeFocus)) then
						return "Expunge dispel";
					end
				end
				v109 = 305 - (300 + 4);
			end
		end
	end
	local function v96()
		local v110 = 0 + 0;
		while true do
			if ((v110 == (5 - 3)) or ((3312 - (112 + 250)) == (1520 + 2292))) then
				if (((11831 - 7108) >= (1328 + 990)) and (v36 == "Selected")) then
					local v147 = v79.NamedUnit(13 + 12, v38);
					if ((v75.BlisteringScales:IsCastable() and (v147:BuffStack(v75.BlisteringScalesBuff) <= v37)) or ((1516 + 511) > (1415 + 1437))) then
						if (v23(v77.BlisteringScalesName, nil, nil) or ((844 + 292) > (5731 - (1001 + 413)))) then
							return "blistering_scales main 34";
						end
					end
				end
				break;
			end
			if (((10587 - 5839) == (5630 - (244 + 638))) and (v110 == (694 - (627 + 66)))) then
				if (((11131 - 7395) <= (5342 - (512 + 90))) and (v39 == "Selected")) then
					local v148 = 1906 - (1665 + 241);
					local v149;
					while true do
						if ((v148 == (717 - (373 + 344))) or ((1529 + 1861) <= (810 + 2250))) then
							v149 = v79.NamedUnit(65 - 40, v40);
							if ((v149 and v75.SourceofMagic:IsCastable() and (v149:BuffRemains(v75.SourceofMagicBuff) < (507 - 207))) or ((2098 - (35 + 1064)) > (1960 + 733))) then
								if (((990 - 527) < (3 + 598)) and v23(v77.SourceofMagicName)) then
									return "source_of_magic precombat";
								end
							end
							break;
						end
					end
				end
				if ((v36 == "Auto") or ((3419 - (298 + 938)) < (1946 - (233 + 1026)))) then
					if (((6215 - (636 + 1030)) == (2326 + 2223)) and v75.BlisteringScales:IsCastable() and v17:IsInRange(25 + 0) and (v17:BuffStack(v75.BlisteringScalesBuff) <= v37) and (v92 == v17:GUID())) then
						if (((1388 + 3284) == (316 + 4356)) and v23(v77.BlisteringScalesFocus, nil, nil)) then
							return "blistering_scales main 34";
						end
					end
				end
				v110 = 223 - (55 + 166);
			end
			if ((v110 == (0 + 0)) or ((369 + 3299) < (1508 - 1113))) then
				if ((v75.BlessingoftheBronze:IsCastable() and v54 and (v13:BuffDown(v75.BlessingoftheBronzeBuff, true) or v79.GroupBuffMissing(v75.BlessingoftheBronzeBuff))) or ((4463 - (36 + 261)) == (795 - 340))) then
					if (v23(v75.BlessingoftheBronze, nil) or ((5817 - (34 + 1334)) == (1024 + 1639))) then
						return "blessing_of_the_bronze precombat";
					end
				end
				if ((v39 == "Auto") or ((3324 + 953) < (4272 - (1035 + 248)))) then
					if ((v75.SourceofMagic:IsCastable() and v17:IsInRange(46 - (20 + 1)) and (v90 == v17:GUID()) and (v17:BuffRemains(v75.SourceofMagicBuff) < (157 + 143))) or ((1189 - (134 + 185)) >= (5282 - (549 + 584)))) then
						if (((2897 - (314 + 371)) < (10926 - 7743)) and v23(v77.SourceofMagicFocus)) then
							return "source_of_magic precombat";
						end
					end
				end
				v110 = 969 - (478 + 490);
			end
		end
	end
	local function v97()
		local v111 = 0 + 0;
		while true do
			if (((5818 - (786 + 386)) > (9690 - 6698)) and (v111 == (1380 - (1055 + 324)))) then
				if (((2774 - (1093 + 247)) < (2761 + 345)) and (v47 == "Player Only")) then
					if (((83 + 703) < (12001 - 8978)) and v75.EmeraldBlossom:IsReady() and (v13:HealthPercentage() < v49)) then
						if (v23(v77.EmeraldBlossomPlayer, nil) or ((8287 - 5845) < (210 - 136))) then
							return "emerald_blossom main 42";
						end
					end
				end
				if (((11396 - 6861) == (1614 + 2921)) and (v47 == "Everyone")) then
					if ((v75.EmeraldBlossom:IsReady() and (v17:HealthPercentage() < v49)) or ((11591 - 8582) <= (7255 - 5150))) then
						if (((1380 + 450) < (9382 - 5713)) and v23(v77.EmeraldBlossomFocus, nil)) then
							return "emerald_blossom main 42";
						end
					end
				end
				break;
			end
			if (((688 - (364 + 324)) == v111) or ((3920 - 2490) >= (8667 - 5055))) then
				if (((890 + 1793) >= (10293 - 7833)) and (v46 == "Player Only")) then
					if ((v75.VerdantEmbrace:IsReady() and (v13:HealthPercentage() < v48)) or ((2888 - 1084) >= (9946 - 6671))) then
						if (v23(v77.VerdantEmbracePlayer, nil) or ((2685 - (1249 + 19)) > (3276 + 353))) then
							return "verdant_embrace main 40";
						end
					end
				end
				if (((18664 - 13869) > (1488 - (686 + 400))) and ((v46 == "Everyone") or (v46 == "Not Tank"))) then
					if (((3777 + 1036) > (3794 - (73 + 156))) and v75.VerdantEmbrace:IsReady() and (v17:HealthPercentage() < v48)) then
						if (((19 + 3893) == (4723 - (721 + 90))) and v23(v77.VerdantEmbraceFocus, nil)) then
							return "verdant_embrace main 40";
						end
					end
				end
				v111 = 1 + 0;
			end
		end
	end
	local function v98()
		local v112 = 0 - 0;
		local v113;
		while true do
			if (((3291 - (224 + 246)) <= (7814 - 2990)) and (v112 == (5 - 2))) then
				if (((316 + 1422) <= (53 + 2142)) and v75.FireBreath:IsCastable() and not v75.LeapingFlames:IsAvailable() and v75.TimeSkip:IsAvailable() and not v75.InterwovenThreads:IsAvailable() and (v75.TimeSkip:CooldownRemains() <= v13:EmpowerCastTime(1 + 0)) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(1 - 0))) then
					v86 = 3 - 2;
					if (((554 - (203 + 310)) <= (5011 - (1238 + 755))) and v24(v75.FireBreath, false, "1", not v16:IsInRange(2 + 23), nil)) then
						return "fire_breath empower 1 main 12";
					end
				end
				if (((3679 - (709 + 825)) <= (7562 - 3458)) and v75.FireBreath:IsCastable() and v75.LeapingFlames:IsAvailable() and v75.TimeSkip:IsAvailable() and not v75.InterwovenThreads:IsAvailable() and (v75.TimeSkip:CooldownRemains() <= v13:EmpowerCastTime(v81)) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(v81))) then
					local v150 = 0 - 0;
					while true do
						if (((3553 - (196 + 668)) < (19129 - 14284)) and (v150 == (0 - 0))) then
							v86 = v81;
							if (v24(v75.FireBreath, false, v81, not v16:IsInRange(858 - (171 + 662)), nil) or ((2415 - (4 + 89)) > (9189 - 6567))) then
								return "fire_breath empower " .. v81 .. " main 14";
							end
							break;
						end
					end
				end
				if ((v75.Upheaval:IsCastable() and v75.TimeSkip:IsAvailable() and not v75.InterwovenThreads:IsAvailable() and (v75.TimeSkip:CooldownRemains() <= v13:EmpowerCastTime(1 + 0)) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(4 - 3))) or ((1779 + 2755) == (3568 - (35 + 1451)))) then
					local v151 = 1453 - (28 + 1425);
					while true do
						if ((v151 == (1993 - (941 + 1052))) or ((1507 + 64) > (3381 - (822 + 692)))) then
							v85 = 1 - 0;
							if (v24(v75.Upheaval, false, "1", not v16:IsInRange(12 + 13), nil) or ((2951 - (45 + 252)) >= (2965 + 31))) then
								return "upheaval emopwer 1 main 16";
							end
							break;
						end
					end
				end
				v112 = 2 + 2;
			end
			if (((9681 - 5703) > (2537 - (114 + 319))) and (v112 == (7 - 1))) then
				if (((3837 - 842) > (983 + 558)) and v75.LivingFlame:IsReady() and (v10.CombatTime() < (v75.LivingFlame:CastTime() * (2 - 0)))) then
					if (((6807 - 3558) > (2916 - (556 + 1407))) and v23(v75.LivingFlame, nil, nil, not v16:IsSpellInRange(v75.LivingFlame))) then
						return "living_flame main 4";
					end
				end
				if ((v33 and v71 and v75.TimeSkip:IsCastable() and ((v75.FireBreath:CooldownRemains() + v75.Upheaval:CooldownRemains() + v75.Prescience:CooldownRemains()) > (1241 - (741 + 465)))) or ((3738 - (170 + 295)) > (2410 + 2163))) then
					if (v70 or ((2895 + 256) < (3161 - 1877))) then
						if (v13:BuffUp(v75.HoverBuff) or ((1534 + 316) == (981 + 548))) then
							if (((465 + 356) < (3353 - (957 + 273))) and v23(v75.TimeSkip, nil)) then
								return "time_skip main 24";
							end
						elseif (((242 + 660) < (931 + 1394)) and v23(v75.Hover, nil)) then
							return "hover main 24";
						end
					elseif (((3269 - 2411) <= (7805 - 4843)) and v23(v75.TimeSkip, nil)) then
						return "time_skip main 24";
					end
				end
				if ((v75.FireBreath:IsCastable() and not v75.AncientFlame:IsAvailable() and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(2 - 1))) or ((19539 - 15593) < (3068 - (389 + 1391)))) then
					local v152 = 0 + 0;
					while true do
						if ((v152 == (0 + 0)) or ((7380 - 4138) == (1518 - (783 + 168)))) then
							v86 = 3 - 2;
							if (v24(v75.FireBreath, false, "1", not v16:IsInRange(25 + 0), nil) or ((1158 - (309 + 2)) >= (3878 - 2615))) then
								return "fire_breath empower 1 main 26";
							end
							break;
						end
					end
				end
				v112 = 1219 - (1090 + 122);
			end
			if ((v112 == (2 + 2)) or ((7566 - 5313) == (1267 + 584))) then
				if ((v33 and v75.BreathofEons:IsCastable() and (v13:BuffUp(v75.EbonMightSelfBuff) or (v75.EbonMight:CooldownRemains() < (1122 - (628 + 490))))) or ((375 + 1712) > (5872 - 3500))) then
					if ((v69 == "@Cursor") or ((20313 - 15868) < (4923 - (431 + 343)))) then
						if (v27(v77.BreathofEonsCursor, not v16:IsInRange(60 - 30)) or ((5259 - 3441) == (68 + 17))) then
							return "breath_of_eons main 18";
						end
					elseif (((81 + 549) < (3822 - (556 + 1139))) and (v69 == "Confirmation")) then
						if (v23(v75.BreathofEons, nil, nil, not v16:IsInRange(45 - (6 + 9))) or ((355 + 1583) == (1288 + 1226))) then
							return "breath_of_eons main 18";
						end
					end
				end
				if (((4424 - (28 + 141)) >= (22 + 33)) and ((((v75.TemporalWoundDebuff:AuraActiveCount() > (0 - 0)) or (v75.BreathofEons:CooldownRemains() > (22 + 8))) and (v69 ~= "Manual")) or (v84 < (1347 - (486 + 831))) or (v13:BuffUp(v75.EbonMightSelfBuff) and (v69 == "Manual")))) then
					ShouldReturn = v79.HandleTopTrinket(v78, v33, 104 - 64, nil);
					if (((10558 - 7559) > (219 + 937)) and ShouldReturn) then
						return ShouldReturn;
					end
					ShouldReturn = v79.HandleBottomTrinket(v78, v33, 126 - 86, nil);
					if (((3613 - (668 + 595)) > (1040 + 115)) and ShouldReturn) then
						return ShouldReturn;
					end
				end
				v113 = v79.HandleDPSPotion((v75.TemporalWoundDebuff:AuraActiveCount() > (0 + 0)) or (v75.BreathofEons:CooldownRemains() > (81 - 51)) or (v84 < (320 - (23 + 267))));
				v112 = 1949 - (1129 + 815);
			end
			if (((4416 - (371 + 16)) <= (6603 - (1326 + 424))) and (v112 == (14 - 6))) then
				if ((v75.Eruption:IsReady() and ((v13:BuffRemains(v75.EbonMightSelfBuff) > v75.Eruption:CastTime()) or (v13:EssenceTimeToMax() < v75.Eruption:CastTime()) or v13:BuffUp(v75.EssenceBurstBuff))) or ((1885 - 1369) > (3552 - (88 + 30)))) then
					if (((4817 - (720 + 51)) >= (6746 - 3713)) and v23(v75.Eruption, nil, nil, not v16:IsInRange(1801 - (421 + 1355)))) then
						return "eruption main 36";
					end
				end
				if ((v75.LivingFlame:IsCastable() and (not v13:IsMoving() or v75.PupilofAlexstrasza:IsAvailable())) or ((4485 - 1766) <= (711 + 736))) then
					if (v23(v75.LivingFlame, nil, nil, not v16:IsSpellInRange(v75.LivingFlame)) or ((5217 - (286 + 797)) < (14351 - 10425))) then
						return "living_flame main 42";
					end
				end
				if ((v75.AzureStrike:IsCastable() and not v75.PupilofAlexstrasza:IsAvailable()) or ((271 - 107) >= (3224 - (397 + 42)))) then
					if (v23(v75.AzureStrike, nil, nil, not v16:IsSpellInRange(v75.AzureStrike)) or ((164 + 361) == (2909 - (24 + 776)))) then
						return "azure_strike main 44";
					end
				end
				break;
			end
			if (((50 - 17) == (818 - (222 + 563))) and ((0 - 0) == v112)) then
				if (((2199 + 855) <= (4205 - (23 + 167))) and (v56 or v55)) then
					local v153 = 1798 - (690 + 1108);
					local v154;
					while true do
						if (((676 + 1195) < (2790 + 592)) and (v153 == (848 - (40 + 808)))) then
							v154 = v95();
							if (((213 + 1080) <= (8282 - 6116)) and v154) then
								return v154;
							end
							break;
						end
					end
				end
				if (v59 or ((2465 + 114) < (66 + 57))) then
					local v155 = 0 + 0;
					while true do
						if ((v155 == (571 - (47 + 524))) or ((550 + 296) >= (6472 - 4104))) then
							ShouldReturn = v79.HandleAfflicted(v75.Expunge, v77.ExpungeMouseover, 59 - 19);
							if (ShouldReturn or ((9149 - 5137) <= (5084 - (1165 + 561)))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (((45 + 1449) <= (9307 - 6302)) and v60) then
					local v156 = 0 + 0;
					while true do
						if ((v156 == (479 - (341 + 138))) or ((840 + 2271) == (4403 - 2269))) then
							ShouldReturn = v79.HandleIncorporeal(v75.Sleepwalk, v77.SleepwalkMouseover, 356 - (89 + 237), true);
							if (((7576 - 5221) == (4958 - 2603)) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v112 = 882 - (581 + 300);
			end
			if (((1222 - (855 + 365)) == v112) or ((1396 - 808) <= (142 + 290))) then
				if (((6032 - (1030 + 205)) >= (3657 + 238)) and v75.ObsidianScales:IsCastable() and (v13:HealthPercentage() < v68) and v67 and v13:BuffDown(v75.ObsidianScales)) then
					if (((3328 + 249) == (3863 - (156 + 130))) and v23(v75.ObsidianScales, nil, nil)) then
						return "obsidianscales main 6";
					end
				end
				if (((8620 - 4826) > (6224 - 2531)) and v75.EbonMight:IsReady() and v13:BuffRefreshable(v75.EbonMightSelfBuff, 7 - 3)) then
					if (v23(v75.EbonMight, nil) or ((336 + 939) == (2391 + 1709))) then
						return "ebon_might main 8";
					end
				end
				if ((v33 and v75.TipTheScales:IsCastable() and (v75.FireBreath:CooldownRemains() < v13:GCD())) or ((1660 - (10 + 59)) >= (1013 + 2567))) then
					if (((4841 - 3858) <= (2971 - (671 + 492))) and v23(v75.TipTheScales, nil)) then
						return "tip_the_scales main 10";
					end
				end
				v112 = 3 + 0;
			end
			if ((v112 == (1222 - (369 + 846))) or ((570 + 1580) <= (1022 + 175))) then
				if (((5714 - (1036 + 909)) >= (933 + 240)) and v75.FireBreath:IsCastable() and v75.AncientFlame:IsAvailable() and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(v81))) then
					local v157 = 0 - 0;
					while true do
						if (((1688 - (11 + 192)) == (751 + 734)) and (v157 == (175 - (135 + 40)))) then
							v86 = v81;
							if (v24(v75.FireBreath, false, v81, not v16:IsInRange(60 - 35), nil) or ((1999 + 1316) <= (6128 - 3346))) then
								return "fire_breath empower " .. v81 .. " main 28";
							end
							break;
						end
					end
				end
				if ((v75.Upheaval:IsCastable() and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(1 - 0))) or ((1052 - (50 + 126)) >= (8253 - 5289))) then
					local v158 = 0 + 0;
					local v159;
					while true do
						if ((v158 == (1413 - (1233 + 180))) or ((3201 - (522 + 447)) > (3918 - (107 + 1314)))) then
							v159 = 1 + 0;
							if (((EnemiesCount8ySplash > (2 - 1)) and (EnemiesCount8ySplash < (2 + 2)) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(3 - 1))) or ((8348 - 6238) <= (2242 - (716 + 1194)))) then
								v159 = 1 + 1;
							elseif (((395 + 3291) > (3675 - (74 + 429))) and (EnemiesCount8ySplash > (5 - 2)) and (EnemiesCount8ySplash < (3 + 3)) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(6 - 3))) then
								v159 = 3 + 0;
							elseif (((EnemiesCount8ySplash > (15 - 10)) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(v81))) or ((11061 - 6587) < (1253 - (279 + 154)))) then
								v159 = v81;
							end
							v158 = 779 - (454 + 324);
						end
						if (((3367 + 912) >= (2899 - (12 + 5))) and (v158 == (1 + 0))) then
							v85 = v159;
							if (v24(v75.Upheaval, false, v159, not v16:IsInRange(63 - 38), nil) or ((750 + 1279) >= (4614 - (277 + 816)))) then
								return "upheaval empower " .. v159 .. " main 30";
							end
							break;
						end
					end
				end
				if ((v75.DeepBreath:IsCastable() and not v75.BreathofEons:IsAvailable()) or ((8704 - 6667) >= (5825 - (1058 + 125)))) then
					if (((323 + 1397) < (5433 - (815 + 160))) and v23(v75.DeepBreath, nil, nil, not v16:IsInRange(128 - 98))) then
						return "deep_breath main 32";
					end
				end
				v112 = 18 - 10;
			end
			if ((v112 == (2 + 3)) or ((1274 - 838) > (4919 - (41 + 1857)))) then
				if (((2606 - (1222 + 671)) <= (2189 - 1342)) and v113) then
					return v113;
				end
				if (((3096 - 942) <= (5213 - (229 + 953))) and v75.LivingFlame:IsReady() and v13:BuffUp(v75.LeapingFlamesBuff) and (v75.FireBreathDebuff:AuraActiveCount() > (1774 - (1111 + 663)))) then
					if (((6194 - (874 + 705)) == (646 + 3969)) and v23(v75.LivingFlame, nil, nil, not v16:IsSpellInRange(v75.LivingFlame))) then
						return "living_flame main 22";
					end
				end
				if (v75.Unravel:IsReady() or ((2586 + 1204) == (1039 - 539))) then
					if (((3 + 86) < (900 - (642 + 37))) and v23(v75.Unravel, nil, nil, not v16:IsSpellInRange(v75.Unravel))) then
						return "unravel main 2";
					end
				end
				v112 = 2 + 4;
			end
			if (((329 + 1725) >= (3567 - 2146)) and (v112 == (455 - (233 + 221)))) then
				if (((1599 - 907) < (2692 + 366)) and v72) then
					if (((GetTime() - v30) > v73) or ((4795 - (718 + 823)) == (1042 + 613))) then
						if (v75.Hover:IsReady() or ((2101 - (266 + 539)) == (13901 - 8991))) then
							if (((4593 - (636 + 589)) == (7994 - 4626)) and v27(v75.Hover)) then
								return "hover main 2";
							end
						end
					end
				end
				if (((5450 - 2807) < (3024 + 791)) and v34 and v13:AffectingCombat()) then
					local v160 = 0 + 0;
					local v161;
					while true do
						if (((2928 - (657 + 358)) > (1305 - 812)) and (v160 == (0 - 0))) then
							v161 = v97();
							if (((5942 - (1151 + 36)) > (3311 + 117)) and v161) then
								return v161;
							end
							break;
						end
					end
				end
				if (((364 + 1017) <= (7074 - 4705)) and v75.RenewingBlaze:IsCastable() and (v13:HealthPercentage() < v66) and v65) then
					if (v23(v75.RenewingBlaze, nil, nil) or ((6675 - (1552 + 280)) == (4918 - (64 + 770)))) then
						return "RenewingBlaze main 6";
					end
				end
				v112 = 2 + 0;
			end
		end
	end
	local function v99()
		v36 = EpicSettings.Settings['BlisteringScalesUsage'] or "";
		v37 = EpicSettings.Settings['BlisteringScalesRefresh'] or (0 - 0);
		v38 = EpicSettings.Settings['BlisteringScalesName'] or "0";
		v39 = EpicSettings.Settings['SourceOfMagicUsage'] or "";
		v40 = EpicSettings.Settings['SourceOfMagicName'] or "";
		v41 = EpicSettings.Settings['PrescienceUsage'] or "";
		v42 = EpicSettings.Settings['PrescienceName1'] or "";
		v43 = EpicSettings.Settings['PrescienceName2'] or "";
		v44 = EpicSettings.Settings['PrescienceName3'] or "";
		v45 = EpicSettings.Settings['PrescienceName4'] or "";
		v46 = EpicSettings.Settings['VerdantEmbraceUsage'] or "";
		v47 = EpicSettings.Settings['EmeraldBlossomUsage'] or "";
		v48 = EpicSettings.Settings['VerdantEmbraceHP'] or (0 + 0);
		v49 = EpicSettings.Settings['EmeraldBlossomHP'] or (1243 - (157 + 1086));
		v50 = EpicSettings.Settings['UseRacials'];
		v51 = EpicSettings.Settings['UseHealingPotion'];
		v52 = EpicSettings.Settings['HealingPotionName'] or "";
		v53 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v54 = EpicSettings.Settings['UseBlessingOfTheBronze'];
		v55 = EpicSettings.Settings['DispelDebuffs'];
		v56 = EpicSettings.Settings['DispelBuffs'];
		v57 = EpicSettings.Settings['UseHealthstone'];
		v58 = EpicSettings.Settings['HealthstoneHP'] or (0 - 0);
		v59 = EpicSettings.Settings['HandleAfflicted'];
		v60 = EpicSettings.Settings['HandleIncorporeal'];
		v61 = EpicSettings.Settings['InterruptWithStun'];
		v62 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v63 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v64 = EpicSettings.Settings['UseOppressingRoar'];
		v65 = EpicSettings.Settings['UseRenewingBlaze'];
		v66 = EpicSettings.Settings['RenewingBlazeHP'] or (0 - 0);
		v67 = EpicSettings.Settings['UseObsidianScales'];
		v68 = EpicSettings.Settings['ObsidianScalesHP'] or (819 - (599 + 220));
		v69 = EpicSettings.Settings['BreathofEonsUsage'] or "";
		v70 = EpicSettings.Settings['UseHoverTimeSkip'];
		v71 = EpicSettings.Settings['UseTimeSkip'];
		v72 = EpicSettings.Settings['UseHover'];
		v73 = EpicSettings.Settings['HoverTime'] or (0 - 0);
		v74 = EpicSettings.Settings['LandslideUsage'] or "";
	end
	local function v100()
		local v130 = 1931 - (1813 + 118);
		while true do
			if (((3413 + 1256) > (1580 - (841 + 376))) and (v130 == (0 - 0))) then
				v99();
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v130 = 1 + 0;
			end
			if (((13 - 8) == v130) or ((2736 - (464 + 395)) >= (8053 - 4915))) then
				if (((2278 + 2464) >= (4463 - (467 + 370))) and (v31 or v13:AffectingCombat())) then
					local v162 = 0 - 0;
					while true do
						if ((v162 == (0 + 0)) or ((15563 - 11023) == (143 + 773))) then
							ShouldReturn = v96();
							if (ShouldReturn or ((2689 - 1533) > (4865 - (150 + 370)))) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (((3519 - (74 + 1208)) < (10450 - 6201)) and v79.TargetIsValid()) then
					local v163 = 0 - 0;
					while true do
						if ((v163 == (3 + 0)) or ((3073 - (14 + 376)) < (39 - 16))) then
							if (((452 + 245) <= (726 + 100)) and v13:IsChanneling(v75.Upheaval)) then
								local v177 = 0 + 0;
								local v178;
								while true do
									if (((3237 - 2132) <= (885 + 291)) and (v177 == (78 - (23 + 55)))) then
										v178 = GetTime() - v13:CastStart();
										if (((8007 - 4628) <= (2544 + 1268)) and (v178 >= v13:EmpowerCastTime(v85))) then
											local v188 = 0 + 0;
											while true do
												if ((v188 == (0 - 0)) or ((248 + 540) >= (2517 - (652 + 249)))) then
													v10.EpicSettingsS = 2678 - 1677;
													return "Stopping Upheaval";
												end
											end
										end
										break;
									end
								end
							end
							if (((3722 - (708 + 1160)) <= (9171 - 5792)) and v24(v75.Pool, false, "WAIT")) then
								return "Wait/Pool";
							end
							break;
						end
						if (((8293 - 3744) == (4576 - (10 + 17))) and ((1 + 0) == v163)) then
							if ((v76.Healthstone:IsReady() and v57 and (v13:HealthPercentage() <= v58)) or ((4754 - (1400 + 332)) >= (5799 - 2775))) then
								if (((6728 - (242 + 1666)) > (941 + 1257)) and v27(v77.Healthstone, nil, nil, true)) then
									return "healthstone defensive 3";
								end
							end
							if ((v51 and (v13:HealthPercentage() <= v53)) or ((389 + 672) >= (4169 + 722))) then
								if (((2304 - (850 + 90)) <= (7833 - 3360)) and (v52 == "Refreshing Healing Potion")) then
									if (v76.RefreshingHealingPotion:IsReady() or ((4985 - (360 + 1030)) <= (3 + 0))) then
										if (v27(v77.RefreshingHealingPotion, nil, nil, true) or ((13186 - 8514) == (5299 - 1447))) then
											return "refreshing healing potion defensive 4";
										end
									end
								end
							end
							v163 = 1663 - (909 + 752);
						end
						if (((2782 - (109 + 1114)) == (2853 - 1294)) and (v163 == (0 + 0))) then
							if ((not v13:AffectingCombat() and not v13:IsCasting() and v31) or ((1994 - (6 + 236)) <= (497 + 291))) then
								local v179 = 0 + 0;
								local v180;
								while true do
									if (((0 - 0) == v179) or ((6824 - 2917) == (1310 - (1076 + 57)))) then
										v180 = v94();
										if (((571 + 2899) > (1244 - (579 + 110))) and v180) then
											return v180;
										end
										break;
									end
								end
							end
							if ((not v13:IsCasting() and not v13:IsChanneling()) or ((77 + 895) == (571 + 74))) then
								local v181 = 0 + 0;
								local v182;
								while true do
									if (((3589 - (174 + 233)) >= (5907 - 3792)) and (v181 == (3 - 1))) then
										v182 = v79.Interrupt(v75.Quell, 5 + 5, true, v14, v77.QuellMouseover);
										if (((5067 - (663 + 511)) < (3952 + 477)) and v182) then
											return v182;
										end
										break;
									end
									if ((v181 == (1 + 0)) or ((8838 - 5971) < (1154 + 751))) then
										v182 = v79.InterruptWithStun(v75.TailSwipe, 18 - 10);
										if (v182 or ((4347 - 2551) >= (1934 + 2117))) then
											return v182;
										end
										v181 = 3 - 1;
									end
									if (((1154 + 465) <= (344 + 3412)) and (v181 == (722 - (478 + 244)))) then
										v182 = v79.Interrupt(v75.Quell, 527 - (440 + 77), true);
										if (((275 + 329) == (2210 - 1606)) and v182) then
											return v182;
										end
										v181 = 1557 - (655 + 901);
									end
								end
							end
							v163 = 1 + 0;
						end
						if ((v163 == (2 + 0)) or ((3028 + 1456) == (3625 - 2725))) then
							if (v13:AffectingCombat() or v31 or ((5904 - (695 + 750)) <= (3800 - 2687))) then
								local v183 = 0 - 0;
								local v184;
								while true do
									if (((14606 - 10974) > (3749 - (285 + 66))) and (v183 == (0 - 0))) then
										v184 = v98();
										if (((5392 - (682 + 628)) <= (793 + 4124)) and v184) then
											return v184;
										end
										break;
									end
								end
							end
							if (((5131 - (176 + 123)) >= (580 + 806)) and v13:IsChanneling(v75.FireBreath)) then
								local v185 = 0 + 0;
								local v186;
								while true do
									if (((406 - (239 + 30)) == (38 + 99)) and (v185 == (0 + 0))) then
										v186 = GetTime() - v13:CastStart();
										if ((v186 >= v13:EmpowerCastTime(v86)) or ((2778 - 1208) >= (13515 - 9183))) then
											v10.EpicSettingsS = 1315 - (306 + 9);
											return "Stopping Fire Breath";
										end
										break;
									end
								end
							end
							v163 = 10 - 7;
						end
					end
				end
				break;
			end
			if (((1 + 3) == v130) or ((2494 + 1570) <= (876 + 943))) then
				if (v79.TargetIsValid() or v13:AffectingCombat() or ((14257 - 9271) < (2949 - (1140 + 235)))) then
					local v164 = 0 + 0;
					while true do
						if (((4059 + 367) > (45 + 127)) and ((52 - (33 + 19)) == v164)) then
							v83 = v10.BossFightRemains();
							v84 = v83;
							v164 = 1 + 0;
						end
						if (((1756 - 1170) > (201 + 254)) and ((1 - 0) == v164)) then
							if (((775 + 51) == (1515 - (586 + 103))) and (v84 == (1012 + 10099))) then
								v84 = v10.FightRemains(Enemies25y, false);
							end
							break;
						end
					end
				end
				if ((v34 and v31 and not v13:AffectingCombat()) or ((12372 - 8353) > (5929 - (1309 + 179)))) then
					local v165 = v97();
					if (((3640 - 1623) < (1855 + 2406)) and v165) then
						return v165;
					end
				end
				if (((12665 - 7949) > (61 + 19)) and v72 and (v31 or v13:AffectingCombat())) then
					if (((GetTime() - v30) > v73) or ((7450 - 3943) == (6519 - 3247))) then
						if ((v75.Hover:IsReady() and v13:BuffDown(v75.Hover)) or ((1485 - (295 + 314)) >= (7552 - 4477))) then
							if (((6314 - (1300 + 662)) > (8019 - 5465)) and v27(v75.Hover)) then
								return "hover main 2";
							end
						end
					end
				end
				v130 = 1760 - (1178 + 577);
			end
			if (((2 + 0) == v130) or ((13024 - 8618) < (5448 - (851 + 554)))) then
				if (v13:IsDeadOrGhost() or ((1671 + 218) >= (9382 - 5999))) then
					return;
				end
				if (((4108 - 2216) <= (3036 - (115 + 187))) and v55 and v75.Expunge:IsReady() and v79.DispellableFriendlyUnit()) then
					local v166 = 0 + 0;
					local v167;
					local v168;
					while true do
						if (((1821 + 102) < (8740 - 6522)) and ((1161 - (160 + 1001)) == v166)) then
							v167 = v55;
							v168 = v79.FocusUnit(v167, v77, 27 + 3);
							v166 = 1 + 0;
						end
						if (((4448 - 2275) > (737 - (237 + 121))) and ((898 - (525 + 372)) == v166)) then
							if (v168 or ((4912 - 2321) == (11200 - 7791))) then
								return v168 .. " for Dispelling";
							end
							break;
						end
					end
				elseif (((4656 - (96 + 46)) > (4101 - (643 + 134))) and v91() and (v17:BuffRemains(v75.SourceofMagicBuff) < (109 + 191)) and (v39 == "Auto") and (v91():BuffRemains(v75.SourceofMagicBuff) < (719 - 419)) and v75.SourceofMagic:IsCastable()) then
					local v174 = 0 - 0;
					while true do
						if ((v174 == (1 + 0)) or ((407 - 199) >= (9868 - 5040))) then
							if (ShouldReturn or ((2302 - (316 + 403)) > (2371 + 1196))) then
								return ShouldReturn .. " for SoM";
							end
							break;
						end
						if ((v174 == (0 - 0)) or ((475 + 838) == (1999 - 1205))) then
							v90 = v91():GUID();
							ShouldReturn = v79.FocusSpecifiedUnit(v91(), 18 + 7);
							v174 = 1 + 0;
						end
					end
				elseif (((10997 - 7823) > (13859 - 10957)) and v93() and (v36 == "Auto") and (v93():BuffStack(v75.BlisteringScalesBuff) <= v37) and v75.BlisteringScales:IsCastable()) then
					local v176 = 0 - 0;
					while true do
						if (((236 + 3884) <= (8386 - 4126)) and (v176 == (1 + 0))) then
							if (ShouldReturn or ((2597 - 1714) > (4795 - (12 + 5)))) then
								return ShouldReturn .. " for Blistering";
							end
							break;
						end
						if ((v176 == (0 - 0)) or ((7723 - 4103) >= (10396 - 5505))) then
							v92 = v93():GUID();
							ShouldReturn = v79.FocusSpecifiedUnit(v93(), 61 - 36);
							v176 = 1 + 0;
						end
					end
				elseif (((6231 - (1656 + 317)) > (835 + 102)) and v34 and (v46 == "Everyone") and v75.VerdantEmbrace:IsReady()) then
					local v187 = 0 + 0;
					while true do
						if ((v187 == (0 - 0)) or ((23962 - 19093) < (1260 - (5 + 349)))) then
							ShouldReturn = v79.FocusUnit(false, nil, nil, nil);
							if (ShouldReturn or ((5818 - 4593) > (5499 - (266 + 1005)))) then
								return ShouldReturn .. " for Verdant Embrace";
							end
							break;
						end
					end
				elseif (((2194 + 1134) > (7636 - 5398)) and v34 and (v47 == "Everyone") and v75.EmeraldBlossom:IsReady()) then
					ShouldReturn = v79.FocusUnit(false, nil, nil, nil);
					if (((5053 - 1214) > (3101 - (561 + 1135))) and ShouldReturn) then
						return ShouldReturn .. " for Emerald Blossom";
					end
				elseif ((v34 and (v46 == "Not Tank") and v75.VerdantEmbrace:IsReady()) or ((1684 - 391) <= (1666 - 1159))) then
					local v190 = 1066 - (507 + 559);
					local v191;
					local v192;
					while true do
						if (((2 - 1) == v190) or ((8956 - 6060) < (1193 - (212 + 176)))) then
							if (((3221 - (250 + 655)) == (6315 - 3999)) and (v191:HealthPercentage() < v192:HealthPercentage())) then
								ShouldReturn = v79.FocusUnit(false, nil, nil, "HEALER");
								if (ShouldReturn or ((4490 - 1920) == (2398 - 865))) then
									return ShouldReturn .. " for Healing Healer";
								end
							elseif ((v192:HealthPercentage() < v191:HealthPercentage()) or ((2839 - (1869 + 87)) == (5063 - 3603))) then
								local v194 = 1901 - (484 + 1417);
								while true do
									if ((v194 == (0 - 0)) or ((7740 - 3121) <= (1772 - (48 + 725)))) then
										ShouldReturn = v79.FocusUnit(false, nil, nil, "DAMAGER");
										if (ShouldReturn or ((5570 - 2160) > (11042 - 6926))) then
											return ShouldReturn .. " for Healing Damager";
										end
										break;
									end
								end
							end
							break;
						end
						if ((v190 == (0 + 0)) or ((2413 - 1510) >= (857 + 2202))) then
							v191 = v79.GetFocusUnit(false, nil, "HEALER") or v13;
							v192 = v79.GetFocusUnit(false, nil, "DAMAGER") or v13;
							v190 = 1 + 0;
						end
					end
				end
				if (not v13:IsMoving() or ((4829 - (152 + 701)) < (4168 - (430 + 881)))) then
					v30 = GetTime();
				end
				v130 = 2 + 1;
			end
			if (((5825 - (557 + 338)) > (682 + 1625)) and (v130 == (2 - 1))) then
				v33 = EpicSettings.Toggles['cds'];
				v34 = EpicSettings.Toggles['heal'];
				v35 = EpicSettings.Toggles['dispel'];
				v130 = 6 - 4;
			end
			if (((7 - 4) == v130) or ((8719 - 4673) < (2092 - (499 + 302)))) then
				Enemies25y = v13:GetEnemiesInRange(891 - (39 + 827));
				Enemies8ySplash = v16:GetEnemiesInSplashRange(21 - 13);
				if (v32 or ((9471 - 5230) == (14080 - 10535))) then
					EnemiesCount8ySplash = v16:GetEnemiesInSplashRangeCount(11 - 3);
				else
					EnemiesCount8ySplash = 1 + 0;
				end
				v130 = 11 - 7;
			end
		end
	end
	local function v101()
		local v131 = 0 + 0;
		while true do
			if ((v131 == (1 - 0)) or ((4152 - (103 + 1)) > (4786 - (475 + 79)))) then
				v79.DispellableDebuffs = v79.DispellablePoisonDebuffs;
				v22.Print("Augmentation Evoker by Epic BoomK.");
				v131 = 4 - 2;
			end
			if ((v131 == (6 - 4)) or ((227 + 1523) >= (3057 + 416))) then
				EpicSettings.SetupVersion("Augmentation Evoker X v 10.2.00 By BoomK");
				break;
			end
			if (((4669 - (1395 + 108)) == (9212 - 6046)) and (v131 == (1204 - (7 + 1197)))) then
				v75.FireBreathDebuff:RegisterAuraTracking();
				v75.TemporalWoundDebuff:RegisterAuraTracking();
				v131 = 1 + 0;
			end
		end
	end
	v22.SetAPL(514 + 959, v100, v101);
end;
return v0["Epix_Evoker_Augmentation.lua"]();

