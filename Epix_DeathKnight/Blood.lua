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
		if ((v5 == 0) or (1653 <= 1108)) then
			v6 = v0[v4];
			if ((2909 > 2609) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((757 > 194) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\194\31\197\203\240\43\239\188\207\10\238\225\215\42\233\191\137\18\196\194", "\126\177\163\187\69\134\219\167")] = function(...)
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
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\121\80\5\54\90", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\145\194\212\24\13", "\75\220\163\183\106\98")];
	local v22 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\33\181\134\58\214\12\169", "\185\98\218\235\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\238\42\34\244\199\165\197\57", "\202\171\92\71\134\190")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\212\33", "\232\73\161\76")];
	local v23 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\230\37\199", "\167\214\137\74\171\120\206\83")];
	local v24 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\134\249\60", "\199\235\144\82\61\152")];
	local v25 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\6\20\170", "\75\103\118\217")];
	local v26 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\202\85\104", "\126\167\52\16\116\217")];
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30;
	local v31;
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
	local function v63()
		local v92 = 0;
		while true do
			if ((5 == v92) or (31 >= 1398)) then
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\248\88\38\27\66\125\159", "\26\236\157\44\82\114\44")][LUAOBFUSACTOR_DECRYPT_STR_0("\28\47\216\75\35\60\220\88\8\34\218\84\46\26\221\73\47\61\221\84\38\42", "\59\74\78\181")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\212\78\78\186\43\214\73", "\211\69\177\58\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\224\120\225\225\248\163\247\112\254\236\239\162\232\105\212\228\196\162\235\109", "\171\215\133\25\149\137")];
				break;
			end
			if ((3196 <= 4872) and (v92 == 0)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\43\52\148\189\23\251\219", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\253\160\252\6\237\172\207\11\253", "\174\103\142\197")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\101\45\75\44\44\80\255\69", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\225\215\235\116\209\197\226\85\218\195\222\83\192\205\225\82", "\60\180\164\142")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\91\17\61\46\227\21\75", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\236\218\200\177\231\220\244\183\253\210\203\182\199\218\201\189", "\164\216\137\187")] or 0;
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\225\227\37\166\175\240\12\193", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\16\11\131\202\163\54\9\178\201\190\49\1\140\238\154", "\202\88\110\226\166")] or 0;
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\10\150\227\195\205\8\145", "\170\163\111\226\151")][LUAOBFUSACTOR_DECRYPT_STR_0("\36\35\183\16\75\54\37\5\56\161\44\65\57\44", "\73\113\80\210\88\46\87")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\178\41\217\6\238\143\43\222", "\135\225\76\173\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\232\185\188\184\181\180\14\226\182\181\132\141", "\199\122\141\216\208\204\221")] or 0;
				v92 = 1;
			end
			if ((3326 == 3326) and (v92 == 2)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\106\83\95\233\124\136\128\24", "\107\57\54\43\157\21\230\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\238\152\20\212\148\239\238\246\177\62\243\191\217\193\200\130\7\240\181\197", "\175\187\235\113\149\217\188")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\170\149\88\234\119\127\47", "\24\92\207\225\44\131\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\106\221\172\69\54\124\76\218\187\127\19\120\71\223\159\111\63", "\29\43\179\216\44\123")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\220\52\88\180\215\39\95", "\44\221\185\64")][LUAOBFUSACTOR_DECRYPT_STR_0("\32\233\92\86\94\0\224\65\92\73\14\233\77\120\80\37", "\19\97\135\40\63")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\157\89\39\47\38\63\169\79", "\81\206\60\83\91\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\106\174\209\102\39\226\67\160\106\174\211\115\54\228\110\128", "\196\46\203\176\18\79\163\45")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\39\106\10\45\245\232\171", "\143\216\66\30\126\68\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\143\197\29\196\210\166\197\211\191\198\8\252\192\162\199\238\164\239\46\239", "\129\202\168\109\171\165\195\183")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\93\35\204\215\26\225\49", "\134\66\56\87\184\190\116")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\48\10\169\16\237\40\54\53\48\5\139\24\232\53\18\31\21", "\85\92\81\105\219\121\139\65")];
				v92 = 3;
			end
			if ((1433 <= 3878) and (v92 == 1)) then
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\216\4\228\113\248\170\206", "\150\205\189\112\144\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\12\138\171\73\22\154\4\0\49\179\182\88\12\187\5\5\43", "\112\69\228\223\44\100\232\113")] or 0;
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\26\19\199\191\114\129\199", "\230\180\127\103\179\214\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\165\11\75\67\246\83\245\156\17\112\72\232\88\215\132\12\75\67\232\72\243\152", "\128\236\101\63\38\132\33")] or 0;
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\159\172\5\80\191\229\200\191", "\175\204\201\113\36\214\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\110\194\33\217\22\85\217\37\200\48\79\222\48\207\12\72\192\49", "\100\39\172\85\188")] or 0;
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\125\173\148\58\163\127\170", "\83\205\24\217\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\214\200\9\244\204\195\54\227\209\222", "\93\134\165\173")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\247\213\214\51\192\181\109", "\30\222\146\161\162\90\174\210")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\93\117\46\224\79\100\2\214\90\98\3\238\75\88\58", "\106\133\46\16")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\37\103\232\83\78\95\51", "\32\56\64\19\156\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\111\219\224\114\91\224\139\105\221\230\85\85\224\168\106", "\224\58\168\133\54\58\146")];
				v92 = 2;
			end
			if ((v92 == 3) or (1583 == 1735)) then
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\182\68\81\117\209\250\160", "\191\157\211\48\37\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\22\250\24\28\205\26\241\6\63\240\25\242\59\25\251", "\90\191\127\148\124")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\130\58\3\113\137\41\4", "\119\24\231\78")][LUAOBFUSACTOR_DECRYPT_STR_0("\176\44\166\67\221\76\2\173\43\163\109\255\100", "\113\226\77\197\42\188\32")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\9\19\224\161\51\24\243\166", "\213\90\118\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\33\186\83\94\79\33\166\91\106\120\10", "\45\59\78\212\54")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\35\83\151\159\143\32\170\227", "\144\112\54\227\235\230\78\205")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\32\14\245\222\72\156\46\38\255\213\124\144\12", "\59\211\72\111\156\176")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\130\247\57\71\137\228\62", "\77\46\231\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\85\184\67\179\90\177\114\175\90\179\119\191\85\166\79\180\115\149\100", "\32\218\52\214")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\18\37\188\248\190\66\73", "\58\46\119\81\200\145\208\37")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\137\49\184\161\142\34\57\133\59\169\142\158\18", "\86\75\236\80\204\201\221")];
				v92 = 4;
			end
			if ((v92 == 4) or (2981 == 2350)) then
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\65\68\99\145\247\133\117\82", "\235\18\33\23\229\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\185\196\185\95\175\207\191\118\181\211\175\89\174\212\191\85\157\226\159", "\219\48\218\161")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\215\116\104\93\210\65\231\247", "\128\132\17\28\41\187\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\61\11\56\78\21\61\8\63\122\34\22", "\61\97\82\102\90")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\159\43\191\95\206\89\25\26", "\105\204\78\203\43\167\55\126")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\171\46\14\26\22\206\82\135\166\44\17\23\35\228\117", "\49\197\202\67\126\115\100\167")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\4\94\203\61\137\88\89\36", "\62\87\59\191\73\224\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\14\245\198\227\54\251\217\200\4\252\238\196\38", "\169\135\98\154")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\114\48\64\244\61\207\216", "\168\171\23\68\52\157\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\100\251\168\17\44\151\219\119\243\138\6\9", "\231\148\17\149\205\69\77")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\162\211\239\94\241\135\180", "\159\224\199\167\155\55")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\230\50\215\195\242\44\230\255\225\57\193\255\252\48\214", "\178\151\147\92")];
				v92 = 5;
			end
		end
	end
	local v64;
	local v65 = v16[LUAOBFUSACTOR_DECRYPT_STR_0("\197\205\51\238\231\27\242\75\230\192\38", "\34\129\168\82\154\143\80\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\167\190\60\4\76", "\233\229\210\83\107\40\46")];
	local v66 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\229\71\51\194\13\234\76\59\209\13\213", "\101\161\34\82\182")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\1\86\241\223", "\78\136\109\57\158\187\130\226")];
	local v67 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\26\58\248\229\54\20\247\248\57\55\237", "\145\94\95\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\193\27\218\74", "\215\157\173\116\181\46")];
	local v68 = {};
	local v69 = 65;
	local v70 = ((not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\17\177\138\230\210\38\151\138\224\223\38\167", "\186\85\212\235\146")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\225\142\24\237\44\227\72\214\136\25\240", "\56\162\225\118\158\89\142")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\126\9\207\160\38\220\78\12\206\164\39\202", "\184\60\101\160\207\66")]:IsAvailable()) and 4) or 5;
	local v71 = 0;
	local v72 = 0;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\22\138\115\169\61\182\125\190\61\135", "\220\81\226\28")];
	local v79 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\48\218\143\246\229\201\0", "\167\115\181\226\155\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\52\226\78\98\126\200\231", "\166\130\66\135\60\27\17")];
	local v80 = {{v65[LUAOBFUSACTOR_DECRYPT_STR_0("\101\89\222\125\41\92\67\207\97\53", "\80\36\42\174\21")],LUAOBFUSACTOR_DECRYPT_STR_0("\109\17\36\110\14\49\36\106\70\9\47\115\79\4\50\58\6\57\57\110\75\2\37\111\94\4\126", "\26\46\112\87"),function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		v70 = ((not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\157\38\170\96\183\172\102\181\171\38\184\103", "\212\217\67\203\20\223\223\37")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\153\130\166\193\175\128\184\198\179\130\166", "\178\218\237\200")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\148\185\233\223\178\177\244\217\184\190\227\194", "\176\214\213\134")]:IsAvailable()) and 4) or 5;
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\199\157\147\248\132\101\102\215\133\151\250\143\115\125", "\57\148\205\214\180\200\54"), LUAOBFUSACTOR_DECRYPT_STR_0("\62\216\20\6\88\55\217\10\7\70\55\209\25\11\95\60\194\1\21\84", "\22\114\157\85\84"));
	local function v81(v93)
		local v94 = 0;
		local v95;
		while true do
			if ((v94 == 1) or (4466 <= 493)) then
				return v95;
			end
			if ((v94 == 0) or (2547 <= 1987)) then
				v95 = 0;
				for v134, v135 in pairs(v93) do
					if ((2961 > 2740) and not v135:DebuffUp(v65.BloodPlagueDebuff)) then
						v95 = v95 + 1;
					end
				end
				v94 = 1;
			end
		end
	end
	local function v82(v96)
		return (v96:DebuffRemains(v65.SoulReaperDebuff));
	end
	local function v83(v97)
		return ((v97:TimeToX(35) < 5) or (v97:HealthPercentage() <= 35)) and (v97:TimeToDie() > (v97:DebuffRemains(v65.SoulReaperDebuff) + 5));
	end
	local function v84()
		local v98 = 0;
		while true do
			if ((3696 >= 3612) and (v98 == 0)) then
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\224\206\18\208\85\229\139\197\217\22\215\78", "\200\164\171\115\164\61\150")]:IsReady() or (2970 == 1878)) then
					if (v20(v65.DeathsCaress, nil, nil, not v15:IsSpellInRange(v65.DeathsCaress)) or (3693 < 1977)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\241\2\81\139\173\203\0\68\145\187\231\16\5\147\172\241\0\74\142\188\245\23\5\215", "\227\222\148\99\37");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\30\83\64\228\246\36\64\87\248\253", "\153\83\50\50\150")]:IsReady() or (930 > 2101)) then
					if ((4153 > 3086) and v20(v65.Marrowrend, nil, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\119\97\14\124\188\95\88\120\119\92\99\185\72\94\121\126\30\114\191\13\11", "\45\61\22\19\124\19\203");
					end
				end
				break;
			end
		end
	end
	local function v85()
		local v99 = 0;
		while true do
			if ((v99 == 0) or (4654 <= 4050)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\243\7\3\240\54\113\169", "\217\161\114\109\149\98\16")]:IsReady() and v73 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= 3) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\32\53\54\121\136\117\2", "\20\114\64\88\28\220")]:Charges() >= 1) and v14:BuffDown(v65.RuneTapBuff)) or (2602 < 1496)) then
					if (v20(v65.RuneTap, v59) or (1020 > 2288)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\20\220\177\199\196\188\33\65\214\177\254\213\179\34\8\196\177\235\144\239", "\221\81\97\178\212\152\176");
					end
				end
				if ((328 == 328) and v14:ActiveMitigationNeeded() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\224\230\15\233\21\218\245\24\245\30", "\122\173\135\125\155")]:TimeSinceLastCast() > 2.5) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\160\196\1\173\55\2\220\150\200\11\188", "\168\228\161\96\217\95\81")]:TimeSinceLastCast() > 2.5)) then
					local v136 = 0;
					while true do
						if ((1511 < 3808) and (v136 == 0)) then
							if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\255\212\47\72\39\100\207\195\39\87\42", "\55\187\177\78\60\79")]:IsReady() and (v14:BuffStack(v65.BoneShieldBuff) > 7)) or (2510 > 4919)) then
								if ((4763 == 4763) and v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\41\203\94\255\78\240\147\57\220\86\224\67\143\132\40\200\90\229\85\198\150\40\221\31\191", "\224\77\174\63\139\38\175");
								end
							end
							if ((4137 > 1848) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\169\64\74\60\139\86\74\43\138\69", "\78\228\33\56")]:IsReady()) then
								if ((2436 <= 3134) and v20(v65.Marrowrend, nil, nil, not v15:IsInMeleeRange(5))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\195\127\160\17\138\217\108\183\13\129\142\122\183\5\128\192\109\187\21\128\221\62\228", "\229\174\30\210\99");
								end
							end
							v136 = 1;
						end
						if ((3723 == 3723) and (v136 == 1)) then
							if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\63\232\135\69\229\14\45\9\228\141\84", "\89\123\141\230\49\141\93")]:IsReady() or (4046 >= 4316)) then
								if (v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike)) or (2008 < 1929)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\247\116\247\24\24\117\224\101\228\5\27\79\179\117\243\10\21\68\224\120\224\9\3\10\162\33", "\42\147\17\150\108\112");
								end
							end
							break;
						end
					end
				end
				v99 = 1;
			end
			if ((2384 > 1775) and (v99 == 1)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\57\167\32\111\238\250\6\165\15\115\232\231\11", "\136\111\198\77\31\135")]:IsCastable() and v73 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v65.IceboundFortitudeBuff)) or (4543 <= 4376)) then
					if ((728 == 728) and v20(v65.VampiricBlood, v57)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\20\8\170\70\180\246\30\170\61\11\171\89\178\224\87\173\7\15\162\88\174\237\1\172\17\73\246\2", "\201\98\105\199\54\221\132\119");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\144\15\134\35\13\32\162\189\42\140\51\22\60\184\172\8\134", "\204\217\108\227\65\98\85")]:IsCastable() and v73 and (v14:HealthPercentage() <= IceboundFortitudeThreshold) and v14:BuffDown(v65.VampiricBloodBuff)) or (1076 > 4671)) then
					if ((1851 >= 378) and v20(v65.IceboundFortitude, v55)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\192\240\231\35\213\80\199\202\227\35\210\74\202\225\240\40\197\30\199\240\227\41\206\77\202\227\224\63\128\15\149", "\160\62\163\149\133\76");
					end
				end
				v99 = 2;
			end
			if ((v99 == 2) or (1948 >= 3476)) then
				if ((4794 >= 833) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\242\165\12\59\203\229\180\31\38\200\211", "\163\182\192\109\79")]:IsReady() and (v14:HealthPercentage() <= (50 + (((v14:RunicPower() > v69) and 20) or 0))) and not v14:HealingAbsorbed()) then
					if ((4090 == 4090) and v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\35\1\212\253\11\53\20\210\252\63\35\64\196\240\50\35\14\211\252\34\35\19\128\164\108", "\149\84\70\96\160");
					end
				end
				break;
			end
		end
	end
	local function v86()
	end
	local function v87()
		local v100 = 0;
		while true do
			if ((v100 == 0) or (3758 == 2498)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\26\10\2\226\60\32\24\255\33", "\141\88\102\109")]:IsCastable() and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\151\82\196\115\19\51\82\243\166\93\207\71\31\60\69\206\189", "\161\211\51\170\16\122\93\53")]:CooldownUp() and (not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\217\162\189\39\255\170\160\33\245\165\183\58", "\72\155\206\210")]:IsReady() or not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\100\118\91\1\55\66\104\93\0\56\67\104", "\83\38\26\52\110")]:IsAvailable())) or (2673 < 1575)) then
					if (v20(v65.BloodFury, v50) or (3721 <= 1455)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\27\40\73\92\40\33\83\74\14\103\84\89\20\46\71\84\4\103\20", "\38\56\119\71");
					end
				end
				if ((934 < 2270) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\209\234\74\197\32\68\248\230\86\209", "\54\147\143\56\182\69")]:IsCastable()) then
					if (v20(v65.Berserking, v50) or (1612 == 1255)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\212\132\237\90\218\196\138\246\71\216\150\147\254\74\214\215\141\236\9\139", "\191\182\225\159\41");
					end
				end
				v100 = 1;
			end
			if ((v100 == 2) or (4352 < 4206)) then
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\39\17\81\194\191\102\153\7\19\113\198\160\126", "\235\102\127\50\167\204\18")]:IsCastable() or (2860 <= 181)) then
					if ((3222 >= 1527) and v20(v65.AncestralCall, v50)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\175\246\38\87\58\66\160\249\28\71\47\92\173\181\49\69\45\89\160\249\48\4\127\0", "\78\48\193\149\67\36");
					end
				end
				if ((1505 <= 2121) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\22\23\146\29\67\60\17\143\28", "\33\80\126\224\120")]:IsCastable()) then
					if ((744 == 744) and v20(v65.Fireblood, v50)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\161\17\193\94\224\167\12\192\28\254\169\0\205\93\224\187\67\149\14", "\60\140\200\99\164");
					end
				end
				v100 = 3;
			end
			if ((1 == v100) or (1979 >= 2836)) then
				if ((1833 <= 2668) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\10\0\43\84\133\130\242\62\30\59\80", "\162\75\114\72\53\235\231")]:IsCastable() and ((v75 >= 2) or ((v14:Rune() < 1) and (v14:RunicPowerDeficit() > 60)))) then
					if ((3686 == 3686) and v20(v65.ArcanePulse, v50, nil, not v15:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\141\46\71\227\93\7\179\44\81\238\64\7\204\46\69\225\90\3\128\47\4\180", "\98\236\92\36\130\51");
					end
				end
				if ((3467 > 477) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\136\16\11\178\81\187\159\37\160\30\1\191\75\188", "\80\196\121\108\218\37\200\213")]:IsCastable() and (v14:BuffUp(v65.UnholyStrengthBuff))) then
					if (v20(v65.LightsJudgment, v50, nil, not v15:IsSpellInRange(v65.LightsJudgment)) or (3288 >= 3541)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\12\122\5\119\95\29\181\10\102\6\120\70\11\132\20\51\16\126\72\7\139\12\96\66\39", "\234\96\19\98\31\43\110");
					end
				end
				v100 = 2;
			end
			if ((v100 == 3) or (3557 == 4540)) then
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\165\245\3\41\164\179\230\13\37\169\148", "\194\231\148\100\70")]:IsCastable() or (261 > 1267)) then
					if ((1272 < 3858) and v20(v65.BagofTricks, v50, nil, not v15:IsSpellInRange(v65.BagofTricks))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\77\198\156\249\206\121\88\211\170\245\195\85\12\211\162\245\193\71\64\210\227\167\156", "\168\38\44\161\195\150");
					end
				end
				if ((3664 == 3664) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\161\238\129\119\62\237\130\25\146\238\135\120\36", "\118\224\156\226\22\80\136\214")]:IsCastable() and (v14:RunicPowerDeficit() > 20)) then
					if ((1941 >= 450) and v20(v65.ArcaneTorrent, v50, nil, not v15:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\252\90\129\76\235\102\148\77\252\75\133\76\250\25\146\67\237\80\129\78\253\25\209\20", "\224\34\142\57");
					end
				end
				break;
			end
		end
	end
	local function v88()
		local v101 = 0;
		while true do
			if ((v101 == 1) or (4646 < 324)) then
				if ((3833 == 3833) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\35\27\39\249\228\171\163\0\17\32", "\194\112\116\82\149\182\206")]:IsReady() and (v75 == 1) and ((v15:TimeToX(35) < 5) or (v15:HealthPercentage() <= 35)) and (v15:TimeToDie() > (v15:DebuffRemains(v65.SoulReaperDebuff) + 5))) then
					if (v20(v65.SoulReaper, nil, nil, not v15:IsInMeleeRange(5)) or (1240 > 3370)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\167\89\20\255\240\11\56\184\73\10\128\230\28\46\151\89\8\128\179\92", "\110\89\200\44\120\160\130");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\152\204\94\74\113\79\58\93\174\209", "\45\203\163\43\38\35\42\91")]:IsReady() and (v75 >= 2)) or (2481 == 4682)) then
					if ((4727 >= 208) and v79.CastTargetIf(v65.SoulReaper, v74, LUAOBFUSACTOR_DECRYPT_STR_0("\223\140\210", "\52\178\229\188\67\231\201"), v82, v83, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\50\78\69\8\200\78\38\32\81\85\22\183\88\49\54\126\69\20\183\13\119", "\67\65\33\48\100\151\60");
					end
				end
				if ((280 < 3851) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\251\226\175\204\251\254\233\170\252\246\220\230\183", "\147\191\135\206\184")]:IsReady() and v14:BuffDown(v65.DeathAndDecayBuff) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\183\41\168\198\205\90\188\129\15\180\206\205\93\182", "\210\228\72\198\161\184\51")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\3\71\251\31\127\215\17\91\252\5\125\202", "\174\86\41\147\112\19")]:IsAvailable())) then
					if (v20(v67.DaDPlayer, v46, nil, not v15:IsInRange(30)) or (3007 > 3194)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\5\140\31\45\48\16\165\95\63\137\14\38\14\8\235\95\18\154\52\48\31\81\250\13", "\203\59\96\237\107\69\111\113");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\6\26\163\238\53\210\216\45\26", "\183\68\118\204\129\81\144")]:IsCastable() and (v64 > 2) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\44\161\127\235\15\160\1\164\124", "\226\110\205\16\132\107")]:ChargesFractional() >= 1.1)) or (2136 >= 2946)) then
					if ((2165 <= 2521) and v20(v65.BloodBoil, nil, not v15:IsInMeleeRange(10))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\207\239\214\69\212\193\239\208\77\171\199\242\206\126\254\211\160\136\25", "\33\139\163\128\185");
					end
				end
				v101 = 2;
			end
			if ((2861 > 661) and (v101 == 3)) then
				if ((4525 > 4519) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\103\80\117\26\91\102\96\26\70\94\113", "\104\47\53\20")]:IsReady() and ((v14:RuneTimeToX(2) < v14:GCD()) or (v14:RunicPowerDeficit() >= v72))) then
					if ((3178 > 972) and v20(v65.HeartStrike, nil, nil, not v15:IsSpellInRange(v65.HeartStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\73\128\14\168\48\176\88\147\21\183\10\227\72\147\11\131\26\179\12\211\74", "\111\195\44\225\124\220");
					end
				end
				break;
			end
			if ((4766 == 4766) and (v101 == 0)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\252\171\202\210\119\211\82\7\210", "\110\190\199\165\189\19\145\61")]:IsReady() and (v15:DebuffDown(v65.BloodPlagueDebuff))) or (2745 > 3128)) then
					if (v20(v65.BloodBoil, nil, nil, not v15:IsInMeleeRange(10)) or (1144 >= 4606)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\231\120\231\143\248\216\228\126\228\203\195\200\252\72\253\155\135\136", "\167\186\139\23\136\235");
					end
				end
				if ((3338 >= 277) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\46\186\133\15\9\161\135\3\31", "\109\122\213\232")]:IsReady() and (v14:BuffStack(v65.BoneShieldBuff) > 5) and (v14:Rune() >= 2) and (v14:RunicPowerDeficit() >= 30) and (not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\221\255\163\36\250\242\176\57\224\240\128\63\224\242", "\80\142\151\194")]:IsAvailable() or (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\48\206\118\88\23\195\101\69\13\193\85\67\13\195", "\44\99\166\23")]:IsAvailable() and v14:BuffUp(v65.DeathAndDecayBuff)))) then
					if ((2610 > 2560) and v20(v65.Tombstone)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\104\248\36\52\32\176\115\249\44\118\55\182\107\200\60\38\115\240", "\196\28\151\73\86\83");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\215\6\40\4\138\107\12\100\250\8\44", "\22\147\99\73\112\226\56\120")]:IsReady() and ((v14:BuffRemains(v65.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v65.IcyTalonsBuff) <= v14:GCD()))) or (1194 > 3083)) then
					if ((916 >= 747) and v20(v65.DeathStrike, v54, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\188\112\227\225\133\135\102\246\231\132\179\112\162\241\159\175\74\247\229\205\238", "\237\216\21\130\149");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\175\79\77\77\191\222\76\135\64\91", "\62\226\46\63\63\208\169")]:IsReady() and ((v14:BuffRemains(v65.BoneShieldBuff) <= 4) or (v14:BuffStack(v65.BoneShieldBuff) < v70)) and (v14:RunicPowerDeficit() > 20)) or (2444 > 2954)) then
					if ((2892 < 3514) and v20(v65.Marrowrend, nil, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\232\24\71\145\16\26\61\91\235\29\21\135\13\26\16\75\245\89\4\211", "\62\133\121\53\227\127\109\79");
					end
				end
				v101 = 1;
			end
			if ((533 == 533) and (v101 == 2)) then
				v72 = 25 + (v76 * v22(v65[LUAOBFUSACTOR_DECRYPT_STR_0("\127\93\5\204\67\90\22\219\86\83\1\204", "\190\55\56\100")]:IsAvailable()) * 2);
				if ((595 <= 3413) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\114\170\61\10\27\208\231\68\166\55\27", "\147\54\207\92\126\115\131")]:IsReady() and ((v14:RunicPowerDeficit() <= v72) or (v14:RunicPower() >= v69))) then
					if ((3078 >= 2591) and v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\52\52\105\5\65\30\37\39\116\6\123\77\53\39\106\50\107\29\113\103\45", "\30\109\81\85\29\109");
					end
				end
				if ((3199 < 4030) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\220\126\90\165\35\211\236\235\120\91\184", "\156\159\17\52\214\86\190")]:IsCastable()) then
					if ((777 < 2078) and v20(v65.Consumption, nil, not v15:IsSpellInRange(v65.Consumption))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\224\179\175\187\226\173\168\167\224\179\252\170\253\170\131\187\255\253\238\252", "\220\206\143\221");
					end
				end
				if ((1696 <= 2282) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\164\113\34\24\220\238\221\143\113", "\178\230\29\77\119\184\172")]:IsReady() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\215\178\5\20\115\218\250\183\6", "\152\149\222\106\123\23")]:ChargesFractional() >= 1.1) and (v14:BuffStack(v65.HemostasisBuff) < 5)) then
					if (v20(v65.BloodBoil, nil, nil, not v15:IsInMeleeRange(10)) or (1761 >= 2462)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\223\42\249\76\177\226\36\249\74\185\157\34\228\84\138\200\54\182\17\225", "\213\189\70\150\35");
					end
				end
				v101 = 3;
			end
		end
	end
	local function v89()
		local v102 = 0;
		while true do
			if ((4551 > 2328) and (v102 == 1)) then
				if ((3825 >= 467) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\202\59\249\98\232\45\249\117\233\62", "\16\135\90\139")]:IsReady() and ((v14:BuffRemains(v65.BoneShieldBuff) <= 4) or (v14:BuffStack(v65.BoneShieldBuff) < v70)) and (v14:RunicPowerDeficit() > 20) and not (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\125\122\21\50\90\93\121\86\120\3\17\66\85\124\81", "\24\52\20\102\83\46\52")]:IsAvailable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\224\46\47\39\6\202\40\19\49\1\193\24\36\37\31\203\33", "\111\164\79\65\68")]:CooldownRemains() < v14:BuffRemains(v65.BoneShieldBuff)))) then
					if (v20(v65.Marrowrend, nil, nil, not v15:IsInMeleeRange(5)) or (2890 == 557)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\203\216\145\204\33\253\212\220\141\218\110\249\210\216\141\218\47\248\194\153\219", "\138\166\185\227\190\78");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\232\123\203\36\71\46\9\223\125\202\57", "\121\171\20\165\87\50\67")]:IsCastable() or (4770 == 2904)) then
					if (v20(v65.Consumption, nil, not v15:IsSpellInRange(v65.Consumption)) or (3903 == 4536)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\55\183\37\172\15\214\44\176\57\183\66\213\44\184\56\189\3\212\60\249\103\233", "\98\166\88\217\86\217");
					end
				end
				if ((4093 <= 4845) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\197\249\108\13\180\217\247\230\124\19", "\188\150\150\25\97\230")]:IsReady() and (v75 == 1) and ((v15:TimeToX(35) < 5) or (v15:HealthPercentage() <= 35)) and (v15:TimeToDie() > (v15:DebuffRemains(v65.SoulReaperDebuff) + 5))) then
					if ((1569 <= 3647) and v20(v65.SoulReaper, nil, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\134\74\14\51\255\223\136\79\7\30\173\201\157\94\12\8\236\200\141\31\83\94", "\141\186\233\63\98\108");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\194\229\57\186\23\244\235\60\179\55", "\69\145\138\76\214")]:IsReady() and (v75 >= 2)) or (4046 >= 4927)) then
					if ((4623 >= 2787) and v79.CastTargetIf(v65.SoulReaper, v74, LUAOBFUSACTOR_DECRYPT_STR_0("\125\198\135", "\118\16\175\233\233\223"), v82, v83, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\152\139\32\183\209\153\120\138\148\48\169\174\152\105\138\138\49\186\252\143\61\218\208", "\29\235\228\85\219\142\235");
					end
				end
				v102 = 2;
			end
			if ((2234 >= 1230) and (v102 == 3)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\209\17\199\238\152\146\228\39\240\31\195", "\85\153\116\166\156\236\193\144")]:IsReady() and (v14:Rune() > 1) and ((v14:RuneTimeToX(3) < v14:GCD()) or (v14:BuffStack(v65.BoneShieldBuff) > 7))) or (343 == 1786)) then
					if ((2570 > 2409) and v20(v65.HeartStrike, nil, nil, not v15:IsSpellInRange(v65.HeartStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\172\229\76\161\240\63\183\244\95\186\239\5\228\243\89\178\234\4\165\242\73\243\182\84", "\96\196\128\45\211\132");
					end
				end
				break;
			end
			if ((v102 == 2) or (2609 >= 3234)) then
				if ((v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\31\219\180\216\100\90\40\64\48", "\50\93\180\218\189\23\46\71")]:IsReady() and (v14:RunicPower() >= 100)) or (3033 >= 4031)) then
					if (v20(v65.Bonestorm, nil, not v15:IsInMeleeRange(8)) or (1401 == 4668)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\171\85\73\87\200\71\204\169\27\95\80\221\70\218\165\73\72\4\141\30", "\40\190\196\59\44\36\188");
					end
				end
				if ((2776 >= 1321) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\30\73\211\187\254\95\2\53\73", "\109\92\37\188\212\154\29")]:IsCastable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\38\227\171\204\53\120\11\230\168", "\58\100\143\196\163\81")]:ChargesFractional() >= 1.8) and ((v14:BuffStack(v65.HemostasisBuff) <= (5 - v64)) or (v64 > 2))) then
					if (v20(v65.BloodBoil, nil, not v15:IsInMeleeRange(10)) or (487 > 2303)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\78\44\172\59\118\231\1\19\78\99\176\43\72\235\10\27\80\39\227\110\17", "\110\122\34\67\195\95\41\133");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\93\180\90\88\194\70\165\73\67\221\112", "\182\21\209\59\42")]:IsReady() and (v14:RuneTimeToX(4) < v14:GCD())) or (4503 == 3462)) then
					if ((553 <= 1543) and v20(v65.HeartStrike, nil, nil, not v15:IsSpellInRange(v65.HeartStrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\82\196\15\53\129\164\67\215\20\42\187\247\68\209\28\47\186\182\69\193\93\115\238", "\222\215\55\165\125\65");
					end
				end
				if ((2015 == 2015) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\14\221\201\21\246\227\226\67\32", "\42\76\177\166\122\146\161\141")]:IsCastable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\135\134\10\193\125\84\170\131\9", "\22\197\234\101\174\25")]:ChargesFractional() >= 1.1)) then
					if (v20(v65.BloodBoil, nil, not v15:IsInMeleeRange(10)) or (4241 <= 2332)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\56\170\211\114\144\213\137\36\56\229\207\98\174\217\130\44\38\161\156\36\253", "\230\77\84\197\188\22\207\183");
					end
				end
				v102 = 3;
			end
			if ((v102 == 0) or (2364 < 1157)) then
				if ((v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\236\73\13\113\184\191\215\72\5", "\203\184\38\96\19\203")]:IsCastable() and (v14:BuffStack(v65.BoneShieldBuff) > 5) and (v14:Rune() >= 2) and (v14:RunicPowerDeficit() >= 30) and (not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\10\123\120\85\218\60\97\112\79\201\27\124\119\68", "\174\89\19\25\33")]:IsAvailable() or (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\28\26\83\90\227\130\25\38\28\85\108\248\137\14", "\107\79\114\50\46\151\231")]:IsAvailable() and v14:BuffUp(v65.DeathAndDecayBuff))) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\29\167\187\42\131\55\176\242\44\168\176\30\143\56\167\207\55", "\160\89\198\213\73\234\89\215")]:CooldownRemains() >= 25)) or (1167 > 1278)) then
					if (v20(v65.Tombstone) or (1145 <= 1082)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\126\185\252\214\92\126\186\251\133\91\101\181\240\193\73\99\176\190\151", "\165\40\17\212\158");
					end
				end
				v71 = 10 + (v75 * v22(v65[LUAOBFUSACTOR_DECRYPT_STR_0("\205\220\9\33\50\231\203\13\50\45\224\203", "\70\133\185\104\83")]:IsAvailable()) * 2);
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\32\64\69\62\193\55\81\86\35\194\1", "\169\100\37\36\74")]:IsReady() and ((v14:BuffRemains(v65.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v65.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v69) or (v14:RunicPowerDeficit() <= v71) or (v15:TimeToDie() < 10))) or (3105 == 4881)) then
					if (v20(v65.DeathStrike, v54, nil, not v15:IsInMeleeRange(5)) or (1887 > 4878)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\4\130\163\68\8\184\177\68\18\142\169\85\64\148\182\81\14\131\163\66\4\199\246", "\48\96\231\194");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\236\95\15\57\17\203\140\130\218\95\29\62", "\227\168\58\110\77\121\184\207")]:IsReady() and ((v14:BuffRemains(v65.BoneShieldBuff) <= 4) or (v14:BuffStack(v65.BoneShieldBuff) < (v70 + 1))) and (v14:RunicPowerDeficit() > 10) and not (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\82\50\172\65\165\210\112\167\119\57\157\76\176\223\116", "\197\27\92\223\32\209\187\17")]:IsAvailable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\39\94\205\248\10\81\196\201\22\81\198\204\6\94\211\244\13", "\155\99\63\163")]:CooldownRemains() < v14:BuffRemains(v65.BoneShieldBuff))) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\161\222\175\158\172\137\146\197\168\130\183", "\228\226\177\193\237\217")]:IsAvailable() and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\22\188\44\233\48\180\49\239\58\187\38\244", "\134\84\208\67")]:IsAvailable() and (v14:RuneTimeToX(3) > v14:GCD())) or (4087 > 4116)) then
					if ((1106 <= 1266) and v20(v65.DeathsCaress, nil, nil, not v15:IsSpellInRange(v65.DeathsCaress))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\169\135\72\27\191\185\95\18\190\131\79\0\236\149\72\18\162\130\93\1\168\198\10", "\60\115\204\230");
					end
				end
				v102 = 1;
			end
		end
	end
	local function v90()
		local v103 = 0;
		while true do
			if ((3155 < 4650) and (v103 == 4)) then
				v73 = v14:IsTankingAoE(8) or v14:IsTanking(v15);
				if ((3774 >= 1839) and v79.TargetIsValid()) then
					local v137 = 0;
					while true do
						if ((2811 == 2811) and (1 == v137)) then
							if ((2146 > 1122) and v31) then
								local v140 = 0;
								local v141;
								while true do
									if ((0 == v140) or (56 == 3616)) then
										v141 = v86();
										if (v141 or (2421 < 622)) then
											return v141;
										end
										break;
									end
								end
							end
							if ((1009 <= 1130) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\30\8\239\31\41\45\227\13\40", "\108\76\105\134")]:IsCastable()) then
								if ((2758 < 2980) and v20(v65.RaiseDead, nil)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\249\196\184\242\203\212\193\180\224\202\171\200\176\232\192\171\145", "\174\139\165\209\129");
								end
							end
							if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\149\178\239\209\207\17\121\123\129\191\237\206\194", "\24\195\211\130\161\166\99\16")]:IsCastable() and v14:BuffDown(v65.VampiricBloodBuff) and v14:BuffDown(v65.VampiricStrengthBuff)) or (86 >= 3626)) then
								if ((2395 == 2395) and v20(v65.VampiricBlood, v57)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\80\2\228\60\90\4\79\0\214\46\95\25\73\7\169\33\82\31\72\67\188", "\118\38\99\137\76\51");
								end
							end
							if ((3780 > 2709) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\217\35\4\6\1\51\222\39\23\23\26\51", "\64\157\70\101\114\105")]:IsReady() and (v14:BuffDown(v65.BoneShieldBuff))) then
								if (v20(v65.DeathsCaress, nil, nil, not v15:IsSpellInRange(v65.DeathsCaress)) or (237 >= 2273)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\68\173\166\247\24\83\151\164\226\2\69\187\180\163\29\65\161\169\163\70", "\112\32\200\199\131");
								end
							end
							v137 = 2;
						end
						if ((v137 == 3) or (2040 <= 703)) then
							if ((3279 <= 3967) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\217\180\39\241\73\57\227\182\45\226\76\15\235\182\48", "\95\138\213\68\131\32")]:IsReady() and v78.GhoulActive() and v14:BuffDown(v65.DancingRuneWeaponBuff) and ((v78.GhoulRemains() < 2) or (v15:TimeToDie() < v14:GCD()))) then
								if (v20(v65.SacrificialPact, v48) or (1988 == 877)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\57\41\162\81\127\44\33\162\74\119\38\23\177\66\117\62\104\172\66\127\36\104\240\23", "\22\74\72\193\35");
								end
							end
							if ((4291 > 1912) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\14\117\235\87\40\77\229\72", "\56\76\25\132")]:IsCastable() and (((v14:Rune() <= 2) and (v14:RuneTimeToX(4) > v14:GCD()) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\124\205\164\41\203\106\192\187", "\175\62\161\203\70")]:ChargesFractional() >= 1.8)) or (v14:RuneTimeToX(3) > v14:GCD()))) then
								if ((2003 < 2339) and v20(v65.BloodTap, v58)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\62\209\204\28\49\3\201\194\3\117\49\220\202\29\117\109\139", "\85\92\189\163\115");
								end
							end
							if ((432 == 432) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\14\163\34\61\47\165\53\54\45\191\23\42\40\191\32", "\88\73\204\80")]:IsCastable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\26\138\23\78\61\223\32\138\30\65\14\200\47\144\0", "\186\78\227\112\38\73")]:IsAvailable())) then
								if (v20(v65.GorefiendsGrasp, nil, not v15:IsSpellInRange(v65.GorefiendsGrasp)) or (1145 >= 1253)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\251\88\239\80\85\115\249\89\249\70\108\125\238\86\238\69\19\119\253\94\243\21\2\34", "\26\156\55\157\53\51");
								end
							end
							if ((3418 > 2118) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\169\213\6\214\175\85\158\234\3\215\189\103\137\217\6\214\182", "\48\236\184\118\185\216")]:IsCastable() and (v14:Rune() < 6) and (v14:RunicPowerDeficit() > 5)) then
								if ((3066 <= 3890) and v20(v65.EmpowerRuneWeapon, v47)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\224\176\71\63\216\49\247\130\69\37\193\49\218\170\82\49\223\59\235\253\90\49\198\58\165\239\7", "\84\133\221\55\80\175");
								end
							end
							v137 = 4;
						end
						if ((v137 == 0) or (2998 >= 3281)) then
							if (not v14:AffectingCombat() or (4649 <= 2632)) then
								local v142 = 0;
								local v143;
								while true do
									if ((v142 == 0) or (3860 > 4872)) then
										v143 = v84();
										if (v143 or (3998 == 2298)) then
											return v143;
										end
										break;
									end
								end
							end
							if (v73 or (8 >= 2739)) then
								local v144 = 0;
								local v145;
								while true do
									if ((2590 == 2590) and (v144 == 0)) then
										v145 = v85();
										if (v145 or (82 >= 1870)) then
											return v145;
										end
										break;
									end
								end
							end
							if ((2624 < 4557) and v14:IsChanneling(v65.Blooddrinker) and v14:BuffUp(v65.BoneShieldBuff) and (v77 == 0) and not v14:ShouldStopCasting() and (v14:CastRemains() > 0.2)) then
								if (v10.CastAnnotated(v65.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\152\234\232\250", "\174\207\171\161")) or (3131 > 3542)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\221\241\2\255\184\243\248\236\4\253\255\151\207\242\2\252\252\211\255\247\3\248\253\197", "\183\141\158\109\147\152");
								end
							end
							v69 = v62;
							v137 = 1;
						end
						if ((2577 >= 1578) and (v137 == 4)) then
							if ((4103 <= 4571) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\156\229\43\171\206\82\188\243\45\169\201\112\180\234\38", "\60\221\135\68\198\167")]:IsCastable()) then
								if (v20(v65.AbominationLimb, nil, not v15:IsInRange(20)) or (1495 == 4787)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\239\191\247\142\75\215\239\169\241\140\76\230\226\180\245\129\2\212\239\180\246\195\16\139", "\185\142\221\152\227\34");
								end
							end
							if ((v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\124\196\89\249\74\61\240\106\208\89\255\116\54\246\72\202\89", "\151\56\165\55\154\35\83")]:IsCastable() and (v14:BuffDown(v65.DancingRuneWeaponBuff))) or (310 > 4434)) then
								if ((2168 <= 4360) and v20(v65.DancingRuneWeapon, v53)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\164\66\11\237\169\77\2\209\178\86\11\235\159\84\0\239\176\76\11\174\173\66\12\224\224\17\81", "\142\192\35\101");
								end
							end
							if ((994 == 994) and (v14:BuffUp(v65.DancingRuneWeaponBuff))) then
								local v146 = 0;
								local v147;
								while true do
									if ((1655 > 401) and (v146 == 0)) then
										v147 = v88();
										if ((3063 <= 3426) and v147) then
											return v147;
										end
										v146 = 1;
									end
									if ((1459 > 764) and (v146 == 1)) then
										if (v10.CastAnnotated(v65.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\225\84\0\151", "\118\182\21\73\195\135\236\204")) or (641 > 4334)) then
											return "Wait/Pool for DRWUp";
										end
										break;
									end
								end
							end
							if ((3399 >= 2260) and true) then
								local v148 = 0;
								local v149;
								while true do
									if ((v148 == 0) or (393 >= 4242)) then
										v149 = v89();
										if ((989 < 4859) and v149) then
											return v149;
										end
										break;
									end
								end
							end
							v137 = 5;
						end
						if ((v137 == 5) or (4795 < 949)) then
							if ((3842 == 3842) and v10.CastAnnotated(v65.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\63\29\51\116", "\157\104\92\122\32\100\109"))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((1747 <= 3601) and (v137 == 2)) then
							if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\8\85\93\172\203\138\44\40\116\89\187\194\178", "\66\76\48\60\216\163\203")]:IsReady() and v14:BuffDown(v65.DeathAndDecayBuff) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\143\136\113\252\83\215\3\168\137\108\253\91", "\68\218\230\25\147\63\174")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\158\43\93\75\163\164\36\86\107\164\162\63\93\72", "\214\205\74\51\44")]:IsAvailable() or (v64 > 3) or v14:BuffUp(v65.CrimsonScourgeBuff))) or (804 > 4359)) then
								if ((4670 >= 3623) and v20(v67.DaDPlayer, v46, nil, not v15:IsInRange(30))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\254\73\227\232\127\197\77\236\248\72\254\73\225\253\110\186\65\227\245\121\186\20", "\23\154\44\130\156");
								end
							end
							if ((2065 < 2544) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\53\163\172\186\62\32\5\180\164\165\51", "\115\113\198\205\206\86")]:IsReady() and ((v14:BuffRemains(v65.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v65.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v69) or (v14:RunicPowerDeficit() <= v71) or (v15:TimeToDie() < 10))) then
								if ((1311 <= 3359) and v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\128\82\255\78\140\104\237\78\150\94\245\95\196\90\255\83\138\23\175\10", "\58\228\55\158");
								end
							end
							if ((2717 <= 3156) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\150\133\223\33\56\169\39\189\135\219\43\46", "\85\212\233\176\78\92\205")]:IsReady() and (v14:BuffDown(v65.DancingRuneWeaponBuff))) then
								if ((1081 < 4524) and v20(v65.Blooddrinker, nil, nil, not v15:IsSpellInRange(v65.Blooddrinker))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\72\84\135\237\78\92\154\235\68\83\141\240\10\85\137\235\68\24\217\176", "\130\42\56\232");
								end
							end
							if ((440 >= 71) and v29) then
								local v150 = 0;
								local v151;
								while true do
									if ((4934 > 2607) and (v150 == 0)) then
										v151 = v87();
										if (v151 or (1400 > 3116)) then
											return v151;
										end
										break;
									end
								end
							end
							v137 = 3;
						end
					end
				end
				break;
			end
			if ((525 < 1662) and (2 == v103)) then
				Enemies10y = v14:GetEnemiesInRange(10);
				if (v28 or (876 > 2550)) then
					local v138 = 0;
					while true do
						if ((219 <= 2456) and (1 == v138)) then
							v64 = #Enemies10y;
							break;
						end
						if ((v138 == 0) or (4219 == 1150)) then
							v74 = v14:GetEnemiesInMeleeRange(8);
							v75 = #v74;
							v138 = 1;
						end
					end
				else
					local v139 = 0;
					while true do
						if ((v139 == 0) or (2989 <= 222)) then
							v75 = 1;
							v64 = 1;
							break;
						end
					end
				end
				v103 = 3;
			end
			if ((2258 > 1241) and (v103 == 3)) then
				v76 = v24(v75, (v14:BuffUp(v65.DeathAndDecayBuff) and 5) or 2);
				v77 = v81(Enemies10y);
				v103 = 4;
			end
			if ((41 < 4259) and (v103 == 0)) then
				v63();
				v27 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\130\124\88\222\170\167", "\184\85\237\27\63\178\207\212")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\86\10", "\63\104\57\105")];
				v103 = 1;
			end
			if ((1 == v103) or (1930 < 56)) then
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\136\163\67\7\130\183", "\36\107\231\196")][LUAOBFUSACTOR_DECRYPT_STR_0("\92\186\167", "\231\61\213\194")];
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\61\162\58\116\5\168\46", "\19\105\205\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\170\12\205", "\95\201\104\190\225")];
				v103 = 2;
			end
		end
	end
	local function v91()
		v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\129\170\192\197\57\103\169\128\227\164\214\138\24\55\132\168\237\230\248\197\47\44\205\162\173\230\223\216\50\32\159\174\176\181\143\237\50\45\132\185\162", "\203\195\198\175\170\93\71\237"));
	end
	v10.SetAPL(250, v90, v91);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\11\91\55\205\110\53\249\47\95\54\254\95\24\251\38\95\1\247\93\30\243\42\5\50\192\80", "\156\78\43\94\181\49\113")]();

