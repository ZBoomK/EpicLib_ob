local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0 + 0;
	local v6;
	while true do
		if (((1975 + 2557) > (7039 - 4343)) and (v5 == (1 + 0))) then
			return v6(...);
		end
		if (((2215 - (645 + 522)) >= (1842 - (1010 + 780))) and (v5 == (0 + 0))) then
			v6 = v0[v4];
			if (((14091 - 11133) < (13195 - 8692)) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1837 - (1045 + 791);
		end
	end
end
v0["Epix_Warlock_Destruction.lua"] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC.DBC;
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10.Unit;
	local v13 = v12.Player;
	local v14 = v12.Pet;
	local v15 = v12.Target;
	local v16 = v12.Focus;
	local v17 = v12.MouseOver;
	local v18 = v10.Spell;
	local v19 = v10.Item;
	local v20 = EpicLib;
	local v21 = v20.Bind;
	local v22 = v20.Macro;
	local v23 = v20.AoEON;
	local v24 = v20.CDsON;
	local v25 = v20.Cast;
	local v26 = v20.Press;
	local v27 = v20.Commons.Everyone.num;
	local v28 = v20.Commons.Everyone.bool;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32;
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
	local function v49()
		v32 = EpicSettings.Settings['UseRacials'];
		v34 = EpicSettings.Settings['UseHealingPotion'];
		v35 = EpicSettings.Settings['HealingPotionName'] or (0 - 0);
		v36 = EpicSettings.Settings['HealingPotionHP'] or (0 - 0);
		v37 = EpicSettings.Settings['UseHealthstone'];
		v38 = EpicSettings.Settings['HealthstoneHP'] or (505 - (351 + 154));
		v39 = EpicSettings.Settings['InterruptWithStun'] or (1574 - (1281 + 293));
		v40 = EpicSettings.Settings['InterruptOnlyWhitelist'] or (266 - (28 + 238));
		v41 = EpicSettings.Settings['InterruptThreshold'] or (0 - 0);
		v43 = EpicSettings.Settings['SummonPet'];
		v44 = EpicSettings.Settings['DarkPactHP'] or (1559 - (1381 + 178));
		v48 = EpicSettings.Settings['IgnoreHavoc'];
	end
	local v50 = v20.Commons.Everyone;
	local v51 = v18.Warlock.Destruction;
	local v52 = v19.Warlock.Destruction;
	local v53 = {};
	local v54 = v22.Warlock.Destruction;
	local v55, v56;
	local v57 = false;
	local v58 = false;
	local v59 = false;
	local v60 = 0 + 0;
	local v61 = 8960 + 2151;
	local v62 = 4740 + 6371;
	v10:RegisterForEvent(function()
		v57 = false;
		v58 = false;
		v59 = false;
		v60 = 0 - 0;
		v61 = 5757 + 5354;
		v62 = 11581 - (381 + 89);
	end, "PLAYER_REGEN_ENABLED");
	v51.SummonInfernal:RegisterInFlight();
	v51.ChaosBolt:RegisterInFlight();
	v51.Incinerate:RegisterInFlight();
	local function v63(v83)
		for v94 in pairs(v83) do
			local v95 = 0 + 0;
			local v96;
			while true do
				if ((v95 == (0 + 0)) or ((4685 - 1950) == (2465 - (1074 + 82)))) then
					v96 = v83[v94];
					if (v96:DebuffUp(v51.Havoc) or ((9050 - 4920) <= (4739 - (214 + 1570)))) then
						return true, v96:DebuffRemains(v51.Havoc);
					end
					break;
				end
			end
		end
		return false, 1455 - (990 + 465);
	end
	local function v64()
		return v10.GuardiansTable.InfernalDuration or (v51.SummonInfernal:InFlight() and (13 + 17)) or (0 + 0);
	end
	local function v65()
		return v10.GuardiansTable.BlasphemyDuration or (0 + 0);
	end
	local function v66(v84)
		return v84:DebuffRefreshable(v51.ImmolateDebuff) and (v84:DebuffRemains(v51.ImmolateDebuff) < v60) and (v13:SoulShardsP() < (15.5 - 11)) and (v84:DebuffDown(v51.HavocDebuff) or v84:DebuffDown(v51.ImmolateDebuff));
	end
	local function v67(v85)
		return ((v51.InternalCombustion:IsAvailable() and v85:DebuffRefreshable(v51.ImmolateDebuff)) or (v85:DebuffRemains(v51.ImmolateDebuff) < (1729 - (1668 + 58)))) and (not v51.Cataclysm:IsAvailable() or (v51.Cataclysm:CooldownRemains() > v85:DebuffRemains(v51.ImmolateDebuff))) and (not v51.SoulFire:IsAvailable() or ((v51.SoulFire:CooldownRemains() + (v27(not v51.Mayhem:IsAvailable()) * v51.SoulFire:CastTime())) > v85:DebuffRemains(v51.ImmolateDebuff)));
	end
	local function v68(v86)
		return (v86:DebuffRemains(v51.ImmolateDebuff) < (631 - (512 + 114))) and (not v51.Cataclysm:IsAvailable() or (v51.Cataclysm:CooldownRemains() > v86:DebuffRemains(v51.ImmolateDebuff))) and (not v51.RagingDemonfire:IsAvailable() or (v51.ChannelDemonfire:CooldownRemains() > v86:DebuffRemains(v51.ImmolateDebuff)));
	end
	local function v69()
		local v87 = 0 - 0;
		while true do
			if ((v87 == (1 - 0)) or ((6833 - 4869) <= (624 + 716))) then
				if (((468 + 2031) == (2173 + 326)) and v51.SoulFire:IsReady() and not v13:IsCasting(v51.SoulFire)) then
					if (v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true) or ((7606 - 5351) < (2016 - (109 + 1885)))) then
						return "soul_fire precombat 4";
					end
				end
				if (v51.Cataclysm:IsCastable() or ((2555 - (1269 + 200)) >= (2692 - 1287))) then
					if (v26(v51.Cataclysm, not v15:IsInRange(855 - (98 + 717)), true) or ((3195 - (802 + 24)) == (734 - 308))) then
						return "cataclysm precombat 6";
					end
				end
				v87 = 2 - 0;
			end
			if ((v87 == (1 + 1)) or ((2364 + 712) > (523 + 2660))) then
				if (((260 + 942) > (2943 - 1885)) and v51.Incinerate:IsCastable() and not v13:IsCasting(v51.Incinerate)) then
					if (((12375 - 8664) > (1200 + 2155)) and v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true)) then
						return "incinerate precombat 8";
					end
				end
				break;
			end
			if ((v87 == (0 + 0)) or ((748 + 158) >= (1621 + 608))) then
				v58 = false;
				if (((602 + 686) > (2684 - (797 + 636))) and v51.GrimoireofSacrifice:IsReady()) then
					if (v26(v51.GrimoireofSacrifice) or ((21912 - 17399) < (4971 - (1427 + 192)))) then
						return "grimoire_of_sacrifice precombat 2";
					end
				end
				v87 = 1 + 0;
			end
		end
	end
	local function v70()
		ShouldReturn = v50.HandleTopTrinket(OnUseExcludes, v31, 92 - 52, nil);
		if (ShouldReturn or ((1857 + 208) >= (1449 + 1747))) then
			return ShouldReturn;
		end
		ShouldReturn = v50.HandleBottomTrinket(OnUseExcludes, v31, 366 - (192 + 134), nil);
		if (ShouldReturn or ((5652 - (316 + 960)) <= (825 + 656))) then
			return ShouldReturn;
		end
	end
	local function v71()
		local v88 = 0 + 0;
		while true do
			if ((v88 == (0 + 0)) or ((12967 - 9575) >= (5292 - (83 + 468)))) then
				if (((5131 - (1202 + 604)) >= (10055 - 7901)) and v52.TimebreachingTalon:IsEquippedAndReady() and (v13:BuffUp(v51.DemonicPowerBuff) or (not v51.SummonDemonicTyrant:IsAvailable() and (v13:BuffUp(v51.NetherPortalBuff) or not v51.NetherPortal:IsAvailable())))) then
					if (v26(v54.TimebreachingTalon) or ((2154 - 859) >= (8951 - 5718))) then
						return "timebreaching_talon items 2";
					end
				end
				if (((4702 - (45 + 280)) > (1585 + 57)) and (not v51.SummonDemonicTyrant:IsAvailable() or v13:BuffUp(v51.DemonicPowerBuff))) then
					local v122 = 0 + 0;
					local v123;
					while true do
						if (((1725 + 2998) > (751 + 605)) and ((0 + 0) == v122)) then
							v123 = v70();
							if (v123 or ((7658 - 3522) <= (5344 - (340 + 1571)))) then
								return v123;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v72()
		if (((1675 + 2570) <= (6403 - (1733 + 39))) and ((v64() > (0 - 0)) or not v51.SummonInfernal:IsAvailable())) then
			local v98 = v50.HandleDPSPotion();
			if (((5310 - (125 + 909)) >= (5862 - (1096 + 852))) and v98) then
				return v98;
			end
			if (((89 + 109) <= (6233 - 1868)) and v51.Berserking:IsCastable() and (((v62 < (v51.SummonInfernal:CooldownRemains() + 12 + 0)) and (v62 > (524 - (409 + 103)))) or (v62 < v51.SummonInfernal:CooldownRemains()))) then
				if (((5018 - (46 + 190)) > (4771 - (51 + 44))) and v26(v51.Berserking, nil, nil, true)) then
					return "berserking cds 10";
				end
			end
			if (((1372 + 3492) > (3514 - (1114 + 203))) and v51.BloodFury:IsCastable() and (((v62 < (v51.SummonInfernal:CooldownRemains() + (736 - (228 + 498)) + 4 + 11)) and (v62 > (9 + 6))) or (v62 < v51.SummonInfernal:CooldownRemains()))) then
				if (v26(v51.BloodFury, nil, nil, true) or ((4363 - (174 + 489)) == (6531 - 4024))) then
					return "blood_fury cds 12";
				end
			end
			if (((6379 - (830 + 1075)) >= (798 - (303 + 221))) and v51.Fireblood:IsCastable() and (((v62 < (v51.SummonInfernal:CooldownRemains() + (1279 - (231 + 1038)) + 7 + 1)) and (v62 > (1170 - (171 + 991)))) or (v62 < v51.SummonInfernal:CooldownRemains()))) then
				if (v26(v51.Fireblood, nil, nil, true) or ((7805 - 5911) <= (3775 - 2369))) then
					return "fireblood cds 14";
				end
			end
		end
	end
	local function v73()
		local v89 = 0 - 0;
		while true do
			if (((1259 + 313) >= (5366 - 3835)) and (v89 == (2 - 1))) then
				if ((v51.ChannelDemonfire:IsCastable() and (v13:SoulShardsP() < (5.5 - 1)) and (v51.RagingDemonfire:TalentRank() == (6 - 4)) and (v56 > (1250 - (111 + 1137)))) or ((4845 - (91 + 67)) < (13518 - 8976))) then
					if (((822 + 2469) > (2190 - (423 + 100))) and v26(v51.ChannelDemonfire, not v15:IsInRange(1 + 39), true)) then
						return "channel_demonfire havoc 6";
					end
				end
				if (v51.Immolate:IsCastable() or ((2416 - 1543) == (1061 + 973))) then
					if (v50.CastCycle(v51.Immolate, v55, v66, not v15:IsSpellInRange(v51.Immolate), nil, nil, v54.ImmolateMouseover, true) or ((3587 - (326 + 445)) < (47 - 36))) then
						return "immolate havoc 8";
					end
				end
				v89 = 4 - 2;
			end
			if (((8633 - 4934) < (5417 - (530 + 181))) and (v89 == (884 - (614 + 267)))) then
				if (((2678 - (19 + 13)) >= (1425 - 549)) and v51.RainofFire:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v56 >= (((9 - 5) - v27(v51.Inferno:IsAvailable())) + v27(v51.MadnessoftheAzjAqir:IsAvailable())))) then
					if (((1753 - 1139) <= (827 + 2357)) and v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true)) then
						return "rain_of_fire havoc 12";
					end
				end
				if (((5497 - 2371) == (6482 - 3356)) and v51.RainofFire:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v56 > (1813 - (1293 + 519))) and (v51.AvatarofDestruction:IsAvailable() or (v51.RainofChaos:IsAvailable() and v13:BuffUp(v51.RainofChaosBuff))) and v51.Inferno:IsAvailable()) then
					if (v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true) or ((4461 - 2274) >= (12934 - 7980))) then
						return "rain_of_fire havoc 13";
					end
				end
				v89 = 7 - 3;
			end
			if (((17 - 13) == v89) or ((9133 - 5256) == (1894 + 1681))) then
				if (((145 + 562) > (1468 - 836)) and v51.Conflagrate:IsCastable() and not v51.Backdraft:IsAvailable()) then
					if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or ((127 + 419) >= (892 + 1792))) then
						return "conflagrate havoc 14";
					end
				end
				if (((916 + 549) <= (5397 - (709 + 387))) and v51.Incinerate:IsCastable() and (v51.Incinerate:CastTime() < v60)) then
					if (((3562 - (673 + 1185)) > (4132 - 2707)) and v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true)) then
						return "incinerate havoc 16";
					end
				end
				break;
			end
			if ((v89 == (6 - 4)) or ((1129 - 442) == (3029 + 1205))) then
				if ((v51.ChaosBolt:IsReady() and v51.CryHavoc:IsAvailable() and not v51.Inferno:IsAvailable() and (v51.ChaosBolt:CastTime() < v60)) or ((2489 + 841) < (1928 - 499))) then
					if (((282 + 865) >= (667 - 332)) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return "chaos_bolt havoc 9";
					end
				end
				if (((6742 - 3307) > (3977 - (446 + 1434))) and v51.ChaosBolt:IsReady() and (v51.ChaosBolt:CastTime() < v60) and (v56 < ((((1287 - (1040 + 243)) - v27(v51.Inferno:IsAvailable())) + v27(v51.MadnessoftheAzjAqir:IsAvailable())) - v27(v51.Inferno:IsAvailable() and (v51.RainofChaos:IsAvailable() or v51.AvatarofDestruction:IsAvailable()) and v13:BuffUp(v51.RainofChaosBuff))))) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or ((11252 - 7482) >= (5888 - (559 + 1288)))) then
						return "chaos_bolt havoc 10";
					end
				end
				v89 = 1934 - (609 + 1322);
			end
			if (((454 - (13 + 441)) == v89) or ((14166 - 10375) <= (4219 - 2608))) then
				if ((v51.Conflagrate:IsCastable() and v51.Backdraft:IsAvailable() and v13:BuffDown(v51.BackdraftBuff) and (v13:SoulShardsP() >= (4 - 3)) and (v13:SoulShardsP() <= (1 + 3))) or ((16626 - 12048) <= (714 + 1294))) then
					if (((493 + 632) <= (6160 - 4084)) and v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate))) then
						return "conflagrate havoc 2";
					end
				end
				if ((v51.SoulFire:IsCastable() and (v51.SoulFire:CastTime() < v60) and (v13:SoulShardsP() < (2.5 + 0))) or ((1365 - 622) >= (2909 + 1490))) then
					if (((643 + 512) < (1203 + 470)) and v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true)) then
						return "soul_fire havoc 4";
					end
				end
				v89 = 1 + 0;
			end
		end
	end
	local function v74()
		local v90 = 0 + 0;
		while true do
			if ((v90 == (433 - (153 + 280))) or ((6710 - 4386) <= (519 + 59))) then
				if (((1488 + 2279) == (1972 + 1795)) and v31 and v33) then
					local v124 = 0 + 0;
					local v125;
					while true do
						if (((2963 + 1126) == (6225 - 2136)) and (v124 == (0 + 0))) then
							v125 = v71();
							if (((5125 - (89 + 578)) >= (1196 + 478)) and v125) then
								return v125;
							end
							break;
						end
					end
				end
				if (((2020 - 1048) <= (2467 - (572 + 477))) and v31) then
					local v126 = v72();
					if (v126 or ((666 + 4272) < (2858 + 1904))) then
						return v126;
					end
				end
				if ((v59 and (v60 > v13:GCD())) or ((299 + 2205) > (4350 - (84 + 2)))) then
					local v127 = 0 - 0;
					local v128;
					while true do
						if (((1552 + 601) == (2995 - (497 + 345))) and (v127 == (0 + 0))) then
							v128 = v73();
							if (v128 or ((86 + 421) >= (3924 - (605 + 728)))) then
								return v128;
							end
							break;
						end
					end
				end
				v57 = (v51.Havoc:CooldownRemains() <= (8 + 2)) or v51.Mayhem:IsAvailable();
				v90 = 1 - 0;
			end
			if (((206 + 4275) == (16567 - 12086)) and (v90 == (2 + 0))) then
				if ((v51.SoulFire:IsCastable() and (v13:SoulShardsP() <= (7.5 - 4)) and ((v15:DebuffRemains(v51.RoaringBlazeDebuff) > (v51.SoulFire:CastTime() + v51.SoulFire:TravelTime())) or (not v51.RoaringBlaze:IsAvailable() and v13:BuffUp(v51.BackdraftBuff))) and not v57) or ((1758 + 570) < (1182 - (457 + 32)))) then
					if (((1837 + 2491) == (5730 - (832 + 570))) and v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true)) then
						return "soul_fire cleave 10";
					end
				end
				if (((1497 + 91) >= (348 + 984)) and v51.Immolate:IsCastable()) then
					if (v50.CastCycle(v51.Immolate, v55, v67, not v15:IsSpellInRange(v51.Immolate), nil, nil, v54.ImmolateMouseover, true) or ((14770 - 10596) > (2047 + 2201))) then
						return "immolate cleave 12";
					end
				end
				if ((v51.Havoc:IsCastable() and (v51.SummonInfernal:CooldownDown() or not v51.SummonInfernal:IsAvailable())) or ((5382 - (588 + 208)) <= (220 - 138))) then
					local v129 = v15:GUID();
					for v130, v131 in pairs(v55) do
						if (((5663 - (884 + 916)) == (8087 - 4224)) and (v131:GUID() ~= v129) and v17 and v17:Exists() and (v131:GUID() == v17:GUID()) and not v131:IsFacingBlacklisted() and not v131:IsUserCycleBlacklisted()) then
							if (v26(v54.HavocMouseover) or ((164 + 118) <= (695 - (232 + 421)))) then
								return "havoc cleave 14";
							end
						end
					end
				end
				if (((6498 - (1569 + 320)) >= (188 + 578)) and v51.ChaosBolt:IsReady() and ((v64() > (0 + 0)) or (v65() > (0 - 0)) or (v13:SoulShardsP() >= (609 - (316 + 289))))) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or ((3015 - 1863) == (115 + 2373))) then
						return "chaos_bolt cleave 16";
					end
				end
				v90 = 1456 - (666 + 787);
			end
			if (((3847 - (360 + 65)) > (3131 + 219)) and (v90 == (258 - (79 + 175)))) then
				if (((1382 - 505) > (294 + 82)) and v51.ChaosBolt:IsReady() and (v13:BuffRemains(v51.RainofChaosBuff) > v51.ChaosBolt:CastTime())) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or ((9557 - 6439) <= (3564 - 1713))) then
						return "chaos_bolt cleave 24";
					end
				end
				if ((v51.ChaosBolt:IsReady() and v13:BuffUp(v51.BackdraftBuff) and not v57) or ((1064 - (503 + 396)) >= (3673 - (92 + 89)))) then
					if (((7660 - 3711) < (2491 + 2365)) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return "chaos_bolt cleave 26";
					end
				end
				if ((v51.ChaosBolt:IsReady() and v51.Eradication:IsAvailable() and not v57 and (v15:DebuffRemains(v51.EradicationDebuff) < v51.ChaosBolt:CastTime()) and not v51.ChaosBolt:InFlight()) or ((2531 + 1745) < (11810 - 8794))) then
					if (((642 + 4048) > (9405 - 5280)) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return "chaos_bolt cleave 28";
					end
				end
				if ((v51.ChaosBolt:IsReady() and (v13:BuffUp(v51.MadnessCBBuff))) or ((44 + 6) >= (428 + 468))) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or ((5220 - 3506) >= (370 + 2588))) then
						return "chaos_bolt cleave 30";
					end
				end
				v90 = 7 - 2;
			end
			if (((1247 - (485 + 759)) == v90) or ((3449 - 1958) < (1833 - (442 + 747)))) then
				if (((1839 - (832 + 303)) < (1933 - (88 + 858))) and v31 and v51.SummonInfernal:IsCastable() and v17 and v17:Exists() and (v17:GUID() == v15:GUID())) then
					if (((1134 + 2584) > (1578 + 328)) and v26(v54.SummonInfernalCursor)) then
						return "summon_infernal cleave 18";
					end
				end
				if ((v51.ChannelDemonfire:IsCastable() and (v51.Ruin:TalentRank() > (1 + 0)) and not (v51.DiabolicEmbers:IsAvailable() and v51.AvatarofDestruction:IsAvailable() and (v51.BurntoAshes:IsAvailable() or v51.ChaosIncarnate:IsAvailable()))) or ((1747 - (766 + 23)) > (17945 - 14310))) then
					if (((4787 - 1286) <= (11834 - 7342)) and v26(v51.ChannelDemonfire, not v15:IsInRange(135 - 95), true)) then
						return "channel_demonfire cleave 20";
					end
				end
				if ((v51.Conflagrate:IsCastable() and v13:BuffDown(v51.BackdraftBuff) and (v13:SoulShardsP() >= (1074.5 - (1036 + 37))) and not v57) or ((2441 + 1001) < (4961 - 2413))) then
					if (((2262 + 613) >= (2944 - (641 + 839))) and v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate))) then
						return "conflagrate cleave 22";
					end
				end
				if ((v51.Incinerate:IsCastable() and v13:BuffUp(v51.BurntoAshesBuff) and ((v51.Incinerate:CastTime() + v51.ChaosBolt:CastTime()) < v13:BuffRemains(v51.MadnessCBBuff))) or ((5710 - (910 + 3)) >= (12473 - 7580))) then
					if (v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true) or ((2235 - (1466 + 218)) > (951 + 1117))) then
						return "incinerate cleave 23";
					end
				end
				v90 = 1152 - (556 + 592);
			end
			if (((752 + 1362) > (1752 - (329 + 479))) and ((855 - (174 + 680)) == v90)) then
				if ((v51.Conflagrate:IsCastable() and ((v51.RoaringBlaze:IsAvailable() and (v15:DebuffRemains(v51.RoaringBlazeDebuff) < (3.5 - 2))) or (v51.Conflagrate:Charges() == v51.Conflagrate:MaxCharges()))) or ((4688 - 2426) >= (2211 + 885))) then
					if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or ((2994 - (396 + 343)) >= (313 + 3224))) then
						return "conflagrate cleave 2";
					end
				end
				if ((v31 and v51.DimensionalRift:IsCastable() and (v13:SoulShardsP() < (1481.7 - (29 + 1448))) and ((v51.DimensionalRift:Charges() > (1391 - (135 + 1254))) or (v62 < v51.DimensionalRift:Cooldown()))) or ((14454 - 10617) < (6097 - 4791))) then
					if (((1966 + 984) == (4477 - (389 + 1138))) and v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift))) then
						return "dimensional_rift cleave 4";
					end
				end
				if ((v31 and v51.Cataclysm:IsCastable()) or ((5297 - (102 + 472)) < (3113 + 185))) then
					if (((630 + 506) >= (144 + 10)) and v26(v51.Cataclysm, not v15:IsSpellInRange(v51.Cataclysm))) then
						return "cataclysm cleave 6";
					end
				end
				if ((v51.ChannelDemonfire:IsCastable() and (v51.RagingDemonfire:IsAvailable())) or ((1816 - (320 + 1225)) > (8452 - 3704))) then
					if (((2901 + 1839) >= (4616 - (157 + 1307))) and v26(v51.ChannelDemonfire, not v15:IsInRange(1899 - (821 + 1038)), true)) then
						return "channel_demonfire cleave 8";
					end
				end
				v90 = 4 - 2;
			end
			if ((v90 == (1 + 5)) or ((4578 - 2000) >= (1262 + 2128))) then
				if (((101 - 60) <= (2687 - (834 + 192))) and v51.ChaosBolt:IsReady() and not v57 and ((v51.SoulConduit:IsAvailable() and not v51.MadnessoftheAzjAqir:IsAvailable()) or not v51.Backdraft:IsAvailable())) then
					if (((39 + 562) < (914 + 2646)) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return "chaos_bolt cleave 40";
					end
				end
				if (((6 + 229) < (1063 - 376)) and v51.ChaosBolt:IsReady() and (v62 < (309.5 - (300 + 4))) and (v62 > (v51.ChaosBolt:CastTime() + v51.ChaosBolt:TravelTime() + 0.5 + 0))) then
					if (((11908 - 7359) > (1515 - (112 + 250))) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return "chaos_bolt cleave 42";
					end
				end
				if ((v51.Conflagrate:IsCastable() and ((v51.Conflagrate:Charges() > (v51.Conflagrate:MaxCharges() - (1 + 0))) or (v62 < (v13:GCD() * v51.Conflagrate:Charges())))) or ((11709 - 7035) < (2677 + 1995))) then
					if (((1897 + 1771) < (3412 + 1149)) and v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate))) then
						return "conflagrate cleave 44";
					end
				end
				if (v51.Incinerate:IsCastable() or ((226 + 229) == (2679 + 926))) then
					if (v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true) or ((4077 - (1001 + 413)) == (7385 - 4073))) then
						return "incinerate cleave 46";
					end
				end
				break;
			end
			if (((5159 - (244 + 638)) <= (5168 - (627 + 66))) and (v90 == (14 - 9))) then
				if ((v51.SoulFire:IsCastable() and (v13:SoulShardsP() <= (606 - (512 + 90))) and v51.Mayhem:IsAvailable()) or ((2776 - (1665 + 241)) == (1906 - (373 + 344)))) then
					if (((701 + 852) <= (829 + 2304)) and v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true)) then
						return "soul_fire cleave 32";
					end
				end
				if ((v51.ChannelDemonfire:IsCastable() and not (v51.DiabolicEmbers:IsAvailable() and v51.AvatarofDestruction:IsAvailable() and (v51.BurntoAshes:IsAvailable() or v51.ChaosIncarnate:IsAvailable()))) or ((5900 - 3663) >= (5941 - 2430))) then
					if (v26(v51.ChannelDemonfire, not v15:IsInRange(1139 - (35 + 1064)), true) or ((964 + 360) > (6461 - 3441))) then
						return "channel_demonfire cleave 34";
					end
				end
				if ((v31 and v51.DimensionalRift:IsCastable()) or ((12 + 2980) == (3117 - (298 + 938)))) then
					if (((4365 - (233 + 1026)) > (3192 - (636 + 1030))) and v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift))) then
						return "dimensional_rift cleave 36";
					end
				end
				if (((1546 + 1477) < (3781 + 89)) and v51.ChaosBolt:IsReady() and (v13:SoulShardsP() > (1.5 + 2))) then
					if (((10 + 133) > (295 - (55 + 166))) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return "chaos_bolt cleave 38";
					end
				end
				v90 = 2 + 4;
			end
		end
	end
	local function v75()
		if (((2 + 16) < (8065 - 5953)) and v31) then
			local v99 = 297 - (36 + 261);
			local v100;
			while true do
				if (((1918 - 821) <= (2996 - (34 + 1334))) and (v99 == (0 + 0))) then
					v100 = v72();
					if (((3598 + 1032) == (5913 - (1035 + 248))) and v100) then
						return v100;
					end
					break;
				end
			end
		end
		if (((3561 - (20 + 1)) > (1398 + 1285)) and v31 and v33) then
			local v101 = 319 - (134 + 185);
			local v102;
			while true do
				if (((5927 - (549 + 584)) >= (3960 - (314 + 371))) and (v101 == (0 - 0))) then
					v102 = v71();
					if (((2452 - (478 + 490)) == (787 + 697)) and v102) then
						return v102;
					end
					break;
				end
			end
		end
		if (((2604 - (786 + 386)) < (11514 - 7959)) and v59 and (v60 > v13:GCD()) and (v56 < ((1384 - (1055 + 324)) + v27(v51.CryHavoc:IsAvailable() and not v51.Inferno:IsAvailable())))) then
			local v103 = 1340 - (1093 + 247);
			local v104;
			while true do
				if ((v103 == (0 + 0)) or ((112 + 953) > (14205 - 10627))) then
					v104 = v73();
					if (v104 or ((16273 - 11478) < (4003 - 2596))) then
						return v104;
					end
					break;
				end
			end
		end
		if (((4656 - 2803) < (1713 + 3100)) and v51.RainofFire:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v64() > (0 - 0))) then
			if (v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true) or ((9723 - 6902) < (1834 + 597))) then
				return "rain_of_fire aoe 2";
			end
		end
		if ((v51.RainofFire:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v51.AvatarofDestruction:IsAvailable())) or ((7349 - 4475) < (2869 - (364 + 324)))) then
			if (v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true) or ((7371 - 4682) <= (822 - 479))) then
				return "rain_of_fire aoe 4";
			end
		end
		if ((v51.RainofFire:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v13:SoulShardsP() == (2 + 3))) or ((7820 - 5951) == (3216 - 1207))) then
			if (v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true) or ((10769 - 7223) < (3590 - (1249 + 19)))) then
				return "rain_of_fire aoe 6";
			end
		end
		if ((v51.ChaosBolt:IsReady() and (v13:SoulShardsP() > ((3.5 + 0) - ((0.1 - 0) * v56))) and not v51.RainofFire:IsAvailable()) or ((3168 - (686 + 400)) == (3745 + 1028))) then
			if (((3473 - (73 + 156)) > (5 + 1050)) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
				return "chaos_bolt aoe 8";
			end
		end
		if ((v31 and v51.Cataclysm:IsCastable()) or ((4124 - (721 + 90)) <= (20 + 1758))) then
			if (v26(v51.Cataclysm, not v15:IsSpellInRange(v51.Cataclysm)) or ((4613 - 3192) >= (2574 - (224 + 246)))) then
				return "cataclysm aoe 10";
			end
		end
		if (((2935 - 1123) <= (5981 - 2732)) and v51.ChannelDemonfire:IsCastable() and (v15:DebuffRemains(v51.ImmolateDebuff) > v51.ChannelDemonfire:CastTime()) and v51.RagingDemonfire:IsAvailable()) then
			if (((295 + 1328) <= (47 + 1910)) and v26(v51.ChannelDemonfire, not v15:IsInRange(30 + 10), true)) then
				return "channel_demonfire aoe 12";
			end
		end
		if (((8771 - 4359) == (14682 - 10270)) and v51.Immolate:IsCastable() and (v51.ImmolateDebuff:AuraActiveCount() <= (519 - (203 + 310)))) then
			if (((3743 - (1238 + 755)) >= (59 + 783)) and v50.CastCycle(v51.Immolate, v55, v68, not v15:IsSpellInRange(v51.Immolate), nil, nil, v54.ImmolateMouseover, true)) then
				return "immolate aoe 10";
			end
		end
		if (((5906 - (709 + 825)) > (3409 - 1559)) and v51.Havoc:IsCastable() and not v51.RainofFire:IsAvailable()) then
			local v105 = v15:GUID();
			for v110, v111 in pairs(v55) do
				if (((337 - 105) < (1685 - (196 + 668))) and (v111:GUID() ~= v105) and v17 and v17:Exists() and (v111:GUID() == v17:GUID()) and not v111:IsFacingBlacklisted() and not v111:IsUserCycleBlacklisted()) then
					if (((2045 - 1527) < (1868 - 966)) and v26(v54.HavocMouseover)) then
						return "havoc cleave 14";
					end
				end
			end
		end
		if (((3827 - (171 + 662)) > (951 - (4 + 89))) and v51.SummonSoulkeeper:IsCastable() and ((v51.SummonSoulkeeper:Count() == (35 - 25)) or ((v51.SummonSoulkeeper:Count() > (2 + 1)) and (v62 < (43 - 33))))) then
			if (v26(v51.SummonSoulkeeper) or ((1473 + 2282) <= (2401 - (35 + 1451)))) then
				return "summon_soulkeeper aoe 12";
			end
		end
		if (((5399 - (28 + 1425)) > (5736 - (941 + 1052))) and v31) then
			local v106 = v72();
			if (v106 or ((1281 + 54) >= (4820 - (822 + 692)))) then
				return v106;
			end
		end
		if (((6915 - 2071) > (1062 + 1191)) and v31 and v51.SummonInfernal:IsCastable() and v17 and v17:Exists() and (v17:GUID() == v15:GUID())) then
			if (((749 - (45 + 252)) == (448 + 4)) and v26(v54.SummonInfernalCursor)) then
				return "summon_infernal aoe 14";
			end
		end
		if ((v51.RainofFire:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID())) or ((1569 + 2988) < (5078 - 2991))) then
			if (((4307 - (114 + 319)) == (5562 - 1688)) and v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate))) then
				return "rain_of_fire aoe 16";
			end
		end
		if (v51.Havoc:IsCastable() or ((2482 - 544) > (3146 + 1789))) then
			local v107 = v15:GUID();
			for v112, v113 in pairs(v55) do
				if (((v113:GUID() ~= v107) and v17 and v17:Exists() and (v113:GUID() == v17:GUID()) and not v113:IsFacingBlacklisted() and not v113:IsUserCycleBlacklisted()) or ((6339 - 2084) < (7171 - 3748))) then
					if (((3417 - (556 + 1407)) <= (3697 - (741 + 465))) and v26(v54.HavocMouseover)) then
						return "havoc cleave 14";
					end
				end
			end
		end
		if ((v51.ChannelDemonfire:IsReady() and (v15:DebuffRemains(v51.ImmolateDebuff) > v51.ChannelDemonfire:CastTime())) or ((4622 - (170 + 295)) <= (1477 + 1326))) then
			if (((4458 + 395) >= (7341 - 4359)) and v26(v51.ChannelDemonfire, not v15:IsSpellInRange(v51.ChannelDemonfire), true)) then
				return "channel_demonfire aoe 17";
			end
		end
		if (((3427 + 707) > (2153 + 1204)) and v51.Immolate:IsCastable()) then
			if (v50.CastCycle(v51.Immolate, v55, v68, not v15:IsSpellInRange(v51.Immolate), nil, nil, v54.ImmolateMouseover, true) or ((1935 + 1482) < (3764 - (957 + 273)))) then
				return "immolate aoe 18";
			end
		end
		if ((v51.SoulFire:IsCastable() and (v13:BuffUp(v51.BackdraftBuff))) or ((729 + 1993) <= (66 + 98))) then
			if (v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true) or ((9175 - 6767) < (5557 - 3448))) then
				return "soul_fire aoe 20";
			end
		end
		if ((v51.Incinerate:IsCastable() and v51.FireandBrimstone:IsAvailable() and v13:BuffUp(v51.Backdraft)) or ((100 - 67) == (7204 - 5749))) then
			if (v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true) or ((2223 - (389 + 1391)) >= (2519 + 1496))) then
				return "incinerate aoe 22";
			end
		end
		if (((353 + 3029) > (377 - 211)) and v51.Conflagrate:IsCastable() and (v13:BuffDown(v51.Backdraft) or not v51.Backdraft:IsAvailable())) then
			if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or ((1231 - (783 + 168)) == (10266 - 7207))) then
				return "conflagrate aoe 24";
			end
		end
		if (((1851 + 30) > (1604 - (309 + 2))) and v31 and v51.DimensionalRift:IsCastable()) then
			if (((7237 - 4880) == (3569 - (1090 + 122))) and v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift))) then
				return "dimensional_rift aoe 26";
			end
		end
		if (((40 + 83) == (412 - 289)) and v51.Immolate:IsCastable() and (v15:DebuffRefreshable(v51.ImmolateDebuff))) then
			if (v26(v54.ImmolatePetAttack, not v15:IsSpellInRange(v51.Immolate), true) or ((723 + 333) >= (4510 - (628 + 490)))) then
				return "immolate aoe 28";
			end
		end
		if (v51.Incinerate:IsCastable() or ((194 + 887) < (2661 - 1586))) then
			if (v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true) or ((4793 - 3744) >= (5206 - (431 + 343)))) then
				return "incinerate aoe 30";
			end
		end
	end
	local function v76()
		v49();
		v29 = EpicSettings.Toggles['ooc'];
		v30 = EpicSettings.Toggles['aoe'];
		v31 = EpicSettings.Toggles['cds'];
		v55 = v13:GetEnemiesInRange(80 - 40);
		Enemies8ySplash = v15:GetEnemiesInSplashRange(34 - 22);
		if (v30 or ((3767 + 1001) <= (109 + 737))) then
			v56 = #Enemies8ySplash;
		else
			v56 = 1696 - (556 + 1139);
		end
		v59, v60 = v63(v55);
		if (v50.TargetIsValid() or v13:AffectingCombat() or ((3373 - (6 + 9)) <= (260 + 1160))) then
			local v108 = 0 + 0;
			while true do
				if ((v108 == (169 - (28 + 141))) or ((1449 + 2290) <= (3709 - 704))) then
					v61 = v10.BossFightRemains(nil, true);
					v62 = v61;
					v108 = 1 + 0;
				end
				if (((1318 - (486 + 831)) == v108) or ((4316 - 2657) >= (7512 - 5378))) then
					if ((v62 == (2100 + 9011)) or ((10308 - 7048) < (3618 - (668 + 595)))) then
						v62 = v10.FightRemains(Enemies8ySplash, false);
					end
					break;
				end
			end
		end
		if (v50.TargetIsValid() or ((602 + 67) == (852 + 3371))) then
			if ((not v13:AffectingCombat() and v29) or ((4614 - 2922) < (878 - (23 + 267)))) then
				local v115 = v69();
				if (v115 or ((6741 - (1129 + 815)) < (4038 - (371 + 16)))) then
					return v115;
				end
			end
			if (((v56 > (1751 - (1326 + 424))) and (v56 <= ((3 - 1) + v27(not v51.Inferno:IsAvailable() and v51.MadnessoftheAzjAqir:IsAvailable() and v51.AshenRemains:IsAvailable())))) or v58 or ((15263 - 11086) > (4968 - (88 + 30)))) then
				local v116 = 771 - (720 + 51);
				local v117;
				while true do
					if ((v116 == (0 - 0)) or ((2176 - (421 + 1355)) > (1832 - 721))) then
						v117 = v74();
						if (((1499 + 1552) > (2088 - (286 + 797))) and v117) then
							return v117;
						end
						break;
					end
				end
			end
			if (((13500 - 9807) <= (7257 - 2875)) and (v56 >= (442 - (397 + 42)))) then
				local v118 = 0 + 0;
				local v119;
				while true do
					if ((v118 == (800 - (24 + 776))) or ((5055 - 1773) > (4885 - (222 + 563)))) then
						v119 = v75();
						if (v119 or ((7887 - 4307) < (2048 + 796))) then
							return v119;
						end
						break;
					end
				end
			end
			local v109 = v71();
			if (((279 - (23 + 167)) < (6288 - (690 + 1108))) and v109) then
				return v109;
			end
			if (v31 or ((1798 + 3185) < (1492 + 316))) then
				local v120 = 848 - (40 + 808);
				local v121;
				while true do
					if (((631 + 3198) > (14412 - 10643)) and (v120 == (0 + 0))) then
						v121 = v72();
						if (((786 + 699) <= (1593 + 1311)) and v121) then
							return v121;
						end
						break;
					end
				end
			end
			if (((4840 - (47 + 524)) == (2771 + 1498)) and v51.Conflagrate:IsReady() and ((v51.RoaringBlaze:IsAvailable() and (v15:DebuffRemains(v51.RoaringBlazeDebuff) < (2.5 - 1))) or (v51.Conflagrate:Charges() == v51.Conflagrate:MaxCharges()))) then
				if (((577 - 190) <= (6344 - 3562)) and v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate))) then
					return "conflagrate main 2";
				end
			end
			if ((v31 and v51.DimensionalRift:IsCastable() and (v13:SoulShardsP() < (1730.7 - (1165 + 561))) and ((v51.DimensionalRift:Charges() > (1 + 1)) or (v62 < v51.DimensionalRift:Cooldown()))) or ((5881 - 3982) <= (350 + 567))) then
				if (v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift)) or ((4791 - (341 + 138)) <= (237 + 639))) then
					return "dimensional_rift main 4";
				end
			end
			if (((4606 - 2374) <= (2922 - (89 + 237))) and v31 and v51.Cataclysm:IsReady()) then
				if (((6739 - 4644) < (7760 - 4074)) and v26(v51.Cataclysm, not v15:IsInRange(921 - (581 + 300)))) then
					return "cataclysm main 6";
				end
			end
			if ((v51.ChannelDemonfire:IsReady() and v51.RagingDemonfire:IsAvailable()) or ((2815 - (855 + 365)) >= (10626 - 6152))) then
				if (v26(v51.ChannelDemonfire, not v15:IsInRange(14 + 26), true) or ((5854 - (1030 + 205)) < (2706 + 176))) then
					return "channel_demonfire main 7";
				end
			end
			if ((v51.SoulFire:IsCastable() and (v13:SoulShardsP() <= (3.5 + 0)) and ((v15:DebuffRemains(v51.RoaringBlazeDebuff) > (v51.SoulFire:CastTime() + v51.SoulFire:TravelTime())) or (not v51.RoaringBlaze:IsAvailable() and v13:BuffUp(v51.BackdraftBuff)))) or ((580 - (156 + 130)) >= (10976 - 6145))) then
				if (((3419 - 1390) <= (6315 - 3231)) and v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true)) then
					return "soul_fire main 8";
				end
			end
			if ((v51.Immolate:IsCastable() and ((v15:DebuffRefreshable(v51.ImmolateDebuff) and v51.InternalCombustion:IsAvailable()) or (v15:DebuffRemains(v51.ImmolateDebuff) < (1 + 2))) and (not v51.Cataclysm:IsAvailable() or (v51.Cataclysm:CooldownRemains() > v15:DebuffRemains(v51.ImmolateDebuff))) and (not v51.SoulFire:IsAvailable() or ((v51.SoulFire:CooldownRemains() + v51.SoulFire:CastTime()) > v15:DebuffRemains(v51.ImmolateDebuff)))) or ((1188 + 849) == (2489 - (10 + 59)))) then
				if (((1261 + 3197) > (19226 - 15322)) and v26(v54.ImmolatePetAttack, not v15:IsSpellInRange(v51.Immolate), true)) then
					return "immolate main 10";
				end
			end
			if (((1599 - (671 + 492)) >= (98 + 25)) and v51.Havoc:IsCastable() and not v48 and v51.CryHavoc:IsAvailable() and (v13:BuffUp(v51.RitualofRuinBuff) or ((v64() > (1215 - (369 + 846))) and v51.BurntoAshes:IsAvailable()) or ((v13:BuffUp(v51.RitualofRuinBuff) or (v64() > (0 + 0))) and not v51.BurntoAshes:IsAvailable()))) then
				if (((427 + 73) < (3761 - (1036 + 909))) and v26(v51.Havoc, not v15:IsSpellInRange(v51.Havoc))) then
					return "havoc (st) main 11";
				end
			end
			if (((2842 + 732) == (5999 - 2425)) and v51.ChaosBolt:IsReady() and ((v64() > (203 - (11 + 192))) or (v65() > (0 + 0)) or (v13:SoulShardsP() >= (179 - (135 + 40))))) then
				if (((535 - 314) < (236 + 154)) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
					return "chaos_bolt main 12";
				end
			end
			if ((v31 and v51.SummonInfernal:IsCastable() and v17 and v17:Exists() and (v17:GUID() == v15:GUID())) or ((4874 - 2661) <= (2129 - 708))) then
				if (((3234 - (50 + 126)) < (13532 - 8672)) and v26(v54.SummonInfernalCursor)) then
					return "summon_infernal main 14";
				end
			end
			if ((v51.ChannelDemonfire:IsCastable() and (v51.Ruin:TalentRank() > (1 + 0)) and not (v51.DiabolicEmbers:IsAvailable() and v51.AvatarofDestruction:IsAvailable() and (v51.BurntoAshes:IsAvailable() or v51.ChaosIncarnate:IsAvailable())) and (v15:DebuffRemains(v51.ImmolateDebuff) > v51.ChannelDemonfire:CastTime())) or ((2709 - (1233 + 180)) >= (5415 - (522 + 447)))) then
				if (v26(v51.ChannelDemonfire, not v15:IsInRange(1461 - (107 + 1314)), true) or ((647 + 746) > (13678 - 9189))) then
					return "channel_demonfire main 16";
				end
			end
			if ((v51.Conflagrate:IsCastable() and v13:BuffDown(v51.Backdraft) and (v13:SoulShardsP() >= (1.5 + 0)) and not v51.RoaringBlaze:IsAvailable()) or ((8784 - 4360) < (106 - 79))) then
				if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or ((3907 - (716 + 1194)) > (66 + 3749))) then
					return "conflagrate main 28";
				end
			end
			if (((372 + 3093) > (2416 - (74 + 429))) and v51.Incinerate:IsCastable() and v13:BuffUp(v51.BurntoAshesBuff) and ((v51.Incinerate:CastTime() + v51.ChaosBolt:CastTime()) < v13:BuffRemains(v51.MadnessCBBuff))) then
				if (((1413 - 680) < (902 + 917)) and v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true)) then
					return "incinerate aoe 29";
				end
			end
			if ((v51.ChaosBolt:IsReady() and (v13:BuffRemains(v51.RainofChaosBuff) > v51.ChaosBolt:CastTime())) or ((10060 - 5665) == (3365 + 1390))) then
				if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or ((11693 - 7900) < (5857 - 3488))) then
					return "chaos_bolt main 30";
				end
			end
			if ((v51.ChaosBolt:IsReady() and v13:BuffUp(v51.Backdraft) and not v51.Eradication:IsAvailable() and not v51.MadnessoftheAzjAqir:IsAvailable()) or ((4517 - (279 + 154)) == (1043 - (454 + 324)))) then
				if (((3429 + 929) == (4375 - (12 + 5))) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
					return "chaos_bolt main 32";
				end
			end
			if ((v51.ChaosBolt:IsReady() and (v13:BuffUp(v51.MadnessCBBuff))) or ((1692 + 1446) < (2529 - 1536))) then
				if (((1231 + 2099) > (3416 - (277 + 816))) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
					return "chaos_bolt cleave 36";
				end
			end
			if ((v51.ChannelDemonfire:IsCastable() and not (v51.DiabolicEmbers:IsAvailable() and v51.AvatarofDestruction:IsAvailable() and (v51.BurntoAshes:IsAvailable() or v51.ChaosIncarnate:IsAvailable())) and (v15:DebuffRemains(v51.ImmolateDebuff) > v51.ChannelDemonfire:CastTime())) or ((15494 - 11868) == (5172 - (1058 + 125)))) then
				if (v26(v51.ChannelDemonfire, not v15:IsInRange(8 + 32), true) or ((1891 - (815 + 160)) == (11460 - 8789))) then
					return "channel_demonfire cleave 38";
				end
			end
			if (((645 - 373) == (65 + 207)) and v31 and v51.DimensionalRift:IsCastable()) then
				if (((12420 - 8171) <= (6737 - (41 + 1857))) and v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift))) then
					return "dimensional_rift cleave 40";
				end
			end
			if (((4670 - (1222 + 671)) < (8270 - 5070)) and v51.ChaosBolt:IsReady() and (v13:SoulShardsP() >= (3.5 - 0))) then
				if (((1277 - (229 + 953)) < (3731 - (1111 + 663))) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
					return "chaos_bolt main 42";
				end
			end
			if (((2405 - (874 + 705)) < (241 + 1476)) and v51.ChaosBolt:IsReady() and ((v51.SoulConduit:IsAvailable() and not v51.MadnessoftheAzjAqir:IsAvailable()) or not v51.Backdraft:IsAvailable())) then
				if (((973 + 453) >= (2296 - 1191)) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
					return "chaos_bolt main 44";
				end
			end
			if (((78 + 2676) <= (4058 - (642 + 37))) and v51.ChaosBolt:IsReady() and (v62 < (2.5 + 3)) and (v62 > (v51.ChaosBolt:CastTime() + v51.ChaosBolt:TravelTime() + 0.5 + 0))) then
				if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or ((9859 - 5932) == (1867 - (233 + 221)))) then
					return "chaos_bolt main 46";
				end
			end
			if ((v51.Conflagrate:IsCastable() and ((v51.Conflagrate:Charges() > (v51.Conflagrate:MaxCharges() - (2 - 1))) or (v62 < (v13:GCD() + 0.5 + 0)))) or ((2695 - (718 + 823)) <= (496 + 292))) then
				if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or ((2448 - (266 + 539)) > (9566 - 6187))) then
					return "conflagrate main 48";
				end
			end
			if (v51.Incinerate:IsCastable() or ((4028 - (636 + 589)) > (10797 - 6248))) then
				if (v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true) or ((453 - 233) >= (2395 + 627))) then
					return "incinerate main 50";
				end
			end
		end
	end
	local function v77()
		v51.ImmolateDebuff:RegisterAuraTracking();
		v20.Print("Destruction Warlock rotation by Epic. Supported by Gojira");
	end
	v20.SetAPL(98 + 169, v76, v77);
end;
return v0["Epix_Warlock_Destruction.lua"]();

