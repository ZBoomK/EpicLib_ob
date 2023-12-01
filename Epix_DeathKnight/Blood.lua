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
		if ((1757 == 1757) and (v5 == 1)) then
			return v6(...);
		end
		if ((2091 < 2945) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (2430 == 4154)) then
				return v1(v4, ...);
			end
			v5 = 1;
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
			if ((4770 >= 4339) and (v92 == 1)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\10\150\227\195\205\8\145", "\170\163\111\226\151")][LUAOBFUSACTOR_DECRYPT_STR_0("\36\35\183\16\75\54\37\5\56\161\44\65\57\44", "\73\113\80\210\88\46\87")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\178\41\217\6\238\143\43\222", "\135\225\76\173\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\232\185\188\184\181\180\14\226\182\181\132\141", "\199\122\141\216\208\204\221")] or 0;
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\216\4\228\113\248\170\206", "\150\205\189\112\144\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\12\138\171\73\22\154\4\0\49\179\182\88\12\187\5\5\43", "\112\69\228\223\44\100\232\113")] or 0;
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\26\19\199\191\114\129\199", "\230\180\127\103\179\214\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\165\11\75\67\246\83\245\156\17\112\72\232\88\215\132\12\75\67\232\72\243\152", "\128\236\101\63\38\132\33")] or 0;
				v92 = 2;
			end
			if ((v92 == 0) or (4466 <= 493)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\43\52\148\189\23\251\219", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\253\160\252\6\237\172\207\11\253", "\174\103\142\197")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\101\45\75\44\44\80\255\69", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\225\215\235\116\209\197\226\85\218\195\222\83\192\205\225\82", "\60\180\164\142")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\91\17\61\46\227\21\75", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\236\218\200\177\231\220\244\183\253\210\203\182\199\218\201\189", "\164\216\137\187")] or 0;
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\225\227\37\166\175\240\12\193", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\16\11\131\202\163\54\9\178\201\190\49\1\140\238\154", "\202\88\110\226\166")] or 0;
				v92 = 1;
			end
			if ((v92 == 7) or (2547 <= 1987)) then
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\114\48\64\244\61\207\216", "\168\171\23\68\52\157\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\100\251\168\17\44\151\219\119\243\138\6\9", "\231\148\17\149\205\69\77")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\162\211\239\94\241\135\180", "\159\224\199\167\155\55")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\230\50\215\195\242\44\230\255\225\57\193\255\252\48\214", "\178\151\147\92")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\248\88\38\27\66\125\159", "\26\236\157\44\82\114\44")][LUAOBFUSACTOR_DECRYPT_STR_0("\28\47\216\75\35\60\220\88\8\34\218\84\46\26\221\73\47\61\221\84\38\42", "\59\74\78\181")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\212\78\78\186\43\214\73", "\211\69\177\58\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\224\120\225\225\248\163\247\112\254\236\239\162\232\105\212\228\196\162\235\109", "\171\215\133\25\149\137")];
				break;
			end
			if ((2961 > 2740) and (v92 == 4)) then
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\39\106\10\45\245\232\171", "\143\216\66\30\126\68\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\143\197\29\196\210\166\197\211\191\198\8\252\192\162\199\238\164\239\46\239", "\129\202\168\109\171\165\195\183")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\93\35\204\215\26\225\49", "\134\66\56\87\184\190\116")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\48\10\169\16\237\40\54\53\48\5\139\24\232\53\18\31\21", "\85\92\81\105\219\121\139\65")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\182\68\81\117\209\250\160", "\191\157\211\48\37\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\22\250\24\28\205\26\241\6\63\240\25\242\59\25\251", "\90\191\127\148\124")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\130\58\3\113\137\41\4", "\119\24\231\78")][LUAOBFUSACTOR_DECRYPT_STR_0("\176\44\166\67\221\76\2\173\43\163\109\255\100", "\113\226\77\197\42\188\32")];
				v92 = 5;
			end
			if ((3696 >= 3612) and (v92 == 5)) then
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\9\19\224\161\51\24\243\166", "\213\90\118\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\33\186\83\94\79\33\166\91\106\120\10", "\45\59\78\212\54")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\35\83\151\159\143\32\170\227", "\144\112\54\227\235\230\78\205")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\32\14\245\222\72\156\46\38\255\213\124\144\12", "\59\211\72\111\156\176")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\130\247\57\71\137\228\62", "\77\46\231\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\85\184\67\179\90\177\114\175\90\179\119\191\85\166\79\180\115\149\100", "\32\218\52\214")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\18\37\188\248\190\66\73", "\58\46\119\81\200\145\208\37")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\137\49\184\161\142\34\57\133\59\169\142\158\18", "\86\75\236\80\204\201\221")];
				v92 = 6;
			end
			if ((v92 == 6) or (2970 == 1878)) then
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\65\68\99\145\247\133\117\82", "\235\18\33\23\229\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\185\196\185\95\175\207\191\118\181\211\175\89\174\212\191\85\157\226\159", "\219\48\218\161")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\215\116\104\93\210\65\231\247", "\128\132\17\28\41\187\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\61\11\56\78\21\61\8\63\122\34\22", "\61\97\82\102\90")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\159\43\191\95\206\89\25\26", "\105\204\78\203\43\167\55\126")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\171\46\14\26\22\206\82\135\166\44\17\23\35\228\117", "\49\197\202\67\126\115\100\167")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\4\94\203\61\137\88\89\36", "\62\87\59\191\73\224\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\14\245\198\227\54\251\217\200\4\252\238\196\38", "\169\135\98\154")];
				v92 = 7;
			end
			if ((v92 == 3) or (3693 < 1977)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\106\83\95\233\124\136\128\24", "\107\57\54\43\157\21\230\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\238\152\20\212\148\239\238\246\177\62\243\191\217\193\200\130\7\240\181\197", "\175\187\235\113\149\217\188")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\170\149\88\234\119\127\47", "\24\92\207\225\44\131\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\106\221\172\69\54\124\76\218\187\127\19\120\71\223\159\111\63", "\29\43\179\216\44\123")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\220\52\88\180\215\39\95", "\44\221\185\64")][LUAOBFUSACTOR_DECRYPT_STR_0("\32\233\92\86\94\0\224\65\92\73\14\233\77\120\80\37", "\19\97\135\40\63")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\157\89\39\47\38\63\169\79", "\81\206\60\83\91\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\106\174\209\102\39\226\67\160\106\174\211\115\54\228\110\128", "\196\46\203\176\18\79\163\45")];
				v92 = 4;
			end
			if ((v92 == 2) or (930 > 2101)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\159\172\5\80\191\229\200\191", "\175\204\201\113\36\214\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\110\194\33\217\22\85\217\37\200\48\79\222\48\207\12\72\192\49", "\100\39\172\85\188")] or 0;
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\125\173\148\58\163\127\170", "\83\205\24\217\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\214\200\9\244\204\195\54\227\209\222", "\93\134\165\173")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\247\213\214\51\192\181\109", "\30\222\146\161\162\90\174\210")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\93\117\46\224\79\100\2\214\90\98\3\238\75\88\58", "\106\133\46\16")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\37\103\232\83\78\95\51", "\32\56\64\19\156\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\111\219\224\114\91\224\139\105\221\230\85\85\224\168\106", "\224\58\168\133\54\58\146")];
				v92 = 3;
			end
		end
	end
	local v64;
	local v65 = v16[LUAOBFUSACTOR_DECRYPT_STR_0("\197\205\51\238\231\27\242\75\230\192\38", "\34\129\168\82\154\143\80\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\167\190\60\4\76", "\233\229\210\83\107\40\46")];
	local v66 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\229\71\51\194\13\234\76\59\209\13\213", "\101\161\34\82\182")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\1\86\241\223", "\78\136\109\57\158\187\130\226")];
	local v67 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\26\58\248\229\54\20\247\248\57\55\237", "\145\94\95\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\193\27\218\74", "\215\157\173\116\181\46")];
	local v68 = {v66[LUAOBFUSACTOR_DECRYPT_STR_0("\19\173\153\243\214\52\160\131", "\186\85\212\235\146")]:ID()};
	local v69 = 65;
	local v70 = ((not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\230\132\23\234\49\253\123\195\147\19\237\42", "\56\162\225\118\158\89\142")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\127\10\206\188\55\213\76\17\201\160\44", "\184\60\101\160\207\66")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\19\142\115\179\53\134\110\181\63\137\121\174", "\220\81\226\28")]:IsAvailable()) and 4) or 5;
	local v71 = 0;
	local v72 = 0;
	local v73;
	local v74;
	local v75;
	local v76;
	local v77;
	local v78 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\52\221\141\238\230\243\18\215\142\254", "\167\115\181\226\155\138")];
	local v79 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\193\45\234\81\116\127\213", "\166\130\66\135\60\27\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\97\92\203\103\41\75\68\203", "\80\36\42\174\21")];
	local v80 = {{v65[LUAOBFUSACTOR_DECRYPT_STR_0("\111\3\39\114\87\8\62\123\90\21", "\26\46\112\87")],LUAOBFUSACTOR_DECRYPT_STR_0("\154\34\184\96\255\158\86\164\177\58\179\125\190\171\64\244\241\10\165\96\186\173\87\161\169\55\226", "\212\217\67\203\20\223\223\37"),function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		v70 = ((not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\158\136\169\198\178\158\139\211\168\136\187\193", "\178\218\237\200")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\149\186\232\195\163\184\246\196\191\186\232", "\176\214\213\134")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\214\161\185\219\172\82\75\253\163\189\209\186", "\57\148\205\214\180\200\54")]:IsAvailable()) and 4) or 5;
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\33\205\16\24\90\33\194\22\28\87\60\218\16\16", "\22\114\157\85\84"), LUAOBFUSACTOR_DECRYPT_STR_0("\232\238\50\246\115\211\140\251\248\35\225\113\218\151\237\229\44\240\124\212", "\200\164\171\115\164\61\150"));
	local function v81(v93)
		local v94 = 0;
		local v95;
		while true do
			if ((4153 > 3086) and (v94 == 1)) then
				return v95;
			end
			if ((v94 == 0) or (4654 <= 4050)) then
				v95 = 0;
				for v135, v136 in pairs(v93) do
					if (not v136:DebuffUp(v65.BloodPlagueDebuff) or (2602 < 1496)) then
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
			if ((0 == v98) or (1020 > 2288)) then
				if ((328 == 328) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\154\241\2\81\139\173\215\2\87\134\173\231", "\227\222\148\99\37")]:IsReady()) then
					if ((1511 < 3808) and v20(v65.DeathsCaress, nil, nil, not v15:IsSpellInRange(v65.DeathsCaress))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\87\83\226\241\32\109\81\247\235\54\65\65\182\233\33\87\81\249\244\49\83\70\182\173", "\153\83\50\50\150");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\112\119\97\14\124\188\95\88\120\119", "\45\61\22\19\124\19\203")]:IsReady() or (2510 > 4919)) then
					if ((4763 == 4763) and v20(v65.Marrowrend, nil, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\19\31\231\13\103\171\196\28\9\181\18\98\188\194\29\0\247\3\100\249\151", "\217\161\114\109\149\98\16");
					end
				end
				break;
			end
		end
	end
	local function v85()
		local v99 = 0;
		while true do
			if ((4137 > 1848) and (v99 == 0)) then
				if ((2436 <= 3134) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\32\53\54\121\136\117\2", "\20\114\64\88\28\220")]:IsReady() and v73 and (v14:HealthPercentage() <= v60) and (v14:Rune() >= 3) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\3\20\220\177\204\209\173", "\221\81\97\178\212\152\176")]:Charges() >= 1) and v14:BuffDown(v65.RuneTapBuff)) then
					if ((3723 == 3723) and v20(v65.RuneTap, v59)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\223\242\19\254\37\217\230\13\187\30\200\225\24\245\9\196\241\24\232\90\159", "\122\173\135\125\155");
					end
				end
				if ((v14:ActiveMitigationNeeded() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\169\192\18\171\48\38\218\129\207\4", "\168\228\161\96\217\95\81")]:TimeSinceLastCast() > 2.5) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\255\212\47\72\39\100\207\195\39\87\42", "\55\187\177\78\60\79")]:TimeSinceLastCast() > 2.5)) or (4046 >= 4316)) then
					local v137 = 0;
					while true do
						if ((v137 == 1) or (2008 < 1929)) then
							if ((2384 > 1775) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\215\116\247\24\24\121\231\99\255\7\21", "\42\147\17\150\108\112")]:IsReady()) then
								if (v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike)) or (4543 <= 4376)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\11\163\44\107\239\215\28\178\63\118\236\237\79\162\40\121\226\230\28\175\59\122\244\168\94\246", "\136\111\198\77\31\135");
								end
							end
							break;
						end
						if ((728 == 728) and (v137 == 0)) then
							if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\9\203\94\255\78\252\148\63\199\84\238", "\224\77\174\63\139\38\175")]:IsReady() and (v14:BuffStack(v65.BoneShieldBuff) > 7)) or (1076 > 4671)) then
								if ((1851 >= 378) and v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\128\68\89\58\140\126\75\58\150\72\83\43\196\69\93\40\129\79\75\39\146\68\75\110\208", "\78\228\33\56");
								end
							end
							if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\227\127\160\17\138\217\108\183\13\129", "\229\174\30\210\99")]:IsReady() or (1948 >= 3476)) then
								if ((4794 >= 833) and v20(v65.Marrowrend, nil, nil, not v15:IsInMeleeRange(5))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\22\236\148\67\226\42\43\30\227\130\17\233\56\63\30\227\149\88\251\56\42\91\187", "\89\123\141\230\49\141\93");
								end
							end
							v137 = 1;
						end
					end
				end
				v99 = 1;
			end
			if ((4090 == 4090) and (v99 == 1)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\52\8\170\70\180\246\30\170\32\5\168\89\185", "\201\98\105\199\54\221\132\119")]:IsCastable() and v73 and (v14:HealthPercentage() <= v61) and v14:BuffDown(v65.IceboundFortitudeBuff)) or (3758 == 2498)) then
					if (v20(v65.VampiricBlood, v57) or (2673 < 1575)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\175\13\142\49\11\39\165\186\51\129\45\13\58\168\249\8\134\39\7\59\191\176\26\134\50\66\100\248", "\204\217\108\227\65\98\85");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\119\192\240\231\35\213\80\199\211\234\62\212\87\215\224\225\41", "\160\62\163\149\133\76")]:IsCastable() and v73 and (v14:HealthPercentage() <= IceboundFortitudeThreshold) and v14:BuffDown(v65.VampiricBloodBuff)) or (3721 <= 1455)) then
					if ((934 < 2270) and v20(v65.IceboundFortitude, v55)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\223\163\8\45\204\195\174\9\16\197\217\178\25\38\215\195\164\8\111\199\211\166\8\33\208\223\182\8\60\131\135\246", "\163\182\192\109\79");
					end
				end
				v99 = 2;
			end
			if ((2 == v99) or (1612 == 1255)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\16\35\1\212\253\7\50\18\201\254\49", "\149\84\70\96\160")]:IsReady() and (v14:HealthPercentage() <= (50 + (((v14:RunicPower() > v69) and 20) or 0))) and not v14:HealingAbsorbed()) or (4352 < 4206)) then
					if (v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike)) or (2860 <= 181)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\3\12\249\48\57\30\249\42\15\6\232\120\2\8\235\61\8\30\228\46\3\30\173\105\94", "\141\88\102\109");
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
			if ((3222 >= 1527) and (v100 == 3)) then
				if ((1505 <= 2121) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\100\77\198\172\240\252\84\69\194\168\229", "\168\38\44\161\195\150")]:IsCastable()) then
					if ((744 == 744) and v20(v65.BagofTricks, v50, nil, not v15:IsSpellInRange(v65.BagofTricks))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\130\253\133\73\63\238\137\2\146\245\129\125\35\168\164\23\131\245\131\122\35\168\231\66", "\118\224\156\226\22\80\136\214");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\99\252\90\129\76\235\109\143\80\252\92\142\86", "\224\34\142\57")]:IsCastable() and (v14:RunicPowerDeficit() > 20)) or (1979 >= 2836)) then
					if ((1833 <= 2668) and v20(v65.ArcaneTorrent, v50, nil, not v15:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\223\181\198\220\125\244\98\26\209\181\215\216\125\229\29\28\223\164\204\220\127\226\29\95\136", "\110\190\199\165\189\19\145\61");
					end
				end
				break;
			end
			if ((3686 == 3686) and (v100 == 0)) then
				if ((3467 > 477) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\145\95\197\127\30\27\64\211\170", "\161\211\51\170\16\122\93\53")]:IsCastable() and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\223\175\188\43\242\160\181\26\238\160\183\31\254\175\162\39\245", "\72\155\206\210")]:CooldownUp() and (not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\100\118\91\1\55\66\104\93\0\56\67\104", "\83\38\26\52\110")]:IsReady() or not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\122\27\40\73\92\19\53\79\86\28\34\84", "\38\56\119\71")]:IsAvailable())) then
					if (v20(v65.BloodFury, v50) or (3288 >= 3541)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\241\227\87\217\33\105\245\250\74\207\101\68\242\236\81\215\41\69\179\189", "\54\147\143\56\182\69");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\244\132\237\90\218\196\138\246\71\216", "\191\182\225\159\41")]:IsCastable() or (3557 == 4540)) then
					if (v20(v65.Berserking, v50) or (261 > 1267)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\41\23\58\70\142\149\201\34\28\47\21\153\134\193\34\19\36\70\203\211", "\162\75\114\72\53\235\231");
					end
				end
				v100 = 1;
			end
			if ((1272 < 3858) and (v100 == 2)) then
				if ((3664 == 3664) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\113\175\246\38\87\58\66\160\249\0\69\34\92", "\78\48\193\149\67\36")]:IsCastable()) then
					if ((1941 >= 450) and v20(v65.AncestralCall, v50)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\16\131\29\82\36\12\129\20\126\51\31\140\20\1\34\31\131\17\64\60\13\192\73\17", "\33\80\126\224\120");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\202\161\17\193\94\224\167\12\192", "\60\140\200\99\164")]:IsCastable() or (4646 < 324)) then
					if ((3833 == 3833) and v20(v65.Fireblood, v50)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\253\22\35\160\139\251\11\34\226\149\245\7\47\163\139\231\68\119\240", "\194\231\148\100\70");
					end
				end
				v100 = 3;
			end
			if ((v100 == 1) or (1240 > 3370)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\173\46\71\227\93\7\188\41\72\241\86", "\98\236\92\36\130\51")]:IsCastable() and ((v75 >= 2) or ((v14:Rune() < 1) and (v14:RunicPowerDeficit() > 60)))) or (2481 == 4682)) then
					if ((4727 >= 208) and v20(v65.ArcanePulse, v50, nil, not v15:IsInRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\11\15\187\75\173\138\32\177\21\31\191\5\186\180\51\173\24\0\169\5\254", "\80\196\121\108\218\37\200\213");
					end
				end
				if ((280 < 3851) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\44\122\5\119\95\29\160\21\119\5\114\78\0\158", "\234\96\19\98\31\43\110")]:IsCastable() and (v14:BuffUp(v65.UnholyStrengthBuff))) then
					if (v20(v65.LightsJudgment, v50, nil, not v15:IsSpellInRange(v65.LightsJudgment)) or (3007 > 3194)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\22\85\207\184\97\180\12\10\86\192\161\119\133\18\95\64\198\175\123\138\10\12\18\159", "\235\102\127\50\167\204\18");
					end
				end
				v100 = 2;
			end
		end
	end
	local function v88()
		local v101 = 0;
		while true do
			if ((v101 == 2) or (2136 >= 2946)) then
				if ((2165 <= 2521) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\160\45\167\213\208\114\188\128\12\163\194\217\74", "\210\228\72\198\161\184\51")]:IsReady() and v14:BuffDown(v65.DeathAndDecayBuff) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\5\72\253\23\102\199\56\76\212\2\124\219\56\77", "\174\86\41\147\112\19")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\110\14\133\4\41\22\54\185\84\21\131\15", "\203\59\96\237\107\69\111\113")]:IsAvailable())) then
					if ((2861 > 661) and v20(v67.DaDPlayer, v46, nil, not v15:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\32\19\173\245\57\207\214\42\18\147\229\52\243\214\61\86\168\243\38\207\194\52\86\253\183", "\183\68\118\204\129\81\144");
					end
				end
				if ((4525 > 4519) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\44\161\127\235\15\160\1\164\124", "\226\110\205\16\132\107")]:IsCastable() and (v75 > 2) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\201\207\239\214\69\201\204\233\213", "\33\139\163\128\185")]:ChargesFractional() >= 1.1)) then
					if ((3178 > 972) and v20(v65.BloodBoil, nil, not v15:IsInMeleeRange(10))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\84\11\209\83\103\6\209\94\84\68\218\69\79\59\203\71\24\85\134", "\190\55\56\100");
					end
				end
				v72 = 25 + (v76 * v22(v65[LUAOBFUSACTOR_DECRYPT_STR_0("\126\170\61\12\7\225\225\83\174\55\27\1", "\147\54\207\92\126\115\131")]:IsAvailable()) * 2);
				v101 = 3;
			end
			if ((4766 == 4766) and (3 == v101)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\41\52\52\105\5\77\25\35\60\118\8", "\30\109\81\85\29\109")]:IsReady() and ((v14:RunicPowerDeficit() <= v72) or (v14:RunicPower() >= v69))) or (2745 > 3128)) then
					if (v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike)) or (1144 >= 4606)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\116\85\162\62\225\239\235\99\93\189\51\158\248\237\102\107\163\38\158\174\175", "\156\159\17\52\214\86\190");
					end
				end
				if ((3338 >= 277) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\141\224\179\175\187\226\173\168\167\224\179", "\220\206\143\221")]:IsCastable()) then
					if ((2610 > 2560) and v20(v65.Consumption, nil, not v15:IsSpellInRange(v65.Consumption))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\133\114\35\4\205\193\194\146\116\34\25\152\200\192\145\66\56\7\152\158\128", "\178\230\29\77\119\184\172");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\215\178\5\20\115\218\250\183\6", "\152\149\222\106\123\23")]:IsReady() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\255\42\249\76\177\255\41\255\79", "\213\189\70\150\35")]:ChargesFractional() >= 1.1) and (v14:BuffStack(v65.HemostasisBuff) < 5)) or (1194 > 3083)) then
					if ((916 >= 747) and v20(v65.BloodBoil, nil, nil, not v15:IsInMeleeRange(10))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\77\89\123\7\75\106\118\7\70\89\52\12\93\66\75\29\95\21\38\92", "\104\47\53\20");
					end
				end
				v101 = 4;
			end
			if ((v101 == 0) or (2444 > 2954)) then
				if ((2892 < 3514) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\248\231\120\231\143\229\213\226\123", "\167\186\139\23\136\235")]:IsReady() and (v15:DebuffDown(v65.BloodPlagueDebuff))) then
					if ((533 == 533) and v20(v65.BloodBoil, nil, nil, not v15:IsInMeleeRange(10))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\185\135\2\30\138\138\2\19\185\200\9\8\162\183\24\10\245\218", "\109\122\213\232");
					end
				end
				if ((595 <= 3413) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\218\248\175\50\253\227\173\62\235", "\80\142\151\194")]:IsReady() and (v14:BuffStack(v65.BoneShieldBuff) > 5) and (v14:Rune() >= 2) and (v14:RunicPowerDeficit() >= 30) and (not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\48\206\118\88\23\195\101\69\13\193\85\67\13\195", "\44\99\166\23")]:IsAvailable() or (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\79\255\40\34\39\161\110\254\39\49\17\171\114\242", "\196\28\151\73\86\83")]:IsAvailable() and v14:BuffUp(v65.DeathAndDecayBuff)))) then
					if ((3078 >= 2591) and v20(v65.Tombstone)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\231\12\36\18\145\76\23\120\246\67\45\2\149\103\13\102\179\87", "\22\147\99\73\112\226\56\120");
					end
				end
				if ((3199 < 4030) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\156\112\227\225\133\139\97\240\252\134\189", "\237\216\21\130\149")]:IsReady() and ((v14:BuffRemains(v65.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v65.IcyTalonsBuff) <= v14:GCD()))) then
					if ((777 < 2078) and v20(v65.DeathStrike, v54, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\75\94\75\184\246\77\150\92\86\84\181\137\90\144\89\96\74\160\137\8", "\62\226\46\63\63\208\169");
					end
				end
				v101 = 1;
			end
			if ((1696 <= 2282) and (v101 == 1)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\200\24\71\145\16\26\61\91\235\29", "\62\133\121\53\227\127\109\79")]:IsReady() and ((v14:BuffRemains(v65.BoneShieldBuff) <= 4) or (v14:BuffStack(v65.BoneShieldBuff) < v70)) and (v14:RunicPowerDeficit() > 20)) or (1761 >= 2462)) then
					if ((4551 > 2328) and v20(v65.Marrowrend, nil, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\29\21\32\231\217\185\176\21\26\54\181\210\188\181\47\1\34\181\135\254", "\194\112\116\82\149\182\206");
					end
				end
				if ((3825 >= 467) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\10\167\89\20\242\231\15\41\173\94", "\110\89\200\44\120\160\130")]:IsReady() and (v75 == 1) and ((v15:TimeToX(35) < 5) or (v15:HealthPercentage() <= 35)) and (v15:TimeToDie() > (v15:DebuffRemains(v65.SoulReaperDebuff) + 5))) then
					if (v20(v65.SoulReaper, nil, nil, not v15:IsInMeleeRange(5)) or (2890 == 557)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\184\204\94\74\124\88\62\76\187\198\89\6\71\88\44\114\190\211\11\23\17", "\45\203\163\43\38\35\42\91");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\225\138\201\47\181\172\85\194\128\206", "\52\178\229\188\67\231\201")]:IsReady() and (v75 >= 2)) or (4770 == 2904)) then
					if (v79.CastTargetIf(v65.SoulReaper, v74, LUAOBFUSACTOR_DECRYPT_STR_0("\44\72\94", "\67\65\33\48\100\151\60"), v82, v83, not v15:IsInMeleeRange(5)) or (3903 == 4536)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\232\187\212\204\205\226\175\200\246\205\167\170\202\228\224\242\190\152\162\139", "\147\191\135\206\184");
					end
				end
				v101 = 2;
			end
			if ((4093 <= 4845) and (4 == v101)) then
				if ((1569 <= 3647) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\139\73\128\14\168\60\183\94\136\23\185", "\111\195\44\225\124\220")]:IsReady() and ((v14:RuneTimeToX(2) < v14:GCD()) or (v14:RunicPowerDeficit() >= v72))) then
					if (v20(v65.HeartStrike, nil, nil, not v15:IsSpellInRange(v65.HeartStrike)) or (4046 >= 4927)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\67\1\97\191\148\203\82\18\122\160\174\152\66\18\100\148\190\200\6\82\37", "\203\184\38\96\19\203");
					end
				end
				break;
			end
		end
	end
	local function v89()
		local v102 = 0;
		while true do
			if ((4623 >= 2787) and (v102 == 1)) then
				if ((2234 >= 1230) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\95\57\190\84\185\200\82\164\105\57\172\83", "\197\27\92\223\32\209\187\17")]:IsReady() and ((v14:BuffRemains(v65.BoneShieldBuff) <= 4) or (v14:BuffStack(v65.BoneShieldBuff) < (v70 + 1))) and (v14:RunicPowerDeficit() > 10) and not (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\42\81\208\250\23\86\194\249\15\90\225\247\2\91\198", "\155\99\63\163")]:IsAvailable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\166\208\175\142\176\138\133\227\180\131\188\179\135\208\177\130\183", "\228\226\177\193\237\217")]:CooldownRemains() < v14:BuffRemains(v65.BoneShieldBuff))) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\23\191\45\245\33\189\51\242\61\191\45", "\134\84\208\67")]:IsAvailable() and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\49\160\137\83\23\168\148\85\29\167\131\78", "\60\115\204\230")]:IsAvailable() and (v14:RuneTimeToX(3) > v14:GCD())) then
					if (v20(v65.DeathsCaress, nil, nil, not v15:IsSpellInRange(v65.DeathsCaress)) or (343 == 1786)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\63\234\100\239\41\212\115\230\40\238\99\244\122\248\100\230\52\239\113\245\62\171\38", "\16\135\90\139");
					end
				end
				if ((2570 > 2409) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\121\117\20\33\65\67\106\81\122\2", "\24\52\20\102\83\46\52")]:IsReady() and ((v14:BuffRemains(v65.BoneShieldBuff) <= 4) or (v14:BuffStack(v65.BoneShieldBuff) < v70)) and (v14:RunicPowerDeficit() > 20) and not (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\237\33\50\37\27\205\46\35\40\10\230\35\32\32\10", "\111\164\79\65\68")]:IsAvailable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\226\216\141\221\39\228\193\235\150\208\43\221\195\216\147\209\32", "\138\166\185\227\190\78")]:CooldownRemains() < v14:BuffRemains(v65.BoneShieldBuff)))) then
					if (v20(v65.Marrowrend, nil, nil, not v15:IsInMeleeRange(5)) or (2609 >= 3234)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\198\117\215\37\93\52\11\206\122\193\119\65\55\24\197\112\196\37\86\99\65", "\121\171\20\165\87\50\67");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\229\55\183\37\172\15\214\44\176\57\183", "\98\166\88\217\86\217")]:IsCastable() or (3033 >= 4031)) then
					if (v20(v65.Consumption, nil, not v15:IsSpellInRange(v65.Consumption)) or (1401 == 4668)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\249\119\18\147\209\230\226\112\14\136\156\229\226\120\15\130\221\228\242\57\80\214", "\188\150\150\25\97\230");
					end
				end
				v102 = 2;
			end
			if ((2776 >= 1321) and (v102 == 0)) then
				if ((v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\13\124\116\67\221\45\124\119\68", "\174\89\19\25\33")]:IsCastable() and (v14:BuffStack(v65.BoneShieldBuff) > 5) and (v14:Rune() >= 2) and (v14:RunicPowerDeficit() >= 30) and (not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\28\26\83\90\227\130\25\38\28\85\108\248\137\14", "\107\79\114\50\46\151\231")]:IsAvailable() or (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\10\174\180\61\158\60\165\201\55\161\151\38\132\60", "\160\89\198\213\73\234\89\215")]:IsAvailable() and v14:BuffUp(v65.DeathAndDecayBuff))) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\108\112\186\253\204\70\118\134\235\203\77\70\177\255\213\71\127", "\165\40\17\212\158")]:CooldownRemains() >= 25)) or (487 > 2303)) then
					if (v20(v65.Tombstone) or (4503 == 3462)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\241\214\5\49\53\241\214\6\54\102\246\205\9\61\34\228\203\12\115\116", "\70\133\185\104\83");
					end
				end
				v71 = 10 + (v75 * v22(v65[LUAOBFUSACTOR_DECRYPT_STR_0("\44\64\69\56\221\6\87\65\43\194\1\87", "\169\100\37\36\74")]:IsAvailable()) * 2);
				if ((553 <= 1543) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\36\130\163\68\8\180\182\66\9\140\167", "\48\96\231\194")]:IsReady() and ((v14:BuffRemains(v65.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v65.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v69) or (v14:RunicPowerDeficit() <= v71) or (v15:TimeToDie() < 10))) then
					if ((2015 == 2015) and v20(v65.DeathStrike, v54, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\95\15\57\17\231\188\151\218\83\5\40\89\203\187\130\198\94\15\63\29\152\251", "\227\168\58\110\77\121\184\207");
					end
				end
				v102 = 1;
			end
			if ((v102 == 3) or (4241 <= 2332)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\38\227\171\204\53\120\11\230\168", "\58\100\143\196\163\81")]:IsCastable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\56\78\44\172\59\107\234\7\22", "\110\122\34\67\195\95\41\133")]:ChargesFractional() >= 1.8) and ((v14:BuffStack(v65.HemostasisBuff) <= (5 - v75)) or (v64 > 2))) or (2364 < 1157)) then
					if (v20(v65.BloodBoil, nil, not v15:IsInMeleeRange(10)) or (1167 > 1278)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\119\189\84\69\210\74\179\84\67\218\53\162\79\75\216\113\176\73\78\150\36\233", "\182\21\209\59\42");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\159\82\196\15\53\141\163\69\204\22\36", "\222\215\55\165\125\65")]:IsReady() and (v14:RuneTimeToX(4) < v14:GCD())) or (1145 <= 1082)) then
					if (v20(v65.HeartStrike, nil, nil, not v15:IsSpellInRange(v65.HeartStrike)) or (3105 == 4881)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\36\212\199\8\230\254\254\94\62\216\205\31\178\210\249\75\34\213\199\8\246\129\191\26", "\42\76\177\166\122\146\161\141");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\135\134\10\193\125\84\170\131\9", "\22\197\234\101\174\25")]:IsCastable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\15\56\170\211\114\141\216\143\33", "\230\77\84\197\188\22\207\183")]:ChargesFractional() >= 1.1)) or (1887 > 4878)) then
					if (v20(v65.BloodBoil, nil, not v15:IsInMeleeRange(10)) or (4087 > 4116)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\24\201\243\136\158\242\58\240\24\134\239\152\160\254\49\248\6\194\188\222\243", "\85\153\116\166\156\236\193\144");
					end
				end
				v102 = 4;
			end
			if ((1106 <= 1266) and (2 == v102)) then
				if ((3155 < 4650) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\233\134\74\14\62\232\219\153\90\16", "\141\186\233\63\98\108")]:IsReady() and (v75 == 1) and ((v15:TimeToX(35) < 5) or (v15:HealthPercentage() <= 35)) and (v15:TimeToDie() > (v15:DebuffRemains(v65.SoulReaperDebuff) + 5))) then
					if ((3774 >= 1839) and v20(v65.SoulReaper, nil, nil, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\229\57\186\26\227\239\45\166\32\227\170\63\162\36\255\238\45\164\33\177\187\126", "\69\145\138\76\214");
					end
				end
				if ((2811 == 2811) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\67\192\156\133\141\19\113\223\140\155", "\118\16\175\233\233\223")]:IsReady() and (v75 >= 2)) then
					if ((2146 > 1122) and v79.CastTargetIf(v65.SoulReaper, v74, LUAOBFUSACTOR_DECRYPT_STR_0("\134\141\59", "\29\235\228\85\219\142\235"), v82, v83, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\219\175\209\72\92\34\83\45\209\168\157\100\90\38\92\57\213\168\217\55\31\115", "\50\93\180\218\189\23\46\71");
					end
				end
				if ((v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\252\171\85\73\87\200\71\204\169", "\40\190\196\59\44\36\188")]:IsReady() and (v14:RunicPower() >= 100)) or (56 == 3616)) then
					if (v20(v65.Bonestorm, nil, not v15:IsInMeleeRange(8)) or (2421 < 622)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\74\210\177\233\105\2\46\72\156\167\238\124\3\56\68\206\176\186\44\91", "\109\92\37\188\212\154\29");
					end
				end
				v102 = 3;
			end
			if ((1009 <= 1130) and (v102 == 4)) then
				if ((2758 < 2980) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\140\229\76\161\240\51\176\242\68\184\225", "\96\196\128\45\211\132")]:IsReady() and (v14:Rune() > 1) and ((v14:RuneTimeToX(3) < v14:GCD()) or (v14:BuffStack(v65.BoneShieldBuff) > 7))) then
					if (v20(v65.HeartStrike, nil, nil, not v15:IsSpellInRange(v65.HeartStrike)) or (86 >= 3626)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\136\122\77\198\144\167\204\39\132\112\90\146\188\160\217\59\137\122\77\214\239\230\140", "\184\85\237\27\63\178\207\212");
					end
				end
				break;
			end
		end
	end
	local function v90()
		local v103 = 0;
		while true do
			if ((2395 == 2395) and (0 == v103)) then
				v63();
				v27 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\60\86\14\88\4\92\26", "\63\104\57\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\136\167", "\36\107\231\196")];
				v103 = 1;
			end
			if ((3780 > 2709) and (v103 == 2)) then
				v74 = v14:GetEnemiesInMeleeRange(5);
				if (v28 or (237 >= 2273)) then
					v75 = ((#v74 > 0) and #v74) or 1;
				else
					local v138 = 0;
					while true do
						if ((v138 == 0) or (2040 <= 703)) then
							v75 = 1;
							v64 = 1;
							break;
						end
					end
				end
				v103 = 3;
			end
			if ((3279 <= 3967) and (v103 == 3)) then
				v76 = v24(v75, (v14:BuffUp(v65.DeathAndDecayBuff) and 5) or 2);
				v77 = v81(v74);
				v103 = 4;
			end
			if ((v103 == 1) or (1988 == 877)) then
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\186\165\128\81\176\177", "\231\61\213\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\8\162\56", "\19\105\205\93")];
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\157\7\217\134\51\172\27", "\95\201\104\190\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\172\207\210", "\174\207\171\161")];
				v103 = 2;
			end
			if ((4291 > 1912) and (v103 == 4)) then
				v73 = v14:IsTankingAoE(8) or v14:IsTanking(v15);
				if ((2003 < 2339) and v79.TargetIsValid()) then
					local v139 = 0;
					local v140;
					while true do
						if ((432 == 432) and (v139 == 6)) then
							if ((v14:BuffUp(v65.DancingRuneWeaponBuff)) or (1145 >= 1253)) then
								local v141 = 0;
								local v142;
								while true do
									if ((3418 > 2118) and (v141 == 1)) then
										if ((3066 <= 3890) and v10.CastAnnotated(v65.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\63\29\51\116", "\157\104\92\122\32\100\109"))) then
											return "Wait/Pool for DRWUp";
										end
										break;
									end
									if ((0 == v141) or (2998 >= 3281)) then
										v142 = v88();
										if (v142 or (4649 <= 2632)) then
											return v142;
										end
										v141 = 1;
									end
								end
							end
							v140 = v89();
							if (v140 or (3860 > 4872)) then
								return v140;
							end
							v139 = 7;
						end
						if ((v139 == 3) or (3998 == 2298)) then
							if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\160\82\255\78\140\100\234\72\141\92\251", "\58\228\55\158")]:IsReady() and ((v14:BuffRemains(v65.CoagulopathyBuff) <= v14:GCD()) or (v14:BuffRemains(v65.IcyTalonsBuff) <= v14:GCD()) or (v14:RunicPower() >= v69) or (v14:RunicPowerDeficit() <= v71) or (v15:TimeToDie() < 10))) or (8 >= 2739)) then
								if ((2590 == 2590) and v20(v65.DeathStrike, v54, nil, not v15:IsSpellInRange(v65.DeathStrike))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\176\140\209\58\52\146\38\160\155\217\37\57\237\56\181\128\222\110\109\253", "\85\212\233\176\78\92\205");
								end
							end
							if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\104\84\135\237\78\92\154\235\68\83\141\240", "\130\42\56\232")]:IsReady() and (v14:BuffDown(v65.DancingRuneWeaponBuff))) or (82 >= 1870)) then
								if ((2624 < 4557) and v20(v65.Blooddrinker, nil, nil, not v15:IsSpellInRange(v65.Blooddrinker))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\232\185\43\236\68\59\248\188\42\232\69\45\170\184\37\234\78\127\187\231", "\95\138\213\68\131\32");
								end
							end
							if (v29 or (3131 > 3542)) then
								local v143 = 0;
								local v144;
								while true do
									if ((2577 >= 1578) and (v143 == 0)) then
										v144 = v87();
										if ((4103 <= 4571) and v144) then
											return v144;
										end
										break;
									end
								end
							end
							v139 = 4;
						end
						if ((v139 == 1) or (1495 == 4787)) then
							v69 = v62;
							if (v31 or (310 > 4434)) then
								local v145 = 0;
								local v146;
								while true do
									if ((2168 <= 4360) and (v145 == 0)) then
										v146 = v86();
										if ((994 == 994) and v146) then
											return v146;
										end
										break;
									end
								end
							end
							if ((1655 > 401) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\217\196\184\242\203\207\192\176\229", "\174\139\165\209\129")]:IsCastable()) then
								if ((3063 <= 3426) and v20(v65.RaiseDead, nil)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\177\178\235\210\195\60\116\125\162\183\162\204\199\10\126\56\247", "\24\195\211\130\161\166\99\16");
								end
							end
							v139 = 2;
						end
						if ((1459 > 764) and (v139 == 0)) then
							if (not v14:AffectingCombat() or (641 > 4334)) then
								local v147 = 0;
								local v148;
								while true do
									if ((3399 >= 2260) and (0 == v147)) then
										v148 = v84();
										if (v148 or (393 >= 4242)) then
											return v148;
										end
										break;
									end
								end
							end
							if ((989 < 4859) and v73) then
								local v149 = 0;
								local v150;
								while true do
									if ((v149 == 0) or (4795 < 949)) then
										v150 = v85();
										if ((3842 == 3842) and v150) then
											return v150;
										end
										break;
									end
								end
							end
							if ((1747 <= 3601) and v14:IsChanneling(v65.Blooddrinker) and v14:BuffUp(v65.BoneShieldBuff) and (v77 == 0) and not v14:ShouldStopCasting() and (v14:CastRemains() > 0.2)) then
								if (v10.CastAnnotated(v65.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\218\223\36\199", "\183\141\158\109\147\152")) or (804 > 4359)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\28\6\233\0\108\45\243\30\37\7\225\76\14\5\233\3\40\13\244\5\34\2\227\30", "\108\76\105\134");
								end
							end
							v139 = 1;
						end
						if ((4670 >= 3623) and (v139 == 5)) then
							if ((2065 < 2544) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\192\176\71\63\216\49\247\143\66\62\202\3\224\188\71\63\193", "\84\133\221\55\80\175")]:IsCastable() and (v14:Rune() < 6) and (v14:RunicPowerDeficit() > 5)) then
								if ((1311 <= 3359) and v20(v65.EmpowerRuneWeapon, v47)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\184\234\52\169\208\89\175\216\54\179\201\89\130\240\33\167\215\83\179\167\41\167\206\82\253\181\116", "\60\221\135\68\198\167");
								end
							end
							if ((2717 <= 3156) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\207\191\247\142\75\215\239\169\241\140\76\245\231\176\250", "\185\142\221\152\227\34")]:IsCastable()) then
								if ((1081 < 4524) and v20(v65.AbominationLimb, nil, not v15:IsInRange(20))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\89\199\88\247\74\61\246\76\204\88\244\124\63\254\85\199\23\247\66\58\249\24\151\5", "\151\56\165\55\154\35\83");
								end
							end
							if ((440 >= 71) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\132\66\11\237\169\77\2\220\181\77\0\217\165\66\21\225\174", "\142\192\35\101")]:IsCastable() and (v14:BuffDown(v65.DancingRuneWeaponBuff))) then
								if ((4934 > 2607) and v20(v65.DancingRuneWeapon, v53)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\210\116\39\160\238\130\171\41\196\96\39\166\216\155\169\23\198\122\39\227\234\141\165\24\150\39\125", "\118\182\21\73\195\135\236\204");
								end
							end
							v139 = 6;
						end
						if ((2 == v139) or (1400 > 3116)) then
							if ((525 < 1662) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\112\2\228\60\90\4\79\0\203\32\92\25\66", "\118\38\99\137\76\51")]:IsCastable() and v14:BuffDown(v65.VampiricBloodBuff) and v14:BuffDown(v65.VampiricStrengthBuff)) then
								if (v20(v65.VampiricBlood, v57) or (876 > 2550)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\235\39\8\2\0\50\244\37\58\16\5\47\242\34\69\31\8\41\243\102\80", "\64\157\70\101\114\105");
								end
							end
							if ((219 <= 2456) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\100\173\166\247\24\83\139\166\241\21\83\187", "\112\32\200\199\131")]:IsReady() and (v14:BuffDown(v65.BoneShieldBuff))) then
								if (v20(v65.DeathsCaress, nil, nil, not v15:IsSpellInRange(v65.DeathsCaress)) or (4219 == 1150)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\40\85\93\172\203\184\29\47\81\78\189\208\184\98\33\81\85\182\131\253", "\66\76\48\60\216\163\203");
								end
							end
							if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\158\131\120\231\87\239\42\190\162\124\240\94\215", "\68\218\230\25\147\63\174")]:IsReady() and v14:BuffDown(v65.DeathAndDecayBuff) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\152\36\91\67\186\180\13\65\67\163\163\46", "\214\205\74\51\44")]:IsAvailable() or v65[LUAOBFUSACTOR_DECRYPT_STR_0("\201\77\236\251\98\243\66\231\219\101\245\89\236\248", "\23\154\44\130\156")]:IsAvailable() or (v75 > 3) or v14:BuffUp(v65.CrimsonScourgeBuff))) or (2989 <= 222)) then
								if ((2258 > 1241) and v20(v67.DaDPlayer, v46, nil, not v15:IsInRange(30))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\21\163\172\186\62\44\16\168\169\145\50\22\18\167\180\238\59\18\24\168\237\246", "\115\113\198\205\206\86");
								end
							end
							v139 = 3;
						end
						if ((41 < 4259) and (v139 == 7)) then
							if (v10.CastAnnotated(v65.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\148\135\230\254", "\203\195\198\175\170\93\71\237")) or (1930 < 56)) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((3333 == 3333) and (v139 == 4)) then
							if ((v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\25\41\162\81\127\44\33\162\74\119\38\24\160\64\98", "\22\74\72\193\35")]:IsReady() and v78.GhoulActive() and v14:BuffDown(v65.DancingRuneWeaponBuff) and ((v78.GhoulRemains() < 2) or (v15:TimeToDie() < v14:GCD()))) or (2225 == 20)) then
								if (v20(v65.SacrificialPact, v48) or (872 >= 3092)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\63\120\231\74\37\127\237\91\37\120\232\103\60\120\231\76\108\116\229\81\34\57\181\12", "\56\76\25\132");
								end
							end
							if ((4404 >= 3252) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\124\205\164\41\203\106\192\187", "\175\62\161\203\70")]:IsCastable() and (((v14:Rune() <= 2) and (v14:RuneTimeToX(4) > v14:GCD()) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\30\209\204\28\49\8\220\211", "\85\92\189\163\115")]:ChargesFractional() >= 1.8)) or (v14:RuneTimeToX(3) > v14:GCD()))) then
								if ((1107 > 796) and v20(v65.BloodTap, v58)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\43\160\63\55\45\147\36\57\57\236\61\57\32\162\112\105\127", "\88\73\204\80");
								end
							end
							if ((959 == 959) and v29 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\9\140\2\67\47\211\43\141\20\85\14\200\47\144\0", "\186\78\227\112\38\73")]:IsCastable() and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\200\94\250\93\71\127\242\94\243\82\116\104\253\68\237", "\26\156\55\157\53\51")]:IsAvailable())) then
								if (v20(v65.GorefiendsGrasp, nil, not v15:IsSpellInRange(v65.GorefiendsGrasp)) or (245 >= 2204)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\139\215\4\220\190\89\137\214\18\202\135\87\158\217\5\201\248\93\141\209\24\153\233\8", "\48\236\184\118\185\216");
								end
							end
							v139 = 5;
						end
					end
				end
				break;
			end
		end
	end
	local function v91()
		local v104 = 0;
		while true do
			if ((3162 >= 2069) and (v104 == 0)) then
				v65[LUAOBFUSACTOR_DECRYPT_STR_0("\3\74\44\222\94\23\218\55\89\63\217\80\5\244\10\78\60\192\87\23", "\156\78\43\94\181\49\113")]:RegisterAuraTracking();
				v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\80\228\203\172\15\3\93\89\168\198\186\75\102\105\123\235\138\227\60\76\107\121\168\205\173\75\83\107\125\239\214\166\24\80\57\85\231\206\170\25\66", "\25\18\136\164\195\107\35"));
				break;
			end
		end
	end
	v10.SetAPL(250, v90, v91);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\205\61\160\87\77\152\196\185\252\37\130\65\123\187\201\172\215\15\165\64\125\184\143\180\253\44", "\216\136\77\201\47\18\220\161")]();

