local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 523 - (423 + 100);
	local v6;
	while true do
		if (((32 + 4442) >= (758 - 484)) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (not v6 or ((2665 - (326 + 445)) <= (6135 - 4729))) then
				return v1(v4, ...);
			end
			v5 = 2 - 1;
		end
		if (((3668 - 2096) >= (2242 - (530 + 181))) and (v5 == (882 - (614 + 267)))) then
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
	local v98 = v19.Mage.Frost;
	local v99 = v21.Mage.Frost;
	local v100 = v26.Mage.Frost;
	local v101 = {};
	local v102, v103;
	local v104, v105;
	local v106 = 32 - (19 + 13);
	local v107 = 0 - 0;
	local v108 = 34 - 19;
	local v109 = 31739 - 20628;
	local v110 = 2886 + 8225;
	local v111;
	local v112 = v22.Commons.Everyone;
	local function v113()
		if (v98.RemoveCurse:IsAvailable() or ((8242 - 3555) < (9418 - 4876))) then
			v112.DispellableDebuffs = v112.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	v98.FrozenOrb:RegisterInFlightEffect(86533 - (1293 + 519));
	v98.FrozenOrb:RegisterInFlight();
	v10:RegisterForEvent(function()
		v98.FrozenOrb:RegisterInFlight();
	end, "LEARNED_SPELL_IN_TAB");
	v98.Frostbolt:RegisterInFlightEffect(466408 - 237811);
	v98.Frostbolt:RegisterInFlight();
	v98.Flurry:RegisterInFlightEffect(596220 - 367866);
	v98.Flurry:RegisterInFlight();
	v98.IceLance:RegisterInFlightEffect(437152 - 208554);
	v98.IceLance:RegisterInFlight();
	v98.GlacialSpike:RegisterInFlightEffect(985748 - 757148);
	v98.GlacialSpike:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v131 = 0 - 0;
		while true do
			if (((1744 + 1547) > (341 + 1326)) and ((2 - 1) == v131)) then
				v106 = 0 + 0;
				break;
			end
			if ((v131 == (0 + 0)) or ((546 + 327) == (3130 - (709 + 387)))) then
				v109 = 12969 - (673 + 1185);
				v110 = 32223 - 21112;
				v131 = 3 - 2;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v114(v132)
		local v133 = 0 - 0;
		while true do
			if ((v133 == (0 + 0)) or ((2105 + 711) < (14 - 3))) then
				if (((909 + 2790) < (9383 - 4677)) and (v132 == nil)) then
					v132 = v15;
				end
				return not v132:IsInBossList() or (v132:Level() < (142 - 69));
			end
		end
	end
	local function v115()
		return v30(v14:BuffRemains(v98.FingersofFrostBuff), v15:DebuffRemains(v98.WintersChillDebuff), v15:DebuffRemains(v98.Frostbite), v15:DebuffRemains(v98.Freeze), v15:DebuffRemains(v98.FrostNova));
	end
	local function v116(v134)
		return (v134:DebuffStack(v98.WintersChillDebuff));
	end
	local function v117(v135)
		return (v135:DebuffDown(v98.WintersChillDebuff));
	end
	local function v118()
		local v136 = 1880 - (446 + 1434);
		while true do
			if (((3929 - (1040 + 243)) >= (2614 - 1738)) and ((1849 - (559 + 1288)) == v136)) then
				if (((2545 - (609 + 1322)) <= (3638 - (13 + 441))) and v98.MirrorImage:IsCastable() and v68 and (v14:HealthPercentage() <= v74)) then
					if (((11681 - 8555) == (8188 - 5062)) and v24(v98.MirrorImage)) then
						return "mirror_image defensive 5";
					end
				end
				if ((v98.GreaterInvisibility:IsReady() and v64 and (v14:HealthPercentage() <= v71)) or ((10892 - 8705) >= (185 + 4769))) then
					if (v24(v98.GreaterInvisibility) or ((14080 - 10203) == (1270 + 2305))) then
						return "greater_invisibility defensive 6";
					end
				end
				v136 = 2 + 1;
			end
			if (((2098 - 1391) > (346 + 286)) and (v136 == (0 - 0))) then
				if ((v98.IceBarrier:IsCastable() and v63 and v14:BuffDown(v98.IceBarrier) and (v14:HealthPercentage() <= v70)) or ((361 + 185) >= (1493 + 1191))) then
					if (((1053 + 412) <= (3612 + 689)) and v24(v98.IceBarrier)) then
						return "ice_barrier defensive 1";
					end
				end
				if (((1668 + 36) > (1858 - (153 + 280))) and v98.MassBarrier:IsCastable() and v67 and v14:BuffDown(v98.IceBarrier) and v112.AreUnitsBelowHealthPercentage(v75, 5 - 3)) then
					if (v24(v98.MassBarrier) or ((617 + 70) == (1672 + 2562))) then
						return "mass_barrier defensive 2";
					end
				end
				v136 = 1 + 0;
			end
			if ((v136 == (1 + 0)) or ((2413 + 917) < (2175 - 746))) then
				if (((709 + 438) >= (1002 - (89 + 578))) and v98.IceColdTalent:IsAvailable() and v98.IceColdAbility:IsCastable() and v66 and (v14:HealthPercentage() <= v73)) then
					if (((2454 + 981) > (4359 - 2262)) and v24(v98.IceColdAbility)) then
						return "ice_cold defensive 3";
					end
				end
				if ((v98.IceBlock:IsReady() and v65 and (v14:HealthPercentage() <= v72)) or ((4819 - (572 + 477)) >= (545 + 3496))) then
					if (v24(v98.IceBlock) or ((2276 + 1515) <= (193 + 1418))) then
						return "ice_block defensive 4";
					end
				end
				v136 = 88 - (84 + 2);
			end
			if ((v136 == (4 - 1)) or ((3299 + 1279) <= (2850 - (497 + 345)))) then
				if (((29 + 1096) <= (351 + 1725)) and v98.AlterTime:IsReady() and v62 and (v14:HealthPercentage() <= v69)) then
					if (v24(v98.AlterTime) or ((2076 - (605 + 728)) >= (3139 + 1260))) then
						return "alter_time defensive 7";
					end
				end
				if (((2567 - 1412) < (77 + 1596)) and v99.Healthstone:IsReady() and v85 and (v14:HealthPercentage() <= v87)) then
					if (v24(v100.Healthstone) or ((8592 - 6268) <= (522 + 56))) then
						return "healthstone defensive";
					end
				end
				v136 = 10 - 6;
			end
			if (((2845 + 922) == (4256 - (457 + 32))) and ((2 + 2) == v136)) then
				if (((5491 - (832 + 570)) == (3853 + 236)) and v84 and (v14:HealthPercentage() <= v86)) then
					if (((1163 + 3295) >= (5923 - 4249)) and (v88 == "Refreshing Healing Potion")) then
						if (((469 + 503) <= (2214 - (588 + 208))) and v99.RefreshingHealingPotion:IsReady()) then
							if (v24(v100.RefreshingHealingPotion) or ((13309 - 8371) < (6562 - (884 + 916)))) then
								return "refreshing healing potion defensive";
							end
						end
					end
					if ((v88 == "Dreamwalker's Healing Potion") or ((5241 - 2737) > (2473 + 1791))) then
						if (((2806 - (232 + 421)) == (4042 - (1569 + 320))) and v99.DreamwalkersHealingPotion:IsReady()) then
							if (v24(v100.RefreshingHealingPotion) or ((125 + 382) >= (493 + 2098))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v119()
		if (((15100 - 10619) == (5086 - (316 + 289))) and v98.RemoveCurse:IsReady() and v112.DispellableFriendlyUnit(52 - 32)) then
			if (v24(v100.RemoveCurseFocus) or ((108 + 2220) < (2146 - (666 + 787)))) then
				return "remove_curse dispel";
			end
		end
	end
	local function v120()
		v31 = v112.HandleTopTrinket(v101, v34, 465 - (360 + 65), nil);
		if (((4045 + 283) == (4582 - (79 + 175))) and v31) then
			return v31;
		end
		v31 = v112.HandleBottomTrinket(v101, v34, 63 - 23, nil);
		if (((1240 + 348) >= (4082 - 2750)) and v31) then
			return v31;
		end
	end
	local function v121()
		if (v112.TargetIsValid() or ((8038 - 3864) > (5147 - (503 + 396)))) then
			local v151 = 181 - (92 + 89);
			while true do
				if (((0 - 0) == v151) or ((2352 + 2234) <= (49 + 33))) then
					if (((15127 - 11264) == (529 + 3334)) and v98.MirrorImage:IsCastable() and v68 and v96) then
						if (v24(v98.MirrorImage) or ((642 - 360) <= (37 + 5))) then
							return "mirror_image precombat 2";
						end
					end
					if (((2202 + 2407) >= (2332 - 1566)) and v98.Frostbolt:IsCastable() and not v14:IsCasting(v98.Frostbolt)) then
						if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt)) or ((144 + 1008) == (3794 - 1306))) then
							return "frostbolt precombat 4";
						end
					end
					break;
				end
			end
		end
	end
	local function v122()
		local v137 = 1244 - (485 + 759);
		local v138;
		while true do
			if (((7917 - 4495) > (4539 - (442 + 747))) and (v137 == (1137 - (832 + 303)))) then
				if (((1823 - (88 + 858)) > (115 + 261)) and (v83 < v110)) then
					if ((v90 and ((v34 and v91) or not v91)) or ((2581 + 537) <= (77 + 1774))) then
						local v212 = 789 - (766 + 23);
						while true do
							if ((v212 == (0 - 0)) or ((225 - 60) >= (9199 - 5707))) then
								v31 = v120();
								if (((13402 - 9453) < (5929 - (1036 + 37))) and v31) then
									return v31;
								end
								break;
							end
						end
					end
				end
				if ((v89 and ((v92 and v34) or not v92) and (v83 < v110)) or ((3032 + 1244) < (5873 - 2857))) then
					if (((3690 + 1000) > (5605 - (641 + 839))) and v98.BloodFury:IsCastable()) then
						if (v24(v98.BloodFury) or ((963 - (910 + 3)) >= (2284 - 1388))) then
							return "blood_fury cd 10";
						end
					end
					if (v98.Berserking:IsCastable() or ((3398 - (1466 + 218)) >= (1360 + 1598))) then
						if (v24(v98.Berserking) or ((2639 - (556 + 592)) < (230 + 414))) then
							return "berserking cd 12";
						end
					end
					if (((1512 - (329 + 479)) < (1841 - (174 + 680))) and v98.LightsJudgment:IsCastable()) then
						if (((12775 - 9057) > (3950 - 2044)) and v24(v98.LightsJudgment, not v15:IsSpellInRange(v98.LightsJudgment))) then
							return "lights_judgment cd 14";
						end
					end
					if (v98.Fireblood:IsCastable() or ((684 + 274) > (4374 - (396 + 343)))) then
						if (((310 + 3191) <= (5969 - (29 + 1448))) and v24(v98.Fireblood)) then
							return "fireblood cd 16";
						end
					end
					if (v98.AncestralCall:IsCastable() or ((4831 - (135 + 1254)) < (9598 - 7050))) then
						if (((13423 - 10548) >= (976 + 488)) and v24(v98.AncestralCall)) then
							return "ancestral_call cd 18";
						end
					end
				end
				break;
			end
			if ((v137 == (1528 - (389 + 1138))) or ((5371 - (102 + 472)) >= (4618 + 275))) then
				if (v138 or ((306 + 245) > (1929 + 139))) then
					return v138;
				end
				if (((3659 - (320 + 1225)) > (1680 - 736)) and v98.IcyVeins:IsCastable() and v34 and v52 and v57 and (v83 < v110)) then
					if (v24(v98.IcyVeins) or ((1385 + 877) >= (4560 - (157 + 1307)))) then
						return "icy_veins cd 6";
					end
				end
				v137 = 1861 - (821 + 1038);
			end
			if ((v137 == (0 - 0)) or ((247 + 2008) >= (6282 - 2745))) then
				if ((v95 and v98.TimeWarp:IsCastable() and v14:BloodlustExhaustUp() and v98.TemporalWarp:IsAvailable() and v14:BloodlustDown() and v14:PrevGCDP(1 + 0, v98.IcyVeins)) or ((9510 - 5673) < (2332 - (834 + 192)))) then
					if (((188 + 2762) == (758 + 2192)) and v24(v98.TimeWarp, not v15:IsInRange(1 + 39))) then
						return "time_warp cd 2";
					end
				end
				v138 = v112.HandleDPSPotion(v14:BuffUp(v98.IcyVeinsBuff));
				v137 = 1 - 0;
			end
		end
	end
	local function v123()
		if ((v98.IceFloes:IsCastable() and v46 and v14:BuffDown(v98.IceFloes)) or ((5027 - (300 + 4)) < (881 + 2417))) then
			if (((2973 - 1837) >= (516 - (112 + 250))) and v24(v98.IceFloes)) then
				return "ice_floes movement";
			end
		end
		if ((v98.IceNova:IsCastable() and v48) or ((109 + 162) > (11894 - 7146))) then
			if (((2716 + 2024) >= (1631 + 1521)) and v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova))) then
				return "ice_nova movement";
			end
		end
		if ((v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (23 + 7)) and (v103 >= (1 + 1))) or ((1916 + 662) >= (4804 - (1001 + 413)))) then
			if (((91 - 50) <= (2543 - (244 + 638))) and v24(v98.ArcaneExplosion, not v15:IsInRange(701 - (627 + 66)))) then
				return "arcane_explosion movement";
			end
		end
		if (((1790 - 1189) < (4162 - (512 + 90))) and v98.FireBlast:IsCastable() and v40) then
			if (((2141 - (1665 + 241)) < (1404 - (373 + 344))) and v24(v98.FireBlast, not v15:IsSpellInRange(v98.FireBlast))) then
				return "fire_blast movement";
			end
		end
		if (((2052 + 2497) > (306 + 847)) and v98.IceLance:IsCastable() and v47) then
			if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((12328 - 7654) < (7905 - 3233))) then
				return "ice_lance movement";
			end
		end
	end
	local function v124()
		local v139 = 1099 - (35 + 1064);
		while true do
			if (((2669 + 999) < (9758 - 5197)) and (v139 == (1 + 0))) then
				if ((v18:IsActive() and v44 and v98.Freeze:IsReady() and v114() and (v115() == (1236 - (298 + 938))) and ((not v98.GlacialSpike:IsAvailable() and not v98.Snowstorm:IsAvailable()) or v14:PrevGCDP(1260 - (233 + 1026), v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108)))) or ((2121 - (636 + 1030)) == (1844 + 1761))) then
					if (v24(v100.FreezePet, not v15:IsSpellInRange(v98.Freeze)) or ((2602 + 61) == (984 + 2328))) then
						return "freeze aoe 10";
					end
				end
				if (((289 + 3988) <= (4696 - (55 + 166))) and v98.IceNova:IsCastable() and v48 and v114() and not v14:PrevOffGCDP(1 + 0, v98.Freeze) and (v14:PrevGCDP(1 + 0, v98.GlacialSpike) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (3 - 2))))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((1167 - (36 + 261)) == (2078 - 889))) then
						return "ice_nova aoe 11";
					end
				end
				if (((2921 - (34 + 1334)) <= (1205 + 1928)) and v98.FrostNova:IsCastable() and v42 and v114() and not v14:PrevOffGCDP(1 + 0, v98.Freeze) and ((v14:PrevGCDP(1284 - (1035 + 248), v98.GlacialSpike) and (v106 == (21 - (20 + 1)))) or (v98.ConeofCold:CooldownUp() and (v14:BuffStack(v98.SnowstormBuff) == v108) and (v111 < (1 + 0))))) then
					if (v24(v98.FrostNova) or ((2556 - (134 + 185)) >= (4644 - (549 + 584)))) then
						return "frost_nova aoe 12";
					end
				end
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and (v14:BuffStackP(v98.SnowstormBuff) == v108)) or ((2009 - (314 + 371)) > (10367 - 7347))) then
					if (v24(v98.ConeofCold, not v15:IsInRange(976 - (478 + 490))) or ((1585 + 1407) == (3053 - (786 + 386)))) then
						return "cone_of_cold aoe 14";
					end
				end
				v139 = 6 - 4;
			end
			if (((4485 - (1055 + 324)) > (2866 - (1093 + 247))) and (v139 == (4 + 0))) then
				if (((318 + 2705) < (15364 - 11494)) and v98.Frostbolt:IsCastable() and v41) then
					if (((484 - 341) > (210 - 136)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt aoe 32";
					end
				end
				if (((45 - 27) < (752 + 1360)) and v14:IsMoving() and v94) then
					local v206 = 0 - 0;
					while true do
						if (((3781 - 2684) <= (1228 + 400)) and (v206 == (0 - 0))) then
							v31 = v123();
							if (((5318 - (364 + 324)) == (12692 - 8062)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
			if (((8494 - 4954) > (890 + 1793)) and (v139 == (12 - 9))) then
				if (((7677 - 2883) >= (9946 - 6671)) and v98.IceLance:IsCastable() and v47 and (v14:BuffUp(v98.FingersofFrostBuff) or (v115() > v98.IceLance:TravelTime()) or v29(v106))) then
					if (((2752 - (1249 + 19)) == (1340 + 144)) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
						return "ice_lance aoe 22";
					end
				end
				if (((5573 - 4141) < (4641 - (686 + 400))) and v98.IceNova:IsCastable() and v48 and (v102 >= (4 + 0)) and ((not v98.Snowstorm:IsAvailable() and not v98.GlacialSpike:IsAvailable()) or not v114())) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((1294 - (73 + 156)) > (17 + 3561))) then
						return "ice_nova aoe 23";
					end
				end
				if ((v98.DragonsBreath:IsCastable() and v39 and (v103 >= (818 - (721 + 90)))) or ((54 + 4741) < (4568 - 3161))) then
					if (((2323 - (224 + 246)) < (7796 - 2983)) and v24(v98.DragonsBreath, not v15:IsInRange(18 - 8))) then
						return "dragons_breath aoe 26";
					end
				end
				if ((v98.ArcaneExplosion:IsCastable() and v36 and (v14:ManaPercentage() > (6 + 24)) and (v103 >= (1 + 6))) or ((2072 + 749) < (4832 - 2401))) then
					if (v24(v98.ArcaneExplosion, not v15:IsInRange(26 - 18)) or ((3387 - (203 + 310)) < (4174 - (1238 + 755)))) then
						return "arcane_explosion aoe 28";
					end
				end
				v139 = 1 + 3;
			end
			if ((v139 == (1536 - (709 + 825))) or ((4954 - 2265) <= (498 - 155))) then
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110)) or ((2733 - (196 + 668)) == (7931 - 5922))) then
					if (v24(v98.ShiftingPower, not v15:IsInRange(82 - 42), true) or ((4379 - (171 + 662)) < (2415 - (4 + 89)))) then
						return "shifting_power aoe 16";
					end
				end
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (17 - 12)) and (v98.Blizzard:CooldownRemains() > v111)) or ((759 + 1323) == (20963 - 16190))) then
					if (((1273 + 1971) > (2541 - (35 + 1451))) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike aoe 18";
					end
				end
				if ((v98.Flurry:IsCastable() and v43 and not v114() and (v106 == (1453 - (28 + 1425))) and (v14:PrevGCDP(1994 - (941 + 1052), v98.GlacialSpike) or (v98.Flurry:ChargesFractional() > (1.8 + 0)))) or ((4827 - (822 + 692)) <= (2538 - 760))) then
					if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((670 + 751) >= (2401 - (45 + 252)))) then
						return "flurry aoe 20";
					end
				end
				if (((1793 + 19) <= (1119 + 2130)) and v98.Flurry:IsCastable() and v43 and (v106 == (0 - 0)) and (v14:BuffUp(v98.BrainFreezeBuff) or v14:BuffUp(v98.FingersofFrostBuff))) then
					if (((2056 - (114 + 319)) <= (2809 - 852)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry aoe 21";
					end
				end
				v139 = 3 - 0;
			end
			if (((2813 + 1599) == (6572 - 2160)) and (v139 == (0 - 0))) then
				if (((3713 - (556 + 1407)) >= (2048 - (741 + 465))) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v14:PrevGCDP(466 - (170 + 295), v98.CometStorm) or (v14:PrevGCDP(1 + 0, v98.FrozenOrb) and not v98.CometStorm:IsAvailable()))) then
					if (((4016 + 356) > (4554 - 2704)) and v24(v98.ConeofCold, not v15:IsInRange(7 + 1))) then
						return "cone_of_cold aoe 2";
					end
				end
				if (((149 + 83) < (465 + 356)) and v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (not v14:PrevGCDP(1231 - (957 + 273), v98.GlacialSpike) or not v114())) then
					if (((139 + 379) < (362 + 540)) and v24(v100.FrozenOrbCast, not v15:IsInRange(152 - 112))) then
						return "frozen_orb aoe 4";
					end
				end
				if (((7889 - 4895) > (2620 - 1762)) and v98.Blizzard:IsCastable() and v38 and (not v14:PrevGCDP(4 - 3, v98.GlacialSpike) or not v114())) then
					if (v24(v100.BlizzardCursor, not v15:IsInRange(1820 - (389 + 1391))) or ((2356 + 1399) <= (96 + 819))) then
						return "blizzard aoe 6";
					end
				end
				if (((8983 - 5037) > (4694 - (783 + 168))) and v98.CometStorm:IsCastable() and ((v59 and v34) or not v59) and v54 and (v83 < v110) and not v14:PrevGCDP(3 - 2, v98.GlacialSpike) and (not v98.ColdestSnap:IsAvailable() or (v98.ConeofCold:CooldownUp() and (v98.FrozenOrb:CooldownRemains() > (25 + 0))) or (v98.ConeofCold:CooldownRemains() > (331 - (309 + 2))))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((4099 - 2764) >= (4518 - (1090 + 122)))) then
						return "comet_storm aoe 8";
					end
				end
				v139 = 1 + 0;
			end
		end
	end
	local function v125()
		local v140 = 0 - 0;
		while true do
			if (((3316 + 1528) > (3371 - (628 + 490))) and (v140 == (1 + 0))) then
				if (((1118 - 666) == (2065 - 1613)) and v98.RayofFrost:IsCastable() and (v106 == (775 - (431 + 343))) and v49) then
					local v207 = 0 - 0;
					while true do
						if ((v207 == (0 - 0)) or ((3601 + 956) < (267 + 1820))) then
							if (((5569 - (556 + 1139)) == (3889 - (6 + 9))) and v112.CastTargetIf(v98.RayofFrost, v104, "max", v116, nil, not v15:IsSpellInRange(v98.RayofFrost))) then
								return "ray_of_frost cleave 8";
							end
							if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((355 + 1583) > (2529 + 2406))) then
								return "ray_of_frost cleave 8";
							end
							break;
						end
					end
				end
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (174 - (28 + 141))) and (v98.Flurry:CooldownUp() or (v106 > (0 + 0)))) or ((5252 - 997) < (2425 + 998))) then
					if (((2771 - (486 + 831)) <= (6482 - 3991)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike cleave 10";
					end
				end
				if ((v98.FrozenOrb:IsCastable() and ((v58 and v34) or not v58) and v53 and (v83 < v110) and (v14:BuffStackP(v98.FingersofFrostBuff) < (6 - 4)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) or ((786 + 3371) <= (8862 - 6059))) then
					if (((6116 - (668 + 595)) >= (2684 + 298)) and v24(v100.FrozenOrbCast, not v15:IsSpellInRange(v98.FrozenOrb))) then
						return "frozen_orb cleave 12";
					end
				end
				v140 = 1 + 1;
			end
			if (((11273 - 7139) > (3647 - (23 + 267))) and (v140 == (1946 - (1129 + 815)))) then
				if ((v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (397 - (371 + 16))) and (v98.FrozenOrb:CooldownRemains() > (1760 - (1326 + 424))) and (v106 == (0 - 0)) and (v103 >= (10 - 7))) or ((3535 - (88 + 30)) < (3305 - (720 + 51)))) then
					if (v24(v98.ConeofCold) or ((6054 - 3332) <= (1940 - (421 + 1355)))) then
						return "cone_of_cold cleave 14";
					end
				end
				if ((v98.Blizzard:IsCastable() and v38 and (v103 >= (2 - 0)) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v103 >= (2 + 1)))) or ((3491 - (286 + 797)) < (7709 - 5600))) then
					if (v24(v100.BlizzardCursor, not v15:IsSpellInRange(v98.Blizzard)) or ((53 - 20) == (1894 - (397 + 42)))) then
						return "blizzard cleave 16";
					end
				end
				if ((v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (((v98.FrozenOrb:CooldownRemains() > (4 + 6)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (810 - (24 + 776)))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (15 - 5)))) or (v98.IcyVeins:CooldownRemains() < (805 - (222 + 563))))) or ((975 - 532) >= (2891 + 1124))) then
					if (((3572 - (23 + 167)) > (1964 - (690 + 1108))) and v24(v98.ShiftingPower, not v15:IsSpellInRange(v98.ShiftingPower), true)) then
						return "shifting_power cleave 18";
					end
				end
				v140 = 2 + 1;
			end
			if ((v140 == (0 + 0)) or ((1128 - (40 + 808)) == (504 + 2555))) then
				if (((7192 - 5311) > (1236 + 57)) and v98.CometStorm:IsCastable() and (v14:PrevGCDP(1 + 0, v98.Flurry) or v14:PrevGCDP(1 + 0, v98.ConeofCold)) and ((v59 and v34) or not v59) and v54 and (v83 < v110)) then
					if (((2928 - (47 + 524)) == (1530 + 827)) and v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm))) then
						return "comet_storm cleave 2";
					end
				end
				if (((336 - 213) == (183 - 60)) and v98.Flurry:IsCastable() and v43 and ((v14:PrevGCDP(2 - 1, v98.Frostbolt) and (v107 >= (1729 - (1165 + 561)))) or v14:PrevGCDP(1 + 0, v98.GlacialSpike) or ((v107 >= (9 - 6)) and (v107 < (2 + 3)) and (v98.Flurry:ChargesFractional() == (481 - (341 + 138)))))) then
					local v208 = 0 + 0;
					while true do
						if ((v208 == (0 - 0)) or ((1382 - (89 + 237)) >= (10911 - 7519))) then
							if (v112.CastTargetIf(v98.Flurry, v104, "min", v116, nil, not v15:IsSpellInRange(v98.Flurry)) or ((2275 - 1194) < (1956 - (581 + 300)))) then
								return "flurry cleave 4";
							end
							if (v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry)) or ((2269 - (855 + 365)) >= (10526 - 6094))) then
								return "flurry cleave 4";
							end
							break;
						end
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and (v98.WintersChillDebuff:AuraActiveCount() == (0 + 0)) and (v107 == (1239 - (1030 + 205))) and v14:BuffUp(v98.FingersofFrostBuff)) or ((4477 + 291) <= (788 + 58))) then
					local v209 = 286 - (156 + 130);
					while true do
						if ((v209 == (0 - 0)) or ((5659 - 2301) <= (2908 - 1488))) then
							if (v112.CastTargetIf(v98.IceLance, v104, "max", v117, nil, not v15:IsSpellInRange(v98.IceLance)) or ((986 + 2753) <= (1753 + 1252))) then
								return "ice_lance cleave 6";
							end
							if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((1728 - (10 + 59)) >= (604 + 1530))) then
								return "ice_lance cleave 6";
							end
							break;
						end
					end
				end
				v140 = 4 - 3;
			end
			if ((v140 == (1166 - (671 + 492))) or ((2596 + 664) < (3570 - (369 + 846)))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (2 + 3))) or ((571 + 98) == (6168 - (1036 + 909)))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((1346 + 346) < (987 - 399))) then
						return "glacial_spike cleave 20";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and ((v14:BuffStackP(v98.FingersofFrostBuff) and not v14:PrevGCDP(204 - (11 + 192), v98.GlacialSpike)) or (v106 > (0 + 0)))) or ((4972 - (135 + 40)) < (8845 - 5194))) then
					local v210 = 0 + 0;
					while true do
						if (((0 - 0) == v210) or ((6261 - 2084) > (5026 - (50 + 126)))) then
							if (v112.CastTargetIf(v98.IceLance, v104, "max", v116, nil, not v15:IsSpellInRange(v98.IceLance)) or ((1113 - 713) > (246 + 865))) then
								return "ice_lance cleave 22";
							end
							if (((4464 - (1233 + 180)) > (1974 - (522 + 447))) and v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance))) then
								return "ice_lance cleave 22";
							end
							break;
						end
					end
				end
				if (((5114 - (107 + 1314)) <= (2034 + 2348)) and v98.IceNova:IsCastable() and v48 and (v103 >= (11 - 7))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((1394 + 1888) > (8141 - 4041))) then
						return "ice_nova cleave 24";
					end
				end
				v140 = 15 - 11;
			end
			if ((v140 == (1914 - (716 + 1194))) or ((62 + 3518) < (305 + 2539))) then
				if (((592 - (74 + 429)) < (8661 - 4171)) and v98.Frostbolt:IsCastable() and v41) then
					if (v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true) or ((2470 + 2513) < (4138 - 2330))) then
						return "frostbolt cleave 26";
					end
				end
				if (((2709 + 1120) > (11619 - 7850)) and v14:IsMoving() and v94) then
					local v211 = 0 - 0;
					while true do
						if (((1918 - (279 + 154)) <= (3682 - (454 + 324))) and (v211 == (0 + 0))) then
							v31 = v123();
							if (((4286 - (12 + 5)) == (2302 + 1967)) and v31) then
								return v31;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v141 = 0 - 0;
		while true do
			if (((144 + 243) <= (3875 - (277 + 816))) and ((0 - 0) == v141)) then
				if ((v98.CometStorm:IsCastable() and v54 and ((v59 and v34) or not v59) and (v83 < v110) and (v14:PrevGCDP(1184 - (1058 + 125), v98.Flurry) or v14:PrevGCDP(1 + 0, v98.ConeofCold))) or ((2874 - (815 + 160)) <= (3934 - 3017))) then
					if (v24(v98.CometStorm, not v15:IsSpellInRange(v98.CometStorm)) or ((10235 - 5923) <= (209 + 667))) then
						return "comet_storm single 2";
					end
				end
				if (((6524 - 4292) <= (4494 - (41 + 1857))) and v98.Flurry:IsCastable() and (v106 == (1893 - (1222 + 671))) and v15:DebuffDown(v98.WintersChillDebuff) and ((v14:PrevGCDP(2 - 1, v98.Frostbolt) and (v107 >= (3 - 0))) or (v14:PrevGCDP(1183 - (229 + 953), v98.Frostbolt) and v14:BuffUp(v98.BrainFreezeBuff)) or v14:PrevGCDP(1775 - (1111 + 663), v98.GlacialSpike) or (v98.GlacialSpike:IsAvailable() and (v107 == (1583 - (874 + 705))) and v14:BuffDown(v98.FingersofFrostBuff)))) then
					if (((294 + 1801) < (2515 + 1171)) and v24(v98.Flurry, not v15:IsSpellInRange(v98.Flurry))) then
						return "flurry single 4";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and v98.GlacialSpike:IsAvailable() and not v98.GlacialSpike:InFlight() and (v106 == (0 - 0)) and (v107 == (1 + 3)) and v14:BuffUp(v98.FingersofFrostBuff)) or ((2274 - (642 + 37)) >= (1021 + 3453))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((739 + 3880) < (7235 - 4353))) then
						return "ice_lance single 6";
					end
				end
				v141 = 455 - (233 + 221);
			end
			if (((4 - 2) == v141) or ((259 + 35) >= (6372 - (718 + 823)))) then
				if (((1277 + 752) <= (3889 - (266 + 539))) and v98.ConeofCold:IsCastable() and v55 and ((v60 and v34) or not v60) and (v83 < v110) and v98.ColdestSnap:IsAvailable() and (v98.CometStorm:CooldownRemains() > (28 - 18)) and (v98.FrozenOrb:CooldownRemains() > (1235 - (636 + 589))) and (v106 == (0 - 0)) and (v102 >= (5 - 2))) then
					if (v24(v98.ConeofCold, not v15:IsInRange(7 + 1)) or ((741 + 1296) == (3435 - (657 + 358)))) then
						return "cone_of_cold single 14";
					end
				end
				if (((11803 - 7345) > (8894 - 4990)) and v98.Blizzard:IsCastable() and v38 and (v102 >= (1189 - (1151 + 36))) and v98.IceCaller:IsAvailable() and v98.FreezingRain:IsAvailable() and ((not v98.SplinteringCold:IsAvailable() and not v98.RayofFrost:IsAvailable()) or v14:BuffUp(v98.FreezingRainBuff) or (v102 >= (3 + 0)))) then
					if (((115 + 321) >= (367 - 244)) and v24(v100.BlizzardCursor, not v15:IsInRange(1872 - (1552 + 280)))) then
						return "blizzard single 16";
					end
				end
				if (((1334 - (64 + 770)) < (1233 + 583)) and v98.ShiftingPower:IsCastable() and v56 and ((v61 and v34) or not v61) and (v83 < v110) and (v106 == (0 - 0)) and (((v98.FrozenOrb:CooldownRemains() > (2 + 8)) and (not v98.CometStorm:IsAvailable() or (v98.CometStorm:CooldownRemains() > (1253 - (157 + 1086)))) and (not v98.RayofFrost:IsAvailable() or (v98.RayofFrost:CooldownRemains() > (20 - 10)))) or (v98.IcyVeins:CooldownRemains() < (87 - 67)))) then
					if (((5482 - 1908) == (4877 - 1303)) and v24(v98.ShiftingPower, not v15:IsInRange(859 - (599 + 220)))) then
						return "shifting_power single 18";
					end
				end
				v141 = 5 - 2;
			end
			if (((2152 - (1813 + 118)) < (286 + 104)) and (v141 == (1220 - (841 + 376)))) then
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (6 - 1))) or ((515 + 1698) <= (3878 - 2457))) then
					if (((3917 - (464 + 395)) < (12472 - 7612)) and v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike))) then
						return "glacial_spike single 20";
					end
				end
				if ((v98.IceLance:IsReady() and v47 and ((v14:BuffUp(v98.FingersofFrostBuff) and not v14:PrevGCDP(1 + 0, v98.GlacialSpike) and not v98.GlacialSpike:InFlight()) or v29(v106))) or ((2133 - (467 + 370)) >= (9187 - 4741))) then
					if (v24(v98.IceLance, not v15:IsSpellInRange(v98.IceLance)) or ((1023 + 370) > (15388 - 10899))) then
						return "ice_lance single 22";
					end
				end
				if ((v98.IceNova:IsCastable() and v48 and (v103 >= (1 + 3))) or ((10292 - 5868) < (547 - (150 + 370)))) then
					if (v24(v98.IceNova, not v15:IsSpellInRange(v98.IceNova)) or ((3279 - (74 + 1208)) > (9383 - 5568))) then
						return "ice_nova single 24";
					end
				end
				v141 = 18 - 14;
			end
			if (((2466 + 999) > (2303 - (14 + 376))) and ((1 - 0) == v141)) then
				if (((475 + 258) < (1598 + 221)) and v98.RayofFrost:IsCastable() and v49 and (v15:DebuffRemains(v98.WintersChillDebuff) > v98.RayofFrost:CastTime()) and (v106 == (1 + 0))) then
					if (v24(v98.RayofFrost, not v15:IsSpellInRange(v98.RayofFrost)) or ((12877 - 8482) == (3578 + 1177))) then
						return "ray_of_frost single 8";
					end
				end
				if ((v98.GlacialSpike:IsReady() and v45 and (v107 == (83 - (23 + 55))) and ((v98.Flurry:Charges() >= (2 - 1)) or ((v106 > (0 + 0)) and (v98.GlacialSpike:CastTime() < v15:DebuffRemains(v98.WintersChillDebuff))))) or ((3407 + 386) < (3672 - 1303))) then
					if (v24(v98.GlacialSpike, not v15:IsSpellInRange(v98.GlacialSpike)) or ((1285 + 2799) == (1166 - (652 + 249)))) then
						return "glacial_spike single 10";
					end
				end
				if (((11662 - 7304) == (6226 - (708 + 1160))) and v98.FrozenOrb:IsCastable() and v53 and ((v58 and v34) or not v58) and (v83 < v110) and (v106 == (0 - 0)) and (v14:BuffStackP(v98.FingersofFrostBuff) < (3 - 1)) and (not v98.RayofFrost:IsAvailable() or v98.RayofFrost:CooldownDown())) then
					if (v24(v100.FrozenOrbCast, not v15:IsInRange(67 - (10 + 17))) or ((705 + 2433) < (2725 - (1400 + 332)))) then
						return "frozen_orb single 12";
					end
				end
				v141 = 3 - 1;
			end
			if (((5238 - (242 + 1666)) > (995 + 1328)) and (v141 == (2 + 2))) then
				if ((v89 and ((v92 and v34) or not v92)) or ((3091 + 535) == (4929 - (850 + 90)))) then
					if (v98.BagofTricks:IsCastable() or ((1603 - 687) == (4061 - (360 + 1030)))) then
						if (((241 + 31) == (767 - 495)) and v24(v98.BagofTricks, not v15:IsSpellInRange(v98.BagofTricks))) then
							return "bag_of_tricks cd 40";
						end
					end
				end
				if (((5845 - 1596) <= (6500 - (909 + 752))) and v98.Frostbolt:IsCastable() and v41) then
					if (((4000 - (109 + 1114)) < (5858 - 2658)) and v24(v98.Frostbolt, not v15:IsSpellInRange(v98.Frostbolt), true)) then
						return "frostbolt single 26";
					end
				end
				if (((37 + 58) < (2199 - (6 + 236))) and v14:IsMoving() and v94) then
					v31 = v123();
					if (((521 + 305) < (1383 + 334)) and v31) then
						return v31;
					end
				end
				break;
			end
		end
	end
	local function v127()
		local v142 = 0 - 0;
		while true do
			if (((2490 - 1064) >= (2238 - (1076 + 57))) and (v142 == (1 + 2))) then
				v48 = EpicSettings.Settings['useIceNova'];
				v49 = EpicSettings.Settings['useRayOfFrost'];
				v50 = EpicSettings.Settings['useCounterspell'];
				v51 = EpicSettings.Settings['useBlastWave'];
				v142 = 693 - (579 + 110);
			end
			if (((218 + 2536) <= (2988 + 391)) and (v142 == (2 + 0))) then
				v44 = EpicSettings.Settings['useFreezePet'];
				v45 = EpicSettings.Settings['useGlacialSpike'];
				v46 = EpicSettings.Settings['useIceFloes'];
				v47 = EpicSettings.Settings['useIceLance'];
				v142 = 410 - (174 + 233);
			end
			if ((v142 == (0 - 0)) or ((6892 - 2965) == (629 + 784))) then
				v36 = EpicSettings.Settings['useArcaneExplosion'];
				v37 = EpicSettings.Settings['useArcaneIntellect'];
				v38 = EpicSettings.Settings['useBlizzard'];
				v39 = EpicSettings.Settings['useDragonsBreath'];
				v142 = 1175 - (663 + 511);
			end
			if ((v142 == (7 + 0)) or ((251 + 903) <= (2429 - 1641))) then
				v64 = EpicSettings.Settings['useGreaterInvisibility'];
				v65 = EpicSettings.Settings['useIceBlock'];
				v66 = EpicSettings.Settings['useIceCold'];
				v67 = EpicSettings.Settings['useMassBarrier'];
				v142 = 5 + 3;
			end
			if ((v142 == (20 - 11)) or ((3977 - 2334) > (1613 + 1766))) then
				v71 = EpicSettings.Settings['greaterInvisibilityHP'] or (0 - 0);
				v72 = EpicSettings.Settings['iceBlockHP'] or (0 + 0);
				v74 = EpicSettings.Settings['mirrorImageHP'] or (0 + 0);
				v75 = EpicSettings.Settings['massBarrierHP'] or (722 - (478 + 244));
				v142 = 527 - (440 + 77);
			end
			if ((v142 == (5 + 5)) or ((10258 - 7455) > (6105 - (655 + 901)))) then
				v93 = EpicSettings.Settings['useSpellStealTarget'];
				v94 = EpicSettings.Settings['useSpellsWhileMoving'];
				v95 = EpicSettings.Settings['useTimeWarpWithTalent'];
				v96 = EpicSettings.Settings['mirrorImageBeforePull'];
				v142 = 3 + 8;
			end
			if ((v142 == (1 + 0)) or ((149 + 71) >= (12174 - 9152))) then
				v40 = EpicSettings.Settings['useFireBlast'];
				v41 = EpicSettings.Settings['useFrostbolt'];
				v42 = EpicSettings.Settings['useFrostNova'];
				v43 = EpicSettings.Settings['useFlurry'];
				v142 = 1447 - (695 + 750);
			end
			if (((9636 - 6814) == (4354 - 1532)) and (v142 == (44 - 33))) then
				v97 = EpicSettings.Settings['useRemoveCurseWithAfflicted'];
				break;
			end
			if (((356 - (285 + 66)) == v142) or ((2473 - 1412) == (3167 - (682 + 628)))) then
				v56 = EpicSettings.Settings['useShiftingPower'];
				v57 = EpicSettings.Settings['icyVeinsWithCD'];
				v58 = EpicSettings.Settings['frozenOrbWithCD'];
				v59 = EpicSettings.Settings['cometStormWithCD'];
				v142 = 1 + 5;
			end
			if (((3059 - (176 + 123)) > (571 + 793)) and (v142 == (6 + 2))) then
				v68 = EpicSettings.Settings['useMirrorImage'];
				v69 = EpicSettings.Settings['alterTimeHP'] or (269 - (239 + 30));
				v70 = EpicSettings.Settings['iceBarrierHP'] or (0 + 0);
				v73 = EpicSettings.Settings['iceColdHP'] or (0 + 0);
				v142 = 15 - 6;
			end
			if (((18 - 12) == v142) or ((5217 - (306 + 9)) <= (12545 - 8950))) then
				v60 = EpicSettings.Settings['coneOfColdWithCD'];
				v61 = EpicSettings.Settings['shiftingPowerWithCD'];
				v62 = EpicSettings.Settings['useAlterTime'];
				v63 = EpicSettings.Settings['useIceBarrier'];
				v142 = 2 + 5;
			end
			if ((v142 == (3 + 1)) or ((1855 + 1997) == (837 - 544))) then
				v52 = EpicSettings.Settings['useIcyVeins'];
				v53 = EpicSettings.Settings['useFrozenOrb'];
				v54 = EpicSettings.Settings['useCometStorm'];
				v55 = EpicSettings.Settings['useConeOfCold'];
				v142 = 1380 - (1140 + 235);
			end
		end
	end
	local function v128()
		local v143 = 0 + 0;
		while true do
			if ((v143 == (4 + 0)) or ((401 + 1158) == (4640 - (33 + 19)))) then
				v79 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v143 == (1 + 0)) or ((13439 - 8955) == (348 + 440))) then
				v77 = EpicSettings.Settings['DispelDebuffs'];
				v76 = EpicSettings.Settings['DispelBuffs'];
				v90 = EpicSettings.Settings['useTrinkets'];
				v89 = EpicSettings.Settings['useRacials'];
				v143 = 3 - 1;
			end
			if (((4284 + 284) >= (4596 - (586 + 103))) and (v143 == (1 + 2))) then
				v87 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v86 = EpicSettings.Settings['healingPotionHP'] or (1488 - (1309 + 179));
				v88 = EpicSettings.Settings['HealingPotionName'] or "";
				v78 = EpicSettings.Settings['handleAfflicted'];
				v143 = 6 - 2;
			end
			if (((543 + 703) < (9318 - 5848)) and (v143 == (2 + 0))) then
				v91 = EpicSettings.Settings['trinketsWithCD'];
				v92 = EpicSettings.Settings['racialsWithCD'];
				v85 = EpicSettings.Settings['useHealthstone'];
				v84 = EpicSettings.Settings['useHealingPotion'];
				v143 = 5 - 2;
			end
			if (((8105 - 4037) >= (1581 - (295 + 314))) and (v143 == (0 - 0))) then
				v83 = EpicSettings.Settings['fightRemainsCheck'] or (1962 - (1300 + 662));
				v80 = EpicSettings.Settings['InterruptWithStun'];
				v81 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v82 = EpicSettings.Settings['InterruptThreshold'];
				v143 = 3 - 2;
			end
		end
	end
	local function v129()
		v127();
		v128();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v35 = EpicSettings.Toggles['dispel'];
		if (((2248 - (1178 + 577)) < (2022 + 1871)) and v14:IsDeadOrGhost()) then
			return v31;
		end
		v104 = v15:GetEnemiesInSplashRange(14 - 9);
		v105 = v14:GetEnemiesInRange(1445 - (851 + 554));
		if (v33 or ((1303 + 170) >= (9240 - 5908))) then
			v102 = v30(v15:GetEnemiesInSplashRangeCount(10 - 5), #v105);
			v103 = v30(v15:GetEnemiesInSplashRangeCount(307 - (115 + 187)), #v105);
		else
			local v152 = 0 + 0;
			while true do
				if ((v152 == (0 + 0)) or ((15963 - 11912) <= (2318 - (160 + 1001)))) then
					v102 = 1 + 0;
					v103 = 1 + 0;
					break;
				end
			end
		end
		if (((1235 - 631) < (3239 - (237 + 121))) and not v14:AffectingCombat()) then
			if ((v98.ArcaneIntellect:IsCastable() and v37 and (v14:BuffDown(v98.ArcaneIntellect, true) or v112.GroupBuffMissing(v98.ArcaneIntellect))) or ((1797 - (525 + 372)) == (6402 - 3025))) then
				if (((14650 - 10191) > (733 - (96 + 46))) and v24(v98.ArcaneIntellect)) then
					return "arcane_intellect";
				end
			end
		end
		if (((4175 - (643 + 134)) >= (865 + 1530)) and (v112.TargetIsValid() or v14:AffectingCombat())) then
			local v153 = 0 - 0;
			while true do
				if ((v153 == (0 - 0)) or ((2094 + 89) >= (5541 - 2717))) then
					v109 = v10.BossFightRemains(nil, true);
					v110 = v109;
					v153 = 1 - 0;
				end
				if (((2655 - (316 + 403)) == (1287 + 649)) and (v153 == (5 - 3))) then
					v107 = v14:BuffStackP(v98.IciclesBuff);
					v111 = v14:GCD();
					break;
				end
				if ((v153 == (1 + 0)) or ((12168 - 7336) < (3057 + 1256))) then
					if (((1318 + 2770) > (13423 - 9549)) and (v110 == (53064 - 41953))) then
						v110 = v10.FightRemains(v105, false);
					end
					v106 = v15:DebuffStack(v98.WintersChillDebuff);
					v153 = 3 - 1;
				end
			end
		end
		if (((248 + 4084) == (8527 - 4195)) and v112.TargetIsValid()) then
			local v154 = 0 + 0;
			while true do
				if (((11765 - 7766) >= (2917 - (12 + 5))) and ((15 - 11) == v154)) then
					if ((v14:AffectingCombat() and v112.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or ((5387 - 2862) > (8638 - 4574))) then
						local v213 = 0 - 0;
						while true do
							if (((888 + 3483) == (6344 - (1656 + 317))) and (v213 == (3 + 0))) then
								if (v94 or ((214 + 52) > (13257 - 8271))) then
									v31 = v123();
									if (((9798 - 7807) >= (1279 - (5 + 349))) and v31) then
										return v31;
									end
								end
								break;
							end
							if (((2161 - 1706) < (3324 - (266 + 1005))) and (v213 == (1 + 0))) then
								if ((v33 and (v103 == (6 - 4))) or ((1087 - 261) == (6547 - (561 + 1135)))) then
									v31 = v125();
									if (((237 - 54) == (601 - 418)) and v31) then
										return v31;
									end
									if (((2225 - (507 + 559)) <= (4486 - 2698)) and v24(v98.Pool)) then
										return "pool for Cleave()";
									end
								end
								v31 = v126();
								v213 = 6 - 4;
							end
							if (((390 - (212 + 176)) == v213) or ((4412 - (250 + 655)) > (11774 - 7456))) then
								if (v31 or ((5373 - 2298) <= (4638 - 1673))) then
									return v31;
								end
								if (((3321 - (1869 + 87)) <= (6974 - 4963)) and v24(v98.Pool)) then
									return "pool for ST()";
								end
								v213 = 1904 - (484 + 1417);
							end
							if (((0 - 0) == v213) or ((4651 - 1875) > (4348 - (48 + 725)))) then
								if (v34 or ((4171 - 1617) == (12888 - 8084))) then
									v31 = v122();
									if (((1498 + 1079) == (6886 - 4309)) and v31) then
										return v31;
									end
								end
								if ((v33 and (((v103 >= (2 + 5)) and not v14:HasTier(9 + 21, 855 - (152 + 701))) or ((v103 >= (1314 - (430 + 881))) and v98.IceCaller:IsAvailable()))) or ((3 + 3) >= (2784 - (557 + 338)))) then
									local v218 = 0 + 0;
									while true do
										if (((1425 - 919) <= (6625 - 4733)) and (v218 == (0 - 0))) then
											v31 = v124();
											if (v31 or ((4327 - 2319) > (3019 - (499 + 302)))) then
												return v31;
											end
											v218 = 867 - (39 + 827);
										end
										if (((1045 - 666) <= (9261 - 5114)) and (v218 == (3 - 2))) then
											if (v24(v98.Pool) or ((6930 - 2416) <= (87 + 922))) then
												return "pool for Aoe()";
											end
											break;
										end
									end
								end
								v213 = 2 - 1;
							end
						end
					end
					break;
				end
				if ((v154 == (1 + 1)) or ((5531 - 2035) == (1296 - (103 + 1)))) then
					if (v14:AffectingCombat() or v77 or ((762 - (475 + 79)) == (6396 - 3437))) then
						local v214 = v77 and v98.RemoveCurse:IsReady() and v35;
						v31 = v112.FocusUnit(v214, v100, 64 - 44, nil, 3 + 17);
						if (((3765 + 512) >= (2816 - (1395 + 108))) and v31) then
							return v31;
						end
					end
					if (((7527 - 4940) < (4378 - (7 + 1197))) and v78) then
						if (v97 or ((1797 + 2323) <= (767 + 1431))) then
							v31 = v112.HandleAfflicted(v98.RemoveCurse, v100.RemoveCurseMouseover, 349 - (27 + 292));
							if (v31 or ((4676 - 3080) == (1093 - 235))) then
								return v31;
							end
						end
					end
					v154 = 12 - 9;
				end
				if (((6350 - 3130) == (6132 - 2912)) and (v154 == (142 - (43 + 96)))) then
					if (v79 or ((5718 - 4316) > (8184 - 4564))) then
						local v215 = 0 + 0;
						while true do
							if (((727 + 1847) == (5087 - 2513)) and ((0 + 0) == v215)) then
								v31 = v112.HandleIncorporeal(v98.Polymorph, v100.PolymorphMouseOver, 56 - 26, true);
								if (((567 + 1231) < (203 + 2554)) and v31) then
									return v31;
								end
								break;
							end
						end
					end
					if ((v98.Spellsteal:IsAvailable() and v93 and v98.Spellsteal:IsReady() and v35 and v76 and not v14:IsCasting() and not v14:IsChanneling() and v112.UnitHasMagicBuff(v15)) or ((2128 - (1414 + 337)) > (4544 - (1642 + 298)))) then
						if (((1480 - 912) < (2620 - 1709)) and v24(v98.Spellsteal, not v15:IsSpellInRange(v98.Spellsteal))) then
							return "spellsteal damage";
						end
					end
					v154 = 11 - 7;
				end
				if (((1082 + 2203) < (3290 + 938)) and (v154 == (972 - (357 + 615)))) then
					if (((2749 + 1167) > (8165 - 4837)) and v77 and v35 and v98.RemoveCurse:IsAvailable()) then
						local v216 = 0 + 0;
						while true do
							if (((5357 - 2857) < (3071 + 768)) and (v216 == (0 + 0))) then
								if (((319 + 188) == (1808 - (384 + 917))) and v16) then
									v31 = v119();
									if (((937 - (128 + 569)) <= (4708 - (1407 + 136))) and v31) then
										return v31;
									end
								end
								if (((2721 - (687 + 1200)) >= (2515 - (556 + 1154))) and v17 and v17:Exists() and v17:IsAPlayer() and v112.UnitHasCurseDebuff(v17)) then
									if (v98.RemoveCurse:IsReady() or ((13410 - 9598) < (2411 - (9 + 86)))) then
										if (v24(v100.RemoveCurseMouseover) or ((3073 - (275 + 146)) <= (250 + 1283))) then
											return "remove_curse dispel";
										end
									end
								end
								break;
							end
						end
					end
					if ((not v14:AffectingCombat() and v32) or ((3662 - (29 + 35)) < (6470 - 5010))) then
						local v217 = 0 - 0;
						while true do
							if ((v217 == (0 - 0)) or ((2681 + 1435) < (2204 - (53 + 959)))) then
								v31 = v121();
								if (v31 or ((3785 - (312 + 96)) <= (1566 - 663))) then
									return v31;
								end
								break;
							end
						end
					end
					v154 = 286 - (147 + 138);
				end
				if (((4875 - (813 + 86)) >= (397 + 42)) and (v154 == (1 - 0))) then
					v31 = v118();
					if (((4244 - (18 + 474)) == (1266 + 2486)) and v31) then
						return v31;
					end
					v154 = 6 - 4;
				end
			end
		end
	end
	local function v130()
		v113();
		v98.WintersChillDebuff:RegisterAuraTracking();
		v22.Print("Frost Mage rotation by Epic. Supported by xKaneto.");
	end
	v22.SetAPL(1150 - (860 + 226), v129, v130);
end;
return v0["Epix_Mage_Frost.lua"]();

