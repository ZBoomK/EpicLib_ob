local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (763 - (418 + 344))) or ((1993 - (192 + 134)) >= (4567 - (316 + 960)))) then
			return v6(...);
		end
		if ((v5 == (0 + 0)) or ((674 + 199) == (1881 + 153))) then
			v6 = v0[v4];
			if (not v6 or ((10765 - 7949) < (562 - (83 + 468)))) then
				return v1(v4, ...);
			end
			v5 = 1807 - (1202 + 604);
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
	local v111 = 51868 - 40757;
	local v112 = 18492 - 7381;
	local v113 = 0 - 0;
	v10:RegisterForEvent(function()
		local v131 = 325 - (45 + 280);
		while true do
			if (((3571 + 128) < (4112 + 594)) and ((0 + 0) == v131)) then
				v111 = 6149 + 4962;
				v112 = 1955 + 9156;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114()
		if (((4899 - 2253) >= (2787 - (340 + 1571))) and v100.CleanseToxins:IsAvailable()) then
			v110.DispellableDebuffs = v13.MergeTable(v110.DispellableDiseaseDebuffs, v110.DispellablePoisonDebuffs);
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v115(v132)
		return v132:DebuffRemains(v100.JudgmentDebuff);
	end
	local function v116()
		return v15:BuffDown(v100.RetributionAura) and v15:BuffDown(v100.DevotionAura) and v15:BuffDown(v100.ConcentrationAura) and v15:BuffDown(v100.CrusaderAura);
	end
	local v117 = 0 + 0;
	local function v118()
		if (((2386 - (1733 + 39)) <= (8749 - 5565)) and v100.CleanseToxins:IsReady() and v110.DispellableFriendlyUnit(1059 - (125 + 909))) then
			local v146 = 1948 - (1096 + 852);
			while true do
				if (((1403 + 1723) == (4463 - 1337)) and ((0 + 0) == v146)) then
					if ((v117 == (512 - (409 + 103))) or ((2423 - (46 + 190)) >= (5049 - (51 + 44)))) then
						v117 = GetTime();
					end
					if (v110.Wait(142 + 358, v117) or ((5194 - (1114 + 203)) == (4301 - (228 + 498)))) then
						if (((154 + 553) > (350 + 282)) and v25(v102.CleanseToxinsFocus)) then
							return "cleanse_toxins dispel";
						end
						v117 = 663 - (174 + 489);
					end
					break;
				end
			end
		end
	end
	local function v119()
		if ((v98 and (v15:HealthPercentage() <= v99)) or ((1422 - 876) >= (4589 - (830 + 1075)))) then
			if (((1989 - (303 + 221)) <= (5570 - (231 + 1038))) and v100.FlashofLight:IsReady()) then
				if (((1420 + 284) > (2587 - (171 + 991))) and v25(v100.FlashofLight)) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v120()
		local v133 = 0 - 0;
		while true do
			if ((v133 == (0 - 0)) or ((1714 - 1027) == (3389 + 845))) then
				v29 = v110.HandleTopTrinket(v103, v32, 140 - 100, nil);
				if (v29 or ((9606 - 6276) < (2302 - 873))) then
					return v29;
				end
				v133 = 3 - 2;
			end
			if (((2395 - (111 + 1137)) >= (493 - (91 + 67))) and (v133 == (2 - 1))) then
				v29 = v110.HandleBottomTrinket(v103, v32, 10 + 30, nil);
				if (((3958 - (423 + 100)) > (15 + 2082)) and v29) then
					return v29;
				end
				break;
			end
		end
	end
	local function v121()
		local v134 = 0 - 0;
		while true do
			if ((v134 == (2 + 0)) or ((4541 - (326 + 445)) >= (17634 - 13593))) then
				if ((v100.WordofGlory:IsReady() and (v15:HealthPercentage() <= v72) and v61 and not v15:HealingAbsorbed()) or ((8445 - 4654) <= (3760 - 2149))) then
					if ((v15:BuffRemains(v100.ShieldoftheRighteousBuff) >= (716 - (530 + 181))) or v15:BuffUp(v100.DivinePurposeBuff) or v15:BuffUp(v100.ShiningLightFreeBuff) or ((5459 - (614 + 267)) <= (2040 - (19 + 13)))) then
						if (((1830 - 705) <= (4837 - 2761)) and v25(v102.WordofGloryPlayer)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v100.ShieldoftheRighteous:IsCastable() and (v15:HolyPower() > (5 - 3)) and v15:BuffRefreshable(v100.ShieldoftheRighteousBuff) and v62 and (v104 or (v15:HealthPercentage() <= v73))) or ((193 + 550) >= (7735 - 3336))) then
					if (((2395 - 1240) < (3485 - (1293 + 519))) and v25(v100.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v134 = 5 - 2;
			end
			if ((v134 == (0 - 0)) or ((4443 - 2119) <= (2492 - 1914))) then
				if (((8874 - 5107) == (1996 + 1771)) and (v15:HealthPercentage() <= v69) and v58 and v100.DivineShield:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
					if (((835 + 3254) == (9500 - 5411)) and v25(v100.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((1031 + 3427) >= (557 + 1117)) and (v15:HealthPercentage() <= v71) and v60 and v100.LayonHands:IsCastable() and v15:DebuffDown(v100.ForbearanceDebuff)) then
					if (((608 + 364) <= (2514 - (709 + 387))) and v25(v102.LayonHandsPlayer)) then
						return "lay_on_hands defensive 2";
					end
				end
				v134 = 1859 - (673 + 1185);
			end
			if ((v134 == (8 - 5)) or ((15856 - 10918) < (7834 - 3072))) then
				if ((v101.Healthstone:IsReady() and v94 and (v15:HealthPercentage() <= v96)) or ((1792 + 712) > (3187 + 1077))) then
					if (((2906 - 753) == (529 + 1624)) and v25(v102.Healthstone)) then
						return "healthstone defensive";
					end
				end
				if ((v93 and (v15:HealthPercentage() <= v95)) or ((1010 - 503) >= (5085 - 2494))) then
					local v212 = 1880 - (446 + 1434);
					while true do
						if (((5764 - (1040 + 243)) == (13374 - 8893)) and (v212 == (1847 - (559 + 1288)))) then
							if ((v97 == "Refreshing Healing Potion") or ((4259 - (609 + 1322)) < (1147 - (13 + 441)))) then
								if (((16172 - 11844) == (11336 - 7008)) and v101.RefreshingHealingPotion:IsReady()) then
									if (((7908 - 6320) >= (50 + 1282)) and v25(v102.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v97 == "Dreamwalker's Healing Potion") or ((15159 - 10985) > (1509 + 2739))) then
								if (v101.DreamwalkersHealingPotion:IsReady() or ((2010 + 2576) <= (243 - 161))) then
									if (((2114 + 1749) == (7104 - 3241)) and v25(v102.RefreshingHealingPotion)) then
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
			if (((1 + 0) == v134) or ((157 + 125) <= (31 + 11))) then
				if (((3870 + 739) >= (750 + 16)) and v100.GuardianofAncientKings:IsCastable() and (v15:HealthPercentage() <= v70) and v59 and v15:BuffDown(v100.ArdentDefenderBuff)) then
					if (v25(v100.GuardianofAncientKings) or ((1585 - (153 + 280)) == (7184 - 4696))) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if (((3073 + 349) > (1323 + 2027)) and v100.ArdentDefender:IsCastable() and (v15:HealthPercentage() <= v68) and v57 and v15:BuffDown(v100.GuardianofAncientKingsBuff)) then
					if (((459 + 418) > (342 + 34)) and v25(v100.ArdentDefender)) then
						return "ardent_defender defensive 6";
					end
				end
				v134 = 2 + 0;
			end
		end
	end
	local function v122()
		local v135 = 0 - 0;
		while true do
			if ((v135 == (0 + 0)) or ((3785 - (89 + 578)) <= (1323 + 528))) then
				if (v16:Exists() or ((342 - 177) >= (4541 - (572 + 477)))) then
					if (((533 + 3416) < (2915 + 1941)) and v100.WordofGlory:IsReady() and v65 and (v16:HealthPercentage() <= v76)) then
						if (v25(v102.WordofGloryMouseover) or ((511 + 3765) < (3102 - (84 + 2)))) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (((7729 - 3039) > (2972 + 1153)) and (not v14 or not v14:Exists() or not v14:IsInRange(872 - (497 + 345)))) then
					return;
				end
				v135 = 1 + 0;
			end
			if ((v135 == (1 + 0)) or ((1383 - (605 + 728)) >= (640 + 256))) then
				if (v14 or ((3810 - 2096) >= (136 + 2822))) then
					if ((v100.WordofGlory:IsReady() and v64 and (v15:BuffUp(v100.ShiningLightFreeBuff) or (v113 >= (10 - 7))) and (v14:HealthPercentage() <= v75)) or ((1345 + 146) < (1784 - 1140))) then
						if (((532 + 172) < (1476 - (457 + 32))) and v25(v102.WordofGloryFocus)) then
							return "word_of_glory defensive focus";
						end
					end
					if (((1578 + 2140) > (3308 - (832 + 570))) and v100.LayonHands:IsCastable() and v63 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v74)) then
						if (v25(v102.LayonHandsFocus) or ((903 + 55) > (948 + 2687))) then
							return "lay_on_hands defensive focus";
						end
					end
					if (((12389 - 8888) <= (2164 + 2328)) and v100.BlessingofSacrifice:IsCastable() and v67 and not UnitIsUnit(v14:ID(), v15:ID()) and (v14:HealthPercentage() <= v78)) then
						if (v25(v102.BlessingofSacrificeFocus) or ((4238 - (588 + 208)) < (6867 - 4319))) then
							return "blessing_of_sacrifice defensive focus";
						end
					end
					if (((4675 - (884 + 916)) >= (3064 - 1600)) and v100.BlessingofProtection:IsCastable() and v66 and v14:DebuffDown(v100.ForbearanceDebuff) and (v14:HealthPercentage() <= v77)) then
						if (v25(v102.BlessingofProtectionFocus) or ((2782 + 2015) >= (5546 - (232 + 421)))) then
							return "blessing_of_protection defensive focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v123()
		if (((v88 < v112) and v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92)) or ((2440 - (1569 + 320)) > (508 + 1560))) then
			if (((402 + 1712) > (3180 - 2236)) and v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment))) then
				return "lights_judgment precombat 4";
			end
		end
		if (((v88 < v112) and v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (610 - (316 + 289)))) or ((5921 - 3659) >= (143 + 2953))) then
			if (v25(v100.ArcaneTorrent, not v17:IsInRange(1461 - (666 + 787))) or ((2680 - (360 + 65)) >= (3306 + 231))) then
				return "arcane_torrent precombat 6";
			end
		end
		if ((v100.Consecration:IsCastable() and v38) or ((4091 - (79 + 175)) < (2059 - 753))) then
			if (((2303 + 647) == (9042 - 6092)) and v25(v100.Consecration, not v17:IsInRange(15 - 7))) then
				return "consecration";
			end
		end
		if ((v100.AvengersShield:IsCastable() and v36) or ((5622 - (503 + 396)) < (3479 - (92 + 89)))) then
			if (((2203 - 1067) >= (79 + 75)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
				return "avengers_shield precombat 10";
			end
		end
		if ((v100.Judgment:IsReady() and v42) or ((161 + 110) > (18593 - 13845))) then
			if (((649 + 4091) >= (7186 - 4034)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
				return "judgment precombat 12";
			end
		end
	end
	local function v124()
		local v136 = 0 + 0;
		local v137;
		while true do
			if ((v136 == (1 + 1)) or ((7851 - 5273) >= (424 + 2966))) then
				v137 = v110.HandleDPSPotion(v15:BuffUp(v100.AvengingWrathBuff));
				if (((62 - 21) <= (2905 - (485 + 759))) and v137) then
					return v137;
				end
				v136 = 6 - 3;
			end
			if (((1790 - (442 + 747)) < (4695 - (832 + 303))) and ((947 - (88 + 858)) == v136)) then
				if (((72 + 163) < (569 + 118)) and v100.AvengingWrath:IsCastable() and v43 and ((v49 and v32) or not v49)) then
					if (((188 + 4361) > (1942 - (766 + 23))) and v25(v100.AvengingWrath, not v17:IsInRange(39 - 31))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if ((v100.Sentinel:IsCastable() and v48 and ((v54 and v32) or not v54)) or ((6392 - 1718) < (12308 - 7636))) then
					if (((12449 - 8781) < (5634 - (1036 + 37))) and v25(v100.Sentinel, not v17:IsInRange(6 + 2))) then
						return "sentinel cooldowns 8";
					end
				end
				v136 = 3 - 1;
			end
			if ((v136 == (4 + 0)) or ((1935 - (641 + 839)) == (4518 - (910 + 3)))) then
				if ((v100.BastionofLight:IsCastable() and v44 and ((v50 and v32) or not v50) and (v15:BuffUp(v100.AvengingWrathBuff) or (v100.AvengingWrath:CooldownRemains() <= (76 - 46)))) or ((4347 - (1466 + 218)) == (1523 + 1789))) then
					if (((5425 - (556 + 592)) <= (1592 + 2883)) and v25(v100.BastionofLight, not v17:IsInRange(816 - (329 + 479)))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
			if ((v136 == (854 - (174 + 680))) or ((2989 - 2119) == (2463 - 1274))) then
				if (((1109 + 444) <= (3872 - (396 + 343))) and v100.AvengersShield:IsCastable() and v36 and (v10.CombatTime() < (1 + 1)) and v15:HasTier(1506 - (29 + 1448), 1391 - (135 + 1254))) then
					if (v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield)) or ((8427 - 6190) >= (16393 - 12882))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if ((v100.LightsJudgment:IsCastable() and v91 and ((v92 and v32) or not v92) and (v109 >= (2 + 0))) or ((2851 - (389 + 1138)) > (3594 - (102 + 472)))) then
					if (v25(v100.LightsJudgment, not v17:IsSpellInRange(v100.LightsJudgment)) or ((2824 + 168) == (1044 + 837))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v136 = 1 + 0;
			end
			if (((4651 - (320 + 1225)) > (2716 - 1190)) and (v136 == (2 + 1))) then
				if (((4487 - (157 + 1307)) < (5729 - (821 + 1038))) and v100.MomentOfGlory:IsCastable() and v47 and ((v53 and v32) or not v53) and ((v15:BuffRemains(v100.SentinelBuff) < (37 - 22)) or (((v10.CombatTime() > (2 + 8)) or (v100.Sentinel:CooldownRemains() > (26 - 11)) or (v100.AvengingWrath:CooldownRemains() > (6 + 9))) and (v100.AvengersShield:CooldownRemains() > (0 - 0)) and (v100.Judgment:CooldownRemains() > (1026 - (834 + 192))) and (v100.HammerofWrath:CooldownRemains() > (0 + 0))))) then
					if (((37 + 106) > (2 + 72)) and v25(v100.MomentOfGlory, not v17:IsInRange(12 - 4))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if (((322 - (300 + 4)) < (565 + 1547)) and v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady() and (v108 >= (7 - 4))) then
					if (((1459 - (112 + 250)) <= (649 + 979)) and v25(v100.DivineToll, not v17:IsInRange(75 - 45))) then
						return "divine_toll cooldowns 12";
					end
				end
				v136 = 3 + 1;
			end
		end
	end
	local function v125()
		local v138 = 0 + 0;
		while true do
			if (((3463 + 1167) == (2296 + 2334)) and (v138 == (0 + 0))) then
				if (((4954 - (1001 + 413)) > (5982 - 3299)) and v100.Consecration:IsCastable() and v38 and (v15:BuffStack(v100.SanctificationBuff) == (887 - (244 + 638)))) then
					if (((5487 - (627 + 66)) >= (9758 - 6483)) and v25(v100.Consecration, not v17:IsInRange(610 - (512 + 90)))) then
						return "consecration standard 2";
					end
				end
				if (((3390 - (1665 + 241)) == (2201 - (373 + 344))) and v100.ShieldoftheRighteous:IsCastable() and v62 and ((v15:HolyPower() > (1 + 1)) or v15:BuffUp(v100.BastionofLightBuff) or v15:BuffUp(v100.DivinePurposeBuff)) and (v15:BuffDown(v100.SanctificationBuff) or (v15:BuffStack(v100.SanctificationBuff) < (2 + 3)))) then
					if (((3777 - 2345) < (6015 - 2460)) and v25(v100.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if ((v100.Judgment:IsReady() and v42 and (v108 > (1102 - (35 + 1064))) and (v15:BuffStack(v100.BulwarkofRighteousFuryBuff) >= (3 + 0)) and (v15:HolyPower() < (6 - 3))) or ((5 + 1060) > (4814 - (298 + 938)))) then
					local v213 = 1259 - (233 + 1026);
					while true do
						if ((v213 == (1666 - (636 + 1030))) or ((2452 + 2343) < (1375 + 32))) then
							if (((551 + 1302) < (326 + 4487)) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
								return "judgment standard 6";
							end
							if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((3042 - (55 + 166)) < (472 + 1959))) then
								return "judgment standard 6";
							end
							break;
						end
					end
				end
				if ((v100.Judgment:IsReady() and v42 and v15:BuffDown(v100.SanctificationEmpowerBuff) and v15:HasTier(4 + 27, 7 - 5)) or ((3171 - (36 + 261)) < (3814 - 1633))) then
					local v214 = 1368 - (34 + 1334);
					while true do
						if ((v214 == (0 + 0)) or ((2090 + 599) <= (1626 - (1035 + 248)))) then
							if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((1890 - (20 + 1)) == (1047 + 962))) then
								return "judgment standard 8";
							end
							if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((3865 - (134 + 185)) < (3455 - (549 + 584)))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				v138 = 686 - (314 + 371);
			end
			if ((v138 == (13 - 9)) or ((3050 - (478 + 490)) == (2529 + 2244))) then
				if (((4416 - (786 + 386)) > (3417 - 2362)) and (v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and not v100.InmostLight:IsAvailable()) then
					if (v25(v100.EyeofTyr, not v17:IsInRange(1387 - (1055 + 324))) or ((4653 - (1093 + 247)) <= (1580 + 198))) then
						return "eye_of_tyr standard 34";
					end
				end
				if ((v100.ArcaneTorrent:IsCastable() and v91 and ((v92 and v32) or not v92) and (v113 < (1 + 4))) or ((5641 - 4220) >= (7140 - 5036))) then
					if (((5155 - 3343) <= (8164 - 4915)) and v25(v100.ArcaneTorrent, not v17:IsInRange(3 + 5))) then
						return "arcane_torrent standard 36";
					end
				end
				if (((6252 - 4629) <= (6745 - 4788)) and v100.Consecration:IsCastable() and v38 and (v15:BuffDown(v100.SanctificationEmpowerBuff))) then
					if (((3327 + 1085) == (11283 - 6871)) and v25(v100.Consecration, not v17:IsInRange(696 - (364 + 324)))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if (((4797 - 3047) >= (2020 - 1178)) and (v138 == (1 + 0))) then
				if (((18293 - 13921) > (2962 - 1112)) and v100.HammerofWrath:IsReady() and v41) then
					if (((704 - 472) < (2089 - (1249 + 19))) and v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if (((468 + 50) < (3510 - 2608)) and v100.Judgment:IsReady() and v42 and ((v100.Judgment:Charges() >= (1088 - (686 + 400))) or (v100.Judgment:FullRechargeTime() <= v15:GCD()))) then
					local v215 = 0 + 0;
					while true do
						if (((3223 - (73 + 156)) > (5 + 853)) and (v215 == (811 - (721 + 90)))) then
							if (v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment)) or ((43 + 3712) <= (2970 - 2055))) then
								return "judgment standard 12";
							end
							if (((4416 - (224 + 246)) > (6063 - 2320)) and v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				if ((v100.AvengersShield:IsCastable() and v36 and ((v109 > (3 - 1)) or v15:BuffUp(v100.MomentOfGloryBuff))) or ((243 + 1092) >= (79 + 3227))) then
					if (((3558 + 1286) > (4479 - 2226)) and v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if (((1504 - 1052) == (965 - (203 + 310))) and v45 and ((v51 and v32) or not v51) and v100.DivineToll:IsReady()) then
					if (v25(v100.DivineToll, not v17:IsInRange(2023 - (1238 + 755))) or ((319 + 4238) < (3621 - (709 + 825)))) then
						return "divine_toll standard 16";
					end
				end
				v138 = 3 - 1;
			end
			if (((5643 - 1769) == (4738 - (196 + 668))) and (v138 == (11 - 8))) then
				if (((v88 < v112) and v46 and ((v52 and v32) or not v52) and v100.EyeofTyr:IsCastable() and v100.InmostLight:IsAvailable() and (v108 >= (5 - 2))) or ((2771 - (171 + 662)) > (5028 - (4 + 89)))) then
					if (v25(v100.EyeofTyr, not v17:IsInRange(27 - 19)) or ((1550 + 2705) < (15034 - 11611))) then
						return "eye_of_tyr standard 26";
					end
				end
				if (((571 + 883) <= (3977 - (35 + 1451))) and v100.BlessedHammer:IsCastable() and v37) then
					if (v25(v100.BlessedHammer, not v17:IsInRange(1461 - (28 + 1425))) or ((6150 - (941 + 1052)) <= (2688 + 115))) then
						return "blessed_hammer standard 28";
					end
				end
				if (((6367 - (822 + 692)) >= (4256 - 1274)) and v100.HammeroftheRighteous:IsCastable() and v40) then
					if (((1948 + 2186) > (3654 - (45 + 252))) and v25(v100.HammeroftheRighteous, not v17:IsInRange(8 + 0))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				if ((v100.CrusaderStrike:IsCastable() and v39) or ((1176 + 2241) < (6166 - 3632))) then
					if (v25(v100.CrusaderStrike, not v17:IsSpellInRange(v100.CrusaderStrike)) or ((3155 - (114 + 319)) <= (235 - 71))) then
						return "crusader_strike standard 32";
					end
				end
				v138 = 4 - 0;
			end
			if (((2 + 0) == v138) or ((3587 - 1179) < (4418 - 2309))) then
				if ((v100.AvengersShield:IsCastable() and v36) or ((1996 - (556 + 1407)) == (2661 - (741 + 465)))) then
					if (v25(v100.AvengersShield, not v17:IsSpellInRange(v100.AvengersShield)) or ((908 - (170 + 295)) >= (2116 + 1899))) then
						return "avengers_shield standard 18";
					end
				end
				if (((3107 + 275) > (408 - 242)) and v100.HammerofWrath:IsReady() and v41) then
					if (v25(v100.HammerofWrath, not v17:IsSpellInRange(v100.HammerofWrath)) or ((233 + 47) == (1962 + 1097))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((1066 + 815) > (2523 - (957 + 273))) and v100.Judgment:IsReady() and v42) then
					local v216 = 0 + 0;
					while true do
						if (((944 + 1413) == (8981 - 6624)) and (v216 == (0 - 0))) then
							if (((375 - 252) == (609 - 486)) and v110.CastCycle(v100.Judgment, v106, v115, not v17:IsSpellInRange(v100.Judgment))) then
								return "judgment standard 22";
							end
							if (v25(v100.Judgment, not v17:IsSpellInRange(v100.Judgment)) or ((2836 - (389 + 1391)) >= (2129 + 1263))) then
								return "judgment standard 22";
							end
							break;
						end
					end
				end
				if ((v100.Consecration:IsCastable() and v38 and v15:BuffDown(v100.ConsecrationBuff) and ((v15:BuffStack(v100.SanctificationBuff) < (1 + 4)) or not v15:HasTier(70 - 39, 953 - (783 + 168)))) or ((3627 - 2546) < (1058 + 17))) then
					if (v25(v100.Consecration, not v17:IsInRange(319 - (309 + 2))) or ((3221 - 2172) >= (5644 - (1090 + 122)))) then
						return "consecration standard 24";
					end
				end
				v138 = 1 + 2;
			end
		end
	end
	local function v126()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (3 + 1)) or ((5886 - (628 + 490)) <= (152 + 694))) then
				v46 = EpicSettings.Settings['useEyeofTyr'];
				v47 = EpicSettings.Settings['useMomentOfGlory'];
				v48 = EpicSettings.Settings['useSentinel'];
				v139 = 12 - 7;
			end
			if ((v139 == (27 - 21)) or ((4132 - (431 + 343)) <= (2867 - 1447))) then
				v52 = EpicSettings.Settings['eyeofTyrWithCD'];
				v53 = EpicSettings.Settings['momentOfGloryWithCD'];
				v54 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
			if ((v139 == (14 - 9)) or ((2954 + 785) <= (385 + 2620))) then
				v49 = EpicSettings.Settings['avengingWrathWithCD'];
				v50 = EpicSettings.Settings['bastionofLightWithCD'];
				v51 = EpicSettings.Settings['divineTollWithCD'];
				v139 = 1701 - (556 + 1139);
			end
			if ((v139 == (17 - (6 + 9))) or ((304 + 1355) >= (1094 + 1040))) then
				v40 = EpicSettings.Settings['useHammeroftheRighteous'];
				v41 = EpicSettings.Settings['useHammerofWrath'];
				v42 = EpicSettings.Settings['useJudgment'];
				v139 = 172 - (28 + 141);
			end
			if ((v139 == (0 + 0)) or ((4024 - 764) < (1668 + 687))) then
				v34 = EpicSettings.Settings['swapAuras'];
				v35 = EpicSettings.Settings['useWeapon'];
				v36 = EpicSettings.Settings['useAvengersShield'];
				v139 = 1318 - (486 + 831);
			end
			if ((v139 == (7 - 4)) or ((2354 - 1685) == (798 + 3425))) then
				v43 = EpicSettings.Settings['useAvengingWrath'];
				v44 = EpicSettings.Settings['useBastionofLight'];
				v45 = EpicSettings.Settings['useDivineToll'];
				v139 = 12 - 8;
			end
			if ((v139 == (1264 - (668 + 595))) or ((1523 + 169) < (119 + 469))) then
				v37 = EpicSettings.Settings['useBlessedHammer'];
				v38 = EpicSettings.Settings['useConsecration'];
				v39 = EpicSettings.Settings['useCrusaderStrike'];
				v139 = 5 - 3;
			end
		end
	end
	local function v127()
		local v140 = 290 - (23 + 267);
		while true do
			if ((v140 == (1950 - (1129 + 815))) or ((5184 - (371 + 16)) < (5401 - (1326 + 424)))) then
				v73 = EpicSettings.Settings['shieldoftheRighteousHP'];
				v74 = EpicSettings.Settings['layOnHandsFocusHP'];
				v75 = EpicSettings.Settings['wordofGloryFocusHP'];
				v140 = 13 - 6;
			end
			if ((v140 == (25 - 18)) or ((4295 - (88 + 30)) > (5621 - (720 + 51)))) then
				v76 = EpicSettings.Settings['wordofGloryMouseoverHP'];
				v77 = EpicSettings.Settings['blessingofProtectionFocusHP'];
				v78 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
				v140 = 17 - 9;
			end
			if ((v140 == (1776 - (421 + 1355))) or ((659 - 259) > (546 + 565))) then
				v55 = EpicSettings.Settings['useRebuke'];
				v56 = EpicSettings.Settings['useHammerofJustice'];
				v57 = EpicSettings.Settings['useArdentDefender'];
				v140 = 1084 - (286 + 797);
			end
			if (((11153 - 8102) > (1664 - 659)) and (v140 == (447 - (397 + 42)))) then
				v79 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
				v80 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
				break;
			end
			if (((1154 + 2539) <= (5182 - (24 + 776))) and (v140 == (5 - 1))) then
				v67 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
				v68 = EpicSettings.Settings['ardentDefenderHP'];
				v69 = EpicSettings.Settings['divineShieldHP'];
				v140 = 790 - (222 + 563);
			end
			if (((1 - 0) == v140) or ((2363 + 919) > (4290 - (23 + 167)))) then
				v58 = EpicSettings.Settings['useDivineShield'];
				v59 = EpicSettings.Settings['useGuardianofAncientKings'];
				v60 = EpicSettings.Settings['useLayOnHands'];
				v140 = 1800 - (690 + 1108);
			end
			if (((2 + 1) == v140) or ((2953 + 627) < (3692 - (40 + 808)))) then
				v64 = EpicSettings.Settings['useWordofGloryFocus'];
				v65 = EpicSettings.Settings['useWordofGloryMouseover'];
				v66 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
				v140 = 1 + 3;
			end
			if (((340 - 251) < (4292 + 198)) and (v140 == (2 + 0))) then
				v61 = EpicSettings.Settings['useWordofGloryPlayer'];
				v62 = EpicSettings.Settings['useShieldoftheRighteous'];
				v63 = EpicSettings.Settings['useLayOnHandsFocus'];
				v140 = 2 + 1;
			end
			if ((v140 == (576 - (47 + 524))) or ((3234 + 1749) < (4942 - 3134))) then
				v70 = EpicSettings.Settings['guardianofAncientKingsHP'];
				v71 = EpicSettings.Settings['layonHandsHP'];
				v72 = EpicSettings.Settings['wordofGloryHP'];
				v140 = 8 - 2;
			end
		end
	end
	local function v128()
		local v141 = 0 - 0;
		while true do
			if (((5555 - (1165 + 561)) > (112 + 3657)) and (v141 == (0 - 0))) then
				v88 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v85 = EpicSettings.Settings['InterruptWithStun'];
				v86 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v87 = EpicSettings.Settings['InterruptThreshold'];
				v141 = 480 - (341 + 138);
			end
			if (((401 + 1084) <= (5992 - 3088)) and (v141 == (328 - (89 + 237)))) then
				v90 = EpicSettings.Settings['trinketsWithCD'];
				v92 = EpicSettings.Settings['racialsWithCD'];
				v94 = EpicSettings.Settings['useHealthstone'];
				v93 = EpicSettings.Settings['useHealingPotion'];
				v141 = 9 - 6;
			end
			if (((8987 - 4718) == (5150 - (581 + 300))) and ((1223 - (855 + 365)) == v141)) then
				v96 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v95 = EpicSettings.Settings['healingPotionHP'] or (0 + 0);
				v97 = EpicSettings.Settings['HealingPotionName'] or "";
				v83 = EpicSettings.Settings['handleAfflicted'];
				v141 = 1239 - (1030 + 205);
			end
			if (((364 + 23) <= (2588 + 194)) and (v141 == (287 - (156 + 130)))) then
				v82 = EpicSettings.Settings['DispelDebuffs'];
				v81 = EpicSettings.Settings['DispelBuffs'];
				v89 = EpicSettings.Settings['useTrinkets'];
				v91 = EpicSettings.Settings['useRacials'];
				v141 = 4 - 2;
			end
			if (((6 - 2) == v141) or ((3888 - 1989) <= (242 + 675))) then
				v84 = EpicSettings.Settings['HandleIncorporeal'];
				v98 = EpicSettings.Settings['HealOOC'];
				v99 = EpicSettings.Settings['HealOOCHP'] or (0 + 0);
				break;
			end
		end
	end
	local function v129()
		local v142 = 69 - (10 + 59);
		while true do
			if ((v142 == (1 + 2)) or ((21235 - 16923) <= (2039 - (671 + 492)))) then
				if (((1777 + 455) <= (3811 - (369 + 846))) and v100.Redemption:IsCastable() and v100.Redemption:IsReady() and not v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) then
					if (((555 + 1540) < (3146 + 540)) and v25(v102.RedemptionMouseover)) then
						return "redemption mouseover";
					end
				end
				if (v15:AffectingCombat() or ((3540 - (1036 + 909)) >= (3558 + 916))) then
					if ((v100.Intercession:IsCastable() and (v15:HolyPower() >= (4 - 1)) and v100.Intercession:IsReady() and v15:AffectingCombat() and v16:Exists() and v16:IsDeadOrGhost() and v16:IsAPlayer() and not v15:CanAttack(v16)) or ((4822 - (11 + 192)) < (1457 + 1425))) then
						if (v25(v102.IntercessionMouseover) or ((469 - (135 + 40)) >= (11704 - 6873))) then
							return "Intercession";
						end
					end
				end
				if (((1224 + 805) <= (6794 - 3710)) and (v15:AffectingCombat() or (v82 and v100.CleanseToxins:IsAvailable()))) then
					local v217 = v82 and v100.CleanseToxins:IsReady() and v33;
					v29 = v110.FocusUnit(v217, nil, 29 - 9, nil, 201 - (50 + 126), v100.FlashofLight);
					if (v29 or ((5672 - 3635) == (536 + 1884))) then
						return v29;
					end
				end
				if (((5871 - (1233 + 180)) > (4873 - (522 + 447))) and v33 and v82) then
					local v218 = 1421 - (107 + 1314);
					while true do
						if (((203 + 233) >= (374 - 251)) and ((1 + 0) == v218)) then
							if (((992 - 492) < (7185 - 5369)) and v100.BlessingofFreedom:IsReady() and v110.UnitHasDebuffFromList(v14, v19.Paladin.FreedomDebuffList)) then
								if (((5484 - (716 + 1194)) == (62 + 3512)) and v25(v102.BlessingofFreedomFocus)) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
						if (((24 + 197) < (893 - (74 + 429))) and (v218 == (0 - 0))) then
							v29 = v110.FocusUnitWithDebuffFromList(v19.Paladin.FreedomDebuffList, 20 + 20, 57 - 32, v100.FlashofLight);
							if (v29 or ((1566 + 647) <= (4380 - 2959))) then
								return v29;
							end
							v218 = 2 - 1;
						end
					end
				end
				if (((3491 - (279 + 154)) < (5638 - (454 + 324))) and (v110.TargetIsValid() or v15:AffectingCombat())) then
					v111 = v10.BossFightRemains(nil, true);
					v112 = v111;
					if ((v112 == (8742 + 2369)) or ((1313 - (12 + 5)) >= (2398 + 2048))) then
						v112 = v10.FightRemains(v106, false);
					end
					v113 = v15:HolyPower();
				end
				v142 = 10 - 6;
			end
			if ((v142 == (1 + 0)) or ((2486 - (277 + 816)) > (19181 - 14692))) then
				v32 = EpicSettings.Toggles['cds'];
				v33 = EpicSettings.Toggles['dispel'];
				if (v15:IsDeadOrGhost() or ((5607 - (1058 + 125)) < (6 + 21))) then
					return v29;
				end
				v106 = v15:GetEnemiesInMeleeRange(983 - (815 + 160));
				v107 = v15:GetEnemiesInRange(128 - 98);
				v142 = 4 - 2;
			end
			if ((v142 == (2 + 4)) or ((5837 - 3840) > (5713 - (41 + 1857)))) then
				if (((5358 - (1222 + 671)) > (4944 - 3031)) and v110.TargetIsValid() and not v15:IsChanneling() and not v15:IsCasting() and v15:AffectingCombat()) then
					local v219 = 0 - 0;
					while true do
						if (((1915 - (229 + 953)) < (3593 - (1111 + 663))) and (v219 == (1580 - (874 + 705)))) then
							v29 = v125();
							if (v29 or ((616 + 3779) == (3245 + 1510))) then
								return v29;
							end
							v219 = 3 - 1;
						end
						if (((0 + 0) == v219) or ((4472 - (642 + 37)) < (541 + 1828))) then
							if ((v88 < v112) or ((654 + 3430) == (665 - 400))) then
								v29 = v124();
								if (((4812 - (233 + 221)) == (10077 - 5719)) and v29) then
									return v29;
								end
								if ((v32 and v101.FyralathTheDreamrender:IsEquippedAndReady() and v35) or ((2762 + 376) < (2534 - (718 + 823)))) then
									if (((2096 + 1234) > (3128 - (266 + 539))) and v25(v102.UseWeapon)) then
										return "Fyralath The Dreamrender used";
									end
								end
							end
							if ((v89 and ((v32 and v90) or not v90) and v17:IsInRange(22 - 14)) or ((4851 - (636 + 589)) == (9468 - 5479))) then
								v29 = v120();
								if (v29 or ((1888 - 972) == (2117 + 554))) then
									return v29;
								end
							end
							v219 = 1 + 0;
						end
						if (((1287 - (657 + 358)) == (719 - 447)) and (v219 == (4 - 2))) then
							if (((5436 - (1151 + 36)) <= (4673 + 166)) and v25(v100.Pool)) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if (((731 + 2046) < (9556 - 6356)) and ((1832 - (1552 + 280)) == v142)) then
				v127();
				v126();
				v128();
				v30 = EpicSettings.Toggles['ooc'];
				v31 = EpicSettings.Toggles['aoe'];
				v142 = 835 - (64 + 770);
			end
			if (((65 + 30) < (4442 - 2485)) and (v142 == (1 + 4))) then
				if (((2069 - (157 + 1086)) < (3436 - 1719)) and v82 and v33) then
					local v220 = 0 - 0;
					while true do
						if (((2186 - 760) >= (1507 - 402)) and (v220 == (819 - (599 + 220)))) then
							if (((5484 - 2730) <= (5310 - (1813 + 118))) and v14) then
								local v228 = 0 + 0;
								while true do
									if (((1217 - (841 + 376)) == v228) or ((5502 - 1575) == (329 + 1084))) then
										v29 = v118();
										if (v29 or ((3149 - 1995) <= (1647 - (464 + 395)))) then
											return v29;
										end
										break;
									end
								end
							end
							if ((v16 and v16:Exists() and v16:IsAPlayer() and (v110.UnitHasCurseDebuff(v16) or v110.UnitHasPoisonDebuff(v16))) or ((4216 - 2573) > (1623 + 1756))) then
								if (v100.CleanseToxins:IsReady() or ((3640 - (467 + 370)) > (9400 - 4851))) then
									if (v25(v102.CleanseToxinsMouseover) or ((162 + 58) >= (10359 - 7337))) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v29 = v122();
				if (((441 + 2381) == (6565 - 3743)) and v29) then
					return v29;
				end
				if (v105 or ((1581 - (150 + 370)) == (3139 - (74 + 1208)))) then
					local v221 = 0 - 0;
					while true do
						if (((13089 - 10329) > (971 + 393)) and (v221 == (390 - (14 + 376)))) then
							v29 = v121();
							if (v29 or ((8502 - 3600) <= (2327 + 1268))) then
								return v29;
							end
							break;
						end
					end
				end
				if ((v110.TargetIsValid() and not v15:AffectingCombat() and v30) or ((3384 + 468) == (280 + 13))) then
					local v222 = 0 - 0;
					while true do
						if (((0 + 0) == v222) or ((1637 - (23 + 55)) == (10873 - 6285))) then
							v29 = v123();
							if (v29 or ((2993 + 1491) == (708 + 80))) then
								return v29;
							end
							break;
						end
					end
				end
				v142 = 9 - 3;
			end
			if (((1437 + 3131) >= (4808 - (652 + 249))) and (v142 == (10 - 6))) then
				if (((3114 - (708 + 1160)) < (9419 - 5949)) and not v15:AffectingCombat()) then
					if (((7416 - 3348) >= (999 - (10 + 17))) and v100.DevotionAura:IsCastable() and (v116()) and v34) then
						if (((111 + 382) < (5625 - (1400 + 332))) and v25(v100.DevotionAura)) then
							return "devotion_aura";
						end
					end
				end
				if (v83 or ((2825 - 1352) >= (5240 - (242 + 1666)))) then
					if (v79 or ((1734 + 2317) <= (425 + 732))) then
						local v226 = 0 + 0;
						while true do
							if (((1544 - (850 + 90)) < (5045 - 2164)) and (v226 == (1390 - (360 + 1030)))) then
								v29 = v110.HandleAfflicted(v100.CleanseToxins, v102.CleanseToxinsMouseover, 36 + 4);
								if (v29 or ((2540 - 1640) == (4646 - 1269))) then
									return v29;
								end
								break;
							end
						end
					end
					if (((6120 - (909 + 752)) > (1814 - (109 + 1114))) and v15:BuffUp(v100.ShiningLightFreeBuff) and v80) then
						local v227 = 0 - 0;
						while true do
							if (((1323 + 2075) >= (2637 - (6 + 236))) and (v227 == (0 + 0))) then
								v29 = v110.HandleAfflicted(v100.WordofGlory, v102.WordofGloryMouseover, 33 + 7, true);
								if (v29 or ((5148 - 2965) >= (4932 - 2108))) then
									return v29;
								end
								break;
							end
						end
					end
				end
				if (((3069 - (1076 + 57)) == (319 + 1617)) and v84) then
					local v223 = 689 - (579 + 110);
					while true do
						if ((v223 == (0 + 0)) or ((4273 + 559) < (2290 + 2023))) then
							v29 = v110.HandleIncorporeal(v100.Repentance, v102.RepentanceMouseOver, 437 - (174 + 233), true);
							if (((11418 - 7330) > (6798 - 2924)) and v29) then
								return v29;
							end
							v223 = 1 + 0;
						end
						if (((5506 - (663 + 511)) == (3865 + 467)) and (v223 == (1 + 0))) then
							v29 = v110.HandleIncorporeal(v100.TurnEvil, v102.TurnEvilMouseOver, 92 - 62, true);
							if (((2422 + 1577) >= (6827 - 3927)) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				v29 = v119();
				if (v29 or ((6112 - 3587) > (1940 + 2124))) then
					return v29;
				end
				v142 = 9 - 4;
			end
			if (((3116 + 1255) == (400 + 3971)) and (v142 == (724 - (478 + 244)))) then
				if (v31 or ((783 - (440 + 77)) > (2268 + 2718))) then
					local v224 = 0 - 0;
					while true do
						if (((3547 - (655 + 901)) >= (172 + 753)) and (v224 == (0 + 0))) then
							v108 = #v106;
							v109 = #v107;
							break;
						end
					end
				else
					local v225 = 0 + 0;
					while true do
						if (((1833 - 1378) < (3498 - (695 + 750))) and (v225 == (0 - 0))) then
							v108 = 1 - 0;
							v109 = 3 - 2;
							break;
						end
					end
				end
				v104 = v15:ActiveMitigationNeeded();
				v105 = v15:IsTankingAoE(359 - (285 + 66)) or v15:IsTanking(v17);
				if ((not v15:AffectingCombat() and v15:IsMounted()) or ((1925 - 1099) == (6161 - (682 + 628)))) then
					if (((30 + 153) == (482 - (176 + 123))) and v100.CrusaderAura:IsCastable() and (v15:BuffDown(v100.CrusaderAura)) and v34) then
						if (((485 + 674) <= (1297 + 491)) and v25(v100.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if ((v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) or ((3776 - (239 + 30)) > (1174 + 3144))) then
					if (v15:AffectingCombat() or ((2956 + 119) <= (5247 - 2282))) then
						if (((4258 - 2893) <= (2326 - (306 + 9))) and v100.Intercession:IsCastable()) then
							if (v25(v100.Intercession, not v17:IsInRange(104 - 74), true) or ((483 + 2293) > (2194 + 1381))) then
								return "intercession target";
							end
						end
					elseif (v100.Redemption:IsCastable() or ((1230 + 1324) == (13737 - 8933))) then
						if (((3952 - (1140 + 235)) == (1640 + 937)) and v25(v100.Redemption, not v17:IsInRange(28 + 2), true)) then
							return "redemption target";
						end
					end
				end
				v142 = 1 + 2;
			end
		end
	end
	local function v130()
		local v143 = 52 - (33 + 19);
		while true do
			if ((v143 == (0 + 0)) or ((17 - 11) >= (833 + 1056))) then
				v21.Print("Protection Paladin by Epic. Supported by xKaneto");
				v114();
				break;
			end
		end
	end
	v21.SetAPL(128 - 62, v129, v130);
end;
return v0["Epix_Paladin_Protection.lua"]();

