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
		if ((1 == v5) or (3647 < 1569)) then
			return v6(...);
		end
		if ((0 == v5) or (4046 >= 4927)) then
			v6 = v0[v4];
			if ((4623 >= 2787) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\158\209\17\218\198\201\26\194\190\209\31\194\215\218\49\239\180\201\80\221\214\218", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\159\37\2\49\118\177", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\210\53\233\83", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\204\82\179", "\38\156\55\199")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\155\109\121\36\31", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\48\171\212\210", "\84\121\223\177\191\237\76")];
	local v19 = EpicLib;
	local v20 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\152\87\218\180", "\161\219\54\169\192\90\48\80")];
	local v21 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\106\67\19\49\121\77\15\41\64\76\7", "\69\41\34\96")];
	local v22 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30\35\37\178\204\195\11\22\46\184", "\75\220\163\183\106\98")];
	local v23 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\33\187\152\35\234\23\189\140\50\202\22\191\143", "\185\98\218\235\87")];
	local v24 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\4\192\47\154\38", "\232\73\161\76")];
	local v26 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\81\121\123\101", "\135\108\174\62\18\30\23\147")];
	local v27 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\3\180", "\75\103\118\217")];
	local v28 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\228\91\125\25\182\16\212", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\56\37\146\173\22\242\205", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\225\170\194", "\174\103\142\197")];
	local v29 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\91\41\71", "\152\54\72\63\88\69\62")];
	local v30 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\241\210\225\87\209\214", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\124\91\19\40\52\249\19\76\87\10\39", "\114\56\62\101\73\71\141")];
	local v31 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\157\255\212\207\189\251", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\227\39\179\181\234\10\198\239\62\188", "\107\178\134\81\210\198\158")];
	local v32 = v25[LUAOBFUSACTOR_DECRYPT_STR_0("\29\24\141\205\175\42", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\231\10\148\246\217\215\14\150\254\197\205", "\170\163\111\226\151")];
	local v33 = {};
	local v34 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\50\63\191\53\65\57\58", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\164\58\200\0\254\142\34\200", "\135\225\76\173\114")];
	local v35 = false;
	local v36 = false;
	local v37 = false;
	local v38 = false;
	local v39 = false;
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
	local v67 = v13:GetEquipment();
	local v68 = (v67[13] and v18(v67[13])) or v18(0);
	local v69 = (v67[14] and v18(v67[14])) or v18(0);
	local v70;
	local v71;
	local v72;
	local v73 = ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\63\254\171\181\162\190\162\59\249\172\165\162\184\170\31\227\172", "\199\122\141\216\208\204\221")]:IsAvailable()) and 2) or 1;
	local v74 = 2;
	local v75, v76, v77;
	local v78;
	local v79, v80;
	local v81 = 4;
	local v82 = 13;
	local v83 = v30[LUAOBFUSACTOR_DECRYPT_STR_0("\143\209\17\227\108\208\184\207\30\241\123\243", "\150\205\189\112\144\24")]:TalentRank();
	local v84;
	local v85;
	local v86 = false;
	local v87 = 11111;
	local v88 = 11111;
	local v89;
	local v90;
	local v91 = 0;
	local v92 = 0;
	local v93 = 1;
	local v94 = 1;
	local v95;
	local function v96()
		local v110 = 0;
		local v111;
		local v112;
		while true do
			if ((2234 >= 1230) and (v110 == 1)) then
				v112 = nil;
				for v152, v153 in pairs(v111) do
					if ((v153:Exists() and (UnitGroupRolesAssigned(v152) == LUAOBFUSACTOR_DECRYPT_STR_0("\111\233\20\240\33\117", "\100\39\172\85\188"))) or (343 == 1786)) then
						v112 = v153;
					end
				end
				v110 = 2;
			end
			if ((2570 > 2409) and (v110 == 0)) then
				v111 = nil;
				if (UnitInRaid(LUAOBFUSACTOR_DECRYPT_STR_0("\53\136\190\85\1\154", "\112\69\228\223\44\100\232\113")) or (2609 >= 3234)) then
					v111 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\230\30\14\215", "\230\180\127\103\179\214\28")];
				elseif (UnitInParty(LUAOBFUSACTOR_DECRYPT_STR_0("\156\9\94\95\225\83", "\128\236\101\63\38\132\33")) or (3033 >= 4031)) then
					v111 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\156\168\3\80\175", "\175\204\201\113\36\214\139")];
				else
					return false;
				end
				v110 = 1;
			end
			if ((v110 == 2) or (1401 == 4668)) then
				return v112;
			end
		end
	end
	v10:RegisterForEvent(function()
		local v113 = 0;
		while true do
			if ((2776 >= 1321) and (v113 == 0)) then
				v67 = v13:GetEquipment();
				v68 = (v67[13] and v18(v67[13])) or v18(0);
				v113 = 1;
			end
			if ((v113 == 1) or (487 > 2303)) then
				v69 = (v67[14] and v18(v67[14])) or v18(0);
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\157\84\152\185\22\159\71\156\177\6\132\72\148\165\29\153\71\154\168\18\131\95\156\164", "\83\205\24\217\224"));
	v10:RegisterForEvent(function()
		local v114 = 0;
		while true do
			if ((v114 == 0) or (4503 == 3462)) then
				v73 = ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\195\214\222\56\232\198\200\28\242\209\216\51\227\200\200\51\242", "\93\134\165\173")]:IsAvailable()) and 2) or 1;
				v83 = v30[LUAOBFUSACTOR_DECRYPT_STR_0("\156\254\192\209\46\232\167\108\176\243\194\199", "\30\222\146\161\162\90\174\210")]:TalentRank();
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\214\126\85\38\201\125\79\41\205\111\94\45\192\106", "\106\133\46\16"), LUAOBFUSACTOR_DECRYPT_STR_0("\116\5\82\206\116\101\124\31\64\204\127\108\116\31\90\210\101\116\121\2", "\32\56\64\19\156\58"));
	v10:RegisterForEvent(function()
		local v115 = 0;
		local v116;
		while true do
			if ((553 <= 1543) and (v115 == 0)) then
				v116 = false;
				v87 = 11111;
				v115 = 1;
			end
			if ((2015 == 2015) and (v115 == 1)) then
				v88 = 11111;
				for v154 in pairs(v26.FirestormTracker) do
					v26[LUAOBFUSACTOR_DECRYPT_STR_0("\124\193\247\83\73\230\143\72\197\209\68\91\241\139\95\218", "\224\58\168\133\54\58\146")][v154] = nil;
				end
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\105\122\106\196\80\180\184\57\124\113\110\211\74\163\169\42\123\122\110\217", "\107\57\54\43\157\21\230\231"));
	local function v97()
		local v117 = 0;
		while true do
			if ((1 == v117) or (4241 <= 2332)) then
				return false;
			end
			if ((v117 == 0) or (2364 < 1157)) then
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\253\130\3\240\170\200\192\201\134", "\175\187\235\113\149\217\188")]:TimeSinceLastCast() > 12) or (1167 > 1278)) then
					return false;
				end
				if (v26[LUAOBFUSACTOR_DECRYPT_STR_0("\26\166\147\73\240\109\119\46\162\181\94\226\122\115\57\189", "\24\92\207\225\44\131\25")][v14:GUID()] or (1145 <= 1082)) then
					if ((v26[LUAOBFUSACTOR_DECRYPT_STR_0("\109\218\170\73\8\105\68\193\181\120\9\124\72\216\189\94", "\29\43\179\216\44\123")][v14:GUID()] > (GetTime() - 2.5)) or (3105 == 4881)) then
						return true;
					end
				end
				v117 = 1;
			end
		end
	end
	local function v98()
		local v118 = 0;
		while true do
			if ((v118 == 1) or (1887 > 4878)) then
				v85 = 1 * v84;
				if (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\4\81\37\221\205\0\233\48\85", "\134\66\56\87\184\190\116")]:IsCastable() or (4087 > 4116)) then
					if ((1106 <= 1266) and v24(v30.Firestorm, not v14:IsInRange(25), v90)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\56\27\190\10\255\46\39\49\113\25\169\28\232\46\56\62\48\29", "\85\92\81\105\219\121\139\65");
					end
				end
				v118 = 2;
			end
			if ((3155 < 4650) and (v118 == 2)) then
				if ((3774 >= 1839) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\209\186\70\76\114\216\219\191\81\72\121", "\191\157\211\48\37\28")]:IsCastable() and not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\249\22\230\25\41\203\16\230\17", "\90\191\127\148\124")]:IsAvailable()) then
					if ((2811 == 2811) and v24(v30.LivingFlame, not v14:IsInRange(25), v90)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\116\142\56\30\118\128\17\17\116\134\35\18\56\151\60\18\123\136\35\21\121\147", "\119\24\231\78");
					end
				end
				if ((2146 > 1122) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\163\55\176\88\217\115\5\144\36\174\79", "\113\226\77\197\42\188\32")]:IsCastable()) then
					if (v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike)) or (56 == 3616)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\12\225\167\63\41\231\161\40\31\255\176\122\6\230\176\57\25\249\183\59\2", "\213\90\118\148");
					end
				end
				break;
			end
			if ((v118 == 0) or (2421 < 622)) then
				if ((1009 <= 1130) and (v65 == LUAOBFUSACTOR_DECRYPT_STR_0("\156\204\52\67", "\44\221\185\64"))) then
					if ((2758 < 2980) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\50\232\93\77\112\4\232\78\114\114\6\238\75", "\19\97\135\40\63")]:IsCastable() and v15:IsInRange(25) and (v95 == v15:GUID()) and (v15:BuffRemains(v30.SourceofMagicBuff) < 300)) then
						if (v20(v32.SourceofMagicFocus) or (86 >= 3626)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\189\83\38\41\44\52\145\83\53\4\34\48\169\85\48\123\63\35\171\95\60\54\45\48\186", "\81\206\60\83\91\79");
						end
					end
				end
				if ((2395 == 2395) and (v65 == LUAOBFUSACTOR_DECRYPT_STR_0("\125\174\220\119\44\215\72\160", "\196\46\203\176\18\79\163\45"))) then
					local v157 = 0;
					local v158;
					while true do
						if ((3780 > 2709) and (0 == v157)) then
							v158 = v34.NamedUnit(25, v66);
							if ((v158 and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\139\45\107\12\39\254\224\190\15\127\25\45\248", "\143\216\66\30\126\68\155")]:IsCastable() and (v158:BuffRemains(v30.SourceofMagicBuff) < 300)) or (237 >= 2273)) then
								if (v20(v32.SourceofMagicName) or (2040 <= 703)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\185\199\24\217\198\166\232\238\172\247\0\202\194\170\212\161\186\218\8\200\202\174\213\224\190", "\129\202\168\109\171\165\195\183");
								end
							end
							break;
						end
					end
				end
				v118 = 1;
			end
		end
	end
	local function v99()
		local v119 = 0;
		while true do
			if ((3279 <= 3967) and (v119 == 1)) then
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\136\81\184\69\173\93\184\71\152\88\183\90\191", "\32\218\52\214")]:IsCastable() and (v13:HealthPercentage() < v59) and v58) or (1988 == 877)) then
					if ((4291 > 1912) and v20(v30.RenewingBlaze, nil, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\124\18\63\173\230\185\75\93\108\27\48\178\244\240\72\91\71\25\113\254", "\58\46\119\81\200\145\208\37");
					end
				end
				if ((2003 < 2339) and v44 and (v13:HealthPercentage() <= v46)) then
					if ((432 == 432) and (v45 == LUAOBFUSACTOR_DECRYPT_STR_0("\25\137\54\190\172\174\62\34\130\55\236\129\184\55\39\133\62\171\233\141\57\63\133\63\162", "\86\75\236\80\204\201\221"))) then
						if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\64\68\113\151\251\152\122\72\121\130\214\142\115\77\126\139\249\187\125\85\126\138\240", "\235\18\33\23\229\158")]:IsReady() or (1145 >= 1253)) then
							if ((3418 > 2118) and v24(v32.RefreshingHealingPotion, nil, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\66\191\199\169\85\169\201\178\94\189\129\179\85\187\205\178\94\189\129\171\95\174\200\180\94\250\197\190\86\191\207\168\89\172\196\251\4", "\219\48\218\161");
							end
						end
					end
				end
				break;
			end
			if ((3066 <= 3890) and (v119 == 0)) then
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\116\44\167\95\73\82\47\186\101\78\90\34\177\69", "\45\59\78\212\54")]:IsCastable() and v13:BuffDown(v30.ObsidianScales) and (v13:HealthPercentage() < v61) and v60) or (2998 >= 3281)) then
					if (v24(v30.ObsidianScales) or (4649 <= 2632)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\84\144\130\130\39\172\254\47\69\128\138\138\43\190\176\20\83\133\142\136\61\164\230\21\69", "\144\112\54\227\235\230\78\205");
					end
				end
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\155\45\14\240\196\83\160\60\0\242\213", "\59\211\72\111\156\176")]:IsReady() and v50 and (v13:HealthPercentage() <= v51)) or (3860 > 4872)) then
					if (v24(v32.Healthstone, nil, nil, true) or (3998 == 2298)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\130\226\33\90\143\240\57\65\137\230\109\74\130\229\40\64\148\234\59\75\199\176", "\77\46\231\131");
					end
				end
				v119 = 1;
			end
		end
	end
	local function v100()
		if ((v79 and ((v72 >= 3) or v13:BuffDown(v30.SpoilsofNeltharusVers) or ((v80 + (4 * v27(v30[LUAOBFUSACTOR_DECRYPT_STR_0("\193\101\121\91\213\70\244\253\66\105\91\220\74", "\128\132\17\28\41\187\47")]:CooldownRemains() <= ((v89 * 2) + v27(v30[LUAOBFUSACTOR_DECRYPT_STR_0("\39\59\20\63\127\19\55\7\46\85", "\61\97\82\102\90")]:CooldownRemains() <= (v89 * 2)))))) <= 18))) or (v88 <= 20) or (8 >= 2739)) then
			local v131 = 0;
			while true do
				if ((2590 == 2590) and (0 == v131)) then
					ShouldReturn = v34.HandleTopTrinket(v33, v37, 40, nil);
					if (ShouldReturn or (82 >= 1870)) then
						return ShouldReturn;
					end
					v131 = 1;
				end
				if ((2624 < 4557) and (v131 == 1)) then
					ShouldReturn = v34.HandleBottomTrinket(v33, v37, 40, nil);
					if (ShouldReturn or (3131 > 3542)) then
						return ShouldReturn;
					end
					break;
				end
			end
		end
	end
	local function v101()
		local v120 = 0;
		while true do
			if ((2577 >= 1578) and (v120 == 1)) then
				v93 = v91;
				if ((4103 <= 4571) and v24(v30.EternitySurge, not v14:IsInRange(30), true)) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\242\231\57\192\249\250\40\203\200\224\41\192\240\246\124\215\250\227\51\197\242\225\124", "\178\151\147\92") .. v91;
				end
				break;
			end
			if ((v120 == 0) or (1495 == 4787)) then
				if (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\137\58\174\89\201\94\10\16\159\59\185\76\194", "\105\204\78\203\43\167\55\126")]:CooldownDown() or (310 > 4434)) then
					return nil;
				end
				if ((2168 <= 4360) and ((v72 <= (1 + v27(v30[LUAOBFUSACTOR_DECRYPT_STR_0("\128\190\38\12\29\13\211\72\182\153\51\31\29", "\49\197\202\67\126\115\100\167")]:IsAvailable()))) or ((v80 < (1.75 * v84)) and (v80 >= (1 * v84))) or (v79 and ((v72 == 5) or (not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\18\79\218\59\142\95\74\46\72\236\57\129\88", "\62\87\59\191\73\224\54")]:IsAvailable() and (v72 >= 6)) or (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\194\22\255\219\233\11\238\208\244\49\234\200\233", "\169\135\98\154")]:IsAvailable() and (v72 >= 8)))))) then
					v91 = 1;
				elseif ((994 == 994) and ((v72 <= (2 + (2 * v27(v30[LUAOBFUSACTOR_DECRYPT_STR_0("\238\99\33\70\243\58\220\210\100\23\68\252\61", "\168\171\23\68\52\157\83")]:IsAvailable())))) or ((v80 < (2.5 * v84)) and (v80 >= (1.75 * v84))))) then
					v91 = 2;
				elseif ((1655 > 401) and ((v72 <= (3 + (3 * v27(v30[LUAOBFUSACTOR_DECRYPT_STR_0("\209\101\240\191\43\36\147\237\98\198\189\36\35", "\231\148\17\149\205\69\77")]:IsAvailable())))) or not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\166\168\201\239\88\249\173\166\192\242\84", "\159\224\199\167\155\55")]:IsAvailable() or ((v80 <= (3.25 * v84)) and (v80 >= (2.5 * v84))))) then
					v91 = 3;
				else
					v91 = 4;
				end
				v120 = 1;
			end
		end
	end
	local function v102()
		local v121 = 0;
		local v122;
		while true do
			if ((3063 <= 3426) and (v121 == 0)) then
				if ((1459 > 764) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\170\244\94\55\48\94\127\141\233\68", "\26\236\157\44\82\114\44")]:CooldownDown()) then
					return nil;
				end
				v122 = v14:DebuffRemains(v30.FireBreath);
				v121 = 1;
			end
			if ((v121 == 1) or (641 > 4334)) then
				if ((3399 >= 2260) and ((v79 and (v72 <= 2)) or ((v72 == 1) and not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\15\56\208\73\40\59\199\85\35\32\210\125\38\47\216\94", "\59\74\78\181")]:IsAvailable()) or ((v80 < (1.75 * v84)) and (v80 >= (1 * v84))))) then
					v92 = 1;
				elseif ((not v97() and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\0\199\95\72\177\48\195\84\83\189\34\247\86\91\190\32", "\211\69\177\58\58")]:IsAvailable() and (v72 <= 3)) or ((v72 == 2) and not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\146\243\124\231\235\222\165\235\112\251\238\237\187\228\116\240", "\171\215\133\25\149\137")]:IsAvailable()) or ((v80 < (2.5 * v84)) and (v80 >= (1.75 * v84))) or (393 >= 4242)) then
					v92 = 2;
				elseif ((989 < 4859) and (not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\199\199\60\238\224\54\209\67\230\193\49", "\34\129\168\82\154\143\80\156")]:IsAvailable() or (v97() and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\160\164\54\25\74\91\155\139\187\61\12\110\66\136\136\183", "\233\229\210\83\107\40\46")]:IsAvailable() and (v72 <= 3)) or ((v80 <= (3.25 * v84)) and (v80 >= (2.5 * v84))))) then
					v92 = 3;
				else
					v92 = 4;
				end
				v94 = v92;
				v121 = 2;
			end
			if ((v121 == 2) or (4795 < 949)) then
				if ((3842 == 3842) and v22(v30.FireBreath, false, "1", not v14:IsInRange(30), nil)) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\199\75\32\211\58\195\80\55\215\17\201\2\55\219\21\206\85\55\196\69", "\101\161\34\82\182") .. v92 .. LUAOBFUSACTOR_DECRYPT_STR_0("\168\0\88\247\213\162\211\124", "\78\136\109\57\158\187\130\226");
				end
				break;
			end
		end
	end
	local function v103()
		local v123 = 0;
		while true do
			if ((1747 <= 3601) and (2 == v123)) then
				if (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\21\91\64\243\234\39\93\64\251", "\153\83\50\50\150")]:IsCastable() or (804 > 4359)) then
					if ((4670 >= 3623) and v24(v30.Firestorm, not v14:IsInRange(25), v90)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\127\97\25\96\191\66\79\123\51\29\124\174\13\12\38", "\45\61\22\19\124\19\203");
					end
				end
				if ((2065 < 2544) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\241\11\31\240", "\217\161\114\109\149\98\16")]:IsReady() and ((v72 >= 5) or ((v72 >= 4) and ((v13:BuffDown(v30.EssenceBurstBuff) and v13:BuffDown(v30.IridescenceBlueBuff)) or not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\55\52\61\110\178\125\6\57\43\79\172\117\28", "\20\114\64\88\28\220")]:IsAvailable())) or ((v72 >= 4) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\7\14\222\181\236\217\177\56\21\203", "\221\81\97\178\212\152\176")]:IsAvailable()) or ((v72 >= 3) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\251\232\17\250\14\196\235\20\239\3", "\122\173\135\125\155")]:IsAvailable() and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\167\201\1\171\56\52\204\166\205\1\170\43", "\168\228\161\96\217\95\81")]:IsAvailable() and v13:BuffDown(v30.EssenceBurstBuff) and v13:BuffDown(v30.IridescenceBlueBuff)) or ((v72 >= 3) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\237\222\34\93\59\94\215\216\58\69", "\55\187\177\78\60\79")]:IsAvailable() and not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\14\198\94\249\65\202\132\15\194\94\248\82", "\224\77\174\63\139\38\175")]:IsAvailable() and (v13:BuffUp(v30.IridescenceRedBuff) or v13:BuffDown(v30.EssenceBurstBuff))) or (v13:BuffStack(v30.ChargedBlastBuff) >= 15))) then
					if ((1311 <= 3359) and v24(v30.Pyre, not v14:IsSpellInRange(v30.Pyre))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\148\88\74\43\196\64\87\43\196\16\12", "\78\228\33\56");
					end
				end
				if ((2717 <= 3156) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\226\119\164\10\139\201\88\190\2\136\203", "\229\174\30\210\99")]:IsCastable() and v13:BuffUp(v30.BurnoutBuff) and v13:BuffUp(v30.LeapingFlamesBuff) and v13:BuffDown(v30.EssenceBurstBuff) and (v13:Essence() < (v13:EssenceMax() - 1))) then
					if ((1081 < 4524) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\228\144\88\227\58\6\29\225\135\92\232\125\56\20\232\198\0\185", "\89\123\141\230\49\141\93");
					end
				end
				v123 = 3;
			end
			if ((440 >= 71) and (v123 == 1)) then
				if ((4934 > 2607) and (v79 or not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\106\2\54\125\65\30\37\123\73\21", "\26\46\112\87")]:IsAvailable() or ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\157\49\170\115\176\177\87\181\190\38", "\212\217\67\203\20\223\223\37")]:CooldownRemains() > v81) and ((v13:BuffRemains(v30.PowerSwellBuff) < v85) or (not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\140\130\164\211\174\132\164\219\174\148", "\178\218\237\200")]:IsAvailable() and (v72 == 3))) and (v13:BuffRemains(v30.BlazingShardsBuff) < v85) and ((v14:TimeToDie() >= 8) or (v88 < 30))))) then
					local v159 = 0;
					local v160;
					while true do
						if ((v159 == 0) or (1400 > 3116)) then
							v160 = v101();
							if ((525 < 1662) and v160) then
								return v160;
							end
							break;
						end
					end
				end
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\146\176\227\192\148\167\227\209\162\189", "\176\214\213\134")]:IsCastable() and v37 and not v79 and (v13:EssenceDeficit() > 3) and v34.TargetIsMouseover()) or (876 > 2550)) then
					if ((219 <= 2456) and v24(v32.DeepBreathCursor, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\168\179\196\151\84\75\241\172\162\220\232\87\86\241\237\224", "\57\148\205\214\180\200\54");
					end
				end
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\33\245\52\32\98\23\239\60\58\113\33\233\52\38", "\22\114\157\85\84")]:IsCastable() and ((v13:BuffStack(v30.EssenceBurstBuff) < v73) or not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\229\217\16\197\83\243\158\205\204\28\214", "\200\164\171\115\164\61\150")]:IsAvailable())) or (4219 == 1150)) then
					if (v24(v30.ShatteringStar, not v14:IsSpellInRange(v30.ShatteringStar)) or (2989 <= 222)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\252\2\81\151\187\230\10\75\132\129\231\23\68\145\254\245\12\64\195\230", "\227\222\148\99\37");
					end
				end
				v123 = 2;
			end
			if ((2258 > 1241) and (v123 == 3)) then
				if ((41 < 4259) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\215\120\229\5\30\94\246\118\228\13\4\79", "\42\147\17\150\108\112")]:IsReady()) then
					if (v24(v30.Disintegrate, not v14:IsSpellInRange(v30.Disintegrate), v90) or (1930 < 56)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\11\175\62\118\233\252\10\161\63\126\243\237\79\167\34\122\167\186\95", "\136\111\198\77\31\135");
					end
				end
				if ((3333 == 3333) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\46\0\177\95\179\227\49\165\3\4\162", "\201\98\105\199\54\221\132\119")]:IsCastable() and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\138\2\130\49\4\60\190\188", "\204\217\108\227\65\98\85")]:IsAvailable() and v13:BuffUp(v30.BurnoutBuff)) then
					if (v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90) or (2225 == 20)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\202\227\236\34\199\97\197\249\228\33\197\30\194\250\224\108\146\12", "\160\62\163\149\133\76");
					end
				end
				if (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\247\186\24\61\198\229\180\31\38\200\211", "\163\182\192\109\79")]:IsCastable() or (872 >= 3092)) then
					if ((4404 >= 3252) and v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\60\21\210\240\11\53\20\210\252\63\35\64\193\250\49\102\82\148", "\149\84\70\96\160");
					end
				end
				break;
			end
			if ((1107 > 796) and (v123 == 0)) then
				if ((959 == 959) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\26\45\248\246\49\49\235\240\57\58", "\145\94\95\153")]:IsCastable() and Cds and ((v14:TimeToDie() >= 32) or (v88 < 30))) then
					if (v24(v30.Dragonrage) or (245 >= 2204)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\223\21\210\65\185\239\204\19\208\14\182\242\200\84\135", "\215\157\173\116\181\46");
					end
				end
				if ((3162 >= 2069) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\1\189\155\198\210\48\135\136\243\214\48\167", "\186\85\212\235\146")]:IsCastable() and v37 and v79 and ((v72 <= (3 + (3 * v27(v30[LUAOBFUSACTOR_DECRYPT_STR_0("\231\149\19\236\55\231\76\219\146\37\238\56\224", "\56\162\225\118\158\89\142")]:IsAvailable())))) or v30[LUAOBFUSACTOR_DECRYPT_STR_0("\122\12\210\170\0\202\89\4\212\167", "\184\60\101\160\207\66")]:CooldownDown())) then
					if (v24(v30.TipTheScales) or (306 > 3081)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\139\108\131\37\138\121\131\34\129\125\176\52\145\60\189\62\135\60\232", "\220\81\226\28");
					end
				end
				if (((not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\55\199\131\252\229\201\1\212\133\254", "\167\115\181\226\155\138")]:IsAvailable() or (v78 > v81) or not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\195\44\238\81\116\98\207\246\59", "\166\130\66\135\60\27\17")]:IsAvailable()) and ((((v13:BuffRemains(v30.PowerSwellBuff) < v85) or (not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\114\69\194\116\36\77\70\199\97\41", "\80\36\42\174\21")]:IsAvailable() and (v72 == 3))) and (v13:BuffRemains(v30.BlazingShardsBuff) < v85)) or v79) and ((v14:TimeToDie() >= 8) or (v88 < 30))) or (3513 < 2706)) then
					local v161 = 0;
					local v162;
					while true do
						if ((2978 < 3639) and (v161 == 0)) then
							v162 = v102();
							if ((3682 >= 2888) and v162) then
								return v162;
							end
							break;
						end
					end
				end
				v123 = 1;
			end
		end
	end
	local function v104()
		local v124 = 0;
		while true do
			if ((149 < 479) and (3 == v124)) then
				if ((1020 >= 567) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\21\161\90\17\206\229\40\53\169\65\29", "\110\89\200\44\120\160\130")]:IsCastable() and v79 and (v80 < ((v73 - v13:BuffStack(v30.EssenceBurstBuff)) * v89)) and v13:BuffUp(v30.BurnoutBuff)) then
					if (v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90) or (733 > 2469)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\167\202\93\79\77\77\4\75\167\194\70\67\3\89\47\13\250\149", "\45\203\163\43\38\35\42\91");
					end
				end
				if ((2497 == 2497) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\243\159\201\49\130\154\64\192\140\215\38", "\52\178\229\188\67\231\201")]:IsCastable() and v79 and (v80 < ((v73 - v13:BuffStack(v30.EssenceBurstBuff)) * v89))) then
					if ((3901 == 3901) and v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\32\91\69\22\242\99\48\53\83\89\15\242\28\48\53\1\1\92", "\67\65\33\48\100\151\60");
					end
				end
				if ((201 < 415) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\243\238\184\209\253\216\193\162\217\254\218", "\147\191\135\206\184")]:IsCastable() and v13:BuffUp(v30.BurnoutBuff) and ((v13:BuffUp(v30.LeapingFlamesBuff) and v13:BuffDown(v30.EssenceBurstBuff)) or (v13:BuffDown(v30.LeapingFlamesBuff) and (v13:BuffStack(v30.EssenceBurstBuff) < v73))) and (v13:Essence() < (v13:EssenceMax() - 1))) then
					if (v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90) or (133 == 1784)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\136\33\176\200\214\84\141\130\36\167\204\221\19\161\144\104\244\145", "\210\228\72\198\161\184\51");
					end
				end
				v124 = 4;
			end
			if ((v124 == 6) or (7 >= 310)) then
				if ((4992 > 286) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\130\86\148\14\185\60\183\94\136\23\185", "\111\195\44\225\124\220")]:IsCastable()) then
					if (v24(v30.AzureStrike, not v14:IsSpellInRange(v30.AzureStrike)) or (2561 == 3893)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\217\92\21\97\174\148\203\82\18\122\160\174\152\85\20\51\248\255", "\203\184\38\96\19\203");
					end
				end
				break;
			end
			if ((4362 >= 1421) and (v124 == 4)) then
				if ((75 <= 3546) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\6\80\225\21", "\174\86\41\147\112\19")]:IsReady() and v97() and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\105\1\138\2\43\8\56\165\93\5\159\5\42", "\203\59\96\237\107\69\111\113")]:IsAvailable() and (v13:BuffStack(v30.ChargedBlastBuff) == 20) and (v72 >= 2)) then
					if ((2680 <= 3418) and v24(v30.Pyre, not v14:IsSpellInRange(v30.Pyre))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\15\190\228\113\227\195\100\68\254", "\183\68\118\204\129\81\144");
					end
				end
				if (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\42\164\99\237\5\150\11\170\98\229\31\135", "\226\110\205\16\132\107")]:IsReady() or (4288 < 2876)) then
					if ((2462 >= 1147) and v24(v30.Disintegrate, not v14:IsSpellInRange(v30.Disintegrate), v90)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\239\202\243\208\79\255\198\231\203\64\255\198\160\202\85\171\145\180", "\33\139\163\128\185");
					end
				end
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\113\81\22\219\68\76\11\204\90", "\190\55\56\100")]:IsCastable() and not v79 and v14:DebuffDown(v30.ShatteringStar)) or (4914 < 2480)) then
					if (v24(v30.Firestorm, not v14:IsInRange(25), v90) or (1559 == 1240)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\166\46\27\0\247\252\68\162\124\13\7\163\161\0", "\147\54\207\92\126\115\131");
					end
				end
				v124 = 5;
			end
			if ((566 == 566) and (v124 == 2)) then
				if ((3921 >= 3009) and (not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\202\229\163\55\225\249\176\49\233\242", "\80\142\151\194")]:IsAvailable() or (v78 > v82) or not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\34\200\126\65\12\213\126\88\26", "\44\99\166\23")]:IsAvailable()) and ((v13:BuffRemains(v30.BlazingShardsBuff) < v85) or v79) and ((v14:TimeToDie() >= 8) or (v88 < 30))) then
					local v163 = 0;
					local v164;
					while true do
						if ((2063 >= 1648) and (v163 == 0)) then
							v164 = v101();
							if ((1066 >= 452) and v164) then
								return v164;
							end
							break;
						end
					end
				end
				if ((4974 >= 2655) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\93\249\32\59\60\183\117\227\48", "\196\28\151\73\86\83")]:IsAvailable() and v79 and (v80 < (v89 + (v85 * v27(v13:BuffDown(v30.TipTheScales))))) and ((v80 - v30[LUAOBFUSACTOR_DECRYPT_STR_0("\213\10\59\21\160\74\29\119\231\11", "\22\147\99\73\112\226\56\120")]:CooldownRemains()) >= (v85 * v27(v13:BuffDown(v30.TipTheScales))))) then
					if (v24(v30.Pool) or (2721 <= 907)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\143\116\235\225\205\190\122\240\181\171\154\53\241\225\205\233\39", "\237\216\21\130\149");
					end
				end
				if ((4437 >= 3031) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\163\64\86\82\191\218\87\150\87", "\62\226\46\63\63\208\169")]:IsAvailable() and v79 and (v80 < (v89 + v85)) and ((v80 - v30[LUAOBFUSACTOR_DECRYPT_STR_0("\192\13\80\145\17\4\59\71\214\12\71\132\26", "\62\133\121\53\227\127\109\79")]:CooldownRemains()) > (v85 * v27(v13:BuffDown(v30.TipTheScales))))) then
					if (v24(v30.Pool) or (4470 < 2949)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\21\59\225\150\168\173\2\84\23\198\150\189\182\80\69\102", "\194\112\116\82\149\182\206");
					end
				end
				v124 = 3;
			end
			if ((v124 == 0) or (1580 == 2426)) then
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\30\15\31\232\43\18\2\255\53", "\141\88\102\109")]:IsCastable() and (v13:BuffUp(v30.SnapfireBuff))) or (3711 == 503)) then
					if (v24(v30.Firestorm, not v14:IsInRange(25), v90) or (420 == 4318)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\181\90\216\117\9\41\90\211\190\19\217\100\90\105", "\161\211\51\170\16\122\93\53");
					end
				end
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\223\188\179\47\244\160\160\41\252\171", "\72\155\206\210")]:IsCastable() and v37 and (((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\96\115\70\11\17\84\127\85\26\59", "\83\38\26\52\110")]:CooldownRemains() < v89) and (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\125\3\34\84\86\30\51\95\107\2\53\65\93", "\38\56\119\71")]:CooldownRemains() < (2 * v89))) or (v88 < 30))) or (4158 <= 33)) then
					if (v24(v30.Dragonrage) or (99 > 4744)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\247\253\89\209\42\88\225\238\95\211\101\69\231\175\14", "\54\147\143\56\182\69");
					end
				end
				if ((4341 == 4341) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\226\136\239\125\215\211\178\252\72\211\211\146", "\191\182\225\159\41")]:IsCastable() and v37 and ((v79 and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\14\6\45\71\133\142\214\50\33\61\71\140\130", "\162\75\114\72\53\235\231")]:CooldownUp() and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\170\53\86\231\113\16\137\61\80\234", "\98\236\92\36\130\51")]:CooldownDown() and not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\129\15\9\168\71\189\167\62\173\23\11\156\73\169\184\53", "\80\196\121\108\218\37\200\213")]:IsAvailable()) or (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\37\101\7\109\73\27\152\14\122\12\120\109\2\139\13\118", "\234\96\19\98\31\43\110")]:IsAvailable() and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\32\22\64\194\142\96\142\7\11\90", "\235\102\127\50\167\204\18")]:CooldownUp()))) then
					if ((255 <= 1596) and v24(v30.TipTheScales)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\168\229\28\80\38\85\158\230\32\69\34\85\178\181\48\80\110\8", "\78\48\193\149\67\36");
					end
				end
				v124 = 1;
			end
			if ((5 == v124) or (4433 < 1635)) then
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\41\52\48\109\47\108\8\48\33\117", "\30\109\81\85\29\109")]:IsCastable() and v37 and not v79 and (v72 >= 2) and v34.TargetIsMouseover()) or (4300 < 3244)) then
					if (v24(v32.DeepBreathCursor, not v14:IsInRange(30)) or (3534 > 4677)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\116\81\166\9\220\238\250\112\64\190\118\205\232\191\35\12", "\156\159\17\52\214\86\190");
					end
				end
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\138\234\184\172\140\253\184\189\186\231", "\220\206\143\221")]:IsCastable() and v37 and not v79 and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\175\112\32\30\214\201\220\146\89\40\4\204\222\199\133\105\36\24\214", "\178\230\29\77\119\184\172")]:IsAvailable() and v14:DebuffDown(v30.ShatteringStar) and v34.TargetIsMouseover()) or (4859 < 2999)) then
					if ((4726 > 2407) and v24(v32.DeepBreathCursor, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\241\187\15\11\72\250\231\187\11\15\127\184\230\170\74\72\39", "\152\149\222\106\123\23");
					end
				end
				if (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\241\47\224\74\187\218\0\250\66\184\216", "\213\189\70\150\35")]:IsCastable() or (1284 > 3669)) then
					if ((1117 < 2549) and v24(v30.LivingFlame, not v14:IsSpellInRange(v30.LivingFlame), v90)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\92\98\1\65\82\75\14\67\84\121\13\15\70\96\72\28\7", "\104\47\53\20");
					end
				end
				v124 = 6;
			end
			if ((1 == v124) or (2851 > 4774)) then
				if ((1031 < 3848) and (not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\20\12\129\31\78\62\12\129\31\68", "\33\80\126\224\120")]:IsAvailable() or (v78 > v82) or not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\205\166\10\201\83\255\161\23\221", "\60\140\200\99\164")]:IsAvailable()) and ((v13:BuffRemains(v30.BlazingShardsBuff) < v85) or v79) and ((v14:TimeToDie() >= 8) or (v88 < 30))) then
					local v165 = 0;
					local v166;
					while true do
						if ((1854 > 903) and (v165 == 0)) then
							v166 = v102();
							if ((4663 > 1860) and v166) then
								return v166;
							end
							break;
						end
					end
				end
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\163\253\23\47\172\147\241\3\52\163\147\241", "\194\231\148\100\70")]:IsReady() and (v80 > 19) and (v30[LUAOBFUSACTOR_DECRYPT_STR_0("\96\69\211\166\212\218\67\77\213\171", "\168\38\44\161\195\150")]:CooldownRemains() > 28) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\165\229\135\121\54\193\184\16\137\242\139\98\41", "\118\224\156\226\22\80\136\214")]:IsAvailable() and v13:HasTier(30, 2)) or (3053 <= 469)) then
					if (v20(v30.Disintegrate, nil, nil, not v14:IsSpellInRange(v30.Disintegrate)) or (540 >= 1869)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\231\74\137\76\250\92\135\80\239\77\133\2\253\77\192\27", "\224\34\142\57");
					end
				end
				if ((3292 == 3292) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\237\175\196\201\103\244\79\7\208\160\246\201\114\227", "\110\190\199\165\189\19\145\61")]:IsCastable() and ((v13:BuffStack(v30.EssenceBurstBuff) < v73) or not v30[LUAOBFUSACTOR_DECRYPT_STR_0("\251\249\116\233\133\194\236\226\112\231\153", "\167\186\139\23\136\235")]:IsAvailable())) then
					if ((1038 <= 2645) and v24(v30.ShatteringStar, not v14:IsSpellInRange(v30.ShatteringStar))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\189\137\25\14\176\154\4\20\178\183\30\14\180\154\77\9\161\200\92\74", "\109\122\213\232");
					end
				end
				v124 = 2;
			end
		end
	end
	local function v105()
		local v125 = 0;
		while true do
			if ((v125 == 1) or (3230 < 2525)) then
				if ((v41 == LUAOBFUSACTOR_DECRYPT_STR_0("\248\86\15\52\28\202\239\172\198\86\23", "\227\168\58\110\77\121\184\207")) or (2400 > 4083)) then
					if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\94\49\186\82\176\215\117\135\119\51\172\83\190\214", "\197\27\92\223\32\209\187\17")]:IsReady() and (v13:HealthPercentage() < v43)) or (2745 > 4359)) then
						if ((172 <= 1810) and v20(v32.EmeraldBlossomPlayer, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\6\82\198\233\2\83\199\196\1\83\204\232\16\80\206\187\14\94\202\245\67\11\145", "\155\99\63\163");
						end
					end
				end
				if ((v41 == LUAOBFUSACTOR_DECRYPT_STR_0("\167\199\164\159\160\139\140\212", "\228\226\177\193\237\217")) or (492 >= 4959)) then
					if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\17\189\38\244\53\188\39\196\56\191\48\245\59\189", "\134\84\208\67")]:IsReady() and (v15:HealthPercentage() < v43)) or (756 == 2072)) then
						if ((1605 <= 4664) and v20(v32.EmeraldBlossomFocus, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\22\161\131\78\18\160\130\99\17\160\137\79\0\163\139\28\30\173\143\82\83\248\212", "\60\115\204\230");
						end
					end
				end
				break;
			end
			if ((1816 == 1816) and (v125 == 0)) then
				if ((v40 == LUAOBFUSACTOR_DECRYPT_STR_0("\9\127\120\88\203\43\51\86\79\194\32", "\174\89\19\25\33")) or (621 > 3100)) then
					if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\25\23\64\74\246\137\31\10\31\80\92\246\132\14", "\107\79\114\50\46\151\231")]:IsReady() and (v13:HealthPercentage() < v42)) or (1157 >= 4225)) then
						if (v20(v32.VerdantEmbracePlayer, nil) or (4986 == 4138)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\47\163\167\45\139\55\163\255\60\171\183\59\139\58\178\128\52\167\188\39\202\109\231", "\160\89\198\213\73\234\89\215");
						end
					end
				end
				if ((v40 == LUAOBFUSACTOR_DECRYPT_STR_0("\109\103\177\236\220\71\127\177", "\165\40\17\212\158")) or (v40 == LUAOBFUSACTOR_DECRYPT_STR_0("\203\214\28\115\18\228\215\3", "\70\133\185\104\83")) or (2033 <= 224)) then
					if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\50\64\86\46\200\10\81\97\39\203\22\68\71\47", "\169\100\37\36\74")]:IsReady() and (v15:HealthPercentage() < v42)) or (1223 == 2011)) then
						if ((4827 > 4695) and v20(v32.VerdantEmbraceFocus, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\22\130\176\84\1\137\182\111\5\138\160\66\1\132\167\16\13\134\171\94\64\211\242", "\48\96\231\194");
						end
					end
				end
				v125 = 1;
			end
		end
	end
	local function v106()
		local v126 = 0;
		while true do
			if ((3710 > 3065) and (v126 == 0)) then
				if ((2135 <= 2696) and (not v15 or not v15:Exists() or not v15:IsInRange(30) or not v34.DispellableFriendlyUnit())) then
					return;
				end
				if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\194\34\251\101\233\61\238", "\16\135\90\139")]:IsReady() and (v34.UnitHasPoisonDebuff(v15))) or (1742 > 4397)) then
					if ((3900 >= 1904) and v24(v32.ExpungeFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\113\108\22\38\64\83\125\20\112\15\32\94\81\116", "\24\52\20\102\83\46\52");
					end
				end
				v126 = 1;
			end
			if ((1 == v126) or (1724 == 909)) then
				if ((1282 < 1421) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\235\63\49\54\10\215\60\40\42\8\246\32\32\54", "\111\164\79\65\68")]:IsReady() and v57 and v34.UnitHasEnrageBuff(v14)) then
					if ((4876 >= 4337) and v24(v30.OppressingRoar)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\201\147\204\43\249\213\208\141\217\110\216\201\216\145\158\42\227\213\201\134\210", "\138\166\185\227\190\78");
					end
				end
				break;
			end
		end
	end
	local function v107()
		local v127 = 0;
		while true do
			if ((4005 >= 3005) and (5 == v127)) then
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\93\156\246\67\86\143\241", "\130\42\56\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\166\33\204\66\44\227\177\45\226\78\12\233\180\40\230\83", "\95\138\213\68\131\32")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\45\181\87\127\36\47\178", "\22\74\72\193\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\3\123\247\81\40\112\229\86\31\122\229\84\41\106\204\104", "\56\76\25\132")] or 0;
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\109\196\191\50\198\80\198\184", "\175\62\161\203\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\206\198\59\58\42\216\209", "\85\92\189\163\115")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\169\36\44\32\162\55\43", "\88\73\204\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\6\140\6\67\59\238\39\142\21", "\186\78\227\112\38\73")] or 0;
				v127 = 6;
			end
			if ((v127 == 1) or (4781 <= 4448)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\161\79\88\77\210\79\205", "\40\190\196\59\44\36\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\86\217\156\255\124\1\53\75\219\132\245\105\4\51\75", "\109\92\37\188\212\154\29")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\234\176\215\56\84\3\252", "\58\100\143\196\163\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\71\34\175\54\71\226\62\21\86\42\172\49\103\228\3\31", "\110\122\34\67\195\95\41\133")] or "";
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\180\79\94\223\123\182\72", "\182\21\209\59\42")][LUAOBFUSACTOR_DECRYPT_STR_0("\159\82\196\17\40\176\176\103\202\9\40\177\185\127\245", "\222\215\55\165\125\65")] or 0;
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\212\210\14\251\207\234\89", "\42\76\177\166\122\146\161\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\153\0\236\117\115\182\153\12\192\126\89\163\190\13\203\91\100\170\132\31\203", "\22\197\234\101\174\25")];
				v127 = 2;
			end
			if ((1317 > 172) and (v127 == 6)) then
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\207\82\233\65\90\116\251\68", "\26\156\55\157\53\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\160\217\24\221\171\92\133\220\19\236\171\81\139\221", "\48\236\184\118\185\216")] or "";
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\184\67\36\198\58\226\174", "\84\133\221\55\80\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\142\232\49\180\196\89\146\225\9\167\192\85\190\210\55\167\192\89", "\60\221\135\68\198\167")] or "";
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\184\236\151\75\215\233\174", "\185\142\221\152\227\34")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\202\66\232\64\54\216\94\232\86\253\74\48\217\89\200\82", "\151\56\165\55\154\35\83")] or "";
				break;
			end
			if ((4791 == 4791) and (v127 == 0)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\113\209\35\91\45\30\216", "\121\171\20\165\87\50\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\61\171\50\184\12\210\29\180\52\171\3\197\61\140\37\184\5\195", "\98\166\88\217\86\217")] or "";
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\243\109\21\143\210\241\229", "\188\150\150\25\97\230")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\132\90\16\13\225\222\171\83\13\31\254\213\132\106\17\13\234\223", "\141\186\233\63\98\108")] or "";
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\239\56\162\44\255\237\63", "\69\145\138\76\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\70\202\155\141\190\24\100\234\132\139\173\23\115\202\161\185", "\118\16\175\233\233\223")] or 0;
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\129\33\175\231\133\122\152", "\29\235\228\85\219\142\235")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\217\191\207\118\66\35\112\49\219\169\206\120\67\15\98", "\50\93\180\218\189\23\46\71")] or 0;
				v127 = 1;
			end
			if ((3988 > 1261) and (v127 == 3)) then
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\154\13\202\149\54\167\15\205", "\95\201\104\190\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\202\207\202\163\206\224\200\169\199\200\205\187\206\197", "\174\207\171\161")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\251\25\231\241\217\234\237", "\183\141\158\109\147\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\8\232\8\32\12\207\2\47\6\244\28\35\27\227\13\32", "\108\76\105\134")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\216\192\165\245\199\229\194\162", "\174\139\165\209\129")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\189\246\196\212\17\101\104\183\132\235\213\206\48\100\109\173", "\24\195\211\130\161\166\99\16")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\6\253\56\90\24\65\16", "\118\38\99\137\76\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\212\40\17\23\27\50\232\54\17\61\7\44\228\17\13\27\29\37\241\47\22\6", "\64\157\70\101\114\105")];
				v127 = 4;
			end
			if ((2240 <= 3616) and (v127 == 4)) then
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\173\179\247\25\78\175\180", "\112\32\200\199\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\94\72\189\209\185\55\60\68\104\176\209\174\49\36\95\80\188", "\66\76\48\60\216\163\203")] or 0;
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\131\109\231\86\192\35\169", "\68\218\230\25\147\63\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\57\86\99\166\189\56\86\95\165\164\36\84\126\185\172\56", "\214\205\74\51\44")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\73\246\232\126\244\75\241", "\23\154\44\130\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\36\181\168\156\51\29\20\177\164\160\49\49\29\167\183\171", "\115\113\198\205\206\86")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\82\234\78\141\89\249\73", "\58\228\55\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\134\140\222\43\43\164\59\179\171\220\47\38\168\29\132", "\85\212\233\176\78\92\205")] or 0;
				v127 = 5;
			end
			if ((v127 == 2) or (3988 < 3947)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\49\177\200\127\161\208\149", "\230\77\84\197\188\22\207\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\221\29\213\236\137\173\212\48\251\1\192\250\159", "\85\153\116\166\156\236\193\144")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\229\89\167\237\14\163\243", "\96\196\128\45\211\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\132\104\79\215\163\150\205\51\139\104", "\184\85\237\27\63\178\207\212")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\92\29\75\1\87\14\76", "\63\104\57\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\62\148\161\108\14\134\168\80\3\148\176\75\5\130", "\36\107\231\196")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\176\182\147\84\187\165\148", "\231\61\213\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\168\60\127\29\165\46\103\6\163\56\91\57", "\19\105\205\93")] or 0;
				v127 = 3;
			end
		end
	end
	local function v108()
		local v128 = 0;
		while true do
			if ((4644 == 4644) and (v128 == 4)) then
				v70 = v13:GetEnemiesInRange(25);
				v71 = v14:GetEnemiesInSplashRange(8);
				if ((1323 > 1271) and v36) then
					v72 = v14:GetEnemiesInSplashRangeCount(8);
				else
					v72 = 1;
				end
				v128 = 5;
			end
			if ((1619 > 1457) and (v128 == 3)) then
				if (v13:IsChanneling(v30.FireBreath) or (2860 < 1808)) then
					local v167 = 0;
					local v168;
					while true do
						if ((v167 == 0) or (739 >= 1809)) then
							v168 = GetTime() - v13:CastStart();
							if ((1539 <= 4148) and (v168 >= v13:EmpowerCastTime(v94))) then
								local v187 = 0;
								while true do
									if ((v187 == 0) or (434 > 3050)) then
										v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\191\167\16\204\237\248\197\6\161\169\0\204", "\177\111\207\206\115\159\136\140")] = v30[LUAOBFUSACTOR_DECRYPT_STR_0("\35\128\2\17\246\93\90\4\157\24", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\241\62\249\7\234\56\234\31", "\86\163\91\141\114\152")];
										return LUAOBFUSACTOR_DECRYPT_STR_0("\96\31\123\99\42\90\5\115\51\28\90\25\113\51\24\65\14\117\103\50", "\90\51\107\20\19");
									end
								end
							end
							break;
						end
					end
				end
				if (v13:IsChanneling(v30.EternitySurge) or (3054 < 1683)) then
					local v169 = 0;
					local v170;
					while true do
						if ((47 < 2706) and (v169 == 0)) then
							v170 = GetTime() - v13:CastStart();
							if ((1519 >= 580) and (v170 >= v13:EmpowerCastTime(v93))) then
								local v188 = 0;
								while true do
									if ((v188 == 0) or (3110 == 4177)) then
										v10[LUAOBFUSACTOR_DECRYPT_STR_0("\168\224\140\236\14\136\228\145\230\51\138\227\182", "\93\237\144\229\143")] = v30[LUAOBFUSACTOR_DECRYPT_STR_0("\48\226\245\11\5\79\1\239\195\12\25\65\16", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\31\190\250\47\63\181\199\30", "\90\77\219\142")];
										return LUAOBFUSACTOR_DECRYPT_STR_0("\213\16\46\41\92\14\116\225\68\4\45\73\21\116\239\16\56\10\89\21\125\227", "\26\134\100\65\89\44\103");
									end
								end
							end
							break;
						end
					end
				end
				v90 = v13:BuffRemains(v30.HoverBuff) < 2;
				v128 = 4;
			end
			if ((4200 > 2076) and (v128 == 1)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\68\57\210\93\20\239", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\113\236\215", "\25\18\136\164\195\107\35")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\220\34\174\72\126\185\210", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\37\233\42\214", "\226\77\140\75\186\104\188")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\193\215\56\67\188\221", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\188\212\101\18\183\88", "\70\216\189\22\98\210\52\24")];
				v128 = 2;
			end
			if ((v128 == 5) or (601 >= 2346)) then
				if ((3970 <= 4354) and (v34.TargetIsValid() or v13:AffectingCombat())) then
					local v171 = 0;
					while true do
						if ((v171 == 1) or (1542 < 208)) then
							if ((1612 <= 2926) and (v88 == 11111)) then
								v88 = v10.FightRemains(v70, false);
							end
							break;
						end
						if ((v171 == 0) or (2006 <= 540)) then
							v87 = v10.BossFightRemains(nil, true);
							v88 = v87;
							v171 = 1;
						end
					end
				end
				v89 = v13:GCD() + 0.25;
				v84 = v13:SpellHaste();
				v128 = 6;
			end
			if ((v128 == 2) or (2412 == 4677)) then
				if (v13:IsDeadOrGhost() or (4897 <= 1972)) then
					return;
				end
				if ((3101 <= 3584) and v48 and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\255\199\179\146\221\221\218", "\179\186\191\195\231")]:IsReady() and v34.DispellableFriendlyUnit()) then
					local v172 = 0;
					local v173;
					local v174;
					while true do
						if ((0 == v172) or (1568 >= 4543)) then
							v173 = v48;
							v174 = v34.FocusUnit(v173, v32, 30);
							v172 = 1;
						end
						if ((4258 >= 1841) and (v172 == 1)) then
							if (v174 or (3052 >= 3554)) then
								return v174;
							end
							break;
						end
					end
				elseif ((v96() and (v15:BuffRemains(v30.SourceofMagicBuff) < 300)) or (2098 > 3885)) then
					local v186 = 0;
					while true do
						if ((0 == v186) or (2970 == 1172)) then
							v95 = v96():GUID();
							if ((3913 > 3881) and (v65 == LUAOBFUSACTOR_DECRYPT_STR_0("\216\42\12\235", "\132\153\95\120")) and (v96():BuffRemains(v30.SourceofMagicBuff) < 300) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\130\189\27\63\244\223\175\183\159\15\42\254\217", "\192\209\210\110\77\151\186")]:IsCastable()) then
								local v204 = 0;
								while true do
									if ((4932 >= 1750) and (v204 == 0)) then
										ShouldReturn = v34.FocusSpecifiedUnit(v96(), 25);
										if (ShouldReturn or (135 == 1669)) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							break;
						end
					end
				elseif ((4802 >= 109) and v38) then
					if (((v40 == LUAOBFUSACTOR_DECRYPT_STR_0("\197\21\39\251\230\203\238\6", "\164\128\99\66\137\159")) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\54\140\251\186\1\135\253\155\13\139\251\191\3\140", "\222\96\233\137")]:IsReady()) or ((v41 == LUAOBFUSACTOR_DECRYPT_STR_0("\156\165\162\13\145\252\254\188", "\144\217\211\199\127\232\147")) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\221\34\59\58\212\73\6\102\244\32\45\59\218\72", "\36\152\79\94\72\181\37\98")]:IsReady()) or (3911 > 4952)) then
						local v203 = 0;
						while true do
							if ((v203 == 0) or (265 > 4194)) then
								ShouldReturn = v34.FocusUnit(false, nil, nil, nil);
								if ((2655 <= 2908) and ShouldReturn) then
									return ShouldReturn;
								end
								break;
							end
						end
					elseif ((963 > 651) and (v40 == LUAOBFUSACTOR_DECRYPT_STR_0("\249\215\83\127\227\217\73\52", "\95\183\184\39")) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\131\58\245\34\85\142\22\144\50\229\52\85\131\7", "\98\213\95\135\70\52\224")]:IsReady()) then
						local v209 = 0;
						local v210;
						local v211;
						while true do
							if ((v209 == 1) or (3503 <= 195)) then
								if ((1382 <= 4404) and (v210:HealthPercentage() < v211:HealthPercentage())) then
									local v212 = 0;
									while true do
										if ((v212 == 0) or (4857 <= 767)) then
											ShouldReturn = v34.FocusUnit(false, nil, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\160\132\200\238\81\186", "\20\232\193\137\162"));
											if (ShouldReturn or (4018 > 4021)) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								if ((v211:HealthPercentage() < v210:HealthPercentage()) or (2270 == 1932)) then
									local v213 = 0;
									while true do
										if ((v213 == 0) or (3430 <= 1176)) then
											ShouldReturn = v34.FocusUnit(false, nil, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\6\254\232\135\192\169\37", "\17\66\191\165\198\135\236\119"));
											if (ShouldReturn or (1198 >= 3717)) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								break;
							end
							if ((3730 >= 1333) and (v209 == 0)) then
								v210 = v34.GetFocusUnit(false, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\214\134\232\91\113\204", "\52\158\195\169\23")) or v13;
								v211 = v34.GetFocusUnit(false, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\94\157\31\85\161\16\73", "\235\26\220\82\20\230\85\27")) or v13;
								v209 = 1;
							end
						end
					end
				end
				if (not v13:IsMoving() or (2152 == 2797)) then
					LastStationaryTime = GetTime();
				end
				v128 = 3;
			end
			if ((v128 == 8) or (1709 < 588)) then
				if (v13:AffectingCombat() or (3575 <= 3202)) then
					local v175 = 0;
					local v176;
					while true do
						if ((v175 == 0) or (4397 < 3715)) then
							v176 = v99();
							if (v176 or (4075 <= 2245)) then
								return v176;
							end
							break;
						end
					end
				end
				if (v13:AffectingCombat() or v35 or (3966 > 4788)) then
					local v177 = 0;
					local v178;
					local v179;
					while true do
						if ((3826 > 588) and (v177 == 2)) then
							if ((694 <= 1507) and (v65 == LUAOBFUSACTOR_DECRYPT_STR_0("\107\162\8\218", "\195\42\215\124\181\33\236"))) then
								if ((3900 >= 1116) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\62\86\34\44\38\253\2\95\26\63\34\241\14", "\152\109\57\87\94\69")]:IsCastable() and v15:IsInRange(25) and (v95 == v15:GUID()) and (v15:BuffRemains(v30.SourceofMagicBuff) < 300)) then
									if ((4907 > 3311) and v20(v32.SourceofMagicFocus)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\234\216\31\177\189\215\107\167\255\232\7\162\185\219\87\232\233\197\15\160\177\223\86\169\237", "\200\153\183\106\195\222\178\52");
									end
								end
							end
							if ((v65 == LUAOBFUSACTOR_DECRYPT_STR_0("\1\230\132\56\74\78\55\231", "\58\82\131\232\93\41")) or (3408 <= 2617)) then
								local v189 = 0;
								local v190;
								while true do
									if ((3201 == 3201) and (v189 == 0)) then
										v190 = v34.NamedUnit(25, v66);
										if ((2195 == 2195) and v190 and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\176\88\197\7\94\58\140\81\253\20\90\54\128", "\95\227\55\176\117\61")]:IsCastable() and (v190:BuffRemains(v30.SourceofMagicBuff) < 300)) then
											if (v20(v32.SourceofMagicName) or (3025 > 3506)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\11\113\54\89\168\29\65\44\77\148\21\127\36\66\168\88\110\49\78\168\23\115\33\74\191", "\203\120\30\67\43");
											end
										end
										break;
									end
								end
							end
							v178 = v34.HandleDPSPotion(v13:BuffUp(v30.IridescenceBlueBuff));
							if (v178 or (736 < 356)) then
								return v178;
							end
							v177 = 3;
						end
						if ((1171 <= 2774) and (v177 == 1)) then
							if ((4108 >= 312) and v52) then
								local v191 = 0;
								while true do
									if ((v191 == 0) or (679 > 2893)) then
										v179 = v34.HandleAfflicted(v30.Expunge, v32.ExpungeMouseover, 40);
										if (v179 or (876 < 200)) then
											return v179;
										end
										break;
									end
								end
							end
							if (v53 or (2325 > 3562)) then
								local v192 = 0;
								while true do
									if ((v192 == 0) or (3661 > 4704)) then
										v179 = v34.HandleIncorporeal(v30.Sleepwalk, v32.SleepwalkMouseover, 30, true);
										if (v179 or (4133 <= 1928)) then
											return v179;
										end
										break;
									end
								end
							end
							if ((4418 >= 1433) and v38 and v13:AffectingCombat()) then
								local v193 = 0;
								local v194;
								while true do
									if ((v193 == 0) or (4123 >= 4123)) then
										v194 = v105();
										if (v194 or (205 >= 2345)) then
											return v194;
										end
										break;
									end
								end
							end
							if ((v62 and v13:AffectingCombat()) or (537 == 1004)) then
								if (((GetTime() - LastStationaryTime) > v63) or (2345 < 545)) then
									if ((1649 > 243) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\248\141\175\246\17", "\180\176\226\217\147\99\131")]:IsReady()) then
										if (v24(v30.Hover) or (3910 <= 3193)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\219\182\57\2\193\249\34\6\218\183\111\85", "\103\179\217\79");
										end
									end
								end
							end
							v177 = 2;
						end
						if ((2005 == 2005) and (v177 == 3)) then
							if ((4688 > 4572) and v37) then
								local v195 = 0;
								local v196;
								while true do
									if ((1567 < 3260) and (v195 == 0)) then
										v196 = v100();
										if (v196 or (3761 == 621)) then
											return v196;
										end
										break;
									end
								end
							end
							if ((4755 > 3454) and (v72 >= 3)) then
								local v197 = 0;
								local v198;
								while true do
									if ((4819 >= 1607) and (v197 == 0)) then
										v198 = v103();
										if ((4546 >= 1896) and v198) then
											return v198;
										end
										v197 = 1;
									end
									if ((3546 > 933) and (1 == v197)) then
										if (v24(v30.Pool) or (3985 <= 3160)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\193\42\66\227\153\247\42\95\175\248\254\32\5\166", "\185\145\69\45\143");
										end
										break;
									end
								end
							end
							v179 = v104();
							if ((1987 == 1987) and v179) then
								return v179;
							end
							break;
						end
						if ((994 <= 4540) and (v177 == 0)) then
							if ((4917 == 4917) and not v13:IsCasting() and not v13:IsChanneling()) then
								local v199 = 0;
								local v200;
								while true do
									if ((v199 == 1) or (324 > 4896)) then
										v200 = v34.InterruptWithStun(v30.TailSwipe, 8);
										if ((772 < 4670) and v200) then
											return v200;
										end
										v199 = 2;
									end
									if ((3172 >= 2578) and (v199 == 2)) then
										v200 = v34.Interrupt(v30.Quell, 10, true, Mouseover, v32.QuellMouseover);
										if (v200 or (721 == 834)) then
											return v200;
										end
										break;
									end
									if ((1312 < 2654) and (v199 == 0)) then
										v200 = v34.Interrupt(v30.Quell, 10, true);
										if ((3213 >= 1613) and v200) then
											return v200;
										end
										v199 = 1;
									end
								end
							end
							v78 = v29(v30[LUAOBFUSACTOR_DECRYPT_STR_0("\111\209\21\234\32\166\89\194\19\232", "\200\43\163\116\141\79")]:CooldownRemains(), v30[LUAOBFUSACTOR_DECRYPT_STR_0("\154\34\56\145\190\253\247\166\5\40\145\183\241", "\131\223\86\93\227\208\148")]:CooldownRemains() - (2 * v89), v30[LUAOBFUSACTOR_DECRYPT_STR_0("\197\76\164\179\63\167\230\68\162\190", "\213\131\37\214\214\125")]:CooldownRemains() - v89);
							if ((v30[LUAOBFUSACTOR_DECRYPT_STR_0("\19\37\55\190\247\35\39", "\129\70\75\69\223")]:IsReady() and v14:EnemyAbsorb()) or (3786 > 4196)) then
								if ((4218 == 4218) and v24(v30.Unravel, not v14:IsSpellInRange(v30.Unravel))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\83\197\225\232\106\234\74\139\254\232\117\225\6\159", "\143\38\171\147\137\28");
								end
							end
							if ((1517 < 4050) and (v49 or v48)) then
								local v201 = 0;
								local v202;
								while true do
									if ((4390 == 4390) and (v201 == 0)) then
										v202 = v106();
										if ((1919 > 289) and v202) then
											return v202;
										end
										break;
									end
								end
							end
							v177 = 1;
						end
					end
				end
				if (v24(v30.Pool) or (1205 < 751)) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\186\16\22\170\156\140\16\11\230\239\190\87\80", "\188\234\127\121\198");
				end
				break;
			end
			if ((v128 == 0) or (2561 <= 1717)) then
				v107();
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\148\76\2\233\172\70\22", "\142\192\35\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\122\42", "\118\182\21\73\195\135\236\204")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\60\51\29\71\8\8\238", "\157\104\92\122\32\100\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\162\169\202", "\203\195\198\175\170\93\71\237")];
				v128 = 1;
			end
			if ((1723 <= 3600) and (v128 == 7)) then
				if ((3271 >= 1633) and v38 and v35 and not v13:AffectingCombat()) then
					local v180 = 0;
					local v181;
					while true do
						if ((3103 >= 2873) and (v180 == 0)) then
							v181 = v105();
							if (v181 or (3603 == 725)) then
								return v181;
							end
							break;
						end
					end
				end
				if ((2843 == 2843) and v62 and (v35 or v13:AffectingCombat())) then
					if (((GetTime() - LastStationaryTime) > v63) or (174 >= 2515)) then
						if ((4411 >= 2020) and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\80\133\216\70\189", "\49\24\234\174\35\207\50\93")]:IsReady() and v13:BuffDown(v30.Hover)) then
							if ((1347 == 1347) and v24(v30.Hover)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\4\253\235\141\99\76\255\252\129\127\76\160", "\17\108\146\157\232");
							end
						end
					end
				end
				if ((4461 == 4461) and not v13:AffectingCombat() and v35 and not v13:IsCasting()) then
					local v182 = 0;
					local v183;
					while true do
						if ((v182 == 0) or (4340 == 2872)) then
							v183 = v98();
							if ((568 <= 2207) and v183) then
								return v183;
							end
							break;
						end
					end
				end
				v128 = 8;
			end
			if ((v128 == 6) or (3789 <= 863)) then
				v85 = 1 * v84;
				if ((238 < 4997) and ((v34.TargetIsValid() and v35) or v13:AffectingCombat())) then
					local v184 = 0;
					while true do
						if ((4285 > 3803) and (v184 == 0)) then
							v79 = v13:BuffUp(v30.Dragonrage);
							v80 = (v79 and v13:BuffRemains(v30.Dragonrage)) or 0;
							break;
						end
					end
				end
				if ((2672 < 4910) and not v13:AffectingCombat()) then
					if ((v47 and v30[LUAOBFUSACTOR_DECRYPT_STR_0("\211\239\53\48\183\248\237\55\44\162\229\235\53\1\182\254\237\42\38", "\196\145\131\80\67")]:IsCastable() and (v13:BuffDown(v30.BlessingoftheBronzeBuff, true) or v34.GroupBuffMissing(v30.BlessingoftheBronzeBuff))) or (2956 > 4353)) then
						if ((3534 > 2097) and v24(v30.BlessingoftheBronze)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\28\188\3\27\11\225\16\183\57\7\30\215\10\184\3\55\26\250\17\190\28\13\88\248\12\181\5\7\21\234\31\164", "\136\126\208\102\104\120");
						end
					end
				end
				v128 = 7;
			end
		end
	end
	local function v109()
		local v129 = 0;
		while true do
			if ((3255 >= 534) and (v129 == 1)) then
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\241\206\224\174\176\226\125\171\220\196\248\239\134\224\115\180\208\217\182\151\227\224\60\238\133\133\164\225\243\166\60\157\204\139\212\160\172\251\87", "\223\181\171\150\207\195\150\28"));
				break;
			end
			if ((4254 < 4460) and (v129 == 0)) then
				v34[LUAOBFUSACTOR_DECRYPT_STR_0("\28\59\0\147\61\62\31\130\58\62\22\167\61\48\6\133\62\33", "\227\88\82\115")] = v34[LUAOBFUSACTOR_DECRYPT_STR_0("\103\22\169\183\7\127\79\30\184\171\7\67\76\22\169\168\12\87\70\29\175\161\4\96", "\19\35\127\218\199\98")];
				v19.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\56\254\28\227\15\239\11\246\21\244\4\162\57\237\5\233\25\233\74\224\5\187\47\242\21\248\74\192\19\244\7\201\82", "\130\124\155\106"));
				v129 = 1;
			end
		end
	end
	v19.SetAPL(1467, v108, v109);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\105\42\234\182\54\105\44\236\165\12\94\5\199\171\31\77\41\247\175\29\69\53\237\224\5\89\59", "\105\44\90\131\206")]();

