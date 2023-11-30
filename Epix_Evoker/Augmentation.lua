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
		if ((v5 == 1) or (1106 > 2800)) then
			return v6(...);
		end
		if ((4650 > 590) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (3774 <= 3667)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\158\209\17\218\198\201\26\199\174\192\19\212\205\207\36\242\178\200\16\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\5\37\118\138\237\174\54", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\118\216\34", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\142\114\127\61\0", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\150\67\197\180\51\99\32\196\183\90", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\96\86\5\40", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\137\215\222\6\17", "\75\220\163\183\106\98")];
	local v22 = EpicLib;
	local v23 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\33\187\152\35", "\185\98\218\235\87")];
	local v24 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\232\61\52\242\255\164\197\51\51\231\202\175\207", "\202\171\92\71\134\190")];
	local v25 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\10\192\63\156\25\206\35\132\32\207\43", "\232\73\161\76")];
	local v26 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\150\216\65\79\17", "\126\219\185\34\61")];
	local v27 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\60\220\91\97\109", "\135\108\174\62\18\30\23\147")];
	local v28 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\3\180", "\75\103\118\217")];
	local v29 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\228\91\125\25\182\16\212", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\56\37\146\173\22\242\205", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\225\170\194", "\174\103\142\197")];
	local v30 = 0;
	local v31 = false;
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
	local v75 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\115\62\80\51\32\76", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\209\233\81\209\202\250\93\192\205\225\82", "\60\180\164\142")];
	local v76 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\125\72\10\34\34\255", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\153\252\220\201\189\231\207\197\172\224\212\202", "\164\216\137\187")];
	local v77 = v26[LUAOBFUSACTOR_DECRYPT_STR_0("\247\240\62\185\163\236", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\27\133\203\175\54\26\131\210\163\55\0", "\202\88\110\226\166")];
	local v78 = {};
	local v79 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\224\0\143\250\197\205\28", "\170\163\111\226\151")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\38\183\42\87\56\39\20", "\73\113\80\210\88\46\87")];
	local v80 = {};
	local v81 = ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\167\35\195\6\232\135\1\204\21\238\130", "\135\225\76\173\114")]:IsAvailable()) and 4) or 3;
	local v82 = ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\60\226\182\164\163\187\138\27\234\177\179", "\199\122\141\216\208\204\221")]:IsAvailable()) and 0.8) or 1;
	local v83 = 11111;
	local v84 = 11111;
	local v85 = 1;
	local v86 = 1;
	local v87 = {{v75[LUAOBFUSACTOR_DECRYPT_STR_0("\153\220\25\252\75\225\164\205\21", "\150\205\189\112\144\24")],LUAOBFUSACTOR_DECRYPT_STR_0("\6\133\172\88\68\188\16\25\41\196\140\91\13\152\20\80\109\173\177\88\1\154\3\5\53\144\246", "\112\69\228\223\44\100\232\113"),function()
		return true;
	end},{v75[LUAOBFUSACTOR_DECRYPT_STR_0("\227\22\9\212\148\105\128\210\26\19", "\230\180\127\103\179\214\28")],LUAOBFUSACTOR_DECRYPT_STR_0("\175\4\76\82\164\118\233\130\2\31\100\241\71\230\137\17\31\14\205\79\244\137\23\77\83\244\85\169", "\128\236\101\63\38\132\33"),function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v102 = 0;
		while true do
			if ((1270 < 2146) and (0 == v102)) then
				v83 = 11111;
				v84 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\156\133\48\125\147\217\240\158\140\54\97\152\212\234\130\136\51\104\147\207", "\175\204\201\113\36\214\139"));
	v10:RegisterForEvent(function()
		local v103 = 0;
		while true do
			if ((4563 >= 56) and (v103 == 0)) then
				v81 = ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\97\195\59\200\11\65\225\52\219\13\68", "\100\39\172\85\188")]:IsAvailable()) and 4) or 3;
				v82 = ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\139\119\183\148\60\171\85\184\135\58\174", "\83\205\24\217\224")]:IsAvailable()) and 0.8) or 1;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\213\245\232\17\202\246\242\30\206\228\227\26\195\225", "\93\134\165\173"), LUAOBFUSACTOR_DECRYPT_STR_0("\146\215\224\240\20\235\150\65\141\194\228\238\22\241\155\80\129\198\224\224", "\30\222\146\161\162\90\174\210"));
	local v88;
	local function v89()
	end
	local v90;
	local function v91()
		local v104 = 0;
		local v105;
		local v106;
		while true do
			if ((v104 == 1) or (446 == 622)) then
				v106 = nil;
				for v142, v143 in pairs(v105) do
					if ((2069 > 1009) and v143:Exists() and (UnitGroupRolesAssigned(v142) == LUAOBFUSACTOR_DECRYPT_STR_0("\243\174\48\217\156\238", "\175\187\235\113\149\217\188")) and v143:IsInRange(25) and (v143:HealthPercentage() > 0)) then
						local v177 = 0;
						while true do
							if ((12 < 4208) and (v177 == 0)) then
								v106 = v143;
								v90 = v143:GUID();
								break;
							end
						end
					end
				end
				v104 = 2;
			end
			if ((v104 == 2) or (2990 <= 2980)) then
				return v106;
			end
			if ((v104 == 0) or (2575 >= 4275)) then
				v105 = nil;
				if (UnitInRaid(LUAOBFUSACTOR_DECRYPT_STR_0("\245\66\113\19\224\92", "\106\133\46\16")) or (3626 <= 1306)) then
					v105 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\106\33\122\248", "\32\56\64\19\156\58")];
				elseif ((1368 < 3780) and UnitInParty(LUAOBFUSACTOR_DECRYPT_STR_0("\74\196\228\79\95\224", "\224\58\168\133\54\58\146"))) then
					v105 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\105\87\89\233\108", "\107\57\54\43\157\21\230\231")];
				else
					return false;
				end
				v104 = 1;
			end
		end
	end
	local v92;
	local function v93()
		local v107 = 0;
		local v108;
		while true do
			if ((v107 == 0) or (3169 == 2273)) then
				v108 = nil;
				if ((2481 <= 3279) and UnitInRaid(LUAOBFUSACTOR_DECRYPT_STR_0("\44\163\128\85\230\107", "\24\92\207\225\44\131\25"))) then
					v108 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\121\210\177\72", "\29\43\179\216\44\123")];
				elseif (UnitInParty(LUAOBFUSACTOR_DECRYPT_STR_0("\173\213\33\85\184\203", "\44\221\185\64")) or (1063 <= 877)) then
					v108 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\49\230\90\75\106", "\19\97\135\40\63")];
				else
					v108 = v13;
				end
				v107 = 1;
			end
			if ((2314 == 2314) and (v107 == 1)) then
				if ((924 >= 477) and (v108 == v13)) then
					local v146 = 0;
					while true do
						if ((1813 <= 3778) and (v146 == 0)) then
							v92 = v13:GUID();
							return v13;
						end
					end
				else
					for v178, v179 in pairs(v108) do
						if ((4150 == 4150) and v179:Exists() and (v179:IsTankingAoE(8) or v179:IsTanking(v16)) and (UnitGroupRolesAssigned(v178) == LUAOBFUSACTOR_DECRYPT_STR_0("\154\125\29\16", "\81\206\60\83\91\79")) and v179:IsInRange(25) and (v179:HealthPercentage() > 0)) then
							local v183 = 0;
							while true do
								if ((432 <= 3007) and (v183 == 0)) then
									v92 = v179:GUID();
									return v179;
								end
							end
						end
					end
				end
				return nil;
			end
		end
	end
	local function v94()
		local v109 = 0;
		while true do
			if ((v109 == 0) or (408 > 2721)) then
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\108\167\213\97\60\202\67\163\65\173\196\122\42\225\95\171\64\177\213", "\196\46\203\176\18\79\163\45")]:IsCastable() and v54 and (v13:BuffDown(v75.BlessingoftheBronzeBuff, true) or v79.GroupBuffMissing(v75.BlessingoftheBronzeBuff))) or (3418 < 2497)) then
					if ((1735 < 2169) and v23(v75.BlessingoftheBronze, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\46\123\13\55\242\225\191\29\113\24\27\239\231\189\29\124\12\43\245\245\189\98\110\12\33\248\224\181\32\127\10", "\143\216\66\30\126\68\155");
					end
				end
				if ((3890 >= 3262) and (v39 == LUAOBFUSACTOR_DECRYPT_STR_0("\139\221\25\196", "\129\202\168\109\171\165\195\183"))) then
					if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\17\87\34\202\221\17\233\36\117\54\223\215\23", "\134\66\56\87\184\190\116")]:IsCastable() and v17:IsInRange(25) and (v90 == v17:GUID()) and (v17:BuffRemains(v75.SourceofMagicBuff) < 300)) or (4356 >= 4649)) then
						if ((3904 == 3904) and v23(v77.SourceofMagicFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\47\62\28\169\26\238\30\58\58\14\4\186\30\226\34\117\44\35\12\184\22\230\35\52\40", "\85\92\81\105\219\121\139\65");
						end
					end
				end
				v109 = 1;
			end
			if ((v109 == 2) or (2860 >= 3789)) then
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\121\60\187\88\87\94\15\160\66\88\85\43\185\83\67\79", "\45\59\78\212\54")]:IsCastable() and v13:BuffDown(v75.BronzeAttunementBuff) and v13:BuffUp(v75.BlackAttunementBuff) and not v13:BuffUp(v75.BlackAttunementBuff, false)) or (1086 > 4449)) then
					if ((4981 > 546) and v23(v75.BronzeAttunement)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\68\140\133\156\43\146\241\4\66\150\133\131\35\168\254\4\22\147\153\131\45\162\253\18\87\151", "\144\112\54\227\235\230\78\205");
					end
				end
				if ((v36 == LUAOBFUSACTOR_DECRYPT_STR_0("\146\61\27\243", "\59\211\72\111\156\176")) or (2366 <= 8)) then
					if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\108\139\234\62\90\130\241\36\64\128\208\46\79\139\230\62", "\77\46\231\131")]:IsCastable() and v17:IsInRange(25) and (v17:BuffStack(v75.BlisteringScalesBuff) <= v37) and (v92 == v17:GUID())) or (2590 == 2864)) then
						if (v23(v77.BlisteringScalesFocus, nil, nil) or (2624 > 4149)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\184\88\191\83\174\81\164\73\180\83\137\83\185\85\186\69\169\20\166\82\191\87\185\77\184\85\162\0\232", "\32\218\52\214");
						end
					end
				end
				v109 = 3;
			end
			if ((v109 == 3) or (2618 >= 4495)) then
				if ((v36 == LUAOBFUSACTOR_DECRYPT_STR_0("\125\18\61\173\242\164\64\94", "\58\46\119\81\200\145\208\37")) or (2485 >= 3131)) then
					local v147 = 0;
					local v148;
					while true do
						if ((v147 == 0) or (2804 <= 2785)) then
							v148 = v79.NamedUnit(25, v38);
							if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\9\128\57\191\189\184\36\34\130\55\159\170\188\58\46\159", "\86\75\236\80\204\201\221")]:IsCastable() and (v148:BuffStack(v75.BlisteringScalesBuff) <= v37)) or (4571 == 3415)) then
								if (v23(v77.BlisteringScalesName, nil, nil) or (4441 > 4787)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\112\77\126\150\234\142\96\72\121\130\193\152\113\64\123\128\237\203\98\83\114\134\241\134\112\64\99\197\172", "\235\18\33\23\229\158");
								end
							end
							break;
						end
					end
				end
				if ((1920 == 1920) and v33 and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\100\179\209\143\88\191\242\184\81\182\196\168", "\219\48\218\161")]:IsCastable()) then
					if (v23(v75.TipTheScales, nil) or (647 == 4477)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\120\108\118\207\71\229\219\98\127\72\215\74\243\164\97\110\76\216\64\237\230\112\104\9\141", "\128\132\17\28\41\187\47");
					end
				end
				v109 = 4;
			end
			if ((3819 == 3819) and (v109 == 4)) then
				if (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\36\48\9\52\112\8\53\14\46", "\61\97\82\102\90")]:IsReady() or (1466 > 4360)) then
					if (v23(v75.EbonMight, nil) or (14 > 994)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\44\164\69\248\90\23\14\164\58\235\91\213\82\29\6\161\44\170\95\135\15", "\105\204\78\203\43\167\55\126");
					end
				end
				if ((401 <= 734) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\137\163\53\23\29\3\225\93\164\167\38", "\49\197\202\67\126\115\100\167")]:IsCastable()) then
					if (v23(v75.LivingFlame, nil, nil, not v16:IsSpellInRange(v75.LivingFlame)) or (2167 >= 3426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\82\201\32\142\81\97\49\87\222\36\133\22\78\37\94\220\38\141\84\95\35\27\142\121", "\62\87\59\191\73\224\54");
					end
				end
				break;
			end
			if ((764 < 3285) and (v109 == 1)) then
				if ((2499 == 2499) and (v39 == LUAOBFUSACTOR_DECRYPT_STR_0("\206\182\92\64\127\203\248\183", "\191\157\211\48\37\28"))) then
					local v149 = 0;
					local v150;
					while true do
						if ((v149 == 0) or (692 >= 4933)) then
							v150 = v79.NamedUnit(25, v40);
							if ((v150 and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\236\16\225\14\57\218\16\242\49\59\216\22\247", "\90\191\127\148\124")]:IsCastable() and (v150:BuffRemains(v75.SourceofMagicBuff) < 300)) or (3154 <= 2260)) then
								if (v23(v77.SourceofMagicName) or (2637 > 3149)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\107\136\59\5\123\130\17\24\126\184\35\22\127\142\45\87\104\149\43\20\119\138\44\22\108", "\119\24\231\78");
								end
							end
							break;
						end
					end
				end
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\160\33\164\73\215\97\5\150\56\171\79\209\69\31\150", "\113\226\77\197\42\188\32")]:IsCastable() and v13:BuffDown(v75.BlackAttunementBuff)) or (3992 < 2407)) then
					if (v23(v75.BlackAttunement) or (2902 > 4859)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\26\245\182\49\41\245\161\46\3\250\176\55\19\250\161\122\6\230\176\57\25\249\183\59\2", "\213\90\118\148");
					end
				end
				v109 = 2;
			end
		end
	end
	local function v95()
		local v110 = 0;
		while true do
			if ((1679 < 4359) and (v110 == 0)) then
				if ((1913 < 4670) and (not v17 or not v17:Exists() or not v17:IsInRange(30) or not v79.DispellableFriendlyUnit())) then
					return;
				end
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\194\26\234\220\233\5\255", "\169\135\98\154")]:IsReady() and (v79.UnitHasPoisonDebuff(v17))) or (2846 < 879)) then
					if ((4588 == 4588) and v27(v77.ExpungeFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\238\111\52\65\243\52\205\139\115\45\71\237\54\196", "\168\171\23\68\52\157\83");
					end
				end
				v110 = 1;
			end
			if ((v110 == 1) or (347 == 2065)) then
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\219\97\229\191\32\62\148\253\127\242\159\42\44\149", "\231\148\17\149\205\69\77")]:IsReady() and v64 and v79.UnitHasEnrageBuff(v16)) or (1311 > 2697)) then
					if (v27(v75.OppressingRoar) or (2717 > 3795)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\175\183\215\233\82\236\147\174\201\252\23\205\143\166\213\187\83\246\147\183\194\247", "\159\224\199\167\155\55");
					end
				end
				break;
			end
		end
	end
	local function v96()
		local v111 = 0;
		while true do
			if ((v111 == 0) or (1081 < 391)) then
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\213\255\57\193\228\250\50\213\248\245\40\218\242\209\46\221\249\233\57", "\178\151\147\92")]:IsCastable() and v54 and (v13:BuffDown(v75.BlessingoftheBronzeBuff, true) or v79.GroupBuffMissing(v75.BlessingoftheBronzeBuff))) or (121 > 3438)) then
					if ((71 < 1949) and v23(v75.BlessingoftheBronze, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\142\241\73\33\1\69\116\139\194\67\52\45\88\114\137\194\78\32\29\66\96\137\189\92\32\23\79\117\129\255\77\38", "\26\236\157\44\82\114\44");
					end
				end
				if ((4254 == 4254) and (v39 == LUAOBFUSACTOR_DECRYPT_STR_0("\11\59\193\84", "\59\74\78\181"))) then
					if ((3196 >= 2550) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\22\222\79\72\176\32\222\92\119\178\34\216\89", "\211\69\177\58\58")]:IsCastable() and v17:IsInRange(25) and (v90 == v17:GUID()) and (v17:BuffRemains(v75.SourceofMagicBuff) < 300)) then
						if ((2456 < 4176) and v23(v77.SourceofMagicFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\164\234\108\231\234\206\136\234\127\202\228\202\176\236\122\181\249\217\178\230\118\248\235\202\163", "\171\215\133\25\149\137");
						end
					end
				end
				v111 = 1;
			end
			if ((v111 == 1) or (1150 == 3452)) then
				if ((1875 < 2258) and (v39 == LUAOBFUSACTOR_DECRYPT_STR_0("\210\205\62\255\236\36\249\70", "\34\129\168\82\154\143\80\156"))) then
					local v151 = 0;
					local v152;
					while true do
						if ((1173 > 41) and (v151 == 0)) then
							v152 = v79.NamedUnit(25, v40);
							if ((v152 and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\182\189\38\25\75\75\134\131\159\50\12\65\77", "\233\229\210\83\107\40\46")]:IsCastable() and (v152:BuffRemains(v75.SourceofMagicBuff) < 300)) or (56 >= 3208)) then
								if ((4313 > 3373) and v23(v77.SourceofMagicName)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\210\77\39\196\6\196\125\61\208\58\204\67\53\223\6\129\82\32\211\6\206\79\48\215\17", "\101\161\34\82\182");
								end
							end
							break;
						end
					end
				end
				if ((v36 == LUAOBFUSACTOR_DECRYPT_STR_0("\201\24\77\241", "\78\136\109\57\158\187\130\226")) or (4493 == 2225)) then
					if ((3104 >= 3092) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\28\51\240\226\42\58\235\248\48\56\202\242\63\51\252\226", "\145\94\95\153")]:IsCastable() and v17:IsInRange(25) and (v17:BuffStack(v75.BlisteringScalesBuff) <= v37) and (v92 == v17:GUID())) then
						if ((3548 > 3098) and v23(v77.BlisteringScalesFocus, nil, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\255\193\29\198\90\178\239\196\26\210\113\164\254\204\24\208\93\247\240\204\29\219\14\228\169", "\215\157\173\116\181\46");
						end
					end
				end
				v111 = 2;
			end
			if ((2 == v111) or (3252 == 503)) then
				if ((4733 > 2066) and (v36 == LUAOBFUSACTOR_DECRYPT_STR_0("\6\177\135\247\217\33\177\143", "\186\85\212\235\146"))) then
					local v153 = 0;
					local v154;
					while true do
						if ((3549 >= 916) and (v153 == 0)) then
							v154 = v79.NamedUnit(25, v38);
							if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\224\141\31\237\45\235\74\203\143\17\205\58\239\84\199\146", "\56\162\225\118\158\89\142")]:IsCastable() and (v154:BuffStack(v75.BlisteringScalesBuff) <= v37)) or (2189 <= 245)) then
								if (v23(v77.BlisteringScalesName, nil, nil) or (1389 > 3925)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\94\9\201\188\54\221\78\12\206\168\29\203\95\4\204\170\49\152\81\4\201\161\98\139\8", "\184\60\101\160\207\66");
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
	local function v97()
		local v112 = 0;
		while true do
			if ((4169 >= 3081) and (v112 == 1)) then
				if ((349 <= 894) and (v47 == LUAOBFUSACTOR_DECRYPT_STR_0("\134\185\231\201\179\167\166\255\184\185\255", "\176\214\213\134"))) then
					if ((731 <= 2978) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\209\160\179\198\169\90\93\214\161\185\199\187\89\84", "\57\148\205\214\180\200\54")]:IsReady() and (v13:HealthPercentage() < v49)) then
						if (v23(v77.EmeraldBlossomPlayer, nil) or (892 > 3892)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\23\240\48\38\119\30\249\10\54\122\29\238\38\59\123\82\240\52\61\120\82\169\103", "\22\114\157\85\84");
						end
					end
				end
				if ((v47 == LUAOBFUSACTOR_DECRYPT_STR_0("\225\221\22\214\68\249\166\193", "\200\164\171\115\164\61\150")) or (4466 == 900)) then
					if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\155\249\6\87\130\178\240\33\73\140\173\231\12\72", "\227\222\148\99\37")]:IsReady() and (v17:HealthPercentage() < v49)) or (2084 >= 2888)) then
						if ((479 < 1863) and v23(v77.EmeraldBlossomFocus, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\54\95\87\228\248\63\86\109\244\245\60\65\65\249\244\115\95\83\255\247\115\6\0", "\153\83\50\50\150");
						end
					end
				end
				break;
			end
			if ((v112 == 0) or (2428 >= 4038)) then
				if ((v46 == LUAOBFUSACTOR_DECRYPT_STR_0("\1\142\125\165\52\144\60\147\63\142\101", "\220\81\226\28")) or (2878 > 2897)) then
					if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\37\208\144\255\235\201\7\240\143\249\248\198\16\208", "\167\115\181\226\155\138")]:IsReady() and (v13:HealthPercentage() < v48)) or (2469 > 3676)) then
						if ((233 < 487) and v23(v77.VerdantEmbracePlayer, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\244\39\245\88\122\127\210\221\39\234\94\105\112\197\231\98\234\93\114\127\134\182\114", "\166\130\66\135\60\27\17");
						end
					end
				end
				if ((2473 >= 201) and ((v46 == LUAOBFUSACTOR_DECRYPT_STR_0("\97\92\203\103\41\75\68\203", "\80\36\42\174\21")) or (v46 == LUAOBFUSACTOR_DECRYPT_STR_0("\96\31\35\58\122\17\57\113", "\26\46\112\87")))) then
					if ((4120 >= 133) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\143\38\185\112\190\177\81\145\180\33\185\117\188\186", "\212\217\67\203\20\223\223\37")]:IsReady() and (v17:HealthPercentage() < v48)) then
						if ((3080 >= 1986) and v23(v77.VerdantEmbraceFocus, nil)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\172\136\186\214\187\131\188\237\191\128\170\192\187\142\173\146\183\140\161\220\250\217\248", "\178\218\237\200");
						end
					end
				end
				v112 = 1;
			end
		end
	end
	local function v98()
		local v113 = 0;
		local v114;
		while true do
			if ((v113 == 8) or (1439 > 3538)) then
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\253\84\21\99\191\162\215\72", "\203\184\38\96\19\203")]:IsReady() and ((v13:BuffRemains(v75.EbonMightSelfBuff) > v75[LUAOBFUSACTOR_DECRYPT_STR_0("\28\97\108\81\218\48\124\119", "\174\89\19\25\33")]:CastTime()) or (v13:EssenceTimeToMax() < v75[LUAOBFUSACTOR_DECRYPT_STR_0("\10\0\71\94\227\142\4\33", "\107\79\114\50\46\151\231")]:CastTime()) or v13:BuffUp(v75.EssenceBurstBuff))) or (419 < 7)) then
					if ((2820 == 2820) and v23(v75.Eruption, nil, nil, not v16:IsInRange(25))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\180\160\57\158\48\184\206\121\171\180\32\132\121\228\150", "\160\89\198\213\73\234\89\215");
					end
				end
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\100\120\162\247\203\79\87\184\255\200\77", "\165\40\17\212\158")]:IsCastable() and (not v13:IsMoving() or v75[LUAOBFUSACTOR_DECRYPT_STR_0("\213\204\24\58\42\234\223\41\63\35\253\202\28\33\39\246\195\9", "\70\133\185\104\83")]:IsAvailable())) or (4362 <= 3527)) then
					if ((2613 <= 2680) and v23(v75.LivingFlame, nil, nil, not v16:IsSpellInRange(v75.LivingFlame))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\76\82\35\199\3\122\66\38\200\9\64\4\39\200\13\75\4\126\155", "\169\100\37\36\74");
					end
				end
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\33\157\183\66\5\180\182\66\9\140\167", "\48\96\231\194")]:IsCastable() and not v75[LUAOBFUSACTOR_DECRYPT_STR_0("\248\79\30\36\21\215\169\162\196\95\22\62\13\202\174\144\210\91", "\227\168\58\110\77\121\184\207")]:IsAvailable()) or (1482 >= 4288)) then
					if (v23(v75.AzureStrike, nil, nil, not v16:IsSpellInRange(v75.AzureStrike)) or (2462 > 4426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\122\38\170\82\180\228\98\177\105\53\180\69\241\214\112\172\117\124\235\20", "\197\27\92\223\32\209\187\17");
					end
				end
				break;
			end
			if ((4774 == 4774) and (v113 == 7)) then
				if ((566 <= 960) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\113\81\22\219\117\74\1\223\67\80", "\190\55\56\100")]:IsCastable() and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\119\161\63\23\22\237\231\112\163\61\19\22", "\147\54\207\92\126\115\131")]:IsAvailable() and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(v81))) then
					local v155 = 0;
					while true do
						if ((v155 == 0) or (2910 <= 1930)) then
							v86 = v81;
							if (v24(v75.FireBreath, false, v81, not v16:IsInRange(25), nil) or (19 > 452)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\11\56\39\120\50\124\31\52\52\105\5\62\8\60\37\114\26\123\31\113", "\30\109\81\85\29\109") .. v81 .. LUAOBFUSACTOR_DECRYPT_STR_0("\191\124\85\191\56\158\174\167", "\156\159\17\52\214\86\190");
							end
							break;
						end
					end
				end
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\155\255\181\185\175\249\188\176", "\220\206\143\221")]:IsCastable() and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(1))) or (907 > 3152)) then
					local v156 = 0;
					local v157;
					while true do
						if ((v156 == 0) or (2505 > 4470)) then
							v157 = 1;
							if (((EnemiesCount8ySplash > 1) and (EnemiesCount8ySplash < 4) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(2))) or (3711 > 4062)) then
								v157 = 2;
							elseif ((420 == 420) and (EnemiesCount8ySplash > 3) and (EnemiesCount8ySplash < 6) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(3))) then
								v157 = 3;
							elseif (((EnemiesCount8ySplash > 5) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(v81))) or (33 >= 3494)) then
								v157 = v81;
							end
							v156 = 1;
						end
						if ((v156 == 1) or (1267 == 4744)) then
							v85 = v157;
							if ((2428 < 3778) and v24(v75.Upheaval, false, v157, not v16:IsInRange(25), nil)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\147\109\37\18\217\218\211\138\61\40\26\200\195\197\131\111\109", "\178\230\29\77\119\184\172") .. v157 .. LUAOBFUSACTOR_DECRYPT_STR_0("\181\179\11\18\121\184\166\238", "\152\149\222\106\123\23");
							end
							break;
						end
					end
				end
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\249\35\243\83\151\207\35\247\87\189", "\213\189\70\150\35")]:IsCastable() and not v75[LUAOBFUSACTOR_DECRYPT_STR_0("\109\71\113\9\91\93\123\14\106\90\122\27", "\104\47\53\20")]:IsAvailable()) or (2946 <= 1596)) then
					if ((4433 > 3127) and v23(v75.DeepBreath, nil, nil, not v16:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\167\73\132\12\131\13\177\73\128\8\180\79\174\77\136\18\252\92\241", "\111\195\44\225\124\220");
					end
				end
				v113 = 8;
			end
			if ((4300 >= 2733) and (6 == v113)) then
				if ((4829 == 4829) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\201\16\67\138\17\10\9\82\228\20\80", "\62\133\121\53\227\127\109\79")]:IsReady() and (v10.CombatTime() < (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\60\29\36\252\216\169\132\28\21\63\240", "\194\112\116\82\149\182\206")]:CastTime() * 2))) then
					if ((1683 <= 4726) and v23(v75.LivingFlame, nil, nil, not v16:IsSpellInRange(v75.LivingFlame))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\161\90\17\206\229\49\63\164\77\21\197\162\3\56\161\66\88\148", "\110\89\200\44\120\160\130");
					end
				end
				if ((4835 >= 3669) and v33 and v71 and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\159\202\70\67\112\65\50\93", "\45\203\163\43\38\35\42\91")]:IsCastable() and ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\244\140\206\38\165\187\81\211\145\212", "\52\178\229\188\67\231\201")]:CooldownRemains() + v75[LUAOBFUSACTOR_DECRYPT_STR_0("\20\81\88\1\246\74\34\45", "\67\65\33\48\100\151\60")]:CooldownRemains() + v75[LUAOBFUSACTOR_DECRYPT_STR_0("\239\245\171\203\240\214\226\160\219\246", "\147\191\135\206\184")]:CooldownRemains()) > 35)) then
					if ((2851 > 1859) and v70) then
						if ((3848 > 2323) and v13:BuffUp(v75.HoverBuff)) then
							if ((2836 > 469) and v23(v75.TimeSkip, nil)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\144\33\171\196\231\64\185\141\56\230\204\217\90\188\196\122\242", "\210\228\72\198\161\184\51");
							end
						elseif (v23(v75.Hover, nil) or (2096 <= 540)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\62\70\229\21\97\142\59\72\250\30\51\156\98", "\174\86\41\147\112\19");
						end
					elseif (v23(v75.TimeSkip, nil) or (3183 < 2645)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\9\128\14\26\28\26\162\75\64\128\10\44\1\81\249\15", "\203\59\96\237\107\69\111\113");
					end
				end
				if ((3230 <= 3760) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\2\31\190\228\19\226\210\37\2\164", "\183\68\118\204\129\81\144")]:IsCastable() and not v75[LUAOBFUSACTOR_DECRYPT_STR_0("\47\163\115\237\14\140\26\139\124\229\6\135", "\226\110\205\16\132\107")]:IsAvailable() and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(1))) then
					local v158 = 0;
					while true do
						if ((3828 == 3828) and (v158 == 0)) then
							v86 = 1;
							if ((554 == 554) and v24(v75.FireBreath, false, "1", not v16:IsInRange(25), nil)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\237\202\242\220\126\233\209\229\216\85\227\131\229\212\81\228\212\229\203\1\186\131\237\216\72\229\131\178\143", "\33\139\163\128\185");
							end
							break;
						end
					end
				end
				v113 = 7;
			end
			if ((v113 == 3) or (2563 == 172)) then
				if ((3889 >= 131) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\213\120\228\9\50\88\246\112\226\4", "\42\147\17\150\108\112")]:IsCastable() and not v75[LUAOBFUSACTOR_DECRYPT_STR_0("\35\163\44\111\238\230\8\128\33\126\234\237\28", "\136\111\198\77\31\135")]:IsAvailable() and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\54\0\170\83\142\239\30\185", "\201\98\105\199\54\221\132\119")]:IsAvailable() and not v75[LUAOBFUSACTOR_DECRYPT_STR_0("\144\2\151\36\16\34\163\175\9\141\21\10\39\169\184\8\144", "\204\217\108\227\65\98\85")]:IsAvailable() and (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\106\202\248\224\31\203\87\211", "\160\62\163\149\133\76")]:CooldownRemains() <= v13:EmpowerCastTime(1)) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(1))) then
					local v159 = 0;
					while true do
						if ((v159 == 0) or (492 == 4578)) then
							v86 = 1;
							if (v24(v75.FireBreath, false, "1", not v16:IsInRange(25), nil) or (4112 < 1816)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\208\169\31\42\252\212\178\8\46\215\222\224\8\34\211\217\183\8\61\131\135\224\0\46\202\216\224\92\125", "\163\182\192\109\79");
							end
							break;
						end
					end
				end
				if ((4525 >= 1223) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\18\47\18\197\215\38\35\1\212\253", "\149\84\70\96\160")]:IsCastable() and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\20\3\12\253\49\8\10\203\52\7\0\232\43", "\141\88\102\109")]:IsAvailable() and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\135\90\199\117\41\54\92\209", "\161\211\51\170\16\122\93\53")]:IsAvailable() and not v75[LUAOBFUSACTOR_DECRYPT_STR_0("\210\160\166\45\233\185\189\62\254\160\134\32\233\171\179\44\232", "\72\155\206\210")]:IsAvailable() and (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\114\115\89\11\0\77\115\68", "\83\38\26\52\110")]:CooldownRemains() <= v13:EmpowerCastTime(v81)) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(v81))) then
					local v160 = 0;
					while true do
						if ((1090 <= 4827) and (v160 == 0)) then
							v86 = v81;
							if (v24(v75.FireBreath, false, v81, not v16:IsInRange(25), nil) or (239 > 1345)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\94\30\53\67\103\21\53\67\89\3\47\6\93\26\55\73\79\18\53\6", "\38\56\119\71") .. v81 .. LUAOBFUSACTOR_DECRYPT_STR_0("\179\226\89\223\43\22\162\187", "\54\147\143\56\182\69");
							end
							break;
						end
					end
				end
				if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\227\145\247\76\222\192\128\243", "\191\182\225\159\41")]:IsCastable() and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\31\27\37\80\184\140\203\59", "\162\75\114\72\53\235\231")]:IsAvailable() and not v75[LUAOBFUSACTOR_DECRYPT_STR_0("\165\50\80\231\65\21\131\42\65\236\103\10\158\57\69\230\64", "\98\236\92\36\130\51")]:IsAvailable() and (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\144\16\1\191\118\163\188\32", "\80\196\121\108\218\37\200\213")]:CooldownRemains() <= v13:EmpowerCastTime(1)) and (v13:BuffRemains(v75.EbonMightSelfBuff) > v13:EmpowerCastTime(1))) or (3710 >= 3738)) then
					local v161 = 0;
					while true do
						if ((v161 == 0) or (3838 < 2061)) then
							v85 = 1;
							if (v24(v75.Upheaval, false, "1", not v16:IsInRange(25), nil) or (690 > 1172)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\21\99\10\122\74\24\139\12\51\7\114\68\30\157\5\97\66\46\11\3\139\9\125\66\46\29", "\234\96\19\98\31\43\110");
							end
							break;
						end
					end
				end
				v113 = 4;
			end
			if ((v113 == 4) or (1592 > 2599)) then
				if ((3574 <= 4397) and v33 and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\36\13\87\198\184\122\132\0\58\93\201\191", "\235\102\127\50\167\204\18")]:IsCastable() and (v13:BuffUp(v75.EbonMightSelfBuff) or (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\117\163\250\45\105\39\87\169\225", "\78\48\193\149\67\36")]:CooldownRemains() < 4))) then
					if ((3135 > 1330) and (v69 == LUAOBFUSACTOR_DECRYPT_STR_0("\16\61\149\10\82\63\12", "\33\80\126\224\120"))) then
						if (v27(v77.BreathofEonsCursor, not v16:IsInRange(30)) or (3900 <= 3641)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\238\186\6\197\72\228\151\12\194\99\233\167\13\215\28\225\169\10\202\28\189\240", "\60\140\200\99\164");
						end
					elseif ((1724 == 1724) and (v69 == LUAOBFUSACTOR_DECRYPT_STR_0("\164\251\10\32\171\149\249\5\50\171\136\250", "\194\231\148\100\70"))) then
						if ((455 <= 1282) and v23(v75.BreathofEons, nil, nil, not v16:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\68\94\196\162\226\192\121\67\199\156\243\199\72\95\129\174\247\193\72\12\144\251", "\168\38\44\161\195\150");
						end
					end
				end
				if ((4606 < 4876) and ((((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\180\249\143\102\63\250\183\26\183\243\151\120\52\204\179\20\149\250\132", "\118\224\156\226\22\80\136\214")]:AuraActiveCount() > 0) or (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\96\252\92\129\86\230\86\134\103\225\87\147", "\224\34\142\57")]:CooldownRemains() > 30)) and (v69 ~= LUAOBFUSACTOR_DECRYPT_STR_0("\243\166\203\200\114\253", "\110\190\199\165\189\19\145\61"))) or (v84 < 30) or (v13:BuffUp(v75.EbonMightSelfBuff) and (v69 == LUAOBFUSACTOR_DECRYPT_STR_0("\247\234\121\253\138\203", "\167\186\139\23\136\235"))))) then
					local v162 = 0;
					while true do
						if ((v162 == 1) or (1442 > 2640)) then
							ShouldReturn = v79.HandleBottomTrinket(v78, v33, 40, nil);
							if ((136 < 3668) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
						if ((v162 == 0) or (1784 > 4781)) then
							ShouldReturn = v79.HandleTopTrinket(v78, v33, 40, nil);
							if ((4585 > 3298) and ShouldReturn) then
								return ShouldReturn;
							end
							v162 = 1;
						end
					end
				end
				v114 = v79.HandleDPSPotion((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\46\176\133\29\21\167\137\1\45\186\157\3\30\145\141\15\15\179\142", "\109\122\213\232")]:AuraActiveCount() > 0) or (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\204\229\167\49\250\255\173\54\203\248\172\35", "\80\142\151\194")]:CooldownRemains() > 30) or (v84 < 30));
				v113 = 5;
			end
			if ((v113 == 0) or (1664 > 1698)) then
				if (v56 or v55 or (3427 < 2849)) then
					local v163 = 0;
					local v164;
					while true do
						if ((3616 <= 4429) and (v163 == 0)) then
							v164 = v95();
							if ((3988 >= 66) and v164) then
								return v164;
							end
							break;
						end
					end
				end
				if (v59 or (862 > 4644)) then
					local v165 = 0;
					while true do
						if ((1221 == 1221) and (v165 == 0)) then
							ShouldReturn = v79.HandleAfflicted(v75.Expunge, v77.ExpungeMouseover, 40);
							if (ShouldReturn or (45 > 1271)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if ((3877 > 1530) and v60) then
					local v166 = 0;
					while true do
						if ((v166 == 0) or (4798 == 1255)) then
							ShouldReturn = v79.HandleIncorporeal(v75.Sleepwalk, v77.SleepwalkMouseover, 30, true);
							if (ShouldReturn or (2541 > 2860)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v113 = 1;
			end
			if ((v113 == 5) or (2902 > 3629)) then
				if ((427 < 3468) and v114) then
					return v114;
				end
				if ((4190 >= 2804) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\47\207\97\69\13\193\81\64\2\203\114", "\44\99\166\23")]:IsReady() and v13:BuffUp(v75.LeapingFlamesBuff) and (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\90\254\59\51\17\182\121\246\61\62\23\161\126\226\47\48", "\196\28\151\73\86\83")]:AuraActiveCount() > 0)) then
					if ((2086 == 2086) and v23(v75.LivingFlame, nil, nil, not v16:IsSpellInRange(v75.LivingFlame))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\10\63\25\140\95\39\112\255\2\36\21\194\85\25\127\253\67\123\66", "\22\147\99\73\112\226\56\120");
					end
				end
				if ((4148 > 2733) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\141\123\240\244\155\189\121", "\237\216\21\130\149")]:IsReady()) then
					if ((3054 >= 1605) and v23(v75.Unravel, nil, nil, not v16:IsSpellInRange(v75.Unravel))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\64\77\94\166\204\82\194\67\94\86\190\137\12", "\62\226\46\63\63\208\169");
					end
				end
				v113 = 6;
			end
			if ((1044 < 1519) and (2 == v113)) then
				if ((1707 <= 4200) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\226\229\14\242\30\196\230\19\200\25\204\235\24\232", "\122\173\135\125\155")]:IsCastable() and (v13:HealthPercentage() < v68) and v67 and v13:BuffDown(v75.ObsidianScales)) then
					if ((580 == 580) and v23(v75.ObsidianScales, nil, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\139\195\19\176\59\56\201\138\210\3\184\51\52\219\196\204\1\176\49\113\158", "\168\228\161\96\217\95\81");
					end
				end
				if ((601 <= 999) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\254\211\33\82\2\94\220\217\58", "\55\187\177\78\60\79")]:IsReady() and v13:BuffRefreshable(v75.EbonMightSelfBuff, 4)) then
					if ((3970 == 3970) and v23(v75.EbonMight, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\40\204\80\229\121\194\137\42\198\75\171\75\206\137\35\142\7", "\224\77\174\63\139\38\175");
					end
				end
				if ((v33 and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\176\72\72\26\140\68\107\45\133\77\93\61", "\78\228\33\56")]:IsCastable() and (v75[LUAOBFUSACTOR_DECRYPT_STR_0("\232\119\160\6\167\220\123\179\23\141", "\229\174\30\210\99")]:CooldownRemains() < v13:GCD())) or (98 == 208)) then
					if ((2006 <= 3914) and v23(v75.TipTheScales, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\15\228\150\110\249\53\60\36\254\133\80\225\56\42\91\224\135\88\227\125\104\75", "\89\123\141\230\49\141\93");
					end
				end
				v113 = 3;
			end
			if ((v113 == 1) or (3101 <= 2971)) then
				if (v72 or (2073 <= 671)) then
					if ((3305 > 95) and ((GetTime() - v30) > v73)) then
						if ((2727 == 2727) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\117\121\101\25\97", "\45\61\22\19\124\19\203")]:IsReady()) then
							if (v27(v75.Hover) or (2970 >= 4072)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\201\29\27\240\16\48\180\192\27\3\181\80", "\217\161\114\109\149\98\16");
							end
						end
					end
				end
				if ((3881 > 814) and v34 and v13:AffectingCombat()) then
					local v167 = 0;
					local v168;
					while true do
						if ((0 == v167) or (4932 < 4868)) then
							v168 = v97();
							if ((3667 <= 4802) and v168) then
								return v168;
							end
							break;
						end
					end
				end
				if ((1260 >= 858) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\32\37\54\121\171\125\28\39\26\112\189\110\23", "\20\114\64\88\28\220")]:IsCastable() and (v13:HealthPercentage() < v66) and v65) then
					if (v23(v75.RenewingBlaze, nil, nil) or (3911 == 4700)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\4\220\177\239\217\179\54\35\222\181\226\213\253\60\0\219\186\184\134", "\221\81\97\178\212\152\176");
					end
				end
				v113 = 2;
			end
		end
	end
	local function v99()
		local v115 = 0;
		while true do
			if ((3000 < 4194) and (v115 == 3)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\49\177\200\127\161\208\149", "\230\77\84\197\188\22\207\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\207\17\212\248\141\175\228\16\244\22\212\253\143\164\216\5", "\85\153\116\166\156\236\193\144")] or 0;
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\229\89\167\237\14\163\243", "\96\196\128\45\211\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\16\128\126\77\211\163\176\250\57\130\104\76\221\162\156\232", "\184\85\237\27\63\178\207\212")] or 0;
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\92\29\75\1\87\14\76", "\63\104\57\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\62\148\161\118\10\132\173\69\7\148", "\36\107\231\196")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\176\182\147\84\187\165\148", "\231\61\213\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\60\190\56\91\12\172\49\122\7\170\13\124\29\164\50\125", "\19\105\205\93")];
				v115 = 4;
			end
			if ((651 < 4442) and (v115 == 9)) then
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\218\183\147\218\212\216\176", "\179\186\191\195\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\44\29\204\246\41\29\246", "\132\153\95\120")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\183\26\57\254\212\167\162", "\192\209\210\110\77\151\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\12\52\236\237\240\233\14\39", "\164\128\99\66\137\159")] or 0;
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\51\140\253\170\9\135\238\173", "\222\96\233\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\149\178\169\27\155\255\249\189\182\146\12\137\244\245", "\144\217\211\199\127\232\147")] or "";
				break;
			end
			if ((v115 == 0) or (195 >= 1804)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\90\215\239\10\81\196\232", "\155\99\63\163")][LUAOBFUSACTOR_DECRYPT_STR_0("\160\221\168\158\173\129\144\216\175\138\138\135\131\221\164\158\140\151\131\214\164", "\228\226\177\193\237\217")] or "";
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\7\181\55\242\61\190\36\245", "\134\84\208\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\49\160\143\79\7\169\148\85\29\171\181\95\18\160\131\79\33\169\128\78\22\191\142", "\60\115\204\230")] or 0;
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\63\255\100\238\52\236\99", "\16\135\90\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\120\15\32\90\81\106\93\122\1\0\77\85\116\81\103\40\50\67\81", "\24\52\20\102\83\46\52")] or "0";
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\42\53\48\6\202\40\50", "\111\164\79\65\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\214\150\204\45\239\233\223\174\223\41\227\197\236\144\223\41\239", "\138\166\185\227\190\78")] or "";
				v115 = 1;
			end
			if ((v115 == 5) or (1382 > 2216)) then
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\173\179\247\25\78\175\180", "\112\32\200\199\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\8\89\79\168\198\167\0\57\86\90\171", "\66\76\48\60\216\163\203")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\131\109\231\86\192\35\169", "\68\218\230\25\147\63\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\57\86\100\179\172\38\71\68\165\185\37\93\73", "\214\205\74\51\44")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\73\246\232\126\244\75\241", "\23\154\44\130\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\163\172\162\34\27\2\178\162\160\51\59\33", "\115\113\198\205\206\86")] or 0;
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\82\234\78\141\89\249\73", "\58\228\55\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\136\222\42\48\168\20\178\143\220\39\63\185\48\176", "\85\212\233\176\78\92\205")];
				v115 = 6;
			end
			if ((v115 == 6) or (2861 == 2459)) then
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\93\156\246\67\86\143\241", "\130\42\56\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\194\180\42\231\76\58\195\187\39\236\82\47\229\167\33\226\76", "\95\138\213\68\131\32")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\45\181\87\127\36\47\178", "\22\74\72\193\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\119\240\93\62\107\241\72\56\78\237\76\36\74\240\77\34", "\56\76\25\132")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\109\196\191\50\198\80\198\184", "\175\62\161\203\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\21\211\215\22\39\46\200\211\7\26\50\209\218\36\61\53\201\198\31\60\47\201", "\85\92\189\163\115")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\169\36\44\32\162\55\43", "\88\73\204\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\141\4\67\59\200\59\147\4\114\33\200\43\144\24\73\37\222", "\186\78\227\112\38\73")] or 0;
				v115 = 7;
			end
			if ((1903 < 4021) and (v115 == 7)) then
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\207\82\233\65\90\116\251\68", "\26\156\55\157\53\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\185\203\19\246\168\64\158\221\5\202\177\94\139\234\25\216\170", "\48\236\184\118\185\216")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\184\67\36\198\58\226\174", "\84\133\221\55\80\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\244\33\148\194\82\184\240\45\168\192\126\177\230\62\163", "\60\221\135\68\198\167")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\184\236\151\75\215\233\174", "\185\142\221\152\227\34")][LUAOBFUSACTOR_DECRYPT_STR_0("\106\192\89\255\84\58\249\95\231\91\251\89\54\223\104", "\151\56\165\55\154\35\83")] or 0;
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\147\70\17\250\169\77\2\253", "\142\192\35\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\227\102\44\140\229\159\165\18\223\116\39\144\228\141\160\19\197", "\118\182\21\73\195\135\236\204")];
				v115 = 8;
			end
			if ((8 == v115) or (2270 >= 4130)) then
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\57\14\84\13\3\250\27", "\157\104\92\122\32\100\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\140\164\220\195\57\46\140\165\144\165\206\198\56\52\165\155", "\203\195\198\175\170\93\71\237")] or 0;
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\78\42\193\88\31\251\61", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\80\250\193\162\31\75\118\116\205\203\173\24\118\106\115\239\193", "\25\18\136\164\195\107\35")] or "";
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\189\91\123\178\198\171", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\255\46\242\7\202\135\63\216\34\215\13\239\137\36\252", "\226\77\140\75\186\104\188")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\203\196\43\70\183\201\195", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\206\115\54\187\89\125\21\179\212\102", "\70\216\189\22\98\210\52\24")];
				v115 = 9;
			end
			if ((2593 <= 3958) and (v115 == 1)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\113\209\35\91\45\30\216", "\121\171\20\165\87\50\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\55\172\36\186\7\233\62\148\55\190\11\197\22\184\59\188", "\98\166\88\217\86\217")] or "";
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\243\109\21\143\210\241\229", "\188\150\150\25\97\230")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\155\90\17\15\228\223\135\92\7\57\254\219\142\90", "\141\186\233\63\98\108")] or "";
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\239\56\162\44\255\237\63", "\69\145\138\76\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\64\221\140\154\188\31\117\193\138\140\145\23\125\202\216", "\118\16\175\233\233\223")] or "";
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\129\33\175\231\133\122\152", "\29\235\228\85\219\142\235")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\198\191\206\116\71\34\92\62\209\148\220\122\75\117", "\50\93\180\218\189\23\46\71")] or "";
				v115 = 2;
			end
			if ((1176 == 1176) and (v115 == 2)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\161\79\88\77\210\79\205", "\40\190\196\59\44\36\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\12\87\217\167\249\116\8\50\70\217\154\251\112\8\111", "\109\92\37\188\212\154\29")] or "";
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\234\176\215\56\84\3\252", "\58\100\143\196\163\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\42\80\38\176\60\64\224\0\25\71\13\162\50\76\177", "\110\122\34\67\195\95\41\133")] or "";
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\180\79\94\223\123\182\72", "\182\21\209\59\42")][LUAOBFUSACTOR_DECRYPT_STR_0("\129\82\215\25\32\176\163\114\200\31\51\191\180\82\240\14\32\185\178", "\222\215\55\165\125\65")] or "";
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\212\210\14\251\207\234\89", "\42\76\177\166\122\146\161\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\128\135\0\220\120\122\161\168\9\193\106\101\170\135\48\221\120\113\160", "\22\197\234\101\174\25")] or "";
				v115 = 3;
			end
			if ((v115 == 4) or (3062 == 1818)) then
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\154\13\202\149\54\167\15\205", "\95\201\104\190\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\206\192\194\166\197\198\254\160\223\200\193\161\229\192\195\170", "\174\207\171\161")] or "";
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\251\25\231\241\217\234\237", "\183\141\158\109\147\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\12\231\0\37\7\225\60\35\29\239\3\34\33\214", "\108\76\105\134")] or 0;
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\216\192\165\245\199\229\194\162", "\174\139\165\209\129")][LUAOBFUSACTOR_DECRYPT_STR_0("\150\160\231\227\202\6\99\107\170\189\229\238\192\55\120\125\129\161\237\207\220\6", "\24\195\211\130\161\166\99\16")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\6\253\56\90\24\65\16", "\118\38\99\137\76\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\47\22\2\12\44\217\35\7\7\15\38\238", "\64\157\70\101\114\105")];
				v115 = 5;
			end
		end
	end
	local function v100()
		local v116 = 0;
		while true do
			if ((v116 == 0) or (3717 < 3149)) then
				v99();
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\32\57\47\217\64\17", "\36\152\79\94\72\181\37\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\216\215\68", "\95\183\184\39")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\129\48\224\33\88\133\17", "\98\213\95\135\70\52\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\172\204", "\52\158\195\169\23")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\78\179\53\115\138\48\104", "\235\26\220\82\20\230\85\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\165\250", "\20\232\193\137\162")];
				v116 = 1;
			end
			if ((3195 < 3730) and (v116 == 2)) then
				if ((2797 <= 3980) and not v13:IsMoving()) then
					v30 = GetTime();
				end
				Enemies25y = v13:GetEnemiesInRange(25);
				Enemies8ySplash = v16:GetEnemiesInSplashRange(8);
				if ((1944 <= 2368) and v32) then
					EnemiesCount8ySplash = v16:GetEnemiesInSplashRangeCount(8);
				else
					EnemiesCount8ySplash = 1;
				end
				v116 = 3;
			end
			if ((1709 < 4248) and (v116 == 3)) then
				if (v79.TargetIsValid() or v13:AffectingCombat() or (3970 == 3202)) then
					local v169 = 0;
					while true do
						if ((v169 == 1) or (3918 >= 4397)) then
							if ((v84 == 11111) or (780 == 3185)) then
								v84 = v10.FightRemains(Enemies25y, false);
							end
							break;
						end
						if ((v169 == 0) or (3202 >= 4075)) then
							v83 = v10.BossFightRemains();
							v84 = v83;
							v169 = 1;
						end
					end
				end
				if ((64 == 64) and v34 and v31 and not v13:AffectingCombat()) then
					local v170 = 0;
					local v171;
					while true do
						if ((2202 >= 694) and (v170 == 0)) then
							v171 = v97();
							if ((3706 <= 3900) and v171) then
								return v171;
							end
							break;
						end
					end
				end
				if ((2890 > 2617) and v72 and (v31 or v13:AffectingCombat())) then
					if (((GetTime() - v30) > v73) or (3355 > 4385)) then
						if ((v75[LUAOBFUSACTOR_DECRYPT_STR_0("\217\42\91\234\203", "\185\145\69\45\143")]:IsReady() and v13:BuffDown(v75.Hover)) or (3067 <= 2195)) then
							if ((3025 >= 2813) and v27(v75.Hover)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\130\16\15\163\206\202\18\24\175\210\202\77", "\188\234\127\121\198");
							end
						end
					end
				end
				if ((2412 >= 356) and (v31 or v13:AffectingCombat())) then
					local v172 = 0;
					while true do
						if ((2070 > 1171) and (v172 == 0)) then
							ShouldReturn = v96();
							if (ShouldReturn or (4108 < 3934)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				v116 = 4;
			end
			if ((3499 >= 3439) and (v116 == 1)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\208\194\161\235\137\4", "\17\66\191\165\198\135\236\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\170\175\31", "\177\111\207\206\115\159\136\140")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\49\134\23\19\216\74\76", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\50\254\2\253\58", "\86\163\91\141\114\152")];
				if ((876 < 3303) and v13:IsDeadOrGhost()) then
					return;
				end
				if ((2922 <= 3562) and v55 and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\118\19\100\102\52\84\14", "\90\51\107\20\19")]:IsReady() and v79.DispellableFriendlyUnit()) then
					local v173 = 0;
					local v174;
					local v175;
					while true do
						if ((2619 >= 1322) and (v173 == 0)) then
							v174 = v55;
							v175 = v79.FocusUnit(v174, v77, 30);
							v173 = 1;
						end
						if ((4133 >= 2404) and (v173 == 1)) then
							if (v175 or (1433 == 2686)) then
								return v175 .. LUAOBFUSACTOR_DECRYPT_STR_0("\205\246\138\253\125\169\249\150\255\56\129\252\140\225\58", "\93\237\144\229\143");
							end
							break;
						end
					end
				elseif ((v91() and (v17:BuffRemains(v75.SourceofMagicBuff) < 300) and (v39 == LUAOBFUSACTOR_DECRYPT_STR_0("\52\227\228\22", "\38\117\150\144\121\107")) and (v91():BuffRemains(v75.SourceofMagicBuff) < 300) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\30\180\251\40\46\190\225\60\0\186\233\51\46", "\90\77\219\142")]:IsCastable()) or (4123 == 4457)) then
					local v182 = 0;
					while true do
						if ((v182 == 0) or (3972 <= 205)) then
							v90 = v91():GUID();
							ShouldReturn = v79.FocusSpecifiedUnit(v91(), 25);
							v182 = 1;
						end
						if ((1 == v182) or (3766 < 1004)) then
							if ((1784 < 2184) and ShouldReturn) then
								return ShouldReturn .. LUAOBFUSACTOR_DECRYPT_STR_0("\166\2\46\43\12\52\117\203", "\26\134\100\65\89\44\103");
							end
							break;
						end
					end
				elseif ((v93() and (v36 == LUAOBFUSACTOR_DECRYPT_STR_0("\208\246\36\44", "\196\145\131\80\67")) and (v93():BuffStack(v75.BlisteringScalesBuff) <= v37) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\60\188\15\27\12\237\12\185\8\15\43\235\31\188\3\27", "\136\126\208\102\104\120")]:IsCastable()) or (1649 > 4231)) then
					local v184 = 0;
					while true do
						if ((3193 == 3193) and (v184 == 1)) then
							if (ShouldReturn or (3495 > 4306)) then
								return ShouldReturn .. LUAOBFUSACTOR_DECRYPT_STR_0("\56\140\193\81\239\112\49\88\107\158\203\81\166\92\58", "\49\24\234\174\35\207\50\93");
							end
							break;
						end
						if ((4001 > 3798) and (v184 == 0)) then
							v92 = v93():GUID();
							ShouldReturn = v79.FocusSpecifiedUnit(v93(), 25);
							v184 = 1;
						end
					end
				elseif ((v34 and (v46 == LUAOBFUSACTOR_DECRYPT_STR_0("\41\228\248\154\104\3\252\248", "\17\108\146\157\232")) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\125\198\6\233\46\166\95\230\25\239\61\169\72\198", "\200\43\163\116\141\79")]:IsReady()) or (4688 <= 4499)) then
					local v195 = 0;
					while true do
						if ((v195 == 0) or (1567 <= 319)) then
							ShouldReturn = v79.FocusUnit(false, nil, nil, nil);
							if (ShouldReturn or (4583 == 3761)) then
								return ShouldReturn .. LUAOBFUSACTOR_DECRYPT_STR_0("\255\48\50\145\240\194\230\173\50\60\141\164\180\198\178\52\47\130\179\241", "\131\223\86\93\227\208\148");
							end
							break;
						end
					end
				elseif ((3454 > 1580) and v34 and (v47 == LUAOBFUSACTOR_DECRYPT_STR_0("\198\83\179\164\4\186\237\64", "\213\131\37\214\214\125")) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\3\38\32\173\224\42\47\7\179\238\53\56\42\178", "\129\70\75\69\223")]:IsReady()) then
					local v196 = 0;
					while true do
						if ((v196 == 0) or (1607 == 20)) then
							ShouldReturn = v79.FocusUnit(false, nil, nil, nil);
							if (ShouldReturn or (962 >= 4666)) then
								return ShouldReturn .. LUAOBFUSACTOR_DECRYPT_STR_0("\6\205\252\251\60\202\75\206\225\232\112\235\6\233\255\230\111\252\73\198", "\143\38\171\147\137\28");
							end
							break;
						end
					end
				elseif ((v34 and (v46 == LUAOBFUSACTOR_DECRYPT_STR_0("\254\141\173\179\55\226\218\219", "\180\176\226\217\147\99\131")) and v75[LUAOBFUSACTOR_DECRYPT_STR_0("\229\188\61\3\210\183\59\34\222\187\61\6\208\188", "\103\179\217\79")]:IsReady()) or (1896 == 1708)) then
					local v197 = 0;
					local v198;
					local v199;
					while true do
						if ((3985 >= 1284) and (v197 == 0)) then
							v198 = v79.GetFocusUnit(false, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\98\146\61\249\100\190", "\195\42\215\124\181\33\236")) or v13;
							v199 = v79.GetFocusUnit(false, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\41\120\26\31\2\221\63", "\152\109\57\87\94\69")) or v13;
							v197 = 1;
						end
						if ((v197 == 1) or (1987 == 545)) then
							if ((v198:HealthPercentage() < v199:HealthPercentage()) or (4896 < 1261)) then
								local v204 = 0;
								while true do
									if ((23 < 3610) and (v204 == 0)) then
										ShouldReturn = v79.FocusUnit(false, nil, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\209\242\43\143\155\224", "\200\153\183\106\195\222\178\52"));
										if (ShouldReturn or (3911 < 2578)) then
											return ShouldReturn .. LUAOBFUSACTOR_DECRYPT_STR_0("\114\229\135\47\9\114\55\226\132\52\71\93\114\203\141\60\69\95\32", "\58\82\131\232\93\41");
										end
										break;
									end
								end
							elseif ((v199:HealthPercentage() < v198:HealthPercentage()) or (4238 < 87)) then
								local v205 = 0;
								while true do
									if ((2538 == 2538) and (v205 == 0)) then
										ShouldReturn = v79.FocusUnit(false, nil, nil, LUAOBFUSACTOR_DECRYPT_STR_0("\167\118\253\52\122\26\177", "\95\227\55\176\117\61"));
										if ((4122 == 4122) and ShouldReturn) then
											return ShouldReturn .. LUAOBFUSACTOR_DECRYPT_STR_0("\88\120\44\89\235\48\123\34\71\162\22\121\99\111\170\21\127\36\78\185", "\203\120\30\67\43");
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v116 = 2;
			end
			if ((v116 == 4) or (2371 > 2654)) then
				if (v79.TargetIsValid() or (3466 > 4520)) then
					local v176 = 0;
					while true do
						if ((v176 == 2) or (951 >= 1027)) then
							if (v13:AffectingCombat() or v31 or (1369 > 2250)) then
								local v185 = 0;
								local v186;
								while true do
									if ((v185 == 0) or (937 > 3786)) then
										v186 = v98();
										if (v186 or (901 > 4218)) then
											return v186;
										end
										break;
									end
								end
							end
							if ((4779 > 4047) and v13:IsChanneling(v75.FireBreath)) then
								local v187 = 0;
								local v188;
								while true do
									if ((4050 > 1373) and (0 == v187)) then
										v188 = GetTime() - v13:CastStart();
										if ((v188 >= v13:EmpowerCastTime(v86)) or (1037 > 4390)) then
											local v200 = 0;
											while true do
												if ((1407 <= 1919) and (v200 == 0)) then
													v10[LUAOBFUSACTOR_DECRYPT_STR_0("\218\240\187\186\59\59\235\244\187\183\15\45\204", "\94\159\128\210\217\104")] = 1000;
													return LUAOBFUSACTOR_DECRYPT_STR_0("\99\237\9\175\79\118\247\125\16\223\15\173\90\63\219\104\85\248\18\183", "\26\48\153\102\223\63\31\153");
												end
											end
										end
										break;
									end
								end
							end
							v176 = 3;
						end
						if ((2526 >= 1717) and (v176 == 0)) then
							if ((not v13:AffectingCombat() and not v13:IsCasting() and v31) or (3620 <= 2094)) then
								local v189 = 0;
								local v190;
								while true do
									if ((v189 == 0) or (1723 >= 2447)) then
										v190 = v94();
										if (v190 or (1199 > 3543)) then
											return v190;
										end
										break;
									end
								end
							end
							if ((1617 < 3271) and not v13:IsCasting() and not v13:IsChanneling()) then
								local v191 = 0;
								local v192;
								while true do
									if ((3085 > 1166) and (v191 == 0)) then
										v192 = v79.Interrupt(v75.Quell, 10, true);
										if ((4493 >= 3603) and v192) then
											return v192;
										end
										v191 = 1;
									end
									if ((2843 <= 2975) and (v191 == 2)) then
										v192 = v79.Interrupt(v75.Quell, 10, true, v14, v77.QuellMouseover);
										if (v192 or (1989 <= 174)) then
											return v192;
										end
										break;
									end
									if ((1 == v191) or (209 > 2153)) then
										v192 = v79.InterruptWithStun(v75.TailSwipe, 8);
										if (v192 or (2020 == 1974)) then
											return v192;
										end
										v191 = 2;
									end
								end
							end
							v176 = 1;
						end
						if ((v176 == 1) or (1347 == 1360)) then
							if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\16\55\18\143\44\58\0\151\55\60\22", "\227\88\82\115")]:IsReady() and v57 and (v13:HealthPercentage() <= v58)) or (4461 == 3572)) then
								if (v27(v77.Healthstone, nil, nil, true) or (2872 == 318)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\75\26\187\171\22\123\80\11\181\169\7\51\71\26\188\162\12\96\74\9\191\231\81", "\19\35\127\218\199\98");
								end
							end
							if ((568 == 568) and v51 and (v13:HealthPercentage() <= v53)) then
								if ((4200 == 4200) and (v52 == LUAOBFUSACTOR_DECRYPT_STR_0("\46\254\12\240\25\232\2\235\18\252\74\202\25\250\6\235\18\252\74\210\19\239\3\237\18", "\130\124\155\106"))) then
									if (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\231\206\240\189\166\229\116\182\219\204\222\170\162\250\117\177\210\251\249\187\170\249\114", "\223\181\171\150\207\195\150\28")]:IsReady() or (4285 < 1369)) then
										if (v27(v77.RefreshingHealingPotion, nil, nil, true) or (3520 > 4910)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\94\63\229\188\12\95\50\234\160\14\12\50\230\175\5\69\52\228\238\25\67\46\234\161\7\12\62\230\168\12\66\41\234\184\12\12\110", "\105\44\90\131\206");
										end
									end
								end
							end
							v176 = 2;
						end
						if ((2842 <= 4353) and (v176 == 3)) then
							if (v13:IsChanneling(v75.Upheaval) or (3751 < 1643)) then
								local v193 = 0;
								local v194;
								while true do
									if ((v193 == 0) or (4911 == 3534)) then
										v194 = GetTime() - v13:CastStart();
										if ((3001 > 16) and (v194 >= v13:EmpowerCastTime(v85))) then
											local v201 = 0;
											while true do
												if ((2875 <= 3255) and (v201 == 0)) then
													v10[LUAOBFUSACTOR_DECRYPT_STR_0("\39\80\228\240\49\69\249\231\11\78\234\224\49", "\147\98\32\141")] = 1001;
													return LUAOBFUSACTOR_DECRYPT_STR_0("\43\87\236\218\22\95\69\31\3\214\218\14\83\74\14\66\239", "\43\120\35\131\170\102\54");
												end
											end
										end
										break;
									end
								end
							end
							if ((368 < 4254) and v24(v75.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\99\39\174\130", "\228\52\102\231\214\197\208"))) then
								return "Wait/Pool";
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v101()
		local v117 = 0;
		while true do
			if ((v117 == 1) or (4841 <= 2203)) then
				v79[LUAOBFUSACTOR_DECRYPT_STR_0("\115\5\45\79\119\216\46\86\14\50\90\86\209\32\66\10\56\76", "\66\55\108\94\63\18\180")] = v79[LUAOBFUSACTOR_DECRYPT_STR_0("\48\132\150\39\34\85\24\140\135\59\34\105\27\132\150\56\41\125\17\143\144\49\33\74", "\57\116\237\229\87\71")];
				v22.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\139\164\234\234\114\224\83\171\165\228\232\121\174\98\188\190\230\226\101\174\69\179\241\200\247\126\237\7\136\190\226\234\92\160", "\39\202\209\141\135\23\142"));
				v117 = 2;
			end
			if ((4661 > 616) and (v117 == 0)) then
				v75[LUAOBFUSACTOR_DECRYPT_STR_0("\56\233\103\207\200\153\28\215\10\232\81\207\232\158\31\208", "\182\126\128\21\170\138\235\121")]:RegisterAuraTracking();
				v75[LUAOBFUSACTOR_DECRYPT_STR_0("\191\223\56\246\137\1\49\10\188\213\32\232\130\55\53\4\158\220\51", "\102\235\186\85\134\230\115\80")]:RegisterAuraTracking();
				v117 = 1;
			end
			if ((v117 == 2) or (1943 == 2712)) then
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\222\38\14\7\55\246\235\50\29\3\61\246\191\22\31\5\57\253\237\115\49\74\36\184\174\99\71\88\124\168\175\115\43\19\114\218\240\60\4\33", "\152\159\83\105\106\82"));
				break;
			end
		end
	end
	v22.SetAPL(1473, v100, v101);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\164\214\88\234\246\121\151\201\90\247\219\99\160\211\86\255\204\82\149\199\69\251\198\82\207\202\68\243", "\60\225\166\49\146\169")]();

