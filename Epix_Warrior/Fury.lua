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
		if ((0 == v5) or (2910 <= 1930)) then
			v6 = v0[v4];
			if (not v6 or (19 > 452)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (907 > 3152)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\140\198\12\195\202\212\55\217\157\210\12\200\141\215\48\231", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67\147\71\238\80\162\82", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\142\114\127\61\0", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = EpicLib;
	local v21 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\107\75\14\33", "\69\41\34\96")];
	local v22 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local v24 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local v26 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local v27 = 5;
	local v28;
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
	local v85;
	local v86;
	local v87;
	local v88;
	local v89;
	local v90;
	local v91;
	local v92 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\228\91\125\25\182\16\212", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\56\37\146\173\22\242\205", "\156\168\78\64\224\212\121")];
	local v93 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\48\239\183\220\14\225\183", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\112\61\77\33", "\152\54\72\63\88\69\62")];
	local v94 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\227\197\252\78\221\203\252", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\75\23\48", "\114\56\62\101\73\71\141")];
	local v95 = v23[LUAOBFUSACTOR_DECRYPT_STR_0("\143\232\201\214\177\230\201", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\243\35\171", "\107\178\134\81\210\198\158")];
	local v96 = {};
	local v97 = 11111;
	local v98 = 11111;
	v10:RegisterForEvent(function()
		local v115 = 0;
		while true do
			if ((v115 == 0) or (2505 > 4470)) then
				v97 = 11111;
				v98 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\8\34\163\255\143\10\49\176\227\141\29\32\189\227\132\25\44\174\227\142", "\202\88\110\226\166"));
	local v99, v100;
	local v101;
	local function v102()
		local v116 = 0;
		local v117;
		while true do
			if ((v116 == 0) or (3711 > 4062)) then
				v117 = UnitGetTotalAbsorbs(v15);
				if ((420 == 420) and (v117 > 0)) then
					return true;
				else
					return false;
				end
				break;
			end
		end
	end
	local function v103()
		local v118 = 0;
		while true do
			if ((v118 == 3) or (33 >= 3494)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\156\247\211\209\63\220\185\123\172\193\213\195\52\205\183", "\30\222\146\161\162\90\174\210")]:IsCastable() and v69 and (v14:HealthPercentage() > v82) and v14:BuffDown(v93.BerserkerStance, true)) or (1267 == 4744)) then
					if ((2428 < 3778) and v24(v93.BerserkerStance)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\231\75\98\25\224\92\123\15\247\113\99\30\228\64\115\15\165\79\118\30\224\92\48\14\224\72\117\4\246\71\102\15\165\93\100\11\235\77\117\74\225\75\118\15\235\93\121\28\224", "\106\133\46\16");
					end
				end
				if ((v94[LUAOBFUSACTOR_DECRYPT_STR_0("\112\37\114\240\78\72\75\52\124\242\95", "\32\56\64\19\156\58")]:IsReady() and v70 and (v14:HealthPercentage() <= v80)) or (2946 <= 1596)) then
					if ((4433 > 3127) and v24(v95.Healthstone)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\205\228\90\78\250\147\78\199\235\83\26\246\133\92\205\235\69\83\228\133\26\155", "\224\58\168\133\54\58\146");
					end
				end
				v118 = 4;
			end
			if ((4300 >= 2733) and (v118 == 0)) then
				if ((4829 == 4829) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\225\6\150\227\207\209\38\143\250\223\205\6\150\238", "\170\163\111\226\151")]:IsReady() and v64 and (v14:HealthPercentage() <= v73)) then
					if ((1683 <= 4726) and v24(v93.BitterImmunity)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\57\166\44\75\37\22\24\61\191\45\64\62\61\8\112\182\61\72\50\39\2\57\164\61", "\73\113\80\210\88\46\87");
					end
				end
				if ((4835 >= 3669) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\164\34\223\19\224\132\40\255\23\224\132\34\200\0\230\149\37\194\28", "\135\225\76\173\114")]:IsCastable() and v65 and (v14:HealthPercentage() <= v74)) then
					if ((2851 > 1859) and v24(v93.EnragedRegeneration)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\227\170\177\171\184\163\37\255\189\183\169\179\162\8\236\172\185\163\179\231\30\232\190\181\162\174\174\12\232", "\199\122\141\216\208\204\221");
					end
				end
				v118 = 1;
			end
			if ((3848 > 2323) and (v118 == 4)) then
				if ((2836 > 469) and v71 and (v14:HealthPercentage() <= v81)) then
					local v180 = 0;
					while true do
						if ((v180 == 0) or (2096 <= 540)) then
							if ((v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\107\83\77\239\112\149\143\2\87\81\11\213\112\135\139\2\87\81\11\205\122\146\142\4\87", "\107\57\54\43\157\21\230\231")) or (3183 < 2645)) then
								if ((3230 <= 3760) and v94[LUAOBFUSACTOR_DECRYPT_STR_0("\233\142\23\231\188\207\199\210\133\22\221\188\221\195\210\133\22\197\182\200\198\212\133", "\175\187\235\113\149\217\188")]:IsReady()) then
									if ((3828 == 3828) and v24(v95.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\46\170\135\94\230\106\112\53\161\134\12\235\124\121\48\166\143\75\163\105\119\40\166\142\66\163\125\125\58\170\143\95\234\111\125\124\251", "\24\92\207\225\44\131\25");
									end
								end
							end
							if ((554 == 554) and (v87 == "Dreamwalker's Healing Potion")) then
								if (v94[LUAOBFUSACTOR_DECRYPT_STR_0("\111\193\189\77\22\106\74\223\179\73\9\110\99\214\185\64\18\115\76\227\183\88\18\114\69", "\29\43\179\216\44\123")]:IsReady() or (2563 == 172)) then
									if ((3889 >= 131) and v24(v95.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\185\203\37\77\176\206\33\64\182\220\50\95\253\209\37\77\177\208\46\75\253\201\47\88\180\214\46\12\185\220\38\73\179\202\41\90\184", "\44\221\185\64");
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((2 == v118) or (492 == 4578)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\5\65\164\253\202\162\172", "\175\204\201\113\36\214\139")]:IsCastable() and v68 and (v17:HealthPercentage() <= v78) and (v17:UnitName() ~= v14:UnitName())) or (4112 < 1816)) then
					if ((4525 >= 1223) and v24(v95.InterveneFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\194\33\217\22\81\201\59\217\68\67\201\51\217\10\84\197\35\217", "\100\39\172\85\188");
					end
				end
				if ((1090 <= 4827) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\137\125\191\133\61\190\113\175\133\0\185\121\183\131\54", "\83\205\24\217\224")]:IsCastable() and v69 and (v14:HealthPercentage() <= v79) and v14:BuffDown(v93.DefensiveStance, true)) then
					if (v24(v93.DefensiveStance) or (239 > 1345)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\192\203\56\232\214\196\43\227\250\222\41\231\203\206\56\166\193\200\59\227\203\222\52\240\192", "\93\134\165\173");
					end
				end
				v118 = 3;
			end
			if ((v118 == 1) or (3710 >= 3738)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\132\218\30\255\106\243\157\220\25\254", "\150\205\189\112\144\24")]:IsCastable() and v66 and (v14:HealthPercentage() <= v75)) or (3838 < 2061)) then
					if (v24(v93.IgnorePain, nil, nil, true) or (690 > 1172)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\131\177\67\22\141\46\0\36\141\177\12\0\141\23\21\43\151\182\90\1", "\112\69\228\223\44\100\232\113");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\230\30\11\223\175\117\136\211\60\21\202", "\230\180\127\103\179\214\28")]:IsCastable() and v67 and v14:BuffDown(v93.AspectsFavorBuff) and v14:BuffDown(v93.RallyingCry) and (((v14:HealthPercentage() <= v76) and v92.IsSoloMode()) or v92.AreUnitsBelowHealthPercentage(v76, v77))) or (1592 > 2599)) then
					if ((3574 <= 4397) and v24(v93.RallyingCry)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\158\4\83\74\253\72\238\139\58\92\84\253\1\228\137\3\90\72\247\72\246\137", "\128\236\101\63\38\132\33");
					end
				end
				v118 = 2;
			end
		end
	end
	local function v104()
		local v119 = 0;
		while true do
			if ((3135 > 1330) and (v119 == 1)) then
				v28 = v92.HandleBottomTrinket(v96, v31, 40, nil);
				if (v28 or (3900 <= 3641)) then
					return v28;
				end
				break;
			end
			if ((1724 == 1724) and (0 == v119)) then
				v28 = v92.HandleTopTrinket(v96, v31, 40, nil);
				if ((455 <= 1282) and v28) then
					return v28;
				end
				v119 = 1;
			end
		end
	end
	local function v105()
		local v120 = 0;
		while true do
			if ((4606 < 4876) and (v120 == 1)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\30\61\6\180\29\255\41\60\46\34\29", "\85\92\81\105\219\121\139\65")]:IsCastable() and v35 and v101) or (1442 > 2640)) then
					if ((136 < 3668) and v24(v93.Bloodthirst, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\191\95\74\120\203\245\186\66\86\104\159\237\161\85\70\115\210\255\178\68\5\45\143", "\191\157\211\48\37\28");
					end
				end
				if ((v36 and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\252\23\245\14\61\218", "\90\191\127\148\124")]:IsReady() and not v101) or (1784 > 4781)) then
					if ((4585 > 3298) and v24(v93.Charge, not v15:IsSpellInRange(v93.Charge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\123\143\47\5\127\130\110\7\106\130\45\24\117\133\47\3\56\214\124", "\119\24\231\78");
					end
				end
				break;
			end
			if ((0 == v120) or (1664 > 1698)) then
				if ((v32 and ((v53 and v31) or not v53) and (v91 < v98) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\32\241\73\75\114\19", "\19\97\135\40\63")]:IsCastable() and not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\154\85\39\58\33\34\154\83\33\54\42\63\186", "\81\206\60\83\91\79")]:IsAvailable()) or (3427 < 2849)) then
					if ((3616 <= 4429) and v24(v93.Avatar, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\189\209\102\46\209\13\180\92\174\211\125\34\193\76\176\14\253", "\196\46\203\176\18\79\163\45");
					end
				end
				if ((3988 >= 66) and v45 and ((v56 and v31) or not v56) and (v91 < v98) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\138\39\125\21\40\254\252\171\44\123\13\55", "\143\216\66\30\126\68\155")]:IsCastable() and not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\152\205\14\192\201\166\196\242\139\202\12\197\193\172\217", "\129\202\168\109\171\165\195\183")]:IsAvailable()) then
					if (v24(v93.Recklessness, not v101) or (862 > 4644)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\93\52\211\210\17\245\49\86\50\203\205\84\246\48\93\52\215\211\22\231\54\24\111", "\134\66\56\87\184\190\116");
					end
				end
				v120 = 1;
			end
		end
	end
	local function v106()
		local v121 = 0;
		local v122;
		while true do
			if ((1221 == 1221) and (v121 == 1)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\233\123\43\91\249\49\201\223\127", "\168\171\23\68\52\157\83")]:IsCastable() and v34 and v14:HasTier(31, 2)) or (45 > 1271)) then
					if ((3877 > 1530) and v24(v93.Bloodbath, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\125\250\162\33\47\134\224\121\181\190\44\35\128\248\116\202\185\36\63\128\241\101\181\252\113", "\231\148\17\149\205\69\77");
					end
				end
				if ((v48 and ((v58 and v31) or not v58) and (v91 < v98) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\180\175\210\245\83\250\146\168\210\232\101\240\129\181", "\159\224\199\167\155\55")]:IsCastable() and v14:BuffUp(v93.EnrageBuff)) or (4798 == 1255)) then
					if (v24(v93.ThunderousRoar, not v15:IsInMeleeRange(v27)) or (2541 > 2860)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\251\41\220\243\246\46\221\226\224\3\192\248\242\46\146\228\250\50\213\251\246\3\198\246\225\59\215\227\179\109\132", "\178\151\147\92");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\163\243\95\62\19\89\125\132\233", "\26\236\157\44\82\114\44")]:IsReady() and v41 and (v14:BuffUp(v93.EnrageBuff) or v93[LUAOBFUSACTOR_DECRYPT_STR_0("\30\43\219\95\47\60\220\65\47", "\59\74\78\181")]:IsAvailable())) or (2902 > 3629)) then
					if ((427 < 3468) and v24(v93.Onslaught, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\223\73\86\178\48\214\82\78\243\54\216\84\93\191\32\238\78\91\161\34\212\78\26\226\125", "\211\69\177\58\58");
					end
				end
				if ((4190 >= 2804) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\148\247\108\230\225\194\185\226\91\249\230\220", "\171\215\133\25\149\137")]:IsCastable() and v37 and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\214\218\51\238\231\49\242\70\199\221\32\227", "\34\129\168\82\154\143\80\156")]:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if ((2086 == 2086) and v24(v93.CrushingBlow, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\160\38\24\64\71\135\130\141\49\7\71\89\201\150\187\61\12\68\75\182\145\179\33\12\77\90\201\215\226", "\233\229\210\83\107\40\46");
					end
				end
				if ((4148 > 2733) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\228\90\55\213\16\213\71", "\101\161\34\82\182")]:IsReady() and v38 and ((v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.FuriousBloodthirstBuff) and v14:BuffUp(v93.AshenJuggernautBuff)) or ((v14:BuffRemains(v93.SuddenDeathBuff) <= v14:GCD()) and (((v15:HealthPercentage() > 35) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\197\12\74\237\218\225\144\43", "\78\136\109\57\158\187\130\226")]:IsAvailable()) or (v15:HealthPercentage() > 20))))) then
					if ((3054 >= 1605) and v24(v93.Execute, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\39\252\242\43\43\252\177\45\54\247\246\50\58\198\229\63\45\254\244\42\127\171\163", "\145\94\95\153");
					end
				end
				if ((1044 < 1519) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\207\204\25\197\79\176\248", "\215\157\173\116\181\46")]:IsReady() and v43 and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\7\177\136\249\214\48\167\152\211\216\52\186\143\253\212", "\186\85\212\235\146")]:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > 85))) then
					if ((1707 <= 4200) and v24(v93.Rampage, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\128\27\238\56\233\93\130\146\31\240\62\226\93\253\149\23\236\62\235\76\130\211\66", "\56\162\225\118\158\89\142");
					end
				end
				v121 = 2;
			end
			if ((580 == 580) and (4 == v121)) then
				if ((601 <= 999) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\193\238\85\198\36\81\246", "\54\147\143\56\182\69")]:IsReady() and v43) then
					if ((3970 == 3970) and v24(v93.Rampage, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\128\242\89\222\209\132\191\90\214\216\134\243\76\224\194\128\237\78\218\194\193\171\30", "\191\182\225\159\41");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\24\30\41\88", "\162\75\114\72\53\235\231")]:IsReady() and v46 and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\173\50\74\235\91\11\128\61\80\237\65", "\98\236\92\36\130\51")]:IsAvailable())) or (98 == 208)) then
					if ((2006 <= 3914) and v24(v93.Slam, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\21\13\183\5\187\188\62\163\21\9\133\81\169\167\55\161\13\76\238\29", "\80\196\121\108\218\37\200\213");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\34\127\13\112\79\12\139\20\123", "\234\96\19\98\31\43\110")]:IsCastable() and v34) or (3101 <= 2971)) then
					if (v24(v93.Bloodbath, not v101) or (2073 <= 671)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\4\19\93\200\168\112\138\18\23\18\212\165\124\140\10\26\109\211\173\96\140\3\11\18\146\252", "\235\102\127\50\167\204\18");
					end
				end
				if ((3305 > 95) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\98\160\242\42\74\41\114\173\250\52", "\78\48\193\149\67\36")]:IsCastable() and v42) then
					if ((2727 == 2727) and v24(v93.RagingBlow, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\31\135\17\79\55\33\130\20\78\39\94\147\17\79\55\18\133\39\85\49\12\135\29\85\112\75\210", "\33\80\126\224\120");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\207\186\22\215\84\229\166\4\230\80\227\191", "\60\140\200\99\164")]:IsCastable() and v37 and v14:BuffDown(v93.FuriousBloodthirstBuff)) or (2970 >= 4072)) then
					if ((3881 > 814) and v24(v93.CrushingBlow, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\132\230\17\53\170\142\250\3\25\160\139\251\19\102\177\142\250\3\42\167\184\224\5\52\165\130\224\68\115\246", "\194\231\148\100\70");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\100\64\206\172\242\220\78\69\211\176\226", "\168\38\44\161\195\150")]:IsCastable() and v35) or (4932 < 4868)) then
					if ((3667 <= 4802) and v24(v93.Bloodthirst, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\130\240\141\121\52\252\190\31\146\239\150\54\35\225\184\17\140\249\189\98\49\250\177\19\148\188\215\32", "\118\224\156\226\22\80\136\214");
					end
				end
				v121 = 5;
			end
			if ((1260 >= 858) and (v121 == 5)) then
				if ((v30 and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\117\230\80\146\78\249\80\142\70", "\224\34\142\57")]:IsCastable() and v49) or (3911 == 4700)) then
					if ((3000 < 4194) and v24(v93.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\175\204\207\127\230\84\0\218\231\214\212\125\246\81\11\225\179\196\207\116\244\73\78\139\255", "\110\190\199\165\189\19\145\61");
					end
				end
				break;
			end
			if ((651 < 4442) and (0 == v121)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\181\37\172\88\208\87\24\140\41", "\113\226\77\197\42\188\32")]:IsCastable() and v49 and (v100 > 1) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\19\27\228\167\53\0\241\177\13\30\253\185\45\31\250\177", "\213\90\118\148")]:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) or (195 >= 1804)) then
					if (v24(v93.Whirlwind, not v15:IsInMeleeRange(v27)) or (1382 > 2216)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\76\38\189\68\65\76\39\186\82\13\72\39\186\81\65\94\17\160\87\95\92\43\160\22\31", "\45\59\78\212\54");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\53\78\134\136\147\58\168", "\144\112\54\227\235\230\78\205")]:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) or (2861 == 2459)) then
					if ((1903 < 4021) and v24(v93.Execute, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\48\10\255\197\79\182\104\28\245\222\92\191\45\48\232\209\73\180\45\27\188\132", "\59\211\72\111\156\176");
					end
				end
				if ((v40 and ((v54 and v31) or not v54) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\97\131\250\35\93\161\246\63\87", "\77\46\231\131")]:IsCastable() and (v91 < v98) and v14:BuffUp(v93.EnrageBuff) and ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\158\85\184\67\179\90\177\98\182\85\178\69\169", "\32\218\52\214")]:IsAvailable() and (v14:BuffRemains(v93.DancingBladesBuff) < 5)) or not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\106\22\63\171\248\190\66\120\66\22\53\173\226", "\58\46\119\81\200\145\208\37")]:IsAvailable())) or (2270 >= 4130)) then
					if ((2593 <= 3958) and v24(v93.OdynsFury, not v15:IsInMeleeRange(v27))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\36\136\41\162\186\130\48\62\158\41\236\186\180\56\44\128\53\147\189\188\36\44\137\36\236\255", "\86\75\236\80\204\201\221");
					end
				end
				if ((1176 == 1176) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\64\64\122\149\255\140\119", "\235\18\33\23\229\158")]:IsReady() and v43 and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\113\180\198\190\66\151\192\181\81\189\196\182\85\180\213", "\219\48\218\161")]:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or (v14:RagePercentage() > 85))) then
					if (v24(v93.Rampage, not v101) or (3062 == 1818)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\112\113\89\218\72\229\164\98\117\71\220\67\229\219\101\125\91\220\74\244\164\41", "\128\132\17\28\41\187\47");
					end
				end
				v122 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * 20) + (v14:BuffStack(v93.MercilessAssaultBuff) * 10) + (v14:BuffStack(v93.BloodcrazeBuff) * 15);
				if ((v122 >= 95) or (not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\34\61\10\62\110\21\55\3\54\117\14\38\36\54\82\14\54", "\61\97\82\102\90")]:IsAvailable() and v14:HasTier(30, 4)) or (3717 < 3149)) then
					local v181 = 0;
					while true do
						if ((3195 < 3730) and (v181 == 0)) then
							if ((2797 <= 3980) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\142\34\164\68\195\85\31\29\164", "\105\204\78\203\43\167\55\126")]:IsCastable() and v34) then
								if ((1944 <= 2368) and v24(v93.Bloodbath, not v101)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\167\166\44\17\23\6\198\69\173\234\48\23\29\3\203\84\154\190\34\12\20\1\211\17\244\250", "\49\197\202\67\126\115\100\167");
								end
							end
							if ((1709 < 4248) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\21\87\208\38\132\66\86\62\73\204\61", "\62\87\59\191\73\224\54")]:IsCastable() and v35) then
								if (v24(v93.Bloodthirst, not v101) or (3970 == 3202)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\229\14\245\198\227\22\242\192\245\17\238\137\244\11\244\206\235\7\197\221\230\16\253\204\243\66\171\155", "\169\135\98\154");
								end
							end
							break;
						end
					end
				end
				v121 = 1;
			end
			if ((v121 == 2) or (3918 >= 4397)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\121\29\197\172\55\204\89", "\184\60\101\160\207\66")]:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) or (780 == 3185)) then
					if (v24(v93.Execute, not v101) or (3202 >= 4075)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\154\121\191\36\150\121\252\34\139\114\187\61\135\67\168\48\144\123\185\37\194\46\234", "\220\81\226\28");
					end
				end
				if ((64 == 64) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\33\212\143\235\235\192\22", "\167\115\181\226\155\138")]:IsReady() and v43 and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\195\44\224\89\105\92\199\236\35\224\89\118\116\200\246", "\166\130\66\135\60\27\17")]:IsAvailable()) then
					if ((2202 >= 694) and v24(v93.Rampage, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\86\75\195\101\49\67\79\142\102\57\74\77\194\112\15\80\75\220\114\53\80\10\156\45", "\80\36\42\174\21");
					end
				end
				if ((3706 <= 3900) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\107\8\50\121\91\4\50", "\26\46\112\87")]:IsReady() and v38) then
					if ((2890 > 2617) and v24(v93.Execute, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\188\59\174\119\170\171\64\244\170\42\165\115\179\186\122\160\184\49\172\113\171\255\23\237", "\212\217\67\203\20\223\223\37");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\152\129\167\221\190\143\169\198\178", "\178\218\237\200")]:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\132\176\229\219\186\176\245\195\151\183\231\222\178\186\232", "\176\214\213\134")]:IsAvailable() and not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\195\191\183\192\160\87\87\240\139\163\198\177", "\57\148\205\214\180\200\54")]:IsAvailable()) or (3355 > 4385)) then
					if (v24(v93.Bloodbath, not v101) or (3067 <= 2195)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\241\58\59\114\16\252\33\60\54\1\244\59\51\122\23\194\33\53\100\21\248\33\116\37\66", "\22\114\157\85\84");
					end
				end
				if ((3025 >= 2813) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\246\202\30\212\92\241\173", "\200\164\171\115\164\61\150")]:IsReady() and v43 and (v15:HealthPercentage() < 35) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\147\245\16\86\130\189\230\6", "\227\222\148\99\37")]:IsAvailable()) then
					if ((2412 >= 356) and v24(v93.Rampage, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\83\95\230\248\52\87\18\229\240\61\85\94\243\198\39\83\64\241\252\39\18\1\164", "\153\83\50\50\150");
					end
				end
				if ((2070 > 1171) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\127\122\124\19\119\191\69\84\100\96\8", "\45\61\22\19\124\19\203")]:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\224\28\3\252\10\121\181\192\6\2\231", "\217\161\114\109\149\98\16")]:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff))) and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if (v24(v93.Bloodthirst, not v101) or (4108 < 3934)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\44\55\115\184\96\26\41\42\111\168\52\1\41\54\123\176\113\45\52\57\110\187\113\6\96\107\40", "\20\114\64\88\28\220");
					end
				end
				v121 = 3;
			end
			if ((3499 >= 3439) and (v121 == 3)) then
				if ((876 < 3303) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\3\0\213\189\246\215\159\61\14\197", "\221\81\97\178\212\152\176")]:IsCastable() and v42 and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\255\230\26\242\20\202\197\17\244\13", "\122\173\135\125\155")]:Charges() > 1) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\179\211\1\173\55\48\198\128\231\21\171\38", "\168\228\161\96\217\95\81")]:IsAvailable()) then
					if ((2922 <= 3562) and v24(v93.RagingBlow, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\208\41\85\33\80\228\211\34\83\56\23\200\216\32\91\35\82\228\197\47\78\40\82\207\145\125\10", "\55\187\177\78\60\79");
					end
				end
				if ((2619 >= 1322) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\14\220\74\248\78\198\142\42\236\83\228\81", "\224\77\174\63\139\38\175")]:IsCastable() and v37 and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\167\83\77\61\140\72\86\41\166\77\87\57", "\78\228\33\56")]:Charges() > 1) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\249\108\179\23\141\207\112\182\37\144\220\103", "\229\174\30\210\99")]:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if ((4133 >= 2404) and v24(v93.CrushingBlow, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\255\147\66\229\52\55\28\210\132\93\226\42\121\8\228\136\86\225\56\6\15\236\148\86\232\41\121\72\181", "\89\123\141\230\49\141\93");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\209\125\249\3\20\72\242\101\254", "\42\147\17\150\108\112")]:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\56\180\44\107\239\233\1\162\11\106\245\241", "\136\111\198\77\31\135")]:IsAvailable())) or (1433 == 2686)) then
					if (v24(v93.Bloodbath, not v101) or (4123 == 4457)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\5\168\89\185\230\22\189\10\73\180\95\179\227\27\172\61\29\166\68\186\225\3\233\86\89", "\201\98\105\199\54\221\132\119");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\154\30\150\50\10\60\162\190\46\143\46\21", "\204\217\108\227\65\98\85")]:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\108\198\246\238\32\197\77\208\212\231\45\206\90\204\251", "\160\62\163\149\133\76")]:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) or (3972 <= 205)) then
					if (v24(v93.CrushingBlow, not v101) or (3766 < 1004)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\213\178\24\60\203\223\174\10\16\193\218\175\26\111\208\223\174\10\35\198\233\180\12\61\196\211\180\77\123\145", "\163\182\192\109\79");
					end
				end
				if ((1784 < 2184) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\22\42\15\207\241\32\46\9\210\230\32", "\149\84\70\96\160")]:IsCastable() and v35 and not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\15\20\12\249\48\7\3\233\30\19\31\244", "\141\88\102\109")]:IsAvailable() and v14:BuffDown(v93.FuriousBloodthirstBuff)) then
					if (v24(v93.Bloodthirst, not v101) or (1649 > 4231)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\95\197\127\30\41\93\200\161\64\222\48\9\52\91\198\191\86\245\100\27\47\82\196\167\19\158\36", "\161\211\51\170\16\122\93\53");
					end
				end
				if ((3193 == 3193) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\201\175\181\33\245\169\144\36\244\185", "\72\155\206\210")]:IsCastable() and v42 and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\116\123\83\7\61\65\88\88\1\36", "\83\38\26\52\110")]:Charges() > 1)) then
					if (v24(v93.RagingBlow, not v101) or (3495 > 4306)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\74\22\32\79\86\16\24\68\84\24\48\6\75\30\41\65\84\18\24\82\89\5\32\67\76\87\115\16", "\38\56\119\71");
					end
				end
				v121 = 4;
			end
		end
	end
	local function v107()
		local v123 = 0;
		local v124;
		while true do
			if ((4001 > 3798) and (v123 == 2)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\7\4\185\242\57\249\217\35\52\160\238\38", "\183\68\118\204\129\81\144")]:IsCastable() and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\57\191\113\240\3\131\0\169\86\241\25\155", "\226\110\205\16\132\107")]:IsAvailable() and v37 and v14:BuffUp(v93.EnrageBuff)) or (4688 <= 4499)) then
					if (v24(v93.CrushingBlow, not v101) or (1567 <= 319)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\232\209\245\202\73\226\205\231\230\67\231\204\247\153\76\254\207\244\208\126\255\194\242\222\68\255\131\177\141", "\33\139\163\128\185");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\114\64\1\221\66\76\1", "\190\55\56\100")]:IsReady() and v38 and v14:BuffUp(v93.EnrageBuff)) or (4583 == 3761)) then
					if ((3454 > 1580) and v24(v93.Execute, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\183\57\29\6\247\246\22\162\41\18\7\234\204\66\174\46\25\22\247\179\7\249", "\147\54\207\92\126\115\131");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\34\53\44\115\30\88\24\35\44", "\30\109\81\85\29\109")]:IsCastable() and ((v54 and v31) or not v54) and v40 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) or (1607 == 20)) then
					if (v24(v93.OdynsFury, not v15:IsInMeleeRange(v27)) or (962 >= 4666)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\117\77\184\37\225\250\234\99\77\246\59\203\240\235\120\107\162\55\204\251\250\101\20\231\110", "\156\159\17\52\214\86\190");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\156\238\176\172\175\232\184", "\220\206\143\221")]:IsReady() and v43 and (v14:BuffUp(v93.RecklessnessBuff) or (v14:BuffRemains(v93.EnrageBuff) < v14:GCD()) or ((v14:Rage() > 110) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\169\107\40\5\207\196\215\138\112\36\25\223\254\211\129\120", "\178\230\29\77\119\184\172")]:IsAvailable()) or ((v14:Rage() > 80) and not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\218\168\15\9\96\240\240\178\7\18\121\255\199\191\13\30", "\152\149\222\106\123\23")]:IsAvailable()))) or (1896 == 1708)) then
					if ((3985 >= 1284) and v24(v93.Rampage, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\207\39\251\83\180\218\35\182\78\160\209\50\255\124\161\220\52\241\70\161\157\116\166", "\213\189\70\150\35");
					end
				end
				v123 = 3;
			end
			if ((v123 == 1) or (1987 == 545)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\13\160\89\22\196\231\28\54\189\95\42\207\227\28", "\110\89\200\44\120\160\130")]:IsCastable() and ((v58 and v31) or not v58) and v48 and (v91 < v98) and v14:BuffUp(v93.EnrageBuff)) or (4896 < 1261)) then
					if ((23 < 3610) and v24(v93.ThunderousRoar, not v15:IsInMeleeRange(v27))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\203\94\72\71\79\41\66\190\208\116\84\76\75\41\13\166\214\71\82\74\117\47\76\185\196\78\82\3\27\107", "\45\203\163\43\38\35\42\91");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\253\129\197\45\148\143\65\192\156", "\52\178\229\188\67\231\201")]:IsCastable() and ((v54 and v31) or not v54) and v40 and (v91 < v98) and (v100 > 1) and v14:BuffUp(v93.EnrageBuff)) or (3911 < 2578)) then
					if (v24(v93.OdynsFury, not v15:IsInMeleeRange(v27)) or (4238 < 87)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\69\73\10\228\99\37\52\83\73\68\250\73\47\53\72\111\16\246\78\36\36\85\16\85\165", "\67\65\33\48\100\151\60");
					end
				end
				v124 = v14:CritChancePct() + (v25(v14:BuffUp(v93.RecklessnessBuff)) * 20) + (v14:BuffStack(v93.MercilessAssaultBuff) * 10) + (v14:BuffStack(v93.BloodcrazeBuff) * 15);
				if ((2538 == 2538) and (v124 >= 95) and v14:HasTier(30, 4)) then
					local v182 = 0;
					while true do
						if ((4122 == 4122) and (v182 == 0)) then
							if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\253\235\161\215\247\221\230\186\208", "\147\191\135\206\184")]:IsCastable() and v34) or (2371 > 2654)) then
								if (v24(v93.Bloodbath, not v101) or (3466 > 4520)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\134\36\169\206\220\81\179\144\32\230\204\205\95\166\141\23\178\192\202\84\183\144\104\247\149", "\210\228\72\198\161\184\51");
								end
							end
							if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\20\69\252\31\119\218\62\64\225\3\103", "\174\86\41\147\112\19")]:IsCastable() and v35) or (951 >= 1027)) then
								if (v24(v93.Bloodthirst, not v101) or (1369 > 2250)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\89\12\130\4\33\27\25\162\73\19\153\75\40\26\29\191\82\63\153\10\55\8\20\191\27\81\219", "\203\59\96\237\107\69\111\113");
								end
							end
							break;
						end
					end
				end
				v123 = 2;
			end
			if ((6 == v123) or (937 > 3786)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\134\236\66\188\224\2\165\244\69", "\96\196\128\45\211\132")]:IsCastable() and v34) or (901 > 4218)) then
					if ((4779 > 4047) and v24(v93.Bloodbath, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\129\116\80\214\173\181\204\61\205\118\74\222\187\189\231\33\140\105\88\215\187\244\140\99", "\184\85\237\27\63\178\207\212");
					end
				end
				if ((4050 > 1373) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\58\88\14\86\6\94\43\83\7\78", "\63\104\57\105")]:IsCastable() and v42) then
					if (v24(v93.RagingBlow, not v101) or (1037 > 4390)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\25\134\163\77\5\128\155\70\7\136\179\4\6\146\168\80\2\184\176\69\25\128\161\80\75\211\252", "\36\107\231\196");
					end
				end
				if ((1407 <= 1919) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\126\167\183\148\85\188\172\128\127\185\173\144", "\231\61\213\194")]:IsCastable() and v37) then
					if ((2526 >= 1717) and v24(v93.CrushingBlow, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\191\40\96\1\164\51\116\54\175\49\124\30\237\48\102\5\185\52\76\29\172\47\116\12\185\125\38\89", "\19\105\205\93");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\158\0\215\147\51\190\1\208\133", "\95\201\104\190\225")]:IsCastable() and v49) or (3620 <= 2094)) then
					if (v24(v93.Whirlwind, not v15:IsInMeleeRange(v27)) or (1723 >= 2447)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\184\195\200\220\163\220\200\192\171\139\204\219\163\223\200\241\187\202\211\201\170\223\129\155\253", "\174\207\171\161");
					end
				end
				break;
			end
			if ((v123 == 3) or (1199 > 3543)) then
				if ((1617 < 3271) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\106\77\113\11\90\65\113", "\104\47\53\20")]:IsReady() and v38) then
					if ((3085 > 1166) and v24(v93.Execute, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\84\132\31\169\27\166\12\140\9\176\27\170\115\149\29\174\8\166\88\193\78\238", "\111\195\44\225\124\220");
					end
				end
				if ((4493 >= 3603) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\250\74\15\124\175\169\217\82\8", "\203\184\38\96\19\203")]:IsCastable() and v34 and v14:BuffUp(v93.EnrageBuff) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\11\118\122\74\194\60\96\106\96\204\56\125\125\78\192", "\174\89\19\25\33")]:IsAvailable() and not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\24\0\83\90\255\134\5\43\52\71\92\238", "\107\79\114\50\46\151\231")]:IsAvailable()) then
					if ((2843 <= 2975) and v24(v93.Bloodbath, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\170\186\38\142\59\182\212\49\230\184\60\134\45\190\255\45\167\167\46\143\45\247\146\109", "\160\89\198\213\73\234\89\215");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\106\125\187\241\193\92\121\189\236\214\92", "\165\40\17\212\158")]:IsCastable() and v35 and (not v14:BuffUp(v93.EnrageBuff) or (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\196\215\6\58\46\236\213\9\39\41\247", "\70\133\185\104\83")]:IsAvailable() and v14:BuffDown(v93.RecklessnessBuff)))) or (1989 <= 174)) then
					if (v24(v93.Bloodthirst, not v101) or (209 > 2153)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\6\73\75\37\205\16\77\77\56\218\16\5\73\63\197\16\76\123\62\200\22\66\65\62\137\86\19", "\169\100\37\36\74");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\47\137\177\92\1\146\165\88\20", "\48\96\231\194")]:IsReady() and v41 and ((not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\233\84\0\36\17\209\163\130\220\85\28", "\227\168\58\110\77\121\184\207")]:IsAvailable() and v14:BuffUp(v93.EnrageBuff)) or v93[LUAOBFUSACTOR_DECRYPT_STR_0("\79\57\177\68\180\201\120\191\126", "\197\27\92\223\32\209\187\17")]:IsAvailable())) or (2020 == 1974)) then
					if (v24(v93.Onslaught, not v101) or (1347 == 1360)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\12\81\208\247\2\74\196\243\23\31\206\238\15\75\202\196\23\94\209\252\6\75\131\169\91", "\155\99\63\163");
					end
				end
				v123 = 4;
			end
			if ((0 == v123) or (4461 == 3572)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\232\238\116\227\135\194\201\248\121\237\152\212", "\167\186\139\23\136\235")]:IsCastable() and ((v56 and v31) or not v56) and v45 and (v91 < v98) and ((v100 > 1) or (v98 < 12))) or (2872 == 318)) then
					if ((568 == 568) and v24(v93.Recklessness, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\176\139\6\22\176\155\30\20\176\155\30\90\184\157\1\14\188\183\25\27\167\143\8\14\245\218", "\109\122\213\232");
					end
				end
				if ((4200 == 4200) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\193\243\187\62\253\209\183\34\247", "\80\142\151\194")]:IsCastable() and ((v54 and v31) or not v54) and v40 and (v91 < v98) and (v100 > 1) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\55\207\99\77\13\207\116\126\2\193\114", "\44\99\166\23")]:IsAvailable() and (v14:BuffDown(v93.MeatCleaverBuff) or v14:BuffUp(v93.AvatarBuff) or v14:BuffUp(v93.RecklessnessBuff))) then
					if (v24(v93.OdynsFury, not v15:IsInMeleeRange(v27)) or (4285 < 1369)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\115\243\48\56\32\155\122\226\59\47\115\169\105\251\61\63\12\176\125\229\46\51\39\228\40", "\196\28\151\73\86\83");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\196\11\32\2\142\79\17\120\247", "\22\147\99\73\112\226\56\120")]:IsCastable() and v49 and (v100 > 1) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\145\120\242\231\130\174\112\230\194\133\177\121\245\252\131\188", "\237\216\21\130\149")]:IsAvailable() and v14:BuffDown(v93.MeatCleaverBuff)) or (3520 > 4910)) then
					if ((2842 <= 4353) and v24(v93.Whirlwind, not v15:IsInMeleeRange(v27))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\149\70\86\77\188\222\87\140\74\31\82\165\197\74\139\113\75\94\162\206\91\150\14\9", "\62\226\46\63\63\208\169");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\192\1\80\128\10\25\42", "\62\133\121\53\227\127\109\79")]:IsReady() and v38 and v14:BuffUp(v93.AshenJuggernautBuff) and (v14:BuffRemains(v93.AshenJuggernautBuff) < v14:GCD())) or (3751 < 1643)) then
					if (v24(v93.Execute, not v101) or (4911 == 3534)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\21\12\55\246\195\186\167\80\25\39\249\194\167\157\4\21\32\242\211\186\226\72", "\194\112\116\82\149\182\206");
					end
				end
				v123 = 1;
			end
			if ((3001 > 16) and (v123 == 4)) then
				if ((2875 <= 3255) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\176\208\166\132\183\131\160\221\174\154", "\228\226\177\193\237\217")]:IsCastable() and v42 and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\6\177\36\239\58\183\1\234\59\167", "\134\84\208\67")]:Charges() > 1) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\36\190\135\72\27\173\136\88\53\185\148\69", "\60\115\204\230")]:IsAvailable()) then
					if ((368 < 4254) and v24(v93.RagingBlow, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\59\236\121\233\61\212\114\235\53\252\48\234\47\231\100\238\5\255\113\245\61\238\100\167\105\187", "\16\135\90\139");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\119\102\19\32\70\93\118\83\86\10\60\89", "\24\52\20\102\83\46\52")]:IsCastable() and v37 and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\231\61\52\55\7\205\33\38\6\3\203\56", "\111\164\79\65\68")]:Charges() > 1) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\241\203\130\202\38\235\200\221\165\203\60\243", "\138\166\185\227\190\78")]:IsAvailable()) or (4841 <= 2203)) then
					if ((4661 > 616) and v24(v93.CrushingBlow, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\200\102\208\36\90\42\23\204\75\199\59\93\52\89\198\97\201\35\91\28\13\202\102\194\50\70\99\74\153", "\121\171\20\165\87\50\67");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\228\52\182\57\189\0\199\44\177", "\98\166\88\217\86\217")]:IsCastable() and v34 and (not v14:BuffUp(v93.EnrageBuff) or not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\193\228\120\21\142\221\248\242\95\20\148\197", "\188\150\150\25\97\230")]:IsAvailable())) or (1943 == 2712)) then
					if ((4219 >= 39) and v24(v93.Bloodbath, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\133\80\13\8\239\219\157\87\66\1\248\214\157\86\61\24\236\200\142\90\22\76\190\142", "\141\186\233\63\98\108");
					end
				end
				if ((3967 > 2289) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\210\248\57\165\45\248\228\43\148\41\254\253", "\69\145\138\76\214")]:IsCastable() and v37 and v14:BuffUp(v93.EnrageBuff) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\66\202\138\130\179\19\99\220\168\139\190\24\116\192\135", "\118\16\175\233\233\223")]:IsAvailable()) then
					if (v24(v93.CrushingBlow, not v101) or (851 > 2987)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\136\150\32\168\230\130\115\140\187\55\183\225\156\61\134\145\57\175\231\180\105\138\150\50\190\250\203\46\221", "\29\235\228\85\219\142\235");
					end
				end
				v123 = 5;
			end
			if ((4893 >= 135) and (5 == v123)) then
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\31\216\181\210\115\90\47\91\47\199\174", "\50\93\180\218\189\23\46\71")]:IsCastable() and v35 and not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\233\182\90\88\76\221\70\218\130\78\94\93", "\40\190\196\59\44\36\188")]:IsAvailable()) or (3084 > 3214)) then
					if (v24(v93.Bloodthirst, not v101) or (3426 < 2647)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\73\211\187\254\105\5\53\87\207\160\186\112\24\48\81\213\139\238\124\31\59\64\200\244\169\37", "\109\92\37\188\212\154\29");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\54\238\163\202\63\93\38\227\171\212", "\58\100\143\196\163\81")]:IsCastable() and v42 and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\40\67\36\170\49\78\199\2\21\85", "\110\122\34\67\195\95\41\133")]:Charges() > 1)) or (1576 == 4375)) then
					if (v24(v93.RagingBlow, not v101) or (2920 < 2592)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\103\176\92\67\216\114\142\89\70\217\98\241\86\95\218\97\184\100\94\215\103\182\94\94\150\33\225", "\182\21\209\59\42");
					end
				end
				if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\133\86\200\13\32\185\178", "\222\215\55\165\125\65")]:IsReady() and v43) or (1110 >= 2819)) then
					if ((1824 <= 2843) and v24(v93.Rampage, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\208\203\10\243\198\232\10\33\196\202\14\251\254\249\75\62\214\195\14\178\149\191", "\42\76\177\166\122\146\161\141");
					end
				end
				if ((3062 == 3062) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\150\134\4\195", "\22\197\234\101\174\25")]:IsReady() and v46 and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\12\58\171\213\126\166\219\135\57\59\183", "\230\77\84\197\188\22\207\183")]:IsAvailable())) then
					if ((716 <= 4334) and v24(v93.Slam, not v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\24\199\241\204\172\229\57\237\29\249\232\141\179\247\48\237\84\146\168", "\85\153\116\166\156\236\193\144");
					end
				end
				v123 = 6;
			end
		end
	end
	local function v108()
		local v125 = 0;
		while true do
			if ((1001 < 3034) and (v125 == 1)) then
				if (v86 or (977 > 1857)) then
					local v183 = 0;
					while true do
						if ((v183 == 0) or (868 > 897)) then
							v28 = v92.HandleIncorporeal(v93.StormBolt, v95.StormBoltMouseover, 20, true);
							if (v28 or (1115 == 4717)) then
								return v28;
							end
							v183 = 1;
						end
						if ((2740 < 4107) and (v183 == 1)) then
							v28 = v92.HandleIncorporeal(v93.IntimidatingShout, v95.IntimidatingShoutMouseover, 8, true);
							if ((284 < 700) and v28) then
								return v28;
							end
							break;
						end
					end
				end
				if ((386 >= 137) and v92.TargetIsValid()) then
					local v184 = 0;
					local v185;
					while true do
						if ((923 == 923) and (v184 == 2)) then
							if ((v30 and (v100 > 2)) or (4173 == 359)) then
								local v192 = 0;
								while true do
									if ((1722 == 1722) and (v192 == 0)) then
										v28 = v107();
										if (v28 or (3994 <= 3820)) then
											return v28;
										end
										break;
									end
								end
							end
							v28 = v106();
							if ((1488 < 1641) and v28) then
								return v28;
							end
							if ((433 <= 2235) and v20.CastAnnotated(v93.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\21\254\236\146", "\17\66\191\165\198\135\236\119"))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v184 == 0) or (1838 > 2471)) then
							if ((2444 < 3313) and v36 and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\206\246\12\225\255\210", "\183\141\158\109\147\152")]:IsCastable()) then
								if (v24(v93.Charge, not v15:IsSpellInRange(v93.Charge)) or (3685 <= 185)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\47\1\231\30\43\12\166\1\45\0\232\76\126", "\108\76\105\134");
								end
							end
							v185 = v92.HandleDPSPotion(v15:BuffUp(v93.RecklessnessBuff));
							if ((738 <= 1959) and v185) then
								return v185;
							end
							if ((v91 < v98) or (1317 == 3093)) then
								if ((v52 and ((v31 and v60) or not v60)) or (2611 >= 4435)) then
									local v195 = 0;
									while true do
										if ((v195 == 0) or (117 > 4925)) then
											v28 = v104();
											if ((107 <= 4905) and v28) then
												return v28;
											end
											break;
										end
									end
								end
							end
							v184 = 1;
						end
						if ((v184 == 1) or (1004 > 4035)) then
							if (((v91 < v98) and v51 and ((v59 and v31) or not v59)) or (2802 < 369)) then
								local v193 = 0;
								while true do
									if ((1497 <= 2561) and (v193 == 1)) then
										if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\108\161\160\235\4\83\130\178\231\23\77\173\169\247", "\112\32\200\199\131")]:IsCastable() and v14:BuffDown(v93.RecklessnessBuff)) or (816 > 1712)) then
											if (v24(v93.LightsJudgment, not v15:IsSpellInRange(v93.LightsJudgment)) or (2733 == 2971)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\32\89\91\176\215\184\29\38\69\88\191\206\174\44\56\16\81\185\202\165\98\125\6", "\66\76\48\60\216\163\203");
											end
										end
										if ((2599 < 4050) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\156\143\107\246\93\194\43\181\130", "\68\218\230\25\147\63\174")]:IsCastable()) then
											if ((2034 == 2034) and v24(v93.Fireblood, not v101)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\171\35\65\73\180\161\37\92\72\246\160\43\90\66\246\252\114", "\214\205\74\51\44");
											end
										end
										v193 = 2;
									end
									if ((3040 < 4528) and (v193 == 2)) then
										if (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\219\66\225\249\100\238\94\227\240\84\251\64\238", "\23\154\44\130\156")]:IsCastable() or (2092 <= 2053)) then
											if ((2120 < 4799) and v24(v93.AncestralCall, not v101)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\16\168\174\171\37\7\3\167\161\145\53\18\29\170\237\163\55\26\31\230\255\254", "\115\113\198\205\206\86");
											end
										end
										if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\166\86\249\85\130\99\236\83\135\92\237", "\58\228\55\158")]:IsCastable() and v14:BuffDown(v93.RecklessnessBuff) and v14:BuffUp(v93.EnrageBuff)) or (4538 <= 389)) then
											if ((270 <= 1590) and v22(v93.BagofTricks, not v15:IsSpellInRange(v93.BagofTricks))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\182\136\215\17\51\171\10\160\155\217\45\55\190\117\185\136\217\32\124\255\103", "\85\212\233\176\78\92\205");
											end
										end
										break;
									end
									if ((1625 > 1265) and (v193 == 0)) then
										if (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\201\201\190\238\202\205\208\163\248", "\174\139\165\209\129")]:IsCastable() or (51 >= 920)) then
											if (v24(v93.BloodFury, not v101) or (2968 <= 1998)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\161\191\237\206\194\60\118\109\177\170\162\204\199\10\126\56\242\225", "\24\195\211\130\161\166\99\16");
											end
										end
										if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\100\6\251\63\86\4\77\10\231\43", "\118\38\99\137\76\51")]:IsCastable() and v14:BuffUp(v93.RecklessnessBuff)) or (3085 <= 2742)) then
											if (v24(v93.Berserking, not v101) or (376 >= 2083)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\255\35\23\1\12\50\246\47\11\21\73\45\252\47\11\82\88\116", "\64\157\70\101\114\105");
											end
										end
										v193 = 1;
									end
								end
							end
							if ((4191 > 1232) and (v91 < v98)) then
								local v194 = 0;
								while true do
									if ((2 == v194) or (1505 > 4873)) then
										if ((3880 < 4534) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\218\44\191\78\117\185\211", "\216\136\77\201\47\18\220\161")]:IsCastable() and (v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\46\249\57\201\7\206", "\226\77\140\75\186\104\188")) and v44 and ((v55 and v31) or not v55) and ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\152\216\209\43\78\171", "\47\217\174\176\95")]:CooldownRemains() < 3) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < 10))) then
											if (v24(v95.RavagerCursor, not v101) or (2368 >= 2541)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\170\220\96\3\181\81\106\102\181\220\127\12\242\6\32", "\70\216\189\22\98\210\52\24");
											end
										end
										if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\233\207\166\134\193\213\217\129\134\192\206\214\172\137", "\179\186\191\195\231")]:IsCastable() and (v85 == LUAOBFUSACTOR_DECRYPT_STR_0("\233\51\25\253\252\45", "\132\153\95\120")) and v47 and ((v57 and v31) or not v57) and v14:BuffUp(v93.EnrageBuff) and (v14:BuffUp(v93.RecklessnessBuff) or v14:BuffUp(v93.AvatarBuff) or (v98 < 20) or (v100 > 1) or not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\133\187\26\44\249\201\148\190\160\3\40\249\206", "\192\209\210\110\77\151\186")]:IsAvailable() or not v14:HasTier(31, 2))) or (4733 <= 4103)) then
											if (v24(v95.SpearOfBastionPlayer, not v101) or (1207 == 4273)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\243\19\39\232\237\251\239\5\29\235\254\215\244\10\45\231\191\201\225\10\44\169\172\148", "\164\128\99\66\137\159");
											end
										end
										v194 = 3;
									end
									if ((1 == v194) or (2005 == 2529)) then
										if ((986 < 3589) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\106\192\84\241\79\54\228\75\203\82\233\80", "\151\56\165\55\154\35\83")]:IsCastable() and v45 and ((v56 and v31) or not v56) and (not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\129\77\11\231\168\74\9\239\180\76\23", "\142\192\35\101")]:IsAvailable() or (v10.FightRemains() < 12))) then
											if (v24(v93.Recklessness, not v101) or (3119 == 430)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\196\112\42\168\235\137\191\5\216\112\58\176\167\129\173\31\216\53\123\244", "\118\182\21\73\195\135\236\204");
											end
										end
										if ((2409 <= 3219) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\58\61\12\65\3\8\239", "\157\104\92\122\32\100\109")]:IsCastable() and (v84 == LUAOBFUSACTOR_DECRYPT_STR_0("\179\170\206\211\56\53", "\203\195\198\175\170\93\71\237")) and v44 and ((v55 and v31) or not v55) and ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\15\93\63\193\80\3", "\156\78\43\94\181\49\113")]:CooldownRemains() < 3) or v14:BuffUp(v93.RecklessnessBuff) or (v98 < 10))) then
											if (v24(v95.RavagerPlayer, not v101) or (898 > 2782)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\96\233\210\162\12\70\107\50\229\197\170\5\3\43\42", "\25\18\136\164\195\107\35");
											end
										end
										v194 = 2;
									end
									if ((3 == v194) or (2250 <= 1764)) then
										if ((693 == 693) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\51\153\236\191\18\134\239\156\1\154\253\183\15\135", "\222\96\233\137")]:IsCastable() and (v85 == LUAOBFUSACTOR_DECRYPT_STR_0("\186\166\181\12\135\225", "\144\217\211\199\127\232\147")) and v47 and ((v57 and v31) or not v57) and v14:BuffUp(v93.EnrageBuff) and (v14:BuffUp(v93.RecklessnessBuff) or v14:BuffUp(v93.AvatarBuff) or (v98 < 20) or (v100 > 1) or not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\204\38\42\41\219\86\54\75\234\34\59\38\193", "\36\152\79\94\72\181\37\98")]:IsAvailable() or not v14:HasTier(31, 2))) then
											if (v24(v95.SpearOfBastionCursor, not v101) or (2529 == 438)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\196\200\66\62\197\231\72\57\232\218\70\44\195\209\72\49\151\213\70\54\217\152\20\110", "\95\183\184\39");
											end
										end
										break;
									end
									if ((1751 > 1411) and (v194 == 0)) then
										if ((4182 == 4182) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\107\78\137\246\75\74", "\130\42\56\232")]:IsCastable() and v32 and ((v53 and v31) or not v53) and ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\222\188\48\226\78\44\222\186\54\238\69\49\254", "\95\138\213\68\131\32")]:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.AvatarBuff) and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\5\44\184\77\101\12\61\179\90", "\22\74\72\193\35")]:CooldownRemains() > 0)) or (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\14\124\246\75\41\107\239\93\62\106\208\87\62\116\225\86\56", "\56\76\25\132")]:IsAvailable() and v14:BuffUp(v93.EnrageBuff) and v14:BuffDown(v93.AvatarBuff)) or (not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\106\200\191\39\193\77\245\164\52\194\91\207\191", "\175\62\161\203\70")]:IsAvailable() and not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\30\216\209\0\48\46\214\198\1\38\8\210\209\30\48\50\201", "\85\92\189\163\115")]:IsAvailable() and (v14:BuffUp(v93.RecklessnessBuff) or (v98 < 20))))) then
											if (v24(v93.Avatar, not v101) or (4666 <= 611)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\40\186\49\44\40\190\112\53\40\165\62\120\123\248", "\88\73\204\80");
											end
										end
										if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\28\134\19\77\37\223\61\144\30\67\58\201", "\186\78\227\112\38\73")]:IsCastable() and v45 and ((v56 and v31) or not v56) and ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\221\89\243\92\91\115\240\86\233\90\65", "\26\156\55\157\53\51")]:IsAvailable() and (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\173\206\23\205\185\66", "\48\236\184\118\185\216")]:CooldownRemains() < 1)) or (v93[LUAOBFUSACTOR_DECRYPT_STR_0("\196\171\86\36\206\38", "\84\133\221\55\80\175")]:CooldownRemains() > 40) or not v93[LUAOBFUSACTOR_DECRYPT_STR_0("\156\241\37\178\198\78", "\60\221\135\68\198\167")]:IsAvailable() or (v98 < 12))) or (4737 <= 4525)) then
											if ((4367 >= 3735) and v24(v93.Recklessness, not v101)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\252\184\251\136\78\220\253\174\246\134\81\202\174\176\249\138\76\153\188\235", "\185\142\221\152\227\34");
											end
										end
										v194 = 1;
									end
								end
							end
							if ((2426 == 2426) and v39 and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\157\58\245\41\93\131\54\189\45\232\49", "\98\213\95\135\70\52\224")]:IsCastable() and not v15:IsInRange(30)) then
								if ((21 < 1971) and v24(v93.HeroicThrow, not v15:IsInRange(30))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\246\166\219\120\93\253\156\221\127\70\241\180\137\122\85\247\173", "\52\158\195\169\23");
								end
							end
							if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\77\174\55\119\141\60\117\140\78\180\32\123\145", "\235\26\220\82\20\230\85\27")]:IsCastable() and v50 and v15:AffectingCombat() and v102()) or (2922 <= 441)) then
								if ((3624 >= 1136) and v24(v93.WreckingThrow, not v15:IsInRange(30))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\159\179\236\193\127\129\175\238\253\96\128\179\230\213\52\133\160\224\204", "\20\232\193\137\162");
								end
							end
							v184 = 2;
						end
					end
				end
				break;
			end
			if ((2043 < 2647) and (v125 == 0)) then
				v28 = v103();
				if (v28 or (354 >= 1534)) then
					return v28;
				end
				v125 = 1;
			end
		end
	end
	local function v109()
		local v126 = 0;
		while true do
			if ((v126 == 0) or (3764 >= 4876)) then
				if ((3676 >= 703) and not v14:AffectingCombat()) then
					local v186 = 0;
					while true do
						if ((3811 > 319) and (v186 == 0)) then
							if ((47 < 1090) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\45\170\188\0\250\250\231\212\29\156\186\18\241\235\233", "\177\111\207\206\115\159\136\140")]:IsCastable() and v14:BuffDown(v93.BerserkerStance, true)) then
								if (v24(v93.BerserkerStance) or (1371 >= 2900)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\7\140\2\7\209\93\84\0\155\47\7\192\78\81\6\140", "\63\101\233\112\116\180\47");
								end
							end
							if ((v93[LUAOBFUSACTOR_DECRYPT_STR_0("\225\58\249\6\244\51\240\51\226\7\236", "\86\163\91\141\114\152")]:IsCastable() and v33 and (v14:BuffDown(v93.BattleShoutBuff, true) or v92.GroupBuffMissing(v93.BattleShoutBuff))) or (1126 <= 504)) then
								if (v24(v93.BattleShout) or (3732 == 193)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\81\10\96\103\54\86\52\103\123\53\70\31\52\99\40\86\8\123\126\56\82\31", "\90\51\107\20\19");
								end
							end
							break;
						end
					end
				end
				if ((3344 >= 3305) and v92.TargetIsValid() and v29) then
					if (not v14:AffectingCombat() or (2885 < 1925)) then
						local v189 = 0;
						while true do
							if ((v189 == 0) or (4542 <= 1594)) then
								v28 = v105();
								if ((338 <= 3505) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v110()
		local v127 = 0;
		while true do
			if ((69 == 69) and (v127 == 8)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\11\239\226\39\0\252\229", "\150\78\110\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\205\50\239\160\27\173\79\144\214\21\238\165\12\136\73\145\205\4\197", "\32\229\165\71\129\196\126\223")];
				break;
			end
			if ((v127 == 5) or (672 == 368)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\49\69\249\231\11\78\234\224", "\147\98\32\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\80\230\248\7\64\74\31\70\241", "\43\120\35\131\170\102\54")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\103\3\147\162\172\190\131\71", "\228\52\102\231\214\197\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\243\112\248\239\136\18\218\27\243\102\196\239\152\10", "\182\126\128\21\170\138\235\121")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\223\33\242\143\29\55\21", "\102\235\186\85\134\230\115\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\66\31\59\108\98\209\35\69\35\56\125\115\199\54\94\3\48", "\66\55\108\94\63\18\180")];
				v127 = 6;
			end
			if ((1019 == 1019) and (v127 == 4)) then
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\112\26\174\179\11\125\68\12", "\19\35\127\218\199\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\232\15\213\14\254\9\233\21\245\13\214\20\233\5\245", "\130\124\155\106")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\230\206\226\187\170\248\123\172", "\223\181\171\150\207\195\150\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\89\41\230\143\31\77\46\226\188", "\105\44\90\131\206")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\229\166\173\1\48\248\243", "\94\159\128\210\217\104")][LUAOBFUSACTOR_DECRYPT_STR_0("\69\234\3\144\91\102\247\105\118\236\20\166", "\26\48\153\102\223\63\31\153")];
				v127 = 5;
			end
			if ((v127 == 6) or (290 > 2746)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\39\136\145\35\46\87\19\158", "\57\116\237\229\87\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\191\162\232\211\127\251\73\174\180\255\232\98\253\117\165\176\255", "\39\202\209\141\135\23\142")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\54\29\30\59\246\248\32", "\152\159\83\105\106\82")][LUAOBFUSACTOR_DECRYPT_STR_0("\128\208\80\230\200\78\182\207\69\250\234\120", "\60\225\166\49\146\169")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\27\59\62\8\9\40\13", "\103\79\126\79\74\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\181\123\202\125\120\15\168\102\228\122\74\18\153\91", "\122\218\31\179\19\62")];
				v127 = 7;
			end
			if ((1923 < 4601) and (v127 == 1)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\143\218\87\166\92\58\66", "\49\24\234\174\35\207\50\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\225\248\171\121\13\224\250\141", "\17\108\146\157\232")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\198\0\249\38\166\76\208", "\200\43\163\116\141\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\170\37\56\160\162\225\240\183\63\51\132\146\248\236\168", "\131\223\86\93\227\208\148")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\208\64\162\162\20\187\228\86", "\213\131\37\214\214\125")][LUAOBFUSACTOR_DECRYPT_STR_0("\51\56\32\154\249\35\40\48\171\228", "\129\70\75\69\223")];
				v127 = 2;
			end
			if ((v127 == 2) or (3957 == 2099)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\206\231\253\117\225\65\216", "\143\38\171\147\137\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\145\188\219\6\241\219\217\129\141\251\17\236\195", "\180\176\226\217\147\99\131")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\224\188\59\19\218\183\40\20", "\103\179\217\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\164\25\250\79\159\175\75\162\27\221\85", "\195\42\215\124\181\33\236")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\92\35\42\44\246\10\74", "\152\109\57\87\94\69")][LUAOBFUSACTOR_DECRYPT_STR_0("\236\196\15\145\191\213\93\166\254\245\6\172\169", "\200\153\183\106\195\222\178\52")];
				v127 = 3;
			end
			if ((4006 > 741) and (v127 == 3)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\230\156\41\64\84\53\240", "\58\82\131\232\93\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\150\68\213\39\92\50\147\86\215\16", "\95\227\55\176\117\61")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\43\123\55\95\162\22\121\48", "\203\120\30\67\43")][LUAOBFUSACTOR_DECRYPT_STR_0("\228\54\72\220\213\240\40", "\185\145\69\45\143")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\185\26\13\178\213\132\24\10", "\188\234\127\121\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\33\22\180\48\59\1\143\47\59\29\135", "\227\88\82\115")];
				v127 = 4;
			end
			if ((2359 <= 3733) and (v127 == 7)) then
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\211\217\213\192\175\66\160", "\37\211\182\173\161\169\193")][LUAOBFUSACTOR_DECRYPT_STR_0("\229\59\91\216\47\126\171\192\51\89\209\11\95", "\217\151\90\45\185\72\27")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\121\243\6\95\205\123\244", "\54\163\28\135\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\58\222\94\137\66\122\59\200\83\135\93\108\31\210\73\138\109\91", "\31\72\187\61\226\46")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\3\87\198\78\112\35\208", "\68\163\102\35\178\39\30")][LUAOBFUSACTOR_DECRYPT_STR_0("\173\96\223\198\17\154\133\51\191\99\206\206\12\187\180\24\170\120\249\227", "\113\222\16\186\167\99\213\227")];
				v127 = 8;
			end
			if ((v127 == 0) or (4596 <= 2402)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\245\145\251\52\131\247\150", "\93\237\144\229\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\229\245\59\10\82\1\250\245\42\3\73\0\226", "\38\117\150\144\121\107")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\190\250\46\36\181\233\41", "\90\77\219\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\23\36\27\64\8\117\226\6\32\45\68", "\26\134\100\65\89\44\103")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\230\36\55\173\255\228\35", "\196\145\131\80\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\163\3\42\20\231\17\180\18\0\17\250\13\164", "\136\126\208\102\104\120")];
				v127 = 1;
			end
		end
	end
	local function v111()
		local v128 = 0;
		while true do
			if ((2078 > 163) and (v128 == 4)) then
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\245\92\208\172\254\79\215", "\164\197\144\40")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\247\164\132\207\179\179\241\163\133\245\134", "\214\227\144\202\235\189")] or 0;
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\160\147\111\25\189\84\47", "\92\141\197\231\27\112\211\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\254\134\175\200\239\241\141\128\195\255\215\186", "\177\134\159\234\195")] or 0;
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\238\43\180\192\179\236\44", "\169\221\139\95\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\138\115\51\59\47\208\140\92\45\59\1\204\132\106\47", "\70\190\235\31\95\66")] or 0;
				v128 = 5;
			end
			if ((4116 > 737) and (v128 == 0)) then
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\140\208\149\136\219\196\154", "\181\163\233\164\225\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\69\152\59\71\69\134\51\114\92", "\23\48\235\94")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\79\223\204\73\94\61\213\111", "\178\28\186\184\61\55\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\209\222\66\15\230\1\231\201\239\72\48\230", "\149\164\173\39\92\146\110")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\192\34\4\11\19\21\244\52", "\123\147\71\112\127\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\222\135\88\72\216\196\143\120\66\205\217\139\127\65\255\197\141\100\82", "\38\172\173\226\17")];
				v128 = 1;
			end
			if ((v128 == 2) or (1175 > 4074)) then
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\53\236\48\84\239\138\35", "\129\237\80\152\68\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\68\187\1\193\29\27\84\72\161\10\244\63\5\65", "\56\49\200\100\147\124\119")];
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\255\59\171\228\197\48\184\227", "\144\172\94\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\49\28\167\110\42\27\167\85\50\10\172\66", "\39\68\111\194")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\163\243\211\112\185\209\181", "\215\182\198\135\167\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\90\239\108\136\79\239\70\158\64\252\77\190\93\235\70\142\76", "\40\237\41\138")];
				v128 = 3;
			end
			if ((1 == v128) or (1361 == 4742)) then
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\126\20\56\251\68\31\43\252", "\143\45\113\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\173\171\25\30\177\172\8\57\170\145\17\49\173\182\21\40\161", "\92\216\216\124")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\55\184\84\244\85\53\191", "\157\59\82\204\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\45\230\223\231\248\210\182\61\58\209\255\238\239\221\180\42\63\247\243\230\228", "\209\88\94\131\154\137\138\179")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\27\164\208\104\23\45\54\49", "\66\72\193\164\28\126\67\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\63\173\113\33\120\232\62\173\104\39\127\233", "\22\135\76\200\56\70")];
				v128 = 2;
			end
			if ((v128 == 5) or (4012 >= 4072)) then
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\231\14\242\236\180\229\9", "\133\218\130\122\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\241\247\193\206\181\61\50\250\203\244", "\88\92\159\131\164\188\195")] or 0;
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\43\171\95\222\229\218\147", "\189\224\78\223\43\183\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\42\249\140\19\207\61\245\156\19\242\58\253\132\21\196\6\204", "\161\78\156\234\118")] or 0;
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\148\178\221\200\174\185\206\207", "\188\199\215\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\7\76\111\233\242\10\90\83\216", "\136\156\105\63\27")] or 0;
				v128 = 6;
			end
			if ((3807 >= 1276) and (v128 == 6)) then
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\40\137\109\32\18\130\126\39", "\84\123\236\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\130\169\3\163\167\233\185\191\4\164\157\192", "\213\144\235\202\119\204")] or 0;
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\29\202\62\33\45\74\48", "\45\67\120\190\74\72\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\35\251\164\254\141\252\218\37\54\249\172\247\143", "\137\64\66\141\197\153\232\142")] or LUAOBFUSACTOR_DECRYPT_STR_0("\19\220\35\191\141\17", "\232\99\176\66\198");
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\223\36\60\18\114\131\254\63", "\76\140\65\72\102\27\237\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\89\202\19\211\197\50\187\94\206\31\220\208", "\222\42\186\118\178\183\97")] or LUAOBFUSACTOR_DECRYPT_STR_0("\77\224\69\147\88\254", "\234\61\140\36");
				break;
			end
			if ((2220 <= 4361) and (3 == v128)) then
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\244\113\238\236\67\201\115\233", "\42\167\20\154\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\237\167\116\120\34\94\241\176\91\67\52\89\246", "\65\42\158\194\34\17")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\34\70\24\36\227\28\253", "\142\122\71\50\108\77\141\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\171\235\12\62\7\139\242\21\46\27\171\235\1\19\37", "\91\117\194\159\120")] or 0;
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\24\42\12\60\255\35\9", "\68\122\125\94\120\85\145")][LUAOBFUSACTOR_DECRYPT_STR_0("\18\18\221\95\207\220\190\37\25\200\91\198\220\168\22\8\198\81\198\241\138", "\218\119\124\175\62\168\185")] or 0;
				v128 = 4;
			end
		end
	end
	local function v112()
		local v129 = 0;
		while true do
			if ((228 == 228) and (v129 == 3)) then
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\187\222\201\184\168\24\161\48", "\67\232\187\189\204\193\118\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\61\176\8\62\3\227\130\32\178\16\52\22\230\132\32", "\143\235\78\213\64\91\98")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\77\144\253\121\184\138\91", "\214\237\40\228\137\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\230\238\213\23\174\150\247\224\215\6\142\181", "\198\229\131\143\185\99")] or 0;
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\98\137\188\103\88\130\175\96", "\19\49\236\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\50\247\187\237\180\249\7\249\163\237\181\240\31\198", "\218\158\87\150\215\132")] or 0;
				v129 = 4;
			end
			if ((1 == v129) or (4118 <= 3578)) then
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\237\182\56\222\230\165\63", "\76\183\136\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\83\232\241\61\66\93\1\106\242\209\48\66\74\7\114\233\233\60", "\116\26\134\133\88\48\47")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\196\180\240\180\124\25\210", "\18\126\161\192\132\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\74\59\171\48\68\86\38\165\1\66\76", "\54\63\72\206\100")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\92\81\110\236\117\207\74", "\27\168\57\37\26\133")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\185\121\154\214\46\163\125\164\196", "\183\77\202\28\200")];
				v129 = 2;
			end
			if ((0 == v129) or (2915 < 1909)) then
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\216\174\102\6\47\218\169", "\111\65\189\218\18")][LUAOBFUSACTOR_DECRYPT_STR_0("\69\66\28\61\31\110\170\78\74\18\59\24\127\167\70\72\16", "\207\35\43\123\85\107\60")] or 0;
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\175\180\254\112\126\173\179", "\25\16\202\192\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\212\197\185\231\187\230\232\219\185\213\160\224\245\248\185\247\167", "\148\157\171\205\130\201")];
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\209\96\61\216\248\36\199", "\150\67\180\20\73\177")][LUAOBFUSACTOR_DECRYPT_STR_0("\164\22\14\72\159\10\15\93\153\55\20\65\148\47\18\68\153\29\22\68\158\12", "\45\237\120\122")];
				v129 = 1;
			end
			if ((634 <= 2275) and (v129 == 4)) then
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\200\27\205\246\63\44\202\232", "\173\155\126\185\130\86\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\205\163\187\203\129\226\226\150\181\211\129\227\235\136\187\202\141", "\140\133\198\218\167\232")] or "";
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\160\105\141\187\41\167", "\228\213\78\212\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\175\77\184\1\231\130\101\184\6\228\149\92\185\23\238\134\64", "\139\231\44\214\101")];
				break;
			end
			if ((1091 <= 2785) and (v129 == 2)) then
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\36\54\157\28\30\61\142\27", "\104\119\83\233")][LUAOBFUSACTOR_DECRYPT_STR_0("\225\234\46\44\72\240\236\52\21\74\225\240\4\6", "\35\149\152\71\66")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\237\86\164\51\23\239\81", "\90\121\136\34\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\213\15\86\23\198\2\70\41\206\26\93\61\227", "\126\167\110\53")];
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\14\21\58\236\213\49\58\3", "\95\93\112\78\152\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\212\230\128\61\225\191\222\213\253\150\1\235\176\215", "\178\161\149\229\117\132\222")];
				v129 = 3;
			end
		end
	end
	local function v113()
		local v130 = 0;
		while true do
			if ((4638 >= 2840) and (v130 == 1)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\229\255\207\77\85\249", "\33\48\138\152\168")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\25\53", "\87\18\118\80\49\161")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\17\221\167\188\73\13", "\208\44\126\186\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\30\183", "\46\151\122\196\166\116\156\169")];
				if (v14:IsDeadOrGhost() or (1292 > 4414)) then
					return;
				end
				if ((3511 == 3511) and v93[LUAOBFUSACTOR_DECRYPT_STR_0("\204\227\82\19\246\236\233\71\14\242\235\234\117\18\244\240\249", "\155\133\141\38\122")]:IsAvailable()) then
					v27 = 8;
				end
				v130 = 2;
			end
			if ((2132 == 2132) and (v130 == 0)) then
				v111();
				v110();
				v112();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\224\1\89\28\180\34", "\118\185\143\102\62\112\209\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\83\127\42", "\88\60\16\73\134\197\117\124")];
				v130 = 1;
			end
			if ((932 <= 3972) and (v130 == 2)) then
				if (v30 or (4560 <= 2694)) then
					local v187 = 0;
					while true do
						if ((v187 == 0) or (2531 >= 3969)) then
							v99 = v14:GetEnemiesInMeleeRange(v27);
							v100 = #v99;
							break;
						end
					end
				else
					v100 = 1;
				end
				v101 = v15:IsInMeleeRange(5);
				if (v92.TargetIsValid() or v14:AffectingCombat() or (738 > 2193)) then
					local v188 = 0;
					while true do
						if ((4606 >= 3398) and (v188 == 0)) then
							v97 = v10.BossFightRemains(nil, true);
							v98 = v97;
							v188 = 1;
						end
						if ((1853 > 1742) and (v188 == 1)) then
							if ((v98 == 11111) or (2442 > 2564)) then
								v98 = v10.FightRemains(v99, false);
							end
							break;
						end
					end
				end
				if ((4374 >= 4168) and not v14:IsChanneling()) then
					if (v14:AffectingCombat() or (4576 > 4938)) then
						local v190 = 0;
						while true do
							if ((2930 > 649) and (v190 == 0)) then
								v28 = v108();
								if (v28 or (1394 < 133)) then
									return v28;
								end
								break;
							end
						end
					else
						local v191 = 0;
						while true do
							if ((v191 == 0) or (432 == 495)) then
								v28 = v109();
								if ((66 < 1456) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v114()
		v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\3\63\190\88\15\72\164\55\56\165\78\93\63\167\60\106\137\81\70\124\235\101\25\185\81\95\112\183\49\47\168\1\77\102\229\61\1\173\79\74\107\170\107", "\197\69\74\204\33\47\31"));
	end
	v20.SetAPL(72, v113, v114);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\213\95\83\159\207\120\91\149\226\70\85\149\207\105\79\149\233\1\86\146\241", "\231\144\47\58")]();

