local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if (((6290 - 3791) == (2735 - (141 + 95))) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((5420 - 3165) < (6 + 16))) then
			v6 = v0[v4];
			if (not v6 or ((2975 - 1889) >= (988 + 417))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
	end
end
v0["Epix_Druid_Guardian.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.MouseOver;
	local v15 = v12.Pet;
	local v16 = v12.Target;
	local v17 = v10.Spell;
	local v18 = v10.MultiSpell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Macro;
	local v23 = v20.Bind;
	local v24 = v20.Press;
	local v25 = v20.Commons.Everyone.num;
	local v26 = v20.Commons.Everyone.bool;
	local v27 = math.floor;
	local v28 = v20.Commons.Everyone;
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
	local v65 = v17.Druid.Guardian;
	v65.BlazingThornsBuff = v17(599076 - 173669);
	if (v13:HasTier(19 + 12, 167 - (92 + 71)) or ((1171 + 1198) == (715 - 289))) then
		v65.BlazingThornsBuff = v17(426206 - (574 + 191));
	end
	local v67 = v19.Druid.Guardian;
	local v68 = {v67.Djaruun:ID()};
	local v69 = v22.Druid.Guardian;
	local v70;
	local v71, v72;
	local v73, v74;
	local v75;
	local v76;
	local v77;
	local v78 = v65.ThornsofIron:IsAvailable() and v65.ReinforcedFur:IsAvailable();
	local v79, v80;
	v10:RegisterForEvent(function()
		v65.BlazingThornsBuff = v17(1065774 - 640367);
		if (v13:HasTier(16 + 15, 853 - (254 + 595)) or ((3202 - (55 + 71)) > (4192 - 1009))) then
			v65.BlazingThornsBuff = v17(427231 - (573 + 1217));
		end
	end, "PLAYER_EQUIPMENT_CHANGED");
	v10:RegisterForEvent(function()
		IFBuild = v65.ThornsofIron:IsAvailable() and v65.ReinforcedFur:IsAvailable();
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	local function v81(v96)
		for v107, v108 in pairs(v96) do
			if (((3328 - 2126) > (81 + 977)) and v108:DebuffUp(v65.ToothandClawDebuff)) then
				return false;
			end
		end
		return true;
	end
	local function v82(v97)
		return v97:DebuffRefreshable(v65.MoonfireDebuff) and (v97:TimeToDie() > (18 - 6)) and (((v80 < (946 - (714 + 225))) and v65.FuryofNature:IsAvailable()) or ((v80 < (11 - 7)) and not v65.FuryofNature:IsAvailable()));
	end
	local function v83(v98)
		return v98:DebuffRefreshable(v65.ThrashDebuff) or ((v16:DebuffStack(v65.ThrashDebuff) < (6 - 1)) and (v65.FlashingClaws:TalentRank() == (1 + 1))) or ((v16:DebuffStack(v65.ThrashDebuff) < (5 - 1)) and (v65.FlashingClaws:TalentRank() == (807 - (118 + 688)))) or ((v16:DebuffStack(v65.ThrashDebuff) < (51 - (25 + 23))) and not v65.FlashingClaws:IsAvailable());
	end
	local function v84(v99)
		return v99:DebuffRefreshable(v65.ThrashDebuff) or (v99:DebuffStack(v65.ThrashDebuff) < (1 + 2)) or (v80 >= (1891 - (927 + 959)));
	end
	local function v85(v100)
		return v100:DebuffStack(v65.ThrashDebuff) > (6 - 4);
	end
	local function v86()
		return v65.Rebirth:CooldownUp() and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14);
	end
	local function v87()
		v70 = v28.HandleTopTrinket(v68, v31 and (v13:BuffUp(v65.HeartOfTheWild) or v13:BuffUp(v65.Incarnation) or v13:BloodlustUp()), 772 - (16 + 716), nil);
		if (((7163 - 3452) > (3452 - (11 + 86))) and v70) then
			return v70;
		end
		v70 = v28.HandleBottomTrinket(v68, v31 and (v13:BuffUp(v65.HeartOfTheWild) or v13:BuffUp(v65.Incarnation) or v13:BloodlustUp()), 97 - 57, nil);
		if (v70 or ((1191 - (175 + 110)) >= (5627 - 3398))) then
			return v70;
		end
	end
	local function v88()
		local v101 = 0 - 0;
		while true do
			if (((3084 - (503 + 1293)) > (3493 - 2242)) and (v101 == (2 + 0))) then
				if ((v65.Barkskin:IsCastable() and v54 and (((v13:HealthPercentage() < v55) and v13:BuffDown(v65.IronfurBuff)) or (v13:HealthPercentage() < (v55 * (1061.75 - (810 + 251)))))) or ((3132 + 1381) < (1029 + 2323))) then
					if (v24(v65.Barkskin) or ((1862 + 203) >= (3729 - (43 + 490)))) then
						return "barkskin defensive 10";
					end
				end
				if ((v65.SurvivalInstincts:IsCastable() and (v13:HealthPercentage() < v63) and v62) or ((5109 - (711 + 22)) <= (5728 - 4247))) then
					if (v24(v65.SurvivalInstincts) or ((4251 - (240 + 619)) >= (1145 + 3596))) then
						return "survival_instincts defensive 12";
					end
				end
				v101 = 4 - 1;
			end
			if (((221 + 3104) >= (3898 - (1344 + 400))) and (v101 == (405 - (255 + 150)))) then
				if (((v13:HealthPercentage() < v59) and v58 and v65.FrenziedRegeneration:IsReady() and v13:BuffDown(v65.FrenziedRegenerationBuff) and not v13:HealingAbsorbed()) or ((1021 + 274) >= (1731 + 1502))) then
					if (((18700 - 14323) > (5303 - 3661)) and v24(v65.FrenziedRegeneration)) then
						return "frenzied_regeneration defensive 2";
					end
				end
				if (((6462 - (404 + 1335)) > (1762 - (183 + 223))) and v65.Regrowth:IsCastable() and v13:BuffUp(v65.DreamofCenariusBuff) and ((v13:BuffDown(v65.PoPHealBuff) and (v13:HealthPercentage() < v52)) or (v13:BuffUp(v65.PoPHealBuff) and (v13:HealthPercentage() < v53)))) then
					if (v24(v69.RegrowthPlayer) or ((5032 - 896) <= (2275 + 1158))) then
						return "regrowth defensive 4";
					end
				end
				v101 = 1 + 0;
			end
			if (((4582 - (10 + 327)) <= (3225 + 1406)) and (v101 == (341 - (118 + 220)))) then
				if (((1425 + 2851) >= (4363 - (108 + 341))) and v65.BristlingFur:IsCastable() and (v13:Rage() < (23 + 27)) and (v65.RageoftheSleeper:CooldownRemains() > (33 - 25))) then
					if (((1691 - (711 + 782)) <= (8367 - 4002)) and v24(v65.BristlingFur)) then
						return "bristling_fur defensive 14";
					end
				end
				if (((5251 - (270 + 199)) > (1516 + 3160)) and v65.NaturesVigil:IsReady() and (v13:HealthPercentage() <= v61) and v60) then
					if (((6683 - (580 + 1239)) > (6530 - 4333)) and v24(v65.NaturesVigil, nil, nil, true)) then
						return "natures_vigil defensive 18";
					end
				end
				v101 = 4 + 0;
			end
			if ((v101 == (1 + 3)) or ((1612 + 2088) == (6545 - 4038))) then
				if (((2780 + 1694) >= (1441 - (645 + 522))) and v67.Healthstone:IsReady() and v39 and (v13:HealthPercentage() <= v40)) then
					if (v24(v69.Healthstone, nil, nil, true) or ((3684 - (1010 + 780)) <= (1406 + 0))) then
						return "healthstone defensive 3";
					end
				end
				if (((7488 - 5916) >= (4486 - 2955)) and v34 and (v13:HealthPercentage() <= v36)) then
					if ((v35 == "Refreshing Healing Potion") or ((6523 - (1045 + 791)) < (11496 - 6954))) then
						if (((5024 - 1733) > (2172 - (351 + 154))) and v67.RefreshingHealingPotion:IsReady()) then
							if (v24(v69.RefreshingHealingPotion, nil, nil, true) or ((2447 - (1281 + 293)) == (2300 - (28 + 238)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
				end
				break;
			end
			if ((v101 == (2 - 1)) or ((4375 - (1381 + 178)) < (11 + 0))) then
				if (((2983 + 716) < (2008 + 2698)) and v65.Renewal:IsCastable() and (v13:HealthPercentage() < v57) and v56) then
					if (((9121 - 6475) >= (454 + 422)) and v24(v65.Renewal)) then
						return "renewal defensive 6";
					end
				end
				if (((1084 - (381 + 89)) <= (2824 + 360)) and v65.Ironfur:IsReady() and (v13:BuffDown(v65.IronfurBuff) or ((v13:BuffStack(v65.IronfurBuff) < (2 + 0)) and v13:BuffRefreshable(v65.Ironfur)))) then
					if (((5354 - 2228) == (4282 - (1074 + 82))) and v24(v65.Ironfur)) then
						return "ironfur defensive 8";
					end
				end
				v101 = 3 - 1;
			end
		end
	end
	local function v89()
		if (v65.Moonfire:IsCastable() or ((3971 - (214 + 1570)) >= (6409 - (990 + 465)))) then
			if (v24(v65.Moonfire, not v16:IsSpellInRange(v65.Moonfire)) or ((1599 + 2278) == (1556 + 2019))) then
				return "moonfire precombat 8";
			end
		end
		if (((688 + 19) > (2487 - 1855)) and v65.WildCharge:IsCastable() and not v74 and v50) then
			if (v24(v65.WildCharge, not v16:IsInRange(1751 - (1668 + 58))) or ((1172 - (512 + 114)) >= (6997 - 4313))) then
				return "wild_charge precombat 10";
			end
		end
		if (((3028 - 1563) <= (14965 - 10664)) and v65.Thrash:IsCastable()) then
			if (((793 + 911) > (267 + 1158)) and v24(v65.Thrash, not v74)) then
				return "thrash precombat 12";
			end
		end
		if (v65.Mangle:IsCastable() or ((598 + 89) == (14280 - 10046))) then
			if (v24(v65.Mangle, not v73) or ((5324 - (109 + 1885)) < (2898 - (1269 + 200)))) then
				return "mangle precombat 14";
			end
		end
	end
	local function v90()
	end
	local function v91()
		local v102 = 0 - 0;
		while true do
			if (((1962 - (98 + 717)) >= (1161 - (802 + 24))) and (v102 == (15 - 6))) then
				if (((4338 - 903) > (310 + 1787)) and v65.Swipe:IsCastable()) then
					if (v24(v65.Swipe, not v74) or ((2897 + 873) >= (664 + 3377))) then
						return "swipe bear 60";
					end
				end
				break;
			end
			if ((v102 == (1 + 1)) or ((10546 - 6755) <= (5372 - 3761))) then
				if ((v65.LunarBeam:IsReady() and v31) or ((1638 + 2940) <= (818 + 1190))) then
					if (((928 + 197) <= (1510 + 566)) and v24(v65.LunarBeam)) then
						return "lunar_beam bear 18";
					end
				end
				if ((v65.RageoftheSleeper:IsCastable() and v76 and ((((v13:BuffDown(v65.IncarnationBuff) and (v65.Incarnation:CooldownRemains() > (29 + 31))) or v13:BuffDown(v65.BerserkBuff)) and (v13:Rage() > (1508 - (797 + 636))) and not v65.ConvokeTheSpirits:IsAvailable()) or ((v13:BuffUp(v65.IncarnationBuff) or v13:BuffUp(v65.BerserkBuff)) and (v13:Rage() > (364 - 289)) and not v65.ConvokeTheSpirits:IsAvailable()) or (v65.ConvokeTheSpirits:IsAvailable() and (v13:Rage() > (1694 - (1427 + 192)))))) or ((258 + 485) >= (10213 - 5814))) then
					if (((1039 + 116) < (759 + 914)) and v24(v65.RageoftheSleeper)) then
						return "rage_of_the_sleeper bear 20";
					end
				end
				if ((v65.Berserking:IsCastable() and (v13:BuffUp(v65.BerserkBuff) or v13:BuffUp(v65.IncarnationBuff))) or ((2650 - (192 + 134)) <= (1854 - (316 + 960)))) then
					if (((2097 + 1670) == (2908 + 859)) and v24(v65.Berserking, not v73)) then
						return "berserking bear 22";
					end
				end
				v102 = 3 + 0;
			end
			if (((15632 - 11543) == (4640 - (83 + 468))) and (v102 == (1809 - (1202 + 604)))) then
				if (((20810 - 16352) >= (2785 - 1111)) and v65.Maul:IsReady() and v77 and v13:BuffUp(v65.RageoftheSleeper) and (v13:BuffStack(v65.ToothandClawBuff) > (0 - 0)) and not v78 and (((v80 <= (331 - (45 + 280))) and not v65.Raze:IsAvailable()) or ((v80 == (1 + 0)) and v65.Raze:IsAvailable()))) then
					if (((850 + 122) <= (518 + 900)) and v24(v65.Maul, not v73)) then
						return "maul bear 24";
					end
				end
				if ((v65.Raze:IsReady() and v13:BuffUp(v65.RageoftheSleeper) and (v13:BuffStack(v65.ToothandClawBuff) > (0 + 0)) and not v78 and (v80 > (1 + 0))) or ((9143 - 4205) < (6673 - (340 + 1571)))) then
					if (v24(v65.Raze, not v73) or ((988 + 1516) > (6036 - (1733 + 39)))) then
						return "raze bear 26";
					end
				end
				if (((5916 - 3763) == (3187 - (125 + 909))) and v65.Maul:IsReady() and not v78 and v77 and (v13:BuffUp(v65.IncarnationBuff) or v13:BuffUp(v65.BerserkBuff)) and (v13:BuffStack(v65.ToothandClawBuff) >= (1949 - (1096 + 852))) and (((v80 <= (3 + 2)) and not v65.Raze:IsAvailable()) or ((v80 == (1 - 0)) and v65.Raze:IsAvailable())) and (v13:BuffUp(v65.RageoftheSleeper) or (v65.RageoftheSleeper:CooldownRemains() > (3 + 0)))) then
					if (v24(v65.Maul, not v73) or ((1019 - (409 + 103)) >= (2827 - (46 + 190)))) then
						return "maul bear 28";
					end
				end
				v102 = 99 - (51 + 44);
			end
			if (((1264 + 3217) == (5798 - (1114 + 203))) and (v102 == (731 - (228 + 498)))) then
				if ((v65.Raze:IsReady() and v13:BuffUp(v65.ToothandClawBuff) and (v80 > (1 + 0)) and ((v65.RageoftheSleeper:CooldownRemains() > (2 + 1)) or v13:BuffUp(v65.RageoftheSleeper))) or ((2991 - (174 + 489)) < (1805 - 1112))) then
					if (((6233 - (830 + 1075)) == (4852 - (303 + 221))) and v24(v65.Raze, not v73)) then
						return "raze bear 36";
					end
				end
				if (((2857 - (231 + 1038)) >= (1110 + 222)) and v65.Raze:IsReady() and not v78 and (v80 > (1163 - (171 + 991))) and ((v65.RageoftheSleeper:CooldownRemains() > (12 - 9)) or v13:BuffUp(v65.RageoftheSleeper))) then
					if (v24(v65.Raze, not v73) or ((11207 - 7033) > (10600 - 6352))) then
						return "raze bear 38";
					end
				end
				if ((v65.Mangle:IsCastable() and ((v13:BuffUp(v65.GoreBuff) and (v80 < (9 + 2))) or (v13:BuffStack(v65.ViciousCycleMaulBuff) == (10 - 7)))) or ((13229 - 8643) <= (131 - 49))) then
					if (((11941 - 8078) == (5111 - (111 + 1137))) and v24(v65.Mangle, not v73)) then
						return "mangle bear 40";
					end
				end
				v102 = 164 - (91 + 67);
			end
			if ((v102 == (17 - 11)) or ((71 + 211) <= (565 - (423 + 100)))) then
				if (((33 + 4576) >= (2120 - 1354)) and v65.Maul:IsReady() and v13:BuffUp(v65.ToothandClawBuff) and (((v80 <= (3 + 2)) and not v65.Raze:IsAvailable()) or ((v80 == (772 - (326 + 445))) and v65.Raze:IsAvailable())) and (v13:BuffUp(v65.RageoftheSleeper) or (v65.RageoftheSleeper:CooldownRemains() > (13 - 10)))) then
					if (v24(v65.Maul, not v73) or ((2566 - 1414) == (5807 - 3319))) then
						return "maul bear 42";
					end
				end
				if (((4133 - (530 + 181)) > (4231 - (614 + 267))) and v65.Maul:IsReady() and not v78 and (((v80 <= (37 - (19 + 13))) and not v65.Raze:IsAvailable()) or ((v80 == (1 - 0)) and v65.Raze:IsAvailable())) and (v13:BuffUp(v65.RageoftheSleeper) or (v65.RageoftheSleeper:CooldownRemains() > (6 - 3)))) then
					if (((2505 - 1628) > (98 + 278)) and v24(v65.Maul, not v73)) then
						return "maul bear 44";
					end
				end
				if ((v65.Thrash:IsCastable() and (v80 >= (8 - 3))) or ((6466 - 3348) <= (3663 - (1293 + 519)))) then
					if (v24(v65.Thrash, not v74) or ((336 - 171) >= (9117 - 5625))) then
						return "thrash bear 46";
					end
				end
				v102 = 13 - 6;
			end
			if (((17028 - 13079) < (11439 - 6583)) and (v102 == (3 + 1))) then
				if ((v65.Raze:IsReady() and not v78 and (v13:BuffUp(v65.IncarnationBuff) or v13:BuffUp(v65.BerserkBuff)) and (v80 > (1 + 0)) and ((v65.RageoftheSleeper:CooldownRemains() > (6 - 3)) or v13:BuffUp(v65.RageoftheSleeper))) or ((989 + 3287) < (1002 + 2014))) then
					if (((2931 + 1759) > (5221 - (709 + 387))) and v24(v65.Raze, not v73)) then
						return "raze bear 30";
					end
				end
				if ((v65.Ironfur:IsReady() and not v78 and v48 and ((v13:BuffDown(v65.IronfurBuff) and (v13:Rage() > (1908 - (673 + 1185))) and v76) or (v13:Rage() > (261 - 171))) and v13:BuffUp(v65.RageoftheSleeper) and v13:BuffDown(v65.BlazingThornsBuff)) or ((160 - 110) >= (1473 - 577))) then
					if (v24(v65.Ironfur) or ((1226 + 488) >= (2211 + 747))) then
						return "ironfur bear 32";
					end
				end
				if ((v65.Ironfur:IsReady() and v48 and v78 and (((v13:BuffUp(v65.IncarnationBuff) or v13:BuffUp(v65.BerserkBuff)) and (v13:Rage() > (27 - 7))) or (v13:Rage() > (23 + 67))) and ((v65.RageoftheSleeper:CooldownRemains() > (5 - 2)) or v13:BuffUp(v65.RageoftheSleeper))) or ((2926 - 1435) < (2524 - (446 + 1434)))) then
					if (((1987 - (1040 + 243)) < (2945 - 1958)) and v24(v65.Ironfur)) then
						return "ironfur bear 34";
					end
				end
				v102 = 1852 - (559 + 1288);
			end
			if (((5649 - (609 + 1322)) > (2360 - (13 + 441))) and (v102 == (0 - 0))) then
				if ((v65.BearForm:IsCastable() and v13:BuffDown(v65.BearForm)) or ((2509 - 1551) > (18103 - 14468))) then
					if (((131 + 3370) <= (16313 - 11821)) and v24(v65.BearForm)) then
						return "bear_form bear 2";
					end
				end
				if ((v65.HeartOfTheWild:IsCastable() and v31 and v47) or ((1223 + 2219) < (1117 + 1431))) then
					if (((8531 - 5656) >= (802 + 662)) and v24(v65.HeartOfTheWild)) then
						return "heart_of_the_wild bear 4";
					end
				end
				if (v65.Moonfire:IsReady() or ((8822 - 4025) >= (3235 + 1658))) then
					if (v28.CastCycle(v65.Moonfire, v79, v82, not v16:IsSpellInRange(v65.Moonfire), nil, nil, v69.MoonfireMouseover) or ((307 + 244) > (1486 + 582))) then
						return "moonfire bear 6";
					end
				end
				v102 = 1 + 0;
			end
			if (((2069 + 45) > (1377 - (153 + 280))) and ((23 - 15) == v102)) then
				if (v65.Pulverize:IsReady() or ((2031 + 231) >= (1223 + 1873))) then
					if (v28.CastCycle(v65.Pulverize, v79, v85, not v73, nil, nil, v69.PulverizeMouseover) or ((1181 + 1074) >= (3210 + 327))) then
						return "pulverize bear 54";
					end
				end
				if (v65.Thrash:IsCastable() or ((2781 + 1056) < (1988 - 682))) then
					if (((1824 + 1126) == (3617 - (89 + 578))) and v24(v65.Thrash, not v74)) then
						return "thrash bear 56";
					end
				end
				if ((v65.Moonfire:IsCastable() and (v13:BuffUp(v65.GalacticGuardianBuff))) or ((3374 + 1349) < (6856 - 3558))) then
					if (((2185 - (572 + 477)) >= (21 + 133)) and v24(v65.Moonfire, not v16:IsSpellInRange(v65.Moonfire))) then
						return "moonfire bear 58";
					end
				end
				v102 = 6 + 3;
			end
			if (((1 + 6) == v102) or ((357 - (84 + 2)) > (7824 - 3076))) then
				if (((3415 + 1325) >= (3994 - (497 + 345))) and v65.Swipe:IsCastable() and v13:BuffDown(v65.IncarnationBuff) and v13:BuffDown(v65.BerserkBuff) and (v80 >= (1 + 10))) then
					if (v24(v65.Swipe, not v74) or ((436 + 2142) >= (4723 - (605 + 728)))) then
						return "swipe bear 48";
					end
				end
				if (((30 + 11) <= (3692 - 2031)) and v65.Mangle:IsCastable() and ((v13:BuffUp(v65.IncarnationBuff) and (v80 <= (1 + 3))) or (v13:BuffUp(v65.IncarnationBuff) and v65.SouloftheForest:IsAvailable() and (v80 <= (18 - 13))) or ((v13:Rage() < (82 + 8)) and (v80 < (30 - 19))) or ((v13:Rage() < (65 + 20)) and (v80 < (500 - (457 + 32))) and v65.SouloftheForest:IsAvailable()))) then
					if (((255 + 346) < (4962 - (832 + 570))) and v24(v65.Mangle, not v73)) then
						return "mangle bear 50";
					end
				end
				if (((222 + 13) < (180 + 507)) and v65.Thrash:IsCastable() and (v80 > (3 - 2))) then
					if (((2192 + 2357) > (1949 - (588 + 208))) and v24(v65.Thrash, not v74)) then
						return "thrash bear 52";
					end
				end
				v102 = 21 - 13;
			end
			if ((v102 == (1801 - (884 + 916))) or ((9785 - 5111) < (2709 + 1963))) then
				if (((4321 - (232 + 421)) < (6450 - (1569 + 320))) and v65.Thrash:IsCastable()) then
					if (v28.CastCycle(v65.Thrash, v79, v83, not v74, nil, nil, v69.ThrashMouseover) or ((112 + 343) == (685 + 2920))) then
						return "thrash bear 8";
					end
				end
				if ((v65.Barkskin:IsReady() and (v13:BuffDown(v65.BearForm))) or ((8973 - 6310) == (3917 - (316 + 289)))) then
					if (((11195 - 6918) <= (207 + 4268)) and v24(v65.Barkskin)) then
						return "barkskin bear 10";
					end
				end
				if (v31 or ((2323 - (666 + 787)) == (1614 - (360 + 65)))) then
					local v137 = 0 + 0;
					while true do
						if (((1807 - (79 + 175)) <= (4939 - 1806)) and (v137 == (0 + 0))) then
							if (v65.ConvokeTheSpirits:IsCastable() or ((6856 - 4619) >= (6761 - 3250))) then
								if (v24(v65.ConvokeTheSpirits, not v73, true) or ((2223 - (503 + 396)) > (3201 - (92 + 89)))) then
									return "convoke_the_spirits bear 12";
								end
							end
							if (v65.Berserk:IsCastable() or ((5803 - 2811) == (965 + 916))) then
								if (((1839 + 1267) > (5975 - 4449)) and v24(v65.Berserk, not v73)) then
									return "berserk bear 14";
								end
							end
							v137 = 1 + 0;
						end
						if (((6892 - 3869) < (3377 + 493)) and (v137 == (1 + 0))) then
							if (((435 - 292) > (10 + 64)) and v65.Incarnation:IsCastable()) then
								if (((27 - 9) < (3356 - (485 + 759))) and v24(v65.Incarnation, not v73)) then
									return "incarnation bear 16";
								end
							end
							break;
						end
					end
				end
				v102 = 4 - 2;
			end
		end
	end
	local function v92()
		local v103 = 1189 - (442 + 747);
		while true do
			if (((2232 - (832 + 303)) <= (2574 - (88 + 858))) and (v103 == (2 + 3))) then
				v53 = EpicSettings.Settings['DoCRegrowthWithPoPHP'] or (0 + 0);
				v54 = EpicSettings.Settings['UseBarkskin'];
				v55 = EpicSettings.Settings['BarkskinHP'] or (0 + 0);
				v56 = EpicSettings.Settings['UseRenewal'];
				v103 = 795 - (766 + 23);
			end
			if (((22857 - 18227) == (6332 - 1702)) and (v103 == (7 - 4))) then
				v44 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v45 = EpicSettings.Settings['InterruptThreshold'];
				v47 = EpicSettings.Settings['UseHeartOfTheWild'];
				v48 = EpicSettings.Settings['UseIronfurOffensively'];
				v103 = 13 - 9;
			end
			if (((4613 - (1036 + 37)) > (1903 + 780)) and (v103 == (0 - 0))) then
				v33 = EpicSettings.Settings['UseRacials'];
				v34 = EpicSettings.Settings['UseHealingPotion'];
				v35 = EpicSettings.Settings['HealingPotionName'] or "";
				v36 = EpicSettings.Settings['HealingPotionHP'] or (0 + 0);
				v103 = 1481 - (641 + 839);
			end
			if (((5707 - (910 + 3)) >= (8348 - 5073)) and (v103 == (1685 - (1466 + 218)))) then
				v46 = EpicSettings.Settings['UseMarkOfTheWild'];
				v37 = EpicSettings.Settings['DispelDebuffs'];
				v38 = EpicSettings.Settings['DispelBuffs'];
				v39 = EpicSettings.Settings['UseHealthstone'];
				v103 = 1 + 1;
			end
			if (((2632 - (556 + 592)) == (528 + 956)) and (v103 == (810 - (329 + 479)))) then
				v40 = EpicSettings.Settings['HealthstoneHP'] or (854 - (174 + 680));
				v41 = EpicSettings.Settings['HandleAfflicted'];
				v42 = EpicSettings.Settings['HandleIncorporeal'];
				v43 = EpicSettings.Settings['InterruptWithStun'];
				v103 = 10 - 7;
			end
			if (((2967 - 1535) < (2539 + 1016)) and (v103 == (745 - (396 + 343)))) then
				v57 = EpicSettings.Settings['RenewalHP'] or (0 + 0);
				v58 = EpicSettings.Settings['UseFrenziedRegen'];
				v59 = EpicSettings.Settings['FrenziedRegenHP'] or (1477 - (29 + 1448));
				v60 = EpicSettings.Settings['UseNaturesVigil'];
				v103 = 1396 - (135 + 1254);
			end
			if ((v103 == (14 - 10)) or ((4972 - 3907) > (2385 + 1193))) then
				v49 = EpicSettings.Settings['UseRageDefensively'];
				v50 = EpicSettings.Settings['UseWildCharge'];
				v51 = EpicSettings.Settings['UseRegrowthMouseover'];
				v52 = EpicSettings.Settings['DoCRegrowthNoPoPHP'] or (1527 - (389 + 1138));
				v103 = 579 - (102 + 472);
			end
			if ((v103 == (7 + 0)) or ((2659 + 2136) < (1312 + 95))) then
				v61 = EpicSettings.Settings['NaturesVigilHP'] or (1545 - (320 + 1225));
				v62 = EpicSettings.Settings['UseSurvivalInstincts'];
				v63 = EpicSettings.Settings['SurvivalInstinctsHP'] or (0 - 0);
				v64 = EpicSettings.Settings['UseBearForm'];
				break;
			end
		end
	end
	local function v93()
		local v104 = 0 + 0;
		local v105;
		while true do
			if (((3317 - (157 + 1307)) < (6672 - (821 + 1038))) and (v104 == (2 - 1))) then
				v32 = EpicSettings.Toggles['dispel'];
				if (v13:IsDeadOrGhost() or ((309 + 2512) < (4317 - 1886))) then
					return;
				end
				if (v13:BuffUp(v65.TravelForm) or v13:IsMounted() or ((1070 + 1804) < (5405 - 3224))) then
					return;
				end
				v105 = v27((1027.5 - (834 + 192)) * v65.AstralInfluence:TalentRank());
				v104 = 1 + 1;
			end
			if ((v104 == (1 + 2)) or ((58 + 2631) <= (531 - 188))) then
				if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((2173 - (300 + 4)) == (537 + 1472))) then
					if (v13:AffectingCombat() or ((9282 - 5736) < (2684 - (112 + 250)))) then
						if (v65.Rebirth:IsReady() or ((830 + 1252) == (11957 - 7184))) then
							if (((1859 + 1385) > (546 + 509)) and v24(v69.RebirthMouseover, nil, true)) then
								return "rebirth";
							end
						end
					elseif (v24(v69.ReviveMouseover, nil, true) or ((2478 + 835) <= (882 + 896))) then
						return "revive";
					end
				end
				if (v41 or ((1056 + 365) >= (3518 - (1001 + 413)))) then
					local v138 = 0 - 0;
					while true do
						if (((2694 - (244 + 638)) <= (3942 - (627 + 66))) and (v138 == (0 - 0))) then
							v70 = v28.HandleAfflicted(v65.RemoveCorruption, v69.RemoveCorruptionMouseover, 642 - (512 + 90));
							if (((3529 - (1665 + 241)) <= (2674 - (373 + 344))) and v70) then
								return v70;
							end
							break;
						end
					end
				end
				if (((1990 + 2422) == (1168 + 3244)) and not v13:AffectingCombat() and v29) then
					if (((4616 - 2866) >= (1424 - 582)) and v65.MarkOfTheWild:IsCastable() and (v13:BuffDown(v65.MarkOfTheWild, true) or v28.GroupBuffMissing(v65.MarkOfTheWild))) then
						if (((5471 - (35 + 1064)) > (1347 + 503)) and v24(v69.MarkOfTheWildPlayer)) then
							return "mark_of_the_wild ooc";
						end
					end
					if (((496 - 264) < (4 + 817)) and v65.BearForm:IsCastable() and v13:BuffDown(v65.BearForm) and v13:BuffDown(v65.CatForm) and v13:BuffDown(v65.TravelForm) and not v13:IsMounted() and v64 and v16:IsInRange(1256 - (298 + 938)) and v13:CanAttack(v16)) then
						if (((1777 - (233 + 1026)) < (2568 - (636 + 1030))) and v24(v65.BearForm)) then
							return "bear_form ooc";
						end
					end
				end
				if (((1531 + 1463) > (839 + 19)) and v28.TargetIsValid()) then
					if ((not v13:AffectingCombat() and v29) or ((1116 + 2639) <= (62 + 853))) then
						v70 = v89();
						if (((4167 - (55 + 166)) > (726 + 3017)) and v70) then
							return v70;
						end
					end
					if (v13:AffectingCombat() or v29 or ((135 + 1200) >= (12625 - 9319))) then
						if (((5141 - (36 + 261)) > (3939 - 1686)) and not v13:IsCasting() and not v13:IsChanneling()) then
							local v142 = 1368 - (34 + 1334);
							local v143;
							while true do
								if (((174 + 278) == (352 + 100)) and (v142 == (1284 - (1035 + 248)))) then
									v143 = v28.Interrupt(v65.SkullBash, 31 - (20 + 1), true, v14, v69.SkullBashMouseover);
									if (v143 or ((2375 + 2182) < (2406 - (134 + 185)))) then
										return v143;
									end
									v142 = 1135 - (549 + 584);
								end
								if (((4559 - (314 + 371)) == (13299 - 9425)) and (v142 == (971 - (478 + 490)))) then
									v143 = v28.InterruptWithStun(v65.IncapacitatingRoar, 5 + 3);
									if (v143 or ((3110 - (786 + 386)) > (15984 - 11049))) then
										return v143;
									end
									break;
								end
								if ((v142 == (1379 - (1055 + 324))) or ((5595 - (1093 + 247)) < (3042 + 381))) then
									v143 = v28.Interrupt(v65.SkullBash, 2 + 8, true);
									if (((5772 - 4318) <= (8453 - 5962)) and v143) then
										return v143;
									end
									v142 = 2 - 1;
								end
								if ((v142 == (4 - 2)) or ((1479 + 2678) <= (10798 - 7995))) then
									v143 = v28.InterruptWithStun(v65.MightyBash, 27 - 19);
									if (((3660 + 1193) >= (7625 - 4643)) and v143) then
										return v143;
									end
									v142 = 691 - (364 + 324);
								end
							end
						end
						if (((11332 - 7198) > (8055 - 4698)) and v38 and v32 and v65.Soothe:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v28.UnitHasEnrageBuff(v16)) then
							if (v24(v65.Soothe, not v73) or ((1133 + 2284) < (10603 - 8069))) then
								return "dispel";
							end
						end
						if ((v76 and v13:BuffUp(v65.BearForm)) or ((4358 - 1636) <= (497 - 333))) then
							v70 = v88();
							if (v70 or ((3676 - (1249 + 19)) < (1904 + 205))) then
								return v70;
							end
						end
						if ((v51 and v65.Regrowth:IsReady() and v13:BuffUp(v65.DreamofCenariusBuff)) or ((128 - 95) == (2541 - (686 + 400)))) then
							if (((v13:HealthPercentage() > v53) and v13:IsInParty() and not v13:IsInRaid()) or ((348 + 95) >= (4244 - (73 + 156)))) then
								if (((16 + 3366) > (977 - (721 + 90))) and v14 and v14:Exists() and (v14:HealthPercentage() < (1 + 79)) and not v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
									if (v24(v69.RegrowthMouseover) or ((909 - 629) == (3529 - (224 + 246)))) then
										return "regrowth_mouseover";
									end
								end
							end
						end
						if (((3047 - 1166) > (2380 - 1087)) and v65.WildCharge:IsCastable() and not v74 and v50) then
							if (((428 + 1929) == (57 + 2300)) and v24(v65.WildCharge, not v16:IsInRange(21 + 7))) then
								return "wild_charge main";
							end
						end
						if (((244 - 121) == (409 - 286)) and v31) then
							v70 = v87();
							if (v70 or ((1569 - (203 + 310)) >= (5385 - (1238 + 755)))) then
								return v70;
							end
						end
						if ((v31 and v67.Djaruun:IsEquippedAndReady() and (v16:DebuffUp(v65.MoonfireDebuff))) or ((76 + 1005) < (2609 - (709 + 825)))) then
							if (v24(v69.Djaruun, not v73) or ((1932 - 883) >= (6455 - 2023))) then
								return "djaruun_pillar_of_the_elder_flame main 4";
							end
						end
						v70 = v91();
						if (v70 or ((5632 - (196 + 668)) <= (3340 - 2494))) then
							return v70;
						end
					end
					if (v24(v65.Pool) or ((6955 - 3597) <= (2253 - (171 + 662)))) then
						return "Wait/Pool Resources";
					end
				end
				break;
			end
			if ((v104 == (95 - (4 + 89))) or ((13104 - 9365) <= (1095 + 1910))) then
				v71 = (21 - 16) + v105;
				v72 = 4 + 4 + v105;
				if (v30 or ((3145 - (35 + 1451)) >= (3587 - (28 + 1425)))) then
					local v139 = 1993 - (941 + 1052);
					while true do
						if ((v139 == (0 + 0)) or ((4774 - (822 + 692)) < (3361 - 1006))) then
							v79 = v13:GetEnemiesInMeleeRange(v72);
							v80 = #v79;
							break;
						end
					end
				else
					local v140 = 0 + 0;
					while true do
						if ((v140 == (297 - (45 + 252))) or ((662 + 7) == (1454 + 2769))) then
							v79 = {};
							v80 = 2 - 1;
							break;
						end
					end
				end
				if (v28.TargetIsValid() or v13:AffectingCombat() or ((2125 - (114 + 319)) < (843 - 255))) then
					local v141 = 0 - 0;
					while true do
						if ((v141 == (0 + 0)) or ((7146 - 2349) < (7649 - 3998))) then
							v75 = v13:ActiveMitigationNeeded();
							v76 = v13:IsTankingAoE(1971 - (556 + 1407)) or v13:IsTanking(v16);
							v141 = 1207 - (741 + 465);
						end
						if (((467 - (170 + 295)) == v141) or ((2201 + 1976) > (4455 + 395))) then
							v73 = v16:IsInRange(v71);
							v74 = v16:IsInRange(v72);
							break;
						end
						if (((2 - 1) == v141) or ((332 + 68) > (713 + 398))) then
							v77 = false;
							if (((1728 + 1323) > (2235 - (957 + 273))) and not v86() and (((v13:Rage() >= (v65.Maul:Cost() + 6 + 14)) and not v76) or (v13:RageDeficit() <= (5 + 5)) or not v49)) then
								v77 = true;
							end
							v141 = 7 - 5;
						end
					end
				end
				v104 = 7 - 4;
			end
			if (((11280 - 7587) <= (21698 - 17316)) and (v104 == (1780 - (389 + 1391)))) then
				v92();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['aoe'];
				v31 = EpicSettings.Toggles['cds'];
				v104 = 1 + 0;
			end
		end
	end
	local function v94()
		v20.Print("Guardian Druid rotation by Epic BoomK");
		EpicSettings.SetupVersion("Guardian Druid X v 10.2.00 By BoomK");
	end
	v20.SetAPL(11 + 93, v93, v94);
end;
return v0["Epix_Druid_Guardian.lua"]();

