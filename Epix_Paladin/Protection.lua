local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((2706 - (692 + 120)) <= (1081 + 325))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Paladin_Protection.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Focus;
	local v14 = v11.Player;
	local v15 = v11.MouseOver;
	local v16 = v11.Target;
	local v17 = v11.Pet;
	local v18 = v9.Spell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Bind;
	local v23 = v20.Macro;
	local v24 = v20.Press;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27 = string.format;
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
	local v99 = v18.Paladin.Protection;
	local v100 = v19.Paladin.Protection;
	local v101 = v23.Paladin.Protection;
	local v102 = {};
	local v103;
	local v104;
	local v105, v106;
	local v107, v108;
	local v109 = v20.Commons.Everyone;
	local v110 = 1826 + 9285;
	local v111 = 2397 + 8714;
	local v112 = 0 - 0;
	v9:RegisterForEvent(function()
		local v130 = 0 - 0;
		while true do
			if (((563 + 1009) >= (624 + 907)) and (v130 == (0 + 0))) then
				v110 = 8080 + 3031;
				v111 = 5188 + 5923;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v113()
		if (v99.CleanseToxins:IsAvailable() or ((6120 - (797 + 636)) < (22053 - 17511))) then
			v109.DispellableDebuffs = v12.MergeTable(v109.DispellableDiseaseDebuffs, v109.DispellablePoisonDebuffs);
		end
	end
	v9:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v114(v131)
		return v131:DebuffRemains(v99.JudgmentDebuff);
	end
	local function v115()
		return v14:BuffDown(v99.RetributionAura) and v14:BuffDown(v99.DevotionAura) and v14:BuffDown(v99.ConcentrationAura) and v14:BuffDown(v99.CrusaderAura);
	end
	local v116 = 1619 - (1427 + 192);
	local function v117()
		if (((1141 + 2150) > (3870 - 2203)) and v99.CleanseToxins:IsReady() and v109.DispellableFriendlyUnit(23 + 2)) then
			if ((v116 == (0 + 0)) or ((1199 - (192 + 134)) == (3310 - (316 + 960)))) then
				v116 = GetTime();
			end
			if (v109.Wait(279 + 221, v116) or ((2174 + 642) < (11 + 0))) then
				local v209 = 0 - 0;
				while true do
					if (((4250 - (83 + 468)) < (6512 - (1202 + 604))) and (v209 == (0 - 0))) then
						if (((4403 - 1757) >= (2425 - 1549)) and v24(v101.CleanseToxinsFocus)) then
							return "cleanse_toxins dispel";
						end
						v116 = 325 - (45 + 280);
						break;
					end
				end
			end
		end
	end
	local function v118()
		if (((593 + 21) <= (2782 + 402)) and v97 and (v14:HealthPercentage() <= v98)) then
			if (((1142 + 1984) == (1730 + 1396)) and v99.FlashofLight:IsReady()) then
				if (v24(v99.FlashofLight) or ((385 + 1802) >= (9173 - 4219))) then
					return "flash_of_light heal ooc";
				end
			end
		end
	end
	local function v119()
		local v132 = 1911 - (340 + 1571);
		while true do
			if ((v132 == (0 + 0)) or ((5649 - (1733 + 39)) == (9823 - 6248))) then
				v28 = v109.HandleTopTrinket(v102, v31, 1074 - (125 + 909), nil);
				if (((2655 - (1096 + 852)) > (284 + 348)) and v28) then
					return v28;
				end
				v132 = 1 - 0;
			end
			if ((v132 == (1 + 0)) or ((1058 - (409 + 103)) >= (2920 - (46 + 190)))) then
				v28 = v109.HandleBottomTrinket(v102, v31, 135 - (51 + 44), nil);
				if (((414 + 1051) <= (5618 - (1114 + 203))) and v28) then
					return v28;
				end
				break;
			end
		end
	end
	local function v120()
		local v133 = 726 - (228 + 498);
		while true do
			if (((370 + 1334) > (788 + 637)) and (v133 == (666 - (174 + 489)))) then
				if ((v100.Healthstone:IsReady() and v93 and (v14:HealthPercentage() <= v95)) or ((1789 - 1102) == (6139 - (830 + 1075)))) then
					if (v24(v101.Healthstone) or ((3854 - (303 + 221)) < (2698 - (231 + 1038)))) then
						return "healthstone defensive";
					end
				end
				if (((956 + 191) >= (1497 - (171 + 991))) and v92 and (v14:HealthPercentage() <= v94)) then
					if (((14156 - 10721) > (5630 - 3533)) and (v96 == "Refreshing Healing Potion")) then
						if (v100.RefreshingHealingPotion:IsReady() or ((9407 - 5637) >= (3235 + 806))) then
							if (v24(v101.RefreshingHealingPotion) or ((13288 - 9497) <= (4647 - 3036))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v96 == "Dreamwalker's Healing Potion") or ((7379 - 2801) <= (6207 - 4199))) then
						if (((2373 - (111 + 1137)) <= (2234 - (91 + 67))) and v100.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v101.RefreshingHealingPotion) or ((2211 - 1468) >= (1098 + 3301))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
			if (((1678 - (423 + 100)) < (12 + 1661)) and (v133 == (0 - 0))) then
				if (((v14:HealthPercentage() <= v68) and v57 and v99.DivineShield:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) or ((1212 + 1112) <= (1349 - (326 + 445)))) then
					if (((16438 - 12671) == (8392 - 4625)) and v24(v99.DivineShield)) then
						return "divine_shield defensive";
					end
				end
				if (((9544 - 5455) == (4800 - (530 + 181))) and (v14:HealthPercentage() <= v70) and v59 and v99.LayonHands:IsCastable() and v14:DebuffDown(v99.ForbearanceDebuff)) then
					if (((5339 - (614 + 267)) >= (1706 - (19 + 13))) and v24(v101.LayonHandsPlayer)) then
						return "lay_on_hands defensive 2";
					end
				end
				v133 = 1 - 0;
			end
			if (((2264 - 1292) <= (4050 - 2632)) and ((1 + 1) == v133)) then
				if ((v99.WordofGlory:IsReady() and (v14:HealthPercentage() <= v71) and v60 and not v14:HealingAbsorbed()) or ((8684 - 3746) < (9875 - 5113))) then
					if ((v14:BuffRemains(v99.ShieldoftheRighteousBuff) >= (1817 - (1293 + 519))) or v14:BuffUp(v99.DivinePurposeBuff) or v14:BuffUp(v99.ShiningLightFreeBuff) or ((5108 - 2604) > (11132 - 6868))) then
						if (((4116 - 1963) == (9283 - 7130)) and v24(v101.WordofGloryPlayer)) then
							return "word_of_glory defensive 8";
						end
					end
				end
				if ((v99.ShieldoftheRighteous:IsCastable() and (v14:HolyPower() > (4 - 2)) and v14:BuffRefreshable(v99.ShieldoftheRighteousBuff) and v61 and (v103 or (v14:HealthPercentage() <= v72))) or ((269 + 238) >= (529 + 2062))) then
					if (((10411 - 5930) == (1036 + 3445)) and v24(v99.ShieldoftheRighteous)) then
						return "shield_of_the_righteous defensive 12";
					end
				end
				v133 = 1 + 2;
			end
			if ((v133 == (1 + 0)) or ((3424 - (709 + 387)) < (2551 - (673 + 1185)))) then
				if (((12551 - 8223) == (13897 - 9569)) and v99.GuardianofAncientKings:IsCastable() and (v14:HealthPercentage() <= v69) and v58 and v14:BuffDown(v99.ArdentDefenderBuff)) then
					if (((2612 - 1024) >= (953 + 379)) and v24(v99.GuardianofAncientKings)) then
						return "guardian_of_ancient_kings defensive 4";
					end
				end
				if ((v99.ArdentDefender:IsCastable() and (v14:HealthPercentage() <= v67) and v56 and v14:BuffDown(v99.GuardianofAncientKingsBuff)) or ((3119 + 1055) > (5735 - 1487))) then
					if (v24(v99.ArdentDefender) or ((1127 + 3459) <= (162 - 80))) then
						return "ardent_defender defensive 6";
					end
				end
				v133 = 3 - 1;
			end
		end
	end
	local function v121()
		local v134 = 1880 - (446 + 1434);
		while true do
			if (((5146 - (1040 + 243)) == (11529 - 7666)) and (v134 == (1848 - (559 + 1288)))) then
				if (v13 or ((2213 - (609 + 1322)) <= (496 - (13 + 441)))) then
					local v210 = 0 - 0;
					while true do
						if (((12072 - 7463) >= (3815 - 3049)) and ((1 + 0) == v210)) then
							if ((v99.BlessingofSacrifice:IsCastable() and v66 and not UnitIsUnit(v13:ID(), v14:ID()) and (v13:HealthPercentage() <= v77)) or ((4183 - 3031) == (884 + 1604))) then
								if (((1500 + 1922) > (9941 - 6591)) and v24(v101.BlessingofSacrificeFocus)) then
									return "blessing_of_sacrifice defensive focus";
								end
							end
							if (((480 + 397) > (690 - 314)) and v99.BlessingofProtection:IsCastable() and v65 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v76)) then
								if (v24(v101.BlessingofProtectionFocus) or ((2062 + 1056) <= (1030 + 821))) then
									return "blessing_of_protection defensive focus";
								end
							end
							break;
						end
						if ((v210 == (0 + 0)) or ((139 + 26) >= (3417 + 75))) then
							if (((4382 - (153 + 280)) < (14022 - 9166)) and v99.WordofGlory:IsReady() and v63 and (v14:BuffUp(v99.ShiningLightFreeBuff) or (v112 >= (3 + 0))) and (v13:HealthPercentage() <= v74)) then
								if (v24(v101.WordofGloryFocus) or ((1689 + 2587) < (1579 + 1437))) then
									return "word_of_glory defensive focus";
								end
							end
							if (((4257 + 433) > (2989 + 1136)) and v99.LayonHands:IsCastable() and v62 and v13:DebuffDown(v99.ForbearanceDebuff) and (v13:HealthPercentage() <= v73)) then
								if (v24(v101.LayonHandsFocus) or ((76 - 26) >= (554 + 342))) then
									return "lay_on_hands defensive focus";
								end
							end
							v210 = 668 - (89 + 578);
						end
					end
				end
				break;
			end
			if ((v134 == (0 + 0)) or ((3563 - 1849) >= (4007 - (572 + 477)))) then
				if (v15:Exists() or ((202 + 1289) < (387 + 257))) then
					if (((85 + 619) < (1073 - (84 + 2))) and v99.WordofGlory:IsReady() and v64 and (v15:HealthPercentage() <= v75)) then
						if (((6127 - 2409) > (1374 + 532)) and v24(v101.WordofGloryMouseover)) then
							return "word_of_glory defensive mouseover";
						end
					end
				end
				if (not v13 or not v13:Exists() or not v13:IsInRange(872 - (497 + 345)) or ((25 + 933) > (615 + 3020))) then
					return;
				end
				v134 = 1334 - (605 + 728);
			end
		end
	end
	local function v122()
		local v135 = 0 + 0;
		while true do
			if (((7783 - 4282) <= (206 + 4286)) and (v135 == (0 - 0))) then
				if (((v87 < v111) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91)) or ((3103 + 339) < (7059 - 4511))) then
					if (((2171 + 704) >= (1953 - (457 + 32))) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
						return "lights_judgment precombat 4";
					end
				end
				if (((v87 < v111) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (3 + 2))) or ((6199 - (832 + 570)) >= (4610 + 283))) then
					if (v24(v99.ArcaneTorrent, not v16:IsInRange(3 + 5)) or ((1949 - 1398) > (997 + 1071))) then
						return "arcane_torrent precombat 6";
					end
				end
				v135 = 797 - (588 + 208);
			end
			if (((5697 - 3583) > (2744 - (884 + 916))) and (v135 == (3 - 1))) then
				if ((v99.Judgment:IsReady() and v41) or ((1312 + 950) >= (3749 - (232 + 421)))) then
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((4144 - (1569 + 320)) >= (868 + 2669))) then
						return "judgment precombat 12";
					end
				end
				break;
			end
			if ((v135 == (1 + 0)) or ((12929 - 9092) < (1911 - (316 + 289)))) then
				if (((7722 - 4772) == (137 + 2813)) and v99.Consecration:IsCastable() and v37) then
					if (v24(v99.Consecration, not v16:IsInRange(1461 - (666 + 787))) or ((5148 - (360 + 65)) < (3083 + 215))) then
						return "consecration";
					end
				end
				if (((1390 - (79 + 175)) >= (242 - 88)) and v99.AvengersShield:IsCastable() and v35) then
					if (v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield)) or ((212 + 59) > (14553 - 9805))) then
						return "avengers_shield precombat 10";
					end
				end
				v135 = 3 - 1;
			end
		end
	end
	local function v123()
		local v136 = 899 - (503 + 396);
		local v137;
		while true do
			if (((4921 - (92 + 89)) >= (6114 - 2962)) and (v136 == (0 + 0))) then
				if ((v99.AvengersShield:IsCastable() and v35 and (v9.CombatTime() < (2 + 0)) and v14:HasTier(113 - 84, 1 + 1)) or ((5877 - 3299) >= (2958 + 432))) then
					if (((20 + 21) <= (5058 - 3397)) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield cooldowns 2";
					end
				end
				if (((76 + 525) < (5429 - 1869)) and v99.LightsJudgment:IsCastable() and v90 and ((v91 and v31) or not v91) and (v108 >= (1246 - (485 + 759)))) then
					if (((543 - 308) < (1876 - (442 + 747))) and v24(v99.LightsJudgment, not v16:IsSpellInRange(v99.LightsJudgment))) then
						return "lights_judgment cooldowns 4";
					end
				end
				v136 = 1136 - (832 + 303);
			end
			if (((5495 - (88 + 858)) > (352 + 801)) and (v136 == (2 + 0))) then
				v137 = v109.HandleDPSPotion(v14:BuffUp(v99.AvengingWrathBuff));
				if (v137 or ((193 + 4481) < (5461 - (766 + 23)))) then
					return v137;
				end
				v136 = 14 - 11;
			end
			if (((5016 - 1348) < (12016 - 7455)) and (v136 == (3 - 2))) then
				if ((v99.AvengingWrath:IsCastable() and v42 and ((v48 and v31) or not v48)) or ((1528 - (1036 + 37)) == (2556 + 1049))) then
					if (v24(v99.AvengingWrath, not v16:IsInRange(15 - 7)) or ((2095 + 568) == (4792 - (641 + 839)))) then
						return "avenging_wrath cooldowns 6";
					end
				end
				if (((5190 - (910 + 3)) <= (11408 - 6933)) and v99.Sentinel:IsCastable() and v47 and ((v53 and v31) or not v53)) then
					if (v24(v99.Sentinel, not v16:IsInRange(1692 - (1466 + 218))) or ((400 + 470) == (2337 - (556 + 592)))) then
						return "sentinel cooldowns 8";
					end
				end
				v136 = 1 + 1;
			end
			if (((2361 - (329 + 479)) <= (3987 - (174 + 680))) and (v136 == (10 - 7))) then
				if ((v99.MomentofGlory:IsCastable() and v46 and ((v52 and v31) or not v52) and ((v14:BuffRemains(v99.SentinelBuff) < (30 - 15)) or (((v9.CombatTime() > (8 + 2)) or (v99.Sentinel:CooldownRemains() > (754 - (396 + 343))) or (v99.AvengingWrath:CooldownRemains() > (2 + 13))) and (v99.AvengersShield:CooldownRemains() > (1477 - (29 + 1448))) and (v99.Judgment:CooldownRemains() > (1389 - (135 + 1254))) and (v99.HammerofWrath:CooldownRemains() > (0 - 0))))) or ((10444 - 8207) >= (2340 + 1171))) then
					if (v24(v99.MomentofGlory, not v16:IsInRange(1535 - (389 + 1138))) or ((1898 - (102 + 472)) > (2850 + 170))) then
						return "moment_of_glory cooldowns 10";
					end
				end
				if ((v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady() and (v107 >= (2 + 1))) or ((2790 + 202) == (3426 - (320 + 1225)))) then
					if (((5528 - 2422) > (934 + 592)) and v24(v99.DivineToll, not v16:IsInRange(1494 - (157 + 1307)))) then
						return "divine_toll cooldowns 12";
					end
				end
				v136 = 1863 - (821 + 1038);
			end
			if (((7542 - 4519) < (424 + 3446)) and ((6 - 2) == v136)) then
				if (((54 + 89) > (183 - 109)) and v99.BastionofLight:IsCastable() and v43 and ((v49 and v31) or not v49) and (v14:BuffUp(v99.AvengingWrathBuff) or (v99.AvengingWrath:CooldownRemains() <= (1056 - (834 + 192))))) then
					if (((2 + 16) < (543 + 1569)) and v24(v99.BastionofLight, not v16:IsInRange(1 + 7))) then
						return "bastion_of_light cooldowns 14";
					end
				end
				break;
			end
		end
	end
	local function v124()
		local v138 = 0 - 0;
		while true do
			if (((1401 - (300 + 4)) <= (435 + 1193)) and (v138 == (2 - 1))) then
				if (((4992 - (112 + 250)) == (1846 + 2784)) and v99.Judgment:IsReady() and v41 and v14:BuffDown(v99.SanctificationEmpowerBuff) and v14:HasTier(77 - 46, 2 + 0)) then
					local v211 = 0 + 0;
					while true do
						if (((2648 + 892) > (1331 + 1352)) and (v211 == (0 + 0))) then
							if (((6208 - (1001 + 413)) >= (7303 - 4028)) and v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 8";
							end
							if (((2366 - (244 + 638)) == (2177 - (627 + 66))) and v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment))) then
								return "judgment standard 8";
							end
							break;
						end
					end
				end
				if (((4266 - 2834) < (4157 - (512 + 90))) and v99.HammerofWrath:IsReady() and v40) then
					if (v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath)) or ((2971 - (1665 + 241)) > (4295 - (373 + 344)))) then
						return "hammer_of_wrath standard 10";
					end
				end
				if ((v99.Judgment:IsReady() and v41 and ((v99.Judgment:Charges() >= (1 + 1)) or (v99.Judgment:FullRechargeTime() <= v14:GCD()))) or ((1269 + 3526) < (3711 - 2304))) then
					local v212 = 0 - 0;
					while true do
						if (((2952 - (35 + 1064)) < (3502 + 1311)) and (v212 == (0 - 0))) then
							if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((12 + 2809) < (3667 - (298 + 938)))) then
								return "judgment standard 12";
							end
							if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((4133 - (233 + 1026)) < (3847 - (636 + 1030)))) then
								return "judgment standard 12";
							end
							break;
						end
					end
				end
				v138 = 2 + 0;
			end
			if ((v138 == (4 + 0)) or ((799 + 1890) <= (24 + 319))) then
				if (((v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and v99.InmostLight:IsAvailable() and (v107 >= (224 - (55 + 166)))) or ((363 + 1506) == (203 + 1806))) then
					if (v24(v99.EyeofTyr, not v16:IsInRange(30 - 22)) or ((3843 - (36 + 261)) < (4060 - 1738))) then
						return "eye_of_tyr standard 26";
					end
				end
				if ((v99.BlessedHammer:IsCastable() and v36) or ((3450 - (34 + 1334)) == (1835 + 2938))) then
					if (((2521 + 723) > (2338 - (1035 + 248))) and v24(v99.BlessedHammer, not v16:IsInRange(29 - (20 + 1)))) then
						return "blessed_hammer standard 28";
					end
				end
				if ((v99.HammeroftheRighteous:IsCastable() and v39) or ((1727 + 1586) <= (2097 - (134 + 185)))) then
					if (v24(v99.HammeroftheRighteous, not v16:IsInRange(1141 - (549 + 584))) or ((2106 - (314 + 371)) >= (7222 - 5118))) then
						return "hammer_of_the_righteous standard 30";
					end
				end
				v138 = 973 - (478 + 490);
			end
			if (((960 + 852) <= (4421 - (786 + 386))) and (v138 == (6 - 4))) then
				if (((3002 - (1055 + 324)) <= (3297 - (1093 + 247))) and v99.AvengersShield:IsCastable() and v35 and ((v108 > (2 + 0)) or v14:BuffUp(v99.MomentofGloryBuff))) then
					if (((464 + 3948) == (17516 - 13104)) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield standard 14";
					end
				end
				if (((5939 - 4189) >= (2395 - 1553)) and v44 and ((v50 and v31) or not v50) and v99.DivineToll:IsReady()) then
					if (((10986 - 6614) > (659 + 1191)) and v24(v99.DivineToll, not v16:IsInRange(115 - 85))) then
						return "divine_toll standard 16";
					end
				end
				if (((799 - 567) < (620 + 201)) and v99.AvengersShield:IsCastable() and v35) then
					if (((1324 - 806) < (1590 - (364 + 324))) and v24(v99.AvengersShield, not v16:IsSpellInRange(v99.AvengersShield))) then
						return "avengers_shield standard 18";
					end
				end
				v138 = 7 - 4;
			end
			if (((7184 - 4190) > (285 + 573)) and ((20 - 15) == v138)) then
				if ((v99.CrusaderStrike:IsCastable() and v38) or ((6013 - 2258) <= (2778 - 1863))) then
					if (((5214 - (1249 + 19)) > (3379 + 364)) and v24(v99.CrusaderStrike, not v16:IsSpellInRange(v99.CrusaderStrike))) then
						return "crusader_strike standard 32";
					end
				end
				if (((v87 < v111) and v45 and ((v51 and v31) or not v51) and v99.EyeofTyr:IsCastable() and not v99.InmostLight:IsAvailable()) or ((5196 - 3861) >= (4392 - (686 + 400)))) then
					if (((3801 + 1043) > (2482 - (73 + 156))) and v24(v99.EyeofTyr, not v16:IsInRange(1 + 7))) then
						return "eye_of_tyr standard 34";
					end
				end
				if (((1263 - (721 + 90)) == (6 + 446)) and v99.ArcaneTorrent:IsCastable() and v90 and ((v91 and v31) or not v91) and (v112 < (16 - 11))) then
					if (v24(v99.ArcaneTorrent, not v16:IsInRange(478 - (224 + 246))) or ((7382 - 2825) < (3842 - 1755))) then
						return "arcane_torrent standard 36";
					end
				end
				v138 = 2 + 4;
			end
			if (((93 + 3781) == (2846 + 1028)) and ((11 - 5) == v138)) then
				if ((v99.Consecration:IsCastable() and v37 and (v14:BuffDown(v99.SanctificationEmpowerBuff))) or ((6449 - 4511) > (5448 - (203 + 310)))) then
					if (v24(v99.Consecration, not v16:IsInRange(2001 - (1238 + 755))) or ((298 + 3957) < (4957 - (709 + 825)))) then
						return "consecration standard 38";
					end
				end
				break;
			end
			if (((2679 - 1225) <= (3628 - 1137)) and (v138 == (867 - (196 + 668)))) then
				if ((v99.HammerofWrath:IsReady() and v40) or ((16412 - 12255) <= (5805 - 3002))) then
					if (((5686 - (171 + 662)) >= (3075 - (4 + 89))) and v24(v99.HammerofWrath, not v16:IsSpellInRange(v99.HammerofWrath))) then
						return "hammer_of_wrath standard 20";
					end
				end
				if (((14489 - 10355) > (1223 + 2134)) and v99.Judgment:IsReady() and v41) then
					if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((15008 - 11591) < (994 + 1540))) then
						return "judgment standard 22";
					end
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((4208 - (35 + 1451)) <= (1617 - (28 + 1425)))) then
						return "judgment standard 22";
					end
				end
				if ((v99.Consecration:IsCastable() and v37 and v14:BuffDown(v99.ConsecrationBuff) and ((v14:BuffStack(v99.SanctificationBuff) < (1998 - (941 + 1052))) or not v14:HasTier(30 + 1, 1516 - (822 + 692)))) or ((3437 - 1029) < (994 + 1115))) then
					if (v24(v99.Consecration, not v16:IsInRange(305 - (45 + 252))) or ((33 + 0) == (501 + 954))) then
						return "consecration standard 24";
					end
				end
				v138 = 9 - 5;
			end
			if ((v138 == (433 - (114 + 319))) or ((635 - 192) >= (5144 - 1129))) then
				if (((2156 + 1226) > (246 - 80)) and v99.Consecration:IsCastable() and v37 and (v14:BuffStack(v99.SanctificationBuff) == (10 - 5))) then
					if (v24(v99.Consecration, not v16:IsInRange(1971 - (556 + 1407))) or ((1486 - (741 + 465)) == (3524 - (170 + 295)))) then
						return "consecration standard 2";
					end
				end
				if (((992 + 889) > (1188 + 105)) and v99.ShieldoftheRighteous:IsCastable() and v61 and ((v14:HolyPower() > (4 - 2)) or v14:BuffUp(v99.BastionofLightBuff) or v14:BuffUp(v99.DivinePurposeBuff)) and (v14:BuffDown(v99.SanctificationBuff) or (v14:BuffStack(v99.SanctificationBuff) < (5 + 0)))) then
					if (((1512 + 845) == (1335 + 1022)) and v24(v99.ShieldoftheRighteous)) then
						return "shield_of_the_righteous standard 4";
					end
				end
				if (((1353 - (957 + 273)) == (33 + 90)) and v99.Judgment:IsReady() and v41 and (v107 > (2 + 1)) and (v14:BuffStack(v99.BulwarkofRighteousFuryBuff) >= (11 - 8)) and (v14:HolyPower() < (7 - 4))) then
					if (v109.CastCycle(v99.Judgment, v105, v114, not v16:IsSpellInRange(v99.Judgment)) or ((3225 - 2169) >= (16796 - 13404))) then
						return "judgment standard 6";
					end
					if (v24(v99.Judgment, not v16:IsSpellInRange(v99.Judgment)) or ((2861 - (389 + 1391)) < (675 + 400))) then
						return "judgment standard 6";
					end
				end
				v138 = 1 + 0;
			end
		end
	end
	local function v125()
		local v139 = 0 - 0;
		while true do
			if ((v139 == (953 - (783 + 168))) or ((3520 - 2471) >= (4360 + 72))) then
				v39 = EpicSettings.Settings['useHammeroftheRighteous'];
				v40 = EpicSettings.Settings['useHammerofWrath'];
				v41 = EpicSettings.Settings['useJudgment'];
				v139 = 314 - (309 + 2);
			end
			if ((v139 == (0 - 0)) or ((5980 - (1090 + 122)) <= (275 + 571))) then
				v33 = EpicSettings.Settings['swapAuras'];
				v34 = EpicSettings.Settings['useWeapon'];
				v35 = EpicSettings.Settings['useAvengersShield'];
				v139 = 3 - 2;
			end
			if ((v139 == (4 + 1)) or ((4476 - (628 + 490)) <= (255 + 1165))) then
				v48 = EpicSettings.Settings['avengingWrathWithCD'];
				v49 = EpicSettings.Settings['bastionofLightWithCD'];
				v50 = EpicSettings.Settings['divineTollWithCD'];
				v139 = 14 - 8;
			end
			if ((v139 == (18 - 14)) or ((4513 - (431 + 343)) <= (6068 - 3063))) then
				v45 = EpicSettings.Settings['useEyeofTyr'];
				v46 = EpicSettings.Settings['useMomentOfGlory'];
				v47 = EpicSettings.Settings['useSentinel'];
				v139 = 14 - 9;
			end
			if ((v139 == (3 + 0)) or ((213 + 1446) >= (3829 - (556 + 1139)))) then
				v42 = EpicSettings.Settings['useAvengingWrath'];
				v43 = EpicSettings.Settings['useBastionofLight'];
				v44 = EpicSettings.Settings['useDivineToll'];
				v139 = 19 - (6 + 9);
			end
			if ((v139 == (1 + 0)) or ((1671 + 1589) < (2524 - (28 + 141)))) then
				v36 = EpicSettings.Settings['useBlessedHammer'];
				v37 = EpicSettings.Settings['useConsecration'];
				v38 = EpicSettings.Settings['useCrusaderStrike'];
				v139 = 1 + 1;
			end
			if ((v139 == (7 - 1)) or ((474 + 195) == (5540 - (486 + 831)))) then
				v51 = EpicSettings.Settings['eyeofTyrWithCD'];
				v52 = EpicSettings.Settings['momentofGloryWithCD'];
				v53 = EpicSettings.Settings['sentinelWithCD'];
				break;
			end
		end
	end
	local function v126()
		v54 = EpicSettings.Settings['useRebuke'];
		v55 = EpicSettings.Settings['useHammerofJustice'];
		v56 = EpicSettings.Settings['useArdentDefender'];
		v57 = EpicSettings.Settings['useDivineShield'];
		v58 = EpicSettings.Settings['useGuardianofAncientKings'];
		v59 = EpicSettings.Settings['useLayOnHands'];
		v60 = EpicSettings.Settings['useWordofGloryPlayer'];
		v61 = EpicSettings.Settings['useShieldoftheRighteous'];
		v62 = EpicSettings.Settings['useLayOnHandsFocus'];
		v63 = EpicSettings.Settings['useWordofGloryFocus'];
		v64 = EpicSettings.Settings['useWordofGloryMouseover'];
		v65 = EpicSettings.Settings['useBlessingOfProtectionFocus'];
		v66 = EpicSettings.Settings['useBlessingOfSacrificeFocus'];
		v67 = EpicSettings.Settings['ardentDefenderHP'];
		v68 = EpicSettings.Settings['divineShieldHP'];
		v69 = EpicSettings.Settings['guardianofAncientKingsHP'];
		v70 = EpicSettings.Settings['layonHandsHP'];
		v71 = EpicSettings.Settings['wordofGloryHP'];
		v72 = EpicSettings.Settings['shieldoftheRighteousHP'];
		v73 = EpicSettings.Settings['layOnHandsFocusHP'];
		v74 = EpicSettings.Settings['wordofGloryFocusHP'];
		v75 = EpicSettings.Settings['wordofGloryMouseoverHP'];
		v76 = EpicSettings.Settings['blessingofProtectionFocusHP'];
		v77 = EpicSettings.Settings['blessingofSacrificeFocusHP'];
		v78 = EpicSettings.Settings['useCleanseToxinsWithAfflicted'];
		v79 = EpicSettings.Settings['useWordofGloryWithAfflicted'];
	end
	local function v127()
		local v166 = 0 - 0;
		while true do
			if ((v166 == (17 - 12)) or ((320 + 1372) < (1859 - 1271))) then
				v82 = EpicSettings.Settings['handleAfflicted'];
				v83 = EpicSettings.Settings['HandleIncorporeal'];
				v97 = EpicSettings.Settings['HealOOC'];
				v166 = 1269 - (668 + 595);
			end
			if ((v166 == (0 + 0)) or ((968 + 3829) < (9956 - 6305))) then
				v87 = EpicSettings.Settings['fightRemainsCheck'] or (290 - (23 + 267));
				v84 = EpicSettings.Settings['InterruptWithStun'];
				v85 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v166 = 1945 - (1129 + 815);
			end
			if ((v166 == (391 - (371 + 16))) or ((5927 - (1326 + 424)) > (9185 - 4335))) then
				v95 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v94 = EpicSettings.Settings['healingPotionHP'] or (118 - (88 + 30));
				v96 = EpicSettings.Settings['HealingPotionName'] or "";
				v166 = 776 - (720 + 51);
			end
			if ((v166 == (6 - 3)) or ((2176 - (421 + 1355)) > (1832 - 721))) then
				v91 = EpicSettings.Settings['racialsWithCD'];
				v93 = EpicSettings.Settings['useHealthstone'];
				v92 = EpicSettings.Settings['useHealingPotion'];
				v166 = 2 + 2;
			end
			if (((4134 - (286 + 797)) > (3673 - 2668)) and (v166 == (2 - 0))) then
				v88 = EpicSettings.Settings['useTrinkets'];
				v90 = EpicSettings.Settings['useRacials'];
				v89 = EpicSettings.Settings['trinketsWithCD'];
				v166 = 442 - (397 + 42);
			end
			if (((1154 + 2539) <= (5182 - (24 + 776))) and (v166 == (1 - 0))) then
				v86 = EpicSettings.Settings['InterruptThreshold'];
				v81 = EpicSettings.Settings['DispelDebuffs'];
				v80 = EpicSettings.Settings['DispelBuffs'];
				v166 = 787 - (222 + 563);
			end
			if (((12 - 6) == v166) or ((2363 + 919) > (4290 - (23 + 167)))) then
				v98 = EpicSettings.Settings['HealOOCHP'] or (1798 - (690 + 1108));
				break;
			end
		end
	end
	local function v128()
		local v167 = 0 + 0;
		while true do
			if ((v167 == (1 + 0)) or ((4428 - (40 + 808)) < (469 + 2375))) then
				v32 = EpicSettings.Toggles['dispel'];
				if (((340 - 251) < (4292 + 198)) and v14:IsDeadOrGhost()) then
					return v28;
				end
				v105 = v14:GetEnemiesInMeleeRange(5 + 3);
				v106 = v14:GetEnemiesInRange(17 + 13);
				if (v30 or ((5554 - (47 + 524)) < (1174 + 634))) then
					v107 = #v105;
					v108 = #v106;
				else
					v107 = 2 - 1;
					v108 = 1 - 0;
				end
				v103 = v14:ActiveMitigationNeeded();
				v167 = 4 - 2;
			end
			if (((5555 - (1165 + 561)) > (112 + 3657)) and ((15 - 10) == v167)) then
				if (((567 + 918) <= (3383 - (341 + 138))) and v109.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting() and v14:AffectingCombat()) then
					local v213 = 0 + 0;
					while true do
						if (((8809 - 4540) == (4595 - (89 + 237))) and (v213 == (3 - 2))) then
							v28 = v124();
							if (((814 - 427) <= (3663 - (581 + 300))) and v28) then
								return v28;
							end
							v213 = 1222 - (855 + 365);
						end
						if ((v213 == (0 - 0)) or ((621 + 1278) <= (2152 - (1030 + 205)))) then
							if ((v87 < v111) or ((4049 + 263) <= (815 + 61))) then
								local v222 = 286 - (156 + 130);
								while true do
									if (((5071 - 2839) <= (4374 - 1778)) and (v222 == (0 - 0))) then
										v28 = v123();
										if (((553 + 1542) < (2150 + 1536)) and v28) then
											return v28;
										end
										v222 = 70 - (10 + 59);
									end
									if ((v222 == (1 + 0)) or ((7855 - 6260) >= (5637 - (671 + 492)))) then
										if ((v31 and v100.FyralathTheDreamrender:IsEquippedAndReady() and v34) or ((3677 + 942) < (4097 - (369 + 846)))) then
											if (v24(v101.UseWeapon) or ((78 + 216) >= (4123 + 708))) then
												return "Fyralath The Dreamrender used";
											end
										end
										break;
									end
								end
							end
							if (((3974 - (1036 + 909)) <= (2453 + 631)) and v88 and ((v31 and v89) or not v89) and v16:IsInRange(13 - 5)) then
								v28 = v119();
								if (v28 or ((2240 - (11 + 192)) == (1223 + 1197))) then
									return v28;
								end
							end
							v213 = 176 - (135 + 40);
						end
						if (((10801 - 6343) > (2354 + 1550)) and (v213 == (4 - 2))) then
							if (((653 - 217) >= (299 - (50 + 126))) and v24(v99.Pool)) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if (((1392 - 892) < (402 + 1414)) and (v167 == (1413 - (1233 + 180)))) then
				v126();
				v125();
				v127();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v167 = 970 - (522 + 447);
			end
			if (((4995 - (107 + 1314)) == (1659 + 1915)) and ((11 - 7) == v167)) then
				if (((94 + 127) < (774 - 384)) and v28) then
					return v28;
				end
				if ((v81 and v32) or ((8755 - 6542) <= (3331 - (716 + 1194)))) then
					local v214 = 0 + 0;
					while true do
						if (((328 + 2730) < (5363 - (74 + 429))) and (v214 == (0 - 0))) then
							if (v13 or ((643 + 653) >= (10177 - 5731))) then
								v28 = v117();
								if (v28 or ((986 + 407) > (13839 - 9350))) then
									return v28;
								end
							end
							if ((v15 and v15:Exists() and v15:IsAPlayer() and (v109.UnitHasCurseDebuff(v15) or v109.UnitHasPoisonDebuff(v15))) or ((10938 - 6514) < (460 - (279 + 154)))) then
								if (v99.CleanseToxins:IsReady() or ((2775 - (454 + 324)) > (3002 + 813))) then
									if (((3482 - (12 + 5)) > (1032 + 881)) and v24(v101.CleanseToxinsMouseover)) then
										return "cleanse_toxins dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				v28 = v121();
				if (((1867 - 1134) < (673 + 1146)) and v28) then
					return v28;
				end
				if (v104 or ((5488 - (277 + 816)) == (20318 - 15563))) then
					local v215 = 1183 - (1058 + 125);
					while true do
						if ((v215 == (0 + 0)) or ((4768 - (815 + 160)) < (10164 - 7795))) then
							v28 = v120();
							if (v28 or ((9694 - 5610) == (64 + 201))) then
								return v28;
							end
							break;
						end
					end
				end
				if (((12739 - 8381) == (6256 - (41 + 1857))) and v109.TargetIsValid() and not v14:AffectingCombat() and v29) then
					local v216 = 1893 - (1222 + 671);
					while true do
						if (((0 - 0) == v216) or ((4510 - 1372) < (2175 - (229 + 953)))) then
							v28 = v122();
							if (((5104 - (1111 + 663)) > (3902 - (874 + 705))) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				v167 = 1 + 4;
			end
			if ((v167 == (2 + 0)) or ((7536 - 3910) == (113 + 3876))) then
				v104 = v14:IsTankingAoE(687 - (642 + 37)) or v14:IsTanking(v16);
				if ((not v14:AffectingCombat() and v14:IsMounted()) or ((209 + 707) == (428 + 2243))) then
					if (((682 - 410) == (726 - (233 + 221))) and v99.CrusaderAura:IsCastable() and (v14:BuffDown(v99.CrusaderAura)) and v33) then
						if (((9825 - 5576) <= (4260 + 579)) and v24(v99.CrusaderAura)) then
							return "crusader_aura";
						end
					end
				end
				if (((4318 - (718 + 823)) < (2014 + 1186)) and v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v14:CanAttack(v16)) then
					if (((900 - (266 + 539)) < (5540 - 3583)) and v14:AffectingCombat()) then
						if (((2051 - (636 + 589)) < (4075 - 2358)) and v99.Intercession:IsCastable()) then
							if (((2940 - 1514) >= (876 + 229)) and v24(v99.Intercession, not v16:IsInRange(11 + 19), true)) then
								return "intercession target";
							end
						end
					elseif (((3769 - (657 + 358)) <= (8946 - 5567)) and v99.Redemption:IsCastable()) then
						if (v24(v99.Redemption, not v16:IsInRange(68 - 38), true) or ((5114 - (1151 + 36)) == (1365 + 48))) then
							return "redemption target";
						end
					end
				end
				if ((v99.Redemption:IsCastable() and v99.Redemption:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((304 + 850) <= (2353 - 1565))) then
					if (v24(v101.RedemptionMouseover) or ((3475 - (1552 + 280)) > (4213 - (64 + 770)))) then
						return "redemption mouseover";
					end
				end
				if (v14:AffectingCombat() or ((1904 + 899) > (10326 - 5777))) then
					if ((v99.Intercession:IsCastable() and (v14:HolyPower() >= (1 + 2)) and v99.Intercession:IsReady() and v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) or ((1463 - (157 + 1086)) >= (6048 - 3026))) then
						if (((12359 - 9537) == (4328 - 1506)) and v24(v101.IntercessionMouseover)) then
							return "Intercession";
						end
					end
				end
				if (v14:AffectingCombat() or (v81 and v99.CleanseToxins:IsAvailable()) or ((1447 - 386) == (2676 - (599 + 220)))) then
					local v217 = 0 - 0;
					local v218;
					while true do
						if (((4691 - (1813 + 118)) > (998 + 366)) and ((1217 - (841 + 376)) == v217)) then
							v218 = v81 and v99.CleanseToxins:IsReady() and v32;
							v28 = v109.FocusUnit(v218, v101, 28 - 8, nil, 6 + 19);
							v217 = 2 - 1;
						end
						if (((860 - (464 + 395)) == v217) or ((12580 - 7678) <= (1727 + 1868))) then
							if (v28 or ((4689 - (467 + 370)) == (604 - 311))) then
								return v28;
							end
							break;
						end
					end
				end
				v167 = 3 + 0;
			end
			if ((v167 == (10 - 7)) or ((244 + 1315) == (10673 - 6085))) then
				if ((v32 and v81) or ((5004 - (150 + 370)) == (2070 - (74 + 1208)))) then
					local v219 = 0 - 0;
					while true do
						if (((21664 - 17096) >= (2781 + 1126)) and ((390 - (14 + 376)) == v219)) then
							v28 = v109.FocusUnitWithDebuffFromList(v18.Paladin.FreedomDebuffList, 69 - 29, 17 + 8);
							if (((1095 + 151) < (3310 + 160)) and v28) then
								return v28;
							end
							v219 = 2 - 1;
						end
						if (((3061 + 1007) >= (1050 - (23 + 55))) and (v219 == (2 - 1))) then
							if (((329 + 164) < (3496 + 397)) and v99.BlessingofFreedom:IsReady() and v109.UnitHasDebuffFromList(v13, v18.Paladin.FreedomDebuffList)) then
								if (v24(v101.BlessingofFreedomFocus) or ((2283 - 810) >= (1049 + 2283))) then
									return "blessing_of_freedom combat";
								end
							end
							break;
						end
					end
				end
				if (v109.TargetIsValid() or v14:AffectingCombat() or ((4952 - (652 + 249)) <= (3096 - 1939))) then
					v110 = v9.BossFightRemains(nil, true);
					v111 = v110;
					if (((2472 - (708 + 1160)) < (7820 - 4939)) and (v111 == (20257 - 9146))) then
						v111 = v9.FightRemains(v105, false);
					end
					v112 = v14:HolyPower();
				end
				if (not v14:AffectingCombat() or ((927 - (10 + 17)) == (759 + 2618))) then
					if (((6191 - (1400 + 332)) > (1133 - 542)) and v99.DevotionAura:IsCastable() and (v115()) and v33) then
						if (((5306 - (242 + 1666)) >= (1025 + 1370)) and v24(v99.DevotionAura)) then
							return "devotion_aura";
						end
					end
				end
				if (v82 or ((801 + 1382) >= (2407 + 417))) then
					local v220 = 940 - (850 + 90);
					while true do
						if (((3390 - 1454) == (3326 - (360 + 1030))) and (v220 == (0 + 0))) then
							if (v78 or ((13638 - 8806) < (5933 - 1620))) then
								local v223 = 1661 - (909 + 752);
								while true do
									if (((5311 - (109 + 1114)) > (7092 - 3218)) and (v223 == (0 + 0))) then
										v28 = v109.HandleAfflicted(v99.CleanseToxins, v101.CleanseToxinsMouseover, 282 - (6 + 236));
										if (((2730 + 1602) == (3487 + 845)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if (((9430 - 5431) >= (5065 - 2165)) and v14:BuffUp(v99.ShiningLightFreeBuff) and v79) then
								v28 = v109.HandleAfflicted(v99.WordofGlory, v101.WordofGloryMouseover, 1173 - (1076 + 57), true);
								if (v28 or ((416 + 2109) > (4753 - (579 + 110)))) then
									return v28;
								end
							end
							break;
						end
					end
				end
				if (((346 + 4025) == (3865 + 506)) and v83) then
					local v221 = 0 + 0;
					while true do
						if (((408 - (174 + 233)) == v221) or ((742 - 476) > (8751 - 3765))) then
							v28 = v109.HandleIncorporeal(v99.TurnEvil, v101.TurnEvilMouseOver, 14 + 16, true);
							if (((3165 - (663 + 511)) >= (826 + 99)) and v28) then
								return v28;
							end
							break;
						end
						if (((99 + 356) < (6329 - 4276)) and (v221 == (0 + 0))) then
							v28 = v109.HandleIncorporeal(v99.Repentance, v101.RepentanceMouseOver, 70 - 40, true);
							if (v28 or ((1999 - 1173) == (2315 + 2536))) then
								return v28;
							end
							v221 = 1 - 0;
						end
					end
				end
				v28 = v118();
				v167 = 3 + 1;
			end
		end
	end
	local function v129()
		local v168 = 0 + 0;
		while true do
			if (((905 - (478 + 244)) == (700 - (440 + 77))) and (v168 == (0 + 0))) then
				v20.Print("Protection Paladin by Epic. Supported by xKaneto");
				v113();
				break;
			end
		end
	end
	v20.SetAPL(241 - 175, v128, v129);
end;
return v0["Epix_Paladin_Protection.lua"]();

