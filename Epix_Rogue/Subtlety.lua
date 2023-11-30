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
		if ((v5 == 1) or (2733 >= 4300)) then
			return v6(...);
		end
		if ((4829 == 4829) and (v5 == 0)) then
			v6 = v0[v4];
			if ((1683 <= 4726) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\137\200\25\196\198\228\22\243\185\211\18\212\215\194\107\234\174\198", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\159\37\2\49\118\177", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\210\53\233\83", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\209\88\178\85\249\120\177\67\238", "\38\156\55\199")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\155\109\121\36\31", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\52\170\221\203\132\31\36\28\179\221", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\124\86\9\41\90", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\137\215\222\6\17", "\75\220\163\183\106\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\32\181\132\59\237\13\147\133\35", "\185\98\218\235\87")];
	local v22 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\234\51\2\201\240", "\202\171\92\71\134\190")];
	local v23 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\10\229\63\167\7", "\232\73\161\76")];
	local v24 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\153\208\76\89", "\126\219\185\34\61")];
	local v25 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\33\207\93\96\113", "\135\108\174\62\18\30\23\147")];
	local v26 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\134\251\47\216\11", "\167\214\137\74\171\120\206\83")];
	local v27 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\168\255\63\80\247\169\152", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\0\188\57\30\25\183\46", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\201\65\125", "\126\167\52\16\116\217")];
	local v28 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\235\33\45\141\187\23\239", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\248\160\220\30\225\171\203", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\84\39\80\52", "\152\54\72\63\88\69\62")];
	local v29 = pairs;
	local v30 = table[LUAOBFUSACTOR_DECRYPT_STR_0("\221\202\253\89\198\208", "\60\180\164\142")];
	local v31 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\85\87\11", "\114\56\62\101\73\71\141")];
	local v32 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\181\232\195", "\164\216\137\187")];
	local v33 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\211\228\34", "\107\178\134\81\210\198\158")];
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
	local function v83()
		local v132 = 0;
		while true do
			if ((4835 >= 3669) and (v132 == 7)) then
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\21\35\110\71\30\48\105", "\26\46\112\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\58\166\118\176\179\86\187\191\7\174\117\171\183\106\178\191\4\136\80", "\212\217\67\203\20\223\223\37")];
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\136\188\198\179\131\175\193", "\178\218\237\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\189\231\212\185\162\196\220\183\177\227\195\153\179\224\247\149\145", "\176\214\213\134")];
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\199\168\162\192\161\88\94\231", "\57\148\205\214\180\200\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\36\252\59\61\101\26\206\33\49\119\30\233\61\25\119\17\239\58", "\22\114\157\85\84")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\206\7\208\84\248\175\215", "\200\164\171\115\164\61\150")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\252\2\65\140\169\249\6\73\135\141\224\6\68\143\170\252\46\68\128\172\251", "\227\222\148\99\37")];
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\0\87\70\226\240\61\85\65", "\153\83\50\50\150")][LUAOBFUSACTOR_DECRYPT_STR_0("\110\126\114\24\124\188\105\92\120\112\25\64\191\72\92\122\103\20\94\170\78\79\121", "\45\61\22\19\124\19\203")];
				break;
			end
			if ((2851 > 1859) and (v132 == 1)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\107\188\168\54\172\116\173\136\32\185\119\183\133", "\83\205\24\217\224")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\150\247\192\206\46\198\161\106\177\252\196\234\10", "\30\222\146\161\162\90\174\210")] or 0;
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\113\46\103\249\72\82\77\48\103\203\83\84\80\19\103\233\84", "\32\56\64\19\156\58")] or 0;
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\112\88\95\248\103\148\146\27\77\121\69\241\108\177\143\2\77\83\71\244\102\146", "\107\57\54\43\157\21\230\231")] or 0;
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\142\5\225\176\210\200\200", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\21\161\149\73\241\107\109\44\187\181\68\241\124\107\52\160\141\72", "\24\92\207\225\44\131\25")] or 0;
				v132 = 2;
			end
			if ((3848 > 2323) and (0 == v132)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\28\135\197\203\192\6\131\251\217", "\170\163\111\226\151")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\63\200\38\245\136\34\198\23\243\146", "\135\225\76\173\114")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\206\21\216\125\247\161\212\30\247\72\249\185\212\31\254", "\150\205\189\112\144\24")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\252\26\6\223\191\114\129\228\16\19\218\185\114\168\213\18\2", "\230\180\127\103\179\214\28")] or 0;
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\172\16\72\191\229\200\156\166\5\77\185\229\231\156", "\175\204\201\113\36\214\139")] or 0;
				v132 = 1;
			end
			if ((2836 > 469) and (v132 == 5)) then
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\199\116\225\185\44\35\128\231", "\231\148\17\149\205\69\77")][LUAOBFUSACTOR_DECRYPT_STR_0("\179\179\194\250\91\235\136\136\232\216", "\159\224\199\167\155\55")];
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\196\246\40\198\254\253\59\193", "\178\151\147\92")][LUAOBFUSACTOR_DECRYPT_STR_0("\175\239\69\63\1\67\116\186\244\77\62\53\111\94", "\26\236\157\44\82\114\44")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\43\193\79\35\32\210\72", "\59\74\78\181")][LUAOBFUSACTOR_DECRYPT_STR_0("\3\212\83\84\167\2\242\126", "\211\69\177\58\58")];
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\132\224\109\225\224\197\176\246", "\171\215\133\25\149\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\193\49\241\192\54\250\101\194\236", "\34\129\168\82\154\143\80\156")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\182\183\39\31\65\64\142\150", "\233\229\210\83\107\40\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\86\55\215\9\213\74\29\208\3\230\97\22", "\101\161\34\82\182")];
				v132 = 6;
			end
			if ((3 == v132) or (2096 <= 540)) then
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\236\26\224\8\51\209\24\231", "\90\191\127\148\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\83\142\42\25\125\158\29\31\119\147\7\25\108\130\60\5\109\151\58", "\119\24\231\78")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\40\177\94\213\78\22\145", "\113\226\77\197\42\188\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\8\23\247\188\59\26\231\146\25\50", "\213\90\118\148")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\43\160\66\68\85\41\167", "\45\59\78\212\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\87\128\130\135\34\190\223\22\80\164\168\162", "\144\112\54\227\235\230\78\205")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\45\27\232\217\85\180\59", "\59\211\72\111\156\176")][LUAOBFUSACTOR_DECRYPT_STR_0("\120\134\237\36\93\143\204\43\72\160\192\9", "\77\46\231\131")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\81\162\84\179\90\177\83", "\32\218\52\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\31\48\172\254\167\97\91\64\20\52\135\247\182\98\121\106", "\58\46\119\81\200\145\208\37")];
				v132 = 4;
			end
			if ((v132 == 2) or (3183 < 2645)) then
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\214\172\88\18\115\76\192", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\214\41\95\178\215\18\73\187\203\37\95\181", "\44\221\185\64")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\226\92\75\122\15\224\91", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\83\58\40\32\63\156\89\53\41\42\34\166\127\60\54\45\48\186", "\81\206\60\83\91\79")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\174\196\102\38\205\74\183", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\35\112\25\33\255\194\173\46\106\23\0\244\219", "\143\216\66\30\126\68\155")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\205\25\223\204\173\208\242", "\129\202\168\109\171\165\195\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\75\50\232\204\29\233\48\81\35\193\236\27\242\35\76\62\215\208", "\134\66\56\87\184\190\116")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\52\29\175\16\229\38\38", "\85\92\81\105\219\121\139\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\206\135\125\67\88\254\238\151\96\118\95\251", "\191\157\211\48\37\28")];
				v132 = 3;
			end
			if ((3230 <= 3760) and (v132 == 4)) then
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\24\137\36\184\160\179\49\56", "\86\75\236\80\204\201\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\70\73\126\150\234\135\119\117\114\132\209\141\116\102\84\161", "\235\18\33\23\229\158")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\191\213\175\89\180\198\168", "\219\48\218\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\126\112\77\249\67\239\235\117\83\79\221\104\195\192", "\128\132\17\28\41\187\47")];
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\55\18\46\84\15\53\21", "\61\97\82\102\90")][LUAOBFUSACTOR_DECRYPT_STR_0("\129\47\185\64\194\83\24\6\190\10\174\74\211\95\49\15\170\9\136\111", "\105\204\78\203\43\167\55\126")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\175\55\10\26\10\192\66", "\49\197\202\67\126\115\100\167")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\73\214\36\147\89\80\1\82\222\37\168\102", "\62\87\59\191\73\224\54")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\7\238\221\238\12\253\218", "\169\135\98\154")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\114\45\90\233\27\248", "\168\171\23\68\52\157\83")];
				v132 = 5;
			end
			if ((3828 == 3828) and (v132 == 6)) then
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\8\77\234\210\236\133\61", "\78\136\109\57\158\187\130\226")][LUAOBFUSACTOR_DECRYPT_STR_0("\27\41\240\226\61\58\235\240\42\58\221\220\25\16\255\247\45\58\237", "\145\94\95\153")] or true;
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\200\0\193\71\185\250\222", "\215\157\173\116\181\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\6\188\175\215\217\58\151\131\243\200\50\177", "\186\85\212\235\146")];
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\241\132\2\234\48\224\95\209", "\56\162\225\118\158\89\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\16\210\161\17\208\93\1\207\184\6\217\82\6\197", "\184\60\101\160\207\66")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\2\135\104\168\56\140\123\175", "\220\81\226\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\35\218\150\242\229\201\39\204\146\254\217\194\31\208\129\239\239\195\32\192\128\239\230\194\7\204", "\167\115\181\226\155\138")];
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\209\39\243\72\114\127\193\241", "\166\130\66\135\60\27\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\119\66\219\103\57\79\79\192\65\63\86\68\207\113\63\99\105\234", "\80\36\42\174\21")];
				v132 = 7;
			end
		end
	end
	local v84 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\226\29\0\248\13\126\170", "\217\161\114\109\149\98\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\55\54\61\110\165\123\28\37", "\20\114\64\88\28\220")];
	local v85 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\18\14\223\185\247\222\174", "\221\81\97\178\212\152\176")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\232\26\238\31", "\122\173\135\125\155")];
	local v86 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\182\206\7\172\58", "\168\228\161\96\217\95\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\232\196\44\72\35\82\207\200", "\55\187\177\78\60\79")];
	local v87 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\31\193\88\254\67", "\224\77\174\63\139\38\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\183\84\90\58\136\68\76\55", "\78\228\33\56")];
	local v88 = v25[LUAOBFUSACTOR_DECRYPT_STR_0("\252\113\181\22\128", "\229\174\30\210\99")][LUAOBFUSACTOR_DECRYPT_STR_0("\40\248\132\69\225\56\45\2", "\89\123\141\230\49\141\93")];
	local v89 = {};
	local v90, v91, v92, v93;
	local v94, v95, v96, v97, v98;
	local v99;
	local v100, v101, v102;
	local v103, v104;
	local v105, v106, v107, v108;
	local v109;
	v86[LUAOBFUSACTOR_DECRYPT_STR_0("\214\103\255\31\19\79\225\112\226\9", "\42\147\17\150\108\112")]:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * v105 * 0.176 * 1.21 * ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\33\175\42\119\243\251\27\167\33\116\226\250", "\136\111\198\77\31\135")]:IsAvailable() and v13:StealthUp(true, false) and 1.08) or 1) * ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\38\12\162\70\184\246\36\189\16\8\179\87\186\225\26", "\201\98\105\199\54\221\132\119")]:IsAvailable() and 1.05) or 1) * ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\157\13\145\42\49\61\173\189\3\148", "\204\217\108\227\65\98\85")]:IsAvailable() and v13:BuffUp(v86.ShadowDanceBuff) and 1.3) or 1) * ((v13:BuffUp(v86.SymbolsofDeath) and 1.1) or 1) * ((v13:BuffUp(v86.FinalityEviscerateBuff) and 1.3) or 1) * (1 + (v13:MasteryPct() / 100)) * (1 + (v13:VersatilityDmgPct() / 100)) * ((v14:DebuffUp(v86.FindWeaknessDebuff) and 1.5) or 1);
	end);
	v86[LUAOBFUSACTOR_DECRYPT_STR_0("\108\214\229\241\57\210\91", "\160\62\163\149\133\76")]:RegisterPMultiplier(function()
		return (v13:BuffUp(v86.FinalityRuptureBuff) and 1.3) or 1;
	end);
	local function v110(v133)
		if ((554 == 554) and not v102) then
			v102 = v133;
		end
	end
	local function v111()
		if (((v74 == LUAOBFUSACTOR_DECRYPT_STR_0("\249\174\77\13\204\197\179\8\60\131\216\175\25\111\202\216\224\41\58\205\209\165\2\33\208", "\163\182\192\109\79")) and v13:IsInDungeonArea()) or (2563 == 172)) then
			return false;
		elseif ((3889 >= 131) and (v74 ~= LUAOBFUSACTOR_DECRYPT_STR_0("\21\42\23\193\236\39", "\149\84\70\96\160")) and not v14:IsInBossList()) then
			return false;
		else
			return true;
		end
	end
	local function v112()
		local v134 = 0;
		while true do
			if ((v134 == 0) or (492 == 4578)) then
				if ((v96 < 2) or (4112 < 1816)) then
					return false;
				elseif ((4525 >= 1223) and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\25\10\26\236\33\21", "\141\88\102\109"))) then
					return true;
				elseif ((1090 <= 4827) and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\156\93\138\82\21\46\70\196\160", "\161\211\51\170\16\122\93\53")) and v14:IsInBossList()) then
					return true;
				elseif ((v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\218\187\166\39", "\72\155\206\210")) or (239 > 1345)) then
					if (((v13:InstanceDifficulty() == 16) and (v14:NPCID() == 138967)) or (3710 >= 3738)) then
						return true;
					elseif ((v14:NPCID() == 166969) or (v14:NPCID() == 166971) or (v14:NPCID() == 166970) or (3838 < 2061)) then
						return true;
					elseif ((v14:NPCID() == 183463) or (v14:NPCID() == 183671) or (690 > 1172)) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v113(v135, v136, v137, v138, v139)
		local v140 = 0;
		local v141;
		local v142;
		local v143;
		while true do
			if ((1 == v140) or (1592 > 2599)) then
				for v220, v221 in v29(v138) do
					if ((3574 <= 4397) and (v221:GUID() ~= v143) and v84.UnitIsCycleValid(v221, v142, -v221:DebuffRemains(v135)) and v136(v221)) then
						v141, v142 = v221, v221:TimeToDie();
					end
				end
				if ((3135 > 1330) and v141 and v14 and v14:Exists() and (v141:GUID() == v14:GUID())) then
					if (v26(v135) or (3900 <= 3641)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\66\117\64\78\32\86\127\88\2\115\82\123\70\9\54\82", "\83\38\26\52\110");
					end
				elseif ((1724 == 1724) and v141 and v16 and v16:Exists() and (v141:GUID() == v16:GUID())) then
					if ((455 <= 1282) and v26(v139)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\24\51\6\75\7\34\74\84\87\42\73\77\4\34\73\78\18\53", "\38\56\119\71");
					end
				end
				break;
			end
			if ((4606 < 4876) and (v140 == 0)) then
				v141, v142 = nil, v137;
				v143 = v14:GUID();
				v140 = 1;
			end
		end
	end
	local function v114()
		return 25 + (v27(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\197\230\95\217\55", "\54\147\143\56\182\69")]:IsAvailable()) * 20) + (v27(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\251\128\236\93\218\196\142\249\122\215\215\133\240\94\204", "\191\182\225\159\41")]:IsAvailable()) * 20) + (v27(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\24\26\41\81\132\144\228\36\17\61\70", "\162\75\114\72\53\235\231")]:IsAvailable()) * 25) + (v27(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\173\48\69\225\65\11\152\37", "\98\236\92\36\130\51")]:IsAvailable()) * 20) + (v27(v96 >= 4) * 25);
	end
	local function v115()
		return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\151\17\13\190\74\191\145\49\170\26\9", "\80\196\121\108\218\37\200\213")]:ChargesFractional() >= (0.75 + v21(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\51\123\3\123\68\25\174\1\125\1\122\127\15\134\5\125\22", "\234\96\19\98\31\43\110")]:IsAvailable()));
	end
	local function v116()
		if ((v96 == (4 - v27(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\53\26\83\203\138\115\159\3", "\235\102\127\50\167\204\18")]:IsAvailable()))) or (1442 > 2640)) then
			return true;
		elseif ((136 < 3668) and ((v96 > (4 - (2 * v21(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\99\169\224\49\77\37\85\175\193\44\86\32\81\165\250", "\78\48\193\149\67\36")]:IsAvailable())))) or (v109 and (v96 >= 4)))) then
			return v107 <= 1;
		else
			return v106 <= 1;
		end
	end
	local function v117()
		return v13:BuffUp(v86.SliceandDice) or (v96 >= v85.CPMaxSpend());
	end
	local function v118(v144)
		return (v13:BuffUp(v86.ThistleTea) and (v96 == 1)) or (v144 and ((v96 == 1) or (v14:DebuffUp(v86.Rupture) and (v96 >= 2))));
	end
	local function v119()
		return (not v13:BuffUp(v86.Premeditation) and (v96 == 1)) or not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\4\22\133\42\78\36\10\133\22", "\33\80\126\224\120")]:IsAvailable() or (v96 > 1);
	end
	local function v120()
		return v13:BuffDown(v86.PremeditationBuff) or (v96 > 1) or ((v106 <= 2) and v13:BuffUp(v86.TheRottenBuff) and not v13:HasTier(30, 2));
	end
	local function v121(v145, v146)
		return v145 and ((v13:BuffStack(v86.DanseMacabreBuff) >= 3) or not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\200\169\13\215\89\193\169\0\197\94\254\173", "\60\140\200\99\164")]:IsAvailable()) and (not v146 or (v96 ~= 2));
	end
	local function v122(v147)
		return v13:BuffUp(v86.ShadowDanceBuff) and (v147:TimeSinceLastCast() < v86[LUAOBFUSACTOR_DECRYPT_STR_0("\180\252\5\34\173\144\208\5\40\161\130", "\194\231\148\100\70")]:TimeSinceLastCast());
	end
	local function v123(v148, v149)
		local v150 = 0;
		local v151;
		local v152;
		local v153;
		local v154;
		local v155;
		local v156;
		while true do
			if ((2 == v150) or (1784 > 4781)) then
				if ((4585 > 3298) and (not v156 or v109) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\153\214\91\82\86\88\62", "\45\203\163\43\38\35\42\91")]:IsCastable() and v14:DebuffRefreshable(v86.Rupture, v103) and (v106 > 0)) then
					if ((v92 and (v14:FilteredTimeToDie(">", 6, -v14:DebuffRemains(v86.Rupture)) or v14:TimeToDieIsNotValid()) and v85.CanDoTUnit(v14, v104) and v14:DebuffRefreshable(v86.Rupture, v103)) or (1664 > 1698)) then
						if (v148 or (3427 < 2849)) then
							return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\224\144\204\55\146\187\81", "\52\178\229\188\67\231\201")];
						elseif ((3616 <= 4429) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\19\84\64\16\226\78\38", "\67\65\33\48\100\151\60")]:IsReady() and v10.Cast(v86.Rupture)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\252\230\189\204\179\237\242\190\204\230\205\226\238\137", "\147\191\135\206\184");
						end
					end
				end
				if ((3988 >= 66) and not v156 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\182\61\182\213\205\65\183", "\210\228\72\198\161\184\51")]:IsCastable() and (v106 > 0)) then
					if (((v96 == 1) and v13:BuffUp(v86.FinalityRuptureBuff) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\18\72\225\27\81\220\51\94", "\174\86\41\147\112\19")]:IsAvailable() or v86[LUAOBFUSACTOR_DECRYPT_STR_0("\127\1\131\24\32\34\16\168\90\2\159\14", "\203\59\96\237\107\69\111\113")]:IsAvailable()) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\23\30\173\229\62\231\243\37\24\175\228", "\183\68\118\204\129\81\144")]:CooldownRemains() < 12) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\61\165\113\224\4\149\42\172\126\231\14", "\226\110\205\16\132\107")]:ChargesFractional() <= 1)) or (862 > 4644)) then
						if ((1221 == 1221) and v148) then
							return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\217\214\240\205\84\249\198", "\33\139\163\128\185")];
						elseif ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\101\77\20\202\66\74\1", "\190\55\56\100")]:IsReady() and v10.Cast(v86.Rupture)) or (45 > 1271)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\117\174\47\10\83\209\230\70\187\41\12\22\163\187\112\166\50\31\31\234\231\79\230", "\147\54\207\92\126\115\131");
						end
					end
				end
				if ((3877 > 1530) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\46\62\57\121\47\114\2\62\49", "\30\109\81\85\29\109")]:IsReady() and v121(v151, v155) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\204\116\87\164\51\202\200\250\114\92\184\63\207\233\250", "\156\159\17\52\214\86\190")]:IsReady()) then
					local v226 = 0;
					while true do
						if ((v226 == 0) or (4798 == 1255)) then
							if (v148 or (2541 > 2860)) then
								return v88[LUAOBFUSACTOR_DECRYPT_STR_0("\157\234\190\174\171\251\137\185\173\231\179\181\191\250\184", "\220\206\143\221")];
							end
							if (v26(v88.SecretTechnique) or (2902 > 3629)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\165\124\62\3\152\239\221\138\121\109\53\212\195\221\130", "\178\230\29\77\119\184\172");
							end
							break;
						end
					end
				end
				if ((427 < 3468) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\198\187\9\9\114\236\193\187\9\19\121\241\228\171\15", "\152\149\222\106\123\23")]:IsReady() and v121(v151, v155) and (not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\254\41\250\71\151\209\41\249\71", "\213\189\70\150\35")]:IsAvailable() or v86[LUAOBFUSACTOR_DECRYPT_STR_0("\108\90\120\12\109\89\123\7\75", "\104\47\53\20")]:IsReady() or v13:BuffUp(v86.ColdBlood) or (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\128\67\141\24\158\3\172\67\133", "\111\195\44\225\124\220")]:CooldownRemains() > (v152 - 2)))) then
					local v227 = 0;
					while true do
						if ((4190 >= 2804) and (0 == v227)) then
							if ((2086 == 2086) and v148) then
								return v88[LUAOBFUSACTOR_DECRYPT_STR_0("\235\67\3\97\174\191\236\67\3\123\165\162\201\83\5", "\203\184\38\96\19\203")];
							end
							if ((4148 > 2733) and v26(v88.SecretTechnique)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\26\114\106\85\142\10\118\122\83\203\45\51\77\68\205\49\125\112\80\219\60", "\174\89\19\25\33");
							end
							break;
						end
					end
				end
				v150 = 3;
			end
			if ((3054 >= 1605) and (v150 == 3)) then
				if ((1044 < 1519) and not v156 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\29\7\66\90\226\149\14", "\107\79\114\50\46\151\231")]:IsCastable()) then
					local v228 = 0;
					while true do
						if ((1707 <= 4200) and (v228 == 0)) then
							if ((580 == 580) and not v148 and v35 and not v109 and (v96 >= 2)) then
								local v253 = 0;
								local v254;
								while true do
									if ((601 <= 999) and (v253 == 1)) then
										v99 = v113(v86.Rupture, v254, 2 * v154, v97, v88.RuptureMouseover);
										if ((3970 == 3970) and v99) then
											return v99;
										end
										break;
									end
									if ((v253 == 0) or (98 == 208)) then
										v254 = nil;
										function v254(v266)
											return v84.CanDoTUnit(v266, v104) and v266:DebuffRefreshable(v86.Rupture, v103);
										end
										v253 = 1;
									end
								end
							end
							if ((2006 <= 3914) and v92 and (v14:DebuffRemains(v86.Rupture) < (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\10\191\184\43\133\53\164\207\63\130\176\40\158\49", "\160\89\198\213\73\234\89\215")]:CooldownRemains() + 10)) and (v106 > 0) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\123\104\185\252\202\68\98\187\248\225\77\112\160\246", "\165\40\17\212\158")]:CooldownRemains() <= 5) and v85.CanDoTUnit(v14, v104) and v14:FilteredTimeToDie(">", 5 + v86[LUAOBFUSACTOR_DECRYPT_STR_0("\214\192\5\49\41\233\202\7\53\2\224\216\28\59", "\70\133\185\104\83")]:CooldownRemains(), -v14:DebuffRemains(v86.Rupture))) then
								if (v148 or (3101 <= 2971)) then
									return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\54\80\84\62\220\22\64", "\169\100\37\36\74")];
								elseif ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\50\146\178\68\21\149\167", "\48\96\231\194")]:IsReady() and v10.Cast(v86.Rupture)) or (2073 <= 671)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\235\91\29\57\89\234\186\147\220\79\28\40\89\138", "\227\168\58\110\77\121\184\207");
								end
							end
							break;
						end
					end
				end
				if ((3305 > 95) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\89\48\190\67\186\235\126\178\127\57\173", "\197\27\92\223\32\209\187\17")]:IsCastable() and ((not v109 and (v96 >= 3)) or ((v96 == 2) and v151 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\39\94\205\232\6\114\194\248\2\93\209\254", "\155\99\63\163")]:IsAvailable() and not v122(v86.BlackPowder)))) then
					if ((2727 == 2727) and v148) then
						return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\160\221\160\142\178\180\141\198\165\136\171", "\228\226\177\193\237\217")];
					elseif ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\22\188\34\229\63\128\44\241\48\181\49", "\134\84\208\67")]:IsReady() and v26(v86.BlackPowder)) or (2970 >= 4072)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\173\149\72\83\142\138\93\16\167\198\108\28\187\130\89\1", "\60\115\204\230");
					end
				end
				if ((3881 > 814) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\194\44\226\99\228\63\249\113\243\63", "\16\135\90\139")]:IsCastable() and v92 and (v106 > 1)) then
					if (v148 or (4932 < 4868)) then
						return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\113\98\15\32\77\81\106\85\96\3", "\24\52\20\102\83\46\52")];
					elseif ((3667 <= 4802) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\225\57\40\55\12\193\61\32\48\10", "\111\164\79\65\68")]:IsReady() and v26(v86.Eviscerate)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\216\144\202\110\207\208\208\144\221\43\248\199\205\134", "\138\166\185\227\190\78");
					end
				end
				return false;
			end
			if ((1260 >= 858) and (v150 == 1)) then
				v155 = v13:BuffUp(v86.PremeditationBuff) or (v149 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\118\94\196\174\243\204\79\88\192\183\255\199\72", "\168\38\44\161\195\150")]:IsAvailable());
				if ((v149 and (v149:ID() == v86[LUAOBFUSACTOR_DECRYPT_STR_0("\179\244\131\114\63\255\146\23\142\255\135", "\118\224\156\226\22\80\136\214")]:ID())) or (3911 == 4700)) then
					local v229 = 0;
					while true do
						if ((3000 < 4194) and (0 == v229)) then
							v151 = true;
							v152 = 8 + v86[LUAOBFUSACTOR_DECRYPT_STR_0("\107\227\73\146\77\248\92\132\113\230\88\132\77\249\125\129\76\237\92", "\224\34\142\57")]:TalentRank();
							v229 = 1;
						end
						if ((651 < 4442) and (1 == v229)) then
							if (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\234\175\192\251\122\227\78\26\250\166\203\222\118", "\110\190\199\165\189\19\145\61")]:IsAvailable() or (195 >= 1804)) then
								v154 = v31(v13:ComboPointsMax(), v106 + 4);
							end
							if (v13:HasTier(30, 2) or (1382 > 2216)) then
								v153 = v32(v153, 6);
							end
							break;
						end
					end
				end
				if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\233\231\126\235\142\198\212\239\83\225\136\194", "\167\186\139\23\136\235")]:IsCastable() and v10.FilteredFightRemains(v95, ">", v13:BuffRemains(v86.SliceandDice))) or (2861 == 2459)) then
					if ((1903 < 4021) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\42\167\141\0\31\177\129\25\27\161\129\2\20", "\109\122\213\232")]:IsAvailable() and (v96 < 5)) then
						if (((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\221\255\163\52\225\224\134\49\224\244\167", "\80\142\151\194")]:ChargesFractional() < 1.75) and (v13:BuffRemains(v86.SliceandDice) < v86[LUAOBFUSACTOR_DECRYPT_STR_0("\48\223\122\78\12\202\100\67\5\226\114\77\23\206", "\44\99\166\23")]:CooldownRemains()) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\79\255\40\50\60\179\88\246\39\53\54", "\196\28\151\73\86\83")]:Charges() >= 1) and ((v153 - v152) < 1.2)) or (2270 >= 4130)) then
							if ((2593 <= 3958) and v148) then
								return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\192\15\32\19\135\89\22\114\215\10\42\21", "\22\147\99\73\112\226\56\120")];
							elseif ((1176 == 1176) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\139\121\235\246\136\185\123\230\209\132\187\112", "\237\216\21\130\149")]:IsReady() and v10.Cast(v86.SliceandDice)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\161\79\76\75\240\250\82\139\77\90\31\177\199\90\194\106\86\92\181\137\22\178\92\90\82\181\205\23", "\62\226\46\63\63\208\169");
							end
						end
					elseif (((v96 < 6) and not v151 and (v13:BuffRemains(v86.SliceandDice) < (1 + (v154 * 1.8)))) or (3062 == 1818)) then
						if (v148 or (3717 < 3149)) then
							return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\214\21\92\128\26\12\33\90\193\16\86\134", "\62\133\121\53\227\127\109\79")];
						elseif ((3195 < 3730) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\35\24\59\246\211\175\172\20\48\59\246\211", "\194\112\116\82\149\182\206")]:IsReady() and v10.Cast(v86.SliceandDice)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\26\169\95\12\128\209\2\48\171\73\88\193\236\10\121\140\69\27\197", "\110\89\200\44\120\160\130");
						end
					end
				end
				v156 = v118(v151);
				v150 = 2;
			end
			if ((2797 <= 3980) and (v150 == 0)) then
				v151 = v13:BuffUp(v86.ShadowDanceBuff);
				v152 = v13:BuffRemains(v86.ShadowDanceBuff);
				v153 = v13:BuffRemains(v86.SymbolsofDeath);
				v154 = v106;
				v150 = 1;
			end
		end
	end
	local function v124(v157, v158)
		local v159 = 0;
		local v160;
		local v161;
		local v162;
		local v163;
		local v164;
		local v165;
		local v166;
		local v167;
		local v168;
		local v169;
		local v170;
		local v171;
		while true do
			if ((1944 <= 2368) and (7 == v159)) then
				if ((1709 < 4248) and (v13:BuffStack(v86.PerforatedVeinsBuff) >= 5) and (v96 < 3)) then
					if (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\202\242\2\252\245\213\225\255\9\246", "\183\141\158\109\147\152")]:IsCastable() or (3970 == 3202)) then
						if (v157 or (3918 >= 4397)) then
							if (v158 or (780 == 3185)) then
								return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\11\5\233\3\33\11\234\13\40\12", "\108\76\105\134")];
							else
								return {v86[LUAOBFUSACTOR_DECRYPT_STR_0("\204\201\190\238\195\233\201\176\229\203", "\174\139\165\209\129")],v86[LUAOBFUSACTOR_DECRYPT_STR_0("\147\182\240\199\201\17\113\108\166\183\212\196\207\13\99", "\24\195\211\130\161\166\99\16")]};
							end
						end
					elseif (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\100\2\234\39\64\2\71\1", "\118\38\99\137\76\51")]:IsCastable() or (3202 >= 4075)) then
						if ((64 == 64) and v157) then
							if ((2202 >= 694) and v158) then
								return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\223\39\6\25\26\52\252\36", "\64\157\70\101\114\105")];
							else
								return {v86[LUAOBFUSACTOR_DECRYPT_STR_0("\98\169\164\232\3\84\169\165", "\112\32\200\199\131")],v86[LUAOBFUSACTOR_DECRYPT_STR_0("\28\85\78\190\204\185\35\56\85\88\142\198\162\44\63", "\66\76\48\60\216\163\203")]};
							end
						end
					end
				end
				if ((3706 <= 3900) and v170 and not v13:StealthUp(true, false) and not v158 and v13:BuffUp(v86.SepsisBuff) and (v96 < 4)) then
					if ((2890 > 2617) and v157) then
						return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\137\142\120\247\80\217\55\174\148\112\248\90", "\68\218\230\25\147\63\174")];
					end
				end
				if ((v35 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\158\34\70\94\191\166\47\93\127\162\162\56\94", "\214\205\74\51\44")]:IsCastable() and (v96 >= (3 + v21(v162))) and (not v165 or ((v96 >= 7) and not v109))) or (3355 > 4385)) then
					if (v157 or (3067 <= 2195)) then
						return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\201\68\247\238\126\241\73\236\207\99\245\94\239", "\23\154\44\130\156")];
					end
				end
				v159 = 8;
			end
			if ((3025 >= 2813) and (v159 == 0)) then
				v160 = v13:BuffUp(v86.ShadowDanceBuff);
				v161 = v13:BuffRemains(v86.ShadowDanceBuff);
				v162 = v13:BuffUp(v86.TheRottenBuff);
				v159 = 1;
			end
			if ((2412 >= 356) and (v159 == 5)) then
				if ((2070 > 1171) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\144\91\202\18\44\188\187\86\193\24", "\222\215\55\165\125\65")]:IsCastable() and ((v171 and (not v122(v86.Gloomblade) or (v96 ~= 2))) or ((v163 <= 2) and v162 and (v96 <= 3)))) then
					if (v157 or (4108 < 3934)) then
						if ((3499 >= 3439) and v158) then
							return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\11\221\201\21\255\195\225\75\40\212", "\42\76\177\166\122\146\161\141")];
						else
							return {v86[LUAOBFUSACTOR_DECRYPT_STR_0("\130\134\10\193\116\116\169\139\1\203", "\22\197\234\101\174\25")],v86[LUAOBFUSACTOR_DECRYPT_STR_0("\30\32\160\221\122\187\223", "\230\77\84\197\188\22\207\183")]};
						end
					end
				end
				if ((876 < 3303) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\219\21\197\247\159\181\241\55", "\85\153\116\166\156\236\193\144")]:IsCastable() and v171 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\128\225\67\160\225\45\165\227\76\177\246\5", "\96\196\128\45\211\132")]:IsAvailable() and not v122(v86.Backstab) and (v13:BuffStack(v86.DanseMacabreBuff) <= 2) and (v96 <= 2)) then
					if ((2922 <= 3562) and v157) then
						if ((2619 >= 1322) and v158) then
							return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\23\140\120\84\193\187\181\218", "\184\85\237\27\63\178\207\212")];
						else
							return {v86[LUAOBFUSACTOR_DECRYPT_STR_0("\42\88\10\84\27\77\8\93", "\63\104\57\105")],v86[LUAOBFUSACTOR_DECRYPT_STR_0("\56\147\161\69\7\147\172", "\36\107\231\196")]};
						end
					end
				end
				if ((4133 >= 2404) and (v169 >= v85.CPMaxSpend())) then
					return v123(v157, v158);
				end
				v159 = 6;
			end
			if ((v159 == 1) or (1433 == 2686)) then
				v163, v164 = v106, v107;
				v165 = v13:BuffUp(v86.PremeditationBuff) or (v158 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\251\102\192\58\87\39\16\223\117\209\62\93\45", "\121\171\20\165\87\50\67")]:IsAvailable());
				v166 = v13:BuffUp(v86.SilentStormBuff) or (v158 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\245\49\181\51\183\22\245\44\182\36\180", "\98\166\88\217\86\217")]:IsAvailable());
				v159 = 2;
			end
			if ((v159 == 4) or (4123 == 4457)) then
				if ((v170 and (v167 or v168) and ((v96 < 4) or v109)) or (3972 <= 205)) then
					if (v157 or (3766 < 1004)) then
						return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\237\172\90\72\75\203\91\202\182\82\71\65", "\40\190\196\59\44\36\188")];
					end
				end
				v171 = (v13:BuffStack(v86.DanseMacabreBuff) < 5) and ((v164 == 2) or (v164 == 3)) and (v165 or (v169 < 7)) and ((v96 <= 8) or v86[LUAOBFUSACTOR_DECRYPT_STR_0("\16\76\210\179\255\111\4\50\66\239\188\251\121\2\43", "\109\92\37\188\212\154\29")]:IsAvailable());
				if ((1784 < 2184) and ((v171 and v166 and v14:DebuffDown(v86.FindWeaknessDebuff) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\45\226\180\209\62\76\1\235\151\203\36\72\13\228\161\205\2\78\11\253\169", "\58\100\143\196\163\81")]:IsAvailable()) or (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\62\67\45\176\58\100\228\13\27\64\49\166", "\110\122\34\67\195\95\41\133")]:IsAvailable() and (v163 <= 1) and (v96 == 2) and not v122(v86.ShurikenStorm)))) then
					if (v157 or (1649 > 4231)) then
						return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\70\185\78\88\223\126\180\85\121\194\122\163\86", "\182\21\209\59\42")];
					end
				end
				v159 = 5;
			end
			if ((3193 == 3193) and (8 == v159)) then
				if ((v170 and ((v14:DebuffRemains(v86.FindWeaknessDebuff) < 1) or ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\34\191\160\172\57\31\2\169\171\138\51\18\5\174", "\115\113\198\205\206\86")]:CooldownRemains() < 18) and (v14:DebuffRemains(v86.FindWeaknessDebuff) < v86[LUAOBFUSACTOR_DECRYPT_STR_0("\183\78\243\88\139\91\237\85\130\115\251\91\144\95", "\58\228\55\158")]:CooldownRemains())))) or (3495 > 4306)) then
					if ((4001 > 3798) and v157) then
						return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\135\129\209\42\51\186\38\160\155\217\37\57", "\85\212\233\176\78\92\205")];
					end
				end
				if (v170 or (4688 <= 4499)) then
					if (v157 or (1567 <= 319)) then
						return v86[LUAOBFUSACTOR_DECRYPT_STR_0("\121\80\137\230\69\79\155\246\88\81\131\231", "\130\42\56\232")];
					end
				end
				return false;
			end
			if ((v159 == 6) or (4583 == 3761)) then
				if ((3454 > 1580) and v13:BuffUp(v86.ShurikenTornado) and (v164 <= 2)) then
					return v123(v157, v158);
				end
				if (((v96 >= (4 - v21(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\110\176\163\139\123\180\182\130", "\231\61\213\194")]:IsAvailable()))) and (v169 >= 4)) or (1607 == 20)) then
					return v123(v157, v158);
				end
				if ((v164 <= (1 + v27(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\58\168\60\127\47\172\41\118", "\19\105\205\93")]:IsAvailable() or v86[LUAOBFUSACTOR_DECRYPT_STR_0("\141\13\219\145\58\187\59\202\147\62\189\9\217\132\50", "\95\201\104\190\225")]:IsAvailable() or v86[LUAOBFUSACTOR_DECRYPT_STR_0("\156\206\194\220\170\223\242\218\189\202\213\207\168\206\204", "\174\207\171\161")]:IsAvailable()))) or (962 >= 4666)) then
					return v123(v157, v158);
				end
				v159 = 7;
			end
			if ((2 == v159) or (1896 == 1708)) then
				v167 = v13:BuffUp(v85.StealthSpell()) or (v158 and (v158:ID() == v85.StealthSpell():ID()));
				v168 = v13:BuffUp(v85.VanishBuffSpell()) or (v158 and (v158:ID() == v86[LUAOBFUSACTOR_DECRYPT_STR_0("\192\247\119\8\149\212", "\188\150\150\25\97\230")]:ID()));
				if ((3985 >= 1284) and v158 and (v158:ID() == v86[LUAOBFUSACTOR_DECRYPT_STR_0("\233\129\94\6\3\250\254\136\81\1\9", "\141\186\233\63\98\108")]:ID())) then
					local v230 = 0;
					while true do
						if ((v230 == 1) or (1987 == 545)) then
							if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\68\199\140\187\176\2\100\202\135", "\118\16\175\233\233\223")]:IsAvailable() and v13:HasTier(30, 2)) or (4896 < 1261)) then
								v162 = true;
							end
							if ((23 < 3610) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\191\140\48\157\231\153\110\159\160\52\181\237\142", "\29\235\228\85\219\142\235")]:IsAvailable()) then
								local v255 = 0;
								while true do
									if ((v255 == 0) or (3911 < 2578)) then
										v163 = v31(v13:ComboPointsMax(), v106 + 4);
										v164 = v13:ComboPointsMax() - v163;
										break;
									end
								end
							end
							break;
						end
						if ((v230 == 0) or (4238 < 87)) then
							v160 = true;
							v161 = 8 + v86[LUAOBFUSACTOR_DECRYPT_STR_0("\216\231\60\164\42\231\239\40\133\45\240\238\35\161\1\240\228\47\179", "\69\145\138\76\214")]:TalentRank();
							v230 = 1;
						end
					end
				end
				v159 = 3;
			end
			if ((2538 == 2538) and (3 == v159)) then
				v169 = v85.EffectiveComboPoints(v163);
				v170 = v86[LUAOBFUSACTOR_DECRYPT_STR_0("\14\220\187\217\120\89\52\70\47\221\177\216", "\50\93\180\218\189\23\46\71")]:IsCastable() or v167 or v168 or v160 or v13:BuffUp(v86.SepsisBuff);
				if ((4122 == 4122) and (v167 or v168)) then
					v170 = v170 and v14:IsInRange(25);
				else
					v170 = v170 and v92;
				end
				v159 = 4;
			end
		end
	end
	local function v125(v172, v173)
		local v174 = 0;
		local v175;
		local v176;
		while true do
			if ((3 == v174) or (2371 > 2654)) then
				return false;
			end
			if ((0 == v174) or (3466 > 4520)) then
				v175 = v124(true, v172);
				if (not v173 or (951 >= 1027)) then
					v173 = 1;
				end
				v174 = 1;
			end
			if ((1 == v174) or (1369 > 2250)) then
				if ((v13:Power() < v173) or (937 > 3786)) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\218\186\43\239\73\49\237", "\95\138\213\68\131\32");
				end
				if (((v172:ID() == v86[LUAOBFUSACTOR_DECRYPT_STR_0("\28\41\175\74\101\34", "\22\74\72\193\35")]:ID()) and (not v79 or not v175)) or (901 > 4218)) then
					local v231 = 0;
					while true do
						if ((4779 > 4047) and (0 == v231)) then
							if ((4050 > 1373) and v10.Cast(v86.Vanish, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\15\120\247\76\108\79\229\86\37\106\236", "\56\76\25\132");
							end
							return false;
						end
					end
				elseif (((v172:ID() == v86[LUAOBFUSACTOR_DECRYPT_STR_0("\109\201\170\34\192\73\204\174\42\203", "\175\62\161\203\70")]:ID()) and (not v80 or not v175)) or (1037 > 4390)) then
					local v246 = 0;
					while true do
						if ((1407 <= 1919) and (v246 == 0)) then
							if ((2526 >= 1717) and v10.Cast(v86.Shadowmeld, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\31\220\208\7\117\15\213\194\23\58\43\208\198\31\49", "\85\92\189\163\115");
							end
							return false;
						end
					end
				elseif (((v172:ID() == v86[LUAOBFUSACTOR_DECRYPT_STR_0("\26\164\49\60\38\187\20\57\39\175\53", "\88\73\204\80")]:ID()) and (not v81 or not v175) and v36) or (3620 <= 2094)) then
					local v251 = 0;
					while true do
						if ((v251 == 0) or (1723 >= 2447)) then
							if (v10.Cast(v88.ShadowDance, true) or (1199 > 3543)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\13\130\3\82\105\233\38\130\20\73\62\154\10\130\30\69\44", "\186\78\227\112\38\73");
							end
							return false;
						end
					end
				end
				v174 = 2;
			end
			if ((1617 < 3271) and (v174 == 2)) then
				v176 = {v172,v175};
				if ((3085 > 1166) and (v176[1] == v86[LUAOBFUSACTOR_DECRYPT_STR_0("\207\95\252\81\92\109\216\86\243\86\86", "\26\156\55\157\53\51")]) and v36) then
					local v232 = 0;
					while true do
						if ((4493 >= 3603) and (v232 == 0)) then
							v99 = v10.Cast(v88.ShadowDance, true);
							if ((2843 <= 2975) and v99) then
								return "|";
							end
							break;
						end
					end
				elseif ((v176[1] == v86[LUAOBFUSACTOR_DECRYPT_STR_0("\186\217\24\208\171\88", "\48\236\184\118\185\216")]) or (1989 <= 174)) then
					local v247 = 0;
					while true do
						if ((0 == v247) or (209 > 2153)) then
							v99 = v10.Cast(v86.Vanish);
							if (v99 or (2020 == 1974)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\249\253", "\84\133\221\55\80\175");
							end
							break;
						end
					end
				end
				v174 = 3;
			end
		end
	end
	local function v126()
		local v177 = 0;
		while true do
			if ((0 == v177) or (1347 == 1360)) then
				v99 = v84.HandleTopTrinket(v89, v36, 40, nil);
				if (v99 or (4461 == 3572)) then
					return v99;
				end
				v177 = 1;
			end
			if ((1 == v177) or (2872 == 318)) then
				v99 = v84.HandleBottomTrinket(v89, v36, 40, nil);
				if ((568 == 568) and v99) then
					return v99;
				end
				break;
			end
		end
	end
	local function v127()
		local v178 = 0;
		local v179;
		while true do
			if ((4200 == 4200) and (v178 == 3)) then
				if (v92 or (4285 < 1369)) then
					local v233 = 0;
					while true do
						if ((v233 == 0) or (3520 > 4910)) then
							if ((2842 <= 4353) and v36 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\203\42\46\59\220\86", "\36\152\79\94\72\181\37\98")]:IsReady() and v179 and (v107 >= 1) and not v14:FilteredTimeToDie("<", 16)) then
								if (v10.Cast(v86.Sepsis) or (3751 < 1643)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\244\217\84\43\151\235\66\47\196\209\84", "\95\183\184\39");
								end
							end
							if (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\134\38\234\36\91\140\17\186\57\195\35\85\148\10", "\98\213\95\135\70\52\224")]:IsCastable() or (4911 == 3534)) then
								if ((3001 > 16) and (((v13:BuffRemains(v86.SymbolsofDeath) <= 3) and not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\205\171\200\115\91\233\135\200\121\87\251", "\52\158\195\169\23")]:CooldownUp()) or not v13:HasTier(30, 2)) and v119() and v179 and ((not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\92\176\51\115\131\57\119\138\110\181\61\122", "\235\26\220\82\20\230\85\27")]:IsAvailable() and ((v106 <= 1) or not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\188\169\236\240\123\156\181\236\204", "\20\232\193\137\162")]:IsAvailable())) or (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\4\211\196\161\226\128\27\112\54\214\202\168", "\17\66\191\165\198\135\236\119")]:CooldownRemains() > 10) or (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\41\163\175\20\250\228\224\208\27\166\161\29", "\177\111\207\206\115\159\136\140")]:CooldownUp() and (v106 >= 5)))) then
									if ((2875 <= 3255) and v26(v86.SymbolsofDeath)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\38\136\3\0\148\124\70\8\139\31\24\199\15\80\3\201\52\17\213\91\87", "\63\101\233\112\116\180\47");
									end
								end
							end
							break;
						end
					end
				end
				if ((368 < 4254) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\238\58\255\25\253\50\197\52\255\54\253\55\215\51", "\86\163\91\141\114\152")]:IsCastable()) then
					local v234 = 0;
					while true do
						if ((v234 == 0) or (4841 <= 2203)) then
							if ((4661 > 616) and v14:FilteredTimeToDie("<", v107)) then
								if (v10.Cast(v86.MarkedforDeath, v64) or (1943 == 2712)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\112\10\103\103\122\126\10\102\120\63\87\75\114\124\40\19\47\113\114\46\91", "\90\51\107\20\19");
								end
							end
							if ((4219 >= 39) and not v13:StealthUp(true, true) and (v107 >= v85.CPMaxSpend())) then
								if ((3967 > 2289) and not v56) then
									v10.CastSuggested(v86.MarkedforDeath);
								elseif (v36 or (851 > 2987)) then
									if ((4893 >= 135) and v10.Cast(v86.MarkedforDeath, v64)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\174\241\150\251\125\160\241\151\228\56\137\176\131\224\47\205\212\128\238\41\133", "\93\237\144\229\143");
									end
								end
							end
							break;
						end
					end
				end
				v178 = 4;
			end
			if ((v178 == 4) or (3084 > 3214)) then
				if (v36 or (3426 < 2647)) then
					local v235 = 0;
					while true do
						if ((v235 == 3) or (1576 == 4375)) then
							if ((v51 and v36) or (2920 < 2592)) then
								local v256 = 0;
								while true do
									if ((v256 == 0) or (1110 >= 2819)) then
										v99 = v126();
										if ((1824 <= 2843) and v99) then
											return v99;
										end
										break;
									end
								end
							end
							break;
						end
						if ((3062 == 3062) and (v235 == 2)) then
							if ((716 <= 4334) and v36 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\44\118\42\88\191\20\123\23\78\170", "\203\120\30\67\43")]:IsReady()) then
								if ((1001 < 3034) and ((((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\194\60\64\237\214\253\54\66\233\253\244\36\89\231", "\185\145\69\45\143")]:CooldownRemains() >= 3) or v13:BuffUp(v86.SymbolsofDeath)) and not v13:BuffUp(v86.ThistleTea) and (((v13:EnergyDeficitPredicted() >= 100) and ((v13:ComboPointsDeficit() >= 2) or (v96 >= 3))) or ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\190\23\16\181\200\134\26\45\163\221", "\188\234\127\121\198")]:ChargesFractional() >= 2.75) and v13:BuffUp(v86.ShadowDanceBuff)))) or ((v13:BuffRemains(v86.ShadowDanceBuff) >= 4) and not v13:BuffUp(v86.ThistleTea) and (v96 >= 3)) or (not v13:BuffUp(v86.ThistleTea) and v10.BossFilteredFightRemains(LUAOBFUSACTOR_DECRYPT_STR_0("\100\111", "\227\88\82\115"), 6 * v86[LUAOBFUSACTOR_DECRYPT_STR_0("\119\23\179\180\22\127\70\43\191\166", "\19\35\127\218\199\98")]:Charges())))) then
									if (v26(v86.ThistleTea, nil, nil, true) or (977 > 1857)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\40\243\3\241\8\247\15\162\40\254\11", "\130\124\155\106");
									end
								end
							end
							if (v13:BuffUp(v86.SymbolsofDeath) or (868 > 897)) then
								local v257 = 0;
								while true do
									if ((v257 == 1) or (1115 == 4717)) then
										if ((2740 < 4107) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\36\73\255\246\0\76\226\252\6", "\147\98\32\141")]:IsCastable()) then
											if ((284 < 700) and v10.Cast(v86.Fireblood, v59)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\59\66\240\222\70\112\66\10\70\225\198\9\89\79", "\43\120\35\131\170\102\54");
											end
										end
										if ((386 >= 137) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\117\8\132\179\182\164\150\85\10\164\183\169\188", "\228\52\102\231\214\197\208")]:IsCastable()) then
											if ((923 == 923) and v10.Cast(v86.AncestralCall, v59)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\61\225\102\222\170\170\23\213\27\243\97\216\235\135\89\245\31\236\121", "\182\126\128\21\170\138\235\121");
											end
										end
										break;
									end
									if ((v257 == 0) or (4173 == 359)) then
										if ((1722 == 1722) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\247\199\249\160\167\208\105\173\204", "\223\181\171\150\207\195\150\28")]:IsCastable()) then
											if (v10.Cast(v86.BloodFury, v59) or (3994 <= 3820)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\111\59\240\186\73\110\54\236\161\13\12\28\246\188\16", "\105\44\90\131\206");
											end
										end
										if ((1488 < 1641) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\221\229\160\170\13\44\244\233\188\190", "\94\159\128\210\217\104")]:IsCastable()) then
											if ((433 <= 2235) and v10.Cast(v86.Berserking, v59)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\115\248\21\171\31\93\252\104\67\252\20\180\86\113\254", "\26\48\153\102\223\63\31\153");
											end
										end
										v257 = 1;
									end
								end
							end
							v235 = 3;
						end
						if ((v235 == 1) or (1838 > 2471)) then
							if ((2444 < 3313) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\117\195\230\251\117\228\67\197\199\230\110\225\71\207\252", "\143\38\171\147\137\28")]:IsReady()) then
								local v258 = 0;
								while true do
									if ((v258 == 0) or (3685 <= 185)) then
										if ((738 <= 1959) and v117 and v13:BuffUp(v86.SymbolsofDeath) and (v106 <= 2) and (not v13:BuffUp(v86.PremeditationBuff) or (v96 > 4))) then
											if (v10.Cast(v86.ShurikenTornado) or (1317 == 3093)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\243\131\170\231\67\208\220\197\144\176\248\6\237\148\228\141\171\253\2\231\219\144\202\138\252\39\170", "\180\176\226\217\147\99\131");
											end
										end
										if ((not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\245\181\46\0\214\181\35\6\199\176\32\9", "\103\179\217\79")]:IsAvailable() and (v96 >= 3) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\121\191\29\209\78\155\135\75\185\31\208", "\195\42\215\124\181\33\236")]:Charges() >= 1) and not v13:StealthUp(true, true)) or (2611 >= 4435)) then
											if (v10.Cast(v86.ShurikenTornado) or (117 > 4925)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\46\88\36\42\101\203\5\76\37\55\46\253\3\25\3\49\55\246\12\93\56\126\109\220\12\87\52\59\108", "\152\109\57\87\94\69");
											end
										end
										break;
									end
								end
							end
							if ((107 <= 4905) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\202\223\11\167\177\197\112\169\247\212\15", "\200\153\183\106\195\222\178\52")]:IsCastable() and v111() and not v13:BuffUp(v86.ShadowDanceBuff) and v10.BossFilteredFightRemains(LUAOBFUSACTOR_DECRYPT_STR_0("\110\190", "\58\82\131\232\93\41"), 8) and v36) then
								local v259 = 0;
								while true do
									if ((v259 == 0) or (1004 > 4035)) then
										v99 = v125(v86.ShadowDance);
										if (v99 or (2802 < 369)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\176\95\209\17\82\40\195\115\209\27\94\58\195\122\209\22\79\48\195\31\252\26\74\127\183\99\244\92\29", "\95\227\55\176\117\61") .. v99;
										end
										break;
									end
								end
							end
							v235 = 2;
						end
						if ((1497 <= 2561) and (v235 == 0)) then
							if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\38\254\241\29\4\81\55\250\241\29\14\85", "\38\117\150\144\121\107")]:IsCastable() and (v13:BuffUp(v86.ShadowDanceBuff) or (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\30\179\239\62\34\172\202\59\35\184\235", "\90\77\219\142")]:CooldownRemains() < 10)) and ((v179 and (v107 >= 2) and v14:FilteredTimeToDie(LUAOBFUSACTOR_DECRYPT_STR_0("\184\89", "\26\134\100\65\89\44\103"), 10) and (not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\194\230\32\48\173\226", "\196\145\131\80\67")]:IsAvailable() or (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\45\181\22\27\17\251", "\136\126\208\102\104\120")]:CooldownRemains() <= 8) or v14:DebuffUp(v86.Sepsis))) or v10.BossFilteredFightRemains(LUAOBFUSACTOR_DECRYPT_STR_0("\36\215", "\49\24\234\174\35\207\50\93"), 20))) or (816 > 1712)) then
								if (v10.Cast(v86.ShadowBlades, true) or (2733 == 2971)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\47\243\238\156\49\63\250\252\140\126\27\178\223\132\112\8\247\238", "\17\108\146\157\232");
								end
							end
							if ((2599 < 4050) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\110\192\28\226\38\166\76\241\17\253\61\161\70\194\26\233", "\200\43\163\116\141\79")]:IsReady() and v92 and (v107 >= 3) and (v109 or (v96 <= 4) or v86[LUAOBFUSACTOR_DECRYPT_STR_0("\141\51\46\140\165\250\231\182\56\58\160\188\245\241\182\34\36", "\131\223\86\93\227\208\148")]:IsAvailable()) and (v13:BuffUp(v86.ShadowDanceBuff) or not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\199\68\184\165\24\152\226\70\183\180\15\176", "\213\131\37\214\214\125")]:IsAvailable())) then
								if ((2034 == 2034) and v10.Cast(v86.EchoingReprimand, nil)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\5\42\54\171\161\3\40\45\176\232\40\44\101\141\228\54\57\44\178\224\40\47", "\129\70\75\69\223");
								end
							end
							v235 = 1;
						end
					end
				end
				return false;
			end
			if ((3040 < 4528) and (2 == v178)) then
				if (v92 or (2092 <= 2053)) then
					if ((2120 < 4799) and v36 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\11\224\42\221\13\208\142\44\248\34\213\6", "\226\77\140\75\186\104\188")]:IsReady() and v179 and not v13:StealthUp(false, false) and (v106 >= 5) and v14:FilteredTimeToDie(">", 10)) then
						if (v10.Cast(v86.Flagellation, nil) or (4538 <= 389)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\154\207\195\43\15\159\194\209\56\74\181\194\209\43\70\182\192", "\47\217\174\176\95");
						end
					end
				end
				if ((270 <= 1590) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\139\213\99\16\187\95\125\40\140\210\100\12\179\80\119", "\70\216\189\22\98\210\52\24")]:IsCastable() and (v96 <= 1) and v179 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\233\198\174\133\220\214\204\172\129\247\223\222\183\143", "\179\186\191\195\231")]:CooldownUp() and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\202\55\25\224\246\40\60\229\247\60\29", "\132\153\95\120")]:Charges() >= 1) and (not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\151\190\15\42\242\214\172\176\166\7\34\249", "\192\209\210\110\77\151\186")]:IsAvailable() or v13:BuffUp(v86.Flagellation) or (v96 >= 5)) and (v106 <= 2) and not v13:BuffUp(v86.PremeditationBuff)) then
					if ((1625 > 1265) and (v13:Energy() >= 60)) then
						if (v10.Cast(v86.ShurikenTornado) or (51 >= 920)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\195\2\49\253\191\247\232\22\48\224\244\193\238\67\22\230\237\202\225\7\45", "\164\128\99\66\137\159");
						end
					elseif (not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\51\129\232\186\15\158\207\177\3\156\250", "\222\96\233\137")]:IsAvailable() or (2968 <= 1998)) then
						local v252 = 0;
						while true do
							if ((v252 == 0) or (3085 <= 2742)) then
								if (v10.CastPooling(v86.ShurikenTornado) or (376 >= 2083)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\137\188\168\19\200\245\255\171\243\148\23\157\225\249\178\182\169\95\188\252\226\183\178\163\16", "\144\217\211\199\127\232\147");
								end
								if ((4191 > 1232) and (v13:Energy() >= 60)) then
									return "1";
								end
								break;
							end
						end
					end
				end
				v178 = 3;
			end
			if ((v178 == 1) or (1505 > 4873)) then
				if ((3880 < 4534) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\150\66\11\231\179\75", "\142\192\35\101")]:IsCastable() and (v106 <= 2) and (v13:BuffStack(v86.DanseMacabreBuff) > 3) and ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\229\112\42\177\226\152\152\19\213\125\39\170\246\153\169", "\118\182\21\73\195\135\236\204")]:CooldownRemains() >= 30) or not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\59\57\25\82\1\25\201\13\63\18\78\13\28\232\13", "\157\104\92\122\32\100\109")]:IsAvailable())) then
					local v236 = 0;
					while true do
						if ((v236 == 0) or (2368 >= 2541)) then
							v99 = v125(v86.Vanish);
							if (v99 or (4733 <= 4103)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\149\167\193\195\46\47\205\134\162\165\221\197\125\111\169\134\234\230", "\203\195\198\175\170\93\71\237") .. v99;
							end
							break;
						end
					end
				end
				if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\13\68\50\209\115\29\243\33\79", "\156\78\43\94\181\49\113")]:IsReady() and not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\65\237\199\177\14\87\77\119\235\204\173\2\82\108\119", "\25\18\136\164\195\107\35")]:IsAvailable() and (v106 >= 5)) or (1207 == 4273)) then
					if (v10.Cast(v86.ColdBlood, true) or (2005 == 2529)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\203\44\186\91\50\159\206\180\236\109\139\67\125\179\197", "\216\136\77\201\47\18\220\161");
					end
				end
				v178 = 2;
			end
			if ((986 < 3589) and (v178 == 0)) then
				if (v13:BuffUp(v86.ShurikenTornado) or (3119 == 430)) then
					if ((2409 <= 3219) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\142\254\41\164\200\80\174\232\34\130\194\93\169\239", "\60\221\135\68\198\167")]:IsCastable() and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\221\181\249\135\77\206\202\188\246\128\71", "\185\142\221\152\227\34")]:IsCastable() and not v13:BuffUp(v86.SymbolsofDeath) and not v13:BuffUp(v86.ShadowDanceBuff)) then
						if (v10.Cast(v86.SymbolsofDeath, true) or (898 > 2782)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\124\196\89\249\70\115\188\24\246\78\247\65\60\251\75\133\31\254\86\33\254\86\194\23\206\76\33\249\89\193\88\179", "\151\56\165\55\154\35\83");
						end
					end
				end
				v179 = v117();
				v178 = 1;
			end
		end
	end
	local function v128(v180)
		local v181 = 0;
		while true do
			if ((v181 == 0) or (2250 <= 1764)) then
				if ((693 == 693) and v36 and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\184\210\52\226\137\4\20\7\133\217\48", "\102\235\186\85\134\230\115\80")]:TimeSinceLastDisplay() > 0.3) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\100\4\63\91\125\195\47\82\0\58", "\66\55\108\94\63\18\180")]:TimeSinceLastDisplay() > 0.3) and not v13:IsTanking(v14)) then
					if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\34\140\139\62\52\81", "\57\116\237\229\87\71")]:IsCastable() and (not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\142\176\227\244\114\195\70\169\176\239\245\114", "\39\202\209\141\135\23\142")]:IsAvailable() or (v96 >= 3)) and not v115() and (v107 > 1) and ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\217\63\8\13\55\244\243\50\29\3\61\246", "\152\159\83\105\106\82")]:CooldownRemains() >= 60) or not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\167\202\80\245\204\80\141\199\69\251\198\82", "\60\225\166\49\146\169")]:IsAvailable() or v10.BossFilteredFightRemains(LUAOBFUSACTOR_DECRYPT_STR_0("\115\67", "\103\79\126\79\74\97"), 30 * v86[LUAOBFUSACTOR_DECRYPT_STR_0("\140\126\221\122\77\18", "\122\218\31\179\19\62")]:Charges()))) or (2529 == 438)) then
						local v248 = 0;
						while true do
							if ((1751 > 1411) and (v248 == 0)) then
								v99 = v125(v86.Vanish, v180);
								if ((4182 == 4182) and v99) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\133\215\195\200\218\169\5\158\215\206\211\198\225", "\37\211\182\173\161\169\193") .. v99;
								end
								break;
							end
						end
					end
				end
				if ((v92 and v36 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\196\50\76\221\39\108\157\246\52\78\220", "\217\151\90\45\185\72\27")]:IsCastable() and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\240\116\230\22\89\212\88\230\28\85\198", "\54\163\28\135\114")]:Charges() >= 1) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\30\218\83\139\93\119", "\31\72\187\61\226\46")]:TimeSinceLastDisplay() > 0.3) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\240\14\66\214\72\105\41\198\10\71", "\68\163\102\35\178\39\30")]:TimeSinceLastDisplay() > 0.3) and (v36 or (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\141\120\219\195\12\162\167\16\176\115\223", "\113\222\16\186\167\99\213\227")]:ChargesFractional() >= (v73 - ((not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\29\6\250\242\33\25\223\247\32\13\254\194\47\2\254\248\58", "\150\78\110\155")]:IsAvailable() and 0.75) or 0))))) or (4666 <= 611)) then
					local v237 = 0;
					while true do
						if ((v237 == 0) or (4737 <= 4525)) then
							if ((4367 >= 3735) and ((v116() and ((not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\182\205\38\229\171\9\155\65\139\198\34\213\165\18\186\78\145", "\32\229\165\71\129\196\126\223")]:IsAvailable() and (v13:BuffRemains(v86.SymbolsofDeath) >= (2.2 - v21(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\229\133\197\134\132\217\207\136\208\136\142\219", "\181\163\233\164\225\225")]:IsAvailable())))) or v115())) or (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\99\131\63\115\95\156\26\118\94\136\59\67\81\135\59\121\68", "\23\48\235\94")]:IsAvailable() and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\79\223\219\79\82\39\230\121\217\208\83\94\34\199\121", "\178\28\186\184\61\55\83")]:CooldownRemains() <= 9) and ((v96 <= 3) or v86[LUAOBFUSACTOR_DECRYPT_STR_0("\224\204\73\47\247\35\244\199\204\69\46\247", "\149\164\173\39\92\146\110")]:IsAvailable())) or (v13:BuffRemains(v86.FlagellationPersistBuff) >= 6) or ((v96 >= 4) and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\192\62\29\29\21\23\224\40\22\59\31\26\231\47", "\123\147\71\112\127\122")]:CooldownRemains() > 10))) and v120()) then
								local v260 = 0;
								while true do
									if ((2426 == 2426) and (v260 == 0)) then
										v99 = v125(v86.ShadowDance, v180);
										if ((21 < 1971) and v99) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\255\197\131\117\73\219\233\131\127\69\201\141\175\112\69\222\194\194\32\6", "\38\172\173\226\17") .. v99;
										end
										break;
									end
								end
							end
							if ((v111() and ((v116() and v10.BossFilteredFightRemains("<", v86[LUAOBFUSACTOR_DECRYPT_STR_0("\126\8\33\237\66\29\63\224\75\53\41\238\89\25", "\143\45\113\76")]:CooldownRemains())) or (not v86[LUAOBFUSACTOR_DECRYPT_STR_0("\139\176\29\56\183\175\56\61\182\187\25\8\185\180\25\50\172", "\92\216\216\124")]:IsAvailable() and v14:DebuffUp(v86.Rupture) and (v96 <= 4) and v120()))) or (2922 <= 441)) then
								local v261 = 0;
								while true do
									if ((3624 >= 1136) and (0 == v261)) then
										v99 = v125(v86.ShadowDance, v180);
										if ((2043 < 2647) and v99) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\104\58\173\68\242\76\22\173\78\254\94\114\129\65\254\73\61\236\18\189", "\157\59\82\204\32") .. v99;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				v181 = 1;
			end
			if ((v181 == 1) or (354 >= 1534)) then
				return false;
			end
		end
	end
	local function v129(v182)
		local v183 = 0;
		local v184;
		while true do
			if ((0 == v183) or (3764 >= 4876)) then
				v184 = not v182 or (v13:EnergyPredicted() >= v182);
				if ((3676 >= 703) and v35 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\11\54\246\232\224\225\214\191\11\42\236\232\228", "\209\88\94\131\154\137\138\179")]:IsCastable() and (v96 >= (2 + v21((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\15\173\203\115\19\33\61\35\44\164", "\66\72\193\164\28\126\67\81")]:IsAvailable() and (v13:BuffRemains(v86.LingeringShadowBuff) >= 6)) or v13:BuffUp(v86.PerforatedVeinsBuff))))) then
					if ((3811 > 319) and v184 and v10.Cast(v86.ShurikenStorm)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\45\187\76\102\69\239\57\186\81\45\115\233\108\155\76\41\100\234", "\22\135\76\200\56\70");
					end
				end
				v183 = 1;
			end
			if ((47 < 1090) and (1 == v183)) then
				if (v92 or (1371 >= 2900)) then
					local v238 = 0;
					while true do
						if ((v238 == 0) or (1126 <= 504)) then
							if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\168\51\240\43\84\239\138\2\253\52\79\232\128\49\246\32", "\129\237\80\152\68\61")]:IsAvailable() and (v13:Energy() < 60) and (((v106 == 2) and v13:BuffUp(v86.EchoingReprimand3)) or ((v106 == 3) and v13:BuffUp(v86.EchoingReprimand4)) or ((v106 == 4) and v13:BuffUp(v86.EchoingReprimand5))) and ((v85.TimeToSht(3) < 0.5) or (v85.TimeToSht(4) < 1) or (v85.TimeToSht(5) < 1))) or (3732 == 193)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\116\132\68\212\25\25\93\67\169\16\252\14\87\104\94\167\8\250\18\16", "\56\49\200\100\147\124\119");
							end
							if ((3344 >= 3305) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\235\50\176\255\193\60\179\241\200\59", "\144\172\94\223")]:IsCastable()) then
								if ((v184 and v10.Cast(v86.Gloomblade)) or (2885 < 1925)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\7\14\177\83\100\40\174\72\43\2\160\75\37\11\167", "\39\68\111\194");
								end
							elseif (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\244\167\228\204\106\163\215\164", "\215\182\198\135\167\25")]:IsCastable() or (4542 <= 1594)) then
								if ((338 <= 3505) and v184 and v10.Cast(v86.Backstab)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\174\72\249\92\205\107\235\75\134\90\254\73\143", "\40\237\41\138");
								end
							end
							break;
						end
					end
				end
				return false;
			end
		end
	end
	local function v130()
		C_Timer.After(0.25, function()
			local v185 = 0;
			while true do
				if ((69 == 69) and (7 == v185)) then
					v104 = v86[LUAOBFUSACTOR_DECRYPT_STR_0("\152\253\54\179\202\184\249\62\180\204", "\169\221\139\95\192")]:Damage() * v72;
					if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\246\142\126\51\54\46\205\159\112\49\39", "\70\190\235\31\95\66")]:IsReady() and (v13:HealthPercentage() < v42) and not (v13:IsChanneling() or v13:IsCasting())) or (672 == 368)) then
						if ((1019 == 1019) and v10.Cast(v88.Healthstone)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\146\231\27\234\241\178\241\14\233\235\191\162", "\133\218\130\122\134");
						end
					end
					if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\14\250\229\214\217\176\48\53\241\228\236\217\162\52\53\241\228\244\211\183\49\51\241", "\88\92\159\131\164\188\195")]:IsReady() and (v13:HealthPercentage() < v40) and not (v13:IsChanneling() or v13:IsCasting())) or (290 > 2746)) then
						if ((1923 < 4601) and v10.Cast(v88.RefreshingHealingPotion)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\178\43\185\89\210\248\213\137\32\184\99\210\234\209\137\32\184\123\216\255\212\143\32\255", "\189\224\78\223\43\183\139");
						end
					end
					v185 = 8;
				end
				if ((v185 == 3) or (3957 == 2099)) then
					v91 = (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\199\252\152\172\211\231\235\131\160\226\242\237\131\168\212\245", "\177\134\159\234\195")]:IsAvailable() and 13) or 10;
					v92 = v14:IsInMeleeRange(v90);
					v93 = v14:IsInMeleeRange(v91);
					v185 = 4;
				end
				if ((4006 > 741) and (4 == v185)) then
					if ((2359 <= 3733) and v35) then
						local v239 = 0;
						while true do
							if ((v239 == 1) or (4596 <= 2402)) then
								v96 = #v95;
								v97 = v13:GetEnemiesInMeleeRange(v90);
								break;
							end
							if ((2078 > 163) and (v239 == 0)) then
								v94 = v13:GetEnemiesInRange(30);
								v95 = v13:GetEnemiesInMeleeRange(v91);
								v239 = 1;
							end
						end
					else
						local v240 = 0;
						while true do
							if ((4116 > 737) and (1 == v240)) then
								v96 = 1;
								v97 = {};
								break;
							end
							if ((v240 == 0) or (1175 > 4074)) then
								v94 = {};
								v95 = {};
								v240 = 1;
							end
						end
					end
					v106 = v13:ComboPoints();
					v105 = v85.EffectiveComboPoints(v106);
					v185 = 5;
				end
				if ((v185 == 0) or (1361 == 4742)) then
					v83();
					v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\243\123\253\255\70\194\103", "\42\167\20\154\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\69\241\161", "\65\42\158\194\34\17")];
					v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\46\40\85\11\33\232\8", "\142\122\71\50\108\77\141\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\173\250", "\91\117\194\159\120")];
					v185 = 1;
				end
				if ((5 == v185) or (4012 >= 4072)) then
					v107 = v13:ComboPointsDeficit();
					v109 = v112();
					v108 = v13:EnergyMax() - v114();
					v185 = 6;
				end
				if ((3807 >= 1276) and (v185 == 9)) then
					if ((2220 <= 4361) and not v13:AffectingCombat() and not v13:IsMounted() and v84.TargetIsValid()) then
						local v241 = 0;
						while true do
							if ((228 == 228) and (v241 == 0)) then
								v99 = v85.Stealth(v86.Stealth2, nil);
								if (v99 or (4118 <= 3578)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\207\29\90\122\228\232\1\31\51\199\211\42\22\33\168", "\136\156\105\63\27") .. v99;
								end
								break;
							end
						end
					end
					if ((not v13:IsChanneling() and ToggleMain) or (2915 < 1909)) then
						local v242 = 0;
						while true do
							if ((634 <= 2275) and (v242 == 0)) then
								if ((1091 <= 2785) and not v13:AffectingCombat() and v14:AffectingCombat() and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\45\141\119\61\8\132", "\84\123\236\25")]:TimeSinceLastCast() > 1)) then
									local v262 = 0;
									while true do
										if ((4638 >= 2840) and (v262 == 0)) then
											if ((v84.TargetIsValid() and (v14:IsSpellInRange(v86.Shadowstrike) or v92)) or (1292 > 4414)) then
												if ((3511 == 3511) and v13:StealthUp(true, true)) then
													local v272 = 0;
													while true do
														if ((2132 == 2132) and (v272 == 0)) then
															CastAbility = v124(true);
															if ((932 <= 3972) and CastAbility) then
																if (((type(CastAbility) == LUAOBFUSACTOR_DECRYPT_STR_0("\228\138\168\27\169", "\213\144\235\202\119\204")) and (#CastAbility > 1)) or (4560 <= 2694)) then
																	if (v10.Cast(unpack(CastAbility)) or (2531 >= 3969)) then
																		return LUAOBFUSACTOR_DECRYPT_STR_0("\16\12\219\43\36\55\69\38\28\158\7\41\32\95\44\88\253\43\59\55\13\44\10\158\26\39\44\65\99\80\241\5\11\106\23\99", "\45\67\120\190\74\72\67");
																	end
																elseif (v10.Cast(CastAbility) or (738 > 2193)) then
																	return LUAOBFUSACTOR_DECRYPT_STR_0("\19\54\232\164\245\156\230\236\36\98\206\164\234\156\174\230\50\98\221\170\246\132\174\161\15\13\206\236\163\200", "\137\64\66\141\197\153\232\142");
																end
															end
															break;
														end
													end
												elseif ((4606 >= 3398) and (v106 >= 5)) then
													local v274 = 0;
													while true do
														if ((1853 > 1742) and (v274 == 0)) then
															v99 = v123();
															if (v99 or (2442 > 2564)) then
																return v99 .. LUAOBFUSACTOR_DECRYPT_STR_0("\67\152\13\137\171\74", "\232\99\176\66\198");
															end
															break;
														end
													end
												end
											end
											return;
										end
									end
								end
								if ((4374 >= 4168) and v84.TargetIsValid() and (v34 or v13:AffectingCombat())) then
									local v263 = 0;
									while true do
										if ((v263 == 0) or (4576 > 4938)) then
											if ((2930 > 649) and v82 and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\223\41\33\16", "\76\140\65\72\102\27\237\153")]:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v84.UnitHasEnrageBuff(v14)) then
												if (v26(v86.Shiv, not v92) or (1394 < 133)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\78\211\5\194\210\13", "\222\42\186\118\178\183\97");
												end
											end
											if (((v10.CombatTime() < 10) and (v10.CombatTime() > 0) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\110\228\69\142\82\251\96\139\83\239\65", "\234\61\140\36")]:CooldownUp() and (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\23\220\180\123\28\41", "\111\65\189\218\18")]:TimeSinceLastCast() > 11)) or (432 == 495)) then
												local v267 = 0;
												while true do
													if ((66 < 1456) and (v267 == 3)) then
														if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\30\162\125\172\216\58\142\125\166\212\40", "\183\77\202\28\200")]:IsCastable() and v36 and v10.Cast(v88.ShadowDance, true)) or (878 >= 3222)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\56\35\140\6\18\33\201\59\31\50\141\7\0\23\136\6\20\54", "\104\119\83\233");
														end
														break;
													end
													if ((v267 == 1) or (254 >= 3289)) then
														if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\16\220\117\45\222\225\1\216\117\45\212\229", "\150\67\180\20\73\177")]:IsCastable() and v13:BuffDown(v86.ShadowBlades)) or (2711 <= 705)) then
															if (v10.Cast(v86.ShadowBlades, true) or (2506 >= 3366)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\162\8\31\67\136\10\90\126\133\25\30\66\154\58\22\76\137\29\9", "\45\237\120\122");
															end
														end
														if ((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\228\224\183\62\222\227\167\34\228\252\173\62\218", "\76\183\136\194")]:IsCastable() and (v96 >= 2)) or (123 > 746)) then
															if (v10.Cast(v86.ShurikenStorm) or (4444 <= 894)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\85\246\224\54\85\93\84\73\238\240\42\89\68\17\116\166\209\55\66\65\21\126\233", "\116\26\134\133\88\48\47");
															end
														end
														v267 = 2;
													end
													if ((1376 > 583) and (2 == v267)) then
														if (((v86[LUAOBFUSACTOR_DECRYPT_STR_0("\57\205\175\235\176\112\18\192\164\225", "\18\126\161\192\132\221")]:TimeSinceLastCast() > 3) and (v96 <= 1)) or (2427 == 2455)) then
															if ((3393 >= 2729) and v10.Cast(v86.Gloomblade)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\112\56\171\10\83\77\104\137\8\89\80\37\172\8\87\91\45", "\54\63\72\206\100");
															end
														end
														if ((4175 == 4175) and v14:DebuffDown(v86.Rupture) and (v96 <= 1) and (v106 > 0)) then
															if ((4584 > 1886) and v10.Cast(v86.Rupture)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\231\73\64\116\224\105\136\107\80\106\241\110\218\92", "\27\168\57\37\26\133");
															end
														end
														v267 = 3;
													end
													if ((v267 == 0) or (1043 >= 2280)) then
														if (v13:StealthUp(true, true) or (667 < 71)) then
															if (v10.Cast(v86.Shadowstrike) or (4482 < 2793)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\108\91\30\59\14\78\239\112\120", "\207\35\43\123\85\107\60");
															end
														end
														if ((561 < 4519) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\67\179\173\232\118\124\185\175\236\93\117\171\180\226", "\25\16\202\192\138")]:IsCastable() and v13:BuffDown(v86.SymbolsofDeath)) then
															if (v10.Cast(v86.SymbolsofDeath, true) or (677 == 1434)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\210\219\168\236\172\230\189\248\180\239\171\251\241\216\162\228\141\241\252\223\165", "\148\157\171\205\130\201");
															end
														end
														v267 = 1;
													end
												end
											end
											v263 = 1;
										end
										if ((2827 == 2827) and (v263 == 2)) then
											if ((2556 == 2556) and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\42\228\75\179\63\24\230\70\148\51\26\237", "\90\121\136\34\208")]:IsCastable() and (v96 < v85.CPMaxSpend()) and v10.FilteredFightRemains(v95, ">", 6) and (v13:BuffRemains(v86.SliceandDice) < v13:GCD()) and (v106 >= 4)) then
												if (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\244\2\92\29\194\15\91\26\227\7\86\27", "\126\167\110\53")]:IsReady() or (3106 >= 4932)) then
													local v273 = 0;
													while true do
														if ((v273 == 0) or (1217 <= 503)) then
															if (v10.Cast(v86.SliceandDice) or (441 >= 4871)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\30\17\61\236\156\12\49\25\45\253\156\62\51\20\110\220\213\60\56\80\102\212\211\40\125\52\59\234\221\43\52\31\32\177", "\95\93\112\78\152\188");
															end
															if ((3751 > 731) and (v13:Power() < 20)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\241\250\138\25\237\176\213", "\178\161\149\229\117\132\222");
															end
															break;
														end
													end
												end
											end
											if (v13:StealthUp(true, true) or (2515 < 1804)) then
												local v268 = 0;
												while true do
													if ((3008 > 1924) and (v268 == 0)) then
														CastAbility = v124(true);
														if ((295 == 295) and CastAbility) then
															if ((4828 >= 1725) and (type(CastAbility) == LUAOBFUSACTOR_DECRYPT_STR_0("\156\218\223\160\164", "\67\232\187\189\204\193\118\198")) and (#CastAbility > 1)) then
																if (v10.Cast(unpack(CastAbility)) or (4201 < 2150)) then
																	return LUAOBFUSACTOR_DECRYPT_STR_0("\184\58\176\33\55\22\231\142\42\245\13\58\1\253\132\110\150\33\40\22\175\132\60\245\16\52\13\227\203\102\154\15\24\75\181\203", "\143\235\78\213\64\91\98");
																end
															elseif (v10.Cast(CastAbility) or (3076 >= 4666)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\190\92\129\232\124\162\133\77\128\169\83\183\158\92\196\230\98\246\189\71\139\229\48\254\162\103\167\160\42\246", "\214\237\40\228\137\16");
															end
														end
														v268 = 1;
													end
													if ((v268 == 1) or (2027 >= 3030)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\182\247\234\216\15\178\141\230\235\153\51\169\138\239\230\215\4", "\198\229\131\143\185\99");
													end
												end
											end
											v263 = 3;
										end
										if ((3245 <= 3566) and (v263 == 1)) then
											v99 = v127();
											if (v99 or (2627 <= 381)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\214\220\52\120\3", "\35\149\152\71\66") .. v99;
											end
											v263 = 2;
										end
										if ((283 < 4544) and (v263 == 3)) then
											if ((618 < 3820) and (v13:EnergyPredicted() >= v108)) then
												local v269 = 0;
												while true do
													if ((4287 >= 124) and (v269 == 0)) then
														v99 = v128(v108);
														if ((2569 <= 3918) and v99) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\98\152\173\114\93\152\160\51\114\168\187\41\17", "\19\49\236\200") .. v99;
														end
														break;
													end
												end
											end
											if ((v105 >= v85.CPMaxSpend()) or (v107 <= (1 + v27(v13:BuffUp(v86.TheRottenBuff)))) or (v10.BossFilteredFightRemains("<", 2) and (v105 >= 3)) or ((v96 >= (4 - v27(v86[LUAOBFUSACTOR_DECRYPT_STR_0("\205\50\247\187\194\187\234\50", "\218\158\87\150\215\132")]:IsAvailable()))) and (v105 >= 4)) or (3154 <= 2030)) then
												local v270 = 0;
												while true do
													if ((v270 == 0) or (3761 <= 682)) then
														v99 = v123();
														if ((2128 > 836) and v99) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\221\23\215\235\37\42\151\187", "\173\155\126\185\130\86\66") .. v99;
														end
														break;
													end
												end
											else
												local v271 = 0;
												while true do
													if ((v271 == 1) or (2361 <= 1063)) then
														v99 = v129(v108);
														if (v99 or (1790 >= 3221)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\151\59\189\113\128\239\110", "\228\213\78\212\29") .. v99;
														end
														break;
													end
													if ((4459 >= 3851) and (0 == v271)) then
														v99 = v128(v108);
														if (v99 or (2969 <= 1860)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\214\178\191\198\132\248\237\230\153\227\155\182\165", "\140\133\198\218\167\232") .. v99;
														end
														v271 = 1;
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
					break;
				end
				if ((v185 == 1) or (2123 == 39)) then
					v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\46\18\57\31\57\244\55", "\68\122\125\94\120\85\145")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\24\220", "\218\119\124\175\62\168\185")];
					ToggleMain = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\145\255\79\195\169\245\91", "\164\197\144\40")][LUAOBFUSACTOR_DECRYPT_STR_0("\151\255\173\140\209\179", "\214\227\144\202\235\189")];
					v100 = nil;
					v185 = 2;
				end
				if ((8 == v185) or (2132 <= 201)) then
					v99 = v85.CrimsonVial();
					if (v99 or (4338 >= 4477)) then
						return v99;
					end
					if (not v13:AffectingCombat() or (1732 >= 3545)) then
						local v243 = 0;
						while true do
							if ((1125 >= 64) and (v243 == 0)) then
								v99 = v85.Poisons();
								if (v99 or (3215 > 4005)) then
									return v99;
								end
								v243 = 1;
							end
							if ((2415 > 665) and (v243 == 1)) then
								if (v84.TargetIsValid() or (1089 > 2205)) then
									if ((v15:Exists() and v86[LUAOBFUSACTOR_DECRYPT_STR_0("\26\238\131\21\202\61\243\140\2\201\43\200\152\23\197\43", "\161\78\156\234\118")]:IsReady()) or (2146 <= 628)) then
										if (v26(v88.TricksoftheTradeFocus) or (3415 >= 4449)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\183\165\204\223\168\186\203\221\179\247\221\206\174\180\194\207\152\184\207\227\179\191\204\227\179\165\200\216\162", "\188\199\215\169");
										end
									end
								end
								break;
							end
						end
					end
					v185 = 9;
				end
				if ((v185 == 6) or (1765 > 4310)) then
					if ((906 > 200) and (v105 > v106) and (v107 > 2) and v13:AffectingCombat()) then
						if (((v106 == 2) and not v13:BuffUp(v86.EchoingReprimand3)) or ((v106 == 3) and not v13:BuffUp(v86.EchoingReprimand4)) or ((v106 == 4) and not v13:BuffUp(v86.EchoingReprimand5)) or (3072 <= 2133)) then
							local v249 = 0;
							local v250;
							while true do
								if ((904 <= 1400) and (v249 == 0)) then
									v250 = v85.TimeToSht(4);
									if ((v250 == 0) or (718 > 3863)) then
										v250 = v85.TimeToSht(5);
									end
									v249 = 1;
								end
								if ((v249 == 1) or (2483 == 2223)) then
									if ((1405 >= 829) and (v250 < (v32(v13:EnergyTimeToX(35), v13:GCDRemains()) + 0.5))) then
										v105 = v106;
									end
									break;
								end
							end
						end
					end
					if ((3341 < 3863) and v13:BuffUp(v86.ShurikenTornado, nil, true) and (v106 < v85.CPMaxSpend())) then
						local v244 = 0;
						local v245;
						while true do
							if ((3840 > 1000) and (v244 == 0)) then
								v245 = v85.TimeToNextTornado();
								if ((v245 <= v13:GCDRemains()) or (v33(v13:GCDRemains() - v245) < 0.25) or (2660 < 1908)) then
									local v264 = 0;
									local v265;
									while true do
										if ((v264 == 0) or (2288 > 2511)) then
											v265 = v96 + v27(v13:BuffUp(v86.ShadowBlades));
											v106 = v31(v106 + v265, v85.CPMaxSpend());
											v264 = 1;
										end
										if ((v264 == 1) or (3592 >= 4409)) then
											v107 = v32(v107 - v265, 0);
											if ((v105 < v85.CPMaxSpend()) or (4841 < 2991)) then
												v105 = v106;
											end
											break;
										end
									end
								end
								break;
							end
						end
					end
					v103 = (4 + (v105 * 4)) * 0.3;
					v185 = 7;
				end
				if ((v185 == 2) or (2863 <= 2540)) then
					v102 = nil;
					v101 = 0;
					v90 = (v86[LUAOBFUSACTOR_DECRYPT_STR_0("\204\166\149\116\18\178\71\53\238\150\147\105\25\184\86\47", "\92\141\197\231\27\112\211\51")]:IsAvailable() and 8) or 5;
					v185 = 3;
				end
			end
		end);
	end
	local function v131()
		v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\180\89\180\17\231\130\88\175\69\217\136\75\163\0\171\133\85\246\32\251\142\79\248\69\216\146\92\166\10\249\147\73\178\69\233\158\12\145\10\225\142\94\183", "\139\231\44\214\101"));
	end
	v10.SetAPL(261, v130, v131);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\252\255\15\70\47\131\62\17\204\234\57\109\5\179\37\26\220\251\31\16\28\164\48", "\118\185\143\102\62\112\209\81")]();

