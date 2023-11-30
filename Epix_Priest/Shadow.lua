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
		if ((3730 >= 1333) and (v5 == 1)) then
			return v6(...);
		end
		if ((v5 == 0) or (2152 == 2797)) then
			v6 = v0[v4];
			if (not v6 or (1709 < 588)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\139\213\23\212\208\207\26\213\179\198\26\222\212\149\41\243\186", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\159\37\2\49\118\177", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\118\216\34", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\218\88\164\83\239", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\133\114\105\59\22\91\236\70\186", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = EpicLib;
	local v21 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\100\67\3\55\70", "\69\41\34\96")];
	local v22 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\50\168\142\36\202", "\185\98\218\235\87")];
	local v24 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205\137\222\46\52\233\204", "\202\171\92\71\134\190")];
	local v25 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local v26 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local v27 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\202\93\126", "\126\167\52\16\116\217")];
	local v28 = 0;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = false;
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
	local v80 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\248\60\41\133\167\13", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\230\164\202\8\249", "\174\103\142\197")];
	local v81 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\102\58\86\61\54\74", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\231\204\239\88\219\211", "\60\180\164\142")];
	local v82 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\104\76\12\44\52\249", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\225\218\192\183\254", "\164\216\137\187")];
	local v83 = {};
	local v84, v85, v86;
	local v87, v88;
	local v89 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\241\233\60\191\169\240\24", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\24\135\212\179\55\0\135", "\202\88\110\226\166")];
	local v90;
	local v91 = 11111;
	local v92 = 11111;
	local v93 = false;
	local v94 = false;
	local v95 = 0;
	local v96 = false;
	local v97 = false;
	local v98 = false;
	local v99 = false;
	local v100 = false;
	local v101 = ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\238\6\140\243\200\198\1\134\242\216", "\170\163\111\226\151")]:IsAvailable()) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\60\57\188\60\76\50\39\21\53\160", "\73\113\80\210\88\46\87")]) or v80[LUAOBFUSACTOR_DECRYPT_STR_0("\178\36\204\22\232\150\42\196\23\233\133", "\135\225\76\173\114")];
	local v102 = false;
	local v103 = 0;
	local v104 = false;
	local v105 = nil;
	local v106;
	local v107;
	v10:RegisterForEvent(function()
		local v145 = 0;
		while true do
			if ((v145 == 2) or (3575 <= 3202)) then
				v97 = false;
				v98 = false;
				v99 = false;
				v100 = false;
				v145 = 3;
			end
			if ((v145 == 1) or (4397 < 3715)) then
				VarMindSearCutoff = 2;
				VarPoolAmount = 60;
				v95 = 0;
				v96 = false;
				v145 = 2;
			end
			if ((0 == v145) or (4075 <= 2245)) then
				v91 = 11111;
				v92 = 11111;
				v93 = false;
				v94 = false;
				v145 = 1;
			end
			if ((v145 == 3) or (3966 > 4788)) then
				v102 = false;
				v103 = 0;
				v104 = false;
				v105 = nil;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\42\193\153\137\137\143\152\40\200\159\149\130\130\130\52\204\154\156\137\153", "\199\122\141\216\208\204\221"));
	local function v108()
		v89[LUAOBFUSACTOR_DECRYPT_STR_0("\137\212\3\224\125\250\161\220\18\252\125\210\168\223\5\246\126\229", "\150\205\189\112\144\24")] = v89[LUAOBFUSACTOR_DECRYPT_STR_0("\1\141\172\92\1\132\29\17\39\136\186\104\13\155\20\17\54\129\155\73\6\157\23\22\54", "\112\69\228\223\44\100\232\113")];
	end
	v10:RegisterForEvent(function()
		v108();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\245\60\51\250\128\89\185\228\51\38\234\147\78\185\231\47\34\240\159\93\170\253\37\38\231\159\83\168\235\60\47\242\152\91\163\240", "\230\180\127\103\179\214\28"));
	v10:RegisterForEvent(function()
		v101 = ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\161\12\81\66\230\68\238\136\0\77", "\128\236\101\63\38\132\33")]:IsAvailable()) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\129\160\31\64\180\238\193\168\172\3", "\175\204\201\113\36\214\139")]) or v80[LUAOBFUSACTOR_DECRYPT_STR_0("\116\196\52\216\11\80\202\60\217\10\67", "\100\39\172\85\188")];
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\158\72\156\172\31\158\71\154\168\18\131\95\156\164", "\83\205\24\217\224"), LUAOBFUSACTOR_DECRYPT_STR_0("\202\224\236\15\200\224\233\2\213\245\232\17\202\250\228\19\217\241\236\31", "\93\134\165\173"));
	v10:RegisterForEvent(function()
		local v148 = 0;
		while true do
			if ((3826 > 588) and (v148 == 0)) then
				v80[LUAOBFUSACTOR_DECRYPT_STR_0("\141\250\192\198\53\217\145\108\191\225\201", "\30\222\146\161\162\90\174\210")]:RegisterInFlightEffect(205386);
				v80[LUAOBFUSACTOR_DECRYPT_STR_0("\214\70\113\14\234\89\83\24\228\93\120", "\106\133\46\16")]:RegisterInFlight();
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\116\5\82\206\116\101\124\31\64\204\127\108\116\31\90\210\101\116\121\2", "\32\56\64\19\156\58"));
	v80[LUAOBFUSACTOR_DECRYPT_STR_0("\105\192\228\82\85\229\163\72\201\246\94", "\224\58\168\133\54\58\146")]:RegisterInFlightEffect(205386);
	v80[LUAOBFUSACTOR_DECRYPT_STR_0("\106\94\74\249\122\145\164\25\88\69\67", "\107\57\54\43\157\21\230\231")]:RegisterInFlight();
	local function v109()
		local v149 = 0;
		local v150;
		while true do
			if ((694 <= 1507) and (1 == v149)) then
				if ((3900 >= 1116) and v13:BuffUp(v80.DarkEvangelismBuff)) then
					v150 = v150 * (1 + (0.01 * v13:BuffStack(v80.DarkEvangelismBuff)));
				end
				if ((4907 > 3311) and (v13:BuffUp(v80.DevouredFearBuff) or v13:BuffUp(v80.DevouredPrideBuff))) then
					v150 = v150 * 1.05;
				end
				v149 = 2;
			end
			if ((v149 == 2) or (3408 <= 2617)) then
				if ((3201 == 3201) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\255\130\2\225\182\206\219\222\143\35\240\184\208\198\207\146", "\175\187\235\113\149\217\188")]:IsAvailable()) then
					v150 = v150 * 1.2;
				end
				if ((2195 == 2195) and v13:BuffUp(v80.MindDevourerBuff)) then
					v150 = v150 * 1.2;
				end
				v149 = 3;
			end
			if ((v149 == 0) or (3025 > 3506)) then
				v150 = 1;
				if (v13:BuffUp(v80.DarkAscensionBuff) or (736 < 356)) then
					v150 = v150 * 1.25;
				end
				v149 = 1;
			end
			if ((1171 <= 2774) and (3 == v149)) then
				if ((4108 >= 312) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\10\160\136\72\247\118\109\63\167\132\72", "\24\92\207\225\44\131\25")]:IsAvailable()) then
					v150 = v150 * 1.06;
				end
				return v150;
			end
		end
	end
	v80[LUAOBFUSACTOR_DECRYPT_STR_0("\111\214\174\67\14\111\66\221\191\124\23\124\76\198\189", "\29\43\179\216\44\123")]:RegisterPMultiplier(v80.DevouringPlagueDebuff, v109);
	local function v110(v151, v152)
		if (v152 or (679 > 2893)) then
			return v151:DebuffUp(v80.ShadowWordPainDebuff) and v151:DebuffUp(v80.VampiricTouchDebuff) and v151:DebuffUp(v80.DevouringPlagueDebuff);
		else
			return v151:DebuffUp(v80.ShadowWordPainDebuff) and v151:DebuffUp(v80.VampiricTouchDebuff);
		end
	end
	local function v111(v153, v154)
		local v155 = 0;
		local v156;
		local v157;
		while true do
			if ((1 == v155) or (876 < 200)) then
				v157 = nil;
				for v221, v222 in pairs(v153) do
					local v223 = 0;
					local v224;
					while true do
						if ((v223 == 0) or (2325 > 3562)) then
							v224 = v222:TimeToDie();
							if (v154 or (3661 > 4704)) then
								if (((v224 * v25(v222:DebuffRefreshable(v80.VampiricTouchDebuff))) > v156) or (4133 <= 1928)) then
									local v242 = 0;
									while true do
										if ((4418 >= 1433) and (v242 == 0)) then
											v156 = v224;
											v157 = v222;
											break;
										end
									end
								end
							elseif ((v224 > v156) or (4123 >= 4123)) then
								local v243 = 0;
								while true do
									if ((v243 == 0) or (205 >= 2345)) then
										v156 = v224;
										v157 = v222;
										break;
									end
								end
							end
							break;
						end
					end
				end
				v155 = 2;
			end
			if ((v155 == 0) or (537 == 1004)) then
				if (not v153 or (2345 < 545)) then
					return nil;
				end
				v156 = 0;
				v155 = 1;
			end
			if ((1649 > 243) and (v155 == 2)) then
				return v157;
			end
		end
	end
	local function v112(v158)
		return (v158:DebuffRemains(v80.ShadowWordPainDebuff));
	end
	local function v113(v159)
		return (v159:TimeToDie());
	end
	local function v114(v160)
		return (v160:DebuffRemains(v80.VampiricTouchDebuff));
	end
	local function v115(v161)
		return v161:DebuffRefreshable(v80.VampiricTouchDebuff) and (v161:TimeToDie() >= 12) and (((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\142\209\33\72\178\206\3\94\188\202\40", "\44\221\185\64")]:CooldownRemains() >= v161:DebuffRemains(v80.VampiricTouchDebuff)) and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\50\239\73\91\124\22\196\90\94\96\9", "\19\97\135\40\63")]:InFlight()) or v98 or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\153\84\58\40\63\52\188\85\61\60\28\57\175\88\60\44\60", "\81\206\60\83\91\79")]:IsAvailable());
	end
	local function v116(v162)
		return not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\106\162\195\102\32\209\89\161\74\153\213\115\35\202\89\189", "\196\46\203\176\18\79\163\45")]:IsAvailable() or (v88 == 1) or (v162:DebuffRemains(v80.DevouringPlagueDebuff) <= v107) or (v13:InsanityDeficit() <= 16);
	end
	local function v117(v163)
		return (v163:DebuffRemains(v80.DevouringPlagueDebuff) <= v107) or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\156\43\109\10\43\233\251\189\38\76\27\37\247\230\172\59", "\143\216\66\30\126\68\155")]:IsAvailable();
	end
	local function v118(v164)
		return ((v164:DebuffRemains(v80.DevouringPlagueDebuff) > v80[LUAOBFUSACTOR_DECRYPT_STR_0("\135\193\3\207\231\175\214\242\190", "\129\202\168\109\171\165\195\183")]:ExecuteTime()) and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\15\81\57\220\252\24\231\49\76", "\134\66\56\87\184\190\116")]:FullRechargeTime() <= (v107 + v80[LUAOBFUSACTOR_DECRYPT_STR_0("\17\56\7\191\59\231\32\38\40", "\85\92\81\105\219\121\139\65")]:ExecuteTime()))) or (v103 <= (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\208\186\94\65\94\211\252\160\68", "\191\157\211\48\37\28")]:ExecuteTime() + v107));
	end
	local function v119(v165)
		return v110(v165, true) and (v165:DebuffRemains(v80.DevouringPlagueDebuff) >= v80[LUAOBFUSACTOR_DECRYPT_STR_0("\242\22\250\24\61\222\18\241\15", "\90\191\127\148\124")]:CastTime());
	end
	local function v120(v166)
		return v166:DebuffRefreshable(v80.VampiricTouchDebuff) or ((v166:DebuffRemains(v80.VampiricTouchDebuff) <= v166:TimeToDie()) and v13:BuffDown(v80.VoidformBuff));
	end
	local function v121(v167)
		return ((v167:HealthPercentage() < 20) and ((v101:CooldownRemains() >= 10) or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\81\137\43\4\123\134\62\22\122\139\43\35\119\149\35\18\118\147", "\119\24\231\78")]:IsAvailable())) or (v102 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\171\35\160\89\223\65\1\131\47\169\79\232\79\3\143\40\171\94", "\113\226\77\197\42\188\32")]:IsAvailable()) or v13:BuffUp(v80.DeathspeakerBuff);
	end
	local function v122(v168)
		return (v168:HealthPercentage() < 20) or v13:BuffUp(v80.DeathspeakerBuff) or v13:HasTier(31, 2);
	end
	local function v123(v169)
		return v169:HealthPercentage() < 20;
	end
	local function v124(v170)
		return v170:DebuffUp(v80.DevouringPlagueDebuff) and (v103 <= 2) and v102 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\19\24\241\166\57\23\228\180\56\26\241\129\53\4\249\176\52\2", "\213\90\118\148")]:IsAvailable() and (v88 <= 7);
	end
	local function v112(v171)
		return (v171:DebuffRemains(v80.ShadowWordPainDebuff));
	end
	local function v125(v172)
		return v172:DebuffRemains(v80.DevouringPlagueDebuff) >= 2.5;
	end
	local function v126(v173)
		return v173:DebuffRefreshable(v80.VampiricTouchDebuff) and (v173:TimeToDie() >= 18) and (v173:DebuffUp(v80.VampiricTouchDebuff) or not v97);
	end
	local function v127(v174)
		local v175 = 0;
		while true do
			if ((v175 == 0) or (3910 <= 3193)) then
				if ((2005 == 2005) and ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\104\38\181\82\66\76\13\166\87\94\83", "\45\59\78\212\54")]:CooldownRemains() >= v174:DebuffRemains(v80.VampiricTouchDebuff)) or v98)) then
					return v174:DebuffRefreshable(v80.VampiricTouchDebuff) and (v174:TimeToDie() >= 18) and (v174:DebuffUp(v80.VampiricTouchDebuff) or not v97);
				end
				return nil;
			end
		end
	end
	local function v128(v176)
		return (v110(v176, false));
	end
	local function v129()
		local v177 = 0;
		local v178;
		while true do
			if ((4688 > 4572) and (v177 == 2)) then
				if ((1567 < 3260) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\55\51\11\42\84\19\59\5\14\82\20\49\14", "\61\97\82\102\90")]:IsCastable() and (not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\159\38\170\79\200\64\61\27\173\61\163", "\105\204\78\203\43\167\55\126")]:IsAvailable() or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\150\162\34\26\28\19\228\67\164\185\43", "\49\197\202\67\126\115\100\167")]:CooldownDown() and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\4\83\222\45\143\65\125\37\90\204\33", "\62\87\59\191\73\224\54")]:InFlight()) or v178)) then
					if (v23(v80.VampiricTouch, not v14:IsSpellInRange(v80.VampiricTouch), true) or (3761 == 621)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\241\3\247\217\238\16\243\202\216\22\245\220\228\10\186\217\245\7\249\198\234\0\251\221\167\83\174", "\169\135\98\154");
					end
				end
				if ((4755 > 3454) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\248\127\37\80\242\36\255\196\101\32\100\252\58\198", "\168\171\23\68\52\157\83")]:IsCastable() and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\217\120\230\168\55\52", "\231\148\17\149\205\69\77")]:IsAvailable()) then
					if ((4819 >= 1607) and v23(v80.ShadowWordPain, not v14:IsSpellInRange(v80.ShadowWordPain))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\147\175\198\255\88\232\191\176\200\233\83\192\144\166\206\245\23\239\146\162\196\244\90\253\129\179\135\170\1", "\159\224\199\167\155\55");
					end
				end
				break;
			end
			if ((4546 >= 1896) and (v177 == 0)) then
				v105 = v14:GUID();
				if ((3546 > 933) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\49\68\128\138\136\43\153\255\2\68\134\133\146", "\144\112\54\227\235\230\78\205")]:IsCastable() and v30) then
					if (v23(v80.ArcaneTorrent, not v14:IsSpellInRange(v80.ArcaneTorrent)) or (3985 <= 3160)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\58\12\253\222\94\140\60\0\238\194\94\189\60\79\236\194\94\176\39\2\254\209\79\243\126", "\59\211\72\111\156\176");
					end
				end
				v177 = 1;
			end
			if ((1987 == 1987) and (1 == v177)) then
				v178 = v13:IsInParty() and not v13:IsInRaid();
				if ((994 <= 4540) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\125\143\226\41\65\144\192\63\79\148\235", "\77\46\231\131")]:IsCastable() and not v178) then
					if ((4917 == 4917) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\153\91\184\70\179\70\187", "\32\218\52\214"))) then
						if (v23(v80.ShadowCrash, not v14:IsInRange(40)) or (324 > 4896)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\93\31\48\172\254\167\122\89\92\22\34\160\177\160\87\95\77\24\60\170\240\164\5\2", "\58\46\119\81\200\145\208\37");
						end
					elseif ((772 < 4670) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\14\130\53\161\176\253\3\37\136\53\190\233\158\35\57\159\63\190", "\86\75\236\80\204\201\221"))) then
						if ((3172 >= 2578) and v17:Exists() and v13:CanAttack(v17)) then
							if (v23(v82.ShadowCrashCursor, not v14:IsInRange(40)) or (721 == 834)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\97\73\118\129\241\156\77\66\101\132\237\131\50\81\101\128\253\132\127\67\118\145\190\211", "\235\18\33\23\229\158");
							end
						end
					elseif ((1312 < 2654) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\113\174\129\152\69\168\210\180\66", "\219\48\218\161"))) then
						if ((3213 >= 1613) and v23(v82.ShadowCrashCursor, not v14:IsInRange(40))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\247\121\125\77\212\88\223\231\99\125\90\211\15\240\246\116\127\70\214\77\225\240\49\36", "\128\132\17\28\41\187\47");
						end
					end
				end
				v177 = 2;
			end
		end
	end
	local function v130()
		local v179 = 0;
		while true do
			if ((v179 == 0) or (3786 > 4196)) then
				v93 = v110(v14, false) or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\196\251\61\214\248\228\31\192\246\224\52", "\178\151\147\92")]:InFlight() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\187\245\69\33\2\73\104\133\243\75\1\26\77\126\131\234\95", "\26\236\157\44\82\114\44")]:IsAvailable());
				v94 = v110(v14, true);
				v179 = 1;
			end
			if ((4218 == 4218) and (v179 == 1)) then
				v100 = ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\28\33\220\95\15\60\192\75\62\39\218\85", "\59\74\78\181")]:CooldownRemains() <= (v13:GCD() * 3)) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\19\222\83\94\150\55\196\74\78\186\42\223", "\211\69\177\58\58")]:IsAvailable()) or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\147\228\107\254\200\216\180\224\119\230\224\196\185", "\171\215\133\25\149\137")]:CooldownUp() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\197\201\32\241\206\35\255\71\239\219\59\245\225", "\34\129\168\82\154\143\80\156")]:IsAvailable()) or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\179\189\58\15\124\65\155\151\183\61\31", "\233\229\210\83\107\40\46")]:IsAvailable() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\241\81\43\213\13\200\65\30\223\11\202", "\101\161\34\82\182")]:IsAvailable() and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\222\2\80\250\239\237\144\60\237\3\77", "\78\136\109\57\158\187\130\226")]:CooldownRemains() <= 4) and v13:BuffDown(v80.VoidformBuff));
				break;
			end
		end
	end
	local function v131()
		local v180 = 0;
		local v181;
		while true do
			if ((1517 < 4050) and (0 == v180)) then
				v95 = v27(v88, v79);
				v96 = false;
				v180 = 1;
			end
			if ((4390 == 4390) and (v180 == 2)) then
				v97 = ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\8\62\244\225\55\45\240\242\10\48\236\242\54\27\252\243\43\57\255", "\145\94\95\153")]:AuraActiveCount() + (8 * v25(v80[LUAOBFUSACTOR_DECRYPT_STR_0("\206\197\21\209\65\160\222\223\21\198\70", "\215\157\173\116\181\46")]:InFlight() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\2\188\130\225\202\48\166\130\252\221\6\188\138\246\213\34\167", "\186\85\212\235\146")]:IsAvailable()))) >= v95) or not v96;
				if ((1919 > 289) and v98 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\245\137\31\237\41\235\74\203\143\17\205\49\239\92\205\150\5", "\56\162\225\118\158\89\142")]:IsAvailable()) then
					v98 = (v95 - v80[LUAOBFUSACTOR_DECRYPT_STR_0("\106\4\205\191\43\202\85\6\244\160\55\219\84\33\197\173\55\222\90", "\184\60\101\160\207\66")]:AuraActiveCount()) < 4;
				end
				v180 = 3;
			end
			if ((3 == v180) or (1205 < 751)) then
				v99 = ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\7\131\113\172\56\144\117\191\5\141\105\191\57\166\121\190\36\132\122", "\220\81\226\28")]:AuraActiveCount() + (8 * v25(not v98))) >= v95) or not v96;
				break;
			end
			if ((v180 == 1) or (2561 <= 1717)) then
				v181 = v111(v86, true);
				if ((1723 <= 3600) and v181 and (v181:TimeToDie() >= 18)) then
					v96 = true;
				end
				v180 = 2;
			end
		end
	end
	local function v132()
		if ((3271 >= 1633) and (v13:BuffUp(v80.VoidformBuff) or v13:BuffUp(v80.PowerInfusionBuff) or v13:BuffUp(v80.DarkAscensionBuff) or (v92 < 20))) then
			local v193 = 0;
			while true do
				if ((3103 >= 2873) and (v193 == 1)) then
					v90 = v89.HandleBottomTrinket(v83, CDs, 40, nil);
					if (v90 or (3603 == 725)) then
						return v90;
					end
					break;
				end
				if ((2843 == 2843) and (v193 == 0)) then
					v90 = v89.HandleTopTrinket(v83, CDs, 40, nil);
					if (v90 or (174 >= 2515)) then
						return v90;
					end
					v193 = 1;
				end
			end
		end
	end
	local function v133()
		local v182 = 0;
		while true do
			if ((4411 >= 2020) and (v182 == 0)) then
				if ((1347 == 1347) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\32\221\131\255\229\208\48\199\131\232\226", "\167\115\181\226\155\138")]:IsCastable() and (v14:DebuffDown(v80.VampiricTouchDebuff))) then
					if ((4461 == 4461) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\193\45\233\90\114\99\203", "\166\130\66\135\60\27\17"))) then
						if (v23(v80.ShadowCrash, not v14:IsInRange(40)) or (4340 == 2872)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\87\66\207\113\63\83\117\205\103\49\87\66\142\122\32\65\68\203\103\112\22", "\80\36\42\174\21");
						end
					elseif ((568 <= 2207) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\107\30\50\119\87\80\2\116\74\21\37\58\109\5\37\105\65\2", "\26\46\112\87"))) then
						if ((v17:Exists() and v13:CanAttack(v17)) or (3789 <= 863)) then
							if ((238 < 4997) and v23(v82.ShadowCrashCursor, not v14:IsInRange(40))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\170\43\170\112\176\168\122\183\171\34\184\124\255\176\85\177\183\38\185\52\237", "\212\217\67\203\20\223\223\37");
							end
						end
					elseif ((4285 > 3803) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\155\153\232\241\175\159\187\221\168", "\178\218\237\200"))) then
						if ((2672 < 4910) and v23(v82.ShadowCrashCursor, not v14:IsInRange(40))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\165\189\231\212\185\162\217\211\164\180\245\216\246\186\246\213\184\176\244\144\228", "\176\214\213\134");
						end
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\194\172\187\196\161\68\80\247\153\185\193\171\94", "\57\148\205\214\180\200\54")]:IsCastable() and v14:DebuffDown(v80.VampiricTouchDebuff) and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\33\245\52\48\121\5\222\39\53\101\26", "\22\114\157\85\84")]:CooldownDown() or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\247\195\18\192\82\225\139\214\202\0\204", "\200\164\171\115\164\61\150")]:IsAvailable())) or (2956 > 4353)) then
					if ((3534 > 2097) and v22(v80.VampiricTouch, nil, nil, not v14:IsSpellInRange(v80.VampiricTouch))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\245\14\85\138\172\253\0\122\151\177\225\0\77\195\177\228\6\75\134\172\180\80", "\227\222\148\99\37");
					end
				end
				if ((3255 >= 534) and v101:IsCastable() and v30) then
					if ((4254 < 4460) and v23(v101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\91\92\242\251\54\92\86\243\235\115\93\66\243\247\54\64\18\162", "\153\83\50\50\150");
					end
				end
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\121\119\97\23\82\184\78\88\120\96\21\124\165", "\45\61\22\19\124\19\203")]:IsCastable() or (4661 <= 4405)) then
					if ((4575 >= 1943) and v23(v80.DarkAscension)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\19\31\254\61\113\170\194\23\3\230\11\127\183\129\29\29\240\12\117\171\129\68", "\217\161\114\109\149\98\16");
					end
				end
				v182 = 1;
			end
			if ((2 == v182) or (326 > 1137)) then
				if ((1284 == 1284) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\38\12\177\89\168\246\30\167\5\57\171\87\186\241\18", "\201\98\105\199\54\221\132\119")]:IsReady()) then
					if (v23(v80.DevouringPlague, not v14:IsSpellInRange(v80.DevouringPlague)) or (3072 >= 3426)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\189\9\149\46\23\39\165\183\11\188\49\14\52\171\172\9\195\46\18\48\162\188\30\195\112\90", "\204\217\108\227\65\98\85");
					end
				end
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\115\202\251\225\14\204\95\208\225", "\160\62\163\149\133\76")]:IsCastable() or (4036 > 4375)) then
					if ((3928 == 3928) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\169\3\43\252\212\172\12\60\215\150\175\29\42\205\211\178\77\125\147", "\163\182\192\109\79");
					end
				end
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\25\47\14\196\198\36\47\11\197", "\149\84\70\96\160")]:IsCastable() or (2629 >= 3005)) then
					if (v23(v80.MindSpike, not v14:IsSpellInRange(v80.MindSpike), true) or (2620 <= 422)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\15\3\233\7\21\29\228\51\3\77\226\40\3\3\232\42\70\95\191", "\141\88\102\109");
					end
				end
				if ((1896 > 1857) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\158\90\196\116\60\49\84\216", "\161\211\51\170\16\122\93\53")]:IsCastable()) then
					if ((1466 >= 492) and v23(v80.MindFlay, not v14:IsSpellInRange(v80.MindFlay), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\167\188\44\196\168\190\41\226\238\189\56\254\160\183\58\187\252\230", "\72\155\206\210");
					end
				end
				break;
			end
			if ((868 < 3853) and (v182 == 1)) then
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\36\47\49\120\153\102\7\48\44\117\179\122", "\20\114\64\88\28\220")]:IsAvailable() or (1815 > 4717)) then
					local v225 = 0;
					while true do
						if ((3671 == 3671) and (v225 == 1)) then
							if ((216 <= 284) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\248\113\187\7\160\220\107\162\23\140\193\112", "\229\174\30\210\99")]:IsCastable()) then
								if ((3257 > 2207) and v23(v80.VoidEruption, not v14:IsInRange(40), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\13\226\143\85\210\56\43\14\253\146\88\226\51\121\20\253\131\95\232\47\121\74\191", "\89\123\141\230\49\141\93");
								end
							end
							break;
						end
						if ((0 == v225) or (2087 < 137)) then
							if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\2\9\211\176\247\199\138\62\19\214\144\253\209\169\57", "\221\81\97\178\212\152\176")]:IsCastable() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\228\233\24\232\25\204\247\28\249\22\200\211\18\233\23\200\233\9", "\122\173\135\125\155")]:IsAvailable() and v13:PrevGCDP(1, v80.MindBlast) and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\183\201\1\189\48\38\255\139\211\4\157\58\48\220\140", "\168\228\161\96\217\95\81")]:TimeSinceLastCast() > 20)) or (3923 >= 4763)) then
								if ((1744 == 1744) and v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\200\217\47\88\32\64\228\198\33\78\43\104\223\212\47\72\39\23\212\193\43\82\42\69\155\137", "\55\187\177\78\60\79");
								end
							end
							if ((248 <= 1150) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\0\199\81\239\100\195\129\62\218", "\224\77\174\63\139\38\175")]:IsCastable()) then
								if ((3994 >= 294) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\137\72\86\42\187\67\84\47\151\85\24\33\148\68\86\43\150\1\9\126", "\78\228\33\56");
								end
							end
							v225 = 1;
						end
					end
				end
				v90 = v132();
				if ((1641 > 693) and v90) then
					return v90;
				end
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\197\126\255\8\50\69\255\101", "\42\147\17\150\108\112")]:IsCastable() or (4519 < 2235)) then
					if ((892 < 1213) and v23(v80.VoidBolt, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\25\169\36\123\216\234\0\170\57\63\232\248\10\168\40\109\167\185\89", "\136\111\198\77\31\135");
					end
				end
				v182 = 2;
			end
		end
	end
	local function v134()
		local v183 = 0;
		while true do
			if ((3313 <= 4655) and (v183 == 1)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\45\122\12\123\109\2\139\25", "\234\96\19\98\31\43\110")]:IsCastable() and (v13:BuffUp(v80.MindFlayInsanityBuff))) or (3956 < 2705)) then
					if ((1959 < 3037) and v23(v80.MindSpike, not v14:IsSpellInRange(v80.MindSpike), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\11\22\92\195\147\116\135\7\6\18\193\165\126\135\3\13\18\159", "\235\102\127\50\167\204\18");
					end
				end
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\125\168\251\39\67\47\93\164\230", "\78\48\193\149\67\36")]:IsReady() or (1241 > 2213)) then
					if ((4905 < 4974) and v23(v80.Mindgames, not v14:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\23\142\28\70\49\19\133\11\1\54\23\140\20\68\34\94\209\72", "\33\80\126\224\120");
					end
				end
				if ((3557 == 3557) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\223\160\2\192\83\251\159\12\214\88\200\173\2\208\84", "\60\140\200\99\164")]:IsReady() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\174\250\1\53\161\134\228\5\36\174\130\192\11\52\175\130\250\16", "\194\231\148\100\70")]:IsAvailable() and v102) then
					if ((369 == 369) and v89.CastTargetIf(v80.ShadowWordDeath, v85, LUAOBFUSACTOR_DECRYPT_STR_0("\75\69\207", "\168\38\44\161\195\150"), v113, nil, not v14:IsSpellInRange(v80.ShadowWordDeath), nil, nil, v82.ShadowWordDeathMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\147\244\131\114\63\255\137\1\143\238\134\73\52\237\183\2\136\188\132\127\60\228\179\4\192\173\208", "\118\224\156\226\22\80\136\214");
					end
				end
				v183 = 2;
			end
			if ((v183 == 3) or (3589 < 2987)) then
				if ((4378 > 2853) and v106:IsCastable()) then
					if (v23(v106, not v14:IsSpellInRange(v106), true) or (1712 > 3602)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\113\254\39\50\12\162\112\246\48\118\53\173\112\251\44\36\115\245\36", "\196\28\151\73\86\83");
					end
				end
				if ((4539 >= 2733) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\192\11\40\20\141\79\59\100\242\16\33", "\22\147\99\73\112\226\56\120")]:IsCastable()) then
					if ((v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\155\122\236\243\132\170\120", "\237\216\21\130\149")) or (2599 <= 515)) then
						if (v23(v80.ShadowCrash, not v14:IsInRange(40)) or (3754 < 810)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\145\70\94\91\191\222\97\129\92\94\76\184\137\88\139\66\83\90\162\137\12\210", "\62\226\46\63\63\208\169");
						end
					elseif ((1633 <= 1977) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\192\23\80\142\6\77\26\80\225\28\71\195\60\24\61\77\234\11", "\62\133\121\53\227\127\109\79"))) then
						if ((4528 >= 3619) and v17:Exists() and v13:CanAttack(v17)) then
							if (v23(v82.ShadowCrashCursor, not v14:IsInRange(40)) or (172 >= 2092)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\3\28\51\241\217\185\157\19\6\51\230\222\238\164\25\24\62\240\196\238\240\64", "\194\112\116\82\149\182\206");
							end
						end
					elseif ((2120 == 2120) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\24\188\12\59\213\240\29\54\186", "\110\89\200\44\120\160\130"))) then
						if (v23(v82.ShadowCrashCursor, not v14:IsInRange(40)) or (2398 == 358)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\184\203\74\66\76\93\4\78\185\194\88\78\3\76\50\65\167\198\89\6\17\26", "\45\203\163\43\38\35\42\91");
						end
					end
				end
				if ((2387 < 4637) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\225\141\221\39\136\190\99\221\151\216\7\130\168\64\218", "\52\178\229\188\67\231\201")]:IsReady()) then
					if ((1265 < 2775) and v89.CastCycle(v80.ShadowWordDeath, v85, v123, not v14:IsSpellInRange(v80.ShadowWordDeath), nil, nil, v82.ShadowWordDeathMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\50\73\81\0\248\75\28\54\78\66\0\200\88\38\32\85\88\68\241\85\47\45\68\66\68\165\14", "\67\65\33\48\100\151\60");
					end
				end
				v183 = 4;
			end
			if ((v183 == 0) or (4430 < 51)) then
				if ((1871 <= 1998) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\112\123\89\30\58\84\115\87\58\60\83\121\92", "\83\38\26\52\110")]:IsCastable() and (v13:BuffUp(v80.UnfurlingDarknessBuff))) then
					if (v89.CastTargetIf(v80.VampiricTouch, v85, LUAOBFUSACTOR_DECRYPT_STR_0("\85\30\41", "\38\56\119\71"), v114, nil, not v14:IsSpellInRange(v80.VampiricTouch), nil, nil, nil, true) or (2083 >= 3954)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\238\85\198\44\68\250\236\103\194\42\67\240\231\24\208\44\90\255\234\74\150\119", "\54\147\143\56\182\69");
					end
				end
				if ((1857 > 59) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\229\137\254\77\208\193\182\240\91\219\242\132\254\93\215", "\191\182\225\159\41")]:IsReady()) then
					if (v89.CastCycle(v80.ShadowWordDeath, v85, v122, not v14:IsSpellInRange(v80.ShadowWordDeath), nil, nil, v82.ShadowWordDeathMouseover) or (1232 == 3045)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\26\41\81\132\144\253\60\29\58\81\180\131\199\42\6\32\21\141\142\206\39\23\58\21\223", "\162\75\114\72\53\235\231");
					end
				end
				if ((104 == 104) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\161\53\74\230\96\18\133\55\65\203\93\17\141\50\77\246\74", "\98\236\92\36\130\51")]:IsReady()) then
					if ((4534 > 2967) and v23(v80.MindSpikeInsanity, not v14:IsSpellInRange(v80.MindSpikeInsanity), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\16\2\190\122\187\165\57\175\28\51\179\75\187\180\62\173\13\21\250\67\161\185\60\161\11\76\236", "\80\196\121\108\218\37\200\213");
					end
				end
				v183 = 1;
			end
			if ((2 == v183) or (3449 <= 2368)) then
				if ((4733 >= 3548) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\102\231\79\137\76\235\106\148\67\252", "\224\34\142\57")]:IsReady() and (v16:HealthPercentage() < DivineStarHP) and v66) then
					if (v23(v82.DivineStarPlayer, not v16:IsInRange(30)) or (2005 > 4687)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\218\174\211\212\125\244\98\29\202\166\215\157\123\244\92\2", "\110\190\199\165\189\19\145\61");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\242\234\123\231", "\167\186\139\23\136\235")]:IsReady() and v89.TargetIsValid() and v14:IsInRange(30) and v63 and v89.AreUnitsBelowHealthPercentage(v64, v65)) or (1767 <= 916)) then
					if ((3589 < 3682) and v23(v80.Halo, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\180\132\2\90\189\141\12\22", "\109\122\213\232");
					end
				end
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\195\254\172\52\221\231\171\59\235", "\80\142\151\194")]:IsCastable() or (75 >= 430)) then
					if (v23(v80.MindSpike, not v14:IsSpellInRange(v80.MindSpike), true) or (4157 <= 3219)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\14\207\121\72\60\213\103\69\8\195\55\74\10\202\123\73\17\134\38\26", "\44\99\166\23");
					end
				end
				v183 = 3;
			end
			if ((1823 < 2782) and (v183 == 4)) then
				if ((3434 >= 1764) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\236\239\175\220\252\200\208\161\202\247\251\226\175\204\251", "\147\191\135\206\184")]:IsReady() and v13:IsMoving()) then
					if ((4040 > 1820) and v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\32\167\197\215\68\141\147\39\180\197\231\87\183\133\60\174\129\213\92\164\129\37\163\207\204\19\180\141\36\170\196\202\19\224\210", "\210\228\72\198\161\184\51");
					end
				end
				if ((4192 >= 2529) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\5\65\242\20\124\217\1\70\225\20\67\207\63\71", "\174\86\41\147\112\19")]:IsReady() and v13:IsMoving()) then
					if ((1554 < 2325) and v89.CastTargetIf(v80.ShadowWordPain, v85, LUAOBFUSACTOR_DECRYPT_STR_0("\86\9\131", "\203\59\96\237\107\69\111\113"), v112, nil, not v14:IsSpellInRange(v80.ShadowWordPain))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\30\173\229\62\231\232\51\25\190\229\14\224\214\45\24\236\231\56\252\219\33\4\236\179\105", "\183\68\118\204\129\81\144");
					end
				end
				break;
			end
		end
	end
	local function v135()
		local v184 = 0;
		while true do
			if ((1108 < 4525) and (v184 == 3)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\193\216\26\56\7\246\218\13\61\53\236\214\6", "\70\133\185\104\83")]:IsCastable() and not v13:IsCasting(v80.DarkAscension) and ((v102 and (v101:CooldownRemains() >= 4)) or (not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\41\76\74\46\203\1\75\64\47\219", "\169\100\37\36\74")]:IsAvailable() and v101:CooldownDown()) or ((v88 > 2) and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\41\137\167\67\3\134\178\81\2\139\167\100\15\149\175\85\14\147", "\48\96\231\194")]:IsAvailable()))) or (4367 <= 3332)) then
					if (v23(v80.DarkAscension) or (2896 > 4641)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\91\28\38\38\217\188\128\205\84\29\36\22\214\239\128\204\73\78\127\75", "\227\168\58\110\77\121\184\207");
					end
				end
				if ((882 > 21) and v30) then
					local v226 = 0;
					while true do
						if ((2373 <= 4789) and (v226 == 0)) then
							v90 = v132();
							if (v90 or (1839 < 1136)) then
								return v90;
							end
							break;
						end
					end
				end
				break;
			end
			if ((3430 == 3430) and (v184 == 1)) then
				if ((748 <= 2288) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\47\61\58\114\9\88\24\35\44", "\30\109\81\85\29\109")]:IsCastable() and (v13:BuffUp(v80.PowerInfusionBuff) or (v92 <= 15))) then
					if ((891 < 4473) and v23(v80.BloodFury)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\125\91\185\50\225\250\234\99\77\246\53\218\239\191\41", "\156\159\17\52\214\86\190");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\143\225\190\185\189\251\175\189\162\204\188\176\162", "\220\206\143\221")]:IsCastable() and (v13:BuffUp(v80.PowerInfusionBuff) or (v92 <= 15))) or (3071 <= 2647)) then
					if (v23(v80.AncestralCall) or (633 > 1640)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\115\46\18\203\216\192\135\113\18\20\217\192\222\198\126\41\4\152\157\130", "\178\230\29\77\119\184\172");
					end
				end
				v184 = 2;
			end
			if ((3764 > 2404) and (v184 == 0)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\40\164\98\225\9\142\1\162\116", "\226\110\205\16\132\107")]:IsCastable() and (v13:BuffUp(v80.PowerInfusionBuff) or (v92 <= 8))) or (3811 >= 4158)) then
					if ((743 > 47) and v23(v80.Fireblood)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\202\242\220\67\231\204\239\221\1\232\199\243\153\21", "\33\139\163\128\185");
					end
				end
				if ((3599 >= 1059) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\117\93\22\205\82\74\15\215\89\95", "\190\55\56\100")]:IsCastable() and (v13:BuffUp(v80.PowerInfusionBuff) or (v92 <= 12))) then
					if ((1371 <= 2507) and v23(v80.Berserking)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\170\46\13\22\241\248\95\161\59\94\16\231\224\22\249", "\147\54\207\92\126\115\131");
					end
				end
				v184 = 1;
			end
			if ((v184 == 2) or (3607 == 2536)) then
				if ((1126 < 3675) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\209\183\28\18\121\253\198\170\11\9", "\152\149\222\106\123\23")]:IsReady() and (v88 > 1) and v81[LUAOBFUSACTOR_DECRYPT_STR_0("\255\35\250\76\167\207\35\250\76\166\201\46\243\112\160\211\37\247\79\185\216\52", "\213\189\70\150\35")]:IsEquipped() and (v81[LUAOBFUSACTOR_DECRYPT_STR_0("\109\80\120\7\93\71\113\4\64\70\96\0\74\102\97\6\76\84\120\4\74\71", "\104\47\53\20")]:CooldownRemains() <= v107)) then
					if (v23(v82.DivineStarPlayer, not v16:IsInRange(30)) or (3344 >= 3615)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\167\69\151\21\178\10\156\95\149\29\174\79\160\72\146\92\237\89", "\111\195\44\225\124\220");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\238\73\9\119\142\185\205\86\20\122\164\165", "\203\184\38\96\19\203")]:IsCastable() and v101:CooldownDown() and ((v102 and (v101:CooldownRemains() >= 4)) or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\20\122\119\69\204\60\125\125\68\220", "\174\89\19\25\33")]:IsAvailable() or ((v88 > 2) and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\6\28\87\93\244\134\27\46\16\94\75\195\136\25\34\23\92\90", "\107\79\114\50\46\151\231")]:IsAvailable())) and ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\20\175\187\45\168\53\182\211\45", "\160\89\198\213\73\234\89\215")]:Charges() == 0) or (v10.CombatTime() > 15))) or (4776 <= 210)) then
					if (v23(v80.VoidEruption) or (2613 > 2752)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\94\126\189\250\250\77\99\161\238\209\65\126\186\190\198\76\98\244\172\149", "\165\40\17\212\158");
					end
				end
				v184 = 3;
			end
		end
	end
	local function v136()
		local v185 = 0;
		while true do
			if ((4542 > 2119) and (v185 == 5)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\151\143\119\247\125\194\37\169\146", "\68\218\230\25\147\63\174")]:IsCastable() and (v13:BuffDown(v80.MindDevourerBuff) or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\155\37\90\72\147\191\63\67\88\191\162\36", "\214\205\74\51\44")]:CooldownUp() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\204\67\235\248\82\232\89\242\232\126\245\66", "\23\154\44\130\156")]:IsAvailable()))) or (1039 == 338)) then
					if (v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true) or (4131 > 4610)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\175\163\170\9\17\29\167\190\186\118\30\16\175\163\238\100\69", "\115\113\198\205\206\86");
					end
				end
				if ((4129 >= 672) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\178\88\247\94\176\88\236\72\129\89\234", "\58\228\55\158")]:IsCastable() and not v98) then
					if ((1019 < 3466) and v89.CastCycle(v80.VoidTorrent, v85, v125, not v14:IsSpellInRange(v80.VoidTorrent), nil, nil, v82.VoidTorrentMouseover, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\162\134\217\42\3\185\58\166\155\213\32\40\237\56\181\128\222\110\110\245", "\85\212\233\176\78\92\205");
					end
				end
				v90 = v134();
				v185 = 6;
			end
			if ((290 <= 855) and (v185 == 0)) then
				v130();
				if ((4601 > 4446) and v30 and ((v92 < 30) or ((v14:TimeToDie() > 15) and (not v98 or (v88 > 2))))) then
					local v227 = 0;
					while true do
						if ((v227 == 0) or (995 >= 2099)) then
							v90 = v135();
							if ((961 < 4006) and v90) then
								return v90;
							end
							break;
						end
					end
				end
				if ((2694 < 4854) and v101:IsCastable() and v93 and ((v92 < 30) or (v14:TimeToDie() > 15)) and (not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\95\61\173\75\144\200\114\160\117\47\182\79\191", "\197\27\92\223\32\209\187\17")]:IsAvailable() or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\39\94\209\240\34\76\192\254\13\76\202\244\13", "\155\99\63\163")]:CooldownRemains() < v107) or (v92 < 15))) then
					if (v23(v101) or (4174 <= 3733)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\143\216\175\137\187\129\140\213\164\159\249\137\131\216\175\205\235", "\228\226\177\193\237\217");
					end
				end
				v185 = 1;
			end
			if ((v185 == 3) or (2626 <= 648)) then
				if ((1595 <= 2078) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\32\234\178\204\36\72\13\225\163\243\61\91\3\250\161", "\58\100\143\196\163\81")]:IsReady() and ((v13:InsanityDeficit() <= 20) or (v13:BuffUp(v80.VoidformBuff) and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\44\77\42\167\29\70\233\26", "\110\122\34\67\195\95\41\133")]:CooldownRemains() > v13:BuffRemains(v80.VoidformBuff)) and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\67\190\82\78\244\122\189\79", "\182\21\209\59\42")]:CooldownRemains() <= (v13:BuffRemains(v80.VoidformBuff) + 2))) or (v13:BuffUp(v80.MindDevourerBuff) and (v13:PMultiplier(v80.DevouringPlague) < 1.2)))) then
					if ((1635 > 653) and v89.CastCycle(v80.DevouringPlague, v85, v116, not v14:IsSpellInRange(v80.DevouringPlague), nil, nil, v82.DevouringPlagueMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\179\82\211\18\52\172\190\89\194\34\49\178\182\80\208\24\97\179\182\94\203\93\112\232", "\222\215\55\165\125\65");
					end
				end
				if ((3738 == 3738) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\31\217\199\30\253\214\218\69\62\213\226\31\243\213\229", "\42\76\177\166\122\146\161\141")]:IsReady() and (v13:HasTier(31, 2))) then
					if (v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath)) or (3963 > 4742)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\130\4\202\118\97\154\157\10\220\125\73\161\143\4\218\113\54\168\139\12\192\57\39\253", "\22\197\234\101\174\25");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\30\60\164\216\121\184\244\148\44\39\173", "\230\77\84\197\188\22\207\183")]:IsCastable() and not v98 and (v14:DebuffRefreshable(v80.VampiricTouchDebuff) or ((v13:BuffStack(v80.DeathsTormentBuff) > 9) and v13:HasTier(31, 4)))) or (4072 > 4695)) then
					if ((v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\218\27\200\250\133\179\253", "\85\153\116\166\156\236\193\144")) or (2220 > 2889)) then
						if (v23(v80.ShadowCrash, not v14:IsInRange(40)) or (4914 < 4399)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\183\232\76\183\235\23\155\227\95\178\247\8\228\237\76\186\234\64\246\176", "\96\196\128\45\211\132");
						end
					elseif ((3660 == 3660) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\16\131\126\82\203\239\129\214\49\136\105\31\241\186\166\203\58\159", "\184\85\237\27\63\178\207\212"))) then
						if ((2915 >= 196) and v17:Exists() and v13:CanAttack(v17)) then
							if (v23(v82.ShadowCrashCursor, not v14:IsInRange(40)) or (4638 < 3902)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\27\81\8\91\7\78\54\92\26\88\26\87\72\84\8\86\6\25\91\15", "\63\104\57\105");
							end
						end
					elseif ((v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\42\147\228\103\30\149\183\75\25", "\36\107\231\196")) or (1100 >= 1292)) then
						if (v23(v82.ShadowCrashCursor, not v14:IsInRange(40)) or (547 > 3511)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\78\189\163\131\82\162\157\132\79\180\177\143\29\184\163\142\83\245\240\215", "\231\61\213\194");
						end
					end
				end
				v185 = 4;
			end
			if ((v185 == 6) or (314 > 2132)) then
				if ((932 == 932) and v90) then
					return v90;
				end
				break;
			end
			if ((v185 == 2) or (2939 == 4366)) then
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\233\129\94\6\3\250\237\134\77\6\40\232\219\157\87", "\141\186\233\63\98\108")]:IsReady() or (3969 <= 3657)) then
					if (v89.CastCycle(v80.ShadowWordDeath, v85, v124, not v14:IsSpellInRange(v80.ShadowWordDeath), nil, nil, v82.ShadowWordDeathMouseover) or (1379 == 1462)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\226\45\178\42\230\213\59\185\55\245\213\40\179\36\229\226\108\187\36\248\228\108\231\117", "\69\145\138\76\214");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\70\192\128\141\157\25\124\219", "\118\16\175\233\233\223")]:IsCastable() and v93) or (4606 <= 3927)) then
					if (v23(v80.VoidBolt, not v14:IsInRange(40)) or (1578 <= 1012)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\157\139\60\191\209\137\114\135\144\117\182\239\130\115\203\213\103", "\29\235\228\85\219\142\235");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\25\209\172\210\98\92\46\92\58\228\182\220\112\91\34", "\50\93\180\218\189\23\46\71")]:IsReady() and (v92 <= (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\250\161\77\67\81\206\65\208\163\107\64\69\219\93\219\128\94\78\81\218\78", "\40\190\196\59\44\36\188")]:BaseDuration() + 4))) or (2399 > 3386)) then
					if (v23(v80.DevouringPlague, not v14:IsSpellInRange(v80.DevouringPlague)) or (3476 > 4701)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\64\202\187\239\111\4\50\66\227\164\246\124\10\41\64\156\185\251\116\3\124\20\136", "\109\92\37\188\212\154\29");
					end
				end
				v185 = 3;
			end
			if ((v185 == 1) or (4374 <= 3729)) then
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\16\181\53\233\33\162\42\232\51\128\47\231\51\165\38", "\134\84\208\67")]:IsReady() or (4938 <= 1325)) then
					if (v89.CastCycle(v80.DevouringPlague, v85, v116, not v14:IsSpellInRange(v80.DevouringPlague)) or (2930 > 4142)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\169\144\83\6\190\143\82\20\147\150\80\18\171\147\89\83\161\135\85\29\236\210", "\60\115\204\230");
					end
				end
				if ((583 >= 133) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\212\50\234\116\232\45\220\127\245\62\207\117\230\46\227", "\16\135\90\139")]:IsReady() and (v13:HasTier(31, 4) or (v102 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\125\122\3\32\77\85\104\85\118\10\54\122\91\106\89\113\8\39", "\24\52\20\102\83\46\52")]:IsAvailable() and v13:HasTier(31, 2))) and v14:DebuffUp(v80.DevouringPlagueDebuff)) then
					if ((432 == 432) and v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\39\32\32\0\211\16\54\43\29\192\16\37\33\14\208\39\97\41\14\205\33\97\114", "\111\164\79\65\68");
					end
				end
				if ((1456 <= 4224) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\235\208\141\218\12\230\199\202\151", "\138\166\185\227\190\78")]:IsCastable() and v102 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\226\122\192\36\81\34\9\202\118\201\50\102\44\11\198\113\203\35", "\121\171\20\165\87\50\67")]:IsAvailable() and (v103 > v80[LUAOBFUSACTOR_DECRYPT_STR_0("\235\49\183\50\155\14\199\43\173", "\98\166\88\217\86\217")]:ExecuteTime()) and (v88 <= 7)) then
					if (v89.CastCycle(v80.MindBlast, v85, v118, not v14:IsSpellInRange(v80.MindBlast), nil, nil, v82.MindBlastMouseover, true) or (1698 >= 2384)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\255\119\5\185\222\250\247\106\21\198\209\247\255\119\65\222", "\188\150\150\25\97\230");
					end
				end
				v185 = 2;
			end
			if ((2711 < 3812) and (4 == v185)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\58\165\60\119\6\186\10\124\27\169\25\118\8\185\53", "\19\105\205\93")]:IsReady() and (v13:BuffStack(v80.DeathsTormentBuff) > 9) and v13:HasTier(31, 4) and (not v98 or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\154\0\223\133\48\190\43\204\128\44\161", "\95\201\104\190\225")]:IsAvailable())) or (746 >= 2339)) then
					if ((3002 >= 894) and v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\188\195\192\202\160\220\254\217\160\217\197\241\171\206\192\218\167\139\204\207\166\197\129\156\253", "\174\207\171\161");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\222\246\12\247\247\192\218\241\31\247\220\210\236\234\5", "\183\141\158\109\147\152")]:IsReady() and v93 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\5\7\227\31\47\8\246\13\46\5\227\56\35\27\235\9\34\29", "\108\76\105\134")]:IsAvailable() and v102 and ((not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\194\203\162\232\202\226\202\164\242\231\249\192", "\174\139\165\209\129")]:IsAvailable() and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\138\183\237\205\233\5\73\119\164\180\209\192\212\12\126", "\24\195\211\130\161\166\99\16")]:IsAvailable()) or v13:BuffUp(v80.DeathspeakerBuff)) and not v13:HasTier(31, 2)) or (1376 <= 1032)) then
					if ((2427 == 2427) and v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\11\232\40\92\1\121\20\230\62\87\41\66\6\232\56\91\86\75\2\224\34\19\68\18", "\118\38\99\137\76\51");
					end
				end
				if ((3491 > 3393) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\203\39\8\2\0\50\244\37\49\29\28\35\245", "\64\157\70\101\114\105")]:IsCastable()) then
					if (v89.CastTargetIf(v80.VampiricTouch, v85, LUAOBFUSACTOR_DECRYPT_STR_0("\77\161\169", "\112\32\200\199\131"), v114, v115, not v14:IsSpellInRange(v80.VampiricTouch)) or (3885 > 4312)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\81\81\168\202\185\43\47\111\72\183\214\168\42\108\93\93\177\205\235\112\122", "\66\76\48\60\216\163\203");
					end
				end
				v185 = 5;
			end
		end
	end
	local function v137()
		local v186 = 0;
		while true do
			if ((1 == v186) or (2128 < 1754)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\24\216\213\28\32\46\212\205\20\5\48\220\196\6\48", "\85\92\189\163\115")]:IsReady() and (v14:DebuffRemains(v80.DevouringPlagueDebuff) <= 4) and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\31\163\57\60\29\163\34\42\44\162\36", "\88\73\204\80")]:CooldownRemains() < (v13:GCD() * 2))) or (4584 <= 3272)) then
					if ((1043 <= 3558) and v23(v80.DevouringPlague, not v14:IsSpellInRange(v80.DevouringPlague))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\134\6\73\60\200\39\141\23\121\57\214\47\132\5\67\105\202\34\188\4\73\59\200\43\141\4\6\127", "\186\78\227\112\38\73");
					end
				end
				if ((71 == 71) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\209\94\243\81\113\118\253\68\233", "\26\156\55\157\53\51")]:IsCastable() and not v13:PrevGCD(1, v80.MindBlast)) then
					if ((2793 == 2793) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\209\24\221\135\82\128\217\5\205\248\64\128\231\2\214\170\66\137\214\2\153\224", "\48\236\184\118\185\216");
					end
				end
				v186 = 2;
			end
			if ((v186 == 2) or (561 > 911)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\211\178\94\52\251\59\247\175\82\62\219", "\84\133\221\55\80\175")]:IsCastable() and (v110(v14, false) or v13:BuffUp(v80.VoidformBuff))) or (677 >= 4143)) then
					if ((4422 > 2292) and v23(v80.VoidTorrent, not v14:IsSpellInRange(v80.VoidTorrent), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\232\45\162\248\72\178\245\54\163\201\72\253\247\40\153\211\83\175\245\33\168\211\28\236\183", "\60\221\135\68\198\167");
					end
				end
				break;
			end
			if ((v186 == 0) or (3386 <= 2556)) then
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\124\87\129\230\104\87\132\246", "\130\42\56\232")]:IsCastable() or (4932 < 902)) then
					if (v23(v80.VoidBolt, not v14:IsInRange(40)) or (503 >= 1425)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\252\186\45\231\127\61\229\185\48\163\80\51\213\161\43\241\82\58\228\161\100\177", "\95\138\213\68\131\32");
					end
				end
				if ((4871 == 4871) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\28\41\172\83\127\56\33\162\119\121\63\43\169", "\22\74\72\193\35")]:IsCastable() and (v14:DebuffRemains(v80.VampiricTouchDebuff) <= 6) and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\26\118\237\92\24\118\246\74\41\119\240", "\56\76\25\132")]:CooldownRemains() < (v13:GCD() * 2))) then
					if ((2515 > 2280) and v23(v80.VampiricTouch, not v14:IsSpellInRange(v80.VampiricTouch), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\72\192\166\54\198\76\200\168\25\219\81\212\168\46\143\78\205\148\50\192\76\211\174\40\219\30\149", "\175\62\161\203\70");
					end
				end
				v186 = 1;
			end
		end
	end
	local function v138()
		local v187 = 0;
		while true do
			if ((3008 == 3008) and (v187 == 3)) then
				if ((295 < 775) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\208\5\44\41\69\21\115\229\48\46\44\79\15", "\26\134\100\65\89\44\103")]:IsCastable() and (((v95 > 0) and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\194\235\49\39\171\230\192\34\34\183\249", "\196\145\131\80\67")]:InFlight()) or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\41\184\15\27\8\237\12\185\8\15\43\224\31\180\9\31\11", "\136\126\208\102\104\120")]:IsAvailable())) then
					if (v89.CastCycle(v80.VampiricTouch, v85, v127, not v14:IsSpellInRange(v80.VampiricTouch), nil, nil, v82.VampiricTouchMouseover, true) or (4828 <= 3019)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\110\139\195\83\166\64\52\82\71\158\193\86\172\90\125\80\119\143\142\18\249", "\49\24\234\174\35\207\50\93");
					end
				end
				if ((2317 >= 2150) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\63\250\252\140\126\27\197\242\154\117\40\247\252\156\121", "\17\108\146\157\232")]:IsReady() and v97 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\98\205\17\254\44\169\91\194\22\225\42\156\68\209\25\232\33\188", "\200\43\163\116\141\79")]:IsAvailable() and v102 and ((not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\150\56\46\138\180\253\236\170\37\20\145\181", "\131\223\86\93\227\208\148")]:IsAvailable() and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\202\65\185\186\50\179\218\74\177\177\46\180\241\74\184", "\213\131\37\214\214\125")]:IsAvailable()) or v13:BuffUp(v80.DeathspeakerBuff))) then
					if (v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath)) or (3148 == 739)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\35\36\187\238\49\20\50\176\243\34\20\33\186\224\50\35\101\190\238\35\107\116\231", "\129\70\75\69\223");
					end
				end
				if ((4576 < 4666) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\107\194\253\237\79\255\79\192\246\192\114\252\71\197\250\253\101", "\143\38\171\147\137\28")]:IsReady() and v93 and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\253\139\183\247\33\239\213\195\150", "\180\176\226\217\147\99\131")]:FullRechargeTime() >= (v13:GCD() * 3)) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\250\189\32\11\252\191\12\19\219\172\33", "\103\179\217\79")]:IsAvailable() and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\124\184\21\209\117\131\177\88\178\18\193", "\195\42\215\124\181\33\236")]:CooldownDown() or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\59\86\62\58\17\247\31\75\50\48\49", "\152\109\57\87\94\69")]:IsAvailable())) then
					if (v23(v80.MindSpikeInsanity, not v14:IsInRange(40), true) or (3843 == 3030)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\244\222\4\167\129\193\68\161\242\210\53\170\176\193\85\166\240\195\19\227\191\221\81\232\171\135", "\200\153\183\106\195\222\178\52");
					end
				end
				v187 = 4;
			end
			if ((2522 > 1584) and (v187 == 5)) then
				if ((3245 == 3245) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\46\76\234\206\50\89\89\10\70\237\222", "\43\120\35\131\170\102\54")]:IsCastable() and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\100\21\158\181\173\185\135\120\15\137\189", "\228\52\102\231\214\197\208")]:IsAvailable()) then
					if (v89.CastCycle(v80.VoidTorrent, v85, v128, not v14:IsSpellInRange(v80.VoidTorrent), nil, nil, v82.VoidTorrentMouseover, true) or (4458 <= 2954)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\239\124\206\213\159\22\196\12\229\123\222\170\138\22\211\94\178\35", "\182\126\128\21\170\138\235\121");
					end
				end
				if ((v106:IsCastable() and v13:BuffUp(v80.MindFlayInsanityBuff) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\162\222\58\234\169\21\19\18\131\207\59", "\102\235\186\85\134\230\115\80")]:IsAvailable()) or (2080 <= 467)) then
					if ((58 < 618) and v23(v106, not v14:IsSpellInRange(v106), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\5\48\91\77\210\46\86\21\126\94\125\209\98\5\84", "\66\55\108\94\63\18\180");
					end
				end
				v90 = v134();
				v187 = 6;
			end
			if ((v187 == 1) or (891 > 3655)) then
				if ((v30 and ((v92 < 30) or ((v14:TimeToDie() > 15) and (not v98 or (v88 > 2))))) or (4287 < 3622)) then
					local v228 = 0;
					while true do
						if ((34 <= 2569) and (v228 == 0)) then
							v90 = v135();
							if (v90 or (2876 == 1323)) then
								return v90;
							end
							break;
						end
					end
				end
				if ((2030 == 2030) and v101:IsCastable() and ((v14:DebuffUp(v80.ShadowWordPainDebuff) and v97) or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\139\213\119\6\189\67\91\52\185\206\126", "\70\216\189\22\98\210\52\24")]:InFlight() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\237\215\170\148\195\223\205\170\137\212\233\215\162\131\220\205\204", "\179\186\191\195\231")]:IsAvailable())) and ((v92 < 30) or (v14:TimeToDie() > 15)) and (not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\221\62\10\239\216\44\27\225\247\44\17\235\247", "\132\153\95\120")]:IsAvailable() or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\149\179\28\38\214\201\163\180\188\29\36\248\212", "\192\209\210\110\77\151\186")]:CooldownRemains() < v107) or (v92 < 15))) then
					if (v23(v101) or (2040 == 682)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\10\44\237\253\193\238\7\39\251\191\197\239\6\98\191", "\164\128\99\66\137\159");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\45\128\231\186\34\133\232\173\20", "\222\96\233\137")]:IsCastable() and ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\148\186\169\27\170\255\241\170\167", "\144\217\211\199\127\232\147")]:FullRechargeTime() <= (v107 + v80[LUAOBFUSACTOR_DECRYPT_STR_0("\213\38\48\44\247\73\3\87\236", "\36\152\79\94\72\181\37\98")]:CastTime())) or (v103 <= (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\250\209\73\59\245\212\70\44\195", "\95\183\184\39")]:CastTime() + v107))) and v102 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\156\49\226\53\87\129\18\180\61\235\35\96\143\16\184\58\233\50", "\98\213\95\135\70\52\224")]:IsAvailable() and (v103 > v80[LUAOBFUSACTOR_DECRYPT_STR_0("\211\170\199\115\118\242\162\218\99", "\52\158\195\169\23")]:CastTime()) and (v88 <= 7) and v13:BuffDown(v80.MindDevourerBuff)) or (269 > 2382)) then
					if ((836 < 4132) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\119\181\60\112\185\55\119\138\105\168\114\117\137\48\59\211", "\235\26\220\82\20\230\85\27");
					end
				end
				v187 = 2;
			end
			if ((2989 >= 1063) and (v187 == 6)) then
				if ((2406 <= 3221) and v90) then
					return v90;
				end
				break;
			end
			if ((3567 < 4459) and (v187 == 0)) then
				v131();
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\216\188\245\147\75\203\231\190\204\140\87\218\230", "\185\142\221\152\227\34")]:IsCastable() and (((v95 > 0) and not v99 and not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\107\205\86\254\76\36\212\74\196\68\242", "\151\56\165\55\154\35\83")]:InFlight()) or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\151\75\12\253\176\70\23\231\174\68\54\230\161\71\10\249\179", "\142\192\35\101")]:IsAvailable())) or (1860 >= 2065)) then
					if (v89.CastCycle(v80.VampiricTouch, v85, v126, not v14:IsSpellInRange(v80.VampiricTouch), nil, nil, v82.VampiricTouchMouseover, true) or (2123 >= 4894)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\116\36\179\238\158\165\21\233\97\38\182\228\132\236\23\217\112\105\241", "\118\182\21\73\195\135\236\204");
					end
				end
				if ((3619 == 3619) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\59\52\27\68\11\26\222\26\61\9\72", "\157\104\92\122\32\100\109")]:IsCastable() and not v98) then
					if ((2132 < 3335) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\128\169\193\204\52\53\128", "\203\195\198\175\170\93\71\237"))) then
						if (v23(v80.ShadowCrash, not v14:IsInRange(40)) or (4477 <= 3601)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\61\67\63\209\94\6\195\45\89\63\198\89\81\253\33\78\126\129", "\156\78\43\94\181\49\113");
						end
					elseif ((v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\87\230\193\174\18\3\76\124\236\193\177\75\96\108\96\251\203\177", "\25\18\136\164\195\107\35")) or (3478 == 589)) then
						if ((1732 >= 130) and v17:Exists() and v13:CanAttack(v17)) then
							if (v23(v82.ShadowCrashCursor, not v14:IsInRange(40)) or (867 > 3215)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\251\37\168\75\125\171\254\187\250\44\186\71\50\189\206\189\168\121", "\216\136\77\201\47\18\220\161");
							end
						end
					elseif ((665 <= 4541) and (v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\12\248\107\249\29\206\145\34\254", "\226\77\140\75\186\104\188"))) then
						if ((1089 <= 3455) and v23(v82.ShadowCrashCursor, not v14:IsInRange(40))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\170\198\209\59\64\174\241\211\45\78\170\198\144\62\64\188\142\132", "\47\217\174\176\95");
						end
					end
				end
				v187 = 1;
			end
			if ((v187 == 2) or (3522 < 2146)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\187\169\232\198\123\159\150\230\208\112\172\164\232\214\124", "\20\232\193\137\162")]:IsReady() and (v103 <= 2) and v102 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\11\209\192\181\228\141\7\112\32\211\192\146\232\158\26\116\44\203", "\17\66\191\165\198\135\236\119")]:IsAvailable() and (v88 <= 7)) or (3491 <= 3258)) then
					if (v23(v80.ShadowWordDeath, not v14:IsSpellInRange(v80.ShadowWordDeath)) or (4449 < 3644)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\167\175\23\240\255\211\198\0\189\170\44\251\237\237\197\7\239\175\28\250\168\189\129", "\177\111\207\206\115\159\136\140");
					end
				end
				if (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\51\134\25\16\246\64\83\17", "\63\101\233\112\116\180\47")]:IsCastable() or (153 >= 1887)) then
					if ((1765 > 640) and v23(v80.VoidBolt, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\213\52\228\22\199\52\204\55\249\82\249\57\198\123\188\64", "\86\163\91\141\114\152");
					end
				end
				if ((200 < 4059) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\119\14\98\124\47\65\2\122\116\10\95\10\115\102\63", "\90\51\107\20\19")]:IsReady() and (not v100 or (v13:InsanityDeficit() <= 20) or (v13:BuffUp(v80.VoidformBuff) and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\187\255\140\235\31\130\252\145", "\93\237\144\229\143")]:CooldownRemains() > v13:BuffRemains(v80.VoidformBuff)) and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\35\249\249\29\41\73\25\226", "\38\117\150\144\121\107")]:CooldownRemains() <= (v13:BuffRemains(v80.VoidformBuff) + 2))))) then
					if (v89.CastCycle(v80.DevouringPlague, v85, v117, not v14:IsSpellInRange(v80.DevouringPlague), nil, nil, v82.DevouringPlagueMouseover) or (3210 <= 1400)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\41\190\248\53\56\169\231\52\42\132\254\54\44\188\251\63\109\186\225\63\109\234\186", "\90\77\219\142");
					end
				end
				v187 = 3;
			end
			if ((1380 < 3863) and (v187 == 4)) then
				if ((183 <= 3341) and v106:IsCastable() and v13:BuffUp(v80.MindFlayInsanityBuff) and v93 and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\31\234\134\57\107\86\51\240\156", "\58\82\131\232\93\41")]:FullRechargeTime() >= (v13:GCD() * 3)) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\170\83\223\25\114\57\160\67\216\0\83", "\95\227\55\176\117\61")]:IsAvailable() and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\46\113\42\79\159\23\108\49\78\165\12", "\203\120\30\67\43")]:CooldownDown() or not v80[LUAOBFUSACTOR_DECRYPT_STR_0("\199\42\68\235\237\254\55\95\234\215\229", "\185\145\69\45\143")]:IsAvailable())) then
					if (v23(v106, not v14:IsSpellInRange(v106), true) or (426 > 3276)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\22\23\162\227\140\19\24\191\156\139\16\28\230\142\216", "\188\234\127\121\198");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\21\59\29\135\26\62\18\144\44", "\227\88\82\115")]:IsCastable() and v97 and (v13:BuffDown(v80.MindDevourerBuff) or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\117\16\179\163\39\97\86\15\174\174\13\125", "\19\35\127\218\199\98")]:CooldownUp() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\42\244\3\230\57\233\31\242\8\242\5\236", "\130\124\155\106")]:IsAvailable()))) or (3592 == 4092)) then
					if ((3380 == 3380) and v23(v80.MindBlast, not v14:IsSpellInRange(v80.MindBlast), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\194\248\171\156\244\112\190\198\223\182\174\172\243\60\237\129", "\223\181\171\150\207\195\150\28");
					end
				end
				if ((4841 >= 4597) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\122\53\234\170\61\67\40\241\171\7\88", "\105\44\90\131\206")]:IsAvailable() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\207\243\171\186\0\55\252\204\187\183\3", "\94\159\128\210\217\104")]:IsAvailable() and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\102\246\15\187\107\112\235\104\85\247\18", "\26\48\153\102\223\63\31\153")]:CooldownRemains() <= 3) and (not v98 or ((v88 / (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\52\65\224\227\11\82\228\240\54\79\248\240\10\100\232\241\23\70\235", "\147\98\32\141")]:AuraActiveCount() + v88)) < 1.5)) and ((v13:Insanity() >= 50) or v14:DebuffUp(v80.DevouringPlagueDebuff) or v13:BuffUp(v80.DarkReveriesBuff) or v13:BuffUp(v80.VoidformBuff) or v13:BuffUp(v80.DarkAscensionBuff))) then
					local v229 = 0;
					while true do
						if ((3962 == 3962) and (v229 == 0)) then
							v90 = v137();
							if (v90 or (3057 <= 2101)) then
								return v90;
							end
							break;
						end
					end
				end
				v187 = 5;
			end
		end
	end
	local function v139()
		local v188 = 0;
		while true do
			if ((v188 == 2) or (3977 >= 4688)) then
				if (v32 or (774 < 455)) then
					local v230 = 0;
					while true do
						if ((v230 == 1) or (832 == 2347)) then
							if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\30\1\236\243\60\57\244\228\42\61\243\255\43\2\255", "\150\78\110\155")]:IsCastable() and (v13:HealthPercentage() <= v72) and v71) or (1934 == 2777)) then
								if (v23(v82.PowerWordShieldPlayer) or (604 == 4669)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\149\202\48\228\182\33\168\79\151\193\24\242\172\23\186\76\129\133\35\228\162\27\177\83\140\211\34", "\32\229\165\71\129\196\126\223");
								end
							end
							break;
						end
						if ((0 == v230) or (2088 > 2395)) then
							if ((1992 <= 2618) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\229\112\230\1\94\235\121\230\30", "\54\163\28\135\114")]:IsCastable() and (v13:HealthPercentage() <= v68) and v67) then
								if (v23(v82.FlashHealPlayer) or (3318 == 418)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\46\215\92\145\70\64\32\222\92\142\14\123\45\221\88\140\93\118\62\222", "\31\72\187\61\226\46");
								end
							end
							if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\241\3\77\215\80", "\68\163\102\35\178\39\30")]:IsCastable() and (v13:HealthPercentage() <= v70) and v69) or (4067 <= 2537)) then
								if (v23(v82.RenewPlayer) or (4169 <= 4060)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\172\117\212\194\20\245\135\20\184\117\212\212\10\163\134", "\113\222\16\186\167\99\213\227");
								end
							end
							v230 = 1;
						end
					end
				end
				if ((v81[LUAOBFUSACTOR_DECRYPT_STR_0("\235\140\197\141\149\221\208\157\203\143\132", "\181\163\233\164\225\225")]:IsReady() and v54 and (v13:HealthPercentage() <= v55)) or (86 >= 606)) then
					if (v23(v82.Healthstone, nil, nil, true) or (153 >= 2453)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\88\142\63\123\68\131\45\99\95\133\59\55\84\142\56\114\94\152\55\97\85\203\109", "\23\48\235\94");
					end
				end
				v188 = 3;
			end
			if ((v188 == 0) or (2676 >= 4227)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\50\140\129\50", "\57\116\237\229\87\71")]:IsReady() and v52 and (v13:HealthPercentage() <= v53)) or (283 >= 2823)) then
					if ((4242 > 366) and v23(v80.Fade, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\172\176\233\226\55\234\66\172\180\227\244\126\248\66", "\39\202\209\141\135\23\142");
					end
				end
				if ((4712 == 4712) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\219\58\26\26\55\234\236\58\6\4", "\152\159\83\105\106\82")]:IsCastable() and (v13:HealthPercentage() < v50) and v51) then
					if ((3335 >= 2992) and v23(v80.Dispersion)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\133\207\66\226\204\78\146\207\94\252\137\88\132\192\84\252\218\85\151\195", "\60\225\166\49\146\169");
					end
				end
				v188 = 1;
			end
			if ((1482 >= 1460) and (v188 == 1)) then
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\11\27\60\58\4\21\46\10\42\26\19\6\54\27\61", "\103\79\126\79\74\97")]:IsCastable() and (v13:HealthPercentage() <= v49) and v48) or (171 >= 4691)) then
					if (v23(v80.DesperatePrayer) or (2173 > 4840)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\190\122\192\99\91\8\187\107\214\76\78\8\187\102\214\97\30\30\191\121\214\125\77\19\172\122", "\122\218\31\179\19\62");
					end
				end
				if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\133\215\192\209\192\179\76\176\243\192\195\219\160\70\182", "\37\211\182\173\161\169\193")]:IsReady() and v89.TargetIsValid() and v14:IsInRange(30) and v74 and v89.AreUnitsBelowHealthPercentage(v75, v76)) or (3884 < 1346)) then
					if ((3360 == 3360) and v23(v80.VampiricEmbrace, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\59\64\201\33\105\176\244\5\72\212\42\105\184\244\63\13\221\45\125\188\249\41\68\207\45", "\217\151\90\45\185\72\27");
					end
				end
				v188 = 2;
			end
			if ((1082 <= 2816) and (v188 == 3)) then
				if ((v34 and (v13:HealthPercentage() <= v36)) or (3830 >= 4328)) then
					if ((v35 == LUAOBFUSACTOR_DECRYPT_STR_0("\78\223\222\79\82\32\218\117\212\223\29\127\54\211\112\211\214\90\23\3\221\104\211\215\83", "\178\28\186\184\61\55\83")) or (1099 >= 4754)) then
						if ((4871 <= 4892) and v81[LUAOBFUSACTOR_DECRYPT_STR_0("\246\200\65\46\247\29\253\205\195\64\20\247\15\249\205\195\64\12\253\26\252\203\195", "\149\164\173\39\92\146\110")]:IsReady()) then
							if (v23(v82.RefreshingHealingPotion, nil, nil, true) or (2393 <= 1632)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\225\34\22\13\31\8\251\46\30\24\90\19\246\38\28\22\20\28\179\55\31\11\19\20\253\103\20\26\28\30\253\52\25\9\31\91\167", "\123\147\71\112\127\122");
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v140()
		if ((2414 == 2414) and ((GetTime() - v28) > v40)) then
			local v194 = 0;
			while true do
				if ((1584 == 1584) and (0 == v194)) then
					if ((2285 > 2073) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\238\194\134\104\71\194\201\177\126\83\192", "\38\172\173\226\17")]:IsAvailable() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\125\30\59\234\95\38\35\253\73\34\36\230\72\29\40", "\143\45\113\76")]:IsReady() and v39 and v13:BuffDown(v80.AngelicFeatherBuff) and v13:BuffDown(v80.BodyandSoulBuff)) then
						if (v23(v82.PowerWordShieldPlayer) or (2894 < 2799)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\168\183\11\57\170\135\11\51\170\188\35\47\176\177\25\48\188\135\12\48\185\161\25\46\248\181\19\42\189", "\92\216\216\124");
						end
					end
					if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\122\60\171\69\241\82\49\138\69\252\79\58\169\82", "\157\59\82\204\32")]:IsReady() and v38 and v13:BuffDown(v80.AngelicFeatherBuff) and v13:BuffDown(v80.BodyandSoulBuff) and v13:BuffDown(v80.AngelicFeatherBuff)) or (1275 > 3605)) then
						if ((240 < 1190) and v23(v82.AngelicFeatherPlayer)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\57\48\228\255\229\227\208\142\62\59\226\238\225\239\193\142\40\50\226\227\236\248\147\188\55\40\230", "\209\88\94\131\154\137\138\179");
						end
					end
					break;
				end
			end
		end
	end
	local function v141()
		if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\24\180\214\117\24\58\21\43\59\164\197\111\27", "\66\72\193\164\28\126\67\81")]:IsReady() and v31 and v89.DispellableFriendlyUnit()) or (635 > 2257)) then
			if ((1961 > 534) and v23(v82.PurifyDiseaseFocus)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\247\57\186\81\32\111\216\40\161\75\35\119\244\41\232\92\47\101\247\41\164", "\22\135\76\200\56\70");
			end
		end
	end
	local function v142()
		local v189 = 0;
		while true do
			if ((196 <= 3023) and (v189 == 8)) then
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\46\172\158\191\42\119\26\186", "\25\125\201\234\203\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\76\231\29\48\28\38\23\118\227\30\12\6\42", "\115\25\148\120\99\116\71")];
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\56\173\48\72\2\58\170", "\33\108\93\217\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\238\88\164\155\218\70\177\164\201\66\162\136\214\73\179\172\216\78", "\205\187\43\193")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\205\119\17\203\247\124\2\204", "\191\158\18\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\194\138\167\166\215\202\132\146\162\199\209\134\180\170\237\243", "\207\165\163\231\215")] or 0;
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\245\252\237\66\45\126\193\234", "\16\166\153\153\54\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\228\178\205\86\61\51\240\209\150\205\68\38\32\250\215\148\210\73\33\49", "\153\178\211\160\38\84\65")] or 0;
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\14\78\63\139\5\93\56", "\75\226\107\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\214\16\126\30\213\238\74\223\2\114\36\209\204\95\219", "\173\56\190\113\26\113\162")] or "";
				v189 = 9;
			end
			if ((2048 <= 3047) and (v189 == 5)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\187\222\201\184\168\24\161\48", "\67\232\187\189\204\193\118\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\187\33\162\37\41\43\225\141\59\166\41\52\12\199\187", "\143\235\78\213\64\91\98")] or 0;
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\77\144\253\121\184\138\91", "\214\237\40\228\137\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\181\236\248\220\17\143\139\229\250\202\10\169\139\196\253\214\22\182", "\198\229\131\143\185\99")] or 0;
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\98\137\188\103\88\130\175\96", "\19\49\236\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\206\30\216\182\233\191\175", "\218\158\87\150\215\132")] or "";
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\200\27\205\246\63\44\202\232", "\173\155\126\185\130\86\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\213\143\148\198\133\233\183", "\140\133\198\218\167\232")] or "";
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\160\105\141\187\41\167", "\228\213\78\212\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\183\101\152\4\230\130\31", "\139\231\44\214\101")] or "";
				v189 = 6;
			end
			if ((6 == v189) or (411 >= 2970)) then
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\234\234\18\74\25\191\54\5", "\118\185\143\102\62\112\209\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\105\99\44\206\164\25\19", "\88\60\16\73\134\197\117\124")];
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\239\236\220\72\94\237\235", "\33\48\138\152\168")][LUAOBFUSACTOR_DECRYPT_STR_0("\90\23\60\94\233\7", "\87\18\118\80\49\161")] or 0;
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\27\206\180\185\66\25\201", "\208\44\126\186\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\27\168\201\51\238\198\91\231", "\46\151\122\196\166\116\156\169")] or 0;
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\232\82\14\242\235\234\85", "\155\133\141\38\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\16\57\169\101\70\105\172\43\47\159\85\78\109", "\197\69\74\204\33\47\31")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\195\74\78\147\249\65\93\148", "\231\144\47\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\203\223\83\20\60\220\49\154\221\219\121", "\89\210\184\186\21\120\93\175")];
				v189 = 7;
			end
			if ((1312 <= 2793) and (v189 == 7)) then
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\86\104\193\112\52\182\64", "\90\209\51\28\181\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\119\86\253\183\248\126\86\226\151\224", "\223\176\27\55\142")] or 0;
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\23\190\218\161\45\181\201\166", "\213\68\219\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\62\243\38\213\47\203\58\104", "\31\107\128\67\135\74\165\95")];
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\235\237\232\89\72\191\223\251", "\209\184\136\156\45\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\205\123\13\175\47\248", "\216\103\168\21\104")] or 0;
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\168\87\176\113\163\68\183", "\196\24\205\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\27\152\230\54\33\156\230\20\25\132\241\2\29\131\234\3\34\143", "\102\78\235\131")];
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\43\32\80\78\55\176\39", "\84\154\78\84\36\39\89\215")][LUAOBFUSACTOR_DECRYPT_STR_0("\205\238\65\93\23\202\238\68\92\54\245\232\83\84\1\213\209", "\101\157\129\54\56")] or 0;
				v189 = 8;
			end
			if ((v189 == 2) or (2164 >= 3404)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\43\171\95\222\229\218\147", "\189\224\78\223\43\183\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\6\253\132\18\205\43\221\140\16\205\39\255\158\19\197", "\161\78\156\234\118")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\148\178\221\200\174\185\206\207", "\188\199\215\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\212\8\81\127\228\249\32\81\120\231\238\25\80\105\237\253\5", "\136\156\105\63\27")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\40\137\109\32\18\130\126\39", "\84\123\236\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\133\190\18\190\167\229\155\190\32\165\161\248\184\190\2\162", "\213\144\235\202\119\204")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\29\202\62\33\45\74\48", "\45\67\120\190\74\72\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\44\249\160\235\154\251\249\52\13\227\169\224\191\230\224\52\39\225\172\234\156", "\137\64\66\141\197\153\232\142")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\213\54\178\129\13\215\49", "\232\99\176\66\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\47\60\3\105\159\236\60\248\21\32\20\126\158\241\35\224\37", "\76\140\65\72\102\27\237\153")] or 0;
				v189 = 3;
			end
			if ((1080 <= 2918) and (v189 == 9)) then
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\219\57\17\254\197\217\62", "\151\171\190\77\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\46\245\185\241\111\2\198\27\247\188\251\117\62\214\46\255\172", "\107\165\79\152\201\152\29")] or "";
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\75\252\223\93\113\80\93", "\31\55\46\136\171\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\231\41\209\228\216\58\213\247\229\39\201\247\217\5\221\236", "\148\177\72\188")] or 0;
				break;
			end
			if ((0 == v189) or (3426 <= 1781)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\53\236\48\84\239\138\35", "\129\237\80\152\68\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\100\187\1\193\29\20\81\80\164\23", "\56\49\200\100\147\124\119")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\255\59\171\228\197\48\184\227", "\144\172\94\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\28\167\111\33\14\174\78\42\8\146\72\48\6\173\73", "\39\68\111\194")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\163\243\211\112\185\209\181", "\215\182\198\135\167\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\165\76\235\68\132\71\237\120\130\93\227\71\131\103\235\69\136", "\40\237\41\138")] or "";
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\244\113\238\236\67\201\115\233", "\42\167\20\154\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\98\251\163\78\120\47\77\206\173\86\120\46\68\214\146", "\65\42\158\194\34\17")] or 0;
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\34\70\24\36\227\28\253", "\142\122\71\50\108\77\141\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\32\177\250\40\52\2\167\237\47\52\7\166\217\23\41\1\171\235\13\63\16", "\91\117\194\159\120")];
				v189 = 1;
			end
			if ((v189 == 3) or (4376 <= 4070)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\223\2\198\222\15\185\89", "\222\42\186\118\178\183\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\104\255\65\174\88\255\84\143\79\237\80\143\109\254\69\147\88\254", "\234\61\140\36")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\216\174\102\6\47\218\169", "\111\65\189\218\18")][LUAOBFUSACTOR_DECRYPT_STR_0("\103\78\8\37\14\78\174\87\78\43\39\10\69\170\81\99\43", "\207\35\43\123\85\107\60")] or 0;
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\175\180\254\112\126\173\179", "\25\16\202\192\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\194\190\242\172\230\238\194\162\236\129\196", "\148\157\171\205\130\201")] or 0;
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\209\96\61\216\248\36\199", "\150\67\180\20\73\177")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\11\31\105\132\11\10\72\159\11\19\66\131", "\45\237\120\122")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\237\182\56\222\230\165\63", "\76\183\136\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\79\245\224\30\81\75\17", "\116\26\134\133\88\48\47")];
				v189 = 4;
			end
			if ((v189 == 4) or (805 > 4162)) then
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\196\180\240\180\124\25\210", "\18\126\161\192\132\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\121\41\170\1\126\111", "\54\63\72\206\100")] or 0;
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\92\81\110\236\117\207\74", "\27\168\57\37\26\133")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\185\121\128\210\44\166\104\160\196\57\165\114\173", "\183\77\202\28\200")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\36\54\157\28\30\61\142\27", "\104\119\83\233")][LUAOBFUSACTOR_DECRYPT_STR_0("\221\253\38\46\87\253\235\51\45\77\240\208\23", "\35\149\152\71\66")] or 0;
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\237\86\164\51\23\239\81", "\90\121\136\34\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\247\1\66\27\213\39\91\24\210\29\92\17\201\59\70\31\192\11", "\126\167\110\53")] or "";
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\14\21\58\236\213\49\58\3", "\95\93\112\78\152\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\241\250\146\16\246\151\220\199\224\150\28\235\176\230\192\231\130\16\240", "\178\161\149\229\117\132\222")] or "";
				v189 = 5;
			end
			if ((4904 == 4904) and (v189 == 1)) then
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\24\42\12\60\255\35\9", "\68\122\125\94\120\85\145")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\15\202\127\198\222\191\27\21\204\120\205\216\174\31\25\221", "\218\119\124\175\62\168\185")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\245\92\208\172\254\79\215", "\164\197\144\40")][LUAOBFUSACTOR_DECRYPT_STR_0("\182\227\175\169\210\178\154\209\164\143\238\185\150\252", "\214\227\144\202\235\189")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\160\147\111\25\189\84\47", "\92\141\197\231\27\112\211\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\240\156\166\220\227\241\158\135\212\234\254\147", "\177\134\159\234\195")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\238\43\180\192\179\236\44", "\169\221\139\95\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\130\108\47\39\42\250\142\125\42\36\32\205", "\70\190\235\31\95\66")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\231\14\242\236\180\229\9", "\133\218\130\122\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\246\240\212\217\175\26\41\249\229\215", "\88\92\159\131\164\188\195")];
				v189 = 2;
			end
		end
	end
	local function v143()
		local v190 = 0;
		while true do
			if ((v190 == 3) or (2525 > 4643)) then
				if (v13:IsDeadOrGhost() or (3983 < 1150)) then
					return;
				end
				if ((4066 < 4247) and not v13:IsMoving()) then
					v28 = GetTime();
				end
				if (v13:AffectingCombat() or v41 or (1446 < 545)) then
					local v231 = 0;
					local v232;
					while true do
						if ((v231 == 1) or (616 == 199)) then
							if (v90 or (4384 <= 2280)) then
								return v90;
							end
							break;
						end
						if ((4564 > 598) and (0 == v231)) then
							v232 = v41 and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\200\29\215\84\196\225", "\162\152\104\165\61")]:IsReady();
							v90 = v89.FocusUnit(v232, nil, nil, nil);
							v231 = 1;
						end
					end
				end
				v190 = 4;
			end
			if ((3747 == 3747) and (v190 == 0)) then
				v142();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\146\185\80\212\170\179\68", "\179\198\214\55")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\3\113", "\179\144\108\18\22\37")];
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\242\172\28\142\195\195\176", "\175\166\195\123\233")][LUAOBFUSACTOR_DECRYPT_STR_0("\236\198\78", "\144\143\162\61\41")];
				v190 = 1;
			end
			if ((3889 < 4766) and (v190 == 1)) then
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\220\26\87\126\130\32", "\83\128\179\125\48\18\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\89\190\224\205\66\18", "\126\61\215\147\189\39")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\76\240\26\66\116\250\14", "\37\24\159\125")][LUAOBFUSACTOR_DECRYPT_STR_0("\210\163\116\78", "\34\186\198\21")];
				v84 = v13:GetEnemiesInRange(30);
				v190 = 2;
			end
			if ((2628 > 2464) and (5 == v190)) then
				if (v89.TargetIsValid() or (3197 <= 2999)) then
					local v233 = 0;
					while true do
						if ((1 == v233) or (952 <= 71)) then
							if ((2347 >= 423) and v23(v80.Pool)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\182\86\250\139\60\60\142\222\198\116\244\142\114\114\200", "\172\230\57\149\231\28\90\225");
							end
							break;
						end
						if ((4997 >= 4775) and (v233 == 0)) then
							if ((3333 < 3636) and not v13:AffectingCombat() and v29) then
								local v239 = 0;
								while true do
									if ((3706 >= 2393) and (0 == v239)) then
										v90 = v129();
										if ((1756 < 3743) and v90) then
											return v90;
										end
										break;
									end
								end
							end
							if ((2598 <= 3220) and (v13:AffectingCombat() or v29)) then
								local v240 = 0;
								while true do
									if ((v240 == 3) or (4962 <= 3676)) then
										if (v16 or (3467 < 3261)) then
											if ((1461 <= 2309) and v41) then
												local v249 = 0;
												while true do
													if ((v249 == 0) or (4669 < 511)) then
														v90 = v141();
														if (v90 or (4222 <= 1868)) then
															return v90;
														end
														break;
													end
												end
											end
										end
										if ((3090 >= 102) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\148\72\8\199\204\253\194\254\183\72\24", "\159\208\33\123\183\169\145\143")]:IsReady() and v31 and v42 and not v13:IsCasting() and not v13:IsChanneling() and v89.UnitHasMagicBuff(v14)) then
											if ((4153 > 1521) and v23(v80.DispelMagic, not v14:IsSpellInRange(v80.DispelMagic))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\246\83\43\38\247\86\7\59\243\93\49\53\178\94\57\59\243\93\61", "\86\146\58\88");
											end
										end
										if ((v88 > 2) or (v87 > 3) or (249 < 91)) then
											local v244 = 0;
											while true do
												if ((v244 == 0) or (4612 == 1807)) then
													v90 = v138();
													if ((633 <= 4454) and v90) then
														return v90;
													end
													v244 = 1;
												end
												if ((v244 == 1) or (2328 < 377)) then
													if ((3247 == 3247) and v23(v80.Pool)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\104\208\229\204\238\239\57\232\24\254\229\229\230\160", "\154\56\191\138\160\206\137\86");
													end
													break;
												end
											end
										end
										v240 = 4;
									end
									if ((1372 < 3989) and (2 == v240)) then
										v100 = ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\195\21\197\244\130\25\44\206\225\19\195\254", "\190\149\122\172\144\199\107\89")]:CooldownRemains() <= (v13:GCD() * 3)) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\4\10\248\250\219\32\16\225\234\247\61\11", "\158\82\101\145\158")]:IsAvailable()) or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\84\255\16\29\101\99\253\7\24\87\121\241\12", "\36\16\158\98\118")]:CooldownUp() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\228\23\209\240\121\251\36\224\206\5\202\244\86", "\133\160\118\163\155\56\136\71")]:IsAvailable()) or (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\192\173\120\246\130\16\167\228\167\127\230", "\213\150\194\17\146\214\127")]:IsAvailable() and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\43\186\189\215\78\173\161\26\18\167\175", "\86\123\201\196\180\38\196\194")]:IsAvailable() and (v80[LUAOBFUSACTOR_DECRYPT_STR_0("\193\231\208\171\195\231\203\189\242\230\205", "\207\151\136\185")]:CooldownRemains() <= 4) and v13:BuffDown(v80.VoidformBuff));
										if ((3776 >= 1834) and (v105 == nil)) then
											v105 = v14:GUID();
										end
										if (((v104 == false) and v29 and (v14:GUID() == v105) and not v110(v14, true)) or (1284 >= 3991)) then
											local v245 = 0;
											while true do
												if ((v245 == 1) or (4187 <= 3305)) then
													if ((1091 == 1091) and v23(v80.Pool)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\152\140\39\142\52\126\126\186\195\7\146\113\118\116\186\203\97", "\17\200\227\72\226\20\24");
													end
													break;
												end
												if ((3782 < 3851) and (v245 == 0)) then
													v90 = v133();
													if ((677 <= 1197) and v90) then
														return v90;
													end
													v245 = 1;
												end
											end
										else
											v104 = true;
										end
										v240 = 3;
									end
									if ((3950 == 3950) and (v240 == 1)) then
										if ((4848 >= 141) and v43) then
											local v246 = 0;
											while true do
												if ((3538 < 3871) and (v246 == 0)) then
													v90 = v89.HandleAfflicted(v80.PurifyDisease, v82.PurifyDiseaseMouseover, 40);
													if ((3810 > 3164) and v90) then
														return v90;
													end
													break;
												end
											end
										end
										if ((2557 <= 2601) and v44) then
											local v247 = 0;
											while true do
												if ((2318 > 1082) and (v247 == 0)) then
													v90 = v89.HandleIncorporeal(v80.DominateMind, v82.DominateMindMouseover, 30, true);
													if (v90 or (3285 >= 3449)) then
														return v90;
													end
													v247 = 1;
												end
												if ((v247 == 1) or (525 > 1349)) then
													v90 = v89.HandleIncorporeal(v80.ShackleUndead, v82.ShackleUndeadMouseover, 30, true);
													if (v90 or (3810 >= 4154)) then
														return v90;
													end
													break;
												end
											end
										end
										v98 = false;
										v240 = 2;
									end
									if ((2423 == 2423) and (4 == v240)) then
										v90 = v136();
										if ((4712 >= 3813) and v90) then
											return v90;
										end
										break;
									end
									if ((v240 == 0) or (153 == 2063)) then
										v90 = v139();
										if (v90 or (2584 == 3247)) then
											return v90;
										end
										if ((not v13:IsCasting() and not v13:IsChanneling()) or (1755 <= 693)) then
											local v248 = 0;
											while true do
												if ((3413 == 3413) and (v248 == 2)) then
													v90 = v89.InterruptWithStun(v80.PsychicScream, 8);
													if (v90 or (4591 <= 3060)) then
														return v90;
													end
													break;
												end
												if ((v248 == 0) or (3292 < 1467)) then
													v90 = v89.Interrupt(v80.Silence, 30, true);
													if (v90 or (1370 == 608)) then
														return v90;
													end
													v248 = 1;
												end
												if ((3133 >= 1678) and (1 == v248)) then
													v90 = v89.Interrupt(v80.Silence, 30, true, v17, v82.SilenceMouseover);
													if ((4721 > 1294) and v90) then
														return v90;
													end
													v248 = 2;
												end
											end
										end
										v240 = 1;
									end
								end
							end
							v233 = 1;
						end
					end
				end
				break;
			end
			if ((v190 == 4) or (2719 == 338)) then
				if ((2263 <= 4336) and not v13:AffectingCombat() and v29) then
					local v234 = 0;
					while true do
						if ((v234 == 1) or (1156 <= 385)) then
							if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\236\80\219\180\61\44\232\243\216\121\195\163\59\18\243\244\216\90", "\129\188\63\172\209\79\123\135")]:IsCastable() and (v13:BuffDown(v80.PowerWordFortitudeBuff, true) or v89.GroupBuffMissing(v80.PowerWordFortitudeBuff))) or (1767 > 4108)) then
								if ((3132 < 3745) and v23(v82.PowerWordFortitudePlayer)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\80\235\241\200\82\219\241\194\82\224\217\203\79\246\242\196\84\241\226\200", "\173\32\132\134");
								end
							end
							if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\125\19\9\235\161\38\203\65\9\5", "\173\46\123\104\143\206\81")]:IsCastable() and (v13:BuffDown(v80.ShadowformBuff)) and v73) or (4858 == 4942)) then
								if ((1649 <= 2572) and v23(v80.Shadowform)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\167\21\35\142\74\148\7\187\15\47", "\97\212\125\66\234\37\227");
								end
							end
							v234 = 2;
						end
						if ((v234 == 0) or (4424 <= 3216)) then
							if ((v80[LUAOBFUSACTOR_DECRYPT_STR_0("\253\32\165\120\98\210\194\61\182\91\127\247\217\38\166\104\116\224", "\133\173\79\210\29\16")]:IsCastable() and v37 and (v13:BuffDown(v80.PowerWordFortitudeBuff, true) or v89.GroupBuffMissing(v80.PowerWordFortitudeBuff))) or (1564 > 3638)) then
								if ((2442 < 4070) and v23(v82.PowerWordFortitudePlayer)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\157\115\250\46\159\67\250\36\159\120\210\45\130\110\249\34\153\105\233\46", "\75\237\28\141");
								end
							end
							if (v43 or (3968 <= 1084)) then
								local v241 = 0;
								while true do
									if ((v241 == 0) or (4137 < 1807)) then
										v90 = v89.HandleAfflicted(v80.PurifyDisease, v82.PurifyDiseaseMouseover, 40);
										if (v90 or (443 >= 1460)) then
											return v90;
										end
										break;
									end
								end
							end
							v234 = 1;
						end
						if ((v234 == 2) or (2707 < 255)) then
							if ((3982 <= 4852) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
								if ((4673 == 4673) and v23(v80.Resurrection, nil, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\152\230\165\32\12\152\230\181\33\23\133\237", "\126\234\131\214\85");
								end
							end
							break;
						end
					end
				end
				if ((2927 < 3035) and v13:IsMoving() and (v13:AffectingCombat() or v29)) then
					local v235 = 0;
					while true do
						if ((4435 >= 1961) and (v235 == 0)) then
							v90 = v140();
							if (v90 or (3500 <= 631)) then
								return v90;
							end
							break;
						end
					end
				end
				if ((1842 < 3956) and (v89.TargetIsValid() or v13:AffectingCombat())) then
					local v236 = 0;
					while true do
						if ((2123 >= 1498) and (v236 == 1)) then
							if ((v92 == 11111) or (1979 == 1924)) then
								v92 = v10.FightRemains(v86, false);
							end
							v102 = v101:TimeSinceLastCast() <= 15;
							v236 = 2;
						end
						if ((v236 == 3) or (840 > 4348)) then
							v106 = ((v13:BuffUp(v80.MindFlayInsanityBuff)) and v80[LUAOBFUSACTOR_DECRYPT_STR_0("\169\220\71\94\105\136\212\80\115\65\151\212\71\83\91\157", "\47\228\181\41\58")]) or v80[LUAOBFUSACTOR_DECRYPT_STR_0("\139\245\215\63\37\60\30\191", "\127\198\156\185\91\99\80")];
							v107 = v13:GCD() + 0.25;
							break;
						end
						if ((4583 > 4499) and (v236 == 2)) then
							v103 = 15 - v101:TimeSinceLastCast();
							if ((4221 > 4162) and (v103 < 0)) then
								v103 = 0;
							end
							v236 = 3;
						end
						if ((2842 < 4835) and (v236 == 0)) then
							v91 = v10.BossFightRemains(nil, true);
							v92 = v91;
							v236 = 1;
						end
					end
				end
				v190 = 5;
			end
			if ((v190 == 2) or (1429 >= 3843)) then
				v85 = v13:GetEnemiesInRange(40);
				v86 = v14:GetEnemiesInSplashRange(10);
				if (AOE or (2629 > 3045)) then
					local v237 = 0;
					while true do
						if ((3447 >= 2905) and (v237 == 0)) then
							v87 = #v84;
							v88 = v14:GetEnemiesInSplashRangeCount(10);
							break;
						end
					end
				else
					local v238 = 0;
					while true do
						if ((v238 == 0) or (2817 < 513)) then
							v87 = 1;
							v88 = 1;
							break;
						end
					end
				end
				v190 = 3;
			end
		end
	end
	local function v144()
		local v191 = 0;
		while true do
			if ((v191 == 1) or (732 >= 2550)) then
				v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\18\233\165\52\69\54\161\148\34\67\36\242\176\112\72\56\161\129\32\67\34\161\134\63\69\44\202", "\42\65\129\196\80"));
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\49\66\92\222\24\16\66\222\16\67\88\201\3\71\58\174\20\10\12\138\89\85\76\190\82\10\127\195\87\37\13\225\15\97", "\142\98\42\61\186\119\103\98"));
				break;
			end
			if ((3089 > 164) and (v191 == 0)) then
				v108();
				v80[LUAOBFUSACTOR_DECRYPT_STR_0("\52\171\139\194\33\201\11\169\178\221\61\216\10\142\131\208\61\221\4", "\187\98\202\230\178\72")]:RegisterAuraTracking();
				v191 = 1;
			end
		end
	end
	v20.SetAPL(258, v143, v144);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\29\175\11\16\7\143\16\1\61\172\22\55\11\183\3\12\55\168\76\4\45\190", "\104\88\223\98")]();

