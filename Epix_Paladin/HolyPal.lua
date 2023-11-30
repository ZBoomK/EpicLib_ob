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
		if ((v5 == 1) or (2033 <= 224)) then
			return v6(...);
		end
		if ((v5 == 0) or (1223 == 2011)) then
			v6 = v0[v4];
			if ((4827 > 4695) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\139\198\18\208\199\210\43\217\147\200\18\200\243\218\41\168\183\210\31", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\163\64\26\175", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\24\43\6", "\158\48\118\66\114")];
	local v14 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\141\43\19\35\96", "\155\203\68\112\86\19\197")];
	local v15 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\118\209\55\229\69\106", "\152\38\189\86\156\32\24\133")];
	local v16 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\209\88\178\85\249\120\177\67\238", "\38\156\55\199")];
	local v17 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\156\124\110\47\22\96", "\35\200\29\28\72\115\20\154")];
	local v18 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\41\186\197", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\136\70\204\172\54", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\96\86\5\40", "\69\41\34\96")];
	local v21 = EpicLib;
	local v22 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local v24 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local v26 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local v27 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\193\88\127\27\171", "\126\167\52\16\116\217")];
	local v28 = string[LUAOBFUSACTOR_DECRYPT_STR_0("\206\33\50\141\181\13", "\156\168\78\64\224\212\121")];
	local v29 = GetTotemInfo;
	local v30 = GetTime;
	local v31 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\55\239\169\207\3\231\171", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\39\83\33", "\152\54\72\63\88\69\62")];
	local v32 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\228\197\226\93\208\205\224", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\112\81\9\48", "\114\56\62\101\73\71\141")];
	local v33 = v23[LUAOBFUSACTOR_DECRYPT_STR_0("\136\232\215\197\188\224\213", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\233\61\171", "\107\178\134\81\210\198\158")];
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
	local v83;
	local v84;
	local v68;
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98;
	local v99;
	local v100;
	local v101;
	local v102;
	local v103;
	local v104;
	local v105;
	local v106;
	local v107;
	local v108;
	local v109;
	local v110;
	local v111;
	local v112;
	local v113;
	local v114;
	local v115;
	local v116;
	local v117;
	local v118 = false;
	local v119 = false;
	local v120 = false;
	local v121 = false;
	local v122 = false;
	local v123 = false;
	local v124 = {};
	local v125;
	local v126;
	local v127 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\27\1\143\203\165\54\29", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\25\135\229\211\204\1\135", "\170\163\111\226\151")];
	local function v128(v149)
		return v149:DebuffRefreshable(v31.JudgmentDebuff);
	end
	local function v129()
		local v150 = 0;
		while true do
			if ((3710 > 3065) and (v150 == 0)) then
				for v223 = 1, 4 do
					local v224 = 0;
					local v225;
					local v226;
					local v227;
					local v228;
					while true do
						if ((2135 <= 2696) and (v224 == 0)) then
							v225, v226, v227, v228 = v29(v223);
							if ((v226 == v31[LUAOBFUSACTOR_DECRYPT_STR_0("\50\63\188\43\75\52\59\16\36\187\55\64", "\73\113\80\210\88\46\87")]:Name()) or (1742 > 4397)) then
								return (v27(((v227 + v228) - v30()) + 0.5)) or 0;
							end
							break;
						end
					end
				end
				return 0;
			end
		end
	end
	local function v130(v151)
		return v151:DebuffRefreshable(v31.GlimmerofLightBuff) or not v61;
	end
	local function v131()
		local v152 = 0;
		local v153;
		while true do
			if ((3900 >= 1904) and (v152 == 0)) then
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\163\32\200\1\244\136\34\202\29\225\178\57\192\31\226\147", "\135\225\76\173\114")]:IsCastable() and v15:IsInParty() and not v15:IsInRaid()) or (1724 == 909)) then
					if ((1282 < 1421) and v14 and v14:Exists() and (v127.UnitGroupRole(v14) == LUAOBFUSACTOR_DECRYPT_STR_0("\62\204\149\145\139\152\149", "\199\122\141\216\208\204\221"))) then
						if ((4876 >= 4337) and v24(v33.BlessingofSummerFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\175\209\21\227\107\255\163\218\47\255\126\201\190\200\29\253\125\228", "\150\205\189\112\144\24");
						end
					end
				end
				v153 = {v31[LUAOBFUSACTOR_DECRYPT_STR_0("\7\136\186\95\23\129\31\23\42\130\140\92\22\129\31\23", "\112\69\228\223\44\100\232\113")],v31[LUAOBFUSACTOR_DECRYPT_STR_0("\246\19\2\192\165\117\136\211\16\1\224\163\113\139\209\13", "\230\180\127\103\179\214\28")],v31[LUAOBFUSACTOR_DECRYPT_STR_0("\174\9\90\85\247\72\238\139\10\89\103\241\85\245\129\11", "\128\236\101\63\38\132\33")],v31[LUAOBFUSACTOR_DECRYPT_STR_0("\142\165\20\87\165\226\193\171\166\23\115\191\229\219\169\187", "\175\204\201\113\36\214\139")]};
				v152 = 1;
			end
			if ((4005 >= 3005) and (v152 == 1)) then
				for v229, v230 in pairs(v153) do
					if (v230:IsCastable() or (4781 <= 4448)) then
						if ((1317 > 172) and v24(v33.BlessingofSummerPlayer)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\69\192\48\207\23\78\194\50\227\11\65\243\33\212\1\120\223\48\221\23\72\194\38", "\100\39\172\85\188");
						end
					end
				end
				break;
			end
		end
	end
	local function v132()
		local v154 = 0;
		while true do
			if ((4791 == 4791) and (0 == v154)) then
				ShouldReturn = v127.HandleTopTrinket(v124, v119, 40, nil);
				if ((3988 > 1261) and ShouldReturn) then
					return ShouldReturn;
				end
				v154 = 1;
			end
			if ((2240 <= 3616) and (v154 == 1)) then
				ShouldReturn = v127.HandleBottomTrinket(v124, v119, 40, nil);
				if (ShouldReturn or (3988 < 3947)) then
					return ShouldReturn;
				end
				break;
			end
		end
	end
	local function v133()
		if ((4644 == 4644) and not v15:IsCasting() and not v15:IsChanneling()) then
			local v174 = 0;
			local v175;
			while true do
				if ((1323 > 1271) and (v174 == 0)) then
					v175 = v127.Interrupt(v31.Rebuke, 5, true);
					if ((1619 > 1457) and v175) then
						return v175;
					end
					v174 = 1;
				end
				if ((1 == v174) or (2860 < 1808)) then
					v175 = v127.InterruptWithStun(v31.HammerofJustice, 8);
					if (v175 or (739 >= 1809)) then
						return v175;
					end
					break;
				end
			end
		end
	end
	local function v134()
		local v155 = 0;
		while true do
			if ((1539 <= 4148) and (v155 == 0)) then
				if (not v14 or not v14:Exists() or not v14:IsInRange(40) or not v127.DispellableFriendlyUnit() or (434 > 3050)) then
					return;
				end
				if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\142\116\188\129\61\190\125", "\83\205\24\217\224")]:IsReady() or (3054 < 1683)) then
					if ((47 < 2706) and v24(v33.CleanseFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\201\200\60\232\214\200\125\226\204\222\45\227\201", "\93\134\165\173");
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v156 = 0;
		while true do
			if ((1519 >= 580) and (v156 == 0)) then
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\157\253\207\209\63\205\160\127\170\251\206\204", "\30\222\146\161\162\90\174\210")]:IsCastable() and v17:IsInMeleeRange(5)) or (3110 == 4177)) then
					if ((4200 > 2076) and v24(v31.Consecration)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\230\65\126\25\224\77\98\11\241\75\48\26\247\75\115\5\232\76\113\30\165\26", "\106\133\46\16");
					end
				end
				if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\114\53\119\251\87\69\86\52", "\32\56\64\19\156\58")]:IsReady() or (601 >= 2346)) then
					if ((3970 <= 4354) and v24(v31.Judgment, not v17:IsSpellInRange(v31.Judgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\221\225\81\87\247\142\78\136\245\68\95\241\143\87\202\228\66\26\164", "\224\58\168\133\54\58\146");
					end
				end
				break;
			end
		end
	end
	local function v136()
		local v157 = 0;
		while true do
			if ((v157 == 2) or (1542 < 208)) then
				if ((1612 <= 2926) and v35 and (v15:HealthPercentage() <= v37)) then
					if ((v36 == LUAOBFUSACTOR_DECRYPT_STR_0("\138\39\120\12\33\232\231\177\44\121\94\12\254\238\180\43\112\25\100\203\224\172\43\113\16", "\143\216\66\30\126\68\155")) or (2006 <= 540)) then
						if (v32[LUAOBFUSACTOR_DECRYPT_STR_0("\152\205\11\217\192\176\223\232\164\207\37\206\196\175\222\239\173\248\2\223\204\172\217", "\129\202\168\109\171\165\195\183")]:IsReady() or (2412 == 4677)) then
							if (v24(v33.RefreshingHealingPotion, nil, nil, true) or (4897 <= 1972)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\48\93\49\202\219\7\238\43\86\48\152\214\17\231\46\81\57\223\158\4\233\54\81\56\214\158\16\227\36\93\57\203\215\2\227\98\12", "\134\66\56\87\184\190\116");
							end
						end
					end
				end
				break;
			end
			if ((3101 <= 3584) and (1 == v157)) then
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\138\214\50\72\178\223\7\64\178\203\57", "\44\221\185\64")]:IsReady() and (v15:HolyPower() >= 3) and (v15:HealthPercentage() <= v85) and v68 and not v15:HealingAbsorbed()) or (1568 >= 4543)) then
					if ((4258 >= 1841) and v24(v33.WordofGloryPlayer)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\54\200\111\31\96\4\235\78", "\19\97\135\40\63");
					end
				end
				if ((v32[LUAOBFUSACTOR_DECRYPT_STR_0("\134\89\50\55\59\57\189\72\60\53\42", "\81\206\60\83\91\79")]:IsReady() and v54 and (v15:HealthPercentage() <= v55)) or (3052 >= 3554)) then
					if (v24(v33.Healthstone, nil, nil, true) or (2098 > 3885)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\174\209\126\59\203\94\176\65\165\213\50\43\198\75\161\64\184\217\100\42\131\30", "\196\46\203\176\18\79\163\45");
					end
				end
				v157 = 2;
			end
			if ((v157 == 0) or (2970 == 1172)) then
				if ((3913 > 3881) and (v15:HealthPercentage() <= v63) and v62 and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\117\87\82\242\123\174\134\5\93\69", "\107\57\54\43\157\21\230\231")]:IsCastable()) then
					if ((4932 >= 1750) and v24(v33.LayonHandsPlayer)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\138\8\202\182\210\240\211\138\31\241\170\156\203\222\141\20\251\170\213\217\222", "\175\187\235\113\149\217\188");
					end
				end
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\24\166\151\69\237\124\72\46\160\149\73\224\109\113\51\161", "\24\92\207\225\44\131\25")]:IsCastable() and (v15:HealthPercentage() <= v67) and v66) or (135 == 1669)) then
					if ((4802 >= 109) and v24(v31.DivineProtection)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\218\174\69\21\120\11\195\170\67\15\120\72\199\177\67\21", "\29\43\179\216\44\123");
					end
				end
				v157 = 1;
			end
		end
	end
	local function v137()
		local v158 = 0;
		local v159;
		while true do
			if ((v158 == 2) or (3911 > 4952)) then
				if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\155\39\3\229\241\77\182\38\8\249\194", "\59\211\72\111\156\176")]:IsCastable() or (265 > 4194)) then
					if ((2655 <= 2908) and v24(v31.HolyAvenger)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\136\239\52\113\134\245\40\64\128\230\63\14\132\236\34\66\131\236\58\64\148\163\124\24", "\77\46\231\131");
					end
				end
				v159 = v127.HandleTopTrinket(v124, v119, 40, nil);
				if ((963 > 651) and v159) then
					return v159;
				end
				v158 = 3;
			end
			if ((v158 == 3) or (3503 <= 195)) then
				v159 = v127.HandleBottomTrinket(v124, v119, 40, nil);
				if ((1382 <= 4404) and v159) then
					return v159;
				end
				if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\137\81\164\65\170\92\191\77", "\32\218\52\214")]:IsReady() or (4857 <= 767)) then
					if (v24(v31.Seraphim) or (4018 > 4021)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\93\18\35\169\225\184\76\87\14\20\62\167\253\180\74\77\64\4\113\249\169", "\58\46\119\81\200\145\208\37");
					end
				end
				break;
			end
			if ((v158 == 1) or (2270 == 1932)) then
				if ((v57 and v119 and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\251\22\226\21\52\218\43\251\16\54", "\90\191\127\148\124")]:IsCastable() and v15:BuffUp(v31.AvengingWrathBuff)) or (3430 <= 1176)) then
					if (v24(v31.DivineToll) or (1198 >= 3717)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\124\142\56\30\118\130\17\3\119\139\34\87\123\136\33\27\124\136\57\25\107\199\118", "\119\24\231\78");
					end
				end
				if ((3730 >= 1333) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\160\33\170\69\216\102\4\144\52", "\113\226\77\197\42\188\32")]:IsCastable()) then
					if (v24(v31.BloodFury) or (2152 == 2797)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\26\251\186\62\41\242\160\40\15\180\182\53\25\248\177\53\1\250\166\122\71\166", "\213\90\118\148");
					end
				end
				if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\121\43\166\69\72\73\37\189\88\74", "\45\59\78\212\54")]:IsCastable() or (1709 < 588)) then
					if (v24(v31.Berserking) or (3575 <= 3202)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\83\145\152\131\60\166\249\30\81\195\136\137\33\161\244\31\65\141\152\198\127\249", "\144\112\54\227\235\230\78\205");
					end
				end
				v158 = 2;
			end
			if ((v158 == 0) or (4397 < 3715)) then
				if ((v56 and v119 and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\29\39\12\181\30\226\47\50\11\35\8\175\17", "\85\92\81\105\219\121\139\65")]:IsReady() and not v15:BuffUp(v31.AvengingWrathBuff)) or (4075 <= 2245)) then
					if (v24(v31.AvengingWrath) or (3966 > 4788)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\252\165\85\75\123\214\243\180\111\82\110\222\233\187\16\70\115\208\241\183\95\82\114\204\189\231", "\191\157\211\48\37\28");
					end
				end
				v159 = v131();
				if ((3826 > 588) and v159) then
					return v159;
				end
				v158 = 1;
			end
		end
	end
	local function v138()
		local v160 = 0;
		while true do
			if ((694 <= 1507) and (v160 == 4)) then
				if ((3900 >= 1116) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\51\226\138\72\221\47\48\8\224", "\89\123\141\230\49\141\93")]:IsReady() and v96) then
					if ((4907 > 3311) and v24(v31.HolyPrism, not v17:IsSpellInRange(v31.HolyPrism))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\126\250\21\47\90\225\120\229\1\80\90\225\120\249\30\25\94\234\49\164\84", "\42\147\17\150\108\112");
					end
				end
				if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\46\180\46\126\233\237\59\169\63\109\226\230\27", "\136\111\198\77\31\135")]:IsCastable() or (3408 <= 2617)) then
					if ((3201 == 3201) and v24(v31.ArcaneTorrent)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\27\164\87\179\225\40\189\13\27\181\83\179\240\87\185\16\0\168\68\180\240\14\233\81\89", "\201\98\105\199\54\221\132\119");
					end
				end
				if ((2195 == 2195) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\149\5\132\41\22\58\170\157\13\148\47", "\204\217\108\227\65\98\85")]:IsReady() and v123 and (v15:HolyPower() >= 3) and ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\127\212\244\238\41\206\87\205\242", "\160\62\163\149\133\76")]:IsAvailable() and v127.AreUnitsBelowHealthPercentage(v90, v91)) or (v127.FriendlyUnitsBelowHealthPercentageCount(v85) > 2))) then
					if (v24(v31.LightofDawn, not v17:IsSpellInRange(v31.LightofDawn)) or (3025 > 3506)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\218\169\10\39\215\233\175\11\16\199\215\183\3\111\211\196\169\2\61\202\194\185\77\124\145", "\163\182\192\109\79");
					end
				end
				if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\23\52\21\211\244\48\35\18\243\225\38\47\11\197", "\149\84\70\96\160")]:IsReady() or (736 < 356)) then
					if ((1171 <= 2774) and v24(v31.CrusaderStrike, not v17:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\20\24\254\57\2\8\255\7\21\25\255\49\13\8\173\40\20\4\226\42\15\25\244\120\85\89", "\141\88\102\109");
					end
				end
				v160 = 5;
			end
			if ((4108 >= 312) and (v160 == 0)) then
				if (v119 or (679 > 2893)) then
					local v231 = 0;
					local v232;
					while true do
						if ((v231 == 0) or (876 < 200)) then
							v232 = v137();
							if (v232 or (2325 > 3562)) then
								return v232;
							end
							break;
						end
					end
				end
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\24\132\57\169\165\185\57\45\152\56\169\155\180\49\35\152\53\163\188\174\30\36\128\41", "\86\75\236\80\204\201\221")]:IsReady() and (v15:BuffUp(v31.AvengingWrathBuff) or v15:BuffUp(v31.HolyAvenger) or not v31[LUAOBFUSACTOR_DECRYPT_STR_0("\83\86\118\142\251\133\123\79\112", "\235\18\33\23\229\158")]:IsAvailable())) or (3661 > 4704)) then
					if (v24(v31.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(5)) or (4133 <= 1928)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\178\200\190\92\190\254\180\86\133\213\179\85\133\211\178\87\178\213\190\95\175\210\251\64\168\200\180\66\179\213\162\16\232", "\219\48\218\161");
					end
				end
				if ((4418 >= 1433) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\215\121\117\76\215\75\239\226\101\116\76\233\70\231\236\101\121\70\206\92\200\235\125\101", "\128\132\17\28\41\187\47")]:IsReady() and (HolyPower >= 3) and (v127[LUAOBFUSACTOR_DECRYPT_STR_0("\41\55\7\54\73\9\2\3\40\94\4\60\18\59\90\4", "\61\97\82\102\90")] > v69) and (v127.FriendlyUnitsBelowHealthPercentageCount(v90) < v91)) then
					if (v24(v31.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(5)) or (4123 >= 4123)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\38\162\78\203\83\33\6\170\17\191\67\194\104\12\0\171\38\191\78\200\66\13\73\188\60\162\68\213\94\10\16\236\124", "\105\204\78\203\43\167\55\126");
					end
				end
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\141\171\46\19\22\22\200\87\146\184\34\10\27", "\49\197\202\67\126\115\100\167")]:IsReady() and (v15:HolyPower() < 5) and (v126 == 2)) or (205 >= 2345)) then
					if (v24(v31.HammerofWrath, not v17:IsSpellInRange(v31.HammerofWrath)) or (537 == 1004)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\90\210\36\133\68\97\56\93\224\62\146\87\74\63\27\207\59\137\89\76\62\79\198\105\212", "\62\87\59\191\73\224\54");
					end
				end
				v160 = 1;
			end
			if ((v160 == 1) or (2345 < 545)) then
				if ((1649 > 243) and (LightsHammerLightsHammerUsage == LUAOBFUSACTOR_DECRYPT_STR_0("\215\14\251\208\226\16", "\169\135\98\154"))) then
					if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\231\126\35\92\233\32\224\202\122\41\81\239", "\168\171\23\68\52\157\83")]:IsCastable() and (v126 >= 2)) or (3910 <= 3193)) then
						if ((2005 == 2005) and v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(8))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\248\120\242\165\49\62\184\252\112\248\160\32\63\199\228\99\252\162\55\36\147\237\49\163", "\231\148\17\149\205\69\77");
						end
					end
				elseif ((4688 > 4572) and (LightsHammerLightsHammerUsage == LUAOBFUSACTOR_DECRYPT_STR_0("\163\178\213\232\88\237", "\159\224\199\167\155\55"))) then
					if ((1567 < 3260) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\219\250\59\218\227\224\20\211\250\254\57\192", "\178\151\147\92")]:IsCastable()) then
						if (v24(v33.LightsHammercursor) or (3761 == 621)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\128\244\75\58\6\95\69\132\252\65\63\23\94\58\156\239\69\61\0\69\110\149\189\26", "\26\236\157\44\82\114\44");
						end
					end
				elseif ((4755 > 3454) and (LightsHammerLightsHammerUsage == LUAOBFUSACTOR_DECRYPT_STR_0("\15\32\208\86\51\110\224\85\46\43\199\27\9\59\199\72\37\60", "\59\74\78\181"))) then
					if ((4819 >= 1607) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\9\216\93\82\167\54\249\91\87\190\32\195", "\211\69\177\58\58")]:IsCastable() and v16:Exists() and v15:CanAttack(v16)) then
						if ((4546 >= 1896) and v24(v33.LightsHammercursor)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\187\236\126\253\253\216\136\237\120\248\228\206\165\165\105\231\224\196\165\236\109\236\169\157", "\171\215\133\25\149\137");
						end
					end
				end
				if ((3546 > 933) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\194\199\60\233\234\51\238\67\245\193\61\244", "\34\129\168\82\154\143\80\156")]:IsCastable() and (v126 >= 2) and (v129() <= 0)) then
					if (v24(v31.Consecration, not v17:IsInMeleeRange(5)) or (3985 <= 3160)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\189\61\24\77\77\155\132\166\58\4\70\14\153\151\187\60\25\65\90\144\197\234", "\233\229\210\83\107\40\46");
					end
				end
				if ((1987 == 1987) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\237\75\53\222\17\206\68\22\215\18\207", "\101\161\34\82\182")]:IsReady() and v123 and ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\201\26\88\245\222\236\139\32\239", "\78\136\109\57\158\187\130\226")]:IsAvailable() and v127.AreUnitsBelowHealthPercentage(v90, v91)) or ((v127.FriendlyUnitsBelowHealthPercentageCount(v85) > 2) and ((v15:HolyPower() >= 5) or (v15:BuffUp(v31.HolyAvenger) and (v15:HolyPower() >= 3)))))) then
					if ((994 <= 4540) and v24(v31.LightofDawn)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\50\54\254\249\42\0\246\247\1\59\248\230\48\127\233\227\55\48\235\248\42\38\185\160\110", "\145\94\95\153");
					end
				end
				if ((4917 == 4917) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\206\197\29\208\66\179\242\203\0\221\75\133\244\202\28\193\75\184\232\222\60\218\66\174", "\215\157\173\116\181\46")]:IsReady() and (v126 > 3)) then
					if (v24(v31.ShieldoftheRighteousHoly, not v17:IsInMeleeRange(5)) or (324 > 4896)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\38\188\130\247\214\49\139\132\244\229\33\188\142\205\200\60\179\131\230\223\58\161\152\178\202\39\189\132\224\211\33\173\203\163\136", "\186\85\212\235\146");
					end
				end
				v160 = 2;
			end
			if ((772 < 4670) and (v160 == 2)) then
				if ((3172 >= 2578) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\234\128\27\243\60\252\87\196\182\4\255\45\230", "\56\162\225\118\158\89\142")]:IsReady()) then
					if (v24(v31.HammerofWrath, not v17:IsSpellInRange(v31.HammerofWrath)) or (721 == 834)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\4\205\162\39\202\99\10\198\144\53\202\93\17\200\239\50\202\85\10\210\166\54\193\28\84\148", "\184\60\101\160\207\66");
					end
				end
				if ((1312 < 2654) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\27\151\120\187\60\135\114\168", "\220\81\226\28")]:IsReady()) then
					if ((3213 >= 1613) and v24(v31.Judgment, not v17:IsSpellInRange(v31.Judgment))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\25\192\134\252\231\194\29\193\194\235\248\206\28\199\139\239\243\135\66\131", "\167\115\181\226\155\138");
					end
				end
				if ((LightsHammer == LUAOBFUSACTOR_DECRYPT_STR_0("\210\46\230\69\126\99", "\166\130\66\135\60\27\17")) or (3786 > 4196)) then
					if ((4218 == 4218) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\104\67\201\125\36\87\98\207\120\61\65\88", "\80\36\42\174\21")]:IsCastable()) then
						if ((1517 < 4050) and v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(8))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\66\25\48\114\90\3\8\114\79\29\58\127\92\80\39\104\71\31\37\115\90\9\119\44", "\26\46\112\87");
						end
					end
				elseif ((4390 == 4390) and (LightsHammer == LUAOBFUSACTOR_DECRYPT_STR_0("\154\54\185\103\176\173", "\212\217\67\203\20\223\223\37"))) then
					if ((1919 > 289) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\150\132\175\218\174\158\128\211\183\128\173\192", "\178\218\237\200")]:IsCastable()) then
						if (v24(v33.LightsHammercursor) or (1205 < 751)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\186\188\225\216\162\166\217\216\183\184\235\213\164\245\246\194\191\186\244\217\162\172\166\134", "\176\214\213\134");
						end
					end
				elseif ((LightsHammer == LUAOBFUSACTOR_DECRYPT_STR_0("\209\163\179\217\177\22\108\250\169\179\198\232\117\76\230\190\185\198", "\57\148\205\214\180\200\54")) or (2561 <= 1717)) then
					if ((1723 <= 3600) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\62\244\50\60\98\1\213\52\57\123\23\239", "\22\114\157\85\84")]:IsCastable() and v16:Exists() and v15:CanAttack(v16)) then
						if ((3271 >= 1633) and v24(v33.LightsHammercursor)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\200\194\20\204\73\229\151\204\202\30\201\88\228\232\212\217\26\203\79\255\188\221\139\69", "\200\164\171\115\164\61\150");
						end
					end
				end
				if ((3103 >= 2873) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\157\251\13\86\134\189\230\2\81\138\177\250", "\227\222\148\99\37")]:IsCastable() and (v129() <= 0)) then
					if (v24(v31.Consecration, not v17:IsInMeleeRange(5)) or (3603 == 725)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\93\92\229\252\48\64\83\226\240\60\92\18\230\235\58\93\64\255\237\42\18\0\166", "\153\83\50\50\150");
					end
				end
				v160 = 3;
			end
			if ((2843 == 2843) and (v160 == 5)) then
				if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\144\92\196\99\31\62\71\192\167\90\197\126", "\161\211\51\170\16\122\93\53")]:IsReady() or (174 >= 2515)) then
					if ((4411 >= 2020) and v24(v31.Consecration, not v17:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\161\188\59\254\173\160\41\239\167\189\38\187\190\160\33\244\188\187\60\226\238\225\126", "\72\155\206\210");
					end
				end
				break;
			end
			if ((1347 == 1347) and (v160 == 3)) then
				if ((4461 == 4461) and v58 and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\117\121\127\5\64\163\66\94\125", "\45\61\22\19\124\19\203")]:IsReady() and v17:DebuffDown(v31.GlimmerofLightBuff) and (not v31[LUAOBFUSACTOR_DECRYPT_STR_0("\230\30\4\248\15\117\171\206\20\33\252\5\120\173", "\217\161\114\109\149\98\16")]:IsAvailable() or v130(v17))) then
					if (v24(v31.HolyShock, not v17:IsSpellInRange(v31.HolyShock)) or (4340 == 2872)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\26\47\52\101\131\103\26\47\59\119\252\112\19\45\57\123\185", "\20\114\64\88\28\220");
					end
				end
				if ((568 <= 2207) and v58 and v59 and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\25\14\222\173\203\216\178\50\10", "\221\81\97\178\212\152\176")]:IsReady() and (v127.EnemiesWithDebuffCount(v31.GlimmerofLightBuff, 40) < v60) and v122) then
					if (v127.CastCycle(v31.HolyShock, v125, v130, not v17:IsSpellInRange(v31.HolyShock), nil, nil, v33.HolyShockMouseover) or (3789 <= 863)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\232\17\226\37\222\239\18\248\17\242\228\4\248\22\200\167\25\250\23\204\224\24", "\122\173\135\125\155");
					end
				end
				if ((238 < 4997) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\167\211\21\170\62\53\205\150\242\20\171\54\58\205", "\168\228\161\96\217\95\81")]:IsReady() and (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\248\195\59\79\46\83\222\195\29\72\61\94\208\212", "\55\187\177\78\60\79")]:Charges() == 2)) then
					if ((4285 > 3803) and v24(v31.CrusaderStrike, not v17:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\220\74\248\71\203\133\63\241\76\255\84\198\139\40\142\79\249\79\192\146\36\218\70\171\20\155", "\224\77\174\63\139\38\175");
					end
				end
				if ((2672 < 4910) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\172\78\84\55\180\83\81\61\137", "\78\228\33\56")]:IsReady() and (v126 >= 2) and v96) then
					if (v24(v33.HolyPrismPlayer) or (2956 > 4353)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\198\113\190\26\186\222\108\187\16\136\142\113\188\67\150\203\114\180\67\149\220\119\189\17\140\218\103\242\81\211", "\229\174\30\210\99");
					end
				end
				v160 = 4;
			end
		end
	end
	local function v139()
		local v161 = 0;
		while true do
			if ((3534 > 2097) and (v161 == 0)) then
				if ((3255 >= 534) and (not v14 or not v14:Exists() or not v14:IsInRange(40))) then
					return;
				end
				if ((4254 < 4460) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\106\123\77\1\61\110\123\90\10\32", "\83\38\26\52\110")]:IsCastable() and (v14:HealthPercentage() <= v63) and v62) then
					if (v24(v33.LayonHandsFocus) or (4661 <= 4405)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\22\62\121\87\25\24\78\89\25\35\85\24\20\40\73\84\19\40\81\86\40\47\67\89\27\46\72\95", "\38\56\119\71");
					end
				end
				if ((4575 >= 1943) and (v101 == LUAOBFUSACTOR_DECRYPT_STR_0("\221\224\76\150\17\87\253\228", "\54\147\143\56\182\69"))) then
					if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\244\141\250\90\204\223\143\248\70\217\230\147\240\93\218\213\149\246\70\209", "\191\182\225\159\41")]:IsCastable() and (v14:HealthPercentage() <= v102) and (not v127.UnitGroupRole(v14) == LUAOBFUSACTOR_DECRYPT_STR_0("\31\51\6\126", "\162\75\114\72\53\235\231"))) or (326 > 1137)) then
						if ((1284 == 1284) and v24(v33.BlessingofProtectionFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\142\48\65\241\64\11\130\59\123\237\85\61\156\46\75\246\86\1\152\53\75\236\19\1\131\51\72\230\92\21\130\3\76\231\82\14\133\50\67", "\98\236\92\36\130\51");
						end
					end
				elseif ((v101 == LUAOBFUSACTOR_DECRYPT_STR_0("\148\21\13\163\64\186", "\80\196\121\108\218\37\200\213")) or (3072 >= 3426)) then
					if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\34\127\7\108\88\7\132\7\124\4\79\89\1\158\5\112\22\118\68\0", "\234\96\19\98\31\43\110")]:IsCastable() and (v15:HealthPercentage() <= v102)) or (4036 > 4375)) then
						if ((3928 == 3928) and v24(v33.BlessingofProtectionplayer)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\4\19\87\212\191\123\133\1\32\93\193\147\98\153\9\11\87\196\184\123\132\8\95\81\200\163\126\143\9\8\92\248\164\119\138\10\22\92\192", "\235\102\127\50\167\204\18");
						end
					end
				end
				v161 = 1;
			end
			if ((v161 == 2) or (2629 >= 3005)) then
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\96\235\88\131\77\224\86\134\116\231\75\148\87\235", "\224\34\142\57")]:IsReady() and v127.AreUnitsBelowHealthPercentage(v87, v88) and v86) or (2620 <= 422)) then
					if ((1896 > 1857) and v24(v33.BeaconofVirtueFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\162\196\222\124\255\98\1\216\152\211\212\97\229\72\11\158\164\202\210\127\245\82\25\208\152\205\216\114\253\84\0\217", "\110\190\199\165\189\19\145\61");
					end
				end
				if ((1466 >= 492) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\254\234\110\234\153\194\219\224", "\167\186\139\23\136\235")]:IsReady() and (v127.FriendlyUnitsWithBuffCount(v31.GlimmerofLightBuff, false, false) > v107) and (v127.AreUnitsBelowHealthPercentage(v105, v106) or (v15:ManaPercentage() <= v104)) and v103) then
					if ((868 < 3853) and v24(v31.Daybreak)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\30\180\145\15\8\176\137\6\90\182\135\2\22\177\135\26\20\138\128\8\27\185\129\3\29", "\109\122\213\232");
					end
				end
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\198\246\172\52\225\241\134\57\248\254\172\57\250\238", "\80\142\151\194")]:IsReady() and v127.AreUnitsBelowHealthPercentage(v112, v113) and v111) or (1815 > 4717)) then
					if ((3671 == 3671) and v24(v31.HandofDivinity)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\207\97\69\13\195\72\88\12\202\123\12\0\201\120\64\7\201\96\66\60\206\114\77\15\207\121\75", "\44\99\166\23");
					end
				end
				v161 = 3;
			end
			if ((216 <= 284) and (v161 == 3)) then
				if ((3257 > 2207) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\88\254\63\63\61\161\72\248\37\58", "\196\28\151\73\86\83")]:IsReady() and v127.AreUnitsBelowHealthPercentage(v93, v94) and v92) then
					if (v24(v33.DivineTollFocus) or (2087 < 137)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\247\10\63\25\140\93\39\98\252\15\37\80\129\87\23\122\247\12\62\30\189\80\29\119\255\10\39\23", "\22\147\99\73\112\226\56\120");
					end
				end
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\144\122\238\236\190\176\122\225\254", "\237\216\21\130\149")]:IsReady() and (v14:HealthPercentage() <= v79) and v78) or (3923 >= 4763)) then
					if ((1744 == 1744) and v24(v33.HolyShockFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\138\65\83\70\143\218\86\141\77\84\31\179\198\81\142\74\80\72\190\246\86\135\79\83\86\190\206", "\62\226\46\63\63\208\169");
					end
				end
				if ((248 <= 1150) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\199\21\80\144\12\4\33\89\234\31\102\130\28\31\38\88\236\26\80", "\62\133\121\53\227\127\109\79")]:IsReady() and (v14:GUID() ~= v15:GUID()) and (v14:HealthPercentage() <= v77) and v76) then
					if ((3994 >= 294) and v24(v33.BlessingofSacrificeFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\24\55\230\197\167\172\23\43\61\243\233\189\163\19\6\59\243\223\173\167\80\23\61\250\218\170\173\7\26\13\253\211\175\174\25\26\53", "\194\112\116\82\149\182\206");
					end
				end
				break;
			end
			if ((1641 > 693) and (v161 == 1)) then
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\113\180\231\34\105\47\67\181\240\49\93", "\78\48\193\149\67\36")]:IsCastable() and v127.AreUnitsBelowHealthPercentage(v74, v75) and v73) or (4519 < 2235)) then
					if ((892 < 1213) and v24(v31.AuraMastery)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\11\146\25\126\61\31\147\12\68\34\7\192\27\78\63\18\132\23\86\62\33\136\29\64\60\23\142\31", "\33\80\126\224\120");
					end
				end
				if ((3313 <= 4655) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\205\190\6\202\91\229\166\4\243\78\237\188\11", "\60\140\200\99\164")]:IsCastable() and not v15:BuffUp(v31.AvengingWrathBuff) and v127.AreUnitsBelowHealthPercentage(v71, v72) and v70) then
					if (v24(v31.AvengingWrath) or (3956 < 2705)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\226\1\40\165\142\250\3\25\181\149\245\16\46\226\132\251\11\42\166\136\227\10\25\170\130\245\8\47\172\128", "\194\231\148\100\70");
					end
				end
				if ((1959 < 3037) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\114\85\211\176\210\205\74\69\215\166\228\201\72\79\196", "\168\38\44\161\195\150")]:IsCastable() and v108 and v127.AreUnitsBelowHealthPercentage(v109, v110)) then
					if (v24(v31.TyrsDeliverance) or (1241 > 2213)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\148\229\144\101\15\236\179\26\137\234\135\100\49\230\181\19\192\255\141\121\60\236\185\1\142\195\138\115\49\228\191\24\135", "\118\224\156\226\22\80\136\214");
					end
				end
				v161 = 2;
			end
		end
	end
	local function v140()
		local v162 = 0;
		while true do
			if ((4905 < 4974) and (v162 == 1)) then
				if ((3557 == 3557) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\232\232\188\220\252\217\192\162\215\225\198", "\147\191\135\206\184")]:IsReady() and (v15:HolyPower() >= 3) and v15:BuffUp(v31.UnendingLightBuff) and (v14:HealthPercentage() <= v85) and v68) then
					if ((369 == 369) and v24(v33.WordofGloryFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\147\39\180\197\231\92\180\187\47\170\206\202\74\242\133\39\163\254\208\86\179\136\33\168\198", "\210\228\72\198\161\184\51");
					end
				end
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\26\64\244\24\103\193\48\109\242\7\125", "\174\86\41\147\112\19")]:IsReady() and v123 and (v15:HolyPower() >= 3) and (v127.AreUnitsBelowHealthPercentage(v90, v91) or (v127.FriendlyUnitsBelowHealthPercentageCount(v85) > 2))) or (3589 < 2987)) then
					if ((4378 > 2853) and v24(v31.LightofDawn)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\9\138\3\49\48\30\173\100\4\140\28\43\79\16\164\94\63\133\14\36\3\24\165\92", "\203\59\96\237\107\69\111\113");
					end
				end
				v162 = 2;
			end
			if ((2 == v162) or (1712 > 3602)) then
				if ((4539 >= 2733) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\19\25\190\229\62\246\240\40\25\190\248", "\183\68\118\204\129\81\144")]:IsReady() and (v15:HolyPower() >= 3) and (v14:HealthPercentage() <= v85) and UseWodOfGlory and (v127.FriendlyUnitsBelowHealthPercentageCount(v85) < 3)) then
					if (v24(v33.WordofGloryFocus) or (2599 <= 515)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\25\162\98\224\52\141\8\146\119\232\4\144\23\237\113\235\14\189\6\168\113\232\2\140\9", "\226\110\205\16\132\107");
					end
				end
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\199\202\231\209\85\228\197\244\209\68\198\194\242\205\88\249", "\33\139\163\128\185")]:IsReady() and (v14:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) or (3754 < 810)) then
					if ((1633 <= 1977) and v24(v33.LightoftheMartyrFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\87\8\199\104\75\12\209\84\83\68\221\88\87\8\218\88\79\10\225\95\93\5\210\94\86\3", "\190\55\56\100");
					end
				end
				v162 = 3;
			end
			if ((4528 >= 3619) and (v162 == 3)) then
				if (v127.TargetIsValid() or (172 >= 2092)) then
					local v233 = 0;
					while true do
						if ((2120 == 2120) and (0 == v233)) then
							if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\117\160\50\13\22\224\225\87\187\53\17\29", "\147\54\207\92\126\115\131")]:IsCastable() and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\42\62\57\121\8\112\61\48\33\117", "\30\109\81\85\29\109")]:IsAvailable() and (v129() <= 0)) or (2398 == 358)) then
								if ((2387 < 4637) and v24(v31.Consecration, not v17:IsInMeleeRange(5))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\252\126\90\165\51\221\238\254\101\93\185\56\158\253\240\116\107\190\51\223\240\246\127\83", "\156\159\17\52\214\86\190");
								end
							end
							if ((1265 < 2775) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\132\250\185\187\163\234\179\168", "\220\206\143\221")]:IsReady() and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\172\104\41\16\213\201\220\146\114\43\59\209\203\218\146", "\178\230\29\77\119\184\172")]:IsAvailable() and v17:DebuffDown(v31.JudgmentofLightDebuff)) then
								if (v24(v31.Judgment, not v17:IsSpellInRange(v31.Judgment)) or (4430 < 51)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\255\171\14\28\122\253\251\170\74\26\120\253\202\182\15\26\123\241\251\185", "\152\149\222\106\123\23");
								end
							end
							v233 = 1;
						end
						if ((1871 <= 1998) and (v233 == 1)) then
							if (v127.AreUnitsBelowHealthPercentage(v99, v100) or (2083 >= 3954)) then
								if ((1857 > 59) and (LightsHammerLightsHammerUsage == LUAOBFUSACTOR_DECRYPT_STR_0("\237\42\247\90\176\207", "\213\189\70\150\35"))) then
									if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\99\92\115\0\91\70\92\9\66\88\113\26", "\104\47\53\20")]:IsCastable() or (1232 == 3045)) then
										if ((104 == 104) and v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(8))) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\175\69\134\20\168\28\156\68\128\17\177\10\177\12\145\14\181\0\177\69\149\5\252\89", "\111\195\44\225\124\220");
										end
									end
								elseif ((4534 > 2967) and (LightsHammerLightsHammerUsage == LUAOBFUSACTOR_DECRYPT_STR_0("\251\83\18\96\164\185", "\203\184\38\96\19\203"))) then
									if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\21\122\126\73\218\42\91\120\76\195\60\97", "\174\89\19\25\33")]:IsCastable() or (3449 <= 2368)) then
										if ((4733 >= 3548) and v24(v33.LightsHammercursor)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\35\27\85\70\227\148\52\39\19\95\67\242\149\75\63\0\91\65\229\142\31\54\82\4", "\107\79\114\50\46\151\231");
										end
									end
								elseif ((LightsHammerLightsHammerUsage == LUAOBFUSACTOR_DECRYPT_STR_0("\28\168\176\36\147\121\130\206\61\163\167\105\169\44\165\211\54\180", "\160\89\198\213\73\234\89\215")) or (2005 > 4687)) then
									if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\100\120\179\246\209\91\89\181\243\200\77\99", "\165\40\17\212\158")]:IsCastable() and v16:Exists() and v15:CanAttack(v16)) or (1767 <= 916)) then
										if ((3589 < 3682) and v24(v33.LightsHammercursor)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\233\208\15\59\50\246\230\0\50\43\232\220\26\115\54\247\208\7\33\47\241\192\72\101", "\70\133\185\104\83");
										end
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v162 == 0) or (75 >= 430)) then
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\27\173\77\27\207\236\1\63\158\69\10\212\247\11", "\110\89\200\44\120\160\130")]:IsReady() and v127.AreUnitsBelowHealthPercentage(v87, v88) and v86) or (4157 <= 3219)) then
					if ((1823 < 2782) and v24(v33.BeaconofVirtueFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\198\74\69\76\68\4\66\173\252\93\79\81\94\46\72\235\194\68\67\124\66\62\76\167\202\69\65", "\45\203\163\43\38\35\42\91");
					end
				end
				if ((3434 >= 1764) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\229\138\206\39\136\175\115\222\138\206\58", "\52\178\229\188\67\231\201")]:IsReady() and (v15:HolyPower() >= 3) and v15:BuffUp(v31.EmpyreanLegacyBuff) and (((v14:HealthPercentage() <= v85) and v68) or v127.AreUnitsBelowHealthPercentage(v90, v91))) then
					if ((4040 > 1820) and v24(v33.WordofGloryFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\54\78\66\0\200\83\37\30\70\92\11\229\69\99\32\78\85\59\255\89\34\45\72\94\3", "\67\65\33\48\100\151\60");
					end
				end
				v162 = 1;
			end
		end
	end
	local function v141()
		local v163 = 0;
		while true do
			if ((4192 >= 2529) and (v163 == 1)) then
				if ((1554 < 2325) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\39\86\213\242\13\90\229\250\21\80\209", "\155\99\63\163")]:IsReady() and (v14:HealthPercentage() <= v84) and v83) then
					if ((1108 < 4525) and v24(v31.DivineFavor)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\216\183\132\183\129\189\215\160\155\182\150\194\194\181\178\177\129\131\221\168\131\190", "\228\226\177\193\237\217");
					end
				end
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\18\188\34\245\60\191\37\202\61\183\43\242", "\134\84\208\67")]:IsCastable() and (v14:HealthPercentage() <= v81) and v80) or (4367 <= 3332)) then
					if (v24(v33.FlashofLightFocus, nil, true) or (2896 > 4641)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\21\160\135\79\27\147\137\90\44\160\143\91\27\184\198\79\7\147\142\89\18\160\143\82\20", "\60\115\204\230");
					end
				end
				v163 = 2;
			end
			if ((882 > 21) and (v163 == 2)) then
				if ((2373 <= 4789) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\203\51\236\120\243\53\237\100\239\63\198\113\245\46\242\98", "\16\135\90\139")]:IsReady() and (v14:HealthPercentage() <= LightoftheMartyrkHP) and UseLightoftheMartyr) then
					if (v24(v33.LightoftheMartyrFocus) or (1839 < 1136)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\123\10\42\113\71\112\91\119\13\115\77\91\119\88\112\9\36\64\107\112\81\117\10\58\64\83", "\24\52\20\102\83\46\52");
					end
				end
				if ((3430 == 3430) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\230\46\51\54\6\193\61\46\34\41\197\38\53\44", "\111\164\79\65\68")]:IsCastable() and (v14:HealthPercentage() <= BarrierofFaithHP) and UseBarrierofFaith) then
					if ((748 <= 2288) and v24(v33.BarrierofFaith, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\216\145\204\39\239\212\230\140\216\17\236\199\208\151\214\110\249\210\230\139\219\47\230\207\215\132", "\138\166\185\227\190\78");
					end
				end
				v163 = 3;
			end
			if ((891 < 4473) and (v163 == 3)) then
				if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\237\120\196\36\90\44\31\231\125\194\63\70", "\121\171\20\165\87\50\67")]:IsCastable() and v15:BuffUp(v31.InfusionofLightBuff) and (v14:HealthPercentage() <= v82) and v80) or (3071 <= 2647)) then
					if (v24(v33.FlashofLightFocus, nil, true) or (633 > 1640)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\52\184\37\177\61\201\62\134\58\176\5\206\44\249\37\173\61\206\61\184\58\176\12\193", "\98\166\88\217\86\217");
					end
				end
				if ((3764 > 2404) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\222\249\117\24\182\206\255\229\116", "\188\150\150\25\97\230")]:IsReady() and (v14:HealthPercentage() <= v97) and v95) then
					if (v24(v33.HolyPrismPlayer) or (3811 >= 4158)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\210\134\83\27\51\253\200\128\76\15\76\226\212\201\76\7\0\235\154\153\77\11\3\255\211\157\70\66\94\187", "\141\186\233\63\98\108");
					end
				end
				v163 = 4;
			end
			if ((743 > 47) and (4 == v163)) then
				if ((3599 >= 1059) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\217\229\32\175\9\248\237\36\162", "\69\145\138\76\214")]:IsCastable() and (v14:HealthPercentage() <= v84) and v83) then
					if ((1371 <= 2507) and v24(v33.HolyLightFocus, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\120\192\133\144\128\26\121\200\129\157\255\5\100\240\129\140\190\26\121\193\142", "\118\16\175\233\233\223");
					end
				end
				if (v127.AreUnitsBelowHealthPercentage(v99, v100) or (3607 == 2536)) then
					if ((1126 < 3675) and (v98 == LUAOBFUSACTOR_DECRYPT_STR_0("\187\136\52\162\235\153", "\29\235\228\85\219\142\235"))) then
						if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\17\221\189\213\99\93\15\83\48\217\191\207", "\50\93\180\218\189\23\46\71")]:IsCastable() or (3344 >= 3615)) then
							if (v24(v33.LightsHammerPlayer, not v17:IsInMeleeRange(8)) or (4776 <= 210)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\210\173\92\68\80\207\119\214\165\86\65\65\206\8\206\182\82\67\86\213\92\199\228\13", "\40\190\196\59\44\36\188");
							end
						end
					elseif ((v98 == LUAOBFUSACTOR_DECRYPT_STR_0("\31\80\206\167\245\111", "\109\92\37\188\212\154\29")) or (2613 > 2752)) then
						if ((4542 > 2119) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\40\230\163\203\37\73\44\238\169\206\52\72", "\58\100\143\196\163\81")]:IsCastable()) then
							if (v24(v33.LightsHammercursor) or (1039 == 338)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\22\75\36\171\43\90\218\6\27\79\46\166\45\9\245\28\19\77\49\170\43\80\165\88", "\110\122\34\67\195\95\41\133");
							end
						end
					elseif ((v98 == LUAOBFUSACTOR_DECRYPT_STR_0("\80\191\94\71\207\53\132\85\78\211\103\241\120\95\196\102\190\73", "\182\21\209\59\42")) or (4131 > 4610)) then
						if ((4129 >= 672) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\155\94\194\21\53\173\159\86\200\16\36\172", "\222\215\55\165\125\65")]:IsCastable() and v16:Exists() and v15:CanAttack(v16)) then
							if ((1019 < 3466) and v24(v33.LightsHammercursor)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\32\216\193\18\230\210\210\66\45\220\203\31\224\129\253\88\37\222\212\19\230\216\173\28", "\42\76\177\166\122\146\161\141");
							end
						end
					end
				end
				break;
			end
			if ((290 <= 855) and (v163 == 0)) then
				if ((4601 > 4446) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\51\74\86\46\198\2\98\72\37\219\29", "\169\100\37\36\74")]:IsReady() and (v15:HolyPower() >= 3) and (v14:HealthPercentage() <= v85) and v68) then
					if (v24(v33.WordofGloryFocus) or (995 >= 2099)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\136\176\84\63\136\164\111\7\139\173\66\25\199\177\68\63\143\167\81\12\142\172\87", "\48\96\231\194");
					end
				end
				if ((961 < 4006) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\224\85\2\52\42\208\160\128\195", "\227\168\58\110\77\121\184\207")]:IsReady() and (v14:HealthPercentage() <= v79) and v78) then
					if ((2694 < 4854) and v24(v33.HolyShockFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\115\51\179\89\142\200\121\170\120\55\255\83\165\228\121\160\122\48\182\78\182", "\197\27\92\223\32\209\187\17");
					end
				end
				v163 = 1;
			end
		end
	end
	local function v142()
		local v164 = 0;
		local v165;
		while true do
			if ((v164 == 1) or (4174 <= 3733)) then
				if (v165 or (2626 <= 648)) then
					return v165;
				end
				v165 = v141();
				v164 = 2;
			end
			if ((1595 <= 2078) and (0 == v164)) then
				if ((1635 > 653) and (not v14 or not v14:Exists() or not v14:IsInRange(40))) then
					return;
				end
				v165 = v140();
				v164 = 1;
			end
			if ((3738 == 3738) and (v164 == 2)) then
				if (v165 or (3963 > 4742)) then
					return v165;
				end
				break;
			end
		end
	end
	local function v143()
		local v166 = 0;
		local v167;
		while true do
			if ((v166 == 2) or (4072 > 4695)) then
				v167 = v127.HandleChromie(v31.Cleanse, v33.CleanseMouseover, 40);
				if (v167 or (2220 > 2889)) then
					return v167;
				end
				v167 = v127.HandleChromie(v31.HolyShock, v33.HolyShockMouseover, 40);
				v166 = 3;
			end
			if ((v166 == 8) or (4914 < 4399)) then
				v167 = v133();
				if ((3660 == 3660) and v167) then
					return v167;
				end
				v167 = v142();
				v166 = 9;
			end
			if ((2915 >= 196) and (v166 == 6)) then
				if ((v116 ~= LUAOBFUSACTOR_DECRYPT_STR_0("\39\162\51\118", "\19\105\205\93")) or (4638 < 3902)) then
					if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\139\13\223\130\48\167\7\216\173\54\174\0\202", "\95\201\104\190\225")]:IsCastable() and (v127.NamedUnit(40, v116, 30) ~= nil) and v127.NamedUnit(40, v116, 30):BuffDown(v31.BeaconofLight)) or (1100 >= 1292)) then
						if (v24(v33.BeaconofLightMacro) or (547 > 3511)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\173\206\192\205\160\197\254\193\169\244\205\199\168\195\213\142\172\196\204\204\174\223", "\174\207\171\161");
						end
					end
				end
				if ((v117 ~= LUAOBFUSACTOR_DECRYPT_STR_0("\195\241\3\246", "\183\141\158\109\147\152")) or (314 > 2132)) then
					if ((932 == 932) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\14\12\231\15\35\7\233\10\10\8\239\24\36", "\108\76\105\134")]:IsCastable() and (v127.NamedUnit(40, v117, 30) ~= nil) and v127.NamedUnit(40, v117, 30):BuffDown(v31.BeaconofFaith)) then
						if (v24(v33.BeaconofFaithMacro) or (2939 == 4366)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\233\192\176\226\193\229\250\190\231\241\237\196\184\245\198\171\198\190\236\204\234\209", "\174\139\165\209\129");
						end
					end
				end
				v167 = v136();
				v166 = 7;
			end
			if ((0 == v166) or (3969 <= 3657)) then
				if ((v127.GetCastingEnemy(v31.BlackoutBarrelDebuff) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\135\134\0\221\106\127\171\141\10\200\95\100\160\143\1\193\116", "\22\197\234\101\174\25")]:IsReady()) or (1379 == 1462)) then
					local v234 = 0;
					local v235;
					while true do
						if ((v234 == 0) or (4606 <= 3927)) then
							v235 = v127.FocusSpecifiedUnit(v127.GetUnitsTargetFriendly(v127.GetCastingEnemy(v31.BlackoutBarrelDebuff)), 40);
							if (v235 or (1578 <= 1012)) then
								return v235;
							end
							v234 = 1;
						end
						if ((v234 == 1) or (2399 > 3386)) then
							if ((v14 and UnitIsUnit(v14:ID(), v127.GetUnitsTargetFriendly(v127.GetCastingEnemy(v31.BlackoutBarrelDebuff)):ID())) or (3476 > 4701)) then
								if (v24(v33.BlessingofFreedomFocus) or (4374 <= 3729)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\47\56\160\207\101\166\217\129\18\59\163\227\112\189\210\131\41\59\168\156\117\160\218\132\44\32", "\230\77\84\197\188\22\207\183");
								end
							end
							break;
						end
					end
				end
				v167 = v127.FocusUnitWithDebuffFromList(v19[LUAOBFUSACTOR_DECRYPT_STR_0("\201\21\202\253\136\168\254", "\85\153\116\166\156\236\193\144")].FreedomDebuffList, 40, 20);
				if (v167 or (4938 <= 1325)) then
					return v167;
				end
				v166 = 1;
			end
			if ((v166 == 1) or (2930 > 4142)) then
				if ((583 >= 133) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\134\236\72\160\247\9\170\231\66\181\194\18\161\229\73\188\233", "\96\196\128\45\211\132")]:IsReady() and v127.UnitHasDebuffFromList(v14, v19[LUAOBFUSACTOR_DECRYPT_STR_0("\5\140\119\94\214\166\186", "\184\85\237\27\63\178\207\212")].FreedomDebuffList)) then
					if ((432 == 432) and v24(v33.BlessingofFreedomFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\85\12\76\27\80\7\88\55\86\15\96\14\75\12\90\12\86\4\31\11\86\4\93\9\77", "\63\104\57\105");
					end
				end
				if ((1456 <= 4224) and v42) then
					local v236 = 0;
					while true do
						if ((v236 == 0) or (1698 >= 2384)) then
							v167 = v134();
							if ((2711 < 3812) and v167) then
								return v167;
							end
							break;
						end
					end
				end
				if (v44 or (746 >= 2339)) then
					local v237 = 0;
					while true do
						if ((3002 >= 894) and (v237 == 3)) then
							v167 = v127.HandleAfflicted(v31.FlashofLight, v33.FlashofLightMouseover, 40);
							if (v167 or (1376 <= 1032)) then
								return v167;
							end
							v237 = 4;
						end
						if ((2427 == 2427) and (v237 == 0)) then
							v167 = v127.HandleAfflicted(v31.Cleanse, v33.CleanseMouseover, 40);
							if ((3491 > 3393) and v167) then
								return v167;
							end
							v237 = 1;
						end
						if ((v237 == 4) or (3885 > 4312)) then
							v167 = v127.HandleAfflicted(v31.HolyLight, v33.HolyLightMouseover, 40);
							if (v167 or (2128 < 1754)) then
								return v167;
							end
							break;
						end
						if ((v237 == 2) or (4584 <= 3272)) then
							v167 = v127.HandleAfflicted(v31.WordofGlory, v33.WordofGloryMouseover, 40);
							if ((1043 <= 3558) and v167) then
								return v167;
							end
							v237 = 3;
						end
						if ((71 == 71) and (v237 == 1)) then
							v167 = v127.HandleAfflicted(v31.HolyShock, v33.HolyShockMouseover, 40);
							if ((2793 == 2793) and v167) then
								return v167;
							end
							v237 = 2;
						end
					end
				end
				v166 = 2;
			end
			if ((v166 == 5) or (561 > 911)) then
				if (v167 or (677 >= 4143)) then
					return v167;
				end
				if ((4422 > 2292) and v45) then
					local v238 = 0;
					while true do
						if ((v238 == 0) or (3386 <= 2556)) then
							v167 = v127.HandleIncorporeal(v31.Repentance, v33.RepentanceMouseover, 30, true);
							if (v167 or (4932 < 902)) then
								return v167;
							end
							v238 = 1;
						end
						if ((v238 == 1) or (503 >= 1425)) then
							v167 = v127.HandleIncorporeal(v31.TurnEvil, v33.TurnEvilMouseover, 30, true);
							if ((4871 == 4871) and v167) then
								return v167;
							end
							break;
						end
					end
				end
				if ((2515 > 2280) and v46) then
					if ((3008 == 3008) and v15:DebuffUp(v31.Entangled) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\41\139\161\87\24\142\170\67\4\129\130\86\14\130\160\75\6", "\36\107\231\196")]:IsReady()) then
						if ((295 < 775) and v24(v33.BlessingofFreedomPlayer)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\95\185\167\148\78\188\172\128\98\186\164\184\91\167\167\130\89\186\175\199\94\186\175\133\92\161", "\231\61\213\194");
						end
					end
				end
				v166 = 6;
			end
			if ((v166 == 9) or (4828 <= 3019)) then
				if ((2317 >= 2150) and v167) then
					return v167;
				end
				if (v127.TargetIsValid() or (3148 == 739)) then
					local v239 = 0;
					while true do
						if ((4576 < 4666) and (v239 == 1)) then
							v167 = v138();
							if (v167 or (3843 == 3030)) then
								return v167;
							end
							break;
						end
						if ((2522 > 1584) and (v239 == 0)) then
							v167 = v137();
							if ((3245 == 3245) and v167) then
								return v167;
							end
							v239 = 1;
						end
					end
				end
				break;
			end
			if ((v166 == 7) or (4458 <= 2954)) then
				if (v167 or (2080 <= 467)) then
					return v167;
				end
				v167 = v139();
				if ((58 < 618) and v167) then
					return v167;
				end
				v166 = 8;
			end
			if ((v166 == 4) or (891 > 3655)) then
				v167 = v127.HandleChromie(v31.FlashofLight, v33.FlashofLightMouseover, 40);
				if (v167 or (4287 < 3622)) then
					return v167;
				end
				v167 = v127.HandleChromie(v31.HolyLight, v33.HolyLightMouseover, 40);
				v166 = 5;
			end
			if ((34 <= 2569) and (v166 == 3)) then
				if (v167 or (2876 == 1323)) then
					return v167;
				end
				v167 = v127.HandleChromie(v31.WordofGlory, v33.WordofGloryMouseover, 40);
				if ((2030 == 2030) and v167) then
					return v167;
				end
				v166 = 4;
			end
		end
	end
	local function v144()
		local v168 = 0;
		while true do
			if ((v168 == 4) or (2040 == 682)) then
				if (v127.TargetIsValid() or (269 > 2382)) then
					local v240 = 0;
					local v241;
					while true do
						if ((836 < 4132) and (v240 == 0)) then
							v241 = v135();
							if ((2989 >= 1063) and v241) then
								return v241;
							end
							break;
						end
					end
				end
				break;
			end
			if ((2406 <= 3221) and (1 == v168)) then
				ShouldReturn = v127.HandleChromie(v31.HolyShock, v33.HolyShockMouseover, 40);
				if ((3567 < 4459) and ShouldReturn) then
					return ShouldReturn;
				end
				ShouldReturn = v127.HandleChromie(v31.WordofGlory, v33.WordofGloryMouseover, 40);
				if (ShouldReturn or (1860 >= 2065)) then
					return ShouldReturn;
				end
				v168 = 2;
			end
			if ((v168 == 2) or (2123 >= 4894)) then
				ShouldReturn = v127.HandleChromie(v31.FlashofLight, v33.FlashofLightMouseover, 40);
				if ((3619 == 3619) and ShouldReturn) then
					return ShouldReturn;
				end
				ShouldReturn = v127.HandleChromie(v31.HolyLight, v33.HolyLightMouseover, 40);
				if ((2132 < 3335) and ShouldReturn) then
					return ShouldReturn;
				end
				v168 = 3;
			end
			if ((0 == v168) or (4477 <= 3601)) then
				if (v42 or (3478 == 589)) then
					local v242 = 0;
					while true do
						if ((1732 >= 130) and (v242 == 0)) then
							ShouldReturn = v134();
							if (ShouldReturn or (867 > 3215)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if ((665 <= 4541) and v44) then
					local v243 = 0;
					while true do
						if ((1089 <= 3455) and (4 == v243)) then
							ShouldReturn = v127.HandleAfflicted(v31.HolyLight, v33.HolyLightMouseover, 40);
							if (ShouldReturn or (3522 < 2146)) then
								return ShouldReturn;
							end
							break;
						end
						if ((v243 == 3) or (3491 <= 3258)) then
							ShouldReturn = v127.HandleAfflicted(v31.FlashofLight, v33.FlashofLightMouseover, 40);
							if (ShouldReturn or (4449 < 3644)) then
								return ShouldReturn;
							end
							v243 = 4;
						end
						if ((2 == v243) or (153 >= 1887)) then
							ShouldReturn = v127.HandleAfflicted(v31.WordofGlory, v33.WordofGloryMouseover, 40);
							if ((1765 > 640) and ShouldReturn) then
								return ShouldReturn;
							end
							v243 = 3;
						end
						if ((200 < 4059) and (v243 == 1)) then
							ShouldReturn = v127.HandleAfflicted(v31.HolyShock, v33.HolyShockMouseover, 40);
							if (ShouldReturn or (3210 <= 1400)) then
								return ShouldReturn;
							end
							v243 = 2;
						end
						if ((1380 < 3863) and (v243 == 0)) then
							ShouldReturn = v127.HandleAfflicted(v31.Cleanse, v33.CleanseMouseover, 40);
							if ((183 <= 3341) and ShouldReturn) then
								return ShouldReturn;
							end
							v243 = 1;
						end
					end
				end
				ShouldReturn = v127.HandleChromie(v31.Cleanse, v33.CleanseMouseover, 40);
				if (ShouldReturn or (426 > 3276)) then
					return ShouldReturn;
				end
				v168 = 1;
			end
			if ((v168 == 3) or (3592 == 4092)) then
				if ((3380 == 3380) and v45) then
					local v244 = 0;
					while true do
						if ((4841 >= 4597) and (v244 == 1)) then
							ShouldReturn = v127.HandleIncorporeal(v31.TurnEvil, v33.TurnEvilMouseover, 30, true);
							if ((3962 == 3962) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
						if ((v244 == 0) or (3057 <= 2101)) then
							ShouldReturn = v127.HandleIncorporeal(v31.Repentance, v33.RepentanceMouseover, 30, true);
							if (ShouldReturn or (3977 >= 4688)) then
								return ShouldReturn;
							end
							v244 = 1;
						end
					end
				end
				if (v46 or (774 < 455)) then
					if ((v15:DebuffUp(v31.Entangled) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\129\191\231\210\213\10\126\127\172\181\196\211\195\6\116\119\174", "\24\195\211\130\161\166\99\16")]:IsReady()) or (832 == 2347)) then
						if (v24(v33.BlessingofFreedomPlayer) or (1934 == 2777)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\68\15\236\63\64\31\72\4\214\35\85\41\64\17\236\41\87\25\75\67\230\57\71\86\73\5\169\47\92\27\68\2\253", "\118\38\99\137\76\51");
						end
					end
				end
				if (v118 or (604 == 4669)) then
					local v245 = 0;
					local v246;
					while true do
						if ((v245 == 0) or (2088 > 2395)) then
							if ((1992 <= 2618) and (v116 ~= LUAOBFUSACTOR_DECRYPT_STR_0("\211\41\11\23", "\64\157\70\101\114\105"))) then
								if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\98\173\166\224\31\78\167\161\207\25\71\160\179", "\112\32\200\199\131")]:IsCastable() and (v127.NamedUnit(40, v116, 30) ~= nil) and v127.NamedUnit(40, v116, 30):BuffDown(v31.BeaconofLight)) or (3318 == 418)) then
									if (v24(v33.BeaconofLightMacro) or (4067 <= 2537)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\46\85\93\187\204\165\29\35\86\99\180\202\172\42\56\16\95\183\206\169\35\56", "\66\76\48\60\216\163\203");
									end
								end
							end
							if ((v117 ~= LUAOBFUSACTOR_DECRYPT_STR_0("\148\137\119\246", "\68\218\230\25\147\63\174")) or (4169 <= 4060)) then
								if ((v31[LUAOBFUSACTOR_DECRYPT_STR_0("\143\47\82\79\185\163\37\85\106\183\164\62\91", "\214\205\74\51\44")]:IsCastable() and (v127.NamedUnit(40, v117, 30) ~= nil) and v127.NamedUnit(40, v117, 30):BuffDown(v31.BeaconofFaith)) or (86 >= 606)) then
									if (v24(v33.BeaconofFaithMacro) or (153 >= 2453)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\248\73\227\255\120\244\115\237\250\72\252\77\235\232\127\186\79\237\241\117\251\88", "\23\154\44\130\156");
									end
								end
							end
							v245 = 1;
						end
						if ((v245 == 1) or (2676 >= 4227)) then
							v246 = v142();
							if (v246 or (283 >= 2823)) then
								return v246;
							end
							break;
						end
					end
				end
				if ((4242 > 366) and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\53\163\187\161\34\26\30\168\140\187\36\18", "\115\113\198\205\206\86")]:IsCastable() and v15:BuffDown(v31.DevotionAura)) then
					if ((4712 == 4712) and v24(v31.DevotionAura)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\128\82\232\85\144\94\241\84\187\86\235\72\133", "\58\228\55\158");
					end
				end
				v168 = 4;
			end
		end
	end
	local function v145()
		local v169 = 0;
		while true do
			if ((3335 >= 2992) and (v169 == 7)) then
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\229\166\173\1\48\248\243", "\94\159\128\210\217\104")][LUAOBFUSACTOR_DECRYPT_STR_0("\101\234\3\158\74\109\248\87\81\234\18\186\77\102", "\26\48\153\102\223\63\31\153")];
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\49\69\249\231\11\78\234\224", "\147\98\32\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\86\241\203\43\87\88\12\70\241\211\14\126\123", "\43\120\35\131\170\102\54")] or 0;
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\103\3\147\162\172\190\131\71", "\228\52\102\231\214\197\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\63\245\103\203\199\138\10\194\27\242\108\237\248\132\12\198", "\182\126\128\21\170\138\235\121")] or 0;
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\223\33\242\143\29\55\21", "\102\235\186\85\134\230\115\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\98\31\59\125\126\209\49\68\5\48\88\93\210\17\86\15\44\86\116\221\33\82", "\66\55\108\94\63\18\180")];
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\39\136\145\35\46\87\19\158", "\57\116\237\229\87\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\189\232\244\100\231\73\173\158\235\212\118\237\85\163\183\228\228\114\198\119", "\39\202\209\141\135\23\142")] or 0;
				v169 = 8;
			end
			if ((1482 >= 1460) and (v169 == 6)) then
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\230\156\41\64\84\53\240", "\58\82\131\232\93\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\182\68\213\34\82\45\135\120\214\50\81\48\145\78", "\95\227\55\176\117\61")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\43\123\55\95\162\22\121\48", "\203\120\30\67\43")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\42\95\235\214\247\2\65\224\203\232\33\101\223", "\185\145\69\45\143")] or 0;
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\185\26\13\178\213\132\24\10", "\188\234\127\121\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\33\22\162\46\55\29\132\49\60\20\180\42\51\7\139", "\227\88\82\115")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\112\26\174\179\11\125\68\12", "\19\35\127\218\199\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\61\237\15\236\27\242\4\229\43\233\11\246\20\211\58", "\130\124\155\106")] or 0;
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\230\206\226\187\170\248\123\172", "\223\181\171\150\207\195\150\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\44\230\160\14\69\52\228\153\27\77\46\235\137\27\67\47\243", "\105\44\90\131\206")] or 0;
				v169 = 7;
			end
			if ((v169 == 4) or (171 >= 4691)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\62\249\6\241\56\196\40", "\86\163\91\141\114\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\102\24\113\91\53\95\18\71\123\53\80\0\91\117\60\86\5\103\122\44\86\7\109", "\90\51\107\20\19")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\245\145\251\52\131\247\150", "\93\237\144\229\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\32\229\245\49\4\74\12\197\248\22\8\77\54\239\243\21\14", "\38\117\150\144\121\107")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\190\250\46\36\181\233\41", "\90\77\219\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\23\36\17\67\11\99\213\12\46\58\71\32\104\233\17\49", "\26\134\100\65\89\44\103")] or 0;
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\230\36\55\173\255\228\35", "\196\145\131\80\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\43\163\3\32\23\228\7\131\14\7\27\227\44\181\0\26\29\251\22\159\8\4\1", "\136\126\208\102\104\120")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\143\218\87\166\92\58\66", "\49\24\234\174\35\207\50\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\225\248\164\112\21\221\243\160\112\2\246\238", "\17\108\146\157\232")];
				v169 = 5;
			end
			if ((v169 == 8) or (2173 > 4840)) then
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\54\29\30\59\246\248\32", "\152\159\83\105\106\82")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\213\84\218\198\80\152\245\89\253\202\87", "\60\225\166\49\146\169")];
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\27\59\62\8\9\40\13", "\103\79\126\79\74\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\146\112\223\106\109\18\181\124\216\91\110", "\122\218\31\179\19\62")] or 0;
				break;
			end
			if ((3 == v169) or (3884 < 1346)) then
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\182\179\11\129\253\247\170", "\144\217\211\199\127\232\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\209\33\42\45\199\87\23\84\236\27\54\58\208\86\10\75\244\43", "\36\152\79\94\72\181\37\98")] or 0;
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\221\83\43\222\214\64\44", "\95\183\184\39")][LUAOBFUSACTOR_DECRYPT_STR_0("\128\44\226\14\81\129\14\161\55\244\50\91\142\7", "\98\213\95\135\70\52\224")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\205\166\221\99\93\240\164\218", "\52\158\195\169\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\82\185\51\120\146\61\104\159\117\178\55\92\182", "\235\26\220\82\20\230\85\27")] or 0;
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\187\164\253\214\125\134\166\250", "\20\232\193\137\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\204\192\135\241\137\25\118\43\209\194\145\245\141\3\121\13\217\195\163\233\159\30\103\39\211\220", "\17\66\191\165\198\135\236\119")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\60\170\186\7\246\230\235\194", "\177\111\207\206\115\159\136\140")][LUAOBFUSACTOR_DECRYPT_STR_0("\48\154\21\48\221\89\86\11\140\36\27\216\67\112\3\143\21\26\199\70\73\0\133\9", "\63\101\233\112\116\180\47")];
				v169 = 4;
			end
			if ((3360 == 3360) and (v169 == 1)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\221\2\205\177\94\139\203", "\48\236\184\118\185\216")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\174\82\17\193\51\224\177\94\51\233\49\228\169\95\53\221", "\84\133\221\55\80\175")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\226\48\178\206\82\186\244", "\60\221\135\68\198\167")][LUAOBFUSACTOR_DECRYPT_STR_0("\219\174\253\161\77\221\247\156\246\135\113\214\251\177", "\185\142\221\152\227\34")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\192\67\238\74\61\240\75", "\151\56\165\55\154\35\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\76\19\235\173\70\11\250\132\70\9\239\185", "\142\192\35\101")] or 0;
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\112\61\183\238\130\171\5", "\118\182\21\73\195\135\236\204")][LUAOBFUSACTOR_DECRYPT_STR_0("\44\53\9\80\1\1\217\13\62\15\70\2\30", "\157\104\92\122\32\100\109")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\144\163\219\222\52\41\138\184", "\203\195\198\175\170\93\71\237")][LUAOBFUSACTOR_DECRYPT_STR_0("\10\66\45\197\84\29\222\59\77\56\198", "\156\78\43\94\181\49\113")];
				v169 = 2;
			end
			if ((1082 <= 2816) and (0 == v169)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\135\140\196\58\53\163\50\167", "\85\212\233\176\78\92\205")][LUAOBFUSACTOR_DECRYPT_STR_0("\127\75\141\208\75\91\129\227\70\75", "\130\42\56\232")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\217\176\48\247\73\49\237\166", "\95\138\213\68\131\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\31\59\164\107\115\43\36\168\77\113\26\39\181\74\121\36", "\22\74\72\193\35")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\124\240\76\37\119\227\75", "\56\76\25\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\196\170\42\198\80\198\155\41\219\87\206\165\8\206\83\196", "\175\62\161\203\70")] or "";
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\216\215\7\60\50\218\208", "\85\92\189\163\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\1\169\49\52\32\162\55\8\38\184\57\55\39\132\0", "\88\73\204\80")] or 0;
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\134\4\82\32\212\41\144", "\186\78\227\112\38\73")][LUAOBFUSACTOR_DECRYPT_STR_0("\201\68\248\101\92\109\249\69\202\90\65\126\218\88\239\65\90\110\233\83\248", "\26\156\55\157\53\51")];
				v169 = 1;
			end
			if ((v169 == 2) or (3830 >= 4328)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\65\237\208\183\2\77\126\97", "\25\18\136\164\195\107\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\192\44\167\75\126\185\224\190\238\33\160\76\102\185\197", "\216\136\77\201\47\18\220\161")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\233\63\206\1\210\133\62", "\226\77\140\75\186\104\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\207\222\59\67\188\231\222\60\64\171\222\223\45\74\184\194", "\47\217\174\176\95")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\216\98\22\187\90\127\53", "\70\216\189\22\98\210\52\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\222\173\131\223\223\250\173\147\210\212\216\175\142\221\221", "\179\186\191\195\231")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\58\12\240\240\49\31\247", "\132\153\95\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\188\26\40\229\200\181\161\166\57\36\227\210\147\165\167\0", "\192\209\210\110\77\151\186")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\211\6\54\253\246\202\231\16", "\164\128\99\66\137\159")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\135\253\187\18\155\252\174\20\166\231\178\25\190\225\183\20\140\229\183\19\157", "\222\96\233\137")];
				v169 = 3;
			end
			if ((v169 == 5) or (1099 >= 4754)) then
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\198\0\249\38\166\76\208", "\200\43\163\116\141\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\55\36\172\190\220\226\177\50\46\171\128", "\131\223\86\93\227\208\148")] or 0;
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\208\64\162\162\20\187\228\86", "\213\131\37\214\214\125")][LUAOBFUSACTOR_DECRYPT_STR_0("\19\56\32\155\232\48\34\43\186\209\52\36\49\186\226\50\34\42\177", "\129\70\75\69\223")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\206\231\253\117\225\65\216", "\143\38\171\147\137\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\139\175\250\13\230\228\194\141\173\246\0\247\221\223\140\145\195", "\180\176\226\217\147\99\131")] or 0;
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\224\188\59\19\218\183\40\20", "\103\179\217\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\127\164\25\241\72\154\170\68\178\47\221\72\137\175\78", "\195\42\215\124\181\33\236")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\92\35\42\44\246\10\74", "\152\109\57\87\94\69")][LUAOBFUSACTOR_DECRYPT_STR_0("\221\222\28\170\176\215\103\160\240\210\6\167\150\226", "\200\153\183\106\195\222\178\52")] or 0;
				v169 = 6;
			end
		end
	end
	local function v146()
		local v170 = 0;
		while true do
			if ((4871 <= 4892) and (v170 == 8)) then
				v111 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\36\54\157\28\30\61\142\27", "\104\119\83\233")][LUAOBFUSACTOR_DECRYPT_STR_0("\192\235\34\10\66\251\252\8\36\103\252\238\46\44\74\225\225", "\35\149\152\71\66")];
				v112 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\237\86\164\51\23\239\81", "\90\121\136\34\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\15\91\26\232\8\113\23\209\7\91\23\211\23\125\46", "\126\167\110\53")] or 0;
				v113 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\14\21\58\236\213\49\58\3", "\95\93\112\78\152\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\244\139\17\203\184\246\200\227\140\27\237\170\203\230\231\138\0\244", "\178\161\149\229\117\132\222")] or 0;
				v114 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\187\222\201\184\168\24\161\48", "\67\232\187\189\204\193\118\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\190\61\176\2\58\16\253\130\43\167\15\61\36\238\130\58\189", "\143\235\78\213\64\91\98")];
				v170 = 9;
			end
			if ((v170 == 1) or (2393 <= 1632)) then
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\140\208\149\136\219\196\154", "\181\163\233\164\225\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\120\132\50\110\124\130\57\127\68\163\14", "\23\48\235\94")] or 0;
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\79\223\204\73\94\61\213\111", "\178\28\186\184\61\55\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\241\222\66\11\253\28\241\235\203\96\48\253\28\236", "\149\164\173\39\92\146\110")];
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\192\34\4\11\19\21\244\52", "\123\147\71\112\127\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\194\144\117\105\202\234\142\126\84\213\229\178", "\38\172\173\226\17")] or 0;
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\126\20\56\251\68\31\43\252", "\143\45\113\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\171\25\30\189\185\31\51\182\151\26\10\177\170\8\41\189", "\92\216\216\124")];
				v170 = 2;
			end
			if ((2414 == 2414) and (v170 == 0)) then
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\211\217\213\192\175\66\160", "\37\211\182\173\161\169\193")][LUAOBFUSACTOR_DECRYPT_STR_0("\194\41\72\255\36\122\170\255\21\75\245\33\124\177\227", "\217\151\90\45\185\72\27")];
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\121\243\6\95\205\123\244", "\54\163\28\135\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\14\215\92\145\70\80\46\247\84\133\70\107\0\235", "\31\72\187\61\226\46")] or 0;
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\3\87\198\78\112\35\208", "\68\163\102\35\178\39\30")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\124\219\212\11\154\133\61\183\119\210\211\42\187\133\4\173\121\213\201\43\133", "\113\222\16\186\167\99\213\227")] or 0;
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\11\239\226\39\0\252\229", "\150\78\110\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\176\214\34\201\171\18\166\108\140\194\47\245", "\32\229\165\71\129\196\126\223")];
				v170 = 1;
			end
			if ((1584 == 1584) and (v170 == 3)) then
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\163\243\211\112\185\209\181", "\215\182\198\135\167\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\161\64\237\64\153\102\236\108\140\94\228\111\159\70\255\88", "\40\237\41\138")] or 0;
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\244\113\238\236\67\201\115\233", "\42\167\20\154\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\127\237\167\102\120\55\67\240\167\118\126\45\70", "\65\42\158\194\34\17")];
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\34\70\24\36\227\28\253", "\142\122\71\50\108\77\141\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\49\171\233\17\53\16\150\240\20\55\61\146", "\91\117\194\159\120")] or 0;
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\24\42\12\60\255\35\9", "\68\122\125\94\120\85\145")][LUAOBFUSACTOR_DECRYPT_STR_0("\51\21\217\87\198\220\142\24\16\195\121\218\214\175\7", "\218\119\124\175\62\168\185")] or 0;
				v170 = 4;
			end
			if ((2285 > 2073) and (v170 == 7)) then
				v107 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\209\96\61\216\248\36\199", "\150\67\180\20\73\177")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\25\3\79\159\29\27\70\170\10\21\88\157", "\45\237\120\122")] or 0;
				v108 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\237\182\56\222\230\165\63", "\76\183\136\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\79\245\224\12\73\93\7\94\227\233\49\70\74\6\123\232\230\61", "\116\26\134\133\88\48\47")];
				v109 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\196\180\240\180\124\25\210", "\18\126\161\192\132\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\49\188\23\114\90\36\167\18\83\77\41\160\7\83\119\24", "\54\63\72\206\100")] or 0;
				v110 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\92\81\110\236\117\207\74", "\27\168\57\37\26\133")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\179\110\187\243\40\166\117\190\210\63\171\114\171\210\10\184\115\189\199", "\183\77\202\28\200")] or 0;
				v170 = 8;
			end
			if ((v170 == 4) or (2894 < 2799)) then
				v95 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\245\92\208\172\254\79\215", "\164\197\144\40")][LUAOBFUSACTOR_DECRYPT_STR_0("\182\227\175\163\210\186\154\192\184\130\206\187", "\214\227\144\202\235\189")];
				v96 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\160\147\111\25\189\84\47", "\92\141\197\231\27\112\211\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\236\143\139\222\234\230\186\177\216\245\242\165\165\215\227\241\153\170\199\227\243\147", "\177\134\159\234\195")];
				v97 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\238\43\180\192\179\236\44", "\169\221\139\95\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\132\115\38\18\52\215\152\114\23\18", "\70\190\235\31\95\66")] or 0;
				v98 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\231\14\242\236\180\229\9", "\133\218\130\122\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\16\246\228\204\200\176\16\61\242\238\193\206\150\43\61\248\230", "\88\92\159\131\164\188\195")] or "";
				v170 = 5;
			end
			if ((v170 == 2) or (1275 > 3605)) then
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\55\184\84\244\85\53\191", "\157\59\82\204\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\26\59\226\249\230\228\252\183\14\55\241\238\252\239\251\129", "\209\88\94\131\154\137\138\179")] or 0;
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\27\164\208\104\23\45\54\49", "\66\72\193\164\28\126\67\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\41\169\91\41\120\200\42\158\81\52\98\242\41\143\74\41\99\247", "\22\135\76\200\56\70")] or 0;
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\53\236\48\84\239\138\35", "\129\237\80\152\68\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\100\187\1\223\21\16\80\69\135\2\215\29\0\86", "\56\49\200\100\147\124\119")];
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\255\59\171\228\197\48\184\227", "\144\172\94\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\8\6\165\79\48\32\164\99\37\24\172\79\12\63", "\39\68\111\194")] or 0;
				v170 = 3;
			end
			if ((240 < 1190) and (v170 == 6)) then
				v103 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\213\54\178\129\13\215\49", "\232\99\176\66\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\50\45\34\122\148\251\62\233\32\35", "\76\140\65\72\102\27\237\153")];
				v104 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\223\2\198\222\15\185\89", "\222\42\186\118\178\183\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\237\93\136\79\233\69\129\112\237\74\139", "\234\61\140\36")] or 0;
				v105 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\216\174\102\6\47\218\169", "\111\65\189\218\18")][LUAOBFUSACTOR_DECRYPT_STR_0("\103\74\2\55\25\89\174\72\99\43", "\207\35\43\123\85\107\60")] or 0;
				v106 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\175\180\254\112\126\173\179", "\25\16\202\192\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\202\180\224\187\241\252\192\133\197\187\251\232\219", "\148\157\171\205\130\201")] or 0;
				v170 = 7;
			end
			if ((9 == v170) or (635 > 2257)) then
				v115 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\77\144\253\121\184\138\91", "\214\237\40\228\137\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\167\226\253\203\10\163\151\204\233\255\2\175\145\235\199\233", "\198\229\131\143\185\99")] or 0;
				v116 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\98\137\188\103\88\130\175\96", "\19\49\236\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\220\50\247\180\235\180\209\49\218\190\227\178\234\2\229\182\227\191", "\218\158\87\150\215\132")] or "";
				v117 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\200\27\205\246\63\44\202\232", "\173\155\126\185\130\86\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\163\187\196\135\226\202\160\156\198\129\248\237\147\169\198\143\233", "\140\133\198\218\167\232")] or "";
				break;
			end
			if ((1961 > 534) and (v170 == 5)) then
				v99 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\43\171\95\222\229\218\147", "\189\224\78\223\43\183\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\245\141\30\213\61\212\139\27\204\43\238\162\38", "\161\78\156\234\118")] or 0;
				v100 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\148\178\221\200\174\185\206\207", "\188\199\215\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\0\88\115\252\239\33\94\118\229\249\27\120\105\231\233\25", "\136\156\105\63\27")] or 0;
				v101 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\40\137\109\32\18\130\126\39", "\84\123\236\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\210\135\175\4\191\188\254\140\133\17\156\167\255\159\175\20\184\188\255\133\159\4\173\178\245", "\213\144\235\202\119\204")] or "";
				v102 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\29\202\62\33\45\74\48", "\45\67\120\190\74\72\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\46\232\182\234\129\224\238\15\36\221\183\246\156\235\234\52\43\226\171", "\137\64\66\141\197\153\232\142")] or 0;
				v170 = 6;
			end
		end
	end
	local function v147()
		local v171 = 0;
		while true do
			if ((196 <= 3023) and (v171 == 2)) then
				if ((2048 <= 3047) and v15:IsMounted()) then
					return;
				end
				if (v15:IsDeadOrGhost() or (411 >= 2970)) then
					return;
				end
				if ((1312 <= 2793) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v15:CanAttack(v17)) then
					local v247 = 0;
					local v248;
					while true do
						if ((0 == v247) or (2164 >= 3404)) then
							v248 = v127.DeadFriendlyUnitsCount();
							if ((1080 <= 2918) and v15:AffectingCombat()) then
								if (v31[LUAOBFUSACTOR_DECRYPT_STR_0("\152\93\104\208\107\57\180\64\111\220\118\52", "\90\209\51\28\181\25")]:IsCastable() or (3426 <= 1781)) then
									if (v24(v31.Intercession, nil, true) or (4376 <= 4070)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\217\117\67\235\173\211\126\68\253\182\223\117", "\223\176\27\55\142");
									end
								end
							elseif ((v248 > 1) or (805 > 4162)) then
								if ((4904 == 4904) and v24(v31.Absolution, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\37\185\221\186\40\174\218\188\43\181", "\213\68\219\174");
								end
							elseif (v24(v31.Redemption, not v17:IsInRange(40), true) or (2525 > 4643)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\25\229\39\226\39\213\43\118\4\238", "\31\107\128\67\135\74\165\95");
							end
							break;
						end
					end
				end
				if (v15:AffectingCombat() or (v42 and v120) or (3983 < 1150)) then
					local v249 = 0;
					local v250;
					local v251;
					while true do
						if ((4066 < 4247) and (v249 == 1)) then
							if (v251 or (1446 < 545)) then
								return v251;
							end
							break;
						end
						if ((v249 == 0) or (616 == 199)) then
							v250 = v42 and v31[LUAOBFUSACTOR_DECRYPT_STR_0("\251\228\249\76\79\162\221", "\209\184\136\156\45\33")]:IsReady();
							v251 = v127.FocusUnit(v250, v33, 20);
							v249 = 1;
						end
					end
				end
				v171 = 3;
			end
			if ((v171 == 1) or (4384 <= 2280)) then
				v120 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\229\255\207\77\85\249", "\33\48\138\152\168")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\31\35\65\196\59", "\87\18\118\80\49\161")];
				v121 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\17\221\167\188\73\13", "\208\44\126\186\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\228\10\182\195\21\248", "\46\151\122\196\166\116\156\169")];
				v122 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\209\226\65\29\247\224\254", "\155\133\141\38\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\38\51\175\77\74", "\197\69\74\204\33\47\31")];
				v123 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\196\64\93\128\252\74\73", "\231\144\47\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\190\215\222", "\89\210\184\186\21\120\93\175")];
				v171 = 2;
			end
			if ((4564 > 598) and (v171 == 0)) then
				v145();
				v146();
				v118 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\129\33\179\122\136\176\61", "\228\213\78\212\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\67\181", "\139\231\44\214\101")];
				v119 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\224\1\89\28\180\34", "\118\185\143\102\62\112\209\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\116\58", "\88\60\16\73\134\197\117\124")];
				v171 = 1;
			end
			if ((3747 == 3747) and (v171 == 3)) then
				v125 = v15:GetEnemiesInMeleeRange(8);
				if ((3889 < 4766) and AOE) then
					v126 = #v125;
				else
					v126 = 1;
				end
				if ((2628 > 2464) and not v15:IsChanneling()) then
					if (v118 or v15:AffectingCombat() or (3197 <= 2999)) then
						if (v15:AffectingCombat() or (952 <= 71)) then
							local v252 = 0;
							local v253;
							while true do
								if ((2347 >= 423) and (v252 == 0)) then
									v253 = v143();
									if ((4997 >= 4775) and v253) then
										return v253;
									end
									break;
								end
							end
						else
							local v254 = 0;
							local v255;
							while true do
								if ((3333 < 3636) and (v254 == 0)) then
									v255 = v144();
									if ((3706 >= 2393) and v255) then
										return v255;
									end
									break;
								end
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v148()
		local v172 = 0;
		while true do
			if ((1756 < 3743) and (v172 == 0)) then
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\47\199\121\17\248\55\201\121\9\188\14\198\53\10\161\71\237\101\1\187\73", "\216\103\168\21\104"));
				v127[LUAOBFUSACTOR_DECRYPT_STR_0("\92\164\80\180\125\161\79\165\122\161\70\128\125\175\86\162\126\190", "\196\24\205\35")] = v127[LUAOBFUSACTOR_DECRYPT_STR_0("\10\130\240\22\43\135\239\7\44\135\230\43\47\140\234\5\10\142\225\19\40\141\240", "\102\78\235\131")];
				v172 = 1;
			end
			if ((2598 <= 3220) and (v172 == 1)) then
				v127[LUAOBFUSACTOR_DECRYPT_STR_0("\222\39\39\84\66\53\187\53\248\34\49\96\66\59\162\50\252\61", "\84\154\78\84\36\39\89\215")] = v12.MergeTable(v127.DispellableDebuffs, v127.DispellableDiseaseDebuffs);
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\213\238\90\65\69\205\224\90\89\1\244\239\22\96\69\235\161\7\8\75\175\175\6\8\69\223\248\22\122\10\242\236\125", "\101\157\129\54\56"));
				break;
			end
		end
	end
	v21.SetAPL(65, v147, v148);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\56\185\131\179\28\73\28\165\139\175\42\119\34\129\133\167\58\73\28\165\196\167\54\120", "\25\125\201\234\203\67")]();

