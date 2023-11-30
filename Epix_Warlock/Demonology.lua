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
		if ((v5 == 1) or (3352 >= 4892)) then
			return v6(...);
		end
		if ((v5 == 0) or (208 == 160)) then
			v6 = v0[v4];
			if ((3664 == 3664) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\140\198\12\221\204\216\46\217\159\194\19\222\205\212\41\233\188\222\80\221\214\218", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\159\37\2\49\118\177", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\210\53\233\83", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\209\88\178\85\249\120\177\67\238", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\152\120\104", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\100\67\3\55\70", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\157\204\242\37\44", "\75\220\163\183\106\98")];
	local v22 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\33\158\152\24\247", "\185\98\218\235\87")];
	local v23 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\232\61\52\242", "\202\171\92\71\134\190")];
	local v24 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\25\211\41\155\58", "\232\73\161\76")];
	local v25 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\59\207\76\126\113\116\248", "\135\108\174\62\18\30\23\147")];
	local v26 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\3\180", "\75\103\118\217")];
	local v27 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\228\91\125\25\182\16\212", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\56\37\146\173\22\242\205", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\225\170\194", "\174\103\142\197")];
	local v28 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\91\41\71", "\152\54\72\63\88\69\62")];
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
	local v48;
	local v49;
	local v50;
	local v51;
	local v52;
	local v53;
	local function v54()
		local v104 = 0;
		while true do
			if ((v104 == 3) or (3194 < 1510)) then
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\214\172\88\18\115\76\192", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\153\220\45\67\179\219\47\64\169\246\48\73\179\220\50", "\44\221\185\64")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\226\92\75\122\15\224\91", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\137\73\58\55\35\62\186\85\61\62", "\81\206\60\83\91\79")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\174\196\102\38\205\74\183", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\44\123\16\32\242\225\191\16\123\13\43\247\249\189\10\78", "\143\216\66\30\126\68\155")] or 0;
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\205\25\223\204\173\208\242", "\129\202\168\109\171\165\195\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\6\93\58\215\208\29\229\17\76\37\221\208\19\242\42", "\134\66\56\87\184\190\116")];
				v104 = 4;
			end
			if ((0 == v104) or (525 >= 3554)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\193\250\72\221\202\233\79", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\77\0\29\53\228\28\83\91\17\58", "\114\56\62\101\73\71\141")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\236\207\208\177\231\220\215", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\231\245\52\128\167\253\2\211\234\34", "\107\178\134\81\210\198\158")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\28\135\223\207\194\3\139\249\205\243\0\150\254\197\205", "\170\163\111\226\151")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\41\204\30\238\143\43\253\29\243\136\35\195\60\230\140\41", "\135\225\76\173\114")] or 0;
				v104 = 1;
			end
			if ((2414 <= 2972) and (v104 == 4)) then
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\52\29\175\16\229\38\38", "\85\92\81\105\219\121\139\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\218\161\89\72\115\214\239\182\118\64\112\216\232\178\66\65", "\191\157\211\48\37\28")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\236\26\224\8\51\209\24\231", "\90\191\127\148\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\81\138\62\27\119\148\39\24\118", "\119\24\231\78")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\40\177\94\213\78\22\145", "\113\226\77\197\42\188\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\19\224\189\63\4\196\186\40\2\245\185", "\213\90\118\148")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\43\160\66\68\85\41\167", "\45\59\78\212\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\32\89\148\142\148\29\164\224\24\89\141", "\144\112\54\227\235\230\78\205")];
				v104 = 5;
			end
			if ((3529 <= 3538) and (v104 == 1)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\216\17\252\113\248\170\237\31\228\113\249\163\245\32", "\150\205\189\112\144\24")] or 0;
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\225\12\2\251\179\125\138\192\23\20\199\185\114\131", "\230\180\127\103\179\214\28")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\172\16\72\162\227\220\184\166\31\65\158\219", "\175\204\201\113\36\214\139")] or 0;
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\118\173\133\33\191\109\169\148\4\164\108\177\179\39\184\118", "\83\205\24\217\224")] or 0;
				v104 = 2;
			end
			if ((v104 == 2) or (2861 < 458)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\151\252\213\199\40\220\167\110\170\221\207\206\35\249\186\119\170\247\205\203\41\218", "\30\222\146\161\162\90\174\210")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\113\46\103\249\72\82\77\48\103\200\82\82\93\51\123\243\86\68", "\32\56\64\19\156\58")] or 0;
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\106\67\70\240\122\136\183\14\77", "\107\57\54\43\157\21\230\231")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\142\5\225\176\210\200\200", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\174\147\71\211\120\123\40\135\177", "\24\92\207\225\44\131\25")] or 0;
				v104 = 3;
			end
			if ((1717 <= 4525) and (v104 == 5)) then
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\45\27\232\217\85\180\59", "\59\211\72\111\156\176")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\146\238\32\65\137\199\40\67\136\237\36\77\179\250\63\79\137\247", "\77\46\231\131")];
				break;
			end
		end
	end
	local v55 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\141\85\164\76\181\87\189", "\32\218\52\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\106\18\60\167\255\191\73\85\73\14", "\58\46\119\81\200\145\208\37")];
	local v56 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\28\141\34\160\166\190\61", "\86\75\236\80\204\201\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\86\68\122\138\240\132\126\78\112\156", "\235\18\33\23\229\158")];
	local v57 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\103\187\211\183\95\185\202", "\219\48\218\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\192\116\113\70\213\64\236\235\118\101", "\128\132\17\28\41\187\47")];
	local v58 = {};
	local v59 = v13:GetEquipment();
	local v60 = (v59[13] and v19(v59[13])) or v19(0);
	local v61 = (v59[14] and v19(v59[14])) or v19(0);
	local v62 = 11111;
	local v63 = 11111;
	local v64 = 0;
	local v65 = 0;
	local v66 = false;
	local v67 = false;
	local v68 = false;
	local v69 = 0;
	local v70 = 120;
	local v71 = 0;
	local v72 = 0;
	local v73 = 0;
	local v74 = 0;
	local v75;
	local v76, v77;
	v10:RegisterForEvent(function()
		local v105 = 0;
		while true do
			if ((v105 == 0) or (3178 <= 1524)) then
				v62 = 11111;
				v63 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\49\30\39\3\120\51\13\52\31\122\36\28\57\31\115\32\16\42\31\121", "\61\97\82\102\90"));
	local v78 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\143\33\166\70\200\89\13", "\105\204\78\203\43\167\55\126")][LUAOBFUSACTOR_DECRYPT_STR_0("\128\188\38\12\10\11\201\84", "\49\197\202\67\126\115\100\167")];
	v10:RegisterForEvent(function()
		v59 = v13:GetEquipment();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\7\119\254\16\165\100\97\18\106\234\0\176\123\123\25\111\224\10\168\119\112\16\126\251", "\62\87\59\191\73\224\54"));
	v10:RegisterForEvent(function()
		v55[LUAOBFUSACTOR_DECRYPT_STR_0("\207\3\244\205\232\4\221\220\235\6\251\199", "\169\135\98\154")]:RegisterInFlight();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\231\82\5\102\211\22\236\244\68\20\113\209\31\247\226\89\27\96\220\17", "\168\171\23\68\52\157\83"));
	v55[LUAOBFUSACTOR_DECRYPT_STR_0("\220\112\251\169\42\43\160\225\125\241\172\43", "\231\148\17\149\205\69\77")]:RegisterInFlight();
	local function v79()
		return v10[LUAOBFUSACTOR_DECRYPT_STR_0("\167\178\198\233\83\246\129\169\212\207\86\253\140\162", "\159\224\199\167\155\55")][LUAOBFUSACTOR_DECRYPT_STR_0("\222\254\44\241\248\230\50\198", "\178\151\147\92")] or 0;
	end
	local function v80(v106)
		local v107 = 0;
		local v108;
		while true do
			if ((4254 > 370) and (v107 == 1)) then
				return v108;
			end
			if ((v107 == 0) or (1635 == 1777)) then
				v108 = 0;
				for v139, v140 in pairs(v10[LUAOBFUSACTOR_DECRYPT_STR_0("\171\232\77\32\22\69\123\130\238\120\51\16\64\127", "\26\236\157\44\82\114\44")].Pets) do
					if ((v140[LUAOBFUSACTOR_DECRYPT_STR_0("\3\35\197\120\43\61\193\72", "\59\74\78\181")] <= v106) or (3338 >= 3993)) then
						v108 = v108 + 1;
					end
				end
				v107 = 1;
			end
		end
	end
	local function v81()
		return v10[LUAOBFUSACTOR_DECRYPT_STR_0("\2\196\91\72\183\44\208\84\73\135\36\211\86\95", "\211\69\177\58\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\224\117\210\252\202\165\225\93\224\251\202\163\236\118\251", "\171\215\133\25\149\137")] or 0;
	end
	local function v82()
		return v81() > 0;
	end
	local function v83()
		return v10[LUAOBFUSACTOR_DECRYPT_STR_0("\198\221\51\232\235\57\253\76\242\252\51\248\227\53", "\34\129\168\82\154\143\80\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\161\183\62\4\70\71\138\177\171\33\10\70\90\173\144\160\50\31\65\65\135", "\233\229\210\83\107\40\46")] or 0;
	end
	local function v84()
		return v83() > 0;
	end
	local function v85()
		return v10[LUAOBFUSACTOR_DECRYPT_STR_0("\230\87\51\196\1\200\67\60\197\49\192\64\62\211", "\101\161\34\82\182")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\31\92\255\223\241\150\47\228\6\92\236\255\247\144\47\252\4\86\240", "\78\136\109\57\158\187\130\226")] or 0;
	end
	local function v86()
		return v85() > 0;
	end
	local function v87()
		return v10[LUAOBFUSACTOR_DECRYPT_STR_0("\25\42\248\227\58\54\248\255\45\11\248\243\50\58", "\145\94\95\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\196\24\208\72\190\248\195\16\241\91\165\252\217\29\218\64", "\215\157\173\116\181\46")] or 0;
	end
	local function v88()
		return v87() > 0;
	end
	local function v89()
		return v10[LUAOBFUSACTOR_DECRYPT_STR_0("\18\161\138\224\222\60\181\133\225\238\52\182\135\247", "\186\85\212\235\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\136\2\210\54\252\92\230\148\4\255\45\231\87\204", "\56\162\225\118\158\89\142")] or 0;
	end
	local function v90()
		return v89() > 0;
	end
	local function v91(v109)
		return v109:DebuffDown(v55.DoomBrandDebuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\116\4\206\171\45\222\123\16\204\171\35\214", "\184\60\101\160\207\66")]:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) <= 3));
	end
	local function v92(v110)
		return v110:DebuffDown(v55.DoomBrandDebuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\25\131\114\184\62\132\91\169\61\134\125\178", "\220\81\226\28")]:InFlight() and (v110:DebuffRemains(v55.DoomBrandDebuff) <= 3)) or (v77 < 4);
	end
	local function v93(v111)
		return (v111:DebuffRefreshable(v55.Doom));
	end
	local function v94(v112)
		return v112:DebuffRemains(v55.DoomBrandDebuff) > 10;
	end
	local function v95()
		local v113 = 0;
		while true do
			if ((1154 <= 1475) and (v113 == 0)) then
				v71 = 12;
				v64 = 14 + v26(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\52\199\139\246\229\206\1\208\164\254\230\192\6\212\144\255", "\167\115\181\226\155\138")]:IsAvailable()) + v26(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\209\55\234\81\116\127\240\235\46\226\90\114\116\200\230", "\166\130\66\135\60\27\17")]:IsAvailable());
				v113 = 1;
			end
			if ((1 == v113) or (2610 < 1230)) then
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\116\69\217\112\34\119\67\222\125\63\74", "\80\36\42\174\21")]:IsReady() or (1448 == 3083)) then
					if ((3139 > 916) and v24(v55.PowerSiphon)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\94\31\32\127\92\47\36\115\94\24\56\116\14\0\37\127\77\31\58\120\79\4\119\40", "\26\46\112\87");
					end
				end
				if ((2954 == 2954) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\157\38\166\123\177\189\74\184\173", "\212\217\67\203\20\223\223\37")]:IsReady() and v45 and v13:BuffDown(v55.DemonicCoreBuff) and not v13:IsCasting(v55.Demonbolt) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\158\136\165\221\180\143\167\222\174", "\178\218\237\200")]:TimeSinceLastCast() >= 4)) then
					if ((117 <= 2892) and v24(v57.DemonboltPetAttack, not v14:IsSpellInRange(v55.Demonbolt), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\176\235\223\184\183\233\220\162\245\246\194\179\182\233\221\180\180\242\144\226", "\176\214\213\134");
					end
				end
				v113 = 2;
			end
			if ((v113 == 2) or (453 > 4662)) then
				if ((1320 > 595) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\199\165\183\208\167\65\123\251\161\162", "\57\148\205\214\180\200\54")]:IsReady()) then
					if (v24(v57.ShadowBoltPetAttack, not v14:IsSpellInRange(v55.ShadowBolt), true) or (3199 < 590)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\245\52\48\121\5\194\55\59\122\6\189\37\38\115\17\242\56\54\119\6\189\99", "\22\114\157\85\84");
					end
				end
				break;
			end
		end
	end
	local function v96()
		local v114 = 0;
		local v115;
		while true do
			if ((v114 == 1) or (4793 < 30)) then
				if ((not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\33\53\53\113\179\122\36\41\52\121\186\125\23\46\60", "\20\114\64\88\28\220")]:IsAvailable() and (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\22\19\219\185\247\217\175\52\39\215\184\255\197\188\35\5", "\221\81\97\178\212\152\176")]:IsAvailable() or not v13:HasTier(30, 2)) and v86()) or (1696 <= 1059)) then
					v65 = v85() - (v13:GCD() * 0.5);
				end
				if ((2343 == 2343) and ((not v88() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\254\242\16\246\21\195\209\20\247\31\203\238\24\245\30", "\122\173\135\125\155")]:IsAvailable()) or not v86())) then
					v65 = 0;
				end
				v66 = not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\170\196\20\177\58\35\248\139\211\20\184\51", "\168\228\161\96\217\95\81")]:IsAvailable() or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\245\212\58\84\42\69\235\222\60\72\46\91", "\55\187\177\78\60\79")]:CooldownRemains() > 30) or v13:BuffUp(v55.NetherPortalBuff);
				v115 = v26(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\30\207\92\249\79\201\137\46\203\91\216\73\218\140\62", "\224\77\174\63\139\38\175")]:IsAvailable());
				v114 = 2;
			end
			if ((v114 == 0) or (1043 > 3591)) then
				v70 = v55[LUAOBFUSACTOR_DECRYPT_STR_0("\247\222\30\201\82\248\140\193\198\28\202\84\245\156\221\217\18\202\73", "\200\164\171\115\164\61\150")]:CooldownRemains();
				if (v27(v69) or (2890 >= 4079)) then
					local v141 = 0;
					local v142;
					while true do
						if ((4474 <= 4770) and (0 == v141)) then
							v142 = 120 - (GetTime() - v25[LUAOBFUSACTOR_DECRYPT_STR_0("\146\245\16\81\179\151", "\227\222\148\99\37")]);
							if (((v142 > 0) and (((((v63 + v73) % 120) <= 85) and (((v63 + v73) % 120) >= 25)) or (v73 >= 210)) and v69 and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\20\64\83\248\253\4\83\64\250\246\48\89\65\210\252\32\91\85\248", "\153\83\50\50\150")]:IsAvailable()) or (4942 == 3903)) then
								v70 = v142;
							end
							break;
						end
					end
				end
				if ((v88() and v86()) or (248 > 4845)) then
					v65 = v28(v87(), v85()) - (v13:GCD() * 0.5);
				end
				if ((1569 == 1569) and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\110\99\126\17\124\165\123\84\122\118\26\122\174\67\89", "\45\61\22\19\124\19\203")]:IsAvailable() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\230\0\4\248\13\121\171\196\52\8\249\5\101\184\211\22", "\217\161\114\109\149\98\16")]:IsAvailable() and v86()) then
					v65 = v28(v85(), v81()) - (v13:GCD() * 0.5);
				end
				v114 = 1;
			end
			if ((v114 == 2) or (4927 <= 3221)) then
				if ((v77 > (1 + v115)) or (1780 > 2787)) then
					v67 = not v84();
				end
				if (((v77 > (2 + v115)) and (v77 < (5 + v115))) or (3937 <= 1230)) then
					v67 = v83() < 6;
				end
				if ((v77 > (4 + v115)) or (2637 < 1706)) then
					v67 = v83() < 8;
				end
				v68 = (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\183\84\85\35\139\79\124\43\137\78\86\39\135\117\65\60\133\79\76", "\78\228\33\56")]:CooldownRemains() < 20) and (v70 < 20) and ((v13:BuffStack(v55.DemonicCoreBuff) <= 2) or v13:BuffDown(v55.DemonicCoreBuff)) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\253\107\191\14\138\192\72\187\15\128\200\119\183\13\129", "\229\174\30\210\99")]:CooldownRemains() < (v74 * 5)) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\56\236\138\93\201\47\60\26\233\149\69\236\49\50\30\255\149", "\89\123\141\230\49\141\93")]:CooldownRemains() < (v74 * 5));
				break;
			end
		end
	end
	local function v97()
		local v116 = 0;
		while true do
			if ((v116 == 1) or (2669 <= 2409)) then
				ShouldReturn = v78.HandleBottomTrinket(v58, v31, 40, nil);
				if (ShouldReturn or (1401 > 4696)) then
					return ShouldReturn;
				end
				break;
			end
			if ((0 == v116) or (3280 < 1321)) then
				ShouldReturn = v78.HandleTopTrinket(v58, v31, 40, nil);
				if ((4927 >= 2303) and ShouldReturn) then
					return ShouldReturn;
				end
				v116 = 1;
			end
		end
	end
	local function v98()
		local v117 = 0;
		while true do
			if ((3462 >= 1032) and (v117 == 0)) then
				if ((v56[LUAOBFUSACTOR_DECRYPT_STR_0("\199\120\251\9\18\88\246\112\245\4\25\68\244\69\247\0\31\68", "\42\147\17\150\108\112")]:IsEquippedAndReady() and (v13:BuffUp(v55.DemonicPowerBuff) or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\60\179\32\114\232\230\43\163\32\112\233\225\12\146\52\109\230\230\27", "\136\111\198\77\31\135")]:IsAvailable() and (v13:BuffUp(v55.NetherPortalBuff) or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\44\12\179\94\184\246\39\166\16\29\166\90", "\201\98\105\199\54\221\132\119")]:IsAvailable())))) or (1077 >= 2011)) then
					if ((1543 < 2415) and v24(v57.TimebreachingTalon)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\5\142\36\0\39\169\184\15\139\40\12\50\147\173\13\143\46\12\117\165\173\9\142\50\66\103", "\204\217\108\227\65\98\85");
					end
				end
				if (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\109\214\248\232\35\206\122\198\248\234\34\201\93\247\236\247\45\206\74", "\160\62\163\149\133\76")]:IsAvailable() or v13:BuffUp(v55.DemonicPowerBuff) or (4444 < 2015)) then
					local v143 = 0;
					local v144;
					while true do
						if ((0 == v143) or (4200 == 2332)) then
							v144 = v97();
							if (v144 or (1278 >= 1316)) then
								return v144;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v99()
		local v118 = 0;
		while true do
			if ((1082 == 1082) and (v118 == 0)) then
				if ((1328 <= 4878) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\244\165\31\60\198\196\171\4\33\196", "\163\182\192\109\79")]:IsCastable()) then
					if ((4087 >= 1355) and v24(v55.Berserking)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\54\35\18\211\240\38\45\9\206\242\116\41\7\195\241\116\114", "\149\84\70\96\160");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\26\10\2\226\60\32\24\255\33", "\141\88\102\109")]:IsCastable() or (590 > 4650)) then
					if (v24(v55.BloodFury) or (3774 <= 3667)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\95\197\127\30\2\83\212\161\74\138\127\29\62\81\129\229", "\161\211\51\170\16\122\93\53");
					end
				end
				v118 = 1;
			end
			if ((1270 < 2146) and (v118 == 1)) then
				if ((4563 >= 56) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\221\167\160\45\249\162\189\39\255", "\72\155\206\210")]:IsCastable()) then
					if (v24(v55.Fireblood) or (446 == 622)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\64\115\70\11\49\74\117\91\10\115\73\125\87\10\115\30", "\83\38\26\52\110");
					end
				end
				break;
			end
		end
	end
	local function v100()
		local v119 = 0;
		while true do
			if ((2069 > 1009) and (v119 == 0)) then
				if ((12 < 4208) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\112\22\41\66\87\17\0\83\84\19\38\72", "\38\56\119\71")]:IsReady() and (v65 > (v74 + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\192\250\85\219\42\88\215\234\85\217\43\95\240\219\65\196\36\88\231", "\54\147\143\56\182\69")]:CastTime())) and (v65 < (v74 * 4))) then
					if (v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan)) or (2990 <= 2980)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\128\241\77\224\217\135\192\78\202\218\133\254\71\159\194\152\237\72\209\194\193\173", "\191\182\225\159\41");
					end
				end
				if (((v65 > 0) and (v65 < (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\24\7\37\88\132\137\230\46\31\39\91\130\132\246\50\0\41\91\159", "\162\75\114\72\53\235\231")]:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55[LUAOBFUSACTOR_DECRYPT_STR_0("\191\52\69\230\92\21\174\51\72\246", "\98\236\92\36\130\51")]:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v74) + v74))) or (2575 >= 4275)) then
					local v145 = 0;
					local v146;
					local v147;
					while true do
						if ((1 == v145) or (3626 <= 1306)) then
							v146 = v99();
							if ((1368 < 3780) and v146) then
								return v146;
							end
							v145 = 2;
						end
						if ((v145 == 0) or (3169 == 2273)) then
							v146 = v98();
							if ((2481 <= 3279) and v146) then
								return v146;
							end
							v145 = 1;
						end
						if ((v145 == 2) or (1063 <= 877)) then
							v147 = v78.HandleDPSPotion();
							if ((2314 == 2314) and v147) then
								return v147;
							end
							break;
						end
					end
				end
				if ((924 >= 477) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\151\12\1\183\74\166\145\53\169\22\2\179\70\156\172\34\165\23\24", "\80\196\121\108\218\37\200\213")]:IsCastable() and (v65 > 0) and (v65 < (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\51\102\15\114\68\0\174\5\126\13\113\66\13\190\25\97\3\113\95", "\234\96\19\98\31\43\110")]:ExecuteTime() + (v26(v13:BuffDown(v55.DemonicCoreBuff)) * v55[LUAOBFUSACTOR_DECRYPT_STR_0("\53\23\83\195\163\101\169\9\19\70", "\235\102\127\50\167\204\18")]:ExecuteTime()) + (v26(v13:BuffUp(v55.DemonicCoreBuff)) * v74) + v74))) then
					if ((1813 <= 3778) and v23(v55.SummonDemonicTyrant, v53)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\180\248\46\75\32\111\165\240\46\75\32\89\162\202\55\93\60\81\175\225\99\80\55\66\160\251\55\4\120", "\78\48\193\149\67\36");
					end
				end
				if ((4150 == 4150) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\25\19\144\20\78\35\23\143\22", "\33\80\126\224\120")]:IsReady() and (v79() > 2) and not v86() and not v82() and not v88() and ((v77 > 3) or ((v77 > 2) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\203\186\2\202\88\219\169\17\200\83\239\163\16\224\89\255\161\4\202", "\60\140\200\99\164")]:IsAvailable()))) then
					if ((432 <= 3007) and v23(v55.Implosion, v50, nil, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\142\249\20\42\173\148\253\11\40\226\147\237\22\39\172\147\180\92", "\194\231\148\100\70");
					end
				end
				v119 = 1;
			end
			if ((v119 == 2) or (408 > 2721)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\192\22\36\29\141\86\46\127\255\6\47\25\135\86\28", "\22\147\99\73\112\226\56\120")]:IsReady() and ((v72 == 5) or v13:BuffUp(v55.NetherPortalBuff)) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\139\96\239\248\130\182\81\231\248\130\182\124\225\193\148\170\116\236\225", "\237\216\21\130\149")]:CooldownRemains() < 13) and v66) or (3418 < 2497)) then
					if ((1735 < 2169) and v23(v55.SummonVilefiend)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\145\91\82\82\191\199\97\148\71\83\90\182\192\91\140\74\31\75\169\219\95\140\90\31\14\232", "\62\226\46\63\63\208\169");
					end
				end
				if ((3890 >= 3262) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\198\24\89\143\59\31\42\95\225\10\65\130\19\6\42\76\246", "\62\133\121\53\227\127\109\79")]:IsReady() and (v88() or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\35\1\63\248\217\160\148\25\24\55\243\223\171\172\20", "\194\112\116\82\149\182\206")]:IsAvailable() and (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\23\173\88\16\197\240\62\54\186\88\25\204", "\110\89\200\44\120\160\130")]:IsAvailable() or v13:BuffUp(v55.NetherPortalBuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\133\198\95\78\70\88\11\66\185\215\74\74", "\45\203\163\43\38\35\42\91")]:CooldownRemains() > 30)) and (v13:BuffUp(v55.NetherPortalBuff) or v82() or (v72 == 5)))) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\225\144\209\46\136\167\112\215\136\211\45\142\170\96\203\151\221\45\147", "\52\178\229\188\67\231\201")]:CooldownRemains() < 11) and v66) then
					if (v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers)) or (4356 >= 4649)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\64\92\8\200\88\49\36\64\84\23\227\93\47\42\68\66\23\183\72\58\51\64\94\16\183\14\115", "\67\65\33\48\100\151\60");
					end
				end
				if ((3904 == 3904) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\248\245\167\213\252\214\245\171\254\246\211\224\187\217\225\219", "\147\191\135\206\184")]:IsReady() and (v88() or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\183\61\171\204\215\93\132\141\36\163\199\209\86\188\128", "\210\228\72\198\161\184\51")]:IsAvailable() and (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\24\76\231\24\118\220\6\70\225\4\114\194", "\174\86\41\147\112\19")]:IsAvailable() or v13:BuffUp(v55.NetherPortalBuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\117\5\153\3\32\29\33\164\73\20\140\7", "\203\59\96\237\107\69\111\113")]:CooldownRemains() > 30)) and (v13:BuffUp(v55.NetherPortalBuff) or v86() or (v72 == 5)) and v66))) then
					if (v23(v55.GrimoireFelguard, v49, nil, not v14:IsSpellInRange(v55.GrimoireFelguard)) or (2860 >= 3789)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\4\165\236\62\249\197\33\41\170\228\61\247\194\37\4\168\161\37\233\197\37\24\184\161\99\162", "\183\68\118\204\129\81\144");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\38\172\126\224\4\132\41\184\124\224\10\140", "\226\110\205\16\132\107")]:IsReady() and (v72 > 2) and (v88() or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\216\214\237\212\78\229\245\233\213\68\237\202\229\215\69", "\33\139\163\128\185")]:IsAvailable() and v86())) and ((v72 > 2) or (v87() < ((v74 * 2) + (2 / v13:SpellHaste()))))) or (1086 > 4449)) then
					if ((4981 > 546) and v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\89\10\218\104\87\2\225\80\77\8\218\86\86\68\202\78\74\5\208\67\24\86\138", "\190\55\56\100");
					end
				end
				v119 = 3;
			end
			if ((v119 == 1) or (2366 <= 8)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\117\68\192\167\249\223\100\67\205\183", "\168\38\44\161\195\150")]:IsReady() and v13:PrevGCDP(1, v55.GrimoireFelguard) and (v73 > 30) and v13:BuffDown(v55.NetherPortalBuff) and v13:BuffDown(v55.DemonicCoreBuff)) or (2590 == 2864)) then
					if (v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or (2624 > 4149)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\147\244\131\114\63\255\137\20\143\240\150\54\36\241\164\23\142\232\194\39\96", "\118\224\156\226\22\80\136\214");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\114\225\78\133\80\221\80\144\74\225\87", "\224\34\142\57")]:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) < 4) and (not v88() or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\237\178\200\208\124\255\107\7\210\162\195\212\118\255\89", "\110\190\199\165\189\19\145\61")]:IsAvailable() and v85())) and v13:BuffDown(v55.NetherPortalBuff)) or (2618 >= 4495)) then
					if (v23(v55.PowerSiphon, v52) or (2485 >= 3131)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\202\228\96\237\153\248\201\226\103\224\132\201\154\255\110\250\138\201\206\171\38\186", "\167\186\139\23\136\235");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\41\189\137\9\21\162\170\2\22\161", "\109\122\213\232")]:IsReady() and not v88() and v13:BuffDown(v55.NetherPortalBuff) and not v86() and (v72 < (5 - v13:BuffStack(v55.DemonicCoreBuff)))) or (2804 <= 2785)) then
					if (v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt)) or (4571 == 3415)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\255\163\52\225\224\157\50\225\251\182\112\250\238\176\49\224\227\226\97\186", "\80\142\151\194");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\45\195\99\68\6\212\71\67\17\210\118\64", "\44\99\166\23")]:IsReady() and (v72 == 5)) or (4441 > 4787)) then
					if ((1920 == 1920) and v23(v55.NetherPortal, v51)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\114\242\61\62\54\182\67\231\38\36\39\165\112\183\61\47\33\165\114\227\105\103\101", "\196\28\151\73\86\83");
					end
				end
				v119 = 2;
			end
			if ((v119 == 3) or (647 == 4477)) then
				if ((3819 == 3819) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\114\170\49\17\29\225\252\90\187", "\147\54\207\92\126\115\131")]:IsReady() and (v72 < 4) and v13:BuffUp(v55.DemonicCoreBuff) and (v88() or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\62\36\56\112\2\112\59\56\57\120\11\119\8\63\49", "\30\109\81\85\29\109")]:IsAvailable() and v86()))) then
					if (v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt)) or (1466 > 4360)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\116\89\185\56\220\243\243\101\20\162\47\204\253\241\101\20\228\96", "\156\159\17\52\214\86\190");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\158\224\170\185\188\220\180\172\166\224\179", "\220\206\143\221")]:IsReady() and (((v13:BuffStack(v55.DemonicCoreBuff) < 3) and (v65 > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\181\104\32\26\215\194\246\131\112\34\25\209\207\230\159\111\44\25\204", "\178\230\29\77\119\184\172")]:ExecuteTime() + (v74 * 3)))) or (v65 == 0))) or (14 > 994)) then
					if ((401 <= 734) and v23(v55.PowerSiphon, v52)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\177\29\30\101\199\230\183\26\19\120\246\181\170\19\9\118\246\225\254\88\67", "\152\149\222\106\123\23");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\238\46\247\71\186\202\4\249\79\161", "\213\189\70\150\35")]:IsCastable() or (2167 >= 3426)) then
					if ((764 < 3285) and v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\93\117\12\64\66\75\10\64\89\96\72\91\76\102\9\65\65\52\91\31", "\104\47\53\20");
					end
				end
				break;
			end
		end
	end
	local function v101()
		local v120 = 0;
		while true do
			if ((2499 == 2499) and (v120 == 2)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\178\222\182\136\171\183\139\193\169\130\183", "\228\226\177\193\237\217")]:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) < 3) and (v63 < 20)) or (692 >= 4933)) then
					if (v23(v55.PowerSiphon, v52) or (3154 <= 2260)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\36\191\52\227\38\143\48\239\36\184\44\232\116\182\42\225\60\164\28\227\58\180\99\183\96", "\134\84\208\67");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\58\161\150\80\28\191\143\83\29", "\60\115\204\230")]:IsReady() and (v63 < (2 * v74))) or (2637 > 3149)) then
					if (v23(v55.Implosion, v50, nil, not v14:IsInRange(40)) or (3992 < 2407)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\238\55\251\124\232\41\226\127\233\122\237\121\224\50\255\79\226\52\239\48\182\108", "\16\135\90\139");
					end
				end
				break;
			end
			if ((v120 == 0) or (2902 > 4859)) then
				if ((1679 < 4359) and (v63 < 20)) then
					local v148 = 0;
					while true do
						if ((1913 < 4670) and (v148 == 0)) then
							if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\132\94\136\17\179\6\177\73\167\25\176\8\182\77\147\24", "\111\195\44\225\124\220")]:IsReady() or (2846 < 879)) then
								if ((4588 == 4588) and v23(v55.GrimoireFelguard, v49)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\223\84\9\126\164\162\202\67\63\117\174\167\223\83\1\97\175\235\222\79\7\123\191\148\221\72\4\51\249", "\203\184\38\96\19\203");
								end
							end
							if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\26\114\117\77\234\43\118\120\69\221\45\114\117\74\203\43\96", "\174\89\19\25\33")]:IsReady() or (347 == 2065)) then
								if (v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers)) or (1311 > 2697)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\44\19\94\66\200\131\25\42\19\86\93\227\134\7\36\23\64\93\183\129\2\40\26\70\113\242\137\15\111\70", "\107\79\114\50\46\151\231");
								end
							end
							v148 = 1;
						end
						if ((v148 == 1) or (2717 > 3795)) then
							if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\10\179\184\36\133\55\129\201\53\163\179\32\143\55\179", "\160\89\198\213\73\234\89\215")]:IsReady() or (1081 < 391)) then
								if (v23(v55.SummonVilefiend) or (121 > 3438)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\91\100\185\243\202\70\78\162\247\201\77\119\189\251\203\76\49\178\247\194\64\101\139\251\203\76\49\226", "\165\40\17\212\158");
								end
							end
							break;
						end
					end
				end
				if ((71 < 1949) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\203\220\28\59\35\247\233\7\33\50\228\213", "\70\133\185\104\83")]:IsReady() and (v63 < 30)) then
					if ((4254 == 4254) and v23(v55.NetherPortal, v51)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\64\80\34\204\22\122\84\37\219\16\68\72\106\207\13\66\76\62\246\1\75\64\106\145", "\169\100\37\36\74");
					end
				end
				v120 = 1;
			end
			if ((3196 >= 2550) and (v120 == 1)) then
				if ((2456 < 4176) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\51\146\175\93\15\137\134\85\13\136\172\89\3\179\187\66\1\137\182", "\48\96\231\194")]:IsCastable() and (v63 < 20)) then
					if (v23(v55.SummonDemonicTyrant, v53) or (1150 == 3452)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\79\3\32\22\214\144\135\205\87\1\35\16\219\144\151\209\72\15\35\13\152\169\138\207\82\26\18\28\214\171\195\153\10", "\227\168\58\110\77\121\184\207");
					end
				end
				if ((1875 < 2258) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\95\57\178\79\191\210\114\150\111\46\186\78\182\207\121", "\197\27\92\223\32\209\187\17")]:IsCastable() and (v63 < 10)) then
					if ((1173 > 41) and v23(v55.DemonicStrength, v48)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\90\206\244\13\86\192\196\16\75\209\254\13\88\215\243\67\89\202\252\11\75\252\254\13\91\131\170\81", "\155\99\63\163");
					end
				end
				v120 = 2;
			end
		end
	end
	local function v102()
		local v121 = 0;
		while true do
			if ((v121 == 2) or (56 >= 3208)) then
				if ((4313 > 3373) and v30) then
					local v149 = 0;
					while true do
						if ((v149 == 0) or (4493 == 2225)) then
							v76 = v14:GetEnemiesInSplashRange(8);
							v77 = v14:GetEnemiesInSplashRangeCount(8);
							v149 = 1;
						end
						if ((3104 >= 3092) and (v149 == 1)) then
							v75 = v13:GetEnemiesInRange(40);
							break;
						end
					end
				else
					local v150 = 0;
					while true do
						if ((3548 > 3098) and (v150 == 1)) then
							v75 = {};
							break;
						end
						if ((v150 == 0) or (3252 == 503)) then
							v76 = {};
							v77 = 1;
							v150 = 1;
						end
					end
				end
				v25.UpdatePetTable();
				v121 = 3;
			end
			if ((4733 > 2066) and (v121 == 0)) then
				v54();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\123\1\52\66\81\107", "\24\52\20\102\83\46\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\32\34", "\111\164\79\65\68")];
				v121 = 1;
			end
			if ((3549 >= 916) and (v121 == 4)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\233\156\82\15\3\227\234\140\75", "\141\186\233\63\98\108")]:IsCastable() and not (v13:IsMounted() or v13:IsInVehicle()) and v43 and not v17:IsActive()) or (2189 <= 245)) then
					local v151 = 0;
					while true do
						if ((v151 == 0) or (1389 > 3925)) then
							if ((4169 >= 3081) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\215\239\32\146\42\252\227\34\183\49\248\229\34", "\69\145\138\76\214")]:IsCastable()) then
								if ((349 <= 894) and v24(v55.FelDomination, nil, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\118\202\133\182\187\25\125\198\135\136\171\31\127\193\201\134\176\21", "\118\16\175\233\233\223");
								end
							end
							if ((731 <= 2978) and v24(v55.SummonPet, false, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\152\145\56\182\225\133\66\155\129\33\251\225\132\126", "\29\235\228\85\219\142\235");
							end
							break;
						end
					end
				end
				if (v78.TargetIsValid() or (892 > 3892)) then
					local v152 = 0;
					local v153;
					while true do
						if ((v152 == 4) or (4466 == 900)) then
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\214\162\199\115\91\248\132\220\123\80\255\173", "\52\158\195\169\23")]:IsReady() and (v72 > 2) and not ((v77 == 1) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\93\174\51\122\130\2\122\153\118\179\49\127\149\17\126\152\115\187\60", "\235\26\220\82\20\230\85\27")]:IsAvailable())) or (2084 >= 2888)) then
								if ((479 < 1863) and v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\128\160\231\198\75\135\167\214\197\97\132\165\232\204\52\133\160\224\204\52\218\249", "\20\232\193\137\162");
								end
							end
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\6\218\200\169\233\142\24\125\54", "\17\66\191\165\198\135\236\119")]:IsReady() and (v13:BuffStack(v55.DemonicCoreBuff) > 1) and (((v72 < 4) and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\60\160\187\31\204\252\254\216\4\170", "\177\111\207\206\115\159\136\140")]:IsAvailable()) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\54\134\5\24\231\91\77\12\130\21", "\63\101\233\112\116\180\47")]:CooldownRemains() > (v74 * 2)) or (v72 < 2)) and not v68) or (2428 >= 4038)) then
								if (v78.CastCycle(v55.Demonbolt, v76, v92, not v14:IsSpellInRange(v55.Demonbolt)) or (2878 > 2897)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\199\62\224\29\246\52\204\55\249\82\245\55\202\53\173\65\168", "\86\163\91\141\114\152");
								end
							end
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\119\14\121\124\52\81\4\120\103", "\90\51\107\20\19")]:IsReady() and v13:HasTier(31, 2) and v13:BuffUp(v55.DemonicCoreBuff) and (v72 < 4) and not v68) or (2469 > 3676)) then
								if ((233 < 487) and v78.CastTargetIf(v55.Demonbolt, v76, LUAOBFUSACTOR_DECRYPT_STR_0("\208\173", "\93\237\144\229\143"), v92, v94, not v14:IsSpellInRange(v55.Demonbolt))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\17\243\253\22\5\68\26\250\228\89\6\71\28\248\176\74\89", "\38\117\150\144\121\107");
								end
							end
							if ((2473 >= 201) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\9\190\227\53\35\185\225\54\57", "\90\77\219\142")]:IsReady() and (v63 < (v13:BuffStack(v55.DemonicCoreBuff) * v74))) then
								if ((4120 >= 133) and v23(v55.Demonbolt, nil, nil, not v14:IsSpellInRange(v55.Demonbolt))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\226\1\44\54\66\5\117\234\16\97\52\77\14\116\166\87\117", "\26\134\100\65\89\44\103");
								end
							end
							if ((3080 >= 1986) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\213\230\61\44\170\243\236\60\55", "\196\145\131\80\67")]:IsReady() and v13:BuffUp(v55.DemonicCoreBuff) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\46\191\17\13\10\219\23\160\14\7\22", "\136\126\208\102\104\120")]:CooldownRemains() < 4) and (v72 < 4) and not v68) then
								if (v78.CastCycle(v55.Demonbolt, v76, v92, not v14:IsSpellInRange(v55.Demonbolt)) or (1439 > 3538)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\124\143\195\76\161\80\50\93\108\202\195\66\166\92\125\2\46", "\49\24\234\174\35\207\50\93");
								end
							end
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\60\253\234\141\99\63\251\237\128\126\2", "\17\108\146\157\232")]:IsReady() and (v13:BuffDown(v55.DemonicCoreBuff))) or (419 < 7)) then
								if ((2820 == 2820) and v23(v55.PowerSiphon, v52)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\91\204\3\232\61\151\88\202\4\229\32\166\11\206\21\228\33\232\24\155", "\200\43\163\116\141\79");
								end
							end
							v152 = 5;
						end
						if ((v152 == 1) or (4362 <= 3527)) then
							v153 = v98();
							if ((2613 <= 2680) and v153) then
								return v153;
							end
							if ((v63 < 30) or (1482 >= 4288)) then
								local v155 = 0;
								local v156;
								while true do
									if ((0 == v155) or (2462 > 4426)) then
										v156 = v101();
										if ((4774 == 4774) and v156) then
											return v156;
										end
										break;
									end
								end
							end
							if ((566 <= 960) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\20\68\210\176\245\123\42\41\73\216\181\244", "\109\92\37\188\212\154\29")]:IsReady() and (v73 < 0.5) and (((v63 % 95) > 40) or ((v63 % 95) < 15)) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\54\234\173\196\63\85\2\219\189\209\48\84\10\246", "\58\100\143\196\163\81")]:IsAvailable() or (v77 > 2))) then
								if (v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan)) or (2910 <= 1930)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\18\67\45\167\0\70\227\49\29\87\47\167\62\71\165\3\27\75\45\227\109", "\110\122\34\67\195\95\41\133");
								end
							end
							if (((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\70\164\86\71\217\123\149\94\71\217\123\184\88\126\207\103\176\85\94", "\182\21\209\59\42")]:CooldownRemains() < 15) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\132\66\200\16\46\176\129\94\201\24\39\183\178\89\193", "\222\215\55\165\125\65")]:CooldownRemains() < (v74 * 5)) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\15\208\202\22\214\211\232\75\40\194\210\27\254\202\232\88\63", "\42\76\177\166\122\146\161\141")]:CooldownRemains() < (v74 * 5)) and ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\130\152\12\195\118\127\183\143\35\203\117\113\176\139\23\202", "\22\197\234\101\174\25")]:CooldownRemains() < 10) or not v13:HasTier(30, 2)) and (not v69 or (v70 < 15) or (v63 < 40) or v13:PowerInfusionUp())) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\30\33\168\209\121\161\225\143\33\49\163\213\115\161\211", "\230\77\84\197\188\22\207\183")]:IsAvailable() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\202\1\203\241\131\175\212\48\244\27\200\245\143\149\233\39\248\26\210", "\85\153\116\166\156\236\193\144")]:CooldownRemains() < 15) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\151\245\64\190\235\14\146\233\65\182\226\9\161\238\73", "\96\196\128\45\211\132")]:CooldownRemains() < (v74 * 5)) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\22\140\119\83\246\189\177\217\49\158\111\94\222\164\177\202\38", "\184\85\237\27\63\178\207\212")]:CooldownRemains() < (v74 * 5)) and ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\47\75\0\82\7\80\27\90\46\92\5\88\29\88\27\91", "\63\104\57\105")]:CooldownRemains() < 10) or not v13:HasTier(30, 2)) and (not v69 or (v70 < 15) or (v63 < 40) or v13:PowerInfusionUp())) or (19 > 452)) then
								local v157 = 0;
								local v158;
								while true do
									if ((v157 == 0) or (907 > 3152)) then
										v158 = v100();
										if (v158 or (2505 > 4470)) then
											return v158;
										end
										break;
									end
								end
							end
							if (((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\56\146\169\73\4\137\128\65\6\136\170\77\8\179\189\86\10\137\176", "\36\107\231\196")]:CooldownRemains() < 15) and (v88() or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\110\160\175\138\82\187\148\142\81\176\164\142\88\187\166", "\231\61\213\194")]:IsAvailable() and (v82() or v55[LUAOBFUSACTOR_DECRYPT_STR_0("\46\191\52\126\6\164\47\118\47\168\49\116\28\172\47\119", "\19\105\205\93")]:CooldownUp() or not v13:HasTier(30, 2)))) and (not v69 or (v70 < 15) or (v63 < 40) or v13:PowerInfusionUp())) or (3711 > 4062)) then
								local v159 = 0;
								local v160;
								while true do
									if ((420 == 420) and (v159 == 0)) then
										v160 = v100();
										if (v160 or (33 >= 3494)) then
											return v160;
										end
										break;
									end
								end
							end
							v152 = 2;
						end
						if ((v152 == 3) or (1267 == 4744)) then
							if ((2428 < 3778) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\219\66\244\89\95\117\232\94\243\80", "\26\156\55\157\53\51")]:IsCastable() and (v13:BuffRemains(v55.NetherPortalBuff) < v74) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\168\221\27\214\182\89\143\235\2\203\189\94\139\204\30", "\48\236\184\118\185\216")]:CooldownDown() or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\193\184\90\63\193\61\230\142\67\34\202\58\226\169\95", "\84\133\221\55\80\175")]:IsAvailable())) then
								if (v23(v55.Guillotine, nil, nil, not v14:IsInRange(40)) or (2946 <= 1596)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\186\242\45\170\203\83\169\238\42\163\135\81\188\238\42\230\150\10", "\60\221\135\68\198\167");
								end
							end
							if ((4433 > 3127) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\205\188\244\143\102\203\235\188\252\144\86\216\226\182\253\145\81", "\185\142\221\152\227\34")]:IsReady() and ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\107\208\90\247\76\61\211\93\200\88\244\74\48\195\65\215\86\244\87", "\151\56\165\55\154\35\83")]:CooldownRemains() > 25) or (v70 > 25) or v13:BuffUp(v55.NetherPortalBuff))) then
								if ((4300 >= 2733) and v23(v55.CallDreadstalkers, nil, nil, not v14:IsSpellInRange(v55.CallDreadstalkers))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\163\66\9\226\159\71\23\235\161\71\22\250\161\79\14\235\178\80\69\227\161\74\11\174\241\27", "\142\192\35\101");
								end
							end
							if ((4829 == 4829) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\255\120\57\175\232\159\165\25\216", "\118\182\21\73\195\135\236\204")]:IsReady() and (v80(2) > 0) and v67 and not v13:PrevGCDP(1, v55.Implosion)) then
								if ((1683 <= 4726) and v23(v55.Implosion, v50, nil, not v14:IsInRange(40))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\1\49\10\76\11\30\244\7\50\90\77\5\4\243\72\110\74", "\157\104\92\122\32\100\109");
								end
							end
							if ((4835 >= 3669) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\144\179\194\199\50\41\190\164\182\170\196\207\56\55\136\185", "\203\195\198\175\170\93\71\237")]:IsReady() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\29\94\51\216\94\31\207\33\94\50\222\84\20\236\43\89", "\156\78\43\94\181\49\113")]:Count() == 10) and (v77 > 1)) then
								if ((2851 > 1859) and v23(v55.SummonSoulkeeper)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\97\231\209\175\52\80\109\96\225\207\166\75\78\120\123\230\132\241\89", "\25\18\136\164\195\107\35");
								end
							end
							if ((3848 > 2323) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\204\40\164\64\124\181\194\139\252\63\172\65\117\168\201", "\216\136\77\201\47\18\220\161")]:IsCastable() and (((v63 > 63) and not (v63 > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\30\249\38\215\7\210\166\40\225\36\212\1\223\182\52\254\42\212\28", "\226\77\140\75\186\104\188")]:CooldownRemains() + 69))) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\138\219\221\50\64\183\234\213\50\64\183\199\211\11\86\171\207\222\43", "\47\217\174\176\95")]:CooldownRemains() > 30) or v13:BuffUp(v55.RiteofRuvaraadBuff) or v69 or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\139\200\123\15\189\90\92\35\181\210\120\11\177\96\97\52\185\211\98", "\70\216\189\22\98\210\52\24")]:IsAvailable() or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\253\205\170\138\220\211\205\166\161\214\214\216\182\134\193\222", "\179\186\191\195\231")]:IsAvailable() or not v13:HasTier(30, 2))) then
								if ((2836 > 469) and v23(v55.DemonicStrength, v48)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\253\58\21\235\247\54\27\219\234\43\10\225\247\56\12\236\185\50\25\237\247\127\74\176", "\132\153\95\120");
								end
							end
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\153\179\0\41\248\220\135\164\190\10\44\249", "\192\209\210\110\77\151\186")]:IsReady() and (((v72 > 2) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\195\2\46\229\219\214\229\2\38\250\235\197\236\8\39\251\236", "\164\128\99\66\137\159")]:CooldownRemains() > (v74 * 4)) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\51\156\228\179\15\135\205\187\13\134\231\183\3\189\240\172\1\135\253", "\222\96\233\137")]:CooldownRemains() > 17)) or (v72 == 5) or ((v72 == 4) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\138\188\178\19\187\231\226\176\184\162", "\144\217\211\199\127\232\147")]:IsAvailable() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\203\32\43\36\230\81\16\77\243\42", "\36\152\79\94\72\181\37\98")]:CooldownRemains() < (v74 * 2)))) and (v77 == 1) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\240\202\70\49\211\239\70\45\219\215\68\52\196\252\66\44\222\223\73", "\95\183\184\39")]:IsAvailable()) or (2096 <= 540)) then
								if (v23(v55.HandofGuldan, nil, nil, not v14:IsSpellInRange(v55.HandofGuldan)) or (3183 < 2645)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\189\62\233\34\107\143\4\138\56\242\42\80\129\12\245\50\230\47\90\192\80\227", "\98\213\95\135\70\52\224");
								end
							end
							v152 = 4;
						end
						if ((3230 <= 3760) and (v152 == 0)) then
							ImmovableCallDreadstalkers = v13:BuffDown(v55.DemonicCallingBuff);
							if ((3828 == 3828) and not v13:AffectingCombat() and v29 and not v13:IsCasting(v55.Demonbolt)) then
								local v161 = 0;
								local v162;
								while true do
									if ((554 == 554) and (v161 == 0)) then
										v162 = v95();
										if (v162 or (2563 == 172)) then
											return v162;
										end
										break;
									end
								end
							end
							if ((3889 >= 131) and not v13:IsCasting() and not v13:IsChanneling()) then
								local v163 = 0;
								local v164;
								while true do
									if ((1 == v163) or (492 == 4578)) then
										if (v164 or (4112 < 1816)) then
											return v164;
										end
										v164 = v78.Interrupt(v55.AxeToss, 40, true);
										if ((4525 >= 1223) and v164) then
											return v164;
										end
										v163 = 2;
									end
									if ((1090 <= 4827) and (v163 == 0)) then
										v164 = v78.Interrupt(v55.SpellLock, 40, true);
										if (v164 or (239 > 1345)) then
											return v164;
										end
										v164 = v78.Interrupt(v55.SpellLock, 40, true, v16, v57.SpellLockMouseover);
										v163 = 1;
									end
									if ((v163 == 2) or (3710 >= 3738)) then
										v164 = v78.Interrupt(v55.AxeToss, 40, true, v16, v57.AxeTossMouseover);
										if (v164 or (3838 < 2061)) then
											return v164;
										end
										v164 = v78.InterruptWithStun(v55.AxeToss, 40, true);
										v163 = 3;
									end
									if ((3 == v163) or (690 > 1172)) then
										if (v164 or (1592 > 2599)) then
											return v164;
										end
										v164 = v78.InterruptWithStun(v55.AxeToss, 40, true, v16, v57.AxeTossMouseover);
										if ((3574 <= 4397) and v164) then
											return v164;
										end
										break;
									end
								end
							end
							if ((3135 > 1330) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\8\218\191\211\115\71\41\85\15\209\169\210\123\88\34", "\50\93\180\218\189\23\46\71")]:IsReady() and (v13:HealthPercentage() < v47)) then
								if (v24(v55.UnendingResolve, nil, nil, true) or (3900 <= 3641)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\203\170\94\66\64\213\70\217\155\73\73\87\211\68\200\161\27\72\65\218\77\208\183\82\90\65", "\40\190\196\59\44\36\188");
								end
							end
							v96();
							if ((1724 == 1724) and (v84() or (v63 < 22))) then
								local v165 = 0;
								local v166;
								while true do
									if ((455 <= 1282) and (v165 == 0)) then
										v166 = v99();
										if ((4606 < 4876) and v166 and v32 and v31) then
											return v166;
										end
										break;
									end
								end
							end
							v152 = 1;
						end
						if ((v152 == 5) or (1442 > 2640)) then
							if ((136 < 3668) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\140\35\48\142\191\250\213\182\58\56\133\185\241\237\187", "\131\223\86\93\227\208\148")]:IsReady() and (v63 < (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\208\80\187\187\18\187\199\64\187\185\19\188\224\113\175\164\28\187\247", "\213\131\37\214\214\125")]:CooldownRemains() + 5))) then
								if (v23(v55.SummonVilefiend) or (1784 > 4781)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\53\62\40\178\238\40\20\51\182\237\35\45\44\186\239\34\107\40\190\232\40\107\113\239", "\129\70\75\69\223");
								end
							end
							if ((4585 > 3298) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\98\196\252\228", "\143\38\171\147\137\28")]:IsReady()) then
								if (v78.CastCycle(v55.Doom, v75, v93, not v14:IsSpellInRange(v55.Doom)) or (1664 > 1698)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\212\141\182\254\67\238\213\217\140\249\167\81", "\180\176\226\217\147\99\131");
								end
							end
							if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\224\177\46\3\220\174\13\8\223\173", "\103\179\217\79")]:IsCastable() or (3427 < 2849)) then
								if ((3616 <= 4429) and v23(v55.ShadowBolt, nil, nil, not v14:IsSpellInRange(v55.ShadowBolt))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\89\191\29\209\78\155\156\72\184\16\193\1\129\162\67\185\92\129\21", "\195\42\215\124\181\33\236");
								end
							end
							break;
						end
						if ((3988 >= 66) and (v152 == 2)) then
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\154\29\211\140\48\167\44\219\140\48\167\1\221\181\38\187\9\208\149", "\95\201\104\190\225")]:IsCastable() and (v88() or v82() or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\136\217\200\195\160\194\211\203\137\206\205\201\186\202\211\202", "\174\207\171\161")]:CooldownRemains() > 90))) or (862 > 4644)) then
								if ((1221 == 1221) and v23(v55.SummonDemonicTyrant, v53)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\254\235\0\254\247\217\210\250\8\254\247\217\228\253\50\231\225\197\236\240\25\179\245\214\228\240\77\167", "\183\141\158\109\147\152");
								end
							end
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\31\28\235\1\35\7\208\5\32\12\224\5\41\7\226", "\108\76\105\134")]:IsReady() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\216\208\188\236\193\229\225\180\236\193\229\204\178\213\215\249\196\191\245", "\174\139\165\209\129")]:CooldownRemains() > 45)) or (45 > 1271)) then
								if ((3877 > 1530) and v23(v55.SummonVilefiend)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\176\166\239\204\201\13\79\110\170\191\231\199\207\6\126\124\227\190\227\200\200\67\38", "\24\195\211\130\161\166\99\16");
								end
							end
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\98\6\228\35\93\20\73\15\253", "\118\38\99\137\76\51")]:IsReady() and v13:BuffUp(v55.DemonicCoreBuff) and (((not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\206\41\16\30\58\52\239\47\14\23", "\64\157\70\101\114\105")]:IsAvailable() or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\115\167\178\239\35\84\186\174\232\21", "\112\32\200\199\131")]:CooldownRemains() > (v74 * 2))) and (v72 < 4)) or (v72 < (4 - (v26(v77 > 2))))) and not v13:PrevGCDP(1, v55.Demonbolt) and v13:HasTier(31, 2)) or (4798 == 1255)) then
								if (v78.CastCycle(v55.Demonbolt, v76, v91, not v14:IsSpellInRange(v55.Demonbolt)) or (2541 > 2860)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\40\85\81\183\205\169\45\32\68\28\181\194\162\44\108\8", "\66\76\48\60\216\163\203");
								end
							end
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\138\137\110\246\77\253\45\170\142\118\253", "\68\218\230\25\147\63\174")]:IsReady() and v13:BuffDown(v55.DemonicCoreBuff) and (v14:DebuffDown(v55.DoomBrandDebuff) or (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\133\43\93\72\185\171\13\70\64\178\172\36", "\214\205\74\51\44")]:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) < (v74 + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\222\73\239\243\121\248\67\238\232", "\23\154\44\130\156")]:TravelTime()))) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\57\167\163\170\57\21\54\179\161\170\55\29", "\115\113\198\205\206\86")]:InFlight() and (v14:DebuffRemains(v55.DoomBrandDebuff) < (v74 + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\160\82\243\85\138\85\241\86\144", "\58\228\55\158")]:TravelTime() + 3)))) and v13:HasTier(31, 2)) or (2902 > 3629)) then
								if ((427 < 3468) and v23(v55.PowerSiphon, v52)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\164\134\199\43\46\146\38\189\153\216\33\50\237\56\181\128\222\110\109\253", "\85\212\233\176\78\92\205");
								end
							end
							if ((4190 >= 2804) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\110\93\133\237\68\81\139\209\94\74\141\236\77\76\128", "\130\42\56\232")]:IsCastable() and (v13:BuffRemains(v55.NetherPortalBuff) < v74) and (((v63 > 63) and not (v63 > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\217\160\41\238\79\49\206\176\41\236\78\54\233\129\61\241\65\49\254", "\95\138\213\68\131\32")]:CooldownRemains() + 69))) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\25\61\172\78\121\36\12\164\78\121\36\33\162\119\111\56\41\175\87", "\22\74\72\193\35")]:CooldownRemains() > 30) or v69 or v13:BuffUp(v55.RiteofRuvaraadBuff) or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\31\108\233\85\35\119\192\93\33\118\234\81\47\77\253\74\45\119\240", "\56\76\25\132")]:IsAvailable() or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\121\211\162\43\192\87\211\174\0\202\82\198\190\39\221\90", "\175\62\161\203\70")]:IsAvailable() or not v13:HasTier(30, 2))) then
								if ((2086 == 2086) and v23(v55.DemonicStrength, v48)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\56\216\206\28\59\53\222\252\0\33\46\216\205\20\33\52\157\206\18\60\50\157\146\65", "\85\92\189\163\115");
								end
							end
							if ((4148 > 2733) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\11\165\60\61\58\175\63\45\59\171\53\26\38\161\50\61\59\191", "\88\73\204\80")]:IsReady()) then
								if ((3054 >= 1605) and v23(v55.BilescourgeBombers, nil, nil, not v14:IsInRange(40))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\44\138\28\67\58\217\33\150\2\65\44\229\44\140\29\68\44\200\61\195\29\71\32\212\110\210\68", "\186\78\227\112\38\73");
								end
							end
							v152 = 3;
						end
					end
				end
				break;
			end
			if ((1044 < 1519) and (1 == v121)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\242\214\132\217\34\239\213", "\138\166\185\227\190\78")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\123\192", "\121\171\20\165\87\50\67")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\242\55\190\49\181\7\213", "\98\166\88\217\86\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\242\106", "\188\150\150\25\97\230")];
				v121 = 2;
			end
			if ((1707 <= 4200) and (v121 == 3)) then
				v25.UpdateSoulShards();
				if ((580 == 580) and (v78.TargetIsValid() or v13:AffectingCombat())) then
					local v154 = 0;
					while true do
						if ((601 <= 999) and (v154 == 1)) then
							if ((3970 == 3970) and (v63 == 11111)) then
								v63 = v10.FightRemains(v76, false);
							end
							v73 = v10.CombatTime();
							v154 = 2;
						end
						if ((0 == v154) or (98 == 208)) then
							v62 = v10.BossFightRemains(nil, true);
							v63 = v62;
							v154 = 1;
						end
						if ((2006 <= 3914) and (v154 == 2)) then
							v72 = v13:SoulShardsP();
							v74 = v13:GCD() + 0.25;
							break;
						end
					end
				end
				v121 = 4;
			end
		end
	end
	local function v103()
		v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\41\92\58\49\43\247\1\86\48\39\101\207\12\75\59\49\38\243\77\75\56\42\36\236\4\86\57\126\39\225\77\124\39\55\38\182\77\106\34\46\53\247\31\77\50\58\101\250\20\25\16\49\47\241\31\88", "\152\109\57\87\94\69"));
	end
	v10.SetAPL(266, v102, v103);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\220\199\3\187\129\229\85\186\245\216\9\168\129\246\81\165\246\217\5\175\177\213\77\230\245\194\11", "\200\153\183\106\195\222\178\52")]();

