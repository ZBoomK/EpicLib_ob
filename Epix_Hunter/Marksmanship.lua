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
		if ((117 <= 2892) and (v5 == 1)) then
			return v6(...);
		end
		if ((v5 == 0) or (453 > 4662)) then
			v6 = v0[v4];
			if ((1320 > 595) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\147\210\16\197\198\201\26\203\186\213\21\194\206\218\43\245\179\206\14\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
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
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\150\67\197\180\51\99\32\196\183\90", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\96\86\5\40", "\69\41\34\96")];
	local v21 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\158\202\217\14", "\75\220\163\183\106\98")];
	local v22 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local v23 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\234\51\2\201\240", "\202\171\92\71\134\190")];
	local v24 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\10\229\63\167\7", "\232\73\161\76")];
	local v25 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\152\216\81\73", "\126\219\185\34\61")];
	local v26 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\60\220\91\97\109", "\135\108\174\62\18\30\23\147")];
	local v27 = GetTime;
	local v28 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\163\229\60\73\253\181", "\199\235\144\82\61\152")];
	local v29 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\36\25\180\38\8\24\170", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\66\117\6\160\17\201\81", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\59\45", "\156\168\78\64\224\212\121")];
	local v30 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\36\225\168\195\8\224\182", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\62\90\42\60\81\246\83", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\203\225\80", "\60\180\164\142")];
	local v31 = false;
	local v32 = false;
	local v33 = false;
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
		local v93 = 0;
		while true do
			if ((2 == v93) or (3199 < 590)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\247\213\214\51\192\181\109", "\30\222\146\161\162\90\174\210")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\64\100\15\247\92\101\26\241\122\120\24\224\93\120\5\233\74", "\106\133\46\16")] or 0;
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\37\103\232\83\78\95\51", "\32\56\64\19\156\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\111\219\224\102\95\230", "\224\58\168\133\54\58\146")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\106\83\95\233\124\136\128\24", "\107\57\54\43\157\21\230\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\232\158\28\248\182\210\255\222\159\34\249\182\200", "\175\187\235\113\149\217\188")] or 0;
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\170\149\88\234\119\127\47", "\24\92\207\225\44\131\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\192\189\127\15\120\78\223\140\94\26\109", "\29\43\179\216\44\123")];
				v93 = 3;
			end
			if ((0 == v93) or (4793 < 30)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\91\17\61\46\227\21\75", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\250\222\246\185\234\210\197\180\250", "\164\216\137\187")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\225\227\37\166\175\240\12\193", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\29\135\238\175\57\2\139\200\173\8\1\150\207\165\54", "\202\88\110\226\166")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\10\150\227\195\205\8\145", "\170\163\111\226\151")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\53\179\52\71\57\46\33\63\166\49\65\57\7\16\61\183", "\73\113\80\210\88\46\87")] or 0;
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\178\41\217\6\238\143\43\222", "\135\225\76\173\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\232\185\188\165\179\160\42\226\172\185\163\179\143\42", "\199\122\141\216\208\204\221")] or 0;
				v93 = 1;
			end
			if ((v93 == 3) or (1696 <= 1059)) then
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\220\52\88\180\215\39\95", "\44\221\185\64")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\244\77\109\118\23\238\94\90", "\19\97\135\40\63")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\157\89\39\47\38\63\169\79", "\81\206\60\83\91\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\123\184\213\95\42\205\73\148\75\191", "\196\46\203\176\18\79\163\45")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\39\106\10\45\245\232\171", "\143\216\66\30\126\68\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\205\3\207\245\166\195\201\154", "\129\202\168\109\171\165\195\183")] or 0;
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\93\35\204\215\26\225\49", "\134\66\56\87\184\190\116")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\34\12\158\1\227\40\57\61\35\8\175\16\228\47", "\85\92\81\105\219\121\139\65")];
				v93 = 4;
			end
			if ((2343 == 2343) and (v93 == 4)) then
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\182\68\81\117\209\250\160", "\191\157\211\48\37\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\7\252\21\54\222\13\245\8\51\208\17\220\44", "\90\191\127\148\124")] or 0;
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\130\58\3\113\137\41\4", "\119\24\231\78")][LUAOBFUSACTOR_DECRYPT_STR_0("\183\62\160\126\206\65\31\147", "\113\226\77\197\42\188\32")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\9\19\224\161\51\24\243\166", "\213\90\118\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\110\61\177\96\66\87\34\177\79", "\45\59\78\212\54")];
				break;
			end
			if ((v93 == 1) or (1043 > 3591)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\216\4\228\113\248\170\206", "\150\205\189\112\144\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\16\151\186\100\1\137\29\4\45\151\171\67\10\141", "\112\69\228\223\44\100\232\113")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\26\19\199\191\114\129\199", "\230\180\127\103\179\214\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\164\0\94\74\240\73\243\152\10\81\67\204\113", "\128\236\101\63\38\132\33")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\159\172\5\80\191\229\200\191", "\175\204\201\113\36\214\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\110\194\33\217\22\85\217\37\200\51\78\216\61\239\16\82\194", "\100\39\172\85\188")] or 0;
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\125\173\148\58\163\127\170", "\83\205\24\217\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\207\203\217\56\244\215\216\45\242\234\195\49\255\242\197\52\242\192\193\52\245\209", "\93\134\165\173")] or 0;
				v93 = 2;
			end
		end
	end
	local v55 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\56\67\141\159\131\60", "\144\112\54\227\235\230\78\205")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\41\29\247\195\86\178\38\28\244\217\75", "\59\211\72\111\156\176")];
	local v56 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\102\146\237\57\75\149", "\77\46\231\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\151\85\164\75\169\89\183\78\169\92\191\80", "\32\218\52\214")];
	local v57 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\102\2\63\188\244\162", "\58\46\119\81\200\145\208\37")][LUAOBFUSACTOR_DECRYPT_STR_0("\6\141\34\167\186\176\55\37\159\56\165\185", "\86\75\236\80\204\201\221")];
	local v58 = {v55[LUAOBFUSACTOR_DECRYPT_STR_0("\65\84\122\136\241\133\66\68\99", "\235\18\33\23\229\158")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\99\175\204\182\95\180\241\190\68\232", "\219\48\218\161")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\215\100\113\68\212\65\208\225\101\47", "\128\132\17\28\41\187\47")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\50\39\11\55\82\15\2\3\46\9", "\61\97\82\102\90")],v55[LUAOBFUSACTOR_DECRYPT_STR_0("\159\59\166\70\200\89\46\12\184\123", "\105\204\78\203\43\167\55\126")]};
	local v59 = {};
	local v60 = v13:GetEquipment();
	local v61 = (v60[13] and v20(v60[13])) or v20(0);
	local v62 = (v60[14] and v20(v60[14])) or v20(0);
	local v63 = {[LUAOBFUSACTOR_DECRYPT_STR_0("\137\171\48\10\48\5\212\69", "\49\197\202\67\126\115\100\167")]=0,[LUAOBFUSACTOR_DECRYPT_STR_0("\20\84\202\39\148", "\62\87\59\191\73\224\54")]=0};
	local v64;
	local v65 = 11111;
	local v66 = 11111;
	local v67;
	local v68;
	local v69;
	local v70;
	local v71 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\196\13\247\196\232\12\233", "\169\135\98\154")][LUAOBFUSACTOR_DECRYPT_STR_0("\238\97\33\70\228\60\198\206", "\168\171\23\68\52\157\83")];
	local v72 = (v14:HealthPercentage() > 70) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\215\112\231\168\35\56\139\213\120\248", "\231\148\17\149\205\69\77")]:IsAvailable();
	local v73 = {{v55[LUAOBFUSACTOR_DECRYPT_STR_0("\169\169\211\242\90\246\132\166\211\242\88\241", "\159\224\199\167\155\55")],LUAOBFUSACTOR_DECRYPT_STR_0("\212\242\47\198\183\218\50\198\254\254\53\214\246\231\53\221\249\179\116\251\249\231\57\192\229\230\44\198\190", "\178\151\147\92"),function()
		return true;
	end}};
	v10:RegisterForEvent(function()
		local v94 = 0;
		while true do
			if ((v94 == 0) or (2890 >= 4079)) then
				v60 = v13:GetEquipment();
				v61 = (v60[13] and v20(v60[13])) or v20(0);
				v94 = 1;
			end
			if ((4474 <= 4770) and (v94 == 1)) then
				v62 = (v60[14] and v20(v60[14])) or v20(0);
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\188\209\109\11\55\126\69\169\204\121\27\34\97\95\162\201\115\17\58\109\84\171\216\104", "\26\236\157\44\82\114\44"));
	v10:RegisterForEvent(function()
		local v95 = 0;
		while true do
			if ((v95 == 1) or (4942 == 3903)) then
				v66 = 11111;
				break;
			end
			if ((v95 == 0) or (248 > 4845)) then
				v63 = {[LUAOBFUSACTOR_DECRYPT_STR_0("\6\47\198\79\9\47\198\79", "\59\74\78\181")]=0,[LUAOBFUSACTOR_DECRYPT_STR_0("\6\222\79\84\167", "\211\69\177\58\58")]=0};
				v65 = 11111;
				v95 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\135\201\88\204\204\249\136\215\92\210\204\229\136\192\87\212\203\231\146\193", "\171\215\133\25\149\137"));
	v10:RegisterForEvent(function()
		local v96 = 0;
		while true do
			if ((1569 == 1569) and (1 == v96)) then
				v55[LUAOBFUSACTOR_DECRYPT_STR_0("\224\75\63\211\1\242\74\61\194", "\101\161\34\82\182")]:RegisterInFlight();
				break;
			end
			if ((0 == v96) or (4927 <= 3221)) then
				v55[LUAOBFUSACTOR_DECRYPT_STR_0("\210\205\32\234\234\62\232\113\245\193\60\253", "\34\129\168\82\154\143\80\156")]:RegisterInFlight();
				v55[LUAOBFUSACTOR_DECRYPT_STR_0("\182\166\54\10\76\87\186\141\189\39", "\233\229\210\83\107\40\46")]:RegisterInFlight();
				v96 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\196\40\120\204\245\199\166\17\219\61\124\210\247\221\171\0\215\57\120\220", "\78\136\109\57\158\187\130\226"));
	v55[LUAOBFUSACTOR_DECRYPT_STR_0("\13\58\235\225\59\49\237\194\42\54\247\246", "\145\94\95\153")]:RegisterInFlight();
	v55[LUAOBFUSACTOR_DECRYPT_STR_0("\206\217\17\212\74\174\206\197\27\193", "\215\157\173\116\181\46")]:RegisterInFlight();
	v55[LUAOBFUSACTOR_DECRYPT_STR_0("\20\189\134\247\222\6\188\132\230", "\186\85\212\235\146")]:RegisterInFlight();
	local function v74()
		return (v13:BuffUp(v55.TrickShotsBuff) and not v13:IsCasting(v55.AimedShot) and not v13:IsChanneling(v55.RapidFire)) or v13:BuffUp(v55.VolleyBuff);
	end
	local function v75()
		local v97 = 0;
		while true do
			if ((v97 == 0) or (1780 > 2787)) then
				if ((((v63[LUAOBFUSACTOR_DECRYPT_STR_0("\225\142\3\240\45", "\56\162\225\118\158\89\142")] == 0) or (v63[LUAOBFUSACTOR_DECRYPT_STR_0("\127\10\213\161\54", "\184\60\101\160\207\66")] == 1)) and v13:IsCasting(v55.SteadyShot) and (v63[LUAOBFUSACTOR_DECRYPT_STR_0("\29\131\111\168\18\131\111\168", "\220\81\226\28")] < (v27() - v55[LUAOBFUSACTOR_DECRYPT_STR_0("\32\193\135\250\238\222\32\221\141\239", "\167\115\181\226\155\138")]:CastTime()))) or (3937 <= 1230)) then
					local v130 = 0;
					while true do
						if ((v130 == 0) or (2637 < 1706)) then
							v63[LUAOBFUSACTOR_DECRYPT_STR_0("\206\35\244\72\88\112\213\246", "\166\130\66\135\60\27\17")] = v27();
							v63[LUAOBFUSACTOR_DECRYPT_STR_0("\103\69\219\123\36", "\80\36\42\174\21")] = v63[LUAOBFUSACTOR_DECRYPT_STR_0("\109\31\34\116\90", "\26\46\112\87")] + 1;
							break;
						end
					end
				end
				if (not (v13:IsCasting(v55.SteadyShot) or v13:PrevGCDP(1, v55.SteadyShot)) or (2669 <= 2409)) then
					v63[LUAOBFUSACTOR_DECRYPT_STR_0("\154\44\190\122\171", "\212\217\67\203\20\223\223\37")] = 0;
				end
				v97 = 1;
			end
			if ((v97 == 1) or (1401 > 4696)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\137\153\173\211\190\148\142\221\185\152\187\240\175\139\174", "\178\218\237\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\154\180\245\196\151\165\246\220\191\176\226\255\184\133\234\209\175\176\244\228\191\184\227", "\176\214\213\134")] > v63[LUAOBFUSACTOR_DECRYPT_STR_0("\216\172\165\192\139\87\74\224", "\57\148\205\214\180\200\54")]) or (3280 < 1321)) then
					v63[LUAOBFUSACTOR_DECRYPT_STR_0("\49\242\32\58\98", "\22\114\157\85\84")] = 0;
				end
				break;
			end
		end
	end
	local function v76(v98)
		return (v98:DebuffRemains(v55.SerpentStingDebuff));
	end
	local function v77(v99)
		return v99:DebuffRemains(v55.SerpentStingDebuff) + (v29(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\247\206\1\212\88\248\188\247\223\26\202\90", "\200\164\171\115\164\61\150")]:InFlight()) * 99);
	end
	local function v78(v100)
		return (v100:DebuffStack(v55.LatentPoisonDebuff));
	end
	local function v79(v101)
		return v101:DebuffRefreshable(v55.SerpentStingDebuff) and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\141\241\17\85\134\176\224\16\81\130\178\255\6\87\144\138\230\10\70\136\187\230\26", "\227\222\148\99\37")]:IsAvailable();
	end
	local function v80(v102)
		return v102:DebuffRefreshable(v55.SerpentStingDebuff) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\27\75\86\228\248\32\112\91\226\252", "\153\83\50\50\150")]:IsAvailable() and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\110\115\97\12\118\165\89\78\98\114\16\120\174\95\78\66\97\21\112\160\72\79\111", "\45\61\22\19\124\19\203")]:IsAvailable();
	end
	local function v81(v103)
		return v103:DebuffRefreshable(v55.SerpentStingDebuff) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\241\29\4\230\13\126\144\207\24\8\246\22\121\182\207", "\217\161\114\109\149\98\16")]:IsAvailable() and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\33\37\42\108\185\122\6\51\44\125\176\127\23\50\43\72\174\125\17\43\61\110\165", "\20\114\64\88\28\220")]:IsAvailable();
	end
	local function v82(v104)
		return v55[LUAOBFUSACTOR_DECRYPT_STR_0("\2\4\192\164\253\222\169\34\21\211\184\243\213\175\34\53\192\189\251\219\184\35\24", "\221\81\97\178\212\152\176")]:IsAvailable() and (v13:BuffDown(v55.PreciseShotsBuff) or ((v13:BuffUp(v55.TrueshotBuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\236\238\16\254\30\254\239\18\239", "\122\173\135\125\155")]:FullRechargeTime() < (v13:GCD() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\165\200\13\188\59\2\192\139\213", "\168\228\161\96\217\95\81")]:CastTime()))) and (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\248\217\39\81\46\82\201\208\29\84\32\67", "\55\187\177\78\60\79")]:IsAvailable() or (v69 < 2))) or ((v13:BuffRemains(v55.TrickShotsBuff) > v55[LUAOBFUSACTOR_DECRYPT_STR_0("\12\199\82\238\66\252\136\34\218", "\224\77\174\63\139\38\175")]:ExecuteTime()) and (v69 > 1)));
	end
	local function v83(v105)
		return v13:BuffDown(v55.PreciseShotsBuff) or ((v13:BuffUp(v55.TrueshotBuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\165\72\85\43\128\114\80\33\144", "\78\228\33\56")]:FullRechargeTime() < (v13:GCD() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\239\119\191\6\129\253\118\189\23", "\229\174\30\210\99")]:CastTime()))) and (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\56\229\143\92\236\56\43\26\222\142\94\249", "\89\123\141\230\49\141\93")]:IsAvailable() or (v69 < 2))) or ((v13:BuffRemains(v55.TrickShotsBuff) > v55[LUAOBFUSACTOR_DECRYPT_STR_0("\210\120\251\9\20\121\251\126\226", "\42\147\17\150\108\112")]:ExecuteTime()) and (v69 > 1));
	end
	local function v84(v106)
		return v55[LUAOBFUSACTOR_DECRYPT_STR_0("\60\163\63\111\226\230\27\181\57\126\235\227\10\180\62\75\245\225\12\173\40\109\254", "\136\111\198\77\31\135")]:IsAvailable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55[LUAOBFUSACTOR_DECRYPT_STR_0("\35\0\170\83\185\215\31\166\22", "\201\98\105\199\54\221\132\119")]:ExecuteTime()) and (v13:BuffDown(v55.PreciseShotsBuff) or v13:BuffUp(v55.TrueshotBuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\152\5\142\36\6\6\164\182\24", "\204\217\108\227\65\98\85")]:FullRechargeTime() < (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\127\202\248\224\40\243\86\204\225", "\160\62\163\149\133\76")]:CastTime() + v13:GCD())));
	end
	local function v85(v107)
		return (v13:BuffRemains(v55.TrickShotsBuff) >= v55[LUAOBFUSACTOR_DECRYPT_STR_0("\247\169\0\42\199\229\168\2\59", "\163\182\192\109\79")]:ExecuteTime()) and (v13:BuffDown(v55.PreciseShotsBuff) or v13:BuffUp(v55.TrueshotBuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\21\47\13\197\241\7\46\15\212", "\149\84\70\96\160")]:FullRechargeTime() < (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\25\15\0\232\60\53\5\226\44", "\141\88\102\109")]:CastTime() + v13:GCD())));
	end
	local function v86()
		local v108 = 0;
		while true do
			if ((4927 >= 2303) and (v108 == 2)) then
				if ((3462 >= 1032) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\49\30\91\203\165\124\140\39\13\64\200\187", "\235\102\127\50\167\204\18")]:IsReady() and not v13:IsCasting(v55.WailingArrow) and ((v69 > 2) or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\99\181\240\34\64\55\118\174\246\54\87", "\78\48\193\149\67\36")]:IsAvailable())) then
					if (v26(v55.WailingArrow, not v70, true) or (1077 >= 2011)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\31\137\20\72\62\25\191\25\83\34\17\151\88\78\32\27\142\29\83", "\33\80\126\224\120");
					end
				end
				if ((1543 < 2415) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\223\188\6\197\88\245\155\11\203\72", "\60\140\200\99\164")]:IsCastable() and ((v69 > 2) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\177\251\8\42\167\158", "\194\231\148\100\70")]:IsAvailable() and (v69 == 2)))) then
					if (v26(v55.SteadyShot, not v70) or (4444 < 2015)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\88\196\162\242\209\121\95\201\172\226\136\73\92\196\173\243\218", "\168\38\44\161\195\150");
					end
				end
				break;
			end
			if ((v108 == 1) or (4200 == 2332)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\229\128\243\95\208", "\191\182\225\159\41")]:IsCastable() and v33) or (1278 >= 1316)) then
					if ((1082 == 1082) and v26(v55.Salvo)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\19\36\67\132\199\205\59\23\38\80\153", "\162\75\114\72\53\235\231");
					end
				end
				if ((1328 <= 4878) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\173\53\73\231\87\49\132\51\80", "\98\236\92\36\130\51")]:IsReady() and not v13:IsCasting(v55.AimedShot) and (v69 < 3) and (not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\146\22\0\182\64\177", "\80\196\121\108\218\37\200\213")]:IsAvailable() or (v69 < 2))) then
					if ((4087 >= 1355) and v26(v55.AimedShot, not v70, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\122\15\122\79\49\153\8\124\22\63\68\30\143\14\118\16", "\234\96\19\98\31\43\110");
					end
				end
				v108 = 2;
			end
			if ((v108 == 0) or (590 > 4650)) then
				if ((v15 and v15:Exists() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\158\90\217\116\19\47\80\194\167\90\197\126", "\161\211\51\170\16\122\93\53")]:IsReady()) or (3774 <= 3667)) then
					if ((1270 < 2146) and v26(v57.MisdirectionFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\167\161\44\242\188\183\43\239\167\189\38\187\161\162\45\245\171\160", "\72\155\206\210");
					end
				end
				if ((4563 >= 56) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\117\111\89\3\60\72\74\81\26", "\83\38\26\52\110")]:IsCastable() and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\116\24\41\67\111\24\43\64", "\38\56\119\71")]:IsAvailable() and v44) then
					if (v26(v58[v45]) or (446 == 622)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\250\85\219\42\88\179\223\93\194\101\89\227\234\86\211\55", "\54\147\143\56\182\69");
					end
				end
				v108 = 1;
			end
		end
	end
	local function v87()
		local v109 = 0;
		while true do
			if ((2069 > 1009) and (v109 == 1)) then
				if ((12 < 4208) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\207\249\161\53\253\227\176\49\226\212\163\60\226", "\80\142\151\194")]:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\55\212\98\73\16\206\120\88", "\44\99\166\23")]:CooldownRemains() > 30) or (v66 < 16))) then
					if (v26(v55.AncestralCall) or (2990 <= 2980)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\125\249\42\51\32\176\110\246\37\9\48\165\112\251\105\53\55\183\60\161", "\196\28\151\73\86\83");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\213\10\59\21\128\84\23\121\247", "\22\147\99\73\112\226\56\120")]:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\140\103\247\240\158\176\122\246", "\237\216\21\130\149")]:CooldownRemains() > 30) or (v66 < 9))) or (2575 >= 4275)) then
					if (v26(v55.Fireblood) or (3626 <= 1306)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\132\71\77\90\178\197\81\141\74\31\92\180\218\30\218", "\62\226\46\63\63\208\169");
					end
				end
				v109 = 2;
			end
			if ((1368 < 3780) and (v109 == 0)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\162\249\144\101\53\250\189\31\142\251", "\118\224\156\226\22\80\136\214")]:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v66 < 13))) or (3169 == 2273)) then
					if ((2481 <= 3279) and v26(v55.Berserking)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\64\235\75\147\71\252\82\137\76\233\25\131\70\253\25\210", "\224\34\142\57");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\252\171\202\210\119\215\72\28\199", "\110\190\199\165\189\19\145\61")]:IsReady() and (v13:BuffUp(v55.TrueshotBuff) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\238\249\98\237\152\207\213\255", "\167\186\139\23\136\235")]:CooldownRemains() > 30) or (v66 < 16))) or (1063 <= 877)) then
					if ((2314 == 2314) and v26(v55.BloodFury)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\185\135\2\30\138\142\24\8\172\200\14\30\166\200\89", "\109\122\213\232");
					end
				end
				v109 = 1;
			end
			if ((924 >= 477) and (v109 == 2)) then
				if ((1813 <= 3778) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\201\16\82\139\11\30\5\75\225\30\88\134\17\25", "\62\133\121\53\227\127\109\79")]:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if ((4150 == 4150) and v26(v55.LightsJudgment, not v14:IsSpellInRange(v55.LightsJudgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\29\53\253\194\189\157\26\1\54\242\219\171\172\4\84\49\241\197\238\243\64", "\194\112\116\82\149\182\206");
					end
				end
				if ((432 <= 3007) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\10\169\64\14\207", "\110\89\200\44\120\160\130")]:IsCastable() and ((v69 > 2) or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\157\204\71\74\70\83", "\45\203\163\43\38\35\42\91")]:CooldownRemains() < 10))) then
					if (v26(v55.Salvo) or (408 > 2721)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\193\132\208\53\136\233\87\214\150\156\114\211", "\52\178\229\188\67\231\201");
					end
				end
				break;
			end
		end
	end
	local function v88()
		local v110 = 0;
		while true do
			if ((8 == v110) or (3418 < 2497)) then
				if ((1735 < 2169) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\206\50\0\19\13\57\206\46\10\6", "\64\157\70\101\114\105")]:IsCastable()) then
					if ((3890 >= 3262) and v26(v55.SteadyShot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\188\162\226\20\89\151\180\235\31\84\232\180\247\80\20\252", "\112\32\200\199\131");
					end
				end
				break;
			end
			if ((v110 == 6) or (4356 >= 4649)) then
				if ((3904 == 3904) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\151\139\21\199\125\80\172\152\0", "\22\197\234\101\174\25")]:IsCastable()) then
					if (v26(v55.RapidFire, not v70) or (2860 >= 3789)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\53\181\213\114\144\209\143\63\49\229\207\98\239\132\210", "\230\77\84\197\188\22\207\183");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\206\21\207\240\133\175\247\20\235\6\201\235", "\85\153\116\166\156\236\193\144")]:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) or (1086 > 4449)) then
					if ((4981 > 546) and v26(v55.WailingArrow, not v70, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\179\225\68\191\237\14\163\223\76\161\246\15\179\160\94\167\164\83\242", "\96\196\128\45\211\132");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\30\132\119\83\241\160\185\213\52\131\127", "\184\85\237\27\63\178\207\212")]:IsCastable() and (v13:BuffDown(v55.TrueshotBuff))) or (2366 <= 8)) then
					if (v26(v55.KillCommand, not v14:IsInRange(50)) or (2590 == 2864)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\80\5\83\55\90\6\82\5\88\7\91\72\74\29\31\91\14", "\63\104\57\105");
					end
				end
				v110 = 7;
			end
			if ((v110 == 5) or (2624 > 4149)) then
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\28\221\183\216\115\125\47\93\41", "\50\93\180\218\189\23\46\71")]:IsReady() or (2618 >= 4495)) then
					if (v71.CastTargetIf(v55.AimedShot, v67, LUAOBFUSACTOR_DECRYPT_STR_0("\211\173\85", "\40\190\196\59\44\36\188"), v77, v82, not v70, nil, nil, v57.AimedShotMouseover, true) or (2485 >= 3131)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\76\209\177\254\66\30\52\74\200\244\233\105\77\110\29", "\109\92\37\188\212\154\29");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\37\230\169\198\53\105\12\224\176", "\58\100\143\196\163\81")]:IsReady() or (2804 <= 2785)) then
					if (v71.CastTargetIf(v55.AimedShot, v67, LUAOBFUSACTOR_DECRYPT_STR_0("\23\67\59", "\110\122\34\67\195\95\41\133"), v78, v83, not v70, nil, nil, v57.AimedShotMouseover, true) or (4571 == 3415)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\116\184\86\79\210\74\162\83\69\194\53\162\79\10\133\37", "\182\21\209\59\42");
					end
				end
				if ((v53 and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\129\88\201\17\36\167", "\222\215\55\165\125\65")]:IsReady() and (v16:GUID() == v14:GUID())) or (4441 > 4787)) then
					if ((1920 == 1920) and v26(v57.VolleyCursor, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\222\202\22\247\216\173\89\56\145\148\74", "\42\76\177\166\122\146\161\141");
					end
				end
				v110 = 6;
			end
			if ((v110 == 3) or (647 == 4477)) then
				if ((3819 == 3819) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\236\95\15\57\17\251\167\130\195\72\15\32", "\227\168\58\110\77\121\184\207")]:IsReady() and v33) then
					if (v26(v55.DeathChakram, not v70) or (1466 > 4360)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\127\61\173\75\142\216\121\164\112\46\190\77\241\200\101\229\42\106", "\197\27\92\223\32\209\187\17");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\52\94\202\247\10\81\196\218\17\77\204\236", "\155\99\63\163")]:IsReady() and (v69 > 1)) or (14 > 994)) then
					if ((401 <= 734) and v26(v55.WailingArrow, not v70, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\149\208\168\129\176\138\133\238\160\159\171\139\149\145\178\153\249\213\218", "\228\226\177\193\237\217");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\6\177\51\239\48\150\42\244\49", "\134\84\208\67")]:IsCastable() and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\32\185\148\91\26\162\129\111\27\163\146\79", "\60\115\204\230")]:IsAvailable() or (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\198\51\230\117\227\9\227\127\243", "\16\135\90\139")]:FullRechargeTime() > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\117\125\11\54\74\103\112\91\96", "\24\52\20\102\83\46\52")]:CastTime() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\246\46\49\45\11\226\38\51\33", "\111\164\79\65\68")]:CastTime())))) or (2167 >= 3426)) then
					if ((764 < 3285) and v26(v55.RapidFire, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\212\216\147\215\42\213\192\208\145\219\110\249\210\153\209\140", "\138\166\185\227\190\78");
					end
				end
				v110 = 4;
			end
			if ((2499 == 2499) and (v110 == 2)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\10\118\107\81\203\55\103\74\85\199\55\116", "\174\89\19\25\33")]:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) or (692 >= 4933)) then
					if (v71.CastTargetIf(v55.SerpentSting, v67, LUAOBFUSACTOR_DECRYPT_STR_0("\34\27\92", "\107\79\114\50\46\151\231"), v76, v79, not v70, nil, nil, v57.SerpentStingMouseover) or (3154 <= 2260)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\163\167\57\143\55\163\255\42\178\188\39\141\121\164\212\121\254", "\160\89\198\213\73\234\89\215");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\109\105\164\242\202\91\120\162\251\246\64\126\160", "\165\40\17\212\158")]:IsReady() or (2637 > 3149)) then
					if (v26(v55.ExplosiveShot, not v70) or (3992 < 2407)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\224\193\24\63\41\246\208\30\54\25\246\209\7\39\102\246\205\72\98\118", "\70\133\185\104\83");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\55\81\69\39\217\1\65\65", "\169\100\37\36\74")]:IsCastable() and v33) or (2902 > 4859)) then
					if ((1679 < 4359) and v26(v55.Stampede, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\147\163\93\16\130\166\85\64\148\182\16\81\211", "\48\96\231\194");
					end
				end
				v110 = 3;
			end
			if ((1913 < 4670) and (v110 == 1)) then
				if ((v53 and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\176\114\33\27\221\213", "\178\230\29\77\119\184\172")]:IsReady() and (v16:GUID() == v14:GUID()) and (v13:BuffUp(v55.SalvoBuff))) or (2846 < 879)) then
					if ((4588 == 4588) and v26(v57.VolleyCursor, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\177\6\23\114\225\181\173\30\91\34", "\152\149\222\106\123\23");
					end
				end
				if ((v16:Exists() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\246\47\250\79\134\213\41\226", "\213\189\70\150\35")]:IsCastable() and (v16:HealthPercentage() <= 20)) or (347 == 2065)) then
					if (v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot)) or (1311 > 2697)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\92\120\4\112\70\124\7\91\106\121\7\90\70\113\7\89\80\102\72\76\89\113\9\89\80\52\91\23", "\104\47\53\20");
					end
				end
				if ((v46 and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\144\88\132\25\176\59\177\77\145", "\111\195\44\225\124\220")]:IsCastable() and (v14:GUID() == v16:GUID()) and (v13:BuffDown(v55.TrueshotBuff))) or (2717 > 3795)) then
					if (v26(v57.SteelTrapCursor, not v14:IsInRange(40)) or (1081 < 391)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\203\82\5\118\167\148\204\84\1\99\235\184\204\6\86", "\203\184\38\96\19\203");
					end
				end
				v110 = 2;
			end
			if ((v110 == 4) or (121 > 3438)) then
				if ((71 < 1949) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\224\125\201\59\97\43\22\223", "\121\171\20\165\87\50\67")]:IsReady()) then
					if ((4254 == 4254) and v26(v55.KillShot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\205\49\181\58\134\17\206\55\173\118\170\22\134\106\237", "\98\166\88\217\86\217");
					end
				end
				if ((3196 >= 2550) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\194\228\108\4\149\212\249\226", "\188\150\150\25\97\230")]:IsReady() and v33 and v64 and (v13:BuffDown(v55.TrueshotBuff) or (v13:BuffRemains(v55.TrueshotBuff) < 5))) then
					if ((2456 < 4176) and v26(v55.Trueshot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\206\155\74\7\31\229\213\157\31\17\24\173\136\223", "\141\186\233\63\98\108");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\220\255\32\162\44\194\226\35\162", "\69\145\138\76\214")]:IsReady() and ((v13:BuffUp(v55.BombardmentBuff) and not v74() and (v69 > 1)) or (v13:BuffUp(v55.SalvoBuff) and not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\70\192\133\133\186\15", "\118\16\175\233\233\223")]:IsAvailable()))) or (1150 == 3452)) then
					if ((1875 < 2258) and v26(v55.MultiShot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\145\57\175\231\152\117\132\144\117\168\250\203\47\221", "\29\235\228\85\219\142\235");
					end
				end
				v110 = 5;
			end
			if ((1173 > 41) and (v110 == 7)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\40\143\173\73\10\130\182\69\56\143\171\80", "\36\107\231\196")]:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:FocusP() > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\126\189\171\138\92\176\176\134\110\189\173\147", "\231\61\213\194")]:Cost() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\40\164\48\118\13\158\53\124\29", "\19\105\205\93")]:Cost())))) or (56 >= 3208)) then
					if ((4313 > 3373) and v26(v55.ChimaeraShot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\0\215\140\62\172\26\223\190\44\161\7\202\193\44\189\72\141\217", "\95\201\104\190\225");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\142\217\194\207\161\206\242\198\160\223", "\174\207\171\161")]:IsReady() and (v13:BuffUp(v55.PreciseShotsBuff) or (v13:FocusP() > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\204\236\14\242\246\210\222\246\2\231", "\183\141\158\109\147\152")]:Cost() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\13\0\235\9\40\58\238\3\56", "\108\76\105\134")]:Cost())))) or (4493 == 2225)) then
					if ((3104 >= 3092) and v26(v55.ArcaneShot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\215\178\224\192\238\250\162\233\193\255\133\162\245\142\191\149", "\174\139\165\209\129");
					end
				end
				if ((3548 > 3098) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\129\178\229\206\192\55\98\113\160\184\241", "\24\195\211\130\161\166\99\16")]:IsReady()) then
					if (v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks)) or (3252 == 503)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\2\238\19\92\16\121\23\251\37\80\29\85\67\250\56\19\66\20", "\118\38\99\137\76\51");
					end
				end
				v110 = 8;
			end
			if ((4733 > 2066) and (v110 == 0)) then
				if ((3549 >= 916) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\18\85\85\5\243\69\16\41\78\68", "\67\65\33\48\100\151\60")]:IsCastable() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\236\243\171\217\247\198\193\161\219\230\204", "\147\191\135\206\184")]:IsAvailable() and (((v63[LUAOBFUSACTOR_DECRYPT_STR_0("\167\39\179\207\204", "\210\228\72\198\161\184\51")] == 1) and (v13:BuffRemains(v55.SteadyFocusBuff) < 5)) or (v13:BuffDown(v55.SteadyFocusBuff) and v13:BuffDown(v55.TrueshotBuff) and (v63[LUAOBFUSACTOR_DECRYPT_STR_0("\21\70\230\30\103", "\174\86\41\147\112\19")] ~= 2)))) then
					if (v26(v55.SteadyShot, not v70) or (2189 <= 245)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\72\20\136\10\33\22\46\184\83\15\153\75\54\27\81\249", "\203\59\96\237\107\69\111\113");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\5\31\161\228\53\195\223\43\2", "\183\68\118\204\129\81\144")]:IsReady() and v13:BuffUp(v55.TrueshotBuff) and (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\47\164\125\225\15\177\6\162\100", "\226\110\205\16\132\107")]:FullRechargeTime() < (v13:GCD() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\202\202\237\220\69\216\203\239\205", "\33\139\163\128\185")]:CastTime())) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\123\93\3\223\84\65\11\216\67\80\1\233\94\86\0\204\66\86\10\219\69\75", "\190\55\56\100")]:IsAvailable() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\97\166\50\26\1\246\253\88\170\46\13\52\246\250\82\174\50\29\22", "\147\54\207\92\126\115\131")]:IsAvailable()) or (1389 > 3925)) then
					if ((4169 >= 3081) and v26(v55.AimedShot, not v70, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\12\56\56\120\9\65\30\57\58\105\77\109\25\113\97", "\30\109\81\85\29\109");
					end
				end
				if ((349 <= 894) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\212\120\88\186\5\214\243\235", "\156\159\17\52\214\86\190")]:IsReady() and (v13:BuffDown(v55.TrueshotBuff))) then
					if ((731 <= 2978) and v26(v55.KillShot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\230\177\176\145\252\181\179\186\175\174\168\238\185", "\220\206\143\221");
					end
				end
				v110 = 1;
			end
		end
	end
	local function v89()
		local v111 = 0;
		while true do
			if ((v111 == 1) or (892 > 3892)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\8\124\229\76\36\90\236\89\39\107\229\85", "\56\76\25\132")]:IsReady() and v33) or (4466 == 900)) then
					if (v26(v55.DeathChakram, not v70) or (2084 >= 2888)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\196\170\50\199\97\194\163\39\196\76\192\166\102\219\76\200\168\45\220\86\206\191\53\143\15\145", "\175\62\161\203\70");
					end
				end
				if ((479 < 1863) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\15\201\194\30\37\57\217\198", "\85\92\189\163\115")]:IsReady() and v33) then
					if (v26(v55.Stampede, not v14:IsInRange(30)) or (2428 >= 4038)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\184\49\53\57\169\52\61\105\184\34\49\42\167\35\48\38\184\35\120\120\254", "\88\73\204\80");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\25\130\25\74\32\212\41\162\2\84\38\205", "\186\78\227\112\38\73")]:IsReady() or (2878 > 2897)) then
					if (v26(v55.WailingArrow, not v70, true) or (2469 > 3676)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\86\244\89\90\116\251\104\252\71\65\117\235\23\233\71\90\121\247\68\245\90\71\105\188\6\169", "\26\156\55\157\53\51");
					end
				end
				if ((233 < 487) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\191\221\4\201\189\94\152\235\2\208\182\87", "\48\236\184\118\185\216")]:IsReady()) then
					if ((2473 >= 201) and v71.CastTargetIf(v55.SerpentSting, v67, LUAOBFUSACTOR_DECRYPT_STR_0("\232\180\89", "\84\133\221\55\80\175"), v76, v80, not v70, nil, nil, v57.SerpentStingMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\174\226\54\182\194\82\169\216\55\178\206\82\186\167\48\180\206\95\182\244\44\169\211\79\253\182\114", "\60\221\135\68\198\167");
					end
				end
				v111 = 2;
			end
			if ((4120 >= 133) and (2 == v111)) then
				if ((3080 >= 1986) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\204\188\234\145\67\222\235", "\185\142\221\152\227\34")]:IsReady() and (v69 > 7) and v33) then
					if (v26(v55.Barrage, not v70) or (1439 > 3538)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\196\69\232\66\52\242\24\209\69\243\64\56\228\80\202\67\233\3\98\175", "\151\56\165\55\154\35\83");
					end
				end
				if ((v53 and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\150\76\9\226\165\90", "\142\192\35\101")]:IsReady() and (v16:GUID() == v14:GUID())) or (419 < 7)) then
					if ((2820 == 2820) and v26(v57.VolleyCursor)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\122\37\175\226\149\236\2\196\124\42\168\244\132\163\2\197\53\123\243", "\118\182\21\73\195\135\236\204");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\60\46\15\69\23\5\242\28", "\157\104\92\122\32\100\109")]:IsReady() and v33 and not v13:IsCasting(v55.SteadyShot) and not v13:IsCasting(v55.RapidFire) and not v13:IsChanneling(v55.RapidFire)) or (4362 <= 3527)) then
					if ((2613 <= 2680) and v26(v55.Trueshot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\180\218\207\46\47\130\191\227\178\221\195\62\44\158\163\172\178\220\138\111\117", "\203\195\198\175\170\93\71\237");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\28\74\46\220\85\55\245\60\78", "\156\78\43\94\181\49\113")]:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55[LUAOBFUSACTOR_DECRYPT_STR_0("\64\233\212\170\15\101\112\96\237", "\25\18\136\164\195\107\35")]:ExecuteTime()) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\219\56\187\72\123\178\198\139\224\34\189\92", "\216\136\77\201\47\18\220\161")]:IsAvailable()) or (1482 >= 4288)) then
					if (v26(v55.RapidFire, not v70) or (2462 > 4426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\237\59\211\12\227\132\36\254\46\154\28\206\139\46\231\56\210\7\200\145\109\190\127", "\226\77\140\75\186\104\188");
					end
				end
				v111 = 3;
			end
			if ((4774 == 4774) and (5 == v111)) then
				if ((566 <= 960) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\33\231\241\156\120\63\250\242\156", "\17\108\146\157\232")]:IsReady() and (v13:FocusP() > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\102\214\24\249\38\155\67\204\0", "\200\43\163\116\141\79")]:Cost() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\158\63\48\134\180\199\235\176\34", "\131\223\86\93\227\208\148")]:Cost()))) then
					if (v26(v55.MultiShot, not v70) or (2910 <= 1930)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\238\80\186\162\20\166\235\74\162\246\9\167\234\70\189\165\21\186\247\86\246\226\79", "\213\131\37\214\214\125");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\4\42\34\176\231\18\57\44\188\234\53", "\129\70\75\69\223")]:IsReady() and (v13:BuffDown(v55.Trueshot))) or (19 > 452)) then
					if (v26(v55.BagofTricks, not v14:IsSpellInRange(v55.BagofTricks)) or (907 > 3152)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\202\244\214\115\233\121\223\225\224\127\228\85\139\231\251\117\236\77\216\251\230\104\252\6\159\167", "\143\38\171\147\137\28");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\227\150\188\242\7\250\231\216\141\173", "\180\176\226\217\147\99\131")]:IsCastable() or (2505 > 4470)) then
					if (v26(v55.SteadyShot, not v70) or (3711 > 4062)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\173\42\6\215\160\16\20\219\182\59\71\199\171\38\4\216\170\39\8\199\170\111\83\133", "\103\179\217\79");
					end
				end
				break;
			end
			if ((420 == 420) and (v111 == 0)) then
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\31\68\89\185\199\178\17\36\95\72", "\66\76\48\60\216\163\203")]:IsCastable() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\137\146\124\242\91\215\2\181\133\108\224", "\68\218\230\25\147\63\174")]:IsAvailable() and (v63[LUAOBFUSACTOR_DECRYPT_STR_0("\142\37\70\66\162", "\214\205\74\51\44")] == 1) and (v13:BuffRemains(v55.SteadyFocusBuff) < 8)) or (33 >= 3494)) then
					if (v26(v55.SteadyShot, not v70) or (1267 == 4744)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\88\231\253\115\227\115\241\244\120\238\12\246\238\126\249\71\241\244\120\238\95\162\174", "\23\154\44\130\156");
					end
				end
				if ((2428 < 3778) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\58\175\161\162\5\27\30\178", "\115\113\198\205\206\86")]:IsReady()) then
					if (v26(v55.KillShot, not v70) or (2946 <= 1596)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\143\94\242\86\187\68\246\85\144\23\234\72\141\84\245\73\140\88\234\73\196\3", "\58\228\55\158");
					end
				end
				if ((4433 > 3127) and v16:Exists() and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\159\128\220\34\15\165\58\160", "\85\212\233\176\78\92\205")]:IsCastable() and (v16:HealthPercentage() <= 20)) then
					if ((4300 >= 2733) and v26(v57.KillShotMouseover, not v16:IsSpellInRange(v55.KillShot))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\65\81\132\238\117\75\128\237\94\103\133\237\95\75\141\237\92\93\154\162\73\84\141\227\92\93\200\177\18", "\130\42\56\232");
					end
				end
				if ((4829 == 4829) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\207\173\52\239\79\44\227\163\33\208\72\48\254", "\95\138\213\68\131\32")]:IsReady()) then
					if ((1683 <= 4726) and v26(v55.ExplosiveShot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\48\177\79\121\57\33\183\70\73\57\32\174\87\54\62\58\168\64\125\57\32\174\87\101\106\112", "\22\74\72\193\35");
					end
				end
				v111 = 1;
			end
			if ((4835 >= 3669) and (v111 == 3)) then
				if ((2851 > 1859) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\152\199\221\58\75\138\198\223\43", "\47\217\174\176\95")]:IsReady()) then
					if ((3848 > 2323) and v71.CastTargetIf(v55.AimedShot, v67, LUAOBFUSACTOR_DECRYPT_STR_0("\181\212\120", "\70\216\189\22\98\210\52\24"), v77, v84, not v70, nil, nil, v57.AimedShotMouseover, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\214\174\130\215\229\204\171\136\199\154\203\177\142\208\209\204\171\136\199\201\159\241\209", "\179\186\191\195\231");
					end
				end
				if ((2836 > 469) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\216\54\21\225\253\12\16\235\237", "\132\153\95\120")]:IsReady()) then
					if (v71.CastTargetIf(v55.AimedShot, v67, LUAOBFUSACTOR_DECRYPT_STR_0("\188\179\22", "\192\209\210\110\77\151\186"), v78, v85, not v70, nil, nil, v57.AimedShotMouseover, true) or (2096 <= 540)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\10\47\236\251\251\243\11\45\253\191\208\242\10\33\226\236\204\239\23\49\169\173\156", "\164\128\99\66\137\159");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\50\136\249\183\4\175\224\172\5", "\222\96\233\137")]:IsCastable() and (v13:BuffRemains(v55.TrickShotsBuff) >= v55[LUAOBFUSACTOR_DECRYPT_STR_0("\139\178\183\22\140\213\249\171\182", "\144\217\211\199\127\232\147")]:ExecuteTime())) or (3183 < 2645)) then
					if ((3230 <= 3760) and v26(v55.RapidFire, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\46\46\33\209\122\4\77\234\42\126\60\199\76\1\79\235\39\49\60\198\5\81\20", "\36\152\79\94\72\181\37\98");
					end
				end
				if ((3828 == 3828) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\244\208\78\50\214\221\85\62\228\208\72\43", "\95\183\184\39")]:IsReady() and v13:BuffUp(v55.TrickShotsBuff) and v13:BuffUp(v55.PreciseShotsBuff) and (v13:FocusP() > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\150\55\238\43\85\133\16\180\12\239\41\64", "\98\213\95\135\70\52\224")]:Cost() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\223\170\196\114\80\205\171\198\99", "\52\158\195\169\23")]:Cost())) and (v69 < 4)) then
					if ((554 == 554) and v26(v55.ChimaeraShot, not v70)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\121\180\59\121\135\48\105\138\69\175\58\123\146\117\111\153\115\191\57\103\142\58\111\152\58\239\96", "\235\26\220\82\20\230\85\27");
					end
				end
				v111 = 4;
			end
			if ((v111 == 4) or (2563 == 172)) then
				if ((3889 >= 131) and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\165\180\229\214\125\187\169\230\214", "\20\232\193\137\162")]:IsReady() and (not v74() or ((v13:BuffUp(v55.PreciseShotsBuff) or (v13:BuffStack(v55.BulletstormBuff) == 10)) and (v13:FocusP() > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\15\202\201\178\238\191\31\126\54", "\17\66\191\165\198\135\236\119")]:Cost() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\46\166\163\22\251\219\228\222\27", "\177\111\207\206\115\159\136\140")]:Cost()))))) then
					if (v26(v55.MultiShot, not v70) or (492 == 4578)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\156\28\0\221\92\87\10\157\80\0\198\70\92\14\154\24\27\192\92\31\86\221", "\63\101\233\112\116\180\47");
					end
				end
				if (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\240\62\255\2\253\56\215\8\249\27\246\49", "\86\163\91\141\114\152")]:IsReady() or (4112 < 1816)) then
					if ((4525 >= 1223) and v71.CastTargetIf(v55.SerpentSting, v67, LUAOBFUSACTOR_DECRYPT_STR_0("\94\2\122", "\90\51\107\20\19"), v76, v81, not v70, nil, nil, v57.SerpentStingMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\158\245\151\255\56\131\228\186\252\41\132\254\130\175\41\159\249\134\228\46\133\255\145\252\125\222\166", "\93\237\144\229\143");
					end
				end
				if ((1090 <= 4827) and v46 and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\38\226\245\28\7\114\7\247\224", "\38\117\150\144\121\107")]:IsCastable() and (v14:GUID() == v16:GUID())) then
					if (v26(v57.SteelTrapCursor, not v14:IsInRange(40)) or (239 > 1345)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\175\235\63\33\132\250\40\44\171\174\46\63\178\237\49\62\179\225\46\62\251\189\98", "\90\77\219\142");
					end
				end
				if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\205\13\45\53\127\15\117\242", "\26\134\100\65\89\44\103")]:IsReady() and (v13:FocusP() > (v55[LUAOBFUSACTOR_DECRYPT_STR_0("\218\234\60\47\151\249\236\36", "\196\145\131\80\67")]:Cost() + v55[LUAOBFUSACTOR_DECRYPT_STR_0("\63\185\11\13\28\219\22\191\18", "\136\126\208\102\104\120")]:Cost()))) or (3710 >= 3738)) then
					if (v26(v55.KillShot, not v70) or (3838 < 2061)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\115\131\194\79\144\65\53\94\108\202\218\81\166\81\54\66\112\133\218\80\239\6\109", "\49\24\234\174\35\207\50\93");
					end
				end
				v111 = 5;
			end
		end
	end
	local function v90()
		local v112 = 0;
		local v113;
		local v114;
		while true do
			if ((v112 == 0) or (690 > 1172)) then
				v113 = v13:GetUseableItems(v59, 13);
				if ((v113 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < 13))) or (1592 > 2599)) then
					if ((3574 <= 4397) and v26(v57.Trinket1, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\94\165\21\219\74\137\183\27\247\8\199\72\130\168\79\163\92\135", "\195\42\215\124\181\33\236");
					end
				end
				v112 = 1;
			end
			if ((3135 > 1330) and (v112 == 1)) then
				v114 = v13:GetUseableItems(v59, 14);
				if ((v114 and (v13:BuffUp(v55.TrueshotBuff) or (v66 < 13))) or (3900 <= 3641)) then
					if ((1724 == 1724) and v26(v57.Trinket2, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\25\75\62\48\46\253\25\11\119\42\55\241\3\82\50\42\101\172", "\152\109\57\87\94\69");
					end
				end
				break;
			end
		end
	end
	local function v91()
		local v115 = 0;
		while true do
			if ((455 <= 1282) and (v115 == 2)) then
				v70 = v14:IsSpellInRange(v55.AimedShot);
				v67 = v13:GetEnemiesInRange(v55[LUAOBFUSACTOR_DECRYPT_STR_0("\25\59\30\134\60\1\27\140\44", "\227\88\82\115")].MaximumRange);
				v115 = 3;
			end
			if ((4606 < 4876) and (v115 == 1)) then
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\88\215\18\81\58\144", "\95\227\55\176\117\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\113\38", "\203\120\30\67\43")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\42\74\232\213\244\54", "\185\145\69\45\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\137\27\10", "\188\234\127\121\198")];
				v115 = 2;
			end
			if ((v115 == 3) or (1442 > 2640)) then
				v68 = v14:GetEnemiesInSplashRange(10);
				if ((136 < 3668) and v23()) then
					v69 = v14:GetEnemiesInSplashRangeCount(10);
				else
					v69 = 1;
				end
				v115 = 4;
			end
			if ((v115 == 0) or (1784 > 4781)) then
				v54();
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\205\216\13\164\178\215\71", "\200\153\183\106\195\222\178\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\61\236\139", "\58\82\131\232\93\41")];
				v115 = 1;
			end
			if ((4585 > 3298) and (v115 == 4)) then
				if (v71.TargetIsValid() or v13:AffectingCombat() or (1664 > 1698)) then
					local v133 = 0;
					while true do
						if ((v133 == 0) or (3427 < 2849)) then
							v65 = v10.BossFightRemains(nil, true);
							v66 = v65;
							v133 = 1;
						end
						if ((3616 <= 4429) and (1 == v133)) then
							if ((3988 >= 66) and (v66 == 11111)) then
								v66 = v10.FightRemains(v68, false);
							end
							break;
						end
					end
				end
				if (v71.TargetIsValid() or (862 > 4644)) then
					local v134 = 0;
					while true do
						if ((1221 == 1221) and (1 == v134)) then
							if ((not v13:IsCasting() and not v13:IsChanneling()) or (45 > 1271)) then
								local v137 = 0;
								local v138;
								while true do
									if ((3877 > 1530) and (v137 == 3)) then
										v138 = v71.InterruptWithStun(v55.Intimidation, 40, false, v16, v57.IntimidationMouseover);
										if (v138 or (4798 == 1255)) then
											return v138;
										end
										break;
									end
									if ((v137 == 1) or (2541 > 2860)) then
										v138 = v71.InterruptWithStun(v55.Intimidation, 40);
										if (v138 or (2902 > 3629)) then
											return v138;
										end
										v137 = 2;
									end
									if ((427 < 3468) and (v137 == 0)) then
										v138 = v71.Interrupt(v55.CounterShot, 40, true);
										if ((4190 >= 2804) and v138) then
											return v138;
										end
										v137 = 1;
									end
									if ((2086 == 2086) and (v137 == 2)) then
										v138 = v71.Interrupt(v55.CounterShot, 40, true, v16, v57.CounterShotMouseover);
										if ((4148 > 2733) and v138) then
											return v138;
										end
										v137 = 3;
									end
								end
							end
							if ((3054 >= 1605) and v52 and v55[LUAOBFUSACTOR_DECRYPT_STR_0("\203\242\179\183\25\43\246\236\187\163\1\48\248\211\186\182\28", "\94\159\128\210\217\104")]:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and (v71.UnitHasEnrageBuff(v14) or v71.UnitHasMagicBuff(v14))) then
								if ((1044 < 1519) and v26(v55.TranquilizingShot, not v70)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\84\240\21\175\90\115", "\26\48\153\102\223\63\31\153");
								end
							end
							v64 = v55[LUAOBFUSACTOR_DECRYPT_STR_0("\54\82\248\246\17\72\226\231", "\147\98\32\141")]:CooldownUp();
							if ((1707 <= 4200) and v35 and v33) then
								local v139 = 0;
								local v140;
								while true do
									if ((580 == 580) and (v139 == 0)) then
										v140 = v90();
										if ((601 <= 999) and v140) then
											return v140;
										end
										break;
									end
								end
							end
							v134 = 2;
						end
						if ((3970 == 3970) and (2 == v134)) then
							if (v33 or (98 == 208)) then
								local v141 = 0;
								local v142;
								while true do
									if ((2006 <= 3914) and (v141 == 0)) then
										v142 = v87();
										if (v142 or (3101 <= 2971)) then
											return v142;
										end
										break;
									end
								end
							end
							if ((v69 < 3) or not v55[LUAOBFUSACTOR_DECRYPT_STR_0("\44\81\234\201\13\101\67\23\87\240", "\43\120\35\131\170\102\54")]:IsAvailable() or not v32 or (2073 <= 671)) then
								local v143 = 0;
								local v144;
								while true do
									if ((3305 > 95) and (v143 == 0)) then
										v144 = v88();
										if ((2727 == 2727) and v144) then
											return v144;
										end
										break;
									end
								end
							end
							if ((v69 > 2) or (2970 >= 4072)) then
								local v145 = 0;
								local v146;
								while true do
									if ((3881 > 814) and (v145 == 0)) then
										v146 = v89();
										if (v146 or (4932 < 4868)) then
											return v146;
										end
										break;
									end
								end
							end
							if ((3667 <= 4802) and v26(v55.PoolFocus)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\100\9\136\186\172\190\131\20\32\136\181\176\163", "\228\52\102\231\214\197\208");
							end
							break;
						end
						if ((1260 >= 858) and (v134 == 0)) then
							v75();
							if ((not v13:AffectingCombat() and not v31) or (3911 == 4700)) then
								local v147 = 0;
								local v148;
								while true do
									if ((3000 < 4194) and (v147 == 0)) then
										v148 = v86();
										if ((651 < 4442) and v148) then
											return v148;
										end
										break;
									end
								end
							end
							if ((v55[LUAOBFUSACTOR_DECRYPT_STR_0("\102\7\178\174\14\114\81\30\174\174\13\125", "\19\35\127\218\199\98")]:IsReady() and (v13:HealthPercentage() <= v51)) or (195 >= 1804)) then
								if (v26(v55.Exhilaration) or (1382 > 2216)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\25\227\2\235\16\250\24\227\8\242\5\236", "\130\124\155\106");
								end
							end
							if (((v13:HealthPercentage() <= v40) and v56[LUAOBFUSACTOR_DECRYPT_STR_0("\253\206\247\163\183\254\111\171\218\197\243", "\223\181\171\150\207\195\150\28")]:IsReady()) or (2861 == 2459)) then
								if ((1903 < 4021) and v26(v57.Healthstone, nil, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\68\63\226\162\29\68\41\247\161\7\73", "\105\44\90\131\206");
								end
							end
							v134 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v92()
		v10.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\51\225\103\193\249\134\24\216\13\232\124\218\170\137\0\150\59\240\124\201\164\203\42\195\14\240\122\216\254\142\29\150\28\249\53\237\229\129\16\196\31", "\182\126\128\21\170\138\235\121"));
	end
	v10.SetAPL(254, v91, v92);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\174\202\60\254\185\59\37\8\159\223\39\217\171\18\34\13\152\215\52\232\149\27\57\22\197\214\32\231", "\102\235\186\85\134\230\115\80")]();

