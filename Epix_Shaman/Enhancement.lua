local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = v0[v4];
	if (not v5 or ((593 - (14 + 59)) > (6253 - 4359))) then
		return v1(v4, ...);
	end
	return v5(...);
end
v0["Epix_Shaman_Enhancement.lua"] = function(...)
	local v6, v7 = ...;
	local v8 = EpicDBC.DBC;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9.Unit;
	local v12 = v9.Utils;
	local v13 = v11.Player;
	local v14 = v11.Target;
	local v15 = v11.Focus;
	local v16 = v11.Mouseover;
	local v17 = v9.Spell;
	local v18 = v9.MultiSpell;
	local v19 = v9.Item;
	local v20 = EpicLib;
	local v21 = v20.Cast;
	local v22 = v20.Macro;
	local v23 = v20.Press;
	local v24 = v20.Commons.Everyone.num;
	local v25 = v20.Commons.Everyone.bool;
	local v26 = GetWeaponEnchantInfo;
	local v27 = math.max;
	local v28 = math.min;
	local v29 = string.match;
	local v30 = GetTime;
	local v31 = C_Timer;
	local v32;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
	local v37 = false;
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
	local v102 = v17.Shaman.Enhancement;
	local v103 = v19.Shaman.Enhancement;
	local v104 = v22.Shaman.Enhancement;
	local v105 = {};
	local v106, v107;
	local v108, v109;
	local v110;
	local v111 = 1552 - (1174 + 368);
	local v112 = 370 - (112 + 250);
	local v113 = 3 + 3;
	local v114 = 2505 - 1505;
	local v115, v116, v117, v118;
	local v119 = (v102.LavaBurst:IsAvailable() and (2 + 0)) or (1 + 0);
	local v120 = "Lightning Bolt";
	local v121 = 8310 + 2801;
	local v122 = 5510 + 5601;
	local v123 = v20.Commons.Everyone;
	v20.Commons.Shaman = {};
	local v125 = v20.Commons.Shaman;
	v125.FeralSpiritCount = 0 + 0;
	v9:RegisterForEvent(function()
		v119 = (v102.LavaBurst:IsAvailable() and (1416 - (1001 + 413))) or (2 - 1);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v9:RegisterForEvent(function()
		local v150 = 882 - (244 + 638);
		while true do
			if ((v150 == (694 - (627 + 66))) or ((4683 - 3111) > (4477 - (512 + 90)))) then
				v122 = 13017 - (1665 + 241);
				break;
			end
			if (((5259 - (373 + 344)) == (2049 + 2493)) and (v150 == (0 + 0))) then
				v120 = "Lightning Bolt";
				v121 = 29307 - 18196;
				v150 = 1 - 0;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	local function v127(v151)
		local v152 = v13:GetEnemiesInRange(v151);
		local v153 = 1100 - (35 + 1064);
		for v198, v199 in pairs(v152) do
			if (((v199:GUID() ~= v14:GUID()) and (v199:AffectingCombat() or v199:IsDummy())) or ((1943 + 727) < (3720 - 1981))) then
				v153 = v153 + 1 + 0;
			end
		end
		return v153;
	end
	v9:RegisterForSelfCombatEvent(function(...)
		local v154 = 1236 - (298 + 938);
		local v155;
		local v156;
		local v157;
		while true do
			if ((v154 == (1259 - (233 + 1026))) or ((1998 - (636 + 1030)) >= (2047 + 1956))) then
				v155, v156, v156, v156, v156, v156, v156, v156, v157 = select(4 + 0, ...);
				if (((v155 == v13:GUID()) and (v157 == (56928 + 134706))) or ((223 + 3068) <= (3501 - (55 + 166)))) then
					v125.LastSKCast = v30();
				end
				v154 = 1 + 0;
			end
			if (((442 + 3944) >= (3333 - 2460)) and (v154 == (298 - (36 + 261)))) then
				if (((1610 - 689) <= (2470 - (34 + 1334))) and v13:HasTier(12 + 19, 2 + 0) and (v155 == v13:GUID()) and (v157 == (377265 - (1035 + 248)))) then
					local v238 = 21 - (20 + 1);
					while true do
						if (((2452 + 2254) >= (1282 - (134 + 185))) and (v238 == (1133 - (549 + 584)))) then
							v125.FeralSpiritCount = v125.FeralSpiritCount + (686 - (314 + 371));
							v31.After(51 - 36, function()
								v125.FeralSpiritCount = v125.FeralSpiritCount - (969 - (478 + 490));
							end);
							break;
						end
					end
				end
				if (((v155 == v13:GUID()) and (v157 == (27299 + 24234))) or ((2132 - (786 + 386)) <= (2837 - 1961))) then
					local v239 = 1379 - (1055 + 324);
					while true do
						if ((v239 == (1340 - (1093 + 247))) or ((1836 + 230) == (99 + 833))) then
							v125.FeralSpiritCount = v125.FeralSpiritCount + (7 - 5);
							v31.After(50 - 35, function()
								v125.FeralSpiritCount = v125.FeralSpiritCount - (5 - 3);
							end);
							break;
						end
					end
				end
				break;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	local function v128()
		if (((12124 - 7299) < (1723 + 3120)) and v102.CleanseSpirit:IsAvailable()) then
			v123.DispellableDebuffs = v123.DispellableCurseDebuffs;
		end
	end
	v9:RegisterForEvent(function()
		v128();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v129()
		if (not v102.AlphaWolf:IsAvailable() or v13:BuffDown(v102.FeralSpiritBuff) or ((14935 - 11058) >= (15638 - 11101))) then
			return 0 + 0;
		end
		local v158 = v28(v102.CrashLightning:TimeSinceLastCast(), v102.ChainLightning:TimeSinceLastCast());
		if ((v158 > (20 - 12)) or (v158 > v102.FeralSpirit:TimeSinceLastCast()) or ((5003 - (364 + 324)) < (4731 - 3005))) then
			return 0 - 0;
		end
		return (3 + 5) - v158;
	end
	local function v130(v159)
		return (v159:DebuffRefreshable(v102.FlameShockDebuff));
	end
	local function v131(v160)
		return v160:DebuffRemains(v102.FlameShockDebuff);
	end
	local function v132(v161)
		return v13:BuffDown(v102.PrimordialWaveBuff);
	end
	local function v133(v162)
		return v162:DebuffRemains(v102.LashingFlamesDebuff);
	end
	local v134 = 0 - 0;
	local function v135()
		if ((v102.CleanseSpirit:IsReady() and v37 and (v123.UnitHasDispellableDebuffByPlayer(v15) or v123.DispellableFriendlyUnit(32 - 12) or v123.UnitHasCurseDebuff(v15))) or ((11173 - 7494) < (1893 - (1249 + 19)))) then
			if ((v134 == (0 + 0)) or ((18002 - 13377) < (1718 - (686 + 400)))) then
				v134 = v30();
			end
			if (v123.Wait(393 + 107, v134) or ((312 - (73 + 156)) > (9 + 1771))) then
				if (((1357 - (721 + 90)) <= (13 + 1064)) and v23(v104.CleanseSpiritFocus)) then
					return "cleanse_spirit dispel";
				end
				v134 = 0 - 0;
			end
		end
	end
	local function v136()
		if (not v15 or not v15:Exists() or not v15:IsInRange(510 - (224 + 246)) or ((1613 - 617) > (7919 - 3618))) then
			return;
		end
		if (((739 + 3331) > (17 + 670)) and v15) then
			if (((v15:HealthPercentage() <= v82) and v72 and v102.HealingSurge:IsReady() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (4 + 1))) or ((1303 - 647) >= (11081 - 7751))) then
				if (v23(v104.HealingSurgeFocus) or ((3005 - (203 + 310)) <= (2328 - (1238 + 755)))) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v137()
		if (((302 + 4020) >= (4096 - (709 + 825))) and (v13:HealthPercentage() <= v86)) then
			if (v102.HealingSurge:IsReady() or ((6702 - 3065) >= (5491 - 1721))) then
				if (v23(v102.HealingSurge) or ((3243 - (196 + 668)) > (18075 - 13497))) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v138()
		local v163 = 0 - 0;
		while true do
			if ((v163 == (833 - (171 + 662))) or ((576 - (4 + 89)) > (2603 - 1860))) then
				if (((894 + 1560) > (2538 - 1960)) and v102.AstralShift:IsReady() and v69 and (v13:HealthPercentage() <= v77)) then
					if (((365 + 565) < (5944 - (35 + 1451))) and v23(v102.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if (((2115 - (28 + 1425)) <= (2965 - (941 + 1052))) and v102.AncestralGuidance:IsReady() and v70 and v123.AreUnitsBelowHealthPercentage(v78, v79, v102.HealingSurge)) then
					if (((4191 + 179) == (5884 - (822 + 692))) and v23(v102.AncestralGuidance)) then
						return "ancestral_guidance defensive 2";
					end
				end
				v163 = 1 - 0;
			end
			if ((v163 == (1 + 0)) or ((5059 - (45 + 252)) <= (852 + 9))) then
				if ((v102.HealingStreamTotem:IsReady() and v71 and v123.AreUnitsBelowHealthPercentage(v80, v81, v102.HealingSurge)) or ((486 + 926) == (10377 - 6113))) then
					if (v23(v102.HealingStreamTotem) or ((3601 - (114 + 319)) < (3090 - 937))) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v102.HealingSurge:IsReady() and v72 and (v13:HealthPercentage() <= v82) and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (6 - 1))) or ((3173 + 1803) < (1983 - 651))) then
					if (((9696 - 5068) == (6591 - (556 + 1407))) and v23(v102.HealingSurge)) then
						return "healing_surge defensive 4";
					end
				end
				v163 = 1208 - (741 + 465);
			end
			if ((v163 == (467 - (170 + 295))) or ((29 + 25) == (363 + 32))) then
				if (((201 - 119) == (68 + 14)) and v103.Healthstone:IsReady() and v73 and (v13:HealthPercentage() <= v83)) then
					if (v23(v104.Healthstone) or ((373 + 208) < (160 + 122))) then
						return "healthstone defensive 3";
					end
				end
				if ((v74 and (v13:HealthPercentage() <= v84)) or ((5839 - (957 + 273)) < (668 + 1827))) then
					if (((462 + 690) == (4389 - 3237)) and (v95 == "Refreshing Healing Potion")) then
						if (((4996 - 3100) <= (10452 - 7030)) and v103.RefreshingHealingPotion:IsReady()) then
							if (v23(v104.RefreshingHealingPotion) or ((4902 - 3912) > (3400 - (389 + 1391)))) then
								return "refreshing healing potion defensive 4";
							end
						end
					end
					if ((v95 == "Dreamwalker's Healing Potion") or ((551 + 326) > (489 + 4206))) then
						if (((6126 - 3435) >= (2802 - (783 + 168))) and v103.DreamwalkersHealingPotion:IsReady()) then
							if (v23(v104.RefreshingHealingPotion) or ((10018 - 7033) >= (4777 + 79))) then
								return "dreamwalkers healing potion defensive";
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v139()
		local v164 = 311 - (309 + 2);
		while true do
			if (((13131 - 8855) >= (2407 - (1090 + 122))) and (v164 == (0 + 0))) then
				v32 = v123.HandleTopTrinket(v105, v35, 134 - 94, nil);
				if (((2212 + 1020) <= (5808 - (628 + 490))) and v32) then
					return v32;
				end
				v164 = 1 + 0;
			end
			if ((v164 == (2 - 1)) or ((4094 - 3198) >= (3920 - (431 + 343)))) then
				v32 = v123.HandleBottomTrinket(v105, v35, 80 - 40, nil);
				if (((8855 - 5794) >= (2337 + 621)) and v32) then
					return v32;
				end
				break;
			end
		end
	end
	local function v140()
		local v165 = 0 + 0;
		while true do
			if (((4882 - (556 + 1139)) >= (659 - (6 + 9))) and ((1 + 0) == v165)) then
				if (((330 + 314) <= (873 - (28 + 141))) and v102.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60)) then
					if (((372 + 586) > (1168 - 221)) and v23(v102.FeralSpirit)) then
						return "feral_spirit precombat 6";
					end
				end
				if (((3182 + 1310) >= (3971 - (486 + 831))) and v102.FlameShock:IsReady() and v42) then
					if (((8956 - 5514) >= (5291 - 3788)) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock precombat 8";
					end
				end
				break;
			end
			if ((v165 == (0 + 0)) or ((10023 - 6853) <= (2727 - (668 + 595)))) then
				if ((v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (81 + 9)))) or ((968 + 3829) == (11966 - 7578))) then
					if (((841 - (23 + 267)) <= (2625 - (1129 + 815))) and v23(v102.WindfuryTotem)) then
						return "windfury_totem precombat 2";
					end
				end
				if (((3664 - (371 + 16)) > (2157 - (1326 + 424))) and v102.PrimordialWave:IsReady() and v48 and ((v63 and v36) or not v63)) then
					if (((8891 - 4196) >= (5170 - 3755)) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave precombat 4";
					end
				end
				v165 = 119 - (88 + 30);
			end
		end
	end
	local function v141()
		local v166 = 771 - (720 + 51);
		while true do
			if ((v166 == (11 - 6)) or ((4988 - (421 + 1355)) <= (1556 - 612))) then
				if ((v102.FrostShock:IsReady() and v43 and (v13:BuffUp(v102.HailstormBuff))) or ((1521 + 1575) <= (2881 - (286 + 797)))) then
					if (((12929 - 9392) == (5858 - 2321)) and v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock))) then
						return "frost_shock single 21";
					end
				end
				if (((4276 - (397 + 42)) >= (491 + 1079)) and v102.LavaLash:IsReady() and v46) then
					if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((3750 - (24 + 776)) == (5871 - 2059))) then
						return "lava_lash single 22";
					end
				end
				if (((5508 - (222 + 563)) >= (5107 - 2789)) and v102.IceStrike:IsReady() and v44) then
					if (v23(v102.IceStrike, not v14:IsInMeleeRange(4 + 1)) or ((2217 - (23 + 167)) > (4650 - (690 + 1108)))) then
						return "ice_strike single 23";
					end
				end
				if ((v102.Windstrike:IsCastable() and v52) or ((410 + 726) > (3561 + 756))) then
					if (((5596 - (40 + 808)) == (782 + 3966)) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
						return "windstrike single 24";
					end
				end
				v166 = 22 - 16;
			end
			if (((3571 + 165) <= (2508 + 2232)) and (v166 == (1 + 0))) then
				if ((v102.LightningBolt:IsCastable() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (576 - (47 + 524))) and v13:BuffDown(v102.CracklingThunderBuff) and v13:BuffUp(v102.AscendanceBuff) and (v120 == "Chain Lightning") and (v13:BuffRemains(v102.AscendanceBuff) > (v102.ChainLightning:CooldownRemains() + v13:GCD()))) or ((2200 + 1190) <= (8364 - 5304))) then
					if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((1493 - 494) > (6141 - 3448))) then
						return "lightning_bolt single 5";
					end
				end
				if (((2189 - (1165 + 561)) < (18 + 583)) and v102.Stormstrike:IsReady() and v49 and (v13:BuffUp(v102.DoomWindsBuff) or v102.DeeplyRootedElements:IsAvailable() or (v102.Stormblast:IsAvailable() and v13:BuffUp(v102.StormbringerBuff)))) then
					if (v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike)) or ((6760 - 4577) < (263 + 424))) then
						return "stormstrike single 6";
					end
				end
				if (((5028 - (341 + 138)) == (1228 + 3321)) and v102.LavaLash:IsReady() and v46 and (v13:BuffUp(v102.HotHandBuff))) then
					if (((9641 - 4969) == (4998 - (89 + 237))) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash single 7";
					end
				end
				if ((v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true))) or ((11799 - 8131) < (831 - 436))) then
					if (v23(v102.WindfuryTotem) or ((5047 - (581 + 300)) == (1675 - (855 + 365)))) then
						return "windfury_totem single 8";
					end
				end
				v166 = 4 - 2;
			end
			if ((v166 == (3 + 4)) or ((5684 - (1030 + 205)) == (2501 + 162))) then
				if ((v102.LightningBolt:IsReady() and v47 and v102.Hailstorm:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0)) and v13:BuffDown(v102.PrimordialWaveBuff)) or ((4563 - (156 + 130)) < (6791 - 3802))) then
					if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((1466 - 596) >= (8497 - 4348))) then
						return "lightning_bolt single 29";
					end
				end
				if (((583 + 1629) < (1857 + 1326)) and v102.FrostShock:IsReady() and v43) then
					if (((4715 - (10 + 59)) > (847 + 2145)) and v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock))) then
						return "frost_shock single 30";
					end
				end
				if (((7062 - 5628) < (4269 - (671 + 492))) and v102.CrashLightning:IsReady() and v39) then
					if (((626 + 160) < (4238 - (369 + 846))) and v23(v102.CrashLightning, not v14:IsInMeleeRange(3 + 5))) then
						return "crash_lightning single 31";
					end
				end
				if ((v102.FireNova:IsReady() and v41 and (v14:DebuffUp(v102.FlameShockDebuff))) or ((2084 + 358) < (2019 - (1036 + 909)))) then
					if (((3606 + 929) == (7613 - 3078)) and v23(v102.FireNova)) then
						return "fire_nova single 32";
					end
				end
				v166 = 211 - (11 + 192);
			end
			if ((v166 == (0 + 0)) or ((3184 - (135 + 40)) <= (5099 - 2994))) then
				if (((1104 + 726) < (8082 - 4413)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v122) and v14:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) then
					if (v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave)) or ((2143 - 713) >= (3788 - (50 + 126)))) then
						return "primordial_wave single 1";
					end
				end
				if (((7470 - 4787) >= (545 + 1915)) and v102.FlameShock:IsReady() and v42 and v14:DebuffDown(v102.FlameShockDebuff) and v102.LashingFlames:IsAvailable()) then
					if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((3217 - (1233 + 180)) >= (4244 - (522 + 447)))) then
						return "flame_shock single 2";
					end
				end
				if ((v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1426 - (107 + 1314))) and v102.ElementalSpirits:IsAvailable() and (v125.FeralSpiritCount >= (2 + 2))) or ((4317 - 2900) > (1542 + 2087))) then
					if (((9521 - 4726) > (1590 - 1188)) and v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast single 3";
					end
				end
				if (((6723 - (716 + 1194)) > (61 + 3504)) and v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v122) and (v13:HasTier(4 + 26, 505 - (74 + 429)))) then
					if (((7546 - 3634) == (1939 + 1973)) and v23(v102.Sundering, not v14:IsInRange(18 - 10))) then
						return "sundering single 4";
					end
				end
				v166 = 1 + 0;
			end
			if (((8696 - 5875) <= (11927 - 7103)) and (v166 == (437 - (279 + 154)))) then
				if (((2516 - (454 + 324)) <= (1727 + 468)) and v102.FlameShock:IsReady() and v42 and (v14:DebuffDown(v102.FlameShockDebuff))) then
					if (((58 - (12 + 5)) <= (1628 + 1390)) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock single 17";
					end
				end
				if (((5465 - 3320) <= (1517 + 2587)) and v102.IceStrike:IsReady() and v44 and v102.ElementalAssault:IsAvailable() and v102.SwirlingMaelstrom:IsAvailable()) then
					if (((3782 - (277 + 816)) < (20703 - 15858)) and v23(v102.IceStrike, not v14:IsInMeleeRange(1188 - (1058 + 125)))) then
						return "ice_strike single 18";
					end
				end
				if ((v102.LavaLash:IsReady() and v46 and (v102.LashingFlames:IsAvailable())) or ((436 + 1886) > (3597 - (815 + 160)))) then
					if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((19453 - 14919) == (4942 - 2860))) then
						return "lava_lash single 19";
					end
				end
				if ((v102.IceStrike:IsReady() and v44 and (v13:BuffDown(v102.IceStrikeBuff))) or ((375 + 1196) > (5457 - 3590))) then
					if (v23(v102.IceStrike, not v14:IsInMeleeRange(1903 - (41 + 1857))) or ((4547 - (1222 + 671)) >= (7743 - 4747))) then
						return "ice_strike single 20";
					end
				end
				v166 = 6 - 1;
			end
			if (((5160 - (229 + 953)) > (3878 - (1111 + 663))) and ((1582 - (874 + 705)) == v166)) then
				if (((420 + 2575) > (1052 + 489)) and v102.LavaBurst:IsReady() and v45 and not v102.ThorimsInvocation:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (10 - 5))) then
					if (((92 + 3157) > (1632 - (642 + 37))) and v23(v102.LavaBurst, not v14:IsSpellInRange(v102.LavaBurst))) then
						return "lava_burst single 13";
					end
				end
				if ((v102.LightningBolt:IsReady() and v47 and ((v13:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 6)) or (v102.StaticAccumulation:IsAvailable() and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1 + 4)))) and v13:BuffDown(v102.PrimordialWaveBuff)) or ((8217 - 4944) > (5027 - (233 + 221)))) then
					if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((7286 - 4135) < (1131 + 153))) then
						return "lightning_bolt single 14";
					end
				end
				if ((v102.CrashLightning:IsReady() and v39 and v102.AlphaWolf:IsAvailable() and v13:BuffUp(v102.FeralSpiritBuff) and (v129() == (1541 - (718 + 823)))) or ((1165 + 685) == (2334 - (266 + 539)))) then
					if (((2324 - 1503) < (3348 - (636 + 589))) and v23(v102.CrashLightning, not v14:IsInMeleeRange(18 - 10))) then
						return "crash_lightning single 15";
					end
				end
				if (((1860 - 958) < (1843 + 482)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v122)) then
					if (((312 + 546) <= (3977 - (657 + 358))) and v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave single 16";
					end
				end
				v166 = 10 - 6;
			end
			if ((v166 == (13 - 7)) or ((5133 - (1151 + 36)) < (1244 + 44))) then
				if ((v102.Stormstrike:IsReady() and v49) or ((853 + 2389) == (1693 - 1126))) then
					if (v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike)) or ((2679 - (1552 + 280)) >= (2097 - (64 + 770)))) then
						return "stormstrike single 25";
					end
				end
				if ((v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v122)) or ((1530 + 723) == (4201 - 2350))) then
					if (v23(v102.Sundering, not v14:IsInRange(2 + 6)) or ((3330 - (157 + 1086)) > (4747 - 2375))) then
						return "sundering single 26";
					end
				end
				if ((v102.BagofTricks:IsReady() and v58 and ((v65 and v35) or not v65)) or ((19467 - 15022) < (6363 - 2214))) then
					if (v23(v102.BagofTricks) or ((2480 - 662) == (904 - (599 + 220)))) then
						return "bag_of_tricks single 27";
					end
				end
				if (((1254 - 624) < (4058 - (1813 + 118))) and v102.FireNova:IsReady() and v41 and v102.SwirlingMaelstrom:IsAvailable() and (v102.FlameShockDebuff:AuraActiveCount() > (0 + 0)) and (v13:BuffStack(v102.MaelstromWeaponBuff) < ((1222 - (841 + 376)) + ((6 - 1) * v24(v102.OverflowingMaelstrom:IsAvailable()))))) then
					if (v23(v102.FireNova) or ((451 + 1487) == (6861 - 4347))) then
						return "fire_nova single 28";
					end
				end
				v166 = 866 - (464 + 395);
			end
			if (((10920 - 6665) >= (27 + 28)) and (v166 == (839 - (467 + 370)))) then
				if (((6196 - 3197) > (849 + 307)) and v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (17 - 12)) and (v102.ElementalBlast:Charges() == v119)) then
					if (((367 + 1983) > (2687 - 1532)) and v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast))) then
						return "elemental_blast single 9";
					end
				end
				if (((4549 - (150 + 370)) <= (6135 - (74 + 1208))) and v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (19 - 11)) and v13:BuffUp(v102.PrimordialWaveBuff) and (v13:BuffDown(v102.SplinteredElementsBuff) or (v122 <= (56 - 44)))) then
					if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((368 + 148) > (3824 - (14 + 376)))) then
						return "lightning_bolt single 10";
					end
				end
				if (((7017 - 2971) >= (1963 + 1070)) and v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (8 + 0)) and v13:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) then
					if (v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning)) or ((2594 + 125) <= (4239 - 2792))) then
						return "chain_lightning single 11";
					end
				end
				if ((v102.ElementalBlast:IsReady() and v40 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (7 + 1)) and ((v125.FeralSpiritCount >= (80 - (23 + 55))) or not v102.ElementalSpirits:IsAvailable())) or ((9797 - 5663) < (2620 + 1306))) then
					if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((148 + 16) >= (4318 - 1533))) then
						return "elemental_blast single 12";
					end
				end
				v166 = 1 + 2;
			end
			if ((v166 == (909 - (652 + 249))) or ((1404 - 879) == (3977 - (708 + 1160)))) then
				if (((89 - 56) == (60 - 27)) and v102.FlameShock:IsReady() and v42) then
					if (((3081 - (10 + 17)) <= (902 + 3113)) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock single 34";
					end
				end
				if (((3603 - (1400 + 332)) < (6486 - 3104)) and v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (1913 - (242 + 1666))) and v13:BuffUp(v102.CracklingThunderBuff) and v102.ElementalSpirits:IsAvailable()) then
					if (((554 + 739) <= (794 + 1372)) and v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning))) then
						return "chain_lightning single 35";
					end
				end
				if ((v102.LightningBolt:IsReady() and v47 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (5 + 0)) and v13:BuffDown(v102.PrimordialWaveBuff)) or ((3519 - (850 + 90)) < (214 - 91))) then
					if (v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt)) or ((2236 - (360 + 1030)) >= (2096 + 272))) then
						return "lightning_bolt single 36";
					end
				end
				if ((v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (254 - 164)))) or ((5519 - 1507) <= (5019 - (909 + 752)))) then
					if (((2717 - (109 + 1114)) <= (5501 - 2496)) and v23(v102.WindfuryTotem)) then
						return "windfury_totem single 37";
					end
				end
				break;
			end
		end
	end
	local function v142()
		if ((v102.CrashLightning:IsReady() and v39 and v102.CrashingStorms:IsAvailable() and ((v102.UnrulyWinds:IsAvailable() and (v117 >= (4 + 6))) or (v117 >= (257 - (6 + 236))))) or ((1961 + 1150) == (1718 + 416))) then
			if (((5554 - 3199) == (4113 - 1758)) and v23(v102.CrashLightning, not v14:IsInMeleeRange(1141 - (1076 + 57)))) then
				return "crash_lightning aoe 1";
			end
		end
		if ((v102.LightningBolt:IsReady() and v47 and ((v102.FlameShockDebuff:AuraActiveCount() >= v117) or (v102.FlameShockDebuff:AuraActiveCount() >= (1 + 5))) and v13:BuffUp(v102.PrimordialWaveBuff) and (v110 == v111) and (v13:BuffDown(v102.SplinteredElementsBuff) or (v122 <= (701 - (579 + 110))))) or ((47 + 541) <= (382 + 50))) then
			if (((2546 + 2251) >= (4302 - (174 + 233))) and v23(v102.LightningBolt, not v14:IsSpellInRange(v102.LightningBolt))) then
				return "lightning_bolt aoe 2";
			end
		end
		if (((9991 - 6414) == (6277 - 2700)) and v102.LavaLash:IsReady() and v46 and v102.MoltenAssault:IsAvailable() and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v14:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v117) and (v102.FlameShockDebuff:AuraActiveCount() < (3 + 3))) then
			if (((4968 - (663 + 511)) > (3295 + 398)) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash aoe 3";
			end
		end
		if ((v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v122) and (v13:BuffDown(v102.PrimordialWaveBuff))) or ((277 + 998) == (12640 - 8540))) then
			local v202 = 0 + 0;
			while true do
				if ((v202 == (0 - 0)) or ((3851 - 2260) >= (1709 + 1871))) then
					if (((1912 - 929) <= (1289 + 519)) and v123.CastCycle(v102.PrimordialWave, v116, v130, not v14:IsSpellInRange(v102.PrimordialWave))) then
						return "primordial_wave aoe 4";
					end
					if (v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave)) or ((197 + 1953) <= (1919 - (478 + 244)))) then
						return "primordial_wave aoe no_cycle 4";
					end
					break;
				end
			end
		end
		if (((4286 - (440 + 77)) >= (534 + 639)) and v102.FlameShock:IsReady() and v42 and (v102.PrimordialWave:IsAvailable() or v102.FireNova:IsAvailable()) and v14:DebuffDown(v102.FlameShockDebuff)) then
			if (((5435 - 3950) == (3041 - (655 + 901))) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock aoe 5";
			end
		end
		if ((v102.ElementalBlast:IsReady() and v40 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v119) or (v125.FeralSpiritCount >= (1 + 1))))) and (v13:BuffStack(v102.MaelstromWeaponBuff) == (4 + 1 + ((4 + 1) * v24(v102.OverflowingMaelstrom:IsAvailable())))) and (not v102.CrashingStorms:IsAvailable() or (v117 <= (11 - 8)))) or ((4760 - (695 + 750)) <= (9499 - 6717))) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((1351 - 475) >= (11920 - 8956))) then
				return "elemental_blast aoe 6";
			end
		end
		if ((v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) == ((356 - (285 + 66)) + ((11 - 6) * v24(v102.OverflowingMaelstrom:IsAvailable()))))) or ((3542 - (682 + 628)) > (403 + 2094))) then
			if (v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning)) or ((2409 - (176 + 123)) <= (139 + 193))) then
				return "chain_lightning aoe 7";
			end
		end
		if (((2674 + 1012) > (3441 - (239 + 30))) and v102.CrashLightning:IsReady() and v39 and (v13:BuffUp(v102.DoomWindsBuff) or v13:BuffDown(v102.CrashLightningBuff) or (v102.AlphaWolf:IsAvailable() and v13:BuffUp(v102.FeralSpiritBuff) and (v129() == (0 + 0))))) then
			if (v23(v102.CrashLightning, not v14:IsInMeleeRange(8 + 0)) or ((7918 - 3444) < (2558 - 1738))) then
				return "crash_lightning aoe 8";
			end
		end
		if (((4594 - (306 + 9)) >= (10056 - 7174)) and v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v122) and (v13:BuffUp(v102.DoomWindsBuff) or v13:HasTier(6 + 24, 2 + 0))) then
			if (v23(v102.Sundering, not v14:IsInRange(4 + 4)) or ((5801 - 3772) >= (4896 - (1140 + 235)))) then
				return "sundering aoe 9";
			end
		end
		if ((v102.FireNova:IsReady() and v41 and ((v102.FlameShockDebuff:AuraActiveCount() >= (4 + 2)) or ((v102.FlameShockDebuff:AuraActiveCount() >= (4 + 0)) and (v102.FlameShockDebuff:AuraActiveCount() >= v117)))) or ((523 + 1514) >= (4694 - (33 + 19)))) then
			if (((622 + 1098) < (13361 - 8903)) and v23(v102.FireNova)) then
				return "fire_nova aoe 10";
			end
		end
		if ((v102.LavaLash:IsReady() and v46 and (v102.LashingFlames:IsAvailable())) or ((193 + 243) > (5924 - 2903))) then
			local v203 = 0 + 0;
			while true do
				if (((1402 - (586 + 103)) <= (78 + 769)) and (v203 == (0 - 0))) then
					if (((3642 - (1309 + 179)) <= (7276 - 3245)) and v123.CastCycle(v102.LavaLash, v116, v133, not v14:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe 11";
					end
					if (((2009 + 2606) == (12393 - 7778)) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
						return "lava_lash aoe no_cycle 11";
					end
					break;
				end
			end
		end
		if ((v102.LavaLash:IsReady() and v46 and ((v102.MoltenAssault:IsAvailable() and v14:DebuffUp(v102.FlameShockDebuff) and (v102.FlameShockDebuff:AuraActiveCount() < v117) and (v102.FlameShockDebuff:AuraActiveCount() < (5 + 1))) or (v102.AshenCatalyst:IsAvailable() and (v13:BuffStack(v102.AshenCatalystBuff) >= (10 - 5))))) or ((7552 - 3762) == (1109 - (295 + 314)))) then
			if (((218 - 129) < (2183 - (1300 + 662))) and v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash))) then
				return "lava_lash aoe 12";
			end
		end
		if (((6449 - 4395) >= (3176 - (1178 + 577))) and v102.IceStrike:IsReady() and v44 and v102.Hailstorm:IsAvailable() and v13:BuffDown(v102.IceStrikeBuff)) then
			if (((360 + 332) < (9040 - 5982)) and v23(v102.IceStrike, not v14:IsInMeleeRange(1410 - (851 + 554)))) then
				return "ice_strike aoe 13";
			end
		end
		if ((v102.FrostShock:IsReady() and v43 and v102.Hailstorm:IsAvailable() and v13:BuffUp(v102.HailstormBuff)) or ((2878 + 376) == (4589 - 2934))) then
			if (v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock)) or ((2814 - 1518) == (5212 - (115 + 187)))) then
				return "frost_shock aoe 14";
			end
		end
		if (((2580 + 788) == (3189 + 179)) and v102.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v122)) then
			if (((10415 - 7772) < (4976 - (160 + 1001))) and v23(v102.Sundering, not v14:IsInRange(7 + 1))) then
				return "sundering aoe 15";
			end
		end
		if (((1320 + 593) > (1009 - 516)) and v102.FlameShock:IsReady() and v42 and v102.MoltenAssault:IsAvailable() and v14:DebuffDown(v102.FlameShockDebuff)) then
			if (((5113 - (237 + 121)) > (4325 - (525 + 372))) and v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock))) then
				return "flame_shock aoe 16";
			end
		end
		if (((2617 - 1236) <= (7783 - 5414)) and v102.FlameShock:IsReady() and v42 and (v102.FireNova:IsAvailable() or v102.PrimordialWave:IsAvailable()) and (v102.FlameShockDebuff:AuraActiveCount() < v117) and (v102.FlameShockDebuff:AuraActiveCount() < (148 - (96 + 46)))) then
			local v204 = 777 - (643 + 134);
			while true do
				if ((v204 == (0 + 0)) or ((11612 - 6769) == (15162 - 11078))) then
					if (((4478 + 191) > (711 - 348)) and v123.CastCycle(v102.FlameShock, v116, v130, not v14:IsSpellInRange(v102.FlameShock))) then
						return "flame_shock aoe 17";
					end
					if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((3836 - 1959) >= (3857 - (316 + 403)))) then
						return "flame_shock aoe no_cycle 17";
					end
					break;
				end
			end
		end
		if (((3152 + 1590) >= (9969 - 6343)) and v102.FireNova:IsReady() and v41 and (v102.FlameShockDebuff:AuraActiveCount() >= (2 + 1))) then
			if (v23(v102.FireNova) or ((11433 - 6893) == (650 + 266))) then
				return "fire_nova aoe 18";
			end
		end
		if ((v102.Stormstrike:IsReady() and v49 and v13:BuffUp(v102.CrashLightningBuff) and (v102.DeeplyRootedElements:IsAvailable() or (v13:BuffStack(v102.ConvergingStormsBuff) == (2 + 4)))) or ((4005 - 2849) > (20751 - 16406))) then
			if (((4646 - 2409) < (244 + 4005)) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike aoe 19";
			end
		end
		if ((v102.CrashLightning:IsReady() and v39 and v102.CrashingStorms:IsAvailable() and v13:BuffUp(v102.CLCrashLightningBuff) and (v117 >= (7 - 3))) or ((132 + 2551) < (67 - 44))) then
			if (((714 - (12 + 5)) <= (3208 - 2382)) and v23(v102.CrashLightning, not v14:IsInMeleeRange(16 - 8))) then
				return "crash_lightning aoe 20";
			end
		end
		if (((2348 - 1243) <= (2916 - 1740)) and v102.Windstrike:IsCastable() and v52) then
			if (((686 + 2693) <= (5785 - (1656 + 317))) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
				return "windstrike aoe 21";
			end
		end
		if ((v102.Stormstrike:IsReady() and v49) or ((703 + 85) >= (1295 + 321))) then
			if (((4929 - 3075) <= (16629 - 13250)) and v23(v102.Stormstrike, not v14:IsSpellInRange(v102.Stormstrike))) then
				return "stormstrike aoe 22";
			end
		end
		if (((4903 - (5 + 349)) == (21607 - 17058)) and v102.IceStrike:IsReady() and v44) then
			if (v23(v102.IceStrike, not v14:IsInMeleeRange(1276 - (266 + 1005))) or ((1992 + 1030) >= (10318 - 7294))) then
				return "ice_strike aoe 23";
			end
		end
		if (((6345 - 1525) > (3894 - (561 + 1135))) and v102.LavaLash:IsReady() and v46) then
			if (v23(v102.LavaLash, not v14:IsSpellInRange(v102.LavaLash)) or ((1382 - 321) >= (16077 - 11186))) then
				return "lava_lash aoe 24";
			end
		end
		if (((2430 - (507 + 559)) <= (11224 - 6751)) and v102.CrashLightning:IsReady() and v39) then
			if (v23(v102.CrashLightning, not v14:IsInMeleeRange(24 - 16)) or ((3983 - (212 + 176)) <= (908 - (250 + 655)))) then
				return "crash_lightning aoe 25";
			end
		end
		if ((v102.FireNova:IsReady() and v41 and (v102.FlameShockDebuff:AuraActiveCount() >= (5 - 3))) or ((8163 - 3491) == (6026 - 2174))) then
			if (((3515 - (1869 + 87)) == (5407 - 3848)) and v23(v102.FireNova)) then
				return "fire_nova aoe 26";
			end
		end
		if ((v102.ElementalBlast:IsReady() and v40 and (not v102.ElementalSpirits:IsAvailable() or (v102.ElementalSpirits:IsAvailable() and ((v102.ElementalBlast:Charges() == v119) or (v125.FeralSpiritCount >= (1903 - (484 + 1417)))))) and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (10 - 5)) and (not v102.CrashingStorms:IsAvailable() or (v117 <= (4 - 1)))) or ((2525 - (48 + 725)) <= (1286 - 498))) then
			if (v23(v102.ElementalBlast, not v14:IsSpellInRange(v102.ElementalBlast)) or ((10482 - 6575) == (103 + 74))) then
				return "elemental_blast aoe 27";
			end
		end
		if (((9273 - 5803) > (156 + 399)) and v102.ChainLightning:IsReady() and v38 and (v13:BuffStack(v102.MaelstromWeaponBuff) >= (2 + 3))) then
			if (v23(v102.ChainLightning, not v14:IsSpellInRange(v102.ChainLightning)) or ((1825 - (152 + 701)) == (1956 - (430 + 881)))) then
				return "chain_lightning aoe 28";
			end
		end
		if (((1219 + 1963) >= (3010 - (557 + 338))) and v102.WindfuryTotem:IsReady() and v51 and (v13:BuffDown(v102.WindfuryTotemBuff, true) or (v102.WindfuryTotem:TimeSinceLastCast() > (27 + 63)))) then
			if (((10970 - 7077) < (15509 - 11080)) and v23(v102.WindfuryTotem)) then
				return "windfury_totem aoe 29";
			end
		end
		if ((v102.FlameShock:IsReady() and v42 and (v14:DebuffDown(v102.FlameShockDebuff))) or ((7616 - 4749) < (4105 - 2200))) then
			if (v23(v102.FlameShock, not v14:IsSpellInRange(v102.FlameShock)) or ((2597 - (499 + 302)) >= (4917 - (39 + 827)))) then
				return "flame_shock aoe 30";
			end
		end
		if (((4468 - 2849) <= (8388 - 4632)) and v102.FrostShock:IsReady() and v43 and not v102.Hailstorm:IsAvailable()) then
			if (((2398 - 1794) == (927 - 323)) and v23(v102.FrostShock, not v14:IsSpellInRange(v102.FrostShock))) then
				return "frost_shock aoe 31";
			end
		end
	end
	local function v143()
		local v167 = 0 + 0;
		while true do
			if ((v167 == (2 - 1)) or ((718 + 3766) == (1424 - 524))) then
				if (((not v107 or (v109 < (600104 - (103 + 1)))) and v53 and v102.FlametongueWeapon:IsCastable()) or ((5013 - (475 + 79)) <= (2405 - 1292))) then
					if (((11622 - 7990) > (440 + 2958)) and v23(v102.FlametongueWeapon)) then
						return "flametongue_weapon enchant";
					end
				end
				if (((3593 + 489) <= (6420 - (1395 + 108))) and v85) then
					local v240 = 0 - 0;
					while true do
						if (((6036 - (7 + 1197)) >= (605 + 781)) and (v240 == (0 + 0))) then
							v32 = v137();
							if (((456 - (27 + 292)) == (401 - 264)) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				v167 = 2 - 0;
			end
			if ((v167 == (8 - 6)) or ((3096 - 1526) >= (8250 - 3918))) then
				if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or ((4203 - (43 + 96)) <= (7419 - 5600))) then
					if (v23(v102.AncestralSpirit, nil, true) or ((11272 - 6286) < (1307 + 267))) then
						return "resurrection";
					end
				end
				if (((1250 + 3176) > (339 - 167)) and v123.TargetIsValid() and v33) then
					if (((225 + 361) > (852 - 397)) and not v13:AffectingCombat()) then
						local v250 = 0 + 0;
						while true do
							if (((61 + 765) == (2577 - (1414 + 337))) and (v250 == (1940 - (1642 + 298)))) then
								v32 = v140();
								if (v32 or ((10476 - 6457) > (12776 - 8335))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((5985 - 3968) < (1403 + 2858)) and (v167 == (0 + 0))) then
				if (((5688 - (357 + 615)) > (57 + 23)) and v75 and v102.EarthShield:IsCastable() and v13:BuffDown(v102.EarthShieldBuff) and ((v76 == "Earth Shield") or (v102.ElementalOrbit:IsAvailable() and v13:BuffUp(v102.LightningShield)))) then
					if (v23(v102.EarthShield) or ((8605 - 5098) == (2804 + 468))) then
						return "earth_shield main 2";
					end
				elseif ((v75 and v102.LightningShield:IsCastable() and v13:BuffDown(v102.LightningShieldBuff) and ((v76 == "Lightning Shield") or (v102.ElementalOrbit:IsAvailable() and v13:BuffUp(v102.EarthShield)))) or ((1877 - 1001) >= (2460 + 615))) then
					if (((296 + 4056) > (1606 + 948)) and v23(v102.LightningShield)) then
						return "lightning_shield main 2";
					end
				end
				if (((not v106 or (v108 < (601301 - (384 + 917)))) and v53 and v102.WindfuryWeapon:IsCastable()) or ((5103 - (128 + 569)) < (5586 - (1407 + 136)))) then
					if (v23(v102.WindfuryWeapon) or ((3776 - (687 + 1200)) >= (5093 - (556 + 1154)))) then
						return "windfury_weapon enchant";
					end
				end
				v167 = 3 - 2;
			end
		end
	end
	local function v144()
		local v168 = 95 - (9 + 86);
		while true do
			if (((2313 - (275 + 146)) <= (445 + 2289)) and (v168 == (65 - (29 + 35)))) then
				if (((8522 - 6599) < (6624 - 4406)) and v93) then
					local v241 = 0 - 0;
					while true do
						if (((1416 + 757) > (1391 - (53 + 959))) and (v241 == (409 - (312 + 96)))) then
							if (v89 or ((4496 - 1905) == (3694 - (147 + 138)))) then
								v32 = v123.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 929 - (813 + 86));
								if (((4080 + 434) > (6158 - 2834)) and v32) then
									return v32;
								end
							end
							if (((v13:BuffStack(v102.MaelstromWeaponBuff) >= (497 - (18 + 474))) and v90) or ((71 + 137) >= (15757 - 10929))) then
								v32 = v123.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 1126 - (860 + 226), true);
								if (v32 or ((1886 - (121 + 182)) > (440 + 3127))) then
									return v32;
								end
							end
							break;
						end
						if ((v241 == (1240 - (988 + 252))) or ((149 + 1164) == (249 + 545))) then
							if (((5144 - (49 + 1921)) > (3792 - (223 + 667))) and v87) then
								v32 = v123.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 92 - (51 + 1));
								if (((7091 - 2971) <= (9122 - 4862)) and v32) then
									return v32;
								end
							end
							if (v88 or ((2008 - (146 + 979)) > (1349 + 3429))) then
								v32 = v123.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 635 - (311 + 294));
								if (v32 or ((10095 - 6475) >= (2072 + 2819))) then
									return v32;
								end
							end
							v241 = 1444 - (496 + 947);
						end
					end
				end
				if (((5616 - (1233 + 125)) > (381 + 556)) and v94) then
					local v242 = 0 + 0;
					while true do
						if ((v242 == (0 + 0)) or ((6514 - (963 + 682)) < (757 + 149))) then
							v32 = v123.HandleIncorporeal(v102.Hex, v104.HexMouseOver, 1534 - (504 + 1000), true);
							if (v32 or ((825 + 400) > (3851 + 377))) then
								return v32;
							end
							break;
						end
					end
				end
				v168 = 1 + 1;
			end
			if (((4907 - 1579) > (1913 + 325)) and ((2 + 0) == v168)) then
				if (((4021 - (156 + 26)) > (810 + 595)) and v92) then
					local v243 = 0 - 0;
					while true do
						if ((v243 == (164 - (149 + 15))) or ((2253 - (890 + 70)) <= (624 - (39 + 78)))) then
							if (v15 or ((3378 - (14 + 468)) < (1770 - 965))) then
								v32 = v135();
								if (((6473 - 4157) == (1195 + 1121)) and v32) then
									return v32;
								end
							end
							if ((v16 and v16:Exists() and not v13:CanAttack(v16) and (v123.UnitHasDispellableDebuffByPlayer(v16) or v123.UnitHasCurseDebuff(v16))) or ((1544 + 1026) == (326 + 1207))) then
								if (v102.CleanseSpirit:IsCastable() or ((399 + 484) == (383 + 1077))) then
									if (v23(v104.CleanseSpiritMouseover, not v16:IsSpellInRange(v102.PurifySpirit)) or ((8840 - 4221) <= (988 + 11))) then
										return "purify_spirit dispel mouseover";
									end
								end
							end
							break;
						end
					end
				end
				if ((v102.GreaterPurge:IsAvailable() and v100 and v102.GreaterPurge:IsReady() and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v123.UnitHasMagicBuff(v14)) or ((11982 - 8572) > (104 + 4012))) then
					if (v23(v102.GreaterPurge, not v14:IsSpellInRange(v102.GreaterPurge)) or ((954 - (12 + 39)) >= (2846 + 213))) then
						return "greater_purge damage";
					end
				end
				v168 = 9 - 6;
			end
			if ((v168 == (14 - 10)) or ((1179 + 2797) < (1504 + 1353))) then
				if (((12501 - 7571) > (1537 + 770)) and v32) then
					return v32;
				end
				if (v123.TargetIsValid() or ((19553 - 15507) < (3001 - (1596 + 114)))) then
					local v244 = 0 - 0;
					local v245;
					while true do
						if ((v244 == (713 - (164 + 549))) or ((5679 - (1059 + 379)) == (4401 - 856))) then
							v245 = v123.HandleDPSPotion(v13:BuffUp(v102.FeralSpiritBuff));
							if (v245 or ((2098 + 1950) > (714 + 3518))) then
								return v245;
							end
							if ((v99 < v122) or ((2142 - (145 + 247)) >= (2850 + 623))) then
								if (((1463 + 1703) == (9385 - 6219)) and v57 and ((v35 and v64) or not v64)) then
									local v259 = 0 + 0;
									while true do
										if (((1519 + 244) < (6046 - 2322)) and ((720 - (254 + 466)) == v259)) then
											v32 = v139();
											if (((617 - (544 + 16)) <= (8653 - 5930)) and v32) then
												return v32;
											end
											break;
										end
									end
								end
							end
							if (((v99 < v122) and v58 and ((v65 and v35) or not v65)) or ((2698 - (294 + 334)) == (696 - (236 + 17)))) then
								local v257 = 0 + 0;
								while true do
									if ((v257 == (0 + 0)) or ((10187 - 7482) == (6595 - 5202))) then
										if ((v102.BloodFury:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (26 + 24)))) or ((3790 + 811) < (855 - (413 + 381)))) then
											if (v23(v102.BloodFury) or ((59 + 1331) >= (10089 - 5345))) then
												return "blood_fury racial";
											end
										end
										if ((v102.Berserking:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff))) or ((5202 - 3199) > (5804 - (582 + 1388)))) then
											if (v23(v102.Berserking) or ((265 - 109) > (2801 + 1112))) then
												return "berserking racial";
											end
										end
										v257 = 365 - (326 + 38);
									end
									if (((576 - 381) == (278 - 83)) and (v257 == (621 - (47 + 573)))) then
										if (((1095 + 2010) >= (7627 - 5831)) and v102.Fireblood:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (81 - 31)))) then
											if (((6043 - (1269 + 395)) >= (2623 - (76 + 416))) and v23(v102.Fireblood)) then
												return "fireblood racial";
											end
										end
										if (((4287 - (319 + 124)) >= (4669 - 2626)) and v102.AncestralCall:IsCastable() and (not v102.Ascendance:IsAvailable() or v13:BuffUp(v102.AscendanceBuff) or (v102.Ascendance:CooldownRemains() > (1057 - (564 + 443))))) then
											if (v23(v102.AncestralCall) or ((8947 - 5715) <= (3189 - (337 + 121)))) then
												return "ancestral_call racial";
											end
										end
										break;
									end
								end
							end
							v244 = 2 - 1;
						end
						if (((16339 - 11434) == (6816 - (1261 + 650))) and (v244 == (1 + 1))) then
							if ((v102.Ascendance:IsCastable() and v54 and ((v59 and v35) or not v59) and (v99 < v122) and v14:DebuffUp(v102.FlameShockDebuff) and (((v120 == "Lightning Bolt") and (v117 == (1 - 0))) or ((v120 == "Chain Lightning") and (v117 > (1818 - (772 + 1045)))))) or ((584 + 3552) >= (4555 - (102 + 42)))) then
								if (v23(v102.Ascendance) or ((4802 - (1524 + 320)) == (5287 - (1049 + 221)))) then
									return "ascendance main 4";
								end
							end
							if (((1384 - (18 + 138)) >= (1989 - 1176)) and v102.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61) and (v99 < v122)) then
								if (v23(v102.DoomWinds, not v14:IsInMeleeRange(1107 - (67 + 1035))) or ((3803 - (136 + 212)) > (17210 - 13160))) then
									return "doom_winds main 5";
								end
							end
							if (((195 + 48) == (225 + 18)) and (v117 == (1605 - (240 + 1364)))) then
								v32 = v141();
								if (v32 or ((1353 - (1050 + 32)) > (5612 - 4040))) then
									return v32;
								end
							end
							if (((1621 + 1118) < (4348 - (331 + 724))) and v34 and (v117 > (1 + 0))) then
								v32 = v142();
								if (v32 or ((4586 - (269 + 375)) < (1859 - (267 + 458)))) then
									return v32;
								end
							end
							break;
						end
						if ((v244 == (1 + 0)) or ((5178 - 2485) == (5791 - (667 + 151)))) then
							if (((3643 - (1410 + 87)) == (4043 - (1504 + 393))) and v102.TotemicProjection:IsCastable() and (v102.WindfuryTotem:TimeSinceLastCast() < (243 - 153)) and v13:BuffDown(v102.WindfuryTotemBuff, true)) then
								if (v23(v104.TotemicProjectionPlayer) or ((5821 - 3577) == (4020 - (461 + 335)))) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if ((v102.Windstrike:IsCastable() and v52) or ((627 + 4277) <= (3677 - (1730 + 31)))) then
								if (((1757 - (728 + 939)) <= (3771 - 2706)) and v23(v102.Windstrike, not v14:IsSpellInRange(v102.Windstrike))) then
									return "windstrike main 1";
								end
							end
							if (((9740 - 4938) == (11002 - 6200)) and v102.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v122) and (v13:HasTier(1099 - (138 + 930), 2 + 0))) then
								if (v23(v102.PrimordialWave, not v14:IsSpellInRange(v102.PrimordialWave)) or ((1783 + 497) <= (438 + 73))) then
									return "primordial_wave main 2";
								end
							end
							if ((v102.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60) and (v99 < v122)) or ((6843 - 5167) <= (2229 - (459 + 1307)))) then
								if (((5739 - (474 + 1396)) == (6755 - 2886)) and v23(v102.FeralSpirit)) then
									return "feral_spirit main 3";
								end
							end
							v244 = 2 + 0;
						end
					end
				end
				break;
			end
			if (((4 + 1154) <= (7484 - 4871)) and (v168 == (0 + 0))) then
				v32 = v138();
				if (v32 or ((7891 - 5527) <= (8717 - 6718))) then
					return v32;
				end
				v168 = 592 - (562 + 29);
			end
			if (((3 + 0) == v168) or ((6341 - (374 + 1045)) < (154 + 40))) then
				if ((v102.Purge:IsReady() and v100 and v37 and v91 and not v13:IsCasting() and not v13:IsChanneling() and v123.UnitHasMagicBuff(v14)) or ((6492 - 4401) < (669 - (448 + 190)))) then
					if (v23(v102.Purge, not v14:IsSpellInRange(v102.Purge)) or ((785 + 1645) >= (2200 + 2672))) then
						return "purge damage";
					end
				end
				v32 = v136();
				v168 = 3 + 1;
			end
		end
	end
	local function v145()
		v54 = EpicSettings.Settings['useAscendance'];
		v56 = EpicSettings.Settings['useDoomWinds'];
		v55 = EpicSettings.Settings['useFeralSpirit'];
		v38 = EpicSettings.Settings['useChainlightning'];
		v39 = EpicSettings.Settings['useCrashLightning'];
		v40 = EpicSettings.Settings['useElementalBlast'];
		v41 = EpicSettings.Settings['useFireNova'];
		v42 = EpicSettings.Settings['useFlameShock'];
		v43 = EpicSettings.Settings['useFrostShock'];
		v44 = EpicSettings.Settings['useIceStrike'];
		v45 = EpicSettings.Settings['useLavaBurst'];
		v46 = EpicSettings.Settings['useLavaLash'];
		v47 = EpicSettings.Settings['useLightningBolt'];
		v48 = EpicSettings.Settings['usePrimordialWave'];
		v49 = EpicSettings.Settings['useStormStrike'];
		v50 = EpicSettings.Settings['useSundering'];
		v52 = EpicSettings.Settings['useWindstrike'];
		v51 = EpicSettings.Settings['useWindfuryTotem'];
		v53 = EpicSettings.Settings['useWeaponEnchant'];
		v101 = EpicSettings.Settings['useWeapon'];
		v59 = EpicSettings.Settings['ascendanceWithCD'];
		v61 = EpicSettings.Settings['doomWindsWithCD'];
		v60 = EpicSettings.Settings['feralSpiritWithCD'];
		v63 = EpicSettings.Settings['primordialWaveWithMiniCD'];
		v62 = EpicSettings.Settings['sunderingWithMiniCD'];
	end
	local function v146()
		local v194 = 0 - 0;
		while true do
			if ((v194 == (0 - 0)) or ((6264 - (1307 + 187)) < (6880 - 5145))) then
				v66 = EpicSettings.Settings['useWindShear'];
				v67 = EpicSettings.Settings['useCapacitorTotem'];
				v68 = EpicSettings.Settings['useThunderstorm'];
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v194 = 2 - 1;
			end
			if ((v194 == (11 - 7)) or ((5122 - (232 + 451)) <= (2244 + 106))) then
				v86 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
				v100 = EpicSettings.Settings['usePurgeTarget'];
				v87 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v88 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v194 = 569 - (510 + 54);
			end
			if ((v194 == (10 - 5)) or ((4515 - (13 + 23)) < (8705 - 4239))) then
				v89 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v90 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
			if (((3659 - 1112) > (2225 - 1000)) and (v194 == (1090 - (830 + 258)))) then
				v79 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
				v77 = EpicSettings.Settings['astralShiftHP'] or (0 + 0);
				v80 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
				v81 = EpicSettings.Settings['healingStreamTotemGroup'] or (1441 - (860 + 581));
				v194 = 10 - 7;
			end
			if (((3708 + 963) > (2915 - (237 + 4))) and (v194 == (6 - 3))) then
				v82 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 - 0);
				v75 = EpicSettings.Settings['autoShield'];
				v76 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v85 = EpicSettings.Settings['healOOC'];
				v194 = 7 - 3;
			end
			if ((v194 == (1 + 0)) or ((2123 + 1573) < (12560 - 9233))) then
				v69 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useMaelstromHealingSurge'];
				v71 = EpicSettings.Settings['useHealingStreamTotem'];
				v78 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v194 = 2 + 0;
			end
		end
	end
	local function v147()
		local v195 = 1426 - (85 + 1341);
		while true do
			if ((v195 == (0 - 0)) or ((12827 - 8285) == (3342 - (45 + 327)))) then
				v99 = EpicSettings.Settings['fightRemainsCheck'] or (0 - 0);
				v96 = EpicSettings.Settings['InterruptWithStun'];
				v97 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v195 = 503 - (444 + 58);
			end
			if (((110 + 142) <= (341 + 1636)) and (v195 == (2 + 2))) then
				v83 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v84 = EpicSettings.Settings['healingPotionHP'] or (1732 - (64 + 1668));
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v195 = 1978 - (1227 + 746);
			end
			if ((v195 == (5 - 3)) or ((2664 - 1228) == (4269 - (415 + 79)))) then
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v64 = EpicSettings.Settings['trinketsWithCD'];
				v195 = 1 + 2;
			end
			if ((v195 == (496 - (142 + 349))) or ((694 + 924) < (1278 - 348))) then
				v93 = EpicSettings.Settings['handleAfflicted'];
				v94 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if (((2348 + 2375) > (2926 + 1227)) and (v195 == (2 - 1))) then
				v98 = EpicSettings.Settings['InterruptThreshold'];
				v92 = EpicSettings.Settings['DispelDebuffs'];
				v91 = EpicSettings.Settings['DispelBuffs'];
				v195 = 1866 - (1710 + 154);
			end
			if ((v195 == (321 - (200 + 118))) or ((1448 + 2206) >= (8136 - 3482))) then
				v65 = EpicSettings.Settings['racialsWithCD'];
				v73 = EpicSettings.Settings['useHealthstone'];
				v74 = EpicSettings.Settings['useHealingPotion'];
				v195 = 5 - 1;
			end
		end
	end
	local function v148()
		local v196 = 0 + 0;
		while true do
			if (((941 + 10) <= (803 + 693)) and (v196 == (1 + 2))) then
				v106, v108, _, _, v107, v109 = v26();
				v115 = v13:GetEnemiesInRange(86 - 46);
				v116 = v13:GetEnemiesInMeleeRange(1260 - (363 + 887));
				v196 = 6 - 2;
			end
			if ((v196 == (9 - 7)) or ((268 + 1468) == (1335 - 764))) then
				v37 = EpicSettings.Toggles['dispel'];
				v36 = EpicSettings.Toggles['minicds'];
				if (v13:IsDeadOrGhost() or ((613 + 283) > (6433 - (674 + 990)))) then
					return v32;
				end
				v196 = 1 + 2;
			end
			if ((v196 == (0 + 0)) or ((1656 - 611) <= (2075 - (507 + 548)))) then
				v146();
				v145();
				v147();
				v196 = 838 - (289 + 548);
			end
			if ((v196 == (1823 - (821 + 997))) or ((1415 - (195 + 60)) <= (89 + 239))) then
				if (((5309 - (251 + 1250)) > (8565 - 5641)) and v13:AffectingCombat()) then
					if (((2674 + 1217) < (5951 - (809 + 223))) and v13:PrevGCD(1 - 0, v102.ChainLightning)) then
						v120 = "Chain Lightning";
					elseif (v13:PrevGCD(2 - 1, v102.LightningBolt) or ((7386 - 5152) <= (1107 + 395))) then
						v120 = "Lightning Bolt";
					end
				end
				if ((not v13:IsChanneling() and not v13:IsChanneling()) or ((1316 + 1196) < (1049 - (14 + 603)))) then
					local v246 = 129 - (118 + 11);
					while true do
						if ((v246 == (0 + 0)) or ((1540 + 308) == (2520 - 1655))) then
							if (v93 or ((5631 - (551 + 398)) <= (2870 + 1671))) then
								local v258 = 0 + 0;
								while true do
									if ((v258 == (0 + 0)) or ((11253 - 8227) >= (9322 - 5276))) then
										if (((651 + 1357) > (2532 - 1894)) and v87) then
											local v260 = 0 + 0;
											while true do
												if (((1864 - (40 + 49)) <= (12311 - 9078)) and ((490 - (99 + 391)) == v260)) then
													v32 = v123.HandleAfflicted(v102.CleanseSpirit, v104.CleanseSpiritMouseover, 34 + 6);
													if (v32 or ((19970 - 15427) == (4945 - 2948))) then
														return v32;
													end
													break;
												end
											end
										end
										if (v88 or ((3022 + 80) < (1915 - 1187))) then
											v32 = v123.HandleAfflicted(v102.TremorTotem, v102.TremorTotem, 1634 - (1032 + 572));
											if (((762 - (203 + 214)) == (2162 - (568 + 1249))) and v32) then
												return v32;
											end
										end
										v258 = 1 + 0;
									end
									if ((v258 == (2 - 1)) or ((10919 - 8092) < (1684 - (913 + 393)))) then
										if (v89 or ((9816 - 6340) < (3669 - 1072))) then
											local v261 = 410 - (269 + 141);
											while true do
												if (((6847 - 3768) < (6775 - (362 + 1619))) and (v261 == (1625 - (950 + 675)))) then
													v32 = v123.HandleAfflicted(v102.PoisonCleansingTotem, v102.PoisonCleansingTotem, 12 + 18);
													if (((6033 - (216 + 963)) > (5751 - (485 + 802))) and v32) then
														return v32;
													end
													break;
												end
											end
										end
										if (((v13:BuffStack(v102.MaelstromWeaponBuff) >= (564 - (432 + 127))) and v90) or ((5985 - (1065 + 8)) == (2088 + 1670))) then
											local v262 = 1601 - (635 + 966);
											while true do
												if (((91 + 35) <= (3524 - (5 + 37))) and (v262 == (0 - 0))) then
													v32 = v123.HandleAfflicted(v102.HealingSurge, v104.HealingSurgeMouseover, 17 + 23, true);
													if (v32 or ((3757 - 1383) == (2047 + 2327))) then
														return v32;
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							if (((3272 - 1697) == (5971 - 4396)) and v13:AffectingCombat()) then
								v32 = v144();
								if (v32 or ((4212 - 1978) == (3478 - 2023))) then
									return v32;
								end
							else
								v32 = v143();
								if (v32 or ((768 + 299) > (2308 - (318 + 211)))) then
									return v32;
								end
							end
							break;
						end
					end
				end
				break;
			end
			if (((10633 - 8472) >= (2521 - (963 + 624))) and (v196 == (2 + 2))) then
				if (((2458 - (518 + 328)) == (3757 - 2145)) and v34) then
					local v247 = 0 - 0;
					while true do
						if (((4669 - (301 + 16)) >= (8303 - 5470)) and (v247 == (0 - 0))) then
							v118 = v127(104 - 64);
							v117 = #v116;
							break;
						end
					end
				else
					local v248 = 0 + 0;
					while true do
						if ((v248 == (0 + 0)) or ((6878 - 3656) < (1849 + 1224))) then
							v118 = 1 + 0;
							v117 = 3 - 2;
							break;
						end
					end
				end
				if (((241 + 503) <= (3961 - (829 + 190))) and v37 and v92) then
					if ((v13:AffectingCombat() and v102.CleanseSpirit:IsAvailable()) or ((6539 - 4706) <= (1672 - 350))) then
						local v251 = 0 - 0;
						local v252;
						while true do
							if ((v251 == (2 - 1)) or ((822 + 2645) <= (345 + 710))) then
								if (((10747 - 7206) == (3342 + 199)) and v32) then
									return v32;
								end
								break;
							end
							if (((613 - (520 + 93)) == v251) or ((3833 - (259 + 17)) >= (231 + 3772))) then
								v252 = v92 and v102.CleanseSpirit:IsReady() and v37;
								v32 = v123.FocusUnit(v252, nil, 8 + 12, nil, 84 - 59, v102.HealingSurge);
								v251 = 592 - (396 + 195);
							end
						end
					end
				end
				if (v123.TargetIsValid() or v13:AffectingCombat() or ((1906 - 1249) >= (3429 - (440 + 1321)))) then
					local v249 = 1829 - (1059 + 770);
					while true do
						if ((v249 == (0 - 0)) or ((1572 - (424 + 121)) > (704 + 3154))) then
							v121 = v9.BossFightRemains(nil, true);
							v122 = v121;
							v249 = 1348 - (641 + 706);
						end
						if (((1 + 0) == v249) or ((4094 - (249 + 191)) < (1960 - 1510))) then
							if (((845 + 1046) < (17162 - 12709)) and (v122 == (11538 - (183 + 244)))) then
								v122 = v9.FightRemains(v116, false);
							end
							break;
						end
					end
				end
				v196 = 1 + 4;
			end
			if ((v196 == (731 - (434 + 296))) or ((10020 - 6880) < (2641 - (169 + 343)))) then
				v33 = EpicSettings.Toggles['ooc'];
				v34 = EpicSettings.Toggles['aoe'];
				v35 = EpicSettings.Toggles['cds'];
				v196 = 2 + 0;
			end
		end
	end
	local function v149()
		local v197 = 0 - 0;
		while true do
			if ((v197 == (2 - 1)) or ((2094 + 461) < (3516 - 2276))) then
				v20.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
			if (((1123 - (651 + 472)) == v197) or ((3573 + 1154) <= (2038 + 2684))) then
				v102.FlameShockDebuff:RegisterAuraTracking();
				v128();
				v197 = 1 - 0;
			end
		end
	end
	v20.SetAPL(746 - (397 + 86), v148, v149);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

