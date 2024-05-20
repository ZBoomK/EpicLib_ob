local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((5898 - (125 + 909)) > (4145 - (1096 + 852))) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((3589 + 111) == (3019 - (409 + 103)))) then
			v6 = v0[v4];
			if (((4710 - (46 + 190)) >= (369 - (51 + 44))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_Paladin_Retribution.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Focus;
	local v15 = v12.Player;
	local v16 = v12.MouseOver;
	local v17 = v12.Target;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.Item;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Bind;
	local v24 = v21.Macro;
	local v25 = v21.Press;
	local v26 = v21.Commons.Everyone.num;
	local v27 = v21.Commons.Everyone.bool;
	local v28 = math.min;
	local v29 = math.max;
	local v30;
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
	local v82;
	local v83;
	local v84;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98;
	local v99 = v21.Commons.Everyone;
	local v100 = v19.Paladin.Retribution;
	local v101 = v20.Paladin.Retribution;
	local v102 = {};
	local function v103()
		if (v100.CleanseToxins:IsAvailable() or ((3211 - (1114 + 203)) <= (2132 - (228 + 498)))) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 2408 + 8703;
	local v108 = 6139 + 4972;
	local v109;
	local v110 = 663 - (174 + 489);
	local v111 = 0 - 0;
	local v112;
	v10:RegisterForEvent(function()
		local v129 = 1905 - (830 + 1075);
		while true do
			if (((2096 - (303 + 221)) >= (2800 - (231 + 1038))) and (v129 == (0 + 0))) then
				v107 = 12273 - (171 + 991);
				v108 = 45790 - 34679;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v130 = 0 - 0;
		local v131;
		local v132;
		while true do
			if ((v130 == (2 - 1)) or ((3752 + 935) < (15921 - 11379))) then
				if (((9493 - 6202) > (2686 - 1019)) and (v131 > v132)) then
					return v131;
				end
				return v132;
			end
			if ((v130 == (0 - 0)) or ((2121 - (111 + 1137)) == (2192 - (91 + 67)))) then
				v131 = v15:GCDRemains();
				v132 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (29 - 19), v100.WakeofAshes:CooldownRemains());
				v130 = 1 + 0;
			end
		end
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 523 - (423 + 100);
	local function v116()
		if ((v100.CleanseToxins:IsReady() and (v99.UnitHasDispellableDebuffByPlayer(v14) or v99.DispellableFriendlyUnit(1 + 19) or v99.UnitHasCurseDebuff(v14) or v99.UnitHasPoisonDebuff(v14))) or ((7796 - 4980) < (6 + 5))) then
			if (((4470 - (326 + 445)) < (20536 - 15830)) and (v115 == (0 - 0))) then
				v115 = GetTime();
			end
			if (((6175 - 3529) >= (1587 - (530 + 181))) and v99.Wait(1381 - (614 + 267), v115)) then
				local v199 = 32 - (19 + 13);
				while true do
					if (((999 - 385) <= (7419 - 4235)) and (v199 == (0 - 0))) then
						if (((812 + 2314) == (5497 - 2371)) and v25(v104.CleanseToxinsFocus)) then
							return "cleanse_toxins dispel";
						end
						v115 = 0 - 0;
						break;
					end
				end
			end
		end
	end
	local function v117()
		if ((v96 and (v15:HealthPercentage() <= v97)) or ((3999 - (1293 + 519)) >= (10107 - 5153))) then
			if (v100.FlashofLight:IsReady() or ((10122 - 6245) == (6836 - 3261))) then
				if (((3048 - 2341) > (1488 - 856)) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		if (v16:Exists() or ((290 + 256) >= (548 + 2136))) then
			if (((3403 - 1938) <= (994 + 3307)) and v100.WordofGlory:IsReady() and v66 and not v15:CanAttack(v16) and (v16:HealthPercentage() <= v74)) then
				if (((567 + 1137) > (891 + 534)) and v25(v104.WordofGloryMouseover)) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (not v14 or not v14:Exists() or not v14:IsInRange(1126 - (709 + 387)) or ((2545 - (673 + 1185)) == (12278 - 8044))) then
			return;
		end
		if (v14 or ((10693 - 7363) < (2350 - 921))) then
			local v144 = 0 + 0;
			while true do
				if (((858 + 289) >= (451 - 116)) and (v144 == (0 + 0))) then
					if (((6849 - 3414) > (4116 - 2019)) and v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) then
						if (v25(v104.WordofGloryFocus) or ((5650 - (446 + 1434)) >= (5324 - (1040 + 243)))) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72) and v15:AffectingCombat()) or ((11314 - 7523) <= (3458 - (559 + 1288)))) then
						if (v25(v104.LayonHandsFocus) or ((6509 - (609 + 1322)) <= (2462 - (13 + 441)))) then
							return "lay_on_hands defensive focus";
						end
					end
					v144 = 3 - 2;
				end
				if (((2946 - 1821) <= (10339 - 8263)) and (v144 == (1 + 0))) then
					if ((v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((2698 - 1955) >= (1563 + 2836))) then
						if (((507 + 648) < (4964 - 3291)) and v25(v104.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if ((v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) or ((1272 + 1052) <= (1062 - 484))) then
						if (((2491 + 1276) == (2096 + 1671)) and v25(v104.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
			end
		end
	end
	local function v119()
		local v133 = 0 + 0;
		while true do
			if (((3434 + 655) == (4001 + 88)) and ((433 - (153 + 280)) == v133)) then
				v30 = v99.HandleTopTrinket(v102, v33, 115 - 75, nil);
				if (((4003 + 455) >= (661 + 1013)) and v30) then
					return v30;
				end
				v133 = 1 + 0;
			end
			if (((883 + 89) <= (1028 + 390)) and (v133 == (1 - 0))) then
				v30 = v99.HandleBottomTrinket(v102, v33, 25 + 15, nil);
				if (v30 or ((5605 - (89 + 578)) < (3402 + 1360))) then
					return v30;
				end
				break;
			end
		end
	end
	local function v120()
		if ((v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) or ((5205 - 2701) > (5313 - (572 + 477)))) then
			if (((291 + 1862) == (1293 + 860)) and v25(v100.ArcaneTorrent, not v17:IsInRange(1 + 7))) then
				return "arcane_torrent precombat 0";
			end
		end
		if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) or ((593 - (84 + 2)) >= (4269 - 1678))) then
			if (((3229 + 1252) == (5323 - (497 + 345))) and v25(v100.ShieldofVengeance, not v17:IsInRange(1 + 7))) then
				return "shield_of_vengeance precombat 1";
			end
		end
		if ((v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (1 + 3))) or ((3661 - (605 + 728)) < (495 + 198))) then
			if (((9622 - 5294) == (199 + 4129)) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
				return "juscticars vengeance precombat 2";
			end
		end
		if (((5871 - 4283) >= (1201 + 131)) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (10 - 6))) then
			if (v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict)) or ((3152 + 1022) > (4737 - (457 + 32)))) then
				return "final verdict precombat 3";
			end
		end
		if ((v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (2 + 2))) or ((5988 - (832 + 570)) <= (78 + 4))) then
			if (((1008 + 2855) == (13670 - 9807)) and v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict))) then
				return "templars verdict precombat 4";
			end
		end
		if ((v100.BladeofJustice:IsCastable() and v37) or ((136 + 146) <= (838 - (588 + 208)))) then
			if (((12422 - 7813) >= (2566 - (884 + 916))) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
				return "blade_of_justice precombat 5";
			end
		end
		if ((v100.Judgment:IsCastable() and v45) or ((2411 - 1259) == (1443 + 1045))) then
			if (((4075 - (232 + 421)) > (5239 - (1569 + 320))) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment precombat 6";
			end
		end
		if (((216 + 661) > (72 + 304)) and v100.HammerofWrath:IsReady() and v44) then
			if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((10506 - 7388) <= (2456 - (316 + 289)))) then
				return "hammer_of_wrath precombat 7";
			end
		end
		if ((v100.CrusaderStrike:IsCastable() and v39) or ((431 - 266) >= (162 + 3330))) then
			if (((5402 - (666 + 787)) < (5281 - (360 + 65))) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
				return "crusader_strike precombat 180";
			end
		end
	end
	local function v121()
		local v134 = 0 + 0;
		local v135;
		while true do
			if (((255 - (79 + 175)) == v134) or ((6742 - 2466) < (2354 + 662))) then
				if (((14376 - 9686) > (7944 - 3819)) and v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) then
					if (v25(v100.LightsJudgment, not v17:IsInRange(939 - (503 + 396))) or ((231 - (92 + 89)) >= (1737 - 841))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if ((v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (6 + 4))))) or ((1015 + 699) >= (11583 - 8625))) then
					if (v25(v100.Fireblood, not v17:IsInRange(2 + 8)) or ((3399 - 1908) < (562 + 82))) then
						return "fireblood cooldowns 6";
					end
				end
				v134 = 1 + 1;
			end
			if (((2144 - 1440) < (124 + 863)) and (v134 == (4 - 1))) then
				if (((4962 - (485 + 759)) > (4410 - 2504)) and v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (1204 - (442 + 747)))) or (v15:BuffStack(v100.CrusadeBuff) == (1145 - (832 + 303))) or not v100.Crusade:IsAvailable() or (v100.AvengingWrath:CooldownRemains() < (946.75 - (88 + 858))) or (v100.AvengingWrath:CooldownRemains() > (5 + 10))) and (((v110 >= (4 + 0)) and (v10.CombatTime() < (1 + 4))) or ((v110 >= (792 - (766 + 23))) and (v10.CombatTime() > (24 - 19))) or ((v110 >= (2 - 0)) and v100.DivineAuxiliary:IsAvailable())) and (((v17:TimeToDie() > (20 - 12)) and not v100.ExecutionersWill:IsAvailable()) or (v17:TimeToDie() > (40 - 28)))) then
					if (v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence)) or ((2031 - (1036 + 37)) > (2578 + 1057))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((6817 - 3316) <= (3534 + 958)) and v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (1484 - (641 + 839))) and (v10.CombatTime() < (918 - (910 + 3)))) or ((v110 >= (7 - 4)) and ((v10.CombatTime() > (1689 - (1466 + 218))) or not v100.VanguardofJustice:IsAvailable())) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable() and (v100.ExecutionSentence:CooldownUp() or v100.FinalReckoning:CooldownUp()))) and ((v106 == (1149 - (556 + 592))) or (v17:TimeToDie() > (4 + 6)))) then
					if (v25(v100.AvengingWrath, not v17:IsInRange(818 - (329 + 479))) or ((4296 - (174 + 680)) < (8755 - 6207))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v134 = 8 - 4;
			end
			if (((2053 + 822) >= (2203 - (396 + 343))) and ((1 + 1) == v134)) then
				if ((v87 and ((v33 and v88) or not v88) and v17:IsInRange(1485 - (29 + 1448))) or ((6186 - (135 + 1254)) >= (18432 - 13539))) then
					v30 = v119();
					if (v30 or ((2572 - 2021) > (1379 + 689))) then
						return v30;
					end
				end
				if (((3641 - (389 + 1138)) > (1518 - (102 + 472))) and v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (15 + 0)) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) then
					if (v25(v100.ShieldofVengeance) or ((1255 + 1007) >= (2887 + 209))) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v134 = 1548 - (320 + 1225);
			end
			if ((v134 == (0 - 0)) or ((1380 + 875) >= (5001 - (157 + 1307)))) then
				v135 = v99.HandleDPSPotion(v33 and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.Crusade) == (1869 - (821 + 1038))))));
				if (v135 or ((9573 - 5736) < (143 + 1163))) then
					return v135;
				end
				v134 = 1 - 0;
			end
			if (((1098 + 1852) == (7311 - 4361)) and (v134 == (1030 - (834 + 192)))) then
				if ((v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (((v110 >= (1 + 4)) and (v10.CombatTime() < (2 + 3))) or ((v110 >= (1 + 2)) and (v10.CombatTime() > (7 - 2))))) or ((5027 - (300 + 4)) < (881 + 2417))) then
					if (((2973 - 1837) >= (516 - (112 + 250))) and v25(v100.Crusade, not v17:IsInRange(4 + 6))) then
						return "crusade cooldowns 14";
					end
				end
				if ((v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (9 - 5)) and (v10.CombatTime() < (5 + 3))) or ((v110 >= (2 + 1)) and ((v10.CombatTime() >= (6 + 2)) or not v100.VanguardofJustice:IsAvailable())) or ((v110 >= (1 + 1)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (8 + 2)) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (1424 - (1001 + 413))))))) or ((604 - 333) > (5630 - (244 + 638)))) then
					if (((5433 - (627 + 66)) >= (9391 - 6239)) and (v98 == "player")) then
						if (v25(v104.FinalReckoningPlayer, not v17:IsInRange(612 - (512 + 90))) or ((4484 - (1665 + 241)) >= (4107 - (373 + 344)))) then
							return "final_reckoning cooldowns 18";
						end
					end
					if (((19 + 22) <= (440 + 1221)) and (v98 == "cursor")) then
						if (((1585 - 984) < (6024 - 2464)) and v25(v104.FinalReckoningCursor, not v17:IsInRange(1119 - (35 + 1064)))) then
							return "final_reckoning cooldowns 18";
						end
					end
				end
				break;
			end
		end
	end
	local function v122()
		v112 = ((v106 >= (3 + 0)) or ((v106 >= (4 - 2)) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (1 + 23)));
		if (((1471 - (298 + 938)) < (1946 - (233 + 1026))) and v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1669 - (636 + 1030)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (6 + 4))))) then
			if (((4444 + 105) > (343 + 810)) and v25(v100.DivineStorm, not v17:IsInRange(1 + 9))) then
				return "divine_storm finishers 2";
			end
		end
		if ((v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (224 - (55 + 166)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (2 + 8))))) or ((471 + 4203) < (17842 - 13170))) then
			if (((3965 - (36 + 261)) < (7976 - 3415)) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
				return "justicars_vengeance finishers 4";
			end
		end
		if ((v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (1371 - (34 + 1334)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (4 + 6))))) or ((354 + 101) == (4888 - (1035 + 248)))) then
			if (v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict)) or ((2684 - (20 + 1)) == (1726 + 1586))) then
				return "final verdict finishers 6";
			end
		end
		if (((4596 - (134 + 185)) <= (5608 - (549 + 584))) and v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (688 - (314 + 371)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (34 - 24))))) then
			if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((1838 - (478 + 490)) == (630 + 559))) then
				return "templars verdict finishers 8";
			end
		end
	end
	local function v123()
		local v136 = 1172 - (786 + 386);
		while true do
			if (((5029 - 3476) <= (4512 - (1055 + 324))) and (v136 == (1348 - (1093 + 247)))) then
				if ((v100.Consecration:IsCastable() and v38) or ((1988 + 249) >= (370 + 3141))) then
					if (v25(v100.Consecration, not v17:IsInRange(39 - 29)) or ((4493 - 3169) > (8593 - 5573))) then
						return "consecration generators 30";
					end
				end
				if ((v100.DivineHammer:IsCastable() and v40) or ((7518 - 4526) == (670 + 1211))) then
					if (((11965 - 8859) > (5259 - 3733)) and v25(v100.DivineHammer, not v17:IsInRange(8 + 2))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if (((7730 - 4707) < (4558 - (364 + 324))) and (v136 == (10 - 6))) then
				if (((342 - 199) > (25 + 49)) and ((v17:HealthPercentage() <= (83 - 63)) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff))) then
					v30 = v122();
					if (((28 - 10) < (6414 - 4302)) and v30) then
						return v30;
					end
				end
				if (((2365 - (1249 + 19)) <= (1470 + 158)) and v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (7 - 5))) then
					if (((5716 - (686 + 400)) == (3633 + 997)) and v25(v100.Consecration, not v17:IsInRange(239 - (73 + 156)))) then
						return "consecration generators 22";
					end
				end
				if (((17 + 3523) > (3494 - (721 + 90))) and v100.DivineHammer:IsCastable() and v40 and (v106 >= (1 + 1))) then
					if (((15565 - 10771) >= (3745 - (224 + 246))) and v25(v100.DivineHammer, not v17:IsInRange(16 - 6))) then
						return "divine_hammer generators 24";
					end
				end
				v136 = 9 - 4;
			end
			if (((270 + 1214) == (36 + 1448)) and (v136 == (3 + 0))) then
				if (((2846 - 1414) < (11830 - 8275)) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (517 - (203 + 310)))) then
					if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((3058 - (1238 + 755)) > (250 + 3328))) then
						return "templar_slash generators 14";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (1537 - (709 + 825))) or not v100.BoundlessJudgment:IsAvailable())) or ((8835 - 4040) < (2049 - 642))) then
					if (((2717 - (196 + 668)) < (19002 - 14189)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment generators 16";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (5 - 2)) or not v100.HolyBlade:IsAvailable())) or ((3654 - (171 + 662)) < (2524 - (4 + 89)))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((10073 - 7199) < (795 + 1386))) then
						return "blade_of_justice generators 18";
					end
				end
				v136 = 17 - 13;
			end
			if ((v136 == (3 + 3)) or ((4175 - (35 + 1451)) <= (1796 - (28 + 1425)))) then
				if ((v100.TemplarSlash:IsReady() and v47) or ((3862 - (941 + 1052)) == (1927 + 82))) then
					if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((5060 - (822 + 692)) < (3314 - 992))) then
						return "templar_slash generators 28";
					end
				end
				if ((v100.TemplarStrike:IsReady() and v48) or ((981 + 1101) == (5070 - (45 + 252)))) then
					if (((3210 + 34) > (364 + 691)) and v25(v100.TemplarStrike, not v17:IsSpellInRange(v100.TemplarStrike))) then
						return "templar_strike generators 30";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and ((v110 <= (7 - 4)) or not v100.BoundlessJudgment:IsAvailable())) or ((3746 - (114 + 319)) <= (2552 - 774))) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((1820 - 399) >= (1342 + 762))) then
						return "judgment generators 32";
					end
				end
				v136 = 9 - 2;
			end
			if (((3796 - 1984) <= (5212 - (556 + 1407))) and (v136 == (1211 - (741 + 465)))) then
				if (((2088 - (170 + 295)) <= (1032 + 925)) and v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (1.75 + 0)) and ((v110 <= (4 - 2)) or ((v110 <= (3 + 0)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (2 + 0)))) or ((v110 == (3 + 1)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (1232 - (957 + 273)))) and (v100.Judgment:CooldownRemains() > (v111 * (1 + 1)))))) then
					if (((1767 + 2645) == (16811 - 12399)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v122();
				if (((4611 - 2861) >= (2571 - 1729)) and v30) then
					return v30;
				end
				v136 = 29 - 23;
			end
			if (((6152 - (389 + 1391)) > (1161 + 689)) and (v136 == (0 + 0))) then
				if (((527 - 295) < (1772 - (783 + 168))) and ((v110 >= (16 - 11)) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(31 + 0, 315 - (309 + 2)) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (12 - 8))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(1243 - (1090 + 122), 1 + 1)))) then
					v30 = v122();
					if (((1739 - 1221) < (618 + 284)) and v30) then
						return v30;
					end
				end
				if (((4112 - (628 + 490)) > (154 + 704)) and v100.WakeofAshes:IsCastable() and v49 and (v110 <= (4 - 2)) and ((v100.AvengingWrath:CooldownRemains() > (27 - 21)) or (v100.Crusade:CooldownRemains() > (780 - (431 + 343)))) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (7 - 3)) or (v108 < (23 - 15)))) then
					if (v25(v100.WakeofAshes, not v17:IsInRange(8 + 2)) or ((481 + 3274) <= (2610 - (556 + 1139)))) then
						return "wake_of_ashes generators 2";
					end
				end
				if (((3961 - (6 + 9)) > (686 + 3057)) and v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (2 + 1)) and v15:HasTier(200 - (28 + 141), 1 + 1)) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((1647 - 312) >= (2342 + 964))) then
						return "blade_of_justice generators 4";
					end
				end
				v136 = 1318 - (486 + 831);
			end
			if (((12605 - 7761) > (7931 - 5678)) and (v136 == (2 + 5))) then
				if (((1429 - 977) == (1715 - (668 + 595))) and v100.HammerofWrath:IsReady() and v44 and ((v110 <= (3 + 0)) or (v17:HealthPercentage() > (5 + 15)) or not v100.VanguardsMomentum:IsAvailable())) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((12427 - 7870) < (2377 - (23 + 267)))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((5818 - (1129 + 815)) == (4261 - (371 + 16))) and v100.CrusaderStrike:IsCastable() and v39) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((3688 - (1326 + 424)) > (9346 - 4411))) then
						return "crusader_strike generators 26";
					end
				end
				if ((v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (18 - 13)) and (v86 < v108)) or ((4373 - (88 + 30)) < (4194 - (720 + 51)))) then
					if (((3234 - 1780) <= (4267 - (421 + 1355))) and v25(v100.ArcaneTorrent, not v17:IsInRange(16 - 6))) then
						return "arcane_torrent generators 28";
					end
				end
				v136 = 4 + 4;
			end
			if ((v136 == (1084 - (286 + 797))) or ((15196 - 11039) <= (4642 - 1839))) then
				if (((5292 - (397 + 42)) >= (932 + 2050)) and v100.DivineToll:IsCastable() and v42 and (v110 <= (802 - (24 + 776))) and ((v100.AvengingWrath:CooldownRemains() > (23 - 8)) or (v100.Crusade:CooldownRemains() > (800 - (222 + 563))) or (v108 < (17 - 9)))) then
					if (((2977 + 1157) > (3547 - (23 + 167))) and v25(v100.DivineToll, not v17:IsInRange(1828 - (690 + 1108)))) then
						return "divine_toll generators 6";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(12 + 19, 2 + 0)) or ((4265 - (40 + 808)) < (418 + 2116))) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((10408 - 7686) <= (157 + 7))) then
						return "judgment generators 7";
					end
				end
				if (((v110 >= (2 + 1)) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (6 + 4))) or ((2979 - (47 + 524)) < (1369 + 740))) then
					v30 = v122();
					if (v30 or ((90 - 57) == (2175 - 720))) then
						return v30;
					end
				end
				v136 = 4 - 2;
			end
			if ((v136 == (1728 - (1165 + 561))) or ((14 + 429) >= (12435 - 8420))) then
				if (((1291 + 2091) > (645 - (341 + 138))) and v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (2 + 2)) and (v106 >= (3 - 1))) then
					if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((606 - (89 + 237)) == (9840 - 6781))) then
						return "templar_slash generators 8";
					end
				end
				if (((3959 - 2078) > (2174 - (581 + 300))) and v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (1223 - (855 + 365))) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (4 - 2)) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (2 + 2)))) then
					if (((3592 - (1030 + 205)) == (2213 + 144)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice generators 10";
					end
				end
				if (((115 + 8) == (409 - (156 + 130))) and v100.HammerofWrath:IsReady() and v44 and ((v106 < (4 - 2)) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(50 - 20, 7 - 3)) and ((v110 <= (1 + 2)) or (v17:HealthPercentage() > (12 + 8)) or not v100.VanguardsMomentum:IsAvailable())) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((1125 - (10 + 59)) >= (960 + 2432))) then
						return "hammer_of_wrath generators 12";
					end
				end
				v136 = 14 - 11;
			end
		end
	end
	local function v124()
		local v137 = 1163 - (671 + 492);
		while true do
			if (((4 + 0) == v137) or ((2296 - (369 + 846)) < (285 + 790))) then
				v51 = EpicSettings.Settings['useAvengingWrath'];
				v52 = EpicSettings.Settings['useCrusade'];
				v53 = EpicSettings.Settings['useFinalReckoning'];
				v54 = EpicSettings.Settings['useShieldofVengeance'];
				v137 = 5 + 0;
			end
			if ((v137 == (1950 - (1036 + 909))) or ((835 + 214) >= (7440 - 3008))) then
				v55 = EpicSettings.Settings['avengingWrathWithCD'];
				v56 = EpicSettings.Settings['crusadeWithCD'];
				v57 = EpicSettings.Settings['finalReckoningWithCD'];
				v58 = EpicSettings.Settings['shieldofVengeanceWithCD'];
				break;
			end
			if ((v137 == (203 - (11 + 192))) or ((2410 + 2358) <= (1021 - (135 + 40)))) then
				v35 = EpicSettings.Settings['swapAuras'];
				v36 = EpicSettings.Settings['useWeapon'];
				v37 = EpicSettings.Settings['useBladeofJustice'];
				v38 = EpicSettings.Settings['useConsecration'];
				v137 = 2 - 1;
			end
			if ((v137 == (2 + 1)) or ((7397 - 4039) <= (2128 - 708))) then
				v47 = EpicSettings.Settings['useTemplarSlash'];
				v48 = EpicSettings.Settings['useTemplarStrike'];
				v49 = EpicSettings.Settings['useWakeofAshes'];
				v50 = EpicSettings.Settings['useVerdict'];
				v137 = 180 - (50 + 126);
			end
			if (((5 - 3) == v137) or ((828 + 2911) <= (4418 - (1233 + 180)))) then
				v43 = EpicSettings.Settings['useExecutionSentence'];
				v44 = EpicSettings.Settings['useHammerofWrath'];
				v45 = EpicSettings.Settings['useJudgment'];
				v46 = EpicSettings.Settings['useJusticarsVengeance'];
				v137 = 972 - (522 + 447);
			end
			if ((v137 == (1422 - (107 + 1314))) or ((770 + 889) >= (6502 - 4368))) then
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useDivineHammer'];
				v41 = EpicSettings.Settings['useDivineStorm'];
				v42 = EpicSettings.Settings['useDivineToll'];
				v137 = 1 + 1;
			end
		end
	end
	local function v125()
		local v138 = 0 - 0;
		while true do
			if ((v138 == (7 - 5)) or ((5170 - (716 + 1194)) < (41 + 2314))) then
				v65 = EpicSettings.Settings['useWordofGloryFocus'];
				v66 = EpicSettings.Settings['useWordofGloryMouseover'];
				v67 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v138 = 1 + 2;
			end
			if ((v138 == (503 - (74 + 429))) or ((1289 - 620) == (2094 + 2129))) then
				v59 = EpicSettings.Settings['useRebuke'];
				v60 = EpicSettings.Settings['useHammerofJustice'];
				v61 = EpicSettings.Settings['useDivineProtection'];
				v138 = 2 - 1;
			end
			if ((v138 == (1 + 0)) or ((5216 - 3524) < (1453 - 865))) then
				v62 = EpicSettings.Settings['useDivineShield'];
				v63 = EpicSettings.Settings['useLayonHands'];
				v64 = EpicSettings.Settings['useLayOnHandsFocus'];
				v138 = 435 - (279 + 154);
			end
			if (((784 - (454 + 324)) == v138) or ((3775 + 1022) < (3668 - (12 + 5)))) then
				v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if ((v138 == (2 + 1)) or ((10643 - 6466) > (1793 + 3057))) then
				v68 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v69 = EpicSettings.Settings['divineProtectionHP'] or (1093 - (277 + 816));
				v70 = EpicSettings.Settings['divineShieldHP'] or (0 - 0);
				v138 = 1187 - (1058 + 125);
			end
			if (((1 + 4) == v138) or ((1375 - (815 + 160)) > (4766 - 3655))) then
				v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
				v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 + 0);
				v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (0 - 0);
				v138 = 1904 - (41 + 1857);
			end
			if (((4944 - (1222 + 671)) > (2597 - 1592)) and (v138 == (5 - 1))) then
				v71 = EpicSettings.Settings['layonHandsHP'] or (1182 - (229 + 953));
				v72 = EpicSettings.Settings['layOnHandsFocusHP'] or (1774 - (1111 + 663));
				v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (1579 - (874 + 705));
				v138 = 1 + 4;
			end
		end
	end
	local function v126()
		local v139 = 0 + 0;
		while true do
			if (((7676 - 3983) <= (124 + 4258)) and (v139 == (682 - (642 + 37)))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v93 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v81 = EpicSettings.Settings['handleAfflicted'];
				v139 = 9 - 5;
			end
			if ((v139 == (454 - (233 + 221))) or ((7588 - 4306) > (3609 + 491))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (1541 - (718 + 823));
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v139 = 1 + 0;
			end
			if ((v139 == (807 - (266 + 539))) or ((10135 - 6555) < (4069 - (636 + 589)))) then
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v139 = 6 - 3;
			end
			if (((183 - 94) < (3559 + 931)) and (v139 == (2 + 2))) then
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v97 = EpicSettings.Settings['HealOOCHP'] or (1015 - (657 + 358));
				break;
			end
			if ((v139 == (2 - 1)) or ((11352 - 6369) < (2995 - (1151 + 36)))) then
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v139 = 2 + 0;
			end
		end
	end
	local function v127()
		local v140 = 0 + 0;
		while true do
			if (((11434 - 7605) > (5601 - (1552 + 280))) and (v140 == (839 - (64 + 770)))) then
				v30 = v118();
				if (((1009 + 476) <= (6592 - 3688)) and v30) then
					return v30;
				end
				v30 = v117();
				v140 = 2 + 4;
			end
			if (((5512 - (157 + 1086)) == (8544 - 4275)) and ((17 - 13) == v140)) then
				if (((593 - 206) <= (3796 - 1014)) and (v99.TargetIsValid() or v15:AffectingCombat())) then
					local v200 = 819 - (599 + 220);
					while true do
						if ((v200 == (3 - 1)) or ((3830 - (1813 + 118)) <= (671 + 246))) then
							v110 = v15:HolyPower();
							break;
						end
						if ((v200 == (1218 - (841 + 376))) or ((6041 - 1729) <= (204 + 672))) then
							if (((6092 - 3860) <= (3455 - (464 + 395))) and (v108 == (28515 - 17404))) then
								v108 = v10.FightRemains(v105, false);
							end
							v111 = v15:GCD();
							v200 = 1 + 1;
						end
						if (((2932 - (467 + 370)) < (7616 - 3930)) and (v200 == (0 + 0))) then
							v107 = v10.BossFightRemains(nil, true);
							v108 = v107;
							v200 = 3 - 2;
						end
					end
				end
				if (not v15:AffectingCombat() or ((249 + 1346) >= (10408 - 5934))) then
					if ((v100.RetributionAura:IsCastable() and (v114()) and v35) or ((5139 - (150 + 370)) < (4164 - (74 + 1208)))) then
						if (v25(v100.RetributionAura) or ((722 - 428) >= (22911 - 18080))) then
							return "retribution_aura";
						end
					end
				end
				if (((1444 + 585) <= (3474 - (14 + 376))) and (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()))) then
					local v201 = v80 and v100.CleanseToxins:IsReady() and v34;
					v30 = v99.FocusUnit(v201, nil, 34 - 14, nil, 17 + 8, v100.WordofGlory);
					if (v30 or ((1790 + 247) == (2308 + 112))) then
						return v30;
					end
				end
				v140 = 14 - 9;
			end
			if (((3354 + 1104) > (3982 - (23 + 55))) and (v140 == (6 - 3))) then
				if (((291 + 145) >= (111 + 12)) and v32) then
					v106 = #v105;
				else
					v105 = {};
					v106 = 1 - 0;
				end
				if (((158 + 342) < (2717 - (652 + 249))) and not v15:AffectingCombat() and v15:IsMounted()) then
					if (((9564 - 5990) == (5442 - (708 + 1160))) and v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) then
						if (((599 - 378) < (711 - 321)) and v25(v100.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				v109 = v113();
				v140 = 31 - (10 + 17);
			end
			if ((v140 == (2 + 6)) or ((3945 - (1400 + 332)) <= (2725 - 1304))) then
				if (((4966 - (242 + 1666)) < (2080 + 2780)) and v82) then
					local v202 = 0 + 0;
					while true do
						if ((v202 == (0 + 0)) or ((2236 - (850 + 90)) >= (7786 - 3340))) then
							v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 1420 - (360 + 1030), true);
							if (v30 or ((1233 + 160) > (12669 - 8180))) then
								return v30;
							end
							v202 = 1 - 0;
						end
						if ((v202 == (1662 - (909 + 752))) or ((5647 - (109 + 1114)) < (48 - 21))) then
							v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 12 + 18, true);
							if (v30 or ((2239 - (6 + 236)) > (2404 + 1411))) then
								return v30;
							end
							break;
						end
					end
				end
				if (((2790 + 675) > (4511 - 2598)) and v80 and v34) then
					if (((1279 - 546) < (2952 - (1076 + 57))) and v14) then
						v30 = v116();
						if (v30 or ((723 + 3672) == (5444 - (579 + 110)))) then
							return v30;
						end
					end
					if ((v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16) or v99.UnitHasDispellableDebuffByPlayer(v16))) or ((300 + 3493) < (2095 + 274))) then
						if (v100.CleanseToxins:IsReady() or ((2168 + 1916) == (672 - (174 + 233)))) then
							if (((12173 - 7815) == (7648 - 3290)) and v25(v104.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
				end
				if ((not v15:AffectingCombat() and v31 and v99.TargetIsValid()) or ((1396 + 1742) < (2167 - (663 + 511)))) then
					v30 = v120();
					if (((2971 + 359) > (505 + 1818)) and v30) then
						return v30;
					end
				end
				v140 = 27 - 18;
			end
			if ((v140 == (4 + 2)) or ((8536 - 4910) == (9656 - 5667))) then
				if (v30 or ((438 + 478) == (5198 - 2527))) then
					return v30;
				end
				if (((194 + 78) == (25 + 247)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					if (((4971 - (478 + 244)) <= (5356 - (440 + 77))) and v15:AffectingCombat()) then
						if (((1263 + 1514) < (11712 - 8512)) and v100.Intercession:IsCastable()) then
							if (((1651 - (655 + 901)) < (363 + 1594)) and v25(v100.Intercession, not v17:IsInRange(23 + 7), true)) then
								return "intercession target";
							end
						end
					elseif (((558 + 268) < (6917 - 5200)) and v100.Redemption:IsCastable()) then
						if (((2871 - (695 + 750)) >= (3773 - 2668)) and v25(v100.Redemption, not v17:IsInRange(46 - 16), true)) then
							return "redemption target";
						end
					end
				end
				if (((11075 - 8321) <= (3730 - (285 + 66))) and v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (v25(v104.RedemptionMouseover) or ((9153 - 5226) == (2723 - (682 + 628)))) then
						return "redemption mouseover";
					end
				end
				v140 = 2 + 5;
			end
			if ((v140 == (299 - (176 + 123))) or ((483 + 671) <= (572 + 216))) then
				v125();
				v124();
				v126();
				v140 = 270 - (239 + 30);
			end
			if ((v140 == (2 + 5)) or ((1580 + 63) > (5980 - 2601))) then
				if (v15:AffectingCombat() or ((8744 - 5941) > (4864 - (306 + 9)))) then
					if ((v100.Intercession:IsCastable() and (v15:HolyPower() >= (10 - 7)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((39 + 181) >= (1855 + 1167))) then
						if (((1359 + 1463) == (8069 - 5247)) and v25(v104.IntercessionMouseover)) then
							return "Intercession mouseover";
						end
					end
				end
				if (v34 or ((2436 - (1140 + 235)) == (1182 + 675))) then
					local v203 = 0 + 0;
					while true do
						if (((709 + 2051) > (1416 - (33 + 19))) and (v203 == (0 + 0))) then
							v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 119 - 79, 12 + 13, v100.WordofGlory, 3 - 1);
							if (v30 or ((4597 + 305) <= (4284 - (586 + 103)))) then
								return v30;
							end
							v203 = 1 + 0;
						end
						if ((v203 == (2 - 1)) or ((5340 - (1309 + 179)) == (528 - 235))) then
							if ((v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((679 + 880) == (12321 - 7733))) then
								if (v25(v104.BlessingofFreedomFocus) or ((3387 + 1097) == (1673 - 885))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				if (((9102 - 4534) >= (4516 - (295 + 314))) and v81) then
					if (((3060 - 1814) < (5432 - (1300 + 662))) and v77) then
						local v205 = 0 - 0;
						while true do
							if (((5823 - (1178 + 577)) >= (505 + 467)) and (v205 == (0 - 0))) then
								v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 1445 - (851 + 554));
								if (((436 + 57) < (10796 - 6903)) and v30) then
									return v30;
								end
								break;
							end
						end
					end
					if ((v78 and (v110 > (3 - 1))) or ((1775 - (115 + 187)) >= (2552 + 780))) then
						local v206 = 0 + 0;
						while true do
							if ((v206 == (0 - 0)) or ((5212 - (160 + 1001)) <= (1013 + 144))) then
								v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 28 + 12, true);
								if (((1235 - 631) < (3239 - (237 + 121))) and v30) then
									return v30;
								end
								break;
							end
						end
					end
				end
				v140 = 905 - (525 + 372);
			end
			if ((v140 == (1 - 0)) or ((2957 - 2057) == (3519 - (96 + 46)))) then
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v140 = 779 - (643 + 134);
			end
			if (((1610 + 2849) > (1416 - 825)) and (v140 == (33 - 24))) then
				if (((3259 + 139) >= (4700 - 2305)) and v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) then
					local v204 = 0 - 0;
					while true do
						if ((v204 == (719 - (316 + 403))) or ((1452 + 731) >= (7764 - 4940))) then
							if (((700 + 1236) == (4875 - 2939)) and v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) then
								if (v25(v100.LayonHands) or ((3425 + 1407) < (1391 + 2922))) then
									return "lay_on_hands_player defensive";
								end
							end
							if (((14164 - 10076) > (18501 - 14627)) and v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
								if (((8999 - 4667) == (248 + 4084)) and v25(v100.DivineShield)) then
									return "divine_shield defensive";
								end
							end
							v204 = 1 - 0;
						end
						if (((196 + 3803) >= (8532 - 5632)) and (v204 == (20 - (12 + 5)))) then
							v30 = v123();
							if (v30 or ((9807 - 7282) > (8670 - 4606))) then
								return v30;
							end
							v204 = 8 - 4;
						end
						if (((10839 - 6468) == (888 + 3483)) and (v204 == (1977 - (1656 + 317)))) then
							if (v25(v100.Pool) or ((238 + 28) > (3996 + 990))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((5293 - 3302) >= (4552 - 3627)) and (v204 == (356 - (5 + 349)))) then
							if (((2161 - 1706) < (3324 - (266 + 1005))) and v91 and (v15:HealthPercentage() <= v93)) then
								local v207 = 0 + 0;
								while true do
									if (((0 - 0) == v207) or ((1087 - 261) == (6547 - (561 + 1135)))) then
										if (((237 - 54) == (601 - 418)) and (v95 == "Refreshing Healing Potion")) then
											if (((2225 - (507 + 559)) <= (4486 - 2698)) and v101.RefreshingHealingPotion:IsReady()) then
												if (v25(v104.RefreshingHealingPotion) or ((10845 - 7338) > (4706 - (212 + 176)))) then
													return "refreshing healing potion defensive";
												end
											end
										end
										if ((v95 == "Dreamwalker's Healing Potion") or ((3980 - (250 + 655)) <= (8085 - 5120))) then
											if (((2385 - 1020) <= (3146 - 1135)) and v101.DreamwalkersHealingPotion:IsReady()) then
												if (v25(v104.RefreshingHealingPotion) or ((4732 - (1869 + 87)) > (12399 - 8824))) then
													return "dreamwalkers healing potion defensive";
												end
											end
										end
										break;
									end
								end
							end
							if ((v86 < v108) or ((4455 - (484 + 1417)) == (10296 - 5492))) then
								local v208 = 0 - 0;
								while true do
									if (((3350 - (48 + 725)) == (4209 - 1632)) and (v208 == (0 - 0))) then
										v30 = v121();
										if (v30 or ((4 + 2) >= (5047 - 3158))) then
											return v30;
										end
										v208 = 1 + 0;
									end
									if (((148 + 358) <= (2745 - (152 + 701))) and ((1312 - (430 + 881)) == v208)) then
										if ((v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36 and (v100.MarkofFyralathDebuff:AuraActiveCount() > (0 + 0)) and v15:BuffDown(v100.AvengingWrathBuff) and v15:BuffDown(v100.CrusadeBuff)) or ((2903 - (557 + 338)) > (656 + 1562))) then
											if (((1067 - 688) <= (14521 - 10374)) and v25(v104.UseWeapon)) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							v204 = 7 - 4;
						end
						if (((2 - 1) == v204) or ((5315 - (499 + 302)) <= (1875 - (39 + 827)))) then
							if ((v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) or ((9650 - 6154) == (2661 - 1469))) then
								if (v25(v100.DivineProtection) or ((826 - 618) == (4542 - 1583))) then
									return "divine_protection defensive";
								end
							end
							if (((367 + 3910) >= (3842 - 2529)) and v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) then
								if (((414 + 2173) < (5022 - 1848)) and v25(v104.Healthstone)) then
									return "healthstone defensive";
								end
							end
							v204 = 106 - (103 + 1);
						end
					end
				end
				break;
			end
			if ((v140 == (556 - (475 + 79))) or ((8906 - 4786) <= (7033 - 4835))) then
				v34 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((207 + 1389) == (756 + 102))) then
					return v30;
				end
				v105 = v15:GetEnemiesInMeleeRange(1511 - (1395 + 108));
				v140 = 8 - 5;
			end
		end
	end
	local function v128()
		local v141 = 1204 - (7 + 1197);
		while true do
			if (((1404 + 1816) == (1124 + 2096)) and ((319 - (27 + 292)) == v141)) then
				v100.MarkofFyralathDebuff:RegisterAuraTracking();
				v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
				v141 = 2 - 1;
			end
			if ((v141 == (1 - 0)) or ((5879 - 4477) > (7138 - 3518))) then
				v103();
				break;
			end
		end
	end
	v21.SetAPL(133 - 63, v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

