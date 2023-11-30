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
		if ((v5 == 1) or (3902 <= 148)) then
			return v6(...);
		end
		if ((4691 > 171) and (0 == v5)) then
			v6 = v0[v4];
			if (not v6 or (2173 > 4840)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\136\207\31\220\194\213\26\195\183\194\19\212\205\207\36\234\245\203\11\208", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\107\210\35\239\69\87\243\253\84", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\204\82\179", "\38\156\55\199")];
	local v17 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\156\124\110\47\22\96", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\150\67\197\180\51\99\32\196\183\90", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\96\86\5\40", "\69\41\34\96")];
	local v21 = EpicLib;
	local v22 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local v24 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local v26 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local v27 = GetTimelocal;
	local v28 = GetWeaponEnchantInfo;
	local v29;
	local v30 = false;
	local v31 = false;
	local v32 = false;
	local v33 = false;
	local v34 = false;
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
	local v92;
	local v93;
	local v94;
	local v95;
	local v96;
	local v97;
	local v98 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\244\92\113\25\184\16", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\34\37\141\177\23\232\201\34", "\156\168\78\64\224\212\121")];
	local v99 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\52\230\164\195\6\224", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\36\90\53\32\80\236\87\36", "\152\54\72\63\88\69\62")];
	local v100 = v23[LUAOBFUSACTOR_DECRYPT_STR_0("\231\204\239\81\213\202", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\82\0\36\34\227\6\89\82", "\114\56\62\101\73\71\141")];
	local v101 = {};
	local v102 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\155\230\214\201\183\231\200", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\247\240\52\160\191\241\5\215", "\107\178\134\81\210\198\158")];
	local function v103()
		if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\2\135\199\164\43\11\177\214\163\42\7\150", "\202\88\110\226\166")]:IsAvailable() or (3884 < 1346)) then
			v102[LUAOBFUSACTOR_DECRYPT_STR_0("\231\6\145\231\207\207\3\131\245\198\198\43\135\245\223\197\9\145", "\170\163\111\226\151")] = v102[LUAOBFUSACTOR_DECRYPT_STR_0("\53\57\161\40\75\59\37\16\50\190\61\109\34\59\2\53\150\61\76\34\47\23\35", "\73\113\80\210\88\46\87")];
		end
	end
	v10:RegisterForEvent(function()
		v103();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\160\15\249\59\209\164\19\253\62\198\184\9\255\45\212\177\9\238\59\198\173\5\247\51\211\168\3\227\45\196\169\13\227\53\194\165", "\135\225\76\173\114"));
	v10:RegisterForEvent(function()
		local v137 = 0;
		while true do
			if ((3360 == 3360) and (v137 == 1)) then
				v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\133\169\77\38\157\3\3\49", "\112\69\228\223\44\100\232\113")]:RegisterInFlight();
				break;
			end
			if ((1082 <= 2816) and (v137 == 0)) then
				v98[LUAOBFUSACTOR_DECRYPT_STR_0("\42\255\177\189\163\175\163\19\236\180\135\173\171\162", "\199\122\141\216\208\204\221")]:RegisterInFlightEffect(327162);
				v98[LUAOBFUSACTOR_DECRYPT_STR_0("\157\207\25\253\119\228\169\212\17\252\79\247\187\216", "\150\205\189\112\144\24")]:RegisterInFlight();
				v137 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\248\58\38\225\152\89\162\235\44\55\246\154\80\185\253\49\56\231\151\94", "\230\180\127\103\179\214\28"));
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\188\23\86\75\235\83\228\133\4\83\113\229\87\229", "\128\236\101\63\38\132\33")]:RegisterInFlightEffect(327162);
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\156\187\24\73\185\249\203\165\168\29\115\183\253\202", "\175\204\201\113\36\214\139")]:RegisterInFlight();
	v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\205\35\221\38\82\222\38\200", "\100\39\172\85\188")]:RegisterInFlight();
	local v104 = 11111;
	local v105 = 11111;
	local v106, v107;
	local v108, v109;
	local v110 = 0;
	local v111 = 0;
	local function v112()
		return 40 - (v27() - Shaman[LUAOBFUSACTOR_DECRYPT_STR_0("\129\121\170\148\7\254\40\235\144\48\143\109\191\134", "\83\205\24\217\224")]);
	end
	local function v113(v138)
		return (v138:DebuffRefreshable(v98.FlameShockDebuff));
	end
	local function v114(v139)
		return v139:DebuffRefreshable(v98.FlameShockDebuff) and (v139:DebuffRemains(v98.FlameShockDebuff) < (v139:TimeToDie() - 5));
	end
	local function v115(v140)
		return v140:DebuffRefreshable(v98.FlameShockDebuff) and (v140:DebuffRemains(v98.FlameShockDebuff) < (v140:TimeToDie() - 5)) and (v140:DebuffRemains(v98.FlameShockDebuff) > 0);
	end
	local function v116(v141)
		return (v141:DebuffRemains(v98.FlameShockDebuff));
	end
	local function v117(v142)
		return v142:DebuffRemains(v98.FlameShockDebuff) > 2;
	end
	local function v118(v143)
		return (v143:DebuffRemains(v98.LightningRodDebuff));
	end
	local function v119()
		local v144 = 0;
		local v145;
		while true do
			if ((v144 == 0) or (3830 >= 4328)) then
				v145 = v14:Maelstrom();
				if (not v14:IsCasting() or (1099 >= 4754)) then
					return v145;
				elseif ((4871 <= 4892) and v14:IsCasting(v98.ElementalBlast)) then
					return v145 - 75;
				elseif (v14:IsCasting(v98.Icefury) or (2393 <= 1632)) then
					return v145 + 25;
				elseif ((2414 == 2414) and v14:IsCasting(v98.LightningBolt)) then
					return v145 + 10;
				elseif ((1584 == 1584) and v14:IsCasting(v98.LavaBurst)) then
					return v145 + 12;
				elseif ((2285 > 2073) and v14:IsCasting(v98.ChainLightning)) then
					return v145 + (4 * v111);
				else
					return v145;
				end
				break;
			end
		end
	end
	local function v120()
		local v146 = 0;
		local v147;
		while true do
			if ((v146 == 0) or (2894 < 2799)) then
				if (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\203\196\222\41\227\215\194\59\242\205\200\24\234\192\192\56\232\209\222", "\93\134\165\173")]:IsAvailable() or (1275 > 3605)) then
					return false;
				end
				v147 = v14:BuffUp(v98.MasteroftheElementsBuff);
				v146 = 1;
			end
			if ((240 < 1190) and (v146 == 1)) then
				if (not v14:IsCasting() or (635 > 2257)) then
					return v147;
				elseif ((1961 > 534) and v14:IsCasting(v98.LavaBurst)) then
					return true;
				elseif ((196 <= 3023) and v14:IsCasting(v98.ElementalBlast)) then
					return false;
				elseif ((2048 <= 3047) and v14:IsCasting(v98.Icefury)) then
					return false;
				elseif (v14:IsCasting(v98.LightningBolt) or (411 >= 2970)) then
					return false;
				elseif ((1312 <= 2793) and v14:IsCasting(v98.ChainLightning)) then
					return false;
				else
					return v147;
				end
				break;
			end
		end
	end
	local function v121()
		local v148 = 0;
		local v149;
		while true do
			if ((1 == v148) or (2164 >= 3404)) then
				if ((1080 <= 2918) and not v14:IsCasting()) then
					return v149;
				elseif (v14:IsCasting(v98.Stormkeeper) or (3426 <= 1781)) then
					return true;
				else
					return v149;
				end
				break;
			end
			if ((v148 == 0) or (4376 <= 4070)) then
				if (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\141\230\206\208\55\197\183\123\174\247\211", "\30\222\146\161\162\90\174\210")]:IsAvailable() or (805 > 4162)) then
					return false;
				end
				v149 = v14:BuffUp(v98.StormkeeperBuff);
				v148 = 1;
			end
		end
	end
	local function v122()
		local v150 = 0;
		local v151;
		while true do
			if ((4904 == 4904) and (v150 == 1)) then
				if (not v14:IsCasting() or (2525 > 4643)) then
					return v151;
				elseif (v14:IsCasting(v98.Icefury) or (3983 < 1150)) then
					return true;
				else
					return v151;
				end
				break;
			end
			if ((4066 < 4247) and (v150 == 0)) then
				if (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\204\77\117\12\240\92\105", "\106\133\46\16")]:IsAvailable() or (1446 < 545)) then
					return false;
				end
				v151 = v14:BuffUp(v98.IcefuryBuff);
				v150 = 1;
			end
		end
	end
	local function v123()
		if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\123\44\118\253\84\83\93\19\99\245\72\73\76", "\32\56\64\19\156\58")]:IsReady() and v34 and v102.DispellableFriendlyUnit(25)) or (616 == 199)) then
			if (v24(v100.CleanseSpiritFocus) or (4384 <= 2280)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\89\196\224\87\84\225\133\101\219\245\95\72\251\148\26\204\236\69\74\247\140", "\224\58\168\133\54\58\146");
			end
		end
	end
	local function v124()
		if ((4564 > 598) and v96 and (v14:HealthPercentage() <= v97)) then
			if ((3747 == 3747) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\113\83\74\241\124\136\128\56\76\68\76\248", "\107\57\54\43\157\21\230\231")]:IsReady()) then
				if ((3889 < 4766) and v24(v98.HealingSurge)) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\211\142\16\249\176\210\200\228\152\4\231\190\217\143\211\142\16\249\249\211\192\216", "\175\187\235\113\149\217\188");
				end
			end
		end
	end
	local function v125()
		local v152 = 0;
		while true do
			if ((2628 > 2464) and (2 == v152)) then
				if ((v90 and (v14:HealthPercentage() <= v92)) or (3197 <= 2999)) then
					local v222 = 0;
					while true do
						if ((v222 == 0) or (952 <= 71)) then
							if ((2347 >= 423) and (v94 == LUAOBFUSACTOR_DECRYPT_STR_0("\16\93\49\202\219\7\238\43\86\48\152\246\17\231\46\81\57\223\158\36\233\54\81\56\214", "\134\66\56\87\184\190\116"))) then
								if ((4997 >= 4775) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\14\52\15\169\28\248\41\60\50\54\33\190\24\231\40\59\59\1\6\175\16\228\47", "\85\92\81\105\219\121\139\65")]:IsReady()) then
									if ((3333 < 3636) and v24(v100.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\239\182\86\87\121\204\245\186\94\66\60\215\248\178\92\76\114\216\189\163\95\81\117\208\243\243\84\64\122\218\243\160\89\83\121\159\169", "\191\157\211\48\37\28");
									end
								end
							end
							if ((3706 >= 2393) and (v94 == "Dreamwalker's Healing Potion")) then
								if ((1756 < 3743) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\251\13\241\29\55\200\30\248\23\63\205\12\220\25\59\211\22\250\27\10\208\11\253\19\52", "\90\191\127\148\124")]:IsReady()) then
									if ((2598 <= 3220) and v24(v100.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\124\149\43\22\117\144\47\27\115\130\60\4\56\143\43\22\116\142\32\16\56\151\33\3\113\136\32\87\124\130\40\18\118\148\39\1\125", "\119\24\231\78");
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((0 == v152) or (4962 <= 3676)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\29\188\149\94\226\117\75\52\166\135\88", "\24\92\207\225\44\131\25")]:IsReady() and v70 and (v14:HealthPercentage() <= v76)) or (3467 < 3261)) then
					if ((1461 <= 2309) and v24(v98.AstralShift)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\74\192\172\94\26\113\116\192\176\69\29\105\11\215\189\74\30\115\88\218\174\73\91\44", "\29\43\179\216\44\123");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\156\215\35\73\174\205\50\77\177\254\53\69\185\216\46\79\184", "\44\221\185\64")]:IsReady() and v69 and v102.AreUnitsBelowHealthPercentage(v74, v75)) or (4669 < 511)) then
					if (v24(v98.AncestralGuidance) or (4222 <= 1868)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\233\75\90\96\21\245\73\83\76\6\242\65\91\114\15\228\77\31\119\4\225\77\81\96\8\241\77\31\33", "\19\97\135\40\63");
					end
				end
				v152 = 1;
			end
			if ((3090 >= 102) and (v152 == 1)) then
				if ((4153 > 1521) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\134\89\50\55\38\63\169\111\39\41\42\48\163\104\60\47\42\60", "\81\206\60\83\91\79")]:IsReady() and v71 and v102.AreUnitsBelowHealthPercentage(v77, v78)) then
					if (v24(v98.HealingStreamTotem) or (249 < 91)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\174\209\126\38\205\74\155\93\191\194\119\46\206\114\176\65\191\213\127\111\199\72\162\75\165\195\123\57\198\13\247", "\196\46\203\176\18\79\163\45");
					end
				end
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\144\39\127\18\48\243\252\172\45\112\27", "\143\216\66\30\126\68\155")]:IsReady() and v91 and (v14:HealthPercentage() <= v93)) or (4612 == 1807)) then
					if ((633 <= 4454) and v24(v100.Healthstone)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\162\205\12\199\209\171\196\245\165\198\8\139\193\166\209\228\164\219\4\221\192\227\132", "\129\202\168\109\171\165\195\183");
					end
				end
				v152 = 2;
			end
		end
	end
	local function v126()
		local v153 = 0;
		while true do
			if ((v153 == 0) or (2328 < 377)) then
				v29 = v102.HandleTopTrinket(v101, v32, 40, nil);
				if ((3247 == 3247) and v29) then
					return v29;
				end
				v153 = 1;
			end
			if ((1372 < 3989) and (1 == v153)) then
				v29 = v102.HandleBottomTrinket(v101, v32, 40, nil);
				if ((3776 >= 1834) and v29) then
					return v29;
				end
				break;
			end
		end
	end
	local function v127()
		local v154 = 0;
		while true do
			if ((v154 == 0) or (1284 >= 3991)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\177\57\170\88\209\75\20\135\61\160\88", "\113\226\77\197\42\188\32")]:IsCastable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\2\251\167\55\29\241\176\42\19\230", "\213\90\118\148")]:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105)) or (4187 <= 3305)) then
					if ((1091 == 1091) and v24(v98.Stormkeeper)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\72\58\187\68\64\80\43\177\70\72\73\110\164\68\72\88\33\185\84\76\79\110\230", "\45\59\78\212\54");
					end
				end
				if ((3782 < 3851) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\57\85\134\141\147\60\180", "\144\112\54\227\235\230\78\205")]:IsCastable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\154\43\10\250\197\73\170", "\59\211\72\111\156\176")]:CooldownRemains() == 0) and v41) then
					if ((677 <= 1197) and v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\71\132\230\43\91\149\250\109\94\149\230\46\65\138\225\44\90\199\183", "\77\46\231\131");
					end
				end
				v154 = 1;
			end
			if ((3950 == 3950) and (2 == v154)) then
				if ((4848 >= 141) and v14:IsCasting(v98.ElementalBlast) and UseFlameShock and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\96\168\200\182\95\168\197\178\81\182\246\186\70\191", "\219\48\218\161")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\194\125\125\68\222\124\232\235\114\119", "\128\132\17\28\41\187\47")]:IsReady()) then
					if ((3538 < 3871) and v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\62\7\55\88\18\58\9\57\86\65\34\20\63\94\14\63\4\59\73\65\99\86", "\61\97\82\102\90");
					end
				end
				if ((3810 > 3164) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\128\47\189\74\229\66\12\26\184", "\105\204\78\203\43\167\55\126")]:IsCastable() and v43 and not v14:IsCasting(v98.LavaBurst) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\128\166\38\19\22\10\211\80\169\136\47\31\0\16", "\49\197\202\67\126\115\100\167")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\18\87\218\36\133\88\74\54\87\253\37\129\69\74", "\62\87\59\191\73\224\54")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\194\14\255\196\226\12\238\200\235\32\246\200\244\22", "\169\135\98\154")]:IsAvailable()))) then
					if ((2557 <= 2601) and v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\199\118\50\85\255\38\218\216\99\100\68\239\54\203\196\122\38\85\233\115\153\153", "\168\171\23\68\52\157\83");
					end
				end
				v154 = 3;
			end
			if ((2318 > 1082) and (v154 == 3)) then
				if ((v14:IsCasting(v98.LavaBurst) and UseFlameShock and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\210\125\244\160\32\30\143\251\114\254", "\231\148\17\149\205\69\77")]:IsReady()) or (3285 >= 3449)) then
					if (v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock)) or (525 > 1349)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\134\171\198\246\82\236\136\168\196\240\23\239\146\162\196\244\90\253\129\179\135\170\3", "\159\224\199\167\155\55");
					end
				end
				if ((v14:IsCasting(v98.LavaBurst) and v46 and ((v63 and v33) or not v63) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\199\225\53\223\248\225\56\219\246\255\11\211\225\246", "\178\151\147\92")]:IsAvailable()) or (3810 >= 4154)) then
					if ((2423 == 2423) and v24(v98.PrimordialWave, not v17:IsSpellInRange(v98.PrimordialWave))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\156\239\69\63\29\94\126\133\252\64\13\5\77\108\137\189\92\32\23\79\117\129\255\77\38\82\29\44", "\26\236\157\44\82\114\44");
					end
				end
				break;
			end
			if ((4712 >= 3813) and (v154 == 1)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\159\88\179\77\191\90\162\65\182\118\186\65\169\64", "\32\218\52\214")]:IsCastable() and v38) or (153 == 2063)) then
					if (v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast)) or (2584 == 3247)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\27\52\165\244\190\81\91\66\40\51\164\240\163\81\26\94\5\52\171\254\189\71\91\90\87\103", "\58\46\119\81\200\145\208\37");
					end
				end
				if ((v14:IsCasting(v98.ElementalBlast) and v46 and ((v63 and v33) or not v63) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\158\57\161\166\175\50\34\141\60\155\168\171\51", "\86\75\236\80\204\201\221")]:IsAvailable()) or (1755 <= 693)) then
					if ((3413 == 3413) and v24(v98.PrimordialWave, not v17:IsSpellInRange(v98.PrimordialWave))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\98\83\126\136\241\153\118\72\118\137\193\156\115\87\114\197\238\153\119\66\120\136\252\138\102\1\47", "\235\18\33\23\229\158");
					end
				end
				v154 = 2;
			end
		end
	end
	local function v128()
		local v155 = 0;
		while true do
			if ((v155 == 3) or (4591 <= 3060)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\253\74\5\126\174\165\204\71\12\81\167\170\203\82", "\203\184\38\96\19\203")]:IsAvailable() and v38 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\28\112\113\78\203\42\124\127\102\220\60\114\109\114\219\55\119\124\83\199\55\116", "\174\89\19\25\33")]:IsAvailable())) or (3292 < 1467)) then
					if (v102.CastTargetIf(v98.ElementalBlast, v109, LUAOBFUSACTOR_DECRYPT_STR_0("\34\27\92", "\107\79\114\50\46\151\231"), v118, nil, not v17:IsSpellInRange(v98.ElementalBlast)) or (1370 == 608)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\170\176\36\143\55\163\193\53\153\183\37\139\42\163\128\56\169\176\105\222\107", "\160\89\198\213\73\234\89\215");
					end
				end
				if ((3133 >= 1678) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\109\125\177\243\192\70\101\181\242\231\68\112\167\234", "\165\40\17\212\158")]:IsAvailable() and v38 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\218\0\60\35\246\214\14\20\52\224\216\28\0\51\235\221\13\33\47\235\222", "\70\133\185\104\83")]:IsAvailable())) then
					if ((4721 > 1294) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\73\65\39\204\10\81\69\38\246\6\73\69\57\221\68\68\75\47\137\80\17", "\169\100\37\36\74");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\37\139\167\93\5\137\182\81\12\165\174\81\19\147", "\48\96\231\194")]:IsAvailable() and v38 and (v110 == 3) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\237\89\6\34\28\203\160\133\239\72\11\44\13\235\186\141\204\95\28\36\23\223", "\227\168\58\110\77\121\184\207")]:IsAvailable()) or (2719 == 338)) then
					if ((2263 <= 4336) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\126\48\186\77\180\213\101\164\119\3\189\76\176\200\101\229\122\51\186\0\229\141", "\197\27\92\223\32\209\187\17");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\38\94\209\239\11\108\203\244\0\84", "\155\99\63\163")]:IsReady() and v37 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\167\210\169\130\188\151\141\215\134\159\188\133\150\226\180\131\189\129\144\216\175\138", "\228\226\177\193\237\217")]:IsAvailable())) or (1156 <= 385)) then
					if (v102.CastTargetIf(v98.EarthShock, v109, LUAOBFUSACTOR_DECRYPT_STR_0("\57\185\45", "\134\84\208\67"), v118, nil, not v17:IsSpellInRange(v98.EarthShock)) or (1767 > 4108)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\173\148\72\27\147\149\84\28\175\141\28\18\163\131\28\71\244", "\60\115\204\230");
					end
				end
				if ((3132 < 3745) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\194\59\249\100\239\9\227\127\228\49", "\16\135\90\139")]:IsReady() and v37 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\113\119\14\60\75\71\119\82\83\20\54\79\64\75\65\122\2\54\92\93\118\83", "\24\52\20\102\83\46\52")]:IsAvailable())) then
					if (v24(v98.EarthShock, not v17:IsSpellInRange(v98.EarthShock)) or (4858 == 4942)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\193\46\51\48\7\251\60\41\43\12\207\111\32\43\10\132\122\113", "\111\164\79\65\68");
					end
				end
				if ((1649 <= 2572) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\239\218\134\216\59\248\223", "\138\166\185\227\190\78")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\226\119\192\49\71\49\0", "\121\171\20\165\87\50\67")]:CooldownRemains() == 0) and v41 and v14:BuffDown(v98.AscendanceBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\227\52\188\53\173\16\207\62\176\51\189\49\206\55\186\61\170", "\98\166\88\217\86\217")]:IsAvailable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\218\255\126\9\146\210\255\248\126\51\137\216", "\188\150\150\25\97\230")]:IsAvailable() and (v110 < 5) and not v120()) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\254\140\90\18\0\244\232\134\80\22\9\233\255\133\90\15\9\227\206\154", "\141\186\233\63\98\108")]:IsAvailable() and (v110 == 3)))) then
					if (v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury)) or (4424 <= 3216)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\233\41\176\48\227\243\108\183\42\244\170\121\228", "\69\145\138\76\214");
					end
				end
				v155 = 4;
			end
			if ((v155 == 6) or (1564 > 3638)) then
				if ((2442 < 4070) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\195\182\33\229\85\45\243", "\95\138\213\68\131\32")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\3\43\164\69\99\56\49", "\22\74\72\193\35")]:CooldownRemains() == 0) and v41 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\117\225\91\56\107\237\94\37\124\224\107\36\118\231\83\63", "\56\76\25\132")]:IsAvailable() and (v111 < 5)) then
					if (v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury)) or (3968 <= 1084)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\194\174\32\218\76\216\235\39\192\91\129\252\126", "\175\62\161\203\70");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\26\207\204\0\33\15\213\204\16\62", "\85\92\189\163\115")]:IsCastable() and v40 and v122() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\12\160\53\59\61\190\57\62\32\169\52\11\33\163\51\51\58", "\88\73\204\80")]:IsAvailable() and v17:DebuffDown(v98.ElectrifiedShocksDebuff) and (v110 < 5) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\141\2\67\37\223\32\151\25\72\46\249\47\143\17\75\32\206\55", "\186\78\227\112\38\73")]:IsAvailable()) or (4137 < 1807)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (443 >= 1460)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\69\242\70\71\69\239\95\242\86\88\58\253\88\248\21\11\42", "\26\156\55\157\53\51");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\160\217\0\216\154\85\141\213", "\48\236\184\118\185\216")]:IsAvailable() and v42 and (v14:BuffRemains(v98.AscendanceBuff) > v98[LUAOBFUSACTOR_DECRYPT_STR_0("\201\188\65\49\237\49\228\176", "\84\133\221\55\80\175")]:CastTime())) or (2707 < 255)) then
					if ((3982 <= 4852) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\230\50\167\248\94\184\230\41\230\198\83\184\167\124\244", "\60\221\135\68\198\167");
					end
				end
				if ((4673 == 4673) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\205\181\249\138\76\245\231\186\240\151\76\208\224\186", "\185\142\221\152\227\34")]:IsAvailable() and v35) then
					if ((2927 < 3035) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\205\86\243\77\12\251\81\194\95\238\77\58\249\95\133\86\245\70\115\175\12", "\151\56\165\55\154\35\83");
					end
				end
				if ((4435 >= 1961) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\134\79\4\227\165\112\13\225\163\72", "\142\192\35\101")]:IsCastable() and UseFlameShock) then
					if (v102.CastCycle(v98.FlameShock, v109, v113, not v17:IsSpellInRange(v98.FlameShock)) or (3500 <= 631)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\121\40\174\226\179\191\30\217\118\34\227\234\131\186\31\216\114\105\162\232\137\236\78\128", "\118\182\21\73\195\135\236\204");
					end
				end
				if ((1842 < 3956) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\46\46\21\83\16\62\245\7\63\17", "\157\104\92\122\32\100\109")]:IsCastable() and v40) then
					if ((2123 >= 1498) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\180\192\217\41\24\158\163\172\165\196\138\48\40\155\162\173\161\143\203\50\34\205\243\251", "\203\195\198\175\170\93\71\237");
					end
				end
				break;
			end
			if ((v155 == 5) or (1979 == 1924)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\133\9\200\128\29\172\9\211", "\95\201\104\190\225")]:IsAvailable() and v42 and (v110 >= 6) and v14:BuffUp(v98.SurgeofPowerBuff) and (v14:BuffRemains(v98.AscendanceBuff) > v98[LUAOBFUSACTOR_DECRYPT_STR_0("\131\202\215\207\141\206\192\195", "\174\207\171\161")]:CastTime())) or (840 > 4348)) then
					if ((4583 > 4499) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\255\27\242\199\213\232\255\0\179\249\216\232\190\91\165", "\183\141\158\109\147\152");
					end
				end
				if ((4221 > 4162) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\15\1\231\5\34\37\239\11\36\29\232\5\34\14", "\108\76\105\134")]:IsAvailable() and v35 and (v110 >= 6) and v14:BuffUp(v98.SurgeofPowerBuff)) then
					if ((2842 < 4835) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\232\205\176\232\192\212\201\184\230\198\255\203\184\239\201\171\196\190\228\142\189\157", "\174\139\165\209\129");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\143\178\244\192\228\22\98\107\183", "\24\195\211\130\161\166\99\16")]:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\98\6\236\60\95\15\116\12\230\56\86\18\99\15\236\33\86\24\82\16", "\118\38\99\137\76\51")]:IsAvailable() and v14:BuffUp(v98.WindspeakersLavaResurgenceBuff)) or (1429 >= 3843)) then
					if (v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst)) or (2629 > 3045)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\241\39\19\19\54\34\232\52\22\6\73\33\242\35\69\69\89", "\64\157\70\101\114\105");
					end
				end
				if ((3447 >= 2905) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\108\169\177\226\50\69\169\170", "\112\32\200\199\131")]:IsAvailable() and v42 and v120() and (v14:BuffRemains(v98.AscendanceBuff) > v98[LUAOBFUSACTOR_DECRYPT_STR_0("\0\81\74\185\225\174\35\33", "\66\76\48\60\216\163\203")]:CastTime())) then
					if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or (2817 < 513)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\135\111\242\96\204\33\187\139\57\242\80\203\100\237\212", "\68\218\230\25\147\63\174");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\129\43\69\77\148\184\56\64\88", "\214\205\74\51\44")]:IsAvailable() and v43 and (v110 == 3) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\215\77\241\232\114\232\67\228\232\127\255\105\238\249\122\255\66\246\239", "\23\154\44\130\156")]:IsAvailable()) or (732 >= 2550)) then
					if ((3089 > 164) and v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\29\167\187\175\9\17\4\180\190\186\118\18\30\163\237\249\98", "\115\113\198\205\206\86");
					end
				end
				if ((1455 <= 3954) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\168\86\232\91\166\66\236\73\144", "\58\228\55\158")]:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\144\140\213\62\48\180\7\187\134\196\43\56\136\57\177\132\213\32\40\190", "\85\212\233\176\78\92\205")]:IsAvailable()) then
					if ((150 == 150) and v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\89\158\227\117\90\157\240\89\76\200\227\69\93\200\181\28", "\130\42\56\232");
					end
				end
				v155 = 6;
			end
			if ((3193 <= 3790) and (v155 == 1)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\126\2\62\119\65\2\51\115\79\28\0\123\88\21", "\26\46\112\87")]:IsAvailable() and v46 and ((v63 and v33) or not v63) and v14:BuffDown(v98.PrimordialWaveBuff) and v14:BuffUp(v98.SurgeofPowerBuff) and v14:BuffDown(v98.SplinteredElementsBuff)) or (463 == 3491)) then
					if ((2549 >= 2060) and v102.CastTargetIf(v98.PrimordialWave, v109, LUAOBFUSACTOR_DECRYPT_STR_0("\180\42\165", "\212\217\67\203\20\223\223\37"), v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\130\165\223\181\131\187", "\178\218\237\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\146\188\245\192\186\180\255\227\162\172\234\213", "\176\214\213\134")].Signature)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\191\191\217\167\68\93\253\172\186\235\191\87\79\241\237\183\219\173\22\8\166", "\57\148\205\214\180\200\54");
					end
				end
				if ((3991 >= 3174) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\34\239\60\57\121\0\249\60\53\122\37\252\35\49", "\22\114\157\85\84")]:IsAvailable() and v46 and ((v63 and v33) or not v63) and v14:BuffDown(v98.PrimordialWaveBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\224\206\22\212\81\239\154\203\196\7\193\89\211\164\193\198\22\202\73\229", "\200\164\171\115\164\61\150")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\141\225\17\66\134\177\242\51\74\148\187\230", "\227\222\148\99\37")]:IsAvailable() and v14:BuffDown(v98.SplinteredElementsBuff)) then
					if (v102.CastTargetIf(v98.PrimordialWave, v109, LUAOBFUSACTOR_DECRYPT_STR_0("\62\91\92", "\153\83\50\50\150"), v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings[LUAOBFUSACTOR_DECRYPT_STR_0("\126\121\126\17\124\165\94", "\45\61\22\19\124\19\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\229\27\30\229\14\113\160\242\6\20\249\7", "\217\161\114\109\149\98\16")].Signature) or (3284 <= 1801)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\2\50\49\113\179\102\22\41\57\112\131\99\19\54\61\60\189\123\23\96\105\40", "\20\114\64\88\28\220");
					end
				end
				if ((4219 <= 4301) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\1\19\219\185\247\194\185\56\0\222\131\249\198\184", "\221\81\97\178\212\152\176")]:IsAvailable() and v46 and ((v63 and v33) or not v63) and v14:BuffDown(v98.PrimordialWaveBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\224\230\14\239\31\223\232\27\239\18\200\194\17\254\23\200\233\9\232", "\122\173\135\125\155")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\168\200\7\177\43\63\193\138\198\50\182\59", "\168\228\161\96\217\95\81")]:IsAvailable()) then
					if (v102.CastTargetIf(v98.PrimordialWave, v109, LUAOBFUSACTOR_DECRYPT_STR_0("\214\216\32", "\55\187\177\78\60\79"), v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings[LUAOBFUSACTOR_DECRYPT_STR_0("\14\193\82\230\73\193\147", "\224\77\174\63\139\38\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\160\72\75\62\136\64\65\29\144\88\84\43", "\78\228\33\56")].Signature) or (3760 < 241)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\108\187\14\138\220\122\187\2\137\241\105\179\21\128\142\127\189\6\197\159\40", "\229\174\30\210\99");
					end
				end
				if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\61\225\135\92\232\14\49\20\238\141", "\89\123\141\230\49\141\93")]:IsCastable() or (1590 <= 1014)) then
					local v223 = 0;
					while true do
						if ((v223 == 3) or (1029 >= 2232)) then
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\200\173\6\212\80\245\154\12\203\72\233\172\38\200\89\225\173\13\208\79", "\60\140\200\99\164")]:IsAvailable() and v39 and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\180\225\22\33\167\136\242\52\41\181\130\230", "\194\231\148\100\70")]:IsAvailable()) or (1843 >= 4176)) then
								if (v102.CastCycle(v98.FlameShock, v109, v115, not v17:IsSpellInRange(v98.FlameShock)) or (685 > 4725)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\64\64\192\174\243\247\85\68\206\160\253\136\71\67\196\227\165\152", "\168\38\44\161\195\150");
								end
							end
							break;
						end
						if ((3162 == 3162) and (2 == v223)) then
							if ((v14:BuffUp(v98.SurgeofPowerBuff) and v39 and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\160\53\67\234\71\12\133\50\67\208\92\6", "\98\236\92\36\130\51")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\151\18\21\184\87\173\180\59\161\11\31\156\76\173\167\41\128\28\1\179\86\173", "\80\196\121\108\218\37\200\213")]:IsAvailable())) or (4195 == 3247)) then
								if (v102.CastCycle(v98.FlameShock, v109, v115, not v17:IsSpellInRange(v98.FlameShock)) or (3761 < 2103)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\6\127\3\114\78\49\153\8\124\1\116\11\15\133\5\51\80\41", "\234\96\19\98\31\43\110");
								end
							end
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\43\30\65\211\169\96\132\0\11\90\194\137\126\142\11\26\92\211\191", "\235\102\127\50\167\204\18")]:IsAvailable() and v39 and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\124\168\242\43\80\32\89\175\242\17\75\42", "\78\48\193\149\67\36")]:IsAvailable()) or (4212 <= 98)) then
								if ((654 < 2945) and v102.CastCycle(v98.FlameShock, v109, v115, not v17:IsSpellInRange(v98.FlameShock))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\54\18\129\21\68\15\13\136\23\66\59\94\129\23\68\112\76\216", "\33\80\126\224\120");
								end
							end
							v223 = 3;
						end
						if ((v223 == 0) or (2370 == 4556)) then
							if ((2486 <= 3406) and v14:BuffUp(v98.SurgeofPowerBuff) and v39 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\223\120\241\4\4\68\250\127\241\62\31\78", "\42\147\17\150\108\112")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\56\175\35\123\244\248\10\167\38\122\245\251\35\167\59\126\213\237\28\179\63\120\226\230\12\163", "\136\111\198\77\31\135")]:IsAvailable() and (v17:DebuffRemains(v98.FlameShockDebuff) < (v17:TimeToDie() - 1))) then
								if (v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock)) or (514 >= 2311)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\4\5\166\91\184\219\4\161\13\10\172\22\188\235\18\233\83\81", "\201\98\105\199\54\221\132\119");
								end
							end
							if ((2594 > 1455) and v14:BuffUp(v98.SurgeofPowerBuff) and v39 and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\149\5\132\41\22\59\165\183\11\177\46\6", "\204\217\108\227\65\98\85")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\109\200\236\231\62\197\95\200\240\247\63\230\87\198\231\252\8\197\83\202\230\224", "\160\62\163\149\133\76")]:IsAvailable()) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\240\172\12\34\198\229\168\2\44\200\242\165\15\58\197\208", "\163\182\192\109\79")]:AuraActiveCount() < 6)) then
								if ((4545 > 4248) and v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\50\42\1\205\240\11\53\8\207\246\63\102\1\207\240\116\116\80", "\149\84\70\96\160");
								end
							end
							v223 = 1;
						end
						if ((1691 == 1691) and (v223 == 1)) then
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\21\7\30\249\61\20\2\235\44\14\8\200\52\3\0\232\54\18\30", "\141\88\102\109")]:IsAvailable() and v39 and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\159\90\205\120\14\51\92\207\180\97\197\116", "\161\211\51\170\16\122\93\53")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\221\162\179\37\254\157\186\39\248\165\150\45\249\187\180\46", "\72\155\206\210")]:AuraActiveCount() < 6)) or (763 > 4143)) then
								if ((1223 == 1223) and v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\64\118\85\3\54\121\105\92\1\48\77\58\85\1\54\6\40\6", "\83\38\26\52\110");
								end
							end
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\124\18\34\86\84\14\21\73\87\3\34\66\125\27\34\75\93\25\51\85", "\38\56\119\71")]:IsAvailable() and v39 and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\250\74\209\32\89\245\223\87\193\32\68", "\54\147\143\56\182\69")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\240\141\254\68\218\229\137\240\74\212\242\132\253\92\217\208", "\191\182\225\159\41")]:AuraActiveCount() < 6)) or (2957 < 2517)) then
								if ((687 < 4117) and v102.CastCycle(v98.FlameShock, v109, v114, not v17:IsSpellInRange(v98.FlameShock))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\45\30\41\88\142\184\209\35\29\43\94\203\134\205\46\82\122\1", "\162\75\114\72\53\235\231");
								end
							end
							v223 = 2;
						end
					end
				end
				if ((292 == 292) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\161\239\129\115\62\236\183\24\131\249", "\118\224\156\226\22\80\136\214")]:IsCastable() and v51 and ((v57 and v32) or not v57) and (v89 < v105)) then
					if ((1826 == 1826) and v24(v98.Ascendance)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\253\90\133\76\234\88\142\65\235\25\129\77\235\25\211\16", "\224\34\142\57");
					end
				end
				if ((4270 > 1575) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\242\166\211\220\81\228\79\29\202", "\110\190\199\165\189\19\145\61")]:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\247\234\100\252\142\213\213\237\99\224\142\226\214\238\122\237\133\211\201", "\167\186\139\23\136\235")]:IsAvailable() and not v120() and (v119() >= ((60 - (5 * v98[LUAOBFUSACTOR_DECRYPT_STR_0("\63\172\141\2\28\161\128\8\41\161\135\31\23", "\109\122\213\232")]:TalentRank())) - (2 * v25(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\200\251\173\39\225\241\146\63\249\242\176", "\80\142\151\194")]:IsAvailable())))) and ((not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\38\197\127\67\6\213\120\74\36\212\114\77\23\245\98\66\7\195\101\69\13\193", "\44\99\166\23")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\80\254\46\62\39\170\117\249\46\4\60\160", "\196\28\151\73\86\83")]:IsAvailable()) or v14:BuffUp(v98.EchoesofGreatSunderingBuff)) and ((v14:BuffDown(v98.AscendanceBuff) and (v110 > 3) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\198\13\59\21\142\93\22\98\250\13\46\51\131\84\25\123\250\23\48", "\22\147\99\73\112\226\56\120")]:IsAvailable()) or (v111 == 3))) then
					if ((2014 >= 125) and v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\180\116\244\244\178\186\96\240\230\153\248\116\237\240\205\235\33", "\237\216\21\130\149");
					end
				end
				v155 = 2;
			end
			if ((4173 >= 1869) and (4 == v155)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\86\221\134\154\171\37\120\192\138\130", "\118\16\175\233\233\223")]:IsCastable() and v40 and v14:BuffDown(v98.AscendanceBuff) and v122() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\174\136\48\184\250\153\116\141\141\48\191\221\131\114\136\143\38", "\29\235\228\85\219\142\235")]:IsAvailable() and (v17:DebuffDown(v98.ElectrifiedShocksDebuff) or (v14:BuffRemains(v98.IcefuryBuff) < v14:GCD())) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\17\221\189\213\99\64\46\92\58\230\181\217", "\50\93\180\218\189\23\46\71")]:IsAvailable() and (v110 < 5) and not v120()) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\250\161\94\92\72\197\122\209\171\79\73\64\249\68\219\169\94\66\80\207", "\40\190\196\59\44\36\188")]:IsAvailable() and (v110 == 3)))) or (381 >= 3836)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (3312 <= 3209)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\87\211\167\238\66\30\52\74\223\191\186\112\2\42\76\210\179\186\124\2\57\5\137\224", "\109\92\37\188\212\154\29");
					end
				end
				if ((1170 >= 32) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\40\238\178\194\19\79\22\252\176", "\58\100\143\196\163\81")]:IsAvailable() and v43 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\55\67\48\183\58\91\234\8\14\74\38\134\51\76\232\11\20\86\48", "\110\122\34\67\195\95\41\133")]:IsAvailable() and not v120() and (v121() or (v14:HasTier(30, 2) and (v112() < 3))) and (v119() < (((60 - (5 * v98[LUAOBFUSACTOR_DECRYPT_STR_0("\80\168\94\69\208\97\185\94\121\194\122\163\86", "\182\21\209\59\42")]:TalentRank())) - (2 * v25(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\145\91\202\10\46\184\135\88\210\24\51", "\222\215\55\165\125\65")]:IsAvailable()))) - 10)) and (v110 < 5)) then
					if (v102.CastCycle(v98.LavaBurst, v109, v116, not v17:IsSpellInRange(v98.LavaBurst)) or (3368 <= 752)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\32\208\208\27\205\195\248\88\63\197\134\27\253\196\173\31\122", "\42\76\177\166\122\146\161\141");
					end
				end
				if ((3866 == 3866) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\137\139\19\207\91\115\164\135", "\22\197\234\101\174\25")]:IsAvailable() and v42 and (v121())) then
					if (v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam)) or (1446 == 3817)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\53\179\221\73\173\210\135\32\116\164\211\115\239\130\222", "\230\77\84\197\188\22\207\183");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\218\28\199\245\130\141\249\50\241\0\200\245\130\166", "\85\153\116\166\156\236\193\144")]:IsAvailable() and v35 and (v121())) or (2373 >= 4428)) then
					if ((508 < 4636) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\167\232\76\186\234\63\168\233\74\187\240\14\173\238\74\243\229\15\161\160\27\227", "\96\196\128\45\211\132");
					end
				end
				if ((1324 == 1324) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\25\140\109\94\240\170\181\213", "\184\85\237\27\63\178\207\212")]:IsAvailable() and v42 and v14:BuffUp(v98.Power) and (v14:BuffRemains(v98.AscendanceBuff) > v98[LUAOBFUSACTOR_DECRYPT_STR_0("\36\88\31\94\42\92\8\82", "\63\104\57\105")]:CastTime())) then
					if ((417 < 4185) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\134\178\69\52\133\161\69\6\199\165\75\14\199\242\22", "\36\107\231\196");
					end
				end
				if ((451 <= 2352) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\126\189\163\142\83\153\171\128\85\161\172\142\83\178", "\231\61\213\194")]:IsAvailable() and v35 and (v120())) then
					if ((1357 < 2767) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\165\60\122\7\146\49\122\14\165\41\125\0\163\58\51\8\162\56\51\95\249", "\19\105\205\93");
					end
				end
				v155 = 5;
			end
			if ((1460 < 3378) and (v155 == 0)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\12\39\199\94\15\34\208\86\47\32\193\90\38", "\59\74\78\181")]:IsReady() and v52 and ((v58 and v32) or not v58) and (v89 < v105)) or (3452 > 3516)) then
					if (v24(v98.FireElemental) or (3881 < 1890)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\216\72\95\140\32\221\95\87\182\43\197\91\86\243\36\222\95\26\225", "\211\69\177\58\58");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\132\241\118\231\228\238\187\224\116\240\231\223\182\233", "\171\215\133\25\149\137")]:IsReady() and v54 and ((v59 and v32) or not v59) and (v89 < v105)) or (2272 >= 3660)) then
					if (v24(v98.StormElemental) or (3054 <= 1922)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\242\220\61\232\226\15\249\78\228\197\55\244\251\49\240\2\224\199\55\186\187", "\34\129\168\82\154\143\80\156");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\182\166\60\25\69\69\140\128\162\54\25", "\233\229\210\83\107\40\46")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\242\86\61\196\8\202\71\55\198\0\211", "\101\161\34\82\182")]:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and not v121()) or (4189 < 2526)) then
					if (v24(v98.Stormkeeper) or (1251 > 1489)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\25\86\236\214\233\135\43\248\8\75\190\218\237\135\110\191", "\78\136\109\57\158\187\130\226");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\10\48\237\244\51\54\250\195\59\60\248\253\50", "\145\94\95\153")]:IsCastable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\209\196\5\192\71\179\208\204\19\216\79\131\242\217\17\216", "\215\157\173\116\181\46")]:CooldownRemains() > 45) and v48) or (670 == 1771)) then
					if ((1459 >= 329) and v24(v98.TotemicRecall)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\187\159\247\215\60\183\180\224\223\54\181\135\254\154\52\187\142\178\130", "\186\85\212\235\146");
					end
				end
				if ((2910 > 1112) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\238\136\7\235\48\234\117\195\134\27\255\13\225\76\199\140", "\56\162\225\118\158\89\142")]:IsReady() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == LUAOBFUSACTOR_DECRYPT_STR_0("\95\16\210\188\45\202", "\184\60\101\160\207\66"))) then
					if ((579 < 4604) and v24(v100.LiquidMagmaTotemCursor, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\139\109\169\56\134\67\177\48\133\113\189\14\150\115\168\52\143\60\189\62\135\60\237\97", "\220\81\226\28");
					end
				end
				if ((2046 <= 4218) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\63\220\147\238\227\195\62\212\133\246\235\243\28\193\135\246", "\167\115\181\226\155\138")]:IsReady() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == LUAOBFUSACTOR_DECRYPT_STR_0("\242\46\230\69\126\99", "\166\130\66\135\60\27\17"))) then
					if ((2488 > 810) and v24(v100.LiquidMagmaTotemPlayer, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\72\67\223\96\57\64\117\195\116\55\73\75\241\97\63\80\79\195\53\49\75\79\142\36\97", "\80\36\42\174\21");
					end
				end
				v155 = 1;
			end
			if ((4794 >= 3564) and (2 == v155)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\167\79\77\75\184\216\75\131\69\90", "\62\226\46\63\63\208\169")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\230\12\71\144\16\31", "\62\133\121\53\227\127\109\79")) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\53\23\58\250\211\189\173\22\51\32\240\215\186\145\5\26\54\240\196\167\172\23", "\194\112\116\82\149\182\206")]:IsAvailable() and (v110 > 3) and (v111 > 3)) or (261 <= 137)) then
					if (v24(v100.EarthquakeCursor, not v17:IsInRange(40)) or (653 >= 1699)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\169\94\12\200\243\27\56\163\73\88\193\237\11\121\251\26", "\110\89\200\44\120\160\130");
					end
				end
				if ((2518 <= 3050) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\142\194\89\82\75\91\46\76\160\198", "\45\203\163\43\38\35\42\91")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\194\137\221\58\130\187", "\52\178\229\188\67\231\201")) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\4\66\88\11\242\79\44\39\102\66\1\246\72\16\52\79\84\1\229\85\45\38", "\67\65\33\48\100\151\60")]:IsAvailable() and (v110 > 3) and (v111 > 3)) then
					if ((4807 > 177) and v24(v100.EarthquakePlayer, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\218\230\188\204\251\206\242\175\211\246\159\230\161\221\179\140\177", "\147\191\135\206\184");
					end
				end
				if ((3663 >= 863) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\161\41\180\213\208\66\167\133\35\163", "\210\228\72\198\161\184\51")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\53\92\225\3\124\220", "\174\86\41\147\112\19")) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\126\3\133\4\32\28\30\173\124\18\136\10\49\60\4\165\95\5\159\2\43\8", "\203\59\96\237\107\69\111\113")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\1\26\169\236\52\254\195\37\26\142\237\48\227\195", "\183\68\118\204\129\81\144")]:IsAvailable() and (v110 == 3) and (v111 == 3)) then
					if ((4018 <= 4690) and v24(v100.EarthquakeCursor, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\11\172\98\240\3\147\27\172\123\225\75\131\1\168\48\183\83", "\226\110\205\16\132\107");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\206\194\242\205\73\250\214\225\210\68", "\33\139\163\128\185")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\71\84\5\199\82\74", "\190\55\56\100")) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\115\172\52\17\22\240\252\80\136\46\27\18\247\192\67\161\56\27\1\234\253\81", "\147\54\207\92\126\115\131")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\40\61\48\112\8\112\25\48\57\95\1\127\30\37", "\30\109\81\85\29\109")]:IsAvailable() and (v110 == 3) and (v111 == 3)) or (392 > 2140)) then
					if (v24(v100.EarthquakePlayer, not v17:IsInRange(40)) or (4531 <= 3105)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\112\70\162\62\207\233\254\122\81\246\55\209\249\191\34\12", "\156\159\17\52\214\86\190");
					end
				end
				if ((3863 == 3863) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\139\238\175\168\166\254\168\189\165\234", "\220\206\143\221")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\133\104\63\4\215\222", "\178\230\29\77\119\184\172")) and (v14:BuffUp(v98.EchoesofGreatSunderingBuff))) then
					if ((3203 > 2189) and v24(v100.EarthquakeCursor, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\191\24\15\127\233\224\191\1\30\55\249\250\187\74\79\39", "\152\149\222\106\123\23");
					end
				end
				if ((989 < 4245) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\248\39\228\87\189\204\51\247\72\176", "\213\189\70\150\35")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\95\89\117\17\74\71", "\104\47\53\20")) and (v14:BuffUp(v98.EchoesofGreatSunderingBuff))) then
					if ((15 <= 390) and v24(v100.EarthquakePlayer, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\77\147\8\180\30\182\77\138\25\252\14\172\73\193\72\236", "\111\195\44\225\124\220");
					end
				end
				v155 = 3;
			end
		end
	end
	local function v129()
		local v156 = 0;
		while true do
			if ((2545 >= 1717) and (v156 == 4)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\138\241\18\38\154\246\7\37\142", "\102\78\235\131")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\249\59\38\87\72\43", "\84\154\78\84\36\39\89\215")) and v14:BuffUp(v98.EchoesofGreatSunderingBuff) and ((not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\216\237\83\85\0\243\245\87\84\39\241\224\69\76", "\101\157\129\54\56")]:IsAvailable() and (v110 < 2)) or (v110 > 1))) or (4635 == 118)) then
					if ((1226 < 3232) and v24(v100.EarthquakeCursor, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\24\168\152\191\43\104\8\168\129\174\99\106\20\167\141\167\38\70\9\168\152\172\38\109\93\255\222", "\25\125\201\234\203\67");
					end
				end
				if ((3767 > 706) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\92\245\10\23\28\54\6\120\255\29", "\115\25\148\120\99\116\71")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\28\49\184\61\68\30", "\33\108\93\217\68")) and v14:BuffUp(v98.EchoesofGreatSunderingBuff) and ((not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\254\71\164\160\222\69\181\172\215\105\173\172\200\95", "\205\187\43\193")]:IsAvailable() and (v110 < 2)) or (v110 > 1))) then
					if ((3292 >= 1475) and v24(v100.EarthquakePlayer, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\115\23\203\246\99\16\222\245\119\69\204\247\124\2\211\251\77\17\222\236\117\0\203\190\36\81", "\191\158\18\101");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\224\194\149\163\167\212\214\134\188\170", "\207\165\163\231\215")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\197\236\235\69\43\98", "\16\166\153\153\54\68")) and (v110 > 1) and (v111 > 1) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\247\176\200\73\49\50\246\212\148\210\67\53\53\202\199\189\196\67\38\40\247\213", "\153\178\211\160\38\84\65")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\167\7\95\38\135\5\78\42\142\41\86\42\145\31", "\75\226\107\58")]:IsAvailable()) or (4773 < 1343)) then
					if (v24(v100.EarthquakeCursor, not v17:IsInRange(40)) or (1751 < 1528)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\93\223\3\110\25\211\216\89\213\20\58\2\203\195\95\210\20\69\5\195\223\95\219\5\58\71\148", "\173\56\190\113\26\113\162");
					end
				end
				if ((941 < 4267) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\238\223\63\17\255\218\203\44\14\242", "\151\171\190\77\101")]:IsReady() and v36 and (v50 == LUAOBFUSACTOR_DECRYPT_STR_0("\213\35\249\176\253\111", "\107\165\79\152\201\152\29")) and (v110 > 1) and (v111 > 1) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\114\77\224\196\81\108\88\72\207\217\81\126\67\125\253\197\80\122\69\71\230\204", "\31\55\46\136\171\52")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\244\36\217\249\212\38\200\245\221\10\208\245\194\60", "\148\177\72\188")]:IsAvailable()) then
					if ((1526 >= 1264) and v24(v100.EarthquakePlayer, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\163\183\69\199\174\167\66\210\173\179\23\192\175\184\80\223\163\137\67\210\180\177\82\199\230\224\1", "\179\198\214\55");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\213\0\119\123\64\221\228\13\126\84\73\210\227\24", "\179\144\108\18\22\37")]:IsAvailable() and v38 and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\235\162\8\157\202\212\172\29\157\199\195\134\23\140\194\195\173\15\154", "\175\166\195\123\233")]:IsAvailable() or (v120() and v17:DebuffUp(v98.ElectrifiedShocksDebuff)))) or (3492 <= 964)) then
					if (v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast)) or (2726 == 4578)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\206\88\68\245\225\214\92\69\207\237\206\92\90\228\175\209\84\71\247\227\199\98\93\241\253\197\88\93\176\185\154", "\144\143\162\61\41");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\198\193\18\67\102\180\59\239\208\22", "\83\128\179\125\48\18\231")]:IsCastable() and v40 and v122() and v120() and (v119() < 110) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\113\182\229\220\101\11\79\164\231", "\126\61\215\147\189\39")]:ChargesFractional() < 1) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\93\243\24\70\108\237\20\67\113\250\25\118\112\240\30\78\107", "\37\24\159\125")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\255\170\112\79\223\168\97\67\214\132\121\67\201\178", "\34\186\198\21")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\212\1\194\85\214\246\1\203\90\240\247\12", "\162\152\104\165\61")]:IsAvailable()) or (4623 == 1784)) then
					if ((546 <= 1071) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\203\61\189\110\100\218\222\39\189\126\123\165\222\38\188\122\124\224\242\59\179\111\119\224\217\111\229\45", "\133\173\79\210\29\16");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\168\112\232\38\136\114\249\42\129\94\225\42\158\104", "\75\237\28\141")]:IsAvailable() and v38 and (v120() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\240\86\203\185\59\21\238\239\219\109\195\181", "\129\188\63\172\209\79\123\135")]:IsAvailable())) or (4862 <= 3641)) then
					if ((2850 > 997) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\69\232\227\192\69\234\242\204\76\219\228\193\65\247\242\141\83\237\232\202\76\225\217\217\65\246\225\200\84\164\177\159", "\173\32\132\134");
					end
				end
				if ((4180 <= 4502) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\26\26\251\166\2\197\65\24\3", "\173\46\123\104\143\206\81")]:IsReady() and v37) then
					if (v24(v98.EarthShock, not v17:IsSpellInRange(v98.EarthShock)) or (149 == 893)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\28\48\158\77\188\18\188\18\33\129\5\144\8\186\26\46\143\122\151\0\166\26\39\158\5\212\85", "\97\212\125\66\234\37\227");
					end
				end
				v156 = 5;
			end
			if ((1037 < 1746) and (7 == v156)) then
				if ((3738 >= 3692) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\226\65\28\17\68\144\200\78\21\12\68\181\207\78", "\220\161\41\125\120\42")]:IsAvailable() and v35 and (v110 > 1) and (v111 > 1)) then
					if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or (3822 < 823)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\121\161\7\178\78\172\7\187\121\180\0\181\127\167\78\175\120\174\9\176\116\159\26\189\99\167\11\168\49\241\94\228", "\110\220\17\192");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\88\112\51\18\255\57\248\169\115\91\59\22\255", "\199\20\25\84\122\139\87\145")]:IsAvailable() and v44) or (4962 == 3146)) then
					if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or (475 > 4146)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\0\218\166\15\228\78\7\218\145\25\229\75\29\157\189\18\228\64\5\216\145\15\235\85\14\216\186\91\187\22\89", "\138\39\105\189\206\123");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\57\11\136\32\246\202\199\240\28\12", "\159\127\103\233\77\147\153\175")]:IsCastable() and UseFlameShock and (v14:IsMoving())) or (121 >= 129)) then
					if (v102.CastCycle(v98.FlameShock, v109, v113, not v17:IsSpellInRange(v98.FlameShock)) or (2058 > 4958)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\252\229\167\69\244\20\248\235\169\75\139\20\249\234\173\76\206\56\228\229\184\71\206\19\176\181\251\18", "\171\103\144\132\202\32");
					end
				end
				if ((1759 == 1759) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\54\35\232\1\21\28\225\3\19\36", "\108\112\79\137")]:IsCastable() and UseFlameShock) then
					if (v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock)) or (4543 == 358)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\206\117\37\168\62\250\61\48\193\127\104\190\8\231\50\51\199\75\60\172\19\238\48\43\130\37\121\249", "\85\95\162\20\72\205\97\137");
					end
				end
				if ((2003 == 2003) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\209\239\37\207\25\203\197\248\254\33", "\173\151\157\74\188\109\152")]:IsCastable() and v40) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (3 == 2368)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\26\55\206\200\107\198\251\43\11\51\157\207\93\219\244\40\13\7\201\221\70\210\246\48\72\105\140\138", "\147\68\104\88\189\188\52\181");
					end
				end
				break;
			end
			if ((v156 == 1) or (2757 > 3968)) then
				if ((812 <= 1870) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\165\91\209\24\88\12\139\88\211\30", "\95\227\55\176\117\61")]:IsCastable() and UseFlameShock and (v110 > 1) and (v111 > 1) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\60\123\38\91\167\1\76\44\68\191\29\122\6\71\174\21\123\45\95\184", "\203\120\30\67\43")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\208\54\78\234\215\245\36\67\236\220", "\185\145\69\45\143")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\186\13\16\171\211\152\27\16\167\208\189\30\15\163", "\188\234\127\121\198")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\55\18\145\49\60\20\165\52\51\30\134\43", "\227\88\82\115")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\110\30\189\170\3\80\75\30\183\165\7\97", "\19\35\127\218\199\98")]:IsAvailable()) and ((v14:BuffUp(v98.SurgeofPowerBuff) and not v121() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\47\239\5\240\17\240\15\231\12\254\24", "\130\124\155\106")]:IsAvailable()) or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\230\222\228\168\166\249\122\143\218\220\243\189", "\223\181\171\150\207\195\150\28")]:IsAvailable())) then
					if ((3889 == 3889) and v102.CastTargetIf(v98.FlameShock, v109, LUAOBFUSACTOR_DECRYPT_STR_0("\65\51\237", "\105\44\90\131\206"), v116, v113, not v17:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\236\179\180\13\1\236\232\189\186\3\126\236\233\188\190\4\59\192\244\179\171\15\59\235\160\227\239", "\94\159\128\210\217\104");
					end
				end
				if ((1411 < 2388) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\99\237\9\173\82\116\252\127\64\252\20", "\26\48\153\102\223\63\31\153")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\49\84\226\225\15\75\232\246\18\69\255", "\147\98\32\141")]:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and v14:BuffDown(v98.AscendanceBuff) and not v121() and (v119() >= 116) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\61\79\230\199\3\88\95\25\79\193\198\7\69\95", "\43\120\35\131\170\102\54")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\103\19\149\177\160\191\130\100\9\144\179\183", "\228\52\102\231\214\197\208")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\45\247\112\198\230\130\23\209\51\225\112\198\249\159\11\217\19", "\182\126\128\21\170\138\235\121")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\167\219\35\231\181\6\34\1\142", "\102\235\186\85\134\230\115\80")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\114\15\54\80\125\210\54\95\9\27\83\119\217\39\89\24\45", "\66\55\108\94\63\18\180")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\36\159\140\58\40\75\16\132\132\59\20\76\6\138\128", "\57\116\237\229\87\71")]:IsAvailable()) then
					if ((4771 == 4771) and v24(v98.Stormkeeper)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\185\165\226\245\122\229\66\175\161\232\245\55\253\78\164\182\225\226\72\250\70\184\182\232\243\55\191\31", "\39\202\209\141\135\23\142");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\204\39\6\24\63\243\250\54\25\15\32", "\152\159\83\105\106\82")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\178\210\94\224\196\87\132\195\65\247\219", "\60\225\166\49\146\169")]:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and v14:BuffDown(v98.AscendanceBuff) and not v121() and v14:BuffUp(v98.SurgeofPowerBuff) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\3\31\57\43\50\18\61\25\42", "\103\79\126\79\74\97")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\159\124\219\124\81\28\174\119\214\86\82\31\183\122\221\103\77", "\122\218\31\179\19\62")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\131\196\196\204\198\179\65\186\215\193\242\220\179\66\182", "\37\211\182\173\161\169\193")]:IsAvailable()) or (98 >= 2345)) then
					if ((4297 > 1243) and v24(v98.Stormkeeper)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\46\66\203\37\112\188\242\42\72\203\104\104\176\249\61\65\220\23\111\184\229\61\72\205\104\41\233", "\217\151\90\45\185\72\27");
					end
				end
				if ((167 <= 4460) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\240\104\232\0\91\200\121\226\2\83\209", "\54\163\28\135\114")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\207\82\144\67\116\45\222\77\135\92", "\31\72\187\61\226\46")]:CooldownRemains() == 0) and not v14:BuffUp(v98.StormkeeperBuff) and v47 and ((v64 and v33) or not v64) and (v89 < v105) and v14:BuffDown(v98.AscendanceBuff) and not v121() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\240\19\81\213\66\113\34\243\9\84\215\85", "\68\163\102\35\178\39\30")]:IsAvailable() or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\155\124\223\202\6\187\151\16\178\82\214\198\16\161", "\113\222\16\186\167\99\213\227")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\2\15\237\247\29\27\233\241\43", "\150\78\110\155")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\160\198\47\238\171\24\171\72\128\224\43\228\169\27\177\84\150", "\32\229\165\71\129\196\126\223")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\243\155\205\140\142\199\199\128\197\141\178\192\209\142\193", "\181\163\233\164\225\225")]:IsAvailable())) then
					if (v24(v98.Stormkeeper) or (3812 < 3081)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\159\49\101\93\128\59\114\64\142\44\55\67\130\48\112\92\142\1\99\81\153\57\114\68\203\108\37", "\23\48\235\94");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\93\201\219\88\89\55\211\114\217\221", "\178\28\186\184\61\55\83")]:IsCastable() and v51 and ((v57 and v32) or not v57) and (v89 < v105) and not v121()) or (3611 > 4881)) then
					if ((2187 < 3817) and v24(v98.Ascendance)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\197\222\68\57\252\10\244\202\206\66\124\225\7\251\195\193\66\3\230\15\231\195\200\83\124\160\90", "\149\164\173\39\92\146\110");
					end
				end
				if ((428 <= 985) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\223\46\23\23\14\21\250\41\23\61\21\23\231", "\123\147\71\112\127\122")]:IsAvailable() and v44 and v121() and v14:BuffUp(v98.SurgeofPowerBuff)) then
					if ((2952 >= 1023) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\196\133\121\82\194\196\140\118\121\206\194\142\101\6\223\196\140\118\74\201\242\150\112\84\203\200\150\49\20\154", "\38\172\173\226\17");
					end
				end
				if ((554 <= 3482) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\97\16\58\238\111\20\45\226", "\143\45\113\76")]:IsCastable() and v42 and (v110 > 1) and (v111 > 1) and v121() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\139\173\14\59\189\183\26\12\183\175\25\46", "\92\216\216\124")]:IsAvailable()) then
					if ((74 <= 3533) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\51\186\65\194\89\55\173\77\189\72\59\162\71\241\94\13\184\65\239\92\55\184\0\175\3", "\157\59\82\204\32");
					end
				end
				if ((1657 < 3319) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\54\226\243\231\198\218\182\48\42\237\243\231\237", "\209\88\94\131\154\137\138\179")]:IsAvailable() and v35 and (v110 > 1) and (v111 > 1) and v121() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\180\214\123\27\44\55\18\39\182\193\110", "\66\72\193\164\28\126\67\81")]:IsAvailable()) then
					if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or (1616 == 1003)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\36\169\81\40\73\235\37\175\80\50\120\238\34\175\24\53\127\233\43\164\93\25\98\230\62\175\93\50\54\180\124", "\22\135\76\200\56\70");
					end
				end
				v156 = 2;
			end
			if ((3 == v156) or (3672 <= 863)) then
				if ((612 < 1082) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\123\254\75\153\73\223\76\133\94\231", "\234\61\140\36")]:IsCastable() and v40 and v122() and v121() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\13\220\172\115\60\52\207\189\119", "\111\65\189\218\18")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\102\72\19\58\4\90\187\75\78\62\57\14\81\170\77\95\8", "\207\35\43\123\85\107\60")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\64\184\169\231\118\98\174\169\235\117\67\191\178\237\124", "\25\16\202\192\138")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\216\199\168\239\172\250\233\202\161\192\165\245\238\223", "\148\157\171\205\130\201")]:IsAvailable() and (((v119() >= 61) and (v119() < 75) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\15\213\98\40\243\227\49\199\96", "\150\67\180\20\73\177")]:CooldownRemains() > v14:GCD())) or ((v119() >= 49) and (v119() < 63) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\161\25\12\76\175\13\8\94\153", "\45\237\120\122")]:CooldownRemains() > 0)))) then
					if ((2142 == 2142) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\250\173\63\195\215\177\36\216\235\169\108\196\225\172\43\219\237\157\56\214\250\165\41\195\168\246\116", "\76\183\136\194");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\92\244\234\43\68\124\28\117\229\238", "\116\26\134\133\88\48\47")]:IsCastable() and v40 and v122() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\50\192\182\229\142\103\12\198\165", "\18\126\161\192\132\221")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\122\43\166\11\89\89\60\166\1\115\83\45\163\1\88\75\59", "\54\63\72\206\100")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\237\85\64\119\224\117\220\88\73\88\233\122\219\77", "\27\168\57\37\26\133")]:IsAvailable() and (((v119() >= 36) and (v119() < 50) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\1\171\106\169\245\56\184\111\188", "\183\77\202\28\200")]:CooldownRemains() > v14:GCD())) or ((v119() >= 24) and (v119() < 38) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\59\50\159\9\53\38\155\27\3", "\104\119\83\233")]:CooldownRemains() > 0)))) or (1680 < 749)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (2012 < 213)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\243\234\40\49\87\202\235\47\45\64\254\184\52\43\77\242\244\34\29\87\244\234\32\39\87\181\173\119", "\35\149\152\71\66");
					end
				end
				if ((4516 >= 2342) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\53\233\84\177\24\12\250\81\164", "\90\121\136\34\208")]:IsAvailable() and v43 and v14:BuffUp(v98.WindspeakersLavaResurgenceBuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\226\13\93\17\200\8\65\22\194\43\89\27\202\11\91\10\212", "\126\167\110\53")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\17\17\56\249\239\42\47\23\43", "\95\93\112\78\152\188")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\241\231\140\24\235\172\214\200\244\137\38\241\172\213\196", "\178\161\149\229\117\132\222")]:IsAvailable() or ((v119() >= 63) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\165\218\206\184\164\4\169\37\156\211\216\137\173\19\171\38\134\207\206", "\67\232\187\189\204\193\118\198")]:IsAvailable()) or ((v119() >= 38) and v14:BuffUp(v98.EchoesofGreatSunderingBuff) and (v110 > 1) and (v111 > 1)) or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\174\34\176\45\62\12\251\138\34\151\44\58\17\251", "\143\235\78\213\64\91\98")]:IsAvailable())) then
					if (v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst)) or (2402 == 3445)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\73\146\232\79\180\152\90\151\253\48\165\132\70\131\229\117\137\153\73\150\238\117\162\205\29\214", "\214\237\40\228\137\16");
					end
				end
				if ((160 <= 3550) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\169\226\249\216\33\179\151\240\251", "\198\229\131\143\185\99")]:IsAvailable() and v43 and v14:BuffUp(v98.LavaSurgeBuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\116\143\160\124\94\138\188\123\84\169\164\118\92\137\166\103\66", "\19\49\236\200")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\210\54\224\182\215\175\236\48\243", "\218\158\87\150\215\132")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\203\12\208\239\57\48\201\242\31\213\209\35\48\202\254", "\173\155\126\185\130\86\66")]:IsAvailable() or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\200\167\169\211\141\254\234\160\174\207\141\201\233\163\183\194\134\248\246", "\140\133\198\218\167\232")]:IsAvailable() or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\144\34\177\112\129\187\58\181\113\166\185\47\167\105", "\228\213\78\212\29")]:IsAvailable())) then
					if ((149 < 3450) and v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\139\77\160\4\212\133\89\164\22\255\199\95\191\11\236\139\73\137\17\234\149\75\179\17\171\210\24", "\139\231\44\214\101");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\245\238\16\95\50\164\35\5\205", "\118\185\143\102\62\112\209\81")]:IsAvailable() and v43 and v14:BuffUp(v98.AscendanceBuff) and (v14:HasTier(31, 4) or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\121\124\44\235\160\27\8\57\80\82\37\231\182\1", "\88\60\16\73\134\197\117\124")]:IsAvailable())) or (3406 < 2659)) then
					if ((3445 == 3445) and v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\235\238\201\126\82\255\234\219\85\16\249\241\198\70\92\239\199\220\64\66\237\253\220\1\5\188", "\33\48\138\152\168");
					end
				end
				if ((4871 == 4871) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\94\23\38\80\227\34\96\5\36", "\87\18\118\80\49\161")]:IsAvailable() and v43 and v14:BuffDown(v98.AscendanceBuff) and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\105\18\223\173\181\66\10\219\172\146\64\31\201\180", "\208\44\126\186\192")]:IsAvailable() or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\218\21\177\200\0\253\192\64\228\45\173\202\24\218\200\66\251", "\46\151\122\196\166\116\156\169")]:IsAvailable()) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\201\228\65\18\239\235\228\72\29\201\234\233", "\155\133\141\38\122")]:IsAvailable() and v14:HasTier(31, 4)) then
					if (v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst)) or (2384 < 828)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\41\43\186\64\112\125\176\55\57\184\1\92\118\171\34\38\169\126\91\126\183\34\47\184\1\26\39", "\197\69\74\204\33\47\31");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\220\78\76\134\210\90\72\148\228", "\231\144\47\58")]:IsAvailable() and v43 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\159\217\201\97\29\47\192\63\166\208\223\80\20\56\194\60\188\204\201", "\89\210\184\186\21\120\93\175")]:IsAvailable() and not v120() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\157\90\123\221\109\52\184\93\123\231\118\62", "\90\209\51\28\181\25")]:IsAvailable()) or (3490 >= 3857)) then
					if (v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst)) or (1930 == 3490)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\122\65\239\128\210\110\69\253\171\144\104\94\224\184\220\126\104\250\190\194\124\82\250\255\134\43", "\223\176\27\55\142");
					end
				end
				if ((284 == 284) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\8\186\216\180\6\174\220\166\48", "\213\68\219\174")]:IsAvailable() and v43 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\38\225\48\243\47\215\48\121\31\232\38\194\38\192\50\122\5\244\48", "\31\107\128\67\135\74\165\95")]:IsAvailable() and not v120() and ((v119() >= 75) or ((v119() >= 50) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\253\228\249\64\68\191\204\233\240\111\77\176\203\252", "\209\184\136\156\45\33")]:IsAvailable())) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\52\223\112\4\180\14\198\114\37\185\2\196\102\28\170\8\197", "\216\103\168\21\104")]:IsAvailable() and (v119() <= 130)) then
					if ((2448 > 1585) and v22(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\116\172\85\165\71\175\86\182\107\185\3\183\113\163\68\168\125\146\87\165\106\170\70\176\56\251\17", "\196\24\205\35");
					end
				end
				v156 = 4;
			end
			if ((3970 > 289) and (v156 == 5)) then
				if ((4729 == 4729) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\172\241\185\38\10\185\235\185\54\21", "\126\234\131\214\85")]:IsCastable() and v40 and v122() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\161\217\76\89\91\150\220\79\83\74\128\230\65\85\76\143\198", "\47\228\181\41\58")]:IsAvailable() and v120() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\138\245\222\51\23\62\22\168\251\235\52\7", "\127\198\156\185\91\99\80")]:IsAvailable() and (v110 > 1) and (v111 > 1)) then
					if ((1189 == 1189) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\243\8\195\227\179\52\42\214\250\25\199\176\180\2\55\217\249\31\243\228\166\25\62\219\225\90\155\166", "\190\149\122\172\144\199\107\89");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\30\4\231\255\220\39\23\226\234", "\158\82\101\145\158")]:IsAvailable() and v43 and v14:BuffUp(v98.FluxMeltingBuff) and (v110 > 1)) or (4168 <= 1718)) then
					if (v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst)) or (2379 > 3094)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\124\255\20\23\123\114\235\16\5\80\48\237\11\24\67\124\251\61\2\69\98\249\7\2\4\39\166", "\36\16\158\98\118");
					end
				end
				if ((4075 <= 4717) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\230\4\204\232\76\219\47\234\195\29", "\133\160\118\163\155\56\136\71")]:IsCastable() and v40 and v122() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\208\174\100\234\155\26\185\226\171\127\245", "\213\150\194\17\146\214\127")]:IsAvailable() and v14:BuffDown(v98.FluxMeltingBuff)) then
					if ((1472 == 1472) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\29\187\171\199\82\155\177\62\20\170\175\148\85\173\172\49\23\172\155\192\71\182\165\51\15\233\252\132", "\86\123\201\196\180\38\196\194");
					end
				end
				if ((4520 > 4486) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\209\250\214\188\227\219\209\160\244\227", "\207\151\136\185")]:IsCastable() and v40 and v122() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\141\143\45\129\96\106\120\174\138\45\134\71\112\126\171\136\59", "\17\200\227\72\226\20\24")]:IsAvailable() and (v17:DebuffRemains(v98.ElectrifiedShocksDebuff) < 2)) or (v14:BuffRemains(v98.IcefuryBuff) < 6))) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (622 > 1409)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\83\20\196\221\206\252\247\191\66\16\151\218\248\225\248\188\68\36\195\200\227\232\250\164\1\67\133", "\159\208\33\123\183\169\145\143");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\222\91\46\55\208\79\42\37\230", "\86\146\58\88")]:IsAvailable() and v43 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\220\226\207\161\239\34\242\93\250\230\197\163\236\56\238\75", "\154\56\191\138\160\206\137\86")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\170\88\227\134\79\47\147\203\131", "\172\230\57\149\231\28\90\225")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\50\184\143\223\39\201\6\163\135\222\27\206\16\173\131", "\187\98\202\230\178\72")]:IsAvailable() or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\4\237\161\61\79\47\245\165\60\104\45\224\183\36", "\42\65\129\196\80")]:IsAvailable() or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\47\75\78\206\18\21\13\232\22\66\88\255\27\2\15\235\12\94\78", "\142\98\42\61\186\119\103\98")]:IsAvailable() or v121())) or (2065 == 4654)) then
					if (v102.CastCycle(v98.LavaBurst, v109, v117, not v17:IsSpellInRange(v98.LavaBurst)) or (4584 < 2479)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\190\20\9\7\189\23\26\43\171\66\27\49\177\5\4\61\128\22\9\42\184\7\28\120\231\86", "\104\88\223\98");
					end
				end
				if ((1753 >= 1055) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\97\251\231\195\7\227\80\246\238\236\14\236\87\227", "\141\36\151\130\174\98")]:IsAvailable() and v38) then
					if ((2136 >= 510) and v24(v98.ElementalBlast, not v17:IsSpellInRange(v98.ElementalBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\118\199\0\129\116\214\12\136\69\192\1\133\105\214\77\151\115\204\10\136\127\253\25\133\104\197\8\144\58\154\91", "\109\228\26\162");
					end
				end
				if ((2377 < 2472) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\237\252\113\238\202\87\226\245\108\238\239\80\226", "\134\62\133\157\24\128")]:IsAvailable() and v35 and v120() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\50\171\8\220\35\180\216\19\172\20\222\12\176\218\6\168\19\205\54", "\182\103\197\122\185\79\209")]:IsAvailable() and (v110 > 1) and (v111 > 1)) then
					if (v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning)) or (2764 > 2956)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\143\224\126\14\119\255\142\230\127\20\70\250\137\230\55\19\65\253\128\237\114\63\92\242\149\230\114\20\8\171\223", "\40\147\231\129\23\96");
					end
				end
				if ((3192 <= 3445) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\89\241\139\77\175\162\213\123\255\174\74\183\184", "\188\21\152\236\37\219\204")]:IsAvailable() and v44 and v120() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\117\231\37\9\76\236\57\24\73\231\48\47\65\229\54\1\73\253\46", "\108\32\137\87")]:IsAvailable()) then
					if ((4775 > 3465) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\225\7\174\59\247\66\87\173\215\2\169\35\237\11\74\163\230\7\170\42\198\95\88\184\239\5\178\111\160\27", "\57\202\136\96\198\79\153\43");
					end
				end
				v156 = 6;
			end
			if ((v156 == 6) or (3711 < 507)) then
				if ((3276 <= 4677) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\130\32\175\161\152\181\225", "\152\203\67\202\199\237\199")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\211\64\165\9\10\103\96", "\134\154\35\192\111\127\21\25")]:CooldownRemains() == 0) and v41) then
					if ((2272 >= 1107) and v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\37\12\12\53\192\161\102\26\3\46\213\180\35\54\30\33\192\191\35\29\74\121\128", "\178\216\70\105\106\64");
					end
				end
				if ((911 >= 521) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\28\35\123\255\199\249\221\135\55\63\116\255\199\210", "\224\95\75\26\150\169\181\180")]:IsAvailable() and v35 and v16:IsActive() and (v16:Name() == LUAOBFUSACTOR_DECRYPT_STR_0("\44\200\221\41\80\169\100\75\233\204\39\86\161\54\46\214\221\37\65\162\98\10\214", "\22\107\186\184\72\36\204")) and v17:DebuffUp(v98.LightningRodDebuff) and (v17:DebuffUp(v98.ElectrifiedShocksDebuff) or v120()) and (v110 > 1) and (v111 > 1)) then
					if ((3804 > 3392) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\181\37\71\0\216\177\45\73\6\243\179\45\64\9\167\174\45\64\9\235\184\27\90\15\245\186\33\90\78\190\233", "\110\135\221\68\46");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\207\63\11\227\218\189\50\237\49\46\228\194\167", "\91\131\86\108\139\174\211")]:IsAvailable() and v44 and v16:IsActive() and (v16:Name() == LUAOBFUSACTOR_DECRYPT_STR_0("\220\57\189\22\73\254\57\248\36\73\244\57\181\87\120\247\46\181\18\83\239\42\180", "\61\155\75\216\119")) and v17:DebuffUp(v98.LightningRodDebuff) and (v17:DebuffUp(v98.ElectrifiedShocksDebuff) or v120())) or (935 <= 162)) then
					if ((414 < 1183) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\8\162\181\52\76\7\212\10\172\141\62\87\5\201\68\184\187\50\95\5\216\59\191\179\46\95\12\201\68\242\228", "\189\100\203\210\92\56\105");
					end
				end
				if ((4098 > 766) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\67\242\59\59\98\245\39\44\90", "\72\79\49\157")]:IsCastable() and v40 and v122() and v120() and v14:BuffDown(v98.LavaSurgeBuff) and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\173\188\52\191\156\162\56\186\129\181\53\143\128\191\50\183\155", "\220\232\208\81")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\211\178\240\40\1\95\173\225\183\235\55", "\193\149\222\133\80\76\58")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\234\92\89\211\228\72\93\193\210", "\178\166\61\47")]:ChargesFractional() < 1) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\222\73\224\117\197\56\239\66\237\95\198\59\246\79\230\110\217", "\94\155\42\136\26\170")]:IsAvailable()) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (3904 <= 98)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\130\45\41\166\144\0\53\189\139\60\45\245\151\54\40\178\136\58\25\161\133\45\33\176\144\127\127\237", "\213\228\95\70");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\12\169\205\151\99\25\179\205\135\124", "\23\74\219\162\228")]:IsCastable() and v40 and v122() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\31\234\83\183\22\60\234\82\166\53\62", "\91\89\134\38\207")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\97\226\205\53\7\194\46\66\231\205\50\32\216\40\71\229\219", "\71\36\142\168\86\115\176")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\243\168\117\183\23\176\95\71\216\147\125\187", "\41\191\193\18\223\99\222\54")]:IsAvailable()))) or (4255 <= 549)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (472 > 516)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\52\200\57\190\148\53\207\37\169\160\102\212\35\164\172\42\194\21\190\170\52\192\47\190\235\119\151\122", "\202\203\70\167\74");
					end
				end
				if ((4264 > 983) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\15\9\221\58\127\0\8\219\59\101\34\8\210\52", "\17\76\97\188\83")]:IsAvailable() and v35 and v120() and v14:BuffDown(v98.LavaSurgeBuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\169\38\207\54\18\150\89\176\145", "\195\229\71\185\87\80\227\43")]:ChargesFractional() < 1) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\197\255\8\95\224\230\232\8\85\202\236\249\13\85\225\244\239", "\143\128\156\96\48")]:IsAvailable() and (v110 > 1) and (v111 > 1)) then
					if ((386 < 4511) and v24(v98.ChainLightning, not v17:IsSpellInRange(v98.ChainLightning))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\187\217\241\27\25\135\221\249\21\31\172\223\249\28\16\248\194\249\28\16\180\212\207\6\22\170\214\245\6\87\233\129\162", "\119\216\177\144\114");
					end
				end
				if ((4795 > 3065) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\229\32\254\74\221\39\240\76\206\11\246\78\221", "\34\169\73\153")]:IsAvailable() and v44 and v120() and v14:BuffDown(v98.LavaSurgeBuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\134\237\29\138\136\249\25\152\190", "\235\202\140\107")]:ChargesFractional() < 1) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\41\119\60\167\230\33\227\205\9\81\56\173\228\34\249\209\31", "\165\108\20\84\200\137\71\151")]:IsAvailable()) then
					if (v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt)) or (4884 == 1777)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\118\189\44\128\110\186\34\134\125\139\41\135\118\160\107\155\115\186\44\132\127\139\63\137\104\179\46\156\58\229\123\220", "\232\26\212\75");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\17\91\125\251\227\4\65\125\235\252", "\151\87\41\18\136")]:IsCastable() and v40 and v122() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\126\163\207\211\234\73\166\204\217\251\95\156\194\223\253\80\188", "\158\59\207\170\176")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\105\82\38\81\161\74\82\39\64\130\72", "\236\47\62\83\41")]:IsAvailable()) or (2997 == 3076)) then
					if (v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock)) or (1158 >= 4765)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\252\187\47\40\190\189\233\161\47\56\161\194\233\160\46\60\166\135\197\189\33\41\173\135\238\233\113\107\252", "\226\154\201\64\91\202");
					end
				end
				v156 = 7;
			end
			if ((v156 == 0) or (844 == 250)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\8\66\44\208\116\29\249\35\78\48\193\80\29", "\156\78\43\94\181\49\113")]:IsCastable() and v52 and ((v58 and v32) or not v58) and (v89 < v105)) or (4757 < 3588)) then
					if (v24(v98.FireElemental) or (197 > 4460)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\116\225\214\166\52\70\117\119\229\193\173\31\66\117\50\251\205\173\12\79\124\77\252\197\177\12\70\109\50\186", "\25\18\136\164\195\107\35");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\219\57\166\93\127\153\205\189\229\40\167\91\115\176", "\216\136\77\201\47\18\220\161")]:IsCastable() and v54 and ((v59 and v32) or not v59) and (v89 < v105)) or (475 < 230)) then
					if ((69 <= 137) and v24(v98.StormElemental)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\248\36\200\5\227\135\33\233\38\223\6\200\131\33\172\56\211\6\219\142\40\211\63\219\26\219\135\57\172\127", "\226\77\140\75\186\104\188");
					end
				end
				if ((2296 == 2296) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\141\193\196\58\66\176\205\226\58\76\184\194\220", "\47\217\174\176\95")]:IsCastable() and v48 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\148\212\103\23\187\80\85\39\191\208\119\54\189\64\125\43", "\70\216\189\22\98\210\52\24")]:CooldownRemains() > 45) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\246\222\181\134\224\207\205\164\130", "\179\186\191\195\231")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\202\47\20\237\247\43\29\246\252\59\61\232\252\50\29\234\237\44", "\132\153\95\120")]:IsAvailable()) or ((v110 > 1) and (v111 > 1)))) then
					if (v24(v98.TotemicRecall) or (532 >= 1376)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\189\26\40\250\211\163\142\160\11\46\246\214\172\241\161\7\35\240\214\165\142\166\15\63\240\223\180\241\229", "\192\209\210\110\77\151\186");
					end
				end
				if ((1698 < 2725) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\204\10\51\252\246\192\205\2\37\228\254\240\239\23\39\228", "\164\128\99\66\137\159")]:IsCastable() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == LUAOBFUSACTOR_DECRYPT_STR_0("\3\156\251\173\15\155", "\222\96\233\137")) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\149\178\177\30\187\230\226\190\182", "\144\217\211\199\127\232\147")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\203\63\50\33\219\81\7\86\253\43\27\36\208\72\7\74\236\60", "\36\152\79\94\72\181\37\98")]:IsAvailable()) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\241\212\70\50\210\235\79\48\212\211\99\58\213\205\65\57", "\95\183\184\39")]:AuraActiveCount() == 0) or (v17:DebuffRemains(v98.FlameShockDebuff) < 6) or ((v110 > 1) and (v111 > 1)))) then
					if ((4064 == 4064) and v24(v100.LiquidMagmaTotemCursor, not v17:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\185\54\246\51\93\132\61\184\62\224\43\85\191\22\186\43\226\43\20\147\11\187\56\235\35\107\148\3\167\56\226\50\20\216", "\98\213\95\135\70\52\224");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\210\170\216\98\93\250\142\200\112\89\255\151\198\99\81\243", "\52\158\195\169\23")]:IsCastable() and v53 and ((v60 and v32) or not v60) and (v89 < v105) and (v65 == LUAOBFUSACTOR_DECRYPT_STR_0("\106\176\51\109\131\39", "\235\26\220\82\20\230\85\27")) and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\164\160\255\195\71\157\179\238\199", "\20\232\193\137\162")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\17\207\201\175\233\152\18\99\39\219\224\170\226\129\18\127\54\204", "\17\66\191\165\198\135\236\119")]:IsAvailable()) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\41\163\175\30\250\219\228\222\12\164\138\22\253\253\234\215", "\177\111\207\206\115\159\136\140")]:AuraActiveCount() == 0) or (v17:DebuffRemains(v98.FlameShockDebuff) < 6) or ((v110 > 1) and (v111 > 1)))) or (2270 == 3114)) then
					if (v24(v100.LiquidMagmaTotemPlayer, not v17:IsInRange(40)) or (1564 > 3303)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\128\1\1\221\75\96\8\136\23\25\213\112\75\10\157\21\25\148\92\86\11\142\28\17\235\91\94\23\142\21\0\148\23", "\63\101\233\112\116\180\47");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\243\41\228\31\247\36\199\50\236\30\207\55\213\62", "\86\163\91\141\114\152")]:IsAvailable() and v46 and v63 and (v89 < v105) and v33 and v14:BuffDown(v98.PrimordialWaveBuff) and v14:BuffDown(v98.SplinteredElementsBuff)) or (2164 > 3146)) then
					if ((686 < 2227) and v102.CastTargetIf(v98.PrimordialWave, v109, LUAOBFUSACTOR_DECRYPT_STR_0("\94\2\122", "\90\51\107\20\19"), v116, nil, not v17:IsSpellInRange(v98.PrimordialWave), nil, Settings[LUAOBFUSACTOR_DECRYPT_STR_0("\174\255\136\226\50\131\227", "\93\237\144\229\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\49\255\227\9\7\71\12\197\228\0\7\67", "\38\117\150\144\121\107")].Signature)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\169\231\55\34\169\234\51\44\183\209\45\44\173\235\122\62\178\224\61\33\190\209\46\44\169\233\63\57\251\191\106", "\90\77\219\142");
					end
				end
				if ((605 == 605) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\8\32\52\73\52\114\233\7\42", "\26\134\100\65\89\44\103")]:IsCastable() and UseFlameShock and (v110 == 1) and v17:DebuffRefreshable(v98.FlameShockDebuff) and v14:BuffDown(v98.SurgeofPowerBuff) and (not v120() or (not v121() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\212\239\53\46\161\255\247\49\47\134\253\226\35\55", "\196\145\131\80\67")]:IsAvailable() and (v119() < (90 - (8 * v98[LUAOBFUSACTOR_DECRYPT_STR_0("\59\169\3\7\30\252\22\181\53\28\23\250\19", "\136\126\208\102\104\120")]:TalentRank())))) or (v119() < (60 - (5 * v98[LUAOBFUSACTOR_DECRYPT_STR_0("\93\147\203\76\169\70\53\84\75\158\193\81\162", "\49\24\234\174\35\207\50\93")]:TalentRank()))))))) then
					if (v24(v98.FlameShock, not v17:IsSpellInRange(v98.FlameShock)) or (2878 < 141)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\254\252\133\116\51\225\245\135\114\7\178\238\129\127\11\254\248\183\101\13\224\250\141\101\76\163\175", "\17\108\146\157\232");
					end
				end
				if ((474 < 1065) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\109\207\21\224\42\155\67\204\23\230", "\200\43\163\116\141\79")]:IsCastable() and UseFlameShock and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\153\58\60\142\181\199\235\176\53\54\167\181\246\246\185\48", "\131\223\86\93\227\208\148")]:AuraActiveCount() == 0) and (v110 > 1) and (v111 > 1) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\199\64\179\166\17\172\209\74\185\162\24\177\198\73\179\187\24\187\247\86", "\213\131\37\214\214\125")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\7\56\38\186\239\34\42\43\188\228", "\129\70\75\69\223")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\118\217\250\228\115\253\66\194\242\229\75\238\80\206", "\143\38\171\147\137\28")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\227\135\184\225\10\237\211\246\142\184\254\6\240", "\180\176\226\217\147\99\131")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\254\184\40\10\210\154\39\6\222\187\42\21", "\103\179\217\79")]:IsAvailable()) and ((not v120() and (v121() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\121\163\19\199\76\135\166\79\167\25\199", "\195\42\215\124\181\33\236")]:CooldownRemains() > 0))) or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\62\76\37\57\32\247\11\105\56\41\32\234", "\152\109\57\87\94\69")]:IsAvailable())) then
					if ((4139 > 3173) and v102.CastTargetIf(v98.FlameShock, v109, LUAOBFUSACTOR_DECRYPT_STR_0("\244\222\4", "\200\153\183\106\195\222\178\52"), v116, nil, not v17:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\239\137\48\76\101\33\235\135\62\66\26\33\234\134\58\69\95\13\247\137\47\78\95\38\163\217\105", "\58\82\131\232\93\41");
					end
				end
				v156 = 1;
			end
			if ((4392 == 4392) and (v156 == 2)) then
				if ((1013 == 1013) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\161\49\238\37\127\244\159\35\236", "\129\237\80\152\68\61")]:IsAvailable() and v43 and v121() and not v120() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\98\189\22\244\25\24\94\97\167\19\246\14", "\56\49\200\100\147\124\119")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\225\63\172\228\201\44\176\246\216\54\186\213\192\59\178\245\194\42\172", "\144\172\94\223")]:IsAvailable()) then
					if ((520 == 520) and v24(v98.LavaBurst, not v17:IsSpellInRange(v98.LavaBurst))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\40\14\180\70\27\13\183\85\55\27\226\84\45\1\165\75\33\48\182\70\54\8\167\83\100\92\240", "\39\68\111\194");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\250\175\224\207\109\185\223\168\224\229\118\187\194", "\215\182\198\135\167\25")]:IsAvailable() and v44 and v121() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\190\92\248\79\136\70\236\120\130\94\239\90", "\40\237\41\138")]:IsAvailable() and v120()) or (3546 <= 2759)) then
					if ((4016 > 3561) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\203\125\253\240\94\201\125\244\255\117\197\123\246\236\10\212\125\244\255\70\194\75\238\249\88\192\113\238\184\25\147", "\42\167\20\154\152");
					end
				end
				if ((1857 < 3234) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\102\247\165\74\101\47\67\240\165\96\126\45\94", "\65\42\158\194\34\17")]:IsAvailable() and v44 and v121() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\41\50\64\11\40\226\29\222\21\48\87\30", "\142\122\71\50\108\77\141\123")]:IsAvailable() and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\56\163\236\12\62\7\173\249\12\51\16\135\243\29\54\16\172\235\11", "\91\117\194\159\120")]:IsAvailable()) then
					if ((4068 > 1180) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\20\57\16\33\255\45\20\26\1\26\58\253\48\90\14\55\22\50\253\33\37\9\63\10\50\244\48\90\78\104", "\68\122\125\94\120\85\145");
					end
				end
				if ((2513 == 2513) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\59\21\200\86\220\215\179\25\27\237\81\196\205", "\218\119\124\175\62\168\185")]:IsAvailable() and v44 and v14:BuffUp(v98.SurgeofPowerBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\137\249\79\204\177\254\65\202\162\194\71\192", "\164\197\144\40")]:IsAvailable()) then
					if ((3331 > 1280) and v24(v98.LightningBolt, not v17:IsSpellInRange(v98.LightningBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\143\249\173\131\201\184\138\254\173\180\223\185\143\228\234\152\212\184\132\252\175\180\201\183\145\247\175\159\157\229\219", "\214\227\144\202\235\189");
					end
				end
				if ((2347 >= 579) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\196\166\130\125\5\161\74", "\92\141\197\231\27\112\211\51")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\207\252\143\165\196\244\230", "\177\134\159\234\195")]:CooldownRemains() == 0) and v41 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\152\231\58\163\221\175\226\57\169\204\185\216\55\175\202\182\248", "\169\221\139\95\192")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\242\130\120\55\54\40\215\133\120\13\45\34", "\70\190\235\31\95\66")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\150\235\29\238\241\180\235\20\225\215\181\230", "\133\218\130\122\134")]:IsAvailable()) then
					if ((2409 == 2409) and v24(v98.Icefury, not v17:IsSpellInRange(v98.Icefury))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\252\230\194\201\177\33\124\236\234\202\219\175\61\3\235\226\214\219\166\44\124\171\179", "\88\92\159\131\164\188\195");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\166\60\176\88\195\216\213\143\45\180", "\189\224\78\223\43\183\139")]:IsCastable() and v40 and v122() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\240\143\21\213\60\245\140\31\196\42\207\130\25\194\37\239", "\161\78\156\234\118")]:IsAvailable() and ((v17:DebuffRemains(v98.ElectrifiedShocksDebuff) < 2) or (v14:BuffRemains(v98.IcefuryBuff) <= v14:GCD())) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\139\190\206\212\179\185\192\210\160\133\198\216", "\188\199\215\169")]:IsAvailable()) or (962 >= 3722)) then
					if ((2395 < 2649) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\27\80\104\252\195\26\87\116\235\247\73\76\114\230\251\5\90\68\252\253\27\88\126\252\188\93\13", "\136\156\105\63\27");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\61\158\118\39\15\191\113\59\24\135", "\84\123\236\25")]:IsCastable() and v40 and v122() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\213\135\175\20\184\167\249\141\163\18\168\134\248\132\169\28\191", "\213\144\235\202\119\204")]:IsAvailable() and (v119() >= 50) and (v17:DebuffRemains(v98.ElectrifiedShocksDebuff) < (2 * v14:GCD())) and v121() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\15\17\217\34\60\45\68\45\31\236\37\44", "\45\67\120\190\74\72\67")]:IsAvailable()) or (1373 > 4744)) then
					if ((2479 < 3052) and v24(v98.FrostShock, not v17:IsSpellInRange(v98.FrostShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\38\48\226\182\237\183\253\225\47\33\230\229\234\129\224\238\44\39\210\177\248\154\233\236\52\98\185\241", "\137\64\66\141\197\153\232\142");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\47\209\52\167\170\6\209\47", "\232\99\176\66\198")]:IsCastable() and v42 and (v110 > 1) and (v111 > 1) and v120() and (v14:BuffRemains(v98.AscendanceBuff) > v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\32\62\7\89\136\248\33", "\76\140\65\72\102\27\237\153")]:CastTime()) and not v14:HasTier(31, 4)) or (3777 < 1129)) then
					if ((1185 < 2612) and v24(v98.LavaBeam, not v17:IsSpellInRange(v98.LavaBeam))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\219\0\211\232\3\187\75\215\86\193\222\15\185\70\223\41\198\214\19\185\79\206\86\134\129", "\222\42\186\118\178\183\97");
					end
				end
				v156 = 3;
			end
		end
	end
	local function v130()
		local v157 = 0;
		while true do
			if ((4480 >= 683) and (v157 == 0)) then
				if ((2796 >= 2496) and v72 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\63\137\153\196\18\187\131\217\31\132\143", "\176\122\232\235")]:IsCastable() and v14:BuffDown(v98.EarthShieldBuff) and ((v73 == LUAOBFUSACTOR_DECRYPT_STR_0("\165\116\40\91\230\192\70\50\70\235\140\113", "\142\224\21\90\47")) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\81\216\34\91\161\133\145\117\216\8\68\166\130\145", "\229\20\180\71\54\196\235")]:IsAvailable() and v14:BuffUp(v98.LightningShield)))) then
					if ((4636 > 3610) and v24(v98.EarthShield)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\127\211\247\253\149\147\33\119\196\239\241\234\141\40\119\207\163\167", "\224\73\30\161\131\149\202");
					end
				elseif ((v72 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\221\236\246\88\229\235\248\94\246\214\249\89\244\233\245", "\48\145\133\145")]:IsCastable() and v14:BuffDown(v98.LightningShieldBuff) and ((v73 == LUAOBFUSACTOR_DECRYPT_STR_0("\118\69\178\230\197\34\83\66\178\174\226\36\83\73\185\234", "\76\58\44\213\142\177")) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\238\40\23\32\125\197\48\19\33\87\217\38\27\57", "\24\171\68\114\77")]:IsAvailable() and v14:BuffUp(v98.EarthShield)))) or (24 == 1960)) then
					if ((639 < 3347) and v24(v98.LightningShield)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\20\87\90\147\208\13\163\232\34\67\90\142\219\8\169\175\16\81\91\137\158\86", "\205\143\125\48\50\231\190\100");
					end
				end
				v29 = v124();
				v157 = 1;
			end
			if ((4167 <= 4286) and (v157 == 2)) then
				if ((3441 < 3525) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\205\42\203\173\228\182\254\37\196\155\231\171\254\45\220", "\194\140\68\168\200\151")]:IsCastable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\99\245\214\32\230\86\233\212\41\198\82\242\199\44\225", "\149\34\155\181\69")]:IsReady() and not v14:AffectingCombat() and v15:Exists() and v15:IsDeadOrGhost() and v15:IsAPlayer() and not v14:CanAttack(v15)) then
					if ((4114 < 4964) and v24(v100.AncestralSpiritMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\2\243\214\255\16\233\199\251\15\194\198\234\10\239\220\238\67\240\218\239\16\248\218\236\6\239", "\154\99\157\181");
					end
				end
				v106, v107 = v28();
				v157 = 3;
			end
			if ((v157 == 3) or (1161 == 2575)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\164\2\252\178\227\155\10\232\134\224\140\2\233\180\227\131\8\249\165\219\136\14\252\175\226", "\140\237\111\140\192")]:IsAvailable() and v49 and (not v106 or (v107 < 600000)) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\32\21\124\21\3\13\114\22\1\12\120\47\3\24\109\23\8", "\120\102\121\29")]:IsAvailable()) or (3531 > 3543)) then
					if ((543 == 543) and v24(v98.FlamentongueWeapon)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\239\184\54\169\247\182\53\171\246\188\4\187\230\184\43\163\237\249\62\162\224\177\58\162\247", "\91\204\131\217");
					end
				end
				if ((not v14:AffectingCombat() and v30 and v102.TargetIsValid()) or (3788 < 44)) then
					local v224 = 0;
					while true do
						if ((v224 == 0) or (4790 < 2768)) then
							v29 = v127();
							if (v29 or (4805 < 3074)) then
								return v29;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v157 == 1) or (2084 >= 3519)) then
				if ((4855 > 3864) and v29) then
					return v29;
				end
				if ((4274 == 4274) and v17 and v17:Exists() and v17:IsAPlayer() and v17:IsDeadOrGhost() and not v14:CanAttack(v17)) then
					if ((1029 == 1029) and v24(v98.AncestralSpirit, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\169\23\0\242\247\205\163\205\152\7\21\232\241\214\182", "\194\161\199\116\101\129\131\191");
					end
				end
				v157 = 2;
			end
		end
	end
	local function v131()
		local v158 = 0;
		while true do
			if ((89 == 89) and (v158 == 1)) then
				if (v84 or (810 > 944)) then
					local v225 = 0;
					while true do
						if ((v225 == 0) or (3503 <= 13)) then
							if (v79 or (4949 <= 3018)) then
								local v236 = 0;
								while true do
									if ((1602 >= 298) and (v236 == 0)) then
										v29 = v102.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 40);
										if ((4189 >= 4175) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							if ((4621 >= 1815) and v80) then
								local v237 = 0;
								while true do
									if ((1897 >= 326) and (0 == v237)) then
										v29 = v102.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 30);
										if (v29 or (2811 < 2702)) then
											return v29;
										end
										break;
									end
								end
							end
							v225 = 1;
						end
						if ((3539 > 1888) and (v225 == 1)) then
							if ((985 < 2861) and v81) then
								local v238 = 0;
								while true do
									if ((v238 == 0) or (4777 == 4762)) then
										v29 = v102.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 30);
										if ((1768 == 1768) and v29) then
											return v29;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if ((3346 > 1448) and v85) then
					local v226 = 0;
					while true do
						if ((0 == v226) or (2418 > 4432)) then
							v29 = v102.HandleIncorporeal(v98.Hex, v100.HexMouseOver, 30, true);
							if ((1758 <= 3423) and v29) then
								return v29;
							end
							break;
						end
					end
				end
				v158 = 2;
			end
			if ((v158 == 3) or (2091 > 3050)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\122\74\3\73\220", "\185\42\63\113\46")]:IsReady() and v95 and v34 and v82 and not v14:IsCasting() and not v14:IsChanneling() and v102.UnitHasMagicBuff(v17)) or (4386 <= 1106)) then
					if ((3992 >= 3533) and v24(v98.Purge, not v17:IsSpellInRange(v98.Purge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\200\51\62\30\148\217\32\52\26\211\216", "\123\180\189\65\89");
					end
				end
				if ((3541 <= 4155) and v102.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) then
					local v227 = 0;
					local v228;
					while true do
						if ((4365 >= 2825) and (v227 == 3)) then
							if (true or (1053 > 3604)) then
								local v239 = 0;
								while true do
									if ((4882 >= 3904) and (v239 == 1)) then
										if (v24(v98.Pool) or (1599 == 3736)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\32\182\3\240\224\208\31\171\76\207\169\216\23\181\9\200\161\196\23\188\24\180\233", "\182\112\217\108\156\192");
										end
										break;
									end
									if ((0 == v239) or (2991 > 4434)) then
										v29 = v129();
										if (v29 or (1676 == 1704)) then
											return v29;
										end
										v239 = 1;
									end
								end
							end
							break;
						end
						if ((1145 <= 2799) and (v227 == 1)) then
							if ((1913 == 1913) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\114\4\151\220\36\217\88\111\18\138\207\34\210\78\79\22", "\43\60\101\227\169\86\188")]:IsCastable() and v45) then
								if (v24(v98.NaturesSwiftness) or (2086 < 2040)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\126\201\197\170\72\201\170\8\99\223\216\185\78\194\188\36\99\136\220\190\83\194\249\102\34", "\87\16\168\177\223\58\172\217");
								end
							end
							v228 = v102.HandleDPSPotion(v14:BuffUp(v98.AscendanceBuff));
							v227 = 2;
						end
						if ((2 == v227) or (510 == 4402)) then
							if (v228 or (1901 >= 3884)) then
								return v228;
							end
							if ((4377 >= 309) and v31 and (v110 > 2) and (v111 > 2)) then
								local v240 = 0;
								while true do
									if ((367 < 2905) and (v240 == 0)) then
										v29 = v128();
										if ((1697 < 2409) and v29) then
											return v29;
										end
										v240 = 1;
									end
									if ((v240 == 1) or (3877 <= 2723)) then
										if (v24(v98.Pool) or (2493 < 2135)) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\4\194\86\209\123\50\194\75\157\26\59\200\17\148", "\91\84\173\57\189");
										end
										break;
									end
								end
							end
							v227 = 3;
						end
						if ((v227 == 0) or (1039 >= 1586)) then
							if ((2474 <= 4531) and (v89 < v105) and v56 and ((v62 and v32) or not v62)) then
								local v241 = 0;
								while true do
									if ((2432 > 980) and (v241 == 0)) then
										if ((1069 == 1069) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\224\128\255\235\141\228\153\226\253", "\233\162\236\144\132")]:IsCastable() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\147\215\253\31\183\242\94\188\199\251", "\63\210\164\158\122\217\150")]:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\18\216\245\233\71\252\50\197\245\233", "\152\83\171\150\140\41")]:CooldownRemains() > 50))) then
											if (v24(v98.BloodFury) or (4793 < 2333)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\128\233\140\60\208\36\14\151\247\154\115\217\26\1\140\165\209", "\104\226\133\227\83\180\123");
											end
										end
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\33\14\49\67\6\25\40\89\13\12", "\48\99\107\67")]:IsCastable() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\255\181\126\213\35\127\223\168\126\213", "\27\190\198\29\176\77")]:IsAvailable() or v14:BuffUp(v98.AscendanceBuff))) or (4926 < 1320)) then
											if ((1769 == 1769) and v24(v98.Berserking)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\237\78\239\39\172\92\228\66\243\51\233\67\238\66\243\116\253", "\46\143\43\157\84\201");
											end
										end
										v241 = 1;
									end
									if ((v241 == 1) or (1840 <= 1445)) then
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\113\113\68\199\93\31\199\88\124", "\168\55\24\54\162\63\115")]:IsCastable() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\54\233\35\133\220\202\22\244\35\133", "\174\119\154\64\224\178")]:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\109\198\126\11\163\27\234\41\123", "\132\74\30\165\27\101\199\122")]:CooldownRemains() > 50))) or (3252 <= 538)) then
											if (v24(v98.Fireblood) or (1291 > 3029)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\41\238\237\162\165\185\187\32\227\191\170\166\188\186\111\177", "\212\79\135\159\199\199\213");
											end
										end
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\88\174\182\66\79\195\10\120\172\150\70\80\219", "\120\25\192\213\39\60\183")]:IsCastable() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\57\83\60\77\22\68\62\70\27\69", "\40\120\32\95")]:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\184\58\127\161\27\59\165\58\127", "\127\90\203\89\26\207")]:CooldownRemains() > 50))) or (946 == 2209)) then
											if (v24(v98.AncestralCall) or (866 > 4384)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\220\59\172\206\26\233\207\52\163\244\10\252\209\57\239\198\8\244\211\117\247", "\157\189\85\207\171\105");
											end
										end
										v241 = 2;
									end
									if ((v241 == 2) or (2992 <= 1370)) then
										if ((4817 == 4817) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\228\160\223\186\5\242\179\209\182\8\213", "\99\166\193\184\213")]:IsCastable() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\247\164\131\190\2\142\215\185\131\190", "\234\182\215\224\219\108")]:IsAvailable() or v14:BuffUp(v98.AscendanceBuff))) then
											if ((788 < 4081) and v24(v98.BagofTricks)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\194\128\188\10\207\135\132\33\210\136\184\62\211\193\182\52\201\143\251\100\144", "\85\160\225\219");
											end
										end
										break;
									end
								end
							end
							if ((2339 > 29) and (v89 < v105)) then
								if ((2023 < 3715) and v55 and ((v32 and v61) or not v61)) then
									local v245 = 0;
									while true do
										if ((3517 < 3859) and (v245 == 0)) then
											v29 = v126();
											if (v29 or (2180 == 3317)) then
												return v29;
											end
											break;
										end
									end
								end
							end
							v227 = 1;
						end
					end
				end
				break;
			end
			if ((v158 == 2) or (3098 <= 1172)) then
				if ((4216 >= 814) and Focus) then
					if (v83 or (3975 == 4556)) then
						local v235 = 0;
						while true do
							if ((v235 == 0) or (1822 < 969)) then
								v29 = v123();
								if (v29 or (1756 < 1301)) then
									return v29;
								end
								break;
							end
						end
					end
				end
				if ((3768 == 3768) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\233\237\80\213\167\216\236\254\234\71\211\182", "\158\174\159\53\180\211\189")]:IsAvailable() and v95 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\117\239\232\220\99\176\64\205\248\207\112\176", "\213\50\157\141\189\23")]:IsReady() and v34 and v82 and not v14:IsCasting() and not v14:IsChanneling() and v102.UnitHasMagicBuff(v17)) then
					if ((2198 >= 1225) and v24(v98.GreaterPurge, not v17:IsSpellInRange(v98.GreaterPurge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\52\129\161\102\161\236\25\148\181\96\163\251\102\128\161\127\165\249\35", "\196\158\70\228\192\18");
					end
				end
				v158 = 3;
			end
			if ((3105 == 3105) and (v158 == 0)) then
				v29 = v125();
				if ((1719 <= 3213) and v29) then
					return v29;
				end
				v158 = 1;
			end
		end
	end
	local function v132()
		local v159 = 0;
		while true do
			if ((v159 == 6) or (3004 <= 2878)) then
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\252\140\97\0\198\135\114\7", "\116\175\233\21")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\235\187\117\207\62\45\243\221\178\67\214\52\49\234\249\178", "\95\158\152\222\38\187\81")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\184\33\166\170\198\255\174", "\168\152\221\85\210\195")][LUAOBFUSACTOR_DECRYPT_STR_0("\170\205\246\130\165\218\244\137\168\219\194\142\191\214\214\163", "\231\203\190\149")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\254\56\247\229\181\251\28\222", "\123\173\93\131\145\220\149")][LUAOBFUSACTOR_DECRYPT_STR_0("\26\205\252\52\125\253\59\197\234\44\117\205\25\208\232\44\67\240\2\204\206\5", "\153\118\164\141\65\20")];
				v159 = 7;
			end
			if ((v159 == 8) or (4515 == 4788)) then
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\34\172\85\98\201\31\174\82", "\160\113\201\33\22")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\76\163\181\164\166\209\93\188\162\187\154\221\76\164\138\160\163\221\123\136", "\205\180\56\204\199\201")];
				break;
			end
			if ((3106 <= 3129) and (v159 == 3)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\242\61\23\35\200\54\4\36", "\87\161\88\99")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\234\234\224\190\215\43\6\247\230\194\176\242\44\30\237", "\67\114\153\143\172\215\176")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\167\250\26\183\172\233\29", "\110\222\194\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\202\30\135\83\181\2\203\30\186\97\182\30\223\15\167\87\178\4", "\193\119\185\123\201\50")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\68\13\237\50\6\119\24\100", "\127\23\104\153\70\111\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\28\20\163\159\57\37\186\188\27\3\175\174\39\27\182\165\12", "\211\105\103\198\207\75\76\215")];
				v159 = 4;
			end
			if ((47 < 1298) and (v159 == 7)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\55\146\246\254\14\233\33", "\96\142\82\230\130\151")][LUAOBFUSACTOR_DECRYPT_STR_0("\73\185\93\71\193\226\74\189\74\76\240\239\67\135\70\86\236\205\107", "\142\47\208\47\34\132")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\187\16\22\82\82\241\173", "\60\150\222\100\98\59")][LUAOBFUSACTOR_DECRYPT_STR_0("\86\40\88\68\214\159\61\64\49\82\88\207\187\61\114\53\67\94\248\158", "\81\37\92\55\54\187\218")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\51\65\185\35\136\14\67\190", "\225\96\36\205\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\249\180\75\116\115\93\13\224\167\78\78\125\89\12\222\175\86\113\81\70\7\224\133\102", "\105\137\198\34\25\28\47")];
				v159 = 8;
			end
			if ((2250 <= 4114) and (v159 == 5)) then
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\234\212\12\228\225\199\11", "\120\141\143\160")][LUAOBFUSACTOR_DECRYPT_STR_0("\85\191\179\115\83\175\179\92\68\173\184\81\69", "\50\32\204\214")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\181\66\33\109\186\31\129\84", "\113\230\39\85\25\211")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\168\3\196\46\218\190\66\218\150\7\239\42\202\159\68\202\190\11", "\43\190\219\102\136\71\171\203")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\123\36\77\43\112\55\74", "\57\66\30\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\60\203\165\51\141\43\241\161\37\221\173\16\138\45\245\136", "\228\73\184\192\117\228\89\148")];
				v159 = 6;
			end
			if ((262 < 4193) and (0 == v159)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\13\92\251\130\164\15\91", "\235\202\104\40\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\152\30\154\5\138\18\183\1\130\28\177\25\133\18\183\10", "\217\109\235\123")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\20\140\106\66\121\222\202\174", "\221\71\233\30\54\16\176\173")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\239\91\154\53\238\74\183\37\233\95\180\49", "\223\84\156\62")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\249\246\201\190\53\209\239", "\91\182\156\130\189\215")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\96\169\112\127\97\184\93\109\123\163\86\117", "\53\30\19\204")];
				v159 = 1;
			end
			if ((2960 > 856) and (v159 == 1)) then
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\229\100\144\174\247\231\99", "\199\153\128\16\228")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\57\224\60\171\212\39\224\23\179\208\38\199\21\166\194\62", "\199\177\74\133\121")];
				UseFlameShock = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\204\168\234\62\200\45\171", "\74\216\169\220\158\87\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\48\22\10\86\233\46\22\31\82\231\32\24", "\58\136\67\115\76")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\175\204\77\140\46\172\78", "\61\145\202\184\57\229\64\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\73\65\140\97\78\93\154\83\111\90\134\68\87", "\39\60\50\233")];
				v159 = 2;
			end
			if ((1388 == 1388) and (v159 == 2)) then
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\54\183\56\139\38\181\176", "\195\122\83\195\76\226\72\210")][LUAOBFUSACTOR_DECRYPT_STR_0("\241\199\62\215\34\225\242\46\236\56", "\65\132\180\91\158")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\121\197\58\12\114\214\61", "\78\101\28\177")][LUAOBFUSACTOR_DECRYPT_STR_0("\48\167\229\125\36\162\225\115\32\181\237", "\49\69\212\128")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\36\9\196\230\232\25\11\195", "\129\119\108\176\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\220\2\225\36\24\29\30\218\21\222\49", "\124\92\175\103\173\69\110")];
				v159 = 3;
			end
			if ((3933 > 416) and (v159 == 4)) then
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\253\162\164\251\119\2\189\165", "\214\174\199\208\143\30\108\218")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\151\14\153\177\89\202\68\26\129\14\186\160\68", "\41\113\228\107\202\197\54\184")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\136\44\72\115\131\63\79", "\60\26\237\88")][LUAOBFUSACTOR_DECRYPT_STR_0("\205\57\113\210\161\204\47\121\239\173\234\47\119\231\162\212", "\206\184\74\20\134")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\225\250\165\250\68\63\223", "\172\88\132\142\209\147\42\88")][LUAOBFUSACTOR_DECRYPT_STR_0("\146\153\201\58\51\244\174\136\132\233\3\53\253\191\137\158", "\222\231\234\172\109\86\149")];
				v159 = 5;
			end
		end
	end
	local function v133()
		local v160 = 0;
		while true do
			if ((v160 == 5) or (252 > 759)) then
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\61\88\91\61\113\222\58", "\185\73\88\44\47\84\31")][LUAOBFUSACTOR_DECRYPT_STR_0("\157\196\31\144\220\246\155\216\20\131\223\250\137\217\9\169\221\248\188\216\14\165\222\200\129\195\18\129\213\249\132\222\25\180\214\251", "\159\232\183\122\192\179")];
				break;
			end
			if ((745 <= 2549) and (v160 == 1)) then
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\118\113\157\152\49\41\66\103", "\71\37\20\233\236\88")][LUAOBFUSACTOR_DECRYPT_STR_0("\216\85\181\55\83\248\94\93\193\117\184\31\70\248", "\60\173\38\208\118\32\140\44")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\114\55\245\199\41\193\70\33", "\175\33\82\129\179\64")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\252\53\231\57\179\226\230\62\200\15\166\252\234\49\194\8\189\250\234\61", "\210\142\143\80\175\92")];
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\236\231\210\176\231\244\213", "\166\217\137\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\173\113\163\226\82\241\162\126\129\228\79\231\162\124\165\244\110\211", "\38\131\195\18\198\145")] or 0;
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\211\46\255\49\90\84\197", "\52\51\182\90\139\88")][LUAOBFUSACTOR_DECRYPT_STR_0("\247\183\211\226\80\226\171\209\235\100\227\176\212\230\77\245\188\247\245\76\227\169", "\35\150\217\176\135")] or 0;
				v160 = 2;
			end
			if ((2746 <= 4845) and (v160 == 2)) then
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\85\31\24\126\77\113\234", "\22\153\48\107\108\23\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\150\175\8\126\121\114\225\7\131\175\50\79", "\137\110\229\219\122\31\21\33")] or 0;
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\184\44\111\63\69\35\109", "\30\122\221\88\27\86\43\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\48\45\234\138\49\38\236\181\44\58\238\135\53\28\228\146\61\37\195\182", "\230\88\72\139")] or 0;
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\65\177\2\15\10\6\95\97", "\56\18\212\118\123\99\104")][LUAOBFUSACTOR_DECRYPT_STR_0("\22\236\249\223\214\208\25\218\236\193\218\223\19\221\247\199\218\211\57\251\247\198\207", "\190\126\137\152\179\191")] or 0;
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\27\7\102\223\163\78\47\17", "\32\72\98\18\171\202")][LUAOBFUSACTOR_DECRYPT_STR_0("\1\137\32\96\255\21\157\51\127\242\55\141\38\96\254\10\143", "\151\100\232\82\20")] or "";
				v160 = 3;
			end
			if ((2391 < 2591) and (v160 == 3)) then
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\76\220\226\28\118\215\241\27", "\104\31\185\150")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\176\226\226\238\200\205\193\219\180\242\195\232\216\229\205\239\188\231\227\238\194\231", "\160\188\217\147\151\135\172\128")] or "";
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\60\216\4\228\51\199\8\206", "\169\111\189\112\144\90")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\150\49\162\140\136\0\135\193\135", "\226\173\227\69\205\223\224\105")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\59\54\79\198\21\95\45", "\123\56\94\66\59\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\75\122\228\22\250\180\233\70", "\225\154\35\19\129\122\158")] or LUAOBFUSACTOR_DECRYPT_STR_0("\118\9\236\95\225\233\217\58\93\64\216\95\252\226\220\48", "\84\58\96\139\55\149\135\176");
				v96 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\32\58\183\20\71\193\57\0", "\94\115\95\195\96\46\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\75\78\62\49\1\2\164", "\128\35\43\95\93\78\77\231")];
				v160 = 4;
			end
			if ((v160 == 4) or (1195 >= 1319)) then
				v97 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\24\34\32\30\112\174\183", "\201\196\125\86\84\119\30")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\235\5\179\236\193\39\151\243", "\223\163\142\100")] or 0;
				v95 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\19\215\165\177\140\17\208", "\216\226\118\163\209")][LUAOBFUSACTOR_DECRYPT_STR_0("\171\227\30\49\66\98\56\187\196\26\19\80\117\43", "\95\222\144\123\97\55\16")];
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\129\174\87\234\23\131\169", "\131\121\228\218\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\195\39\34\117\30\216\222\49\4\74\11\208\194\43\21\78\18\205\216\3\7\127\23\208\211\54\4\125", "\123\185\176\66\97\25")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\10\13\69\28\33\95\34", "\81\168\111\121\49\117\79\56")][LUAOBFUSACTOR_DECRYPT_STR_0("\210\25\224\130\213\15\232\185\213\62\234\162\194\7\210\191\211\2\196\176\193\6\236\181\211\15\225", "\214\167\106\133")];
				v160 = 5;
			end
			if ((3414 > 2251) and (v160 == 0)) then
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\219\40\12\138\208\59\11", "\120\227\190\92")][LUAOBFUSACTOR_DECRYPT_STR_0("\40\79\26\76\42\82\221\209\53\89\30\105", "\130\93\60\127\27\67\60\185")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\123\55\44\90\233\77\122\91", "\29\40\82\88\46\128\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\46\86\209\62\0\168\58\70\221\9\14\170\15\74\192\24\12", "\216\91\37\180\125\97")];
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\115\8\215\94\43\113\15", "\55\69\22\124\163")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\192\89\220\215\100\94\240\125\193\79\252\208\99\93", "\148\24\179\60\136\191\17\48")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\129\47\237\180\255\188\45\234", "\150\210\74\153\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\219\61\171\123\121\177\240\220\42\139\121\93\161\234\204\57\132\118\127", "\212\131\168\88\234\21\26")];
				v160 = 1;
			end
		end
	end
	local function v134()
		local v161 = 0;
		while true do
			if ((2820 > 224) and (v161 == 0)) then
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\23\55\188\53\45\60\175\50", "\65\68\82\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\35\89\117\40\219\253\123\40\81\123\46\220\236\118\32\83\121", "\30\69\48\18\64\175\175")] or 0;
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\195\41\11\248\50\254\43\12", "\91\144\76\127\140")][LUAOBFUSACTOR_DECRYPT_STR_0("\201\6\82\36\193\168\192\192\244\63\79\53\219\137\193\197\238", "\176\128\104\38\65\179\218\181")];
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\193\214\1\217\202\197\6", "\117\176\164\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\173\204\17\245\200\107\145\210\17\223\212\117\157\245\13\249\206\124\136\203\22\228", "\25\228\162\101\144\186")];
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\123\51\173\26\251\234\79\37", "\132\40\86\217\110\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\87\197\51\185\181\97\233\78\106\255\47\174\162\96\244\81\114\207", "\62\30\171\71\220\199\19\156")];
				v161 = 1;
			end
			if ((v161 == 3) or (3759 < 1073)) then
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\161\243\174\220\220\167\225", "\146\209\196\135\218\181\178\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\37\53\130\29\68\175\62\36\140\31\85\143\29", "\199\77\80\227\113\48")] or 0;
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\58\74\217\35\49\89\222", "\173\74\95\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\206\28\93\58\194\9\187\246\22\72\63\196\9\148\246", "\220\166\121\60\86\171\103")] or 0;
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\218\7\41\164\50\196\29\250", "\122\137\98\93\208\91\170")][LUAOBFUSACTOR_DECRYPT_STR_0("\175\228\29\67\220\188\174\250\136\245\21\64\219\156\168\199\130", "\170\231\129\124\47\181\210\201")] or "";
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\190\46\36\3\36\140\168", "\74\235\219\90\80\106")][LUAOBFUSACTOR_DECRYPT_STR_0("\68\194\85\63\54\241\91\244\74\207\82\56\46\241\126", "\146\44\163\59\91\90\148\26")];
				v161 = 4;
			end
			if ((3858 >= 1776) and (v161 == 2)) then
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\234\45\19\228\244\215\47\20", "\157\185\72\103\144")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\161\131\116\163\180\77\160\189\115\188\185\122\151", "\209\57\211\234\26\200")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\50\203\178\149\89\220\6\221", "\178\97\174\198\225\48")][LUAOBFUSACTOR_DECRYPT_STR_0("\221\87\7\248\121\234\28\248\95\16\249\91\194", "\111\175\54\100\145\24\134")];
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\112\28\52\1\74\23\39\6", "\117\35\121\64")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\174\235\254\38\78\209\169\230\197\55\64\211\184", "\47\189\221\142\182\67")];
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\19\186\51\223\65\167\39\58", "\73\64\223\71\171\40\201\64")][LUAOBFUSACTOR_DECRYPT_STR_0("\31\158\193\113\165\124\6\132\202\94\144\114\30\132\203\87", "\29\106\237\164\57\192")];
				v161 = 3;
			end
			if ((3370 >= 3257) and (v161 == 1)) then
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\64\184\34\84\199\40\94", "\45\32\37\204\86\61\169\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\113\92\22\172\176\112\113\80\7\169\179\122\70", "\28\53\53\101\220\213")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\89\28\85\83\175\87\204", "\191\109\60\104\33\58\193\48")][LUAOBFUSACTOR_DECRYPT_STR_0("\163\222\11\247\130\219\58\242\129\209\11", "\135\231\183\120")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\15\88\240\60\20\174\245", "\201\134\106\44\132\85\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\35\31\114\11\19\5\198\40\51\24\100", "\67\86\108\23\95\97\108\168")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\61\88\30\173\42\210\67", "\48\196\88\44\106\196\68\181")][LUAOBFUSACTOR_DECRYPT_STR_0("\151\204\217\17\129\167\171\45\142\204", "\76\226\191\188\67\224\196\194")];
				v161 = 2;
			end
			if ((2429 > 1167) and (v161 == 4)) then
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\40\172\149\64\123\42\171", "\41\21\77\216\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\60\76\124\65\24\72\91\75\23\66\96\85\27\95\119\68\24", "\37\116\45\18")];
				break;
			end
		end
	end
	local function v135()
		local v162 = 0;
		while true do
			if ((3932 > 957) and (v162 == 3)) then
				v108 = v14:GetEnemiesInRange(40);
				v109 = v17:GetEnemiesInSplashRange(5);
				if ((644 == 644) and v31) then
					local v229 = 0;
					while true do
						if ((4771 == 4771) and (0 == v229)) then
							v110 = #v108;
							v111 = max(v17:GetEnemiesInSplashRangeCount(5), v110);
							break;
						end
					end
				else
					local v230 = 0;
					while true do
						if ((1164 > 1095) and (v230 == 0)) then
							v110 = 1;
							v111 = 1;
							break;
						end
					end
				end
				v162 = 4;
			end
			if ((v162 == 1) or (511 == 4655)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\240\81\165\167\202\236", "\203\175\159\54\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\116\193\26", "\162\27\174\121\91\58\47")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\231\202\24\242\51\220\192", "\185\179\165\127\149\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\80\122\202", "\119\49\21\175\148")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\186\17\90\33\76\153", "\149\55\213\118\61\77\41\234")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\2\217", "\123\125\102\170\166\137\89\207")];
				v162 = 2;
			end
			if ((3479 >= 2378) and (v162 == 2)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\122\15\95\58\2\134\186", "\201\46\96\56\93\110\227")][LUAOBFUSACTOR_DECRYPT_STR_0("\191\10\253\233\16\205", "\161\219\99\142\153\117")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\72\190\161\116\193\121\162", "\173\28\209\198\19")][LUAOBFUSACTOR_DECRYPT_STR_0("\120\229\185\178\118\232\164", "\219\21\140\215")];
				if ((2069 <= 4346) and v14:IsDeadOrGhost()) then
					return;
				end
				v162 = 3;
			end
			if ((4 == v162) or (124 > 191)) then
				if (v14:AffectingCombat() or v83 or (663 > 2245)) then
					local v231 = 0;
					local v232;
					while true do
						if ((v231 == 1) or (1608 == 1524)) then
							if ((581 <= 2774) and v29) then
								return v29;
							end
							break;
						end
						if ((3575 > 1313) and (v231 == 0)) then
							v232 = v83 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\180\195\166\86\91\189\245\183\81\90\177\210", "\56\40\216\166\199")]:IsReady() and v34;
							v29 = v102.FocusUnit(v232, v100, 20, nil, 25);
							v231 = 1;
						end
					end
				end
				if ((4581 >= 1179) and (v102.TargetIsValid() or v14:AffectingCombat())) then
					local v233 = 0;
					while true do
						if ((v233 == 0) or (4804 == 790)) then
							v104 = v10.BossFightRemains();
							v105 = v104;
							v233 = 1;
						end
						if ((v233 == 1) or (283 >= 2410)) then
							if ((2530 >= 1955) and (v105 == 11111)) then
								v105 = v10.FightRemains(v108, false);
							end
							break;
						end
					end
				end
				if ((1932 == 1932) and not v14:IsChanneling() and not v14:IsChanneling()) then
					local v234 = 0;
					while true do
						if ((889 <= 2417) and (v234 == 0)) then
							if (Focus or (1496 > 2249)) then
								if (v83 or (2981 <= 333)) then
									local v246 = 0;
									while true do
										if ((364 <= 4940) and (v246 == 0)) then
											v29 = v123();
											if ((2265 > 522) and v29) then
												return v29;
											end
											break;
										end
									end
								end
							end
							if ((4152 >= 1643) and v84) then
								local v242 = 0;
								while true do
									if ((2810 >= 2165) and (v242 == 1)) then
										if ((4693 > 2870) and v81) then
											local v247 = 0;
											while true do
												if ((357 <= 3812) and (v247 == 0)) then
													v29 = v102.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 30);
													if ((1186 == 1186) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										break;
									end
									if ((v242 == 0) or (586 == 611)) then
										if (v79 or (4778 < 99)) then
											local v248 = 0;
											while true do
												if ((0 == v248) or (2025 >= 4681)) then
													v29 = v102.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 40);
													if ((1561 < 2644) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										if ((44 <= 3142) and v80) then
											local v249 = 0;
											while true do
												if ((v249 == 0) or (1817 >= 4076)) then
													v29 = v102.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 30);
													if ((4522 >= 234) and v29) then
														return v29;
													end
													break;
												end
											end
										end
										v242 = 1;
									end
								end
							end
							v234 = 1;
						end
						if ((4624 > 1588) and (v234 == 1)) then
							if (v14:AffectingCombat() or (1101 >= 2067)) then
								local v243 = 0;
								while true do
									if ((v243 == 0) or (122 >= 2949)) then
										v29 = v131();
										if ((3995 == 3995) and v29) then
											return v29;
										end
										break;
									end
								end
							else
								local v244 = 0;
								while true do
									if ((v244 == 0) or (2388 <= 1882)) then
										v29 = v130();
										if (v29 or (3507 < 2485)) then
											return v29;
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
			if ((v162 == 0) or (933 >= 3101)) then
				v133();
				v132();
				v134();
				v162 = 1;
			end
		end
	end
	local function v136()
		local v163 = 0;
		while true do
			if ((1977 <= 3119) and (v163 == 1)) then
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\130\26\228\203\252\3\179\23\237\134\202\5\166\27\224\200\185\15\190\86\196\214\240\14\233\86\210\211\233\29\168\4\245\195\253\77\165\15\161\222\210\12\169\19\245\201\183", "\109\199\118\129\166\153"));
				break;
			end
			if ((2321 < 3422) and (v163 == 0)) then
				v98[LUAOBFUSACTOR_DECRYPT_STR_0("\0\184\20\34\35\135\29\32\37\191\49\42\36\161\19\41", "\79\70\212\117")]:RegisterAuraTracking();
				v103();
				v163 = 1;
			end
		end
	end
	v21.SetAPL(262, v135, v136);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\20\160\126\238\14\131\127\247\60\177\121\201\20\188\114\251\52\190\99\247\61\254\123\227\48", "\150\81\208\23")]();

