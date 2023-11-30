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
		if ((v5 == 0) or (2561 < 1497)) then
			v6 = v0[v4];
			if (not v6 or (816 > 1712)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (2733 == 2971)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\136\207\31\220\194\213\26\195\181\207\31\223\192\222\40\227\181\211\80\221\214\218", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v14 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v12[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\207\71\162\74\240", "\38\156\55\199")];
	local v17 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\133\104\112\60\26\71\234\70\164\113", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\48\171\212\210", "\84\121\223\177\191\237\76")];
	local v19 = EpicLib;
	local v20 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\152\87\218\180", "\161\219\54\169\192\90\48\80")];
	local v21 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\100\67\3\55\70", "\69\41\34\96")];
	local v22 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\140\209\210\25\17", "\75\220\163\183\106\98")];
	local v23 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\33\181\134\58\214\12\169", "\185\98\218\235\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\238\42\34\244\199\165\197\57", "\202\171\92\71\134\190")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\212\33", "\232\73\161\76")];
	local v24 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\230\37\199", "\167\214\137\74\171\120\206\83")];
	local v25 = GetWeaponEnchantInfo;
	local v26 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\134\241\42", "\199\235\144\82\61\152")];
	local v27 = string[LUAOBFUSACTOR_DECRYPT_STR_0("\10\23\173\40\15", "\75\103\118\217")];
	local v28;
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
	local v60;
	local v61;
	local v62;
	local v63;
	local v34;
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
	local v98 = v16[LUAOBFUSACTOR_DECRYPT_STR_0("\244\92\113\25\184\16", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\32\40\129\186\26\249\197\43\46\148", "\156\168\78\64\224\212\121")];
	local v99 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\52\230\164\195\6\224", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\38\87\57\43\93\253\91\45\81\44", "\152\54\72\63\88\69\62")];
	local v100 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\231\204\239\81\213\202", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\80\13\40\41\238\23\85\91\11\61", "\114\56\62\101\73\71\141")];
	local v101 = {};
	local v102, v103;
	local v104, v105;
	local v106, v107, v108, v109;
	local v110 = (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\148\232\205\197\154\252\201\215\172", "\164\216\137\187")]:IsAvailable() and 2) or 1;
	local v111 = LUAOBFUSACTOR_DECRYPT_STR_0("\254\239\54\186\178\240\2\220\225\113\144\169\242\31", "\107\178\134\81\210\198\158");
	local v112 = 11111;
	local v113 = 11111;
	v10:RegisterForEvent(function()
		v110 = (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\20\15\148\199\136\45\28\145\210", "\202\88\110\226\166")]:IsAvailable() and 2) or 1;
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\240\63\167\219\230\240\48\161\223\235\237\40\167\211", "\170\163\111\226\151"), LUAOBFUSACTOR_DECRYPT_STR_0("\61\21\147\10\96\18\13\46\3\130\29\98\27\22\56\30\141\12\111\21", "\73\113\80\210\88\46\87"));
	v10:RegisterForEvent(function()
		local v141 = 0;
		while true do
			if ((2599 < 4050) and (v141 == 0)) then
				v111 = LUAOBFUSACTOR_DECRYPT_STR_0("\173\37\202\26\243\143\37\195\21\167\163\35\193\6", "\135\225\76\173\114");
				v112 = 11111;
				v141 = 1;
			end
			if ((2034 == 2034) and (v141 == 1)) then
				v113 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\42\193\153\137\137\143\152\40\200\159\149\130\130\130\52\204\154\156\137\153", "\199\122\141\216\208\204\221"));
	local v114 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\142\210\29\253\119\248\190", "\150\205\189\112\144\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\146\186\94\29\135\31\21", "\112\69\228\223\44\100\232\113")];
	local function v115()
		if ((3040 < 4528) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\247\19\2\210\184\111\131\231\15\14\193\191\104", "\230\180\127\103\179\214\28")]:IsAvailable()) then
			v114[LUAOBFUSACTOR_DECRYPT_STR_0("\168\12\76\86\225\77\236\141\7\83\67\192\68\226\153\3\89\85", "\128\236\101\63\38\132\33")] = v114[LUAOBFUSACTOR_DECRYPT_STR_0("\136\160\2\84\179\231\195\173\171\29\65\149\254\221\191\172\53\65\180\254\201\170\186", "\175\204\201\113\36\214\139")];
		end
	end
	v10:RegisterForEvent(function()
		v115();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\102\239\1\245\50\98\243\5\240\37\126\233\7\227\55\119\233\22\245\37\107\229\15\253\48\110\227\27\227\39\111\237\27\251\33\99", "\100\39\172\85\188"));
	local function v116()
		for v165 = 1, 6, 1 do
			if (v27(v14:TotemName(v165), LUAOBFUSACTOR_DECRYPT_STR_0("\153\119\173\133\62", "\83\205\24\217\224")) or (2092 <= 2053)) then
				return v165;
			end
		end
	end
	local function v117()
		local v142 = 0;
		local v143;
		while true do
			if ((2120 < 4799) and (v142 == 0)) then
				if (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\199\201\221\53\231\242\194\49\224", "\93\134\165\173")]:IsAvailable() or v14:BuffDown(v98.FeralSpiritBuff) or (4538 <= 389)) then
					return 0;
				end
				v143 = mathmin(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\157\224\192\209\50\226\187\121\182\230\207\203\52\201", "\30\222\146\161\162\90\174\210")]:TimeSinceLastCast(), v98[LUAOBFUSACTOR_DECRYPT_STR_0("\198\70\113\3\235\98\121\13\237\90\126\3\235\73", "\106\133\46\16")]:TimeSinceLastCast());
				v142 = 1;
			end
			if ((270 <= 1590) and (v142 == 1)) then
				if ((1625 > 1265) and ((v143 > 8) or (v143 > v98[LUAOBFUSACTOR_DECRYPT_STR_0("\126\37\97\253\86\115\72\41\97\245\78", "\32\56\64\19\156\58")]:TimeSinceLastCast()))) then
					return 0;
				end
				return 8 - v143;
			end
		end
	end
	local function v118(v144)
		return (v144:DebuffRefreshable(v98.FlameShockDebuff));
	end
	local function v119(v145)
		return (v145:DebuffRefreshable(v98.LashingFlamesDebuff));
	end
	local function v120(v146)
		return (v146:DebuffRemains(v98.FlameShockDebuff));
	end
	local function v121(v147)
		return (v14:BuffDown(v98.PrimordialWaveBuff));
	end
	local function v122(v148)
		return (v15:DebuffRemains(v98.LashingFlamesDebuff));
	end
	local function v123(v149)
		return (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\118\201\246\94\83\252\135\124\196\228\91\95\225", "\224\58\168\133\54\58\146")]:IsAvailable());
	end
	local function v124(v150)
		return v150:DebuffUp(v98.FlameShockDebuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\127\90\74\240\112\181\143\4\90\93\111\248\119\147\129\13", "\107\57\54\43\157\21\230\231")]:AuraActiveCount() < v108) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\253\135\16\248\188\239\199\212\136\26\209\188\222\218\221\141", "\175\187\235\113\149\217\188")]:AuraActiveCount() < 6);
	end
	local function v125()
		if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\31\163\132\77\237\106\125\15\191\136\94\234\109", "\24\92\207\225\44\131\25")]:IsReady() and v33 and v114.DispellableFriendlyUnit(25)) or (51 >= 920)) then
			if (v22(v100.CleanseSpiritFocus) or (2968 <= 1998)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\72\223\189\77\21\110\78\236\171\92\18\111\66\199\248\72\18\110\91\214\180", "\29\43\179\216\44\123");
			end
		end
	end
	local function v126()
		local v151 = 0;
		while true do
			if ((v151 == 0) or (3085 <= 2742)) then
				if (not Focus or not Focus:Exists() or not Focus:IsInRange(40) or (376 >= 2083)) then
					return;
				end
				if ((4191 > 1232) and Focus) then
					if (((Focus:HealthPercentage() <= v79) and v69 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\149\220\33\64\180\215\39\127\168\203\39\73", "\44\221\185\64")]:IsReady() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) or (1505 > 4873)) then
						if ((3880 < 4534) and v22(v100.HealingSurgeFocus)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\9\226\73\83\122\15\224\119\76\102\19\224\77\31\123\4\230\68\31\117\14\228\93\76", "\19\97\135\40\63");
						end
					end
				end
				break;
			end
		end
	end
	local function v127()
		if ((v14:HealthPercentage() <= v83) or (2368 >= 2541)) then
			if (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\134\89\50\55\38\63\169\111\38\41\40\52", "\81\206\60\83\91\79")]:IsReady() or (4733 <= 4103)) then
				if (v22(v98.HealingSurge) or (1207 == 4273)) then
					return LUAOBFUSACTOR_DECRYPT_STR_0("\70\174\209\126\38\205\74\155\93\190\194\117\42\131\69\161\79\167\144\125\32\192", "\196\46\203\176\18\79\163\45");
				end
			end
		end
	end
	local function v128()
		local v152 = 0;
		while true do
			if ((0 == v152) or (2005 == 2529)) then
				if ((986 < 3589) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\153\49\106\12\37\247\220\176\43\120\10", "\143\216\66\30\126\68\155")]:IsReady() and v66 and (v14:HealthPercentage() <= v74)) then
					if (v22(v98.AstralShift) or (3119 == 430)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\219\25\217\196\175\232\242\162\193\11\223\133\167\210\231\175\198\30\194\211\166\151\176", "\129\202\168\109\171\165\195\183");
					end
				end
				if ((2409 <= 3219) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\3\86\52\221\205\0\244\35\84\16\205\215\16\231\44\91\50", "\134\66\56\87\184\190\116")]:IsReady() and v67 and v114.AreUnitsBelowHealthPercentage(v75, v76)) then
					if (v22(v98.AncestralGuidance) or (898 > 2782)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\63\10\190\10\255\51\52\48\14\14\174\16\239\32\59\63\52\73\191\28\237\36\59\47\56\31\190\89\185", "\85\92\81\105\219\121\139\65");
					end
				end
				v152 = 1;
			end
			if ((v152 == 1) or (2250 <= 1764)) then
				if ((693 == 693) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\213\182\81\73\117\209\250\128\68\87\121\222\240\135\95\81\121\210", "\191\157\211\48\37\28")]:IsReady() and v68 and v114.AreUnitsBelowHealthPercentage(v77, v78)) then
					if (v22(v98.HealingStreamTotem) or (2529 == 438)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\215\26\245\16\51\209\24\203\15\46\205\26\245\17\5\203\16\224\25\55\159\27\241\26\63\209\12\253\10\63\159\76", "\90\191\127\148\124");
					end
				end
				if ((1751 > 1411) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\80\130\47\27\113\137\41\36\109\149\41\18", "\119\24\231\78")]:IsReady() and v69 and (v14:HealthPercentage() <= v79) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) then
					if ((4182 == 4182) and v22(v98.HealingSurge)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\138\40\164\70\213\78\22\189\62\176\88\219\69\81\134\40\163\79\210\83\24\148\40\229\30", "\113\226\77\197\42\188\32");
					end
				end
				v152 = 2;
			end
			if ((v152 == 2) or (4666 <= 611)) then
				if ((v99[LUAOBFUSACTOR_DECRYPT_STR_0("\18\19\245\185\46\30\231\161\53\24\241", "\213\90\118\148")]:IsReady() and v70 and (v14:HealthPercentage() <= v80)) or (4737 <= 4525)) then
					if ((4367 >= 3735) and v22(v100.Healthstone)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\43\181\90\89\83\61\160\89\67\94\110\176\83\75\94\32\167\95\91\94\110\231", "\45\59\78\212\54");
					end
				end
				if ((2426 == 2426) and v71 and (v14:HealthPercentage() <= v81)) then
					local v225 = 0;
					while true do
						if ((21 < 1971) and (v225 == 0)) then
							if ((v92 == LUAOBFUSACTOR_DECRYPT_STR_0("\34\83\133\153\131\61\165\249\30\81\195\163\131\47\161\249\30\81\195\187\137\58\164\255\30", "\144\112\54\227\235\230\78\205")) or (2922 <= 441)) then
								if ((3624 >= 1136) and v99[LUAOBFUSACTOR_DECRYPT_STR_0("\129\45\9\238\213\72\187\33\1\251\248\94\178\36\6\242\215\107\188\60\6\243\222", "\59\211\72\111\156\176")]:IsReady()) then
									if ((2043 < 2647) and v22(v100.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\92\130\229\63\75\148\235\36\64\128\163\37\75\134\239\36\64\128\163\61\65\147\234\34\64\199\231\40\72\130\237\62\71\145\230\109\26", "\77\46\231\131");
									end
								end
							end
							if ((v92 == "Dreamwalker's Healing Potion") or (354 >= 1534)) then
								if (v99[LUAOBFUSACTOR_DECRYPT_STR_0("\158\70\179\65\183\67\183\76\177\81\164\83\146\81\183\76\179\90\177\112\181\64\191\79\180", "\32\218\52\214")]:IsReady() or (3764 >= 4876)) then
									if ((3676 >= 703) and v22(v100.RefreshingHealingPotion)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\74\5\52\169\252\167\68\86\69\18\35\187\177\184\64\91\66\30\63\175\177\160\74\78\71\24\63\232\245\181\67\95\64\4\56\190\244", "\58\46\119\81\200\145\208\37");
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
	local function v129()
		local v153 = 0;
		while true do
			if ((3811 > 319) and (0 == v153)) then
				v28 = v114.HandleTopTrinket(v101, v31, 40, nil);
				if ((47 < 1090) and v28) then
					return v28;
				end
				v153 = 1;
			end
			if ((v153 == 1) or (1371 >= 2900)) then
				v28 = v114.HandleBottomTrinket(v101, v31, 40, nil);
				if (v28 or (1126 <= 504)) then
					return v28;
				end
				break;
			end
		end
	end
	local function v130()
		local v154 = 0;
		while true do
			if ((v154 == 1) or (3732 == 193)) then
				if ((3344 >= 3305) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\136\33\164\70\240\94\16\13\191", "\105\204\78\203\43\167\55\126")]:IsCastable() and v53 and ((v58 and v31) or not v58)) then
					if (v22(v98.DoomWinds, not v15:IsSpellInRange(v98.DoomWinds)) or (2885 < 1925)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\165\44\19\44\19\206\95\161\185\99\14\1\1\196\94\168\168\34\10\83\92", "\49\197\202\67\126\115\100\167");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\4\78\209\45\133\68\87\57\92", "\62\87\59\191\73\224\54")]:IsReady() and v47 and ((v59 and v32) or not v59)) or (4542 <= 1594)) then
					if ((338 <= 3505) and v22(v98.Sundering, not v15:IsInRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\244\23\244\205\226\16\243\199\224\66\234\219\226\1\245\196\229\3\238\137\182\82", "\169\135\98\154");
					end
				end
				v154 = 2;
			end
			if ((69 == 69) and (v154 == 2)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\248\99\43\70\240\32\220\217\126\47\81", "\168\171\23\68\52\157\83")]:IsReady() and v46) or (672 == 368)) then
					if ((1019 == 1019) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\231\101\250\191\40\62\147\230\120\254\168\101\61\149\241\114\250\160\39\44\147\180\32\167", "\231\148\17\149\205\69\77");
					end
				end
				break;
			end
			if ((v154 == 0) or (290 > 2746)) then
				if ((1923 < 4601) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\28\133\62\168\175\168\36\50\184\63\184\172\176", "\86\75\236\80\204\201\221")]:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\69\72\121\129\248\158\96\88\67\138\234\142\127", "\235\18\33\23\229\158")]:TimeSinceLastCast() > 90))) then
					if (v22(v98.WindfuryTotem) or (3957 == 2099)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\71\179\207\191\86\175\211\162\111\174\206\175\85\183\129\171\66\191\194\180\93\184\192\175\16\238", "\219\48\218\161");
					end
				end
				if ((4006 > 741) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\194\116\110\72\215\124\240\237\99\117\93", "\128\132\17\28\41\187\47")]:IsCastable() and v52 and ((v57 and v31) or not v57)) then
					if ((2359 <= 3733) and v22(v98.FeralSpirit)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\55\20\59\81\62\33\22\51\79\8\38\70\42\79\4\49\9\55\95\0\38\70\108", "\61\97\82\102\90");
					end
				end
				v154 = 1;
			end
		end
	end
	local function v131()
		local v155 = 0;
		while true do
			if ((v155 == 4) or (4596 <= 2402)) then
				if ((2078 > 163) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\38\97\13\108\95\61\130\15\112\9", "\234\96\19\98\31\43\110")]:IsReady() and v40 and (v14:BuffUp(v98.HailstormBuff))) then
					if ((4116 > 737) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\13\93\212\184\77\152\14\16\81\204\236\97\130\8\24\94\194\236\32\218", "\235\102\127\50\167\204\18");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\124\160\227\34\104\47\67\169", "\78\48\193\149\67\36")]:IsReady() and v43) or (1175 > 4074)) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (1361 == 4742)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\31\150\25\126\60\31\147\16\1\35\23\142\31\77\53\94\210\74", "\33\80\126\224\120");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\197\171\6\247\72\254\161\8\193", "\60\140\200\99\164")]:IsReady() and v41) or (4012 >= 4072)) then
					if ((3807 >= 1276) and v22(v98.IceStrike, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\142\247\1\25\177\147\230\13\45\167\199\231\13\40\165\139\241\68\116\241", "\194\231\148\100\70");
					end
				end
				if ((2220 <= 4361) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\113\69\207\167\229\220\84\69\202\166", "\168\38\44\161\195\150")]:IsCastable() and v49) then
					if ((228 == 228) and v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\245\140\114\35\252\164\31\139\249\194\101\57\230\177\26\133\188\208\34", "\118\224\156\226\22\80\136\214");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\113\250\86\146\79\253\77\146\75\229\92", "\224\34\142\57")]:IsReady() and v46) or (4118 <= 3578)) then
					if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or (2915 < 1909)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\205\179\202\207\126\226\73\28\215\172\192\157\96\248\83\9\210\162\133\143\38", "\110\190\199\165\189\19\145\61");
					end
				end
				v155 = 5;
			end
			if ((634 <= 2275) and (v155 == 7)) then
				if ((1091 <= 2785) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\200\120\90\178\48\203\238\230\69\91\162\51\211", "\156\159\17\52\214\86\190")]:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\153\230\179\184\168\250\175\165\154\224\169\185\163", "\220\206\143\221")]:TimeSinceLastCast() > 90))) then
					if ((4638 >= 2840) and v22(v98.WindfuryTotem)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\145\116\35\19\222\217\192\159\66\57\24\204\201\223\198\110\36\25\223\192\215\198\46\123", "\178\230\29\77\119\184\172");
					end
				end
				break;
			end
			if ((v155 == 1) or (1292 > 4414)) then
				if ((3511 == 3511) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\2\150\115\174\60\145\104\174\56\137\121", "\220\81\226\28")]:IsReady() and v46 and (v14:BuffUp(v98.DoomWindsBuff) or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\55\208\135\235\230\222\33\218\141\239\239\195\54\217\135\246\239\201\7\198", "\167\115\181\226\155\138")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\209\54\232\78\118\115\202\227\49\243", "\166\130\66\135\60\27\17")]:IsAvailable() and v14:BuffUp(v98.StormbringerBuff)))) then
					if ((2132 == 2132) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\87\94\193\103\61\87\94\220\124\59\65\10\221\124\62\67\70\203\53\102", "\80\36\42\174\21");
					end
				end
				if ((932 <= 3972) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\98\17\33\123\98\17\36\114", "\26\46\112\87")]:IsReady() and v43 and (v14:BuffUp(v98.HotHandBuff))) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (4560 <= 2694)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\181\34\189\117\128\179\68\167\177\99\184\125\177\184\73\177\249\116", "\212\217\67\203\20\223\223\37");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\141\132\166\214\188\152\186\203\142\130\188\215\183", "\178\218\237\200")]:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true))) or (2531 >= 3969)) then
					if (v22(v98.WindfuryTotem) or (738 > 2193)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\188\232\212\176\160\244\201\137\161\233\196\179\184\166\195\191\187\225\220\179\245\190", "\176\214\213\134");
					end
				end
				if ((4606 >= 3398) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\209\161\179\217\173\88\77\245\161\148\216\169\69\77", "\57\148\205\214\180\200\54")]:IsReady() and v37 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\55\241\48\57\115\28\233\52\56\84\30\252\38\32", "\22\114\157\85\84")]:Charges() == v110)) then
					if ((1853 > 1742) and v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\193\199\22\201\88\248\188\197\199\44\198\81\247\187\208\139\0\205\83\241\164\193\139\74", "\200\164\171\115\164\61\150");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\146\253\4\77\151\176\253\13\66\161\177\248\23", "\227\222\148\99\37")]:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 8) and v14:BuffUp(v98.PrimordialWaveBuff) and (v14:BuffDown(v98.SplinteredElementsBuff) or (v113 <= 12))) or (2442 > 2564)) then
					if ((4374 >= 4168) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\91\85\254\237\61\91\92\241\198\49\93\94\226\185\32\91\92\241\245\54\18\3\166", "\153\83\50\50\150");
					end
				end
				v155 = 2;
			end
			if ((v155 == 0) or (4576 > 4938)) then
				if ((2930 > 649) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\176\181\206\246\88\237\132\174\198\247\96\254\150\162", "\159\224\199\167\155\55")]:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and v15:DebuffDown(v98.FlameShockDebuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\219\242\47\218\254\253\59\244\251\242\49\215\228", "\178\151\147\92")]:IsAvailable()) then
					if (v22(v98.PrimordialWave, not v15:IsSpellInRange(v98.PrimordialWave)) or (1394 < 133)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\156\239\69\63\29\94\126\133\252\64\13\5\77\108\137\189\95\59\28\75\118\137\189\29", "\26\236\157\44\82\114\44");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\12\34\212\86\47\29\221\84\41\37", "\59\74\78\181")]:IsReady() and v39 and v15:DebuffDown(v98.FlameShockDebuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\208\73\82\186\43\214\124\86\178\40\212\73", "\211\69\177\58\58")]:IsAvailable()) or (432 == 495)) then
					if ((66 < 1456) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\233\120\248\236\244\164\237\118\246\226\139\164\236\119\242\229\206\247\183", "\171\215\133\25\149\137");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\196\196\55\247\234\62\232\67\237\234\62\251\252\36", "\34\129\168\82\154\143\80\156")]:IsReady() and v37 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\160\190\54\6\77\64\157\132\190\0\27\65\92\128\145\161", "\233\229\210\83\107\40\46")]:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff)) or (878 >= 3222)) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or (254 >= 3289)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\78\55\219\0\207\86\51\218\58\195\78\51\197\17\129\81\59\216\2\205\71\114\133", "\101\161\34\82\182");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\219\24\87\250\222\240\139\32\239", "\78\136\109\57\158\187\130\226")]:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113) and (v14:HasTier(30, 2))) or (2711 <= 705)) then
					if (v22(v98.Sundering, not v15:IsInRange(5)) or (2506 >= 3366)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\45\42\247\245\59\45\240\255\57\127\234\248\48\56\245\244\126\107", "\145\94\95\153");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\209\196\19\221\90\185\244\195\19\247\65\187\233", "\215\157\173\116\181\46")]:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v14:BuffDown(v98.CracklingThunderBuff) and v14:BuffUp(v98.AscendanceBuff) and (v111 == LUAOBFUSACTOR_DECRYPT_STR_0("\22\188\138\251\212\117\152\130\245\210\33\186\130\252\221", "\186\85\212\235\146")) and (v14:BuffRemains(v98.AscendanceBuff) > (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\225\137\23\247\55\194\81\197\137\2\240\48\224\95", "\56\162\225\118\158\89\142")]:CooldownRemains() + v14:GCD()))) or (123 > 746)) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or (4444 <= 894)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\80\12\199\167\54\214\85\11\199\144\32\215\80\17\128\188\43\214\91\9\197\239\119", "\184\60\101\160\207\66");
					end
				end
				v155 = 1;
			end
			if ((1376 > 583) and (v155 == 3)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\110\209\252\232\35\210\90\202\244\233\27\193\72\198", "\160\62\163\149\133\76")]:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113)) or (2427 == 2455)) then
					if ((3393 >= 2729) and v22(v98.PrimordialWave, not v15:IsSpellInRange(v98.PrimordialWave))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\198\178\4\34\204\196\164\4\46\207\233\183\12\57\198\150\179\4\33\196\218\165\77\126\149", "\163\182\192\109\79");
					end
				end
				if ((4175 == 4175) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\18\42\1\205\240\7\46\15\195\254", "\149\84\70\96\160")]:IsReady() and v39 and (v15:DebuffDown(v98.FlameShockDebuff))) then
					if ((4584 > 1886) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\10\12\224\61\57\30\229\55\5\6\173\43\15\3\234\52\3\77\188\111", "\141\88\102\109");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\154\80\207\67\14\47\92\202\182", "\161\211\51\170\16\122\93\53")]:IsReady() and v41 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\222\162\183\37\254\160\166\41\247\143\161\59\250\187\190\60", "\72\155\206\210")]:IsAvailable() and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\117\109\93\28\63\79\116\83\35\50\67\118\71\26\33\73\119", "\83\38\26\52\110")]:IsAvailable()) or (1043 >= 2280)) then
					if (v22(v98.IceStrike, not v15:IsInMeleeRange(5)) or (667 < 71)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\20\34\121\75\3\53\79\83\18\103\85\81\25\32\74\93\87\118\30", "\38\56\119\71");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\223\238\78\215\9\87\224\231", "\54\147\143\56\182\69")]:IsReady() and v43 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\250\128\236\65\214\216\134\217\69\222\219\132\236", "\191\182\225\159\41")]:IsAvailable())) or (4482 < 2793)) then
					if ((561 < 4519) and v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\19\62\84\180\139\195\56\26\104\70\130\137\197\39\23\104\4\210", "\162\75\114\72\53\235\231");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\165\63\65\209\71\16\133\55\65", "\98\236\92\36\130\51")]:IsReady() and v41 and (v14:BuffDown(v98.IceStrikeBuff))) or (677 == 1434)) then
					if ((2827 == 2827) and v22(v98.IceStrike, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\26\9\133\86\188\167\57\175\28\76\169\76\166\178\60\161\89\94\234", "\80\196\121\108\218\37\200\213");
					end
				end
				v155 = 4;
			end
			if ((2556 == 2556) and (v155 == 6)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\2\83\81\23\255\112\42\38\73\68\10\254\82\36", "\67\65\33\48\100\151\60")]:IsReady() and v36) or (3106 >= 4932)) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (1217 <= 503)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\245\175\203\251\224\235\167\223\251\203\233\167\214\244\159\244\167\214\244\211\226\238\139\162", "\147\191\135\206\184");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\162\33\180\196\246\92\164\133", "\210\228\72\198\161\184\51")]:IsReady() and v38 and (v15:DebuffUp(v98.FlameShockDebuff))) or (441 >= 4871)) then
					if ((3751 > 731) and v22(v98.FireNova)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\64\225\21\76\192\57\95\242\80\96\199\56\78\255\21\51\157\100", "\174\86\41\147\112\19");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\12\140\6\32\60\25\164\88\11", "\203\59\96\237\107\69\111\113")]:IsReady() and v39) or (2515 < 1804)) then
					if ((3008 > 1924) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\26\173\236\52\207\196\44\25\175\234\113\227\222\42\17\160\228\113\163\132", "\183\68\118\204\129\81\144");
					end
				end
				if ((295 == 295) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\45\165\113\237\5\174\7\170\120\240\5\139\0\170", "\226\110\205\16\132\107")]:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v14:BuffUp(v98.CracklingThunderBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\206\207\229\212\68\229\215\225\213\114\251\202\242\208\85\248", "\33\139\163\128\185")]:IsAvailable()) then
					if ((4828 >= 1725) and v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\80\5\215\89\103\8\215\80\80\16\208\94\86\3\158\68\81\10\217\91\93\68\141\3", "\190\55\56\100");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\122\166\59\22\7\237\250\88\168\30\17\31\247", "\147\54\207\92\126\115\131")]:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v14:BuffDown(v98.PrimordialWaveBuff)) or (4201 < 2150)) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or (3076 >= 4666)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\56\50\117\25\112\4\63\50\66\15\113\1\37\117\110\4\112\10\61\48\61\94\43", "\30\109\81\85\29\109");
					end
				end
				v155 = 7;
			end
			if ((v155 == 2) or (2027 >= 3030)) then
				if ((3245 <= 3566) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\126\126\114\21\125\135\68\90\126\103\18\122\165\74", "\45\61\22\19\124\19\203")]:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 8) and v14:BuffUp(v98.CracklingThunderBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\228\30\8\248\7\126\173\192\30\62\229\11\98\176\213\1", "\217\161\114\109\149\98\16")]:IsAvailable()) then
					if (v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning)) or (2627 <= 381)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\17\40\57\117\178\75\30\41\63\116\168\122\27\46\63\60\175\125\28\39\52\121\252\37\67", "\20\114\64\88\28\220");
					end
				end
				if ((283 < 4544) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\20\13\215\185\253\222\169\48\13\240\184\249\195\169", "\221\81\97\178\212\152\176")]:IsReady() and v37 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 8) and (v14:BuffUp(v98.FeralSpiritBuff) or not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\232\235\24\246\31\195\243\28\247\41\221\238\15\242\14\222", "\122\173\135\125\155")]:IsAvailable())) then
					if ((618 < 3820) and v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\205\5\180\58\63\220\133\205\63\187\51\48\219\144\129\19\176\49\54\196\129\129\81\235", "\168\228\161\96\217\95\81");
					end
				end
				if ((4287 >= 124) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\247\208\56\93\13\66\201\194\58", "\55\187\177\78\60\79")]:IsReady() and v42 and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\25\198\80\249\79\194\147\4\192\73\228\69\206\148\36\193\81", "\224\77\174\63\139\38\175")]:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) then
					if ((2569 <= 3918) and v22(v98.LavaBurst, not v15:IsSpellInRange(v98.LavaBurst))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\136\64\78\47\187\67\77\60\151\85\24\61\141\79\95\34\129\1\9\125", "\78\228\33\56");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\226\119\181\11\145\192\119\188\4\167\193\114\166", "\229\174\30\210\99")]:IsReady() and v44 and ((v14:BuffStack(v98.MaelstromWeaponBuff) >= 8) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\40\249\135\69\228\62\24\24\238\147\92\248\49\56\15\228\137\95", "\89\123\141\230\49\141\93")]:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5))) and v14:BuffDown(v98.PrimordialWaveBuff)) or (3154 <= 2030)) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or (3761 <= 682)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\120\241\4\4\68\250\127\241\51\18\69\255\101\182\31\25\68\244\125\243\76\65\30", "\42\147\17\150\108\112");
					end
				end
				if ((2128 > 836) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\44\180\44\108\239\196\6\161\37\107\233\225\1\161", "\136\111\198\77\31\135")]:IsReady() and v36 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\35\5\183\94\188\211\24\165\4", "\201\98\105\199\54\221\132\119")]:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff) and (v117() == 0)) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (2361 <= 1063)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\186\30\130\50\10\10\160\176\11\139\53\12\60\162\190\76\144\40\12\50\160\188\76\210\116", "\204\217\108\227\65\98\85");
					end
				end
				v155 = 3;
			end
			if ((v155 == 5) or (1790 >= 3221)) then
				if ((4459 >= 3851) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\233\254\121\236\142\213\211\229\112", "\167\186\139\23\136\235")]:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113)) then
					if (v22(v98.Sundering, not v15:IsInRange(5)) or (2969 <= 1860)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\160\134\9\31\167\129\3\29\245\155\4\20\178\132\8\90\231\222", "\109\122\213\232");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\204\246\165\63\232\195\176\57\237\252\177", "\80\142\151\194")]:IsReady() and v55 and ((v62 and v31) or not v62)) or (2123 == 39)) then
					if (v22(v98.BagofTricks) or (2132 <= 201)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\199\112\115\12\192\72\88\17\207\116\71\16\134\100\69\13\193\123\73\67\148\32", "\44\99\166\23");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\90\254\59\51\29\171\106\246", "\196\28\151\73\86\83")]:IsReady() and v38 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\20\32\2\142\81\22\113\222\2\44\28\145\76\10\121\254", "\22\147\99\73\112\226\56\120")]:IsAvailable() and v15:DebuffUp(v98.FlameShockDebuff) and (v14:BuffStack(v98.MaelstromWeaponBuff) < (5 + (5 * v23(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\151\99\231\231\139\180\122\245\252\131\191\88\227\240\129\171\97\240\250\128", "\237\216\21\130\149")]:IsAvailable()))))) or (4338 >= 4477)) then
					if (v22(v98.FireNova) or (1732 >= 3545)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\132\71\77\90\143\199\81\148\79\31\76\185\199\89\142\75\31\13\232", "\62\226\46\63\63\208\169");
					end
				end
				if ((1125 >= 64) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\201\16\82\139\11\3\38\80\226\59\90\143\11", "\62\133\121\53\227\127\109\79")]:IsReady() and v44 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\56\21\59\249\197\186\173\2\25", "\194\112\116\82\149\182\206")]:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v14:BuffDown(v98.PrimordialWaveBuff)) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or (3215 > 4005)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\161\75\16\212\236\7\55\175\115\26\207\238\26\121\187\69\22\199\238\11\121\250\21", "\110\89\200\44\120\160\130");
					end
				end
				if ((2415 > 665) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\141\209\68\85\87\121\51\66\168\200", "\45\203\163\43\38\35\42\91")]:IsReady() and v40) then
					if (v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock)) or (1089 > 2205)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\212\151\211\48\147\150\71\218\138\223\40\199\186\93\220\130\208\38\199\250\4", "\52\178\229\188\67\231\201");
					end
				end
				v155 = 6;
			end
		end
	end
	local function v132()
		local v156 = 0;
		while true do
			if ((v156 == 1) or (2146 <= 628)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\249\129\94\11\2\193\211\142\87\22\2\228\212\142", "\141\186\233\63\98\108")]:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\222\252\41\164\35\253\229\59\191\43\246\199\45\179\41\226\254\62\185\40", "\69\145\138\76\214")]:IsAvailable()))))) or (3415 >= 4449)) then
					if (v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning)) or (1765 > 4310)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\115\199\136\128\177\41\124\198\142\129\171\24\121\193\142\201\190\25\117\143\222", "\118\16\175\233\233\223");
					end
				end
				if ((906 > 200) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\168\150\52\168\230\167\116\140\140\33\181\231\133\122", "\29\235\228\85\219\142\235")]:IsReady() and v36 and (v14:BuffUp(v98.DoomWindsBuff) or v14:BuffDown(v98.CrashLightningBuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\28\216\170\213\118\121\40\94\59", "\50\93\180\218\189\23\46\71")]:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff) and (v117() == 0)))) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (3072 <= 2133)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\221\182\90\95\76\227\68\215\163\83\88\74\213\70\217\228\90\67\65\156\16", "\40\190\196\59\44\36\188");
					end
				end
				if ((904 <= 1400) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\15\80\210\176\255\111\4\50\66", "\109\92\37\188\212\154\29")]:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113) and (v14:BuffUp(v98.DoomWindsBuff) or v14:HasTier(30, 2))) then
					if (v22(v98.Sundering, not v15:IsInRange(5)) or (718 > 3863)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\250\170\199\52\72\13\225\163\131\48\85\1\175\253", "\58\100\143\196\163\81");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\60\75\49\166\17\70\243\15", "\110\122\34\67\195\95\41\133")]:IsReady() and v38 and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\83\189\90\71\211\70\185\84\73\221\81\180\89\95\208\115", "\182\21\209\59\42")]:AuraActiveCount() >= 6) or ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\145\91\196\16\36\141\191\88\198\22\5\187\181\66\195\27", "\222\215\55\165\125\65")]:AuraActiveCount() >= 4) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\10\221\199\23\247\242\229\69\47\218\226\31\240\212\235\76", "\42\76\177\166\122\146\161\141")]:AuraActiveCount() >= v108)))) or (2483 == 2223)) then
					if ((1405 >= 829) and v22(v98.FireNova)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\163\131\23\203\70\120\170\156\4\142\120\121\160\202\84\158", "\22\197\234\101\174\25");
					end
				end
				if ((3341 < 3863) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\1\53\179\221\90\174\196\142", "\230\77\84\197\188\22\207\183")]:IsReady() and v43 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\213\21\213\244\133\175\247\19\245\21\203\249\159", "\85\153\116\166\156\236\193\144")]:IsAvailable())) then
					if ((3840 > 1000) and v114.CastCycle(v98.LavaLash, v107, v119, not v15:IsSpellInRange(v98.LavaLash))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\225\91\178\219\12\165\243\69\243\229\15\161\160\28\226", "\96\196\128\45\211\132");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\25\140\109\94\254\174\167\208", "\184\85\237\27\63\178\207\212")]:IsReady() and v43 and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\37\86\5\75\13\87\40\76\27\88\28\83\28", "\63\104\57\105")]:IsAvailable() and v15:DebuffUp(v98.FlameShockDebuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\45\139\165\73\14\180\172\75\8\140\128\65\9\146\162\66", "\36\107\231\196")]:AuraActiveCount() < v108) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\123\185\163\138\88\134\170\136\94\190\134\130\95\160\164\129", "\231\61\213\194")]:AuraActiveCount() < 6)) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\40\190\53\118\7\142\60\103\8\161\36\96\29", "\19\105\205\93")]:IsAvailable() and (v14:BuffStack(v98.AshenCatalystBuff) == 5)))) or (2660 < 1908)) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (2288 > 2511)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\9\200\128\0\165\9\205\137\127\168\7\219\193\110\251", "\95\201\104\190\225");
					end
				end
				v156 = 2;
			end
			if ((v156 == 4) or (3592 >= 4409)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\81\250\197\176\3\111\112\117\224\208\173\2\77\126", "\25\18\136\164\195\107\35")]:IsReady() and v36) or (4841 < 2991)) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (2863 <= 2540)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\63\168\92\122\131\205\177\239\37\189\65\123\178\198\248\233\34\172\15\32\233", "\216\136\77\201\47\18\220\161");
					end
				end
				if ((3057 <= 4822) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\229\57\223\38\211\148\44", "\226\77\140\75\186\104\188")]:IsReady() and v38 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\209\50\74\138\198\223\60\68\157\203\210\42\73\191", "\47\217\174\176\95")]:AuraActiveCount() >= 2)) then
					if (v22(v98.FireNova) or (4688 < 1489)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\190\212\100\7\141\90\119\48\185\157\119\13\183\20\42\112", "\70\216\189\22\98\210\52\24");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\255\211\166\138\214\212\203\162\139\241\214\222\176\147", "\179\186\191\195\231")]:IsReady() and v37 and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\220\51\29\233\252\49\12\229\245\12\8\237\235\54\12\247", "\132\153\95\120")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\148\190\11\32\242\212\180\176\190\61\61\254\200\169\165\161", "\192\209\210\110\77\151\186")]:IsAvailable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\197\15\39\228\250\202\244\2\46\203\243\197\243\23", "\164\128\99\66\137\159")]:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) or (832 >= 4770)) then
					if ((1934 == 1934) and v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\5\133\236\179\5\135\253\191\12\182\235\178\1\154\253\254\1\134\236\254\82\222", "\222\96\233\137");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\154\187\166\22\134\223\249\190\187\179\17\129\253\247", "\144\217\211\199\127\232\147")]:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) or (4524 <= 2618)) then
					if (v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning)) or (4166 >= 4169)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\39\63\33\219\122\14\77\255\39\42\38\220\75\5\4\249\32\59\104\135\29", "\36\152\79\94\72\181\37\98");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\224\209\73\59\209\205\85\38\227\215\83\58\218", "\95\183\184\39")]:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\130\54\233\34\82\149\16\172\11\232\50\81\141", "\98\213\95\135\70\52\224")]:TimeSinceLastCast() > 90))) or (3725 < 86)) then
					if (v22(v98.WindfuryTotem) or (4822 <= 153)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\170\199\115\82\235\177\208\72\64\241\183\204\122\20\255\172\204\55\6\167", "\52\158\195\169\23");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\92\176\51\121\131\6\115\132\121\183", "\235\26\220\82\20\230\85\27")]:IsReady() and v39 and (v15:DebuffDown(v98.FlameShockDebuff))) or (1816 > 2293)) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or (2823 >= 3213)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\142\173\232\207\113\183\178\225\205\119\131\225\232\205\113\200\242\185", "\20\232\193\137\162");
					end
				end
				v156 = 5;
			end
			if ((4702 > 2133) and (5 == v156)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\4\205\202\181\243\191\31\126\33\212", "\17\66\191\165\198\135\236\119")]:IsReady() and v40 and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\39\174\167\31\236\252\227\195\2", "\177\111\207\206\115\159\136\140")]:IsAvailable()) or (3335 <= 3201)) then
					if (v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock)) or (3347 < 1460)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\3\155\31\7\192\112\76\13\134\19\31\148\78\80\0\201\67\69", "\63\101\233\112\116\180\47");
					end
				end
				break;
			end
			if ((v156 == 2) or (4691 < 4371)) then
				if ((612 == 612) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\134\200\196\253\187\217\200\197\170", "\174\207\171\161")]:IsReady() and v41 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\197\255\4\255\235\195\226\236\0", "\183\141\158\109\147\152")]:IsAvailable())) then
					if (v22(v98.IceStrike, not v15:IsInMeleeRange(5)) or (4840 <= 4170)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\10\227\51\63\29\244\5\39\12\166\13\35\12\166\93\127", "\108\76\105\134");
					end
				end
				if ((1346 == 1346) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\205\215\190\242\218\216\205\190\226\197", "\174\139\165\209\129")]:IsReady() and v40 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\139\178\235\205\213\23\127\106\174", "\24\195\211\130\161\166\99\16")]:IsAvailable() and v14:BuffUp(v98.HailstormBuff)) then
					if (v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock)) or (3020 <= 2751)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\64\17\230\63\71\41\85\11\230\47\88\86\71\12\236\108\2\66", "\118\38\99\137\76\51");
					end
				end
				if ((3824 > 3667) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\206\51\11\22\12\50\244\40\2", "\64\157\70\101\114\105")]:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113)) then
					if (v22(v98.Sundering, not v15:IsInRange(5)) or (3048 > 3830)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\189\169\231\21\82\161\169\228\80\65\167\162\163\65\21", "\112\32\200\199\131");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\10\92\93\181\198\152\42\35\83\87", "\66\76\48\60\216\163\203")]:IsReady() and v39 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\151\137\117\231\90\192\5\169\149\120\230\83\218", "\68\218\230\25\147\63\174")]:IsAvailable() and v15:DebuffDown(v98.FlameShockDebuff)) or (2117 < 1050)) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or (1099 == 1810)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\38\82\65\179\146\57\91\67\181\166\106\82\67\179\237\123\5", "\214\205\74\51\44");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\220\64\227\241\114\201\68\237\255\124", "\23\154\44\130\156")]:IsReady() and v39 and v15:DebuffRefreshable(v98.FlameShockDebuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\55\175\191\171\24\28\7\167", "\115\113\198\205\206\86")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\180\69\247\87\139\69\250\83\133\91\201\91\146\82", "\58\228\55\158")]:IsAvailable()) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\146\133\209\35\57\158\61\187\138\219\10\57\175\32\178\143", "\85\212\233\176\78\92\205")]:AuraActiveCount() < v108) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\108\84\137\239\79\107\128\237\73\83\172\231\72\77\142\228", "\130\42\56\232")]:AuraActiveCount() < 6)) or (4892 == 3708)) then
					if ((2393 > 617) and v114.CastCycle(v98.FlameShock, v107, v118, not v15:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\236\185\37\238\69\0\249\189\43\224\75\127\235\186\33\163\17\104", "\95\138\213\68\131\32");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\12\33\179\70\88\37\62\160", "\22\74\72\193\35")]:IsReady() and v38 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\10\117\229\85\41\74\236\87\47\114\192\93\46\108\226\94", "\56\76\25\132")]:AuraActiveCount() >= 3)) or (1352 > 2414)) then
					if (v22(v98.FireNova) or (1584 == 2283)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\88\200\185\35\240\80\206\189\39\143\95\206\174\102\158\6", "\175\62\161\203\70");
					end
				end
				v156 = 3;
			end
			if ((2073 < 2845) and (v156 == 3)) then
				if ((2894 <= 3293) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\15\201\204\1\56\47\201\209\26\62\57", "\85\92\189\163\115")]:IsReady() and v46 and v14:BuffUp(v98.CrashLightningBuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\13\169\53\40\37\181\2\55\38\184\53\60\12\160\53\53\44\162\36\43", "\88\73\204\80")]:IsAvailable() or (v14:BuffStack(v98.ConvergingStormsBuff) == 6))) then
					if ((1275 > 942) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\151\31\84\36\201\58\145\25\77\44\154\47\140\21\6\120\131", "\186\78\227\112\38\73");
					end
				end
				if ((1190 < 4108) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\223\69\252\70\91\86\245\80\245\65\93\115\242\80", "\26\156\55\157\53\51")]:IsReady() and v36 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\175\202\23\202\176\89\130\223\37\205\183\66\129\203", "\48\236\184\118\185\216")]:IsAvailable() and v14:BuffUp(v98.CLCrashLightningBuff) and (v108 >= 4)) then
					if ((2404 <= 2475) and v22(v98.CrashLightning, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\230\175\86\35\199\11\233\180\80\56\219\58\236\179\80\112\206\59\224\253\5\96", "\84\133\221\55\80\175");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\138\238\42\162\212\72\175\238\47\163", "\60\221\135\68\198\167")]:IsCastable() and v49) or (2100 <= 635)) then
					if ((2967 > 196) and v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\180\246\135\81\205\252\180\243\134\2\216\225\184\184\209\19", "\185\142\221\152\227\34");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\107\209\88\232\78\32\227\74\204\92\255", "\151\56\165\55\154\35\83")]:IsReady() and v46) or (4689 < 3047)) then
					if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or (422 <= 411)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\179\87\10\252\173\80\17\252\169\72\0\174\161\76\0\174\242\17", "\142\192\35\101");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\255\118\44\144\243\158\165\29\211", "\118\182\21\73\195\135\236\204")]:IsReady() and v41) or (2476 > 2899)) then
					if ((1312 == 1312) and v22(v98.IceStrike, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\1\63\31\127\23\25\239\1\55\31\0\5\2\248\72\110\73", "\157\104\92\122\32\100\109");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\143\167\217\203\17\38\158\163", "\203\195\198\175\170\93\71\237")]:IsReady() and v43) or (3503 == 3404)) then
					if ((2284 < 4260) and v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\74\40\212\110\29\253\61\67\126\212\94\20\188\124\31", "\156\78\43\94\181\49\113");
					end
				end
				v156 = 4;
			end
			if ((638 <= 1080) and (v156 == 0)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\214\172\11\8\127\212\252\185\2\15\121\241\251\185", "\152\149\222\106\123\23")]:IsReady() and v36 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\254\52\247\80\189\212\40\241\112\161\210\52\251\80", "\213\189\70\150\35")]:IsAvailable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\122\91\102\29\67\76\67\1\65\81\103", "\104\47\53\20")]:IsAvailable() and (v108 >= 10)) or (v108 >= 15))) or (2440 == 4141)) then
					if ((4376 > 2959) and v22(v98.CrashLightning, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\160\94\128\15\180\48\175\69\134\20\168\1\170\66\134\92\189\0\166\12\208", "\111\195\44\225\124\220");
					end
				end
				if ((1668 == 1668) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\244\79\7\123\191\165\209\72\7\81\164\167\204", "\203\184\38\96\19\203")]:IsReady() and v44 and ((v15:DebuffStack(v98.FlameShockDebuff) >= v108) or (v15:DebuffStack(v98.FlameShockDebuff) >= 6)) and v14:BuffUp(v98.PrimordialWaveBuff) and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\22\101\124\83\200\53\124\110\72\192\62\94\120\68\194\42\103\107\78\195", "\174\89\19\25\33")]:IsAvailable())))) and (v14:BuffDown(v98.SplinteredElementsBuff) or (v113 <= 12) or (v96 <= v14:GCD()))) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or (3358 >= 4904)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\35\27\85\70\227\137\2\33\21\109\76\248\139\31\111\19\93\75\183\213", "\107\79\114\50\46\151\231");
					end
				end
				if ((2885 > 2876) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\21\167\163\40\166\56\164\200", "\160\89\198\213\73\234\89\215")]:IsReady() and v43 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\101\126\184\234\192\70\80\167\237\196\93\125\160", "\165\40\17\212\158")]:IsAvailable() and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\213\203\1\62\41\247\221\1\50\42\210\216\30\54", "\70\133\185\104\83")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\34\76\86\47\231\11\83\69", "\169\100\37\36\74")]:IsAvailable()) and v15:DebuffUp(v98.FlameShockDebuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\38\139\163\93\5\180\170\95\3\140\134\85\2\146\164\86", "\48\96\231\194")]:AuraActiveCount() < v108) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\238\86\15\32\28\235\167\140\203\81\42\40\27\205\169\133", "\227\168\58\110\77\121\184\207")]:AuraActiveCount() < 6)) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (2525 == 2957)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\119\61\169\65\142\215\112\182\115\124\190\79\180\155\34", "\197\27\92\223\32\209\187\17");
					end
				end
				if ((3983 > 649) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\51\77\202\246\12\77\199\242\2\83\244\250\21\90", "\155\99\63\163")]:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and (v14:BuffDown(v98.PrimordialWaveBuff))) then
					if ((1916 == 1916) and v114.CastCycle(v98.PrimordialWave, v107, v118, not v15:IsSpellInRange(v98.PrimordialWave))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\146\195\168\128\182\150\134\216\160\129\134\147\131\199\164\205\184\139\135\145\245", "\228\226\177\193\237\217");
					end
				end
				if ((4247 >= 3723) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\18\188\34\235\49\131\43\233\55\187", "\134\84\208\67")]:IsReady() and v39 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\35\190\143\81\28\190\130\85\18\160\177\93\5\169", "\60\115\204\230")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\193\51\249\117\201\53\253\113", "\16\135\90\139")]:IsAvailable()) and v15:DebuffDown(v98.FlameShockDebuff)) then
					if ((1446 < 3001) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\120\7\62\75\107\107\92\123\5\56\14\85\119\81\52\83", "\24\52\20\102\83\46\52");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\225\35\36\41\10\202\59\32\40\45\200\46\50\48", "\111\164\79\65\68")]:IsReady() and v37 and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\227\213\134\211\43\228\210\216\143\237\62\227\212\208\151\205", "\138\166\185\227\190\78")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\238\120\192\58\87\45\13\202\120\246\39\91\49\16\223\103", "\121\171\20\165\87\50\67")]:IsAvailable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\227\52\188\59\188\12\210\57\181\20\181\3\213\44", "\98\166\88\217\86\217")]:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) or (3380 < 199)) then
					if ((1494 <= 4564) and v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\243\250\124\12\131\210\226\247\117\62\132\208\247\229\109\65\135\211\243\182\47", "\188\150\150\25\97\230");
					end
				end
				v156 = 1;
			end
		end
	end
	local function v133()
		local v157 = 0;
		while true do
			if ((4256 > 469) and (4 == v157)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\245\180\230\212\113\155\223\161\239\211\119\190\216\161", "\215\182\198\135\167\25")]:IsReady() and v36 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\174\91\235\91\133\64\228\79\190\93\229\90\128\90", "\40\237\41\138")]:IsAvailable() and v14:BuffUp(v98.CLCrashLightningBuff) and (v108 >= 4)) or (3727 < 87)) then
					if ((609 <= 3889) and v22(v98.CrashLightning, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\196\102\251\235\66\248\120\243\255\66\211\122\243\246\77\135\114\239\246\68\194\120\186\170\27", "\42\167\20\154\152");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\247\172\70\98\53\88\247\169\71", "\65\42\158\194\34\17")]:IsCastable() and v49) or (2628 < 2175)) then
					if ((2999 == 2999) and v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\13\46\92\8\62\249\9\231\17\34\18\10\56\227\21\235\22\103\0\94", "\142\122\71\50\108\77\141\123");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\38\182\240\10\54\6\182\237\17\48\16", "\91\117\194\159\120")]:IsReady() and v46) or (2968 == 71)) then
					if ((3429 < 3464) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\9\49\10\56\226\48\8\20\53\29\117\247\49\20\19\59\20\117\163\119", "\68\122\125\94\120\85\145");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\62\31\202\109\220\203\179\28\25", "\218\119\124\175\62\168\185")]:IsReady() and v41) or (2337 <= 423)) then
					if (v22(v98.IceStrike, not v15:IsInMeleeRange(5)) or (4775 == 715)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\172\243\77\251\182\228\90\205\174\245\8\194\176\254\70\193\169\176\26\144", "\164\197\144\40");
					end
				end
				if ((3636 >= 1819) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\175\241\188\138\241\183\144\248", "\214\227\144\202\235\189")]:IsReady() and v43) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (1101 >= 2393)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\164\145\122\47\191\82\47\229\229\129\110\30\189\86\48\173\247\210", "\92\141\197\231\27\112\211\51");
					end
				end
				v157 = 5;
			end
			if ((1347 == 1347) and (5 == v157)) then
				if ((3743 > 2332) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\197\237\139\176\217\202\246\141\171\197\232\246\132\164", "\177\134\159\234\195")]:IsReady() and v36) then
					if ((3220 <= 4732) and v22(v98.CrashLightning, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\190\249\62\179\193\130\231\54\167\193\169\229\54\174\206\253\237\42\174\199\184\231\127\242\159", "\169\221\139\95\192");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\248\130\109\58\12\41\200\138", "\70\190\235\31\95\66")]:IsReady() and v38 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\156\238\27\235\224\137\234\21\229\238\158\231\24\243\227\188", "\133\218\130\122\134")]:AuraActiveCount() >= 2)) or (4482 >= 4962)) then
					if ((3467 >= 2430) and v22(v98.FireNova)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\58\246\241\193\227\173\55\42\254\163\194\201\173\54\57\243\163\150\139", "\88\92\159\131\164\188\195");
					end
				end
				if ((526 > 511) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\165\34\186\70\210\229\201\129\34\157\71\214\248\201", "\189\224\78\223\43\183\139")]:IsReady() and v37 and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\11\240\143\27\196\32\232\139\26\242\62\245\152\31\213\61", "\161\78\156\234\118")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\130\187\204\209\162\185\221\221\171\132\217\213\181\190\221\207", "\188\199\215\169")]:IsAvailable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\217\5\90\118\237\242\29\94\119\202\240\8\76\111", "\136\156\105\63\27")]:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or (2130 == 1868)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\30\128\124\57\30\130\109\53\23\179\123\56\26\159\109\116\29\153\119\58\30\128\57\102\67", "\84\123\236\25");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\220\138\188\22\142\160\226\152\190", "\213\144\235\202\119\204")]:IsReady() and v42 and ((v14:BuffStack(v98.MoltenWeaponBuff) + v23(v14:BuffUp(v98.VolcanicStrengthBuff))) > v14:BuffStack(v98.CracklingSurgeBuff)) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) or (2083 > 3867)) then
					if (v22(v98.LavaBurst, not v15:IsSpellInRange(v98.LavaBurst)) or (3090 >= 3604)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\47\25\200\43\23\33\88\49\11\202\106\46\54\67\45\29\210\106\122\122", "\45\67\120\190\74\72\67");
					end
				end
				if ((3370 < 4153) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\12\43\234\173\237\134\231\231\39\0\226\169\237", "\137\64\66\141\197\153\232\142")]:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5)) then
					if ((4132 == 4132) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\15\217\37\174\156\13\217\44\161\183\1\223\46\178\200\5\197\44\168\141\15\144\113\246", "\232\99\176\66\198");
					end
				end
				v157 = 6;
			end
			if ((v157 == 2) or (91 >= 2748)) then
				if ((1807 >= 1725) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\119\20\134\165\173\156\141\83\14\147\184\172\190\131", "\228\52\102\231\214\197\208")]:IsReady() and v36 and (v14:BuffUp(v98.DoomWindsBuff) or v14:BuffDown(v98.CrashLightningBuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\63\236\101\194\235\188\22\218\24", "\182\126\128\21\170\138\235\121")]:IsAvailable() and v14:BuffUp(v98.FeralSpiritBuff) and (v117() == 0)) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\168\213\59\240\131\1\55\15\133\221\6\242\137\1\61\21", "\102\235\186\85\134\230\115\80")]:IsAvailable() and (v14:BuffStack(v98.ConvergingStormsBuff) < 6)))) then
					if (v22(v98.CrashLightning, not v15:IsInMeleeRange(5)) or (633 >= 2602)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\84\30\63\76\122\235\46\94\11\54\75\124\221\44\80\76\56\74\124\218\39\91\76\111\14", "\66\55\108\94\63\18\180");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\39\152\139\51\34\75\29\131\130", "\57\116\237\229\87\71")]:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113) and (v14:BuffUp(v98.DoomWindsBuff) or v14:HasTier(30, 2))) or (377 >= 4657)) then
					if ((4868 > 1056) and v22(v98.Sundering, not v15:IsInRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\185\164\227\227\114\252\78\164\182\173\225\98\224\73\175\189\173\182\37", "\39\202\209\141\135\23\142");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\217\58\27\15\28\247\233\50", "\152\159\83\105\106\82")]:IsReady() and v38 and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\167\202\80\255\204\111\137\201\82\249\237\89\131\211\87\244", "\60\225\166\49\146\169")]:AuraActiveCount() == 6) or ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\9\18\46\39\4\52\39\17\44\33\37\2\45\11\41\44", "\103\79\126\79\74\97")]:AuraActiveCount() >= 4) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\156\115\210\126\91\41\178\112\208\120\122\31\184\106\213\117", "\122\218\31\179\19\62")]:AuraActiveCount() >= v108)))) or (1372 < 761)) then
					if (v22(v98.FireNova) or (3776 < 3310)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\181\223\223\196\246\175\74\165\215\141\199\220\175\75\182\218\141\144\154", "\37\211\182\173\161\169\193");
					end
				end
				if ((3991 == 3991) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\222\57\72\234\60\105\176\252\63", "\217\151\90\45\185\72\27")]:IsReady() and v41 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\235\125\238\30\69\215\115\245\31", "\54\163\28\135\114")]:IsAvailable() and v14:BuffDown(v98.IceStrikeBuff)) then
					if ((3538 >= 3305) and v22(v98.IceStrike, not v15:IsInMeleeRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\216\88\189\93\107\58\210\86\135\14\121\61\213\83\135\66\63\121\143", "\31\72\187\61\226\46");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\229\20\76\193\83\77\44\204\5\72", "\68\163\102\35\178\39\30")]:IsReady() and v40 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\150\113\211\203\16\161\140\3\179", "\113\222\16\186\167\99\213\227")]:IsAvailable() and v14:BuffUp(v98.HailstormBuff)) or (1165 < 1091)) then
					if ((3782 == 3782) and v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\40\28\244\229\58\49\232\254\33\13\240\182\40\27\245\248\43\2\187\167\123", "\150\78\110\155");
					end
				end
				v157 = 3;
			end
			if ((v157 == 1) or (2838 < 2736)) then
				if ((3651 == 3651) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\5\234\134\57\90\78\32\234\131\56", "\58\82\131\232\93\41")]:IsCastable() and v49 and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\183\95\223\7\84\50\144\126\222\3\82\60\130\67\217\26\83", "\95\227\55\176\117\61")]:IsAvailable() and (v14:BuffStack(v98.MaelstromWeaponBuff) > 1)) or (v14:BuffStack(v98.ConvergingStormsBuff) == 6))) then
					if ((1382 > 677) and v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\15\119\45\79\184\12\108\42\64\174\88\120\54\69\165\29\114\99\29", "\203\120\30\67\43");
					end
				end
				if ((903 < 2719) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\194\49\66\253\212\226\49\95\230\210\244", "\185\145\69\45\143")]:IsReady() and v46 and (v14:BuffStack(v98.ConvergingStormsBuff) == 6)) then
					if (v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike)) or (2145 > 4711)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\153\11\22\180\209\153\11\11\175\215\143\95\31\179\210\132\26\21\230\139", "\188\234\127\121\198");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\27\58\18\138\54\30\26\132\48\38\29\138\54\53", "\227\88\82\115")]:IsReady() and v35 and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\108\9\191\181\4\127\76\8\179\169\5\94\66\26\182\180\22\97\76\18", "\19\35\127\218\199\98")]:IsAvailable())))) and v14:BuffUp(v98.CracklingThunderBuff)) or (4848 <= 4317)) then
					if ((641 < 4795) and v22(v98.ChainLightning, not v15:IsSpellInRange(v98.ChainLightning))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\31\243\11\235\18\196\6\235\27\243\30\236\21\245\13\162\26\238\4\236\25\247\74\186", "\130\124\155\106");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\249\202\224\174\129\227\110\172\193", "\223\181\171\150\207\195\150\28")]:IsReady() and v42 and ((v14:BuffStack(v98.MoltenWeaponBuff) + v23(v14:BuffUp(v98.VolcanicStrengthBuff))) > v14:BuffStack(v98.CracklingSurgeBuff)) and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\99\44\230\188\15\64\53\244\167\7\75\23\226\171\5\95\46\241\161\4", "\105\44\90\131\206")]:IsAvailable()))))) or (3538 <= 1184)) then
					if (v22(v98.LavaBurst, not v15:IsSpellInRange(v98.LavaBurst)) or (3810 > 4775)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\243\225\164\184\55\60\234\242\161\173\72\56\234\238\188\188\4\126\166", "\94\159\128\210\217\104");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\124\240\1\183\75\113\240\116\87\219\9\179\75", "\26\48\153\102\223\63\31\153")]:IsReady() and v44 and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\45\86\232\225\4\76\226\228\11\78\234\222\3\69\225\224\22\82\226\254", "\147\98\32\141")]:IsAvailable()))))) or (3401 <= 2215)) then
					if ((2557 == 2557) and v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\20\74\228\194\18\88\66\22\68\220\200\9\90\95\88\69\246\196\8\83\71\88\18\179", "\43\120\35\131\170\102\54");
					end
				end
				v157 = 2;
			end
			if ((v157 == 0) or (2318 <= 1935)) then
				if ((3449 == 3449) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\239\50\234\26\236\56\202\53\234\48\247\58\215", "\86\163\91\141\114\152")]:IsReady() and v44 and ((v15:DebuffStack(v98.FlameShockDebuff) >= v108) or (v15:DebuffStack(v98.FlameShockDebuff) == 6)) and v14:BuffUp(v98.PrimordialWaveBuff) and (v14:BuffStack(v98.MaelstromWeaponBuff) == (5 + (5 * v23(v98[LUAOBFUSACTOR_DECRYPT_STR_0("\124\29\113\97\60\95\4\99\122\52\84\38\117\118\54\64\31\102\124\55", "\90\51\107\20\19")]:IsAvailable())))) and (v14:BuffDown(v98.SplinteredElementsBuff) or (v113 <= 12) or (v96 <= v14:GCD()))) then
					if (v22(v98.LightningBolt, not v15:IsSpellInRange(v98.LightningBolt)) or (1349 >= 1360)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\249\130\231\41\131\249\139\232\2\143\255\137\251\125\139\229\139\225\56\129\176\212", "\93\237\144\229\143");
					end
				end
				if ((3810 >= 779) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\57\247\230\24\39\71\6\254", "\38\117\150\144\121\107")]:IsReady() and v43 and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\0\180\226\46\40\181\207\41\62\186\251\54\57", "\90\77\219\142")]:IsAvailable() and v15:DebuffUp(v98.FlameShockDebuff) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\192\8\32\52\73\52\114\233\7\42\29\73\5\111\224\2", "\26\134\100\65\89\44\103")]:AuraActiveCount() < v108) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\215\239\49\46\161\194\235\63\32\175\213\230\50\54\162\247", "\196\145\131\80\67")]:AuraActiveCount() < 6)) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\63\163\14\13\22\203\31\164\7\4\1\251\10", "\136\126\208\102\104\120")]:IsAvailable() and (v14:BuffStack(v98.AshenCatalystBuff) == 5)))) then
					if (v22(v98.LavaLash, not v15:IsSpellInRange(v98.LavaLash)) or (2423 == 1135)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\116\139\216\66\144\94\60\66\112\202\200\86\161\92\56\93\56\216", "\49\24\234\174\35\207\50\93");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\60\224\244\133\126\30\246\244\137\125\59\243\235\141", "\17\108\146\157\232")]:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and (v14:BuffDown(v98.PrimordialWaveBuff))) or (4712 <= 2944)) then
					if (v114.CastCycle(v98.PrimordialWave, v107, v118, not v15:IsSpellInRange(v98.PrimordialWave)) or (4586 <= 2063)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\209\29\224\32\186\79\202\21\225\16\191\74\213\17\173\41\189\69\205\17\225\111\251", "\200\43\163\116\141\79");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\153\58\60\142\181\199\235\176\53\54", "\131\223\86\93\227\208\148")]:IsReady() and v39 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\211\87\191\187\18\167\231\76\183\186\42\180\245\64", "\213\131\37\214\214\125")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\0\34\55\186\207\41\61\36", "\129\70\75\69\223")]:IsAvailable()) and v15:DebuffDown(v98.FlameShockDebuff)) or (3589 <= 3247)) then
					if (v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock)) or (1763 < 1755)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\64\199\242\228\121\208\85\195\252\234\119\175\64\222\253\231\121\227\6\159", "\143\38\171\147\137\28");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\245\142\188\254\6\237\192\209\142\155\255\2\240\192", "\180\176\226\217\147\99\131")]:IsReady() and v37 and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\246\181\42\10\214\183\59\6\223\138\63\14\193\176\59\20", "\103\179\217\79")]:IsAvailable() or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\111\187\25\216\68\130\183\75\187\47\197\72\158\170\94\164", "\195\42\215\124\181\33\236")]:IsAvailable() and ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\40\85\50\51\32\246\25\88\59\28\41\249\30\77", "\152\109\57\87\94\69")]:Charges() == v110) or v14:BuffUp(v98.FeralSpiritBuff))))) or (3427 < 2151)) then
					if (v22(v98.ElementalBlast, not v15:IsSpellInRange(v98.ElementalBlast)) or (3829 == 3060)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\252\219\15\174\187\220\64\169\245\232\8\175\191\193\64\232\255\194\4\173\187\222\20\253", "\200\153\183\106\195\222\178\52");
					end
				end
				v157 = 1;
			end
			if ((v157 == 3) or (250 == 371)) then
				if ((4374 > 1370) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\182\208\41\229\161\12\182\78\130", "\32\229\165\71\129\196\126\223")]:IsReady() and v47 and ((v59 and v32) or not v59) and (v96 < v113)) then
					if ((3519 > 3133) and v22(v98.Sundering, not v15:IsInRange(5))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\156\202\133\132\199\202\135\195\193\135\192\205\135\193\141\193\132\149", "\181\163\233\164\225\225");
					end
				end
				if ((4996 > 4721) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\118\135\63\122\85\184\54\120\83\128", "\23\48\235\94")]:IsReady() and v39 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\81\213\212\73\82\61\243\111\201\217\72\91\39", "\178\28\186\184\61\55\83")]:IsAvailable() and v15:DebuffDown(v98.FlameShockDebuff)) then
					if ((4023 >= 2719) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\194\193\70\49\247\49\230\204\194\68\55\178\8\224\202\195\66\48\178\95\162", "\149\164\173\39\92\146\110");
					end
				end
				if ((243 <= 4516) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\213\43\17\18\31\40\251\40\19\20", "\123\147\71\112\127\122")]:IsReady() and v39 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\234\196\144\116\104\195\219\131", "\38\172\173\226\17")]:IsAvailable() or v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\3\37\226\66\3\40\230\76\29\27\238\91\20", "\143\45\113\76")]:IsAvailable()) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\158\180\29\49\189\139\20\51\187\179\56\57\186\173\26\58", "\92\216\216\124")]:AuraActiveCount() < v108) and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\62\173\77\248\104\58\163\67\246\127\55\174\85\251\93", "\157\59\82\204\32")]:AuraActiveCount() < 6)) then
					if ((3743 >= 1870) and v114.CastCycle(v98.FlameShock, v107, v118, not v15:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\50\226\247\236\213\192\185\55\61\232\186\239\255\221\191\61\50\163\171\177", "\209\88\94\131\154\137\138\179");
					end
				end
				if ((298 <= 3318) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\14\168\214\121\48\44\39\35", "\66\72\193\164\28\126\67\81")]:IsReady() and v38 and (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\193\32\169\85\35\69\239\35\171\83\2\115\229\57\174\94", "\22\135\76\200\56\70")]:AuraActiveCount() >= 3)) then
					if ((1156 < 3232) and v22(v98.FireNova)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\139\57\234\33\98\239\130\38\249\100\91\244\131\62\253\40\29\176\212", "\129\237\80\152\68\61");
					end
				end
				if ((777 < 2530) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\98\188\11\225\17\4\76\67\161\15\246", "\56\49\200\100\147\124\119")]:IsReady() and v46 and v14:BuffUp(v98.CrashLightningBuff) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\232\59\186\224\192\39\141\255\195\42\186\244\233\50\186\253\201\48\171\227", "\144\172\94\223")]:IsAvailable()) then
					if ((3745 >= 2715) and v22(v98.Stormstrike, not v15:IsSpellInRange(v98.Stormstrike))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\27\173\85\41\28\182\85\45\4\167\7\34\26\172\73\33\3\226\21\116", "\39\68\111\194");
					end
				end
				v157 = 4;
			end
			if ((v157 == 6) or (4942 == 1715)) then
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\38\2\125\152\235\53\216\46\60\3\118", "\76\140\65\72\102\27\237\153")]:IsReady() and v48 and (v14:BuffDown(v98.WindfuryTotemBuff, true) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\125\211\24\214\209\20\172\83\238\25\198\210\12", "\222\42\186\118\178\183\97")]:TimeSinceLastCast() > 90))) or (2975 > 4424)) then
					if ((2898 >= 1084) and v22(v98.WindfuryTotem)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\74\229\74\142\91\249\86\147\98\248\75\158\88\225\4\140\72\226\74\143\81\172\23\219", "\234\61\140\36");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\7\209\187\127\10\18\213\181\113\4", "\111\65\189\218\18")]:IsReady() and v39 and (v15:DebuffDown(v98.FlameShockDebuff))) or (103 == 4087)) then
					if ((3036 > 2582) and v22(v98.FlameShock, not v15:IsSpellInRange(v98.FlameShock))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\69\71\26\56\14\99\188\75\68\24\62\75\90\186\77\69\30\57\75\15\253", "\207\35\43\123\85\107\60");
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\86\184\175\249\109\67\162\175\233\114", "\25\16\202\192\138")]:IsReady() and v40 and not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\213\202\164\238\186\224\242\217\160", "\148\157\171\205\130\201")]:IsAvailable()) or (255 > 608)) then
					if (v22(v98.FrostShock, not v15:IsSpellInRange(v98.FrostShock)) or (3982 <= 2940)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\37\198\123\58\197\201\48\220\123\42\218\182\37\193\122\39\212\250\99\135\39", "\150\67\180\20\73\177");
					end
				end
				break;
			end
		end
	end
	local function v134()
		local v158 = 0;
		while true do
			if ((v158 == 1) or (3791 > 4684)) then
				if (((not v103 or (v105 < 600000)) and v50 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\225\2\84\19\194\0\65\17\201\9\64\27\240\11\84\14\200\0", "\126\167\110\53")]:IsCastable()) or (2927 <= 967)) then
					if (v22(v98.FlamentongueWeapon) or (631 > 2929)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\28\47\245\217\43\50\30\41\237\217\0\42\21\47\232\211\49\125\21\32\251\212\62\51\4", "\95\93\112\78\152\188");
					end
				end
				if (v82 or (341 > 3956)) then
					local v226 = 0;
					while true do
						if ((v226 == 0) or (4842 <= 1498)) then
							v28 = v127();
							if (v28 or (1312 > 4950)) then
								return v28;
							end
							break;
						end
					end
				end
				v158 = 2;
			end
			if ((v158 == 2) or (840 == 1211)) then
				if ((4499 > 1584) and v15 and v15:Exists() and v15:IsAPlayer() and v15:IsDeadOrGhost() and not v14:CanAttack(v15)) then
					if ((3708 <= 4221) and v22(v98.AncestralSpirit, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\240\150\0\246\172\215\194\225\140\26\234", "\178\161\149\229\117\132\222");
					end
				end
				if ((v114.TargetIsValid() and v29) or (3680 <= 483)) then
					if ((1429 <= 3193) and not v14:AffectingCombat()) then
						local v237 = 0;
						local v238;
						while true do
							if ((2629 > 487) and (0 == v237)) then
								v238 = v130();
								if (v238 or (4372 < 2905)) then
									return v238;
								end
								break;
							end
						end
					end
				end
				break;
			end
			if ((1134 > 513) and (v158 == 0)) then
				if ((v72 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\168\25\8\89\133\43\18\68\136\20\30", "\45\237\120\122")]:IsCastable() and v14:BuffDown(v98.EarthShieldBuff) and ((v73 == LUAOBFUSACTOR_DECRYPT_STR_0("\242\233\176\56\223\168\145\36\222\237\174\40", "\76\183\136\194")) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\95\234\224\53\85\65\0\123\234\202\42\82\70\0", "\116\26\134\133\88\48\47")]:IsAvailable() and v14:BuffUp(v98.LightningShield)))) or (3433 == 2550)) then
					if ((407 <= 1997) and v22(v98.EarthShield)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\27\192\178\240\181\77\13\201\169\225\177\118\94\204\161\237\179\50\76", "\18\126\161\192\132\221");
					end
				elseif ((v72 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\115\33\169\12\66\81\33\160\3\101\87\33\171\8\82", "\54\63\72\206\100")]:IsCastable() and v14:BuffDown(v98.LightningShieldBuff) and ((v73 == LUAOBFUSACTOR_DECRYPT_STR_0("\228\80\66\114\241\117\193\87\66\58\214\115\193\92\73\126", "\27\168\57\37\26\133")) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\8\166\121\165\210\35\190\125\164\248\63\168\117\188", "\183\77\202\28\200")]:IsAvailable() and v14:BuffUp(v98.EarthShield)))) or (1455 >= 2073)) then
					if (v22(v98.LightningShield) or (3473 > 4578)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\27\58\142\0\3\61\128\6\16\12\154\0\30\54\133\12\87\62\136\1\25\115\219", "\104\119\83\233");
					end
				end
				if ((2519 < 3193) and (not v102 or (v104 < 600000)) and v50 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\194\241\41\38\69\224\234\62\21\70\244\232\40\44", "\35\149\152\71\66")]:IsCastable()) then
					if (v22(v98.WindfuryWeapon) or (463 >= 4937)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\14\225\76\180\60\12\250\91\143\45\28\233\82\191\52\89\237\76\179\50\24\230\86", "\90\121\136\34\208");
					end
				end
				v158 = 1;
			end
		end
	end
	local function v135()
		local v159 = 0;
		while true do
			if ((v159 == 1) or (3991 <= 3758)) then
				if (v90 or (4387 <= 2300)) then
					local v227 = 0;
					while true do
						if ((v227 == 0) or (4301 == 2660)) then
							if ((1590 <= 3077) and v84) then
								local v240 = 0;
								while true do
									if ((0 == v240) or (4107 <= 1029)) then
										v28 = v114.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 40);
										if (v28 or (1843 == 3876)) then
											return v28;
										end
										break;
									end
								end
							end
							if ((4715 >= 1158) and v85) then
								local v241 = 0;
								while true do
									if ((1989 == 1989) and (v241 == 0)) then
										v28 = v114.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 30);
										if (v28 or (3162 == 4103)) then
											return v28;
										end
										break;
									end
								end
							end
							v227 = 1;
						end
						if ((v227 == 1) or (3247 == 4400)) then
							if ((3761 > 2745) and v86) then
								local v242 = 0;
								while true do
									if ((772 < 4176) and (0 == v242)) then
										v28 = v114.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 30);
										if ((2766 >= 654) and v28) then
											return v28;
										end
										break;
									end
								end
							end
							if (((v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v87) or (4827 == 2370)) then
								local v243 = 0;
								while true do
									if ((0 == v243) or (2486 > 2851)) then
										v28 = v114.HandleAfflicted(v98.HealingSurge, v100.HealingSurgeMouseover, 40, true);
										if (v28 or (3984 == 1629)) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
				if (v91 or (2473 > 3375)) then
					local v228 = 0;
					while true do
						if ((v228 == 0) or (4886 == 1971)) then
							v28 = v114.HandleIncorporeal(v98.Hex, v100.HexMouseOver, 30, true);
							if (v28 or (2594 <= 1430)) then
								return v28;
							end
							break;
						end
					end
				end
				v159 = 2;
			end
			if ((4813 > 4545) and (v159 == 0)) then
				v28 = v128();
				if (v28 or (4915 < 4893)) then
					return v28;
				end
				v159 = 1;
			end
			if ((4143 == 4143) and (v159 == 2)) then
				if ((1223 < 3414) and Focus) then
					if ((450 < 2517) and v89) then
						local v239 = 0;
						while true do
							if ((2235 == 2235) and (v239 == 0)) then
								v28 = v125();
								if ((927 <= 2517) and v28) then
									return v28;
								end
								break;
							end
						end
					end
				end
				if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\175\201\216\173\181\19\180\19\157\201\218\169", "\67\232\187\189\204\193\118\198")]:IsAvailable() and v97 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\172\60\176\33\47\7\253\187\59\167\39\62", "\143\235\78\213\64\91\98")]:IsReady() and v33 and v88 and not v14:IsCasting() and not v14:IsChanneling() and v114.UnitHasMagicBuff(v15)) or (2073 > 4117)) then
					if (v22(v98.GreaterPurge, not v15:IsSpellInRange(v98.GreaterPurge)) or (3015 > 4666)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\138\90\129\232\100\179\159\119\148\252\98\177\136\8\128\232\125\183\138\77", "\214\237\40\228\137\16");
					end
				end
				v159 = 3;
			end
			if ((1039 < 4270) and (v159 == 3)) then
				if ((125 < 2081) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\181\246\253\222\6", "\198\229\131\143\185\99")]:IsReady() and v97 and v33 and v88 and not v14:IsCasting() and not v14:IsChanneling() and v114.UnitHasMagicBuff(v15)) then
					if (v22(v98.Purge, not v15:IsSpellInRange(v98.Purge)) or (1869 == 4900)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\65\153\186\116\84\204\172\114\92\141\175\118", "\19\49\236\200");
					end
				end
				v28 = v126();
				v159 = 4;
			end
			if ((v159 == 4) or (1777 >= 3312)) then
				if (v28 or (1170 > 1897)) then
					return v28;
				end
				if ((888 >= 752) and v114.TargetIsValid()) then
					local v229 = 0;
					local v230;
					while true do
						if ((v229 == 2) or (3089 > 4023)) then
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\57\166\133\166\20\112\19\173\153", "\25\125\201\234\203\67")]:IsCastable() and v53 and ((v58 and v31) or not v58) and (v96 < v113)) or (4850 == 1446)) then
								if (v22(v98.DoomWinds, not v15:IsInMeleeRange(5)) or (3104 == 1021)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\125\251\23\14\43\48\26\119\240\11\67\25\38\26\119\180\77", "\115\25\148\120\99\116\71");
								end
							end
							if ((1584 < 4428) and (v108 == 1)) then
								local v244 = 0;
								local v245;
								while true do
									if ((1324 < 1928) and (v244 == 0)) then
										v245 = v131();
										if ((4629 == 4629) and v245) then
											return v245;
										end
										break;
									end
								end
							end
							if ((2911 < 3901) and v30 and (v108 > 1)) then
								local v246 = 0;
								local v247;
								while true do
									if ((379 < 1357) and (0 == v246)) then
										v247 = v132();
										if (v247 or (1393 <= 362)) then
											return v247;
										end
										break;
									end
								end
							end
							if ((1460 == 1460) and v19.CastAnnotated(v98.Pool, false, LUAOBFUSACTOR_DECRYPT_STR_0("\59\28\144\16", "\33\108\93\217\68"))) then
								return "Wait/Pool Resources";
							end
							break;
						end
						if ((v229 == 1) or (3516 <= 1360)) then
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\134\90\114\209\106\46\163\90\119\208", "\90\209\51\28\181\25")]:IsCastable() and v49) or (1890 <= 123)) then
								if (v22(v98.Windstrike, not v15:IsSpellInRange(v98.Windstrike)) or (1683 >= 3073)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\199\114\89\234\172\196\105\94\229\186\144\118\86\231\177\144\42", "\223\176\27\55\142");
								end
							end
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\20\169\199\184\43\169\202\188\37\183\249\180\50\190", "\213\68\219\174")]:IsCastable() and v45 and ((v60 and v32) or not v60) and (v96 < v113) and (v14:HasTier(31, 2))) or (1922 >= 2669)) then
								if (v22(v98.PrimordialWave, not v15:IsSpellInRange(v98.PrimordialWave)) or (130 == 3280)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\27\242\42\234\37\215\59\118\10\236\28\240\43\211\58\63\6\225\42\233\106\151", "\31\107\128\67\135\74\165\95");
								end
							end
							if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\254\237\238\76\77\130\200\225\238\68\85", "\209\184\136\156\45\33")]:IsCastable() and v52 and ((v57 and v31) or not v57) and (v96 < v113)) or (4930 <= 4189)) then
								if ((1167 < 1489) and v22(v98.FeralSpirit)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\1\205\103\9\180\56\219\101\1\170\14\220\53\5\185\14\198\53\91", "\216\103\168\21\104");
								end
							end
							if ((4056 >= 670) and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\89\190\64\161\118\169\66\170\123\168", "\196\24\205\35")]:IsCastable() and v51 and ((v56 and v31) or not v56) and (v96 < v113) and v15:DebuffUp(v98.FlameShockDebuff) and (((v111 == LUAOBFUSACTOR_DECRYPT_STR_0("\2\130\228\14\58\133\234\8\41\203\193\9\34\159", "\102\78\235\131")) and (v108 == 1)) or ((v111 == LUAOBFUSACTOR_DECRYPT_STR_0("\217\38\53\77\73\121\155\61\253\38\32\74\78\55\176", "\84\154\78\84\36\39\89\215")) and (v108 > 1)))) then
								if ((329 < 462) and v22(v98.Ascendance)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\252\242\85\93\11\249\224\88\91\0\189\236\87\81\11\189\181", "\101\157\129\54\56");
								end
							end
							v229 = 2;
						end
						if ((3283 > 1085) and (v229 == 0)) then
							v230 = v114.HandleDPSPotion(v14:BuffUp(v98.FeralSpiritBuff));
							if (v230 or (759 > 4120)) then
								return v230;
							end
							if ((202 < 3063) and (v96 < v113)) then
								if ((v54 and ((v31 and v61) or not v61)) or (1603 > 4604)) then
									local v252 = 0;
									while true do
										if ((v252 == 0) or (2592 <= 1594)) then
											v28 = v129();
											if (v28 or (2195 >= 4996)) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if (((v96 < v113) and v55 and ((v62 and v31) or not v62)) or (930 <= 810)) then
								local v248 = 0;
								while true do
									if ((v248 == 1) or (4794 < 2698)) then
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\118\227\234\205\67\92\229\247\204", "\33\48\138\152\168")]:IsCastable() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\83\5\51\84\207\51\115\24\51\84", "\87\18\118\80\49\161")]:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\109\13\217\165\190\72\31\212\163\181", "\208\44\126\186\192")]:CooldownRemains() > 50))) or (555 <= 551)) then
											if ((261 < 3869) and v22(v98.Fireblood)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\241\19\182\195\22\240\198\65\243\90\182\199\23\245\200\66", "\46\151\122\196\166\116\156\169");
											end
										end
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\196\227\69\31\232\241\255\71\22\216\228\225\74", "\155\133\141\38\122")]:IsCastable() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\4\57\175\68\65\123\164\43\41\169", "\197\69\74\204\33\47\31")]:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\209\92\89\130\254\75\91\137\243\74", "\231\144\47\58")]:CooldownRemains() > 50))) or (334 > 3050)) then
											if ((3653 <= 4807) and v22(v98.AncestralCall)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\179\214\217\112\11\41\221\56\190\231\217\116\20\49\143\43\179\219\211\116\20", "\89\210\184\186\21\120\93\175");
											end
										end
										break;
									end
									if ((3366 <= 3623) and (v248 == 0)) then
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\220\59\249\184\224\156\235\37\239", "\218\158\87\150\215\132")]:IsCastable() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\218\13\218\231\56\38\204\245\29\220", "\173\155\126\185\130\86\66")]:IsAvailable() or v14:BuffUp(v98.AscendanceBuff) or (v98[LUAOBFUSACTOR_DECRYPT_STR_0("\196\181\185\194\134\232\228\168\185\194", "\140\133\198\218\167\232")]:CooldownRemains() > 50))) or (4624 == 1921)) then
											if (v22(v98.BloodFury) or (2088 < 2014)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\183\34\187\114\128\138\40\161\111\157\245\60\181\126\141\180\34", "\228\213\78\212\29");
											end
										end
										if ((v98[LUAOBFUSACTOR_DECRYPT_STR_0("\165\73\164\22\238\149\71\191\11\236", "\139\231\44\214\101")]:IsCastable() and (not v98[LUAOBFUSACTOR_DECRYPT_STR_0("\248\252\5\91\30\181\48\24\218\234", "\118\185\143\102\62\112\209\81")]:IsAvailable() or v14:BuffUp(v98.AscendanceBuff))) or (3297 > 4690)) then
											if ((392 <= 3292) and v22(v98.Berserking)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\94\117\59\245\160\7\23\49\82\119\105\244\164\22\21\57\80", "\88\60\16\73\134\197\117\124");
											end
										end
										v248 = 1;
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
	end
	local function v136()
		local v160 = 0;
		while true do
			if ((v160 == 5) or (119 >= 4531)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\181\92\225\147\117\52\134\223", "\172\230\57\149\231\28\90\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\6\165\137\223\31\210\12\174\149\229\33\207\10\137\162", "\187\98\202\230\178\72")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\228\176\36\67\47\230\183", "\42\65\129\196\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\79\79\219\27\52\18\231\16\67\73\237\30\19\10\205\38", "\142\98\42\61\186\119\103\98")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\186\22\28\49\177\5\27", "\104\88\223\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\84\229\235\195\13\255\64\254\227\194\53\236\82\242\213\199\22\229\105\254\236\199\33\201", "\141\36\151\130\174\98")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\127\214\25\141\116\197\30", "\109\228\26\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\240\243\124\229\244\87\235\250\79\233\242\86\200\244\118\233\197\122", "\134\62\133\157\24\128")];
				break;
			end
			if ((v160 == 0) or (2475 > 3863)) then
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\78\181\185\210\69\166\190", "\205\187\43\193")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\97\0\254\237\113\0\209\250\115\11\220\251", "\191\158\18\101")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\246\198\147\163\166\203\196\148", "\207\165\163\231\215")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\234\252\114\43\127\203\206\240\88\32\99", "\16\166\153\153\54\68")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\225\182\212\82\61\47\254\193", "\153\178\211\160\38\84\65")][LUAOBFUSACTOR_DECRYPT_STR_0("\151\24\95\13\135\25\91\39\177\27\83\57\139\31", "\75\226\107\58")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\219\5\110\24\204\202\75", "\173\56\190\113\26\113\162")][LUAOBFUSACTOR_DECRYPT_STR_0("\222\205\40\38\255\202\215\35\9\254\204\214\57\11\254\197\217", "\151\171\190\77\101")];
				v160 = 1;
			end
			if ((2189 >= 1725) and (v160 == 1)) then
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\246\42\236\189\241\115\12\214", "\107\165\79\152\201\152\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\66\93\237\232\70\126\68\70\196\194\83\119\67\64\225\197\83", "\31\55\46\136\171\52")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\226\45\200\224\216\38\219\231", "\148\177\72\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\179\165\82\246\170\179\90\214\168\162\86\223\132\186\86\192\178", "\179\198\214\55")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\195\9\102\98\76\221\247\31", "\179\144\108\18\22\37")][LUAOBFUSACTOR_DECRYPT_STR_0("\211\176\30\175\198\212\166\53\134\217\199", "\175\166\195\123\233")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\220\199\73\93\249\225\197\78", "\144\143\162\61\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\192\24\118\126\134\62\229\224\21\95\113\140", "\83\128\179\125\48\18\231")];
				v160 = 2;
			end
			if ((1717 < 3405) and (v160 == 4)) then
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\243\19\215\239\81\230\32\246", "\133\160\118\163\155\56\136\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\227\177\116\197\191\17\177\229\182\99\251\189\26", "\213\150\194\17\146\214\127")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\40\172\176\192\79\170\165\37", "\86\123\201\196\180\38\196\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\251\220\152\254\230\221\169\226\250\192\155\248\252\220\162", "\207\151\136\185")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\155\134\60\150\125\118\118\187", "\17\200\227\72\226\20\24")][LUAOBFUSACTOR_DECRYPT_STR_0("\165\82\30\224\204\240\255\240\190\100\21\212\193\240\225\235", "\159\208\33\123\183\169\145\143")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\193\95\44\34\251\84\63\37", "\86\146\58\88")][LUAOBFUSACTOR_DECRYPT_STR_0("\89\204\233\197\160\237\55\244\91\218\221\201\186\225\21\222", "\154\56\191\138\160\206\137\86")];
				v160 = 5;
			end
			if ((v160 == 2) or (118 == 1880)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\178\231\201\78\16\90\164", "\126\61\215\147\189\39")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\236\24\99\106\240\14\81\75\247\18\70\115", "\37\24\159\125")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\163\97\86\211\168\114\81", "\34\186\198\21")][LUAOBFUSACTOR_DECRYPT_STR_0("\237\27\192\116\193\253\59\209\79\203\243\13", "\162\152\104\165\61")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\254\42\166\105\121\235\202\60", "\133\173\79\210\29\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\111\232\7\140\106\236\9\152\110\254\63", "\75\237\28\141")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\239\90\216\165\38\21\224\242", "\129\188\63\172\209\79\123\135")][LUAOBFUSACTOR_DECRYPT_STR_0("\85\247\227\225\65\242\231\225\65\247\238", "\173\32\132\134")];
				v160 = 3;
			end
			if ((3232 > 1090) and (v160 == 3)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\125\30\28\251\167\63\202\93", "\173\46\123\104\143\206\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\161\14\39\166\76\132\9\160\19\43\132\66\161\14\184\9", "\97\212\125\66\234\37\227")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\185\230\162\33\23\132\228\165", "\126\234\131\214\85")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\198\76\106\93\141\216\70\72\75\141\212\69\109\78\146\208", "\47\228\181\41\58")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\149\249\205\47\10\62\24\181", "\127\198\156\185\91\99\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\224\9\201\195\179\4\43\211\198\14\222\249\172\14", "\190\149\122\172\144\199\107\89")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\0\229\234\247\60\2\226", "\158\82\101\145\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\101\237\7\37\81\126\250\7\4\77\126\249", "\36\16\158\98\118")];
				v160 = 4;
			end
		end
	end
	local function v137()
		local v161 = 0;
		while true do
			if ((3225 > 1844) and (v161 == 4)) then
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\152\35\211\62\163\165\33\212", "\202\203\70\167\74")][LUAOBFUSACTOR_DECRYPT_STR_0("\33\0\217\63\98\56\19\211\62\89\41\0\208\58\127\43\50\201\33\118\41\34\206\58\101\37\2\221\63\89\28", "\17\76\97\188\83")] or 0;
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\182\34\205\35\57\141\76\176", "\195\229\71\185\87\80\227\43")][LUAOBFUSACTOR_DECRYPT_STR_0("\225\233\20\95\220\232\245\5\92\235", "\143\128\156\96\48")];
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\212\228\6\30\182\214\227", "\119\216\177\144\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\218\33\240\71\197\45\204\81\204", "\34\169\73\153")] or LUAOBFUSACTOR_DECRYPT_STR_0("\134\229\12\131\190\226\2\133\173\172\56\131\163\233\7\143", "\235\202\140\107");
				v161 = 5;
			end
			if ((v161 == 6) or (2722 >= 4773)) then
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\242\76\9\12\67\178\198\90", "\220\161\41\125\120\42")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\98\165\45\176\116\161\0\175\116\147\30\181\99\169\26\139\120\180\6\157\119\166\2\181\114\180\11\184", "\110\220\17\192")];
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\71\124\32\14\226\57\246\180", "\199\20\25\84\122\139\87\145")][LUAOBFUSACTOR_DECRYPT_STR_0("\82\26\216\154\9\239\74\6\207\154\20\254\66\4\234\167\15\226\102\15\219\162\18\233\83\12\217", "\138\39\105\189\206\123")];
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\44\2\157\57\250\247\200\236", "\159\127\103\233\77\147\153\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\18\227\225\154\79\194\20\255\234\137\76\206\6\254\247\163\78\204\51\255\240\175\77\252\14\228\236\139\70\205\11\249\231\190\69\207", "\171\103\144\132\202\32")];
				v161 = 7;
			end
			if ((1751 > 383) and (v161 == 0)) then
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\160\14\205\38\191\209\20", "\182\103\197\122\185\79\209")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\148\228\64\9\70\247\180\233\114\1\90", "\40\147\231\129\23\96")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\253\152\81\178\162\219\102", "\188\21\152\236\37\219\204")][LUAOBFUSACTOR_DECRYPT_STR_0("\85\250\50\47\65\249\54\15\73\253\56\30\116\230\35\9\77", "\108\32\137\87")];
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\153\237\20\178\38\247\76\74", "\57\202\136\96\198\79\153\43")][LUAOBFUSACTOR_DECRYPT_STR_0("\190\48\175\147\133\178\246\175\38\184\180\153\168\234\166", "\152\203\67\202\199\237\199")];
				v161 = 1;
			end
			if ((1264 < 4227) and (v161 == 5)) then
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\113\32\188\224\41\240\214", "\165\108\20\84\200\137\71\151")][LUAOBFUSACTOR_DECRYPT_STR_0("\114\177\42\132\85\155\8", "\232\26\212\75")];
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\4\76\102\252\254\57\78\97", "\151\87\41\18\136")][LUAOBFUSACTOR_DECRYPT_STR_0("\83\170\203\220\209\116\140\226\224", "\158\59\207\170\176")] or 0;
				v97 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\124\91\39\93\133\65\89\32", "\236\47\62\83\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\239\186\37\11\191\144\253\172\20\58\184\133\255\189", "\226\154\201\64\91\202")];
				v161 = 6;
			end
			if ((964 == 964) and (v161 == 7)) then
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\35\42\253\24\25\33\238\31", "\108\112\79\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\42\209\113\5\172\4\229\38\43\208\123\37\133\4\232\57\54\204\115\27\184\19\238\48\8\203\96\32\140\7\239\57\54\193\96\45\169", "\85\95\162\20\72\205\97\137")];
				break;
			end
			if ((v161 == 1) or (4597 == 2726)) then
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\70\180\27\22\123\126\245", "\134\154\35\192\111\127\21\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\173\53\12\43\46\209\189\53\29\24\33\222\159\51\0\14\33\220\187\35", "\178\216\70\105\106\64")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\12\46\110\226\192\219\211\147", "\224\95\75\26\150\169\181\180")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\201\221\9\87\184\100\10\214\235\32\77\170\98", "\22\107\186\184\72\36\204")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\184\48\90\7\233\186\55", "\110\135\221\68\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\37\9\198\207\182\55\240\34\30\228\195\155\62\226\58\5\229\201\128\46\241\49\9", "\91\131\86\108\139\174\211")];
				v161 = 2;
			end
			if ((v161 == 2) or (4308 == 4623)) then
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\200\46\172\3\84\245\44\171", "\61\155\75\216\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\184\183\20\93\8\209\13\165\181\15\76\27\216\5\166\134\51\76\12\208", "\189\100\203\210\92\56\105")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\84\233\60\38\95\250\59", "\72\79\49\157")][LUAOBFUSACTOR_DECRYPT_STR_0("\137\190\50\185\155\164\35\189\132\151\36\181\140\177\63\191\141\152\1", "\220\232\208\81")] or 0;
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\198\187\241\36\37\84\166\230", "\193\149\222\133\80\76\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\83\76\215\213\73\93\211\202\122\90\219\194\92\65\209\195\122\93\221\211\77", "\178\166\61\47")] or 0;
				v161 = 3;
			end
			if ((2249 > 546) and (v161 == 3)) then
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\200\79\252\110\195\48\252\89", "\94\155\42\136\26\170")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\44\50\167\133\51\21\189\141\57\50\157\180", "\213\228\95\70")] or 0;
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\25\190\214\144\126\36\188\209", "\23\74\219\162\228")][LUAOBFUSACTOR_DECRYPT_STR_0("\49\227\71\163\50\55\225\117\187\41\60\231\75\155\52\45\227\75\135\11", "\91\89\134\38\207")] or 0;
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\119\235\220\34\26\222\32\87", "\71\36\142\168\86\115\176")][LUAOBFUSACTOR_DECRYPT_STR_0("\215\164\115\179\10\176\81\122\203\179\119\190\14\138\89\93\218\172\85\173\12\171\70", "\41\191\193\18\223\99\222\54")] or 0;
				v161 = 4;
			end
		end
	end
	local function v138()
		local v162 = 0;
		while true do
			if ((2704 <= 3641) and (v162 == 1)) then
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\33\6\57\113\197\35\1", "\24\171\68\114\77")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\20\67\66\130\210\32\168\237\8\86\84\148", "\205\143\125\48\50\231\190\100")];
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\242\162\0\17\232\237\216\177", "\194\161\199\116\101\129\131\191")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\45\219\184\242\174\206\49\206\174\228", "\194\140\68\168\200\151")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\113\254\193\49\252\76\252\198", "\149\34\155\181\69")][LUAOBFUSACTOR_DECRYPT_STR_0("\22\238\208\206\17\244\219\241\6\233\198", "\154\99\157\181")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\10\248\180\229\131\8\255", "\140\237\111\140\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\19\10\120\42\7\26\116\25\10\10", "\120\102\121\29")];
				v162 = 2;
			end
			if ((2 == v162) or (4277 <= 1396)) then
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\159\230\173\47\165\237\190\40", "\91\204\131\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\218\237\92\218\184\216\234\221\200\92\192\187\254\218", "\158\174\159\53\180\211\189")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\97\248\249\201\126\187\85\238", "\213\50\157\141\189\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\236\39\135\169\115\168\237\17\141\180\122\135\218", "\196\158\70\228\192\18")];
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\90\5\90\208\68\88\2", "\185\42\63\113\46")][LUAOBFUSACTOR_DECRYPT_STR_0("\193\206\36\17\30\213\209\53\49\8\192\210\47\60", "\123\180\189\65\89")];
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\241\137\228\240\128\204\139\227", "\233\162\236\144\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\167\215\251\50\188\247\83\187\202\249\42\182\226\86\189\202", "\63\210\164\158\122\217\150")];
				v162 = 3;
			end
			if ((v162 == 3) or (4180 <= 366)) then
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\0\206\226\248\64\246\52\216", "\152\83\171\150\140\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\224\130\63\192\19\27\150\234\141\54\252\43", "\104\226\133\227\83\180\123")] or 0;
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\14\55\68\10\5\36\67", "\48\99\107\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\163\124\220\36\117\217\150\114\196\36\116\208\142\77", "\27\190\198\29\176\77")] or 0;
				v92 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\220\78\233\32\160\64\232\88", "\46\143\43\157\84\201")][LUAOBFUSACTOR_DECRYPT_STR_0("\127\125\87\206\86\29\207\103\119\66\203\80\29\230\86\117\83", "\168\55\24\54\162\63\115")] or "";
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\36\255\52\148\219\192\16\233", "\174\119\154\64\224\178")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\127\203\127\9\162\59\226\44\114\204\120\17\162\30", "\132\74\30\165\27\101\199\122")];
				v162 = 4;
			end
			if ((v162 == 0) or (149 >= 4486)) then
				v96 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\196\248\62\200\4\246\202\228", "\173\151\157\74\188\109\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\1\63\213\200\102\208\254\37\1\54\206\255\92\208\240\47", "\147\68\104\88\189\188\52\181")] or 0;
				v93 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\141\159\196\19\134\140\195", "\176\122\232\235")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\123\46\74\252\146\96\42\91\217\137\97\50\124\250\149\123", "\142\224\21\90\47")];
				v94 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\71\209\51\66\173\133\130\103", "\229\20\180\71\54\196\235")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\112\213\230\231\184\149\57\106\238\237\249\179\183\33\119\213\230\249\163\147\61", "\224\73\30\161\131\149\202")];
				v95 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\224\229\68\248\235\246\67", "\48\145\133\145")][LUAOBFUSACTOR_DECRYPT_STR_0("\115\66\161\235\195\62\79\92\161\218\217\62\95\95\189\225\221\40", "\76\58\44\213\142\177")];
				v162 = 1;
			end
			if ((646 < 1037) and (v162 == 4)) then
				v91 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\226\235\179\174\187\179\60", "\212\79\135\159\199\199\213")][LUAOBFUSACTOR_DECRYPT_STR_0("\81\161\187\67\80\210\49\119\163\186\85\76\216\10\124\161\185", "\120\25\192\213\39\60\183")];
				break;
			end
		end
	end
	local function v139()
		local v163 = 0;
		while true do
			if ((3598 <= 3738) and (v163 == 3)) then
				if (v30 or (823 >= 915)) then
					local v231 = 0;
					while true do
						if ((v231 == 0) or (4962 <= 4365)) then
							v109 = #v106;
							v108 = #v107;
							break;
						end
					end
				else
					local v232 = 0;
					while true do
						if ((0 == v232) or (643 >= 1489)) then
							v109 = 1;
							v108 = 1;
							break;
						end
					end
				end
				if (v14:AffectingCombat() or v89 or (475 == 4175)) then
					local v233 = 0;
					local v234;
					while true do
						if ((v233 == 1) or (2786 < 121)) then
							if ((1896 <= 2815) and v28) then
								return v28;
							end
							break;
						end
						if ((v233 == 0) or (2058 == 2348)) then
							v234 = v89 and v98[LUAOBFUSACTOR_DECRYPT_STR_0("\137\4\77\238\133\185\13\123\255\130\184\1\92", "\235\202\104\40\143")]:IsReady() and v33;
							v28 = v114.FocusUnit(v234, v100, 20, nil, 25);
							v233 = 1;
						end
					end
				end
				if (v114.TargetIsValid() or v14:AffectingCombat() or (3529 <= 1759)) then
					local v235 = 0;
					while true do
						if ((1 == v235) or (358 == 1881)) then
							if ((v113 == 11111) or (2003 == 2771)) then
								v113 = v10.FightRemains(v107, false);
							end
							break;
						end
						if ((v235 == 0) or (2599 < 2368)) then
							v112 = v10.BossFightRemains(nil, true);
							v113 = v112;
							v235 = 1;
						end
					end
				end
				if ((2757 >= 2090) and v14:AffectingCombat()) then
					if ((726 < 1551) and v14:PrevGCD(1, v98.ChainLightning)) then
						v111 = LUAOBFUSACTOR_DECRYPT_STR_0("\46\131\26\176\3\203\55\176\10\131\15\183\4\133\28", "\217\109\235\123");
					elseif ((2388 >= 1946) and v14:PrevGCD(1, v98.LightningBolt)) then
						v111 = LUAOBFUSACTOR_DECRYPT_STR_0("\11\128\121\94\100\222\196\179\32\201\92\89\124\196", "\221\71\233\30\54\16\176\173");
					end
				end
				v163 = 4;
			end
			if ((2 == v163) or (4771 == 3240)) then
				if (v14:IsDeadOrGhost() or (1882 <= 98)) then
					return;
				end
				v102, v104, _, _, v103, v105 = v25();
				v106 = v14:GetEnemiesInRange(40);
				v107 = v14:GetEnemiesInMeleeRange(5);
				v163 = 3;
			end
			if ((4298 > 4297) and (1 == v163)) then
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\58\168\204\5\248\206", "\157\189\85\207\171\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\174\221", "\99\166\193\184\213")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\226\184\135\188\0\143\197", "\234\182\215\224\219\108")][LUAOBFUSACTOR_DECRYPT_STR_0("\195\133\168", "\85\160\225\219")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\10\132\206\58\217\88", "\43\60\101\227\169\86\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\116\193\194\175\95\192", "\87\16\168\177\223\58\172\217")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\0\194\94\218\55\49\222", "\91\84\173\57\189")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\176\2\245\163\210\3", "\182\112\217\108\156\192")];
				v163 = 2;
			end
			if ((2202 < 4968) and (0 == v163)) then
				v137();
				v136();
				v138();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\44\79\56\79\20\69\44", "\40\120\32\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\164\58", "\127\90\203\89\26\207")];
				v163 = 1;
			end
			if ((388 >= 167) and (v163 == 4)) then
				if ((not v14:IsChanneling() and not v14:IsChanneling()) or (655 == 3201)) then
					local v236 = 0;
					while true do
						if ((3611 >= 958) and (v236 == 1)) then
							if ((3619 == 3619) and v14:AffectingCombat()) then
								local v249 = 0;
								while true do
									if ((3817 >= 1959) and (v249 == 0)) then
										v28 = v135();
										if (v28 or (2952 > 3799)) then
											return v28;
										end
										break;
									end
								end
							else
								local v250 = 0;
								while true do
									if ((176 <= 1657) and (v250 == 0)) then
										v28 = v134();
										if (v28 or (1616 >= 4086)) then
											return v28;
										end
										break;
									end
								end
							end
							break;
						end
						if ((2650 >= 1576) and (v236 == 0)) then
							if ((317 < 3696) and Focus) then
								if ((3384 == 3384) and v89) then
									local v253 = 0;
									while true do
										if ((v253 == 0) or (3727 < 2142)) then
											v28 = v125();
											if ((1680 < 2583) and v28) then
												return v28;
											end
											break;
										end
									end
								end
							end
							if ((2012 < 2160) and v90) then
								local v251 = 0;
								while true do
									if ((v251 == 1) or (2342 == 3691)) then
										if (v86 or (4786 <= 238)) then
											local v254 = 0;
											while true do
												if ((3450 <= 4563) and (v254 == 0)) then
													v28 = v114.HandleAfflicted(v98.PoisonCleansingTotem, v98.PoisonCleansingTotem, 30);
													if ((262 <= 3156) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										if ((2384 < 4082) and (v14:BuffStack(v98.MaelstromWeaponBuff) >= 5) and v87) then
											local v255 = 0;
											while true do
												if ((v255 == 0) or (3857 < 2167)) then
													v28 = v114.HandleAfflicted(v98.HealingSurge, v100.HealingSurgeMouseover, 40, true);
													if (v28 or (4438 == 1930)) then
														return v28;
													end
													break;
												end
											end
										end
										break;
									end
									if ((v251 == 0) or (844 < 284)) then
										if ((1111 <= 1244) and v84) then
											local v256 = 0;
											while true do
												if ((0 == v256) or (3970 <= 2329)) then
													v28 = v114.HandleAfflicted(v98.CleanseSpirit, v100.CleanseSpiritMouseover, 40);
													if ((1189 < 3021) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										if ((4168 > 3631) and v85) then
											local v257 = 0;
											while true do
												if ((2916 <= 4027) and (v257 == 0)) then
													v28 = v114.HandleAfflicted(v98.TremorTotem, v98.TremorTotem, 30);
													if ((1572 <= 4075) and v28) then
														return v28;
													end
													break;
												end
											end
										end
										v251 = 1;
									end
								end
							end
							v236 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function v140()
		local v164 = 0;
		while true do
			if ((v164 == 1) or (1810 > 4864)) then
				v19.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\243\242\234\220\185\56\211\241\231\211\163\123\229\244\227\208\182\53\150\254\251\157\146\43\223\255\172\157\132\46\198\236\237\207\163\62\210\188\224\196\247\35\253\253\236\216\163\52\152", "\91\182\156\130\189\215"));
				break;
			end
			if ((1529 < 4520) and (v164 == 0)) then
				v98[LUAOBFUSACTOR_DECRYPT_STR_0("\18\240\95\178\49\207\86\176\55\247\122\186\54\233\88\185", "\223\84\156\62")]:RegisterAuraTracking();
				v115();
				v164 = 1;
			end
		end
	end
	v19.SetAPL(263, v139, v140);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\91\99\165\77\65\64\164\84\115\114\162\106\91\125\164\84\112\112\169\88\123\125\184\27\114\102\173", "\53\30\19\204")]();

