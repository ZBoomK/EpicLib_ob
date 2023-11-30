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
		if ((v5 == 0) or (1949 < 71)) then
			v6 = v0[v4];
			if ((4254 == 4254) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((3196 >= 2550) and (1 == v5)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\140\198\12\221\204\216\46\217\159\194\13\197\209\206\38\242\178\200\16\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\155\33\4", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\218\88\164\83\239", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\133\114\105\59\22\91\236\70\186", "\35\200\29\28\72\115\20\154")];
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
	local v48;
	local function v49()
		local v78 = 0;
		while true do
			if ((2456 < 4176) and (v78 == 2)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\129\171\88\13\134\22\3", "\112\69\228\223\44\100\232\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\17\19\214\164\110\147\196\11\48\218\162\116\181\192\10\9", "\230\180\127\103\179\214\28")] or 0;
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\75\82\237\79\231\159", "\128\236\101\63\38\132\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\5\65\164\249\218\188\189\62\74\186\242\248\164\160\5\65\186\226\220\184", "\175\204\201\113\36\214\139")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\201\33\200\13\73\203\38", "\100\39\172\85\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\132\118\173\133\33\191\109\169\148\7\165\106\188\147\59\162\116\189", "\83\205\24\217\224")] or 0;
				v78 = 3;
			end
			if ((v78 == 0) or (1150 == 3452)) then
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\235\177\218\14\224\162\221", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\59\90\10\36\93\241\87\36\76", "\152\54\72\63\88\69\62")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\193\250\72\221\202\233\79", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\77\0\1\34\236\30\81\80\2\25\40\249\27\87\80", "\114\56\62\101\73\71\141")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\236\207\208\177\231\220\215", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\227\48\190\175\240\12\226\233\37\187\169\240\37\211\235\52", "\107\178\134\81\210\198\158")] or 0;
				v78 = 1;
			end
			if ((1875 < 2258) and (v78 == 1)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\11\150\210\163\54\9\145", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\10\131\251\195\205\8\178\248\222\202\0\140\223\250", "\170\163\111\226\151")] or 0;
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\166\44\71\57\46\2", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\63\200\58\226\128\32\217\26\244\149\35\195\23", "\135\225\76\173\114")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\232\172\164\165\179\160\9", "\199\122\141\216\208\204\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\216\17\252\108\254\190\201\31\254\125\222\157", "\150\205\189\112\144\24")] or 0;
				v78 = 2;
			end
			if ((1173 > 41) and (v78 == 3)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\192\217\41\239\203\202\46", "\93\134\165\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\231\204\207\53\192\130\123\170", "\30\222\146\161\162\90\174\210")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\75\100\30\236\64\119\25", "\106\133\46\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\124\33\97\247\106\65\91\52\91\204", "\32\56\64\19\156\58")] or 0;
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\105\205\241\66\83\252\135\73", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\112\81\69\242\103\131\175\10\79\89\72", "\107\57\54\43\157\21\230\231")];
				break;
			end
		end
	end
	local v50 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\248\132\28\248\182\210\220", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\185\132\94\250\118\118\57", "\24\92\207\225\44\131\25")];
	local v51 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\124\210\170\64\20\126\64", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\153\220\51\88\175\204\35\88\180\214\46", "\44\221\185\64")];
	local v52 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\54\230\90\83\124\2\236", "\19\97\135\40\63")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\89\32\47\61\36\173\72\58\52\33", "\81\206\60\83\91\79")];
	local v53 = {};
	local v54 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\121\170\194\126\32\192\70", "\196\46\203\176\18\79\163\45")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\39\109\10\54\238\236\172\43\113\16", "\143\216\66\30\126\68\155")];
	local v55, v56;
	local v57 = false;
	local v58 = false;
	local v59 = false;
	local v60 = 0;
	local v61 = 11111;
	local v62 = 11111;
	v10:RegisterForEvent(function()
		local v79 = 0;
		while true do
			if ((v79 == 2) or (56 >= 3208)) then
				v61 = 11111;
				v62 = 11111;
				break;
			end
			if ((4313 > 3373) and (v79 == 1)) then
				v59 = false;
				v60 = 0;
				v79 = 2;
			end
			if ((v79 == 0) or (4493 == 2225)) then
				v57 = false;
				v58 = false;
				v79 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\154\228\44\242\224\145\232\211\143\239\40\229\250\134\249\192\136\228\40\239", "\129\202\168\109\171\165\195\183"));
	v51[LUAOBFUSACTOR_DECRYPT_STR_0("\17\77\58\213\209\26\207\44\94\50\202\208\21\234", "\134\66\56\87\184\190\116")]:RegisterInFlight();
	v51[LUAOBFUSACTOR_DECRYPT_STR_0("\31\57\8\180\10\201\46\57\40", "\85\92\81\105\219\121\139\65")]:RegisterInFlight();
	v51[LUAOBFUSACTOR_DECRYPT_STR_0("\212\189\83\76\114\218\239\178\68\64", "\191\157\211\48\37\28")]:RegisterInFlight();
	local function v63(v80)
		local v81 = 0;
		while true do
			if ((3104 >= 3092) and (v81 == 0)) then
				for v104 in pairs(v80) do
					local v105 = 0;
					local v106;
					while true do
						if ((3548 > 3098) and (v105 == 0)) then
							v106 = v80[v104];
							if (v106:DebuffUp(v51.Havoc) or (3252 == 503)) then
								return true, v106:DebuffRemains(v51.Havoc);
							end
							break;
						end
					end
				end
				return false, 0;
			end
		end
	end
	local function v64()
		return v10[LUAOBFUSACTOR_DECRYPT_STR_0("\248\10\245\14\62\214\30\250\15\14\222\29\248\25", "\90\191\127\148\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\81\137\40\18\106\137\47\27\92\146\60\22\108\142\33\25", "\119\24\231\78")] or (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\177\56\168\71\211\78\56\140\43\160\88\210\65\29", "\113\226\77\197\42\188\32")]:InFlight() and 30) or 0;
	end
	local function v65()
		return v10[LUAOBFUSACTOR_DECRYPT_STR_0("\29\3\245\167\62\31\245\187\41\34\245\183\54\19", "\213\90\118\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\34\181\69\93\83\43\185\79\105\78\60\181\66\68\84\32", "\45\59\78\212\54")] or 0;
	end
	local function v66(v82)
		return v82:DebuffRefreshable(v51.ImmolateDebuff) and (v82:DebuffRemains(v51.ImmolateDebuff) < v60) and (v13:SoulShardsP() < 4.5) and (v82:DebuffDown(v51.HavocDebuff) or v82:DebuffDown(v51.ImmolateDebuff));
	end
	local function v67(v83)
		return ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\57\88\151\142\148\32\172\252\51\89\142\137\147\61\185\249\31\88", "\144\112\54\227\235\230\78\205")]:IsAvailable() and v83:DebuffRefreshable(v51.ImmolateDebuff)) or (v83:DebuffRemains(v51.ImmolateDebuff) < 3)) and (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\144\41\27\253\211\87\170\59\2", "\59\211\72\111\156\176")]:IsAvailable() or (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\109\134\247\44\77\139\250\62\67", "\77\46\231\131")]:CooldownRemains() > v83:DebuffRemains(v51.ImmolateDebuff))) and (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\137\91\163\76\156\93\164\69", "\32\218\52\214")]:IsAvailable() or ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\125\24\36\164\215\185\87\95", "\58\46\119\81\200\145\208\37")]:CooldownRemains() + (v27(not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\6\141\41\164\172\176", "\86\75\236\80\204\201\221")]:IsAvailable()) * v51[LUAOBFUSACTOR_DECRYPT_STR_0("\65\78\98\137\216\130\96\68", "\235\18\33\23\229\158")]:CastTime())) > v83:DebuffRemains(v51.ImmolateDebuff)));
	end
	local function v68(v84)
		return (v84:DebuffRemains(v51.ImmolateDebuff) < 5) and (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\115\187\213\186\83\182\216\168\93", "\219\48\218\161")]:IsAvailable() or (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\199\112\104\72\216\67\249\247\124", "\128\132\17\28\41\187\47")]:CooldownRemains() > v84:DebuffRemains(v51.ImmolateDebuff))) and (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\51\51\1\51\83\6\22\3\55\82\15\52\15\40\88", "\61\97\82\102\90")]:IsAvailable() or (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\143\38\170\69\201\82\18\45\169\35\164\69\193\94\12\12", "\105\204\78\203\43\167\55\126")]:CooldownRemains() > v84:DebuffRemains(v51.ImmolateDebuff)));
	end
	local function v69()
		local v85 = 0;
		while true do
			if ((4733 > 2066) and (v85 == 2)) then
				if ((3549 >= 916) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\222\253\63\219\249\246\46\211\227\246", "\178\151\147\92")]:IsCastable() and not v13:IsCasting(v51.Incinerate)) then
					if (v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true) or (2189 <= 245)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\133\243\79\59\28\73\104\141\233\73\114\2\94\127\143\242\65\48\19\88\58\212", "\26\236\157\44\82\114\44");
					end
				end
				break;
			end
			if ((v85 == 0) or (1389 > 3925)) then
				v58 = false;
				if ((4169 >= 3081) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\130\184\42\19\28\13\213\84\170\172\16\31\16\22\206\87\172\169\38", "\49\197\202\67\126\115\100\167")]:IsReady()) then
					if ((349 <= 894) and v26(v51.GrimoireofSacrifice)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\73\214\36\143\95\76\50\100\208\47\191\69\95\52\73\214\47\137\85\91\119\75\205\44\131\89\83\53\90\203\105\210", "\62\87\59\191\73\224\54");
					end
				end
				v85 = 1;
			end
			if ((731 <= 2978) and (v85 == 1)) then
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\212\13\239\197\193\11\232\204", "\169\135\98\154")]:IsReady() and not v13:IsCasting(v51.SoulFire)) or (892 > 3892)) then
					if (v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true) or (4466 == 900)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\120\49\88\194\53\193\217\114\100\68\239\54\203\196\122\38\85\233\115\156", "\168\171\23\68\52\157\83");
					end
				end
				if (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\215\112\225\172\38\33\158\231\124", "\231\148\17\149\205\69\77")]:IsCastable() or (2084 >= 2888)) then
					if ((479 < 1863) and v26(v51.Cataclysm, not v15:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\131\166\211\250\84\243\153\180\202\187\71\237\133\164\200\246\85\254\148\231\145", "\159\224\199\167\155\55");
					end
				end
				v85 = 2;
			end
		end
	end
	local function v70()
		local v86 = 0;
		while true do
			if ((v86 == 1) or (2428 >= 4038)) then
				ShouldReturn = v50.HandleBottomTrinket(OnUseExcludes, v31, 40, nil);
				if (ShouldReturn or (2878 > 2897)) then
					return ShouldReturn;
				end
				break;
			end
			if ((v86 == 0) or (2469 > 3676)) then
				ShouldReturn = v50.HandleTopTrinket(OnUseExcludes, v31, 40, nil);
				if ((233 < 487) and ShouldReturn) then
					return ShouldReturn;
				end
				v86 = 1;
			end
		end
	end
	local function v71()
		local v87 = 0;
		while true do
			if ((2473 >= 201) and (v87 == 0)) then
				if ((4120 >= 133) and v52[LUAOBFUSACTOR_DECRYPT_STR_0("\30\39\216\94\40\60\208\90\41\38\220\85\45\26\212\87\37\32", "\59\74\78\181")]:IsEquippedAndReady() and (v13:BuffUp(v51.DemonicPowerBuff) or (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\22\196\87\87\188\43\245\95\87\188\43\216\89\110\170\55\208\84\78", "\211\69\177\58\58")]:IsAvailable() and (v13:BuffUp(v51.NetherPortalBuff) or not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\153\224\109\253\236\217\135\234\107\225\232\199", "\171\215\133\25\149\137")]:IsAvailable())))) then
					if ((3080 >= 1986) and v26(v54.TimebreachingTalon)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\193\63\255\237\34\249\67\226\192\59\244\232\15\232\67\237\199\60\186\230\36\249\79\242\136\96", "\34\129\168\82\154\143\80\156");
					end
				end
				if (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\182\167\62\6\71\64\173\128\191\60\5\65\77\189\156\160\50\5\92", "\233\229\210\83\107\40\46")]:IsAvailable() or v13:BuffUp(v51.DemonicPowerBuff) or (1439 > 3538)) then
					local v107 = 0;
					local v108;
					while true do
						if ((v107 == 0) or (419 < 7)) then
							v108 = v70();
							if ((2820 == 2820) and v108) then
								return v108;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v72()
		if ((v64() > 0) or not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\242\87\63\219\10\207\107\60\208\0\211\76\51\218", "\101\161\34\82\182")]:IsAvailable() or (4362 <= 3527)) then
			local v94 = 0;
			local v95;
			while true do
				if ((2613 <= 2680) and (v94 == 0)) then
					v95 = v50.HandleDPSPotion();
					if (v95 or (1482 >= 4288)) then
						return v95;
					end
					v94 = 1;
				end
				if ((v94 == 1) or (2462 > 4426)) then
					if ((4774 == 4774) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\202\8\75\237\222\240\137\39\230\10", "\78\136\109\57\158\187\130\226")]:IsCastable() and (((v62 < (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\13\42\244\252\49\49\208\255\56\58\235\255\63\51", "\145\94\95\153")]:CooldownRemains() + 12)) and (v62 > 12)) or (v62 < v51[LUAOBFUSACTOR_DECRYPT_STR_0("\206\216\25\216\65\185\212\195\18\208\92\185\252\193", "\215\157\173\116\181\46")]:CooldownRemains()))) then
						if ((566 <= 960) and v26(v51.Berserking, nil, nil, true)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\55\177\153\225\223\39\191\130\252\221\117\183\143\225\154\100\228", "\186\85\212\235\146");
						end
					end
					if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\224\141\25\241\61\200\77\208\152", "\56\162\225\118\158\89\142")]:IsCastable() and (((v62 < (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\111\16\205\162\45\214\117\11\198\170\48\214\93\9", "\184\60\101\160\207\66")]:CooldownRemains() + 10 + 15)) and (v62 > 15)) or (v62 < v51[LUAOBFUSACTOR_DECRYPT_STR_0("\2\151\113\177\62\140\85\178\55\135\110\178\48\142", "\220\81\226\28")]:CooldownRemains()))) or (2910 <= 1930)) then
						if (v26(v51.BloodFury, nil, nil, true) or (19 > 452)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\17\217\141\244\238\248\21\192\144\226\170\196\23\198\194\170\184", "\167\115\181\226\155\138");
						end
					end
					v94 = 2;
				end
				if ((v94 == 2) or (907 > 3152)) then
					if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\196\43\245\89\121\125\201\237\38", "\166\130\66\135\60\27\17")]:IsCastable() and (((v62 < (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\119\95\195\120\63\74\99\192\115\53\86\68\207\121", "\80\36\42\174\21")]:CooldownRemains() + 10 + 8)) and (v62 > 8)) or (v62 < v51[LUAOBFUSACTOR_DECRYPT_STR_0("\125\5\58\119\65\30\30\116\72\21\37\116\79\28", "\26\46\112\87")]:CooldownRemains()))) or (2505 > 4470)) then
						if (v26(v51.Fireblood, nil, nil, true) or (3711 > 4062)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\191\42\185\113\189\179\74\187\189\99\168\112\172\255\20\224", "\212\217\67\203\20\223\223\37");
						end
					end
					break;
				end
			end
		end
	end
	local function v73()
		local v88 = 0;
		while true do
			if ((420 == 420) and (v88 == 0)) then
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\153\130\166\212\182\140\175\192\187\153\173", "\178\218\237\200")]:IsCastable() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\148\180\229\219\178\167\231\214\162", "\176\214\213\134")]:IsAvailable() and v13:BuffDown(v51.BackdraftBuff) and (v13:SoulShardsP() >= 1) and (v13:SoulShardsP() <= 4)) or (33 >= 3494)) then
					if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or (1267 == 4744)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\247\162\184\210\164\87\94\230\172\162\209\232\94\88\226\162\181\148\250", "\57\148\205\214\180\200\54");
					end
				end
				if ((2428 < 3778) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\33\242\32\56\80\27\239\48", "\22\114\157\85\84")]:IsCastable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\247\196\6\200\123\255\186\193", "\200\164\171\115\164\61\150")]:CastTime() < v60) and (v13:SoulShardsP() < 2.5)) then
					if (v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true) or (2946 <= 1596)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\251\22\73\188\184\253\17\64\195\182\245\21\74\128\254\160", "\227\222\148\99\37");
					end
				end
				v88 = 1;
			end
			if ((4433 > 3127) and (3 == v88)) then
				if ((4300 >= 2733) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\6\39\9\206\250\50\0\9\210\240", "\149\84\70\96\160")]:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v56 >= ((4 - v27(v51[LUAOBFUSACTOR_DECRYPT_STR_0("\17\8\11\232\42\8\2", "\141\88\102\109")]:IsAvailable())) + v27(v51[LUAOBFUSACTOR_DECRYPT_STR_0("\158\82\206\126\31\46\70\206\181\71\194\117\59\39\95\224\162\90\216", "\161\211\51\170\16\122\93\53")]:IsAvailable())))) then
					if ((4829 == 4829) and v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\175\187\38\196\161\180\23\253\167\160\45\187\166\179\62\244\173\242\121\169", "\72\155\206\210");
					end
				end
				if ((1683 <= 4726) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\116\123\93\0\60\64\92\93\28\54", "\83\38\26\52\110")]:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v56 > 1) and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\121\1\38\82\89\5\40\64\124\18\52\82\74\2\36\82\81\24\41", "\38\56\119\71")]:IsAvailable() or (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\193\238\81\216\42\80\208\231\89\217\54", "\54\147\143\56\182\69")]:IsAvailable() and v13:BuffUp(v51.RainofChaosBuff))) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\255\143\249\76\205\216\142", "\191\182\225\159\41")]:IsAvailable()) then
					if ((4835 >= 3669) and v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\19\33\91\180\136\196\20\20\33\71\142\199\202\42\4\39\86\203\214\145", "\162\75\114\72\53\235\231");
					end
				end
				v88 = 4;
			end
			if ((2851 > 1859) and (v88 == 2)) then
				if ((3848 > 2323) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\238\239\28\244\9\239\232\17\239", "\122\173\135\125\155")]:IsReady() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\167\211\25\145\62\39\199\135", "\168\228\161\96\217\95\81")]:IsAvailable() and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\242\223\40\89\61\89\212", "\55\187\177\78\60\79")]:IsAvailable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\14\198\94\228\85\237\143\33\218", "\224\77\174\63\139\38\175")]:CastTime() < v60)) then
					if ((2836 > 469) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\73\89\33\151\126\90\33\136\85\24\38\133\87\87\45\196\24", "\78\228\33\56");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\237\118\179\12\150\236\113\190\23", "\229\174\30\210\99")]:IsReady() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\56\229\135\94\254\31\54\23\249", "\89\123\141\230\49\141\93")]:CastTime() < v60) and (v56 < (((4 - v27(v51[LUAOBFUSACTOR_DECRYPT_STR_0("\218\127\240\9\2\68\252", "\42\147\17\150\108\112")]:IsAvailable())) + v27(v51[LUAOBFUSACTOR_DECRYPT_STR_0("\34\167\41\113\226\251\28\169\43\107\239\237\46\188\39\94\246\225\29", "\136\111\198\77\31\135")]:IsAvailable())) - v27(v51[LUAOBFUSACTOR_DECRYPT_STR_0("\43\7\161\83\175\234\24", "\201\98\105\199\54\221\132\119")]:IsAvailable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\139\13\138\47\13\51\143\177\13\140\50", "\204\217\108\227\65\98\85")]:IsAvailable() or v51[LUAOBFUSACTOR_DECRYPT_STR_0("\127\213\244\241\45\210\81\197\209\224\63\212\76\214\246\241\37\207\80", "\160\62\163\149\133\76")]:IsAvailable()) and v13:BuffUp(v51.RainofChaosBuff))))) or (2096 <= 540)) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or (3183 < 2645)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\213\168\12\32\208\233\162\2\35\215\150\168\12\57\204\213\224\92\127", "\163\182\192\109\79");
					end
				end
				v88 = 3;
			end
			if ((3230 <= 3760) and (v88 == 4)) then
				if ((3828 == 3828) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\175\51\74\228\95\3\139\46\69\246\86", "\98\236\92\36\130\51")]:IsCastable() and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\134\24\15\177\65\186\180\54\176", "\80\196\121\108\218\37\200\213")]:IsAvailable()) then
					if ((554 == 554) and v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\124\12\121\71\15\141\18\114\22\122\11\6\139\22\124\1\63\26\90", "\234\96\19\98\31\43\110");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\47\17\81\206\162\119\153\7\11\87", "\235\102\127\50\167\204\18")]:IsCastable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\121\175\246\42\74\43\66\160\225\38", "\78\48\193\149\67\36")]:CastTime() < v60)) or (2563 == 172)) then
					if ((3889 >= 131) and v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\16\131\17\79\53\12\129\12\68\112\22\129\14\78\51\94\209\78", "\33\80\126\224\120");
					end
				end
				break;
			end
			if ((v88 == 1) or (492 == 4578)) then
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\16\90\83\248\247\54\94\118\243\244\60\92\84\255\235\54", "\153\83\50\50\150")]:IsCastable() and (v13:SoulShardsP() < 4.5) and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\111\119\116\21\125\172\105\88\123\124\18\117\162\95\88", "\45\61\22\19\124\19\203")]:TalentRank() == 2) and (v56 > 2)) or (4112 < 1816)) then
					if ((4525 >= 1223) and v26(v51.ChannelDemonfire, not v15:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\194\26\12\251\12\117\181\254\22\8\248\13\126\191\200\0\8\181\10\113\175\206\17\77\163", "\217\161\114\109\149\98\16");
					end
				end
				if ((1090 <= 4827) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\59\45\53\115\176\117\6\37", "\20\114\64\88\28\220")]:IsCastable()) then
					if (v50.CastCycle(v51.Immolate, v55, v66, not v15:IsSpellInRange(v51.Immolate), nil, nil, v54.ImmolateMouseover, true) or (239 > 1345)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\12\223\187\244\209\169\52\65\218\181\238\223\190\113\89", "\221\81\97\178\212\152\176");
					end
				end
				v88 = 2;
			end
		end
	end
	local function v74()
		local v89 = 0;
		while true do
			if ((v89 == 0) or (3710 >= 3738)) then
				if ((v31 and v33) or (3838 < 2061)) then
					local v109 = 0;
					local v110;
					while true do
						if ((v109 == 0) or (690 > 1172)) then
							v110 = v71();
							if (v110 or (1592 > 2599)) then
								return v110;
							end
							break;
						end
					end
				end
				if ((3574 <= 4397) and v31) then
					local v111 = 0;
					local v112;
					while true do
						if ((3135 > 1330) and (v111 == 0)) then
							v112 = v72();
							if (v112 or (3900 <= 3641)) then
								return v112;
							end
							break;
						end
					end
				end
				if ((1724 == 1724) and v59 and (v60 > v13:GCD())) then
					local v113 = 0;
					local v114;
					while true do
						if ((455 <= 1282) and (v113 == 0)) then
							v114 = v73();
							if ((4606 < 4876) and v114) then
								return v114;
							end
							break;
						end
					end
				end
				v57 = (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\196\169\21\203\95", "\60\140\200\99\164")]:CooldownRemains() <= 10) or v51[LUAOBFUSACTOR_DECRYPT_STR_0("\170\245\29\46\167\138", "\194\231\148\100\70")]:IsAvailable();
				v89 = 1;
			end
			if ((4 == v89) or (1442 > 2640)) then
				if ((136 < 3668) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\35\143\163\95\19\165\173\92\20", "\48\96\231\194")]:IsReady() and (v13:BuffRemains(v51.RainofChaosBuff) > v51[LUAOBFUSACTOR_DECRYPT_STR_0("\235\82\15\34\10\250\160\143\220", "\227\168\58\110\77\121\184\207")]:CastTime())) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or (1784 > 4781)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\120\52\190\79\162\228\115\170\119\40\255\67\189\222\112\179\126\124\237\20", "\197\27\92\223\32\209\187\17");
					end
				end
				if ((4585 > 3298) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\32\87\194\244\16\125\204\247\23", "\155\99\63\163")]:IsReady() and v13:BuffUp(v51.BackdraftBuff) and not v57) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or (1664 > 1698)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\217\160\130\170\187\128\222\173\153\249\135\142\212\160\155\188\196\208\135", "\228\226\177\193\237\217");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\23\184\34\233\39\146\44\234\32", "\134\84\208\67")]:IsReady() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\54\190\135\88\26\175\135\72\26\163\136", "\60\115\204\230")]:IsAvailable() and not v57 and (v15:DebuffRemains(v51.EradicationDebuff) < v51[LUAOBFUSACTOR_DECRYPT_STR_0("\196\50\234\127\244\24\228\124\243", "\16\135\90\139")]:CastTime()) and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\119\124\7\60\93\118\119\88\96", "\24\52\20\102\83\46\52")]:InFlight()) or (3427 < 2849)) then
					if ((3616 <= 4429) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\199\39\32\43\28\251\45\46\40\27\132\44\45\33\14\210\42\97\118\87", "\111\164\79\65\68");
					end
				end
				if ((3988 >= 66) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\229\209\130\209\61\200\201\213\151", "\138\166\185\227\190\78")]:IsReady() and (v13:BuffUp(v51.MadnessCBBuff))) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or (862 > 4644)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\200\124\196\56\65\28\27\196\120\209\119\81\47\28\202\98\192\119\1\115", "\121\171\20\165\87\50\67");
					end
				end
				v89 = 5;
			end
			if ((1221 == 1221) and (v89 == 5)) then
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\245\55\172\58\159\11\212\61", "\98\166\88\217\86\217")]:IsCastable() and (v13:SoulShardsP() <= 4) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\219\247\96\9\131\209", "\188\150\150\25\97\230")]:IsAvailable()) or (45 > 1271)) then
					if ((3877 > 1530) and v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\134\74\14\51\235\211\155\90\66\15\225\223\136\73\7\76\190\136", "\141\186\233\63\98\108");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\210\226\45\184\43\244\230\8\179\40\254\228\42\191\55\244", "\69\145\138\76\214")]:IsCastable() and not (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\84\198\136\139\176\26\121\204\172\132\189\19\98\220", "\118\16\175\233\233\223")]:IsAvailable() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\170\146\52\175\239\153\114\141\160\48\168\250\153\104\136\144\60\180\224", "\29\235\228\85\219\142\235")]:IsAvailable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\31\193\168\211\99\65\6\65\53\209\169", "\50\93\180\218\189\23\46\71")]:IsAvailable() or v51[LUAOBFUSACTOR_DECRYPT_STR_0("\253\172\90\67\87\245\70\221\165\73\66\69\200\77", "\40\190\196\59\44\36\188")]:IsAvailable()))) or (4798 == 1255)) then
					if (v26(v51.ChannelDemonfire, not v15:IsInRange(40), true) or (2541 > 2860)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\77\221\186\244\120\1\3\65\217\185\245\115\11\53\87\217\244\249\113\8\61\83\217\244\169\41", "\109\92\37\188\212\154\29");
					end
				end
				if ((v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\32\230\169\198\63\73\13\224\170\194\61\104\13\233\176", "\58\100\143\196\163\81")]:IsCastable()) or (2902 > 3629)) then
					if ((427 < 3468) and v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\30\75\46\166\49\90\236\1\20\67\47\156\45\64\227\26\90\65\47\166\62\95\224\78\73\20", "\110\122\34\67\195\95\41\133");
					end
				end
				if ((4190 >= 2804) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\86\185\90\69\197\87\190\87\94", "\182\21\209\59\42")]:IsReady() and (v13:SoulShardsP() > 3.5)) then
					if ((2086 == 2086) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\95\196\18\50\129\181\88\201\9\97\189\187\82\196\11\36\254\228\15", "\222\215\55\165\125\65");
					end
				end
				v89 = 6;
			end
			if ((4148 > 2733) and (v89 == 2)) then
				if ((3054 >= 1605) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\10\167\89\20\230\235\28\60", "\110\89\200\44\120\160\130")]:IsCastable() and (v13:SoulShardsP() <= 3.5) and ((v15:DebuffRemains(v51.RoaringBlazeDebuff) > (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\152\204\94\74\101\67\41\72", "\45\203\163\43\38\35\42\91")]:CastTime() + v51[LUAOBFUSACTOR_DECRYPT_STR_0("\225\138\201\47\161\160\70\215", "\52\178\229\188\67\231\201")]:TravelTime())) or (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\19\78\81\22\254\82\36\3\77\81\30\242", "\67\65\33\48\100\151\60")]:IsAvailable() and v13:BuffUp(v51.BackdraftBuff))) and not v57) then
					if ((1044 < 1519) and v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\232\187\212\204\217\238\188\221\179\220\235\171\217\229\218\167\255\136", "\147\191\135\206\184");
					end
				end
				if ((1707 <= 4200) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\173\37\171\206\212\82\166\129", "\210\228\72\198\161\184\51")]:IsCastable()) then
					if ((580 == 580) and v50.CastCycle(v51.Immolate, v55, v67, not v15:IsSpellInRange(v51.Immolate), nil, nil, v54.ImmolateMouseover, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\68\254\31\127\207\34\76\179\19\127\203\55\95\246\80\34\156", "\174\86\41\147\112\19");
					end
				end
				if ((601 <= 999) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\115\1\155\4\38", "\203\59\96\237\107\69\111\113")]:IsCastable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\23\3\161\236\62\254\254\42\16\169\243\63\241\219", "\183\68\118\204\129\81\144")]:CooldownDown() or not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\61\184\125\233\4\140\39\163\118\225\25\140\15\161", "\226\110\205\16\132\107")]:IsAvailable())) then
					local v115 = 0;
					local v116;
					while true do
						if ((3970 == 3970) and (v115 == 0)) then
							v116 = v15:GUID();
							for v133, v134 in pairs(v55) do
								if (((v134:GUID() ~= v116) and v17 and v17:Exists() and (v134:GUID() == v17:GUID()) and not v134:IsFacingBlacklisted() and not v134:IsUserCycleBlacklisted()) or (98 == 208)) then
									if ((2006 <= 3914) and v26(v54.HavocMouseover)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\227\194\246\214\66\171\192\236\220\64\253\198\160\136\21", "\33\139\163\128\185");
									end
								end
							end
							break;
						end
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\116\80\5\209\68\122\11\210\67", "\190\55\56\100")]:IsReady() and ((v64() > 0) or (v65() > 0) or (v13:SoulShardsP() >= 4))) or (3101 <= 2971)) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or (2073 <= 671)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\167\61\17\0\220\241\89\163\40\94\16\239\246\87\185\57\94\66\181", "\147\54\207\92\126\115\131");
					end
				end
				v89 = 3;
			end
			if ((3305 > 95) and (v89 == 1)) then
				if ((2727 == 2727) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\101\67\207\165\250\201\65\94\192\183\243", "\168\38\44\161\195\150")]:IsCastable() and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\178\243\131\100\57\230\177\52\140\253\152\115", "\118\224\156\226\22\80\136\214")]:IsAvailable() and (v15:DebuffRemains(v51.RoaringBlazeDebuff) < 1.5)) or (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\97\225\87\134\78\239\94\146\67\250\92", "\224\34\142\57")]:Charges() == v51[LUAOBFUSACTOR_DECRYPT_STR_0("\253\168\203\219\127\240\90\28\223\179\192", "\110\190\199\165\189\19\145\61")]:MaxCharges()))) then
					if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or (2970 >= 4072)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\217\228\121\238\135\198\221\249\118\252\142\135\217\231\114\233\157\194\154\185", "\167\186\139\23\136\235");
					end
				end
				if ((3881 > 814) and v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\62\188\133\8\20\166\129\2\20\180\132\63\19\179\156", "\109\122\213\232")]:IsCastable() and (v13:SoulShardsP() < 4.7) and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\202\254\175\53\224\228\171\63\224\246\174\2\231\241\182", "\80\142\151\194")]:Charges() > 2) or (v62 < v51[LUAOBFUSACTOR_DECRYPT_STR_0("\39\207\122\73\13\213\126\67\13\199\123\126\10\192\99", "\44\99\166\23")]:Cooldown()))) then
					if (v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift)) or (4932 < 4868)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\120\254\36\51\61\183\117\248\39\55\63\155\110\254\47\34\115\167\112\242\40\32\54\228\40", "\196\28\151\73\86\83");
					end
				end
				if ((3667 <= 4802) and v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\208\2\61\17\129\84\1\101\254", "\22\147\99\73\112\226\56\120")]:IsCastable()) then
					if ((1260 >= 858) and v26(v51.Cataclysm, not v15:IsSpellInRange(v51.Cataclysm))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\187\116\246\244\142\180\108\241\248\205\187\121\231\244\155\189\53\180", "\237\216\21\130\149");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\161\70\94\81\190\204\82\166\75\82\80\190\207\87\144\75", "\62\226\46\63\63\208\169")]:IsCastable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\215\24\82\138\17\10\11\91\232\22\91\133\22\31\42", "\62\133\121\53\227\127\109\79")]:IsAvailable())) or (3911 == 4700)) then
					if ((3000 < 4194) and v26(v51.ChannelDemonfire, not v15:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\28\51\251\216\171\174\47\16\55\248\217\160\164\25\6\55\181\213\162\167\17\2\55\181\142", "\194\112\116\82\149\182\206");
					end
				end
				v89 = 2;
			end
			if ((651 < 4442) and (v89 == 3)) then
				if ((v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\62\36\56\112\2\112\36\63\51\120\31\112\12\61", "\30\109\81\85\29\109")]:IsCastable() and v17 and v17:Exists() and (v17:GUID() == v15:GUID())) or (195 >= 1804)) then
					if (v26(v54.SummonInfernalCursor) or (1382 > 2216)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\236\100\89\187\57\208\195\246\127\82\179\36\208\253\243\49\87\186\51\223\234\250\49\5\238", "\156\159\17\52\214\86\190");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\141\231\188\178\160\234\177\152\171\226\178\178\168\230\175\185", "\220\206\143\221")]:IsCastable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\180\104\36\25", "\178\230\29\77\119\184\172")]:TalentRank() > 1) and not (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\209\183\11\25\120\244\252\189\47\22\117\253\231\173", "\152\149\222\106\123\23")]:IsAvailable() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\252\48\247\87\180\207\41\240\103\176\206\50\228\86\182\201\47\249\77", "\213\189\70\150\35")]:IsAvailable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\109\64\102\6\91\90\85\27\71\80\103", "\104\47\53\20")]:IsAvailable() or v51[LUAOBFUSACTOR_DECRYPT_STR_0("\128\68\128\19\175\38\173\79\128\14\178\14\183\73", "\111\195\44\225\124\220")]:IsAvailable()))) or (2861 == 2459)) then
					if ((1903 < 4021) and v26(v51.ChannelDemonfire, not v15:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\78\1\125\165\174\212\121\4\118\166\164\214\64\9\97\174\235\219\74\5\114\189\174\152\20\80", "\203\184\38\96\19\203");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\26\124\119\71\194\56\116\107\64\218\60", "\174\89\19\25\33")]:IsCastable() and v13:BuffDown(v51.BackdraftBuff) and (v13:SoulShardsP() >= 1.5) and not v57) or (2270 >= 4130)) then
					if ((2593 <= 3958) and v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\29\92\72\251\134\12\61\19\70\75\183\132\7\42\19\68\75\183\213\89", "\107\79\114\50\46\151\231");
					end
				end
				if ((1176 == 1176) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\16\168\182\32\132\60\165\193\45\163", "\160\89\198\213\73\234\89\215")]:IsCastable() and v13:BuffUp(v51.BurntoAshesBuff) and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\97\127\183\247\203\77\99\181\234\192", "\165\40\17\212\158")]:CastTime() + v51[LUAOBFUSACTOR_DECRYPT_STR_0("\198\209\9\60\53\199\214\4\39", "\70\133\185\104\83")]:CastTime()) < v13:BuffRemains(v51.MadnessCBBuff))) then
					if (v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true) or (3062 == 1818)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\13\75\71\35\199\1\87\69\62\204\68\70\72\47\200\18\64\4\120\154", "\169\100\37\36\74");
					end
				end
				v89 = 4;
			end
			if ((v89 == 6) or (3717 < 3149)) then
				if ((3195 < 3730) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\15\217\199\21\225\227\226\70\56", "\42\76\177\166\122\146\161\141")]:IsReady() and not v57 and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\150\133\16\194\90\121\171\142\16\199\109", "\22\197\234\101\174\25")]:IsAvailable() and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\0\53\161\210\115\188\196\137\43\32\173\217\87\181\221\167\60\61\183", "\230\77\84\197\188\22\207\183")]:IsAvailable()) or not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\219\21\197\247\136\179\241\51\237", "\85\153\116\166\156\236\193\144")]:IsAvailable())) then
					if ((2797 <= 3980) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\167\232\76\188\247\63\166\239\65\167\164\3\168\229\76\165\225\64\240\176", "\96\196\128\45\211\132");
					end
				end
				if ((1944 <= 2368) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\22\133\122\80\193\141\187\212\33", "\184\85\237\27\63\178\207\212")]:IsReady() and (v62 < 5.5) and (v62 > (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\43\81\8\80\27\123\6\83\28", "\63\104\57\105")]:CastTime() + v51[LUAOBFUSACTOR_DECRYPT_STR_0("\40\143\165\75\24\165\171\72\31", "\36\107\231\196")]:TravelTime() + 0.5))) then
					if ((1709 < 4248) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\94\189\163\136\78\138\160\136\81\161\226\132\81\176\163\145\88\245\246\213", "\231\61\213\194");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\42\162\51\117\5\172\58\97\8\185\56", "\19\105\205\93")]:IsCastable() and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\138\7\208\135\51\168\15\204\128\43\172", "\95\201\104\190\225")]:Charges() > (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\140\196\207\200\163\202\198\220\174\223\196", "\174\207\171\161")]:MaxCharges() - 1)) or (v62 < (v13:GCD() * v51[LUAOBFUSACTOR_DECRYPT_STR_0("\206\241\3\245\244\214\234\236\12\231\253", "\183\141\158\109\147\152")]:Charges())))) or (3970 == 3202)) then
					if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or (3918 >= 4397)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\6\232\10\32\8\225\30\45\29\227\76\47\5\227\13\58\12\166\88\120", "\108\76\105\134");
					end
				end
				if (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\194\203\178\232\192\238\215\176\245\203", "\174\139\165\209\129")]:IsCastable() or (780 == 3185)) then
					if (v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true) or (3202 >= 4075)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\189\225\200\200\6\98\121\183\182\162\194\202\6\113\110\166\243\182\151", "\24\195\211\130\161\166\99\16");
					end
				end
				break;
			end
		end
	end
	local function v75()
		local v90 = 0;
		while true do
			if ((64 == 64) and (7 == v90)) then
				if ((2202 >= 694) and v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\43\166\163\22\241\251\229\222\1\174\162\33\246\238\248", "\177\111\207\206\115\159\136\140")]:IsCastable()) then
					if ((3706 <= 3900) and v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\128\29\17\218\92\86\10\135\17\24\235\93\86\3\157\80\21\219\74\31\87\223", "\63\101\233\112\116\180\47");
					end
				end
				if ((2890 > 2617) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\234\54\224\29\244\55\215\62", "\86\163\91\141\114\152")]:IsCastable() and (v15:DebuffRefreshable(v51.ImmolateDebuff))) then
					if (v26(v54.ImmolatePetAttack, not v15:IsSpellInRange(v51.Immolate), true) or (3355 > 4385)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\6\121\124\54\82\31\113\51\59\92\14\52\33\98", "\90\51\107\20\19");
					end
				end
				if (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\164\254\134\230\51\136\226\132\251\56", "\93\237\144\229\143")]:IsCastable() or (3067 <= 2195)) then
					if ((3025 >= 2813) and v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\248\243\16\5\67\7\247\228\28\75\71\26\243\176\74\91", "\38\117\150\144\121\107");
					end
				end
				break;
			end
			if ((2412 >= 356) and (v90 == 6)) then
				if ((2070 > 1171) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\138\188\178\19\174\250\226\188", "\144\217\211\199\127\232\147")]:IsCastable() and (v13:BuffUp(v51.BackdraftBuff))) then
					if (v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true) or (4108 < 3934)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\32\43\36\234\67\11\86\253\111\63\39\208\5\80\20", "\36\152\79\94\72\181\37\98");
					end
				end
				if ((3499 >= 3439) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\254\214\68\54\217\221\85\62\195\221", "\95\183\184\39")]:IsCastable() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\147\54\245\35\85\142\6\151\45\238\43\71\148\13\187\58", "\98\213\95\135\70\52\224")]:IsAvailable() and v13:BuffUp(v51.Backdraft)) then
					if ((876 < 3303) and v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\247\173\202\126\90\251\177\200\99\81\190\162\198\114\20\172\241", "\52\158\195\169\23");
					end
				end
				if ((2922 <= 3562) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\89\179\60\114\138\52\124\153\123\168\55", "\235\26\220\82\20\230\85\27")]:IsCastable() and (v13:BuffDown(v51.Backdraft) or not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\170\160\234\201\112\154\160\239\214", "\20\232\193\137\162")]:IsAvailable())) then
					if ((2619 >= 1322) and v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\208\203\160\235\141\16\99\35\203\192\230\230\131\18\49\112\139", "\17\66\191\165\198\135\236\119");
					end
				end
				v90 = 7;
			end
			if ((4133 >= 2404) and (v90 == 3)) then
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\213\90\240\90\95\123\232\82", "\26\156\55\157\53\51")]:IsCastable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\165\213\27\214\180\81\152\221\50\220\186\69\138\222", "\48\236\184\118\185\216")]:AuraActiveCount() <= 6)) or (1433 == 2686)) then
					if (v50.CastCycle(v51.Immolate, v55, v68, not v15:IsSpellInRange(v51.Immolate), nil, nil, v54.ImmolateMouseover, true) or (4123 == 4457)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\236\176\90\63\195\53\241\184\23\49\192\49\165\236\7", "\84\133\221\55\80\175");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\50\169\196", "\60\221\135\68\198\167")]:IsCastable() and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\220\188\241\141\77\223\200\180\234\134", "\185\142\221\152\227\34")]:IsAvailable()) or (3972 <= 205)) then
					local v117 = 0;
					local v118;
					while true do
						if ((v117 == 0) or (3766 < 1004)) then
							v118 = v15:GUID();
							for v135, v136 in pairs(v55) do
								if ((1784 < 2184) and (v136:GUID() ~= v118) and v17 and v17:Exists() and (v136:GUID() == v17:GUID()) and not v136:IsFacingBlacklisted() and not v136:IsUserCycleBlacklisted()) then
									if (v26(v54.HavocMouseover) or (1649 > 4231)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\80\196\65\245\64\115\244\84\192\86\236\70\115\166\12", "\151\56\165\55\154\35\83");
									end
								end
							end
							break;
						end
					end
				end
				if ((3193 == 3193) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\147\86\8\227\175\77\54\225\181\79\14\235\165\83\0\252", "\142\192\35\101")]:IsCastable() and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\229\96\36\174\232\130\159\25\195\121\34\166\226\156\169\4", "\118\182\21\73\195\135\236\204")]:Count() == 10) or ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\59\41\23\77\11\3\206\7\41\22\75\1\8\237\13\46", "\157\104\92\122\32\100\109")]:Count() > 3) and (v62 < 10)))) then
					if (v26(v51.SummonSoulkeeper) or (3495 > 4306)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\176\179\194\199\50\41\178\184\172\179\195\193\56\34\157\174\177\230\206\197\56\103\220\249", "\203\195\198\175\170\93\71\237");
					end
				end
				v90 = 4;
			end
			if ((4001 > 3798) and (v90 == 4)) then
				if (v31 or (4688 <= 4499)) then
					local v119 = 0;
					local v120;
					while true do
						if ((v119 == 0) or (1567 <= 319)) then
							v120 = v72();
							if (v120 or (4583 == 3761)) then
								return v120;
							end
							break;
						end
					end
				end
				if ((3454 > 1580) and v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\29\94\51\216\94\31\213\32\77\59\199\95\16\240", "\156\78\43\94\181\49\113")]:IsCastable() and v17 and v17:Exists() and (v17:GUID() == v15:GUID())) then
					if (v26(v54.SummonInfernalCursor) or (1607 == 20)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\97\253\201\174\4\77\70\123\230\194\166\25\77\120\126\168\197\172\14\3\40\38", "\25\18\136\164\195\107\35");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\218\44\160\65\125\186\231\177\250\40", "\216\136\77\201\47\18\220\161")]:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID())) or (962 >= 4666)) then
					if (v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate)) or (1896 == 1708)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\237\34\212\55\211\132\18\234\34\200\13\156\131\34\233\107\139\94", "\226\77\140\75\186\104\188");
					end
				end
				v90 = 5;
			end
			if ((3985 >= 1284) and (0 == v90)) then
				if (v31 or (1987 == 545)) then
					local v121 = 0;
					local v122;
					while true do
						if ((v121 == 0) or (4896 < 1261)) then
							v122 = v72();
							if ((23 < 3610) and v122) then
								return v122;
							end
							break;
						end
					end
				end
				if ((v31 and v33) or (3911 < 2578)) then
					local v123 = 0;
					local v124;
					while true do
						if ((v123 == 0) or (4238 < 87)) then
							v124 = v71();
							if ((2538 == 2538) and v124) then
								return v124;
							end
							break;
						end
					end
				end
				if ((4122 == 4122) and v59 and (v60 > v13:GCD()) and (v56 < (5 + v27(v51[LUAOBFUSACTOR_DECRYPT_STR_0("\101\17\240\4\82\0\73\0", "\118\38\99\137\76\51")]:IsAvailable() and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\212\40\3\23\27\46\242", "\64\157\70\101\114\105")]:IsAvailable())))) then
					local v125 = 0;
					local v126;
					while true do
						if ((0 == v125) or (2371 > 2654)) then
							v126 = v73();
							if (v126 or (3466 > 4520)) then
								return v126;
							end
							break;
						end
					end
				end
				v90 = 1;
			end
			if ((v90 == 1) or (951 >= 1027)) then
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\114\169\174\237\31\70\142\174\241\21", "\112\32\200\199\131")]:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v64() > 0)) or (1369 > 2250)) then
					if (v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true) or (937 > 3786)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\81\85\182\252\164\36\19\86\85\170\198\235\35\35\85\28\234", "\66\76\48\60\216\163\203");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\136\135\112\253\80\200\2\179\148\124", "\68\218\230\25\147\63\174")]:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\140\60\82\88\183\191\37\85\104\179\190\62\65\89\181\185\35\92\66", "\214\205\74\51\44")]:IsAvailable())) or (901 > 4218)) then
					if ((4779 > 4047) and v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\232\77\235\242\72\245\74\221\250\126\232\73\162\253\120\255\12\182", "\23\154\44\130\156");
					end
				end
				if ((4050 > 1373) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\35\167\164\160\57\21\55\175\191\171", "\115\113\198\205\206\86")]:IsReady() and v17 and v17:Exists() and (v17:GUID() == v15:GUID()) and (v13:SoulShardsP() == 5)) then
					if (v26(v54.RainofFireCursor, not v15:IsSpellInRange(v51.Conflagrate), true) or (1037 > 4390)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\150\86\247\84\187\88\248\101\130\94\236\95\196\86\241\95\196\1", "\58\228\55\158");
					end
				end
				v90 = 2;
			end
			if ((1407 <= 1919) and (v90 == 5)) then
				if ((2526 >= 1717) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\145\207\198\48\76", "\47\217\174\176\95")]:IsCastable()) then
					local v127 = 0;
					local v128;
					while true do
						if ((v127 == 0) or (3620 <= 2094)) then
							v128 = v15:GUID();
							for v137, v138 in pairs(v55) do
								if (((v138:GUID() ~= v128) and v17 and v17:Exists() and (v138:GUID() == v17:GUID()) and not v138:IsFacingBlacklisted() and not v138:IsUserCycleBlacklisted()) or (1723 >= 2447)) then
									if (v26(v54.HavocMouseover) or (1199 > 3543)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\176\220\96\13\177\20\123\42\189\220\96\7\242\5\44", "\70\216\189\22\98\210\52\24");
									end
								end
							end
							break;
						end
					end
				end
				if ((1617 < 3271) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\249\215\162\137\221\223\211\135\130\222\213\209\165\142\193\223", "\179\186\191\195\231")]:IsReady() and (v15:DebuffRemains(v51.ImmolateDebuff) > v51[LUAOBFUSACTOR_DECRYPT_STR_0("\218\55\25\234\247\58\20\192\252\50\23\234\255\54\10\225", "\132\153\95\120")]:CastTime())) then
					if ((3085 > 1166) and v26(v51.ChannelDemonfire, not v15:IsSpellInRange(v51.ChannelDemonfire), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\186\15\35\249\223\172\142\182\11\32\248\212\166\184\160\11\109\246\213\165\241\227\89", "\192\209\210\110\77\151\186");
					end
				end
				if ((4493 >= 3603) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\201\14\47\230\243\197\244\6", "\164\128\99\66\137\159")]:IsCastable()) then
					if ((2843 <= 2975) and v50.CastCycle(v51.Immolate, v55, v68, not v15:IsSpellInRange(v51.Immolate), nil, nil, v54.ImmolateMouseover, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\132\228\177\12\136\253\187\64\136\230\187\64\216\177", "\222\96\233\137");
					end
				end
				v90 = 6;
			end
			if ((v90 == 2) or (1989 <= 174)) then
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\151\129\209\33\47\143\58\184\157", "\85\212\233\176\78\92\205")]:IsReady() and (v13:SoulShardsP() > (3.5 - (0.1 * v56))) and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\120\89\129\236\69\94\174\235\88\93", "\130\42\56\232")]:IsAvailable()) or (209 > 2153)) then
					if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or (2020 == 1974)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\189\37\236\83\0\232\186\40\247\0\62\229\176\100\187", "\95\138\213\68\131\32");
					end
				end
				if ((v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\9\41\181\66\117\38\49\178\78", "\22\74\72\193\35")]:IsCastable()) or (1347 == 1360)) then
					if (v26(v51.Cataclysm, not v15:IsSpellInRange(v51.Cataclysm)) or (4461 == 3572)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\120\240\89\47\117\253\75\33\57\229\87\41\57\181\8", "\56\76\25\132");
					end
				end
				if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\125\201\170\40\193\91\205\143\35\194\81\207\173\47\221\91", "\175\62\161\203\70")]:IsCastable() and (v15:DebuffRemains(v51.ImmolateDebuff) > v51[LUAOBFUSACTOR_DECRYPT_STR_0("\31\213\194\29\59\57\209\231\22\56\51\211\197\26\39\57", "\85\92\189\163\115")]:CastTime()) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\27\173\55\49\39\171\20\61\36\163\62\62\32\190\53", "\88\73\204\80")]:IsAvailable()) or (2872 == 318)) then
					if ((568 == 568) and v26(v51.ChannelDemonfire, not v15:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\139\17\72\39\223\34\188\20\67\36\213\32\133\25\84\44\154\47\140\21\6\120\136", "\186\78\227\112\38\73");
					end
				end
				v90 = 3;
			end
		end
	end
	local function v76()
		local v91 = 0;
		while true do
			if ((4200 == 4200) and (v91 == 1)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\236\55\36\168\244\240", "\196\145\131\80\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\31\191\3", "\136\126\208\102\104\120")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\76\133\201\68\163\87\46", "\49\24\234\174\35\207\50\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\246\238", "\17\108\146\157\232")];
				v91 = 2;
			end
			if ((v91 == 0) or (4285 < 1369)) then
				v49();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\180\233\61\33\190\253", "\90\77\219\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\11\34", "\26\134\100\65\89\44\103")];
				v91 = 1;
			end
			if ((v91 == 4) or (3520 > 4910)) then
				if ((2842 <= 4353) and (v50.TargetIsValid() or v13:AffectingCombat())) then
					local v129 = 0;
					while true do
						if ((v129 == 0) or (3751 < 1643)) then
							v61 = v10.BossFightRemains(nil, true);
							v62 = v61;
							v129 = 1;
						end
						if ((v129 == 1) or (4911 == 3534)) then
							if ((3001 > 16) and (v62 == 11111)) then
								v62 = v10.FightRemains(Enemies8ySplash, false);
							end
							break;
						end
					end
				end
				if ((2875 <= 3255) and v50.TargetIsValid()) then
					local v130 = 0;
					local v131;
					while true do
						if ((368 < 4254) and (v130 == 8)) then
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\163\38\190\68\196\201\210\140\58", "\189\224\78\223\43\183\139")]:IsReady() and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\29\243\159\26\226\33\242\142\3\200\58", "\161\78\156\234\118")]:IsAvailable() and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\138\182\205\210\162\164\218\211\161\163\193\217\134\173\195\253\182\190\219", "\188\199\215\169")]:IsAvailable()) or not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\222\8\92\112\236\238\8\89\111", "\136\156\105\63\27")]:IsAvailable())) or (4841 <= 2203)) then
								if ((4661 > 616) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\24\132\120\59\8\179\123\59\23\152\57\57\26\133\119\116\79\216", "\84\123\236\25");
								end
							end
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\211\131\171\24\191\151\255\135\190", "\213\144\235\202\119\204")]:IsReady() and (v62 < 5.5) and (v62 > (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\0\16\223\37\59\1\66\47\12", "\45\67\120\190\74\72\67")]:CastTime() + v51[LUAOBFUSACTOR_DECRYPT_STR_0("\3\42\236\170\234\170\225\229\52", "\137\64\66\141\197\153\232\142")]:TravelTime() + 0.5))) or (1943 == 2712)) then
								if ((4219 >= 39) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\0\216\35\169\155\60\210\45\170\156\67\221\35\175\134\67\132\116", "\232\99\176\66\198");
								end
							end
							if ((3967 > 2289) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\207\46\38\0\119\140\254\62\237\53\45", "\76\140\65\72\102\27\237\153")]:IsCastable() and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\105\213\24\212\219\0\185\88\219\2\215", "\222\42\186\118\178\183\97")]:Charges() > (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\126\227\74\140\81\237\67\152\92\248\65", "\234\61\140\36")]:MaxCharges() - 1)) or (v62 < (v13:GCD() + 0.5)))) then
								if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or (851 > 2987)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\34\210\180\116\3\32\218\168\115\27\36\157\183\115\6\47\157\238\42", "\111\65\189\218\18");
								end
							end
							v130 = 9;
						end
						if ((4893 >= 135) and (7 == v130)) then
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\54\170\254\22\53\16\174\219\29\54\26\172\249\17\41\16", "\91\117\194\159\120")]:IsCastable() and not (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\62\20\63\26\58\253\45\25\56\51\26\48\227\55", "\68\122\125\94\120\85\145")]:IsAvailable() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\54\10\206\74\201\203\181\17\56\202\77\220\203\175\20\8\198\81\198", "\218\119\124\175\62\168\185")]:IsAvailable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\135\229\90\202\177\255\105\215\173\245\91", "\164\197\144\40")]:IsAvailable() or v51[LUAOBFUSACTOR_DECRYPT_STR_0("\160\248\171\132\206\159\141\243\171\153\211\183\151\245", "\214\227\144\202\235\189")]:IsAvailable())) and (v15:DebuffRemains(v51.ImmolateDebuff) > v51[LUAOBFUSACTOR_DECRYPT_STR_0("\206\173\134\117\30\182\95\24\232\168\136\117\22\186\65\57", "\92\141\197\231\27\112\211\51")]:CastTime())) or (3084 > 3214)) then
								if (v26(v51.ChannelDemonfire, not v15:IsInRange(40), true) or (3426 < 2647)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\229\247\139\173\223\227\243\181\167\212\235\240\132\165\216\244\250\202\160\221\227\254\156\166\145\181\167", "\177\134\159\234\195");
								end
							end
							if ((v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\153\226\50\165\199\174\226\48\174\200\177\217\54\166\221", "\169\221\139\95\192")]:IsCastable()) or (1576 == 4375)) then
								if (v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift)) or (2920 < 2592)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\218\130\114\58\44\53\215\132\113\62\46\25\204\130\121\43\98\37\210\142\126\41\39\102\138\219", "\70\190\235\31\95\66");
								end
							end
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\153\234\27\233\246\152\237\22\242", "\133\218\130\122\134")]:IsReady() and (v13:SoulShardsP() >= 3.5)) or (1110 >= 2819)) then
								if ((1824 <= 2843) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\63\247\226\203\207\156\58\51\243\247\132\209\162\49\50\191\183\150", "\88\92\159\131\164\188\195");
								end
							end
							v130 = 8;
						end
						if ((3062 == 3062) and (v130 == 3)) then
							if ((716 <= 4334) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\169\23\24\168\210\143\19\61\163\209\133\17\31\175\206\143", "\188\234\127\121\198")]:IsReady() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\10\51\20\138\54\53\55\134\53\61\29\133\49\32\22", "\227\88\82\115")]:IsAvailable()) then
								if ((1001 < 3034) and v26(v51.ChannelDemonfire, not v15:IsInRange(40), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\64\23\187\169\12\118\79\32\190\162\15\124\77\25\179\181\7\51\78\30\179\169\66\36", "\19\35\127\218\199\98");
								end
							end
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\47\244\31\238\58\242\24\231", "\130\124\155\106")]:IsCastable() and (v13:SoulShardsP() <= 3.5) and ((v15:DebuffRemains(v51.RoaringBlazeDebuff) > (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\230\196\227\163\133\255\110\186", "\223\181\171\150\207\195\150\28")]:CastTime() + v51[LUAOBFUSACTOR_DECRYPT_STR_0("\127\53\246\162\47\69\40\230", "\105\44\90\131\206")]:TravelTime())) or (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\205\239\179\171\1\48\248\194\190\184\18\59", "\94\159\128\210\217\104")]:IsAvailable() and v13:BuffUp(v51.BackdraftBuff)))) or (977 > 1857)) then
								if (v26(v51.SoulFire, not v15:IsSpellInRange(v51.SoulFire), true) or (868 > 897)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\67\246\19\179\96\121\240\104\85\185\11\190\86\113\185\34", "\26\48\153\102\223\63\31\153");
								end
							end
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\43\77\224\252\14\65\249\246", "\147\98\32\141")]:IsCastable() and ((v15:DebuffRefreshable(v51.ImmolateDebuff) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\49\77\247\207\20\88\74\20\96\236\199\4\67\88\12\74\236\196", "\43\120\35\131\170\102\54")]:IsAvailable()) or (v15:DebuffRemains(v51.ImmolateDebuff) < 3)) and (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\119\7\147\183\166\188\157\71\11", "\228\52\102\231\214\197\208")]:IsAvailable() or (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\61\225\97\203\233\135\0\197\19", "\182\126\128\21\170\138\235\121")]:CooldownRemains() > v15:DebuffRemains(v51.ImmolateDebuff))) and (not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\184\213\32\234\160\26\34\3", "\102\235\186\85\134\230\115\80")]:IsAvailable() or ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\100\3\43\83\84\221\48\82", "\66\55\108\94\63\18\180")]:CooldownRemains() + v51[LUAOBFUSACTOR_DECRYPT_STR_0("\39\130\144\59\1\80\6\136", "\57\116\237\229\87\71")]:CastTime()) > v15:DebuffRemains(v51.ImmolateDebuff)))) or (1115 == 4717)) then
								if ((2740 < 4107) and v26(v54.ImmolatePetAttack, not v15:IsSpellInRange(v51.Immolate), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\163\188\224\232\123\239\83\175\241\224\230\126\224\7\251\225", "\39\202\209\141\135\23\142");
								end
							end
							v130 = 4;
						end
						if ((284 < 700) and (2 == v130)) then
							if ((386 >= 137) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\5\36\43\185\237\39\44\55\190\245\35", "\129\70\75\69\223")]:IsReady() and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\116\196\242\251\117\225\65\233\255\232\102\234", "\143\38\171\147\137\28")]:IsAvailable() and (v15:DebuffRemains(v51.RoaringBlazeDebuff) < 1.5)) or (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\243\141\183\245\15\226\211\194\131\173\246", "\180\176\226\217\147\99\131")]:Charges() == v51[LUAOBFUSACTOR_DECRYPT_STR_0("\240\182\33\1\223\184\40\21\210\173\42", "\103\179\217\79")]:MaxCharges()))) then
								if ((923 == 923) and v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\73\184\18\211\77\141\164\88\182\8\208\1\129\162\67\185\92\135", "\195\42\215\124\181\33\236");
								end
							end
							if ((v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\41\80\58\59\43\235\4\86\57\63\41\202\4\95\35", "\152\109\57\87\94\69")]:IsCastable() and (v13:SoulShardsP() < 4.7) and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\221\222\7\166\176\193\93\167\247\214\6\145\183\212\64", "\200\153\183\106\195\222\178\52")]:Charges() > 2) or (v62 < v51[LUAOBFUSACTOR_DECRYPT_STR_0("\22\234\133\56\71\73\59\236\134\60\69\104\59\229\156", "\58\82\131\232\93\41")]:Cooldown()))) or (4173 == 359)) then
								if ((1722 == 1722) and v26(v51.DimensionalRift, not v15:IsSpellInRange(v51.DimensionalRift))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\135\94\221\16\83\44\138\88\222\20\81\0\145\94\214\1\29\50\130\94\222\85\9", "\95\227\55\176\117\61");
								end
							end
							if ((v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\59\127\55\74\168\20\103\48\70", "\203\120\30\67\43")]:IsReady()) or (3994 <= 3820)) then
								if ((1488 < 1641) and v26(v51.Cataclysm, not v15:IsInRange(40))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\242\36\89\238\218\253\60\94\226\153\252\36\68\225\153\167", "\185\145\69\45\143");
								end
							end
							v130 = 3;
						end
						if ((433 <= 2235) and (v130 == 4)) then
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\215\50\31\5\49", "\152\159\83\105\106\82")]:IsCastable() and not v48 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\162\212\72\218\200\74\142\197", "\60\225\166\49\146\169")]:IsAvailable() and (v13:BuffUp(v51.RitualofRuinBuff) or ((v64() > 0) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\13\11\61\36\21\8\14\13\39\47\18", "\103\79\126\79\74\97")]:IsAvailable()) or ((v13:BuffUp(v51.RitualofRuinBuff) or (v64() > 0)) and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\152\106\193\125\74\21\155\108\219\118\77", "\122\218\31\179\19\62")]:IsAvailable()))) or (1838 > 2471)) then
								if ((2444 < 3313) and v26(v51.Havoc, not v15:IsSpellInRange(v51.Havoc))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\187\215\219\206\202\225\13\160\194\132\129\196\160\76\189\150\156\144", "\37\211\182\173\161\169\193");
								end
							end
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\212\50\76\214\59\89\182\251\46", "\217\151\90\45\185\72\27")]:IsReady() and ((v64() > 0) or (v65() > 0) or (v13:SoulShardsP() >= 4))) or (3685 <= 185)) then
								if ((738 <= 1959) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\192\116\230\29\69\252\126\232\30\66\131\113\230\27\88\131\45\181", "\54\163\28\135\114");
								end
							end
							if ((v31 and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\27\206\80\143\65\113\1\213\91\135\92\113\41\215", "\31\72\187\61\226\46")]:IsCastable() and v17 and v17:Exists() and (v17:GUID() == v15:GUID())) or (1317 == 3093)) then
								if (v26(v54.SummonInfernalCursor) or (2611 >= 4435)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\208\19\78\223\72\112\27\202\8\69\215\85\112\37\207\70\78\211\78\112\100\146\82", "\68\163\102\35\178\39\30");
								end
							end
							v130 = 5;
						end
						if ((9 == v130) or (117 > 4925)) then
							if ((107 <= 4905) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\106\69\24\60\5\89\189\66\95\30", "\207\35\43\123\85\107\60")]:IsCastable()) then
								if (v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true) or (1004 > 4035)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\121\164\163\227\119\117\184\161\254\124\48\167\161\227\119\48\255\240", "\25\16\202\192\138");
								end
							end
							break;
						end
						if ((6 == v130) or (2802 < 369)) then
							if ((1497 <= 2561) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\174\56\249\43\78\195\130\60\236", "\129\237\80\152\68\61")]:IsReady() and (v13:BuffRemains(v51.RainofChaosBuff) > v51[LUAOBFUSACTOR_DECRYPT_STR_0("\114\160\5\252\15\53\87\93\188", "\56\49\200\100\147\124\119")]:CastTime())) then
								if (v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true) or (816 > 1712)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\207\54\190\255\223\1\189\255\192\42\255\253\205\55\177\176\159\110", "\144\172\94\223");
								end
							end
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\7\7\163\72\55\45\173\75\48", "\39\68\111\194")]:IsReady() and v13:BuffUp(v51.Backdraft) and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\243\180\230\195\112\180\215\178\238\200\119", "\215\182\198\135\167\25")]:IsAvailable() and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\160\72\238\70\136\90\249\71\139\93\226\77\172\83\224\105\156\64\248", "\40\237\41\138")]:IsAvailable()) or (2733 == 2971)) then
								if ((2599 < 4050) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\196\124\251\247\89\248\118\245\244\94\135\121\251\241\68\135\39\168", "\42\167\20\154\152");
								end
							end
							if ((2034 == 2034) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\105\246\163\77\98\3\69\242\182", "\65\42\158\194\34\17")]:IsReady() and (v13:BuffUp(v51.MadnessCBBuff))) then
								if ((3040 < 4528) and v26(v51.ChaosBolt, not v15:IsSpellInRange(v51.ChaosBolt), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\25\47\83\3\62\210\25\225\22\51\18\15\33\232\26\248\31\103\1\90", "\142\122\71\50\108\77\141\123");
								end
							end
							v130 = 7;
						end
						if ((v130 == 0) or (2092 <= 2053)) then
							if ((2120 < 4799) and not v13:AffectingCombat() and v29) then
								local v139 = 0;
								local v140;
								while true do
									if ((v139 == 0) or (4538 <= 389)) then
										v140 = v69();
										if ((270 <= 1590) and v140) then
											return v140;
										end
										break;
									end
								end
							end
							if ((1625 > 1265) and (((v56 > 1) and (v56 <= (2 + v27(not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\98\205\18\232\61\166\68", "\200\43\163\116\141\79")]:IsAvailable() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\146\55\57\141\181\231\240\176\48\41\139\181\213\249\181\23\44\138\162", "\131\223\86\93\227\208\148")]:IsAvailable() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\194\86\190\179\19\135\230\72\183\191\19\166", "\213\131\37\214\214\125")]:IsAvailable())))) or v58)) then
								local v141 = 0;
								local v142;
								while true do
									if ((v141 == 0) or (51 >= 920)) then
										v142 = v74();
										if (v142 or (2968 <= 1998)) then
											return v142;
										end
										break;
									end
								end
							end
							if ((v56 >= 3) or (3085 <= 2742)) then
								local v143 = 0;
								local v144;
								while true do
									if ((v143 == 0) or (376 >= 2083)) then
										v144 = v75();
										if ((4191 > 1232) and v144) then
											return v144;
										end
										break;
									end
								end
							end
							v130 = 1;
						end
						if ((5 == v130) or (1505 > 4873)) then
							if ((3880 < 4534) and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\157\120\219\201\13\176\143\53\187\125\213\201\5\188\145\20", "\113\222\16\186\167\99\213\227")]:IsCastable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\28\27\242\248", "\150\78\110\155")]:TalentRank() > 1) and not (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\161\204\38\227\171\18\182\67\160\200\37\228\182\13", "\32\229\165\71\129\196\126\223")]:IsAvailable() and v51[LUAOBFUSACTOR_DECRYPT_STR_0("\226\159\197\149\128\199\204\143\224\132\146\193\209\156\199\149\136\218\205", "\181\163\233\164\225\225")]:IsAvailable() and (v51[LUAOBFUSACTOR_DECRYPT_STR_0("\114\158\44\121\68\132\31\100\88\142\45", "\23\48\235\94")]:IsAvailable() or v51[LUAOBFUSACTOR_DECRYPT_STR_0("\95\210\217\82\68\26\220\127\219\202\83\86\39\215", "\178\28\186\184\61\55\83")]:IsAvailable())) and (v15:DebuffRemains(v51.ImmolateDebuff) > v51[LUAOBFUSACTOR_DECRYPT_STR_0("\231\197\70\50\252\11\249\224\200\74\51\252\8\252\214\200", "\149\164\173\39\92\146\110")]:CastTime())) then
								if (v26(v51.ChannelDemonfire, not v15:IsInRange(40), true) or (2368 >= 2541)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\240\47\17\17\20\30\255\24\20\26\23\20\253\33\25\13\31\91\254\38\25\17\90\74\165", "\123\147\71\112\127\122");
								end
							end
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\239\194\140\119\74\205\202\144\112\82\201", "\38\172\173\226\17")]:IsCastable() and v13:BuffDown(v51.Backdraft) and (v13:SoulShardsP() >= 1.5) and not v51[LUAOBFUSACTOR_DECRYPT_STR_0("\127\30\45\253\68\31\43\205\65\16\54\234", "\143\45\113\76")]:IsAvailable()) or (4733 <= 4103)) then
								if (v26(v51.Conflagrate, not v15:IsSpellInRange(v51.Conflagrate)) or (1207 == 4273)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\187\183\18\58\180\185\27\46\185\172\25\124\181\185\21\50\248\234\68", "\92\216\216\124");
								end
							end
							if ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\114\60\175\73\243\94\32\173\84\248", "\157\59\82\204\32")]:IsCastable() and v13:BuffUp(v51.BurntoAshesBuff) and ((v51[LUAOBFUSACTOR_DECRYPT_STR_0("\17\48\224\243\231\239\193\176\44\59", "\209\88\94\131\154\137\138\179")]:CastTime() + v51[LUAOBFUSACTOR_DECRYPT_STR_0("\11\169\197\115\13\1\62\46\60", "\66\72\193\164\28\126\67\81")]:CastTime()) < v13:BuffRemains(v51.MadnessCBBuff))) or (2005 == 2529)) then
								if ((986 < 3589) and v26(v51.Incinerate, not v15:IsSpellInRange(v51.Incinerate), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\238\34\171\81\40\115\245\45\188\93\102\119\232\41\232\10\127", "\22\135\76\200\56\70");
								end
							end
							v130 = 6;
						end
						if ((v130 == 1) or (3119 == 430)) then
							v131 = v71();
							if ((2409 <= 3219) and v131) then
								return v131;
							end
							if (v31 or (898 > 2782)) then
								local v145 = 0;
								local v146;
								while true do
									if ((0 == v145) or (2250 <= 1764)) then
										v146 = v72();
										if ((693 == 693) and v146) then
											return v146;
										end
										break;
									end
								end
							end
							v130 = 2;
						end
					end
				end
				break;
			end
			if ((v91 == 3) or (2529 == 438)) then
				if ((1751 > 1411) and v30) then
					v56 = #Enemies8ySplash;
				else
					v56 = 1;
				end
				v59, v60 = v63(v55);
				v91 = 4;
			end
			if ((4182 == 4182) and (v91 == 2)) then
				v55 = v13:GetEnemiesInRange(40);
				Enemies8ySplash = v15:GetEnemiesInSplashRange(12);
				v91 = 3;
			end
		end
	end
	local function v77()
		local v92 = 0;
		while true do
			if ((v92 == 0) or (4666 <= 611)) then
				v51[LUAOBFUSACTOR_DECRYPT_STR_0("\212\198\160\237\165\245\233\206\137\231\171\225\251\205", "\148\157\171\205\130\201")]:RegisterAuraTracking();
				v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\7\209\103\61\195\227\32\192\125\38\223\182\20\213\102\37\222\245\40\148\102\38\197\247\55\221\123\39\145\244\58\148\81\57\216\245\109\148\71\60\193\230\44\198\96\44\213\182\33\205\52\14\222\252\42\198\117", "\150\67\180\20\73\177"));
				break;
			end
		end
	end
	v20.SetAPL(267, v76, v77);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\168\8\19\85\178\47\27\95\129\23\25\70\178\60\31\94\153\10\15\78\153\17\21\67\195\20\15\76", "\45\237\120\122")]();

