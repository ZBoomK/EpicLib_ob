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
		if ((1 == v5) or (2522 >= 3330)) then
			return v6(...);
		end
		if ((v5 == 0) or (1710 >= 3825)) then
			v6 = v0[v4];
			if ((4734 > 3921) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\194\31\197\203\240\43\239\188\207\10\238\246\213\45\233\183\222\80\221\214\218", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\163\64\26\175", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\24\43\6", "\158\48\118\66\114")];
	local v14 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\118\216\34", "\152\38\189\86\156\32\24\133")];
	local v16 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67", "\38\156\55\199")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\155\109\121\36\31", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\52\170\221\203\132\31\36\28\179\221", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
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
	local function v60()
		local v129 = 0;
		while true do
			if ((v129 == 3) or (2910 <= 1930)) then
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\142\5\225\176\210\200\200", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\161\149\69\206\120\127\53\172\178\68\230\117\116\27\140\165", "\24\92\207\225\44\131\25")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\214\172\88\18\115\76\192", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\215\52\69\144\216\39\69\190\227\47\66\184\254\3\104", "\44\221\185\64")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\226\92\75\122\15\224\91", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\89\50\47\39\16\160\88\23\62\44\48\183\123\16\31", "\81\206\60\83\91\79")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\174\196\102\38\205\74\183", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\157\47\110\17\51\254\253\138\55\112\27\19\254\238\168\45\112\57\7\223", "\143\216\66\30\126\68\155")];
				v129 = 4;
			end
			if ((v129 == 5) or (19 > 452)) then
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\43\160\66\68\85\41\167", "\45\59\78\212\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\87\145\128\178\60\172\254\3\80\140\153\139\47\185\249\31\88\164\168\162", "\144\112\54\227\235\230\78\205")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\45\27\232\217\85\180\59", "\59\211\72\111\156\176")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\151\234\41\75\138\234\46\105\164\199", "\77\46\231\131")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\81\162\84\179\90\177\83", "\32\218\52\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\2\60\165\254\190\98\91\92\16\62\177\253\181\98\121\106", "\58\46\119\81\200\145\208\37")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\24\137\36\184\160\179\49\56", "\86\75\236\80\204\201\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\71\79\127\138\242\146\83\82\100\132\235\135\102\102\84\161", "\235\18\33\23\229\158")];
				v129 = 6;
			end
			if ((1 == v129) or (907 > 3152)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\63\200\58\226\128\32\217\26\244\149\35\195\23", "\135\225\76\173\114")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\216\17\252\108\254\190\201\31\254\125\222\157", "\150\205\189\112\144\24")] or 0;
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\17\19\214\164\110\147\196\11\48\218\162\116\181\192\10\9", "\230\180\127\103\179\214\28")] or 0;
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\5\65\164\249\218\188\189\62\74\186\242\248\164\160\5\65\186\226\220\184", "\175\204\201\113\36\214\139")] or 0;
				v129 = 2;
			end
			if ((v129 == 0) or (2505 > 4470)) then
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\235\177\218\14\224\162\221", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\59\90\10\36\93\241\87\36\76", "\152\54\72\63\88\69\62")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\193\250\72\221\202\233\79", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\77\0\1\34\236\30\81\80\2\25\40\249\27\87\80", "\114\56\62\101\73\71\141")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\236\207\208\177\231\220\215", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\227\48\190\175\240\12\226\233\37\187\169\240\37\211\235\52", "\107\178\134\81\210\198\158")] or 0;
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\10\131\251\195\205\8\178\248\222\202\0\140\223\250", "\170\163\111\226\151")] or 0;
				v129 = 1;
			end
			if ((v129 == 6) or (3711 > 4062)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\191\213\175\89\180\198\168", "\219\48\218\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\209\127\116\70\215\86\194\232\120\123\65\207\104\195\192", "\128\132\17\28\41\187\47")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\55\18\46\84\15\53\21", "\61\97\82\102\90")][LUAOBFUSACTOR_DECRYPT_STR_0("\154\39\167\78\228\88\16\29\173\41\162\68\201\112\61\45", "\105\204\78\203\43\167\55\126")];
				break;
			end
			if ((420 == 420) and (v129 == 2)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\118\173\133\33\191\109\169\148\7\165\106\188\147\59\162\116\189", "\83\205\24\217\224")] or 0;
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\225\196\230\63\207\166\118\141\230\211\203\49\203\154\78", "\30\222\146\161\162\90\174\210")] or 0;
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\51\118\216\91\82\83\19\102\255\89\79\74\8\67", "\32\56\64\19\156\58")] or 0;
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\108\69\78\220\88\181\166\38\99\121\77\251\112\136\148\2\79\83\71\228", "\107\57\54\43\157\21\230\231")];
				v129 = 3;
			end
			if ((v129 == 4) or (33 >= 3494)) then
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\205\25\223\204\173\208\242", "\129\202\168\109\171\165\195\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\89\52\202\215\18\239\33\81\54\212\238\21\229\54\127\20\252", "\134\66\56\87\184\190\116")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\52\29\175\16\229\38\38", "\85\92\81\105\219\121\139\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\186\94\65\90\205\248\182\74\64\83\217\251\148\115\97", "\191\157\211\48\37\28")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\236\26\224\8\51\209\24\231", "\90\191\127\148\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\74\134\45\30\121\139\61\56\126\129\9\52\92", "\119\24\231\78")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\40\177\94\213\78\22\145", "\113\226\77\197\42\188\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\27\6\251\182\59\26\237\165\41\19\211\150\30", "\213\90\118\148")];
				v129 = 5;
			end
		end
	end
	local v61 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\129\175\34\10\27\47\201\88\162\162\55", "\49\197\202\67\126\115\100\167")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\85\215\38\140\79", "\62\87\59\191\73\224\54")];
	local v62 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\195\7\251\221\239\41\244\192\224\10\238", "\169\135\98\154")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\121\44\91\241\42", "\168\171\23\68\52\157\83")];
	local v63 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\208\116\244\185\45\6\137\253\118\253\185", "\231\148\17\149\205\69\77")][LUAOBFUSACTOR_DECRYPT_STR_0("\181\169\207\244\91\230", "\159\224\199\167\155\55")];
	local v64 = {v62[LUAOBFUSACTOR_DECRYPT_STR_0("\214\255\59\215\227\251\61\192\199\230\38\200\251\246\30\221\239", "\178\151\147\92")]:ID(),v62[LUAOBFUSACTOR_DECRYPT_STR_0("\165\239\69\54\23\89\105\170\239\77\53\31\73\116\152", "\26\236\157\44\82\114\44")]:ID(),v62[LUAOBFUSACTOR_DECRYPT_STR_0("\28\39\212\87\37\40\244\85\35\35\212\79\47\42\247\87\37\33\209", "\59\74\78\181")]:ID()};
	local v65 = v14:GetEquipment();
	local v66 = (v65[13] and v19(v65[13])) or v19(0);
	local v67 = (v65[14] and v19(v65[14])) or v19(0);
	local v68;
	local v69;
	local v70 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\6\222\87\87\188\43\194", "\211\69\177\58\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\146\243\124\231\240\196\185\224", "\171\215\133\25\149\137")];
	local v71;
	local v72;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78;
	local v79;
	local v80, v81;
	local v82, v83;
	local v84, v85;
	local v86 = ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\194\196\51\237\230\62\251\113\233\201\54\245\248\35", "\34\129\168\82\154\143\80\156")]:IsAvailable()) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\166\190\50\28\65\64\142\182\186\50\15\71\89\154", "\233\229\210\83\107\40\46")]) or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\242\65\61\195\23\198\71\1\194\23\200\73\55", "\101\161\34\82\182")];
	local v87 = ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\204\8\95\247\215\231", "\78\136\109\57\158\187\130\226")]:IsAvailable()) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\26\58\255\248\50\58", "\145\94\95\153")]) or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\217\200\21\193\70\150\243\201\48\208\77\182\228", "\215\157\173\116\181\46")];
	local v88 = ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\17\177\141\251\214\48", "\186\85\212\235\146")]:IsAvailable()) and v63[LUAOBFUSACTOR_DECRYPT_STR_0("\230\132\16\247\53\235\104\206\128\15\251\43", "\56\162\225\118\158\89\142")]) or v63[LUAOBFUSACTOR_DECRYPT_STR_0("\120\4\228\159\46\217\69\0\210", "\184\60\101\160\207\66")];
	local v89;
	local v90 = 11111;
	local v91 = 11111;
	local v92 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\22\138\115\169\61\182\125\190\61\135", "\220\81\226\28")];
	local v93, v94;
	local v95, v96;
	local v97;
	local v98 = {{v61[LUAOBFUSACTOR_DECRYPT_STR_0("\50\198\146\243\243\223\26\212\150\254", "\167\115\181\226\155\138")],LUAOBFUSACTOR_DECRYPT_STR_0("\193\35\244\72\59\80\213\242\42\254\68\114\112\210\231\98\175\117\117\101\195\240\48\242\76\111\56", "\166\130\66\135\60\27\17"),function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v130 = 0;
		while true do
			if ((v130 == 0) or (1267 == 4744)) then
				v65 = v14:GetEquipment();
				v66 = (v65[13] and v19(v65[13])) or v19(0);
				v130 = 1;
			end
			if ((2428 < 3778) and (v130 == 1)) then
				v67 = (v65[14] and v19(v65[14])) or v19(0);
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\116\102\239\76\21\118\117\235\68\5\109\122\227\80\30\112\117\237\93\17\106\109\235\81", "\80\36\42\174\21"));
	v10:RegisterForEvent(function()
		local v131 = 0;
		while true do
			if ((v131 == 0) or (2946 <= 1596)) then
				v90 = 11111;
				v91 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\126\60\22\67\107\34\8\72\107\55\18\84\113\53\25\91\108\60\18\94", "\26\46\112\87"));
	v10:RegisterForEvent(function()
		local v132 = 0;
		while true do
			if ((4433 > 3127) and (v132 == 0)) then
				v86 = ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\154\47\170\99\182\177\66\135\177\34\175\123\168\172", "\212\217\67\203\20\223\223\37")]:IsAvailable()) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\153\129\169\197\179\131\175\225\178\140\172\221\173\158", "\178\218\237\200")]) or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\133\182\233\197\164\178\227\227\162\167\239\219\179", "\176\214\213\134")];
				v88 = ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\208\168\176\221\164\83", "\57\148\205\214\180\200\54")]:IsAvailable()) and v63[LUAOBFUSACTOR_DECRYPT_STR_0("\54\248\51\61\122\23\205\57\53\111\23\239", "\22\114\157\85\84")]) or v63[LUAOBFUSACTOR_DECRYPT_STR_0("\224\202\55\244\81\247\177\193\217", "\200\164\171\115\164\61\150")];
				v132 = 1;
			end
			if ((4300 >= 2733) and (v132 == 1)) then
				v87 = ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\154\241\5\76\143\187", "\227\222\148\99\37")]:IsAvailable()) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\23\87\84\255\245\54", "\153\83\50\50\150")]) or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\121\115\114\8\123\138\67\89\82\118\31\114\178", "\45\61\22\19\124\19\203")];
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\242\34\40\217\46\67\134\226\58\44\219\37\85\157", "\217\161\114\109\149\98\16"), LUAOBFUSACTOR_DECRYPT_STR_0("\62\5\25\78\146\81\54\31\11\76\153\88\62\31\17\82\131\64\51\2", "\20\114\64\88\28\220"));
	local function v99()
		return (v14:HealthPercentage() < v43) or ((v14:HealthPercentage() < v44) and v14:BuffUp(v61.DeathStrikeBuff));
	end
	local function v100(v133)
		local v134 = 0;
		local v135;
		while true do
			if ((4829 == 4829) and (1 == v134)) then
				return v135;
			end
			if ((1683 <= 4726) and (0 == v134)) then
				v135 = 0;
				for v189, v190 in pairs(v133) do
					if ((4835 >= 3669) and v190:DebuffDown(v61.VirulentPlagueDebuff)) then
						v135 = v135 + 1;
					end
				end
				v134 = 1;
			end
		end
	end
	local function v101(v136)
		local v137 = 0;
		local v138;
		while true do
			if ((2851 > 1859) and (v137 == 0)) then
				v138 = {};
				for v191 in pairs(v136) do
					if ((3848 > 2323) and not v13:IsInBossList(v136[v191]['UnitNPCID'])) then
						v30(v138, v136[v191]);
					end
				end
				v137 = 1;
			end
			if ((2836 > 469) and (v137 == 1)) then
				return v10.FightRemains(v138);
			end
		end
	end
	local function v102(v139)
		return (v139:DebuffStack(v61.FesteringWoundDebuff));
	end
	local function v103(v140)
		return (v140:DebuffRemains(v61.SoulReaper));
	end
	local function v104(v141)
		return (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\19\20\192\167\236\217\179\54\50\221\166\253\195", "\221\81\97\178\212\152\176")]:IsAvailable() and v141:DebuffUp(v61.FesteringWoundDebuff) and ((v14:BuffDown(v61.DeathAndDecayBuff) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\233\226\28\239\18\236\233\25\223\31\206\230\4", "\122\173\135\125\155")]:CooldownDown() and (v14:Rune() < 3)) or (v14:BuffUp(v61.DeathAndDecayBuff) and (v14:Rune() == 0)))) or (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\166\212\18\170\43\56\198\131\242\15\171\58\34", "\168\228\161\96\217\95\81")]:IsAvailable() and (v141:DebuffStack(v61.FesteringWoundDebuff) >= 4)) or (v14:HasTier(31, 2) and v141:DebuffUp(v61.FesteringWoundDebuff));
	end
	local function v105(v142)
		return v142:DebuffStack(v61.FesteringWoundDebuff) >= 4;
	end
	local function v106(v143)
		return v143:DebuffStack(v61.FesteringWoundDebuff) < 4;
	end
	local function v107(v144)
		return v144:DebuffStack(v61.FesteringWoundDebuff) < 4;
	end
	local function v108(v145)
		return v145:DebuffStack(v61.FesteringWoundDebuff) >= 4;
	end
	local function v109(v146)
		return ((v146:TimeToX(35) < 5) or (v146:HealthPercentage() <= 35)) and (v146:TimeToDie() > (v146:DebuffRemains(v61.SoulReaper) + 5));
	end
	local function v110(v147)
		return (v147:DebuffStack(v61.FesteringWoundDebuff) <= 2) or v15:BuffUp(v61.DarkTransformation);
	end
	local function v111(v148)
		return (v148:DebuffStack(v61.FesteringWoundDebuff) >= 4) and (v87:CooldownRemains() < 3);
	end
	local function v112(v149)
		return v149:DebuffStack(v61.FesteringWoundDebuff) >= 1;
	end
	local function v113(v150)
		return (v150:TimeToDie() > v150:DebuffRemains(v61.VirulentPlagueDebuff)) and (v150:DebuffRefreshable(v61.VirulentPlagueDebuff) or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\232\196\62\89\61\68\207\195\47\85\33", "\55\187\177\78\60\79")]:IsAvailable() and (v150:DebuffRefreshable(v61.FrostFeverDebuff) or v150:DebuffRefreshable(v61.BloodPlagueDebuff)))) and (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\24\192\87\228\74\214\162\33\199\88\227\82", "\224\77\174\63\139\38\175")]:IsAvailable() or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\177\79\80\33\136\88\122\34\141\70\80\58", "\78\228\33\56")]:IsAvailable() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\251\112\186\12\137\215\92\190\10\130\198\106", "\229\174\30\210\99")]:CooldownRemains() > (15 / ((v21(v61[LUAOBFUSACTOR_DECRYPT_STR_0("\40\248\150\84\255\46\45\9\236\143\95", "\89\123\141\230\49\141\93")]:IsAvailable()) * 3) + (v21(v61[LUAOBFUSACTOR_DECRYPT_STR_0("\195\125\247\11\5\79\241\99\255\2\23\79\225", "\42\147\17\150\108\112")]:IsAvailable()) * 2) + (v21(v61[LUAOBFUSACTOR_DECRYPT_STR_0("\42\164\34\113\193\237\25\163\63", "\136\111\198\77\31\135")]:IsAvailable()) * 2))))));
	end
	local function v114()
		local v151 = 0;
		while true do
			if ((v151 == 0) or (2096 <= 540)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\48\8\174\69\184\192\18\168\6", "\201\98\105\199\54\221\132\119")]:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive() or not v15:IsActive())) or (3183 < 2645)) then
					if ((3230 <= 3760) and v10.Press(v61.RaiseDead, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\13\138\50\7\10\168\188\13\135\97\18\39\169\186\3\142\35\3\33\236\235\76\135\40\17\37\160\184\21\144\53\27\57\169", "\204\217\108\227\65\98\85");
					end
				end
				if ((3828 == 3828) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\127\209\248\252\35\198\74\203\240\193\41\193\90", "\160\62\163\149\133\76")]:IsReady() and v28) then
					if ((554 == 554) and v10.Press(v61.ArmyoftheDead, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\178\0\54\252\217\166\50\59\203\211\159\9\42\194\210\224\29\61\198\213\175\0\45\194\194\224\89", "\163\182\192\109\79");
					end
				end
				v151 = 1;
			end
			if ((v151 == 1) or (2563 == 172)) then
				if ((3889 >= 131) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\27\51\20\194\231\49\39\11", "\149\84\70\96\160")]:IsReady()) then
					if (v10.Press(v61.Outbreak, nil, nil, not v16:IsSpellInRange(v61.Outbreak)) or (492 == 4578)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\19\25\239\42\3\12\230\120\22\31\232\59\9\0\239\57\18\77\187", "\141\88\102\109");
					end
				end
				if (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\149\86\217\100\31\47\92\207\180\96\222\98\19\54\80", "\161\211\51\170\16\122\93\53")]:IsReady() or (4112 < 1816)) then
					if ((4525 >= 1223) and v10.Press(v61.FesteringStrike, nil, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\171\161\60\254\188\187\38\252\145\161\60\233\167\185\45\187\190\160\45\248\161\191\42\250\186\242\112", "\72\155\206\210");
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v152 = 0;
		while true do
			if ((1090 <= 4827) and (1 == v152)) then
				v68 = v70.HandleBottomTrinket(v64, v28, 40, nil);
				if (v68 or (239 > 1345)) then
					return v68;
				end
				break;
			end
			if ((0 == v152) or (3710 >= 3738)) then
				v68 = v70.HandleTopTrinket(v64, v28, 40, nil);
				if (v68 or (3838 < 2061)) then
					return v68;
				end
				v152 = 1;
			end
		end
	end
	local function v116()
		local v153 = 0;
		while true do
			if ((v153 == 0) or (690 > 1172)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\99\106\93\10\54\75\115\87", "\83\38\26\52\110")]:IsReady() and (not v77 or (v91 < 10))) or (1592 > 2599)) then
					if ((3574 <= 4397) and v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\93\7\46\66\93\26\46\69\24\22\40\67\24\69", "\38\56\119\71");
					end
				end
				if ((3135 > 1330) and v86:IsReady() and v76) then
					if (v70.CastTargetIf(v86, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\254\238\64", "\54\147\143\56\182\69"), v102, nil, not v16:IsSpellInRange(v86)) or (3900 <= 3641)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\193\142\234\71\219\233\146\239\76\209\210\132\237\9\222\217\132\191\29", "\191\182\225\159\41");
					end
				end
				v153 = 1;
			end
			if ((1724 == 1724) and (1 == v153)) then
				if ((455 <= 1282) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\13\23\59\65\142\149\203\37\21\27\65\153\142\201\46", "\162\75\114\72\53\235\231")]:IsReady() and not v76) then
					if ((4606 < 4876) and v70.CastTargetIf(v61.FesteringStrike, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\129\61\92", "\98\236\92\36\130\51"), v102, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\162\28\31\174\64\186\188\62\163\38\31\174\87\161\190\53\228\24\3\191\5\254", "\80\196\121\108\218\37\200\213");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\36\118\3\107\67\45\133\9\127", "\234\96\19\98\31\43\110")]:IsReady() and not v77 and not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\35\15\91\195\169\127\130\5", "\235\102\127\50\167\204\18")]:IsAvailable()) or (1442 > 2640)) then
					if ((136 < 3668) and v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\164\244\55\76\17\83\174\252\47\4\47\95\164\181\123", "\78\48\193\149\67\36");
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v154 = 0;
		while true do
			if ((v154 == 2) or (1784 > 4781)) then
				if ((4585 > 3298) and v86:IsReady()) then
					if (v10.Press(v86, nil, nil, not v16:IsSpellInRange(v86)) or (1664 > 1698)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\107\248\60\56\55\155\111\231\44\56\55\161\110\183\40\57\54\155\126\226\59\37\39\228\45\167", "\196\28\151\73\86\83");
					end
				end
				break;
			end
			if ((0 == v154) or (3427 < 2849)) then
				if ((3616 <= 4429) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\21\14\137\28\68\61\23\131", "\33\80\126\224\120")]:IsReady() and (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\206\189\17\215\72\229\166\4\247\83\254\173\16", "\60\140\200\99\164")]:IsAvailable() or (v14:Rune() < 1) or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\165\225\22\53\182\142\250\3\21\173\149\241\23", "\194\231\148\100\70")]:IsAvailable() and (v89 == 0))) and not v77 and ((v94 >= 6) or (v14:RunicPowerDeficit() < 30) or (v14:BuffStack(v61.FestermightBuff) == 20))) then
					if ((3988 >= 66) and v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\92\200\167\243\197\79\79\129\162\249\205\121\78\212\177\229\220\6\30", "\168\38\44\161\195\150");
					end
				end
				if (v86:IsReady() or (862 > 4644)) then
					if ((1221 == 1221) and v70.CastTargetIf(v86, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\141\253\154", "\118\224\156\226\22\80\136\214"), v102, v112, not v16:IsSpellInRange(v86))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\225\76\142\70\209\74\144\71\224\93\133\80\174\88\143\71\209\91\149\80\253\77\192\22", "\224\34\142\57");
					end
				end
				v154 = 1;
			end
			if ((v154 == 1) or (45 > 1271)) then
				if ((3877 > 1530) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\251\183\204\217\118\252\84\13", "\110\190\199\165\189\19\145\61")]:IsReady() and (not v77 or (v91 < 10))) then
					if (v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(30)) or (4798 == 1255)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\223\251\126\236\142\202\211\232\55\233\132\194\229\233\98\250\152\211\154\189", "\167\186\139\23\136\235");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\62\176\137\25\18\150\135\4\22", "\109\122\213\232")]:IsReady() and not v77 and not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\203\231\171\52\235\250\171\51", "\80\142\151\194")]:IsAvailable()) or (2541 > 2860)) then
					if (v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or (2902 > 3629)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\195\118\88\11\249\116\67\10\202\55\77\12\195\72\78\22\212\100\88\67\158", "\44\99\166\23");
					end
				end
				v154 = 2;
			end
		end
	end
	local function v118()
		local v155 = 0;
		while true do
			if ((427 < 3468) and (v155 == 2)) then
				if ((4190 >= 2804) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\3\71\251\31\127\215\23\90\224\17\102\194\34", "\174\86\41\147\112\19")]:IsCastable()) then
					if ((2086 == 2086) and v70.CastTargetIf(v61.UnholyAssault, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\86\9\131", "\203\59\96\237\107\69\111\113"), v102, v110, v57)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\24\164\238\61\233\232\37\5\191\224\36\252\195\100\23\163\228\14\243\216\43\26\168\238\38\254\196\100\71\252", "\183\68\118\204\129\81\144");
					end
				end
				if ((4148 > 2733) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\60\172\121\247\14\166\11\172\116", "\226\110\205\16\132\107")]:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) then
					if ((3054 >= 1605) and v10.Press(v61.RaiseDead, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\194\233\202\68\212\199\229\216\69\171\194\239\220\126\232\204\239\213\69\228\212\238\202\1\186\145\160\221\72\248\211\236\216\88\248\215\249\213\68", "\33\139\163\128\185");
					end
				end
				v155 = 3;
			end
			if ((1044 < 1519) and (v155 == 4)) then
				if ((1707 <= 4200) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\124\84\119\26\70\83\125\11\70\84\120\56\78\86\96", "\104\47\53\20")]:IsReady() and ((v15:BuffDown(v61.DarkTransformation) and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\135\77\147\23\136\29\162\66\146\26\179\29\174\77\149\21\179\1", "\111\195\44\225\124\220")]:CooldownRemains() > 6)) or (v91 < v14:GCD()))) then
					if ((580 == 580) and v10.Press(v61.SacrificialPact, v50)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\203\71\3\97\162\173\209\69\9\114\167\148\200\71\3\103\235\170\215\67\63\112\164\164\212\66\15\100\165\184\152\23\88", "\203\184\38\96\19\203");
					end
				end
				break;
			end
			if ((601 <= 999) and (v155 == 1)) then
				if ((3970 == 3970) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\24\170\67\21\201\236\15\45\161\67\22\236\235\3\59", "\110\89\200\44\120\160\130")]:IsCastable() and ((v14:Rune() < 2) or (v89 > 10) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\141\198\88\82\70\88\54\68\172\203\95", "\45\203\163\43\38\35\42\91")]:IsAvailable() or (v14:BuffUp(v61.FestermightBuff) and (v14:BuffRemains(v61.FestermightBuff) < 12)))) then
					if (v10.Press(v61.AbominationLimb, nil, not v16:IsInRange(20)) or (98 == 208)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\135\211\46\142\167\85\198\140\211\45\184\165\93\223\135\156\34\136\172\107\209\138\211\47\131\166\67\220\150\156\117", "\52\178\229\188\67\231\201");
					end
				end
				if ((2006 <= 3914) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\0\81\95\7\246\80\58\49\82\85", "\67\65\33\48\100\151\60")]:IsReady()) then
					if (v70.CastTargetIf(v61.Apocalypse, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\210\238\160", "\147\191\135\206\184"), v102, v104) or (3101 <= 2971)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\133\56\169\194\217\95\171\148\59\163\129\217\92\183\187\43\169\206\212\87\189\147\38\181\129\128", "\210\228\72\198\161\184\51");
					end
				end
				v155 = 2;
			end
			if ((0 == v155) or (2073 <= 671)) then
				if ((3305 > 95) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\197\10\37\21\161\87\22\98\242\4\32\31\140", "\22\147\99\73\112\226\56\120")]:IsReady() and (v87:CooldownRemains() < 3)) then
					if ((2727 == 2727) and v70.CastTargetIf(v61.VileContagion, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\181\116\250", "\237\216\21\130\149"), v102, v111, not v16:IsSpellInRange(v61.VileContagion))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\148\71\83\90\143\202\81\140\90\94\88\185\198\80\194\79\80\90\143\202\81\141\66\91\80\167\199\77\194\28", "\62\226\46\63\63\208\169");
					end
				end
				if (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\214\12\88\142\16\3\8\95\247\30\90\154\19\8", "\62\133\121\53\227\127\109\79")]:IsReady() or (2970 >= 4072)) then
					if ((3881 > 814) and v10.Press(v61.SummonGargoyle, v56)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\1\63\248\217\160\157\23\21\32\242\217\183\174\21\84\51\250\211\145\161\31\27\62\241\217\185\172\3\84\102", "\194\112\116\82\149\182\206");
					end
				end
				v155 = 1;
			end
			if ((v155 == 3) or (4932 < 4868)) then
				if ((3667 <= 4802) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\115\89\22\213\99\74\5\208\68\94\11\204\90\89\16\215\88\86", "\190\55\56\100")]:IsCastable() and (((v87:CooldownRemains() < 10) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\127\161\58\27\16\247\246\82\140\48\31\4\240", "\147\54\207\92\126\115\131")]:IsAvailable() and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\43\52\38\105\8\108\4\63\50\74\2\107\3\53\17\120\15\107\11\55", "\30\109\81\85\29\109")]:AuraActiveCount() < v96) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\201\120\88\179\21\209\242\235\112\83\191\57\208", "\156\159\17\52\214\86\190")]:IsAvailable())) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\135\225\187\185\173\251\184\184\141\227\188\171\189", "\220\206\143\221")]:IsAvailable())) then
					if ((1260 >= 858) and v10.Press(v61.DarkTransformation, v54)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\130\124\63\28\231\216\192\135\115\62\17\215\222\223\135\105\36\24\214\140\211\137\120\18\20\215\195\222\130\114\58\25\203\140\131\210", "\178\230\29\77\119\184\172");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\208\179\26\20\96\253\231\140\31\21\114\207\240\191\26\20\121", "\152\149\222\106\123\23")]:IsCastable() and (v15:BuffUp(v61.DarkTransformation))) or (3911 == 4700)) then
					if ((3000 < 4194) and v10.Press(v61.EmpowerRuneWeapon, v49)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\43\230\76\162\216\52\201\81\160\211\35\201\84\176\220\54\249\77\245\220\41\243\124\182\210\41\250\71\186\202\40\229\3\228\139", "\213\189\70\150\35");
					end
				end
				v155 = 4;
			end
		end
	end
	local function v119()
		local v156 = 0;
		while true do
			if ((651 < 4442) and (v156 == 0)) then
				if ((v87:IsReady() and (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\27\102\107\82\218\48\125\126\114\193\43\118\106", "\174\89\19\25\33")]:IsAvailable() or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\9\23\65\90\242\149\2\33\21\101\65\226\137\15\11\23\80\91\241\129", "\107\79\114\50\46\151\231")]:AuraActiveCount() == v96) or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\31\163\166\61\143\43\190\206\62\145\186\60\132\61\147\197\59\179\179\47", "\160\89\198\213\73\234\89\215")]:AuraActiveCount() >= 8))) or (195 >= 1804)) then
					if (v10.Press(v88, v48) or (1382 > 2216)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\127\173\193\193\70\117\244\255\202\77\78\167\251\209\93\97\244\172", "\165\40\17\212\158");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\195\220\27\39\35\247\208\6\52\21\241\203\1\56\35", "\70\133\185\104\83")]:IsReady() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\34\64\87\62\204\22\76\74\45\254\11\80\74\46\237\1\71\81\44\207", "\169\100\37\36\74")]:AuraActiveCount() < v96) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\34\146\176\67\20\142\172\87\51\136\176\85\19", "\48\96\231\194")]:IsAvailable()) or (2861 == 2459)) then
					if ((1903 < 4021) and v70.CastTargetIf(v61.FesteringStrike, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\197\83\0", "\227\168\58\110\77\121\184\207"), v102, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\125\57\172\84\180\201\120\171\124\3\172\84\163\210\122\160\59\61\176\69\142\200\116\177\110\44\255\20", "\197\27\92\223\32\209\187\17");
					end
				end
				v156 = 1;
			end
			if ((v156 == 2) or (2270 >= 4130)) then
				if ((2593 <= 3958) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\226\42\50\48\10\214\38\47\35\60\208\61\40\47\10", "\111\164\79\65\68")]:IsReady() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\231\201\140\221\47\230\223\201\144\219", "\138\166\185\227\190\78")]:CooldownRemains() < v74)) then
					if ((1176 == 1176) and v70.CastTargetIf(v61.FesteringStrike, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\198\117\221", "\121\171\20\165\87\50\67"), v102, v106)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\61\170\34\188\16\207\54\190\9\170\22\212\49\178\51\249\3\201\61\134\37\188\22\211\40\249\103\233", "\98\166\88\217\86\217");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\210\243\120\21\142\255\249\255\117", "\188\150\150\25\97\230")]:IsReady() and not v77 and not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\255\153\86\6\9\224\211\138", "\141\186\233\63\98\108")]:IsAvailable()) or (3062 == 1818)) then
					if (v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or (3717 < 3149)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\239\45\162\45\206\233\35\191\41\177\235\35\179\26\226\239\56\163\53\177\187\126", "\69\145\138\76\214");
					end
				end
				break;
			end
			if ((3195 < 3730) and (v156 == 1)) then
				if ((2797 <= 3980) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\38\79\202\255\6\82\202\248", "\155\99\63\163")]:IsReady() and (not v77 or (v91 < 10))) then
					if ((1944 <= 2368) and v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\193\168\137\188\137\139\210\225\140\182\129\189\194\164\153\172\148\194\135", "\228\226\177\193\237\217");
					end
				end
				if ((1709 < 4248) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\18\181\48\242\49\162\42\232\51\131\55\244\61\187\38", "\134\84\208\67")]:IsReady() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\53\169\149\72\22\190\143\82\20\155\137\73\29\168\162\89\17\185\128\90", "\60\115\204\230")]:AuraActiveCount() < v96)) then
					if (v70.CastTargetIf(v61.FesteringStrike, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\234\51\229", "\16\135\90\139"), v102, nil) or (3970 == 3202)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\113\21\39\75\70\113\90\115\57\32\90\70\113\95\113\70\50\65\81\71\71\113\18\38\94\20\32", "\24\52\20\102\83\46\52");
					end
				end
				v156 = 2;
			end
		end
	end
	local function v120()
		local v157 = 0;
		while true do
			if ((2 == v157) or (3918 >= 4397)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\8\57\181\211\97\170\197\180\56\58\160\235\115\174\199\137\35", "\230\77\84\197\188\22\207\183")]:IsCastable() and ((v78 and ((v84 and (v85 <= 23)) or (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\202\1\203\241\131\175\215\52\235\19\201\229\128\164", "\85\153\116\166\156\236\193\144")]:IsAvailable() and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\133\242\64\170\235\6\176\232\72\151\229\13\170\229\73", "\96\196\128\45\211\132")]:IsAvailable() and v82 and v80) or (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\6\152\118\82\221\161\147\217\39\138\116\70\222\170", "\184\85\237\27\63\178\207\212")]:IsAvailable() and not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\41\75\4\70\7\95\29\87\13\125\8\82\6\92\13", "\63\104\57\105")]:IsAvailable() and v15:BuffUp(v61.DarkTransformation)) or (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\56\146\169\73\4\137\131\69\25\128\171\93\7\130", "\36\107\231\196")]:IsAvailable() and v15:BuffUp(v61.DarkTransformation)))) or (v91 <= 21))) or (780 == 3185)) then
					if (v10.Press(v61.EmpowerRuneWeapon, v49) or (3202 >= 4075)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\88\184\178\136\74\176\176\184\79\160\172\130\98\162\167\134\77\186\172\199\94\186\173\139\89\186\181\137\78\245\243\215", "\231\61\213\194");
					end
				end
				if ((64 == 64) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\40\175\50\126\0\163\60\103\0\162\51\95\0\160\63", "\19\105\205\93")]:IsCastable() and (v14:Rune() < 3) and v78) then
					if ((2202 >= 694) and v10.Press(v61.AbominationLimb, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\10\209\140\54\167\9\202\136\48\167\55\210\136\50\171\72\221\142\48\165\12\209\150\49\186\72\143\211", "\95\201\104\190\225");
					end
				end
				v157 = 3;
			end
			if ((3706 <= 3900) and (v157 == 3)) then
				if ((2890 > 2617) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\154\197\201\193\163\210\224\221\188\202\212\194\187", "\174\207\171\161")]:IsReady() and v78) then
					if (v70.CastTargetIf(v61.UnholyAssault, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\224\247\3", "\183\141\158\109\147\152"), v102, nil, v57) or (3355 > 4385)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\7\238\3\32\16\217\13\63\26\231\25\32\29\166\15\35\6\234\8\35\30\232\31\108\88\178", "\108\76\105\134");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\216\202\164\237\252\238\196\161\228\220", "\174\139\165\209\129")]:IsReady() and (v94 == 1) and ((v16:TimeToX(35) < 5) or (v16:HealthPercentage() <= 35)) and (v16:TimeToDie() > 5)) or (3067 <= 2195)) then
					if ((3025 >= 2813) and v10.Press(v61.SoulReaper, nil, nil, not v16:IsSpellInRange(v61.SoulReaper))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\176\188\247\205\249\17\117\121\179\182\240\129\197\12\127\116\167\188\245\207\213\67\33\46", "\24\195\211\130\161\166\99\16");
					end
				end
				v157 = 4;
			end
			if ((2412 >= 356) and (v157 == 1)) then
				if ((2070 > 1171) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\32\238\182\200\5\72\5\225\183\197\62\72\9\238\176\202\62\84", "\58\100\143\196\163\81")]:IsCastable() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\59\82\44\160\62\69\252\30\9\71", "\110\122\34\67\195\95\41\133")]:CooldownRemains() < 5)) then
					if (v10.Press(v61.DarkTransformation, v54) or (4108 < 3934)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\113\176\73\65\233\97\163\90\68\197\115\190\73\71\215\97\184\84\68\150\118\190\84\70\210\122\166\85\89\150\35", "\182\21\209\59\42");
					end
				end
				if ((3499 >= 3439) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\150\71\202\30\32\178\174\71\214\24", "\222\215\55\165\125\65")]:IsReady() and v78) then
					if ((876 < 3303) and v70.CastTargetIf(v61.Apocalypse, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\33\208\222", "\42\76\177\166\122\146\161\141"), v102, v105, v53)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\164\154\10\205\120\122\188\154\22\203\57\117\170\133\9\202\118\97\171\153\69\150", "\22\197\234\101\174\25");
					end
				end
				v157 = 2;
			end
			if ((2922 <= 3562) and (v157 == 4)) then
				if ((2619 >= 1322) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\117\12\252\32\97\19\71\19\236\62", "\118\38\99\137\76\51")]:IsReady() and (v94 >= 2)) then
					if ((4133 >= 2404) and v70.CastTargetIf(v61.SoulReaper, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\240\47\11", "\64\157\70\101\114\105"), v103, v109, not v16:IsSpellInRange(v61.SoulReaper))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\167\178\239\47\82\173\166\243\21\82\232\164\236\31\76\172\168\244\30\83\232\246\187", "\112\32\200\199\131");
					end
				end
				break;
			end
			if ((v157 == 0) or (1433 == 2686)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\67\218\132\132\176\24\87\206\155\142\176\15\124\202", "\118\16\175\233\233\223")]:IsCastable() and (v14:BuffUp(v61.CommanderoftheDeadBuff) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\168\139\56\182\239\133\121\142\150\58\189\250\131\120\175\129\52\191", "\29\235\228\85\219\142\235")]:IsAvailable())) or (4123 == 4457)) then
					if (v10.Press(v61.SummonGargoyle, v56) or (3972 <= 205)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\193\183\208\120\64\24\85\60\198\189\210\110\66\34\18\62\219\181\209\115\65\48\92\46\148\232", "\50\93\180\218\189\23\46\71");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\236\165\82\95\65\248\77\223\160", "\40\190\196\59\44\36\188")]:IsCastable() and (v15:IsDeadOrGhost() or not v15:IsActive())) or (3766 < 1004)) then
					if ((1784 < 2184) and v10.Press(v61.RaiseDead, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\68\213\167\255\66\9\57\68\216\244\249\114\2\48\65\211\163\244\110\77\104\5\216\189\233\109\1\61\92\207\160\227\113\8", "\109\92\37\188\212\154\29");
					end
				end
				v157 = 1;
			end
		end
	end
	local function v121()
		local v158 = 0;
		while true do
			if ((v158 == 3) or (1649 > 4231)) then
				if ((3193 == 3193) and v87:IsReady() and v14:BuffDown(v61.DeathAndDecayBuff) and (v89 > 0)) then
					if (v10.Press(v88, v48) or (3495 > 4306)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\69\39\234\85\31\248\110\76\63\199\86\46\239\43\95\43\197\17\64\164", "\156\78\43\94\181\49\113");
					end
				end
				if ((4001 > 3798) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\84\237\215\183\14\81\112\124\239\247\183\25\74\114\119", "\25\18\136\164\195\107\35")]:IsReady() and ((v89 == 0) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\201\61\166\76\115\176\216\168\251\40", "\216\136\77\201\47\18\220\161")]:IsAvailable() or ((v14:RunicPower() < 40) and not v84))) then
					if (v10.Press(v61.FesteringStrike, nil, nil) or (4688 <= 4499)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\233\56\206\13\206\139\35\235\20\201\28\206\139\38\233\107\221\9\206\133\18\255\46\206\29\204\194\127\188", "\226\77\140\75\186\104\188");
					end
				end
				v158 = 4;
			end
			if ((2 == v158) or (1567 <= 319)) then
				if ((v28 and v84 and (v85 <= 23)) or (4583 == 3761)) then
					local v192 = 0;
					while true do
						if ((3454 > 1580) and (0 == v192)) then
							if (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\192\176\71\63\216\49\247\143\66\62\202\3\224\188\71\63\193", "\84\133\221\55\80\175")]:IsCastable() or (1607 == 20)) then
								if (v10.Press(v61.EmpowerRuneWeapon, v49) or (962 >= 4666)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\184\234\52\169\208\89\175\216\54\179\201\89\130\240\33\167\215\83\179\167\35\167\213\91\130\244\33\178\210\76\253\182\116", "\60\221\135\68\198\167");
								end
							end
							if (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\219\179\240\140\78\192\207\174\235\130\87\213\250", "\185\142\221\152\227\34")]:IsCastable() or (1896 == 1708)) then
								if ((3985 >= 1284) and v10.Press(v61.UnholyAssault, v57, nil)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\77\203\95\245\79\42\200\89\214\68\251\86\63\227\24\194\86\232\68\12\228\93\209\66\234\3\98\165", "\151\56\165\55\154\35\83");
								end
							end
							break;
						end
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\132\66\23\229\148\81\4\224\179\69\10\252\173\66\17\231\175\77", "\142\192\35\101")]:IsCastable() and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\245\122\36\174\230\130\168\19\196\122\47\183\239\137\136\19\215\113", "\118\182\21\73\195\135\236\204")]:IsAvailable() and (v14:RunicPower() > 40)) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\43\51\23\77\5\3\249\13\46\21\70\16\5\248\44\57\27\68", "\157\104\92\122\32\100\109")]:IsAvailable())) or (1987 == 545)) then
					if (v10.Press(v61.DarkTransformation, v54) or (4896 < 1261)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\167\167\221\193\2\51\159\170\173\181\201\197\47\42\140\191\170\169\193\138\58\38\159\172\156\181\202\222\40\55\205\250\245", "\203\195\198\175\170\93\71\237");
					end
				end
				v158 = 3;
			end
			if ((23 < 3610) and (0 == v158)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\13\64\83\187\194\167\59\60\67\89", "\66\76\48\60\216\163\203")]:IsReady() and (v89 >= 4) and ((v14:BuffUp(v61.CommanderoftheDeadBuff) and (v85 < 23)) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\153\137\116\254\94\192\32\191\148\118\245\75\198\33\158\131\120\247", "\68\218\230\25\147\63\174")]:IsAvailable())) or (3911 < 2578)) then
					if (v10.Press(v61.Apocalypse, v53, nil) or (4238 < 87)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\172\58\92\79\183\161\51\67\95\179\237\45\82\94\177\146\57\86\88\163\189\106\1", "\214\205\74\51\44");
					end
				end
				if ((2538 == 2538) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\219\94\239\229\120\252\88\234\249\83\255\77\230", "\23\154\44\130\156")]:IsReady() and v28 and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\50\169\160\163\55\29\21\163\191\161\48\7\25\163\137\171\55\23", "\115\113\198\205\206\86")]:IsAvailable() and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\160\86\236\81\176\69\255\84\151\81\241\72\137\86\234\83\139\89", "\58\228\55\158")]:CooldownRemains() < 3) or v14:BuffUp(v61.CommanderoftheDeadBuff))) or (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\151\134\221\35\61\163\49\177\155\223\40\40\165\48\144\140\209\42", "\85\212\233\176\78\92\205")]:IsAvailable() and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\127\86\128\237\70\65\169\241\89\89\157\238\94", "\130\42\56\232")]:IsAvailable() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\223\187\44\236\76\38\203\166\55\226\85\51\254", "\95\138\213\68\131\32")]:CooldownRemains() < 10)) or (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\31\38\169\76\122\51\9\178\80\119\63\36\181", "\22\74\72\193\35")]:IsAvailable() and not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\15\118\233\85\45\119\224\93\62\118\226\76\36\124\192\93\45\125", "\56\76\25\132")]:IsAvailable()))) then
					if ((4122 == 4122) and v10.Press(v61.ArmyoftheDead, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\211\166\63\240\81\199\148\50\199\91\254\175\35\206\90\129\172\39\221\89\254\184\35\219\75\209\235\114", "\175\62\161\203\70");
					end
				end
				v158 = 1;
			end
			if ((v158 == 4) or (2371 > 2654)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\157\203\209\43\71\154\193\217\51", "\47\217\174\176\95")]:IsReady() and (v14:Rune() <= 1)) or (3466 > 4520)) then
					if (v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or (951 >= 1027)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\188\216\119\22\186\107\123\41\177\209\54\5\179\70\127\25\171\216\98\23\162\20\42\116", "\70\216\189\22\98\210\52\24");
					end
				end
				break;
			end
			if ((v158 == 1) or (1369 > 2250)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\15\210\214\31\7\57\220\211\22\39", "\85\92\189\163\115")]:IsReady() and (v94 == 1) and ((v16:TimeToX(35) < 5) or (v16:HealthPercentage() <= 35)) and (v16:TimeToDie() > 5)) or (937 > 3786)) then
					if (v10.Press(v61.SoulReaper, nil, nil) or (901 > 4218)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\163\37\52\22\190\53\57\57\169\34\120\46\173\34\63\22\191\53\44\60\188\112\110", "\88\73\204\80");
					end
				end
				if ((4779 > 4047) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\29\150\29\75\38\212\9\130\2\65\38\195\34\134", "\186\78\227\112\38\73")]:IsCastable() and v28 and (v14:BuffUp(v61.CommanderoftheDeadBuff) or (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\223\88\240\88\82\116\248\82\239\90\85\110\244\82\217\80\82\126", "\26\156\55\157\53\51")]:IsAvailable() and (v14:RunicPower() >= 40)))) then
					if ((4050 > 1373) and v10.Press(v61.SummonGargoyle, v56)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\159\205\27\212\183\94\179\223\23\203\191\95\149\212\19\153\191\81\158\223\41\202\189\68\153\200\86\129", "\48\236\184\118\185\216");
					end
				end
				v158 = 2;
			end
		end
	end
	local function v122()
		local v159 = 0;
		while true do
			if ((v159 == 0) or (1037 > 4390)) then
				if ((1407 <= 1919) and v45) then
					local v193 = 0;
					while true do
						if ((2526 >= 1717) and (0 == v193)) then
							if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\251\209\183\142\254\219\216\170\132\224\210\218\175\139", "\179\186\191\195\231")]:IsCastable() and (v14:RunicPowerDeficit() > 40) and (v84 or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\202\42\21\233\246\49\63\229\235\56\23\253\245\58", "\132\153\95\120")]:IsAvailable() or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\130\167\3\32\248\212\135\176\160\9\34\238\214\165", "\192\209\210\110\77\151\186")]:CooldownRemains() > 40))) or (3620 <= 2094)) then
								if (v10.Press(v61.AntiMagicShell, v46) or (1723 >= 2447)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\225\13\54\224\242\197\231\10\33\214\236\204\229\15\46\169\254\201\243\60\35\228\229\132\178", "\164\128\99\66\137\159");
								end
							end
							if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\33\135\253\183\45\136\238\183\3\179\230\176\5", "\222\96\233\137")]:IsCastable() and (v14:RunicPowerDeficit() > 70) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\152\160\180\22\133\250\252\184\167\174\16\134", "\144\217\211\199\127\232\147")]:IsAvailable() and (v84 or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\203\58\51\37\218\75\37\69\234\40\49\49\217\64", "\36\152\79\94\72\181\37\98")]:IsAvailable())) or (1199 > 3543)) then
								if ((1617 < 3271) and v10.Press(v61.AntiMagicZone, v47)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\214\214\83\54\218\217\64\54\212\231\93\48\217\221\7\62\218\203\120\62\218\194\7\107", "\95\183\184\39");
								end
							end
							break;
						end
					end
				end
				if ((3085 > 1166) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\148\45\234\63\91\134\22\189\58\195\35\85\132", "\98\213\95\135\70\52\224")]:IsReady() and v28 and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\205\182\196\122\91\240\132\200\101\83\241\186\197\114", "\52\158\195\169\23")]:IsAvailable() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\73\169\63\121\137\59\92\138\104\187\61\109\138\48", "\235\26\220\82\20\230\85\27")]:CooldownRemains() < 2)) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\187\180\228\207\123\134\134\232\208\115\135\184\229\199", "\20\232\193\137\162")]:IsAvailable() or (v91 < 35))) then
					if ((4493 >= 3603) and v10.Press(v61.ArmyoftheDead, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\205\200\191\216\131\17\78\54\215\192\153\227\137\22\117\98\215\204\161\239\179\7\99\43\208\250\167\228\152\30\126\44\204\133\242", "\17\66\191\165\198\135\236\119");
					end
				end
				v159 = 1;
			end
			if ((2843 <= 2975) and (v159 == 1)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\43\170\175\7\247\203\227\216\3", "\177\111\207\206\115\159\136\140")]:IsReady() and ((v94 <= 3) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\32\153\25\16\209\66\86\6", "\63\101\233\112\116\180\47")]:IsAvailable()) and ((v84 and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\224\52\224\31\249\56\199\62\255\29\254\34\203\62\201\23\249\50", "\86\163\91\141\114\152")]:IsAvailable() and v14:BuffUp(v61.CommanderoftheDeadBuff) and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\114\27\123\112\59\95\18\100\96\63", "\90\51\107\20\19")]:CooldownRemains() < 5) and (v14:BuffRemains(v61.CommanderoftheDeadBuff) > 27)) or (v16:DebuffUp(v61.DeathRotDebuff) and (v16:DebuffRemains(v61.DeathRotDebuff) < v14:GCD())))) or (1989 <= 174)) then
					if (v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or (209 > 2153)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\137\245\132\251\53\178\243\138\230\49\205\248\140\232\53\178\224\151\230\50\178\241\134\251\52\130\254\150\175\107", "\93\237\144\229\143");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\48\230\249\29\14\75\28\245", "\38\117\150\144\121\107")]:IsReady() and (v96 >= 4) and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\14\180\227\55\44\181\234\63\63\180\232\46\37\190\202\63\44\191", "\90\77\219\142")]:IsAvailable() and v14:BuffUp(v61.CommanderoftheDeadBuff) and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\199\20\46\58\77\11\99\246\23\36", "\26\134\100\65\89\44\103")]:CooldownRemains() < 5)) or (v16:DebuffUp(v61.DeathRotDebuff) and (v16:DebuffRemains(v61.DeathRotDebuff) < v14:GCD())))) or (2020 == 1974)) then
					if (v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(30)) or (1347 == 1360)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\244\243\57\39\161\252\234\51\99\172\248\228\56\28\180\227\234\63\28\165\242\247\57\44\170\226\163\104", "\196\145\131\80\67");
					end
				end
				v159 = 2;
			end
			if ((2 == v159) or (4461 == 3572)) then
				if ((v86:IsReady() and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\63\160\9\11\25\228\7\160\21\13", "\136\126\208\102\104\120")]:CooldownRemains() > (v74 + 3)) or (v94 >= 3)) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\72\134\207\68\186\87\63\67\113\132\201\70\189", "\49\24\234\174\35\207\50\93")]:IsAvailable() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\63\231\237\141\99\31\230\239\137\120\2", "\17\108\146\157\232")]:IsAvailable() or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\126\205\28\226\35\177\105\207\29\234\39\188", "\200\43\163\116\141\79")]:IsAvailable()) and (v14:BuffRemains(v61.PlaguebringerBuff) < v14:GCD())) or (2872 == 318)) then
					if ((568 == 568) and v10.Press(v86, nil, nil, not v16:IsSpellInRange(v86))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\57\40\141\180\203\240\175\51\51\135\181\230\163\183\63\58\139\143\228\241\182\57\2\130\179\224\234\176\56\46\195\225\164", "\131\223\86\93\227\208\148");
					end
				end
				if ((4200 == 4200) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\190\185\17\172\193\73\191\177\21\161", "\213\131\37\214\214\125")]:IsReady() and ((v78 and (((not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\7\59\42\188\224\42\50\53\172\228", "\129\70\75\69\223")]:IsAvailable() or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\103\219\252\234\125\227\95\219\224\236", "\143\38\171\147\137\28")]:CooldownDown()) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\253\141\171\241\10\231\221\196\155", "\180\176\226\217\147\99\131")]:IsAvailable()) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\254\182\61\5\218\189\38\19\202", "\103\179\217\79")]:IsAvailable())) or v79 or (v91 < 21))) then
					if (v10.Press(v61.UnholyBlight, v58, nil) or (4285 < 1369)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\185\20\218\77\149\156\72\187\21\210\73\152\227\66\190\27\221\126\156\177\67\184\35\212\66\152\170\69\185\15\149\16\222", "\195\42\215\124\181\33\236");
					end
				end
				v159 = 3;
			end
			if ((v159 == 3) or (3520 > 4910)) then
				if ((2842 <= 4353) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\34\76\35\60\55\253\12\82", "\152\109\57\87\94\69")]:IsReady()) then
					if (v70.CastCycle(v61.Outbreak, v93, v113, not v16:IsSpellInRange(v61.Outbreak)) or (3751 < 1643)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\194\30\161\172\215\85\163\185\223\3\164\182\237\68\186\240\216\53\162\189\198\93\167\247\196\74\242\234", "\200\153\183\106\195\222\178\52");
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v160 = 0;
		while true do
			if ((v160 == 1) or (4911 == 3534)) then
				if ((3001 > 16) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\32\69\255\224\7\82\230\250\12\71", "\147\98\32\141")]:IsCastable() and ((((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\58\70\241\217\3\68\64\17\77\228", "\43\120\35\131\170\102\54")]:BaseDuration() + 3) >= v85) and v84) or ((not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\103\19\138\187\170\190\163\85\20\128\185\188\188\129", "\228\52\102\231\214\197\208")]:IsAvailable() or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\45\245\120\199\229\133\62\215\12\231\122\211\230\142", "\182\126\128\21\170\138\235\121")]:CooldownRemains() > 60)) and ((v82 and (v83 <= (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\169\223\39\245\131\1\59\15\133\221", "\102\235\186\85\134\230\115\80")]:BaseDuration() + 3))) or (v80 and (v81 <= (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\117\9\44\76\119\198\41\94\2\57", "\66\55\108\94\63\18\180")]:BaseDuration() + 3))) or ((v94 >= 2) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\54\136\151\36\34\75\31\132\139\48", "\57\116\237\229\87\71")]:BaseDuration() + 3)))) then
					if ((2875 <= 3255) and v10.Press(v61.Berserking, v52)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\180\255\244\114\252\76\163\191\234\167\101\239\68\163\176\225\244\55\184", "\39\202\209\141\135\23\142");
					end
				end
				if ((368 < 4254) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\211\58\14\2\38\235\213\38\13\13\63\253\241\39", "\152\159\83\105\106\82")]:IsCastable() and v14:BuffUp(v61.UnholyStrengthBuff) and (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\167\195\66\230\204\78\140\207\86\250\221", "\60\225\166\49\146\169")]:IsAvailable() or (v14:BuffRemains(v61.FestermightBuff) < v16:TimeToDie()) or (v14:BuffRemains(v61.UnholyStrengthBuff) < v16:TimeToDie()))) then
					if (v10.Press(v61.LightsJudgment, v52, nil, not v16:IsSpellInRange(v61.LightsJudgment)) or (4841 <= 2203)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\23\40\34\21\20\16\20\58\46\6\10\42\16\59\106\19\6\44\23\46\38\18\71\119", "\103\79\126\79\74\97");
					end
				end
				v160 = 2;
			end
			if ((4661 > 616) and (v160 == 2)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\155\113\208\118\77\14\168\126\223\80\95\22\182", "\122\218\31\179\19\62")]:IsCastable() and (((18 >= v85) and v84) or ((not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\128\195\192\204\198\175\98\178\196\202\206\208\173\64", "\37\211\182\173\161\169\193")]:IsAvailable() or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\196\47\64\212\39\117\158\246\40\74\214\49\119\188", "\217\151\90\45\185\72\27")]:CooldownRemains() > 60)) and ((v82 and (v83 <= 18)) or (v80 and (v81 <= 18)) or ((v94 >= 2) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= 18))) or (1943 == 2712)) then
					if ((4219 >= 39) and v10.Press(v61.AncestralCall, v52)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\194\114\228\23\69\215\110\230\30\105\192\125\235\30\22\209\125\228\27\87\207\111\167\67\6", "\54\163\28\135\114");
					end
				end
				if ((3967 > 2289) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\9\201\94\131\64\122\24\206\81\145\75", "\31\72\187\61\226\46")]:IsCastable() and ((v94 >= 2) or ((v14:Rune() <= 1) and (v14:RunicPowerDeficit() >= 60)))) then
					if (v10.Press(v61.ArcanePulse, v52, nil) or (851 > 2987)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\194\20\64\211\73\123\27\211\19\79\193\66\62\54\194\5\74\211\75\109\100\146\84", "\68\163\102\35\178\39\30");
					end
				end
				v160 = 3;
			end
			if ((4893 >= 135) and (v160 == 3)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\152\121\200\194\1\185\140\30\186", "\113\222\16\186\167\99\213\227")]:IsCastable() and ((((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\8\7\233\243\44\2\244\249\42", "\150\78\110\155")]:BaseDuration() + 3) >= v85) and v84) or ((not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\182\208\42\236\171\16\152\65\151\194\40\248\168\27", "\32\229\165\71\129\196\126\223")]:IsAvailable() or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\240\156\201\140\142\219\228\136\214\134\142\204\207\140", "\181\163\233\164\225\225")]:CooldownRemains() > 60)) and ((v82 and (v83 <= (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\118\130\44\114\82\135\49\120\84", "\23\48\235\94")]:BaseDuration() + 3))) or (v80 and (v81 <= (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\90\211\202\88\85\63\221\115\222", "\178\28\186\184\61\55\83")]:BaseDuration() + 3))) or ((v94 >= 2) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\226\196\85\57\240\2\250\203\201", "\149\164\173\39\92\146\110")]:BaseDuration() + 3)))) or (3084 > 3214)) then
					if (v10.Press(v61.Fireblood, v52) or (3426 < 2647)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\46\2\26\24\23\252\40\20\95\8\26\240\46\17\19\9\91\162\115", "\123\147\71\112\127\122");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\238\204\133\126\64\248\223\139\114\77\223", "\38\172\173\226\17")]:IsCastable() and (v94 == 1) and (v14:BuffUp(v61.UnholyStrengthBuff) or v10.FilteredFightRemains(v93, "<", 5))) or (1576 == 4375)) then
					if (v10.Press(v61.BagofTricks, v52, nil, not v16:IsSpellInRange(v61.BagofTricks)) or (2920 < 2592)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\16\43\208\66\23\19\251\95\24\47\228\94\81\62\238\78\24\45\227\94\81\125\185", "\143\45\113\76");
					end
				end
				break;
			end
			if ((v160 == 0) or (1110 >= 2819)) then
				if ((1824 <= 2843) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\19\241\139\60\71\95\6\236\154\47\76\84\38", "\58\82\131\232\93\41")]:IsCastable() and (v14:RunicPowerDeficit() > 20) and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\176\66\221\24\82\49\164\86\194\18\82\38\143\82", "\95\227\55\176\117\61")]:CooldownRemains() < v14:GCD()) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\43\107\46\70\164\22\89\34\89\172\23\103\47\78", "\203\120\30\67\43")]:IsAvailable() or (v84 and (v14:Rune() < 2) and (v89 < 1)))) then
					if ((3062 == 3062) and v10.Press(v61.ArcaneTorrent, v52, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\55\78\238\215\244\26\89\224\203\227\32\67\251\153\227\36\78\230\216\253\54\13\189", "\185\145\69\45\143");
					end
				end
				if ((716 <= 4334) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\168\19\22\169\216\172\10\11\191", "\188\234\127\121\198")]:IsCastable() and ((((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\26\62\28\140\60\20\6\145\33", "\227\88\82\115")]:BaseDuration() + 3) >= v85) and v84) or ((not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\112\10\183\170\13\125\100\30\168\160\13\106\79\26", "\19\35\127\218\199\98")]:IsAvailable() or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\47\238\7\239\19\245\45\227\14\252\5\251\16\254", "\130\124\155\106")]:CooldownRemains() > 60)) and ((v82 and (v83 <= (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\247\199\249\160\167\208\105\173\204", "\223\181\171\150\207\195\150\28")]:BaseDuration() + 3))) or (v80 and (v81 <= (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\110\54\236\161\13\106\47\241\183", "\105\44\90\131\206")]:BaseDuration() + 3))) or ((v94 >= 2) and v14:BuffUp(v61.DeathAndDecayBuff)))) or (v91 <= (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\221\236\189\182\12\24\234\242\171", "\94\159\128\210\217\104")]:BaseDuration() + 3)))) then
					if ((1001 < 3034) and v10.Press(v61.BloodFury, v52)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\245\9\176\91\64\255\111\66\224\70\173\94\124\240\123\92\234\70\235", "\26\48\153\102\223\63\31\153");
					end
				end
				v160 = 1;
			end
		end
	end
	local function v124()
		local v161 = 0;
		while true do
			if ((v161 == 3) or (977 > 1857)) then
				if ((v86:IsReady() and not v76) or (868 > 897)) then
					if (v70.CastTargetIf(v86, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\24\163\231", "\91\117\194\159\120"), v102, v108, not v16:IsSpellInRange(v86)) or (1115 == 4717)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\13\18\43\22\49\206\55\10\24\48\28\48\227\100\9\9\126\73\97", "\68\122\125\94\120\85\145");
					end
				end
				break;
			end
			if ((2740 < 4107) and (v161 == 2)) then
				if ((284 < 700) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\240\163\244\211\124\165\223\168\224\244\109\165\223\173\226", "\215\182\198\135\167\25")]:IsReady() and not v76) then
					if ((386 >= 137) and v70.CastTargetIf(v61.FesteringStrike, v93, LUAOBFUSACTOR_DECRYPT_STR_0("\128\64\228", "\40\237\41\138"), v102, v107)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\193\113\233\236\79\213\125\244\255\117\212\96\232\241\65\194\52\233\236\10\150\36", "\42\167\20\154\152");
					end
				end
				if ((923 == 923) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\110\251\163\86\121\2\69\247\174", "\65\42\158\194\34\17")]:IsReady()) then
					if (v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or (4173 == 359)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\30\34\83\24\37\210\24\225\19\43\18\31\57\173\74\188", "\142\122\71\50\108\77\141\123");
					end
				end
				v161 = 3;
			end
			if ((1722 == 1722) and (v161 == 1)) then
				if ((v87:IsReady() and v14:BuffDown(v61.DeathAndDecayBuff) and ((v94 >= 2) or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\210\34\160\87\42\111\192\62\167\77\40\114", "\22\135\76\200\56\70")]:IsAvailable() and ((v80 and (v81 >= 13)) or (v84 and (v85 > 8)) or (v82 and (v83 > 8)) or (not v76 and (v89 >= 4)))) or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\169\53\254\45\81\228", "\129\237\80\152\68\61")]:IsAvailable() and (v84 or v80 or v82 or v15:BuffUp(v61.DarkTransformation)))) and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\119\173\23\231\25\5\81\95\175\51\252\9\25\92\117\173\6\230\26\17", "\56\49\200\100\147\124\119")]:AuraActiveCount() == v94) or (v94 == 1))) or (3994 <= 3820)) then
					if ((1488 < 1641) and v10.Press(v88, v48)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\205\48\166\207\200\48\187\176\223\42\255\166", "\144\172\94\223");
					end
				end
				if ((433 <= 2235) and v86:IsReady() and (v76 or ((v94 >= 2) and v14:BuffUp(v61.DeathAndDecayBuff)))) then
					if (v10.Press(v86, nil, nil, not v16:IsSpellInRange(v86)) or (1838 > 2471)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\51\0\183\73\32\48\177\87\33\1\166\66\54\79\177\83\100\87", "\39\68\111\194");
					end
				end
				v161 = 2;
			end
			if ((2444 < 3313) and (v161 == 0)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\156\189\29\40\176\155\19\53\180", "\92\216\216\124")]:IsReady() and not v72 and ((not v77 and v73) or (v91 < 10))) or (3685 <= 185)) then
					if ((738 <= 1959) and v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\55\173\84\245\100\49\163\73\241\27\33\184\0\175", "\157\59\82\204\32");
					end
				end
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\29\46\234\254\236\231\218\178", "\209\88\94\131\154\137\138\179")]:IsReady() and v72 and ((not v77 and v73) or (v91 < 10))) or (1317 == 3093)) then
					if (v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(30)) or (2611 >= 4435)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\177\205\120\27\46\56\33\104\178\208\60\74", "\66\72\193\164\28\126\67\81");
					end
				end
				v161 = 1;
			end
		end
	end
	local function v125()
		if (v33 or (117 > 4925)) then
			local v166 = 0;
			local v167;
			while true do
				if ((107 <= 4905) and (v166 == 0)) then
					v167 = v115();
					if (v167 or (1004 > 4035)) then
						return v167;
					end
					break;
				end
			end
		end
	end
	local function v126()
		local v162 = 0;
		while true do
			if ((3 == v162) or (2802 < 369)) then
				v78 = (v94 == 1) or not v27;
				v79 = (v94 >= 2) and v27;
				v162 = 4;
			end
			if ((1497 <= 2561) and (2 == v162)) then
				v76 = (((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\221\25\80\120\233\240\16\79\104\237", "\136\156\105\63\27")]:CooldownRemains() > v74) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\58\156\118\55\26\128\96\36\8\137", "\84\123\236\25")]:IsAvailable()) and (v75 or ((v89 >= 1) and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\197\133\162\24\160\172\209\152\185\22\185\185\228", "\213\144\235\202\119\204")]:CooldownRemains() < 20) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\22\22\214\37\36\58\108\48\11\223\63\36\55", "\45\67\120\190\74\72\67")]:IsAvailable() and v78) or (v16:DebuffUp(v61.RottenTouchDebuff) and (v89 >= 1)) or (v89 > 4) or (v14:HasTier(31, 4) and (v92:ApocMagusActive() or v92:ArmyMagusActive()) and (v89 >= 1)))) or ((v91 < 5) and (v89 >= 1));
				v77 = v61[LUAOBFUSACTOR_DECRYPT_STR_0("\22\43\225\160\218\135\224\253\33\37\228\170\247", "\137\64\66\141\197\153\232\142")]:IsAvailable() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\53\217\46\163\171\12\222\54\167\143\10\223\44", "\232\99\176\66\198")]:CooldownRemains() < 3) and (v14:RunicPower() < 60) and not v78;
				v162 = 3;
			end
			if ((v162 == 1) or (816 > 1712)) then
				v74 = ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\29\239\236\199\221\175\33\44\236\230", "\88\92\159\131\164\188\195")]:CooldownRemains() < 10) and (v89 <= 4) and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\181\32\183\68\219\242\252\147\61\190\94\219\255", "\189\224\78\223\43\183\139")]:CooldownRemains() > 10) and 7) or 2;
				if ((not v84 and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\8\249\153\2\196\60\241\131\17\201\58", "\161\78\156\234\118")]:IsAvailable() and v14:BuffUp(v61.FestermightBuff) and ((v14:BuffRemains(v61.FestermightBuff) / (5 * v14:GCD())) >= 1)) or (2733 == 2971)) then
					v75 = v89 >= 1;
				else
					v75 = v89 >= (3 - v21(v61[LUAOBFUSACTOR_DECRYPT_STR_0("\142\185\207\217\164\163\204\216\132\187\200\203\180", "\188\199\215\169")]:IsAvailable()));
				end
				v162 = 2;
			end
			if ((2599 < 4050) and (4 == v162)) then
				v73 = (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\222\46\60\18\126\131\205\35\249\34\32", "\76\140\65\72\102\27\237\153")]:IsAvailable() or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\120\213\2\198\210\15\138\69\207\21\218", "\222\42\186\118\178\183\97")]:IsAvailable() and v16:DebuffDown(v61.RottenTouchDebuff)) or (v14:RunicPowerDeficit() < 20)) and (not v14:HasTier(31, 4) or (v14:HasTier(31, 4) and not (v92:ApocMagusActive() or v92:ArmyMagusActive())) or (v14:RunicPowerDeficit() < 20) or (v14:Rune() < 3)) and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\116\225\84\152\82\250\65\142\121\233\69\158\85\207\75\131\81", "\234\61\140\36")]:IsAvailable() and ((v94 == 2) or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\2\210\179\126\0\39\249\191\100\14\50\201\187\102\6\46\211", "\111\65\189\218\18")]:IsAvailable())) or (v14:Rune() < 3) or v84 or v14:BuffUp(v61.SuddenDoomBuff) or ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\98\91\20\54\10\80\182\83\88\30", "\207\35\43\123\85\107\60")]:CooldownRemains() < 10) and (v89 > 3)) or (not v76 and (v89 >= 4)));
				break;
			end
			if ((2034 == 2034) and (v162 == 0)) then
				v72 = (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\62\17\223\76\199\207\191\19\56\202\95\220\209\153\24\21\195", "\218\119\124\175\62\168\185")]:IsAvailable() and not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\134\255\65\200\170\246\108\193\179\241\91\208\164\228\65\203\171", "\164\197\144\40")]:IsAvailable() and (v94 >= 3)) or (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\160\255\163\135\210\176\167\245\188\138\206\162\130\228\163\132\211", "\214\227\144\202\235\189")]:IsAvailable() and (v94 >= 4)) or (not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\196\168\151\105\31\165\86\56\201\160\134\111\24\144\92\53\225", "\92\141\197\231\27\112\211\51")]:IsAvailable() and (v94 >= 2));
				v71 = (v94 >= 3) or ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\213\234\135\174\222\232\216\139\177\214\233\230\134\166", "\177\134\159\234\195")]:CooldownRemains() > 1) and ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\156\251\48\163\200\177\242\47\179\204", "\169\221\139\95\192")]:CooldownRemains() > 1) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\255\155\112\60\35\42\199\155\108\58", "\70\190\235\31\95\66")]:IsAvailable())) or not v61[LUAOBFUSACTOR_DECRYPT_STR_0("\137\247\23\235\234\180\197\27\244\226\181\251\22\227", "\133\218\130\122\134")]:IsAvailable() or (v10.CombatTime() > 20);
				v162 = 1;
			end
		end
	end
	local function v127()
		local v163 = 0;
		while true do
			if ((3040 < 4528) and (v163 == 4)) then
				if (v70.TargetIsValid() or v14:AffectingCombat() or (2092 <= 2053)) then
					local v194 = 0;
					while true do
						if ((2120 < 4799) and (v194 == 1)) then
							v80 = v61[LUAOBFUSACTOR_DECRYPT_STR_0("\63\209\175\231\188\126\7\209\179\225", "\18\126\161\192\132\221")]:TimeSinceLastCast() <= 15;
							v81 = (v80 and (15 - v61[LUAOBFUSACTOR_DECRYPT_STR_0("\126\56\161\7\87\83\49\190\23\83", "\54\63\72\206\100")]:TimeSinceLastCast())) or 0;
							v82 = v61[LUAOBFUSACTOR_DECRYPT_STR_0("\233\75\72\99\234\125\220\81\64\94\224\122\204", "\27\168\57\37\26\133")]:TimeSinceLastCast() <= 30;
							v83 = (v82 and (30 - v61[LUAOBFUSACTOR_DECRYPT_STR_0("\12\184\113\177\216\43\190\116\173\243\40\171\120", "\183\77\202\28\200")]:TimeSinceLastCast())) or 0;
							v194 = 2;
						end
						if ((v194 == 0) or (4538 <= 389)) then
							v90 = v10.BossFightRemains();
							v91 = v90;
							if ((270 <= 1590) and (v91 == 11111)) then
								v91 = v10.FightRemains(v93, false);
							end
							v97 = v100(v95);
							v194 = 1;
						end
						if ((1625 > 1265) and (v194 == 2)) then
							v84 = v92:GargActive();
							v85 = v92:GargRemains();
							v89 = v16:DebuffStack(v61.FesteringWoundDebuff);
							break;
						end
					end
				end
				if (v70.TargetIsValid() or (51 >= 920)) then
					local v195 = 0;
					local v196;
					while true do
						if ((v195 == 2) or (2968 <= 1998)) then
							if ((v28 and v78) or (3085 <= 2742)) then
								local v199 = 0;
								local v200;
								while true do
									if ((0 == v199) or (376 >= 2083)) then
										v200 = v120();
										if ((4191 > 1232) and v200) then
											return v200;
										end
										break;
									end
								end
							end
							if ((v27 and v28 and v79) or (1505 > 4873)) then
								local v201 = 0;
								local v202;
								while true do
									if ((3880 < 4534) and (v201 == 0)) then
										v202 = v118();
										if (v202 or (2368 >= 2541)) then
											return v202;
										end
										break;
									end
								end
							end
							if (v28 or (4733 <= 4103)) then
								local v203 = 0;
								local v204;
								while true do
									if ((v203 == 0) or (1207 == 4273)) then
										v204 = v123();
										if (v204 or (2005 == 2529)) then
											return v204;
										end
										break;
									end
								end
							end
							if ((986 < 3589) and v27) then
								local v205 = 0;
								while true do
									if ((v205 == 0) or (3119 == 430)) then
										if ((2409 <= 3219) and v79 and (v87:CooldownRemains() < 10) and v14:BuffDown(v61.DeathAndDecayBuff)) then
											local v215 = 0;
											local v216;
											while true do
												if ((v215 == 0) or (898 > 2782)) then
													v216 = v119();
													if (v216 or (2250 <= 1764)) then
														return v216;
													end
													break;
												end
											end
										end
										if ((693 == 693) and (v94 >= 4) and v14:BuffUp(v61.DeathAndDecayBuff)) then
											local v217 = 0;
											local v218;
											while true do
												if ((v217 == 0) or (2529 == 438)) then
													v218 = v117();
													if ((1751 > 1411) and v218) then
														return v218;
													end
													break;
												end
											end
										end
										v205 = 1;
									end
									if ((4182 == 4182) and (v205 == 1)) then
										if (((v94 >= 4) and (((v87:CooldownRemains() > 10) and v14:BuffDown(v61.DeathAndDecayBuff)) or not v79)) or (4666 <= 611)) then
											local v219 = 0;
											local v220;
											while true do
												if ((v219 == 0) or (4737 <= 4525)) then
													v220 = v116();
													if ((4367 >= 3735) and v220) then
														return v220;
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							v195 = 3;
						end
						if ((2426 == 2426) and (1 == v195)) then
							v196 = v122();
							if ((21 < 1971) and v196) then
								return v196;
							end
							if (v33 or (2922 <= 441)) then
								local v206 = 0;
								local v207;
								while true do
									if ((3624 >= 1136) and (v206 == 0)) then
										v207 = v125();
										if ((2043 < 2647) and v207) then
											return v207;
										end
										break;
									end
								end
							end
							if ((v28 and not v71) or (354 >= 1534)) then
								local v208 = 0;
								local v209;
								while true do
									if ((0 == v208) or (3764 >= 4876)) then
										v209 = v121();
										if ((3676 >= 703) and v209) then
											return v209;
										end
										break;
									end
								end
							end
							v195 = 2;
						end
						if ((3811 > 319) and (3 == v195)) then
							if ((47 < 1090) and (v94 <= 3)) then
								local v210 = 0;
								local v211;
								while true do
									if ((v210 == 0) or (1371 >= 2900)) then
										v211 = v124();
										if (v211 or (1126 <= 504)) then
											return v211;
										end
										break;
									end
								end
							end
							if (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\119\137\187\103\84\158\161\125\86\191\188\97\88\135\173", "\19\49\236\200")]:IsReady() or (3732 == 193)) then
								if ((3344 >= 3305) and v10.Press(v61.FesteringStrike, nil, nil)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\248\50\229\163\225\168\247\57\241\136\247\174\236\62\253\178\164\170\236\50\245\184\233\184\255\35\182\239", "\218\158\87\150\215\132");
								end
							end
							break;
						end
						if ((v195 == 0) or (2885 < 1925)) then
							if (not v14:AffectingCombat() or (4542 <= 1594)) then
								local v212 = 0;
								local v213;
								while true do
									if ((338 <= 3505) and (v212 == 0)) then
										v213 = v114();
										if ((69 == 69) and v213) then
											return v213;
										end
										break;
									end
								end
							end
							if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\51\54\136\28\31\0\157\26\30\56\140", "\104\119\83\233")]:IsReady() and not v69) or (672 == 368)) then
								if ((1019 == 1019) and v10.Press(v61.DeathStrike)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\241\253\38\54\75\202\235\51\48\74\254\253\103\46\76\226\184\47\50\3\250\234\103\50\81\250\251", "\35\149\152\71\66");
								end
							end
							if ((v94 == 0) or (290 > 2746)) then
								local v214 = 0;
								while true do
									if ((1923 < 4601) and (v214 == 0)) then
										if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\54\253\86\178\40\28\233\73", "\90\121\136\34\208")]:IsReady() and (v97 > 0)) or (3957 == 2099)) then
											if ((4006 > 741) and v10.Press(v61.Outbreak, nil, nil, not v16:IsSpellInRange(v61.Outbreak))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\200\27\65\28\213\11\84\21\135\1\64\10\248\1\83\33\213\15\91\25\194", "\126\167\110\53");
											end
										end
										if ((2359 <= 3733) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\24\0\39\252\217\50\52\19", "\95\93\112\78\152\188")]:IsReady() and v27 and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\247\252\151\0\232\187\220\213\197\137\20\227\171\215\229\240\135\0\226\184", "\178\161\149\229\117\132\222")]:AuraActiveCount() > 1) and not v77) then
											if (v10.Press(v61.Epidemic, v55, nil, not v16:IsInRange(30)) or (4596 <= 2402)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\141\203\212\168\164\27\175\32\200\212\200\184\158\25\160\28\154\218\211\171\164", "\67\232\187\189\204\193\118\198");
											end
										end
										v214 = 1;
									end
									if ((2078 > 163) and (v214 == 1)) then
										if ((4116 > 737) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\175\43\180\52\51\33\224\130\34", "\143\235\78\213\64\91\98")]:IsReady() and (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\187\65\150\252\124\179\131\92\180\229\113\177\152\77\160\236\114\163\139\78", "\214\237\40\228\137\16")]:AuraActiveCount() < 2) and not v77) then
											if (v10.Press(v61.DeathCoil, nil, nil, not v16:IsSpellInRange(v61.DeathCoil)) or (1175 > 4074)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\129\230\238\205\11\153\134\236\230\213\67\169\144\247\208\214\5\153\151\226\225\222\6", "\198\229\131\143\185\99");
											end
										end
										break;
									end
								end
							end
							v126();
							v195 = 1;
						end
					end
				end
				break;
			end
			if ((v163 == 0) or (1361 == 4742)) then
				v60();
				v26 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\68\165\167\237\117\117\185", "\25\16\202\192\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\196\174", "\148\157\171\205\130\201")];
				v163 = 1;
			end
			if ((v163 == 1) or (4012 >= 4072)) then
				v27 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\23\219\115\46\221\243\48", "\150\67\180\20\73\177")][LUAOBFUSACTOR_DECRYPT_STR_0("\140\23\31", "\45\237\120\122")];
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\231\165\43\219\237\177", "\76\183\136\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\226\246", "\116\26\134\133\88\48\47")];
				v163 = 2;
			end
			if ((3807 >= 1276) and (v163 == 2)) then
				v69 = not v99();
				v93 = v14:GetEnemiesInMeleeRange(8, v61.FesteringStrike);
				v163 = 3;
			end
			if ((2220 <= 4361) and (3 == v163)) then
				v95 = v16:GetEnemiesInSplashRange(10);
				if ((228 == 228) and v27) then
					local v197 = 0;
					while true do
						if ((v197 == 0) or (4118 <= 3578)) then
							v94 = #v93;
							v96 = v16:GetEnemiesInSplashRangeCount(10);
							break;
						end
					end
				else
					local v198 = 0;
					while true do
						if ((v198 == 0) or (2915 < 1909)) then
							v94 = 1;
							v96 = 1;
							break;
						end
					end
				end
				v163 = 4;
			end
		end
	end
	local function v128()
		local v164 = 0;
		while true do
			if ((634 <= 2275) and (v164 == 1)) then
				v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\128\32\188\114\136\172\110\144\86\196\183\55\244\88\148\188\45\250\61\179\186\60\191\61\141\187\110\132\111\139\178\60\177\110\151\245\9\187\119\141\167\47", "\228\213\78\212\29"));
				break;
			end
			if ((1091 <= 2785) and (v164 == 0)) then
				v61[LUAOBFUSACTOR_DECRYPT_STR_0("\205\23\203\247\58\39\195\239\46\213\227\49\55\200\223\27\219\247\48\36", "\173\155\126\185\130\86\66")]:RegisterAuraTracking();
				v61[LUAOBFUSACTOR_DECRYPT_STR_0("\195\163\169\211\141\254\236\168\189\240\135\249\235\162\158\194\138\249\227\160", "\140\133\198\218\167\232")]:RegisterAuraTracking();
				v164 = 1;
			end
		end
	end
	v10.SetAPL(252, v127, v128);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\162\92\191\29\212\163\73\183\17\227\172\66\191\2\227\147\115\131\11\227\136\64\175\75\231\146\77", "\139\231\44\214\101")]();

