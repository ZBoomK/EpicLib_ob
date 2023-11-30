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
		if ((v5 == 1) or (3626 <= 1306)) then
			return v6(...);
		end
		if ((1368 < 3780) and (0 == v5)) then
			v6 = v0[v4];
			if (not v6 or (3169 == 2273)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\136\207\31\220\194\213\26\212\190\212\10\222\240\211\36\235\186\201\80\221\214\218", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\155\33\4", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\218\88\164\83\239", "\38\156\55\199")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\155\109\121\36\31", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\52\170\221\203\132\31\36\28\179\221", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\124\86\9\41\90", "\69\41\34\96")];
	local v21 = EpicLib;
	local v22 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\50\168\142\36\202", "\185\98\218\235\87")];
	local v24 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\230\61\36\244\209", "\202\171\92\71\134\190")];
	local v25 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local v26 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local v27 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\202\93\126", "\126\167\52\16\116\217")];
	local v28 = false;
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
	local v98;
	local v99;
	local v100;
	local v101;
	local v102;
	local v103;
	local v104;
	local v105 = 11111;
	local v106 = 11111;
	v10:RegisterForEvent(function()
		local v125 = 0;
		while true do
			if ((2481 <= 3279) and (v125 == 0)) then
				v105 = 11111;
				v106 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\248\2\1\185\145\43\195\250\11\7\165\154\38\217\230\15\2\172\145\61", "\156\168\78\64\224\212\121"));
	local v107 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\52\230\164\195\6\224", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\100\45\76\44\42\76\249\66\33\80\54", "\152\54\72\63\88\69\62")];
	local v108 = v24[LUAOBFUSACTOR_DECRYPT_STR_0("\231\204\239\81\213\202", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\106\91\22\61\40\255\19\76\87\10\39", "\114\56\62\101\73\71\141")];
	local v109 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\139\225\218\201\185\231", "\164\216\137\187")][LUAOBFUSACTOR_DECRYPT_STR_0("\224\227\34\166\169\236\10\198\239\62\188", "\107\178\134\81\210\198\158")];
	local v110 = {};
	local v111 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\27\1\143\203\165\54\29", "\202\88\110\226\166")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\25\135\229\211\204\1\135", "\170\163\111\226\151")];
	local v112 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\50\63\191\53\65\57\58", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\178\36\204\31\230\143", "\135\225\76\173\114")];
	local function v113()
		if (v107[LUAOBFUSACTOR_DECRYPT_STR_0("\51\224\168\162\163\171\162\30\221\173\162\165\187\190\41\253\177\162\165\169", "\199\122\141\216\208\204\221")]:IsAvailable() or (1063 <= 877)) then
			v111[LUAOBFUSACTOR_DECRYPT_STR_0("\137\212\3\224\125\250\161\220\18\252\125\210\168\223\5\246\126\229", "\150\205\189\112\144\24")] = v20.MergeTable(v111.DispellableMagicDebuffs, v111.DispellableCurseDebuffs);
		else
			v111[LUAOBFUSACTOR_DECRYPT_STR_0("\1\141\172\92\1\132\29\17\39\136\186\104\1\138\4\22\35\151", "\112\69\228\223\44\100\232\113")] = v111[LUAOBFUSACTOR_DECRYPT_STR_0("\240\22\20\195\179\112\138\213\29\11\214\155\125\129\221\28\35\214\180\105\128\210\12", "\230\180\127\103\179\214\28")];
		end
	end
	v10:RegisterForEvent(function()
		v113();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\173\38\107\111\210\100\223\188\41\126\127\193\115\223\191\53\122\101\205\96\204\165\63\126\114\205\110\206\179\38\119\103\202\102\197\168", "\128\236\101\63\38\132\33"));
	local function v114(v126)
		return v126:DebuffRefreshable(v107.FlameShockDebuff) and (v106 > 5);
	end
	local function v115()
		local v127 = 0;
		while true do
			if ((2314 == 2314) and (v127 == 0)) then
				if ((924 >= 477) and v97 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\141\186\5\86\183\231\252\164\160\23\80", "\175\204\201\113\36\214\139")]:IsReady()) then
					if ((1813 <= 3778) and (v13:HealthPercentage() <= v98)) then
						if ((4150 == 4150) and v23(v107.AstralShift)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\70\223\33\206\5\75\243\38\212\13\65\216\117\216\1\65\201\59\207\13\81\201\38", "\100\39\172\85\188");
						end
					end
				end
				if ((432 <= 3007) and v99 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\136\121\171\148\59\136\116\188\141\54\163\108\184\140", "\83\205\24\217\224")]:IsReady()) then
					if ((v13:HealthPercentage() <= v100) or v111.IsTankBelowHealthPercentage(v101) or (408 > 2721)) then
						if (v23(v107.EarthElemental) or (3418 < 2497)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\227\196\223\41\238\250\200\49\227\200\200\51\242\196\193\125\226\192\203\56\232\214\196\43\227\214", "\93\134\165\173");
						end
					end
				end
				v127 = 1;
			end
			if ((1735 < 2169) and (v127 == 1)) then
				if ((3890 >= 3262) and v109[LUAOBFUSACTOR_DECRYPT_STR_0("\150\247\192\206\46\198\161\106\177\252\196", "\30\222\146\161\162\90\174\210")]:IsReady() and v34 and (v13:HealthPercentage() <= v35)) then
					if (v23(v108.Healthstone, nil, nil, true) or (4356 >= 4649)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\75\113\6\241\70\99\30\234\64\117\74\225\75\118\15\235\93\121\28\224\14\35", "\106\133\46\16");
					end
				end
				if ((3904 == 3904) and v36 and (v13:HealthPercentage() <= v37)) then
					if ((v38 == LUAOBFUSACTOR_DECRYPT_STR_0("\106\37\117\238\95\83\80\41\125\251\26\104\93\33\127\245\84\71\24\16\124\232\83\79\86", "\32\56\64\19\156\58")) or (2860 >= 3789)) then
						if (v109[LUAOBFUSACTOR_DECRYPT_STR_0("\104\205\227\68\95\225\136\83\198\226\126\95\243\140\83\198\226\102\85\230\137\85\198", "\224\58\168\133\54\58\146")]:IsReady() or (1086 > 4449)) then
							if ((4981 > 546) and v23(v108.RefreshingHealingPotion, nil, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\75\83\77\239\112\149\143\2\87\81\11\245\112\135\139\2\87\81\11\237\122\146\142\4\87\22\79\248\115\131\137\24\80\64\78\189\33", "\107\57\54\43\157\21\230\231");
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v116()
		local v128 = 0;
		while true do
			if ((v128 == 3) or (2366 <= 8)) then
				if (ShouldReturn or (2590 == 2864)) then
					return ShouldReturn;
				end
				if (v40 or (2624 > 4149)) then
					local v219 = 0;
					while true do
						if ((0 == v219) or (2618 >= 4495)) then
							ShouldReturn = v111.HandleIncorporeal(v107.Hex, v108.HexMouseOver, 30);
							if (ShouldReturn or (2485 >= 3131)) then
								return ShouldReturn;
							end
							break;
						end
					end
				end
				break;
			end
			if ((v128 == 0) or (2804 <= 2785)) then
				if (v39 or (4571 == 3415)) then
					local v220 = 0;
					while true do
						if ((v220 == 2) or (4441 > 4787)) then
							ShouldReturn = v111.HandleAfflicted(v107.Riptide, v108.RiptideMouseover, 40);
							if ((1920 == 1920) and ShouldReturn) then
								return ShouldReturn;
							end
							v220 = 3;
						end
						if ((1 == v220) or (647 == 4477)) then
							ShouldReturn = v111.HandleAfflicted(v107.PurifySpirit, v108.PurifySpiritMouseover, 40);
							if ((3819 == 3819) and ShouldReturn) then
								return ShouldReturn;
							end
							v220 = 2;
						end
						if ((v220 == 4) or (1466 > 4360)) then
							ShouldReturn = v111.HandleAfflicted(v107.HealingWave, v108.HealingWaveMouseover, 40);
							if (ShouldReturn or (14 > 994)) then
								return ShouldReturn;
							end
							break;
						end
						if ((401 <= 734) and (v220 == 3)) then
							ShouldReturn = v111.HandleAfflicted(v107.HealingSurge, v108.HealingSurgeMouseover, 40);
							if (ShouldReturn or (2167 >= 3426)) then
								return ShouldReturn;
							end
							v220 = 4;
						end
						if ((764 < 3285) and (v220 == 0)) then
							ShouldReturn = v111.HandleAfflicted(v107.PoisonCleansingTotem, nil, 40);
							if ((2499 == 2499) and ShouldReturn) then
								return ShouldReturn;
							end
							v220 = 1;
						end
					end
				end
				ShouldReturn = v111.HandleChromie(v107.Riptide, v108.RiptideMouseover, 40);
				v128 = 1;
			end
			if ((2 == v128) or (692 >= 4933)) then
				if (ShouldReturn or (3154 <= 2260)) then
					return ShouldReturn;
				end
				ShouldReturn = v111.HandleChromie(v107.HealingWave, v108.HealingWaveMouseover, 40);
				v128 = 3;
			end
			if ((v128 == 1) or (2637 > 3149)) then
				if (ShouldReturn or (3992 < 2407)) then
					return ShouldReturn;
				end
				ShouldReturn = v111.HandleChromie(v107.HealingSurge, v108.HealingSurgeMouseover, 40);
				v128 = 2;
			end
		end
	end
	local function v117()
		local v129 = 0;
		while true do
			if ((v129 == 3) or (2902 > 4859)) then
				if ((1679 < 4359) and v95 and (v13:Mana() <= v96) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\136\171\45\31\39\13\195\84\145\165\55\27\30", "\49\197\202\67\126\115\100\167")]:IsReady()) then
					if ((1913 < 4670) and v23(v107.ManaTideTotem)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\90\209\40\191\66\87\51\94\224\61\143\66\91\58\27\220\38\143\90\90\56\76\209\58", "\62\87\59\191\73\224\54");
					end
				end
				if (v33 or (2846 < 879)) then
					local v221 = 0;
					while true do
						if ((4588 == 4588) and (v221 == 2)) then
							if (v107[LUAOBFUSACTOR_DECRYPT_STR_0("\145\236\107\240\235\199\184\234\125", "\171\215\133\25\149\137")]:IsReady() or (347 == 2065)) then
								if (v23(v107.Fireblood) or (1311 > 2697)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\199\193\32\255\237\60\243\77\229\136\49\245\224\60\248\77\246\198\33", "\34\129\168\82\154\143\80\156");
								end
							end
							break;
						end
						if ((v221 == 0) or (2717 > 3795)) then
							if (v107[LUAOBFUSACTOR_DECRYPT_STR_0("\198\12\249\204\244\22\232\200\235\33\251\197\235", "\169\135\98\154")]:IsReady() or (1081 < 391)) then
								if (v23(v107.AncestralCall) or (121 > 3438)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\234\121\39\81\238\39\218\202\123\7\85\241\63\136\200\120\43\88\249\60\223\197\100", "\168\171\23\68\52\157\83");
								end
							end
							if ((71 < 1949) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\214\112\242\162\35\25\149\253\114\254\190", "\231\148\17\149\205\69\77")]:IsReady()) then
								if ((4254 == 4254) and v23(v107.BagofTricks)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\162\166\192\244\81\203\146\174\196\240\68\191\131\168\200\247\83\240\151\169\212", "\159\224\199\167\155\55");
								end
							end
							v221 = 1;
						end
						if ((3196 >= 2550) and (v221 == 1)) then
							if ((2456 < 4176) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\213\246\46\193\242\225\55\219\249\244", "\178\151\147\92")]:IsReady()) then
								if (v23(v107.Berserking) or (1150 == 3452)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\174\248\94\33\23\94\113\133\243\75\114\17\67\117\128\249\67\37\28\95", "\26\236\157\44\82\114\44");
								end
							end
							if ((1875 < 2258) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\8\34\218\84\46\8\192\73\51", "\59\74\78\181")]:IsReady()) then
								if ((1173 > 41) and v23(v107.BloodFury)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\7\221\85\85\183\3\196\72\67\243\38\222\85\86\183\42\198\84\73", "\211\69\177\58\58");
								end
							end
							v221 = 2;
						end
					end
				end
				break;
			end
			if ((2 == v129) or (56 >= 3208)) then
				if ((4313 > 3373) and v71 and v111.AreUnitsBelowHealthPercentage(v72, v73) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\18\19\245\185\51\24\243\129\51\18\241\129\53\2\241\184", "\213\90\118\148")]:IsReady()) then
					if (v23(v107.HealingTideTotem) or (4493 == 2225)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\43\181\90\68\85\41\139\66\68\95\43\139\66\66\79\43\185\22\78\84\33\184\82\66\76\32\167", "\45\59\78\212\54");
					end
				end
				if ((3104 >= 3092) and v111.AreUnitsBelowHealthPercentage(v81, v82) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\49\88\128\142\149\58\191\241\28\102\145\132\146\43\174\228\25\89\141\191\137\58\168\253", "\144\112\54\227\235\230\78\205")]:IsReady()) then
					if ((3548 > 3098) and (v80 == LUAOBFUSACTOR_DECRYPT_STR_0("\131\36\14\229\213\73", "\59\211\72\111\156\176"))) then
						if (v23(v108.AncestralProtectionTotemPlayer) or (3252 == 503)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\111\137\224\40\93\147\241\44\66\183\241\34\90\130\224\57\71\136\237\25\65\147\230\32\14\132\236\34\66\131\236\58\64\148", "\77\46\231\131");
						end
					elseif ((4733 > 2066) and (v80 == LUAOBFUSACTOR_DECRYPT_STR_0("\156\70\191\69\180\80\186\89\250\65\184\68\191\70\246\99\175\70\165\79\168", "\32\218\52\214"))) then
						if ((3549 >= 916) and Mouseover:Exists() and not v13:CanAttack(Mouseover)) then
							if (v23(v108.AncestralProtectionTotemCursor, not v15:IsInRange(40)) or (2189 <= 245)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\111\25\50\173\226\164\87\91\66\39\35\167\229\181\70\78\71\24\63\156\254\164\64\87\14\20\62\167\253\180\74\77\64\4", "\58\46\119\81\200\145\208\37");
							end
						end
					elseif ((v80 == LUAOBFUSACTOR_DECRYPT_STR_0("\8\131\62\170\160\175\59\42\152\57\163\167", "\86\75\236\80\204\201\221")) or (1389 > 3925)) then
						if ((4169 >= 3081) and v23(v107.AncestralProtectionTotem)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\83\79\116\128\237\159\96\64\123\181\236\132\102\68\116\145\247\132\124\117\120\145\251\134\50\66\120\138\242\143\125\86\121\150", "\235\18\33\23\229\158");
						end
					end
				end
				if ((349 <= 894) and v89 and v111.AreUnitsBelowHealthPercentage(v90, v91) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\113\180\194\190\67\174\211\186\92\157\212\178\84\187\207\184\85", "\219\48\218\161")]:IsReady()) then
					if ((731 <= 2978) and v23(v107.AncestralGuidance)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\127\127\76\200\91\242\229\125\67\78\206\70\228\229\127\127\76\155\76\239\235\125\120\70\204\65\243", "\128\132\17\28\41\187\47");
					end
				end
				if ((v92 and v111.AreUnitsBelowHealthPercentage(v93, v94) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\32\33\5\63\83\5\51\8\57\88", "\61\97\82\102\90")]:IsReady()) or (892 > 3892)) then
					if (v23(v107.Ascendance) or (4466 == 900)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\61\168\78\201\83\31\7\175\43\235\72\200\88\18\13\163\57\165\88", "\105\204\78\203\43\167\55\126");
					end
				end
				v129 = 3;
			end
			if ((v129 == 0) or (2084 >= 2888)) then
				ShouldReturn = v111.HandleTopTrinket(v110, v29, 40, nil);
				if ((479 < 1863) and ShouldReturn) then
					return ShouldReturn;
				end
				ShouldReturn = v111.HandleBottomTrinket(v110, v29, 40, nil);
				if (ShouldReturn or (2428 >= 4038)) then
					return ShouldReturn;
				end
				v129 = 1;
			end
			if ((v129 == 1) or (2878 > 2897)) then
				if ((v107[LUAOBFUSACTOR_DECRYPT_STR_0("\254\138\3\225\177\239\199\210\142\29\241", "\175\187\235\113\149\217\188")]:IsReady() and v46 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(40) and (v111.UnitGroupRole(v16) == LUAOBFUSACTOR_DECRYPT_STR_0("\8\142\175\103", "\24\92\207\225\44\131\25")) and v16:BuffDown(v107.EarthShield)) or (2469 > 3676)) then
					if ((233 < 487) and v23(v108.EarthShieldFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\78\210\170\88\19\66\88\219\177\73\23\121\116\199\185\66\16\61\67\214\185\64\18\115\76\192\172", "\29\43\179\216\44\123");
					end
				end
				if ((2473 >= 201) and v47 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\143\208\48\88\180\221\37", "\44\221\185\64")]:IsReady() and v16:BuffDown(v107.Riptide)) then
					if ((4120 >= 133) and (v16:HealthPercentage() <= v48)) then
						if ((3080 >= 1986) and v23(v108.RiptideFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\19\238\88\75\122\5\226\8\87\118\0\235\65\81\116\0\232\77", "\19\97\135\40\63");
						end
					end
				end
				if ((v47 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\156\85\35\47\38\53\171", "\81\206\60\83\91\79")]:IsReady() and v16:BuffDown(v107.Riptide)) or (1439 > 3538)) then
					if (((v16:HealthPercentage() <= v49) and (v111.UnitGroupRole(v16) == LUAOBFUSACTOR_DECRYPT_STR_0("\122\138\254\89", "\196\46\203\176\18\79\163\45"))) or (419 < 7)) then
						if ((2820 == 2820) and v23(v108.RiptideFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\170\43\110\10\45\255\234\248\42\123\31\40\242\225\191\35\113\27", "\143\216\66\30\126\68\155");
						end
					end
				end
				if ((v111.AreUnitsBelowHealthPercentage(v69, v70) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\153\216\4\217\204\183\251\232\164\195\57\196\209\166\218", "\129\202\168\109\171\165\195\183")]:IsReady()) or (4362 <= 3527)) then
					if ((2613 <= 2680) and (v68 == LUAOBFUSACTOR_DECRYPT_STR_0("\18\84\54\193\219\6", "\134\66\56\87\184\190\116"))) then
						if (v23(v108.SpiritLinkTotemPlayer) or (1482 >= 4288)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\47\33\0\169\16\255\30\57\53\63\2\132\13\228\53\48\49\113\10\180\22\231\37\58\43\63\26", "\85\92\81\105\219\121\139\65");
						end
					elseif ((v68 == LUAOBFUSACTOR_DECRYPT_STR_0("\219\161\89\64\114\219\241\170\16\80\114\219\248\161\16\102\105\205\238\188\66", "\191\157\211\48\37\28")) or (2462 > 4426)) then
						if ((4774 == 4774) and Mouseover:Exists() and not v13:CanAttack(Mouseover)) then
							if ((566 <= 960) and v23(v108.SpiritLinkTotemCursor, not v15:IsInRange(40))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\204\15\253\14\51\203\32\248\21\52\212\32\224\19\46\218\18\180\31\53\208\19\240\19\45\209\12", "\90\191\127\148\124");
							end
						end
					elseif ((v68 == LUAOBFUSACTOR_DECRYPT_STR_0("\91\136\32\17\113\149\35\22\108\142\33\25", "\119\24\231\78")) or (2910 <= 1930)) then
						if (v23(v107.SpiritLinkTotem) or (19 > 452)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\145\61\172\88\213\84\46\142\36\171\65\227\84\30\150\40\168\10\223\79\30\142\41\170\93\210\83", "\113\226\77\197\42\188\32");
						end
					end
				end
				v129 = 2;
			end
		end
	end
	local function v118()
		local v130 = 0;
		while true do
			if ((v130 == 4) or (907 > 3152)) then
				if ((v65 and v111.AreUnitsBelowHealthPercentage(v66, v67) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\219\234\89\218\44\88\244\220\76\196\32\87\254\219\87\194\32\91", "\54\147\143\56\182\69")]:IsReady()) or (2505 > 4470)) then
					if (v23(v107.HealingStreamTotem) or (3711 > 4062)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\222\132\254\69\214\216\134\192\90\203\196\132\254\68\224\194\142\235\76\210\150\137\250\72\211\223\143\248\72\208\211", "\191\182\225\159\41");
					end
				end
				break;
			end
			if ((420 == 420) and (v130 == 0)) then
				if ((v107[LUAOBFUSACTOR_DECRYPT_STR_0("\160\179\33\31\64\125\129\140\183\63\15", "\233\229\210\83\107\40\46")]:IsReady() and v46 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(40) and (v111.UnitGroupRole(v16) == LUAOBFUSACTOR_DECRYPT_STR_0("\245\99\28\253", "\101\161\34\82\182")) and v16:BuffDown(v107.EarthShield)) or (33 >= 3494)) then
					if (v23(v108.EarthShieldFocus) or (1267 == 4744)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\237\12\75\234\211\221\145\38\225\8\85\250\228\246\131\32\227\77\81\251\218\238\139\32\239\30\77", "\78\136\109\57\158\187\130\226");
					end
				end
				if ((2428 < 3778) and v47 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\12\54\233\229\55\59\252", "\145\94\95\153")]:IsReady() and v16:BuffDown(v107.Riptide)) then
					if ((v16:HealthPercentage() <= v48) or (2946 <= 1596)) then
						if ((4433 > 3127) and v23(v108.RiptideFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\239\196\4\193\71\179\248\141\28\208\79\187\244\195\19\212\65\178", "\215\157\173\116\181\46");
						end
					end
				end
				if ((4300 >= 2733) and v47 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\7\189\155\230\211\49\177", "\186\85\212\235\146")]:IsReady() and v16:BuffDown(v107.Riptide)) then
					if ((4829 == 4829) and (v16:HealthPercentage() <= v49) and (v111.UnitGroupRole(v16) == LUAOBFUSACTOR_DECRYPT_STR_0("\246\160\56\213", "\56\162\225\118\158\89\142"))) then
						if ((1683 <= 4726) and v23(v108.RiptideFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\78\12\208\187\43\220\89\69\200\170\35\212\85\11\199\174\45\221", "\184\60\101\160\207\66");
						end
					end
				end
				v130 = 1;
			end
			if ((4835 >= 3669) and (v130 == 3)) then
				if ((2851 > 1859) and v86 and v111.AreUnitsBelowHealthPercentage(v87, v88) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\3\35\12\204\230\36\52\9\206\242", "\149\84\70\96\160")]:IsReady()) then
					if ((3848 > 2323) and v23(v107.Wellspring, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\3\1\225\43\22\31\228\54\1\77\229\61\7\1\228\54\1\12\226\61", "\141\88\102\109");
					end
				end
				if ((2836 > 469) and v59 and v111.AreUnitsBelowHealthPercentage(v60, v61) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\144\91\203\121\20\21\80\192\191", "\161\211\51\170\16\122\93\53")]:IsReady()) then
					if (v23(v108.ChainHealFocus, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff)) or (2096 <= 540)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\166\179\33\245\145\186\45\250\162\242\32\254\175\190\33\245\169\179\39\254", "\72\155\206\210");
					end
				end
				if ((v62 and v13:IsMoving() and v111.AreUnitsBelowHealthPercentage(v63, v64) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\117\106\93\28\58\82\109\85\2\56\67\104\71\41\33\71\121\81", "\83\38\26\52\110")]:IsReady()) or (3183 < 2645)) then
					if ((3230 <= 3760) and v23(v107.SpiritwalkersGrace)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\7\46\84\81\3\48\71\84\28\34\84\75\40\32\84\89\20\34\6\80\18\38\74\81\25\32\71\87\18", "\38\56\119\71");
					end
				end
				v130 = 4;
			end
			if ((3828 == 3828) and (v130 == 2)) then
				if ((554 == 554) and v111.AreUnitsBelowHealthPercentage(v75, v76) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\228\19\31\225\10\117\183\246\19\1\249\54\127\173\196\31", "\217\161\114\109\149\98\16")]:IsReady()) then
					if ((v74 == LUAOBFUSACTOR_DECRYPT_STR_0("\34\44\57\101\185\102", "\20\114\64\88\28\220")) or (2563 == 172)) then
						if ((3889 >= 131) and v23(v108.EarthenWallTotemPlayer)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\52\0\192\160\240\213\179\14\22\211\184\244\239\169\62\21\215\185\184\216\184\48\13\219\186\255\209\178\52", "\221\81\97\178\212\152\176");
						end
					elseif ((v74 == LUAOBFUSACTOR_DECRYPT_STR_0("\235\245\20\254\20\201\235\4\187\15\195\227\24\233\90\238\242\15\232\21\223", "\122\173\135\125\155")) or (492 == 4578)) then
						if ((Mouseover:Exists() and not v13:CanAttack(Mouseover)) or (4112 < 1816)) then
							if ((4525 >= 1223) and v23(v108.EarthenWallTotemCursor, not v15:IsInRange(40))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\129\192\18\173\55\52\198\187\214\1\181\51\14\220\139\213\5\180\127\57\205\133\205\9\183\56\48\199\129", "\168\228\161\96\217\95\81");
							end
						end
					elseif ((1090 <= 4827) and (v74 == LUAOBFUSACTOR_DECRYPT_STR_0("\248\222\32\90\38\69\214\208\58\85\32\89", "\55\187\177\78\60\79"))) then
						if (v23(v107.EarthenWallTotem) or (239 > 1345)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\40\207\77\255\78\202\142\18\217\94\231\74\240\148\34\218\90\230\6\199\133\44\194\86\229\65\206\143\40", "\224\77\174\63\139\38\175");
						end
					end
				end
				if ((v111.AreUnitsBelowHealthPercentage(v78, v79) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\160\78\79\32\148\78\77\60", "\78\228\33\56")]:IsReady()) or (3710 >= 3738)) then
					if ((v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\254\114\179\26\128\220", "\229\174\30\210\99")) or (3838 < 2061)) then
						if (v23(v108.DownpourPlayer, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff)) or (690 > 1172)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\31\226\145\95\253\50\44\9\173\142\84\236\49\48\21\234\135\94\232", "\89\123\141\230\49\141\93");
						end
					elseif ((v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\213\99\255\9\30\78\255\104\182\25\30\78\246\99\182\47\5\88\224\126\228", "\42\147\17\150\108\112")) or (1592 > 2599)) then
						if ((3574 <= 4397) and Mouseover:Exists() and not v13:CanAttack(Mouseover)) then
							if ((3135 > 1330) and v23(v108.DownpourCursor, not v15:IsInRange(40), v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\11\169\58\113\247\231\26\180\109\119\226\233\3\175\35\120\230\231\10", "\136\111\198\77\31\135");
							end
						end
					elseif ((v77 == LUAOBFUSACTOR_DECRYPT_STR_0("\33\6\169\80\180\246\26\168\22\0\168\88", "\201\98\105\199\54\221\132\119")) or (3900 <= 3641)) then
						if ((1724 == 1724) and v23(v107.Downpour, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\189\3\148\47\18\58\185\171\76\139\36\3\57\165\183\11\130\46\7", "\204\217\108\227\65\98\85");
						end
					end
				end
				if ((455 <= 1282) and v83 and v111.AreUnitsBelowHealthPercentage(v84, v85) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\125\207\250\240\40\194\75\209\230\241\24\207\74\198\248", "\160\62\163\149\133\76")]:IsReady()) then
					if ((4606 < 4876) and v23(v107.CloudburstTotem)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\213\172\2\58\193\195\178\30\59\252\194\175\25\42\206\150\168\8\46\207\223\174\10\46\204\211", "\163\182\192\109\79");
					end
				end
				v130 = 3;
			end
			if ((v130 == 1) or (1442 > 2640)) then
				if ((136 < 3668) and v54 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\4\140\112\185\48\145\116\144\56\132\121", "\220\81\226\28")]:IsReady()) then
					if ((v16:HealthPercentage() <= v55) or (1784 > 4781)) then
						if ((4585 > 3298) and v23(v107.UnleashLife)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\6\219\142\254\235\212\27\234\142\242\236\194\83\221\135\250\230\206\29\210\131\244\239", "\167\115\181\226\155\138");
						end
					end
				end
				if (((v56 == LUAOBFUSACTOR_DECRYPT_STR_0("\193\55\245\79\116\99", "\166\130\66\135\60\27\17")) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\108\79\207\121\57\74\77\252\116\57\74", "\80\36\42\174\21")]:IsReady()) or (1664 > 1698)) then
					if (v23(v108.HealingRainCursor, not v15:IsInRange(40), v13:BuffDown(v107.SpiritwalkersGraceBuff)) or (3427 < 2849)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\21\54\118\71\30\48\69\92\17\62\116\14\24\50\123\66\25\57\125\79\31\50", "\26\46\112\87");
					end
				end
				if ((3616 <= 4429) and v111.AreUnitsBelowHealthPercentage(v57, v58) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\145\38\170\120\182\177\66\134\184\42\165", "\212\217\67\203\20\223\223\37")]:IsReady()) then
					if ((3988 >= 66) and (v56 == LUAOBFUSACTOR_DECRYPT_STR_0("\138\129\169\203\191\159", "\178\218\237\200"))) then
						if (v23(v108.HealingRainPlayer, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff)) or (862 > 4644)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\190\176\231\220\191\187\225\239\164\180\239\222\246\189\227\209\186\188\232\215\183\186\227", "\176\214\213\134");
						end
					elseif ((1221 == 1221) and (v56 == LUAOBFUSACTOR_DECRYPT_STR_0("\210\191\191\209\166\82\85\237\237\163\218\172\83\75\180\142\163\198\187\89\75", "\57\148\205\214\180\200\54"))) then
						if ((Mouseover:Exists() and not v13:CanAttack(Mouseover)) or (45 > 1271)) then
							if ((3877 > 1530) and v23(v108.HealingRainCursor, not v15:IsInRange(40), v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\26\248\52\56\127\28\250\10\38\119\27\243\117\60\115\19\241\60\58\113\19\242\48", "\22\114\157\85\84");
							end
						end
					elseif ((v56 == LUAOBFUSACTOR_DECRYPT_STR_0("\225\197\22\201\68\182\189\202\207\22\214\29\213\189\214\216\28\214", "\200\164\171\115\164\61\150")) or (4798 == 1255)) then
						if ((Mouseover:Exists() and v13:CanAttack(Mouseover)) or (2541 > 2860)) then
							if (v23(v108.HealingRainCursor, not v15:IsInRange(40), v13:BuffDown(v107.SpiritwalkersGraceBuff)) or (2902 > 3629)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\182\241\2\73\138\176\243\60\87\130\183\250\67\77\134\191\248\10\75\132\191\251\6", "\227\222\148\99\37");
							end
						end
					elseif ((427 < 3468) and (v56 == LUAOBFUSACTOR_DECRYPT_STR_0("\16\93\92\240\240\33\95\83\226\240\60\92", "\153\83\50\50\150"))) then
						if ((4190 >= 2804) and v23(v107.HealingRain, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\85\115\114\16\122\165\74\98\100\114\21\125\235\69\88\119\127\21\125\172\76\82\115", "\45\61\22\19\124\19\203");
						end
					end
				end
				v130 = 2;
			end
		end
	end
	local function v119()
		local v131 = 0;
		while true do
			if ((2086 == 2086) and (1 == v131)) then
				if ((4148 > 2733) and v47 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\98\168\229\55\77\42\85", "\78\48\193\149\67\36")]:IsReady() and v16:BuffDown(v107.Riptide)) then
					if ((3054 >= 1605) and (v16:HealthPercentage() <= v49) and (v111.UnitGroupRole(v16) == LUAOBFUSACTOR_DECRYPT_STR_0("\4\63\174\51", "\33\80\126\224\120"))) then
						if ((1044 < 1519) and v23(v108.RiptideFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\254\161\19\208\85\232\173\67\204\89\237\164\10\202\91\237\167\6", "\60\140\200\99\164");
						end
					end
				end
				if ((1707 <= 4200) and v47 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\181\253\20\50\171\131\241", "\194\231\148\100\70")]:IsReady() and v16:BuffDown(v107.Riptide)) then
					if ((580 == 580) and ((v16:HealthPercentage() <= v48) or (v16:HealthPercentage() <= v48))) then
						if ((601 <= 999) and v23(v108.RiptideFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\84\69\209\183\255\204\67\12\201\166\247\196\79\66\198\162\249\205", "\168\38\44\161\195\150");
						end
					end
				end
				v131 = 2;
			end
			if ((3970 == 3970) and (v131 == 0)) then
				if ((v107[LUAOBFUSACTOR_DECRYPT_STR_0("\14\19\58\65\131\180\202\34\23\36\81", "\162\75\114\72\53\235\231")]:IsReady() and v46 and v16:Exists() and not v16:IsDeadOrGhost() and v16:IsInRange(40) and (v111.UnitGroupRole(v16) == LUAOBFUSACTOR_DECRYPT_STR_0("\184\29\106\201", "\98\236\92\36\130\51")) and v16:BuffDown(v107.EarthShield)) or (98 == 208)) then
					if ((2006 <= 3914) and v23(v108.EarthShieldFocus)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\24\30\174\77\151\166\56\173\28\0\190\122\188\180\62\175\89\4\191\68\164\188\62\163\10\24", "\80\196\121\108\218\37\200\213");
					end
				end
				if ((v47 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\50\122\18\107\66\10\143", "\234\96\19\98\31\43\110")]:IsReady() and v16:BuffDown(v107.Riptide)) or (3101 <= 2971)) then
					if ((v16:HealthPercentage() <= v48) or (2073 <= 671)) then
						if ((3305 > 95) and v23(v108.RiptideFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\20\22\66\211\165\118\142\70\23\87\198\160\123\133\1\30\93\194", "\235\102\127\50\167\204\18");
						end
					end
				end
				v131 = 1;
			end
			if ((2727 == 2727) and (v131 == 2)) then
				if (v111.IsSoloMode() or (2970 >= 4072)) then
					if ((3881 > 814) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\172\245\133\126\36\230\191\24\135\207\138\127\53\228\178", "\118\224\156\226\22\80\136\214")]:IsReady() and v13:BuffDown(v107.LightningShield)) then
						if (v23(v107.LightningShield) or (4932 < 4868)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\78\231\94\136\86\224\80\142\69\209\74\136\75\235\85\132\2\230\92\129\78\231\87\135\81\250", "\224\34\142\57");
						end
					end
				elseif ((3667 <= 4802) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\233\166\209\216\97\194\85\7\219\171\193", "\110\190\199\165\189\19\145\61")]:IsReady() and v13:BuffDown(v107.WaterShield)) then
					if ((1260 >= 858) and v23(v107.WaterShield)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\205\234\99\237\153\248\201\227\126\237\135\195\154\227\114\233\135\206\212\236\100\252", "\167\186\139\23\136\235");
					end
				end
				if ((v52 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\50\176\137\1\19\187\143\62\15\167\143\8", "\109\122\213\232")]:IsReady()) or (3911 == 4700)) then
					if ((3000 < 4194) and (v16:HealthPercentage() <= v53)) then
						if ((651 < 4442) and v23(v108.HealingSurgeFocus, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\230\242\163\60\231\249\165\15\253\226\176\55\235\183\170\53\239\251\171\62\233\228\182", "\80\142\151\194");
						end
					end
				end
				v131 = 3;
			end
			if ((v131 == 3) or (195 >= 1804)) then
				if ((v50 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\43\195\118\64\10\200\112\123\2\208\114", "\44\99\166\23")]:IsReady()) or (1382 > 2216)) then
					if ((v16:HealthPercentage() <= v51) or (2861 == 2459)) then
						if ((1903 < 4021) and v23(v108.HealingWaveFocus, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\116\242\40\58\58\170\123\200\62\55\37\161\60\255\44\55\63\173\114\240\58\34", "\196\28\151\73\86\83");
						end
					end
				end
				break;
			end
		end
	end
	local function v120()
		local v132 = 0;
		while true do
			if ((1 == v132) or (2270 >= 4130)) then
				if ((2593 <= 3958) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\35\0\61\231\219\165\167\21\4\55\231", "\194\112\116\82\149\182\206")]:IsReady()) then
					if ((1176 == 1176) and v23(v107.Stormkeeper)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\188\67\10\205\233\11\60\184\73\10\128\230\15\52\169\75\29", "\110\89\200\44\120\160\130");
					end
				end
				if ((#v13:GetEnemiesInRange(40) < 3) or (3062 == 1818)) then
					if (v107[LUAOBFUSACTOR_DECRYPT_STR_0("\135\202\76\78\87\68\50\67\172\225\68\74\87", "\45\203\163\43\38\35\42\91")]:IsReady() or (3717 < 3149)) then
						if ((3195 < 3730) and v23(v107.LightningBolt, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\222\140\219\43\147\167\93\220\130\227\33\136\165\64\146\129\221\46\134\174\81", "\52\178\229\188\67\231\201");
						end
					end
				elseif ((2797 <= 3980) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\2\73\81\13\249\112\42\38\73\68\10\254\82\36", "\67\65\33\48\100\151\60")]:IsReady()) then
					if ((1944 <= 2368) and v23(v107.ChainLightning, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\239\175\209\253\224\235\167\223\251\203\233\167\214\244\159\227\175\213\242\216\226", "\147\191\135\206\184");
					end
				end
				break;
			end
			if ((1709 < 4248) and (0 == v132)) then
				if (v107[LUAOBFUSACTOR_DECRYPT_STR_0("\213\15\40\29\135\107\16\121\240\8", "\22\147\99\73\112\226\56\120")]:IsReady() or (3970 == 3202)) then
					if (v111.CastCycle(v107.FlameShock, v13:GetEnemiesInRange(40), v114, not v15:IsSpellInRange(v107.FlameShock), nil, nil, nil, nil) or (3918 >= 4397)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\190\121\227\248\136\135\102\234\250\142\179\74\225\236\142\180\112\162\241\140\181\116\229\240", "\237\216\21\130\149");
					end
				end
				if (v107[LUAOBFUSACTOR_DECRYPT_STR_0("\174\79\73\94\146\220\76\145\90", "\62\226\46\63\63\208\169")]:IsReady() or (780 == 3185)) then
					if (v23(v107.LavaBurst, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff)) or (3202 >= 4075)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\24\67\130\32\15\58\76\246\13\21\135\30\0\46\89\224", "\62\133\121\53\227\127\109\79");
					end
				end
				v132 = 1;
			end
		end
	end
	local function v121()
		local v133 = 0;
		while true do
			if ((64 == 64) and (v133 == 0)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\45\178\213\209\93\181\151", "\210\228\72\198\161\184\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\3\90\246\56\118\207\58\93\251\3\103\193\56\76", "\174\86\41\147\112\19")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\5\153\31\44\1\22\184", "\203\59\96\237\107\69\111\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\12\19\173\237\37\248\196\48\25\162\228\25\192", "\183\68\118\204\129\81\144")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\61\168\100\240\2\140\9\190", "\226\110\205\16\132\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\222\208\229\241\68\234\207\233\215\70\219\204\244\208\78\229", "\33\139\163\128\185")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\93\16\202\94\86\3\205", "\190\55\56\100")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\170\61\18\26\237\244\102\160\40\23\28\237\219\102", "\147\54\207\92\126\115\131")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\52\33\105\4\112\10\34", "\30\109\81\85\29\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\215\116\85\186\63\208\251\207\126\64\191\57\208\210\254\124\81", "\156\159\17\52\214\86\190")];
				v133 = 1;
			end
			if ((2202 >= 694) and (v133 == 1)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\157\234\169\168\167\225\186\175", "\220\206\143\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\124\35\19\212\201\243\128\123\33\30\219\216\215\130", "\178\230\29\77\119\184\172")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\198\187\30\15\126\246\242\173", "\152\149\222\106\123\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\39\248\71\185\216\15\248\64\186\207\54\249\81\176\220\42", "\213\189\70\150\35")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\124\80\96\28\70\91\115\27", "\104\47\53\20")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\69\146\12\185\3\135\73\131\9\186\9\176", "\111\195\44\225\124\220")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\235\67\20\103\162\165\223\85", "\203\184\38\96\19\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\122\106\81\203\53\81\108\71\200\42", "\174\89\19\25\33")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\23\70\90\254\137\12\60", "\107\79\114\50\46\151\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\16\168\161\44\152\43\162\208\45\145\188\61\130\10\163\213\55", "\160\89\198\213\73\234\89\215")];
				v133 = 2;
			end
			if ((3706 <= 3900) and (v133 == 8)) then
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\26\169\36\44\32\162\55\43", "\88\73\204\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\130\2\82\33\223\32\180\17\74\37\238\33\151\21\75\28\201\47\132\21", "\186\78\227\112\38\73")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\207\82\233\65\90\116\251\68", "\26\156\55\157\53\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\217\4\205\176\85\130\239\23\213\180\100\131\204\19\212\144\96", "\48\236\184\118\185\216")];
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\184\67\36\198\58\226\174", "\84\133\221\55\80\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\230\54\178\207\89\179\208\37\170\203\104\178\243\33\171\224\78\178\242\52", "\60\221\135\68\198\167")];
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\184\236\151\75\215\233\174", "\185\142\221\152\227\34")][LUAOBFUSACTOR_DECRYPT_STR_0("\124\202\64\244\83\60\226\74\240\68\251\68\54", "\151\56\165\55\154\35\83")];
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\147\70\17\250\169\77\2\253", "\142\192\35\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\122\62\173\247\131\185\4\254\69", "\118\182\21\73\195\135\236\204")];
				v133 = 9;
			end
			if ((2890 > 2617) and (v133 == 7)) then
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\73\246\232\126\244\75\241", "\23\154\44\130\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\182\164\188\63\7\61\175\163\165\2\28\5\163\160\134\6", "\115\113\198\205\206\86")];
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\82\234\78\141\89\249\73", "\58\228\55\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\153\217\60\53\185\25\189\135\219\26\51\185\48\185\174\194\33\41\189", "\85\212\233\176\78\92\205")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\93\156\246\67\86\143\241", "\130\42\56\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\166\33\203\69\62\230\188\42\228\116\54\238\176\16\236\84\58\231", "\95\138\213\68\131\32")];
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\45\181\87\127\36\47\178", "\22\74\72\193\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\124\229\84\37\119\227\108\37\125\225\108\35\109\225\85\4\73", "\56\76\25\132")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\109\196\191\50\198\80\198\184", "\175\62\161\203\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\216\194\31\60\50\218\247\26\49\57\233\204\7\48\49\250\209\28\32\44", "\85\92\189\163\115")];
				v133 = 8;
			end
			if ((v133 == 3) or (3355 > 4385)) then
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\63\255\100\238\52\236\99", "\16\135\90\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\102\125\22\39\71\80\125\96\117\8\56\102\100", "\24\52\20\102\83\46\52")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\42\53\48\6\202\40\50", "\111\164\79\65\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\202\134\246\43\235\202\208\141\217\25\235\208\220", "\138\166\185\227\190\78")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\113\209\35\91\45\30\216", "\121\171\20\165\87\50\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\238\61\184\58\176\12\193\15\184\32\188\42\246", "\98\166\88\217\86\217")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\243\109\21\143\210\241\229", "\188\150\150\25\97\230")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\154\90\42\9\236\214\128\81\5\63\248\200\142\90", "\141\186\233\63\98\108")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\239\56\162\44\255\237\63", "\69\145\138\76\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\88\202\136\133\182\24\119\252\156\155\184\19\88\255", "\118\16\175\233\233\223")];
				v133 = 4;
			end
			if ((6 == v133) or (3067 <= 2195)) then
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\251\25\231\241\217\234\237", "\183\141\158\109\147\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\31\25\239\30\37\29\241\13\32\2\227\30\63\46\244\13\47\12\193\30\35\28\246", "\108\76\105\134")];
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\216\192\165\245\199\229\194\162", "\174\139\165\209\129")][LUAOBFUSACTOR_DECRYPT_STR_0("\150\160\231\233\195\2\124\113\173\180\209\213\212\6\113\117\151\188\246\196\203", "\24\195\211\130\161\166\99\16")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\6\253\56\90\24\65\16", "\118\38\99\137\76\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\213\35\4\30\0\46\250\21\17\0\12\33\240\18\10\6\12\45\213\22", "\64\157\70\101\114\105")];
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\173\179\247\25\78\175\180", "\112\32\200\199\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\85\93\180\202\165\37\31\68\78\189\194\166\22\35\68\89\181\228\185\45\57\64", "\66\76\48\60\216\163\203")];
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\131\109\231\86\192\35\169", "\68\218\230\25\147\63\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\58\90\94\191\185\6\90\66\189\153\37\71\73\187\152\57\82\75\179", "\214\205\74\51\44")];
				v133 = 7;
			end
			if ((3025 >= 2813) and (v133 == 2)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\123\116\160\234\204\70\118\167", "\165\40\17\212\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\215\28\54\52\247\204\24\39\9\235\213\17\4\46\236\205\13\63\47\246\205", "\70\133\185\104\83")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\64\80\62\192\10\66\87", "\169\100\37\36\74")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\137\182\85\18\149\183\64\20\179\170\66\5\148\170\95\12\131", "\48\96\231\194")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\95\26\57\16\214\168\144", "\227\168\58\110\77\121\184\207")][LUAOBFUSACTOR_DECRYPT_STR_0("\78\47\186\101\176\201\101\173\72\52\182\69\189\223", "\197\27\92\223\32\209\187\17")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\90\215\239\10\81\196\232", "\155\99\63\163")][LUAOBFUSACTOR_DECRYPT_STR_0("\183\194\164\191\176\148\150\216\165\136", "\228\226\177\193\237\217")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\7\181\55\242\61\190\36\245", "\134\84\208\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\165\150\72\26\168\131\116\35", "\60\115\204\230")];
				v133 = 3;
			end
			if ((2412 >= 356) and (v133 == 5)) then
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\49\177\200\127\161\208\149", "\230\77\84\197\188\22\207\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\7\195\223\132\160\249\59\209\17\199\240", "\85\153\116\166\156\236\193\144")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\229\89\167\237\14\163\243", "\96\196\128\45\211\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\22\133\122\86\220\135\177\217\57\165\75", "\184\85\237\27\63\178\207\212")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\92\29\75\1\87\14\76", "\63\104\57\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\40\143\165\77\5\175\161\69\7\160\182\75\30\151", "\36\107\231\196")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\176\182\147\84\187\165\148", "\231\61\213\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\60\190\56\64\25\164\47\122\29\186\60\127\2\168\47\96\46\191\60\112\12", "\19\105\205\93")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\154\13\202\149\54\167\15\205", "\95\201\104\190\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\219\200\220\166\223\214\207\163\192\196\220\188\236\211\207\172\206\233\254", "\174\207\171\161")];
				v133 = 6;
			end
			if ((2070 > 1171) and (v133 == 9)) then
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\57\14\84\13\3\250\27", "\157\104\92\122\32\100\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\169\216\196\45\40\152\185\132\180\192\223\45", "\203\195\198\175\170\93\71\237")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\78\42\193\88\31\251\61", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\83\230\199\166\24\87\107\115\228\244\177\4\87\124\113\252\205\172\5\119\118\102\237\201\150\24\66\126\119", "\25\18\136\164\195\107\35")];
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\189\91\123\178\198\171", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\12\226\40\223\27\200\144\44\224\27\200\7\200\135\46\248\34\213\6\232\141\57\233\38\242\56", "\226\77\140\75\186\104\188")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\203\196\43\70\183\201\195", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\153\211\117\7\161\64\106\39\180\237\100\13\166\81\123\50\177\210\120\54\189\64\125\43\159\207\121\23\162", "\70\216\189\22\98\210\52\24")];
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\218\183\147\218\212\216\176", "\179\186\191\195\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\44\29\199\245\48\13\224\251\42\10\247\237\11\23\240\252\50", "\132\153\95\120")];
				break;
			end
			if ((v133 == 4) or (4108 < 3934)) then
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\129\33\175\231\133\122\152", "\29\235\228\85\219\142\235")][LUAOBFUSACTOR_DECRYPT_STR_0("\8\199\191\232\121\66\34\83\46\220\150\212\113\75", "\50\93\180\218\189\23\46\71")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\161\79\88\77\210\79\205", "\40\190\196\59\44\36\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\75\208\177\251\110\5\16\76\218\177\210\77", "\109\92\37\188\212\154\29")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\234\176\215\56\84\3\252", "\58\100\143\196\163\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\71\34\175\54\71\226\60\27\75\45\150\44\72\226\11", "\110\122\34\67\195\95\41\133")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\180\79\94\223\123\182\72", "\182\21\209\59\42")][LUAOBFUSACTOR_DECRYPT_STR_0("\159\82\196\17\40\176\176\101\196\20\47\150\135", "\222\215\55\165\125\65")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\212\210\14\251\207\234\89", "\42\76\177\166\122\146\161\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\141\143\4\194\112\120\162\184\4\199\119\81\183\133\16\222", "\22\197\234\101\174\25")];
				v133 = 5;
			end
		end
	end
	local function v122()
		local v134 = 0;
		while true do
			if ((3499 >= 3439) and (v134 == 5)) then
				v103 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\47\254\30\246\21\245\13\241", "\130\124\155\106")][LUAOBFUSACTOR_DECRYPT_STR_0("\229\217\255\162\172\228\120\182\212\199\193\174\181\243\73\172\212\204\243", "\223\181\171\150\207\195\150\28")];
				v104 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\63\247\186\0\66\61\240", "\105\44\90\131\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\207\242\187\180\7\44\251\233\179\181\63\63\233\229\154\137", "\94\159\128\210\217\104")];
				break;
			end
			if ((876 < 3303) and (v134 == 1)) then
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\185\38\96\143\59\124\152", "\235\26\220\82\20\230\85\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\191\164\229\206\103\152\179\224\204\115\175\179\230\215\100", "\20\232\193\137\162")];
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\218\209\178\238\130\16\98", "\17\66\191\165\198\135\236\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\58\188\171\50\241\235\233\194\27\189\175\31\216\253\229\213\14\161\173\22", "\177\111\207\206\115\159\136\140")];
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\140\4\0\221\65\88\22", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\53\238\23\235\34\209\58\225\53\237\63\199\58\227\17\253\30\243", "\86\163\91\141\114\152")];
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\14\96\103\51\93\12\103", "\90\51\107\20\19")][LUAOBFUSACTOR_DECRYPT_STR_0("\172\254\134\234\46\153\226\132\227\26\152\249\129\238\51\142\245\162\253\50\152\224", "\93\237\144\229\143")];
				v134 = 2;
			end
			if ((2922 <= 3562) and (v134 == 2)) then
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\38\243\228\13\2\72\18\229", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\168\235\27\62\184\235\52\41\186\224\57\40", "\90\77\219\142")];
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\1\53\45\69\9\125\245", "\26\134\100\65\89\44\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\240\51\38\170\245\226\62\32\161\217\211", "\196\145\131\80\67")];
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\181\18\28\17\230\25\163", "\136\126\208\102\104\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\89\153\205\70\161\86\60\95\123\143\233\81\160\71\45", "\49\24\234\174\35\207\50\93")];
				v95 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\247\233\156\120\2\245\238", "\17\108\146\157\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\126\208\17\192\46\166\74\247\29\233\42\156\68\215\17\224", "\200\43\163\116\141\79")];
				v134 = 3;
			end
			if ((2619 >= 1322) and (v134 == 4)) then
				v100 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\210\30\183\183\220\83\187", "\200\153\183\106\195\222\178\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\226\154\41\65\127\62\230\133\56\71\78\51\239\160\13", "\58\82\131\232\93\41")];
				v101 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\82\196\1\84\49\132\68", "\95\227\55\176\117\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\61\127\49\95\163\61\114\38\70\174\22\106\34\71\159\25\112\40\99\155", "\203\120\30\67\43")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\32\89\251\208\255\34\94", "\185\145\69\45\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\191\12\28\148\221\137\22\24\170\207", "\188\234\127\121\198")];
				v102 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\55\7\151\49\60\20\144", "\227\88\82\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\13\179\170\13\97\71\22\187\171\53\114\85\26\137\166\20\118\96\16\181\171\6\124\84\17\169", "\19\35\127\218\199\98")];
				v134 = 5;
			end
			if ((4133 >= 2404) and (v134 == 3)) then
				v96 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\140\51\41\151\185\250\228\172", "\131\223\86\93\227\208\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\206\68\184\183\41\188\231\64\130\185\9\176\238\104\183\184\28", "\213\131\37\214\214\125")];
				v97 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\21\46\49\171\232\40\44\54", "\129\70\75\69\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\216\246\200\111\251\84\202\255\218\116\230\64\223", "\143\38\171\147\137\28")];
				v98 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\135\173\231\10\237\211\195", "\180\176\226\217\147\99\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\170\59\21\210\181\28\15\218\191\59\47\227", "\103\179\217\79")];
				v99 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\178\8\193\72\130\164\89", "\195\42\215\124\181\33\236")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\74\50\27\36\234\25\81\18\50\32\245\8\87\35\63\41", "\152\109\57\87\94\69")];
				v134 = 4;
			end
			if ((v134 == 0) or (1433 == 2686)) then
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\183\26\57\254\212\167\162", "\192\209\210\110\77\151\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\195\15\45\252\251\198\245\17\49\253\203\203\244\6\47\193\207", "\164\128\99\66\137\159")];
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\51\140\253\170\9\135\238\173", "\222\96\233\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\154\191\168\10\140\241\229\171\160\179\43\135\231\245\180\148\181\16\157\227", "\144\217\211\199\127\232\147")];
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\42\42\60\220\75\5\87", "\36\152\79\94\72\181\37\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\203\66\8\210\212\75\44\199\202\78\49\208", "\95\183\184\39")];
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\58\243\50\93\142\5\166", "\98\213\95\135\70\52\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\201\166\197\123\71\238\177\192\121\83\214\147", "\52\158\195\169\23")];
				v134 = 1;
			end
		end
	end
	local function v123()
		local v135 = 0;
		local v136;
		while true do
			if ((v135 == 0) or (4123 == 4457)) then
				v121();
				v122();
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\246\1\184\83\122\234", "\26\48\153\102\223\63\31\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\79\238", "\147\98\32\141")];
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\44\76\228\205\10\83\88", "\43\120\35\131\170\102\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\87\2\148", "\228\52\102\231\214\197\208")];
				v135 = 1;
			end
			if ((3 == v135) or (3972 <= 205)) then
				if (v28 or v13:AffectingCombat() or (3766 < 1004)) then
					local v222 = 0;
					while true do
						if ((1784 < 2184) and (v222 == 1)) then
							if (v136 or (1649 > 4231)) then
								return v136;
							end
							if ((3193 == 3193) and v31) then
								local v229 = 0;
								while true do
									if ((v229 == 1) or (3495 > 4306)) then
										v136 = v119();
										if ((4001 > 3798) and v136) then
											return v136;
										end
										break;
									end
									if ((v229 == 0) or (4688 <= 4499)) then
										v136 = v118();
										if (v136 or (1567 <= 319)) then
											return v136;
										end
										v229 = 1;
									end
								end
							end
							v222 = 2;
						end
						if ((v222 == 2) or (4583 == 3761)) then
							if ((3454 > 1580) and v32) then
								if (v111.TargetIsValid() or (1607 == 20)) then
									local v234 = 0;
									while true do
										if ((0 == v234) or (962 >= 4666)) then
											v136 = v120();
											if (v136 or (1896 == 1708)) then
												return v136;
											end
											break;
										end
									end
								end
							end
							break;
						end
						if ((3985 >= 1284) and (v222 == 0)) then
							if (v30 or (1987 == 545)) then
								local v230 = 0;
								while true do
									if ((0 == v230) or (4896 < 1261)) then
										if ((23 < 3610) and v16 and v41) then
											if ((v107[LUAOBFUSACTOR_DECRYPT_STR_0("\244\216\85\53\244\23\198\212\196\85\53\230", "\149\164\173\39\92\146\110")]:IsReady() and v111.DispellableFriendlyUnit()) or (3911 < 2578)) then
												if (v23(v108.PurifySpirit) or (4238 < 87)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\227\50\2\22\28\2\204\52\0\22\8\18\231\103\20\22\9\11\246\43", "\123\147\71\112\127\122");
												end
											end
										end
										if ((2538 == 2538) and v42) then
											if ((4122 == 4122) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\252\216\144\118\67", "\38\172\173\226\17")]:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v111.UnitHasMagicBuff(v15)) then
												if (v23(v107.Purge, not v15:IsSpellInRange(v107.Purge)) or (2371 > 2654)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\93\4\62\232\72\81\40\230\94\1\41\227", "\143\45\113\76");
												end
											end
										end
										break;
									end
								end
							end
							v136 = v116();
							v222 = 1;
						end
					end
				end
				break;
			end
			if ((v135 == 2) or (3466 > 4520)) then
				if (v13:AffectingCombat() or v28 or (951 >= 1027)) then
					local v223 = 0;
					local v224;
					while true do
						if ((v223 == 1) or (1369 > 2250)) then
							if (not v16:BuffRefreshable(v107.EarthShield) or (v111.UnitGroupRole(v16) ~= LUAOBFUSACTOR_DECRYPT_STR_0("\135\247\227\234", "\37\211\182\173\161\169\193")) or not v46 or (937 > 3786)) then
								local v231 = 0;
								while true do
									if ((v231 == 0) or (901 > 4218)) then
										ShouldReturn = v111.FocusUnit(v224, nil, nil, nil);
										if ((4779 > 4047) and ShouldReturn) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							break;
						end
						if ((4050 > 1373) and (0 == v223)) then
							v224 = v41 and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\177\211\67\251\207\69\178\214\88\224\192\72", "\60\225\166\49\146\169")]:IsReady() and v30;
							if ((v107[LUAOBFUSACTOR_DECRYPT_STR_0("\10\31\61\62\9\52\39\23\42\38\5", "\103\79\126\79\74\97")]:IsReady() and v46) or (1037 > 4390)) then
								local v232 = 0;
								while true do
									if ((1407 <= 1919) and (v232 == 0)) then
										ShouldReturn = v111.FocusUnitRefreshableBuff(v107.EarthShield, 15, 40, LUAOBFUSACTOR_DECRYPT_STR_0("\142\94\253\88", "\122\218\31\179\19\62"));
										if ((2526 >= 1717) and ShouldReturn) then
											return ShouldReturn;
										end
										break;
									end
								end
							end
							v223 = 1;
						end
					end
				end
				v136 = nil;
				if ((not v13:AffectingCombat() and v28) or (3620 <= 2094)) then
					if ((v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v13:CanAttack(v15)) or (1723 >= 2447)) then
						local v227 = 0;
						local v228;
						while true do
							if ((v227 == 0) or (1199 > 3543)) then
								v228 = v111.DeadFriendlyUnitsCount();
								if ((1617 < 3271) and v13:AffectingCombat()) then
									if ((3085 > 1166) and (v228 > 1)) then
										if ((4493 >= 3603) and v23(v107.AncestralVision, nil, v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
											return LUAOBFUSACTOR_DECRYPT_STR_0("\246\52\78\220\59\111\171\246\54\114\207\33\104\176\248\52", "\217\151\90\45\185\72\27");
										end
									elseif ((2843 <= 2975) and v23(v107.AncestralSpirit, not v15:IsInRange(40), v13:BuffDown(v107.SpiritwalkersGraceBuff))) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\194\114\228\23\69\215\110\230\30\105\208\108\238\0\95\215", "\54\163\28\135\114");
									end
								end
								break;
							end
						end
					end
				end
				if ((v13:AffectingCombat() and v111.TargetIsValid()) or (1989 <= 174)) then
					local v225 = 0;
					local v226;
					while true do
						if ((v225 == 3) or (209 > 2153)) then
							v136 = v115();
							if (v136 or (2020 == 1974)) then
								return v136;
							end
							v136 = v117();
							v225 = 4;
						end
						if ((v225 == 4) or (1347 == 1360)) then
							if (v136 or (4461 == 3572)) then
								return v136;
							end
							if (not v102 or v29 or (2872 == 318)) then
								local v233 = 0;
								while true do
									if ((568 == 568) and (v233 == 0)) then
										if ((4200 == 4200) and ((v103 == LUAOBFUSACTOR_DECRYPT_STR_0("\10\212\73\138", "\31\72\187\61\226\46")) or (v103 == LUAOBFUSACTOR_DECRYPT_STR_0("\231\3\69\215\73\109\45\213\3", "\68\163\102\35\178\39\30")))) then
											if ((v16:HealthPercentage() < v104) or (4285 < 1369)) then
												if (v107[LUAOBFUSACTOR_DECRYPT_STR_0("\142\98\211\202\12\167\135\24\191\124\237\198\21\176", "\113\222\16\186\167\99\213\227")]:IsReady() or (3520 > 4910)) then
													if ((2842 <= 4353) and v23(v108.PrimordialWaveFocus)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\62\28\242\251\33\28\255\255\47\2\196\225\47\24\254\182\35\15\242\248", "\150\78\110\155");
													end
												end
											end
										end
										if ((v103 == LUAOBFUSACTOR_DECRYPT_STR_0("\167\202\51\233", "\32\229\165\71\129\196\126\223")) or (v103 == LUAOBFUSACTOR_DECRYPT_STR_0("\236\143\194\132\143\198\202\159\193", "\181\163\233\164\225\225")) or (3751 < 1643)) then
											if ((v15:DebuffRefreshable(v107.FlameShock) and (v106 > 10)) or (4911 == 3534)) then
												if ((3001 > 16) and v107[LUAOBFUSACTOR_DECRYPT_STR_0("\96\153\55\122\95\153\58\126\81\135\9\118\70\142", "\23\48\235\94")]:IsReady()) then
													if ((2875 <= 3255) and v23(v107.PrimordialWave)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\108\200\209\80\88\33\214\117\219\212\98\64\50\196\121\154\213\92\94\61", "\178\28\186\184\61\55\83");
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
						if ((368 < 4254) and (v225 == 2)) then
							if (v226 or (4841 <= 2203)) then
								return v226;
							end
							v226 = v111.InterruptWithStunCursor(v107.CapacitorTotem, v108.CapacitorTotemCursor, 30, nil, Mouseover);
							if ((4661 > 616) and v226) then
								return v226;
							end
							v225 = 3;
						end
						if ((v225 == 0) or (1943 == 2712)) then
							v105 = v10.BossFightRemains(nil, true);
							v106 = v105;
							if ((4219 >= 39) and (v106 == 11111)) then
								v106 = v10.FightRemains(Enemies10ySplash, false);
							end
							v225 = 1;
						end
						if ((3967 > 2289) and (v225 == 1)) then
							v226 = v111.Interrupt(v107.WindShear, 30, true);
							if (v226 or (851 > 2987)) then
								return v226;
							end
							v226 = v111.InterruptCursor(v107.WindShear, v108.WindShearMouseover, 30, true, Mouseover);
							v225 = 2;
						end
					end
				end
				v135 = 3;
			end
			if ((4893 >= 135) and (v135 == 1)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\239\114\205\230\142\10", "\182\126\128\21\170\138\235\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\143\211\38\246\131\31", "\102\235\186\85\134\230\115\80")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\3\57\88\126\209\49", "\66\55\108\94\63\18\180")][LUAOBFUSACTOR_DECRYPT_STR_0("\28\136\132\59\46\87\19", "\57\116\237\229\87\71")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\190\234\224\123\235\84", "\39\202\209\141\135\23\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\35\26", "\152\159\83\105\106\82")];
				if (v13:IsDeadOrGhost() or (3084 > 3214)) then
					return;
				end
				v135 = 2;
			end
		end
	end
	local function v124()
		local v137 = 0;
		while true do
			if ((v137 == 0) or (3426 < 2647)) then
				v113();
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\138\189\15\40\183\170\29\40\177\183\18\124\139\176\29\49\185\182\92\46\183\172\29\40\177\183\18\124\186\161\92\25\168\177\31\114", "\92\216\216\124"));
				v137 = 1;
			end
			if ((v137 == 1) or (1576 == 4375)) then
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\105\55\191\84\242\73\51\184\73\242\85\114\159\72\252\86\51\162\0\197\27\36\236\17\173\21\96\226\16\173\27\16\181\0\223\84\61\161\107", "\157\59\82\204\32"));
				break;
			end
		end
	end
	v21.SetAPL(264, v123, v124);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\29\46\234\226\214\217\219\176\53\63\237\197\219\239\192\165\55\13\235\251\228\235\221\255\52\43\226", "\209\88\94\131\154\137\138\179")]();

