local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((5852 - 2460) >= (6132 - (157 + 1234)))) then
			v6 = v0[v4];
			if (((5618 - 2293) >= (3709 - (991 + 564))) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if ((v5 == (1560 - (1381 + 178))) or ((1215 + 80) >= (2607 + 626))) then
			return v6(...);
		end
	end
end
v0["Epix_Paladin_Protection.lua"] = function(...)
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
	local v28 = string.format;
	local v29;
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
	local v99;
	local v100 = v19.Paladin.Protection;
	local v101 = v20.Paladin.Protection;
	local v102 = v24.Paladin.Protection;
	local v103 = {};
	local v104;
	local v105;
	local v106, v107;
	local v108, v109;
	local v110 = v21.Commons.Everyone;
	local v111 = 4740 + 6371;
	local v112 = 38304 - 27193;
	local v113 = 0 + 0;
	v10:RegisterForEvent(function()
		v111 = 11581 - (381 + 89);
		v112 = 9854 + 1257;
	end, "PLAYER_REGEN_ENABLED");
	local function v114()
		if (((2961 + 1416) > (2812 - 1170)) and v100.CleanseToxins:IsAvailable()) then
			v110.DispellableDebuffs = v13.MergeTable(v110.DispellableDiseaseDebuffs, v110.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v115(v131)
		return v131:DebuffRemains(v100.JudgmentDebuff);
	end
	local function v116()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v117 = 1156 - (1074 + 82);
	local function v118()
		if (((10350 - 5627) > (3140 - (214 + 1570))) and v100.CleanseToxins:IsReady() and (v110.UnitHasDispellableDebuffByPlayer(v14) or v110.DispellableFriendlyUnit(1480 - (990 + 465)))) then
			local v162 = 0 + 0;
			while true do
				if ((v162 == (0 + 0)) or ((4023 + 113) <= (13510 - 10077))) then
					if (((5971 - (1668 + 58)) <= (5257 - (512 + 114))) and (v117 == (0 - 0))) then
						v117 = GetTime();
					end
					if (((8839 - 4563) >= (13619 - 9705)) and v110.Wait(233 + 267, v117)) then
						local v219 = 0 + 0;
						while true do
							if (((173 + 25) <= (14723 - 10358)) and (v219 == (1994 - (109 + 1885)))) then
								if (((6251 - (1269 + 200)) > (8962 - 4286)) and v25(v102.CleanseToxinsFocus)) then
									return "cleanse_toxins dispel";
								end
								v117 = 815 - (98 + 717);
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v119()
		if (((5690 - (802 + 24)) > (3788 - 1591)) and v98 and (v15:HealthPercentage() <= v99)) then
			if (v100.FlashofLight:IsReady() or ((4672 - 972) == (371 + 2136))) then
				if (((3438 + 1036) >= (46 + 228)) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v120()
		local v132 = 0 + 0;
		while true do
			if ((v132 == (2 - 1)) or ((6315 - 4421) <= (503 + 903))) then
				v29 = v110.HandleBottomTrinket(v103, v32, 17 + 23, nil);
				if (((1297 + 275) >= (1114 + 417)) and v29) then
					return v29;
				end
				break;
			end
			if ((v132 == (0 + 0)) or ((6120 - (797 + 636)) < (22053 - 17511))) then
				v29 = v110.HandleTopTrinket(v103, v32, 1659 - (1427 + 192), nil);
				if (((1141 + 2150) > (3870 - 2203)) and v29) then
					return v29;
				end
				v132 = 1 + 0;
			end
		end
	end
	local function v121()
		local v133 = 0 + 0;
		while true do
			if (((328 - (192 + 134)) == v133) or ((2149 - (316 + 960)) == (1132 + 902))) then
				if ((v100.WordofGlory:IsReady() and (v15:HealthPercentage() <= v72) and v61 and not v15:HealingAbsorbed()) or ((2174 + 642) < (11 + 0))) then
					if (((14141 - 10442) < (5257 - (83 + 468))) and ((v15:BuffRemains(v100.ShieldoftheRighteousBuff) >= (1811 - (1202 + 604))) or v15:BuffUp(v100.DivinePurposeBuff) or v15:BuffUp(v100.ShiningLightFreeBuff))) then
						if (((12352 - 9706) >= (1457 - 581)) and v25(v102.WordofGloryPlayer)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if (((1699 - 1085) <= (3509 - (45 + 280))) and v100.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (2 + 0)) and v15:BuffRefreshable(v100.ShieldoftheRighteousBuff) and v62 and (v104 or (v15:HealthPercentage() <= v73))) then
					if (((2732 + 394) == (1142 + 1984)) and v25(v100.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v133 = 2 + 1;
			end
			if ((v133 == (1 + 2)) or ((4049 - 1862) >= (6865 - (340 + 1571)))) then
				if ((v101.Healthstone:IsReady() and v94 and (v15:HealthPercentage() <= v96)) or ((1530 + 2347) == (5347 - (1733 + 39)))) then
					if (((1942 - 1235) > (1666 - (125 + 909))) and v25(v102.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v93 and (v15:HealthPercentage() <= v95)) or ((2494 - (1096 + 852)) >= (1204 + 1480))) then
					if (((2091 - 626) <= (4172 + 129)) and (v97 == "Refreshing Healing Potion")) then
						if (((2216 - (409 + 103)) > (1661 - (46 + 190))) and v101.RefreshingHealingPotion:IsReady()) then
							if (v25(v102.RefreshingHealingPotion) or ((782 - (51 + 44)) == (1195 + 3039))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v97 == "Dreamwalker's Healing Potion") or ((4647 - (1114 + 203)) < (2155 - (228 + 498)))) then
						if (((249 + 898) >= (186 + 149)) and v101.DreamwalkersHealingPotion:IsReady()) then
							if (((4098 - (174 + 489)) > (5463 - 3366)) and v25(v102.RefreshingHealingPotion)) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if ((v133 == (1905 - (830 + 1075))) or ((4294 - (303 + 221)) >= (5310 - (231 + 1038)))) then
				if (((v15:HealthPercentage() <= v69) and v58 and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) or ((3160 + 631) <= (2773 - (171 + 991)))) then
					if (v25(v100.DivineShield) or ((18866 - 14288) <= (5391 - 3383))) then
						return "divine_shield defensive";
					end
				end
				if (((2807 - 1682) <= (1662 + 414)) and (v15:HealthPercentage() <= v71) and v60 and v100.LayonHands:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
					if (v25(v102.LayonHandsPlayer) or ((2604 - 1861) >= (12690 - 8291))) then
						return "lay_on_hands defensive 2";
					end
				end
				v133 = 1 - 0;
			end
			if (((3570 - 2415) < (2921 - (111 + 1137))) and (v133 == (159 - (91 + 67)))) then
				if ((v100.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v70) and v59 and v15:BuffDown(v100.ArdentDefenderBuff)) or ((6916 - 4592) <= (145 + 433))) then
					if (((4290 - (423 + 100)) == (27 + 3740)) and v25(v100.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if (((11321 - 7232) == (2132 + 1957)) and v100.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v100.GuardianofAncientKingsBuff)) then
					if (((5229 - (326 + 445)) >= (7305 - 5631)) and v25(v100.ArdentDefender)) then
						return "ardent_defender defensive 6";
					end
				end
				v133 = 4 - 2;
			end
		end
	end
	local function v122()
		local v134 = 0 - 0;
		while true do
			if (((1683 - (530 + 181)) <= (2299 - (614 + 267))) and (v134 == (33 - (19 + 13)))) then
				if (v14 or ((8036 - 3098) < (11096 - 6334))) then
					if ((v100.WordofGlory:IsReady() and v64 and (v15:BuffUp(v100.ShiningLightFreeBuff) or (v113 >= (8 - 5))) and (v14:HealthPercentage() <= v75)) or ((651 + 1853) > (7498 - 3234))) then
						if (((4464 - 2311) == (3965 - (1293 + 519))) and v25(v102.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if ((v100.LayonHands:IsCastable() and v63 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v74) and v15:AffectingCombat()) or ((1033 - 526) >= (6764 - 4173))) then
						if (((8568 - 4087) == (19322 - 14841)) and v25(v102.LayonHandsFocus)) then
							return "lay_on_hands defensive focus";
						end
					end
					if ((v100.BlessingofSacrifice:IsCastable() and v67 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v78)) or ((5484 - 3156) < (368 + 325))) then
						if (((883 + 3445) == (10055 - 5727)) and v25(v102.BlessingofSacrificeFocus)) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((367 + 1221) >= (443 + 889)) and v100.BlessingofProtection:IsCastable() and v66 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v77)) then
						if (v25(v102.BlessingofProtectionFocus) or ((2609 + 1565) > (5344 - (709 + 387)))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
			if ((v134 == (1858 - (673 + 1185))) or ((13299 - 8713) <= (262 - 180))) then
				if (((6355 - 2492) == (2764 + 1099)) and v16:Exists()) then
					if ((v100.WordofGlory:IsReady() and v65 and (v16:HealthPercentage() <= v76)) or ((211 + 71) <= (56 - 14))) then
						if (((1132 + 3477) >= (1527 - 761)) and v25(v102.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v14 or not v14:Exists() or not v14:IsInRange(58 - 28) or ((3032 - (446 + 1434)) == (3771 - (1040 + 243)))) then
					return;
				end
				v134 = 2 - 1;
			end
		end
	end
	local function v123()
		local v135 = 1847 - (559 + 1288);
		while true do
			if (((5353 - (609 + 1322)) > (3804 - (13 + 441))) and (v135 == (7 - 5))) then
				if (((2297 - 1420) > (1872 - 1496)) and v100.Judgment:IsReady() and v42) then
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((117 + 3001) <= (6722 - 4871))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if ((v135 == (1 + 0)) or ((73 + 92) >= (10362 - 6870))) then
				if (((2161 + 1788) < (8930 - 4074)) and v100.Consecration:IsCastable() and v38) then
					if (v25(v100.Consecration, not v17:IsInRange(6 + 2)) or ((2379 + 1897) < (2168 + 848))) then
						return "consecration";
					end
				end
				if (((3938 + 752) > (4036 + 89)) and v100.AvengersShield:IsCastable() and v36) then
					if (v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield)) or ((483 - (153 + 280)) >= (2587 - 1691))) then
						return "avengers_shield precombat 10";
					end
				end
				v135 = 2 + 0;
			end
			if ((v135 == (0 + 0)) or ((897 + 817) >= (2685 + 273))) then
				if (((v88 < v112) and v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92)) or ((1081 + 410) < (980 - 336))) then
					if (((436 + 268) < (1654 - (89 + 578))) and v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((2657 + 1061) > (3961 - 2055)) and (v88 < v112) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (1054 - (572 + 477)))) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(2 + 6)) or ((575 + 383) > (434 + 3201))) then
						return "arcane_torrent precombat 6";
					end
				end
				v135 = 87 - (84 + 2);
			end
		end
	end
	local function v124()
		local v136 = 0 - 0;
		local v137;
		while true do
			if (((2523 + 978) <= (5334 - (497 + 345))) and (v136 == (0 + 0))) then
				if ((v100.AvengersShield:IsCastable() and v36 and (v10.CombatTime() < (1 + 1)) and v15:HasTier(1362 - (605 + 728), 2 + 0)) or ((7651 - 4209) < (117 + 2431))) then
					if (((10629 - 7754) >= (1320 + 144)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92) and (v109 >= (5 - 3))) or ((3622 + 1175) >= (5382 - (457 + 32)))) then
					if (v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment)) or ((234 + 317) > (3470 - (832 + 570)))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v136 = 1 + 0;
			end
			if (((552 + 1562) > (3340 - 2396)) and (v136 == (2 + 1))) then
				if ((v100.MomentOfGlory:IsCastable() and v47 and ((v53 and v32) or not v53) and ((v15:BuffRemains(v100.SentinelBuff) < (811 - (588 + 208))) or (((v10.CombatTime() > (26 - 16)) or (v100.Sentinel:CooldownRemains() > (1815 - (884 + 916))) or (v100.AvengingWrath:CooldownRemains() > (31 - 16))) and (v100.AvengersShield:CooldownRemains() > (0 + 0)) and (v100.Judgment:CooldownRemains() > (653 - (232 + 421))) and (v100.HammerofWrath:CooldownRemains() > (1889 - (1569 + 320)))))) or ((555 + 1707) >= (589 + 2507))) then
					if (v25(v100.MomentOfGlory, not v17:IsInRange(26 - 18)) or ((2860 - (316 + 289)) >= (9258 - 5721))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if ((v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady() and (v108 >= (1 + 2))) or ((5290 - (666 + 787)) < (1731 - (360 + 65)))) then
					if (((2757 + 193) == (3204 - (79 + 175))) and v25(v100.DivineToll, not v17:IsInRange(47 - 17))) then
						return "divine_toll cooldowns 12";
					end
				end
				v136 = 4 + 0;
			end
			if ((v136 == (5 - 3)) or ((9095 - 4372) < (4197 - (503 + 396)))) then
				v137 = v110.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff));
				if (((1317 - (92 + 89)) >= (298 - 144)) and v137) then
					return v137;
				end
				v136 = 2 + 1;
			end
			if ((v136 == (1 + 0)) or ((1061 - 790) > (650 + 4098))) then
				if (((10807 - 6067) >= (2751 + 401)) and v100.AvengingWrath:IsCastable() and v43 and ((v49 and v32) or not v49)) then
					if (v25(v100.AvengingWrath, not v17:IsInRange(4 + 4)) or ((7851 - 5273) >= (424 + 2966))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if (((62 - 21) <= (2905 - (485 + 759))) and v100.Sentinel:IsCastable() and v48 and ((v54 and v32) or not v54)) then
					if (((1390 - 789) < (4749 - (442 + 747))) and v25(v100.Sentinel, not v17:IsInRange(1143 - (832 + 303)))) then
						return "sentinel cooldowns 8";
					end
				end
				v136 = 948 - (88 + 858);
			end
			if (((72 + 163) < (569 + 118)) and (v136 == (1 + 3))) then
				if (((5338 - (766 + 23)) > (5692 - 4539)) and v100.BastionofLight:IsCastable() and v44 and ((v50 and v32) or not v50) and (v15:BuffUp(v100.AvengingWrathBuff) or (v100.AvengingWrath:CooldownRemains() <= (41 - 11)))) then
					if (v25(v100.BastionofLight, not v17:IsInRange(20 - 12)) or ((15863 - 11189) < (5745 - (1036 + 37)))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v138 = 0 + 0;
		while true do
			if (((7142 - 3474) < (3588 + 973)) and (v138 == (1480 - (641 + 839)))) then
				if ((v100.Consecration:IsCastable() and v38 and (v15:BuffStack(v100.SanctificationBuff) == (918 - (910 + 3)))) or ((1159 - 704) == (5289 - (1466 + 218)))) then
					if (v25(v100.Consecration, not v17:IsInRange(4 + 4)) or ((3811 - (556 + 592)) == (1178 + 2134))) then
						return "consecration standard 2";
					end
				end
				if (((5085 - (329 + 479)) <= (5329 - (174 + 680))) and v100.ShieldoftheRighteous:IsCastable() and v62 and ((v15:HolyPower() > (6 - 4)) or v15:BuffUp(v100.BastionofLightBuff) or v15:BuffUp(v100.DivinePurposeBuff)) and (v15:BuffDown(v100.SanctificationBuff) or (v15:BuffStack(v100.SanctificationBuff) < (10 - 5)))) then
					if (v25(v100.ShieldoftheRighteous) or ((622 + 248) == (1928 - (396 + 343)))) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((138 + 1415) <= (4610 - (29 + 1448))) and v100.Judgment:IsReady() and v42 and (v108 > (1392 - (135 + 1254))) and (v15:BuffStack(v100.BulwarkofRighteousFuryBuff) >= (11 - 8)) and (v15:HolyPower() < (13 - 10))) then
					local v218 = 0 + 0;
					while true do
						if ((v218 == (1527 - (389 + 1138))) or ((2811 - (102 + 472)) >= (3314 + 197))) then
							if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((735 + 589) > (2816 + 204))) then
								return "judgment standard 6";
							end
							if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((4537 - (320 + 1225)) == (3348 - 1467))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				if (((1901 + 1205) > (2990 - (157 + 1307))) and v100.Judgment:IsReady() and v42 and v15:BuffDown(v100.SanctificationEmpowerBuff) and v15:HasTier(1890 - (821 + 1038), 4 - 2)) then
					if (((331 + 2692) < (6874 - 3004)) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 8";
					end
					if (((54 + 89) > (183 - 109)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 8";
					end
				end
				v138 = 1027 - (834 + 192);
			end
			if (((2 + 16) < (543 + 1569)) and (v138 == (1 + 1))) then
				if (((1698 - 601) <= (1932 - (300 + 4))) and v100.AvengersShield:IsCastable() and v36) then
					if (((1237 + 3393) == (12120 - 7490)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				if (((3902 - (112 + 250)) > (1070 + 1613)) and v100.HammerofWrath:IsReady() and v41) then
					if (((12009 - 7215) >= (1877 + 1398)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((768 + 716) == (1110 + 374)) and v100.Judgment:IsReady() and v42) then
					if (((711 + 721) < (2641 + 914)) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 22";
					end
					if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2479 - (1001 + 413)) > (7978 - 4400))) then
						return "judgment standard 22";
					end
				end
				if ((v100.Consecration:IsCastable() and v38 and v15:BuffDown(v100.ConsecrationBuff) and ((v15:BuffStack(v100.SanctificationBuff) < (887 - (244 + 638))) or not v15:HasTier(724 - (627 + 66), 5 - 3))) or ((5397 - (512 + 90)) < (3313 - (1665 + 241)))) then
					if (((2570 - (373 + 344)) < (2171 + 2642)) and v25(v100.Consecration, not v17:IsInRange(3 + 5))) then
						return "consecration standard 24";
					end
				end
				v138 = 7 - 4;
			end
			if ((v138 == (6 - 2)) or ((3920 - (35 + 1064)) < (1769 + 662))) then
				if (((v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and not v100.InmostLight:IsAvailable()) or ((6148 - 3274) < (9 + 2172))) then
					if (v25(v100.EyeofTyr, not v17:IsInRange(1244 - (298 + 938))) or ((3948 - (233 + 1026)) <= (2009 - (636 + 1030)))) then
						return "eye_of_tyr standard 34";
					end
				end
				if ((v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (3 + 2))) or ((1826 + 43) == (597 + 1412))) then
					if (v25(v100.ArcaneTorrent, not v17:IsInRange(1 + 7)) or ((3767 - (55 + 166)) < (450 + 1872))) then
						return "arcane_torrent standard 36";
					end
				end
				if ((v100.Consecration:IsCastable() and v38 and (v15:BuffDown(v100.SanctificationEmpowerBuff))) or ((210 + 1872) == (18228 - 13455))) then
					if (((3541 - (36 + 261)) > (1844 - 789)) and v25(v100.Consecration, not v17:IsInRange(1376 - (34 + 1334)))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if ((v138 == (2 + 1)) or ((2575 + 738) <= (3061 - (1035 + 248)))) then
				if (((v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and v100.InmostLight:IsAvailable() and (v108 >= (24 - (20 + 1)))) or ((741 + 680) >= (2423 - (134 + 185)))) then
					if (((2945 - (549 + 584)) <= (3934 - (314 + 371))) and v25(v100.EyeofTyr, not v17:IsInRange(27 - 19))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((2591 - (478 + 490)) <= (1037 + 920)) and v100.BlessedHammer:IsCastable() and v37) then
					if (((5584 - (786 + 386)) == (14290 - 9878)) and v25(v100.BlessedHammer, not v17:IsInRange(1387 - (1055 + 324)))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((3090 - (1093 + 247)) >= (749 + 93)) and v100.HammeroftheRighteous:IsCastable() and v40) then
					if (((460 + 3912) > (7344 - 5494)) and v25(v100.HammeroftheRighteous, not v17:IsInRange(26 - 18))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				if (((659 - 427) < (2063 - 1242)) and v100.CrusaderStrike:IsCastable() and v39) then
					if (((185 + 333) < (3474 - 2572)) and v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				v138 = 13 - 9;
			end
			if (((2258 + 736) > (2193 - 1335)) and (v138 == (689 - (364 + 324)))) then
				if ((v100.HammerofWrath:IsReady() and v41) or ((10293 - 6538) <= (2195 - 1280))) then
					if (((1308 + 2638) > (15661 - 11918)) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v100.Judgment:IsReady() and v42 and ((v100.Judgment:Charges() >= (2 - 0)) or (v100.Judgment:FullRechargeTime() <= v15:GCD()))) or ((4054 - 2719) >= (4574 - (1249 + 19)))) then
					if (((4373 + 471) > (8769 - 6516)) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 12";
					end
					if (((1538 - (686 + 400)) == (355 + 97)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
						return "judgment standard 12";
					end
				end
				if ((v100.AvengersShield:IsCastable() and v36 and ((v109 > (231 - (73 + 156))) or v15:BuffUp(v100.MomentOfGloryBuff))) or ((22 + 4535) < (2898 - (721 + 90)))) then
					if (((44 + 3830) == (12578 - 8704)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if ((v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady()) or ((2408 - (224 + 246)) > (7994 - 3059))) then
					if (v25(v100.DivineToll, not v17:IsInRange(55 - 25)) or ((772 + 3483) < (82 + 3341))) then
						return "divine_toll standard 16";
					end
				end
				v138 = 2 + 0;
			end
		end
	end
	local function v126()
		local v139 = 0 - 0;
		while true do
			if (((4838 - 3384) <= (3004 - (203 + 310))) and (v139 == (1993 - (1238 + 755)))) then
				v34 = EpicSettings.Settings['swapAuras'];
				v35 = EpicSettings.Settings['useWeapon'];
				v36 = EpicSettings.Settings['useAvengersShield'];
				v37 = EpicSettings.Settings['useBlessedHammer'];
				v139 = 1 + 0;
			end
			if ((v139 == (1537 - (709 + 825))) or ((7660 - 3503) <= (4082 - 1279))) then
				v46 = EpicSettings.Settings['useEyeofTyr'];
				v47 = EpicSettings.Settings['useMomentOfGlory'];
				v48 = EpicSettings.Settings['useSentinel'];
				v49 = EpicSettings.Settings['avengingWrathWithCD'];
				v139 = 868 - (196 + 668);
			end
			if (((19160 - 14307) >= (6176 - 3194)) and (v139 == (835 - (171 + 662)))) then
				v42 = EpicSettings.Settings['useJudgment'];
				v43 = EpicSettings.Settings['useAvengingWrath'];
				v44 = EpicSettings.Settings['useBastionofLight'];
				v45 = EpicSettings.Settings['useDivineToll'];
				v139 = 96 - (4 + 89);
			end
			if (((14489 - 10355) > (1223 + 2134)) and (v139 == (17 - 13))) then
				v50 = EpicSettings.Settings['bastionofLightWithCD'];
				v51 = EpicSettings.Settings['divineTollWithCD'];
				v52 = EpicSettings.Settings['eyeofTyrWithCD'];
				v53 = EpicSettings.Settings['momentOfGloryWithCD'];
				v139 = 2 + 3;
			end
			if ((v139 == (1491 - (35 + 1451))) or ((4870 - (28 + 1425)) < (4527 - (941 + 1052)))) then
				v54 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v139 == (1 + 0)) or ((4236 - (822 + 692)) <= (233 - 69))) then
				v38 = EpicSettings.Settings['useConsecration'];
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v40 = EpicSettings.Settings['useHammeroftheRighteous'];
				v41 = EpicSettings.Settings['useHammerofWrath'];
				v139 = 1 + 1;
			end
		end
	end
	local function v127()
		local v140 = 297 - (45 + 252);
		while true do
			if ((v140 == (0 + 0)) or ((829 + 1579) < (5132 - 3023))) then
				v55 = EpicSettings.Settings['useRebuke'];
				v56 = EpicSettings.Settings['useHammerofJustice'];
				v57 = EpicSettings.Settings['useArdentDefender'];
				v58 = EpicSettings.Settings['useDivineShield'];
				v140 = 434 - (114 + 319);
			end
			if ((v140 == (5 - 1)) or ((41 - 8) == (928 + 527))) then
				v71 = EpicSettings.Settings['layonHandsHP'];
				v72 = EpicSettings.Settings['wordofGloryHP'];
				v73 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v74 = EpicSettings.Settings['layOnHandsFocusHP'];
				v140 = 7 - 2;
			end
			if ((v140 == (12 - 6)) or ((2406 - (556 + 1407)) >= (5221 - (741 + 465)))) then
				v79 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v80 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if (((3847 - (170 + 295)) > (88 + 78)) and ((2 + 0) == v140)) then
				v63 = EpicSettings.Settings['useLayOnHandsFocus'];
				v64 = EpicSettings.Settings['useWordofGloryFocus'];
				v65 = EpicSettings.Settings['useWordofGloryMouseover'];
				v66 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v140 = 7 - 4;
			end
			if ((v140 == (1 + 0)) or ((180 + 100) == (1733 + 1326))) then
				v59 = EpicSettings.Settings['useGuardianofAncientKings'];
				v60 = EpicSettings.Settings['useLayOnHands'];
				v61 = EpicSettings.Settings['useWordofGloryPlayer'];
				v62 = EpicSettings.Settings['useShieldoftheRighteous'];
				v140 = 1232 - (957 + 273);
			end
			if (((504 + 1377) > (518 + 775)) and (v140 == (19 - 14))) then
				v75 = EpicSettings.Settings['wordofGloryFocusHP'];
				v76 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v77 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v78 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v140 = 15 - 9;
			end
			if (((7199 - 4842) == (11671 - 9314)) and (v140 == (1783 - (389 + 1391)))) then
				v67 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v68 = EpicSettings.Settings['ardentDefenderHP'];
				v69 = EpicSettings.Settings['divineShieldHP'];
				v70 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v140 = 3 + 1;
			end
		end
	end
	local function v128()
		v88 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v85 = EpicSettings.Settings['InterruptWithStun'];
		v86 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v87 = EpicSettings.Settings['InterruptThreshold'];
		v82 = EpicSettings.Settings['DispelDebuffs'];
		v81 = EpicSettings.Settings['DispelBuffs'];
		v89 = EpicSettings.Settings['useTrinkets'];
		v91 = EpicSettings.Settings['useRacials'];
		v90 = EpicSettings.Settings['trinketsWithCD'];
		v92 = EpicSettings.Settings['racialsWithCD'];
		v94 = EpicSettings.Settings['useHealthstone'];
		v93 = EpicSettings.Settings['useHealingPotion'];
		v96 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v95 = EpicSettings.Settings['healingPotionHP'] or (951 - (783 + 168));
		v97 = EpicSettings.Settings['HealingPotionName'] or "";
		v83 = EpicSettings.Settings['handleAfflicted'];
		v84 = EpicSettings.Settings['HandleIncorporeal'];
		v98 = EpicSettings.Settings['HealOOC'];
		v99 = EpicSettings.Settings['HealOOCHP'] or (0 - 0);
	end
	local function v129()
		v127();
		v126();
		v128();
		v30 = EpicSettings.Toggles['ooc'];
		v31 = EpicSettings.Toggles['aoe'];
		v32 = EpicSettings.Toggles['cds'];
		v33 = EpicSettings.Toggles['dispel'];
		if (((121 + 2) == (434 - (309 + 2))) and v15:IsDeadOrGhost()) then
			return v29;
		end
		v106 = v15:GetEnemiesInMeleeRange(24 - 16);
		v107 = v15:GetEnemiesInRange(1242 - (1090 + 122));
		if (v31 or ((343 + 713) >= (11391 - 7999))) then
			local v163 = 0 + 0;
			while true do
				if ((v163 == (1118 - (628 + 490))) or ((194 + 887) < (2661 - 1586))) then
					v108 = #v106;
					v109 = #v107;
					break;
				end
			end
		else
			v108 = 4 - 3;
			v109 = 775 - (431 + 343);
		end
		v104 = v15:ActiveMitigationNeeded();
		v105 = v15:IsTankingAoE(16 - 8) or v15:IsTanking(v17);
		if ((not v15:AffectingCombat() and v15:IsMounted()) or ((3034 - 1985) >= (3502 + 930))) then
			if ((v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v34) or ((610 + 4158) <= (2541 - (556 + 1139)))) then
				if (v25(v100.CrusaderAura) or ((3373 - (6 + 9)) <= (260 + 1160))) then
					return "crusader_aura";
				end
			end
		end
		if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((1916 + 1823) <= (3174 - (28 + 141)))) then
			if (v15:AffectingCombat() or ((643 + 1016) >= (2633 - 499))) then
				if (v100.Intercession:IsCastable() or ((2309 + 951) < (3672 - (486 + 831)))) then
					if (v25(v100.Intercession, not v17:IsInRange(78 - 48), true) or ((2354 - 1685) == (798 + 3425))) then
						return "intercession target";
					end
				end
			elseif (v100.Redemption:IsCastable() or ((5349 - 3657) < (1851 - (668 + 595)))) then
				if (v25(v100.Redemption, not v17:IsInRange(27 + 3), true) or ((968 + 3829) < (9956 - 6305))) then
					return "redemption target";
				end
			end
		end
		if ((v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((4467 - (23 + 267)) > (6794 - (1129 + 815)))) then
			if (v25(v102.RedemptionMouseover) or ((787 - (371 + 16)) > (2861 - (1326 + 424)))) then
				return "redemption mouseover";
			end
		end
		if (((5778 - 2727) > (3672 - 2667)) and v15:AffectingCombat()) then
			if (((3811 - (88 + 30)) <= (5153 - (720 + 51))) and v100.Intercession:IsCastable() and (v15:HolyPower() >= (6 - 3)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
				if (v25(v102.IntercessionMouseover) or ((5058 - (421 + 1355)) > (6764 - 2664))) then
					return "Intercession";
				end
			end
		end
		if (v15:AffectingCombat() or (v82 and v100.CleanseToxins:IsAvailable()) or ((1759 + 1821) < (3927 - (286 + 797)))) then
			local v164 = 0 - 0;
			local v165;
			while true do
				if (((146 - 57) < (4929 - (397 + 42))) and (v164 == (1 + 0))) then
					if (v29 or ((5783 - (24 + 776)) < (2785 - 977))) then
						return v29;
					end
					break;
				end
				if (((4614 - (222 + 563)) > (8303 - 4534)) and (v164 == (0 + 0))) then
					v165 = v82 and v100.CleanseToxins:IsReady() and v33;
					v29 = v110.FocusUnit(v165, nil, 210 - (23 + 167), nil, 1823 - (690 + 1108), v100.FlashofLight);
					v164 = 1 + 0;
				end
			end
		end
		if (((1225 + 260) <= (3752 - (40 + 808))) and v33 and v82) then
			local v166 = 0 + 0;
			while true do
				if (((16324 - 12055) == (4081 + 188)) and (v166 == (0 + 0))) then
					v29 = v110.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 22 + 18, 596 - (47 + 524), v100.FlashofLight);
					if (((252 + 135) <= (7604 - 4822)) and v29) then
						return v29;
					end
					v166 = 1 - 0;
				end
				if ((v166 == (2 - 1)) or ((3625 - (1165 + 561)) <= (28 + 889))) then
					if ((v100.BlessingofFreedom:IsReady() and v110.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) or ((13354 - 9042) <= (335 + 541))) then
						if (((2711 - (341 + 138)) <= (701 + 1895)) and v25(v102.BlessingofFreedomFocus)) then
							return "blessing_of_freedom combat";
						end
					end
					break;
				end
			end
		end
		if (((4323 - 2228) < (4012 - (89 + 237))) and (v110.TargetIsValid() or v15:AffectingCombat())) then
			v111 = v10.BossFightRemains(nil, true);
			v112 = v111;
			if ((v112 == (35744 - 24633)) or ((3357 - 1762) >= (5355 - (581 + 300)))) then
				v112 = v10.FightRemains(v106, false);
			end
			v113 = v15:HolyPower();
		end
		if (not v15:AffectingCombat() or ((5839 - (855 + 365)) < (6845 - 3963))) then
			if ((v100.DevotionAura:IsCastable() and (v116()) and v34) or ((96 + 198) >= (6066 - (1030 + 205)))) then
				if (((1905 + 124) <= (2869 + 215)) and v25(v100.DevotionAura)) then
					return "devotion_aura";
				end
			end
		end
		if (v83 or ((2323 - (156 + 130)) == (5498 - 3078))) then
			local v167 = 0 - 0;
			while true do
				if (((9130 - 4672) > (1029 + 2875)) and (v167 == (0 + 0))) then
					if (((505 - (10 + 59)) >= (35 + 88)) and v79) then
						local v220 = 0 - 0;
						while true do
							if (((1663 - (671 + 492)) < (1446 + 370)) and (v220 == (1215 - (369 + 846)))) then
								v29 = v110.HandleAfflicted(v100.CleanseToxins, v102.CleanseToxinsMouseover, 11 + 29);
								if (((3051 + 523) == (5519 - (1036 + 909))) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					if (((176 + 45) < (654 - 264)) and v15:BuffUp(v100.ShiningLightFreeBuff) and v80) then
						local v221 = 203 - (11 + 192);
						while true do
							if ((v221 == (0 + 0)) or ((2388 - (135 + 40)) <= (3442 - 2021))) then
								v29 = v110.HandleAfflicted(v100.WordofGlory, v102.WordofGloryMouseover, 25 + 15, true);
								if (((6736 - 3678) < (7285 - 2425)) and v29) then
									return v29;
								end
								break;
							end
						end
					end
					break;
				end
			end
		end
		if (v84 or ((1472 - (50 + 126)) >= (12379 - 7933))) then
			v29 = v110.HandleIncorporeal(v100.Repentance, v102.RepentanceMouseOver, 7 + 23, true);
			if (v29 or ((2806 - (1233 + 180)) > (5458 - (522 + 447)))) then
				return v29;
			end
			v29 = v110.HandleIncorporeal(v100.TurnEvil, v102.TurnEvilMouseOver, 1451 - (107 + 1314), true);
			if (v29 or ((2053 + 2371) < (82 - 55))) then
				return v29;
			end
		end
		v29 = v119();
		if (v29 or ((849 + 1148) > (7575 - 3760))) then
			return v29;
		end
		if (((13709 - 10244) > (3823 - (716 + 1194))) and v82 and v33) then
			local v168 = 0 + 0;
			while true do
				if (((79 + 654) < (2322 - (74 + 429))) and (v168 == (0 - 0))) then
					if (v14 or ((2179 + 2216) == (10884 - 6129))) then
						local v222 = 0 + 0;
						while true do
							if ((v222 == (0 - 0)) or ((9378 - 5585) < (2802 - (279 + 154)))) then
								v29 = v118();
								if (v29 or ((4862 - (454 + 324)) == (209 + 56))) then
									return v29;
								end
								break;
							end
						end
					end
					if (((4375 - (12 + 5)) == (2350 + 2008)) and v16 and v16:Exists() and not v15:CanAttack(v16) and (v110.UnitHasCurseDebuff(v16) or v110.UnitHasPoisonDebuff(v16))) then
						if (v100.CleanseToxins:IsReady() or ((7995 - 4857) < (367 + 626))) then
							if (((4423 - (277 + 816)) > (9926 - 7603)) and v25(v102.CleanseToxinsMouseover)) then
								return "cleanse_toxins dispel mouseover";
							end
						end
					end
					break;
				end
			end
		end
		v29 = v122();
		if (v29 or ((4809 - (1058 + 125)) == (748 + 3241))) then
			return v29;
		end
		if (v105 or ((1891 - (815 + 160)) == (11460 - 8789))) then
			local v169 = 0 - 0;
			while true do
				if (((65 + 207) == (795 - 523)) and (v169 == (1898 - (41 + 1857)))) then
					v29 = v121();
					if (((6142 - (1222 + 671)) <= (12506 - 7667)) and v29) then
						return v29;
					end
					break;
				end
			end
		end
		if (((3991 - 1214) < (4382 - (229 + 953))) and v110.TargetIsValid() and not v15:AffectingCombat() and v30) then
			v29 = v123();
			if (((1869 - (1111 + 663)) < (3536 - (874 + 705))) and v29) then
				return v29;
			end
		end
		if (((116 + 710) < (1172 + 545)) and v110.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
			local v170 = 0 - 0;
			while true do
				if (((41 + 1385) >= (1784 - (642 + 37))) and (v170 == (1 + 1))) then
					if (((441 + 2313) <= (8483 - 5104)) and v25(v100.Pool)) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if ((v170 == (455 - (233 + 221))) or ((9080 - 5153) == (1244 + 169))) then
					v29 = v125();
					if (v29 or ((2695 - (718 + 823)) <= (496 + 292))) then
						return v29;
					end
					v170 = 807 - (266 + 539);
				end
				if ((v170 == (0 - 0)) or ((2868 - (636 + 589)) > (8020 - 4641))) then
					if ((v88 < v112) or ((5780 - 2977) > (3605 + 944))) then
						v29 = v124();
						if (v29 or ((80 + 140) >= (4037 - (657 + 358)))) then
							return v29;
						end
						if (((7471 - 4649) == (6428 - 3606)) and v32 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v35) then
							if (v25(v102.UseWeapon) or ((2248 - (1151 + 36)) == (1794 + 63))) then
								return "Fyralath The Dreamrender used";
							end
						end
					end
					if (((726 + 2034) > (4073 - 2709)) and v89 and ((v32 and v90) or not v90) and v17:IsInRange(1840 - (1552 + 280))) then
						local v223 = 834 - (64 + 770);
						while true do
							if ((v223 == (0 + 0)) or ((11127 - 6225) <= (639 + 2956))) then
								v29 = v120();
								if (v29 or ((5095 - (157 + 1086)) == (586 - 293))) then
									return v29;
								end
								break;
							end
						end
					end
					v170 = 4 - 3;
				end
			end
		end
	end
	local function v130()
		local v159 = 0 - 0;
		while true do
			if ((v159 == (0 - 0)) or ((2378 - (599 + 220)) == (9136 - 4548))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v114();
				break;
			end
		end
	end
	v21.SetAPL(1997 - (1813 + 118), v129, v130);
end;
return v0["Epix_Paladin_Protection.lua"]();

