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
		if ((2655 <= 2908) and (v5 == 0)) then
			v6 = v0[v4];
			if ((963 > 651) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((1 == v5) or (3503 <= 195)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\194\31\197\203\240\43\239\188\207\10\238\229\201\42\245\175\227\53\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
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
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\139\83\221", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\100\67\3\55\70", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\159\204\218\7\13\37\175", "\75\220\163\183\106\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\172\142\37\192\13\180\142", "\185\98\218\235\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\41\42", "\202\171\92\71\134\190")];
	local v22 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\14\193\81\126", "\135\108\174\62\18\30\23\147")];
	local v23 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\187\224\36", "\167\214\137\74\171\120\206\83")];
	local v24 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\138\242\33", "\199\235\144\82\61\152")];
	local v25 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\10\23\161", "\75\103\118\217")];
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\228\85\99\0", "\126\167\52\16\116\217")];
	local v30 = table[LUAOBFUSACTOR_DECRYPT_STR_0("\193\32\51\133\166\13", "\156\168\78\64\224\212\121")];
	local v31 = GetTime;
	local v32 = strsplit;
	local v33 = GetInventoryItemLink;
	local v34;
	local v35;
	local v36;
	local v37;
	local v38 = 0;
	local v39;
	local v40 = 0;
	local v41;
	local v42;
	local v43;
	local v44;
	local v45 = 0;
	local v46 = 0;
	local v47;
	local v48;
	local v49;
	local v50;
	local v51;
	local v52;
	local v53;
	local v54;
	local v55;
	local v56 = 0;
	local v57;
	local v58;
	local v59;
	local v60;
	local v61;
	local v62;
	local function v63()
		local v127 = 0;
		while true do
			if ((1382 <= 4404) and (v127 == 1)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\63\200\58\226\128\32\217\26\244\149\35\195\23", "\135\225\76\173\114")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\216\17\252\108\254\190\201\31\254\125\222\157", "\150\205\189\112\144\24")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\17\19\214\164\110\147\196\11\48\218\162\116\181\192\10\9", "\230\180\127\103\179\214\28")] or 0;
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\5\65\164\249\218\188\189\62\74\186\242\248\164\160\5\65\186\226\220\184", "\175\204\201\113\36\214\139")] or 0;
				v127 = 2;
			end
			if ((v127 == 5) or (4857 <= 767)) then
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\43\160\66\68\85\41\167", "\45\59\78\212\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\49\123\176\170\132\61\162\226\18\102\134\153\133\43\163\228", "\144\112\54\227\235\230\78\205")] or 0;
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\45\27\232\217\85\180\59", "\59\211\72\111\156\176")][LUAOBFUSACTOR_DECRYPT_STR_0("\108\149\230\44\90\143\204\43\125\142\237\41\92\134\228\34\93\134\196\14\106", "\77\46\231\131")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\81\162\84\179\90\177\83", "\32\218\52\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\104\5\62\187\229\131\81\72\71\28\52\143\210\148", "\58\46\119\81\200\145\208\37")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\24\137\36\184\160\179\49\56", "\86\75\236\80\204\201\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\84\83\120\150\234\156\107\83\122\150\216\158\96\88\80\166\218", "\235\18\33\23\229\158")];
				v127 = 6;
			end
			if ((6 == v127) or (4018 > 4021)) then
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\191\213\175\89\180\198\168", "\219\48\218\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\126\110\71\244\73\215\237\127\104\76\201\104\195\192", "\128\132\17\28\41\187\47")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\55\18\46\84\15\53\21", "\61\97\82\102\90")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\55\187\68\211\95\27\27\161\39\168\123\213\82\13\12\162\45\174\108\228\115", "\105\204\78\203\43\167\55\126")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\175\55\10\26\10\192\66", "\49\197\202\67\126\115\100\167")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\82\211\37\129\68\113\49\125\205\38\147\66\121\20\127", "\62\87\59\191\73\224\54")];
				break;
			end
			if ((v127 == 4) or (2270 == 1932)) then
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\205\25\223\204\173\208\242", "\129\202\168\109\171\165\195\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\89\52\202\215\18\239\33\81\54\212\238\21\229\54\127\20\252", "\134\66\56\87\184\190\116")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\52\29\175\16\229\38\38", "\85\92\81\105\219\121\139\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\186\94\65\90\205\248\182\74\64\83\217\251\148\115\97", "\191\157\211\48\37\28")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\236\26\224\8\51\209\24\231", "\90\191\127\148\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\74\134\45\30\121\139\61\56\126\129\9\52\92", "\119\24\231\78")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\40\177\94\213\78\22\145", "\113\226\77\197\42\188\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\31\231\180\56\26\241\151\53\37\196\186\53\26\253\187\61", "\213\90\118\148")];
				v127 = 5;
			end
			if ((v127 == 3) or (3430 <= 1176)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\142\5\225\176\210\200\200", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\161\149\69\206\120\127\53\172\178\68\230\117\116\27\140\165", "\24\92\207\225\44\131\25")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\214\172\88\18\115\76\192", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\215\52\69\144\216\39\69\190\227\47\66\184\254\3\104", "\44\221\185\64")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\226\92\75\122\15\224\91", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\89\50\47\39\16\160\88\23\62\44\48\183\123\16\31", "\81\206\60\83\91\79")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\174\196\102\38\205\74\183", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\157\47\110\17\51\254\253\138\55\112\27\19\254\238\168\45\112\57\7\223", "\143\216\66\30\126\68\155")];
				v127 = 4;
			end
			if ((v127 == 2) or (1198 >= 3717)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\118\173\133\33\191\109\169\148\7\165\106\188\147\59\162\116\189", "\83\205\24\217\224")] or 0;
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\225\196\230\63\207\166\118\141\230\211\203\49\203\154\78", "\30\222\146\161\162\90\174\210")] or 0;
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\51\118\216\91\82\83\19\102\255\89\79\74\8\67", "\32\56\64\19\156\58")] or 0;
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\108\69\78\220\88\181\166\38\99\121\77\251\112\136\148\2\79\83\71\228", "\107\57\54\43\157\21\230\231")];
				v127 = 3;
			end
			if ((3730 >= 1333) and (v127 == 0)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\235\177\218\14\224\162\221", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\59\90\10\36\93\241\87\36\76", "\152\54\72\63\88\69\62")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\193\250\72\221\202\233\79", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\77\0\1\34\236\30\81\80\2\25\40\249\27\87\80", "\114\56\62\101\73\71\141")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\236\207\208\177\231\220\215", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\227\48\190\175\240\12\226\233\37\187\169\240\37\211\235\52", "\107\178\134\81\210\198\158")] or 0;
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\10\131\251\195\205\8\178\248\222\202\0\140\223\250", "\170\163\111\226\151")] or 0;
				v127 = 1;
			end
		end
	end
	local v64 = v16[LUAOBFUSACTOR_DECRYPT_STR_0("\195\7\251\221\239\41\244\192\224\10\238", "\169\135\98\154")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\101\43\71\233", "\168\171\23\68\52\157\83")];
	local v65 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\208\116\244\185\45\6\137\253\118\253\185", "\231\148\17\149\205\69\77")][LUAOBFUSACTOR_DECRYPT_STR_0("\166\181\200\232\67", "\159\224\199\167\155\55")];
	local v66 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\211\246\61\198\255\216\50\219\240\251\40", "\178\151\147\92")][LUAOBFUSACTOR_DECRYPT_STR_0("\170\239\67\33\6", "\26\236\157\44\82\114\44")];
	local v67 = {v65[LUAOBFUSACTOR_DECRYPT_STR_0("\11\34\210\94\62\38\212\73\26\59\207\65\38\43\247\84\50", "\59\74\78\181")]:ID()};
	local v68 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\6\222\87\87\188\43\194", "\211\69\177\58\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\146\243\124\231\240\196\185\224", "\171\215\133\25\149\137")];
	local v69;
	local v70;
	local v71;
	local v72 = v64[LUAOBFUSACTOR_DECRYPT_STR_0("\198\201\38\242\234\34\245\76\230\251\38\245\253\61", "\34\129\168\82\154\143\80\156")]:IsAvailable() or v64[LUAOBFUSACTOR_DECRYPT_STR_0("\160\164\54\25\78\92\134\150\166", "\233\229\210\83\107\40\46")]:IsAvailable();
	local v73 = ((v56 > 59) and 25) or 45;
	local v74, v75;
	local v76, v77;
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
	local v89 = 11111;
	local v90 = 11111;
	local v91 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\230\74\61\195\9\245\67\48\218\0", "\101\161\34\82\182")];
	local v92, v93, v94;
	local v95, v96, v97;
	local v98;
	v10:RegisterForEvent(function()
		local v128 = 0;
		while true do
			if ((v128 == 0) or (2152 == 2797)) then
				v89 = 11111;
				v90 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\216\33\120\199\254\208\189\28\205\42\124\208\228\199\172\15\202\33\124\218", "\78\136\109\57\158\187\130\226"));
	v10:RegisterForEvent(function()
		v72 = v64[LUAOBFUSACTOR_DECRYPT_STR_0("\25\62\237\249\59\45\240\255\57\12\237\254\44\50", "\145\94\95\153")]:IsAvailable() or v64[LUAOBFUSACTOR_DECRYPT_STR_0("\216\219\17\199\72\165\242\222\0", "\215\157\173\116\181\46")]:IsAvailable();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\6\132\174\222\246\6\139\168\218\251\27\147\174\214", "\186\85\212\235\146"), LUAOBFUSACTOR_DECRYPT_STR_0("\238\164\55\204\23\203\124\253\178\38\219\21\194\103\235\175\41\202\24\204", "\56\162\225\118\158\89\142"));
	local v99 = {{v64[LUAOBFUSACTOR_DECRYPT_STR_0("\125\22\208\167\59\192\85\4\212\170", "\184\60\101\160\207\66")],LUAOBFUSACTOR_DECRYPT_STR_0("\18\131\111\168\113\163\111\172\57\155\100\181\48\150\121\252\121\171\114\168\52\144\110\169\33\150\53", "\220\81\226\28"),function()
		return true;
	end}};
	local v100 = v33(LUAOBFUSACTOR_DECRYPT_STR_0("\3\217\131\226\239\213", "\167\115\181\226\155\138"), 16) or "";
	local v101 = v33(LUAOBFUSACTOR_DECRYPT_STR_0("\242\46\230\69\126\99", "\166\130\66\135\60\27\17"), 17) or "";
	local v102, v102, v103 = v32(":", v100);
	local v102, v102, v104 = v32(":", v101);
	local v70 = (v103 == LUAOBFUSACTOR_DECRYPT_STR_0("\23\25\153\37", "\80\36\42\174\21")) or (v104 == LUAOBFUSACTOR_DECRYPT_STR_0("\29\67\96\42", "\26\46\112\87"));
	local v71 = (v103 == LUAOBFUSACTOR_DECRYPT_STR_0("\234\112\253\44", "\212\217\67\203\20\223\223\37")) or (v104 == LUAOBFUSACTOR_DECRYPT_STR_0("\233\222\254\138", "\178\218\237\200"));
	local v105 = (v103 == LUAOBFUSACTOR_DECRYPT_STR_0("\224\231\178\131", "\176\214\213\134")) or (v104 == LUAOBFUSACTOR_DECRYPT_STR_0("\162\255\226\135", "\57\148\205\214\180\200\54"));
	local v106 = IsEquippedItemType(LUAOBFUSACTOR_DECRYPT_STR_0("\38\234\58\121\94\19\243\49", "\22\114\157\85\84"));
	local v107 = v14:GetEquipment();
	local v108 = (v107[13] and v18(v107[13])) or v18(0);
	local v109 = (v107[14] and v18(v107[14])) or v18(0);
	v10:RegisterForEvent(function()
		local v129 = 0;
		while true do
			if ((v129 == 4) or (1709 < 588)) then
				v108 = (v107[13] and v18(v107[13])) or v18(0);
				v109 = (v107[14] and v18(v107[14])) or v18(0);
				break;
			end
			if ((v129 == 3) or (3575 <= 3202)) then
				v106 = IsEquippedItemType(LUAOBFUSACTOR_DECRYPT_STR_0("\5\22\221\249\208\209\179\53", "\221\81\97\178\212\152\176"));
				v107 = v14:GetEquipment();
				v129 = 4;
			end
			if ((v129 == 2) or (4397 < 3715)) then
				v70 = (v103 == LUAOBFUSACTOR_DECRYPT_STR_0("\96\1\5\166", "\153\83\50\50\150")) or (v104 == LUAOBFUSACTOR_DECRYPT_STR_0("\14\37\36\76", "\45\61\22\19\124\19\203"));
				v71 = (v103 == LUAOBFUSACTOR_DECRYPT_STR_0("\146\65\91\173", "\217\161\114\109\149\98\16")) or (v104 == LUAOBFUSACTOR_DECRYPT_STR_0("\65\115\110\36", "\20\114\64\88\28\220"));
				v129 = 3;
			end
			if ((v129 == 0) or (4075 <= 2245)) then
				v100 = v33(LUAOBFUSACTOR_DECRYPT_STR_0("\212\199\18\221\88\228", "\200\164\171\115\164\61\150"), 16) or "";
				v101 = v33(LUAOBFUSACTOR_DECRYPT_STR_0("\174\248\2\92\134\172", "\227\222\148\99\37"), 17) or "";
				v129 = 1;
			end
			if ((v129 == 1) or (3966 > 4788)) then
				v102, v102, v103 = v32(":", v100);
				v102, v102, v104 = v32(":", v101);
				v129 = 2;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\253\203\60\194\63\255\216\56\202\47\228\215\48\222\52\249\216\62\211\59\227\192\56\223", "\122\173\135\125\155"));
	local function v110()
		return (v14:HealthPercentage() < v45) or ((v14:HealthPercentage() < v46) and v14:BuffUp(v64.DeathStrikeBuff));
	end
	local function v111(v130)
		return ((v130:DebuffStack(v64.RazoriceDebuff) + 1) / (v130:DebuffRemains(v64.RazoriceDebuff) + 1)) * v21(v70);
	end
	local function v112(v131)
		return (v131:DebuffDown(v64.FrostFeverDebuff));
	end
	local function v113()
		local v132 = 0;
		while true do
			if ((3826 > 588) and (v132 == 1)) then
				if ((694 <= 1507) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\31\203\82\228\84\220\133\33\203\76\248\113\198\142\57\203\77", "\224\77\174\63\139\38\175")]:IsReady() and v15:IsInRange(8)) then
					if ((3900 >= 1116) and v29(v64.RemorselessWinter)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\150\68\85\33\150\82\93\34\129\82\75\17\147\72\86\58\129\83\24\62\150\68\91\33\137\67\89\58\196\21", "\78\228\33\56");
					end
				end
				break;
			end
			if ((4907 > 3311) and (v132 == 0)) then
				v73 = ((v56 > 59) and 25) or 45;
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\172\206\23\181\54\63\207\166\205\1\170\43", "\168\228\161\96\217\95\81")]:IsReady() and not v15:IsInRange(8)) or (3408 <= 2617)) then
					if ((3201 == 3201) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\222\57\80\38\89\220\238\44\80\46\68\207\145\62\78\42\84\212\220\44\93\59\23\137", "\55\187\177\78\60\79");
					end
				end
				v132 = 1;
			end
		end
	end
	local function v114()
		local v133 = 0;
		local v134;
		while true do
			if ((2195 == 2195) and (1 == v133)) then
				v134 = v68.HandleBottomTrinket(v67, v28, 40, nil);
				if (v134 or (3025 > 3506)) then
					return v134;
				end
				break;
			end
			if ((v133 == 0) or (736 < 356)) then
				v134 = v68.HandleTopTrinket(v67, v28, 40, nil);
				if ((1171 <= 2774) and v134) then
					return v134;
				end
				v133 = 1;
			end
		end
	end
	local function v115()
		local v135 = 0;
		while true do
			if ((4108 >= 312) and (v135 == 1)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\37\5\166\85\180\229\27\136\6\31\166\88\190\225", "\201\98\105\199\54\221\132\119")]:IsReady() and not v88 and v82) or (679 > 2893)) then
					if (v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100)) or (876 < 200)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\190\0\130\34\11\52\160\134\13\135\55\3\59\175\188\76\130\46\7\117\250", "\204\217\108\227\65\98\85");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\113\193\249\236\56\197\76\194\225\224", "\160\62\163\149\133\76")]:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\245\172\8\46\213\223\174\10\28\215\196\169\6\42\208", "\163\182\192\109\79")]:IsAvailable() and v14:BuffUp(v64.DeathAndDecayBuff) and not v84) or (2325 > 3562)) then
					if (v29(v64.Obliterate, nil, nil, not v15:IsInMeleeRange(5)) or (3661 > 4704)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\36\12\201\225\49\52\1\212\240\116\39\15\197\181\108", "\149\84\70\96\160");
					end
				end
				v135 = 2;
			end
			if ((v135 == 4) or (4133 <= 1928)) then
				if ((4418 >= 1433) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\140\22\30\180\74\174\130\57\170\13\9\168", "\80\196\121\108\218\37\200\213")]:IsCastable() and (v14:Rune() < 2) and (v14:RunicPowerDeficit() > 25)) then
					if (v29(v64.HornofWinter, v60) or (4123 >= 4123)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\124\16\113\116\1\140\63\100\11\113\95\11\152\64\114\13\122\11\95\210", "\234\96\19\98\31\43\110");
					end
				end
				if ((v28 and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\39\13\81\198\162\119\191\9\13\64\194\162\102", "\235\102\127\50\167\204\18")]:IsReady() and (v14:RunicPowerDeficit() > 25)) or (205 >= 2345)) then
					if (v29(v64.ArcaneTorrent, v54) or (537 == 1004)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\179\246\34\74\43\111\181\250\49\86\43\94\181\181\34\75\43\16\243\165", "\78\48\193\149\67\36");
					end
				end
				break;
			end
			if ((3 == v135) or (2345 < 545)) then
				if ((1649 > 243) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\119\21\43\79\76\18\53\71\76\18", "\38\56\119\71")]:IsReady() and not v84) then
					if (v29(v64.Obliterate, nil, nil, not v15:IsInMeleeRange(5)) or (3910 <= 3193)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\252\237\84\223\49\83\225\238\76\211\101\87\252\234\24\135\113", "\54\147\143\56\182\69");
					end
				end
				if ((2005 == 2005) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\240\147\240\90\203\229\149\237\64\212\211", "\191\182\225\159\41")]:IsReady() and not v88 and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\12\30\41\86\130\134\206\10\22\62\84\133\132\199", "\162\75\114\72\53\235\231")]:IsAvailable()) then
					if ((4688 > 4572) and v29(v64.FrostStrike, v58, nil, not v15:IsSpellInRange(v64.FrostStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\138\46\75\241\71\61\159\40\86\235\88\7\204\61\75\231\19\83\218", "\98\236\92\36\130\51");
					end
				end
				v135 = 4;
			end
			if ((1567 < 3260) and (0 == v135)) then
				if (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\252\123\191\12\151\221\123\190\6\150\221\73\187\13\145\203\108", "\229\174\30\210\99")]:IsReady() or (3761 == 621)) then
					if ((4755 > 3454) and v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\232\139\94\255\46\60\23\232\149\66\210\42\48\21\249\131\67\173\60\54\30\173\212", "\89\123\141\230\49\141\93");
					end
				end
				if ((4819 >= 1607) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\219\126\225\0\25\68\244\83\250\13\3\94", "\42\147\17\150\108\112")]:IsReady() and (v14:BuffUp(v64.RimeBuff) or v15:DebuffDown(v64.FrostFeverDebuff))) then
					if ((4546 >= 1896) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\169\58\115\238\230\8\153\47\115\230\251\27\230\44\112\226\168\91", "\136\111\198\77\31\135");
					end
				end
				v135 = 1;
			end
			if ((3546 > 933) and (v135 == 2)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\31\10\12\238\49\7\1\204\60\16\12\227\59\3", "\141\88\102\109")]:IsReady() and not v88) or (3985 <= 3160)) then
					if ((1987 == 1987) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\95\203\115\19\60\89\254\178\87\220\113\20\62\80\129\178\92\207\48\75\109", "\161\211\51\170\16\122\93\53");
					end
				end
				if ((994 <= 4540) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\221\188\189\59\239\189\177\49\239\166\183", "\72\155\206\210")]:IsReady() and v84) then
					if ((4917 == 4917) and v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\64\104\91\29\39\85\121\77\26\59\67\58\85\1\54\6\43\6", "\83\38\26\52\110");
					end
				end
				v135 = 3;
			end
		end
	end
	local function v116()
		local v136 = 0;
		while true do
			if ((v136 == 2) or (324 > 4896)) then
				if ((772 < 4670) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\173\76\83\86\164\204\76\131\90\90", "\62\226\46\63\63\208\169")]:IsReady() and ((v14:RunicPowerDeficit() > 40) or (v14:BuffUp(v64.PillarofFrostBuff) and (v14:RunicPowerDeficit() > 17)))) then
					if ((3172 >= 2578) and v68.CastTargetIf(v64.Obliterate, v97, LUAOBFUSACTOR_DECRYPT_STR_0("\232\24\77", "\62\133\121\53\227\127\109\79"), v111, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\22\62\252\194\171\176\17\0\55\181\212\188\167\17\0\58\181\135\250", "\194\112\116\82\149\182\206");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\29\173\77\12\200\195\0\61\140\73\27\193\251", "\110\89\200\44\120\160\130")]:IsReady() and (v14:RunicPower() < 36) and (v14:RuneTimeToX(2) > (v14:RunicPower() / 18))) or (721 == 834)) then
					if ((1312 < 2654) and v29(v66.DaDPlayer, v50, nil, not v15:IsSpellInRange(v64.DeathAndDecay))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\175\198\74\82\75\117\58\67\175\252\79\67\64\75\34\13\169\209\78\71\87\66\123\28\253", "\45\203\163\43\38\35\42\91");
					end
				end
				if ((3213 >= 1613) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\224\128\209\44\149\186\81\222\128\207\48\176\160\90\198\128\206", "\52\178\229\188\67\231\201")]:IsReady() and (v14:RunicPower() < 36) and (v14:RuneTimeToX(2) > (v14:RunicPower() / 18))) then
					if (v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(8)) or (3786 > 4196)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\51\68\93\11\229\79\38\45\68\67\23\200\75\42\47\85\85\22\183\94\49\36\64\68\12\183\13\123", "\67\65\33\48\100\151\60");
					end
				end
				v136 = 3;
			end
			if ((4218 == 4218) and (v136 == 4)) then
				if ((1517 < 4050) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\118\74\7\223\89\93\48\209\69\74\1\208\67", "\190\55\56\100")]:IsReady() and (v14:RunicPower() < 60)) then
					if ((4390 == 4390) and v29(v64.ArcaneTorrent, v54)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\189\63\31\29\230\204\66\160\46\12\22\237\231\22\173\46\27\18\247\251\22\253\106", "\147\54\207\92\126\115\131");
					end
				end
				break;
			end
			if ((1919 > 289) and (v136 == 3)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\247\232\185\212\250\209\224\140\212\242\204\243", "\147\191\135\206\184")]:IsReady() and (v14:RunicPower() < 36) and (v14:RuneTimeToX(2) > (v14:RunicPower() / 18))) or (1205 < 751)) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or (2561 <= 1717)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\140\39\177\205\209\93\181\187\42\170\192\203\71\242\134\58\163\192\204\91\242\214\120", "\210\228\72\198\161\184\51");
					end
				end
				if ((1723 <= 3600) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\25\75\255\25\103\203\36\72\231\21", "\174\86\41\147\112\19")]:IsReady() and (v14:RunicPowerDeficit() > 25)) then
					if ((3271 >= 1633) and v68.CastTargetIf(v64.Obliterate, v97, LUAOBFUSACTOR_DECRYPT_STR_0("\86\1\149", "\203\59\96\237\107\69\111\113"), v111, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\20\160\232\37\245\197\37\2\169\161\51\226\210\37\2\164\161\99\162", "\183\68\118\204\129\81\144");
					end
				end
				if ((3103 >= 2873) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\38\162\103\232\2\140\9\143\124\229\24\150", "\226\110\205\16\132\107")]:IsReady() and (v14:BuffUp(v64.RimeBuff))) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or (3603 == 725)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\204\247\213\72\229\196\223\219\77\234\208\244\153\67\249\198\225\205\73\171\145\180", "\33\139\163\128\185");
					end
				end
				v136 = 4;
			end
			if ((2843 == 2843) and (v136 == 0)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\2\27\141\23\83\35\27\140\29\82\35\41\137\22\85\53\12", "\33\80\126\224\120")]:IsReady() and (v72 or v80)) or (174 >= 2515)) then
					if ((4411 >= 2020) and v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\254\173\14\203\78\255\173\15\193\79\255\151\20\205\82\248\173\17\132\94\254\173\2\208\84\172\250", "\60\140\200\99\164");
					end
				end
				if ((1347 == 1347) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\175\251\19\42\171\137\243\38\42\163\148\224", "\194\231\148\100\70")]:IsReady() and v81 and (v14:RunicPower() > (45 - (v21(v64[LUAOBFUSACTOR_DECRYPT_STR_0("\116\77\198\166\249\206\82\68\196\133\228\199\92\73\207\128\254\201\75\92\200\172\248", "\168\38\44\161\195\150")]:IsAvailable()) * 8)))) then
					if ((4461 == 4461) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\136\243\149\122\57\230\177\41\130\240\131\101\36\168\180\4\133\253\150\126\112\188", "\118\224\156\226\22\80\136\214");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\106\225\75\142\77\232\110\137\76\250\92\146", "\224\34\142\57")]:IsReady() and (v14:Rune() < 2) and (v14:RunicPowerDeficit() > 25)) or (4340 == 2872)) then
					if ((568 <= 2207) and v29(v64.HornofWinter, v60)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\168\215\211\76\254\91\49\201\174\203\201\118\227\29\12\204\162\196\201\123\177\11", "\110\190\199\165\189\19\145\61");
					end
				end
				v136 = 1;
			end
			if ((v136 == 1) or (3789 <= 863)) then
				if ((238 < 4997) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\245\233\123\225\159\194\200\234\99\237", "\167\186\139\23\136\235")]:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and not v84) then
					if ((4285 > 3803) and v68.CastTargetIf(v64.Obliterate, v97, LUAOBFUSACTOR_DECRYPT_STR_0("\23\180\144", "\109\122\213\232"), v111, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\245\174\57\250\242\176\49\250\242\226\50\252\242\163\36\230\183\250", "\80\142\151\194");
					end
				end
				if ((2672 < 4910) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\37\212\120\95\23\213\116\85\23\206\114", "\44\99\166\23")]:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v84) then
					if (v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(8)) or (2956 > 4353)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\122\229\38\37\39\183\127\238\61\62\54\228\126\229\44\55\39\172\60\166\121", "\196\28\151\73\86\83");
					end
				end
				if ((3534 > 2097) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\213\17\38\3\150\75\27\111\231\11\44", "\22\147\99\73\112\226\56\120")]:IsReady() and v84 and (v14:RunicPower() > 45)) then
					if ((3255 >= 534) and v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\190\103\237\230\153\171\118\251\225\133\189\53\224\231\136\185\97\234\181\220\234", "\237\216\21\130\149");
					end
				end
				v136 = 2;
			end
		end
	end
	local function v117()
		local v137 = 0;
		while true do
			if ((4254 < 4460) and (v137 == 2)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\17\124\107\79\193\63\68\112\79\218\60\97", "\174\89\19\25\33")]:IsReady() and (v14:RunicPowerDeficit() > 25)) or (4661 <= 4405)) then
					if ((4575 >= 1943) and v29(v64.HornofWinter, v60)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\29\64\64\200\136\13\16\5\91\64\227\130\25\111\16\64\75\246\147\3\16\29\80\66\254\147\75\126\66", "\107\79\114\50\46\151\231");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\24\180\182\40\132\60\131\207\43\180\176\39\158", "\160\89\198\213\73\234\89\215")]:IsReady() and (v14:RunicPowerDeficit() > 20)) or (326 > 1137)) then
					if ((1284 == 1284) and v29(v64.ArcaneTorrent, v54)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\99\183\255\203\77\78\160\241\215\90\116\186\234\133\74\99\177\255\209\64\78\187\252\201\65\101\244\175\151", "\165\40\17\212\158");
					end
				end
				break;
			end
			if ((v137 == 1) or (3072 >= 3426)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\245\41\225\79\188\211\33\212\79\180\206\50", "\213\189\70\150\35")]:IsReady() and (v14:BuffUp(v64.RimeBuff))) or (4036 > 4375)) then
					if ((3928 == 3928) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\71\90\99\4\70\91\115\55\77\89\117\27\91\21\118\26\74\84\96\0\112\90\118\4\70\65\52\94", "\104\47\53\20");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\139\67\150\16\181\1\164\110\141\29\175\27", "\111\195\44\225\124\220")]:IsReady() and (v14:BuffDown(v64.KillingMachineBuff))) or (2629 >= 3005)) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or (2620 <= 422)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\73\23\127\162\165\223\121\2\127\170\184\204\6\2\97\174\170\204\78\63\124\169\167\209\82\64\43", "\203\184\38\96\19\203");
					end
				end
				v137 = 2;
			end
			if ((1896 > 1857) and (v137 == 0)) then
				if ((1466 >= 492) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\43\35\58\110\25\109\14\40\33\117\8", "\30\109\81\85\29\109")]:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v84) then
					if ((868 < 3853) and v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\99\91\165\34\205\255\230\101\92\179\118\220\238\250\112\64\190\9\209\254\243\120\64\246\100", "\156\159\17\52\214\86\190");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\129\237\177\181\186\234\175\189\186\234", "\220\206\143\221")]:IsReady() and (v14:BuffUp(v64.KillingMachineBuff))) or (1815 > 4717)) then
					if ((3671 == 3671) and v68.CastTargetIf(v64.Obliterate, v97, LUAOBFUSACTOR_DECRYPT_STR_0("\139\124\53", "\178\230\29\77\119\184\172"), v111, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\188\6\18\99\253\231\191\30\30\55\250\231\187\11\15\127\199\250\188\6\18\99\184\161", "\152\149\222\106\123\23");
					end
				end
				v137 = 1;
			end
		end
	end
	local function v118()
		local v138 = 0;
		while true do
			if ((216 <= 284) and (v138 == 0)) then
				if ((3257 > 2207) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\198\209\9\58\40\246\214\14\26\37\224", "\70\133\185\104\83")]:IsReady() and (v90 < v14:GCD()) and ((v14:Rune() < 2) or (v14:BuffDown(v64.KillingMachineBuff) and ((not v106 and (v14:BuffStack(v64.ColdHeartBuff) >= 4)) or (v106 and (v14:BuffStack(v64.ColdHeartBuff) > 8)))) or (v14:BuffUp(v64.KillingMachineBuff) and ((not v106 and (v14:BuffStack(v64.ColdHeartBuff) > 8)) or (v106 and (v14:BuffStack(v64.ColdHeartBuff) > 10)))))) then
					if (v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce)) or (2087 < 137)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\77\69\35\199\23\122\75\44\246\13\70\65\106\202\11\73\64\21\193\1\68\86\62\137\86", "\169\100\37\36\74");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\35\143\163\89\14\148\173\86\41\132\167", "\48\96\231\194")]:IsReady() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\231\88\2\36\13\221\189\130\220\83\1\35", "\227\168\58\110\77\121\184\207")]:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and (v14:BuffStack(v64.ColdHeartBuff) >= 10) and ((v14:BuffRemains(v64.PillarofFrostBuff) < (v14:GCD() * (1 + v21(v64[LUAOBFUSACTOR_DECRYPT_STR_0("\93\46\176\83\165\204\104\183\118\47\153\85\163\194", "\197\27\92\223\32\209\187\17")]:IsAvailable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\37\77\204\232\23\72\218\233\14\76\229\238\17\70", "\155\99\63\163")]:IsReady())))) or (v14:BuffUp(v64.UnholyStrengthBuff) and (v14:BuffRemains(v64.UnholyStrengthBuff) < v14:GCD())))) or (3923 >= 4763)) then
					if ((1744 == 1744) and v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\217\160\132\183\151\189\222\167\178\176\135\135\145\162\130\181\128\189\217\164\140\171\144\194\133", "\228\226\177\193\237\217");
					end
				end
				v138 = 1;
			end
			if ((248 <= 1150) and (v138 == 1)) then
				if ((3994 >= 294) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\23\184\34\239\58\163\44\224\29\179\38", "\134\84\208\67")]:IsReady() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\60\174\138\85\7\169\148\93\7\165\137\82", "\60\115\204\230")]:IsAvailable() and v71 and v14:BuffDown(v64.PillarofFrostBuff) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\215\51\231\124\230\40\228\118\193\40\228\99\243", "\16\135\90\139")]:CooldownRemains() > 15) and (((v14:BuffStack(v64.ColdHeartBuff) >= 10) and v14:BuffUp(v64.UnholyStrengthBuff)) or (v14:BuffStack(v64.ColdHeartBuff) >= 13))) then
					if ((1641 > 693) and v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\124\7\58\64\71\71\91\114\57\58\77\81\56\87\123\10\55\113\92\125\85\102\18\115\24", "\24\52\20\102\83\46\52");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\231\39\32\45\1\215\32\39\13\12\193", "\111\164\79\65\68")]:IsReady() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\233\219\143\215\58\239\212\216\151\215\33\228", "\138\166\185\227\190\78")]:IsAvailable() and not v71 and (v14:BuffStack(v64.ColdHeartBuff) >= 10) and v14:BuffDown(v64.PillarofFrostBuff) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\251\125\201\59\83\49\22\205\82\215\56\65\55", "\121\171\20\165\87\50\67")]:CooldownRemains() > 20)) or (4519 < 2235)) then
					if ((892 < 1213) and v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\48\184\63\183\17\249\55\191\9\176\1\195\120\186\57\181\6\249\48\188\55\171\22\134\96", "\98\166\88\217\86\217");
					end
				end
				v138 = 2;
			end
			if ((3313 <= 4655) and (v138 == 2)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\213\254\120\8\136\207\249\240\80\2\131", "\188\150\150\25\97\230")]:IsReady() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\245\139\83\11\24\232\200\136\75\11\3\227", "\141\186\233\63\98\108")]:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and (((v14:BuffStack(v64.ColdHeartBuff) >= 14) and (v14:BuffUp(v64.UnholyStrengthBuff))) or (v14:BuffStack(v64.ColdHeartBuff) >= 19) or ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\193\227\32\186\36\227\229\42\144\55\254\249\56", "\69\145\138\76\214")]:CooldownRemains() < 3) and (v14:BuffStack(v64.ColdHeartBuff) >= 14)))) or (3956 < 2705)) then
					if ((1959 < 3037) and v29(v64.ChainsofIce, nil, not v15:IsSpellInRange(v64.ChainsofIce))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\115\199\136\128\177\5\79\192\143\182\182\21\117\143\138\134\179\18\79\199\140\136\173\2\48\158\217", "\118\16\175\233\233\223");
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v139 = 0;
		while true do
			if ((v139 == 6) or (1241 > 2213)) then
				if ((4905 < 4974) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\169\245\132\251\53\172\254\129\203\56\142\241\156", "\93\237\144\229\143")]:IsReady() and v14:BuffDown(v64.DeathAndDecayBuff) and v80 and ((v14:BuffUp(v64.PillarofFrostBuff) and (v14:BuffRemains(v64.PillarofFrostBuff) > 5) and (v14:BuffRemains(v64.PillarofFrostBuff) < 11)) or (v14:BuffDown(v64.PillarofFrostBuff) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\37\255\252\21\10\84\26\240\214\11\4\85\1", "\38\117\150\144\121\107")]:CooldownRemains() > 10)) or (v90 < 11)) and ((v94 > 5) or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\14\183\235\59\59\178\224\61\30\175\252\51\38\190\253", "\90\77\219\142")]:IsAvailable() and (v94 >= 2)))) then
					if ((3557 == 3557) and v29(v66.DaDPlayer, v50)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\1\32\45\68\56\123\232\0\30\61\73\4\123\255\68\34\54\67\11\126\233\19\47\42\12\84\34", "\26\134\100\65\89\44\103");
					end
				end
				break;
			end
			if ((369 == 369) and (v139 == 2)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\222\46\12\30\5\19\233\52\0\19\2", "\64\157\70\101\114\105")]:IsReady() and (v14:HasTier(31, 2))) or (3589 < 2987)) then
					if ((4378 > 2853) and v29(v64.ChillStreak, nil, nil, not v15:IsSpellInRange(v64.ChillStreak))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\160\174\239\28\127\187\179\241\21\65\163\231\224\31\79\164\163\236\7\78\187\231\178\69", "\112\32\200\199\131");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\15\88\85\180\207\152\54\62\85\93\179", "\66\76\48\60\216\163\203")]:IsReady() and not v14:HasTier(31, 2) and (v94 >= 2) and ((v14:BuffDown(v64.DeathAndDecayBuff) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\153\138\124\242\73\199\42\189\181\109\225\86\197\33\169", "\68\218\230\25\147\63\174")]:IsAvailable()) or not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\142\38\86\77\160\164\36\84\127\162\191\35\88\73\165", "\214\205\74\51\44")]:IsAvailable() or (v94 <= 5))) or (1712 > 3602)) then
					if ((4539 >= 2733) and v29(v64.ChillStreak, nil, nil, not v15:IsSpellInRange(v64.ChillStreak))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\68\235\240\123\197\95\246\238\114\251\71\162\255\120\245\64\230\243\96\244\95\162\173\33", "\23\154\44\130\156");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\33\175\161\162\55\1\30\160\139\188\57\0\5", "\115\113\198\205\206\86")]:IsCastable() and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\171\85\242\83\144\82\236\91\144\94\241\84", "\58\228\55\158")]:IsAvailable() and (v80 or v79) and (v14:BuffUp(v64.EmpowerRuneWeaponBuff) or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\145\132\192\33\43\168\39\134\156\222\43\11\168\52\164\134\222", "\85\212\233\176\78\92\205")]:CooldownRemains() > 0))) or (v90 < 12))) or (2599 <= 515)) then
					if (v29(v64.PillarofFrost, v62) or (3754 < 810)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\81\132\238\75\74\183\237\76\103\142\240\69\75\156\162\73\87\135\238\78\87\159\236\89\24\217\186", "\130\42\56\232");
					end
				end
				v139 = 3;
			end
			if ((1633 <= 1977) and (1 == v139)) then
				if ((4528 >= 3619) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\41\91\6\82\1\87\8\75\1\86\7\115\1\84\11", "\63\104\57\105")]:IsCastable() and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\36\133\168\77\31\130\182\69\31\142\171\74", "\36\107\231\196")]:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\109\188\174\139\92\167\173\129\123\167\173\148\73", "\231\61\213\194")]:CooldownRemains() < 3) and (v80 or v79)) or (v90 < 12))) then
					if (v29(v64.AbominationLimb, nil, not v15:IsInRange(20)) or (172 >= 2092)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\175\50\126\0\163\60\103\0\162\51\76\5\164\48\113\54\185\60\127\12\163\41\51\10\162\50\127\13\162\42\125\26\237\108\35", "\19\105\205\93");
					end
				end
				if ((2120 == 2120) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\136\10\209\140\54\167\9\202\136\48\167\36\215\140\61", "\95\201\104\190\225")]:IsCastable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\141\217\196\207\187\195\206\200\156\194\207\202\189\202\198\193\188\202", "\174\207\171\161")]:IsAvailable() and (v80 or v79)) then
					if (v29(v64.AbominationLimb, nil, not v15:IsInRange(20)) or (2398 == 358)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\236\252\2\254\241\217\236\234\4\252\246\232\225\247\0\241\199\195\236\242\8\253\236\151\238\241\2\255\252\216\250\240\30\179\169\133", "\183\141\158\109\147\152");
					end
				end
				if ((2387 < 4637) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\13\11\233\1\37\7\231\24\37\6\232\32\37\4\228", "\108\76\105\134")]:IsCastable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\201\215\180\224\218\227\202\183\210\199\229\193\163\224\201\228\214\176", "\174\139\165\209\129")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\140\177\238\200\210\6\98\121\183\186\237\207", "\24\195\211\130\161\166\99\16")]:IsAvailable() and (v80 or v79)) then
					if ((1265 < 2775) and v29(v64.AbominationLimb, nil, not v15:IsInRange(20))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\71\1\230\33\90\24\71\23\224\35\93\41\74\10\228\46\108\2\71\15\236\34\71\86\69\12\230\32\87\25\81\13\250\108\2\66", "\118\38\99\137\76\51");
					end
				end
				v139 = 2;
			end
			if ((v139 == 3) or (4430 < 51)) then
				if ((1871 <= 1998) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\218\188\40\239\65\45\229\179\2\241\79\44\254", "\95\138\213\68\131\32")]:IsCastable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\8\58\164\66\98\34\39\167\112\127\36\44\179\66\113\37\59\160", "\22\74\72\193\35")]:IsAvailable() and (v80 or v79) and ((not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\5\122\225\91\45\105", "\56\76\25\132")]:IsAvailable() and ((v14:RunicPower() > 70) or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\124\211\174\39\219\86\206\173\21\198\80\197\185\39\200\81\210\170", "\175\62\161\203\70")]:CooldownRemains() > 40))) or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\21\222\198\16\52\44", "\85\92\189\163\115")]:IsAvailable() and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\11\190\53\57\61\164\63\62\26\165\62\60\59\173\55\55\58\173", "\88\73\204\80")]:CooldownRemains() > 10) or v14:BuffUp(v64.BreathofSindragosa))))) then
					if (v29(v64.PillarofFrost, v62) or (2083 >= 3954)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\138\28\74\40\200\17\140\22\121\47\200\33\144\4\6\42\213\33\143\20\73\62\212\61\195\66\22", "\186\78\227\112\38\73");
					end
				end
				if ((1857 > 59) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\204\94\241\89\82\104\243\81\219\71\92\105\232", "\26\156\55\157\53\51")]:IsCastable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\165\219\19\218\185\64", "\48\236\184\118\185\216")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\202\191\91\57\219\49\247\188\67\57\192\58", "\84\133\221\55\80\175")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\159\245\33\167\211\84\178\225\23\175\201\88\175\230\35\169\212\93", "\60\221\135\68\198\167")]:IsAvailable() and (v80 or v79)) then
					if (v29(v64.PillarofFrost, v62) or (1232 == 3045)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\254\180\244\143\67\203\209\178\254\188\68\203\225\174\236\195\65\214\225\177\252\140\85\215\253\253\170\209", "\185\142\221\152\227\34");
					end
				end
				if ((104 == 104) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\122\215\82\251\87\59\248\94\246\94\244\71\33\246\95\202\68\251", "\151\56\165\55\154\35\83")]:IsReady() and ((v14:BuffDown(v64.BreathofSindragosa) and (v14:RunicPower() > 60) and (v80 or v79)) or (v90 < 30))) then
					if ((4534 > 2967) and v29(v64.BreathofSindragosa, v57, nil, not v15:IsInRange(12))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\162\81\0\239\180\75\58\225\166\124\22\231\174\71\23\239\167\76\22\239\224\64\10\225\172\71\10\249\174\80\69\188\244", "\142\192\35\101");
					end
				end
				v139 = 4;
			end
			if ((v139 == 0) or (3449 <= 2368)) then
				if ((4733 >= 3548) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\174\137\37\180\249\142\111\185\145\59\190\217\142\124\155\139\59", "\29\235\228\85\219\142\235")]:IsCastable() and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\18\214\182\212\99\75\53\83\41\221\181\211", "\50\93\180\218\189\23\46\71")]:IsAvailable() and v14:BuffDown(v64.EmpowerRuneWeaponBuff) and (v14:Rune() < 6) and (((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\238\173\87\64\69\206\71\216\130\73\67\87\200", "\40\190\196\59\44\36\188")]:CooldownRemains() < 7) and (v80 or v79)) or v14:BuffUp(v64.PillarofFrostBuff))) or (v90 < 20))) then
					if (v29(v64.EmpowerRuneWeapon, v51) or (2005 > 4687)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\72\204\187\237\120\31\3\87\201\186\255\66\26\57\68\204\187\244\61\14\51\74\208\176\245\106\3\47\5\136", "\109\92\37\188\212\154\29");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\33\226\180\204\38\95\22\221\177\205\52\109\1\238\180\204\63", "\58\100\143\196\163\81")]:IsCastable() and ((v14:BuffUp(v64.BreathofSindragosa) and v14:BuffDown(v64.EmpowerRuneWeaponBuff) and (v10.CombatTime() < 10) and v14:BloodlustUp()) or ((v14:RunicPower() < 70) and (v14:Rune() < 3) and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\56\80\38\162\43\65\234\8\41\75\45\167\45\72\226\1\9\67", "\110\122\34\67\195\95\41\133")]:CooldownRemains() > v73) or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\80\188\75\69\193\112\163\105\95\216\112\134\94\75\198\122\191", "\182\21\209\59\42")]:FullRechargeTime() < 10))))) or (1767 <= 916)) then
					if ((3589 < 3682) and v29(v64.EmpowerRuneWeapon, v51)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\90\213\18\54\187\165\104\215\8\47\187\136\64\192\28\49\177\185\23\198\18\46\178\179\88\210\19\50\254\225", "\222\215\55\165\125\65");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\9\220\214\21\229\196\255\120\57\223\195\45\247\192\253\69\34", "\42\76\177\166\122\146\161\141")]:IsCastable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\135\152\0\207\109\126\170\140\54\199\119\114\183\139\2\193\106\119", "\22\197\234\101\174\25")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\2\54\169\213\98\170\197\135\57\61\170\210", "\230\77\84\197\188\22\207\183")]:IsAvailable() and v14:BuffDown(v64.EmpowerRuneWeaponBuff) and (v14:Rune() < 5) and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\201\29\202\240\141\179\255\51\223\6\201\239\152", "\85\153\116\166\156\236\193\144")]:CooldownRemains() < 7) or v14:BuffUp(v64.PillarofFrostBuff) or not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\148\233\65\191\229\18\171\230\107\161\235\19\176", "\96\196\128\45\211\132")]:IsAvailable())) or (75 >= 430)) then
					if (v29(v64.EmpowerRuneWeapon, v51) or (4157 <= 3219)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\128\107\80\197\170\166\231\39\152\117\90\237\184\177\217\37\130\117\31\209\160\187\212\49\130\108\81\193\239\236", "\184\85\237\27\63\178\207\212");
					end
				end
				v139 = 1;
			end
			if ((1823 < 2782) and (v139 == 4)) then
				if ((3434 >= 1764) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\240\103\38\176\243\155\181\4\219\102\15\182\245\149", "\118\182\21\73\195\135\236\204")]:IsCastable() and (((v94 == 1) and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\56\53\22\76\5\31\242\14\26\8\79\23\25", "\157\104\92\122\32\100\109")]:IsAvailable() and (v14:BuffRemains(v64.PillarofFrostBuff) < (v14:GCD() * 2)) and v14:BuffUp(v64.PillarofFrostBuff) and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\140\164\195\195\41\34\159\170\183\175\192\196", "\203\195\198\175\170\93\71\237")]:IsAvailable()) or not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\30\66\50\217\80\3\243\40\109\44\218\66\5", "\156\78\43\94\181\49\113")]:IsAvailable())) or (v90 < 3))) then
					if ((4040 > 1820) and v29(v64.FrostwyrmsFury, v59, nil, not v15:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\116\250\203\176\31\84\96\96\229\215\156\13\86\107\107\168\199\172\4\79\125\125\255\202\176\75\17\47", "\25\18\136\164\195\107\35");
					end
				end
				if ((4192 >= 2529) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\206\63\166\92\102\171\216\170\229\62\143\90\96\165", "\216\136\77\201\47\18\220\161")]:IsCastable() and (v94 >= 2) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\29\229\39\214\9\206\141\43\202\57\213\27\200", "\226\77\140\75\186\104\188")]:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and (v14:BuffRemains(v64.PillarofFrostBuff) < (v14:GCD() * 2))) then
					if ((1554 < 2325) and v29(v64.FrostwyrmsFury, v59, nil, not v15:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\220\223\44\91\174\215\194\50\92\134\200\197\45\86\249\205\223\48\67\189\193\199\49\92\249\156\136", "\47\217\174\176\95");
					end
				end
				if ((1108 < 4525) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\121\17\166\67\97\52\181\206\80\23\160\77", "\70\216\189\22\98\210\52\24")]:IsCastable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\245\221\175\142\199\223\205\162\147\218\213\209", "\179\186\191\195\231")]:IsAvailable() and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\201\54\20\232\248\45\23\226\223\45\23\247\237", "\132\153\95\120")]:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and not v106) or (v14:BuffDown(v64.PillarofFrostBuff) and v106 and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\129\187\2\33\246\200\175\183\148\28\34\228\206", "\192\209\210\110\77\151\186")]:CooldownDown()) or not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\208\10\46\229\254\214\239\5\4\251\240\215\244", "\164\128\99\66\137\159")]:IsAvailable()) and ((v14:BuffRemains(v64.PillarofFrostBuff) < v14:GCD()) or (v14:BuffUp(v64.UnholyStrengthBuff) and (v14:BuffRemains(v64.UnholyStrengthBuff) < v14:GCD()))) and ((v15:DebuffStack(v64.RazoriceDebuff) == 5) or (not v70 and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\39\133\232\189\9\136\229\159\4\159\232\176\3\140", "\222\96\233\137")]:IsAvailable()))) then
					if (v29(v64.FrostwyrmsFury, v59, nil, not v15:IsInRange(40)) or (4367 <= 3332)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\161\168\12\156\228\233\171\190\180\32\142\230\226\160\243\164\16\135\255\244\182\164\169\12\200\160\160", "\144\217\211\199\127\232\147");
					end
				end
				v139 = 5;
			end
			if ((v139 == 5) or (2896 > 4641)) then
				if ((882 > 21) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\202\46\55\59\208\97\7\69\252", "\36\152\79\94\72\181\37\98")]:IsCastable()) then
					if ((2373 <= 4789) and v29(v64.RaiseDead, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\217\78\44\210\231\67\58\214\220\7\60\216\215\75\59\216\207\73\44\151\139\21", "\95\183\184\39");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\134\48\242\42\102\133\3\165\58\245", "\98\213\95\135\70\52\224")]:IsReady() and (v90 > 5) and ((v15:TimeToX(35) < 5) or (v15:HealthPercentage() <= 35)) and (v94 <= 2) and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\209\161\197\126\64\251\177\200\99\93\241\173", "\52\158\195\169\23")]:IsAvailable() and ((v14:BuffUp(v64.PillarofFrostBuff) and v14:BuffDown(v64.KillingMachineBuff)) or v14:BuffDown(v64.PillarofFrostBuff))) or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\88\174\55\117\146\61\116\141\73\181\60\112\148\52\124\132\105\189", "\235\26\220\82\20\230\85\27")]:IsAvailable() and ((v14:BuffUp(v64.BreathofSindragosa) and (v14:RunicPower() > 40)) or v14:BuffDown(v64.BreathofSindragosa))) or (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\170\179\236\195\96\128\174\239\241\125\134\165\251\195\115\135\178\232", "\20\232\193\137\162")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\13\221\201\175\243\137\5\112\54\214\202\168", "\17\66\191\165\198\135\236\119")]:IsAvailable()))) or (1839 < 1136)) then
					if ((3430 == 3430) and v29(v64.SoulReaper, nil, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\160\187\31\192\250\233\208\31\170\188\83\252\231\227\221\11\160\185\29\236\168\191\133", "\177\111\207\206\115\159\136\140");
					end
				end
				if ((748 <= 2288) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\54\136\19\6\221\73\86\6\128\17\24\228\78\92\17", "\63\101\233\112\116\180\47")]:IsReady() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\228\55\236\17\241\55\207\26\233\4\249\56\192\62", "\86\163\91\141\114\152")]:IsAvailable() and v14:BuffDown(v64.BreathofSindragosa) and (v91:GhoulRemains() < (v14:GCD() * 2)) and (v94 > 3)) then
					if ((891 < 4473) and v29(v64.SacrificialPact, v52)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\64\10\119\97\51\85\2\119\122\59\95\52\100\114\57\71\75\119\124\53\95\15\123\100\52\64\75\39\37", "\90\51\107\20\19");
					end
				end
				v139 = 6;
			end
		end
	end
	local function v120()
		local v140 = 0;
		while true do
			if ((0 == v140) or (3071 <= 2647)) then
				if ((v47 and v28) or (633 > 1640)) then
					local v170 = 0;
					while true do
						if ((3764 > 2404) and (v170 == 0)) then
							if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\208\237\36\42\137\240\228\57\32\151\249\230\60\47", "\196\145\131\80\67")]:IsCastable() and (v14:RunicPowerDeficit() > 40)) or (3811 >= 4158)) then
								if ((743 > 47) and v29(v64.AntiMagicShell, v48)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\31\190\18\1\21\233\25\185\5\55\11\224\27\188\10\72\16\225\25\184\57\24\10\225\17\143\7\11\12\225\17\190\21\72\74", "\136\126\208\102\104\120");
								end
							end
							if ((3599 >= 1059) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\89\132\218\74\130\83\58\88\123\176\193\77\170", "\49\24\234\174\35\207\50\93")]:IsCastable() and (v14:RunicPowerDeficit() > 70) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\45\225\238\129\124\5\254\252\156\120\3\252", "\17\108\146\157\232")]:IsAvailable() and ((v14:BuffUp(v64.BreathofSindragosa) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\110\206\4\226\56\173\89\241\1\227\42\159\78\194\4\226\33", "\200\43\163\116\141\79")]:Charges() < 2)) or (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\157\36\56\130\164\252\236\185\5\52\141\180\230\226\184\57\46\130", "\131\223\86\93\227\208\148")]:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff)))) then
								if ((1371 <= 2507) and v29(v64.AntiMagicZone, v49)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\226\75\162\191\16\180\228\76\181\137\7\186\237\64\246\190\20\178\235\122\166\164\20\186\220\68\181\162\20\186\237\86\246\226", "\213\131\37\214\214\125");
								end
							end
							break;
						end
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\14\36\50\179\232\40\44\7\179\224\53\63", "\129\70\75\69\223")]:IsReady() and v15:DebuffDown(v64.FrostFeverDebuff) and (v94 >= 2) and (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\105\201\255\224\104\234\84\202\231\224\115\225", "\143\38\171\147\137\28")]:IsAvailable() or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\255\128\181\250\23\230\198\209\150\176\252\13", "\180\176\226\217\147\99\131")]:IsAvailable() and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\227\176\35\11\210\171\32\1\245\171\32\20\199", "\103\179\217\79")]:CooldownDown() or (v14:BuffUp(v64.PillarofFrostBuff) and v14:BuffDown(v64.KillingMachineBuff)))))) or (3607 == 2536)) then
					if ((1126 < 3675) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\66\184\11\217\72\130\164\117\181\16\212\82\152\227\66\190\27\221\126\156\177\67\184\35\212\66\152\170\69\185\15\149\23", "\195\42\215\124\181\33\236");
					end
				end
				v140 = 1;
			end
			if ((v140 == 4) or (3344 >= 3615)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\129\211\192\206\219\178\64\191\211\222\210\254\168\75\167\211\223", "\37\211\182\173\161\169\193")]:IsReady() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\213\40\72\216\60\115\182\241\9\68\215\44\105\184\240\53\94\216", "\217\151\90\45\185\72\27")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\236\126\235\27\66\198\110\230\6\95\204\114", "\54\163\28\135\114")]:IsAvailable() and v72) or (4776 <= 210)) then
					if (v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(8)) or (2613 > 2752)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\222\80\141\92\108\45\215\88\145\93\64\63\210\83\150\75\109\104\211\84\133\70\64\56\201\84\141\113\126\43\207\84\141\64\108\104\137\13", "\31\72\187\61\226\46");
					end
				end
				if ((4542 > 2119) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\241\3\78\221\85\109\33\207\3\80\193\112\119\42\215\3\81", "\68\163\102\35\178\39\30")]:IsReady() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\145\114\214\206\23\176\145\16\170\121\213\201", "\113\222\16\186\167\99\213\227")]:IsAvailable() and (v94 >= 3) and v80) then
					if (v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(8)) or (1039 == 338)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\11\246\249\60\29\254\250\43\29\232\201\57\7\245\226\43\28\187\254\39\9\243\201\62\28\242\249\17\15\248\226\39\1\245\229\110\92\169", "\150\78\110\155");
					end
				end
				break;
			end
			if ((v140 == 2) or (4131 > 4610)) then
				if ((4129 >= 672) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\59\247\11\225\21\250\6\195\24\237\11\236\31\254", "\130\124\155\106")]:IsReady() and (v94 >= 2) and v82 and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\247\217\243\174\183\254\115\185\230\194\248\171\177\247\123\176\198\202", "\223\181\171\150\207\195\150\28")]:IsAvailable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\99\56\239\167\29\73\40\226\186\0\67\52", "\105\44\90\131\206")]:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff)) then
					if ((1019 < 3466) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\236\179\186\1\63\243\223\179\189\30\63\241\227\183\249\0\55\248\232\141\169\26\55\240\223\179\186\28\55\240\238\161\249\89\108", "\94\159\128\210\217\104");
					end
				end
				if ((290 <= 855) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\118\235\9\172\75\76\237\104\89\242\3", "\26\48\153\102\223\63\31\153")]:IsReady() and (v94 == 1) and v82 and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\45\66\225\250\22\69\255\242\22\73\226\253", "\147\98\32\141")]:IsAvailable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\58\81\230\203\18\94\68\30\112\234\196\2\68\74\31\76\240\203", "\43\120\35\131\170\102\54")]:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and v14:BuffDown(v64.BreathofSindragosa) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\118\20\130\183\177\184\139\82\53\142\184\161\162\133\83\9\148\183", "\228\52\102\231\214\197\208")]:CooldownRemains() > v86)) then
					if ((4601 > 4446) and v29(v64.FrostStrike, nil, nil, not v15:IsSpellInRange(v64.FrostStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\242\122\217\254\180\10\194\12\233\126\207\170\131\16\209\22\223\101\216\227\132\38\215\29\244\124\197\228\152\89\135\74", "\182\126\128\21\170\138\235\121");
					end
				end
				v140 = 3;
			end
			if ((v140 == 3) or (995 >= 2099)) then
				if ((961 < 4006) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\173\200\58\245\146\32\36\20\130\209\48", "\102\235\186\85\134\230\115\80")]:IsReady() and (v94 == 1) and v82 and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\117\30\59\94\102\220\45\81\63\55\81\118\198\35\80\3\45\94", "\66\55\108\94\63\18\180")]:IsAvailable() and v14:BuffDown(v64.BreathofSindragosa) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\54\159\128\54\51\81\27\139\182\62\41\93\6\140\130\56\52\88", "\57\116\237\229\87\71")]:CooldownRemains() > v86)) then
					if ((2694 < 4854) and v29(v64.FrostStrike, nil, nil, not v15:IsSpellInRange(v64.FrostStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\172\163\226\244\99\209\84\190\163\228\236\114\174\79\163\182\229\216\103\252\78\165\142\236\228\99\231\72\164\162\173\182\33", "\39\202\209\141\135\23\142");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\217\33\6\25\38\203\235\33\0\1\55", "\152\159\83\105\106\82")]:IsReady() and (v94 == 1) and v82 and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\163\212\84\243\221\84\142\192\98\251\199\88\147\199\86\253\218\93", "\60\225\166\49\146\169")]:IsAvailable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\0\28\35\35\21\2\61\31\59\35\14\9", "\103\79\126\79\74\97")]:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff)) or (4174 <= 3733)) then
					if (v29(v64.FrostStrike, nil, nil, not v15:IsSpellInRange(v64.FrostStrike)) or (2626 <= 648)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\188\109\220\96\74\37\169\107\193\122\85\31\250\119\218\116\86\37\170\109\218\124\97\27\185\107\218\124\80\9\250\46\139", "\122\218\31\179\19\62");
					end
				end
				v140 = 4;
			end
			if ((1595 <= 2078) and (v140 == 1)) then
				if ((1635 > 653) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\42\85\54\61\44\249\1\120\51\40\36\246\14\92", "\152\109\57\87\94\69")]:IsReady() and (v94 >= 2) and v82 and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\214\213\6\170\170\215\70\169\237\222\5\173", "\200\153\183\106\195\222\178\52")]:IsAvailable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\16\241\141\60\93\82\61\229\187\52\71\94\32\226\143\50\90\91", "\58\82\131\232\93\41")]:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and v14:BuffDown(v64.BreathofSindragosa) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\161\69\213\20\73\55\140\81\227\28\83\59\145\86\215\26\78\62", "\95\227\55\176\117\61")]:CooldownRemains() > v86)) then
					if ((3738 == 3738) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\114\34\72\162\25\114\28\74\175\14\127\45\72\174\88\118\42\76\163\39\110\49\66\164\39\127\32\95\162\23\112\48\11\243", "\203\120\30\67\43");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\214\41\76\236\208\240\41\108\235\207\240\43\78\234", "\185\145\69\45\143")]:IsReady() and (v94 >= 2) and v82 and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\168\13\28\167\200\130\16\31\149\213\132\27\11\167\219\133\12\24", "\188\234\127\121\198")]:IsAvailable() and v14:BuffDown(v64.BreathofSindragosa) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\26\32\22\130\44\58\28\133\11\59\29\135\42\51\20\140\43\51", "\227\88\82\115")]:CooldownRemains() > v86)) or (3963 > 4742)) then
					if (v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100)) or (4072 > 4695)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\19\187\164\11\114\79\32\187\163\20\114\77\28\191\231\10\122\68\23\133\183\16\122\76\32\187\164\22\122\76\17\169\231\83\35", "\19\35\127\218\199\98");
					end
				end
				v140 = 2;
			end
		end
	end
	local function v121()
		local v141 = 0;
		while true do
			if ((v141 == 2) or (2220 > 2889)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\121\167\19\255\21\25\95\115\164\5\224\8", "\56\49\200\100\147\124\119")]:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and (v15:DebuffDown(v64.FrostFeverDebuff) or (v14:BuffUp(v64.RimeBuff) and v14:HasTier(30, 2) and not v82))) or (4914 < 4399)) then
					if ((3660 == 3660) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\49\168\252\197\48\184\207\206\50\190\227\216\126\176\242\192\55\171\245\222\63\171\249\195\48\255\161\152", "\144\172\94\223");
					end
				end
				if ((2915 >= 196) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\3\3\163\68\45\14\174\102\32\25\163\73\39\10", "\39\68\111\194")]:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and ((not v70 and (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\247\176\230\203\120\185\213\174\226", "\215\182\198\135\167\25")]:IsAvailable() or (v15:DebuffStack(v64.RazoriceDebuff) < 5) or (v15:DebuffRemains(v64.RazoriceDebuff) < (v14:GCD() * 3)))) or (v82 and (v93 > 1)))) then
					if (v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100)) or (4638 < 3902)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\138\69\235\75\132\72\230\119\140\77\252\73\131\74\239\8\130\75\230\65\153\76\248\73\153\64\229\70\205\24\188", "\40\237\41\138");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\225\102\245\235\94\244\96\232\241\65\194", "\42\167\20\154\152")]:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and ((v14:Rune() < 2) or v82 or ((v15:DebuffStack(v64.RazoriceDebuff) == 5) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\121\246\163\86\101\36\88\247\172\69\83\45\75\250\167", "\65\42\158\194\34\17")]:IsAvailable())) and not v88 and (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\61\43\83\15\36\236\23\207\30\49\83\2\46\232", "\142\122\71\50\108\77\141\123")]:IsAvailable() or (v94 == 1))) or (1100 >= 1292)) then
					if (v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(5)) or (547 > 3511)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\176\240\11\47\42\177\235\10\50\30\167\191\23\57\25\171\235\29\41\20\182\246\23\53\85\243\167", "\91\117\194\159\120");
					end
				end
				v141 = 3;
			end
			if ((v141 == 5) or (314 > 2132)) then
				if ((932 == 932) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\218\27\80\104\252\207\29\77\114\227\249", "\136\156\105\63\27")]:IsReady() and not v88 and (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\60\128\120\55\18\141\117\21\31\154\120\58\24\137", "\84\123\236\25")]:IsAvailable() or (v94 == 1))) then
					if (v68.CastTargetIf(v64.FrostStrike, v97, LUAOBFUSACTOR_DECRYPT_STR_0("\253\138\178", "\213\144\235\202\119\204"), v111, nil, not v15:IsInMeleeRange(5)) or (2939 == 4366)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\10\209\57\60\28\94\55\10\215\33\45\99\66\33\20\215\62\45\49\76\55\17\209\36\104\112\31", "\45\67\120\190\74\72\67");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\8\45\250\169\240\134\233\203\44\35\254\177", "\137\64\66\141\197\153\232\142")]:IsReady() and (v14:BuffUp(v64.RimeBuff))) or (3969 <= 3657)) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or (1379 == 1462)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\11\223\53\170\129\13\215\29\164\132\2\195\54\230\135\1\220\43\178\141\17\209\54\175\135\13\144\113\242", "\232\99\176\66\198");
					end
				end
				if (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\195\35\36\15\111\136\235\45\248\36", "\76\140\65\72\102\27\237\153")]:IsReady() or (4606 <= 3927)) then
					if (v68.CastTargetIf(v64.Obliterate, v97, LUAOBFUSACTOR_DECRYPT_STR_0("\71\219\14", "\222\42\186\118\178\183\97"), v111, nil, not v15:IsInMeleeRange(5)) or (1578 <= 1012)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\238\72\131\73\233\86\139\73\233\4\133\95\224\77\158\88\254\69\158\84\227\74\202\14\186", "\234\61\140\36");
					end
				end
				break;
			end
			if ((v141 == 4) or (2399 > 3386)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\246\132\104\51\43\40\217\169\115\62\49\50", "\70\190\235\31\95\66")]:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and (v14:RunicPower() < 25)) or (3476 > 4701)) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or (4374 <= 3729)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\237\13\234\236\180\229\37\228\233\187\241\14\166\234\184\238\19\242\224\168\227\14\239\234\180\162\72\176", "\133\218\130\122\134");
					end
				end
				if ((v28 and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\29\237\224\197\210\166\12\51\237\241\193\210\183", "\88\92\159\131\164\188\195")]:IsReady() and (v14:Rune() < 1) and (v14:RunicPower() < 25)) or (4938 <= 1325)) then
					if (v29(v64.ArcaneTorrent, v54) or (2930 > 4142)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\60\188\74\217\238\226\148\33\173\89\210\229\201\192\33\189\71\222\255\216\146\47\171\66\216\229\157\210\118", "\189\224\78\223\43\183\139");
					end
				end
				if ((583 >= 133) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\9\240\139\21\200\47\240\171\18\215\47\242\137\19", "\161\78\156\234\118")]:IsReady() and not v88 and (v94 >= 2)) then
					if ((432 == 432) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\160\187\200\223\174\182\197\227\166\179\223\221\169\180\204\156\168\181\197\213\179\178\219\221\179\190\198\210\231\228\153", "\188\199\215\169");
					end
				end
				v141 = 5;
			end
			if ((1456 <= 4224) and (v141 == 1)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\106\29\45\236\68\16\32\206\73\7\45\225\78\20", "\143\45\113\76")]:IsReady() and (v14:BuffStack(v64.KillingMachineBuff) < 2) and (v14:BuffRemains(v64.PillarofFrostBuff) < v14:GCD()) and v14:BuffDown(v64.DeathAndDecayBuff)) or (1698 >= 2384)) then
					if ((2711 < 3812) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\180\29\63\177\185\16\3\185\188\10\61\182\187\25\124\183\186\16\53\172\189\14\61\172\177\19\50\248\224", "\92\216\216\124");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\116\48\160\73\233\94\32\173\84\248", "\157\59\82\204\32")]:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and not v84) or (746 >= 2339)) then
					if ((3002 >= 894) and v68.CastTargetIf(v64.Obliterate, v97, LUAOBFUSACTOR_DECRYPT_STR_0("\53\63\251", "\209\88\94\131\154\137\138\179"), v111, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\163\200\117\10\38\35\35\60\164\132\115\28\47\56\54\45\179\197\104\23\44\63\98\121\241", "\66\72\193\164\28\126\67\81");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\193\62\167\75\50\101\228\53\188\80\35", "\22\135\76\200\56\70")]:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v84) or (1376 <= 1032)) then
					if ((2427 == 2427) and v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\139\34\247\55\73\242\142\41\236\44\88\161\130\50\244\45\73\228\159\49\236\45\82\239\205\97\170", "\129\237\80\152\68\61");
					end
				end
				v141 = 2;
			end
			if ((3491 > 3393) and (3 == v141)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\50\18\41\20\60\255\35\56\17\63\11\33", "\68\122\125\94\120\85\145")]:IsReady() and v14:BuffUp(v64.RimeBuff) and v14:BuffDown(v64.KillingMachineBuff)) or (3885 > 4312)) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or (2128 < 1754)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\19\216\82\193\215\189\40\30\195\95\219\205\250\24\30\195\87\220\220\168\22\8\198\81\198\153\232\71", "\218\119\124\175\62\168\185");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\130\252\73\199\172\241\68\229\161\230\73\202\166\245", "\164\197\144\40")]:IsReady() and not v88 and v82 and v14:BuffDown(v64.KillingMachineBuff) and (v94 >= 2)) or (4584 <= 3272)) then
					if ((1043 <= 3558) and v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\132\252\171\136\212\183\143\207\171\143\203\183\141\243\175\203\210\180\143\249\190\142\207\183\151\249\165\133\157\228\209", "\214\227\144\202\235\189");
					end
				end
				if ((71 == 71) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\203\183\136\104\4\128\71\46\228\174\130", "\92\141\197\231\27\112\211\51")]:IsReady() and v14:BuffDown(v64.KillingMachineBuff) and not v88 and (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\193\243\139\160\216\231\243\171\167\199\231\241\137\166", "\177\134\159\234\195")]:IsAvailable() or (v94 == 1))) then
					if ((2793 == 2793) and v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\187\249\48\179\221\130\248\43\178\192\182\238\127\175\203\177\226\43\165\219\188\255\54\175\199\253\185\107", "\169\221\139\95\192");
					end
				end
				v141 = 4;
			end
			if ((v141 == 0) or (561 > 911)) then
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\183\192\42\238\182\13\186\76\128\214\52\214\173\16\171\69\151", "\32\229\165\71\129\196\126\223")]:IsReady() and ((v94 > 3) or v64[LUAOBFUSACTOR_DECRYPT_STR_0("\228\136\208\137\132\199\202\135\195\178\149\218\209\132", "\181\163\233\164\225\225")]:IsAvailable())) or (677 >= 4143)) then
					if ((4422 > 2292) and v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\66\142\51\120\66\152\59\123\85\152\45\72\71\130\48\99\85\153\126\120\82\135\55\99\85\153\63\99\89\132\48\55\2", "\23\48\235\94");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\84\213\207\81\94\61\213\94\214\217\78\67", "\178\28\186\184\61\55\83")]:IsReady() and (v14:BuffStack(v64.KillingMachineBuff) < 2) and (v14:BuffRemains(v64.PillarofFrostBuff) < v14:GCD()) and v14:BuffUp(v64.RimeBuff)) or (3386 <= 2556)) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or (4932 < 902)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\194\80\48\251\0\242\251\207\75\61\225\26\181\203\207\75\53\230\11\231\197\217\78\51\252\78\161", "\149\164\173\39\92\146\110");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\213\53\31\12\14\40\231\53\25\20\31", "\123\147\71\112\127\122")]:IsReady() and (v14:BuffStack(v64.KillingMachineBuff) < 2) and (v14:BuffRemains(v64.PillarofFrostBuff) < v14:GCD()) and v14:BuffDown(v64.DeathAndDecayBuff)) or (503 >= 1425)) then
					if ((4871 == 4871) and v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\202\223\141\98\82\243\222\150\99\79\199\200\194\126\68\192\196\150\116\84\205\217\139\126\72\140\155", "\38\172\173\226\17");
					end
				end
				v141 = 1;
			end
		end
	end
	local function v122()
		local v142 = 0;
		while true do
			if ((2515 > 2280) and (v142 == 1)) then
				if ((3008 == 3008) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\229\15\82\17\193\58\71\23\196\5\70", "\126\167\110\53")]:IsCastable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\18\18\34\241\200\58\47\17\58\241\211\49", "\95\93\112\78\152\188")]:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and ((v14:BuffUp(v64.UnholyStrengthBuff) and (v14:BuffRemains(v64.UnholyStrengthBuff) < (v14:GCD() * 3))) or (v14:BuffRemains(v64.PillarofFrostBuff) < (v14:GCD() * 3)))) then
					if ((295 < 775) and v29(v64.BagofTricks, v54, nil, not v15:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\195\244\130\42\235\184\237\213\231\140\22\239\173\146\211\244\134\28\229\178\193\129\164\211", "\178\161\149\229\117\132\222");
					end
				end
				break;
			end
			if ((v142 == 0) or (4828 <= 3019)) then
				if ((2317 >= 2150) and v83) then
					local v171 = 0;
					while true do
						if ((v171 == 2) or (3148 == 739)) then
							if ((4576 < 4666) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\63\207\163\225\174\102\12\192\172\199\188\126\18", "\18\126\161\192\132\221")]:IsCastable()) then
								if (v29(v64.AncestralCall, v54) or (3843 == 3030)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\94\38\173\1\69\75\58\175\8\105\92\41\162\8\22\77\41\173\13\87\83\59\238\85\6", "\54\63\72\206\100");
								end
							end
							if ((2522 > 1584) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\238\80\87\127\231\119\199\86\65", "\27\168\57\37\26\133")]:IsCastable()) then
								if ((3245 == 3245) and v29(v64.Fireblood, v54)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\43\163\110\173\213\33\165\115\172\151\63\171\127\161\214\33\185\60\249\133", "\183\77\202\28\200");
								end
							end
							break;
						end
						if ((v171 == 1) or (4458 <= 2954)) then
							if (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\2\198\119\40\223\243\19\193\120\58\212", "\150\67\180\20\73\177")]:IsCastable() or (2080 <= 467)) then
								if ((58 < 618) and v29(v64.ArcanePulse, v54, nil, not v15:IsInRange(8))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\140\10\25\76\131\29\37\93\152\20\9\72\205\10\27\78\132\25\22\94\205\78", "\45\237\120\122");
								end
							end
							if (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\251\225\165\36\195\251\136\57\211\239\175\41\217\252", "\76\183\136\194")]:IsCastable() or (891 > 3655)) then
								if (v29(v64.LightsJudgment, v54, nil, not v15:IsSpellInRange(v64.LightsJudgment)) or (4287 < 3622)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\118\239\226\48\68\92\43\112\243\225\63\93\74\26\110\166\247\57\83\70\21\118\245\165\96", "\116\26\134\133\88\48\47");
								end
							end
							v171 = 2;
						end
						if ((34 <= 2569) and (v171 == 0)) then
							if (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\3\209\181\125\11\7\200\168\107", "\111\65\189\218\18")]:IsCastable() or (2876 == 1323)) then
								if ((2030 == 2030) and v29(v64.BloodFury, v54)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\65\71\20\58\15\99\169\86\89\2\117\25\93\172\74\74\23\38\75\14", "\207\35\43\123\85\107\60");
								end
							end
							if (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\82\175\178\249\124\98\161\169\228\126", "\25\16\202\192\138")]:IsCastable() or (2040 == 682)) then
								if (v29(v64.Berserking, v54) or (269 > 2382)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\255\206\191\241\172\230\246\194\163\229\233\230\252\200\164\227\165\231\189\159", "\148\157\171\205\130\201");
								end
							end
							v171 = 1;
						end
					end
				end
				if ((836 < 4132) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\53\50\142\7\17\7\155\1\20\56\154", "\104\119\83\233")]:IsCastable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\218\250\43\43\87\240\234\38\54\74\250\246", "\35\149\152\71\66")]:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff) and v14:BuffUp(v64.UnholyStrengthBuff)) then
					if ((2989 >= 1063) and v29(v64.BagofTricks, v54, nil, not v15:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\27\233\69\143\53\31\215\86\162\51\26\227\81\240\40\24\235\75\177\54\10\168\19\228", "\90\121\136\34\208");
					end
				end
				v142 = 1;
			end
		end
	end
	local function v123()
		local v143 = 0;
		while true do
			if ((2406 <= 3221) and (v143 == 1)) then
				if ((3567 < 4459) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\154\44\184\116\144\176\60\181\105\129", "\228\213\78\212\29")]:IsReady() and (v14:BuffUp(v64.KillingMachineBuff))) then
					if (v29(v64.Obliterate, nil, nil, not v15:IsInMeleeRange(5)) or (1860 >= 2065)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\136\78\186\12\255\130\94\183\17\238\199\95\191\11\236\139\73\137\17\234\149\75\179\17\171\214\28", "\139\231\44\214\101");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\241\224\17\82\25\191\54\52\213\238\21\74", "\118\185\143\102\62\112\209\81")]:IsReady() and v14:BuffUp(v64.RimeBuff) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\117\115\44\228\183\16\29\51\89\98", "\88\60\16\73\134\197\117\124")]:TalentRank() == 2)) or (2123 >= 4894)) then
					if ((3619 == 3619) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\88\229\239\196\72\94\237\199\202\77\81\249\236\136\82\89\228\255\196\68\111\254\249\218\70\85\254\184\153\19", "\33\48\138\152\168");
					end
				end
				if ((2132 < 3335) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\90\25\34\95\206\49\69\31\62\69\196\37", "\87\18\118\80\49\161")]:IsReady() and (v14:Rune() < 4) and (v14:RunicPowerDeficit() > 25) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\99\28\214\169\164\73\12\219\180\185\67\16", "\208\44\126\186\192")]:IsAvailable() and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\213\8\161\199\0\244\198\72\196\19\170\194\6\253\206\65\228\27", "\46\151\122\196\166\116\156\169")]:IsAvailable()) then
					if (v29(v64.HornofWinter, v60) or (4477 <= 3601)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\226\84\20\196\234\235\121\13\242\235\249\67\8\187\246\228\72\29\247\224\210\82\27\233\226\232\82\90\170\177", "\155\133\141\38\122");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\3\56\163\82\91\76\177\55\35\167\68", "\197\69\74\204\33\47\31")]:IsReady() and not v88 and (v82 or (v14:RunicPowerDeficit() < 25) or ((v15:DebuffStack(v64.RazoriceDebuff) == 5) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\195\71\91\147\228\74\72\142\254\72\120\139\241\75\95", "\231\144\47\58")]:IsAvailable()))) or (3478 == 589)) then
					if ((1732 >= 130) and v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\202\213\102\12\2\220\45\160\209\209\112\88\46\198\55\181\212\223\74\12\60\221\62\183\204\154\36\78", "\89\210\184\186\21\120\93\175");
					end
				end
				v143 = 2;
			end
			if ((v143 == 0) or (867 > 3215)) then
				if ((665 <= 4541) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\186\222\208\163\179\5\163\47\141\200\206\155\168\24\178\38\154", "\67\232\187\189\204\193\118\198")]:IsReady() and (v72 or v80)) then
					if ((1089 <= 3455) and v29(v64.RemorselessWinter, nil, nil, not v15:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\153\43\184\47\41\17\234\135\43\166\51\4\21\230\133\58\176\50\123\17\230\133\41\185\37\4\22\238\153\41\176\52\123\80", "\143\235\78\213\64\91\98");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\171\90\139\250\100\133\153\90\141\226\117", "\214\237\40\228\137\16")]:IsReady() and (v14:BuffStack(v64.KillingMachineBuff) < 2) and (v14:RunicPowerDeficit() < 20) and not v106) or (3522 < 2146)) then
					if (v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(5)) or (3491 <= 3258)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\131\241\224\202\23\153\150\247\253\208\8\163\197\240\230\215\4\170\128\220\251\216\17\161\128\247\175\141", "\198\229\131\143\185\99");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\121\131\191\127\88\130\175\81\93\141\187\103", "\19\49\236\200")]:IsReady() and v14:BuffUp(v64.RimeBuff) and v14:HasTier(30, 2) and (v14:BuffStack(v64.KillingMachineBuff) < 2)) or (4449 < 3644)) then
					if (v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast)) or (153 >= 1887)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\56\225\187\237\180\249\8\244\187\229\169\234\119\229\190\234\189\242\50\201\163\229\168\249\50\226\247\178", "\218\158\87\150\215\132");
					end
				end
				if ((1765 > 640) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\221\12\214\241\34\49\206\226\10\209\231", "\173\155\126\185\130\86\66")]:IsReady() and v14:BuffUp(v64.KillingMachineBuff) and v84) then
					if ((200 < 4059) and v29(v64.Frostscythe, nil, nil, not v15:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\180\181\212\156\255\230\191\174\207\141\172\246\175\180\192\132\233\218\178\187\213\143\233\241\230\226", "\140\133\198\218\167\232");
					end
				end
				v143 = 1;
			end
			if ((3 == v143) or (3210 <= 1400)) then
				if ((1380 < 3863) and v28 and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\60\187\137\170\45\124\41\166\152\185\38\119\9", "\25\125\201\234\203\67")]:IsReady() and (v14:RunicPowerDeficit() > 20)) then
					if ((183 <= 3341) and v29(v64.ArcaneTorrent, v54)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\120\230\27\2\26\34\44\109\251\10\17\17\41\7\57\231\17\13\19\43\22\70\224\25\17\19\34\7\57\166\78", "\115\25\148\120\99\116\71");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\42\47\182\55\85\63\41\171\45\74\9", "\33\108\93\217\68")]:IsReady() and not v88) or (426 > 3276)) then
					if (v29(v64.FrostStrike, v58, nil, not v15:IsInMeleeRange(5)) or (3592 == 4092)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\221\89\174\190\207\116\178\185\201\66\170\168\155\88\168\163\220\71\164\146\207\74\179\170\222\95\225\255\131", "\205\187\43\193");
					end
				end
				break;
			end
			if ((3380 == 3380) and (v143 == 2)) then
				if ((4841 >= 4597) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\153\92\107\217\112\52\182\113\112\212\106\46", "\90\209\51\28\181\25")]:IsReady() and v81) then
					if ((3962 == 3962) and v29(v64.HowlingBlast, nil, nil, not v15:IsSpellInRange(v64.HowlingBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\116\64\226\182\222\124\104\236\179\209\104\67\174\172\217\117\80\226\186\239\111\86\252\184\213\111\23\191\231", "\223\176\27\55\142");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\3\183\207\182\45\186\194\148\32\173\207\187\39\190", "\213\68\219\174")]:IsReady() and not v88 and not v70 and ((v15:DebuffStack(v64.RazoriceDebuff) < 5) or (v15:DebuffRemains(v64.RazoriceDebuff) < (v14:GCD() * 3)))) or (3057 <= 2101)) then
					if (v29(v64.GlacialAdvance, nil, nil, not v15:IsInRange(100)) or (3977 >= 4688)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\12\236\34\228\35\196\51\64\10\228\53\230\36\198\58\63\24\233\45\224\38\192\0\107\10\242\36\226\62\133\109\47", "\31\107\128\67\135\74\165\95");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\247\234\240\68\85\180\202\233\232\72", "\209\184\136\156\45\33")]:IsReady() and not v87) or (774 < 455)) then
					if (v29(v64.Obliterate, nil, nil, not v15:IsInMeleeRange(5)) or (832 == 2347)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\202\121\1\172\2\218\116\28\189\71\219\124\6\191\11\205\74\28\185\21\207\112\28\248\85\154", "\216\103\168\21\104");
					end
				end
				if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\80\162\81\170\119\171\116\173\118\185\70\182", "\196\24\205\35")]:IsReady() and (v14:Rune() < 4) and (v14:RunicPowerDeficit() > 25) and (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\12\153\230\7\58\131\236\0\29\130\237\2\60\138\228\9\61\138", "\102\78\235\131")]:IsAvailable() or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\216\60\49\69\83\49\184\50\201\39\58\64\85\56\176\59\233\47", "\84\154\78\84\36\39\89\215")]:CooldownRemains() > 45))) or (1934 == 2777)) then
					if (v29(v64.HornofWinter, v60) or (604 == 4669)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\238\68\86\58\242\231\105\79\12\243\245\83\74\69\238\232\88\95\9\248\222\66\89\23\250\228\66\24\87\169", "\101\157\129\54\56");
					end
				end
				v143 = 3;
			end
		end
	end
	local function v124()
		local v144 = 0;
		local v145;
		while true do
			if ((v144 == 0) or (2088 > 2395)) then
				v145 = v14:GCD() + 0.25;
				v79 = (v94 == 1) or not v27;
				v80 = (v94 >= 2) and v27;
				v144 = 1;
			end
			if ((1992 <= 2618) and (2 == v144)) then
				v84 = v64[LUAOBFUSACTOR_DECRYPT_STR_0("\214\30\125\101\81\192\243\21\102\126\64", "\179\144\108\18\22\37")]:IsAvailable() and (v14:BuffUp(v64.KillingMachineBuff) or (v94 >= 3)) and ((not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\239\174\11\155\192\208\166\31\166\205\202\170\15\140\221\199\183\30", "\175\166\195\123\233")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\201\208\84\78\249\235\231\69\76\243\250\214\84\70\254\234\208", "\144\143\162\61\41")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\198\193\18\67\102\149\54\225\195\24\66", "\83\128\179\125\48\18\231")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\112\190\244\213\83\17\91\163\251\216\97\12\82\173\246\211\112\31\78\163\246\206", "\126\61\215\147\189\39")]:IsAvailable()) or not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\91\243\24\68\110\246\19\66\75\235\15\76\115\250\14", "\37\24\159\125")]:IsAvailable() or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\249\170\112\67\204\175\123\69\233\178\103\75\209\163\102", "\34\186\198\21")]:IsAvailable() and ((v94 > 6) or (v14:BuffDown(v64.DeathAndDecayBuff) and (v94 > 3)))));
				if (((v14:RunicPower() < 35) and (v14:Rune() < 2) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\200\1\201\81\195\234\7\195\123\208\247\27\209", "\162\152\104\165\61")]:CooldownRemains() < 10)) or (3318 == 418)) then
					v85 = (((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\253\38\190\113\113\247\194\41\148\111\127\246\217", "\133\173\79\210\29\16")]:CooldownRemains() + 1) / v145) / ((v14:Rune() + 3) * (v14:RunicPower() + 5))) * 100;
				else
					v85 = 3;
				end
				if (((v14:RunicPowerDeficit() > 10) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\175\110\232\42\153\116\226\45\190\117\227\47\159\125\234\36\158\125", "\75\237\28\141")]:CooldownRemains() < 10)) or (4067 <= 2537)) then
					v86 = (((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\254\77\201\176\59\19\232\231\239\86\194\181\61\26\224\238\207\94", "\129\188\63\172\209\79\123\135")]:CooldownRemains() + 1) / v145) / ((v14:Rune() + 1) * (v14:RunicPower() + 20))) * 100;
				else
					v86 = 3;
				end
				v144 = 3;
			end
			if ((v144 == 1) or (4169 <= 4060)) then
				v81 = v14:BuffUp(v64.RimeBuff) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\204\115\2\218\241\116\17\215\251\84\23\208\228\119\11\252\246\115\8\207\247\125\11", "\191\158\18\101")]:IsAvailable() or v64[LUAOBFUSACTOR_DECRYPT_STR_0("\228\213\134\187\174\203\192\143\178", "\207\165\163\231\215")]:IsAvailable() or v64[LUAOBFUSACTOR_DECRYPT_STR_0("\239\250\252\84\54\117\199\242\252\68", "\16\166\153\153\54\68")]:IsAvailable());
				v82 = (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\231\189\204\67\53\50\241\215\183\230\84\49\47\227\203", "\153\178\211\160\38\84\65")]:IsAvailable() and ((v14:BuffRemains(v64.UnleashedFrenzyBuff) < (v145 * 3)) or (v14:BuffStack(v64.UnleashedFrenzyBuff) < 3))) or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\171\8\67\31\131\7\85\37\145", "\75\226\107\58")]:IsAvailable() and ((v14:BuffRemains(v64.IcyTalonsBuff) < (v145 * 3)) or (v14:BuffStack(v64.IcyTalonsBuff) < 3)));
				v83 = (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\104\215\29\118\16\208\194\94\248\3\117\2\214", "\173\56\190\113\26\113\162")]:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\228\220\33\12\227\206\204\44\17\254\196\208", "\151\171\190\77\101")]:IsAvailable() and (v14:BuffRemains(v64.PillarofFrostBuff) < 6)) or not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\234\45\244\160\236\120\25\196\59\241\166\246", "\107\165\79\152\201\152\29")]:IsAvailable())) or (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\103\71\228\199\85\109\88\72\206\217\91\108\67", "\31\55\46\136\171\52")]:IsAvailable() and v14:BuffUp(v64.EmpowerRuneWeaponBuff)) or (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\225\33\208\248\208\58\211\242\247\58\211\231\197", "\148\177\72\188")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\131\187\71\220\177\179\69\225\179\184\82\228\163\183\71\220\168", "\179\198\214\55")]:IsAvailable()) or ((v93 >= 2) and v14:BuffUp(v64.PillarofFrostBuff));
				v144 = 2;
			end
			if ((v144 == 3) or (86 >= 606)) then
				v87 = (v14:Rune() < 4) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\111\230\234\196\84\225\244\204\84\237\233\195", "\173\32\132\134")]:IsAvailable() and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\126\18\4\227\175\35\194\72\61\26\224\189\37", "\173\46\123\104\143\206\81")]:CooldownRemains() < v85);
				v88 = (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\150\15\39\139\81\139\14\178\46\43\132\65\145\0\179\18\49\139", "\97\212\125\66\234\37\227")]:IsAvailable() and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\168\241\179\52\10\130\236\176\6\23\132\231\164\52\25\133\240\183", "\126\234\131\214\85")]:CooldownRemains() < v86)) or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\171\215\69\83\91\129\199\72\78\70\139\219", "\47\228\181\41\58")]:IsAvailable() and (v14:RunicPower() < 35) and (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\150\245\213\55\2\34\16\160\218\203\52\16\36", "\127\198\156\185\91\99\80")]:CooldownRemains() < v85));
				break;
			end
		end
	end
	local function v125()
		local v146 = 0;
		while true do
			if ((v146 == 1) or (153 >= 2453)) then
				v27 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\68\241\5\17\72\117\237", "\36\16\158\98\118")][LUAOBFUSACTOR_DECRYPT_STR_0("\193\25\198", "\133\160\118\163\155\56\136\71")];
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\173\118\245\186\26\166", "\213\150\194\17\146\214\127")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\173\183", "\86\123\201\196\180\38\196\194")];
				v146 = 2;
			end
			if ((v146 == 0) or (2676 >= 4227)) then
				v63();
				v26 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\193\21\203\247\171\14\42", "\190\149\122\172\144\199\107\89")][LUAOBFUSACTOR_DECRYPT_STR_0("\61\10\242", "\158\82\101\145\158")];
				v146 = 1;
			end
			if ((v146 == 2) or (283 >= 2823)) then
				v69 = not v110();
				if ((4242 > 366) and v27) then
					local v172 = 0;
					while true do
						if ((4712 == 4712) and (v172 == 0)) then
							v92 = v14:GetEnemiesInMeleeRange(8);
							v97 = v14:GetEnemiesInMeleeRange(10);
							v172 = 1;
						end
						if ((3335 >= 2992) and (v172 == 1)) then
							v94 = #v97;
							v93 = #v92;
							break;
						end
					end
				else
					local v173 = 0;
					while true do
						if ((1482 >= 1460) and (v173 == 0)) then
							v92 = {};
							v97 = {};
							v173 = 1;
						end
						if ((v173 == 1) or (171 >= 4691)) then
							v94 = 1;
							v93 = 1;
							break;
						end
					end
				end
				v146 = 3;
			end
			if ((v146 == 3) or (2173 > 4840)) then
				if (v68.TargetIsValid() or v14:AffectingCombat() or (3884 < 1346)) then
					local v174 = 0;
					while true do
						if ((3360 == 3360) and (v174 == 0)) then
							v89 = v10.BossFightRemains();
							v90 = v89;
							v174 = 1;
						end
						if ((1082 <= 2816) and (v174 == 1)) then
							if ((v90 == 11111) or (3830 >= 4328)) then
								v90 = v10.FightRemains(v97, false);
							end
							break;
						end
					end
				end
				if (v68.TargetIsValid() or (1099 >= 4754)) then
					local v175 = 0;
					local v176;
					while true do
						if ((4871 <= 4892) and (v175 == 0)) then
							if (not v14:AffectingCombat() or (2393 <= 1632)) then
								local v177 = 0;
								local v178;
								while true do
									if ((2414 == 2414) and (0 == v177)) then
										v178 = v113();
										if ((1584 == 1584) and v178) then
											return v178;
										end
										break;
									end
								end
							end
							if ((2285 > 2073) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\211\237\216\187\255\219\205\189\254\227\220", "\207\151\136\185")]:IsReady() and not v69) then
								if (v29(v64.DeathStrike, nil, nil, not v15:IsInMeleeRange(5)) or (2894 < 2799)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\172\134\41\150\124\71\98\188\145\33\137\113\56\125\167\148\104\138\100\56\126\186\195\56\144\123\123", "\17\200\227\72\226\20\24");
								end
							end
							v124();
							v176 = v120();
							v175 = 1;
						end
						if ((v175 == 2) or (1275 > 3605)) then
							if ((240 < 1190) and v14:BuffUp(v64.BreathofSindragosa) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\45\168\138\219\60\222\16\171\146\219\39\213", "\187\98\202\230\178\72")]:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff)) then
								local v179 = 0;
								local v180;
								while true do
									if ((v179 == 1) or (635 > 2257)) then
										if ((1961 > 534) and v29(v64.Pool)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\49\238\171\60\10\39\238\182\112\104\51\228\165\36\66\14\227\168\57\94\105\168", "\42\65\129\196\80");
										end
										break;
									end
									if ((196 <= 3023) and (v179 == 0)) then
										v180 = v117();
										if ((2048 <= 3047) and v180) then
											return v180;
										end
										v179 = 1;
									end
								end
							end
							if ((v14:BuffUp(v64.BreathofSindragosa) and (not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\45\72\81\211\3\2\16\239\22\67\82\212", "\142\98\42\61\186\119\103\98")]:IsAvailable() or (v64[LUAOBFUSACTOR_DECRYPT_STR_0("\23\189\14\1\44\186\16\9\44\182\13\6", "\104\88\223\98")]:IsAvailable() and v14:BuffDown(v64.PillarofFrostBuff)))) or (411 >= 2970)) then
								local v181 = 0;
								local v182;
								while true do
									if ((1312 <= 2793) and (v181 == 0)) then
										v182 = v116();
										if (v182 or (2164 >= 3404)) then
											return v182;
										end
										v181 = 1;
									end
									if ((1080 <= 2918) and (v181 == 1)) then
										if (v29(v64.Pool) or (3426 <= 1781)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\84\248\237\194\66\235\75\229\162\236\16\232\69\227\234\134\75", "\141\36\151\130\174\98");
										end
										break;
									end
								end
							end
							if ((v64[LUAOBFUSACTOR_DECRYPT_STR_0("\171\120\206\4\144\127\208\12\144\115\205\3", "\109\228\26\162")]:IsAvailable() and v14:BuffUp(v64.PillarofFrostBuff) and v14:BuffDown(v64.BreathofSindragosa)) or (4376 <= 4070)) then
								local v183 = 0;
								local v184;
								while true do
									if ((v183 == 0) or (805 > 4162)) then
										v184 = v121();
										if ((4904 == 4904) and v184) then
											return v184;
										end
										v183 = 1;
									end
									if ((1 == v183) or (2525 > 4643)) then
										if (v29(v64.Pool) or (3983 < 1150)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\78\234\242\116\160\224\81\247\189\87\226\234\87\241\248\106\225\242\87\234\243\48\169", "\134\62\133\157\24\128");
										end
										break;
									end
								end
							end
							if ((4066 < 4247) and (v94 >= 2) and v27) then
								local v185 = 0;
								local v186;
								while true do
									if ((v185 == 0) or (1446 < 545)) then
										v186 = v115();
										if (v186 or (616 == 199)) then
											return v186;
										end
										break;
									end
								end
							end
							v175 = 3;
						end
						if ((v175 == 3) or (4384 <= 2280)) then
							if ((4564 > 598) and ((v94 == 1) or not v27)) then
								local v187 = 0;
								local v188;
								while true do
									if ((3747 == 3747) and (0 == v187)) then
										v188 = v123();
										if ((3889 < 4766) and v188) then
											return v188;
										end
										break;
									end
								end
							end
							if ((2628 > 2464) and v10.CastAnnotated(v64.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\48\132\51\237", "\182\103\197\122\185\79\209"))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((1 == v175) or (3197 <= 2999)) then
							if (v176 or (952 <= 71)) then
								return v176;
							end
							if ((2347 >= 423) and v28) then
								local v189 = 0;
								local v190;
								while true do
									if ((4997 >= 4775) and (v189 == 0)) then
										v190 = v119();
										if ((3333 < 3636) and v190) then
											return v190;
										end
										break;
									end
								end
							end
							if ((3706 >= 2393) and v28) then
								local v191 = 0;
								local v192;
								while true do
									if ((1756 < 3743) and (v191 == 1)) then
										v192 = v114();
										if ((2598 <= 3220) and v192) then
											return v192;
										end
										break;
									end
									if ((v191 == 0) or (4962 <= 3676)) then
										v192 = v122();
										if (v192 or (3467 < 3261)) then
											return v192;
										end
										v191 = 1;
									end
								end
							end
							if ((1461 <= 2309) and v64[LUAOBFUSACTOR_DECRYPT_STR_0("\147\78\23\211\225\244\238\237\164", "\159\208\33\123\183\169\145\143")]:IsAvailable() and (v14:BuffDown(v64.KillingMachineBuff) or v64[LUAOBFUSACTOR_DECRYPT_STR_0("\208\72\61\55\230\82\55\48\193\83\54\50\224\91\63\57\225\91", "\86\146\58\88")]:IsAvailable()) and ((v15:DebuffStack(v64.RazoriceDebuff) == 5) or (not v70 and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\127\211\235\195\167\232\58\219\92\201\235\206\173\236", "\154\56\191\138\160\206\137\86")]:IsAvailable() and not v64[LUAOBFUSACTOR_DECRYPT_STR_0("\167\79\244\139\125\52\130\196\131", "\172\230\57\149\231\28\90\225")]:IsAvailable()) or (v90 <= (v14:GCD() + 0.5)))) then
								local v193 = 0;
								local v194;
								while true do
									if ((v193 == 0) or (4669 < 511)) then
										v194 = v118();
										if (v194 or (4222 <= 1868)) then
											return v194;
										end
										break;
									end
								end
							end
							v175 = 2;
						end
					end
				end
				break;
			end
		end
	end
	local function v126()
		local v147 = 0;
		while true do
			if ((3090 >= 102) and (0 == v147)) then
				v63();
				v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\213\149\238\100\20\8\215\172\161\101\15\92\242\147\232\120\14\8\241\158\161\82\16\65\240\201\161\64\15\90\248\199\232\121\64\88\225\136\230\101\5\91\224\199\198\120\10\65\225\134", "\40\147\231\129\23\96"));
				break;
			end
		end
	end
	v10.SetAPL(251, v125, v126);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\80\232\133\93\132\136\217\116\236\132\110\181\165\219\125\236\179\99\169\163\207\97\220\167\11\183\185\221", "\188\21\152\236\37\219\204")]();

