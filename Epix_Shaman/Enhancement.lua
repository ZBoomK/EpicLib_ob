local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 1334 - (987 + 347);
	local v6;
	while true do
		if ((v5 == (3 - 2)) or ((995 + 1070) >= (3992 - (588 + 208)))) then
			return v6(...);
		end
		if ((v5 == (0 - 0)) or ((6176 - (884 + 916)) <= (3100 - 1619))) then
			v6 = v0[v4];
			if (not v6 or ((1967 + 1425) >= (5394 - (232 + 421)))) then
				return v1(v4, ...);
			end
			v5 = 1890 - (1569 + 320);
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
	local v16 = v10.Spell;
	local v17 = v10.MultiSpell;
	local v18 = v10.Item;
	local v19 = EpicLib;
	local v20 = v19.Cast;
	local v21 = v19.Macro;
	local v22 = v19.Press;
	local v23 = v19.Commons.Everyone.num;
	local v24 = v19.Commons.Everyone.bool;
	local v25 = GetWeaponEnchantInfo;
	local v26 = math.max;
	local v27 = math.min;
	local v28 = string.match;
	local v29 = GetTime;
	local v30 = C_Timer;
	local v31;
	local v32 = false;
	local v33 = false;
	local v34 = false;
	local v35 = false;
	local v36 = false;
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
	local v37;
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
	local v101 = v16.Shaman.Enhancement;
	local v102 = v18.Shaman.Enhancement;
	local v103 = v21.Shaman.Enhancement;
	local v104 = {};
	local v105, v106;
	local v107, v108;
	local v109, v110, v111, v112;
	local v113 = (v101.LavaBurst:IsAvailable() and (1 + 1)) or (1 + 0);
	local v114 = "Lightning Bolt";
	local v115 = 37441 - 26330;
	local v116 = 11716 - (316 + 289);
	local v117 = v19.Commons.Everyone;
	v19.Commons.Shaman = {};
	local v119 = v19.Commons.Shaman;
	v119.LastSKCast = 0 - 0;
	v119.LastSKBuff = 0 + 0;
	v119.LastT302pcBuff = 1453 - (666 + 787);
	v119.FeralSpiritCount = 425 - (360 + 65);
	v10:RegisterForEvent(function()
		v113 = (v101.LavaBurst:IsAvailable() and (2 + 0)) or (255 - (79 + 175));
	end, "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB");
	v10:RegisterForEvent(function()
		local v149 = 0 - 0;
		while true do
			if (((2595 + 730) >= (6602 - 4448)) and (v149 == (0 - 0))) then
				v114 = "Lightning Bolt";
				v115 = 12010 - (503 + 396);
				v149 = 182 - (92 + 89);
			end
			if ((v149 == (1 - 0)) or ((665 + 630) >= (1914 + 1319))) then
				v116 = 43512 - 32401;
				break;
			end
		end
	end, "PLAYER_REGEN_ENABLED");
	v10:RegisterForSelfCombatEvent(function(...)
		local v150 = 0 + 0;
		local v151;
		local v152;
		local v153;
		while true do
			if (((9979 - 5602) > (1433 + 209)) and ((1 + 0) == v150)) then
				if (((14384 - 9661) > (170 + 1186)) and v14:HasTier(46 - 15, 1246 - (485 + 759)) and (v151 == v14:GUID()) and (v153 == (869978 - 493996))) then
					local v243 = 1189 - (442 + 747);
					while true do
						if ((v243 == (1135 - (832 + 303))) or ((5082 - (88 + 858)) <= (1047 + 2386))) then
							v119.FeralSpiritCount = v119.FeralSpiritCount + 1 + 0;
							v30.After(1 + 14, function()
								v119.FeralSpiritCount = v119.FeralSpiritCount - (790 - (766 + 23));
							end);
							break;
						end
					end
				end
				if (((20956 - 16711) <= (6333 - 1702)) and (v151 == v14:GUID()) and (v153 == (135774 - 84241))) then
					local v244 = 0 - 0;
					while true do
						if (((5349 - (1036 + 37)) >= (2775 + 1139)) and (v244 == (0 - 0))) then
							v119.FeralSpiritCount = v119.FeralSpiritCount + 2 + 0;
							v30.After(1495 - (641 + 839), function()
								v119.FeralSpiritCount = v119.FeralSpiritCount - (915 - (910 + 3));
							end);
							break;
						end
					end
				end
				break;
			end
			if (((504 - 306) <= (6049 - (1466 + 218))) and (v150 == (0 + 0))) then
				v151, v152, v152, v152, v152, v152, v152, v152, v153 = select(1152 - (556 + 592), ...);
				if (((1701 + 3081) > (5484 - (329 + 479))) and (v151 == v14:GUID()) and (v153 == (192488 - (174 + 680)))) then
					v119.LastSKCast = v29();
				end
				v150 = 3 - 2;
			end
		end
	end, "SPELL_CAST_SUCCESS");
	v10:RegisterForSelfCombatEvent(function(...)
		local v154, v155, v155, v155, v156 = select(16 - 8, ...);
		if (((3473 + 1391) > (2936 - (396 + 343))) and (v154 == v14:GUID()) and (v156 == (16956 + 174678))) then
			local v191 = 1477 - (29 + 1448);
			while true do
				if (((1389 - (135 + 1254)) == v191) or ((13938 - 10238) == (11705 - 9198))) then
					v119.LastSKBuff = v29();
					v30.After(0.1 + 0, function()
						if (((6001 - (389 + 1138)) >= (848 - (102 + 472))) and (v119.LastSKBuff ~= v119.LastSKCast)) then
							v119.LastT302pcBuff = v119.LastSKBuff;
						end
					end);
					break;
				end
			end
		end
	end, "SPELL_AURA_APPLIED");
	local function v124()
		if (v101.CleanseSpirit:IsAvailable() or ((1788 + 106) <= (780 + 626))) then
			v117.DispellableDebuffs = v117.DispellableCurseDebuffs;
		end
	end
	v10:RegisterForEvent(function()
		v124();
	end, "ACTIVE_PLAYER_SPECIALIZATION_CHANGED");
	local function v125()
		for v189 = 1 + 0, 1551 - (320 + 1225), 1 - 0 do
			if (((962 + 610) >= (2995 - (157 + 1307))) and v28(v14:TotemName(v189), "Totem")) then
				return v189;
			end
		end
	end
	local function v126()
		if (not v101.AlphaWolf:IsAvailable() or v14:BuffDown(v101.FeralSpiritBuff) or ((6546 - (821 + 1038)) < (11331 - 6789))) then
			return 0 + 0;
		end
		local v157 = v27(v101.CrashLightning:TimeSinceLastCast(), v101.ChainLightning:TimeSinceLastCast());
		if (((5845 - 2554) > (621 + 1046)) and ((v157 > (19 - 11)) or (v157 > v101.FeralSpirit:TimeSinceLastCast()))) then
			return 1026 - (834 + 192);
		end
		return (1 + 7) - v157;
	end
	local function v127(v158)
		return (v158:DebuffRefreshable(v101.FlameShockDebuff));
	end
	local function v128(v159)
		return (v159:DebuffRefreshable(v101.LashingFlamesDebuff));
	end
	local function v129(v160)
		return (v160:DebuffRemains(v101.FlameShockDebuff));
	end
	local function v130(v161)
		return (v14:BuffDown(v101.PrimordialWaveBuff));
	end
	local function v131(v162)
		return (v15:DebuffRemains(v101.LashingFlamesDebuff));
	end
	local function v132(v163)
		return (v101.LashingFlames:IsAvailable());
	end
	local function v133(v164)
		return v164:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (2 + 4));
	end
	local function v134()
		if ((v101.CleanseSpirit:IsReady() and v36 and v117.DispellableFriendlyUnit(1 + 24)) or ((1352 - 479) == (2338 - (300 + 4)))) then
			if (v22(v103.CleanseSpiritFocus) or ((753 + 2063) < (28 - 17))) then
				return "cleanse_spirit dispel";
			end
		end
	end
	local function v135()
		if (((4061 - (112 + 250)) < (1877 + 2829)) and (not Focus or not Focus:Exists() or not Focus:IsInRange(100 - 60))) then
			return;
		end
		if (((1516 + 1130) >= (454 + 422)) and Focus) then
			if (((460 + 154) <= (1579 + 1605)) and (Focus:HealthPercentage() <= v82) and v72 and v101.HealingSurge:IsReady() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (4 + 1))) then
				if (((4540 - (1001 + 413)) == (6970 - 3844)) and v22(v103.HealingSurgeFocus)) then
					return "healing_surge heal focus";
				end
			end
		end
	end
	local function v136()
		if ((v14:HealthPercentage() <= v86) or ((3069 - (244 + 638)) >= (5647 - (627 + 66)))) then
			if (v101.HealingSurge:IsReady() or ((11551 - 7674) == (4177 - (512 + 90)))) then
				if (((2613 - (1665 + 241)) > (1349 - (373 + 344))) and v22(v101.HealingSurge)) then
					return "healing_surge heal ooc";
				end
			end
		end
	end
	local function v137()
		local v165 = 0 + 0;
		while true do
			if ((v165 == (1 + 0)) or ((1440 - 894) >= (4541 - 1857))) then
				if (((2564 - (35 + 1064)) <= (3130 + 1171)) and v101.HealingStreamTotem:IsReady() and v71 and v117.AreUnitsBelowHealthPercentage(v80, v81)) then
					if (((3645 - 1941) > (6 + 1419)) and v22(v101.HealingStreamTotem)) then
						return "healing_stream_totem defensive 3";
					end
				end
				if ((v101.HealingSurge:IsReady() and v72 and (v14:HealthPercentage() <= v82) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (1241 - (298 + 938)))) or ((1946 - (233 + 1026)) == (5900 - (636 + 1030)))) then
					if (v22(v101.HealingSurge) or ((1703 + 1627) < (1396 + 33))) then
						return "healing_surge defensive 4";
					end
				end
				v165 = 1 + 1;
			end
			if (((78 + 1069) >= (556 - (55 + 166))) and ((0 + 0) == v165)) then
				if (((346 + 3089) > (8008 - 5911)) and v101.AstralShift:IsReady() and v69 and (v14:HealthPercentage() <= v77)) then
					if (v22(v101.AstralShift) or ((4067 - (36 + 261)) >= (7066 - 3025))) then
						return "astral_shift defensive 1";
					end
				end
				if ((v101.AncestralGuidance:IsReady() and v70 and v117.AreUnitsBelowHealthPercentage(v78, v79)) or ((5159 - (34 + 1334)) <= (620 + 991))) then
					if (v22(v101.AncestralGuidance) or ((3558 + 1020) <= (3291 - (1035 + 248)))) then
						return "ancestral_guidance defensive 2";
					end
				end
				v165 = 22 - (20 + 1);
			end
			if (((587 + 538) <= (2395 - (134 + 185))) and (v165 == (1135 - (549 + 584)))) then
				if ((v102.Healthstone:IsReady() and v73 and (v14:HealthPercentage() <= v83)) or ((1428 - (314 + 371)) >= (15101 - 10702))) then
					if (((2123 - (478 + 490)) < (887 + 786)) and v22(v103.Healthstone)) then
						return "healthstone defensive 3";
					end
				end
				if ((v74 and (v14:HealthPercentage() <= v84)) or ((3496 - (786 + 386)) <= (1872 - 1294))) then
					local v247 = 1379 - (1055 + 324);
					while true do
						if (((5107 - (1093 + 247)) == (3348 + 419)) and (v247 == (0 + 0))) then
							if (((16234 - 12145) == (13876 - 9787)) and (v95 == "Refreshing Healing Potion")) then
								if (((12684 - 8226) >= (4206 - 2532)) and v102.RefreshingHealingPotion:IsReady()) then
									if (((346 + 626) <= (5462 - 4044)) and v22(v103.RefreshingHealingPotion)) then
										return "refreshing healing potion defensive 4";
									end
								end
							end
							if ((v95 == "Dreamwalker's Healing Potion") or ((17020 - 12082) < (3591 + 1171))) then
								if (v102.DreamwalkersHealingPotion:IsReady() or ((6403 - 3899) > (4952 - (364 + 324)))) then
									if (((5901 - 3748) == (5166 - 3013)) and v22(v103.RefreshingHealingPotion)) then
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
		v31 = v117.HandleTopTrinket(v104, v34, 14 + 26, nil);
		if (v31 or ((2121 - 1614) >= (4149 - 1558))) then
			return v31;
		end
		v31 = v117.HandleBottomTrinket(v104, v34, 121 - 81, nil);
		if (((5749 - (1249 + 19)) == (4045 + 436)) and v31) then
			return v31;
		end
	end
	local function v139()
		local v166 = 0 - 0;
		while true do
			if ((v166 == (1087 - (686 + 400))) or ((1827 + 501) < (922 - (73 + 156)))) then
				if (((21 + 4307) == (5139 - (721 + 90))) and v101.DoomWinds:IsCastable() and v56 and ((v61 and v34) or not v61)) then
					if (((18 + 1570) >= (4324 - 2992)) and v22(v101.DoomWinds, not v15:IsSpellInRange(v101.DoomWinds))) then
						return "doom_winds precombat 8";
					end
				end
				if ((v101.Sundering:IsReady() and v50 and ((v62 and v35) or not v62)) or ((4644 - (224 + 246)) > (6881 - 2633))) then
					if (v22(v101.Sundering, not v15:IsInRange(9 - 4)) or ((832 + 3754) <= (2 + 80))) then
						return "sundering precombat 10";
					end
				end
				v166 = 2 + 0;
			end
			if (((7680 - 3817) == (12855 - 8992)) and (v166 == (515 - (203 + 310)))) then
				if ((v101.Stormstrike:IsReady() and v49) or ((2275 - (1238 + 755)) <= (3 + 39))) then
					if (((6143 - (709 + 825)) >= (1410 - 644)) and v22(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
						return "stormstrike precombat 12";
					end
				end
				break;
			end
			if ((v166 == (0 - 0)) or ((2016 - (196 + 668)) == (9823 - 7335))) then
				if (((7088 - 3666) > (4183 - (171 + 662))) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (183 - (4 + 89))))) then
					if (((3073 - 2196) > (137 + 239)) and v22(v101.WindfuryTotem)) then
						return "windfury_totem precombat 4";
					end
				end
				if ((v101.FeralSpirit:IsCastable() and v55 and ((v60 and v34) or not v60)) or ((13694 - 10576) <= (726 + 1125))) then
					if (v22(v101.FeralSpirit) or ((1651 - (35 + 1451)) >= (4945 - (28 + 1425)))) then
						return "feral_spirit precombat 6";
					end
				end
				v166 = 1994 - (941 + 1052);
			end
		end
	end
	local function v140()
		if (((3787 + 162) < (6370 - (822 + 692))) and v101.PrimordialWave:IsCastable() and v48 and ((v63 and v35) or not v63) and (v99 < v116) and v15:DebuffDown(v101.FlameShockDebuff) and v101.LashingFlames:IsAvailable()) then
			if (v22(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave)) or ((6103 - 1827) < (1421 + 1595))) then
				return "primordial_wave single 1";
			end
		end
		if (((4987 - (45 + 252)) > (4082 + 43)) and v101.FlameShock:IsReady() and v42 and v15:DebuffDown(v101.FlameShockDebuff) and v101.LashingFlames:IsAvailable()) then
			if (v22(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock)) or ((18 + 32) >= (2180 - 1284))) then
				return "flame_shock single 2";
			end
		end
		if ((v101.ElementalBlast:IsReady() and v40 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (438 - (114 + 319))) and v101.ElementalSpirits:IsAvailable() and (v119.FeralSpiritCount >= (5 - 1))) or ((2195 - 481) >= (1886 + 1072))) then
			if (v22(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((2221 - 730) < (1349 - 705))) then
				return "elemental_blast single 3";
			end
		end
		if (((2667 - (556 + 1407)) < (2193 - (741 + 465))) and v101.Sundering:IsReady() and v50 and ((v62 and v35) or not v62) and (v99 < v116) and (v14:HasTier(495 - (170 + 295), 2 + 0))) then
			if (((3416 + 302) > (4692 - 2786)) and v22(v101.Sundering, not v15:IsInRange(7 + 1))) then
				return "sundering single 4";
			end
		end
		if ((v101.LightningBolt:IsReady() and v47 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (4 + 1)) and v14:BuffDown(v101.CracklingThunderBuff) and v14:BuffUp(v101.AscendanceBuff) and (v114 == "Chain Lightning") and (v14:BuffRemains(v101.AscendanceBuff) > (v101.ChainLightning:CooldownRemains() + v14:GCD()))) or ((543 + 415) > (4865 - (957 + 273)))) then
			if (((937 + 2564) <= (1799 + 2693)) and v22(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single 5";
			end
		end
		if ((v101.Stormstrike:IsReady() and v49 and (v14:BuffUp(v101.DoomWindsBuff) or v101.DeeplyRootedElements:IsAvailable() or (v101.Stormblast:IsAvailable() and v14:BuffUp(v101.StormbringerBuff)))) or ((13115 - 9673) < (6714 - 4166))) then
			if (((8781 - 5906) >= (7249 - 5785)) and v22(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
				return "stormstrike single 6";
			end
		end
		if ((v101.LavaLash:IsReady() and v46 and (v14:BuffUp(v101.HotHandBuff))) or ((6577 - (389 + 1391)) >= (3070 + 1823))) then
			if (v22(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((58 + 493) > (4707 - 2639))) then
				return "lava_lash single 7";
			end
		end
		if (((3065 - (783 + 168)) > (3168 - 2224)) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true))) then
			if (v22(v101.WindfuryTotem) or ((2225 + 37) >= (3407 - (309 + 2)))) then
				return "windfury_totem single 8";
			end
		end
		if ((v101.ElementalBlast:IsReady() and v40 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (15 - 10)) and (v101.ElementalBlast:Charges() == v113)) or ((3467 - (1090 + 122)) >= (1147 + 2390))) then
			if (v22(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((12886 - 9049) < (894 + 412))) then
				return "elemental_blast single 9";
			end
		end
		if (((4068 - (628 + 490)) == (529 + 2421)) and v101.LightningBolt:IsReady() and v47 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (19 - 11)) and v14:BuffUp(v101.PrimordialWaveBuff) and (v14:BuffDown(v101.SplinteredElementsBuff) or (v116 <= (54 - 42)))) then
			if (v22(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt)) or ((5497 - (431 + 343)) < (6660 - 3362))) then
				return "lightning_bolt single 10";
			end
		end
		if (((3286 - 2150) >= (122 + 32)) and v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 6)) and v14:BuffUp(v101.CracklingThunderBuff) and v101.ElementalSpirits:IsAvailable()) then
			if (v22(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning)) or ((1966 - (556 + 1139)) > (4763 - (6 + 9)))) then
				return "chain_lightning single 11";
			end
		end
		if (((868 + 3872) >= (1615 + 1537)) and v101.ElementalBlast:IsReady() and v40 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (177 - (28 + 141))) and ((v119.FeralSpiritCount >= (1 + 1)) or not v101.ElementalSpirits:IsAvailable())) then
			if (v22(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((3181 - 603) >= (2401 + 989))) then
				return "elemental_blast single 12";
			end
		end
		if (((1358 - (486 + 831)) <= (4322 - 2661)) and v101.LavaBurst:IsReady() and v45 and not v101.ThorimsInvocation:IsAvailable() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (17 - 12))) then
			if (((114 + 487) < (11256 - 7696)) and v22(v101.LavaBurst, not v15:IsSpellInRange(v101.LavaBurst))) then
				return "lava_burst single 13";
			end
		end
		if (((1498 - (668 + 595)) < (619 + 68)) and v101.LightningBolt:IsReady() and v47 and ((v14:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 6)) or (v101.StaticAccumulation:IsAvailable() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (13 - 8)))) and v14:BuffDown(v101.PrimordialWaveBuff)) then
			if (((4839 - (23 + 267)) > (3097 - (1129 + 815))) and v22(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single 14";
			end
		end
		if ((v101.CrashLightning:IsReady() and v39 and v101.AlphaWolf:IsAvailable() and v14:BuffUp(v101.FeralSpiritBuff) and (v126() == (387 - (371 + 16)))) or ((6424 - (1326 + 424)) < (8848 - 4176))) then
			if (((13403 - 9735) < (4679 - (88 + 30))) and v22(v101.CrashLightning, not v15:IsInMeleeRange(779 - (720 + 51)))) then
				return "crash_lightning single 15";
			end
		end
		if ((v101.PrimordialWave:IsCastable() and v48 and ((v63 and v35) or not v63) and (v99 < v116)) or ((1012 - 557) == (5381 - (421 + 1355)))) then
			if (v22(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave)) or ((4393 - 1730) == (1627 + 1685))) then
				return "primordial_wave single 16";
			end
		end
		if (((5360 - (286 + 797)) <= (16358 - 11883)) and v101.FlameShock:IsReady() and v42 and (v15:DebuffDown(v101.FlameShockDebuff))) then
			if (v22(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock)) or ((1441 - 571) == (1628 - (397 + 42)))) then
				return "flame_shock single 17";
			end
		end
		if (((486 + 1067) <= (3933 - (24 + 776))) and v101.IceStrike:IsReady() and v44 and v101.ElementalAssault:IsAvailable() and v101.SwirlingMaelstrom:IsAvailable()) then
			if (v22(v101.IceStrike, not v15:IsInMeleeRange(7 - 2)) or ((3022 - (222 + 563)) >= (7735 - 4224))) then
				return "ice_strike single 18";
			end
		end
		if ((v101.LavaLash:IsReady() and v46 and (v101.LashingFlames:IsAvailable())) or ((954 + 370) > (3210 - (23 + 167)))) then
			if (v22(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((4790 - (690 + 1108)) == (679 + 1202))) then
				return "lava_lash single 19";
			end
		end
		if (((2562 + 544) > (2374 - (40 + 808))) and v101.IceStrike:IsReady() and v44 and (v14:BuffDown(v101.IceStrikeBuff))) then
			if (((498 + 2525) < (14798 - 10928)) and v22(v101.IceStrike, not v15:IsInMeleeRange(5 + 0))) then
				return "ice_strike single 20";
			end
		end
		if (((76 + 67) > (41 + 33)) and v101.FrostShock:IsReady() and v43 and (v14:BuffUp(v101.HailstormBuff))) then
			if (((589 - (47 + 524)) < (1371 + 741)) and v22(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock single 21";
			end
		end
		if (((2998 - 1901) <= (2434 - 806)) and v101.LavaLash:IsReady() and v46) then
			if (((10559 - 5929) == (6356 - (1165 + 561))) and v22(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
				return "lava_lash single 22";
			end
		end
		if (((106 + 3434) > (8309 - 5626)) and v101.IceStrike:IsReady() and v44) then
			if (((1830 + 2964) >= (3754 - (341 + 138))) and v22(v101.IceStrike, not v15:IsInMeleeRange(2 + 3))) then
				return "ice_strike single 23";
			end
		end
		if (((3062 - 1578) == (1810 - (89 + 237))) and v101.Windstrike:IsCastable() and v52) then
			if (((4606 - 3174) < (7484 - 3929)) and v22(v101.Windstrike, not v15:IsSpellInRange(v101.Windstrike))) then
				return "windstrike single 24";
			end
		end
		if ((v101.Stormstrike:IsReady() and v49) or ((1946 - (581 + 300)) > (4798 - (855 + 365)))) then
			if (v22(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike)) or ((11388 - 6593) < (460 + 947))) then
				return "stormstrike single 25";
			end
		end
		if (((3088 - (1030 + 205)) < (4519 + 294)) and v101.Sundering:IsReady() and v50 and ((v62 and v35) or not v62) and (v99 < v116)) then
			if (v22(v101.Sundering, not v15:IsInRange(8 + 0)) or ((3107 - (156 + 130)) < (5523 - 3092))) then
				return "sundering single 26";
			end
		end
		if ((v101.BagofTricks:IsReady() and v58 and ((v65 and v34) or not v65)) or ((4843 - 1969) < (4466 - 2285))) then
			if (v22(v101.BagofTricks) or ((709 + 1980) <= (201 + 142))) then
				return "bag_of_tricks single 27";
			end
		end
		if ((v101.FireNova:IsReady() and v41 and v101.SwirlingMaelstrom:IsAvailable() and v15:DebuffUp(v101.FlameShockDebuff) and (v14:BuffStack(v101.MaelstromWeaponBuff) < ((74 - (10 + 59)) + ((2 + 3) * v23(v101.OverflowingMaelstrom:IsAvailable()))))) or ((9204 - 7335) == (3172 - (671 + 492)))) then
			if (v22(v101.FireNova) or ((2823 + 723) < (3537 - (369 + 846)))) then
				return "fire_nova single 28";
			end
		end
		if ((v101.LightningBolt:IsReady() and v47 and v101.Hailstorm:IsAvailable() and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 3)) and v14:BuffDown(v101.PrimordialWaveBuff)) or ((1777 + 305) == (6718 - (1036 + 909)))) then
			if (((2580 + 664) > (1771 - 716)) and v22(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single 29";
			end
		end
		if ((v101.FrostShock:IsReady() and v43) or ((3516 - (11 + 192)) <= (899 + 879))) then
			if (v22(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock)) or ((1596 - (135 + 40)) >= (5097 - 2993))) then
				return "frost_shock single 30";
			end
		end
		if (((1093 + 719) <= (7157 - 3908)) and v101.CrashLightning:IsReady() and v39) then
			if (((2432 - 809) <= (2133 - (50 + 126))) and v22(v101.CrashLightning, not v15:IsInMeleeRange(22 - 14))) then
				return "crash_lightning single 31";
			end
		end
		if (((977 + 3435) == (5825 - (1233 + 180))) and v101.FireNova:IsReady() and v41 and (v15:DebuffUp(v101.FlameShockDebuff))) then
			if (((2719 - (522 + 447)) >= (2263 - (107 + 1314))) and v22(v101.FireNova)) then
				return "fire_nova single 32";
			end
		end
		if (((2029 + 2343) > (5637 - 3787)) and v101.EarthElemental:IsCastable() and UseEarthElemental and ((EarthElementalWithCD and v34) or not EarthElementalWithCD)) then
			if (((99 + 133) < (1630 - 809)) and v22(v101.EarthElemental)) then
				return "earth_elemental single 33";
			end
		end
		if (((2049 - 1531) < (2812 - (716 + 1194))) and v101.FlameShock:IsReady() and v42) then
			if (((52 + 2942) > (92 + 766)) and v22(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock single 34";
			end
		end
		if ((v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (508 - (74 + 429))) and v14:BuffUp(v101.CracklingThunderBuff) and v101.ElementalSpirits:IsAvailable()) or ((7243 - 3488) <= (454 + 461))) then
			if (((9032 - 5086) > (2649 + 1094)) and v22(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning single 35";
			end
		end
		if ((v101.LightningBolt:IsReady() and v47 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (15 - 10)) and v14:BuffDown(v101.PrimordialWaveBuff)) or ((3300 - 1965) >= (3739 - (279 + 154)))) then
			if (((5622 - (454 + 324)) > (1773 + 480)) and v22(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt single 36";
			end
		end
		if (((469 - (12 + 5)) == (244 + 208)) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (229 - 139)))) then
			if (v22(v101.WindfuryTotem) or ((1684 + 2873) < (3180 - (277 + 816)))) then
				return "windfury_totem single 37";
			end
		end
	end
	local function v141()
		if (((16553 - 12679) == (5057 - (1058 + 125))) and v101.CrashLightning:IsReady() and v39 and v101.CrashingStorms:IsAvailable() and ((v101.UnrulyWinds:IsAvailable() and (v111 >= (2 + 8))) or (v111 >= (990 - (815 + 160))))) then
			if (v22(v101.CrashLightning, not v15:IsInMeleeRange(34 - 26)) or ((4600 - 2662) > (1178 + 3757))) then
				return "crash_lightning aoe 1";
			end
		end
		if ((v101.LightningBolt:IsReady() and v47 and ((v101.FlameShockDebuff:AuraActiveCount() >= v111) or (v14:BuffRemains(v101.PrimordialWaveBuff) < (v14:GCD() * PWaveGCDs)) or (v101.FlameShockDebuff:AuraActiveCount() >= (17 - 11))) and v14:BuffUp(v101.PrimordialWaveBuff) and (v14:BuffStack(v101.MaelstromWeaponBuff) == ((1903 - (41 + 1857)) + ((1898 - (1222 + 671)) * v23(v101.OverflowingMaelstrom:IsAvailable())))) and (v14:BuffDown(v101.SplinteredElementsBuff) or (v116 <= (30 - 18)) or (v99 <= v14:GCD()))) or ((6115 - 1860) < (4605 - (229 + 953)))) then
			if (((3228 - (1111 + 663)) <= (4070 - (874 + 705))) and v22(v101.LightningBolt, not v15:IsSpellInRange(v101.LightningBolt))) then
				return "lightning_bolt aoe 2";
			end
		end
		if ((v101.LavaLash:IsReady() and v46 and v101.MoltenAssault:IsAvailable() and (v101.PrimordialWave:IsAvailable() or v101.FireNova:IsAvailable()) and v15:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (1 + 5))) or ((2837 + 1320) <= (5826 - 3023))) then
			if (((137 + 4716) >= (3661 - (642 + 37))) and v22(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
				return "lava_lash aoe 3";
			end
		end
		if (((943 + 3191) > (538 + 2819)) and v101.PrimordialWave:IsCastable() and v48 and ((v63 and v35) or not v63) and (v99 < v116) and (v14:BuffDown(v101.PrimordialWaveBuff))) then
			local v194 = 0 - 0;
			while true do
				if ((v194 == (454 - (233 + 221))) or ((7901 - 4484) < (2231 + 303))) then
					if (v117.CastCycle(v101.PrimordialWave, v110, v127, not v15:IsSpellInRange(v101.PrimordialWave)) or ((4263 - (718 + 823)) <= (104 + 60))) then
						return "primordial_wave aoe 4";
					end
					if (v22(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave)) or ((3213 - (266 + 539)) < (5970 - 3861))) then
						return "primordial_wave aoe no_cycle 4";
					end
					break;
				end
			end
		end
		if ((v101.FlameShock:IsReady() and v42 and (v101.PrimordialWave:IsAvailable() or v101.FireNova:IsAvailable()) and v15:DebuffDown(v101.FlameShockDebuff)) or ((1258 - (636 + 589)) == (3453 - 1998))) then
			if (v22(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock)) or ((913 - 470) >= (3182 + 833))) then
				return "flame_shock aoe 5";
			end
		end
		if (((1229 + 2153) > (1181 - (657 + 358))) and v101.ElementalBlast:IsReady() and v40 and (not v101.ElementalSpirits:IsAvailable() or (v101.ElementalSpirits:IsAvailable() and ((v101.ElementalBlast:Charges() == v113) or (v119.FeralSpiritCount >= (4 - 2))))) and (v14:BuffStack(v101.MaelstromWeaponBuff) == ((11 - 6) + ((1192 - (1151 + 36)) * v23(v101.OverflowingMaelstrom:IsAvailable())))) and (not v101.CrashingStorms:IsAvailable() or (v111 <= (3 + 0)))) then
			if (v22(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((74 + 206) == (9135 - 6076))) then
				return "elemental_blast aoe 6";
			end
		end
		if (((3713 - (1552 + 280)) > (2127 - (64 + 770))) and v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) == (4 + 1 + ((11 - 6) * v23(v101.OverflowingMaelstrom:IsAvailable()))))) then
			if (((419 + 1938) == (3600 - (157 + 1086))) and v22(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning))) then
				return "chain_lightning aoe 7";
			end
		end
		if (((246 - 123) == (538 - 415)) and v101.CrashLightning:IsReady() and v39 and (v14:BuffUp(v101.DoomWindsBuff) or v14:BuffDown(v101.CrashLightningBuff) or (v101.AlphaWolf:IsAvailable() and v14:BuffUp(v101.FeralSpiritBuff) and (v126() == (0 - 0))))) then
			if (v22(v101.CrashLightning, not v15:IsInMeleeRange(10 - 2)) or ((1875 - (599 + 220)) >= (6754 - 3362))) then
				return "crash_lightning aoe 8";
			end
		end
		if ((v101.Sundering:IsReady() and v50 and ((v62 and v35) or not v62) and (v99 < v116) and (v14:BuffUp(v101.DoomWindsBuff) or v14:HasTier(1961 - (1813 + 118), 2 + 0))) or ((2298 - (841 + 376)) < (1505 - 430))) then
			if (v22(v101.Sundering, not v15:IsInRange(2 + 6)) or ((2863 - 1814) >= (5291 - (464 + 395)))) then
				return "sundering aoe 9";
			end
		end
		if ((v101.FireNova:IsReady() and v41 and ((v101.FlameShockDebuff:AuraActiveCount() >= (15 - 9)) or ((v101.FlameShockDebuff:AuraActiveCount() >= (2 + 2)) and (v101.FlameShockDebuff:AuraActiveCount() >= v111)))) or ((5605 - (467 + 370)) <= (1747 - 901))) then
			if (v22(v101.FireNova) or ((2465 + 893) <= (4867 - 3447))) then
				return "fire_nova aoe 10";
			end
		end
		if ((v101.LavaLash:IsReady() and v46 and (v101.LashingFlames:IsAvailable())) or ((584 + 3155) <= (6991 - 3986))) then
			if (v117.CastCycle(v101.LavaLash, v110, v128, not v15:IsSpellInRange(v101.LavaLash)) or ((2179 - (150 + 370)) >= (3416 - (74 + 1208)))) then
				return "lava_lash aoe 11";
			end
			if (v22(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((8018 - 4758) < (11168 - 8813))) then
				return "lava_lash aoe no_cycle 11";
			end
		end
		if ((v101.LavaLash:IsReady() and v46 and ((v101.MoltenAssault:IsAvailable() and v15:DebuffUp(v101.FlameShockDebuff) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (5 + 1))) or (v101.AshenCatalyst:IsAvailable() and (v14:BuffStack(v101.AshenCatalystBuff) == (395 - (14 + 376)))))) or ((1159 - 490) == (2733 + 1490))) then
			if (v22(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash)) or ((1487 + 205) < (561 + 27))) then
				return "lava_lash aoe 12";
			end
		end
		if ((v101.IceStrike:IsReady() and v44 and (v101.Hailstorm:IsAvailable())) or ((14055 - 9258) < (2747 + 904))) then
			if (v22(v101.IceStrike, not v15:IsInMeleeRange(83 - (23 + 55))) or ((9898 - 5721) > (3237 + 1613))) then
				return "ice_strike aoe 13";
			end
		end
		if ((v101.FrostShock:IsReady() and v43 and v101.Hailstorm:IsAvailable() and v14:BuffUp(v101.HailstormBuff)) or ((360 + 40) > (1722 - 611))) then
			if (((960 + 2091) > (1906 - (652 + 249))) and v22(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock aoe 14";
			end
		end
		if (((9882 - 6189) <= (6250 - (708 + 1160))) and v101.Sundering:IsReady() and v50 and ((v62 and v35) or not v62) and (v99 < v116)) then
			if (v22(v101.Sundering, not v15:IsInRange(21 - 13)) or ((5983 - 2701) > (4127 - (10 + 17)))) then
				return "sundering aoe 15";
			end
		end
		if ((v101.FlameShock:IsReady() and v42 and v101.MoltenAssault:IsAvailable() and v15:DebuffDown(v101.FlameShockDebuff)) or ((805 + 2775) < (4576 - (1400 + 332)))) then
			if (((170 - 81) < (6398 - (242 + 1666))) and v22(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock aoe 16";
			end
		end
		if ((v101.FlameShock:IsReady() and v42 and v15:DebuffRefreshable(v101.FlameShockDebuff) and (v101.FireNova:IsAvailable() or v101.PrimordialWave:IsAvailable()) and (v101.FlameShockDebuff:AuraActiveCount() < v111) and (v101.FlameShockDebuff:AuraActiveCount() < (3 + 3))) or ((1827 + 3156) < (1541 + 267))) then
			if (((4769 - (850 + 90)) > (6600 - 2831)) and v117.CastCycle(v101.FlameShock, v110, v127, not v15:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock aoe 17";
			end
			if (((2875 - (360 + 1030)) <= (2570 + 334)) and v22(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock))) then
				return "flame_shock aoe no_cycle 17";
			end
		end
		if (((12048 - 7779) == (5872 - 1603)) and v101.FireNova:IsReady() and v41 and (v101.FlameShockDebuff:AuraActiveCount() >= (1664 - (909 + 752)))) then
			if (((1610 - (109 + 1114)) <= (5092 - 2310)) and v22(v101.FireNova)) then
				return "fire_nova aoe 18";
			end
		end
		if ((v101.Stormstrike:IsReady() and v49 and v14:BuffUp(v101.CrashLightningBuff) and (v101.DeeplyRootedElements:IsAvailable() or (v14:BuffStack(v101.ConvergingStormsBuff) == (3 + 3)))) or ((2141 - (6 + 236)) <= (578 + 339))) then
			if (v22(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike)) or ((3471 + 841) <= (2065 - 1189))) then
				return "stormstrike aoe 19";
			end
		end
		if (((3898 - 1666) <= (3729 - (1076 + 57))) and v101.CrashLightning:IsReady() and v39 and v101.CrashingStorms:IsAvailable() and v14:BuffUp(v101.CLCrashLightningBuff) and (v111 >= (1 + 3))) then
			if (((2784 - (579 + 110)) < (292 + 3394)) and v22(v101.CrashLightning, not v15:IsInMeleeRange(8 + 0))) then
				return "crash_lightning aoe 20";
			end
		end
		if ((v101.Windstrike:IsCastable() and v52) or ((847 + 748) >= (4881 - (174 + 233)))) then
			if (v22(v101.Windstrike, not v15:IsSpellInRange(v101.Windstrike)) or ((12902 - 8283) < (5058 - 2176))) then
				return "windstrike aoe 21";
			end
		end
		if ((v101.Stormstrike:IsReady() and v49) or ((131 + 163) >= (6005 - (663 + 511)))) then
			if (((1811 + 218) <= (670 + 2414)) and v22(v101.Stormstrike, not v15:IsSpellInRange(v101.Stormstrike))) then
				return "stormstrike aoe 22";
			end
		end
		if ((v101.IceStrike:IsReady() and v44) or ((6279 - 4242) == (1466 + 954))) then
			if (((10495 - 6037) > (9450 - 5546)) and v22(v101.IceStrike, not v15:IsInMeleeRange(3 + 2))) then
				return "ice_strike aoe 23";
			end
		end
		if (((848 - 412) >= (88 + 35)) and v101.LavaLash:IsReady() and v46) then
			if (((46 + 454) < (2538 - (478 + 244))) and v22(v101.LavaLash, not v15:IsSpellInRange(v101.LavaLash))) then
				return "lava_lash aoe 24";
			end
		end
		if (((4091 - (440 + 77)) == (1626 + 1948)) and v101.CrashLightning:IsReady() and v39) then
			if (((808 - 587) < (1946 - (655 + 901))) and v22(v101.CrashLightning, not v15:IsInMeleeRange(2 + 6))) then
				return "crash_lightning aoe 25";
			end
		end
		if ((v101.FireNova:IsReady() and v41 and (v101.FlameShockDebuff:AuraActiveCount() >= (2 + 0))) or ((1495 + 718) <= (5724 - 4303))) then
			if (((4503 - (695 + 750)) < (16595 - 11735)) and v22(v101.FireNova)) then
				return "fire_nova aoe 26";
			end
		end
		if ((v101.ElementalBlast:IsReady() and v40 and (not v101.ElementalSpirits:IsAvailable() or (v101.ElementalSpirits:IsAvailable() and ((v101.ElementalBlast:Charges() == v113) or (v119.FeralSpiritCount >= (2 - 0))))) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (20 - 15)) and (not v101.CrashingStorms:IsAvailable() or (v111 <= (354 - (285 + 66))))) or ((3020 - 1724) >= (5756 - (682 + 628)))) then
			if (v22(v101.ElementalBlast, not v15:IsSpellInRange(v101.ElementalBlast)) or ((225 + 1168) > (4788 - (176 + 123)))) then
				return "elemental_blast aoe 27";
			end
		end
		if ((v101.ChainLightning:IsReady() and v38 and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (3 + 2))) or ((3210 + 1214) < (296 - (239 + 30)))) then
			if (v22(v101.ChainLightning, not v15:IsSpellInRange(v101.ChainLightning)) or ((543 + 1454) > (3667 + 148))) then
				return "chain_lightning aoe 28";
			end
		end
		if (((6132 - 2667) > (5967 - 4054)) and v101.WindfuryTotem:IsReady() and v51 and (v14:BuffDown(v101.WindfuryTotemBuff, true) or (v101.WindfuryTotem:TimeSinceLastCast() > (405 - (306 + 9))))) then
			if (((2557 - 1824) < (317 + 1502)) and v22(v101.WindfuryTotem)) then
				return "windfury_totem aoe 29";
			end
		end
		if ((v101.FlameShock:IsReady() and v42 and (v15:DebuffDown(v101.FlameShockDebuff))) or ((2697 + 1698) == (2289 + 2466))) then
			if (v22(v101.FlameShock, not v15:IsSpellInRange(v101.FlameShock)) or ((10846 - 7053) < (3744 - (1140 + 235)))) then
				return "flame_shock aoe 30";
			end
		end
		if ((v101.FrostShock:IsReady() and v43 and not v101.Hailstorm:IsAvailable()) or ((2599 + 1485) == (244 + 21))) then
			if (((1119 + 3239) == (4410 - (33 + 19))) and v22(v101.FrostShock, not v15:IsSpellInRange(v101.FrostShock))) then
				return "frost_shock aoe 31";
			end
		end
	end
	local function v142()
		if ((v75 and v101.EarthShield:IsCastable() and v14:BuffDown(v101.EarthShieldBuff) and ((v76 == "Earth Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.LightningShield)))) or ((1134 + 2004) < (2976 - 1983))) then
			if (((1467 + 1863) > (4555 - 2232)) and v22(v101.EarthShield)) then
				return "earth_shield main 2";
			end
		elseif ((v75 and v101.LightningShield:IsCastable() and v14:BuffDown(v101.LightningShieldBuff) and ((v76 == "Lightning Shield") or (v101.ElementalOrbit:IsAvailable() and v14:BuffUp(v101.EarthShield)))) or ((3401 + 225) == (4678 - (586 + 103)))) then
			if (v22(v101.LightningShield) or ((84 + 832) == (8222 - 5551))) then
				return "lightning_shield main 2";
			end
		end
		if (((1760 - (1309 + 179)) == (490 - 218)) and (not v105 or (v107 < (261150 + 338850))) and v53 and v101.WindfuryWeapon:IsCastable()) then
			if (((11410 - 7161) <= (3656 + 1183)) and v22(v101.WindfuryWeapon)) then
				return "windfury_weapon enchant";
			end
		end
		if (((5899 - 3122) < (6376 - 3176)) and (not v106 or (v108 < (600609 - (295 + 314)))) and v53 and v101.FlamentongueWeapon:IsCastable()) then
			if (((233 - 138) < (3919 - (1300 + 662))) and v22(v101.FlamentongueWeapon)) then
				return "flametongue_weapon enchant";
			end
		end
		if (((2593 - 1767) < (3472 - (1178 + 577))) and v85) then
			local v195 = 0 + 0;
			while true do
				if (((4215 - 2789) >= (2510 - (851 + 554))) and (v195 == (0 + 0))) then
					v31 = v136();
					if (((7637 - 4883) <= (7338 - 3959)) and v31) then
						return v31;
					end
					break;
				end
			end
		end
		if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) or ((4229 - (115 + 187)) == (1083 + 330))) then
			if (v22(v101.AncestralSpirit, nil, true) or ((1093 + 61) <= (3105 - 2317))) then
				return "resurrection";
			end
		end
		if ((v117.TargetIsValid() and v32) or ((2804 - (160 + 1001)) > (2957 + 422))) then
			if (not v14:AffectingCombat() or ((1935 + 868) > (9311 - 4762))) then
				local v240 = v139();
				if (v240 or ((578 - (237 + 121)) >= (3919 - (525 + 372)))) then
					return v240;
				end
			end
		end
	end
	local function v143()
		v31 = v137();
		if (((5349 - 2527) == (9271 - 6449)) and v31) then
			return v31;
		end
		if (v93 or ((1203 - (96 + 46)) == (2634 - (643 + 134)))) then
			local v196 = 0 + 0;
			while true do
				if (((6617 - 3857) > (5063 - 3699)) and (v196 == (0 + 0))) then
					if (v87 or ((9620 - 4718) <= (7348 - 3753))) then
						v31 = v117.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 759 - (316 + 403));
						if (v31 or ((2561 + 1291) == (805 - 512))) then
							return v31;
						end
					end
					if (v88 or ((564 + 995) == (11554 - 6966))) then
						v31 = v117.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 22 + 8);
						if (v31 or ((1446 + 3038) == (2730 - 1942))) then
							return v31;
						end
					end
					v196 = 4 - 3;
				end
				if (((9489 - 4921) >= (224 + 3683)) and (v196 == (1 - 0))) then
					if (((61 + 1185) < (10209 - 6739)) and v89) then
						v31 = v117.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 47 - (12 + 5));
						if (((15800 - 11732) >= (2073 - 1101)) and v31) then
							return v31;
						end
					end
					if (((1047 - 554) < (9654 - 5761)) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (2 + 3)) and v90) then
						v31 = v117.HandleAfflicted(v101.HealingSurge, v103.HealingSurgeMouseover, 2013 - (1656 + 317), true);
						if (v31 or ((1313 + 160) >= (2671 + 661))) then
							return v31;
						end
					end
					break;
				end
			end
		end
		if (v94 or ((10771 - 6720) <= (5694 - 4537))) then
			local v197 = 354 - (5 + 349);
			while true do
				if (((2868 - 2264) < (4152 - (266 + 1005))) and (v197 == (0 + 0))) then
					v31 = v117.HandleIncorporeal(v101.Hex, v103.HexMouseOver, 102 - 72, true);
					if (v31 or ((1184 - 284) == (5073 - (561 + 1135)))) then
						return v31;
					end
					break;
				end
			end
		end
		if (((5810 - 1351) > (1942 - 1351)) and Focus) then
			if (((4464 - (507 + 559)) >= (6009 - 3614)) and v92) then
				v31 = v134();
				if (v31 or ((6751 - 4568) >= (3212 - (212 + 176)))) then
					return v31;
				end
			end
		end
		if (((2841 - (250 + 655)) == (5279 - 3343)) and v101.GreaterPurge:IsAvailable() and v100 and v101.GreaterPurge:IsReady() and v36 and v91 and not v14:IsCasting() and not v14:IsChanneling() and v117.UnitHasMagicBuff(v15)) then
			if (v22(v101.GreaterPurge, not v15:IsSpellInRange(v101.GreaterPurge)) or ((8442 - 3610) < (6747 - 2434))) then
				return "greater_purge damage";
			end
		end
		if (((6044 - (1869 + 87)) > (13436 - 9562)) and v101.Purge:IsReady() and v100 and v36 and v91 and not v14:IsCasting() and not v14:IsChanneling() and v117.UnitHasMagicBuff(v15)) then
			if (((6233 - (484 + 1417)) == (9285 - 4953)) and v22(v101.Purge, not v15:IsSpellInRange(v101.Purge))) then
				return "purge damage";
			end
		end
		v31 = v135();
		if (((6701 - 2702) >= (3673 - (48 + 725))) and v31) then
			return v31;
		end
		if (v117.TargetIsValid() or ((4124 - 1599) > (10903 - 6839))) then
			local v198 = 0 + 0;
			local v199;
			while true do
				if (((11681 - 7310) == (1224 + 3147)) and (v198 == (1 + 2))) then
					if ((v101.DoomWinds:IsCastable() and v56 and ((v61 and v34) or not v61) and (v99 < v116)) or ((1119 - (152 + 701)) > (6297 - (430 + 881)))) then
						if (((763 + 1228) >= (1820 - (557 + 338))) and v22(v101.DoomWinds, not v15:IsInMeleeRange(2 + 3))) then
							return "doom_winds main 5";
						end
					end
					if (((1282 - 827) < (7188 - 5135)) and (v111 == (2 - 1))) then
						local v248 = 0 - 0;
						local v249;
						while true do
							if ((v248 == (801 - (499 + 302))) or ((1692 - (39 + 827)) == (13391 - 8540))) then
								v249 = v140();
								if (((408 - 225) == (726 - 543)) and v249) then
									return v249;
								end
								break;
							end
						end
					end
					if (((1778 - 619) <= (154 + 1634)) and v33 and (v111 > (2 - 1))) then
						local v250 = 0 + 0;
						local v251;
						while true do
							if ((v250 == (0 - 0)) or ((3611 - (103 + 1)) > (4872 - (475 + 79)))) then
								v251 = v141();
								if (v251 or ((6647 - 3572) <= (9488 - 6523))) then
									return v251;
								end
								break;
							end
						end
					end
					v198 = 1 + 3;
				end
				if (((1202 + 163) <= (3514 - (1395 + 108))) and (v198 == (0 - 0))) then
					v199 = v117.HandleDPSPotion(v14:BuffUp(v101.FeralSpiritBuff));
					if (v199 or ((3980 - (7 + 1197)) > (1559 + 2016))) then
						return v199;
					end
					if ((v99 < v116) or ((892 + 1662) == (5123 - (27 + 292)))) then
						if (((7551 - 4974) == (3285 - 708)) and v57 and ((v34 and v64) or not v64)) then
							v31 = v138();
							if (v31 or ((25 - 19) >= (3724 - 1835))) then
								return v31;
							end
						end
					end
					v198 = 1 - 0;
				end
				if (((645 - (43 + 96)) <= (7717 - 5825)) and (v198 == (3 - 1))) then
					if ((v101.PrimordialWave:IsCastable() and v48 and ((v63 and v35) or not v63) and (v99 < v116) and (v14:HasTier(26 + 5, 1 + 1))) or ((3968 - 1960) > (851 + 1367))) then
						if (((709 - 330) <= (1306 + 2841)) and v22(v101.PrimordialWave, not v15:IsSpellInRange(v101.PrimordialWave))) then
							return "primordial_wave main 2";
						end
					end
					if ((v101.FeralSpirit:IsCastable() and v55 and ((v60 and v34) or not v60) and (v99 < v116)) or ((332 + 4182) <= (2760 - (1414 + 337)))) then
						if (v22(v101.FeralSpirit) or ((5436 - (1642 + 298)) == (3107 - 1915))) then
							return "feral_spirit main 3";
						end
					end
					if ((v101.Ascendance:IsCastable() and v54 and ((v59 and v34) or not v59) and (v99 < v116) and v15:DebuffUp(v101.FlameShockDebuff) and (((v114 == "Lightning Bolt") and (v111 == (2 - 1))) or ((v114 == "Chain Lightning") and (v111 > (2 - 1))))) or ((69 + 139) == (2303 + 656))) then
						if (((5249 - (357 + 615)) >= (922 + 391)) and v22(v101.Ascendance)) then
							return "ascendance main 4";
						end
					end
					v198 = 6 - 3;
				end
				if (((2217 + 370) < (6801 - 3627)) and (v198 == (4 + 0))) then
					if (v19.CastAnnotated(v101.Pool, false, "WAIT") or ((280 + 3840) <= (1382 + 816))) then
						return "Wait/Pool Resources";
					end
					break;
				end
				if ((v198 == (1302 - (384 + 917))) or ((2293 - (128 + 569)) == (2401 - (1407 + 136)))) then
					if (((5107 - (687 + 1200)) == (4930 - (556 + 1154))) and (v99 < v116) and v58 and ((v65 and v34) or not v65)) then
						if ((v101.BloodFury:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (175 - 125)))) or ((1497 - (9 + 86)) > (4041 - (275 + 146)))) then
							if (((419 + 2155) == (2638 - (29 + 35))) and v22(v101.BloodFury)) then
								return "blood_fury racial";
							end
						end
						if (((7968 - 6170) < (8234 - 5477)) and v101.Berserking:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff))) then
							if (v22(v101.Berserking) or ((1664 - 1287) > (1697 + 907))) then
								return "berserking racial";
							end
						end
						if (((1580 - (53 + 959)) < (1319 - (312 + 96))) and v101.Fireblood:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (86 - 36)))) then
							if (((3570 - (147 + 138)) < (5127 - (813 + 86))) and v22(v101.Fireblood)) then
								return "fireblood racial";
							end
						end
						if (((3539 + 377) > (6165 - 2837)) and v101.AncestralCall:IsCastable() and (not v101.Ascendance:IsAvailable() or v14:BuffUp(v101.AscendanceBuff) or (v101.Ascendance:CooldownRemains() > (542 - (18 + 474))))) then
							if (((844 + 1656) < (12529 - 8690)) and v22(v101.AncestralCall)) then
								return "ancestral_call racial";
							end
						end
					end
					if (((1593 - (860 + 226)) == (810 - (121 + 182))) and v101.TotemicProjection:IsCastable() and (v101.WindfuryTotem:TimeSinceLastCast() < (12 + 78)) and v14:BuffDown(v101.WindfuryTotemBuff, true)) then
						if (((1480 - (988 + 252)) <= (358 + 2807)) and v22(v103.TotemicProjectionPlayer)) then
							return "totemic_projection wind_fury main 0";
						end
					end
					if (((262 + 572) >= (2775 - (49 + 1921))) and v101.Windstrike:IsCastable() and v52) then
						if (v22(v101.Windstrike, not v15:IsSpellInRange(v101.Windstrike)) or ((4702 - (223 + 667)) < (2368 - (51 + 1)))) then
							return "windstrike main 1";
						end
					end
					v198 = 2 - 0;
				end
			end
		end
	end
	local function v144()
		local v167 = 0 - 0;
		while true do
			if ((v167 == (1131 - (146 + 979))) or ((749 + 1903) <= (2138 - (311 + 294)))) then
				v53 = EpicSettings.Settings['useWeaponEnchant'];
				v59 = EpicSettings.Settings['ascendanceWithCD'];
				v61 = EpicSettings.Settings['doomWindsWithCD'];
				v167 = 19 - 12;
			end
			if ((v167 == (1 + 0)) or ((5041 - (496 + 947)) < (2818 - (1233 + 125)))) then
				v38 = EpicSettings.Settings['useChainlightning'];
				v39 = EpicSettings.Settings['useCrashLightning'];
				v40 = EpicSettings.Settings['useElementalBlast'];
				v167 = 1 + 1;
			end
			if ((v167 == (5 + 0)) or ((783 + 3333) < (2837 - (963 + 682)))) then
				v50 = EpicSettings.Settings['useSundering'];
				v52 = EpicSettings.Settings['useWindstrike'];
				v51 = EpicSettings.Settings['useWindfuryTotem'];
				v167 = 6 + 0;
			end
			if ((v167 == (1506 - (504 + 1000))) or ((2275 + 1102) <= (823 + 80))) then
				v41 = EpicSettings.Settings['useFireNova'];
				v42 = EpicSettings.Settings['useFlameShock'];
				v43 = EpicSettings.Settings['useFrostShock'];
				v167 = 1 + 2;
			end
			if (((5862 - 1886) >= (376 + 63)) and (v167 == (3 + 1))) then
				v47 = EpicSettings.Settings['useLightningBolt'];
				v48 = EpicSettings.Settings['usePrimordialWave'];
				v49 = EpicSettings.Settings['useStormStrike'];
				v167 = 187 - (156 + 26);
			end
			if (((2162 + 1590) == (5869 - 2117)) and (v167 == (167 - (149 + 15)))) then
				v44 = EpicSettings.Settings['useIceStrike'];
				v45 = EpicSettings.Settings['useLavaBurst'];
				v46 = EpicSettings.Settings['useLavaLash'];
				v167 = 964 - (890 + 70);
			end
			if (((4163 - (39 + 78)) > (3177 - (14 + 468))) and ((15 - 8) == v167)) then
				v60 = EpicSettings.Settings['feralSpiritWithCD'];
				v63 = EpicSettings.Settings['primordialWaveWithMiniCD'];
				v62 = EpicSettings.Settings['sunderingWithMiniCD'];
				break;
			end
			if ((v167 == (0 - 0)) or ((1830 + 1715) == (1920 + 1277))) then
				v54 = EpicSettings.Settings['useAscendance'];
				v56 = EpicSettings.Settings['useDoomWinds'];
				v55 = EpicSettings.Settings['useFeralSpirit'];
				v167 = 1 + 0;
			end
		end
	end
	local function v145()
		v66 = EpicSettings.Settings['useWindShear'];
		v37 = EpicSettings.Settings['useCapacitorTotem'];
		v67 = EpicSettings.Settings['useThunderstorm'];
		v70 = EpicSettings.Settings['useAncestralGuidance'];
		v69 = EpicSettings.Settings['useAstralShift'];
		v72 = EpicSettings.Settings['useMaelstromHealingSurge'];
		v71 = EpicSettings.Settings['useHealingStreamTotem'];
		v78 = EpicSettings.Settings['ancestralGuidanceHP'] or (0 + 0);
		v79 = EpicSettings.Settings['ancestralGuidanceGroup'] or (0 + 0);
		v77 = EpicSettings.Settings['astralShiftHP'] or (0 - 0);
		v80 = EpicSettings.Settings['healingStreamTotemHP'] or (0 + 0);
		v81 = EpicSettings.Settings['healingStreamTotemGroup'] or (0 - 0);
		v82 = EpicSettings.Settings['maelstromHealingSurgeCriticalHP'] or (0 + 0);
		v75 = EpicSettings.Settings['autoShield'];
		v76 = EpicSettings.Settings['shieldUse'] or "Lightning Shield";
		v85 = EpicSettings.Settings['healOOC'];
		v86 = EpicSettings.Settings['healOOCHP'] or (51 - (12 + 39));
		v100 = EpicSettings.Settings['usePurgeTarget'];
		v87 = EpicSettings.Settings['useCleanseSpiritWithAfflicted'];
		v88 = EpicSettings.Settings['useTremorTotemWithAfflicted'];
		v89 = EpicSettings.Settings['usePoisonCleansingTotemWithAfflicted'];
		v90 = EpicSettings.Settings['useMaelstromHealingSurgeWithAfflicted'];
	end
	local function v146()
		local v182 = 0 + 0;
		while true do
			if (((7410 - 5016) > (1328 - 955)) and (v182 == (0 + 0))) then
				v99 = EpicSettings.Settings['fightRemainsCheck'] or (0 + 0);
				v96 = EpicSettings.Settings['InterruptWithStun'];
				v97 = EpicSettings.Settings['InterruptOnlyWhitelist'];
				v182 = 2 - 1;
			end
			if (((2768 + 1387) <= (20452 - 16220)) and (v182 == (1715 - (1596 + 114)))) then
				v93 = EpicSettings.Settings['handleAfflicted'];
				v94 = EpicSettings.Settings['HandleIncorporeal'];
				break;
			end
			if ((v182 == (7 - 4)) or ((4294 - (164 + 549)) == (4911 - (1059 + 379)))) then
				v65 = EpicSettings.Settings['racialsWithCD'];
				v73 = EpicSettings.Settings['useHealthstone'];
				v74 = EpicSettings.Settings['useHealingPotion'];
				v182 = 4 - 0;
			end
			if (((2589 + 2406) > (565 + 2783)) and (v182 == (393 - (145 + 247)))) then
				v98 = EpicSettings.Settings['InterruptThreshold'];
				v92 = EpicSettings.Settings['DispelDebuffs'];
				v91 = EpicSettings.Settings['DispelBuffs'];
				v182 = 2 + 0;
			end
			if (((2 + 2) == v182) or ((2235 - 1481) > (715 + 3009))) then
				v83 = EpicSettings.Settings['healthstoneHP'] or (0 + 0);
				v84 = EpicSettings.Settings['healingPotionHP'] or (0 - 0);
				v95 = EpicSettings.Settings['HealingPotionName'] or "";
				v182 = 725 - (254 + 466);
			end
			if (((777 - (544 + 16)) >= (180 - 123)) and (v182 == (630 - (294 + 334)))) then
				v57 = EpicSettings.Settings['useTrinkets'];
				v58 = EpicSettings.Settings['useRacials'];
				v64 = EpicSettings.Settings['trinketsWithCD'];
				v182 = 256 - (236 + 17);
			end
		end
	end
	local function v147()
		v145();
		v144();
		v146();
		v32 = EpicSettings.Toggles['ooc'];
		v33 = EpicSettings.Toggles['aoe'];
		v34 = EpicSettings.Toggles['cds'];
		v36 = EpicSettings.Toggles['dispel'];
		v35 = EpicSettings.Toggles['minicds'];
		if (v14:IsDeadOrGhost() or ((893 + 1177) >= (3143 + 894))) then
			return;
		end
		v105, v107, _, _, v106, v108 = v25();
		v109 = v14:GetEnemiesInRange(150 - 110);
		v110 = v14:GetEnemiesInMeleeRange(47 - 37);
		if (((1393 + 1312) == (2228 + 477)) and v33) then
			v112 = #v109;
			v111 = #v110;
		else
			v112 = 795 - (413 + 381);
			v111 = 1 + 0;
		end
		if (((129 - 68) == (158 - 97)) and (v14:AffectingCombat() or v92)) then
			local v200 = 1970 - (582 + 1388);
			local v201;
			while true do
				if (((0 - 0) == v200) or ((501 + 198) >= (1660 - (326 + 38)))) then
					v201 = v92 and v101.CleanseSpirit:IsReady() and v36;
					v31 = v117.FocusUnit(v201, v103, 59 - 39, nil, 35 - 10);
					v200 = 621 - (47 + 573);
				end
				if ((v200 == (1 + 0)) or ((7572 - 5789) >= (5868 - 2252))) then
					if (v31 or ((5577 - (1269 + 395)) > (5019 - (76 + 416)))) then
						return v31;
					end
					break;
				end
			end
		end
		if (((4819 - (319 + 124)) > (1867 - 1050)) and (v117.TargetIsValid() or v14:AffectingCombat())) then
			local v202 = 1007 - (564 + 443);
			while true do
				if (((13457 - 8596) > (1282 - (337 + 121))) and ((0 - 0) == v202)) then
					v115 = v10.BossFightRemains(nil, true);
					v116 = v115;
					v202 = 3 - 2;
				end
				if ((v202 == (1912 - (1261 + 650))) or ((586 + 797) >= (3395 - 1264))) then
					if ((v116 == (12928 - (772 + 1045))) or ((265 + 1611) >= (2685 - (102 + 42)))) then
						v116 = v10.FightRemains(v110, false);
					end
					break;
				end
			end
		end
		if (((3626 - (1524 + 320)) <= (5042 - (1049 + 221))) and v14:AffectingCombat()) then
			if (v14:PrevGCD(157 - (18 + 138), v101.ChainLightning) or ((11504 - 6804) < (1915 - (67 + 1035)))) then
				v114 = "Chain Lightning";
			elseif (((3547 - (136 + 212)) < (17210 - 13160)) and v14:PrevGCD(1 + 0, v101.LightningBolt)) then
				v114 = "Lightning Bolt";
			end
		end
		if ((not v14:IsChanneling() and not v14:IsChanneling()) or ((4565 + 386) < (6034 - (240 + 1364)))) then
			if (((1178 - (1050 + 32)) == (342 - 246)) and Focus) then
				if (v92 or ((1621 + 1118) > (5063 - (331 + 724)))) then
					v31 = v134();
					if (v31 or ((2 + 21) == (1778 - (269 + 375)))) then
						return v31;
					end
				end
			end
			if (v93 or ((3418 - (267 + 458)) >= (1279 + 2832))) then
				local v241 = 0 - 0;
				while true do
					if ((v241 == (819 - (667 + 151))) or ((5813 - (1410 + 87)) <= (4043 - (1504 + 393)))) then
						if (v89 or ((9584 - 6038) <= (7287 - 4478))) then
							local v258 = 796 - (461 + 335);
							while true do
								if (((627 + 4277) > (3927 - (1730 + 31))) and (v258 == (1667 - (728 + 939)))) then
									v31 = v117.HandleAfflicted(v101.PoisonCleansingTotem, v101.PoisonCleansingTotem, 106 - 76);
									if (((220 - 111) >= (206 - 116)) and v31) then
										return v31;
									end
									break;
								end
							end
						end
						if (((6046 - (138 + 930)) > (2655 + 250)) and (v14:BuffStack(v101.MaelstromWeaponBuff) >= (4 + 1)) and v90) then
							v31 = v117.HandleAfflicted(v101.HealingSurge, v103.HealingSurgeMouseover, 35 + 5, true);
							if (v31 or ((12355 - 9329) <= (4046 - (459 + 1307)))) then
								return v31;
							end
						end
						break;
					end
					if ((v241 == (1870 - (474 + 1396))) or ((2886 - 1233) <= (1039 + 69))) then
						if (((10 + 2899) > (7473 - 4864)) and v87) then
							local v259 = 0 + 0;
							while true do
								if (((2526 - 1769) > (846 - 652)) and (v259 == (591 - (562 + 29)))) then
									v31 = v117.HandleAfflicted(v101.CleanseSpirit, v103.CleanseSpiritMouseover, 35 + 5);
									if (v31 or ((1450 - (374 + 1045)) >= (1107 + 291))) then
										return v31;
									end
									break;
								end
							end
						end
						if (((9924 - 6728) <= (5510 - (448 + 190))) and v88) then
							v31 = v117.HandleAfflicted(v101.TremorTotem, v101.TremorTotem, 10 + 20);
							if (((1502 + 1824) == (2168 + 1158)) and v31) then
								return v31;
							end
						end
						v241 = 3 - 2;
					end
				end
			end
			if (((4452 - 3019) <= (5372 - (1307 + 187))) and v14:AffectingCombat()) then
				local v242 = 0 - 0;
				while true do
					if ((v242 == (0 - 0)) or ((4853 - 3270) == (2418 - (232 + 451)))) then
						v31 = v143();
						if (v31 or ((2847 + 134) == (2076 + 274))) then
							return v31;
						end
						break;
					end
				end
			else
				v31 = v142();
				if (v31 or ((5030 - (510 + 54)) <= (992 - 499))) then
					return v31;
				end
			end
		end
	end
	local function v148()
		local v188 = 36 - (13 + 23);
		while true do
			if ((v188 == (0 - 0)) or ((3659 - 1112) <= (3610 - 1623))) then
				v101.FlameShockDebuff:RegisterAuraTracking();
				v124();
				v188 = 1089 - (830 + 258);
			end
			if (((10445 - 7484) > (1715 + 1025)) and (v188 == (1 + 0))) then
				v19.Print("Enhancement Shaman by Epic. Supported by xKaneto.");
				break;
			end
		end
	end
	v19.SetAPL(1704 - (860 + 581), v147, v148);
end;
return v0["Epix_Shaman_Enhancement.lua"]();

