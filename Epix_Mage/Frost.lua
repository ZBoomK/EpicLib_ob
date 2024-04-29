local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (1848 - (559 + 1288))) or ((4118 - (609 + 1322)) >= (5408 - (13 + 441)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((10155 - 6278) == (17805 - 14230))) then
			v6 = v0[v4];
			if (((27 + 680) > (2295 - 1663)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
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
	local v107 = 0 + 0;
	local v108 = 0 - 0;
	local v109 = 9 + 6;
	local v110 = 20435 - 9324;
	local v111 = 7346 + 3765;
	local v112;
	local v113 = v22.Commons.Everyone;
	local function v114()
		if (v99.RemoveCurse:IsAvailable() or ((304 + 242) >= (1929 + 755))) then
			v113.DispellableDebuffs = v113.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v99.FrozenOrb:RegisterInFlightEffect(71137 + 13584);
	v99.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v99.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v99.Frostbolt:RegisterInFlightEffect(223656 + 4941);
	v99.Frostbolt:RegisterInFlight();
	v99.Flurry:RegisterInFlightEffect(228787 - (153 + 280));
	v99.Flurry:RegisterInFlight();
	v99.GlacialSpike:RegisterInFlightEffect(660105 - 431505);
	v99.GlacialSpike:RegisterInFlight();
	v99.IceLance:RegisterInFlightEffect(205236 + 23362);
	v99.IceLance:RegisterInFlight();
	v10:RegisterForEvent(function()
		v110 = 4388 + 6723;
		v111 = 5815 + 5296;
		v107 = 0 + 0;
	end, "PLAYER_REGEN_ENABLED");
	local function v115(v134)
		if (((1062 + 403) <= (6548 - 2247)) and (v134 == nil)) then
			v134 = v15;
		end
		return not v134:IsInBossList() or (v134:Level() < (46 + 27));
	end
	local function v116()
		return v30(v14:BuffRemains(v99.FingersofFrostBuff), v15:DebuffRemains(v99.WintersChillDebuff), v15:DebuffRemains(v99.Frostbite), v15:DebuffRemains(v99.Freeze), v15:DebuffRemains(v99.FrostNova));
	end
	local function v117(v135)
		local v136 = 667 - (89 + 578);
		local v137;
		while true do
			if (((1218 + 486) > (2962 - 1537)) and (v136 == (1049 - (572 + 477)))) then
				if ((v99.WintersChillDebuff:AuraActiveCount() == (0 + 0)) or ((413 + 274) == (506 + 3728))) then
					return 86 - (84 + 2);
				end
				v137 = 0 - 0;
				v136 = 1 + 0;
			end
			if (((843 - (497 + 345)) == v136) or ((86 + 3244) < (242 + 1187))) then
				for v213, v214 in pairs(v135) do
					v137 = v137 + v214:DebuffStack(v99.WintersChillDebuff);
				end
				return v137;
			end
		end
	end
	local function v118(v138)
		return (v138:DebuffStack(v99.WintersChillDebuff));
	end
	local function v119(v139)
		return (v139:DebuffDown(v99.WintersChillDebuff));
	end
	local function v120()
		local v140 = 1333 - (605 + 728);
		while true do
			if (((819 + 328) >= (744 - 409)) and (v140 == (1 + 2))) then
				if (((12699 - 9264) > (1891 + 206)) and v99.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) then
					if (v24(v99.AlterTime) or ((10445 - 6675) >= (3052 + 989))) then
						return "alter_time defensive 7";
					end
				end
				if ((v100.Healthstone:IsReady() and v86 and (v14:HealthPercentage() <= v88)) or ((4280 - (457 + 32)) <= (684 + 927))) then
					if (v24(v101.Healthstone) or ((5980 - (832 + 570)) <= (1892 + 116))) then
						return "healthstone defensive";
					end
				end
				v140 = 2 + 2;
			end
			if (((3981 - 2856) <= (1001 + 1075)) and (v140 == (798 - (588 + 208)))) then
				if ((v99.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or ((2002 - 1259) >= (6199 - (884 + 916)))) then
					if (((2418 - 1263) < (971 + 702)) and v24(v99.MirrorImage)) then
						return "mirror_image defensive 5";
					end
				end
				if ((v99.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((2977 - (232 + 421)) <= (2467 - (1569 + 320)))) then
					if (((925 + 2842) == (716 + 3051)) and v24(v99.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v140 = 9 - 6;
			end
			if (((4694 - (316 + 289)) == (10703 - 6614)) and (v140 == (1 + 0))) then
				if (((5911 - (666 + 787)) >= (2099 - (360 + 65))) and v99.IceColdTalent:IsAvailable() and v99.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
					if (((909 + 63) <= (1672 - (79 + 175))) and v24(v99.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if ((v99.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((7785 - 2847) < (3716 + 1046))) then
					if (v24(v99.IceBlock) or ((7675 - 5171) > (8211 - 3947))) then
						return "ice_block defensive 4";
					end
				end
				v140 = 901 - (503 + 396);
			end
			if (((2334 - (92 + 89)) == (4175 - 2022)) and (v140 == (0 + 0))) then
				if ((v99.IceBarrier:IsCastable() and v63 and v14:BuffDown(v99.IceBarrier) and (v14:HealthPercentage() <= v70)) or ((301 + 206) >= (10146 - 7555))) then
					if (((613 + 3868) == (10217 - 5736)) and v24(v99.IceBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if ((v99.MassBarrier:IsCastable() and v67 and v14:BuffDown(v99.IceBarrier) and v113.AreUnitsBelowHealthPercentage(v75, 2 + 0, v99.ArcaneIntellect)) or ((1112 + 1216) < (2110 - 1417))) then
					if (((541 + 3787) == (6600 - 2272)) and v24(v99.MassBarrier)) then
						return "mass_barrier defensive 2";
					end
				end
				v140 = 1245 - (485 + 759);
			end
			if (((3674 - 2086) >= (2521 - (442 + 747))) and (v140 == (1139 - (832 + 303)))) then
				if ((v85 and (v14:HealthPercentage() <= v87)) or ((5120 - (88 + 858)) > (1295 + 2953))) then
					local v216 = 0 + 0;
					while true do
						if ((v216 == (0 + 0)) or ((5375 - (766 + 23)) <= (404 - 322))) then
							if (((5282 - 1419) == (10177 - 6314)) and (v89 == "Refreshing Healing Potion")) then
								if (v100.RefreshingHealingPotion:IsReady() or ((956 - 674) <= (1115 - (1036 + 37)))) then
									if (((3268 + 1341) >= (1491 - 725)) and v24(v101.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if ((v89 == "Dreamwalker's Healing Potion") or ((907 + 245) == (3968 - (641 + 839)))) then
								if (((4335 - (910 + 3)) > (8540 - 5190)) and v100.DreamwalkersHealingPotion:IsReady()) then
									if (((2561 - (1466 + 218)) > (173 + 203)) and v24(v101.RefreshingHealingPotion)) then
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
		end
	end
	local v121 = 1148 - (556 + 592);
	local function v122()
		if ((v99.RemoveCurse:IsReady() and (v113.UnitHasDispellableDebuffByPlayer(v16) or v113.DispellableFriendlyUnit(9 + 16) or v113.UnitHasCurseDebuff(v16))) or ((3926 - (329 + 479)) <= (2705 - (174 + 680)))) then
			local v154 = 0 - 0;
			while true do
				if ((v154 == (0 - 0)) or ((118 + 47) >= (4231 - (396 + 343)))) then
					if (((350 + 3599) < (6333 - (29 + 1448))) and (v121 == (1389 - (135 + 1254)))) then
						v121 = GetTime();
					end
					if (v113.Wait(1883 - 1383, v121) or ((19965 - 15689) < (2010 + 1006))) then
						local v222 = 1527 - (389 + 1138);
						while true do
							if (((5264 - (102 + 472)) > (3893 + 232)) and (v222 == (0 + 0))) then
								if (v24(v101.RemoveCurseFocus) or ((47 + 3) >= (2441 - (320 + 1225)))) then
									return "remove_curse dispel";
								end
								v121 = 0 - 0;
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v123()
		v31 = v113.HandleTopTrinket(v102, v34, 25 + 15, nil);
		if (v31 or ((3178 - (157 + 1307)) >= (4817 - (821 + 1038)))) then
			return v31;
		end
		v31 = v113.HandleBottomTrinket(v102, v34, 99 - 59, nil);
		if (v31 or ((164 + 1327) < (1143 - 499))) then
			return v31;
		end
	end
	local function v124()
		if (((262 + 442) < (2446 - 1459)) and v113.TargetIsValid()) then
			local v155 = 1026 - (834 + 192);
			while true do
				if (((237 + 3481) > (490 + 1416)) and (v155 == (0 + 0))) then
					if ((v99.MirrorImage:IsCastable() and v68 and v97) or ((1483 - 525) > (3939 - (300 + 4)))) then
						if (((936 + 2565) <= (11758 - 7266)) and v24(v99.MirrorImage)) then
							return "mirror_image precombat 2";
						end
					end
					if ((v99.Frostbolt:IsCastable() and not v14:IsCasting(v99.Frostbolt)) or ((3804 - (112 + 250)) < (1016 + 1532))) then
						if (((7202 - 4327) >= (839 + 625)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v125()
		if ((v96 and v99.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v99.TemporalWarp:IsAvailable() and v14:BloodlustDown() and (v14:PrevOffGCDP(1 + 0, v99.IcyVeins) or (v14:BuffUp(v99.IcyVeinsBuff) and (v111 <= (83 + 27))) or (v14:BuffUp(v99.IcyVeinsBuff) and (v111 >= (139 + 141))) or (v111 < (30 + 10)))) or ((6211 - (1001 + 413)) >= (10911 - 6018))) then
			if (v24(v99.TimeWarp, not v15:IsInRange(922 - (244 + 638))) or ((1244 - (627 + 66)) > (6161 - 4093))) then
				return "time_warp cd 2";
			end
		end
		local v141 = v113.HandleDPSPotion(v14:BuffUp(v99.IcyVeinsBuff));
		if (((2716 - (512 + 90)) > (2850 - (1665 + 241))) and v141) then
			return v141;
		end
		if ((v99.IcyVeins:IsCastable() and ((v34 and v57) or not v57) and v52 and (v83 < v111)) or ((2979 - (373 + 344)) >= (1397 + 1699))) then
			if (v24(v99.IcyVeins) or ((597 + 1658) >= (9329 - 5792))) then
				return "icy_veins cd 6";
			end
		end
		if ((v83 < v111) or ((6493 - 2656) < (2405 - (35 + 1064)))) then
			if (((2147 + 803) == (6311 - 3361)) and v91 and ((v34 and v92) or not v92)) then
				local v215 = 0 + 0;
				while true do
					if ((v215 == (1236 - (298 + 938))) or ((5982 - (233 + 1026)) < (4964 - (636 + 1030)))) then
						v31 = v123();
						if (((581 + 555) >= (151 + 3)) and v31) then
							return v31;
						end
						break;
					end
				end
			end
		end
		if ((v90 and ((v93 and v34) or not v93) and (v83 < v111)) or ((81 + 190) > (321 + 4427))) then
			local v156 = 221 - (55 + 166);
			while true do
				if (((919 + 3821) >= (317 + 2835)) and ((0 - 0) == v156)) then
					if (v99.BloodFury:IsCastable() or ((2875 - (36 + 261)) >= (5928 - 2538))) then
						if (((1409 - (34 + 1334)) <= (639 + 1022)) and v24(v99.BloodFury)) then
							return "blood_fury cd 10";
						end
					end
					if (((467 + 134) < (4843 - (1035 + 248))) and v99.Berserking:IsCastable()) then
						if (((256 - (20 + 1)) < (358 + 329)) and v24(v99.Berserking)) then
							return "berserking cd 12";
						end
					end
					v156 = 320 - (134 + 185);
				end
				if (((5682 - (549 + 584)) > (1838 - (314 + 371))) and (v156 == (6 - 4))) then
					if (v99.AncestralCall:IsCastable() or ((5642 - (478 + 490)) < (2475 + 2197))) then
						if (((4840 - (786 + 386)) < (14772 - 10211)) and v24(v99.AncestralCall)) then
							return "ancestral_call cd 18";
						end
					end
					break;
				end
				if (((1380 - (1055 + 324)) == v156) or ((1795 - (1093 + 247)) == (3204 + 401))) then
					if (v99.LightsJudgment:IsCastable() or ((281 + 2382) == (13149 - 9837))) then
						if (((14515 - 10238) <= (12733 - 8258)) and v24(v99.LightsJudgment, not v15:IsSpellInRange(v99.LightsJudgment))) then
							return "lights_judgment cd 14";
						end
					end
					if (v99.Fireblood:IsCastable() or ((2186 - 1316) == (423 + 766))) then
						if (((5982 - 4429) <= (10798 - 7665)) and v24(v99.Fireblood)) then
							return "fireblood cd 16";
						end
					end
					v156 = 2 + 0;
				end
			end
		end
	end
	local function v126()
		local v142 = 0 - 0;
		while true do
			if ((v142 == (689 - (364 + 324))) or ((6132 - 3895) >= (8424 - 4913))) then
				if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (10 + 20)) and (v104 >= (8 - 6))) or ((2119 - 795) > (9172 - 6152))) then
					if (v24(v99.ArcaneExplosion, not v15:IsInRange(1278 - (1249 + 19))) or ((2701 + 291) == (7321 - 5440))) then
						return "arcane_explosion movement";
					end
				end
				if (((4192 - (686 + 400)) > (1198 + 328)) and v99.FireBlast:IsCastable() and v40) then
					if (((3252 - (73 + 156)) < (19 + 3851)) and v24(v99.FireBlast, not v15:IsSpellInRange(v99.FireBlast))) then
						return "fire_blast movement";
					end
				end
				v142 = 813 - (721 + 90);
			end
			if (((2 + 141) > (240 - 166)) and ((470 - (224 + 246)) == v142)) then
				if (((28 - 10) < (3888 - 1776)) and v99.IceFloes:IsCastable() and v46 and v14:BuffDown(v99.IceFloes) and not v14:PrevOffGCDP(1 + 0, v99.IceFloes)) then
					if (((27 + 1070) <= (1196 + 432)) and v24(v99.IceFloes)) then
						return "ice_floes movement";
					end
				end
				if (((9205 - 4575) == (15407 - 10777)) and v99.IceNova:IsCastable() and v48) then
					if (((4053 - (203 + 310)) > (4676 - (1238 + 755))) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova movement";
					end
				end
				v142 = 1 + 0;
			end
			if (((6328 - (709 + 825)) >= (6034 - 2759)) and (v142 == (2 - 0))) then
				if (((2348 - (196 + 668)) == (5859 - 4375)) and v99.IceLance:IsCastable() and v47) then
					if (((2966 - 1534) < (4388 - (171 + 662))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance movement";
					end
				end
				break;
			end
		end
	end
	local function v127()
		if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v14:PrevGCDP(94 - (4 + 89), v99.CometStorm) or (v14:PrevGCDP(3 - 2, v99.FrozenOrb) and not v99.CometStorm:IsAvailable()))) or ((388 + 677) > (15715 - 12137))) then
			if (v24(v99.ConeofCold, not v15:IsInRange(5 + 7)) or ((6281 - (35 + 1451)) < (2860 - (28 + 1425)))) then
				return "cone_of_cold aoe 2";
			end
		end
		if (((3846 - (941 + 1052)) < (4615 + 198)) and v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (not v14:PrevGCDP(1515 - (822 + 692), v99.GlacialSpike) or not v115())) then
			if (v24(v101.FrozenOrbCast, not v15:IsInRange(57 - 17)) or ((1329 + 1492) < (2728 - (45 + 252)))) then
				return "frozen_orb aoe 4";
			end
		end
		if ((v99.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1 + 0, v99.GlacialSpike) or not v115())) or ((990 + 1884) < (5307 - 3126))) then
			if (v24(v101.BlizzardCursor, not v15:IsInRange(473 - (114 + 319)), v14:BuffDown(v99.IceFloes)) or ((3860 - 1171) <= (438 - 95))) then
				return "blizzard aoe 6";
			end
		end
		if ((v99.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v111) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike) and (not v99.ColdestSnap:IsAvailable() or (v99.ConeofCold:CooldownUp() and (v99.FrozenOrb:CooldownRemains() > (37 - 12))) or (v99.ConeofCold:CooldownRemains() > (41 - 21)))) or ((3832 - (556 + 1407)) == (3215 - (741 + 465)))) then
			if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((4011 - (170 + 295)) < (1224 + 1098))) then
				return "comet_storm aoe 8";
			end
		end
		if ((v18:IsActive() and v44 and v99.Freeze:IsReady() and v115() and (v116() == (0 + 0)) and ((not v99.GlacialSpike:IsAvailable() and not v99.Snowstorm:IsAvailable()) or v14:PrevGCDP(2 - 1, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109)))) or ((1726 + 356) == (3061 + 1712))) then
			if (((1837 + 1407) > (2285 - (957 + 273))) and v24(v101.FreezePet, not v15:IsSpellInRange(v99.Freeze))) then
				return "freeze aoe 10";
			end
		end
		if ((v99.IceNova:IsCastable() and v48 and v115() and not v14:PrevOffGCDP(1 + 0, v99.Freeze) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (3 - 2))))) or ((8730 - 5417) <= (5430 - 3652))) then
			if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((7036 - 5615) >= (3884 - (389 + 1391)))) then
				return "ice_nova aoe 11";
			end
		end
		if (((1137 + 675) <= (339 + 2910)) and v99.FrostNova:IsCastable() and v42 and v115() and not v14:PrevOffGCDP(2 - 1, v99.Freeze) and ((v14:PrevGCDP(952 - (783 + 168), v99.GlacialSpike) and (v107 == (0 - 0))) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (1 + 0))))) then
			if (((1934 - (309 + 2)) <= (6009 - 4052)) and v24(v99.FrostNova)) then
				return "frost_nova aoe 12";
			end
		end
		if (((5624 - (1090 + 122)) == (1431 + 2981)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and (v14:BuffStackP(v99.SnowstormBuff) == v109)) then
			if (((5877 - 4127) >= (577 + 265)) and v24(v99.ConeofCold, not v15:IsInRange(1126 - (628 + 490)))) then
				return "cone_of_cold aoe 14";
			end
		end
		if (((784 + 3588) > (4580 - 2730)) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111)) then
			if (((1060 - 828) < (1595 - (431 + 343))) and v24(v99.ShiftingPower, not v15:IsInRange(80 - 40), true)) then
				return "shifting_power aoe 16";
			end
		end
		if (((1498 - 980) < (713 + 189)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (1 + 4)) and (v99.Blizzard:CooldownRemains() > v112)) then
			if (((4689 - (556 + 1139)) > (873 - (6 + 9))) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
				return "glacial_spike aoe 18";
			end
		end
		if ((v99.Flurry:IsCastable() and v43 and not v115() and (v107 == (0 + 0)) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.Flurry:ChargesFractional() > (170.8 - (28 + 141))))) or ((1455 + 2300) <= (1129 - 214))) then
			if (((2795 + 1151) > (5060 - (486 + 831))) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes))) then
				return "flurry aoe 20";
			end
		end
		if ((v99.Flurry:IsCastable() and v43 and (v107 == (0 - 0)) and (v14:BuffUp(v99.BrainFreezeBuff) or v14:BuffUp(v99.FingersofFrostBuff))) or ((4700 - 3365) >= (625 + 2681))) then
			if (((15316 - 10472) > (3516 - (668 + 595))) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes))) then
				return "flurry aoe 21";
			end
		end
		if (((407 + 45) == (92 + 360)) and v99.IceLance:IsCastable() and v47 and (v14:BuffUp(v99.FingersofFrostBuff) or (v116() > v99.IceLance:TravelTime()) or v29(v107))) then
			if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((12427 - 7870) < (2377 - (23 + 267)))) then
				return "ice_lance aoe 22";
			end
		end
		if (((5818 - (1129 + 815)) == (4261 - (371 + 16))) and v99.IceNova:IsCastable() and v48 and (v103 >= (1754 - (1326 + 424))) and ((not v99.Snowstorm:IsAvailable() and not v99.GlacialSpike:IsAvailable()) or not v115())) then
			if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((3670 - 1732) > (18033 - 13098))) then
				return "ice_nova aoe 23";
			end
		end
		if ((v99.DragonsBreath:IsCastable() and v39 and (v104 >= (125 - (88 + 30)))) or ((5026 - (720 + 51)) < (7614 - 4191))) then
			if (((3230 - (421 + 1355)) <= (4109 - 1618)) and v24(v99.DragonsBreath, not v15:IsInRange(5 + 5))) then
				return "dragons_breath aoe 26";
			end
		end
		if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (1113 - (286 + 797))) and (v104 >= (25 - 18))) or ((6885 - 2728) <= (3242 - (397 + 42)))) then
			if (((1516 + 3337) >= (3782 - (24 + 776))) and v24(v99.ArcaneExplosion, not v15:IsInRange(12 - 4))) then
				return "arcane_explosion aoe 28";
			end
		end
		if (((4919 - (222 + 563)) > (7396 - 4039)) and v99.Frostbolt:IsCastable() and v41) then
			if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((2461 + 956) < (2724 - (23 + 167)))) then
				return "frostbolt aoe 32";
			end
		end
		if ((v14:IsMoving() and v95) or ((4520 - (690 + 1108)) <= (60 + 104))) then
			v31 = v126();
			if (v31 or ((1987 + 421) < (2957 - (40 + 808)))) then
				return v31;
			end
		end
	end
	local function v128()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (7 - 5)) or ((32 + 1) == (770 + 685))) then
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (6 + 4)) and (v99.FrozenOrb:CooldownRemains() > (581 - (47 + 524))) and (v107 == (0 + 0)) and (v104 >= (8 - 5))) or ((662 - 219) >= (9156 - 5141))) then
					if (((5108 - (1165 + 561)) > (5 + 161)) and v24(v99.ConeofCold, not v15:IsInRange(37 - 25))) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v104 >= (1 + 1)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v104 >= (482 - (341 + 138))))) or ((76 + 204) == (6312 - 3253))) then
					if (((2207 - (89 + 237)) > (4159 - 2866)) and v24(v101.BlizzardCursor, not v15:IsSpellInRange(v99.Blizzard), v14:BuffDown(v99.IceFloes))) then
						return "blizzard cleave 16";
					end
				end
				if (((4961 - 2604) == (3238 - (581 + 300))) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (((v99.FrozenOrb:CooldownRemains() > (1230 - (855 + 365))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (23 - 13))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (4 + 6)))) or (v99.IcyVeins:CooldownRemains() < (1255 - (1030 + 205))))) then
					if (((116 + 7) == (115 + 8)) and v24(v99.ShiftingPower, not v15:IsSpellInRange(v99.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				v143 = 289 - (156 + 130);
			end
			if ((v143 == (6 - 3)) or ((1779 - 723) >= (6946 - 3554))) then
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (2 + 3))) or ((631 + 450) < (1144 - (10 + 59)))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((297 + 752) >= (21826 - 17394))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and ((v14:BuffUpP(v99.FingersofFrostBuff) and not v14:PrevGCDP(1164 - (671 + 492), v99.GlacialSpike)) or (v107 > (0 + 0)))) or ((5983 - (369 + 846)) <= (224 + 622))) then
					if (v113.CastTargetIf(v99.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v99.IceLance)) or ((2866 + 492) <= (3365 - (1036 + 909)))) then
						return "ice_lance cleave 22";
					end
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((2973 + 766) <= (5045 - 2040))) then
						return "ice_lance cleave 22";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v104 >= (207 - (11 + 192)))) or ((839 + 820) >= (2309 - (135 + 40)))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((7898 - 4638) < (1420 + 935))) then
						return "ice_nova cleave 24";
					end
				end
				v143 = 8 - 4;
			end
			if ((v143 == (1 - 0)) or ((845 - (50 + 126)) == (11758 - 7535))) then
				if ((v99.RayofFrost:IsCastable() and (v107 == (1 + 0)) and v49) or ((3105 - (1233 + 180)) < (1557 - (522 + 447)))) then
					local v217 = 1421 - (107 + 1314);
					while true do
						if (((0 + 0) == v217) or ((14616 - 9819) < (1551 + 2100))) then
							if (v113.CastTargetIf(v99.RayofFrost, v105, "max", v118, nil, not v15:IsSpellInRange(v99.RayofFrost)) or ((8294 - 4117) > (19189 - 14339))) then
								return "ray_of_frost cleave 8";
							end
							if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((2310 - (716 + 1194)) > (19 + 1092))) then
								return "ray_of_frost cleave 8";
							end
							break;
						end
					end
				end
				if (((327 + 2724) > (1508 - (74 + 429))) and v99.GlacialSpike:IsReady() and v45 and (v108 == (9 - 4)) and (v99.Flurry:CooldownUp() or (v107 > (0 + 0)))) then
					if (((8453 - 4760) <= (3101 + 1281)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
						return "glacial_spike cleave 10";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (v14:BuffStackP(v99.FingersofFrostBuff) < (5 - 3)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((8114 - 4832) > (4533 - (279 + 154)))) then
					if (v24(v101.FrozenOrbCast, not v15:IsSpellInRange(v99.FrozenOrb)) or ((4358 - (454 + 324)) < (2238 + 606))) then
						return "frozen_orb cleave 12";
					end
				end
				v143 = 19 - (12 + 5);
			end
			if (((48 + 41) < (11440 - 6950)) and (v143 == (2 + 2))) then
				if ((v99.Frostbolt:IsCastable() and v41) or ((6076 - (277 + 816)) < (7725 - 5917))) then
					if (((5012 - (1058 + 125)) > (707 + 3062)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes))) then
						return "frostbolt cleave 26";
					end
				end
				if (((2460 - (815 + 160)) <= (12459 - 9555)) and v14:IsMoving() and v95) then
					local v218 = 0 - 0;
					while true do
						if (((1019 + 3250) == (12478 - 8209)) and ((1898 - (41 + 1857)) == v218)) then
							v31 = v126();
							if (((2280 - (1222 + 671)) <= (7190 - 4408)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v143 == (0 - 0)) or ((3081 - (229 + 953)) <= (2691 - (1111 + 663)))) then
				if ((v99.CometStorm:IsCastable() and (v14:PrevGCDP(1580 - (874 + 705), v99.Flurry) or v14:PrevGCDP(1 + 0, v99.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v111)) or ((2942 + 1370) <= (1820 - 944))) then
					if (((63 + 2169) <= (3275 - (642 + 37))) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm cleave 2";
					end
				end
				if (((478 + 1617) < (590 + 3096)) and v99.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(2 - 1, v99.Frostbolt) and (v108 >= (457 - (233 + 221)))) or v14:PrevGCDP(2 - 1, v99.GlacialSpike) or ((v108 >= (3 + 0)) and (v108 < (1546 - (718 + 823))) and (v99.Flurry:ChargesFractional() == (2 + 0))))) then
					local v219 = 805 - (266 + 539);
					while true do
						if ((v219 == (0 - 0)) or ((2820 - (636 + 589)) >= (10619 - 6145))) then
							if (v113.CastTargetIf(v99.Flurry, v105, "min", v118, nil, not v15:IsSpellInRange(v99.Flurry)) or ((9526 - 4907) < (2284 + 598))) then
								return "flurry cleave 4";
							end
							if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((107 + 187) >= (5846 - (657 + 358)))) then
								return "flurry cleave 4";
							end
							break;
						end
					end
				end
				if (((5372 - 3343) <= (7025 - 3941)) and v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and (v99.WintersChillDebuff:AuraActiveCount() == (1187 - (1151 + 36))) and (v108 == (4 + 0)) and v14:BuffUp(v99.FingersofFrostBuff)) then
					local v220 = 0 + 0;
					while true do
						if ((v220 == (0 - 0)) or ((3869 - (1552 + 280)) == (3254 - (64 + 770)))) then
							if (((3027 + 1431) > (8862 - 4958)) and v113.CastTargetIf(v99.IceLance, v105, "max", v119, nil, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 6";
							end
							if (((78 + 358) >= (1366 - (157 + 1086))) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 6";
							end
							break;
						end
					end
				end
				v143 = 1 - 0;
			end
		end
	end
	local function v129()
		local v144 = 0 - 0;
		while true do
			if (((766 - 266) < (2477 - 661)) and (v144 == (821 - (599 + 220)))) then
				if (((7117 - 3543) == (5505 - (1813 + 118))) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (8 + 2)) and (v99.FrozenOrb:CooldownRemains() > (1227 - (841 + 376))) and (v107 == (0 - 0)) and (v103 >= (1 + 2))) then
					if (((603 - 382) < (1249 - (464 + 395))) and v24(v99.ConeofCold, not v15:IsInRange(20 - 12))) then
						return "cone_of_cold single 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v103 >= (1 + 1)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v103 >= (840 - (467 + 370))))) or ((4572 - 2359) <= (1044 + 377))) then
					if (((10482 - 7424) < (759 + 4101)) and v24(v101.BlizzardCursor, not v15:IsInRange(93 - 53), v14:BuffDown(v99.IceFloes))) then
						return "blizzard single 16";
					end
				end
				if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (v107 == (520 - (150 + 370))) and (((v99.FrozenOrb:CooldownRemains() > (1292 - (74 + 1208))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (24 - 14))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (47 - 37)))) or (v99.IcyVeins:CooldownRemains() < (15 + 5)))) or ((1686 - (14 + 376)) >= (7711 - 3265))) then
					if (v24(v99.ShiftingPower, not v15:IsInRange(26 + 14)) or ((1224 + 169) > (4282 + 207))) then
						return "shifting_power single 18";
					end
				end
				v144 = 8 - 5;
			end
			if ((v144 == (0 + 0)) or ((4502 - (23 + 55)) < (63 - 36))) then
				if ((v99.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v111) and (v14:PrevGCDP(1 + 0, v99.Flurry) or v14:PrevGCDP(1 + 0, v99.ConeofCold))) or ((3096 - 1099) > (1201 + 2614))) then
					if (((4366 - (652 + 249)) > (5119 - 3206)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm single 2";
					end
				end
				if (((2601 - (708 + 1160)) < (4937 - 3118)) and v99.Flurry:IsCastable() and (v107 == (0 - 0)) and v15:DebuffDown(v99.WintersChillDebuff) and ((v14:PrevGCDP(28 - (10 + 17), v99.Frostbolt) and (v108 >= (1 + 2))) or (v14:PrevGCDP(1733 - (1400 + 332), v99.Frostbolt) and v14:BuffUp(v99.BrainFreezeBuff)) or v14:PrevGCDP(1 - 0, v99.GlacialSpike) or (v99.GlacialSpike:IsAvailable() and (v108 == (1912 - (242 + 1666))) and v14:BuffDown(v99.FingersofFrostBuff)))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((1881 + 2514) == (1743 + 3012))) then
						return "flurry single 4";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and not v99.GlacialSpike:InFlight() and (v107 == (0 + 0)) and (v108 == (944 - (850 + 90))) and v14:BuffUp(v99.FingersofFrostBuff)) or ((6642 - 2849) < (3759 - (360 + 1030)))) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((3615 + 469) == (747 - 482))) then
						return "ice_lance single 6";
					end
				end
				v144 = 1 - 0;
			end
			if (((6019 - (909 + 752)) == (5581 - (109 + 1114))) and (v144 == (1 - 0))) then
				if ((v99.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v99.WintersChillDebuff) > v99.RayofFrost:CastTime()) and (v107 == (1 + 0))) or ((3380 - (6 + 236)) < (626 + 367))) then
					if (((2681 + 649) > (5478 - 3155)) and v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost single 8";
					end
				end
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (8 - 3)) and ((v99.Flurry:Charges() >= (1134 - (1076 + 57))) or ((v107 > (0 + 0)) and (v99.GlacialSpike:CastTime() < v15:DebuffRemains(v99.WintersChillDebuff))))) or ((4315 - (579 + 110)) == (315 + 3674))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((810 + 106) == (1418 + 1253))) then
						return "glacial_spike single 10";
					end
				end
				if (((679 - (174 + 233)) == (759 - 487)) and v99.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v111) and (v107 == (0 - 0)) and (v14:BuffStackP(v99.FingersofFrostBuff) < (1 + 1)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) then
					if (((5423 - (663 + 511)) <= (4317 + 522)) and v24(v101.FrozenOrbCast, not v15:IsInRange(9 + 31))) then
						return "frozen_orb single 12";
					end
				end
				v144 = 5 - 3;
			end
			if (((1682 + 1095) < (7533 - 4333)) and (v144 == (9 - 5))) then
				if (((46 + 49) < (3808 - 1851)) and v90 and ((v93 and v34) or not v93)) then
					if (((589 + 237) < (157 + 1560)) and v99.BagofTricks:IsCastable()) then
						if (((2148 - (478 + 244)) >= (1622 - (440 + 77))) and v24(v99.BagofTricks, not v15:IsSpellInRange(v99.BagofTricks))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((1253 + 1501) <= (12367 - 8988)) and v99.Frostbolt:IsCastable() and v41) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((5483 - (655 + 901)) == (263 + 1150))) then
						return "frostbolt single 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((884 + 270) <= (533 + 255))) then
					local v221 = 0 - 0;
					while true do
						if ((v221 == (1445 - (695 + 750))) or ((5610 - 3967) > (5214 - 1835))) then
							v31 = v126();
							if (v31 or ((11272 - 8469) > (4900 - (285 + 66)))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v144 == (6 - 3)) or ((1530 - (682 + 628)) >= (488 + 2534))) then
				if (((3121 - (176 + 123)) == (1181 + 1641)) and v99.GlacialSpike:IsCastable() and v45 and (v108 == (4 + 1))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((1330 - (239 + 30)) == (505 + 1352))) then
						return "glacial_spike single 20";
					end
				end
				if (((2653 + 107) > (2414 - 1050)) and v99.IceLance:IsReady() and v47 and ((v14:BuffUp(v99.FingersofFrostBuff) and not v14:PrevGCDP(2 - 1, v99.GlacialSpike) and not v99.GlacialSpike:InFlight()) or v29(v107))) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((5217 - (306 + 9)) <= (12545 - 8950))) then
						return "ice_lance single 22";
					end
				end
				if ((v33 and v99.IceNova:IsCastable() and v48 and (v104 >= (1 + 3))) or ((2364 + 1488) == (142 + 151))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((4457 - 2898) == (5963 - (1140 + 235)))) then
						return "ice_nova single 24";
					end
				end
				v144 = 3 + 1;
			end
		end
	end
	local function v130()
		local v145 = 0 + 0;
		while true do
			if (((2 + 2) == v145) or ((4536 - (33 + 19)) == (285 + 503))) then
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v145 = 14 - 9;
			end
			if (((2013 + 2555) >= (7661 - 3754)) and (v145 == (2 + 0))) then
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v145 = 692 - (586 + 103);
			end
			if (((114 + 1132) < (10682 - 7212)) and (v145 == (1488 - (1309 + 179)))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v145 = 1 - 0;
			end
			if (((1771 + 2297) >= (2610 - 1638)) and (v145 == (4 + 1))) then
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v145 = 12 - 6;
			end
			if (((982 - 489) < (4502 - (295 + 314))) and (v145 == (6 - 3))) then
				v51 = EpicSettings.Settings['useBlastWave'];
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v145 = 1966 - (1300 + 662);
			end
			if ((v145 == (24 - 16)) or ((3228 - (1178 + 577)) >= (1731 + 1601))) then
				v94 = EpicSettings.Settings['useSpellStealTarget'];
				v95 = EpicSettings.Settings['useSpellsWhileMoving'];
				v96 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v97 = EpicSettings.Settings['mirrorImageBeforePull'];
				v98 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((17 - 11) == v145) or ((5456 - (851 + 554)) <= (1024 + 133))) then
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 - 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (0 - 0);
				v145 = 309 - (115 + 187);
			end
			if (((463 + 141) < (2728 + 153)) and (v145 == (3 - 2))) then
				v41 = EpicSettings.Settings['useFrostbolt'];
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v145 = 1163 - (160 + 1001);
			end
			if ((v145 == (7 + 0)) or ((621 + 279) == (6912 - 3535))) then
				v73 = EpicSettings.Settings['iceColdHP'] or (358 - (237 + 121));
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (897 - (525 + 372));
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 - 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (142 - (96 + 46));
				v145 = 785 - (643 + 134);
			end
		end
	end
	local function v131()
		local v146 = 0 + 0;
		while true do
			if (((10691 - 6232) > (2194 - 1603)) and ((3 + 0) == v146)) then
				v92 = EpicSettings.Settings['trinketsWithCD'];
				v93 = EpicSettings.Settings['racialsWithCD'];
				v86 = EpicSettings.Settings['useHealthstone'];
				v146 = 7 - 3;
			end
			if (((6945 - 3547) >= (3114 - (316 + 403))) and ((0 + 0) == v146)) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v84 = EpicSettings.Settings['useWeapon'];
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v146 = 1 + 0;
			end
			if ((v146 == (9 - 5)) or ((1547 + 636) >= (911 + 1913))) then
				v85 = EpicSettings.Settings['useHealingPotion'];
				v88 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v87 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v146 = 10 - 5;
			end
			if (((111 + 1825) == (3811 - 1875)) and (v146 == (1 + 0))) then
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v146 = 5 - 3;
			end
			if ((v146 == (19 - (12 + 5))) or ((18767 - 13935) < (9201 - 4888))) then
				v76 = EpicSettings.Settings['DispelBuffs'];
				v91 = EpicSettings.Settings['useTrinkets'];
				v90 = EpicSettings.Settings['useRacials'];
				v146 = 6 - 3;
			end
			if (((10137 - 6049) > (787 + 3087)) and (v146 == (1978 - (1656 + 317)))) then
				v89 = EpicSettings.Settings['HealingPotionName'] or "";
				v78 = EpicSettings.Settings['handleAfflicted'];
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v132()
		v130();
		v131();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		if (((3861 + 471) == (3472 + 860)) and v14:IsDeadOrGhost()) then
			return v31;
		end
		v105 = v15:GetEnemiesInSplashRange(13 - 8);
		v106 = v14:GetEnemiesInRange(196 - 156);
		if (((4353 - (5 + 349)) >= (13774 - 10874)) and v33) then
			local v157 = 1271 - (266 + 1005);
			while true do
				if ((v157 == (0 + 0)) or ((8615 - 6090) > (5349 - 1285))) then
					v103 = v30(v15:GetEnemiesInSplashRangeCount(1704 - (561 + 1135)), #v106);
					v104 = v30(v15:GetEnemiesInSplashRangeCount(20 - 4), #v106);
					break;
				end
			end
		else
			local v158 = 0 - 0;
			while true do
				if (((5437 - (507 + 559)) == (10968 - 6597)) and (v158 == (0 - 0))) then
					v103 = 389 - (212 + 176);
					v104 = 906 - (250 + 655);
					break;
				end
			end
		end
		if (not v14:AffectingCombat() or ((725 - 459) > (8712 - 3726))) then
			if (((3114 - 1123) >= (2881 - (1869 + 87))) and v99.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v99.ArcaneIntellect, true) or v113.GroupBuffMissing(v99.ArcaneIntellect))) then
				if (((1578 - 1123) < (3954 - (484 + 1417))) and v24(v99.ArcaneIntellect)) then
					return "arcane_intellect";
				end
			end
		end
		if (v113.TargetIsValid() or v14:AffectingCombat() or ((1770 - 944) == (8129 - 3278))) then
			local v159 = 773 - (48 + 725);
			while true do
				if (((298 - 115) == (490 - 307)) and ((0 + 0) == v159)) then
					v110 = v10.BossFightRemains(nil, true);
					v111 = v110;
					v159 = 2 - 1;
				end
				if (((325 + 834) <= (522 + 1266)) and (v159 == (855 - (152 + 701)))) then
					v108 = v14:BuffStackP(v99.IciclesBuff);
					v112 = v14:GCD();
					break;
				end
				if ((v159 == (1312 - (430 + 881))) or ((1344 + 2163) > (5213 - (557 + 338)))) then
					if ((v111 == (3285 + 7826)) or ((8665 - 5590) <= (10382 - 7417))) then
						v111 = v10.FightRemains(v106, false);
					end
					if (((3626 - 2261) <= (4333 - 2322)) and v33 and (v104 > (802 - (499 + 302)))) then
						v107 = v117(v105);
					else
						v107 = v15:DebuffStack(v99.WintersChillDebuff);
					end
					v159 = 868 - (39 + 827);
				end
			end
		end
		if (v113.TargetIsValid() or ((7662 - 4886) > (7984 - 4409))) then
			local v160 = 0 - 0;
			while true do
				if ((v160 == (0 - 0)) or ((219 + 2335) == (14060 - 9256))) then
					if (((413 + 2164) == (4077 - 1500)) and v77 and v35 and v99.RemoveCurse:IsAvailable()) then
						if (v16 or ((110 - (103 + 1)) >= (2443 - (475 + 79)))) then
							local v228 = 0 - 0;
							while true do
								if (((1619 - 1113) <= (245 + 1647)) and ((0 + 0) == v228)) then
									v31 = v122();
									if (v31 or ((3511 - (1395 + 108)) > (6454 - 4236))) then
										return v31;
									end
									break;
								end
							end
						end
						if (((1583 - (7 + 1197)) <= (1809 + 2338)) and v17 and v17:Exists() and not v14:CanAttack(v17) and v113.UnitHasCurseDebuff(v17)) then
							if (v99.RemoveCurse:IsReady() or ((1576 + 2938) <= (1328 - (27 + 292)))) then
								if (v24(v101.RemoveCurseMouseover) or ((10244 - 6748) == (1519 - 327))) then
									return "remove_curse dispel";
								end
							end
						end
					end
					if ((not v14:AffectingCombat() and v32) or ((872 - 664) == (5834 - 2875))) then
						local v223 = 0 - 0;
						while true do
							if (((4416 - (43 + 96)) >= (5355 - 4042)) and (v223 == (0 - 0))) then
								v31 = v124();
								if (((2147 + 440) < (897 + 2277)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					v160 = 1 - 0;
				end
				if ((v160 == (1 + 1)) or ((7721 - 3601) <= (692 + 1506))) then
					if (v14:AffectingCombat() or v77 or ((118 + 1478) == (2609 - (1414 + 337)))) then
						local v224 = 1940 - (1642 + 298);
						local v225;
						while true do
							if (((8394 - 5174) == (9263 - 6043)) and ((2 - 1) == v224)) then
								if (v31 or ((462 + 940) > (2817 + 803))) then
									return v31;
								end
								break;
							end
							if (((3546 - (357 + 615)) == (1807 + 767)) and (v224 == (0 - 0))) then
								v225 = v77 and v99.RemoveCurse:IsReady() and v35;
								v31 = v113.FocusUnit(v225, nil, 18 + 2, nil, 42 - 22, v99.ArcaneIntellect);
								v224 = 1 + 0;
							end
						end
					end
					if (((123 + 1675) < (1733 + 1024)) and v78) then
						if (v98 or ((1678 - (384 + 917)) > (3301 - (128 + 569)))) then
							v31 = v113.HandleAfflicted(v99.RemoveCurse, v101.RemoveCurseMouseover, 1573 - (1407 + 136));
							if (((2455 - (687 + 1200)) < (2621 - (556 + 1154))) and v31) then
								return v31;
							end
						end
					end
					v160 = 10 - 7;
				end
				if (((3380 - (9 + 86)) < (4649 - (275 + 146))) and ((1 + 0) == v160)) then
					v31 = v120();
					if (((3980 - (29 + 35)) > (14749 - 11421)) and v31) then
						return v31;
					end
					v160 = 5 - 3;
				end
				if (((11036 - 8536) < (2501 + 1338)) and (v160 == (1015 - (53 + 959)))) then
					if (((915 - (312 + 96)) == (879 - 372)) and v79) then
						local v226 = 285 - (147 + 138);
						while true do
							if (((1139 - (813 + 86)) <= (2861 + 304)) and (v226 == (0 - 0))) then
								v31 = v113.HandleIncorporeal(v99.Polymorph, v101.PolymorphMouseover, 522 - (18 + 474));
								if (((282 + 552) >= (2627 - 1822)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					if ((v99.Spellsteal:IsAvailable() and v94 and v99.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v113.UnitHasMagicBuff(v15)) or ((4898 - (860 + 226)) < (2619 - (121 + 182)))) then
						if (v24(v99.Spellsteal, not v15:IsSpellInRange(v99.Spellsteal)) or ((327 + 2325) <= (2773 - (988 + 252)))) then
							return "spellsteal damage";
						end
					end
					v160 = 1 + 3;
				end
				if ((v160 == (2 + 2)) or ((5568 - (49 + 1921)) < (2350 - (223 + 667)))) then
					if ((v14:AffectingCombat() and v113.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((4168 - (51 + 1)) < (2051 - 859))) then
						local v227 = 0 - 0;
						while true do
							if ((v227 == (1127 - (146 + 979))) or ((954 + 2423) <= (1508 - (311 + 294)))) then
								v31 = v129();
								if (((11087 - 7111) >= (186 + 253)) and v31) then
									return v31;
								end
								v227 = 1446 - (496 + 947);
							end
							if (((5110 - (1233 + 125)) == (1523 + 2229)) and (v227 == (1 + 0))) then
								if (((769 + 3277) > (4340 - (963 + 682))) and v33 and (((v104 >= (6 + 1)) and not v14:HasTier(1534 - (504 + 1000), 2 + 0)) or ((v104 >= (3 + 0)) and v99.IceCaller:IsAvailable()))) then
									local v229 = 0 + 0;
									while true do
										if ((v229 == (0 - 0)) or ((3029 + 516) == (1860 + 1337))) then
											v31 = v127();
											if (((2576 - (156 + 26)) > (215 + 158)) and v31) then
												return v31;
											end
											v229 = 1 - 0;
										end
										if (((4319 - (149 + 15)) <= (5192 - (890 + 70))) and (v229 == (118 - (39 + 78)))) then
											if (v24(v99.Pool) or ((4063 - (14 + 468)) == (7636 - 4163))) then
												return "pool for Aoe()";
											end
											break;
										end
									end
								end
								if (((13961 - 8966) > (1728 + 1620)) and v33 and (v104 == (2 + 0))) then
									local v230 = 0 + 0;
									while true do
										if ((v230 == (1 + 0)) or ((198 + 556) > (7127 - 3403))) then
											if (((215 + 2) >= (200 - 143)) and v24(v99.Pool)) then
												return "pool for Cleave()";
											end
											break;
										end
										if ((v230 == (0 + 0)) or ((2121 - (12 + 39)) >= (3756 + 281))) then
											v31 = v128();
											if (((8372 - 5667) == (9633 - 6928)) and v31) then
												return v31;
											end
											v230 = 1 + 0;
										end
									end
								end
								v227 = 2 + 0;
							end
							if (((154 - 93) == (41 + 20)) and (v227 == (14 - 11))) then
								if (v24(v99.Pool) or ((2409 - (1596 + 114)) >= (3383 - 2087))) then
									return "pool for ST()";
								end
								if ((v14:IsMoving() and v95) or ((2496 - (164 + 549)) >= (5054 - (1059 + 379)))) then
									local v231 = 0 - 0;
									while true do
										if (((0 + 0) == v231) or ((660 + 3253) > (4919 - (145 + 247)))) then
											v31 = v126();
											if (((3591 + 785) > (378 + 439)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								break;
							end
							if (((14411 - 9550) > (159 + 665)) and (v227 == (0 + 0))) then
								if ((v34 and v84 and (v100.Dreambinder:IsEquippedAndReady() or v100.Iridal:IsEquippedAndReady())) or ((2244 - 861) >= (2851 - (254 + 466)))) then
									if (v24(v101.UseWeapon, nil) or ((2436 - (544 + 16)) >= (8075 - 5534))) then
										return "Using Weapon Macro";
									end
								end
								if (((2410 - (294 + 334)) <= (4025 - (236 + 17))) and v34) then
									local v232 = 0 + 0;
									while true do
										if ((v232 == (0 + 0)) or ((17700 - 13000) < (3849 - 3036))) then
											v31 = v125();
											if (((1648 + 1551) < (3336 + 714)) and v31) then
												return v31;
											end
											break;
										end
									end
								end
								v227 = 795 - (413 + 381);
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v133()
		v114();
		v99.WintersChillDebuff:RegisterAuraTracking();
		v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(3 + 61, v132, v133);
end;
return v0["Epix_Mage_Frost.lua"]();

