local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1320 - (19 + 13)) > (2035 - 784)) and (v5 == (2 - 1))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((1173 + 3340) < (5894 - 2542))) then
			v6 = v0[v4];
			if (not v6 or ((4282 - 2217) >= (5008 - (1293 + 519)))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
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
	local v91 = 0 + 0;
	local v92 = v14:GCD() + (0.25 - 0);
	local v93 = 2568 + 8543;
	local v94 = 3692 + 7419;
	local v95 = {(170517 - (709 + 387)),(491356 - 321931),(277949 - 109017),(126595 + 42831),(41613 + 127816),(332591 - 163163),(170713 - (1040 + 243))};
	v10:RegisterForEvent(function()
		local v109 = 0 - 0;
		while true do
			if ((v109 == (1847 - (559 + 1288))) or ((6307 - (609 + 1322)) <= (1935 - (13 + 441)))) then
				v88 = false;
				v93 = 41519 - 30408;
				v109 = 2 - 1;
			end
			if ((v109 == (4 - 3)) or ((127 + 3265) >= (17218 - 12477))) then
				v94 = 3947 + 7164;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v96()
		v28 = v23.HandleTopTrinket(v82, v31, 18 + 22, nil);
		if (((9867 - 6542) >= (1179 + 975)) and v28) then
			return v28;
		end
		v28 = v23.HandleBottomTrinket(v82, v31, 73 - 33, nil);
		if (v28 or ((857 + 438) >= (1799 + 1434))) then
			return v28;
		end
	end
	local function v97()
		local v110 = 0 + 0;
		while true do
			if (((3676 + 701) > (1607 + 35)) and ((434 - (153 + 280)) == v110)) then
				if (((13638 - 8915) > (1218 + 138)) and v80.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v76)) then
					if (v21(v81.Healthstone) or ((1634 + 2502) <= (1797 + 1636))) then
						return "healthstone defensive";
					end
				end
				if (((3853 + 392) <= (3356 + 1275)) and v73 and (v14:HealthPercentage() <= v75)) then
					if (((6510 - 2234) >= (2420 + 1494)) and (v77 == "Refreshing Healing Potion")) then
						if (((865 - (89 + 578)) <= (3119 + 1246)) and v80.RefreshingHealingPotion:IsReady()) then
							if (((9941 - 5159) > (5725 - (572 + 477))) and v21(v81.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if (((656 + 4208) > (1319 + 878)) and (v77 == "Dreamwalker's Healing Potion")) then
						if (v80.DreamwalkersHealingPotion:IsReady() or ((442 + 3258) == (2593 - (84 + 2)))) then
							if (((7372 - 2898) >= (198 + 76)) and v21(v81.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v110 == (842 - (497 + 345))) or ((49 + 1845) <= (238 + 1168))) then
				if (((2905 - (605 + 728)) >= (1093 + 438)) and v79.Blur:IsCastable() and v61 and (v14:HealthPercentage() <= v63)) then
					if (v21(v79.Blur) or ((10419 - 5732) < (209 + 4333))) then
						return "blur defensive";
					end
				end
				if (((12167 - 8876) > (1503 + 164)) and v79.Netherwalk:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) then
					if (v21(v79.Netherwalk) or ((2418 - 1545) == (1536 + 498))) then
						return "netherwalk defensive";
					end
				end
				v110 = 490 - (457 + 32);
			end
		end
	end
	local function v98()
		if ((v79.ImmolationAura:IsCastable() and v45) or ((1195 + 1621) < (1413 - (832 + 570)))) then
			if (((3485 + 214) < (1228 + 3478)) and v21(v79.ImmolationAura, not v15:IsInRange(28 - 20))) then
				return "immolation_aura precombat 8";
			end
		end
		if (((1275 + 1371) >= (1672 - (588 + 208))) and v46 and not v14:IsMoving() and (v85 > (2 - 1)) and v79.SigilOfFlame:IsCastable()) then
			if (((2414 - (884 + 916)) <= (6665 - 3481)) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
				if (((1813 + 1313) == (3779 - (232 + 421))) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1897 - (1569 + 320)))) then
					return "sigil_of_flame precombat 9";
				end
			elseif ((v78 == "cursor") or ((537 + 1650) >= (942 + 4012))) then
				if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(134 - 94)) or ((4482 - (316 + 289)) == (9358 - 5783))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if (((33 + 674) > (2085 - (666 + 787))) and not v15:IsInMeleeRange(430 - (360 + 65)) and v79.Felblade:IsCastable() and v42) then
			if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((511 + 35) >= (2938 - (79 + 175)))) then
				return "felblade precombat 9";
			end
		end
		if (((2310 - 845) <= (3357 + 944)) and not v15:IsInMeleeRange(15 - 10) and v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(1 - 0, v79.VengefulRetreat)) then
			if (((2603 - (503 + 396)) > (1606 - (92 + 89))) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
				return "throw_glaive precombat 9";
			end
		end
		if ((not v15:IsInMeleeRange(9 - 4) and v79.FelRush:IsCastable() and (not v79.Felblade:IsAvailable() or (v79.Felblade:CooldownUp() and not v14:PrevGCDP(1 + 0, v79.Felblade))) and v32 and v43) or ((407 + 280) == (16580 - 12346))) then
			if (v21(v79.FelRush, not v15:IsInRange(3 + 12)) or ((7592 - 4262) < (1247 + 182))) then
				return "fel_rush precombat 10";
			end
		end
		if (((548 + 599) >= (1020 - 685)) and v15:IsInMeleeRange(1 + 4) and v38 and (v79.DemonsBite:IsCastable() or v79.DemonBlades:IsAvailable())) then
			if (((5238 - 1803) > (3341 - (485 + 759))) and v21(v79.DemonsBite, not v15:IsInMeleeRange(11 - 6))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v99()
		local v111 = 1189 - (442 + 747);
		local v112;
		while true do
			if ((v111 == (1135 - (832 + 303))) or ((4716 - (88 + 858)) >= (1232 + 2809))) then
				if ((((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and (((not v79.Demonic:IsAvailable() or (v14:BuffRemains(v79.MetamorphosisBuff) < v14:GCD())) and (v79.EyeBeam:CooldownRemains() > (0 + 0)) and (not v79.EssenceBreak:IsAvailable() or v15:DebuffUp(v79.EssenceBreakDebuff)) and v14:BuffDown(v79.FelBarrageBuff)) or not v79.ChaoticTransformation:IsAvailable() or (v94 < (2 + 28)))) or ((4580 - (766 + 23)) <= (7953 - 6342))) then
					if (v21(v81.MetamorphosisPlayer, not v15:IsInRange(10 - 2)) or ((12061 - 7483) <= (6815 - 4807))) then
						return "metamorphosis cooldown 2";
					end
				end
				v112 = v23.HandleDPSPotion(v14:BuffUp(v79.MetamorphosisBuff));
				v111 = 1074 - (1036 + 37);
			end
			if (((798 + 327) <= (4042 - 1966)) and (v111 == (2 + 0))) then
				if ((((v31 and v58) or not v58) and v32 and v79.TheHunt:IsCastable() and v55 and v15:DebuffDown(v79.EssenceBreakDebuff) and (v10.CombatTime() > (1485 - (641 + 839)))) or ((1656 - (910 + 3)) >= (11214 - 6815))) then
					if (((2839 - (1466 + 218)) < (769 + 904)) and v21(v79.TheHunt, not v15:IsInRange(1188 - (556 + 592)))) then
						return "the_hunt cooldown 4";
					end
				end
				if ((v53 and not v14:IsMoving() and ((v31 and v56) or not v56) and v79.ElysianDecree:IsCastable() and (v15:DebuffDown(v79.EssenceBreakDebuff)) and (v85 > v60)) or ((827 + 1497) <= (1386 - (329 + 479)))) then
					if (((4621 - (174 + 680)) == (12943 - 9176)) and (v59 == "player")) then
						if (((8474 - 4385) == (2920 + 1169)) and v21(v81.ElysianDecreePlayer, not v15:IsInRange(747 - (396 + 343)))) then
							return "elysian_decree cooldown 6 (Player)";
						end
					elseif (((395 + 4063) >= (3151 - (29 + 1448))) and (v59 == "cursor")) then
						if (((2361 - (135 + 1254)) <= (5341 - 3923)) and v21(v81.ElysianDecreeCursor, not v15:IsInRange(140 - 110))) then
							return "elysian_decree cooldown 6 (Cursor)";
						end
					end
				end
				break;
			end
			if ((v111 == (1 + 0)) or ((6465 - (389 + 1138)) < (5336 - (102 + 472)))) then
				if (v112 or ((2364 + 140) > (2365 + 1899))) then
					return v112;
				end
				if (((2008 + 145) == (3698 - (320 + 1225))) and (v70 < v94)) then
					if ((v71 and ((v31 and v72) or not v72)) or ((901 - 394) >= (1586 + 1005))) then
						local v167 = 1464 - (157 + 1307);
						while true do
							if (((6340 - (821 + 1038)) == (11179 - 6698)) and (v167 == (0 + 0))) then
								v28 = v96();
								if (v28 or ((4134 - 1806) < (258 + 435))) then
									return v28;
								end
								break;
							end
						end
					end
				end
				v111 = 4 - 2;
			end
		end
	end
	local function v100()
		local v113 = 1026 - (834 + 192);
		while true do
			if (((276 + 4052) == (1111 + 3217)) and (v113 == (1 + 0))) then
				if (((2459 - 871) >= (1636 - (300 + 4))) and v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (not v79.ChaoticTransformation:IsAvailable() or v79.Metamorphosis:CooldownUp())) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(2 + 3)) or ((10926 - 6752) > (4610 - (112 + 250)))) then
						return "annihilation opener 5";
					end
				end
				if ((v79.EyeBeam:IsCastable() and v40 and v15:DebuffDown(v79.EssenceBreakDebuff) and v14:BuffDown(v79.InnerDemonBuff) and (not v14:BuffUp(v79.MetamorphosisBuff) or (v79.BladeDance:CooldownRemains() > (0 + 0)))) or ((11488 - 6902) <= (47 + 35))) then
					if (((1998 + 1865) == (2890 + 973)) and v21(v79.EyeBeam, not v15:IsInRange(4 + 4))) then
						return "eye_beam opener 6";
					end
				end
				if ((v79.FelRush:IsReady() and v43 and v32 and v79.Inertia:IsAvailable() and (v14:BuffDown(v79.InertiaBuff) or (v85 > (2 + 0))) and v14:BuffUp(v79.UnboundChaosBuff)) or ((1696 - (1001 + 413)) <= (93 - 51))) then
					if (((5491 - (244 + 638)) >= (1459 - (627 + 66))) and v21(v79.FelRush, not v15:IsInRange(44 - 29))) then
						return "fel_rush opener 7";
					end
				end
				if ((v79.TheHunt:IsCastable() and v55 and ((v31 and v58) or not v58) and v32) or ((1754 - (512 + 90)) == (4394 - (1665 + 241)))) then
					if (((4139 - (373 + 344)) > (1511 + 1839)) and v21(v79.TheHunt, not v15:IsInRange(11 + 29))) then
						return "the_hunt opener 8";
					end
				end
				v113 = 5 - 3;
			end
			if (((1484 - 607) > (1475 - (35 + 1064))) and (v113 == (2 + 0))) then
				if ((v79.EssenceBreak:IsCastable() and v39) or ((6670 - 3552) <= (8 + 1843))) then
					if (v21(v79.EssenceBreak, not v15:IsInMeleeRange(1241 - (298 + 938))) or ((1424 - (233 + 1026)) >= (5158 - (636 + 1030)))) then
						return "essence_break opener 9";
					end
				end
				if (((2019 + 1930) < (4744 + 112)) and v79.DeathSweep:IsCastable() and v37) then
					if (v21(v79.DeathSweep, not v15:IsInMeleeRange(2 + 3)) or ((289 + 3987) < (3237 - (55 + 166)))) then
						return "death_sweep opener 10";
					end
				end
				if (((909 + 3781) > (415 + 3710)) and v79.Annihilation:IsCastable() and v33) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(18 - 13)) or ((347 - (36 + 261)) >= (1566 - 670))) then
						return "annihilation opener 11";
					end
				end
				if ((v79.DemonsBite:IsCastable() and v38) or ((3082 - (34 + 1334)) >= (1138 + 1820))) then
					if (v21(v79.DemonsBite, not v15:IsInMeleeRange(4 + 1)) or ((2774 - (1035 + 248)) < (665 - (20 + 1)))) then
						return "demons_bite opener 12";
					end
				end
				break;
			end
			if (((367 + 337) < (1306 - (134 + 185))) and (v113 == (1133 - (549 + 584)))) then
				if (((4403 - (314 + 371)) > (6543 - 4637)) and v79.VengefulRetreat:IsCastable() and v48 and v32 and v14:PrevGCDP(969 - (478 + 490), v79.DeathSweep) and (v79.Felblade:CooldownRemains() == (0 + 0))) then
					if (v21(v79.VengefulRetreat, not v15:IsInRange(1180 - (786 + 386)), true, true) or ((3102 - 2144) > (5014 - (1055 + 324)))) then
						return "vengeful_retreat opener 1";
					end
				end
				if (((4841 - (1093 + 247)) <= (3992 + 500)) and v79.Metamorphosis:IsCastable() and v54 and ((v31 and v57) or not v57) and (v14:PrevGCDP(1 + 0, v79.DeathSweep) or (not v79.ChaoticTransformation:IsAvailable() and (not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (7 - 5)))) or not v79.Demonic:IsAvailable())) then
					if (v21(v81.MetamorphosisPlayer, not v15:IsInRange(26 - 18)) or ((9794 - 6352) < (6402 - 3854))) then
						return "metamorphosis opener 2";
					end
				end
				if (((1023 + 1852) >= (5639 - 4175)) and v79.Felblade:IsCastable() and v42 and v15:DebuffDown(v79.EssenceBreakDebuff)) then
					if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((16534 - 11737) >= (3690 + 1203))) then
						return "felblade opener 3";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and (v79.ImmolationAura:Charges() == (4 - 2)) and v14:BuffDown(v79.UnboundChaosBuff) and (v14:BuffDown(v79.InertiaBuff) or (v85 > (690 - (364 + 324))))) or ((1510 - 959) > (4962 - 2894))) then
					if (((701 + 1413) > (3949 - 3005)) and v21(v79.ImmolationAura, not v15:IsInRange(12 - 4))) then
						return "immolation_aura opener 4";
					end
				end
				v113 = 2 - 1;
			end
		end
	end
	local function v101()
		local v114 = 1268 - (1249 + 19);
		while true do
			if ((v114 == (1 + 0)) or ((8804 - 6542) >= (4182 - (686 + 400)))) then
				if ((v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff)) or ((1770 + 485) >= (3766 - (73 + 156)))) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(1 + 4)) or ((4648 - (721 + 90)) < (15 + 1291))) then
						return "annihilation fel_barrage 1";
					end
				end
				if (((9578 - 6628) == (3420 - (224 + 246))) and v79.EyeBeam:IsCastable() and v40 and v14:BuffDown(v79.FelBarrageBuff)) then
					if (v21(v79.EyeBeam, not v15:IsInRange(12 - 4)) or ((8695 - 3972) < (599 + 2699))) then
						return "eye_beam fel_barrage 3";
					end
				end
				if (((28 + 1108) >= (114 + 40)) and v79.EssenceBreak:IsCastable() and v39 and v14:BuffDown(v79.FelBarrageBuff) and v14:BuffUp(v79.MetamorphosisBuff)) then
					if (v21(v79.EssenceBreak, not v15:IsInMeleeRange(9 - 4)) or ((901 - 630) > (5261 - (203 + 310)))) then
						return "essence_break fel_barrage 5";
					end
				end
				v114 = 1995 - (1238 + 755);
			end
			if (((332 + 4408) >= (4686 - (709 + 825))) and (v114 == (0 - 0))) then
				v89 = (v79.Felblade:CooldownRemains() < v92) or (v79.SigilOfFlame:CooldownRemains() < v92);
				v90 = (((1 - 0) % ((866.6 - (196 + 668)) * v14:AttackHaste())) * (47 - 35)) + (v14:BuffStack(v79.ImmolationAuraBuff) * (12 - 6)) + (v24(v14:BuffUp(v79.TacticalRetreatBuff)) * (843 - (171 + 662)));
				v91 = v92 * (125 - (4 + 89));
				v114 = 3 - 2;
			end
			if ((v114 == (1 + 1)) or ((11323 - 8745) >= (1330 + 2060))) then
				if (((1527 - (35 + 1451)) <= (3114 - (28 + 1425))) and v79.DeathSweep:IsCastable() and v37 and v14:BuffDown(v79.FelBarrageBuff)) then
					if (((2594 - (941 + 1052)) < (3414 + 146)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(1519 - (822 + 692)))) then
						return "death_sweep fel_barrage 7";
					end
				end
				if (((335 - 100) < (324 + 363)) and v79.ImmolationAura:IsCastable() and v45 and v14:BuffDown(v79.UnboundChaosBuff) and ((v85 > (299 - (45 + 252))) or v14:BuffUp(v79.FelBarrageBuff))) then
					if (((4501 + 48) > (397 + 756)) and v21(v79.ImmolationAura, not v15:IsInRange(19 - 11))) then
						return "immolation_aura fel_barrage 9";
					end
				end
				if ((v79.GlaiveTempest:IsCastable() and v44 and v14:BuffDown(v79.FelBarrageBuff) and (v85 > (434 - (114 + 319)))) or ((6710 - 2036) < (5986 - 1314))) then
					if (((2339 + 1329) < (6794 - 2233)) and v21(v79.GlaiveTempest, not v15:IsInMeleeRange(10 - 5))) then
						return "glaive_tempest fel_barrage 11";
					end
				end
				v114 = 1966 - (556 + 1407);
			end
			if ((v114 == (1210 - (741 + 465))) or ((920 - (170 + 295)) == (1900 + 1705))) then
				if ((v46 and v79.SigilOfFlame:IsCastable() and (v14:FuryDeficit() > (37 + 3)) and v14:BuffUp(v79.FelBarrageBuff)) or ((6556 - 3893) == (2746 + 566))) then
					if (((2743 + 1534) <= (2535 + 1940)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(1238 - (957 + 273))) or ((233 + 637) == (476 + 713))) then
							return "sigil_of_flame fel_barrage 18";
						end
					elseif (((5917 - 4364) <= (8256 - 5123)) and (v78 == "cursor")) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(122 - 82)) or ((11076 - 8839) >= (5291 - (389 + 1391)))) then
							return "sigil_of_flame fel_barrage 18";
						end
					end
				end
				if ((v79.Felblade:IsCastable() and v42 and v14:BuffUp(v79.FelBarrageBuff) and (v14:FuryDeficit() > (26 + 14))) or ((138 + 1186) > (6875 - 3855))) then
					if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((3943 - (783 + 168)) == (6312 - 4431))) then
						return "felblade fel_barrage 19";
					end
				end
				if (((3056 + 50) > (1837 - (309 + 2))) and v79.DeathSweep:IsCastable() and v37 and (((v14:Fury() - v91) - (107 - 72)) > (1212 - (1090 + 122))) and ((v14:BuffRemains(v79.FelBarrageBuff) < (1 + 2)) or v89 or (v14:Fury() > (268 - 188)) or (v90 > (13 + 5)))) then
					if (((4141 - (628 + 490)) < (694 + 3176)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(12 - 7))) then
						return "death_sweep fel_barrage 21";
					end
				end
				v114 = 22 - 17;
			end
			if (((917 - (431 + 343)) > (149 - 75)) and (v114 == (17 - 11))) then
				if (((15 + 3) < (271 + 1841)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff)) then
					if (((2792 - (556 + 1139)) <= (1643 - (6 + 9))) and v21(v79.FelRush, not v15:IsInRange(3 + 12))) then
						return "fel_rush fel_barrage 29";
					end
				end
				if (((2372 + 2258) == (4799 - (28 + 141))) and v79.TheHunt:IsCastable() and v55 and ((v31 and v58) or not v58) and v32 and (v14:Fury() > (16 + 24))) then
					if (((4369 - 829) > (1901 + 782)) and v21(v79.TheHunt, not v15:IsInRange(1357 - (486 + 831)))) then
						return "the_hunt fel_barrage 31";
					end
				end
				if (((12475 - 7681) >= (11530 - 8255)) and v79.DemonsBite:IsCastable() and v38) then
					if (((281 + 1203) == (4692 - 3208)) and v21(v79.DemonsBite, not v15:IsInMeleeRange(1268 - (668 + 595)))) then
						return "demons_bite fel_barrage 33";
					end
				end
				break;
			end
			if (((1289 + 143) < (717 + 2838)) and (v114 == (13 - 8))) then
				if ((v79.GlaiveTempest:IsCastable() and v44 and (((v14:Fury() - v91) - (320 - (23 + 267))) > (1944 - (1129 + 815))) and ((v14:BuffRemains(v79.FelBarrageBuff) < (390 - (371 + 16))) or v89 or (v14:Fury() > (1830 - (1326 + 424))) or (v90 > (33 - 15)))) or ((3891 - 2826) > (3696 - (88 + 30)))) then
					if (v21(v79.GlaiveTempest, not v15:IsInMeleeRange(776 - (720 + 51))) or ((10666 - 5871) < (3183 - (421 + 1355)))) then
						return "glaive_tempest fel_barrage 23";
					end
				end
				if (((3056 - 1203) < (2365 + 2448)) and v79.BladeDance:IsCastable() and v34 and (((v14:Fury() - v91) - (1118 - (286 + 797))) > (0 - 0)) and ((v14:BuffRemains(v79.FelBarrageBuff) < (4 - 1)) or v89 or (v14:Fury() > (519 - (397 + 42))) or (v90 > (6 + 12)))) then
					if (v21(v79.BladeDance, not v15:IsInMeleeRange(805 - (24 + 776))) or ((4345 - 1524) < (3216 - (222 + 563)))) then
						return "blade_dance fel_barrage 25";
					end
				end
				if ((v79.ArcaneTorrent:IsCastable() and (v14:FuryDeficit() > (88 - 48)) and v14:BuffUp(v79.FelBarrageBuff)) or ((2070 + 804) < (2371 - (23 + 167)))) then
					if (v21(v79.ArcaneTorrent) or ((4487 - (690 + 1108)) <= (124 + 219))) then
						return "arcane_torrent fel_barrage 27";
					end
				end
				v114 = 5 + 1;
			end
			if (((851 - (40 + 808)) == v114) or ((308 + 1561) == (7682 - 5673))) then
				if ((v79.BladeDance:IsCastable() and v34 and v14:BuffDown(v79.FelBarrageBuff)) or ((3390 + 156) < (1229 + 1093))) then
					if (v21(v79.BladeDance, not v15:IsInMeleeRange(3 + 2)) or ((2653 - (47 + 524)) == (3098 + 1675))) then
						return "blade_dance fel_barrage 13";
					end
				end
				if (((8867 - 5623) > (1577 - 522)) and v79.FelBarrage:IsCastable() and v41 and (v14:Fury() > (228 - 128))) then
					if (v21(v79.FelBarrage, not v15:IsInMeleeRange(1731 - (1165 + 561))) or ((99 + 3214) <= (5506 - 3728))) then
						return "fel_barrage fel_barrage 15";
					end
				end
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v14:Fury() > (8 + 12)) and v14:BuffUp(v79.FelBarrageBuff)) or ((1900 - (341 + 138)) >= (568 + 1536))) then
					if (((3739 - 1927) <= (3575 - (89 + 237))) and v21(v79.FelRush, not v15:IsInRange(48 - 33))) then
						return "fel_rush fel_barrage 17";
					end
				end
				v114 = 8 - 4;
			end
		end
	end
	local function v102()
		local v115 = 881 - (581 + 300);
		while true do
			if (((2843 - (855 + 365)) <= (4648 - 2691)) and (v115 == (1 + 2))) then
				if (((5647 - (1030 + 205)) == (4142 + 270)) and v46 and v79.SigilOfFlame:IsCastable() and (v14:BuffRemains(v79.MetamorphosisBuff) > (5 + 0))) then
					if (((2036 - (156 + 130)) >= (1913 - 1071)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
						if (((7367 - 2995) > (3789 - 1939)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(3 + 5))) then
							return "sigil_of_flame meta 25";
						end
					elseif (((136 + 96) < (890 - (10 + 59))) and (v78 == "cursor")) then
						if (((147 + 371) < (4442 - 3540)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(1203 - (671 + 492)))) then
							return "sigil_of_flame meta 25";
						end
					end
				end
				if (((2384 + 610) > (2073 - (369 + 846))) and v79.Felblade:IsCastable() and v42) then
					if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((995 + 2760) <= (781 + 134))) then
						return "felblade meta 27";
					end
				end
				if (((5891 - (1036 + 909)) > (2976 + 767)) and v46 and v79.SigilOfFlame:IsCastable() and v15:DebuffDown(v79.EssenceBreakDebuff)) then
					if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((2241 - 906) >= (3509 - (11 + 192)))) then
						if (((2448 + 2396) > (2428 - (135 + 40))) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(19 - 11))) then
							return "sigil_of_flame meta 29";
						end
					elseif (((273 + 179) == (995 - 543)) and (v78 == "cursor")) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(59 - 19)) or ((4733 - (50 + 126)) < (5811 - 3724))) then
							return "sigil_of_flame meta 29";
						end
					end
				end
				if (((858 + 3016) == (5287 - (1233 + 180))) and v79.ImmolationAura:IsCastable() and v45 and v15:IsInRange(977 - (522 + 447)) and (v79.ImmolationAura:Recharge() < (v79.EyeBeam:CooldownRemains() < v14:BuffRemains(v79.MetamorphosisBuff)))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(1429 - (107 + 1314))) or ((900 + 1038) > (15037 - 10102))) then
						return "immolation_aura meta 31";
					end
				end
				v115 = 2 + 2;
			end
			if ((v115 == (7 - 3)) or ((16835 - 12580) < (5333 - (716 + 1194)))) then
				if (((25 + 1429) <= (267 + 2224)) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable()) then
					if (v21(v79.FelRush, not v15:IsInRange(518 - (74 + 429))) or ((8018 - 3861) <= (1390 + 1413))) then
						return "fel_rush meta 33";
					end
				end
				if (((11108 - 6255) >= (2110 + 872)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.FelRush:Recharge() < v79.EyeBeam:CooldownRemains()) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.EyeBeam:CooldownRemains() > (24 - 16)) or (v79.EyeBeam:ChargesFractional() > (2.01 - 1)))) then
					if (((4567 - (279 + 154)) > (4135 - (454 + 324))) and v21(v79.FelRush, not v15:IsInRange(12 + 3))) then
						return "fel_rush meta 35";
					end
				end
				if ((v79.DemonsBite:IsCastable() and v38) or ((3434 - (12 + 5)) < (1367 + 1167))) then
					if (v21(v79.DemonsBite, not v15:IsInMeleeRange(12 - 7)) or ((1006 + 1716) <= (1257 - (277 + 816)))) then
						return "demons_bite meta 37";
					end
				end
				break;
			end
			if ((v115 == (0 - 0)) or ((3591 - (1058 + 125)) < (396 + 1713))) then
				if ((v79.DeathSweep:IsCastable() and v37 and (v14:BuffRemains(v79.MetamorphosisBuff) < v92)) or ((1008 - (815 + 160)) == (6242 - 4787))) then
					if (v21(v79.DeathSweep, not v15:IsInMeleeRange(11 - 6)) or ((106 + 337) >= (11736 - 7721))) then
						return "death_sweep meta 1";
					end
				end
				if (((5280 - (41 + 1857)) > (2059 - (1222 + 671))) and v79.Annihilation:IsCastable() and v33 and (v14:BuffRemains(v79.MetamorphosisBuff) < v92)) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(12 - 7)) or ((402 - 122) == (4241 - (229 + 953)))) then
						return "annihilation meta 3";
					end
				end
				if (((3655 - (1111 + 663)) > (2872 - (874 + 705))) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable()) then
					if (((330 + 2027) == (1609 + 748)) and v21(v79.FelRush, not v15:IsInRange(31 - 16))) then
						return "fel_rush meta 5";
					end
				end
				if (((4 + 119) == (802 - (642 + 37))) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) < (v92 * (1 + 1)))) then
					if (v21(v79.FelRush, not v15:IsInRange(3 + 12)) or ((2651 - 1595) >= (3846 - (233 + 221)))) then
						return "fel_rush meta 7";
					end
				end
				v115 = 2 - 1;
			end
			if ((v115 == (2 + 0)) or ((2622 - (718 + 823)) < (677 + 398))) then
				if ((v79.EyeBeam:IsCastable() and v40 and v15:DebuffDown(v79.EssenceBreakDebuff) and v14:BuffDown(v79.InnerDemonBuff)) or ((1854 - (266 + 539)) >= (12547 - 8115))) then
					if (v21(v79.EyeBeam, not v15:IsInRange(1233 - (636 + 589))) or ((11317 - 6549) <= (1744 - 898))) then
						return "eye_beam meta 17";
					end
				end
				if ((v79.GlaiveTempest:IsCastable() and v44 and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.BladeDance:CooldownRemains() > (v92 * (2 + 0))) or (v14:Fury() > (22 + 38)))) or ((4373 - (657 + 358)) <= (3759 - 2339))) then
					if (v21(v79.GlaiveTempest, not v15:IsInMeleeRange(11 - 6)) or ((4926 - (1151 + 36)) <= (2902 + 103))) then
						return "glaive_tempest meta 19";
					end
				end
				if ((v46 and v79.SigilOfFlame:IsCastable() and (v85 > (1 + 1))) or ((4954 - 3295) >= (3966 - (1552 + 280)))) then
					if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((4094 - (64 + 770)) < (1599 + 756))) then
						if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(18 - 10)) or ((119 + 550) == (5466 - (157 + 1086)))) then
							return "sigil_of_flame meta 21";
						end
					elseif ((v78 == "cursor") or ((3386 - 1694) < (2575 - 1987))) then
						if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(61 - 21)) or ((6547 - 1750) < (4470 - (599 + 220)))) then
							return "sigil_of_flame meta 21";
						end
					end
				end
				if ((v79.Annihilation:IsCastable() and v33 and ((v79.BladeDance:CooldownRemains() > (v92 * (3 - 1))) or (v14:Fury() > (1991 - (1813 + 118))) or ((v14:BuffRemains(v79.MetamorphosisBuff) < (4 + 1)) and v79.Felblade:CooldownUp()))) or ((5394 - (841 + 376)) > (6796 - 1946))) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(2 + 3)) or ((1091 - 691) > (1970 - (464 + 395)))) then
						return "annihilation meta 23";
					end
				end
				v115 = 7 - 4;
			end
			if (((1466 + 1585) > (1842 - (467 + 370))) and (v115 == (1 - 0))) then
				if (((2711 + 982) <= (15021 - 10639)) and v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (((v79.EyeBeam:CooldownRemains() < (v92 * (1 + 2))) and (v79.BladeDance:CooldownRemains() > (0 - 0))) or (v79.Metamorphosis:CooldownRemains() < (v92 * (523 - (150 + 370)))))) then
					if (v21(v79.Annihilation, not v15:IsInMeleeRange(1287 - (74 + 1208))) or ((8071 - 4789) > (19444 - 15344))) then
						return "annihilation meta 9";
					end
				end
				if ((v79.EssenceBreak:IsCastable() and v39 and (v14:Fury() > (15 + 5)) and ((v79.Metamorphosis:CooldownRemains() > (400 - (14 + 376))) or (v79.BladeDance:CooldownRemains() < (v92 * (3 - 1)))) and (v14:BuffDown(v79.UnboundChaosBuff) or v14:BuffUp(v79.InertiaBuff) or not v79.Inertia:IsAvailable())) or (v94 < (7 + 3)) or ((3145 + 435) < (2713 + 131))) then
					if (((260 - 171) < (3378 + 1112)) and v21(v79.EssenceBreak, not v15:IsInMeleeRange(83 - (23 + 55)))) then
						return "essence_break meta 11";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and v15:DebuffDown(v79.EssenceBreakDebuff) and (v79.BladeDance:CooldownRemains() > (v92 + (0.5 - 0))) and v14:BuffDown(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and ((v79.ImmolationAura:FullRechargeTime() + 3 + 0) < v79.EyeBeam:CooldownRemains()) and (v14:BuffRemains(v79.MetamorphosisBuff) > (5 + 0))) or ((7725 - 2742) < (569 + 1239))) then
					if (((4730 - (652 + 249)) > (10086 - 6317)) and v21(v79.ImmolationAura, not v15:IsInRange(1876 - (708 + 1160)))) then
						return "immolation_aura meta 13";
					end
				end
				if (((4030 - 2545) <= (5294 - 2390)) and v79.DeathSweep:IsCastable() and v37) then
					if (((4296 - (10 + 17)) == (959 + 3310)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(1737 - (1400 + 332)))) then
						return "death_sweep meta 15";
					end
				end
				v115 = 3 - 1;
			end
		end
	end
	local function v103()
		v28 = v99();
		if (((2295 - (242 + 1666)) <= (1191 + 1591)) and v28) then
			return v28;
		end
		if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v14:BuffRemains(v79.UnboundChaosBuff) < (v92 * (1 + 1)))) or ((1619 + 280) <= (1857 - (850 + 90)))) then
			if (v21(v79.FelRush, not v15:IsInRange(25 - 10)) or ((5702 - (360 + 1030)) <= (776 + 100))) then
				return "fel_rush rotation 1";
			end
		end
		if (((6299 - 4067) <= (3570 - 974)) and v79.FelBarrage:IsAvailable()) then
			v88 = v79.FelBarrage:IsAvailable() and (v79.FelBarrage:CooldownRemains() < (v92 * (1668 - (909 + 752)))) and (((v85 >= (1225 - (109 + 1114))) and ((v79.Metamorphosis:CooldownRemains() > (0 - 0)) or (v85 > (1 + 1)))) or v14:BuffUp(v79.FelBarrageBuff));
		end
		if (((2337 - (6 + 236)) < (2323 + 1363)) and (v79.EyeBeam:CooldownUp() or v79.Metamorphosis:CooldownUp()) and (v10.CombatTime() < (13 + 2))) then
			local v129 = 0 - 0;
			while true do
				if ((v129 == (0 - 0)) or ((2728 - (1076 + 57)) >= (736 + 3738))) then
					v28 = v100();
					if (v28 or ((5308 - (579 + 110)) < (228 + 2654))) then
						return v28;
					end
					break;
				end
			end
		end
		if (v88 or ((260 + 34) >= (2564 + 2267))) then
			local v130 = 407 - (174 + 233);
			while true do
				if (((5667 - 3638) <= (5412 - 2328)) and ((0 + 0) == v130)) then
					v28 = v101();
					if (v28 or ((3211 - (663 + 511)) == (2159 + 261))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((968 + 3490) > (12035 - 8131)) and v79.ImmolationAura:IsCastable() and v45 and (v85 > (2 + 0)) and v79.Ragefire:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (not v79.FelBarrage:IsAvailable() or (v79.FelBarrage:CooldownRemains() > v79.ImmolationAura:Recharge())) and v15:DebuffDown(v79.EssenceBreakDebuff)) then
			if (((1026 - 590) >= (297 - 174)) and v21(v79.ImmolationAura, not v15:IsInRange(4 + 4))) then
				return "immolation_aura rotation 3";
			end
		end
		if (((973 - 473) < (1295 + 521)) and v79.ImmolationAura:IsCastable() and v45 and (v85 > (1 + 1)) and v79.Ragefire:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)) then
			if (((4296 - (478 + 244)) == (4091 - (440 + 77))) and v21(v79.ImmolationAura, not v15:IsInRange(4 + 4))) then
				return "immolation_aura rotation 5";
			end
		end
		if (((808 - 587) < (1946 - (655 + 901))) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v85 > (1 + 1)) and (not v79.Inertia:IsAvailable() or ((v79.EyeBeam:CooldownRemains() + 2 + 0) > v14:BuffRemains(v79.UnboundChaosBuff)))) then
			if (v21(v79.FelRush, not v15:IsInRange(11 + 4)) or ((8915 - 6702) <= (2866 - (695 + 750)))) then
				return "fel_rush rotation 7";
			end
		end
		if (((10442 - 7384) < (7500 - 2640)) and v79.VengefulRetreat:IsCastable() and v48 and v32 and v79.Felblade:IsCastable() and v79.Initiative:IsAvailable() and (((v79.EyeBeam:CooldownRemains() > (60 - 45)) and (v14:GCDRemains() < (351.3 - (285 + 66)))) or ((v14:GCDRemains() < (0.1 - 0)) and (v79.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and ((v79.Metamorphosis:CooldownRemains() > (1320 - (682 + 628))) or (v79.BladeDance:CooldownRemains() < (v92 * (1 + 1)))))) and (v10.CombatTime() > (303 - (176 + 123)))) then
			if (v21(v79.VengefulRetreat, not v15:IsInRange(4 + 4), true, true) or ((941 + 355) >= (4715 - (239 + 30)))) then
				return "vengeful_retreat rotation 9";
			end
		end
		if (v88 or (not v79.DemonBlades:IsAvailable() and v79.FelBarrage:IsAvailable() and (v14:BuffUp(v79.FelBarrageBuff) or (v79.FelBarrage:CooldownRemains() > (0 + 0))) and v14:BuffDown(v79.MetamorphosisBuff)) or ((1339 + 54) > (7944 - 3455))) then
			local v131 = 0 - 0;
			while true do
				if (((315 - (306 + 9)) == v131) or ((15437 - 11013) < (5 + 22))) then
					v28 = v101();
					if (v28 or ((1226 + 771) > (1837 + 1978))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((9908 - 6443) > (3288 - (1140 + 235))) and v14:BuffUp(v79.MetamorphosisBuff)) then
			local v132 = 0 + 0;
			while true do
				if (((673 + 60) < (467 + 1352)) and (v132 == (52 - (33 + 19)))) then
					v28 = v102();
					if (v28 or ((1587 + 2808) == (14251 - 9496))) then
						return v28;
					end
					break;
				end
			end
		end
		if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and (v79.BladeDance:CooldownRemains() < (2 + 2)) and (v79.EyeBeam:CooldownRemains() > (9 - 4)) and ((v79.ImmolationAura:Charges() > (0 + 0)) or ((v79.ImmolationAura:Recharge() + (691 - (586 + 103))) < v79.EyeBeam:CooldownRemains()) or (v79.EyeBeam:CooldownRemains() > (v14:BuffRemains(v79.UnboundChaosBuff) - (1 + 1))))) or ((11677 - 7884) < (3857 - (1309 + 179)))) then
			if (v21(v79.FelRush, not v15:IsInRange(27 - 12)) or ((1778 + 2306) == (711 - 446))) then
				return "fel_rush rotation 11";
			end
		end
		if (((3292 + 1066) == (9258 - 4900)) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v92 * (3 - 1)))) then
			if (v21(v79.FelRush, not v15:IsInRange(624 - (295 + 314))) or ((7707 - 4569) < (2955 - (1300 + 662)))) then
				return "fel_rush rotation 13";
			end
		end
		if (((10456 - 7126) > (4078 - (1178 + 577))) and v79.ImmolationAura:IsCastable() and v45 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.ImmolationAura:FullRechargeTime() < (v92 * (2 + 0))) and (v94 > v79.ImmolationAura:FullRechargeTime())) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(23 - 15)) or ((5031 - (851 + 554)) == (3528 + 461))) then
				return "immolation_aura rotation 15";
			end
		end
		if ((v79.ImmolationAura:IsCastable() and v45 and (v85 > (5 - 3)) and v14:BuffDown(v79.UnboundChaosBuff)) or ((1989 - 1073) == (2973 - (115 + 187)))) then
			if (((209 + 63) == (258 + 14)) and v21(v79.ImmolationAura, not v15:IsInRange(31 - 23))) then
				return "immolation_aura rotation 17";
			end
		end
		if (((5410 - (160 + 1001)) <= (4234 + 605)) and v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (v79.EyeBeam:CooldownRemains() < (4 + 1))) then
			if (((5684 - 2907) < (3558 - (237 + 121))) and v21(v79.ImmolationAura, not v15:IsInRange(905 - (525 + 372)))) then
				return "immolation_aura rotation 19";
			end
		end
		if (((179 - 84) < (6429 - 4472)) and v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.ImmolationAura:Recharge() + (147 - (96 + 46))) < v79.EyeBeam:CooldownRemains()) and (v79.BladeDance:CooldownRemains() > (777 - (643 + 134))) and (v79.BladeDance:CooldownRemains() < (2 + 2)) and (v79.ImmolationAura:ChargesFractional() > (2 - 1))) then
			if (((3066 - 2240) < (1647 + 70)) and v21(v79.ImmolationAura, not v15:IsInRange(15 - 7))) then
				return "immolation_aura rotation 21";
			end
		end
		if (((2914 - 1488) >= (1824 - (316 + 403))) and v79.ImmolationAura:IsCastable() and v45 and (v94 < (10 + 5)) and (v79.BladeDance:CooldownRemains() > (0 - 0))) then
			if (((996 + 1758) <= (8509 - 5130)) and v21(v79.ImmolationAura, not v15:IsInRange(6 + 2))) then
				return "immolation_aura rotation 23";
			end
		end
		if ((v79.EyeBeam:IsCastable() and v40 and not v79.EssenceBreak:IsAvailable() and (not v79.ChaoticTransformation:IsAvailable() or (v79.Metamorphosis:CooldownRemains() < (2 + 3 + ((10 - 7) * v24(v79.ShatteredDestiny:IsAvailable())))) or (v79.Metamorphosis:CooldownRemains() > (71 - 56)))) or ((8157 - 4230) == (81 + 1332))) then
			if (v21(v79.EyeBeam, not v15:IsInRange(15 - 7)) or ((57 + 1097) <= (2318 - 1530))) then
				return "eye_beam rotation 25";
			end
		end
		if ((v79.EyeBeam:IsCastable() and v40 and v79.EssenceBreak:IsAvailable() and ((v79.EssenceBreak:CooldownRemains() < ((v92 * (19 - (12 + 5))) + ((19 - 14) * v24(v79.ShatteredDestiny:IsAvailable())))) or (v79.ShatteredDestiny:IsAvailable() and (v79.EssenceBreak:CooldownRemains() > (21 - 11)))) and ((v79.BladeDance:CooldownRemains() < (14 - 7)) or (v85 > (2 - 1))) and (not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (3 + 7)) or (v85 > (1974 - (1656 + 317)))) and (not v79.Inertia:IsAvailable() or v14:BuffUp(v79.UnboundChaosBuff) or ((v79.ImmolationAura:Charges() == (0 + 0)) and (v79.ImmolationAura:Recharge() > (5 + 0))))) or (v94 < (26 - 16)) or ((8086 - 6443) > (3733 - (5 + 349)))) then
			if (v21(v79.EyeBeam, not v15:IsInRange(37 - 29)) or ((4074 - (266 + 1005)) > (2998 + 1551))) then
				return "eye_beam rotation 27";
			end
		end
		if ((v79.BladeDance:IsCastable() and v34 and ((v79.EyeBeam:CooldownRemains() > v92) or v79.EyeBeam:CooldownUp())) or ((750 - 530) >= (3978 - 956))) then
			if (((4518 - (561 + 1135)) == (3676 - 854)) and v21(v79.BladeDance, not v15:IsInRange(16 - 11))) then
				return "blade_dance rotation 29";
			end
		end
		if ((v79.GlaiveTempest:IsCastable() and v44 and (v85 >= (1068 - (507 + 559)))) or ((2662 - 1601) == (5743 - 3886))) then
			if (((3148 - (212 + 176)) > (2269 - (250 + 655))) and v21(v79.GlaiveTempest, not v15:IsInRange(21 - 13))) then
				return "glaive_tempest rotation 31";
			end
		end
		if ((v46 and (v85 > (5 - 2)) and v79.SigilOfFlame:IsCastable()) or ((7669 - 2767) <= (5551 - (1869 + 87)))) then
			if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((13360 - 9508) == (2194 - (484 + 1417)))) then
				if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(16 - 8)) or ((2612 - 1053) == (5361 - (48 + 725)))) then
					return "sigil_of_flame rotation 33";
				end
			elseif ((v78 == "cursor") or ((7324 - 2840) == (2113 - 1325))) then
				if (((2655 + 1913) >= (10440 - 6533)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(12 + 28))) then
					return "sigil_of_flame rotation 33";
				end
			end
		end
		if (((364 + 882) < (4323 - (152 + 701))) and v79.ChaosStrike:IsCastable() and v35 and v15:DebuffUp(v79.EssenceBreakDebuff)) then
			if (((5379 - (430 + 881)) >= (373 + 599)) and v21(v79.ChaosStrike, not v15:IsInMeleeRange(900 - (557 + 338)))) then
				return "chaos_strike rotation 35";
			end
		end
		if (((146 + 347) < (10970 - 7077)) and v79.Felblade:IsCastable() and v42) then
			if (v21(v79.Felblade, not v15:IsInMeleeRange(17 - 12)) or ((3913 - 2440) >= (7180 - 3848))) then
				return "felblade rotation 37";
			end
		end
		if ((v79.ThrowGlaive:IsCastable() and v47 and (v79.ThrowGlaive:FullRechargeTime() <= v79.BladeDance:CooldownRemains()) and (v79.Metamorphosis:CooldownRemains() > (806 - (499 + 302))) and v79.Soulscar:IsAvailable() and v14:HasTier(897 - (39 + 827), 5 - 3) and not v14:PrevGCDP(2 - 1, v79.VengefulRetreat)) or ((16089 - 12038) <= (1776 - 619))) then
			if (((52 + 552) < (8432 - 5551)) and v21(v79.ThrowGlaive, not v15:IsInMeleeRange(5 + 25))) then
				return "throw_glaive rotation 39";
			end
		end
		if ((v79.ThrowGlaive:IsCastable() and v47 and not v14:HasTier(48 - 17, 106 - (103 + 1)) and ((v85 > (555 - (475 + 79))) or v79.Soulscar:IsAvailable()) and not v14:PrevGCDP(2 - 1, v79.VengefulRetreat)) or ((2880 - 1980) == (437 + 2940))) then
			if (((3925 + 534) > (2094 - (1395 + 108))) and v21(v79.ThrowGlaive, not v15:IsInMeleeRange(87 - 57))) then
				return "throw_glaive rotation 41";
			end
		end
		if (((4602 - (7 + 1197)) >= (1045 + 1350)) and v79.ChaosStrike:IsCastable() and v35 and ((v79.EyeBeam:CooldownRemains() > (v92 * (1 + 1))) or (v14:Fury() > (399 - (27 + 292))))) then
			if (v21(v79.ChaosStrike, not v15:IsInMeleeRange(14 - 9)) or ((2783 - 600) >= (11843 - 9019))) then
				return "chaos_strike rotation 43";
			end
		end
		if (((3817 - 1881) == (3687 - 1751)) and v79.ImmolationAura:IsCastable() and v45 and not v79.Inertia:IsAvailable() and (v85 > (141 - (43 + 96)))) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(32 - 24)) or ((10924 - 6092) < (3579 + 734))) then
				return "immolation_aura rotation 45";
			end
		end
		if (((1155 + 2933) > (7656 - 3782)) and v46 and not v15:IsInRange(4 + 4) and v15:DebuffDown(v79.EssenceBreakDebuff) and (not v79.FelBarrage:IsAvailable() or (v79.FelBarrage:CooldownRemains() > (46 - 21))) and v79.SigilOfFlame:IsCastable()) then
			if (((1364 + 2968) == (318 + 4014)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
				if (((5750 - (1414 + 337)) >= (4840 - (1642 + 298))) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(20 - 12))) then
					return "sigil_of_flame rotation 47";
				end
			elseif ((v78 == "cursor") or ((7263 - 4738) > (12060 - 7996))) then
				if (((1439 + 2932) == (3401 + 970)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(1012 - (357 + 615)))) then
					return "sigil_of_flame rotation 47";
				end
			end
		end
		if ((v79.DemonsBite:IsCastable() and v38) or ((187 + 79) > (12233 - 7247))) then
			if (((1706 + 285) >= (1982 - 1057)) and v21(v79.DemonsBite, not v15:IsInMeleeRange(4 + 1))) then
				return "demons_bite rotation 49";
			end
		end
		if (((31 + 424) < (1291 + 762)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.FelRush:Recharge() < v79.EyeBeam:CooldownRemains()) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.EyeBeam:CooldownRemains() > (1309 - (384 + 917))) or (v79.FelRush:ChargesFractional() > (698.01 - (128 + 569))))) then
			if (v21(v79.FelRush, not v15:IsInRange(1558 - (1407 + 136))) or ((2713 - (687 + 1200)) == (6561 - (556 + 1154)))) then
				return "fel_rush rotation 51";
			end
		end
		if (((643 - 460) == (278 - (9 + 86))) and v79.ArcaneTorrent:IsCastable() and not v14:IsMoving() and v15:IsInRange(429 - (275 + 146)) and v15:DebuffDown(v79.EssenceBreakDebuff) and (v14:Fury() < (17 + 83))) then
			if (((1223 - (29 + 35)) <= (7924 - 6136)) and v21(v79.ArcaneTorrent, not v15:IsInRange(23 - 15))) then
				return "arcane_torrent rotation 53";
			end
		end
	end
	local function v104()
		local v116 = 0 - 0;
		while true do
			if ((v116 == (4 + 1)) or ((4519 - (53 + 959)) > (4726 - (312 + 96)))) then
				v57 = EpicSettings.Settings['metamorphosisWithCD'];
				v58 = EpicSettings.Settings['theHuntWithCD'];
				v59 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v60 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
				break;
			end
			if ((v116 == (287 - (147 + 138))) or ((3974 - (813 + 86)) <= (2680 + 285))) then
				v41 = EpicSettings.Settings['useFelBarrage'];
				v42 = EpicSettings.Settings['useFelblade'];
				v43 = EpicSettings.Settings['useFelRush'];
				v44 = EpicSettings.Settings['useGlaiveTempest'];
				v116 = 4 - 1;
			end
			if (((1857 - (18 + 474)) <= (679 + 1332)) and ((9 - 6) == v116)) then
				v45 = EpicSettings.Settings['useImmolationAura'];
				v46 = EpicSettings.Settings['useSigilOfFlame'];
				v47 = EpicSettings.Settings['useThrowGlaive'];
				v48 = EpicSettings.Settings['useVengefulRetreat'];
				v116 = 1090 - (860 + 226);
			end
			if ((v116 == (303 - (121 + 182))) or ((342 + 2434) > (4815 - (988 + 252)))) then
				v33 = EpicSettings.Settings['useAnnihilation'];
				v34 = EpicSettings.Settings['useBladeDance'];
				v35 = EpicSettings.Settings['useChaosStrike'];
				v36 = EpicSettings.Settings['useConsumeMagic'];
				v116 = 1 + 0;
			end
			if ((v116 == (1 + 0)) or ((4524 - (49 + 1921)) == (5694 - (223 + 667)))) then
				v37 = EpicSettings.Settings['useDeathSweep'];
				v38 = EpicSettings.Settings['useDemonsBite'];
				v39 = EpicSettings.Settings['useEssenceBreak'];
				v40 = EpicSettings.Settings['useEyeBeam'];
				v116 = 54 - (51 + 1);
			end
			if (((4434 - 1857) == (5517 - 2940)) and ((1129 - (146 + 979)) == v116)) then
				v53 = EpicSettings.Settings['useElysianDecree'];
				v54 = EpicSettings.Settings['useMetamorphosis'];
				v55 = EpicSettings.Settings['useTheHunt'];
				v56 = EpicSettings.Settings['elysianDecreeWithCD'];
				v116 = 2 + 3;
			end
		end
	end
	local function v105()
		local v117 = 605 - (311 + 294);
		while true do
			if ((v117 == (2 - 1)) or ((3 + 3) >= (3332 - (496 + 947)))) then
				v51 = EpicSettings.Settings['useFelEruption'];
				v52 = EpicSettings.Settings['useSigilOfMisery'];
				v117 = 1360 - (1233 + 125);
			end
			if (((206 + 300) <= (1698 + 194)) and (v117 == (1 + 2))) then
				v63 = EpicSettings.Settings['blurHP'] or (1645 - (963 + 682));
				v64 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
				v117 = 1508 - (504 + 1000);
			end
			if (((0 + 0) == v117) or ((1829 + 179) > (210 + 2008))) then
				v49 = EpicSettings.Settings['useChaosNova'];
				v50 = EpicSettings.Settings['useDisrupt'];
				v117 = 1 - 0;
			end
			if (((324 + 55) <= (2412 + 1735)) and (v117 == (184 - (156 + 26)))) then
				v61 = EpicSettings.Settings['useBlur'];
				v62 = EpicSettings.Settings['useNetherwalk'];
				v117 = 2 + 1;
			end
			if ((v117 == (6 - 2)) or ((4678 - (149 + 15)) <= (1969 - (890 + 70)))) then
				v78 = EpicSettings.Settings['sigilSetting'] or "";
				break;
			end
		end
	end
	local function v106()
		v70 = EpicSettings.Settings['fightRemainsCheck'] or (117 - (39 + 78));
		v65 = EpicSettings.Settings['dispelBuffs'];
		v67 = EpicSettings.Settings['InterruptWithStun'];
		v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v69 = EpicSettings.Settings['InterruptThreshold'];
		v71 = EpicSettings.Settings['useTrinkets'];
		v72 = EpicSettings.Settings['trinketsWithCD'];
		v74 = EpicSettings.Settings['useHealthstone'];
		v73 = EpicSettings.Settings['useHealingPotion'];
		v76 = EpicSettings.Settings['healthstoneHP'] or (482 - (14 + 468));
		v75 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v77 = EpicSettings.Settings['HealingPotionName'] or "";
		v66 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v107()
		local v127 = 0 - 0;
		while true do
			if (((2 + 1) == v127) or ((2100 + 1396) == (254 + 938))) then
				v84 = v14:GetEnemiesInMeleeRange(10 + 10);
				if (v30 or ((55 + 153) == (5663 - 2704))) then
					v85 = ((#v83 > (0 + 0)) and #v83) or (3 - 2);
					v86 = #v84;
				else
					local v165 = 0 + 0;
					while true do
						if (((4328 - (12 + 39)) >= (1222 + 91)) and (v165 == (0 - 0))) then
							v85 = 3 - 2;
							v86 = 1 + 0;
							break;
						end
					end
				end
				v92 = v14:GCD() + 0.05 + 0;
				v127 = 9 - 5;
			end
			if (((1724 + 863) < (15339 - 12165)) and (v127 == (1715 - (1596 + 114)))) then
				if (v66 or ((10756 - 6636) <= (2911 - (164 + 549)))) then
					v28 = v23.HandleIncorporeal(v79.Imprison, v81.ImprisonMouseover, 1468 - (1059 + 379), true);
					if (v28 or ((1981 - 385) == (445 + 413))) then
						return v28;
					end
				end
				if (((543 + 2677) == (3612 - (145 + 247))) and (v14:PrevGCDP(1 + 0, v79.VengefulRetreat) or v14:PrevGCDP(1 + 1, v79.VengefulRetreat) or (v14:PrevGCDP(8 - 5, v79.VengefulRetreat) and v14:IsMoving()))) then
					if ((v79.Felblade:IsCastable() and v42) or ((269 + 1133) > (3119 + 501))) then
						if (((4179 - 1605) == (3294 - (254 + 466))) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
							return "felblade rotation 1";
						end
					end
				elseif (((2358 - (544 + 16)) < (8761 - 6004)) and v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					local v168 = 628 - (294 + 334);
					while true do
						if ((v168 == (254 - (236 + 17))) or ((163 + 214) > (2027 + 577))) then
							if (((2139 - 1571) < (4313 - 3402)) and v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v95, v15:NPCID())) then
								if (((1692 + 1593) < (3483 + 745)) and v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive))) then
									return "fodder to the flames react per target";
								end
							end
							if (((4710 - (413 + 381)) > (141 + 3187)) and v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v95, v16:NPCID())) then
								if (((5317 - 2817) < (9971 - 6132)) and v21(v81.ThrowGlaiveMouseover, not v15:IsSpellInRange(v79.ThrowGlaive))) then
									return "fodder to the flames react per mouseover";
								end
							end
							v168 = 1972 - (582 + 1388);
						end
						if (((863 - 356) == (363 + 144)) and (v168 == (364 - (326 + 38)))) then
							if (((709 - 469) <= (4518 - 1353)) and not v14:AffectingCombat() and v29) then
								v28 = v98();
								if (((1454 - (47 + 573)) >= (284 + 521)) and v28) then
									return v28;
								end
							end
							if ((v79.ConsumeMagic:IsAvailable() and v36 and v79.ConsumeMagic:IsReady() and v65 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) or ((16189 - 12377) < (3758 - 1442))) then
								if (v21(v79.ConsumeMagic, not v15:IsSpellInRange(v79.ConsumeMagic)) or ((4316 - (1269 + 395)) <= (2025 - (76 + 416)))) then
									return "greater_purge damage";
								end
							end
							v168 = 444 - (319 + 124);
						end
						if ((v168 == (4 - 2)) or ((4605 - (564 + 443)) < (4041 - 2581))) then
							v28 = v103();
							if (v28 or ((4574 - (337 + 121)) < (3492 - 2300))) then
								return v28;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v127 == (6 - 4)) or ((5288 - (1261 + 650)) <= (383 + 520))) then
				v32 = EpicSettings.Toggles['movement'];
				if (((6335 - 2359) >= (2256 - (772 + 1045))) and v14:IsDeadOrGhost()) then
					return v28;
				end
				v83 = v14:GetEnemiesInMeleeRange(2 + 6);
				v127 = 147 - (102 + 42);
			end
			if (((5596 - (1524 + 320)) == (5022 - (1049 + 221))) and (v127 == (156 - (18 + 138)))) then
				v105();
				v104();
				v106();
				v127 = 2 - 1;
			end
			if (((5148 - (67 + 1035)) > (3043 - (136 + 212))) and (v127 == (4 - 3))) then
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v127 = 2 + 0;
			end
			if (((4 + 0) == v127) or ((5149 - (240 + 1364)) == (4279 - (1050 + 32)))) then
				if (((8547 - 6153) > (221 + 152)) and (v23.TargetIsValid() or v14:AffectingCombat())) then
					local v166 = 1055 - (331 + 724);
					while true do
						if (((336 + 3819) <= (4876 - (269 + 375))) and (v166 == (726 - (267 + 458)))) then
							if ((v94 == (3456 + 7655)) or ((6886 - 3305) == (4291 - (667 + 151)))) then
								v94 = v10.FightRemains(v83, false);
							end
							break;
						end
						if (((6492 - (1410 + 87)) > (5245 - (1504 + 393))) and (v166 == (0 - 0))) then
							v93 = v10.BossFightRemains(nil, true);
							v94 = v93;
							v166 = 2 - 1;
						end
					end
				end
				v28 = v97();
				if (v28 or ((1550 - (461 + 335)) > (476 + 3248))) then
					return v28;
				end
				v127 = 1766 - (1730 + 31);
			end
		end
	end
	local function v108()
		v79.BurningWoundDebuff:RegisterAuraTracking();
		v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(2244 - (728 + 939), v107, v108);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

