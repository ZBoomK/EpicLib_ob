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
		if ((v5 == 1) or (4960 < 1420)) then
			return v6(...);
		end
		if ((v5 == 0) or (3565 >= 4050)) then
			v6 = v0[v4];
			if ((3416 >= 187) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\150\200\16\218\252\236\44\232\191\208\31\221\200\222\55\168\183\210\31", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\159\37\2\49\118\177", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\210\53\233\83", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\209\88\178\85\249\88\177\67\238", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\152\120\104", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\150\67\197\180\51\99\32\196\183\90", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\96\86\5\40", "\69\41\34\96")];
	local v21 = EpicLib;
	local v22 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local v24 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\28\213\37\132\58", "\232\73\161\76")];
	local v26 = pairs;
	local v27 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\252\39", "\167\214\137\74\171\120\206\83")];
	local v28 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\168\255\63\80\247\169\152", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\0\188\57\30\25\183\46", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\91\127\24", "\126\167\52\16\116\217")];
	local v29 = false;
	local v30 = false;
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
	local v54;
	local v55;
	local v56;
	local v57;
	local v58;
	local v59;
	local v60 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\229\33\46\139", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\48\231\171\202\16\239\169\197\2\252", "\174\103\142\197")];
	local v61 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\123\39\81\51", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\227\205\224\88\195\197\226\87\209\214", "\60\180\164\142")];
	local v62 = v23[LUAOBFUSACTOR_DECRYPT_STR_0("\117\81\11\34", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\143\224\213\192\175\232\215\207\189\251", "\164\216\137\187")];
	local v63 = {v61[LUAOBFUSACTOR_DECRYPT_STR_0("\243\234\54\183\178\246\10\192\214\36\168\188\242\14\240\233\41", "\107\178\134\81\210\198\158")]:ID(),v61[LUAOBFUSACTOR_DECRYPT_STR_0("\26\11\131\197\165\54\26\141\210\162\61\44\135\223\165\54\10", "\202\88\110\226\166")]:ID(),v61[LUAOBFUSACTOR_DECRYPT_STR_0("\231\5\131\229\223\214\1", "\170\163\111\226\151")]:ID(),v61[LUAOBFUSACTOR_DECRYPT_STR_0("\53\34\179\63\65\57\47\24\34\183\26\65\58\43\53\57\161\40\75\57\58\20\34", "\73\113\80\210\88\46\87")]:ID(),v61[LUAOBFUSACTOR_DECRYPT_STR_0("\164\62\216\2\243\136\34\202\33\247\132\45\223\52\245\128\43\192\23\233\149", "\135\225\76\173\114")]:ID(),v61[LUAOBFUSACTOR_DECRYPT_STR_0("\55\236\182\185\175\154\181\19\232\190\164\163\175\164\18", "\199\122\141\216\208\204\221")]:ID()};
	local v64;
	local v65;
	local v66;
	local v67 = 11111;
	local v68 = 11111;
	local v69;
	local v70 = false;
	local v71 = false;
	local v72 = false;
	local v73 = v61[LUAOBFUSACTOR_DECRYPT_STR_0("\131\216\28\228\112\247\191\212\31\254\107\213\172\209\28\228\119\210\162\208\25\254\121\248\174\216", "\150\205\189\112\144\24")]:IsEquipped() or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\4\151\183\73\23\135\23\4\45\129\154\65\6\141\3\3\42\145\179", "\112\69\228\223\44\100\232\113")]:IsEquipped() or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\249\22\21\193\185\110\137\210\57\21\210\181\104\147\198\26\3\231\185\113\137\198\13\8\196\165", "\230\180\127\103\179\214\28")]:IsEquipped() or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\187\12\75\78\225\83\226\141\23\84\85\198\83\225\130\6\87", "\128\236\101\63\38\132\33")]:IsEquipped();
	local v74 = false;
	local v75 = false;
	local v76 = false;
	local v77 = ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\159\172\3\65\184\226\219\181", "\175\204\201\113\36\214\139")]:IsAvailable()) and 1) or 2;
	local v78 = {{v60[LUAOBFUSACTOR_DECRYPT_STR_0("\107\201\50\239\19\66\201\37", "\100\39\172\85\188")],LUAOBFUSACTOR_DECRYPT_STR_0("\142\121\170\148\115\129\125\190\192\0\186\125\188\144\115\229\75\173\149\61\228", "\83\205\24\217\224"),function()
		return true;
	end},{v60[LUAOBFUSACTOR_DECRYPT_STR_0("\212\204\195\58\201\195\253\56\231\198\200", "\93\134\165\173")],LUAOBFUSACTOR_DECRYPT_STR_0("\157\243\210\214\122\252\187\112\185\178\238\196\122\254\183\127\189\247\129\138\9\218\167\112\247", "\30\222\146\161\162\90\174\210"),function()
		return true;
	end},{v60[LUAOBFUSACTOR_DECRYPT_STR_0("\213\79\98\11\233\87\99\3\246", "\106\133\46\16")],LUAOBFUSACTOR_DECRYPT_STR_0("\123\33\96\232\26\112\89\50\114\240\67\83\81\51\51\180\105\84\77\46\58", "\32\56\64\19\156\58"),function()
		return true;
	end}};
	local v79 = false;
	local v80 = 0;
	local v81 = v13:GetEquipment();
	local v82 = (v81[13] and v20(v81[13])) or v20(0);
	local v83 = (v81[14] and v20(v81[14])) or v20(0);
	local v84 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\121\199\232\91\85\252\147", "\224\58\168\133\54\58\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\124\64\78\239\108\137\137\14", "\107\57\54\43\157\21\230\231")];
	local v85 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\248\132\28\248\182\210\220", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\160\143\71", "\24\92\207\225\44\131\25")];
	local function v86()
		v84[LUAOBFUSACTOR_DECRYPT_STR_0("\111\218\171\92\30\113\71\210\186\64\30\89\78\209\173\74\29\110", "\29\43\179\216\44\123")] = v25.MergeTable(v84.DispellablePoisonDebuffs, v84.DispellableDiseaseDebuffs);
	end
	v10:RegisterForEvent(function()
		v86();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\156\250\20\101\139\252\31\124\145\248\25\105\143\230\19\124\152\250\9\109\145\240\26\109\137\240\15\98\130\250\8\109\147\254\5\104", "\44\221\185\64"));
	v10:RegisterForEvent(function()
		local v130 = 0;
		while true do
			if ((1962 >= 1695) and (v130 == 1)) then
				v68 = 11111;
				break;
			end
			if ((v130 == 0) or (4961 == 3582)) then
				v80 = 0;
				v67 = 11111;
				v130 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\49\203\105\102\86\51\216\122\122\84\36\201\119\122\93\32\197\100\122\87", "\19\97\135\40\63"));
	v10:RegisterForEvent(function()
		v77 = ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\157\89\33\62\33\56\186\69", "\81\206\60\83\91\79")]:IsAvailable()) and 1) or 2;
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\125\155\245\94\3\240\114\135\102\138\254\85\10\231", "\196\46\203\176\18\79\163\45"), LUAOBFUSACTOR_DECRYPT_STR_0("\148\7\95\44\10\222\203\135\17\78\59\8\215\208\145\12\65\42\5\217", "\143\216\66\30\126\68\155"));
	v10:RegisterForEvent(function()
		local v131 = 0;
		while true do
			if ((924 == 924) and (v131 == 1)) then
				v83 = (v81[14] and v20(v81[14])) or v20(0);
				v73 = v61[LUAOBFUSACTOR_DECRYPT_STR_0("\132\205\1\223\205\162\197\232\165\198\30\232\196\175\219\245\165\236\2\198\204\173\214\239\169\205", "\129\202\168\109\171\165\195\183")]:IsEquipped() or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\3\75\63\221\205\27\224\54\80\50\253\211\22\227\48\75\56\205\210", "\134\66\56\87\184\190\116")]:IsEquipped() or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\17\56\27\169\22\249\46\51\26\35\8\184\13\254\51\48\56\5\6\182\22\249\51\58\43\34", "\85\92\81\105\219\121\139\65")]:IsEquipped() or v61[LUAOBFUSACTOR_DECRYPT_STR_0("\202\186\68\77\121\205\255\178\66\78\111\253\239\178\94\70\116", "\191\157\211\48\37\28")]:IsEquipped();
				break;
			end
			if ((v131 == 0) or (3153 < 1109)) then
				v81 = v13:GetEquipment();
				v82 = (v81[13] and v20(v81[13])) or v20(0);
				v131 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\239\51\213\37\31\237\32\209\45\15\246\47\217\57\20\235\32\215\52\27\241\56\209\56", "\90\191\127\148\124"));
	local function v87()
		return math.floor((v13:EnergyTimeToMaxPredicted() * 10) + 0.5) / 10;
	end
	local function v88()
		return math.floor(v13:EnergyPredicted() + 0.5);
	end
	local function v89(v132)
		return not v13:PrevGCD(1, v132);
	end
	local function v90()
		local v133 = 0;
		local v134;
		while true do
			if ((4301 == 4301) and (v133 == 0)) then
				if ((4494 >= 3295) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\85\134\60\28\119\129\58\31\125\164\60\22\118\130", "\119\24\231\78")]:IsAvailable()) then
					return 0;
				end
				v134 = 0;
				v133 = 1;
			end
			if ((3502 > 1144) and (v133 == 1)) then
				for v204, v205 in v26(v65) do
					if (v205:DebuffUp(v60.MarkoftheCraneDebuff) or (1276 == 3449)) then
						v134 = v134 + 1;
					end
				end
				return v134;
			end
		end
	end
	local function v91()
		local v135 = 0;
		local v136;
		local v137;
		local v138;
		while true do
			if ((v135 == 4) or (1761 == 1260)) then
				return v137;
			end
			if ((0 == v135) or (264 >= 1458)) then
				if (not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\175\44\183\65\211\70\5\138\40\134\88\221\78\20", "\113\226\77\197\42\188\32")]:IsAvailable() or (2661 <= 2372)) then
					return 0;
				end
				v136 = v90();
				v135 = 1;
			end
			if ((1042 < 4804) and (v135 == 3)) then
				v137 = v137 * (1 + (0.3 * v27(v13:BuffUp(v60.KicksofFlowingMomentumBuff))));
				v137 = v137 * (1 + (0.05 * v60[LUAOBFUSACTOR_DECRYPT_STR_0("\125\47\167\66\107\94\43\160", "\45\59\78\212\54")]:TalentRank()));
				v135 = 4;
			end
			if ((v135 == 2) or (3035 <= 721)) then
				if ((v136 > 0) or (3438 >= 3570)) then
					v137 = v137 * (1 + (v136 * v138));
				end
				v137 = v137 * (1 + (0.1 * v60[LUAOBFUSACTOR_DECRYPT_STR_0("\25\4\245\187\63\32\251\167\46\19\236", "\213\90\118\148")]:TalentRank()));
				v135 = 3;
			end
			if ((3772 > 2036) and (v135 == 1)) then
				v137 = 1;
				v138 = 0.18;
				v135 = 2;
			end
		end
	end
	local function v92()
		local v139 = 0;
		local v140;
		while true do
			if ((1 == v139) or (1868 > 3567)) then
				if ((2942 > 596) and ((v66 == v140) or (v140 >= 5))) then
					return true;
				end
				return false;
			end
			if ((0 == v139) or (3840 <= 3392)) then
				if (not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\61\87\145\128\137\40\185\248\21\117\145\138\136\43", "\144\112\54\227\235\230\78\205")]:IsAvailable() or (3798 <= 276)) then
					return true;
				end
				v140 = v90();
				v139 = 1;
			end
		end
	end
	local function v93()
		local v141 = 0;
		local v142;
		local v143;
		while true do
			if ((2400 >= 1045) and (v141 == 2)) then
				return v142;
			end
			if ((v141 == 0) or (2681 >= 2695)) then
				if (not (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\135\39\26\255\216\84\181\12\10\253\196\83", "\59\211\72\111\156\176")]:CooldownUp() or v13:BuffUp(v60.HiddenMastersForbiddenTouchBuff)) or (2750 > 4092)) then
					return nil;
				end
				v142, v143 = nil, nil;
				v141 = 1;
			end
			if ((2119 > 126) and (1 == v141)) then
				for v206, v207 in v26(v64) do
					if ((not v207:IsFacingBlacklisted() and not v207:IsUserCycleBlacklisted() and (v207:AffectingCombat() or v207:IsDummy()) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\103\138\243\25\65\146\224\37\65\129\199\40\79\147\235", "\77\46\231\131")]:IsAvailable() and (v207:HealthPercentage() <= 15)) or (v207:Health() < v13:Health())) and (not v143 or v25.CompareThis(LUAOBFUSACTOR_DECRYPT_STR_0("\183\85\174", "\32\218\52\214"), v207:Health(), v143))) or (3679 < 445)) then
						v142, v143 = v207, v207:Health();
					end
				end
				if ((v142 and (v142 == v14)) or (1459 < 845)) then
					if ((3609 > 2522) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\122\24\36\171\249\191\67\126\75\22\37\160", "\58\46\119\81\200\145\208\37")]:IsReady()) then
						return nil;
					end
				end
				v141 = 2;
			end
		end
	end
	local function v94()
		local v144 = 0;
		local v145;
		local v146;
		while true do
			if ((v144 == 0) or (781 <= 678)) then
				v145, v146 = nil, nil;
				for v208, v209 in v26(v65) do
					if ((4705 >= 2895) and not v209:IsFacingBlacklisted() and not v209:IsUserCycleBlacklisted() and (v209:AffectingCombat() or v209:IsDummy()) and (not v146 or v25.CompareThis(LUAOBFUSACTOR_DECRYPT_STR_0("\38\141\40", "\86\75\236\80\204\201\221"), v209:TimeToDie(), v146))) then
						v145, v146 = v209, v209:TimeToDie();
					end
				end
				v144 = 1;
			end
			if ((v144 == 1) or (1834 >= 3417)) then
				return v145;
			end
		end
	end
	local function v95(v147)
		return v147:DebuffRemains(v60.MarkoftheCraneDebuff);
	end
	local function v96(v148)
		return v148:DebuffRemains(v60.MarkoftheCraneDebuff) + (v27(v148:DebuffUp(v60.SkyreachExhaustionDebuff)) * 20);
	end
	local function v97(v149)
		return v149:DebuffRemains(v60.MarkoftheCraneDebuff) + (v27(v14:DebuffDown(v60.SkyreachExhaustionDebuff)) * 20);
	end
	local function v98(v150)
		return v150:DebuffRemains(v60.MarkoftheCraneDebuff) - (v27(v92()) * (v150:TimeToDie() + (v150:DebuffRemains(v60.SkyreachCritDebuff) * 20)));
	end
	local function v99(v151)
		return v151:DebuffRemains(v60.FaeExposureDebuff);
	end
	local function v100(v152)
		return v152:TimeToDie();
	end
	local function v101(v153)
		return v153:DebuffRemains(v60.SkyreachCritDebuff);
	end
	local function v102(v154)
		return v154:DebuffRemains(v60.FaeExposureDebuff);
	end
	local function v103(v155)
		return v155:DebuffRemains(v60.SkyreachExhaustionDebuff) > v13:BuffRemains(v60.CalltoDominanceBuff);
	end
	local function v104(v156)
		return v156:DebuffRemains(v60.SkyreachExhaustionDebuff) > 55;
	end
	local function v105()
		local v157 = 0;
		while true do
			if ((538 < 1701) and (v157 == 1)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\196\10\243\235\242\16\233\221", "\169\135\98\154")]:IsReady() and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\237\118\33\88\244\61\205\248\99\43\89\237", "\168\171\23\68\52\157\83")]:IsAvailable()) or (1571 >= 3089)) then
					if ((3095 >= 2083) and v24(v60.ChiBurst, not v14:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\247\121\252\146\39\56\149\231\101\181\189\55\40\132\251\124\247\172\49\109\209", "\231\148\17\149\205\69\77");
					end
				end
				if ((3277 >= 1776) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\163\175\206\204\86\233\133", "\159\224\199\167\155\55")]:IsReady()) then
					if ((1346 <= 1697) and v22(v60.ChiWave, nil, nil, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\244\251\53\237\224\242\42\215\183\227\46\215\244\252\49\208\246\231\124\138", "\178\151\147\92");
					end
				end
				break;
			end
			if ((v157 == 0) or (3976 <= 1502)) then
				if ((2866 >= 231) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\65\84\122\136\241\133\69\73\126\145\251\191\123\70\114\151\205\159\115\85\98\128", "\235\18\33\23\229\158")]:IsCastable() and v32) then
					if ((4589 > 612) and (v59 == LUAOBFUSACTOR_DECRYPT_STR_0("\96\182\192\162\85\168", "\219\48\218\161"))) then
						if ((429 <= 629) and v24(v62.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(5))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\247\100\113\68\212\65\223\243\121\117\93\222\112\244\237\118\121\91\228\92\244\229\101\105\76\155\95\242\225\114\115\68\217\78\244\164\35", "\128\132\17\28\41\187\47");
						end
					elseif ((4648 > 2774) and (v59 == LUAOBFUSACTOR_DECRYPT_STR_0("\34\39\20\41\82\19", "\61\97\82\102\90"))) then
						if ((529 == 529) and v24(v62.SummonWhiteTigerStatueCursor)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\191\59\166\70\200\89\33\30\164\39\191\78\248\67\23\14\169\60\148\88\211\86\10\28\169\110\187\89\194\84\17\4\174\47\191\11\149", "\105\204\78\203\43\167\55\126");
						end
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\128\178\51\27\31\44\198\67\168", "\49\197\202\67\126\115\100\167")]:IsReady() and (v13:Chi() < v13:ChiMax())) or (1905 == 4025)) then
					if ((83 < 2864) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\50\67\207\44\140\105\86\54\73\210\105\144\68\91\52\84\210\43\129\66\30\99", "\62\87\59\191\73\224\54");
					end
				end
				v157 = 1;
			end
		end
	end
	local function v106()
		local v158 = 0;
		while true do
			if ((1428 < 4728) and (v158 == 2)) then
				if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\22\58\248\253\42\55\234\229\49\49\252", "\145\94\95\153")]:IsReady() and v42 and (v13:HealthPercentage() <= v43)) or (4175 <= 2713)) then
					if (v24(v62.Healthstone, nil, nil, true) or (4061 < 3423)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\200\21\217\90\191\238\217\27\219\75\247\249\200\18\208\64\164\244\219\17\149\29", "\215\157\173\116\181\46");
					end
				end
				if ((3379 > 2901) and v39 and (v13:HealthPercentage() <= v41)) then
					if ((v40 == LUAOBFUSACTOR_DECRYPT_STR_0("\7\177\141\224\223\38\188\130\252\221\117\156\142\243\214\60\186\140\178\234\58\160\130\253\212", "\186\85\212\235\146")) or (2976 < 1937)) then
						if (v61[LUAOBFUSACTOR_DECRYPT_STR_0("\240\132\16\236\60\253\80\203\143\17\214\60\239\84\203\143\17\206\54\250\81\205\143", "\56\162\225\118\158\89\142")]:IsReady() or (2985 == 2843)) then
							if (v24(v62.RefreshingHealingPotion, nil, nil, true) or (2818 >= 3247)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\78\0\198\189\39\203\84\12\206\168\98\208\89\4\204\166\44\223\28\21\207\187\43\215\82\69\196\170\36\221\82\22\201\185\39\152\8", "\184\60\101\160\207\66");
							end
						end
					end
				end
				break;
			end
			if ((421 >= 252) and (v158 == 1)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\199\199\32\238\230\54\229\75\239\207\16\232\234\39", "\34\129\168\82\154\143\80\156")]:IsCastable() and v50 and v13:BuffDown(v60.DampenHarmBuff) and (v13:HealthPercentage() <= v51)) or (1823 > 4077)) then
					if ((4290 > 3567) and v24(v60.FortifyingBrew)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\163\189\33\31\65\72\144\140\188\52\75\106\92\140\146", "\233\229\210\83\107\40\46");
					end
				end
				if ((1926 <= 4924) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\229\75\52\208\16\210\71\31\215\2\200\65", "\101\161\34\82\182")]:IsCastable() and v56 and (v13:HealthPercentage() <= v57)) then
					if ((1432 == 1432) and v24(v60.DiffuseMagic)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\4\95\248\206\241\135\110\197\12\94\247\216", "\78\136\109\57\158\187\130\226");
					end
				end
				v158 = 2;
			end
			if ((v158 == 0) or (3116 <= 554)) then
				if ((3575 >= 2306) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\169\229\92\55\30\100\123\158\240", "\26\236\157\44\82\114\44")]:IsCastable() and v52 and (v13:HealthPercentage() <= v53)) then
					if (v24(v60.ExpelHarm) or (481 == 1636)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\15\54\197\94\38\110\253\90\56\35", "\59\74\78\181");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\1\208\87\74\182\43\249\91\72\190", "\211\69\177\58\58")]:IsCastable() and v54 and v13:BuffDown(v60.FortifyingBrewBuff) and (v13:HealthPercentage() <= v55)) or (1731 >= 2323)) then
					if ((1447 <= 2610) and v24(v60.DampenHarm)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\147\228\116\229\236\197\247\205\120\231\228", "\171\215\133\25\149\137");
					end
				end
				v158 = 1;
			end
		end
	end
	local function v107()
		local v159 = 0;
		local v160;
		while true do
			if ((2883 > 848) and (0 == v159)) then
				v160 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\2\135\104\168\56\140\123\175", "\220\81\226\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\218\146\207\248\206\29\222\135\239\201\200\29\209\139\239\227\200\29", "\167\115\181\226\155\138")] ~= "Don't Use";
				if ((3817 > 995) and v160 and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\207\35\233\85\120\86\212\235\39\225\72\116\99\197\234", "\166\130\66\135\60\27\17")]:IsEquippedAndReady()) then
					local v210 = 0;
					while true do
						if ((0 == v210) or (1451 >= 3387)) then
							if ((4973 >= 1280) and (v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\105\75\192\124\51\99\88\199\112\54\80\69\220\118\56", "\80\36\42\174\21")]:ID()) and not v83:HasUseBuff()) then
								if (v24(v62.TrinketTop, not v14:IsInRange(40)) or (4656 <= 2182)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\67\17\57\115\77\47\48\104\71\21\49\110\65\2\52\114\14\4\37\115\64\27\50\110\93\80\101", "\26\46\112\87");
								end
							end
							if (((v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\148\34\165\125\188\152\87\189\188\37\191\123\173\188\77", "\212\217\67\203\20\223\223\37")]:ID()) and not v82:HasUseBuff()) or (3859 < 3320)) then
								if (v24(v62.TrinketBottom, not v14:IsInRange(40)) or (3354 == 2971)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\183\140\166\219\185\178\175\192\179\136\174\198\181\159\171\218\250\153\186\219\180\134\173\198\169\205\250", "\178\218\237\200");
								end
							end
							break;
						end
					end
				end
				v159 = 1;
			end
			if ((v159 == 1) or (2944 < 1180)) then
				if ((2022 == 2022) and (v77 == 1)) then
					local v211 = 0;
					while true do
						if ((3488 > 1561) and (v211 == 0)) then
							if ((1799 <= 4264) and v160) then
								local v228 = 0;
								while true do
									if ((2708 >= 2333) and (v228 == 1)) then
										if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\169\192\14\176\60\22\218\141\196\6\173\48\35\203\140", "\168\228\161\96\217\95\81")]:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff() and v13:BuffDown(v60.SerenityBuff) and not v69) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\242\223\56\83\36\82\227\196\43\82\27\95\222\230\38\85\59\82\239\216\41\89\61", "\55\187\177\78\60\79")]:CooldownRemains() > 30) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\30\203\77\238\72\198\148\52", "\224\77\174\63\139\38\175")]:CooldownDown()) or (v68 < 5))) or (428 == 975)) then
											local v237 = 0;
											while true do
												if ((0 == v237) or (3051 <= 2528)) then
													if ((v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\169\64\86\39\135\102\74\39\129\71\76\33\150\66\80", "\78\228\33\56")]:ID()) or (2640 == 1627)) then
														if ((271 <= 3325) and v24(v62.TrinketTop, not v14:IsInRange(40))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\195\127\188\10\134\241\121\160\10\128\200\106\189\17\134\198\62\161\6\151\203\112\187\23\156\241\106\160\10\139\197\123\166\16\197\150", "\229\174\30\210\99");
														end
													end
													if ((4223 > 2897) and (v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\54\236\136\88\238\26\43\18\232\128\69\226\47\58\19", "\89\123\141\230\49\141\93")]:ID())) then
														if (v24(v62.TrinketBottom, not v14:IsInRange(40)) or (3336 < 2060)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\254\112\248\5\19\117\244\99\255\9\22\94\252\99\245\4\80\89\246\99\243\2\25\94\234\78\226\30\25\68\248\116\226\31\80\18", "\42\147\17\150\108\112");
														end
													end
													break;
												end
											end
										end
										if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\45\163\44\124\232\230\27\169\57\119\226\202\10\191\34\113\227", "\136\111\198\77\31\135")]:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff() and v13:BuffDown(v60.SerenityBuff) and not v69) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\43\7\177\89\182\225\47\188\7\7\147\94\184\211\31\160\22\12\147\95\186\225\5", "\201\98\105\199\54\221\132\119")]:CooldownRemains() > 30) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\138\9\145\36\12\60\184\160", "\204\217\108\227\65\98\85")]:CooldownDown()) or (v68 < 10))) or (487 < 263)) then
											local v238 = 0;
											while true do
												if ((v238 == 0) or (1512 > 2516)) then
													if ((4494 >= 4005) and (v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\124\198\244\230\35\206\74\204\225\237\41\226\91\218\250\235\40", "\160\62\163\149\133\76")]:ID())) then
														if (v24(v62.TrinketTop, not v14:IsInRange(45)) or (3408 >= 3920)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\212\165\12\44\204\216\159\25\32\252\194\168\8\16\193\211\185\2\33\199\150\179\8\61\198\216\169\25\54\252\194\178\4\33\200\211\180\30\111\155", "\163\182\192\109\79");
														end
													end
													if ((2045 < 3473) and (v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\22\35\1\195\250\58\50\15\212\253\49\4\5\217\250\58\34", "\149\84\70\96\160")]:ID())) then
														if (v24(v62.TrinketBottom, not v14:IsInRange(45)) or (855 >= 991)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\58\3\12\238\55\8\50\249\55\57\25\229\61\57\15\232\33\9\3\233\120\21\8\255\61\8\4\249\33\57\25\255\49\8\6\232\44\21\77\181", "\141\88\102\109");
														end
													end
													break;
												end
											end
										end
										break;
									end
									if ((1365 <= 4702) and (v228 == 0)) then
										if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\151\185\225\213\162\189\231\194\134\160\252\202\186\176\196\223\174", "\176\214\213\134")]:IsEquippedAndReady() and (((v69 or not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\221\163\160\219\163\83\97\225\168\184\224\160\83\110\252\164\162\209\156\95\94\241\191", "\57\148\205\214\180\200\54")]:IsAvailable()) and v13:BuffDown(v60.SerenityBuff)) or (v68 < 25))) or (219 >= 3457)) then
											local v239 = 0;
											while true do
												if ((1212 == 1212) and (v239 == 0)) then
													if (((v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\51\241\50\49\98\26\252\39\4\99\8\231\57\49\84\29\229", "\22\114\157\85\84")]:ID()) and not v83:HasUseBuff()) or (3586 > 3960)) then
														if (v24(v62.TrinketTop, not v14:IsInRange(40)) or (4068 == 506)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\197\199\20\193\73\254\169\214\244\3\209\71\236\164\193\244\17\203\69\182\187\193\217\22\202\84\226\177\251\223\1\205\83\253\173\208\216\83\144", "\200\164\171\115\164\61\150");
														end
													end
													if ((3331 >= 2972) and (v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\159\248\4\64\151\182\245\17\117\150\164\238\15\64\161\177\236", "\227\222\148\99\37")]:ID()) and not v82:HasUseBuff()) then
														if (v24(v62.TrinketBottom, not v14:IsInRange(40)) or (1492 > 2290)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\50\94\85\243\237\59\83\64\201\233\38\72\72\250\252\12\80\93\238\185\32\87\64\243\247\58\70\75\201\237\33\91\92\253\252\39\65\18\162", "\153\83\50\50\150");
														end
													end
													break;
												end
											end
										end
										if ((1163 <= 3508) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\120\100\102\12\103\162\67\90\69\99\25\114\185\107\79\119\116\17\118\165\89", "\45\61\22\19\124\19\203")]:IsEquippedAndReady() and (v13:BuffUp(v60.SerenityBuff))) then
											local v240 = 0;
											while true do
												if ((v240 == 0) or (2465 == 2663)) then
													if ((1211 <= 2088) and (v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\228\0\24\229\22\121\183\198\33\29\240\3\98\159\211\19\10\248\7\126\173", "\217\161\114\109\149\98\16")]:ID()) and not v83:HasUseBuff()) then
														if (v24(v62.TrinketTop, not v14:IsInRange(40)) or (3099 < 2736)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\23\50\45\108\168\125\28\39\7\111\172\113\19\50\7\122\174\117\21\45\61\114\168\52\1\37\42\121\178\125\6\57\7\104\174\125\28\43\61\104\175\52\68", "\20\114\64\88\28\220");
														end
													end
													if (((v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\20\19\199\164\236\217\179\54\50\194\177\249\194\155\35\0\213\185\253\222\169", "\221\81\97\178\212\152\176")]:ID()) and not v82:HasUseBuff()) or (210 >= 2468)) then
														if (v24(v62.TrinketBottom, not v14:IsInRange(40)) or (4487 < 4206)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\200\245\8\235\14\196\233\26\196\9\221\226\28\233\37\203\245\28\252\23\200\233\9\187\9\200\245\24\245\19\217\254\34\239\8\196\233\22\254\14\222\167\75", "\122\173\135\125\155");
														end
													end
													break;
												end
											end
										end
										v228 = 1;
									end
								end
							end
							if ((v35 and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\151\89\203\98\15\40\91", "\161\211\51\170\16\122\93\53")]:IsEquippedAndReady() and (((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\221\167\161\60\232\161\180\14\238\188\171", "\72\155\206\210")]:CooldownRemains() < 2) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\111\116\66\1\56\67\66\65\11\61\114\114\81\57\59\79\110\81\58\58\65\127\70", "\83\38\26\52\110")]:CooldownRemains() > 10)) or (v68 < 12))) or (4604 == 16)) then
								if (v24(v62.Djaruun, not v14:IsInRange(8)) or (410 == 611)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\92\29\38\84\77\2\41\121\72\30\43\74\89\5\24\73\94\40\51\78\93\40\34\74\92\18\53\121\94\27\38\75\93\87\52\67\74\18\41\79\76\14\24\82\74\30\41\77\93\3\52\6\9\69", "\38\56\119\71");
								end
							end
							v211 = 1;
						end
						if ((255 < 284) and (v211 == 1)) then
							if ((3624 == 3624) and v160) then
								local v229 = 0;
								while true do
									if ((v229 == 1) or (775 < 686)) then
										if (((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\25\16\150\23\74\53\38\149\29\79\4\22\133\47\73\57\10\133\44\72\55\27\146", "\33\80\126\224\120")]:CooldownRemains() > 30) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\223\173\17\193\82\229\188\26", "\60\140\200\99\164")]:CooldownDown()) or (3814 <= 975)) then
											local v241 = 0;
											while true do
												if ((v241 == 0) or (1956 <= 178)) then
													ShouldReturn = v84.HandleTopTrinket(v63, v32, 40, nil);
													if ((1657 <= 3112) and ShouldReturn) then
														return ShouldReturn;
													end
													v241 = 1;
												end
												if ((v241 == 1) or (389 >= 816)) then
													ShouldReturn = v84.HandleBottomTrinket(v63, v32, 40, nil);
													if ((3034 > 2266) and ShouldReturn) then
														return ShouldReturn;
													end
													break;
												end
											end
										end
										break;
									end
									if ((916 <= 1710) and (v229 == 0)) then
										if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\215\253\89\209\42\88\245\230\74\211\7\89\254\237\124\223\54\70\246\225\75\211\55", "\54\147\143\56\182\69")]:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff()) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\255\143\233\70\212\211\185\234\76\209\226\137\250\126\215\223\149\250\125\214\209\132\237", "\191\182\225\159\41")]:CooldownRemains() > 10) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\24\23\58\80\133\142\214\50", "\162\75\114\72\53\235\231")]:CooldownDown()) or (v68 < 10))) or (1646 == 3299)) then
											local v242 = 0;
											while true do
												if ((v242 == 0) or (25 == 1176)) then
													if ((v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\168\46\69\229\92\12\138\53\86\231\113\13\129\62\96\235\64\18\137\50\87\231\65", "\98\236\92\36\130\51")]:ID()) or (1842 <= 1070)) then
														if (v24(v62.TrinketTop, not v14:IsInRange(46)) or (4092 <= 738)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\160\11\13\189\74\166\179\57\182\28\51\184\74\165\183\15\160\16\31\170\64\166\166\53\182\89\24\168\76\166\190\53\176\10\76\235\17", "\80\196\121\108\218\37\200\213");
														end
													end
													if ((v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\36\97\3\120\68\0\140\9\97\7\93\68\3\136\36\122\17\111\78\0\153\5\97", "\234\96\19\98\31\43\110")]:ID()) or (2943 > 3317)) then
														if ((3065 < 3261) and v24(v62.TrinketBottom, not v14:IsInRange(46))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\2\13\83\192\163\124\141\15\13\87\248\174\125\134\4\32\86\206\191\98\142\8\12\87\213\236\102\153\15\17\89\194\184\97\203\87\75", "\235\102\127\50\167\204\18");
														end
													end
													break;
												end
											end
										end
										if (((v69 or not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\121\175\227\44\79\43\104\180\240\45\112\38\85\150\253\42\80\43\100\168\242\38\86", "\78\48\193\149\67\36")]:IsAvailable()) and v13:BuffUp(v60.SerenityBuff)) or (v68 < 25) or (1786 >= 2196)) then
											local v243 = 0;
											while true do
												if ((v243 == 0) or (1778 > 3742)) then
													ShouldReturn = v84.HandleTopTrinket(v63, v32, 40, nil);
													if ((2241 >= 904) and ShouldReturn) then
														return ShouldReturn;
													end
													v243 = 1;
												end
												if ((1 == v243) or (1273 >= 3110)) then
													ShouldReturn = v84.HandleBottomTrinket(v63, v32, 40, nil);
													if (ShouldReturn or (4284 < 464)) then
														return ShouldReturn;
													end
													break;
												end
											end
										end
										v229 = 1;
									end
								end
							end
							break;
						end
					end
				else
					local v212 = 0;
					while true do
						if ((4545 > 238) and (v212 == 0)) then
							if ((607 < 4327) and v160) then
								local v230 = 0;
								while true do
									if ((v230 == 0) or (3800 <= 893)) then
										if ((910 < 3460) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\166\248\3\35\182\143\245\22\22\183\157\238\8\35\128\136\236", "\194\231\148\100\70")]:IsEquippedAndReady() and (((v69 or not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\111\66\215\172\253\205\126\89\196\173\194\192\67\123\201\170\226\205\114\69\198\166\228", "\168\38\44\161\195\150")]:IsAvailable()) and v13:BuffDown(v60.StormEarthAndFireBuff)) or (v68 < 25))) then
											local v244 = 0;
											while true do
												if ((2175 == 2175) and (v244 == 0)) then
													if ((v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\161\240\133\115\36\224\183\4\176\233\152\108\60\237\148\25\152", "\118\224\156\226\22\80\136\214")]:ID()) or (1003 > 1556)) then
														if ((3693 == 3693) and v24(v62.TrinketTop)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\67\226\94\133\86\230\88\146\125\254\76\154\88\226\92\191\64\225\65\192\81\235\95\191\86\252\80\142\73\235\77\147\2\191\15", "\224\34\142\57");
														end
													end
													if ((v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\255\171\194\216\103\249\92\28\238\178\223\199\127\244\127\1\198", "\110\190\199\165\189\19\145\61")]:ID()) or (655 > 1501)) then
														if ((1721 < 1809) and v24(v62.TrinketBottom)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\219\231\112\237\159\207\219\249\72\248\158\221\192\231\114\215\137\200\194\171\100\237\141\248\206\249\126\230\128\194\206\248\55\185\221", "\167\186\139\23\136\235");
														end
													end
													break;
												end
											end
										end
										if ((2740 == 2740) and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\63\167\157\29\14\188\134\10\41\165\141\12\8\147\154\12\29\184\141\3\14", "\109\122\213\232")]:IsEquippedAndReady() and (v13:BuffUp(v60.InvokersDelightBuff))) then
											local v245 = 0;
											while true do
												if ((v245 == 0) or (95 >= 2754)) then
													if ((2453 <= 4911) and (v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\203\229\183\32\250\254\172\55\221\231\167\49\252\209\176\49\233\250\167\62\250", "\80\142\151\194")]:ID())) then
														if ((3208 < 3815) and v24(v62.TrinketTop, not v14:IsInRange(40))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\6\212\98\92\23\207\121\75\60\213\103\73\2\212\72\74\17\199\112\65\6\200\99\12\16\195\113\115\23\212\126\66\8\195\99\95\67\151\47", "\44\99\166\23");
														end
													end
													if ((v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\89\229\60\38\39\173\114\240\26\38\54\165\110\209\59\55\52\169\121\249\61", "\196\28\151\73\86\83")]:ID()) or (4914 <= 643)) then
														if (v24(v62.TrinketBottom, not v14:IsInRange(40)) or (4131 < 3861)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\246\17\60\0\150\81\22\113\204\16\57\21\131\74\39\112\225\2\46\29\135\86\12\54\224\6\47\47\150\74\17\120\248\6\61\3\194\9\64", "\22\147\99\73\112\226\56\120");
														end
													end
													break;
												end
											end
										end
										v230 = 1;
									end
									if ((3923 <= 4584) and (v230 == 1)) then
										if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\149\116\236\252\142\159\103\235\240\139\172\122\240\246\133", "\237\216\21\130\149")]:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff() and v13:BuffDown(v60.StormEarthAndFireBuff) and not v69) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\171\64\73\80\187\204\102\151\75\81\107\184\204\105\138\71\75\90\132\192\89\135\92", "\62\226\46\63\63\208\169")]:CooldownRemains() > 30)) or (v68 < 5))) or (2087 >= 2808)) then
											local v246 = 0;
											while true do
												if ((897 >= 428) and (0 == v246)) then
													if ((3875 <= 4416) and (v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\200\24\91\138\28\42\61\87\224\31\65\140\13\14\39", "\62\133\121\53\227\127\109\79")]:ID())) then
														if (v24(v62.TrinketTop) or (40 > 2063)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\29\21\60\252\213\145\165\2\29\55\243\194\161\176\19\28\114\230\211\168\157\4\6\59\251\221\171\182\3\84\96\165", "\194\112\116\82\149\182\206");
														end
													end
													if ((3347 > 2887) and (v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\20\169\66\17\195\197\28\48\173\74\12\207\240\13\49", "\110\89\200\44\120\160\130")]:ID())) then
														if ((4943 > 700) and v24(v62.TrinketBottom)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\166\194\69\79\64\117\60\95\162\198\77\82\76\88\56\69\235\208\78\64\124\94\41\68\165\200\78\82\80\10\105\29", "\45\203\163\43\38\35\42\91");
														end
													end
													break;
												end
											end
										end
										if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\240\128\221\32\136\167\64\221\145\212\38\165\172\77\221\139\216", "\52\178\229\188\67\231\201")]:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff() and v13:BuffDown(v60.StormEarthAndFireBuff) and not v69) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\8\79\70\11\252\89\27\52\68\94\48\255\89\20\41\72\68\1\195\85\36\36\83", "\67\65\33\48\100\151\60")]:CooldownRemains() > 30)) or (v68 < 10))) or (2802 >= 4413)) then
											local v247 = 0;
											while true do
												if ((3528 <= 4130) and (v247 == 0)) then
													if ((4423 >= 3045) and (v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\253\226\175\219\252\209\243\161\204\251\218\197\171\193\252\209\227", "\147\191\135\206\184")]:ID())) then
														if ((2726 == 2726) and v24(v62.TrinketTop, not v14:IsInRange(45))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\134\45\167\194\215\93\141\144\39\153\213\208\86\141\134\45\191\206\214\87\242\151\45\160\254\204\65\187\138\35\163\213\203\19\224\214", "\210\228\72\198\161\184\51");
														end
													end
													if ((v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\20\76\242\19\124\192\34\70\231\24\118\236\51\80\252\30\119", "\174\86\41\147\112\19")]:ID()) or (3011 < 172)) then
														if ((485 <= 4911) and v24(v62.TrinketBottom, not v14:IsInRange(45))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\89\5\140\8\42\1\46\191\84\63\153\3\32\48\19\174\66\15\131\15\101\28\20\173\100\20\159\2\43\4\20\191\72\64\223\89", "\203\59\96\237\107\69\111\113");
														end
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							if ((v35 and v61[LUAOBFUSACTOR_DECRYPT_STR_0("\0\28\173\243\36\229\217", "\183\68\118\204\129\81\144")]:IsEquippedAndReady() and (((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\40\164\99\240\24\141\8\139\101\246\18", "\226\110\205\16\132\107")]:CooldownRemains() < 2) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\194\205\246\214\74\238\251\245\220\79\223\203\229\238\73\226\215\229\237\72\236\198\242", "\33\139\163\128\185")]:CooldownRemains() > 10)) or (v68 < 12))) or (4 == 4906)) then
								if (v24(v62.Djaruun, not v14:IsInRange(8)) or (942 >= 2054)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\83\82\5\204\66\77\10\225\71\81\8\210\86\74\59\209\81\103\16\214\82\103\1\210\83\93\22\225\81\84\5\211\82\24\23\219\81\103\16\204\94\86\15\219\67\75\68\140\3", "\190\55\56\100");
								end
							end
							v212 = 1;
						end
						if ((415 <= 4986) and (v212 == 1)) then
							if (v160 or (3324 >= 4808)) then
								local v231 = 0;
								while true do
									if ((v231 == 0) or (729 == 2290)) then
										if ((v61[LUAOBFUSACTOR_DECRYPT_STR_0("\114\189\61\25\28\237\245\95\189\57\60\28\238\241\114\166\47\14\22\237\224\83\189", "\147\54\207\92\126\115\131")]:IsEquippedAndReady() and ((not v82:HasUseBuff() and not v83:HasUseBuff()) or ((v82:HasUseBuff() or v83:HasUseBuff()) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\36\63\35\114\6\123\53\36\48\115\57\118\8\6\61\116\25\123\57\56\50\120\31", "\30\109\81\85\29\109")]:CooldownRemains() > 10)) or (v68 < 10))) or (1361 <= 276)) then
											local v248 = 0;
											while true do
												if ((1700 < 3627) and (v248 == 0)) then
													if ((v82:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\219\99\85\177\57\208\250\246\99\81\148\57\211\254\219\120\71\166\51\208\239\250\99", "\156\159\17\52\214\86\190")]:ID()) or (4298 == 1123)) then
														if (v24(v62.TrinketTop, not v14:IsInRange(46)) or (4029 <= 3171)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\170\253\188\187\161\225\187\181\188\234\130\190\161\226\191\131\170\230\174\172\171\225\174\185\188\175\174\185\168\208\169\174\167\225\182\185\186\252\253\238\248", "\220\206\143\221");
														end
													end
													if ((2536 <= 4256) and (v83:ID() == v61[LUAOBFUSACTOR_DECRYPT_STR_0("\162\111\44\16\215\194\212\143\111\40\53\215\193\208\162\116\62\7\221\194\193\131\111", "\178\230\29\77\119\184\172")]:ID())) then
														if ((3202 <= 4105) and v24(v62.TrinketBottom, not v14:IsInRange(46))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\241\172\11\28\120\246\243\183\24\30\72\250\250\179\8\36\115\241\230\174\15\21\100\253\231\254\25\30\113\199\225\172\3\21\124\253\225\173\74\73\33", "\152\149\222\106\123\23");
														end
													end
													break;
												end
											end
										end
										if (((v69 or not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\244\40\224\76\190\216\30\227\70\187\233\46\243\116\189\212\50\243\119\188\218\35\228", "\213\189\70\150\35")]:IsAvailable()) and v13:BuffUp(v60.StormEarthAndFireBuff)) or (v68 < 25) or (2742 < 66)) then
											local v249 = 0;
											while true do
												if ((v249 == 1) or (1788 <= 394)) then
													ShouldReturn = v84.HandleBottomTrinket(v63, v32, 40, nil);
													if ((2920 >= 2247) and ShouldReturn) then
														return ShouldReturn;
													end
													break;
												end
												if ((v249 == 0) or (1547 == 1699)) then
													ShouldReturn = v84.HandleTopTrinket(v63, v32, 40, nil);
													if ((177 <= 3195) and ShouldReturn) then
														return ShouldReturn;
													end
													v249 = 1;
												end
											end
										end
										v231 = 1;
									end
									if ((796 <= 2110) and (1 == v231)) then
										if ((1057 <= 1754) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\102\91\98\7\68\80\76\29\74\91\64\0\74\98\124\1\91\80\64\1\72\80\102", "\104\47\53\20")]:CooldownRemains() > 30)) then
											local v250 = 0;
											while true do
												if ((v250 == 0) or (2479 < 2338)) then
													ShouldReturn = v84.HandleTopTrinket(v63, v32, 40, nil);
													if (ShouldReturn or (1622 == 4950)) then
														return ShouldReturn;
													end
													v250 = 1;
												end
												if ((v250 == 1) or (956 >= 4835)) then
													ShouldReturn = v84.HandleBottomTrinket(v63, v32, 40, nil);
													if (ShouldReturn or (2484 >= 4220)) then
														return ShouldReturn;
													end
													break;
												end
											end
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function v108()
		local v161 = 0;
		while true do
			if ((v161 == 3) or (3027 <= 2220)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\231\39\40\6\26\214\60\53", "\111\164\79\65\68")]:IsReady() and (v13:Chi() > 1) and (v13:ChiDeficit() >= 2)) or (2799 > 3682)) then
					if ((1087 == 1087) and v24(v60.ChiBurst, not v14:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\209\138\225\44\255\212\202\151\158\33\250\195\215\134\204\110\187\146", "\138\166\185\227\190\78");
					end
				end
				break;
			end
			if ((v161 == 1) or (573 > 1214)) then
				if ((3162 == 3162) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\38\134\167\92\9\137\167\99\20\136\175\64", "\48\96\231\194")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 2) and v14:DebuffDown(v60.SkyreachExhaustionDebuff)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInMeleeRange(5)) or (2695 > 3124)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\83\9\40\11\231\191\130\196\87\78\34\9\221\161\134\218\26\88", "\227\168\58\110\77\121\184\207");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\94\36\175\69\189\243\112\183\118", "\197\27\92\223\32\209\187\17")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\32\87\202\217\22\77\208\239", "\155\99\63\163")]:IsAvailable() and (v13:Chi() == 3)) or (3825 <= 3624)) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8)) or (528 > 1378)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\201\177\136\181\187\138\208\179\128\249\139\146\212\175\136\171\196\218", "\228\226\177\193\237\217");
					end
				end
				v161 = 2;
			end
			if ((372 <= 3822) and (v161 == 2)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\23\184\42\209\53\166\38", "\134\84\208\67")]:IsReady() and (v13:ChiDeficit() >= 2)) or (4962 == 4242)) then
					if (v22(v60.ChiWave, nil, nil, not v14:IsInRange(40)) or (589 >= 2928)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\164\143\99\4\173\144\89\83\163\150\89\29\169\148\28\66\252", "\60\115\204\230");
					end
				end
				if ((1018 < 1648) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\194\34\251\117\235\18\234\98\234", "\16\135\90\139")]:IsReady()) then
					if ((2354 == 2354) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\108\22\54\66\107\112\85\102\11\115\65\68\125\90\113\20\115\31\6", "\24\52\20\102\83\46\52");
					end
				end
				v161 = 3;
			end
			if ((v161 == 0) or (4287 <= 2462)) then
				if ((2505 > 1866) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\144\89\140\17\179\1\148\68\136\8\185\59\170\75\132\14\143\27\162\88\148\25", "\111\195\44\225\124\220")]:IsCastable() and v32) then
					if ((1614 < 2030) and (v59 == LUAOBFUSACTOR_DECRYPT_STR_0("\232\74\1\106\174\185", "\203\184\38\96\19\203"))) then
						if ((3431 > 2535) and v24(v62.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(5))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\42\102\116\76\193\55\76\110\73\199\45\118\70\85\199\62\118\107\126\221\45\114\109\84\203\121\124\105\68\192\60\97\57\19", "\174\89\19\25\33");
						end
					elseif ((2808 <= 2886) and (v59 == LUAOBFUSACTOR_DECRYPT_STR_0("\12\7\64\93\248\149", "\107\79\114\50\46\151\231"))) then
						if (v24(v62.SummonWhiteTigerStatueCursor) or (3049 > 3803)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\42\179\184\36\133\55\136\215\49\175\161\44\181\45\190\199\60\180\138\58\158\56\163\213\60\230\186\57\143\55\178\210\121\244", "\160\89\198\213\73\234\89\215");
						end
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\109\105\164\251\201\96\112\166\243", "\165\40\17\212\158")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\198\209\1\17\51\247\202\28", "\70\133\185\104\83")]:IsAvailable() and (v13:ChiDeficit() >= 3)) or (4184 < 2034)) then
					if ((1093 == 1093) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\93\84\47\197\59\77\69\56\196\68\74\84\47\199\1\87\4\126", "\169\100\37\36\74");
					end
				end
				v161 = 1;
			end
		end
	end
	local function v109()
		local v162 = 0;
		while true do
			if ((v162 == 2) or (2141 >= 3892)) then
				if ((4867 == 4867) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\41\139\165\71\0\136\177\80\32\142\167\79", "\36\107\231\196")]:IsReady() and v89(v60.BlackoutKick) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\106\189\171\149\81\188\172\128\121\167\163\128\82\187\146\146\83\182\170", "\231\61\213\194")]:IsAvailable() and not v92()) then
					if ((2497 >= 524) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\4\164\51", "\19\105\205\93"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\4\223\130\52\166\29\202\190\52\160\11\213\193\61\173\10\225\146\58\189\29\206\193\103", "\95\201\104\190\225");
					end
				end
				if ((1618 <= 4765) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\155\194\198\203\189\251\192\194\162", "\174\207\171\161")]:IsReady() and v89(v60.TigerPalm) and (v13:ChiDeficit() >= 2) and v13:BuffUp(v60.StormEarthAndFireBuff)) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\224\247\3", "\183\141\158\109\147\152"), v96, nil, not v14:IsInMeleeRange(5)) or (4514 < 2853)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\0\225\9\62\54\246\13\32\4\166\14\40\11\217\31\41\29\243\28\108\95", "\108\76\105\134");
					end
				end
				break;
			end
			if ((v162 == 0) or (1515 == 57)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\248\96\215\62\89\38\22\205\96\205\50\101\42\23\207\120\202\37\86", "\121\171\20\165\87\50\67")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\242\48\172\56\189\7\212\62\176\37\173", "\98\166\88\217\86\217")]:IsAvailable() and (v66 > 3)) or (1912 <= 1430)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\251\247\97", "\188\150\150\25\97\230"), v101, nil, not v14:IsInMeleeRange(9)) or (2561 >= 3596)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\157\77\11\7\232\229\134\89\61\24\229\223\182\72\11\2\233\214\134\77\6\76\239\222\139\96\17\9\249\207\153\31\80", "\141\186\233\63\98\108");
					end
				end
				if ((2784 < 3450) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\211\229\34\179\33\228\249\56\148\55\244\253", "\69\145\138\76\214")]:IsCastable() and v92() and (v13:Chi() >= 4)) then
					if ((3547 == 3547) and (v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\64\195\136\144\186\4", "\118\16\175\233\233\223"))) then
						if ((4680 >= 4133) and v24(v62.BonedustBrewPlayer, not v14:IsInRange(8))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\137\139\59\190\234\158\110\159\187\55\169\235\156\61\137\128\55\132\253\142\105\158\148\117\239", "\29\235\228\85\219\142\235");
						end
					elseif ((893 <= 2982) and (v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\30\219\180\219\126\92\42\83\41\221\181\211", "\50\93\180\218\189\23\46\71"))) then
						if (v24(v60.BonedustBrew, not v14:IsInRange(40)) or (1562 <= 984)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\220\171\85\73\64\201\91\202\155\89\94\65\203\8\220\160\89\115\87\217\92\203\180\27\24", "\40\190\196\59\44\36\188");
						end
					elseif ((4401 > 2756) and (v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\31\80\206\167\245\111", "\109\92\37\188\212\154\29"))) then
						if ((1890 == 1890) and v24(v62.BonedustBrewCursor, not v14:IsInRange(40))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\6\224\170\198\53\79\23\251\155\193\35\95\19\175\166\199\51\101\23\234\176\214\33\26\80", "\58\100\143\196\163\81");
						end
					elseif ((929 == 929) and (v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\63\76\38\174\38\9\240\0\30\71\49\227\28\92\247\29\21\80", "\110\122\34\67\195\95\41\133"))) then
						if ((v16 and v16:Exists() and v13:CanAttack(v16)) or (4055 >= 4687)) then
							if (v24(v62.BonedustBrewCursor, not v14:IsInRange(40)) or (2602 >= 3961)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\119\190\85\79\210\96\162\79\117\212\103\180\76\10\212\113\179\100\89\211\97\164\75\10\130", "\182\21\209\59\42");
							end
						end
					end
				end
				v162 = 1;
			end
			if ((v162 == 1) or (2297 > 2981)) then
				if ((2841 < 4145) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\133\94\214\20\47\185\132\66\203\54\40\189\188", "\222\215\55\165\125\65")]:IsReady() and v89(v60.RisingSunKick) and (v13:Chi() >= 5) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\27\217\207\8\254\200\227\77\8\195\199\29\253\207\221\95\34\210\206", "\42\76\177\166\122\146\161\141")]:IsAvailable()) then
					if ((3295 <= 4559) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\168\131\11", "\22\197\234\101\174\25"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\61\182\213\120\168\232\149\56\58\154\215\127\172\220\198\47\48\167\227\101\170\195\147\61\116\244\140", "\230\77\84\197\188\22\207\183");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\203\29\213\245\130\166\195\32\247\63\207\255\135", "\85\153\116\166\156\236\193\144")]:IsReady() and v89(v60.RisingSunKick) and (v66 >= 2) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\147\232\68\161\232\9\170\231\105\161\229\7\171\238\125\166\234\3\172", "\96\196\128\45\211\132")]:IsAvailable()) or (3866 <= 3295)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\56\132\117", "\184\85\237\27\63\178\207\212"), v98, nil, not v14:IsInMeleeRange(5)) or (3007 <= 2600)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\26\80\26\86\6\94\54\76\29\87\54\84\1\90\2\31\10\93\11\96\27\92\29\74\24\25\88\13", "\63\104\57\105");
					end
				end
				v162 = 2;
			end
		end
	end
	local function v110()
		local v163 = 0;
		while true do
			if ((1959 < 3128) and (3 == v163)) then
				if ((4909 >= 2489) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\18\36\48\188\233\41\45\14\190\243\43\42", "\129\70\75\69\223")]:IsCastable() and v48 and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\111\197\229\230\119\234\126\222\246\231\72\231\67\252\251\224\104\234\114\194\244\236\110", "\143\38\171\147\137\28")]:IsAvailable() and ((v68 > 90) or v69 or v71 or (v68 < 16))) or (not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\249\140\175\252\8\230\236\197\135\183\199\11\230\227\216\139\173\246\55\234\211\213\144", "\180\176\226\217\147\99\131")]:IsAvailable() and ((v68 > 159) or v71)))) then
					if ((681 <= 1651) and v22(v60.TouchofKarma, nil, nil, not v14:IsInRange(20))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\199\182\58\4\219\134\32\1\236\178\46\21\222\184\111\4\215\134\60\2\213\249\125\87", "\103\179\217\79");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\107\185\31\208\82\152\177\75\187\63\212\77\128", "\195\42\215\124\181\33\236")]:IsCastable() and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\36\87\33\49\46\253\53\76\50\48\17\240\8\110\63\55\49\253\57\80\48\59\55", "\152\109\57\87\94\69")]:CooldownRemains() > 30) or v71 or (v68 < 20))) or (2226 == 2073)) then
					if (v22(v60.AncestralCall, nil) or (1256 <= 914)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\217\9\166\173\198\70\169\245\232\9\162\178\222\20\171\253\232\25\166\184\146\6\250", "\200\153\183\106\195\222\178\52");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\16\239\135\50\77\124\39\241\145", "\58\82\131\232\93\41")]:IsCastable() and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\170\89\198\26\86\58\187\66\213\27\105\55\134\96\216\28\73\58\183\94\215\16\79", "\95\227\55\176\117\61")]:CooldownRemains() > 30) or v71 or (v68 < 20))) or (3549 == 3304)) then
					if ((3957 >= 496) and v22(v60.BloodFury, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\26\114\44\68\175\39\120\54\89\178\88\125\39\116\184\29\120\99\25\255", "\203\120\30\67\43");
					end
				end
				v163 = 4;
			end
			if ((3217 < 3403) and (v163 == 0)) then
				if ((3337 > 1679) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\216\208\188\236\193\229\242\185\232\218\238\241\184\230\203\249\246\165\224\218\254\192", "\174\139\165\209\129")]:IsCastable() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\138\189\244\206\205\6\72\109\166\189\214\201\195\52\120\113\183\182\214\200\193\6\98", "\24\195\211\130\161\166\99\16")]:CooldownUp() or (v66 > 4) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\111\13\255\35\88\19\126\22\236\34\103\30\67\52\225\37\71\19\114\10\238\41\65", "\118\38\99\137\76\51")]:CooldownRemains() > 50) or (v68 <= 30))) then
					if ((4054 > 2868) and (v59 == LUAOBFUSACTOR_DECRYPT_STR_0("\205\42\4\11\12\50", "\64\157\70\101\114\105"))) then
						if ((105 == 105) and v24(v62.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(5))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\83\189\170\238\31\78\151\176\235\25\84\173\152\247\25\71\173\181\220\3\84\169\179\246\21\0\171\163\220\3\69\174\231\177", "\112\32\200\199\131");
						end
					elseif ((v59 == LUAOBFUSACTOR_DECRYPT_STR_0("\15\69\78\171\204\185", "\66\76\48\60\216\163\203")) or (323 > 1478)) then
						if ((4447 >= 1218) and v24(v62.SummonWhiteTigerStatueCursor)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\169\147\116\254\80\192\27\173\142\112\231\90\241\48\179\129\124\225\96\221\48\187\146\108\246\31\205\32\133\149\124\245\31\156", "\68\218\230\25\147\63\174");
						end
					end
				end
				if ((1617 < 3823) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\132\36\69\67\189\168\18\70\73\184\153\34\86\123\190\164\62\86\120\191\170\47\65", "\214\205\74\51\44")]:IsCastable() and ((not v71 and (v14:TimeToDie() > 25) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\216\67\236\249\115\239\95\246\222\101\255\91", "\23\154\44\130\156")]:IsAvailable() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\51\169\163\171\50\6\2\178\143\188\51\4", "\115\113\198\205\206\86")]:CooldownRemains() <= 5) and (((v66 < 3) and (v13:Chi() >= 3)) or ((v66 >= 3) and (v13:Chi() >= 2)))) or (v68 < 25))) then
					if ((3938 > 1444) and v22(v60.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\141\89\232\85\143\82\193\66\145\82\240\101\144\95\251\101\147\95\247\78\129\104\234\83\131\82\236\26\135\83\193\73\129\81\190\14", "\58\228\55\158");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\157\135\198\33\55\168\13\161\140\222\26\52\168\2\188\128\196\43\8\164\50\177\155", "\85\212\233\176\78\92\205")]:IsCastable() and (((v14:TimeToDie() > 25) and (v68 > 120)) or ((v68 < 60) and ((v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < 2) or (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > 55)) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\121\93\154\231\68\81\156\251", "\130\42\56\232")]:CooldownUp() and (v66 < 3)) or v13:BloodlustUp() or (v68 < 23))) or (2072 >= 3876)) then
					if ((2047 >= 1089) and v22(v60.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\187\50\236\75\58\213\173\49\230\78\0\254\189\33\220\87\55\227\161\33\220\84\54\237\176\54\163\67\59\213\166\33\229\0\105", "\95\138\213\68\131\32");
					end
				end
				v163 = 1;
			end
			if ((v163 == 5) or (2230 > 4660)) then
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\124\240\1\183\75\108\211\111\84\254\11\186\81\107", "\26\48\153\102\223\63\31\153")]:IsCastable() or (3606 <= 1639)) then
					if (v22(v60.LightsJudgment, nil) or (4348 <= 1961)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\14\73\234\251\22\83\210\249\23\68\234\254\7\78\249\179\1\68\210\224\7\70\173\160\80", "\147\98\32\141");
					end
				end
				break;
			end
			if ((597 <= 3439) and (v163 == 2)) then
				if ((v13:BuffDown(v60.BonedustBrewBuff) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\154\210\120\7\182\65\107\50\154\207\115\21", "\70\216\189\22\98\210\52\24")]:IsAvailable() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\248\208\173\130\215\207\204\183\165\193\223\200", "\179\186\191\195\231")]:CooldownRemains() <= 2) and (((v68 > 60) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\202\43\23\246\244\26\25\246\237\55\57\234\253\25\17\246\252", "\132\153\95\120")]:Charges() > 0) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\130\166\1\63\250\255\161\163\166\6\12\249\222\134\184\160\11", "\192\209\210\110\77\151\186")]:CooldownRemains() > 10)) and (v69 or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\201\13\52\230\244\193\216\22\39\231\203\204\229\52\42\224\235\193\212\10\37\236\237", "\164\128\99\66\137\159")]:CooldownRemains() > 10) or v71)) or ((v69 or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\41\135\255\177\11\140\209\171\5\135\221\182\5\190\225\183\20\140\221\183\7\140\251", "\222\96\233\137")]:CooldownRemains() > 13)) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\138\167\168\13\133\214\241\171\167\175\62\134\247\214\176\161\162", "\144\217\211\199\127\232\147")]:Charges() > 0) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\203\59\49\58\216\96\3\86\236\39\31\38\209\99\11\86\253", "\36\152\79\94\72\181\37\98")]:CooldownRemains() > 13) or v13:BuffUp(v60.StormEarthAndFireBuff))))) or (2832 <= 2081)) then
					local v213 = 0;
					local v214;
					while true do
						if ((v213 == 0) or (2972 < 1266)) then
							v214 = v109();
							if ((4985 >= 4938) and v214) then
								return v214;
							end
							break;
						end
					end
				end
				if ((3854 <= 4222) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\228\204\72\45\218\253\70\45\195\208\102\49\211\254\78\45\210", "\95\183\184\39")]:IsCastable() and ((v68 < 20) or ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\232\52\89\165\3\167\43\239\7\90\132\36\188\45\226", "\98\213\95\135\70\52\224")]:Charges() == 2) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\215\173\223\120\95\251\155\220\114\90\202\171\204\64\92\247\183\204\67\93\249\166\219", "\52\158\195\169\23")]:CooldownRemains() > v60[LUAOBFUSACTOR_DECRYPT_STR_0("\73\168\61\102\139\16\122\153\110\180\19\122\130\19\114\153\127", "\235\26\220\82\20\230\85\27")]:FullRechargeTime()) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\174\168\250\214\103\135\167\207\215\102\145", "\20\232\193\137\162")]:CooldownRemains() <= 9) and (v13:Chi() >= 2) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\21\215\204\180\235\133\25\118\6\205\196\161\232\130\39\100\44\220\205", "\17\66\191\165\198\135\236\119")]:CooldownRemains() <= 12)))) then
					if ((4938 >= 3580) and v22(v60.StormEarthAndFire, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\187\161\1\242\215\233\208\29\187\166\44\254\230\232\238\9\166\188\22\191\235\232\238\28\170\168\83\174\186", "\177\111\207\206\115\159\136\140");
					end
				end
				if ((144 < 1902) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\49\134\5\23\220\64\89\33\140\17\0\220", "\63\101\233\112\116\180\47")]:CooldownUp() and v49) then
					local v215 = 0;
					local v216;
					local v217;
					while true do
						if ((v215 == 0) or (421 == 3932)) then
							v216 = v13:IsInParty() and not v13:IsInRaid();
							v217 = nil;
							v215 = 1;
						end
						if ((2430 < 3134) and (v215 == 1)) then
							if ((v30 and v31) or (2771 < 2028)) then
								v217 = v93();
							elseif (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\247\52\248\17\240\57\197\31\232\19\236\62", "\86\163\91\141\114\152")]:IsReady() or (1945 >= 3481)) then
								v217 = v14;
							end
							if ((3454 > 2697) and v217) then
								if ((4947 == 4947) and ((v216 and v13:BuffDown(v60.SerenityBuff) and v89(v60.TouchofDeath) and (v217:Health() < v13:Health())) or (v13:BuffRemains(v60.HiddenMastersForbiddenTouchBuff) < 2) or (v13:BuffRemains(v60.HiddenMastersForbiddenTouchBuff) > v217:TimeToDie()))) then
									if ((v217:GUID() == v14:GUID()) or (4848 <= 1621)) then
										if (v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(5)) or (466 >= 1015)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\71\4\97\112\50\108\4\114\76\62\86\10\96\123\122\80\15\75\96\63\85\75\121\114\51\93\70\96\114\40\84\14\96\51\107\7", "\90\51\107\20\19");
										end
									elseif ((3863 > 3479) and (((GetTime() - v84[LUAOBFUSACTOR_DECRYPT_STR_0("\161\241\150\251\9\140\226\130\234\41\190\231\132\255", "\93\237\144\229\143")]) * 1000) >= v34)) then
										local v272 = 0;
										while true do
											if ((v272 == 0) or (2508 == 3444)) then
												v84[LUAOBFUSACTOR_DECRYPT_STR_0("\57\247\227\13\63\71\7\241\245\13\56\81\20\230", "\38\117\150\144\121\107")] = GetTime();
												if (v24(v23(100)) or (2446 >= 3538)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\57\180\251\57\37\132\225\60\18\191\235\59\57\179\174\57\41\132\253\63\43\251\225\60\43\246\250\59\63\188\235\46\109\234\186", "\90\77\219\142");
												end
												break;
											end
										end
									end
								end
							end
							v215 = 2;
						end
						if ((2048 >= 694) and (v215 == 2)) then
							if ((3567 >= 2014) and v217 and v89(v60.TouchofDeath)) then
								if (v216 or (2154 <= 190)) then
									if ((v217:TimeToDie() > 60) or v217:DebuffUp(v60.BonedustBrewDebuff) or (v68 < 10) or (4182 < 2753)) then
										if ((4793 > 2182) and (v217:GUID() == v14:GUID())) then
											if ((4161 >= 1826) and v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(5))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\242\11\52\58\68\56\117\224\59\37\60\77\19\114\166\7\37\6\95\2\124\166\9\32\48\66\74\110\231\22\38\60\88\71\43\176", "\26\134\100\65\89\44\103");
											end
										elseif ((2856 >= 1815) and (((GetTime() - v84[LUAOBFUSACTOR_DECRYPT_STR_0("\221\226\35\55\144\240\241\55\38\176\194\244\49\51", "\196\145\131\80\67")]) * 1000) >= v34)) then
											local v276 = 0;
											while true do
												if ((2721 > 1181) and (v276 == 0)) then
													v84[LUAOBFUSACTOR_DECRYPT_STR_0("\50\177\21\28\44\233\12\183\3\28\43\255\31\160", "\136\126\208\102\104\120")] = GetTime();
													if ((4055 < 4831) and v24(v23(100))) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\108\133\219\64\167\109\50\87\71\142\203\66\187\90\125\82\124\181\221\70\169\18\50\87\126\199\218\66\189\85\56\69\56\219\152", "\49\24\234\174\35\207\50\93");
													end
													break;
												end
											end
										end
									end
								elseif ((v217:GUID() == v14:GUID()) or (2959 == 3187)) then
									if (v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(5)) or (32 > 3887)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\24\253\232\139\121\51\253\251\183\117\9\243\233\128\49\15\246\194\155\116\10\178\240\137\120\2\191\233\137\99\11\247\233\200\32\84", "\17\108\146\157\232");
									end
								elseif ((3814 >= 3781) and (((GetTime() - v84[LUAOBFUSACTOR_DECRYPT_STR_0("\103\194\7\249\27\169\89\196\17\249\28\191\74\211", "\200\43\163\116\141\79")]) * 1000) >= v34)) then
									local v273 = 0;
									while true do
										if ((670 <= 1936) and (v273 == 0)) then
											v84[LUAOBFUSACTOR_DECRYPT_STR_0("\147\55\46\151\132\245\241\184\51\41\176\167\245\243", "\131\223\86\93\227\208\148")] = GetTime();
											if ((1012 <= 4444) and v24(v23(100))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\247\74\163\181\21\138\236\67\137\178\24\180\247\77\246\181\25\138\240\64\176\246\18\179\229\8\162\183\15\178\230\81\246\231\69", "\213\131\37\214\214\125");
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
				v163 = 3;
			end
			if ((2115 < 2168) and (4 == v163)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\215\44\95\234\219\253\42\66\235", "\185\145\69\45\143")]:IsCastable() and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\163\17\15\169\215\143\39\12\163\210\190\23\28\145\212\131\11\28\146\213\141\26\11", "\188\234\127\121\198")]:CooldownRemains() > 30) or v71 or (v68 < 10))) or (3939 <= 1042)) then
					if (v22(v60.Fireblood, nil) or (577 == 503)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\59\1\134\58\62\28\140\60\114\16\135\7\33\22\133\120\96\69", "\227\88\82\115");
					end
				end
				if ((4655 > 2682) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\97\26\168\180\7\97\72\22\180\160", "\19\35\127\218\199\98")]:IsCastable() and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\53\245\28\237\23\254\50\247\25\245\62\234\25\204\2\235\8\254\62\235\27\254\24", "\130\124\155\106")]:CooldownRemains() > 30) or v71 or (v68 < 15))) then
					if ((4020 >= 1952) and v22(v60.Berserking, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\206\228\188\166\228\119\182\219\204\182\172\167\201\111\186\211\139\164\247", "\223\181\171\150\207\195\150\28");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\110\59\228\161\15\120\40\234\173\2\95", "\105\44\90\131\206")]:IsCastable() and (v13:BuffDown(v60.StormEarthAndFireBuff))) or (3124 <= 616)) then
					if ((2769 > 2106) and v22(v60.BagofTricks, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\225\181\134\7\56\192\244\160\176\11\53\236\160\177\189\55\45\250\230\242\234\88", "\94\159\128\210\217\104");
					end
				end
				v163 = 5;
			end
			if ((2580 >= 2495) and (v163 == 1)) then
				if ((1084 <= 2661) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\25\60\174\81\123\15\41\179\87\126\11\38\165\101\127\56\45", "\22\74\72\193\35")]:IsCastable() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\14\118\234\93\40\108\247\76\14\107\225\79", "\56\76\25\132")]:IsAvailable() and (((v68 < 30) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\124\206\165\35\203\75\210\191\4\221\91\214", "\175\62\161\203\70")]:CooldownRemains() < 4) and (v13:Chi() >= 4)) or v13:BuffUp(v60.BonedustBrewBuff) or (not v92() and (v66 >= 3) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\30\210\205\22\49\41\206\215\49\39\57\202", "\85\92\189\163\115")]:CooldownRemains() <= 2) and (v13:Chi() >= 2))) and (v69 or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\0\162\38\55\34\169\8\45\44\162\4\48\44\155\56\49\61\169\4\49\46\169\34", "\88\73\204\80")]:CooldownRemains() > v60[LUAOBFUSACTOR_DECRYPT_STR_0("\29\151\31\84\36\255\47\145\4\78\8\212\42\165\25\84\44", "\186\78\227\112\38\73")]:FullRechargeTime()))) then
					if ((2091 > 816) and v22(v60.StormEarthAndFire, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\239\67\242\71\94\69\249\86\239\65\91\69\253\89\249\106\85\115\238\82\189\86\87\69\239\82\251\21\11", "\26\156\55\157\53\51");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\191\204\25\203\181\117\141\202\2\209\153\94\136\254\31\203\189", "\48\236\184\118\185\216")]:IsCastable() and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\199\178\89\53\203\33\246\169\117\34\202\35", "\84\133\221\55\80\175")]:IsAvailable() and (v69 or ((v14:TimeToDie() > 15) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\142\243\43\180\202\121\188\245\48\174\230\82\185\193\45\180\194", "\60\221\135\68\198\167")]:FullRechargeTime() < v60[LUAOBFUSACTOR_DECRYPT_STR_0("\199\179\238\140\73\220\214\168\253\141\118\209\235\138\240\138\86\220\218\180\255\134\80", "\185\142\221\152\227\34")]:CooldownRemains())))) or (2461 >= 2570)) then
					if ((1170 <= 2524) and v22(v60.StormEarthAndFire, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\209\88\232\78\12\242\89\215\67\242\124\50\249\92\250\81\243\81\54\183\91\193\104\233\70\53\183\1", "\151\56\165\55\154\35\83");
					end
				end
				if ((4064 > 2351) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\130\76\11\235\164\86\22\250\130\81\0\249", "\142\192\35\101")]:IsCastable() and ((v13:BuffDown(v60.BonedustBrewBuff) and v13:BuffUp(v60.StormEarthAndFireBuff) and (v13:BuffRemains(v60.StormEarthAndFireBuff) < 11) and v92()) or (v13:BuffDown(v60.BonedustBrewBuff) and (v68 < 30) and (v68 > 10) and v92() and (v13:Chi() >= 4)) or (v68 < 10) or (v14:DebuffDown(v60.SkyreachExhaustionDebuff) and (v66 >= 4) and (v91() >= 2)) or (v69 and v92() and (v66 >= 4)))) then
					if ((v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\230\121\40\186\226\158", "\118\182\21\73\195\135\236\204")) or (4445 <= 1697)) then
						if ((4632 > 2290) and v24(v62.BonedustBrewPlayer, not v14:IsInRange(8))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\10\51\20\69\0\24\238\28\3\24\82\1\26\189\11\56\37\83\1\11\189\89\108", "\157\104\92\122\32\100\109");
						end
					elseif ((v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\128\169\193\204\52\53\128\170\183\175\192\196", "\203\195\198\175\170\93\71\237")) or (698 == 3358)) then
						if ((4439 == 4439) and v24(v60.BonedustBrew, not v14:IsInRange(40))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\44\68\48\208\85\4\239\58\116\60\199\84\6\188\45\79\1\198\84\23\188\127\27", "\156\78\43\94\181\49\113");
						end
					elseif ((v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\81\253\214\176\4\81", "\25\18\136\164\195\107\35")) or (1728 == 4102)) then
						if (v24(v62.BonedustBrewCursor, not v14:IsInRange(40)) or (4599 < 3018)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\234\34\167\74\118\169\210\172\215\47\187\74\101\252\194\188\215\62\172\73\50\237\145", "\216\136\77\201\47\18\220\161");
						end
					elseif ((v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\8\226\46\215\17\156\151\35\232\46\200\72\255\151\63\255\36\200", "\226\77\140\75\186\104\188")) or (4782 < 562)) then
						if ((3192 < 4740) and v16 and v16:Exists() and v13:CanAttack(v16)) then
							if ((1634 < 3125) and v24(v62.BonedustBrewCursor, not v14:IsInRange(40))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\187\193\222\58\75\172\221\196\0\77\171\203\199\127\76\189\241\195\58\73\249\159\128", "\47\217\174\176\95");
							end
						end
					end
				end
				v163 = 2;
			end
		end
	end
	local function v111()
		local v164 = 0;
		while true do
			if ((2566 < 4504) and (1 == v164)) then
				if ((4551 == 4551) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\154\216\219\206\194\164\125\166\211\195\245\193\164\114\187\223\217\196\253\168\66\182\196", "\37\211\182\173\161\169\193")]:IsCastable() and (((v14:TimeToDie() > 25) and (v68 > 120)) or ((v68 < 60) and ((v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < 2) or (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > 55)) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\196\63\95\220\38\114\173\238", "\217\151\90\45\185\72\27")]:CooldownUp() and (v66 < 3)) or v13:BloodlustUp() or (v68 < 23))) then
					if ((2987 > 2475) and v22(v60.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\202\114\241\29\93\198\67\255\7\83\205\67\243\26\83\252\107\239\27\66\198\67\243\27\81\198\110\167\17\82\252\111\226\0\83\205\117\243\11\22\149", "\54\163\28\135\114");
					end
				end
				if ((3885 == 3885) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\10\212\83\135\74\106\59\207\127\144\75\104", "\31\72\187\61\226\46")]:IsCastable() and (v13:BuffUp(v60.InvokersDelightBuff) or (v13:BuffDown(v60.BonedustBrewBuff) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\240\3\81\215\73\119\48\218", "\68\163\102\35\178\39\30")]:CooldownUp() or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\141\117\200\194\13\188\151\8", "\113\222\16\186\167\99\213\227")]:CooldownRemains() > 15) or ((v68 < 30) and (v68 > 10)))) or (v68 < 10))) then
					if ((v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\30\2\250\239\43\28", "\150\78\110\155")) or (1761 <= 283)) then
						if (v24(v62.BonedustBrewPlayer, not v14:IsInRange(8)) or (319 >= 4250)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\135\202\41\228\160\11\172\84\186\199\53\228\179\94\188\68\186\214\34\243\161\16\182\84\156\133\127", "\32\229\165\71\129\196\126\223");
						end
					elseif ((2805 > 1412) and (v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\224\134\202\135\136\199\206\136\208\136\142\219", "\181\163\233\164\225\225"))) then
						if (v24(v60.BonedustBrew, not v14:IsInRange(40)) or (3651 < 1400)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\82\132\48\114\84\158\45\99\111\137\44\114\71\203\61\115\111\152\59\101\85\133\55\99\73\203\102", "\23\48\235\94");
						end
					elseif ((v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\95\207\202\78\88\33", "\178\28\186\184\61\55\83")) or (2704 >= 4129)) then
						if ((1121 < 2110) and v24(v62.BonedustBrewCursor, not v14:IsInRange(40))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\198\194\73\57\246\27\230\208\242\69\46\247\25\181\199\201\120\47\247\28\240\202\196\83\37\178\86", "\149\164\173\39\92\146\110");
						end
					elseif ((v58 == LUAOBFUSACTOR_DECRYPT_STR_0("\214\41\21\18\3\91\230\41\20\26\8\91\208\50\2\12\21\9", "\123\147\71\112\127\122")) or (628 > 1084)) then
						if ((v16 and v16:Exists() and v13:CanAttack(v16)) or (2897 > 3915)) then
							if (v24(v62.BonedustBrewCursor, not v14:IsInRange(40)) or (754 > 4394)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\206\194\140\116\66\217\222\150\78\68\222\200\149\49\69\200\242\145\116\84\201\195\139\101\95\140\149", "\38\172\173\226\17");
							end
						end
					end
				end
				v164 = 2;
			end
			if ((3570 >= 606) and (v164 == 4)) then
				if (v13:BuffUp(v60.SerenityBuff) or (v68 < 20) or (3545 <= 3261)) then
					local v218 = 0;
					while true do
						if ((v218 == 1) or (2960 <= 2444)) then
							if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\218\0\77\126\234\240\6\80\127", "\136\156\105\63\27")]:IsCastable() or (949 < 36)) then
								if (v22(v60.Fireblood, nil) or (1812 <= 1353)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\29\133\107\49\25\128\118\59\31\204\122\48\36\159\124\38\30\130\112\32\2\204\43\96", "\84\123\236\25");
								end
							end
							if ((4801 >= 1233) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\210\142\184\4\169\167\251\130\164\16", "\213\144\235\202\119\204")]:IsCastable()) then
								if (v22(v60.Berserking, nil) or (327 == 2806)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\33\29\204\57\45\49\70\42\22\217\106\43\39\114\48\29\204\47\38\42\89\58\88\140\124", "\45\67\120\190\74\72\67");
								end
							end
							v218 = 2;
						end
						if ((2 == v218) or (4638 < 2367)) then
							if ((956 == 956) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\2\35\234\170\255\188\252\224\35\41\254", "\137\64\66\141\197\153\232\142")]:IsCastable()) then
								if (v22(v60.BagofTricks, nil) or (4092 <= 969)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\1\209\37\153\135\5\239\54\180\129\0\219\49\230\139\7\239\49\163\154\6\222\43\178\145\67\130\122", "\232\99\176\66\198");
								end
							end
							break;
						end
						if ((4160 > 1467) and (v218 == 0)) then
							if ((3218 > 1704) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\29\241\224\193\207\183\42\61\243\192\197\208\175", "\88\92\159\131\164\188\195")]:IsCastable()) then
								if (v22(v60.AncestralCall, nil) or (4250 <= 3003)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\129\32\188\78\196\255\207\129\34\128\72\214\231\209\192\45\187\116\196\238\207\133\32\182\95\206\171\143\208", "\189\224\78\223\43\183\139");
								end
							end
							if ((294 <= 3198) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\12\240\133\25\197\8\233\152\15", "\161\78\156\234\118")]:IsCastable()) then
								if ((3242 >= 1790) and v22(v60.BloodFury, nil)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\165\187\198\211\163\136\207\201\181\174\137\223\163\136\218\217\181\178\199\213\179\174\137\142\245", "\188\199\215\169");
								end
							end
							v218 = 1;
						end
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\192\40\47\14\111\158\211\57\232\38\37\3\117\153", "\76\140\65\72\102\27\237\153")]:IsCastable() or (1249 > 3739)) then
					if (v22(v60.LightsJudgment, nil) or (3354 <= 526)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\211\17\218\195\18\129\64\207\18\213\218\4\176\94\154\21\214\232\18\187\88\223\24\219\195\24\254\25\138", "\222\42\186\118\178\183\97");
					end
				end
				break;
			end
			if ((4864 == 4864) and (v164 == 0)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\43\86\238\199\9\88\124\16\74\247\207\50\95\76\29\81\208\222\7\66\94\29", "\43\120\35\131\170\102\54")]:IsCastable() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\125\8\145\185\174\181\188\65\3\137\130\173\181\179\92\15\147\179\145\185\131\81\20", "\228\52\102\231\214\197\208")]:CooldownUp() or (v66 > 4) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\55\238\99\197\225\142\33\195\27\238\65\194\239\188\17\223\10\229\65\195\237\142\11", "\182\126\128\21\170\138\235\121")]:CooldownRemains() > 50) or (v68 <= 30))) or (3478 >= 4703)) then
					if ((v59 == LUAOBFUSACTOR_DECRYPT_STR_0("\187\214\52\255\131\1", "\102\235\186\85\134\230\115\80")) or (203 >= 3146)) then
						if ((4035 == 4035) and v24(v62.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(5))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\68\25\51\82\125\218\29\64\4\55\75\119\235\54\94\11\59\77\77\199\54\86\24\43\90\50\215\38\104\31\59\77\119\218\43\67\21\126\13", "\66\55\108\94\63\18\180");
						end
					elseif ((1166 >= 558) and (v59 == LUAOBFUSACTOR_DECRYPT_STR_0("\55\152\151\36\40\75", "\57\116\237\229\87\71"))) then
						if ((965 == 965) and v24(v62.SummonWhiteTigerStatueCursor)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\185\164\224\234\120\224\120\189\185\228\243\114\209\83\163\182\232\245\72\253\83\171\165\248\226\55\237\67\149\162\232\245\114\224\78\190\168\173\181", "\39\202\209\141\135\23\142");
						end
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\214\61\31\5\57\253\199\38\12\4\6\240\250\4\1\3\38\253\203\58\14\15\32", "\152\159\83\105\106\82")]:IsCastable() and ((not v71 and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\163\201\95\247\205\73\146\210\115\224\204\75", "\60\225\166\49\146\169")]:IsAvailable() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\13\17\33\47\5\18\60\10\13\56\4\16", "\103\79\126\79\74\97")]:CooldownRemains() <= 5) and (v14:TimeToDie() > 25)) or v13:BloodlustUp() or (v68 < 25))) or (1813 > 1941)) then
					if ((4740 == 4740) and v22(v60.InvokeXuenTheWhiteTiger, nil, nil, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\179\113\197\124\85\31\133\103\198\118\80\37\174\119\214\76\73\18\179\107\214\76\74\19\189\122\193\51\93\30\133\108\214\97\91\20\179\107\202\51\10", "\122\218\31\179\19\62");
					end
				end
				v164 = 1;
			end
			if ((345 <= 3537) and (v164 == 2)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\126\20\62\234\67\24\56\246", "\143\45\113\76")]:IsCastable() and ((v73 and (v13:BuffUp(v60.InvokersDelightBuff) or (v71 and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\156\170\21\50\179\177\18\59\144\183\14\50\155\183\10\57\170", "\92\216\216\124")]:IsAvailable() and (v68 > 110)) or (not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\127\32\165\78\246\82\60\171\104\242\73\60\143\79\235\94\32", "\157\59\82\204\32")]:IsAvailable() and (v68 > 105)))))) or not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\17\48\245\245\226\239\235\164\61\48\215\242\236\221\219\184\44\59\215\243\238\239\193", "\209\88\94\131\154\137\138\179")]:IsAvailable() or (v68 < 15))) or (4934 == 3962)) then
					if ((3649 > 701) and v22(v60.Serenity, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\164\214\121\16\42\37\59\104\162\192\67\13\38\35\39\38\168\208\101\94\114\97", "\66\72\193\164\28\126\67\81");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\212\41\186\93\40\127\243\53", "\22\135\76\200\56\70")]:IsCastable() and not v73 and (v13:BuffUp(v60.InvokersDelightBuff) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\164\62\238\43\86\228\181\37\253\42\105\233\136\7\240\45\73\228\185\57\255\33\79", "\129\237\80\152\68\61")]:CooldownRemains() > v68) or ((v68 > (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\120\166\18\252\23\18\96\68\173\10\199\20\18\111\89\161\16\246\40\30\95\84\186", "\56\49\200\100\147\124\119")]:CooldownRemains() + 10)) and (v68 > 90)))) or (1985 >= 2687)) then
					if (v22(v60.Serenity, nil) or (987 >= 4907)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\223\59\173\245\194\55\171\233\140\61\187\207\223\59\173\245\194\55\171\233\140\111\237", "\144\172\94\223");
					end
				end
				v164 = 3;
			end
			if ((v164 == 3) or (4104 < 453)) then
				if ((4167 >= 1973) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\16\0\183\68\44\0\164\99\33\14\182\79", "\39\68\111\194")]:CooldownUp() and v49) then
					local v219 = 0;
					local v220;
					local v221;
					while true do
						if ((2048 >= 1829) and (v219 == 1)) then
							if ((2342 >= 859) and v30 and v31) then
								v221 = v93();
							elseif ((2821 > 2453) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\226\169\242\196\113\184\208\130\226\198\109\191", "\215\182\198\135\167\25")]:IsReady()) then
								v221 = v14;
							end
							if ((4218 > 3810) and v221) then
								if ((v220 and v13:BuffDown(v60.SerenityBuff) and v89(v60.TouchofDeath) and (v221:Health() < v13:Health())) or (v13:BuffRemains(v60.HiddenMastersForbiddenTouchBuff) < 2) or (v13:BuffRemains(v60.HiddenMastersForbiddenTouchBuff) > v221:TimeToDie()) or (2163 > 4184)) then
									if ((v221:GUID() == v14:GUID()) or (786 >= 821)) then
										if (v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(5)) or (776 > 3893)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\153\70\255\75\133\118\229\78\178\77\239\73\153\65\170\75\137\118\249\77\139\9\231\73\132\71\167\92\140\91\237\77\153\9\187\26", "\40\237\41\138");
										end
									elseif ((((GetTime() - v84[LUAOBFUSACTOR_DECRYPT_STR_0("\235\117\233\236\126\198\102\253\253\94\244\99\251\232", "\42\167\20\154\152")]) * 1000) >= v34) or (1920 > 3487)) then
										local v274 = 0;
										while true do
											if ((840 < 4049) and (v274 == 0)) then
												v84[LUAOBFUSACTOR_DECRYPT_STR_0("\102\255\177\86\69\32\88\249\167\86\66\54\75\238", "\65\42\158\194\34\17")] = GetTime();
												if (v24(v23(100)) or (688 > 2840)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\14\40\71\15\37\210\20\232\37\35\87\13\57\229\91\237\30\24\65\9\43\173\20\232\28\106\70\13\63\234\30\250\90\118\0", "\142\122\71\50\108\77\141\123");
												end
												break;
											end
										end
									end
								end
							end
							v219 = 2;
						end
						if ((v219 == 0) or (1643 > 1773)) then
							v220 = v13:IsInParty() and not v13:IsInRaid();
							v221 = nil;
							v219 = 1;
						end
						if ((2 == v219) or (2774 < 2244)) then
							if ((710 == 710) and v221 and v89(v60.TouchofDeath)) then
								if ((3137 <= 3516) and v220) then
									if ((4639 >= 4543) and ((v221:TimeToDie() > 60) or v221:DebuffUp(v60.BonedustBrewDebuff) or (v68 < 10)) and v13:BuffDown(v60.SerenityBuff)) then
										if ((1512 < 3311) and (v221:GUID() == v14:GUID())) then
											if (v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(5)) or (2268 <= 1742)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\1\173\234\27\51\42\173\249\39\63\16\163\235\16\123\22\166\192\11\62\19\226\242\25\50\27\239\235\25\41\18\167\235\88\106\65", "\91\117\194\159\120");
											end
										elseif ((((GetTime() - v84[LUAOBFUSACTOR_DECRYPT_STR_0("\54\28\45\12\1\240\54\29\24\42\43\34\240\52", "\68\122\125\94\120\85\145")]) * 1000) >= v34) or (2899 > 4676)) then
											local v277 = 0;
											while true do
												if ((0 == v277) or (4258 <= 2507)) then
													v84[LUAOBFUSACTOR_DECRYPT_STR_0("\59\29\220\74\252\216\168\16\25\219\109\223\216\170", "\218\119\124\175\62\168\185")] = GetTime();
													if (v24(v23(100)) or (3506 == 1216)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\177\255\93\199\173\207\71\194\154\244\77\197\177\248\8\199\161\207\91\193\163\176\71\194\163\189\92\197\183\247\77\208\229\161\28", "\164\197\144\40");
													end
													break;
												end
											end
										end
									end
								elseif (v13:BuffDown(v60.SerenityBuff) or (3763 < 682)) then
									if ((v221:GUID() == v14:GUID()) or (4535 <= 850)) then
										if ((2103 >= 1896) and v22(v60.TouchofDeath, nil, nil, not v14:IsInMeleeRange(5))) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\151\255\191\136\213\137\140\246\149\143\216\183\151\248\234\136\217\137\144\245\172\203\208\183\138\254\231\159\220\164\132\245\190\203\140\224", "\214\227\144\202\235\189");
										end
									elseif ((((GetTime() - v84[LUAOBFUSACTOR_DECRYPT_STR_0("\193\164\148\111\36\178\65\59\232\177\180\108\17\163", "\92\141\197\231\27\112\211\51")]) * 1000) >= v34) or (2767 < 2407)) then
										local v278 = 0;
										while true do
											if ((282 < 386) and (0 == v278)) then
												v84[LUAOBFUSACTOR_DECRYPT_STR_0("\202\254\153\183\229\231\237\141\166\197\213\232\139\179", "\177\134\159\234\195")] = GetTime();
												if (v24(v23(100)) or (1651 >= 3921)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\169\228\42\163\193\130\228\57\159\205\184\234\43\168\137\190\239\0\179\204\187\171\48\166\207\240\255\62\178\206\184\255\127\241\159", "\169\221\139\95\192");
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
				if ((1976 == 1976) and v48 and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\234\132\106\60\42\41\216\160\126\45\47\39", "\70\190\235\31\95\66")]:IsCastable() and ((v68 > 90) or (v68 < 10))) then
					if ((4080 >= 780) and v22(v60.TouchofKarma, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\174\237\15\229\237\133\237\28\217\238\187\240\23\231\165\185\230\37\245\224\168\231\20\239\241\163\162\75\190", "\133\218\130\122\134");
					end
				end
				v164 = 4;
			end
		end
	end
	local function v112()
		local v165 = 0;
		while true do
			if ((v165 == 5) or (1594 <= 492)) then
				if ((2549 > 1932) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\239\66\166\168\201\123\160\161\214", "\205\187\43\193")]:IsReady() and v89(v60.TigerPalm) and (v66 == 5)) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\243\123\11", "\191\158\18\101"), v97, nil, not v14:IsInMeleeRange(5)) or (1357 == 4978)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\202\128\178\189\250\211\134\187\162\133\208\130\165\170\203\202\147\174\144\196\204\130\187\186\214\215\199\227\253", "\207\165\163\231\215");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\244\236\234\94\45\126\193\211\248\82\33\71\207\247\253", "\16\166\153\153\54\68")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or (465 < 295)) then
					if ((4572 >= 3652) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\166\211\78\61\47\254\237\185\193\66\49\30\238\219\189\196\6\39\36\235\215\189\201\82\45\30\248\221\182\204\83\39\53\185\134\231", "\153\178\211\160\38\84\65");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\160\7\91\40\137\4\79\63\169\2\89\32", "\75\226\107\58")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\107\214\16\126\30\213\207\87\198\24\116\22\246\223\93\223\21\105", "\173\56\190\113\26\113\162")]:IsAvailable() and (v66 >= 3) and v89(v60.BlackoutKick)) or (4690 <= 3679)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\198\215\35", "\151\171\190\77\101"), v98, nil, not v14:IsInMeleeRange(5)) or (566 > 3535)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\199\35\249\170\243\114\30\209\16\243\160\251\118\75\214\42\234\172\246\116\31\220\16\249\166\253\113\30\214\59\184\253\174", "\107\165\79\152\201\152\29");
					end
				end
				if ((4146 > 2099) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\100\90\250\194\95\122\88\72\252\195\81\72\94\64\236\199\91\109\83", "\31\55\46\136\171\52")]:IsReady()) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\220\41\196", "\148\177\72\188"), v101, nil, not v14:IsInMeleeRange(9)) or (858 >= 4349)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\181\162\69\218\173\179\104\220\160\137\67\219\163\137\64\218\168\178\91\220\180\178\23\192\163\164\82\221\175\162\78\236\167\185\82\223\179\165\67\147\242\238", "\179\198\214\55");
					end
				end
				v165 = 6;
			end
			if ((1937 >= 530) and (2 == v165)) then
				if ((2598 > 1204) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\169\34\180\35\48\13\250\159\5\188\35\48", "\143\235\78\213\64\91\98")]:IsReady() and v13:HasTier(31, 2) and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\128\65\138", "\214\237\40\228\137\16"), v98, nil, not v14:IsInMeleeRange(5)) or (3527 <= 1614)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\239\238\218\8\169\144\247\208\210\10\165\142\163\252\220\17\163\139\234\251\192\60\167\138\230\227\204\16\178\197\178\183", "\198\229\131\143\185\99");
					end
				end
				if ((682 <= 1147) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\98\156\161\125\95\133\166\116\114\158\169\125\84\167\161\112\90", "\19\49\236\200")]:IsReady() and v13:HasTier(31, 2) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if ((1298 < 2821) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\39\255\185\234\179\240\48\201\180\246\187\240\50\201\188\237\185\245\119\229\178\246\191\240\62\226\174\219\187\241\50\250\162\247\174\190\101\166", "\218\158\87\150\215\132");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\217\18\216\225\61\45\216\239\53\208\225\61", "\173\155\126\185\130\86\66")]:IsReady() and (v66 < 6) and v89(v60.BlackoutKick) and v13:HasTier(31, 2)) or (3098 < 1322)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\232\175\180", "\140\133\198\218\167\232"), v98, nil, not v14:IsInMeleeRange(5)) or (3309 <= 2696)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\34\181\126\143\186\59\160\66\143\188\45\191\61\151\176\60\177\115\141\161\55\139\124\139\176\34\161\110\144\245\124\230", "\228\213\78\212\29");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\181\69\165\12\229\128\127\163\11\192\142\79\189", "\139\231\44\214\101")]:IsReady() and (v13:HasTier(30, 2))) or (2331 < 1550)) then
					if ((3976 >= 3448) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\212\230\8", "\118\185\143\102\62\112\209\81"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\121\58\239\171\18\35\43\73\126\22\237\172\22\23\120\79\117\59\227\171\28\8\33\99\113\38\227\169\0\15\44\28\34\125", "\88\60\16\73\134\197\117\124");
					end
				end
				v165 = 3;
			end
			if ((v165 == 7) or (822 > 1767)) then
				if ((1887 >= 1801) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\185\117\234\46\159\76\236\39\128", "\75\237\28\141")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\232\90\205\178\39\18\233\230\207\80\202\165\39\30\202\238\210\94\223\165\42\9\254", "\129\188\63\172\209\79\123\135")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) then
					if (v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5)) or (41 >= 2333)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\237\225\200\82\219\246\204\76\233\166\222\69\246\227\195\73\240\255\242\65\235\227\193\85\247\242\141\21\188", "\173\32\132\134");
					end
				end
				break;
			end
			if ((v165 == 0) or (4475 <= 4376)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\123\237\65\134\84\226\65\185\73\227\73\154", "\234\61\140\36")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 1)) or (1058 >= 3606)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (476 >= 3389)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\220\191\126\6\47\216\133\97\27\46\208\170\50\28\36\207\191\124\6\53\196\133\115\0\36\209\175\97\27\97\143", "\111\65\189\218\18");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\112\95\9\60\0\89\160\69\95\19\48\60\85\161\71\71\20\39\15", "\207\35\43\123\85\107\60")]:IsReady() and v13:HasTier(31, 4) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\68\162\181\228\125\117\184\166\227\106\100", "\25\16\202\192\138")]:IsAvailable()) or (3877 < 129)) then
					if ((4296 >= 1581) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\238\223\191\235\162\241\194\196\171\221\189\252\248\244\186\235\167\240\241\196\191\230\233\231\248\217\168\236\160\224\228\244\172\237\172\248\232\216\185\162\253", "\148\157\171\205\130\201");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\5\221\103\61\194\249\37\242\97\59\200", "\150\67\180\20\73\177")]:IsReady() and v13:BuffUp(v60.InvokersDelightBuff) and not v13:HasTier(30, 2)) or (2988 < 2450)) then
					if (v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\128\25\2", "\45\237\120\122"), v101, nil, not v14:IsInMeleeRange(8)) or (2288 >= 4740)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\225\177\56\196\215\173\42\232\238\183\62\206\168\177\41\197\237\172\37\195\241\157\45\216\237\174\57\196\252\226\122", "\76\183\136\194");
					end
				end
				if (v13:IsCasting(v60.FistsofFury) or (90 >= 2339)) then
					if (v24(v62.StopFoF) or (4251 == 3440)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\124\239\246\44\67\112\27\124\217\227\45\66\86\43\121\231\235\59\85\67\84\105\227\247\61\94\70\0\99\217\228\55\85\67\1\105\242\165\96", "\116\26\134\133\88\48\47");
					end
				end
				v165 = 1;
			end
			if ((v165 == 3) or (4728 <= 1268)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\99\254\234\193\74\85\229\254\220\73\85\221\241\198\69\92\229\234\204", "\33\48\138\152\168")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\70\30\37\95\197\50\96\16\57\66\213", "\87\18\118\80\49\161")]:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff) and (v66 < 10)) or (4951 < 2174)) then
					if ((1986 <= 2651) and v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\65\31\194", "\208\44\126\186\192"), v101, v103, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\14\182\207\31\249\246\65\241\37\176\206\17\195\222\71\249\30\168\201\6\248\137\93\242\8\161\200\29\232\208\113\246\21\161\202\1\239\221\14\165\76", "\46\151\122\196\166\116\156\169");
					end
				end
				if ((486 < 4456) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\195\236\67\22\242\235\232\117\14\244\232\253", "\155\133\141\38\122")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 2)) then
					if ((2242 < 3924) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\43\169\77\70\113\160\26\57\184\78\66\111\229\54\47\190\68\65\118\177\60\21\173\78\74\115\176\54\62\236\19\23", "\197\69\74\204\33\47\31");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\195\91\72\142\251\74\85\129\228\71\95\176\249\65\94\139\255\93\94", "\231\144\47\58")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\134\208\207\123\28\56\221\63\187\203\206", "\89\210\184\186\21\120\93\175")]:IsAvailable())) or (4701 <= 3665)) then
					if ((4956 > 856) and v84.CastTargetIf(v60.StrikeoftheWindlord, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\188\82\100", "\90\209\51\28\181\25"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\195\111\69\231\180\213\68\88\232\128\196\115\82\209\168\217\117\83\226\176\194\127\23\253\186\194\126\89\231\171\201\68\86\225\186\220\110\68\250\255\131\43", "\223\176\27\55\142");
					end
				end
				if ((4337 > 3037) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\2\178\221\161\55\180\200\147\49\169\215", "\213\68\219\174")]:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) then
					if ((115 < 2690) and v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\6\225\59", "\31\107\128\67\135\74\165\95"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\225\239\89\82\142\215\238\195\75\84\163\193\168\239\72\83\180\214\225\232\84\126\176\215\237\240\88\82\165\152\187\174", "\209\184\136\156\45\33");
					end
				end
				v165 = 4;
			end
			if ((v165 == 4) or (1594 >= 4333)) then
				if (v13:IsCasting(v60.FistsofFury) or (1177 > 3344)) then
					if ((4481 == 4481) and v24(v62.StopFoF)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\193\102\28\171\56\199\115\55\190\18\218\108\55\187\6\198\118\13\180\71\219\112\26\189\9\193\97\17\135\6\199\112\4\173\20\220\53\91\236", "\216\103\168\21\104");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\75\189\74\170\118\164\77\163\91\191\66\170\125\134\74\167\115", "\196\24\205\35")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) or (1779 < 865)) then
					if ((270 <= 2991) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\155\234\8\32\130\237\1\17\136\241\7\32\142\220\13\39\136\232\70\61\142\241\3\32\130\247\31\17\138\236\3\34\158\240\18\110\216\181", "\102\78\235\131");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\216\34\53\71\76\54\162\32\209\39\55\79", "\84\154\78\84\36\39\89\215")]:IsReady() and (v66 < 6) and v89(v60.BlackoutKick) and v13:HasTier(30, 2)) or (1698 < 412)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\240\232\88", "\101\157\129\54\56"), v98, nil, not v14:IsInMeleeRange(5)) or (162 > 4048)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\165\139\168\40\118\8\189\181\160\42\122\22\233\153\174\49\124\19\160\158\178\28\120\18\172\134\190\48\109\93\250\210", "\25\125\201\234\203\67");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\74\228\17\13\26\46\29\126\215\10\2\26\34\56\112\247\19", "\115\25\148\120\99\116\71")]:IsReady() and v89(v60.SpinningCraneKick) and v92()) or (2448 <= 1527)) then
					if ((1985 <= 3718) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\45\176\42\79\5\51\190\27\66\30\60\183\33\126\7\52\186\47\1\31\56\171\33\79\5\41\160\27\64\3\56\181\49\82\24\125\237\116", "\33\108\93\217\68");
					end
				end
				v165 = 5;
			end
			if ((v165 == 1) or (3254 < 2695)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\60\205\161\231\182\125\11\213\139\237\190\121", "\18\126\161\192\132\221")]:IsReady() and v89(v60.BlackoutKick) and not v92() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\108\32\175\0\89\72\42\161\28\95\81\47\154\22\83\94\44\189", "\54\63\72\206\100")]:IsAvailable()) or (1806 >= 3823)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\197\80\75", "\27\168\57\37\26\133"), v98, nil, not v14:IsInMeleeRange(5)) or (2160 > 3964)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\166\125\171\220\34\191\104\151\220\36\169\119\232\196\40\184\121\166\222\57\179\67\169\216\40\166\105\187\195\109\251\44", "\183\77\202\28\200");
					end
				end
				if ((3781 >= 3416) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\53\63\136\11\28\60\156\28\60\58\138\3", "\104\119\83\233")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < 1)) then
					if ((2700 >= 2436) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\248\241\41", "\35\149\152\71\66"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\27\228\67\179\49\22\253\86\143\49\16\235\73\240\41\28\250\71\190\51\13\241\125\177\53\28\228\87\163\46\89\185\16", "\90\121\136\34\208");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\244\30\92\16\201\7\91\25\228\28\84\16\194\37\92\29\204", "\126\167\110\53")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or (2875 > 4175)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (1430 > 2134)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\0\39\246\210\54\51\23\17\251\206\62\51\21\17\243\213\60\54\80\61\253\206\58\51\25\58\225\227\62\50\21\34\237\207\43\125\65\122", "\95\93\112\78\152\188");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\242\229\140\27\234\183\220\198\214\151\20\234\187\249\200\246\142", "\178\161\149\229\117\132\222")]:IsReady() and v13:HasTier(31, 2) and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1, v60.BlackoutKick) and v13:BuffUp(v60.DanceofChijiBuff)) or (2552 > 3817)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (3983 == 4367)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\155\203\212\162\175\31\168\36\183\216\207\173\175\19\153\40\129\216\214\236\178\19\180\38\134\210\201\181\158\23\169\38\132\206\206\184\225\71\240", "\67\232\187\189\204\193\118\198");
					end
				end
				v165 = 2;
			end
			if ((4072 > 339) and (6 == v165)) then
				if ((2861 == 2861) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\195\28\123\120\75\218\254\11\81\100\68\221\245\39\123\117\78", "\179\144\108\18\22\37")]:IsReady() and (v89(v60.SpinningCraneKick))) then
					if ((4891 > 2414) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\213\179\18\135\193\207\173\28\182\204\212\162\21\140\240\205\170\24\130\143\213\166\9\140\193\207\183\2\182\206\201\166\23\156\220\210\227\78\217", "\175\166\195\123\233");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\216\202\84\91\252\230\204\90\109\226\238\197\82\71\192\250\204\94\65", "\144\143\162\61\41")]:IsReady() or (1206 <= 627)) then
					if ((1629 == 1629) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\247\219\20\66\126\142\61\231\236\25\66\115\128\60\238\236\13\69\124\132\59\160\192\24\66\119\137\58\244\202\34\81\125\130\63\245\192\9\16\39\213", "\83\128\179\125\48\18\231");
					end
				end
				if ((1804 <= 1830) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\111\162\224\213\78\16\90\157\242\217\66\41\84\185\247", "\126\61\215\147\189\39")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8)) or (1499 == 4625)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\106\234\14\77\113\241\26\122\114\254\25\64\71\232\20\75\124\191\14\64\106\250\19\76\108\230\34\68\119\250\17\80\107\235\93\16\44", "\37\24\159\125");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\248\170\116\65\209\169\96\86\241\175\118\73", "\34\186\198\21")]:IsReady() and (v89(v60.BlackoutKick))) or (4388 < 833)) then
					if ((1230 < 2468) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\245\9\221", "\162\152\104\165\61"), v101, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\207\35\179\126\123\234\216\59\141\118\121\230\198\111\161\120\98\224\195\38\166\100\79\228\194\42\190\104\99\241\141\122\228", "\133\173\79\210\29\16");
					end
				end
				v165 = 7;
			end
		end
	end
	local function v113()
		local v166 = 0;
		while true do
			if ((3332 == 3332) and (1 == v166)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\57\165\165\215\77\171\183\34\48\160\167\223", "\86\123\201\196\180\38\196\194")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < 1)) or (3223 > 4574)) then
					if ((787 == 787) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\250\225\215", "\207\151\136\185"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\143\41\129\127\119\100\188\188\35\139\119\115\49\187\134\58\135\122\113\101\177\188\36\151\103\108\49\254", "\17\200\227\72\226\20\24");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\131\85\9\222\194\244\224\249\164\73\30\224\192\255\235\243\191\83\31", "\159\208\33\123\183\169\145\143")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\198\82\45\56\246\95\42\48\251\73\44", "\86\146\58\88")]:IsAvailable())) or (3035 < 1416)) then
					if ((1581 <= 3596) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\85\222\242", "\154\56\191\138\160\206\137\86"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\149\77\231\142\119\63\190\195\128\102\225\143\121\5\150\197\136\93\249\136\110\62\193\223\131\75\240\137\117\46\152\243\138\76\230\147\60\107\209", "\172\230\57\149\231\28\90\225");
					end
				end
				if ((1725 < 4991) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\32\166\135\209\35\212\23\190\173\219\43\208", "\187\98\202\230\178\72")]:IsReady() and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1, v60.FistsofFury) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\18\233\165\52\69\54\227\171\40\67\47\230\144\34\79\32\229\183", "\42\65\129\196\80")]:IsAvailable() and v13:HasTier(31, 2) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\38\75\83\217\18\8\4\205\10\67\87\211", "\142\98\42\61\186\119\103\98")]:IsAvailable()) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\53\182\12", "\104\88\223\98"), v98, nil, not v14:IsInMeleeRange(5)) or (661 > 678)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\251\227\205\9\226\81\227\221\197\11\238\79\183\241\203\16\232\74\254\246\215\61\225\81\228\246\142\83\185", "\141\36\151\130\174\98");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\162\115\209\25\151\117\196\43\145\104\219", "\109\228\26\162")]:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) or (1341 >= 1883)) then
					if (v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\83\228\229", "\134\62\133\157\24\128"), v101, nil, not v14:IsInMeleeRange(8)) or (3587 <= 3491)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\172\9\205\60\142\217\1\154\28\204\61\168\150\20\160\8\220\33\184\194\30\154\22\204\60\165\150\86\247", "\182\103\197\122\185\79\209");
					end
				end
				v166 = 2;
			end
			if ((v166 == 0) or (1177 == 1743)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\104\26\13\227\167\63\200\125\15\7\226\190", "\173\46\123\104\143\206\81")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 1)) or (443 >= 2145)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (2799 < 1999)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\28\39\134\76\141\4\139\14\54\133\72\147\65\167\24\48\143\75\138\21\173\34\46\159\86\151\65\230", "\97\212\125\66\234\37\227");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\185\243\191\59\16\131\237\177\22\12\139\237\179\30\23\137\232", "\126\234\131\214\85")]:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < 1.5) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:HasTier(31, 2)) or (3914 <= 3411)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (2828 <= 2303)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\197\64\84\65\141\219\78\101\76\150\212\71\95\112\143\220\74\81\15\151\208\91\95\65\141\193\80\101\67\145\198\93\26\27", "\47\228\181\41\58");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\128\245\202\47\16\63\25\128\233\203\34", "\127\198\156\185\91\99\80")]:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < 1)) or (4838 <= 971)) then
					if (v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\248\27\212", "\190\149\122\172\144\199\107\89"), v101, nil, not v14:IsInMeleeRange(8)) or (522 > 2743)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\12\226\234\237\13\10\247\193\248\39\23\232\190\237\55\23\244\240\247\38\28\206\242\235\33\17\177\170", "\158\82\101\145\158");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\66\247\17\31\74\119\205\23\24\111\121\253\9", "\36\16\158\98\118")]:IsReady() or (246 >= 1352)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\205\23\219", "\133\160\118\163\155\56\136\71"), v101, nil, not v14:IsInMeleeRange(5)) or (3227 <= 1048)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\171\98\251\184\24\138\229\183\127\205\189\22\182\253\226\98\247\164\26\187\255\182\104\205\186\10\166\226\226\41", "\213\150\194\17\146\214\127");
					end
				end
				v166 = 1;
			end
			if ((2 == v166) or (4946 < 1852)) then
				if (v13:IsCasting(v60.FistsofFury) or (308 > 2854)) then
					if ((151 == 151) and v24(v62.StopFoF)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\142\242\99\19\119\252\129\222\113\21\90\234\184\226\118\14\75\246\139\161\100\5\90\246\137\232\99\25\119\255\146\242\99\64\25\167", "\40\147\231\129\23\96");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\87\244\141\70\176\163\201\97\211\133\70\176", "\188\21\152\236\37\219\204")]:IsReady() and (v89(v60.BlackoutKick))) or (540 > 4259)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\77\224\57", "\108\32\137\87"), v98, nil, not v14:IsInMeleeRange(5)) or (2890 <= 2521)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\228\1\165\36\246\94\77\149\227\9\165\36\185\88\92\184\237\14\175\59\224\116\85\191\251\20\230\126\161", "\57\202\136\96\198\79\153\43");
					end
				end
				if ((1780 > 310) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\152\51\163\169\131\174\246\172\0\184\166\131\162\211\162\32\161", "\152\203\67\202\199\237\199")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (2884 < 1507)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\83\169\1\17\124\119\225\197\64\178\14\17\112\70\237\243\64\171\79\12\112\107\227\244\74\180\22\32\121\108\245\238\3\242\95", "\134\154\35\192\111\127\21\25");
					end
				end
				if ((2899 == 2899) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\154\42\8\9\43\221\173\50\34\3\35\217", "\178\216\70\105\106\64")]:IsReady() and (v89(v60.BlackoutKick))) then
					if ((923 < 1792) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\50\42\98", "\224\95\75\26\150\169\181\180"), v101, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\214\217\43\79\163\99\31\229\211\33\71\167\54\24\223\202\45\74\165\98\18\229\212\61\87\184\54\89\136", "\22\107\186\184\72\36\204");
					end
				end
				v166 = 3;
			end
			if ((3579 > 509) and (v166 == 3)) then
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\208\181\45\92\2\238\179\35\106\28\230\186\43\64\62\242\179\39\70", "\110\135\221\68\46")]:IsReady() or (3063 < 390)) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (1771 < 524)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\244\62\5\249\194\186\53\228\9\8\249\207\180\52\237\9\28\254\192\176\51\163\37\9\249\203\189\50\247\47\51\231\219\160\47\163\100\88", "\91\131\86\108\139\174\211");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\207\34\191\18\79\203\42\180\26", "\61\155\75\216\119")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\48\174\179\63\80\0\211\3\184\189\58\76\1\216\41\164\188\61\75\29\216\22\178", "\189\100\203\210\92\56\105")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) or (4369 > 4663)) then
					if ((223 < 4172) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\88\250\45\61\110\237\41\35\92\189\59\42\67\248\38\38\69\228\23\35\68\238\60\111\3\171", "\72\79\49\157");
					end
				end
				break;
			end
		end
	end
	local function v114()
		local v167 = 0;
		while true do
			if ((4644 == 4644) and (v167 == 4)) then
				if ((1667 > 1066) and v13:IsCasting(v60.FistsofFury)) then
					if (v24(v62.StopFoF) or (4500 == 2085)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\242\198\49\230\125\244\211\26\243\87\233\204\26\246\67\245\214\32\249\2\232\208\55\240\76\242\193\60\202\67\244\208\101\166\22", "\149\34\155\181\69");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\48\233\199\243\8\248\218\252\23\245\208\205\10\243\209\246\12\239\209", "\154\99\157\181")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\185\7\249\174\232\136\29\234\169\255\153", "\140\237\111\140\192")]:IsAvailable())) or (4278 < 2082)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\11\24\101", "\120\102\121\29"), v101, nil, not v14:IsInMeleeRange(9)) or (1269 == 485)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\247\171\50\167\230\134\52\170\220\173\51\169\220\174\50\162\231\181\52\190\231\249\40\169\241\188\53\165\247\160\4\173\236\188\123\255\181", "\91\204\131\217");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\253\239\92\218\189\212\240\201\220\71\213\189\216\213\199\252\94", "\158\174\159\53\180\211\189")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) or (4210 < 1946)) then
					if ((1725 == 1725) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\65\237\228\211\121\188\92\250\210\222\101\180\92\248\210\214\126\182\89\189\254\216\101\176\92\244\249\196\72\180\93\248\173\142\47", "\213\50\157\141\189\23");
					end
				end
				if ((1529 < 4456) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\220\42\133\163\121\171\235\50\175\169\113\175", "\196\158\70\228\192\18")]:IsReady() and (v66 < 6) and v89(v60.BlackoutKick) and v13:HasTier(30, 2)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\71\86\31", "\185\42\63\113\46"), v98, nil, not v14:IsInMeleeRange(5)) or (1726 <= 1365)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\209\32\58\16\219\200\53\6\16\221\222\42\121\8\209\207\36\55\18\192\196\30\56\20\209\157\117\105", "\123\180\189\65\89");
					end
				end
				v167 = 5;
			end
			if ((1729 <= 2248) and (v167 == 6)) then
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\74\180\167\78\87\210\23\127\180\189\66\107\222\22\125\172\186\85\88", "\120\25\192\213\39\60\183")]:IsReady() or (1320 < 484)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\21\65\39", "\40\120\32\95"), v101, nil, not v14:IsInMeleeRange(5)) or (1144 > 2086)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\41\191\43\115\164\26\5\164\63\69\187\23\63\148\46\115\161\27\54\164\43\126\239\12\63\185\60\116\166\11\35\148\56\117\170\95\111\251", "\127\90\203\89\26\207");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\238\37\166\197\7\244\211\50\140\217\8\243\216\30\166\200\2", "\157\189\85\207\171\105")]:IsReady() and (v89(v60.SpinningCraneKick))) or (1434 > 1774)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (380 == 4979)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\213\177\209\187\13\207\175\223\138\0\212\160\214\176\60\205\168\219\190\67\213\164\202\176\13\207\181\193\138\2\201\164\152\224\81", "\99\166\193\184\213");
					end
				end
				if ((4341 > 1809) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\225\191\137\169\0\131\216\176\164\169\13\141\217\185\176\174\2\137\222", "\234\182\215\224\219\108")]:IsReady()) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (4275 < 2141)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\137\178\39\204\136\181\50\255\133\169\52\199\142\181\10\208\148\181\54\200\193\168\48\210\132\181\60\212\152\132\52\207\132\251\96\148", "\85\160\225\219");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\126\9\130\202\61\211\94\72\46\138\202\61", "\43\60\101\227\169\86\188")]:IsReady() and (v89(v60.BlackoutKick))) or (479 > 3016)) then
					if ((1732 <= 4708) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\125\201\201", "\87\16\168\177\223\58\172\217"), v101, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\54\193\88\222\48\59\216\77\226\48\61\206\82\157\40\49\223\92\211\50\32\212\102\220\52\49\141\12\139", "\91\84\173\57\189");
					end
				end
				v167 = 7;
			end
			if ((v167 == 7) or (2387 > 2752)) then
				if ((4049 == 4049) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\36\176\11\249\178\230\17\181\1", "\182\112\217\108\156\192")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\158\13\73\236\131\163\6\79\252\132\172\28\64\234\166\165\6\73\252\159\175\26\81", "\235\202\104\40\143")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) then
					if (v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5)) or (3154 >= 3765)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\25\130\28\188\31\180\11\184\1\134\91\170\8\153\30\183\4\159\2\134\12\132\30\249\88\211", "\217\109\235\123");
					end
				end
				break;
			end
			if ((198 == 198) and (v167 == 2)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\4\89\123\230\249\62\71\117\203\229\54\71\119\195\254\52\66", "\151\87\41\18\136")]:IsReady() and v13:HasTier(31, 2) and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1, v60.BlackoutKick)) or (77 > 417)) then
					if ((2112 >= 945) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\72\191\195\222\240\82\161\205\239\253\73\174\196\213\193\80\166\201\219\190\72\170\216\213\240\82\187\211\239\255\84\170\138\130\172", "\158\59\207\170\176");
					end
				end
				if ((2202 <= 2905) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\125\87\32\64\130\72\109\38\71\167\70\93\56", "\236\47\62\83\41")]:IsReady() and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(30, 2)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\247\160\46", "\226\154\201\64\91\202"), v98, nil, not v14:IsInMeleeRange(5)) or (804 < 105)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\64\14\17\68\187\254\90\8\22\117\183\200\74\22\88\89\185\211\76\19\17\94\165\254\72\18\29\10\238\149", "\220\161\41\125\120\42");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\142\120\179\7\178\118\147\27\178\90\169\13\183", "\110\220\17\192")]:IsReady() and (v13:HasTier(30, 2))) or (4809 == 264)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\121\112\58", "\199\20\25\84\122\139\87\145"), v98, nil, not v14:IsInMeleeRange(5)) or (3496 == 1754)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\0\206\167\21\237\120\26\200\160\36\225\78\10\214\238\8\239\85\12\211\167\15\243\120\8\210\171\91\184\17", "\138\39\105\189\206\123");
					end
				end
				if ((1525 < 4339) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\61\11\136\46\248\246\218\235\52\14\138\38", "\159\127\103\233\77\147\153\175")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < 1)) then
					if ((414 <= 2458) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\10\249\234", "\171\103\144\132\202\32"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\35\232\15\27\32\252\24\47\36\224\15\27\111\250\9\2\42\231\5\4\54\214\13\31\42\169\93\66", "\108\112\79\137");
					end
				end
				v167 = 3;
			end
			if ((v167 == 5) or (1078 >= 3716)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\241\156\249\234\135\203\130\247\199\155\195\130\245\207\128\193\135", "\233\162\236\144\132")]:IsReady() and v89(v60.SpinningCraneKick) and v92()) or (4429 < 952)) then
					if ((492 >= 428) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\212\247\20\183\255\81\181\251\253\8\184\248\90\141\207\247\25\178\182\76\183\214\251\20\176\226\70\141\197\241\31\249\162\13", "\63\210\164\158\122\217\150");
					end
				end
				if ((268 <= 1710) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\7\194\241\233\91\200\50\199\251", "\152\83\171\150\140\41")]:IsReady() and v89(v60.TigerPalm) and (v66 == 5)) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\143\236\141", "\104\226\133\227\83\180\123"), v97, nil, not v14:IsInMeleeRange(5)) or (3580 <= 2449)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\2\36\85\17\52\51\81\15\6\99\67\6\25\38\94\10\31\58\111\2\4\38\16\87\95", "\48\99\107\67");
					end
				end
				if ((1884 >= 1382) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\236\179\110\216\36\117\217\140\124\212\40\76\215\168\121", "\27\190\198\29\176\77")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8)) or (2907 <= 1405)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\94\238\60\160\64\232\116\247\53\173\75\208\92\244\58\173\14\252\78\239\49\167\71\251\82\194\53\166\75\175\31\171", "\46\143\43\157\84\201");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\117\116\87\193\84\28\221\67\83\95\193\84", "\168\55\24\54\162\63\115")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\36\242\33\132\221\217\21\245\56\137\220\201\35\232\37\129\214\221", "\174\119\154\64\224\178")]:IsAvailable() and (v66 >= 3) and v89(v60.BlackoutKick)) or (1464 == 2908)) then
					if ((2310 > 110) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\39\119\203", "\132\74\30\165\27\101\199\122"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\235\254\164\172\186\161\59\216\244\174\164\190\244\60\226\237\162\169\188\160\54\216\254\168\162\245\224\119", "\212\79\135\159\199\199\213");
					end
				end
				v167 = 6;
			end
			if ((2948 >= 96) and (v167 == 1)) then
				if ((2545 < 3908) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\152\54\206\36\164\162\40\192\9\184\170\40\194\1\163\168\45", "\202\203\70\167\74")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (272 >= 292)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\17\213\61\127\37\15\219\12\114\62\0\210\54\78\39\8\223\56\49\63\4\206\54\127\37\21\197\12\112\35\4\156\98\37", "\17\76\97\188\83");
					end
				end
				if ((305 < 1603) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\182\55\208\57\62\138\69\164\166\53\216\57\53\168\66\160\142", "\195\229\71\185\87\80\227\43")]:IsReady() and v13:HasTier(31, 2) and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1, v60.BlackoutKick) and v13:BuffUp(v60.DanceofChijiBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (921 >= 2875)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\243\236\9\94\225\233\242\7\111\236\242\253\14\85\208\235\245\3\91\175\243\249\18\85\225\233\232\25\111\238\239\249\64\1\185", "\143\128\156\96\48");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\154\221\241\17\28\183\196\228\57\30\187\218", "\119\216\177\144\114")]:IsReady() and v13:HasTier(31, 2) and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) or (1040 > 3974)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\196\32\247", "\34\169\73\153"), v98, nil, not v14:IsInMeleeRange(5)) or (1103 == 1951)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\224\10\136\161\227\30\159\149\231\2\136\161\172\24\142\184\233\5\130\190\245\52\138\165\233\75\218\242", "\235\202\140\107");
					end
				end
				if ((1522 <= 2556) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\63\100\61\166\231\46\249\194\47\102\53\166\236\12\254\198\7", "\165\108\20\84\200\137\71\151")]:IsReady() and v13:HasTier(31, 2) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (2039 > 3853)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\105\164\34\134\116\189\37\143\69\183\57\137\116\177\20\131\115\183\32\200\105\177\57\141\116\189\63\145\69\181\36\141\58\230\123", "\232\26\212\75");
					end
				end
				v167 = 2;
			end
			if ((v167 == 3) or (1346 > 3400)) then
				if ((1377 <= 2951) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\29\206\117\43\166\14\252\33\20\203\119\35", "\85\95\162\20\72\205\97\137")]:IsReady() and v89(v60.BlackoutKick) and not v92() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\196\245\43\216\2\239\207\248\229\35\210\10\204\223\242\252\46\207", "\173\151\157\74\188\109\152")]:IsAvailable()) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\41\1\54", "\147\68\104\88\189\188\52\181"), v98, nil, not v14:IsInMeleeRange(5)) or (4670 < 4152)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\132\138\211\17\135\158\196\37\131\130\211\17\200\152\213\8\141\133\217\14\145\180\209\21\141\203\129\74", "\176\122\232\235");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\179\97\40\70\229\133\122\60\91\230\133\66\51\65\234\140\122\40\75", "\142\224\21\90\47")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\64\220\50\88\160\142\151\114\221\52\66", "\229\20\180\71\54\196\235")]:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff) and (v66 < 10)) or (956 >= 4088)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\36\127\217", "\224\73\30\161\131\149\202"), v101, v103, not v14:IsInMeleeRange(5)) or (3513 < 3145)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\241\227\89\250\224\206\95\247\218\229\88\244\218\230\89\255\225\253\95\227\225\177\67\244\247\244\94\248\241\232\111\240\234\244\16\163\189", "\48\145\133\145");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\124\77\176\226\216\34\95\127\161\225\220\60", "\76\58\44\213\142\177")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 2)) or (2954 <= 2640)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (44 >= 3931)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\205\37\23\33\113\197\33\45\62\108\196\41\2\109\107\206\54\23\35\113\223\61\45\44\119\206\100\65\125", "\24\171\68\114\77");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\201\20\67\70\148\209\2\139\250\15\73", "\205\143\125\48\50\231\190\100")]:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) or (3729 < 2345)) then
					if (v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\204\166\12", "\194\161\199\116\101\129\131\191"), v101, nil, not v14:IsInMeleeRange(8)) or (3459 <= 536)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\45\219\188\228\157\227\34\247\174\226\176\245\100\219\173\229\167\226\45\220\177\200\163\227\33\136\251\165", "\194\140\68\168\200\151");
					end
				end
				v167 = 4;
			end
			if ((v167 == 0) or (989 <= 108)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\174\177\52\176\129\190\52\143\156\191\60\172", "\220\232\208\81")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 1)) or (4409 == 3432)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (414 == 3640)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\243\191\224\60\37\84\164\202\173\241\63\33\74\225\230\187\247\53\34\83\181\236\129\228\63\41\26\243", "\193\149\222\133\80\76\58");
					end
				end
				if ((4667 > 2632) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\245\73\93\219\205\88\64\212\210\85\74\229\207\83\75\222\201\79\75", "\178\166\61\47")]:IsReady() and v13:HasTier(31, 4) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\207\66\253\116\206\59\233\76\225\105\222", "\94\155\42\136\26\170")]:IsAvailable()) then
					if (v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9)) or (3911 <= 133)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\43\52\188\143\58\25\186\130\0\50\189\129\0\49\188\138\59\42\186\150\59\102\166\129\45\35\187\141\43\63\138\133\48\35\245\208", "\213\228\95\70");
					end
				end
				if ((3100 < 3168) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\12\178\209\144\100\37\189\228\145\101\51", "\23\74\219\162\228")]:IsReady() and v13:BuffUp(v60.InvokersDelightBuff) and not v13:HasTier(30, 2)) then
					if ((2869 >= 166) and v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\52\231\94", "\91\89\134\38\207"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\66\231\219\34\0\239\40\66\209\206\35\1\201\103\87\235\218\51\29\217\51\93\209\201\57\22\144\113", "\71\36\142\168\86\115\176");
					end
				end
				if ((2531 > 843) and v13:IsCasting(v60.FistsofFury) and not v13:HasTier(30, 2)) then
					if ((1249 < 3274) and v24(v62.StopFoF)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\217\168\97\171\16\129\89\79\224\167\103\173\26\129\85\72\209\162\119\179\67\173\83\91\218\175\123\171\26\129\87\70\218\225\42", "\41\191\193\18\223\99\222\54");
					end
				end
				v167 = 1;
			end
		end
	end
	local function v115()
		local v168 = 0;
		while true do
			if ((3 == v168) or (2205 == 4426)) then
				if ((2419 == 2419) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\252\183\7\235\44\196\190\95\245\178\5\227", "\43\190\219\102\136\71\171\203")]:IsReady() and v13:HasTier(31, 2) and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) then
					if ((734 <= 1801) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\47\119\62", "\57\66\30\80"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\212\161\22\143\54\225\144\22\211\169\22\143\121\231\129\59\221\174\28\144\32\203\208\61\152\241\77", "\228\73\184\192\117\228\89\148");
					end
				end
				if ((3440 >= 1532) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\252\157\103\29\196\140\122\18\219\129\112\35\198\135\113\24\192\155\113", "\116\175\233\21")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\202\240\171\72\223\52\45\248\241\173\82", "\95\158\152\222\38\187\81")]:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\245\188\45", "\168\152\221\85\210\195"), v101, v103, not v14:IsInMeleeRange(9)) or (991 > 1450)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\184\202\231\142\160\219\202\136\173\225\225\143\174\225\226\142\165\218\249\136\185\218\181\148\174\204\240\137\162\202\236\184\255\202\181\213\243", "\231\203\190\149");
					end
				end
				if ((3951 >= 2430) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\235\60\230\253\181\251\30\254\41\236\252\172", "\123\173\93\131\145\220\149")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 2)) then
					if ((1747 < 3027) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\197\232\45\125\247\19\251\254\53\123\244\6\132\254\36\102\252\24\205\249\56\75\173\2\132\190\113", "\153\118\164\141\65\20");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\200\59\149\246\228\15\232\20\147\240\238", "\96\142\82\230\130\151")]:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) or (673 <= 619)) then
					if ((3981 == 3981) and v84.CastTargetIf(v60.FistsofFury, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\66\177\87", "\142\47\208\47\34\132"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\183\23\22\72\99\249\184\59\4\78\78\239\254\23\7\73\89\248\183\16\27\100\8\226\254\87\80", "\60\150\222\100\98\59");
					end
				end
				v168 = 4;
			end
			if ((645 <= 4255) and (7 == v168)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\59\212\23\245\40\249\14\209\29", "\169\111\189\112\144\90")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\249\134\36\174\183\137\7\133\222\140\35\185\183\133\36\141\195\130\54\185\186\146\16", "\226\173\227\69\205\223\224\105")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) or (4537 < 601)) then
					if (v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5)) or (3093 <= 740)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\76\55\37\94\221\36\72\63\46\86\143\8\93\44\39\85\198\15\65\1\118\79\143\78\0", "\123\56\94\66\59\175");
					end
				end
				break;
			end
			if ((0 == v168) or (578 == 2925)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\1\136\123\90\121\222\200\142\51\134\115\70", "\221\71\233\30\54\16\176\173")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 1)) or (3930 == 2096)) then
					if ((618 == 618) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\50\253\91\179\61\242\91\128\39\232\81\178\36\188\77\186\38\249\80\182\32\229\97\235\32\188\12", "\223\84\156\62");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\229\236\235\211\185\50\216\251\193\207\182\53\211\215\235\222\188", "\91\182\156\130\189\215")]:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < 1.5) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:HasTier(31, 2)) or (2016 <= 786)) then
					if ((818 < 2120) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\109\99\165\91\112\122\162\82\65\112\190\84\112\118\147\94\119\112\167\21\109\118\190\80\112\122\184\76\65\39\184\21\42", "\53\30\19\204");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\205\233\119\129\181\201\225\124\137", "\199\153\128\16\228")]:IsReady() and v89(v60.TigerPalm) and not v13:HasTier(31, 2)) or (3010 == 1284)) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\220\35\235", "\199\177\74\133\121"), v97, nil, not v14:IsInMeleeRange(5)) or (280 > 3960)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\172\192\187\251\37\249\58\185\197\177\190\36\195\56\189\199\181\234\46\249\126\172\137\234", "\74\216\169\220\158\87\166");
					end
				end
				if ((1912 < 3017) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\219\55\1\37\81\237\44\21\56\82\237\20\26\34\94\228\44\1\40", "\58\136\67\115\76")]:IsReady() and v13:HasTier(31, 4) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\197\162\205\87\129\37\185\91\248\185\204", "\61\145\202\184\57\229\64\203")]:IsAvailable()) then
					if (v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9)) or (283 >= 2180)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\79\70\155\78\87\87\182\72\90\109\157\79\89\109\158\78\82\86\133\72\78\86\201\84\89\64\140\73\85\70\144\120\8\70\201\31", "\39\60\50\233");
					end
				end
				v168 = 1;
			end
			if ((1461 <= 3392) and (v168 == 4)) then
				if (v13:IsCasting(v60.FistsofFury) or (1398 <= 1074)) then
					if ((2022 < 4223) and v24(v62.StopFoF)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\53\68\66\200\133\62\67\3\81\67\201\163\14\70\61\89\85\222\182\113\86\57\69\83\213\179\37\92\3\3\66\155\233\101", "\81\37\92\55\54\187\218");
					end
				end
				if ((2135 <= 4261) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\51\80\191\62\138\5\75\171\35\137\5\115\164\57\133\12\75\191\51", "\225\96\36\205\87")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\221\174\87\119\120\74\27\239\175\81\109", "\105\137\198\34\25\28\47")]:IsAvailable())) then
					if ((4103 > 3232) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\28\168\89", "\160\113\201\33\22"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\199\76\190\174\162\168\235\87\170\152\189\165\209\103\187\174\167\169\216\87\190\163\233\190\209\74\169\169\160\185\205\103\248\179\233\254\130", "\205\180\56\204\199\201");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\176\206\53\22\141\215\50\31\160\204\61\22\134\245\53\27\136", "\120\227\190\92")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or (1702 >= 3939)) then
					if ((2138 >= 782) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\76\22\117\45\85\215\229\2\95\13\122\45\89\230\233\52\95\20\59\48\89\203\231\51\85\11\98\28\8\205\162\110\4", "\130\93\60\127\27\67\60\185");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\122\59\43\71\238\68\78\93\60\19\71\227\72", "\29\40\82\88\46\128\35")]:IsReady() and (v13:BuffUp(v60.PressurePointBuff))) or (939 > 3198)) then
					if ((1621 == 1621) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\54\76\218", "\216\91\37\180\125\97"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\127\15\202\89\34\73\15\214\89\26\125\21\192\92\101\101\25\209\82\43\127\8\218\104\113\98\92\151\7", "\55\69\22\124\163");
					end
				end
				v168 = 5;
			end
			if ((4000 > 2885) and (v168 == 1)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\60\58\176\56\145\39\180\133\15\33\186", "\195\122\83\195\76\226\72\210")]:IsReady() and v13:BuffUp(v60.InvokersDelightBuff) and not v13:HasTier(30, 2)) or (242 >= 4015)) then
					if (v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\233\213\35", "\65\132\180\91\158"), v101, nil, not v14:IsInMeleeRange(8)) or (3778 < 970)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\117\194\58\22\67\222\40\58\122\196\60\28\60\194\43\23\121\223\39\17\101\238\122\17\60\128\126", "\78\101\28\177");
					end
				end
				if ((v13:IsCasting(v60.FistsofFury) and not v13:HasTier(30, 2)) or (2472 >= 3715)) then
					if (v24(v62.StopFoF) or (430 <= 391)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\189\243\69\54\139\239\87\26\178\245\67\60\139\227\80\43\183\229\93\101\167\229\67\32\186\233\69\60\139\180\69\101\229\178", "\49\69\212\128");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\36\28\217\252\239\30\2\215\209\243\22\2\213\217\232\20\7", "\129\119\108\176\146")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:HasTier(31, 2) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or (628 >= 1277)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (70 >= 4938)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\223\14\195\43\7\18\59\240\4\223\36\0\25\3\196\14\206\46\78\15\57\221\2\195\44\26\5\3\155\19\141\116\90", "\124\92\175\103\173\69\110");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\243\49\16\62\207\63\48\34\207\19\10\52\202", "\87\161\88\99")]:IsReady() and v13:BuffUp(v60.PressurePointBuff) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\48\246\225\201\179\197\48\6\219\253\201\160", "\67\114\153\143\172\215\176")]:IsAvailable()) or (4062 <= 653)) then
					if ((3179 > 2277) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\179\171\224", "\110\222\194\142"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\5\208\8\160\92\166\40\202\14\167\109\170\30\218\16\233\65\164\5\220\21\160\70\184\40\141\15\233\0\241", "\193\119\185\123\201\50");
					end
				end
				v168 = 2;
			end
			if ((1907 <= 4736) and (v168 == 2)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\69\1\234\47\1\126\44\98\6\210\47\12\114", "\127\23\104\153\70\111\25")]:IsReady() and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(30, 2)) or (651 == 2122)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\4\14\168", "\211\105\103\198\207\75\76\215"), v98, nil, not v14:IsInMeleeRange(5)) or (449 >= 3779)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\174\163\230\112\11\133\165\219\169\143\228\119\15\177\246\221\162\162\234\112\5\174\175\241\243\164\175\44\94", "\214\174\199\208\143\30\108\218");
					end
				end
				if ((1609 < 2813) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\35\141\24\163\171\81\235\92\31\175\2\169\174", "\41\113\228\107\202\197\54\184")]:IsReady() and (v13:HasTier(30, 2))) then
					if ((304 < 3962) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\119\132\54", "\60\26\237\88"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\202\35\103\239\160\223\21\103\243\160\231\33\125\229\165\152\57\113\244\171\214\35\96\255\145\140\62\52\180\250", "\206\184\74\20\134");
					end
				end
				if ((4435 <= 4879) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\11\244\231\191\253\67\54\203\27\246\239\191\246\97\49\207\51", "\172\88\132\142\209\147\42\88")]:IsReady() and v13:HasTier(31, 2) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (587 >= 4292)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\148\154\197\3\56\252\176\128\181\207\31\55\251\187\184\129\197\14\61\181\173\130\152\201\3\63\225\167\184\222\216\77\100\163", "\222\231\234\172\109\86\149");
					end
				end
				if ((187 <= 1266) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\207\227\193\27\230\224\213\12\198\230\195\19", "\120\141\143\160")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < 1)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\77\165\184", "\50\32\204\214"), v98, nil, not v14:IsInMeleeRange(5)) or (1791 == 3378)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\132\75\52\122\184\30\147\83\10\114\186\18\141\7\38\124\161\20\136\78\33\96\140\69\146\7\100\47", "\113\230\39\85\25\211");
					end
				end
				v168 = 3;
			end
			if ((23 < 367) and (v168 == 5)) then
				if ((2653 < 2944) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\90\223\93\235\212\126\69\224\83\218\95\227", "\148\24\179\60\136\191\17\48")]:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(30, 2)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\191\35\247", "\150\210\74\153\192"), v98, nil, not v14:IsInMeleeRange(5)) or (771 <= 482)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\196\57\137\126\117\161\247\247\51\131\118\113\244\240\205\42\143\123\115\160\250\247\108\158\53\46\230", "\212\131\168\88\234\21\26");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\118\100\128\130\54\46\75\115\170\158\57\41\64\95\128\143\51", "\71\37\20\233\236\88")]:IsReady() and v89(v60.SpinningCraneKick) and v92()) or (3072 < 2132)) then
					if ((1345 == 1345) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\86\185\24\78\229\66\91\242\69\162\23\78\233\115\87\196\69\187\86\83\233\94\89\195\79\164\15\127\184\88\28\153\18", "\60\173\38\208\118\32\140\44");
					end
				end
				if ((2837 <= 4591) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\99\62\224\208\43\192\84\38\202\218\35\196", "\175\33\82\129\179\64")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\221\231\49\203\51\165\236\224\40\198\50\181\218\253\53\206\56\161", "\210\142\143\80\175\92")]:IsAvailable() and v89(v60.BlackoutKick)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\180\224\253", "\166\217\137\147"), v98, nil, not v14:IsInMeleeRange(5)) or (4048 == 1534)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\175\115\165\250\73\246\183\77\173\248\69\232\227\97\163\227\67\237\170\102\191\206\18\247\227\38\240", "\38\131\195\18\198\145");
					end
				end
				if ((4782 > 486) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\96\194\40\226\51\81\92\208\46\227\61\99\90\216\62\231\55\70\87", "\52\51\182\90\139\88")]:IsReady()) then
					if ((3663 >= 1115) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\251\184\200", "\35\150\217\176\135"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\68\25\5\124\70\73\246\86\52\24\127\70\73\238\89\5\8\123\76\100\253\16\24\9\101\70\120\240\68\18\51\35\87\54\173\8", "\22\153\48\107\108\23\35");
					end
				end
				v168 = 6;
			end
			if ((v168 == 6) or (4205 < 877)) then
				if ((3643 < 4772) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\61\149\178\20\113\124\79\238\45\151\186\20\122\94\72\234\5", "\137\110\229\219\122\31\21\33")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (3615 <= 605)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\173\49\117\56\66\42\121\37\190\42\122\56\78\27\117\19\190\51\59\37\78\54\123\20\180\44\98\9\31\48\62\79\237", "\30\122\221\88\27\86\43\68");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\15\32\226\148\52\33\229\129\28\58\234\129\55\38\219\147\54\43\227", "\230\88\72\139")]:IsReady() or (4425 <= 2443)) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (1349 > 1564)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\101\188\31\9\15\1\86\117\139\18\9\2\15\87\124\139\6\14\13\11\80\50\167\19\9\6\6\81\102\173\41\79\23\72\13\32", "\56\18\212\118\123\99\104");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\44\252\235\219\214\208\25\195\249\215\218\233\23\231\252", "\190\126\137\152\179\191")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or (3631 > 4372)) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8)) or (4904 == 2205)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\23\97\195\163\78\47\61\120\202\174\69\23\21\123\197\174\0\59\7\96\206\164\73\60\27\77\159\190\0\125\86", "\32\72\98\18\171\202");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\38\132\51\119\252\11\157\38\95\254\7\131", "\151\100\232\82\20")]:IsReady() and (v89(v60.BlackoutKick))) or (1603 >= 4872)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\114\216\238", "\104\31\185\150"), v101, nil, not v14:IsInMeleeRange(5)) or (1333 >= 1397)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\181\242\244\236\195\245\212\227\178\250\244\236\140\243\197\206\188\253\254\243\213\223\148\200\249\166\161", "\160\188\217\147\151\135\172\128");
					end
				end
				v168 = 7;
			end
		end
	end
	local function v116()
		local v169 = 0;
		while true do
			if ((3066 > 1452) and (v169 == 2)) then
				if ((832 < 2327) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\115\81\190\63\86\204\32\75\84\77\169\1\84\199\43\65\79\87\168", "\45\32\37\204\86\61\169\79")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\97\93\16\178\177\121\71\83\12\175\161", "\28\53\53\101\220\213")]:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff)) then
					if ((400 < 3898) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\0\93\16", "\191\109\60\104\33\58\193\48"), v101, v103, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\148\195\10\238\140\210\39\232\129\232\12\239\130\232\15\238\137\211\20\232\149\211\88\244\130\197\29\233\142\195\1\216\212\195\88\182\209", "\135\231\183\120");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\213\30\94\237\62\31\166\224\30\68\225\2\19\167\226\6\67\246\49", "\201\134\106\44\132\85\122")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\2\4\98\49\5\9\218\37\63\31\99", "\67\86\108\23\95\97\108\168")]:IsAvailable())) or (2180 < 1426)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\169\57\84", "\48\196\88\44\106\196\68\181"), v101, v104, not v14:IsInMeleeRange(9)) or (399 >= 569)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\145\203\206\42\139\161\157\35\132\224\200\43\133\155\181\37\140\219\208\44\146\160\226\63\135\205\217\45\137\176\187\19\209\203\156\114\216", "\76\226\191\188\67\224\196\194");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\255\33\20\228\238\214\46\33\229\239\192", "\157\185\72\103\144")]:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) or (2417 < 57)) then
					if ((2021 < 4765) and v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\84\178\146", "\209\57\211\234\26\200"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\199\181\149\67\237\14\200\153\135\69\192\24\142\181\132\66\215\15\199\178\152\111\129\21\142\244\209", "\178\97\174\198\225\48");
					end
				end
				if ((1888 <= 2498) and v13:IsCasting(v60.FistsofFury)) then
					if ((4990 == 4990) and v24(v62.StopFoF)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\95\23\229\107\217\0\201\105\2\228\106\255\48\204\87\10\242\125\234\79\220\83\22\244\118\239\27\214\105\87\229\56\180\93", "\111\175\54\100\145\24\134");
					end
				end
				v169 = 3;
			end
			if ((3 == v169) or (2621 >= 4268)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\112\13\50\28\72\28\47\19\87\17\37\34\74\23\36\25\76\11\36", "\117\35\121\64")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\233\181\251\216\39\74\207\187\231\197\55", "\47\189\221\142\182\67")]:IsAvailable())) or (3447 <= 2261)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\45\190\63", "\73\64\223\71\171\40\201\64"), v101, nil, not v14:IsInMeleeRange(9)) or (2375 <= 1270)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\25\153\214\80\171\120\53\130\194\102\180\117\15\178\211\80\174\121\6\130\214\93\224\110\15\159\193\87\169\105\19\178\151\77\224\47\94", "\29\106\237\164\57\192");
					end
				end
				if ((4399 > 3707) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\130\180\238\180\219\219\174\245\146\182\230\180\208\249\169\241\186", "\146\209\196\135\218\181\178\192")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (1836 == 2739)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\32\138\31\94\174\35\55\188\18\66\166\35\53\188\26\89\164\38\112\144\20\66\162\35\57\151\8\111\244\57\112\209\71", "\199\77\80\227\113\48");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\8\51\95\206\33\48\75\217\1\54\93\198", "\173\74\95\62")]:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(30, 2)) or (4676 < 2944)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\203\16\82", "\220\166\121\60\86\171\103"), v98, nil, not v14:IsInMeleeRange(5)) or (3225 < 1022)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\14\60\179\48\197\15\253\61\54\185\56\193\90\250\7\47\181\53\195\14\240\61\110\164\123\152\66", "\122\137\98\93\208\91\170");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\180\241\21\65\219\187\167\205\164\243\29\65\208\153\160\201\140", "\170\231\129\124\47\181\210\201")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or (3197 <= 228)) then
					if ((2197 < 4408) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\152\171\51\62\4\35\133\188\5\51\24\43\133\190\5\59\3\41\128\251\41\53\24\47\133\178\46\41\53\121\159\251\105\96", "\74\235\219\90\80\106");
					end
				end
				v169 = 4;
			end
			if ((1161 == 1161) and (v169 == 5)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\71\249\164\179\124\226\176\145\116\232\178\140\124\226\179", "\219\21\140\215")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or (2981 >= 4641)) then
					if ((3732 == 3732) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\173\213\175\81\70\191\249\173\89\76\189\249\176\81\70\188\134\180\93\90\189\200\174\76\81\135\149\179\24\28\232", "\56\40\216\166\199");
					end
				end
				if ((669 <= 2896) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\4\184\20\44\45\187\0\59\13\189\22\36", "\79\70\212\117")]:IsReady() and (v89(v60.BlackoutKick))) then
					if ((4513 >= 3253) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\170\23\249", "\109\199\118\129\166\153"), v101, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\51\188\118\245\58\191\98\226\14\187\126\245\58\240\100\243\35\181\121\255\37\169\72\165\37\240\35\164", "\150\81\208\23");
					end
				end
				if ((4559 > 1202) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\205\204\231\142\235\245\225\135\244", "\235\153\165\128")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\143\76\163\44\78\47\164\249\168\70\164\59\78\35\135\241\181\72\177\59\67\52\179", "\158\219\41\194\79\38\70\202")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) then
					if (v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5)) or (3361 <= 1511)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\44\40\7\252\233\152\66\41\34\66\253\211\154\70\43\38\22\247\233\219\87\101\123\86", "\232\35\69\79\98\142\182");
					end
				end
				break;
			end
			if ((3220 > 2301) and (v169 == 4)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\110\207\90\56\49\251\111\230\103\202\88\48", "\146\44\163\59\91\90\148\26")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 2)) or (3805 > 3992)) then
					if ((4938 > 821) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\120\36\182", "\41\21\77\216\225"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\65\115\70\31\66\103\81\43\70\123\70\31\13\97\64\6\72\124\76\0\84\77\22\0\13\33\23", "\37\116\45\18");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\237\243\87\161\160\192\234\66\137\162\204\244", "\203\175\159\54\194")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\72\198\24\63\85\88\192\116\214\16\53\93\123\208\126\207\29\40", "\162\27\174\121\91\58\47")]:IsAvailable() and v89(v60.BlackoutKick)) or (373 >= 2839)) then
					if ((1257 == 1257) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\222\204\17", "\185\179\165\127\149\95"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\121\206\247\28\94\96\219\203\28\88\118\196\180\4\84\103\202\250\30\69\108\240\167\3\17\38\155", "\119\49\21\175\148");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\100\161\4\84\38\76\133\243\67\189\19\106\36\71\142\249\88\167\18", "\149\55\213\118\61\77\41\234")]:IsReady() or (4808 <= 460)) then
					if ((3 <= 3064) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\16\7\210", "\123\125\102\170\166\137\89\207"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\93\20\74\52\5\134\150\65\6\103\41\6\134\150\89\9\86\57\2\140\187\74\64\75\56\28\134\167\71\20\65\2\93\151\233\29\86", "\201\46\96\56\93\110\227");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\140\11\231\235\25\200\181\4\202\235\20\198\180\13\222\236\27\194\179", "\161\219\99\142\153\117")]:IsReady() or (3203 < 2140)) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (911 >= 3423)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\107\185\175\97\193\117\191\161\76\201\110\176\161\124\195\67\161\179\125\206\116\241\181\118\223\121\191\175\103\212\67\226\178\51\158\36", "\173\28\209\198\19");
					end
				end
				v169 = 5;
			end
			if ((4989 > 379) and (v169 == 0)) then
				if ((4493 > 2862) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\220\66\118\237\19\240\132\201\87\124\236\10", "\225\154\35\19\129\122\158")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 1)) then
					if ((4803 >= 402) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\1\238\91\252\233\213\11\73\20\228\90\229\167\195\49\72\5\229\94\225\254\239\103\78\64\185", "\84\58\96\139\55\149\135\176");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\49\51\162\3\69\192\43\7\20\170\3\69", "\94\115\95\195\96\46\175")]:IsReady() and v13:HasTier(31, 2) and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) or (4791 <= 361)) then
					if ((4487 == 4487) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\78\66\49", "\128\35\43\95\93\78\77\231"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\17\55\55\28\113\188\176\34\61\61\20\117\233\183\24\36\49\25\119\189\189\34\101\32\87\42", "\201\196\125\86\84\119\30");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\247\231\3\186\209\222\5\179\206", "\223\163\142\100")]:IsReady() and (v89(v60.TigerPalm))) or (1090 > 1950)) then
					if ((4037 > 970) and v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\143\31\205", "\216\226\118\163\209"), v97, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\249\28\4\69\79\47\191\252\22\65\68\117\45\187\254\18\21\78\79\108\170\176\77", "\95\222\144\123\97\55\16");
					end
				end
				if ((1402 < 3635) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\43\141\169\74\237\30\183\175\77\200\16\135\177", "\131\121\228\218\35")]:IsReady() and (v13:BuffUp(v60.PressurePointBuff))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\212\217\44", "\123\185\176\66\97\25"), v98, nil, not v14:IsInMeleeRange(5)) or (698 > 4970)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\218\6\10\88\27\40\103\34\221\1\38\90\28\44\83\113\219\10\11\84\27\38\76\40\247\92\13\17\77", "\81\168\111\121\49\117\79\56");
					end
				end
				v169 = 1;
			end
			if ((103 <= 4002) and (v169 == 1)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\245\3\246\191\201\13\214\163\201\33\236\181\204", "\214\167\106\133")]:IsReady() and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(30, 2)) or (3404 > 4418)) then
					if ((3833 == 3833) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\36\49\66", "\185\73\88\44\47\84\31"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\154\222\9\169\221\248\183\196\15\174\236\244\129\212\17\224\192\250\154\210\20\169\199\230\183\132\14\224\130\175", "\159\232\183\122\192\179");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\22\59\187\40\42\53\155\52\42\25\161\34\47", "\65\68\82\200")]:IsReady() and (v13:HasTier(30, 2))) or (3535 <= 917)) then
					if ((4539 > 1252) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\40\89\124", "\30\69\48\18\64\175\175"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\37\12\229\53\247\19\12\249\53\207\39\22\239\48\176\63\26\254\62\254\37\11\245\4\163\56\95\189\105", "\91\144\76\127\140");
					end
				end
				if ((1643 == 1643) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\194\4\71\34\216\181\192\196\203\1\69\42", "\176\128\104\38\65\179\218\181")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < 1)) then
					if ((4168 == 4168) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\221\205\204", "\117\176\164\162"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\206\4\243\209\118\145\214\58\251\211\122\143\130\22\245\200\124\138\203\17\233\229\42\144\130\83", "\25\228\162\101\144\186");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\110\55\188\2\251\234\77\5\173\1\255\244", "\132\40\86\217\110\146")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 2)) or (3134 == 4945)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (988 < 432)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\120\202\34\176\174\125\249\97\109\223\40\177\183\51\239\91\108\206\41\181\179\106\195\13\106\139\118\232", "\62\30\171\71\220\199\19\156");
					end
				end
				v169 = 2;
			end
		end
	end
	local function v117()
		local v170 = 0;
		while true do
			if ((v170 == 0) or (4866 == 2021)) then
				if ((1135 < 4181) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\95\1\26\241\112\14\26\206\109\15\18\237", "\157\25\96\127")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 2) and (not v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < 2) and v14:DebuffDown(v60.SkyreachExhaustionDebuff)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (1145 <= 952)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\130\240\9\89\63\162\188\230\17\95\60\183\195\230\0\66\52\169\138\225\28\111\99\179\195\167", "\81\199\227\149\101\48");
					end
				end
				if ((2863 >= 1073) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\73\91\252\20\228\182\61\183\112", "\219\29\50\155\113\150\230\92")]:IsReady() and (v89(v60.TigerPalm))) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\220\41\203", "\45\177\64\165\27\159\40"), v97, nil, not v14:IsInMeleeRange(5)) or (1335 >= 2223)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\31\8\175\96\34\6\14\166\127\93\5\10\184\119\19\31\27\179\77\79\2\79\254", "\18\125\118\111\202");
					end
				end
				if ((2014 > 750) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\98\53\74\243\62\170\244\238\94\23\80\249\59", "\155\48\92\57\154\80\205\167")]:IsReady() and (v13:BuffUp(v60.PressurePointBuff))) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\180\196\181", "\37\217\173\219\223\152\203"), v98, nil, not v14:IsInMeleeRange(5)) or (4307 < 3447)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\27\12\12\63\65\175\201\26\16\17\9\68\161\245\2\69\12\51\93\173\248\0\17\6\9\29\188\182\81", "\150\105\101\127\86\47\200");
					end
				end
				v170 = 1;
			end
			if ((v170 == 2) or (4875 <= 2673)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\115\166\28\246\253\81\29\61\65\168\20\234", "\110\53\199\121\154\148\63\120")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 2)) or (2963 == 1842)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (3029 == 1051)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\27\250\51\80\242\4\37\236\43\86\241\17\90\236\58\75\249\15\19\235\38\102\174\21\90\174\107", "\156\97\122\159\95\57");
					end
				end
				if ((370 == 370) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\253\162\200\241\0\7\48\200\162\210\253\60\11\49\202\186\213\234\15", "\95\174\214\186\152\107\98")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\189\6\100\133\23\195\155\8\120\152\7", "\166\233\110\17\235\115")]:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\117\15\220", "\28\24\110\164\161\146\222"), v101, v103, not v14:IsInMeleeRange(9)) or (4797 == 3860)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\72\215\68\44\80\198\105\42\93\252\66\45\94\252\65\44\85\199\90\42\73\199\22\54\94\209\83\43\82\215\79\26\9\215\22\116\13", "\69\59\163\54");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\131\188\216\67\56\200\185\182\188\194\79\4\196\184\180\164\197\88\55", "\214\208\200\170\42\83\173")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\237\41\103\174\113\220\51\116\169\102\205", "\21\185\65\18\192")]:IsAvailable())) or (1671 == 493)) then
					if ((4059 < 4397) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\243\87\69", "\193\158\54\61\123"), v101, v104, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\38\5\50\176\62\20\31\182\51\46\52\177\48\46\55\176\59\21\44\182\39\21\96\170\48\3\37\183\60\5\57\134\103\5\96\232\109", "\217\85\113\64");
					end
				end
				v170 = 3;
			end
			if ((476 <= 1651) and (v170 == 3)) then
				if ((3371 <= 3459) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\109\6\223\212\252\141\227\109\26\222\217", "\133\43\111\172\160\143\226")]:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) then
					if ((450 <= 963) and v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\198\162\72", "\160\171\195\48\177"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\213\10\101\57\79\254\160\193\236\5\99\63\69\129\188\194\193\6\120\36\72\216\144\149\199\67\36\125", "\167\179\99\22\77\60\161\207");
					end
				end
				if (v13:IsCasting(v60.FistsofFury) or (2197 >= 2721)) then
					if ((2180 == 2180) and v24(v62.StopFoF)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\118\152\76\95\62\112\141\103\74\20\109\146\103\79\0\113\136\93\64\65\108\142\74\73\15\118\159\65\115\83\107\203\10\30", "\44\97\31\235\56");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\194\26\234\173\250\11\247\162\229\6\253\147\248\0\252\168\254\28\252", "\196\145\110\152")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\108\38\235\252\92\43\236\244\81\61\234", "\146\56\78\158")]:IsAvailable())) or (1389 >= 4893)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\32\218\87", "\58\77\187\47\134"), v101, nil, not v14:IsInMeleeRange(9)) or (1510 <= 489)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\33\179\14\238\43\107\17\20\10\181\15\224\17\67\23\28\49\173\8\247\42\20\13\23\39\164\9\236\58\77\33\64\33\225\85\177", "\126\114\85\193\103\133\78\52");
					end
				end
				v170 = 4;
			end
			if ((2741 >= 1612) and (v170 == 1)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\252\251\224\188\201\199\253\231\253\158\206\195\197", "\160\174\146\147\213\167")]:IsReady() and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(30, 2)) or (1676 == 4911)) then
					if ((1098 >= 752) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\77\237\20", "\33\32\132\122\36\108"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\29\97\66\114\190\43\97\94\114\134\31\123\72\119\249\7\119\89\121\183\29\102\82\67\235\0\50\26\44", "\28\217\116\18\43");
					end
				end
				if ((2273 >= 1818) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\224\94\197\93\222\169\15\199\89\253\93\211\165", "\92\178\55\182\52\176\206")]:IsReady() and (v13:HasTier(30, 2))) then
					if ((984 >= 564) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\23\60\127", "\117\122\85\17"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\154\230\57\77\168\218\183\252\63\74\153\214\129\236\33\4\181\216\154\234\36\77\178\196\183\189\62\4\247\143", "\189\232\143\74\36\198");
					end
				end
				if ((2075 >= 1708) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\222\166\11\77\220\5\233\190\33\71\212\1", "\106\156\202\106\46\183")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < 1)) then
					if ((1413 < 2247) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\48\16\117", "\74\93\121\27\83"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\127\183\231\125\118\180\243\106\66\176\239\125\118\251\245\123\111\190\232\119\105\162\217\44\105\251\176", "\30\29\219\134");
					end
				end
				v170 = 2;
			end
			if ((4 == v170) or (4030 < 1956)) then
				if ((2696 >= 1598) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\230\215\51\123\207\212\39\108\239\210\49\115", "\24\164\187\82")]:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(30, 2)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\252\211\82", "\145\145\186\60\202"), v98, nil, not v14:IsInMeleeRange(5)) or (4737 < 1061)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\220\50\7\237\223\38\16\217\219\58\7\237\144\32\1\244\213\61\13\242\201\12\86\242\144\97\82", "\100\134\176\83");
					end
				end
				if ((3628 >= 1113) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\241\205\67\190\184\26\198\213\105\180\176\30", "\117\179\161\34\221\211")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 2)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\64\185\244", "\197\45\208\154\166\100\159"), v98, nil, not v14:IsInMeleeRange(5)) or (767 >= 873)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\248\135\191\56\38\225\146\131\56\32\247\141\252\32\44\230\131\178\58\61\237\185\238\39\105\166\222", "\83\73\148\230\220");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\17\211\247\227\228\134\38\203\221\233\236\130", "\233\83\191\150\128\143")]:IsReady() and v89(v60.BlackoutKick) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\209\143\220\102\30\248\128\233\103\31\238", "\109\151\230\175\18")]:CooldownRemains() > 5) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\147\242\64\64\143\183\248\78\92\137\174\253\117\86\133\161\254\82", "\224\192\154\33\36")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 1)) or (2990 > 4861)) then
					if ((2185 >= 1586) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\142\93\22", "\226\227\52\120"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\231\237\167\65\176\194\173\58\224\229\167\65\255\196\188\23\238\226\173\94\166\232\235\17\171\191\244", "\217\101\139\140\196\42\223\183");
					end
				end
				v170 = 5;
			end
			if ((3588 < 3735) and (v170 == 6)) then
				if ((4844 >= 2019) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\17\160\65\37\56\163\85\50\24\165\67\45", "\70\83\204\32")]:IsReady() and (v89(v60.BlackoutKick))) then
					if ((844 == 844) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\3\128\19", "\224\110\225\107"), v101, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\122\220\50\59\203\209\224\73\214\56\51\207\132\231\115\207\52\62\205\208\237\73\143\37\112\151\156", "\164\148\22\189\81\80\164");
					end
				end
				if ((3182 >= 2210) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\134\137\112\182\53\123\118\190\141", "\23\210\224\23\211\71\43")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\157\131\17\180\93\34\210\247\186\137\22\163\93\46\241\255\167\135\3\163\80\57\197", "\144\201\230\112\215\53\75\188")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) then
					if (v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5)) or (3624 == 240)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\65\204\30\239\228\154\69\196\21\231\182\182\80\215\28\228\255\177\76\250\75\254\182\241\5", "\197\53\165\121\138\150");
					end
				end
				break;
			end
			if ((v170 == 5) or (1701 == 4007)) then
				if ((3990 > 2761) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\41\31\166\20\74\19\1\168\57\86\27\1\170\49\77\25\4", "\36\122\111\207\122")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if ((4912 > 2541) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\24\237\182\182\61\2\15\219\187\170\53\2\13\219\179\177\55\7\72\247\189\170\49\2\1\240\161\135\102\24\72\183\234", "\84\108\104\132\216\216");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\255\11\207\86\238\173\76\203\56\212\89\238\161\105\197\24\205", "\34\172\123\166\56\128\196")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or (4017 <= 3947)) then
					if ((1172 <= 2804) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\185\161\197\68\122\219\19\155\170\186\202\68\118\234\31\173\170\163\139\89\118\199\17\170\160\188\210\117\33\193\84\247\253", "\116\196\201\200\171\42\19\181");
					end
				end
				if ((2686 >= 2293) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\65\142\242\79\25\9\18\113\162\233\92\18\15\18\70\147\245\94\29", "\124\22\230\155\61\117\96")]:IsReady()) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (112 == 4932)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\210\163\239\249\242\228\251\194\148\226\249\255\234\250\203\148\246\254\240\238\253\133\184\227\249\251\227\252\209\178\217\185\234\173\166\147", "\149\165\203\134\139\158\141");
					end
				end
				v170 = 6;
			end
		end
	end
	local function v118()
		local v171 = 0;
		while true do
			if ((1694 >= 838) and (v171 == 3)) then
				if ((364 < 4588) and v13:IsCasting(v60.FistsofFury)) then
					if (v24(v62.StopFoF) or (4004 == 4681)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\177\224\103\73\202\242\190\204\117\79\231\228\135\240\114\84\246\248\180\179\96\95\231\248\182\250\103\67\202\238\172\179\33\12", "\149\157\216\147\19\58");
					end
				end
				if ((3204 >= 12) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\250\150\17\198\199\143\22\207\234\148\25\198\204\173\17\203\194", "\168\169\230\120")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:HasTier(31, 2)) then
					if ((696 >= 310) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\239\157\141\25\242\132\138\16\195\142\150\22\242\136\187\28\245\142\143\87\239\136\150\18\242\132\144\14\195\158\144\87\174\213", "\119\156\237\228");
					end
				end
				if ((762 == 762) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\240\197\18\119\200\212\15\120\215\217\5\73\202\223\4\114\204\195\4", "\30\163\177\96")]:IsReady() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > v13:BuffRemains(v60.CalltoDominanceBuff))) then
					if ((1701 >= 1502) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\52\71\128\54\46\235\21\38\106\157\53\46\235\13\41\91\141\49\36\198\30\96\70\140\47\46\218\19\52\76\182\46\63\148\73\112", "\180\122\64\53\233\93\75");
					end
				end
				if ((4997 >= 4359) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\244\27\18\62\221\24\6\41\253\30\16\54", "\93\182\119\115")]:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(30, 2)) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5)) or (2955 <= 1567)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\128\19\210\143\188\241\151\11\236\135\190\253\137\95\192\137\165\251\140\22\199\149\136\237\150\95\128\222", "\158\226\127\179\236\215");
					end
				end
				v171 = 4;
			end
			if ((4089 >= 3094) and (v171 == 2)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\53\188\65\51\175\242\134\245\18\160\86\13\173\249\141\255\9\186\87", "\147\102\200\51\90\196\151\233")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\15\248\250\195\186\229\41\61\249\252\217", "\91\91\144\143\173\222\128")]:IsAvailable() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > 55)) or (1200 > 3639)) then
					if ((3001 <= 3475) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\180\94\88\160\75\28\175\74\110\191\70\38\159\91\88\165\74\47\175\94\85\235\93\38\178\73\95\162\90\58\159\95\69\235\31\123", "\46\67\192\44\49\203");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\55\198\39\172\42\173\11\3\245\60\163\42\161\46\13\213\37", "\101\100\182\78\194\68\196")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1, v60.RisingSunKick) and v13:HasTier(31, 2)) or (4917 < 4513)) then
					if ((1492 >= 878) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\88\57\251\131\66\118\210\119\75\34\244\131\78\71\222\65\75\59\181\158\78\106\208\70\65\36\236\178\88\108\149\26\24", "\181\40\40\80\149\237\43\24");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\55\190\36\49\177\69\7\1\153\44\49\177", "\114\117\210\69\82\218\42")]:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(31, 2) and v13:BuffUp(v60.BlackoutReinforcementBuff) and v13:PrevGCD(1, v60.RisingSunKick)) or (4711 < 4563)) then
					if ((4007 > 2030) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\218\89\112\167\75\195\76\76\167\77\213\83\51\191\65\196\93\125\165\80\207\103\96\184\4\132\10", "\204\36\182\56\19");
					end
				end
				if ((661 < 4452) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\207\66\207\151\110\55\20\207\94\206\154", "\114\137\43\188\227\29\88")]:IsReady() and (v13:BuffUp(v60.InvokersDelightBuff))) then
					if ((4943 == 4943) and v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\20\187\4\247\34\167\22\219\27\189\2\253\93\187\21\246\24\166\25\240\4\151\3\240\93\250\68", "\112\132\125\200");
					end
				end
				v171 = 3;
			end
			if ((v171 == 4) or (1102 == 156)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\211\204\200\213\250\207\220\194\218\201\202\221", "\182\145\160\169")]:IsReady() and (v89(v60.BlackoutKick))) or (425 >= 1463)) then
					if ((972 == 972) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\44\49\21\172\0\44\52\15\29\174\12\50\96\35\19\181\10\55\41\36\15\152\28\45\96\99\66", "\111\89\64\80\118\199");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\140\167\7\72\177\190\0\65\156\165\15\72\186\156\7\69\180", "\38\223\215\110")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) or (1130 > 1637)) then
					if ((2172 > 1834) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\77\203\5\203\165\87\213\11\250\168\76\218\2\192\148\85\210\15\206\235\77\222\30\192\165\87\207\21\250\184\74\155\95\147", "\203\62\187\108\165");
					end
				end
				if ((851 <= 1672) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\206\124\65\44\125\247\222\254\80\90\63\118\241\222\201\97\70\61\121", "\176\153\20\40\94\17\158")]:IsReady()) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (3342 < 218)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\59\178\65\201\161\61\188\108\193\186\50\188\92\203\151\35\174\93\198\160\115\168\86\215\173\61\178\71\220\151\32\175\19\150\240", "\165\200\83\219\51");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\243\227\115\126\195\133\189\232\202", "\132\167\138\20\27\177\213\220")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\198\208\226\79\52\251\219\228\95\51\244\193\235\73\17\253\219\226\95\40\247\199\250", "\92\146\181\131\44")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) or (3321 >= 3587)) then
					if ((746 == 746) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\247\70\131\172\127\7\220\71\243\1\149\187\82\18\211\66\234\88\185\173\84\87\137\27", "\189\43\158\33\230\222\32\119");
					end
				end
				break;
			end
			if ((1278 <= 3583) and (v171 == 0)) then
				if ((4441 > 1421) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\203\222\220\44\228\209\220\19\249\208\212\48", "\64\141\191\185")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 2) and v14:DebuffDown(v60.SkyreachExhaustionDebuff)) then
					if ((3863 <= 4530) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\5\235\181\214\254\199\163\60\249\164\213\250\217\230\16\239\162\223\249\192\178\26\213\163\206\183\155", "\198\99\138\208\186\151\169");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\62\229\138\80\3\252\141\89\46\231\130\80\8\222\138\93\6", "\62\109\149\227")]:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < 1.5) and v89(v60.SpinningCraneKick) and v13:BuffDown(v60.BlackoutReinforcementBuff) and v13:HasTier(31, 4)) or (2363 >= 3896)) then
					if ((2566 == 2566) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\224\152\128\218\14\250\134\142\235\3\225\137\135\209\63\248\129\138\223\64\224\141\155\209\14\250\156\144\235\19\231\200\221", "\96\147\232\233\180");
					end
				end
				if ((208 < 1909) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\28\49\29\78\159\9\41\52\23", "\89\72\88\122\43\237")]:IsReady() and v14:DebuffDown(v60.SkyreachExhaustionDebuff) and v89(v60.TigerPalm)) then
					if (v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5)) or (2463 <= 557)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\178\162\51\9\19\171\164\58\22\108\168\160\36\30\34\178\177\47\36\63\175\229\96", "\123\76\219\197\86");
					end
				end
				if ((4675 >= 586) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\106\209\6\5\224\56\107\205\27\39\231\60\83", "\95\56\184\117\108\142")]:IsReady()) then
					if ((385 < 1355) and v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\203\53\229\254\197\25\255\229\204\25\231\249\193\45\172\227\199\52\233\254\203\50\245\207\209\50\172\161\144", "\140\144\162\70");
					end
				end
				v171 = 1;
			end
			if ((4521 > 3942) and (v171 == 1)) then
				if ((806 == 806) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\242\36\88\113\229\223\61\77\89\231\211\35", "\142\176\72\57\18")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < 1)) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5)) or (1986 == 2320)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\164\61\17\39\173\62\5\48\153\58\25\39\173\113\3\33\180\52\30\45\178\40\47\55\178\113\72", "\68\198\81\112");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\132\27\162\29\71\24\184\9\164\28\73\42\190\1\180\24\67\15\179", "\125\215\111\208\116\44")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\51\79\90\253\124\89\21\65\70\224\108", "\60\103\39\47\147\24")]:IsAvailable() and v13:HasTier(31, 4)) or (1924 > 3250)) then
					if ((1421 <= 1433) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\30\229\137\221\246\113\227\12\200\148\222\246\113\251\3\249\132\218\252\92\232\74\228\133\196\246\64\229\30\238\191\197\231\14\189\90", "\46\140\106\151\224\182\147");
					end
				end
				if ((4307 > 4) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\205\44\120\78\226\35\120\113\255\34\112\82", "\34\139\77\29")]:IsCastable() and (v14:DebuffRemains(v60.FaeExposureDebuff) < 2)) then
					if ((834 == 834) and v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\241\24\88\32\190\245\34\71\61\191\253\13\20\58\181\226\24\90\32\164\233\34\71\61\240\161\73", "\73\208\144\125\52");
					end
				end
				if ((2942 == 2942) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\25\248\152\194\204\21\92\205\62\228\143\252\206\30\87\199\37\254\142", "\171\74\140\234\171\167\112\51")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\27\6\89\81\245\168\61\8\69\76\229", "\205\79\110\44\63\145")]:IsAvailable() and v13:BuffUp(v60.CalltoDominanceBuff) and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > v13:BuffRemains(v60.CalltoDominanceBuff))) then
					if ((2389 < 4158) and v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\75\45\193\191\14\155\19\161\96\43\192\177\52\179\21\169\91\51\199\166\15\228\15\162\77\58\198\189\31\189\35\180\75\127\153\226", "\124\199\63\95\168\212\107\196");
					end
				end
				v171 = 2;
			end
		end
	end
	local function v119()
		local v172 = 0;
		while true do
			if ((1270 <= 1567) and (6 == v172)) then
				if ((4505 >= 3433) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\108\4\133\172\247\142\91\28\175\166\255\138", "\225\46\104\228\207\156")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\167\201\189", "\223\202\160\211\46\87\51\210"), v98, nil, not v14:IsInMeleeRange(5)) or (825 >= 2346)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\212\229\27\119\6\217\252\14\75\6\223\234\17\52\9\211\239\27\97\1\194\214\27\123\8\150\186\66", "\109\182\137\122\20");
					end
				end
				if ((4479 <= 4948) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\97\189\0\243\235\210\229\122\70\161\23\205\233\217\238\112\93\187\22", "\28\50\201\114\154\128\183\138")]:IsReady()) then
					if ((2290 >= 232) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\167\135\1", "\146\202\230\121"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\251\252\23\204\183\159\49\232\208\250\22\194\141\183\55\224\235\226\17\213\182\224\58\235\233\239\11\203\166\159\63\225\234\174\74\151", "\94\142\143\142\126\167\210\192");
					end
				end
				if ((2046 <= 3976) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\34\201\28\226\204\15\208\9\202\206\3\206", "\167\96\165\125\129")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\52\222\23\66\77\49\73\135\31\223\24\65\118\52\78\137\3\197", "\232\103\182\118\38\34\70\43")]:IsAvailable() and v89(v60.BlackoutKick) and not v92()) then
					if ((273 < 3427) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\56\94\33", "\17\85\55\79\131\80"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\202\137\184\175\52\199\144\173\147\52\193\134\178\236\59\205\131\184\185\51\220\186\184\163\58\136\209\235", "\95\168\229\217\204");
					end
				end
				v172 = 7;
			end
			if ((v172 == 7) or (1705 >= 2088)) then
				if ((4995 == 4995) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\169\51\143\171\159\41\149\157", "\233\234\91\230")]:IsReady() and (((v13:ChiDeficit() >= 1) and (v66 == 1)) or (v13:ChiDeficit() >= 2))) then
					if (v24(v60.ChiBurst, not v14:IsInRange(40), true) or (3051 < 2678)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\73\139\76\165\68\83\145\103\231\85\68\132\114\178\93\85\189\114\168\84\1\214\39", "\199\49\33\226\19");
					end
				end
				break;
			end
			if ((163 == 163) and (3 == v172)) then
				if ((132 <= 2347) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\75\58\73\37\115\131\10\123\22\82\54\120\133\10\76\39\78\52\119", "\100\28\82\32\87\31\234")]:IsReady() and (v66 >= 5)) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (602 >= 2443)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\38\90\233\99\247\223\230\57\14\86\242\112\252\217\230\1\33\71\238\114\243\150\236\59\55\83\245\125\239\233\233\49\52\18\178\33", "\94\81\50\128\17\155\182\136");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\185\53\247\48\236\179\47\146\133\23\237\58\233", "\231\235\92\132\89\130\212\124")]:IsReady() and (v13:HasTier(30, 2) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\201\188\253\45\221\76\240\179\208\45\208\66\241\186\196\42\223\70\246", "\37\158\212\148\95\177")]:IsAvailable() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\67\20\173\149\1\125\18\163\163\31\117\27\171\137\61\97\18\167\143", "\109\20\124\196\231")]:CooldownRemains() < 3) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\134\180\103\177\34\47\166\155\97\183\40", "\64\192\221\20\197\81")]:CooldownRemains() > 3) and v13:BuffDown(v60.KicksofFlowingMomentumBuff)))) or (4582 <= 2199)) then
					if ((1647 == 1647) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\162\255\236", "\199\207\150\130\194"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\167\67\104\225\77\178\117\104\253\77\138\65\114\235\72\245\78\126\238\66\160\70\111\215\66\186\79\59\186\17", "\35\213\42\27\136");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\133\159\43\186\212\218\161\149\54", "\146\192\231\91\223\184")]:IsReady() and (((v13:Chi() == 1) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\104\248\229\32\223\179\52\27\84\218\255\42\218", "\110\58\145\150\73\177\212\103")]:CooldownUp() or v60[LUAOBFUSACTOR_DECRYPT_STR_0("\199\32\216\251\64\206\230\242\32\194\247\124\194\231\240\56\197\224\79", "\137\148\84\170\146\43\171")]:CooldownUp())) or ((v13:Chi() == 2) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\39\214\108\233\100\14\217\89\232\101\24", "\23\97\191\31\157")]:CooldownUp()))) or (2492 <= 2221)) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8)) or (4990 <= 3905)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\131\154\23\0\209\13\142\131\21\8\157\54\131\132\6\16\209\38\185\131\8\0\157\96\210", "\82\230\226\103\101\189");
					end
				end
				v172 = 4;
			end
			if ((v172 == 4) or (3802 == 2812)) then
				if ((852 <= 1952) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\184\58\186\191\26\130\36\180\146\6\138\36\182\154\29\136\33", "\116\235\74\211\209")]:IsReady() and v89(v60.SpinningCraneKick) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\14\53\205\49\59\51\216\3\61\46\199", "\69\72\92\190")]:CooldownRemains() < 5) and (v13:BuffStack(v60.ChiEnergyBuff) > 10)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (3908 <= 2891)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\43\237\218\165\161\24\176\9\56\246\213\165\173\41\188\63\56\239\148\175\173\16\182\35\55\240\235\170\167\19\247\100\109", "\215\86\91\132\180\203\200\118");
					end
				end
				if ((4199 > 1607) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\16\230\143\241\38\252\149\199", "\179\83\142\230")]:IsCastable() and (v13:Chi() < 5) and (v13:BloodlustUp() or (v13:Energy() < 50))) then
					if (v24(v60.ChiBurst, not v14:IsInRange(40), true) or (3841 >= 4873)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\217\39\244\10\59\10\229\204\206\111\249\48\63\30\226\211\206\16\252\58\60\95\165\135", "\191\186\79\157\85\89\127\151");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\197\106\173\192\138\76\248\125\135\220\133\75\243\81\173\205\143", "\37\150\26\196\174\228")]:IsReady() and v89(v60.SpinningCraneKick) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\239\249\161\65\36\134\207\214\167\71\46", "\233\169\144\210\53\87")]:CooldownRemains() > 3) or (v13:Chi() > 2)) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff) and (v13:BloodlustUp() or v13:BuffUp(v60.InvokersDelightBuff))) or (3852 < 601)) then
					if ((1850 <= 4893) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\86\228\210\44\79\227\219\29\69\255\221\44\67\210\215\43\69\230\156\38\67\235\221\55\74\249\227\35\73\232\156\113\22", "\188\66\38\141");
					end
				end
				v172 = 5;
			end
			if ((925 < 3951) and (v172 == 5)) then
				if ((1275 < 1308) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\195\92\12\50\120\77\29\220\202\89\14\58", "\168\129\48\109\81\19\34\104")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\68\28\13\52\208\50\185\246\111\29\2\55\235\55\190\248\115\7", "\153\23\116\108\80\191\69\219")]:IsAvailable() and v89(v60.BlackoutKick) and v13:HasTier(30, 2) and v13:BuffDown(v60.BonedustBrewBuff) and (((v66 < 15) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\106\13\252\214\253\189\121\91\11\248\192", "\22\41\127\157\184\152\235")]:IsAvailable()) or (v66 < 8))) then
					if ((316 >= 80) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\26\206\239", "\170\119\167\129"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\252\189\112\136\81\207\228\131\120\138\93\209\176\184\118\133\95\207\252\168\76\130\81\223\176\239\33", "\62\186\144\220\19\227");
					end
				end
				if ((2841 <= 4050) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\146\236\229\216\175\245\226\209\130\238\237\216\164\215\229\213\170", "\182\193\156\140")]:IsReady() and v89(v60.SpinningCraneKick) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\231\69\5\166\245\48\199\106\3\160\255", "\95\161\44\118\210\134")]:CooldownRemains() > 3) or (v13:Chi() > 4)) and v92()) then
					if ((4085 < 4453) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\80\26\3\116\223\235\169\217\67\1\12\116\211\218\165\239\67\24\77\126\211\227\175\243\76\7\50\123\217\224\238\181\20", "\206\134\32\115\109\26\182\133");
					end
				end
				if ((26 < 2618) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\4\237\220\27\84\83\49\210\206\23\88\106\63\246\203", "\61\86\152\175\115\61")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) then
					if ((842 < 2003) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\187\20\207\56\216\143\36\248\163\0\216\53\238\150\42\201\173\65\216\53\215\128\54\203\189\62\221\63\212\193\112\145", "\167\201\97\188\80\177\225\67");
					end
				end
				v172 = 6;
			end
			if ((v172 == 0) or (1805 > 4128)) then
				if ((4536 > 3169) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\109\208\68\95\134\87\206\74\114\154\95\206\72\122\129\93\203", "\232\62\160\45\49")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if ((3650 == 3650) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\103\195\252\162\175\125\221\242\147\162\102\210\251\169\158\127\218\246\167\225\112\214\243\173\180\120\199\202\173\174\113\147\167", "\193\20\179\149\204");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\228\17\136\204\217\8\143\197\244\19\128\204\210\42\136\193\220", "\162\183\97\225")]:IsReady() and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\1\204\240\212\19\239\163\38", "\193\73\165\132\151\124\130")]:IsAvailable() and v92() and v13:BuffUp(v60.BonedustBrewBuff)) or (364 >= 3612)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (2338 <= 36)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\210\160\85\184\191\195\197\150\88\164\183\195\199\150\80\191\181\198\130\173\94\176\183\216\206\189\100\183\185\200\130\253", "\214\173\162\201\59\214");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\16\109\184\72\220\37\44\127\190\73\210\23\42\119\174\77\216\50\39", "\64\67\25\202\33\183")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\221\230\100\178\42\215\81\239\231\98\168", "\35\137\142\17\220\78\178")]:IsAvailable())) or (558 >= 3797)) then
					if ((2466 < 4564) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\32\79\61", "\97\77\46\69"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\203\18\172\212\218\63\170\217\224\20\173\218\224\23\172\209\219\12\170\205\219\64\161\218\217\1\176\211\203\63\164\208\218\64\243", "\197\191\191\96");
					end
				end
				v172 = 1;
			end
			if ((v172 == 2) or (4318 >= 4897)) then
				if ((2859 >= 1223) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\235\91\164\130\21\37\155\204\92\156\130\24\41", "\200\185\50\215\235\123\66")]:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(30, 2)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\255\136\215", "\122\146\225\185\130\234\22"), v98, nil, not v14:IsInMeleeRange(5)) or (695 >= 4727)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\235\211\198\225\188\134\241\213\193\208\176\176\225\203\143\235\190\191\227\213\195\251\132\184\237\197\143\190\239", "\219\217\130\160\175\143");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\28\176\67\62\53\179\87\41\21\181\65\54", "\93\94\220\34")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\60\192\192\142\213\224\255\0\208\200\132\221\195\239\10\201\197\153", "\157\111\168\161\234\186\151")]:IsAvailable()) or (1257 >= 4346)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\118\73\123", "\229\27\32\21\81\162\217\210"), v98, nil, not v14:IsInMeleeRange(5)) or (277 >= 3615)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\192\250\57\65\35\217\239\5\65\37\207\240\122\78\41\202\250\47\70\56\243\250\53\79\108\157\173", "\42\76\172\155\90");
					end
				end
				if ((486 == 486) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\208\129\128\42\11\253\152\149\2\9\241\134", "\96\146\237\225\73")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\219\118\9\236\70\109\160\231\102\1\230\78\78\176\237\127\12\251", "\194\136\30\104\136\41\26")]:IsAvailable() and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) then
					if ((4095 >= 694) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\209\223\13", "\79\188\182\99\40\116\208\201"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\127\207\43\66\40\48\104\215\21\74\42\60\118\131\46\68\37\62\104\207\62\126\34\48\120\131\123\25", "\95\29\163\74\33\67");
					end
				end
				v172 = 3;
			end
			if ((4504 == 4504) and (v172 == 1)) then
				if ((4558 > 3813) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\253\33\228\92\84\225\67\205\13\255\79\95\231\67\250\60\227\77\80", "\45\170\73\141\46\56\136")]:IsReady() and (v66 > 8)) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (3920 == 3102)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\150\7\196\247\163\142\9\134\48\201\247\174\128\8\143\48\221\240\161\132\15\193\11\200\227\174\146\11\149\48\204\234\170\199\95", "\103\225\111\173\133\207\231");
					end
				end
				if ((2306 <= 4192) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\106\141\230\65\95\139\243\115\89\150\236", "\53\44\228\149")]:IsReady()) then
					if ((2665 >= 645) and v84.CastTargetIf(v60.FistsofFury, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\192\218\35", "\68\173\187\91\101\171"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\6\1\211\90\189\114\223\195\9\7\213\80\194\121\220\250\14\7\203\93\189\124\214\249\79\67\151", "\185\156\111\114\167\41\226\29");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\56\21\31\46\186\234\5\2\53\50\181\237\14\46\31\35\191", "\131\107\101\118\64\212")]:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff)) or (4374 < 1441)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (1184 > 2471)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\210\198\37\37\73\201\199\198\233\47\57\70\206\204\254\221\37\40\76\128\205\196\208\45\62\75\212\246\192\217\41\107\22\146", "\169\161\182\76\75\39\160");
					end
				end
				v172 = 2;
			end
		end
	end
	local function v120()
		local v173 = 0;
		while true do
			if ((3754 <= 4262) and (5 == v173)) then
				if ((1325 >= 500) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\114\56\78\254\84\168\26\68\31\70\254\84", "\111\48\84\47\157\63\199")]:IsReady() and (v89(v60.BlackoutKick))) then
					if ((720 == 720) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\23\15\142", "\78\122\102\224\199"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\254\20\117\0\63\10\187\235\195\19\125\0\63\69\170\250\250\25\97\15\32\58\250\235\188\76\38", "\159\156\120\20\99\84\101\206");
					end
				end
				break;
			end
			if ((185 == 185) and (v173 == 1)) then
				if ((2284 > 377) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\43\75\95\79\186\30\113\89\72\159\16\65\71", "\212\121\34\44\38")]:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(30, 2)) then
					if ((313 < 397) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\183\179\36", "\62\218\218\74\101\30\205\146"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\160\106\248\211\57\123\60\87\167\70\250\212\61\79\111\70\172\127\240\200\50\80\16\22\189\57\160\141", "\79\34\201\25\145\189\94\36");
					end
				end
				if ((3196 <= 4620) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\98\32\235\9\75\91\85\56\193\3\67\95", "\52\32\76\138\106\32")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\139\242\49\194\117\175\248\63\222\115\182\253\4\212\127\185\254\35", "\26\216\154\80\166")]:IsAvailable() and v89(v60.BlackoutKick) and v13:BuffUp(v60.BlackoutReinforcementBuff)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\193\192\227", "\76\172\169\141\35\29"), v98, nil, not v14:IsInMeleeRange(5)) or (4030 < 3014)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\213\249\0\215\214\237\23\227\210\241\0\215\153\252\6\218\216\237\15\200\230\172\23\156\136\170", "\99\188\185\152");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\225\4\191\0\173\219\26\177\45\177\211\26\179\37\170\209\31", "\195\178\116\214\110")]:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick) and v92()) or (155 > 1408)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (2456 <= 1421)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\231\143\123\207\239\11\240\185\118\211\231\11\242\185\126\200\229\14\183\130\112\199\231\16\251\146\74\149\242\69\166\210", "\134\101\151\230\21\161");
					end
				end
				if ((1118 < 4451) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\155\131\41\93\45\53\211\188\132\17\93\32\57", "\128\201\234\90\52\67\82")]:IsReady() and v13:BuffDown(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\130\68\45\96\217\171\75\24\97\216\189", "\170\196\45\94\20")]:CooldownRemains() > 5)) then
					if ((408 < 802) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\115\77\11", "\80\30\36\101\84\161\64"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\88\10\75\214\60\153\66\12\76\231\48\175\82\18\2\220\62\160\80\12\78\204\4\242\69\89\19\142", "\91\198\49\121\34\184");
					end
				end
				v173 = 2;
			end
			if ((v173 == 2) or (4928 <= 2674)) then
				if ((640 < 2789) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\22\202\118\186\130\59\211\99\146\128\55\205", "\233\84\166\23\217")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\75\112\249\226\57\54\122\119\224\239\56\38\76\106\253\231\50\50", "\65\24\24\152\134\86")]:IsAvailable()) then
					if ((1733 > 1075) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\177\62\230", "\41\220\87\136"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\58\226\243\197\164\48\34\220\251\199\168\46\118\231\245\200\170\48\58\247\207\154\191\101\103\187", "\203\69\86\131\144\174");
					end
				end
				if ((1408 < 2305) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\139\23\64\80\198\87\212\4\183\53\90\90\195", "\113\217\126\51\57\168\48\135")]:IsReady() and (v13:HasTier(30, 2))) then
					if ((3989 >= 1367) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\18\28\56", "\174\127\117\86\40\40\31\22"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\206\50\95\210\210\60\115\200\201\53\115\208\213\56\71\155\216\62\74\218\201\55\88\228\136\47\12\137\140", "\187\188\91\44");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\58\239\110\32\238\37\30\229\115", "\109\127\151\30\69\130")]:IsReady() and (((v13:Chi() == 1) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\224\140\100\17\203\215\129\3\220\174\126\27\206", "\118\178\229\23\120\165\176\210")]:CooldownUp() or v60[LUAOBFUSACTOR_DECRYPT_STR_0("\54\200\94\0\7\170\46\187\17\212\73\62\5\161\37\177\10\206\72", "\221\101\188\44\105\108\207\65")]:CooldownUp())) or ((v13:Chi() == 2) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\112\57\4\182\193\89\54\49\183\192\79", "\178\54\80\119\194")]:CooldownUp()))) or (1995 < 899)) then
					if ((2043 <= 3445) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\23\81\199\227\198\177\195\38\2\1\198\234\255\184\215\56\27\126\150\251\185\235\144", "\162\84\111\33\162\143\153\217");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\20\203\20\132\41\210\19\141\4\201\28\132\34\240\20\137\44", "\234\71\187\125")]:IsReady() and v89(v60.SpinningCraneKick) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\55\53\66\79\237\30\58\119\78\236\8", "\158\113\92\49\59")]:CooldownRemains() > 3) and (v13:BuffStack(v60.ChiEnergyBuff) > 10)) or (1005 > 1078)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (327 > 847)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\96\72\126\240\15\212\0\211\115\83\113\240\3\229\12\229\115\74\48\250\3\220\6\249\124\85\79\170\18\154\85\184", "\103\140\16\33\16\158\102\186");
					end
				end
				v173 = 3;
			end
			if ((3627 > 767) and (v173 == 4)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\102\31\64\67\162\83\81\7\106\73\170\87", "\60\36\115\33\32\201")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3)) or (4760 == 1478)) then
					if ((4755 > 1274) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\186\127\89", "\193\215\22\55\38\44\62\93"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\30\15\204\222\244\58\6\49\196\220\248\36\82\10\202\211\250\58\30\26\240\129\239\111\65\90", "\155\79\114\110\175\181");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\106\65\202\236\184\130\210\114\85\221\225\134\133\219\92", "\181\56\52\185\132\209\236")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or (2212 > 3112)) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8)) or (4059 <= 3833)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\32\89\193\160\76\167\253\13\70\211\172\64\150\237\59\66\214\232\65\172\252\51\89\222\188\122\253\238\114\31\132", "\154\82\44\178\200\37\201");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\70\255\16\4\181\77\122\115\255\10\8\137\65\123\113\231\13\31\186", "\21\21\139\98\109\222\40")]:IsReady() or (1868 <= 1852)) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\9\237\180", "\90\100\140\204\236"), v101, nil, not v14:IsInMeleeRange(9)) or (1402 <= 471)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\0\44\197\188\29\147\27\56\243\163\16\169\43\41\197\185\28\160\27\44\200\247\28\169\18\63\217\187\12\147\64\42\140\228\64", "\120\204\116\94\172\215");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\48\173\177\6\229\171\126\120\32\175\185\6\238\137\121\124\8", "\31\99\221\216\104\139\194\16")]:IsReady() and v89(v60.SpinningCraneKick) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\19\169\249\24\26\236\51\134\255\30\16", "\131\85\192\138\108\105")]:CooldownRemains() > 3) or (v13:Chi() > 4))) or (465 == 1680)) then
					if ((1005 == 1005) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\180\118\13\56\173\113\4\9\167\109\2\56\161\64\8\63\167\116\67\50\161\121\2\35\168\107\60\98\176\63\87\102", "\99\86\196\31");
					end
				end
				v173 = 5;
			end
			if ((777 < 1992) and (v173 == 0)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\102\82\68\26\213\98\90\79\18", "\167\50\59\35\127")]:IsReady() and v89(v60.TigerPalm) and (v13:Chi() < 2) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\110\26\65\248\187\71\21\116\249\186\81", "\200\40\115\50\140")]:CooldownRemains() < 1) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\192\57\101\22\248\40\120\25\231\37\114\40\250\35\115\19\252\63\115", "\127\147\77\23")]:CooldownRemains() < 1)) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) or (1207 >= 4371)) then
					if ((3191 > 1416) and v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\134\239\251", "\16\235\134\149\20"), v96, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\206\66\73\163\30\184\28\219\71\67\230\8\130\10\219\94\66\178\51\211\24\154\25", "\108\186\43\46\198\108\231");
					end
				end
				if ((387 < 702) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\1\175\252\15\114\59\177\242\34\110\51\177\240\42\117\49\180", "\28\82\223\149\97")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v92() and v13:BuffDown(v60.BlackoutReinforcementBuff)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (822 >= 1010)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\190\37\68\80\163\60\67\89\146\54\95\95\163\48\114\85\164\54\70\30\169\48\75\95\184\57\89\97\249\33\13\10", "\62\205\85\45");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\70\24\179\160\9\140\6\115\24\169\172\53\128\7\113\0\174\187\6", "\105\21\108\193\201\98\233")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\116\141\14\240\199\59\200\70\140\8\234", "\186\32\229\123\158\163\94")]:IsAvailable())) or (211 > 1666)) then
					if ((2860 > 2108) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\9\34\105", "\87\100\67\17\170\121\197"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\159\168\137\92\176\209\132\188\191\67\189\235\180\173\137\89\177\226\132\168\132\23\177\235\141\187\149\91\161\209\223\174\192\1", "\213\142\235\218\224\55");
					end
				end
				if ((37 <= 4401) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\46\171\234\209\27\173\255\227\29\176\224", "\165\104\194\153")]:IsReady()) then
					if ((3662 == 3662) and v84.CastTargetIf(v60.FistsofFury, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\138\49\193", "\237\231\80\185\203\153\61"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\163\57\147\102\86\154\63\134\77\67\176\34\153\50\65\160\54\129\103\73\177\15\212\102\5\253", "\37\197\80\224\18");
					end
				end
				v173 = 1;
			end
			if ((v173 == 3) or (2634 >= 3211)) then
				if ((1293 < 1533) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\229\129\188\118\8\51\210\153\150\124\0\55", "\92\167\237\221\21\99")]:IsReady() and v89(v60.BlackoutKick) and v13:HasTier(30, 2)) then
					if ((898 <= 2486) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\242\41\35", "\70\159\64\77"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\213\67\83\252\17\216\90\70\192\17\222\76\89\191\30\210\73\83\234\22\195\112\6\235\90\133\25", "\122\183\47\50\159");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\225\57\174\109\149\208\34\179", "\224\162\81\199\47")]:IsCastable() and (v13:Chi() < 5) and (v13:BloodlustUp() or (v13:Energy() < 50))) or (3201 < 983)) then
					if (v24(v60.ChiBurst, not v14:IsInRange(40), true) or (719 == 4160)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\77\58\2\129\253\87\32\41\195\236\64\53\60\150\228\81\12\105\151\168\23\107", "\227\136\37\83\93");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\106\189\1\122\87\164\6\115\122\191\9\122\92\134\1\119\82", "\20\57\205\104")]:IsReady() and v89(v60.SpinningCraneKick) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\14\162\11\173\9\85\53\14\190\10\160", "\83\72\203\120\217\122\58")]:CooldownRemains() > 3) or (v13:Chi() > 4)) and v92()) or (3973 == 1084)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (2896 == 3545)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\175\249\178\173\161\180\177\187\214\184\177\174\179\186\131\226\178\160\164\253\187\185\239\186\182\163\169\128\232\253\251\240\255", "\223\220\137\219\195\207\221");
					end
				end
				if ((640 == 640) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\36\64\86\240\32\26\70\88\198\62\18\79\80\236\28\6\70\92\234", "\76\115\40\63\130")]:IsReady()) then
					if ((1936 <= 2372) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\144\18\36\191\186\216\137\29\18\169\164\208\128\21\35\146\166\196\137\25\37\237\178\212\129\27\56\161\162\238\211\14\109\254\228", "\177\231\122\77\205\214");
					end
				end
				v173 = 4;
			end
		end
	end
	local function v121()
		local v174 = 0;
		while true do
			if ((v174 == 0) or (660 < 333)) then
				if ((1205 == 1205) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\72\24\139\122\218\113\118\43\113", "\71\28\113\236\31\168\33\23")]:IsReady() and v89(v60.TigerPalm) and (v13:Chi() < 2) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\127\247\48\241\215\222\8\178\67\213\42\251\210", "\199\45\158\67\152\185\185\91")]:CooldownRemains() < 1) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\124\112\174\186\195\25\209\246\79\107\164", "\176\58\25\221\206\176\118\183")]:CooldownRemains() < 1) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\1\5\203\15\229\189\61\23\205\14\235\143\59\31\221\10\225\170\54", "\216\82\113\185\102\142")]:CooldownRemains() < 1)) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) then
					if ((4529 > 3018) and v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\79\82\46", "\29\34\59\64\184"), v96, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\6\23\79\207\39\98\2\31\68\199\117\89\23\24\73\223\57\73\45\77\92\138\103", "\61\114\126\40\170\85");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\255\56\126\55\205\122\194\47\84\43\194\125\201\3\126\58\200", "\19\172\72\23\89\163")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or (3857 >= 4861)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (2748 <= 2487)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\36\76\198\235\59\91\171\48\99\204\247\52\92\160\8\87\198\230\62\18\161\50\90\206\240\57\70\154\100\72\143\177", "\197\87\60\175\133\85\50");
					end
				end
				if ((772 > 258) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\39\106\198\218\31\123\219\213\0\118\209\228\29\112\208\223\27\108\208", "\179\116\30\180")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\223\206\248\143\239\195\255\135\226\213\249", "\225\139\166\141")]:IsAvailable() and v13:HasTier(31, 4)) then
					if ((4045 > 3611) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\64\138\236", "\64\45\235\148"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\101\69\40\235\87\208\73\94\60\221\72\221\115\110\45\235\82\209\122\94\40\230\28\209\115\87\59\247\80\193\73\2\46\162\10", "\181\22\49\90\130\60");
					end
				end
				if ((4933 >= 4436) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\60\197\170\0\4\212\183\15\27\217\189\62\6\223\188\5\0\195\188", "\105\111\177\216")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\128\18\221\28\20\214\166\28\193\1\4", "\179\212\122\168\114\112")]:IsAvailable() and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\80\116\146\194\114\127\188\216\124\116\176\197\124\77\140\196\109\127\176\196\126\127\150", "\173\25\26\228")]:CooldownRemains() > 20) or (v68 < 5))) then
					if ((2686 <= 3829) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\27\119\209", "\120\118\22\169\218"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\212\52\164\239\204\37\137\233\193\31\162\238\194\31\161\239\201\36\186\233\213\36\246\226\194\38\183\243\203\52\137\181\211\96\238", "\134\167\64\214");
					end
				end
				v174 = 1;
			end
			if ((v174 == 5) or (484 >= 2707)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\113\238\221\26\113\92\247\200\50\115\80\233", "\26\51\130\188\121")]:IsReady() and v89(v60.BlackoutKick) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\206\139\63\13\90\17\241\127\253\144\53", "\57\136\226\76\121\41\126\151")]:CooldownDown()) or (3880 <= 6)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\47\222\7", "\29\66\183\105\51\68\131"), v98, nil, not v14:IsInMeleeRange(5)) or (2248 < 2159)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\71\41\72\205\78\42\92\218\122\46\64\205\78\101\77\203\67\36\92\194\81\26\26\218\5\113\27", "\174\37\69\41");
					end
				end
				if ((3085 < 4311) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\179\163\93\6\25\143\177\100\15\20\132\129\71\0\20", "\112\225\214\46\110")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8)) or (39 > 3367)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\12\49\48\83\237\179\235\33\46\34\95\225\130\251\23\42\39\27\224\184\234\31\49\47\79\219\238\248\94\112\119", "\140\126\68\67\59\132\221");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\160\125\6\72\70\16\147\150\90\14\72\70", "\230\226\17\103\43\45\127")]:IsReady() and v89(v60.BlackoutKick) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\227\68\197\79\136\199\78\203\83\142\222\75\240\89\130\209\72\215", "\231\176\44\164\43")]:IsAvailable() and not v92()) or (2325 < 1039)) then
					if ((4789 == 4789) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\172\207\42", "\236\193\166\68\201\206"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\6\55\201\114\15\52\221\101\59\48\193\114\15\123\204\116\2\58\221\125\16\4\155\101\68\111\158", "\17\100\91\168");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\105\182\133\226\189\42\117\93\133\158\237\189\38\80\83\165\135", "\27\58\198\236\140\211\67")]:IsReady() and v89(v60.SpinningCraneKick) and (((v13:Chi() > 5) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\18\217\195\88\132\206\32\223\216\66\168\229\37\235\197\88\140", "\139\65\173\172\42\233")]:IsAvailable()) or ((v13:Chi() > 4) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\180\83\99\221\202\126\244\81", "\40\231\54\17\184\164\23\128")]:IsAvailable()))) or (188 >= 2969)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (4094 < 2583)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\217\118\246\139\227\138\206\64\251\151\235\138\204\64\243\140\233\143\137\123\253\131\235\145\197\107\199\214\254\196\157\39", "\138\228\169\31\152\229");
					end
				end
				break;
			end
			if ((2513 <= 3001) and (v174 == 4)) then
				if ((2125 <= 2528) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\77\43\225\20\112\50\230\29\93\41\233\20\123\16\225\25\117", "\122\30\91\136")]:IsReady() and v89(v60.SpinningCraneKick) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\153\173\246\164\158\176\162\195\165\159\166", "\237\223\196\133\208")]:CooldownRemains() < 3) and (v13:BuffStack(v60.ChiEnergyBuff) > 15)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (4018 <= 3670)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\207\24\202\176\80\243\210\15\252\189\76\251\210\13\252\181\87\249\215\72\199\187\88\251\201\4\215\129\13\238\156\91\149", "\154\188\104\163\222\62");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\7\228\62\242\30\72\241\32\227\6\242\19\68", "\162\85\141\77\155\112\47")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\52\32\181\90\1\38\160\104\7\59\191", "\46\114\73\198")]:CooldownRemains() > 4) and (v13:Chi() > 3)) or (3332 < 2926)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\168\119\120", "\42\197\30\22\143\78"), v98, nil, not v14:IsInMeleeRange(5)) or (1262 == 4623)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\97\76\76\54\125\66\96\44\102\75\96\52\122\70\84\127\119\64\89\62\102\73\75\0\32\81\31\108\43", "\95\19\37\63");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\83\32\166\255\122\8\100\56\140\245\114\12", "\103\17\76\199\156\17")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3)) or (2791 <= 1075)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\190\35\139", "\154\211\74\229\136\60\112\217"), v98, nil, not v14:IsInMeleeRange(5)) or (1876 == 980)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\16\235\206\14\72\186\8\213\198\12\68\164\92\238\200\3\70\186\16\254\242\86\83\239\79\190", "\39\207\124\138\173\101");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\253\17\74\206\172\199\15\68\227\176\207\15\70\235\171\205\10", "\194\174\97\35\160")]:IsReady() and v89(v60.SpinningCraneKick) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\205\41\46\11\241\39\14\23\241\11\52\1\244", "\98\159\64\93")]:CooldownDown() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\40\184\62\11\2\9\93\2\27\163\52", "\68\110\209\77\127\113\102\59")]:CooldownDown() and (v13:Chi() > 4) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\157\240\168\93\14\230\175\188\240\175\110\13\199\136\167\246\162", "\206\206\132\199\47\99\163")]:IsAvailable() and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\212\205\217\119\85\227\209\195\80\67\243\213", "\49\150\162\183\18")]:IsAvailable()) or v60[LUAOBFUSACTOR_DECRYPT_STR_0("\122\47\169\36\20\233\12\80", "\120\41\74\219\65\122\128")]:IsAvailable())) or (4954 <= 2967)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (3342 < 2369)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\22\85\20\235\174\219\93\57\95\8\228\169\208\101\13\85\25\238\231\209\95\0\93\15\233\179\234\9\18\28\78\181", "\181\58\102\60\122\133\199");
					end
				end
				v174 = 5;
			end
			if ((v174 == 1) or (1484 > 1739)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\38\133\255\139\194\199\17\157\213\129\202\195", "\168\100\233\158\232\169")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\65\92\24\248\125\67\27\243\106\93\23\251\70\70\28\253\118\71", "\156\18\52\121")]:IsAvailable()) or (494 == 1798)) then
					if ((949 < 1030) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\78\25\213", "\191\35\112\187\170\228\213\101"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\163\125\86\53\19\106\172\144\119\92\61\23\63\188\170\122\84\43\16\107\135\252\104\21\111\76", "\31\216\207\28\53\94\124");
					end
				end
				if ((2029 == 2029) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\7\46\184\27\72\46\33\141\26\73\56", "\59\65\71\203\111")]:IsReady()) then
					if ((2919 == 2919) and v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\26\161\100", "\84\119\192\28\20\235\108"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\138\247\55\226\9\3\166\71\179\248\49\228\3\124\173\68\138\255\49\250\14\3\250\85\204\175\118", "\33\236\158\68\150\122\92\201");
					end
				end
				if ((3131 >= 2468) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\210\209\234\16\71\246\10\245\214\210\16\74\250", "\89\128\184\153\121\41\145")]:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(30, 2)) then
					if ((858 > 580) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\225\60\170", "\91\140\85\196\225\66\231\96"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\177\164\184\69\52\135\164\164\69\12\179\190\178\64\115\188\178\183\74\38\180\163\142\24\39\248\230\229", "\43\83\216\215\209");
					end
				end
				if ((4607 > 2342) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\120\183\185\5\32\66\169\183\40\60\74\169\181\32\39\72\172", "\78\43\199\208\107")]:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick)) then
					if ((67 <= 3820) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\97\152\9\16\181\51\203\209\77\139\18\31\181\63\250\221\123\139\11\94\191\63\195\215\103\132\20\33\232\46\133\135\36", "\182\18\232\96\126\219\90\165");
					end
				end
				v174 = 2;
			end
			if ((1333 < 3026) and (v174 == 2)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\15\87\52\161\51\89\20\189\51\117\46\171\54", "\200\93\62\71")]:IsReady() and v13:BuffDown(v60.BonedustBrewBuff) and v13:BuffUp(v60.PressurePointBuff)) or (2286 < 679)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\75\68\64", "\110\38\45\46\186\164\210"), v98, nil, not v14:IsInMeleeRange(5)) or (197 >= 4502)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\106\183\187\31\48\127\129\187\3\48\71\181\161\21\53\56\186\173\16\63\109\178\188\41\109\108\254\249\78", "\94\24\222\200\118");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\47\201\53\16\19\199\21\12\19\235\47\26\22", "\121\125\160\70")]:IsReady() and (v13:HasTier(30, 2))) or (2082 >= 2140)) then
					if ((1869 < 2377) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\254\227\53", "\210\147\138\91"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\244\219\66\62\20\10\238\221\69\15\24\60\254\195\11\52\22\51\252\221\71\36\44\102\233\136\25\96", "\115\85\157\168\43\80");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\218\66\151\82\128\225\71\219\242", "\169\159\58\231\55\236\169\38")]:IsReady() and (((v13:Chi() == 1) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\35\200\172\25\202\19\79\4\207\148\25\199\31", "\28\113\161\223\112\164\116")]:CooldownUp() or v60[LUAOBFUSACTOR_DECRYPT_STR_0("\245\76\85\112\80\195\87\65\109\83\195\111\78\119\95\202\87\85\125", "\59\166\56\39\25")]:CooldownUp())) or ((v13:Chi() == 2) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\148\209\213\220\80\189\222\224\221\81\171", "\35\210\184\166\168")]:CooldownUp()))) or (3173 == 2689)) then
					if ((4874 == 4874) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\65\109\71\40\72\81\88\111\79\100\115\92\95\124\87\40\99\102\10\105\2\118\37", "\23\57\57\29\34\68");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\114\61\30\47\91\62\10\56\123\56\28\39", "\76\48\81\127")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 2)) or (258 == 234)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\3\172\95", "\48\110\197\49\215\106\20\189"), v98, nil, not v14:IsInMeleeRange(5)) or (4869 < 1586)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\30\73\175\203\36\83\24\34\25\65\175\203\107\66\9\27\19\93\160\212\20\21\24\93\64\28", "\108\125\114\40\204\160\75\38");
					end
				end
				v174 = 3;
			end
			if ((1603 <= 3047) and (v174 == 3)) then
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\6\100\237\4\62\117\240\11\33\120\250\58\60\126\251\1\58\98\251", "\109\85\16\159")]:IsReady() or (5 > 2024)) then
					if ((1248 < 2910) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\42\242\181", "\208\71\147\205\59\123\56"), v101, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\52\150\177\92\37\187\183\81\31\144\176\82\31\147\177\89\36\136\183\69\36\196\188\82\38\133\173\91\52\187\235\67\96\214\238", "\216\55\64\228");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\157\132\63\193\178\250\254\171\163\55\193\178", "\139\223\232\94\162\217\149")]:IsReady() and v13:BuffUp(v60.TeachingsoftheMonasteryBuff) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\230\139\34\245\180\66\200\218\155\42\255\188\97\216\208\130\39\226", "\170\181\227\67\145\219\53")]:IsAvailable() or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\107\140\13\187\87\130\45\167\87\174\23\177\82", "\210\57\229\126")]:CooldownRemains() > 1))) or (2806 < 956)) then
					if ((3203 <= 3695) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\181\58\228", "\227\216\83\138\198\82\165"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\41\185\183\123\249\36\160\162\71\249\34\182\189\56\246\46\179\183\109\254\63\138\229\108\178\121\237", "\146\75\213\214\24");
					end
				end
				if ((970 > 658) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\125\118\200\86\118\76\91\77\90\211\69\125\74\91\122\107\207\71\114", "\53\42\30\161\36\26\37")]:IsReady()) then
					if ((3272 < 4703) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\241\254\242\241\240\249\231\194\253\229\225\250\246\249\223\237\236\249\227\245\185\243\229\251\248\226\236\233\198\164\244\189\170\167", "\128\157\153\151");
					end
				end
				if ((2573 >= 528) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\85\125\133\11\0\97\101\97", "\19\22\21\236\73\117")]:IsCastable() and (v13:Chi() < 5) and (v13:BloodlustUp() or (v13:Energy() < 50))) then
					if (v24(v60.ChiBurst, not v14:IsInRange(40), true) or (1122 > 2845)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\116\205\171\150\245\168\63\229\99\133\166\172\241\188\56\250\99\250\241\189\183\238\127", "\150\23\165\194\201\151\221\77");
					end
				end
				v174 = 4;
			end
		end
	end
	local function v122()
		local v175 = 0;
		while true do
			if ((3458 >= 1138) and (v175 == 7)) then
				if ((4331 == 4331) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\20\42\92\40\18\45\199\12\62\75\37\44\42\206\34", "\160\70\95\47\64\123\67")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) then
					if ((3095 > 36) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\79\103\57\215\84\115\14\212\91\112\52\225\77\125\63\218\26\112\52\216\91\97\61\202\101\38\37\158\14\32", "\81\190\58\20");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\127\93\191\121\141\32\81\52\111\95\183\121\134\2\86\48\71", "\83\44\45\214\23\227\73\63")]:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick) and (v91() >= 2.7)) or (1544 < 705)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (3010 == 4413)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\230\170\79\176\46\252\180\65\129\35\231\187\72\187\31\254\179\69\181\96\241\191\64\191\53\249\174\121\236\52\181\238\16", "\64\149\218\38\222");
					end
				end
				if ((4020 > 1946) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\40\174\217\217\20\160\249\197\20\140\195\211\17", "\176\122\199\170")]:IsReady()) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\31\2\190", "\75\114\107\208\176\81"), v95, nil, not v14:IsInMeleeRange(5)) or (4637 == 2109)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\34\58\124\247\44\22\102\236\37\22\126\240\40\34\53\253\46\47\116\236\39\61\74\171\63\105\33\161", "\21\153\75\73");
					end
				end
				v175 = 8;
			end
			if ((3190 >= 2633) and (v175 == 4)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\17\57\22\166\56\58\2\177\24\60\20\174", "\197\83\85\119")]:IsReady() and v13:BuffUp(v60.PressurePointBuff) and (v13:Chi() > 2) and v13:PrevGCD(1, v60.RisingSunKick)) or (2810 >= 3580)) then
					if ((2245 < 4315) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\66\243\16", "\87\47\154\126"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\41\116\205\216\217\219\62\108\243\208\219\215\32\56\200\222\212\213\62\116\216\228\128\192\107\42\154", "\180\75\24\172\187\178");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\240\201\236\13\114\45\247\23\224\203\228\13\121\15\240\19\200", "\112\163\185\133\99\28\68\153")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or (2259 > 4906)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (3041 <= 2326)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\184\68\245\197\165\93\242\204\148\87\238\202\165\81\195\192\162\87\247\139\175\81\250\202\190\88\232\244\249\64\188\153\243", "\171\203\52\156");
					end
				end
				if ((3981 > 1765) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\153\194\116\147\63\147\174\180", "\192\218\170\29\209\74\225\221")]:IsCastable() and (v13:Chi() < 5) and (v13:Energy() < 50)) then
					if (v24(v60.ChiBurst, not v14:IsInRange(40), true) or (377 >= 953)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\128\212\82\63\205\88\59\238\151\156\95\5\201\76\60\241\151\227\9\20\143\30\121", "\157\227\188\59\96\175\45\73");
					end
				end
				v175 = 5;
			end
			if ((v175 == 8) or (3030 <= 1705)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\43\31\76\241\185\73\28\7\102\251\177\77", "\38\105\115\45\146\210")]:IsReady() and (v89(v60.BlackoutKick))) or (353 > 4033)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\15\31\2", "\83\98\118\108\22"), v98, nil, not v14:IsInMeleeRange(5)) or (1442 < 308)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\231\120\46\174\139\54\93\212\114\36\166\143\99\77\238\127\44\176\136\55\118\185\109\109\240\212", "\67\41\139\25\77\197\228");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\206\175\203\38\95\230\237\157\218\37\91\248", "\136\136\206\174\74\54")]:IsCastable() and (v89(v60.FaelineStomp))) or (2884 <= 1305)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (2729 <= 2117)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\242\131\137\90\170\190\27\224\146\138\94\180\251\32\246\128\132\70\168\175\27\161\146\197\6\246", "\219\68\147\230\229\51\196");
					end
				end
				break;
			end
			if ((v175 == 5) or (2751 >= 3363)) then
				if ((722 < 3291) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\140\222\197\31\58\186\197\209\2\57\186\253\222\24\53\179\197\197\18", "\81\223\170\183\118")]:IsReady()) then
					if (v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\43\64\180", "\113\70\33\204\219\153\82"), v101, nil, not v14:IsInMeleeRange(9)) or (2290 <= 1449)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\150\45\53\245\181\206\141\57\3\234\184\244\189\40\53\240\180\253\141\45\56\190\180\244\132\62\41\242\164\206\208\43\124\173\226", "\208\145\226\95\92\158");
					end
				end
				if ((3584 >= 2525) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\156\237\220\79\228\250\186\12\149\232\222\71", "\120\222\129\189\44\143\149\207")]:IsReady() and v13:BuffUp(v60.TeachingsoftheMonasteryBuff) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\183\25\28\181\197\92\123\183\156\24\19\182\254\89\124\185\128\2", "\216\228\113\125\209\170\43\25")]:IsAvailable() or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\203\243\75\76\124\121\202\239\86\110\123\125\242", "\30\153\154\56\37\18")]:CooldownRemains() > 1))) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\16\176\249", "\91\125\217\151\108"), v98, nil, not v14:IsInMeleeRange(5)) or (606 >= 4055)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\31\167\115\213\246\6\178\79\213\240\16\173\48\218\252\21\167\101\210\237\44\244\100\158\170\71", "\190\153\115\198\16");
					end
				end
				if ((4239 >= 420) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\13\115\163\149\54\114\164\128\30\105\171\128\53\117\154\146\52\120\162", "\231\90\27\202")]:IsReady()) then
					if ((758 == 758) and v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\150\140\81\176\82\136\138\95\157\90\147\133\95\173\80\190\148\77\172\93\137\196\92\167\88\128\145\84\182\97\211\144\24\241\8", "\62\225\228\56\194");
					end
				end
				v175 = 6;
			end
			if ((v175 == 3) or (3953 < 851)) then
				if ((734 <= 743) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\124\172\22\90\143\115\88\166\11", "\59\57\212\102\63\227")]:IsReady() and (((v13:Chi() == 1) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\79\225\108\14\115\239\76\18\115\195\118\4\118", "\103\29\136\31")]:CooldownUp() or v60[LUAOBFUSACTOR_DECRYPT_STR_0("\45\58\200\35\77\27\33\220\62\78\27\25\211\36\66\18\33\200\46", "\38\126\78\186\74")]:CooldownUp())) or ((v13:Chi() == 2) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\231\73\57\158\84\139\199\102\63\152\94", "\228\161\32\74\234\39")]:CooldownUp()))) then
					if ((4997 > 619) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\156\26\176\252\190\60\129\44\137\74\177\245\135\53\149\50\144\53\231\228\193\102\208", "\224\94\228\106\213\144\225\84");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\147\224\78\226\20\162\251\83", "\97\208\136\39\160")]:IsCastable() and v13:BloodlustUp() and (v13:Chi() < 5)) or (3187 <= 2682)) then
					if ((2981 < 4649) and v24(v60.ChiBurst, not v14:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\33\202\185\91\7\41\229\61\131\130\92\20\58\227\37\215\185\11\6\123\164\123", "\91\150\73\163\230\57\114");
					end
				end
				if ((3747 == 3747) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\108\161\179\85\251\4\171\75\101\164\177\93", "\63\46\205\210\54\144\107\222")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 2)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\253\37\250", "\188\144\76\148\39"), v98, nil, not v14:IsInMeleeRange(5)) or (3544 < 1439)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\71\116\167\71\3\55\65\186\64\124\167\71\76\38\80\131\74\96\168\88\51\112\65\197\25\33", "\53\229\43\21\196\44\108\66");
					end
				end
				v175 = 4;
			end
			if ((1791 < 1989) and (v175 == 1)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\63\166\246\40\252\9\189\226\53\255\9\133\237\47\243\0\189\246\37", "\151\108\210\132\65")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\236\92\28\70\194\68\213\82\209\71\29", "\52\184\52\105\40\166\33\167")]:IsAvailable() and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\123\0\219\167\49\209\244\71\11\195\156\50\209\251\90\7\217\173\14\221\203\87\28", "\172\50\110\173\200\90\180")]:CooldownRemains() > 20) or (v68 < 5))) or (571 <= 22)) then
					if ((2020 < 4808) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\246\187\236", "\44\155\218\148"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\254\239\62\50\223\34\142\226\253\19\47\220\34\142\250\242\34\63\216\40\163\233\187\40\62\210\38\164\225\239\19\105\192\103\233", "\209\141\155\76\91\180\71");
					end
				end
				if ((855 > 433) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\213\116\204\95\9\252\123\249\94\8\234", "\122\147\29\191\43")]:IsReady() and not v13:HasTier(30, 2)) then
					if (v84.CastTargetIf(v60.FistsofFury, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\177\209\70", "\30\220\176\62\105\186\159\236"), v101, nil, not v14:IsInMeleeRange(8)) or (560 > 1553)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\142\212\150\164\37\234\184\187\183\219\144\162\47\149\179\184\142\220\144\188\34\234\229\169\200\140\213", "\221\232\189\229\208\86\181\215");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\62\189\231\213\32\11\135\225\210\5\5\183\255", "\78\108\212\148\188")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\29\25\7\54\255\15\189\28\46\2\13", "\90\91\112\116\66\140\96\219")]:CooldownUp())) or (2743 > 3621)) then
					if (v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(5)) or (2083 >= 2879)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\94\25\5\238\175\59\214\66\4\51\235\161\7\206\23\14\9\230\169\17\201\67\53\94\244\232\85\151", "\100\165\55\106\108\128\200");
					end
				end
				v175 = 2;
			end
			if ((v175 == 6) or (1686 <= 864)) then
				if ((1984 >= 1602) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\36\176\170\36\122\82\37\172\183\6\125\86\29", "\53\118\217\217\77\20")]:IsReady() and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\154\23\229\218\32\190\29\235\198\38\167\24\208\204\42\168\27\247", "\79\201\127\132\190")]:IsAvailable() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\14\29\250\221\59\27\239\239\61\6\240", "\169\72\116\137")]:CooldownRemains() > 4) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\65\111\204\168\106\88\200\178\109\118\204\161\124\123\219", "\198\25\26\169")]:IsAvailable()) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\68\122\211", "\31\41\19\189\70\231\49\27"), v98, nil, not v14:IsInMeleeRange(5)) or (3345 > 4014)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\218\66\239\185\212\110\245\162\221\110\237\190\208\90\166\179\214\87\231\162\223\69\217\229\199\17\178\231", "\134\215\179\49");
					end
				end
				if ((4227 >= 1548) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\195\248\87\229\94\28\244\224\125\239\86\24", "\115\129\148\54\134\53")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3)) then
					if ((3719 >= 2635) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\228\142\94", "\115\137\231\48\43\184\104"), v98, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\229\27\224\162\175\42\205\214\17\234\170\171\127\221\236\28\226\188\172\43\230\187\14\163\250\248", "\95\185\137\122\131\201\192");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\84\58\198\16\46\121\35\211\56\44\117\61", "\69\22\86\167\115")]:IsReady() and v89(v60.BlackoutKick) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\106\141\84\136\75\32\107\145\73\170\76\36\83", "\71\56\228\39\225\37")]:CooldownDown() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\150\232\247\61\233\226\36\150\244\246\48", "\66\208\129\132\73\154\141")]:CooldownDown() and (v13:BuffDown(v60.BonedustBrewBuff) or (v91() < 1.5))) or (2008 == 2775)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\71\86\216", "\157\42\63\182"), v98, nil, not v14:IsInMeleeRange(5)) or (358 == 4160)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\217\50\40\255\196\212\43\61\195\196\210\61\34\188\203\222\56\40\233\195\207\1\123\232\143\143\108", "\175\187\94\73\156");
					end
				end
				v175 = 7;
			end
			if ((1075 == 1075) and (v175 == 2)) then
				if ((4595 >= 1488) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\227\194\34\167\214\196\55\149\208\217\40", "\211\165\171\81")]:IsReady()) then
					if ((1545 < 4230) and v84.CastTargetIf(v60.FistsofFury, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\9\116\202", "\188\100\21\178\170\183"), v101, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\120\30\67\167\161\242\113\17\111\181\167\223\103\87\84\182\180\204\107\27\68\140\224\217\62\70\4", "\173\30\119\48\211\210");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\105\208\42\51\85\222\10\47\85\242\48\57\80", "\90\59\185\89")]:IsReady() and (v13:HasTier(30, 2))) or (2602 == 1441)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\77\249\84", "\29\32\144\58\47\91"), v98, nil, not v14:IsInMeleeRange(5)) or (3198 > 4629)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\60\98\180\79\166\44\38\100\179\126\170\26\54\122\253\69\164\21\52\100\177\85\158\65\33\49\236\23", "\193\115\85\17\221\33");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\223\114\29\23\161\219\222\110\0\53\166\223\230", "\188\141\27\110\126\207")]:IsReady() and (v13:BuffUp(v60.KicksofFlowingMomentumBuff) or v13:BuffUp(v60.PressurePointBuff))) or (2538 > 2967)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\128\63\80", "\105\237\86\62\23\132\136"), v98, nil, not v14:IsInMeleeRange(5)) or (4690 <= 3277)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\64\47\68\45\26\134\90\41\67\28\22\176\74\55\13\39\24\191\72\41\65\55\34\235\93\124\28\123", "\125\217\41\92\45\67");
					end
				end
				v175 = 3;
			end
			if ((0 == v175) or (879 >= 2209)) then
				if ((3846 >= 995) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\248\5\69\48\242\243\205\0\79", "\163\172\108\34\85\128")]:IsReady() and v89(v60.TigerPalm) and (v13:Chi() < 2) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\21\24\228\142\213\67\187\65\41\58\254\132\208", "\52\71\113\151\231\187\36\232")]:CooldownRemains() < 1) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\80\132\107\185\101\130\126\139\99\159\97", "\205\22\237\24")]:CooldownRemains() < 1) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\141\108\97\193\50\187\119\117\220\49\187\79\122\198\61\178\119\97\204", "\89\222\24\19\168")]:CooldownRemains() < 1)) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) then
					if (v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\248\80\93", "\113\149\57\51\215"), v96, nil, not v14:IsInMeleeRange(5)) or (568 >= 1676)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\109\121\204\179\240\255\105\113\199\187\162\196\124\118\202\163\238\212\70\34\223\246\176", "\160\25\16\171\214\130");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\83\212\54\126\118\221\158\101\243\62\126\118", "\235\17\184\87\29\29\178")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\153\161\120\252\255\189\171\118\224\249\164\174\77\234\245\171\173\106", "\144\202\201\25\152")]:IsAvailable()) or (1064 > 3552)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\52\210\10", "\96\89\187\100\30\155\42\135"), v98, nil, not v14:IsInMeleeRange(5)) or (1889 >= 3459)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\193\2\73\113\114\56\217\60\65\115\126\38\141\7\79\124\124\56\193\23\117\40\105\109\153", "\29\77\173\99\42\26");
					end
				end
				if ((1805 < 1854) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\183\246\21\115\80\234\248\11\144\234\2\77\82\225\243\1\139\240\3", "\109\228\130\103\26\59\143\151")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\183\112\187\215\58\79\61\130\138\107\186", "\228\227\24\206\185\94\42\79")]:IsAvailable() and v13:HasTier(31, 4)) then
					if ((2648 > 1724) and v84.CastTargetIf(v60.StrikeoftheWindlord, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\195\35\47", "\80\174\66\87\200\212\123"), v101, nil, not v14:IsInMeleeRange(9))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\109\44\193\252\22\244\118\56\247\227\27\206\70\41\193\249\23\199\118\44\204\183\23\206\127\63\221\251\7\244\43\42\136\161", "\115\171\25\94\168\151");
					end
				end
				v175 = 1;
			end
		end
	end
	local function v123()
		local v176 = 0;
		while true do
			if ((4 == v176) or (2540 < 802)) then
				if ((4986 >= 4496) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\115\197\136\206\90\66\222\149", "\47\48\173\225\140")]:IsCastable() and v13:BloodlustUp() and (v13:Chi() < 5)) then
					if (v24(v60.ChiBurst, not v14:IsInRange(40), true) or (949 >= 4471)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\64\197\136\231\41\185\81\222\149\152\47\169\69\204\148\212\63\147\80\217\193\139\127", "\204\35\173\225\184\75");
					end
				end
				if ((1415 == 1415) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\204\72\226\142\237\169\27\250\111\234\142\237", "\110\142\36\131\237\134\198")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 2) and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > 1)) then
					if ((4619 > 4204) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\121\76\178\243\51\116\85\167\207\51\114\67\184\176\60\126\70\178\229\52\111\127\160\228\120\40\22", "\88\27\32\211\144");
					end
				end
				if ((1024 <= 4952) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\174\163\183\30\222\191\72\100", "\16\237\203\222\92\171\205\59")]:IsCastable() and (v13:Chi() < 5) and (v13:Energy() < 50)) then
					if ((1061 >= 1013) and v24(v60.ChiBurst, not v14:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\185\180\183\29\166\243\162\169\200\27\182\231\176\168\132\11\140\242\165\253\219\71", "\211\129\209\221\232\127");
					end
				end
				if ((2936 < 4630) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\58\91\84\45\247\24\191\64\29\71\67\19\245\19\180\74\6\93\66", "\38\105\47\38\68\156\125\208")]:IsReady() and ((v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > 30) or (v68 < 5))) then
					if (v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9)) or (2868 <= 857)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\159\148\183\77\247\45\179\143\163\123\232\32\137\191\178\77\242\44\128\143\183\64\188\44\137\134\164\81\240\60\179\147\177\4\168\120", "\72\236\224\197\36\156");
					end
				end
				v176 = 5;
			end
			if ((v176 == 2) or (4317 < 717)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\145\174\41\161\172\183\46\168\129\172\33\161\167\149\41\172\169", "\207\194\222\64")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and v13:HasTier(31, 2) and v13:BuffDown(v60.BlackoutReinforcementBuff)) or (447 >= 2104)) then
					if ((4534 >= 1789) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\101\222\78\134\218\21\114\232\67\154\210\21\112\232\75\129\208\16\53\211\69\142\210\14\121\195\127\155\199\91\36\143", "\179\123\21\183\32\232");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\244\42\223\52\189\5\245\54\194\22\186\1\205", "\98\166\67\172\93\211")]:IsReady() and (v13:BuffUp(v60.KicksofFlowingMomentumBuff) or v13:BuffUp(v60.PressurePointBuff) or (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > 55))) or (232 == 2860)) then
					if (v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(5)) or (2831 > 3110)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\234\196\220\12\77\221\244\246\217\234\9\67\225\236\163\211\208\4\75\247\235\247\232\198\22\10\176\183", "\130\135\131\183\181\98\42");
					end
				end
				if ((1310 < 2684) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\225\186\58\224\43\204\163\47\200\41\192\189", "\64\163\214\91\131")]:IsReady() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3)) then
					if ((1101 <= 1232) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\35\25\53\52\30\58\12\9\52\24\44\19\118\59\20\41\25\35\51\5\16\11\34\127\67\125", "\95\113\79\120\86");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\153\253\51\185\136\10\12\220\165\223\41\179\141", "\169\203\148\64\208\230\109\95")]:IsReady() or (3929 > 4763)) then
					if (v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(5)) or (1583 <= 1363)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\218\30\21\187\36\28\3\245\221\25\57\185\35\24\55\166\204\18\0\179\63\23\40\217\219\3\70\224\126", "\134\168\119\102\210\74\123\92");
					end
				end
				v176 = 3;
			end
			if ((v176 == 5) or (1148 >= 4399)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\247\187\77\132\202\162\74\141\231\185\69\132\193\128\77\137\207", "\234\164\203\36")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and not v13:HasTier(31, 2)) or (4758 == 987)) then
					if ((3320 < 4248) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\253\137\44\130\87\127\117\52\238\146\35\130\91\78\121\2\238\139\98\136\91\119\115\30\225\148\29\159\74\49\38\89", "\18\107\141\224\66\236\62\17");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\137\163\29\244\160\160\9\227\128\166\31\252", "\151\203\207\124")]:IsReady() and v13:BuffUp(v60.TeachingsoftheMonasteryBuff) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\230\19\226\11\238\142\45\209\218\49\248\1\235", "\164\180\122\145\98\128\233\126")]:CooldownRemains() > 1)) or (3302 < 2389)) then
					if ((4405 > 1302) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\185\8\26\206\176\11\14\217\132\15\18\206\176\68\31\200\189\5\14\193\175\59\8\217\251\80\79", "\173\219\100\123");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\135\56\69\5\29\189\38\75\40\1\181\38\73\32\26\183\35", "\115\212\72\44\107")]:IsReady() and v13:BuffUp(v60.BonedustBrewBuff) and v89(v60.SpinningCraneKick) and (v91() >= 2.7)) or (3043 <= 53)) then
					if ((3894 == 3894) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\159\255\93\124\243\39\160\67\179\236\70\115\243\43\145\79\133\236\95\50\249\43\168\69\153\227\64\77\238\58\238\16\218", "\36\236\143\52\18\157\78\206");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\103\73\49\93\243\89\79\63\107\237\81\70\55\65\207\69\79\59\71", "\159\48\33\88\47")]:IsReady() or (1894 <= 1016)) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (3599 > 3904)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\74\16\224\191\232\57\48\32\70\11\243\180\238\57\8\15\87\23\241\187\161\51\50\25\67\12\254\167\222\36\35\95\22\65", "\87\127\34\121\146\211\129\87");
					end
				end
				v176 = 6;
			end
			if ((1602 <= 2745) and (v176 == 3)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\137\2\29\90\160\1\9\77\128\7\31\82", "\57\203\110\124")]:IsReady() and v13:BuffUp(v60.BlackoutReinforcementBuff) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\156\218\6\32\14\169\224\0\39\43\167\208\30", "\96\206\179\117\73")]:CooldownDown() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\178\55\101\44\138\38\120\35\149\43\114\18\136\45\115\41\142\49\115", "\69\225\67\23")]:CooldownDown() and v89(v60.BlackoutKick) and v13:BuffUp(v60.DanceofChijiBuff)) or (2487 >= 4173)) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5)) or (3815 >= 4154)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\198\141\50\182\215\140\204\111\251\138\58\182\215\195\221\126\194\128\38\185\200\188\202\111\132\211\101", "\27\164\225\83\213\188\227\185");
					end
				end
				if ((4448 > 3260) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\174\6\145\234\212\135\9\164\235\213\145", "\167\232\111\226\158")]:IsReady()) then
					if (v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(8)) or (2918 > 3141)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\66\45\60\12\8\98\255\183\123\34\58\10\2\29\244\180\66\37\58\20\15\98\227\165\4\118\119", "\209\36\68\79\120\123\61\144");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\110\237\82\56\11\67\244\71\16\9\79\234", "\96\44\129\51\91")]:IsReady() and v13:BuffUp(v60.BlackoutReinforcementBuff) and v89(v60.BlackoutKick)) or (4779 == 4357)) then
					if ((2098 == 2098) and v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\3\13\165\248\231\230\1\48\7\175\240\227\179\17\10\10\167\230\228\231\42\28\24\230\160\184", "\147\117\111\108\198\147\136");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\61\190\203\70\6\191\204\83\46\164\195\83\5\184\242\65\4\181\202", "\52\106\214\162")]:IsReady() and (v13:BuffDown(v60.PressurePointBuff))) or (3237 == 4615)) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (3671 <= 1920)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\7\215\182\253\12\1\217\155\245\23\14\217\171\255\58\31\203\170\242\13\79\218\161\247\4\26\210\176\206\22\27\158\247\163", "\145\101\111\190\196");
					end
				end
				v176 = 4;
			end
			if ((2281 < 4127) and (1 == v176)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\237\254\179\10\216\248\166\56\222\229\185", "\126\171\151\192")]:IsReady() and v13:BuffDown(v60.PressurePointBuff) and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < 55)) or (610 > 4375)) then
					if (v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(8)) or (1237 >= 3534)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\23\234\8\20\197\86\56\33\255\9\21\227\25\58\27\255\29\18\246\77\1\13\237\92\86\170", "\57\94\126\153\124\103\154");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\49\198\76\21\223\79\18\244\93\22\219\81", "\33\119\167\41\121\182")]:IsCastable() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < 1) and (v14:DebuffRemains(v60.FaeExposureDebuff) < 3)) or (925 > 1561)) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (3654 >= 3989)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\65\181\62\90\162\93\25\7\84\160\52\91\187\19\24\61\65\181\46\90\191\108\15\44\7\229\105", "\88\39\212\91\54\203\51\124");
					end
				end
				if ((2027 < 4566) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\30\165\167\131\117\201\251\57\162\159\131\120\197", "\168\76\204\212\234\27\174")]:IsReady() and (v13:BuffUp(v60.PressurePointBuff) or (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > 55))) then
					if (v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(5)) or (202 == 3425)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\158\13\32\77\7\225\113\159\17\61\123\2\239\77\135\68\55\65\15\231\91\128\16\12\87\29\166\31\216", "\46\236\100\83\36\105\134");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\27\246\134\131\138\0\44\238\172\137\130\4", "\111\89\154\231\224\225")]:IsReady() and v13:BuffUp(v60.PressurePointBuff) and (v13:Chi() > 2) and v13:PrevGCD(1, v60.RisingSunKick)) or (3965 <= 3591)) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5)) or (4065 < 2722)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\214\7\166\39\246\201\197\194\209\15\166\39\185\216\212\251\219\19\169\56\198\207\197\189\139\80", "\177\157\186\102\197\76\153\188");
					end
				end
				v176 = 2;
			end
			if ((v176 == 6) or (1081 == 2218)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\153\244\150\228\44\48\200\94\170\229\128\219\44\48\203", "\20\203\129\229\140\69\94\175")]:IsReady() and (v13:BuffDown(v60.RushingJadeWindBuff))) or (3763 < 2386)) then
					if (v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8)) or (1898 > 4502)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\189\211\71\62\230\236\168\249\94\55\235\231\144\209\93\56\235\162\171\195\82\55\250\238\187\249\71\34\175\183\255", "\130\207\166\52\86\143");
					end
				end
				if ((3583 >= 139) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\104\86\18\238\161\116\52\94\113\26\238\161", "\65\42\58\115\141\202\27")]:IsReady() and (v89(v60.BlackoutKick))) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5)) or (1035 == 520)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\8\84\194\36\68\17\65\254\36\66\7\94\129\43\78\2\84\212\35\95\59\70\213\111\30\86", "\79\43\100\53\161");
					end
				end
				break;
			end
			if ((3878 >= 2595) and (v176 == 0)) then
				if ((4542 >= 2122) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\72\71\241\229\20\119\26\112\67", "\123\28\46\150\128\102\39")]:IsReady() and v89(v60.TigerPalm) and (v13:Chi() < 2) and ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\55\64\14\94\21\142\8\96\11\98\20\84\16", "\21\101\41\125\55\123\233\91")]:CooldownRemains() < 1) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\164\226\189\231\31\61\132\205\187\225\21", "\82\226\139\206\147\108")]:CooldownRemains() < 1) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\194\18\95\184\199\244\9\75\165\196\244\49\68\191\200\253\9\95\181", "\172\145\102\45\209")]:CooldownRemains() < 1)) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) then
					if ((4812 > 1326) and v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\249\4\2", "\30\148\109\108\32\235"), v96, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\78\22\90\6\120\1\94\24\74\81\91\17\65\16\74\24\83\46\76\0\7\67", "\63\116\39\113");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\29\72\215\233\28\0\169\42\93", "\200\88\48\167\140\112\72")]:IsReady() and (((v13:Chi() == 1) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\240\87\59\162\236\197\109\61\165\201\203\93\35", "\130\162\62\72\203")]:CooldownUp() or v60[LUAOBFUSACTOR_DECRYPT_STR_0("\144\163\175\121\140\133\224\251\183\191\184\71\142\142\235\241\172\165\185", "\157\195\215\221\16\231\224\143")]:CooldownUp())) or ((v13:Chi() == 2) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\89\208\24\152\240\112\223\45\153\241\102", "\131\31\185\107\236")]:CooldownUp() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\153\162\89\45\165\172\121\49\165\128\67\39\160", "\68\203\203\42")]:CooldownDown()))) or (768 >= 4663)) then
					if (v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(20)) or (1832 > 4462)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\79\101\220\79\104\125\216\81\90\53\221\70\81\116\204\79\67\74\202\87\23\33", "\185\35\55\21");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\128\237\173\141\184\252\176\130\167\241\186\179\186\247\187\136\188\235\187", "\228\211\153\223")]:IsReady() and ((v13:BuffUp(v60.DomineeringArroganceBuff) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\96\231\77\51\62\3\70\233\81\46\46", "\102\52\143\56\93\90")]:IsAvailable() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\117\18\178\45\235\79\3\185", "\133\38\119\192\72")]:IsAvailable() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\222\175\98\244\252\164\76\238\242\175\64\243\242\150\124\242\227\164\64\242\240\164\102", "\155\151\193\20")]:CooldownRemains() > 20)) or (v68 < 5) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\26\172\21\64\127\43\182\6\71\104\58", "\27\78\196\96\46")]:IsAvailable() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > 10) and v13:BuffDown(v60.DomineeringArroganceBuff)) or (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\222\243\167\182\126\65\94\236\242\161\172", "\44\138\155\210\216\26\36")]:IsAvailable() and (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) > 35) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\136\72\171\95\243\178\89\160", "\157\219\45\217\58")]:IsAvailable()))) or (483 == 4635)) then
					if (v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9)) or (1000 > 4884)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\163\169\36\220\245\181\130\57\211\193\164\181\51\234\233\185\179\50\217\241\162\185\118\209\251\182\188\35\217\234\143\174\34\149\168", "\158\208\221\86\181");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\210\72\249\2\46\184\11\245\79\193\2\35\180", "\88\128\33\138\107\64\223")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\231\251\102\97\190\116\232\231\231\103\108", "\142\161\146\21\21\205\27")]:CooldownUp())) or (3393 < 2232)) then
					if (v22(v60.RisingSunKick, nil, nil, not v14:IsInMeleeRange(5)) or (319 <= 208)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\2\243\111\10\20\254\243\3\239\114\60\17\240\207\27\186\120\6\28\248\217\28\238\67\16\14\185\148", "\172\112\154\28\99\122\153");
					end
				end
				v176 = 1;
			end
		end
	end
	local function v124()
		local v177 = 0;
		while true do
			if ((2 == v177) or (4317 <= 1066)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\14\253\78\204\226\226\51\234\100\208\237\229\56\198\78\193\231", "\139\93\141\39\162\140")]:IsReady() and ((v89(v60.SpinningCraneKick) and (v13:BuffStack(v60.ChiEnergyBuff) > (30 - (5 * v66))) and v13:BuffDown(v60.StormEarthAndFireBuff) and (((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\30\170\26\222\16\43\144\28\217\53\37\160\2", "\126\76\195\105\183")]:CooldownRemains() > 2) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\121\65\183\101\74\187\89\110\177\99\64", "\212\63\40\196\17\57")]:CooldownRemains() > 2)) or ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\155\194\227\243\167\204\195\239\167\224\249\249\162", "\154\201\171\144")]:CooldownRemains() < 3) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\164\231\187\217\165\0\185\155\151\252\177", "\221\226\142\200\173\214\111\223")]:CooldownRemains() > 3) and (v13:Chi() > 3)) or ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\60\71\172\56\166\9\125\170\63\131\7\77\180", "\200\110\46\223\81")]:CooldownRemains() > 3) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\48\78\47\32\49\221\68\48\82\46\45", "\34\118\39\92\84\66\178")]:CooldownRemains() < 3) and (v13:Chi() > 4)) or ((v13:ChiDeficit() <= 1) and (v87() < 2)))) or ((v13:BuffStack(v60.ChiEnergyBuff) > 10) and (v68 < 7)))) or (1437 < 395)) then
					if ((4095 == 4095) and v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\88\152\56\12\32\160\193\116\116\139\35\3\32\172\240\120\66\139\58\66\40\168\195\127\95\128\35\23\110\248\151", "\19\43\232\81\98\78\201\175");
					end
				end
				if ((4695 > 3959) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\106\193\251\167\202\232\190\68\193\234\163\202\249", "\234\43\179\152\198\164\141")]:IsCastable() and (v13:ChiDeficit() >= 1)) then
					if ((4747 > 2464) and v22(v60.ArcaneTorrent, nil)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\164\72\127\223\137\182\242\147\170\72\110\219\137\167\141\129\164\86\112\202\143\161\216\199\247\10", "\231\197\58\28\190\231\211\173");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\103\219\57\41\197\188\82\222\51", "\236\51\178\94\76\183")]:IsReady() or (2347 < 469)) then
					if ((686 < 3153) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\254\196\213\70\248\242\194\66\230\192\146\69\235\193\222\87\226\223\199\3\184\153", "\35\138\173\178");
					end
				end
				break;
			end
			if ((1 == v177) or (3799 < 2868)) then
				if ((701 <= 4279) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\89\210\85\143\106\194\59\173", "\217\26\186\60\205\31\176\72")]:IsCastable() and (((v13:ChiDeficit() >= 1) and (v66 == 1)) or ((v13:ChiDeficit() >= 2) and (v66 >= 2)))) then
					if ((1939 < 4196) and v24(v60.ChiBurst, not v14:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\121\15\211\217\100\20\255\207\49\0\237\215\125\18\228\201\100\70\189\139", "\140\187\17\102");
					end
				end
				if (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\15\131\173\118\45\157\161", "\33\76\235\196")]:IsCastable() or (3455 < 3374)) then
					if ((616 <= 2930) and v22(v60.ChiWave, nil, nil, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\11\226\251\96\187\49\147\128\72\236\243\83\160\36\141\151\29\170\163\13", "\229\104\138\146\63\204\80\229");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\133\101\14\204\172\85\31\219\173", "\169\192\29\126")]:IsReady() and (v13:ChiDeficit() >= 1)) or (346 > 4438)) then
					if ((4615 == 4615) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\221\21\142\61\250\13\138\35\200\69\141\48\201\9\159\57\215\16\203\96\145", "\235\81\165\101");
					end
				end
				if ((2103 <= 4801) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\90\136\94\26\142\11\217\108\175\86\26\142", "\172\24\228\63\121\229\100")]:IsReady() and v89(v60.BlackoutKick) and (v66 >= 5)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\135\71\219", "\173\234\46\181"), v98, nil, not v14:IsInMeleeRange(5)) or (1834 == 2370)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\221\62\234\60\40\208\39\255\0\40\214\49\224\127\37\222\62\231\43\43\205\39\171\110\117", "\67\191\82\139\95");
					end
				end
				v177 = 2;
			end
			if ((v177 == 0) or (4153 > 4588)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\211\214\206\76\95\64\63\74\247\238\206\75\81\96\63\67\248\208\193\70\90\75", "\36\144\164\175\47\52\44\86")]:IsReady() and (((v13:BuffStack(v60.TheEmperorsCapacitorBuff) > 19) and (v87() > (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\19\29\250\167\116\60\6\245\163\85\49\11\254\136\118\55\7\239\170\118\62\8", "\31\80\111\155\196")]:ExecuteTime() - 1)) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\97\80\242\221\33\84\106\244\218\4\90\90\234", "\79\51\57\129\180")]:CooldownRemains() > v60[LUAOBFUSACTOR_DECRYPT_STR_0("\20\160\49\91\210\59\187\62\95\243\54\182\53\116\208\48\186\36\86\208\57\181", "\185\87\210\80\56")]:ExecuteTime())) or ((v13:BuffStack(v60.TheEmperorsCapacitorBuff) > 14) and (((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\245\21\188\93\115\240\65\223", "\53\166\112\206\56\29\153")]:CooldownRemains() < 5) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\65\22\68\15\251\38\102\10", "\79\18\115\54\106\149")]:IsAvailable()) or (v68 < 5))))) or (1272 >= 3225)) then
					if (v22(v60.CracklingJadeLightning, nil, nil, not v14:IsSpellInRange(v60.CracklingJadeLightning)) or (2231 > 2541)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\64\79\93\46\113\132\168\77\109\68\95\33\120\178\170\67\85\70\74\43\116\131\161\10\84\79\82\41\105\133\180\95\18\28", "\198\42\50\46\62\69\29\237");
					end
				end
				if ((1885 < 2469) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\228\187\19\53\33\174\11\104\214\181\27\41", "\59\162\218\118\89\72\192\110")]:IsCastable() and (v89(v60.FaelineStomp))) then
					if (v22(v60.FaelineStomp, nil, nil, not v14:IsInRange(30)) or (4125 >= 4263)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\131\255\181\83\65\15\119\62\150\234\191\82\88\65\116\0\137\242\164\87\90\20\50\85", "\97\229\158\208\63\40\97\18");
					end
				end
				if ((3848 >= 1225) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\25\199\117\67\158\29\207\126\75", "\236\77\174\18\38")]:IsReady() and v89(v60.TigerPalm) and (v13:ChiDeficit() >= (2 + v27(v13:BuffUp(v60.PowerStrikesBuff))))) then
					if ((1480 > 1337) and v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\141\84\193", "\117\224\61\175"), v96, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\78\193\141\249\120\214\137\231\74\134\142\234\75\202\156\227\85\211\200\189", "\232\139\39\166");
					end
				end
				if ((2171 >= 726) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\198\73\67\64\123\234\226\67\94", "\162\131\49\51\37\23")]:IsReady() and (v13:ChiDeficit() >= 1) and (v66 > 2)) then
					if ((1618 < 2034) and v22(v60.ExpelHarm, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\97\238\47\120\96\113\255\56\121\31\127\255\38\120\75\113\236\63\52\7", "\20\63\25\158\74");
					end
				end
				v177 = 1;
			end
		end
	end
	local function v125()
		local v178 = 0;
		while true do
			if ((v178 == 6) or (2119 < 22)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\77\220\66\142\112\197\69\135\93\222\74\142\123\231\66\131\117", "\224\30\172\43")]:IsReady() and v89(v60.SpinningCraneKick) and (v66 > 1)) or (4099 < 3869)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (4107 < 610)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\183\118\208\227\12\169\120\225\238\23\166\113\219\210\14\174\124\213\173\22\162\109\219\227\12\179\102\158\190\81", "\141\101\199\31\190");
					end
				end
				if ((4656 > 1721) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\108\79\10\213\214\176\161\92\99\17\198\221\182\161\107\82\13\196\210", "\207\59\39\99\167\186\217")]:IsReady() and (v66 > 1)) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (4721 < 3189)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\78\178\64\68\244\174\236\56\66\169\83\79\242\174\212\23\83\181\81\64\189\179\238\21\67\181\91\92\228\224\184\81", "\139\103\38\219\50\40\157\192");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\212\173\37\202\239\182\49\232\231\188\51\245\239\182\50", "\162\134\216\86")]:IsReady() and v13:BuffDown(v60.RushingJadeWindBuff) and (v66 >= 3)) or (1215 < 338)) then
					if ((3748 >= 1459) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\250\68\81\57\76\246\144\52\238\83\92\15\85\248\161\58\175\68\92\34\71\255\166\42\246\23\10\104", "\207\94\143\55\57\80\34\145");
					end
				end
				v178 = 7;
			end
			if ((944 == 944) and (v178 == 0)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\231\10\91\200\65\114\199\37\93\206\75", "\29\161\99\40\188\50")]:IsReady() and (v13:BuffRemains(v60.SerenityBuff) < 1)) or (4692 < 1203)) then
					if ((3988 >= 1295) and v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\127\35\179\243\29\5\5\234\70\44\181\245\23\122\25\233\107\47\174\238\26\35\74\190", "\140\25\74\192\135\110\90\106");
					end
				end
				if ((4045 >= 332) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\0\93\69\241\161\173\55\69\111\251\169\169", "\194\66\49\36\146\202")]:IsReady() and v89(v60.BlackoutKick) and not v92() and (v66 > 4) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\184\57\204\6\202\156\51\194\26\204\133\54\249\16\192\138\53\222", "\165\235\81\173\98")]:IsAvailable()) then
					if ((4245 <= 4666) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\38\140\167", "\132\75\229\201\86\217"), v95, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\128\126\164\166\137\125\176\177\189\121\172\166\137\50\182\160\144\119\171\172\150\107\229\241", "\197\226\18\197");
					end
				end
				if ((4623 > 179) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\46\216\18\88\18\214\50\68\18\250\8\82\23", "\49\124\177\97")]:IsReady() and (((v66 == 4) and v13:BuffUp(v60.PressurePointBuff) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\162\50\206\187\132\40\211\170\162\47\197\169", "\222\224\93\160")]:IsAvailable()) or (v66 == 1) or ((v66 <= 3) and v13:BuffUp(v60.PressurePointBuff)) or (v13:BuffUp(v60.PressurePointBuff) and v13:HasTier(30, 2)))) then
					if ((2580 == 2580) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\230\244\124", "\88\139\157\18\65"), v95, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\88\19\1\24\197\77\37\1\4\197\117\17\27\18\192\10\9\23\3\206\68\19\6\8\139\18", "\171\42\122\114\113");
					end
				end
				v178 = 1;
			end
			if ((v178 == 4) or (4582 > 4758)) then
				if ((3454 <= 4096) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\213\60\146\41\238\39\134\11\230\45\132\22\238\39\133", "\65\135\73\225")]:IsReady() and v13:BuffDown(v60.RushingJadeWindBuff) and (v66 >= 5)) then
					if ((4161 > 187) and v22(v60.RushingJadeWind, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\13\70\66\168\29\17\84\110\170\21\27\86\110\183\29\17\87\17\179\17\13\86\95\169\0\6\19\3\242", "\116\127\51\49\192");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\57\12\82\254\229\17\23\15\43\90\254\229", "\98\123\96\51\157\142\126")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\254\246\167\202\41\218\252\169\214\47\195\249\146\220\35\204\250\181", "\70\173\158\198\174")]:IsAvailable() and (v66 >= 3) and v89(v60.BlackoutKick)) or (1646 > 3171)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\253\54\65", "\142\144\95\47"), v95, nil, not v14:IsInMeleeRange(5)) or (2778 >= 2813)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\21\33\81\13\28\34\69\26\40\38\89\13\28\109\67\11\5\40\94\7\3\52\16\92\67", "\110\119\77\48");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\216\47\45\91\234\226\49\35\118\246\234\49\33\126\237\232\52", "\132\139\95\68\53")]:IsReady() and v89(v60.SpinningCraneKick) and ((v66 > 3) or ((v66 > 2) and (v91() >= 2.3)))) or (3168 > 4000)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (622 > 4897)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\239\56\244\59\242\33\243\50\195\43\239\52\242\45\194\62\245\43\246\117\239\45\239\48\242\33\233\44\188\122\171", "\85\156\72\157");
					end
				end
				v178 = 5;
			end
			if ((1018 < 4823) and (v178 == 8)) then
				if ((2136 == 2136) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\249\61\49\209\14\53\89\201\17\42\194\5\51\89\254\32\54\192\10", "\55\174\85\88\163\98\92")]:IsReady()) then
					if (v22(v60.WhirlingDragonPunch, nil, nil, not v14:IsInMeleeRange(5)) or (612 == 1980)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\218\64\15\151\58\196\70\1\186\50\223\73\1\138\56\242\88\19\139\53\197\8\21\128\36\200\70\15\145\47\141\28\80", "\86\173\40\102\229");
					end
				end
				if ((2334 == 2334) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\48\173\72\136\22\148\78\129\9", "\237\100\196\47")]:IsReady() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\120\73\138\169\63\129\26\75\95\132\172\35\128\17\97\67\133\171\36\156\17\94\85", "\116\44\44\235\202\87\232")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3)) then
					if ((70 < 471) and v22(v60.TigerPalm, nil, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\222\81\32\16\141\226\2\219\91\101\17\183\224\6\217\95\49\27\242\166\91", "\146\99\183\54\69\98\210");
					end
				end
				break;
			end
			if ((3960 <= 4600) and (v178 == 1)) then
				if ((4561 == 4561) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\175\164\205\225\134\167\217\246\166\161\207\233", "\130\237\200\172")]:IsReady() and v89(v60.BlackoutKick) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 3) and (v13:BuffRemains(v60.TeachingsoftheMonasteryBuff) < 1)) then
					if ((4066 >= 1982) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\43\217\160", "\110\70\176\206"), v95, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\119\28\60\232\49\122\5\41\212\49\124\19\54\171\41\112\2\56\229\51\97\9\125\189", "\90\21\112\93\139");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\39\210\103\162\179\14\221\82\163\178\24", "\192\97\187\20\214")]:IsReady() and ((v13:BuffUp(v60.InvokersDelightBuff) and (((v66 < 3) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\32\90\55\205\169\13\85\58\220\137\5\85", "\224\106\59\83\168")]:IsAvailable()) or (v66 > 4))) or v13:BloodlustUp() or (v66 == 2))) or (3612 < 1085)) then
					if ((2479 == 2479) and v22(v60.FistsofFury, nil, nil, not v14:IsInMeleeRange(8))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\236\17\239\93\183\70\161\218\4\238\92\145\9\180\224\16\254\64\129\93\190\165\83\171", "\41\199\133\98\155\46\232");
					end
				end
				if ((4806 >= 2179) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\58\175\242\82\174\0\224\58\179\243\95", "\134\124\198\129\38\221\111")]:IsReady()) then
					local v222 = 0;
					local v223;
					while true do
						if ((v222 == 0) or (2190 >= 4882)) then
							v223 = v94();
							if (v223 or (4107 < 568)) then
								if ((v223:GUID() == v14:GUID()) or (1258 > 2404)) then
									if (v24(v60.FistsofFury) or (4862 < 3634)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\254\230\162\52\235\208\190\38\199\233\164\50\225\175\190\46\253\208\182\35\252\175\162\37\234\234\191\41\236\246\241\113\172", "\64\152\143\209");
									end
								elseif (v31 or (3966 == 4307)) then
									if ((((GetTime() - v84[LUAOBFUSACTOR_DECRYPT_STR_0("\27\72\214\24\126\44\110\0\50\93\246\27\75\61", "\103\87\41\165\108\42\77\28")]) * 1000) >= v34) or (3748 == 210)) then
										local v275 = 0;
										while true do
											if ((2267 > 1776) and (v275 == 0)) then
												v84[LUAOBFUSACTOR_DECRYPT_STR_0("\142\210\7\227\66\225\176\212\17\227\69\247\163\195", "\128\194\179\116\151\22")] = GetTime();
												if ((182 < 4762) and v24(v23(100))) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\1\59\16\179\207\11\137\1\13\5\178\206\45\198\8\60\6\152\219\55\130\71\61\5\161\145\32\135\21\53\6\179\156\39\131\21\55\13\174\200\45\198\86\102", "\230\103\82\99\199\188\84");
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
				v178 = 2;
			end
			if ((v178 == 2) or (4191 <= 3950)) then
				if ((4459 == 4459) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\143\146\177\161\82\47\179\128\183\160\92\29\181\136\167\164\86\56\184", "\74\220\230\195\200\57")]:IsReady() and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\145\130\197\17\15\212\183\140\217\12\31", "\177\197\234\176\127\107")]:IsAvailable())) then
					if (v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9)) or (3203 > 3380)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\96\222\212\65\129\113\96\124\204\249\92\130\113\96\100\195\200\76\134\123\77\119\138\213\77\152\113\81\122\222\223\8\216", "\63\19\170\166\40\234\20");
					end
				end
				if ((4311 < 4910) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\5\24\4\38\46\36\206\49\43\31\41\46\40\235\63\11\6", "\160\86\104\109\72\64\77")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff) and (v66 >= 2)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (358 >= 3733)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\99\231\4\16\131\247\116\209\9\12\139\247\118\209\1\23\137\242\51\253\15\12\143\247\122\250\19\94\219\173", "\234\153\19\142\106\126");
					end
				end
				if ((712 <= 1607) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\19\45\174\17\47\35\142\13\47\15\180\27\42", "\120\65\68\221")]:IsReady() and (v66 == 4) and v13:BuffUp(v60.PressurePointBuff)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\21\188\235", "\220\120\213\133"), v95, nil, not v14:IsInMeleeRange(5)) or (2554 > 3248)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\74\39\212\89\36\95\17\212\69\36\103\37\206\83\33\24\61\194\66\47\86\39\211\73\106\9\120", "\74\56\78\167\48");
					end
				end
				v178 = 3;
			end
			if ((v178 == 5) or (4900 == 3871)) then
				if ((1023 < 4774) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\72\38\111\40\209\45\133\125\38\117\36\237\33\132\127\62\114\51\222", "\234\27\82\29\65\186\72")]:IsReady() and (v66 >= 3)) then
					if (v22(v60.StrikeoftheWindlord, nil, nil, not v14:IsInMeleeRange(9)) or (796 == 4289)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\219\251\183\8\245\240\230\184\60\228\199\236\129\20\249\193\237\178\12\226\203\169\173\6\226\202\231\183\23\233\143\187\230", "\99\144\175\137\222");
					end
				end
				if ((2097 < 4387) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\98\125\159\8\55\66\130\69\122\167\8\58\78", "\209\48\20\236\97\89\37")]:IsReady() and (v66 == 2) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\218\72\77\61\81\243\71\120\60\80\229", "\34\156\33\62\73")]:CooldownRemains() > 5)) then
					if (v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\5\123\224", "\49\104\18\142"), v95, nil, not v14:IsInMeleeRange(5)) or (3383 > 3550)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\236\111\2\255\226\67\24\228\235\67\0\248\230\119\75\226\224\110\14\255\236\104\18\177\182\44", "\107\145\133\28");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\224\82\178\189\201\81\166\170\233\87\176\181", "\222\162\62\211")]:IsReady() and v89(v60.BlackoutKick) and (v66 == 2) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\133\120\29\15\34\140\204\133\100\28\2", "\170\195\17\110\123\81\227")]:CooldownRemains() > 5) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\135\60\225\196\242\163\54\239\216\244\186\51\212\210\248\181\48\243", "\157\212\84\128\160")]:IsAvailable() and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 1)) or (4443 <= 2791)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\132\122\238", "\163\233\19\128\37\70\232\142"), v95, nil, not v14:IsInMeleeRange(5)) or (3606 > 4793)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\89\61\26\232\90\41\13\220\94\53\26\232\21\47\28\241\80\50\16\247\76\124\74\177", "\121\131\53\92");
					end
				end
				v178 = 6;
			end
			if ((458 <= 3770) and (v178 == 7)) then
				if ((4979 >= 4544) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\16\216\48\115\190\92\36\172\44\250\42\121\187", "\217\66\177\67\26\208\59\119")]:IsReady()) then
					if ((3119 == 3119) and v84.CastTargetIf(v60.RisingSunKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\46\215\196", "\152\67\190\170\202\48\138"), v95, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\32\70\249\213\46\106\227\206\39\106\251\210\42\94\176\200\44\71\245\213\32\65\233\155\125\5", "\144\187\73\53");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\37\171\51\217\172\186\24\188\25\197\163\189\19\144\51\212\169", "\211\118\219\90\183\194")]:IsReady() and v89(v60.SpinningCraneKick) and v13:BuffUp(v60.DanceofChijiBuff)) or (1820 == 4294)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (3617 <= 2313)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\189\129\229\84\248\246\170\183\232\72\240\246\168\183\224\83\242\243\237\155\238\72\244\246\164\156\242\26\165\170", "\145\152\205\232\139\58");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\145\254\191\188\80\167\27\167\217\183\188\80", "\110\211\146\222\223\59\200")]:IsReady() and (v89(v60.BlackoutKick))) or (2766 >= 4426)) then
					if (v22(v60.BlackoutKick, nil, nil, not v14:IsInMeleeRange(5)) or (153 > 3769)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\88\227\12\73\92\65\246\48\73\90\87\233\79\81\86\70\231\1\75\71\77\162\91\22", "\34\51\52\130\111");
					end
				end
				v178 = 8;
			end
			if ((4995 == 4995) and (v178 == 3)) then
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\198\16\42\195\1\5\45\240\55\34\195\1", "\88\132\124\75\160\106\106")]:IsReady() and (v66 == 3) and v89(v60.BlackoutKick) and v13:HasTier(30, 2)) or (352 > 2154)) then
					if ((296 == 296) and v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\25\63\131", "\96\116\86\237\39\123\202\80"), v95, nil, not v14:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\24\176\126\137\163\186\53\43\186\116\129\167\239\50\17\163\120\140\165\187\56\84", "\207\65\116\209\29\226\204");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\131\64\130\0\190\89\133\9\147\66\138\0\181\123\130\13\187", "\110\208\48\235")]:IsReady() and v89(v60.SpinningCraneKick) and (v66 >= 3) and v92()) or (291 < 54)) then
					if (v22(v60.SpinningCraneKick, nil, nil, not v14:IsInMeleeRange(8)) or (3035 > 4343)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\185\138\131\171\160\141\138\154\170\145\140\171\172\188\134\172\170\136\205\182\172\145\136\171\160\151\148\229\251\211", "\237\197\201\227");
					end
				end
				if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\153\47\30\125\174\60\111\175\8\22\125\174", "\26\219\67\127\30\197\83")]:IsReady() and v89(v60.BlackoutKick) and (v66 > 1) and (v66 < 4) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) == 2)) or (1155 > 4438)) then
					if (v84.CastTargetIf(v60.BlackoutKick, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\248\17\208", "\153\149\120\190\26\112"), v95, nil, not v14:IsInMeleeRange(5)) or (1946 > 2286)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\14\25\203\163\33\255\235\3\51\30\195\163\33\176\237\18\30\16\196\169\62\233\190\70\84", "\119\108\117\170\192\74\144\158");
					end
				end
				v178 = 4;
			end
		end
	end
	local function v126()
		local v179 = 0;
		while true do
			if ((v179 == 6) or (3807 <= 1713)) then
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\178\88\79\6\136\83\92\1", "\114\225\61\59")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\102\41\128\211\125\19\133\213\103\33\185\213\116\33\159\239\103\37\153\201\118\17\158\221\116\33", "\237\188\19\68")] or "";
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\237\250\12\233\243\239\253", "\128\157\136\142\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\177\28\134\82\171\237\87\241\179\28", "\157\210\101\229\62\206\169\50")] or "";
				break;
			end
			if ((3 == v179) or (3958 > 4750)) then
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\141\77\99\142\196\233\215", "\142\164\232\57\23\231\170")][LUAOBFUSACTOR_DECRYPT_STR_0("\159\171\210\249\30\178\131\210\254\29\165\186\211\239\23\182\166", "\114\215\202\188\157")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\2\160\230\68\187\141\236\150", "\229\81\197\146\48\210\227\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\183\65\94\78\220\238\94\94\173\84\112\123\193\246\92", "\54\226\50\59\26\179\155\61")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\249\59\44\76\22\196\57\43", "\127\170\94\88\56")][LUAOBFUSACTOR_DECRYPT_STR_0("\213\212\177\246\183\40\250\174\207\193\144\199\185\41\241", "\198\128\167\212\162\216\93\153")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\63\240\202\163\52\227\205", "\190\202\90\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\178\202\118\241\173\52\147\208\117\206\171\40\128\251\97\210\181", "\70\231\185\19\183\194")];
				v179 = 4;
			end
			if ((4132 == 4132) and (v179 == 2)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\63\242\185\186\228\253\49", "\66\101\90\134\205\211\138\154")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\73\120\160\145\47\15\88\118\162\128\15\44", "\71\124\44\25\204\229")] or 0;
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\33\255\61\80\203\183\21\233", "\217\114\154\73\36\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\172\169\189\4\132\36\57\167\175\171\7\155", "\96\92\197\218\205\97\232")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\13\15\168\153\246\48\13\175", "\159\94\106\220\237")][LUAOBFUSACTOR_DECRYPT_STR_0("\137\19\23\83\168\22\38\86\171\28\23", "\35\205\122\100")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\145\92\19\83\171\87\0\84", "\39\194\57\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\250\50\85\10\169\239\164\253\48\88\5\184\203\166", "\174\194\155\92\49\102\204")];
				v179 = 3;
			end
			if ((3986 >= 1186) and (5 == v179)) then
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\255\126\251\193\123\69\203\104", "\43\172\27\143\181\18")][LUAOBFUSACTOR_DECRYPT_STR_0("\247\40\170\169\120\221\1\166\171\112\251\25", "\29\179\73\199\217")] or 0;
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\74\164\105\217\112\175\122\222", "\173\25\193\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\111\99\82\59\164\12\208\109\73\117\122\30\170\3\213", "\24\58\16\55\127\205\106\182")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\148\2\195\77\41\169\0\196", "\64\199\103\183\57")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\70\85\95\230\55\74\126\88\244\45\76\123\105", "\147\68\47\51\57")] or 0;
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\186\74\8\40\143\78\142\92", "\32\233\47\124\92\230")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\78\140\190\184\219\234\159\99\144\190\171\251\234\138\70\135", "\153\235\33\226\219\220\174")] or "";
				v179 = 6;
			end
			if ((1484 >= 732) and (v179 == 4)) then
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\197\240\176\186\213\199\247", "\211\187\160\132\196")][LUAOBFUSACTOR_DECRYPT_STR_0("\10\143\253\233\65\186\235\37\142\232\223\90\185\229\4\176", "\146\76\224\143\157\40\220")] or 0;
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\122\162\102\175\55\249\72", "\158\59\31\214\18\198\89")][LUAOBFUSACTOR_DECRYPT_STR_0("\104\26\66\47\69\25\66\6\117\8\85\7", "\106\61\105\39")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\187\47\251\10\204\117\246", "\18\133\222\91\143\99\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\82\39\188\91\213\20\66\192\122\23\156", "\178\23\95\204\62\185\92\35")] or 0;
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\243\203\226\84\47\241\204", "\61\65\150\191\150")][LUAOBFUSACTOR_DECRYPT_STR_0("\127\198\140\157\214\12\218\79\219\161\184\197\12", "\170\42\181\233\217\183\97")];
				v179 = 5;
			end
			if ((v179 == 1) or (322 == 3439)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\12\80\107\234\10\49\82\108", "\99\95\53\31\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\57\117\121\247\43\124\88\252\45\64\94\230\35\127\95", "\49\146\74\16")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\215\84\158\78\139\234\86\153", "\226\132\49\234\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\125\177\232\19\247\21\104\213\108\185\235\20\215\19\85\223", "\56\186\24\208\132\122\153\114")] or "";
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\19\52\69\139\205\17\51", "\226\163\118\64\49")][LUAOBFUSACTOR_DECRYPT_STR_0("\209\201\62\178\20\247\203\15\177\9\240\195\49\150\45", "\125\153\172\95\222")] or 0;
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\72\195\247\217\228\212\228\104", "\131\27\166\131\173\141\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\198\96\66\15\246\114\75\51\251\96\83\40\253\118", "\71\147\19\39")];
				v179 = 2;
			end
			if ((240 <= 3891) and (v179 == 0)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\250\161\177\53\185\224\236", "\215\135\159\213\197\92")][LUAOBFUSACTOR_DECRYPT_STR_0("\134\182\237\200\185\164\250\249\166\171", "\140\211\197\136")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\3\201\40\96\197\62\203\47", "\172\80\172\92\20")][LUAOBFUSACTOR_DECRYPT_STR_0("\55\116\197\29\98\219\214\152\10\77\216\12\120\250\215\157\16", "\232\126\26\177\120\16\169\163")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\223\227\165\103\75\193\177\255", "\214\140\134\209\19\34\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\41\188\175\70\53\189\186\64\8\166\166\77\16\160\163\64\34\164\163\71\51", "\202\52\71\200")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\77\97\147\231\70\114\148", "\231\142\40\21")][LUAOBFUSACTOR_DECRYPT_STR_0("\89\60\209\15\64\17\193\96\38\241\2\64\6\199\120\61\201\14", "\180\16\82\165\106\50\99")];
				v179 = 1;
			end
		end
	end
	local function v127()
		local v180 = 0;
		while true do
			if ((319 >= 269) and (v180 == 2)) then
				if ((1353 < 3845) and v30) then
					local v224 = 0;
					while true do
						if ((v224 == 0) or (3383 < 531)) then
							v66 = #v65;
							v66 = ((#v65 > 0) and #v65) or 1;
							break;
						end
					end
				else
					v66 = 1;
				end
				if ((1009 <= 1382) and v13:IsDeadOrGhost()) then
					return;
				end
				if (v84.TargetIsValid() or v13:AffectingCombat() or (169 > 4163)) then
					local v225 = 0;
					while true do
						if ((v225 == 0) or (4810 < 545)) then
							v67 = v10.BossFightRemains();
							v68 = v67;
							v225 = 1;
						end
						if ((v225 == 1) or (538 == 4449)) then
							if ((v68 == 11111) or (1199 == 1619)) then
								v68 = v10.FightRemains(v65, false);
							end
							break;
						end
					end
				end
				if (v84.TargetIsValid() or v13:AffectingCombat() or (4440 == 3503)) then
					v69 = v60[LUAOBFUSACTOR_DECRYPT_STR_0("\250\215\82\229\36\81\213\198\220\74\222\39\81\218\219\208\80\239\27\93\234\214\203", "\141\179\185\36\138\79\52")]:TimeSinceLastCast() <= 24;
				end
				v180 = 3;
			end
			if ((553 == 553) and (v180 == 3)) then
				if ((983 == 983) and v13:AffectingCombat() and v44) then
					if ((v60[LUAOBFUSACTOR_DECRYPT_STR_0("\223\62\75\172\227", "\195\155\91\63")]:IsReady() and v33) or (2664 <= 1493)) then
						local v227 = 0;
						while true do
							if ((3871 > 1947) and (v227 == 0)) then
								ShouldReturn = v84.FocusUnit(true, nil, nil, nil);
								if (ShouldReturn or (3661 < 1392)) then
									return ShouldReturn;
								end
								break;
							end
						end
					end
				end
				if (v84.TargetIsValid() or (2273 == 4605)) then
					local v226 = 0;
					while true do
						if ((684 <= 4562) and (v226 == 1)) then
							if ((2064 <= 4490) and v22(v60.PoolEnergy)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\33\203\216\81\86\52\60\55\3\195\206", "\82\113\164\183\61\118\113\82");
							end
							break;
						end
						if ((2010 < 3660) and (v226 == 0)) then
							if ((not v13:AffectingCombat() and v29) or (3070 <= 384)) then
								local v232 = 0;
								local v233;
								while true do
									if ((4659 >= 4614) and (v232 == 0)) then
										v233 = v105();
										if ((2126 <= 4280) and v233) then
											return v233;
										end
										break;
									end
								end
							end
							if (v13:AffectingCombat() or v29 or (2895 < 2845)) then
								local v234 = 0;
								local v235;
								local v236;
								while true do
									if ((2914 < 3742) and (2 == v234)) then
										if ((2349 >= 1367) and (v10.CombatTime() < 4) and (v13:Chi() < 5) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\229\17\20\13\216\29\18\17", "\104\182\116\102")]:IsAvailable() and (not v69 or not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\15\230\234\238\181\61\134\51\237\242\213\182\61\137\46\225\232\228\138\49\185\35\250", "\222\70\136\156\129\222\88")]:IsAvailable())) then
											local v251 = 0;
											local v252;
											while true do
												if ((1214 <= 1594) and (v251 == 0)) then
													v252 = v108();
													if (v252 or (215 >= 1317)) then
														return v252;
													end
													break;
												end
											end
										end
										v236 = v107();
										if (v236 or (4863 == 4605)) then
											return v236;
										end
										v236 = v106();
										v234 = 3;
									end
									if ((v234 == 3) or (3897 < 1534)) then
										if (v236 or (4352 == 2489)) then
											return v236;
										end
										if ((149 < 3260) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\228\133\129\181\203\138\129\138\214\139\137\169", "\217\162\228\228")]:IsCastable() and v89(v60.FaelineStomp) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\136\220\202\212\167\211\202\240\175\207\194\215\160\196", "\184\206\189\175")]:IsAvailable()) then
											if (v84.CastTargetIf(v60.FaelineStomp, v65, LUAOBFUSACTOR_DECRYPT_STR_0("\81\71\247", "\188\60\46\153\215\172\57"), v99, v102, not v14:IsInRange(30)) or (4825 < 1253)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\18\240\56\94\48\42\17\206\46\70\54\41\4\177\48\83\48\42\84\169", "\68\116\145\93\50\89");
											end
										end
										if ((4176 > 3251) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\155\81\173\166\228\99\174\84\167", "\51\207\56\202\195\150")]:IsReady() and v13:BuffDown(v60.SerenityBuff) and (v13:Energy() > 50) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3) and v89(v60.TigerPalm) and (v13:ChiDeficit() >= (2 + v27(v13:BuffUp(v60.PowerStrikesBuff)))) and ((not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\148\70\237\76\138\131\198\182\184\70\207\75\132\177\246\170\169\77\207\74\134\131\236", "\195\221\40\155\35\225\230\158")]:IsAvailable() and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\245\120\212\92\246\11\210\100", "\98\166\29\166\57\152")]:IsAvailable()) or (not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\154\25\152\216\56\168\17\137", "\93\201\114\225\170")]:IsAvailable() and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\223\235\226\252\122\162\198\230", "\142\140\128\155\136\21\215\165")]:IsAvailable()) or (v10.CombatTime() > 5) or v69) and not v72) then
											if ((2794 == 2794) and v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\76\164\8", "\218\33\205\102\62\128\75\152"), v96, nil, not v14:IsInMeleeRange(5))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\224\114\89\193\228\203\107\95\200\251\180\118\95\205\248\180\42\14", "\150\148\27\62\164");
											end
										end
										if ((2028 <= 2153) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\22\224\237\197\48\217\235\204\47", "\160\66\137\138")]:IsReady() and v13:BuffDown(v60.SerenityBuff) and (v13:BuffStack(v60.TeachingsoftheMonasteryBuff) < 3) and v89(v60.TigerPalm) and (v13:ChiDeficit() >= (2 + v27(v13:BuffUp(v60.PowerStrikesBuff)))) and ((not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\41\205\52\176\52\239\114\101\5\205\22\183\58\221\66\121\20\198\22\182\56\239\88", "\16\96\163\66\223\95\138\42")]:IsAvailable() and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\179\209\195\11\212\0\148\205", "\105\224\180\177\110\186")]:IsAvailable()) or (not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\146\1\187\80\37\93\56\175", "\199\193\106\194\34\64\60\91")]:IsAvailable() and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\12\189\21\178\48\163\15\174", "\198\95\214\108")]:IsAvailable()) or (v10.CombatTime() > 5) or v69) and not v72) then
											if (v84.CastTargetIf(v60.TigerPalm, v64, LUAOBFUSACTOR_DECRYPT_STR_0("\23\52\164", "\85\122\93\202\224\137\108\154"), v96, nil, not v14:IsInMeleeRange(5)) or (1454 > 1715)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\144\89\85\174\209\147\148\81\94\166\131\161\133\89\92\235\146\254", "\204\228\48\50\203\163");
											end
										end
										v234 = 4;
									end
									if ((2845 <= 4527) and (v234 == 5)) then
										if ((623 == 623) and (v66 > 4)) then
											local v253 = 0;
											local v254;
											while true do
												if ((1012 < 3726) and (v253 == 0)) then
													v254 = v119();
													if (v254 or (4096 < 1247)) then
														return v254;
													end
													break;
												end
											end
										end
										if ((v66 == 43) or (3946 < 2578)) then
											local v255 = 0;
											local v256;
											while true do
												if ((407 < 2486) and (v255 == 0)) then
													v256 = v120();
													if (v256 or (1765 <= 282)) then
														return v256;
													end
													break;
												end
											end
										end
										if ((4242 >= 2521) and (v66 == 3)) then
											local v257 = 0;
											local v258;
											while true do
												if ((3378 > 1146) and (v257 == 0)) then
													v258 = v121();
													if (v258 or (3550 == 3822)) then
														return v258;
													end
													break;
												end
											end
										end
										if ((962 == 962) and (v66 == 2)) then
											local v259 = 0;
											local v260;
											while true do
												if ((3181 > 2066) and (v259 == 0)) then
													v260 = v122();
													if (v260 or (1377 >= 3955)) then
														return v260;
													end
													break;
												end
											end
										end
										v234 = 6;
									end
									if ((2566 >= 1160) and (v234 == 6)) then
										if ((2805 <= 4656) and (v66 == 1)) then
											local v261 = 0;
											local v262;
											while true do
												if ((4586 >= 2213) and (v261 == 0)) then
													v262 = v123();
													if ((569 < 4485) and v262) then
														return v262;
													end
													break;
												end
											end
										end
										v236 = v124();
										if ((2984 > 1584) and v236) then
											return v236;
										end
										break;
									end
									if ((2042 == 2042) and (4 == v234)) then
										if ((3580 >= 2486) and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\253\191\64\133\26\93\198\44", "\88\190\215\41\199\111\47\181")]:IsCastable() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\114\54\73\69\121\207\219\103\35\67\68\96", "\190\52\87\44\41\16\161")]:IsAvailable() and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\101\23\2\184\18\47\25\112\2\8\185\11", "\124\35\118\103\212\123\65")]:CooldownDown() and (((v13:ChiDeficit() >= 1) and (v66 == 1)) or ((v13:ChiDeficit() >= 2) and (v66 >= 2))) and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\26\234\169\179\119\82\57\195\173\173\115\83\50\242", "\60\92\139\204\223\30")]:IsAvailable()) then
											if (v24(v60.ChiBurst, not v14:IsInRange(40), true) or (668 > 4598)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\37\21\230\178\199\51\15\252\153\133\43\28\230\131\133\119\73", "\165\70\125\143\237");
											end
										end
										if ((2923 >= 963) and v32 and not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\135\62\231\65\94\189\47\236", "\48\212\91\149\36")]:IsAvailable()) then
											local v263 = 0;
											local v264;
											while true do
												if ((v263 == 0) or (1786 < 400)) then
													v264 = v110();
													if (v264 or (2043 >= 4529)) then
														return v264;
													end
													break;
												end
											end
										end
										if ((4538 > 3371) and v32 and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\119\27\40\1\74\23\46\29", "\100\36\126\90")]:IsAvailable()) then
											local v265 = 0;
											local v266;
											while true do
												if ((1761 == 1761) and (0 == v265)) then
													v266 = v111();
													if ((4667 >= 2772) and v266) then
														return v266;
													end
													break;
												end
											end
										end
										if ((2087 <= 2653) and v13:BuffUp(v60.SerenityBuff)) then
											local v267 = 0;
											while true do
												if ((2464 <= 2556) and (v267 == 1)) then
													if ((v66 > 4) or (2493 == 2954)) then
														local v283 = 0;
														local v284;
														while true do
															if ((v283 == 0) or (1868 >= 2704)) then
																v284 = v114();
																if (v284 or (4079 > 4339)) then
																	return v284;
																end
																break;
															end
														end
													end
													if ((3315 == 3315) and (v66 == 4)) then
														local v285 = 0;
														local v286;
														while true do
															if ((0 == v285) or (3012 <= 999)) then
																v286 = v115();
																if ((2406 < 4613) and v286) then
																	return v286;
																end
																break;
															end
														end
													end
													v267 = 2;
												end
												if ((2 == v267) or (1010 >= 3192)) then
													if ((v66 == 3) or (3647 == 4528)) then
														local v287 = 0;
														local v288;
														while true do
															if ((v287 == 0) or (186 == 2840)) then
																v288 = v116();
																if ((4486 == 4486) and v288) then
																	return v288;
																end
																break;
															end
														end
													end
													if ((v66 == 2) or (83 >= 3201)) then
														local v289 = 0;
														local v290;
														while true do
															if ((3659 == 3659) and (0 == v289)) then
																v290 = v117();
																if ((3147 <= 3604) and v290) then
																	return v290;
																end
																break;
															end
														end
													end
													v267 = 3;
												end
												if ((v267 == 0) or (4461 == 369)) then
													if ((3724 > 73) and v13:BloodlustUp() and (v66 >= 4)) then
														local v291 = 0;
														local v292;
														while true do
															if ((v291 == 0) or (711 > 4199)) then
																v292 = v112();
																if ((214 == 214) and v292) then
																	return v292;
																end
																break;
															end
														end
													end
													if ((v13:BloodlustUp() and (v66 < 4)) or (4650 == 3634)) then
														local v293 = 0;
														local v294;
														while true do
															if ((1929 == 1929) and (v293 == 0)) then
																v294 = v113();
																if (v294 or (3602 == 2156)) then
																	return v294;
																end
																break;
															end
														end
													end
													v267 = 1;
												end
												if ((319 < 3957) and (v267 == 3)) then
													if ((650 == 650) and (v66 == 1)) then
														local v295 = 0;
														local v296;
														while true do
															if ((4350 == 4350) and (0 == v295)) then
																v296 = v118();
																if ((4162 >= 2933) and v296) then
																	return v296;
																end
																break;
															end
														end
													end
													break;
												end
											end
										end
										v234 = 5;
									end
									if ((v234 == 0) or (206 == 828)) then
										if ((not v13:IsCasting() and not v13:IsChanneling()) or (771 >= 4298)) then
											local v268 = 0;
											local v269;
											while true do
												if ((v268 == 2) or (1569 <= 246)) then
													v269 = v84.Interrupt(v60.SpearHandStrike, 40, true, v16, v62.SpearHandStrikeMouseover);
													if (v269 or (242 >= 1152)) then
														return v269;
													end
													break;
												end
												if ((3320 < 4986) and (v268 == 0)) then
													v269 = v84.Interrupt(v60.SpearHandStrike, 8, true);
													if ((1677 < 3594) and v269) then
														return v269;
													end
													v268 = 1;
												end
												if ((2993 < 3299) and (v268 == 1)) then
													v269 = v84.InterruptWithStun(v60.LegSweep, 8);
													if ((3752 < 4442) and v269) then
														return v269;
													end
													v268 = 2;
												end
											end
										end
										if ((964 <= 2008) and v15) then
											if ((v44 and v33 and v60[LUAOBFUSACTOR_DECRYPT_STR_0("\242\70\219\243\213", "\57\182\35\175\156\173\179")]:IsReady() and v84.DispellableFriendlyUnit()) or (3669 > 4613)) then
												if (v24(v62.DetoxFocus) or (2241 == 672)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\217\167\173\208\23\68\181\220\171\183", "\216\189\194\217\191\111\100");
												end
											end
										end
										if ((637 <= 4645) and v46) then
											local v270 = 0;
											while true do
												if ((v270 == 0) or (1584 < 55)) then
													v236 = v84.HandleAfflicted(v60.Detox, v62.DetoxMouseover, 40);
													if ((2631 <= 4599) and v236) then
														return v236;
													end
													break;
												end
											end
										end
										if ((3686 > 2718) and v47) then
											local v271 = 0;
											while true do
												if ((2202 >= 191) and (0 == v271)) then
													v236 = v84.HandleIncorporeal(v60.Paralysis, v62.ParalysisMouseover, 20);
													if ((2030 >= 181) and v236) then
														return v236;
													end
													break;
												end
											end
										end
										v234 = 1;
									end
									if ((v234 == 1) or (4902 == 3748)) then
										v71 = not v60[LUAOBFUSACTOR_DECRYPT_STR_0("\132\64\87\123\59\79\149\91\68\122\4\66\168\121\73\125\36\79\153\71\70\113\34", "\42\205\46\33\20\80")]:IsAvailable() or (120 > v68);
										v72 = not (v14:DebuffRemains(v60.SkyreachExhaustionDebuff) < 1) and (v60[LUAOBFUSACTOR_DECRYPT_STR_0("\99\1\58\190\95\15\26\162\95\35\32\180\90", "\215\49\104\73")]:CooldownRemains() < 1) and (v13:HasTier(30, 2) or (v66 < 5));
										v235 = v84.HandleDPSPotion(v13:BuffUp(v60.BonedustBrewBuff) or v13:BuffUp(v60.Serenity) or v13:BuffUp(v60.FaelineStomp) or v69);
										if ((4456 >= 1806) and v235) then
											return v235;
										end
										v234 = 2;
									end
								end
							end
							v226 = 1;
						end
					end
				end
				break;
			end
			if ((v180 == 1) or (4603 <= 1854)) then
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\155\201\83\58\1\82\150", "\95\207\166\52\93\109\55\229")][LUAOBFUSACTOR_DECRYPT_STR_0("\222\199\53", "\205\189\163\70\226\136\86")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\118\222\130\234\28\238\81", "\139\34\177\229\141\112")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\228\107\164\213\47", "\176\67\141\24\212")];
				v64 = v13:GetEnemiesInMeleeRange(5);
				v65 = v13:GetEnemiesInMeleeRange(8);
				v180 = 2;
			end
			if ((v180 == 0) or (4864 <= 3795)) then
				v126();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\41\72\181\21\173\10", "\173\45\70\47\210\121\200\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\62\176\134", "\49\81\223\229")];
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\6\137\190\242\62\131\170", "\149\82\230\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\57\93\127", "\202\88\50\26")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\118\225\208\137\82\38", "\55\85\25\134\183\229")][LUAOBFUSACTOR_DECRYPT_STR_0("\120\45\22\163\227", "\72\27\84\117\207\134")];
				v180 = 1;
			end
		end
	end
	local function v128()
		local v181 = 0;
		while true do
			if ((v181 == 0) or (4032 <= 168)) then
				v86();
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\204\75\255\179\179\206\230\240\71\227\247\137\192\228\240\2\227\184\176\206\254\242\77\255\247\166\214\170\222\82\248\180\228\237\229\244\79\218", "\138\155\34\145\215\196\175"));
				v181 = 1;
			end
			if ((4938 > 66) and (v181 == 1)) then
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\131\240\0\198\30\58\81\203\177\235\78\239\6\53\86\128\140\185\24\130\88\107\19\146\250\169\94\130\43\34\29\226\187\246\3\233", "\160\212\153\110\162\105\91\61"));
				break;
			end
		end
	end
	v21.SetAPL(269, v127, v128);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\133\40\163\199\159\21\165\209\171\7\157\214\174\60\189\222\172\51\175\205\238\52\191\222", "\191\192\88\202")]();

