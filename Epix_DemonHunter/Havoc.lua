local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((224 + 4619) >= (4579 - (666 + 787))) and (v5 == (425 - (360 + 65)))) then
			v6 = v0[v4];
			if (not v6 or ((2044 + 143) >= (5208 - (79 + 175)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if (((1 + 0) == v5) or ((11884 - 8007) == (6884 - 3309))) then
			return v6(...);
		end
	end
end
v0["Epix_DemonHunter_Havoc.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.MouseOver;
	local v17 = v12.Pet;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Press;
	local v22 = v20.Macro;
	local v23 = v20.Commons.Everyone;
	local v24 = v23.num;
	local v25 = v23.bool;
	local v26 = math.min;
	local v27 = math.max;
	local v28;
	local v29 = false;
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
	local v79 = v18.DemonHunter.Havoc;
	local v80 = v19.DemonHunter.Havoc;
	local v81 = v22.DemonHunter.Havoc;
	local v82 = {};
	local v83, v84;
	local v85, v86;
	local v87 = {{v79.FelEruption},{v79.ChaosNova}};
	local v88 = false;
	local v89 = false;
	local v90 = 0 + 0;
	local v91 = 0 - 0;
	local v92 = v14:GCD() + 0.25 + 0;
	local v93 = 25334 - 14223;
	local v94 = 9695 + 1416;
	local v95 = {(516000 - 346579),(258375 - 88950),(390888 - 221956),(170561 - (832 + 303)),(51639 + 117790),(6979 + 162449),(836431 - 667001)};
	v10:RegisterForEvent(function()
		local v109 = 0 - 0;
		while true do
			if (((1862 - 1155) > (2144 - 1512)) and (v109 == (1073 - (1036 + 37)))) then
				v88 = false;
				v93 = 7878 + 3233;
				v109 = 1 - 0;
			end
			if ((v109 == (1 + 0)) or ((2026 - (641 + 839)) >= (3597 - (910 + 3)))) then
				v94 = 28325 - 17214;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v96()
		local v110 = 1684 - (1466 + 218);
		while true do
			if (((674 + 791) <= (5449 - (556 + 592))) and (v110 == (0 + 0))) then
				v28 = v23.HandleTopTrinket(v82, v31, 848 - (329 + 479), nil);
				if (((2558 - (174 + 680)) > (4896 - 3471)) and v28) then
					return v28;
				end
				v110 = 1 - 0;
			end
			if ((v110 == (1 + 0)) or ((1426 - (396 + 343)) == (375 + 3859))) then
				v28 = v23.HandleBottomTrinket(v82, v31, 1517 - (29 + 1448), nil);
				if (v28 or ((4719 - (135 + 1254)) < (5383 - 3954))) then
					return v28;
				end
				break;
			end
		end
	end
	local function v97()
		local v111 = 0 - 0;
		while true do
			if (((765 + 382) >= (1862 - (389 + 1138))) and (v111 == (574 - (102 + 472)))) then
				if (((3242 + 193) > (1163 + 934)) and v79.Blur:IsCastable() and v61 and (v14:HealthPercentage() <= v63)) then
					if (v21(v79.Blur) or ((3516 + 254) >= (5586 - (320 + 1225)))) then
						return "blur defensive";
					end
				end
				if ((v79.Netherwalk:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) or ((6748 - 2957) <= (986 + 625))) then
					if (v21(v79.Netherwalk) or ((6042 - (157 + 1307)) <= (3867 - (821 + 1038)))) then
						return "netherwalk defensive";
					end
				end
				v111 = 2 - 1;
			end
			if (((124 + 1001) <= (3686 - 1610)) and (v111 == (1 + 0))) then
				if ((v80.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v76)) or ((1841 - 1098) >= (5425 - (834 + 192)))) then
					if (((74 + 1081) < (430 + 1243)) and v21(v81.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v73 and (v14:HealthPercentage() <= v75)) or ((50 + 2274) <= (895 - 317))) then
					local v165 = 304 - (300 + 4);
					while true do
						if (((1007 + 2760) == (9860 - 6093)) and (v165 == (362 - (112 + 250)))) then
							if (((1631 + 2458) == (10243 - 6154)) and (v77 == "Refreshing Healing Potion")) then
								if (((2554 + 1904) >= (866 + 808)) and v80.RefreshingHealingPotion:IsReady()) then
									if (((727 + 245) <= (704 + 714)) and v21(v81.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v77 == "Dreamwalker's Healing Potion") or ((3669 + 1269) < (6176 - (1001 + 413)))) then
								if (v80.DreamwalkersHealingPotion:IsReady() or ((5583 - 3079) > (5146 - (244 + 638)))) then
									if (((2846 - (627 + 66)) == (6414 - 4261)) and v21(v81.RefreshingHealingPotion)) then
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
		end
	end
	local function v98()
		if ((v79.ImmolationAura:IsCastable() and v45) or ((1109 - (512 + 90)) >= (4497 - (1665 + 241)))) then
			if (((5198 - (373 + 344)) == (2022 + 2459)) and v21(v79.ImmolationAura, not v15:IsInRange(3 + 5))) then
				return "immolation_aura precombat 8";
			end
		end
		if ((v46 and not v14:IsMoving() and (v85 > (2 - 1)) and v79.SigilOfFlame:IsCastable()) or ((3939 - 1611) < (1792 - (35 + 1064)))) then
			if (((3150 + 1178) == (9259 - 4931)) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
				if (((7 + 1581) >= (2568 - (298 + 938))) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1267 - (233 + 1026)))) then
					return "sigil_of_flame precombat 9";
				end
			elseif ((v78 == "cursor") or ((5840 - (636 + 1030)) > (2172 + 2076))) then
				if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(40 + 0)) or ((1363 + 3223) <= (6 + 76))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if (((4084 - (55 + 166)) == (749 + 3114)) and not v15:IsInMeleeRange(1 + 4) and v79.Felblade:IsCastable() and v42) then
			if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((1076 - 794) <= (339 - (36 + 261)))) then
				return "felblade precombat 9";
			end
		end
		if (((8059 - 3450) >= (2134 - (34 + 1334))) and not v15:IsInMeleeRange(2 + 3) and v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat)) then
			if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((2435 - (1035 + 248)) == (2509 - (20 + 1)))) then
				return "throw_glaive precombat 9";
			end
		end
		if (((1783 + 1639) > (3669 - (134 + 185))) and not v15:IsInMeleeRange(1138 - (549 + 584)) and v79.FelRush:IsCastable() and (not v79.Felblade:IsAvailable() or (v79.Felblade:CooldownUp() and not v14:PrevGCDP(686 - (314 + 371), v79.Felblade))) and v32 and v43) then
			if (((3010 - 2133) > (1344 - (478 + 490))) and v21(v79.FelRush, not v15:IsInRange(8 + 7))) then
				return "fel_rush precombat 10";
			end
		end
		if ((v15:IsInMeleeRange(1177 - (786 + 386)) and v38 and (v79.DemonsBite:IsCastable() or v79.DemonBlades:IsAvailable())) or ((10099 - 6981) <= (3230 - (1055 + 324)))) then
			if (v21(v79.DemonsBite, not v15:IsInMeleeRange(1345 - (1093 + 247))) or ((147 + 18) >= (368 + 3124))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v99()
		local v112 = 0 - 0;
		local v113;
		while true do
			if (((13401 - 9452) < (13817 - 8961)) and ((2 - 1) == v112)) then
				if (v113 or ((1522 + 2754) < (11618 - 8602))) then
					return v113;
				end
				if (((16165 - 11475) > (3111 + 1014)) and (v70 < v94)) then
					if ((v71 and ((v31 and v72) or not v72)) or ((127 - 77) >= (1584 - (364 + 324)))) then
						local v174 = 0 - 0;
						while true do
							if ((v174 == (0 - 0)) or ((569 + 1145) >= (12377 - 9419))) then
								v28 = v96();
								if (v28 or ((2387 - 896) < (1955 - 1311))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				v112 = 1270 - (1249 + 19);
			end
			if (((636 + 68) < (3841 - 2854)) and (v112 == (1086 - (686 + 400)))) then
				if (((2918 + 800) > (2135 - (73 + 156))) and ((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and (((not v79.Demonic:IsAvailable() or (v14:BuffRemains(v79.MetamorphosisBuff) < v14:GCD())) and (v79.EyeBeam:CooldownRemains() > (0 + 0)) and (not v79.EssenceBreak:IsAvailable() or v15:DebuffUp(v79.EssenceBreakDebuff)) and v14:BuffDown(v79.FelBarrageBuff)) or not v79.ChaoticTransformation:IsAvailable() or (v94 < (841 - (721 + 90))))) then
					if (v21(v81.MetamorphosisPlayer, not v15:IsInRange(1 + 7)) or ((3110 - 2152) > (4105 - (224 + 246)))) then
						return "metamorphosis cooldown 2";
					end
				end
				v113 = v23.HandleDPSPotion(v14:BuffUp(v79.MetamorphosisBuff));
				v112 = 1 - 0;
			end
			if (((6446 - 2945) <= (815 + 3677)) and (v112 == (1 + 1))) then
				if ((((v31 and v58) or not v58) and v32 and v79.TheHunt:IsCastable() and v55 and v15:DebuffDown(v79.EssenceBreakDebuff) and (v10.CombatTime() > (4 + 1))) or ((6842 - 3400) < (8479 - 5931))) then
					if (((3388 - (203 + 310)) >= (3457 - (1238 + 755))) and v21(v79.TheHunt, not v15:IsInRange(3 + 37))) then
						return "the_hunt cooldown 4";
					end
				end
				if ((v53 and not v14:IsMoving() and ((v31 and v56) or not v56) and v79.ElysianDecree:IsCastable() and (v15:DebuffDown(v79.EssenceBreakDebuff)) and (v85 > v60)) or ((6331 - (709 + 825)) >= (9015 - 4122))) then
					if ((v59 == "player") or ((802 - 251) > (2932 - (196 + 668)))) then
						if (((8346 - 6232) > (1955 - 1011)) and v21(v81.ElysianDecreePlayer, not v15:IsInRange(841 - (171 + 662)))) then
							return "elysian_decree cooldown 6 (Player)";
						end
					elseif ((v59 == "cursor") or ((2355 - (4 + 89)) >= (10851 - 7755))) then
						if (v21(v81.ElysianDecreeCursor, not v15:IsInRange(11 + 19)) or ((9904 - 7649) >= (1388 + 2149))) then
							return "elysian_decree cooldown 6 (Cursor)";
						end
					end
				end
				break;
			end
		end
	end
	local function v100()
		local v114 = 1486 - (35 + 1451);
		while true do
			if (((1453 - (28 + 1425)) == v114) or ((5830 - (941 + 1052)) < (1253 + 53))) then
				if (((4464 - (822 + 692)) == (4211 - 1261)) and v79.VengefulRetreat:IsCastable() and v48 and v32 and v14:PrevGCDP(1 + 0, v79.DeathSweep) and (v79.Felblade:CooldownRemains() == (297 - (45 + 252)))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(8 + 0), true, true) or ((1626 + 3097) < (8026 - 4728))) then
						return "vengeful_retreat opener 1";
					end
				end
				if (((1569 - (114 + 319)) >= (220 - 66)) and v79.Metamorphosis:IsCastable() and v54 and ((v31 and v57) or not v57) and (v14:PrevGCDP(1 - 0, v79.DeathSweep) or (not v79.ChaoticTransformation:IsAvailable() and (not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (2 + 0)))) or not v79.Demonic:IsAvailable())) then
					if (v21(v81.MetamorphosisPlayer, not v15:IsInRange(11 - 3)) or ((567 - 296) > (6711 - (556 + 1407)))) then
						return "metamorphosis opener 2";
					end
				end
				if (((5946 - (741 + 465)) >= (3617 - (170 + 295))) and v79.Felblade:IsCastable() and v42 and v15:DebuffDown(v79.EssenceBreakDebuff)) then
					if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((1359 + 1219) >= (3114 + 276))) then
						return "felblade opener 3";
					end
				end
				if (((100 - 59) <= (1377 + 284)) and v79.ImmolationAura:IsCastable() and v45 and (v79.ImmolationAura:Charges() == (2 + 0)) and v14:BuffDown(v79.UnboundChaosBuff) and (v14:BuffDown(v79.InertiaBuff) or (v85 > (2 + 0)))) then
					if (((1831 - (957 + 273)) < (953 + 2607)) and v21(v79.ImmolationAura, not v15:IsInRange(4 + 4))) then
						return "immolation_aura opener 4";
					end
				end
				v114 = 3 - 2;
			end
			if (((619 - 384) < (2098 - 1411)) and (v114 == (4 - 3))) then
				if (((6329 - (389 + 1391)) > (724 + 429)) and v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (not v79.ChaoticTransformation:IsAvailable() or v79.Metamorphosis:CooldownUp())) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(1 + 4)) or ((10640 - 5966) < (5623 - (783 + 168)))) then
						return "annihilation opener 5";
					end
				end
				if (((12310 - 8642) < (4487 + 74)) and v79.EyeBeam:IsCastable() and v40 and v15:DebuffDown(v79.EssenceBreakDebuff) and v14:BuffDown(v79.InnerDemonBuff) and (not v14:BuffUp(v79.MetamorphosisBuff) or (v79.BladeDance:CooldownRemains() > (311 - (309 + 2))))) then
					if (v21(v79.EyeBeam, not v15:IsInRange(24 - 16)) or ((1667 - (1090 + 122)) == (1169 + 2436))) then
						return "eye_beam opener 6";
					end
				end
				if ((v79.FelRush:IsReady() and v43 and v32 and v79.Inertia:IsAvailable() and (v14:BuffDown(v79.InertiaBuff) or (v85 > (6 - 4))) and v14:BuffUp(v79.UnboundChaosBuff)) or ((1823 + 840) == (4430 - (628 + 490)))) then
					if (((767 + 3510) <= (11079 - 6604)) and v21(v79.FelRush, not v15:IsInRange(68 - 53))) then
						return "fel_rush opener 7";
					end
				end
				if ((v79.TheHunt:IsCastable() and v55 and ((v31 and v58) or not v58) and v32) or ((1644 - (431 + 343)) == (2400 - 1211))) then
					if (((4492 - 2939) <= (2476 + 657)) and v21(v79.TheHunt, not v15:IsInRange(6 + 34))) then
						return "the_hunt opener 8";
					end
				end
				v114 = 1697 - (556 + 1139);
			end
			if (((17 - (6 + 9)) == v114) or ((410 + 1827) >= (1799 + 1712))) then
				if ((v79.EssenceBreak:IsCastable() and v39) or ((1493 - (28 + 141)) > (1170 + 1850))) then
					if (v21(v79.EssenceBreak, not v15:IsInMeleeRange(6 - 1)) or ((2120 + 872) == (3198 - (486 + 831)))) then
						return "essence_break opener 9";
					end
				end
				if (((8082 - 4976) > (5372 - 3846)) and v79.DeathSweep:IsCastable() and v37) then
					if (((572 + 2451) < (12236 - 8366)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(1268 - (668 + 595)))) then
						return "death_sweep opener 10";
					end
				end
				if (((129 + 14) > (15 + 59)) and v79.Annihilation:IsCastable() and v33) then
					if (((48 - 30) < (2402 - (23 + 267))) and v21(v79.Annihilation, not v15:IsInMeleeRange(1949 - (1129 + 815)))) then
						return "annihilation opener 11";
					end
				end
				if (((1484 - (371 + 16)) <= (3378 - (1326 + 424))) and v79.DemonsBite:IsCastable() and v38) then
					if (((8769 - 4139) == (16919 - 12289)) and v21(v79.DemonsBite, not v15:IsInMeleeRange(123 - (88 + 30)))) then
						return "demons_bite opener 12";
					end
				end
				break;
			end
		end
	end
	local function v101()
		local v115 = 771 - (720 + 51);
		while true do
			if (((7874 - 4334) > (4459 - (421 + 1355))) and ((1 - 0) == v115)) then
				if (((2355 + 2439) >= (4358 - (286 + 797))) and v79.EyeBeam:IsCastable() and v40 and v14:BuffDown(v79.FelBarrageBuff)) then
					if (((5424 - 3940) == (2457 - 973)) and v21(v79.EyeBeam, not v15:IsInRange(447 - (397 + 42)))) then
						return "eye_beam fel_barrage 3";
					end
				end
				if (((448 + 984) < (4355 - (24 + 776))) and v79.EssenceBreak:IsCastable() and v39 and v14:BuffDown(v79.FelBarrageBuff) and v14:BuffUp(v79.MetamorphosisBuff)) then
					if (v21(v79.EssenceBreak, not v15:IsInMeleeRange(7 - 2)) or ((1850 - (222 + 563)) > (7883 - 4305))) then
						return "essence_break fel_barrage 5";
					end
				end
				if ((v79.DeathSweep:IsCastable() and v37 and v14:BuffDown(v79.FelBarrageBuff)) or ((3453 + 1342) < (1597 - (23 + 167)))) then
					if (((3651 - (690 + 1108)) < (1737 + 3076)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(5 + 0))) then
						return "death_sweep fel_barrage 7";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and v14:BuffDown(v79.UnboundChaosBuff) and ((v85 > (850 - (40 + 808))) or v14:BuffUp(v79.FelBarrageBuff))) or ((465 + 2356) < (9296 - 6865))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(8 + 0)) or ((1521 + 1353) < (1197 + 984))) then
						return "immolation_aura fel_barrage 9";
					end
				end
				v115 = 573 - (47 + 524);
			end
			if (((2 + 0) == v115) or ((7350 - 4661) <= (512 - 169))) then
				if ((v79.GlaiveTempest:IsCastable() and v44 and v14:BuffDown(v79.FelBarrageBuff) and (v85 > (2 - 1))) or ((3595 - (1165 + 561)) == (60 + 1949))) then
					if (v21(v79.GlaiveTempest, not v15:IsInMeleeRange(15 - 10)) or ((1353 + 2193) < (2801 - (341 + 138)))) then
						return "glaive_tempest fel_barrage 11";
					end
				end
				if ((v79.BladeDance:IsCastable() and v34 and v14:BuffDown(v79.FelBarrageBuff)) or ((563 + 1519) == (9849 - 5076))) then
					if (((3570 - (89 + 237)) > (3393 - 2338)) and v21(v79.BladeDance, not v15:IsInMeleeRange(10 - 5))) then
						return "blade_dance fel_barrage 13";
					end
				end
				if ((v79.FelBarrage:IsCastable() and v41 and (v14:Fury() > (981 - (581 + 300)))) or ((4533 - (855 + 365)) <= (4222 - 2444))) then
					if (v21(v79.FelBarrage, not v15:IsInMeleeRange(2 + 3)) or ((2656 - (1030 + 205)) >= (1976 + 128))) then
						return "fel_barrage fel_barrage 15";
					end
				end
				if (((1686 + 126) <= (3535 - (156 + 130))) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v14:Fury() > (45 - 25)) and v14:BuffUp(v79.FelBarrageBuff)) then
					if (((2735 - 1112) <= (4007 - 2050)) and v21(v79.FelRush, not v15:IsInRange(4 + 11))) then
						return "fel_rush fel_barrage 17";
					end
				end
				v115 = 2 + 1;
			end
			if (((4481 - (10 + 59)) == (1248 + 3164)) and (v115 == (14 - 11))) then
				if (((2913 - (671 + 492)) >= (671 + 171)) and v46 and v79.SigilOfFlame:IsCastable() and (v14:FuryDeficit() > (1255 - (369 + 846))) and v14:BuffUp(v79.FelBarrageBuff)) then
					if (((1158 + 3214) > (1579 + 271)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (((2177 - (1036 + 909)) < (653 + 168)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(13 - 5))) then
							return "sigil_of_flame fel_barrage 18";
						end
					elseif (((721 - (11 + 192)) < (456 + 446)) and (v78 == "cursor")) then
						if (((3169 - (135 + 40)) > (2078 - 1220)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(25 + 15))) then
							return "sigil_of_flame fel_barrage 18";
						end
					end
				end
				if ((v79.Felblade:IsCastable() and v42 and v14:BuffUp(v79.FelBarrageBuff) and (v14:FuryDeficit() > (88 - 48))) or ((5629 - 1874) <= (1091 - (50 + 126)))) then
					if (((10987 - 7041) > (829 + 2914)) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
						return "felblade fel_barrage 19";
					end
				end
				if ((v79.DeathSweep:IsCastable() and v37 and (((v14:Fury() - v91) - (1448 - (1233 + 180))) > (969 - (522 + 447))) and ((v14:BuffRemains(v79.FelBarrageBuff) < (1424 - (107 + 1314))) or v89 or (v14:Fury() > (38 + 42)) or (v90 > (54 - 36)))) or ((568 + 767) >= (6564 - 3258))) then
					if (((19165 - 14321) > (4163 - (716 + 1194))) and v21(v79.DeathSweep, not v15:IsInMeleeRange(1 + 4))) then
						return "death_sweep fel_barrage 21";
					end
				end
				if (((49 + 403) == (955 - (74 + 429))) and v79.GlaiveTempest:IsCastable() and v44 and (((v14:Fury() - v91) - (57 - 27)) > (0 + 0)) and ((v14:BuffRemains(v79.FelBarrageBuff) < (6 - 3)) or v89 or (v14:Fury() > (57 + 23)) or (v90 > (55 - 37)))) then
					if (v21(v79.GlaiveTempest, not v15:IsInMeleeRange(12 - 7)) or ((4990 - (279 + 154)) < (2865 - (454 + 324)))) then
						return "glaive_tempest fel_barrage 23";
					end
				end
				v115 = 4 + 0;
			end
			if (((3891 - (12 + 5)) == (2089 + 1785)) and (v115 == (12 - 7))) then
				if ((v79.DemonsBite:IsCastable() and v38) or ((717 + 1221) > (6028 - (277 + 816)))) then
					if (v21(v79.DemonsBite, not v15:IsInMeleeRange(21 - 16)) or ((5438 - (1058 + 125)) < (642 + 2781))) then
						return "demons_bite fel_barrage 33";
					end
				end
				break;
			end
			if (((2429 - (815 + 160)) <= (10687 - 8196)) and (v115 == (0 - 0))) then
				v89 = (v79.Felblade:CooldownRemains() < v92) or (v79.SigilOfFlame:CooldownRemains() < v92);
				v90 = (((1 + 0) % ((5.6 - 3) * v14:SpellHaste())) * (1910 - (41 + 1857))) + (v14:BuffStack(v79.ImmolationAuraBuff) * (1899 - (1222 + 671))) + (v24(v14:BuffUp(v79.TacticalRetreatBuff)) * (25 - 15));
				v91 = v92 * (45 - 13);
				if ((v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff)) or ((5339 - (229 + 953)) <= (4577 - (1111 + 663)))) then
					if (((6432 - (874 + 705)) >= (418 + 2564)) and v21(v79.Annihilation, not v15:IsInMeleeRange(4 + 1))) then
						return "annihilation fel_barrage 1";
					end
				end
				v115 = 1 - 0;
			end
			if (((117 + 4017) > (4036 - (642 + 37))) and (v115 == (1 + 3))) then
				if ((v79.BladeDance:IsCastable() and v34 and (((v14:Fury() - v91) - (6 + 29)) > (0 - 0)) and ((v14:BuffRemains(v79.FelBarrageBuff) < (457 - (233 + 221))) or v89 or (v14:Fury() > (184 - 104)) or (v90 > (16 + 2)))) or ((4958 - (718 + 823)) < (1595 + 939))) then
					if (v21(v79.BladeDance, not v15:IsInMeleeRange(810 - (266 + 539))) or ((7706 - 4984) <= (1389 - (636 + 589)))) then
						return "blade_dance fel_barrage 25";
					end
				end
				if ((v79.ArcaneTorrent:IsCastable() and (v14:FuryDeficit() > (94 - 54)) and v14:BuffUp(v79.FelBarrageBuff)) or ((4966 - 2558) < (1672 + 437))) then
					if (v21(v79.ArcaneTorrent) or ((12 + 21) == (2470 - (657 + 358)))) then
						return "arcane_torrent fel_barrage 27";
					end
				end
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff)) or ((1172 - 729) >= (9147 - 5132))) then
					if (((4569 - (1151 + 36)) > (161 + 5)) and v21(v79.FelRush, not v15:IsInRange(4 + 11))) then
						return "fel_rush fel_barrage 29";
					end
				end
				if ((v79.TheHunt:IsCastable() and v55 and ((v31 and v58) or not v58) and v32 and (v14:Fury() > (119 - 79))) or ((2112 - (1552 + 280)) == (3893 - (64 + 770)))) then
					if (((1278 + 603) > (2935 - 1642)) and v21(v79.TheHunt, not v15:IsInRange(8 + 32))) then
						return "the_hunt fel_barrage 31";
					end
				end
				v115 = 1248 - (157 + 1086);
			end
		end
	end
	local function v102()
		local v116 = 0 - 0;
		while true do
			if (((10322 - 7965) == (3615 - 1258)) and (v116 == (1 - 0))) then
				if (((942 - (599 + 220)) == (244 - 121)) and v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (((v79.EyeBeam:CooldownRemains() < (v92 * (1934 - (1813 + 118)))) and (v79.BladeDance:CooldownRemains() > (0 + 0))) or (v79.Metamorphosis:CooldownRemains() < (v92 * (1220 - (841 + 376)))))) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(6 - 1)) or ((246 + 810) >= (9258 - 5866))) then
						return "annihilation meta 9";
					end
				end
				if ((v79.EssenceBreak:IsCastable() and v39 and (v14:Fury() > (879 - (464 + 395))) and ((v79.Metamorphosis:CooldownRemains() > (25 - 15)) or (v79.BladeDance:CooldownRemains() < (v92 * (1 + 1)))) and (v14:BuffDown(v79.UnboundChaosBuff) or v14:BuffUp(v79.InertiaBuff) or not v79.Inertia:IsAvailable())) or (v94 < (847 - (467 + 370))) or ((2233 - 1152) < (790 + 285))) then
					if (v21(v79.EssenceBreak, not v15:IsInMeleeRange(17 - 12)) or ((164 + 885) >= (10311 - 5879))) then
						return "essence_break meta 11";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and v15:DebuffDown(v79.EssenceBreakDebuff) and (v79.BladeDance:CooldownRemains() > (v92 + (520.5 - (150 + 370)))) and v14:BuffDown(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and ((v79.ImmolationAura:FullRechargeTime() + (1285 - (74 + 1208))) < v79.EyeBeam:CooldownRemains()) and (v14:BuffRemains(v79.MetamorphosisBuff) > (12 - 7))) or ((22612 - 17844) <= (602 + 244))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(398 - (14 + 376))) or ((5823 - 2465) <= (919 + 501))) then
						return "immolation_aura meta 13";
					end
				end
				if ((v79.DeathSweep:IsCastable() and v37) or ((3285 + 454) <= (2866 + 139))) then
					if (v21(v79.DeathSweep, not v15:IsInMeleeRange(14 - 9)) or ((1249 + 410) >= (2212 - (23 + 55)))) then
						return "death_sweep meta 15";
					end
				end
				v116 = 4 - 2;
			end
			if ((v116 == (3 + 1)) or ((2928 + 332) < (3651 - 1296))) then
				if ((v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable()) or ((211 + 458) == (5124 - (652 + 249)))) then
					if (v21(v79.FelRush, not v15:IsInRange(40 - 25)) or ((3560 - (708 + 1160)) < (1595 - 1007))) then
						return "fel_rush meta 33";
					end
				end
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.FelRush:Recharge() < v79.EyeBeam:CooldownRemains()) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.EyeBeam:CooldownRemains() > (14 - 6)) or (v79.FelRush:ChargesFractional() > (28.01 - (10 + 17))))) or ((1078 + 3719) < (5383 - (1400 + 332)))) then
					if (v21(v79.FelRush, not v15:IsInRange(28 - 13)) or ((6085 - (242 + 1666)) > (2076 + 2774))) then
						return "fel_rush meta 35";
					end
				end
				if ((v79.DemonsBite:IsCastable() and v38) or ((147 + 253) > (947 + 164))) then
					if (((3991 - (850 + 90)) > (1759 - 754)) and v21(v79.DemonsBite, not v15:IsInMeleeRange(1395 - (360 + 1030)))) then
						return "demons_bite meta 37";
					end
				end
				break;
			end
			if (((3269 + 424) <= (12367 - 7985)) and (v116 == (3 - 0))) then
				if ((v46 and v79.SigilOfFlame:IsCastable() and (v14:BuffRemains(v79.MetamorphosisBuff) > (1666 - (909 + 752)))) or ((4505 - (109 + 1114)) > (7506 - 3406))) then
					if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((1394 + 2186) < (3086 - (6 + 236)))) then
						if (((57 + 32) < (3615 + 875)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(18 - 10))) then
							return "sigil_of_flame meta 25";
						end
					elseif ((v78 == "cursor") or ((8703 - 3720) < (2941 - (1076 + 57)))) then
						if (((630 + 3199) > (4458 - (579 + 110))) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(4 + 36))) then
							return "sigil_of_flame meta 25";
						end
					end
				end
				if (((1313 + 172) <= (1542 + 1362)) and v79.Felblade:IsCastable() and v42) then
					if (((4676 - (174 + 233)) == (11924 - 7655)) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
						return "felblade meta 27";
					end
				end
				if (((678 - 291) <= (1238 + 1544)) and v46 and v79.SigilOfFlame:IsCastable() and v15:DebuffDown(v79.EssenceBreakDebuff)) then
					if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((3073 - (663 + 511)) <= (819 + 98))) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(2 + 6)) or ((13293 - 8981) <= (531 + 345))) then
							return "sigil_of_flame meta 29";
						end
					elseif (((5254 - 3022) <= (6284 - 3688)) and (v78 == "cursor")) then
						if (((1000 + 1095) < (7174 - 3488)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(29 + 11))) then
							return "sigil_of_flame meta 29";
						end
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and v15:IsInRange(1 + 7) and (v79.ImmolationAura:Recharge() < v27(v79.EyeBeam:CooldownRemains(), v14:BuffRemains(v79.MetamorphosisBuff)))) or ((2317 - (478 + 244)) >= (4991 - (440 + 77)))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(4 + 4)) or ((16905 - 12286) < (4438 - (655 + 901)))) then
						return "immolation_aura meta 31";
					end
				end
				v116 = 1 + 3;
			end
			if ((v116 == (2 + 0)) or ((199 + 95) >= (19462 - 14631))) then
				if (((3474 - (695 + 750)) <= (10530 - 7446)) and v79.EyeBeam:IsCastable() and v40 and v15:DebuffDown(v79.EssenceBreakDebuff) and v14:BuffDown(v79.InnerDemonBuff)) then
					if (v21(v79.EyeBeam, not v15:IsInRange(12 - 4)) or ((8192 - 6155) == (2771 - (285 + 66)))) then
						return "eye_beam meta 17";
					end
				end
				if (((10391 - 5933) > (5214 - (682 + 628))) and v79.GlaiveTempest:IsCastable() and v44 and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.BladeDance:CooldownRemains() > (v92 * (1 + 1))) or (v14:Fury() > (359 - (176 + 123))))) then
					if (((183 + 253) >= (90 + 33)) and v21(v79.GlaiveTempest, not v15:IsInMeleeRange(274 - (239 + 30)))) then
						return "glaive_tempest meta 19";
					end
				end
				if (((136 + 364) < (1746 + 70)) and v46 and v79.SigilOfFlame:IsCastable() and (v85 > (3 - 1))) then
					if (((11150 - 7576) == (3889 - (306 + 9))) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (((771 - 550) < (68 + 322)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(5 + 3))) then
							return "sigil_of_flame meta 21";
						end
					elseif ((v78 == "cursor") or ((1066 + 1147) <= (4063 - 2642))) then
						if (((4433 - (1140 + 235)) < (3093 + 1767)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(37 + 3))) then
							return "sigil_of_flame meta 21";
						end
					end
				end
				if ((v79.Annihilation:IsCastable() and v33 and ((v79.BladeDance:CooldownRemains() > (v92 * (1 + 1))) or (v14:Fury() > (112 - (33 + 19))) or ((v14:BuffRemains(v79.MetamorphosisBuff) < (2 + 3)) and v79.Felblade:CooldownUp()))) or ((3884 - 2588) >= (1959 + 2487))) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(9 - 4)) or ((1307 + 86) > (5178 - (586 + 103)))) then
						return "annihilation meta 23";
					end
				end
				v116 = 1 + 2;
			end
			if ((v116 == (0 - 0)) or ((5912 - (1309 + 179)) < (48 - 21))) then
				if ((v79.DeathSweep:IsCastable() and v37 and (v14:BuffRemains(v79.MetamorphosisBuff) < v92)) or ((870 + 1127) > (10245 - 6430))) then
					if (((2618 + 847) > (4064 - 2151)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(9 - 4))) then
						return "death_sweep meta 1";
					end
				end
				if (((1342 - (295 + 314)) < (4467 - 2648)) and v79.Annihilation:IsCastable() and v33 and (v14:BuffRemains(v79.MetamorphosisBuff) < v92)) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(1967 - (1300 + 662))) or ((13800 - 9405) == (6510 - (1178 + 577)))) then
						return "annihilation meta 3";
					end
				end
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable()) or ((1970 + 1823) < (7003 - 4634))) then
					if (v21(v79.FelRush, not v15:IsInRange(1420 - (851 + 554))) or ((3612 + 472) == (734 - 469))) then
						return "fel_rush meta 5";
					end
				end
				if (((9464 - 5106) == (4660 - (115 + 187))) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) < (v92 * (2 + 0)))) then
					if (v21(v79.FelRush, not v15:IsInRange(15 + 0)) or ((12365 - 9227) < (2154 - (160 + 1001)))) then
						return "fel_rush meta 7";
					end
				end
				v116 = 1 + 0;
			end
		end
	end
	local function v103()
		local v117 = 0 + 0;
		while true do
			if (((6816 - 3486) > (2681 - (237 + 121))) and (v117 == (901 - (525 + 372)))) then
				if ((v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (v79.EyeBeam:CooldownRemains() < (9 - 4))) or ((11913 - 8287) == (4131 - (96 + 46)))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(785 - (643 + 134))) or ((331 + 585) == (6404 - 3733))) then
						return "immolation_aura rotation 19";
					end
				end
				if (((1009 - 737) == (261 + 11)) and v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.ImmolationAura:Recharge() + (9 - 4)) < v79.EyeBeam:CooldownRemains()) and (v79.BladeDance:CooldownRemains() > (0 - 0)) and (v79.BladeDance:CooldownRemains() < (723 - (316 + 403))) and (v79.ImmolationAura:ChargesFractional() > (1 + 0))) then
					if (((11681 - 7432) <= (1749 + 3090)) and v21(v79.ImmolationAura, not v15:IsInRange(20 - 12))) then
						return "immolation_aura rotation 21";
					end
				end
				if (((1968 + 809) < (1032 + 2168)) and v79.ImmolationAura:IsCastable() and v45 and (v94 < (51 - 36)) and (v79.BladeDance:CooldownRemains() > (0 - 0))) then
					if (((197 - 102) < (113 + 1844)) and v21(v79.ImmolationAura, not v15:IsInRange(15 - 7))) then
						return "immolation_aura rotation 23";
					end
				end
				if (((41 + 785) < (5051 - 3334)) and v79.EyeBeam:IsCastable() and v40 and not v79.EssenceBreak:IsAvailable() and (not v79.ChaoticTransformation:IsAvailable() or (v79.Metamorphosis:CooldownRemains() < ((22 - (12 + 5)) + ((11 - 8) * v24(v79.ShatteredDestiny:IsAvailable())))) or (v79.Metamorphosis:CooldownRemains() > (31 - 16)))) then
					if (((3031 - 1605) >= (2740 - 1635)) and v21(v79.EyeBeam, not v15:IsInRange(2 + 6))) then
						return "eye_beam rotation 25";
					end
				end
				v117 = 1978 - (1656 + 317);
			end
			if (((2455 + 299) <= (2708 + 671)) and (v117 == (21 - 13))) then
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.FelRush:Recharge() < v79.EyeBeam:CooldownRemains()) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.EyeBeam:CooldownRemains() > (39 - 31)) or (v79.FelRush:ChargesFractional() > (355.01 - (5 + 349))))) or ((18652 - 14725) == (2684 - (266 + 1005)))) then
					if (v21(v79.FelRush, not v15:IsInRange(10 + 5)) or ((3937 - 2783) <= (1036 - 248))) then
						return "fel_rush rotation 51";
					end
				end
				if ((v79.ArcaneTorrent:IsCastable() and not v14:IsMoving() and v15:IsInRange(1704 - (561 + 1135)) and v15:DebuffDown(v79.EssenceBreakDebuff) and (v14:Fury() < (130 - 30))) or ((5400 - 3757) > (4445 - (507 + 559)))) then
					if (v21(v79.ArcaneTorrent, not v15:IsInRange(20 - 12)) or ((8668 - 5865) > (4937 - (212 + 176)))) then
						return "arcane_torrent rotation 53";
					end
				end
				break;
			end
			if ((v117 == (905 - (250 + 655))) or ((599 - 379) >= (5279 - 2257))) then
				v28 = v99();
				if (((4414 - 1592) == (4778 - (1869 + 87))) and v28) then
					return v28;
				end
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v14:BuffRemains(v79.UnboundChaosBuff) < (v92 * (6 - 4)))) or ((2962 - (484 + 1417)) == (3980 - 2123))) then
					if (((4625 - 1865) > (2137 - (48 + 725))) and v21(v79.FelRush, not v15:IsInRange(24 - 9))) then
						return "fel_rush rotation 1";
					end
				end
				if (v79.FelBarrage:IsAvailable() or ((13151 - 8249) <= (2090 + 1505))) then
					v88 = v79.FelBarrage:IsAvailable() and (v79.FelBarrage:CooldownRemains() < (v92 * (18 - 11))) and (((v85 >= (1 + 1)) and ((v79.Metamorphosis:CooldownRemains() > (0 + 0)) or (v85 > (855 - (152 + 701))))) or v14:BuffUp(v79.FelBarrageBuff));
				end
				v117 = 1312 - (430 + 881);
			end
			if ((v117 == (2 + 1)) or ((4747 - (557 + 338)) == (87 + 206))) then
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and (v79.BladeDance:CooldownRemains() < (10 - 6)) and (v79.EyeBeam:CooldownRemains() > (17 - 12)) and ((v79.ImmolationAura:Charges() > (0 - 0)) or ((v79.ImmolationAura:Recharge() + (4 - 2)) < v79.EyeBeam:CooldownRemains()) or (v79.EyeBeam:CooldownRemains() > (v14:BuffRemains(v79.UnboundChaosBuff) - (803 - (499 + 302)))))) or ((2425 - (39 + 827)) == (12665 - 8077))) then
					if (v21(v79.FelRush, not v15:IsInRange(33 - 18)) or ((17809 - 13325) == (1209 - 421))) then
						return "fel_rush rotation 11";
					end
				end
				if (((392 + 4176) >= (11435 - 7528)) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v92 * (1 + 1)))) then
					if (((1971 - 725) < (3574 - (103 + 1))) and v21(v79.FelRush, not v15:IsInRange(569 - (475 + 79)))) then
						return "fel_rush rotation 13";
					end
				end
				if (((8793 - 4725) >= (3110 - 2138)) and v79.ImmolationAura:IsCastable() and v45 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.ImmolationAura:FullRechargeTime() < (v92 * (1 + 1))) and (v94 > v79.ImmolationAura:FullRechargeTime())) then
					if (((434 + 59) < (5396 - (1395 + 108))) and v21(v79.ImmolationAura, not v15:IsInRange(23 - 15))) then
						return "immolation_aura rotation 15";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and (v85 > (1206 - (7 + 1197))) and v14:BuffDown(v79.UnboundChaosBuff)) or ((643 + 830) >= (1163 + 2169))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(327 - (27 + 292))) or ((11870 - 7819) <= (1475 - 318))) then
						return "immolation_aura rotation 17";
					end
				end
				v117 = 16 - 12;
			end
			if (((1190 - 586) < (5486 - 2605)) and (v117 == (145 - (43 + 96)))) then
				if ((v79.ChaosStrike:IsCastable() and v35 and v15:DebuffUp(v79.EssenceBreakDebuff)) or ((3671 - 2771) == (7634 - 4257))) then
					if (((3700 + 759) > (167 + 424)) and v21(v79.ChaosStrike, not v15:IsInMeleeRange(9 - 4))) then
						return "chaos_strike rotation 35";
					end
				end
				if (((1303 + 2095) >= (4488 - 2093)) and v79.Felblade:IsCastable() and v42) then
					if (v21(v79.Felblade, not v15:IsInMeleeRange(2 + 3)) or ((161 + 2022) >= (4575 - (1414 + 337)))) then
						return "felblade rotation 37";
					end
				end
				if (((3876 - (1642 + 298)) == (5046 - 3110)) and v79.ThrowGlaive:IsCastable() and v47 and (v79.ThrowGlaive:FullRechargeTime() <= v79.BladeDance:CooldownRemains()) and (v79.Metamorphosis:CooldownRemains() > (14 - 9)) and v79.Soulscar:IsAvailable() and v14:HasTier(91 - 60, 1 + 1) and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat)) then
					if (v21(v79.ThrowGlaive, not v15:IsInMeleeRange(1002 - (357 + 615))) or ((3392 + 1440) < (10582 - 6269))) then
						return "throw_glaive rotation 39";
					end
				end
				if (((3503 + 585) > (8301 - 4427)) and v79.ThrowGlaive:IsCastable() and v47 and not v14:HasTier(25 + 6, 1 + 1) and ((v85 > (1 + 0)) or v79.Soulscar:IsAvailable()) and not v14:PrevGCDP(1302 - (384 + 917), v79.VengefulRetreat)) then
					if (((5029 - (128 + 569)) == (5875 - (1407 + 136))) and v21(v79.ThrowGlaive, not v15:IsInMeleeRange(1917 - (687 + 1200)))) then
						return "throw_glaive rotation 41";
					end
				end
				v117 = 1717 - (556 + 1154);
			end
			if (((14068 - 10069) >= (2995 - (9 + 86))) and (v117 == (422 - (275 + 146)))) then
				if (((v79.EyeBeam:CooldownUp() or v79.Metamorphosis:CooldownUp()) and (v10.CombatTime() < (3 + 12))) or ((2589 - (29 + 35)) > (18011 - 13947))) then
					local v166 = 0 - 0;
					while true do
						if (((19295 - 14924) == (2847 + 1524)) and (v166 == (1012 - (53 + 959)))) then
							v28 = v100();
							if (v28 or ((674 - (312 + 96)) > (8653 - 3667))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((2276 - (147 + 138)) >= (1824 - (813 + 86))) and v88) then
					local v167 = 0 + 0;
					while true do
						if (((842 - 387) < (2545 - (18 + 474))) and (v167 == (0 + 0))) then
							v28 = v101();
							if (v28 or ((2695 - 1869) == (5937 - (860 + 226)))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((486 - (121 + 182)) == (23 + 160)) and v79.ImmolationAura:IsCastable() and v45 and (v85 > (1242 - (988 + 252))) and v79.Ragefire:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (not v79.FelBarrage:IsAvailable() or (v79.FelBarrage:CooldownRemains() > v79.ImmolationAura:Recharge())) and v15:DebuffDown(v79.EssenceBreakDebuff)) then
					if (((131 + 1028) <= (561 + 1227)) and v21(v79.ImmolationAura, not v15:IsInRange(1978 - (49 + 1921)))) then
						return "immolation_aura rotation 3";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and (v85 > (892 - (223 + 667))) and v79.Ragefire:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((3559 - (51 + 1)) > (7431 - 3113))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(17 - 9)) or ((4200 - (146 + 979)) <= (837 + 2128))) then
						return "immolation_aura rotation 5";
					end
				end
				v117 = 607 - (311 + 294);
			end
			if (((3806 - 2441) <= (852 + 1159)) and (v117 == (1445 - (496 + 947)))) then
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v85 > (1360 - (1233 + 125))) and (not v79.Inertia:IsAvailable() or ((v79.EyeBeam:CooldownRemains() + 1 + 1) > v14:BuffRemains(v79.UnboundChaosBuff)))) or ((2491 + 285) > (680 + 2895))) then
					if (v21(v79.FelRush, not v15:IsInRange(1660 - (963 + 682))) or ((2132 + 422) == (6308 - (504 + 1000)))) then
						return "fel_rush rotation 7";
					end
				end
				if (((1736 + 841) == (2347 + 230)) and v79.VengefulRetreat:IsCastable() and v48 and v32 and v79.Felblade:IsCastable() and v79.Initiative:IsAvailable() and (((v79.EyeBeam:CooldownRemains() > (2 + 13)) and (v14:GCDRemains() < (0.3 - 0))) or ((v14:GCDRemains() < (0.1 + 0)) and (v79.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and ((v79.Metamorphosis:CooldownRemains() > (6 + 4)) or (v79.BladeDance:CooldownRemains() < (v92 * (184 - (156 + 26))))))) and (v10.CombatTime() > (3 + 1))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(12 - 4), true, true) or ((170 - (149 + 15)) >= (2849 - (890 + 70)))) then
						return "vengeful_retreat rotation 9";
					end
				end
				if (((623 - (39 + 78)) <= (2374 - (14 + 468))) and (v88 or (not v79.DemonBlades:IsAvailable() and v79.FelBarrage:IsAvailable() and (v14:BuffUp(v79.FelBarrageBuff) or (v79.FelBarrage:CooldownRemains() > (0 - 0))) and v14:BuffDown(v79.MetamorphosisBuff)))) then
					local v168 = 0 - 0;
					while true do
						if (((0 + 0) == v168) or ((1206 + 802) > (472 + 1746))) then
							v28 = v101();
							if (((172 + 207) <= (1087 + 3060)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (v14:BuffUp(v79.MetamorphosisBuff) or ((8639 - 4125) <= (998 + 11))) then
					local v169 = 0 - 0;
					while true do
						if ((v169 == (0 + 0)) or ((3547 - (12 + 39)) == (1109 + 83))) then
							v28 = v102();
							if (v28 or ((643 - 435) == (10538 - 7579))) then
								return v28;
							end
							break;
						end
					end
				end
				v117 = 1 + 2;
			end
			if (((2252 + 2025) >= (3329 - 2016)) and (v117 == (4 + 1))) then
				if (((12502 - 9915) < (4884 - (1596 + 114))) and ((v79.EyeBeam:IsCastable() and v40 and v79.EssenceBreak:IsAvailable() and ((v79.EssenceBreak:CooldownRemains() < ((v92 * (4 - 2)) + ((718 - (164 + 549)) * v24(v79.ShatteredDestiny:IsAvailable())))) or (v79.ShatteredDestiny:IsAvailable() and (v79.EssenceBreak:CooldownRemains() > (1448 - (1059 + 379))))) and ((v79.BladeDance:CooldownRemains() < (8 - 1)) or (v85 > (1 + 0))) and (not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (2 + 8)) or (v85 > (393 - (145 + 247)))) and (not v79.Inertia:IsAvailable() or v14:BuffUp(v79.UnboundChaosBuff) or ((v79.ImmolationAura:Charges() == (0 + 0)) and (v79.ImmolationAura:Recharge() > (3 + 2))))) or (v94 < (29 - 19)))) then
					if (v21(v79.EyeBeam, not v15:IsInRange(2 + 6)) or ((3549 + 571) <= (3568 - 1370))) then
						return "eye_beam rotation 27";
					end
				end
				if ((v79.BladeDance:IsCastable() and v34 and ((v79.EyeBeam:CooldownRemains() > v92) or v79.EyeBeam:CooldownUp())) or ((2316 - (254 + 466)) == (1418 - (544 + 16)))) then
					if (((10233 - 7013) == (3848 - (294 + 334))) and v21(v79.BladeDance, not v15:IsInRange(258 - (236 + 17)))) then
						return "blade_dance rotation 29";
					end
				end
				if ((v79.GlaiveTempest:IsCastable() and v44 and (v85 >= (1 + 1))) or ((1092 + 310) > (13633 - 10013))) then
					if (((12186 - 9612) == (1326 + 1248)) and v21(v79.GlaiveTempest, not v15:IsInRange(7 + 1))) then
						return "glaive_tempest rotation 31";
					end
				end
				if (((2592 - (413 + 381)) < (117 + 2640)) and v46 and (v85 > (5 - 2)) and v79.SigilOfFlame:IsCastable()) then
					if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((979 - 602) > (4574 - (582 + 1388)))) then
						if (((967 - 399) < (653 + 258)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(372 - (326 + 38)))) then
							return "sigil_of_flame rotation 33";
						end
					elseif (((9717 - 6432) < (6035 - 1807)) and (v78 == "cursor")) then
						if (((4536 - (47 + 573)) > (1174 + 2154)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(169 - 129))) then
							return "sigil_of_flame rotation 33";
						end
					end
				end
				v117 = 9 - 3;
			end
			if (((4164 - (1269 + 395)) < (4331 - (76 + 416))) and (v117 == (450 - (319 + 124)))) then
				if (((1158 - 651) == (1514 - (564 + 443))) and v79.ChaosStrike:IsCastable() and v35 and ((v79.EyeBeam:CooldownRemains() > (v92 * (5 - 3))) or (v14:Fury() > (538 - (337 + 121))))) then
					if (((703 - 463) <= (10542 - 7377)) and v21(v79.ChaosStrike, not v15:IsInMeleeRange(1916 - (1261 + 650)))) then
						return "chaos_strike rotation 43";
					end
				end
				if (((353 + 481) >= (1282 - 477)) and v79.ImmolationAura:IsCastable() and v45 and not v79.Inertia:IsAvailable() and (v85 > (1819 - (772 + 1045)))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(2 + 6)) or ((3956 - (102 + 42)) < (4160 - (1524 + 320)))) then
						return "immolation_aura rotation 45";
					end
				end
				if ((v46 and not v15:IsInRange(1278 - (1049 + 221)) and v15:DebuffDown(v79.EssenceBreakDebuff) and (not v79.FelBarrage:IsAvailable() or (v79.FelBarrage:CooldownRemains() > (181 - (18 + 138)))) and v79.SigilOfFlame:IsCastable()) or ((6491 - 3839) <= (2635 - (67 + 1035)))) then
					if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((3946 - (136 + 212)) < (6204 - 4744))) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(7 + 1)) or ((3795 + 321) < (2796 - (240 + 1364)))) then
							return "sigil_of_flame rotation 47";
						end
					elseif ((v78 == "cursor") or ((4459 - (1050 + 32)) <= (3224 - 2321))) then
						if (((2352 + 1624) >= (1494 - (331 + 724))) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(4 + 36))) then
							return "sigil_of_flame rotation 47";
						end
					end
				end
				if (((4396 - (269 + 375)) == (4477 - (267 + 458))) and v79.DemonsBite:IsCastable() and v38) then
					if (((1259 + 2787) > (5182 - 2487)) and v21(v79.DemonsBite, not v15:IsInMeleeRange(823 - (667 + 151)))) then
						return "demons_bite rotation 49";
					end
				end
				v117 = 1505 - (1410 + 87);
			end
		end
	end
	local function v104()
		local v118 = 1897 - (1504 + 393);
		while true do
			if ((v118 == (13 - 8)) or ((9197 - 5652) == (3993 - (461 + 335)))) then
				v57 = EpicSettings.Settings['metamorphosisWithCD'];
				v58 = EpicSettings.Settings['theHuntWithCD'];
				v59 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v60 = EpicSettings.Settings['elysianDecreeSlider'] or (0 + 0);
				break;
			end
			if (((4155 - (1730 + 31)) > (2040 - (728 + 939))) and (v118 == (6 - 4))) then
				v41 = EpicSettings.Settings['useFelBarrage'];
				v42 = EpicSettings.Settings['useFelblade'];
				v43 = EpicSettings.Settings['useFelRush'];
				v44 = EpicSettings.Settings['useGlaiveTempest'];
				v118 = 5 - 2;
			end
			if (((9519 - 5364) <= (5300 - (138 + 930))) and (v118 == (4 + 0))) then
				v53 = EpicSettings.Settings['useElysianDecree'];
				v54 = EpicSettings.Settings['useMetamorphosis'];
				v55 = EpicSettings.Settings['useTheHunt'];
				v56 = EpicSettings.Settings['elysianDecreeWithCD'];
				v118 = 4 + 1;
			end
			if (((3 + 0) == v118) or ((14622 - 11041) == (5239 - (459 + 1307)))) then
				v45 = EpicSettings.Settings['useImmolationAura'];
				v46 = EpicSettings.Settings['useSigilOfFlame'];
				v47 = EpicSettings.Settings['useThrowGlaive'];
				v48 = EpicSettings.Settings['useVengefulRetreat'];
				v118 = 1874 - (474 + 1396);
			end
			if (((8722 - 3727) > (3138 + 210)) and (v118 == (1 + 0))) then
				v37 = EpicSettings.Settings['useDeathSweep'];
				v38 = EpicSettings.Settings['useDemonsBite'];
				v39 = EpicSettings.Settings['useEssenceBreak'];
				v40 = EpicSettings.Settings['useEyeBeam'];
				v118 = 5 - 3;
			end
			if ((v118 == (0 + 0)) or ((2516 - 1762) > (16240 - 12516))) then
				v33 = EpicSettings.Settings['useAnnihilation'];
				v34 = EpicSettings.Settings['useBladeDance'];
				v35 = EpicSettings.Settings['useChaosStrike'];
				v36 = EpicSettings.Settings['useConsumeMagic'];
				v118 = 592 - (562 + 29);
			end
		end
	end
	local function v105()
		local v119 = 0 + 0;
		while true do
			if (((1636 - (374 + 1045)) >= (46 + 11)) and (v119 == (12 - 8))) then
				v78 = EpicSettings.Settings['sigilSetting'] or "";
				break;
			end
			if ((v119 == (639 - (448 + 190))) or ((669 + 1401) >= (1823 + 2214))) then
				v51 = EpicSettings.Settings['useFelEruption'];
				v52 = EpicSettings.Settings['useSigilOfMisery'];
				v119 = 2 + 0;
			end
			if (((10400 - 7695) == (8405 - 5700)) and ((1494 - (1307 + 187)) == v119)) then
				v49 = EpicSettings.Settings['useChaosNova'];
				v50 = EpicSettings.Settings['useDisrupt'];
				v119 = 3 - 2;
			end
			if (((142 - 81) == (186 - 125)) and (v119 == (686 - (232 + 451)))) then
				v63 = EpicSettings.Settings['blurHP'] or (0 + 0);
				v64 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
				v119 = 568 - (510 + 54);
			end
			if ((v119 == (3 - 1)) or ((735 - (13 + 23)) >= (2525 - 1229))) then
				v61 = EpicSettings.Settings['useBlur'];
				v62 = EpicSettings.Settings['useNetherwalk'];
				v119 = 3 - 0;
			end
		end
	end
	local function v106()
		local v120 = 0 - 0;
		while true do
			if ((v120 == (1091 - (830 + 258))) or ((6289 - 4506) >= (2263 + 1353))) then
				v66 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v120 == (0 + 0)) or ((5354 - (860 + 581)) > (16698 - 12171))) then
				v70 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v65 = EpicSettings.Settings['dispelBuffs'];
				v67 = EpicSettings.Settings['InterruptWithStun'];
				v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v120 = 242 - (237 + 4);
			end
			if (((10284 - 5908) > (2066 - 1249)) and (v120 == (3 - 1))) then
				v73 = EpicSettings.Settings['useHealingPotion'];
				v76 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v75 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v77 = EpicSettings.Settings['HealingPotionName'] or "";
				v120 = 11 - 8;
			end
			if (((2086 + 2775) > (449 + 375)) and (v120 == (1427 - (85 + 1341)))) then
				v69 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['useTrinkets'];
				v72 = EpicSettings.Settings['trinketsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v120 = 3 - 1;
			end
		end
	end
	local function v107()
		local v121 = 0 - 0;
		while true do
			if (((373 - (45 + 327)) == v121) or ((2609 - 1226) >= (2633 - (444 + 58)))) then
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v32 = EpicSettings.Toggles['movement'];
				if (v14:IsDeadOrGhost() or ((816 + 1060) >= (438 + 2103))) then
					return v28;
				end
				v121 = 1 + 1;
			end
			if (((5164 - 3382) <= (5504 - (64 + 1668))) and (v121 == (1975 - (1227 + 746)))) then
				v83 = v14:GetEnemiesInMeleeRange(24 - 16);
				v84 = v14:GetEnemiesInMeleeRange(37 - 17);
				if (v30 or ((5194 - (415 + 79)) < (21 + 792))) then
					local v170 = 491 - (142 + 349);
					while true do
						if (((1371 + 1828) < (5568 - 1518)) and (v170 == (0 + 0))) then
							v85 = ((#v83 > (0 + 0)) and #v83) or (2 - 1);
							v86 = #v84;
							break;
						end
					end
				else
					local v171 = 1864 - (1710 + 154);
					while true do
						if (((318 - (200 + 118)) == v171) or ((1962 + 2989) < (7745 - 3315))) then
							v85 = 1 - 0;
							v86 = 1 + 0;
							break;
						end
					end
				end
				v92 = v14:GCD() + 0.05 + 0;
				v121 = 2 + 1;
			end
			if (((16 + 80) == (207 - 111)) and (v121 == (1254 - (363 + 887)))) then
				if (v14:PrevGCDP(1 - 0, v79.VengefulRetreat) or v14:PrevGCDP(9 - 7, v79.VengefulRetreat) or (v14:PrevGCDP(1 + 2, v79.VengefulRetreat) and v14:IsMoving()) or ((6408 - 3669) > (2739 + 1269))) then
					if ((v79.Felblade:IsCastable() and v42) or ((1687 - (674 + 990)) == (326 + 808))) then
						if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((1103 + 1590) >= (6516 - 2405))) then
							return "felblade rotation 1";
						end
					end
				elseif ((v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((5371 - (507 + 548)) <= (2983 - (289 + 548)))) then
					local v175 = 1818 - (821 + 997);
					while true do
						if ((v175 == (256 - (195 + 60))) or ((954 + 2592) <= (4310 - (251 + 1250)))) then
							if (((14366 - 9462) > (1489 + 677)) and v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v95, v15:NPCID())) then
								if (((1141 - (809 + 223)) >= (131 - 41)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
									return "fodder to the flames react per target";
								end
							end
							if (((14949 - 9971) > (9605 - 6700)) and v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v95, v16:NPCID())) then
								if (v21(v81.ThrowGlaiveMouseover, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((2229 + 797) <= (1194 + 1086))) then
									return "fodder to the flames react per mouseover";
								end
							end
							v175 = 619 - (14 + 603);
						end
						if ((v175 == (129 - (118 + 11))) or ((268 + 1385) <= (923 + 185))) then
							if (((8477 - 5568) > (3558 - (551 + 398))) and not v14:AffectingCombat() and v29) then
								local v176 = 0 + 0;
								while true do
									if (((270 + 487) > (158 + 36)) and (v176 == (0 - 0))) then
										v28 = v98();
										if (v28 or ((71 - 40) >= (454 + 944))) then
											return v28;
										end
										break;
									end
								end
							end
							if (((12687 - 9491) <= (1346 + 3526)) and v79.ConsumeMagic:IsAvailable() and v36 and v79.ConsumeMagic:IsReady() and v65 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) then
								if (((3415 - (40 + 49)) == (12665 - 9339)) and v21(v79.ConsumeMagic, not v15:IsSpellInRange(v79.ConsumeMagic))) then
									return "greater_purge damage";
								end
							end
							v175 = 491 - (99 + 391);
						end
						if (((1186 + 247) <= (17047 - 13169)) and (v175 == (4 - 2))) then
							v28 = v103();
							if (v28 or ((1542 + 41) == (4565 - 2830))) then
								return v28;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v121 == (1604 - (1032 + 572))) or ((3398 - (203 + 214)) == (4167 - (568 + 1249)))) then
				v105();
				v104();
				v106();
				v29 = EpicSettings.Toggles['ooc'];
				v121 = 1 + 0;
			end
			if (((6 - 3) == v121) or ((17250 - 12784) <= (1799 - (913 + 393)))) then
				if (v23.TargetIsValid() or v14:AffectingCombat() or ((7192 - 4645) <= (2807 - 820))) then
					local v172 = 410 - (269 + 141);
					while true do
						if (((6585 - 3624) > (4721 - (362 + 1619))) and (v172 == (1625 - (950 + 675)))) then
							v93 = v10.BossFightRemains(nil, true);
							v94 = v93;
							v172 = 1 + 0;
						end
						if (((4875 - (216 + 963)) >= (4899 - (485 + 802))) and (v172 == (560 - (432 + 127)))) then
							if ((v94 == (12184 - (1065 + 8))) or ((1650 + 1320) == (3479 - (635 + 966)))) then
								v94 = v10.FightRemains(v83, false);
							end
							break;
						end
					end
				end
				v28 = v97();
				if (v28 or ((2656 + 1037) < (2019 - (5 + 37)))) then
					return v28;
				end
				if (v66 or ((2313 - 1383) > (875 + 1226))) then
					local v173 = 0 - 0;
					while true do
						if (((1944 + 2209) > (6412 - 3326)) and (v173 == (0 - 0))) then
							v28 = v23.HandleIncorporeal(v79.Imprison, v81.ImprisonMouseover, 56 - 26, true);
							if (v28 or ((11127 - 6473) <= (2912 + 1138))) then
								return v28;
							end
							break;
						end
					end
				end
				v121 = 533 - (318 + 211);
			end
		end
	end
	local function v108()
		local v122 = 0 - 0;
		while true do
			if ((v122 == (1587 - (963 + 624))) or ((1113 + 1489) < (2342 - (518 + 328)))) then
				v79.BurningWoundDebuff:RegisterAuraTracking();
				v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v20.SetAPL(1344 - 767, v107, v108);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

