local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (4 - 3)) or ((215 + 2688) == (71 + 1424))) then
			return v6(...);
		end
		if (((6143 - (978 + 619)) >= (3629 - (243 + 1111))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((977 - (91 + 67)) >= (65 - 43)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v33 = false;
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
	local v81;
	local v82 = v18.DemonHunter.Havoc;
	local v83 = v19.DemonHunter.Havoc;
	local v84 = v22.DemonHunter.Havoc;
	local v85 = {};
	local v86, v87;
	local v88, v89;
	local v90 = {{v82.FelEruption},{v82.ChaosNova}};
	local v91 = false;
	local v92 = false;
	local v93 = 771 - (326 + 445);
	local v94 = 0 - 0;
	local v95 = v14:GCD() + (0.25 - 0);
	local v96 = 25935 - 14824;
	local v97 = 11822 - (530 + 181);
	local v98 = {(169453 - (19 + 13)),(394817 - 225392),(43873 + 125059),(351363 - 181937),(345687 - 176258),(324000 - 154572),(399132 - 229702)};
	v10:RegisterForEvent(function()
		local v112 = 0 + 0;
		while true do
			if (((646 + 2516) == (7346 - 4184)) and (v112 == (0 + 0))) then
				v91 = false;
				v96 = 3692 + 7419;
				v112 = 1 + 0;
			end
			if ((v112 == (1097 - (709 + 387))) or ((4227 - (673 + 1185)) > (12844 - 8415))) then
				v97 = 35679 - 24568;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v99()
		local v113 = 0 - 0;
		while true do
			if (((2929 + 1166) >= (2379 + 804)) and ((1 - 0) == v113)) then
				v28 = v23.HandleBottomTrinket(v85, v31, 10 + 30, nil);
				if (v28 or ((7399 - 3688) < (1978 - 970))) then
					return v28;
				end
				break;
			end
			if ((v113 == (1880 - (446 + 1434))) or ((2332 - (1040 + 243)) <= (2704 - 1798))) then
				v28 = v23.HandleTopTrinket(v85, v31, 1887 - (559 + 1288), nil);
				if (((6444 - (609 + 1322)) > (3180 - (13 + 441))) and v28) then
					return v28;
				end
				v113 = 3 - 2;
			end
		end
	end
	local function v100()
		local v114 = 0 - 0;
		while true do
			if ((v114 == (4 - 3)) or ((56 + 1425) >= (9653 - 6995))) then
				if ((v83.Healthstone:IsReady() and v75 and (v14:HealthPercentage() <= v77)) or ((1144 + 2076) == (598 + 766))) then
					if (v21(v84.Healthstone) or ((3127 - 2073) > (1857 + 1535))) then
						return "healthstone defensive";
					end
				end
				if ((v74 and (v14:HealthPercentage() <= v76)) or ((1242 - 566) >= (1086 + 556))) then
					local v169 = 0 + 0;
					while true do
						if (((2972 + 1164) > (2013 + 384)) and (v169 == (0 + 0))) then
							if ((v78 == "Refreshing Healing Potion") or ((4767 - (153 + 280)) == (12257 - 8012))) then
								if (v83.RefreshingHealingPotion:IsReady() or ((3839 + 437) <= (1197 + 1834))) then
									if (v21(v84.RefreshingHealingPotion) or ((2503 + 2279) <= (1089 + 110))) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v78 == "Dreamwalker's Healing Potion") or ((3525 + 1339) < (2895 - 993))) then
								if (((2991 + 1848) >= (4367 - (89 + 578))) and v83.DreamwalkersHealingPotion:IsReady()) then
									if (v21(v84.RefreshingHealingPotion) or ((768 + 307) > (3987 - 2069))) then
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
			if (((1445 - (572 + 477)) <= (514 + 3290)) and (v114 == (0 + 0))) then
				if ((v82.Blur:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) or ((498 + 3671) == (2273 - (84 + 2)))) then
					if (((2316 - 910) == (1013 + 393)) and v21(v82.Blur)) then
						return "blur defensive";
					end
				end
				if (((2373 - (497 + 345)) < (110 + 4161)) and v82.Netherwalk:IsCastable() and v63 and (v14:HealthPercentage() <= v65)) then
					if (((108 + 527) == (1968 - (605 + 728))) and v21(v82.Netherwalk)) then
						return "netherwalk defensive";
					end
				end
				v114 = 1 + 0;
			end
		end
	end
	local function v101()
		local v115 = 0 - 0;
		while true do
			if (((155 + 3218) <= (13147 - 9591)) and (v115 == (2 + 0))) then
				if ((not v15:IsInMeleeRange(13 - 8) and v82.FelRush:IsCastable() and (not v82.Felblade:IsAvailable() or (v82.Felblade:CooldownUp() and not v14:PrevGCDP(1 + 0, v82.Felblade))) and v32 and ((not v33 and v80) or not v80) and v44) or ((3780 - (457 + 32)) < (1392 + 1888))) then
					if (((5788 - (832 + 570)) >= (823 + 50)) and v21(v82.FelRush, not v15:IsInRange(4 + 11))) then
						return "fel_rush precombat 10";
					end
				end
				if (((3259 - 2338) <= (531 + 571)) and v15:IsInMeleeRange(801 - (588 + 208)) and v39 and (v82.DemonsBite:IsCastable() or v82.DemonBlades:IsAvailable())) then
					if (((12683 - 7977) >= (2763 - (884 + 916))) and v21(v82.DemonsBite, not v15:IsInMeleeRange(10 - 5))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
			if ((v115 == (1 + 0)) or ((1613 - (232 + 421)) <= (2765 - (1569 + 320)))) then
				if ((not v15:IsInMeleeRange(2 + 3) and v82.Felblade:IsCastable() and v43) or ((393 + 1673) == (3140 - 2208))) then
					if (((5430 - (316 + 289)) < (12677 - 7834)) and v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade))) then
						return "felblade precombat 9";
					end
				end
				if ((not v15:IsInMeleeRange(1 + 4) and v82.ThrowGlaive:IsCastable() and v48 and not v14:PrevGCDP(1454 - (666 + 787), v82.VengefulRetreat)) or ((4302 - (360 + 65)) >= (4241 + 296))) then
					if (v21(v82.ThrowGlaive, not v15:IsSpellInRange(v82.ThrowGlaive)) or ((4569 - (79 + 175)) < (2721 - 995))) then
						return "throw_glaive precombat 9";
					end
				end
				v115 = 2 + 0;
			end
			if ((v115 == (0 - 0)) or ((7084 - 3405) < (1524 - (503 + 396)))) then
				if ((v82.ImmolationAura:IsCastable() and v46) or ((4806 - (92 + 89)) < (1225 - 593))) then
					if (v21(v82.ImmolationAura, not v15:IsInRange(5 + 3)) or ((50 + 33) > (6970 - 5190))) then
						return "immolation_aura precombat 8";
					end
				end
				if (((75 + 471) <= (2455 - 1378)) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving() and (v88 > (1 + 0)) and v82.SigilOfFlame:IsCastable()) then
					if ((v79 == "player") or v82.ConcentratedSigils:IsAvailable() or ((476 + 520) > (13099 - 8798))) then
						if (((508 + 3562) > (1046 - 359)) and v21(v84.SigilOfFlamePlayer, not v15:IsInRange(1252 - (485 + 759)))) then
							return "sigil_of_flame precombat 9";
						end
					elseif ((v79 == "cursor") or ((1517 - 861) >= (4519 - (442 + 747)))) then
						if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(1175 - (832 + 303))) or ((3438 - (88 + 858)) <= (103 + 232))) then
							return "sigil_of_flame precombat 9";
						end
					end
				end
				v115 = 1 + 0;
			end
		end
	end
	local function v102()
		if (((179 + 4143) >= (3351 - (766 + 23))) and v82.DeathSweep:IsReady() and (v14:BuffRemains(v82.MetamorphosisBuff) < v95) and v38) then
			if (v21(v82.DeathSweep, not v15:IsInMeleeRange(39 - 31)) or ((4974 - 1337) >= (9932 - 6162))) then
				return "death_sweep meta 2";
			end
		end
		if ((v82.Annihilation:IsReady() and (v14:BuffRemains(v82.MetamorphosisBuff) < v95) and v34) or ((8074 - 5695) > (5651 - (1036 + 37)))) then
			if (v21(v82.Annihilation, not v15:IsInMeleeRange(4 + 1)) or ((940 - 457) > (585 + 158))) then
				return "annihilation meta 4";
			end
		end
		if (((3934 - (641 + 839)) > (1491 - (910 + 3))) and v82.FelRush:IsCastable() and v44 and ((v14:BuffUp(v82.UnboundChaosBuff) and v82.Inertia:IsAvailable()) or (v82.Momentum:IsAvailable() and (v14:BuffRemains(v82.MomentumBuff) < (v95 * (4 - 2))))) and v44 and v32 and ((not v33 and v80) or not v80)) then
			if (((2614 - (1466 + 218)) < (2049 + 2409)) and v21(v82.FelRush, not v15:IsInRange(1163 - (556 + 592)))) then
				return "fel_rush meta 6";
			end
		end
		if (((236 + 426) <= (1780 - (329 + 479))) and v82.Annihilation:IsReady() and v14:BuffUp(v82.InnerDemonBuff) and (((v82.EyeBeam:CooldownRemains() < (v95 * (857 - (174 + 680)))) and v82.BladeDance:CooldownUp()) or (v82.Metamorphosis:CooldownRemains() < (v95 * (10 - 7)))) and v34) then
			if (((9057 - 4687) == (3121 + 1249)) and v21(v82.Annihilation, not v15:IsInMeleeRange(744 - (396 + 343)))) then
				return "annihilation meta 8";
			end
		end
		if ((v82.EssenceBreak:IsCastable() and (((v14:Fury() > (2 + 18)) and ((v82.Metamorphosis:CooldownRemains() > (1487 - (29 + 1448))) or (v82.BladeDance:CooldownRemains() < (v95 * (1391 - (135 + 1254))))) and (v14:BuffDown(v82.UnboundChaosBuff) or v14:BuffUp(v82.InertiaBuff) or not v82.Inertia:IsAvailable())) or (v97 < (37 - 27))) and v40) or ((22234 - 17472) <= (574 + 287))) then
			if (v21(v82.EssenceBreak, not v15:IsInMeleeRange(1532 - (389 + 1138))) or ((1986 - (102 + 472)) == (4024 + 240))) then
				return "essence_break meta 10";
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v15:DebuffDown(v82.EssenceBreakDebuff) and (v82.BladeDance:CooldownRemains() > (v95 + 0.5 + 0)) and v14:BuffDown(v82.UnboundChaosBuff) and v82.Inertia:IsAvailable() and v14:BuffDown(v82.InertiaBuff) and ((v82.ImmolationAura:FullRechargeTime() + 3 + 0) < v82.EyeBeam:CooldownRemains()) and (v14:BuffRemains(v82.MetamorphosisBuff) > (1550 - (320 + 1225))) and v46) or ((5639 - 2471) < (1318 + 835))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(1472 - (157 + 1307))) or ((6835 - (821 + 1038)) < (3323 - 1991))) then
				return "immolation_aura meta 12";
			end
		end
		if (((507 + 4121) == (8220 - 3592)) and v82.DeathSweep:IsReady() and v38) then
			if (v21(v82.DeathSweep, not v15:IsInMeleeRange(3 + 5)) or ((133 - 79) == (1421 - (834 + 192)))) then
				return "death_sweep meta 14";
			end
		end
		if (((6 + 76) == (22 + 60)) and v82.EyeBeam:IsReady() and v15:DebuffDown(v82.EssenceBreakDebuff) and v14:BuffDown(v82.InnerDemonBuff) and v41) then
			if (v21(v82.EyeBeam, not v15:IsInRange(1 + 7)) or ((899 - 318) < (586 - (300 + 4)))) then
				return "eye_beam meta 16";
			end
		end
		if ((v82.GlaiveTempest:IsReady() and v15:DebuffDown(v82.EssenceBreakDebuff) and ((v82.BladeDance:CooldownRemains() > (v95 * (1 + 1))) or (v14:Fury() > (157 - 97))) and v45) or ((4971 - (112 + 250)) < (995 + 1500))) then
			if (((2885 - 1733) == (660 + 492)) and v21(v82.GlaiveTempest, not v15:IsInMeleeRange(3 + 2), false, true)) then
				return "glaive_tempest meta 18";
			end
		end
		if (((1418 + 478) <= (1697 + 1725)) and v82.SigilOfFlame:IsCastable() and (v88 > (2 + 0)) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving()) then
			if ((v79 == "player") or v82.ConcentratedSigils:IsAvailable() or ((2404 - (1001 + 413)) > (3612 - 1992))) then
				if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(890 - (244 + 638))) or ((1570 - (627 + 66)) > (13989 - 9294))) then
					return "sigil_of_flame meta 20";
				end
			elseif (((3293 - (512 + 90)) >= (3757 - (1665 + 241))) and (v79 == "cursor")) then
				if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(757 - (373 + 344))) or ((1347 + 1638) >= (1285 + 3571))) then
					return "sigil_of_flame meta 20";
				end
			end
		end
		if (((11278 - 7002) >= (2021 - 826)) and v82.Annihilation:IsReady() and ((v82.BladeDance:CooldownRemains() > (v95 * (1101 - (35 + 1064)))) or (v14:Fury() > (44 + 16)) or ((v14:BuffRemains(v82.MetamorphosisBuff) < (10 - 5)) and v82.Felblade:CooldownUp())) and v34) then
			if (((13 + 3219) <= (5926 - (298 + 938))) and v21(v82.Annihilation, not v15:IsInMeleeRange(1264 - (233 + 1026)))) then
				return "annihilation meta 22";
			end
		end
		if ((v82.SigilOfFlame:IsCastable() and (v14:BuffRemains(v82.MetamorphosisBuff) > (1671 - (636 + 1030))) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving()) or ((459 + 437) >= (3073 + 73))) then
			if (((910 + 2151) >= (200 + 2758)) and ((v79 == "player") or v82.ConcentratedSigils:IsAvailable())) then
				if (((3408 - (55 + 166)) >= (125 + 519)) and v21(v84.SigilOfFlamePlayer, not v15:IsInRange(1 + 7))) then
					return "sigil_of_flame meta 24";
				end
			elseif (((2459 - 1815) <= (1001 - (36 + 261))) and (v79 == "cursor")) then
				if (((1675 - 717) > (2315 - (34 + 1334))) and v21(v84.SigilOfFlameCursor, not v15:IsInRange(16 + 24))) then
					return "sigil_of_flame meta 24";
				end
			end
		end
		if (((3491 + 1001) >= (3937 - (1035 + 248))) and v82.Felblade:IsCastable() and v43) then
			if (((3463 - (20 + 1)) >= (784 + 719)) and v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade))) then
				return "felblade meta 26";
			end
		end
		if ((v82.SigilOfFlame:IsCastable() and (v15:DebuffDown(v82.EssenceBreakDebuff)) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving()) or ((3489 - (134 + 185)) <= (2597 - (549 + 584)))) then
			if ((v79 == "player") or v82.ConcentratedSigils:IsAvailable() or ((5482 - (314 + 371)) == (15063 - 10675))) then
				if (((1519 - (478 + 490)) <= (361 + 320)) and v21(v84.SigilOfFlamePlayer, not v15:IsInRange(1180 - (786 + 386)))) then
					return "sigil_of_flame meta 28";
				end
			elseif (((10614 - 7337) > (1786 - (1055 + 324))) and (v79 == "cursor")) then
				if (((6035 - (1093 + 247)) >= (1258 + 157)) and v21(v84.SigilOfFlameCursor, not v15:IsInRange(5 + 35))) then
					return "sigil_of_flame meta 28";
				end
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v15:IsInRange(31 - 23) and (v82.ImmolationAura:Recharge() < (v27(v82.EyeBeam:CooldownRemains(), v14:BuffRemains(v82.MetamorphosisBuff)))) and v46) or ((10900 - 7688) <= (2685 - 1741))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(19 - 11)) or ((1102 + 1994) <= (6926 - 5128))) then
				return "immolation_aura meta 30";
			end
		end
		if (((12191 - 8654) == (2668 + 869)) and v82.FelRush:IsCastable() and v44 and (v82.Momentum:IsAvailable()) and v32 and ((not v33 and v80) or not v80)) then
			if (((9812 - 5975) >= (2258 - (364 + 324))) and v21(v82.FelRush, not v15:IsInRange(40 - 25))) then
				return "fel_rush meta 32";
			end
		end
		if ((v82.FelRush:IsCastable() and v44 and v14:BuffDown(v82.UnboundChaosBuff) and (v82.FelRush:Recharge() < v82.EyeBeam:CooldownRemains()) and v15:DebuffDown(v82.EssenceBreakDebuff) and ((v82.EyeBeam:CooldownRemains() > (19 - 11)) or (v82.FelRush:ChargesFractional() > (1.01 + 0))) and v15:IsInRange(62 - 47) and v32 and ((not v33 and v80) or not v80)) or ((4724 - 1774) == (11577 - 7765))) then
			if (((5991 - (1249 + 19)) >= (2093 + 225)) and v21(v82.FelRush, not v15:IsInRange(58 - 43))) then
				return "fel_rush meta 34";
			end
		end
		if ((v82.DemonsBite:IsCastable() and v39) or ((3113 - (686 + 400)) > (2238 + 614))) then
			if (v21(v82.DemonsBite, not v15:IsInMeleeRange(234 - (73 + 156))) or ((6 + 1130) > (5128 - (721 + 90)))) then
				return "demons_bite meta 36";
			end
		end
	end
	local function v103()
		if (((54 + 4694) == (15416 - 10668)) and ((v31 and v58) or not v58) and v82.Metamorphosis:IsCastable() and v55 and (not v82.Initiative:IsAvailable() or (v82.VengefulRetreat:CooldownRemains() > (470 - (224 + 246)))) and (((not v82.Demonic:IsAvailable() or v14:PrevGCDP(1 - 0, v82.DeathSweep) or v14:PrevGCDP(3 - 1, v82.DeathSweep) or v14:PrevGCDP(1 + 2, v82.DeathSweep)) and v82.EyeBeam:CooldownDown() and (not v82.EssenceBreak:IsAvailable() or v15:DebuffUp(v82.EssenceBreakDebuff)) and v14:BuffDown(v82.FelBarrage)) or not v82.ChaoticTransformation:IsAvailable() or (v96 < (1 + 29)))) then
			if (((2745 + 991) <= (9423 - 4683)) and v21(v84.MetamorphosisPlayer, not v15:IsInRange(26 - 18))) then
				return "metamorphosis cooldown 2";
			end
		end
		local v116 = v23.HandleDPSPotion(v14:BuffUp(v82.MetamorphosisBuff));
		if (v116 or ((3903 - (203 + 310)) <= (5053 - (1238 + 755)))) then
			return v116;
		end
		if ((v71 < v97) or ((70 + 929) > (4227 - (709 + 825)))) then
			if (((852 - 389) < (875 - 274)) and v72 and ((v31 and v73) or not v73)) then
				v28 = v99();
				if (v28 or ((3047 - (196 + 668)) < (2712 - 2025))) then
					return v28;
				end
			end
		end
		if (((9422 - 4873) == (5382 - (171 + 662))) and ((v31 and v59) or not v59) and v32 and ((not v33 and v80) or not v80) and v82.TheHunt:IsCastable() and v56 and v15:DebuffDown(v82.EssenceBreakDebuff) and (v10.CombatTime() > (98 - (4 + 89)))) then
			if (((16375 - 11703) == (1702 + 2970)) and v21(v82.TheHunt, not v15:IsInRange(175 - 135))) then
				return "the_hunt cooldown 4";
			end
		end
		if ((v54 and ((not v33 and v81) or not v81) and not v14:IsMoving() and ((v31 and v57) or not v57) and v82.ElysianDecree:IsCastable() and (v15:DebuffDown(v82.EssenceBreakDebuff)) and (v88 > v61)) or ((1439 + 2229) < (1881 - (35 + 1451)))) then
			if ((v60 == "player") or ((5619 - (28 + 1425)) == (2448 - (941 + 1052)))) then
				if (v21(v84.ElysianDecreePlayer, not v15:IsInRange(8 + 0)) or ((5963 - (822 + 692)) == (3801 - 1138))) then
					return "elysian_decree cooldown 6 (Player)";
				end
			elseif ((v60 == "cursor") or ((2015 + 2262) < (3286 - (45 + 252)))) then
				if (v21(v84.ElysianDecreeCursor, not v15:IsInRange(30 + 0)) or ((300 + 570) >= (10097 - 5948))) then
					return "elysian_decree cooldown 6 (Cursor)";
				end
			end
		end
	end
	local function v104()
		local v117 = 433 - (114 + 319);
		while true do
			if (((3175 - 963) < (4078 - 895)) and (v117 == (1 + 0))) then
				if (((6921 - 2275) > (6268 - 3276)) and v82.ImmolationAura:IsCastable() and v46 and (v82.ImmolationAura:Charges() == (1965 - (556 + 1407))) and v14:BuffDown(v82.UnboundChaosBuff) and (v14:BuffDown(v82.InertiaBuff) or (v88 > (1208 - (741 + 465))))) then
					if (((1899 - (170 + 295)) < (1637 + 1469)) and v21(v82.ImmolationAura, not v15:IsInRange(8 + 0))) then
						return "immolation_aura opener 4";
					end
				end
				if (((1934 - 1148) < (2506 + 517)) and v82.Annihilation:IsCastable() and v34 and v14:BuffUp(v82.InnerDemonBuff) and (not v82.ChaoticTransformation:IsAvailable() or v82.Metamorphosis:CooldownUp())) then
					if (v21(v82.Annihilation, not v15:IsInMeleeRange(4 + 1)) or ((1383 + 1059) < (1304 - (957 + 273)))) then
						return "annihilation opener 5";
					end
				end
				if (((1213 + 3322) == (1816 + 2719)) and v82.EyeBeam:IsCastable() and v41 and v15:DebuffDown(v82.EssenceBreakDebuff) and v14:BuffDown(v82.InnerDemonBuff) and (not v14:BuffUp(v82.MetamorphosisBuff) or (v82.BladeDance:CooldownRemains() > (0 - 0)))) then
					if (v21(v82.EyeBeam, not v15:IsInRange(21 - 13)) or ((9190 - 6181) <= (10423 - 8318))) then
						return "eye_beam opener 6";
					end
				end
				v117 = 1782 - (389 + 1391);
			end
			if (((1149 + 681) < (382 + 3287)) and (v117 == (6 - 3))) then
				if ((v82.DeathSweep:IsCastable() and v38) or ((2381 - (783 + 168)) >= (12122 - 8510))) then
					if (((2640 + 43) >= (2771 - (309 + 2))) and v21(v82.DeathSweep, not v15:IsInMeleeRange(15 - 10))) then
						return "death_sweep opener 10";
					end
				end
				if ((v82.Annihilation:IsCastable() and v34) or ((3016 - (1090 + 122)) >= (1062 + 2213))) then
					if (v21(v82.Annihilation, not v15:IsInMeleeRange(16 - 11)) or ((970 + 447) > (4747 - (628 + 490)))) then
						return "annihilation opener 11";
					end
				end
				if (((860 + 3935) > (994 - 592)) and v82.DemonsBite:IsCastable() and v39) then
					if (((21995 - 17182) > (4339 - (431 + 343))) and v21(v82.DemonsBite, not v15:IsInMeleeRange(10 - 5))) then
						return "demons_bite opener 12";
					end
				end
				break;
			end
			if (((11316 - 7404) == (3091 + 821)) and (v117 == (1 + 1))) then
				if (((4516 - (556 + 1139)) <= (4839 - (6 + 9))) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v82.Inertia:IsAvailable() and (v14:BuffDown(v82.InertiaBuff) or (v88 > (1 + 1))) and v14:BuffUp(v82.UnboundChaosBuff)) then
					if (((891 + 847) <= (2364 - (28 + 141))) and v21(v82.FelRush, not v15:IsInRange(6 + 9))) then
						return "fel_rush opener 7";
					end
				end
				if (((50 - 9) <= (2138 + 880)) and v82.TheHunt:IsCastable() and v56 and ((v31 and v59) or not v59) and v32 and ((not v33 and v80) or not v80)) then
					if (((3462 - (486 + 831)) <= (10679 - 6575)) and v21(v82.TheHunt, not v15:IsInRange(140 - 100))) then
						return "the_hunt opener 8";
					end
				end
				if (((509 + 2180) < (15319 - 10474)) and v82.EssenceBreak:IsCastable() and v40) then
					if (v21(v82.EssenceBreak, not v15:IsInMeleeRange(1268 - (668 + 595))) or ((2090 + 232) > (529 + 2093))) then
						return "essence_break opener 9";
					end
				end
				v117 = 8 - 5;
			end
			if ((v117 == (290 - (23 + 267))) or ((6478 - (1129 + 815)) == (2469 - (371 + 16)))) then
				if ((v82.VengefulRetreat:IsCastable() and v49 and v32 and ((not v33 and v80) or not v80) and v14:PrevGCDP(1751 - (1326 + 424), v82.DeathSweep) and (v82.Felblade:CooldownRemains() == (0 - 0))) or ((5740 - 4169) > (1985 - (88 + 30)))) then
					if (v21(v82.VengefulRetreat, not v15:IsInRange(779 - (720 + 51)), true, true) or ((5903 - 3249) >= (4772 - (421 + 1355)))) then
						return "vengeful_retreat opener 1";
					end
				end
				if (((6562 - 2584) > (1034 + 1070)) and v82.Metamorphosis:IsCastable() and v55 and ((v31 and v58) or not v58) and (v14:PrevGCDP(1084 - (286 + 797), v82.DeathSweep) or (not v82.ChaoticTransformation:IsAvailable() and (not v82.Initiative:IsAvailable() or (v82.VengefulRetreat:CooldownRemains() > (7 - 5)))) or not v82.Demonic:IsAvailable())) then
					if (((4960 - 1965) > (1980 - (397 + 42))) and v21(v84.MetamorphosisPlayer, not v15:IsInRange(3 + 5))) then
						return "metamorphosis opener 2";
					end
				end
				if (((4049 - (24 + 776)) > (1467 - 514)) and v82.Felblade:IsCastable() and v43 and v15:DebuffDown(v82.EssenceBreakDebuff)) then
					if (v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade)) or ((4058 - (222 + 563)) > (10075 - 5502))) then
						return "felblade opener 3";
					end
				end
				v117 = 1 + 0;
			end
		end
	end
	local function v105()
		v92 = (v82.Felblade:CooldownRemains() < v95) or (v82.SigilOfFlame:CooldownRemains() < v95);
		v93 = (((191 - (23 + 167)) / ((1800.6 - (690 + 1108)) * v14:SpellHaste())) * (5 + 7)) + (v14:BuffStack(v82.ImmolationAura) * (5 + 1)) + (v24(v14:BuffUp(v82.TacticalRetreatBuff)) * (858 - (40 + 808)));
		v94 = v95 * (6 + 26);
		if ((v82.Annihilation:IsReady() and (v14:BuffUp(v82.InnerDemonBuff)) and v34) or ((12049 - 8898) < (1228 + 56))) then
			if (v21(v82.Annihilation, not v15:IsInMeleeRange(3 + 2)) or ((1015 + 835) == (2100 - (47 + 524)))) then
				return "annihilation fel_barrage 2";
			end
		end
		if (((533 + 288) < (5803 - 3680)) and v82.EyeBeam:IsReady() and (v14:BuffDown(v82.FelBarrage)) and v41) then
			if (((1348 - 446) < (5302 - 2977)) and v21(v82.EyeBeam, not v15:IsInRange(1734 - (1165 + 561)))) then
				return "eye_beam fel_barrage 4";
			end
		end
		if (((26 + 832) <= (9173 - 6211)) and v82.EssenceBreak:IsCastable() and v14:BuffDown(v82.FelBarrage) and v14:BuffUp(v82.MetamorphosisBuff) and v40) then
			if (v21(v82.EssenceBreak, not v15:IsInMeleeRange(2 + 3)) or ((4425 - (341 + 138)) < (348 + 940))) then
				return "essence_break fel_barrage 6";
			end
		end
		if ((v82.DeathSweep:IsReady() and (v14:BuffDown(v82.FelBarrage)) and v38) or ((6690 - 3448) == (893 - (89 + 237)))) then
			if (v21(v82.DeathSweep, not v15:IsInMeleeRange(16 - 11)) or ((1782 - 935) >= (2144 - (581 + 300)))) then
				return "death_sweep fel_barrage 8";
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v14:BuffDown(v82.UnboundChaosBuff) and ((v88 > (1222 - (855 + 365))) or v14:BuffUp(v82.FelBarrage)) and v46) or ((5351 - 3098) == (605 + 1246))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(1243 - (1030 + 205))) or ((1960 + 127) > (2207 + 165))) then
				return "immolation_aura fel_barrage 10";
			end
		end
		if ((v82.GlaiveTempest:IsReady() and v14:BuffDown(v82.FelBarrage) and (v88 > (287 - (156 + 130))) and v45) or ((10099 - 5654) < (6992 - 2843))) then
			if (v21(v82.GlaiveTempest, not v15:IsInMeleeRange(10 - 5)) or ((480 + 1338) == (50 + 35))) then
				return "glaive_tempest fel_barrage 12";
			end
		end
		if (((699 - (10 + 59)) < (602 + 1525)) and v82.BladeDance:IsReady() and (v14:BuffDown(v82.FelBarrage)) and v35) then
			if (v21(v82.BladeDance, not v15:IsInMeleeRange(39 - 31)) or ((3101 - (671 + 492)) == (2002 + 512))) then
				return "blade_dance fel_barrage 14";
			end
		end
		if (((5470 - (369 + 846)) >= (15 + 40)) and v82.FelBarrage:IsReady() and (v14:Fury() > (86 + 14)) and v42) then
			if (((4944 - (1036 + 909)) > (920 + 236)) and v21(v82.FelBarrage, not v15:IsInMeleeRange(8 - 3))) then
				return "fel_barrage fel_barrage 16";
			end
		end
		if (((2553 - (11 + 192)) > (584 + 571)) and v82.FelRush:IsCastable() and v44 and v14:BuffUp(v82.UnboundChaosBuff) and (v14:Fury() > (195 - (135 + 40))) and v14:BuffUp(v82.FelBarrage) and v32 and ((not v33 and v80) or not v80)) then
			if (((9761 - 5732) <= (2926 + 1927)) and v21(v82.FelRush, not v15:IsInRange(32 - 17))) then
				return "fel_rush fel_barrage 18";
			end
		end
		if ((v82.SigilOfFlame:IsCastable() and (v14:FuryDeficit() > (59 - 19)) and v14:BuffUp(v82.FelBarrage) and v47 and ((not v33 and v81) or not v81) and not v14:IsMoving()) or ((692 - (50 + 126)) > (9562 - 6128))) then
			if (((896 + 3150) >= (4446 - (1233 + 180))) and ((v79 == "player") or v82.ConcentratedSigils:IsAvailable())) then
				if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(977 - (522 + 447))) or ((4140 - (107 + 1314)) <= (672 + 775))) then
					return "sigil_of_flame fel_barrage 20";
				end
			elseif ((v79 == "cursor") or ((12596 - 8462) < (1668 + 2258))) then
				if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(79 - 39)) or ((648 - 484) >= (4695 - (716 + 1194)))) then
					return "sigil_of_flame fel_barrage 20";
				end
			end
		end
		if ((v82.Felblade:IsCastable() and v14:BuffUp(v82.FelBarrage) and (v14:FuryDeficit() > (1 + 39)) and v43) or ((57 + 468) == (2612 - (74 + 429)))) then
			if (((63 - 30) == (17 + 16)) and v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade))) then
				return "felblade fel_barrage 22";
			end
		end
		if (((6990 - 3936) <= (2841 + 1174)) and v82.DeathSweep:IsReady() and (((v14:Fury() - v94) - (107 - 72)) > (0 - 0)) and ((v14:BuffRemains(v82.FelBarrage) < (436 - (279 + 154))) or v92 or (v14:Fury() > (858 - (454 + 324))) or (v93 > (15 + 3))) and v38) then
			if (((1888 - (12 + 5)) < (1824 + 1558)) and v21(v82.DeathSweep, not v15:IsInMeleeRange(12 - 7))) then
				return "death_sweep fel_barrage 24";
			end
		end
		if (((478 + 815) <= (3259 - (277 + 816))) and v82.GlaiveTempest:IsReady() and (((v14:Fury() - v94) - (128 - 98)) > (1183 - (1058 + 125))) and ((v14:BuffRemains(v82.FelBarrage) < (1 + 2)) or v92 or (v14:Fury() > (1055 - (815 + 160))) or (v93 > (77 - 59))) and v45) then
			if (v21(v82.GlaiveTempest, not v15:IsInMeleeRange(11 - 6), false, true) or ((616 + 1963) < (359 - 236))) then
				return "glaive_tempest fel_barrage 26";
			end
		end
		if ((v82.BladeDance:IsReady() and (((v14:Fury() - v94) - (1933 - (41 + 1857))) > (1893 - (1222 + 671))) and ((v14:BuffRemains(v82.FelBarrage) < (7 - 4)) or v92 or (v14:Fury() > (114 - 34)) or (v93 > (1200 - (229 + 953)))) and v35) or ((2620 - (1111 + 663)) >= (3947 - (874 + 705)))) then
			if (v21(v82.BladeDance, not v15:IsInMeleeRange(2 + 6)) or ((2738 + 1274) <= (6979 - 3621))) then
				return "blade_dance fel_barrage 28";
			end
		end
		if (((43 + 1451) <= (3684 - (642 + 37))) and v82.ArcaneTorrent:IsCastable() and (v14:FuryDeficit() > (10 + 30)) and v14:BuffUp(v82.FelBarrage)) then
			if (v21(v82.ArcaneTorrent) or ((498 + 2613) == (5357 - 3223))) then
				return "arcane_torrent fel_barrage 30";
			end
		end
		if (((2809 - (233 + 221)) == (5445 - 3090)) and v82.FelRush:IsCastable() and v44 and (v14:BuffUp(v82.UnboundChaosBuff)) and v32 and ((not v33 and v80) or not v80)) then
			if (v21(v82.FelRush, not v15:IsInRange(8 + 0)) or ((2129 - (718 + 823)) <= (272 + 160))) then
				return "fel_rush fel_barrage 32";
			end
		end
		if (((5602 - (266 + 539)) >= (11027 - 7132)) and v82.TheHunt:IsCastable() and v56 and ((v31 and v59) or not v59) and v32 and ((not v33 and v80) or not v80) and (v14:Fury() > (1265 - (636 + 589)))) then
			if (((8490 - 4913) == (7377 - 3800)) and v21(v82.TheHunt, not v15:IsInRange(32 + 8))) then
				return "the_hunt fel_barrage 31";
			end
		end
		if (((1379 + 2415) > (4708 - (657 + 358))) and v82.DemonsBite:IsCastable() and v39) then
			if (v21(v82.DemonsBite, not v15:IsInMeleeRange(13 - 8)) or ((2904 - 1629) == (5287 - (1151 + 36)))) then
				return "demons_bite fel_barrage 33";
			end
		end
	end
	local function v106()
		v91 = v82.FelBarrage:IsAvailable() and (((v82.FelBarrage:CooldownRemains() < (v95 * (7 + 0))) and (v82.Metamorphosis:CooldownDown() or (v88 > (1 + 1)))) or v14:BuffUp(v82.FelBarrage));
		v28 = v103();
		if (v28 or ((4751 - 3160) >= (5412 - (1552 + 280)))) then
			return v28;
		end
		if (((1817 - (64 + 770)) <= (1228 + 580)) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and (v14:BuffRemains(v82.UnboundChaosBuff) < (v95 * (4 - 2)))) then
			if (v21(v82.FelRush, not v15:IsInRange(3 + 12)) or ((3393 - (157 + 1086)) <= (2395 - 1198))) then
				return "fel_rush rotation 1";
			end
		end
		if (((16507 - 12738) >= (1798 - 625)) and (v82.EyeBeam:CooldownUp() or v82.Metamorphosis:CooldownUp()) and (v10.CombatTime() < (19 - 4))) then
			v28 = v104();
			if (((2304 - (599 + 220)) == (2956 - 1471)) and v28) then
				return v28;
			end
		end
		if (v91 or ((5246 - (1813 + 118)) <= (2034 + 748))) then
			v28 = v105();
			if (v28 or ((2093 - (841 + 376)) >= (4153 - 1189))) then
				return v28;
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v46 and (v88 > (1 + 1)) and v82.Ragefire:IsAvailable() and v14:BuffDown(v82.UnboundChaosBuff) and (not v82.FelBarrage:IsAvailable() or (v82.FelBarrage:CooldownRemains() > v82.ImmolationAura:Recharge())) and v15:DebuffDown(v82.EssenceBreakDebuff)) or ((6092 - 3860) > (3356 - (464 + 395)))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(20 - 12)) or ((1014 + 1096) <= (1169 - (467 + 370)))) then
				return "immolation_aura rotation 3";
			end
		end
		if (((7616 - 3930) > (2329 + 843)) and v82.ImmolationAura:IsCastable() and v46 and (v88 > (6 - 4)) and v82.Ragefire:IsAvailable() and v15:DebuffDown(v82.EssenceBreakDebuff)) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(2 + 6)) or ((10408 - 5934) < (1340 - (150 + 370)))) then
				return "immolation_aura rotation 5";
			end
		end
		if (((5561 - (74 + 1208)) >= (7088 - 4206)) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and (v88 > (9 - 7)) and (not v82.Inertia:IsAvailable() or ((v82.EyeBeam:CooldownRemains() + 2 + 0) > v14:BuffRemains(v82.UnboundChaosBuff)))) then
			if (v21(v82.FelRush, not v15:IsInRange(405 - (14 + 376))) or ((3518 - 1489) >= (2279 + 1242))) then
				return "fel_rush rotation 7";
			end
		end
		if ((v82.VengefulRetreat:IsCastable() and v49 and v32 and ((not v33 and v80) or not v80) and v82.Initiative:IsAvailable() and ((v82.EyeBeam:CooldownRemains() > (14 + 1)) or ((v82.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and ((v82.Metamorphosis:CooldownRemains() > (10 + 0)) or (v82.BladeDance:CooldownRemains() < (v95 * (5 - 3)))))) and (v10.CombatTime() > (4 + 0))) or ((2115 - (23 + 55)) >= (11000 - 6358))) then
			if (((1148 + 572) < (4004 + 454)) and v21(v82.VengefulRetreat, not v15:IsInRange(11 - 3), true, true)) then
				return "vengeful_retreat rotation 9";
			end
		end
		if (v91 or (not v82.DemonBlades:IsAvailable() and v82.FelBarrage:IsAvailable() and (v14:BuffUp(v82.FelBarrage) or v82.FelBarrage:CooldownUp()) and v14:BuffDown(v82.MetamorphosisBuff)) or ((138 + 298) > (3922 - (652 + 249)))) then
			v28 = v105();
			if (((1908 - 1195) <= (2715 - (708 + 1160))) and v28) then
				return v28;
			end
		end
		if (((5846 - 3692) <= (7349 - 3318)) and v14:BuffUp(v82.MetamorphosisBuff)) then
			v28 = v102();
			if (((4642 - (10 + 17)) == (1037 + 3578)) and v28) then
				return v28;
			end
		end
		if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffUp(v82.UnboundChaosBuff) and v82.Inertia:IsAvailable() and v14:BuffDown(v82.InertiaBuff) and (v82.BladeDance:CooldownRemains() < (1736 - (1400 + 332))) and (v82.EyeBeam:CooldownRemains() > (9 - 4)) and ((v82.ImmolationAura:Charges() > (1908 - (242 + 1666))) or ((v82.ImmolationAura:Recharge() + 1 + 1) < v82.EyeBeam:CooldownRemains()) or (v82.EyeBeam:CooldownRemains() > (v14:BuffRemains(v82.UnboundChaosBuff) - (1 + 1))))) or ((3230 + 560) == (1440 - (850 + 90)))) then
			if (((155 - 66) < (1611 - (360 + 1030))) and v21(v82.FelRush, not v15:IsInRange(14 + 1))) then
				return "fel_rush rotation 11";
			end
		end
		if (((5797 - 3743) >= (1954 - 533)) and v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v82.Momentum:IsAvailable() and (v82.EyeBeam:CooldownRemains() < (v95 * (1663 - (909 + 752))))) then
			if (((1915 - (109 + 1114)) < (5598 - 2540)) and v21(v82.FelRush, not v15:IsInRange(6 + 9))) then
				return "fel_rush rotation 13";
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v46 and ((v14:BuffDown(v82.UnboundChaosBuff) and (v82.ImmolationAura:FullRechargeTime() < (v95 * (244 - (6 + 236))))) or ((v88 > (1 + 0)) and v14:BuffDown(v82.UnboundChaosBuff)) or (v82.Inertia:IsAvailable() and v14:BuffDown(v82.UnboundChaosBuff) and (v82.EyeBeam:CooldownRemains() < (5 + 0))) or (v82.Inertia:IsAvailable() and v14:BuffDown(v82.InertiaBuff) and v14:BuffDown(v82.UnboundChaosBuff) and ((v82.ImmolationAura:Recharge() + (11 - 6)) < v82.EyeBeam:CooldownRemains()) and v82.BladeDance:CooldownDown() and (v82.BladeDance:CooldownRemains() < (6 - 2)) and (v82.ImmolationAura:ChargesFractional() > (1134 - (1076 + 57)))))) or ((536 + 2718) == (2344 - (579 + 110)))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(1 + 7)) or ((1146 + 150) == (2606 + 2304))) then
				return "immolation_aura rotation 15";
			end
		end
		if (((3775 - (174 + 233)) == (9407 - 6039)) and v82.EyeBeam:IsCastable() and v41 and not v82.EssenceBreak:IsAvailable() and (not v82.ChaoticTransformation:IsAvailable() or (v82.Metamorphosis:CooldownRemains() < ((8 - 3) + ((2 + 1) * v24(v82.ShatteredDestiny:IsAvailable())))) or (v82.Metamorphosis:CooldownRemains() > (1189 - (663 + 511))))) then
			if (((2358 + 285) < (829 + 2986)) and v21(v82.EyeBeam, not v15:IsInRange(24 - 16))) then
				return "eye_beam rotation 25";
			end
		end
		if (((1159 + 754) > (1160 - 667)) and v82.EyeBeam:IsCastable() and v41 and ((v82.EssenceBreak:IsAvailable() and ((v82.EssenceBreak:CooldownRemains() < ((v95 * (4 - 2)) + ((3 + 2) * v24(v82.ShatteredDestiny:IsAvailable())))) or (v82.ShatteredDestiny:IsAvailable() and (v82.EssenceBreak:CooldownRemains() > (19 - 9)))) and ((v82.BladeDance:CooldownRemains() < (5 + 2)) or (v88 > (1 + 0))) and (not v82.Initiative:IsAvailable() or (v82.VengefulRetreat:CooldownRemains() > (732 - (478 + 244))) or (v88 > (518 - (440 + 77)))) and (not v82.Inertia:IsAvailable() or v14:BuffUp(v82.UnboundChaosBuff) or ((v82.ImmolationAura:Charges() == (0 + 0)) and (v82.ImmolationAura:Recharge() > (18 - 13))))) or (v97 < (1566 - (655 + 901))))) then
			if (((882 + 3873) > (2625 + 803)) and v21(v82.EyeBeam, not v15:IsInRange(6 + 2))) then
				return "eye_beam rotation 27";
			end
		end
		if (((5563 - 4182) <= (3814 - (695 + 750))) and v82.BladeDance:IsCastable() and v35 and ((v82.EyeBeam:CooldownRemains() > v95) or v82.EyeBeam:CooldownUp())) then
			if (v21(v82.BladeDance, not v15:IsInRange(27 - 19)) or ((7473 - 2630) == (16424 - 12340))) then
				return "blade_dance rotation 29";
			end
		end
		if (((5020 - (285 + 66)) > (846 - 483)) and v82.GlaiveTempest:IsCastable() and v45 and (v88 >= (1312 - (682 + 628)))) then
			if (v21(v82.GlaiveTempest, not v15:IsInRange(2 + 6)) or ((2176 - (176 + 123)) >= (1313 + 1825))) then
				return "glaive_tempest rotation 31";
			end
		end
		if (((3440 + 1302) >= (3895 - (239 + 30))) and v47 and ((not v33 and v81) or not v81) and (v88 > (1 + 2)) and v82.SigilOfFlame:IsCastable()) then
			if ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((4364 + 176) == (1620 - 704))) then
				if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(24 - 16)) or ((1471 - (306 + 9)) > (15162 - 10817))) then
					return "sigil_of_flame rotation 33";
				end
			elseif (((390 + 1847) < (2607 + 1642)) and (v79 == "cursor")) then
				if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(20 + 20)) or ((7672 - 4989) < (1398 - (1140 + 235)))) then
					return "sigil_of_flame rotation 33";
				end
			end
		end
		if (((444 + 253) <= (758 + 68)) and v82.ChaosStrike:IsCastable() and v36 and v15:DebuffUp(v82.EssenceBreakDebuff)) then
			if (((284 + 821) <= (1228 - (33 + 19))) and v21(v82.ChaosStrike, not v15:IsInMeleeRange(2 + 3))) then
				return "chaos_strike rotation 35";
			end
		end
		if (((10127 - 6748) <= (1680 + 2132)) and v82.Felblade:IsCastable() and v43) then
			if (v21(v82.Felblade, not v15:IsInMeleeRange(9 - 4)) or ((739 + 49) >= (2305 - (586 + 103)))) then
				return "felblade rotation 37";
			end
		end
		if (((169 + 1685) <= (10402 - 7023)) and v82.ThrowGlaive:IsCastable() and v48 and (v82.ThrowGlaive:FullRechargeTime() <= v82.BladeDance:CooldownRemains()) and (v82.Metamorphosis:CooldownRemains() > (1493 - (1309 + 179))) and v82.Soulscar:IsAvailable() and v14:HasTier(55 - 24, 1 + 1) and not v14:PrevGCDP(2 - 1, v82.VengefulRetreat)) then
			if (((3437 + 1112) == (9664 - 5115)) and v21(v82.ThrowGlaive, not v15:IsInMeleeRange(59 - 29))) then
				return "throw_glaive rotation 39";
			end
		end
		if ((v82.ThrowGlaive:IsCastable() and v48 and not v14:HasTier(640 - (295 + 314), 4 - 2) and ((v88 > (1963 - (1300 + 662))) or v82.Soulscar:IsAvailable()) and not v14:PrevGCDP(3 - 2, v82.VengefulRetreat)) or ((4777 - (1178 + 577)) >= (1571 + 1453))) then
			if (((14249 - 9429) > (3603 - (851 + 554))) and v21(v82.ThrowGlaive, not v15:IsInMeleeRange(27 + 3))) then
				return "throw_glaive rotation 41";
			end
		end
		if ((v82.ChaosStrike:IsCastable() and v36 and ((v82.EyeBeam:CooldownRemains() > (v95 * (5 - 3))) or (v14:Fury() > (173 - 93)))) or ((1363 - (115 + 187)) >= (3746 + 1145))) then
			if (((1292 + 72) <= (17626 - 13153)) and v21(v82.ChaosStrike, not v15:IsInMeleeRange(1166 - (160 + 1001)))) then
				return "chaos_strike rotation 43";
			end
		end
		if ((v82.ImmolationAura:IsCastable() and v46 and not v82.Inertia:IsAvailable()) or ((3146 + 449) <= (3 + 0))) then
			if (v21(v82.ImmolationAura, not v15:IsInRange(16 - 8)) or ((5030 - (237 + 121)) == (4749 - (525 + 372)))) then
				return "immolation_aura rotation 45";
			end
		end
		if (((2955 - 1396) == (5122 - 3563)) and v47 and ((not v33 and v81) or not v81) and not v15:IsInRange(150 - (96 + 46)) and v15:DebuffDown(v82.EssenceBreakDebuff) and (not v82.FelBarrage:IsAvailable() or (v82.FelBarrage:CooldownRemains() > (802 - (643 + 134))) or (v88 == (1 + 0))) and v82.SigilOfFlame:IsCastable()) then
			if ((v79 == "player") or (v82.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((4200 - 2448) <= (2925 - 2137))) then
				if (v21(v84.SigilOfFlamePlayer, not v15:IsInRange(8 + 0)) or ((7667 - 3760) == (361 - 184))) then
					return "sigil_of_flame rotation 47";
				end
			elseif (((4189 - (316 + 403)) > (369 + 186)) and (v79 == "cursor")) then
				if (v21(v84.SigilOfFlameCursor, not v15:IsInRange(109 - 69)) or ((352 + 620) == (1624 - 979))) then
					return "sigil_of_flame rotation 47";
				end
			end
		end
		if (((2255 + 927) >= (682 + 1433)) and v82.DemonsBite:IsCastable() and v39) then
			if (((13489 - 9596) < (21152 - 16723)) and v21(v82.DemonsBite, not v15:IsInMeleeRange(10 - 5))) then
				return "demons_bite rotation 49";
			end
		end
		if ((v82.FelRush:IsReady() and v44 and v32 and ((not v33 and v80) or not v80) and v14:BuffDown(v82.UnboundChaosBuff) and (v82.FelRush:Recharge() < v82.EyeBeam:CooldownRemains()) and v15:DebuffDown(v82.EssenceBreakDebuff) and ((v82.EyeBeam:CooldownRemains() > (1 + 7)) or (v82.FelRush:ChargesFractional() > (1.01 - 0)))) or ((141 + 2726) < (5604 - 3699))) then
			if (v21(v82.FelRush, not v15:IsInRange(32 - (12 + 5))) or ((6975 - 5179) >= (8643 - 4592))) then
				return "fel_rush rotation 51";
			end
		end
		if (((3441 - 1822) <= (9314 - 5558)) and v82.ArcaneTorrent:IsCastable() and v15:IsInRange(2 + 6) and v15:DebuffDown(v82.EssenceBreakDebuff) and (v14:Fury() < (2073 - (1656 + 317)))) then
			if (((539 + 65) == (485 + 119)) and v21(v82.ArcaneTorrent, not v15:IsInRange(21 - 13))) then
				return "arcane_torrent rotation 53";
			end
		end
	end
	local function v107()
		local v118 = 0 - 0;
		while true do
			if ((v118 == (359 - (5 + 349))) or ((21298 - 16814) == (2171 - (266 + 1005)))) then
				v49 = EpicSettings.Settings['useVengefulRetreat'];
				v54 = EpicSettings.Settings['useElysianDecree'];
				v55 = EpicSettings.Settings['useMetamorphosis'];
				v118 = 4 + 2;
			end
			if ((v118 == (23 - 16)) or ((5869 - 1410) <= (2809 - (561 + 1135)))) then
				v59 = EpicSettings.Settings['theHuntWithCD'];
				v60 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v61 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
				break;
			end
			if (((11938 - 8306) > (4464 - (507 + 559))) and (v118 == (7 - 4))) then
				v43 = EpicSettings.Settings['useFelblade'];
				v44 = EpicSettings.Settings['useFelRush'];
				v45 = EpicSettings.Settings['useGlaiveTempest'];
				v118 = 12 - 8;
			end
			if (((4470 - (212 + 176)) <= (5822 - (250 + 655))) and (v118 == (10 - 6))) then
				v46 = EpicSettings.Settings['useImmolationAura'];
				v47 = EpicSettings.Settings['useSigilOfFlame'];
				v48 = EpicSettings.Settings['useThrowGlaive'];
				v118 = 8 - 3;
			end
			if (((7559 - 2727) >= (3342 - (1869 + 87))) and (v118 == (0 - 0))) then
				v34 = EpicSettings.Settings['useAnnihilation'];
				v35 = EpicSettings.Settings['useBladeDance'];
				v36 = EpicSettings.Settings['useChaosStrike'];
				v118 = 1902 - (484 + 1417);
			end
			if (((293 - 156) == (229 - 92)) and (v118 == (779 - (48 + 725)))) then
				v56 = EpicSettings.Settings['useTheHunt'];
				v57 = EpicSettings.Settings['elysianDecreeWithCD'];
				v58 = EpicSettings.Settings['metamorphosisWithCD'];
				v118 = 11 - 4;
			end
			if ((v118 == (2 - 1)) or ((913 + 657) >= (11576 - 7244))) then
				v37 = EpicSettings.Settings['useConsumeMagic'];
				v38 = EpicSettings.Settings['useDeathSweep'];
				v39 = EpicSettings.Settings['useDemonsBite'];
				v118 = 1 + 1;
			end
			if ((v118 == (1 + 1)) or ((4917 - (152 + 701)) <= (3130 - (430 + 881)))) then
				v40 = EpicSettings.Settings['useEssenceBreak'];
				v41 = EpicSettings.Settings['useEyeBeam'];
				v42 = EpicSettings.Settings['useFelBarrage'];
				v118 = 2 + 1;
			end
		end
	end
	local function v108()
		v50 = EpicSettings.Settings['useChaosNova'];
		v51 = EpicSettings.Settings['useDisrupt'];
		v52 = EpicSettings.Settings['useFelEruption'];
		v53 = EpicSettings.Settings['useSigilOfMisery'];
		v62 = EpicSettings.Settings['useBlur'];
		v63 = EpicSettings.Settings['useNetherwalk'];
		v64 = EpicSettings.Settings['blurHP'] or (895 - (557 + 338));
		v65 = EpicSettings.Settings['netherwalkHP'] or (0 + 0);
		v79 = EpicSettings.Settings['sigilSetting'] or "";
		v81 = EpicSettings.Settings['RMBAOE'];
		v80 = EpicSettings.Settings['RMBMovement'];
	end
	local function v109()
		local v127 = 0 - 0;
		while true do
			if ((v127 == (0 - 0)) or ((13246 - 8260) < (3392 - 1818))) then
				v71 = EpicSettings.Settings['fightRemainsCheck'] or (801 - (499 + 302));
				v66 = EpicSettings.Settings['dispelBuffs'];
				v68 = EpicSettings.Settings['InterruptWithStun'];
				v127 = 867 - (39 + 827);
			end
			if (((12217 - 7791) > (383 - 211)) and (v127 == (11 - 8))) then
				v77 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v76 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v78 = EpicSettings.Settings['HealingPotionName'] or "";
				v127 = 11 - 7;
			end
			if (((94 + 492) > (719 - 264)) and (v127 == (106 - (103 + 1)))) then
				v73 = EpicSettings.Settings['trinketsWithCD'];
				v75 = EpicSettings.Settings['useHealthstone'];
				v74 = EpicSettings.Settings['useHealingPotion'];
				v127 = 557 - (475 + 79);
			end
			if (((1785 - 959) == (2643 - 1817)) and (v127 == (1 + 3))) then
				v67 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v127 == (1 + 0)) or ((5522 - (1395 + 108)) > (12923 - 8482))) then
				v69 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v70 = EpicSettings.Settings['InterruptThreshold'];
				v72 = EpicSettings.Settings['useTrinkets'];
				v127 = 1206 - (7 + 1197);
			end
		end
	end
	local function v110()
		v108();
		v107();
		v109();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['movement'];
		if (((880 + 1137) < (1487 + 2774)) and IsMouseButtonDown("RightButton")) then
			v33 = true;
		else
			v33 = false;
		end
		if (((5035 - (27 + 292)) > (234 - 154)) and v14:IsDeadOrGhost()) then
			return v28;
		end
		v86 = v14:GetEnemiesInMeleeRange(9 - 1);
		v87 = v14:GetEnemiesInMeleeRange(83 - 63);
		if (v30 or ((6915 - 3408) == (6231 - 2959))) then
			local v133 = 139 - (43 + 96);
			while true do
				if ((v133 == (0 - 0)) or ((1980 - 1104) >= (2552 + 523))) then
					v88 = ((#v86 > (0 + 0)) and #v86) or (1 - 0);
					v89 = #v87;
					break;
				end
			end
		else
			local v134 = 0 + 0;
			while true do
				if (((8155 - 3803) > (805 + 1749)) and (v134 == (0 + 0))) then
					v88 = 1752 - (1414 + 337);
					v89 = 1941 - (1642 + 298);
					break;
				end
			end
		end
		v95 = v14:GCD() + (0.05 - 0);
		if (v23.TargetIsValid() or v14:AffectingCombat() or ((12675 - 8269) < (11997 - 7954))) then
			local v135 = 0 + 0;
			while true do
				if (((1 + 0) == v135) or ((2861 - (357 + 615)) >= (2375 + 1008))) then
					if (((4642 - 2750) <= (2343 + 391)) and (v97 == (23811 - 12700))) then
						v97 = v10.FightRemains(v86, false);
					end
					break;
				end
				if (((1539 + 384) < (151 + 2067)) and (v135 == (0 + 0))) then
					v96 = v10.BossFightRemains(nil, true);
					v97 = v96;
					v135 = 1302 - (384 + 917);
				end
			end
		end
		v28 = v100();
		if (((2870 - (128 + 569)) > (1922 - (1407 + 136))) and v28) then
			return v28;
		end
		if (v67 or ((4478 - (687 + 1200)) == (5119 - (556 + 1154)))) then
			local v136 = 0 - 0;
			while true do
				if (((4609 - (9 + 86)) > (3745 - (275 + 146))) and (v136 == (0 + 0))) then
					v28 = v23.HandleIncorporeal(v82.Imprison, v84.ImprisonMouseover, 94 - (29 + 35), true);
					if (v28 or ((921 - 713) >= (14420 - 9592))) then
						return v28;
					end
					break;
				end
			end
		end
		if (v14:PrevGCDP(4 - 3, v82.VengefulRetreat) or v14:PrevGCDP(2 + 0, v82.VengefulRetreat) or (v14:PrevGCDP(1015 - (53 + 959), v82.VengefulRetreat) and v14:IsMoving()) or ((1991 - (312 + 96)) > (6190 - 2623))) then
			if ((v82.Felblade:IsCastable() and v43) or ((1598 - (147 + 138)) == (1693 - (813 + 86)))) then
				if (((2869 + 305) > (5376 - 2474)) and v21(v82.Felblade, not v15:IsSpellInRange(v82.Felblade))) then
					return "felblade rotation 1";
				end
			end
		elseif (((4612 - (18 + 474)) <= (1438 + 2822)) and v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
			local v168 = 0 - 0;
			while true do
				if (((1088 - (860 + 226)) == v168) or ((1186 - (121 + 182)) > (589 + 4189))) then
					v28 = v106();
					if (v28 or ((4860 - (988 + 252)) >= (553 + 4338))) then
						return v28;
					end
					break;
				end
				if (((1334 + 2924) > (2907 - (49 + 1921))) and ((890 - (223 + 667)) == v168)) then
					if ((not v14:AffectingCombat() and v29) or ((4921 - (51 + 1)) < (1559 - 653))) then
						local v170 = 0 - 0;
						while true do
							if ((v170 == (1125 - (146 + 979))) or ((346 + 879) > (4833 - (311 + 294)))) then
								v28 = v101();
								if (((9280 - 5952) > (948 + 1290)) and v28) then
									return v28;
								end
								break;
							end
						end
					end
					if (((5282 - (496 + 947)) > (2763 - (1233 + 125))) and v82.ConsumeMagic:IsAvailable() and v37 and v82.ConsumeMagic:IsReady() and v66 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) then
						if (v21(v82.ConsumeMagic, not v15:IsSpellInRange(v82.ConsumeMagic)) or ((525 + 768) <= (455 + 52))) then
							return "greater_purge damage";
						end
					end
					v168 = 1 + 0;
				end
				if (((1646 - (963 + 682)) == v168) or ((2417 + 479) < (2309 - (504 + 1000)))) then
					if (((1560 + 756) == (2110 + 206)) and v82.ThrowGlaive:IsReady() and v48 and v13.ValueIsInArray(v98, v15:NPCID())) then
						if (v21(v82.ThrowGlaive, not v15:IsSpellInRange(v82.ThrowGlaive)) or ((243 + 2327) == (2260 - 727))) then
							return "fodder to the flames react per target";
						end
					end
					if ((v82.ThrowGlaive:IsReady() and v48 and v13.ValueIsInArray(v98, v16:NPCID())) or ((755 + 128) == (850 + 610))) then
						if (v21(v84.ThrowGlaiveMouseover, not v15:IsSpellInRange(v82.ThrowGlaive)) or ((4801 - (156 + 26)) <= (576 + 423))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v168 = 2 - 0;
				end
			end
		end
	end
	local function v111()
		v82.BurningWoundDebuff:RegisterAuraTracking();
		v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v20.SetAPL(741 - (149 + 15), v110, v111);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

