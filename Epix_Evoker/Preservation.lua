local obf_stringchar = string.char;
local obf_stringbyte = string.byte;
local obf_stringsub = string.sub;
local obf_bitlib = bit32 or bit;
local obf_XOR = obf_bitlib.bxor;
local obf_tableconcat = table.concat;
local obf_tableinsert = table.insert;
local function LUAOBFUSACTOR_DECRYPT_STR_0(LUAOBFUSACTOR_STR, LUAOBFUSACTOR_KEY)
	local result = {};
	for i = 1, #LUAOBFUSACTOR_STR do
		obf_tableinsert(result, obf_stringchar(obf_XOR(obf_stringbyte(obf_stringsub(LUAOBFUSACTOR_STR, i, i + 1)), obf_stringbyte(obf_stringsub(LUAOBFUSACTOR_KEY, 1 + (i % #LUAOBFUSACTOR_KEY), 1 + (i % #LUAOBFUSACTOR_KEY) + 1))) % 256));
	end
	return obf_tableconcat(result);
end
local v0 = {};
local v1 = require;
local function v2(v4, ...)
	local v5 = 0;
	local v6;
	while true do
		if ((4541 <= 4682) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (3026 >= 4046)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((2008 > 638) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\158\209\17\218\198\201\26\214\169\194\13\212\209\205\36\242\178\200\16\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\163\64\26\175", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\24\43\6", "\158\48\118\66\114")];
	local v14 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\218\88\164\83\239", "\38\156\55\199")];
	local v17 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\133\114\105\59\22\91\236\70\186", "\35\200\29\28\72\115\20\154")];
	local v18 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\41\186\197", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\136\70\204\172\54", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\96\86\5\40", "\69\41\34\96")];
	local v21 = EpicLib;
	local v22 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\33\187\152\35\233\13\181\135\62\215\5", "\185\98\218\235\87")];
	local v24 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\232\61\52\242\255\164\197\51\51\231\202\175\207", "\202\171\92\71\134\190")];
	local v25 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\10\192\63\156\26\212\43\143\44\210\56\141\45", "\232\73\161\76")];
	local v26 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\139\203\71\78\13", "\126\219\185\34\61")];
	local v27 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\33\207\93\96\113", "\135\108\174\62\18\30\23\147")];
	local v28 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")];
	local v29 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\36\25\180\38\8\24\170", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\66\117\6\160\17\201\81", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\59\45", "\156\168\78\64\224\212\121")];
	local v30 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\36\225\168\195\8\224\182", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\62\90\42\60\81\246\83", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\203\225\80", "\60\180\164\142")];
	local v31 = string[LUAOBFUSACTOR_DECRYPT_STR_0("\94\81\23\36\38\249", "\114\56\62\101\73\71\141")];
	local v32 = GetUnitEmpowerStageDuration;
	local v33 = 0;
	local v34 = 1;
	local v35 = 1;
	local v36 = 1;
	local v37 = false;
	local v38 = false;
	local v39 = false;
	local v40 = false;
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
	local v94 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\157\255\212\207\189\251", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\244\52\161\163\236\29\211\242\56\189\168", "\107\178\134\81\210\198\158")];
	local v95 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\29\24\141\205\175\42", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\29\135\228\207\209\25\131\227\195\204\1", "\170\163\111\226\151")];
	local v96 = v27[LUAOBFUSACTOR_DECRYPT_STR_0("\52\38\189\51\75\37", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\177\62\200\1\226\147\58\204\6\238\142\34", "\135\225\76\173\114")];
	local v97 = {};
	local v98 = v14:GetEquipment();
	local v99 = (v98[13] and v20(v98[13])) or v20(0);
	local v100 = (v98[14] and v20(v98[14])) or v20(0);
	local v101;
	local v102;
	local v103;
	local v104 = 11111;
	local v105 = 11111;
	local v106;
	local v107 = 0;
	local v108 = 0;
	local v109 = 0;
	local v110 = 0;
	v10:RegisterForEvent(function()
		local v127 = 0;
		while true do
			if ((1775 <= 3233) and (v127 == 1)) then
				v100 = (v98[14] and v20(v98[14])) or v20(0);
				break;
			end
			if ((v127 == 0) or (4543 == 1997)) then
				v98 = v14:GetEquipment();
				v99 = (v98[13] and v20(v98[13])) or v20(0);
				v127 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\42\193\153\137\137\143\152\63\220\141\153\156\144\130\52\217\135\147\132\156\137\61\200\156", "\199\122\141\216\208\204\221"));
	v10:RegisterForEvent(function()
		local v128 = 0;
		while true do
			if ((v128 == 0) or (3102 < 728)) then
				v104 = 11111;
				v105 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\157\241\49\201\93\196\146\239\53\215\93\216\146\248\62\209\90\218\136\249", "\150\205\189\112\144\24"));
	local function v111()
		local v129 = 0;
		while true do
			if ((345 == 345) and (0 == v129)) then
				if (v94[LUAOBFUSACTOR_DECRYPT_STR_0("\9\141\169\69\10\143\55\28\36\137\186", "\112\69\228\223\44\100\232\113")]:IsCastable() or (2827 < 378)) then
					if (v26(v94.LivingFlame, not v15:IsInRange(25), v106) or (3476 < 2597)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\22\17\218\184\123\185\210\19\6\222\179\60\150\198\26\4\220\187\126\135\192", "\230\180\127\103\179\214\28");
					end
				end
				if ((3079 < 4794) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\173\31\74\84\225\114\244\158\12\84\67", "\128\236\101\63\38\132\33")]:IsCastable()) then
					if ((4854 > 4464) and v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\179\4\86\179\212\220\184\187\24\79\179\171\223\190\172\18\75\187\233\206\184", "\175\204\201\113\36\214\139");
					end
				end
				break;
			end
		end
	end
	local function v112()
		local v130 = 0;
		while true do
			if ((0 == v130) or (4912 == 3758)) then
				if ((126 <= 3482) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\104\206\38\213\0\78\205\59\239\7\70\192\48\207", "\100\39\172\85\188")]:IsCastable() and v55 and v14:BuffDown(v94.ObsidianScales) and (v14:HealthPercentage() < v56)) then
					if (v26(v94.ObsidianScales) or (2374 == 4374)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\162\122\170\137\55\164\121\183\191\32\174\121\181\133\32\237\124\188\134\54\163\107\176\150\54\190", "\83\205\24\217\224");
					end
				end
				if ((1575 == 1575) and v95[LUAOBFUSACTOR_DECRYPT_STR_0("\206\192\204\49\242\205\222\41\233\203\200", "\93\134\165\173")]:IsReady() and v48 and (v14:HealthPercentage() <= v49)) then
					if (v26(v96.Healthstone, nil, nil, true) or (2234 == 1455)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\247\192\206\46\198\161\106\177\252\196\130\62\203\180\123\176\225\200\212\63\142\225", "\30\222\146\161\162\90\174\210");
					end
				end
				v130 = 1;
			end
			if ((1 == v130) or (1067 > 1779)) then
				if ((2161 >= 934) and v42 and (v14:HealthPercentage() <= v44)) then
					if ((1612 == 1612) and (v43 == LUAOBFUSACTOR_DECRYPT_STR_0("\215\75\118\24\224\93\120\3\235\73\48\34\224\79\124\3\235\73\48\58\234\90\121\5\235", "\106\133\46\16"))) then
						if ((4352 >= 2833) and v95[LUAOBFUSACTOR_DECRYPT_STR_0("\106\37\117\238\95\83\80\41\125\251\114\69\89\44\122\242\93\112\87\52\122\243\84", "\32\56\64\19\156\58")]:IsReady()) then
							if (v26(v96.RefreshingHealingPotion, nil, nil, true) or (3222 < 3073)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\72\205\227\68\95\225\136\83\198\226\22\82\247\129\86\193\235\81\26\226\143\78\193\234\88\26\246\133\92\205\235\69\83\228\133\26\156", "\224\58\168\133\54\58\146");
							end
						end
					end
				end
				if ((744 <= 2942) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\107\83\69\248\98\143\137\12\123\90\74\231\112", "\107\57\54\43\157\21\230\231")]:IsCastable() and (v14:HealthPercentage() < v88) and v87) then
					if (v22(v94.RenewingBlaze, nil, nil) or (1833 <= 1322)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\142\31\240\174\213\193\220\169\29\244\163\217\143\223\142\23\240\183\207\198\205\142", "\175\187\235\113\149\217\188");
					end
				end
				break;
			end
		end
	end
	local function v113()
		local v131 = 0;
		while true do
			if ((v131 == 0) or (3467 <= 1055)) then
				if ((3541 == 3541) and (not v16 or not v16:Exists() or not v16:IsInRange(30) or not v28.DispellableFriendlyUnit())) then
					return;
				end
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\25\183\145\89\237\126\125", "\24\92\207\225\44\131\25")]:IsReady() and (v28.UnitHasMagicDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) or (3557 >= 4003)) then
					if (v26(v96.ExpungeFocus) or (657 >= 1668)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\203\168\89\21\122\78\147\188\69\8\109\78\223", "\29\43\179\216\44\123");
					end
				end
				v131 = 1;
			end
			if ((v131 == 1) or (1027 > 3858)) then
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\158\216\53\88\184\203\41\86\180\215\39\106\177\216\45\73", "\44\221\185\64")]:IsReady() and (v28.UnitHasCurseDebuff(v16) or v28.UnitHasDiseaseDebuff(v16))) or (3654 < 450)) then
					if ((1891 < 4453) and v26(v96.CauterizingFlameFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\2\230\93\75\118\19\238\82\86\125\6\216\78\83\114\12\226\8\91\122\18\247\77\83", "\19\97\135\40\63");
					end
				end
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\129\76\35\41\42\34\189\85\61\60\29\62\175\78", "\81\206\60\83\91\79")]:IsReady() and v86 and v28.UnitHasEnrageBuff(v15)) or (3140 < 2129)) then
					if (v26(v94.OppressingRoar) or (2555 < 1240)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\97\187\192\96\42\208\94\173\64\172\144\64\32\194\95\228\74\162\195\98\42\207", "\196\46\203\176\18\79\163\45");
					end
				end
				break;
			end
		end
	end
	local function v114()
		if ((not v14:IsCasting() and not v14:IsChanneling()) or (4727 <= 4722)) then
			local v148 = 0;
			local v149;
			while true do
				if ((740 < 4937) and (v148 == 0)) then
					v149 = v28.Interrupt(v94.Quell, 10, true);
					if ((3658 >= 280) and v149) then
						return v149;
					end
					v148 = 1;
				end
				if ((v148 == 2) or (885 >= 1031)) then
					v149 = v28.Interrupt(v94.Quell, 10, true, v17, v96.QuellMouseover);
					if ((3554 >= 525) and v149) then
						return v149;
					end
					break;
				end
				if ((2414 <= 2972) and (v148 == 1)) then
					v149 = v28.InterruptWithStun(v94.TailSwipe, 8);
					if ((3529 <= 3538) and v149) then
						return v149;
					end
					v148 = 2;
				end
			end
		end
	end
	local function v115()
		local v132 = 0;
		while true do
			if ((v132 == 0) or (2861 < 458)) then
				ShouldReturn = v28.HandleTopTrinket(v97, v39, 40, nil);
				if ((1717 <= 4525) and ShouldReturn) then
					return ShouldReturn;
				end
				v132 = 1;
			end
			if ((v132 == 1) or (3178 <= 1524)) then
				ShouldReturn = v28.HandleBottomTrinket(v97, v39, 40, nil);
				if ((4254 > 370) and ShouldReturn) then
					return ShouldReturn;
				end
				break;
			end
		end
	end
	local function v116()
		local v133 = 0;
		while true do
			if ((v133 == 1) or (1635 == 1777)) then
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\217\186\67\76\114\203\248\180\66\68\104\218", "\191\157\211\48\37\28")]:IsReady() and v14:BuffUp(v94.EssenceBurstBuff)) or (3338 >= 3993)) then
					if ((1154 <= 1475) and v26(v94.Disintegrate, not v15:IsSpellInRange(v94.Disintegrate), v106)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\22\231\21\52\203\26\243\14\59\203\26\180\24\59\210\30\243\25", "\90\191\127\148\124");
					end
				end
				if (v94[LUAOBFUSACTOR_DECRYPT_STR_0("\84\142\56\30\118\128\8\27\121\138\43", "\119\24\231\78")]:IsCastable() or (2610 < 1230)) then
					if (v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106) or (1448 == 3083)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\142\36\179\67\210\71\46\132\33\164\71\217\0\21\131\32\164\77\217", "\113\226\77\197\42\188\32");
					end
				end
				v133 = 2;
			end
			if ((3139 > 916) and (v133 == 0)) then
				if ((2954 == 2954) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\148\43\104\23\42\252\201\180\35\115\27", "\143\216\66\30\126\68\155")]:IsCastable() and v14:BuffUp(v94.LeapingFlamesBuff)) then
					if ((117 <= 2892) and v26(v94.LivingFlame, not v15:IsSpellInRange(v94.LivingFlame), v106)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\193\27\194\203\164\232\231\166\201\0\206\250\175\210\224\186\193\3\204\250\165\219\224\167\205\30\139\193\162\218\224\173\205", "\129\202\168\109\171\165\195\183");
					end
				end
				if (v94[LUAOBFUSACTOR_DECRYPT_STR_0("\4\81\37\221\252\6\227\35\76\63", "\134\66\56\87\184\190\116")]:IsReady() or (453 > 4662)) then
					local v175 = 0;
					while true do
						if ((1320 > 595) and (v175 == 0)) then
							if ((v103 <= 2) or (3199 < 590)) then
								v107 = 1;
							elseif ((v103 <= 4) or (4793 < 30)) then
								v107 = 2;
							elseif ((v103 <= 6) or (1696 <= 1059)) then
								v107 = 3;
							else
								v107 = 4;
							end
							v34 = v107;
							v175 = 1;
						end
						if ((2343 == 2343) and (1 == v175)) then
							if (v26(v96.FireBreathMacro, not v15:IsInRange(30), true, nil, true) or (1043 > 3591)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\58\56\27\190\38\233\51\48\61\37\1\251\29\234\44\52\59\52\73", "\85\92\81\105\219\121\139\65") .. v107;
							end
							break;
						end
					end
				end
				v133 = 1;
			end
			if ((2 == v133) or (2890 >= 4079)) then
				if ((4474 <= 4770) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\27\12\225\167\63\37\224\167\51\29\241", "\213\90\118\148")]:IsCastable()) then
					if (v26(v94.AzureStrike, not v15:IsSpellInRange(v94.AzureStrike)) or (4942 == 3903)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\52\161\68\72\100\61\160\68\68\80\43\244\82\76\86\47\179\83", "\45\59\78\212\54");
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v134 = 0;
		local v135;
		while true do
			if ((v134 == 1) or (248 > 4845)) then
				if ((1569 == 1569) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\125\147\226\62\71\148\209\40\79\132\247\36\88\134\247\40", "\77\46\231\131")]:IsReady() and v57 and (v28.AreUnitsBelowHealthPercentage(v58, v59) or (v14:BuffUp(v94.StasisBuff) and (v14:BuffRemains(v94.StasisBuff) < 3)))) then
					if (v26(v94.StasisReactivate) or (4927 <= 3221)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\64\183\83\179\71\137\82\191\85\181\84\179\66\183\84\191\20\181\79\181\88\178\79\173\90", "\32\218\52\214");
					end
				end
				if (v94[LUAOBFUSACTOR_DECRYPT_STR_0("\122\30\33\156\249\181\118\89\79\27\52\187", "\58\46\119\81\200\145\208\37")]:IsCastable() or (1780 > 2787)) then
					if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\15\158\53\173\164\159\36\46\141\36\164", "\86\75\236\80\204\201\221")]:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) or (3937 <= 1230)) then
						local v200 = 0;
						while true do
							if ((v200 == 0) or (2637 < 1706)) then
								v35 = 1;
								if (v26(v96.TipTheScalesDreamBreath) or (2669 <= 2409)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\118\83\114\132\243\180\112\83\114\132\234\131\50\66\120\138\242\143\125\86\121", "\235\18\33\23\229\158");
								end
								break;
							end
						end
					elseif ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\99\170\200\169\89\174\195\183\95\181\204", "\219\48\218\161")]:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) or (1401 > 4696)) then
						local v205 = 0;
						while true do
							if ((v205 == 0) or (3280 < 1321)) then
								v36 = 3;
								if ((4927 >= 2303) and v26(v96.TipTheScalesSpiritbloom)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\247\97\117\91\210\91\223\230\125\115\70\214\15\227\235\126\112\77\212\88\238", "\128\132\17\28\41\187\47");
								end
								break;
							end
						end
					end
				end
				if ((3462 >= 1032) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\37\32\3\59\80\39\62\15\61\85\21", "\61\97\82\102\90")]:IsCastable() and (v91 == LUAOBFUSACTOR_DECRYPT_STR_0("\141\58\235\104\210\69\13\6\190", "\105\204\78\203\43\167\55\126")) and v28.AreUnitsBelowHealthPercentage(v92, v93)) then
					if (v26(v96.DreamFlightCursor) or (1077 >= 2011)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\184\38\31\30\59\225\93\172\173\43\10\83\7\200\94\169\174\44\9\29", "\49\197\202\67\126\115\100\167");
					end
				end
				if ((1543 < 2415) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\19\73\218\40\141\112\82\62\92\215\61", "\62\87\59\191\73\224\54")]:IsCastable() and (v91 == LUAOBFUSACTOR_DECRYPT_STR_0("\196\13\244\207\238\16\247\200\243\11\245\199", "\169\135\98\154")) and v28.AreUnitsBelowHealthPercentage(v92, v93)) then
					if (v26(v94.DreamFlight) or (4444 < 2015)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\239\101\33\85\240\12\238\199\126\35\92\233\115\203\196\120\40\80\242\36\198", "\168\171\23\68\52\157\83");
					end
				end
				v134 = 2;
			end
			if ((v134 == 0) or (4200 == 2332)) then
				if (not v16 or not v16:Exists() or not v16:IsInRange(30) or (1278 >= 1316)) then
					return;
				end
				v135 = v115();
				if ((1082 == 1082) and v135) then
					return v135;
				end
				if ((1328 <= 4878) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\35\66\130\152\143\61", "\144\112\54\227\235\230\78\205")]:IsReady() and v57 and v28.AreUnitsBelowHealthPercentage(v58, v59)) then
					if ((4087 >= 1355) and v26(v94.Stasis)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\160\60\14\239\217\72\243\43\0\243\220\95\188\63\1", "\59\211\72\111\156\176");
					end
				end
				v134 = 1;
			end
			if ((v134 == 2) or (590 > 4650)) then
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\198\116\226\164\43\41", "\231\148\17\149\205\69\77")]:IsCastable() and v66 and v28.AreUnitsBelowHealthPercentage(v67, v68)) or (3774 <= 3667)) then
					if ((1270 < 2146) and v26(v94.Rewind)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\146\162\208\242\89\251\192\164\200\244\91\251\143\176\201", "\159\224\199\167\155\55");
					end
				end
				if ((4563 >= 56) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\195\250\49\215\211\250\48\211\227\250\51\220", "\178\151\147\92")]:IsCastable() and v69 and (v16:HealthPercentage() <= v70)) then
					if (v26(v96.TimeDilationFocus) or (446 == 622)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\152\244\65\55\45\72\115\128\252\88\59\29\66\58\143\242\67\62\22\67\109\130", "\26\236\157\44\82\114\44");
					end
				end
				if ((2069 > 1009) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\12\39\199\94\8\60\208\90\62\38", "\59\74\78\181")]:IsReady()) then
					local v176 = 0;
					while true do
						if ((12 < 4208) and (v176 == 1)) then
							if (v26(v96.FireBreathMacro, not v15:IsInRange(30), true, nil, true) or (2990 <= 2980)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\35\216\72\95\140\39\195\95\91\167\45\145\89\94\160\101", "\211\69\177\58\58") .. v107;
							end
							break;
						end
						if ((v176 == 0) or (2575 >= 4275)) then
							if ((v103 <= 2) or (3626 <= 1306)) then
								v107 = 1;
							elseif ((1368 < 3780) and (v103 <= 4)) then
								v107 = 2;
							elseif ((v103 <= 6) or (3169 == 2273)) then
								v107 = 3;
							else
								v107 = 4;
							end
							v34 = v107;
							v176 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v118()
		local v136 = 0;
		while true do
			if ((2481 <= 3279) and (1 == v136)) then
				if ((v71 == LUAOBFUSACTOR_DECRYPT_STR_0("\27\41\252\227\39\48\247\244", "\145\94\95\153")) or (1063 <= 877)) then
					if ((2314 == 2314) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\203\200\6\209\79\185\233\232\25\215\92\182\254\200", "\215\157\173\116\181\46")]:IsReady() and (v16:HealthPercentage() < v72)) then
						if ((924 >= 477) and v22(v96.VerdantEmbraceFocus, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\35\177\153\246\219\59\160\180\247\215\55\166\138\241\223\117\181\132\247\229\61\177\138\254\211\59\179", "\186\85\212\235\146");
						end
					end
				end
				if ((1813 <= 3778) and (v71 == LUAOBFUSACTOR_DECRYPT_STR_0("\236\142\2\190\13\239\86\201", "\56\162\225\118\158\89\142"))) then
					if ((4150 == 4150) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\106\0\210\171\35\214\72\32\205\173\48\217\95\0", "\184\60\101\160\207\66")]:IsReady() and (v16:HealthPercentage() < v72) and (v28.UnitGroupRole(v16) ~= LUAOBFUSACTOR_DECRYPT_STR_0("\5\163\82\151", "\220\81\226\28"))) then
						if ((432 <= 3007) and v22(v96.VerdantEmbraceFocus, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\5\208\144\255\235\201\7\234\135\246\232\213\18\214\135\187\235\200\22\234\138\254\235\203\26\219\133", "\167\115\181\226\155\138");
						end
					end
				end
				v136 = 2;
			end
			if ((v136 == 3) or (408 > 2721)) then
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\150\132\190\219\180\138\142\222\187\128\173", "\178\218\237\200")]:IsCastable() and v76 and v14:BuffUp(v94.LeapingFlamesBuff) and (v16:HealthPercentage() <= v77)) or (3418 < 2497)) then
					if ((1735 < 2169) and v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\188\240\217\184\178\217\214\186\180\235\213\137\185\227\209\166\188\232\215\137\179\234\209\187\176\245\144\183\186\227\239\190\176\231\220\191\187\225", "\176\214\213\134");
					end
				end
				break;
			end
			if ((3890 >= 3262) and (2 == v136)) then
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\198\48\226\93\118\83\212\231\35\243\84", "\166\130\66\135\60\27\17")]:IsReady() and v60 and v28.AreUnitsBelowHealthPercentage(v61, v62)) or (4356 >= 4649)) then
					local v177 = 0;
					while true do
						if ((3904 == 3904) and (v177 == 0)) then
							if ((v110 <= 2) or (2860 >= 3789)) then
								v108 = 1;
							else
								v108 = 2;
							end
							v35 = v108;
							v177 = 1;
						end
						if ((v177 == 1) or (1086 > 4449)) then
							if ((4981 > 546) and v26(v96.DreamBreathMacro, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\64\88\203\116\61\123\72\220\112\49\80\66\142\116\63\65\117\198\112\49\72\67\192\114", "\80\36\42\174\21");
							end
							break;
						end
					end
				end
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\125\0\62\104\71\4\53\118\65\31\58", "\26\46\112\87")]:IsReady() and v63 and v28.AreUnitsBelowHealthPercentage(v64, v65)) or (2366 <= 8)) then
					local v178 = 0;
					while true do
						if ((v178 == 0) or (2590 == 2864)) then
							if ((v110 > 2) or (2624 > 4149)) then
								v109 = 3;
							else
								v109 = 1;
							end
							v36 = 3;
							v178 = 1;
						end
						if ((v178 == 1) or (2618 >= 4495)) then
							if (v26(v96.SpiritbloomFocus, nil, true) or (2485 >= 3131)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\170\51\162\102\182\171\122\182\181\44\164\121\255\190\74\177\134\43\174\117\179\182\75\179", "\212\217\67\203\20\223\223\37");
							end
							break;
						end
					end
				end
				v136 = 3;
			end
			if ((v136 == 0) or (2804 <= 2785)) then
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\146\232\124\231\232\199\179\199\117\250\250\216\184\232", "\171\215\133\25\149\137")]:IsCastable() and v73 and v28.AreUnitsBelowHealthPercentage(v74, v75)) or (4571 == 3415)) then
					if (v26(v96.EmeraldBlossomFocus) or (4441 > 4787)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\197\55\232\238\60\248\125\227\196\61\233\252\63\241\2\224\199\55\197\231\53\253\78\232\198\53", "\34\129\168\82\154\143\80\156");
					end
				end
				if ((1920 == 1920) and (v71 == LUAOBFUSACTOR_DECRYPT_STR_0("\181\190\50\18\77\92\201\170\188\63\18", "\233\229\210\83\107\40\46"))) then
					if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\247\71\32\210\4\207\86\23\219\7\211\67\49\211", "\101\161\34\82\182")]:IsReady() and (v14:HealthPercentage() < v72)) or (647 == 4477)) then
						if ((3819 == 3819) and v22(v96.VerdantEmbracePlayer, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\254\8\75\250\218\236\150\17\237\0\91\236\218\225\135\110\233\2\92\193\211\231\131\34\225\3\94", "\78\136\109\57\158\187\130\226");
						end
					end
				end
				v136 = 1;
			end
		end
	end
	local function v119()
		local v137 = 0;
		while true do
			if ((v137 == 0) or (1466 > 4360)) then
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\198\168\160\209\186\69\80\251\163", "\57\148\205\214\180\200\54")]:IsReady() and v78 and (v28.UnitGroupRole(v16) ~= LUAOBFUSACTOR_DECRYPT_STR_0("\38\220\27\31", "\22\114\157\85\84")) and (v28.FriendlyUnitsWithBuffCount(v94.Reversion) < 1) and (v16:HealthPercentage() <= v79)) or (14 > 994)) then
					if ((401 <= 734) and v26(v96.ReversionFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\206\5\193\79\229\161\203\197\44\208\92\248\163\132\216\7\251\85\243\169\200\194\29\195", "\200\164\171\115\164\61\150");
					end
				end
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\140\241\21\64\145\173\253\12\75", "\227\222\148\99\37")]:IsReady() and v78 and (v28.UnitGroupRole(v16) == LUAOBFUSACTOR_DECRYPT_STR_0("\7\115\124\221", "\153\83\50\50\150")) and (v28.FriendlyUnitsWithBuffCount(v94.Reversion, true, false) < 1) and (v16:HealthPercentage() <= v80)) or (2167 >= 3426)) then
					if ((764 < 3285) and v26(v96.ReversionFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\115\101\25\97\184\68\82\120\76\8\114\165\70\29\101\103\35\123\174\76\81\127\125\27", "\45\61\22\19\124\19\203");
					end
				end
				v137 = 1;
			end
			if ((2499 == 2499) and (v137 == 2)) then
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\168\200\22\176\49\54\238\136\192\13\188", "\168\228\161\96\217\95\81")]:IsReady() and v76 and (v16:HealthPercentage() <= v77)) or (692 >= 4933)) then
					if (v26(v96.LivingFlameFocus, not v16:IsSpellInRange(v94.LivingFlame), v106) or (3154 <= 2260)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\216\56\85\33\80\228\215\34\93\34\82\155\194\58\99\39\82\218\221\39\82\40", "\55\187\177\78\60\79");
					end
				end
				break;
			end
			if ((1 == v137) or (2637 > 3149)) then
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\245\23\0\229\13\98\184\205\51\3\250\15\113\181\216", "\217\161\114\109\149\98\16")]:IsReady() and v81 and v28.AreUnitsBelowHealthPercentage(v82, v83)) or (3992 < 2407)) then
					if (v26(v94.TemporalAnomaly, not v16:IsInRange(30), v106) or (2902 > 4859)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\6\37\53\108\179\102\19\44\7\125\178\123\31\33\52\101\252\103\6\31\48\121\189\120\27\46\63", "\20\114\64\88\28\220");
					end
				end
				if ((1679 < 4359) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\20\2\218\187", "\221\81\97\178\212\152\176")]:IsReady() and v84 and not v16:BuffUp(v94.Echo) and (v16:HealthPercentage() <= v85)) then
					if ((1913 < 4670) and v26(v96.EchoFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\200\228\21\244\90\222\243\34\243\31\204\235\20\245\29", "\122\173\135\125\155");
					end
				end
				v137 = 2;
			end
		end
	end
	local function v120()
		local v138 = 0;
		local v139;
		while true do
			if ((v138 == 1) or (2846 < 879)) then
				if ((4588 == 4588) and v139) then
					return v139;
				end
				v139 = v119();
				v138 = 2;
			end
			if ((v138 == 2) or (347 == 2065)) then
				if (v139 or (1311 > 2697)) then
					return v139;
				end
				break;
			end
			if ((v138 == 0) or (2717 > 3795)) then
				if (not v16 or not v16:Exists() or not v16:IsInRange(30) or (1081 < 391)) then
					return;
				end
				v139 = v118();
				v138 = 1;
			end
		end
	end
	local function v121()
		local v140 = 0;
		local v141;
		while true do
			if ((v140 == 0) or (121 > 3438)) then
				if ((71 < 1949) and (v47 or v46)) then
					local v179 = 0;
					local v180;
					while true do
						if ((4254 == 4254) and (v179 == 0)) then
							v180 = v113();
							if ((3196 >= 2550) and v180) then
								return v180;
							end
							break;
						end
					end
				end
				v141 = v112();
				v140 = 1;
			end
			if ((2456 < 4176) and (v140 == 3)) then
				if (v141 or (1150 == 3452)) then
					return v141;
				end
				v141 = v120();
				v140 = 4;
			end
			if ((1875 < 2258) and (v140 == 2)) then
				if ((1173 > 41) and v141) then
					return v141;
				end
				v141 = v114();
				v140 = 3;
			end
			if ((4 == v140) or (56 >= 3208)) then
				if ((4313 > 3373) and v141) then
					return v141;
				end
				if (v28.TargetIsValid() or (4493 == 2225)) then
					local v181 = 0;
					while true do
						if ((3104 >= 3092) and (v181 == 0)) then
							v141 = v116();
							if ((3548 > 3098) and v141) then
								return v141;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v140 == 1) or (3252 == 503)) then
				if ((4733 > 2066) and v141) then
					return v141;
				end
				v141 = v117();
				v140 = 2;
			end
		end
	end
	local function v122()
		local v142 = 0;
		while true do
			if ((3549 >= 916) and (v142 == 0)) then
				if (v47 or v46 or (2189 <= 245)) then
					local v182 = 0;
					local v183;
					while true do
						if ((0 == v182) or (1389 > 3925)) then
							v183 = v113();
							if ((4169 >= 3081) and v183) then
								return v183;
							end
							break;
						end
					end
				end
				if ((349 <= 894) and v37) then
					local v184 = 0;
					local v185;
					while true do
						if ((731 <= 2978) and (v184 == 1)) then
							if ((UseBlessingoftheBronze and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\15\194\90\248\85\198\142\42\193\89\255\78\202\162\63\193\81\241\67", "\224\77\174\63\139\38\175")]:IsCastable() and (v14:BuffDown(v94.BlessingoftheBronzeBuff, true) or v28.GroupBuffMissing(v94.BlessingoftheBronzeBuff))) or (892 > 3892)) then
								if (v26(v94.BlessingoftheBronze) or (4466 == 900)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\134\77\93\61\151\72\86\41\187\78\94\17\144\73\93\17\134\83\87\32\158\68\24\62\150\68\91\33\137\67\89\58", "\78\228\33\56");
								end
							end
							if (v28.TargetIsValid() or (2084 >= 2888)) then
								local v206 = 0;
								local v207;
								while true do
									if ((479 < 1863) and (v206 == 0)) then
										v207 = v111();
										if (v207 or (2428 >= 4038)) then
											return v207;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v184 == 0) or (2878 > 2897)) then
							v185 = v120();
							if (v185 or (2469 > 3676)) then
								return v185;
							end
							v184 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v143 = 0;
		while true do
			if ((233 < 487) and (0 == v143)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\253\123\166\23\140\192\121\161", "\229\174\30\210\99")][LUAOBFUSACTOR_DECRYPT_STR_0("\46\254\131\99\236\62\48\26\225\149", "\89\123\141\230\49\141\93")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\192\116\226\24\25\68\244\98", "\42\147\17\150\108\112")][LUAOBFUSACTOR_DECRYPT_STR_0("\58\181\40\87\226\233\3\175\35\120\215\231\27\175\34\113", "\136\111\198\77\31\135")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\49\12\179\66\180\234\16\186", "\201\98\105\199\54\221\132\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\9\130\45\11\59\171\137\3\151\40\13\59\130\184\1\134", "\204\217\108\227\65\98\85")] or 0;
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\109\198\225\241\37\206\89\208", "\160\62\163\149\133\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\165\12\35\202\216\167\61\32\215\223\175\3\7\243", "\163\182\192\109\79")] or 0;
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\7\35\20\212\252\58\33\19", "\149\84\70\96\160")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\21\8\207\52\3\30\254\49\8\10\194\62\50\5\232\26\20\2\227\34\3", "\141\88\102\109")];
				v143 = 1;
			end
			if ((2473 >= 201) and (3 == v143)) then
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\176\156\25\19\187\143\30", "\109\122\213\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\193\245\177\57\234\254\163\62\221\244\163\60\235\228\138\0", "\80\142\151\194")] or 0;
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\195\99\88\10\200\112\95", "\44\99\166\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\73\228\44\5\39\165\111\254\58", "\196\28\151\73\86\83")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\192\6\61\4\139\86\31\101", "\22\147\99\73\112\226\56\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\97\227\230\132\171\93\210", "\237\216\21\130\149")] or 0;
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\75\75\75\185\199\89\145", "\62\226\46\63\63\208\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\13\84\144\22\30\8\76\234\12\69", "\62\133\121\53\227\127\109\79")] or 0;
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\35\17\38\225\223\160\165\3", "\194\112\116\82\149\182\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\12\187\73\60\210\231\15\52\138\94\29\193\246\6", "\110\89\200\44\120\160\130")];
				v143 = 4;
			end
			if ((4120 >= 133) and (v143 == 6)) then
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\235\67\20\103\162\165\223\85", "\203\184\38\96\19\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\118\107\69\207\55\103\92\76\204\43\114\122\68\251\42\114\126\68", "\174\89\19\25\33")] or "";
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\23\70\90\254\137\12\60", "\107\79\114\50\46\151\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\163\167\45\139\55\163\229\52\164\167\40\137\60\159\240", "\160\89\198\213\73\234\89\215")] or 0;
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\123\116\160\234\204\70\118\167", "\165\40\17\212\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\202\13\22\43\224\203\9\63\34\199\213\7\32\53\234\212", "\70\133\185\104\83")];
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\64\80\62\192\10\66\87", "\169\100\37\36\74")][LUAOBFUSACTOR_DECRYPT_STR_0("\37\138\167\66\1\139\166\114\12\136\177\67\15\138\138\96", "\48\96\231\194")] or 0;
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\95\26\57\16\214\168\144", "\227\168\58\110\77\121\184\207")][LUAOBFUSACTOR_DECRYPT_STR_0("\94\49\186\82\176\215\117\135\119\51\172\83\190\214\86\183\116\41\175", "\197\27\92\223\32\209\187\17")] or 0;
				v143 = 7;
			end
			if ((3080 >= 1986) and (v143 == 8)) then
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\243\109\21\143\210\241\229", "\188\150\150\25\97\230")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\154\90\54\9\224\202\134\77\3\0\204\212\134\82\3\0\244", "\141\186\233\63\98\108")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\239\56\162\44\255\237\63", "\69\145\138\76\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\68\202\132\153\176\4\113\195\168\135\176\27\113\195\144\161\143", "\118\16\175\233\233\223")] or 0;
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\129\33\175\231\133\122\152", "\29\235\228\85\219\142\235")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\209\183\205\120\92\38\94\28\218\181\208\118\66\62\117\47\219\175\205", "\50\93\180\218\189\23\46\71")] or 0;
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\161\79\88\77\210\79\205", "\40\190\196\59\44\36\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\86\217\145\249\117\2", "\109\92\37\188\212\154\29")];
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\234\176\215\56\84\3\252", "\58\100\143\196\163\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\63\65\43\172\23\121", "\110\122\34\67\195\95\41\133")] or 0;
				v143 = 9;
			end
			if ((5 == v143) or (1439 > 3538)) then
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\93\16\202\94\86\3\205", "\190\55\56\100")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\188\57\44\22\244\250\88\171", "\147\54\207\92\126\115\131")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\52\33\105\4\112\10\34", "\30\109\81\85\29\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\205\116\67\191\56\218\212\207", "\156\159\17\52\214\86\190")] or 0;
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\157\234\169\168\167\225\186\175", "\220\206\143\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\120\58\30\214\200\245\148\114\56\7", "\178\230\29\77\119\184\172")] or 0;
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\198\187\30\15\126\246\242\173", "\152\149\222\106\123\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\232\53\243\119\188\208\35\210\74\185\220\50\255\76\187", "\213\189\70\150\35")];
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\124\80\96\28\70\91\115\27", "\104\47\53\20")][LUAOBFUSACTOR_DECRYPT_STR_0("\151\69\140\25\152\6\175\77\149\21\179\1\139\124", "\111\195\44\225\124\220")] or 0;
				v143 = 6;
			end
			if ((2 == v143) or (419 < 7)) then
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\53\26\70\211\165\124\140\21", "\235\102\127\50\167\204\18")][LUAOBFUSACTOR_DECRYPT_STR_0("\120\160\251\39\72\43\121\175\246\44\86\62\95\179\240\34\72", "\78\48\193\149\67\36")] or 0;
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\3\27\148\12\72\62\25\147", "\33\80\126\224\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\166\23\193\78\254\189\19\208\107\229\188\11\247\72\249\166", "\60\140\200\99\164")] or 0;
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\180\241\16\50\171\137\243\23", "\194\231\148\100\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\111\66\213\166\228\218\83\92\213\140\248\196\95\123\201\170\226\205\74\69\210\183", "\168\38\44\161\195\150")] or 0;
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\249\150\98\57\230\177\5", "\118\224\156\226\22\80\136\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\224\77\133\80\252\76\144\86\218\81\146\71\253\81\143\78\234", "\224\34\142\57")] or 0;
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\162\209\201\122\255\90\29", "\110\190\199\165\189\19\145\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\248\114\199\137\212\211\239\126\233\133\244\217\234\123\237\152", "\167\186\139\23\136\235")];
				v143 = 3;
			end
			if ((2820 == 2820) and (v143 == 9)) then
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\180\79\94\223\123\182\72", "\182\21\209\59\42")][LUAOBFUSACTOR_DECRYPT_STR_0("\130\68\192\50\49\174\165\82\214\14\40\176\176\101\202\28\51", "\222\215\55\165\125\65")];
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\212\210\14\251\207\234\89", "\42\76\177\166\122\146\161\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\153\0\252\124\120\160\157\12\192\126\84\169\139\31\203", "\22\197\234\101\174\25")];
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\49\177\200\127\161\208\149", "\230\77\84\197\188\22\207\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\17\200\249\155\168\254\50\219\24\199\230\137\137\192", "\85\153\116\166\156\236\193\144")] or 0;
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\229\89\167\237\14\163\243", "\96\196\128\45\211\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\158\126\119\221\185\177\202", "\184\85\237\27\63\178\207\212")];
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\92\29\75\1\87\14\76", "\63\104\57\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\35\136\178\65\25\179\173\73\14", "\36\107\231\196")] or 0;
				break;
			end
			if ((v143 == 1) or (4362 <= 3527)) then
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\86\222\100\19\51\82\210", "\161\211\51\170\16\122\93\53")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\167\161\56\254\162\150\45\249\187\180\46\232", "\72\155\206\210")] or 0;
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\127\64\26\58\72\125\71", "\83\38\26\52\110")][LUAOBFUSACTOR_DECRYPT_STR_0("\124\30\52\86\93\27\5\83\94\17\52", "\38\56\119\71")] or 0;
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\192\234\76\194\44\88\244\252", "\54\147\143\56\182\69")][LUAOBFUSACTOR_DECRYPT_STR_0("\227\146\250\97\218\215\141\235\65\204\194\142\241\76", "\191\182\225\159\41")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\24\23\60\65\130\137\197\56", "\162\75\114\72\53\235\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\164\57\69\238\71\10\159\40\75\236\86\42\188", "\98\236\92\36\130\51")] or 0;
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\28\24\174\76\166\178\35", "\80\196\121\108\218\37\200\213")][LUAOBFUSACTOR_DECRYPT_STR_0("\40\114\12\123\71\11\171\6\117\14\118\72\26\143\4", "\234\96\19\98\31\43\110")] or 0;
				v143 = 2;
			end
			if ((2613 <= 2680) and (7 == v143)) then
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\90\215\239\10\81\196\232", "\155\99\63\163")][LUAOBFUSACTOR_DECRYPT_STR_0("\183\194\164\161\176\146\139\223\166\171\181\133\143\212", "\228\226\177\193\237\217")];
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\7\181\55\242\61\190\36\245", "\134\84\208\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\63\165\144\85\29\171\160\80\18\161\131\116\35", "\60\115\204\230")] or 0;
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\63\255\100\238\52\236\99", "\16\135\90\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\97\103\3\1\75\66\125\70\103\15\60\64", "\24\52\20\102\83\46\52")];
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\42\53\48\6\202\40\50", "\111\164\79\65\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\220\149\219\60\249\207\214\141\246\30", "\138\166\185\227\190\78")] or 0;
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\113\209\35\91\45\30\216", "\121\171\20\165\87\50\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\61\175\51\171\17\207\55\183\2\184\12\205\16\137", "\98\166\88\217\86\217")] or 0;
				v143 = 8;
			end
			if ((v143 == 4) or (1482 >= 4288)) then
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\152\198\95\82\74\68\60\94", "\45\203\163\43\38\35\42\91")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\151\217\34\138\139\70\215\132\200\43\175\153", "\52\178\229\188\67\231\201")] or 0;
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\68\68\16\254\82\36\50", "\67\65\33\48\100\151\60")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\245\171\217\254\253\245\171\217\231\215\192\188\215\230\207", "\147\191\135\206\184")] or 0;
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\45\178\213\209\93\181\151", "\210\228\72\198\161\184\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\3\90\246\35\99\199\36\64\231\18\127\193\57\68", "\174\86\41\147\112\19")];
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\5\153\31\44\1\22\184", "\203\59\96\237\107\69\111\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\6\165\243\56\228\213\40\25\163\236\25\192", "\183\68\118\204\129\81\144")] or 0;
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\61\168\100\240\2\140\9\190", "\226\110\205\16\132\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\216\211\233\203\72\255\193\236\214\78\230\228\242\214\84\251", "\33\139\163\128\185")] or 0;
				v143 = 5;
			end
		end
	end
	local function v124()
		local v144 = 0;
		while true do
			if ((v144 == 1) or (2462 > 4426)) then
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\251\25\231\241\217\234\237", "\183\141\158\109\147\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\8\27\227\13\33\47\234\5\43\1\242\43\62\6\243\28", "\108\76\105\134")] or 0;
				break;
			end
			if ((4774 == 4774) and (v144 == 0)) then
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\176\182\147\84\187\165\148", "\231\61\213\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\191\56\114\4\139\49\122\14\165\41\70\26\172\58\118", "\19\105\205\93")] or "";
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\154\13\202\149\54\167\15\205", "\95\201\104\190\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\217\196\207\162\237\205\199\168\195\213\230\159", "\174\207\171\161")] or 0;
				v144 = 1;
			end
		end
	end
	local function v125()
		local v145 = 0;
		while true do
			if ((566 <= 960) and (v145 == 2)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\137\126\244\83\203\55", "\68\218\230\25\147\63\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\35\64\92\179\161", "\214\205\74\51\44")];
				if (v14:IsMounted() or (2910 <= 1930)) then
					return;
				end
				if (not v14:IsMoving() or (19 > 452)) then
					v33 = GetTime();
				end
				v145 = 3;
			end
			if ((0 == v145) or (907 > 3152)) then
				v123();
				v124();
				if (v14:IsDeadOrGhost() or (2505 > 4470)) then
					return;
				end
				v145 = 1;
			end
			if ((v145 == 1) or (3711 > 4062)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\223\202\182\230\194\238\214", "\174\139\165\209\129")][LUAOBFUSACTOR_DECRYPT_STR_0("\172\188\225", "\24\195\211\130\161\166\99\16")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\114\12\238\43\95\19\85", "\118\38\99\137\76\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\252\41\0", "\64\157\70\101\114\105")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\167\160\228\28\69\187", "\112\32\200\199\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\47\84\79", "\66\76\48\60\216\163\203")];
				v145 = 2;
			end
			if ((420 == 420) and (v145 == 3)) then
				if (v14:AffectingCombat() or v46 or (33 >= 3494)) then
					local v186 = 0;
					local v187;
					local v188;
					while true do
						if ((v186 == 0) or (1267 == 4744)) then
							v187 = v46 and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\223\84\242\233\121\253\73", "\23\154\44\130\156")]:IsReady();
							v188 = v28.FocusUnit(v187, v96, 30, 20);
							v186 = 1;
						end
						if ((2428 < 3778) and (v186 == 1)) then
							if (v188 or (2946 <= 1596)) then
								return v188;
							end
							break;
						end
					end
				end
				if ((4433 > 3127) and v50) then
					local v189 = 0;
					while true do
						if ((4300 >= 2733) and (v189 == 0)) then
							ShouldReturn = v28.HandleAfflicted(v94.Expunge, v96.ExpungeMouseover, 40);
							if ((4829 == 4829) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if ((1683 <= 4726) and v51) then
					local v190 = 0;
					while true do
						if ((4835 >= 3669) and (v190 == 0)) then
							ShouldReturn = v28.HandleIncorporeal(v94.Sleepwalk, v96.SleepwalkMouseover, 30, true);
							if ((2851 > 1859) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v145 = 4;
			end
			if ((3848 > 2323) and (v145 == 6)) then
				if ((2836 > 469) and (v28.TargetIsValid() or v14:AffectingCombat())) then
					local v191 = 0;
					while true do
						if ((v191 == 0) or (2096 <= 540)) then
							v104 = v10.BossFightRemains(nil, true);
							v105 = v104;
							v191 = 1;
						end
						if ((v191 == 1) or (3183 < 2645)) then
							if ((3230 <= 3760) and (v105 == 11111)) then
								v105 = v10.FightRemains(v101, false);
							end
							break;
						end
					end
				end
				if ((3828 == 3828) and v14:IsChanneling(v94.FireBreath)) then
					local v192 = 0;
					local v193;
					while true do
						if ((554 == 554) and (v192 == 0)) then
							v193 = GetTime() - v14:CastStart();
							if ((v193 >= v14:EmpowerCastTime(v34)) or (2563 == 172)) then
								local v208 = 0;
								while true do
									if ((3889 >= 131) and (v208 == 0)) then
										v10[LUAOBFUSACTOR_DECRYPT_STR_0("\145\153\217\45\15\168\33\160\128\222\41\47\158", "\85\212\233\176\78\92\205")] = v94[LUAOBFUSACTOR_DECRYPT_STR_0("\108\81\154\231\104\74\141\227\94\80", "\130\42\56\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\216\176\48\246\82\49\195\145", "\95\138\213\68\131\32")];
										return LUAOBFUSACTOR_DECRYPT_STR_0("\25\60\174\83\102\35\38\166\3\80\35\58\164\3\84\56\45\160\87\126", "\22\74\72\193\35");
									end
								end
							end
							break;
						end
					end
				end
				if (v14:IsChanneling(v94.DreamBreath) or (492 == 4578)) then
					local v194 = 0;
					local v195;
					while true do
						if ((v194 == 0) or (4112 < 1816)) then
							v195 = GetTime() - v14:CastStart();
							if ((4525 >= 1223) and (v195 >= v14:EmpowerCastTime(v35))) then
								local v209 = 0;
								while true do
									if ((1090 <= 4827) and (v209 == 0)) then
										v10[LUAOBFUSACTOR_DECRYPT_STR_0("\9\105\237\91\31\124\240\76\37\119\227\75\31", "\56\76\25\132")] = v94[LUAOBFUSACTOR_DECRYPT_STR_0("\122\211\174\39\194\124\211\174\39\219\86", "\175\62\161\203\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\14\216\215\6\39\50\244\231", "\85\92\189\163\115")];
										return LUAOBFUSACTOR_DECRYPT_STR_0("\26\184\63\40\57\165\62\63\105\136\34\61\40\161\18\42\44\173\36\48", "\88\73\204\80");
									end
								end
							end
							break;
						end
					end
				end
				v145 = 7;
			end
			if ((v145 == 4) or (239 > 1345)) then
				if ((v89 and (v37 or v14:AffectingCombat())) or (3710 >= 3738)) then
					if (((GetTime() - v33) > v90) or (3838 < 2061)) then
						if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\57\169\187\171\36", "\115\113\198\205\206\86")]:IsReady() and v14:BuffDown(v94.Hover)) or (690 > 1172)) then
							if (v26(v94.Hover) or (1592 > 2599)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\140\88\232\95\150\23\243\91\141\89\190\8", "\58\228\55\158");
							end
						end
					end
				end
				v106 = v14:BuffRemains(v94.HoverBuff) < 2;
				v110 = v28.FriendlyUnitsBelowHealthPercentageCount(85);
				v145 = 5;
			end
			if ((3574 <= 4397) and (7 == v145)) then
				if ((3135 > 1330) and v14:IsChanneling(v94.Spiritbloom)) then
					local v196 = 0;
					local v197;
					while true do
						if ((v196 == 0) or (3900 <= 3641)) then
							v197 = GetTime() - v14:CastStart();
							if ((1724 == 1724) and (v197 >= v14:EmpowerCastTime(v36))) then
								local v210 = 0;
								while true do
									if ((455 <= 1282) and (0 == v210)) then
										v10[LUAOBFUSACTOR_DECRYPT_STR_0("\11\147\25\69\26\223\58\151\25\72\46\201\29", "\186\78\227\112\38\73")] = v94[LUAOBFUSACTOR_DECRYPT_STR_0("\207\71\244\71\90\110\254\91\242\90\94", "\26\156\55\157\53\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\190\221\2\204\170\94\165\252", "\48\236\184\118\185\216")];
										return LUAOBFUSACTOR_DECRYPT_STR_0("\214\169\88\32\223\61\235\186\23\3\223\61\247\180\67\50\195\59\234\176", "\84\133\221\55\80\175");
									end
								end
							end
							break;
						end
					end
				end
				if ((4606 < 4876) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) then
					local v198 = 0;
					local v199;
					while true do
						if ((v198 == 0) or (1442 > 2640)) then
							v199 = v28.DeadFriendlyUnitsCount();
							if ((136 < 3668) and not v14:AffectingCombat()) then
								if ((v199 > 1) or (1784 > 4781)) then
									if ((4585 > 3298) and v26(v94.MassReturn, nil, true)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\176\230\55\181\248\78\184\243\49\180\201", "\60\221\135\68\198\167");
									end
								elseif (v26(v94.Return, not v15:IsInRange(30), true) or (1664 > 1698)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\252\184\236\150\80\215", "\185\142\221\152\227\34");
								end
							end
							break;
						end
					end
				end
				if (not v14:IsChanneling() or (3427 < 2849)) then
					if ((3616 <= 4429) and v14:AffectingCombat()) then
						local v201 = 0;
						local v202;
						while true do
							if ((3988 >= 66) and (v201 == 0)) then
								v202 = v121();
								if (v202 or (862 > 4644)) then
									return v202;
								end
								break;
							end
						end
					else
						local v203 = 0;
						local v204;
						while true do
							if ((1221 == 1221) and (v203 == 0)) then
								v204 = v122();
								if (v204 or (45 > 1271)) then
									return v204;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((3877 > 1530) and (v145 == 5)) then
				v101 = v14:GetEnemiesInRange(25);
				v102 = v15:GetEnemiesInSplashRange(8);
				if (v38 or (4798 == 1255)) then
					v103 = #v102;
				else
					v103 = 1;
				end
				v145 = 6;
			end
		end
	end
	local function v126()
		local v146 = 0;
		while true do
			if ((v146 == 0) or (2541 > 2860)) then
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\104\215\82\233\70\33\225\89\209\94\245\77\115\210\78\202\92\255\81\115\245\65\133\114\234\74\48\183\122\202\88\247\104", "\151\56\165\55\154\35\83"));
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\144\81\0\253\165\81\19\239\180\74\10\224\224\102\19\225\171\70\23\174\152\3\19\174\241\19\75\188\238\19\85\174\130\90\69\204\175\76\8\197", "\142\192\35\101"));
				v146 = 1;
			end
			if ((v146 == 2) or (2902 > 3629)) then
				v28[LUAOBFUSACTOR_DECRYPT_STR_0("\135\175\220\218\56\43\129\170\161\170\202\238\56\37\152\173\165\181", "\203\195\198\175\170\93\71\237")] = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableCurseDebuffs);
				break;
			end
			if ((427 < 3468) and (v146 == 1)) then
				v28[LUAOBFUSACTOR_DECRYPT_STR_0("\242\124\58\179\226\128\160\23\212\121\44\135\226\142\185\16\208\102", "\118\182\21\73\195\135\236\204")] = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableMagicDebuffs);
				v28[LUAOBFUSACTOR_DECRYPT_STR_0("\44\53\9\80\1\1\241\9\62\22\69\32\8\255\29\58\28\83", "\157\104\92\122\32\100\109")] = v12.MergeTable(v28.DispellableDebuffs, v28.DispellableDiseaseDebuffs);
				v146 = 2;
			end
		end
	end
	v21.SetAPL(1468, v125, v126);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\11\91\55\205\110\52\234\33\64\59\199\110\33\238\43\88\59\199\71\16\232\39\68\48\155\93\4\253", "\156\78\43\94\181\49\113")]();

