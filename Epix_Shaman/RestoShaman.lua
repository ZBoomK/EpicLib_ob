local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((1222 - 702) > (8650 - 6756))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Shaman_RestoShaman.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v11.Player;
	local v13 = v11.Pet;
	local v14 = v11.Target;
	local v15 = v11.MouseOver;
	local v16 = v11.Focus;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = v9.Utils;
	local v21 = EpicLib;
	local v22 = v21.Cast;
	local v23 = v21.Press;
	local v24 = v21.Macro;
	local v25 = v21.Commons.Everyone.num;
	local v26 = v21.Commons.Everyone.bool;
	local v27 = math.min;
	local v28;
	local v29 = false;
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
	local v100;
	local v101;
	local v102;
	local v103;
	local v104;
	local v105;
	local v106;
	local v107;
	local v108;
	local v109;
	local v110;
	local v111;
	local v112 = 20916 - 9805;
	local v113 = 13042 - (609 + 1322);
	local v114;
	v9:RegisterForEvent(function()
		local v133 = 454 - (13 + 441);
		while true do
			if ((v133 == (0 - 0)) or ((4117 - 2545) > (19299 - 15424))) then
				v112 = 414 + 10697;
				v113 = 40352 - 29241;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local v115 = v17.Shaman.Restoration;
	local v116 = v24.Shaman.Restoration;
	local v117 = v19.Shaman.Restoration;
	local v118 = {};
	local v119 = v21.Commons.Everyone;
	local v120 = v21.Commons.Shaman;
	local function v121()
		if (((1614 + 2928) == (1991 + 2551)) and v115.ImprovedPurifySpirit:IsAvailable()) then
			v119.DispellableDebuffs = v20.MergeTable(v119.DispellableMagicDebuffs, v119.DispellableCurseDebuffs);
		else
			v119.DispellableDebuffs = v119.DispellableMagicDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v121();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v122(v134)
		return v134:DebuffRefreshable(v115.FlameShockDebuff) and (v113 > (14 - 9));
	end
	local function v123()
		if ((v88 and v115.AstralShift:IsReady()) or ((1462 + 1208) < (3197 - 1458))) then
			if ((v12:HealthPercentage() <= v54) or ((220 + 112) >= (2227 + 1776))) then
				if (v23(v115.AstralShift, not v14:IsInRange(29 + 11)) or ((2764 + 527) <= (3210 + 70))) then
					return "astral_shift defensives";
				end
			end
		end
		if (((4819 - (153 + 280)) >= (2520 - 1647)) and v91 and v115.EarthElemental:IsReady()) then
			if (((827 + 94) <= (436 + 666)) and ((v12:HealthPercentage() <= v62) or v119.IsTankBelowHealthPercentage(v63))) then
				if (((2463 + 2243) >= (874 + 89)) and v23(v115.EarthElemental, not v14:IsInRange(29 + 11))) then
					return "earth_elemental defensives";
				end
			end
		end
		if ((v117.Healthstone:IsReady() and v35 and (v12:HealthPercentage() <= v36)) or ((1461 - 501) <= (542 + 334))) then
			if (v23(v116.Healthstone) or ((2733 - (89 + 578)) == (666 + 266))) then
				return "healthstone defensive 3";
			end
		end
		if (((10030 - 5205) < (5892 - (572 + 477))) and v37 and (v12:HealthPercentage() <= v38)) then
			local v147 = 0 + 0;
			while true do
				if ((v147 == (0 + 0)) or ((463 + 3414) >= (4623 - (84 + 2)))) then
					if ((v39 == "Refreshing Healing Potion") or ((7111 - 2796) < (1244 + 482))) then
						if (v117.RefreshingHealingPotion:IsReady() or ((4521 - (497 + 345)) < (16 + 609))) then
							if (v23(v116.RefreshingHealingPotion) or ((782 + 3843) < (1965 - (605 + 728)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v39 == "Dreamwalker's Healing Potion") or ((60 + 23) > (3957 - 2177))) then
						if (((26 + 520) <= (3981 - 2904)) and v117.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v116.RefreshingHealingPotion) or ((898 + 98) > (11916 - 7615))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
					break;
				end
			end
		end
	end
	local function v124()
		local v135 = 0 + 0;
		while true do
			if (((4559 - (457 + 32)) > (292 + 395)) and (v135 == (1402 - (832 + 570)))) then
				if (v109 or ((619 + 37) >= (869 + 2461))) then
					local v231 = 0 - 0;
					while true do
						if ((v231 == (0 + 0)) or ((3288 - (588 + 208)) <= (902 - 567))) then
							v28 = v119.HandleIncorporeal(v115.Hex, v116.HexMouseOver, 1830 - (884 + 916), true);
							if (((9047 - 4725) >= (1486 + 1076)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (v108 or ((4290 - (232 + 421)) >= (5659 - (1569 + 320)))) then
					local v232 = 0 + 0;
					while true do
						if ((v232 == (1 + 0)) or ((8016 - 5637) > (5183 - (316 + 289)))) then
							if (v110 or ((1264 - 781) > (35 + 708))) then
								local v241 = 1453 - (666 + 787);
								while true do
									if (((2879 - (360 + 65)) > (541 + 37)) and (v241 == (254 - (79 + 175)))) then
										v28 = v119.HandleAfflicted(v115.TremorTotem, v115.TremorTotem, 47 - 17);
										if (((726 + 204) < (13664 - 9206)) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if (((1274 - 612) <= (1871 - (503 + 396))) and v111) then
								local v242 = 181 - (92 + 89);
								while true do
									if (((8477 - 4107) == (2242 + 2128)) and (v242 == (0 + 0))) then
										v28 = v119.HandleAfflicted(v115.PoisonCleansingTotem, v115.PoisonCleansingTotem, 117 - 87);
										if (v28 or ((652 + 4110) <= (1963 - 1102))) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v232 == (0 + 0)) or ((675 + 737) == (12986 - 8722))) then
							v28 = v119.HandleAfflicted(v115.PurifySpirit, v116.PurifySpiritMouseover, 4 + 26);
							if (v28 or ((4831 - 1663) < (3397 - (485 + 759)))) then
								return v28;
							end
							v232 = 2 - 1;
						end
					end
				end
				v135 = 1190 - (442 + 747);
			end
			if ((v135 == (1136 - (832 + 303))) or ((5922 - (88 + 858)) < (406 + 926))) then
				if (((3831 + 797) == (191 + 4437)) and v40) then
					local v233 = 789 - (766 + 23);
					while true do
						if ((v233 == (0 - 0)) or ((73 - 19) == (1040 - 645))) then
							v28 = v119.HandleCharredTreant(v115.Riptide, v116.RiptideMouseover, 135 - 95);
							if (((1155 - (1036 + 37)) == (59 + 23)) and v28) then
								return v28;
							end
							v233 = 1 - 0;
						end
						if ((v233 == (3 + 0)) or ((2061 - (641 + 839)) < (1195 - (910 + 3)))) then
							v28 = v119.HandleCharredTreant(v115.HealingWave, v116.HealingWaveMouseover, 101 - 61);
							if (v28 or ((6293 - (1466 + 218)) < (1147 + 1348))) then
								return v28;
							end
							break;
						end
						if (((2300 - (556 + 592)) == (410 + 742)) and (v233 == (810 - (329 + 479)))) then
							v28 = v119.HandleCharredTreant(v115.HealingSurge, v116.HealingSurgeMouseover, 894 - (174 + 680));
							if (((6514 - 4618) <= (7092 - 3670)) and v28) then
								return v28;
							end
							v233 = 3 + 0;
						end
						if ((v233 == (740 - (396 + 343))) or ((88 + 902) > (3097 - (29 + 1448)))) then
							v28 = v119.HandleCharredTreant(v115.ChainHeal, v116.ChainHealMouseover, 1429 - (135 + 1254));
							if (v28 or ((3303 - 2426) > (21921 - 17226))) then
								return v28;
							end
							v233 = 2 + 0;
						end
					end
				end
				if (((4218 - (389 + 1138)) >= (2425 - (102 + 472))) and v41) then
					v28 = v119.HandleCharredBrambles(v115.Riptide, v116.RiptideMouseover, 38 + 2);
					if (v28 or ((1656 + 1329) >= (4528 + 328))) then
						return v28;
					end
					v28 = v119.HandleCharredBrambles(v115.ChainHeal, v116.ChainHealMouseover, 1585 - (320 + 1225));
					if (((7611 - 3335) >= (732 + 463)) and v28) then
						return v28;
					end
					v28 = v119.HandleCharredBrambles(v115.HealingSurge, v116.HealingSurgeMouseover, 1504 - (157 + 1307));
					if (((5091 - (821 + 1038)) <= (11701 - 7011)) and v28) then
						return v28;
					end
					v28 = v119.HandleCharredBrambles(v115.HealingWave, v116.HealingWaveMouseover, 5 + 35);
					if (v28 or ((1590 - 694) >= (1171 + 1975))) then
						return v28;
					end
				end
				v135 = 4 - 2;
			end
			if (((4087 - (834 + 192)) >= (189 + 2769)) and (v135 == (1 + 1))) then
				if (((69 + 3118) >= (997 - 353)) and v42) then
					v28 = v119.HandleFyrakkNPC(v115.Riptide, v116.RiptideMouseover, 344 - (300 + 4));
					if (((172 + 472) <= (1842 - 1138)) and v28) then
						return v28;
					end
					v28 = v119.HandleFyrakkNPC(v115.ChainHeal, v116.ChainHealMouseover, 402 - (112 + 250));
					if (((382 + 576) > (2372 - 1425)) and v28) then
						return v28;
					end
					v28 = v119.HandleFyrakkNPC(v115.HealingSurge, v116.HealingSurgeMouseover, 23 + 17);
					if (((2324 + 2168) >= (1985 + 669)) and v28) then
						return v28;
					end
					v28 = v119.HandleFyrakkNPC(v115.HealingWave, v116.HealingWaveMouseover, 20 + 20);
					if (((2557 + 885) >= (2917 - (1001 + 413))) and v28) then
						return v28;
					end
				end
				break;
			end
		end
	end
	local function v125()
		local v136 = 0 - 0;
		while true do
			if ((v136 == (883 - (244 + 638))) or ((3863 - (627 + 66)) <= (4361 - 2897))) then
				if ((v98 and v12:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v16:BuffDown(v115.Riptide)) or ((5399 - (512 + 90)) == (6294 - (1665 + 241)))) then
					if (((1268 - (373 + 344)) <= (308 + 373)) and (v16:HealthPercentage() <= v79) and (v119.UnitGroupRole(v16) == "TANK")) then
						if (((868 + 2409) > (1073 - 666)) and v23(v116.RiptideFocus, not v16:IsSpellInRange(v115.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				if (((7944 - 3249) >= (2514 - (35 + 1064))) and v119.AreUnitsBelowHealthPercentage(v81, v80) and v115.SpiritLinkTotem:IsReady()) then
					if ((v82 == "Player") or ((2338 + 874) <= (2019 - 1075))) then
						if (v23(v116.SpiritLinkTotemPlayer, not v14:IsInRange(1 + 39)) or ((4332 - (298 + 938)) <= (3057 - (233 + 1026)))) then
							return "spirit_link_totem cooldowns";
						end
					elseif (((5203 - (636 + 1030)) == (1809 + 1728)) and (v82 == "Friendly under Cursor")) then
						if (((3748 + 89) >= (467 + 1103)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (v23(v116.SpiritLinkTotemCursor, not v14:IsInRange(3 + 37)) or ((3171 - (55 + 166)) == (739 + 3073))) then
								return "spirit_link_totem cooldowns";
							end
						end
					elseif (((475 + 4248) >= (8852 - 6534)) and (v82 == "Confirmation")) then
						if (v23(v115.SpiritLinkTotem, not v14:IsInRange(337 - (36 + 261))) or ((3544 - 1517) > (4220 - (34 + 1334)))) then
							return "spirit_link_totem cooldowns";
						end
					end
				end
				v136 = 1 + 1;
			end
			if ((v136 == (2 + 0)) or ((2419 - (1035 + 248)) > (4338 - (20 + 1)))) then
				if (((2474 + 2274) == (5067 - (134 + 185))) and v95 and v119.AreUnitsBelowHealthPercentage(v74, v73) and v115.HealingTideTotem:IsReady()) then
					if (((4869 - (549 + 584)) <= (5425 - (314 + 371))) and v23(v115.HealingTideTotem, not v14:IsInRange(137 - 97))) then
						return "healing_tide_totem cooldowns";
					end
				end
				if ((v119.AreUnitsBelowHealthPercentage(v50, v49) and v115.AncestralProtectionTotem:IsReady()) or ((4358 - (478 + 490)) <= (1621 + 1439))) then
					if ((v51 == "Player") or ((2171 - (786 + 386)) > (8722 - 6029))) then
						if (((1842 - (1055 + 324)) < (1941 - (1093 + 247))) and v23(v116.AncestralProtectionTotemPlayer, not v14:IsInRange(36 + 4))) then
							return "AncestralProtectionTotem cooldowns";
						end
					elseif ((v51 == "Friendly under Cursor") or ((230 + 1953) < (2727 - 2040))) then
						if (((15438 - 10889) == (12943 - 8394)) and v15:Exists() and not v12:CanAttack(v15)) then
							if (((11740 - 7068) == (1662 + 3010)) and v23(v116.AncestralProtectionTotemCursor, not v14:IsInRange(154 - 114))) then
								return "AncestralProtectionTotem cooldowns";
							end
						end
					elseif ((v51 == "Confirmation") or ((12642 - 8974) < (298 + 97))) then
						if (v23(v115.AncestralProtectionTotem, not v14:IsInRange(102 - 62)) or ((4854 - (364 + 324)) == (1247 - 792))) then
							return "AncestralProtectionTotem cooldowns";
						end
					end
				end
				v136 = 6 - 3;
			end
			if ((v136 == (0 + 0)) or ((18615 - 14166) == (4264 - 1601))) then
				if ((v106 and ((v30 and v105) or not v105)) or ((12989 - 8712) < (4257 - (1249 + 19)))) then
					local v234 = 0 + 0;
					while true do
						if ((v234 == (0 - 0)) or ((1956 - (686 + 400)) >= (3256 + 893))) then
							v28 = v119.HandleTopTrinket(v118, v30, 269 - (73 + 156), nil);
							if (((11 + 2201) < (3994 - (721 + 90))) and v28) then
								return v28;
							end
							v234 = 1 + 0;
						end
						if (((15084 - 10438) > (3462 - (224 + 246))) and (v234 == (1 - 0))) then
							v28 = v119.HandleBottomTrinket(v118, v30, 73 - 33, nil);
							if (((261 + 1173) < (74 + 3032)) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if (((578 + 208) < (6010 - 2987)) and v98 and v12:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v16:BuffDown(v115.Riptide)) then
					if ((v16:HealthPercentage() <= v78) or ((8126 - 5684) < (587 - (203 + 310)))) then
						if (((6528 - (1238 + 755)) == (317 + 4218)) and v23(v116.RiptideFocus, not v16:IsSpellInRange(v115.Riptide))) then
							return "riptide healingcd";
						end
					end
				end
				v136 = 1535 - (709 + 825);
			end
			if ((v136 == (7 - 3)) or ((4382 - 1373) <= (2969 - (196 + 668)))) then
				if (((7225 - 5395) < (7599 - 3930)) and v97 and (v12:Mana() <= v76) and v115.ManaTideTotem:IsReady()) then
					if (v23(v115.ManaTideTotem, not v14:IsInRange(873 - (171 + 662))) or ((1523 - (4 + 89)) >= (12659 - 9047))) then
						return "mana_tide_totem cooldowns";
					end
				end
				if (((977 + 1706) >= (10804 - 8344)) and v34 and ((v104 and v30) or not v104)) then
					if (v115.AncestralCall:IsReady() or ((708 + 1096) >= (4761 - (35 + 1451)))) then
						if (v23(v115.AncestralCall, not v14:IsInRange(1493 - (28 + 1425))) or ((3410 - (941 + 1052)) > (3480 + 149))) then
							return "AncestralCall cooldowns";
						end
					end
					if (((6309 - (822 + 692)) > (573 - 171)) and v115.BagofTricks:IsReady()) then
						if (((2268 + 2545) > (3862 - (45 + 252))) and v23(v115.BagofTricks, not v14:IsInRange(40 + 0))) then
							return "BagofTricks cooldowns";
						end
					end
					if (((1347 + 2565) == (9520 - 5608)) and v115.Berserking:IsReady()) then
						if (((3254 - (114 + 319)) <= (6926 - 2102)) and v23(v115.Berserking, not v14:IsInRange(51 - 11))) then
							return "Berserking cooldowns";
						end
					end
					if (((1108 + 630) <= (3270 - 1075)) and v115.BloodFury:IsReady()) then
						if (((85 - 44) <= (4981 - (556 + 1407))) and v23(v115.BloodFury, not v14:IsInRange(1246 - (741 + 465)))) then
							return "BloodFury cooldowns";
						end
					end
					if (((2610 - (170 + 295)) <= (2163 + 1941)) and v115.Fireblood:IsReady()) then
						if (((2470 + 219) < (11928 - 7083)) and v23(v115.Fireblood, not v14:IsInRange(34 + 6))) then
							return "Fireblood cooldowns";
						end
					end
				end
				break;
			end
			if ((v136 == (2 + 1)) or ((1315 + 1007) > (3852 - (957 + 273)))) then
				if ((v86 and v119.AreUnitsBelowHealthPercentage(v48, v47) and v115.AncestralGuidance:IsReady()) or ((1213 + 3321) == (834 + 1248))) then
					if (v23(v115.AncestralGuidance, not v14:IsInRange(152 - 112)) or ((4139 - 2568) > (5702 - 3835))) then
						return "ancestral_guidance cooldowns";
					end
				end
				if ((v87 and v119.AreUnitsBelowHealthPercentage(v53, v52) and v115.Ascendance:IsReady()) or ((13141 - 10487) >= (4776 - (389 + 1391)))) then
					if (((2496 + 1482) > (219 + 1885)) and v23(v115.Ascendance, not v14:IsInRange(91 - 51))) then
						return "ascendance cooldowns";
					end
				end
				v136 = 955 - (783 + 168);
			end
		end
	end
	local function v126()
		local v137 = 0 - 0;
		while true do
			if (((2946 + 49) > (1852 - (309 + 2))) and (v137 == (2 - 1))) then
				if (((4461 - (1090 + 122)) > (309 + 644)) and v98 and v12:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v16:BuffDown(v115.Riptide)) then
					if (((v16:HealthPercentage() <= v79) and (v119.UnitGroupRole(v16) == "TANK")) or ((10992 - 7719) > (3130 + 1443))) then
						if (v23(v116.RiptideFocus, not v16:IsSpellInRange(v115.Riptide)) or ((4269 - (628 + 490)) < (231 + 1053))) then
							return "riptide healingaoe";
						end
					end
				end
				if ((v100 and v115.UnleashLife:IsReady()) or ((4580 - 2730) == (6987 - 5458))) then
					if (((1595 - (431 + 343)) < (4287 - 2164)) and (v16:HealthPercentage() <= v85)) then
						if (((2609 - 1707) < (1837 + 488)) and v23(v115.UnleashLife, not v16:IsSpellInRange(v115.UnleashLife))) then
							return "unleash_life healingaoe";
						end
					end
				end
				if (((110 + 748) <= (4657 - (556 + 1139))) and (v69 == "Cursor") and v115.HealingRain:IsReady()) then
					if (v23(v116.HealingRainCursor, not v14:IsInRange(55 - (6 + 9)), v12:BuffDown(v115.SpiritwalkersGraceBuff)) or ((723 + 3223) < (660 + 628))) then
						return "healing_rain healingaoe";
					end
				end
				v137 = 171 - (28 + 141);
			end
			if ((v137 == (1 + 1)) or ((4001 - 759) == (402 + 165))) then
				if ((v119.AreUnitsBelowHealthPercentage(v68, v67) and v115.HealingRain:IsReady()) or ((2164 - (486 + 831)) >= (3286 - 2023))) then
					if ((v69 == "Player") or ((7931 - 5678) == (350 + 1501))) then
						if (v23(v116.HealingRainPlayer, not v14:IsInRange(126 - 86), v12:BuffDown(v115.SpiritwalkersGraceBuff)) or ((3350 - (668 + 595)) > (2135 + 237))) then
							return "healing_rain healingaoe";
						end
					elseif ((v69 == "Friendly under Cursor") or ((897 + 3548) < (11314 - 7165))) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((2108 - (23 + 267)) == (2029 - (1129 + 815)))) then
							if (((1017 - (371 + 16)) < (3877 - (1326 + 424))) and v23(v116.HealingRainCursor, not v14:IsInRange(75 - 35), v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif ((v69 == "Enemy under Cursor") or ((7081 - 5143) == (2632 - (88 + 30)))) then
						if (((5026 - (720 + 51)) >= (122 - 67)) and v15:Exists() and v12:CanAttack(v15)) then
							if (((4775 - (421 + 1355)) > (1906 - 750)) and v23(v116.HealingRainCursor, not v14:IsInRange(20 + 20), v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
								return "healing_rain healingaoe";
							end
						end
					elseif (((3433 - (286 + 797)) > (4222 - 3067)) and (v69 == "Confirmation")) then
						if (((6672 - 2643) <= (5292 - (397 + 42))) and v23(v115.HealingRain, not v14:IsInRange(13 + 27), v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
							return "healing_rain healingaoe";
						end
					end
				end
				if ((v119.AreUnitsBelowHealthPercentage(v65, v64) and v115.EarthenWallTotem:IsReady()) or ((1316 - (24 + 776)) > (5289 - 1855))) then
					if (((4831 - (222 + 563)) >= (6682 - 3649)) and (v66 == "Player")) then
						if (v23(v116.EarthenWallTotemPlayer, not v14:IsInRange(29 + 11)) or ((2909 - (23 + 167)) <= (3245 - (690 + 1108)))) then
							return "earthen_wall_totem healingaoe";
						end
					elseif ((v66 == "Friendly under Cursor") or ((1492 + 2642) < (3239 + 687))) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((1012 - (40 + 808)) >= (459 + 2326))) then
							if (v23(v116.EarthenWallTotemCursor, not v14:IsInRange(152 - 112)) or ((502 + 23) == (1116 + 993))) then
								return "earthen_wall_totem healingaoe";
							end
						end
					elseif (((19 + 14) == (604 - (47 + 524))) and (v66 == "Confirmation")) then
						if (((1982 + 1072) <= (10975 - 6960)) and v23(v115.EarthenWallTotem, not v14:IsInRange(59 - 19))) then
							return "earthen_wall_totem healingaoe";
						end
					end
				end
				if (((4266 - 2395) < (5108 - (1165 + 561))) and v119.AreUnitsBelowHealthPercentage(v60, v59) and v115.Downpour:IsReady()) then
					if (((39 + 1254) <= (6708 - 4542)) and (v61 == "Player")) then
						if (v23(v116.DownpourPlayer, not v14:IsInRange(16 + 24), v12:BuffDown(v115.SpiritwalkersGraceBuff)) or ((3058 - (341 + 138)) < (34 + 89))) then
							return "downpour healingaoe";
						end
					elseif ((v61 == "Friendly under Cursor") or ((1745 - 899) >= (2694 - (89 + 237)))) then
						if ((v15:Exists() and not v12:CanAttack(v15)) or ((12906 - 8894) <= (7069 - 3711))) then
							if (((2375 - (581 + 300)) <= (4225 - (855 + 365))) and v23(v116.DownpourCursor, not v14:IsInRange(95 - 55), v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
								return "downpour healingaoe";
							end
						end
					elseif ((v61 == "Confirmation") or ((1016 + 2095) == (3369 - (1030 + 205)))) then
						if (((2211 + 144) == (2191 + 164)) and v23(v115.Downpour, not v14:IsInRange(326 - (156 + 130)), v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
							return "downpour healingaoe";
						end
					end
				end
				v137 = 6 - 3;
			end
			if ((v137 == (4 - 1)) or ((1204 - 616) <= (114 + 318))) then
				if (((2798 + 1999) >= (3964 - (10 + 59))) and v90 and v119.AreUnitsBelowHealthPercentage(v58, v57) and v115.CloudburstTotem:IsReady()) then
					if (((1012 + 2565) == (17615 - 14038)) and v23(v115.CloudburstTotem)) then
						return "clouburst_totem healingaoe";
					end
				end
				if (((4957 - (671 + 492)) > (2940 + 753)) and v101 and v119.AreUnitsBelowHealthPercentage(v103, v102) and v115.Wellspring:IsReady()) then
					if (v23(v115.Wellspring, not v14:IsInRange(1255 - (369 + 846)), v12:BuffDown(v115.SpiritwalkersGraceBuff)) or ((338 + 937) == (3499 + 601))) then
						return "wellspring healingaoe";
					end
				end
				if ((v89 and v119.AreUnitsBelowHealthPercentage(v56, v55) and v115.ChainHeal:IsReady()) or ((3536 - (1036 + 909)) >= (2847 + 733))) then
					if (((1650 - 667) <= (2011 - (11 + 192))) and v23(v116.ChainHealFocus, not v16:IsSpellInRange(v115.ChainHeal), v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe";
					end
				end
				v137 = 3 + 1;
			end
			if ((v137 == (179 - (135 + 40))) or ((5209 - 3059) <= (722 + 475))) then
				if (((8302 - 4533) >= (1758 - 585)) and v99 and v12:IsMoving() and v119.AreUnitsBelowHealthPercentage(v84, v83) and v115.SpiritwalkersGrace:IsReady()) then
					if (((1661 - (50 + 126)) == (4134 - 2649)) and v23(v115.SpiritwalkersGrace, nil)) then
						return "spiritwalkers_grace healingaoe";
					end
				end
				if ((v93 and v119.AreUnitsBelowHealthPercentage(v71, v70) and v115.HealingStreamTotem:IsReady()) or ((734 + 2581) <= (4195 - (1233 + 180)))) then
					if (v23(v115.HealingStreamTotem, nil) or ((1845 - (522 + 447)) >= (4385 - (107 + 1314)))) then
						return "healing_stream_totem healingaoe";
					end
				end
				break;
			end
			if ((v137 == (0 + 0)) or ((6800 - 4568) > (1061 + 1436))) then
				if ((v89 and v119.AreUnitsBelowHealthPercentage(188 - 93, 11 - 8) and v115.ChainHeal:IsReady() and v12:BuffUp(v115.HighTide)) or ((4020 - (716 + 1194)) <= (6 + 326))) then
					if (((395 + 3291) > (3675 - (74 + 429))) and v23(v116.ChainHealFocus, not v16:IsSpellInRange(v115.ChainHeal), v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "chain_heal healingaoe high tide";
					end
				end
				if ((v96 and (v16:HealthPercentage() <= v75) and v115.HealingWave:IsReady() and (v115.PrimordialWaveResto:TimeSinceLastCast() < (28 - 13))) or ((2218 + 2256) < (1877 - 1057))) then
					if (((3028 + 1251) >= (8884 - 6002)) and v23(v116.HealingWaveFocus, not v16:IsSpellInRange(v115.HealingWave), v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "healing_wave healingaoe after primordial";
					end
				end
				if ((v98 and v12:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v16:BuffDown(v115.Riptide)) or ((5016 - 2987) >= (3954 - (279 + 154)))) then
					if ((v16:HealthPercentage() <= v78) or ((2815 - (454 + 324)) >= (3653 + 989))) then
						if (((1737 - (12 + 5)) < (2404 + 2054)) and v23(v116.RiptideFocus, not v16:IsSpellInRange(v115.Riptide))) then
							return "riptide healingaoe";
						end
					end
				end
				v137 = 2 - 1;
			end
		end
	end
	local function v127()
		if ((v98 and v12:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v16:BuffDown(v115.Riptide)) or ((162 + 274) > (4114 - (277 + 816)))) then
			if (((3046 - 2333) <= (2030 - (1058 + 125))) and (v16:HealthPercentage() <= v78)) then
				if (((404 + 1750) <= (5006 - (815 + 160))) and v23(v116.RiptideFocus, not v16:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((19801 - 15186) == (10955 - 6340)) and v98 and v12:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v16:BuffDown(v115.Riptide)) then
			if (((v16:HealthPercentage() <= v79) and (v119.UnitGroupRole(v16) == "TANK")) or ((905 + 2885) == (1461 - 961))) then
				if (((1987 - (41 + 1857)) < (2114 - (1222 + 671))) and v23(v116.RiptideFocus, not v16:IsSpellInRange(v115.Riptide))) then
					return "riptide healingaoe";
				end
			end
		end
		if (((5308 - 3254) >= (2042 - 621)) and v98 and v12:BuffDown(v115.UnleashLife) and v115.Riptide:IsReady() and v16:BuffDown(v115.Riptide)) then
			if (((1874 - (229 + 953)) < (4832 - (1111 + 663))) and ((v16:HealthPercentage() <= v78) or (v16:HealthPercentage() <= v78))) then
				if (v23(v116.RiptideFocus, not v16:IsSpellInRange(v115.Riptide)) or ((4833 - (874 + 705)) == (232 + 1423))) then
					return "riptide healingaoe";
				end
			end
		end
		if ((v115.ElementalOrbit:IsAvailable() and v12:BuffDown(v115.EarthShieldBuff)) or ((885 + 411) == (10206 - 5296))) then
			if (((95 + 3273) == (4047 - (642 + 37))) and v23(v115.EarthShield)) then
				return "earth_shield healingst";
			end
		end
		if (((603 + 2040) < (611 + 3204)) and v115.ElementalOrbit:IsAvailable() and v12:BuffUp(v115.EarthShieldBuff)) then
			if (((4802 - 2889) > (947 - (233 + 221))) and v119.IsSoloMode()) then
				if (((10995 - 6240) > (3018 + 410)) and v115.LightningShield:IsReady() and v12:BuffDown(v115.LightningShield)) then
					if (((2922 - (718 + 823)) <= (1491 + 878)) and v23(v115.LightningShield)) then
						return "lightning_shield healingst";
					end
				end
			elseif ((v115.WaterShield:IsReady() and v12:BuffDown(v115.WaterShield)) or ((5648 - (266 + 539)) == (11562 - 7478))) then
				if (((5894 - (636 + 589)) > (861 - 498)) and v23(v115.WaterShield)) then
					return "water_shield healingst";
				end
			end
		end
		if ((v94 and v115.HealingSurge:IsReady()) or ((3871 - 1994) >= (2487 + 651))) then
			if (((1723 + 3019) >= (4641 - (657 + 358))) and (v16:HealthPercentage() <= v72)) then
				if (v23(v116.HealingSurgeFocus, not v16:IsSpellInRange(v115.HealingSurge), v12:BuffDown(v115.SpiritwalkersGraceBuff)) or ((12020 - 7480) == (2086 - 1170))) then
					return "healing_surge healingst";
				end
			end
		end
		if ((v96 and v115.HealingWave:IsReady()) or ((2343 - (1151 + 36)) > (4196 + 149))) then
			if (((589 + 1648) < (12689 - 8440)) and (v16:HealthPercentage() <= v75)) then
				if (v23(v116.HealingWaveFocus, not v16:IsSpellInRange(v115.HealingWave), v12:BuffDown(v115.SpiritwalkersGraceBuff)) or ((4515 - (1552 + 280)) < (857 - (64 + 770)))) then
					return "healing_wave healingst";
				end
			end
		end
	end
	local function v128()
		local v138 = 0 + 0;
		while true do
			if (((1581 - 884) <= (147 + 679)) and (v138 == (1244 - (157 + 1086)))) then
				if (((2211 - 1106) <= (5150 - 3974)) and v115.FlameShock:IsReady()) then
					if (((5182 - 1803) <= (5202 - 1390)) and v119.CastCycle(v115.FlameShock, v12:GetEnemiesInRange(859 - (599 + 220)), v122, not v14:IsSpellInRange(v115.FlameShock), nil, nil, nil, nil)) then
						return "flame_shock_cycle damage";
					end
					if (v23(v115.FlameShock, not v14:IsSpellInRange(v115.FlameShock)) or ((1568 - 780) >= (3547 - (1813 + 118)))) then
						return "flame_shock damage";
					end
				end
				if (((1356 + 498) <= (4596 - (841 + 376))) and v115.LavaBurst:IsReady()) then
					if (((6373 - 1824) == (1057 + 3492)) and v23(v115.LavaBurst, not v14:IsSpellInRange(v115.LavaBurst), v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
						return "lava_burst damage";
					end
				end
				v138 = 5 - 3;
			end
			if ((v138 == (859 - (464 + 395))) or ((7755 - 4733) >= (1453 + 1571))) then
				if (((5657 - (467 + 370)) > (4541 - 2343)) and v115.Stormkeeper:IsReady()) then
					if (v23(v115.Stormkeeper, not v14:IsInRange(30 + 10)) or ((3637 - 2576) >= (764 + 4127))) then
						return "stormkeeper damage";
					end
				end
				if (((3172 - 1808) <= (4993 - (150 + 370))) and (#v12:GetEnemiesInRange(1322 - (74 + 1208)) > (2 - 1))) then
					if (v115.ChainLightning:IsReady() or ((17049 - 13454) <= (3 + 0))) then
						if (v23(v115.ChainLightning, not v14:IsSpellInRange(v115.ChainLightning), v12:BuffDown(v115.SpiritwalkersGraceBuff)) or ((5062 - (14 + 376)) == (6680 - 2828))) then
							return "chain_lightning damage";
						end
					end
				end
				v138 = 1 + 0;
			end
			if (((1370 + 189) == (1487 + 72)) and (v138 == (5 - 3))) then
				if (v115.LightningBolt:IsReady() or ((1319 + 433) <= (866 - (23 + 55)))) then
					if (v23(v115.LightningBolt, not v14:IsSpellInRange(v115.LightningBolt), v12:BuffDown(v115.SpiritwalkersGraceBuff)) or ((9258 - 5351) == (119 + 58))) then
						return "lightning_bolt damage";
					end
				end
				break;
			end
		end
	end
	local function v129()
		local v139 = 0 + 0;
		while true do
			if (((5380 - 1910) > (175 + 380)) and (v139 == (901 - (652 + 249)))) then
				v49 = EpicSettings.Settings['AncestralProtectionTotemGroup'];
				v50 = EpicSettings.Settings['AncestralProtectionTotemHP'];
				v51 = EpicSettings.Settings['AncestralProtectionTotemUsage'];
				v55 = EpicSettings.Settings['ChainHealGroup'];
				v56 = EpicSettings.Settings['ChainHealHP'];
				v43 = EpicSettings.Settings['DispelDebuffs'];
				v139 = 2 - 1;
			end
			if ((v139 == (1875 - (708 + 1160))) or ((2638 - 1666) == (1175 - 530))) then
				v93 = EpicSettings.Settings['UseHealingStreamTotem'];
				v94 = EpicSettings.Settings['UseHealingSurge'];
				v95 = EpicSettings.Settings['UseHealingTideTotem'];
				v96 = EpicSettings.Settings['UseHealingWave'];
				v35 = EpicSettings.Settings['useHealthstone'];
				v98 = EpicSettings.Settings['UseRiptide'];
				v139 = 35 - (10 + 17);
			end
			if (((715 + 2467) >= (3847 - (1400 + 332))) and (v139 == (5 - 2))) then
				v68 = EpicSettings.Settings['HealingRainHP'];
				v69 = EpicSettings.Settings['HealingRainUsage'];
				v70 = EpicSettings.Settings['HealingStreamTotemGroup'];
				v71 = EpicSettings.Settings['HealingStreamTotemHP'];
				v72 = EpicSettings.Settings['HealingSurgeHP'];
				v73 = EpicSettings.Settings['HealingTideTotemGroup'];
				v139 = 1912 - (242 + 1666);
			end
			if (((1666 + 2227) < (1624 + 2805)) and (v139 == (1 + 0))) then
				v59 = EpicSettings.Settings['DownpourGroup'];
				v60 = EpicSettings.Settings['DownpourHP'];
				v61 = EpicSettings.Settings['DownpourUsage'];
				v64 = EpicSettings.Settings['EarthenWallTotemGroup'];
				v65 = EpicSettings.Settings['EarthenWallTotemHP'];
				v66 = EpicSettings.Settings['EarthenWallTotemUsage'];
				v139 = 942 - (850 + 90);
			end
			if ((v139 == (6 - 2)) or ((4257 - (360 + 1030)) < (1686 + 219))) then
				v74 = EpicSettings.Settings['HealingTideTotemHP'];
				v75 = EpicSettings.Settings['HealingWaveHP'];
				v36 = EpicSettings.Settings['healthstoneHP'];
				v45 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v46 = EpicSettings.Settings['InterruptThreshold'];
				v44 = EpicSettings.Settings['InterruptWithStun'];
				v139 = 13 - 8;
			end
			if ((v139 == (6 - 1)) or ((3457 - (909 + 752)) >= (5274 - (109 + 1114)))) then
				v78 = EpicSettings.Settings['RiptideHP'];
				v79 = EpicSettings.Settings['RiptideTankHP'];
				v80 = EpicSettings.Settings['SpiritLinkTotemGroup'];
				v81 = EpicSettings.Settings['SpiritLinkTotemHP'];
				v82 = EpicSettings.Settings['SpiritLinkTotemUsage'];
				v83 = EpicSettings.Settings['SpiritwalkersGraceGroup'];
				v139 = 10 - 4;
			end
			if (((631 + 988) <= (3998 - (6 + 236))) and (v139 == (6 + 2))) then
				v99 = EpicSettings.Settings['UseSpiritwalkersGrace'];
				v100 = EpicSettings.Settings['UseUnleashLife'];
				break;
			end
			if (((487 + 117) == (1424 - 820)) and (v139 == (10 - 4))) then
				v84 = EpicSettings.Settings['SpiritwalkersGraceHP'];
				v85 = EpicSettings.Settings['UnleashLifeHP'];
				v89 = EpicSettings.Settings['UseChainHeal'];
				v90 = EpicSettings.Settings['UseCloudburstTotem'];
				v92 = EpicSettings.Settings['UseEarthShield'];
				v37 = EpicSettings.Settings['useHealingPotion'];
				v139 = 1140 - (1076 + 57);
			end
			if ((v139 == (1 + 1)) or ((5173 - (579 + 110)) == (72 + 828))) then
				v41 = EpicSettings.Settings['HandleCharredBrambles'];
				v40 = EpicSettings.Settings['HandleCharredTreant'];
				v42 = EpicSettings.Settings['HandleFyrakkNPC'];
				v38 = EpicSettings.Settings['healingPotionHP'];
				v39 = EpicSettings.Settings['HealingPotionName'];
				v67 = EpicSettings.Settings['HealingRainGroup'];
				v139 = 3 + 0;
			end
		end
	end
	local function v130()
		local v140 = 0 + 0;
		while true do
			if ((v140 == (410 - (174 + 233))) or ((12455 - 7996) <= (1953 - 840))) then
				v76 = EpicSettings.Settings['ManaTideTotemMana'];
				v77 = EpicSettings.Settings['PrimordialWaveHP'];
				v86 = EpicSettings.Settings['UseAncestralGuidance'];
				v140 = 2 + 2;
			end
			if (((4806 - (663 + 511)) > (3032 + 366)) and ((2 + 7) == v140)) then
				v111 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				break;
			end
			if (((12584 - 8502) <= (2978 + 1939)) and ((13 - 7) == v140)) then
				v103 = EpicSettings.Settings['WellspringHP'];
				v104 = EpicSettings.Settings['racialsWithCD'];
				v34 = EpicSettings.Settings['useRacials'];
				v140 = 16 - 9;
			end
			if (((2306 + 2526) >= (2697 - 1311)) and (v140 == (1 + 0))) then
				v53 = EpicSettings.Settings['AscendanceHP'];
				v54 = EpicSettings.Settings['AstralShiftHP'];
				v57 = EpicSettings.Settings['CloudburstTotemGroup'];
				v140 = 1 + 1;
			end
			if (((859 - (478 + 244)) == (654 - (440 + 77))) and (v140 == (1 + 1))) then
				v58 = EpicSettings.Settings['CloudburstTotemHP'];
				v62 = EpicSettings.Settings['EarthElementalHP'];
				v63 = EpicSettings.Settings['EarthElementalTankHP'];
				v140 = 10 - 7;
			end
			if ((v140 == (1564 - (655 + 901))) or ((292 + 1278) >= (3317 + 1015))) then
				v108 = EpicSettings.Settings['handleAfflicted'];
				v109 = EpicSettings.Settings['HandleIncorporeal'];
				v110 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v140 = 7 + 2;
			end
			if ((v140 == (15 - 11)) or ((5509 - (695 + 750)) <= (6211 - 4392))) then
				v87 = EpicSettings.Settings['UseAscendance'];
				v88 = EpicSettings.Settings['UseAstralShift'];
				v91 = EpicSettings.Settings['UseEarthElemental'];
				v140 = 7 - 2;
			end
			if ((v140 == (28 - 21)) or ((5337 - (285 + 66)) < (3668 - 2094))) then
				v105 = EpicSettings.Settings['trinketsWithCD'];
				v106 = EpicSettings.Settings['useTrinkets'];
				v107 = EpicSettings.Settings['fightRemainsCheck'];
				v140 = 1318 - (682 + 628);
			end
			if (((714 + 3712) > (471 - (176 + 123))) and ((3 + 2) == v140)) then
				v97 = EpicSettings.Settings['UseManaTideTotem'];
				v101 = EpicSettings.Settings['UseWellspring'];
				v102 = EpicSettings.Settings['WellspringGroup'];
				v140 = 5 + 1;
			end
			if (((855 - (239 + 30)) > (124 + 331)) and (v140 == (0 + 0))) then
				v47 = EpicSettings.Settings['AncestralGuidanceGroup'];
				v48 = EpicSettings.Settings['AncestralGuidanceHP'];
				v52 = EpicSettings.Settings['AscendanceGroup'];
				v140 = 1 - 0;
			end
		end
	end
	local function v131()
		local v141 = 0 - 0;
		local v142;
		while true do
			if (((1141 - (306 + 9)) == (2882 - 2056)) and (v141 == (0 + 0))) then
				v129();
				v130();
				v29 = EpicSettings.Toggles['ooc'];
				v30 = EpicSettings.Toggles['cds'];
				v141 = 1 + 0;
			end
			if (((1 + 1) == v141) or ((11492 - 7473) > (5816 - (1140 + 235)))) then
				if (((1284 + 733) < (3908 + 353)) and (v119.TargetIsValid() or v12:AffectingCombat())) then
					v114 = v12:GetEnemiesInRange(11 + 29);
					v112 = v9.BossFightRemains(nil, true);
					v113 = v112;
					if (((4768 - (33 + 19)) > (29 + 51)) and (v113 == (33302 - 22191))) then
						v113 = v9.FightRemains(v114, false);
					end
				end
				if (v12:AffectingCombat() or v29 or ((1545 + 1962) == (6416 - 3144))) then
					local v235 = v43 and v115.PurifySpirit:IsReady() and v31;
					if ((v115.EarthShield:IsReady() and v92 and (v119.FriendlyUnitsWithBuffCount(v115.EarthShield, true, false, 24 + 1) < (690 - (586 + 103)))) or ((80 + 796) >= (9466 - 6391))) then
						v28 = v119.FocusUnitRefreshableBuff(v115.EarthShield, 1503 - (1309 + 179), 72 - 32, "TANK", true, 11 + 14);
						if (((11687 - 7335) > (1930 + 624)) and v28) then
							return v28;
						end
						if ((v119.UnitGroupRole(v16) == "TANK") or ((9361 - 4955) < (8055 - 4012))) then
							if (v23(v116.EarthShieldFocus, not v16:IsSpellInRange(v115.EarthShield)) or ((2498 - (295 + 314)) >= (8308 - 4925))) then
								return "earth_shield_tank main apl";
							end
						end
					end
					if (((3854 - (1300 + 662)) <= (8585 - 5851)) and (not v16:BuffDown(v115.EarthShield) or (v119.UnitGroupRole(v16) ~= "TANK") or not v92 or (v119.FriendlyUnitsWithBuffCount(v115.EarthShield, true, false, 1780 - (1178 + 577)) >= (1 + 0)))) then
						local v238 = 0 - 0;
						while true do
							if (((3328 - (851 + 554)) < (1962 + 256)) and (v238 == (0 - 0))) then
								v28 = v119.FocusUnit(v235, nil, nil, nil);
								if (((4719 - 2546) > (681 - (115 + 187))) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				if ((v115.EarthShield:IsCastable() and v92 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(31 + 9) and (v119.UnitGroupRole(v16) == "TANK") and (v16:BuffDown(v115.EarthShield))) or ((2453 + 138) == (13433 - 10024))) then
					if (((5675 - (160 + 1001)) > (2908 + 416)) and v23(v116.EarthShieldFocus, not v16:IsSpellInRange(v115.EarthShield))) then
						return "earth_shield_tank main apl";
					end
				end
				v142 = nil;
				v141 = 3 + 0;
			end
			if ((v141 == (1 - 0)) or ((566 - (237 + 121)) >= (5725 - (525 + 372)))) then
				v31 = EpicSettings.Toggles['dispel'];
				v32 = EpicSettings.Toggles['healing'];
				v33 = EpicSettings.Toggles['dps'];
				if (v12:IsDeadOrGhost() or ((3000 - 1417) > (11719 - 8152))) then
					return;
				end
				v141 = 144 - (96 + 46);
			end
			if (((780 - (643 + 134)) == v141) or ((474 + 839) == (1903 - 1109))) then
				if (((11783 - 8609) > (2784 + 118)) and not v12:AffectingCombat()) then
					if (((8085 - 3965) <= (8707 - 4447)) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v12:CanAttack(v15)) then
						local v239 = 719 - (316 + 403);
						local v240;
						while true do
							if ((v239 == (0 + 0)) or ((2427 - 1544) > (1727 + 3051))) then
								v240 = v119.DeadFriendlyUnitsCount();
								if ((v240 > (2 - 1)) or ((2566 + 1054) >= (1577 + 3314))) then
									if (((14753 - 10495) > (4474 - 3537)) and v23(v115.AncestralVision, nil, v12:BuffDown(v115.SpiritwalkersGraceBuff))) then
										return "ancestral_vision";
									end
								elseif (v23(v116.AncestralSpiritMouseover, not v14:IsInRange(83 - 43), v12:BuffDown(v115.SpiritwalkersGraceBuff)) or ((279 + 4590) < (1783 - 877))) then
									return "ancestral_spirit";
								end
								break;
							end
						end
					end
				end
				if ((v12:AffectingCombat() and v119.TargetIsValid()) or ((60 + 1165) > (12439 - 8211))) then
					local v236 = 17 - (12 + 5);
					while true do
						if (((12925 - 9597) > (4774 - 2536)) and (v236 == (6 - 3))) then
							v142 = v123();
							if (((9519 - 5680) > (286 + 1119)) and v142) then
								return v142;
							end
							v236 = 1977 - (1656 + 317);
						end
						if ((v236 == (1 + 0)) or ((1037 + 256) <= (1347 - 840))) then
							v28 = v119.InterruptCursor(v115.WindShear, v116.WindShearMouseover, 147 - 117, true, v15);
							if (v28 or ((3250 - (5 + 349)) < (3823 - 3018))) then
								return v28;
							end
							v236 = 1273 - (266 + 1005);
						end
						if (((1527 + 789) == (7902 - 5586)) and (v236 == (2 - 0))) then
							v28 = v119.InterruptWithStunCursor(v115.CapacitorTotem, v116.CapacitorTotemCursor, 1726 - (561 + 1135), nil, v15);
							if (v28 or ((3349 - 779) == (5039 - 3506))) then
								return v28;
							end
							v236 = 1069 - (507 + 559);
						end
						if ((v236 == (0 - 0)) or ((2730 - 1847) == (1848 - (212 + 176)))) then
							v28 = v119.Interrupt(v115.WindShear, 935 - (250 + 655), true);
							if (v28 or ((12595 - 7976) <= (1745 - 746))) then
								return v28;
							end
							v236 = 1 - 0;
						end
						if ((v236 == (1960 - (1869 + 87))) or ((11827 - 8417) > (6017 - (484 + 1417)))) then
							if ((v113 > v107) or ((1935 - 1032) >= (5126 - 2067))) then
								local v243 = 773 - (48 + 725);
								while true do
									if ((v243 == (0 - 0)) or ((10666 - 6690) < (1661 + 1196))) then
										v142 = v125();
										if (((13175 - 8245) > (646 + 1661)) and v142) then
											return v142;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (v29 or v12:AffectingCombat() or ((1180 + 2866) < (2144 - (152 + 701)))) then
					local v237 = 1311 - (430 + 881);
					while true do
						if ((v237 == (0 + 0)) or ((5136 - (557 + 338)) == (1048 + 2497))) then
							if (v31 or ((11407 - 7359) > (14819 - 10587))) then
								if ((v16 and v43) or ((4649 - 2899) >= (7484 - 4011))) then
									if (((3967 - (499 + 302)) == (4032 - (39 + 827))) and v115.PurifySpirit:IsReady() and v119.DispellableFriendlyUnit(68 - 43)) then
										if (((3937 - 2174) < (14791 - 11067)) and v23(v116.PurifySpiritFocus, not v16:IsSpellInRange(v115.PurifySpirit))) then
											return "purify_spirit dispel";
										end
									end
								end
							end
							if (((87 - 30) <= (234 + 2489)) and (v16:HealthPercentage() < v77) and v16:BuffDown(v115.Riptide)) then
								if (v115.PrimordialWaveResto:IsCastable() or ((6058 - 3988) == (71 + 372))) then
									if (v23(v116.PrimordialWaveFocus, not v16:IsSpellInRange(v115.PrimordialWaveResto)) or ((4280 - 1575) == (1497 - (103 + 1)))) then
										return "primordial_wave main";
									end
								end
							end
							v237 = 555 - (475 + 79);
						end
						if ((v237 == (4 - 2)) or ((14723 - 10122) < (8 + 53))) then
							if (v32 or ((1224 + 166) >= (6247 - (1395 + 108)))) then
								local v244 = 0 - 0;
								while true do
									if ((v244 == (1204 - (7 + 1197))) or ((874 + 1129) > (1338 + 2496))) then
										v142 = v126();
										if (v142 or ((475 - (27 + 292)) > (11465 - 7552))) then
											return v142;
										end
										v244 = 1 - 0;
									end
									if (((817 - 622) == (384 - 189)) and (v244 == (1 - 0))) then
										v142 = v127();
										if (((3244 - (43 + 96)) >= (7326 - 5530)) and v142) then
											return v142;
										end
										break;
									end
								end
							end
							if (((9900 - 5521) >= (1769 + 362)) and v33) then
								if (((1086 + 2758) >= (4037 - 1994)) and v119.TargetIsValid()) then
									local v245 = 0 + 0;
									while true do
										if ((v245 == (0 - 0)) or ((1018 + 2214) <= (201 + 2530))) then
											v142 = v128();
											if (((6656 - (1414 + 337)) == (6845 - (1642 + 298))) and v142) then
												return v142;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if (((2 - 1) == v237) or ((11898 - 7762) >= (13089 - 8678))) then
							v142 = v124();
							if (v142 or ((974 + 1984) == (3126 + 891))) then
								return v142;
							end
							v237 = 974 - (357 + 615);
						end
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v143 = 0 + 0;
		while true do
			if (((3012 - 1784) >= (697 + 116)) and (v143 == (0 - 0))) then
				v121();
				v21.Print("Restoration Shaman rotation by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v21.SetAPL(212 + 52, v131, v132);
end;
return v0["Epix_Shaman_RestoShaman.lua"]();

