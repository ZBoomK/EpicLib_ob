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
		if ((v5 == 1) or (2669 <= 2409)) then
			return v6(...);
		end
		if ((v5 == 0) or (1401 > 4696)) then
			v6 = v0[v4];
			if (not v6 or (3280 < 1321)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\213\11\216\199\228\7\231\183\198\16\210\198\149\41\243\186", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\5\37\118\138\237\174\54", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\118\216\34", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67", "\38\156\55\199")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\155\109\121\36\31", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\52\170\221\203\132\31\36\28\179\221", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\100\67\3\55\70", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\158\202\217\14", "\75\220\163\183\106\98")];
	local v22 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\35\181\174\24\247", "\185\98\218\235\87")];
	local v23 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\232\24\52\201\240", "\202\171\92\71\134\190")];
	local v24 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\10\192\63\156", "\232\73\161\76")];
	local v25 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\139\203\71\78\13", "\126\219\185\34\61")];
	local v26 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\47\193\83\127\113\121\224", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\255\47\217\1\161\61\194", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\229\63", "\199\235\144\82\61\152")];
	local v27 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\36\25\180\38\8\24\170", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\66\117\6\160\17\201\81", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\33\47\140", "\156\168\78\64\224\212\121")];
	local v28 = false;
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
	local function v47()
		local v107 = 0;
		while true do
			if ((4927 >= 2303) and (v107 == 0)) then
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\235\177\218\14\224\162\221", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\59\90\10\36\93\241\87\36\76", "\152\54\72\63\88\69\62")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\193\250\72\221\202\233\79", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\77\0\1\34\236\30\81\80\2\25\40\249\27\87\80", "\114\56\62\101\73\71\141")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\236\207\208\177\231\220\215", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\227\48\190\175\240\12\226\233\37\187\169\240\37\211\235\52", "\107\178\134\81\210\198\158")] or 0;
				v107 = 1;
			end
			if ((3462 >= 1032) and (v107 == 2)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\17\19\214\164\110\147\196\11\48\218\162\116\181\192\10\9", "\230\180\127\103\179\214\28")] or 0;
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\5\65\164\249\218\188\189\62\74\186\242\248\164\160\5\65\186\226\220\184", "\175\204\201\113\36\214\139")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\118\173\133\33\191\109\169\148\7\165\106\188\147\59\162\116\189", "\83\205\24\217\224")] or 0;
				v107 = 3;
			end
			if ((v107 == 3) or (1077 >= 2011)) then
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\231\213\237\60\237\189\115\188\243\213\234\63\207\190\119\176\245", "\30\222\146\161\162\90\174\210")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\117\33\97\247\117\70\108\40\118\203\83\76\92", "\32\56\64\19\156\58")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\116\89\68\243\126\143\137\45\86\68\70\210\90\165", "\107\57\54\43\157\21\230\231")];
				v107 = 4;
			end
			if ((1543 < 2415) and (v107 == 4)) then
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\142\5\225\176\210\200\200", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\174\147\71\240\114\113\50\135\177", "\24\92\207\225\44\131\25")] or 0;
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\214\172\88\18\115\76\192", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\216\52\89\175\220\51\122\180\222\41\64\149\233", "\44\221\185\64")] or 0;
				break;
			end
			if ((v107 == 1) or (4444 < 2015)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\10\131\251\195\205\8\178\248\222\202\0\140\223\250", "\170\163\111\226\151")] or 0;
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\63\200\58\226\128\32\217\26\244\149\35\195\23", "\135\225\76\173\114")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\216\17\252\108\254\190\201\31\254\125\222\157", "\150\205\189\112\144\24")] or 0;
				v107 = 2;
			end
		end
	end
	local v48 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\34\232\69\82\124\15\244", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\74\54\41\54\62\160\89", "\81\206\60\83\91\79")];
	local v49 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\106\185\197\123\43", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\154\35\114\31\42\248\234", "\143\216\66\30\126\68\155")];
	local v50 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\142\218\24\194\193", "\129\202\168\109\171\165\195\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\89\59\217\208\23\227", "\134\66\56\87\184\190\116")];
	local v51 = {v50[LUAOBFUSACTOR_DECRYPT_STR_0("\17\56\27\169\22\249\46\51\26\35\8\184\13\254\51\48\56\5\6\182\22\249\51\58\43\34", "\85\92\81\105\219\121\139\65")]:ID()};
	local v52 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\217\161\69\76\120", "\191\157\211\48\37\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\30\248\29\52\220\26", "\90\191\127\148\124")];
	local v53 = v13:GetEquipment();
	local v54 = (v53[13] and v19(v53[13])) or v19(0);
	local v55 = (v53[14] and v19(v53[14])) or v19(0);
	local v56 = false;
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
	local v74 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\92\149\59\30\124", "\119\24\231\78")];
	local v75 = 11111;
	local v76 = 11111;
	local v77 = (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\171\35\166\75\206\78\16\150\36\170\68\232\65\29\135\35\177", "\113\226\77\197\42\188\32")]:IsAvailable() and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\19\24\247\180\40\24\245\161\51\25\250", "\213\90\118\148")]) or v49[LUAOBFUSACTOR_DECRYPT_STR_0("\120\43\184\83\94\79\39\181\90\108\87\39\179\88\64\94\32\160", "\45\59\78\212\54")];
	local v78 = false;
	local v79 = false;
	local v80 = false;
	local v81 = false;
	local v82 = false;
	local v83 = false;
	local v84 = false;
	v10:RegisterForEvent(function()
		local v108 = 0;
		while true do
			if ((v108 == 0) or (4200 == 2332)) then
				v53 = v13:GetEquipment();
				v54 = (v53[13] and v19(v53[13])) or v19(0);
				v108 = 1;
			end
			if ((v108 == 1) or (1278 >= 1316)) then
				v55 = (v53[14] and v19(v53[14])) or v19(0);
				v56 = false;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\32\122\162\178\163\28\146\213\33\99\170\187\171\11\131\196\47\117\171\170\168\9\136\212", "\144\112\54\227\235\230\78\205"));
	v10:RegisterForEvent(function()
		local v109 = 0;
		while true do
			if ((1082 == 1082) and (v109 == 0)) then
				v56 = false;
				v75 = 11111;
				v109 = 1;
			end
			if ((1328 <= 4878) and (v109 == 1)) then
				v76 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\131\4\46\197\245\105\140\26\42\219\245\117\140\13\33\221\242\119\150\12", "\59\211\72\111\156\176"));
	v10:RegisterForEvent(function()
		local v110 = 0;
		while true do
			if ((4087 >= 1355) and (v110 == 0)) then
				v77 = (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\103\137\224\44\92\137\226\57\71\136\237\25\79\139\230\35\90", "\77\46\231\131")]:IsAvailable() and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\147\90\181\65\168\90\183\84\179\91\184", "\32\218\52\214")]) or v49[LUAOBFUSACTOR_DECRYPT_STR_0("\109\18\61\173\226\164\76\91\66\54\61\161\246\190\72\95\64\3", "\58\46\119\81\200\145\208\37")];
				v56 = false;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\24\188\21\128\133\142\9\8\164\17\130\142\152\18", "\86\75\236\80\204\201\221"), LUAOBFUSACTOR_DECRYPT_STR_0("\94\100\86\183\208\174\86\126\68\181\219\167\94\126\94\171\193\191\83\99", "\235\18\33\23\229\158"));
	local v85, v86;
	local function v87(v111)
		local v112 = 0;
		local v113;
		while true do
			if ((0 == v112) or (590 > 4650)) then
				v113 = 0;
				if ((v111 == v49[LUAOBFUSACTOR_DECRYPT_STR_0("\103\168\192\175\88", "\219\48\218\161")]) or (3774 <= 3667)) then
					local v160 = 0;
					while true do
						if ((1270 < 2146) and (v160 == 0)) then
							v113 = 8;
							if ((4563 >= 56) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\211\120\112\77\232\90\242\227\116\111", "\128\132\17\28\41\187\47")]:IsAvailable()) then
								v113 = v113 + 2;
							end
							v160 = 1;
						end
						if ((v160 == 1) or (446 == 622)) then
							if ((2069 > 1009) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\50\61\19\54\82\7\38\14\63\123\14\32\3\41\73", "\61\97\82\102\90")]:IsAvailable() and v13:BuffUp(v49.EclipseSolar)) then
								v113 = v113 * 1.6;
							end
							break;
						end
					end
				elseif ((12 < 4208) and (v111 == v49[LUAOBFUSACTOR_DECRYPT_STR_0("\159\58\170\89\193\94\12\12", "\105\204\78\203\43\167\55\126")])) then
					local v172 = 0;
					while true do
						if ((v172 == 1) or (2990 <= 2980)) then
							if (v13:BuffUp(v49.WarriorofEluneBuff) or (2575 >= 4275)) then
								v113 = v113 * 1.4;
							end
							if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\4\84\202\37\143\80\74\63\94\249\38\146\83\77\35", "\62\87\59\191\73\224\54")]:IsAvailable() and v13:BuffUp(v49.EclipseLunar)) or (3626 <= 1306)) then
								local v181 = 0;
								local v182;
								while true do
									if ((1368 < 3780) and (0 == v181)) then
										v182 = 1 + (0.2 * v86);
										if ((v182 > 1.6) or (3169 == 2273)) then
											v182 = 1.6;
										end
										v181 = 1;
									end
									if ((2481 <= 3279) and (v181 == 1)) then
										v113 = v113 * v182;
										break;
									end
								end
							end
							break;
						end
						if ((v172 == 0) or (1063 <= 877)) then
							v113 = 10;
							if ((2314 == 2314) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\146\163\47\26\32\17\213\86\160\185", "\49\197\202\67\126\115\100\167")]:IsAvailable()) then
								v113 = v113 + 2;
							end
							v172 = 1;
						end
					end
				end
				v112 = 1;
			end
			if ((924 >= 477) and (v112 == 1)) then
				return v113;
			end
		end
	end
	local function v88(v114)
		local v115 = 0;
		local v116;
		while true do
			if ((1813 <= 3778) and (v115 == 0)) then
				v116 = v114:DebuffRemains(v49.SunfireDebuff);
				return v114:DebuffRefreshable(v49.SunfireDebuff) and (v116 < 2) and ((v114:TimeToDie() - v116) > 6);
			end
		end
	end
	local function v89(v117)
		return v117:DebuffRefreshable(v49.SunfireDebuff) and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\212\23\244\207\238\16\255", "\169\135\98\154")]:EnergizeAmount()));
	end
	local function v90(v118)
		local v119 = 0;
		local v120;
		while true do
			if ((4150 == 4150) and (v119 == 0)) then
				v120 = v118:DebuffRemains(v49.MoonfireDebuff);
				return v118:DebuffRefreshable(v49.MoonfireDebuff) and (v120 < 2) and ((v118:TimeToDie() - v120) > 6);
			end
		end
	end
	local function v91(v121)
		return v121:DebuffRefreshable(v49.MoonfireDebuff) and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\230\120\43\90\251\58\218\206", "\168\171\23\68\52\157\83")]:EnergizeAmount()));
	end
	local function v92(v122)
		local v123 = 0;
		local v124;
		while true do
			if ((432 <= 3007) and (0 == v123)) then
				v124 = v122:DebuffRemains(v49.StellarFlareDebuff);
				return v122:DebuffRefreshable(v49.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\199\101\240\161\41\44\149\210\125\244\191\32", "\231\148\17\149\205\69\77")]:EnergizeAmount())) and (v124 < 2) and ((v122:TimeToDie() - v124) > 8);
			end
		end
	end
	local function v93(v125)
		return v125:DebuffRefreshable(v49.StellarFlareDebuff) and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\179\179\194\247\91\254\146\129\203\250\69\250", "\159\224\199\167\155\55")]:EnergizeAmount()));
	end
	local function v94(v126)
		return v126:DebuffRefreshable(v49.SunfireDebuff) and ((v126:TimeToDie() - v16:DebuffRemains(v49.SunfireDebuff)) > (6 - (v86 / 2))) and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\196\230\50\212\254\225\57", "\178\151\147\92")]:EnergizeAmount()));
	end
	local function v95(v127)
		return v127:DebuffRefreshable(v49.MoonfireDebuff) and ((v127:TimeToDie() - v16:DebuffRemains(v49.MoonfireDebuff)) > 6) and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\161\242\67\60\20\69\104\137", "\26\236\157\44\82\114\44")]:EnergizeAmount()));
	end
	local function v96(v128)
		return v128:DebuffRefreshable(v49.StellarFlareDebuff) and (((v128:TimeToDie() - v128:DebuffRemains(v49.StellarFlareDebuff)) - v128:GetEnemiesInSplashRangeCount(8)) > (8 + v86));
	end
	local function v97(v129)
		return v129:DebuffRemains(v49.MoonfireDebuff) > ((v129:DebuffRemains(v49.SunfireDebuff) * 22) / 18);
	end
	local function v98()
		local v130 = 0;
		while true do
			if ((v130 == 0) or (408 > 2721)) then
				v78 = v13:BuffUp(v49.EclipseSolar) or v13:BuffUp(v49.EclipseLunar);
				v79 = v13:BuffUp(v49.EclipseSolar) and v13:BuffUp(v49.EclipseLunar);
				v130 = 1;
			end
			if ((v130 == 1) or (3418 < 2497)) then
				v80 = v13:BuffUp(v49.EclipseLunar) and v13:BuffDown(v49.EclipseSolar);
				v81 = v13:BuffUp(v49.EclipseSolar) and v13:BuffDown(v49.EclipseLunar);
				v130 = 2;
			end
			if ((1735 < 2169) and (v130 == 3)) then
				v84 = not v78 and (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\178\160\50\31\64", "\233\229\210\83\107\40\46")]:Count() > 0) and (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\242\86\51\196\3\200\80\55", "\101\161\34\82\182")]:Count() > 0);
				break;
			end
			if ((3890 >= 3262) and (v130 == 2)) then
				v82 = (not v78 and (((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\25\58\212\73\44\39\199\94", "\59\74\78\181")]:Count() == 0) and (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\18\195\91\78\187", "\211\69\177\58\58")]:Count() > 0)) or v13:IsCasting(v49.Wrath))) or v81;
				v83 = (not v78 and (((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\128\247\120\225\225", "\171\215\133\25\149\137")]:Count() == 0) and (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\210\220\51\232\233\57\238\71", "\34\129\168\82\154\143\80\156")]:Count() > 0)) or v13:IsCasting(v49.Starfire))) or v80;
				v130 = 3;
			end
		end
	end
	local function v99()
		local v131 = 0;
		while true do
			if ((v131 == 1) or (4356 >= 4649)) then
				v61 = v61 + v26(v54:IsReady() or (v54:CooldownRemains() > 0));
				v61 = v61 + (v26(v55:IsReady() or (v55:CooldownRemains() > 0)) * 2);
				v131 = 2;
			end
			if ((3904 == 3904) and (0 == v131)) then
				v57 = (not v49[LUAOBFUSACTOR_DECRYPT_STR_0("\203\8\85\251\200\246\139\47\228\44\85\247\220\236\143\43\230\25", "\78\136\109\57\158\187\130\226")]:IsAvailable() and not v49[LUAOBFUSACTOR_DECRYPT_STR_0("\23\49\250\240\44\49\248\229\55\48\247\197\63\51\252\255\42", "\145\94\95\153")]:IsAvailable()) or not v23();
				v61 = 0;
				v131 = 1;
			end
			if ((v131 == 2) or (2860 >= 3789)) then
				v56 = true;
				break;
			end
		end
	end
	local function v100()
		local v132 = 0;
		while true do
			if ((v132 == 1) or (1086 > 4449)) then
				if ((4981 > 546) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\6\144\125\168\57", "\220\81\226\28")]:IsCastable() and not v13:IsCasting(v49.Wrath)) then
					if (v25(v49.Wrath, not v16:IsSpellInRange(v49.Wrath), v73) or (2366 <= 8)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\4\199\131\239\226", "\167\115\181\226\155\138");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\213\48\230\72\115", "\166\130\66\135\60\27\17")]:IsCastable() and ((v13:IsCasting(v49.Wrath) and (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\115\88\207\97\56", "\80\36\42\174\21")]:Count() == 2)) or (v13:PrevGCD(1, v49.Wrath) and (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\121\2\54\110\70", "\26\46\112\87")]:Count() == 1)))) or (2590 == 2864)) then
					if (v25(v49.Wrath, not v16:IsSpellInRange(v49.Wrath), v73) or (2624 > 4149)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\174\49\170\96\183", "\212\217\67\203\20\223\223\37");
					end
				end
				v132 = 2;
			end
			if ((v132 == 0) or (2618 >= 4495)) then
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\208\204\6\222\97\177\201\197\17\226\71\187\249", "\215\157\173\116\181\46")]:IsCastable() and v48.GroupBuffMissing(v49.MarkOfTheWild)) or (2485 >= 3131)) then
					if (v24(v49.MarkOfTheWild, v43) or (2804 <= 2785)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\181\153\249\229\58\178\180\230\210\48\139\156\251\214\49\244\155\224\223\54\187\134\240\219\33", "\186\85\212\235\146");
					end
				end
				if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\239\142\25\240\50\231\86\228\142\4\243", "\56\162\225\118\158\89\142")]:IsCastable() or (4571 == 3415)) then
					if (v25(v49.MoonkinForm) or (4441 > 4787)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\10\207\161\41\209\82\58\198\160\48\213", "\184\60\101\160\207\66");
					end
				end
				v132 = 1;
			end
			if ((1920 == 1920) and (v132 == 2)) then
				if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\137\153\173\222\182\140\186\244\182\140\186\215", "\178\218\237\200")]:IsCastable() or (647 == 4477)) then
					if ((3819 == 3819) and v24(v49.StellarFlare, nil, nil, not v16:IsSpellInRange(v49.StellarFlare))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\161\227\220\186\180\244\239\176\185\231\194\179\245\246\194\179\182\233\221\180\180\242\144\224", "\176\214\213\134");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\199\185\183\198\174\95\75\241", "\57\148\205\214\180\200\54")]:IsCastable() and not v49[LUAOBFUSACTOR_DECRYPT_STR_0("\33\233\48\56\122\19\239\19\56\119\0\248", "\22\114\157\85\84")]:IsAvailable()) or (1466 > 4360)) then
					if (v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire)) or (14 > 994)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\223\18\214\91\255\186\193\139\3\214\88\245\167\201\201\18\208\29\174", "\200\164\171\115\164\61\150");
					end
				end
				break;
			end
		end
	end
	local function v101()
		local v133 = 0;
		while true do
			if ((401 <= 734) and (v133 == 1)) then
				if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\33\53\54\122\181\102\23", "\20\114\64\88\28\220")]:IsCastable() or (2167 >= 3426)) then
					if ((764 < 3285) and v48.CastCycle(v49.Sunfire, v85, v97, not v16:IsSpellInRange(v49.Sunfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\20\220\178\241\194\184\113\7\211\184\244\196\181\35\20\146\226", "\221\81\97\178\212\152\176");
					end
				end
				if ((2499 == 2499) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\224\232\18\245\28\196\245\24", "\122\173\135\125\155")]:IsCastable()) then
					if (v25(v49.Moonfire, not v16:IsSpellInRange(v49.Moonfire)) or (692 >= 4933)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\137\206\15\183\57\56\218\129\129\6\184\51\61\220\140\211\21\249\103", "\168\228\161\96\217\95\81");
					end
				end
				break;
			end
			if ((v133 == 0) or (3154 <= 2260)) then
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\141\224\2\87\133\191\248\15", "\227\222\148\99\37")]:IsReady() and v62) or (2637 > 3149)) then
					if (v25(v49.Starfall, not v16:IsInRange(45)) or (3992 < 2407)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\32\70\83\228\255\50\94\94\182\255\50\94\94\226\241\33\71\18\164", "\153\83\50\50\150");
					end
				end
				if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\110\98\114\14\96\190\95\90\115", "\45\61\22\19\124\19\203")]:IsReady() or (2902 > 4859)) then
					if ((1679 < 4359) and v25(v49.Starsurge, not v16:IsSpellInRange(v49.Starsurge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\210\6\12\231\17\101\171\198\23\77\243\3\124\181\213\26\31\224\66\36", "\217\161\114\109\149\98\16");
					end
				end
				v133 = 1;
			end
		end
	end
	local function v102()
		local v134 = 0;
		local v135;
		local v136;
		local v137;
		while true do
			if ((1913 < 4670) and (v134 == 7)) then
				v137 = v101();
				if (v137 or (2846 < 879)) then
					return v137;
				end
				if ((4588 == 4588) and v10.CastAnnotated(v49.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\235\246\181\247\0\205", "\138\166\185\227\190\78"))) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\251\123\202\59\18\16\45\139\112\208\50\18\55\22\139\121\202\33\87\46\28\197\96\133\54\92\39\89\197\123\133\49\83\47\21\223\124\215\34", "\121\171\20\165\87\50\67");
				end
				break;
			end
			if ((6 == v134) or (347 == 2065)) then
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\31\179\185\37\167\54\184\206", "\160\89\198\213\73\234\89\215")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\110\100\184\242\232\71\126\186", "\165\40\17\212\158")]:EnergizeAmount())) and ((v13:BuffRemains(v49.EclipseLunar) > v49[LUAOBFUSACTOR_DECRYPT_STR_0("\195\204\4\63\11\234\214\6", "\70\133\185\104\83")]:ExecuteTime()) or (v13:BuffRemains(v49.EclipseSolar) > v49[LUAOBFUSACTOR_DECRYPT_STR_0("\34\80\72\38\228\11\74\74", "\169\100\37\36\74")]:ExecuteTime())) and (v71 or ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\40\134\174\86\45\136\173\94", "\48\96\231\194")]:ChargesFractional() > 2.5) and (v70 <= 520) and (v77:CooldownRemains() > 10)) or (v76 < 10))) or (1311 > 2697)) then
					if (v24(v49.FullMoon, nil, nil, not v16:IsSpellInRange(v49.FullMoon)) or (2717 > 3795)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\206\79\2\33\38\213\160\140\198\26\29\57\89\141\253", "\227\168\58\110\77\121\184\207");
					end
				end
				v136 = v13:BuffUp(v49.StarweaversWeft) or (v13:AstralPowerDeficit() < (v64 + v87(v49.Wrath) + ((v87(v49.Starfire) + v64) * (v26(v13:BuffRemains(v49.EclipseSolar) < (v13:GCD() * 3)))))) or (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\90\47\171\82\176\215\82\170\118\49\170\78\184\212\127", "\197\27\92\223\32\209\187\17")]:IsAvailable() and (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\34\76\215\233\2\83\224\244\14\82\214\245\10\80\205", "\155\99\63\163")]:CooldownRemains() < 3)) or (v76 < 5);
				if ((v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < 2) and v136) or (1081 < 391)) then
					if (v25(v52.CancelStarlord, false, LUAOBFUSACTOR_DECRYPT_STR_0("\161\240\143\174\156\168", "\228\226\177\193\237\217")) or (121 > 3438)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\177\45\229\49\188\28\228\33\182\37\166\39\164\34\244\56\191\49\226\116\163\55\166\97\227", "\134\84\208\67");
					end
				end
				if ((71 < 1949) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\32\184\135\78\0\185\148\91\22", "\60\115\204\230")]:IsReady() and v136) then
					if ((4254 == 4254) and v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\244\46\234\98\244\47\249\119\226\122\248\100\167\111\191", "\16\135\90\139");
					end
				end
				if ((3196 >= 2550) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\99\102\7\39\70", "\24\52\20\102\83\46\52")]:IsCastable() and not v13:IsMoving()) then
					if ((2456 < 4176) and v24(v49.Wrath, nil, nil, not v16:IsSpellInRange(v49.Wrath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\61\32\48\7\132\60\53\100\89\148", "\111\164\79\65\68");
					end
				end
				v134 = 7;
			end
			if ((v134 == 0) or (1150 == 3452)) then
				if ((1875 < 2258) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\232\196\32\90\38\69\222", "\55\187\177\78\60\79")]:IsCastable()) then
					if ((1173 > 41) and v48.CastCycle(v49.Sunfire, v85, v88, not v16:IsSpellInRange(v49.Sunfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\219\81\237\79\221\133\109\221\75\171\20", "\224\77\174\63\139\38\175");
					end
				end
				v65 = v30 and (v77:CooldownRemains() < 5) and not v71 and (((v16:TimeToDie() > 15) and (v70 < 480)) or (v76 < (25 + (10 * v26(v49[LUAOBFUSACTOR_DECRYPT_STR_0("\173\79\91\47\150\79\89\58\141\78\86", "\78\228\33\56")]:IsAvailable())))));
				if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\227\113\189\13\131\199\108\183", "\229\174\30\210\99")]:IsCastable() or (56 >= 3208)) then
					if ((4313 > 3373) and v48.CastCycle(v49.Moonfire, v85, v90, not v16:IsSpellInRange(v49.Moonfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\226\137\95\235\52\43\30\173\149\69\173\107", "\89\123\141\230\49\141\93");
					end
				end
				if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\192\101\243\0\28\75\225\87\250\13\2\79", "\42\147\17\150\108\112")]:IsCastable() or (4493 == 2225)) then
					if ((3104 >= 3092) and v48.CastCycle(v49.StellarFlare, v85, v92, not v16:IsSpellInRange(v49.StellarFlare))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\178\40\115\235\233\29\153\43\115\230\250\10\230\62\107\167\185\95", "\136\111\198\77\31\135");
					end
				end
				if ((3548 > 3098) and v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < 2) and (((v70 >= 550) and not v71 and v13:BuffUp(v49.StarweaversWarp)) or ((v70 >= 560) and v13:BuffUp(v49.StarweaversWeft)))) then
					if (v10.CastAnnotated(v52.CancelStarlord, false, LUAOBFUSACTOR_DECRYPT_STR_0("\33\40\137\117\152\200", "\201\98\105\199\54\221\132\119")) or (3252 == 503)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\13\141\34\7\57\147\187\25\133\39\66\38\184\184\30\143\46\16\49\236\170\24\195\112\83", "\204\217\108\227\65\98\85");
					end
				end
				v134 = 1;
			end
			if ((4733 > 2066) and (v134 == 3)) then
				v69 = (v72 > 4) or (((v77:CooldownRemains() > 30) or v57) and ((v13:BuffRemains(v49.EclipseLunar) > 4) or (v13:BuffRemains(v49.EclipseSolar) > 4)));
				if ((3549 >= 916) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\179\232\131\100\35\253\164\17\133", "\118\224\156\226\22\80\136\214")]:IsReady() and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\97\225\87\150\77\229\92\180\74\235\106\144\75\252\80\148\81", "\224\34\142\57")]:IsAvailable() and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\253\168\203\203\124\250\88\58\214\162\246\205\122\227\84\26\205", "\110\190\199\165\189\19\145\61")]:IsCastable() and v69) then
					if (v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge)) or (2189 <= 245)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\255\118\250\152\210\200\236\114\168\152\211\154\185\47", "\167\186\139\23\136\235");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\57\186\134\27\21\190\141\57\18\176\187\29\19\167\129\25\9", "\109\122\213\232")]:IsCastable() and v23() and v69) or (1389 > 3925)) then
					if ((4169 >= 3081) and v24(v49.ConvokeTheSpirits, nil, not v16:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\248\172\38\225\252\167\15\250\255\167\15\253\231\171\34\231\227\177\112\253\227\226\99\190", "\80\142\151\194");
					end
				end
				if ((349 <= 894) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\34\213\99\94\2\202\84\67\14\203\98\66\10\201\121", "\44\99\166\23")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\93\228\61\36\50\168\95\248\36\59\38\170\117\248\39", "\196\28\151\73\86\83")]:EnergizeAmount()))) then
					if ((731 <= 2978) and v24(v49.AstralCommunion)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\242\16\61\2\131\84\39\117\252\14\36\5\140\81\23\120\179\16\61\80\209\10", "\22\147\99\73\112\226\56\120");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\158\122\240\246\136\151\115\204\244\153\173\103\231", "\237\216\21\130\149")]:IsCastable() and v23() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\164\65\77\92\181\230\88\172\79\75\74\162\204", "\62\226\46\63\63\208\169")]:EnergizeAmount()))) or (892 > 3892)) then
					if (v24(v49.ForceOfNature, nil, not v16:IsInRange(45)) or (4466 == 900)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\22\71\128\26\50\32\88\218\23\84\151\10\31\42\30\246\13\21\208\75", "\62\133\121\53\227\127\109\79");
					end
				end
				v134 = 4;
			end
			if ((v134 == 5) or (2084 >= 2888)) then
				if ((479 < 1863) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\23\3\162\231\56\226\210", "\183\68\118\204\129\81\144")]:IsCastable()) then
					if (v48.CastCycle(v49.Sunfire, v85, v89, not v16:IsSpellInRange(v49.Sunfire)) or (2428 >= 4038)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\29\184\126\226\2\144\11\237\99\240\75\214\92", "\226\110\205\16\132\107");
					end
				end
				if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\198\204\239\215\71\226\209\229", "\33\139\163\128\185")]:IsCastable() or (2878 > 2897)) then
					if (v48.CastCycle(v49.Moonfire, v85, v91, not v16:IsSpellInRange(v49.Moonfire)) or (2469 > 3676)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\87\11\208\81\81\22\219\23\75\16\158\3\12", "\190\55\56\100");
					end
				end
				if ((233 < 487) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\101\187\57\18\31\226\225\112\163\61\12\22", "\147\54\207\92\126\115\131")]:IsCastable()) then
					if ((2473 >= 201) and v48.CastCycle(v49.StellarFlare, v85, v93, not v16:IsSpellInRange(v49.StellarFlare))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\30\37\48\113\1\127\31\14\51\113\12\108\8\113\38\105\77\42\91", "\30\109\81\85\29\109");
					end
				end
				if ((4120 >= 133) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\209\116\67\155\57\209\242", "\156\159\17\52\214\86\190")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\128\234\170\145\161\224\179", "\220\206\143\221")]:EnergizeAmount())) and (v71 or ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\168\120\58\58\215\195\220", "\178\230\29\77\119\184\172")]:ChargesFractional() > 2.5) and (v70 <= 520) and (v77:CooldownRemains() > 10)) or (v76 < 10))) then
					if ((3080 >= 1986) and v24(v49.NewMoon, nil, nil, not v16:IsSpellInRange(v49.NewMoon))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\187\29\36\122\247\250\176\74\8\99\184\161\230", "\152\149\222\106\123\23");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\245\39\250\69\152\210\41\248", "\213\189\70\150\35")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\103\84\120\14\98\90\123\6", "\104\47\53\20")]:EnergizeAmount())) and ((v13:BuffRemains(v49.EclipseLunar) > v49[LUAOBFUSACTOR_DECRYPT_STR_0("\139\77\141\26\145\0\172\66", "\111\195\44\225\124\220")]:ExecuteTime()) or (v13:BuffRemains(v49.EclipseSolar) > v49[LUAOBFUSACTOR_DECRYPT_STR_0("\240\71\12\117\134\164\215\72", "\203\184\38\96\19\203")]:ExecuteTime())) and (v71 or ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\17\114\117\71\227\54\124\119", "\174\89\19\25\33")]:ChargesFractional() > 2.5) and (v70 <= 520) and (v77:CooldownRemains() > 10)) or (v76 < 10))) or (1439 > 3538)) then
					if (v24(v49.HalfMoon, nil, nil, not v16:IsSpellInRange(v49.HalfMoon)) or (419 < 7)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\19\94\72\200\138\4\32\28\18\93\227\199\94\127", "\107\79\114\50\46\151\231");
					end
				end
				v134 = 6;
			end
			if ((2820 == 2820) and (v134 == 1)) then
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\109\215\244\247\42\193\82\207", "\160\62\163\149\133\76")]:IsReady() and (v70 >= 550) and not v71 and v13:BuffUp(v49.StarweaversWarp)) or (4362 <= 3527)) then
					if ((2613 <= 2680) and v24(v49.Starfall, nil, not v16:IsInRange(45))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\180\12\61\197\215\172\1\111\208\194\224\92\125", "\163\182\192\109\79");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\7\50\1\210\230\33\52\7\197", "\149\84\70\96\160")]:IsReady() and (v70 >= 560) and v13:BuffUp(v49.StarweaversWeft)) or (1482 >= 4288)) then
					if (v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge)) or (2462 > 4426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\18\12\255\43\19\31\234\61\70\30\249\120\87\94", "\141\88\102\109");
					end
				end
				if ((4774 == 4774) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\128\71\203\98\28\52\71\196", "\161\211\51\170\16\122\93\53")]:IsReady() and v13:BuffUp(v49.DreamstateBuff) and v65 and v80) then
					if ((566 <= 960) and v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\232\186\179\58\253\167\160\45\187\189\166\104\170\250", "\72\155\206\210");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\113\104\85\26\59", "\83\38\26\52\110")]:IsReady() and v13:BuffUp(v49.DreamstateBuff) and v65 and v13:BuffUp(v49.EclipseSolar)) or (2910 <= 1930)) then
					if (v24(v49.Wrath, nil, nil, not v16:IsSpellInRange(v49.Wrath)) or (19 > 452)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\5\38\82\80\87\52\82\24\70\114", "\38\56\119\71");
					end
				end
				if (v30 or (907 > 3152)) then
					local v161 = 0;
					while true do
						if ((v161 == 0) or (2505 > 4470)) then
							if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\208\234\84\211\54\66\250\238\84\247\41\95\244\225\85\211\43\66", "\54\147\143\56\182\69")]:IsCastable() and v65) or (3711 > 4062)) then
								if ((420 == 420) and v25(v49.CelestialAlignment)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\213\132\243\76\204\194\136\254\69\224\215\141\246\78\209\219\132\241\93\159\197\149\191\24\137", "\191\182\225\159\41");
								end
							end
							if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\2\28\43\84\153\137\195\63\27\39\91", "\162\75\114\72\53\235\231")]:IsCastable() and v65) or (33 >= 3494)) then
								if (v25(v49.Incarnation) or (1267 == 4744)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\133\50\71\227\65\12\141\40\77\237\93\66\159\40\4\179\11", "\98\236\92\36\130\51");
								end
							end
							break;
						end
					end
				end
				v134 = 2;
			end
			if ((2428 < 3778) and (v134 == 4)) then
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\54\1\32\236\249\168\135\28\1\60\240", "\194\112\116\82\149\182\206")]:IsCastable() and (((v16:TimeToDie() > 2) and ((v72 > 3) or ((v77:CooldownRemains() > 30) and (v70 <= 280)) or ((v70 >= 560) and (v13:AstralPowerP() > 50)))) or (v76 < 10))) or (2946 <= 1596)) then
					if ((4433 > 3127) and v24(v49.FuryOfElune, nil, not v16:IsSpellInRange(v49.FuryOfElune))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\189\94\1\255\237\8\6\173\64\13\206\231\78\42\188\12\75\150", "\110\89\200\44\120\160\130");
					end
				end
				if ((4300 >= 2733) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\152\215\74\84\69\75\55\65", "\45\203\163\43\38\35\42\91")]:IsReady() and (v13:BuffUp(v49.StarweaversWarp))) then
					if ((4829 == 4829) and v24(v49.Starfall, nil, not v16:IsInRange(45))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\193\145\221\49\129\168\88\222\197\207\55\199\250\12", "\52\178\229\188\67\231\201");
					end
				end
				v135 = (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\18\85\81\22\251\83\49\37", "\67\65\33\48\100\151\60")]:IsAvailable() and (v13:BuffStack(v49.StarlordBuff) < 3)) or (((v13:BuffStack(v49.BOATArcaneBuff) + v13:BuffStack(v49.BOATNatureBuff)) > 2) and (v13:BuffRemains(v49.StarlordBuff) > 4));
				if ((1683 <= 4726) and v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < 2) and v135) then
					if ((4835 >= 3669) and v10.CastAnnotated(v52.CancelStarlord, false, LUAOBFUSACTOR_DECRYPT_STR_0("\252\198\128\251\214\243", "\147\191\135\206\184"))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\41\168\194\221\95\141\134\61\160\199\152\64\166\133\58\170\206\202\87\242\151\60\230\146\129", "\210\228\72\198\161\184\51");
					end
				end
				if ((2851 > 1859) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\5\93\242\2\96\219\36\78\246", "\174\86\41\147\112\19")]:IsReady() and v135) then
					if ((3848 > 2323) and v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\72\20\140\25\54\26\3\172\94\64\158\31\101\91\65", "\203\59\96\237\107\69\111\113");
					end
				end
				v134 = 5;
			end
			if ((2836 > 469) and (2 == v134)) then
				v60 = ((v70 < 520) and (v77:CooldownRemains() > 5) and (v86 < 3)) or v13:HasTier(31, 2);
				v67 = v84 or (v60 and v13:BuffUp(v49.EclipseSolar) and (v13:BuffRemains(v49.EclipseSolar) < v49[LUAOBFUSACTOR_DECRYPT_STR_0("\151\13\13\168\67\161\167\53", "\80\196\121\108\218\37\200\213")]:CastTime())) or (not v60 and v13:BuffUp(v49.EclipseLunar) and (v13:BuffRemains(v49.EclipseLunar) < v49[LUAOBFUSACTOR_DECRYPT_STR_0("\55\97\3\107\67", "\234\96\19\98\31\43\110")]:CastTime()));
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\49\30\64\213\165\125\153\9\25\119\203\185\124\142", "\235\102\127\50\167\204\18")]:IsCastable() and v60 and (v67 or (v13:BuffRemains(v49.EclipseSolar) < 7))) or (2096 <= 540)) then
					if (v24(v49.WarriorofElune) or (3183 < 2645)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\71\160\231\49\77\33\66\158\250\37\123\43\92\180\251\38\4\61\68\225\167\115", "\78\48\193\149\67\36");
					end
				end
				if ((3230 <= 3760) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\3\10\129\10\71\57\12\133", "\33\80\126\224\120")]:IsCastable() and v67 and (v60 or v13:BuffUp(v49.EclipseSolar))) then
					if ((3828 == 3828) and v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\188\2\214\90\229\186\6\132\79\248\232\81\144", "\60\140\200\99\164");
					end
				end
				if ((554 == 554) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\176\230\5\50\170", "\194\231\148\100\70")]:IsCastable() and v67) then
					if (v24(v49.Wrath, nil, nil, not v16:IsSpellInRange(v49.Wrath)) or (2563 == 172)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\94\192\183\254\136\85\88\129\241\160", "\168\38\44\161\195\150");
					end
				end
				v134 = 3;
			end
		end
	end
	local function v103()
		local v138 = 0;
		local v139;
		local v140;
		local v141;
		local v142;
		local v143;
		local v144;
		local v145;
		while true do
			if ((3889 >= 131) and (v138 == 2)) then
				if (v30 or (492 == 4578)) then
					local v162 = 0;
					while true do
						if ((v162 == 0) or (4112 < 1816)) then
							if ((4525 >= 1223) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\43\92\5\90\27\77\0\94\4\120\5\86\15\87\4\90\6\77", "\63\104\57\105")]:IsCastable() and v66) then
								if ((1090 <= 4827) and v25(v49.CelestialAlignment)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\8\130\168\65\24\147\173\69\7\184\165\72\2\128\170\73\14\137\176\4\10\136\161\4\90\215", "\36\107\231\196");
								end
							end
							if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\116\187\161\134\79\187\163\147\84\186\172", "\231\61\213\194")]:IsCastable() and v66) or (239 > 1345)) then
								if (v25(v49.Incarnation) or (3710 >= 3738)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\10\168\49\118\26\185\52\114\5\146\60\127\0\170\51\126\12\163\41\51\8\162\56\51\88\255", "\19\105\205\93");
								end
							end
							break;
						end
					end
				end
				if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\158\9\204\147\54\166\26\209\135\26\165\29\208\132", "\95\201\104\190\225")]:IsCastable() or (3838 < 2061)) then
					if (v25(v49.WarriorofElune) or (690 > 1172)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\184\202\211\220\166\196\211\241\160\205\254\203\163\222\207\203\239\202\206\203\239\154\149", "\174\207\171\161");
					end
				end
				v141 = v86 < 3;
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\222\234\12\225\254\222\255\251", "\183\141\158\109\147\152")]:IsCastable() and v141 and (v84 or (v13:BuffRemains(v49.EclipseSolar) < v49[LUAOBFUSACTOR_DECRYPT_STR_0("\31\29\231\30\42\0\244\9", "\108\76\105\134")]:CastTime()))) or (1592 > 2599)) then
					if ((3574 <= 4397) and v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\209\176\243\200\226\215\180\161\207\228\192\241\176\153", "\174\139\165\209\129");
					end
				end
				if ((3135 > 1330) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\148\161\227\213\206", "\24\195\211\130\161\166\99\16")]:IsCastable() and not v141 and (v84 or (v13:BuffRemains(v49.EclipseLunar) < v49[LUAOBFUSACTOR_DECRYPT_STR_0("\113\17\232\56\91", "\118\38\99\137\76\51")]:CastTime()))) then
					if (v24(v49.Wrath, nil, nil, not v16:IsSpellInRange(v49.Wrath)) or (3900 <= 3641)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\52\4\6\1\96\252\41\0\82\88\120", "\64\157\70\101\114\105");
					end
				end
				v138 = 3;
			end
			if ((1724 == 1724) and (v138 == 0)) then
				v139 = v13:IsInParty() and not v13:IsInRaid();
				if ((455 <= 1282) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\235\55\182\56\191\11\212\61", "\98\166\88\217\86\217")]:IsCastable() and v139) then
					if ((4606 < 4876) and v48.CastCycle(v49.Moonfire, v85, v95, not v16:IsSpellInRange(v49.Moonfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\249\118\15\128\213\228\243\57\0\137\217\182\164", "\188\150\150\25\97\230");
					end
				end
				v66 = v23() and (v77:CooldownRemains() < 5) and not v71 and (((v16:TimeToDie() > 10) and (v70 < 500)) or (v76 < (25 + (10 * v26(v49[LUAOBFUSACTOR_DECRYPT_STR_0("\243\135\92\3\30\227\219\157\86\13\2", "\141\186\233\63\98\108")]:IsAvailable())))));
				if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\194\255\34\176\44\227\239", "\69\145\138\76\214")]:IsCastable() or (1442 > 2640)) then
					if ((136 < 3668) and v48.CastCycle(v49.Sunfire, v85, v94, not v16:IsSpellInRange(v49.Sunfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\99\218\135\143\182\4\117\143\136\134\186\86\36", "\118\16\175\233\233\223");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\166\139\58\181\232\130\111\142", "\29\235\228\85\219\142\235")]:IsCastable() and not v139) or (1784 > 4781)) then
					if ((4585 > 3298) and v48.CastCycle(v49.Moonfire, v85, v95, not v16:IsSpellInRange(v49.Moonfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\219\181\211\113\71\53\87\125\213\181\216\55\24", "\50\93\180\218\189\23\46\71");
					end
				end
				v138 = 1;
			end
			if ((5 == v138) or (1664 > 1698)) then
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\3\233\60\247\7\211\140", "\226\77\140\75\186\104\188")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\151\203\199\18\64\182\192", "\47\217\174\176\95")]:EnergizeAmount()))) or (3427 < 2849)) then
					if ((3616 <= 4429) and v24(v49.NewMoon, nil, nil, not v16:IsSpellInRange(v49.NewMoon))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\216\97\61\191\91\119\40\248\220\121\7\242\7\32", "\70\216\189\22\98\210\52\24");
					end
				end
				if ((3988 >= 66) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\242\222\175\129\254\213\208\173", "\179\186\191\195\231")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\209\62\20\226\212\48\23\234", "\132\153\95\120")]:EnergizeAmount())) and ((v13:BuffRemains(v49.EclipseLunar) > v49[LUAOBFUSACTOR_DECRYPT_STR_0("\151\167\2\33\218\213\175\191", "\192\209\210\110\77\151\186")]:ExecuteTime()) or (v13:BuffRemains(v49.EclipseSolar) > v49[LUAOBFUSACTOR_DECRYPT_STR_0("\198\22\46\229\210\203\239\13", "\164\128\99\66\137\159")]:ExecuteTime()))) then
					if (v24(v49.HalfMoon, nil, nil, not v16:IsSpellInRange(v49.HalfMoon)) or (862 > 4644)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\136\229\184\63\132\230\177\14\201\232\177\5\201\189\238", "\222\96\233\137");
					end
				end
				if ((1221 == 1221) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\159\188\181\28\141\220\246\151\178\179\10\154\246", "\144\217\211\199\127\232\147")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\222\32\44\43\208\106\4\106\249\59\43\58\208", "\36\152\79\94\72\181\37\98")]:EnergizeAmount()))) then
					if (v24(v49.ForceOfNature, nil, not v16:IsInRange(45)) or (45 > 1271)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\215\85\60\210\231\72\57\232\214\70\43\194\202\66\127\214\215\66\127\131\138", "\95\183\184\39");
					end
				end
				if ((3877 > 1530) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\230\52\71\149\16\178\58", "\98\213\95\135\70\52\224")]:IsReady() and v13:BuffUp(v49.StarweaversWeft) and (v86 < 17)) then
					if (v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge)) or (4798 == 1255)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\183\200\101\71\235\177\206\114\20\255\172\204\55\0\170", "\52\158\195\169\23");
					end
				end
				v143 = 0;
				v138 = 6;
			end
			if ((v138 == 7) or (2541 > 2860)) then
				v145 = v101();
				if (v145 or (2902 > 3629)) then
					return v145;
				end
				if ((427 < 3468) and v10.CastAnnotated(v49.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\126\36\66\90\20\116", "\90\51\107\20\19"))) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\189\255\138\227\125\172\255\160\175\57\152\245\197\251\50\205\253\138\249\56\128\245\139\251\125\140\254\129\175\51\130\176\131\238\49\129\228\141\253\40", "\93\237\144\229\143");
				end
				break;
			end
			if ((4190 >= 2804) and (v138 == 4)) then
				if ((2086 == 2086) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\12\61\173\79\91\37\39\175", "\22\74\72\193\35")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\10\108\232\84\1\118\235\86", "\56\76\25\132")]:EnergizeAmount())) and ((v13:BuffRemains(v49.EclipseLunar) > v49[LUAOBFUSACTOR_DECRYPT_STR_0("\120\212\167\42\226\81\206\165", "\175\62\161\203\70")]:ExecuteTime()) or (v13:BuffRemains(v49.EclipseSolar) > v49[LUAOBFUSACTOR_DECRYPT_STR_0("\26\200\207\31\24\51\210\205", "\85\92\189\163\115")]:ExecuteTime())) and (v71 or ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\1\173\60\62\4\163\63\54", "\88\73\204\80")]:ChargesFractional() > 2.5) and (v70 <= 520) and (v77:CooldownRemains() > 10)) or (v76 < 10))) then
					if ((4148 > 2733) and v24(v49.FullMoon, nil, nil, not v16:IsSpellInRange(v49.FullMoon))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\40\150\28\74\22\215\33\140\30\6\40\213\43\195\66\16", "\186\78\227\112\38\73");
					end
				end
				if ((3054 >= 1605) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\207\67\252\71\64\111\238\80\248", "\26\156\55\157\53\51")]:IsReady() and v13:BuffUp(v49.StarweaversWeft) and (v86 < 3)) then
					if ((1044 < 1519) and v24(v49.Starsurge, nil, nil, not v16:IsSpellInRange(v49.Starsurge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\159\204\23\203\171\69\158\223\19\153\185\95\137\152\69\137", "\48\236\184\118\185\216");
					end
				end
				if ((1707 <= 4200) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\214\169\82\60\195\53\247\155\91\49\221\49", "\84\133\221\55\80\175")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\142\243\33\170\203\93\175\193\40\167\213\89", "\60\221\135\68\198\167")]:EnergizeAmount())) and (v86 < ((11 - v49[LUAOBFUSACTOR_DECRYPT_STR_0("\219\176\250\145\67\213\199\179\236\134\76\202\231\169\225", "\185\142\221\152\227\34")]:TalentRank()) - v49[LUAOBFUSACTOR_DECRYPT_STR_0("\121\214\67\232\66\63\196\85\202\91\254\70\33", "\151\56\165\55\154\35\83")]:TalentRank()))) then
					if ((580 == 580) and v48.CastCycle(v49.StellarFlare, v85, v96, not v16:IsSpellInRange(v49.StellarFlare))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\179\87\0\226\172\66\23\209\166\79\4\252\165\3\4\225\165\3\86\188", "\142\192\35\101");
					end
				end
				if ((601 <= 999) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\247\102\61\177\230\128\143\25\219\120\60\173\238\131\162", "\118\182\21\73\195\135\236\204")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\41\47\14\82\5\1\222\7\49\23\85\10\4\242\6", "\157\104\92\122\32\100\109")]:EnergizeAmount()))) then
					if ((3970 == 3970) and v24(v49.ForceOfNature)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\162\181\219\216\60\43\178\168\172\171\194\223\51\46\130\165\227\167\192\207\125\116\217", "\203\195\198\175\170\93\71\237");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\13\68\48\195\94\26\249\26\67\59\230\65\24\238\39\95\45", "\156\78\43\94\181\49\113")]:IsCastable() and v23() and (v13:AstralPowerP() < 50) and (v86 < (3 + v26(v49[LUAOBFUSACTOR_DECRYPT_STR_0("\87\228\209\173\14\80\94\103\225\192\162\5\64\124", "\25\18\136\164\195\107\35")]:IsAvailable()))) and ((v13:BuffRemains(v49.EclipseLunar) > 4) or (v13:BuffRemains(v49.EclipseSolar) > 4))) or (98 == 208)) then
					if ((2006 <= 3914) and v24(v49.ConvokeTheSpirits, nil, not v16:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\34\167\89\125\183\196\135\252\37\172\112\97\172\200\170\225\57\186\15\115\179\196\248\187\123", "\216\136\77\201\47\18\220\161");
					end
				end
				v138 = 5;
			end
			if ((v138 == 6) or (3101 <= 2971)) then
				v144 = 0;
				if (v13:BuffUp(v49.EclipseLunar) or (2073 <= 671)) then
					local v163 = 0;
					local v164;
					local v165;
					local v166;
					while true do
						if ((3305 > 95) and (v163 == 0)) then
							v164 = v13:BuffInfo(v49.EclipseLunar, nil, true);
							v165 = v164[LUAOBFUSACTOR_DECRYPT_STR_0("\106\179\59\122\146\38", "\235\26\220\82\20\230\85\27")][1];
							v163 = 1;
						end
						if ((2727 == 2727) and (1 == v163)) then
							v166 = (v165 - 15) / 2;
							break;
						end
					end
				end
				if (v13:BuffUp(v49.EclipseSolar) or (2970 >= 4072)) then
					local v167 = 0;
					local v168;
					local v169;
					local v170;
					while true do
						if ((3881 > 814) and (v167 == 1)) then
							v170 = (v169 - 15) / 2;
							break;
						end
						if ((v167 == 0) or (4932 < 4868)) then
							v168 = v13:BuffInfo(v49.EclipseSolar, nil, true);
							v169 = v168[LUAOBFUSACTOR_DECRYPT_STR_0("\152\174\224\204\96\155", "\20\232\193\137\162")][1];
							v167 = 1;
						end
					end
				end
				if ((3667 <= 4802) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\17\203\196\180\225\133\5\116", "\17\66\191\165\198\135\236\119")]:IsCastable() and not v13:IsMoving() and (((v86 > (3 - (v26(v13:BuffUp(v49.DreamstateBuff) or (v143 > v144))))) and v13:BuffUp(v49.EclipseLunar)) or v80)) then
					if ((1260 >= 858) and v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\187\175\1\249\225\254\212\79\174\161\22\191\188\186", "\177\111\207\206\115\159\136\140");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\50\155\17\0\220", "\63\101\233\112\116\180\47")]:IsCastable() and not v13:IsMoving()) or (3911 == 4700)) then
					if ((3000 < 4194) and v25(v49.Wrath, not v16:IsSpellInRange(v49.Wrath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\212\41\236\6\240\118\194\52\232\82\172\110", "\86\163\91\141\114\152");
					end
				end
				v138 = 7;
			end
			if ((651 < 4442) and (v138 == 3)) then
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\119\161\171\231\61\85\187\175\241\31\79\165", "\112\32\200\199\131")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + 20)) and (not v49[LUAOBFUSACTOR_DECRYPT_STR_0("\27\81\82\177\205\172\22\59\89\80\177\196\163\54", "\66\76\48\60\216\163\203")]:IsAvailable() or ((v16:DebuffRemains(v49.FungalGrowthDebuff) < 2) and (v16:TimeToDie() > 7) and not v13:PrevGCDP(1, v49.WildMushroom)))) or (195 >= 1804)) then
					if (v24(v49.WildMushroom, nil, not v16:IsSpellInRange(v49.WildMushroom)) or (1382 > 2216)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\143\117\247\96\195\49\169\142\107\252\80\195\100\187\137\124\179\13\158", "\68\218\230\25\147\63\174");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\139\63\65\85\153\171\15\95\89\184\168", "\214\205\74\51\44")]:IsCastable() and (((v16:TimeToDie() > 2) and ((v72 > 3) or ((v77:CooldownRemains() > 30) and (v70 <= 280)) or ((v70 >= 560) and (v13:AstralPowerP() > 50)))) or (v76 < 10))) or (2861 == 2459)) then
					if ((1903 < 4021) and v24(v49.FuryOfElune, nil, not v16:IsSpellInRange(v49.FuryOfElune))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\252\89\240\229\72\245\74\221\249\123\239\66\231\188\118\245\73\162\174\37", "\23\154\44\130\156");
					end
				end
				v142 = (v16:TimeToDie() > 4) and (v13:BuffUp(v49.StarweaversWarp) or (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\34\178\172\188\58\28\3\162", "\115\113\198\205\206\86")]:IsAvailable() and (v13:BuffStack(v49.StarlordBuff) < 3)));
				if ((v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < 2) and v142) or (2270 >= 4130)) then
					if ((2593 <= 3958) and v10.CastAnnotated(v52.CancelStarlord, false, LUAOBFUSACTOR_DECRYPT_STR_0("\167\118\208\121\161\123", "\58\228\55\158"))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\136\222\45\57\161\10\182\156\214\40\124\190\33\181\155\220\33\46\169\117\181\134\213\110\110\254", "\85\212\233\176\78\92\205");
					end
				end
				if ((1176 == 1176) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\121\76\137\240\76\89\132\238", "\130\42\56\232")]:IsReady() and v142) then
					if (v24(v49.Starfall, nil, not v16:IsInRange(45)) or (3062 == 1818)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\161\37\241\70\62\230\185\100\226\79\58\170\231\112", "\95\138\213\68\131\32");
					end
				end
				v138 = 4;
			end
			if ((v138 == 1) or (3717 < 3149)) then
				if ((3195 < 3730) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\237\176\94\64\72\221\90\248\168\90\94\65", "\40\190\196\59\44\36\188")]:IsCastable() and (v13:AstralPowerDeficit() > (v64 + v49[LUAOBFUSACTOR_DECRYPT_STR_0("\15\81\217\184\246\124\31\26\73\221\166\255", "\109\92\37\188\212\154\29")]:EnergizeAmount())) and (v86 < ((11 - v49[LUAOBFUSACTOR_DECRYPT_STR_0("\49\226\166\209\48\86\45\225\176\198\63\73\13\251\189", "\58\100\143\196\163\81")]:TalentRank()) - v49[LUAOBFUSACTOR_DECRYPT_STR_0("\59\81\55\177\62\69\214\3\21\78\39\166\45", "\110\122\34\67\195\95\41\133")]:TalentRank())) and v66) then
					if ((2797 <= 3980) and v48.CastCycle(v49.StellarFlare, v85, v96, not v16:IsSpellInRange(v49.StellarFlare))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\102\165\94\70\218\116\163\100\76\218\116\163\94\10\215\122\180\27\19", "\182\21\209\59\42");
					end
				end
				v140 = (v66 and ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\152\69\199\20\53\191\187\100\209\15\40\181\178", "\222\215\55\165\125\65")]:IsAvailable() and (v13:AstralPowerDeficit() < (v64 + (8 * v86)))) or v13:BuffUp(v49.TouchtheCosmos))) or (v13:AstralPowerDeficit() < (v64 + 8 + (12 * v26((v13:BuffRemains(v49.EclipseLunar) < 4) or (v13:BuffRemains(v49.EclipseSolar) < 4)))));
				if ((1944 <= 2368) and v13:BuffUp(v49.StarlordBuff) and (v13:BuffRemains(v49.StarlordBuff) < 2) and v140) then
					if ((1709 < 4248) and v10.CastAnnotated(v52.CancelStarlord, false, LUAOBFUSACTOR_DECRYPT_STR_0("\15\240\232\57\215\237", "\42\76\177\166\122\146\161\141"))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\139\11\205\124\122\154\136\16\200\127\54\182\158\4\220\117\121\183\142\69\207\118\115\229\211\75\155", "\22\197\234\101\174\25");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\30\32\164\206\112\174\219\138", "\230\77\84\197\188\22\207\183")]:IsReady() and v140) or (3970 == 3202)) then
					if (v24(v49.Starfall, nil, not v16:IsInRange(45)) or (3918 >= 4397)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\0\199\238\138\160\252\57\185\21\201\249\204\240\160", "\85\153\116\166\156\236\193\144");
					end
				end
				if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\151\244\76\161\226\9\182\229", "\96\196\128\45\211\132")]:IsReady() and v13:BuffUp(v49.DreamstateBuff) and v66 and v13:BuffUp(v49.EclipseLunar)) or (780 == 3185)) then
					if (v24(v49.Starfire, nil, nil, not v16:IsSpellInRange(v49.Starfire)) or (3202 >= 4075)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\38\153\122\77\212\166\166\221\117\140\116\90\146\254\229", "\184\85\237\27\63\178\207\212");
					end
				end
				v138 = 2;
			end
		end
	end
	local function v104()
		local v146 = 0;
		local v147;
		while true do
			if ((64 == 64) and (v146 == 0)) then
				v147 = v48.HandleTopTrinket(v51, v30, 40, nil);
				if ((2202 >= 694) and v147) then
					return v147;
				end
				v146 = 1;
			end
			if ((3706 <= 3900) and (v146 == 1)) then
				v147 = v48.HandleBottomTrinket(v51, v30, 40, nil);
				if ((2890 > 2617) and v147) then
					return v147;
				end
				break;
			end
		end
	end
	local function v105()
		C_Timer.After(0.15, function()
			local v148 = 0;
			while true do
				if ((v148 == 4) or (3355 > 4385)) then
					if (v29 or (3067 <= 2195)) then
						v86 = v16:GetEnemiesInSplashRangeCount(10);
					else
						v86 = 1;
					end
					if ((3025 >= 2813) and not v13:IsChanneling() and v31) then
						local v171 = 0;
						while true do
							if ((2412 >= 356) and (v171 == 2)) then
								if ((2070 > 1171) and not v13:AffectingCombat()) then
									if ((v49[LUAOBFUSACTOR_DECRYPT_STR_0("\21\61\28\141\51\59\29\165\55\32\30", "\227\88\82\115")]:IsCastable() and v44) or (4108 < 3934)) then
										if ((3499 >= 3439) and v25(v49.MoonkinForm)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\78\16\181\169\9\122\77\32\188\168\16\126\3\16\181\164", "\19\35\127\218\199\98");
										end
									end
								end
								if ((876 < 3303) and ((v48.TargetIsValid() and v28) or v13:AffectingCombat())) then
									local v175 = 0;
									local v176;
									while true do
										if ((2922 <= 3562) and (v175 == 2)) then
											v64 = (6 / v13:SpellHaste()) + v26(v49[LUAOBFUSACTOR_DECRYPT_STR_0("\209\225\166\172\26\59\236\194\179\181\9\48\252\229", "\94\159\128\210\217\104")]:IsAvailable()) + (v26(v49[LUAOBFUSACTOR_DECRYPT_STR_0("\127\235\4\182\75\93\235\127\81\242\3\173", "\26\48\153\102\223\63\31\153")]:IsAvailable()) * v26(v16:DebuffUp(v49.MoonfireDebuff)) * v26(v74[LUAOBFUSACTOR_DECRYPT_STR_0("\45\82\239\250\22\98\255\246\3\75\232\225\49\84\236\240\9\83", "\147\98\32\141")] > (27 - (2 * v26(v13:BuffUp(v49.SolsticeBuff))))) * 40);
											if ((2619 >= 1322) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\58\70\241\217\3\68\64\17\77\228", "\43\120\35\131\170\102\54")]:IsCastable() and v23() and ((v72 >= 20) or v57 or (v76 < 15))) then
												if ((4133 >= 2404) and v24(v49.Berserking, v32)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\86\3\149\165\160\162\143\93\8\128\246\168\177\141\90\70\213", "\228\52\102\231\214\197\208");
												end
											end
											v175 = 3;
										end
										if ((1 == v175) or (1433 == 2686)) then
											v62 = (v86 > (1 + v26(not v49[LUAOBFUSACTOR_DECRYPT_STR_0("\61\254\30\234\25\233\3\227\16\208\3\236\24\247\3\236\27", "\130\124\155\106")]:IsAvailable() and not v49[LUAOBFUSACTOR_DECRYPT_STR_0("\230\223\247\189\180\243\125\169\208\217", "\223\181\171\150\207\195\150\28")]:IsAvailable()))) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\127\46\226\188\15\77\54\239", "\105\44\90\131\206")]:IsAvailable();
											v63 = v86 > 1;
											v175 = 2;
										end
										if ((v175 == 3) or (4123 == 4457)) then
											v176 = v104();
											if (v176 or (3972 <= 205)) then
												return v176;
											end
											v175 = 4;
										end
										if ((v175 == 0) or (3766 < 1004)) then
											v98();
											if ((1784 < 2184) and not v13:AffectingCombat()) then
												local v183 = 0;
												local v184;
												while true do
													if ((v183 == 0) or (1649 > 4231)) then
														v184 = v100();
														if ((3193 == 3193) and v184) then
															return v184;
														end
														break;
													end
												end
											end
											v175 = 1;
										end
										if ((v175 == 4) or (3495 > 4306)) then
											if ((4001 > 3798) and v62 and v29) then
												local v185 = 0;
												local v186;
												while true do
													if ((v185 == 1) or (4688 <= 4499)) then
														if (v10.CastAnnotated(v49.Pool, false, "WAIT/AoE") or (1567 <= 319)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\41\225\124\222\170\141\22\196\94\193\122\239", "\182\126\128\21\170\138\235\121");
														end
														break;
													end
													if ((v185 == 0) or (4583 == 3761)) then
														v186 = v103();
														if ((3454 > 1580) and v186) then
															return v186;
														end
														v185 = 1;
													end
												end
											end
											if (true or (1607 == 20)) then
												local v187 = 0;
												local v188;
												while true do
													if ((v187 == 1) or (962 >= 4666)) then
														if (v10.CastAnnotated(v49.Pool, false, "WAIT/ST") or (1896 == 1708)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\188\219\60\242\198\21\63\20\203\233\1", "\102\235\186\85\134\230\115\80");
														end
														break;
													end
													if ((3985 >= 1284) and (0 == v187)) then
														v188 = v102();
														if (v188 or (1987 == 545)) then
															return v188;
														end
														v187 = 1;
													end
												end
											end
											break;
										end
									end
								end
								break;
							end
							if ((v171 == 0) or (4896 < 1261)) then
								if ((23 < 3610) and v13:AffectingCombat()) then
									local v177 = 0;
									while true do
										if ((v177 == 0) or (3911 < 2578)) then
											if (((v13:HealthPercentage() <= v46) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\205\68\162\163\15\176\240\115\191\177\20\185", "\213\131\37\214\214\125")]:IsReady()) or (4238 < 87)) then
												if ((2538 == 2538) and v25(v49.NaturesVigil, nil, nil, true)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\36\42\55\180\242\45\34\43\255\229\35\45\32\177\242\47\61\32\255\179", "\129\70\75\69\223");
												end
											end
											if ((4122 == 4122) and (v13:HealthPercentage() <= v45) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\100\202\225\226\111\228\79\197", "\143\38\171\147\137\28")]:IsReady()) then
												if (v25(v49.Barkskin, nil, nil, true) or (2371 > 2654)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\210\131\171\248\16\232\221\222\194\189\246\5\230\218\195\139\175\246\67\177", "\180\176\226\217\147\99\131");
												end
											end
											v177 = 1;
										end
										if ((v177 == 1) or (3466 > 4520)) then
											if (((v13:HealthPercentage() <= v38) and v37 and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\251\188\46\11\199\177\60\19\220\183\42", "\103\179\217\79")]:IsReady()) or (951 >= 1027)) then
												if (v25(v52.Healthstone, nil, nil, true) or (1369 > 2250)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\66\178\29\217\85\132\176\94\184\18\208\1\136\166\76\178\18\198\72\154\166\10\227", "\195\42\215\124\181\33\236");
												end
											end
											break;
										end
									end
								end
								if ((v16 and v16:Exists() and v16:IsAPlayer() and v16:IsDeadOrGhost() and not v13:CanAttack(v16)) or (937 > 3786)) then
									local v178 = 0;
									local v179;
									while true do
										if ((v178 == 0) or (901 > 4218)) then
											v179 = v48.DeadFriendlyUnitsCount();
											if ((4779 > 4047) and v13:AffectingCombat()) then
												if ((4050 > 1373) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\63\92\53\55\55\236\5", "\152\109\57\87\94\69")]:IsCastable()) then
													if (v25(v49.Rebirth, nil, true) or (1037 > 4390)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\235\210\8\170\172\198\92", "\200\153\183\106\195\222\178\52");
													end
												end
											elseif ((1407 <= 1919) and v49[LUAOBFUSACTOR_DECRYPT_STR_0("\0\230\158\52\95\95", "\58\82\131\232\93\41")]:IsCastable()) then
												if ((2526 >= 1717) and v25(v49.Revive, not v16:IsInRange(40), true)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\145\82\198\28\75\58", "\95\227\55\176\117\61");
												end
											end
											break;
										end
									end
								end
								v171 = 1;
							end
							if ((v171 == 1) or (3620 <= 2094)) then
								if ((v48.TargetIsValid() and not v56) or (1723 >= 2447)) then
									v99();
								end
								if (v48.TargetIsValid() or v13:AffectingCombat() or (1199 > 3543)) then
									local v180 = 0;
									while true do
										if ((1617 < 3271) and (v180 == 4)) then
											if ((3085 > 1166) and v71) then
												v72 = (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\163\17\26\167\206\132\30\13\175\211\132\43\24\170\217\132\11", "\188\234\127\121\198")]:IsAvailable() and v13:BuffRemains(v49.IncarnationBuff)) or v13:BuffRemains(v49.CABuff);
											end
											break;
										end
										if ((4493 >= 3603) and (v180 == 1)) then
											v76 = v75;
											if ((2843 <= 2975) and (v76 == 11111)) then
												v76 = v10.FightRemains(v85, false);
											end
											v180 = 2;
										end
										if ((v180 == 2) or (1989 <= 174)) then
											v70 = 0;
											if (v49[LUAOBFUSACTOR_DECRYPT_STR_0("\40\108\42\70\164\10\122\42\74\167\57\108\32\74\165\17\125\19\94\167\11\127\49", "\203\120\30\67\43")]:IsAvailable() or (209 > 2153)) then
												local v189 = 0;
												local v190;
												while true do
													if ((0 == v189) or (2020 == 1974)) then
														v190 = v13:BuffInfo(v49.PAPBuff, false, true);
														if ((v190 ~= nil) or (1347 == 1360)) then
															v70 = v190[LUAOBFUSACTOR_DECRYPT_STR_0("\225\42\68\225\205\226", "\185\145\69\45\143")][1];
														end
														break;
													end
												end
											end
											v180 = 3;
										end
										if ((v180 == 0) or (4461 == 3572)) then
											v73 = true;
											v75 = v10.BossFightRemains();
											v180 = 1;
										end
										if ((v180 == 3) or (2872 == 318)) then
											v71 = v13:BuffUp(v49.CABuff) or v13:BuffUp(v49.IncarnationBuff);
											v72 = 0;
											v180 = 4;
										end
									end
								end
								v171 = 2;
							end
						end
					end
					break;
				end
				if ((568 == 568) and (v148 == 1)) then
					v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\33\249\247\30\7\67\6", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\180\237", "\90\77\219\142")];
					v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\210\11\38\62\64\2\105", "\26\134\100\65\89\44\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\236\53", "\196\145\131\80\67")];
					v148 = 2;
				end
				if ((4200 == 4200) and (3 == v148)) then
					if (v13:IsDeadOrGhost() or (4285 < 1369)) then
						if (v25(v49.Nothing, nil, nil) or (3520 > 4910)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\155\51\60\135", "\131\223\86\93\227\208\148");
						end
					end
					v85 = v16:GetEnemiesInSplashRange(10);
					v148 = 4;
				end
				if ((2842 <= 4353) and (v148 == 0)) then
					v85 = v16:GetEnemiesInSplashRange(10);
					v47();
					v148 = 1;
				end
				if ((v148 == 2) or (3751 < 1643)) then
					v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\191\1\15\20\237\13", "\136\126\208\102\104\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\123\142\221", "\49\24\234\174\35\207\50\93")];
					v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\56\253\250\143\125\9\225", "\17\108\146\157\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\204\19\234\35\173", "\200\43\163\116\141\79")];
					v148 = 3;
				end
			end
		end);
	end
	local function v106()
		v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\117\13\50\94\124\215\39\23\40\44\74\123\208\98\101\3\42\94\102\221\45\89\76\60\70\50\241\50\94\15\112\31\65\193\50\71\3\44\75\119\208\98\85\21\126\120\125\222\43\69\13", "\66\55\108\94\63\18\180"));
	end
	v10.SetAPL(102, v105, v106);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\49\157\140\47\24\125\6\152\140\51\24\123\21\129\132\57\36\92\90\129\144\54", "\57\116\237\229\87\71")]();

