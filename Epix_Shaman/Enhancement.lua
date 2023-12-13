local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 - 0;
	local v6;
	while true do
		if ((v5 == (0 - 0)) or ((4580 - (463 + 171)) <= (739 + 1337))) then
			v6 = v0[v4];
			if (not v6 or ((2862 - 2119) == (1664 - 1181))) then
				return v1(v4, ...);
			end
			v5 = 1 + 0;
		end
		if (((6275 - 3821) > (1266 - (364 + 324))) and (v5 == (2 - 1))) then
			return v6(...);
		end
	end
end
v0["Epix_Shaman_Enhancement.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v10.Utils;
	local v14 = v12.Player;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v10.Spell;
	local v18 = v10.MultiSpell;
	local v19 = v10.Item;
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
	local v101 = v17.Shaman.Enhancement;
	local v102 = v19.Shaman.Enhancement;
	local v103 = v22.Shaman.Enhancement;
	local v104 = {};
	local v105, v106;
	local v107, v108;
	local v109, v110, v111, v112;
	local v113 = (v101.LavaBurst:IsAvailable() and (4 - 2)) or (1 + 0);
	local v114 = "Lightning Bolt";
	local v115 = 46492 - 35381;
	local v116 = 17794 - 6683;
	local v117 = v20.Commons.Everyone;
	v20.Commons.Shaman = {};
	local v119 = v20.Commons.Shaman;
	v119.LastSKCast = 0 - 0;
	v119.LastSKBuff = 1268 - (1249 + 19);
	v119.LastT302pcBuff = 0 + 0;
	v119.FeralSpiritCount = 0 - 0;
	v10:RegisterForEvent(function()
		v113 = (v101.LavaBurst:IsAvailable() and (1088 - (686 + 400))) or (1 + 0);
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		v114 = "Lightning Bolt";
		v115 = 11340 - (73 + 156);
		v116 = 53 + 11058;
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v149, v150, v150, v150, v150, v150, v150, v150, v151 = select(815 - (721 + 90), ...);
		if (((11 + 919) < (14474 - 10016)) and (v149 == v14:GUID()) and (v151 == (192104 - (224 + 246)))) then
			v119.LastSKCast = v30();
		end
		if (((1072 - 410) <= (1789 - 817)) and v14:HasTier(6 + 25, 1 + 1) and (v149 == v14:GUID()) and (v151 == (276150 + 99832))) then
			local v182 = 0 - 0;
			while true do
				if (((14542 - 10172) == (4883 - (203 + 310))) and (v182 == (1993 - (1238 + 755)))) then
					v119.FeralSpiritCount = v119.FeralSpiritCount + 1 + 0;
					v31.After(1549 - (709 + 825), function()
						v119.FeralSpiritCount = v119.FeralSpiritCount - (1 - 0);
					end);
					break;
				end
			end
		end
		if (((v149 == v14:GUID()) and (v151 == (75067 - 23534))) or ((5626 - (196 + 668)) <= (3399 - 2538))) then
			local v183 = 0 - 0;
			while true do
				if ((v183 == (833 - (171 + 662))) or ((1505 - (4 + 89)) == (14945 - 10681))) then
					v119.FeralSpiritCount = v119.FeralSpiritCount + 1 + 1;
					v31.After(65 - 50, function()
						v119.FeralSpiritCount = v119.FeralSpiritCount - (1 + 1);
					end);
					break;
				end
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v10:RegisterForSelfCombatEvent(function(...)
		local v152, v153, v153, v153, v154 = select(1494 - (35 + 1451), ...);
		if (((v152 == v14:GUID()) and (v154 == (193087 - (28 + 1425)))) or ((5161 - (941 + 1052)) < (2065 + 88))) then
			v119.LastSKBuff = v30();
			v31.After(1514.1 - (822 + 692), function()
				if ((v119.LastSKBuff ~= v119.LastSKCast) or ((7103 - 2127) < (628 + 704))) then
					v119.LastT302pcBuff = v119.LastSKBuff;
				end
			end);
		end
	end, "SPELL_AURA_APPLIED");
	local function v124()
		if (((4925 - (45 + 252)) == (4580 + 48)) and v101.CleanseSpirit:IsAvailable()) then
			v117.DispellableDebuffs = v117.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v124();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v125()
		for v179 = 1 + 0, 14 - 8, 434 - (114 + 319) do
			if (v29(v14:TotemName(v179), "Totem") or ((77 - 23) == (506 - 111))) then
				return v179;
			end
		end
	end
	local function v126()
		local v155 = 0 + 0;
		local v156;
		while true do
			if (((121 - 39) == (171 - 89)) and (v155 == (1964 - (556 + 1407)))) then
				if ((v156 > (1214 - (741 + 465))) or (v156 > v101.FeralSpirit:TimeSinceLastCast()) or ((1046 - (170 + 295)) < (149 + 133))) then
					return 0 + 0;
				end
				return (19 - 11) - v156;
			end
			if ((v155 == (0 + 0)) or ((2956 + 1653) < (1413 + 1082))) then
				if (((2382 - (957 + 273)) == (309 + 843)) and (not v101.AlphaWolf:IsAvailable() or v14:BuffDown(v101.FeralSpiritBuff))) then
					return 0 + 0;
				end
				v156 = v28(v101.CrashLightning:TimeSinceLastCast(), v101.ChainLightning:TimeSinceLastCast());
				v155 = 3 - 2;
			end
		end
	end
	local function v127(v157)
		return (v157:DebuffRefreshable(v101.FlameShockDebuff));
	end
	local function v128(v158)
		return (v158:DebuffRefreshable(v101.LashingFlamesDebuff));
	end
	local function v129(v159)
		return (v159:DebuffRemains(v101.FlameShockDebuff));
	end
	local function v130(v160)
		return (v14:BuffDown(v101.PrimordialWaveBuff));
	end
	local function v131(v161)
		return (v15:DebuffRemains(v101.LashingFlamesDebuff));
	end
	local function v132(v162)
		return (v101.LashingFlames:IsAvailable());
	end
	local function v133(v163)
		return v163:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (15 - 9));
	end
	local function v134()
		if (((5791 - 3895) <= (16944 - 13522)) and v101.CleanseSpirit:IsReady() and v37 and v117.DispellableFriendlyUnit(1805 - (389 + 1391))) then
			if (v23(v103.CleanseSpiritFocus) or ((622 + 368) > (169 + 1451))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v135()
		local v164 = 0 - 0;
		while true do
			if ((v164 == (951 - (783 + 168))) or ((2943 - 2066) > (4619 + 76))) then
				if (((3002 - (309 + 2)) >= (5684 - 3833)) and (not v16 or not v16:Exists() or not v16:IsInRange(1252 - (1090 + 122)))) then
					return;
				end
				if (v16 or ((968 + 2017) >= (16308 - 11452))) then
					if (((2927 + 1349) >= (2313 - (628 + 490))) and (v16:HealthPercentage() <= v82) and v72 and v101.HealingSurge:IsReady() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1 + 4))) then
						if (((8001 - 4769) <= (21433 - 16743)) and v23(v103.HealingSurgeFocus)) then
							return "healing_surge heal focus";
						end
					end
				end
				break;
			end
		end
	end
	local function v136()
		if ((v14:HealthPercentage() <= v86) or ((1670 - (431 + 343)) >= (6353 - 3207))) then
			if (((8855 - 5794) >= (2337 + 621)) and v101.HealingSurge:IsReady()) then
				if (((408 + 2779) >= (2339 - (556 + 1139))) and v23(v101.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v137()
		local v165 = 15 - (6 + 9);
		while true do
			if (((118 + 526) <= (361 + 343)) and (v165 == (169 - (28 + 141)))) then
				if (((372 + 586) > (1168 - 221)) and v101.AstralShift:IsReady() and v69 and (v14:HealthPercentage() <= v77)) then
					if (((3182 + 1310) >= (3971 - (486 + 831))) and v23(v101.AstralShift)) then
						return "astral_shift defensive 1";
					end
				end
				if (((8956 - 5514) >= (5291 - 3788)) and v101.AncestralGuidance:IsReady() and v70 and v117.AreUnitsBelowHealthPercentage(v78, v79)) then
					if (v23(v101.AncestralGuidance) or ((600 + 2570) <= (4629 - 3165))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v165 = 1264 - (668 + 595);
			end
			if ((v165 == (1 + 0)) or ((968 + 3829) == (11966 - 7578))) then
				if (((841 - (23 + 267)) <= (2625 - (1129 + 815))) and v101.HealingStreamTotem:IsReady() and v71 and v117.AreUnitsBelowHealthPercentage(v80, v81)) then
					if (((3664 - (371 + 16)) > (2157 - (1326 + 424))) and v23(v101.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if (((8891 - 4196) >= (5170 - 3755)) and v101.HealingSurge:IsReady() and v72 and (v14:HealthPercentage() <= v82) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (123 - (88 + 30)))) then
					if (v23(v101.HealingSurge) or ((3983 - (720 + 51)) <= (2099 - 1155))) then
						return "healing_surge defensive 4";
					end
				end
				v165 = 1778 - (421 + 1355);
			end
			if ((v165 == (2 - 0)) or ((1521 + 1575) <= (2881 - (286 + 797)))) then
				if (((12929 - 9392) == (5858 - 2321)) and v102.Healthstone:IsReady() and v73 and (v14:HealthPercentage() <= v83)) then
					if (((4276 - (397 + 42)) >= (491 + 1079)) and v23(v103.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if ((v74 and (v14:HealthPercentage() <= v84)) or ((3750 - (24 + 776)) == (5871 - 2059))) then
					local v249 = 785 - (222 + 563);
					while true do
						if (((10406 - 5683) >= (1669 + 649)) and (v249 == (190 - (23 + 167)))) then
							if ((v95 == "Refreshing Healing Potion") or ((3825 - (690 + 1108)) > (1029 + 1823))) then
								if (v102.RefreshingHealingPotion:IsReady() or ((938 + 198) > (5165 - (40 + 808)))) then
									if (((782 + 3966) == (18156 - 13408)) and v23(v103.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if (((3571 + 165) <= (2508 + 2232)) and (v95 == "Dreamwalker's Healing Potion")) then
								if (v102.DreamwalkersHealingPotion:IsReady() or ((1859 + 1531) <= (3631 - (47 + 524)))) then
									if (v23(v103.RefreshingHealingPotion) or ((649 + 350) > (7361 - 4668))) then
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
	local function v138()
		v32 = v117.HandleTopTrinket(v104, v35, 59 - 19, nil);
		if (((1055 - 592) < (2327 - (1165 + 561))) and v32) then
			return v32;
		end
		v32 = v117.HandleBottomTrinket(v104, v35, 2 + 38, nil);
		if (v32 or ((6760 - 4577) < (263 + 424))) then
			return v32;
		end
	end
	local function v139()
		local v166 = 479 - (341 + 138);
		while true do
			if (((1228 + 3321) == (9387 - 4838)) and (v166 == (326 - (89 + 237)))) then
				if (((15029 - 10357) == (9835 - 5163)) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (971 - (581 + 300))))) then
					if (v23(v101.WindfuryTotem) or ((4888 - (855 + 365)) < (938 - 543))) then
						return "windfury_totem precombat 4";
					end
				end
				if ((v101.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60)) or ((1361 + 2805) == (1690 - (1030 + 205)))) then
					if (v23(v101.FeralSpirit) or ((4177 + 272) == (2478 + 185))) then
						return "feral_spirit precombat 6";
					end
				end
				v166 = 287 - (156 + 130);
			end
			if ((v166 == (2 - 1)) or ((7207 - 2930) < (6121 - 3132))) then
				if ((v101.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61)) or ((230 + 640) >= (2420 + 1729))) then
					if (((2281 - (10 + 59)) < (901 + 2282)) and v23(v101.DoomWinds, not v15:IsSpellInRange(v101.DoomWinds))) then
						return "doom_winds precombat 8";
					end
				end
				if (((22880 - 18234) > (4155 - (671 + 492))) and v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62)) then
					if (((1142 + 292) < (4321 - (369 + 846))) and v23(v101.Sundering, not v15:IsInRange(2 + 3))) then
						return "sundering precombat 10";
					end
				end
				v166 = 2 + 0;
			end
			if (((2731 - (1036 + 909)) < (2404 + 619)) and (v166 == (2 - 0))) then
				if ((v101.Stormstrike:IsReady() and v49) or ((2645 - (11 + 192)) < (38 + 36))) then
					if (((4710 - (135 + 40)) == (10987 - 6452)) and v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
		end
	end
	local function v140()
		if ((v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116) and v15:DebuffDown(v101.FlameShockDebuff) and v101.LashingFlames:IsAvailable()) or ((1814 + 1195) <= (4637 - 2532))) then
			if (((2743 - 913) < (3845 - (50 + 126))) and v23(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave))) then
				return "primordial_wave single 1";
			end
		end
		if ((v101.FlameShock:IsReady() and v42 and v15:DebuffDown(v101.FlameShockDebuff) and v101.LashingFlames:IsAvailable()) or ((3981 - 2551) >= (800 + 2812))) then
			if (((4096 - (1233 + 180)) >= (3429 - (522 + 447))) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock single 2";
			end
		end
		if ((v101.ElementalBlast:IsReady() and v40 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1426 - (107 + 1314))) and v101.ElementalSpirits:IsAvailable() and (v119.FeralSpiritCount >= (2 + 2))) or ((5496 - 3692) >= (1391 + 1884))) then
			if (v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((2813 - 1396) > (14358 - 10729))) then
				return "elemental_blast single 3";
			end
		end
		if (((6705 - (716 + 1194)) > (7 + 395)) and v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116) and (v14:HasTier(4 + 26, 505 - (74 + 429)))) then
			if (((9284 - 4471) > (1767 + 1798)) and v23(v101.Sundering, not v15:IsInRange(18 - 10))) then
				return "sundering single 4";
			end
		end
		if (((2768 + 1144) == (12060 - 8148)) and v101.LightningBolt:IsReady() and v47 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (12 - 7)) and v14:BuffDown(v101.CracklingThunderBuff) and v14:BuffUp(v101.AscendanceBuff) and (v114 == "Chain Lightning") and (v14:BuffRemains(v101.AscendanceBuff) > (v101.ChainLightning:CooldownRemains() + v14:GCD()))) then
			if (((3254 - (279 + 154)) <= (5602 - (454 + 324))) and v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single 5";
			end
		end
		if (((1368 + 370) <= (2212 - (12 + 5))) and v101.Stormstrike:IsReady() and v49 and (v14:BuffUp(v101.DoomWindsBuff) or v101.DeeplyRootedElements:IsAvailable() or (v101.Stormblast:IsAvailable() and v14:BuffUp(v101.StormbringerBuff)))) then
			if (((23 + 18) <= (7689 - 4671)) and v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
				return "stormstrike single 6";
			end
		end
		if (((793 + 1352) <= (5197 - (277 + 816))) and v101.LavaLash:IsReady() and v46 and (v14:BuffUp(v101.HotHandBuff))) then
			if (((11490 - 8801) < (6028 - (1058 + 125))) and v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
				return "lava_lash single 7";
			end
		end
		if ((v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true))) or ((436 + 1886) > (3597 - (815 + 160)))) then
			if (v23(v101.WindfuryTotem) or ((19453 - 14919) == (4942 - 2860))) then
				return "windfury_totem single 8";
			end
		end
		if ((v101.ElementalBlast:IsReady() and v40 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 3)) and (v101.ElementalBlast:Charges() == v113)) or ((4592 - 3021) > (3765 - (41 + 1857)))) then
			if (v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((4547 - (1222 + 671)) >= (7743 - 4747))) then
				return "elemental_blast single 9";
			end
		end
		if (((5717 - 1739) > (3286 - (229 + 953))) and v101.LightningBolt:IsReady() and v47 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1782 - (1111 + 663))) and v14:BuffUp(v101.PrimordialWaveBuff) and (v14:BuffDown(v101.SplinteredElementsBuff) or (v116 <= (1591 - (874 + 705))))) then
			if (((420 + 2575) > (1052 + 489)) and v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single 10";
			end
		end
		if (((6753 - 3504) > (27 + 926)) and v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (687 - (642 + 37))) and v14:BuffUp(v101.CracklingThunderBuff) and v101.ElementalSpirits:IsAvailable()) then
			if (v23(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning)) or ((747 + 2526) > (732 + 3841))) then
				return "chain_lightning single 11";
			end
		end
		if ((v101.ElementalBlast:IsReady() and v40 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (19 - 11)) and ((v119.FeralSpiritCount >= (456 - (233 + 221))) or not v101.ElementalSpirits:IsAvailable())) or ((7286 - 4135) < (1131 + 153))) then
			if (v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((3391 - (718 + 823)) == (963 + 566))) then
				return "elemental_blast single 12";
			end
		end
		if (((1626 - (266 + 539)) < (6010 - 3887)) and v101.LavaBurst:IsReady() and v45 and not v101.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1230 - (636 + 589)))) then
			if (((2140 - 1238) < (4795 - 2470)) and v23(v101.LavaBurst, not v15:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single 13";
			end
		end
		if (((680 + 178) <= (1077 + 1885)) and v101.LightningBolt:IsReady() and v47 and ((v14:BuffStack(v101.MaelstromWeaponBuff) >= (1023 - (657 + 358))) or (v101.StaticAccumulation:IsAvailable() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (13 - 8)))) and v14:BuffDown(v101.PrimordialWaveBuff)) then
			if (v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt)) or ((8989 - 5043) < (2475 - (1151 + 36)))) then
				return "lightning_bolt single 14";
			end
		end
		if ((v101.CrashLightning:IsReady() and v39 and v101.AlphaWolf:IsAvailable() and v14:BuffUp(v101.FeralSpiritBuff) and (v126() == (0 + 0))) or ((853 + 2389) == (1693 - 1126))) then
			if (v23(v101.CrashLightning, not v15:IsInMeleeRange(1840 - (1552 + 280))) or ((1681 - (64 + 770)) >= (858 + 405))) then
				return "crash_lightning single 15";
			end
		end
		if ((v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116)) or ((5114 - 2861) == (329 + 1522))) then
			if (v23(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave)) or ((3330 - (157 + 1086)) > (4747 - 2375))) then
				return "primordial_wave single 16";
			end
		end
		if ((v101.FlameShock:IsReady() and v42 and (v15:DebuffDown(v101.FlameShockDebuff))) or ((19467 - 15022) < (6363 - 2214))) then
			if (v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock)) or ((2480 - 662) == (904 - (599 + 220)))) then
				return "flame_shock single 17";
			end
		end
		if (((1254 - 624) < (4058 - (1813 + 118))) and v101.IceStrike:IsReady() and v44 and v101.ElementalAssault:IsAvailable() and v101.SwirlingMaelstrom:IsAvailable()) then
			if (v23(v101.IceStrike, not v15:IsInMeleeRange(4 + 1)) or ((3155 - (841 + 376)) == (3522 - 1008))) then
				return "ice_strike single 18";
			end
		end
		if (((989 + 3266) >= (150 - 95)) and v101.LavaLash:IsReady() and v46 and (v101.LashingFlames:IsAvailable())) then
			if (((3858 - (464 + 395)) > (2966 - 1810)) and v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
				return "lava_lash single 19";
			end
		end
		if (((1129 + 1221) > (1992 - (467 + 370))) and v101.IceStrike:IsReady() and v44 and (v14:BuffDown(v101.IceStrikeBuff))) then
			if (((8325 - 4296) <= (3563 + 1290)) and v23(v101.IceStrike, not v15:IsInMeleeRange(17 - 12))) then
				return "ice_strike single 20";
			end
		end
		if ((v101.FrostShock:IsReady() and v43 and (v14:BuffUp(v101.HailstormBuff))) or ((81 + 435) > (7988 - 4554))) then
			if (((4566 - (150 + 370)) >= (4315 - (74 + 1208))) and v23(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single 21";
			end
		end
		if ((v101.LavaLash:IsReady() and v46) or ((6687 - 3968) <= (6862 - 5415))) then
			if (v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((2942 + 1192) < (4316 - (14 + 376)))) then
				return "lava_lash single 22";
			end
		end
		if ((v101.IceStrike:IsReady() and v44) or ((283 - 119) >= (1803 + 982))) then
			if (v23(v101.IceStrike, not v15:IsInMeleeRange(5 + 0)) or ((501 + 24) == (6179 - 4070))) then
				return "ice_strike single 23";
			end
		end
		if (((25 + 8) == (111 - (23 + 55))) and v101.Windstrike:IsCastable() and v52) then
			if (((7237 - 4183) <= (2680 + 1335)) and v23(v101.Windstrike, not v15:IsSpellInRange(v101.Windstrike))) then
				return "windstrike single 24";
			end
		end
		if (((1681 + 190) < (5243 - 1861)) and v101.Stormstrike:IsReady() and v49) then
			if (((407 + 886) <= (3067 - (652 + 249))) and v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
				return "stormstrike single 25";
			end
		end
		if ((v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116)) or ((6901 - 4322) < (1991 - (708 + 1160)))) then
			if (v23(v101.Sundering, not v15:IsInRange(21 - 13)) or ((1542 - 696) >= (2395 - (10 + 17)))) then
				return "sundering single 26";
			end
		end
		if ((v101.BagofTricks:IsReady() and v58 and ((v65 and v35) or not v65)) or ((902 + 3110) <= (5090 - (1400 + 332)))) then
			if (((2865 - 1371) <= (4913 - (242 + 1666))) and v23(v101.BagofTricks)) then
				return "bag_of_tricks single 27";
			end
		end
		if ((v101.FireNova:IsReady() and v41 and v101.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v101.FlameShockDebuff) and (v14:BuffStack(v101.MaelstromWeaponBuff) < (3 + 2 + ((2 + 3) * v24(v101.OverflowingMaelstrom:IsAvailable()))))) or ((2652 + 459) == (3074 - (850 + 90)))) then
			if (((4124 - 1769) == (3745 - (360 + 1030))) and v23(v101.FireNova)) then
				return "fire_nova single 28";
			end
		end
		if ((v101.LightningBolt:IsReady() and v47 and v101.Hailstorm:IsAvailable() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (5 + 0)) and v14:BuffDown(v101.PrimordialWaveBuff)) or ((1659 - 1071) <= (593 - 161))) then
			if (((6458 - (909 + 752)) >= (5118 - (109 + 1114))) and v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single 29";
			end
		end
		if (((6548 - 2971) == (1393 + 2184)) and v101.FrostShock:IsReady() and v43) then
			if (((4036 - (6 + 236)) > (2327 + 1366)) and v23(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single 30";
			end
		end
		if ((v101.CrashLightning:IsReady() and v39) or ((1027 + 248) == (9669 - 5569))) then
			if (v23(v101.CrashLightning, not v15:IsInMeleeRange(13 - 5)) or ((2724 - (1076 + 57)) >= (589 + 2991))) then
				return "crash_lightning single 31";
			end
		end
		if (((1672 - (579 + 110)) <= (143 + 1665)) and v101.FireNova:IsReady() and v41 and (v15:DebuffUp(v101.FlameShockDebuff))) then
			if (v23(v101.FireNova) or ((1901 + 249) <= (636 + 561))) then
				return "fire_nova single 32";
			end
		end
		if (((4176 - (174 + 233)) >= (3276 - 2103)) and v101.FlameShock:IsReady() and v42) then
			if (((2606 - 1121) == (661 + 824)) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock single 34";
			end
		end
		if ((v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1179 - (663 + 511))) and v14:BuffUp(v101.CracklingThunderBuff) and v101.ElementalSpirits:IsAvailable()) or ((2958 + 357) <= (604 + 2178))) then
			if (v23(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning)) or ((2700 - 1824) >= (1795 + 1169))) then
				return "chain_lightning single 35";
			end
		end
		if ((v101.LightningBolt:IsReady() and v47 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (11 - 6)) and v14:BuffDown(v101.PrimordialWaveBuff)) or ((5402 - 3170) > (1192 + 1305))) then
			if (v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt)) or ((4106 - 1996) <= (237 + 95))) then
				return "lightning_bolt single 36";
			end
		end
		if (((337 + 3349) > (3894 - (478 + 244))) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (607 - (440 + 77))))) then
			if (v23(v101.WindfuryTotem) or ((2035 + 2439) < (3001 - 2181))) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v141()
		local v167 = 1556 - (655 + 901);
		while true do
			if (((794 + 3485) >= (2207 + 675)) and (v167 == (2 + 0))) then
				if ((v101.LavaLash:IsReady() and v46 and (v101.LashingFlames:IsAvailable())) or ((8173 - 6144) >= (4966 - (695 + 750)))) then
					local v250 = 0 - 0;
					while true do
						if ((v250 == (0 - 0)) or ((8192 - 6155) >= (4993 - (285 + 66)))) then
							if (((4009 - 2289) < (5768 - (682 + 628))) and v117.CastCycle(v101.LavaLash, v110, v128, not v15:IsSpellInRange(v101.LavaLash))) then
								return "lava_lash aoe 11";
							end
							if (v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((71 + 365) > (3320 - (176 + 123)))) then
								return "lava_lash aoe no_cycle 11";
							end
							break;
						end
					end
				end
				if (((299 + 414) <= (615 + 232)) and v101.LavaLash:IsReady() and v46 and ((v101.MoltenAssault:IsAvailable() and v15:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (275 - (239 + 30)))) or (v101.AshenCatalyst:IsAvailable() and (v14:BuffStack(v101.AshenCatalystBuff) == (2 + 3))))) then
					if (((2071 + 83) <= (7134 - 3103)) and v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
						return "lava_lash aoe 12";
					end
				end
				if (((14398 - 9783) == (4930 - (306 + 9))) and v101.IceStrike:IsReady() and v44 and (v101.Hailstorm:IsAvailable())) then
					if (v23(v101.IceStrike, not v15:IsInMeleeRange(17 - 12)) or ((660 + 3130) == (307 + 193))) then
						return "ice_strike aoe 13";
					end
				end
				if (((43 + 46) < (631 - 410)) and v101.FrostShock:IsReady() and v43 and v101.Hailstorm:IsAvailable() and v14:BuffUp(v101.HailstormBuff)) then
					if (((3429 - (1140 + 235)) >= (905 + 516)) and v23(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock aoe 14";
					end
				end
				if (((635 + 57) < (785 + 2273)) and v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116)) then
					if (v23(v101.Sundering, not v15:IsInRange(60 - (33 + 19))) or ((1175 + 2079) == (4960 - 3305))) then
						return "sundering aoe 15";
					end
				end
				v167 = 2 + 1;
			end
			if ((v167 == (9 - 4)) or ((1216 + 80) == (5599 - (586 + 103)))) then
				if (((307 + 3061) == (10368 - 7000)) and v101.FireNova:IsReady() and v41 and (v101.FlameShockDebuff:AuraActiveCount() >= (1490 - (1309 + 179)))) then
					if (((4771 - 2128) < (1661 + 2154)) and v23(v101.FireNova)) then
						return "fire_nova aoe 26";
					end
				end
				if (((5137 - 3224) > (373 + 120)) and v101.ElementalBlast:IsReady() and v40 and (not v101.ElementalSpirits:IsAvailable() or (v101.ElementalSpirits:IsAvailable() and ((v101.ElementalBlast:Charges() == v113) or (v119.FeralSpiritCount >= (3 - 1))))) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (9 - 4)) and (not v101.CrashingStorms:IsAvailable() or (v111 <= (612 - (295 + 314))))) then
					if (((11679 - 6924) > (5390 - (1300 + 662))) and v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 27";
					end
				end
				if (((4336 - 2955) <= (4124 - (1178 + 577))) and v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (3 + 2))) then
					if (v23(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning)) or ((14316 - 9473) == (5489 - (851 + 554)))) then
						return "chain_lightning aoe 28";
					end
				end
				if (((4129 + 540) > (1006 - 643)) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (195 - 105)))) then
					if (v23(v101.WindfuryTotem) or ((2179 - (115 + 187)) >= (2404 + 734))) then
						return "windfury_totem aoe 29";
					end
				end
				if (((4490 + 252) >= (14288 - 10662)) and v101.FlameShock:IsReady() and v42 and (v15:DebuffDown(v101.FlameShockDebuff))) then
					if (v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock)) or ((5701 - (160 + 1001)) == (802 + 114))) then
						return "flame_shock aoe 30";
					end
				end
				v167 = 5 + 1;
			end
			if (((0 - 0) == v167) or ((1514 - (237 + 121)) > (5242 - (525 + 372)))) then
				if (((4241 - 2004) < (13960 - 9711)) and v101.CrashLightning:IsReady() and v39 and v101.CrashingStorms:IsAvailable() and ((v101.UnrulyWinds:IsAvailable() and (v111 >= (152 - (96 + 46)))) or (v111 >= (792 - (643 + 134))))) then
					if (v23(v101.CrashLightning, not v15:IsInMeleeRange(3 + 5)) or ((6432 - 3749) < (85 - 62))) then
						return "crash_lightning aoe 1";
					end
				end
				if (((669 + 28) <= (1620 - 794)) and v101.LightningBolt:IsReady() and v47 and ((v101.FlameShockDebuff:AuraActiveCount() >= v111) or (v14:BuffRemains(v101.PrimordialWaveBuff) < (v14:GCD() * (5 - 2))) or (v101.FlameShockDebuff:AuraActiveCount() >= (725 - (316 + 403)))) and v14:BuffUp(v101.PrimordialWaveBuff) and (v14:BuffStack(v101.MaelstromWeaponBuff) == (4 + 1 + ((13 - 8) * v24(v101.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v101.SplinteredElementsBuff) or (v116 <= (5 + 7)) or (v99 <= v14:GCD()))) then
					if (((2782 - 1677) <= (834 + 342)) and v23(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
						return "lightning_bolt aoe 2";
					end
				end
				if (((1089 + 2290) <= (13208 - 9396)) and v101.LavaLash:IsReady() and v46 and v101.MoltenAssault:IsAvailable() and (v101.PrimordialWave:IsAvailable() or v101.FireNova:IsAvailable()) and v15:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (28 - 22))) then
					if (v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((1636 - 848) >= (93 + 1523))) then
						return "lava_lash aoe 3";
					end
				end
				if (((3649 - 1795) <= (166 + 3213)) and v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116) and (v14:BuffDown(v101.PrimordialWaveBuff))) then
					local v251 = 0 - 0;
					while true do
						if (((4566 - (12 + 5)) == (17668 - 13119)) and (v251 == (0 - 0))) then
							if (v117.CastCycle(v101.PrimordialWave, v110, v127, not v15:IsSpellInRange(v101.PrimordialWave)) or ((6423 - 3401) >= (7498 - 4474))) then
								return "primordial_wave aoe 4";
							end
							if (((979 + 3841) > (4171 - (1656 + 317))) and v23(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave))) then
								return "primordial_wave aoe no_cycle 4";
							end
							break;
						end
					end
				end
				if ((v101.FlameShock:IsReady() and v42 and (v101.PrimordialWave:IsAvailable() or v101.FireNova:IsAvailable()) and v15:DebuffDown(v101.FlameShockDebuff)) or ((946 + 115) >= (3920 + 971))) then
					if (((3626 - 2262) <= (22014 - 17541)) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock aoe 5";
					end
				end
				v167 = 355 - (5 + 349);
			end
			if ((v167 == (14 - 11)) or ((4866 - (266 + 1005)) <= (2 + 1))) then
				if ((v101.FlameShock:IsReady() and v42 and v101.MoltenAssault:IsAvailable() and v15:DebuffDown(v101.FlameShockDebuff)) or ((15941 - 11269) == (5070 - 1218))) then
					if (((3255 - (561 + 1135)) == (2030 - 471)) and v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
						return "flame_shock aoe 16";
					end
				end
				if ((v101.FlameShock:IsReady() and v42 and v15:DebuffRefreshable(v101.FlameShockDebuff) and (v101.FireNova:IsAvailable() or v101.PrimordialWave:IsAvailable()) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (19 - 13))) or ((2818 - (507 + 559)) <= (1977 - 1189))) then
					local v252 = 0 - 0;
					while true do
						if ((v252 == (388 - (212 + 176))) or ((4812 - (250 + 655)) == (482 - 305))) then
							if (((6063 - 2593) > (868 - 313)) and v117.CastCycle(v101.FlameShock, v110, v127, not v15:IsSpellInRange(v101.FlameShock))) then
								return "flame_shock aoe 17";
							end
							if (v23(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock)) or ((2928 - (1869 + 87)) == (2237 - 1592))) then
								return "flame_shock aoe no_cycle 17";
							end
							break;
						end
					end
				end
				if (((5083 - (484 + 1417)) >= (4533 - 2418)) and v101.FireNova:IsReady() and v41 and (v101.FlameShockDebuff:AuraActiveCount() >= (4 - 1))) then
					if (((4666 - (48 + 725)) < (7234 - 2805)) and v23(v101.FireNova)) then
						return "fire_nova aoe 18";
					end
				end
				if ((v101.Stormstrike:IsReady() and v49 and v14:BuffUp(v101.CrashLightningBuff) and (v101.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v101.ConvergingStormsBuff) == (15 - 9)))) or ((1667 + 1200) < (5091 - 3186))) then
					if (v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike)) or ((503 + 1293) >= (1181 + 2870))) then
						return "stormstrike aoe 19";
					end
				end
				if (((2472 - (152 + 701)) <= (5067 - (430 + 881))) and v101.CrashLightning:IsReady() and v39 and v101.CrashingStorms:IsAvailable() and v14:BuffUp(v101.CLCrashLightningBuff) and (v111 >= (2 + 2))) then
					if (((1499 - (557 + 338)) == (179 + 425)) and v23(v101.CrashLightning, not v15:IsInMeleeRange(22 - 14))) then
						return "crash_lightning aoe 20";
					end
				end
				v167 = 13 - 9;
			end
			if ((v167 == (15 - 9)) or ((9663 - 5179) == (1701 - (499 + 302)))) then
				if ((v101.FrostShock:IsReady() and v43 and not v101.Hailstorm:IsAvailable()) or ((5325 - (39 + 827)) <= (3071 - 1958))) then
					if (((8111 - 4479) > (13496 - 10098)) and v23(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
						return "frost_shock aoe 31";
					end
				end
				break;
			end
			if (((6266 - 2184) <= (421 + 4496)) and (v167 == (2 - 1))) then
				if (((773 + 4059) >= (2192 - 806)) and v101.ElementalBlast:IsReady() and v40 and (not v101.ElementalSpirits:IsAvailable() or (v101.ElementalSpirits:IsAvailable() and ((v101.ElementalBlast:Charges() == v113) or (v119.FeralSpiritCount >= (106 - (103 + 1)))))) and (v14:BuffStack(v101.MaelstromWeaponBuff) == ((559 - (475 + 79)) + ((10 - 5) * v24(v101.OverflowingMaelstrom:IsAvailable())))) and (not v101.CrashingStorms:IsAvailable() or (v111 <= (9 - 6)))) then
					if (((18 + 119) == (121 + 16)) and v23(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast))) then
						return "elemental_blast aoe 6";
					end
				end
				if ((v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) == ((1508 - (1395 + 108)) + ((14 - 9) * v24(v101.OverflowingMaelstrom:IsAvailable()))))) or ((2774 - (7 + 1197)) >= (1889 + 2443))) then
					if (v23(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning)) or ((1419 + 2645) <= (2138 - (27 + 292)))) then
						return "chain_lightning aoe 7";
					end
				end
				if ((v101.CrashLightning:IsReady() and v39 and (v14:BuffUp(v101.DoomWindsBuff) or v14:BuffDown(v101.CrashLightningBuff) or (v101.AlphaWolf:IsAvailable() and v14:BuffUp(v101.FeralSpiritBuff) and (v126() == (0 - 0))))) or ((6358 - 1372) < (6600 - 5026))) then
					if (((8727 - 4301) > (327 - 155)) and v23(v101.CrashLightning, not v15:IsInMeleeRange(147 - (43 + 96)))) then
						return "crash_lightning aoe 8";
					end
				end
				if (((2390 - 1804) > (1028 - 573)) and v101.Sundering:IsReady() and v50 and ((v62 and v36) or not v62) and (v99 < v116) and (v14:BuffUp(v101.DoomWindsBuff) or v14:HasTier(25 + 5, 1 + 1))) then
					if (((1632 - 806) == (317 + 509)) and v23(v101.Sundering, not v15:IsInRange(14 - 6))) then
						return "sundering aoe 9";
					end
				end
				if ((v101.FireNova:IsReady() and v41 and ((v101.FlameShockDebuff:AuraActiveCount() >= (2 + 4)) or ((v101.FlameShockDebuff:AuraActiveCount() >= (1 + 3)) and (v101.FlameShockDebuff:AuraActiveCount() >= v111)))) or ((5770 - (1414 + 337)) > (6381 - (1642 + 298)))) then
					if (((5257 - 3240) < (12258 - 7997)) and v23(v101.FireNova)) then
						return "fire_nova aoe 10";
					end
				end
				v167 = 5 - 3;
			end
			if (((1552 + 3164) > (63 + 17)) and ((976 - (357 + 615)) == v167)) then
				if ((v101.Windstrike:IsCastable() and v52) or ((2462 + 1045) == (8028 - 4756))) then
					if (v23(v101.Windstrike, not v15:IsSpellInRange(v101.Windstrike)) or ((751 + 125) >= (6589 - 3514))) then
						return "windstrike aoe 21";
					end
				end
				if (((3481 + 871) > (174 + 2380)) and v101.Stormstrike:IsReady() and v49) then
					if (v23(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike)) or ((2770 + 1636) < (5344 - (384 + 917)))) then
						return "stormstrike aoe 22";
					end
				end
				if ((v101.IceStrike:IsReady() and v44) or ((2586 - (128 + 569)) >= (4926 - (1407 + 136)))) then
					if (((3779 - (687 + 1200)) <= (4444 - (556 + 1154))) and v23(v101.IceStrike, not v15:IsInMeleeRange(17 - 12))) then
						return "ice_strike aoe 23";
					end
				end
				if (((2018 - (9 + 86)) < (2639 - (275 + 146))) and v101.LavaLash:IsReady() and v46) then
					if (((354 + 1819) > (443 - (29 + 35))) and v23(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
						return "lava_lash aoe 24";
					end
				end
				if ((v101.CrashLightning:IsReady() and v39) or ((11483 - 8892) == (10182 - 6773))) then
					if (((19927 - 15413) > (2166 + 1158)) and v23(v101.CrashLightning, not v15:IsInMeleeRange(1020 - (53 + 959)))) then
						return "crash_lightning aoe 25";
					end
				end
				v167 = 413 - (312 + 96);
			end
		end
	end
	local function v142()
		local v168 = 0 - 0;
		while true do
			if ((v168 == (287 - (147 + 138))) or ((1107 - (813 + 86)) >= (4363 + 465))) then
				if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((2932 - 1349) > (4059 - (18 + 474)))) then
					if (v23(v101.AncestralSpirit, nil, true) or ((443 + 870) == (2591 - 1797))) then
						return "resurrection";
					end
				end
				if (((4260 - (860 + 226)) > (3205 - (121 + 182))) and v117.TargetIsValid() and v33) then
					if (((508 + 3612) <= (5500 - (988 + 252))) and not v14:AffectingCombat()) then
						local v260 = 0 + 0;
						while true do
							if ((v260 == (0 + 0)) or ((2853 - (49 + 1921)) > (5668 - (223 + 667)))) then
								v32 = v139();
								if (v32 or ((3672 - (51 + 1)) >= (8417 - 3526))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (((9117 - 4859) > (2062 - (146 + 979))) and ((1 + 0) == v168)) then
				if (((not v106 or (v108 < (600605 - (311 + 294)))) and v53 and v101.FlamentongueWeapon:IsCastable()) or ((13578 - 8709) < (384 + 522))) then
					if (v23(v101.FlamentongueWeapon) or ((2668 - (496 + 947)) > (5586 - (1233 + 125)))) then
						return "flametongue_weapon enchant";
					end
				end
				if (((1351 + 1977) > (2008 + 230)) and v85) then
					v32 = v136();
					if (((730 + 3109) > (3050 - (963 + 682))) and v32) then
						return v32;
					end
				end
				v168 = 2 + 0;
			end
			if ((v168 == (1504 - (504 + 1000))) or ((871 + 422) <= (462 + 45))) then
				if ((v75 and v101.EarthShield:IsCastable() and v14:BuffDown(v101.EarthShieldBuff) and ((v76 == "Earth Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.LightningShield)))) or ((274 + 2622) < (1187 - 382))) then
					if (((1979 + 337) == (1347 + 969)) and v23(v101.EarthShield)) then
						return "earth_shield main 2";
					end
				elseif ((v75 and v101.LightningShield:IsCastable() and v14:BuffDown(v101.LightningShieldBuff) and ((v76 == "Lightning Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.EarthShield)))) or ((2752 - (156 + 26)) == (884 + 649))) then
					if (v23(v101.LightningShield) or ((1380 - 497) == (1624 - (149 + 15)))) then
						return "lightning_shield main 2";
					end
				end
				if (((not v105 or (v107 < (600960 - (890 + 70)))) and v53 and v101.WindfuryWeapon:IsCastable()) or ((4736 - (39 + 78)) <= (1481 - (14 + 468)))) then
					if (v23(v101.WindfuryWeapon) or ((7498 - 4088) > (11504 - 7388))) then
						return "windfury_weapon enchant";
					end
				end
				v168 = 1 + 0;
			end
		end
	end
	local function v143()
		local v169 = 0 + 0;
		while true do
			if (((1 + 1) == v169) or ((408 + 495) >= (802 + 2257))) then
				if (v16 or ((7610 - 3634) < (2824 + 33))) then
					if (((17324 - 12394) > (59 + 2248)) and v92) then
						local v261 = 51 - (12 + 39);
						while true do
							if ((v261 == (0 + 0)) or ((12523 - 8477) < (4597 - 3306))) then
								v32 = v134();
								if (v32 or ((1258 + 2983) == (1866 + 1679))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				if ((v101.GreaterPurge:IsAvailable() and v100 and v101.GreaterPurge:IsReady() and v37 and v91 and not v14:IsCasting() and not v14:IsChanneling() and v117.UnitHasMagicBuff(v15)) or ((10264 - 6216) > (2819 + 1413))) then
					if (v23(v101.GreaterPurge, not v15:IsSpellInRange(v101.GreaterPurge)) or ((8457 - 6707) >= (5183 - (1596 + 114)))) then
						return "greater_purge damage";
					end
				end
				v169 = 7 - 4;
			end
			if (((3879 - (164 + 549)) == (4604 - (1059 + 379))) and (v169 == (4 - 0))) then
				if (((914 + 849) < (628 + 3096)) and v32) then
					return v32;
				end
				if (((449 - (145 + 247)) <= (2235 + 488)) and v117.TargetIsValid()) then
					local v253 = 0 + 0;
					local v254;
					while true do
						if ((v253 == (2 - 1)) or ((398 + 1672) == (382 + 61))) then
							if ((v101.TotemicProjection:IsCastable() and (v101.WindfuryTotem:TimeSinceLastCast() < (146 - 56)) and v14:BuffDown(v101.WindfuryTotemBuff, true)) or ((3425 - (254 + 466)) == (1953 - (544 + 16)))) then
								if (v23(v103.TotemicProjectionPlayer) or ((14622 - 10021) < (689 - (294 + 334)))) then
									return "totemic_projection wind_fury main 0";
								end
							end
							if ((v101.Windstrike:IsCastable() and v52) or ((1643 - (236 + 17)) >= (2046 + 2698))) then
								if (v23(v101.Windstrike, not v15:IsSpellInRange(v101.Windstrike)) or ((1560 + 443) > (14439 - 10605))) then
									return "windstrike main 1";
								end
							end
							if ((v101.PrimordialWave:IsCastable() and v48 and ((v63 and v36) or not v63) and (v99 < v116) and (v14:HasTier(146 - 115, 2 + 0))) or ((129 + 27) > (4707 - (413 + 381)))) then
								if (((9 + 186) == (414 - 219)) and v23(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave))) then
									return "primordial_wave main 2";
								end
							end
							if (((8065 - 4960) >= (3766 - (582 + 1388))) and v101.FeralSpirit:IsCastable() and v55 and ((v60 and v35) or not v60) and (v99 < v116)) then
								if (((7460 - 3081) >= (1526 + 605)) and v23(v101.FeralSpirit)) then
									return "feral_spirit main 3";
								end
							end
							v253 = 366 - (326 + 38);
						end
						if (((11371 - 7527) >= (2916 - 873)) and (v253 == (622 - (47 + 573)))) then
							if ((v101.Ascendance:IsCastable() and v54 and ((v59 and v35) or not v59) and (v99 < v116) and v15:DebuffUp(v101.FlameShockDebuff) and (((v114 == "Lightning Bolt") and (v111 == (1 + 0))) or ((v114 == "Chain Lightning") and (v111 > (4 - 3))))) or ((5245 - 2013) <= (4395 - (1269 + 395)))) then
								if (((5397 - (76 + 416)) == (5348 - (319 + 124))) and v23(v101.Ascendance)) then
									return "ascendance main 4";
								end
							end
							if ((v101.DoomWinds:IsCastable() and v56 and ((v61 and v35) or not v61) and (v99 < v116)) or ((9454 - 5318) >= (5418 - (564 + 443)))) then
								if (v23(v101.DoomWinds, not v15:IsInMeleeRange(13 - 8)) or ((3416 - (337 + 121)) == (11769 - 7752))) then
									return "doom_winds main 5";
								end
							end
							if (((4090 - 2862) >= (2724 - (1261 + 650))) and (v111 == (1 + 0))) then
								local v266 = 0 - 0;
								while true do
									if ((v266 == (1817 - (772 + 1045))) or ((488 + 2967) > (4194 - (102 + 42)))) then
										v32 = v140();
										if (((2087 - (1524 + 320)) == (1513 - (1049 + 221))) and v32) then
											return v32;
										end
										break;
									end
								end
							end
							if ((v34 and (v111 > (157 - (18 + 138)))) or ((663 - 392) > (2674 - (67 + 1035)))) then
								local v267 = 348 - (136 + 212);
								while true do
									if (((11638 - 8899) < (2639 + 654)) and (v267 == (0 + 0))) then
										v32 = v141();
										if (v32 or ((5546 - (240 + 1364)) < (2216 - (1050 + 32)))) then
											return v32;
										end
										break;
									end
								end
							end
							v253 = 10 - 7;
						end
						if ((v253 == (0 + 0)) or ((3748 - (331 + 724)) == (402 + 4571))) then
							v254 = v117.HandleDPSPotion(v14:BuffUp(v101.FeralSpiritBuff));
							if (((2790 - (269 + 375)) == (2871 - (267 + 458))) and v254) then
								return v254;
							end
							if ((v99 < v116) or ((698 + 1546) == (6199 - 2975))) then
								if ((v57 and ((v35 and v64) or not v64)) or ((5722 - (667 + 151)) <= (3413 - (1410 + 87)))) then
									v32 = v138();
									if (((1987 - (1504 + 393)) <= (2878 - 1813)) and v32) then
										return v32;
									end
								end
							end
							if (((12458 - 7656) == (5598 - (461 + 335))) and (v99 < v116) and v58 and ((v65 and v35) or not v65)) then
								if ((v101.BloodFury:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (7 + 43)))) or ((4041 - (1730 + 31)) <= (2178 - (728 + 939)))) then
									if (v23(v101.BloodFury) or ((5935 - 4259) <= (938 - 475))) then
										return "blood_fury racial";
									end
								end
								if (((8864 - 4995) == (4937 - (138 + 930))) and v101.Berserking:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) then
									if (((1059 + 99) <= (2043 + 570)) and v23(v101.Berserking)) then
										return "berserking racial";
									end
								end
								if ((v101.Fireblood:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (43 + 7)))) or ((9652 - 7288) <= (3765 - (459 + 1307)))) then
									if (v23(v101.Fireblood) or ((6792 - (474 + 1396)) < (338 - 144))) then
										return "fireblood racial";
									end
								end
								if ((v101.AncestralCall:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (47 + 3)))) or ((7 + 2084) < (88 - 57))) then
									if (v23(v101.AncestralCall) or ((308 + 2122) >= (16263 - 11391))) then
										return "ancestral_call racial";
									end
								end
							end
							v253 = 4 - 3;
						end
						if (((594 - (562 + 29)) == v253) or ((4067 + 703) < (3154 - (374 + 1045)))) then
							if (v20.CastAnnotated(v101.Pool, false, "WAIT") or ((3514 + 925) <= (7297 - 4947))) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if ((v169 == (641 - (448 + 190))) or ((1447 + 3032) < (2016 + 2450))) then
				if (((1660 + 887) > (4709 - 3484)) and v101.Purge:IsReady() and v100 and v37 and v91 and not v14:IsCasting() and not v14:IsChanneling() and v117.UnitHasMagicBuff(v15)) then
					if (((14514 - 9843) > (4168 - (1307 + 187))) and v23(v101.Purge, not v15:IsSpellInRange(v101.Purge))) then
						return "purge damage";
					end
				end
				v32 = v135();
				v169 = 15 - 11;
			end
			if ((v169 == (0 - 0)) or ((11332 - 7636) < (4010 - (232 + 451)))) then
				v32 = v137();
				if (v32 or ((4338 + 204) == (2624 + 346))) then
					return v32;
				end
				v169 = 565 - (510 + 54);
			end
			if (((507 - 255) <= (2013 - (13 + 23))) and (v169 == (1 - 0))) then
				if (v93 or ((2062 - 626) == (6858 - 3083))) then
					if (v87 or ((2706 - (830 + 258)) < (3280 - 2350))) then
						local v262 = 0 + 0;
						while true do
							if (((4019 + 704) > (5594 - (860 + 581))) and (v262 == (0 - 0))) then
								v32 = v117.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 32 + 8);
								if (v32 or ((3895 - (237 + 4)) >= (10937 - 6283))) then
									return v32;
								end
								break;
							end
						end
					end
					if (((2405 - 1454) <= (2836 - 1340)) and v88) then
						local v263 = 0 + 0;
						while true do
							if ((v263 == (0 + 0)) or ((6554 - 4818) == (246 + 325))) then
								v32 = v117.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 17 + 13);
								if (v32 or ((2322 - (85 + 1341)) > (8136 - 3367))) then
									return v32;
								end
								break;
							end
						end
					end
					if (v89 or ((2951 - 1906) <= (1392 - (45 + 327)))) then
						local v264 = 0 - 0;
						while true do
							if ((v264 == (502 - (444 + 58))) or ((505 + 655) <= (57 + 271))) then
								v32 = v117.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 15 + 15);
								if (((11035 - 7227) > (4656 - (64 + 1668))) and v32) then
									return v32;
								end
								break;
							end
						end
					end
					if (((5864 - (1227 + 746)) < (15119 - 10200)) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (9 - 4)) and v90) then
						local v265 = 494 - (415 + 79);
						while true do
							if ((v265 == (0 + 0)) or ((2725 - (142 + 349)) <= (644 + 858))) then
								v32 = v117.HandleAfflicted(v101.HealingSurge, v103.HealingSurgeMouseover, 54 - 14, true);
								if (v32 or ((1249 + 1263) < (305 + 127))) then
									return v32;
								end
								break;
							end
						end
					end
				end
				if (v94 or ((5032 - 3184) == (2729 - (1710 + 154)))) then
					local v255 = 318 - (200 + 118);
					while true do
						if ((v255 == (0 + 0)) or ((8185 - 3503) <= (6734 - 2193))) then
							v32 = v117.HandleIncorporeal(v101.Hex, v103.HexMouseOver, 27 + 3, true);
							if (v32 or ((2994 + 32) >= (2172 + 1874))) then
								return v32;
							end
							break;
						end
					end
				end
				v169 = 1 + 1;
			end
		end
	end
	local function v144()
		local v170 = 0 - 0;
		while true do
			if (((3258 - (363 + 887)) > (1113 - 475)) and (v170 == (0 - 0))) then
				v54 = EpicSettings.Settings['useAscendance'];
				v56 = EpicSettings.Settings['useDoomWinds'];
				v55 = EpicSettings.Settings['useFeralSpirit'];
				v170 = 1 + 0;
			end
			if (((4153 - 2378) <= (2210 + 1023)) and ((1671 - (674 + 990)) == v170)) then
				v60 = EpicSettings.Settings['feralSpiritWithCD'];
				v63 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v62 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if ((v170 == (2 + 2)) or ((1860 + 2683) == (3165 - 1168))) then
				v47 = EpicSettings.Settings['useLightningBolt'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v49 = EpicSettings.Settings['useStormStrike'];
				v170 = 1060 - (507 + 548);
			end
			if ((v170 == (839 - (289 + 548))) or ((4920 - (821 + 997)) < (983 - (195 + 60)))) then
				v41 = EpicSettings.Settings['useFireNova'];
				v42 = EpicSettings.Settings['useFlameShock'];
				v43 = EpicSettings.Settings['useFrostShock'];
				v170 = 1 + 2;
			end
			if (((1846 - (251 + 1250)) == (1010 - 665)) and (v170 == (1 + 0))) then
				v38 = EpicSettings.Settings['useChainlightning'];
				v39 = EpicSettings.Settings['useCrashLightning'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v170 = 1034 - (809 + 223);
			end
			if ((v170 == (3 - 0)) or ((8489 - 5662) < (1249 - 871))) then
				v44 = EpicSettings.Settings['useIceStrike'];
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLavaLash'];
				v170 = 3 + 1;
			end
			if (((4 + 2) == v170) or ((4093 - (14 + 603)) < (2726 - (118 + 11)))) then
				v53 = EpicSettings.Settings['useWeaponEnchant'];
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v61 = EpicSettings.Settings['doomWindsWithCD'];
				v170 = 2 + 5;
			end
			if (((2565 + 514) < (13971 - 9177)) and ((954 - (551 + 398)) == v170)) then
				v50 = EpicSettings.Settings['useSundering'];
				v52 = EpicSettings.Settings['useWindstrike'];
				v51 = EpicSettings.Settings['useWindfuryTotem'];
				v170 = 4 + 2;
			end
		end
	end
	local function v145()
		local v171 = 0 + 0;
		while true do
			if (((3945 + 909) > (16601 - 12137)) and ((11 - 6) == v171)) then
				v85 = EpicSettings.Settings['healOOC'];
				v86 = EpicSettings.Settings['healOOCHP'] or (0 + 0);
				v100 = EpicSettings.Settings['usePurgeTarget'];
				v171 = 23 - 17;
			end
			if ((v171 == (1 + 0)) or ((5001 - (40 + 49)) == (14310 - 10552))) then
				v70 = EpicSettings.Settings['useAncestralGuidance'];
				v69 = EpicSettings.Settings['useAstralShift'];
				v72 = EpicSettings.Settings['useMaelstromHealingSurge'];
				v171 = 492 - (99 + 391);
			end
			if (((105 + 21) <= (15306 - 11824)) and (v171 == (4 - 2))) then
				v71 = EpicSettings.Settings['useHealingStreamTotem'];
				v78 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
				v79 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 - 0);
				v171 = 1607 - (1032 + 572);
			end
			if ((v171 == (424 - (203 + 214))) or ((4191 - (568 + 1249)) == (3422 + 952))) then
				v90 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
				break;
			end
			if (((3782 - 2207) == (6083 - 4508)) and ((1312 - (913 + 393)) == v171)) then
				v87 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
				v88 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
				v89 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
				v171 = 19 - 12;
			end
			if ((v171 == (3 - 0)) or ((2644 - (269 + 141)) == (3236 - 1781))) then
				v77 = EpicSettings.Settings['astralShiftHP'] or (1981 - (362 + 1619));
				v80 = EpicSettings.Settings['healingStreamTotemHP'] or (1625 - (950 + 675));
				v81 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 + 0);
				v171 = 1183 - (216 + 963);
			end
			if ((v171 == (1287 - (485 + 802))) or ((1626 - (432 + 127)) > (2852 - (1065 + 8)))) then
				v66 = EpicSettings.Settings['useWindShear'];
				v67 = EpicSettings.Settings['useCapacitorTotem'];
				v68 = EpicSettings.Settings['useThunderstorm'];
				v171 = 1 + 0;
			end
			if (((3762 - (635 + 966)) >= (672 + 262)) and (v171 == (46 - (5 + 37)))) then
				v82 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 - 0);
				v75 = EpicSettings.Settings['autoShield'];
				v76 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
				v171 = 3 + 2;
			end
		end
	end
	local function v146()
		local v172 = 0 - 0;
		while true do
			if (((755 + 857) == (3349 - 1737)) and ((7 - 5) == v172)) then
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v64 = EpicSettings.Settings['trinketsWithCD'];
				v172 = 5 - 2;
			end
			if (((10404 - 6052) >= (2037 + 796)) and (v172 == (533 - (318 + 211)))) then
				v83 = EpicSettings.Settings['healthstoneHP'] or (0 - 0);
				v84 = EpicSettings.Settings['healingPotionHP'] or (1587 - (963 + 624));
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v172 = 3 + 2;
			end
			if ((v172 == (849 - (518 + 328))) or ((7510 - 4288) < (4911 - 1838))) then
				v65 = EpicSettings.Settings['racialsWithCD'];
				v73 = EpicSettings.Settings['useHealthstone'];
				v74 = EpicSettings.Settings['useHealingPotion'];
				v172 = 321 - (301 + 16);
			end
			if (((2180 - 1436) <= (8262 - 5320)) and (v172 == (2 - 1))) then
				v98 = EpicSettings.Settings['InterruptThreshold'];
				v92 = EpicSettings.Settings['DispelDebuffs'];
				v91 = EpicSettings.Settings['DispelBuffs'];
				v172 = 2 + 0;
			end
			if ((v172 == (0 + 0)) or ((3912 - 2079) <= (796 + 526))) then
				v99 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v96 = EpicSettings.Settings['InterruptWithStun'];
				v97 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v172 = 3 - 2;
			end
			if ((v172 == (2 + 3)) or ((4486 - (829 + 190)) <= (3764 - 2709))) then
				v93 = EpicSettings.Settings['handleAfflicted'];
				v94 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
		end
	end
	local function v147()
		v145();
		v144();
		v146();
		v33 = EpicSettings.Toggles['ooc'];
		v34 = EpicSettings.Toggles['aoe'];
		v35 = EpicSettings.Toggles['cds'];
		v37 = EpicSettings.Toggles['dispel'];
		v36 = EpicSettings.Toggles['minicds'];
		if (((4480 - 939) == (4894 - 1353)) and v14:IsDeadOrGhost()) then
			return v32;
		end
		v105, v107, _, _, v106, v108 = v26();
		v109 = v14:GetEnemiesInRange(99 - 59);
		v110 = v14:GetEnemiesInMeleeRange(3 + 7);
		if (v34 or ((1162 + 2395) >= (12150 - 8147))) then
			local v187 = 0 + 0;
			while true do
				if ((v187 == (613 - (520 + 93))) or ((933 - (259 + 17)) >= (97 + 1571))) then
					v112 = #v109;
					v111 = #v110;
					break;
				end
			end
		else
			local v188 = 0 + 0;
			while true do
				if ((v188 == (0 - 0)) or ((1618 - (396 + 195)) > (11193 - 7335))) then
					v112 = 1762 - (440 + 1321);
					v111 = 1830 - (1059 + 770);
					break;
				end
			end
		end
		if (v14:AffectingCombat() or v92 or ((16896 - 13242) < (995 - (424 + 121)))) then
			local v189 = 0 + 0;
			local v190;
			while true do
				if (((3238 - (641 + 706)) < (1764 + 2689)) and ((441 - (249 + 191)) == v189)) then
					if (v32 or ((13678 - 10538) < (951 + 1178))) then
						return v32;
					end
					break;
				end
				if (((0 - 0) == v189) or ((2982 - (183 + 244)) < (61 + 1179))) then
					v190 = v92 and v101.CleanseSpirit:IsReady() and v37;
					v32 = v117.FocusUnit(v190, v103, 750 - (434 + 296), nil, 79 - 54);
					v189 = 513 - (169 + 343);
				end
			end
		end
		if (v117.TargetIsValid() or v14:AffectingCombat() or ((4144 + 583) <= (8308 - 3586))) then
			local v191 = 0 - 0;
			while true do
				if (((607 + 133) < (14001 - 9064)) and (v191 == (1124 - (651 + 472)))) then
					if (((2765 + 893) >= (121 + 159)) and (v116 == (13560 - 2449))) then
						v116 = v10.FightRemains(v110, false);
					end
					break;
				end
				if ((v191 == (483 - (397 + 86))) or ((1761 - (423 + 453)) >= (105 + 926))) then
					v115 = v10.BossFightRemains(nil, true);
					v116 = v115;
					v191 = 1 + 0;
				end
			end
		end
		if (((3103 + 451) >= (419 + 106)) and v14:AffectingCombat()) then
			if (((2157 + 257) <= (4162 - (50 + 1140))) and v14:PrevGCD(1 + 0, v101.ChainLightning)) then
				v114 = "Chain Lightning";
			elseif (((2084 + 1445) <= (220 + 3318)) and v14:PrevGCD(1 - 0, v101.LightningBolt)) then
				v114 = "Lightning Bolt";
			end
		end
		if ((not v14:IsChanneling() and not v14:IsChanneling()) or ((2071 + 790) < (1054 - (157 + 439)))) then
			if (((2985 - 1268) <= (15035 - 10510)) and v16) then
				if (v92 or ((9400 - 6222) <= (2442 - (782 + 136)))) then
					v32 = v134();
					if (((5109 - (112 + 743)) > (1541 - (1026 + 145))) and v32) then
						return v32;
					end
				end
			end
			if (v93 or ((281 + 1354) == (2495 - (493 + 225)))) then
				if (v87 or ((12269 - 8931) >= (2429 + 1564))) then
					local v258 = 0 - 0;
					while true do
						if (((22 + 1132) <= (4215 - 2740)) and (v258 == (0 + 0))) then
							v32 = v117.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 66 - 26);
							if (v32 or ((4205 - (210 + 1385)) < (2919 - (1201 + 488)))) then
								return v32;
							end
							break;
						end
					end
				end
				if (v88 or ((898 + 550) == (5483 - 2400))) then
					local v259 = 0 - 0;
					while true do
						if (((3724 - (352 + 233)) > (2213 - 1297)) and (v259 == (0 + 0))) then
							v32 = v117.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 85 - 55);
							if (((3528 - (489 + 85)) == (4455 - (277 + 1224))) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				if (((1610 - (663 + 830)) <= (2541 + 351)) and v89) then
					v32 = v117.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 73 - 43);
					if (v32 or ((1328 - (461 + 414)) > (782 + 3880))) then
						return v32;
					end
				end
				if (((529 + 791) > (57 + 538)) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (5 + 0)) and v90) then
					v32 = v117.HandleAfflicted(v101.HealingSurge, v103.HealingSurgeMouseover, 290 - (172 + 78), true);
					if (v32 or ((5157 - 1958) < (218 + 372))) then
						return v32;
					end
				end
			end
			if (v14:AffectingCombat() or ((6916 - 2123) < (9 + 21))) then
				local v243 = 0 + 0;
				while true do
					if ((v243 == (0 - 0)) or ((2134 - 438) <= (267 + 792))) then
						v32 = v143();
						if (((1296 + 1047) == (834 + 1509)) and v32) then
							return v32;
						end
						break;
					end
				end
			else
				local v244 = 0 - 0;
				while true do
					if ((v244 == (0 - 0)) or ((320 + 723) > (2051 + 1540))) then
						v32 = v142();
						if (v32 or ((3337 - (133 + 314)) >= (710 + 3369))) then
							return v32;
						end
						break;
					end
				end
			end
		end
	end
	local function v148()
		local v178 = 213 - (199 + 14);
		while true do
			if (((16016 - 11542) <= (6319 - (647 + 902))) and (v178 == (0 - 0))) then
				v101.FlameShockDebuff:RegisterAuraTracking();
				v124();
				v178 = 234 - (85 + 148);
			end
			if ((v178 == (1290 - (426 + 863))) or ((23129 - 18187) == (5557 - (873 + 781)))) then
				v20.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v20.SetAPL(351 - 88, v147, v148);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

