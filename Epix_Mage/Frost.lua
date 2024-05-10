local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if ((v5 == (2 - 1)) or ((353 + 323) >= (2413 - (326 + 445)))) then
			return v6(...);
		end
		if (((18049 - 13913) > (5340 - 2943)) and (v5 == (0 - 0))) then
			v6 = v0[v4];
			if (not v6 or ((5045 - (530 + 181)) == (5126 - (614 + 267)))) then
				return v1(v4, ...);
			end
			v5 = 33 - (19 + 13);
		end
	end
end
v0["Epix_Mage_Frost.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v12.MouseOver;
	local v18 = v12.Pet;
	local v19 = v10.Spell;
	local v20 = v10.MultiSpell;
	local v21 = v10.Item;
	local v22 = EpicLib;
	local v23 = v22.Cast;
	local v24 = v22.Press;
	local v25 = v22.PressCursor;
	local v26 = v22.Macro;
	local v27 = v22.Bind;
	local v28 = v22.Commons.Everyone.num;
	local v29 = v22.Commons.Everyone.bool;
	local v30 = math.max;
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
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
	local v99 = v19.Mage.Frost;
	local v100 = v21.Mage.Frost;
	local v101 = v26.Mage.Frost;
	local v102 = {};
	local v103, v104;
	local v105, v106;
	local v107 = 0 - 0;
	local v108 = 0 - 0;
	local v109 = 42 - 27;
	local v110 = 2886 + 8225;
	local v111 = 19540 - 8429;
	local v112;
	local v113 = v22.Commons.Everyone;
	local function v114()
		if (v99.RemoveCurse:IsAvailable() or ((8867 - 4591) <= (4843 - (1293 + 519)))) then
			v113.DispellableDebuffs = v113.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v99.FrozenOrb:RegisterInFlightEffect(172857 - 88136);
	v99.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v99.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v99.Frostbolt:RegisterInFlightEffect(596855 - 368258);
	v99.Frostbolt:RegisterInFlight();
	v99.Flurry:RegisterInFlightEffect(436686 - 208332);
	v99.Flurry:RegisterInFlight();
	v99.GlacialSpike:RegisterInFlightEffect(985748 - 757148);
	v99.GlacialSpike:RegisterInFlight();
	v99.IceLance:RegisterInFlightEffect(538516 - 309918);
	v99.IceLance:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v134 = 0 + 0;
		while true do
			if ((v134 == (1 + 0)) or ((11110 - 6328) <= (278 + 921))) then
				v107 = 0 + 0;
				break;
			end
			if ((v134 == (0 + 0)) or ((5960 - (709 + 387)) < (3760 - (673 + 1185)))) then
				v110 = 32223 - 21112;
				v111 = 35679 - 24568;
				v134 = 1 - 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v115(v135)
		local v136 = 0 + 0;
		while true do
			if (((3616 + 1223) >= (4995 - 1295)) and (v136 == (0 + 0))) then
				if ((v135 == nil) or ((2143 - 1068) > (3764 - 1846))) then
					v135 = v15;
				end
				return not v135:IsInBossList() or (v135:Level() < (1953 - (446 + 1434)));
			end
		end
	end
	local function v116()
		return v30(v14:BuffRemains(v99.FingersofFrostBuff), v15:DebuffRemains(v99.WintersChillDebuff), v15:DebuffRemains(v99.Frostbite), v15:DebuffRemains(v99.Freeze), v15:DebuffRemains(v99.FrostNova));
	end
	local function v117(v137)
		local v138 = 1283 - (1040 + 243);
		local v139;
		while true do
			if (((1181 - 785) <= (5651 - (559 + 1288))) and (v138 == (1932 - (609 + 1322)))) then
				for v212, v213 in pairs(v137) do
					v139 = v139 + v213:DebuffStack(v99.WintersChillDebuff);
				end
				return v139;
			end
			if ((v138 == (454 - (13 + 441))) or ((15578 - 11409) == (5728 - 3541))) then
				if (((7002 - 5596) == (53 + 1353)) and (v99.WintersChillDebuff:AuraActiveCount() == (0 - 0))) then
					return 0 + 0;
				end
				v139 = 0 + 0;
				v138 = 2 - 1;
			end
		end
	end
	local function v118(v140)
		return (v140:DebuffStack(v99.WintersChillDebuff));
	end
	local function v119(v141)
		return (v141:DebuffDown(v99.WintersChillDebuff));
	end
	local function v120()
		if (((838 + 693) < (7855 - 3584)) and v99.IceBarrier:IsCastable() and v63 and v14:BuffDown(v99.IceBarrier) and (v14:HealthPercentage() <= v70)) then
			if (((420 + 215) == (354 + 281)) and v24(v99.IceBarrier)) then
				return "ice_barrier defensive 1";
			end
		end
		if (((2424 + 949) <= (2986 + 570)) and v99.MassBarrier:IsCastable() and v67 and v14:BuffDown(v99.IceBarrier) and v113.AreUnitsBelowHealthPercentage(v75, 2 + 0, v99.ArcaneIntellect)) then
			if (v24(v99.MassBarrier) or ((3724 - (153 + 280)) < (9471 - 6191))) then
				return "mass_barrier defensive 2";
			end
		end
		if (((3938 + 448) >= (345 + 528)) and v99.IceColdTalent:IsAvailable() and v99.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
			if (((482 + 439) <= (1001 + 101)) and v24(v99.IceColdAbility)) then
				return "ice_cold defensive 3";
			end
		end
		if (((3410 + 1296) >= (1466 - 503)) and v99.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) then
			if (v24(v99.IceBlock) or ((594 + 366) <= (1543 - (89 + 578)))) then
				return "ice_block defensive 4";
			end
		end
		if ((v99.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or ((1476 + 590) == (1937 - 1005))) then
			if (((5874 - (572 + 477)) < (654 + 4189)) and v24(v99.MirrorImage)) then
				return "mirror_image defensive 5";
			end
		end
		if ((v99.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((2327 + 1550) >= (542 + 3995))) then
			if (v24(v99.GreaterInvisibility) or ((4401 - (84 + 2)) < (2844 - 1118))) then
				return "greater_invisibility defensive 6";
			end
		end
		if ((v99.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((2651 + 1028) < (1467 - (497 + 345)))) then
			if (v24(v99.AlterTime) or ((119 + 4506) < (107 + 525))) then
				return "alter_time defensive 7";
			end
		end
		if ((v100.Healthstone:IsReady() and v86 and (v14:HealthPercentage() <= v88)) or ((1416 - (605 + 728)) > (1270 + 510))) then
			if (((1213 - 667) <= (50 + 1027)) and v24(v101.Healthstone)) then
				return "healthstone defensive";
			end
		end
		if ((v85 and (v14:HealthPercentage() <= v87)) or ((3682 - 2686) > (3878 + 423))) then
			local v167 = 0 - 0;
			while true do
				if (((3074 + 996) > (1176 - (457 + 32))) and ((0 + 0) == v167)) then
					if ((v89 == "Refreshing Healing Potion") or ((2058 - (832 + 570)) >= (3138 + 192))) then
						if (v100.RefreshingHealingPotion:IsReady() or ((650 + 1842) <= (1185 - 850))) then
							if (((2082 + 2240) >= (3358 - (588 + 208))) and v24(v101.RefreshingHealingPotion)) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v89 == "Dreamwalker's Healing Potion") or ((9802 - 6165) >= (5570 - (884 + 916)))) then
						if (v100.DreamwalkersHealingPotion:IsReady() or ((4980 - 2601) > (2655 + 1923))) then
							if (v24(v101.RefreshingHealingPotion) or ((1136 - (232 + 421)) > (2632 - (1569 + 320)))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local v121 = 0 + 0;
	local function v122()
		if (((467 + 1987) > (1947 - 1369)) and v99.RemoveCurse:IsReady() and (v113.UnitHasDispellableDebuffByPlayer(v16) or v113.DispellableFriendlyUnit(625 - (316 + 289)) or v113.UnitHasCurseDebuff(v16))) then
			if (((2434 - 1504) < (206 + 4252)) and (v121 == (1453 - (666 + 787)))) then
				v121 = GetTime();
			end
			if (((1087 - (360 + 65)) <= (909 + 63)) and v113.Wait(754 - (79 + 175), v121)) then
				local v214 = 0 - 0;
				while true do
					if (((3411 + 959) == (13395 - 9025)) and ((0 - 0) == v214)) then
						if (v24(v101.RemoveCurseFocus) or ((5661 - (503 + 396)) <= (1042 - (92 + 89)))) then
							return "remove_curse dispel";
						end
						v121 = 0 - 0;
						break;
					end
				end
			end
		end
	end
	local function v123()
		local v142 = 0 + 0;
		while true do
			if ((v142 == (0 + 0)) or ((5529 - 4117) == (584 + 3680))) then
				v31 = v113.HandleTopTrinket(v102, v34, 91 - 51, nil);
				if (v31 or ((2765 + 403) < (1029 + 1124))) then
					return v31;
				end
				v142 = 2 - 1;
			end
			if ((v142 == (1 + 0)) or ((7588 - 2612) < (2576 - (485 + 759)))) then
				v31 = v113.HandleBottomTrinket(v102, v34, 92 - 52, nil);
				if (((5817 - (442 + 747)) == (5763 - (832 + 303))) and v31) then
					return v31;
				end
				break;
			end
		end
	end
	local function v124()
		if (v113.TargetIsValid() or ((1000 - (88 + 858)) == (121 + 274))) then
			local v168 = 0 + 0;
			while true do
				if (((4 + 78) == (871 - (766 + 23))) and ((0 - 0) == v168)) then
					if ((v99.MirrorImage:IsCastable() and v68 and v97) or ((794 - 213) < (742 - 460))) then
						if (v24(v99.MirrorImage) or ((15642 - 11033) < (3568 - (1036 + 37)))) then
							return "mirror_image precombat 2";
						end
					end
					if (((817 + 335) == (2243 - 1091)) and v99.Frostbolt:IsCastable() and not v14:IsCasting(v99.Frostbolt)) then
						if (((1492 + 404) <= (4902 - (641 + 839))) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v125()
		local v143 = 913 - (910 + 3);
		local v144;
		while true do
			if ((v143 == (2 - 1)) or ((2674 - (1466 + 218)) > (745 + 875))) then
				if (v144 or ((2025 - (556 + 592)) > (1670 + 3025))) then
					return v144;
				end
				if (((3499 - (329 + 479)) >= (2705 - (174 + 680))) and v99.IcyVeins:IsCastable() and ((v34 and v57) or not v57) and v52 and (v83 < v111)) then
					if (v24(v99.IcyVeins) or ((10256 - 7271) >= (10064 - 5208))) then
						return "icy_veins cd 6";
					end
				end
				v143 = 2 + 0;
			end
			if (((5015 - (396 + 343)) >= (106 + 1089)) and ((1479 - (29 + 1448)) == v143)) then
				if (((4621 - (135 + 1254)) <= (17668 - 12978)) and (v83 < v111)) then
					if ((v91 and ((v34 and v92) or not v92)) or ((4183 - 3287) >= (2097 + 1049))) then
						local v218 = 1527 - (389 + 1138);
						while true do
							if (((3635 - (102 + 472)) >= (2792 + 166)) and (v218 == (0 + 0))) then
								v31 = v123();
								if (((2972 + 215) >= (2189 - (320 + 1225))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if (((1145 - 501) <= (431 + 273)) and v90 and ((v93 and v34) or not v93) and (v83 < v111)) then
					if (((2422 - (157 + 1307)) > (2806 - (821 + 1038))) and v99.BloodFury:IsCastable()) then
						if (((11207 - 6715) >= (291 + 2363)) and v24(v99.BloodFury)) then
							return "blood_fury cd 10";
						end
					end
					if (((6113 - 2671) >= (560 + 943)) and v99.Berserking:IsCastable()) then
						if (v24(v99.Berserking) or ((7857 - 4687) <= (2490 - (834 + 192)))) then
							return "berserking cd 12";
						end
					end
					if (v99.LightsJudgment:IsCastable() or ((305 + 4492) == (1127 + 3261))) then
						if (((12 + 539) <= (1054 - 373)) and v24(v99.LightsJudgment, not v15:IsSpellInRange(v99.LightsJudgment))) then
							return "lights_judgment cd 14";
						end
					end
					if (((3581 - (300 + 4)) > (109 + 298)) and v99.Fireblood:IsCastable()) then
						if (((12290 - 7595) >= (1777 - (112 + 250))) and v24(v99.Fireblood)) then
							return "fireblood cd 16";
						end
					end
					if (v99.AncestralCall:IsCastable() or ((1281 + 1931) <= (2364 - 1420))) then
						if (v24(v99.AncestralCall) or ((1774 + 1322) <= (930 + 868))) then
							return "ancestral_call cd 18";
						end
					end
				end
				break;
			end
			if (((2646 + 891) == (1754 + 1783)) and (v143 == (0 + 0))) then
				if (((5251 - (1001 + 413)) >= (3501 - 1931)) and v96 and v99.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v99.TemporalWarp:IsAvailable() and v14:BloodlustDown() and (v14:PrevOffGCDP(883 - (244 + 638), v99.IcyVeins) or (v14:BuffUp(v99.IcyVeinsBuff) and (v111 <= (803 - (627 + 66)))) or (v14:BuffUp(v99.IcyVeinsBuff) and (v111 >= (834 - 554))) or (v111 < (642 - (512 + 90))))) then
					if (v24(v99.TimeWarp, not v15:IsInRange(1946 - (1665 + 241))) or ((3667 - (373 + 344)) == (1720 + 2092))) then
						return "time_warp cd 2";
					end
				end
				v144 = v113.HandleDPSPotion(v14:BuffUp(v99.IcyVeinsBuff));
				v143 = 1 + 0;
			end
		end
	end
	local function v126()
		if (((12457 - 7734) >= (3922 - 1604)) and v99.IceFloes:IsCastable() and v46 and v14:BuffDown(v99.IceFloes) and not v14:PrevOffGCDP(1100 - (35 + 1064), v99.IceFloes)) then
			if (v24(v99.IceFloes) or ((1475 + 552) > (6101 - 3249))) then
				return "ice_floes movement";
			end
		end
		if ((v99.IceNova:IsCastable() and v48) or ((5 + 1131) > (5553 - (298 + 938)))) then
			if (((6007 - (233 + 1026)) == (6414 - (636 + 1030))) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
				return "ice_nova movement";
			end
		end
		if (((1911 + 1825) <= (4630 + 110)) and v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (9 + 21)) and (v104 >= (1 + 1))) then
			if (v24(v99.ArcaneExplosion, not v15:IsInRange(231 - (55 + 166))) or ((657 + 2733) <= (308 + 2752))) then
				return "arcane_explosion movement";
			end
		end
		if ((v99.FireBlast:IsCastable() and v40) or ((3815 - 2816) > (2990 - (36 + 261)))) then
			if (((809 - 346) < (1969 - (34 + 1334))) and v24(v99.FireBlast, not v15:IsSpellInRange(v99.FireBlast))) then
				return "fire_blast movement";
			end
		end
		if ((v99.IceLance:IsCastable() and v47) or ((840 + 1343) < (534 + 153))) then
			if (((5832 - (1035 + 248)) == (4570 - (20 + 1))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
				return "ice_lance movement";
			end
		end
	end
	local function v127()
		if (((2435 + 2237) == (4991 - (134 + 185))) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1134 - (549 + 584), v99.CometStorm) or (v14:PrevGCDP(686 - (314 + 371), v99.FrozenOrb) and not v99.CometStorm:IsAvailable()))) then
			if (v24(v99.ConeofCold, not v15:IsInRange(41 - 29)) or ((4636 - (478 + 490)) < (210 + 185))) then
				return "cone_of_cold aoe 2";
			end
		end
		if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (not v14:PrevGCDP(1173 - (786 + 386), v99.GlacialSpike) or not v115())) or ((13493 - 9327) == (1834 - (1055 + 324)))) then
			if (v24(v101.FrozenOrbCast, not v15:IsInRange(1380 - (1093 + 247))) or ((3954 + 495) == (281 + 2382))) then
				return "frozen_orb aoe 4";
			end
		end
		if ((v99.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(3 - 2, v99.GlacialSpike) or not v115())) or ((14515 - 10238) < (8504 - 5515))) then
			if (v24(v101.BlizzardCursor, not v15:IsInRange(100 - 60), v14:BuffDown(v99.IceFloes)) or ((310 + 560) >= (15983 - 11834))) then
				return "blizzard aoe 6";
			end
		end
		if (((7624 - 5412) < (2401 + 782)) and v99.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v111) and not v14:PrevGCDP(2 - 1, v99.GlacialSpike) and (not v99.ColdestSnap:IsAvailable() or (v99.ConeofCold:CooldownUp() and (v99.FrozenOrb:CooldownRemains() > (713 - (364 + 324)))) or (v99.ConeofCold:CooldownRemains() > (54 - 34)))) then
			if (((11148 - 6502) > (992 + 2000)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
				return "comet_storm aoe 8";
			end
		end
		if (((6000 - 4566) < (4974 - 1868)) and v18:IsActive() and v44 and v99.Freeze:IsReady() and v115() and (v116() == (0 - 0)) and ((not v99.GlacialSpike:IsAvailable() and not v99.Snowstorm:IsAvailable()) or v14:PrevGCDP(1269 - (1249 + 19), v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109)))) then
			if (((710 + 76) < (11766 - 8743)) and v24(v101.FreezePet, not v15:IsSpellInRange(v99.Freeze))) then
				return "freeze aoe 10";
			end
		end
		if ((v99.IceNova:IsCastable() and v48 and v115() and not v14:PrevOffGCDP(1087 - (686 + 400), v99.Freeze) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (230 - (73 + 156)))))) or ((12 + 2430) < (885 - (721 + 90)))) then
			if (((51 + 4484) == (14724 - 10189)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
				return "ice_nova aoe 11";
			end
		end
		if ((v99.FrostNova:IsCastable() and v42 and v115() and not v14:PrevOffGCDP(471 - (224 + 246), v99.Freeze) and ((v14:PrevGCDP(1 - 0, v99.GlacialSpike) and (v107 == (0 - 0))) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (1 + 0))))) or ((72 + 2937) <= (1547 + 558))) then
			if (((3638 - 1808) < (12209 - 8540)) and v24(v99.FrostNova)) then
				return "frost_nova aoe 12";
			end
		end
		if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and (v14:BuffStackP(v99.SnowstormBuff) == v109)) or ((1943 - (203 + 310)) >= (5605 - (1238 + 755)))) then
			if (((188 + 2495) >= (3994 - (709 + 825))) and v24(v99.ConeofCold, not v15:IsInRange(14 - 6))) then
				return "cone_of_cold aoe 14";
			end
		end
		if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111)) or ((2627 - 823) >= (4139 - (196 + 668)))) then
			if (v24(v99.ShiftingPower, not v15:IsInRange(157 - 117), true) or ((2935 - 1518) > (4462 - (171 + 662)))) then
				return "shifting_power aoe 16";
			end
		end
		if (((4888 - (4 + 89)) > (1408 - 1006)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (2 + 3)) and (v99.Blizzard:CooldownRemains() > v112)) then
			if (((21139 - 16326) > (1399 + 2166)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
				return "glacial_spike aoe 18";
			end
		end
		if (((5398 - (35 + 1451)) == (5365 - (28 + 1425))) and v99.Flurry:IsCastable() and v43 and not v115() and (v107 == (1993 - (941 + 1052))) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.Flurry:ChargesFractional() > (1515.8 - (822 + 692))))) then
			if (((4027 - 1206) <= (2273 + 2551)) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes))) then
				return "flurry aoe 20";
			end
		end
		if (((2035 - (45 + 252)) <= (2172 + 23)) and v99.Flurry:IsCastable() and v43 and (v107 == (0 + 0)) and (v14:BuffUp(v99.BrainFreezeBuff) or v14:BuffUp(v99.FingersofFrostBuff))) then
			if (((99 - 58) <= (3451 - (114 + 319))) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes))) then
				return "flurry aoe 21";
			end
		end
		if (((3079 - 934) <= (5258 - 1154)) and v99.IceLance:IsCastable() and v47 and (v14:BuffUp(v99.FingersofFrostBuff) or (v116() > v99.IceLance:TravelTime()) or v29(v107))) then
			if (((1715 + 974) < (7218 - 2373)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
				return "ice_lance aoe 22";
			end
		end
		if ((v99.IceNova:IsCastable() and v48 and (v103 >= (8 - 4)) and ((not v99.Snowstorm:IsAvailable() and not v99.GlacialSpike:IsAvailable()) or not v115())) or ((4285 - (556 + 1407)) > (3828 - (741 + 465)))) then
			if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((4999 - (170 + 295)) == (1097 + 985))) then
				return "ice_nova aoe 23";
			end
		end
		if ((v99.DragonsBreath:IsCastable() and v39 and (v104 >= (7 + 0))) or ((3867 - 2296) > (1548 + 319))) then
			if (v24(v99.DragonsBreath, not v15:IsInRange(7 + 3)) or ((1503 + 1151) >= (4226 - (957 + 273)))) then
				return "dragons_breath aoe 26";
			end
		end
		if (((1064 + 2914) > (843 + 1261)) and v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (114 - 84)) and (v104 >= (18 - 11))) then
			if (((9148 - 6153) > (7630 - 6089)) and v24(v99.ArcaneExplosion, not v15:IsInRange(1788 - (389 + 1391)))) then
				return "arcane_explosion aoe 28";
			end
		end
		if (((2039 + 1210) > (100 + 853)) and v99.Frostbolt:IsCastable() and v41) then
			if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((7451 - 4178) > (5524 - (783 + 168)))) then
				return "frostbolt aoe 32";
			end
		end
		if ((v14:IsMoving() and v95) or ((10575 - 7424) < (1263 + 21))) then
			local v169 = 311 - (309 + 2);
			while true do
				if ((v169 == (0 - 0)) or ((3062 - (1090 + 122)) == (496 + 1033))) then
					v31 = v126();
					if (((2757 - 1936) < (1453 + 670)) and v31) then
						return v31;
					end
					break;
				end
			end
		end
	end
	local function v128()
		local v145 = 1118 - (628 + 490);
		while true do
			if (((162 + 740) < (5756 - 3431)) and (v145 == (18 - 14))) then
				if (((1632 - (431 + 343)) <= (5981 - 3019)) and v99.Frostbolt:IsCastable() and v41) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((11415 - 7469) < (1018 + 270))) then
						return "frostbolt cleave 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((415 + 2827) == (2262 - (556 + 1139)))) then
					v31 = v126();
					if (v31 or ((862 - (6 + 9)) >= (232 + 1031))) then
						return v31;
					end
				end
				break;
			end
			if ((v145 == (2 + 0)) or ((2422 - (28 + 141)) == (717 + 1134))) then
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (12 - 2)) and (v99.FrozenOrb:CooldownRemains() > (8 + 2)) and (v107 == (1317 - (486 + 831))) and (v104 >= (7 - 4))) or ((7347 - 5260) > (449 + 1923))) then
					if (v24(v99.ConeofCold, not v15:IsInRange(37 - 25)) or ((5708 - (668 + 595)) < (3734 + 415))) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v104 >= (1 + 1)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v104 >= (8 - 5)))) or ((2108 - (23 + 267)) == (2029 - (1129 + 815)))) then
					if (((1017 - (371 + 16)) < (3877 - (1326 + 424))) and v24(v101.BlizzardCursor, not v15:IsSpellInRange(v99.Blizzard), v14:BuffDown(v99.IceFloes))) then
						return "blizzard cleave 16";
					end
				end
				if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (((v99.FrozenOrb:CooldownRemains() > (18 - 8)) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (36 - 26))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (128 - (88 + 30))))) or (v99.IcyVeins:CooldownRemains() < (791 - (720 + 51))))) or ((4310 - 2372) == (4290 - (421 + 1355)))) then
					if (((7019 - 2764) >= (28 + 27)) and v24(v99.ShiftingPower, not v15:IsSpellInRange(v99.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				v145 = 1086 - (286 + 797);
			end
			if (((10963 - 7964) > (1914 - 758)) and (v145 == (442 - (397 + 42)))) then
				if (((734 + 1616) > (1955 - (24 + 776))) and v99.GlacialSpike:IsReady() and v45 and (v108 == (7 - 2))) then
					if (((4814 - (222 + 563)) <= (10692 - 5839)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and ((v14:BuffUpP(v99.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike)) or (v107 > (190 - (23 + 167))))) or ((2314 - (690 + 1108)) > (1239 + 2195))) then
					local v215 = 0 + 0;
					while true do
						if (((4894 - (40 + 808)) >= (500 + 2533)) and (v215 == (0 - 0))) then
							if (v113.CastTargetIf(v99.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v99.IceLance)) or ((2599 + 120) <= (766 + 681))) then
								return "ice_lance cleave 22";
							end
							if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((2267 + 1867) < (4497 - (47 + 524)))) then
								return "ice_lance cleave 22";
							end
							break;
						end
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v104 >= (3 + 1))) or ((448 - 284) >= (4164 - 1379))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((1197 - 672) == (3835 - (1165 + 561)))) then
						return "ice_nova cleave 24";
					end
				end
				v145 = 1 + 3;
			end
			if (((102 - 69) == (13 + 20)) and (v145 == (479 - (341 + 138)))) then
				if (((825 + 2229) <= (8285 - 4270)) and v99.CometStorm:IsCastable() and (v14:PrevGCDP(327 - (89 + 237), v99.Flurry) or v14:PrevGCDP(3 - 2, v99.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v111)) then
					if (((3938 - 2067) < (4263 - (581 + 300))) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm cleave 2";
					end
				end
				if (((2513 - (855 + 365)) <= (5144 - 2978)) and v99.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1 + 0, v99.Frostbolt) and (v108 >= (1238 - (1030 + 205)))) or v14:PrevGCDP(1 + 0, v99.GlacialSpike) or ((v108 >= (3 + 0)) and (v108 < (291 - (156 + 130))) and (v99.Flurry:ChargesFractional() == (4 - 2))))) then
					if (v113.CastTargetIf(v99.Flurry, v105, "min", v118, nil, not v15:IsSpellInRange(v99.Flurry)) or ((4346 - 1767) < (251 - 128))) then
						return "flurry cleave 4";
					end
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((223 + 623) >= (1381 + 987))) then
						return "flurry cleave 4";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and (v99.WintersChillDebuff:AuraActiveCount() == (69 - (10 + 59))) and (v108 == (2 + 2)) and v14:BuffUp(v99.FingersofFrostBuff)) or ((19758 - 15746) <= (4521 - (671 + 492)))) then
					if (((1190 + 304) <= (4220 - (369 + 846))) and v113.CastTargetIf(v99.IceLance, v105, "max", v119, nil, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance cleave 6";
					end
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((824 + 2287) == (1822 + 312))) then
						return "ice_lance cleave 6";
					end
				end
				v145 = 1946 - (1036 + 909);
			end
			if (((1873 + 482) == (3953 - 1598)) and (v145 == (204 - (11 + 192)))) then
				if ((v99.RayofFrost:IsCastable() and (v107 == (1 + 0)) and v49) or ((763 - (135 + 40)) <= (1046 - 614))) then
					if (((2892 + 1905) >= (8580 - 4685)) and v113.CastTargetIf(v99.RayofFrost, v105, "max", v118, nil, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
					if (((5361 - 1784) == (3753 - (50 + 126))) and v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
				end
				if (((10564 - 6770) > (818 + 2875)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (1418 - (1233 + 180))) and (v99.Flurry:CooldownUp() or (v107 > (969 - (522 + 447))))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((2696 - (107 + 1314)) == (1903 + 2197))) then
						return "glacial_spike cleave 10";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (v14:BuffStackP(v99.FingersofFrostBuff) < (5 - 3)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((676 + 915) >= (7109 - 3529))) then
					if (((3889 - 2906) <= (3718 - (716 + 1194))) and v24(v101.FrozenOrbCast, not v15:IsSpellInRange(v99.FrozenOrb))) then
						return "frozen_orb cleave 12";
					end
				end
				v145 = 1 + 1;
			end
		end
	end
	local function v129()
		local v146 = 0 + 0;
		while true do
			if ((v146 == (507 - (74 + 429))) or ((4147 - 1997) <= (594 + 603))) then
				if (((8627 - 4858) >= (830 + 343)) and v90 and ((v93 and v34) or not v93)) then
					if (((4577 - 3092) == (3671 - 2186)) and v99.BagofTricks:IsCastable()) then
						if (v24(v99.BagofTricks, not v15:IsSpellInRange(v99.BagofTricks)) or ((3748 - (279 + 154)) <= (3560 - (454 + 324)))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if ((v99.Frostbolt:IsCastable() and v41) or ((690 + 186) >= (2981 - (12 + 5)))) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((1204 + 1028) > (6362 - 3865))) then
						return "frostbolt single 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((780 + 1330) <= (1425 - (277 + 816)))) then
					v31 = v126();
					if (((15750 - 12064) > (4355 - (1058 + 125))) and v31) then
						return v31;
					end
				end
				break;
			end
			if ((v146 == (0 + 0)) or ((5449 - (815 + 160)) < (3518 - 2698))) then
				if (((10157 - 5878) >= (688 + 2194)) and v99.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v111) and (v14:PrevGCDP(2 - 1, v99.Flurry) or v14:PrevGCDP(1899 - (41 + 1857), v99.ConeofCold))) then
					if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((3922 - (1222 + 671)) >= (9100 - 5579))) then
						return "comet_storm single 2";
					end
				end
				if ((v99.Flurry:IsCastable() and (v107 == (0 - 0)) and v15:DebuffDown(v99.WintersChillDebuff) and ((v14:PrevGCDP(1183 - (229 + 953), v99.Frostbolt) and (v108 >= (1777 - (1111 + 663)))) or (v14:PrevGCDP(1580 - (874 + 705), v99.Frostbolt) and v14:BuffUp(v99.BrainFreezeBuff)) or v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.GlacialSpike:IsAvailable() and (v108 == (3 + 1)) and v14:BuffDown(v99.FingersofFrostBuff)))) or ((4233 - 2196) >= (131 + 4511))) then
					if (((2399 - (642 + 37)) < (1017 + 3441)) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes))) then
						return "flurry single 4";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and not v99.GlacialSpike:InFlight() and (v107 == (0 + 0)) and (v108 == (9 - 5)) and v14:BuffUp(v99.FingersofFrostBuff)) or ((890 - (233 + 221)) > (6985 - 3964))) then
					if (((628 + 85) <= (2388 - (718 + 823))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance single 6";
					end
				end
				v146 = 1 + 0;
			end
			if (((2959 - (266 + 539)) <= (11412 - 7381)) and ((1228 - (636 + 589)) == v146)) then
				if (((10954 - 6339) == (9518 - 4903)) and v99.GlacialSpike:IsCastable() and v45 and (v108 == (4 + 1))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((1377 + 2413) == (1515 - (657 + 358)))) then
						return "glacial_spike single 20";
					end
				end
				if (((235 - 146) < (503 - 282)) and v99.IceLance:IsReady() and v47 and ((v14:BuffUp(v99.FingersofFrostBuff) and not v14:PrevGCDP(1188 - (1151 + 36), v99.GlacialSpike) and not v99.GlacialSpike:InFlight()) or v29(v107))) then
					if (((1984 + 70) >= (374 + 1047)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance single 22";
					end
				end
				if (((2066 - 1374) < (4890 - (1552 + 280))) and v33 and v99.IceNova:IsCastable() and v48 and (v104 >= (838 - (64 + 770)))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((2210 + 1044) == (3756 - 2101))) then
						return "ice_nova single 24";
					end
				end
				v146 = 1 + 3;
			end
			if ((v146 == (1245 - (157 + 1086))) or ((2593 - 1297) == (21504 - 16594))) then
				if (((5166 - 1798) == (4596 - 1228)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (829 - (599 + 220))) and (v99.FrozenOrb:CooldownRemains() > (19 - 9)) and (v107 == (1931 - (1813 + 118))) and (v103 >= (3 + 0))) then
					if (((3860 - (841 + 376)) < (5345 - 1530)) and v24(v99.ConeofCold, not v15:IsInRange(2 + 6))) then
						return "cone_of_cold single 14";
					end
				end
				if (((5221 - 3308) > (1352 - (464 + 395))) and v99.Blizzard:IsCastable() and v38 and (v103 >= (5 - 3)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v103 >= (2 + 1)))) then
					if (((5592 - (467 + 370)) > (7083 - 3655)) and v24(v101.BlizzardCursor, not v15:IsInRange(30 + 10), v14:BuffDown(v99.IceFloes))) then
						return "blizzard single 16";
					end
				end
				if (((4733 - 3352) <= (370 + 1999)) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (v107 == (0 - 0)) and (((v99.FrozenOrb:CooldownRemains() > (530 - (150 + 370))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (1292 - (74 + 1208)))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (24 - 14)))) or (v99.IcyVeins:CooldownRemains() < (94 - 74)))) then
					if (v24(v99.ShiftingPower, not v15:IsInRange(29 + 11)) or ((5233 - (14 + 376)) == (7083 - 2999))) then
						return "shifting_power single 18";
					end
				end
				v146 = 2 + 1;
			end
			if (((4102 + 567) > (347 + 16)) and ((2 - 1) == v146)) then
				if ((v99.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v99.WintersChillDebuff) > v99.RayofFrost:CastTime()) and (v107 == (1 + 0))) or ((1955 - (23 + 55)) >= (7436 - 4298))) then
					if (((3165 + 1577) >= (3257 + 369)) and v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost single 8";
					end
				end
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (7 - 2)) and ((v99.Flurry:Charges() >= (1 + 0)) or ((v107 > (901 - (652 + 249))) and (v99.GlacialSpike:CastTime() < v15:DebuffRemains(v99.WintersChillDebuff))))) or ((12149 - 7609) == (2784 - (708 + 1160)))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((3137 - 1981) > (7921 - 3576))) then
						return "glacial_spike single 10";
					end
				end
				if (((2264 - (10 + 17)) < (955 + 3294)) and v99.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v111) and (v107 == (1732 - (1400 + 332))) and (v14:BuffStackP(v99.FingersofFrostBuff) < (3 - 1)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) then
					if (v24(v101.FrozenOrbCast, not v15:IsInRange(1948 - (242 + 1666))) or ((1149 + 1534) < (9 + 14))) then
						return "frozen_orb single 12";
					end
				end
				v146 = 2 + 0;
			end
		end
	end
	local function v130()
		local v147 = 940 - (850 + 90);
		while true do
			if (((1220 - 523) <= (2216 - (360 + 1030))) and (v147 == (5 + 0))) then
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v147 = 16 - 10;
			end
			if (((1519 - 414) <= (2837 - (909 + 752))) and ((1229 - (109 + 1114)) == v147)) then
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (0 + 0);
				v147 = 249 - (6 + 236);
			end
			if (((2129 + 1250) <= (3069 + 743)) and (v147 == (0 - 0))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v147 = 1 - 0;
			end
			if (((1136 - (1076 + 57)) == v147) or ((130 + 658) >= (2305 - (579 + 110)))) then
				v51 = EpicSettings.Settings['useBlastWave'];
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v147 = 1 + 3;
			end
			if (((1640 + 214) <= (1794 + 1585)) and ((409 - (174 + 233)) == v147)) then
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v147 = 8 - 5;
			end
			if (((7983 - 3434) == (2023 + 2526)) and (v147 == (1181 - (663 + 511)))) then
				v73 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 + 0);
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v147 = 19 - 11;
			end
			if ((v147 == (1 + 0)) or ((5881 - 2859) >= (2156 + 868))) then
				v41 = EpicSettings.Settings['useFrostbolt'];
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v147 = 1 + 1;
			end
			if (((5542 - (478 + 244)) > (2715 - (440 + 77))) and (v147 == (2 + 2))) then
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v147 = 18 - 13;
			end
			if ((v147 == (1564 - (655 + 901))) or ((197 + 864) >= (3745 + 1146))) then
				v94 = EpicSettings.Settings['useSpellStealTarget'];
				v95 = EpicSettings.Settings['useSpellsWhileMoving'];
				v96 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v97 = EpicSettings.Settings['mirrorImageBeforePull'];
				v98 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
		end
	end
	local function v131()
		v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
		v84 = EpicSettings.Settings['useWeapon'];
		v80 = EpicSettings.Settings['InterruptWithStun'];
		v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
		v82 = EpicSettings.Settings['InterruptThreshold'];
		v77 = EpicSettings.Settings['DispelDebuffs'];
		v76 = EpicSettings.Settings['DispelBuffs'];
		v91 = EpicSettings.Settings['useTrinkets'];
		v90 = EpicSettings.Settings['useRacials'];
		v92 = EpicSettings.Settings['trinketsWithCD'];
		v93 = EpicSettings.Settings['racialsWithCD'];
		v86 = EpicSettings.Settings['useHealthstone'];
		v85 = EpicSettings.Settings['useHealingPotion'];
		v88 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
		v87 = EpicSettings.Settings['healingPotionHP'] or (1445 - (695 + 750));
		v89 = EpicSettings.Settings['HealingPotionName'] or "";
		v78 = EpicSettings.Settings['handleAfflicted'];
		v79 = EpicSettings.Settings['HandleIncorporeal'];
	end
	local function v132()
		local v162 = 0 - 0;
		while true do
			if (((2104 - 740) <= (17989 - 13516)) and (v162 == (351 - (285 + 66)))) then
				v130();
				v131();
				v32 = EpicSettings.Toggles['ooc'];
				v33 = EpicSettings.Toggles['aoe'];
				v162 = 2 - 1;
			end
			if ((v162 == (1312 - (682 + 628))) or ((580 + 3015) <= (302 - (176 + 123)))) then
				v106 = v14:GetEnemiesInRange(17 + 23);
				if (v33 or ((3389 + 1283) == (4121 - (239 + 30)))) then
					local v216 = 0 + 0;
					while true do
						if (((1499 + 60) == (2758 - 1199)) and ((0 - 0) == v216)) then
							v103 = v30(v15:GetEnemiesInSplashRangeCount(323 - (306 + 9)), #v106);
							v104 = v30(v15:GetEnemiesInSplashRangeCount(55 - 39), #v106);
							break;
						end
					end
				else
					v103 = 1 + 0;
					v104 = 1 + 0;
				end
				if (not v14:AffectingCombat() or ((844 + 908) <= (2253 - 1465))) then
					if ((v99.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v99.ArcaneIntellect, true) or v113.GroupBuffMissing(v99.ArcaneIntellect))) or ((5282 - (1140 + 235)) == (113 + 64))) then
						if (((3183 + 287) > (143 + 412)) and v24(v99.ArcaneIntellect)) then
							return "arcane_intellect";
						end
					end
				end
				if (v113.TargetIsValid() or v14:AffectingCombat() or ((1024 - (33 + 19)) == (233 + 412))) then
					local v217 = 0 - 0;
					while true do
						if (((1402 + 1780) >= (4147 - 2032)) and (v217 == (2 + 0))) then
							v108 = v14:BuffStackP(v99.IciclesBuff);
							v112 = v14:GCD();
							break;
						end
						if (((4582 - (586 + 103)) < (404 + 4025)) and (v217 == (2 - 1))) then
							if ((v111 == (12599 - (1309 + 179))) or ((5175 - 2308) < (830 + 1075))) then
								v111 = v10.FightRemains(v106, false);
							end
							if ((v33 and (v104 > (2 - 1))) or ((1357 + 439) >= (8606 - 4555))) then
								v107 = v117(v105);
							else
								v107 = v15:DebuffStack(v99.WintersChillDebuff);
							end
							v217 = 3 - 1;
						end
						if (((2228 - (295 + 314)) <= (9225 - 5469)) and (v217 == (1962 - (1300 + 662)))) then
							v110 = v10.BossFightRemains(nil, true);
							v111 = v110;
							v217 = 3 - 2;
						end
					end
				end
				v162 = 1758 - (1178 + 577);
			end
			if (((314 + 290) == (1785 - 1181)) and ((1408 - (851 + 554)) == v162)) then
				if (v113.TargetIsValid() or ((3966 + 518) == (2496 - 1596))) then
					if ((v77 and v35 and v99.RemoveCurse:IsAvailable()) or ((9683 - 5224) <= (1415 - (115 + 187)))) then
						local v219 = 0 + 0;
						while true do
							if (((3439 + 193) > (13390 - 9992)) and (v219 == (1161 - (160 + 1001)))) then
								if (((3572 + 510) <= (3393 + 1524)) and v16) then
									local v223 = 0 - 0;
									while true do
										if (((5190 - (237 + 121)) >= (2283 - (525 + 372))) and (v223 == (0 - 0))) then
											v31 = v122();
											if (((449 - 312) == (279 - (96 + 46))) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								if ((v17 and v17:Exists() and not v14:CanAttack(v17) and v113.UnitHasCurseDebuff(v17)) or ((2347 - (643 + 134)) >= (1564 + 2768))) then
									if (v99.RemoveCurse:IsReady() or ((9744 - 5680) <= (6753 - 4934))) then
										if (v24(v101.RemoveCurseMouseover) or ((4782 + 204) < (3088 - 1514))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					if (((9047 - 4621) > (891 - (316 + 403))) and not v14:AffectingCombat() and v32) then
						local v220 = 0 + 0;
						while true do
							if (((1611 - 1025) > (165 + 290)) and (v220 == (0 - 0))) then
								v31 = v124();
								if (((586 + 240) == (267 + 559)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					v31 = v120();
					if (v31 or ((13925 - 9906) > (21209 - 16768))) then
						return v31;
					end
					if (((4189 - 2172) < (244 + 4017)) and (v14:AffectingCombat() or v77)) then
						local v221 = v77 and v99.RemoveCurse:IsReady() and v35;
						v31 = v113.FocusUnit(v221, nil, 39 - 19, nil, 1 + 19, v99.ArcaneIntellect);
						if (((13874 - 9158) > (97 - (12 + 5))) and v31) then
							return v31;
						end
					end
					if (v78 or ((13621 - 10114) == (6980 - 3708))) then
						if (v98 or ((1861 - 985) >= (7625 - 4550))) then
							v31 = v113.HandleAfflicted(v99.RemoveCurse, v101.RemoveCurseMouseover, 7 + 23);
							if (((6325 - (1656 + 317)) > (2276 + 278)) and v31) then
								return v31;
							end
						end
					end
					if (v79 or ((3531 + 875) < (10750 - 6707))) then
						v31 = v113.HandleIncorporeal(v99.Polymorph, v101.PolymorphMouseover, 147 - 117);
						if (v31 or ((2243 - (5 + 349)) >= (16068 - 12685))) then
							return v31;
						end
					end
					if (((3163 - (266 + 1005)) <= (1802 + 932)) and v99.Spellsteal:IsAvailable() and v94 and v99.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v113.UnitHasMagicBuff(v15)) then
						if (((6561 - 4638) < (2919 - 701)) and v24(v99.Spellsteal, not v15:IsSpellInRange(v99.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					if (((3869 - (561 + 1135)) > (493 - 114)) and v14:AffectingCombat() and v113.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
						local v222 = 0 - 0;
						while true do
							if ((v222 == (1068 - (507 + 559))) or ((6501 - 3910) == (10542 - 7133))) then
								v31 = v129();
								if (((4902 - (212 + 176)) > (4229 - (250 + 655))) and v31) then
									return v31;
								end
								v222 = 8 - 5;
							end
							if ((v222 == (0 - 0)) or ((324 - 116) >= (6784 - (1869 + 87)))) then
								if ((v34 and v84 and (v100.Dreambinder:IsEquippedAndReady() or v100.Iridal:IsEquippedAndReady())) or ((5490 - 3907) > (5468 - (484 + 1417)))) then
									if (v24(v101.UseWeapon, nil) or ((2814 - 1501) == (1330 - 536))) then
										return "Using Weapon Macro";
									end
								end
								if (((3947 - (48 + 725)) > (4740 - 1838)) and v34) then
									v31 = v125();
									if (((11053 - 6933) <= (2476 + 1784)) and v31) then
										return v31;
									end
								end
								v222 = 2 - 1;
							end
							if ((v222 == (1 + 2)) or ((258 + 625) > (5631 - (152 + 701)))) then
								if (v24(v99.Pool) or ((4931 - (430 + 881)) >= (1874 + 3017))) then
									return "pool for ST()";
								end
								if (((5153 - (557 + 338)) > (277 + 660)) and v14:IsMoving() and v95) then
									local v224 = 0 - 0;
									while true do
										if ((v224 == (0 - 0)) or ((12935 - 8066) < (1952 - 1046))) then
											v31 = v126();
											if (v31 or ((2026 - (499 + 302)) > (5094 - (39 + 827)))) then
												return v31;
											end
											break;
										end
									end
								end
								break;
							end
							if (((9186 - 5858) > (4997 - 2759)) and (v222 == (3 - 2))) then
								if (((5893 - 2054) > (121 + 1284)) and v33 and (((v104 >= (20 - 13)) and not v14:HasTier(5 + 25, 2 - 0)) or ((v104 >= (107 - (103 + 1))) and v99.IceCaller:IsAvailable()))) then
									local v225 = 554 - (475 + 79);
									while true do
										if ((v225 == (0 - 0)) or ((4137 - 2844) <= (66 + 441))) then
											v31 = v127();
											if (v31 or ((2549 + 347) < (2308 - (1395 + 108)))) then
												return v31;
											end
											v225 = 2 - 1;
										end
										if (((3520 - (7 + 1197)) == (1010 + 1306)) and (v225 == (1 + 0))) then
											if (v24(v99.Pool) or ((2889 - (27 + 292)) == (4491 - 2958))) then
												return "pool for Aoe()";
											end
											break;
										end
									end
								end
								if ((v33 and (v104 == (2 - 0))) or ((3703 - 2820) == (2879 - 1419))) then
									v31 = v128();
									if (v31 or ((8796 - 4177) <= (1138 - (43 + 96)))) then
										return v31;
									end
									if (v24(v99.Pool) or ((13909 - 10499) > (9305 - 5189))) then
										return "pool for Cleave()";
									end
								end
								v222 = 2 + 0;
							end
						end
					end
				end
				break;
			end
			if (((1 + 0) == v162) or ((1784 - 881) >= (1173 + 1886))) then
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				if (v14:IsDeadOrGhost() or ((7451 - 3475) < (900 + 1957))) then
					return v31;
				end
				v105 = v15:GetEnemiesInSplashRange(1 + 4);
				v162 = 1753 - (1414 + 337);
			end
		end
	end
	local function v133()
		local v163 = 1940 - (1642 + 298);
		while true do
			if (((12851 - 7921) > (6636 - 4329)) and (v163 == (0 - 0))) then
				v114();
				v99.WintersChillDebuff:RegisterAuraTracking();
				v163 = 1 + 0;
			end
			if ((v163 == (1 + 0)) or ((5018 - (357 + 615)) < (907 + 384))) then
				v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v22.SetAPL(156 - 92, v132, v133);
end;
return v0["Epix_Mage_Frost.lua"]();

