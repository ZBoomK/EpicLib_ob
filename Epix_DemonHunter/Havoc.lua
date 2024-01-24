local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1619 - (1427 + 192);
	local v6;
	while true do
		if ((v5 == (1 + 0)) or ((5762 - 3280) < (1312 + 147))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((3022 - (192 + 134)) >= (5808 - (316 + 960)))) then
			v6 = v0[v4];
			if (((584 + 464) >= (41 + 11)) and not v6) then
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
	local v90 = 0 - 0;
	local v91 = 0 - 0;
	local v92 = v14:GCD() + (325.25 - (45 + 280));
	local v93 = 10725 + 386;
	local v94 = 9708 + 1403;
	local v95 = {(93753 + 75668),(313736 - 144311),(66631 + 102301),(465565 - 296139),(171377 - (1096 + 852)),(241961 - 72533),(169942 - (409 + 103))};
	v10:RegisterForEvent(function()
		local v109 = 236 - (46 + 190);
		while true do
			if (((3053 - (51 + 44)) < (1271 + 3232)) and (v109 == (1317 - (1114 + 203)))) then
				v88 = false;
				v93 = 11837 - (228 + 498);
				v109 = 1 + 0;
			end
			if ((v109 == (1 + 0)) or ((3398 - (174 + 489)) == (3410 - 2101))) then
				v94 = 13016 - (830 + 1075);
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v96()
		v28 = v23.HandleTopTrinket(v82, v31, 564 - (303 + 221), nil);
		if (v28 or ((5399 - (231 + 1038)) <= (2463 + 492))) then
			return v28;
		end
		v28 = v23.HandleBottomTrinket(v82, v31, 1202 - (171 + 991), nil);
		if (v28 or ((8094 - 6130) <= (3598 - 2258))) then
			return v28;
		end
	end
	local function v97()
		if (((6235 - 3736) == (2001 + 498)) and v79.Blur:IsCastable() and v61 and (v14:HealthPercentage() <= v63)) then
			if (v21(v79.Blur) or ((7904 - 5649) < (63 - 41))) then
				return "blur defensive";
			end
		end
		if ((v79.Netherwalk:IsCastable() and v62 and (v14:HealthPercentage() <= v64)) or ((1750 - 664) >= (4343 - 2938))) then
			if (v21(v79.Netherwalk) or ((3617 - (111 + 1137)) == (584 - (91 + 67)))) then
				return "netherwalk defensive";
			end
		end
		if ((v80.Healthstone:IsReady() and v74 and (v14:HealthPercentage() <= v76)) or ((9154 - 6078) > (795 + 2388))) then
			if (((1725 - (423 + 100)) > (8 + 1050)) and v21(v81.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if (((10275 - 6564) > (1749 + 1606)) and v73 and (v14:HealthPercentage() <= v75)) then
			if ((v77 == "Refreshing Healing Potion") or ((1677 - (326 + 445)) >= (9727 - 7498))) then
				if (((2869 - 1581) > (2919 - 1668)) and v80.RefreshingHealingPotion:IsReady()) then
					if (v21(v81.RefreshingHealingPotion) or ((5224 - (530 + 181)) < (4233 - (614 + 267)))) then
						return "refreshing healing potion defensive";
					end
				end
			end
			if ((v77 == "Dreamwalker's Healing Potion") or ((2097 - (19 + 13)) >= (5201 - 2005))) then
				if (v80.DreamwalkersHealingPotion:IsReady() or ((10196 - 5820) <= (4230 - 2749))) then
					if (v21(v81.RefreshingHealingPotion) or ((881 + 2511) >= (8337 - 3596))) then
						return "dreamwalkers healing potion defensive";
					end
				end
			end
		end
	end
	local function v98()
		if (((6895 - 3570) >= (3966 - (1293 + 519))) and v79.ImmolationAura:IsCastable() and v45) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(16 - 8)) or ((3381 - 2086) >= (6182 - 2949))) then
				return "immolation_aura precombat 8";
			end
		end
		if (((18873 - 14496) > (3867 - 2225)) and v46 and not v14:IsMoving() and (v85 > (1 + 0)) and v79.SigilOfFlame:IsCastable()) then
			if (((964 + 3759) > (3150 - 1794)) and ((v78 == "player") or v79.ConcentratedSigils:IsAvailable())) then
				if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(2 + 6)) or ((1375 + 2761) <= (2146 + 1287))) then
					return "sigil_of_flame precombat 9";
				end
			elseif (((5341 - (709 + 387)) <= (6489 - (673 + 1185))) and (v78 == "cursor")) then
				if (((12400 - 8124) >= (12568 - 8654)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(65 - 25))) then
					return "sigil_of_flame precombat 9";
				end
			end
		end
		if (((142 + 56) <= (3262 + 1103)) and not v15:IsInMeleeRange(6 - 1) and v79.Felblade:IsCastable() and v42) then
			if (((1175 + 3607) > (9323 - 4647)) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
				return "felblade precombat 9";
			end
		end
		if (((9548 - 4684) > (4077 - (446 + 1434))) and not v15:IsInMeleeRange(1288 - (1040 + 243)) and v79.ThrowGlaive:IsCastable() and v47 and not v14:PrevGCDP(2 - 1, v79.VengefulRetreat)) then
			if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((5547 - (559 + 1288)) == (4438 - (609 + 1322)))) then
				return "throw_glaive precombat 9";
			end
		end
		if (((4928 - (13 + 441)) >= (1023 - 749)) and not v15:IsInMeleeRange(13 - 8) and v79.FelRush:IsCastable() and (not v79.Felblade:IsAvailable() or (v79.Felblade:CooldownUp() and not v14:PrevGCDP(4 - 3, v79.Felblade))) and v32 and v43) then
			if (v21(v79.FelRush, not v15:IsInRange(1 + 14)) or ((6878 - 4984) <= (500 + 906))) then
				return "fel_rush precombat 10";
			end
		end
		if (((689 + 883) >= (4543 - 3012)) and v15:IsInMeleeRange(3 + 2) and v38 and (v79.DemonsBite:IsCastable() or v79.DemonBlades:IsAvailable())) then
			if (v21(v79.DemonsBite, not v15:IsInMeleeRange(8 - 3)) or ((3099 + 1588) < (2527 + 2015))) then
				return "demons_bite or demon_blades precombat 12";
			end
		end
	end
	local function v99()
		if (((2365 + 926) > (1400 + 267)) and ((v31 and v57) or not v57) and v79.Metamorphosis:IsCastable() and v54 and (((not v79.Demonic:IsAvailable() or (v14:BuffRemains(v79.MetamorphosisBuff) < v14:GCD())) and (v79.EyeBeam:CooldownRemains() > (0 + 0)) and (not v79.EssenceBreak:IsAvailable() or v15:DebuffUp(v79.EssenceBreakDebuff)) and v14:BuffDown(v79.FelBarrageBuff)) or not v79.ChaoticTransformation:IsAvailable() or (v94 < (463 - (153 + 280))))) then
			if (v21(v81.MetamorphosisPlayer, not v15:IsInRange(23 - 15)) or ((784 + 89) == (804 + 1230))) then
				return "metamorphosis cooldown 2";
			end
		end
		local v110 = v23.HandleDPSPotion(v14:BuffUp(v79.MetamorphosisBuff));
		if (v110 or ((1474 + 1342) < (10 + 1))) then
			return v110;
		end
		if (((2681 + 1018) < (7165 - 2459)) and (v70 < v94)) then
			if (((1636 + 1010) >= (1543 - (89 + 578))) and v71 and ((v31 and v72) or not v72)) then
				v28 = v96();
				if (((439 + 175) <= (6619 - 3435)) and v28) then
					return v28;
				end
			end
		end
		if (((4175 - (572 + 477)) == (422 + 2704)) and ((v31 and v58) or not v58) and v32 and v79.TheHunt:IsCastable() and v55 and v15:DebuffDown(v79.EssenceBreakDebuff) and (v10.CombatTime() > (4 + 1))) then
			if (v21(v79.TheHunt, not v15:IsInRange(5 + 35)) or ((2273 - (84 + 2)) >= (8164 - 3210))) then
				return "the_hunt cooldown 4";
			end
		end
		if ((v53 and not v14:IsMoving() and ((v31 and v56) or not v56) and v79.ElysianDecree:IsCastable() and (v15:DebuffDown(v79.EssenceBreakDebuff)) and (v85 > v60)) or ((2794 + 1083) == (4417 - (497 + 345)))) then
			if (((19 + 688) > (107 + 525)) and (v59 == "player")) then
				if (v21(v81.ElysianDecreePlayer, not v15:IsInRange(1341 - (605 + 728))) or ((390 + 156) >= (5966 - 3282))) then
					return "elysian_decree cooldown 6 (Player)";
				end
			elseif (((68 + 1397) <= (15901 - 11600)) and (v59 == "cursor")) then
				if (((1537 + 167) > (3947 - 2522)) and v21(v81.ElysianDecreeCursor, not v15:IsInRange(23 + 7))) then
					return "elysian_decree cooldown 6 (Cursor)";
				end
			end
		end
	end
	local function v100()
		if ((v79.VengefulRetreat:IsCastable() and v48 and v32 and v14:PrevGCDP(490 - (457 + 32), v79.DeathSweep) and (v79.Felblade:CooldownRemains() == (0 + 0))) or ((2089 - (832 + 570)) == (3989 + 245))) then
			if (v21(v79.VengefulRetreat, not v15:IsInRange(3 + 5)) or ((11784 - 8454) < (689 + 740))) then
				return "vengeful_retreat opener 1";
			end
		end
		if (((1943 - (588 + 208)) >= (902 - 567)) and v79.Metamorphosis:IsCastable() and v54 and ((v31 and v57) or not v57) and (v14:PrevGCDP(1801 - (884 + 916), v79.DeathSweep) or (not v79.ChaoticTransformation:IsAvailable() and (not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (3 - 1)))) or not v79.Demonic:IsAvailable())) then
			if (((1992 + 1443) > (2750 - (232 + 421))) and v21(v81.MetamorphosisPlayer, not v15:IsInRange(1897 - (1569 + 320)))) then
				return "metamorphosis opener 2";
			end
		end
		if ((v79.Felblade:IsCastable() and v42 and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((925 + 2845) >= (768 + 3273))) then
			if (v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade)) or ((12774 - 8983) <= (2216 - (316 + 289)))) then
				return "felblade opener 3";
			end
		end
		if ((v79.ImmolationAura:IsCastable() and v45 and (v79.ImmolationAura:Charges() == (5 - 3)) and v14:BuffDown(v79.UnboundChaosBuff) and (v14:BuffDown(v79.InertiaBuff) or (v85 > (1 + 1)))) or ((6031 - (666 + 787)) <= (2433 - (360 + 65)))) then
			if (((1052 + 73) <= (2330 - (79 + 175))) and v21(v79.ImmolationAura, not v15:IsInRange(12 - 4))) then
				return "immolation_aura opener 4";
			end
		end
		if ((v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (not v79.ChaoticTransformation:IsAvailable() or v79.Metamorphosis:CooldownUp())) or ((580 + 163) >= (13483 - 9084))) then
			if (((2224 - 1069) < (2572 - (503 + 396))) and v21(v79.Annihilation, not v15:IsInMeleeRange(186 - (92 + 89)))) then
				return "annihilation opener 5";
			end
		end
		if ((v79.EyeBeam:IsCastable() and v40 and v15:DebuffDown(v79.EssenceBreakDebuff) and v14:BuffDown(v79.InnerDemonBuff) and (not v14:BuffUp(v79.MetamorphosisBuff) or (v79.BladeDance:CooldownRemains() > (0 - 0)))) or ((1192 + 1132) <= (343 + 235))) then
			if (((14751 - 10984) == (516 + 3251)) and v21(v79.EyeBeam, not v15:IsInRange(17 - 9))) then
				return "eye_beam opener 6";
			end
		end
		if (((3568 + 521) == (1954 + 2135)) and v79.FelRush:IsReady() and v43 and v32 and v79.Inertia:IsAvailable() and (v14:BuffDown(v79.InertiaBuff) or (v85 > (5 - 3))) and v14:BuffUp(v79.UnboundChaosBuff)) then
			if (((557 + 3901) >= (2552 - 878)) and v21(v79.FelRush, not v15:IsInRange(1259 - (485 + 759)))) then
				return "fel_rush opener 7";
			end
		end
		if (((2248 - 1276) <= (2607 - (442 + 747))) and v79.TheHunt:IsCastable() and v55 and ((v31 and v58) or not v58) and v32) then
			if (v21(v79.TheHunt, not v15:IsInRange(1175 - (832 + 303))) or ((5884 - (88 + 858)) < (1452 + 3310))) then
				return "the_hunt opener 8";
			end
		end
		if ((v79.EssenceBreak:IsCastable() and v39) or ((2073 + 431) > (176 + 4088))) then
			if (((2942 - (766 + 23)) == (10628 - 8475)) and v21(v79.EssenceBreak, not v15:IsInMeleeRange(6 - 1))) then
				return "essence_break opener 9";
			end
		end
		if ((v79.DeathSweep:IsCastable() and v37) or ((1335 - 828) >= (8793 - 6202))) then
			if (((5554 - (1036 + 37)) == (3177 + 1304)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(9 - 4))) then
				return "death_sweep opener 10";
			end
		end
		if ((v79.Annihilation:IsCastable() and v33) or ((1832 + 496) < (2173 - (641 + 839)))) then
			if (((5241 - (910 + 3)) == (11033 - 6705)) and v21(v79.Annihilation, not v15:IsInMeleeRange(1689 - (1466 + 218)))) then
				return "annihilation opener 11";
			end
		end
		if (((730 + 858) >= (2480 - (556 + 592))) and v79.DemonsBite:IsCastable() and v38) then
			if (v21(v79.DemonsBite, not v15:IsInMeleeRange(2 + 3)) or ((4982 - (329 + 479)) > (5102 - (174 + 680)))) then
				return "demons_bite opener 12";
			end
		end
	end
	local function v101()
		local v111 = 0 - 0;
		while true do
			if ((v111 == (1 - 0)) or ((3275 + 1311) <= (821 - (396 + 343)))) then
				if (((342 + 3521) == (5340 - (29 + 1448))) and v79.EyeBeam:IsCastable() and v40 and v14:BuffDown(v79.FelBarrageBuff)) then
					if (v21(v79.EyeBeam, not v15:IsInRange(1397 - (135 + 1254))) or ((1062 - 780) <= (196 - 154))) then
						return "eye_beam fel_barrage 3";
					end
				end
				if (((3072 + 1537) >= (2293 - (389 + 1138))) and v79.EssenceBreak:IsCastable() and v39 and v14:BuffDown(v79.FelBarrageBuff) and v14:BuffUp(v79.MetamorphosisBuff)) then
					if (v21(v79.EssenceBreak, not v15:IsInMeleeRange(579 - (102 + 472))) or ((1088 + 64) == (1380 + 1108))) then
						return "essence_break fel_barrage 5";
					end
				end
				if (((3191 + 231) > (4895 - (320 + 1225))) and v79.DeathSweep:IsCastable() and v37 and v14:BuffDown(v79.FelBarrageBuff)) then
					if (((1560 - 683) > (231 + 145)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(1469 - (157 + 1307)))) then
						return "death_sweep fel_barrage 7";
					end
				end
				if ((v79.ImmolationAura:IsCastable() and v45 and v14:BuffDown(v79.UnboundChaosBuff) and ((v85 > (1861 - (821 + 1038))) or v14:BuffUp(v79.FelBarrageBuff))) or ((7779 - 4661) <= (203 + 1648))) then
					if (v21(v79.ImmolationAura, not v15:IsInRange(13 - 5)) or ((62 + 103) >= (8654 - 5162))) then
						return "immolation_aura fel_barrage 9";
					end
				end
				v111 = 1028 - (834 + 192);
			end
			if (((252 + 3697) < (1247 + 3609)) and (v111 == (0 + 0))) then
				v89 = (v79.Felblade:CooldownRemains() < v92) or (v79.SigilOfFlame:CooldownRemains() < v92);
				v90 = (((1 - 0) % ((306.6 - (300 + 4)) * v14:AttackHaste())) * (4 + 8)) + (v14:BuffStack(v79.ImmolationAuraBuff) * (15 - 9)) + (v24(v14:BuffUp(v79.TacticalRetreatBuff)) * (372 - (112 + 250)));
				v91 = v92 * (13 + 19);
				if ((v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff)) or ((10712 - 6436) < (1728 + 1288))) then
					if (((2426 + 2264) > (3086 + 1039)) and v21(v79.Annihilation, not v15:IsInMeleeRange(3 + 2))) then
						return "annihilation fel_barrage 1";
					end
				end
				v111 = 1 + 0;
			end
			if ((v111 == (1418 - (1001 + 413))) or ((111 - 61) >= (1778 - (244 + 638)))) then
				if ((v79.BladeDance:IsCastable() and v34 and (((v14:Fury() - v91) - (728 - (627 + 66))) > (0 - 0)) and ((v14:BuffRemains(v79.FelBarrageBuff) < (605 - (512 + 90))) or v89 or (v14:Fury() > (1986 - (1665 + 241))) or (v90 > (735 - (373 + 344))))) or ((774 + 940) >= (783 + 2175))) then
					if (v21(v79.BladeDance, not v15:IsInMeleeRange(13 - 8)) or ((2522 - 1031) < (1743 - (35 + 1064)))) then
						return "blade_dance fel_barrage 25";
					end
				end
				if (((513 + 191) < (2111 - 1124)) and v79.ArcaneTorrent:IsCastable() and (v14:FuryDeficit() > (1 + 39)) and v14:BuffUp(v79.FelBarrageBuff)) then
					if (((4954 - (298 + 938)) > (3165 - (233 + 1026))) and v21(v79.ArcaneTorrent)) then
						return "arcane_torrent fel_barrage 27";
					end
				end
				if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff)) or ((2624 - (636 + 1030)) > (1859 + 1776))) then
					if (((3420 + 81) <= (1335 + 3157)) and v21(v79.FelRush, not v15:IsInRange(2 + 13))) then
						return "fel_rush fel_barrage 29";
					end
				end
				if ((v79.TheHunt:IsCastable() and v55 and ((v31 and v58) or not v58) and v32 and (v14:Fury() > (261 - (55 + 166)))) or ((668 + 2774) < (257 + 2291))) then
					if (((10979 - 8104) >= (1761 - (36 + 261))) and v21(v79.TheHunt, not v15:IsInRange(69 - 29))) then
						return "the_hunt fel_barrage 31";
					end
				end
				v111 = 1373 - (34 + 1334);
			end
			if ((v111 == (2 + 3)) or ((3728 + 1069) >= (6176 - (1035 + 248)))) then
				if ((v79.DemonsBite:IsCastable() and v38) or ((572 - (20 + 1)) > (1078 + 990))) then
					if (((2433 - (134 + 185)) > (2077 - (549 + 584))) and v21(v79.DemonsBite, not v15:IsInMeleeRange(690 - (314 + 371)))) then
						return "demons_bite fel_barrage 33";
					end
				end
				break;
			end
			if ((v111 == (10 - 7)) or ((3230 - (478 + 490)) >= (1641 + 1455))) then
				if ((v46 and v79.SigilOfFlame:IsCastable() and (v14:FuryDeficit() > (1212 - (786 + 386))) and v14:BuffUp(v79.FelBarrageBuff)) or ((7303 - 5048) >= (4916 - (1055 + 324)))) then
					if ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()) or ((5177 - (1093 + 247)) < (1161 + 145))) then
						if (((311 + 2639) == (11712 - 8762)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(26 - 18))) then
							return "sigil_of_flame fel_barrage 18";
						end
					elseif ((v78 == "cursor") or ((13439 - 8716) < (8287 - 4989))) then
						if (((405 + 731) >= (593 - 439)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(137 - 97))) then
							return "sigil_of_flame fel_barrage 18";
						end
					end
				end
				if ((v79.Felblade:IsCastable() and v42 and v14:BuffUp(v79.FelBarrageBuff) and (v14:FuryDeficit() > (31 + 9))) or ((692 - 421) > (5436 - (364 + 324)))) then
					if (((12994 - 8254) >= (7563 - 4411)) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
						return "felblade fel_barrage 19";
					end
				end
				if ((v79.DeathSweep:IsCastable() and v37 and (((v14:Fury() - v91) - (12 + 23)) > (0 - 0)) and ((v14:BuffRemains(v79.FelBarrageBuff) < (4 - 1)) or v89 or (v14:Fury() > (242 - 162)) or (v90 > (1286 - (1249 + 19))))) or ((2327 + 251) >= (13195 - 9805))) then
					if (((1127 - (686 + 400)) <= (1304 + 357)) and v21(v79.DeathSweep, not v15:IsInMeleeRange(234 - (73 + 156)))) then
						return "death_sweep fel_barrage 21";
					end
				end
				if (((3 + 598) < (4371 - (721 + 90))) and v79.GlaiveTempest:IsCastable() and v44 and (((v14:Fury() - v91) - (1 + 29)) > (0 - 0)) and ((v14:BuffRemains(v79.FelBarrageBuff) < (473 - (224 + 246))) or v89 or (v14:Fury() > (129 - 49)) or (v90 > (32 - 14)))) then
					if (((43 + 192) < (17 + 670)) and v21(v79.GlaiveTempest, not v15:IsInMeleeRange(4 + 1))) then
						return "glaive_tempest fel_barrage 23";
					end
				end
				v111 = 7 - 3;
			end
			if (((15137 - 10588) > (1666 - (203 + 310))) and (v111 == (1995 - (1238 + 755)))) then
				if ((v79.GlaiveTempest:IsCastable() and v44 and v14:BuffDown(v79.FelBarrageBuff) and (v85 > (1 + 0))) or ((6208 - (709 + 825)) < (8608 - 3936))) then
					if (((5342 - 1674) < (5425 - (196 + 668))) and v21(v79.GlaiveTempest, not v15:IsInMeleeRange(19 - 14))) then
						return "glaive_tempest fel_barrage 11";
					end
				end
				if ((v79.BladeDance:IsCastable() and v34 and v14:BuffDown(v79.FelBarrageBuff)) or ((942 - 487) == (4438 - (171 + 662)))) then
					if (v21(v79.BladeDance, not v15:IsInMeleeRange(98 - (4 + 89))) or ((9333 - 6670) == (1206 + 2106))) then
						return "blade_dance fel_barrage 13";
					end
				end
				if (((18785 - 14508) <= (1755 + 2720)) and v79.FelBarrage:IsCastable() and v41 and (v14:Fury() > (1586 - (35 + 1451)))) then
					if (v21(v79.FelBarrage, not v15:IsInMeleeRange(1458 - (28 + 1425))) or ((2863 - (941 + 1052)) == (1141 + 48))) then
						return "fel_barrage fel_barrage 15";
					end
				end
				if (((3067 - (822 + 692)) <= (4472 - 1339)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v14:Fury() > (10 + 10)) and v14:BuffUp(v79.FelBarrageBuff)) then
					if (v21(v79.FelRush, not v15:IsInRange(312 - (45 + 252))) or ((2214 + 23) >= (1209 + 2302))) then
						return "fel_rush fel_barrage 17";
					end
				end
				v111 = 7 - 4;
			end
		end
	end
	local function v102()
		if ((v79.DeathSweep:IsCastable() and v37 and (v14:BuffRemains(v79.MetamorphosisBuff) < v92)) or ((1757 - (114 + 319)) > (4336 - 1316))) then
			if (v21(v79.DeathSweep, not v15:IsInMeleeRange(6 - 1)) or ((1908 + 1084) == (2802 - 921))) then
				return "death_sweep meta 1";
			end
		end
		if (((6507 - 3401) > (3489 - (556 + 1407))) and v79.Annihilation:IsCastable() and v33 and (v14:BuffRemains(v79.MetamorphosisBuff) < v92)) then
			if (((4229 - (741 + 465)) < (4335 - (170 + 295))) and v21(v79.Annihilation, not v15:IsInMeleeRange(3 + 2))) then
				return "annihilation meta 3";
			end
		end
		if (((132 + 11) > (182 - 108)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable()) then
			if (((15 + 3) < (1355 + 757)) and v21(v79.FelRush, not v15:IsInRange(9 + 6))) then
				return "fel_rush meta 5";
			end
		end
		if (((2327 - (957 + 273)) <= (436 + 1192)) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable() and (v14:BuffRemains(v79.MomentumBuff) < (v92 * (1 + 1)))) then
			if (((17642 - 13012) == (12201 - 7571)) and v21(v79.FelRush, not v15:IsInRange(45 - 30))) then
				return "fel_rush meta 7";
			end
		end
		if (((17528 - 13988) > (4463 - (389 + 1391))) and v79.Annihilation:IsCastable() and v33 and v14:BuffUp(v79.InnerDemonBuff) and (((v79.EyeBeam:CooldownRemains() < (v92 * (2 + 1))) and (v79.BladeDance:CooldownRemains() > (0 + 0))) or (v79.Metamorphosis:CooldownRemains() < (v92 * (6 - 3))))) then
			if (((5745 - (783 + 168)) >= (10991 - 7716)) and v21(v79.Annihilation, not v15:IsInMeleeRange(5 + 0))) then
				return "annihilation meta 9";
			end
		end
		if (((1795 - (309 + 2)) == (4557 - 3073)) and ((v79.EssenceBreak:IsCastable() and v39 and (v14:Fury() > (1232 - (1090 + 122))) and ((v79.Metamorphosis:CooldownRemains() > (4 + 6)) or (v79.BladeDance:CooldownRemains() < (v92 * (6 - 4)))) and (v14:BuffDown(v79.UnboundChaosBuff) or v14:BuffUp(v79.InertiaBuff) or not v79.Inertia:IsAvailable())) or (v94 < (7 + 3)))) then
			if (((2550 - (628 + 490)) < (638 + 2917)) and v21(v79.EssenceBreak, not v15:IsInMeleeRange(12 - 7))) then
				return "essence_break meta 11";
			end
		end
		if ((v79.ImmolationAura:IsCastable() and v45 and v15:DebuffDown(v79.EssenceBreakDebuff) and (v79.BladeDance:CooldownRemains() > (v92 + (0.5 - 0))) and v14:BuffDown(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and ((v79.ImmolationAura:FullRechargeTime() + (777 - (431 + 343))) < v79.EyeBeam:CooldownRemains()) and (v14:BuffRemains(v79.MetamorphosisBuff) > (10 - 5))) or ((3080 - 2015) > (2827 + 751))) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(2 + 6)) or ((6490 - (556 + 1139)) < (1422 - (6 + 9)))) then
				return "immolation_aura meta 13";
			end
		end
		if (((340 + 1513) < (2466 + 2347)) and v79.DeathSweep:IsCastable() and v37) then
			if (v21(v79.DeathSweep, not v15:IsInMeleeRange(174 - (28 + 141))) or ((1093 + 1728) < (3000 - 569))) then
				return "death_sweep meta 15";
			end
		end
		if ((v79.EyeBeam:IsCastable() and v40 and v15:DebuffDown(v79.EssenceBreakDebuff) and v14:BuffDown(v79.InnerDemonBuff)) or ((2036 + 838) < (3498 - (486 + 831)))) then
			if (v21(v79.EyeBeam, not v15:IsInRange(20 - 12)) or ((9466 - 6777) <= (65 + 278))) then
				return "eye_beam meta 17";
			end
		end
		if ((v79.GlaiveTempest:IsCastable() and v44 and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.BladeDance:CooldownRemains() > (v92 * (6 - 4))) or (v14:Fury() > (1323 - (668 + 595))))) or ((1682 + 187) == (406 + 1603))) then
			if (v21(v79.GlaiveTempest, not v15:IsInMeleeRange(13 - 8)) or ((3836 - (23 + 267)) < (4266 - (1129 + 815)))) then
				return "glaive_tempest meta 19";
			end
		end
		if ((v46 and v79.SigilOfFlame:IsCastable() and (v85 > (389 - (371 + 16)))) or ((3832 - (1326 + 424)) == (9039 - 4266))) then
			if (((11854 - 8610) > (1173 - (88 + 30))) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
				if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(779 - (720 + 51))) or ((7369 - 4056) <= (3554 - (421 + 1355)))) then
					return "sigil_of_flame meta 21";
				end
			elseif ((v78 == "cursor") or ((2343 - 922) >= (1034 + 1070))) then
				if (((2895 - (286 + 797)) <= (11877 - 8628)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(66 - 26))) then
					return "sigil_of_flame meta 21";
				end
			end
		end
		if (((2062 - (397 + 42)) <= (612 + 1345)) and v79.Annihilation:IsCastable() and v33 and ((v79.BladeDance:CooldownRemains() > (v92 * (802 - (24 + 776)))) or (v14:Fury() > (92 - 32)) or ((v14:BuffRemains(v79.MetamorphosisBuff) < (790 - (222 + 563))) and v79.Felblade:CooldownUp()))) then
			if (((9720 - 5308) == (3177 + 1235)) and v21(v79.Annihilation, not v15:IsInMeleeRange(195 - (23 + 167)))) then
				return "annihilation meta 23";
			end
		end
		if (((3548 - (690 + 1108)) >= (304 + 538)) and v46 and v79.SigilOfFlame:IsCastable() and (v14:BuffRemains(v79.MetamorphosisBuff) > (5 + 0))) then
			if (((5220 - (40 + 808)) > (305 + 1545)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
				if (((887 - 655) < (785 + 36)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(5 + 3))) then
					return "sigil_of_flame meta 25";
				end
			elseif (((285 + 233) < (1473 - (47 + 524))) and (v78 == "cursor")) then
				if (((1943 + 1051) > (2345 - 1487)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(59 - 19))) then
					return "sigil_of_flame meta 25";
				end
			end
		end
		if ((v79.Felblade:IsCastable() and v42) or ((8563 - 4808) <= (2641 - (1165 + 561)))) then
			if (((118 + 3828) > (11592 - 7849)) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
				return "felblade meta 27";
			end
		end
		if ((v46 and v79.SigilOfFlame:IsCastable() and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((510 + 825) >= (3785 - (341 + 138)))) then
			if (((1308 + 3536) > (4649 - 2396)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
				if (((778 - (89 + 237)) == (1453 - 1001)) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(16 - 8))) then
					return "sigil_of_flame meta 29";
				end
			elseif ((v78 == "cursor") or ((5438 - (581 + 300)) < (3307 - (855 + 365)))) then
				if (((9201 - 5327) == (1265 + 2609)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(1275 - (1030 + 205)))) then
					return "sigil_of_flame meta 29";
				end
			end
		end
		if ((v79.ImmolationAura:IsCastable() and v45 and v15:IsInRange(8 + 0) and (v79.ImmolationAura:Recharge() < (v79.EyeBeam:CooldownRemains() < v14:BuffRemains(v79.MetamorphosisBuff)))) or ((1803 + 135) > (5221 - (156 + 130)))) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(17 - 9)) or ((7171 - 2916) < (7010 - 3587))) then
				return "immolation_aura meta 31";
			end
		end
		if (((384 + 1070) <= (1453 + 1038)) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable()) then
			if (v21(v79.FelRush, not v15:IsInRange(84 - (10 + 59))) or ((1176 + 2981) <= (13804 - 11001))) then
				return "fel_rush meta 33";
			end
		end
		if (((6016 - (671 + 492)) >= (2374 + 608)) and v79.FelRush:IsReady() and v43 and v32 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.FelRush:Recharge() < v79.EyeBeam:CooldownRemains()) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.EyeBeam:CooldownRemains() > (1223 - (369 + 846))) or (v79.EyeBeam:ChargesFractional() > (1.01 + 0)))) then
			if (((3528 + 606) > (5302 - (1036 + 909))) and v21(v79.FelRush, not v15:IsInRange(12 + 3))) then
				return "fel_rush meta 35";
			end
		end
		if ((v79.DemonsBite:IsCastable() and v38) or ((5736 - 2319) < (2737 - (11 + 192)))) then
			if (v21(v79.DemonsBite, not v15:IsInMeleeRange(3 + 2)) or ((2897 - (135 + 40)) <= (397 - 233))) then
				return "demons_bite meta 37";
			end
		end
	end
	local function v103()
		v28 = v99();
		if (v28 or ((1452 + 956) < (4645 - 2536))) then
			return v28;
		end
		if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v14:BuffRemains(v79.UnboundChaosBuff) < (v92 * (2 - 0)))) or ((209 - (50 + 126)) == (4051 - 2596))) then
			if (v21(v79.FelRush, not v15:IsInRange(4 + 11)) or ((1856 - (1233 + 180)) >= (4984 - (522 + 447)))) then
				return "fel_rush rotation 1";
			end
		end
		if (((4803 - (107 + 1314)) > (78 + 88)) and v79.FelBarrage:IsAvailable()) then
			v88 = v79.FelBarrage:IsAvailable() and (v79.FelBarrage:CooldownRemains() < (v92 * (21 - 14))) and (((v85 >= (1 + 1)) and ((v79.Metamorphosis:CooldownRemains() > (0 - 0)) or (v85 > (7 - 5)))) or v14:BuffUp(v79.FelBarrageBuff));
		end
		if (((v79.EyeBeam:CooldownUp() or v79.Metamorphosis:CooldownUp()) and (v10.CombatTime() < (1925 - (716 + 1194)))) or ((5 + 275) == (328 + 2731))) then
			local v134 = 503 - (74 + 429);
			while true do
				if (((3628 - 1747) > (641 + 652)) and (v134 == (0 - 0))) then
					v28 = v100();
					if (((1668 + 689) == (7266 - 4909)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (((304 - 181) == (556 - (279 + 154))) and v88) then
			local v135 = 778 - (454 + 324);
			while true do
				if ((v135 == (0 + 0)) or ((1073 - (12 + 5)) >= (1829 + 1563))) then
					v28 = v101();
					if (v28 or ((2754 - 1673) < (398 + 677))) then
						return v28;
					end
					break;
				end
			end
		end
		if ((v79.ImmolationAura:IsCastable() and v45 and (v85 > (1095 - (277 + 816))) and v79.Ragefire:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (not v79.FelBarrage:IsAvailable() or (v79.FelBarrage:CooldownRemains() > v79.ImmolationAura:Recharge())) and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((4482 - 3433) >= (5615 - (1058 + 125)))) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(2 + 6)) or ((5743 - (815 + 160)) <= (3629 - 2783))) then
				return "immolation_aura rotation 3";
			end
		end
		if ((v79.ImmolationAura:IsCastable() and v45 and (v85 > (4 - 2)) and v79.Ragefire:IsAvailable() and v15:DebuffDown(v79.EssenceBreakDebuff)) or ((802 + 2556) <= (4150 - 2730))) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(1906 - (41 + 1857))) or ((5632 - (1222 + 671)) <= (7766 - 4761))) then
				return "immolation_aura rotation 5";
			end
		end
		if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and (v85 > (2 - 0)) and (not v79.Inertia:IsAvailable() or ((v79.EyeBeam:CooldownRemains() + (1184 - (229 + 953))) > v14:BuffRemains(v79.UnboundChaosBuff)))) or ((3433 - (1111 + 663)) >= (3713 - (874 + 705)))) then
			if (v21(v79.FelRush, not v15:IsInRange(3 + 12)) or ((2225 + 1035) < (4895 - 2540))) then
				return "fel_rush rotation 7";
			end
		end
		if ((v79.VengefulRetreat:IsCastable() and v48 and v32 and v79.Felblade:IsCastable() and v79.Initiative:IsAvailable() and (((v79.EyeBeam:CooldownRemains() > (1 + 14)) and (v14:GCDRemains() < (679.3 - (642 + 37)))) or ((v14:GCDRemains() < (0.1 + 0)) and (v79.EyeBeam:CooldownRemains() <= v14:GCDRemains()) and ((v79.Metamorphosis:CooldownRemains() > (2 + 8)) or (v79.BladeDance:CooldownRemains() < (v92 * (4 - 2)))))) and (v10.CombatTime() > (458 - (233 + 221)))) or ((1546 - 877) == (3717 + 506))) then
			if (v21(v79.VengefulRetreat, not v15:IsInRange(1549 - (718 + 823))) or ((1065 + 627) < (1393 - (266 + 539)))) then
				return "vengeful_retreat rotation 9";
			end
		end
		if (v88 or (not v79.DemonBlades:IsAvailable() and v79.FelBarrage:IsAvailable() and (v14:BuffUp(v79.FelBarrageBuff) or (v79.FelBarrage:CooldownRemains() > (0 - 0))) and v14:BuffDown(v79.MetamorphosisBuff)) or ((6022 - (636 + 589)) < (8666 - 5015))) then
			local v136 = 0 - 0;
			while true do
				if (((0 + 0) == v136) or ((1518 + 2659) > (5865 - (657 + 358)))) then
					v28 = v101();
					if (v28 or ((1059 - 659) > (2531 - 1420))) then
						return v28;
					end
					break;
				end
			end
		end
		if (((4238 - (1151 + 36)) > (971 + 34)) and v14:BuffUp(v79.MetamorphosisBuff)) then
			v28 = v102();
			if (((971 + 2722) <= (13086 - 8704)) and v28) then
				return v28;
			end
		end
		if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffUp(v79.UnboundChaosBuff) and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and (v79.BladeDance:CooldownRemains() < (1836 - (1552 + 280))) and (v79.EyeBeam:CooldownRemains() > (839 - (64 + 770))) and ((v79.ImmolationAura:Charges() > (0 + 0)) or ((v79.ImmolationAura:Recharge() + (4 - 2)) < v79.EyeBeam:CooldownRemains()) or (v79.EyeBeam:CooldownRemains() > (v14:BuffRemains(v79.UnboundChaosBuff) - (1 + 1))))) or ((4525 - (157 + 1086)) > (8206 - 4106))) then
			if (v21(v79.FelRush, not v15:IsInRange(65 - 50)) or ((5491 - 1911) < (3881 - 1037))) then
				return "fel_rush rotation 11";
			end
		end
		if (((908 - (599 + 220)) < (8941 - 4451)) and v79.FelRush:IsReady() and v43 and v32 and v79.Momentum:IsAvailable() and (v79.EyeBeam:CooldownRemains() < (v92 * (1933 - (1813 + 118))))) then
			if (v21(v79.FelRush, not v15:IsInRange(11 + 4)) or ((6200 - (841 + 376)) < (2533 - 725))) then
				return "fel_rush rotation 13";
			end
		end
		if (((890 + 2939) > (10287 - 6518)) and v79.ImmolationAura:IsCastable() and v45 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.ImmolationAura:FullRechargeTime() < (v92 * (861 - (464 + 395)))) and (v94 > v79.ImmolationAura:FullRechargeTime())) then
			if (((3811 - 2326) <= (1395 + 1509)) and v21(v79.ImmolationAura, not v15:IsInRange(845 - (467 + 370)))) then
				return "immolation_aura rotation 15";
			end
		end
		if (((8821 - 4552) == (3134 + 1135)) and v79.ImmolationAura:IsCastable() and v45 and (v85 > (6 - 4)) and v14:BuffDown(v79.UnboundChaosBuff)) then
			if (((61 + 326) <= (6472 - 3690)) and v21(v79.ImmolationAura, not v15:IsInRange(528 - (150 + 370)))) then
				return "immolation_aura rotation 17";
			end
		end
		if ((v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.UnboundChaosBuff) and (v79.EyeBeam:CooldownRemains() < (1287 - (74 + 1208)))) or ((4670 - 2771) <= (4348 - 3431))) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(6 + 2)) or ((4702 - (14 + 376)) <= (1519 - 643))) then
				return "immolation_aura rotation 19";
			end
		end
		if (((1445 + 787) <= (2281 + 315)) and v79.ImmolationAura:IsCastable() and v45 and v79.Inertia:IsAvailable() and v14:BuffDown(v79.InertiaBuff) and v14:BuffDown(v79.UnboundChaosBuff) and ((v79.ImmolationAura:Recharge() + 5 + 0) < v79.EyeBeam:CooldownRemains()) and (v79.BladeDance:CooldownRemains() > (0 - 0)) and (v79.BladeDance:CooldownRemains() < (4 + 0)) and (v79.ImmolationAura:ChargesFractional() > (79 - (23 + 55)))) then
			if (((4965 - 2870) < (2460 + 1226)) and v21(v79.ImmolationAura, not v15:IsInRange(8 + 0))) then
				return "immolation_aura rotation 21";
			end
		end
		if ((v79.ImmolationAura:IsCastable() and v45 and (v94 < (23 - 8)) and (v79.BladeDance:CooldownRemains() > (0 + 0))) or ((2496 - (652 + 249)) >= (11972 - 7498))) then
			if (v21(v79.ImmolationAura, not v15:IsInRange(1876 - (708 + 1160))) or ((12537 - 7918) < (5253 - 2371))) then
				return "immolation_aura rotation 23";
			end
		end
		if ((v79.EyeBeam:IsCastable() and v40 and not v79.EssenceBreak:IsAvailable() and (not v79.ChaoticTransformation:IsAvailable() or (v79.Metamorphosis:CooldownRemains() < ((32 - (10 + 17)) + ((1 + 2) * v24(v79.ShatteredDestiny:IsAvailable())))) or (v79.Metamorphosis:CooldownRemains() > (1747 - (1400 + 332))))) or ((563 - 269) >= (6739 - (242 + 1666)))) then
			if (((869 + 1160) <= (1131 + 1953)) and v21(v79.EyeBeam, not v15:IsInRange(7 + 1))) then
				return "eye_beam rotation 25";
			end
		end
		if ((v79.EyeBeam:IsCastable() and v40 and v79.EssenceBreak:IsAvailable() and ((v79.EssenceBreak:CooldownRemains() < ((v92 * (942 - (850 + 90))) + ((8 - 3) * v24(v79.ShatteredDestiny:IsAvailable())))) or (v79.ShatteredDestiny:IsAvailable() and (v79.EssenceBreak:CooldownRemains() > (1400 - (360 + 1030))))) and ((v79.BladeDance:CooldownRemains() < (7 + 0)) or (v85 > (2 - 1))) and (not v79.Initiative:IsAvailable() or (v79.VengefulRetreat:CooldownRemains() > (13 - 3)) or (v85 > (1662 - (909 + 752)))) and (not v79.Inertia:IsAvailable() or v14:BuffUp(v79.UnboundChaosBuff) or ((v79.ImmolationAura:Charges() == (1223 - (109 + 1114))) and (v79.ImmolationAura:Recharge() > (9 - 4))))) or (v94 < (4 + 6)) or ((2279 - (6 + 236)) == (1525 + 895))) then
			if (((3589 + 869) > (9206 - 5302)) and v21(v79.EyeBeam, not v15:IsInRange(13 - 5))) then
				return "eye_beam rotation 27";
			end
		end
		if (((1569 - (1076 + 57)) >= (21 + 102)) and v79.BladeDance:IsCastable() and v34 and ((v79.EyeBeam:CooldownRemains() > v92) or v79.EyeBeam:CooldownUp())) then
			if (((1189 - (579 + 110)) < (144 + 1672)) and v21(v79.BladeDance, not v15:IsInRange(5 + 0))) then
				return "blade_dance rotation 29";
			end
		end
		if (((1897 + 1677) == (3981 - (174 + 233))) and v79.GlaiveTempest:IsCastable() and v44 and (v85 >= (5 - 3))) then
			if (((387 - 166) < (174 + 216)) and v21(v79.GlaiveTempest, not v15:IsInRange(1182 - (663 + 511)))) then
				return "glaive_tempest rotation 31";
			end
		end
		if ((v46 and (v85 > (3 + 0)) and v79.SigilOfFlame:IsCastable()) or ((481 + 1732) <= (4380 - 2959))) then
			if (((1852 + 1206) < (11441 - 6581)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
				if (v21(v81.SigilOfFlamePlayer, not v15:IsInRange(19 - 11)) or ((619 + 677) >= (8653 - 4207))) then
					return "sigil_of_flame rotation 33";
				end
			elseif ((v78 == "cursor") or ((993 + 400) > (411 + 4078))) then
				if (v21(v81.SigilOfFlameCursor, not v15:IsInRange(762 - (478 + 244))) or ((4941 - (440 + 77)) < (13 + 14))) then
					return "sigil_of_flame rotation 33";
				end
			end
		end
		if ((v79.ChaosStrike:IsCastable() and v35 and v15:DebuffUp(v79.EssenceBreakDebuff)) or ((7309 - 5312) > (5371 - (655 + 901)))) then
			if (((643 + 2822) > (1465 + 448)) and v21(v79.ChaosStrike, not v15:IsInMeleeRange(4 + 1))) then
				return "chaos_strike rotation 35";
			end
		end
		if (((2952 - 2219) < (3264 - (695 + 750))) and v79.Felblade:IsCastable() and v42) then
			if (v21(v79.Felblade, not v15:IsInMeleeRange(16 - 11)) or ((6782 - 2387) == (19123 - 14368))) then
				return "felblade rotation 37";
			end
		end
		if ((v79.ThrowGlaive:IsCastable() and v47 and (v79.ThrowGlaive:FullRechargeTime() <= v79.BladeDance:CooldownRemains()) and (v79.Metamorphosis:CooldownRemains() > (356 - (285 + 66))) and v79.Soulscar:IsAvailable() and v14:HasTier(71 - 40, 1312 - (682 + 628)) and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat)) or ((4092 - (176 + 123)) < (991 + 1378))) then
			if (v21(v79.ThrowGlaive, not v15:IsInMeleeRange(22 + 8)) or ((4353 - (239 + 30)) == (73 + 192))) then
				return "throw_glaive rotation 39";
			end
		end
		if (((4189 + 169) == (7713 - 3355)) and v79.ThrowGlaive:IsCastable() and v47 and not v14:HasTier(96 - 65, 317 - (306 + 9)) and ((v85 > (3 - 2)) or v79.Soulscar:IsAvailable()) and not v14:PrevGCDP(1 + 0, v79.VengefulRetreat)) then
			if (v21(v79.ThrowGlaive, not v15:IsInMeleeRange(19 + 11)) or ((1511 + 1627) < (2839 - 1846))) then
				return "throw_glaive rotation 41";
			end
		end
		if (((4705 - (1140 + 235)) > (1479 + 844)) and v79.ChaosStrike:IsCastable() and v35 and ((v79.EyeBeam:CooldownRemains() > (v92 * (2 + 0))) or (v14:Fury() > (21 + 59)))) then
			if (v21(v79.ChaosStrike, not v15:IsInMeleeRange(57 - (33 + 19))) or ((1310 + 2316) == (11955 - 7966))) then
				return "chaos_strike rotation 43";
			end
		end
		if ((v79.ImmolationAura:IsCastable() and v45 and not v79.Inertia:IsAvailable() and (v85 > (1 + 1))) or ((1795 - 879) == (2505 + 166))) then
			if (((961 - (586 + 103)) == (25 + 247)) and v21(v79.ImmolationAura, not v15:IsInRange(24 - 16))) then
				return "immolation_aura rotation 45";
			end
		end
		if (((5737 - (1309 + 179)) <= (8735 - 3896)) and v46 and not v15:IsInRange(4 + 4) and v15:DebuffDown(v79.EssenceBreakDebuff) and (not v79.FelBarrage:IsAvailable() or (v79.FelBarrage:CooldownRemains() > (67 - 42))) and v79.SigilOfFlame:IsCastable()) then
			if (((2098 + 679) < (6798 - 3598)) and ((v78 == "player") or (v79.ConcentratedSigils:IsAvailable() and not v14:IsMoving()))) then
				if (((189 - 94) < (2566 - (295 + 314))) and v21(v81.SigilOfFlamePlayer, not v15:IsInRange(19 - 11))) then
					return "sigil_of_flame rotation 47";
				end
			elseif (((2788 - (1300 + 662)) < (5391 - 3674)) and (v78 == "cursor")) then
				if (((3181 - (1178 + 577)) >= (574 + 531)) and v21(v81.SigilOfFlameCursor, not v15:IsInRange(118 - 78))) then
					return "sigil_of_flame rotation 47";
				end
			end
		end
		if (((4159 - (851 + 554)) <= (2988 + 391)) and v79.DemonsBite:IsCastable() and v38) then
			if (v21(v79.DemonsBite, not v15:IsInMeleeRange(13 - 8)) or ((8528 - 4601) == (1715 - (115 + 187)))) then
				return "demons_bite rotation 49";
			end
		end
		if ((v79.FelRush:IsReady() and v43 and v32 and v14:BuffDown(v79.UnboundChaosBuff) and (v79.FelRush:Recharge() < v79.EyeBeam:CooldownRemains()) and v15:DebuffDown(v79.EssenceBreakDebuff) and ((v79.EyeBeam:CooldownRemains() > (7 + 1)) or (v79.FelRush:ChargesFractional() > (1.01 + 0)))) or ((4547 - 3393) <= (1949 - (160 + 1001)))) then
			if (v21(v79.FelRush, not v15:IsInRange(14 + 1)) or ((1134 + 509) > (6916 - 3537))) then
				return "fel_rush rotation 51";
			end
		end
		if ((v79.ArcaneTorrent:IsCastable() and not v14:IsMoving() and v15:IsInRange(366 - (237 + 121)) and v15:DebuffDown(v79.EssenceBreakDebuff) and (v14:Fury() < (997 - (525 + 372)))) or ((5313 - 2510) > (14946 - 10397))) then
			if (v21(v79.ArcaneTorrent, not v15:IsInRange(150 - (96 + 46))) or ((997 - (643 + 134)) >= (1091 + 1931))) then
				return "arcane_torrent rotation 53";
			end
		end
	end
	local function v104()
		local v112 = 0 - 0;
		while true do
			if (((10477 - 7655) == (2707 + 115)) and (v112 == (0 - 0))) then
				v33 = EpicSettings.Settings['useAnnihilation'];
				v34 = EpicSettings.Settings['useBladeDance'];
				v35 = EpicSettings.Settings['useChaosStrike'];
				v112 = 1 - 0;
			end
			if ((v112 == (721 - (316 + 403))) or ((706 + 355) == (5105 - 3248))) then
				v39 = EpicSettings.Settings['useEssenceBreak'];
				v40 = EpicSettings.Settings['useEyeBeam'];
				v41 = EpicSettings.Settings['useFelBarrage'];
				v112 = 2 + 1;
			end
			if (((6950 - 4190) > (967 + 397)) and (v112 == (2 + 2))) then
				v45 = EpicSettings.Settings['useImmolationAura'];
				v46 = EpicSettings.Settings['useSigilOfFlame'];
				v47 = EpicSettings.Settings['useThrowGlaive'];
				v112 = 17 - 12;
			end
			if (((14 - 11) == v112) or ((10183 - 5281) <= (206 + 3389))) then
				v42 = EpicSettings.Settings['useFelblade'];
				v43 = EpicSettings.Settings['useFelRush'];
				v44 = EpicSettings.Settings['useGlaiveTempest'];
				v112 = 7 - 3;
			end
			if ((v112 == (1 + 0)) or ((11332 - 7480) == (310 - (12 + 5)))) then
				v36 = EpicSettings.Settings['useConsumeMagic'];
				v37 = EpicSettings.Settings['useDeathSweep'];
				v38 = EpicSettings.Settings['useDemonsBite'];
				v112 = 7 - 5;
			end
			if ((v112 == (12 - 6)) or ((3313 - 1754) == (11377 - 6789))) then
				v55 = EpicSettings.Settings['useTheHunt'];
				v56 = EpicSettings.Settings['elysianDecreeWithCD'];
				v57 = EpicSettings.Settings['metamorphosisWithCD'];
				v112 = 2 + 5;
			end
			if ((v112 == (1980 - (1656 + 317))) or ((3996 + 488) == (632 + 156))) then
				v58 = EpicSettings.Settings['theHuntWithCD'];
				v59 = EpicSettings.Settings['elysianDecreeSetting'] or "player";
				v60 = EpicSettings.Settings['elysianDecreeSlider'] or (0 - 0);
				break;
			end
			if (((22481 - 17913) >= (4261 - (5 + 349))) and (v112 == (23 - 18))) then
				v48 = EpicSettings.Settings['useVengefulRetreat'];
				v53 = EpicSettings.Settings['useElysianDecree'];
				v54 = EpicSettings.Settings['useMetamorphosis'];
				v112 = 1277 - (266 + 1005);
			end
		end
	end
	local function v105()
		v49 = EpicSettings.Settings['useChaosNova'];
		v50 = EpicSettings.Settings['useDisrupt'];
		v51 = EpicSettings.Settings['useFelEruption'];
		v52 = EpicSettings.Settings['useSigilOfMisery'];
		v61 = EpicSettings.Settings['useBlur'];
		v62 = EpicSettings.Settings['useNetherwalk'];
		v63 = EpicSettings.Settings['blurHP'] or (0 + 0);
		v64 = EpicSettings.Settings['netherwalkHP'] or (0 - 0);
		v78 = EpicSettings.Settings['sigilSetting'] or "";
	end
	local function v106()
		v70 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
		v65 = EpicSettings.Settings['dispelBuffs'];
		v67 = EpicSettings.Settings['InterruptWithStun'];
		v68 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v69 = EpicSettings.Settings['InterruptThreshold'];
		v71 = EpicSettings.Settings['useTrinkets'];
		v72 = EpicSettings.Settings['trinketsWithCD'];
		v74 = EpicSettings.Settings['useHealthstone'];
		v73 = EpicSettings.Settings['useHealingPotion'];
		v76 = EpicSettings.Settings['healthstoneHP'] or (1696 - (561 + 1135));
		v75 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
		v77 = EpicSettings.Settings['HealingPotionName'] or "";
		v66 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v107()
		v105();
		v104();
		v106();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v32 = EpicSettings.Toggles['movement'];
		if (((4095 - 2849) < (4536 - (507 + 559))) and v14:IsDeadOrGhost()) then
			return v28;
		end
		v83 = v14:GetEnemiesInMeleeRange(20 - 12);
		v84 = v14:GetEnemiesInMeleeRange(61 - 41);
		if (((4456 - (212 + 176)) >= (1877 - (250 + 655))) and v30) then
			v85 = ((#v83 > (0 - 0)) and #v83) or (1 - 0);
			v86 = #v84;
		else
			local v137 = 0 - 0;
			while true do
				if (((2449 - (1869 + 87)) < (13502 - 9609)) and (v137 == (1901 - (484 + 1417)))) then
					v85 = 2 - 1;
					v86 = 1 - 0;
					break;
				end
			end
		end
		v92 = v14:GCD() + (773.05 - (48 + 725));
		if (v23.TargetIsValid() or v14:AffectingCombat() or ((2405 - 932) >= (8939 - 5607))) then
			local v138 = 0 + 0;
			while true do
				if ((v138 == (2 - 1)) or ((1134 + 2917) <= (338 + 819))) then
					if (((1457 - (152 + 701)) < (4192 - (430 + 881))) and (v94 == (4256 + 6855))) then
						v94 = v10.FightRemains(v83, false);
					end
					break;
				end
				if ((v138 == (895 - (557 + 338))) or ((267 + 633) == (9516 - 6139))) then
					v93 = v10.BossFightRemains(nil, true);
					v94 = v93;
					v138 = 3 - 2;
				end
			end
		end
		v28 = v97();
		if (((11846 - 7387) > (1273 - 682)) and v28) then
			return v28;
		end
		if (((4199 - (499 + 302)) >= (3261 - (39 + 827))) and v66) then
			local v139 = 0 - 0;
			while true do
				if ((v139 == (0 - 0)) or ((8670 - 6487) >= (4335 - 1511))) then
					v28 = v23.HandleIncorporeal(v79.Imprison, v81.ImprisonMouseover, 3 + 27, true);
					if (((5666 - 3730) == (310 + 1626)) and v28) then
						return v28;
					end
					break;
				end
			end
		end
		if (v14:PrevGCDP(1 - 0, v79.VengefulRetreat) or v14:PrevGCDP(106 - (103 + 1), v79.VengefulRetreat) or (v14:PrevGCDP(557 - (475 + 79), v79.VengefulRetreat) and v14:IsMoving()) or ((10445 - 5613) < (13801 - 9488))) then
			if (((529 + 3559) > (3410 + 464)) and v79.Felblade:IsCastable() and v42) then
				if (((5835 - (1395 + 108)) == (12605 - 8273)) and v21(v79.Felblade, not v15:IsSpellInRange(v79.Felblade))) then
					return "felblade rotation 1";
				end
			end
		elseif (((5203 - (7 + 1197)) >= (1265 + 1635)) and v23.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
			local v162 = 0 + 0;
			while true do
				if ((v162 == (320 - (27 + 292))) or ((7398 - 4873) > (5181 - 1117))) then
					if (((18331 - 13960) == (8619 - 4248)) and v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v95, v15:NPCID())) then
						if (v21(v79.ThrowGlaive, not v15:IsSpellInRange(v79.ThrowGlaive)) or ((506 - 240) > (5125 - (43 + 96)))) then
							return "fodder to the flames react per target";
						end
					end
					if (((8121 - 6130) >= (2091 - 1166)) and v79.ThrowGlaive:IsReady() and v47 and v13.ValueIsInArray(v95, v16:NPCID())) then
						if (((378 + 77) < (580 + 1473)) and v21(v81.ThrowGlaiveMouseover, not v15:IsSpellInRange(v79.ThrowGlaive))) then
							return "fodder to the flames react per mouseover";
						end
					end
					v162 = 3 - 1;
				end
				if ((v162 == (1 + 1)) or ((1547 - 721) == (1528 + 3323))) then
					v28 = v103();
					if (((14 + 169) == (1934 - (1414 + 337))) and v28) then
						return v28;
					end
					break;
				end
				if (((3099 - (1642 + 298)) <= (4660 - 2872)) and (v162 == (0 - 0))) then
					if ((not v14:AffectingCombat() and v29) or ((10407 - 6900) > (1422 + 2896))) then
						v28 = v98();
						if (v28 or ((2393 + 682) <= (3937 - (357 + 615)))) then
							return v28;
						end
					end
					if (((959 + 406) <= (4934 - 2923)) and v79.ConsumeMagic:IsAvailable() and v36 and v79.ConsumeMagic:IsReady() and v65 and not v14:IsCasting() and not v14:IsChanneling() and v23.UnitHasMagicBuff(v15)) then
						if (v21(v79.ConsumeMagic, not v15:IsSpellInRange(v79.ConsumeMagic)) or ((2379 + 397) > (7661 - 4086))) then
							return "greater_purge damage";
						end
					end
					v162 = 1 + 0;
				end
			end
		end
	end
	local function v108()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (0 + 0)) or ((3855 - (384 + 917)) == (5501 - (128 + 569)))) then
				v79.BurningWoundDebuff:RegisterAuraTracking();
				v20.Print("Havoc Demon Hunter by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v20.SetAPL(2120 - (1407 + 136), v107, v108);
end;
return v0["Epix_DemonHunter_Havoc.lua"]();

