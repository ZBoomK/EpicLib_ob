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
		if ((v5 == 0) or (2339 < 2003)) then
			v6 = v0[v4];
			if ((432 == 432) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((1 == v5) or (1145 >= 1253)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\137\200\25\196\198\228\4\245\168\198\13\194\202\213\36\242\178\200\16\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\163\64\26\175", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\24\43\6", "\158\48\118\66\114")];
	local v14 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\207\71\162\74\240", "\38\156\55\199")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\133\104\112\60\26\71\234\70\164\113", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\48\171\212\210", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\150\87\202\178\53", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\121\80\5\54\90", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\159\204\218\7\13\37\175", "\75\220\163\183\106\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\172\142\37\192\13\180\142", "\185\98\218\235\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\41\42", "\202\171\92\71\134\190")];
	local v22 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\14\193\81\126", "\135\108\174\62\18\30\23\147")];
	local v23 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\187\224\36", "\167\214\137\74\171\120\206\83")];
	local v24 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\138\242\33", "\199\235\144\82\61\152")];
	local v25 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\10\23\161", "\75\103\118\217")];
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\228\85\99\0\137\17\200\88\121\26\190", "\126\167\52\16\116\217")];
	local v30 = pairs;
	local v31 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\206\34\47\143\166", "\156\168\78\64\224\212\121")];
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
	local function v73()
		local v137 = 0;
		while true do
			if ((3418 > 2118) and (v137 == 1)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\63\200\58\226\128\32\217\26\244\149\35\195\23", "\135\225\76\173\114")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\216\17\252\108\254\190\201\31\254\125\222\157", "\150\205\189\112\144\24")] or 0;
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\17\19\214\164\110\147\196\11\48\218\162\116\181\192\10\9", "\230\180\127\103\179\214\28")] or 0;
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\5\65\164\249\218\188\189\62\74\186\242\248\164\160\5\65\186\226\220\184", "\175\204\201\113\36\214\139")] or 0;
				v137 = 2;
			end
			if ((3066 <= 3890) and (v137 == 2)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\118\173\133\33\191\109\169\148\7\165\106\188\147\59\162\116\189", "\83\205\24\217\224")] or 0;
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\142\253\200\209\53\192\128\123\184\224\196\209\50", "\30\222\146\161\162\90\174\210")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\104\47\122\239\85\78\106\37\117\238\95\83\80\3\124\241\88\65\76", "\32\56\64\19\156\58")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\87\69\250\112\130\170\30\85\66\66\217\122\178", "\107\57\54\43\157\21\230\231")];
				v137 = 3;
			end
			if ((v137 == 6) or (2998 >= 3281)) then
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\191\213\175\89\180\198\168", "\219\48\218\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\215\101\121\72\215\91\232\203\94\95", "\128\132\17\28\41\187\47")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\55\18\46\84\15\53\21", "\61\97\82\102\90")][LUAOBFUSACTOR_DECRYPT_STR_0("\137\32\189\78\201\88\19\45\129\9\132\77\193\68\27\29", "\105\204\78\203\43\167\55\126")] or 1;
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\175\55\10\26\10\192\66", "\49\197\202\67\126\115\100\167")][LUAOBFUSACTOR_DECRYPT_STR_0("\26\78\203\32\140\87\74\50\127\242\14\175\80\88\36\94\203", "\62\87\59\191\73\224\54")] or 1;
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\7\238\221\238\12\253\218", "\169\135\98\154")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\123\51\85\228\32\251\222\112\35\81\238\39\239\202\101\54\91\233\54", "\168\171\23\68\52\157\83")];
				v137 = 7;
			end
			if ((v137 == 4) or (4649 <= 2632)) then
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\205\25\223\204\173\208\242", "\129\202\168\109\171\165\195\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\16\89\52\209\223\24\245\13\94\49\255\253\48", "\134\66\56\87\184\190\116")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\52\29\175\16\229\38\38", "\85\92\81\105\219\121\139\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\178\94\76\111\215\210\181\86\98\95\251", "\191\157\211\48\37\28")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\236\26\224\8\51\209\24\231", "\90\191\127\148\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\75\143\47\19\119\144\10\22\118\132\43\56\126\129\9\52\92", "\119\24\231\78")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\40\177\94\213\78\22\145", "\113\226\77\197\42\188\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\14\30\253\166\46\26\241\129\63\23\219\179\60\49\215\145", "\213\90\118\148")];
				v137 = 5;
			end
			if ((v137 == 8) or (3860 > 4872)) then
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\182\183\39\31\65\64\142\150", "\233\229\210\83\107\40\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\229\71\51\194\13\204\67\32\221\42\199\68\21\245\33", "\101\161\34\82\182")];
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\8\77\234\210\236\133\61", "\78\136\109\57\158\187\130\226")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\49\253\248\45\60\235\248\51\54\247\240\42\58\218\240\44\49\248\246\59\16\255\247\25\28\221", "\145\94\95\153")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\200\0\193\71\185\250\222", "\215\157\173\116\181\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\189\136\249\245\51\178\172\209\254", "\186\85\212\235\146")];
				break;
			end
			if ((v137 == 0) or (3998 == 2298)) then
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\235\177\218\14\224\162\221", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\59\90\10\36\93\241\87\36\76", "\152\54\72\63\88\69\62")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\193\250\72\221\202\233\79", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\77\0\1\34\236\30\81\80\2\25\40\249\27\87\80", "\114\56\62\101\73\71\141")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\236\207\208\177\231\220\215", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\227\48\190\175\240\12\226\233\37\187\169\240\37\211\235\52", "\107\178\134\81\210\198\158")] or 0;
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\10\131\251\195\205\8\178\248\222\202\0\140\223\250", "\170\163\111\226\151")] or 0;
				v137 = 1;
			end
			if ((7 == v137) or (8 >= 2739)) then
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\199\116\225\185\44\35\128\231", "\231\148\17\149\205\69\77")][LUAOBFUSACTOR_DECRYPT_STR_0("\176\168\211\242\88\241\180\190\215\254\100\250\140\162\196\239\82\251", "\159\224\199\167\155\55")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\196\246\40\198\254\253\59\193", "\178\151\147\92")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\229\95\51\28\75\111\133\243\77\38\23\107\89\168", "\26\236\157\44\82\114\44")];
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\43\193\79\35\32\210\72", "\59\74\78\181")][LUAOBFUSACTOR_DECRYPT_STR_0("\14\216\84\93\160\39\208\84\95\148\6\245", "\211\69\177\58\58")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\132\224\109\225\224\197\176\246", "\171\215\133\25\149\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\210\192\59\236\200\19\216", "\34\129\168\82\154\143\80\156")];
				v137 = 8;
			end
			if ((2590 == 2590) and (v137 == 5)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\43\160\66\68\85\41\167", "\45\59\78\212\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\51\89\143\143\164\34\162\255\20\121\133\141\161\13\137", "\144\112\54\227\235\230\78\205")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\45\27\232\217\85\180\59", "\59\211\72\111\156\176")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\134\241\38\75\131\229\34\92\163\230\44\90\143\204\43\72\160\192\9", "\77\46\231\131")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\81\162\84\179\90\177\83", "\32\218\52\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\5\56\165\226\191\75\108\71\22\61\128\193", "\58\46\119\81\200\145\208\37")] or 1;
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\24\137\36\184\160\179\49\56", "\86\75\236\80\204\201\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\84\68\126\139\234\163\66", "\235\18\33\23\229\158")] or 1;
				v137 = 6;
			end
			if ((v137 == 3) or (82 >= 1870)) then
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\142\5\225\176\210\200\200", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\188\132\124\241\112\119\46\166\149\85\209\118\108\61\187\136\67\237", "\24\92\207\225\44\131\25")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\214\172\88\18\115\76\192", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\142\237\13\74\153\248\51\104\141\234\3\104", "\44\221\185\64")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\226\92\75\122\15\224\91", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\85\55\53\42\40\157\84\60\47\6\63\186\89\33\41\58\33\186", "\81\206\60\83\91\79")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\174\196\102\38\205\74\183", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\35\125\23\37\247\252\159\1\90", "\143\216\66\30\126\68\155")];
				v137 = 4;
			end
		end
	end
	local v74 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\225\142\27\243\54\224\75", "\56\162\225\118\158\89\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\19\197\189\59\215\82\0", "\184\60\101\160\207\66")];
	local v75 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\18\141\113\177\62\140\111", "\220\81\226\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\218\133\238\239", "\167\115\181\226\155\138")];
	local v76 = v16[LUAOBFUSACTOR_DECRYPT_STR_0("\208\45\224\73\126", "\166\130\66\135\60\27\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\101\89\221\116\35\87\67\192\116\36\77\69\192", "\80\36\42\174\21")];
	local v77 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\124\31\48\111\75", "\26\46\112\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\48\184\117\172\172\76\186\184\55\162\123\177", "\212\217\67\203\20\223\223\37")];
	local v78 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\136\130\175\199\191", "\178\218\237\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\151\166\245\209\165\166\239\222\183\161\239\223\184", "\176\214\213\134")];
	local v79 = {v78[LUAOBFUSACTOR_DECRYPT_STR_0("\213\161\177\209\188\94\88\230\157\163\206\178\90\92\214\162\174", "\57\148\205\214\180\200\54")],v78[LUAOBFUSACTOR_DECRYPT_STR_0("\51\238\61\49\101\29\251\33\60\115\55\240\55\49\100\1\242\32\56", "\22\114\157\85\84")],v78[LUAOBFUSACTOR_DECRYPT_STR_0("\243\194\7\204\88\228\170\197\217\24\215\127\228\169\202\200\27", "\200\164\171\115\164\61\150")]};
	local v80, v81, v82, v83;
	local v84, v85, v86, v87;
	local v88;
	local v89, v90 = 2 * v14:SpellHaste(), 1 * v14:SpellHaste();
	local v91, v92;
	local v93, v94, v95, v96, v97, v98, v99;
	local v100;
	local v101, v102, v103, v104, v105, v106, v107, v108;
	local v109 = 0;
	local v110 = v14:GetEquipment();
	local v111 = (v110[13] and v18(v110[13])) or v18(0);
	local v112 = (v110[14] and v18(v110[14])) or v18(0);
	local function v113()
		if ((2624 < 4557) and v111:HasStatAnyDps() and (not v112:HasStatAnyDps() or (v111:Cooldown() >= v112:Cooldown()))) then
			v109 = 1;
		elseif ((v112:HasStatAnyDps() and (not v111:HasStatAnyDps() or (v112:Cooldown() > v111:Cooldown()))) or (3131 > 3542)) then
			v109 = 2;
		else
			v109 = 0;
		end
	end
	v113();
	v10:RegisterForEvent(function()
		local v138 = 0;
		while true do
			if ((2577 >= 1578) and (v138 == 1)) then
				v112 = (v110[14] and v18(v110[14])) or v18(0);
				v113();
				break;
			end
			if ((4103 <= 4571) and (v138 == 0)) then
				v110 = v14:GetEquipment();
				v111 = (v110[13] and v18(v110[13])) or v18(0);
				v138 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\142\216\34\124\166\140\203\38\116\182\151\196\46\96\173\138\203\32\109\162\144\211\38\97", "\227\222\148\99\37"));
	local v114 = {{v76[LUAOBFUSACTOR_DECRYPT_STR_0("\17\94\91\248\253", "\153\83\50\50\150")],LUAOBFUSACTOR_DECRYPT_STR_0("\126\119\96\8\51\137\65\84\120\119\92\59\130\67\73\115\97\14\102\187\89\20", "\45\61\22\19\124\19\203"),function()
		return true;
	end},{v76[LUAOBFUSACTOR_DECRYPT_STR_0("\234\27\9\251\7\105\138\201\29\25", "\217\161\114\109\149\98\16")],LUAOBFUSACTOR_DECRYPT_STR_0("\49\33\43\104\252\95\27\36\54\121\165\52\33\40\55\104\252\60\59\46\44\121\174\102\7\48\44\53", "\20\114\64\88\28\220"),function()
		return v91 > 0;
	end}};
	v76[LUAOBFUSACTOR_DECRYPT_STR_0("\20\15\196\177\246\223\176", "\221\81\97\178\212\152\176")]:RegisterDamageFormula(function()
		return v14:AttackPowerDamageMod() * v91 * 0.22 * 1 * ((v15:DebuffUp(v76.ShivDebuff) and 1.3) or 1) * ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\233\226\24\235\31\223\212\9\233\27\217\230\26\254\23", "\122\173\135\125\155")]:IsAvailable() and 1.05) or 1) * (1 + (v14:MasteryPct() / 100)) * (1 + (v14:VersatilityDmgPct() / 100));
	end);
	v76[LUAOBFUSACTOR_DECRYPT_STR_0("\169\212\20\176\51\48\220\129", "\168\228\161\96\217\95\81")]:RegisterDamageFormula(function()
		return (v14:AttackPowerDamageMod() + v14:AttackPowerDamageMod(true)) * 0.485 * 1 * (1 + (v14:VersatilityDmgPct() / 100));
	end);
	local function v115()
		return v14:BuffRemains(v76.MasterAssassinBuff) == 9999;
	end
	local function v116()
		local v139 = 0;
		while true do
			if ((v139 == 0) or (1495 == 4787)) then
				if (v115() or (310 > 4434)) then
					return v14:GCDRemains() + 3;
				end
				return v14:BuffRemains(v76.MasterAssassinBuff);
			end
		end
	end
	local function v117()
		local v140 = 0;
		while true do
			if ((2168 <= 4360) and (v140 == 0)) then
				if ((994 == 994) and v14:BuffUp(v76.ImprovedGarroteAura)) then
					return v14:GCDRemains() + 3;
				end
				return v14:BuffRemains(v76.ImprovedGarroteBuff);
			end
		end
	end
	local function v118()
		local v141 = 0;
		while true do
			if ((1655 > 401) and (v141 == 0)) then
				if ((3063 <= 3426) and v14:BuffUp(v76.IndiscriminateCarnageAura)) then
					return v14:GCDRemains() + 10;
				end
				return v14:BuffRemains(v76.IndiscriminateCarnageBuff);
			end
		end
	end
	local function v46()
		local v142 = 0;
		while true do
			if ((1459 > 764) and (v142 == 0)) then
				if ((v86 < 2) or (641 > 4334)) then
					return false;
				elseif ((3399 >= 2260) and (v46 == LUAOBFUSACTOR_DECRYPT_STR_0("\250\221\57\93\54\68", "\55\187\177\78\60\79"))) then
					return true;
				elseif (((v46 == LUAOBFUSACTOR_DECRYPT_STR_0("\2\192\31\201\73\220\147\40\221", "\224\77\174\63\139\38\175")) and v15:IsInBossList()) or (393 >= 4242)) then
					return true;
				elseif ((989 < 4859) and (v46 == LUAOBFUSACTOR_DECRYPT_STR_0("\165\84\76\33", "\78\228\33\56"))) then
					if (((v14:InstanceDifficulty() == 16) and (v15:NPCID() == 138967)) or (4795 < 949)) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v119()
		local v143 = 0;
		while true do
			if ((3842 == 3842) and (v143 == 0)) then
				if ((1747 <= 3601) and (v15:DebuffUp(v76.Deathmark) or v15:DebuffUp(v76.Kingsbane) or v14:BuffUp(v76.ShadowDanceBuff) or v15:DebuffUp(v76.ShivDebuff) or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\250\118\187\16\145\194\123\134\6\132", "\229\174\30\210\99")]:FullRechargeTime() < 20) or (v14:EnergyPercentage() >= 80) or (v14:HasTier(31, 4) and ((v14:BuffUp(v76.Envenom) and (v14:BuffRemains(v76.Envenom) <= 2)) or v10.BossFilteredFightRemains(LUAOBFUSACTOR_DECRYPT_STR_0("\71\176", "\89\123\141\230\49\141\93"), 90))))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v120()
		local v144 = 0;
		while true do
			if ((0 == v144) or (804 > 4359)) then
				if ((4670 >= 3623) and (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\215\116\247\24\24\71\242\99\253", "\42\147\17\150\108\112")]:CooldownRemains() > v76[LUAOBFUSACTOR_DECRYPT_STR_0("\60\163\61\108\238\251", "\136\111\198\77\31\135")]:CooldownRemains()) and (v10.BossFightRemainsIsNotValid() or v10.BossFilteredFightRemains(">", v76[LUAOBFUSACTOR_DECRYPT_STR_0("\38\12\166\66\181\233\22\187\9", "\201\98\105\199\54\221\132\119")]:CooldownRemains()))) then
					return v76[LUAOBFUSACTOR_DECRYPT_STR_0("\157\9\130\53\10\56\173\171\7", "\204\217\108\227\65\98\85")]:CooldownRemains();
				end
				return v76[LUAOBFUSACTOR_DECRYPT_STR_0("\109\198\229\246\37\211", "\160\62\163\149\133\76")]:CooldownRemains();
			end
		end
	end
	local function v121()
		local v145 = 0;
		while true do
			if ((2065 < 2544) and (v145 == 0)) then
				if ((1311 <= 3359) and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\229\163\8\33\215\249\166\47\35\204\217\164", "\163\182\192\109\79")]:IsAvailable()) then
					return true;
				end
				return v14:BuffStack(v76.ScentOfBloodBuff) >= v23(20, v76[LUAOBFUSACTOR_DECRYPT_STR_0("\7\37\5\206\225\27\32\34\204\250\59\34", "\149\84\70\96\160")]:TalentRank() * 2 * v86);
			end
		end
	end
	local function v122(v146, v147, v148)
		local v149 = 0;
		local v148;
		while true do
			if ((2717 <= 3156) and (v149 == 0)) then
				v148 = v148 or v147:PandemicThreshold();
				return v146:DebuffRefreshable(v147, v148);
			end
		end
	end
	local function v123(v150, v151, v152, v153)
		local v154 = 0;
		local v155;
		local v156;
		local v157;
		while true do
			if ((1081 < 4524) and (v154 == 0)) then
				v155, v156 = nil, v152;
				v157 = v15:GUID();
				v154 = 1;
			end
			if ((440 >= 71) and (v154 == 1)) then
				for v213, v214 in v30(v153) do
					if ((4934 > 2607) and (v214:GUID() ~= v157) and v74.UnitIsCycleValid(v214, v156, -v214:DebuffRemains(v150)) and v151(v214)) then
						v155, v156 = v214, v214:TimeToDie();
					end
				end
				if (v155 or (1400 > 3116)) then
					v20(v155, v150);
				elseif ((525 < 1662) and v45) then
					local v245 = 0;
					while true do
						if ((v245 == 1) or (876 > 2550)) then
							if ((219 <= 2456) and v155) then
								v20(v155, v150);
							end
							break;
						end
						if ((v245 == 0) or (4219 == 1150)) then
							v155, v156 = nil, v152;
							for v263, v264 in v30(v85) do
								if (((v264:GUID() ~= v157) and v74.UnitIsCycleValid(v264, v156, -v264:DebuffRemains(v150)) and v151(v264)) or (2989 <= 222)) then
									v155, v156 = v264, v264:TimeToDie();
								end
							end
							v245 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v124(v158, v159, v160)
		local v161 = 0;
		local v162;
		local v163;
		local v164;
		local v165;
		while true do
			if ((2258 > 1241) and (v161 == 2)) then
				function v165(v215)
					for v216, v217 in v30(v215) do
						local v218 = 0;
						local v219;
						while true do
							if ((41 < 4259) and (v218 == 0)) then
								v219 = v159(v217);
								if ((not v163 and (v158 == LUAOBFUSACTOR_DECRYPT_STR_0("\181\90\216\99\14", "\161\211\51\170\16\122\93\53"))) or (1930 < 56)) then
									if ((3333 == 3333) and (v219 ~= 0)) then
										v163, v164 = v217, v219;
									end
								elseif ((v158 == LUAOBFUSACTOR_DECRYPT_STR_0("\246\167\188", "\72\155\206\210")) or (2225 == 20)) then
									if (not v163 or (v219 < v164) or (872 >= 3092)) then
										v163, v164 = v217, v219;
									end
								elseif ((4404 >= 3252) and (v158 == LUAOBFUSACTOR_DECRYPT_STR_0("\75\123\76", "\83\38\26\52\110"))) then
									if ((1107 > 796) and (not v163 or (v219 > v164))) then
										v163, v164 = v217, v219;
									end
								end
								v218 = 1;
							end
							if ((959 == 959) and (v218 == 1)) then
								if ((v163 and (v219 == v164) and (v217:TimeToDie() > v163:TimeToDie())) or (245 >= 2204)) then
									v163, v164 = v217, v219;
								end
								break;
							end
						end
					end
				end
				v165(v87);
				v161 = 3;
			end
			if ((3162 >= 2069) and (v161 == 0)) then
				v162 = v159(v15);
				if (((v158 == LUAOBFUSACTOR_DECRYPT_STR_0("\62\15\31\254\44", "\141\88\102\109")) and (v162 ~= 0)) or (306 > 3081)) then
					return v15;
				end
				v161 = 1;
			end
			if ((v161 == 3) or (3513 < 2706)) then
				if ((2978 < 3639) and v45) then
					v165(v85);
				end
				if ((3682 >= 2888) and v163 and (v164 == v162) and v160(v15)) then
					return v15;
				end
				v161 = 4;
			end
			if ((149 < 479) and (v161 == 1)) then
				v163, v164 = nil, 0;
				v165 = nil;
				v161 = 2;
			end
			if ((1020 >= 567) and (v161 == 4)) then
				if ((v163 and v160(v163)) or (733 > 2469)) then
					return v163;
				end
				return nil;
			end
		end
	end
	local function v125(v166, v167, v168)
		local v169 = 0;
		local v170;
		while true do
			if ((2497 == 2497) and (v169 == 0)) then
				v170 = v15:TimeToDie();
				if ((3901 == 3901) and not v10.BossFightRemainsIsNotValid()) then
					v170 = v10.BossFightRemains();
				elseif ((201 < 415) and (v170 < v168)) then
					return false;
				end
				v169 = 1;
			end
			if ((v169 == 1) or (133 == 1784)) then
				if ((v31((v170 - v168) / v166) > v31(((v170 - v168) - v167) / v166)) or (7 >= 310)) then
					return true;
				end
				return false;
			end
		end
	end
	local function v126(v171)
		local v172 = 0;
		while true do
			if ((4992 > 286) and (v172 == 0)) then
				if (v171:DebuffUp(v76.SerratedBoneSpikeDebuff) or (2561 == 3893)) then
					return 1000000;
				end
				return v171:TimeToDie();
			end
		end
	end
	local function v127(v173)
		return not v173:DebuffUp(v76.SerratedBoneSpikeDebuff);
	end
	local function v128()
		local v174 = 0;
		while true do
			if ((4362 >= 1421) and (v174 == 1)) then
				if ((75 <= 3546) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\170\53\86\231\81\14\131\51\64", "\98\236\92\36\130\51")]:IsCastable()) then
					if ((2680 <= 3418) and v10.Press(v76.Fireblood, v54)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\24\31\174\5\142\188\34\161\27\0\181\74\172", "\80\196\121\108\218\37\200\213");
					end
				end
				if (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\33\125\1\122\88\26\152\1\127\33\126\71\2", "\234\96\19\98\31\43\110")]:IsCastable() or (4288 < 2876)) then
					if ((2462 >= 1147) and ((not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\45\22\92\192\191\112\138\8\26", "\235\102\127\50\167\204\18")]:IsAvailable() and v15:DebuffUp(v76.ShivDebuff)) or (v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) < 8)))) then
						if (v10.Press(v76.AncestralCall, v54) or (4914 < 2480)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\115\160\230\55\4\15\94\162\240\48\80\60\81\173\181\0\69\34\92", "\78\48\193\149\67\36");
						end
					end
				end
				v174 = 2;
			end
			if ((2 == v174) or (1559 == 1240)) then
				return false;
			end
			if ((566 == 566) and (v174 == 0)) then
				if ((3921 >= 3009) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\122\27\40\73\92\49\50\84\65", "\38\56\119\71")]:IsCastable()) then
					if ((2063 >= 1648) and v10.Press(v76.BloodFury, v54)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\238\75\194\101\116\255\224\87\210\101\112\230\253\65", "\54\147\143\56\182\69");
					end
				end
				if ((1066 >= 452) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\244\132\237\90\218\196\138\246\71\216", "\191\182\225\159\41")]:IsCastable()) then
					if ((4974 >= 2655) and v10.Press(v76.Berserking, v54)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\19\59\65\203\165\199\57\1\45\71\128\142\204\44", "\162\75\114\72\53\235\231");
					end
				end
				v174 = 1;
			end
		end
	end
	local function v129()
		local v175 = 0;
		while true do
			if ((v175 == 0) or (2721 <= 907)) then
				if ((4437 >= 3031) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\3\22\129\28\78\39\58\129\22\66\53", "\33\80\126\224\120")]:IsCastable() and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\199\161\13\195\79\238\169\13\193", "\60\140\200\99\164")]:IsAvailable()) then
					local v220 = 0;
					while true do
						if ((v220 == 0) or (4470 < 2949)) then
							if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\174\249\20\52\173\145\241\0\1\163\149\230\11\50\167", "\194\231\148\100\70")]:IsAvailable() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\97\77\211\177\249\220\67", "\168\38\44\161\195\150")]:CooldownUp() and ((v15:PMultiplier(v76.Garrote) <= 1) or v122(v15, v76.Garrote)) and (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\164\249\131\98\56\229\183\4\139", "\118\224\156\226\22\80\136\214")]:AnyDebuffUp() or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\102\235\88\148\74\227\88\146\73", "\224\34\142\57")]:CooldownRemains() < 12) or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\250\162\196\201\123\252\92\28\213", "\110\190\199\165\189\19\145\61")]:CooldownRemains() > 60)) and (v92 >= math.min(v86, 4))) or (1580 == 2426)) then
								local v253 = 0;
								while true do
									if ((v253 == 0) or (3711 == 503)) then
										if ((v50 and (v14:EnergyPredicted() < 45)) or (420 == 4318)) then
											if (v20(v76.PoolEnergy) or (4158 <= 33)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\234\228\120\228\203\193\213\249\55\219\131\198\222\228\96\168\175\198\212\232\114\168\195\224\219\249\101\231\159\194\147", "\167\186\139\23\136\235");
											end
										end
										if (v20(v76.ShadowDance, v56) or (99 > 4744)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\57\180\155\25\90\134\128\12\30\186\159\77\62\180\134\14\31\245\192\42\27\167\154\2\14\176\193", "\109\122\213\232");
										end
										break;
									end
								end
							end
							if ((4341 == 4341) and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\199\250\178\34\225\225\167\52\201\246\176\34\225\227\167", "\80\142\151\194")]:IsAvailable() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\46\199\100\88\6\212\86\95\16\199\100\95\10\200", "\44\99\166\23")]:IsAvailable() and not v122(v15, v76.Rupture) and (v15:DebuffRemains(v76.Garrote) > 3) and (v15:DebuffUp(v76.Deathmark) or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\88\242\40\34\59\169\125\229\34", "\196\28\151\73\86\83")]:CooldownRemains() > 60)) and (v15:DebuffUp(v76.ShivDebuff) or (v15:DebuffRemains(v76.Deathmark) < 4) or v15:DebuffUp(v76.Sepsis)) and (v15:DebuffRemains(v76.Sepsis) < 3)) then
								if ((255 <= 1596) and v20(v76.ShadowDance, v56)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\208\2\58\4\194\107\16\119\247\12\62\80\166\89\22\117\246\67\97\61\131\75\12\115\225\67\8\3\145\89\11\101\250\13\96", "\22\147\99\73\112\226\56\120");
								end
							end
							break;
						end
					end
				end
				if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\142\116\236\252\158\176", "\237\216\21\130\149")]:IsCastable() and not v14:IsTanking(v15)) or (4433 < 1635)) then
					local v221 = 0;
					while true do
						if ((v221 == 1) or (4300 < 3244)) then
							if ((not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\126\85\20\204\88\78\1\218\112\89\22\204\88\76\1", "\190\55\56\100")]:IsAvailable() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\123\174\47\10\22\241\210\69\188\61\13\0\234\253", "\147\54\207\92\126\115\131")]:IsAvailable() and not v122(v15, v76.Rupture) and (v15:DebuffRemains(v76.Garrote) > 3) and v15:DebuffUp(v76.Deathmark) and (v15:DebuffUp(v76.ShivDebuff) or (v15:DebuffRemains(v76.Deathmark) < 4) or v15:DebuffUp(v76.Sepsis)) and (v15:DebuffRemains(v76.Sepsis) < 3)) or (3534 > 4677)) then
								if (v20(v76.Vanish, v55) or (4859 < 2999)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\46\48\38\105\77\72\12\63\60\110\5\62\69\28\52\110\25\123\31\113\20\110\30\127\30\34\60\115\68", "\30\109\81\85\29\109");
								end
							end
							break;
						end
						if ((4726 > 2407) and (0 == v221)) then
							if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\171\67\79\77\191\223\91\134\105\94\77\162\198\74\135", "\62\226\46\63\63\208\169")]:IsAvailable() and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\200\24\70\151\26\31\14\77\246\24\70\144\22\3", "\62\133\121\53\227\127\109\79")]:IsAvailable() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\55\21\32\231\217\186\167", "\194\112\116\82\149\182\206")]:CooldownUp() and ((v15:PMultiplier(v76.Garrote) <= 1) or v122(v15, v76.Garrote))) or (1284 > 3669)) then
								local v254 = 0;
								while true do
									if ((1117 < 2549) and (v254 == 0)) then
										if ((not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\16\166\72\17\211\225\28\48\165\69\22\193\246\11\26\169\94\22\193\229\11", "\110\89\200\44\120\160\130")]:IsAvailable() and (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\143\198\74\82\75\71\58\95\160", "\45\203\163\43\38\35\42\91")]:AnyDebuffUp() or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\246\128\221\55\143\164\85\192\142", "\52\178\229\188\67\231\201")]:CooldownRemains() < 4)) and (v92 >= v23(v86, 4))) or (2851 > 4774)) then
											local v267 = 0;
											while true do
												if ((1031 < 3848) and (v267 == 0)) then
													if ((1854 > 903) and v50 and (v14:EnergyPredicted() < 45)) then
														if ((4663 > 1860) and v20(v76.PoolEnergy)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\17\78\95\8\183\90\44\51\1\102\5\249\85\48\41\1\24\35\246\78\49\46\85\85\68\211\89\34\53\73\93\5\229\87\106", "\67\65\33\48\100\151\60");
														end
													end
													if (v20(v76.Vanish, v55) or (3053 <= 469)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\252\230\189\204\179\233\230\160\209\224\215\167\230\255\242\205\245\161\204\246\159\195\171\217\231\215\234\175\202\248\150", "\147\191\135\206\184");
													end
													break;
												end
											end
										end
										if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\173\38\162\200\203\80\160\141\37\175\207\217\71\183\167\41\180\207\217\84\183", "\210\228\72\198\161\184\51")]:IsAvailable() and (v86 > 2)) or (540 >= 1869)) then
											local v268 = 0;
											while true do
												if ((3292 == 3292) and (v268 == 0)) then
													if ((1038 <= 2645) and v50 and (v14:EnergyPredicted() < 45)) then
														if (v20(v76.PoolEnergy) or (3230 < 2525)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\6\70\252\28\51\200\57\91\179\38\114\192\63\90\251\80\59\233\55\91\225\31\103\203\118\109\246\17\103\198\59\72\225\27\58", "\174\86\41\147\112\19");
														end
													end
													if (v20(v76.Vanish, v55) or (2400 > 4083)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\120\1\158\31\101\57\16\165\82\19\133\75\109\40\16\185\73\15\153\14\101\44\29\174\90\22\136\66", "\203\59\96\237\107\69\111\113");
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\9\23\191\245\52\226\246\55\5\173\242\34\249\217", "\183\68\118\204\129\81\144")]:IsAvailable() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\37\164\126\227\24\128\15\163\117", "\226\110\205\16\132\107")]:IsAvailable() and v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) <= 3) and v15:DebuffUp(v76.Deathmark) and (v15:DebuffRemains(v76.Deathmark) <= 3)) or (2745 > 4359)) then
								if ((172 <= 1810) and v20(v76.Vanish, v55)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\200\194\243\205\1\221\194\238\208\82\227\131\168\242\72\229\196\243\219\64\229\198\169", "\33\139\163\128\185");
								end
							end
							v221 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v130()
		local v176 = 0;
		while true do
			if ((v176 == 1) or (492 >= 4959)) then
				v88 = v74.HandleBottomTrinket(v79, v28, 40, nil);
				if (v88 or (756 == 2072)) then
					return v88;
				end
				break;
			end
			if ((1605 <= 4664) and (v176 == 0)) then
				v88 = v74.HandleTopTrinket(v79, v28, 40, nil);
				if ((1816 == 1816) and v88) then
					return v88;
				end
				v176 = 1;
			end
		end
	end
	local function v131()
		local v177 = 0;
		local v178;
		while true do
			if ((v177 == 2) or (621 > 3100)) then
				if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\1\133\114\76\198\163\177\236\48\140", "\184\85\237\27\63\178\207\212")]:IsCastable() and not v14:BuffUp(v76.ThistleTea) and (((v14:EnergyDeficit() >= (100 + v104)) and (not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\35\80\7\88\27\91\8\81\13", "\63\104\57\105")]:IsAvailable() or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\63\143\173\87\31\139\161\112\14\134", "\36\107\231\196")]:Charges() >= 2))) or (v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) < 6)) or (not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\118\188\172\128\78\183\163\137\88", "\231\61\213\194")]:IsAvailable() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\45\168\60\103\1\160\60\97\2", "\19\105\205\93")]:AnyDebuffUp()) or v10.BossFilteredFightRemains("<", v76[LUAOBFUSACTOR_DECRYPT_STR_0("\157\0\215\146\43\165\13\234\132\62", "\95\201\104\190\225")]:Charges() * 6))) or (1157 >= 4225)) then
					if (v10.Cast(v76.ThistleTea, v57) or (4986 == 4138)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\140\202\210\218\239\255\201\199\188\223\205\203\239\255\196\207", "\174\207\171\161");
					end
				end
				if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\201\251\12\231\240\218\236\236\6", "\183\141\158\109\147\152")]:AnyDebuffUp() and (not v88 or v54)) or (2033 <= 224)) then
					if (v88 or (1223 == 2011)) then
						v128();
					else
						v88 = v128();
					end
				end
				if ((4827 > 4695) and not v14:StealthUp(true, true) and (v117() <= 0) and (v116() <= 0)) then
					if ((3710 > 3065) and v88) then
						v129();
					else
						v88 = v129();
					end
				end
				if ((2135 <= 2696) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\15\6\234\8\14\5\233\3\40", "\108\76\105\134")]:IsReady() and v14:DebuffDown(v76.ColdBlood) and (v91 >= 4) and (v58 or not v88)) then
					if (v10.Press(v76.ColdBlood, v58) or (1742 > 4397)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\200\196\162\245\142\200\202\189\229\142\201\201\190\238\202", "\174\139\165\209\129");
					end
				end
				v177 = 3;
			end
			if ((3900 >= 1904) and (v177 == 0)) then
				if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\204\116\68\165\63\205", "\156\159\17\52\214\86\190")]:IsReady() and (v15:DebuffRemains(v76.Rupture) > 20) and ((not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\135\226\173\174\161\249\184\184\137\238\175\174\161\251\184", "\220\206\143\221")]:IsAvailable() and v15:DebuffUp(v76.Garrote)) or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\175\112\61\5\215\218\215\130\90\44\5\202\195\198\131", "\178\230\29\77\119\184\172")]:IsAvailable() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\210\191\24\9\120\236\240", "\152\149\222\106\123\23")]:CooldownUp() and (v15:PMultiplier(v76.Garrote) <= 1))) and (v15:FilteredTimeToDie(">", 10) or v10.BossFilteredFightRemains(LUAOBFUSACTOR_DECRYPT_STR_0("\129\123", "\213\189\70\150\35"), 10))) or (1724 == 909)) then
					if ((1282 < 1421) and v20(v76.Sepsis, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\108\84\103\28\15\102\113\24\92\92\103", "\104\47\53\20");
					end
				end
				v88 = v130();
				if ((4876 >= 4337) and v88) then
					return v88;
				end
				v178 = not v14:StealthUp(true, false) and v15:DebuffUp(v76.Rupture) and v14:BuffUp(v76.Envenom) and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\135\73\128\8\180\2\162\94\138", "\111\195\44\225\124\220")]:AnyDebuffUp() and (not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\245\71\19\103\174\185\249\85\19\114\184\184\209\72", "\203\184\38\96\19\203")]:IsAvailable() or v15:DebuffUp(v76.Garrote)) and (not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\18\122\119\70\221\59\114\119\68", "\174\89\19\25\33")]:IsAvailable() or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\4\27\92\73\228\133\10\33\23", "\107\79\114\50\46\151\231")]:CooldownRemains() <= 2));
				v177 = 1;
			end
			if ((4005 >= 3005) and (v177 == 1)) then
				if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\29\163\180\61\130\52\182\210\50", "\160\89\198\213\73\234\89\215")]:IsCastable() and (v178 or v10.BossFilteredFightRemains(LUAOBFUSACTOR_DECRYPT_STR_0("\20\44", "\165\40\17\212\158"), 20))) or (4781 <= 4448)) then
					if ((1317 > 172) and v20(v76.Deathmark, v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\198\216\27\39\102\193\220\9\39\46\232\216\26\56", "\70\133\185\104\83");
					end
				end
				if ((4791 == 4791) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\55\77\77\60", "\169\100\37\36\74")]:IsReady() and not v15:DebuffUp(v76.ShivDebuff) and v15:DebuffUp(v76.Garrote) and v15:DebuffUp(v76.Rupture)) then
					local v222 = 0;
					while true do
						if ((3988 > 1261) and (v222 == 0)) then
							if ((2240 <= 3616) and v10.BossFilteredFightRemains(LUAOBFUSACTOR_DECRYPT_STR_0("\92\218", "\48\96\231\194"), v76[LUAOBFUSACTOR_DECRYPT_STR_0("\251\82\7\59", "\227\168\58\110\77\121\184\207")]:Charges() * 8)) then
								if (v20(v76.Shiv) or (3988 < 3947)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\88\61\172\84\241\232\121\172\109\124\247\101\191\223\49\170\125\124\153\73\182\211\101\236", "\197\27\92\223\32\209\187\17");
								end
							end
							if ((4644 == 4644) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\40\86\205\252\16\93\194\245\6", "\155\99\63\163")]:IsAvailable() and v14:BuffUp(v76.Envenom)) then
								local v255 = 0;
								while true do
									if ((1323 > 1271) and (v255 == 0)) then
										if ((1619 > 1457) and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\174\216\166\133\173\147\135\216\166\133\173\183\138\216\183", "\228\226\177\193\237\217")]:IsAvailable() and ((v15:DebuffUp(v76.Kingsbane) and (v15:DebuffRemains(v76.Kingsbane) < 8)) or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\31\185\45\225\39\178\34\232\49", "\134\84\208\67")]:CooldownRemains() >= 24)) and (not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\48\190\143\81\0\163\136\104\22\161\150\89\0\184", "\60\115\204\230")]:IsAvailable() or v107 or v15:DebuffUp(v76.CrimsonTempest))) then
											if (v20(v76.Shiv) or (2860 < 1808)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\196\59\248\100\167\9\227\121\241\122\163\91\238\52\236\99\229\59\229\117\174", "\16\135\90\139");
											end
										end
										if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\120\125\1\59\90\67\125\93\115\14\39\125\92\113\66", "\24\52\20\102\83\46\52")]:IsAvailable() and (v15:DebuffUp(v76.Kingsbane) or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\239\38\47\35\28\198\46\47\33", "\111\164\79\65\68")]:CooldownRemains() <= 1))) or (739 >= 1809)) then
											if ((1539 <= 4148) and v20(v76.Shiv)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\229\216\144\202\110\217\206\208\149\158\102\193\207\215\132\205\44\235\200\220\195\242\39\237\206\205\148\219\39\237\206\205\202", "\138\166\185\227\190\78");
											end
										end
										break;
									end
								end
							end
							v222 = 1;
						end
						if ((v222 == 1) or (434 > 3050)) then
							if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\234\102\209\50\64\42\24\199\68\215\50\81\42\10\194\123\203", "\121\171\20\165\87\50\67")]:IsAvailable() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\226\61\184\34\177\15\199\42\178", "\98\166\88\217\86\217")]:AnyDebuffUp()) or (3054 < 1683)) then
								if ((47 < 2706) and v20(v76.Shi)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\213\247\106\21\198\239\254\255\111\65\206\253\228\226\124\19\143\221\250\182\73\19\131\223\255\229\112\14\136\149", "\188\150\150\25\97\230");
								end
							end
							if ((1519 >= 580) and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\241\128\81\5\31\239\219\135\90", "\141\186\233\63\98\108")]:IsAvailable() and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\208\248\56\179\55\248\235\32\134\55\244\233\37\165\44\254\228", "\69\145\138\76\214")]:IsAvailable()) then
								if (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\67\202\153\154\182\5", "\118\16\175\233\233\223")]:IsAvailable() or (3110 == 4177)) then
									if ((4200 > 2076) and (((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\184\140\60\173", "\29\235\228\85\219\142\235")]:ChargesFractional() > (0.9 + v21(v76[LUAOBFUSACTOR_DECRYPT_STR_0("\17\221\189\213\99\89\34\91\58\220\174\238\127\71\49", "\50\93\180\218\189\23\46\71")]:IsAvailable()))) and (v102 > 5)) or v15:DebuffUp(v76.Sepsis) or v15:DebuffUp(v76.Deathmark))) then
										if (v20(v76.Shiv) or (601 >= 2346)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\253\165\72\88\4\239\64\215\178\27\4\119\217\88\205\173\72\5", "\40\190\196\59\44\36\188");
										end
									end
								elseif ((3970 <= 4354) and (not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\31\87\213\185\233\114\3\8\64\209\164\255\110\25", "\109\92\37\188\212\154\29")]:IsAvailable() or v107 or v15:DebuffUp(v76.CrimsonTempest))) then
									if (v20(v76.Shiv) or (1542 < 208)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\39\238\183\215\113\105\12\230\178", "\58\100\143\196\163\81");
									end
								end
							end
							break;
						end
					end
				end
				if ((1612 <= 2926) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\41\74\34\167\48\94\193\15\20\65\38", "\110\122\34\67\195\95\41\133")]:IsCastable() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\94\184\85\77\197\119\176\85\79", "\182\21\209\59\42")]:IsAvailable() and v14:BuffUp(v76.Envenom) and ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\147\82\196\9\41\179\182\69\206", "\222\215\55\165\125\65")]:CooldownRemains() >= 50) or v178)) then
					if (v20(v76.ShadowDance, v56) or (2006 <= 540)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\15\208\213\14\178\242\229\75\40\222\209\90\214\192\227\73\41\145\142\49\251\207\234\89\46\208\200\31\178\242\244\68\47\152", "\42\76\177\166\122\146\161\141");
					end
				end
				if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\142\131\11\201\106\116\164\132\0", "\22\197\234\101\174\25")]:IsReady() and (v15:DebuffUp(v76.ShivDebuff) or (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\30\60\172\202", "\230\77\84\197\188\22\207\183")]:CooldownRemains() < 6)) and v14:BuffUp(v76.Envenom) and ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\221\17\199\232\132\172\241\39\242", "\85\153\116\166\156\236\193\144")]:CooldownRemains() >= 50) or v15:DebuffUp(v76.Deathmark))) or (2412 == 4677)) then
					if (v20(v76.Kingsbane, v68) or (4897 <= 1972)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\225\94\167\164\43\173\238\74\160\230\1\170\229", "\96\196\128\45\211\132");
					end
				end
				v177 = 2;
			end
			if ((3101 <= 3584) and (v177 == 3)) then
				return v88;
			end
		end
	end
	local function v132()
		local v179 = 0;
		while true do
			if ((0 == v179) or (1568 >= 4543)) then
				if ((4258 >= 1841) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\136\186\236\198\213\1\113\118\166", "\24\195\211\130\161\166\99\16")]:IsAvailable() and v14:BuffUp(v76.Envenom)) then
					local v223 = 0;
					while true do
						if ((v223 == 0) or (3052 >= 3554)) then
							if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\117\11\224\58", "\118\38\99\137\76\51")]:IsReady() and (v15:DebuffUp(v76.Kingsbane) or v76[LUAOBFUSACTOR_DECRYPT_STR_0("\214\47\11\21\26\34\252\40\0", "\64\157\70\101\114\105")]:CooldownUp()) and v15:DebuffDown(v76.ShivDebuff)) or (2098 > 3885)) then
								if (v20(v76.Shiv) or (2970 == 1172)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\99\169\180\247\80\115\160\174\245\80\8\155\179\230\17\76\188\175\163\59\73\166\160\240\18\65\166\162\170", "\112\32\200\199\131");
								end
							end
							if ((3913 > 3881) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\7\89\82\191\208\169\35\34\85", "\66\76\48\60\216\163\203")]:IsReady() and (v14:BuffRemains(v76.ShadowDanceBuff) >= 2)) then
								if ((4932 >= 1750) and v20(v76.Kingsbane, v68)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\153\135\106\231\31\229\45\180\129\106\241\94\192\33\250\206\93\242\81\205\33\243", "\68\218\230\25\147\63\174");
								end
							end
							break;
						end
					end
				end
				if ((v91 >= 4) or (135 == 1669)) then
					local v224 = 0;
					while true do
						if ((4802 >= 109) and (v224 == 0)) then
							if ((v15:DebuffUp(v76.Kingsbane) and (v14:BuffRemains(v76.Envenom) <= 2)) or (3911 > 4952)) then
								if (v20(v76.Envenom, nil, nil, not v82) or (265 > 4194)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\142\43\64\88\246\136\36\69\73\184\162\39\19\4\133\185\47\82\64\162\165\106\120\69\184\170\57\81\77\184\168\99", "\214\205\74\51\44");
								end
							end
							if ((2655 <= 2908) and v107 and v115() and v14:BuffDown(v76.ShadowDanceBuff)) then
								if ((963 > 651) and v20(v76.Envenom, nil, nil, not v82)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\217\77\241\232\55\223\66\244\249\121\245\65\162\180\90\251\95\246\249\101\186\109\241\239\118\233\95\235\242\62", "\23\154\44\130\156");
								end
							end
							break;
						end
					end
				end
				v179 = 1;
			end
			if ((v179 == 2) or (3503 <= 195)) then
				if ((1382 <= 4404) and (v91 >= 4) and (v15:PMultiplier(v76.Rupture) <= 1) and (v14:BuffUp(v76.ShadowDanceBuff) or v15:DebuffUp(v76.Deathmark))) then
					if (v20(v76.Rupture, nil, nil, not v82) or (4857 <= 767)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\223\86\238\65\19\72\233\71\233\64\65\127\188\31\211\92\84\114\232\68\233\84\95\113\249\69\180", "\26\156\55\157\53\51");
					end
				end
				break;
			end
			if ((v179 == 1) or (4018 > 4021)) then
				if ((v27 and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\50\180\164\163\37\28\31\146\168\163\38\22\2\178", "\115\113\198\205\206\86")]:IsReady() and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\170\94\249\82\144\68\234\91\136\92\251\72", "\58\228\55\158")]:IsAvailable() and (v86 >= 3) and (v91 >= 4) and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\144\140\209\58\52\160\52\166\130", "\85\212\233\176\78\92\205")]:IsReady()) or (2270 == 1932)) then
					for v241, v242 in v30(v85) do
						if ((v122(v242, v76.CrimsonTempest, v94) and v242:FilteredTimeToDie(">", 6, -v242:DebuffRemains(v76.CrimsonTempest))) or (3430 <= 1176)) then
							if (v20(v76.CrimsonTempest) or (1198 >= 3717)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\105\89\155\246\10\123\154\235\71\75\135\236\10\108\141\239\90\93\155\246\10\16\187\246\79\89\132\246\66\17", "\130\42\56\232");
							end
						end
					end
				end
				if ((3730 >= 1333) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\205\180\54\241\79\43\239", "\95\138\213\68\131\32")]:IsCastable() and (v117() > 0)) then
					local v225 = 0;
					local v226;
					local v227;
					while true do
						if ((0 == v225) or (2152 == 2797)) then
							v226 = nil;
							function v226(v247)
								return v247:DebuffRemains(v76.Garrote);
							end
							v225 = 1;
						end
						if ((v225 == 2) or (1709 < 588)) then
							if (v27 or (3575 <= 3202)) then
								local v256 = 0;
								local v257;
								while true do
									if ((v256 == 0) or (4397 < 3715)) then
										v257 = v124(LUAOBFUSACTOR_DECRYPT_STR_0("\33\112\234", "\56\76\25\132"), v226, v227);
										if ((v257 and (v257:GUID() ~= v15:GUID())) or (4075 <= 2245)) then
											v20(v257, v76.Garrote);
										end
										break;
									end
								end
							end
							if (v227(v15) or (3966 > 4788)) then
								if ((3826 > 588) and v20(v76.Garrote, nil, nil, not v82)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\125\192\184\50\143\121\192\185\52\192\74\196\235\110\230\83\209\185\41\217\91\197\235\1\206\76\211\164\50\202\23", "\175\62\161\203\70");
								end
							end
							v225 = 3;
						end
						if ((694 <= 1507) and (v225 == 3)) then
							if ((3900 >= 1116) and (v92 >= (1 + (2 * v21(v76[LUAOBFUSACTOR_DECRYPT_STR_0("\15\213\209\28\32\56\216\199\32\32\58\219\204\16\52\40\212\204\29", "\85\92\189\163\115")]:IsAvailable()))))) then
								local v258 = 0;
								while true do
									if ((4907 > 3311) and (v258 == 0)) then
										if ((v14:BuffDown(v76.ShadowDanceBuff) and ((v15:PMultiplier(v76.Garrote) <= 1) or (v15:DebuffUp(v76.Deathmark) and (v116() < 3)))) or (3408 <= 2617)) then
											if ((3201 == 3201) and v20(v76.Garrote, nil, nil, not v82)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\10\173\35\44\105\139\49\42\59\163\36\61\105\228\25\53\57\190\63\46\44\168\112\31\40\190\34\55\61\169\112\20\38\187\112\27\25\229", "\88\73\204\80");
											end
										end
										if ((2195 == 2195) and ((v15:PMultiplier(v76.Garrote) <= 1) or (v15:DebuffRemains(v76.Garrote) < 12))) then
											if (v20(v76.Garrote, nil, nil, not v82) or (3025 > 3506)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\13\130\3\82\105\253\47\145\2\73\61\223\110\203\57\75\57\200\33\149\21\66\105\253\47\145\2\73\61\223\110\175\31\81\105\249\30\195\66\15", "\186\78\227\112\38\73");
											end
										end
										break;
									end
								end
							end
							break;
						end
						if ((v225 == 1) or (736 < 356)) then
							v227 = nil;
							function v227(v248)
								return ((v248:PMultiplier(v76.Garrote) <= 1) or (v248:DebuffRemains(v76.Garrote) < (12 / v75.ExsanguinatedRate(v248, v76.Garrote))) or ((v118() > 0) and (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\13\41\179\81\121\62\45", "\22\74\72\193\35")]:AuraActiveCount() < v86))) and not v107 and (v248:FilteredTimeToDie(">", 2, -v248:DebuffRemains(v76.Garrote)) or v248:TimeToDieIsNotValid()) and v75.CanDoTUnit(v248, v96);
							end
							v225 = 2;
						end
					end
				end
				v179 = 2;
			end
		end
	end
	local function v133()
		local v180 = 0;
		while true do
			if ((1171 <= 2774) and (v180 == 2)) then
				return false;
			end
			if ((4108 >= 312) and (v180 == 0)) then
				if ((v27 and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\175\202\31\212\171\95\130\236\19\212\168\85\159\204", "\48\236\184\118\185\216")]:IsReady() and (v86 >= 2) and (v91 >= 4) and (v104 > 25) and not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\193\184\86\36\199\57\228\175\92", "\84\133\221\55\80\175")]:IsReady()) or (679 > 2893)) then
					for v243, v244 in v30(v85) do
						if ((v122(v244, v76.CrimsonTempest, v94) and (v244:PMultiplier(v76.CrimsonTempest) <= 1) and v244:FilteredTimeToDie(">", 6, -v244:DebuffRemains(v76.CrimsonTempest))) or (876 < 200)) then
							if (v20(v76.CrimsonTempest) or (2325 > 3562)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\158\230\55\178\135\127\175\238\41\181\200\82\253\211\33\171\215\89\174\243\100\238\230\83\152\167\12\175\192\84\253\194\42\163\213\91\164\174", "\60\221\135\68\198\167");
							end
						end
					end
				end
				if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\201\188\234\145\77\205\235", "\185\142\221\152\227\34")]:IsCastable() and (v92 >= 1)) or (3661 > 4704)) then
					local v228 = 0;
					local v229;
					while true do
						if ((v228 == 0) or (4133 <= 1928)) then
							v229 = nil;
							function v229(v249)
								return v122(v249, v76.Garrote) and (v249:PMultiplier(v76.Garrote) <= 1);
							end
							v228 = 1;
						end
						if ((4418 >= 1433) and (v228 == 1)) then
							if ((v229(v15) and v75.CanDoTUnit(v15, v96) and (v15:FilteredTimeToDie(">", 12, -v15:DebuffRemains(v76.Garrote)) or v15:TimeToDieIsNotValid())) or (4123 >= 4123)) then
								if (v29(v76.Garrote, nil, not v82) or (205 >= 2345)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\104\202\88\246\3\53\248\74\133\112\251\81\33\248\76\192\23\178\112\7\190", "\151\56\165\55\154\35\83");
								end
							end
							if ((v27 and not v106 and (v86 >= 2)) or (537 == 1004)) then
								v123(v76.Garrote, v229, 12, v87);
							end
							break;
						end
					end
				end
				v180 = 1;
			end
			if ((v180 == 1) or (2345 < 545)) then
				if ((1649 > 243) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\146\86\21\250\181\81\0", "\142\192\35\101")]:IsReady() and (v91 >= 4)) then
					local v230 = 0;
					local v231;
					while true do
						if ((v230 == 1) or (3910 <= 3193)) then
							function v231(v250)
								return v122(v250, v76.Rupture, v93) and (v250:PMultiplier(v76.Rupture) <= 1) and (v250:FilteredTimeToDie(">", v97, -v250:DebuffRemains(v76.Rupture)) or v250:TimeToDieIsNotValid());
							end
							if ((2005 == 2005) and v231(v15) and v75.CanDoTUnit(v15, v95)) then
								if ((4688 > 4572) and v20(v76.Rupture, nil, nil, not v82)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\128\167\220\222\125\21\152\187\183\179\221\207", "\203\195\198\175\170\93\71\237");
								end
							end
							v230 = 2;
						end
						if ((1567 < 3260) and (v230 == 2)) then
							if ((v27 and (not v106 or not v108)) or (3761 == 621)) then
								v123(v76.Rupture, v231, v97, v87);
							end
							break;
						end
						if ((4755 > 3454) and (v230 == 0)) then
							v97 = 4 + (v21(v76[LUAOBFUSACTOR_DECRYPT_STR_0("\242\116\58\171\238\130\171\37\213\122\60\173\227\158\169\26", "\118\182\21\73\195\135\236\204")]:IsAvailable()) * 5) + (v21(v76[LUAOBFUSACTOR_DECRYPT_STR_0("\44\51\21\77\6\1\252\12\57", "\157\104\92\122\32\100\109")]:IsAvailable()) * 5) + (v21(v106) * 6);
							v231 = nil;
							v230 = 1;
						end
					end
				end
				if ((4819 >= 1607) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\9\74\44\199\94\5\249", "\156\78\43\94\181\49\113")]:IsCastable() and (v92 >= 1) and (v116() <= 0) and ((v15:PMultiplier(v76.Garrote) <= 1) or ((v15:DebuffRemains(v76.Garrote) < v89) and (v86 >= 3))) and (v15:DebuffRemains(v76.Garrote) < (v89 * 2)) and (v86 >= 3) and (v15:FilteredTimeToDie(">", 4, -v15:DebuffRemains(v76.Garrote)) or v15:TimeToDieIsNotValid())) then
					if ((4546 >= 1896) and v20(v76.Garrote, nil, nil, not v82)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\233\214\177\4\87\124\50\160\226\162\7\79\123\115\235\207\234", "\25\18\136\164\195\107\35");
					end
				end
				v180 = 2;
			end
		end
	end
	local function v134()
		local v181 = 0;
		while true do
			if ((3546 > 933) and (v181 == 1)) then
				if ((not v107 and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\154\207\197\44\91\176\205\227\47\78\173\218\213\45", "\47\217\174\176\95")]:IsAvailable() and v15:DebuffUp(v76.Rupture) and (v15:DebuffRemains(v76.CausticSpatterDebuff) <= 2)) or (3985 <= 3160)) then
					local v232 = 0;
					while true do
						if ((1987 == 1987) and (v232 == 0)) then
							if ((994 <= 4540) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\149\200\98\11\190\85\108\35", "\70\216\189\22\98\210\52\24")]:IsCastable()) then
								if ((4917 == 4917) and v20(v76.Mutilate, nil, nil, not v82)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\249\222\176\147\147\247\202\183\142\223\219\203\166\199\155\249\222\176\146\199\211\220\234", "\179\186\191\195\231");
								end
							end
							if (((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\216\50\26\241\234\55", "\132\153\95\120")]:IsCastable() or v76[LUAOBFUSACTOR_DECRYPT_STR_0("\144\191\12\56\228\210\143\167\183\28\63\254\222\165", "\192\209\210\110\77\151\186")]:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v76.BlindsideBuff))) or (324 > 4896)) then
								if ((772 < 4670) and v20(v76.Ambush, nil, nil, not v82)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\195\2\49\253\191\229\237\1\55\250\247\132\168\32\35\252\236\208\233\0\107", "\164\128\99\66\137\159");
								end
							end
							break;
						end
					end
				end
				if ((3172 >= 2578) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\51\140\251\172\1\157\236\186\34\134\231\187\51\153\224\181\5", "\222\96\233\137")]:IsReady()) then
					if (not v15:DebuffUp(v76.SerratedBoneSpikeDebuff) or (721 == 834)) then
						if ((1312 < 2654) and v20(v76.SerratedBoneSpike, nil, not v83)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\154\178\180\11\200\192\245\171\161\166\11\141\247\176\155\188\169\26\200\192\224\176\184\162", "\144\217\211\199\127\232\147");
						end
					else
						local v246 = 0;
						while true do
							if ((3213 >= 1613) and (v246 == 0)) then
								if (v27 or (3786 > 4196)) then
									if ((4218 == 4218) and v74.CastTargetIf(v76.SerratedBoneSpike, v84, LUAOBFUSACTOR_DECRYPT_STR_0("\245\38\48", "\36\152\79\94\72\181\37\98"), v126, v127)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\244\217\84\43\151\235\66\45\197\217\83\58\211\152\101\48\217\221\7\119\246\215\98\118", "\95\183\184\39");
									end
								end
								if ((1517 < 4050) and (v116() < 0.8)) then
									if ((4390 == 4390) and ((v10.BossFightRemains() <= 5) or ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\134\58\245\52\85\148\7\177\29\232\40\81\179\18\188\52\226", "\98\213\95\135\70\52\224")]:MaxCharges() - v76[LUAOBFUSACTOR_DECRYPT_STR_0("\205\166\219\101\85\234\166\205\85\91\240\166\250\103\93\245\166", "\52\158\195\169\23")]:ChargesFractional()) <= 0.25))) then
										if ((1919 > 289) and v20(v76.SerratedBoneSpike, nil, true, not v83)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\89\189\33\96\198\6\126\153\104\189\38\113\130\117\89\132\116\185\114\71\150\60\112\142\58\244\22\97\139\37\59\168\114\189\32\115\131\124", "\235\26\220\82\20\230\85\27");
										end
									elseif ((not v107 and v15:DebuffUp(v76.ShivDebuff)) or (1205 < 751)) then
										if (v20(v76.SerratedBoneSpike, nil, true, not v83) or (2561 <= 1717)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\171\160\250\214\52\187\164\251\208\117\156\164\237\130\86\135\175\236\130\71\152\168\226\199\52\192\146\225\203\98\193", "\20\232\193\137\162");
										end
									end
								end
								break;
							end
						end
					end
				end
				v181 = 2;
			end
			if ((1723 <= 3600) and (v181 == 4)) then
				if ((3271 >= 1633) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\51\165\18\1\20\233\10\181", "\136\126\208\102\104\120")]:IsCastable()) then
					if ((3103 >= 2873) and v29(v76.Mutilate, nil, not v82)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\139\221\87\239\127\40\69\113\134\207\87\170", "\49\24\234\174\35\207\50\93");
					end
				end
				return false;
			end
			if ((0 == v181) or (3603 == 725)) then
				if ((2843 == 2843) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\205\35\191\74\124\179\204", "\216\136\77\201\47\18\220\161")]:IsReady() and (v91 >= 4) and (v101 or (v15:DebuffStack(v76.AmplifyingPoisonDebuff) >= 20) or (v91 > v75.CPMaxSpend()) or not v107)) then
					if (v20(v76.Envenom, nil, nil, not v82) or (174 >= 2515)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\14\237\56\206\72\249\140\59\233\37\213\5", "\226\77\140\75\186\104\188");
					end
				end
				if ((4411 >= 2020) and not ((v92 > 1) or v101 or not v107)) then
					return false;
				end
				v181 = 1;
			end
			if ((1347 == 1347) and (v181 == 3)) then
				if ((4461 == 4461) and (v76[LUAOBFUSACTOR_DECRYPT_STR_0("\52\251\242\12\24\78", "\38\117\150\144\121\107")]:IsCastable() or v76[LUAOBFUSACTOR_DECRYPT_STR_0("\12\182\236\47\62\179\193\44\40\169\252\51\41\190", "\90\77\219\142")]:IsCastable()) and (v14:StealthUp(true, true) or v14:BuffUp(v76.BlindsideBuff) or v14:BuffUp(v76.SepsisBuff)) and (v15:DebuffDown(v76.Kingsbane) or v15:DebuffDown(v76.Deathmark) or v14:BuffUp(v76.BlindsideBuff))) then
					if (v29(v76.Ambush, nil, not v82) or (4340 == 2872)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\5\50\45\12\38\119\228\17\50\49", "\26\134\100\65\89\44\103");
					end
				end
				if ((568 <= 2207) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\220\246\36\42\168\240\247\53", "\196\145\131\80\67")]:IsCastable() and (v86 == 2) and v15:DebuffDown(v76.DeadlyPoisonDebuff, true) and v15:DebuffDown(v76.AmplifyingPoisonDebuff, true)) then
					local v233 = 0;
					local v234;
					while true do
						if ((v233 == 0) or (3789 <= 863)) then
							v234 = v15:GUID();
							for v251, v252 in v30(v87) do
								if ((238 < 4997) and (v252:GUID() ~= v234) and (v252:DebuffUp(v76.Garrote) or v252:DebuffUp(v76.Rupture)) and not v252:DebuffUp(v76.DeadlyPoisonDebuff, true) and not v252:DebuffUp(v76.AmplifyingPoisonDebuff, true)) then
									v20(v252, v76.Mutilate);
									break;
								end
							end
							break;
						end
					end
				end
				v181 = 4;
			end
			if ((4285 > 3803) and (v181 == 2)) then
				if ((2672 < 4910) and v28 and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\7\220\205\169\238\130\16\67\39\207\215\175\234\141\25\117", "\17\66\191\165\198\135\236\119")]:IsReady()) then
					if (v20(v76.EchoingReprimand, nil, not v82) or (2956 > 4353)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\174\189\7\191\205\239\217\0\166\160\20\191\218\233\193\29\166\163\18\241\236", "\177\111\207\206\115\159\136\140");
					end
				end
				if ((3534 > 2097) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\35\136\30\27\210\100\81\12\159\21\7", "\63\101\233\112\116\180\47")]:IsCastable()) then
					local v235 = 0;
					while true do
						if ((3255 >= 534) and (v235 == 0)) then
							if ((4254 < 4460) and v27 and (v86 >= 1) and not v100 and (v86 >= (2 + v21(v14:StealthUp(true, false)) + v21(v76[LUAOBFUSACTOR_DECRYPT_STR_0("\231\41\236\21\247\56\247\62\224\2\253\36\198\63\207\30\249\50\198\40", "\86\163\91\141\114\152")]:IsAvailable())))) then
								if (v29(v76.FanofKnives) or (4661 <= 4405)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\112\10\103\103\122\117\10\122\51\53\85\75\95\125\51\69\14\103", "\90\51\107\20\19");
								end
							end
							if ((4575 >= 1943) and v27 and v14:BuffUp(v76.DeadlyPoison) and (v86 >= 3)) then
								for v265, v266 in v30(v85) do
									if ((not v266:DebuffUp(v76.DeadlyPoisonDebuff, true) and (not v100 or v266:DebuffUp(v76.Garrote) or v266:DebuffUp(v76.Rupture))) or (326 > 1137)) then
										if ((1284 == 1284) and v29(v76.FanofKnives)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\174\241\150\251\125\171\241\139\175\50\139\176\174\225\52\155\245\150\175\117\169\192\197\221\56\139\226\128\252\53\196", "\93\237\144\229\143");
										end
									end
								end
							end
							break;
						end
					end
				end
				v181 = 3;
			end
		end
	end
	local function v135()
		local v182 = 0;
		while true do
			if ((v182 == 3) or (3072 >= 3426)) then
				v92 = v14:ComboPointsMax() - v91;
				v93 = (4 + (v91 * 4)) * 0.3;
				v94 = (4 + (v91 * 2)) * 0.3;
				v182 = 4;
			end
			if ((v182 == 5) or (4036 > 4375)) then
				v88 = v75.CrimsonVial();
				if ((3928 == 3928) and v88) then
					return v88;
				end
				v88 = v75.Feint();
				v182 = 6;
			end
			if ((v182 == 7) or (2629 >= 3005)) then
				if (not v14:AffectingCombat() or (2620 <= 422)) then
					local v236 = 0;
					while true do
						if ((1896 > 1857) and (0 == v236)) then
							if ((1466 >= 492) and not v14:BuffUp(v75.VanishBuffSpell())) then
								local v259 = 0;
								while true do
									if ((868 < 3853) and (v259 == 0)) then
										v88 = v75.Stealth(v75.StealthSpell());
										if (v88 or (1815 > 4717)) then
											return v88;
										end
										break;
									end
								end
							end
							if ((3671 == 3671) and v74.TargetIsValid()) then
								local v260 = 0;
								while true do
									if ((216 <= 284) and (0 == v260)) then
										if ((3257 > 2207) and v28) then
											if ((v26 and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\32\88\37\53\32\252\11\86\37\26\32\249\25\81", "\152\109\57\87\94\69")]:IsCastable() and (v14:ComboPointsDeficit() >= v75.CPMaxSpend()) and v74.TargetIsValid()) or (2087 < 137)) then
												if (v10.Press(v76.MarkedforDeath, v59) or (3923 >= 4763)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\218\214\25\183\254\255\85\186\242\210\14\227\184\221\70\232\221\210\11\183\182\146\28\135\214\244\67", "\200\153\183\106\195\222\178\52");
												end
											end
										end
										if ((1744 == 1744) and not v14:BuffUp(v76.SliceandDice)) then
											if ((248 <= 1150) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\1\239\129\62\76\91\60\231\172\52\74\95", "\58\82\131\232\93\41")]:IsReady() and (v91 >= 2)) then
												if ((3994 >= 294) and v10.Press(v76.SliceandDice)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\160\86\195\1\29\12\143\94\211\16\29\62\141\83\144\49\84\60\134", "\95\227\55\176\117\61");
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
				v75.MfDSniping(v76.MarkedforDeath);
				if ((1641 > 693) and v74.TargetIsValid()) then
					local v237 = 0;
					while true do
						if ((v237 == 5) or (4519 < 2235)) then
							if ((892 < 1213) and v88) then
								return v88;
							end
							if ((3313 <= 4655) and v28) then
								local v261 = 0;
								while true do
									if ((v261 == 1) or (3956 < 2705)) then
										if ((1959 < 3037) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\50\233\114\194\254\152\51\195\26\231\120\207\228\159", "\182\126\128\21\170\138\235\121")]:IsCastable() and v82) then
											if (v20(v76.LightsJudgment, v32) or (1241 > 2213)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\168\219\38\242\198\63\57\1\131\206\38\166\172\6\52\1\134\223\59\242", "\102\235\186\85\134\230\115\80");
											end
										end
										if ((4905 < 4974) and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\117\13\57\80\116\224\48\94\15\53\76", "\66\55\108\94\63\18\180")]:IsCastable() and v82) then
											if ((3557 == 3557) and v20(v76.BagofTricks, v32)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\55\140\150\35\103\123\21\138\197\56\33\25\32\159\140\52\44\74", "\57\116\237\229\87\71");
											end
										end
										break;
									end
									if ((369 == 369) and (v261 == 0)) then
										if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\113\235\5\190\81\122\205\117\66\235\3\177\75", "\26\48\153\102\223\63\31\153")]:IsCastable() and v82 and (v14:EnergyDeficit() > 15)) or (3589 < 2987)) then
											if ((4378 > 2853) and v20(v76.ArcaneTorrent, v32)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\33\65\254\231\66\97\255\240\3\78\232\179\54\79\255\225\7\78\249", "\147\98\32\141");
											end
										end
										if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\57\81\224\203\8\83\123\13\79\240\207", "\43\120\35\131\170\102\54")]:IsCastable() and v82) or (1712 > 3602)) then
											if ((4539 >= 2733) and v20(v76.ArcanePulse, v32)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\119\7\148\162\229\145\150\87\7\137\179\229\128\145\88\21\130", "\228\52\102\231\214\197\208");
											end
										end
										v261 = 1;
									end
								end
							end
							if (((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\139\188\239\242\100\230", "\39\202\209\141\135\23\142")]:IsCastable() or v76[LUAOBFUSACTOR_DECRYPT_STR_0("\222\62\11\31\33\240\208\37\12\24\32\241\251\54", "\152\159\83\105\106\82")]:IsCastable()) and v83) or (2599 <= 515)) then
								if (v20(v76.Ambush) or (3754 < 810)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\167\207\93\254\137\125\140\196\68\225\193", "\60\225\166\49\146\169");
								end
							end
							v237 = 6;
						end
						if ((1633 <= 1977) and (v237 == 1)) then
							v106 = v104 > 35;
							v101 = v119();
							v102 = v120();
							v237 = 2;
						end
						if ((4528 >= 3619) and (v237 == 3)) then
							v88 = v131();
							if (v88 or (172 >= 2092)) then
								return v88;
							end
							if ((2120 == 2120) and not v14:BuffUp(v76.SliceandDice)) then
								if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\194\41\68\236\220\240\43\73\203\208\242\32", "\185\145\69\45\143")]:IsReady() and (v14:ComboPoints() >= 2) and v15:DebuffUp(v76.Rupture)) or (not v76[LUAOBFUSACTOR_DECRYPT_STR_0("\169\10\13\146\211\190\23\28\133\212\139\12\28", "\188\234\127\121\198")]:IsAvailable() and (v14:ComboPoints() >= 4) and (v14:BuffRemains(v76.SliceandDice) < ((1 + v14:ComboPoints()) * 1.8))) or (2398 == 358)) then
									if ((2387 < 4637) and v20(v76.SliceandDice)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\27\51\0\151\120\1\31\138\59\55\83\130\54\54\83\167\49\49\22", "\227\88\82\115");
									end
								end
							elseif ((1265 < 2775) and v83 and v76[LUAOBFUSACTOR_DECRYPT_STR_0("\96\10\174\147\13\71\75\26\153\175\3\96\70", "\19\35\127\218\199\98")]:IsAvailable()) then
								if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\57\245\28\231\18\244\7", "\130\124\155\106")]:IsReady() and (v14:BuffRemains(v76.SliceandDice) < 5) and (v14:ComboPoints() >= 4)) or (4430 < 51)) then
									if ((1871 <= 1998) and v20(v76.Envenom, nil, nil, not v82)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\246\202\229\187\227\211\114\169\208\197\249\162\227\190\95\171\193\232\191", "\223\181\171\150\207\195\150\28");
									end
								end
							elseif ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\124\53\234\189\6\66\63\231\133\7\69\60\230", "\105\44\90\131\206")]:IsCastable() and v15:IsInRange(30) and not v14:StealthUp(true, true) and (v86 == 0) and (v14:EnergyTimeToMax() <= (v14:GCD() * 1.5))) or (2083 >= 3954)) then
								if ((1857 > 59) and v20(v76.PoisonedKnife)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\220\225\161\173\72\14\240\233\161\182\6\59\251\160\153\183\1\56\250", "\94\159\128\210\217\104");
								end
							end
							v237 = 4;
						end
						if ((v237 == 4) or (1232 == 3045)) then
							v88 = v133();
							if ((104 == 104) and v88) then
								return v88;
							end
							v88 = v134();
							v237 = 5;
						end
						if ((4534 > 2967) and (v237 == 6)) then
							if ((v76[LUAOBFUSACTOR_DECRYPT_STR_0("\2\11\59\35\13\6\59\27", "\103\79\126\79\74\97")]:IsCastable() and v83) or (3449 <= 2368)) then
								if ((4733 >= 3548) and v20(v76.Mutilate)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\156\118\223\127\30\55\175\107\218\127\95\14\191", "\122\218\31\179\19\62");
								end
							end
							break;
						end
						if ((0 == v237) or (2005 > 4687)) then
							v103 = v75.PoisonedBleeds();
							v104 = v14:EnergyRegen() + ((v103 * 6) / (2 * v14:SpellHaste()));
							v105 = v14:EnergyDeficit() / v104;
							v237 = 1;
						end
						if ((v237 == 2) or (1767 <= 916)) then
							v108 = v121();
							v107 = v86 < 2;
							if ((3589 < 3682) and (v14:StealthUp(true, false) or (v117() > 0) or (v116() > 0))) then
								local v262 = 0;
								while true do
									if ((v262 == 0) or (75 >= 430)) then
										v88 = v132();
										if (v88 or (4157 <= 3219)) then
											return v88 .. LUAOBFUSACTOR_DECRYPT_STR_0("\88\54\16\95\174\25\114\55\67\174\28\55", "\203\120\30\67\43");
										end
										break;
									end
								end
							end
							v237 = 3;
						end
					end
				end
				break;
			end
			if ((1823 < 2782) and (v182 == 6)) then
				if ((3434 >= 1764) and v88) then
					return v88;
				end
				if ((4040 > 1820) and not v14:AffectingCombat() and not v14:IsMounted() and v74.TargetIsValid()) then
					local v238 = 0;
					while true do
						if ((4192 >= 2529) and (v238 == 0)) then
							v88 = v75.Stealth(v76.Stealth2, nil);
							if ((1554 < 2325) and v88) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\121\163\25\212\77\152\171\10\255\51\250\98\197\249\10", "\195\42\215\124\181\33\236") .. v88;
							end
							break;
						end
					end
				end
				v75.Poisons();
				v182 = 7;
			end
			if ((1108 < 4525) and (v182 == 2)) then
				if (v27 or (4367 <= 3332)) then
					local v239 = 0;
					while true do
						if ((v239 == 1) or (2896 > 4641)) then
							v86 = #v85;
							v87 = v14:GetEnemiesInMeleeRange(5);
							break;
						end
						if ((882 > 21) and (v239 == 0)) then
							v84 = v14:GetEnemiesInRange(30);
							v85 = v14:GetEnemiesInMeleeRange(10);
							v239 = 1;
						end
					end
				else
					local v240 = 0;
					while true do
						if ((2373 <= 4789) and (0 == v240)) then
							v84 = {};
							v85 = {};
							v240 = 1;
						end
						if ((1 == v240) or (1839 < 1136)) then
							v86 = 1;
							v87 = {};
							break;
						end
					end
				end
				v89, v90 = 2 * v14:SpellHaste(), 1 * v14:SpellHaste();
				v91 = v75.EffectiveComboPoints(v14:ComboPoints());
				v182 = 3;
			end
			if ((3430 == 3430) and (v182 == 1)) then
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\36\34\184\237\35\56", "\129\70\75\69\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\69\207\224", "\143\38\171\147\137\28")];
				v82 = v15:IsInMeleeRange(5);
				v83 = v15:IsInMeleeRange(10);
				v182 = 2;
			end
			if ((748 <= 2288) and (v182 == 0)) then
				v73();
				v26 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\56\253\250\143\125\9\225", "\17\108\146\157\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\68\204\23", "\200\43\163\116\141\79")];
				v27 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\57\58\132\188\241\240", "\131\223\86\93\227\208\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\74\179", "\213\131\37\214\214\125")];
				v182 = 1;
			end
			if ((891 < 4473) and (v182 == 4)) then
				v95 = v76[LUAOBFUSACTOR_DECRYPT_STR_0("\245\140\175\246\13\236\217", "\180\176\226\217\147\99\131")]:Damage() * v63;
				v96 = v76[LUAOBFUSACTOR_DECRYPT_STR_0("\254\172\59\14\223\184\59\2", "\103\179\217\79")]:Damage() * v64;
				v100 = v46();
				v182 = 5;
			end
		end
	end
	local function v136()
		local v183 = 0;
		while true do
			if ((v183 == 0) or (3071 <= 2647)) then
				v76[LUAOBFUSACTOR_DECRYPT_STR_0("\151\211\204\213\193\172\68\161\221", "\37\211\182\173\161\169\193")]:RegisterAuraTracking();
				v76[LUAOBFUSACTOR_DECRYPT_STR_0("\196\63\93\202\33\104", "\217\151\90\45\185\72\27")]:RegisterAuraTracking();
				v183 = 1;
			end
			if ((v183 == 1) or (633 > 1640)) then
				v76[LUAOBFUSACTOR_DECRYPT_STR_0("\228\125\245\0\89\215\121", "\54\163\28\135\114")]:RegisterAuraTracking();
				v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\9\200\78\131\93\108\33\213\92\150\71\112\38\155\111\141\73\106\45\155\95\155\14\90\56\210\94\204\14\76\61\203\77\141\92\107\45\223\29\128\87\63\15\212\87\139\92\126", "\31\72\187\61\226\46"));
				break;
			end
		end
	end
	v10.SetAPL(259, v135, v136);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\230\22\74\202\120\76\43\196\19\70\237\102\109\55\194\21\80\219\73\127\48\202\9\77\156\75\107\37", "\68\163\102\35\178\39\30")]();

