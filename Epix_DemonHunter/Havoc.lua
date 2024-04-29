local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (((4427 - (1269 + 200)) < (8630 - 4127)) and not v5) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_DemonHunter_Havoc.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.MouseOver;
	local v16 = v11.Pet;
	local v17 = v9.Spell;
	local v18 = v9.Item;
	local v19 = EpicLib;
	local v20 = v19.Press;
	local v21 = v19.Macro;
	local v22 = v19.Commons.Everyone;
	local v23 = v22.num;
	local v24 = v22.bool;
	local v25 = math.min;
	local v26 = math.max;
	local v27;
	local v28 = false;
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
	local v79;
	local v80;
	local v81 = v17.DemonHunter.Havoc;
	local v82 = v18.DemonHunter.Havoc;
	local v83 = v21.DemonHunter.Havoc;
	local v84 = {};
	local v85, v86;
	local v87, v88;
	local v89 = {{v81.FelEruption},{v81.ChaosNova}};
	local v90 = false;
	local v91 = false;
	local v92 = 0 + 0;
	local v93 = 0 + 0;
	local v94 = v13:GCD() + 0.25 + 0;
	local v95 = 2397 + 8714;
	local v96 = 30910 - 19799;
	local v97 = {(60597 + 108824),(139752 + 29673),(78872 + 90060),(822624 - 653198),(58706 + 110723),(152293 + 17135),(169756 - (192 + 134))};
	v9:RegisterForEvent(function()
		v90 = false;
		v95 = 12387 - (316 + 960);
		v96 = 6184 + 4927;
	end, "PLAYER_REGEN_ENABLED");
	local function v98()
		v27 = v22.HandleTopTrinket(v84, v30, 31 + 9, nil);
		if (v27 or ((2528 + 207) == (5004 - 3695))) then
			return v27;
		end
		v27 = v22.HandleBottomTrinket(v84, v30, 591 - (83 + 468), nil);
		if (v27 or ((5936 - (1202 + 604)) <= (13794 - 10839))) then
			return v27;
		end
	end
	local function v99()
		if ((v81.Blur:IsCastable() and v61 and (v13:HealthPercentage() <= v63)) or ((3268 - 1304) <= (3710 - 2370))) then
			if (((2824 - (45 + 280)) == (2413 + 86)) and v20(v81.Blur)) then
				return "blur defensive";
			end
		end
		if ((v81.Netherwalk:IsCastable() and v62 and (v13:HealthPercentage() <= v64)) or ((1971 + 284) < (9 + 13))) then
			if (v20(v81.Netherwalk) or ((601 + 485) >= (248 + 1157))) then
				return "netherwalk defensive";
			end
		end
		if ((v82.Healthstone:IsReady() and v74 and (v13:HealthPercentage() <= v76)) or ((4386 - 2017) == (2337 - (340 + 1571)))) then
			if (v20(v83.Healthstone) or ((1214 + 1862) > (4955 - (1733 + 39)))) then
				return "healthstone defensive";
			end
		end
		if (((3302 - 2100) > (2092 - (125 + 909))) and v73 and (v13:HealthPercentage() <= v75)) then
			local v143 = 1948 - (1096 + 852);
			while true do
				if (((1665 + 2046) > (4790 - 1435)) and (v143 == (0 + 0))) then
					if ((v77 == "Refreshing Healing Potion") or ((1418 - (409 + 103)) >= (2465 - (46 + 190)))) then
						if (((1383 - (51 + 44)) > (353 + 898)) and v82.RefreshingHealingPotion:IsReady()) then
							if (v20(v83.RefreshingHealingPotion) or ((5830 - (1114 + 203)) < (4078 - (228 + 498)))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v77 == "Dreamwalker's Healing Potion") or ((448 + 1617) >= (1766 + 1430))) then
						if (v82.DreamwalkersHealingPotion:IsReady() or ((5039 - (174 + 489)) <= (3858 - 2377))) then
							if (v20(v83.RefreshingHealingPotion) or ((5297 - (830 + 1075)) >= (5265 - (303 + 221)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v100()
		local v111 = 1269 - (231 + 1038);
		while true do
			if (((2771 + 554) >= (3316 - (171 + 991))) and (v111 == (0 - 0))) then
				if ((v81.ImmolationAura:IsCastable() and v45) or ((3477 - 2182) >= (8067 - 4834))) then
					if (((3504 + 873) > (5755 - 4113)) and v20(v81.ImmolationAura, not v14:IsInRange(22 - 14))) then
						return "immolation_aura precombat 8";
					end
				end
				if (((7613 - 2890) > (4191 - 2835)) and not v14:IsInMeleeRange(1253 - (111 + 1137)) and v81.Felblade:IsCastable() and v42) then
					if (v20(v81.Felblade, not v14:IsSpellInRange(v81.Felblade)) or ((4294 - (91 + 67)) <= (10217 - 6784))) then
						return "felblade precombat 9";
					end
				end
				v111 = 1 + 0;
			end
			if (((4768 - (423 + 100)) <= (33 + 4598)) and (v111 == (2 - 1))) then
				if (((2229 + 2047) >= (4685 - (326 + 445))) and not v14:IsInMeleeRange(21 - 16) and v81.FelRush:IsCastable() and (not v81.Felblade:IsAvailable() or (v81.Felblade:CooldownUp() and not v13:PrevGCDP(2 - 1, v81.Felblade))) and v31 and ((not v32 and v79) or not v79) and v43) then
					if (((461 - 263) <= (5076 - (530 + 181))) and v20(v81.FelRush, not v14:IsInRange(896 - (614 + 267)))) then
						return "fel_rush precombat 10";
					end
				end
				if (((4814 - (19 + 13)) > (7609 - 2933)) and v14:IsInMeleeRange(11 - 6) and v38 and (v81.DemonsBite:IsCastable() or v81.DemonBlades:IsAvailable())) then
					if (((13894 - 9030) > (571 + 1626)) and v20(v81.DemonsBite, not v14:IsInMeleeRange(8 - 3))) then
						return "demons_bite or demon_blades precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v101()
		if ((v81.DeathSweep:IsReady() and (v13:BuffRemains(v81.MetamorphosisBuff) < v94) and v37) or ((7673 - 3973) == (4319 - (1293 + 519)))) then
			if (((9127 - 4653) >= (714 - 440)) and v20(v81.DeathSweep, not v14:IsInMeleeRange(14 - 6))) then
				return "death_sweep meta 2";
			end
		end
		if ((v81.Annihilation:IsReady() and (v13:BuffRemains(v81.MetamorphosisBuff) < v94) and v33) or ((8167 - 6273) <= (3311 - 1905))) then
			if (((833 + 739) >= (313 + 1218)) and v20(v81.Annihilation, not v14:IsInMeleeRange(11 - 6))) then
				return "annihilation meta 4";
			end
		end
		if ((v81.FelRush:IsCastable() and v43 and ((v13:BuffUp(v81.UnboundChaosBuff) and v81.Inertia:IsAvailable()) or (v81.Momentum:IsAvailable() and (v13:BuffRemains(v81.MomentumBuff) < (v94 * (1 + 1))))) and v43 and v31 and ((not v32 and v79) or not v79)) or ((1558 + 3129) < (2839 + 1703))) then
			if (((4387 - (709 + 387)) > (3525 - (673 + 1185))) and v20(v81.FelRush, not v14:IsInRange(43 - 28))) then
				return "fel_rush meta 6";
			end
		end
		if ((v81.Annihilation:IsReady() and v13:BuffUp(v81.InnerDemonBuff) and (((v81.EyeBeam:CooldownRemains() < (v94 * (9 - 6))) and v81.BladeDance:CooldownUp()) or (v81.Metamorphosis:CooldownRemains() < (v94 * (4 - 1)))) and v33) or ((625 + 248) == (1520 + 514))) then
			if (v20(v81.Annihilation, not v14:IsInMeleeRange(6 - 1)) or ((692 + 2124) < (21 - 10))) then
				return "annihilation meta 8";
			end
		end
		if (((7260 - 3561) < (6586 - (446 + 1434))) and v81.EssenceBreak:IsCastable() and (((v13:Fury() > (1303 - (1040 + 243))) and ((v81.Metamorphosis:CooldownRemains() > (29 - 19)) or (v81.BladeDance:CooldownRemains() < (v94 * (1849 - (559 + 1288))))) and (v13:BuffDown(v81.UnboundChaosBuff) or v13:BuffUp(v81.InertiaBuff) or not v81.Inertia:IsAvailable())) or (v96 < (1941 - (609 + 1322)))) and v39) then
			if (((3100 - (13 + 441)) >= (3273 - 2397)) and v20(v81.EssenceBreak, not v14:IsInMeleeRange(13 - 8))) then
				return "essence_break meta 10";
			end
		end
		if (((3057 - 2443) <= (119 + 3065)) and v81.ImmolationAura:IsCastable() and v14:DebuffDown(v81.EssenceBreakDebuff) and (v81.BladeDance:CooldownRemains() > (v94 + (0.5 - 0))) and v13:BuffDown(v81.UnboundChaosBuff) and v81.Inertia:IsAvailable() and v13:BuffDown(v81.InertiaBuff) and ((v81.ImmolationAura:FullRechargeTime() + 2 + 1) < v81.EyeBeam:CooldownRemains()) and (v13:BuffRemains(v81.MetamorphosisBuff) > (3 + 2)) and v45) then
			if (((9276 - 6150) == (1711 + 1415)) and v20(v81.ImmolationAura, not v14:IsInRange(14 - 6))) then
				return "immolation_aura meta 12";
			end
		end
		if ((v81.DeathSweep:IsReady() and v37) or ((1446 + 741) >= (2756 + 2198))) then
			if (v20(v81.DeathSweep, not v14:IsInMeleeRange(6 + 2)) or ((3256 + 621) == (3498 + 77))) then
				return "death_sweep meta 14";
			end
		end
		if (((1140 - (153 + 280)) > (1824 - 1192)) and v81.EyeBeam:IsReady() and v14:DebuffDown(v81.EssenceBreakDebuff) and v13:BuffDown(v81.InnerDemonBuff) and v40) then
			if (v20(v81.EyeBeam, not v14:IsInRange(8 + 0)) or ((216 + 330) >= (1405 + 1279))) then
				return "eye_beam meta 16";
			end
		end
		if (((1330 + 135) <= (3117 + 1184)) and v81.GlaiveTempest:IsReady() and v14:DebuffDown(v81.EssenceBreakDebuff) and ((v81.BladeDance:CooldownRemains() > (v94 * (2 - 0))) or (v13:Fury() > (38 + 22))) and v44) then
			if (((2371 - (89 + 578)) > (1018 + 407)) and v20(v81.GlaiveTempest, not v14:IsInMeleeRange(10 - 5), false, true)) then
				return "glaive_tempest meta 18";
			end
		end
		if ((v81.SigilOfFlame:IsCastable() and (v87 > (1051 - (572 + 477))) and v46 and ((not v32 and v80) or not v80) and not v13:IsMoving()) or ((93 + 594) == (2541 + 1693))) then
			if ((v78 == "player") or v81.ConcentratedSigils:IsAvailable() or ((398 + 2932) < (1515 - (84 + 2)))) then
				if (((1889 - 742) >= (242 + 93)) and v20(v83.SigilOfFlamePlayer, not v14:IsInRange(850 - (497 + 345)))) then
					return "sigil_of_flame meta 20";
				end
			elseif (((88 + 3347) > (355 + 1742)) and (v78 == "cursor")) then
				if (v20(v83.SigilOfFlameCursor, not v14:IsInRange(1373 - (605 + 728))) or ((2690 + 1080) >= (8984 - 4943))) then
					return "sigil_of_flame meta 20";
				end
			end
		end
		if ((v81.Annihilation:IsReady() and ((v81.BladeDance:CooldownRemains() > (v94 * (1 + 1))) or (v13:Fury() > (221 - 161)) or ((v13:BuffRemains(v81.MetamorphosisBuff) < (5 + 0)) and v81.Felblade:CooldownUp())) and v33) or ((10503 - 6712) <= (1217 + 394))) then
			if (v20(v81.Annihilation, not v14:IsInMeleeRange(494 - (457 + 32))) or ((1943 + 2635) <= (3410 - (832 + 570)))) then
				return "annihilation meta 22";
			end
		end
		if (((1060 + 65) <= (542 + 1534)) and v81.SigilOfFlame:IsCastable() and (v13:BuffRemains(v81.MetamorphosisBuff) > (17 - 12)) and v46 and ((not v32 and v80) or not v80) and not v13:IsMoving()) then
			if ((v78 == "player") or v81.ConcentratedSigils:IsAvailable() or ((358 + 385) >= (5195 - (588 + 208)))) then
				if (((3112 - 1957) < (3473 - (884 + 916))) and v20(v83.SigilOfFlamePlayer, not v14:IsInRange(16 - 8))) then
					return "sigil_of_flame meta 24";
				end
			elseif ((v78 == "cursor") or ((1348 + 976) <= (1231 - (232 + 421)))) then
				if (((5656 - (1569 + 320)) == (925 + 2842)) and v20(v83.SigilOfFlameCursor, not v14:IsInRange(8 + 32))) then
					return "sigil_of_flame meta 24";
				end
			end
		end
		if (((13778 - 9689) == (4694 - (316 + 289))) and v81.Felblade:IsCastable() and v42) then
			if (((11669 - 7211) >= (78 + 1596)) and v20(v81.Felblade, not v14:IsSpellInRange(v81.Felblade))) then
				return "felblade meta 26";
			end
		end
		if (((2425 - (666 + 787)) <= (1843 - (360 + 65))) and v81.SigilOfFlame:IsCastable() and (v14:DebuffDown(v81.EssenceBreakDebuff)) and v46 and ((not v32 and v80) or not v80) and not v13:IsMoving()) then
			if ((v78 == "player") or v81.ConcentratedSigils:IsAvailable() or ((4615 + 323) < (5016 - (79 + 175)))) then
				if (v20(v83.SigilOfFlamePlayer, not v14:IsInRange(12 - 4)) or ((1954 + 550) > (13070 - 8806))) then
					return "sigil_of_flame meta 28";
				end
			elseif (((4146 - 1993) == (3052 - (503 + 396))) and (v78 == "cursor")) then
				if (v20(v83.SigilOfFlameCursor, not v14:IsInRange(221 - (92 + 89))) or ((983 - 476) >= (1329 + 1262))) then
					return "sigil_of_flame meta 28";
				end
			end
		end
		if (((2653 + 1828) == (17548 - 13067)) and v81.ImmolationAura:IsCastable() and v14:IsInRange(2 + 6) and (v81.ImmolationAura:Recharge() < (v26(v81.EyeBeam:CooldownRemains(), v13:BuffRemains(v81.MetamorphosisBuff)))) and v45) then
			if (v20(v81.ImmolationAura, not v14:IsInRange(17 - 9)) or ((2032 + 296) < (331 + 362))) then
				return "immolation_aura meta 30";
			end
		end
		if (((13181 - 8853) == (541 + 3787)) and v81.FelRush:IsCastable() and v43 and (v81.Momentum:IsAvailable()) and v31 and ((not v32 and v79) or not v79)) then
			if (((2421 - 833) >= (2576 - (485 + 759))) and v20(v81.FelRush, not v14:IsInRange(34 - 19))) then
				return "fel_rush meta 32";
			end
		end
		if ((v81.FelRush:IsCastable() and v43 and v13:BuffDown(v81.UnboundChaosBuff) and (v81.FelRush:Recharge() < v81.EyeBeam:CooldownRemains()) and v14:DebuffDown(v81.EssenceBreakDebuff) and ((v81.EyeBeam:CooldownRemains() > (1197 - (442 + 747))) or (v81.FelRush:ChargesFractional() > (1136.01 - (832 + 303)))) and v14:IsInRange(961 - (88 + 858)) and v31 and ((not v32 and v79) or not v79)) or ((1273 + 2901) > (3516 + 732))) then
			if (v20(v81.FelRush, not v14:IsInRange(1 + 14)) or ((5375 - (766 + 23)) <= (404 - 322))) then
				return "fel_rush meta 34";
			end
		end
		if (((5282 - 1419) == (10177 - 6314)) and v81.DemonsBite:IsCastable() and v38) then
			if (v20(v81.DemonsBite, not v14:IsInMeleeRange(16 - 11)) or ((1355 - (1036 + 37)) <= (30 + 12))) then
				return "demons_bite meta 36";
			end
		end
	end
	local function v102()
		if (((8975 - 4366) >= (603 + 163)) and ((v30 and v57) or not v57) and v81.Metamorphosis:IsCastable() and v54 and (not v81.Initiative:IsAvailable() or (v81.VengefulRetreat:CooldownRemains() > (1480 - (641 + 839)))) and (((not v81.Demonic:IsAvailable() or v13:PrevGCDP(914 - (910 + 3), v81.DeathSweep) or v13:PrevGCDP(4 - 2, v81.DeathSweep) or v13:PrevGCDP(1687 - (1466 + 218), v81.DeathSweep)) and v81.EyeBeam:CooldownDown() and (not v81.EssenceBreak:IsAvailable() or v14:DebuffUp(v81.EssenceBreakDebuff)) and v13:BuffDown(v81.FelBarrage)) or not v81.ChaoticTransformation:IsAvailable() or (v95 < (14 + 16)))) then
			if (v20(v83.MetamorphosisPlayer, not v14:IsInRange(1156 - (556 + 592))) or ((410 + 742) == (3296 - (329 + 479)))) then
				return "metamorphosis cooldown 2";
			end
		end
		local v112 = v22.HandleDPSPotion(v13:BuffUp(v81.MetamorphosisBuff));
		if (((4276 - (174 + 680)) > (11511 - 8161)) and v112) then
			return v112;
		end
		if (((1817 - 940) > (269 + 107)) and (v70 < v96)) then
			if ((v71 and ((v30 and v72) or not v72)) or ((3857 - (396 + 343)) <= (164 + 1687))) then
				v27 = v98();
				if (v27 or ((1642 - (29 + 1448)) >= (4881 - (135 + 1254)))) then
					return v27;
				end
			end
		end
		if (((14876 - 10927) < (22673 - 17817)) and ((v30 and v58) or not v58) and v31 and ((not v32 and v79) or not v79) and v81.TheHunt:IsCastable() and v55 and v14:DebuffDown(v81.EssenceBreakDebuff) and (v9.CombatTime() > (4 + 1))) then
			if (v20(v81.TheHunt, not v14:IsInRange(1567 - (389 + 1138))) or ((4850 - (102 + 472)) < (2847 + 169))) then
				return "the_hunt cooldown 4";
			end
		end
		if (((2601 + 2089) > (3847 + 278)) and ((v30 and v56) or not v56) and v53 and ((not v32 and v80) or not v80) and not v13:IsMoving() and v81.ElysianDecree:IsCastable() and (v14:DebuffDown(v81.EssenceBreakDebuff)) and (v87 > v60)) then
			if ((v59 == "player") or ((1595 - (320 + 1225)) >= (1594 - 698))) then
				if (v20(v83.ElysianDecreePlayer, not v14:IsInRange(5 + 3)) or ((3178 - (157 + 1307)) >= (4817 - (821 + 1038)))) then
					return "elysian_decree cooldown 6 (Player)";
				end
			elseif ((v59 == "cursor") or ((3719 - 2228) < (71 + 573))) then
				if (((1250 - 546) < (368 + 619)) and v20(v83.ElysianDecreeCursor, not v14:IsInRange(74 - 44))) then
					return "elysian_decree cooldown 6 (Cursor)";
				end
			end
		end
	end
	local function v103()
		if (((4744 - (834 + 192)) > (122 + 1784)) and v81.VengefulRetreat:IsCastable() and v48 and v31 and ((not v32 and v79) or not v79) and v13:PrevGCDP(1 + 0, v81.DeathSweep) and (v81.Felblade:CooldownRemains() == (0 + 0))) then
			if (v20(v81.VengefulRetreat, not v14:IsInRange(12 - 4), true, true) or ((1262 - (300 + 4)) > (971 + 2664))) then
				return "vengeful_retreat opener 1";
			end
		end
		if (((9164 - 5663) <= (4854 - (112 + 250))) and v81.Metamorphosis:IsCastable() and v54 and ((v30 and v57) or not v57) and (v13:PrevGCDP(1 + 0, v81.DeathSweep) or (not v81.ChaoticTransformation:IsAvailable() and (not v81.Initiative:IsAvailable() or (v81.VengefulRetreat:CooldownRemains() > (4 - 2)))) or not v81.Demonic:IsAvailable())) then
			if (v20(v83.MetamorphosisPlayer, not v14:IsInRange(5 + 3)) or ((1781 + 1661) < (1906 + 642))) then
				return "metamorphosis opener 2";
			end
		end
		if (((1426 + 1449) >= (1088 + 376)) and v81.Felblade:IsCastable() and v42 and v14:DebuffDown(v81.EssenceBreakDebuff)) then
			if (v20(v81.Felblade, not v14:IsSpellInRange(v81.Felblade)) or ((6211 - (1001 + 413)) >= (10911 - 6018))) then
				return "felblade opener 3";
			end
		end
		if ((v81.ImmolationAura:IsCastable() and v45 and (v81.ImmolationAura:Charges() == (884 - (244 + 638))) and v13:BuffDown(v81.UnboundChaosBuff) and (v13:BuffDown(v81.InertiaBuff) or (v87 > (695 - (627 + 66))))) or ((1641 - 1090) > (2670 - (512 + 90)))) then
			if (((4020 - (1665 + 241)) > (1661 - (373 + 344))) and v20(v81.ImmolationAura, not v14:IsInRange(4 + 4))) then
				return "immolation_aura opener 4";
			end
		end
		if ((v81.Annihilation:IsCastable() and v33 and v13:BuffUp(v81.InnerDemonBuff) and (not v81.ChaoticTransformation:IsAvailable() or v81.Metamorphosis:CooldownUp())) or ((599 + 1663) >= (8166 - 5070))) then
			if (v20(v81.Annihilation, not v14:IsInMeleeRange(8 - 3)) or ((3354 - (35 + 1064)) >= (2574 + 963))) then
				return "annihilation opener 5";
			end
		end
		if ((v81.EyeBeam:IsCastable() and v40 and v14:DebuffDown(v81.EssenceBreakDebuff) and v13:BuffDown(v81.InnerDemonBuff) and (not v13:BuffUp(v81.MetamorphosisBuff) or (v81.BladeDance:CooldownRemains() > (0 - 0)))) or ((16 + 3821) < (2542 - (298 + 938)))) then
			if (((4209 - (233 + 1026)) == (4616 - (636 + 1030))) and v20(v81.EyeBeam, not v14:IsInRange(5 + 3))) then
				return "eye_beam opener 6";
			end
		end
		if ((v81.FelRush:IsReady() and v43 and v31 and ((not v32 and v79) or not v79) and v81.Inertia:IsAvailable() and (v13:BuffDown(v81.InertiaBuff) or (v87 > (2 + 0))) and v13:BuffUp(v81.UnboundChaosBuff)) or ((1404 + 3319) < (223 + 3075))) then
			if (((1357 - (55 + 166)) >= (30 + 124)) and v20(v81.FelRush, not v14:IsInRange(2 + 13))) then
				return "fel_rush opener 7";
			end
		end
		if ((v81.TheHunt:IsCastable() and v55 and ((v30 and v58) or not v58) and v31 and ((not v32 and v79) or not v79)) or ((1034 - 763) > (5045 - (36 + 261)))) then
			if (((8289 - 3549) >= (4520 - (34 + 1334))) and v20(v81.TheHunt, not v14:IsInRange(16 + 24))) then
				return "the_hunt opener 8";
			end
		end
		if ((v81.EssenceBreak:IsCastable() and v39) or ((2004 + 574) >= (4673 - (1035 + 248)))) then
			if (((62 - (20 + 1)) <= (866 + 795)) and v20(v81.EssenceBreak, not v14:IsInMeleeRange(324 - (134 + 185)))) then
				return "essence_break opener 9";
			end
		end
		if (((1734 - (549 + 584)) < (4245 - (314 + 371))) and v81.DeathSweep:IsCastable() and v37) then
			if (((806 - 571) < (1655 - (478 + 490))) and v20(v81.DeathSweep, not v14:IsInMeleeRange(3 + 2))) then
				return "death_sweep opener 10";
			end
		end
		if (((5721 - (786 + 386)) > (3734 - 2581)) and v81.Annihilation:IsCastable() and v33) then
			if (v20(v81.Annihilation, not v14:IsInMeleeRange(1384 - (1055 + 324))) or ((6014 - (1093 + 247)) < (4152 + 520))) then
				return "annihilation opener 11";
			end
		end
		if (((386 + 3282) < (18107 - 13546)) and v81.DemonsBite:IsCastable() and v38) then
			if (v20(v81.DemonsBite, not v14:IsInMeleeRange(16 - 11)) or ((1294 - 839) == (9059 - 5454))) then
				return "demons_bite opener 12";
			end
		end
	end
	local function v104()
		local v113 = 0 + 0;
		while true do
			if ((v113 == (3 - 2)) or ((9178 - 6515) == (2498 + 814))) then
				if (((10937 - 6660) <= (5163 - (364 + 324))) and v81.EyeBeam:IsReady() and (v13:BuffDown(v81.FelBarrage)) and v40) then
					if (v20(v81.EyeBeam, not v14:IsInRange(21 - 13)) or ((2087 - 1217) == (395 + 794))) then
						return "eye_beam fel_barrage 4";
					end
				end
				if (((6498 - 4945) <= (5017 - 1884)) and v81.EssenceBreak:IsCastable() and v13:BuffDown(v81.FelBarrage) and v13:BuffUp(v81.MetamorphosisBuff) and v39) then
					if (v20(v81.EssenceBreak, not v14:IsInMeleeRange(15 - 10)) or ((3505 - (1249 + 19)) >= (3170 + 341))) then
						return "essence_break fel_barrage 6";
					end
				end
				if ((v81.DeathSweep:IsReady() and (v13:BuffDown(v81.FelBarrage)) and v37) or ((5153 - 3829) > (4106 - (686 + 400)))) then
					if (v20(v81.DeathSweep, not v14:IsInMeleeRange(4 + 1)) or ((3221 - (73 + 156)) == (9 + 1872))) then
						return "death_sweep fel_barrage 8";
					end
				end
				if (((3917 - (721 + 90)) > (18 + 1508)) and v81.ImmolationAura:IsCastable() and v13:BuffDown(v81.UnboundChaosBuff) and ((v87 > (6 - 4)) or v13:BuffUp(v81.FelBarrage)) and v45) then
					if (((3493 - (224 + 246)) < (6269 - 2399)) and v20(v81.ImmolationAura, not v14:IsInRange(14 - 6))) then
						return "immolation_aura fel_barrage 10";
					end
				end
				v113 = 1 + 1;
			end
			if (((4 + 139) > (55 + 19)) and (v113 == (0 - 0))) then
				v91 = (v81.Felblade:CooldownRemains() < v94) or (v81.SigilOfFlame:CooldownRemains() < v94);
				v92 = (((3 - 2) / ((515.6 - (203 + 310)) * v13:SpellHaste())) * (2005 - (1238 + 755))) + (v13:BuffStack(v81.ImmolationAura) * (1 + 5)) + (v23(v13:BuffUp(v81.TacticalRetreatBuff)) * (1544 - (709 + 825)));
				v93 = v94 * (58 - 26);
				if (((25 - 7) < (2976 - (196 + 668))) and v81.Annihilation:IsReady() and (v13:BuffUp(v81.InnerDemonBuff)) and v33) then
					if (((4331 - 3234) <= (3371 - 1743)) and v20(v81.Annihilation, not v14:IsInMeleeRange(838 - (171 + 662)))) then
						return "annihilation fel_barrage 2";
					end
				end
				v113 = 94 - (4 + 89);
			end
			if (((16228 - 11598) == (1686 + 2944)) and (v113 == (17 - 13))) then
				if (((1389 + 2151) > (4169 - (35 + 1451))) and v81.BladeDance:IsReady() and (((v13:Fury() - v93) - (1488 - (28 + 1425))) > (1993 - (941 + 1052))) and ((v13:BuffRemains(v81.FelBarrage) < (3 + 0)) or v91 or (v13:Fury() > (1594 - (822 + 692))) or (v92 > (25 - 7))) and v34) then
					if (((2259 + 2535) >= (3572 - (45 + 252))) and v20(v81.BladeDance, not v14:IsInMeleeRange(8 + 0))) then
						return "blade_dance fel_barrage 28";
					end
				end
				if (((511 + 973) == (3611 - 2127)) and v81.ArcaneTorrent:IsCastable() and (v13:FuryDeficit() > (473 - (114 + 319))) and v13:BuffUp(v81.FelBarrage)) then
					if (((2055 - 623) < (4555 - 1000)) and v20(v81.ArcaneTorrent)) then
						return "arcane_torrent fel_barrage 30";
					end
				end
				if ((v81.FelRush:IsCastable() and v43 and (v13:BuffUp(v81.UnboundChaosBuff)) and v31 and ((not v32 and v79) or not v79)) or ((679 + 386) > (5330 - 1752))) then
					if (v20(v81.FelRush, not v14:IsInRange(16 - 8)) or ((6758 - (556 + 1407)) < (2613 - (741 + 465)))) then
						return "fel_rush fel_barrage 32";
					end
				end
				if (((2318 - (170 + 295)) < (2536 + 2277)) and v81.TheHunt:IsCastable() and v55 and ((v30 and v58) or not v58) and v31 and ((not v32 and v79) or not v79) and (v13:Fury() > (37 + 3))) then
					if (v20(v81.TheHunt, not v14:IsInRange(98 - 58)) or ((2339 + 482) < (1560 + 871))) then
						return "the_hunt fel_barrage 31";
					end
				end
				v113 = 3 + 2;
			end
			if ((v113 == (1235 - (957 + 273))) or ((769 + 2105) < (874 + 1307))) then
				if ((v81.DemonsBite:IsCastable() and v38) or ((10246 - 7557) <= (903 - 560))) then
					if (v20(v81.DemonsBite, not v14:IsInMeleeRange(15 - 10)) or ((9254 - 7385) == (3789 - (389 + 1391)))) then
						return "demons_bite fel_barrage 33";
					end
				end
				break;
			end
			if ((v113 == (2 + 1)) or ((370 + 3176) < (5285 - 2963))) then
				if ((v81.SigilOfFlame:IsCastable() and (v13:FuryDeficit() > (991 - (783 + 168))) and v13:BuffUp(v81.FelBarrage) and v46 and ((not v32 and v80) or not v80) and not v13:IsMoving()) or ((6987 - 4905) == (4695 + 78))) then
					if (((3555 - (309 + 2)) > (3239 - 2184)) and ((v78 == "player") or v81.ConcentratedSigils:IsAvailable())) then
						if (v20(v83.SigilOfFlamePlayer, not v14:IsInRange(1220 - (1090 + 122))) or ((1075 + 2238) <= (5971 - 4193))) then
							return "sigil_of_flame fel_barrage 20";
						end
					elseif ((v78 == "cursor") or ((973 + 448) >= (3222 - (628 + 490)))) then
						if (((325 + 1487) <= (8043 - 4794)) and v20(v83.SigilOfFlameCursor, not v14:IsInRange(182 - 142))) then
							return "sigil_of_flame fel_barrage 20";
						end
					end
				end
				if (((2397 - (431 + 343)) <= (3951 - 1994)) and v81.Felblade:IsCastable() and v13:BuffUp(v81.FelBarrage) and (v13:FuryDeficit() > (115 - 75)) and v42) then
					if (((3486 + 926) == (565 + 3847)) and v20(v81.Felblade, not v14:IsSpellInRange(v81.Felblade))) then
						return "felblade fel_barrage 22";
					end
				end
				if (((3445 - (556 + 1139)) >= (857 - (6 + 9))) and v81.DeathSweep:IsReady() and (((v13:Fury() - v93) - (7 + 28)) > (0 + 0)) and ((v13:BuffRemains(v81.FelBarrage) < (172 - (28 + 141))) or v91 or (v13:Fury() > (31 + 49)) or (v92 > (21 - 3))) and v37) then
					if (((3097 + 1275) > (3167 - (486 + 831))) and v20(v81.DeathSweep, not v14:IsInMeleeRange(12 - 7))) then
						return "death_sweep fel_barrage 24";
					end
				end
				if (((816 - 584) < (156 + 665)) and v81.GlaiveTempest:IsReady() and (((v13:Fury() - v93) - (94 - 64)) > (1263 - (668 + 595))) and ((v13:BuffRemains(v81.FelBarrage) < (3 + 0)) or v91 or (v13:Fury() > (17 + 63)) or (v92 > (48 - 30))) and v44) then
					if (((808 - (23 + 267)) < (2846 - (1129 + 815))) and v20(v81.GlaiveTempest, not v14:IsInMeleeRange(392 - (371 + 16)), false, true)) then
						return "glaive_tempest fel_barrage 26";
					end
				end
				v113 = 1754 - (1326 + 424);
			end
			if (((5670 - 2676) > (3135 - 2277)) and (v113 == (120 - (88 + 30)))) then
				if ((v81.GlaiveTempest:IsReady() and v13:BuffDown(v81.FelBarrage) and (v87 > (772 - (720 + 51))) and v44) or ((8353 - 4598) <= (2691 - (421 + 1355)))) then
					if (((6509 - 2563) > (1839 + 1904)) and v20(v81.GlaiveTempest, not v14:IsInMeleeRange(1088 - (286 + 797)))) then
						return "glaive_tempest fel_barrage 12";
					end
				end
				if ((v81.BladeDance:IsReady() and (v13:BuffDown(v81.FelBarrage)) and v34) or ((4880 - 3545) >= (5475 - 2169))) then
					if (((5283 - (397 + 42)) > (704 + 1549)) and v20(v81.BladeDance, not v14:IsInMeleeRange(808 - (24 + 776)))) then
						return "blade_dance fel_barrage 14";
					end
				end
				if (((695 - 243) == (1237 - (222 + 563))) and v81.FelBarrage:IsReady() and (v13:Fury() > (220 - 120)) and v41) then
					if (v20(v81.FelBarrage, not v14:IsInMeleeRange(4 + 1)) or ((4747 - (23 + 167)) < (3885 - (690 + 1108)))) then
						return "fel_barrage fel_barrage 16";
					end
				end
				if (((1398 + 2476) == (3196 + 678)) and v81.FelRush:IsCastable() and v43 and v13:BuffUp(v81.UnboundChaosBuff) and (v13:Fury() > (868 - (40 + 808))) and v13:BuffUp(v81.FelBarrage) and v31 and ((not v32 and v79) or not v79)) then
					if (v20(v81.FelRush, not v14:IsInRange(3 + 12)) or ((7410 - 5472) > (4717 + 218))) then
						return "fel_rush fel_barrage 18";
					end
				end
				v113 = 2 + 1;
			end
		end
	end
	local function v105()
		local v114 = 0 + 0;
		while true do
			if ((v114 == (578 - (47 + 524))) or ((2762 + 1493) < (9356 - 5933))) then
				if (((2173 - 719) <= (5680 - 3189)) and v81.Felblade:IsCastable() and v42) then
					if (v20(v81.Felblade, not v14:IsInMeleeRange(1731 - (1165 + 561))) or ((124 + 4033) <= (8681 - 5878))) then
						return "felblade rotation 37";
					end
				end
				if (((1852 + 3001) >= (3461 - (341 + 138))) and v81.ThrowGlaive:IsCastable() and v47 and (v81.ThrowGlaive:FullRechargeTime() <= v81.BladeDance:CooldownRemains()) and (v81.Metamorphosis:CooldownRemains() > (2 + 3)) and v81.Soulscar:IsAvailable() and v13:HasTier(63 - 32, 328 - (89 + 237)) and not v13:PrevGCDP(3 - 2, v81.VengefulRetreat)) then
					if (((8703 - 4569) > (4238 - (581 + 300))) and v20(v81.ThrowGlaive, not v14:IsInMeleeRange(1250 - (855 + 365)))) then
						return "throw_glaive rotation 39";
					end
				end
				if ((v81.ThrowGlaive:IsCastable() and v47 and not v13:HasTier(73 - 42, 1 + 1) and ((v87 > (1236 - (1030 + 205))) or v81.Soulscar:IsAvailable()) and not v13:PrevGCDP(1 + 0, v81.VengefulRetreat)) or ((3179 + 238) < (2820 - (156 + 130)))) then
					if (v20(v81.ThrowGlaive, not v14:IsInMeleeRange(68 - 38)) or ((4586 - 1864) <= (335 - 171))) then
						return "throw_glaive rotation 41";
					end
				end
				v114 = 3 + 5;
			end
			if (((2 + 1) == v114) or ((2477 - (10 + 59)) < (597 + 1512))) then
				if ((v81.VengefulRetreat:IsCastable() and v48 and v31 and ((not v32 and v79) or not v79) and v81.Initiative:IsAvailable() and ((v81.EyeBeam:CooldownRemains() > (73 - 58)) or ((v81.EyeBeam:CooldownRemains() <= v13:GCDRemains()) and ((v81.Metamorphosis:CooldownRemains() > (1173 - (671 + 492))) or (v81.BladeDance:CooldownRemains() < (v94 * (2 + 0)))))) and (v9.CombatTime() > (1219 - (369 + 846)))) or ((9 + 24) == (1242 + 213))) then
					if (v20(v81.VengefulRetreat, not v14:IsInRange(1953 - (1036 + 909)), true, true) or ((353 + 90) >= (6740 - 2725))) then
						return "vengeful_retreat rotation 9";
					end
				end
				if (((3585 - (11 + 192)) > (84 + 82)) and (v90 or (not v81.DemonBlades:IsAvailable() and v81.FelBarrage:IsAvailable() and (v13:BuffUp(v81.FelBarrage) or v81.FelBarrage:CooldownUp()) and v13:BuffDown(v81.MetamorphosisBuff)))) then
					local v163 = 175 - (135 + 40);
					while true do
						if ((v163 == (0 - 0)) or ((169 + 111) == (6738 - 3679))) then
							v27 = v104();
							if (((2819 - 938) > (1469 - (50 + 126))) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if (((6563 - 4206) == (522 + 1835)) and v13:BuffUp(v81.MetamorphosisBuff)) then
					v27 = v101();
					if (((1536 - (1233 + 180)) == (1092 - (522 + 447))) and v27) then
						return v27;
					end
				end
				v114 = 1425 - (107 + 1314);
			end
			if (((5 + 4) == v114) or ((3217 - 2161) >= (1441 + 1951))) then
				if ((v81.DemonsBite:IsCastable() and v38) or ((2146 - 1065) < (4253 - 3178))) then
					if (v20(v81.DemonsBite, not v14:IsInMeleeRange(1915 - (716 + 1194))) or ((18 + 1031) >= (475 + 3957))) then
						return "demons_bite rotation 49";
					end
				end
				if ((v81.FelRush:IsReady() and v43 and v31 and ((not v32 and v79) or not v79) and v13:BuffDown(v81.UnboundChaosBuff) and (v81.FelRush:Recharge() < v81.EyeBeam:CooldownRemains()) and v14:DebuffDown(v81.EssenceBreakDebuff) and ((v81.EyeBeam:CooldownRemains() > (511 - (74 + 429))) or (v81.FelRush:ChargesFractional() > (1.01 - 0)))) or ((2364 + 2404) <= (1936 - 1090))) then
					if (v20(v81.FelRush, not v14:IsInRange(11 + 4)) or ((10352 - 6994) <= (3511 - 2091))) then
						return "fel_rush rotation 51";
					end
				end
				if ((v81.ArcaneTorrent:IsCastable() and v14:IsInRange(441 - (279 + 154)) and v14:DebuffDown(v81.EssenceBreakDebuff) and (v13:Fury() < (878 - (454 + 324)))) or ((2942 + 797) <= (3022 - (12 + 5)))) then
					if (v20(v81.ArcaneTorrent, not v14:IsInRange(5 + 3)) or ((4226 - 2567) >= (789 + 1345))) then
						return "arcane_torrent rotation 53";
					end
				end
				break;
			end
			if ((v114 == (1098 - (277 + 816))) or ((13930 - 10670) < (3538 - (1058 + 125)))) then
				if ((v81.EyeBeam:IsCastable() and v40 and not v81.EssenceBreak:IsAvailable() and (not v81.ChaoticTransformation:IsAvailable() or (v81.Metamorphosis:CooldownRemains() < (1 + 4 + ((978 - (815 + 160)) * v23(v81.ShatteredDestiny:IsAvailable())))) or (v81.Metamorphosis:CooldownRemains() > (64 - 49)))) or ((1587 - 918) == (1008 + 3215))) then
					if (v20(v81.EyeBeam, not v14:IsInRange(23 - 15)) or ((3590 - (41 + 1857)) < (2481 - (1222 + 671)))) then
						return "eye_beam rotation 25";
					end
				end
				if ((v81.EyeBeam:IsCastable() and v40 and ((v81.EssenceBreak:IsAvailable() and ((v81.EssenceBreak:CooldownRemains() < ((v94 * (5 - 3)) + ((6 - 1) * v23(v81.ShatteredDestiny:IsAvailable())))) or (v81.ShatteredDestiny:IsAvailable() and (v81.EssenceBreak:CooldownRemains() > (1192 - (229 + 953))))) and ((v81.BladeDance:CooldownRemains() < (1781 - (1111 + 663))) or (v87 > (1580 - (874 + 705)))) and (not v81.Initiative:IsAvailable() or (v81.VengefulRetreat:CooldownRemains() > (2 + 8)) or (v87 > (1 + 0))) and (not v81.Inertia:IsAvailable() or v13:BuffUp(v81.UnboundChaosBuff) or ((v81.ImmolationAura:Charges() == (0 - 0)) and (v81.ImmolationAura:Recharge() > (1 + 4))))) or (v96 < (689 - (642 + 37))))) or ((1094 + 3703) < (585 + 3066))) then
					if (v20(v81.EyeBeam, not v14:IsInRange(19 - 11)) or ((4631 - (233 + 221)) > (11215 - 6365))) then
						return "eye_beam rotation 27";
					end
				end
				if ((v81.BladeDance:IsCastable() and v34 and ((v81.EyeBeam:CooldownRemains() > v94) or v81.EyeBeam:CooldownUp())) or ((353 + 47) > (2652 - (718 + 823)))) then
					if (((1920 + 1131) > (1810 - (266 + 539))) and v20(v81.BladeDance, not v14:IsInRange(22 - 14))) then
						return "blade_dance rotation 29";
					end
				end
				v114 = 1231 - (636 + 589);
			end
			if (((8765 - 5072) <= (9037 - 4655)) and (v114 == (1 + 0))) then
				if ((v81.FelRush:IsReady() and v43 and v31 and ((not v32 and v79) or not v79) and v13:BuffUp(v81.UnboundChaosBuff) and (v13:BuffRemains(v81.UnboundChaosBuff) < (v94 * (1 + 1)))) or ((4297 - (657 + 358)) > (10855 - 6755))) then
					if (v20(v81.FelRush, not v14:IsInRange(34 - 19)) or ((4767 - (1151 + 36)) < (2747 + 97))) then
						return "fel_rush rotation 1";
					end
				end
				if (((24 + 65) < (13408 - 8918)) and (v81.EyeBeam:CooldownUp() or v81.Metamorphosis:CooldownUp()) and (v9.CombatTime() < (1847 - (1552 + 280)))) then
					local v164 = 834 - (64 + 770);
					while true do
						if ((v164 == (0 + 0)) or ((11311 - 6328) < (322 + 1486))) then
							v27 = v103();
							if (((5072 - (157 + 1086)) > (7543 - 3774)) and v27) then
								return v27;
							end
							break;
						end
					end
				end
				if (((6503 - 5018) <= (4454 - 1550)) and v90) then
					v27 = v104();
					if (((5825 - 1556) == (5088 - (599 + 220))) and v27) then
						return v27;
					end
				end
				v114 = 3 - 1;
			end
			if (((2318 - (1813 + 118)) <= (2034 + 748)) and (v114 == (1223 - (841 + 376)))) then
				if ((v81.GlaiveTempest:IsCastable() and v44 and (v87 >= (2 - 0))) or ((442 + 1457) <= (2502 - 1585))) then
					if (v20(v81.GlaiveTempest, not v14:IsInRange(867 - (464 + 395))) or ((11066 - 6754) <= (421 + 455))) then
						return "glaive_tempest rotation 31";
					end
				end
				if (((3069 - (467 + 370)) <= (5364 - 2768)) and v46 and ((not v32 and v80) or not v80) and (v87 > (3 + 0)) and v81.SigilOfFlame:IsCastable()) then
					if (((7181 - 5086) < (576 + 3110)) and ((v78 == "player") or (v81.ConcentratedSigils:IsAvailable() and not v13:IsMoving()))) then
						if (v20(v83.SigilOfFlamePlayer, not v14:IsInRange(18 - 10)) or ((2115 - (150 + 370)) >= (5756 - (74 + 1208)))) then
							return "sigil_of_flame rotation 33";
						end
					elseif ((v78 == "cursor") or ((11360 - 6741) < (13668 - 10786))) then
						if (v20(v83.SigilOfFlameCursor, not v14:IsInRange(29 + 11)) or ((684 - (14 + 376)) >= (8379 - 3548))) then
							return "sigil_of_flame rotation 33";
						end
					end
				end
				if (((1313 + 716) <= (2710 + 374)) and v81.ChaosStrike:IsCastable() and v35 and v14:DebuffUp(v81.EssenceBreakDebuff)) then
					if (v20(v81.ChaosStrike, not v14:IsInMeleeRange(5 + 0)) or ((5968 - 3931) == (1821 + 599))) then
						return "chaos_strike rotation 35";
					end
				end
				v114 = 85 - (23 + 55);
			end
			if (((10565 - 6107) > (2606 + 1298)) and (v114 == (8 + 0))) then
				if (((675 - 239) >= (39 + 84)) and v81.ChaosStrike:IsCastable() and v35 and ((v81.EyeBeam:CooldownRemains() > (v94 * (903 - (652 + 249)))) or (v13:Fury() > (214 - 134)))) then
					if (((2368 - (708 + 1160)) < (4929 - 3113)) and v20(v81.ChaosStrike, not v14:IsInMeleeRange(9 - 4))) then
						return "chaos_strike rotation 43";
					end
				end
				if (((3601 - (10 + 17)) == (803 + 2771)) and v81.ImmolationAura:IsCastable() and v45 and not v81.Inertia:IsAvailable()) then
					if (((1953 - (1400 + 332)) < (748 - 358)) and v20(v81.ImmolationAura, not v14:IsInRange(1916 - (242 + 1666)))) then
						return "immolation_aura rotation 45";
					end
				end
				if ((v46 and ((not v32 and v80) or not v80) and v14:IsInRange(4 + 4) and v14:DebuffDown(v81.EssenceBreakDebuff) and (not v81.FelBarrage:IsAvailable() or (v81.FelBarrage:CooldownRemains() > (10 + 15)) or (v87 == (1 + 0))) and v81.SigilOfFlame:IsCastable()) or ((3153 - (850 + 90)) <= (2488 - 1067))) then
					if (((4448 - (360 + 1030)) < (4301 + 559)) and ((v78 == "player") or (v81.ConcentratedSigils:IsAvailable() and not v13:IsMoving()))) then
						if (v20(v83.SigilOfFlamePlayer, not v14:IsInRange(22 - 14)) or ((1782 - 486) >= (6107 - (909 + 752)))) then
							return "sigil_of_flame rotation 47";
						end
					elseif ((v78 == "cursor") or ((2616 - (109 + 1114)) > (8218 - 3729))) then
						if (v20(v83.SigilOfFlameCursor, not v14:IsInRange(16 + 24)) or ((4666 - (6 + 236)) < (18 + 9))) then
							return "sigil_of_flame rotation 47";
						end
					end
				end
				v114 = 8 + 1;
			end
			if ((v114 == (0 - 0)) or ((3487 - 1490) > (4948 - (1076 + 57)))) then
				v90 = v81.FelBarrage:IsAvailable() and (((v81.FelBarrage:CooldownRemains() < (v94 * (2 + 5))) and (v81.Metamorphosis:CooldownDown() or (v87 > (691 - (579 + 110))))) or v13:BuffUp(v81.FelBarrage));
				v27 = v102();
				if (((274 + 3191) > (1692 + 221)) and v27) then
					return v27;
				end
				v114 = 1 + 0;
			end
			if (((1140 - (174 + 233)) < (5080 - 3261)) and (v114 == (6 - 2))) then
				if ((v81.FelRush:IsReady() and v43 and v31 and ((not v32 and v79) or not v79) and v13:BuffUp(v81.UnboundChaosBuff) and v81.Inertia:IsAvailable() and v13:BuffDown(v81.InertiaBuff) and (v81.BladeDance:CooldownRemains() < (2 + 2)) and (v81.EyeBeam:CooldownRemains() > (1179 - (663 + 511))) and ((v81.ImmolationAura:Charges() > (0 + 0)) or ((v81.ImmolationAura:Recharge() + 1 + 1) < v81.EyeBeam:CooldownRemains()) or (v81.EyeBeam:CooldownRemains() > (v13:BuffRemains(v81.UnboundChaosBuff) - (5 - 3))))) or ((2662 + 1733) == (11194 - 6439))) then
					if (v20(v81.FelRush, not v14:IsInRange(36 - 21)) or ((1810 + 1983) < (4610 - 2241))) then
						return "fel_rush rotation 11";
					end
				end
				if ((v81.FelRush:IsReady() and v43 and v31 and ((not v32 and v79) or not v79) and v81.Momentum:IsAvailable() and (v81.EyeBeam:CooldownRemains() < (v94 * (2 + 0)))) or ((374 + 3710) == (987 - (478 + 244)))) then
					if (((4875 - (440 + 77)) == (1982 + 2376)) and v20(v81.FelRush, not v14:IsInRange(54 - 39))) then
						return "fel_rush rotation 13";
					end
				end
				if ((v81.ImmolationAura:IsCastable() and v45 and ((v13:BuffDown(v81.UnboundChaosBuff) and (v81.ImmolationAura:FullRechargeTime() < (v94 * (1558 - (655 + 901))))) or ((v87 > (1 + 0)) and v13:BuffDown(v81.UnboundChaosBuff)) or (v81.Inertia:IsAvailable() and v13:BuffDown(v81.UnboundChaosBuff) and (v81.EyeBeam:CooldownRemains() < (4 + 1))) or (v81.Inertia:IsAvailable() and v13:BuffDown(v81.InertiaBuff) and v13:BuffDown(v81.UnboundChaosBuff) and ((v81.ImmolationAura:Recharge() + 4 + 1) < v81.EyeBeam:CooldownRemains()) and v81.BladeDance:CooldownDown() and (v81.BladeDance:CooldownRemains() < (15 - 11)) and (v81.ImmolationAura:ChargesFractional() > (1446 - (695 + 750)))))) or ((10715 - 7577) < (1531 - 538))) then
					if (((13392 - 10062) > (2674 - (285 + 66))) and v20(v81.ImmolationAura, not v14:IsInRange(18 - 10))) then
						return "immolation_aura rotation 15";
					end
				end
				v114 = 1315 - (682 + 628);
			end
			if ((v114 == (1 + 1)) or ((3925 - (176 + 123)) == (1669 + 2320))) then
				if ((v81.ImmolationAura:IsCastable() and v45 and (v87 > (2 + 0)) and v81.Ragefire:IsAvailable() and v13:BuffDown(v81.UnboundChaosBuff) and (not v81.FelBarrage:IsAvailable() or (v81.FelBarrage:CooldownRemains() > v81.ImmolationAura:Recharge())) and v14:DebuffDown(v81.EssenceBreakDebuff)) or ((1185 - (239 + 30)) == (727 + 1944))) then
					if (((262 + 10) == (480 - 208)) and v20(v81.ImmolationAura, not v14:IsInRange(24 - 16))) then
						return "immolation_aura rotation 3";
					end
				end
				if (((4564 - (306 + 9)) <= (16886 - 12047)) and v81.ImmolationAura:IsCastable() and v45 and (v87 > (1 + 1)) and v81.Ragefire:IsAvailable() and v14:DebuffDown(v81.EssenceBreakDebuff)) then
					if (((1704 + 1073) < (1541 + 1659)) and v20(v81.ImmolationAura, not v14:IsInRange(22 - 14))) then
						return "immolation_aura rotation 5";
					end
				end
				if (((1470 - (1140 + 235)) < (1246 + 711)) and v81.FelRush:IsReady() and v43 and v31 and ((not v32 and v79) or not v79) and v13:BuffUp(v81.UnboundChaosBuff) and (v87 > (2 + 0)) and (not v81.Inertia:IsAvailable() or ((v81.EyeBeam:CooldownRemains() + 1 + 1) > v13:BuffRemains(v81.UnboundChaosBuff)))) then
					if (((878 - (33 + 19)) < (620 + 1097)) and v20(v81.FelRush, not v14:IsInRange(44 - 29))) then
						return "fel_rush rotation 7";
					end
				end
				v114 = 2 + 1;
			end
		end
	end
	local function v106()
		v33 = EpicSettings.Settings['useAnnihilation'];
		v34 = EpicSettings.Settings['useBladeDance'];
		v35 = EpicSettings.Settings['useChaosStrike'];
		v36 = EpicSettings.Settings['useConsumeMagic'];
		v37 = EpicSettings.Settings['useDeathSweep'];
		v38 = EpicSettings.Settings['useDemonsBite'];
		v39 = EpicSettings.Settings['useEssenceBreak'];
		v40 = EpicSettings.Settings['useEyeBeam'];
		v41 = EpicSettings.Settings['useFelBarrage'];
		v42 = EpicSettings.Settings['useFelblade'];
		v43 = EpicSettings.Settings['useFelRush'];
		v44 = EpicSettings.Settings['useGlaiveTempest'];
		v45 = EpicSettings.Settings['useImmolationAura'];
		v46 = EpicSettings.Settings['useSigilOfFlame'];
		v47 = EpicSettings.Settings['useThrowGlaive'];
		v48 = EpicSettings.Settings['useVengefulRetreat'];
		v53 = EpicSettings.Settings['useElysianDecree'];
		v54 = EpicSettings.Settings['useMetamorphosis'];
		v55 = EpicSettings.Settings['useTheHunt'];
		v56 = EpicSettings.Settings['elysianDecreeWithCD'];
		v57 = EpicSettings.Settings['metamorphosisWithCD'];
		v58 = EpicSettings.Settings['theHuntWithCD'];
		v59 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
		v60 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
	end
	local function v107()
		local v137 = 0 + 0;
		while true do
			if (((2115 - (586 + 103)) >= (101 + 1004)) and (v137 == (0 - 0))) then
				v49 = EpicSettings.Settings['useChaosNova'];
				v50 = EpicSettings.Settings['useDisrupt'];
				v51 = EpicSettings.Settings['useFelEruption'];
				v137 = 1489 - (1309 + 179);
			end
			if (((4971 - 2217) <= (1471 + 1908)) and (v137 == (5 - 3))) then
				v63 = EpicSettings.Settings['blurHP'] or (0 + 0);
				v64 = EpicSettings.Settings['netherwalkHP'] or (0 - 0);
				v78 = EpicSettings.Settings['sigilSetting'] or "";
				v137 = 5 - 2;
			end
			if ((v137 == (610 - (295 + 314))) or ((9645 - 5718) == (3375 - (1300 + 662)))) then
				v52 = EpicSettings.Settings['useSigilOfMisery'];
				v61 = EpicSettings.Settings['useBlur'];
				v62 = EpicSettings.Settings['useNetherwalk'];
				v137 = 6 - 4;
			end
			if ((v137 == (1758 - (1178 + 577))) or ((600 + 554) <= (2329 - 1541))) then
				v80 = EpicSettings.Settings['RMBAOE'];
				v79 = EpicSettings.Settings['RMBMovement'];
				break;
			end
		end
	end
	local function v108()
		local v138 = 1405 - (851 + 554);
		while true do
			if ((v138 == (4 + 0)) or ((4556 - 2913) > (7338 - 3959))) then
				v66 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v138 == (303 - (115 + 187))) or ((2147 + 656) > (4307 + 242))) then
				v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v69 = EpicSettings.Settings['InterruptThreshold'];
				v71 = EpicSettings.Settings['useTrinkets'];
				v138 = 7 - 5;
			end
			if ((v138 == (1161 - (160 + 1001))) or ((193 + 27) >= (2086 + 936))) then
				v70 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v65 = EpicSettings.Settings['dispelBuffs'];
				v67 = EpicSettings.Settings['InterruptWithStun'];
				v138 = 359 - (237 + 121);
			end
			if (((3719 - (525 + 372)) == (5349 - 2527)) and (v138 == (9 - 6))) then
				v76 = EpicSettings.Settings['healthstoneHP'] or (142 - (96 + 46));
				v75 = EpicSettings.Settings['healingPotionHP'] or (777 - (643 + 134));
				v77 = EpicSettings.Settings['HealingPotionName'] or "";
				v138 = 2 + 2;
			end
			if ((v138 == (4 - 2)) or ((3939 - 2878) == (1781 + 76))) then
				v72 = EpicSettings.Settings['trinketsWithCD'];
				v74 = EpicSettings.Settings['useHealthstone'];
				v73 = EpicSettings.Settings['useHealingPotion'];
				v138 = 5 - 2;
			end
		end
	end
	local function v109()
		v107();
		v106();
		v108();
		v28 = EpicSettings.Toggles['ooc'];
		v29 = EpicSettings.Toggles['aoe'];
		v30 = EpicSettings.Toggles['cds'];
		v31 = EpicSettings.Toggles['movement'];
		if (((5641 - 2881) > (2083 - (316 + 403))) and IsMouseButtonDown("RightButton")) then
			v32 = true;
		else
			v32 = false;
		end
		if (v13:IsDeadOrGhost() or ((3259 + 1643) <= (9884 - 6289))) then
			return v27;
		end
		v85 = v13:GetEnemiesInMeleeRange(3 + 5);
		v86 = v13:GetEnemiesInMeleeRange(50 - 30);
		if (v29 or ((2730 + 1122) == (95 + 198))) then
			local v144 = 0 - 0;
			while true do
				if ((v144 == (0 - 0)) or ((3238 - 1679) == (263 + 4325))) then
					v87 = ((#v85 > (0 - 0)) and #v85) or (1 + 0);
					v88 = #v86;
					break;
				end
			end
		else
			local v145 = 0 - 0;
			while true do
				if (((17 - (12 + 5)) == v145) or ((17415 - 12931) == (1681 - 893))) then
					v87 = 1 - 0;
					v88 = 2 - 1;
					break;
				end
			end
		end
		v94 = v13:GCD() + 0.05 + 0;
		if (((6541 - (1656 + 317)) >= (3482 + 425)) and (v22.TargetIsValid() or v13:AffectingCombat())) then
			v95 = v9.BossFightRemains(nil, true);
			v96 = v95;
			if (((999 + 247) < (9226 - 5756)) and (v96 == (54683 - 43572))) then
				v96 = v9.FightRemains(v85, false);
			end
		end
		v27 = v99();
		if (((4422 - (5 + 349)) >= (4616 - 3644)) and v27) then
			return v27;
		end
		if (((1764 - (266 + 1005)) < (2566 + 1327)) and v66) then
			v27 = v22.HandleIncorporeal(v81.Imprison, v83.ImprisonMouseover, 102 - 72, true);
			if (v27 or ((1938 - 465) >= (5028 - (561 + 1135)))) then
				return v27;
			end
		end
		if (v13:PrevGCDP(1 - 0, v81.VengefulRetreat) or v13:PrevGCDP(6 - 4, v81.VengefulRetreat) or (v13:PrevGCDP(1069 - (507 + 559), v81.VengefulRetreat) and v13:IsMoving()) or ((10165 - 6114) <= (3578 - 2421))) then
			if (((992 - (212 + 176)) < (3786 - (250 + 655))) and v81.Felblade:IsCastable() and v42) then
				if (v20(v81.Felblade, not v14:IsSpellInRange(v81.Felblade)) or ((2454 - 1554) == (5900 - 2523))) then
					return "felblade rotation 1";
				end
			end
		elseif (((6975 - 2516) > (2547 - (1869 + 87))) and v22.TargetIsValid() and not v13:IsChanneling() and not v13:IsCasting()) then
			if (((11785 - 8387) >= (4296 - (484 + 1417))) and not v13:AffectingCombat() and v28) then
				local v165 = 0 - 0;
				while true do
					if ((v165 == (0 - 0)) or ((2956 - (48 + 725)) >= (4612 - 1788))) then
						v27 = v100();
						if (((5193 - 3257) == (1126 + 810)) and v27) then
							return v27;
						end
						break;
					end
				end
			end
			if ((v81.ConsumeMagic:IsAvailable() and v36 and v81.ConsumeMagic:IsReady() and v65 and not v13:IsCasting() and not v13:IsChanneling() and v22.UnitHasMagicBuff(v14)) or ((12912 - 8080) < (1208 + 3105))) then
				if (((1192 + 2896) > (4727 - (152 + 701))) and v20(v81.ConsumeMagic, not v14:IsSpellInRange(v81.ConsumeMagic))) then
					return "greater_purge damage";
				end
			end
			if (((5643 - (430 + 881)) == (1659 + 2673)) and v81.ThrowGlaive:IsReady() and v47 and v12.ValueIsInArray(v97, v14:NPCID())) then
				if (((4894 - (557 + 338)) >= (858 + 2042)) and v20(v81.ThrowGlaive, not v14:IsSpellInRange(v81.ThrowGlaive))) then
					return "fodder to the flames react per target";
				end
			end
			if ((v81.ThrowGlaive:IsReady() and v47 and v12.ValueIsInArray(v97, v15:NPCID())) or ((7115 - 4590) > (14231 - 10167))) then
				if (((11612 - 7241) == (9420 - 5049)) and v20(v83.ThrowGlaiveMouseover, not v14:IsSpellInRange(v81.ThrowGlaive))) then
					return "fodder to the flames react per mouseover";
				end
			end
			v27 = v105();
			if (v27 or ((1067 - (499 + 302)) > (5852 - (39 + 827)))) then
				return v27;
			end
		end
	end
	local function v110()
		v81.BurningWoundDebuff:RegisterAuraTracking();
		v19.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
	end
	v19.SetAPL(1592 - 1015, v109, v110);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

