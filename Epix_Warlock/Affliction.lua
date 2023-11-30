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
		if ((2481 <= 3279) and (v5 == 1)) then
			return v6(...);
		end
		if ((v5 == 0) or (1063 <= 877)) then
			v6 = v0[v4];
			if ((2314 == 2314) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\140\198\12\221\204\216\46\217\154\193\24\221\202\216\49\239\180\201\80\221\214\218", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\141\43\19\35\96", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\107\210\35\239\69\87\243\253\84", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\204\82\179", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\156\124\110\47\22\96", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = EpicLib;
	local v21 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\107\75\14\33", "\69\41\34\96")];
	local v22 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\145\194\212\24\13", "\75\220\163\183\106\98")];
	local v23 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\35\181\174\24\247", "\185\98\218\235\87")];
	local v24 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\232\24\52\201\240", "\202\171\92\71\134\190")];
	local v25 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\10\192\63\156", "\232\73\161\76")];
	local v26 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\139\203\71\78\13", "\126\219\185\34\61")];
	local v27 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\47\193\83\127\113\121\224", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\255\47\217\1\161\61\194", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\229\63", "\199\235\144\82\61\152")];
	local v28 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\36\25\180\38\8\24\170", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\66\117\6\160\17\201\81", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\33\47\140", "\156\168\78\64\224\212\121")];
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
	local function v48()
		local v95 = 0;
		while true do
			if ((924 >= 477) and (3 == v95)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\151\252\213\199\40\220\167\110\170\198\201\208\63\221\186\113\178\246", "\30\222\146\161\162\90\174\210")] or 0;
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\53\126\241\85\78\104\37\103", "\32\56\64\19\156\58")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\87\89\246\69\135\132\31\113\102", "\107\57\54\43\157\21\230\231")] or 0;
				v95 = 4;
			end
			if ((1813 <= 3778) and (v95 == 4)) then
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\142\5\225\176\210\200\200", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\10\166\141\73\215\120\113\50\187", "\24\92\207\225\44\131\25")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\214\172\88\18\115\76\192", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\209\33\66\169\214\45\127\180\215\39\89\177\216\50\69\169\192", "\44\221\185\64")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\226\92\75\122\15\224\91", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\157\73\62\54\32\63\138\93\33\48\40\61\175\78\54", "\81\206\60\83\91\79")];
				break;
			end
			if ((4150 == 4150) and (v95 == 0)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\235\177\218\14\224\162\221", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\59\90\12\55\87\246\93\45\75\43", "\152\54\72\63\88\69\62")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\193\250\72\221\202\233\79", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\77\0\27\38\238\27\89\82\22", "\114\56\62\101\73\71\141")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\236\207\208\177\231\220\215", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\231\245\52\154\163\255\7\219\232\54\130\169\234\2\221\232", "\107\178\134\81\210\198\158")];
				v95 = 1;
			end
			if ((432 <= 3007) and (v95 == 1)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\10\131\251\195\205\8\178\248\222\202\0\140\217\203\206\10", "\170\163\111\226\151")] or 0;
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\41\204\30\238\143\43\253\29\243\136\35\195\58\215", "\135\225\76\173\114")] or 0;
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\206\21\216\125\247\161\201\24\227\108\249\163\216", "\150\205\189\112\144\24")];
				v95 = 2;
			end
			if ((v95 == 2) or (408 > 2721)) then
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\252\26\6\223\162\116\149\192\16\9\214\158\76", "\230\180\127\103\179\214\28")] or 0;
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\5\65\164\249\218\188\189\38\77\162\227\252\184\188\31", "\175\204\201\113\36\214\139")] or 0;
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\118\173\133\33\191\109\169\148\28\163\116\160\183\59\164\108\188\140\58\190\108", "\83\205\24\217\224")] or 0;
				v95 = 3;
			end
		end
	end
	local v49 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\109\164\221\127\32\205\94", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\157\52\123\12\61\244\225\189", "\143\216\66\30\126\68\155")];
	local v50 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\157\201\31\199\202\160\220", "\129\202\168\109\171\165\195\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\3\94\49\212\215\23\242\43\87\57", "\134\66\56\87\184\190\116")];
	local v51 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\11\48\27\183\22\232\42", "\85\92\81\105\219\121\139\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\220\181\86\73\117\220\233\186\95\75", "\191\157\211\48\37\28")];
	local v52 = {v51[LUAOBFUSACTOR_DECRYPT_STR_0("\252\16\250\22\47\205\26\240\63\50\214\19\248\27\54\208\29\241", "\90\191\127\148\124")]:ID(),v51[LUAOBFUSACTOR_DECRYPT_STR_0("\92\130\61\7\125\149\47\3\125\174\32\1\119\140\43\5\107\164\33\19\125\159", "\119\24\231\78")]:ID(),v51[LUAOBFUSACTOR_DECRYPT_STR_0("\160\40\169\69\206\82\20\142\34\182\94\212\69\34\151\35\166\75\208\76\20\144", "\113\226\77\197\42\188\32")]:ID()};
	local v53 = v13:GetEquipment();
	local v54 = (v53[13] and v19(v53[13])) or v19(0);
	local v55 = (v53[14] and v19(v53[14])) or v19(0);
	local v56 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\13\23\230\185\53\21\255", "\213\90\118\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\122\40\178\90\68\88\58\189\89\67", "\45\59\78\212\54")];
	local v57, v58, v59;
	local v60, v61, v62, v63, v64, v65, v66;
	local v67;
	local v68;
	local v69 = 11111;
	local v70 = 11111;
	v10:RegisterForEvent(function()
		local v96 = 0;
		while true do
			if ((v96 == 1) or (3418 < 2497)) then
				v50[LUAOBFUSACTOR_DECRYPT_STR_0("\102\134\246\35\90", "\77\46\231\131")]:RegisterInFlight();
				break;
			end
			if ((1735 < 2169) and (v96 == 0)) then
				v50[LUAOBFUSACTOR_DECRYPT_STR_0("\35\83\134\143\137\40\142\255\2\68\150\155\146\39\162\254", "\144\112\54\227\235\230\78\205")]:RegisterInFlight();
				v50[LUAOBFUSACTOR_DECRYPT_STR_0("\128\32\14\248\223\76\145\39\3\232", "\59\211\72\111\156\176")]:RegisterInFlight();
				v96 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\150\113\151\114\148\113\146\127\137\100\147\108\150\107\159\110\133\96\151\98", "\32\218\52\214"));
	v50[LUAOBFUSACTOR_DECRYPT_STR_0("\125\18\52\172\254\182\102\85\92\5\36\184\229\185\74\84", "\58\46\119\81\200\145\208\37")]:RegisterInFlight();
	v50[LUAOBFUSACTOR_DECRYPT_STR_0("\24\132\49\168\166\170\20\36\128\36", "\86\75\236\80\204\201\221")]:RegisterInFlight();
	v50[LUAOBFUSACTOR_DECRYPT_STR_0("\90\64\98\139\234", "\235\18\33\23\229\158")]:RegisterInFlight();
	v10:RegisterForEvent(function()
		local v97 = 0;
		while true do
			if ((3890 >= 3262) and (v97 == 1)) then
				v55 = (v53[14] and v19(v53[14])) or v19(0);
				break;
			end
			if ((v97 == 0) or (4356 >= 4649)) then
				v53 = v13:GetEquipment();
				v54 = (v53[13] and v19(v53[13])) or v19(0);
				v97 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\96\150\224\130\117\136\254\158\97\143\232\139\125\159\239\143\111\153\233\154\126\157\228\159", "\219\48\218\161"));
	v10:RegisterForEvent(function()
		local v98 = 0;
		while true do
			if ((3904 == 3904) and (v98 == 0)) then
				v69 = 11111;
				v70 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\212\93\93\112\254\125\223\214\84\91\108\245\112\197\202\80\94\101\254\107", "\128\132\17\28\41\187\47"));
	local function v71(v99)
		local v100 = 0;
		local v101;
		while true do
			if ((v100 == 0) or (2860 >= 3789)) then
				v101 = nil;
				for v143, v144 in pairs(v99) do
					local v145 = 0;
					local v146;
					while true do
						if ((v145 == 0) or (1086 > 4449)) then
							v146 = v144:DebuffRemains(v50.AgonyDebuff) + (99 * v27(v144:DebuffDown(v50.AgonyDebuff)));
							if ((4981 > 546) and ((v101 == nil) or (v146 < v101))) then
								v101 = v146;
							end
							break;
						end
					end
				end
				v100 = 1;
			end
			if ((v100 == 1) or (2366 <= 8)) then
				return v101 or 0;
			end
		end
	end
	local function v72(v102)
		local v103 = 0;
		local v104;
		local v105;
		while true do
			if ((0 == v103) or (2590 == 2864)) then
				if (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\50\55\3\62\82\7\17\9\40\79\20\34\18\51\82\15", "\61\97\82\102\90")]:InFlight() or v13:PrevGCDP(1, v50.SeedofCorruption) or (2624 > 4149)) then
					return false;
				end
				v104 = 0;
				v103 = 1;
			end
			if ((v103 == 1) or (2618 >= 4495)) then
				v105 = 0;
				for v147, v148 in pairs(v102) do
					local v149 = 0;
					while true do
						if ((v149 == 0) or (2485 >= 3131)) then
							v104 = v104 + 1;
							if (v148:DebuffUp(v50.SeedofCorruptionDebuff) or (2804 <= 2785)) then
								v105 = v105 + 1;
							end
							break;
						end
					end
				end
				v103 = 2;
			end
			if ((v103 == 2) or (4571 == 3415)) then
				return v104 == v105;
			end
		end
	end
	local function v73(v106)
		return (v106:DebuffRemains(v50.AgonyDebuff));
	end
	local function v74(v107)
		return (v107:DebuffRemains(v50.CorruptionDebuff));
	end
	local function v75(v108)
		return (v108:DebuffRemains(v50.SiphonLifeDebuff));
	end
	local function v76(v109)
		return (v109:DebuffRemains(v50.AgonyDebuff) < (v109:DebuffRemains(v50.VileTaintDebuff) + v50[LUAOBFUSACTOR_DECRYPT_STR_0("\154\39\167\78\243\86\23\7\184", "\105\204\78\203\43\167\55\126")]:CastTime())) and (v109:DebuffRemains(v50.AgonyDebuff) < 5);
	end
	local function v77(v110)
		return v110:DebuffRemains(v50.AgonyDebuff) < 5;
	end
	local function v78(v111)
		return v111:DebuffRemains(v50.CorruptionDebuff) < 5;
	end
	local function v79(v112)
		return (v112:DebuffRefreshable(v50.SiphonLifeDebuff));
	end
	local function v80(v113)
		return v113:DebuffRemains(v50.AgonyDebuff) < 5;
	end
	local function v81(v114)
		return (v114:DebuffRefreshable(v50.AgonyDebuff));
	end
	local function v82(v115)
		return v115:DebuffRemains(v50.CorruptionDebuff) < 5;
	end
	local function v83(v116)
		return (v116:DebuffRefreshable(v50.CorruptionDebuff));
	end
	local function v84(v117)
		return (v117:DebuffStack(v50.ShadowEmbraceDebuff) < 3) or (v117:DebuffRemains(v50.ShadowEmbraceDebuff) < 3);
	end
	local function v85(v118)
		return v118:DebuffRemains(v50.SiphonLifeDebuff) < 5;
	end
	local function v86()
		local v119 = 0;
		while true do
			if ((v119 == 0) or (4441 > 4787)) then
				if ((1920 == 1920) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\130\184\42\19\28\13\213\84\170\172\16\31\16\22\206\87\172\169\38", "\49\197\202\67\126\115\100\167")]:IsCastable()) then
					if (v26(v50.GrimoireofSacrifice) or (647 == 4477)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\73\214\36\143\95\76\50\100\208\47\191\69\95\52\73\214\47\137\85\91\119\75\205\44\131\89\83\53\90\203\105\210", "\62\87\59\191\73\224\54");
					end
				end
				if ((3819 == 3819) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\207\3\239\199\243", "\169\135\98\154")]:IsReady()) then
					if (v26(v50.Haunt, not v17:IsSpellInRange(v50.Haunt), true) or (1466 > 4360)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\195\118\49\90\233\115\216\217\114\39\91\240\49\201\223\55\114", "\168\171\23\68\52\157\83");
					end
				end
				v119 = 1;
			end
			if ((v119 == 1) or (14 > 994)) then
				if ((401 <= 734) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\193\127\230\185\36\47\139\241\80\243\171\41\36\132\224\120\250\163", "\231\148\17\149\205\69\77")]:IsReady() and not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\179\168\210\247\100\232\129\183", "\159\224\199\167\155\55")]:IsAvailable()) then
					if (v26(v50.UnstableAffliction, not v17:IsSpellInRange(v50.UnstableAffliction), true) or (2167 >= 3426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\253\47\198\246\241\48\215\200\242\58\212\251\250\63\198\254\252\50\146\231\225\57\209\248\254\62\211\227\179\100", "\178\151\147\92");
					end
				end
				if ((764 < 3285) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\191\245\77\54\29\91\88\131\241\88", "\26\236\157\44\82\114\44")]:IsReady()) then
					if ((2499 == 2499) and v26(v50.ShadowBolt, not v17:IsSpellInRange(v50.ShadowBolt), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\38\212\95\37\57\234\89\37\34\193\27\58\60\208\88\37\35\215\90\62\110\132\11", "\59\74\78\181");
					end
				end
				break;
			end
		end
	end
	local function v87()
		local v120 = 0;
		while true do
			if ((v120 == 3) or (692 >= 4933)) then
				v66 = not v65 or (v10[LUAOBFUSACTOR_DECRYPT_STR_0("\229\148\23\236\61\231\89\204\146\34\255\59\226\93", "\56\162\225\118\158\89\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\120\4\210\164\37\212\93\23\197\139\55\202\93\17\201\160\44", "\184\60\101\160\207\66")] > 0) or (v64 and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\2\151\113\177\62\140\88\189\35\137\123\176\48\144\121", "\220\81\226\28")]:CooldownRemains() > 20)) or v13:PowerInfusionUp();
				break;
			end
			if ((v120 == 1) or (3154 <= 2260)) then
				v62 = v17:DebuffUp(v50.VileTaintDebuff) or v17:DebuffUp(v50.PhantomSingularityDebuff) or (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\215\193\62\255\219\49\245\76\245", "\34\129\168\82\154\143\80\156")]:IsAvailable() and not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\181\186\50\5\92\65\132\182\187\61\12\93\66\136\151\187\39\18", "\233\229\210\83\107\40\46")]:IsAvailable());
				v63 = v17:DebuffUp(v50.SoulRotDebuff) or not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\242\77\39\218\55\206\86", "\101\161\34\82\182")]:IsAvailable();
				v120 = 2;
			end
			if ((v120 == 2) or (2637 > 3149)) then
				v64 = v60 and v61 and v63;
				v65 = v50[LUAOBFUSACTOR_DECRYPT_STR_0("\216\5\88\240\207\237\143\29\225\3\94\235\215\227\144\39\252\20", "\78\136\109\57\158\187\130\226")]:IsAvailable() or v50[LUAOBFUSACTOR_DECRYPT_STR_0("\8\54\245\244\10\62\240\255\42", "\145\94\95\153")]:IsAvailable() or v50[LUAOBFUSACTOR_DECRYPT_STR_0("\206\194\1\217\124\184\233", "\215\157\173\116\181\46")]:IsAvailable() or v50[LUAOBFUSACTOR_DECRYPT_STR_0("\6\161\134\255\213\59\144\138\224\209\50\184\138\224\223", "\186\85\212\235\146")]:IsAvailable();
				v120 = 3;
			end
			if ((v120 == 0) or (3992 < 2407)) then
				v60 = v17:DebuffUp(v50.PhantomSingularityDebuff) or not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\21\217\91\84\167\42\220\105\83\189\34\196\86\91\161\44\197\67", "\211\69\177\58\58")]:IsAvailable();
				v61 = v17:DebuffUp(v50.VileTaintDebuff) or not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\129\236\117\240\221\202\190\235\109", "\171\215\133\25\149\137")]:IsAvailable();
				v120 = 1;
			end
		end
	end
	local function v88()
		local v121 = 0;
		while true do
			if ((v121 == 0) or (2902 > 4859)) then
				ShouldReturn = v49.HandleTopTrinket(v52, v31, 40, nil);
				if ((1679 < 4359) and ShouldReturn) then
					return ShouldReturn;
				end
				v121 = 1;
			end
			if ((1913 < 4670) and (1 == v121)) then
				ShouldReturn = v49.HandleBottomTrinket(v52, v31, 40, nil);
				if (ShouldReturn or (2846 < 879)) then
					return ShouldReturn;
				end
				break;
			end
		end
	end
	local function v89()
		local v122 = 0;
		local v123;
		while true do
			if ((4588 == 4588) and (v122 == 0)) then
				v123 = v88();
				if (v123 or (347 == 2065)) then
					return v123;
				end
				v122 = 1;
			end
			if ((v122 == 1) or (1311 > 2697)) then
				if (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\55\208\145\235\239\213\18\193\135\210\228\209\28\222\135\233\249\228\28\209\135\227", "\167\115\181\226\155\138")]:IsEquippedAndReady() or (2717 > 3795)) then
					if (v26(v56.DesperateInvokersCodex, not v17:IsInRange(45)) or (1081 < 391)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\230\39\244\76\126\99\199\246\39\216\85\117\103\201\233\39\245\79\68\114\201\230\39\255\28\114\101\195\239\49\167\14", "\166\130\66\135\60\27\17");
					end
				end
				if (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\103\69\192\127\37\86\79\202\86\56\77\70\194\114\60\75\72\203", "\80\36\42\174\21")]:IsEquippedAndReady() or (121 > 3438)) then
					if ((71 < 1949) and v26(v56.ConjuredChillglobe)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\77\31\57\112\91\2\50\126\113\19\63\115\66\28\48\118\65\18\50\58\71\4\50\119\93\80\99", "\26\46\112\87");
					end
				end
				break;
			end
		end
	end
	local function v90()
		if ((4254 == 4254) and v66) then
			local v130 = 0;
			local v131;
			while true do
				if ((3196 >= 2550) and (v130 == 2)) then
					if ((2456 < 4176) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\52\244\39\49\116\30\242\58\48", "\22\114\157\85\84")]:IsCastable()) then
						if (v26(v50.Fireblood) or (1150 == 3452)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\194\194\1\193\95\250\167\203\207\83\203\90\245\172\132\147", "\200\164\171\115\164\61\150");
						end
					end
					break;
				end
				if ((1875 < 2258) and (v130 == 1)) then
					if ((1173 > 41) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\155\38\185\103\186\173\78\189\183\36", "\212\217\67\203\20\223\223\37")]:IsCastable()) then
						if (v26(v50.Berserking) or (56 >= 3208)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\184\136\186\193\191\159\163\219\180\138\232\221\189\142\172\146\238", "\178\218\237\200");
						end
					end
					if ((4313 > 3373) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\148\185\233\223\178\147\243\194\175", "\176\214\213\134")]:IsCastable()) then
						if (v26(v50.BloodFury) or (4493 == 2225)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\246\161\185\219\172\105\95\225\191\175\148\167\81\90\240\237\224", "\57\148\205\214\180\200\54");
						end
					end
					v130 = 2;
				end
				if ((3104 >= 3092) and (v130 == 0)) then
					v131 = v49.HandleDPSPotion();
					if ((3548 > 3098) and v131) then
						return v131;
					end
					v130 = 1;
				end
			end
		end
	end
	local function v91()
		local v124 = 0;
		local v125;
		while true do
			if ((v124 == 4) or (3252 == 503)) then
				if ((4733 > 2066) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\202\229\163\57\224\219\171\54\235", "\80\142\151\194")]:IsReady() and (v17:DebuffUp(v50.SoulRotDebuff) or not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\48\201\98\64\49\201\99", "\44\99\166\23")]:IsAvailable()) and (v13:BuffStack(v50.InevitableDemiseBuff) > 10)) then
					if ((3549 >= 916) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\120\229\40\63\61\155\112\254\47\51\115\165\115\242\105\100\101", "\196\28\151\73\86\83");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\215\17\40\25\140\107\23\99\255", "\22\147\99\73\112\226\56\120")]:IsReady() and v13:BuffUp(v50.NightfallBuff) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\139\125\227\241\130\175\80\239\247\159\185\118\231", "\237\216\21\130\149")]:IsAvailable()) or (2189 <= 245)) then
					if (v49.CastCycle(v50.DrainSoul, v57, v84, not v17:IsSpellInRange(v50.DrainSoul)) or (1389 > 3925)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\92\94\86\190\246\77\141\91\83\31\177\198\91\194\28\7", "\62\226\46\63\63\208\169");
					end
				end
				if ((4169 >= 3081) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\193\11\84\138\17\62\32\75\233", "\62\133\121\53\227\127\109\79")]:IsReady() and (v13:BuffUp(v50.NightfallBuff))) then
					if ((349 <= 894) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\20\6\51\252\216\145\177\31\1\62\181\215\161\167\80\71\98", "\194\112\116\82\149\182\206");
					end
				end
				if ((731 <= 2978) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\10\189\65\21\207\236\61\54\189\64\19\197\231\30\60\186", "\110\89\200\44\120\160\130")]:IsReady() and ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\70\75\76\68\8\66\190\207\64\67\70\90\62\95", "\45\203\163\43\38\35\42\91")]:Count() == 10) or ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\225\144\209\46\136\167\103\221\144\208\40\130\172\68\215\151", "\52\178\229\188\67\231\201")]:Count() > 3) and (v70 < 10)))) then
					if (v25(v50.SummonSoulkeeper) or (892 > 3892)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\50\78\69\8\200\79\55\51\72\91\1\183\93\44\36\1\3\86", "\67\65\33\48\100\151\60");
					end
				end
				v124 = 5;
			end
			if ((v124 == 5) or (4466 == 900)) then
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\236\238\190\208\252\209\203\167\222\246", "\147\191\135\206\184")]:IsReady() and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\183\33\182\201\215\93\158\141\46\163\229\221\81\167\130\46", "\210\228\72\198\161\184\51")]:AuraActiveCount() < 5)) or (2084 >= 2888)) then
					if ((479 < 1863) and v49.CastCycle(v50.SiphonLife, v57, v85, not v17:IsSpellInRange(v50.SiphonLife))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\64\227\24\124\192\9\69\250\22\118\142\55\70\246\80\32\154", "\174\86\41\147\112\19");
					end
				end
				if (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\127\18\140\2\43\60\30\190\87", "\203\59\96\237\107\69\111\113")]:IsReady() or (2428 >= 4038)) then
					if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or (2878 > 2897)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\32\4\173\232\63\207\196\43\3\160\161\48\255\210\100\69\250", "\183\68\118\204\129\81\144");
					end
				end
				if (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\61\165\113\224\4\149\44\162\124\240", "\226\110\205\16\132\107")]:IsReady() or (2469 > 3676)) then
					if ((233 < 487) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\203\225\221\78\252\252\226\214\77\255\131\225\214\68\171\144\184", "\33\139\163\128\185");
					end
				end
				break;
			end
			if ((2473 >= 201) and (3 == v124)) then
				if ((4120 >= 133) and v31 and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\53\10\95\202\163\124\175\7\13\89\192\160\115\153\3", "\235\102\127\50\167\204\18")]:IsCastable() and v60 and v61 and v63) then
					if ((3080 >= 1986) and v25(v50.SummonDarkglare, v47)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\180\248\46\75\32\111\165\244\49\79\41\92\160\231\38\4\47\95\164\181\114\28", "\78\48\193\149\67\36");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\29\31\140\29\71\57\29\178\25\81\36\11\146\29", "\33\80\126\224\120")]:IsReady() and (v13:BuffUp(v50.UmbrafireKindlingBuff))) or (1439 > 3538)) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100)) or (419 < 7)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\169\15\193\90\229\171\60\214\93\252\188\22\214\89\172\169\12\193\28\190\248", "\60\140\200\99\164");
					end
				end
				if ((2820 == 2820) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\180\241\1\34\173\129\215\11\52\176\146\228\16\47\173\137", "\194\231\148\100\70")]:IsReady() and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\117\67\214\151\254\205\117\73\196\167\229", "\168\38\44\161\195\150")]:IsAvailable()) then
					if (v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption)) or (4362 <= 3527)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\147\249\135\114\15\231\176\41\131\243\144\100\37\248\162\31\143\242\194\119\63\237\246\68\210", "\118\224\156\226\22\80\136\214");
					end
				end
				if ((2613 <= 2680) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\111\239\85\133\68\231\90\178\67\254\77\149\80\235", "\224\34\142\57")]:IsReady() and ((((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\237\178\200\208\124\255\121\15\204\172\194\209\114\227\88", "\110\190\199\165\189\19\145\61")]:CooldownRemains() > 15) or (v68 > 3)) and not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\233\228\96\220\131\194\233\238\114\236\152", "\167\186\139\23\136\235")]:IsAvailable()) or v13:BuffUp(v50.TormentedCrescendoBuff))) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100)) or (1482 >= 4288)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\180\132\8\28\188\139\50\8\180\152\25\15\167\141\77\27\186\141\77\72\225", "\109\122\213\232");
					end
				end
				v124 = 4;
			end
			if ((v124 == 0) or (2462 > 4426)) then
				if ((4774 == 4774) and v31) then
					local v150 = 0;
					local v151;
					while true do
						if ((566 <= 960) and (v150 == 0)) then
							v151 = v90();
							if (v151 or (2910 <= 1930)) then
								return v151;
							end
							break;
						end
					end
				end
				v125 = v89();
				if (v125 or (19 > 452)) then
					return v125;
				end
				v67 = v71(v58);
				v124 = 1;
			end
			if ((v124 == 1) or (907 > 3152)) then
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\150\245\22\75\151", "\227\222\148\99\37")]:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < 3)) or (2505 > 4470)) then
					if (v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt)) or (3711 > 4062)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\83\71\248\237\115\83\93\243\185\97", "\153\83\50\50\150");
					end
				end
				if ((420 == 420) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\107\127\127\25\71\170\68\83\98", "\45\61\22\19\124\19\203")]:IsReady() and (((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\242\29\24\249\7\113\173\196\0\30\210\14\101\173\213\29\3\236", "\217\161\114\109\149\98\16")]:TalentRank() == 2) and ((v67 < 1.5) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\33\47\45\112\142\123\6", "\20\114\64\88\28\220")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\7\8\222\177\204\209\180\63\21", "\221\81\97\178\212\152\176")]:ExecuteTime()))) or ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\254\232\8\247\31\204\243\24\233\9\234\235\8\239\14\194\233\4", "\122\173\135\125\155")]:TalentRank() == 1) and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\183\206\21\181\13\62\220", "\168\228\161\96\217\95\81")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\237\216\34\89\27\86\210\223\58", "\55\187\177\78\60\79")]:ExecuteTime())) or (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\30\193\74\231\67\206\148\40\220\76\204\74\218\148\57\193\81\242", "\224\77\174\63\139\38\175")]:IsAvailable() and ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\183\78\77\34\182\78\76", "\78\228\33\56")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\248\119\190\6\177\207\119\188\23", "\229\174\30\210\99")]:ExecuteTime()) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\45\228\138\84\217\60\48\21\249", "\89\123\141\230\49\141\93")]:CooldownRemains() > 25))))) then
					if (v25(v56.VileTaintCursor, nil, nil, not v17:IsInRange(40)) or (33 >= 3494)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\120\250\9\47\94\242\120\248\24\80\75\252\116\182\88", "\42\147\17\150\108\112");
					end
				end
				if (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\63\174\44\113\243\231\2\149\36\113\224\253\3\167\63\118\243\241", "\136\111\198\77\31\135")]:IsCastable() or (1267 == 4744)) then
					if ((2428 < 3778) and v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\1\166\88\169\235\26\150\17\0\169\81\168\232\22\187\11\29\190\22\188\235\18\233\84", "\201\98\105\199\54\221\132\119");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\140\2\144\53\3\55\160\188\45\133\39\14\60\175\173\5\140\47", "\204\217\108\227\65\98\85")]:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < 5)) or (2946 <= 1596)) then
					if ((4433 > 3127) and v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\205\230\241\45\194\82\198\202\228\42\198\82\202\246\241\37\207\80\131\244\234\41\128\6", "\160\62\163\149\133\76");
					end
				end
				v124 = 2;
			end
			if ((4300 >= 2733) and (v124 == 2)) then
				if ((4829 == 4829) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\229\169\29\39\204\216\140\4\41\198", "\163\182\192\109\79")]:IsReady() and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\7\47\16\200\250\58\10\9\198\240\16\35\2\213\243\50", "\149\84\70\96\160")]:AuraActiveCount() < 6) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\11\19\0\224\55\8\41\236\42\13\10\225\57\20\8", "\141\88\102\109")]:CooldownUp()) then
					if ((1683 <= 4726) and v49.CastCycle(v50.SiphonLife, v57, v85, not v17:IsSpellInRange(v50.SiphonLife))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\160\90\218\120\21\51\106\205\186\85\207\48\27\50\80\129\226\3", "\161\211\51\170\16\122\93\53");
					end
				end
				if ((4835 >= 3669) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\200\161\167\36\201\161\166", "\72\155\206\210")]:IsReady() and v61 and v60) then
					if ((2851 > 1859) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\117\65\2\12\84\117\64\78\50\73\127\20\95\97", "\83\38\26\52\110");
					end
				end
				if ((3848 > 2323) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\107\18\34\66\87\17\4\73\74\5\50\86\76\30\40\72", "\38\56\119\71")]:IsReady() and (v17:DebuffRemains(v50.CorruptionDebuff) < 5) and not (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\192\234\93\210\42\80\208\224\74\196\48\70\231\230\87\216", "\54\147\143\56\182\69")]:InFlight() or v17:DebuffUp(v50.SeedofCorruptionDebuff))) then
					if ((2836 > 469) and v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\132\250\77\224\217\135\192\74\208\196\147\234\89\203\223\142\241\9\222\217\132\191\24\139", "\191\182\225\159\41");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\10\21\39\91\146", "\162\75\114\72\53\235\231")]:IsReady() and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\173\59\75\236\74\38\137\62\81\228\85", "\98\236\92\36\130\51")]:AuraActiveCount() < 8)) or (2096 <= 540)) then
					if (v49.CastTargetIf(v50.Agony, v57, LUAOBFUSACTOR_DECRYPT_STR_0("\169\16\2", "\80\196\121\108\218\37\200\213"), v73, v76, not v17:IsSpellInRange(v50.Agony)) or (3183 < 2645)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\116\13\113\82\78\139\15\118\66\46\29", "\234\96\19\98\31\43\110");
					end
				end
				v124 = 3;
			end
		end
	end
	local function v92()
		local v126 = 0;
		local v127;
		while true do
			if ((3230 <= 3760) and (5 == v126)) then
				if ((3828 == 3828) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\211\11\35\237\240\211\194\12\46\253", "\164\128\99\66\137\159")]:IsReady()) then
					if ((554 == 554) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\129\232\186\15\158\214\188\15\133\253\254\3\133\236\191\22\140\169\235\86", "\222\96\233\137");
					end
				end
				break;
			end
			if ((v126 == 2) or (2563 == 172)) then
				if ((3889 >= 131) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\6\132\107\87\221\161\152\209\51\136", "\184\85\237\27\63\178\207\212")]:IsReady()) then
					if (v49.CastTargetIf(v50.SiphonLife, v57, LUAOBFUSACTOR_DECRYPT_STR_0("\5\80\7", "\63\104\57\105"), v75, v79, not v17:IsSpellInRange(v50.SiphonLife)) or (492 == 4578)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\142\180\76\4\137\155\72\2\129\161\4\8\139\161\69\29\130\228\22\91", "\36\107\231\196");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\117\180\183\137\73", "\231\61\213\194")]:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < 3)) or (4112 < 1816)) then
					if ((4525 >= 1223) and v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\172\40\125\29\237\62\127\12\172\43\118\73\255\111", "\19\105\205\93");
					end
				end
				if ((1090 <= 4827) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\153\0\223\143\43\166\5\237\136\49\174\29\210\128\45\160\28\199", "\95\201\104\190\225")]:IsReady() and ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\156\196\212\194\157\196\213", "\174\207\171\161")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\221\246\12\253\236\216\224\205\4\253\255\194\225\255\31\250\236\206", "\183\141\158\109\147\152")]:ExecuteTime()) or (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\31\6\243\0\41\8\242\9\62\26\193\0\57\29\242\3\34\16", "\108\76\105\134")]:IsAvailable() and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\216\202\164\237\252\228\209", "\174\139\165\209\129")]:IsAvailable() or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\144\188\247\205\244\12\100", "\24\195\211\130\161\166\99\16")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\118\11\232\34\71\25\75\48\224\34\84\3\74\2\251\37\71\15", "\118\38\99\137\76\51")]:ExecuteTime()) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\206\41\16\30\59\47\233", "\64\157\70\101\114\105")]:CooldownRemains() >= 25))))) then
					if (v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity)) or (239 > 1345)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\160\166\237\4\79\165\152\240\25\78\175\178\239\17\82\161\179\250\80\67\164\162\226\6\69\232\245\183", "\112\32\200\199\131");
					end
				end
				if (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\31\95\73\180\241\164\54", "\66\76\48\60\216\163\203")]:IsReady() or (3710 >= 3738)) then
					if (v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot)) or (3838 < 2061)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\137\108\255\96\220\43\174\198\122\255\90\207\50\191\198\43\165", "\68\218\230\25\147\63\174");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\128\43\95\73\176\164\41\97\77\166\185\63\65\73", "\214\205\74\51\44")]:IsReady() and ((v68 > 4) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\206\67\240\241\114\244\88\231\248\84\232\73\241\255\114\244\72\237", "\23\154\44\130\156")]:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == 1) and (v68 > 3)))) or (690 > 1172)) then
					if (v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100)) or (1592 > 2599)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\167\161\171\48\26\18\153\191\175\38\7\4\180\168\238\53\31\20\167\187\171\118\65\73", "\115\113\198\205\206\86");
					end
				end
				if ((3574 <= 4397) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\169\86\242\95\130\94\253\104\133\71\234\79\150\82", "\58\228\55\158")]:IsReady() and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\144\155\213\47\56\153\58\161\138\216", "\85\212\233\176\78\92\205")]:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < v13:GCD())) then
					if ((3135 > 1330) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\71\89\132\231\76\81\139\221\88\89\152\246\95\74\141\162\73\84\141\227\92\93\200\177\26", "\130\42\56\232");
					end
				end
				v126 = 3;
			end
			if ((v126 == 4) or (3900 <= 3641)) then
				if ((1724 == 1724) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\242\103\40\170\233\160\165\16\211", "\118\182\21\73\195\135\236\204")]:IsReady() and ((v13:BuffStack(v50.InevitableDemiseBuff) > 48) or ((v13:BuffStack(v50.InevitableDemiseBuff) > 20) and (v70 < 4)))) then
					if ((455 <= 1282) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\12\46\27\73\10\50\241\1\58\31\0\7\1\248\9\42\31\0\80\89", "\157\104\92\122\32\100\109");
					end
				end
				if ((4606 < 4876) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\135\180\206\195\51\11\132\173\166", "\203\195\198\175\170\93\71\237")]:IsReady() and v17:DebuffUp(v50.SoulRotDebuff) and (v13:BuffStack(v50.InevitableDemiseBuff) > 10)) then
					if (v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife)) or (1442 > 2640)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\89\63\220\95\46\240\39\77\59\149\82\29\249\47\93\59\149\5\71", "\156\78\43\94\181\49\113");
					end
				end
				if ((136 < 3668) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\83\239\203\173\18", "\25\18\136\164\195\107\35")]:IsReady()) then
					if (v49.CastCycle(v50.Agony, v57, v81, not v17:IsSpellInRange(v50.Agony)) or (1784 > 4781)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\42\166\65\107\252\194\180\237\44\191\74\50\232\153", "\216\136\77\201\47\18\220\161");
					end
				end
				if ((4585 > 3298) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\14\227\57\200\29\204\150\36\227\37", "\226\77\140\75\186\104\188")]:IsCastable()) then
					if (v49.CastCycle(v50.Corruption, v57, v83, not v17:IsSpellInRange(v50.Corruption)) or (1664 > 1698)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\193\194\45\90\169\218\217\48\65\249\205\220\58\78\175\203\144\106\31", "\47\217\174\176\95");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\149\220\122\7\180\93\123\20\185\205\98\23\160\81", "\70\216\189\22\98\210\52\24")]:IsReady() and (v68 > 1)) or (3427 < 2849)) then
					if ((3616 <= 4429) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\222\175\130\213\211\220\156\149\210\202\203\182\149\214\154\220\175\130\210\204\218\227\210\129", "\179\186\191\195\231");
					end
				end
				if ((3988 >= 66) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\221\45\25\237\247\12\23\241\245", "\132\153\95\120")]:IsReady()) then
					if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or (862 > 4644)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\181\160\15\36\249\229\179\190\167\2\109\244\214\165\176\164\11\109\162\142", "\192\209\210\110\77\151\186");
					end
				end
				v126 = 5;
			end
			if ((1221 == 1221) and (v126 == 0)) then
				if (v31 or (45 > 1271)) then
					local v152 = 0;
					local v153;
					while true do
						if ((3877 > 1530) and (v152 == 0)) then
							v153 = v90();
							if (v153 or (4798 == 1255)) then
								return v153;
							end
							break;
						end
					end
				end
				v127 = v89();
				if (v127 or (2541 > 2860)) then
					return v127;
				end
				if ((v31 and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\100\77\9\211\88\86\32\223\69\83\3\210\86\74\1", "\190\55\56\100")]:IsCastable() and v60 and v61 and v63) or (2902 > 3629)) then
					if ((427 < 3468) and v25(v50.SummonDarkglare, v47)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\69\186\49\19\28\237\204\82\174\46\21\20\239\242\68\170\124\29\31\230\242\64\170\124\76", "\147\54\207\92\126\115\131");
					end
				end
				if ((4190 >= 2804) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\32\48\57\120\11\119\14\3\52\109\25\107\31\52", "\30\109\81\85\29\109")]:IsReady() and ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\219\99\81\183\50\234\243\234\114\92", "\156\159\17\52\214\86\190")]:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < 2) and v17:DebuffUp(v50.AgonyDebuff) and v17:DebuffUp(v50.CorruptionDebuff) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\157\230\173\180\161\225\145\181\168\234", "\220\206\143\221")]:IsAvailable() or v17:DebuffUp(v50.SiphonLifeDebuff)) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\182\117\44\25\204\195\223\181\116\35\16\205\192\211\148\116\57\14", "\178\230\29\77\119\184\172")]:IsAvailable() or v50[LUAOBFUSACTOR_DECRYPT_STR_0("\197\182\11\21\99\247\248\141\3\21\112\237\249\191\24\18\99\225", "\152\149\222\106\123\23")]:CooldownDown()) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\235\47\250\70\129\220\47\248\87", "\213\189\70\150\35")]:IsAvailable() or v50[LUAOBFUSACTOR_DECRYPT_STR_0("\121\92\120\13\123\84\125\6\91", "\104\47\53\20")]:CooldownDown()) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\144\67\148\16\142\0\183", "\111\195\44\225\124\220")]:IsAvailable() or v50[LUAOBFUSACTOR_DECRYPT_STR_0("\235\73\21\127\153\164\204", "\203\184\38\96\19\203")]:CooldownDown())) or (v68 > 4) or v13:BuffUp(v50.UmbrafireKindlingBuff))) then
					if ((2086 == 2086) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\114\117\68\200\48\112\70\83\207\41\103\108\83\203\121\112\117\68\207\47\118\57\21", "\174\89\19\25\33");
					end
				end
				if ((4148 > 2733) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\14\21\93\64\238", "\107\79\114\50\46\151\231")]:IsReady()) then
					if ((3054 >= 1605) and v49.CastTargetIf(v50.Agony, v57, LUAOBFUSACTOR_DECRYPT_STR_0("\52\175\187", "\160\89\198\213\73\234\89\215"), v73, v77, not v17:IsSpellInRange(v50.Agony))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\118\187\240\220\8\114\184\251\196\94\116\244\168", "\165\40\17\212\158");
					end
				end
				v126 = 1;
			end
			if ((1044 < 1519) and (v126 == 1)) then
				if ((1707 <= 4200) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\214\214\29\63\20\234\205", "\70\133\185\104\83")]:IsReady() and v61 and v60) then
					if ((580 == 580) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\74\81\38\246\22\74\80\106\202\8\64\69\60\204\68\29", "\169\100\37\36\74");
					end
				end
				if ((601 <= 999) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\54\142\174\85\52\134\171\94\20", "\48\96\231\194")]:IsReady() and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\233\93\1\35\0\252\170\129\221\92\8", "\227\168\58\110\77\121\184\207")]:AuraActiveCount() == 2) and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\88\51\173\82\164\203\101\172\116\50\155\69\179\206\119\163", "\197\27\92\223\32\209\187\17")]:AuraActiveCount() == 2) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\48\86\211\243\12\81\239\242\5\90", "\155\99\63\163")]:IsAvailable() or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\177\216\177\133\182\138\174\216\167\136\157\129\128\196\167\139", "\228\226\177\193\237\217")]:AuraActiveCount() == 2)) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\7\191\54\234\6\191\55", "\134\84\208\67")]:IsAvailable() or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\32\163\147\80\33\163\146", "\60\115\204\230")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\209\51\231\117\211\59\226\126\243", "\16\135\90\139")]:ExecuteTime()) or (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\103\123\19\63\75\85\108\81\102\21\20\66\65\108\64\123\8\42", "\24\52\20\102\83\46\52")]:IsAvailable() and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\247\32\52\40\61\203\59", "\111\164\79\65\68")]:CooldownRemains() >= 12)))) then
					if ((3970 == 3970) and v25(v56.VileTaintCursor, nil, nil, not v17:IsSpellInRange(v50.VileTaint))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\208\143\219\17\254\199\208\141\202\110\233\202\220\130\200\43\170\151\137", "\138\166\185\227\190\78");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\251\124\196\57\70\44\20\248\125\203\48\71\47\24\217\125\209\46", "\121\171\20\165\87\50\67")]:IsReady() and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\231\63\182\56\160\38\195\58\172\48\191", "\98\166\88\217\86\217")]:AuraActiveCount() == 2) and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\213\249\107\19\147\204\226\255\118\15\162\217\244\227\127\7", "\188\150\150\25\97\230")]:AuraActiveCount() == 2) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\233\128\79\10\3\227\246\128\89\7", "\141\186\233\63\98\108")]:IsAvailable() or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\194\227\60\190\42\255\198\37\176\32\213\239\46\163\35\247", "\69\145\138\76\214")]:AuraActiveCount() == 2)) and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\67\192\156\133\141\25\100", "\118\16\175\233\233\223")]:IsAvailable() or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\184\139\32\183\220\132\105", "\29\235\228\85\219\142\235")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\13\220\187\211\99\65\42\97\52\218\189\200\123\79\53\91\41\205", "\50\93\180\218\189\23\46\71")]:ExecuteTime()) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\237\171\78\64\118\211\92", "\40\190\196\59\44\36\188")]:CooldownRemains() >= 25))) or (98 == 208)) then
					if ((2006 <= 3914) and v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\77\221\186\238\114\0\3\86\213\186\253\104\1\61\87\213\160\227\61\14\48\64\221\162\255\61\92\110", "\109\92\37\188\212\154\29");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\49\225\183\215\48\88\8\234\133\197\55\86\13\236\176\202\62\84", "\58\100\143\196\163\81")]:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < 5)) or (3101 <= 2971)) then
					if (v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction)) or (2073 <= 671)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\15\76\48\183\62\75\233\11\37\67\37\165\51\64\230\26\19\77\45\227\60\69\224\15\12\71\99\242\107", "\110\122\34\67\195\95\41\133");
					end
				end
				if ((3305 > 95) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\70\180\94\78\217\115\146\84\88\196\96\161\79\67\217\123", "\182\21\209\59\42")]:IsReady() and not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\150\85\214\18\45\171\163\82\230\18\51\172\162\71\209\20\46\176", "\222\215\55\165\125\65")]:IsAvailable() and (v17:DebuffRemains(v50.CorruptionDebuff) < 5) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\31\222\209\46\250\196\222\79\41\213\213", "\42\76\177\166\122\146\161\141")]:IsAvailable() and v72()) then
					if ((2727 == 2727) and v25(v50.SeedofCorruption, nil, nil, not v17:IsSpellInRange(v50.SeedofCorruption))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\143\0\202\70\121\163\181\6\193\107\100\176\154\17\199\118\120\229\137\9\203\120\96\160\202\84\152", "\22\197\234\101\174\25");
					end
				end
				if (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\14\59\183\206\99\191\195\143\34\58", "\230\77\84\197\188\22\207\183")]:IsReady() or (2970 >= 4072)) then
					if ((3881 > 814) and v49.CastTargetIf(v50.Corruption, v57, LUAOBFUSACTOR_DECRYPT_STR_0("\244\29\200", "\85\153\116\166\156\236\193\144"), v74, v78, not v17:IsSpellInRange(v50.Corruption))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\167\239\95\161\241\16\176\233\66\189\164\3\168\229\76\165\225\64\245\184", "\96\196\128\45\211\132");
					end
				end
				v126 = 2;
			end
			if ((v126 == 3) or (4932 < 4868)) then
				if ((3667 <= 4802) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\199\180\40\230\70\54\233\135\37\243\84\42\248\176", "\95\138\213\68\131\32")]:IsReady() and not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\14\58\164\66\114\30\39\180\64\126", "\22\74\72\193\35")]:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff)) then
					if ((1260 >= 858) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\120\232\93\42\112\231\103\62\120\244\76\57\107\225\24\47\117\225\89\58\124\164\11\126", "\56\76\25\132");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\115\192\167\35\201\87\194\153\39\223\74\212\185\35", "\175\62\161\203\70")]:IsReady() and (v64 or v62)) or (3911 == 4700)) then
					if ((3000 < 4194) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\220\207\22\51\53\222\252\1\52\44\201\214\1\48\124\222\207\22\52\42\216\131\64\97", "\85\92\189\163\115");
					end
				end
				if ((651 < 4442) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\13\190\49\49\39\159\63\45\37", "\88\73\204\80")]:IsReady() and v13:BuffUp(v50.NightfallBuff) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\29\139\17\66\38\205\11\142\18\84\40\217\43", "\186\78\227\112\38\73")]:IsAvailable()) then
					if (v49.CastCycle(v50.DrainSoul, v57, EvaluatecycleDrainSoul, not v17:IsSpellInRange(v50.DrainSoul)) or (195 >= 1804)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\69\252\92\93\69\239\88\232\89\19\121\240\82\252\67\86\58\175\1", "\26\156\55\157\53\51");
					end
				end
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\168\202\23\208\182\99\131\205\26", "\48\236\184\118\185\216")]:IsReady() and v13:BuffUp(v50.NightfallBuff)) or (1382 > 2216)) then
					if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or (2861 == 2459)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\175\86\57\193\11\246\178\66\60\143\55\233\184\86\38\202\116\182\229", "\84\133\221\55\80\175");
					end
				end
				if ((1903 < 4021) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\142\239\37\162\200\75\159\232\40\178", "\60\221\135\68\198\167")]:IsReady() and v13:BuffUp(v50.NightfallBuff)) then
					if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or (2270 >= 4130)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\181\249\135\77\206\209\191\247\143\86\153\237\177\253\130\84\220\174\233\168", "\185\142\221\152\227\34");
					end
				end
				if ((2593 <= 3958) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\117\196\91\255\69\58\244\106\196\71\238\86\33\242", "\151\56\165\55\154\35\83")]:IsReady() and (v68 > 3)) then
					if ((1176 == 1176) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\66\9\235\166\74\6\209\178\66\21\250\181\81\0\174\163\79\0\239\182\70\69\186\242", "\142\192\35\101");
					end
				end
				v126 = 4;
			end
		end
	end
	local function v93()
		local v128 = 0;
		while true do
			if ((v128 == 1) or (3062 == 1818)) then
				v57 = v13:GetEnemiesInRange(40);
				v58 = v17:GetEnemiesInSplashRange(10);
				if (v30 or (3717 < 3149)) then
					v59 = v17:GetEnemiesInSplashRangeCount(10);
				else
					v59 = 1;
				end
				if ((3195 < 3730) and (v49.TargetIsValid() or v13:AffectingCombat())) then
					local v154 = 0;
					while true do
						if ((2797 <= 3980) and (v154 == 0)) then
							v69 = v10.BossFightRemains(nil, true);
							v70 = v69;
							v154 = 1;
						end
						if ((1944 <= 2368) and (v154 == 1)) then
							if ((1709 < 4248) and (v70 == 11111)) then
								v70 = v10.FightRemains(v58, false);
							end
							break;
						end
					end
				end
				v128 = 2;
			end
			if ((v128 == 2) or (3970 == 3202)) then
				v68 = v13:SoulShardsP();
				if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\187\180\228\207\123\134\145\236\214", "\20\232\193\137\162")]:IsCastable() and v43 and not v16:IsActive()) or (3918 >= 4397)) then
					if (v26(v50.SummonPet) or (780 == 3185)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\202\200\171\232\130\40\97\39\203\133\169\232\143", "\17\66\191\165\198\135\236\119");
					end
				end
				if (v49.TargetIsValid() or (3202 >= 4075)) then
					local v155 = 0;
					while true do
						if ((64 == 64) and (v155 == 4)) then
							if ((2202 >= 694) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\115\23\187\169\22\124\78\44\179\169\5\102\79\30\168\174\22\106", "\19\35\127\218\199\98")]:IsCastable() and ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\47\244\31\238\46\244\30", "\130\124\155\106")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\229\195\247\161\183\249\113\140\220\197\241\186\175\247\110\182\193\210", "\223\181\171\150\207\195\150\28")]:ExecuteTime()) or (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\127\53\246\162\12\77\46\230\188\26\107\54\246\186\29\67\52\250", "\105\44\90\131\206")]:IsAvailable() and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\204\239\167\181\58\49\235", "\94\159\128\210\217\104")]:IsAvailable() or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\99\246\19\179\109\112\237", "\26\48\153\102\223\63\31\153")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\50\72\236\253\22\79\224\192\11\78\234\230\14\65\255\250\22\89", "\147\98\32\141")]:ExecuteTime()) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\43\76\246\198\52\89\95", "\43\120\35\131\170\102\54")]:CooldownRemains() >= 25))))) then
								if ((3706 <= 3900) and v25(v50.PhantomSingularity, v46, nil, not v17:IsSpellInRange(v50.PhantomSingularity))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\68\14\134\184\177\191\137\107\21\142\184\162\165\136\85\20\142\162\188\240\137\85\15\137\246\247\224", "\228\52\102\231\214\197\208");
								end
							end
							if ((2890 > 2617) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\40\233\121\207\222\138\16\216\10", "\182\126\128\21\170\138\235\121")]:IsReady() and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\184\213\32\234\180\28\36", "\102\235\186\85\134\230\115\80")]:IsAvailable() or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\100\3\43\83\64\219\54", "\66\55\108\94\63\18\180")]:CooldownRemains() <= v50[LUAOBFUSACTOR_DECRYPT_STR_0("\34\132\137\50\19\88\29\131\145", "\57\116\237\229\87\71")]:ExecuteTime()) or (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\153\190\248\235\114\239\83\175\163\254\192\123\251\83\190\190\227\254", "\39\202\209\141\135\23\142")]:IsAvailable() and (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\204\60\28\6\0\247\235", "\152\159\83\105\106\82")]:CooldownRemains() >= 12)))) then
								if (v25(v56.VileTaintCursor, nil, nil, not v17:IsInRange(40)) or (3355 > 4385)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\151\207\93\247\246\72\128\207\95\230\137\81\128\207\95\178\155\14", "\60\225\166\49\146\169");
								end
							end
							if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\28\17\58\38\51\8\59", "\103\79\126\79\74\97")]:IsReady() and v61 and (v60 or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\137\112\198\127\91\27\174\122\193\96\121\22\175\107\199\124\80\3", "\122\218\31\179\19\62")]:TalentRank() ~= 1))) or (3067 <= 2195)) then
								if ((3025 >= 2813) and v25(v50.SoulRot, nil, nil, not v17:IsSpellInRange(v50.SoulRot))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\160\217\216\205\246\179\74\167\150\192\192\192\175\5\225\130", "\37\211\182\173\161\169\193");
								end
							end
							if ((2412 >= 356) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\218\59\65\220\46\114\186\197\59\93\205\61\105\188", "\217\151\90\45\185\72\27")]:IsReady() and ((v68 > 4) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\247\115\245\31\83\205\104\226\22\117\209\121\244\17\83\205\120\232", "\54\163\28\135\114")]:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == 1) and (v68 > 3)) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\28\212\79\143\75\113\60\222\89\161\92\122\59\216\88\140\74\112", "\31\72\187\61\226\46")]:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff) and v17:DebuffDown(v50.DreadTouchDebuff)) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\247\9\81\223\66\112\48\198\2\96\192\66\109\39\198\8\71\221", "\68\163\102\35\178\39\30")]:IsAvailable() and (v13:BuffStack(v50.TormentedCrescendoBuff) == 2)) or v64 or (v62 and (v68 > 1)) or (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\138\127\200\202\6\187\151\20\186\83\200\194\16\182\134\31\186\127", "\113\222\16\186\167\99\213\227")]:IsAvailable() and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\0\7\252\254\58\8\250\250\34", "\150\78\110\155")]:IsAvailable() and v13:BuffUp(v50.TormentedCrescendoBuff) and v13:BuffUp(v50.NightfallBuff)))) then
								if ((2070 > 1171) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\136\196\43\228\162\23\188\127\151\196\55\245\177\12\186\0\136\196\46\239\228\76\233", "\32\229\165\71\129\196\126\223");
								end
							end
							v155 = 5;
						end
						if ((5 == v155) or (4108 < 3934)) then
							if ((3499 >= 3439) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\231\155\197\136\143\249\202\143\193", "\181\163\233\164\225\225")]:IsReady() and ((v13:BuffStack(v50.InevitableDemiseBuff) > 48) or ((v13:BuffStack(v50.InevitableDemiseBuff) > 20) and (v70 < 4)))) then
								if ((876 < 3303) and v25(v50.DrainLife, nil, nil, not v17:IsSpellInRange(v50.DrainLife))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\84\153\63\126\94\180\50\126\86\142\126\122\81\130\48\55\2\211", "\23\48\235\94");
								end
							end
							if ((2922 <= 3562) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\88\200\217\84\89\0\221\105\214", "\178\28\186\184\61\55\83")]:IsReady() and (v13:BuffUp(v50.NightfallBuff))) then
								if ((2619 >= 1322) and v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\192\223\70\53\252\49\230\203\216\75\124\255\15\252\202\141\20\108", "\149\164\173\39\92\146\110");
								end
							end
							if ((4133 >= 2404) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\192\47\17\27\21\12\209\40\28\11", "\123\147\71\112\127\122")]:IsReady() and (v13:BuffUp(v50.NightfallBuff))) then
								if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or (1433 == 2686)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\223\197\131\117\73\219\242\128\126\74\216\141\143\112\79\194\141\209\35", "\38\172\173\226\17");
								end
							end
							if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\108\22\35\225\84", "\143\45\113\76")]:IsCastable() and (v17:DebuffRefreshable(v50.AgonyDebuff))) or (4123 == 4457)) then
								if (v25(v50.Agony, nil, nil, not v17:IsSpellInRange(v50.Agony)) or (3972 <= 205)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\185\191\19\50\161\248\17\61\177\182\92\111\236", "\92\216\216\124");
								end
							end
							v155 = 6;
						end
						if ((v155 == 3) or (3766 < 1004)) then
							if ((1784 < 2184) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\224\176\63\15\220\183\3\14\213\188", "\103\179\217\79")]:IsCastable() and (v17:DebuffRefreshable(v50.SiphonLifeDebuff))) then
								if (v25(v50.SiphonLife, nil, nil, not v17:IsSpellInRange(v50.SiphonLife)) or (1649 > 4231)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\89\190\12\221\78\130\156\70\190\26\208\1\129\162\67\185\92\132\19", "\195\42\215\124\181\33\236");
								end
							end
							if ((3193 == 3193) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\37\88\34\48\49", "\152\109\57\87\94\69")]:IsReady() and (v17:DebuffRemains(v50.HauntDebuff) < 3)) then
								if (v25(v50.Haunt, nil, nil, not v17:IsSpellInRange(v50.Haunt)) or (3495 > 4306)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\241\214\31\173\170\146\89\169\240\217\74\242\234", "\200\153\183\106\195\222\178\52");
								end
							end
							if ((4001 > 3798) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\22\241\137\52\71\105\61\246\132", "\58\82\131\232\93\41")]:IsReady() and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\176\95\209\17\82\40\166\90\210\7\92\60\134", "\95\227\55\176\117\61")]:IsAvailable() and ((v17:DebuffStack(v50.ShadowEmbraceDebuff) < 3) or (v17:DebuffRemains(v50.ShadowEmbraceDebuff) < 3))) then
								if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or (4688 <= 4499)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\28\108\34\66\165\39\109\44\94\167\88\115\34\66\165\88\47\117", "\203\120\30\67\43");
								end
							end
							if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\194\45\76\235\214\230\7\66\227\205", "\185\145\69\45\143")]:IsReady() and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\185\23\24\162\211\157\58\20\164\206\139\28\28", "\188\234\127\121\198")]:IsAvailable() and ((v17:DebuffStack(v50.ShadowEmbraceDebuff) < 3) or (v17:DebuffRemains(v50.ShadowEmbraceDebuff) < 3))) or (1567 <= 319)) then
								if (v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt)) or (4583 == 3761)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\43\58\18\135\55\37\44\129\55\62\7\195\53\51\26\141\120\99\75", "\227\88\82\115");
								end
							end
							v155 = 4;
						end
						if ((3454 > 1580) and (v155 == 1)) then
							if ((v59 > 2) or (1607 == 20)) then
								local v156 = 0;
								local v157;
								while true do
									if ((v156 == 0) or (962 >= 4666)) then
										v157 = v91();
										if (v157 or (1896 == 1708)) then
											return v157;
										end
										break;
									end
								end
							end
							if ((3985 >= 1284) and v24()) then
								local v158 = 0;
								local v159;
								while true do
									if ((v158 == 0) or (1987 == 545)) then
										v159 = v90();
										if (v159 or (4896 < 1261)) then
											return v159;
										end
										break;
									end
								end
							end
							if ((23 < 3610) and v33) then
								local v160 = 0;
								local v161;
								while true do
									if ((v160 == 0) or (3911 < 2578)) then
										v161 = v89();
										if (v161 or (4238 < 87)) then
											return v161;
										end
										break;
									end
								end
							end
							if ((2538 == 2538) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\34\174\162\22\249\225\239\227\14\191\186\6\237\237", "\177\111\207\206\115\159\136\140")]:IsReady() and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\33\155\21\21\208\123\80\16\138\24", "\63\101\233\112\116\180\47")]:IsAvailable() and (v17:DebuffRemains(v50.DreadTouchDebuff) < 2) and v17:DebuffUp(v50.AgonyDebuff) and v17:DebuffUp(v50.CorruptionDebuff) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\240\50\253\26\247\56\239\50\235\23", "\86\163\91\141\114\152")]:IsAvailable() or v17:DebuffUp(v50.SiphonLifeDebuff)) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\99\3\117\125\46\92\6\71\122\52\84\30\120\114\40\90\31\109", "\90\51\107\20\19")]:IsAvailable() or v50[LUAOBFUSACTOR_DECRYPT_STR_0("\189\248\132\225\41\130\253\182\230\51\138\229\137\238\47\132\228\156", "\93\237\144\229\143")]:CooldownDown()) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\35\255\252\28\63\71\28\248\228", "\38\117\150\144\121\107")]:IsAvailable() or v50[LUAOBFUSACTOR_DECRYPT_STR_0("\27\178\226\63\25\186\231\52\57", "\90\77\219\142")]:CooldownDown()) and (not v50[LUAOBFUSACTOR_DECRYPT_STR_0("\213\11\52\53\126\8\110", "\26\134\100\65\89\44\103")]:IsAvailable() or v50[LUAOBFUSACTOR_DECRYPT_STR_0("\194\236\37\47\150\254\247", "\196\145\131\80\67")]:CooldownDown())) then
								if ((4122 == 4122) and v25(v50.MaleficRapture, nil, nil, not v17:IsInRange(100))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\19\177\10\13\30\225\29\143\20\9\8\252\11\162\3\72\21\233\23\190\70\90", "\136\126\208\102\104\120");
								end
							end
							v155 = 2;
						end
						if ((v155 == 2) or (2371 > 2654)) then
							if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\75\159\195\78\160\92\25\80\106\129\201\79\174\64\56", "\49\24\234\174\35\207\50\93")]:IsReady() and v60 and v61 and v63) or (3466 > 4520)) then
								if (v25(v50.SummonDarkglare, v47) or (951 >= 1027)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\31\231\240\133\126\2\205\249\137\99\7\245\241\137\99\9\178\240\137\120\2\178\169", "\17\108\146\157\232");
								end
							end
							if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\106\196\27\227\54", "\200\43\163\116\141\79")]:IsCastable() and (v17:DebuffRemains(v50.AgonyDebuff) < 5)) or (1369 > 2250)) then
								if (v25(v50.Agony, nil, nil, not v17:IsSpellInRange(v50.Agony)) or (937 > 3786)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\190\49\50\141\169\180\238\190\63\51\195\230", "\131\223\86\93\227\208\148");
								end
							end
							if ((v50[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\165\162\28\183\239\64\151\176\27\185\234\70\162\191\18\187", "\213\131\37\214\214\125")]:IsReady() and (v17:DebuffRemains(v50.UnstableAfflictionDebuff) < 5)) or (901 > 4218)) then
								if ((4779 > 4047) and v25(v50.UnstableAffliction, nil, nil, not v17:IsSpellInRange(v50.UnstableAffliction))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\51\37\54\171\224\36\39\32\128\224\32\45\41\182\226\50\34\42\177\161\43\42\44\177\161\126", "\129\70\75\69\223");
								end
							end
							if ((4050 > 1373) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\101\196\225\251\105\255\82\194\252\231", "\143\38\171\147\137\28")]:IsCastable() and (v17:DebuffRefreshable(v50.CorruptionDebuff))) then
								if (v25(v50.Corruption, nil, nil, not v17:IsSpellInRange(v50.Corruption)) or (1037 > 4390)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\211\141\171\225\22\243\192\217\141\183\179\14\226\221\222\194\232\163", "\180\176\226\217\147\99\131");
								end
							end
							v155 = 3;
						end
						if ((1407 <= 1919) and (6 == v155)) then
							if ((2526 >= 1717) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\120\61\190\82\232\75\38\165\79\243", "\157\59\82\204\32")]:IsCastable() and (v17:DebuffRefreshable(v50.CorruptionDebuff))) then
								if (v25(v50.Corruption, nil, nil, not v17:IsSpellInRange(v50.Corruption)) or (3620 <= 2094)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\59\49\241\232\252\250\199\184\55\48\163\247\232\227\221\241\107\104", "\209\88\94\131\154\137\138\179");
								end
							end
							if (v50[LUAOBFUSACTOR_DECRYPT_STR_0("\12\179\197\117\16\16\62\55\36", "\66\72\193\164\28\126\67\81")]:IsReady() or (1723 >= 2447)) then
								if (v25(v50.DrainSoul, nil, nil, not v17:IsSpellInRange(v50.DrainSoul)) or (1199 > 3543)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\227\62\169\81\40\73\244\35\189\84\102\123\230\37\166\24\114\38", "\22\135\76\200\56\70");
								end
							end
							if ((1617 < 3271) and v50[LUAOBFUSACTOR_DECRYPT_STR_0("\190\56\249\32\82\246\175\63\244\48", "\129\237\80\152\68\61")]:IsReady()) then
								if ((3085 > 1166) and v25(v50.ShadowBolt, nil, nil, not v17:IsSpellInRange(v50.ShadowBolt))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\66\160\5\247\19\0\103\83\167\8\231\92\26\89\88\166\68\167\78", "\56\49\200\100\147\124\119");
								end
							end
							break;
						end
						if ((4493 >= 3603) and (v155 == 0)) then
							if ((2843 <= 2975) and not v13:AffectingCombat() and v29) then
								local v162 = 0;
								local v163;
								while true do
									if ((0 == v162) or (1989 <= 174)) then
										v163 = v86();
										if (v163 or (209 > 2153)) then
											return v163;
										end
										break;
									end
								end
							end
							if ((not v13:IsCasting() and not v13:IsChanneling()) or (2020 == 1974)) then
								local v164 = 0;
								local v165;
								while true do
									if ((v164 == 0) or (1347 == 1360)) then
										v165 = v49.Interrupt(v50.SpellLock, 40, true);
										if (v165 or (4461 == 3572)) then
											return v165;
										end
										v165 = v49.Interrupt(v50.SpellLock, 40, true, v15, v56.SpellLockMouseover);
										if (v165 or (2872 == 318)) then
											return v165;
										end
										v164 = 1;
									end
									if ((568 == 568) and (2 == v164)) then
										v165 = v49.InterruptWithStun(v50.AxeToss, 40, true);
										if ((4200 == 4200) and v165) then
											return v165;
										end
										v165 = v49.InterruptWithStun(v50.AxeToss, 40, true, v15, v56.AxeTossMouseover);
										if (v165 or (4285 < 1369)) then
											return v165;
										end
										break;
									end
									if ((1 == v164) or (3520 > 4910)) then
										v165 = v49.Interrupt(v50.AxeToss, 40, true);
										if ((2842 <= 4353) and v165) then
											return v165;
										end
										v165 = v49.Interrupt(v50.AxeToss, 40, true, v15, v56.AxeTossMouseover);
										if (v165 or (3751 < 1643)) then
											return v165;
										end
										v164 = 2;
									end
								end
							end
							v87();
							if (((v59 > 1) and (v59 < 3)) or (4911 == 3534)) then
								local v166 = 0;
								local v167;
								while true do
									if ((3001 > 16) and (v166 == 0)) then
										v167 = v92();
										if ((2875 <= 3255) and v167) then
											return v167;
										end
										break;
									end
								end
							end
							v155 = 1;
						end
					end
				end
				break;
			end
			if ((368 < 4254) and (v128 == 0)) then
				v48();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\188\160\24\132\246\227", "\144\217\211\199\127\232\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\247\32\61", "\36\152\79\94\72\181\37\98")];
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\215\64\56\219\221\84", "\95\183\184\39")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\48\226", "\98\213\95\135\70\52\224")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\172\206\112\88\251\176", "\52\158\195\169\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\184\33", "\235\26\220\82\20\230\85\27")];
				v128 = 1;
			end
		end
	end
	local function v94()
		v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\237\56\185\252\197\61\171\249\195\48\255\199\205\44\179\255\207\53\255\226\195\42\190\228\197\49\177\176\206\39\255\213\220\55\188\190\140\13\170\224\220\49\173\228\201\58\255\242\213\126\152\255\198\55\173\241", "\144\172\94\223"));
	end
	v20.SetAPL(265, v93, v94);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\1\31\171\95\27\56\163\85\40\0\161\76\27\46\164\65\40\6\161\83\45\0\172\9\40\26\163", "\39\68\111\194")]();

