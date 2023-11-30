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
		if ((310 >= 7) and (0 == v5)) then
			v6 = v0[v4];
			if ((4992 > 286) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (2561 == 3893)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\213\11\216\199\228\3\227\169\198\18\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\5\37\118\138\237\174\54", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\118\216\34", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67", "\38\156\55\199")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\155\109\121\36\31", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\52\170\221\203\132\31\36\28\179\221", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = EpicLib;
	local v21 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\106\67\19\49", "\69\41\34\96")];
	local v22 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30\50\36\179\207\222\4\5", "\75\220\163\183\106\98")];
	local v23 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local v24 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local v26 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local v27 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\193\88\127\27\171", "\126\167\52\16\116\217")];
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31 = false;
	local v32 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\235\33\45\141\187\23\239", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\248\160\220\30\225\171\203", "\174\103\142\197")];
	local v33 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\114\58\74\49\33", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\193\252\93\216", "\60\180\164\142")];
	local v34 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\124\76\16\32\35", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\236\201\197\180", "\164\216\137\187")];
	local v35 = {v34[LUAOBFUSACTOR_DECRYPT_STR_0("\243\245\57\183\181\241\13\198\238\52\151\171\252\14\192\245\62\167\170", "\107\178\134\81\210\198\158")]:ID(),v34[LUAOBFUSACTOR_DECRYPT_STR_0("\26\15\140\194\165\52\7\135\212\165\62\58\149\207\185\44\11\134\228\166\57\10\135\213", "\202\88\110\226\166")]:ID(),v34[LUAOBFUSACTOR_DECRYPT_STR_0("\238\22\134\246\217\247\14\142\254\217\206\14\140", "\170\163\111\226\151")]:ID(),v34[LUAOBFUSACTOR_DECRYPT_STR_0("\38\57\166\48\75\37\43\16\34\185\43\108\37\40\31\51\186", "\73\113\80\210\88\46\87")]:ID()};
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
	local v63 = v23[LUAOBFUSACTOR_DECRYPT_STR_0("\165\62\216\27\227", "\135\225\76\173\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\60\232\170\177\160", "\199\122\141\216\208\204\221")];
	local v64, v65, v66, v67, v68, v69, v70;
	local v71, v72;
	local v73, v74;
	local v75 = 11111;
	local v76 = 11111;
	local v77, v78;
	local v79, v80;
	local v81, v82;
	local v83, v84;
	local v85 = (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\132\211\19\241\106\248\172\201\25\255\118", "\150\205\189\112\144\24")]:IsAvailable() and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\12\138\188\77\22\134\16\4\44\139\177", "\112\69\228\223\44\100\232\113")]) or v33[LUAOBFUSACTOR_DECRYPT_STR_0("\246\26\21\192\179\110\141", "\230\180\127\103\179\214\28")];
	v10:RegisterForEvent(function()
		v85 = (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\165\11\92\71\246\79\225\152\12\80\72", "\128\236\101\63\38\132\33")]:IsAvailable() and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\18\69\164\229\206\184\160\30\74", "\175\204\201\113\36\214\139")]) or v33[LUAOBFUSACTOR_DECRYPT_STR_0("\101\201\39\207\1\85\199", "\100\39\172\85\188")];
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\158\72\156\172\31\158\71\154\168\18\131\95\156\164", "\83\205\24\217\224"), LUAOBFUSACTOR_DECRYPT_STR_0("\202\224\236\15\200\224\233\2\213\245\232\17\202\250\228\19\217\241\236\31", "\93\134\165\173"));
	v10:RegisterForEvent(function()
		local v126 = 0;
		while true do
			if ((4362 >= 1421) and (v126 == 0)) then
				v75 = 11111;
				v76 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\142\222\224\251\31\252\141\76\155\213\228\236\5\235\156\95\156\222\228\230", "\30\222\146\161\162\90\174\210"));
	v10:RegisterForEvent(function()
		local v127 = 0;
		while true do
			if ((75 <= 3546) and (v127 == 0)) then
				v33[LUAOBFUSACTOR_DECRYPT_STR_0("\196\74\113\26\241\71\102\15\214\89\113\24\232", "\106\133\46\16")]:RegisterInFlightEffect(391889);
				v33[LUAOBFUSACTOR_DECRYPT_STR_0("\121\36\114\236\78\73\78\37\64\235\91\82\85", "\32\56\64\19\156\58")]:RegisterInFlight();
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\118\237\196\100\116\215\164\101\251\213\115\118\222\191\115\230\218\98\123\208", "\224\58\168\133\54\58\146"));
	v33[LUAOBFUSACTOR_DECRYPT_STR_0("\120\82\74\237\97\143\145\14\106\65\74\239\120", "\107\57\54\43\157\21\230\231")]:RegisterInFlightEffect(391889);
	v33[LUAOBFUSACTOR_DECRYPT_STR_0("\250\143\16\229\173\213\217\222\184\6\244\171\209", "\175\187\235\113\149\217\188")]:RegisterInFlight();
	local function v86()
		return (v13:StealthUp(true, true) and 1.6) or 1;
	end
	v33[LUAOBFUSACTOR_DECRYPT_STR_0("\14\174\138\73", "\24\92\207\225\44\131\25")]:RegisterPMultiplier(v33.RakeDebuff, v86);
	v33[LUAOBFUSACTOR_DECRYPT_STR_0("\120\219\170\73\31", "\29\43\179\216\44\123")]:RegisterDamageFormula(function()
		return v13:AttackPowerDamageMod() * 0.7762 * ((v13:StealthUp(true) and 1.6) or 1) * (1 + (v13:VersatilityDmgPct() / 100));
	end);
	v33[LUAOBFUSACTOR_DECRYPT_STR_0("\137\209\50\77\174\209", "\44\221\185\64")]:RegisterDamageFormula(function()
		return (v13:AttackPowerDamageMod() * 0.1272) + (v13:AttackPowerDamageMod() * 0.4055);
	end);
	local v87 = {v33[LUAOBFUSACTOR_DECRYPT_STR_0("\51\230\67\90", "\19\97\135\40\63")],v33[LUAOBFUSACTOR_DECRYPT_STR_0("\130\117\30\52\32\63\168\85\33\62", "\81\206\60\83\91\79")],v33[LUAOBFUSACTOR_DECRYPT_STR_0("\122\163\194\115\60\203", "\196\46\203\176\18\79\163\45")],v33[LUAOBFUSACTOR_DECRYPT_STR_0("\154\48\107\10\37\247\220\180\35\109\22", "\143\216\66\30\126\68\155")],v33[LUAOBFUSACTOR_DECRYPT_STR_0("\153\223\4\219\192", "\129\202\168\109\171\165\195\183")],v33[LUAOBFUSACTOR_DECRYPT_STR_0("\17\80\37\221\218", "\134\66\56\87\184\190\116")],v33[LUAOBFUSACTOR_DECRYPT_STR_0("\26\52\27\186\21\205\51\48\50\43\16", "\85\92\81\105\219\121\139\65")]};
	local function v88(v128, v129)
		local v130 = 0;
		while true do
			if ((2680 <= 3418) and (v130 == 0)) then
				for v215, v216 in pairs(v128) do
					if (v216:DebuffRefreshable(v129) or (4288 < 2876)) then
						return true;
					end
				end
				return false;
			end
		end
	end
	local function v89(v131)
		local v132 = 0;
		local v133;
		while true do
			if ((2462 >= 1147) and (v132 == 0)) then
				v133 = nil;
				for v217, v218 in pairs(v131) do
					local v219 = 0;
					local v220;
					while true do
						if ((v219 == 0) or (4914 < 2480)) then
							v220 = v218:PMultiplier(v33.Rake);
							if (not v133 or (v220 < v133) or (1559 == 1240)) then
								v133 = v220;
							end
							break;
						end
					end
				end
				v132 = 1;
			end
			if ((566 == 566) and (v132 == 1)) then
				return v133;
			end
		end
	end
	local function v90(v134)
		local v135 = 0;
		while true do
			if ((3921 >= 3009) and (0 == v135)) then
				if ((2063 >= 1648) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\223\191\95\74\120\203\252\191\95\75\111", "\191\157\211\48\37\28")]:IsAvailable()) then
					return false;
				end
				return v134:TimeSinceLastCast() < math.min(5, v33[LUAOBFUSACTOR_DECRYPT_STR_0("\253\19\251\19\62\203\30\248\19\52\204\61\225\26\60", "\90\191\127\148\124")]:TimeSinceLastAppliedOnPlayer());
			end
		end
	end
	local function v91(v136)
		return not v90(v136);
	end
	function CountActiveBtTriggers()
		local v137 = 0;
		local v138;
		while true do
			if ((1066 >= 452) and (v137 == 1)) then
				return v138;
			end
			if ((4974 >= 2655) and (v137 == 0)) then
				v138 = 0;
				for v221 = 1, #v87 do
					if (v90(v87[v221]) or (2721 <= 907)) then
						v138 = v138 + 1;
					end
				end
				v137 = 1;
			end
		end
	end
	local function v92(v139, v140)
		local v141 = 0;
		local v142;
		local v143;
		local v144;
		local v145;
		local v146;
		local v147;
		local v148;
		local v149;
		while true do
			if ((4437 >= 3031) and (v141 == 0)) then
				if (not v140 or (4470 < 2949)) then
					v140 = v16;
				end
				v142 = 0;
				v143 = 0;
				v141 = 1;
			end
			if ((v141 == 2) or (1580 == 2426)) then
				v146 = v140:DebuffRemains(v139);
				v147 = v142 + v146;
				if ((v147 > v143) or (3711 == 503)) then
					v147 = v143;
				end
				v141 = 3;
			end
			if ((v141 == 1) or (420 == 4318)) then
				v144 = 0;
				if ((v139 == v33[LUAOBFUSACTOR_DECRYPT_STR_0("\74\142\62", "\119\24\231\78")]) or (4158 <= 33)) then
					local v226 = 0;
					while true do
						if ((0 == v226) or (99 > 4744)) then
							v142 = 4 + (v73 * 4);
							v143 = 31.2;
							v226 = 1;
						end
						if ((4341 == 4341) and (v226 == 1)) then
							v144 = v139:TickTime();
							break;
						end
					end
				else
					local v227 = 0;
					while true do
						if ((255 <= 1596) and (v227 == 0)) then
							v142 = v139:BaseDuration();
							v143 = v139:MaxDuration();
							v227 = 1;
						end
						if ((v227 == 1) or (4433 < 1635)) then
							v144 = v139:TickTime();
							break;
						end
					end
				end
				v145 = v140:DebuffTicksRemain(v139);
				v141 = 2;
			end
			if ((3 == v141) or (4300 < 3244)) then
				v148 = v147 / v144;
				if (not v145 or (3534 > 4677)) then
					v145 = 0;
				end
				v149 = v148 - v145;
				v141 = 4;
			end
			if ((v141 == 4) or (4859 < 2999)) then
				return v149;
			end
		end
	end
	local function v93(v150)
		local v151 = 0;
		local v152;
		local v153;
		while true do
			if ((4726 > 2407) and (v151 == 1)) then
				v153 = nil;
				for v222, v223 in pairs(v150) do
					local v224 = 0;
					local v225;
					while true do
						if ((v224 == 0) or (1284 > 3669)) then
							v225 = v223:TimeToDie();
							if ((1117 < 2549) and (v225 > v152)) then
								local v239 = 0;
								while true do
									if ((v239 == 0) or (2851 > 4774)) then
										v152 = v225;
										v153 = v223;
										break;
									end
								end
							end
							break;
						end
					end
				end
				v151 = 2;
			end
			if ((1031 < 3848) and (0 == v151)) then
				if ((1854 > 903) and not v150) then
					return 0;
				end
				v152 = 0;
				v151 = 1;
			end
			if ((4663 > 1860) and (v151 == 2)) then
				return v152, v153;
			end
		end
	end
	local function v94(v154)
		return (1 + v154:DebuffStack(v33.AdaptiveSwarmDebuff)) * v25(v154:DebuffStack(v33.AdaptiveSwarmDebuff) < 3) * v154:TimeToDie();
	end
	local function v95(v155)
		return (3 * v25(v155:DebuffRefreshable(v33.LIMoonfireDebuff))) + v25(v155:DebuffUp(v33.LIMoonfireDebuff));
	end
	local function v96(v156)
		return (25 * v25(v13:PMultiplier(v33.Rake) < v156:PMultiplier(v33.Rake))) + v156:DebuffRemains(v33.RakeDebuff);
	end
	local function v97(v157)
		return (v92(v33.RakeDebuff, v157));
	end
	local function v98(v158)
		return (v158:TimeToDie());
	end
	local function v99(v159)
		return v159:DebuffStack(v33.AdaptiveSwarmDebuff) < 3;
	end
	local function v100(v160)
		return (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\160\63\176\94\221\76\34\142\44\182\66", "\113\226\77\197\42\188\32")]:FullRechargeTime() < 4) or (v160:TimeToDie() < 5);
	end
	local function v101(v161)
		return ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\24\4\225\161\59\26\199\185\59\5\252", "\213\90\118\148")]:FullRechargeTime() < 4) or (v161:TimeToDie() < 5)) and v91(v33.BrutalSlash) and (v13:BuffUp(v85) or v64);
	end
	local function v102(v162)
		return (v76 < 5) or ((v13:BuffUp(v33.SmolderingFrenzyBuff) or not v13:HasTier(31, 4)) and (v162:DebuffRemains(v33.Rip) > (4 - v25(v33[LUAOBFUSACTOR_DECRYPT_STR_0("\122\61\188\87\64\90\32\177\69\106\78\39\176\87\67\88\43", "\45\59\78\212\54")]:IsAvailable()))) and v13:BuffUp(v33.TigersFury) and (v73 < 2) and (v162:DebuffUp(v33.DireFixationDebuff) or not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\52\95\145\142\160\39\181\241\4\95\140\133", "\144\112\54\227\235\230\78\205")]:IsAvailable() or (v84 > 1)) and (((v162:TimeToDie() < v76) and (v162:TimeToDie() > (5 - v25(v33[LUAOBFUSACTOR_DECRYPT_STR_0("\146\59\7\253\221\90\189\45\28\219\197\82\183\41\1\255\213", "\59\211\72\111\156\176")]:IsAvailable())))) or (v162:TimeToDie() == v76)));
	end
	local function v103(v163)
		return (v163:DebuffRefreshable(v33.LIMoonfireDebuff));
	end
	local function v104(v164)
		return (v92(v33.LIMoonfireDebuff, v164));
	end
	local function v105(v165)
		return ((v73 < 3) or ((v10.CombatTime() < 10) and (v73 < 4))) and (not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\106\142\241\40\104\142\251\44\90\142\236\35", "\77\46\231\131")]:IsAvailable() or v165:DebuffUp(v33.DireFixationDebuff) or (v84 > 1)) and (((v165:TimeToDie() < v76) and (v16:TimeToDie() > 6)) or (v165:TimeToDie() == v76)) and not ((v84 == 1) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\153\91\184\86\181\95\179\116\178\81\133\80\179\70\191\84\169", "\32\218\52\214")]:IsAvailable());
	end
	local function v106(v166)
		return v13:PMultiplier(v33.Rake) > v16:PMultiplier(v33.Rake);
	end
	local function v107(v167)
		return (v167:DebuffRefreshable(v33.RakeDebuff) or (v13:BuffUp(v33.SuddenAmbushBuff) and (v13:PMultiplier(v33.Rake) > v167:PMultiplier(v33.Rake)))) and v91(v33.Rake);
	end
	local function v108(v168)
		return v168:DebuffRemains(v33.Rip) > 5;
	end
	local function v109(v169)
		return (v169:DebuffDown(v33.AdaptiveSwarmDebuff) or (v169:DebuffRemains(v33.AdaptiveSwarmDebuff) < 2)) and (v169:DebuffStack(v33.AdaptiveSwarmDebuff) < 3) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\111\19\48\184\229\185\83\95\125\0\48\186\252", "\58\46\119\81\200\145\208\37")]:InFlight() and (v169:TimeToDie() > 5);
	end
	local function v110(v170)
		return (v170:DebuffRefreshable(v33.LIMoonfireDebuff));
	end
	local function v111(v171)
		return (v13:BuffUp(v33.SuddenAmbushBuff) and (v13:PMultiplier(v33.Rake) > v171:PMultiplier(v33.Rake))) or v171:DebuffRefreshable(v33.RakeDebuff);
	end
	local function v112(v172)
		return v13:BuffUp(v33.SuddenAmbushBuff) and (v13:PMultiplier(v33.Rake) > v172:PMultiplier(v33.Rake));
	end
	local function v113(v173)
		return v13:PMultiplier(v33.Rake) > v173:PMultiplier(v33.Rake);
	end
	local function v114(v174)
		return ((v13:HasTier(31, 2) and (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\13\137\34\173\165\155\36\46\130\42\181", "\86\75\236\80\204\201\221")]:CooldownRemains() < 2) and (v174:DebuffRemains(v33.Rip) < 10)) or (((v10.CombatTime() < 8) or v13:BuffUp(v33.BloodtalonsBuff) or not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\80\77\120\138\250\159\115\77\120\139\237", "\235\18\33\23\229\158")]:IsAvailable() or (v13:BuffUp(v85) and (v174:DebuffRemains(v33.Rip) < 2))) and v174:DebuffRefreshable(v33.Rip))) and (not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\96\168\200\182\81\182\246\169\81\174\201", "\219\48\218\161")]:IsAvailable() or (v84 == 1)) and not (v13:BuffUp(v33.SmolderingFrenzyBuff) and (v174:DebuffRemains(v33.Rip) > 2));
	end
	local function v115(v175)
		return (v175:DebuffRefreshable(v33.ThrashDebuff));
	end
	local function v116()
		local v176 = 0;
		while true do
			if ((2 == v176) or (3053 <= 469)) then
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\23\208\81\95", "\211\69\177\58\58")]:IsReady() or (540 >= 1869)) then
					if ((3292 == 3292) and v24(v33.Rake, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\228\114\240\169\219\165\224\122\250\228\201\182\241\57\173", "\171\215\133\25\149\137");
					end
				end
				break;
			end
			if ((1038 <= 2645) and (v176 == 1)) then
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\7\73\208\62\140", "\62\87\59\191\73\224\54")]:IsCastable() and (v51 == LUAOBFUSACTOR_DECRYPT_STR_0("\198\14\237\200\254\17", "\169\135\98\154"))) or (3230 < 2525)) then
					if (v24(v33.Prowl) or (2400 > 4083)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\101\43\67\241\115\216\217\114\39\91\240\49\201\223\55\112", "\168\171\23\68\52\157\83");
					end
				elseif ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\196\99\250\186\41", "\231\148\17\149\205\69\77")]:IsCastable() and (v51 == LUAOBFUSACTOR_DECRYPT_STR_0("\164\174\212\239\86\241\131\162", "\159\224\199\167\155\55")) and v16:IsInRange(v52)) or (2745 > 4359)) then
					if ((172 <= 1810) and v24(v33.Prowl)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\231\225\51\197\251\179\44\192\242\240\51\223\245\242\40\146\163", "\178\151\147\92");
					end
				end
				if ((v53 and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\187\244\64\54\49\68\123\158\250\73", "\26\236\157\44\82\114\44")]:IsCastable() and not v16:IsInRange(8)) or (492 >= 4959)) then
					if (v24(v33.WildCharge, not v16:IsInRange(28)) or (756 == 2072)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\39\217\95\21\45\221\90\56\41\208\27\58\60\208\88\37\35\215\90\62\110\131", "\59\74\78\181");
					end
				end
				v176 = 2;
			end
			if ((1605 <= 4664) and (v176 == 0)) then
				if ((1816 == 1816) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\199\112\104\111\212\93\237", "\128\132\17\28\41\187\47")]:IsCastable() and v50) then
					if (v24(v33.CatForm) or (621 > 3100)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\2\51\18\5\91\14\32\11\122\77\19\55\5\53\80\3\51\18\122\15", "\61\97\82\102\90");
					end
				end
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\132\43\170\89\211\120\24\61\164\43\156\66\203\83", "\105\204\78\203\43\167\55\126")]:IsCastable() or (1157 >= 4225)) then
					if (v24(v33.HeartOfTheWild) or (4986 == 4138)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\175\34\12\7\59\200\87\154\190\43\27\44\19\206\93\161\234\51\12\22\7\200\92\167\171\55\94\71", "\49\197\202\67\126\115\100\167");
					end
				end
				v176 = 1;
			end
		end
	end
	local function v117()
		local v177 = 0;
		local v178;
		local v179;
		local v180;
		while true do
			if ((v177 == 0) or (2033 <= 224)) then
				v64 = v33[LUAOBFUSACTOR_DECRYPT_STR_0("\195\196\61\245\235\36\253\78\238\198\33", "\34\129\168\82\154\143\80\156")]:IsAvailable() and (v13:BuffStack(v33.BloodtalonsBuff) <= 1);
				v178 = v13:IsInParty() and not v13:IsInRaid();
				v65 = (v84 == 1) and not v178;
				v177 = 1;
			end
			if ((v177 == 3) or (1223 == 2011)) then
				v179 = v10.CombatTime();
				v180 = v179 + v76;
				v72 = (v71 or v34[LUAOBFUSACTOR_DECRYPT_STR_0("\107\12\212\167\39\202\94\4\210\164\49\250\78\4\206\172\42", "\184\60\101\160\207\66")]:IsEquipped() or v34[LUAOBFUSACTOR_DECRYPT_STR_0("\16\145\116\185\34\141\122\168\57\135\89\177\51\135\110\175\62\151\112", "\220\81\226\28")]:IsEquipped() or ((v180 > 150) and (v180 < 200)) or ((v180 > 270) and (v180 < 295)) or ((v180 > 395) and (v180 < 400)) or ((v180 > 490) and (v180 < 495))) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\48\218\140\237\229\204\22\225\138\254\217\215\26\199\139\239\249", "\167\115\181\226\155\138")]:IsAvailable() and not v178 and (v84 == 1) and v13:HasTier(31, 2);
				break;
			end
			if ((4827 > 4695) and (v177 == 1)) then
				v66 = (v76 > (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\166\189\61\29\71\69\140\177\186\54\56\88\71\155\140\166\32", "\233\229\210\83\107\40\46")]:CooldownRemains() + 3)) and ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\224\81\58\215\8\192\76\55\197\34\212\75\54\215\11\194\71", "\101\161\34\82\182")]:IsAvailable() and (v76 < (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\203\2\87\232\212\233\135\26\224\8\106\238\210\240\139\58\251", "\78\136\109\57\158\187\130\226")]:CooldownRemains() + 60))) or (not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\31\44\241\240\51\62\247\244\45\24\236\248\58\62\247\242\59", "\145\94\95\153")]:IsAvailable() and (v76 < (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\222\194\26\195\65\188\248\249\28\208\125\167\244\223\29\193\93", "\215\157\173\116\181\46")]:CooldownRemains() + 12))));
				v67 = (v76 > (30 + (v85:CooldownRemains() / 1.6))) and ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\23\177\153\225\223\39\191\163\247\219\39\160\132\244\206\61\177\167\251\213\59", "\186\85\212\235\146")]:IsAvailable() and (v76 < (90 + (v85:CooldownRemains() / 1.6)))) or (not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\224\132\4\237\60\252\83\234\132\23\236\45\225\94\214\137\19\210\48\225\86", "\56\162\225\118\158\89\142")]:IsAvailable() and (v76 < (180 + v85:CooldownRemains()))));
				v68 = true;
				v177 = 2;
			end
			if ((3710 > 3065) and (v177 == 2)) then
				v69 = true;
				v70 = true;
				v71 = true;
				v177 = 3;
			end
		end
	end
	local function v118()
		local v181 = 0;
		while true do
			if ((2135 <= 2696) and (2 == v181)) then
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\1\231\114\228\73\193\134\36\220\90", "\224\77\174\63\139\38\175")]:IsReady() or (1742 > 4397)) then
					if ((3900 >= 1904) and v32.CastCycle(v33.LIMoonfire, v83, v110, not v16:IsSpellInRange(v33.LIMoonfire), nil, nil, v63.MoonfireMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\137\78\87\32\130\72\74\43\187\66\89\58\196\67\77\39\136\69\93\60\196\25", "\78\228\33\56");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\250\118\160\2\150\198", "\229\174\30\210\99")]:IsCastable() and v16:DebuffRefreshable(v33.ThrashDebuff) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\47\229\148\80\254\53\48\21\234\165\93\236\42\42", "\89\123\141\230\49\141\93")]:IsAvailable()) or (1724 == 909)) then
					if ((1282 < 1421) and v24(v33.Thrash, not v80)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\231\121\228\13\3\66\179\115\227\5\28\78\246\99\182\93\64", "\42\147\17\150\108\112");
					end
				end
				if ((4876 >= 4337) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\45\180\56\107\230\228\60\170\44\108\239", "\136\111\198\77\31\135")]:IsReady() and not (v64 and v90(v33.BrutalSlash))) then
					if ((4005 >= 3005) and v24(v33.BrutalSlash, not v80)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\27\178\66\188\232\40\186\14\8\180\94\253\230\2\160\14\13\162\68\253\181\69", "\201\98\105\199\54\221\132\119");
					end
				end
				v181 = 3;
			end
			if ((v181 == 3) or (4781 <= 4448)) then
				if ((1317 > 172) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\138\27\138\49\7", "\204\217\108\227\65\98\85")]:IsReady() and ((v84 > 1) or v33[LUAOBFUSACTOR_DECRYPT_STR_0("\105\202\249\225\31\204\95\208\253\224\63", "\160\62\163\149\133\76")]:IsAvailable())) then
					if ((4791 == 4791) and v24(v33.Swipe, not v80)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\183\4\63\198\150\162\24\38\207\210\165\31\111\146\130", "\163\182\192\109\79");
					end
				end
				if ((3988 > 1261) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\7\46\18\197\241", "\149\84\70\96\160")]:IsReady() and not (v64 and v90(v33.Shred))) then
					if ((2240 <= 3616) and v24(v33.Shred, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\14\31\232\60\70\15\248\49\10\9\232\42\70\92\187", "\141\88\102\109");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\159\122\231\127\21\51\83\200\161\86", "\161\211\51\170\16\122\93\53")]:IsReady() and v64 and v91(v33.LIMoonfire)) or (3988 < 3947)) then
					if ((4644 == 4644) and v24(v33.LIMoonfire, not v16:IsSpellInRange(v33.LIMoonfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\161\189\38\253\167\160\45\196\173\179\60\187\172\167\33\247\170\183\58\187\255\234", "\72\155\206\210");
					end
				end
				v181 = 4;
			end
			if ((1323 > 1271) and (v181 == 1)) then
				if ((1619 > 1457) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\111\119\120\25", "\45\61\22\19\124\19\203")]:IsReady() and (v16:DebuffRefreshable(v33.RakeDebuff) or (v13:BuffUp(v33.SuddenAmbushBuff) and (v13:PMultiplier(v33.Rake) > v16:PMultiplier(v33.Rake)) and (v16:DebuffRemains(v33.RakeDebuff) > 6))) and v13:BuffDown(v33.Clearcasting) and not (v64 and v90(v33.Rake))) then
					if (v24(v33.Pool) or (2860 < 1808)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\241\29\2\249\66\118\182\211\82\63\244\9\117\249\200\28\77\215\23\121\181\197\23\31\189\75", "\217\161\114\109\149\98\16");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\33\40\57\120\179\99\31\37\52\120", "\20\114\64\88\28\220")]:IsCastable() and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\3\0\217\177", "\221\81\97\178\212\152\176")]:IsReady() and v13:BuffDown(v33.SuddenAmbushBuff) and (v16:DebuffRefreshable(v33.RakeDebuff) or (v16:PMultiplier(v33.Rake) < 1.4)) and not (v64 and v90(v33.Rake)) and v13:BuffDown(v33.Prowl)) or (739 >= 1809)) then
					if ((1539 <= 4148) and v24(v33.Shadowmeld)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\239\28\255\21\218\234\24\247\30\141\229\8\242\22\201\226\15\187\78", "\122\173\135\125\155");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\182\192\11\188", "\168\228\161\96\217\95\81")]:IsReady() and (v16:DebuffRefreshable(v33.RakeDebuff) or (v13:BuffUp(v33.SuddenAmbushBuff) and (v13:PMultiplier(v33.Rake) > v16:PMultiplier(v33.Rake)))) and not (v64 and v90(v33.Rake))) or (434 > 3050)) then
					if (v24(v33.Rake, not v79) or (3054 < 1683)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\208\37\89\111\85\206\216\34\88\42\69\155\135", "\55\187\177\78\60\79");
					end
				end
				v181 = 2;
			end
			if ((47 < 2706) and (v181 == 0)) then
				if ((1519 >= 580) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\214\42\245\93\104\121", "\166\130\66\135\60\27\17")]:IsCastable() and v16:DebuffRefreshable(v33.ThrashDebuff) and (not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\96\67\220\112\22\77\82\207\97\57\75\68", "\80\36\42\174\21")]:IsAvailable() or (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\106\25\37\127\104\25\47\123\90\25\56\116", "\26\46\112\87")]:IsAvailable() and v16:DebuffUp(v33.DireFixationDebuff))) and v13:BuffUp(v33.Clearcasting) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\141\43\185\117\172\183\76\186\190\0\167\117\168\172", "\212\217\67\203\20\223\223\37")]:IsAvailable()) then
					if (v24(v33.Thrash, not v80) or (3110 == 4177)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\174\133\186\211\169\133\232\208\175\132\164\214\191\159\232\128", "\178\218\237\200");
					end
				end
				if ((4200 > 2076) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\133\189\244\213\178", "\176\214\213\134")]:IsReady() and (v13:BuffUp(v33.Clearcasting) or (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\208\164\164\209\142\95\65\245\185\191\219\166", "\57\148\205\214\180\200\54")]:IsAvailable() and v16:DebuffDown(v33.DireFixationDebuff))) and not (v64 and v90(v33.Shred))) then
					if (v24(v33.Shred, not v79) or (601 >= 2346)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\245\39\49\114\82\255\32\61\122\22\248\39\116\34", "\22\114\157\85\84");
					end
				end
				if ((3970 <= 4354) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\230\217\6\208\92\250\155\200\202\0\204", "\200\164\171\115\164\61\150")]:IsReady() and (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\156\230\22\81\130\178\199\15\68\144\182", "\227\222\148\99\37")]:FullRechargeTime() < 4) and not (v64 and v90(v33.BrutalSlash))) then
					if (v24(v33.BrutalSlash, not v80) or (1542 < 208)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\64\71\226\248\63\109\65\250\248\32\90\18\244\236\58\94\86\243\235\115\4", "\153\83\50\50\150");
					end
				end
				v181 = 1;
			end
			if ((1612 <= 2926) and (v181 == 4)) then
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\117\109\93\30\54", "\83\38\26\52\110")]:IsReady() and v64 and v91(v33.Swipe)) or (2006 <= 540)) then
					if (v24(v33.Swipe, not v80) or (2412 == 4677)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\0\46\86\93\87\37\83\81\27\35\67\74\87\117\22", "\38\56\119\71");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\193\238\83\211", "\54\147\143\56\182\69")]:IsReady() and v64 and v91(v33.Rake) and (v13:PMultiplier(v33.Rake) >= v16:PMultiplier(v33.Rake))) or (4897 <= 1972)) then
					if ((3101 <= 3584) and v24(v33.Rake, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\128\244\76\159\212\148\246\69\219\211\147\191\27\141", "\191\182\225\159\41");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\31\26\58\84\152\143", "\162\75\114\72\53\235\231")]:IsCastable() and v64 and v91(v33.Thrash)) or (1568 >= 4543)) then
					if ((4258 >= 1841) and v24(v33.Thrash, not v80)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\152\52\86\227\64\10\204\62\81\235\95\6\137\46\4\176\7", "\98\236\92\36\130\51");
					end
				end
				break;
			end
		end
	end
	local function v119()
		local v182 = 0;
		while true do
			if ((v182 == 3) or (3052 >= 3554)) then
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\236\240\167\200\246", "\147\191\135\206\184")]:IsReady() or (2098 > 3885)) then
					if (v24(v33.Swipe, not v80) or (2970 == 1172)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\63\175\209\221\19\179\139\45\153\195\205\90\190\128\45\180\129\138\3", "\210\228\72\198\161\184\51");
					end
				end
				if ((3913 > 3881) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\26\96\222\31\124\192\48\64\225\21", "\174\86\41\147\112\19")]:IsReady()) then
					if ((4932 >= 1750) and v32.CastTargetIf(v33.LIMoonfire, v83, LUAOBFUSACTOR_DECRYPT_STR_0("\86\1\149", "\203\59\96\237\107\69\111\113"), v95, v103, not v16:IsSpellInRange(v33.LIMoonfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\41\25\163\239\55\249\197\33\41\175\224\37\176\214\43\19\147\227\36\249\219\32\19\190\242\113\162\133", "\183\68\118\204\129\81\144");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\61\165\98\225\15", "\226\110\205\16\132\107")]:IsReady() and ((v84 < 4) or v33[LUAOBFUSACTOR_DECRYPT_STR_0("\207\202\242\220\103\226\219\225\205\72\228\205", "\33\139\163\128\185")]:IsAvailable()) and v13:BuffDown(v33.SuddenAmbushBuff) and not (v70 and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\96\81\8\218\100\84\5\205\95\93\23", "\190\55\56\100")]:IsAvailable())) or (135 == 1669)) then
					if ((4802 >= 109) and v32.CastTargetIf(v33.Shred, v81, LUAOBFUSACTOR_DECRYPT_STR_0("\91\174\36", "\147\54\207\92\126\115\131"), v98, nil, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\30\57\39\120\9\62\12\62\48\66\15\107\4\61\49\120\31\62\95\101", "\30\109\81\85\29\109");
					end
				end
				v182 = 4;
			end
			if ((v182 == 0) or (3911 > 4952)) then
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\134\11\25\174\68\164\134\60\165\10\4", "\80\196\121\108\218\37\200\213")]:IsReady() or (265 > 4194)) then
					if ((2655 <= 2908) and v32.CastTargetIf(v33.BrutalSlash, v83, LUAOBFUSACTOR_DECRYPT_STR_0("\13\122\12", "\234\96\19\98\31\43\110"), v98, v100, not v80)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\4\13\71\211\173\126\180\21\19\83\212\164\50\138\9\26\109\197\185\123\135\2\26\64\135\254", "\235\102\127\50\167\204\18");
					end
				end
				if ((963 > 651) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\100\169\231\34\87\38", "\78\48\193\149\67\36")]:IsReady() and (v13:BuffUp(v33.Clearcasting) or (((v84 > 10) or ((v84 > 5) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\20\17\149\26\77\53\61\140\25\86\53\26\178\25\74\53", "\33\80\126\224\120")]:IsAvailable())) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\216\160\17\197\79\228\161\13\195\127\224\169\20\215", "\60\140\200\99\164")]:IsAvailable()))) then
					if (v32.CastCycle(v33.Thrash, v83, v115, not v80) or (3503 <= 195)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\147\252\22\39\177\143\180\5\41\167\184\246\17\47\174\131\241\22\102\246", "\194\231\148\100\70");
					end
				end
				if ((1382 <= 4404) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\117\68\192\167\249\223\75\73\205\167", "\168\38\44\161\195\150")]:IsReady() and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\178\253\137\115", "\118\224\156\226\22\80\136\214")]:IsReady() and v13:BuffDown(v33.SuddenAmbushBuff) and (v88(v83, v33.RakeDebuff) or (v89(v83) < 1.4)) and v13:BuffDown(v33.Prowl) and v13:BuffDown(v33.ApexPredatorsCravingBuff)) then
					if (v24(v33.Shadowmeld) or (4857 <= 767)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\230\88\132\77\249\84\133\78\234\25\129\77\235\102\130\87\231\85\132\71\252\25\214", "\224\34\142\57");
					end
				end
				v182 = 1;
			end
			if ((v182 == 2) or (4018 > 4021)) then
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\182\70\77\94\163\193", "\62\226\46\63\63\208\169")]:IsReady() and (v16:DebuffRefreshable(v33.ThrashDebuff))) or (2270 == 1932)) then
					if (v24(v33.Thrash, not v80) or (3430 <= 1176)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\241\17\71\130\12\5\111\95\234\28\106\129\10\4\35\90\224\11\21\210\75", "\62\133\121\53\227\127\109\79");
					end
				end
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\50\6\39\225\215\162\145\28\21\33\253", "\194\112\116\82\149\182\206")]:IsReady() or (1198 >= 3717)) then
					if ((3730 >= 1333) and v24(v33.BrutalSlash, not v80)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\186\89\12\193\238\49\42\164\77\11\200\162\15\54\173\115\26\213\235\2\61\173\94\88\145\180", "\110\89\200\44\120\160\130");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\135\234\102\73\76\68\61\68\185\198", "\45\203\163\43\38\35\42\91")]:IsReady() and (v84 < 5)) or (2152 == 2797)) then
					if (v32.CastTargetIf(v33.LIMoonfire, v83, LUAOBFUSACTOR_DECRYPT_STR_0("\223\132\196", "\52\178\229\188\67\231\201"), v95, v103, not v16:IsSpellInRange(v33.LIMoonfire)) or (1709 < 588)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\78\95\10\241\85\49\36\126\83\5\227\28\34\46\68\111\6\226\85\47\37\68\66\23\183\13\123", "\67\65\33\48\100\151\60");
					end
				end
				v182 = 3;
			end
			if ((v182 == 4) or (3575 <= 3202)) then
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\203\121\70\183\37\214", "\156\159\17\52\214\86\190")]:IsReady() or (4397 < 3715)) then
					if (v24(v33.Thrash, not v80) or (4075 <= 2245)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\231\175\189\189\231\253\189\161\234\130\190\187\230\177\184\171\253\253\238\248", "\220\206\143\221");
					end
				end
				break;
			end
			if ((v182 == 1) or (3966 > 4788)) then
				if ((3826 > 588) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\237\175\196\217\124\230\80\11\210\163", "\110\190\199\165\189\19\145\61")]:IsReady() and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\232\234\124\237", "\167\186\139\23\136\235")]:IsReady() and v13:BuffDown(v33.SuddenAmbushBuff) and (v89(v83) < 1.4) and v13:BuffDown(v33.Prowl) and v13:BuffDown(v33.ApexPredatorsCravingBuff)) then
					if ((694 <= 1507) and v24(v33.Shadowmeld)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\189\137\9\21\162\133\8\22\177\200\12\21\176\183\15\15\188\132\9\31\167\200\85", "\109\122\213\232");
					end
				end
				if ((3900 >= 1116) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\220\246\169\53", "\80\142\151\194")]:IsReady() and (v13:BuffUp(v33.SuddenAmbushBuff))) then
					if ((4907 > 3311) and v32.CastTargetIf(v33.Rake, v81, LUAOBFUSACTOR_DECRYPT_STR_0("\14\199\111", "\44\99\166\23"), v97, v106, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\110\246\34\51\115\165\115\242\22\52\38\173\112\243\44\36\115\245\44", "\196\28\151\73\86\83");
					end
				end
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\193\2\34\21", "\22\147\99\73\112\226\56\120")]:IsReady() or (3408 <= 2617)) then
					if ((3201 == 3201) and v32.CastCycle(v33.Rake, v81, v111, not v79, nil, nil, v63.RakeMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\116\233\240\205\185\122\231\202\143\173\124\238\241\136\170\53\179\167", "\237\216\21\130\149");
					end
				end
				v182 = 2;
			end
		end
	end
	local function v120()
		local v183 = 0;
		while true do
			if ((2195 == 2195) and (v183 == 1)) then
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\9\23\64\65\244\142\4\58\1\112\71\227\130", "\107\79\114\50\46\151\231")]:IsReady() and v13:BuffDown(v33.ApexPredatorsCravingBuff) and (v13:BuffDown(v85) or (v13:BuffUp(v85) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\10\169\160\37\133\63\163\200\60\128\186\59\143\42\163", "\160\89\198\213\73\234\89\215")]:IsAvailable()))) or (3025 > 3506)) then
					if ((not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\124\120\179\251\215\91\87\161\236\220", "\165\40\17\212\158")]:IsReady() and v13:BuffDown(v33.ApexPredatorsCravingBuff)) or (736 < 356)) then
						if ((1171 <= 2774) and v22(v33.FerociousBite, v13:EnergyTimeToX(50))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\227\220\26\60\37\236\214\29\32\25\231\208\28\54\102\227\208\6\58\53\237\220\26\115\112", "\70\133\185\104\83");
						end
					elseif ((4108 >= 312) and (v13:Energy() >= 50)) then
						if (v32.CastTargetIf(v33.FerociousBite, v81, LUAOBFUSACTOR_DECRYPT_STR_0("\9\68\92", "\169\100\37\36\74"), v98, nil, not v79) or (679 > 2893)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\6\130\176\95\3\142\173\69\19\184\160\89\20\130\226\86\9\137\171\67\8\130\176\16\88", "\48\96\231\194");
						end
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\238\95\28\34\26\209\160\150\219\120\7\57\28", "\227\168\58\110\77\121\184\207")]:IsReady() and ((v13:BuffUp(v85) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\72\51\170\76\190\221\101\173\126\26\176\82\180\200\101", "\197\27\92\223\32\209\187\17")]:IsAvailable()) or v13:BuffUp(v33.ApexPredatorsCravingBuff))) or (876 < 200)) then
					if (v32.CastTargetIf(v33.FerociousBite, v81, LUAOBFUSACTOR_DECRYPT_STR_0("\14\94\219", "\155\99\63\163"), v98, nil, not v79) or (2325 > 3562)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\132\212\179\130\186\141\141\196\178\178\187\141\150\212\225\139\176\138\139\194\169\136\171\196\211\129", "\228\226\177\193\237\217");
					end
				end
				break;
			end
			if ((v183 == 0) or (3661 > 4704)) then
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\182\111\36\26\217\192\229\148\124\57\31", "\178\230\29\77\119\184\172")]:IsCastable() and (v16:DebuffRefreshable(v33.PrimalWrath) or v33[LUAOBFUSACTOR_DECRYPT_STR_0("\193\187\11\9\88\232\240\176\61\20\98\246\241\173", "\152\149\222\106\123\23")]:IsAvailable() or ((v84 > 4) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\239\39\251\83\180\211\50\208\70\167\210\37\255\87\172", "\213\189\70\150\35")]:IsAvailable())) and (v84 > 1) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\127\71\125\5\78\89\67\26\78\65\124", "\104\47\53\20")]:IsAvailable()) or (4133 <= 1928)) then
					if ((4418 >= 1433) and v22(v33.PrimalWrath, v13:EnergyTimeToX(20))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\179\94\136\17\189\3\156\91\147\29\168\7\227\74\136\18\181\28\171\73\147\92\238", "\111\195\44\225\124\220");
					end
				end
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\234\79\16", "\203\184\38\96\19\203")]:IsReady() or (4123 >= 4123)) then
					if (v32.CastCycle(v33.Rip, v81, v114, not v16:IsInRange(8), nil, nil, v63.RipMouseover) or (205 >= 2345)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\43\122\105\1\200\48\125\112\82\198\60\97\57\21", "\174\89\19\25\33");
					end
				end
				v183 = 1;
			end
		end
	end
	local function v121()
		local v184 = 0;
		while true do
			if ((v184 == 1) or (537 == 1004)) then
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\245\48\184\50\182\21\203\61\181\50", "\98\166\88\217\86\217")]:IsCastable() and not (v90(v33.Rake) and (CountActiveBtTriggers() == 2)) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\196\247\114\4", "\188\150\150\25\97\230")]:IsReady() and v13:BuffDown(v33.SuddenAmbushBuff) and (v16:DebuffRefreshable(v33.RakeDebuff) or (v16:PMultiplier(v33.Rake) < 1.4)) and v13:BuffDown(v33.Prowl)) or (2345 < 545)) then
					if ((1649 > 243) and v24(v33.Shadowmeld)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\201\129\94\6\3\250\215\140\83\6\76\239\223\155\76\7\30\230\154\223", "\141\186\233\63\98\108");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\195\235\39\179", "\69\145\138\76\214")]:IsReady() and not (v90(v33.Rake) and (CountActiveBtTriggers() == 2)) and ((v16:DebuffRemains(v33.RakeDebuff) < 3) or (v13:BuffUp(v33.SuddenAmbushBuff) and (v13:PMultiplier(v33.Rake) > v16:PMultiplier(v33.Rake))))) or (3910 <= 3193)) then
					if ((2005 == 2005) and v24(v33.Rake, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\98\206\130\140\255\20\117\221\154\140\173\29\48\151", "\118\16\175\233\233\223");
					end
				end
				if ((4688 > 4572) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\184\140\39\190\234", "\29\235\228\85\219\142\235")]:IsReady() and (CountActiveBtTriggers() == 2) and v91(v33.Shred)) then
					if ((1567 < 3260) and v24(v33.Shred, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\220\168\216\115\14\37\87\47\199\191\207\124\14\118\2", "\50\93\180\218\189\23\46\71");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\252\182\78\88\69\208\123\210\165\72\68", "\40\190\196\59\44\36\188")]:IsReady() and (CountActiveBtTriggers() == 2) and v91(v33.BrutalSlash)) or (3761 == 621)) then
					if ((4755 > 3454) and v24(v33.BrutalSlash, not v80)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\87\201\160\251\113\50\47\73\221\167\242\61\15\57\87\207\177\232\118\77\109\23", "\109\92\37\188\212\154\29");
					end
				end
				v184 = 2;
			end
			if ((4819 >= 1607) and (v184 == 2)) then
				if ((4546 >= 1896) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\40\198\137\204\62\84\2\230\182\198", "\58\100\143\196\163\81")]:IsReady() and (CountActiveBtTriggers() == 2) and v91(v33.LIMoonfire)) then
					if ((3546 > 933) and v24(v33.LIMoonfire, not v16:IsSpellInRange(v33.LIMoonfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\77\44\173\57\64\247\11\37\65\34\183\127\75\224\28\9\71\49\168\127\24\177", "\110\122\34\67\195\95\41\133");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\65\185\73\75\197\125", "\182\21\209\59\42")]:IsReady() and (CountActiveBtTriggers() == 2) and v91(v33.Thrash) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\131\95\215\28\50\182\190\89\194\62\45\191\160\68", "\222\215\55\165\125\65")]:IsAvailable() and v64) or (3985 <= 3160)) then
					if ((1987 == 1987) and v24(v33.Thrash, not v80)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\217\212\27\225\201\173\72\41\195\213\31\224\202\173\27\122", "\42\76\177\166\122\146\161\141");
					end
				end
				if ((994 <= 4540) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\137\163\40\193\118\120\163\131\23\203", "\22\197\234\101\174\25")]:IsReady()) then
					if ((4917 == 4917) and v32.CastCycle(v33.LIMoonfire, v83, v110, not v16:IsSpellInRange(v33.LIMoonfire), nil, nil, v63.MoonfireMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\32\59\170\210\112\166\197\131\18\55\164\200\54\173\210\148\62\49\183\215\54\254\143", "\230\77\84\197\188\22\207\183");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\219\6\211\232\141\173\195\57\248\7\206", "\85\153\116\166\156\236\193\144")]:IsReady() and (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\134\242\88\167\229\12\151\236\76\160\236", "\96\196\128\45\211\132")]:Charges() > 1) and (not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\17\132\105\90\244\166\172\217\33\132\116\81", "\184\85\237\27\63\178\207\212")]:IsAvailable() or v16:DebuffUp(v33.DireFixationDebuff))) or (324 > 4896)) then
					if ((772 < 4670) and v24(v33.BrutalSlash, not v80)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\75\28\75\9\85\54\76\4\88\26\87\72\91\12\77\27\92\27\84\72\11\89", "\63\104\57\105");
					end
				end
				v184 = 3;
			end
			if ((3172 >= 2578) and (v184 == 0)) then
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\18\181\49\233\55\185\44\243\39\146\42\242\49", "\134\84\208\67")]:IsReady() and (v73 == 5) and v68 and (v84 > 1)) or (721 == 834)) then
					if ((1312 < 2654) and v32.CastTargetIf(v33.FerociousBite, v81, LUAOBFUSACTOR_DECRYPT_STR_0("\30\173\158", "\60\115\204\230"), v98, v108, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\63\249\127\228\51\228\101\244\5\233\121\243\63\171\114\226\40\248\117\245\49\171\34", "\16\135\90\139");
					end
				end
				if ((3213 >= 1613) and (v73 == 5) and not ((v13:BuffStack(v33.OverflowingPowerBuff) <= 1) and (CountActiveBtTriggers() == 2) and (v13:BuffStack(v33.BloodtalonsBuff) <= 1) and v13:HasTier(30, 4))) then
					local v228 = 0;
					local v229;
					while true do
						if ((v228 == 0) or (3786 > 4196)) then
							v229 = v120();
							if ((4218 == 4218) and v229) then
								return v229;
							end
							break;
						end
					end
				end
				if ((1517 < 4050) and (v84 > 1)) then
					local v230 = 0;
					local v231;
					while true do
						if ((4390 == 4390) and (1 == v230)) then
							if ((1919 > 289) and v24(v33.Pool)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\99\117\15\39\14\82\119\70\52\39\60\75\118\109\93\120\2\54\92\28\49", "\24\52\20\102\83\46\52");
							end
							break;
						end
						if ((v230 == 0) or (1205 < 751)) then
							v231 = v119();
							if (v231 or (2561 <= 1717)) then
								return v231;
							end
							v230 = 1;
						end
					end
				end
				if ((1723 <= 3600) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\244\61\46\51\3", "\111\164\79\65\68")]:IsReady() and not (v90(v33.Rake) and (CountActiveBtTriggers() == 2)) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\244\216\136\219", "\138\166\185\227\190\78")]:IsReady() and v13:BuffDown(v33.SuddenAmbushBuff) and (v16:DebuffRefreshable(v33.RakeDebuff) or (v16:PMultiplier(v33.Rake) < 1.4)) and v13:BuffDown(v33.Shadowmeld)) then
					if ((3271 >= 1633) and v24(v33.Prowl)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\219\102\202\32\94\99\27\206\102\214\50\64\40\89\159", "\121\171\20\165\87\50\67");
					end
				end
				v184 = 1;
			end
			if ((3103 >= 2873) and (v184 == 3)) then
				if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\56\143\182\65\15", "\36\107\231\196")]:IsReady() or (3603 == 725)) then
					if ((2843 == 2843) and v24(v33.Shred, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\189\176\130\89\245\160\130\79\166\167\149\86\245\240\213", "\231\61\213\194");
					end
				end
				break;
			end
		end
	end
	local function v122()
		local v185 = 0;
		local v186;
		local v187;
		while true do
			if ((v185 == 0) or (174 >= 2515)) then
				v186, v187 = v93(v83);
				if ((4411 >= 2020) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\32\163\62\114\27\163\60\103\0\162\51", "\19\105\205\93")]:IsReady() and v30 and (((v186 < v76) and (v186 > 25)) or (v186 == v76))) then
					if ((1347 == 1347) and v24(v33.Incarnation, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\160\6\221\128\45\167\9\202\136\48\167\72\221\142\48\165\12\209\150\49\233\94", "\95\201\104\190\225");
					end
				end
				if ((4461 == 4461) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\141\206\211\221\170\217\202", "\174\207\171\161")]:IsReady() and v30 and ((v76 < 25) or (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\206\241\3\229\247\220\232\202\5\246\203\199\228\236\4\231\235", "\183\141\158\109\147\152")]:IsAvailable() and ((v76 < v33[LUAOBFUSACTOR_DECRYPT_STR_0("\15\6\232\26\35\2\227\56\36\12\213\28\37\27\239\24\63", "\108\76\105\134")]:CooldownRemains()) or (v72 and ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\205\192\163\224\194\205\215\180\239\212\242", "\174\139\165\209\129")]:IsReady() and ((v73 < 3) or ((v10.CombatTime() < 10) and (v73 < 4)))) or ((v10.CombatTime() < 10) and (v73 < 4))) and (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\128\188\236\215\201\8\117\76\171\182\209\209\207\17\121\108\176", "\24\195\211\130\161\166\99\16")]:CooldownRemains() < 10)))))) then
					if (v24(v33.Berserk, not v79) or (4340 == 2872)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\68\6\251\63\86\4\77\67\234\35\92\26\66\12\254\34\19\78", "\118\38\99\137\76\51");
					end
				end
				if ((568 <= 2207) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\223\35\23\1\12\50\246", "\64\157\70\101\114\105")]:IsReady() and v30 and not v72 and not (not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\102\186\166\237\4\73\171\138\236\29\69\166\179\246\29", "\112\32\200\199\131")]:IsAvailable() and v34[LUAOBFUSACTOR_DECRYPT_STR_0("\27\89\72\176\198\185\32\45\66\87\171\225\185\35\34\83\84", "\66\76\48\60\216\163\203")]:IsEquipped() and (v84 == 1)) and (not v67 or (v67 and not v66) or (v66 and (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\153\137\119\229\80\197\33\142\142\124\192\79\199\54\179\146\106", "\68\218\230\25\147\63\174")]:CooldownRemains() < 10) and (not v13:HasTier(31, 2) or (v13:HasTier(31, 2) and v13:BuffUp(v33.SmolderingFrenzyBuff))))) and (((v16:TimeToDie() < v76) and (v16:TimeToDie() > 18)) or (v16:TimeToDie() == v76))) then
					if (v24(v33.Berserk, not v79) or (3789 <= 863)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\175\47\65\95\179\191\33\19\79\185\162\38\87\67\161\163\106\2\28", "\214\205\74\51\44");
					end
				end
				v185 = 1;
			end
			if ((238 < 4997) and (v185 == 3)) then
				if ((4285 > 3803) and v30 and v34[LUAOBFUSACTOR_DECRYPT_STR_0("\216\93\252\71\70\111\242", "\26\156\55\157\53\51")]:IsEquippedAndReady()) then
					if ((2672 < 4910) and v24(v63.Djaruun, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\136\210\23\203\173\69\130\231\6\208\180\92\141\202\41\214\190\111\152\208\19\230\189\92\136\221\4\230\190\92\141\213\19\153\181\81\133\214\86\141", "\48\236\184\118\185\216");
					end
				end
				break;
			end
			if ((v185 == 2) or (2956 > 4353)) then
				ShouldReturn = v32.HandleTopTrinket(v35, v30 and (v13:BuffUp(v33.HeartOfTheWild) or v13:BuffUp(v33.Incarnation) or v13:BloodlustUp()), 40, nil);
				if ((3534 > 2097) and ShouldReturn) then
					return ShouldReturn;
				end
				ShouldReturn = v32.HandleBottomTrinket(v35, v30 and (v13:BuffUp(v33.HeartOfTheWild) or v13:BuffUp(v33.Incarnation) or v13:BloodlustUp()), 40, nil);
				if ((3255 >= 534) and ShouldReturn) then
					return ShouldReturn;
				end
				v185 = 3;
			end
			if ((4254 < 4460) and (v185 == 1)) then
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\216\73\240\239\114\232\71", "\23\154\44\130\156")]:IsReady() and ((v76 < 23) or ((((v10.CombatTime() + 118) % 120) < 30) and not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\55\180\172\160\34\26\18\139\162\163\51\29\5\179\160", "\115\113\198\205\206\86")]:IsAvailable() and (v34[LUAOBFUSACTOR_DECRYPT_STR_0("\179\94\234\82\129\69\252\91\150\92\237\120\150\86\240\89\140", "\58\228\55\158")]:IsEquipped() or v34[LUAOBFUSACTOR_DECRYPT_STR_0("\149\154\216\43\47\162\51\160\129\213\11\49\175\48\166\154\223\59\48", "\85\212\233\176\78\92\205")]:IsEquipped()) and (v84 == 1)))) or (4661 <= 4405)) then
					if ((4575 >= 1943) and v24(v33.Berserk, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\72\93\154\241\79\74\131\162\73\87\135\238\78\87\159\236\10\9\218", "\130\42\56\232");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\200\176\54\240\69\45\225\188\42\228", "\95\138\213\68\131\32")]:IsCastable() and v30 and (not v65 or v13:BuffUp(v85))) or (326 > 1137)) then
					if ((1284 == 1284) and v24(v33.Berserking, not v79)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\40\45\179\80\115\56\35\168\77\113\106\43\174\76\122\46\39\182\77\54\123\122", "\22\74\72\193\35");
					end
				end
				if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\15\118\234\78\35\114\225\108\36\124\215\72\37\107\237\76\63", "\56\76\25\132")]:IsReady() and v30) or (3072 >= 3426)) then
					if (v24(v33.ConvokeTheSpirits, not v79) or (4036 > 4375)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\93\206\165\48\192\85\196\148\50\199\91\254\184\54\198\76\200\191\53\143\93\206\164\42\203\81\214\165\102\158\8", "\175\62\161\203\70");
					end
				end
				if ((3928 == 3928) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\31\210\205\5\58\55\216\247\27\48\15\205\202\1\60\40\206", "\85\92\189\163\115")]:IsReady() and v30 and v13:BuffUp(v33.SmolderingFrenzyBuff) and (v13:BuffRemains(v33.SmolderingFrenzyBuff) < (5.1 - v25(v33[LUAOBFUSACTOR_DECRYPT_STR_0("\8\191\56\57\36\173\62\61\58\139\37\49\45\173\62\59\44", "\88\73\204\80")]:IsAvailable())))) then
					if (v24(v33.ConvokeTheSpirits, not v79) or (2629 >= 3005)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\140\30\80\38\209\43\188\4\78\44\229\61\147\25\84\32\206\61\195\19\73\38\214\42\140\7\72\105\136\120", "\186\78\227\112\38\73");
					end
				end
				v185 = 2;
			end
		end
	end
	local function v123()
		local v188 = 0;
		while true do
			if ((v188 == 7) or (2620 <= 422)) then
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\47\254\30\246\21\245\13\241", "\130\124\155\106")][LUAOBFUSACTOR_DECRYPT_STR_0("\224\216\243\157\166\241\110\176\194\223\254", "\223\181\171\150\207\195\150\28")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\63\247\186\0\66\61\240", "\105\44\90\131\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\243\183\139\13\57\237\239\165\173\0\19\240\245\161\188\7\40\250\242", "\94\159\128\210\217\104")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\252\18\171\86\113\254\105", "\26\48\153\102\223\63\31\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\48\69\234\225\13\87\249\251\42\112", "\147\98\32\141")] or 0;
				break;
			end
			if ((1896 > 1857) and (2 == v188)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\183\26\57\254\212\167\162", "\192\209\210\110\77\151\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\6\35\229\235\204\243\23\45\231\250\236\208", "\164\128\99\66\137\159")] or 0;
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\51\140\253\170\9\135\238\173", "\222\96\233\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\178\169\27\132\246\209\191\181\171\22\139\231\245\189", "\144\217\211\199\127\232\147")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\42\42\60\220\75\5\87", "\36\152\79\94\72\181\37\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\217\73\59\219\221\110\49\212\215\85\47\216\202\66\62\219", "\95\183\184\39")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\58\243\50\93\142\5\166", "\98\213\95\135\70\52\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\215\173\221\114\70\236\182\217\99\99\247\183\193\68\64\235\173", "\52\158\195\169\23")];
				v188 = 3;
			end
			if ((1466 >= 492) and (v188 == 0)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\184\67\36\198\58\226\174", "\84\133\221\55\80\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\244\33\148\198\95\180\230\40\181", "\60\221\135\68\198\167")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\184\236\151\75\215\233\174", "\185\142\221\152\227\34")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\214\82\210\70\50\251\81\203\80\202\76\39\254\87\203", "\151\56\165\55\154\35\83")] or 0;
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\147\70\17\250\169\77\2\253", "\142\192\35\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\112\40\175\238\130\171\38\217\97\32\172\233\162\173\27\211", "\118\182\21\73\195\135\236\204")] or "";
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\57\14\84\13\3\250\27", "\157\104\92\122\32\100\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\163\206\198\52\41\138\155\172\178\198\197\51\15\189", "\203\195\198\175\170\93\71\237")] or 0;
				v188 = 1;
			end
			if ((868 < 3853) and (v188 == 6)) then
				FrenziedRegenerationHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\210\30\183\183\220\83\187", "\200\153\183\106\195\222\178\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\241\141\51\83\83\55\231\186\56\78\95\60\230\154\60\93\83\61\237\160\13", "\58\82\131\232\93\41")] or 0;
				UseFrenziedRegeneration = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\82\196\1\84\49\132\68", "\95\227\55\176\117\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\109\38\109\185\29\112\57\66\174\28\76\38\76\174\22\123\49\74\191\17\113\45", "\203\120\30\67\43")];
				SurvivalInstinctsHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\32\89\251\208\255\34\94", "\185\145\69\45\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\185\10\11\176\213\156\30\21\143\210\153\11\16\168\223\158\12\49\150", "\188\234\127\121\198")] or 0;
				UseSurvivalInstincts = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\55\7\151\49\60\20\144", "\227\88\82\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\12\191\148\23\97\85\22\172\166\14\90\77\12\174\174\12\112\87\12", "\19\35\127\218\199\98")];
				v188 = 7;
			end
			if ((3 == v188) or (1815 > 4717)) then
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\185\38\96\143\59\124\152", "\235\26\220\82\20\230\85\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\161\175\253\199\102\154\180\249\214\91\134\173\240\245\124\129\181\236\206\125\155\181", "\20\232\193\137\162")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\218\209\178\238\130\16\98", "\17\66\191\165\198\135\236\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\38\161\186\22\237\250\249\193\27\155\166\1\250\251\228\222\3\171", "\177\111\207\206\115\159\136\140")] or 0;
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\140\4\0\221\65\88\22", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\40\232\49\249\34\229\52\255\31\215\25\224", "\86\163\91\141\114\152")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\14\96\103\51\93\12\103", "\90\51\107\20\19")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\227\132\232\56\189\226\138\248\49\162\223\166", "\93\237\144\229\143")] or "";
				v188 = 4;
			end
			if ((3671 == 3671) and (v188 == 1)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\78\42\193\88\31\251\61", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\71\251\193\142\10\81\114\93\238\240\171\14\116\112\126\236", "\25\18\136\164\195\107\35")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\189\91\123\178\198\171", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\229\56\202\13\208\166\40\238\62\220\14\207", "\226\77\140\75\186\104\188")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\203\196\43\70\183\201\195", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\212\101\18\183\88\90\51\190\219\101", "\70\216\189\22\98\210\52\24")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\218\183\147\218\212\216\176", "\179\186\191\195\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\44\29\204\252\62\20\240\241\44\12\235\247\58", "\132\153\95\120")];
				v188 = 2;
			end
			if ((216 <= 284) and (v188 == 5)) then
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\140\51\41\151\185\250\228\172", "\131\223\86\93\227\208\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\86\179\152\28\161\246\87\179\165\43\188\228\76\186", "\213\131\37\214\214\125")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\21\46\49\171\232\40\44\54", "\129\70\75\69\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\104\202\231\252\110\234\85\253\250\238\117\227\110\251", "\143\38\171\147\137\28")] or 0;
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\135\173\231\10\237\211\195", "\180\176\226\217\147\99\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\170\42\53\214\183\42\16\210\181", "\103\179\217\79")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\178\8\193\72\130\164\89", "\195\42\215\124\181\33\236")][LUAOBFUSACTOR_DECRYPT_STR_0("\63\92\57\59\50\249\1\113\7", "\152\109\57\87\94\69")] or 0;
				v188 = 6;
			end
			if ((3257 > 2207) and (4 == v188)) then
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\38\243\228\13\2\72\18\229", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\169\225\45\33\137\239\52\42\190", "\90\77\219\142")] or 0;
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\1\53\45\69\9\125\245", "\26\134\100\65\89\44\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\240\53\20\173\253\231\19\43\165\227\228\53", "\196\145\131\80\67")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\181\18\28\17\230\25\163", "\136\126\208\102\104\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\153\203\97\174\64\54\66\115\131\192", "\49\24\234\174\35\207\50\93")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\247\233\156\120\2\245\238", "\17\108\146\157\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\105\194\6\230\60\163\66\205\60\221", "\200\43\163\116\141\79")] or 0;
				v188 = 5;
			end
		end
	end
	local function v124()
		local v189 = 0;
		local v190;
		while true do
			if ((v189 == 2) or (2087 < 137)) then
				v77 = 5 + v190;
				v78 = 8 + v190;
				if (v29 or (3923 >= 4763)) then
					local v232 = 0;
					while true do
						if ((1744 == 1744) and (1 == v232)) then
							v82 = #v81;
							v84 = #v83;
							break;
						end
						if ((248 <= 1150) and (v232 == 0)) then
							v81 = v13:GetEnemiesInMeleeRange(v77);
							v83 = v13:GetEnemiesInMeleeRange(v78);
							v232 = 1;
						end
					end
				else
					local v233 = 0;
					while true do
						if ((3994 >= 294) and (v233 == 1)) then
							v82 = 1;
							v84 = 1;
							break;
						end
						if ((1641 > 693) and (0 == v233)) then
							v81 = {};
							v83 = {};
							v233 = 1;
						end
					end
				end
				v73 = v13:ComboPoints();
				v189 = 3;
			end
			if ((4 == v189) or (4519 < 2235)) then
				if ((892 < 1213) and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
					if ((3313 <= 4655) and v13:AffectingCombat()) then
						if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\29\27\45\35\19\19\39", "\103\79\126\79\74\97")]:IsReady() or (3956 < 2705)) then
							if ((1959 < 3037) and v24(v63.RebirthMouseover, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\168\122\209\122\76\14\178", "\122\218\31\179\19\62");
							end
						end
					elseif (v24(v63.ReviveMouseover, nil, true) or (1241 > 2213)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\211\219\200\223\164", "\37\211\182\173\161\169\193");
					end
				end
				if ((4905 < 4974) and v45) then
					local v234 = 0;
					while true do
						if ((3557 == 3557) and (v234 == 0)) then
							ShouldReturn = v32.HandleAfflicted(v33.RemoveCorruption, v63.RemoveCorruptionMouseover, 40);
							if ((369 == 369) and ShouldReturn) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if (v46 or (3589 < 2987)) then
					local v235 = 0;
					while true do
						if ((4378 > 2853) and (v235 == 0)) then
							ShouldReturn = v32.HandleIncorporeal(v33.Hibernate, v63.HibernateMouseover, 30, true);
							if (ShouldReturn or (1712 > 3602)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				if ((4539 >= 2733) and not v13:AffectingCombat() and v28) then
					local v236 = 0;
					while true do
						if ((v236 == 0) or (2599 <= 515)) then
							if ((v40 and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\218\59\95\210\7\125\141\255\63\122\208\36\127", "\217\151\90\45\185\72\27")]:IsCastable() and (v13:BuffDown(v33.MarkOfTheWild, true) or v32.GroupBuffMissing(v33.MarkOfTheWild))) or (3754 < 810)) then
								if ((1633 <= 1977) and v24(v63.MarkOfTheWildPlayer)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\206\125\245\25\105\204\122\216\6\94\198\67\240\27\90\199", "\54\163\28\135\114");
								end
							end
							if ((4528 >= 3619) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\11\218\73\164\65\109\37", "\31\72\187\61\226\46")]:IsCastable()) then
								if (v24(v33.CatForm) or (172 >= 2092)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\192\7\87\237\65\113\54\206\70\76\221\68", "\68\163\102\35\178\39\30");
								end
							end
							break;
						end
					end
				end
				v189 = 5;
			end
			if ((2120 == 2120) and (v189 == 0)) then
				v123();
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\44\76\228\205\10\83\88", "\43\120\35\131\170\102\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\91\9\132", "\228\52\102\231\214\197\208")];
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\239\114\205\230\142\10", "\182\126\128\21\170\138\235\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\213\48", "\102\235\186\85\134\230\115\80")];
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\3\57\88\126\209\49", "\66\55\108\94\63\18\180")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\137\150", "\57\116\237\229\87\71")];
				v189 = 1;
			end
			if ((5 == v189) or (2398 == 358)) then
				if ((2387 < 4637) and v32.TargetIsValid() and v16:IsInRange(11)) then
					local v237 = 0;
					while true do
						if ((1265 < 2775) and (v237 == 1)) then
							if (v24(v33.Pool) or (4430 < 51)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\111\39\161\8\22\122\38\171\22\81\70", "\54\63\72\206\100");
							end
							break;
						end
						if ((1871 <= 1998) and (0 == v237)) then
							if ((not v13:AffectingCombat() and v28) or (2083 >= 3954)) then
								local v240 = 0;
								local v241;
								while true do
									if ((1857 > 59) and (v240 == 0)) then
										v241 = v116();
										if (v241 or (1232 == 3045)) then
											return v241;
										end
										break;
									end
								end
							end
							if ((104 == 104) and (v13:AffectingCombat() or v28)) then
								local v242 = 0;
								while true do
									if ((4534 > 2967) and (v242 == 4)) then
										if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\219\206\191\237\170\253\242\222\190\192\160\224\248", "\148\157\171\205\130\201")]:IsReady() and v13:BuffUp(v33.ApexPredatorsCravingBuff) and ((v84 == 1) or not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\19\198\125\36\208\250\20\198\117\61\217", "\150\67\180\20\73\177")]:IsAvailable() or v13:BuffDown(v33.SabertoothBuff)) and not (v64 and (CountActiveBtTriggers() == 2))) or (3449 <= 2368)) then
											if ((4733 >= 3548) and v32.CastTargetIf(v33.FerociousBite, v81, LUAOBFUSACTOR_DECRYPT_STR_0("\128\25\2", "\45\237\120\122"), v98, nil, not v79)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\209\237\176\35\212\225\173\57\196\215\160\37\195\237\226\33\214\225\172\108\134\190", "\76\183\136\194");
											end
										end
										if (v13:BuffUp(v85) or (2005 > 4687)) then
											local v243 = 0;
											local v244;
											while true do
												if ((v243 == 0) or (1767 <= 916)) then
													v244 = v121();
													if ((3589 < 3682) and v244) then
														return v244;
													end
													v243 = 1;
												end
												if ((1 == v243) or (75 >= 430)) then
													if (v24(v33.Pool) or (4157 <= 3219)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\77\231\236\44\16\73\27\104\166\199\61\66\92\17\104\237\173\113", "\116\26\134\133\88\48\47");
													end
													break;
												end
											end
										end
										if ((1823 < 2782) and (v73 == 4) and v13:BuffUp(v33.PredatorRevealedBuff) and (v13:EnergyDeficit() > 40) and (v84 == 1)) then
											if ((3434 >= 1764) and v24(v33.Pool)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\41\192\169\240\253\116\17\211\224\194\180\124\23\210\168\225\175\58\87", "\18\126\161\192\132\221");
											end
										end
										if ((4040 > 1820) and (v73 >= 4)) then
											local v245 = 0;
											local v246;
											while true do
												if ((4192 >= 2529) and (0 == v245)) then
													v246 = v120();
													if ((1554 < 2325) and v246) then
														return v246;
													end
													break;
												end
											end
										end
										v242 = 5;
									end
									if ((1108 < 4525) and (v242 == 0)) then
										if ((not v13:IsCasting() and not v13:IsChanneling()) or (4367 <= 3332)) then
											local v247 = 0;
											local v248;
											while true do
												if ((v247 == 3) or (2896 > 4641)) then
													v248 = v32.InterruptWithStun(v33.IncapacitatingRoar, 8);
													if ((882 > 21) and v248) then
														return v248;
													end
													v247 = 4;
												end
												if ((2373 <= 4789) and (1 == v247)) then
													v248 = v32.Interrupt(v33.SkullBash, 10, true, v14, v63.SkullBashMouseover);
													if (v248 or (1839 < 1136)) then
														return v248;
													end
													v247 = 2;
												end
												if ((3430 == 3430) and (0 == v247)) then
													v248 = v32.Interrupt(v33.SkullBash, 10, true);
													if ((748 <= 2288) and v248) then
														return v248;
													end
													v247 = 1;
												end
												if ((891 < 4473) and (v247 == 4)) then
													if ((v13:BuffUp(v33.CatForm) and (v13:ComboPoints() > 0)) or (3071 <= 2647)) then
														local v258 = 0;
														while true do
															if ((0 == v258) or (633 > 1640)) then
																v248 = v32.InterruptWithStun(v33.Maim, 8);
																if ((3764 > 2404) and v248) then
																	return v248;
																end
																break;
															end
														end
													end
													break;
												end
												if ((v247 == 2) or (3811 >= 4158)) then
													v248 = v32.InterruptWithStun(v33.MightyBash, 8);
													if ((743 > 47) and v248) then
														return v248;
													end
													v247 = 3;
												end
											end
										end
										if ((3599 >= 1059) and v42 and v31 and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\141\127\213\211\11\176", "\113\222\16\186\167\99\213\227")]:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v32.UnitHasEnrageBuff(v16)) then
											if ((1371 <= 2507) and v24(v33.Soothe, not v79)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\42\7\232\230\43\2", "\150\78\110\155");
											end
										end
										if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\181\215\40\246\168", "\32\229\165\71\129\196\126\223")]:IsCastable() and (v13:BuffDown(v85))) or (3607 == 2536)) then
											if ((1126 < 3675) and v24(v33.Prowl)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\211\155\203\150\141\149\206\136\205\143\193\135", "\181\163\233\164\225\225");
											end
										end
										if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\115\138\42\81\95\153\51", "\23\48\235\94")]:IsCastable() or (3344 >= 3615)) then
											if (v24(v33.CatForm) or (4776 <= 210)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\127\219\204\98\81\60\192\113\154\213\92\94\61\146\40", "\178\28\186\184\61\55\83");
											end
										end
										v242 = 1;
									end
									if ((v242 == 5) or (2613 > 2752)) then
										if ((4542 > 2119) and (v84 > 1) and (v73 < 4)) then
											local v249 = 0;
											local v250;
											while true do
												if ((0 == v249) or (1039 == 338)) then
													v250 = v119();
													if (v250 or (4131 > 4610)) then
														return v250;
													end
													break;
												end
											end
										end
										if ((4129 >= 672) and v13:BuffDown(v85) and (v84 == 1) and (v73 < 4)) then
											local v251 = 0;
											local v252;
											while true do
												if ((1019 < 3466) and (v251 == 0)) then
													v252 = v118();
													if ((290 <= 855) and v252) then
														return v252;
													end
													break;
												end
											end
										end
										break;
									end
									if ((4601 > 4446) and (v242 == 1)) then
										if (v13:AffectingCombat() or (995 >= 2099)) then
											local v253 = 0;
											while true do
												if ((961 < 4006) and (1 == v253)) then
													if ((2694 < 4854) and (v13:HealthPercentage() <= FrenziedRegenerationHP) and UseFrenziedRegeneration and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\158\170\25\50\162\177\25\56\138\189\27\57\182\189\14\61\172\177\19\50", "\92\216\216\124")]:IsReady()) then
														if (v24(v33.FrenziedRegeneration, nil, nil, true) or (4174 <= 3733)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\125\32\169\78\231\82\55\168\114\248\92\55\162\69\239\90\38\165\79\243\27\54\169\70\248\85\33\165\86\248\27\96", "\157\59\82\204\32");
														end
													end
													if (((v13:HealthPercentage() <= SurvivalInstinctsHP) and UseSurvivalInstincts and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\11\43\241\236\224\252\210\189\17\48\240\238\224\228\208\165\43", "\209\88\94\131\154\137\138\179")]:IsReady()) or (2626 <= 648)) then
														if ((1595 <= 2078) and v24(v33.SurvivalInstincts, nil, nil, true)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\27\180\214\106\23\53\48\46\1\175\215\104\23\45\50\54\59\225\192\121\24\38\63\49\33\183\193\60\76", "\66\72\193\164\28\126\67\81");
														end
													end
													v253 = 2;
												end
												if ((1635 > 653) and (v253 == 0)) then
													if ((3738 == 3738) and (v13:HealthPercentage() <= v57) and v56 and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\234\204\83\41\224\11\230\242\196\64\53\254", "\149\164\173\39\92\146\110")]:IsReady()) then
														if (v24(v33.NaturesVigil, nil, nil, true) or (3963 > 4742)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\253\38\4\10\8\30\224\24\6\22\29\18\255\103\20\26\28\30\253\52\25\9\31\91\161", "\123\147\71\112\127\122");
														end
													end
													if (((v13:HealthPercentage() <= v59) and v58 and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\254\200\140\116\81\205\193", "\38\172\173\226\17")]:IsReady()) or (4072 > 4695)) then
														if (v24(v33.Renewal, nil, nil, true) or (2220 > 2889)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\95\20\34\234\90\16\32\175\73\20\42\234\67\2\37\249\72\81\126", "\143\45\113\76");
														end
													end
													v253 = 1;
												end
												if ((v253 == 3) or (4914 < 4399)) then
													if ((3660 == 3660) and v34[LUAOBFUSACTOR_DECRYPT_STR_0("\12\10\163\75\48\7\177\83\43\1\167", "\39\68\111\194")]:IsReady() and v43 and (v13:HealthPercentage() <= v44)) then
														if ((2915 >= 196) and v24(v63.Healthstone, nil, nil, true)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\222\163\230\203\109\191\197\178\232\201\124\247\210\163\225\194\119\164\223\176\226\135\42", "\215\182\198\135\167\25");
														end
													end
													if ((v37 and (v13:HealthPercentage() <= v39)) or (4638 < 3902)) then
														if ((v38 == LUAOBFUSACTOR_DECRYPT_STR_0("\191\76\236\90\136\90\226\65\131\78\170\96\136\72\230\65\131\78\170\120\130\93\227\71\131", "\40\237\41\138")) or (1100 >= 1292)) then
															if (v34[LUAOBFUSACTOR_DECRYPT_STR_0("\245\113\252\234\79\212\124\243\246\77\239\113\251\244\67\201\115\202\247\94\206\123\244", "\42\167\20\154\152")]:IsReady() or (547 > 3511)) then
																if (v24(v63.RefreshingHealingPotion, nil, nil, true) or (314 > 2132)) then
																	return LUAOBFUSACTOR_DECRYPT_STR_0("\88\251\164\80\116\50\66\247\172\69\49\41\79\255\174\75\127\38\10\238\173\86\120\46\68\190\166\71\119\36\68\237\171\84\116\97\30", "\65\42\158\194\34\17");
																end
															end
														end
													end
													break;
												end
												if ((932 == 932) and (v253 == 2)) then
													if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\213\41\175\74\41\97\243\36", "\22\135\76\200\56\70")]:IsCastable() and v60 and v13:BuffUp(v33.PredatorySwiftnessBuff) and (v13:HealthPercentage() <= v62)) or (2939 == 4366)) then
														if (v24(v63.RegrowthPlayer) or (3969 <= 3657)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\159\53\255\54\82\246\153\56\184\32\88\231\136\62\235\45\75\228\205\100", "\129\237\80\152\68\61");
														end
													end
													if (((v13:HealthPercentage() <= v55) and v54 and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\115\169\22\248\15\28\81\95", "\56\49\200\100\147\124\119")]:IsReady()) or (1379 == 1462)) then
														if (v24(v33.Barkskin, nil, nil, true) or (4606 <= 3927)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\206\63\173\251\223\53\182\254\140\58\186\246\201\48\172\249\218\59\255\166", "\144\172\94\223");
														end
													end
													v253 = 3;
												end
											end
										end
										if ((v61 and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\40\34\85\30\34\250\15\230", "\142\122\71\50\108\77\141\123")]:IsReady() and v13:BuffUp(v33.PredatorySwiftnessBuff)) or (1578 <= 1012)) then
											if (((v13:HealthPercentage() > v62) and v13:IsInParty() and not v13:IsInRaid()) or (2399 > 3386)) then
												if ((v14 and v14:Exists() and (v14:HealthPercentage() <= v62) and not v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or (3476 > 4701)) then
													if (v24(v63.RegrowthMouseover) or (4374 <= 3729)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\7\167\248\10\52\2\182\247\39\54\26\183\236\29\52\3\167\237", "\91\117\194\159\120");
													end
												end
											end
										end
										v117();
										if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\46\20\57\29\39\226\2\15\15\39", "\68\122\125\94\120\85\145")]:IsCastable() and ((not v13:HasTier(31, 4) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\52\19\193\72\199\210\191\35\20\202\109\216\208\168\30\8\220", "\218\119\124\175\62\168\185")]:IsAvailable()) or v13:BuffDown(v33.TigersFury) or (v13:EnergyDeficit() > 65) or (v13:HasTier(31, 2) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\131\245\90\197\169\214\90\193\171\234\81", "\164\197\144\40")]:CooldownUp()) or ((v76 < 15) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\179\226\175\143\220\162\140\226", "\214\227\144\202\235\189")]:IsAvailable()))) or (4938 <= 1325)) then
											if (v24(v33.TigersFury, not v79) or (2930 > 4142)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\249\172\128\126\2\160\108\58\248\183\158\59\29\178\90\50\173\243", "\92\141\197\231\27\112\211\51");
											end
										end
										v242 = 2;
									end
									if ((583 >= 133) and (v242 == 3)) then
										if ((432 == 432) and v30 and ((v10.CombatTime() > 3) or not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\4\43\255\160\223\129\246\232\52\43\226\171", "\137\64\66\141\197\153\232\142")]:IsAvailable() or (v16:DebuffUp(v33.DireFixationDebuff) and (v73 < 4)) or (v84 > 1)) and not ((v84 == 1) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\32\223\44\176\135\8\213\22\174\141\48\192\43\180\129\23\195", "\232\99\176\66\198")]:IsAvailable())) then
											local v254 = 0;
											local v255;
											while true do
												if ((1456 <= 4224) and (v254 == 0)) then
													v255 = v122();
													if (v255 or (1698 >= 2384)) then
														return v255;
													end
													break;
												end
											end
										end
										if ((2711 < 3812) and v30 and v16:DebuffUp(v33.Rip)) then
											local v256 = 0;
											local v257;
											while true do
												if ((v256 == 0) or (746 >= 2339)) then
													v257 = v122();
													if ((3002 >= 894) and v257) then
														return v257;
													end
													break;
												end
											end
										end
										if (v33[LUAOBFUSACTOR_DECRYPT_STR_0("\202\36\58\7\119\171\235\41\226\59\49", "\76\140\65\72\102\27\237\153")]:IsReady() or (1376 <= 1032)) then
											if ((2427 == 2427) and v32.CastTargetIf(v33.FeralFrenzy, v81, LUAOBFUSACTOR_DECRYPT_STR_0("\71\219\14", "\222\42\186\118\178\183\97"), v98, v105, not v79)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\91\233\86\139\81\211\66\152\88\226\94\147\29\225\69\131\83\172\22\218", "\234\61\140\36");
											end
										end
										if ((3491 > 3393) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\7\216\168\115\3\7\207\191\124\21\56", "\111\65\189\218\18")]:IsReady() and (v73 < 3) and v16:DebuffUp(v33.DireFixationDebuff) and v16:DebuffUp(v33.Rip) and (v84 == 1) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\96\68\21\35\4\87\170\119\67\30\6\27\85\189\74\95\8", "\207\35\43\123\85\107\60")]:IsAvailable()) then
											if (v24(v33.FeralFrenzy, not v79) or (3885 > 4312)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\118\175\178\235\117\79\172\178\239\119\106\179\224\231\120\121\164\224\184\40", "\25\16\202\192\138");
											end
										end
										v242 = 4;
									end
									if ((v242 == 2) or (2128 < 1754)) then
										if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\212\254\129\166", "\177\134\159\234\195")]:IsReady() and (v13:StealthUp(false, true))) or (4584 <= 3272)) then
											if ((1043 <= 3558) and v32.CastCycle(v33.Rake, v81, v113, not v79, nil, nil, v63.RakeMouseover)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\175\234\52\165\137\176\234\54\174\137\236\187", "\169\221\139\95\192");
											end
										end
										if ((71 == 71) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\255\143\126\47\54\47\200\142\76\40\35\52\211", "\70\190\235\31\95\66")]:IsReady() and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\143\236\24\244\236\190\238\31\226\214\173\227\8\235", "\133\218\130\122\134")]:IsAvailable() and (v84 <= 1) and (v13:BuffStack(v33.AdaptiveSwarmHeal) < 4) and (v13:BuffRemains(v33.AdaptiveSwarmHeal) > 4)) then
											if ((2793 == 2793) and v24(v63.AdaptiveSwarmPlayer)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\61\251\226\212\200\170\46\57\192\240\211\221\177\53\124\236\230\200\218\227\53\61\246\237\132\141\247", "\88\92\159\131\164\188\195");
											end
										end
										if ((v33[LUAOBFUSACTOR_DECRYPT_STR_0("\161\42\190\91\195\226\203\133\29\168\74\197\230", "\189\224\78\223\43\183\139")]:IsReady() and (not v33[LUAOBFUSACTOR_DECRYPT_STR_0("\27\242\136\4\200\42\240\143\18\242\57\253\152\27", "\161\78\156\234\118")]:IsAvailable() or (v84 == 1))) or (561 > 911)) then
											if (v32.CastCycle(v33.AdaptiveSwarm, v83, v109, not v16:IsSpellInRange(v33.AdaptiveSwarm), nil, nil, v63.AdaptiveSwarmMouseover) or (677 >= 4143)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\166\179\200\204\179\190\223\217\152\164\222\221\181\186\137\209\166\190\199\156\246\229", "\188\199\215\169");
											end
										end
										if ((4422 > 2292) and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\221\13\94\107\252\245\31\90\72\255\253\27\82", "\136\156\105\63\27")]:IsReady() and v33[LUAOBFUSACTOR_DECRYPT_STR_0("\46\130\123\38\18\136\117\49\31\191\110\53\9\129", "\84\123\236\25")]:IsAvailable() and (v84 > 1)) then
											if (v32.CastTargetIf(v33.AdaptiveSwarm, v83, LUAOBFUSACTOR_DECRYPT_STR_0("\253\138\178", "\213\144\235\202\119\204"), v94, v99, not v16:IsSpellInRange(v33.AdaptiveSwarm)) or (3386 <= 2556)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\34\28\223\58\60\42\91\38\39\205\61\41\49\64\99\21\223\35\38\99\28\112", "\45\67\120\190\74\72\67");
											end
										end
										v242 = 3;
									end
								end
							end
							v237 = 1;
						end
					end
				end
				break;
			end
			if ((3 == v189) or (4932 < 902)) then
				v74 = v13:ComboPointsDeficit();
				v79 = v16:IsInRange(v77);
				v80 = v16:IsInRange(v78);
				if (v32.TargetIsValid() or v13:AffectingCombat() or (503 >= 1425)) then
					local v238 = 0;
					while true do
						if ((4871 == 4871) and (v238 == 1)) then
							if ((2515 > 2280) and (v76 == 11111)) then
								v76 = v10.FightRemains(v83, false);
							end
							break;
						end
						if ((3008 == 3008) and (v238 == 0)) then
							v75 = v10.BossFightRemains(nil, true);
							v76 = v75;
							v238 = 1;
						end
					end
				end
				v189 = 4;
			end
			if ((295 < 775) and (v189 == 1)) then
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\190\234\224\123\235\84", "\39\202\209\141\135\23\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\58\26\26\55\244", "\152\159\83\105\106\82")];
				if (v13:IsDeadOrGhost() or (4828 <= 3019)) then
					return;
				end
				if ((2317 >= 2150) and (v13:BuffUp(v33.TravelForm) or v13:IsMounted())) then
					return;
				end
				v190 = v27(1.5 * v33[LUAOBFUSACTOR_DECRYPT_STR_0("\160\213\69\224\200\80\168\200\87\254\220\89\143\197\84", "\60\225\166\49\146\169")]:TalentRank());
				v189 = 2;
			end
		end
	end
	local function v125()
		local v191 = 0;
		while true do
			if ((v191 == 0) or (3148 == 739)) then
				v33[LUAOBFUSACTOR_DECRYPT_STR_0("\250\80\85", "\27\168\57\37\26\133")]:RegisterAuraTracking();
				v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\11\175\110\169\219\109\142\110\189\222\41\234\126\177\151\8\186\117\171\151\15\165\115\165\252", "\183\77\202\28\200"));
				v191 = 1;
			end
			if ((4576 < 4666) and (v191 == 1)) then
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\49\54\155\9\27\115\173\26\2\58\141\72\47\115\159\72\70\99\199\90\89\99\217\72\53\42\201\42\24\60\132\35", "\104\119\83\233"));
				break;
			end
		end
	end
	v20.SetAPL(103, v124, v125);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\208\232\46\58\124\209\234\50\43\71\202\222\34\48\66\249\182\43\55\66", "\35\149\152\71\66")]();

