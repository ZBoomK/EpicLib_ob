local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1248 - (111 + 1137);
	local v6;
	while true do
		if ((v5 == (159 - (91 + 67))) or ((2866 - 1903) == (856 + 2572))) then
			return v6(...);
		end
		if ((v5 == (523 - (423 + 100))) or ((21 + 2919) < (2658 - 1698))) then
			v6 = v0[v4];
			if (not v6 or ((1660 + 1524) <= (1385 - (326 + 445)))) then
				return v1(v4, ...);
			end
			v5 = 4 - 3;
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
		if (((6963 - 3837) == (7296 - 4170)) and v100.CleanseToxins:IsAvailable()) then
			v99.DispellableDebuffs = v13.MergeTable(v99.DispellableDiseaseDebuffs, v99.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local v104 = v24.Paladin.Retribution;
	local v105;
	local v106;
	local v107 = 11822 - (530 + 181);
	local v108 = 11992 - (614 + 267);
	local v109;
	local v110 = 32 - (19 + 13);
	local v111 = 0 - 0;
	local v112;
	v10:RegisterForEvent(function()
		v107 = 25892 - 14781;
		v108 = 31739 - 20628;
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		local v129 = v15:GCDRemains();
		local v130 = v28(v100.CrusaderStrike:CooldownRemains(), v100.BladeofJustice:CooldownRemains(), v100.Judgment:CooldownRemains(), (v100.HammerofWrath:IsUsable() and v100.HammerofWrath:CooldownRemains()) or (3 + 7), v100.WakeofAshes:CooldownRemains());
		if ((v129 > v130) or ((3846 - 1659) >= (10273 - 5319))) then
			return v129;
		end
		return v130;
	end
	local function v114()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v115 = 1812 - (1293 + 519);
	local function v116()
		if ((v100.CleanseToxins:IsReady() and (v99.UnitHasDispellableDebuffByPlayer(v14) or v99.DispellableFriendlyUnit(40 - 20) or v99.UnitHasCurseDebuff(v14) or v99.UnitHasPoisonDebuff(v14))) or ((10122 - 6245) == (6836 - 3261))) then
			local v165 = 0 - 0;
			while true do
				if (((1665 - 958) > (335 + 297)) and (v165 == (0 + 0))) then
					if ((v115 == (0 - 0)) or ((127 + 419) >= (892 + 1792))) then
						v115 = GetTime();
					end
					if (((916 + 549) <= (5397 - (709 + 387))) and v99.Wait(2358 - (673 + 1185), v115)) then
						local v209 = 0 - 0;
						while true do
							if (((5471 - 3767) > (2344 - 919)) and (v209 == (0 + 0))) then
								if (v25(v104.CleanseToxinsFocus) or ((514 + 173) == (5716 - 1482))) then
									return "cleanse_toxins dispel";
								end
								v115 = 0 + 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v117()
		if ((v96 and (v15:HealthPercentage() <= v97)) or ((6639 - 3309) < (2804 - 1375))) then
			if (((3027 - (446 + 1434)) >= (1618 - (1040 + 243))) and v100.FlashofLight:IsReady()) then
				if (((10252 - 6817) > (3944 - (559 + 1288))) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v118()
		if (v16:Exists() or ((5701 - (609 + 1322)) >= (4495 - (13 + 441)))) then
			if ((v100.WordofGlory:IsReady() and v66 and not v15:CanAttack(v16) and (v16:HealthPercentage() <= v74)) or ((14166 - 10375) <= (4219 - 2608))) then
				if (v25(v104.WordofGloryMouseover) or ((22800 - 18222) <= (75 + 1933))) then
					return "word_of_glory defensive mouseover";
				end
			end
		end
		if (((4085 - 2960) <= (738 + 1338)) and (not v14 or not v14:Exists() or not v14:IsInRange(14 + 16))) then
			return;
		end
		if (v14 or ((2204 - 1461) >= (2408 + 1991))) then
			local v166 = 0 - 0;
			while true do
				if (((764 + 391) < (931 + 742)) and (v166 == (1 + 0))) then
					if ((v100.BlessingofSacrifice:IsCastable() and v68 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v76)) or ((1952 + 372) <= (566 + 12))) then
						if (((4200 - (153 + 280)) == (10877 - 7110)) and v25(v104.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((3672 + 417) == (1615 + 2474)) and v100.BlessingofProtection:IsCastable() and v67 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v75)) then
						if (((2333 + 2125) >= (1520 + 154)) and v25(v104.BlessingofProtectionFocus)) then
							return "blessing_of_protection defensive focus";
						end
					end
					break;
				end
				if (((705 + 267) <= (2159 - 741)) and (v166 == (0 + 0))) then
					if ((v100.WordofGlory:IsReady() and v65 and (v14:HealthPercentage() <= v73)) or ((5605 - (89 + 578)) < (3402 + 1360))) then
						if (v25(v104.WordofGloryFocus) or ((5205 - 2701) > (5313 - (572 + 477)))) then
							return "word_of_glory defensive focus";
						end
					end
					if (((291 + 1862) == (1293 + 860)) and v100.LayonHands:IsCastable() and v64 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v72) and v15:AffectingCombat()) then
						if (v25(v104.LayonHandsFocus) or ((61 + 446) >= (2677 - (84 + 2)))) then
							return "lay_on_hands defensive focus";
						end
					end
					v166 = 1 - 0;
				end
			end
		end
	end
	local function v119()
		v30 = v99.HandleTopTrinket(v102, v33, 29 + 11, nil);
		if (((5323 - (497 + 345)) == (115 + 4366)) and v30) then
			return v30;
		end
		v30 = v99.HandleBottomTrinket(v102, v33, 7 + 33, nil);
		if (v30 or ((3661 - (605 + 728)) < (495 + 198))) then
			return v30;
		end
	end
	local function v120()
		local v131 = 0 - 0;
		while true do
			if (((199 + 4129) == (16001 - 11673)) and (v131 == (3 + 0))) then
				if (((4399 - 2811) >= (1006 + 326)) and v100.Judgment:IsCastable() and v45) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((4663 - (457 + 32)) > (1803 + 2445))) then
						return "judgment precombat 6";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v44) or ((5988 - (832 + 570)) <= (78 + 4))) then
					if (((1008 + 2855) == (13670 - 9807)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath precombat 7";
					end
				end
				v131 = 2 + 2;
			end
			if ((v131 == (796 - (588 + 208))) or ((759 - 477) <= (1842 - (884 + 916)))) then
				if (((9648 - 5039) >= (445 + 321)) and v100.ArcaneTorrent:IsCastable() and v89 and ((v90 and v33) or not v90) and v100.FinalReckoning:IsAvailable()) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(661 - (232 + 421))) or ((3041 - (1569 + 320)) == (611 + 1877))) then
						return "arcane_torrent precombat 0";
					end
				end
				if (((651 + 2771) > (11288 - 7938)) and v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58)) then
					if (((1482 - (316 + 289)) > (984 - 608)) and v25(v100.ShieldofVengeance, not v17:IsInRange(1 + 7))) then
						return "shield_of_vengeance precombat 1";
					end
				end
				v131 = 1454 - (666 + 787);
			end
			if (((429 - (360 + 65)) == v131) or ((2914 + 204) <= (2105 - (79 + 175)))) then
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((260 - 95) >= (2725 + 767))) then
					if (((12104 - 8155) < (9351 - 4495)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike precombat 180";
					end
				end
				break;
			end
			if ((v131 == (900 - (503 + 396))) or ((4457 - (92 + 89)) < (5850 - 2834))) then
				if (((2406 + 2284) > (2442 + 1683)) and v100.JusticarsVengeance:IsAvailable() and v100.JusticarsVengeance:IsReady() and v46 and (v110 >= (15 - 11))) then
					if (v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance)) or ((7 + 43) >= (2042 - 1146))) then
						return "juscticars vengeance precombat 2";
					end
				end
				if ((v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsReady() and v50 and (v110 >= (4 + 0))) or ((819 + 895) >= (9008 - 6050))) then
					if (v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict)) or ((187 + 1304) < (981 - 337))) then
						return "final verdict precombat 3";
					end
				end
				v131 = 1246 - (485 + 759);
			end
			if (((1628 - 924) < (2176 - (442 + 747))) and ((1137 - (832 + 303)) == v131)) then
				if (((4664 - (88 + 858)) > (581 + 1325)) and v100.TemplarsVerdict:IsReady() and v50 and (v110 >= (4 + 0))) then
					if (v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict)) or ((40 + 918) > (4424 - (766 + 23)))) then
						return "templars verdict precombat 4";
					end
				end
				if (((17283 - 13782) <= (6142 - 1650)) and v100.BladeofJustice:IsCastable() and v37) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((9068 - 5626) < (8647 - 6099))) then
						return "blade_of_justice precombat 5";
					end
				end
				v131 = 1076 - (1036 + 37);
			end
		end
	end
	local function v121()
		local v132 = 0 + 0;
		local v133;
		while true do
			if (((5598 - 2723) >= (1152 + 312)) and (v132 == (1484 - (641 + 839)))) then
				if ((v100.Crusade:IsCastable() and v52 and ((v33 and v56) or not v56) and (((v110 >= (918 - (910 + 3))) and (v10.CombatTime() < (12 - 7))) or ((v110 >= (1687 - (1466 + 218))) and (v10.CombatTime() > (3 + 2))))) or ((5945 - (556 + 592)) >= (1740 + 3153))) then
					if (v25(v100.Crusade, not v17:IsInRange(818 - (329 + 479))) or ((1405 - (174 + 680)) > (7105 - 5037))) then
						return "crusade cooldowns 14";
					end
				end
				if (((4381 - 2267) > (674 + 270)) and v100.FinalReckoning:IsCastable() and v53 and ((v33 and v57) or not v57) and (((v110 >= (743 - (396 + 343))) and (v10.CombatTime() < (1 + 7))) or ((v110 >= (1480 - (29 + 1448))) and ((v10.CombatTime() >= (1397 - (135 + 1254))) or not v100.VanguardofJustice:IsAvailable())) or ((v110 >= (7 - 5)) and v100.DivineAuxiliary:IsAvailable())) and ((v100.AvengingWrath:CooldownRemains() > (46 - 36)) or (v100.Crusade:CooldownDown() and (v15:BuffDown(v100.CrusadeBuff) or (v15:BuffStack(v100.CrusadeBuff) >= (7 + 3)))))) then
					if ((v98 == "player") or ((3789 - (389 + 1138)) >= (3670 - (102 + 472)))) then
						if (v25(v104.FinalReckoningPlayer, not v17:IsInRange(10 + 0)) or ((1251 + 1004) >= (3298 + 239))) then
							return "final_reckoning cooldowns 18";
						end
					end
					if ((v98 == "cursor") or ((5382 - (320 + 1225)) < (2324 - 1018))) then
						if (((1805 + 1145) == (4414 - (157 + 1307))) and v25(v104.FinalReckoningCursor, not v17:IsInRange(1879 - (821 + 1038)))) then
							return "final_reckoning cooldowns 18";
						end
					end
				end
				break;
			end
			if ((v132 == (7 - 4)) or ((517 + 4206) < (5857 - 2559))) then
				if (((423 + 713) >= (381 - 227)) and v100.ExecutionSentence:IsCastable() and v43 and ((v15:BuffDown(v100.CrusadeBuff) and (v100.Crusade:CooldownRemains() > (1041 - (834 + 192)))) or (v15:BuffStack(v100.CrusadeBuff) == (1 + 9)) or not v100.Crusade:IsAvailable() or (v100.AvengingWrath:CooldownRemains() < (0.75 + 0)) or (v100.AvengingWrath:CooldownRemains() > (1 + 14))) and (((v110 >= (5 - 1)) and (v10.CombatTime() < (309 - (300 + 4)))) or ((v110 >= (1 + 2)) and (v10.CombatTime() > (13 - 8))) or ((v110 >= (364 - (112 + 250))) and v100.DivineAuxiliary:IsAvailable())) and (((v17:TimeToDie() > (4 + 4)) and not v100.ExecutionersWill:IsAvailable()) or (v17:TimeToDie() > (29 - 17)))) then
					if (v25(v100.ExecutionSentence, not v17:IsSpellInRange(v100.ExecutionSentence)) or ((156 + 115) > (2456 + 2292))) then
						return "execution_sentence cooldowns 16";
					end
				end
				if (((3545 + 1195) >= (1563 + 1589)) and v100.AvengingWrath:IsCastable() and v51 and ((v33 and v55) or not v55) and (((v110 >= (3 + 1)) and (v10.CombatTime() < (1419 - (1001 + 413)))) or ((v110 >= (6 - 3)) and ((v10.CombatTime() > (887 - (244 + 638))) or not v100.VanguardofJustice:IsAvailable())) or ((v110 >= (695 - (627 + 66))) and v100.DivineAuxiliary:IsAvailable() and (v100.ExecutionSentence:CooldownUp() or v100.FinalReckoning:CooldownUp()))) and ((v106 == (2 - 1)) or (v17:TimeToDie() > (612 - (512 + 90))))) then
					if (v25(v100.AvengingWrath, not v17:IsInRange(1916 - (1665 + 241))) or ((3295 - (373 + 344)) >= (1529 + 1861))) then
						return "avenging_wrath cooldowns 12";
					end
				end
				v132 = 2 + 2;
			end
			if (((108 - 67) <= (2810 - 1149)) and (v132 == (1099 - (35 + 1064)))) then
				v133 = v99.HandleDPSPotion(v33 and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.Crusade) == (8 + 2)))));
				if (((1285 - 684) < (15 + 3545)) and v133) then
					return v133;
				end
				v132 = 1237 - (298 + 938);
			end
			if (((1494 - (233 + 1026)) < (2353 - (636 + 1030))) and (v132 == (1 + 0))) then
				if (((4444 + 105) > (343 + 810)) and v100.LightsJudgment:IsCastable() and v89 and ((v90 and v33) or not v90)) then
					if (v25(v100.LightsJudgment, not v17:IsInRange(3 + 37)) or ((4895 - (55 + 166)) < (906 + 3766))) then
						return "lights_judgment cooldowns 4";
					end
				end
				if (((369 + 3299) < (17418 - 12857)) and v100.Fireblood:IsCastable() and v89 and ((v90 and v33) or not v90) and (v15:BuffUp(v100.AvengingWrathBuff) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) == (307 - (36 + 261)))))) then
					if (v25(v100.Fireblood, not v17:IsInRange(17 - 7)) or ((1823 - (34 + 1334)) == (1386 + 2219))) then
						return "fireblood cooldowns 6";
					end
				end
				v132 = 2 + 0;
			end
			if ((v132 == (1285 - (1035 + 248))) or ((2684 - (20 + 1)) == (1726 + 1586))) then
				if (((4596 - (134 + 185)) <= (5608 - (549 + 584))) and v87 and ((v33 and v88) or not v88) and v17:IsInRange(693 - (314 + 371))) then
					local v197 = 0 - 0;
					while true do
						if ((v197 == (968 - (478 + 490))) or ((461 + 409) == (2361 - (786 + 386)))) then
							v30 = v119();
							if (((5029 - 3476) <= (4512 - (1055 + 324))) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v100.ShieldofVengeance:IsCastable() and v54 and ((v33 and v58) or not v58) and (v108 > (1355 - (1093 + 247))) and (not v100.ExecutionSentence:IsAvailable() or v17:DebuffDown(v100.ExecutionSentence))) or ((1988 + 249) >= (370 + 3141))) then
					if (v25(v100.ShieldofVengeance) or ((5256 - 3932) > (10249 - 7229))) then
						return "shield_of_vengeance cooldowns 10";
					end
				end
				v132 = 8 - 5;
			end
		end
	end
	local function v122()
		local v134 = 0 - 0;
		while true do
			if (((1 + 1) == v134) or ((11526 - 8534) == (6483 - 4602))) then
				if (((2343 + 763) > (3902 - 2376)) and v100.TemplarsVerdict:IsReady() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (691 - (364 + 324)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (27 - 17))))) then
					if (((7253 - 4230) < (1283 + 2587)) and v25(v100.TemplarsVerdict, not v17:IsSpellInRange(v100.TemplarsVerdict))) then
						return "templars verdict finishers 8";
					end
				end
				break;
			end
			if (((598 - 455) > (117 - 43)) and (v134 == (0 - 0))) then
				v112 = ((v106 >= (1271 - (1249 + 19))) or ((v106 >= (2 + 0)) and not v100.DivineArbiter:IsAvailable()) or v15:BuffUp(v100.EmpyreanPowerBuff)) and v15:BuffDown(v100.EmpyreanLegacyBuff) and not (v15:BuffUp(v100.DivineArbiterBuff) and (v15:BuffStack(v100.DivineArbiterBuff) > (93 - 69)));
				if (((1104 - (686 + 400)) < (1658 + 454)) and v100.DivineStorm:IsReady() and v41 and v112 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (232 - (73 + 156)))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (1 + 9))))) then
					if (((1908 - (721 + 90)) <= (19 + 1609)) and v25(v100.DivineStorm, not v17:IsInRange(32 - 22))) then
						return "divine_storm finishers 2";
					end
				end
				v134 = 471 - (224 + 246);
			end
			if (((7500 - 2870) == (8524 - 3894)) and (v134 == (1 + 0))) then
				if (((85 + 3455) > (1971 + 712)) and v100.JusticarsVengeance:IsReady() and v46 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (5 - 2))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (33 - 23))))) then
					if (((5307 - (203 + 310)) >= (5268 - (1238 + 755))) and v25(v100.JusticarsVengeance, not v17:IsSpellInRange(v100.JusticarsVengeance))) then
						return "justicars_vengeance finishers 4";
					end
				end
				if (((104 + 1380) == (3018 - (709 + 825))) and v100.FinalVerdict:IsAvailable() and v100.FinalVerdict:IsCastable() and v50 and (not v100.Crusade:IsAvailable() or (v100.Crusade:CooldownRemains() > (v111 * (4 - 1))) or (v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (14 - 4))))) then
					if (((2296 - (196 + 668)) < (14036 - 10481)) and v25(v100.FinalVerdict, not v17:IsSpellInRange(v100.FinalVerdict))) then
						return "final verdict finishers 6";
					end
				end
				v134 = 3 - 1;
			end
		end
	end
	local function v123()
		local v135 = 833 - (171 + 662);
		while true do
			if ((v135 == (93 - (4 + 89))) or ((3732 - 2667) > (1303 + 2275))) then
				if ((v110 >= (21 - 16)) or (v15:BuffUp(v100.EchoesofWrathBuff) and v15:HasTier(13 + 18, 1490 - (35 + 1451)) and v100.CrusadingStrikes:IsAvailable()) or ((v17:DebuffUp(v100.JudgmentDebuff) or (v110 == (1457 - (28 + 1425)))) and v15:BuffUp(v100.DivineResonanceBuff) and not v15:HasTier(2024 - (941 + 1052), 2 + 0)) or ((6309 - (822 + 692)) < (2008 - 601))) then
					v30 = v122();
					if (((873 + 980) < (5110 - (45 + 252))) and v30) then
						return v30;
					end
				end
				if ((v100.WakeofAshes:IsCastable() and v49 and (v110 <= (2 + 0)) and ((v100.AvengingWrath:CooldownRemains() > (3 + 3)) or (v100.Crusade:CooldownRemains() > (14 - 8))) and (not v100.ExecutionSentence:IsAvailable() or (v100.ExecutionSentence:CooldownRemains() > (437 - (114 + 319))) or (v108 < (11 - 3)))) or ((3614 - 793) < (1550 + 881))) then
					if (v25(v100.WakeofAshes, not v17:IsInRange(14 - 4)) or ((6021 - 3147) < (4144 - (556 + 1407)))) then
						return "wake_of_ashes generators 2";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37 and not v17:DebuffUp(v100.ExpurgationDebuff) and (v110 <= (1209 - (741 + 465))) and v15:HasTier(496 - (170 + 295), 2 + 0)) or ((2470 + 219) <= (844 - 501))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((1550 + 319) == (1289 + 720))) then
						return "blade_of_justice generators 4";
					end
				end
				v135 = 1 + 0;
			end
			if ((v135 == (1233 - (957 + 273))) or ((949 + 2597) < (930 + 1392))) then
				if ((v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (15 - 11))) or ((5486 - 3404) == (14579 - 9806))) then
					if (((16063 - 12819) > (2835 - (389 + 1391))) and v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash))) then
						return "templar_slash generators 14";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and v17:DebuffDown(v100.JudgmentDebuff) and ((v110 <= (2 + 1)) or not v100.BoundlessJudgment:IsAvailable())) or ((345 + 2968) <= (4047 - 2269))) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2372 - (783 + 168)) >= (7061 - 4957))) then
						return "judgment generators 16";
					end
				end
				if (((1783 + 29) <= (3560 - (309 + 2))) and v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (9 - 6)) or not v100.HolyBlade:IsAvailable())) then
					if (((2835 - (1090 + 122)) <= (635 + 1322)) and v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice))) then
						return "blade_of_justice generators 18";
					end
				end
				v135 = 13 - 9;
			end
			if (((3020 + 1392) == (5530 - (628 + 490))) and (v135 == (2 + 5))) then
				if (((4332 - 2582) >= (3847 - 3005)) and v100.HammerofWrath:IsReady() and v44 and ((v110 <= (777 - (431 + 343))) or (v17:HealthPercentage() > (40 - 20)) or not v100.VanguardsMomentum:IsAvailable())) then
					if (((12647 - 8275) > (1462 + 388)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath generators 34";
					end
				end
				if (((30 + 202) < (2516 - (556 + 1139))) and v100.CrusaderStrike:IsCastable() and v39) then
					if (((533 - (6 + 9)) < (166 + 736)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike generators 26";
					end
				end
				if (((1534 + 1460) > (1027 - (28 + 141))) and v100.ArcaneTorrent:IsCastable() and ((v90 and v33) or not v90) and v89 and (v110 < (2 + 3)) and (v86 < v108)) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(12 - 2)) or ((2660 + 1095) <= (2232 - (486 + 831)))) then
						return "arcane_torrent generators 28";
					end
				end
				v135 = 20 - 12;
			end
			if (((13892 - 9946) > (708 + 3035)) and (v135 == (3 - 2))) then
				if ((v100.DivineToll:IsCastable() and v42 and (v110 <= (1265 - (668 + 595))) and ((v100.AvengingWrath:CooldownRemains() > (14 + 1)) or (v100.Crusade:CooldownRemains() > (4 + 11)) or (v108 < (21 - 13)))) or ((1625 - (23 + 267)) >= (5250 - (1129 + 815)))) then
					if (((5231 - (371 + 16)) > (4003 - (1326 + 424))) and v25(v100.DivineToll, not v17:IsInRange(56 - 26))) then
						return "divine_toll generators 6";
					end
				end
				if (((1651 - 1199) == (570 - (88 + 30))) and v100.Judgment:IsReady() and v45 and v17:DebuffUp(v100.ExpurgationDebuff) and v15:BuffDown(v100.EchoesofWrathBuff) and v15:HasTier(802 - (720 + 51), 4 - 2)) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((6333 - (421 + 1355)) < (3442 - 1355))) then
						return "judgment generators 7";
					end
				end
				if (((1903 + 1971) == (4957 - (286 + 797))) and (v110 >= (10 - 7)) and v15:BuffUp(v100.CrusadeBuff) and (v15:BuffStack(v100.CrusadeBuff) < (16 - 6))) then
					local v198 = 439 - (397 + 42);
					while true do
						if ((v198 == (0 + 0)) or ((2738 - (24 + 776)) > (7602 - 2667))) then
							v30 = v122();
							if (v30 or ((5040 - (222 + 563)) < (7541 - 4118))) then
								return v30;
							end
							break;
						end
					end
				end
				v135 = 2 + 0;
			end
			if (((1644 - (23 + 167)) <= (4289 - (690 + 1108))) and (v135 == (3 + 5))) then
				if ((v100.Consecration:IsCastable() and v38) or ((3429 + 728) <= (3651 - (40 + 808)))) then
					if (((800 + 4053) >= (11403 - 8421)) and v25(v100.Consecration, not v17:IsInRange(10 + 0))) then
						return "consecration generators 30";
					end
				end
				if (((2187 + 1947) > (1841 + 1516)) and v100.DivineHammer:IsCastable() and v40) then
					if (v25(v100.DivineHammer, not v17:IsInRange(581 - (47 + 524))) or ((2218 + 1199) < (6926 - 4392))) then
						return "divine_hammer generators 32";
					end
				end
				break;
			end
			if ((v135 == (5 - 1)) or ((6207 - 3485) <= (1890 - (1165 + 561)))) then
				if ((v17:HealthPercentage() <= (1 + 19)) or v15:BuffUp(v100.AvengingWrathBuff) or v15:BuffUp(v100.CrusadeBuff) or v15:BuffUp(v100.EmpyreanPowerBuff) or ((7457 - 5049) < (805 + 1304))) then
					local v199 = 479 - (341 + 138);
					while true do
						if (((0 + 0) == v199) or ((67 - 34) == (1781 - (89 + 237)))) then
							v30 = v122();
							if (v30 or ((1424 - 981) >= (8452 - 4437))) then
								return v30;
							end
							break;
						end
					end
				end
				if (((4263 - (581 + 300)) > (1386 - (855 + 365))) and v100.Consecration:IsCastable() and v38 and v17:DebuffDown(v100.ConsecrationDebuff) and (v106 >= (4 - 2))) then
					if (v25(v100.Consecration, not v17:IsInRange(4 + 6)) or ((1515 - (1030 + 205)) == (2872 + 187))) then
						return "consecration generators 22";
					end
				end
				if (((1750 + 131) > (1579 - (156 + 130))) and v100.DivineHammer:IsCastable() and v40 and (v106 >= (4 - 2))) then
					if (((3971 - 1614) == (4826 - 2469)) and v25(v100.DivineHammer, not v17:IsInRange(3 + 7))) then
						return "divine_hammer generators 24";
					end
				end
				v135 = 3 + 2;
			end
			if (((192 - (10 + 59)) == (35 + 88)) and (v135 == (9 - 7))) then
				if ((v100.TemplarSlash:IsReady() and v47 and ((v100.TemplarStrike:TimeSinceLastCast() + v111) < (1167 - (671 + 492))) and (v106 >= (2 + 0))) or ((2271 - (369 + 846)) >= (899 + 2493))) then
					if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((923 + 158) < (3020 - (1036 + 909)))) then
						return "templar_slash generators 8";
					end
				end
				if ((v100.BladeofJustice:IsCastable() and v37 and ((v110 <= (3 + 0)) or not v100.HolyBlade:IsAvailable()) and (((v106 >= (2 - 0)) and not v100.CrusadingStrikes:IsAvailable()) or (v106 >= (207 - (11 + 192))))) or ((531 + 518) >= (4607 - (135 + 40)))) then
					if (v25(v100.BladeofJustice, not v17:IsSpellInRange(v100.BladeofJustice)) or ((11552 - 6784) <= (510 + 336))) then
						return "blade_of_justice generators 10";
					end
				end
				if ((v100.HammerofWrath:IsReady() and v44 and ((v106 < (4 - 2)) or not v100.BlessedChampion:IsAvailable() or v15:HasTier(44 - 14, 180 - (50 + 126))) and ((v110 <= (8 - 5)) or (v17:HealthPercentage() > (5 + 15)) or not v100.VanguardsMomentum:IsAvailable())) or ((4771 - (1233 + 180)) <= (2389 - (522 + 447)))) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((5160 - (107 + 1314)) <= (1395 + 1610))) then
						return "hammer_of_wrath generators 12";
					end
				end
				v135 = 8 - 5;
			end
			if ((v135 == (3 + 2)) or ((3294 - 1635) >= (8443 - 6309))) then
				if ((v100.CrusaderStrike:IsCastable() and v39 and (v100.CrusaderStrike:ChargesFractional() >= (1911.75 - (716 + 1194))) and ((v110 <= (1 + 1)) or ((v110 <= (1 + 2)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (505 - (74 + 429))))) or ((v110 == (7 - 3)) and (v100.BladeofJustice:CooldownRemains() > (v111 * (1 + 1))) and (v100.Judgment:CooldownRemains() > (v111 * (4 - 2)))))) or ((2307 + 953) < (7260 - 4905))) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((1653 - 984) == (4656 - (279 + 154)))) then
						return "crusader_strike generators 26";
					end
				end
				v30 = v122();
				if (v30 or ((2470 - (454 + 324)) < (463 + 125))) then
					return v30;
				end
				v135 = 23 - (12 + 5);
			end
			if ((v135 == (4 + 2)) or ((12222 - 7425) < (1350 + 2301))) then
				if ((v100.TemplarSlash:IsReady() and v47) or ((5270 - (277 + 816)) > (20724 - 15874))) then
					if (v25(v100.TemplarSlash, not v17:IsSpellInRange(v100.TemplarSlash)) or ((1583 - (1058 + 125)) > (209 + 902))) then
						return "templar_slash generators 28";
					end
				end
				if (((4026 - (815 + 160)) > (4312 - 3307)) and v100.TemplarStrike:IsReady() and v48) then
					if (((8766 - 5073) <= (1046 + 3336)) and v25(v100.TemplarStrike, not v17:IsSpellInRange(v100.TemplarStrike))) then
						return "templar_strike generators 30";
					end
				end
				if ((v100.Judgment:IsReady() and v45 and ((v110 <= (8 - 5)) or not v100.BoundlessJudgment:IsAvailable())) or ((5180 - (41 + 1857)) > (5993 - (1222 + 671)))) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((9252 - 5672) < (4087 - 1243))) then
						return "judgment generators 32";
					end
				end
				v135 = 1189 - (229 + 953);
			end
		end
	end
	local function v124()
		v35 = EpicSettings.Settings['swapAuras'];
		v36 = EpicSettings.Settings['useWeapon'];
		v37 = EpicSettings.Settings['useBladeofJustice'];
		v38 = EpicSettings.Settings['useConsecration'];
		v39 = EpicSettings.Settings['useCrusaderStrike'];
		v40 = EpicSettings.Settings['useDivineHammer'];
		v41 = EpicSettings.Settings['useDivineStorm'];
		v42 = EpicSettings.Settings['useDivineToll'];
		v43 = EpicSettings.Settings['useExecutionSentence'];
		v44 = EpicSettings.Settings['useHammerofWrath'];
		v45 = EpicSettings.Settings['useJudgment'];
		v46 = EpicSettings.Settings['useJusticarsVengeance'];
		v47 = EpicSettings.Settings['useTemplarSlash'];
		v48 = EpicSettings.Settings['useTemplarStrike'];
		v49 = EpicSettings.Settings['useWakeofAshes'];
		v50 = EpicSettings.Settings['useVerdict'];
		v51 = EpicSettings.Settings['useAvengingWrath'];
		v52 = EpicSettings.Settings['useCrusade'];
		v53 = EpicSettings.Settings['useFinalReckoning'];
		v54 = EpicSettings.Settings['useShieldofVengeance'];
		v55 = EpicSettings.Settings['avengingWrathWithCD'];
		v56 = EpicSettings.Settings['crusadeWithCD'];
		v57 = EpicSettings.Settings['finalReckoningWithCD'];
		v58 = EpicSettings.Settings['shieldofVengeanceWithCD'];
	end
	local function v125()
		local v160 = 1774 - (1111 + 663);
		while true do
			if (((1668 - (874 + 705)) < (629 + 3861)) and (v160 == (4 + 1))) then
				v98 = EpicSettings.Settings['finalReckoningSetting'] or "";
				break;
			end
			if ((v160 == (3 - 1)) or ((141 + 4842) < (2487 - (642 + 37)))) then
				v67 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v68 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v69 = EpicSettings.Settings['divineProtectionHP'] or (0 + 0);
				v70 = EpicSettings.Settings['divineShieldHP'] or (0 + 0);
				v160 = 7 - 4;
			end
			if (((4283 - (233 + 221)) > (8715 - 4946)) and (v160 == (3 + 0))) then
				v71 = EpicSettings.Settings['layonHandsHP'] or (1541 - (718 + 823));
				v72 = EpicSettings.Settings['layOnHandsFocusHP'] or (0 + 0);
				v73 = EpicSettings.Settings['wordofGloryFocusHP'] or (805 - (266 + 539));
				v74 = EpicSettings.Settings['wordofGloryMouseoverHP'] or (0 - 0);
				v160 = 1229 - (636 + 589);
			end
			if (((3525 - 2040) <= (5989 - 3085)) and (v160 == (4 + 0))) then
				v75 = EpicSettings.Settings['blessingofProtectionFocusHP'] or (0 + 0);
				v76 = EpicSettings.Settings['blessingofSacrificeFocusHP'] or (1015 - (657 + 358));
				v77 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v78 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				v160 = 13 - 8;
			end
			if (((9725 - 5456) == (5456 - (1151 + 36))) and (v160 == (1 + 0))) then
				v63 = EpicSettings.Settings['useLayonHands'];
				v64 = EpicSettings.Settings['useLayOnHandsFocus'];
				v65 = EpicSettings.Settings['useWordofGloryFocus'];
				v66 = EpicSettings.Settings['useWordofGloryMouseover'];
				v160 = 1 + 1;
			end
			if (((1155 - 768) <= (4614 - (1552 + 280))) and (v160 == (834 - (64 + 770)))) then
				v59 = EpicSettings.Settings['useRebuke'];
				v60 = EpicSettings.Settings['useHammerofJustice'];
				v61 = EpicSettings.Settings['useDivineProtection'];
				v62 = EpicSettings.Settings['useDivineShield'];
				v160 = 1 + 0;
			end
		end
	end
	local function v126()
		local v161 = 0 - 0;
		while true do
			if ((v161 == (1 + 4)) or ((3142 - (157 + 1086)) <= (1834 - 917))) then
				v81 = EpicSettings.Settings['handleAfflicted'];
				v82 = EpicSettings.Settings['HandleIncorporeal'];
				v96 = EpicSettings.Settings['HealOOC'];
				v161 = 26 - 20;
			end
			if ((v161 == (2 - 0)) or ((5884 - 1572) <= (1695 - (599 + 220)))) then
				v87 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v88 = EpicSettings.Settings['trinketsWithCD'];
				v161 = 5 - 2;
			end
			if (((4163 - (1813 + 118)) <= (1898 + 698)) and (v161 == (1220 - (841 + 376)))) then
				v90 = EpicSettings.Settings['racialsWithCD'];
				v92 = EpicSettings.Settings['useHealthstone'];
				v91 = EpicSettings.Settings['useHealingPotion'];
				v161 = 5 - 1;
			end
			if (((487 + 1608) < (10060 - 6374)) and (v161 == (859 - (464 + 395)))) then
				v86 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v83 = EpicSettings.Settings['InterruptWithStun'];
				v84 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v161 = 1 + 0;
			end
			if ((v161 == (838 - (467 + 370))) or ((3295 - 1700) >= (3285 + 1189))) then
				v85 = EpicSettings.Settings['InterruptThreshold'];
				v80 = EpicSettings.Settings['DispelDebuffs'];
				v79 = EpicSettings.Settings['DispelBuffs'];
				v161 = 6 - 4;
			end
			if ((v161 == (1 + 5)) or ((10745 - 6126) < (3402 - (150 + 370)))) then
				v97 = EpicSettings.Settings['HealOOCHP'] or (1282 - (74 + 1208));
				break;
			end
			if ((v161 == (9 - 5)) or ((1394 - 1100) >= (3438 + 1393))) then
				v94 = EpicSettings.Settings['healthstoneHP'] or (390 - (14 + 376));
				v93 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v161 = 4 + 1;
			end
		end
	end
	local function v127()
		local v162 = 0 + 0;
		while true do
			if (((1936 + 93) <= (9036 - 5952)) and (v162 == (4 + 1))) then
				v30 = v118();
				if (v30 or ((2115 - (23 + 55)) == (5735 - 3315))) then
					return v30;
				end
				v30 = v117();
				v162 = 5 + 1;
			end
			if (((4004 + 454) > (6052 - 2148)) and (v162 == (0 + 0))) then
				v125();
				v124();
				v126();
				v162 = 902 - (652 + 249);
			end
			if (((1166 - 730) >= (1991 - (708 + 1160))) and (v162 == (24 - 15))) then
				if (((911 - 411) < (1843 - (10 + 17))) and v15:AffectingCombat() and v99.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting()) then
					local v200 = 0 + 0;
					while true do
						if (((5306 - (1400 + 332)) == (6854 - 3280)) and ((1912 - (242 + 1666)) == v200)) then
							if (((95 + 126) < (143 + 247)) and v25(v100.Pool)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if (((1 + 0) == v200) or ((3153 - (850 + 90)) <= (2488 - 1067))) then
							if (((4448 - (360 + 1030)) < (4301 + 559)) and v61 and v100.DivineProtection:IsCastable() and (v15:HealthPercentage() <= v69)) then
								if (v25(v100.DivineProtection) or ((3657 - 2361) >= (6116 - 1670))) then
									return "divine_protection defensive";
								end
							end
							if ((v101.Healthstone:IsReady() and v92 and (v15:HealthPercentage() <= v94)) or ((3054 - (909 + 752)) > (5712 - (109 + 1114)))) then
								if (v25(v104.Healthstone) or ((8099 - 3675) < (11 + 16))) then
									return "healthstone defensive";
								end
							end
							v200 = 244 - (6 + 236);
						end
						if ((v200 == (2 + 1)) or ((1608 + 389) > (8997 - 5182))) then
							v30 = v123();
							if (((6052 - 2587) > (3046 - (1076 + 57))) and v30) then
								return v30;
							end
							v200 = 1 + 3;
						end
						if (((1422 - (579 + 110)) < (144 + 1675)) and (v200 == (2 + 0))) then
							if ((v91 and (v15:HealthPercentage() <= v93)) or ((2333 + 2062) == (5162 - (174 + 233)))) then
								local v210 = 0 - 0;
								while true do
									if ((v210 == (0 - 0)) or ((1687 + 2106) < (3543 - (663 + 511)))) then
										if ((v95 == "Refreshing Healing Potion") or ((3644 + 440) == (58 + 207))) then
											if (((13435 - 9077) == (2640 + 1718)) and v101.RefreshingHealingPotion:IsReady()) then
												if (v25(v104.RefreshingHealingPotion) or ((7387 - 4249) < (2403 - 1410))) then
													return "refreshing healing potion defensive";
												end
											end
										end
										if (((1590 + 1740) > (4521 - 2198)) and (v95 == "Dreamwalker's Healing Potion")) then
											if (v101.DreamwalkersHealingPotion:IsReady() or ((2585 + 1041) == (365 + 3624))) then
												if (v25(v104.RefreshingHealingPotion) or ((1638 - (478 + 244)) == (3188 - (440 + 77)))) then
													return "dreamwalkers healing potion defensive";
												end
											end
										end
										v210 = 1 + 0;
									end
									if (((995 - 723) == (1828 - (655 + 901))) and ((1 + 0) == v210)) then
										if (((3253 + 996) <= (3268 + 1571)) and (v95 == "Potion of Withering Dreams")) then
											if (((11187 - 8410) < (4645 - (695 + 750))) and v101.PotionOfWitheringDreams:IsReady()) then
												if (((324 - 229) < (3020 - 1063)) and v25(v104.RefreshingHealingPotion)) then
													return "potion of withering dreams defensive";
												end
											end
										end
										break;
									end
								end
							end
							if (((3321 - 2495) < (2068 - (285 + 66))) and (v86 < v108)) then
								v30 = v121();
								if (((3323 - 1897) >= (2415 - (682 + 628))) and v30) then
									return v30;
								end
								if (((444 + 2310) <= (3678 - (176 + 123))) and v33 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v36 and (v100.MarkofFyralathDebuff:AuraActiveCount() > (0 + 0)) and v15:BuffDown(v100.AvengingWrathBuff) and v15:BuffDown(v100.CrusadeBuff)) then
									if (v25(v104.UseWeapon) or ((2849 + 1078) == (1682 - (239 + 30)))) then
										return "Fyralath The Dreamrender used";
									end
								end
							end
							v200 = 1 + 2;
						end
						if (((0 + 0) == v200) or ((2042 - 888) <= (2458 - 1670))) then
							if ((v63 and (v15:HealthPercentage() <= v71) and v100.LayonHands:IsReady() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((1958 - (306 + 9)) > (11791 - 8412))) then
								if (v25(v100.LayonHands) or ((488 + 2315) > (2792 + 1757))) then
									return "lay_on_hands_player defensive";
								end
							end
							if ((v62 and (v15:HealthPercentage() <= v70) and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((106 + 114) >= (8641 - 5619))) then
								if (((4197 - (1140 + 235)) == (1796 + 1026)) and v25(v100.DivineShield)) then
									return "divine_shield defensive";
								end
							end
							v200 = 1 + 0;
						end
					end
				end
				break;
			end
			if (((1 + 1) == v162) or ((1113 - (33 + 19)) == (671 + 1186))) then
				v34 = EpicSettings.Toggles['dispel'];
				if (((8272 - 5512) > (601 + 763)) and v15:IsDeadOrGhost()) then
					return v30;
				end
				v105 = v15:GetEnemiesInMeleeRange(15 - 7);
				v162 = 3 + 0;
			end
			if ((v162 == (693 - (586 + 103))) or ((447 + 4455) <= (11067 - 7472))) then
				if (v99.TargetIsValid() or v15:AffectingCombat() or ((5340 - (1309 + 179)) == (528 - 235))) then
					local v201 = 0 + 0;
					while true do
						if ((v201 == (5 - 3)) or ((1178 + 381) == (9747 - 5159))) then
							v110 = v15:HolyPower();
							break;
						end
						if ((v201 == (1 - 0)) or ((5093 - (295 + 314)) == (1935 - 1147))) then
							if (((6530 - (1300 + 662)) >= (12268 - 8361)) and (v108 == (12866 - (1178 + 577)))) then
								v108 = v10.FightRemains(v105, false);
							end
							v111 = v15:GCD();
							v201 = 2 + 0;
						end
						if (((3683 - 2437) < (4875 - (851 + 554))) and (v201 == (0 + 0))) then
							v107 = v10.BossFightRemains(nil, true);
							v108 = v107;
							v201 = 2 - 1;
						end
					end
				end
				if (((8834 - 4766) >= (1274 - (115 + 187))) and not v15:AffectingCombat()) then
					if (((378 + 115) < (3686 + 207)) and v100.RetributionAura:IsCastable() and (v114()) and v35) then
						if (v25(v100.RetributionAura) or ((5804 - 4331) >= (4493 - (160 + 1001)))) then
							return "retribution_aura";
						end
					end
				end
				if (v15:AffectingCombat() or (v80 and v100.CleanseToxins:IsAvailable()) or ((3544 + 507) <= (799 + 358))) then
					local v202 = 0 - 0;
					local v203;
					while true do
						if (((962 - (237 + 121)) < (3778 - (525 + 372))) and (v202 == (1 - 0))) then
							if (v30 or ((2957 - 2057) == (3519 - (96 + 46)))) then
								return v30;
							end
							break;
						end
						if (((5236 - (643 + 134)) > (214 + 377)) and (v202 == (0 - 0))) then
							v203 = v80 and v100.CleanseToxins:IsReady() and v34;
							v30 = v99.FocusUnit(v203, nil, 74 - 54, nil, 24 + 1, v100.WordofGlory);
							v202 = 1 - 0;
						end
					end
				end
				v162 = 10 - 5;
			end
			if (((4117 - (316 + 403)) >= (1592 + 803)) and (v162 == (16 - 10))) then
				if (v30 or ((789 + 1394) >= (7111 - 4287))) then
					return v30;
				end
				if (((1372 + 564) == (624 + 1312)) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					if (v15:AffectingCombat() or ((16742 - 11910) < (20598 - 16285))) then
						if (((8492 - 4404) > (222 + 3652)) and v100.Intercession:IsCastable()) then
							if (((8527 - 4195) == (212 + 4120)) and v25(v100.Intercession, not v17:IsInRange(88 - 58), true)) then
								return "intercession target";
							end
						end
					elseif (((4016 - (12 + 5)) >= (11263 - 8363)) and v100.Redemption:IsCastable()) then
						if (v25(v100.Redemption, not v17:IsInRange(64 - 34), true) or ((5367 - 2842) > (10077 - 6013))) then
							return "redemption target";
						end
					end
				end
				if (((888 + 3483) == (6344 - (1656 + 317))) and v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (v25(v104.RedemptionMouseover) or ((238 + 28) > (3996 + 990))) then
						return "redemption mouseover";
					end
				end
				v162 = 18 - 11;
			end
			if (((9798 - 7807) >= (1279 - (5 + 349))) and (v162 == (37 - 29))) then
				if (((1726 - (266 + 1005)) < (1353 + 700)) and v82) then
					local v204 = 0 - 0;
					while true do
						if ((v204 == (0 - 0)) or ((2522 - (561 + 1135)) == (6321 - 1470))) then
							v30 = v99.HandleIncorporeal(v100.Repentance, v104.RepentanceMouseOver, 98 - 68, true);
							if (((1249 - (507 + 559)) == (459 - 276)) and v30) then
								return v30;
							end
							v204 = 3 - 2;
						end
						if (((1547 - (212 + 176)) <= (2693 - (250 + 655))) and (v204 == (2 - 1))) then
							v30 = v99.HandleIncorporeal(v100.TurnEvil, v104.TurnEvilMouseOver, 52 - 22, true);
							if (v30 or ((5486 - 1979) > (6274 - (1869 + 87)))) then
								return v30;
							end
							break;
						end
					end
				end
				if ((v80 and v34) or ((10665 - 7590) <= (4866 - (484 + 1417)))) then
					local v205 = 0 - 0;
					while true do
						if (((2287 - 922) <= (2784 - (48 + 725))) and (v205 == (0 - 0))) then
							if (v14 or ((7447 - 4671) > (2078 + 1497))) then
								local v211 = 0 - 0;
								while true do
									if (((0 + 0) == v211) or ((745 + 1809) == (5657 - (152 + 701)))) then
										v30 = v116();
										if (((3888 - (430 + 881)) == (987 + 1590)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							if ((v16 and v16:Exists() and not v15:CanAttack(v16) and v16:IsAPlayer() and (v99.UnitHasCurseDebuff(v16) or v99.UnitHasPoisonDebuff(v16) or v99.UnitHasDispellableDebuffByPlayer(v16))) or ((901 - (557 + 338)) >= (559 + 1330))) then
								if (((1425 - 919) <= (6625 - 4733)) and v100.CleanseToxins:IsReady()) then
									if (v25(v104.CleanseToxinsMouseover) or ((5334 - 3326) > (4779 - 2561))) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if (((1180 - (499 + 302)) <= (5013 - (39 + 827))) and not v15:AffectingCombat() and v31 and v99.TargetIsValid()) then
					local v206 = 0 - 0;
					while true do
						if ((v206 == (0 - 0)) or ((17928 - 13414) <= (1548 - 539))) then
							v30 = v120();
							if (v30 or ((300 + 3196) == (3488 - 2296))) then
								return v30;
							end
							break;
						end
					end
				end
				v162 = 2 + 7;
			end
			if (((10 - 3) == v162) or ((312 - (103 + 1)) == (3513 - (475 + 79)))) then
				if (((9245 - 4968) >= (4201 - 2888)) and v15:AffectingCombat()) then
					if (((335 + 2252) < (2794 + 380)) and v100.Intercession:IsCastable() and (v15:HolyPower() >= (1506 - (1395 + 108))) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
						if (v25(v104.IntercessionMouseover) or ((11989 - 7869) <= (3402 - (7 + 1197)))) then
							return "Intercession mouseover";
						end
					end
				end
				if (v34 or ((696 + 900) == (300 + 558))) then
					v30 = v99.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 359 - (27 + 292), 72 - 47, v100.WordofGlory, 2 - 0);
					if (((13504 - 10284) == (6350 - 3130)) and v30) then
						return v30;
					end
					if ((v100.BlessingofFreedom:IsReady() and v99.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((2669 - 1267) > (3759 - (43 + 96)))) then
						if (((10499 - 7925) == (5819 - 3245)) and v25(v104.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
				end
				if (((1492 + 306) < (779 + 1978)) and v81) then
					local v207 = 0 - 0;
					while true do
						if (((0 + 0) == v207) or ((705 - 328) > (820 + 1784))) then
							if (((42 + 526) < (2662 - (1414 + 337))) and v77) then
								v30 = v99.HandleAfflicted(v100.CleanseToxins, v104.CleanseToxinsMouseover, 1980 - (1642 + 298));
								if (((8563 - 5278) < (12163 - 7935)) and v30) then
									return v30;
								end
							end
							if (((11620 - 7704) > (1096 + 2232)) and v78 and (v110 > (2 + 0))) then
								local v212 = 972 - (357 + 615);
								while true do
									if (((1755 + 745) < (9419 - 5580)) and ((0 + 0) == v212)) then
										v30 = v99.HandleAfflicted(v100.WordofGlory, v104.WordofGloryMouseover, 85 - 45, true);
										if (((406 + 101) == (35 + 472)) and v30) then
											return v30;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v162 = 6 + 2;
			end
			if (((1541 - (384 + 917)) <= (3862 - (128 + 569))) and (v162 == (1546 - (1407 + 136)))) then
				if (((2721 - (687 + 1200)) >= (2515 - (556 + 1154))) and v32) then
					v106 = #v105;
				else
					local v208 = 0 - 0;
					while true do
						if ((v208 == (95 - (9 + 86))) or ((4233 - (275 + 146)) < (377 + 1939))) then
							v105 = {};
							v106 = 65 - (29 + 35);
							break;
						end
					end
				end
				if ((not v15:AffectingCombat() and v15:IsMounted()) or ((11753 - 9101) <= (4578 - 3045))) then
					if ((v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v35) or ((15883 - 12285) < (951 + 509))) then
						if (v25(v100.CrusaderAura) or ((5128 - (53 + 959)) < (1600 - (312 + 96)))) then
							return "crusader_aura";
						end
					end
				end
				v109 = v113();
				v162 = 6 - 2;
			end
			if ((v162 == (286 - (147 + 138))) or ((4276 - (813 + 86)) <= (817 + 86))) then
				v31 = EpicSettings.Toggles['ooc'];
				v32 = EpicSettings.Toggles['aoe'];
				v33 = EpicSettings.Toggles['cds'];
				v162 = 3 - 1;
			end
		end
	end
	local function v128()
		v100.MarkofFyralathDebuff:RegisterAuraTracking();
		v21.Print("Retribution Paladin by Epic. Supported by xKaneto.");
		v103();
	end
	v21.SetAPL(562 - (18 + 474), v127, v128);
end;
return v0["Epix_Paladin_Retribution.lua"]();

