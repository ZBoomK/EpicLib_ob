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
		if ((0 == v5) or (4138 == 4937)) then
			v6 = v0[v4];
			if (not v6 or (1223 >= 4525)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((1090 <= 4827) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\194\19\222\205\243\48\232\175\194\12\238\235\218\51\233\184\137\18\196\194", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\209\88\178\85\249\120\177\67\238", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\152\120\104", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = EpicLib;
	local v21 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\107\75\14\33", "\69\41\34\96")];
	local v22 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\33\187\152\35\234\23\189\140\50\202\22\191\143", "\185\98\218\235\87")];
	local v24 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\4\192\47\154\38", "\232\73\161\76")];
	local v26 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")];
	local v27 = v26[LUAOBFUSACTOR_DECRYPT_STR_0("\184\252\39", "\167\214\137\74\171\120\206\83")];
	local v28 = v26[LUAOBFUSACTOR_DECRYPT_STR_0("\137\255\61\81", "\199\235\144\82\61\152")];
	local v29 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\10\31\183", "\75\103\118\217")];
	local v30 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\202\85\104", "\126\167\52\16\116\217")];
	local v31 = 5;
	local v32;
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
	local v85 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\236\43\45\143\186\49\233\198\58\37\146", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\47\239\179\193\4", "\174\103\142\197")];
	local v86 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\114\45\82\55\43\118\237\88\60\90\42", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\252\197\248\83\215", "\60\180\164\142")];
	local v87 = v25[LUAOBFUSACTOR_DECRYPT_STR_0("\124\91\8\38\41\197\7\86\74\0\59", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\232\205\203\187", "\164\216\137\187")];
	local v88 = {};
	local v89 = v14:GetEquipment();
	local v90 = (v89[13] and v19(v89[13])) or v19(0);
	local v91 = (v89[14] and v19(v89[14])) or v19(0);
	local v92, v93;
	local v94, v95;
	local v96 = {{v85[LUAOBFUSACTOR_DECRYPT_STR_0("\244\227\61\151\180\235\27\198\239\62\188", "\107\178\134\81\210\198\158")]},{v85[LUAOBFUSACTOR_DECRYPT_STR_0("\27\6\131\201\185\22\1\148\199", "\202\88\110\226\166")]}};
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = false;
	local v101 = false;
	local v102 = false;
	local v103 = ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\226\41\139\229\207\234\1\145\254\206\198", "\170\163\111\226\151")]:IsAvailable()) and 5) or 1;
	local v104 = v14:GCD() + 0.25;
	local v105 = 0;
	local v106 = false;
	local v107 = 11111;
	local v108 = 11111;
	local v109 = {169421,169425,168932,169426,169429,169428,169430};
	v10:RegisterForEvent(function()
		local v123 = 0;
		while true do
			if ((v123 == 3) or (239 > 1345)) then
				v108 = 11111;
				break;
			end
			if ((v123 == 0) or (3710 >= 3738)) then
				v97 = false;
				v98 = false;
				v123 = 1;
			end
			if ((2 == v123) or (3838 < 2061)) then
				v101 = false;
				v107 = 11111;
				v123 = 3;
			end
			if ((v123 == 1) or (690 > 1172)) then
				v99 = false;
				v100 = false;
				v123 = 2;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\33\28\147\1\107\5\22\35\21\149\29\96\8\12\63\17\144\20\107\19", "\73\113\80\210\88\46\87"));
	v10:RegisterForEvent(function()
		local v124 = 0;
		while true do
			if ((v124 == 0) or (1592 > 2599)) then
				v89 = v14:GetEquipment();
				v90 = (v89[13] and v19(v89[13])) or v19(0);
				v124 = 1;
			end
			if ((3574 <= 4397) and (v124 == 1)) then
				v91 = (v89[14] and v19(v89[14])) or v19(0);
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\177\0\236\43\194\179\19\232\35\210\168\28\224\55\201\181\19\238\58\198\175\11\232\54", "\135\225\76\173\114"));
	v10:RegisterForEvent(function()
		v103 = ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\59\203\177\162\169\148\169\9\228\188\181", "\199\122\141\216\208\204\221")]:IsAvailable()) and 5) or 1;
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\158\237\53\220\84\197\146\254\56\209\86\209\136\249", "\150\205\189\112\144\24"), LUAOBFUSACTOR_DECRYPT_STR_0("\9\161\158\126\42\173\53\47\22\180\154\96\40\183\56\62\26\176\158\110", "\112\69\228\223\44\100\232\113"));
	local function v110(v125)
		return v125:DebuffRemains(v85.BurningWoundDebuff) or v125:DebuffRemains(v85.BurningWoundLegDebuff);
	end
	local function v111(v126)
		return v85[LUAOBFUSACTOR_DECRYPT_STR_0("\246\10\21\221\191\114\129\227\16\18\221\178", "\230\180\127\103\179\214\28")]:IsAvailable() and (v126:DebuffRemains(v85.BurningWoundDebuff) < 4) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\174\16\77\72\237\79\231\187\10\74\72\224\101\229\142\16\89\64", "\128\236\101\63\38\132\33")]:AuraActiveCount() < v29(v94, 3));
	end
	local function v112()
		local v127 = 0;
		while true do
			if ((3135 > 1330) and (v127 == 0)) then
				v32 = v26.HandleTopTrinket(v88, v35, 40, nil);
				if (v32 or (3900 <= 3641)) then
					return v32;
				end
				v127 = 1;
			end
			if ((1724 == 1724) and (v127 == 1)) then
				v32 = v26.HandleBottomTrinket(v88, v35, 40, nil);
				if ((455 <= 1282) and v32) then
					return v32;
				end
				break;
			end
		end
	end
	local function v113()
		local v128 = 0;
		while true do
			if ((4606 < 4876) and (v128 == 0)) then
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\142\165\4\86", "\175\204\201\113\36\214\139")]:IsCastable() and v65 and (v14:HealthPercentage() <= v67)) or (1442 > 2640)) then
					if ((136 < 3668) and v24(v85.Blur)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\69\192\32\206\68\67\201\51\217\10\84\197\35\217", "\100\39\172\85\188");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\131\125\173\136\54\191\111\184\140\56", "\83\205\24\217\224")]:IsCastable() and v66 and (v14:HealthPercentage() <= v68)) or (1784 > 4781)) then
					if ((4585 > 3298) and v24(v85.Netherwalk)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\232\192\217\53\227\215\218\60\234\206\141\57\227\195\200\51\245\204\219\56", "\93\134\165\173");
					end
				end
				v128 = 1;
			end
			if ((v128 == 1) or (1664 > 1698)) then
				if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\150\247\192\206\46\198\161\106\177\252\196", "\30\222\146\161\162\90\174\210")]:IsReady() and v80 and (v14:HealthPercentage() <= v82)) or (3427 < 2849)) then
					if ((3616 <= 4429) and v24(v87.Healthstone)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\75\113\6\241\70\99\30\234\64\117\74\225\75\118\15\235\93\121\28\224", "\106\133\46\16");
					end
				end
				if ((3988 >= 66) and v79 and (v14:HealthPercentage() <= v81)) then
					local v181 = 0;
					while true do
						if ((v181 == 0) or (862 > 4644)) then
							if ((1221 == 1221) and (v83 == LUAOBFUSACTOR_DECRYPT_STR_0("\106\37\117\238\95\83\80\41\125\251\26\104\93\33\127\245\84\71\24\16\124\232\83\79\86", "\32\56\64\19\156\58"))) then
								if (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\104\205\227\68\95\225\136\83\198\226\126\95\243\140\83\198\226\102\85\230\137\85\198", "\224\58\168\133\54\58\146")]:IsReady() or (45 > 1271)) then
									if ((3877 > 1530) and v24(v87.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\75\83\77\239\112\149\143\2\87\81\11\245\112\135\139\2\87\81\11\237\122\146\142\4\87\22\79\248\115\131\137\24\80\64\78", "\107\57\54\43\157\21\230\231");
									end
								end
							end
							if ((v83 == "Dreamwalker's Healing Potion") or (4798 == 1255)) then
								if (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\255\153\20\244\180\203\206\215\128\20\231\170\244\202\218\135\24\251\190\236\192\207\130\30\251", "\175\187\235\113\149\217\188")]:IsReady() or (2541 > 2860)) then
									if (v24(v87.RefreshingHealingPotion) or (2902 > 3629)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\56\189\132\77\238\110\121\48\164\132\94\240\57\112\57\174\141\69\237\126\56\44\160\149\69\236\119\56\56\170\135\73\237\106\113\42\170", "\24\92\207\225\44\131\25");
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
	local function v114()
		local v129 = 0;
		while true do
			if ((427 < 3468) and (v129 == 2)) then
				if ((4190 >= 2804) and v15:IsInMeleeRange(5) and v42 and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\127\43\185\89\67\72\12\189\66\72", "\45\59\78\212\54")]:IsCastable() or v85[LUAOBFUSACTOR_DECRYPT_STR_0("\52\83\142\132\136\12\161\241\20\83\144", "\144\112\54\227\235\230\78\205")]:IsAvailable())) then
					if ((2086 == 2086) and v24(v85.DemonsBite, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\45\2\243\222\72\140\42\6\232\213\27\188\58\79\248\213\86\188\38\48\254\220\90\183\45\28\188\192\73\182\43\0\241\210\90\167\104\94\174", "\59\211\72\111\156\176");
					end
				end
				break;
			end
			if ((4148 > 2733) and (v129 == 1)) then
				if ((3054 >= 1605) and not v15:IsInMeleeRange(5) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\26\52\5\185\21\234\37\48", "\85\92\81\105\219\121\139\65")]:IsCastable()) then
					if ((1044 < 1519) and v24(v85.Felblade, not v15:IsSpellInRange(v85.Felblade))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\182\92\71\112\222\249\182\16\85\110\218\254\188\93\71\125\203\189\234", "\191\157\211\48\37\28");
					end
				end
				if ((1707 <= 4200) and not v15:IsInMeleeRange(5) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\249\26\248\46\47\204\23", "\90\191\127\148\124")]:IsCastable() and (not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\94\130\34\21\116\134\42\18", "\119\24\231\78")]:IsAvailable() or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\164\40\169\72\208\65\21\135", "\113\226\77\197\42\188\32")]:CooldownDown() and not v14:PrevGCDP(1, v85.Felblade))) and v36 and v47) then
					if ((580 == 580) and v24(v85.FelRush, not v15:IsInRange(15))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\19\248\138\40\3\231\189\122\6\230\176\57\25\249\183\59\2\180\228\106", "\213\90\118\148");
					end
				end
				v129 = 2;
			end
			if ((601 <= 999) and (v129 == 0)) then
				if ((3970 == 3970) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\98\222\181\67\23\124\95\218\183\66\58\104\89\210", "\29\43\179\216\44\123")]:IsCastable() and v49) then
					if (v24(v85.ImmolationAura, not v15:IsInRange(v31)) or (98 == 208)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\212\45\67\177\216\52\69\178\215\31\77\168\203\33\12\173\203\37\79\178\212\34\77\169\153\120", "\44\221\185\64");
					end
				end
				if ((2006 <= 3914) and v50 and not v14:IsMoving() and (v94 > 1) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\50\238\79\86\127\46\225\110\83\114\12\226", "\19\97\135\40\63")]:IsCastable()) then
					if ((v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\190\80\50\34\42\35", "\81\206\60\83\91\79")) or v85[LUAOBFUSACTOR_DECRYPT_STR_0("\109\164\222\113\42\205\89\182\79\191\213\118\28\202\74\173\66\184", "\196\46\203\176\18\79\163\45")]:IsAvailable() or (3101 <= 2971)) then
						if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or (2073 <= 671)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\171\43\121\23\40\196\224\190\29\120\18\37\246\234\248\50\108\27\39\244\226\186\35\106\94\125", "\143\216\66\30\126\68\155");
						end
					elseif ((3305 > 95) and (v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\169\221\31\216\202\177", "\129\202\168\109\171\165\195\183"))) then
						if ((2727 == 2727) and v24(v87.SigilOfFlameCursor, not v15:IsInRange(40))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\49\81\48\209\210\43\233\36\103\49\212\223\25\227\98\72\37\221\221\27\235\32\89\35\152\135", "\134\66\56\87\184\190\116");
						end
					end
				end
				v129 = 1;
			end
		end
	end
	local function v115()
		if (v14:BuffDown(v85.FelBarrage) or (2970 >= 4072)) then
			local v139 = 0;
			while true do
				if ((3881 > 814) and (v139 == 0)) then
					if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\106\130\226\57\70\180\244\40\75\151", "\77\46\231\131")]:IsReady() and v41) or (4932 < 4868)) then
						if ((3667 <= 4802) and v24(v85.DeathSweep, not v15:IsInRange(v31))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\190\81\183\84\178\107\165\87\191\81\166\0\183\81\162\65\133\81\184\68\250\6", "\32\218\52\214");
						end
					end
					if ((1260 >= 858) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\111\25\63\161\249\185\73\91\90\30\62\166", "\58\46\119\81\200\145\208\37")]:IsReady() and v37) then
						if (v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation)) or (3911 == 4700)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\42\130\62\165\161\180\58\42\152\57\163\167\253\59\46\152\49\147\172\179\50\107\216", "\86\75\236\80\204\201\221");
						end
					end
					break;
				end
			end
		end
	end
	local function v116()
		local v130 = 0;
		local v131;
		while true do
			if ((3000 < 4194) and (v130 == 2)) then
				if ((651 < 4442) and (v76 < v108) and v57 and not v14:IsMoving() and ((v35 and v60) or not v60) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\169\241\85\33\27\77\116\168\248\79\32\23\73", "\26\236\157\44\82\114\44")]:IsCastable() and (v15:DebuffDown(v85.EssenceBreakDebuff)) and (v94 > v64)) then
					if ((v63 == LUAOBFUSACTOR_DECRYPT_STR_0("\58\34\212\66\47\60", "\59\74\78\181")) or (195 >= 1804)) then
						if (v24(v87.ElysianDecreePlayer, not v15:IsInRange(v31)) or (1382 > 2216)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\32\221\67\73\186\36\223\101\94\182\38\195\95\95\243\38\222\85\86\183\42\198\84\26\235\101\153\106\86\178\60\212\72\19", "\211\69\177\58\58");
						end
					elseif ((v63 == LUAOBFUSACTOR_DECRYPT_STR_0("\180\240\107\230\230\217", "\171\215\133\25\149\137")) or (2861 == 2459)) then
						if ((1903 < 4021) and v24(v87.ElysianDecreeCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\228\196\43\233\230\49\242\125\229\205\49\232\234\53\188\65\238\199\62\254\224\39\242\2\185\136\122\217\250\34\239\77\243\129", "\34\129\168\82\154\143\80\156");
						end
					end
				end
				if ((v76 < v108) or (2270 >= 4130)) then
					if ((2593 <= 3958) and v77 and ((v35 and v78) or not v78)) then
						local v188 = 0;
						while true do
							if ((1176 == 1176) and (v188 == 0)) then
								v32 = v112();
								if (v32 or (3062 == 1818)) then
									return v32;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((v130 == 0) or (3717 < 3149)) then
				if ((3195 < 3730) and (v76 < v108) and ((v35 and v61) or not v61) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\95\68\99\132\243\132\96\81\127\138\237\130\97", "\235\18\33\23\229\158")]:IsCastable() and v58 and not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\116\191\204\180\94\179\194", "\219\48\218\161")]:IsAvailable()) then
					if ((2797 <= 3980) and v24(v87.MetamorphosisPlayer, not v15:IsInRange(v31))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\116\104\72\214\64\242\244\121\115\90\210\92\160\231\126\115\69\223\64\247\234\49\40", "\128\132\17\28\41\187\47");
					end
				end
				if ((1944 <= 2368) and (v76 < v108) and ((v35 and v61) or not v61) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\44\55\18\59\80\14\32\22\50\82\18\59\21", "\61\97\82\102\90")]:IsCastable() and v58 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\136\43\166\68\201\94\29", "\105\204\78\203\43\167\55\126")]:IsAvailable() and ((not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\134\162\34\17\7\13\196\101\183\171\45\13\21\11\213\92\164\190\42\17\29", "\49\197\202\67\126\115\100\167")]:IsAvailable() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\18\66\218\11\133\87\83", "\62\87\59\191\73\224\54")]:CooldownDown()) or ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\194\27\255\235\226\3\247", "\169\135\98\154")]:CooldownRemains() > 20) and (not v97 or v14:PrevGCDP(1, v85.DeathSweep) or v14:PrevGCDP(2, v85.DeathSweep))) or ((v108 < (25 + (v27(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\248\127\37\64\233\54\218\206\115\0\81\238\39\193\197\110", "\168\171\23\68\52\157\83")]:IsAvailable()) * 70))) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\209\104\240\143\32\44\138", "\231\148\17\149\205\69\77")]:CooldownDown() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\162\171\198\255\82\219\129\169\196\254", "\159\224\199\167\155\55")]:CooldownDown())) and v14:BuffDown(v85.InnerDemonBuff)) then
					if ((1709 < 4248) and v24(v87.MetamorphosisPlayer, not v15:IsInRange(v31))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\246\40\211\250\252\46\194\255\252\47\219\228\179\63\221\248\255\56\221\224\253\124\132", "\178\151\147\92");
					end
				end
				v130 = 1;
			end
			if ((v130 == 1) or (3970 == 3202)) then
				v131 = v26.HandleDPSPotion(v14:BuffUp(v85.MetamorphosisBuff));
				if (v131 or (3918 >= 4397)) then
					return v131;
				end
				v130 = 2;
			end
		end
	end
	local function v117()
		local v132 = 0;
		while true do
			if ((v132 == 6) or (780 == 3185)) then
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\227\208\85\48\192\255\75\62\222\206\66", "\95\183\184\39")]:IsCastable() and v51 and not v14:PrevGCDP(1, v85.VengefulRetreat) and not v14:IsMoving() and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\145\58\234\41\90\162\14\180\59\226\53", "\98\213\95\135\70\52\224")]:IsAvailable() or not v15:IsInRange(12)) and v15:DebuffDown(v85.EssenceBreakDebuff) and v15:IsSpellInRange(v85.ThrowGlaive) and not v14:HasTier(31, 2)) or (3202 >= 4075)) then
					if ((64 == 64) and v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\171\219\120\67\193\164\197\118\93\232\166\137\101\91\234\162\221\126\91\240\227\159\37", "\52\158\195\169\23");
					end
				end
				break;
			end
			if ((2202 >= 694) and (v132 == 3)) then
				if ((3706 <= 3900) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\29\189\46\233\56\177\55\239\59\190\2\243\38\177", "\134\84\208\67")]:IsCastable() and v49 and (v94 >= 2) and (v14:Fury() < 70) and v15:DebuffDown(v85.EssenceBreakDebuff)) then
					if ((2890 > 2617) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\26\161\139\83\31\173\146\85\28\162\185\93\6\190\135\28\1\163\146\93\7\165\137\82\83\255\210", "\60\115\204\230");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\198\52\229\121\239\51\231\113\243\51\228\126", "\16\135\90\139")]:IsCastable() and v37 and not v98 and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\113\103\21\54\64\87\125\118\102\3\50\69", "\24\52\20\102\83\46\52")]:CooldownRemains() > 0) or not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\225\60\50\33\1\199\42\3\54\10\197\36", "\111\164\79\65\68")]:IsAvailable()) and v14:BuffDown(v85.FelBarrage)) or v14:HasTier(30, 2) or (3355 > 4385)) then
					if (v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation)) or (3067 <= 2195)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\199\215\141\215\38\227\202\216\151\215\33\228\134\203\140\202\47\254\207\214\141\158\125\188", "\138\166\185\227\190\78");
					end
				end
				if ((3025 >= 2813) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\237\113\201\53\94\34\29\206", "\121\171\20\165\87\50\67")]:IsCastable() and v46 and not v14:PrevGCDP(1, v85.VengefulRetreat) and (((v14:FuryDeficit() >= 40) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\231\54\160\27\188\3\200\43\151\51\186\7\213\43\184\36\160", "\98\166\88\217\86\217")]:IsAvailable() and v15:DebuffDown(v85.EssenceBreakDebuff)) or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\215\248\96\44\131\221\248\229\87\4\133\217\229\229\120\19\159", "\188\150\150\25\97\230")]:IsAvailable() and v15:DebuffDown(v85.EssenceBreakDebuff)))) then
					if ((2412 >= 356) and v24(v85.Felblade, not v15:IsSpellInRange(v85.Felblade))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\140\83\0\0\236\222\140\31\16\3\249\219\157\86\13\2\173\137\209", "\141\186\233\63\98\108");
					end
				end
				if ((2070 > 1171) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\194\227\43\191\41\222\236\10\186\36\252\239", "\69\145\138\76\214")]:IsCastable() and not v14:IsMoving() and v50 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\81\193\144\164\186\23\126\220\167\140\188\19\99\220\136\155\166", "\118\16\175\233\233\223")]:IsAvailable() and (v14:FuryDeficit() >= 30)) then
					if ((v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\155\136\52\162\235\153", "\29\235\228\85\219\142\235")) or v85[LUAOBFUSACTOR_DECRYPT_STR_0("\30\219\180\222\114\64\51\64\60\192\191\217\68\71\32\91\49\199", "\50\93\180\218\189\23\46\71")]:IsAvailable() or (4108 < 3934)) then
						if ((3499 >= 3439) and v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\205\173\92\69\72\227\71\216\155\93\64\69\209\77\158\182\84\88\69\200\65\209\170\27\92\72\221\81\219\182\27\31\29", "\40\190\196\59\44\36\188");
						end
					elseif ((876 < 3303) and (v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\63\80\206\167\245\111", "\109\92\37\188\212\154\29"))) then
						if ((2922 <= 3562) and v24(v87.SigilOfFlameCursor, not v15:IsInRange(40))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\23\230\163\202\61\101\11\233\155\197\61\91\9\234\228\209\62\78\5\251\173\204\63\26\7\250\182\208\62\72\68\188\253", "\58\100\143\196\163\81");
						end
					end
				end
				if ((2619 >= 1322) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\46\74\49\172\40\110\233\15\19\84\38", "\110\122\34\67\195\95\41\133")]:IsReady() and v51 and not v14:PrevGCDP(1, v85.VengefulRetreat) and not v14:IsMoving() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\70\190\78\70\197\118\176\73", "\182\21\209\59\42")]:IsAvailable() and (v95 >= (2 - v27(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\145\66\215\20\46\171\164\99\205\15\46\169\164", "\222\215\55\165\125\65")]:IsAvailable()))) and v15:DebuffDown(v85.EssenceBreakDebuff) and not v14:HasTier(31, 2)) then
					if ((4133 >= 2404) and v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\217\212\21\229\254\234\70\45\216\208\31\178\211\226\94\45\197\207\21\252\129\185\26", "\42\76\177\166\122\146\161\141");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\140\135\8\193\117\119\177\131\10\192\88\99\183\139", "\22\197\234\101\174\25")]:IsCastable() and v49 and (v14:BuffStack(v85.ImmolationAuraBuff) < v103) and v15:IsInRange(8) and (v14:BuffDown(v85.UnboundChaosBuff) or not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\24\58\167\211\99\161\211\165\37\53\170\207", "\230\77\84\197\188\22\207\183")]:IsAvailable()) and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\208\25\203\243\128\160\228\60\246\26\231\233\158\160", "\85\153\116\166\156\236\193\144")]:Recharge() < v85[LUAOBFUSACTOR_DECRYPT_STR_0("\129\243\94\182\234\3\161\194\95\182\229\11", "\96\196\128\45\211\132")]:CooldownRemains()) or (not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\16\158\104\90\220\172\177\250\39\136\122\84", "\184\85\237\27\63\178\207\212")]:IsAvailable() and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\45\64\12\125\13\88\4", "\63\104\57\105")]:CooldownRemains() > v85[LUAOBFUSACTOR_DECRYPT_STR_0("\34\138\169\75\7\134\176\77\4\137\133\81\25\134", "\36\107\231\196")]:Recharge())))) or (1433 == 2686)) then
					if (v24(v85.ImmolationAura, not v15:IsInRange(v31)) or (4123 == 4457)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\184\175\136\81\180\182\142\82\187\157\134\72\167\163\199\79\186\182\134\73\188\173\137\29\225\240", "\231\61\213\194");
					end
				end
				v132 = 4;
			end
			if ((v132 == 1) or (3972 <= 205)) then
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\213\234\84\228\48\69\251", "\54\147\143\56\182\69")]:IsCastable() and v36 and v47 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\255\143\250\91\203\223\128", "\191\182\225\159\41")]:IsAvailable() and v14:BuffDown(v85.InertiaBuff) and v14:BuffUp(v85.UnboundChaosBuff) and (v14:BuffUp(v85.MetamorphosisBuff) or ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\14\11\45\119\142\134\207", "\162\75\114\72\53\235\231")]:CooldownRemains() > v85[LUAOBFUSACTOR_DECRYPT_STR_0("\165\49\73\237\95\3\152\53\75\236\114\23\158\61", "\98\236\92\36\130\51")]:Recharge()) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\129\0\9\152\64\169\184", "\80\196\121\108\218\37\200\213")]:CooldownRemains() > 4))) and v15:DebuffDown(v85.EssenceBreakDebuff) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\34\127\3\123\78\42\139\14\112\7", "\234\96\19\98\31\43\110")]:CooldownDown()) or (3766 < 1004)) then
					if ((1784 < 2184) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\26\94\248\190\103\152\14\95\64\200\184\115\159\15\16\92\135\253\35", "\235\102\127\50\167\204\18");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\117\178\230\38\74\45\85\131\231\38\69\37", "\78\48\193\149\67\36")]:IsCastable() and v43 and ((((v14:BuffRemains(v85.MetamorphosisBuff) > (v104 * 3)) or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\21\7\133\58\68\49\19", "\33\80\126\224\120")]:CooldownRemains() > 10)) and (not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\216\169\0\208\85\239\169\15\246\89\248\186\6\197\72", "\60\140\200\99\164")]:IsAvailable() or v14:BuffUp(v85.TacticalRetreatBuff) or (v10.CombatTime() < 10)) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\165\248\5\34\167\163\245\10\37\167", "\194\231\148\100\70")]:CooldownRemains() <= (3.1 * v104))) or (v108 < 6))) or (1649 > 4231)) then
					if ((3193 == 3193) and v24(v85.EssenceBreak, not v15:IsInRange(v31))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\95\210\166\248\203\67\115\195\177\243\201\77\12\211\172\226\201\82\69\206\173\182\153\21", "\168\38\44\161\195\150");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\164\249\131\98\56\219\161\19\133\236", "\118\224\156\226\22\80\136\214")]:IsCastable() and v41 and v97 and (not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\103\253\74\133\76\237\92\162\80\235\88\139", "\224\34\142\57")]:IsAvailable() or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\251\180\214\216\125\242\88\44\204\162\196\214", "\110\190\199\165\189\19\145\61")]:CooldownRemains() > (v104 * 2))) and v14:BuffDown(v85.FelBarrage)) or (3495 > 4306)) then
					if ((4001 > 3798) and v24(v85.DeathSweep, not v15:IsInRange(v31))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\238\118\252\131\248\201\252\114\237\155\135\200\228\99\233\159\206\213\229\55\185\223", "\167\186\139\23\136\235");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\46\189\141\37\15\187\156", "\109\122\213\232")]:IsCastable() and v36 and v59 and (v76 < v108) and ((v35 and v62) or not v62) and v15:DebuffDown(v85.EssenceBreakDebuff) and ((v10.CombatTime() < 10) or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\195\242\182\49\227\248\176\32\230\248\177\57\253", "\80\142\151\194")]:CooldownRemains() > 10)) and ((v94 == 1) or (v94 > 3) or (v108 < 10)) and ((v15:DebuffDown(v85.EssenceBreakDebuff) and (not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\37\211\101\69\12\211\100\107\2\220\114", "\44\99\166\23")]:IsAvailable() or v14:BuffUp(v85.FuriousGazeBuff) or v14:HasTier(31, 4))) or not v14:HasTier(30, 2)) and (v10.CombatTime() > 10)) or (4688 <= 4499)) then
					if (v24(v85.TheHunt, not v15:IsSpellInRange(v85.TheHunt)) or (1567 <= 319)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\104\255\44\9\59\177\114\227\105\59\50\173\114\183\120\100", "\196\28\151\73\86\83");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\213\6\37\50\131\74\10\119\244\6", "\22\147\99\73\112\226\56\120")]:IsCastable() and v45 and ((v94 > 1) or ((v94 == 1) and (v14:FuryDeficit() < 20) and v14:BuffDown(v85.MetamorphosisBuff)))) or (4583 == 3761)) then
					if ((3454 > 1580) and v24(v85.FelBarrage, not v15:IsInRange(v31))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\190\112\238\202\143\185\103\240\244\138\189\53\240\250\153\185\97\235\250\131\248\36\180", "\237\216\21\130\149");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\165\66\94\86\166\204\106\135\67\79\90\163\221", "\62\226\46\63\63\208\169")]:IsReady() and v48 and (v15:DebuffDown(v85.EssenceBreakDebuff) or (v94 > 1)) and v14:BuffDown(v85.FelBarrage)) or (1607 == 20)) then
					if (v24(v85.GlaiveTempest, not v15:IsInRange(v31)) or (962 >= 4666)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\21\84\138\9\8\16\74\224\20\69\134\12\25\111\76\234\13\84\151\22\2\33\30\180\65", "\62\133\121\53\227\127\109\79");
					end
				end
				v132 = 2;
			end
			if ((v132 == 2) or (1896 == 1708)) then
				if ((3985 >= 1284) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\49\26\60\252\222\167\174\17\0\59\250\216", "\194\112\116\82\149\182\206")]:IsReady() and v37 and v14:BuffUp(v85.InnerDemonBuff) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\28\177\73\58\197\227\3", "\110\89\200\44\120\160\130")]:CooldownRemains() <= v14:GCD()) and v14:BuffDown(v85.FelBarrage)) then
					if (v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation)) or (1987 == 545)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\205\69\79\75\67\55\76\191\202\68\72\3\88\52\89\170\215\66\73\77\10\105\29", "\45\203\163\43\38\35\42\91");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\244\128\208\17\146\186\92", "\52\178\229\188\67\231\201")]:IsReady() and v36 and v47 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\12\78\93\1\249\72\54\44", "\67\65\33\48\100\151\60")]:IsAvailable() and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\250\254\171\250\246\222\234", "\147\191\135\206\184")]:CooldownRemains() < (v104 * 3)) and (v14:BuffRemains(v85.MomentumBuff) < 5) and v14:BuffDown(v85.MetamorphosisBuff)) or (4896 < 1261)) then
					if ((23 < 3610) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\130\45\170\254\202\70\161\140\104\180\206\204\82\166\141\39\168\129\138\1", "\210\228\72\198\161\184\51");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\19\80\246\50\118\207\59", "\174\86\41\147\112\19")]:IsCastable() and v44 and not v14:PrevGCDP(1, v85.VengefulRetreat) and ((v15:DebuffDown(v85.EssenceBreakDebuff) and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\118\5\153\10\40\0\3\187\83\15\158\2\54", "\203\59\96\237\107\69\111\113")]:CooldownRemains() > (30 - (v27(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\7\15\175\237\52\223\209\12\23\184\243\52\244", "\183\68\118\204\129\81\144")]:IsAvailable()) * 15))) or ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\35\168\100\229\6\141\28\189\120\235\24\139\29", "\226\110\205\16\132\107")]:CooldownRemains() < (v104 * 2)) and (not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\206\208\243\220\79\232\198\194\203\68\234\200", "\33\139\163\128\185")]:IsAvailable() or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\114\75\23\219\89\91\1\252\69\93\5\213", "\190\55\56\100")]:CooldownRemains() < (v104 * 1.5))))) and (v14:BuffDown(v85.MetamorphosisBuff) or (v14:BuffRemains(v85.MetamorphosisBuff) > v104) or not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\100\170\47\10\31\230\224\69\135\41\16\7\230\225", "\147\54\207\92\126\115\131")]:IsAvailable()) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\46\40\54\113\8\81\11\25\52\105\31\123\9", "\30\109\81\85\29\109")]:IsAvailable() or not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\214\127\93\162\63\223\232\246\103\81", "\156\159\17\52\214\86\190")]:IsAvailable() or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\152\234\179\187\171\233\168\176\156\234\169\174\171\238\169", "\220\206\143\221")]:CooldownRemains() > 5) or not v52 or (v10.CombatTime() < 10)) and v14:BuffDown(v85.InnerDemonBuff)) or (v108 < 15))) or (3911 < 2578)) then
					if (v24(v85.EyeBeam, not v15:IsInRange(v31)) or (4238 < 87)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\131\100\40\40\218\201\211\139\61\63\24\204\205\198\143\114\35\87\138\154", "\178\230\29\77\119\184\172");
					end
				end
				if ((2538 == 2538) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\215\178\11\31\114\220\244\176\9\30", "\152\149\222\106\123\23")]:IsCastable() and v38 and v97 and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\248\63\243\97\176\220\43", "\213\189\70\150\35")]:CooldownRemains() > 5) or not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\107\80\121\7\65\92\119", "\104\47\53\20")]:IsAvailable() or v14:HasTier(31, 2))) then
					if ((4122 == 4122) and v24(v85.BladeDance, not v15:IsInRange(v31))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\64\128\24\185\48\167\77\143\31\185\79\177\67\149\29\168\6\172\66\193\78\228", "\111\195\44\225\124\220");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\235\79\7\122\167\132\222\96\12\114\166\174", "\203\184\38\96\19\203")]:IsCastable() and not v14:IsMoving() and v50 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\24\125\96\108\203\56\125\106\111\203\58\118\106\82\207\43\106", "\174\89\19\25\33")]:IsAvailable() and v15:DebuffDown(v85.EssenceBreakDebuff) and (v94 >= 4)) or (2371 > 2654)) then
					if ((v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\63\30\83\87\242\149", "\107\79\114\50\46\151\231")) or v85[LUAOBFUSACTOR_DECRYPT_STR_0("\26\169\187\42\143\55\163\210\56\178\176\45\185\48\176\201\53\181", "\160\89\198\213\73\234\89\215")]:IsAvailable() or (3466 > 4520)) then
						if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or (951 >= 1027)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\91\120\179\247\201\119\126\178\193\195\68\112\185\251\133\90\126\160\255\209\65\126\186\190\213\68\112\173\251\215\8\34\228", "\165\40\17\212\158");
						end
					elseif ((v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\230\204\26\32\41\247", "\70\133\185\104\83")) or (1369 > 2250)) then
						if (v24(v87.SigilOfFlameCursor, not v15:IsInRange(40)) or (937 > 3786)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\23\76\67\35\197\59\74\66\21\207\8\68\73\47\137\22\74\80\43\221\13\74\74\106\202\17\87\87\37\219\68\22\20", "\169\100\37\36\74");
						end
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\52\143\176\95\23\160\174\81\9\145\167", "\48\96\231\194")]:IsCastable() and v51 and not v14:PrevGCDP(1, v85.VengefulRetreat) and not v14:IsMoving() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\251\85\27\33\10\219\174\145", "\227\168\58\110\77\121\184\207")]:IsAvailable() and (v94 >= (2 - v27(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\93\41\173\73\190\206\98\145\115\46\176\87\162", "\197\27\92\223\32\209\187\17")]:IsAvailable()))) and v15:DebuffDown(v85.EssenceBreakDebuff) and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\55\87\209\244\20\120\207\250\10\73\198", "\155\99\63\163")]:FullRechargeTime() < (v104 * 3)) or (v94 > 1)) and not v14:HasTier(31, 2)) or (901 > 4218)) then
					if ((4779 > 4047) and v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\150\217\179\130\174\187\133\221\160\132\175\129\194\195\174\153\184\144\139\222\175\205\234\214", "\228\226\177\193\237\217");
					end
				end
				v132 = 3;
			end
			if ((4050 > 1373) and (4 == v132)) then
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\61\165\47\124\30\138\49\114\0\187\56", "\19\105\205\93")]:IsReady() and v51 and not v14:PrevGCDP(1, v85.VengefulRetreat) and not v14:IsMoving() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\154\7\203\141\44\170\9\204", "\95\201\104\190\225")]:IsAvailable() and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\155\195\211\193\184\236\205\207\166\221\196", "\174\207\171\161")]:FullRechargeTime() < v85[LUAOBFUSACTOR_DECRYPT_STR_0("\207\242\12\247\253\243\236\240\14\246", "\183\141\158\109\147\152")]:CooldownRemains()) and v14:HasTier(31, 2) and v14:BuffDown(v85.FelBarrage) and not v99) or (1037 > 4390)) then
					if ((1407 <= 1919) and v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\1\244\3\59\54\225\0\45\0\240\9\108\27\233\24\45\29\239\3\34\73\178\88", "\108\76\105\134");
					end
				end
				if ((2526 >= 1717) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\200\205\176\238\221\216\209\163\232\197\238", "\174\139\165\209\129")]:IsReady() and v39 and not v98 and not v99 and v14:BuffDown(v85.FelBarrage)) then
					if (v24(v85.ChaosStrike, not v15:IsSpellInRange(v85.ChaosStrike)) or (3620 <= 2094)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\160\187\227\206\213\60\99\108\177\186\233\196\134\17\127\108\162\167\235\206\200\67\36\46", "\24\195\211\130\161\166\99\16");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\117\10\238\37\95\57\64\37\229\45\94\19", "\118\38\99\137\76\51")]:IsCastable() and not v14:IsMoving() and v50 and (v14:FuryDeficit() >= 30)) or (1723 >= 2447)) then
					if ((v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\237\42\4\11\12\50", "\64\157\70\101\114\105")) or v85[LUAOBFUSACTOR_DECRYPT_STR_0("\99\167\169\224\21\78\188\181\226\4\69\172\148\234\23\73\164\180", "\112\32\200\199\131")]:IsAvailable() or (1199 > 3543)) then
						if ((1617 < 3271) and v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\63\89\91\177\207\148\45\42\111\90\180\194\166\39\108\66\83\172\194\191\43\35\94\28\168\207\170\59\41\66\28\236\155", "\66\76\48\60\216\163\203");
						end
					elseif ((3085 > 1166) and (v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\185\147\107\224\80\220", "\68\218\230\25\147\63\174"))) then
						if ((4493 >= 3603) and v24(v87.SigilOfFlameCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\190\35\84\69\186\146\37\85\115\176\161\43\94\73\246\191\37\71\77\162\164\37\93\12\181\184\56\64\67\164\237\126\11", "\214\205\74\51\44");
						end
					end
				end
				if ((2843 <= 2975) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\220\73\238\254\123\251\72\231", "\23\154\44\130\156")]:IsCastable() and v46 and (v14:FuryDeficit() >= 40) and not v14:PrevGCDP(1, v85.VengefulRetreat)) then
					if (v24(v85.Felblade, not v15:IsSpellInRange(v85.Felblade)) or (1989 <= 174)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\163\161\172\58\18\21\163\237\188\57\7\16\178\164\161\56\83\68\246", "\115\113\198\205\206\86");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\162\82\242\104\145\68\246", "\58\228\55\158")]:IsCastable() and v36 and v47 and not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\153\134\221\43\50\185\32\185", "\85\212\233\176\78\92\205")]:IsAvailable() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\110\93\133\237\68\122\132\227\78\93\155", "\130\42\56\232")]:IsAvailable() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\207\172\33\193\69\62\231", "\95\138\213\68\131\32")]:CooldownDown() and v14:BuffDown(v85.UnboundChaosBuff) and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\12\45\173\113\99\57\32", "\22\74\72\193\35")]:Recharge() < v85[LUAOBFUSACTOR_DECRYPT_STR_0("\9\106\247\93\34\122\225\122\62\124\229\83", "\56\76\25\132")]:CooldownRemains()) or not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\123\210\184\35\193\93\196\137\52\202\95\202", "\175\62\161\203\70")]:IsAvailable())) or (209 > 2153)) then
					if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or (2020 == 1974)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\216\207\44\39\41\206\203\83\39\51\201\194\7\60\51\211\131\70\103", "\85\92\189\163\115");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\13\169\61\55\39\191\18\49\61\169", "\88\73\204\80")]:IsCastable() and v42 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\12\150\2\72\32\212\41\180\31\83\39\222", "\186\78\227\112\38\73")]:IsAvailable() and (v15:DebuffRemains(v85.BurningWoundDebuff) < 4)) or (1347 == 1360)) then
					if (v24(v85.DemonsBite, not v15:IsSpellInRange(v85.DemonsBite)) or (4461 == 3572)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\82\240\90\93\105\195\85\244\65\86\58\238\88\233\84\71\115\243\89\189\0\7", "\26\156\55\157\53\51");
					end
				end
				v132 = 5;
			end
			if ((v132 == 0) or (2872 == 318)) then
				if ((568 == 568) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\164\188\61\2\64\71\133\132\166\58\4\70", "\233\229\210\83\107\40\46")]:IsCastable() and v37 and v14:BuffUp(v85.InnerDemonBuff) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\236\71\38\215\8\206\80\34\222\10\210\75\33", "\101\161\34\82\182")]:CooldownRemains() <= (v14:GCD() * 3))) then
					if ((4200 == 4200) and v24(v85.Annihilation, not v15:IsSpellInRange(v85.Annihilation))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\3\87\247\211\235\142\47\252\4\86\240\155\240\141\58\233\25\80\241\213\162\208", "\78\136\109\57\158\187\130\226");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\8\58\247\246\59\57\236\253\12\58\237\227\59\62\237", "\145\94\95\153")]:IsCastable() and v36 and v52 and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\219\200\24\231\91\164\245", "\215\157\173\116\181\46")]:Charges() > 0) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\16\173\142\208\223\52\185", "\186\85\212\235\146")]:CooldownRemains() < 0.3) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\231\146\5\251\55\237\93\224\147\19\255\50", "\56\162\225\118\158\89\142")]:CooldownRemains() < (v104 * 2)) and (v10.CombatTime() > 5) and (v14:Fury() >= 30) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\117\11\197\189\54\209\93", "\184\60\101\160\207\66")]:IsAvailable()) or (4285 < 1369)) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or (3520 > 4910)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\135\114\187\52\132\105\176\14\144\121\168\35\135\125\168\113\144\115\168\48\150\117\179\63\194\47", "\220\81\226\28");
					end
				end
				if ((2842 <= 4353) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\37\208\140\252\239\193\6\217\176\254\254\213\22\212\150", "\167\115\181\226\155\138")]:IsCastable() and v36 and v52 and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\196\39\235\110\110\98\206", "\166\130\66\135\60\27\17")]:Charges() > 0) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\109\68\199\97\57\69\94\199\99\53", "\80\36\42\174\21")]:IsAvailable() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\107\3\36\127\64\19\50\88\92\21\54\113", "\26\46\112\87")]:IsAvailable() and (v10.CombatTime() > 1) and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\156\48\184\113\177\188\64\150\171\38\170\127", "\212\217\67\203\20\223\223\37")]:CooldownRemains() > 15) or ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\159\158\187\215\180\142\173\240\168\136\169\217", "\178\218\237\200")]:CooldownRemains() < v104) and (not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\146\176\235\223\184\188\229", "\176\214\213\134")]:IsAvailable() or v14:BuffUp(v85.MetamorphosisBuff) or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\209\180\179\246\173\87\84", "\57\148\205\214\180\200\54")]:CooldownRemains() > (15 + (10 * v27(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\49\228\54\56\115\61\251\29\53\98\0\248\49", "\22\114\157\85\84")]:IsAvailable()))))))) and ((v10.CombatTime() < 30) or ((v14:GCDRemains() - 1) < 0)) and (not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\237\197\26\208\84\247\188\205\221\22", "\200\164\171\115\164\61\150")]:IsAvailable() or (v14:BuffRemains(v85.InitiativeBuff) < v104) or (v10.CombatTime() > 4))) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or (3751 < 1643)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\241\13\66\134\184\225\15\122\145\187\224\17\64\130\170\180\17\74\151\191\224\10\74\141\254\160", "\227\222\148\99\37");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\5\87\92\241\252\53\71\94\196\252\39\64\87\247\237", "\153\83\50\50\150")]:IsCastable() and v36 and v52 and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\123\115\127\46\102\184\69", "\45\61\22\19\124\19\203")]:Charges() > 0) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\232\28\4\225\11\113\173\200\4\8", "\217\161\114\109\149\98\16")]:IsAvailable() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\55\51\43\121\178\119\23\2\42\121\189\127", "\20\114\64\88\28\220")]:IsAvailable() and (v10.CombatTime() > 1) and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\20\18\193\177\246\211\184\19\19\215\181\243", "\221\81\97\178\212\152\176")]:CooldownRemains() > 15) or ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\232\244\14\254\20\206\226\63\233\31\204\236", "\122\173\135\125\155")]:CooldownRemains() < (v104 * 2)) and (((v14:BuffRemains(v85.InitiativeBuff) < v104) and not v102 and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\161\216\5\155\58\48\197", "\168\228\161\96\217\95\81")]:CooldownRemains() <= v14:GCDRemains()) and (v14:Fury() > 30)) or not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\255\212\35\83\33\94\216", "\55\187\177\78\60\79")]:IsAvailable() or v14:BuffUp(v85.MetamorphosisBuff) or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\8\215\90\201\67\206\141", "\224\77\174\63\139\38\175")]:CooldownRemains() > (15 + (10 * v27(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\167\88\91\34\129\78\94\6\133\85\74\43\128", "\78\228\33\56")]:IsAvailable()))))))) and (v14:BuffDown(v85.UnboundChaosBuff) or v14:BuffUp(v85.InertiaBuff))) or (4911 == 3534)) then
					if ((3001 > 16) and v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\123\188\4\128\200\107\190\60\151\203\106\160\6\132\218\62\160\12\145\207\106\187\12\139\142\40", "\229\174\30\210\99");
					end
				end
				if ((2875 <= 3255) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\45\232\136\86\232\59\44\23\223\131\69\255\56\56\15", "\89\123\141\230\49\141\93")]:IsCastable() and v36 and v52 and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\213\116\250\62\5\89\251", "\42\147\17\150\108\112")]:Charges() > 0) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\38\168\36\107\238\233\27\175\59\122", "\136\111\198\77\31\135")]:IsAvailable() and not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\39\26\180\83\179\231\18\139\16\12\166\93", "\201\98\105\199\54\221\132\119")]:IsAvailable() and (v10.CombatTime() > 1) and (v14:BuffDown(v85.InitiativeBuff) or (v14:PrevGCDP(1, v85.DeathSweep) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\148\9\151\32\15\58\190\169\4\140\50\11\38", "\204\217\108\227\65\98\85")]:CooldownUp() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\125\203\244\234\56\201\93\247\231\228\34\211\88\204\231\232\45\212\87\204\251", "\160\62\163\149\133\76")]:IsAvailable())) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\255\174\4\59\202\215\180\4\57\198", "\163\182\192\109\79")]:IsAvailable()) then
					if ((368 < 4254) and v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\35\14\199\240\50\51\12\255\231\49\50\18\197\244\32\102\18\207\225\53\50\9\207\251\116\126", "\149\84\70\96\160");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\30\3\1\223\45\21\5", "\141\88\102\109")]:IsCastable() and v36 and v47 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\158\92\199\117\20\41\64\204", "\161\211\51\170\16\122\93\53")]:IsAvailable() and (v14:BuffRemains(v85.MomentumBuff) < (v104 * 2)) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\222\183\183\10\254\175\191", "\72\155\206\210")]:CooldownRemains() <= v104) and v15:DebuffDown(v85.EssenceBreakDebuff) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\100\118\85\10\54\98\123\90\13\54", "\83\38\26\52\110")]:CooldownDown()) or (4841 <= 2203)) then
					if ((4661 > 616) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\94\18\43\121\74\2\52\78\24\5\40\82\89\3\46\73\86\87\118\22", "\38\56\119\71");
					end
				end
				v132 = 1;
			end
			if ((v132 == 5) or (1943 == 2712)) then
				if ((4219 >= 39) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\170\221\26\235\173\67\132", "\48\236\184\118\185\216")]:IsCastable() and v36 and v47 and not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\200\178\90\53\193\32\240\176", "\84\133\221\55\80\175")]:IsAvailable() and not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\153\226\41\169\201\126\177\230\32\163\212", "\60\221\135\68\198\167")]:IsAvailable() and (v94 > 1) and v14:BuffDown(v85.UnboundChaosBuff)) then
					if ((3967 > 2289) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\232\184\244\188\80\204\253\181\184\145\77\205\239\169\241\140\76\153\187\235", "\185\142\221\152\227\34");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\107\204\80\243\79\28\241\126\201\86\247\70", "\151\56\165\55\154\35\83")]:IsCastable() and not v14:IsMoving() and (v14:FuryDeficit() >= 30) and v15:IsInRange(30)) or (851 > 2987)) then
					if ((4893 >= 135) and ((v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\176\79\4\247\165\81", "\142\192\35\101")) or v85[LUAOBFUSACTOR_DECRYPT_STR_0("\245\122\39\160\226\130\184\4\215\97\44\167\212\133\171\31\218\102", "\118\182\21\73\195\135\236\204")]:IsAvailable())) then
						if (v24(v87.SigilOfFlamePlayer, not v15:IsInRange(v31)) or (3084 > 3214)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\27\53\29\73\8\50\242\14\3\28\76\5\0\248\72\46\21\84\5\25\244\7\50\90\80\8\12\228\13\46\90\21\92", "\157\104\92\122\32\100\109");
						end
					elseif ((v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\160\179\221\217\50\53", "\203\195\198\175\170\93\71\237")) or (3426 < 2647)) then
						if (v24(v87.SigilOfFlameCursor, not v15:IsInRange(30)) or (1576 == 4375)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\61\66\57\220\93\46\243\40\116\56\217\80\28\249\110\89\49\193\80\5\245\33\69\126\214\68\3\239\33\89\126\128\9", "\156\78\43\94\181\49\113");
						end
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\86\237\201\172\5\80\91\123\252\193", "\25\18\136\164\195\107\35")]:IsCastable() and v42) or (2920 < 2592)) then
					if (v24(v85.DemonsBite, not v15:IsSpellInRange(v85.DemonsBite)) or (1110 >= 2819)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\236\40\164\64\124\175\254\186\225\57\172\15\96\179\213\185\252\36\166\65\50\233\150", "\216\136\77\201\47\18\220\161");
					end
				end
				if ((1824 <= 2843) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\11\233\39\232\29\207\138", "\226\77\140\75\186\104\188")]:IsReady() and v36 and v47 and not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\148\193\221\58\65\173\219\221", "\47\217\174\176\95")]:IsAvailable() and (v14:BuffRemains(v85.MomentumBuff) <= 20)) then
					if ((3062 == 3062) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\190\216\122\61\160\65\107\46\248\207\121\22\179\64\113\41\182\157\35\90", "\70\216\189\22\98\210\52\24");
					end
				end
				if ((716 <= 4334) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\252\218\175\181\198\201\215", "\179\186\191\195\231")]:IsReady() and v36 and v47 and not v15:IsInRange(v31) and not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\212\48\21\225\247\43\13\233", "\132\153\95\120")]:IsAvailable()) then
					if ((1001 < 3034) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\183\2\18\229\207\179\185\242\28\34\227\219\180\184\189\0\109\162\131", "\192\209\210\110\77\151\186");
					end
				end
				if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\214\6\44\238\250\194\245\15\16\236\235\214\229\2\54", "\164\128\99\66\137\159")]:IsCastable() and v36 and v52 and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\38\140\229\140\21\154\225", "\222\96\233\137")]:Charges() > 0) and not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\144\189\174\11\129\242\228\176\165\162", "\144\217\211\199\127\232\147")]:IsAvailable() and not v15:IsInRange(v31)) or (977 > 1857)) then
					if (v24(v85.VengefulRetreat, not v15:IsInRange(v31), nil, true) or (868 > 897)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\238\42\48\47\208\67\23\72\199\61\59\60\199\64\3\80\184\61\49\60\212\81\11\75\246\111\104\120", "\36\152\79\94\72\181\37\98");
					end
				end
				v132 = 6;
			end
		end
	end
	local function v118()
		local v133 = 0;
		while true do
			if ((v133 == 4) or (1115 == 4717)) then
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\47\254\30\246\21\245\13\241", "\130\124\155\106")][LUAOBFUSACTOR_DECRYPT_STR_0("\192\216\243\138\175\239\111\182\212\197\210\170\160\228\121\186", "\223\181\171\150\207\195\150\28")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\63\247\186\0\66\61\240", "\105\44\90\131\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\243\183\148\13\42\254\237\189\171\24\54\240\243\187\170", "\94\159\128\210\217\104")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\252\18\171\86\113\254\105", "\26\48\153\102\223\63\31\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\83\232\199\10\69\197\230\12\84", "\147\98\32\141")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\43\70\247\222\15\88\76\11", "\43\120\35\131\170\102\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\81\10\158\165\172\177\138\112\3\132\164\160\181\179\93\18\143\149\129", "\228\52\102\231\214\197\208")];
				v133 = 5;
			end
			if ((2740 < 4107) and (1 == v133)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\38\243\228\13\2\72\18\229", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\168\235\30\40\186\250\50\30\172\235\63\61", "\90\77\219\142")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\1\53\45\69\9\125\245", "\26\134\100\65\89\44\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\228\240\53\7\161\252\236\62\48\134\248\247\53", "\196\145\131\80\67")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\181\18\28\17\230\25\163", "\136\126\208\102\104\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\153\203\102\188\65\56\95\123\143\236\81\170\83\54", "\49\24\234\174\35\207\50\93")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\247\233\156\120\2\245\238", "\17\108\146\157\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\94\208\17\200\54\173\105\198\21\224", "\200\43\163\116\141\79")];
				v133 = 2;
			end
			if ((284 < 700) and (v133 == 5)) then
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\229\97\222\227\133\30\197", "\182\126\128\21\170\138\235\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\134\223\33\231\139\28\34\22\131\213\38\239\149\36\57\18\131\249\17", "\102\235\186\85\134\230\115\80")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\9\42\75\123\218\37\68", "\66\55\108\94\63\18\180")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\133\128\31\50\87\0\186\140\35\47\122\48", "\57\116\237\229\87\71")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\180\249\243\126\224\64\185", "\39\202\209\141\135\23\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\63\16\25\59\249\241\23\12\9\32\253\250\0\12\30\38\241\241\52", "\152\159\83\105\106\82")] or LUAOBFUSACTOR_DECRYPT_STR_0("\145\202\80\235\204\78", "\60\225\166\49\146\169");
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\27\59\62\8\9\40\13", "\103\79\126\79\74\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\191\115\202\96\87\27\180\91\214\112\76\31\191\76\223\122\90\31\168", "\122\218\31\179\19\62")] or 0;
				break;
			end
			if ((386 >= 137) and (v133 == 0)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\185\38\96\143\59\124\152", "\235\26\220\82\20\230\85\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\157\178\236\227\122\134\168\225\203\120\137\181\224\205\122", "\20\232\193\137\162")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\218\209\178\238\130\16\98", "\17\66\191\165\198\135\236\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\26\188\171\49\243\233\232\212\43\174\160\16\250", "\177\111\207\206\115\159\136\140")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\140\4\0\221\65\88\22", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\40\232\49\240\55\204\40\222\6\234\63\200\62", "\86\163\91\141\114\152")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\14\96\103\51\93\12\103", "\90\51\107\20\19")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\227\128\204\50\131\227\144\226\56\160\241\130\230\62", "\93\237\144\229\143")];
				v133 = 1;
			end
			if ((923 == 923) and (v133 == 2)) then
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\140\51\41\151\185\250\228\172", "\131\223\86\93\227\208\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\86\179\144\24\185\193\68\164\164\28\178\230", "\213\131\37\214\214\125")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\21\46\49\171\232\40\44\54", "\129\70\75\69\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\83\216\246\207\121\227\68\199\242\237\121", "\143\38\171\147\137\28")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\135\173\231\10\237\211\195", "\180\176\226\217\147\99\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\170\42\33\214\181\29\18\192\177", "\103\179\217\79")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\178\8\193\72\130\164\89", "\195\42\215\124\181\33\236")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\74\50\25\41\249\4\79\50\10\32\245\29\92\36\42", "\152\109\57\87\94\69")];
				v133 = 3;
			end
			if ((3 == v133) or (4173 == 359)) then
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\210\30\183\183\220\83\187", "\200\153\183\106\195\222\178\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\240\141\20\68\87\61\239\137\41\64\85\60\194\157\47\72", "\58\82\131\232\93\41")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\82\196\1\84\49\132\68", "\95\227\55\176\117\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\109\38\120\162\31\119\47\100\173\62\114\34\70\174", "\203\120\30\67\43")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\32\89\251\208\255\34\94", "\185\145\69\45\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\159\12\28\146\212\152\16\14\129\208\139\22\15\163", "\188\234\127\121\198")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\55\7\151\49\60\20\144", "\227\88\82\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\86\12\191\145\7\125\68\26\188\178\14\65\70\11\168\162\3\103", "\19\35\127\218\199\98")];
				v133 = 4;
			end
		end
	end
	local function v119()
		local v134 = 0;
		while true do
			if ((1722 == 1722) and (v134 == 2)) then
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\140\208\149\136\219\196\154", "\181\163\233\164\225\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\69\152\59\85\92\158\44", "\23\48\235\94")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\79\223\204\73\94\61\213\111", "\178\28\186\184\61\55\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\209\222\66\18\247\26\253\193\223\80\61\254\5", "\149\164\173\39\92\146\110")];
				v134 = 3;
			end
			if ((v134 == 1) or (3994 <= 3820)) then
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\3\87\198\78\112\35\208", "\68\163\102\35\178\39\30")][LUAOBFUSACTOR_DECRYPT_STR_0("\171\99\223\225\6\185\166\3\171\96\206\206\12\187", "\113\222\16\186\167\99\213\227")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\11\239\226\39\0\252\229", "\150\78\110\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\214\34\210\173\25\182\76\170\195\10\232\183\27\173\89", "\32\229\165\71\129\196\126\223")];
				v134 = 2;
			end
			if ((1488 < 1641) and (v134 == 0)) then
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\211\217\213\192\175\66\160", "\37\211\182\173\161\169\193")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\41\72\250\32\122\182\228\20\66\207\41", "\217\151\90\45\185\72\27")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\121\243\6\95\205\123\244", "\54\163\28\135\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\61\200\88\166\71\108\58\206\77\150", "\31\72\187\61\226\46")];
				v134 = 1;
			end
			if ((433 <= 2235) and (v134 == 4)) then
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\55\184\84\244\85\53\191", "\157\59\82\204\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\43\55\228\243\229\217\214\165\44\55\237\253", "\209\88\94\131\154\137\138\179")] or "";
				break;
			end
			if ((v134 == 3) or (1838 > 2471)) then
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\192\34\4\11\19\21\244\52", "\123\147\71\112\127\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\206\193\151\99\110\252", "\38\172\173\226\17")] or 0;
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\126\20\56\251\68\31\43\252", "\143\45\113\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\182\189\8\52\189\170\11\61\180\179\52\12", "\92\216\216\124")] or 0;
				v134 = 4;
			end
		end
	end
	local function v120()
		local v135 = 0;
		while true do
			if ((2444 < 3313) and (v135 == 4)) then
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\148\178\221\200\174\185\206\207", "\188\199\215\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\212\8\81\127\228\249\32\81\120\231\238\25\80\105\237\253\5", "\136\156\105\63\27")];
				break;
			end
			if ((v135 == 0) or (3685 <= 185)) then
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\27\164\208\104\23\45\54\49", "\66\72\193\164\28\126\67\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\225\37\175\80\50\68\226\33\169\81\40\101\196\36\173\91\45", "\22\135\76\200\56\70")] or 0;
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\53\236\48\84\239\138\35", "\129\237\80\152\68\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\85\161\23\227\25\27\122\68\174\2\224", "\56\49\200\100\147\124\119")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\255\59\171\228\197\48\184\227", "\144\172\94\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\1\182\66\54\29\183\87\48\56\171\83\44\60\182\82\42", "\39\68\111\194")];
				v135 = 1;
			end
			if ((738 <= 1959) and (v135 == 3)) then
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\238\43\180\192\179\236\44", "\169\221\139\95\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\142\126\51\54\46\205\159\112\49\39\14\238", "\70\190\235\31\95\66")] or 0;
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\231\14\242\236\180\229\9", "\133\218\130\122\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\250\226\200\213\173\63\12\240\247\205\211\173\16\12", "\88\92\159\131\164\188\195")] or 0;
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\43\171\95\222\229\218\147", "\189\224\78\223\43\183\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\6\249\139\26\200\32\251\186\25\213\39\243\132\56\192\35\249", "\161\78\156\234\118")] or "";
				v135 = 4;
			end
			if ((v135 == 2) or (1317 == 3093)) then
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\24\42\12\60\255\35\9", "\68\122\125\94\120\85\145")][LUAOBFUSACTOR_DECRYPT_STR_0("\3\14\198\80\195\220\174\4\43\198\74\192\250\158", "\218\119\124\175\62\168\185")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\245\92\208\172\254\79\215", "\164\197\144\40")][LUAOBFUSACTOR_DECRYPT_STR_0("\150\227\175\163\216\183\143\228\162\152\201\185\141\245", "\214\227\144\202\235\189")];
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\160\147\111\25\189\84\47", "\92\141\197\231\27\112\211\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\236\143\139\212\231\243\131\173\214\214\240\158\170\222\232", "\177\134\159\234\195")];
				v135 = 3;
			end
			if ((v135 == 1) or (2611 >= 4435)) then
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\163\243\211\112\185\209\181", "\215\182\198\135\167\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\164\71\254\77\159\91\255\88\153\102\228\68\148\126\226\65\153\76\230\65\158\93", "\40\237\41\138")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\244\113\238\236\67\201\115\233", "\42\167\20\154\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\240\182\71\99\51\95\238\182\118\121\51\79\237\170\77\125\37", "\65\42\158\194\34\17")];
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\34\70\24\36\227\28\253", "\142\122\71\50\108\77\141\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\177\250\44\41\28\172\244\29\47\6", "\91\117\194\159\120")];
				v135 = 2;
			end
		end
	end
	local function v121()
		local v136 = 0;
		while true do
			if ((v136 == 4) or (117 > 4925)) then
				v104 = v14:GCD() + 0.05;
				if ((107 <= 4905) and (v26.TargetIsValid() or v14:AffectingCombat())) then
					local v182 = 0;
					while true do
						if ((0 == v182) or (1004 > 4035)) then
							v107 = v10.BossFightRemains(nil, true);
							v108 = v107;
							v182 = 1;
						end
						if ((v182 == 1) or (2802 < 369)) then
							if ((1497 <= 2561) and (v108 == 11111)) then
								v108 = v10.FightRemains(Enemies8y, false);
							end
							break;
						end
					end
				end
				v32 = v113();
				v136 = 5;
			end
			if ((v136 == 5) or (816 > 1712)) then
				if (v32 or (2733 == 2971)) then
					return v32;
				end
				if ((2599 < 4050) and v72) then
					local v183 = 0;
					while true do
						if ((2034 == 2034) and (v183 == 0)) then
							v32 = v26.HandleIncorporeal(v85.Imprison, v87.ImprisonMouseover, 30, true);
							if ((3040 < 4528) and v32) then
								return v32;
							end
							break;
						end
					end
				end
				if ((v26.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or (2092 <= 2053)) then
					local v184 = 0;
					local v185;
					while true do
						if ((2120 < 4799) and (v184 == 3)) then
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\101\19\215\175\188\77\10\211\175\190\109\11\200\161", "\208\44\126\186\192")]:IsCastable() and v49 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\214\60\173\212\17\213\199\93\254\30\161", "\46\151\122\196\166\116\156\169")]:IsAvailable() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\204\227\67\8\239\236\236", "\155\133\141\38\122")]:IsAvailable() and v14:BuffDown(v85.UnboundChaosBuff) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\12\39\161\78\67\126\177\44\37\162\96\90\109\164", "\197\69\74\204\33\47\31")]:FullRechargeTime() < (v104 * 2)) and v15:DebuffDown(v85.EssenceBreakDebuff)) or (4538 <= 389)) then
								if ((270 <= 1590) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\249\66\87\136\252\78\78\142\255\65\101\134\229\93\91\199\253\78\83\137\176\28", "\231\144\47\58");
								end
							end
							if ((1625 > 1265) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\148\221\214\71\13\46\199", "\89\210\184\186\21\120\93\175")]:IsCastable() and v36 and v47 and v14:BuffUp(v85.UnboundChaosBuff) and (((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\152\94\113\218\117\59\165\90\115\219\88\47\163\82", "\90\209\51\28\181\25")]:Charges() == 2) and v15:DebuffDown(v85.EssenceBreakDebuff)) or (v14:PrevGCDP(1, v85.EyeBeam) and v14:BuffUp(v85.InertiaBuff) and (v14:BuffRemains(v85.InertiaBuff) < 3)))) then
								if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or (51 >= 920)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\214\126\91\209\173\197\104\95\174\178\209\114\89\174\235", "\223\176\27\55\142");
								end
							end
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\16\179\203\157\49\181\218", "\213\68\219\174")]:IsCastable() and (v10.CombatTime() < 10) and (not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\34\238\38\245\62\204\62", "\31\107\128\67\135\74\165\95")]:IsAvailable() or (v14:BuffUp(v85.MetamorphosisBuff) and v15:DebuffDown(v85.EssenceBreakDebuff)))) or (2968 <= 1998)) then
								if (v22(v85.TheHunt, not v15:IsSpellInRange(v85.TheHunt)) or (3085 <= 2742)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\204\224\249\114\73\164\214\252\188\64\64\184\214\168\170", "\209\184\136\156\45\33");
								end
							end
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\46\197\120\7\180\6\220\124\7\182\38\221\103\9", "\216\103\168\21\104")]:IsCastable() and v49 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\81\163\70\182\108\164\66", "\196\24\205\35")]:IsAvailable() and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\11\146\230\36\43\138\238", "\102\78\235\131")]:CooldownRemains() < (v104 * 2)) or v14:BuffUp(v85.MetamorphosisBuff)) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\223\61\39\65\73\58\178\22\232\43\53\79", "\84\154\78\84\36\39\89\215")]:CooldownRemains() < (v104 * 3)) and v14:BuffDown(v85.UnboundChaosBuff) and v14:BuffDown(v85.InertiaBuff) and v15:DebuffDown(v85.EssenceBreakDebuff)) or (376 >= 2083)) then
								if ((4191 > 1232) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\244\236\91\87\9\252\245\95\87\11\194\224\67\74\4\189\236\87\81\11\189\180", "\101\157\129\54\56");
								end
							end
							v184 = 4;
						end
						if ((6 == v184) or (1505 > 4873)) then
							if ((3880 < 4534) and v32) then
								return v32;
							end
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\92\250\16\74\118\221\17\68\124\250\14", "\37\24\159\125")]:IsAvailable()) or (2368 >= 2541)) then
								if (v24(v85.Pool) or (4733 <= 4103)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\202\169\122\78\154\162\112\79\213\168\74\64\214\167\113\71\201", "\34\186\198\21");
								end
							end
							break;
						end
						if ((v184 == 4) or (1207 == 4273)) then
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\52\164\135\164\47\120\9\160\133\165\2\108\15\168", "\25\125\201\234\203\67")]:IsCastable() and v49 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\80\250\29\17\0\46\18", "\115\25\148\120\99\116\71")]:IsAvailable() and v14:BuffDown(v85.UnboundChaosBuff) and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\37\48\180\43\77\13\41\176\43\79\45\40\171\37", "\33\108\93\217\68")]:FullRechargeTime() < v85[LUAOBFUSACTOR_DECRYPT_STR_0("\254\88\178\168\213\72\164\143\201\78\160\166", "\205\187\43\193")]:CooldownRemains()) or not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\219\97\22\218\240\113\0\253\236\119\4\212", "\191\158\18\101")]:IsAvailable()) and v15:DebuffDown(v85.EssenceBreakDebuff) and (v14:BuffDown(v85.MetamorphosisBuff) or (v14:BuffRemains(v85.MetamorphosisBuff) > 6)) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\231\207\134\179\170\225\194\137\180\170", "\207\165\163\231\215")]:CooldownDown() and ((v14:Fury() < 75) or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\228\245\248\82\33\84\199\247\250\83", "\16\166\153\153\54\68")]:CooldownRemains() < (v104 * 2)))) or (2005 == 2529)) then
								if ((986 < 3589) and v24(v85.ImmolationAura, not v15:IsInRange(v31))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\219\190\205\73\56\32\237\219\188\206\121\53\52\235\211\243\205\71\61\47\185\132", "\153\178\211\160\38\84\65");
								end
							end
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\164\14\86\25\151\24\82", "\75\226\107\58")]:IsCastable() and v36 and v47 and ((v14:BuffRemains(v85.UnboundChaosBuff) < (v104 * 2)) or (v15:TimeToDie() < (v104 * 2)))) or (3119 == 430)) then
								if ((2409 <= 3219) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\94\219\29\69\3\215\222\80\158\28\123\24\204\141\0", "\173\56\190\113\26\113\162");
								end
							end
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\237\219\33\55\226\216\214", "\151\171\190\77\101")]:IsCastable() and v36 and v47 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\236\33\253\187\236\116\10", "\107\165\79\152\201\152\29")]:IsAvailable() and v14:BuffDown(v85.InertiaBuff) and v14:BuffUp(v85.UnboundChaosBuff) and ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\114\87\237\233\81\126\90", "\31\55\46\136\171\52")]:CooldownRemains() + 3) > v14:BuffRemains(v85.UnboundChaosBuff)) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\243\36\221\240\212\12\221\250\210\45", "\148\177\72\188")]:CooldownDown() or v85[LUAOBFUSACTOR_DECRYPT_STR_0("\131\165\68\214\168\181\82\241\180\179\86\216", "\179\198\214\55")]:CooldownUp())) or (898 > 2782)) then
								if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or (2250 <= 1764)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\246\9\126\73\87\198\227\4\50\123\68\218\254\76\43", "\179\144\108\18\22\37");
								end
							end
							if ((693 == 693) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\224\166\23\187\218\213\171", "\175\166\195\123\233")]:IsCastable() and v36 and v47 and v14:BuffUp(v85.UnboundChaosBuff) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\198\204\88\91\228\230\195", "\144\143\162\61\41")]:IsAvailable() and v14:BuffDown(v85.InertiaBuff) and (v14:BuffUp(v85.MetamorphosisBuff) or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\197\192\14\85\124\132\54\194\193\24\81\121", "\83\128\179\125\48\18\231")]:CooldownRemains() > 10))) then
								if (v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive)) or (2529 == 438)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\91\178\255\226\85\11\78\191\179\208\70\23\83\247\162\141", "\126\61\215\147\189\39");
								end
							end
							v184 = 5;
						end
						if ((1751 > 1411) and (v184 == 5)) then
							v32 = v116();
							if ((4182 == 4182) and v32) then
								return v32;
							end
							if ((v14:BuffUp(v85.MetamorphosisBuff) and (v14:BuffRemains(v85.MetamorphosisBuff) < v104) and (v94 < 3)) or (4666 <= 611)) then
								local v189 = 0;
								while true do
									if ((v189 == 0) or (4737 <= 4525)) then
										v32 = v115();
										if ((4367 >= 3735) and v32) then
											return v32;
										end
										break;
									end
								end
							end
							v32 = v117();
							v184 = 6;
						end
						if ((2426 == 2426) and (v184 == 0)) then
							if ((21 < 1971) and not v14:AffectingCombat()) then
								local v190 = 0;
								while true do
									if ((v190 == 0) or (2922 <= 441)) then
										v32 = v114();
										if ((3624 >= 1136) and v32) then
											return v32;
										end
										break;
									end
								end
							end
							if ((2043 < 2647) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\96\68\21\38\30\81\170\110\74\28\60\8", "\207\35\43\123\85\107\60")]:IsAvailable() and v40 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\83\165\174\249\108\125\175\141\235\126\121\169", "\25\16\202\192\138")]:IsReady() and v69 and not v14:IsCasting() and not v14:IsChanneling() and v26.UnitHasMagicBuff(v15)) then
								if (v24(v85.ConsumeMagic, not v15:IsSpellInRange(v85.ConsumeMagic)) or (354 >= 1534)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\250\217\168\227\189\241\239\244\189\247\187\243\248\139\169\227\164\245\250\206", "\148\157\171\205\130\201");
								end
							end
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\5\209\120\27\196\229\43", "\150\67\180\20\73\177")]:IsReady() and v36 and v47 and not v15:IsInRange(v31)) or (3764 >= 4876)) then
								if ((3676 >= 703) and v24(v85.FelRush, not v15:IsSpellInRange(v85.ThrowGlaive))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\139\29\22\114\159\13\9\69\205\10\21\89\140\12\19\66\131\88\13\69\136\22\90\98\162\42", "\45\237\120\122");
								end
							end
							if ((3811 > 319) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\227\224\176\35\192\207\174\45\222\254\167", "\76\183\136\194")]:IsReady() and v51 and v13.ValueIsInArray(v109, v15:NPCID())) then
								if ((47 < 1090) and v24(v85.ThrowGlaive, not v15:IsSpellInRange(v85.ThrowGlaive))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\124\233\225\60\85\93\84\110\233\165\44\88\74\84\124\234\228\53\85\92\84\104\227\228\59\68\15\4\127\244\165\44\81\93\19\127\242", "\116\26\134\133\88\48\47");
								end
							end
							v184 = 1;
						end
						if ((v184 == 2) or (1371 >= 2900)) then
							v101 = (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\165\212\208\169\175\2\179\46", "\67\232\187\189\204\193\118\198")]:IsAvailable() and v14:BuffDown(v85.MomentumBuff)) or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\162\32\176\50\47\11\238", "\143\235\78\213\64\91\98")]:IsAvailable() and v14:BuffDown(v85.InertiaBuff));
							v185 = v30(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\168\81\129\203\117\183\128", "\214\237\40\228\137\16")]:BaseDuration(), v14:GCD());
							v102 = v85[LUAOBFUSACTOR_DECRYPT_STR_0("\161\230\226\214\13\175\134", "\198\229\131\143\185\99")]:IsAvailable() and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\116\159\187\118\95\143\173\81\67\137\169\120", "\19\49\236\200")]:IsAvailable() and Var3MinTrinket and (v108 > (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\211\50\226\182\233\181\236\39\254\184\247\179\237", "\218\158\87\150\215\132")]:CooldownRemains() + 30 + (v27(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\200\22\216\246\34\39\223\254\26\253\231\37\54\196\245\7", "\173\155\126\185\130\86\66")]:IsAvailable()) * 60))) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\200\163\174\198\133\227\247\182\178\200\155\229\246", "\140\133\198\218\167\232")]:CooldownRemains() < 20) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\152\43\160\124\137\186\60\164\117\139\166\39\167", "\228\213\78\212\29")]:CooldownRemains() > (v185 + (v104 * (v27(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\174\66\184\0\249\163\73\187\10\229", "\139\231\44\214\101")]:IsAvailable()) + 2))));
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\240\226\11\81\28\176\37\31\214\225\39\75\2\176", "\118\185\143\102\62\112\209\81")]:IsCastable() and v49 and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\110\113\46\227\163\28\14\61", "\88\60\16\73\134\197\117\124")]:IsAvailable() and (v94 >= 3) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\114\230\249\204\68\116\235\246\203\68", "\33\48\138\152\168")]:CooldownDown() or v15:DebuffDown(v85.EssenceBreakDebuff))) or (1126 <= 504)) then
								if (v24(v85.ImmolationAura, not v15:IsInRange(v31)) or (3732 == 193)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\123\27\61\94\205\54\102\31\63\95\254\54\103\4\49\17\204\54\123\24\112\3", "\87\18\118\80\49\161");
								end
							end
							v184 = 3;
						end
						if ((3344 >= 3305) and (v184 == 1)) then
							if ((v85[LUAOBFUSACTOR_DECRYPT_STR_0("\42\201\178\235\170\85\18\192\169\242\184", "\18\126\161\192\132\221")]:IsReady() and v51 and v13.ValueIsInArray(v109, v16:NPCID())) or (2885 < 1925)) then
								if (v24(v87.ThrowGlaiveMouseover, not v15:IsSpellInRange(v85.ThrowGlaive)) or (4542 <= 1594)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\89\39\170\0\83\77\104\186\11\22\75\32\171\68\80\83\41\163\1\69\31\58\171\5\85\75\104\190\1\68\31\37\161\17\69\90\39\184\1\68", "\54\63\72\206\100");
								end
							end
							v97 = v85[LUAOBFUSACTOR_DECRYPT_STR_0("\238\80\87\105\241\89\196\86\74\126", "\27\168\57\37\26\133")]:IsAvailable() or v85[LUAOBFUSACTOR_DECRYPT_STR_0("\25\184\125\161\219\34\172\78\189\222\35", "\183\77\202\28\200")]:IsAvailable() or (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\52\59\136\7\4\7\129\13\24\33\144", "\104\119\83\233")]:IsAvailable() and v14:BuffDown(v85.ChaosTheoryBuff)) or (v94 > 1);
							v98 = v97 and (v14:Fury() < (75 - (v27(v85[LUAOBFUSACTOR_DECRYPT_STR_0("\209\253\42\45\77\215\244\38\38\70\230", "\35\149\152\71\66")]:IsAvailable()) * 20))) and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\59\228\67\180\63\61\233\76\179\63", "\90\121\136\34\208")]:CooldownRemains() < v104);
							v99 = v85[LUAOBFUSACTOR_DECRYPT_STR_0("\227\11\88\17\201\7\86", "\126\167\110\53")]:IsAvailable() and not v85[LUAOBFUSACTOR_DECRYPT_STR_0("\31\28\39\246\216\25\40\2\55", "\95\93\112\78\152\188")]:IsAvailable() and (v85[LUAOBFUSACTOR_DECRYPT_STR_0("\228\236\128\55\225\191\223", "\178\161\149\229\117\132\222")]:CooldownRemains() < (v104 * 2)) and (v14:FuryDeficit() > 30);
							v184 = 2;
						end
					end
				end
				break;
			end
			if ((338 <= 3505) and (v136 == 1)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\47\131\126\51\23\137\106", "\84\123\236\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\132\169", "\213\144\235\202\119\204")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\23\23\217\45\36\38\94", "\45\67\120\190\74\72\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\45\232", "\137\64\66\141\197\153\232\142")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\223\37\161\132\6\195", "\232\99\176\66\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\37\59", "\76\140\65\72\102\27\237\153")];
				v136 = 2;
			end
			if ((69 == 69) and (v136 == 2)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\126\213\17\213\219\4\173", "\222\42\186\118\178\183\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\80\227\82\143\80\233\74\158", "\234\61\140\36")];
				if (v14:IsDeadOrGhost() or (672 == 368)) then
					return;
				end
				if ((1019 == 1019) and v85[LUAOBFUSACTOR_DECRYPT_STR_0("\8\208\170\96\0\55\216\190\86\6\50\207\175\98\27", "\111\65\189\218\18")]:IsAvailable()) then
					v31 = 10;
				end
				v136 = 3;
			end
			if ((v136 == 0) or (290 > 2746)) then
				v119();
				v118();
				v120();
				v136 = 1;
			end
			if ((1923 < 4601) and (v136 == 3)) then
				v92 = v14:GetEnemiesInMeleeRange(v31);
				v93 = v14:GetEnemiesInMeleeRange(20);
				if (v34 or (3957 == 2099)) then
					local v186 = 0;
					while true do
						if ((4006 > 741) and (v186 == 0)) then
							v94 = ((#v92 > 0) and #v92) or 1;
							v95 = #v93;
							break;
						end
					end
				else
					local v187 = 0;
					while true do
						if ((2359 <= 3733) and (v187 == 0)) then
							v94 = 1;
							v95 = 1;
							break;
						end
					end
				end
				v136 = 4;
			end
		end
	end
	local function v122()
		local v137 = 0;
		while true do
			if ((v137 == 0) or (4596 <= 2402)) then
				v85[LUAOBFUSACTOR_DECRYPT_STR_0("\218\29\215\83\203\246\15\242\82\215\246\12\225\88\192\237\14\195", "\162\152\104\165\61")]:RegisterAuraTracking();
				v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\229\46\164\114\115\165\233\42\191\114\126\165\229\58\188\105\117\247\141\45\171\61\85\245\196\44\252\61\67\240\221\63\189\111\100\224\201\111\176\100\48\253\230\46\188\120\100\234\131", "\133\173\79\210\29\16"));
				break;
			end
		end
	end
	v20.SetAPL(577, v121, v122);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\168\108\228\51\178\88\232\38\130\114\197\62\131\104\232\57\178\84\236\61\130\127\163\39\152\125", "\75\237\28\141")]();

