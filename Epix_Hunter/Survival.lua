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
		if ((v5 == 0) or (2624 > 4149)) then
			v6 = v0[v4];
			if (not v6 or (2618 >= 4495)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (2485 >= 3131)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\147\210\16\197\198\201\26\213\174\213\8\216\213\218\41\168\183\210\31", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicLib;
	local v10 = EpicCache;
	local v11 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\22\195\35\209", "\156\67\173\74\165")];
	local v12 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\4\187\72\15\185\52", "\38\84\215\41\118\220\70")];
	local v13 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\100\23\48\21\251\68", "\158\48\118\66\114")];
	local v14 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\141\43\19\35\96", "\155\203\68\112\86\19\197")];
	local v15 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\107\210\35\239\69\87\243\253\84", "\152\38\189\86\156\32\24\133")];
	local v16 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\204\82\179", "\38\156\55\199")];
	local v17 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\155\109\121\36\31", "\35\200\29\28\72\115\20\154")];
	local v18 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\52\170\221\203\132\31\36\28\179\221", "\84\121\223\177\191\237\76")];
	local v19 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\107\75\14\33", "\69\41\34\96")];
	local v21 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\145\194\212\24\13", "\75\220\163\183\106\98")];
	local v22 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\35\181\174\24\247", "\185\98\218\235\87")];
	local v23 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\232\24\52\201\240", "\202\171\92\71\134\190")];
	local v24 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\10\192\63\156", "\232\73\161\76")];
	local v25 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\139\203\71\78\13", "\126\219\185\34\61")];
	local v26 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\47\193\83\127\113\121\224", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\255\47\217\1\161\61\194", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\229\63", "\199\235\144\82\61\152")];
	local v27 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\36\25\180\38\8\24\170", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\66\117\6\160\17\201\81", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\33\47\140", "\156\168\78\64\224\212\121")];
	local v28 = false;
	local v29 = false;
	local v30 = false;
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
	local function v53()
		local v89 = 0;
		while true do
			if ((v89 == 5) or (2804 <= 2785)) then
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\174\196\102\38\205\74\183", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\49\123\59\60\243\230\180\35\108\31\48\242\224\182", "\143\216\66\30\126\68\155")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\205\25\223\204\173\208\242", "\129\202\168\109\171\165\195\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\64\63\209\210\21\244\35\76\62\215\208\60\214", "\134\66\56\87\184\190\116")] or 0;
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\52\29\175\16\229\38\38", "\85\92\81\105\219\121\139\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\160\85\113\110\222\243\162", "\191\157\211\48\37\28")];
				v89 = 6;
			end
			if ((v89 == 4) or (4571 == 3415)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\142\5\225\176\210\200\200", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\188\132\126\230\111\113\42\170", "\24\92\207\225\44\131\25")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\214\172\88\18\115\76\192", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\202\37\97\184\215\36\124\184\205", "\44\221\185\64")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\226\92\75\122\15\224\91", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\131\89\61\63\31\52\186\116\3", "\81\206\60\83\91\79")] or 0;
				v89 = 5;
			end
			if ((v89 == 6) or (4441 > 4787)) then
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\236\26\224\8\51\209\24\231", "\90\191\127\148\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\148\43\63\121\149\62\24\119\137", "\119\24\231\78")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\40\177\94\213\78\22\145", "\113\226\77\197\42\188\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\5\241\157\59\4\228\186\53\24\217\154", "\213\90\118\148")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\43\160\66\68\85\41\167", "\45\59\78\212\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\37\69\134\170\149\62\168\243\4\89\133\159\142\43\136\241\23\90\134", "\144\112\54\227\235\230\78\205")];
				break;
			end
			if ((1920 == 1920) and (3 == v89)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\225\196\242\63\218", "\30\222\146\161\162\90\174\210")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\53\126\241\85\78\104\37\103\207\86\79\76", "\32\56\64\19\156\58")] or 0;
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\108\69\78\206\97\131\130\7\109\68\74\237", "\107\57\54\43\157\21\230\231")];
				v89 = 4;
			end
			if ((2 == v89) or (647 == 4477)) then
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\17\19\214\164\110\147\196\11\48\218\162\116\181\192\10\9", "\230\180\127\103\179\214\28")] or 0;
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\5\65\164\249\218\188\189\62\74\186\242\248\164\160\5\65\186\226\220\184", "\175\204\201\113\36\214\139")] or 0;
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\118\173\133\33\191\109\169\148\7\165\106\188\147\59\162\116\189", "\83\205\24\217\224")] or 0;
				v89 = 3;
			end
			if ((3819 == 3819) and (v89 == 1)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\10\131\251\195\205\8\178\248\222\202\0\140\223\250", "\170\163\111\226\151")] or 0;
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\63\200\58\226\128\32\217\26\244\149\35\195\23", "\135\225\76\173\114")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\216\17\252\108\254\190\201\31\254\125\222\157", "\150\205\189\112\144\24")] or 0;
				v89 = 2;
			end
			if ((v89 == 0) or (1466 > 4360)) then
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\235\177\218\14\224\162\221", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\59\90\10\36\93\241\87\36\76", "\152\54\72\63\88\69\62")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\193\250\72\221\202\233\79", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\77\0\1\34\236\30\81\80\2\25\40\249\27\87\80", "\114\56\62\101\73\71\141")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\236\207\208\177\231\220\215", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\227\48\190\175\240\12\226\233\37\187\169\240\37\211\235\52", "\107\178\134\81\210\198\158")] or 0;
				v89 = 1;
			end
		end
	end
	local v54 = v9[LUAOBFUSACTOR_DECRYPT_STR_0("\144\39\2\241\223\85\160", "\59\211\72\111\156\176")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\145\230\63\87\136\237\40", "\77\46\231\131")];
	local v55 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\146\65\184\84\191\70", "\32\218\52\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\2\35\190\248\166\68\86", "\58\46\119\81\200\145\208\37")];
	local v56 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\3\153\62\184\172\175", "\86\75\236\80\204\201\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\65\84\101\147\247\157\115\77", "\235\18\33\23\229\158")];
	local v57 = {v56[LUAOBFUSACTOR_DECRYPT_STR_0("\113\182\198\190\68\178\192\169\96\175\219\161\92\191\227\180\72", "\219\48\218\161")]:ID(),v56[LUAOBFUSACTOR_DECRYPT_STR_0("\201\112\114\64\216\104\242\237\116\122\93\212\93\227\236", "\128\132\17\28\41\187\47")]:ID()};
	local v58 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\41\39\8\46\88\19", "\61\97\82\102\90")][LUAOBFUSACTOR_DECRYPT_STR_0("\159\59\185\93\206\65\31\5", "\105\204\78\203\43\167\55\126")];
	local v59 = v12:GetEquipment();
	local v60 = (v59[13] and v19(v59[13])) or v19(0);
	local v61 = (v59[14] and v19(v59[14])) or v19(0);
	v9:RegisterForEvent(function()
		local v90 = 0;
		while true do
			if ((v90 == 0) or (14 > 994)) then
				v59 = v12:GetEquipment();
				v60 = (v59[13] and v19(v59[13])) or v19(0);
				v90 = 1;
			end
			if ((401 <= 734) and (v90 == 1)) then
				v61 = (v59[14] and v19(v59[14])) or v19(0);
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\149\134\2\39\54\54\248\116\148\159\10\46\62\33\233\101\154\137\11\63\61\35\226\117", "\49\197\202\67\126\115\100\167"));
	local v62 = {v55[LUAOBFUSACTOR_DECRYPT_STR_0("\4\78\210\36\143\88\110\50\79", "\62\87\59\191\73\224\54")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\212\23\247\196\232\12\202\204\243\80", "\169\135\98\154")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\248\98\41\89\242\61\248\206\99\119", "\168\171\23\68\52\157\83")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\199\100\248\160\42\35\183\241\101\161", "\231\148\17\149\205\69\77")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\179\178\202\246\88\241\176\162\211\174", "\159\224\199\167\155\55")]};
	local v63, v64;
	local v65 = 11111;
	local v66 = 11111;
	local v67 = (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\218\252\50\213\248\252\47\215\213\250\40\215", "\178\151\147\92")]:IsAvailable() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\161\242\66\53\29\67\105\137\223\69\38\23", "\26\236\157\44\82\114\44")]:Cost()) or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\24\47\197\79\37\60\230\79\56\39\222\94", "\59\74\78\181")]:Cost();
	local v68 = (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\9\196\84\93\182", "\211\69\177\58\58")]:IsAvailable() and 8) or 5;
	v9:RegisterForEvent(function()
		local v91 = 0;
		while true do
			if ((v91 == 0) or (2167 >= 3426)) then
				v67 = (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\154\234\119\242\230\196\164\224\91\252\253\206", "\171\215\133\25\149\137")]:IsAvailable() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\204\199\60\253\224\63\239\71\195\193\38\255", "\34\129\168\82\154\143\80\156")]:Cost()) or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\183\179\35\31\71\92\186\145\160\58\0\77", "\233\229\210\83\107\40\46")]:Cost();
				v68 = (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\237\87\60\209\0", "\101\161\34\82\182")]:IsAvailable() and 8) or 5;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\219\61\124\210\247\209\189\13\192\44\119\217\254\198", "\78\136\109\57\158\187\130\226"), LUAOBFUSACTOR_DECRYPT_STR_0("\18\26\216\195\16\26\221\206\13\15\220\221\18\0\208\223\1\11\216\211", "\145\94\95\153"));
	v9:RegisterForEvent(function()
		local v92 = 0;
		while true do
			if ((764 < 3285) and (v92 == 0)) then
				v65 = 11111;
				v66 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\205\225\53\236\107\133\194\255\49\242\107\153\194\232\58\244\108\155\216\233", "\215\157\173\116\181\46"));
	local v69 = {v55[LUAOBFUSACTOR_DECRYPT_STR_0("\2\189\135\246\220\60\166\142\208\213\56\182", "\186\85\212\235\146")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\241\137\4\255\41\224\93\206\163\25\243\59", "\56\162\225\118\158\89\142")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\108\13\197\189\45\213\83\11\197\141\45\213\94", "\184\60\101\160\207\66")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\7\141\112\189\37\139\112\185\19\141\113\190", "\220\81\226\28")]};
	local v70 = {v55[LUAOBFUSACTOR_DECRYPT_STR_0("\36\220\142\255\236\206\1\208\160\244\231\197\55\208\128\238\236\193", "\167\115\181\226\155\138")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\209\42\245\93\107\127\195\238\0\232\81\121\85\195\224\55\225\90", "\166\130\66\135\60\27\17")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\116\66\203\103\63\73\69\192\112\18\75\71\204\81\53\70\95\200\115", "\80\36\42\174\21")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\120\31\59\123\90\25\59\127\108\31\58\120\106\21\53\111\72\22", "\26\46\112\87")]};
	local function v71(v93, v94)
		local v95 = 0;
		local v96;
		while true do
			if ((2499 == 2499) and (v95 == 0)) then
				v96 = v94 or 0;
				return (v12:Focus() + v12:FocusCastRegen(v93) + v96) < v12:FocusMax();
			end
		end
	end
	local function v72(v97)
		return (v97:DebuffRemains(v55.SerpentStingDebuff));
	end
	local function v73(v98)
		return (v98:DebuffRemains(v55.BloodseekerDebuff));
	end
	local function v74(v99)
		return (v99:DebuffStack(v55.LatentPoisonDebuff));
	end
	local function v75(v100)
		return (v100:DebuffDown(v55.ShreddedArmorDebuff));
	end
	local function v76(v101)
		return (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\146\42\167\120\156\176\72\185\184\45\175", "\212\217\67\203\20\223\223\37")]:FullRechargeTime() < v12:GCD()) and v71(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\145\132\164\222\153\130\165\223\187\131\172", "\178\218\237\200")]:ExecuteTime(), 21) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\144\185\231\222\189\188\232\215\133\161\244\217\189\176", "\176\214\213\134")]:CooldownDown() or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\210\161\183\218\163\95\87\243\158\162\198\161\93\92", "\57\148\205\214\180\200\54")]:IsAvailable());
	end
	local function v77(v102)
		return (v102:DebuffDown(v55.ShreddedArmorDebuff));
	end
	local function v78(v103)
		return v103:DebuffStack(v55.LatentPoisonDebuff) > 8;
	end
	local function v79(v104)
		return v104:DebuffRefreshable(v55.SerpentStingDebuff) and (v104:TimeToDie() > 12) and (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\36\244\37\49\100\1\203\48\58\121\31", "\22\114\157\85\84")]:IsAvailable() or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\236\210\23\214\92\229\138\205\223\22", "\200\164\171\115\164\61\150")]:IsAvailable());
	end
	local function v80(v105)
		return v105:DebuffDown(v55.SerpentStingDebuff) and (v105:TimeToDie() > 7);
	end
	local function v81(v106)
		return (v106:DebuffRefreshable(v55.SerpentStingDebuff));
	end
	local function v82()
		local v107 = 0;
		while true do
			if ((v107 == 2) or (692 >= 4933)) then
				if (v13:IsInMeleeRange(v68) or (v12:BuffUp(v55.AspectoftheEagle) and v13:IsInRange(40)) or (3154 <= 2260)) then
					if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\246\222\32\91\32\88\200\212\12\85\59\82", "\55\187\177\78\60\79")]:IsReady() or (2637 > 3149)) then
						if (v25(v55.MongooseBite) or (3992 < 2407)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\32\193\81\236\73\192\147\40\241\93\226\82\202\192\61\220\90\232\73\194\130\44\218\31\189", "\224\77\174\63\139\38\175");
						end
					elseif (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\182\64\72\58\139\83\107\58\150\72\83\43", "\78\228\33\56")]:IsReady() or (2902 > 4859)) then
						if ((1679 < 4359) and v25(v55.RaptorStrike)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\220\127\162\23\138\220\65\161\23\151\199\117\183\67\149\220\123\177\12\136\204\127\166\67\221", "\229\174\30\210\99");
						end
					end
				end
				break;
			end
			if ((1913 < 4670) and (v107 == 1)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\33\52\61\121\176\64\0\33\40", "\20\114\64\88\28\220")]:IsCastable() and v13:DebuffDown(v55.SteelTrapDebuff)) or (2846 < 879)) then
					if ((4588 == 4588) and v25(v55.SteelTrap, not v13:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\21\215\177\244\239\169\35\0\194\244\232\194\184\50\14\223\182\249\196\253\99", "\221\81\97\178\212\152\176");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\229\230\15\235\21\194\233", "\122\173\135\125\155")]:IsCastable() and v50 and (v12:BuffDown(v55.AspectoftheEagle) or not v13:IsInRange(30))) or (347 == 2065)) then
					if (v25(v55.Harpoon, not v13:IsSpellInRange(v55.Harpoon)) or (1311 > 2697)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\140\192\18\169\48\62\198\196\209\18\188\60\62\197\134\192\20\249\107", "\168\228\161\96\217\95\81");
					end
				end
				v107 = 2;
			end
			if ((0 == v107) or (2717 > 3795)) then
				if ((v14:Exists() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\147\253\16\65\138\172\241\0\81\138\177\250", "\227\222\148\99\37")]:IsReady()) or (1081 < 391)) then
					if (v25(v58.MisdirectionFocus) or (121 > 3438)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\91\65\242\240\33\87\81\226\240\60\92\18\230\235\54\81\93\251\251\50\70\18\166", "\153\83\50\50\150");
					end
				end
				if ((71 < 1949) and v56[LUAOBFUSACTOR_DECRYPT_STR_0("\124\122\116\25\103\163\76\79\70\102\6\105\167\72\127\121\107", "\45\61\22\19\124\19\203")]:IsEquippedAndReady()) then
					if ((4254 == 4254) and v25(v58.AlgetharPuzzleBox, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\30\10\240\22\120\184\211\45\29\224\24\106\181\196\45\15\250\26\48\169\211\23\14\250\15\114\184\213\82\92", "\217\161\114\109\149\98\16");
					end
				end
				v107 = 1;
			end
		end
	end
	local function v83()
		local v108 = 0;
		local v109;
		local v110;
		while true do
			if ((3196 >= 2550) and (v108 == 1)) then
				v109 = v12:GetUseableItems(v57, 13);
				if ((2456 < 4176) and v109) then
					if (v25(v58.Trinket1, nil, nil, true) or (1150 == 3452)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\30\138\47\9\48\184\232\76\151\51\11\59\167\188\24\195\115", "\204\217\108\227\65\98\85");
					end
				end
				v108 = 2;
			end
			if ((1875 < 2258) and (v108 == 2)) then
				v110 = v12:GetUseableItems(v57, 14);
				if ((1173 > 41) and v110) then
					if (v25(v58.Trinket2, nil, nil, true) or (56 >= 3208)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\74\209\252\235\39\197\74\145\181\241\62\201\80\200\240\241\108\148", "\160\62\163\149\133\76");
					end
				end
				break;
			end
			if ((4313 > 3373) and (v108 == 0)) then
				if ((v56[LUAOBFUSACTOR_DECRYPT_STR_0("\58\225\129\84\249\53\56\9\221\147\75\247\49\60\57\226\158", "\89\123\141\230\49\141\93")]:IsEquippedAndReady() and (v12:GCDRemains() > (v12:GCD() - 0.6))) or (4493 == 2225)) then
					if ((3104 >= 3092) and v25(v58.AlgetharPuzzleBox, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\242\125\241\9\4\66\242\99\201\28\5\80\233\125\243\51\18\69\235\49\245\8\3\10\162\38", "\42\147\17\150\108\112");
					end
				end
				if ((3548 > 3098) and v56[LUAOBFUSACTOR_DECRYPT_STR_0("\34\167\35\118\228\207\29\175\40\121\243\231\29\165\37", "\136\111\198\77\31\135")]:IsEquippedAndReady() and (v12:GCDRemains() > (v12:GCD() - 0.6)) and v12:BuffDown(v55.SpearheadBuff)) then
					if (v25(v58.ManicGrieftorch, nil, true) or (3252 == 503)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\15\8\169\95\190\219\16\187\11\12\161\66\178\246\20\161\66\10\163\69\253\181\79", "\201\98\105\199\54\221\132\119");
					end
				end
				v108 = 1;
			end
		end
	end
	local function v84()
		local v111 = 0;
		while true do
			if ((4733 > 2066) and (v111 == 2)) then
				if ((3549 >= 916) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\18\31\135\23\71\4\12\137\27\74\35", "\33\80\126\224\120")]:IsCastable() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\199\161\15\200\127\227\165\14\197\82\232", "\60\140\200\99\164")]:FullRechargeTime() > v12:GCD())) then
					if (v25(v55.BagofTricks, not v13:IsSpellInRange(v55.BagofTricks)) or (2189 <= 245)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\133\245\3\25\173\129\203\16\52\171\132\255\23\102\161\131\231\68\119\240", "\194\231\148\100\70");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\100\73\211\176\243\218\77\69\207\164", "\168\38\44\161\195\150")]:IsCastable() and (v12:BuffUp(v55.CoordinatedAssaultBuff) or v12:BuffUp(v55.SpearheadBuff) or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\179\236\135\119\34\224\179\23\132", "\118\224\156\226\22\80\136\214")]:IsAvailable() and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\97\225\86\146\70\231\87\129\86\235\93\161\81\253\88\149\78\250", "\224\34\142\57")]:IsAvailable()) or (v66 < 13))) or (1389 > 3925)) then
					if ((4169 >= 3081) and v25(v55.Berserking)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\162\215\206\118\227\86\7\208\160\133\222\119\226\29\95\138", "\110\190\199\165\189\19\145\61");
					end
				end
				v111 = 3;
			end
			if ((349 <= 894) and (0 == v111)) then
				if ((731 <= 2978) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\244\172\2\32\199\240\181\31\54", "\163\182\192\109\79")]:IsCastable() and (v12:BuffUp(v55.CoordinatedAssaultBuff) or v12:BuffUp(v55.SpearheadBuff) or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\7\54\5\193\231\60\35\1\196", "\149\84\70\96\160")]:IsAvailable() and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\27\9\2\255\60\15\3\236\44\3\9\204\43\21\12\248\52\18", "\141\88\102\109")]:IsAvailable()))) then
					if (v25(v55.BloodFury) or (892 > 3892)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\95\197\127\30\2\83\212\161\74\138\115\30\46\21\147", "\161\211\51\170\16\122\93\53");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\211\175\160\56\244\161\188", "\72\155\206\210")]:IsCastable() and v50 and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\114\127\70\3\32\73\124\113\0\52\71\125\81\3\54\72\110", "\83\38\26\52\110")]:IsAvailable() and (v12:Focus() < v12:FocusMax())) or (4466 == 900)) then
					if (v25(v55.Harpoon, not v13:IsSpellInRange(v55.Harpoon)) or (2084 >= 2888)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\22\53\86\87\24\41\6\91\19\52\6\10", "\38\56\119\71");
					end
				end
				v111 = 1;
			end
			if ((479 < 1863) and (v111 == 3)) then
				if (v32 or (2428 >= 4038)) then
					local v137 = 0;
					local v138;
					while true do
						if ((v137 == 0) or (2878 > 2897)) then
							v138 = v83();
							if (v138 or (2469 > 3676)) then
								return v138;
							end
							break;
						end
					end
				end
				if ((233 < 487) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\251\248\103\237\136\211\213\237\99\224\142\226\219\236\123\237", "\167\186\139\23\136\235")]:IsCastable() and v52 and not v13:IsInRange(v68)) then
					if ((2473 >= 201) and v25(v55.AspectoftheEagle)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\27\166\152\8\25\161\183\2\28\138\156\5\31\138\141\12\29\185\141\77\25\177\155\77\75\236", "\109\122\213\232");
					end
				end
				break;
			end
			if ((4120 >= 133) and (v111 == 1)) then
				if ((3080 >= 1986) and (v12:BuffUp(v55.CoordinatedAssaultBuff) or v12:BuffUp(v55.SpearheadBuff) or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\192\255\93\215\55\94\246\238\92", "\54\147\143\56\182\69")]:IsAvailable() and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\245\142\240\91\219\223\143\254\93\218\210\160\236\90\222\195\141\235", "\191\182\225\159\41")]:IsAvailable()))) then
					local v139 = 0;
					while true do
						if ((0 == v139) or (1439 > 3538)) then
							if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\10\28\43\80\152\147\208\42\30\11\84\135\139", "\162\75\114\72\53\235\231")]:IsCastable() or (419 < 7)) then
								if ((2820 == 2820) and v25(v55.AncestralCall)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\141\50\71\231\64\22\158\61\72\221\80\3\128\48\4\225\87\17\204\106", "\98\236\92\36\130\51");
								end
							end
							if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\130\16\30\191\71\164\186\63\160", "\80\196\121\108\218\37\200\213")]:IsCastable() or (4362 <= 3527)) then
								if ((2613 <= 2680) and v25(v55.Fireblood)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\6\122\16\122\73\2\133\15\119\66\124\79\29\202\88", "\234\96\19\98\31\43\110");
								end
							end
							break;
						end
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\42\22\85\207\184\97\161\19\27\85\202\169\124\159", "\235\102\127\50\167\204\18")]:IsCastable() or (1482 >= 4288)) then
					if (v25(v55.LightsJudgment, not v13:IsSpellInRange(v55.LightsJudgment)) or (2462 > 4426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\168\242\43\80\61\111\171\224\39\67\35\85\175\225\99\71\42\67\225\164\115", "\78\48\193\149\67\36");
					end
				end
				v111 = 2;
			end
		end
	end
	local function v85()
		local v112 = 0;
		while true do
			if ((4774 == 4774) and (v112 == 6)) then
				if ((566 <= 960) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\59\172\45\103\6\191\14\103\27\164\54\118", "\19\105\205\93")]:IsReady()) then
					if (v54.CastTargetIf(v55.RaptorStrike, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\164\1\208", "\95\201\104\190\225"), v72, nil, not v13:IsInMeleeRange(v68)) or (2910 <= 1930)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\189\202\209\218\160\217\254\221\187\217\200\197\170\139\194\194\170\202\215\203\239\159\151", "\174\207\171\161");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\203\242\12\253\243\222\227\249\62\231\234\222\230\251", "\183\141\158\109\147\152")]:IsCastable() or (19 > 452)) then
					if (v25(v55.FlankingStrike, not v13:IsSpellInRange(v55.FlankingStrike)) or (907 > 3152)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\5\231\2\39\0\232\11\19\26\242\30\37\2\227\76\47\5\227\13\58\12\166\88\116", "\108\76\105\134");
					end
				end
				break;
			end
			if ((v112 == 5) or (2505 > 4470)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\55\77\45\164\48\70\246\11\56\75\55\166", "\110\122\34\67\195\95\41\133")]:IsReady() and (v12:BuffUp(v55.SpearheadBuff))) or (3711 > 4062)) then
					if ((420 == 420) and v54.CastTargetIf(v55.MongooseBite, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\120\184\85", "\182\21\209\59\42"), v72, nil, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\88\203\26\46\177\164\82\250\31\40\170\178\23\198\17\36\191\161\82\133\73\115", "\222\215\55\165\125\65");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\31\212\212\10\247\207\249\121\56\216\200\29", "\42\76\177\166\122\146\161\141")]:IsReady() or (33 >= 3494)) then
					if (v54.CastTargetIf(v55.SerpentSting, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\168\131\11", "\22\197\234\101\174\25"), v72, v79, not v13:IsSpellInRange(v55.SerpentSting)) or (1267 == 4744)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\49\183\204\115\161\195\185\62\32\172\210\113\239\212\138\40\53\179\217\54\251\133", "\230\77\84\197\188\22\207\183");
					end
				end
				if ((2428 < 3778) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\223\24\199\242\135\168\254\50\202\0\212\245\135\164", "\85\153\116\166\156\236\193\144")]:IsCastable() and (v71(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\130\236\76\189\239\9\170\231\126\167\246\9\175\229", "\96\196\128\45\211\132")]:ExecuteTime()))) then
					if (v25(v55.FlankingStrike, not v13:IsSpellInRange(v55.FlankingStrike)) or (2946 <= 1596)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\51\129\122\81\217\166\186\223\10\158\111\77\219\164\177\152\54\129\126\94\196\170\244\140\102\195\46", "\184\85\237\27\63\178\207\212");
					end
				end
				if ((4433 > 3127) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\37\86\7\88\7\86\26\90\42\80\29\90", "\63\104\57\105")]:IsReady()) then
					if ((4300 >= 2733) and v54.CastTargetIf(v55.MongooseBite, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\6\142\170", "\36\107\231\196"), v72, nil, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\186\172\128\82\186\177\130\98\183\171\147\88\245\161\139\88\180\180\130\29\225\246", "\231\61\213\194");
					end
				end
				v112 = 6;
			end
			if ((4829 == 4829) and (4 == v112)) then
				if ((1683 <= 4726) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\213\247\107\23\131", "\188\150\150\25\97\230")]:IsReady()) then
					if ((4835 >= 3669) and v25(v55.Carve, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\217\136\77\20\9\173\217\133\90\3\26\232\154\218\9", "\141\186\233\63\98\108");
					end
				end
				if ((2851 > 1859) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\218\227\32\186\22\249\229\56", "\69\145\138\76\214")]:IsReady() and (v12:BuffDown(v55.CoordinatedAssaultBuff))) then
					if ((3848 > 2323) and v25(v55.KillShot, not v13:IsSpellInRange(v55.KillShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\123\198\133\133\128\5\120\192\157\201\188\26\117\206\159\140\255\69\40", "\118\16\175\233\233\223");
					end
				end
				if ((2836 > 469) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\184\144\48\190\226\191\111\138\148", "\29\235\228\85\219\142\235")]:IsCastable() and (v71(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\14\192\191\216\123\122\53\83\45", "\50\93\180\218\189\23\46\71")]:ExecuteTime()))) then
					if (v25(v55.SteelTrap, not v13:IsInRange(40)) or (2096 <= 540)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\205\176\94\73\72\227\92\204\165\75\12\71\208\77\223\178\94\12\16\140", "\40\190\196\59\44\36\188");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\15\85\217\181\232\117\8\61\65", "\109\92\37\188\212\154\29")]:IsCastable() and v30) or (3183 < 2645)) then
					if ((3230 <= 3760) and v25(v55.Spearhead, not v13:IsSpellInRange(v55.Spearhead))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\255\161\194\35\82\1\238\160\131\50\86\1\238\178\198\113\14\85", "\58\100\143\196\163\81");
					end
				end
				v112 = 5;
			end
			if ((3828 == 3828) and (v112 == 2)) then
				for v133, v134 in pairs(v69) do
					if ((554 == 554) and v134:IsCastable() and (v13:DebuffDown(v70[v133]))) then
						if (v25(v134, not v13:IsSpellInRange(v134)) or (2563 == 172)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\202\47\250\71\179\212\52\243\124\183\210\43\244\3\182\209\35\247\85\176\157\119\174", "\213\189\70\150\35");
						end
					end
				end
				if ((3889 >= 131) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\105\64\102\17\64\83\96\0\74\112\117\15\67\80", "\104\47\53\20")]:IsCastable()) then
					if (v25(v55.FuryoftheEagle, not v13:IsInMeleeRange(v68)) or (492 == 4578)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\89\147\5\131\0\165\115\149\20\185\48\166\77\134\16\185\79\160\64\132\29\170\10\227\30\211", "\111\195\44\225\124\220");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\251\71\18\101\174", "\203\184\38\96\19\203")]:IsReady() and (v13:DebuffUp(v55.ShrapnelBombDebuff))) or (4112 < 1816)) then
					if ((4525 >= 1223) and v25(v55.Carve, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\114\107\87\203\121\112\117\68\207\47\118\57\19\154", "\174\89\19\25\33");
					end
				end
				if ((1090 <= 4827) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\9\30\83\64\252\142\5\40\33\70\92\254\140\14", "\107\79\114\50\46\151\231")]:IsCastable() and (v71(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\31\170\180\39\129\48\185\199\10\178\167\32\129\60", "\160\89\198\213\73\234\89\215")]:ExecuteTime(), 30))) then
					if (v25(v55.FlankingStrike, not v13:IsInMeleeRange(v68)) or (239 > 1345)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\125\181\240\206\65\127\179\193\214\92\99\189\245\192\8\114\184\251\196\94\116\244\172\147", "\165\40\17\212\158");
					end
				end
				v112 = 3;
			end
			if ((v112 == 3) or (3710 >= 3738)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\199\204\28\48\46\224\203\17", "\70\133\185\104\83")]:IsReady() and (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\55\77\86\43\217\10\64\72\8\198\9\71", "\169\100\37\36\74")]:IsCastable() or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\55\142\174\84\6\142\176\85\41\137\164\69\19\142\173\94", "\48\96\231\194")]:IsAvailable())) or (3838 < 2061)) then
					if (v25(v55.Butchery, not v13:IsInMeleeRange(v68)) or (690 > 1172)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\202\79\26\46\17\221\189\154\136\89\2\40\24\206\170\195\154\2", "\227\168\58\110\77\121\184\207");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\86\51\177\71\190\212\98\160\89\53\171\69", "\197\27\92\223\32\209\187\17")]:IsReady() or (1592 > 2599)) then
					if ((3574 <= 4397) and v54.CastTargetIf(v55.MongooseBite, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\14\94\219", "\155\99\63\163"), v74, v78, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\143\222\175\138\182\139\145\212\158\143\176\144\135\145\162\129\188\133\148\212\225\222\233", "\228\226\177\193\237\217");
					end
				end
				if ((3135 > 1330) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\6\177\51\242\59\162\16\242\38\185\40\227", "\134\84\208\67")]:IsReady()) then
					if (v54.CastTargetIf(v55.RaptorStrike, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\30\173\158", "\60\115\204\230"), v74, v78, not v13:IsInMeleeRange(v68)) or (3900 <= 3641)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\59\251\100\232\40\212\99\243\40\226\123\226\122\232\124\226\59\253\117\167\105\185", "\16\135\90\139");
					end
				end
				if ((1724 == 1724) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\127\125\10\63\109\91\117\89\117\8\55", "\24\52\20\102\83\46\52")]:IsCastable() and v71(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\239\38\45\40\44\203\34\44\37\1\192", "\111\164\79\65\68")]:ExecuteTime()) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\237\208\143\210\13\229\203\212\130\208\42", "\138\166\185\227\190\78")]:FullRechargeTime() < v12:GCD())) then
					if ((455 <= 1282) and v54.CastTargetIf(v55.KillCommand, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\198\125\203", "\121\171\20\165\87\50\67"), v73, nil, not v13:IsSpellInRange(v55.KillCommand))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\205\49\181\58\134\1\201\53\180\55\183\6\134\59\181\51\184\20\195\120\234\98", "\98\166\88\217\86\217");
					end
				end
				v112 = 4;
			end
			if ((4606 < 4876) and (v112 == 1)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\21\70\252\2\119\199\56\72\231\21\119\239\37\90\242\5\127\218", "\174\86\41\147\112\19")]:IsCastable() and v30 and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\125\21\159\18\42\9\5\163\94\37\140\12\41\10", "\203\59\96\237\107\69\111\113")]:CooldownDown() or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\2\3\190\248\62\246\195\44\19\137\224\54\252\210", "\183\68\118\204\129\81\144")]:IsAvailable())) or (1442 > 2640)) then
					if ((136 < 3668) and v25(v55.CoordinatedAssault, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\13\162\127\246\15\139\0\172\100\225\15\189\15\190\99\229\30\142\26\237\115\232\14\131\24\168\48\188", "\226\110\205\16\132\107");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\206\219\240\213\78\248\202\246\220\114\227\204\244", "\33\139\163\128\185")]:IsReady() or (1784 > 4781)) then
					if ((4585 > 3298) and v25(v55.ExplosiveShot, not v13:IsSpellInRange(v55.ExplosiveShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\64\20\210\88\75\13\200\82\103\23\214\88\76\68\221\91\93\5\200\82\24\85\140", "\190\55\56\100");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\117\174\46\8\22", "\147\54\207\92\126\115\131")]:IsReady() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\58\56\57\121\11\119\31\52\23\114\0\124", "\30\109\81\85\29\109")]:FullRechargeTime() > (v63 / 2))) or (1664 > 1698)) then
					if (v25(v55.Carve, not v13:IsInMeleeRange(v68)) or (3427 < 2849)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\252\112\70\160\51\158\255\243\116\85\160\51\158\173\171", "\156\159\17\52\214\86\190");
					end
				end
				if ((3616 <= 4429) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\140\250\169\191\166\234\175\165", "\220\206\143\221")]:IsReady() and ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\164\104\57\20\208\201\192\159", "\178\230\29\77\119\184\172")]:FullRechargeTime() < v12:GCD()) or (v13:DebuffUp(v55.ShrapnelBombDebuff) and ((v13:DebuffStack(v55.InternalBleedingDebuff) < 2) or (v13:DebuffRemains(v55.ShrapnelBombDebuff) < v12:GCD()))))) then
					if ((3988 >= 66) and v25(v55.Butchery, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\247\171\30\24\127\253\231\167\74\24\123\253\244\168\15\91\38\174", "\152\149\222\106\123\23");
					end
				end
				v112 = 2;
			end
			if ((0 == v112) or (862 > 4644)) then
				if ((1221 == 1221) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\197\254\174\60\221\255\173\36", "\80\142\151\194")]:IsReady() and v12:BuffUp(v55.CoordinatedAssaultEmpowerBuff) and v12:BuffUp(v55.CoordinatedAssaultBuff) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\33\207\99\73", "\44\99\166\23")]:IsReady() or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\95\251\40\33", "\196\28\151\73\86\83")]:IsReady() or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\192\14\40\19\137", "\22\147\99\73\112\226\56\120")]:IsReady()) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\154\124\240\241\158\183\115\210\231\136\161", "\237\216\21\130\149")]:IsAvailable()) then
					if (v25(v55.KillShot, not v13:IsSpellInRange(v55.KillShot)) or (45 > 1271)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\137\71\83\83\143\218\86\141\90\31\92\188\204\95\148\75", "\62\226\46\63\63\208\169");
					end
				end
				if ((3877 > 1530) and ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\210\16\89\135\25\4\61\91\199\22\88\129", "\62\133\121\53\227\127\109\79")]:FullRechargeTime() < v12:GCD()) or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\51\27\61\231\210\167\172\17\0\55\241\247\189\177\17\1\62\225", "\194\112\116\82\149\182\206")]:CooldownUp() or (v12:BuffUp(v55.CoordinatedAssaultBuff) and v12:BuffDown(v55.CoordinatedAssaultEmpowerBuff)) or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\27\167\65\26\193\240\10\48\173\94", "\110\89\200\44\120\160\130")]:IsAvailable())) then
					for v143, v144 in pairs(v69) do
						if (v144:IsCastable() or (4798 == 1255)) then
							if (v25(v144, not v13:IsSpellInRange(v144)) or (2541 > 2860)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\188\202\71\66\69\67\41\72\148\193\68\75\65\10\56\65\174\194\93\67\3\24", "\45\203\163\43\38\35\42\91");
							end
						end
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\246\128\221\55\143\138\92\211\142\206\34\138", "\52\178\229\188\67\231\201")]:IsCastable() or (2902 > 3629)) then
					if ((427 < 3468) and v25(v55.DeathChakram, not v13:IsSpellInRange(v55.DeathChakram))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\68\81\16\255\99\32\41\64\91\22\246\81\99\34\77\85\5\225\89\99\117", "\67\65\33\48\100\151\60");
					end
				end
				if ((4190 >= 2804) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\236\243\175\213\227\218\227\171", "\147\191\135\206\184")]:IsCastable() and v30) then
					if ((2086 == 2086) and v25(v55.Stampede, not v13:IsSpellInRange(v55.Stampede))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\60\167\204\200\86\182\129\104\165\205\221\82\164\129\104\240", "\210\228\72\198\161\184\51");
					end
				end
				v112 = 1;
			end
		end
	end
	local function v86()
		local v113 = 0;
		while true do
			if ((4148 > 2733) and (2 == v113)) then
				if ((3054 >= 1605) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\211\38\50\36\230\77\13\80", "\36\152\79\94\72\181\37\98")]:IsReady() and (v12:BuffDown(v55.CoordinatedAssaultBuff))) then
					if ((1044 < 1519) and v25(v55.KillShot, not v13:IsSpellInRange(v55.KillShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\209\75\51\232\203\79\48\195\152\84\43\151\137\19", "\95\183\184\39");
					end
				end
				if ((1707 <= 4200) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\135\62\247\50\91\146\49\161\45\238\45\81", "\98\213\95\135\70\52\224")]:IsReady() and (v63 == 1) and (v13:TimeToDie() < ((v12:Focus() / (v67 - v12:FocusCastRegen(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\204\162\217\99\91\236\144\221\101\93\245\166", "\52\158\195\169\23")]:ExecuteTime()))) * v12:GCD()))) then
					if ((580 == 580) and v25(v55.RaptorStrike, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\104\189\34\96\137\39\68\152\110\174\59\127\131\117\104\159\58\237\100", "\235\26\220\82\20\230\85\27");
					end
				end
				if ((601 <= 999) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\187\164\251\210\113\134\181\218\214\125\134\166", "\20\232\193\137\162")]:IsReady() and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\20\214\213\163\245\159\33\116\44\208\200", "\17\66\191\165\198\135\236\119")]:IsAvailable()) then
					if ((3970 == 3970) and v54.CastTargetIf(v55.SerpentSting, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\2\166\160", "\177\111\207\206\115\159\136\140"), v72, v80, not v13:IsSpellInRange(v55.SerpentSting))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\140\2\4\209\65\75\58\154\4\29\218\72\31\22\157\80\69\140", "\63\101\233\112\116\180\47");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\229\46\255\11\247\48\215\51\232\55\249\49\207\62", "\86\163\91\141\114\152")]:IsCastable() and v12:BuffUp(v55.SeethingRageBuff) and (v12:BuffRemains(v55.SeethingRageBuff) < (3 * v12:GCD()))) or (98 == 208)) then
					if ((2006 <= 3914) and v25(v55.FuryoftheEagle, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\30\102\106\5\92\13\75\103\50\86\52\113\114\61\95\14\52\96\46\19", "\90\51\107\20\19");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\160\255\139\232\50\130\227\128\205\52\153\245", "\93\237\144\229\143")]:IsReady() and ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\52\250\224\17\10\118\7\243\244\24\31\73\7", "\38\117\150\144\121\107")]:IsAvailable() and v12:BuffUp(v55.MongooseFuryBuff) and (v12:BuffRemains(v55.MongooseFuryBuff) < ((v12:Focus() / (v67 - v12:FocusCastRegen(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\0\180\224\61\34\180\253\63\15\178\250\63", "\90\77\219\142")]:ExecuteTime()))) * v12:GCD()))) or (v12:BuffUp(v55.SeethingRageBuff) and (v63 == 1)))) or (3101 <= 2971)) then
					if (v25(v55.MongooseBite, not v13:IsInMeleeRange(v68)) or (2073 <= 671)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\11\47\62\67\8\105\227\59\35\48\88\2\58\245\16\97\107\28", "\26\134\100\65\89\44\103");
					end
				end
				v113 = 3;
			end
			if ((3305 > 95) and (v113 == 3)) then
				if ((2727 == 2727) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\215\239\49\45\175\248\237\55\16\176\227\234\59\38", "\196\145\131\80\67")]:IsCastable() and (v71(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\56\188\7\6\19\225\16\183\53\28\10\225\21\181", "\136\126\208\102\104\120")]:ExecuteTime(), 30))) then
					if (v25(v55.FlankingStrike, not v13:IsInMeleeRange(v68)) or (2970 >= 4072)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\126\134\207\77\164\91\51\86\71\153\218\81\166\89\56\17\107\158\142\17\253", "\49\24\234\174\35\207\50\93");
					end
				end
				if ((3881 > 814) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\63\230\252\133\97\9\246\248", "\17\108\146\157\232")]:IsCastable() and v30) then
					if (v25(v55.Stampede, not v13:IsSpellInRange(v55.Stampede)) or (4932 < 4868)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\88\215\21\224\63\173\79\198\84\254\59\232\25\144", "\200\43\163\116\141\79");
					end
				end
				if ((3667 <= 4802) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\156\57\50\145\180\253\237\190\34\56\135\145\231\240\190\35\49\151", "\131\223\86\93\227\208\148")]:IsCastable() and v30 and ((not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\192\74\185\164\25\188\237\68\162\179\25\158\234\73\186", "\213\131\37\214\214\125")]:IsAvailable() and (v13:HealthPercentage() < 20) and ((v12:BuffDown(v55.SpearheadBuff) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\21\59\32\190\243\46\46\36\187", "\129\70\75\69\223")]:CooldownDown()) or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\117\219\246\232\110\231\67\202\247", "\143\38\171\147\137\28")]:IsAvailable())) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\243\141\182\225\7\234\218\209\150\188\247\40\234\216\220", "\180\176\226\217\147\99\131")]:IsAvailable() and ((v12:BuffDown(v55.SpearheadBuff) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\224\169\42\6\193\177\42\6\215", "\103\179\217\79")]:CooldownDown()) or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\121\167\25\212\83\132\166\75\179", "\195\42\215\124\181\33\236")]:IsAvailable())))) then
					if ((1260 >= 858) and v25(v55.CoordinatedAssault, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\14\86\56\44\33\241\3\88\35\59\33\199\12\74\36\63\48\244\25\25\36\42\101\170\89", "\152\109\57\87\94\69");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\210\222\6\175\157\221\89\165\248\217\14", "\200\153\183\106\195\222\178\52")]:IsCastable() or (3911 == 4700)) then
					if ((3000 < 4194) and v54.CastTargetIf(v55.KillCommand, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\63\234\134", "\58\82\131\232\93\41"), v73, v76, not v13:IsSpellInRange(v55.KillCommand))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\136\94\220\25\98\60\140\90\221\20\83\59\195\68\196\85\15\103", "\95\227\55\176\117\61");
					end
				end
				if ((651 < 4442) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\43\123\49\91\174\22\106\16\95\162\22\121", "\203\120\30\67\43")]:IsReady() and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\199\44\93\234\203\226\19\72\225\214\252", "\185\145\69\45\143")]:IsAvailable()) then
					if (v54.CastTargetIf(v55.SerpentSting, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\135\22\23", "\188\234\127\121\198"), v72, v81, not v13:IsSpellInRange(v55.SerpentSting)) or (195 >= 1804)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\55\1\147\61\60\7\188\43\38\26\141\63\114\0\151\120\97\65", "\227\88\82\115");
					end
				end
				v113 = 4;
			end
			if ((v113 == 0) or (1382 > 2216)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\192\204\189\237\237\228\200\188\224\192\239", "\174\139\165\209\129")]:IsCastable() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\144\163\231\192\212\11\117\121\167", "\24\195\211\130\161\166\99\16")]:IsAvailable() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\117\19\236\45\65\30\67\2\237", "\118\38\99\137\76\51")]:CooldownRemains() < (2 * v12:GCD()))) or (2861 == 2459)) then
					if ((1903 < 4021) and v54.CastTargetIf(v55.KillCommand, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\240\47\11", "\64\157\70\101\114\105"), v73, v77, not v13:IsSpellInRange(v55.KillCommand))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\161\171\239\47\67\167\170\238\17\78\172\231\240\4\0\250", "\112\32\200\199\131");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\31\64\89\185\209\163\39\45\84", "\66\76\48\60\216\163\203")]:IsAvailable() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\137\150\124\242\77\198\33\187\130", "\68\218\230\25\147\63\174")]:CooldownRemains() < (2 * v12:GCD())) and v13:DebuffUp(v55.ShreddedArmorDebuff)) or (2270 >= 4130)) then
					for v145, v146 in pairs(v69) do
						if ((2593 <= 3958) and v146:IsCastable()) then
							if ((1176 == 1176) and v25(v146, not v13:IsSpellInRange(v146))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\186\35\95\72\176\164\56\86\115\180\162\39\81\12\165\185\106\7", "\214\205\74\51\44");
							end
						end
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\222\73\227\232\127\217\68\227\247\101\251\65", "\23\154\44\130\156")]:IsCastable() and (v71(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\53\163\172\186\62\48\25\167\166\188\55\30", "\115\113\198\205\206\86")]:ExecuteTime()) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\183\71\251\91\150\95\251\91\128", "\58\228\55\158")]:IsAvailable() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\135\153\213\47\46\165\48\181\141", "\85\212\233\176\78\92\205")]:CooldownUp()))) or (3062 == 1818)) then
					if (v25(v55.DeathChakram, not v13:IsSpellInRange(v55.DeathChakram)) or (3717 < 3149)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\93\137\246\66\103\139\234\75\83\154\227\71\24\155\246\10\10", "\130\42\56\232");
					end
				end
				if ((3195 < 3730) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\217\165\33\226\82\55\239\180\32", "\95\138\213\68\131\32")]:IsCastable() and v30 and ((v12:Focus() + v12:FocusCastRegen(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\1\33\173\79\85\37\37\172\66\120\46", "\22\74\72\193\35")]:ExecuteTime()) + 21) > (v12:FocusMax() - 10)) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\8\124\229\76\36\90\236\89\39\107\229\85", "\56\76\25\132")]:CooldownDown() or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\122\196\170\50\199\125\201\170\45\221\95\204", "\175\62\161\203\70")]:IsAvailable())) then
					if ((2797 <= 3980) and v25(v55.Spearhead, not v13:IsSpellInRange(v55.Spearhead))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\205\198\18\39\52\216\194\23\117\47\201\131\71", "\85\92\189\163\115");
					end
				end
				if ((1944 <= 2368) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\2\165\60\52\26\164\63\44", "\88\73\204\80")]:IsReady() and v12:BuffUp(v55.CoordinatedAssaultEmpowerBuff) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\12\138\4\67", "\186\78\227\112\38\73")]:IsReady() or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\223\91\252\66", "\26\156\55\157\53\51")]:IsReady() or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\191\213\23\218\179", "\48\236\184\118\185\216")]:IsReady())) then
					if ((1709 < 4248) and v25(v55.KillShot, not v13:IsSpellInRange(v55.KillShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\238\180\91\60\240\39\237\178\67\112\220\32\165\235", "\84\133\221\55\80\175");
					end
				end
				v113 = 1;
			end
			if ((v113 == 4) or (3970 == 3202)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\116\22\182\163\4\122\81\26\152\168\15\113", "\19\35\127\218\199\98")]:FullRechargeTime() < (2 * v12:GCD())) or (3918 >= 4397)) then
					for v147, v148 in pairs(v69) do
						if (v148:IsCastable() or (780 == 3185)) then
							if (v25(v148, not v13:IsSpellInRange(v148)) or (3202 >= 4075)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\11\242\6\230\26\242\24\231\35\249\5\239\30\187\25\246\92\168\94", "\130\124\155\106");
							end
						end
					end
				end
				if ((64 == 64) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\248\196\248\168\172\249\111\186\247\194\226\170", "\223\181\171\150\207\195\150\28")]:IsReady() and (v13:DebuffUp(v55.ShrapnelBombDebuff))) then
					if ((2202 >= 694) and v25(v55.MongooseBite, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\65\53\237\169\6\67\41\230\145\11\69\46\230\238\26\88\122\176\254", "\105\44\90\131\206");
					end
				end
				if ((3706 <= 3900) and v12:HasTier(30, 4)) then
					for v149, v150 in pairs(v69) do
						if ((2890 > 2617) and v150:IsCastable() and ((v13:DebuffDown(v70[v149]) and v13:DebuffUp(v55.ShreddedArmorDebuff) and v71(v150:ExecuteTime())) or (v63 > 1))) then
							if (v25(v150, not v13:IsSpellInRange(v150)) or (3355 > 4385)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\232\233\190\189\14\55\237\229\141\187\7\51\253\160\161\173\72", "\94\159\128\210\217\104");
							end
						end
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\125\246\8\184\80\112\234\127\114\240\18\186", "\26\48\153\102\223\63\31\153")]:IsReady() and (v12:BuffUp(v55.MongooseFuryBuff))) or (3067 <= 2195)) then
					if ((3025 >= 2813) and v54.CastTargetIf(v55.MongooseBite, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\15\65\245", "\147\98\32\141"), v74, nil, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\21\76\237\205\9\89\88\29\124\225\195\18\83\11\11\87\163\153\80", "\43\120\35\131\170\102\54");
					end
				end
				if ((2412 >= 356) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\113\30\151\186\170\163\141\66\3\180\190\170\164", "\228\52\102\231\214\197\208")]:IsReady() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\44\225\123\205\239\153", "\182\126\128\21\170\138\235\121")]:IsAvailable())) then
					if ((2070 > 1171) and v25(v55.ExplosiveShot, not v13:IsSpellInRange(v55.ExplosiveShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\142\194\37\234\137\0\57\16\142\229\38\238\137\7\112\21\159\154\102\177", "\102\235\186\85\134\230\115\80");
					end
				end
				v113 = 5;
			end
			if ((v113 == 6) or (4108 < 3934)) then
				if ((3499 >= 3439) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\5\7\247\250\13\1\246\251\47\0\255", "\150\78\110\155")]:IsCastable() and (v71(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\174\204\43\237\135\17\178\77\132\203\35", "\32\229\165\71\129\196\126\223")]:ExecuteTime(), 21))) then
					if ((876 < 3303) and v54.CastTargetIf(v55.KillCommand, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\206\128\202", "\181\163\233\164\225\225"), v73, nil, not v13:IsSpellInRange(v55.KillCommand))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\130\50\123\111\136\49\122\93\138\48\115\16\152\42\55\5\217", "\23\48\235\94");
					end
				end
				if ((2922 <= 3562) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\95\213\215\79\83\58\220\125\206\221\89\118\32\193\125\207\212\73", "\178\28\186\184\61\55\83")]:IsCastable() and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\231\194\72\46\246\7\251\197\217\66\56\217\7\249\200", "\149\164\173\39\92\146\110")]:IsAvailable() and (v13:TimeToDie() > 140)) then
					if ((2619 >= 1322) and v25(v55.CoordinatedAssault, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\40\31\13\30\18\253\38\4\26\30\36\242\52\3\30\15\23\231\103\3\11\90\78\167", "\123\147\71\112\127\122");
					end
				end
				break;
			end
			if ((4133 >= 2404) and (v113 == 5)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\113\25\44\70\125\210\54\95\9\27\94\117\216\39", "\66\55\108\94\63\18\180")]:IsCastable() and (v13:HealthPercentage() < 65) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\38\152\145\63\43\92\7\158\168\54\53\88\1\137\128\37", "\57\116\237\229\87\71")]:IsAvailable()) or (1433 == 2686)) then
					if (v25(v55.FuryoftheEagle, not v13:IsInMeleeRange(v68)) or (4123 == 4457)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\172\164\255\254\72\225\65\149\165\229\226\72\235\70\173\189\232\167\100\250\7", "\39\202\209\141\135\23\142");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\210\60\7\13\61\247\236\54\43\3\38\253", "\152\159\83\105\106\82")]:IsReady() and (((v12:Focus() + v12:FocusCastRegen(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\170\207\93\254\234\83\140\203\80\252\205", "\60\225\166\49\146\169")]:ExecuteTime()) + 21) > (v12:FocusMax() - 10)) or v12:HasTier(30, 4))) or (3972 <= 205)) then
					if (v54.CastTargetIf(v55.MongooseBite, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\34\31\55", "\103\79\126\79\74\97"), v74, nil, not v13:IsInMeleeRange(v68)) or (3766 < 1004)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\112\221\116\81\21\169\122\236\113\87\14\191\63\192\103\30\78\234", "\122\218\31\179\19\62");
					end
				end
				if ((1784 < 2184) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\129\215\221\213\198\179\118\167\196\196\202\204", "\37\211\182\173\161\169\193")]:IsReady()) then
					if (v54.CastTargetIf(v55.RaptorStrike, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\250\59\85", "\217\151\90\45\185\72\27"), v74, nil, not v13:IsInMeleeRange(v68)) or (1649 > 4231)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\125\247\6\89\209\67\244\6\68\202\119\226\82\69\215\60\179\68", "\54\163\28\135\114");
					end
				end
				if ((3193 == 3193) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\27\207\88\135\66\75\58\218\77", "\31\72\187\61\226\46")]:IsCastable()) then
					if (v25(v55.SteelTrap, not v13:IsInRange(40)) or (3495 > 4306)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\18\70\215\75\65\48\209\7\83\146\84\106\100\151\94", "\68\163\102\35\178\39\30");
					end
				end
				for v135, v136 in pairs(v69) do
					if ((4001 > 3798) and v136:IsCastable() and (v13:DebuffDown(v70[v135]))) then
						if (v25(v136, not v13:IsSpellInRange(v136)) or (4688 <= 4499)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\169\121\214\195\5\188\145\20\129\114\213\202\1\245\144\5\254\37\138", "\113\222\16\186\167\99\213\227");
						end
					end
				end
				v113 = 6;
			end
			if ((v113 == 1) or (1567 <= 319)) then
				if ((v13:DebuffUp(v55.ShreddedArmorDebuff) and ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\138\238\40\162\193\85\175\226\6\169\202\94", "\60\221\135\68\198\167")]:FullRechargeTime() < (2 * v12:GCD())) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\204\178\245\129\67\203\234\180\253\145", "\185\142\221\152\227\34")]:IsAvailable() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\123\202\88\232\71\58\249\89\209\82\254\98\32\228\89\208\91\238", "\151\56\165\55\154\35\83")]:CooldownUp()) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\130\76\8\236\161\81\1\231\165\81", "\142\192\35\101")]:IsAvailable() and v12:BuffUp(v55.CoordinatedAssaultBuff) and (v12:BuffRemains(v55.CoordinatedAssaultBuff) < (2 * v12:GCD()))))) or (v66 < 7) or (4583 == 3761)) then
					for v151, v152 in pairs(v69) do
						if ((3454 > 1580) and v152:IsCastable()) then
							if (v25(v152, not v13:IsSpellInRange(v152)) or (1607 == 20)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\193\124\37\167\225\133\190\19\233\119\38\174\229\204\191\2\150\34", "\118\182\21\73\195\135\236\204");
							end
						end
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\35\53\22\76\39\2\240\5\61\20\68", "\157\104\92\122\32\100\109")]:IsCastable() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\136\175\195\198\30\40\128\166\162\168\203", "\203\195\198\175\170\93\71\237")]:FullRechargeTime() < v12:GCD()) and v71(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\5\66\50\217\114\30\241\35\74\48\209", "\156\78\43\94\181\49\113")]:ExecuteTime(), 21) and ((v12:BuffStack(v55.DeadlyDuoBuff) > 2) or (v12:BuffUp(v55.SpearheadBuff) and v13:DebuffRemains(v55.PheromoneBombDebuff)))) or (962 >= 4666)) then
					if (v54.CastTargetIf(v55.KillCommand, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\127\225\202", "\25\18\136\164\195\107\35"), v73, nil, not v13:IsSpellInRange(v55.KillCommand)) or (1896 == 1708)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\36\165\67\77\191\206\181\229\44\167\75\50\175\213\248\176", "\216\136\77\201\47\18\220\161");
					end
				end
				if ((3985 >= 1284) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\6\229\39\214\43\211\143\32\237\37\222", "\226\77\140\75\186\104\188")]:IsCastable() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\142\199\220\59\73\176\220\213\29\64\180\204", "\47\217\174\176\95")]:FullRechargeTime() < (3 * v12:GCD())) and v12:HasTier(30, 4) and v12:BuffDown(v55.SpearheadBuff)) then
					if (v54.CastTargetIf(v55.KillCommand, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\181\212\120", "\70\216\189\22\98\210\52\24"), v73, v75, not v13:IsSpellInRange(v55.KillCommand)) or (1987 == 545)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\214\175\139\236\217\208\174\138\210\212\219\227\148\199\154\134", "\179\186\191\195\231");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\212\48\22\227\246\48\11\225\219\54\12\225", "\132\153\95\120")]:IsReady() and (v12:BuffUp(v55.SpearheadBuff))) or (4896 < 1261)) then
					if ((23 < 3610) and v25(v55.MongooseBite, not v13:IsInMeleeRange(v68))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\188\189\0\42\248\213\179\180\141\12\36\227\223\224\162\166\78\124\167", "\192\209\210\110\77\151\186");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\205\12\44\238\240\203\243\6\0\224\235\193", "\164\128\99\66\137\159")]:IsReady() and (((v63 == 1) and (v13:TimeToDie() < ((v12:Focus() / (v67 - v12:FocusCastRegen(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\45\134\231\185\15\134\250\187\34\128\253\187", "\222\96\233\137")]:ExecuteTime()))) * v12:GCD()))) or (v12:BuffUp(v55.MongooseFuryBuff) and (v12:BuffRemains(v55.MongooseFuryBuff) < v12:GCD())))) or (3911 < 2578)) then
					if (v25(v55.MongooseBite, not v13:IsInMeleeRange(v68)) or (4238 < 87)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\188\169\24\135\252\227\188\140\165\22\156\246\176\170\167\231\78\218", "\144\217\211\199\127\232\147");
					end
				end
				v113 = 2;
			end
		end
	end
	local function v87()
		local v114 = 0;
		local v115;
		local v116;
		while true do
			if ((2538 == 2538) and (2 == v114)) then
				v68 = (v115 and (40 + v116)) or (5 + v116);
				if ((4122 == 4122) and v29) then
					if ((v115 and not v13:IsInMeleeRange(8)) or (2371 > 2654)) then
						v63 = v13:GetEnemiesInSplashRangeCount(8);
					else
						v63 = #v12:GetEnemiesInRange(8);
					end
				else
					v63 = 1;
				end
				if (v115 or (3466 > 4520)) then
					v64 = v12:GetEnemiesInRange(40);
				else
					v64 = v12:GetEnemiesInRange(8);
				end
				v114 = 3;
			end
			if ((v114 == 0) or (951 >= 1027)) then
				v53();
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\194\133\118\74\201\222", "\38\172\173\226\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\66\30\47", "\143\45\113\76")];
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\140\183\27\59\180\189\15", "\92\216\216\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\90\61\169", "\157\59\82\204\32")];
				v114 = 1;
			end
			if ((3 == v114) or (1369 > 2250)) then
				if (v54.TargetIsValid() or v12:AffectingCombat() or (937 > 3786)) then
					local v140 = 0;
					while true do
						if ((v140 == 1) or (901 > 4218)) then
							if ((4779 > 4047) and (v66 == 11111)) then
								v66 = v9.FightRemains(v64, false);
							end
							break;
						end
						if ((4050 > 1373) and (v140 == 0)) then
							v65 = v9.BossFightRemains(nil, true);
							v66 = v65;
							v140 = 1;
						end
					end
				end
				if ((not (v12:IsMounted() or v12:IsInVehicle()) and v41) or (1037 > 4390)) then
					local v141 = 0;
					while true do
						if ((1407 <= 1919) and (1 == v141)) then
							if ((2526 >= 1717) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\251\163\233\195\73\178\194", "\215\182\198\135\167\25")]:IsCastable() and v45 and (v16:HealthPercentage() < v46)) then
								if (v25(v55.MendPet) or (3620 <= 2094)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\160\76\228\76\205\121\239\92", "\40\237\41\138");
								end
							end
							break;
						end
						if ((v141 == 0) or (1723 >= 2447)) then
							if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\191\53\238\45\75\228\189\53\236", "\129\237\80\152\68\61")]:IsCastable() or (1199 > 3543)) then
								if ((1617 < 3271) and v25(v55.RevivePet, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\99\173\18\250\10\18\24\97\173\16", "\56\49\200\100\147\124\119");
								end
							end
							if ((3085 > 1166) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\255\43\178\253\195\48\143\245\216", "\144\172\94\223")]:IsCastable() and v44 and v16:IsDeadOrGhost()) then
								if ((4493 >= 3603) and v25(v62[v42])) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\23\26\175\74\43\1\226\119\33\27", "\39\68\111\194");
								end
							end
							v141 = 1;
						end
					end
				end
				if ((2843 <= 2975) and v54.TargetIsValid()) then
					local v142 = 0;
					while true do
						if ((v142 == 0) or (1989 <= 174)) then
							if ((not v12:AffectingCombat() and not v28) or (209 > 2153)) then
								local v153 = 0;
								local v154;
								while true do
									if ((v153 == 0) or (2020 == 1974)) then
										v154 = v82();
										if (v154 or (1347 == 1360)) then
											return v154;
										end
										break;
									end
								end
							end
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\226\108\242\241\70\198\102\251\236\67\200\122", "\42\167\20\154\152")]:IsReady() and (v12:HealthPercentage() <= v48)) or (4461 == 3572)) then
								if (v25(v55.Exhilaration) or (2872 == 318)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\79\230\170\75\125\32\88\255\182\75\126\47", "\65\42\158\194\34\17");
								end
							end
							if ((568 == 568) and (v12:HealthPercentage() <= v37) and v56[LUAOBFUSACTOR_DECRYPT_STR_0("\50\34\83\0\57\229\8\250\21\41\87", "\142\122\71\50\108\77\141\123")]:IsReady()) then
								if ((4200 == 4200) and v25(v58.Healthstone, nil, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\29\167\254\20\47\29\177\235\23\53\16", "\91\117\194\159\120");
								end
							end
							v142 = 1;
						end
						if ((v142 == 1) or (4285 < 1369)) then
							if ((not v12:IsCasting() and not v12:IsChanneling()) or (3520 > 4910)) then
								local v155 = 0;
								local v156;
								while true do
									if ((2842 <= 4353) and (v155 == 0)) then
										v156 = v54.Interrupt(v55.Muzzle, 5, true);
										if (v156 or (3751 < 1643)) then
											return v156;
										end
										v155 = 1;
									end
									if ((v155 == 2) or (4911 == 3534)) then
										v156 = v54.Interrupt(v55.Muzzle, 5, true, v15, v58.MuzzleMouseover);
										if ((3001 > 16) and v156) then
											return v156;
										end
										v155 = 3;
									end
									if ((2875 <= 3255) and (v155 == 1)) then
										v156 = v54.InterruptWithStun(v55.Intimidation, 40);
										if ((368 < 4254) and v156) then
											return v156;
										end
										v155 = 2;
									end
									if ((v155 == 3) or (4841 <= 2203)) then
										v156 = v54.InterruptWithStun(v55.Intimidation, 40, nil, v15, v58.IntimidationMouseover);
										if ((4661 > 616) and v156) then
											return v156;
										end
										break;
									end
								end
							end
							if ((v49 and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\46\15\63\22\36\228\45\22\20\36\17\59\246\23\18\18\42", "\68\122\125\94\120\85\145")]:IsReady() and not v12:IsCasting() and not v12:IsChanneling() and (v54.UnitHasEnrageBuff(v13) or v54.UnitHasMagicBuff(v13))) or (1943 == 2712)) then
								if ((4219 >= 39) and v25(v55.TranquilizingShot, not v13:IsSpellInRange(v55.TranquilizingShot))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\19\21\220\78\205\213", "\218\119\124\175\62\168\185");
								end
							end
							if ((3967 > 2289) and not v115 and not v13:IsInMeleeRange(8)) then
								local v157 = 0;
								while true do
									if ((v157 == 0) or (851 > 2987)) then
										if ((4893 >= 135) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\132\227\88\193\166\228\71\194\177\248\77\225\164\247\68\193", "\164\197\144\40")]:IsCastable() and v52) then
											if (v25(v55.AspectoftheEagle) or (3084 > 3214)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\130\227\186\142\222\162\188\255\172\180\201\190\134\207\175\138\218\186\134\176\165\132\207", "\214\227\144\202\235\189");
											end
										end
										if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\197\164\149\107\31\188\93", "\92\141\197\231\27\112\211\51")]:IsCastable() and v50) or (3426 < 2647)) then
											if (v25(v55.Harpoon, not v13:IsSpellInRange(v55.Harpoon)) or (1576 == 4375)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\238\254\152\179\222\233\241\202\172\222\244", "\177\134\159\234\195");
											end
										end
										break;
									end
								end
							end
							v142 = 2;
						end
						if ((v142 == 3) or (2920 < 2592)) then
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\156\249\60\161\199\184\223\48\178\219\184\229\43", "\169\221\139\95\192")]:IsCastable() and v30) or (1110 >= 2819)) then
								if ((1824 <= 2843) and v25(v55.ArcaneTorrent, not v13:IsInRange(8))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\223\153\124\62\44\35\225\159\112\45\48\35\208\159\63\50\35\47\208\203\39\103\122", "\70\190\235\31\95\66");
								end
							end
							if ((3062 == 3062) and v25(v55.PoolFocus)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\138\237\21\234\236\180\229\90\192\234\185\247\9", "\133\218\130\122\134");
							end
							break;
						end
						if ((716 <= 4334) and (v142 == 2)) then
							if ((1001 < 3034) and v30) then
								local v158 = 0;
								local v159;
								while true do
									if ((v158 == 0) or (977 > 1857)) then
										v159 = v84();
										if (v159 or (868 > 897)) then
											return v159;
										end
										break;
									end
								end
							end
							if ((v63 < 3) or not v29 or (1115 == 4717)) then
								local v160 = 0;
								local v161;
								while true do
									if ((2740 < 4107) and (0 == v160)) then
										v161 = v86();
										if ((284 < 700) and v161) then
											return v161;
										end
										break;
									end
								end
							end
							if ((386 >= 137) and (v63 > 2)) then
								local v162 = 0;
								local v163;
								while true do
									if ((923 == 923) and (v162 == 0)) then
										v163 = v85();
										if (v163 or (4173 == 359)) then
											return v163;
										end
										break;
									end
								end
							end
							v142 = 3;
						end
					end
				end
				break;
			end
			if ((1722 == 1722) and (v114 == 1)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\12\49\228\253\229\239\192", "\209\88\94\131\154\137\138\179")][LUAOBFUSACTOR_DECRYPT_STR_0("\43\165\215", "\66\72\193\164\28\126\67\81")];
				v115 = v12:BuffUp(v55.AspectoftheEagle);
				v116 = (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\203\57\166\95\35", "\22\135\76\200\56\70")]:IsAvailable() and 3) or 0;
				v114 = 2;
			end
		end
	end
	local function v88()
		v9.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\15\234\241\210\213\181\57\48\191\203\209\210\183\61\46\191\241\203\200\162\44\53\240\237\132\222\186\120\25\239\234\199\146\227\11\41\239\243\203\206\183\61\56\191\225\221\156\132\55\54\246\241\197", "\88\92\159\131\164\188\195"));
	end
	v9.SetAPL(255, v87, v88);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\165\62\182\83\232\195\200\142\58\186\89\232\216\200\146\56\182\93\214\231\147\140\59\190", "\189\224\78\223\43\183\139")]();

