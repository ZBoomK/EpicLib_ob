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
		if ((1421 > 753) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (4876 < 4606)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (1442 > 2640)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\150\198\25\212\252\253\44\244\190\137\18\196\194", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\204\82\179", "\38\156\55\199")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\155\109\121\36\31", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\52\170\221\203\132\31\36\28\179\221", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = EpicLib;
	local v21 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\106\67\19\49", "\69\41\34\96")];
	local v22 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\140\209\210\25\17", "\75\220\163\183\106\98")];
	local v23 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\50\168\142\36\202\33\175\153\36\214\16", "\185\98\218\235\87")];
	local v24 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\230\61\36\244\209", "\202\171\92\71\134\190")];
	local v25 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\11\200\34\140", "\232\73\161\76")];
	local v26 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\252\39", "\167\214\137\74\171\120\206\83")];
	local v27 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\168\255\63\80\247\169\152", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\0\188\57\30\25\183\46", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\91\127\24", "\126\167\52\16\116\217")];
	local v28 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\197\47\56", "\156\168\78\64\224\212\121")];
	local v29 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\4\235\172\194", "\174\103\142\197")];
	local v30;
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
	local v87 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\123\41\88\61", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\205\252\89", "\60\180\164\142")];
	local v88 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\117\95\2\44", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\224\201\193", "\164\216\137\187")];
	local v89 = v24[LUAOBFUSACTOR_DECRYPT_STR_0("\255\231\54\183", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\7\144\195", "\202\88\110\226\166")];
	local v90 = {};
	local v91 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\224\0\143\250\197\205\28", "\170\163\111\226\151")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\38\183\42\87\56\39\20", "\73\113\80\210\88\46\87")];
	local function v92()
		if ((136 < 3668) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\179\41\192\29\241\132\15\216\0\244\132", "\135\225\76\173\114")]:IsAvailable()) then
			v91[LUAOBFUSACTOR_DECRYPT_STR_0("\62\228\171\160\169\177\171\27\239\180\181\136\184\165\15\235\190\163", "\199\122\141\216\208\204\221")] = v91[LUAOBFUSACTOR_DECRYPT_STR_0("\137\212\3\224\125\250\161\220\18\252\125\213\184\207\3\245\92\243\175\200\22\246\107", "\150\205\189\112\144\24")];
		end
	end
	v10:RegisterForEvent(function()
		v92();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\4\167\139\101\50\173\46\32\9\165\134\105\54\183\34\32\0\167\150\109\40\161\43\49\17\173\144\98\59\171\57\49\11\163\154\104", "\112\69\228\223\44\100\232\113"));
	local v93 = not v33;
	local v94 = v87[LUAOBFUSACTOR_DECRYPT_STR_0("\231\10\9\248\191\114\129\199\61\11\214\165\111\143\218\24", "\230\180\127\103\179\214\28")]:IsAvailable();
	local v95 = ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\170\9\94\75\225\113\225\152\6\87", "\128\236\101\63\38\132\33")]:IsAvailable()) and 4) or 999;
	local v96 = 999;
	local v97 = v95;
	local v98 = (3 * v26(v87[LUAOBFUSACTOR_DECRYPT_STR_0("\138\188\20\72\162\227\202\138\160\3\65", "\175\204\201\113\36\214\139")]:IsAvailable())) + (999 * v26(not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\97\217\48\208\16\79\201\19\213\22\66", "\100\39\172\85\188")]:IsAvailable()));
	local v99 = 999;
	local v100 = 40;
	local v101 = 999;
	local v102 = 0.3;
	local v103 = 0;
	local v104 = 6;
	local v105 = false;
	local v106 = (v105 and 20) or 0;
	local v107;
	local v108 = ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\134\113\183\132\63\164\118\190", "\83\205\24\217\224")]:IsAvailable()) and 0.4) or 1;
	local v109 = false;
	local v110 = false;
	local v111 = false;
	local v112 = 0;
	local v113 = 0;
	local v114 = 8;
	local v115 = 3;
	local v116;
	local v117;
	local v118;
	local v119 = 3;
	local v120 = 11111;
	local v121 = 11111;
	local v122;
	local v123, v124, v125;
	local v126;
	local v127;
	local v128;
	local v129;
	v10:RegisterForEvent(function()
		local v153 = 0;
		while true do
			if ((v153 == 0) or (1784 > 4781)) then
				v105 = false;
				v106 = (v105 and 20) or 0;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\214\233\236\4\195\247\242\24\215\240\228\13\203\224\227\9\217\230\229\28\200\226\232\25", "\93\134\165\173"));
	v10:RegisterForEvent(function()
		local v154 = 0;
		while true do
			if ((4585 > 3298) and (v154 == 1)) then
				v87[LUAOBFUSACTOR_DECRYPT_STR_0("\117\37\103\249\85\82", "\32\56\64\19\156\58")]:RegisterInFlightEffect(351140);
				v87[LUAOBFUSACTOR_DECRYPT_STR_0("\119\205\241\83\85\224", "\224\58\168\133\54\58\146")]:RegisterInFlight();
				v154 = 2;
			end
			if ((v154 == 2) or (1664 > 1698)) then
				v87[LUAOBFUSACTOR_DECRYPT_STR_0("\105\94\68\248\123\143\159\45\85\87\70\248\102", "\107\57\54\43\157\21\230\231")]:RegisterInFlightEffect(257542);
				v87[LUAOBFUSACTOR_DECRYPT_STR_0("\235\131\30\240\183\213\215\253\135\16\248\188\207", "\175\187\235\113\149\217\188")]:RegisterInFlight();
				v154 = 3;
			end
			if ((v154 == 3) or (3427 < 2849)) then
				v87[LUAOBFUSACTOR_DECRYPT_STR_0("\12\182\147\67\225\117\121\47\187", "\24\92\207\225\44\131\25")]:RegisterInFlight(v87.CombustionBuff);
				v87[LUAOBFUSACTOR_DECRYPT_STR_0("\109\218\170\73\25\124\71\223", "\29\43\179\216\44\123")]:RegisterInFlight(v87.CombustionBuff);
				break;
			end
			if ((3616 <= 4429) and (v154 == 0)) then
				v87[LUAOBFUSACTOR_DECRYPT_STR_0("\142\235\211\205\56\194\179\109\170", "\30\222\146\161\162\90\174\210")]:RegisterInFlight();
				v87[LUAOBFUSACTOR_DECRYPT_STR_0("\195\71\98\15\231\79\124\6", "\106\133\46\16")]:RegisterInFlight();
				v154 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\145\252\1\126\147\252\4\115\142\233\5\96\145\230\9\98\130\237\1\110", "\44\221\185\64"));
	v87[LUAOBFUSACTOR_DECRYPT_STR_0("\49\254\90\80\113\13\230\91\75", "\19\97\135\40\63")]:RegisterInFlight();
	v87[LUAOBFUSACTOR_DECRYPT_STR_0("\136\85\33\62\45\48\162\80", "\81\206\60\83\91\79")]:RegisterInFlight();
	v87[LUAOBFUSACTOR_DECRYPT_STR_0("\99\174\196\119\32\209", "\196\46\203\176\18\79\163\45")]:RegisterInFlightEffect(351140);
	v87[LUAOBFUSACTOR_DECRYPT_STR_0("\149\39\106\27\43\233", "\143\216\66\30\126\68\155")]:RegisterInFlight();
	v87[LUAOBFUSACTOR_DECRYPT_STR_0("\154\192\2\206\203\170\207\199\166\201\0\206\214", "\129\202\168\109\171\165\195\183")]:RegisterInFlightEffect(257542);
	v87[LUAOBFUSACTOR_DECRYPT_STR_0("\18\80\56\221\208\29\254\4\84\54\213\219\7", "\134\66\56\87\184\190\116")]:RegisterInFlight();
	v87[LUAOBFUSACTOR_DECRYPT_STR_0("\12\40\27\180\27\231\32\38\40", "\85\92\81\105\219\121\139\65")]:RegisterInFlight(v87.CombustionBuff);
	v87[LUAOBFUSACTOR_DECRYPT_STR_0("\219\186\66\64\126\222\241\191", "\191\157\211\48\37\28")]:RegisterInFlight(v87.CombustionBuff);
	v10:RegisterForEvent(function()
		local v155 = 0;
		while true do
			if ((3988 >= 66) and (0 == v155)) then
				v120 = 11111;
				v121 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\239\51\213\37\31\237\32\198\57\29\250\49\203\57\20\254\61\216\57\30", "\90\191\127\148\124"));
	v10:RegisterForEvent(function()
		local v156 = 0;
		while true do
			if ((v156 == 1) or (862 > 4644)) then
				v97 = v95;
				v108 = ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\17\31\250\177\54\31\250\178", "\213\90\118\148")]:IsAvailable()) and 0.4) or 1;
				break;
			end
			if ((1221 == 1221) and (v156 == 0)) then
				v94 = v87[LUAOBFUSACTOR_DECRYPT_STR_0("\75\146\32\60\113\137\41\4\90\139\43\4\107\142\32\16", "\119\24\231\78")]:IsAvailable();
				v95 = ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\164\33\164\71\217\112\16\150\46\173", "\113\226\77\197\42\188\32")]:IsAvailable()) and 3) or 999;
				v156 = 1;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\104\30\145\122\97\104\17\151\126\108\117\9\145\114", "\45\59\78\212\54"), LUAOBFUSACTOR_DECRYPT_STR_0("\60\115\162\185\168\11\137\207\35\102\166\167\170\17\132\222\47\98\162\169", "\144\112\54\227\235\230\78\205"));
	local function v130()
		return v87[LUAOBFUSACTOR_DECRYPT_STR_0("\149\33\29\249\195\79\178\58\27\249\194", "\59\211\72\111\156\176")]:IsAvailable() and (v15:HealthPercentage() > 90);
	end
	local function v131()
		return (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\104\142\241\40\93\147\226\63\90\130\241", "\77\46\231\131")]:IsAvailable() and (((v15:HealthPercentage() > 90) and v15:TimeToX(90)) or 0)) or 0;
	end
	local function v132()
		return v87[LUAOBFUSACTOR_DECRYPT_STR_0("\137\81\183\82\179\90\177\116\181\65\181\72", "\32\218\52\214")]:IsAvailable() and (v15:HealthPercentage() < 30);
	end
	local function v133()
		return v87[LUAOBFUSACTOR_DECRYPT_STR_0("\103\26\33\186\254\166\64\94\125\20\62\186\242\184", "\58\46\119\81\200\145\208\37")]:IsAvailable() and (v15:HealthPercentage() < 30);
	end
	local function v134()
		return (v119 * v87[LUAOBFUSACTOR_DECRYPT_STR_0("\24\132\57\170\189\180\56\44\188\63\187\172\175", "\86\75\236\80\204\201\221")]:BaseDuration()) / v87[LUAOBFUSACTOR_DECRYPT_STR_0("\65\73\126\131\234\130\124\70\71\138\233\142\96", "\235\18\33\23\229\158")]:BaseTickTime();
	end
	local function v135()
		local v157 = 0;
		local v158;
		while true do
			if ((v157 == 0) or (45 > 1271)) then
				v158 = (v130() and (v26(v87[LUAOBFUSACTOR_DECRYPT_STR_0("\96\163\211\180\82\182\192\168\68", "\219\48\218\161")]:InFlight()) + v26(v87[LUAOBFUSACTOR_DECRYPT_STR_0("\194\120\110\76\217\78\236\232", "\128\132\17\28\41\187\47")]:InFlight()))) or 0;
				v158 = v158 + v26(v87[LUAOBFUSACTOR_DECRYPT_STR_0("\49\58\9\63\83\8\42\32\54\92\12\55\21", "\61\97\82\102\90")]:InFlight() or v14:PrevGCDP(1, v87.PhoenixFlames));
				v157 = 1;
			end
			if ((3877 > 1530) and (v157 == 1)) then
				return v14:BuffUp(v87.HotStreakBuff) or v14:BuffUp(v87.HyperthermiaBuff) or (v14:BuffUp(v87.HeatingUpBuff) and ((v133() and v14:IsCasting(v87.Scorch)) or (v130() and (v14:IsCasting(v87.Fireball) or v14:IsCasting(v87.Pyroblast) or (v158 > 0)))));
			end
		end
	end
	local function v136(v159)
		local v160 = 0;
		local v161;
		while true do
			if ((v160 == 0) or (4798 == 1255)) then
				v161 = 0;
				for v228, v229 in pairs(v159) do
					if (v229:DebuffUp(v87.IgniteDebuff) or (2541 > 2860)) then
						v161 = v161 + 1;
					end
				end
				v160 = 1;
			end
			if ((1 == v160) or (2902 > 3629)) then
				return v161;
			end
		end
	end
	local function v137()
		local v162 = 0;
		local v163;
		while true do
			if ((427 < 3468) and (1 == v162)) then
				return v163;
			end
			if ((4190 >= 2804) and (v162 == 0)) then
				v163 = 0;
				if ((2086 == 2086) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\138\39\185\78\197\86\18\5", "\105\204\78\203\43\167\55\126")]:InFlight() or v87[LUAOBFUSACTOR_DECRYPT_STR_0("\149\162\44\27\29\13\223\119\169\171\46\27\0", "\49\197\202\67\126\115\100\167")]:InFlight())) then
					v163 = v163 + 1;
				end
				v162 = 1;
			end
		end
	end
	local function v138()
		local v164 = 0;
		while true do
			if ((4148 > 2733) and (v164 == 0)) then
				v30 = v91.HandleTopTrinket(v90, v33, 40, nil);
				if ((3054 >= 1605) and v30) then
					return v30;
				end
				v164 = 1;
			end
			if ((1044 < 1519) and (v164 == 1)) then
				v30 = v91.HandleBottomTrinket(v90, v33, 40, nil);
				if ((1707 <= 4200) and v30) then
					return v30;
				end
				break;
			end
		end
	end
	local function v139()
		if ((580 == 580) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\5\94\210\38\150\83\125\34\73\204\44", "\62\87\59\191\73\224\54")]:IsReady() and v34 and v91.DispellableFriendlyUnit(20)) then
			if ((601 <= 999) and v22(v89.RemoveCurseFocus)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\245\7\247\198\241\7\197\202\242\16\233\204\167\6\243\218\247\7\246", "\169\135\98\154");
			end
		end
	end
	local function v140()
		local v165 = 0;
		while true do
			if ((3970 == 3970) and (v165 == 2)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\168\187\33\25\71\92\160\136\179\52\14", "\233\229\210\83\107\40\46")]:IsCastable() and v57 and (v14:HealthPercentage() <= v64)) or (98 == 208)) then
					if ((2006 <= 3914) and v22(v87.MirrorImage)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\75\32\196\10\211\125\59\219\4\198\71\114\210\0\199\71\60\197\12\215\71\114\130", "\101\161\34\82\182");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\207\31\92\255\207\231\144\7\230\27\80\237\210\224\139\34\225\25\64", "\78\136\109\57\158\187\130\226")]:IsReady() and v54 and (v14:HealthPercentage() <= v61)) or (3101 <= 2971)) then
					if (v22(v87.GreaterInvisibility) or (2073 <= 671)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\45\252\240\42\58\235\206\55\49\239\248\45\54\251\248\50\54\237\232\126\59\252\247\59\49\234\248\40\58\185\164", "\145\94\95\153");
					end
				end
				v165 = 3;
			end
			if ((3305 > 95) and (v165 == 4)) then
				if ((2727 == 2727) and v74 and (v14:HealthPercentage() <= v76)) then
					local v230 = 0;
					while true do
						if ((v230 == 0) or (2970 >= 4072)) then
							if ((3881 > 814) and (v78 == LUAOBFUSACTOR_DECRYPT_STR_0("\3\135\122\174\52\145\116\181\63\133\60\148\52\131\112\181\63\133\60\140\62\150\117\179\63", "\220\81\226\28"))) then
								if (v88[LUAOBFUSACTOR_DECRYPT_STR_0("\33\208\132\233\239\212\27\220\140\252\194\194\18\217\139\245\237\247\28\193\139\244\228", "\167\115\181\226\155\138")]:IsReady() or (4932 < 4868)) then
									if ((3667 <= 4802) and v22(v89.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\240\39\225\78\126\98\206\235\44\224\28\115\116\199\238\43\233\91\59\97\201\246\43\232\82\59\117\195\228\39\233\79\114\103\195", "\166\130\66\135\60\27\17");
									end
								end
							end
							if ((1260 >= 858) and (v78 == "Dreamwalker's Healing Potion")) then
								if (v88[LUAOBFUSACTOR_DECRYPT_STR_0("\96\88\203\116\61\83\75\194\126\53\86\89\230\112\49\72\67\192\114\0\75\94\199\122\62", "\80\36\42\174\21")]:IsReady() or (3911 == 4700)) then
									if ((3000 < 4194) and v22(v89.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\74\2\50\123\67\7\54\118\69\21\37\105\14\24\50\123\66\25\57\125\14\0\56\110\71\31\57\58\74\21\49\127\64\3\62\108\75", "\26\46\112\87");
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((651 < 4442) and (v165 == 0)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\233\123\37\78\244\61\207\233\118\54\70\244\54\218", "\168\171\23\68\52\157\83")]:IsCastable() and v53 and v14:BuffDown(v87.BlazingBarrier) and (v14:HealthPercentage() <= v60)) or (195 >= 1804)) then
					if (v22(v87.BlazingBarrier) or (1382 > 2216)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\125\244\183\44\35\128\203\115\244\191\55\36\130\230\49\241\168\35\40\137\231\120\227\168\101\124", "\231\148\17\149\205\69\77");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\173\166\212\232\117\254\146\181\206\254\69", "\159\224\199\167\155\55")]:IsCastable() and v58 and v14:BuffDown(v87.BlazingBarrier) and v91.AreUnitsBelowHealthPercentage(v65, 2)) or (2861 == 2459)) then
					if ((1903 < 4021) and v22(v87.MassBarrier)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\242\47\193\200\241\61\192\229\250\57\192\183\247\57\212\242\253\47\219\225\246\124\128", "\178\151\147\92");
					end
				end
				v165 = 1;
			end
			if ((v165 == 3) or (2270 >= 4130)) then
				if ((2593 <= 3958) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\220\193\0\208\92\131\244\192\17", "\215\157\173\116\181\46")]:IsReady() and v52 and (v14:HealthPercentage() <= v59)) then
					if ((1176 == 1176) and v22(v87.AlterTime)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\184\159\247\200\10\160\130\255\223\117\176\142\244\223\59\167\130\228\223\117\226", "\186\85\212\235\146");
					end
				end
				if ((v88[LUAOBFUSACTOR_DECRYPT_STR_0("\234\132\23\242\45\230\75\214\142\24\251", "\56\162\225\118\158\89\142")]:IsReady() and v75 and (v14:HealthPercentage() <= v77)) or (3062 == 1818)) then
					if (v22(v89.Healthstone) or (3717 < 3149)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\0\193\163\54\208\79\17\207\161\39\152\88\0\198\170\44\203\85\19\197", "\184\60\101\160\207\66");
					end
				end
				v165 = 4;
			end
			if ((3195 < 3730) and (v165 == 1)) then
				if ((2797 <= 3980) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\165\254\73\16\30\67\121\135", "\26\236\157\44\82\114\44")]:IsCastable() and v55 and (v14:HealthPercentage() <= v62)) then
					if ((1944 <= 2368) and v22(v87.IceBlock)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\45\208\100\40\34\218\88\33\110\209\94\44\43\219\72\35\56\208\27\121", "\59\74\78\181");
					end
				end
				if ((1709 < 4248) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\12\210\95\121\188\41\213\110\91\191\32\223\78", "\211\69\177\58\58")]:IsAvailable() and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\158\230\124\214\230\199\179\196\123\252\229\194\163\252", "\171\215\133\25\149\137")]:IsCastable() and v56 and (v14:HealthPercentage() <= v63)) then
					if (v22(v87.IceColdAbility) or (3970 == 3202)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\232\203\55\197\236\63\240\70\161\204\55\252\234\62\239\75\247\205\114\169", "\34\129\168\82\154\143\80\156");
					end
				end
				v165 = 2;
			end
		end
	end
	local function v141()
		local v166 = 0;
		while true do
			if ((v166 == 1) or (3918 >= 4397)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\34\228\39\59\116\30\252\38\32", "\22\114\157\85\84")]:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast)) or (780 == 3185)) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true) or (3202 >= 4075)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\212\210\1\203\95\250\169\215\223\83\212\79\243\171\203\198\17\197\73\182\252", "\200\164\171\115\164\61\150");
					end
				end
				if ((64 == 64) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\152\253\17\64\129\191\248\15", "\227\222\148\99\37")]:IsReady() and v39) then
					if ((2202 >= 694) and v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\91\64\243\251\50\94\94\182\233\33\87\81\249\244\49\83\70\182\175", "\153\83\50\50\150");
					end
				end
				break;
			end
			if ((3706 <= 3900) and (v166 == 0)) then
				if ((2890 > 2617) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\152\49\168\117\177\186\108\186\173\38\167\120\186\188\81", "\212\217\67\203\20\223\223\37")]:IsCastable() and v36 and (v14:BuffDown(v87.ArcaneIntellect, true) or v91.GroupBuffMissing(v87.ArcaneIntellect))) then
					if (v22(v87.ArcaneIntellect) or (3355 > 4385)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\187\159\171\211\180\136\151\219\180\153\173\222\182\136\171\198\250\157\186\215\185\130\165\208\187\153\232\128", "\178\218\237\200");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\155\188\244\194\185\167\207\221\183\178\227", "\176\214\213\134")]:IsCastable() and v91.TargetIsValid() and v57 and v83) or (3067 <= 2195)) then
					if ((3025 >= 2813) and v22(v87.MirrorImage)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\164\164\198\167\68\102\253\160\183\211\173\22\73\230\168\181\219\165\84\88\224\237\228", "\57\148\205\214\180\200\54");
					end
				end
				v166 = 1;
			end
		end
	end
	local function v142()
		local v167 = 0;
		while true do
			if ((2412 >= 356) and (v167 == 1)) then
				if ((2070 > 1171) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\9\220\94\236\73\193\147\15\220\90\234\82\199", "\224\77\174\63\139\38\175")]:IsReady() and v37 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\165\77\93\54\151\85\74\47\151\91\89\61\162\84\74\55", "\78\228\33\56")]:IsAvailable() and v117 and v14:BuffDown(v87.HotStreakBuff) and (v14:BuffUp(v87.FeeltheBurnBuff) or (v10.CombatTime() > 15)) and not v133() and (v131() == 0) and not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\250\123\191\19\128\220\123\182\37\137\207\115\183\16", "\229\174\30\210\99")]:IsAvailable()) then
					if (v22(v87.DragonsBreath) or (4108 < 3934)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\255\135\86\226\51\42\36\239\148\84\236\41\49\91\236\133\69\228\43\60\36\249\135\93\232\51\45\8\173\208", "\89\123\141\230\49\141\93");
					end
				end
				if ((3499 >= 3439) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\215\99\247\11\31\68\224\83\228\9\17\94\251", "\42\147\17\150\108\112")]:IsReady() and v37 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\46\170\40\103\244\252\29\167\62\101\230\251\41\179\63\102", "\136\111\198\77\31\135")]:IsAvailable() and v117 and v14:BuffDown(v87.HotStreakBuff) and (v14:BuffUp(v87.FeeltheBurnBuff) or (v10.CombatTime() > 15)) and not v133() and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\54\12\170\70\184\246\18\173\36\5\166\91\184\247", "\201\98\105\199\54\221\132\119")]:IsAvailable()) then
					if ((876 < 3303) and v22(v87.DragonsBreath)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\189\30\130\38\13\59\191\134\14\145\36\3\33\164\249\13\128\53\11\35\169\134\24\130\45\7\59\184\170\76\219", "\204\217\108\227\65\98\85");
					end
				end
				break;
			end
			if ((2922 <= 3562) and (v167 == 0)) then
				if ((2619 >= 1322) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\113\127\101\21\125\172\111\82\123\113", "\45\61\22\19\124\19\203")]:IsReady() and v41 and (v124 > 1) and v117 and ((v107 > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\237\27\27\252\12\119\155\206\31\15", "\217\161\114\109\149\98\16")]:CooldownRemains()) or (v107 <= 0))) then
					if ((4133 >= 2404) and v22(v87.LivingBomb, not v15:IsSpellInRange(v87.LivingBomb))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\30\41\46\117\178\115\45\34\55\113\190\52\19\35\44\117\170\113\45\52\57\112\185\122\6\51\120\46", "\20\114\64\88\28\220");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\28\4\198\177\247\194", "\221\81\97\178\212\152\176")]:IsReady() and v42 and (v73 < v121) and ((v107 <= 0) or (v14:BuffRemains(v87.CombustionBuff) > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\224\226\9\254\21\223", "\122\173\135\125\155")]:TravelTime()) or (not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\183\212\14\146\54\63\207\151\227\12\188\44\34\193\138\198", "\168\228\161\96\217\95\81")]:IsAvailable() and ((45 < v107) or (v121 < v107))))) or (1433 == 2686)) then
					if (v22(v89.MeteorCursor, not v15:IsInRange(40)) or (4123 == 4457)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\212\58\89\32\69\155\208\45\72\38\65\222\238\58\93\35\82\213\197\61\28\123", "\55\187\177\78\60\79");
					end
				end
				v167 = 1;
			end
		end
	end
	local function v143()
		local v168 = 0;
		local v169;
		while true do
			if ((v168 == 1) or (3972 <= 205)) then
				if ((v79 and ((v82 and v33) or not v82) and (v73 < v121)) or (3766 < 1004)) then
					local v231 = 0;
					while true do
						if ((1784 < 2184) and (v231 == 0)) then
							if (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\124\207\250\234\40\230\75\209\236", "\160\62\163\149\133\76")]:IsCastable() or (1649 > 4231)) then
								if ((3193 == 3193) and v22(v87.BloodFury)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\212\172\2\32\199\233\166\24\61\218\150\163\2\34\193\195\179\25\38\204\216\159\14\32\204\218\164\2\56\205\197\224\89", "\163\182\192\109\79");
								end
							end
							if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\22\35\18\211\240\38\45\9\206\242", "\149\84\70\96\160")]:IsCastable() and v116) or (3495 > 4306)) then
								if ((4001 > 3798) and v22(v87.Berserking)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\58\3\31\254\61\20\6\228\54\1\77\238\55\11\15\248\43\18\4\226\54\57\14\226\55\10\9\226\47\8\30\173\110", "\141\88\102\109");
								end
							end
							v231 = 1;
						end
						if ((v231 == 1) or (4688 <= 4499)) then
							if (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\149\90\216\117\24\49\90\206\183", "\161\211\51\170\16\122\93\53")]:IsCastable() or (1567 <= 319)) then
								if (v22(v87.Fireblood) or (4583 == 3761)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\253\167\160\45\249\162\189\39\255\238\177\39\246\172\167\59\239\167\189\38\196\173\189\39\247\170\189\63\245\189\242\112", "\72\155\206\210");
								end
							end
							if ((3454 > 1580) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\103\116\87\11\32\82\104\85\2\16\71\118\88", "\83\38\26\52\110")]:IsCastable()) then
								if (v22(v87.AncestralCall) or (1607 == 20)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\89\25\36\67\75\3\53\71\84\40\36\71\84\27\103\69\87\26\37\83\75\3\46\73\86\40\36\73\87\27\35\73\79\25\52\6\9\71", "\38\56\119\71");
								end
							end
							break;
						end
					end
				end
				if ((v85 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\199\230\85\211\18\87\225\255", "\54\147\143\56\182\69")]:IsReady() and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\226\132\242\89\208\196\128\243\126\222\196\145", "\191\182\225\159\41")]:IsAvailable() and v14:BloodlustExhaustUp()) or (962 >= 4666)) then
					if (v22(v87.TimeWarp, nil, nil, true) or (1896 == 1708)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\27\37\80\180\144\195\57\2\104\86\132\138\192\62\1\60\92\132\137\253\40\29\39\89\143\136\213\37\1\104\4\217", "\162\75\114\72\53\235\231");
					end
				end
				v168 = 2;
			end
			if ((3985 >= 1284) and (v168 == 0)) then
				v169 = v91.HandleDPSPotion(v14:BuffUp(v87.CombustionBuff));
				if (v169 or (1987 == 545)) then
					return v169;
				end
				v168 = 1;
			end
			if ((v168 == 2) or (4896 < 1261)) then
				if ((23 < 3610) and (v73 < v121)) then
					if ((v80 and ((v33 and v81) or not v81)) or (3911 < 2578)) then
						local v241 = 0;
						while true do
							if ((v241 == 0) or (4238 < 87)) then
								v30 = v138();
								if ((2538 == 2538) and v30) then
									return v30;
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
	local function v144()
		local v170 = 0;
		while true do
			if ((4122 == 4122) and (v170 == 0)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\160\53\67\234\71\17\166\41\64\229\94\7\130\40", "\98\236\92\36\130\51")]:IsCastable() and v79 and ((v82 and v33) or not v82) and (v73 < v121) and v117) or (2371 > 2654)) then
					if (v22(v87.LightsJudgment, not v15:IsSpellInRange(v87.LightsJudgment)) or (3466 > 4520)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\16\11\178\81\187\138\58\177\29\11\183\64\166\161\112\167\22\1\184\80\187\161\57\171\23\51\170\77\169\166\53\228\75", "\80\196\121\108\218\37\200\213");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\34\114\5\112\77\58\152\9\112\9\108", "\234\96\19\98\31\43\110")]:IsCastable() and v79 and ((v82 and v33) or not v82) and (v73 < v121) and v117) or (951 >= 1027)) then
					if (v22(v87.BagofTricks) or (1369 > 2250)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\4\30\85\248\163\116\180\18\13\91\196\167\97\203\5\16\95\197\185\97\159\15\16\92\248\188\122\138\21\26\18\147", "\235\102\127\50\167\204\18");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\124\168\227\42\74\41\114\174\248\33", "\78\48\193\149\67\36")]:IsReady() and v32 and v41 and (v124 > 1) and v117) or (937 > 3786)) then
					if (v22(v87.LivingBomb, not v15:IsSpellInRange(v87.LivingBomb)) or (901 > 4218)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\23\150\17\79\55\33\130\23\76\50\94\131\23\76\50\11\147\12\72\63\16\191\8\73\49\13\133\88\23", "\33\80\126\224\120");
					end
				end
				if ((4779 > 4047) and ((v14:BuffRemains(v87.CombustionBuff) > v104) or (v121 < 20))) then
					local v232 = 0;
					while true do
						if ((4050 > 1373) and (v232 == 0)) then
							v30 = v143();
							if (v30 or (1037 > 4390)) then
								return v30;
							end
							break;
						end
					end
				end
				v170 = 1;
			end
			if ((1407 <= 1919) and (v170 == 2)) then
				if ((2526 >= 1717) and v32 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\213\15\40\29\135\75\12\100\250\8\44", "\22\147\99\73\112\226\56\120")]:IsReady() and v40 and not v14:IsCasting(v87.Flamestrike) and v117 and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\158\121\227\248\136\171\97\240\252\134\189", "\237\216\21\130\149")]:CastTime()) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\161\65\82\93\165\218\74\139\65\81", "\62\226\46\63\63\208\169")]:CooldownRemains() < v87[LUAOBFUSACTOR_DECRYPT_STR_0("\195\21\84\142\26\30\59\76\236\18\80", "\62\133\121\53\227\127\109\79")]:CastTime()) and (v123 >= v98)) then
					if (v22(v89.FlamestrikeCursor, not v15:IsInRange(40)) or (3620 <= 2094)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\24\51\248\211\189\182\2\29\57\240\150\173\173\29\22\39\230\194\167\173\30\43\34\253\215\189\167\80\69\96", "\194\112\116\82\149\182\206");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\9\177\94\23\194\238\15\42\188", "\110\89\200\44\120\160\130")]:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast) and v117 and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\155\218\89\73\65\70\58\94\191", "\45\203\163\43\38\35\42\91")]:CastTime())) or (1723 >= 2447)) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast)) or (1199 > 3543)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\194\156\206\44\133\165\85\193\145\156\32\136\164\86\199\150\200\42\136\167\107\194\141\221\48\130\233\5\134", "\52\178\229\188\67\231\201");
					end
				end
				if ((1617 < 3271) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\7\72\66\1\245\93\47\45", "\67\65\33\48\100\151\60")]:IsReady() and v39 and v117 and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\252\232\163\218\230\204\243\167\215\253", "\147\191\135\206\184")]:CooldownRemains() < v87[LUAOBFUSACTOR_DECRYPT_STR_0("\162\33\180\196\218\82\190\136", "\210\228\72\198\161\184\51")]:CastTime()) and (v123 < 2) and not v133()) then
					if ((3085 > 1166) and v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\64\225\21\113\207\58\69\179\19\124\195\52\92\224\4\122\193\56\118\227\24\114\221\51\9\162\70", "\174\86\41\147\112\19");
					end
				end
				if ((4493 >= 3603) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\104\3\130\25\38\7", "\203\59\96\237\107\69\111\113")]:IsReady() and v45 and v117 and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\7\25\161\227\36\227\195\45\25\162", "\183\68\118\204\129\81\144")]:CooldownRemains() < v87[LUAOBFUSACTOR_DECRYPT_STR_0("\61\174\127\246\8\138", "\226\110\205\16\132\107")]:CastTime())) then
					if ((2843 <= 2975) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\192\239\203\66\227\131\227\214\76\233\214\243\205\72\228\205\223\201\73\234\208\229\153\16\179", "\33\139\163\128\185");
					end
				end
				v170 = 3;
			end
			if ((v170 == 5) or (1989 <= 174)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\32\175\137\78\16\164", "\60\115\204\230")]:IsReady() and v45 and v133() and (v15:DebuffRemains(v87.ImprovedScorchDebuff) < (4 * v122)) and (v125 < v97)) or (209 > 2153)) then
					if (v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch)) or (2020 == 1974)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\244\57\228\98\228\50\171\115\232\55\233\101\244\46\226\127\233\5\251\120\230\41\238\48\180\108", "\16\135\90\139");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\100\124\9\54\64\93\96\114\120\7\62\75\71", "\24\52\20\102\83\46\52")]:IsCastable() and v43 and v14:HasTier(30, 2) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\244\39\46\33\1\205\55\7\40\14\201\42\50", "\111\164\79\65\68")]:TravelTime() < v14:BuffRemains(v87.CombustionBuff)) and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) < 2) and ((v15:DebuffRemains(v87.CharringEmbersDebuff) < (4 * v122)) or (v14:BuffStack(v87.FlamesFuryBuff) > 1) or v14:BuffUp(v87.FlamesFuryBuff))) or (1347 == 1360)) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or (4461 == 3572)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\209\140\219\32\227\222\230\133\210\47\231\195\202\195\221\33\231\196\204\144\202\39\229\200\230\147\214\47\249\195\153\208\134", "\138\166\185\227\190\78");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\237\125\215\50\80\34\21\199", "\121\171\20\165\87\50\67")]:IsReady() and v39 and (v14:BuffRemains(v87.CombustionBuff) > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\224\49\171\51\187\3\202\52", "\98\166\88\217\86\217")]:CastTime()) and v14:BuffUp(v87.FlameAccelerantBuff)) or (2872 == 318)) then
					if ((568 == 568) and v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\255\107\4\132\221\250\250\57\2\137\209\244\227\106\21\143\211\248\201\105\9\135\207\243\182\45\81", "\188\150\150\25\97\230");
					end
				end
				if ((4200 == 4200) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\234\129\80\7\2\228\194\175\83\3\1\232\201", "\141\186\233\63\98\108")]:IsCastable() and v43 and not v14:HasTier(30, 2) and not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\208\230\41\174\54\229\248\45\165\63\240\249\10\163\55\232", "\69\145\138\76\214")]:IsAvailable() and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\64\199\134\140\177\31\104\233\133\136\178\19\99", "\118\16\175\233\233\223")]:TravelTime() < v14:BuffRemains(v87.CombustionBuff)) and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) < 2)) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or (4285 < 1369)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\155\140\58\190\224\130\101\180\130\57\186\227\142\110\203\135\58\182\236\158\110\159\141\58\181\209\155\117\138\151\48\251\186\217", "\29\235\228\85\219\142\235");
					end
				end
				v170 = 6;
			end
			if ((v170 == 1) or (3520 > 4910)) then
				if ((2842 <= 4353) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\220\160\12\193\82\229\176\37\200\93\225\173\16", "\60\140\200\99\164")]:IsCastable() and v43 and v14:BuffDown(v87.CombustionBuff) and v14:HasTier(30, 2) and not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\183\252\11\35\172\142\236\34\42\163\138\241\23", "\194\231\148\100\70")]:InFlight() and (v15:DebuffRemains(v87.CharringEmbersDebuff) < (4 * v122)) and v14:BuffDown(v87.HotStreakBuff)) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or (3751 < 1643)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\86\68\206\166\248\193\94\115\199\175\247\197\67\95\129\160\249\197\68\89\210\183\255\199\72\115\209\171\247\219\67\12\153", "\168\38\44\161\195\150");
					end
				end
				v30 = v142();
				if (v30 or (4911 == 3534)) then
					return v30;
				end
				if ((3001 > 16) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\163\243\143\116\37\251\162\31\143\242", "\118\224\156\226\22\80\136\214")]:IsReady() and v48 and ((v50 and v33) or not v50) and (v73 < v121) and (v137() == 0) and v117 and (v107 <= 0) and ((v14:IsCasting(v87.Scorch) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\113\237\86\146\65\230", "\224\34\142\57")]:ExecuteRemains() < v102)) or (v14:IsCasting(v87.Fireball) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\248\174\215\216\113\240\81\2", "\110\190\199\165\189\19\145\61")]:ExecuteRemains() < v102)) or (v14:IsCasting(v87.Pyroblast) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\234\242\101\231\137\203\219\248\99", "\167\186\139\23\136\235")]:ExecuteRemains() < v102)) or (v14:IsCasting(v87.Flamestrike) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\60\185\137\0\31\166\156\31\19\190\141", "\109\122\213\232")]:ExecuteRemains() < v102)) or (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\195\242\182\53\225\229", "\80\142\151\194")]:InFlight() and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\46\195\99\73\12\212", "\44\99\166\23")]:InFlightRemains() < v102)))) then
					if ((2875 <= 3255) and v22(v87.Combustion, not v15:IsInRange(40), nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\127\248\36\52\38\183\104\254\38\56\115\167\115\250\43\35\32\176\117\248\39\9\35\172\125\228\44\118\98\244", "\196\28\151\73\86\83");
					end
				end
				v170 = 2;
			end
			if ((368 < 4254) and (4 == v170)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\147\85\147\19\190\3\162\95\149", "\111\195\44\225\124\220")]:IsReady() and v44 and v14:PrevGCDP(1, v87.Scorch) and v14:BuffUp(v87.HeatingUpBuff) and (v123 < v97) and v116) or (4841 <= 2203)) then
					if ((4661 > 616) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\200\95\18\124\169\167\217\85\20\51\168\164\213\68\21\96\191\162\215\72\63\99\163\170\203\67\64\33\243", "\203\184\38\96\19\203");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\10\123\112\71\218\48\125\126\113\193\46\118\107", "\174\89\19\25\33")]:IsReady() and v49 and ((v51 and v33) or not v51) and (v73 < v121) and v116 and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\9\27\64\75\213\139\10\60\6", "\107\79\114\50\46\151\231")]:Charges() == 0) and ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\9\174\186\44\132\48\175\230\53\167\184\44\153", "\160\89\198\213\73\234\89\215")]:Charges() < v87[LUAOBFUSACTOR_DECRYPT_STR_0("\120\121\187\251\203\65\105\146\242\196\69\116\167", "\165\40\17\212\158")]:MaxCharges()) or v87[LUAOBFUSACTOR_DECRYPT_STR_0("\196\213\13\43\53\241\203\9\32\60\228\202\46\38\52\252", "\70\133\185\104\83")]:IsAvailable()) and (v101 <= v123)) or (1943 == 2712)) then
					if ((4219 >= 39) and v22(v87.ShiftingPower, not v15:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\77\77\44\221\13\75\67\21\217\11\82\65\56\137\7\74\73\40\220\23\81\77\37\199\59\85\76\43\218\1\5\23\122", "\169\100\37\36\74");
					end
				end
				if ((3967 > 2289) and v32 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\38\139\163\93\5\148\182\66\9\140\167", "\48\96\231\194")]:IsReady() and v40 and not v14:IsCasting(v87.Flamestrike) and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\238\86\15\32\28\203\187\145\193\81\11", "\227\168\58\110\77\121\184\207")]:CastTime()) and (v123 >= v98)) then
					if (v22(v89.FlamestrikeCursor, not v15:IsInRange(40)) or (851 > 2987)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\125\48\190\77\180\200\101\183\114\55\186\0\178\212\124\167\110\47\171\73\190\213\78\181\115\61\172\69\241\136\35", "\197\27\92\223\32\209\187\17");
					end
				end
				if ((4893 >= 135) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\51\70\209\244\1\83\194\232\23", "\155\99\63\163")]:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast) and v14:BuffUp(v87.FuryoftheSunKingBuff) and (v14:BuffRemains(v87.FuryoftheSunKingBuff) > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\178\200\179\130\187\136\131\194\181", "\228\226\177\193\237\217")]:CastTime())) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast)) or (3084 > 3214)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\36\169\49\233\54\188\34\245\32\240\32\233\57\178\54\245\32\185\44\232\11\160\43\231\39\181\99\181\96", "\134\84\208\67");
					end
				end
				v170 = 5;
			end
			if ((v170 == 3) or (3426 < 2647)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\113\81\22\219\117\84\5\205\67", "\190\55\56\100")]:IsReady() and v38 and not v135() and not v111 and (not v133() or v14:IsCasting(v87.Scorch) or (v15:DebuffRemains(v87.ImprovedScorchDebuff) > (4 * v122))) and (v14:BuffDown(v87.FuryoftheSunKingBuff) or v14:IsCasting(v87.Pyroblast)) and v116 and v14:BuffDown(v87.HyperthermiaBuff) and v14:BuffDown(v87.HotStreakBuff) and ((v137() + (v26(v14:BuffUp(v87.HeatingUpBuff)) * v26(v14:GCDRemains() > 0))) < 2)) or (1576 == 4375)) then
					if (v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true) or (2920 < 2592)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\166\46\27\44\225\255\87\188\40\94\16\236\254\84\186\47\10\26\236\253\105\191\52\31\0\230\179\4\255", "\147\54\207\92\126\115\131");
					end
				end
				if ((v32 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\43\61\52\112\8\109\25\35\60\118\8", "\30\109\81\85\29\109")]:IsReady() and v40 and ((v14:BuffUp(v87.HotStreakBuff) and (v123 >= v97)) or (v14:BuffUp(v87.HyperthermiaBuff) and (v123 >= (v97 - v26(v87[LUAOBFUSACTOR_DECRYPT_STR_0("\215\104\68\179\36\202\244\250\99\89\191\55", "\156\159\17\52\214\86\190")]:IsAvailable())))))) or (1110 >= 2819)) then
					if ((1824 <= 2843) and v22(v89.FlamestrikeCursor, not v15:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\227\188\177\171\252\169\174\167\228\184\252\173\224\176\190\187\252\169\181\161\225\130\172\166\238\174\185\238\189\239", "\220\206\143\221");
					end
				end
				if ((3062 == 3062) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\182\100\63\24\218\192\211\149\105", "\178\230\29\77\119\184\172")]:IsReady() and v44 and (v14:BuffUp(v87.HyperthermiaBuff))) then
					if ((716 <= 4334) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\167\24\20\117\244\244\173\30\91\116\247\248\188\31\8\99\241\250\176\53\11\127\249\230\187\74\73\35", "\152\149\222\106\123\23");
					end
				end
				if ((1001 < 3034) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\237\63\228\76\183\209\39\229\87", "\213\189\70\150\35")]:IsReady() and v44 and v14:BuffUp(v87.HotStreakBuff) and v116) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast)) or (977 > 1857)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\76\102\7\77\89\117\27\91\21\119\7\66\87\97\27\91\92\123\6\112\69\124\9\92\80\52\90\25", "\104\47\53\20");
					end
				end
				v170 = 4;
			end
			if ((v170 == 6) or (868 > 897)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\14\215\181\207\116\70", "\50\93\180\218\189\23\46\71")]:IsReady() and v45 and (v14:BuffRemains(v87.CombustionBuff) > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\237\167\84\94\71\212", "\40\190\196\59\44\36\188")]:CastTime()) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\15\70\211\166\249\117", "\109\92\37\188\212\154\29")]:CastTime() >= v122)) or (1115 == 4717)) then
					if ((2740 < 4107) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\236\171\209\50\82\68\236\171\206\51\79\23\251\173\204\63\101\20\231\165\208\52\26\80\187", "\58\100\143\196\163\81");
					end
				end
				if ((284 < 700) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\60\75\49\166\61\72\233\2", "\110\122\34\67\195\95\41\133")]:IsReady() and v39 and (v14:BuffRemains(v87.CombustionBuff) > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\83\184\73\79\212\116\189\87", "\182\21\209\59\42")]:CastTime())) then
					if ((386 >= 137) and v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\94\215\24\35\191\187\91\133\30\46\179\181\66\214\9\40\177\185\104\213\21\32\173\178\23\145\75", "\222\215\55\165\125\65");
					end
				end
				if ((923 == 923) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\0\216\208\19\252\198\207\69\33\211", "\42\76\177\166\122\146\161\141")]:IsReady() and v41 and (v14:BuffRemains(v87.CombustionBuff) < v122) and (v124 > 1)) then
					if (v22(v87.LivingBomb, not v15:IsSpellInRange(v87.LivingBomb)) or (4173 == 359)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\131\19\199\119\113\154\136\10\195\123\54\166\133\8\204\108\101\177\131\10\192\70\102\173\139\22\203\57\34\253", "\22\197\234\101\174\25");
					end
				end
				break;
			end
		end
	end
	local function v145()
		local v171 = 0;
		while true do
			if ((1722 == 1722) and (v171 == 3)) then
				if (((v112 + (120 * (1 - ((0.4 + (0.2 * v26(v87[LUAOBFUSACTOR_DECRYPT_STR_0("\45\142\182\65\24\147\165\86\31\130\182", "\36\107\231\196")]:IsAvailable()))) * v26(v87[LUAOBFUSACTOR_DECRYPT_STR_0("\118\188\172\131\81\188\172\128", "\231\61\213\194")]:IsAvailable()))))) <= v107) or (v107 > (v121 - 20)) or (3994 <= 3820)) then
					v107 = v112;
				end
				break;
			end
			if ((1488 < 1641) and (v171 == 0)) then
				v112 = v87[LUAOBFUSACTOR_DECRYPT_STR_0("\14\59\168\222\99\188\195\143\34\58", "\230\77\84\197\188\22\207\183")]:CooldownRemains() * v108;
				v113 = ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\223\29\212\249\142\160\252\57", "\85\153\116\166\156\236\193\144")]:CastTime() * v26(v123 < v97)) + (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\130\236\76\190\225\19\176\242\68\184\225", "\96\196\128\45\211\132")]:CastTime() * v26(v123 >= v97))) - v102;
				v171 = 1;
			end
			if ((433 <= 2235) and (2 == v171)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\59\76\7\116\1\87\14\76\42\85\12\76\27\80\7\88", "\63\104\57\105")]:IsAvailable() and v130() and v14:BuffDown(v87.FuryoftheSunKingBuff)) or (1838 > 2471)) then
					v107 = v28((v114 - v14:BuffStack(v87.SunKingsBlessingBuff)) * 3 * v122, v107);
				end
				v107 = v28(v14:BuffRemains(v87.CombustionBuff), v107);
				v171 = 3;
			end
			if ((2444 < 3313) and (v171 == 1)) then
				v107 = v112;
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\19\132\105\90\193\187\181\202\33\136\105", "\184\85\237\27\63\178\207\212")]:IsAvailable() and not v94) or (3685 <= 185)) then
					v107 = v28(v131(), v107);
				end
				v171 = 2;
			end
		end
	end
	local function v146()
		local v172 = 0;
		while true do
			if ((738 <= 1959) and (0 == v172)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\47\164\47\118\43\161\60\96\29", "\19\105\205\93")]:IsReady() and v38 and not v135() and not v111 and v14:BuffDown(v87.HotStreakBuff) and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) == 1) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\154\0\215\135\43\160\6\217\177\48\190\13\204", "\95\201\104\190\225")]:CooldownUp() or (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\137\194\211\203\141\199\192\221\187", "\174\207\171\161")]:Charges() > 1) or (v14:BuffRemains(v87.FeeltheBurnBuff) < (2 * v122)))) or (1317 == 3093)) then
					if (v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true) or (2611 >= 4435)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\247\31\246\199\213\225\255\30\231\184\209\228\236\8\224\236\214\255\234\8\225\199\209\228\236\8\204\250\219\236\237\25\224\184\133", "\183\141\158\109\147\152");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\10\0\244\9\14\5\231\31\56", "\108\76\105\134")]:IsReady() and v38 and not v135() and not v111 and ((v26(v14:BuffUp(v87.HeatingUpBuff)) + v137()) == 1) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\216\205\184\231\218\226\203\182\209\193\252\192\163", "\174\139\165\209\129")]:CooldownUp() and (not v14:HasTier(30, 2) or (v15:DebuffRemains(v87.CharringEmbersDebuff) > (2 * v122)))) or (117 > 4925)) then
					if ((107 <= 4905) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\186\240\196\249\1\124\121\176\167\162\199\207\17\117\107\183\178\240\213\195\17\79\126\170\161\231\254\196\15\113\107\183\160\162\149", "\24\195\211\130\161\166\99\16");
					end
				end
				break;
			end
		end
	end
	local function v147()
		local v173 = 0;
		while true do
			if ((v173 == 2) or (1004 > 4035)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\222\181\247\134\76\208\246\155\244\130\79\220\253", "\185\142\221\152\227\34")]:IsCastable() and v43 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\121\201\82\226\80\39\229\89\214\77\251\80\21\226\74\220", "\151\56\165\55\154\35\83")]:IsAvailable() and (not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\134\70\0\226\180\75\0\204\181\81\11", "\142\192\35\101")]:IsAvailable() or (v14:BuffRemains(v87.FeeltheBurnBuff) < (2 * v122)))) or (2802 < 369)) then
					if ((1497 <= 2561) and v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\198\125\38\166\233\133\180\41\208\121\40\174\226\159\236\5\194\116\39\167\230\158\168\41\196\122\61\162\243\133\163\24\150\39\121", "\118\182\21\73\195\135\236\204");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\56\52\21\69\10\4\229\46\48\27\77\1\30", "\157\104\92\122\32\100\109")]:IsCastable() and v43 and v14:HasTier(30, 2) and (v15:DebuffRemains(v87.CharringEmbersDebuff) < (2 * v122)) and v14:BuffDown(v87.HotStreakBuff)) or (816 > 1712)) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or (2733 == 2971)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\179\174\192\207\51\46\149\148\165\170\206\199\56\52\205\184\183\167\193\206\60\53\137\148\177\169\219\203\41\46\130\165\227\244\158", "\203\195\198\175\170\93\71\237");
					end
				end
				if ((2599 < 4050) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\29\72\49\199\82\25", "\156\78\43\94\181\49\113")]:IsReady() and v45 and v133() and (v15:DebuffStack(v87.ImprovedScorchDebuff) < v115)) then
					if ((2034 == 2034) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\97\235\203\177\8\75\57\97\252\197\173\15\66\107\118\215\214\172\31\66\109\123\231\202\227\89\17", "\25\18\136\164\195\107\35");
					end
				end
				if ((3040 < 4528) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\216\37\166\74\124\181\217\158\228\44\164\74\97", "\216\136\77\201\47\18\220\161")]:IsCastable() and v43 and not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\12\224\46\194\27\200\144\44\255\49\219\27\250\151\63\245", "\226\77\140\75\186\104\188")]:IsAvailable() and v14:BuffDown(v87.HotStreakBuff) and not v110 and v14:BuffUp(v87.FlamesFuryBuff)) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or (2092 <= 2053)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\198\223\58\65\176\214\239\57\67\184\195\213\44\15\170\218\209\49\75\184\220\212\0\93\182\218\209\43\70\182\192\144\109\27", "\47\217\174\176\95");
					end
				end
				v173 = 3;
			end
			if ((2120 < 4799) and (v173 == 0)) then
				if ((v32 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\96\15\232\33\86\5\82\17\224\39\86", "\118\38\99\137\76\51")]:IsReady() and v40 and (v123 >= v95) and v135()) or (4538 <= 389)) then
					if ((270 <= 1590) and v22(v89.FlamestrikeCursor, not v15:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\42\4\31\12\51\233\52\12\25\12\96\238\50\4\28\13\33\239\34\58\0\6\52\252\50\12\29\7\96\175", "\64\157\70\101\114\105");
					end
				end
				if ((1625 > 1265) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\112\177\181\236\18\76\169\180\247", "\112\32\200\199\131")]:IsReady() and v44 and (v135())) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true) or (51 >= 920)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\73\78\183\193\167\35\63\68\28\171\215\170\44\40\81\78\188\252\185\45\56\81\72\177\204\165\98\120", "\66\76\48\60\216\163\203");
					end
				end
				if ((v32 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\156\138\120\254\90\221\48\168\143\114\246", "\68\218\230\25\147\63\174")]:IsReady() and v40 and not v14:IsCasting(v87.Flamestrike) and (v123 >= v98) and v14:BuffUp(v87.FuryoftheSunKingBuff)) or (2968 <= 1998)) then
					if (v22(v89.FlamestrikeCursor, not v15:IsInRange(40)) or (3085 <= 2742)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\38\82\65\179\190\62\65\69\189\168\106\64\88\183\163\46\82\94\178\146\56\92\88\183\185\35\92\66\246\252\120", "\214\205\74\51\44");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\201\79\237\238\116\242", "\23\154\44\130\156")]:IsReady() and v45 and v133() and (v15:DebuffRemains(v87.ImprovedScorchDebuff) < (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\33\191\191\161\52\31\16\181\185", "\115\113\198\205\206\86")]:CastTime() + (5 * v122))) and v14:BuffUp(v87.FuryoftheSunKingBuff) and not v14:IsCasting(v87.Scorch)) or (376 >= 2083)) then
					if ((4191 > 1232) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\84\241\72\135\95\190\73\144\86\240\94\133\69\250\101\150\88\234\91\144\94\241\84\196\6\173", "\58\228\55\158");
					end
				end
				v173 = 1;
			end
			if ((1 == v173) or (1505 > 4873)) then
				if ((3880 < 4534) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\132\144\194\33\62\161\52\167\157", "\85\212\233\176\78\92\205")]:IsReady() and v44 and not v14:IsCasting(v87.Pyroblast) and (v14:BuffUp(v87.FuryoftheSunKingBuff))) then
					if (v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true) or (2368 >= 2541)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\65\154\237\72\84\137\241\94\24\155\246\75\86\140\227\88\92\183\240\69\76\137\246\67\87\134\162\27\12", "\130\42\56\232");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\204\188\54\230\98\51\235\166\48", "\95\138\213\68\131\32")]:IsReady() and v38 and not v135() and not v130() and not v111 and v14:BuffDown(v87.FuryoftheSunKingBuff) and ((((v14:IsCasting(v87.Fireball) and ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\12\33\179\70\116\43\36\173", "\22\74\72\193\35")]:ExecuteRemains() < 0.5) or not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\4\96\244\93\62\109\236\93\62\116\237\89", "\56\76\25\132")]:IsAvailable())) or (v14:IsCasting(v87.Pyroblast) and ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\110\216\185\41\205\82\192\184\50", "\175\62\161\203\70")]:ExecuteRemains() < 0.5) or not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\20\196\211\22\39\40\213\198\1\56\53\220", "\85\92\189\163\115")]:IsAvailable()))) and v14:BuffUp(v87.HeatingUpBuff)) or (v132() and (not v133() or (v15:DebuffStack(v87.ImprovedScorchDebuff) == v115) or (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\15\165\34\61\11\160\49\43\61", "\88\73\204\80")]:FullRechargeTime() < 3)) and ((v14:BuffUp(v87.HeatingUpBuff) and not v14:IsCasting(v87.Scorch)) or (v14:BuffDown(v87.HotStreakBuff) and v14:BuffDown(v87.HeatingUpBuff) and v14:IsCasting(v87.Scorch) and (v137() == 0)))))) or (4733 <= 4103)) then
					if (v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true) or (1207 == 4273)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\40\138\2\67\22\216\34\130\3\82\105\201\58\130\30\66\40\200\42\188\2\73\61\219\58\138\31\72\105\139\120", "\186\78\227\112\38\73");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\204\78\239\90\81\118\253\68\233", "\26\156\55\157\53\51")]:IsReady() and v44 and (v14:IsCasting(v87.Scorch) or v14:PrevGCDP(1, v87.Scorch)) and v14:BuffUp(v87.HeatingUpBuff) and v132() and (v123 < v95)) or (2005 == 2529)) then
					if ((986 < 3589) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\156\193\4\214\186\92\141\203\2\153\171\68\141\214\18\216\170\84\179\202\25\205\185\68\133\215\24\153\233\8", "\48\236\184\118\185\216");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\214\190\88\34\204\60", "\84\133\221\55\80\175")]:IsReady() and v45 and v133() and (v15:DebuffRemains(v87.ImprovedScorchDebuff) < (4 * v122))) or (3119 == 430)) then
					if ((2409 <= 3219) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\174\228\43\180\196\84\253\244\48\167\201\88\188\245\32\153\213\83\169\230\48\175\200\82\253\182\125", "\60\221\135\68\198\167");
					end
				end
				v173 = 2;
			end
			if ((v173 == 4) or (898 > 2782)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\134\60\232\52\87\136", "\98\213\95\135\70\52\224")]:IsReady() and v45 and (v132())) or (2250 <= 1764)) then
					if ((693 == 693) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\160\198\101\87\246\227\218\99\85\240\167\200\101\80\193\177\198\99\85\234\170\198\121\20\173\243", "\52\158\195\169\23");
					end
				end
				if ((v32 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\91\174\49\117\136\48\94\147\106\176\61\103\143\58\117", "\235\26\220\82\20\230\85\27")]:IsReady() and v35 and (v126 >= v99) and (v14:ManaPercentageP() >= v100)) or (2529 == 438)) then
					if ((1751 > 1411) and v22(v87.ArcaneExplosion, not v15:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\137\179\234\195\122\141\158\236\218\100\132\174\250\203\123\134\225\250\214\117\134\165\232\208\112\183\179\230\214\117\156\168\230\204\52\219\243", "\20\232\193\137\162");
					end
				end
				if ((4182 == 4182) and v32 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\4\211\196\171\226\159\3\99\43\212\192", "\17\66\191\165\198\135\236\119")]:IsReady() and v40 and (v123 >= v96)) then
					if (v22(v89.FlamestrikeCursor, not v15:IsInRange(40)) or (4666 <= 611)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\163\175\30\250\251\248\195\6\164\171\83\236\252\237\223\11\174\188\23\192\250\227\197\14\187\167\28\241\168\191\133", "\177\111\207\206\115\159\136\140");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\53\144\2\27\214\67\94\22\157", "\63\101\233\112\116\180\47")]:IsReady() and v44 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\247\62\224\2\253\36\198\63\203\30\249\59\198\40", "\86\163\91\141\114\152")]:IsAvailable() and v14:BuffDown(v87.FlameAccelerantBuff)) or (4737 <= 4525)) then
					if ((4367 >= 3735) and v22(v87.Pyroblast, not v15:IsSpellInRange(v87.Pyroblast), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\67\18\102\124\56\95\10\103\103\122\64\31\117\125\62\82\25\112\76\40\92\31\117\103\51\92\5\52\32\111", "\90\51\107\20\19");
					end
				end
				v173 = 5;
			end
			if ((2426 == 2426) and (v173 == 5)) then
				if ((21 < 1971) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\171\249\151\234\63\140\252\137", "\93\237\144\229\143")]:IsReady() and v39 and not v135()) then
					if (v22(v87.Fireball, not v15:IsSpellInRange(v87.Fireball), true) or (2922 <= 441)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\255\226\28\9\71\25\250\176\10\31\71\27\242\241\11\15\121\7\249\228\24\31\79\26\248\176\74\93", "\38\117\150\144\121\107");
					end
				end
				break;
			end
			if ((3624 >= 1136) and (v173 == 3)) then
				if ((2043 < 2647) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\136\213\121\7\188\93\96\0\180\220\123\7\161", "\70\216\189\22\98\210\52\24")]:IsCastable() and v43 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\251\211\166\159\192\206\205\162\148\201\219\204\133\146\193\195", "\179\186\191\195\231")]:IsAvailable() and v14:BuffDown(v87.HotStreakBuff) and (v137() == 0) and ((not v110 and v14:BuffUp(v87.FlamesFuryBuff)) or (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\201\55\23\225\247\54\0\194\245\62\21\225\234", "\132\153\95\120")]:ChargesFractional() > 2.5) or ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\129\186\1\40\249\211\184\151\190\15\32\242\201", "\192\209\210\110\77\151\186")]:ChargesFractional() > 1.5) and (not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\198\6\39\229\235\204\229\33\55\251\241", "\164\128\99\66\137\159")]:IsAvailable() or (v14:BuffRemains(v87.FeeltheBurnBuff) < (3 * v122)))))) then
					if (v22(v87.PhoenixFlames, not v15:IsSpellInRange(v87.PhoenixFlames)) or (354 >= 1534)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\16\129\230\187\14\128\241\129\6\133\232\179\5\154\169\173\20\136\231\186\1\155\237\129\18\134\253\191\20\128\230\176\64\219\191", "\222\96\233\137");
					end
				end
				v30 = v142();
				if (v30 or (3764 >= 4876)) then
					return v30;
				end
				if ((3676 >= 703) and v32 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\157\161\166\24\135\253\227\155\161\162\30\156\251", "\144\217\211\199\127\232\147")]:IsReady() and v37 and (v125 > 1) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\217\35\59\48\198\81\16\69\235\53\63\59\243\80\16\93", "\36\152\79\94\72\181\37\98")]:IsAvailable()) then
					if ((3811 > 319) and v22(v87.DragonsBreath)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\202\70\56\216\214\84\0\213\202\66\62\195\208\7\44\195\217\73\59\214\202\67\0\197\215\83\62\195\209\72\49\151\138\31", "\95\183\184\39");
					end
				end
				v173 = 4;
			end
		end
	end
	local function v148()
		local v174 = 0;
		while true do
			if ((47 < 1090) and (v174 == 0)) then
				if (not v93 or (1371 >= 2900)) then
					v145();
				end
				if ((v33 and v85 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\25\178\227\63\26\186\252\42", "\90\77\219\142")]:IsReady() and v14:BloodlustExhaustUp() and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\210\1\44\41\67\21\123\234\51\32\43\92", "\26\134\100\65\89\44\103")]:IsAvailable() and (v130() or (v121 < 40))) or (1126 <= 504)) then
					if (v22(v87.TimeWarp, not v15:IsInRange(40)) or (3732 == 193)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\234\61\38\155\230\226\34\51\228\242\236\61\33\177\226\247\57\44\170\206\224\63\44\168\245\236\39\45\183\177\178\98", "\196\145\131\80\67");
					end
				end
				if ((3344 >= 3305) and (v73 < v121)) then
					if ((v80 and ((v33 and v81) or not v81)) or (2885 < 1925)) then
						local v242 = 0;
						while true do
							if ((v242 == 0) or (4542 <= 1594)) then
								v30 = v138();
								if ((338 <= 3505) and v30) then
									return v30;
								end
								break;
							end
						end
					end
				end
				v109 = v107 > v87[LUAOBFUSACTOR_DECRYPT_STR_0("\45\184\15\14\12\225\16\183\54\7\15\237\12", "\136\126\208\102\104\120")]:CooldownRemains();
				v174 = 1;
			end
			if ((69 == 69) and (v174 == 3)) then
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\36\73\255\246\32\76\236\224\22", "\147\98\32\141")]:IsReady() and v38 and not v135() and v14:IsCasting(v87.ShiftingPower) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\62\74\241\207\36\90\74\11\87", "\43\120\35\131\170\102\54")]:FullRechargeTime() < v119)) or (672 == 368)) then
					if ((1019 == 1019) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\15\149\179\154\178\136\85\21\147\246\168\177\141\90\70\214\224", "\228\52\102\231\214\197\208");
					end
				end
				if (((v107 > 0) and v117) or (290 > 2746)) then
					local v233 = 0;
					while true do
						if ((1923 < 4601) and (v233 == 0)) then
							v30 = v147();
							if (v30 or (3957 == 2099)) then
								return v30;
							end
							break;
						end
					end
				end
				if ((4006 > 741) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\55\227\112\228\229\157\24", "\182\126\128\21\170\138\235\121")]:IsCastable() and UseIceNova and not v132()) then
					if ((2359 <= 3733) and v22(v87.IceNova, not v15:IsSpellInRange(v87.IceNova))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\130\217\48\217\136\28\38\7\203\215\52\239\136\83\97\94", "\102\235\186\85\134\230\115\80");
					end
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\100\15\49\77\113\220", "\66\55\108\94\63\18\180")]:IsReady() and v45) or (4596 <= 2402)) then
					if ((2078 > 163) and v22(v87.Scorch, not v15:IsSpellInRange(v87.Scorch))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\142\138\37\36\81\84\128\132\62\41\25\70\221", "\57\116\237\229\87\71");
					end
				end
				break;
			end
			if ((4116 > 737) and (v174 == 2)) then
				if ((v123 < v97) or (1175 > 4074)) then
					v110 = (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\176\66\222\62\84\49\132\68\242\25\88\44\144\94\222\18", "\95\227\55\176\117\61")]:IsAvailable() or (((v107 + 7) < ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\40\118\44\78\165\17\102\5\71\170\21\123\48", "\203\120\30\67\43")]:FullRechargeTime() + v87[LUAOBFUSACTOR_DECRYPT_STR_0("\193\45\66\234\215\248\61\107\227\216\252\32\94", "\185\145\69\45\143")]:Cooldown()) - (v134() * v26(v109)))) and (v107 < v121))) and not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\171\19\28\190\207\158\13\24\181\198\139\12\63\179\206\147", "\188\234\127\121\198")]:IsAvailable();
				end
				if ((v123 >= v97) or (1361 == 4742)) then
					v110 = (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\11\39\29\168\49\60\20\144\26\62\22\144\43\59\29\132", "\227\88\82\115")]:IsAvailable() or ((v107 < (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\115\23\181\162\12\122\91\57\182\166\15\118\80", "\19\35\127\218\199\98")]:FullRechargeTime() - (v134() * v26(v109)))) and (v107 < v121))) and not v87[LUAOBFUSACTOR_DECRYPT_STR_0("\61\247\15\250\15\239\24\227\15\225\11\241\58\238\24\251", "\130\124\155\106")]:IsAvailable();
				end
				if ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\243\194\228\170\129\250\125\172\193", "\223\181\171\150\207\195\150\28")]:IsReady() and v38 and not v135() and not v111 and (v107 > 0) and (v123 >= v96) and not v130() and v14:BuffDown(v87.HotStreakBuff) and ((v14:BuffUp(v87.HeatingUpBuff) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\106\54\226\163\12\95\46\241\167\2\73", "\105\44\90\131\206")]:ExecuteRemains() < 0.5)) or (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\217\233\160\188\42\50\254\243\166", "\94\159\128\210\217\104")]:ChargesFractional() >= 2))) or (4012 >= 4072)) then
					if ((3807 >= 1276) and v22(v87.FireBlast, not v15:IsSpellInRange(v87.FireBlast), nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\86\240\20\186\96\125\245\123\67\237\70\178\94\118\247\58\1\173", "\26\48\153\102\223\63\31\153");
					end
				end
				if ((2220 <= 4361) and v117 and v130() and (v107 > 0)) then
					local v234 = 0;
					while true do
						if ((228 == 228) and (v234 == 0)) then
							v30 = v146();
							if (v30 or (4118 <= 3578)) then
								return v30;
							end
							break;
						end
					end
				end
				v174 = 3;
			end
			if ((1 == v174) or (2915 < 1909)) then
				v111 = v117 and (((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\94\131\220\70\141\94\60\66\108", "\49\24\234\174\35\207\50\93")]:ChargesFractional() + ((v107 + (v134() * v26(v109))) / v87[LUAOBFUSACTOR_DECRYPT_STR_0("\42\251\239\141\83\0\243\238\156", "\17\108\146\157\232")]:Cooldown())) - 1) < ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\109\202\6\232\13\164\74\208\0", "\200\43\163\116\141\79")]:MaxCharges() + (v103 / v87[LUAOBFUSACTOR_DECRYPT_STR_0("\153\63\47\134\146\248\226\172\34", "\131\223\86\93\227\208\148")]:Cooldown())) - ((12 / v87[LUAOBFUSACTOR_DECRYPT_STR_0("\197\76\164\179\63\185\226\86\162", "\213\131\37\214\214\125")]:Cooldown()) % 1))) and (v107 < v121);
				if ((634 <= 2275) and not v93 and ((v107 <= 0) or v116 or ((v107 < v113) and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\5\36\40\189\244\53\63\44\176\239", "\129\70\75\69\223")]:CooldownRemains() < v113)))) then
					local v235 = 0;
					while true do
						if ((1091 <= 2785) and (v235 == 0)) then
							v30 = v144();
							if ((4638 >= 2840) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((not v111 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\117\222\253\194\117\225\65\216\209\229\121\252\85\194\253\238", "\143\38\171\147\137\28")]:IsAvailable()) or (1292 > 4414)) then
					v111 = v132() and (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\246\139\171\246\33\239\213\195\150", "\180\176\226\217\147\99\131")]:FullRechargeTime() > (3 * v122));
				end
				if ((3511 == 3511) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\224\177\38\1\199\176\33\0\227\182\56\2\193", "\103\179\217\79")]:IsReady() and ((v33 and v51) or not v51) and v49 and (v73 < v121) and v117 and ((v87[LUAOBFUSACTOR_DECRYPT_STR_0("\108\190\14\208\99\128\162\89\163", "\195\42\215\124\181\33\236")]:Charges() == 0) or v111) and (not v133() or ((v15:DebuffRemains(v87.ImprovedScorchDebuff) > (v87[LUAOBFUSACTOR_DECRYPT_STR_0("\62\81\62\56\49\241\3\94\7\49\50\253\31", "\152\109\57\87\94\69")]:CastTime() + v87[LUAOBFUSACTOR_DECRYPT_STR_0("\202\212\5\177\189\218", "\200\153\183\106\195\222\178\52")]:CastTime())) and v14:BuffDown(v87.FuryoftheSunKingBuff))) and v14:BuffDown(v87.HotStreakBuff) and v109) then
					if ((2132 == 2132) and v22(v87.ShiftingPower, not v15:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\235\129\59\93\83\60\228\183\45\70\77\55\241\200\48\72\83\60\163\217\111", "\58\82\131\232\93\41");
					end
				end
				v174 = 2;
			end
		end
	end
	local function v149()
		local v175 = 0;
		while true do
			if ((932 <= 3972) and (v175 == 3)) then
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\76\254\92\132\71\237\91", "\40\237\41\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\123\247\250\95\212\96\243\247\68\240\125\238\240\105\227", "\42\167\20\154\152")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\251\182\86\120\47\77\237", "\65\42\158\194\34\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\47\91\10\57\228\21\233\42\40\69\9\63\218\18\250\18\4\118", "\142\122\71\50\108\77\141\123")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\38\167\235\12\50\27\165\236", "\91\117\194\159\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\14\59\57\57\229\33\8\41\55\21\48", "\68\122\125\94\120\85\145")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\36\25\219\74\193\215\189\4", "\218\119\124\175\62\168\185")][LUAOBFUSACTOR_DECRYPT_STR_0("\176\227\77\230\169\241\82\205\171\247\106\197\183\226\65\193\183", "\164\197\144\40")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\245\190\159\212\184\132\227", "\214\227\144\202\235\189")][LUAOBFUSACTOR_DECRYPT_STR_0("\248\182\130\92\2\182\82\40\232\183\174\117\6\186\64\53\239\172\139\114\4\170", "\92\141\197\231\27\112\211\51")];
				v175 = 4;
			end
			if ((6 == v175) or (4560 <= 2694)) then
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\206\206\185\246\160\250\250\216", "\148\157\171\205\130\201")][LUAOBFUSACTOR_DECRYPT_STR_0("\46\213\103\58\243\247\49\198\125\44\195\222\19", "\150\67\180\20\73\177")] or 0;
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\29\14\89\132\22\29\94", "\45\237\120\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\218\225\176\62\216\250\139\33\214\239\167\14\210\238\173\62\210\216\183\32\219", "\76\183\136\194")];
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\227\241\44\89\65\19\105", "\116\26\134\133\88\48\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\210\165\215\173\119\18\205\147\240\184\115\18\245\161\246\186\119\10", "\18\126\161\192\132\221")];
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\108\45\186\16\95\81\47\189", "\54\63\72\206\100")][LUAOBFUSACTOR_DECRYPT_STR_0("\221\74\64\78\236\118\205\110\68\104\245\76\193\77\77\78\228\119\205\87\81", "\27\168\57\37\26\133")];
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\175\104\188\222\35\173\111", "\183\77\202\28\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\32\140\58\18\62\134\30\18\16\156\26\4\54\190\1\3\59\168\14\17\63\128\11\3\54\141", "\104\119\83\233")];
				break;
			end
			if ((v175 == 1) or (2531 >= 3969)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\117\206\211\10\187\132\2", "\113\222\16\186\167\99\213\227")][LUAOBFUSACTOR_DECRYPT_STR_0("\59\29\254\208\34\15\246\243\61\26\233\255\37\11", "\150\78\110\155")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\182\192\51\245\173\16\184\83", "\32\229\165\71\129\196\126\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\154\193\173\136\195\202\135\195\163\142\216\193", "\181\163\233\164\225\225")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\142\42\99\89\133\57\100", "\23\48\235\94")][LUAOBFUSACTOR_DECRYPT_STR_0("\105\201\221\112\82\39\215\115\200", "\178\28\186\184\61\55\83")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\200\83\40\251\0\242\215", "\149\164\173\39\92\146\110")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\52\21\47\18\20\246\41\25\7\60\23\242\42\21\12", "\123\147\71\112\127\122")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\255\200\150\101\79\194\202\145", "\38\172\173\226\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\88\2\41\223\84\3\35\237\65\16\63\251", "\143\45\113\76")];
				v175 = 2;
			end
			if ((v175 == 0) or (738 > 2193)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\180\249\243\126\224\64\185", "\39\202\209\141\135\23\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\32\12\43\32\251\254\61\12\47\42\232\243\60\26\3\61\246", "\152\159\83\105\106\82")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\178\195\69\230\192\82\134\213", "\60\225\166\49\146\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\58\13\42\11\19\4\46\16\42\3\15\19\42\18\35\47\2\19", "\103\79\126\79\74\97")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\122\199\103\87\20\189\108", "\122\218\31\179\19\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\166\197\200\229\219\160\66\188\216\222\227\219\164\68\167\222", "\37\211\182\173\161\169\193")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\196\63\89\205\33\117\190\228", "\217\151\90\45\185\72\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\111\226\52\95\209\121\197\30\87\208\104", "\54\163\28\135\114")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\27\222\73\150\71\113\47\200", "\31\72\187\61\226\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\21\70\244\78\108\33\193\7\79\222", "\68\163\102\35\178\39\30")];
				v175 = 1;
			end
			if ((4606 >= 3398) and (v175 == 5)) then
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\195\142\190\3\165\187\247\152", "\213\144\235\202\119\204")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\20\223\48\33\45\74\1\25\204\56\33\38\95\11\40", "\45\67\120\190\74\72\67")] or 0;
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\19\39\249\177\240\134\233\250", "\137\64\66\141\197\153\232\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\194\39\167\156\6\194\11\168\158\10\195\43\164\129\15\217\54\191\160\51", "\232\99\176\66\198")] or 0;
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\223\36\60\18\114\131\254\63", "\76\140\65\72\102\27\237\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\67\217\19\240\219\14\189\65\242\38", "\222\42\186\118\178\183\97")] or 0;
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\233\80\158\84\226\67\153", "\234\61\140\36")][LUAOBFUSACTOR_DECRYPT_STR_0("\40\222\191\81\0\45\217\146\66", "\111\65\189\218\18")] or 0;
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\112\78\15\33\2\82\168\80", "\207\35\43\123\85\107\60")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\163\178\248\118\98\131\173\235\126\117\130\144", "\25\16\202\192\138")] or 0;
				v175 = 6;
			end
			if ((1853 > 1742) and (v175 == 2)) then
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\189\8\40\177\182\27\47", "\92\216\216\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\78\33\169\115\254\84\32\175\72", "\157\59\82\204\32")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\59\247\238\224\228\212\162", "\209\88\94\131\154\137\138\179")][LUAOBFUSACTOR_DECRYPT_STR_0("\61\178\193\95\17\54\63\54\45\179\215\108\27\47\61", "\66\72\193\164\28\126\67\81")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\41\188\76\47\120\224\63", "\22\135\76\200\56\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\35\253\6\81\224\158\36\207\37\75\228", "\129\237\80\152\68\61")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\98\173\16\231\21\25\95\66", "\56\49\200\100\147\124\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\45\186\211\195\51\189\229\223\42\182\255\194", "\144\172\94\223")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\23\10\182\83\45\1\165\84", "\39\68\111\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\195\181\226\244\113\190\208\178\238\201\126\135\217\177\226\213", "\215\182\198\135\167\25")];
				v175 = 3;
			end
			if ((v175 == 4) or (2442 > 2564)) then
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\250\158\183\216\232\248\153", "\177\134\159\234\195")][LUAOBFUSACTOR_DECRYPT_STR_0("\168\248\58\137\202\184\201\51\175\202\182", "\169\221\139\95\192")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\142\107\43\43\40\217\152", "\70\190\235\31\95\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\175\241\31\207\230\191\193\21\234\225", "\133\218\130\122\134")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\15\250\247\208\213\173\63\47", "\88\92\159\131\164\188\195")][LUAOBFUSACTOR_DECRYPT_STR_0("\149\61\186\102\214\248\206\162\47\173\89\222\238\207", "\189\224\78\223\43\183\139")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\249\158\2\200\32\251\153", "\161\78\156\234\118")][LUAOBFUSACTOR_DECRYPT_STR_0("\178\164\204\241\174\165\219\211\181\158\196\221\160\178", "\188\199\215\169")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\207\12\75\111\225\242\14\76", "\136\156\105\63\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\26\128\109\49\9\184\112\57\30\164\73", "\84\123\236\25")] or 0;
				v175 = 5;
			end
		end
	end
	local function v150()
		local v176 = 0;
		while true do
			if ((4374 >= 4168) and (v176 == 1)) then
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\182\230\251\205\10\168\130\240", "\198\229\131\143\185\99")][LUAOBFUSACTOR_DECRYPT_STR_0("\117\133\187\99\84\128\140\118\83\153\174\117\66", "\19\49\236\200")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\205\50\226\163\237\180\249\36", "\218\158\87\150\215\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\23\202\242\51\46\239\238\24\223\241", "\173\155\126\185\130\86\66")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\163\174\211\129\226\226\181", "\140\133\198\218\167\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\160\61\177\73\150\188\32\191\120\144\166", "\228\213\78\212\29")];
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\180\73\162\17\226\137\75\165", "\139\231\44\214\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\252\3\108\17\178\56\23\213\252", "\118\185\143\102\62\112\209\81")];
				v176 = 2;
			end
			if ((v176 == 3) or (4576 > 4938)) then
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\129\221\206\97\17\51\200\42", "\89\210\184\186\21\120\93\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\185\86\125\217\109\50\162\71\115\219\124\18\129", "\90\209\51\28\181\25")] or 0;
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\126\67\250\182\222\124\68", "\223\176\27\55\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\44\190\207\185\45\181\201\133\43\175\199\186\42\147\254", "\213\68\219\174")] or 0;
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\56\229\55\243\35\203\56\108", "\31\107\128\67\135\74\165\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\237\253\65\72\191\223\216\243\89\72\190\214\198\253\64\68", "\209\184\136\156\45\33")] or "";
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\205\97\28\177\9\207\102", "\216\103\168\21\104")][LUAOBFUSACTOR_DECRYPT_STR_0("\112\172\77\160\116\168\98\162\126\161\74\167\108\168\71", "\196\24\205\35")];
				v176 = 4;
			end
			if ((2930 > 649) and (v176 == 0)) then
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\198\253\51\54\74\251\255\52", "\35\149\152\71\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\31\225\69\184\46\43\237\79\177\51\23\251\97\184\63\26\227", "\90\121\136\34\208")] or 0;
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\244\11\65\10\206\0\82\13", "\126\167\110\53")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\30\58\253\206\45\40\0\58\207\213\43\53\35\58\237\210", "\95\93\112\78\152\188")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\242\240\145\1\237\176\213\210", "\178\161\149\229\117\132\222")][LUAOBFUSACTOR_DECRYPT_STR_0("\161\213\201\169\179\4\179\51\156\244\211\160\184\33\174\42\156\222\209\165\178\2", "\67\232\187\189\204\193\118\198")];
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\43\161\52\50\12\232\152", "\143\235\78\213\64\91\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\164\70\144\236\98\164\152\88\144\221\120\164\136\91\140\230\124\178", "\214\237\40\228\137\16")];
				v176 = 1;
			end
			if ((v176 == 2) or (1394 < 133)) then
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\111\117\61\242\172\27\27\43", "\88\60\16\73\134\197\117\124")][LUAOBFUSACTOR_DECRYPT_STR_0("\68\248\241\198\74\85\254\235\255\72\68\226\219\236", "\33\48\138\152\168")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\65\19\36\69\200\57\117\5", "\87\18\118\80\49\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\94\31\217\169\177\64\13\237\169\164\68\61\254", "\208\44\126\186\192")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\196\31\176\210\29\242\206\93", "\46\151\122\196\166\116\156\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\254\67\50\254\228\225\82\18\232\241\226\72\31", "\155\133\141\38\122")];
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\47\184\85\70\113\162\54", "\197\69\74\204\33\47\31")][LUAOBFUSACTOR_DECRYPT_STR_0("\229\92\95\175\245\78\86\142\254\72\106\136\228\70\85\137", "\231\144\47\58")];
				v176 = 3;
			end
			if ((v176 == 4) or (432 == 495)) then
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\142\247\18\39\133\228\21", "\102\78\235\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\210\47\58\64\75\60\158\58\249\33\38\84\72\43\178\53\246", "\84\154\78\84\36\39\89\215")];
				break;
			end
		end
	end
	local function v151()
		local v177 = 0;
		while true do
			if ((66 < 1456) and (3 == v177)) then
				v127 = v14:GetEnemiesInRange(40);
				if (v32 or (878 >= 3222)) then
					local v236 = 0;
					while true do
						if ((v236 == 0) or (254 >= 3289)) then
							v123 = v28(v15:GetEnemiesInSplashRangeCount(5), #v127);
							v124 = v28(v15:GetEnemiesInSplashRangeCount(5), #v127);
							v236 = 1;
						end
						if ((v236 == 1) or (2711 <= 705)) then
							v125 = v28(v15:GetEnemiesInSplashRangeCount(5), #v127);
							v126 = #v127;
							break;
						end
					end
				else
					local v237 = 0;
					while true do
						if ((v237 == 0) or (2506 >= 3366)) then
							v123 = 1;
							v124 = 1;
							v237 = 1;
						end
						if ((v237 == 1) or (123 > 746)) then
							v125 = 1;
							v126 = 1;
							break;
						end
					end
				end
				if (v91.TargetIsValid() or v14:AffectingCombat() or (4444 <= 894)) then
					local v238 = 0;
					while true do
						if ((1376 > 583) and (v238 == 4)) then
							v116 = v14:BuffUp(v87.CombustionBuff);
							v117 = not v116;
							break;
						end
						if ((v238 == 3) or (2427 == 2455)) then
							if ((3393 >= 2729) and v93) then
								v107 = 99999;
							end
							v122 = v14:GCD();
							v238 = 4;
						end
						if ((4175 == 4175) and (v238 == 0)) then
							if ((4584 > 1886) and (v14:AffectingCombat() or v67)) then
								local v243 = 0;
								local v244;
								while true do
									if ((0 == v243) or (1043 >= 2280)) then
										v244 = v67 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\106\219\28\117\7\199\238\77\204\2\127", "\173\56\190\113\26\113\162")]:IsReady() and v34;
										v30 = v91.FocusUnit(v244, v89, 20, nil, 20);
										v243 = 1;
									end
									if ((v243 == 1) or (667 < 71)) then
										if (v30 or (4482 < 2793)) then
											return v30;
										end
										break;
									end
								end
							end
							v120 = v10.BossFightRemains(nil, true);
							v238 = 1;
						end
						if ((561 < 4519) and (v238 == 1)) then
							v121 = v120;
							if ((v121 == 11111) or (677 == 1434)) then
								v121 = v10.FightRemains(v127, false);
							end
							v238 = 2;
						end
						if ((2827 == 2827) and (2 == v238)) then
							v129 = v136(v127);
							v93 = not v33;
							v238 = 3;
						end
					end
				end
				v177 = 4;
			end
			if ((2556 == 2556) and (1 == v177)) then
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\77\251\31\4\24\34\0", "\115\25\148\120\99\116\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\50\188", "\33\108\93\217\68")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\239\68\166\170\215\78\178", "\205\187\43\193")][LUAOBFUSACTOR_DECRYPT_STR_0("\253\118\22", "\191\158\18\101")];
				Kick = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\241\204\128\176\163\192\208", "\207\165\163\231\215")][LUAOBFUSACTOR_DECRYPT_STR_0("\205\240\250\93", "\16\166\153\153\54\68")];
				v177 = 2;
			end
			if ((v177 == 2) or (3106 >= 4932)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\230\188\199\65\56\36\234", "\153\178\211\160\38\84\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\134\2\73\59\135\7", "\75\226\107\58")];
				if (v14:IsDeadOrGhost() or (1217 <= 503)) then
					return;
				end
				v128 = v15:GetEnemiesInSplashRange(5);
				v177 = 3;
			end
			if ((v177 == 0) or (441 >= 4871)) then
				v149();
				v150();
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\238\81\95\9\248\242", "\101\157\129\54\56")][LUAOBFUSACTOR_DECRYPT_STR_0("\18\166\137", "\25\125\201\234\203\67")];
				v177 = 1;
			end
			if ((3751 > 731) and (v177 == 4)) then
				if ((not v14:AffectingCombat() and v31) or (2515 < 1804)) then
					local v239 = 0;
					while true do
						if ((3008 > 1924) and (v239 == 0)) then
							v30 = v141();
							if ((295 == 295) and v30) then
								return v30;
							end
							break;
						end
					end
				end
				if ((4828 >= 1725) and v14:AffectingCombat() and v91.TargetIsValid()) then
					local v240 = 0;
					while true do
						if ((v240 == 4) or (4201 < 2150)) then
							if (v30 or (3076 >= 4666)) then
								return v30;
							end
							break;
						end
						if ((v240 == 3) or (2027 >= 3030)) then
							if ((3245 <= 3566) and (v14:IsCasting() or v14:IsChanneling()) and v14:BuffUp(v87.HotStreakBuff)) then
								if (v22(v89.StopCasting, not v15:IsSpellInRange(v87.Pyroblast)) or (2627 <= 381)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\226\60\211\228\145\11\221\231\197\33\210\243", "\148\177\72\188");
								end
							end
							v30 = v148();
							v240 = 4;
						end
						if ((283 < 4544) and (v240 == 0)) then
							if ((618 < 3820) and Focus) then
								if ((4287 >= 124) and v67) then
									local v246 = 0;
									while true do
										if ((2569 <= 3918) and (v246 == 0)) then
											v30 = v139();
											if (v30 or (3154 <= 2030)) then
												return v30;
											end
											break;
										end
									end
								end
							end
							v30 = v140();
							v240 = 1;
						end
						if ((v240 == 2) or (3761 <= 682)) then
							if ((2128 > 836) and v69) then
								local v245 = 0;
								while true do
									if ((v245 == 0) or (2361 <= 1063)) then
										v30 = v91.HandleIncorporeal(v87.Polymorph, v89.PolymorphMouseOver, 30, true);
										if (v30 or (1790 >= 3221)) then
											return v30;
										end
										break;
									end
								end
							end
							if ((4459 >= 3851) and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\248\206\40\9\251\216\202\40\4\251", "\151\171\190\77\101")]:IsAvailable() and v84 and v87[LUAOBFUSACTOR_DECRYPT_STR_0("\246\63\253\165\244\110\31\192\46\244", "\107\165\79\152\201\152\29")]:IsReady() and v34 and v66 and not v14:IsCasting() and not v14:IsChanneling() and v91.UnitHasMagicBuff(v15)) then
								if (v22(v87.Spellsteal, not v15:IsSpellInRange(v87.Spellsteal)) or (2969 <= 1860)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\68\94\237\199\88\108\67\75\233\199\20\123\86\67\233\204\81", "\31\55\46\136\171\52");
								end
							end
							v240 = 3;
						end
						if ((v240 == 1) or (2123 == 39)) then
							if (v30 or (2132 <= 201)) then
								return v30;
							end
							if (v68 or (4338 >= 4477)) then
								if (v86 or (1732 >= 3545)) then
									local v247 = 0;
									while true do
										if ((1125 >= 64) and (0 == v247)) then
											v30 = v91.HandleAfflicted(v87.RemoveCurse, v89.RemoveCurseMouseover, 30);
											if (v30 or (3215 > 4005)) then
												return v30;
											end
											break;
										end
									end
								end
							end
							v240 = 2;
						end
					end
				end
				break;
			end
		end
	end
	local function v152()
		local v178 = 0;
		while true do
			if ((2415 > 665) and (v178 == 0)) then
				v92();
				v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\128\191\69\214\230\155\86\212\163\246\69\220\178\183\67\218\169\184\23\209\191\246\114\195\175\181\25\147\149\163\71\195\169\164\67\214\162\246\85\202\230\174\124\210\168\179\67\220\232", "\179\198\214\55"));
				break;
			end
		end
	end
	v20.SetAPL(63, v151, v152);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\213\28\123\110\122\254\241\11\119\73\99\218\226\9\60\122\80\210", "\179\144\108\18\22\37")]();

