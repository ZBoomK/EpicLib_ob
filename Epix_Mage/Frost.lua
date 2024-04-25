local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((2803 - (466 + 145)) > (2856 + 911))) then
			v6 = v0[v4];
			if (not v6 or ((1738 - (255 + 896)) > (12533 - 8444))) then
				return v1(v4, ...);
			end
			v5 = 1 - 0;
		end
		if ((v5 == (900 - (503 + 396))) or ((4639 - (92 + 89)) < (1804 - 874))) then
			return v6(...);
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
	local v108 = 0 + 0;
	local v109 = 58 - 43;
	local v110 = 1520 + 9591;
	local v111 = 25334 - 14223;
	local v112;
	local v113 = v22.Commons.Everyone;
	local function v114()
		if (((578 + 84) <= (465 + 507)) and v99.RemoveCurse:IsAvailable()) then
			v113.DispellableDebuffs = v113.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v114();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v99.FrozenOrb:RegisterInFlightEffect(258032 - 173311);
	v99.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v99.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v99.Frostbolt:RegisterInFlightEffect(28532 + 200065);
	v99.Frostbolt:RegisterInFlight();
	v99.Flurry:RegisterInFlightEffect(348242 - 119888);
	v99.Flurry:RegisterInFlight();
	v99.IceLance:RegisterInFlightEffect(229842 - (485 + 759));
	v99.IceLance:RegisterInFlight();
	v99.GlacialSpike:RegisterInFlightEffect(528953 - 300353);
	v99.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		v110 = 12300 - (442 + 747);
		v111 = 12246 - (832 + 303);
		v107 = 946 - (88 + 858);
	end, "PLAYER_REGEN_ENABLED");
	local function v115(v133)
		local v134 = 0 + 0;
		while true do
			if (((3617 + 753) == (180 + 4190)) and (v134 == (789 - (766 + 23)))) then
				if ((v133 == nil) or ((23508 - 18746) <= (1177 - 316))) then
					v133 = v15;
				end
				return not v133:IsInBossList() or (v133:Level() < (192 - 119));
			end
		end
	end
	local function v116()
		return v30(v14:BuffRemains(v99.FingersofFrostBuff), v15:DebuffRemains(v99.WintersChillDebuff), v15:DebuffRemains(v99.Frostbite), v15:DebuffRemains(v99.Freeze), v15:DebuffRemains(v99.FrostNova));
	end
	local function v117(v135)
		return (v135:DebuffStack(v99.WintersChillDebuff));
	end
	local function v118(v136)
		return (v136:DebuffDown(v99.WintersChillDebuff));
	end
	local function v119()
		local v137 = 0 - 0;
		while true do
			if ((v137 == (1073 - (1036 + 37))) or ((1002 + 410) == (8303 - 4039))) then
				if ((v99.IceBarrier:IsCastable() and v63 and v14:BuffDown(v99.IceBarrier) and (v14:HealthPercentage() <= v70)) or ((2493 + 675) < (3633 - (641 + 839)))) then
					if (v24(v99.IceBarrier) or ((5889 - (910 + 3)) < (3395 - 2063))) then
						return "ice_barrier defensive 1";
					end
				end
				if (((6312 - (1466 + 218)) == (2127 + 2501)) and v99.MassBarrier:IsCastable() and v67 and v14:BuffDown(v99.IceBarrier) and v113.AreUnitsBelowHealthPercentage(v75, 1150 - (556 + 592), v99.ArcaneIntellect)) then
					if (v24(v99.MassBarrier) or ((20 + 34) == (1203 - (329 + 479)))) then
						return "mass_barrier defensive 2";
					end
				end
				v137 = 855 - (174 + 680);
			end
			if (((281 - 199) == (169 - 87)) and (v137 == (2 + 0))) then
				if ((v99.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) or ((1320 - (396 + 343)) < (25 + 257))) then
					if (v24(v99.MirrorImage) or ((6086 - (29 + 1448)) < (3884 - (135 + 1254)))) then
						return "mirror_image defensive 5";
					end
				end
				if (((4339 - 3187) == (5378 - 4226)) and v99.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) then
					if (((1264 + 632) <= (4949 - (389 + 1138))) and v24(v99.GreaterInvisibility)) then
						return "greater_invisibility defensive 6";
					end
				end
				v137 = 577 - (102 + 472);
			end
			if ((v137 == (1 + 0)) or ((549 + 441) > (1511 + 109))) then
				if ((v99.IceColdTalent:IsAvailable() and v99.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) or ((2422 - (320 + 1225)) > (8358 - 3663))) then
					if (((1647 + 1044) >= (3315 - (157 + 1307))) and v24(v99.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if ((v99.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((4844 - (821 + 1038)) >= (12115 - 7259))) then
					if (((468 + 3808) >= (2122 - 927)) and v24(v99.IceBlock)) then
						return "ice_block defensive 4";
					end
				end
				v137 = 1 + 1;
			end
			if (((8010 - 4778) <= (5716 - (834 + 192))) and (v137 == (1 + 2))) then
				if ((v99.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) or ((230 + 666) >= (68 + 3078))) then
					if (((4741 - 1680) >= (3262 - (300 + 4))) and v24(v99.AlterTime)) then
						return "alter_time defensive 7";
					end
				end
				if (((852 + 2335) >= (1685 - 1041)) and v100.Healthstone:IsReady() and v86 and (v14:HealthPercentage() <= v88)) then
					if (((1006 - (112 + 250)) <= (281 + 423)) and v24(v101.Healthstone)) then
						return "healthstone defensive";
					end
				end
				v137 = 9 - 5;
			end
			if (((549 + 409) > (490 + 457)) and ((3 + 1) == v137)) then
				if (((2228 + 2264) >= (1972 + 682)) and v85 and (v14:HealthPercentage() <= v87)) then
					local v208 = 1414 - (1001 + 413);
					while true do
						if (((7675 - 4233) >= (2385 - (244 + 638))) and (v208 == (693 - (627 + 66)))) then
							if ((v89 == "Refreshing Healing Potion") or ((9445 - 6275) <= (2066 - (512 + 90)))) then
								if (v100.RefreshingHealingPotion:IsReady() or ((6703 - (1665 + 241)) == (5105 - (373 + 344)))) then
									if (((249 + 302) <= (181 + 500)) and v24(v101.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive";
									end
								end
							end
							if (((8643 - 5366) > (688 - 281)) and (v89 == "Dreamwalker's Healing Potion")) then
								if (((5794 - (35 + 1064)) >= (1030 + 385)) and v100.DreamwalkersHealingPotion:IsReady()) then
									if (v24(v101.RefreshingHealingPotion) or ((6871 - 3659) <= (4 + 940))) then
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
	local v120 = 1236 - (298 + 938);
	local function v121()
		if ((v99.RemoveCurse:IsReady() and (v113.UnitHasDispellableDebuffByPlayer(v16) or v113.DispellableFriendlyUnit(1284 - (233 + 1026)) or v113.UnitHasCurseDebuff(v16))) or ((4762 - (636 + 1030)) <= (920 + 878))) then
			local v150 = 0 + 0;
			while true do
				if (((1051 + 2486) == (239 + 3298)) and (v150 == (221 - (55 + 166)))) then
					if (((744 + 3093) >= (158 + 1412)) and (v120 == (0 - 0))) then
						v120 = GetTime();
					end
					if (v113.Wait(797 - (36 + 261), v120) or ((5159 - 2209) == (5180 - (34 + 1334)))) then
						local v219 = 0 + 0;
						while true do
							if (((3670 + 1053) >= (3601 - (1035 + 248))) and (v219 == (21 - (20 + 1)))) then
								if (v24(v101.RemoveCurseFocus) or ((1057 + 970) > (3171 - (134 + 185)))) then
									return "remove_curse dispel";
								end
								v120 = 1133 - (549 + 584);
								break;
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v138 = 685 - (314 + 371);
		while true do
			if (((3 - 2) == v138) or ((2104 - (478 + 490)) > (2287 + 2030))) then
				v31 = v113.HandleBottomTrinket(v102, v34, 1212 - (786 + 386), nil);
				if (((15378 - 10630) == (6127 - (1055 + 324))) and v31) then
					return v31;
				end
				break;
			end
			if (((5076 - (1093 + 247)) <= (4213 + 527)) and (v138 == (0 + 0))) then
				v31 = v113.HandleTopTrinket(v102, v34, 158 - 118, nil);
				if (v31 or ((11504 - 8114) <= (8707 - 5647))) then
					return v31;
				end
				v138 = 2 - 1;
			end
		end
	end
	local function v123()
		if (v113.TargetIsValid() or ((356 + 643) > (10374 - 7681))) then
			if (((1595 - 1132) < (454 + 147)) and v99.MirrorImage:IsCastable() and v68 and v97) then
				if (v24(v99.MirrorImage) or ((5582 - 3399) < (1375 - (364 + 324)))) then
					return "mirror_image precombat 2";
				end
			end
			if (((12470 - 7921) == (10915 - 6366)) and v99.Frostbolt:IsCastable() and not v14:IsCasting(v99.Frostbolt)) then
				if (((1549 + 3123) == (19549 - 14877)) and v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt))) then
					return "frostbolt precombat 4";
				end
			end
		end
	end
	local function v124()
		local v139 = 0 - 0;
		local v140;
		while true do
			if ((v139 == (0 - 0)) or ((4936 - (1249 + 19)) < (357 + 38))) then
				if ((v96 and v99.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v99.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(3 - 2, v99.IcyVeins)) or ((5252 - (686 + 400)) == (357 + 98))) then
					if (v24(v99.TimeWarp, not v15:IsInRange(269 - (73 + 156))) or ((22 + 4427) == (3474 - (721 + 90)))) then
						return "time_warp cd 2";
					end
				end
				v140 = v113.HandleDPSPotion(v14:BuffUp(v99.IcyVeinsBuff));
				v139 = 1 + 0;
			end
			if ((v139 == (6 - 4)) or ((4747 - (224 + 246)) < (4841 - 1852))) then
				if ((v83 < v111) or ((1601 - 731) >= (753 + 3396))) then
					if (((53 + 2159) < (2338 + 845)) and v91 and ((v34 and v92) or not v92)) then
						local v220 = 0 - 0;
						while true do
							if (((15460 - 10814) > (3505 - (203 + 310))) and (v220 == (1993 - (1238 + 755)))) then
								v31 = v122();
								if (((101 + 1333) < (4640 - (709 + 825))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if (((1447 - 661) < (4402 - 1379)) and v90 and ((v93 and v34) or not v93) and (v83 < v111)) then
					local v209 = 864 - (196 + 668);
					while true do
						if ((v209 == (7 - 5)) or ((5058 - 2616) < (907 - (171 + 662)))) then
							if (((4628 - (4 + 89)) == (15894 - 11359)) and v99.AncestralCall:IsCastable()) then
								if (v24(v99.AncestralCall) or ((1096 + 1913) <= (9245 - 7140))) then
									return "ancestral_call cd 18";
								end
							end
							break;
						end
						if (((718 + 1112) < (5155 - (35 + 1451))) and (v209 == (1453 - (28 + 1425)))) then
							if (v99.BloodFury:IsCastable() or ((3423 - (941 + 1052)) >= (3464 + 148))) then
								if (((4197 - (822 + 692)) >= (3512 - 1052)) and v24(v99.BloodFury)) then
									return "blood_fury cd 10";
								end
							end
							if (v99.Berserking:IsCastable() or ((850 + 954) >= (3572 - (45 + 252)))) then
								if (v24(v99.Berserking) or ((1403 + 14) > (1249 + 2380))) then
									return "berserking cd 12";
								end
							end
							v209 = 2 - 1;
						end
						if (((5228 - (114 + 319)) > (576 - 174)) and (v209 == (1 - 0))) then
							if (((3069 + 1744) > (5311 - 1746)) and v99.LightsJudgment:IsCastable()) then
								if (((8196 - 4284) == (5875 - (556 + 1407))) and v24(v99.LightsJudgment, not v15:IsSpellInRange(v99.LightsJudgment))) then
									return "lights_judgment cd 14";
								end
							end
							if (((4027 - (741 + 465)) <= (5289 - (170 + 295))) and v99.Fireblood:IsCastable()) then
								if (((916 + 822) <= (2017 + 178)) and v24(v99.Fireblood)) then
									return "fireblood cd 16";
								end
							end
							v209 = 4 - 2;
						end
					end
				end
				break;
			end
			if (((34 + 7) <= (1936 + 1082)) and (v139 == (1 + 0))) then
				if (((3375 - (957 + 273)) <= (1098 + 3006)) and v140) then
					return v140;
				end
				if (((1077 + 1612) < (18461 - 13616)) and v99.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v111)) then
					if (v24(v99.IcyVeins) or ((6118 - 3796) > (8008 - 5386))) then
						return "icy_veins cd 6";
					end
				end
				v139 = 9 - 7;
			end
		end
	end
	local function v125()
		local v141 = 1780 - (389 + 1391);
		while true do
			if ((v141 == (2 + 0)) or ((472 + 4062) == (4739 - 2657))) then
				if ((v99.IceLance:IsCastable() and v47) or ((2522 - (783 + 168)) > (6265 - 4398))) then
					if (v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance)) or ((2611 + 43) >= (3307 - (309 + 2)))) then
						return "ice_lance movement";
					end
				end
				break;
			end
			if (((12215 - 8237) > (3316 - (1090 + 122))) and (v141 == (1 + 0))) then
				if (((10058 - 7063) > (1055 + 486)) and v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (1148 - (628 + 490))) and (v104 >= (1 + 1))) then
					if (((8043 - 4794) > (4355 - 3402)) and v24(v99.ArcaneExplosion, not v15:IsInRange(782 - (431 + 343)))) then
						return "arcane_explosion movement";
					end
				end
				if ((v99.FireBlast:IsCastable() and v40) or ((6610 - 3337) > (13229 - 8656))) then
					if (v24(v99.FireBlast, not v15:IsSpellInRange(v99.FireBlast)) or ((2490 + 661) < (165 + 1119))) then
						return "fire_blast movement";
					end
				end
				v141 = 1697 - (556 + 1139);
			end
			if ((v141 == (15 - (6 + 9))) or ((339 + 1511) == (784 + 745))) then
				if (((990 - (28 + 141)) < (823 + 1300)) and v99.IceFloes:IsCastable() and v46 and v14:BuffDown(v99.IceFloes)) then
					if (((1112 - 210) < (1647 + 678)) and v24(v99.IceFloes)) then
						return "ice_floes movement";
					end
				end
				if (((2175 - (486 + 831)) <= (7707 - 4745)) and v99.IceNova:IsCastable() and v48) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((13892 - 9946) < (244 + 1044))) then
						return "ice_nova movement";
					end
				end
				v141 = 3 - 2;
			end
		end
	end
	local function v126()
		local v142 = 1263 - (668 + 595);
		while true do
			if ((v142 == (5 + 0)) or ((654 + 2588) == (1546 - 979))) then
				if ((v99.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (320 - (23 + 267))) and (v104 >= (1951 - (1129 + 815)))) or ((1234 - (371 + 16)) >= (3013 - (1326 + 424)))) then
					if (v24(v99.ArcaneExplosion, not v15:IsInRange(14 - 6)) or ((8232 - 5979) == (1969 - (88 + 30)))) then
						return "arcane_explosion aoe 28";
					end
				end
				if ((v99.Frostbolt:IsCastable() and v41) or ((2858 - (720 + 51)) > (5276 - 2904))) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((6221 - (421 + 1355)) < (6844 - 2695))) then
						return "frostbolt aoe 32";
					end
				end
				if ((v14:IsMoving() and v95) or ((894 + 924) == (1168 - (286 + 797)))) then
					local v210 = 0 - 0;
					while true do
						if (((1043 - 413) < (2566 - (397 + 42))) and (v210 == (0 + 0))) then
							v31 = v125();
							if (v31 or ((2738 - (24 + 776)) == (3872 - 1358))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((5040 - (222 + 563)) >= (121 - 66)) and (v142 == (1 + 0))) then
				if (((3189 - (23 + 167)) > (2954 - (690 + 1108))) and v99.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v111) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike) and (not v99.ColdestSnap:IsAvailable() or (v99.ConeofCold:CooldownUp() and (v99.FrozenOrb:CooldownRemains() > (21 + 4))) or (v99.ConeofCold:CooldownRemains() > (868 - (40 + 808))))) then
					if (((387 + 1963) > (4416 - 3261)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm aoe 8";
					end
				end
				if (((3851 + 178) <= (2568 + 2285)) and v18:IsActive() and v44 and v99.Freeze:IsReady() and v115() and (v116() == (0 + 0)) and ((not v99.GlacialSpike:IsAvailable() and not v99.Snowstorm:IsAvailable()) or v14:PrevGCDP(572 - (47 + 524), v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109)))) then
					if (v24(v101.FreezePet, not v15:IsSpellInRange(v99.Freeze)) or ((335 + 181) > (9386 - 5952))) then
						return "freeze aoe 10";
					end
				end
				if (((6049 - 2003) >= (6916 - 3883)) and v99.IceNova:IsCastable() and v48 and v115() and not v14:PrevOffGCDP(1727 - (1165 + 561), v99.Freeze) and (v14:PrevGCDP(1 + 0, v99.GlacialSpike) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (3 - 2))))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((1038 + 1681) <= (1926 - (341 + 138)))) then
						return "ice_nova aoe 11";
					end
				end
				v142 = 1 + 1;
			end
			if ((v142 == (3 - 1)) or ((4460 - (89 + 237)) < (12629 - 8703))) then
				if ((v99.FrostNova:IsCastable() and v42 and v115() and not v14:PrevOffGCDP(1 - 0, v99.Freeze) and ((v14:PrevGCDP(882 - (581 + 300), v99.GlacialSpike) and (v107 == (1220 - (855 + 365)))) or (v99.ConeofCold:CooldownUp() and (v14:BuffStack(v99.SnowstormBuff) == v109) and (v112 < (2 - 1))))) or ((54 + 110) >= (4020 - (1030 + 205)))) then
					if (v24(v99.FrostNova) or ((493 + 32) == (1962 + 147))) then
						return "frost_nova aoe 12";
					end
				end
				if (((319 - (156 + 130)) == (74 - 41)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and (v14:BuffStackP(v99.SnowstormBuff) == v109)) then
					if (((5146 - 2092) <= (8223 - 4208)) and v24(v99.ConeofCold, not v15:IsInRange(3 + 5))) then
						return "cone_of_cold aoe 14";
					end
				end
				if (((1092 + 779) < (3451 - (10 + 59))) and v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111)) then
					if (((366 + 927) <= (10667 - 8501)) and v24(v99.ShiftingPower, not v15:IsInRange(1203 - (671 + 492)), true)) then
						return "shifting_power aoe 16";
					end
				end
				v142 = 3 + 0;
			end
			if (((1215 - (369 + 846)) == v142) or ((683 + 1896) < (105 + 18))) then
				if ((v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v14:PrevGCDP(1946 - (1036 + 909), v99.CometStorm) or (v14:PrevGCDP(1 + 0, v99.FrozenOrb) and not v99.CometStorm:IsAvailable()))) or ((1420 - 574) >= (2571 - (11 + 192)))) then
					if (v24(v99.ConeofCold, not v15:IsInRange(5 + 3)) or ((4187 - (135 + 40)) <= (8135 - 4777))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((901 + 593) <= (6619 - 3614)) and v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (not v14:PrevGCDP(1 - 0, v99.GlacialSpike) or not v115())) then
					if (v24(v101.FrozenOrbCast, not v15:IsInRange(216 - (50 + 126))) or ((8662 - 5551) == (473 + 1661))) then
						return "frozen_orb aoe 4";
					end
				end
				if (((3768 - (1233 + 180)) == (3324 - (522 + 447))) and v99.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(1422 - (107 + 1314), v99.GlacialSpike) or not v115())) then
					if (v24(v101.BlizzardCursor, not v15:IsInRange(19 + 21), v14:BuffDown(v99.IceFloes)) or ((1791 - 1203) <= (184 + 248))) then
						return "blizzard aoe 6";
					end
				end
				v142 = 1 - 0;
			end
			if (((18979 - 14182) >= (5805 - (716 + 1194))) and (v142 == (1 + 3))) then
				if (((384 + 3193) == (4080 - (74 + 429))) and v99.IceLance:IsCastable() and v47 and (v14:BuffUp(v99.FingersofFrostBuff) or (v116() > v99.IceLance:TravelTime()) or v29(v107))) then
					if (((7318 - 3524) > (1831 + 1862)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v103 >= (8 - 4)) and ((not v99.Snowstorm:IsAvailable() and not v99.GlacialSpike:IsAvailable()) or not v115())) or ((903 + 372) == (12640 - 8540))) then
					if (v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova)) or ((3933 - 2342) >= (4013 - (279 + 154)))) then
						return "ice_nova aoe 23";
					end
				end
				if (((1761 - (454 + 324)) <= (1423 + 385)) and v99.DragonsBreath:IsCastable() and v39 and (v104 >= (24 - (12 + 5)))) then
					if (v24(v99.DragonsBreath, not v15:IsInRange(6 + 4)) or ((5478 - 3328) <= (443 + 754))) then
						return "dragons_breath aoe 26";
					end
				end
				v142 = 1098 - (277 + 816);
			end
			if (((16105 - 12336) >= (2356 - (1058 + 125))) and (v142 == (1 + 2))) then
				if (((2460 - (815 + 160)) == (6371 - 4886)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (11 - 6)) and (v99.Blizzard:CooldownRemains() > v112)) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((791 + 2524) <= (8132 - 5350))) then
						return "glacial_spike aoe 18";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and not v115() and (v107 == (1898 - (41 + 1857))) and (v14:PrevGCDP(1894 - (1222 + 671), v99.GlacialSpike) or (v99.Flurry:ChargesFractional() > (2.8 - 1)))) or ((1258 - 382) >= (4146 - (229 + 953)))) then
					if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((4006 - (1111 + 663)) > (4076 - (874 + 705)))) then
						return "flurry aoe 20";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and (v107 == (0 + 0)) and (v14:BuffUp(v99.BrainFreezeBuff) or v14:BuffUp(v99.FingersofFrostBuff))) or ((1440 + 670) <= (689 - 357))) then
					if (((104 + 3582) > (3851 - (642 + 37))) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes))) then
						return "flurry aoe 21";
					end
				end
				v142 = 1 + 3;
			end
		end
	end
	local function v127()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (9 - 5)) or ((4928 - (233 + 221)) < (1896 - 1076))) then
				if (((3767 + 512) >= (4423 - (718 + 823))) and v99.Frostbolt:IsCastable() and v41) then
					if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((1277 + 752) >= (4326 - (266 + 539)))) then
						return "frostbolt cleave 26";
					end
				end
				if ((v14:IsMoving() and v95) or ((5767 - 3730) >= (5867 - (636 + 589)))) then
					local v211 = 0 - 0;
					while true do
						if (((3547 - 1827) < (3533 + 925)) and (v211 == (0 + 0))) then
							v31 = v125();
							if (v31 or ((1451 - (657 + 358)) > (7998 - 4977))) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((1624 - 911) <= (2034 - (1151 + 36))) and (v143 == (0 + 0))) then
				if (((567 + 1587) <= (12038 - 8007)) and v99.CometStorm:IsCastable() and (v14:PrevGCDP(1833 - (1552 + 280), v99.Flurry) or v14:PrevGCDP(835 - (64 + 770), v99.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v111)) then
					if (((3134 + 1481) == (10476 - 5861)) and v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm))) then
						return "comet_storm cleave 2";
					end
				end
				if ((v99.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(1 + 0, v99.Frostbolt) and (v108 >= (1246 - (157 + 1086)))) or v14:PrevGCDP(1 - 0, v99.GlacialSpike) or ((v108 >= (13 - 10)) and (v108 < (7 - 2)) and (v99.Flurry:ChargesFractional() == (2 - 0))))) or ((4609 - (599 + 220)) == (995 - 495))) then
					local v212 = 1931 - (1813 + 118);
					while true do
						if (((66 + 23) < (1438 - (841 + 376))) and ((0 - 0) == v212)) then
							if (((478 + 1576) >= (3878 - 2457)) and v113.CastTargetIf(v99.Flurry, v105, "min", v117, nil, not v15:IsSpellInRange(v99.Flurry))) then
								return "flurry cleave 4";
							end
							if (((1551 - (464 + 395)) < (7847 - 4789)) and v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes))) then
								return "flurry cleave 4";
							end
							break;
						end
					end
				end
				if ((v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and (v99.WintersChillDebuff:AuraActiveCount() == (0 + 0)) and (v108 == (841 - (467 + 370))) and v14:BuffUp(v99.FingersofFrostBuff)) or ((6724 - 3470) == (1215 + 440))) then
					local v213 = 0 - 0;
					while true do
						if ((v213 == (0 + 0)) or ((3015 - 1719) == (5430 - (150 + 370)))) then
							if (((4650 - (74 + 1208)) == (8283 - 4915)) and v113.CastTargetIf(v99.IceLance, v105, "max", v118, nil, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 6";
							end
							if (((12534 - 9891) < (2715 + 1100)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 6";
							end
							break;
						end
					end
				end
				v143 = 391 - (14 + 376);
			end
			if (((3317 - 1404) > (320 + 173)) and (v143 == (2 + 0))) then
				if (((4535 + 220) > (10044 - 6616)) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (8 + 2)) and (v99.FrozenOrb:CooldownRemains() > (88 - (23 + 55))) and (v107 == (0 - 0)) and (v104 >= (3 + 0))) then
					if (((1241 + 140) <= (3672 - 1303)) and v24(v99.ConeofCold)) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v99.Blizzard:IsCastable() and v38 and (v104 >= (1 + 1)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v104 >= (904 - (652 + 249))))) or ((12960 - 8117) == (5952 - (708 + 1160)))) then
					if (((12673 - 8004) > (661 - 298)) and v24(v101.BlizzardCursor, not v15:IsSpellInRange(v99.Blizzard), v14:BuffDown(v99.IceFloes))) then
						return "blizzard cleave 16";
					end
				end
				if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (((v99.FrozenOrb:CooldownRemains() > (37 - (10 + 17))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (3 + 7))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (1742 - (1400 + 332))))) or (v99.IcyVeins:CooldownRemains() < (38 - 18)))) or ((3785 - (242 + 1666)) >= (1343 + 1795))) then
					if (((1738 + 3004) >= (3091 + 535)) and v24(v99.ShiftingPower, not v15:IsSpellInRange(v99.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				v143 = 943 - (850 + 90);
			end
			if ((v143 == (4 - 1)) or ((5930 - (360 + 1030)) == (811 + 105))) then
				if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (13 - 8))) or ((1589 - 433) > (6006 - (909 + 752)))) then
					if (((3460 - (109 + 1114)) < (7778 - 3529)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((v99.IceLance:IsReady() and v47 and ((v14:BuffStackP(v99.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike)) or (v107 > (242 - (6 + 236))))) or ((1691 + 992) < (19 + 4))) then
					local v214 = 0 - 0;
					while true do
						if (((1217 - 520) <= (1959 - (1076 + 57))) and (v214 == (0 + 0))) then
							if (((1794 - (579 + 110)) <= (93 + 1083)) and v113.CastTargetIf(v99.IceLance, v105, "max", v117, nil, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 22";
							end
							if (((2988 + 391) <= (2024 + 1788)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
								return "ice_lance cleave 22";
							end
							break;
						end
					end
				end
				if ((v99.IceNova:IsCastable() and v48 and (v104 >= (411 - (174 + 233)))) or ((2201 - 1413) >= (2836 - 1220))) then
					if (((825 + 1029) <= (4553 - (663 + 511))) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
						return "ice_nova cleave 24";
					end
				end
				v143 = 4 + 0;
			end
			if (((988 + 3561) == (14024 - 9475)) and (v143 == (1 + 0))) then
				if ((v99.RayofFrost:IsCastable() and (v107 == (2 - 1)) and v49) or ((7315 - 4293) >= (1443 + 1581))) then
					if (((9381 - 4561) > (1567 + 631)) and v113.CastTargetIf(v99.RayofFrost, v105, "max", v117, nil, not v15:IsSpellInRange(v99.RayofFrost))) then
						return "ray_of_frost cleave 8";
					end
					if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((97 + 964) >= (5613 - (478 + 244)))) then
						return "ray_of_frost cleave 8";
					end
				end
				if (((1881 - (440 + 77)) <= (2034 + 2439)) and v99.GlacialSpike:IsReady() and v45 and (v108 == (18 - 13)) and (v99.Flurry:CooldownUp() or (v107 > (1556 - (655 + 901))))) then
					if (v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes)) or ((667 + 2928) <= (3 + 0))) then
						return "glacial_spike cleave 10";
					end
				end
				if ((v99.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v111) and (v14:BuffStackP(v99.FingersofFrostBuff) < (2 + 0)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((18821 - 14149) == (5297 - (695 + 750)))) then
					if (((5323 - 3764) == (2405 - 846)) and v24(v101.FrozenOrbCast, not v15:IsSpellInRange(v99.FrozenOrb))) then
						return "frozen_orb cleave 12";
					end
				end
				v143 = 7 - 5;
			end
		end
	end
	local function v128()
		if ((v99.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v111) and (v14:PrevGCDP(352 - (285 + 66), v99.Flurry) or v14:PrevGCDP(2 - 1, v99.ConeofCold))) or ((3062 - (682 + 628)) <= (128 + 660))) then
			if (v24(v99.CometStorm, not v15:IsSpellInRange(v99.CometStorm)) or ((4206 - (176 + 123)) == (75 + 102))) then
				return "comet_storm single 2";
			end
		end
		if (((2518 + 952) > (824 - (239 + 30))) and v99.Flurry:IsCastable() and (v107 == (0 + 0)) and v15:DebuffDown(v99.WintersChillDebuff) and ((v14:PrevGCDP(1 + 0, v99.Frostbolt) and (v108 >= (4 - 1))) or (v14:PrevGCDP(2 - 1, v99.Frostbolt) and v14:BuffUp(v99.BrainFreezeBuff)) or v14:PrevGCDP(316 - (306 + 9), v99.GlacialSpike) or (v99.GlacialSpike:IsAvailable() and (v108 == (13 - 9)) and v14:BuffDown(v99.FingersofFrostBuff)))) then
			if (v24(v99.Flurry, not v15:IsSpellInRange(v99.Flurry), v14:BuffDown(v99.IceFloes)) or ((170 + 802) == (396 + 249))) then
				return "flurry single 4";
			end
		end
		if (((1532 + 1650) >= (6048 - 3933)) and v99.IceLance:IsReady() and v47 and v99.GlacialSpike:IsAvailable() and not v99.GlacialSpike:InFlight() and (v107 == (1375 - (1140 + 235))) and (v108 == (3 + 1)) and v14:BuffUp(v99.FingersofFrostBuff)) then
			if (((3570 + 323) < (1137 + 3292)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
				return "ice_lance single 6";
			end
		end
		if ((v99.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v99.WintersChillDebuff) > v99.RayofFrost:CastTime()) and (v107 == (53 - (33 + 19)))) or ((1036 + 1831) < (5709 - 3804))) then
			if (v24(v99.RayofFrost, not v15:IsSpellInRange(v99.RayofFrost)) or ((792 + 1004) >= (7944 - 3893))) then
				return "ray_of_frost single 8";
			end
		end
		if (((1519 + 100) <= (4445 - (586 + 103))) and v99.GlacialSpike:IsReady() and v45 and (v108 == (1 + 4)) and ((v99.Flurry:Charges() >= (2 - 1)) or ((v107 > (1488 - (1309 + 179))) and (v99.GlacialSpike:CastTime() < v15:DebuffRemains(v99.WintersChillDebuff))))) then
			if (((1089 - 485) == (263 + 341)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
				return "glacial_spike single 10";
			end
		end
		if ((v99.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v111) and (v107 == (0 - 0)) and (v14:BuffStackP(v99.FingersofFrostBuff) < (2 + 0)) and (not v99.RayofFrost:IsAvailable() or v99.RayofFrost:CooldownDown())) or ((9526 - 5042) == (1793 - 893))) then
			if (v24(v101.FrozenOrbCast, not v15:IsInRange(649 - (295 + 314))) or ((10951 - 6492) <= (3075 - (1300 + 662)))) then
				return "frozen_orb single 12";
			end
		end
		if (((11404 - 7772) > (5153 - (1178 + 577))) and v99.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v111) and v99.ColdestSnap:IsAvailable() and (v99.CometStorm:CooldownRemains() > (6 + 4)) and (v99.FrozenOrb:CooldownRemains() > (29 - 19)) and (v107 == (1405 - (851 + 554))) and (v103 >= (3 + 0))) then
			if (((11320 - 7238) <= (10678 - 5761)) and v24(v99.ConeofCold, not v15:IsInRange(310 - (115 + 187)))) then
				return "cone_of_cold single 14";
			end
		end
		if (((3701 + 1131) >= (1313 + 73)) and v99.Blizzard:IsCastable() and v38 and (v103 >= (7 - 5)) and v99.IceCaller:IsAvailable() and v99.FreezingRain:IsAvailable() and ((not v99.SplinteringCold:IsAvailable() and not v99.RayofFrost:IsAvailable()) or v14:BuffUp(v99.FreezingRainBuff) or (v103 >= (1164 - (160 + 1001))))) then
			if (((120 + 17) == (95 + 42)) and v24(v101.BlizzardCursor, not v15:IsInRange(81 - 41), v14:BuffDown(v99.IceFloes))) then
				return "blizzard single 16";
			end
		end
		if ((v99.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v111) and (v107 == (358 - (237 + 121))) and (((v99.FrozenOrb:CooldownRemains() > (907 - (525 + 372))) and (not v99.CometStorm:IsAvailable() or (v99.CometStorm:CooldownRemains() > (18 - 8))) and (not v99.RayofFrost:IsAvailable() or (v99.RayofFrost:CooldownRemains() > (32 - 22)))) or (v99.IcyVeins:CooldownRemains() < (162 - (96 + 46))))) or ((2347 - (643 + 134)) >= (1564 + 2768))) then
			if (v24(v99.ShiftingPower, not v15:IsInRange(95 - 55)) or ((15088 - 11024) <= (1745 + 74))) then
				return "shifting_power single 18";
			end
		end
		if ((v99.GlacialSpike:IsReady() and v45 and (v108 == (9 - 4))) or ((10191 - 5205) < (2293 - (316 + 403)))) then
			if (((2942 + 1484) > (472 - 300)) and v24(v99.GlacialSpike, not v15:IsSpellInRange(v99.GlacialSpike), v14:BuffDown(v99.IceFloes))) then
				return "glacial_spike single 20";
			end
		end
		if (((212 + 374) > (1145 - 690)) and v99.IceLance:IsReady() and v47 and ((v14:BuffUp(v99.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v99.GlacialSpike) and not v99.GlacialSpike:InFlight()) or v29(v107))) then
			if (((267 + 559) == (2861 - 2035)) and v24(v99.IceLance, not v15:IsSpellInRange(v99.IceLance))) then
				return "ice_lance single 22";
			end
		end
		if ((v99.IceNova:IsCastable() and v48 and (v104 >= (19 - 15))) or ((8348 - 4329) > (255 + 4186))) then
			if (((3970 - 1953) < (209 + 4052)) and v24(v99.IceNova, not v15:IsSpellInRange(v99.IceNova))) then
				return "ice_nova single 24";
			end
		end
		if (((13874 - 9158) > (97 - (12 + 5))) and v90 and ((v93 and v34) or not v93)) then
			if (v99.BagofTricks:IsCastable() or ((13621 - 10114) == (6980 - 3708))) then
				if (v24(v99.BagofTricks, not v15:IsSpellInRange(v99.BagofTricks)) or ((1861 - 985) >= (7625 - 4550))) then
					return "bag_of_tricks cd 40";
				end
			end
		end
		if (((884 + 3468) > (4527 - (1656 + 317))) and v99.Frostbolt:IsCastable() and v41) then
			if (v24(v99.Frostbolt, not v15:IsSpellInRange(v99.Frostbolt), v14:BuffDown(v99.IceFloes)) or ((3927 + 479) < (3240 + 803))) then
				return "frostbolt single 26";
			end
		end
		if ((v14:IsMoving() and v95) or ((5022 - 3133) >= (16649 - 13266))) then
			local v151 = 354 - (5 + 349);
			while true do
				if (((8986 - 7094) <= (4005 - (266 + 1005))) and (v151 == (0 + 0))) then
					v31 = v125();
					if (((6561 - 4638) < (2919 - 701)) and v31) then
						return v31;
					end
					break;
				end
			end
		end
	end
	local function v129()
		local v144 = 1696 - (561 + 1135);
		while true do
			if (((2830 - 657) > (1245 - 866)) and (v144 == (1067 - (507 + 559)))) then
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v144 = 4 - 2;
			end
			if ((v144 == (9 - 6)) or ((2979 - (212 + 176)) == (4314 - (250 + 655)))) then
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v144 = 10 - 6;
			end
			if (((7887 - 3373) > (5199 - 1875)) and (v144 == (1956 - (1869 + 87)))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFrostbolt'];
				v144 = 3 - 2;
			end
			if (((1908 - (484 + 1417)) == v144) or ((445 - 237) >= (8090 - 3262))) then
				v96 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v97 = EpicSettings.Settings['mirrorImageBeforePull'];
				v98 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if ((v144 == (778 - (48 + 725))) or ((2585 - 1002) > (9569 - 6002))) then
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (0 + 0);
				v70 = EpicSettings.Settings['iceBarrierHP'] or (0 - 0);
				v73 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v144 = 2 + 4;
			end
			if ((v144 == (859 - (152 + 701))) or ((2624 - (430 + 881)) == (305 + 489))) then
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (895 - (557 + 338));
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 - 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (0 - 0);
				v94 = EpicSettings.Settings['useSpellStealTarget'];
				v95 = EpicSettings.Settings['useSpellsWhileMoving'];
				v144 = 18 - 11;
			end
			if (((6840 - 3666) > (3703 - (499 + 302))) and (v144 == (870 - (39 + 827)))) then
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v144 = 13 - 8;
			end
			if (((9201 - 5081) <= (16920 - 12660)) and ((2 - 0) == v144)) then
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v51 = EpicSettings.Settings['useBlastWave'];
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v144 = 1 + 2;
			end
		end
	end
	local function v130()
		local v145 = 0 - 0;
		while true do
			if ((v145 == (1 + 0)) or ((1397 - 514) > (4882 - (103 + 1)))) then
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v76 = EpicSettings.Settings['DispelBuffs'];
				v91 = EpicSettings.Settings['useTrinkets'];
				v145 = 556 - (475 + 79);
			end
			if (((8 - 4) == v145) or ((11584 - 7964) >= (633 + 4258))) then
				v78 = EpicSettings.Settings['handleAfflicted'];
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((3748 + 510) > (2440 - (1395 + 108))) and (v145 == (0 - 0))) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (1204 - (7 + 1197));
				v84 = EpicSettings.Settings['useWeapon'];
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v145 = 1 + 0;
			end
			if ((v145 == (1 + 1)) or ((5188 - (27 + 292)) < (2654 - 1748))) then
				v90 = EpicSettings.Settings['useRacials'];
				v92 = EpicSettings.Settings['trinketsWithCD'];
				v93 = EpicSettings.Settings['racialsWithCD'];
				v86 = EpicSettings.Settings['useHealthstone'];
				v145 = 3 - 0;
			end
			if ((v145 == (12 - 9)) or ((2415 - 1190) > (8051 - 3823))) then
				v85 = EpicSettings.Settings['useHealingPotion'];
				v88 = EpicSettings.Settings['healthstoneHP'] or (139 - (43 + 96));
				v87 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v89 = EpicSettings.Settings['HealingPotionName'] or "";
				v145 = 8 - 4;
			end
		end
	end
	local function v131()
		local v146 = 0 + 0;
		while true do
			if (((940 + 2388) > (4423 - 2185)) and (v146 == (1 + 0))) then
				v33 = EpicSettings.Toggles['aoe'];
				v34 = EpicSettings.Toggles['cds'];
				v35 = EpicSettings.Toggles['dispel'];
				v146 = 3 - 1;
			end
			if (((1209 + 2630) > (104 + 1301)) and (v146 == (1751 - (1414 + 337)))) then
				v129();
				v130();
				v32 = EpicSettings.Toggles['ooc'];
				v146 = 1941 - (1642 + 298);
			end
			if (((10 - 6) == v146) or ((3719 - 2426) <= (1504 - 997))) then
				if (v113.TargetIsValid() or ((954 + 1942) < (627 + 178))) then
					local v215 = 972 - (357 + 615);
					while true do
						if (((1626 + 690) == (5682 - 3366)) and (v215 == (0 + 0))) then
							if ((v77 and v35 and v99.RemoveCurse:IsAvailable()) or ((5507 - 2937) == (1227 + 306))) then
								local v221 = 0 + 0;
								while true do
									if ((v221 == (0 + 0)) or ((2184 - (384 + 917)) == (2157 - (128 + 569)))) then
										if (v16 or ((6162 - (1407 + 136)) <= (2886 - (687 + 1200)))) then
											local v230 = 1710 - (556 + 1154);
											while true do
												if ((v230 == (0 - 0)) or ((3505 - (9 + 86)) > (4537 - (275 + 146)))) then
													v31 = v121();
													if (v31 or ((147 + 756) >= (3123 - (29 + 35)))) then
														return v31;
													end
													break;
												end
											end
										end
										if ((v17 and v17:Exists() and not v14:CanAttack(v17) and v113.UnitHasCurseDebuff(v17)) or ((17621 - 13645) < (8533 - 5676))) then
											if (((21763 - 16833) > (1503 + 804)) and v99.RemoveCurse:IsReady()) then
												if (v24(v101.RemoveCurseMouseover) or ((5058 - (53 + 959)) < (1699 - (312 + 96)))) then
													return "remove_curse dispel";
												end
											end
										end
										break;
									end
								end
							end
							if ((not v14:AffectingCombat() and v32) or ((7360 - 3119) == (3830 - (147 + 138)))) then
								local v222 = 899 - (813 + 86);
								while true do
									if ((v222 == (0 + 0)) or ((7499 - 3451) > (4724 - (18 + 474)))) then
										v31 = v123();
										if (v31 or ((591 + 1159) >= (11335 - 7862))) then
											return v31;
										end
										break;
									end
								end
							end
							v215 = 1087 - (860 + 226);
						end
						if (((3469 - (121 + 182)) == (390 + 2776)) and (v215 == (1241 - (988 + 252)))) then
							v31 = v119();
							if (((200 + 1563) < (1167 + 2557)) and v31) then
								return v31;
							end
							v215 = 1972 - (49 + 1921);
						end
						if (((947 - (223 + 667)) <= (2775 - (51 + 1))) and (v215 == (5 - 2))) then
							if (v79 or ((4432 - 2362) == (1568 - (146 + 979)))) then
								local v223 = 0 + 0;
								while true do
									if (((605 - (311 + 294)) == v223) or ((7543 - 4838) == (591 + 802))) then
										v31 = v113.HandleIncorporeal(v99.Polymorph, v101.PolymorphMouseover, 1473 - (496 + 947));
										if (v31 or ((5959 - (1233 + 125)) < (25 + 36))) then
											return v31;
										end
										break;
									end
								end
							end
							if ((v99.Spellsteal:IsAvailable() and v94 and v99.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v113.UnitHasMagicBuff(v15)) or ((1248 + 142) >= (902 + 3842))) then
								if (v24(v99.Spellsteal, not v15:IsSpellInRange(v99.Spellsteal)) or ((3648 - (963 + 682)) > (3200 + 634))) then
									return "spellsteal damage";
								end
							end
							v215 = 1508 - (504 + 1000);
						end
						if ((v215 == (2 + 0)) or ((143 + 13) > (370 + 3543))) then
							if (((287 - 92) == (167 + 28)) and (v14:AffectingCombat() or v77)) then
								local v224 = 0 + 0;
								local v225;
								while true do
									if (((3287 - (156 + 26)) >= (1035 + 761)) and (v224 == (1 - 0))) then
										if (((4543 - (149 + 15)) >= (3091 - (890 + 70))) and v31) then
											return v31;
										end
										break;
									end
									if (((3961 - (39 + 78)) >= (2525 - (14 + 468))) and (v224 == (0 - 0))) then
										v225 = v77 and v99.RemoveCurse:IsReady() and v35;
										v31 = v113.FocusUnit(v225, nil, 55 - 35, nil, 11 + 9, v99.ArcaneIntellect);
										v224 = 1 + 0;
									end
								end
							end
							if (v78 or ((687 + 2545) <= (1234 + 1497))) then
								if (((1286 + 3619) == (9389 - 4484)) and v98) then
									local v226 = 0 + 0;
									while true do
										if ((v226 == (0 - 0)) or ((105 + 4031) >= (4462 - (12 + 39)))) then
											v31 = v113.HandleAfflicted(v99.RemoveCurse, v101.RemoveCurseMouseover, 28 + 2);
											if (v31 or ((9155 - 6197) == (14306 - 10289))) then
												return v31;
											end
											break;
										end
									end
								end
							end
							v215 = 1 + 2;
						end
						if (((647 + 581) >= (2061 - 1248)) and (v215 == (3 + 1))) then
							if ((v14:AffectingCombat() and v113.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((16697 - 13242) > (5760 - (1596 + 114)))) then
								if (((633 - 390) == (956 - (164 + 549))) and v34 and v84 and (v100.Dreambinder:IsEquippedAndReady() or v100.Iridal:IsEquippedAndReady())) then
									if (v24(v101.UseWeapon, nil) or ((1709 - (1059 + 379)) > (1951 - 379))) then
										return "Using Weapon Macro";
									end
								end
								if (((1420 + 1319) < (556 + 2737)) and v34) then
									v31 = v124();
									if (v31 or ((4334 - (145 + 247)) < (931 + 203))) then
										return v31;
									end
								end
								if ((v33 and (((v104 >= (4 + 3)) and not v14:HasTier(88 - 58, 1 + 1)) or ((v104 >= (3 + 0)) and v99.IceCaller:IsAvailable()))) or ((4371 - 1678) == (5693 - (254 + 466)))) then
									local v227 = 560 - (544 + 16);
									while true do
										if (((6819 - 4673) == (2774 - (294 + 334))) and ((253 - (236 + 17)) == v227)) then
											v31 = v126();
											if (v31 or ((968 + 1276) == (2510 + 714))) then
												return v31;
											end
											v227 = 3 - 2;
										end
										if ((v227 == (4 - 3)) or ((2525 + 2379) <= (1579 + 337))) then
											if (((884 - (413 + 381)) <= (45 + 1020)) and v24(v99.Pool)) then
												return "pool for Aoe()";
											end
											break;
										end
									end
								end
								if (((10212 - 5410) == (12473 - 7671)) and v33 and (v104 == (1972 - (582 + 1388)))) then
									local v228 = 0 - 0;
									while true do
										if ((v228 == (1 + 0)) or ((2644 - (326 + 38)) <= (1511 - 1000))) then
											if (v24(v99.Pool) or ((2392 - 716) <= (1083 - (47 + 573)))) then
												return "pool for Cleave()";
											end
											break;
										end
										if (((1364 + 2505) == (16431 - 12562)) and (v228 == (0 - 0))) then
											v31 = v127();
											if (((2822 - (1269 + 395)) <= (3105 - (76 + 416))) and v31) then
												return v31;
											end
											v228 = 444 - (319 + 124);
										end
									end
								end
								v31 = v128();
								if (v31 or ((5403 - 3039) <= (3006 - (564 + 443)))) then
									return v31;
								end
								if (v24(v99.Pool) or ((13625 - 8703) < (652 - (337 + 121)))) then
									return "pool for ST()";
								end
								if ((v14:IsMoving() and v95) or ((6126 - 4035) < (103 - 72))) then
									local v229 = 1911 - (1261 + 650);
									while true do
										if ((v229 == (0 + 0)) or ((3872 - 1442) >= (6689 - (772 + 1045)))) then
											v31 = v125();
											if (v31 or ((673 + 4097) < (1879 - (102 + 42)))) then
												return v31;
											end
											break;
										end
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v146 == (1846 - (1524 + 320))) or ((5709 - (1049 + 221)) <= (2506 - (18 + 138)))) then
				if (v14:IsDeadOrGhost() or ((10963 - 6484) < (5568 - (67 + 1035)))) then
					return v31;
				end
				v105 = v15:GetEnemiesInSplashRange(353 - (136 + 212));
				v106 = v14:GetEnemiesInRange(169 - 129);
				v146 = 3 + 0;
			end
			if (((2348 + 199) > (2829 - (240 + 1364))) and ((1085 - (1050 + 32)) == v146)) then
				if (((16678 - 12007) > (1582 + 1092)) and v33) then
					local v216 = 1055 - (331 + 724);
					while true do
						if ((v216 == (0 + 0)) or ((4340 - (269 + 375)) < (4052 - (267 + 458)))) then
							v103 = v30(v15:GetEnemiesInSplashRangeCount(2 + 3), #v106);
							v104 = v30(v15:GetEnemiesInSplashRangeCount(9 - 4), #v106);
							break;
						end
					end
				else
					local v217 = 818 - (667 + 151);
					while true do
						if ((v217 == (1497 - (1410 + 87))) or ((6439 - (1504 + 393)) == (8028 - 5058))) then
							v103 = 2 - 1;
							v104 = 797 - (461 + 335);
							break;
						end
					end
				end
				if (((33 + 219) <= (3738 - (1730 + 31))) and not v14:AffectingCombat()) then
					if ((v99.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v99.ArcaneIntellect, true) or v113.GroupBuffMissing(v99.ArcaneIntellect))) or ((3103 - (728 + 939)) == (13369 - 9594))) then
						if (v24(v99.ArcaneIntellect) or ((3281 - 1663) < (2130 - 1200))) then
							return "arcane_intellect";
						end
					end
				end
				if (((5791 - (138 + 930)) > (3796 + 357)) and (v113.TargetIsValid() or v14:AffectingCombat())) then
					local v218 = 0 + 0;
					while true do
						if ((v218 == (1 + 0)) or ((14920 - 11266) >= (6420 - (459 + 1307)))) then
							if (((2821 - (474 + 1396)) <= (2612 - 1116)) and (v111 == (10414 + 697))) then
								v111 = v10.FightRemains(v106, false);
							end
							v107 = v15:DebuffStack(v99.WintersChillDebuff);
							v218 = 1 + 1;
						end
						if ((v218 == (5 - 3)) or ((220 + 1516) == (1906 - 1335))) then
							v108 = v14:BuffStackP(v99.IciclesBuff);
							v112 = v14:GCD();
							break;
						end
						if ((v218 == (0 - 0)) or ((1487 - (562 + 29)) > (4066 + 703))) then
							v110 = v10.BossFightRemains(nil, true);
							v111 = v110;
							v218 = 1420 - (374 + 1045);
						end
					end
				end
				v146 = 4 + 0;
			end
		end
	end
	local function v132()
		v114();
		v99.WintersChillDebuff:RegisterAuraTracking();
		v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(198 - 134, v131, v132);
end;
return v0["Epix_Mage_Frost.lua"]();

