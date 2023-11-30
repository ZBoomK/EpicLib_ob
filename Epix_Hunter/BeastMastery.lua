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
		if ((v5 == 1) or (2481 == 4682)) then
			return v6(...);
		end
		if ((4727 >= 208) and (v5 == 0)) then
			v6 = v0[v4];
			if ((280 < 3851) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\147\210\16\197\198\201\26\196\190\198\13\197\238\218\54\242\190\213\7\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
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
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\104\65\20\44\70\76", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\158\202\217\14", "\75\220\163\183\106\98")];
	local v22 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local v23 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\234\51\2\201\240", "\202\171\92\71\134\190")];
	local v24 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\10\229\63\167\7", "\232\73\161\76")];
	local v25 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\152\216\81\73", "\126\219\185\34\61")];
	local v26 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\60\220\91\97\109", "\135\108\174\62\18\30\23\147")];
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\187\232\50", "\167\214\137\74\171\120\206\83")];
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
	local function v50()
		local v87 = 0;
		while true do
			if ((v87 == 0) or (3007 > 3194)) then
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\245\38\73\241\169\140\227", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\5\188\25\6\21\176\42\11\5", "\75\103\118\217")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\244\81\100\0\176\16\192\71", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\61\37\168\177\24\240\193\32\39\176\187\13\245\199\32", "\156\168\78\64\224\212\121")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\235\177\218\14\224\162\221", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\45\94\52\44\80\255\102\39\75\49\42\80\214\87\37\90", "\152\54\72\63\88\69\62")] or 0;
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\193\250\72\221\202\233\79", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\112\91\4\37\46\227\21\104\81\17\32\40\227\58\104", "\114\56\62\101\73\71\141")] or 0;
				v87 = 1;
			end
			if ((v87 == 1) or (2136 >= 2946)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\236\207\208\177\231\220\215", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\231\245\52\154\163\255\7\198\238\34\166\169\240\14", "\107\178\134\81\210\198\158")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\10\131\251\222\203\28\150\248\196\198\39\178", "\170\163\111\226\151")] or 0;
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\168\34\217\23\245\147\57\221\6\208\136\56\197\33\243\148\34", "\135\225\76\173\114")] or 0;
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\211\4\245\106\228\184\205\4\223\118\250\180\234\24\249\108\243\161\212\3\228", "\150\205\189\112\144\24")] or 0;
				v87 = 2;
			end
			if ((2165 <= 2521) and (v87 == 4)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\226\92\75\122\15\224\91", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\68\59\50\35\48\188\93\39\50\32\63\134\108", "\81\206\60\83\91\79")] or 0;
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\174\196\102\38\205\74\183", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\49\123\42\54\250\225\169", "\143\216\66\30\126\68\155")];
				break;
			end
			if ((2861 > 661) and (v87 == 2)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\17\19\214\164\110\147\196\11\51\219\164\121\149\220\16\11\215", "\230\180\127\103\179\214\28")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\153\186\20\116\179\255", "\175\204\201\113\36\214\139")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\109\180\141\60\163\72\188\148\0\161\119\173", "\83\205\24\217\224")] or 0;
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\225\196\241\46\203\183\114\138\224\192\210", "\30\222\146\161\162\90\174\210")];
				v87 = 3;
			end
			if ((4525 > 4519) and (3 == v87)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\51\118\206\95\86\81\54\118", "\32\56\64\19\156\58")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\108\69\78\208\112\136\131\59\92\66", "\107\57\54\43\157\21\230\231")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\142\5\225\176\210\200\200", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\170\143\72\211\124\108\20\159", "\24\92\207\225\44\131\25")] or 0;
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\214\172\88\18\115\76\192", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\202\37\105\165\209\41\64\188\203\33\88\180\214\46", "\44\221\185\64")];
				v87 = 4;
			end
		end
	end
	local v51 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\137\199\0\198\202\173\196", "\129\202\168\109\171\165\195\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\78\50\202\199\27\232\39", "\134\66\56\87\184\190\116")];
	local v52 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\31\62\4\182\22\229\50", "\85\92\81\105\219\121\139\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\213\166\94\81\121\205", "\191\157\211\48\37\28")];
	local v53 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\247\10\250\8\63\205", "\90\191\127\148\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\90\130\47\4\108\170\47\4\108\130\60\14", "\119\24\231\78")];
	local v54 = {v53[LUAOBFUSACTOR_DECRYPT_STR_0("\177\56\168\71\211\78\33\135\57", "\113\226\77\197\42\188\32")],v53[LUAOBFUSACTOR_DECRYPT_STR_0("\9\3\249\184\53\24\196\176\46\68", "\213\90\118\148")],v53[LUAOBFUSACTOR_DECRYPT_STR_0("\104\59\185\91\66\85\30\177\66\30", "\45\59\78\212\54")],v53[LUAOBFUSACTOR_DECRYPT_STR_0("\35\67\142\134\137\32\157\245\4\2", "\144\112\54\227\235\230\78\205")],v53[LUAOBFUSACTOR_DECRYPT_STR_0("\128\61\2\241\223\85\131\45\27\169", "\59\211\72\111\156\176")]};
	local v55 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\102\146\237\57\75\149", "\77\46\231\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\81\183\83\174\121\183\83\174\81\164\89", "\32\218\52\214")];
	local v56 = {};
	local v57 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\102\2\63\188\244\162", "\58\46\119\81\200\145\208\37")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\137\49\191\189\144\55\56\152\53\190\176", "\86\75\236\80\204\201\221")];
	local v58 = v13:GetEquipment();
	v10:RegisterForEvent(function()
		v58 = v13:GetEquipment();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\66\109\86\188\219\185\77\100\70\176\215\187\95\100\89\177\193\168\90\96\89\162\219\175", "\235\18\33\23\229\158"));
	local v59;
	local v60 = 11111;
	local v61 = 11111;
	v10:RegisterForEvent(function()
		local v88 = 0;
		while true do
			if ((3178 > 972) and (v88 == 0)) then
				v60 = 11111;
				v61 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\96\150\224\130\117\136\254\137\117\157\228\149\111\159\239\154\114\150\228\159", "\219\48\218\161"));
	local v62, v63, v64;
	local v65, v66;
	local v67;
	local v68 = {{v53[LUAOBFUSACTOR_DECRYPT_STR_0("\205\127\104\64\214\70\228\229\101\117\70\213", "\128\132\17\28\41\187\47")],LUAOBFUSACTOR_DECRYPT_STR_0("\34\51\21\46\29\40\60\18\51\80\8\54\7\46\84\14\60\70\114\116\15\38\3\40\79\20\34\18\115", "\61\97\82\102\90"),function()
		return true;
	end}};
	local function v69(v89)
		return (v89:DebuffRemains(v53.BarbedShotDebuff));
	end
	local function v70(v90)
		return (v90:DebuffStack(v53.LatentPoisonDebuff));
	end
	local function v71(v91)
		return (v91:DebuffRemains(v53.SerpentStingDebuff));
	end
	local function v72(v92)
		return (v92:DebuffStack(v53.LatentPoisonDebuff) > 9) and ((v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25))) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\159\45\174\69\211\88\24\43\160\33\164\79", "\105\204\78\203\43\167\55\126")]:IsAvailable() and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\135\175\48\10\26\5\203\102\183\171\55\22", "\49\197\202\67\126\115\100\167")]:CooldownRemains() < (12 + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < 3) and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\21\94\204\61\137\87\82\0\73\222\61\136", "\62\87\59\191\73\224\54")]:CooldownUp() or v53[LUAOBFUSACTOR_DECRYPT_STR_0("\196\3\246\197\232\4\238\193\226\53\243\197\227", "\169\135\98\154")]:CooldownUp())) or ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\233\118\54\86\248\55\251\195\120\48", "\168\171\23\68\52\157\83")]:FullRechargeTime() < v59) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\214\116\230\185\44\44\139\195\99\244\185\45", "\231\148\17\149\205\69\77")]:CooldownDown()));
	end
	local function v73(v93)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25))) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\179\164\194\245\67\240\134\133\203\244\88\251", "\159\224\199\167\155\55")]:IsAvailable() and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\213\246\47\198\254\242\48\229\229\242\40\218", "\178\151\147\92")]:CooldownRemains() < (12 + v59))) or ((v17:BuffStack(v53.FrenzyPetBuff) < 3) and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\174\248\95\38\27\77\118\187\239\77\38\26", "\26\236\157\44\82\114\44")]:CooldownUp() or v53[LUAOBFUSACTOR_DECRYPT_STR_0("\9\47\217\87\37\40\193\83\47\25\220\87\46", "\59\74\78\181")]:CooldownUp())) or ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\7\208\72\88\182\33\226\82\85\167", "\211\69\177\58\58")]:FullRechargeTime() < v59) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\149\224\106\225\224\202\187\210\107\244\253\195", "\171\215\133\25\149\137")]:CooldownDown());
	end
	local function v74(v94)
		return (v94:DebuffStack(v53.LatentPoisonDebuff) > 9) and (v13:BuffUp(v53.CalloftheWildBuff) or (v61 < 9) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\214\193\62\254\204\49\240\78", "\34\129\168\82\154\143\80\156")]:IsAvailable() and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\167\179\33\9\77\74\186\141\189\39", "\233\229\210\83\107\40\46")]:ChargesFractional() > 1.2)) or v53[LUAOBFUSACTOR_DECRYPT_STR_0("\242\67\36\215\2\196\80\43", "\101\161\34\82\182")]:IsAvailable());
	end
	local function v75(v95)
		return v13:BuffUp(v53.CalloftheWildBuff) or (v61 < 9) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\223\4\85\250\248\227\142\34", "\78\136\109\57\158\187\130\226")]:IsAvailable() and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\28\62\235\243\59\59\202\249\49\43", "\145\94\95\153")]:ChargesFractional() > 1.2)) or v53[LUAOBFUSACTOR_DECRYPT_STR_0("\206\204\2\212\73\178\239\212", "\215\157\173\116\181\46")]:IsAvailable();
	end
	local function v76(v96)
		return v96:DebuffRefreshable(v53.SerpentStingDebuff) and (v96:TimeToDie() > v53[LUAOBFUSACTOR_DECRYPT_STR_0("\6\177\153\226\223\59\160\184\230\211\59\179\175\247\216\32\178\141", "\186\85\212\235\146")]:BaseDuration());
	end
	local function v77(v97)
		return (v17:BuffUp(v53.FrenzyPetBuff) and (v17:BuffRemains(v53.FrenzyPetBuff) <= (v59 + 0.25))) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\241\130\19\240\45\225\94\224\141\25\241\61", "\56\162\225\118\158\89\142")]:IsAvailable() and (v17:BuffStack(v53.FrenzyPetBuff) < 3) and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\126\0\211\187\43\217\80\50\210\174\54\208", "\184\60\101\160\207\66")]:CooldownUp() or v53[LUAOBFUSACTOR_DECRYPT_STR_0("\18\131\112\176\62\132\104\180\52\181\117\176\53", "\220\81\226\28")]:CooldownUp()));
	end
	local function v78(v98)
		return (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\36\220\142\255\201\198\31\217", "\167\115\181\226\155\138")]:IsAvailable() and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\192\35\245\94\126\117\245\234\45\243", "\166\130\66\135\60\27\17")]:ChargesFractional() > 1.4)) or v13:BuffUp(v53.CalloftheWildBuff) or ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\102\75\220\119\53\64\121\198\122\36", "\80\36\42\174\21")]:FullRechargeTime() < v59) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\108\21\36\110\71\17\59\77\92\17\35\114", "\26\46\112\87")]:CooldownDown()) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\138\32\174\122\171\176\67\150\181\44\164\112", "\212\217\67\203\20\223\223\37")]:IsAvailable() and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\152\136\187\198\179\140\164\229\168\140\188\218", "\178\218\237\200")]:CooldownRemains() < (12 + v59))) or v53[LUAOBFUSACTOR_DECRYPT_STR_0("\133\180\240\209\177\176\244\201", "\176\214\213\134")]:IsAvailable() or (v61 < 9);
	end
	local function v79(v99)
		return v99:DebuffRefreshable(v53.SerpentStingDebuff) and (v14:TimeToDie() > v53[LUAOBFUSACTOR_DECRYPT_STR_0("\199\168\164\196\173\88\77\199\185\191\218\175\114\92\246\184\176\210", "\57\148\205\214\180\200\54")]:BaseDuration());
	end
	local function v80()
		local v100 = 0;
		while true do
			if ((4766 == 4766) and (3 == v100)) then
				if ((v64 > 1) or (2745 > 3128)) then
					if (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\222\100\250\24\25\121\251\126\226", "\42\147\17\150\108\112")]:IsReady() or (1144 >= 4606)) then
						if ((3338 >= 277) and v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\2\179\33\107\238\251\7\169\57\63\247\250\10\165\34\114\229\233\27\230\124\43", "\136\111\198\77\31\135");
						end
					end
				elseif ((2610 > 2560) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\33\6\165\68\188\215\31\166\22", "\201\98\105\199\54\221\132\119")]:IsReady()) then
					if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or (1194 > 3083)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\3\129\51\3\10\191\177\3\151\97\18\39\169\186\3\142\35\3\33\236\232\90", "\204\217\108\227\65\98\85");
					end
				end
				break;
			end
			if ((916 >= 747) and (0 == v100)) then
				if ((v15:Exists() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\63\244\38\48\127\0\248\54\32\127\29\243", "\22\114\157\85\84")]:IsReady()) or (2444 > 2954)) then
					if ((2892 < 3514) and v26(v57.MisdirectionFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\194\0\192\84\228\173\199\223\26\203\83\182\184\214\206\16\203\80\244\169\208\139\67", "\200\164\171\115\164\61\150");
					end
				end
				if ((533 == 533) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\141\224\6\64\143\138\230\2\85", "\227\222\148\99\37")]:IsCastable() and not v53[LUAOBFUSACTOR_DECRYPT_STR_0("\4\83\91\250\240\61\85\115\228\235\60\69", "\153\83\50\50\150")]:IsAvailable() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\110\98\118\25\127\159\95\92\102", "\45\61\22\19\124\19\203")]:IsAvailable()) then
					if ((595 <= 3413) and v26(v53.SteelTrap)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\210\6\8\240\14\79\173\211\19\29\181\18\98\188\194\29\0\247\3\100\249\147", "\217\161\114\109\149\98\16");
					end
				end
				v100 = 1;
			end
			if ((3078 >= 2591) and (v100 == 2)) then
				if ((3199 < 4030) and v16:Exists() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\6\199\83\231\117\199\143\57", "\224\77\174\63\139\38\175")]:IsCastable() and (v16:HealthPercentage() <= 20)) then
					if ((777 < 2078) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\143\72\84\34\187\82\80\33\144\126\85\33\145\82\93\33\146\68\74\110\148\83\93\45\139\76\90\47\144\1\9\127", "\78\228\33\56");
					end
				end
				if ((1696 <= 2282) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\229\119\190\15\166\193\115\191\2\139\202", "\229\174\30\210\99")]:IsReady()) then
					if (v26(v57.KillCommandPetAttack) or (1761 >= 2462)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\228\138\93\210\62\54\22\224\135\95\233\125\41\9\232\133\94\224\63\56\15\173\215\3", "\89\123\141\230\49\141\93");
					end
				end
				v100 = 3;
			end
			if ((4551 > 2328) and (v100 == 1)) then
				if ((3825 >= 467) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\48\33\42\126\185\112\33\40\55\104", "\20\114\64\88\28\220")]:IsCastable() and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\19\0\192\182\253\212\142\57\14\198", "\221\81\97\178\212\152\176")]:Charges() >= 2)) then
					if (v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or (2890 == 557)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\207\230\15\249\31\201\216\14\243\21\217\167\13\233\31\206\232\16\249\27\217\167\69", "\122\173\135\125\155");
					end
				end
				if (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\175\200\12\181\12\57\199\144", "\168\228\161\96\217\95\81")]:IsReady() or (4770 == 2904)) then
					if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or (3903 == 4536)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\216\34\80\16\68\211\222\58\28\63\69\222\210\33\81\45\86\207\145\127\12", "\55\187\177\78\60\79");
					end
				end
				v100 = 2;
			end
		end
	end
	local function v81()
		local v101 = 0;
		while true do
			if ((4093 <= 4845) and (v101 == 0)) then
				if ((1569 <= 3647) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\124\198\231\246\41\210\85\202\251\226", "\160\62\163\149\133\76")]:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53[LUAOBFUSACTOR_DECRYPT_STR_0("\245\161\1\35\204\208\180\5\42\244\223\172\9", "\163\182\192\109\79")]:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < 13))) then
					if (v26(v53.Berserking, nil, nil, true) or (4046 >= 4927)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\54\35\18\211\240\38\45\9\206\242\116\37\4\211\181\102", "\149\84\70\96\160");
					end
				end
				if ((4623 >= 2787) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\26\10\2\226\60\32\24\255\33", "\141\88\102\109")]:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53[LUAOBFUSACTOR_DECRYPT_STR_0("\144\82\198\124\21\59\65\201\182\100\195\124\30", "\161\211\51\170\16\122\93\53")]:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < 16))) then
					if ((2234 >= 1230) and v26(v53.BloodFury, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\162\189\39\255\145\180\61\233\183\242\43\255\189\242\112", "\72\155\206\210");
					end
				end
				v101 = 1;
			end
			if ((1 == v101) or (343 == 1786)) then
				if ((2570 > 2409) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\103\116\87\11\32\82\104\85\2\16\71\118\88", "\83\38\26\52\110")]:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53[LUAOBFUSACTOR_DECRYPT_STR_0("\123\22\43\74\87\17\51\78\93\32\46\74\92", "\38\56\119\71")]:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < 16))) then
					if (v26(v53.AncestralCall) or (2609 >= 3234)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\242\225\91\211\54\66\225\238\84\233\38\87\255\227\24\213\33\69\179\190\8", "\54\147\143\56\182\69");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\240\136\237\76\221\218\142\240\77", "\191\182\225\159\41")]:IsCastable() and (v13:BuffUp(v53.CalloftheWildBuff) or (not v53[LUAOBFUSACTOR_DECRYPT_STR_0("\8\19\36\89\132\129\214\35\23\31\92\135\131", "\162\75\114\72\53\235\231")]:IsAvailable() and v13:BuffUp(v53.BestialWrathBuff)) or (v61 < 9))) or (3033 >= 4031)) then
					if (v26(v53.Fireblood) or (1401 == 4668)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\138\53\86\231\81\14\131\51\64\162\80\6\159\124\21\176", "\98\236\92\36\130\51");
					end
				end
				break;
			end
		end
	end
	local function v82()
		local v102 = 0;
		local v103;
		while true do
			if ((2776 >= 1321) and (v102 == 1)) then
				v103 = v51.HandleBottomTrinket(v56, v29, 40, nil);
				if (v103 or (487 > 2303)) then
					return v103;
				end
				break;
			end
			if ((0 == v102) or (4503 == 3462)) then
				v103 = v51.HandleTopTrinket(v56, v29, 40, nil);
				if ((553 <= 1543) and v103) then
					return v103;
				end
				v102 = 1;
			end
		end
	end
	local function v83()
		local v104 = 0;
		while true do
			if ((2015 == 2015) and (v104 == 1)) then
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\57\180\132\1\21\179\156\5\31\130\129\1\30", "\109\122\213\232")]:IsCastable() and v29) or (4241 <= 2332)) then
					if (v25(v53.CalloftheWild) or (2364 < 1157)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\246\174\60\209\248\164\15\250\255\167\15\249\254\174\52\174\244\174\53\239\225\167\112\191\167", "\80\142\151\194");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\40\207\123\64\32\201\122\65\2\200\115", "\44\99\166\23")]:IsReady() and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\87\254\37\58\16\168\121\246\63\51", "\196\28\151\73\86\83")]:IsAvailable())) or (1167 > 1278)) then
					if (v25(v53.KillCommand, nil, nil, not v14:IsInRange(50)) or (1145 <= 1082)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\10\37\28\189\91\23\123\254\2\39\20\194\91\20\115\242\21\44\80\211\10", "\22\147\99\73\112\226\56\120");
					end
				end
				if (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\157\109\242\249\130\171\124\244\240\190\176\122\246", "\237\216\21\130\149")]:IsReady() or (3105 == 4881)) then
					if (v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot)) or (1887 > 4878)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\86\79\83\191\218\87\148\75\96\76\184\198\74\194\77\83\90\177\223\91\194\31\13", "\62\226\46\63\63\208\169");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\214\13\84\142\15\8\43\91", "\62\133\121\53\227\127\109\79")]:IsCastable() and v29) or (4087 > 4116)) then
					if ((1106 <= 1266) and v26(v53.Stampede, not v14:IsSpellInRange(v53.Stampede))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\0\51\248\198\171\166\21\84\49\249\211\175\180\21\84\99\161", "\194\112\116\82\149\182\206");
					end
				end
				v104 = 2;
			end
			if ((3155 < 4650) and (v104 == 5)) then
				if ((3774 >= 1839) and v29 and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\44\142\165\88\20\148\136\69\4\128\175\85\14\147", "\48\96\231\194")]:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v14:TimeToDie() < 5))) then
					if ((2811 == 2811) and v25(v53.LightsJudgment, nil, not v14:IsInRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\83\9\37\13\203\144\137\221\94\9\32\28\214\187\195\203\86\11\44\15\221\239\215\152", "\227\168\58\110\77\121\184\207");
					end
				end
				if ((2146 > 1122) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\80\53\179\76\130\211\126\177", "\197\27\92\223\32\209\187\17")]:IsReady()) then
					if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or (56 == 3616)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\86\207\247\60\76\203\244\23\31\192\247\6\94\213\254\67\12\155", "\155\99\63\163");
					end
				end
				if ((v16:Exists() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\169\216\173\129\138\140\141\197", "\228\226\177\193\237\217")]:IsCastable() and (v16:HealthPercentage() <= 20)) or (2421 < 622)) then
					if ((1009 <= 1130) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\185\47\234\11\163\43\233\32\143\46\233\33\163\38\233\34\181\49\166\55\188\38\231\34\181\99\181\109", "\134\84\208\67");
					end
				end
				if ((2758 < 2980) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\48\163\132\78\18\159\142\83\7", "\60\115\204\230")]:IsReady() and (v13:FocusTimeToMax() < (v59 * 2))) then
					if (v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot)) or (86 >= 3626)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\53\233\98\230\5\248\120\232\46\171\115\235\63\234\102\226\122\191\34", "\16\135\90\139");
					end
				end
				v104 = 6;
			end
			if ((2395 == 2395) and (v104 == 4)) then
				if ((3780 > 2709) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\238\35\228\83\176\211\50\197\87\188\211\33", "\213\189\70\150\35")]:IsReady()) then
					if (v51.CastTargetIf(v53.SerpentSting, v62, LUAOBFUSACTOR_DECRYPT_STR_0("\66\92\122", "\104\47\53\20"), v71, v76, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover) or (237 >= 2273)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\176\73\147\12\185\1\183\115\146\8\181\1\164\12\130\16\185\14\181\73\193\79\232", "\111\195\44\225\124\220");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\250\71\18\97\170\172\221", "\203\184\38\96\19\203")]:IsReady() and (v17:BuffRemains(v53.FrenzyPetBuff) > v53[LUAOBFUSACTOR_DECRYPT_STR_0("\27\114\107\83\207\62\118", "\174\89\19\25\33")]:ExecuteTime())) or (2040 <= 703)) then
					if ((3279 <= 3967) and v26(v53.Barrage, not v14:IsSpellInRange(v53.Barrage))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\19\64\92\246\128\14\111\17\94\75\246\145\14\111\65\4", "\107\79\114\50\46\151\231");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\20\179\185\61\131\10\191\207\45", "\160\89\198\213\73\234\89\215")]:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (v13:GCD() * 2))) or (1988 == 877)) then
					if ((4291 > 1912) and v26(v53.MultiShot, not v14:IsSpellInRange(v53.MultiShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\69\100\184\234\204\91\121\187\234\133\75\125\177\255\211\77\49\231\166", "\165\40\17\212\158");
					end
				end
				if ((2003 < 2339) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\196\202\24\54\37\241\214\14\39\46\224\238\1\63\34", "\70\133\185\104\83")]:IsCastable() and v29) then
					if ((432 == 432) and v26(v53.AspectoftheWild)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\5\86\84\47\202\16\122\75\44\246\16\77\65\21\222\13\73\64\106\202\8\64\69\60\204\68\17\20", "\169\100\37\36\74");
					end
				end
				v104 = 5;
			end
			if ((v104 == 2) or (1145 >= 1253)) then
				if ((3418 > 2118) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\27\164\67\23\196\241\6\60\172", "\110\89\200\44\120\160\130")]:IsCastable()) then
					if ((3066 <= 3890) and v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\207\68\73\71\89\51\72\175\131\72\74\70\75\45\72\235\146\29", "\45\203\163\43\38\35\42\91");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\246\128\221\55\143\138\92\211\142\206\34\138", "\52\178\229\188\67\231\201")]:IsCastable() and v29) or (2998 >= 3281)) then
					if (v26(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram)) or (4649 <= 2632)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\68\81\16\255\99\32\41\64\91\22\246\81\99\34\77\85\5\225\89\99\112\25", "\67\65\33\48\100\151\60");
					end
				end
				if (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\236\243\171\221\255\235\245\175\200", "\147\191\135\206\184")]:IsCastable() or (3860 > 4872)) then
					if (v26(v57.SteelTrap) or (3998 == 2298)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\60\163\196\212\108\166\150\41\182\129\219\95\183\133\62\163\129\138\1", "\210\228\72\198\161\184\51");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\23\100\230\2\119\203\36\70\245\51\97\193\33\90", "\174\86\41\147\112\19")]:IsReady() and v29) or (8 >= 2739)) then
					if ((2590 == 2590) and v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\63\128\30\55\11\20\185\100\15\139\52\38\29\30\188\72\64\142\7\32\14\7\174\27\82\217", "\203\59\96\237\107\69\111\113");
					end
				end
				v104 = 3;
			end
			if ((v104 == 6) or (82 >= 1870)) then
				if ((2624 < 4557) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\99\117\15\63\71\90\127\117\102\20\60\89", "\24\52\20\102\83\46\52")]:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53[LUAOBFUSACTOR_DECRYPT_STR_0("\243\46\40\40\6\202\40\0\54\29\203\56", "\111\164\79\65\68")]:ExecuteTime()) or (v61 < 5))) then
					if (v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true) or (3131 > 3542)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\216\138\210\39\228\193\230\130\204\60\229\209\153\128\210\43\235\208\220\195\138\122", "\138\166\185\227\190\78");
					end
				end
				if ((2577 >= 1578) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\233\117\194\56\84\23\11\194\119\206\36", "\121\171\20\165\87\50\67")]:IsCastable() and v29 and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < 5))) then
					if ((4103 <= 4571) and v26(v53.BagofTricks)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\57\190\9\182\4\249\44\171\63\186\9\213\120\186\58\188\3\208\61\249\98\239", "\98\166\88\217\86\217");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\215\228\122\0\136\217\194\249\107\19\131\210\226", "\188\150\150\25\97\230")]:IsCastable() and v29 and ((v13:Focus() + v13:FocusRegen() + 30) < v13:FocusMax())) or (1495 == 4787)) then
					if (v26(v53.ArcaneTorrent) or (310 > 4434)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\155\92\3\2\232\229\157\80\16\30\232\212\157\31\1\0\232\219\159\90\66\88\181", "\141\186\233\63\98\108");
					end
				end
				break;
			end
			if ((2168 <= 4360) and (v104 == 0)) then
				if ((994 == 994) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\134\24\30\184\64\172\134\56\171\13", "\80\196\121\108\218\37\200\213")]:IsCastable()) then
					if ((1655 > 401) and v51.CastTargetIf(v53.BarbedShot, v62, LUAOBFUSACTOR_DECRYPT_STR_0("\13\114\26", "\234\96\19\98\31\43\110"), v70, v72, not v14:IsSpellInRange(v53.BarbedShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\4\30\64\197\169\118\180\21\23\93\211\236\113\135\3\30\68\194\236\32", "\235\102\127\50\167\204\18");
					end
				end
				if ((3063 <= 3426) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\114\160\231\33\65\42\99\169\250\55", "\78\48\193\149\67\36")]:IsCastable()) then
					if ((1459 > 764) and v51.CastTargetIf(v53.BarbedShot, v62, LUAOBFUSACTOR_DECRYPT_STR_0("\61\23\142", "\33\80\126\224\120"), v69, v73, not v14:IsSpellInRange(v53.BarbedShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\238\169\17\198\89\232\151\16\204\83\248\232\0\200\89\237\190\6\132\8", "\60\140\200\99\164");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\170\225\8\50\171\180\252\11\50", "\194\231\148\100\70")]:IsReady() and (v17:BuffRemains(v53.BeastCleavePetBuff) < (0.25 + v59)) and (not v53[LUAOBFUSACTOR_DECRYPT_STR_0("\100\64\206\172\242\209\96\94\196\173\236\209", "\168\38\44\161\195\150")]:IsAvailable() or v53[LUAOBFUSACTOR_DECRYPT_STR_0("\163\253\142\122\63\238\162\30\133\203\139\122\52", "\118\224\156\226\22\80\136\214")]:CooldownDown())) or (641 > 4334)) then
					if ((3399 >= 2260) and v26(v53.MultiShot, nil, nil, not v14:IsSpellInRange(v53.MultiShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\251\85\148\75\253\81\143\86\174\90\140\71\239\79\133\2\184", "\224\34\142\57");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\252\162\214\201\122\240\81\57\204\166\209\213", "\110\190\199\165\189\19\145\61")]:IsCastable() and v29) or (393 >= 4242)) then
					if ((989 < 4859) and v26(v53.BestialWrath)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\238\100\252\130\198\214\212\96\250\138\211\210\171\116\228\142\198\204\238\55\176", "\167\186\139\23\136\235");
					end
				end
				v104 = 1;
			end
			if ((v104 == 3) or (4795 < 949)) then
				if ((3842 == 3842) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\6\23\190\227\52\244\228\44\25\184", "\183\68\118\204\129\81\144")]:IsCastable()) then
					if ((1747 <= 3601) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, LUAOBFUSACTOR_DECRYPT_STR_0("\3\172\104", "\226\110\205\16\132\107"), v70, v74, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\194\242\219\68\239\252\243\209\78\255\131\227\213\68\234\213\229\153\19\189", "\33\139\163\128\185");
					end
				end
				if (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\117\89\22\220\82\92\55\214\88\76", "\190\55\56\100")]:IsCastable() or (804 > 4359)) then
					if ((4670 >= 3623) and v51.CastTargetIf(v57.BarbedShotPetAttack, v62, LUAOBFUSACTOR_DECRYPT_STR_0("\91\166\50", "\147\54\207\92\126\115\131"), v69, v75, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\15\48\39\127\8\122\50\34\61\114\25\62\14\61\48\124\27\123\77\99\109", "\30\109\81\85\29\109");
					end
				end
				if ((2065 < 2544) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\212\120\88\186\21\209\241\242\112\90\178", "\156\159\17\52\214\86\190")]:IsReady()) then
					if ((1311 <= 3359) and v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\230\177\176\145\236\178\177\163\238\179\184\238\236\177\185\175\249\184\252\253\191", "\220\206\143\221");
					end
				end
				if ((2717 <= 3156) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\162\116\63\18\250\201\211\149\105", "\178\230\29\77\119\184\172")]:IsCastable()) then
					if ((1081 < 4524) and v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\241\183\24\30\72\250\240\191\25\15\55\251\249\187\11\13\114\184\166\236", "\152\149\222\106\123\23");
					end
				end
				v104 = 4;
			end
		end
	end
	local function v84()
		local v105 = 0;
		while true do
			if ((440 >= 71) and (v105 == 4)) then
				if ((4934 > 2607) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\193\188\40\239\115\55\229\161", "\95\138\213\68\131\32")]:IsReady()) then
					if (v26(v53.KillShot, not v14:IsSpellInRange(v53.KillShot)) or (1400 > 3116)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\33\173\79\73\57\32\174\87\54\57\60\225\16\38", "\22\74\72\193\35");
					end
				end
				if ((525 < 1662) and v16:Exists() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\7\112\232\84\31\113\235\76", "\56\76\25\132")]:IsCastable() and (v16:HealthPercentage() <= 20)) then
					if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v53.KillShot)) or (876 > 2550)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\200\167\42\240\77\201\164\50\240\83\206\190\53\202\81\215\174\52\143\77\213\235\117\158", "\175\62\161\203\70");
					end
				end
				if ((219 <= 2456) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\29\206\211\22\54\40\210\197\7\61\57\234\202\31\49", "\85\92\189\163\115")]:IsCastable() and v29) then
					if (v26(v53.AspectoftheWild) or (4219 == 1150)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\40\191\32\61\42\184\15\55\47\147\36\48\44\147\39\49\37\168\112\43\61\236\99\106", "\88\73\204\80");
					end
				end
				if (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\13\140\18\84\40\233\38\140\4", "\186\78\227\112\38\73")]:IsReady() or (2989 <= 222)) then
					if ((2258 > 1241) and v26(v57.CobraShotPetAttack, not v14:IsSpellInRange(v53.CobraShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\88\255\71\82\69\239\95\242\65\19\105\232\23\174\1", "\26\156\55\157\53\51");
					end
				end
				v105 = 5;
			end
			if ((41 < 4259) and (v105 == 2)) then
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\40\128\40\97\13\168\47\124\15\142\47\124\30\190", "\19\105\205\93")]:IsCastable() and v29) or (1930 < 56)) then
					if ((3333 == 3333) and v26(v53.AMurderofCrows, not v14:IsSpellInRange(v53.AMurderofCrows))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\55\211\148\45\173\13\204\190\48\175\55\221\147\48\190\27\158\146\43\233\89\138", "\95\201\104\190\225");
					end
				end
				if (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\156\223\196\203\163\255\211\207\191", "\174\207\171\161")]:IsCastable() or (2225 == 20)) then
					if (v26(v53.SteelTrap) or (872 >= 3092)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\254\234\8\246\244\232\249\236\12\227\184\196\249\190\92\165", "\183\141\158\109\147\152");
					end
				end
				if ((4404 >= 3252) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\9\17\246\0\35\26\239\26\41\58\238\3\56", "\108\76\105\134")]:IsReady()) then
					if ((1107 > 796) and v26(v53.ExplosiveShot, not v14:IsSpellInRange(v53.ExplosiveShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\238\221\161\237\193\248\204\167\228\241\248\205\190\245\142\248\209\241\176\150", "\174\139\165\209\129");
					end
				end
				if ((959 == 959) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\129\178\240\195\195\7\67\112\172\167", "\24\195\211\130\161\166\99\16")]:IsCastable()) then
					if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, LUAOBFUSACTOR_DECRYPT_STR_0("\75\10\231", "\118\38\99\137\76\51"), v69, v78, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or (245 >= 2204)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\39\23\16\12\36\194\53\13\29\29\96\238\50\69\64\93", "\64\157\70\101\114\105");
					end
				end
				v105 = 3;
			end
			if ((3162 >= 2069) and (v105 == 5)) then
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\187\217\31\213\177\94\139\249\4\203\183\71", "\48\236\184\118\185\216")]:IsReady() and ((v17:BuffRemains(v53.FrenzyPetBuff) > v53[LUAOBFUSACTOR_DECRYPT_STR_0("\210\188\94\60\198\58\226\156\69\34\192\35", "\84\133\221\55\80\175")]:ExecuteTime()) or (v61 < 5))) or (306 > 3081)) then
					if (v26(v53.WailingArrow, not v14:IsSpellInRange(v53.WailingArrow), true) or (3513 < 2706)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\230\45\170\206\82\186\216\37\180\213\83\170\167\55\178\135\15\235", "\60\221\135\68\198\167");
					end
				end
				if ((2978 < 3639) and v29) then
					local v124 = 0;
					while true do
						if ((3682 >= 2888) and (v124 == 0)) then
							if ((149 < 479) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\204\188\255\140\68\237\252\180\251\136\81", "\185\142\221\152\227\34")]:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < 5))) then
								if ((1020 >= 567) and v26(v53.BagofTricks)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\90\196\80\197\76\53\200\76\215\94\249\72\32\183\75\209\23\169\27", "\151\56\165\55\154\35\83");
								end
							end
							if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\129\81\6\239\174\70\53\251\172\80\0", "\142\192\35\101")]:IsCastable() and (v13:BuffDown(v53.BestialWrathBuff) or (v61 < 5))) or (733 > 2469)) then
								if ((2497 == 2497) and v26(v53.ArcanePulse)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\215\103\42\162\233\137\147\6\195\121\58\166\167\159\184\86\130\37", "\118\182\21\73\195\135\236\204");
								end
							end
							v124 = 1;
						end
						if ((3901 == 3901) and (v124 == 1)) then
							if ((201 < 415) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\41\46\25\65\10\8\201\7\46\8\69\10\25", "\157\104\92\122\32\100\109")]:IsCastable() and ((v13:Focus() + v13:FocusRegen() + 15) < v13:FocusMax())) then
								if (v26(v53.ArcaneTorrent) or (133 == 1784)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\162\180\204\203\51\34\178\191\172\180\221\207\51\51\205\184\183\230\155\152", "\203\195\198\175\170\93\71\237");
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v105 == 1) or (7 >= 310)) then
				if ((4992 > 286) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\135\143\22\218\112\119\169\189\23\207\109\126", "\22\197\234\101\174\25")]:IsCastable() and v29) then
					if (v26(v53.BestialWrath) or (2561 == 3893)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\49\182\200\127\174\219\185\58\38\164\200\126\239\196\146\109\102\245", "\230\77\84\197\188\22\207\183");
					end
				end
				if ((4362 >= 1421) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\219\24\201\243\136\178\248\48\253", "\85\153\116\166\156\236\193\144")]:IsCastable()) then
					if ((75 <= 3546) and v26(v53.Bloodshed, not v14:IsSpellInRange(v53.Bloodshed))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\236\66\188\224\19\172\229\73\243\247\20\228\177\29", "\96\196\128\45\211\132");
					end
				end
				if ((2680 <= 3418) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\17\136\122\75\218\140\188\217\62\159\122\82", "\184\85\237\27\63\178\207\212")]:IsCastable() and v29) then
					if (v26(v53.DeathChakram, not v14:IsSpellInRange(v53.DeathChakram)) or (4288 < 2876)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\12\92\8\75\0\102\10\87\9\82\27\94\5\25\26\75\72\1", "\63\104\57\105");
					end
				end
				if ((2462 >= 1147) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\32\142\168\72\40\136\169\73\10\137\160", "\36\107\231\196")]:IsReady()) then
					if (v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or (4914 < 2480)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\86\188\174\139\98\182\173\138\80\180\172\131\29\166\182\199\15\231", "\231\61\213\194");
					end
				end
				v105 = 2;
			end
			if ((v105 == 3) or (1559 == 1240)) then
				if ((566 == 566) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\98\169\181\225\21\68\155\175\236\4", "\112\32\200\199\131")]:IsCastable() and v78(v14)) then
					if ((3921 >= 3009) and v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\81\78\186\198\175\29\63\88\83\172\131\184\54\108\93\72\135\193\170\33\39\69\76\248\145\254", "\66\76\48\60\216\163\203");
					end
				end
				if ((2063 >= 1648) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\158\143\107\246\125\203\37\169\146", "\68\218\230\25\147\63\174")]:IsCastable()) then
					if ((1066 >= 452) and v26(v53.DireBeast, not v14:IsSpellInRange(v53.DireBeast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\35\65\73\137\175\47\82\95\162\237\57\71\12\228\251", "\214\205\74\51\44");
					end
				end
				if ((4974 >= 2655) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\201\73\240\236\114\244\88\209\232\126\244\75", "\23\154\44\130\156")]:IsReady()) then
					if (v51.CastTargetIf(v53.SerpentSting, v62, LUAOBFUSACTOR_DECRYPT_STR_0("\28\175\163", "\115\113\198\205\206\86"), v71, v79, not v14:IsSpellInRange(v53.SerpentSting), nil, nil, v57.SerpentStingMouseover) or (2721 <= 907)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\82\236\74\129\89\234\101\151\67\247\84\131\23\237\78\196\5\166", "\58\228\55\158");
					end
				end
				if ((4437 >= 3031) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\135\157\209\35\44\168\49\177", "\85\212\233\176\78\92\205")]:IsCastable() and v29) then
					if (v26(v53.Stampede, not v14:IsSpellInRange(v53.Stampede)) or (4470 < 2949)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\89\76\137\239\90\93\140\231\10\75\156\162\27\10", "\130\42\56\232");
					end
				end
				v105 = 4;
			end
			if ((v105 == 0) or (1580 == 2426)) then
				if (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\211\235\62\180\32\245\217\36\185\49", "\69\145\138\76\214")]:IsCastable() or (3711 == 503)) then
					if (v51.CastTargetIf(v57.BarbedShotPetAttack, v62, LUAOBFUSACTOR_DECRYPT_STR_0("\125\198\135", "\118\16\175\233\233\223"), v69, v77, not v14:IsSpellInRange(v53.BarbedShot), nil, nil, v57.BarbedShotMouseover) or (420 == 4318)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\137\133\39\185\235\143\66\152\140\58\175\174\152\105\203\214", "\29\235\228\85\219\142\235");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\31\213\168\223\114\74\20\90\50\192", "\50\93\180\218\189\23\46\71")]:IsCastable() and v77(v14)) or (4158 <= 33)) then
					if (v26(v57.BarbedShotPetAttack, not v14:IsSpellInRange(v53.BarbedShot)) or (99 > 4744)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\165\73\78\65\216\119\205\172\84\88\4\207\92\158\169\79\115\70\221\75\213\177\75\12\23", "\40\190\196\59\44\36\188");
					end
				end
				if ((4341 == 4341) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\31\68\208\184\245\123\25\52\64\235\189\246\121", "\109\92\37\188\212\154\29")]:IsCastable() and v29) then
					if ((255 <= 1596) and v26(v53.CalloftheWild)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\238\168\207\14\85\2\208\176\203\52\101\19\230\168\199\113\73\16\175\242", "\58\100\143\196\163\81");
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\49\75\47\175\28\70\232\3\27\76\39", "\110\122\34\67\195\95\41\133")]:IsReady() and (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\94\184\87\70\245\122\188\86\75\216\113", "\182\21\209\59\42")]:FullRechargeTime() < v59) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\150\91\213\21\32\142\165\82\193\28\53\177\165", "\222\215\55\165\125\65")]:IsAvailable()) or (4433 < 1635)) then
					if (v26(v57.KillCommandPetAttack, not v14:IsSpellInRange(v53.KillCommand)) or (4300 < 3244)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\216\202\22\205\194\226\71\33\208\200\30\178\210\249\10\120", "\42\76\177\166\122\146\161\141");
					end
				end
				v105 = 1;
			end
		end
	end
	local function v85()
		local v106 = 0;
		local v107;
		local v108;
		while true do
			if ((v106 == 4) or (3534 > 4677)) then
				if (v51.TargetIsValid() or (4859 < 2999)) then
					local v125 = 0;
					local v126;
					while true do
						if ((4726 > 2407) and (2 == v125)) then
							if ((v32 and v29) or (1284 > 3669)) then
								local v131 = 0;
								local v132;
								while true do
									if ((1117 < 2549) and (v131 == 0)) then
										v132 = v82();
										if (v132 or (2851 > 4774)) then
											return v132;
										end
										break;
									end
								end
							end
							if ((1031 < 3848) and ((v64 < 2) or (not v53[LUAOBFUSACTOR_DECRYPT_STR_0("\4\46\36\172\245\5\39\32\190\247\35", "\129\70\75\69\223")]:IsAvailable() and (v64 < 3)))) then
								local v133 = 0;
								local v134;
								while true do
									if ((1854 > 903) and (v133 == 0)) then
										v134 = v84();
										if ((4663 > 1860) and v134) then
											return v134;
										end
										break;
									end
								end
							end
							v125 = 3;
						end
						if ((4 == v125) or (3053 <= 469)) then
							if (v26(v53.PoolFocus) or (540 >= 1869)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\227\182\32\11\218\183\40\71\245\182\44\18\192", "\103\179\217\79");
							end
							break;
						end
						if ((3292 == 3292) and (0 == v125)) then
							if ((1038 <= 2645) and not v13:AffectingCombat() and not v27) then
								local v135 = 0;
								local v136;
								while true do
									if ((v135 == 0) or (3230 < 2525)) then
										v136 = v80();
										if (v136 or (2400 > 4083)) then
											return v136;
										end
										break;
									end
								end
							end
							v126 = v51.Interrupt(40, v53.CounterShot, v68);
							v125 = 1;
						end
						if ((v125 == 3) or (2745 > 4359)) then
							if ((172 <= 1810) and ((v64 > 2) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\100\206\242\250\104\204\74\206\242\255\121", "\143\38\171\147\137\28")]:IsAvailable() and (v64 > 1)))) then
								local v137 = 0;
								local v138;
								while true do
									if ((v137 == 0) or (492 >= 4959)) then
										v138 = v83();
										if (v138 or (756 == 2072)) then
											return v138;
										end
										break;
									end
								end
							end
							if ((1605 <= 4664) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\253\135\183\247\51\230\192", "\180\176\226\217\147\99\131")]:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
								if ((1816 == 1816) and v26(v53.MendPet)) then
									return "Mend Pet Low Priority (w/ Target)";
								end
							end
							v125 = 4;
						end
						if ((v125 == 1) or (621 > 3100)) then
							if (v126 or (1157 >= 4225)) then
								return v126;
							end
							if (v29 or (4986 == 4138)) then
								local v139 = 0;
								local v140;
								while true do
									if ((v139 == 0) or (2033 <= 224)) then
										v140 = v81();
										if (v140 or (1223 == 2011)) then
											return v140;
										end
										break;
									end
								end
							end
							v125 = 2;
						end
					end
				end
				if ((4827 > 4695) and not (v13:IsMounted() or v13:IsInVehicle()) and not v17:IsDeadOrGhost() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\103\178\18\209\113\137\183", "\195\42\215\124\181\33\236")]:IsCastable() and (v17:HealthPercentage() < v46) and v45) then
					if ((3710 > 3065) and v26(v53.MendPet)) then
						return "Mend Pet Low Priority (w/o Target)";
					end
				end
				break;
			end
			if ((2135 <= 2696) and (v106 == 0)) then
				v50();
				v27 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\68\57\210\93\20\239", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\231\199", "\25\18\136\164\195\107\35")];
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\220\34\174\72\126\185\210", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\44\227\46", "\226\77\140\75\186\104\188")];
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\193\215\56\67\188\221", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\187\217\101", "\70\216\189\22\98\210\52\24")];
				v106 = 1;
			end
			if ((v106 == 2) or (1742 > 4397)) then
				v65 = v14:IsInRange(40);
				v66 = v14:IsInRange(30);
				v67 = (v108 and v14:IsSpellInActionRange(v108)) or v14:IsInRange(30);
				v59 = v13:GCD() + 0.15;
				v106 = 3;
			end
			if ((3900 >= 1904) and (v106 == 3)) then
				if (v51.TargetIsValid() or v13:AffectingCombat() or (1724 == 909)) then
					local v127 = 0;
					while true do
						if ((1282 < 1421) and (v127 == 0)) then
							v60 = v10.BossFightRemains(nil, true);
							v61 = v60;
							v127 = 1;
						end
						if ((4876 >= 4337) and (v127 == 1)) then
							if ((4005 >= 3005) and (v61 == 11111)) then
								v61 = v10.FightRemains(v62, false);
							end
							break;
						end
					end
				end
				if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\118\19\124\122\54\82\25\117\103\51\92\5", "\90\51\107\20\19")]:IsCastable() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\168\232\141\230\49\140\226\132\251\52\130\254", "\93\237\144\229\143")]:IsReady() and (v13:HealthPercentage() <= v48)) or (4781 <= 4448)) then
					if ((1317 > 172) and v26(v53.Exhilaration)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\238\248\16\7\71\7\247\228\16\4\72", "\38\117\150\144\121\107");
					end
				end
				if ((4791 == 4791) and (v13:HealthPercentage() <= v37) and v36 and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\5\190\239\54\57\179\253\46\34\181\235", "\90\77\219\142")]:IsReady() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\206\1\32\53\88\15\105\242\11\47\60", "\26\134\100\65\89\44\103")]:IsUsable()) then
					if ((3988 > 1261) and v26(v57.Healthstone, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\230\49\47\176\249\240\36\44\170\244\163\52\38\162\244\237\35\42\178\244\163\99", "\196\145\131\80\67");
					end
				end
				if ((2240 <= 3616) and not (v13:IsMounted() or v13:IsInVehicle())) then
					local v128 = 0;
					while true do
						if ((v128 == 1) or (3988 < 3947)) then
							if ((4644 == 4644) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\146\51\51\135\128\241\247", "\131\223\86\93\227\208\148")]:IsCastable() and v45 and (v17:HealthPercentage() < v46)) then
								if ((1323 > 1271) and v26(v53.MendPet)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\206\64\184\178\93\133\230\81\246\158\20\178\235\5\134\164\20\186\241\76\162\175", "\213\131\37\214\214\125");
								end
							end
							break;
						end
						if ((1619 > 1457) and (v128 == 0)) then
							if ((v53[LUAOBFUSACTOR_DECRYPT_STR_0("\45\165\11\5\23\230\46\181\18", "\136\126\208\102\104\120")]:IsCastable() and v41) or (2860 < 1808)) then
								if (v26(v54[v42]) or (739 >= 1809)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\75\159\195\78\160\92\125\97\125\158", "\49\24\234\174\35\207\50\93");
								end
							end
							if ((1539 <= 4148) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\62\247\235\129\103\9\194\248\156", "\17\108\146\157\232")]:IsCastable() and v44 and v17:IsDeadOrGhost()) then
								if (v26(v53.RevivePet) or (434 > 3050)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\121\198\2\228\57\173\11\243\17\249", "\200\43\163\116\141\79");
								end
							end
							v128 = 1;
						end
					end
				end
				v106 = 4;
			end
			if ((v106 == 1) or (3054 < 1683)) then
				if ((47 < 2706) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\233\203\172\138\195", "\179\186\191\195\231")]:IsAvailable()) then
					v10[LUAOBFUSACTOR_DECRYPT_STR_0("\202\47\20\229\234\55\61\234\252\50\17\225\234", "\132\153\95\120")].ChangeFriendTargetsTracking(LUAOBFUSACTOR_DECRYPT_STR_0("\156\187\0\40\183\245\174\189\171", "\192\209\210\110\77\151\186"));
				else
					v10[LUAOBFUSACTOR_DECRYPT_STR_0("\211\19\46\232\236\204\197\13\39\228\246\193\243", "\164\128\99\66\137\159")].ChangeFriendTargetsTracking(LUAOBFUSACTOR_DECRYPT_STR_0("\33\133\229", "\222\96\233\137"));
				end
				v107 = (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\155\191\168\16\140\209\255\181\167", "\144\217\211\199\127\232\147")]:IsPetKnown() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\218\35\49\39\209\103\13\72\236", "\36\152\79\94\72\181\37\98")]) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\245\209\83\58", "\95\183\184\39")]:IsPetKnown() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\151\54\243\35", "\98\213\95\135\70\52\224")]) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\221\175\200\96", "\52\158\195\169\23")]:IsPetKnown() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\89\176\51\99", "\235\26\220\82\20\230\85\27")]) or (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\187\172\232\193\127", "\20\232\193\137\162")]:IsPetKnown() and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\17\210\196\165\236", "\17\66\191\165\198\135\236\119")]) or nil;
				v108 = (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\40\189\161\4\243", "\177\111\207\206\115\159\136\140")]:IsPetKnown() and v20.FindBySpellID(v53[LUAOBFUSACTOR_DECRYPT_STR_0("\34\155\31\3\216", "\63\101\233\112\116\180\47")]:ID()) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\228\41\226\5\244", "\86\163\91\141\114\152")]) or nil;
				if ((1519 >= 580) and v23()) then
					local v129 = 0;
					while true do
						if ((v129 == 1) or (3110 == 4177)) then
							v64 = (v107 and #v63) or v14:GetEnemiesInSplashRangeCount(8);
							break;
						end
						if ((4200 > 2076) and (v129 == 0)) then
							v62 = v13:GetEnemiesInRange(40);
							v63 = (v107 and v13:GetEnemiesInSpellActionRange(v107)) or v14:GetEnemiesInSplashRange(8);
							v129 = 1;
						end
					end
				else
					local v130 = 0;
					while true do
						if ((v130 == 0) or (601 >= 2346)) then
							v62 = {};
							v63 = v14 or {};
							v130 = 1;
						end
						if ((3970 <= 4354) and (1 == v130)) then
							v64 = 0;
							break;
						end
					end
				end
				v106 = 2;
			end
		end
	end
	local function v86()
		local v109 = 0;
		local v110;
		while true do
			if ((0 == v109) or (1542 < 208)) then
				v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\47\92\54\45\49\184\32\88\36\42\32\234\20\25\53\39\101\221\29\80\52\112\101\203\24\73\39\49\55\236\8\93\119\60\60\184\42\86\61\55\55\249", "\152\109\57\87\94\69"));
				v110 = (v53[LUAOBFUSACTOR_DECRYPT_STR_0("\222\197\5\180\178", "\200\153\183\106\195\222\178\52")]:IsPetKnown() and v20.FindBySpellID(v53[LUAOBFUSACTOR_DECRYPT_STR_0("\21\241\135\42\69", "\58\82\131\232\93\41")]:ID()) and v53[LUAOBFUSACTOR_DECRYPT_STR_0("\164\69\223\2\81", "\95\227\55\176\117\61")]) or nil;
				v109 = 1;
			end
			if ((1612 <= 2926) and (v109 == 1)) then
				if (not v110 or (2006 <= 540)) then
					v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\4\125\37\77\173\30\120\37\27\251\49\112\37\68\183\10\36\99\106\175\28\62\51\78\191\88\127\33\66\167\17\106\42\78\184\88\106\44\11\178\23\107\49\11\170\27\106\42\68\165\88\124\34\89\184\88\106\44\11\162\21\110\49\68\189\29\62\49\74\165\31\123\99\72\163\29\125\40\88\229", "\203\120\30\67\43"));
				end
				break;
			end
		end
	end
	v10.SetAPL(253, v85, v86);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\212\53\68\247\230\217\48\67\251\220\227\26\111\234\216\226\49\96\238\202\229\32\95\246\151\253\48\76", "\185\145\69\45\143")]();

