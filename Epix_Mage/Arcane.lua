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
		if ((v5 == 0) or (2843 == 2975)) then
			v6 = v0[v4];
			if (not v6 or (1989 <= 174)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((1 == v5) or (209 > 2153)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\150\198\25\212\252\250\55\229\186\201\27\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\2\43\30\237", "\158\48\118\66\114")];
	local v13 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v14 = v11[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v15 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\207\71\162\74\240", "\38\156\55\199")];
	local v16 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\129\105\121\37", "\35\200\29\28\72\115\20\154")];
	local v17 = EpicLib;
	local v18 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\58\190\194\203", "\84\121\223\177\191\237\76")];
	local v19 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\139\68\204\179\41", "\161\219\54\169\192\90\48\80")];
	local v20 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\100\67\3\55\70", "\69\41\34\96")];
	local v21 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\158\202\217\14", "\75\220\163\183\106\98")];
	local v22 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\33\181\134\58\214\12\169", "\185\98\218\235\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\238\42\34\244\199\165\197\57", "\202\171\92\71\134\190")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\212\33", "\232\73\161\76")];
	local v23 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\180\230\37\199", "\167\214\137\74\171\120\206\83")];
	local v24 = GetItemCount;
	local v25;
	local v26 = false;
	local v27 = false;
	local v28 = false;
	local v29 = false;
	local v30 = false;
	local v31;
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
	local v91 = v15[LUAOBFUSACTOR_DECRYPT_STR_0("\166\241\53\88", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\38\4\186\42\9\19", "\75\103\118\217")];
	local v92 = v16[LUAOBFUSACTOR_DECRYPT_STR_0("\234\85\119\17", "\126\167\52\16\116\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\60\35\129\186\28", "\156\168\78\64\224\212\121")];
	local v93 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\42\239\162\203", "\174\103\142\197")][LUAOBFUSACTOR_DECRYPT_STR_0("\119\58\92\57\43\91", "\152\54\72\63\88\69\62")];
	local v94 = {};
	local v95 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\247\203\227\81\219\202\253", "\60\180\164\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\125\72\0\59\62\226\28\93", "\114\56\62\101\73\71\141")];
	local function v96()
		if (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\138\236\214\203\174\236\248\209\170\250\222", "\164\216\137\187")]:IsAvailable() or (2020 == 1974)) then
			v95[LUAOBFUSACTOR_DECRYPT_STR_0("\246\239\34\162\163\242\7\211\228\61\183\130\251\9\199\224\55\161", "\107\178\134\81\210\198\158")] = v95[LUAOBFUSACTOR_DECRYPT_STR_0("\28\7\145\214\175\52\2\131\196\166\61\45\151\212\185\61\42\135\196\191\62\8\145", "\202\88\110\226\166")];
		end
	end
	v10:RegisterForEvent(function()
		v96();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\226\44\182\222\252\230\48\178\219\235\250\42\176\200\249\243\42\161\222\235\239\38\184\214\254\234\32\172\200\233\235\46\172\208\239\231", "\170\163\111\226\151"));
	v91[LUAOBFUSACTOR_DECRYPT_STR_0("\48\34\177\57\64\50\11\29\49\161\44", "\73\113\80\210\88\46\87")]:RegisterInFlight();
	v91[LUAOBFUSACTOR_DECRYPT_STR_0("\160\62\206\19\233\132\14\204\0\245\128\43\200", "\135\225\76\173\114")]:RegisterInFlight();
	local v97, v98;
	local v99, v100;
	local v101 = 3;
	local v102 = false;
	local v103 = false;
	local v104 = false;
	local v105 = true;
	local v106 = false;
	local v107 = v13:HasTier(29, 4);
	local v108 = 225000 - ((25000 * v22(not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\59\255\187\177\162\184\143\27\255\181\191\162\164", "\199\122\141\216\208\204\221")]:IsAvailable())) + (200000 * v22(not v107)));
	local v109 = 3;
	local v110 = 11111;
	local v111 = 11111;
	local v112;
	v10:RegisterForEvent(function()
		local v130 = 0;
		while true do
			if ((v130 == 0) or (1347 == 1360)) then
				v102 = false;
				v105 = true;
				v130 = 1;
			end
			if ((v130 == 2) or (4461 == 3572)) then
				v111 = 11111;
				break;
			end
			if ((v130 == 1) or (2872 == 318)) then
				v108 = 225000 - ((25000 * v22(not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\140\207\19\241\118\243\133\220\2\253\119\248\180", "\150\205\189\112\144\24")]:IsAvailable())) + (200000 * v22(not v107)));
				v110 = 11111;
				v130 = 2;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\21\168\158\117\33\186\46\34\0\163\154\98\59\173\63\49\7\168\154\104", "\112\69\228\223\44\100\232\113"));
	v10:RegisterForEvent(function()
		v107 = not v13:HasTier(29, 4);
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\228\51\38\234\147\78\185\241\46\50\250\134\81\163\250\43\56\240\158\93\168\243\58\35", "\230\180\127\103\179\214\28"));
	local function v113()
		local v131 = 0;
		while true do
			if ((568 == 568) and (v131 == 2)) then
				if ((4200 == 4200) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\116\95\89\239\122\148\174\6\88\81\78", "\107\57\54\43\157\21\230\231")]:IsCastable() and v61 and (v13:HealthPercentage() <= v67)) then
					if (v19(v91.MirrorImage) or (4285 < 1369)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\130\3\231\182\206\240\210\134\16\242\188\156\203\222\141\20\251\170\213\217\222\203\69", "\175\187\235\113\149\217\188");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\27\189\132\77\247\124\106\21\161\151\69\240\112\122\53\163\136\88\250", "\24\92\207\225\44\131\25")]:IsReady() and v57 and (v13:HealthPercentage() <= v64)) or (3520 > 4910)) then
					if ((2842 <= 4353) and v19(v91.GreaterInvisibility)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\76\193\189\77\15\120\89\236\177\66\13\116\88\218\186\69\23\116\95\202\248\72\30\123\78\221\171\69\13\120\11\134", "\29\43\179\216\44\123");
					end
				end
				v131 = 3;
			end
			if ((v131 == 1) or (3751 < 1643)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\207\198\200\31\234\202\206\54", "\93\134\165\173")]:IsCastable() and v58 and (v13:HealthPercentage() <= v65)) or (4911 == 3534)) then
					if ((3001 > 16) and v19(v91.IceBlock)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\241\196\253\56\194\189\125\181\178\197\199\60\203\188\109\183\228\196\130\105", "\30\222\146\161\162\90\174\210");
					end
				end
				if ((2875 <= 3255) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\204\77\117\41\234\66\116\62\228\66\117\4\241", "\106\133\46\16")]:IsAvailable() and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\113\35\118\223\85\76\92\1\113\245\86\73\76\57", "\32\56\64\19\156\58")]:IsCastable() and v59 and (v13:HealthPercentage() <= v66)) then
					if ((368 < 4254) and v19(v91.IceColdAbility)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\203\224\105\89\253\140\94\136\225\83\92\247\142\73\193\243\83\26\161", "\224\58\168\133\54\58\146");
					end
				end
				v131 = 2;
			end
			if ((v131 == 4) or (4841 <= 2203)) then
				if ((4661 > 616) and v81 and (v13:HealthPercentage() <= v83)) then
					local v205 = 0;
					while true do
						if ((v205 == 0) or (1943 == 2712)) then
							if ((4219 >= 39) and (v85 == LUAOBFUSACTOR_DECRYPT_STR_0("\138\39\120\12\33\232\231\177\44\121\94\12\254\238\180\43\112\25\100\203\224\172\43\113\16", "\143\216\66\30\126\68\155"))) then
								if ((3967 > 2289) and v92[LUAOBFUSACTOR_DECRYPT_STR_0("\152\205\11\217\192\176\223\232\164\207\37\206\196\175\222\239\173\248\2\223\204\172\217", "\129\202\168\109\171\165\195\183")]:IsReady()) then
									if (v19(v93.RefreshingHealingPotion) or (851 > 2987)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\48\93\49\202\219\7\238\43\86\48\152\214\17\231\46\81\57\223\158\4\233\54\81\56\214\158\16\227\36\93\57\203\215\2\227", "\134\66\56\87\184\190\116");
									end
								end
							end
							if ((4893 >= 135) and (v85 == "Dreamwalker's Healing Potion")) then
								if (v92[LUAOBFUSACTOR_DECRYPT_STR_0("\24\35\12\186\20\252\32\57\55\52\27\168\49\238\32\57\53\63\14\139\22\255\40\58\50", "\85\92\81\105\219\121\139\65")]:IsReady() or (3084 > 3214)) then
									if (v19(v93.RefreshingHealingPotion) or (3426 < 2647)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\249\161\85\68\113\200\252\191\91\64\110\204\189\187\85\68\112\214\243\180\16\85\115\203\244\188\94\5\120\218\251\182\94\86\117\201\248", "\191\157\211\48\37\28");
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v131 == 0) or (1576 == 4375)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\188\23\86\85\233\64\244\133\6\125\71\246\83\233\137\23", "\128\236\101\63\38\132\33")]:IsCastable() and v56 and v13:BuffDown(v91.PrismaticBarrier) and (v13:HealthPercentage() <= v63)) or (2920 < 2592)) then
					if (v19(v91.PrismaticBarrier) or (1110 >= 2819)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\170\20\123\180\234\221\190\160\20\86\246\239\202\170\172\31\87\191\253\202\236\248", "\175\204\201\113\36\214\139");
					end
				end
				if ((1824 <= 2843) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\106\205\38\207\38\70\222\39\213\1\85", "\100\39\172\85\188")]:IsCastable() and v60 and v13:BuffDown(v91.PrismaticBarrier) and v95.AreUnitsBelowHealthPercentage(v68, 2)) then
					if ((3062 == 3062) and v19(v91.MassBarrier)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\160\121\170\147\12\175\121\171\146\58\168\106\249\132\54\171\125\183\147\58\187\125\249\210", "\83\205\24\217\224");
					end
				end
				v131 = 1;
			end
			if ((716 <= 4334) and (v131 == 3)) then
				if ((1001 < 3034) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\156\213\52\73\175\237\41\65\184", "\44\221\185\64")]:IsReady() and v55 and (v13:HealthPercentage() <= v62)) then
					if (v19(v91.AlterTime) or (977 > 1857)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\235\92\90\97\62\243\65\82\118\65\227\77\89\118\15\244\65\73\118\65\177", "\19\97\135\40\63");
					end
				end
				if ((v92[LUAOBFUSACTOR_DECRYPT_STR_0("\134\89\50\55\59\57\189\72\60\53\42", "\81\206\60\83\91\79")]:IsReady() and v82 and (v13:HealthPercentage() <= v84)) or (868 > 897)) then
					if (v19(v93.Healthstone) or (1115 == 4717)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\174\209\126\59\203\94\176\65\165\213\50\43\198\75\161\64\184\217\100\42", "\196\46\203\176\18\79\163\45");
					end
				end
				v131 = 4;
			end
		end
	end
	local function v114()
		if ((2740 < 4107) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\237\26\249\19\44\218\60\225\14\41\218", "\90\191\127\148\124")]:IsReady() and v30 and v95.DispellableFriendlyUnit(20)) then
			if ((284 < 700) and v19(v93.RemoveCurseFocus)) then
				return LUAOBFUSACTOR_DECRYPT_STR_0("\106\130\35\24\110\130\17\20\109\149\61\18\56\131\39\4\104\130\34", "\119\24\231\78");
			end
		end
	end
	local function v115()
		local v132 = 0;
		while true do
			if ((386 >= 137) and (v132 == 1)) then
				v25 = v95.HandleBottomTrinket(v94, v28, 40, nil);
				if ((923 == 923) and v25) then
					return v25;
				end
				break;
			end
			if ((v132 == 0) or (4173 == 359)) then
				v25 = v95.HandleTopTrinket(v94, v28, 40, nil);
				if ((1722 == 1722) and v25) then
					return v25;
				end
				v132 = 1;
			end
		end
	end
	local function v116()
		local v133 = 0;
		while true do
			if ((v133 == 0) or (3994 <= 3820)) then
				if ((1488 < 1641) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\175\36\183\88\211\82\56\143\44\162\79", "\113\226\77\197\42\188\32")]:IsCastable() and v88 and v61) then
					if ((433 <= 2235) and v19(v91.MirrorImage)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\31\230\167\53\4\203\188\55\23\243\176\122\6\230\176\57\25\249\183\59\2\180\231", "\213\90\118\148");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\122\60\183\87\67\94\12\184\87\94\79", "\45\59\78\212\54")]:IsReady() and v31 and not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\35\95\147\131\137\32\158\228\31\68\142", "\144\112\54\227\235\230\78\205")]:IsAvailable()) or (1838 > 2471)) then
					if ((2444 < 3313) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\58\12\253\222\94\140\42\3\253\195\79\243\56\29\249\211\84\190\42\14\232\144\15", "\59\211\72\111\156\176");
					end
				end
				v133 = 1;
			end
			if ((1 == v133) or (3685 <= 185)) then
				if ((738 <= 1959) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\107\145\236\46\79\147\234\34\64", "\77\46\231\131")]:IsReady() and v39 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\137\93\166\72\181\90\133\84\181\70\187", "\32\218\52\214")]:IsAvailable())) then
					if (v19(v91.Evocation) or (1317 == 3093)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\1\62\171\240\164\76\85\64\87\33\186\244\179\74\87\76\22\37\232\167", "\58\46\119\81\200\145\208\37");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\10\158\51\173\167\184\25\57\142", "\86\75\236\80\204\201\221")]:IsReady() and v47 and ((v52 and v29) or not v52)) or (2611 >= 4435)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (117 > 4925)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\115\83\116\132\240\142\77\78\101\135\190\155\96\68\116\138\243\137\115\85\55\221", "\235\18\33\23\229\158");
					end
				end
				v133 = 2;
			end
			if ((107 <= 4905) and (2 == v133)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\113\168\194\186\94\191\227\183\81\169\213", "\219\48\218\161")]:IsReady() and v31) or (1004 > 4035)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (2802 < 369)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\229\99\127\72\213\74\223\230\125\125\90\207\15\240\246\116\127\70\214\77\225\240\49\36", "\128\132\17\28\41\187\47");
					end
				end
				break;
			end
		end
	end
	local function v117()
		local v134 = 0;
		while true do
			if ((1497 <= 2561) and (v134 == 0)) then
				if ((((v98 >= v101) or (v99 >= v101)) and ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\32\32\5\59\83\4\29\20\56", "\61\97\82\102\90")]:Charges() > 0) or (v13:ArcaneCharges() >= 3)) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\158\47\175\66\198\89\10\58\188\47\185\64", "\105\204\78\203\43\167\55\126")]:CooldownUp() and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\145\165\54\29\27\11\193\69\173\175\14\31\20\13", "\49\197\202\67\126\115\100\167")]:CooldownRemains() <= (v112 * 2))) or (816 > 1712)) then
					v103 = true;
				elseif ((v103 and v14:DebuffDown(v91.RadiantSparkVulnerability) and (v14:DebuffRemains(v91.RadiantSparkDebuff) < 7) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\5\90\219\32\129\88\74\4\75\222\59\139", "\62\87\59\191\73\224\54")]:CooldownDown()) or (2733 == 2971)) then
					v103 = false;
				end
				if ((2599 < 4050) and (v13:ArcaneCharges() > 3) and ((v98 < v101) or (v99 < v101)) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\213\3\254\192\230\12\238\250\247\3\232\194", "\169\135\98\154")]:CooldownUp() and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\255\120\49\87\245\60\206\223\127\33\121\252\52\193", "\168\171\23\68\52\157\83")]:CooldownRemains() <= (v112 * 7)) and ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\213\99\246\172\43\40\180\225\99\242\168", "\231\148\17\149\205\69\77")]:CooldownRemains() <= (v112 * 5)) or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\161\181\196\250\89\250\179\178\213\252\82", "\159\224\199\167\155\55")]:CooldownRemains() > 40))) then
					v104 = true;
				elseif ((2034 == 2034) and v104 and v14:DebuffDown(v91.RadiantSparkVulnerability) and (v14:DebuffRemains(v91.RadiantSparkDebuff) < 7) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\197\242\56\219\246\253\40\225\231\242\46\217", "\178\151\147\92")]:CooldownDown()) then
					v104 = false;
				end
				v134 = 1;
			end
			if ((3040 < 4528) and (v134 == 1)) then
				if ((v14:DebuffUp(v91.TouchoftheMagiDebuff) and v105) or (2092 <= 2053)) then
					v105 = false;
				end
				v106 = v91[LUAOBFUSACTOR_DECRYPT_STR_0("\173\239\79\51\28\73\88\128\252\95\38", "\26\236\157\44\82\114\44")]:CastTime() < v112;
				break;
			end
		end
	end
	local function v118()
		local v135 = 0;
		while true do
			if ((2120 < 4799) and (4 == v135)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\203\188\183\59\254\160\177\45\244\168\159\33\245\170", "\72\155\206\210")]:IsCastable() and v42 and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) or (4538 <= 389)) then
					if ((270 <= 1590) and v19(v91.PresenceofMind)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\86\104\81\29\54\72\121\81\49\60\64\69\89\7\61\66\58\87\1\60\74\126\91\25\61\121\106\92\15\32\67\58\7\94", "\83\38\26\52\110");
					end
				end
				if ((1625 > 1265) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\121\5\36\71\86\18\5\74\89\4\51", "\38\56\119\71")]:IsReady() and v31 and (v13:BuffUp(v91.PresenceofMindBuff))) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (51 >= 920)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\242\253\91\215\43\83\204\237\84\215\54\66\179\236\87\217\41\82\252\248\86\233\53\94\242\252\93\150\118\4", "\54\147\143\56\182\69");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\247\147\252\72\209\211\172\246\90\204\223\141\250\90", "\191\182\225\159\41")]:IsReady() and v36 and v13:BuffDown(v91.NetherPrecisionBuff) and v13:BuffUp(v91.ClearcastingBuff) and (v14:DebuffDown(v91.RadiantSparkVulnerability) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 4) and v13:PrevGCDP(1, v91.ArcaneBlast)))) or (2968 <= 1998)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (3085 <= 2742)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\0\43\84\133\130\253\38\27\59\70\130\139\199\56\82\43\90\132\139\198\36\5\38\106\155\143\195\56\23\104\6\223", "\162\75\114\72\53\235\231");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\173\46\71\227\93\7\174\48\69\241\71", "\98\236\92\36\130\51")]:IsReady() and v31) or (376 >= 2083)) then
					if ((4191 > 1232) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\11\15\187\75\173\138\50\168\24\31\174\5\171\186\63\168\29\3\173\75\151\165\56\165\10\9\250\22\254", "\80\196\121\108\218\37\200\213");
					end
				end
				break;
			end
			if ((v135 == 2) or (1505 > 4873)) then
				if ((3880 < 4534) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\51\239\54\53\120\23\208\60\39\101\27\241\48\39", "\22\114\157\85\84")]:IsReady() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v13:BuffStack(v91.ClearcastingBuff) >= 2) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\246\202\23\205\92\248\188\247\219\18\214\86", "\200\164\171\115\164\61\150")]:CooldownRemains() < 5) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffDown(v91.ArcaneArtilleryBuff) or (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * 6))) and not v13:HasTier(30, 4)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (2368 >= 2541)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\230\0\68\141\187\203\14\76\144\173\253\15\64\144\254\247\12\74\143\186\251\20\75\188\174\252\2\86\134\254\165\87", "\227\222\148\99\37");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\18\64\81\247\247\54\127\91\229\234\58\94\87\229", "\153\83\50\50\150")]:IsReady() and v36 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\124\100\112\29\125\174\101\92\100\126\19\125\178", "\45\61\22\19\124\19\203")]:IsAvailable() and (v13:BuffStack(v91.ArcaneHarmonyBuff) < 15) and ((v105 and v13:BloodlustUp()) or (v13:BuffUp(v91.ClearcastingBuff) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\243\19\9\252\3\126\173\242\2\12\231\9", "\217\161\114\109\149\98\16")]:CooldownRemains() < 5))) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\51\50\59\125\178\113\33\53\42\123\185", "\20\114\64\88\28\220")]:CooldownRemains() < 30)) or (4733 <= 4103)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (1207 == 4273)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\48\19\209\181\246\213\130\60\8\193\167\241\220\184\34\65\209\187\247\220\185\62\22\220\139\232\216\188\34\4\146\229\174", "\221\81\97\178\212\152\176");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\236\245\30\250\20\200\202\20\232\9\196\235\24\232", "\122\173\135\125\155")]:IsReady() and v36 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\182\192\4\176\62\63\220\183\209\1\171\52", "\168\228\161\96\217\95\81")]:CooldownUp() and v13:BuffUp(v91.ClearcastingBuff) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\245\212\58\84\42\69\235\195\43\95\38\68\210\222\32", "\55\187\177\78\60\79")]:IsAvailable() and (v13:BuffDown(v91.NetherPrecisionBuff) or (v13:BuffRemains(v91.NetherPrecisionBuff) < v112)) and v13:HasTier(30, 4)) or (2005 == 2529)) then
					if ((986 < 3589) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\220\92\234\72\202\191\32\199\76\248\79\195\133\62\142\92\228\73\195\132\34\217\81\212\86\199\129\62\203\31\186\30", "\224\77\174\63\139\38\175");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\182\64\92\39\133\79\76\29\148\64\74\37", "\78\228\33\56")]:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) or (3119 == 430)) then
					if ((2409 <= 3219) and v19(v91.RadiantSpark, not v14:IsSpellInRange(v91.RadiantSpark), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\127\182\10\132\192\106\141\16\149\207\108\185\67\134\193\113\190\7\138\217\112\141\19\141\207\109\183\67\215\158", "\229\174\30\210\99");
					end
				end
				v135 = 3;
			end
			if ((v135 == 0) or (898 > 2782)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\30\33\192\88\34\33\211\79\34\43\248\90\45\39", "\59\74\78\181")]:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v13:PrevGCDP(1, v91.ArcaneBarrage))) or (2250 <= 1764)) then
					if ((693 == 693) and v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\222\79\89\187\26\222\92\101\167\45\212\101\87\178\34\216\26\89\188\42\221\94\85\164\43\238\74\82\178\54\212\26\8", "\211\69\177\58\58");
					end
				end
				if (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\133\228\125\252\232\197\163\214\105\244\251\192", "\171\215\133\25\149\137")]:CooldownUp() or (2529 == 438)) then
					v102 = v91[LUAOBFUSACTOR_DECRYPT_STR_0("\192\218\49\251\225\53\207\87\243\207\55", "\34\129\168\82\154\143\80\156")]:CooldownRemains() < 10;
				end
				if ((1751 > 1411) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\182\186\58\13\92\71\135\130\130\60\28\77\92", "\233\229\210\83\107\40\46")]:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v13:BuffDown(v91.ArcaneSurgeBuff) and not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\243\67\54\223\4\207\86\1\198\4\211\73", "\101\161\34\82\182")]:IsAvailable()) then
					if ((4182 == 4182) and v19(v91.ShiftingPower, not v14:IsInRange(40), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\251\5\80\248\207\235\140\41\215\29\86\233\222\240\194\45\231\2\85\250\212\245\140\17\248\5\88\237\222\162\214", "\78\136\109\57\158\187\130\226");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\31\45\250\240\48\58\214\227\60", "\145\94\95\153")]:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\207\204\16\220\79\185\233\254\4\212\92\188", "\215\157\173\116\181\46")]:CooldownUp() and (v13:ArcaneCharges() < v13:ArcaneChargesMax())) or (4666 <= 611)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (4737 <= 4525)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\166\136\243\212\48\139\132\224\216\117\183\132\253\214\49\187\156\252\229\37\188\138\225\223\117\226", "\186\85\212\235\146");
					end
				end
				v135 = 1;
			end
			if ((4367 >= 3735) and (v135 == 3)) then
				if ((2426 == 2426) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\53\232\146\89\232\47\13\30\224\150\84\254\41", "\89\123\141\230\49\141\93")]:IsReady() and v41 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\221\116\226\4\21\88\199\116\251\28\21\89\231", "\42\147\17\150\108\112")]:TimeSinceLastCast() >= 30) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\46\180\46\126\233\237\42\165\37\112", "\136\111\198\77\31\135")]:IsAvailable())) then
					if ((21 < 1971) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\12\12\179\94\184\246\40\189\7\4\183\83\174\240\87\170\13\6\171\82\178\243\25\150\18\1\166\69\184\164\69\251", "\201\98\105\199\54\221\132\119");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\152\30\128\32\12\48\159\172\30\132\36", "\204\217\108\227\65\98\85")]:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) or (2922 <= 441)) then
					if ((3624 >= 1136) and v19(v91.ArcaneSurge, not v14:IsSpellInRange(v91.ArcaneSurge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\209\246\228\34\197\97\208\224\247\43\197\30\192\250\234\32\196\81\212\251\218\60\200\95\208\240\165\126\148", "\160\62\163\149\133\76");
					end
				end
				if ((2043 < 2647) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\247\178\14\46\205\211\130\12\61\209\215\167\8", "\163\182\192\109\79")]:IsReady() and v32 and (v13:PrevGCDP(1, v91.ArcaneSurge) or v13:PrevGCDP(1, v91.NetherTempest) or v13:PrevGCDP(1, v91.RadiantSpark))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (354 >= 1534)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\52\3\193\251\49\25\2\193\231\38\39\7\197\181\55\41\15\204\241\59\49\14\255\229\60\39\19\197\181\102\112", "\149\84\70\96\160");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\25\20\14\236\54\3\47\225\57\21\25", "\141\88\102\109")]:IsReady() and v31 and v14:DebuffUp(v91.RadiantSparkVulnerability) and (v14:DebuffStack(v91.RadiantSparkVulnerability) < 4)) or (3764 >= 4876)) then
					if ((3676 >= 703) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\178\65\201\113\20\56\106\195\191\82\217\100\90\62\90\206\191\87\197\103\20\2\69\201\178\64\207\48\72\101", "\161\211\51\170\16\122\93\53");
					end
				end
				v135 = 4;
			end
			if ((3811 > 319) and (v135 == 1)) then
				if ((47 < 1090) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\227\147\21\255\55\235\122\206\128\5\234", "\56\162\225\118\158\89\142")]:IsReady() and v31 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\110\4\196\166\35\214\72\54\208\174\48\211", "\184\60\101\160\207\66")]:CooldownUp() and ((v13:ArcaneCharges() < 2) or ((v13:ArcaneCharges() < v13:ArcaneChargesMax()) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\16\144\127\189\63\135\83\174\51", "\220\81\226\28")]:CooldownRemains() >= v112)))) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (1371 >= 2900)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\199\129\250\228\194\44\215\142\250\249\211\83\214\141\244\230\195\28\194\140\196\250\207\18\198\135\187\178", "\167\115\181\226\155\138");
					end
				end
				if ((v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == 0) and (v13:ManaPercentage() > 30) and v13:BuffUp(v91.NetherPrecisionBuff) and v13:BuffDown(v91.ArcaneArtilleryBuff)) or (1126 <= 504)) then
					if (v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (3732 == 193)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\48\228\93\117\116\249\239\43\244\79\114\125\195\241\98\238\82\111\116\212\240\55\247\72\59\114\201\237\46\227\83\108\127\249\242\42\230\79\126\49\151\178", "\166\130\66\135\60\27\17");
					end
				end
				if ((3344 >= 3305) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\101\88\205\116\62\65\103\199\102\35\77\70\203\102", "\80\36\42\174\21")]:IsReady() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\124\17\51\115\79\30\35\73\94\17\37\113", "\26\46\112\87")]:CooldownRemains() < 5) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffDown(v91.ArcaneArtilleryBuff) or (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * 6))) and v13:HasTier(31, 4)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (2885 < 1925)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\184\49\168\117\177\186\122\185\176\48\184\125\179\186\86\244\186\44\164\120\187\176\82\186\134\51\163\117\172\186\5\229\233", "\212\217\67\203\20\223\223\37");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\155\159\171\211\180\136\138\222\187\158\188", "\178\218\237\200")]:IsReady() and v31 and v105 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\151\167\229\209\184\176\213\197\164\178\227", "\176\214\213\134")]:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v108) and (v13:BuffRemains(v91.SiphonStormBuff) > 17) and not v13:HasTier(30, 4)) or (4542 <= 1594)) then
					if ((338 <= 3505) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\191\181\213\166\83\102\246\161\183\199\188\22\90\251\162\186\208\167\65\87\203\189\190\213\187\83\25\165\255", "\57\148\205\214\180\200\54");
					end
				end
				v135 = 2;
			end
		end
	end
	local function v119()
		local v136 = 0;
		while true do
			if ((69 == 69) and (v136 == 3)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\5\4\175\224\63\245\245\40\23\191\245", "\183\68\118\204\129\81\144")]:IsReady() and v31 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\47\191\115\229\5\135\44\161\113\247\31", "\226\110\205\16\132\107")]:CastTime() >= v13:GCD()) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\202\209\227\216\79\238\225\236\216\82\255", "\33\139\163\128\185")]:ExecuteTime() < v14:DebuffRemains(v91.RadiantSparkVulnerability)) and (not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\118\74\7\223\89\93\38\209\90\90\5\204\83\85\1\208\67", "\190\55\56\100")]:IsAvailable() or (v14:HealthPercentage() >= 35)) and ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\120\170\40\22\22\241\199\83\162\44\27\0\247", "\147\54\207\92\126\115\131")]:IsAvailable() and v13:PrevGCDP(6, v91.RadiantSpark)) or (not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\35\52\33\117\8\108\57\52\56\109\8\109\25", "\30\109\81\85\29\109")]:IsAvailable() and v13:PrevGCDP(5, v91.RadiantSpark))) and not (v13:IsCasting(v91.ArcaneSurge) and (v13:CastRemains() < 0.5) and not v106)) or (672 == 368)) then
					if ((1019 == 1019) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\254\99\87\183\56\219\195\253\125\85\165\34\158\239\239\112\70\189\9\206\244\254\98\81\246\100\142", "\156\159\17\52\214\86\190");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\143\253\190\189\160\234\159\189\188\253\188\187\171", "\220\206\143\221")]:IsReady() and v32 and (v14:DebuffStack(v91.RadiantSparkVulnerability) == 4)) or (290 > 2746)) then
					if ((1923 < 4601) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\111\46\22\214\201\237\132\124\63\5\217\203\215\198\110\61\22\202\199\237\150\117\44\4\221\140\128\212", "\178\230\29\77\119\184\172");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\193\177\31\24\127\247\243\170\2\30\90\249\242\183", "\152\149\222\106\123\23")]:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and v13:PrevGCDP(1, v91.ArcaneBarrage) and ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\252\52\245\66\187\216\4\247\81\167\220\33\243", "\213\189\70\150\35")]:InFlight() and ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\110\71\119\9\65\80\86\9\93\71\117\15\74", "\104\47\53\20")]:TravelTime() - v91[LUAOBFUSACTOR_DECRYPT_STR_0("\130\94\130\29\178\10\129\77\147\14\189\8\166", "\111\195\44\225\124\220")]:TimeSinceLastCast()) <= 0.2)) or (v13:GCDRemains() <= 0.2))) or (3957 == 2099)) then
					if ((4006 > 741) and v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\73\21\112\163\148\215\64\63\103\163\174\231\75\1\116\162\235\203\86\1\97\160\148\200\78\1\96\174\235\138\18", "\203\184\38\96\19\203");
					end
				end
				v136 = 4;
			end
			if ((2359 <= 3733) and (v136 == 1)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\161\238\129\119\62\237\148\26\129\239\150", "\118\224\156\226\22\80\136\214")]:IsReady() and v31 and v105 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\99\252\90\129\76\235\106\149\80\233\92", "\224\34\142\57")]:CooldownUp() and v13:BloodlustUp() and (v13:Mana() >= v108) and (v13:BuffRemains(v91.SiphonStormBuff) > 15)) or (4596 <= 2402)) then
					if ((2078 > 163) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\223\181\198\220\125\244\98\12\210\166\214\201\51\226\77\15\204\172\250\205\123\240\78\11\158\241", "\110\190\199\165\189\19\145\61");
					end
				end
				if ((4116 > 737) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\251\249\116\233\133\194\247\226\100\251\130\203\223\248", "\167\186\139\23\136\235")]:IsCastable() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v13:BuffStack(v91.ClearcastingBuff) >= 2) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\40\180\140\4\27\187\156\62\10\180\154\6", "\109\122\213\232")]:CooldownRemains() < 5) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * 6))) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (1175 > 4074)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\239\229\161\49\224\242\157\61\231\228\177\57\226\242\177\112\253\231\163\34\229\200\178\56\239\228\167\112\191\167", "\80\142\151\194");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\34\212\116\77\13\195\90\69\16\213\126\64\6\213", "\44\99\166\23")]:IsReady() and v36 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\93\229\42\55\61\161\84\246\59\59\60\170\101", "\196\28\151\73\86\83")]:IsAvailable() and (v13:BuffStack(v91.ArcaneHarmonyBuff) < 15) and ((v105 and v13:BloodlustUp()) or (v13:BuffUp(v91.ClearcastingBuff) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\193\2\45\25\131\86\12\69\227\2\59\27", "\22\147\99\73\112\226\56\120")]:CooldownRemains() < 5))) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\153\103\225\244\131\189\70\247\231\138\189", "\237\216\21\130\149")]:CooldownRemains() < 30)) or (1361 == 4742)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (4012 >= 4072)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\131\92\92\94\190\204\97\143\71\76\76\185\197\91\145\14\76\79\177\219\85\189\94\87\94\163\204\30\211\28", "\62\226\46\63\63\208\169");
					end
				end
				v136 = 2;
			end
			if ((3807 >= 1276) and (v136 == 0)) then
				if ((2220 <= 4361) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\46\118\22\119\78\28\190\5\126\18\122\88\26", "\234\96\19\98\31\43\110")]:IsReady() and v41 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\40\26\70\207\169\96\191\3\18\66\194\191\102", "\235\102\127\50\167\204\18")]:TimeSinceLastCast() >= 45) and v14:DebuffDown(v91.NetherTempestDebuff) and v105 and v13:BloodlustUp()) then
					if ((228 == 228) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\94\164\225\43\65\60\111\181\240\46\84\43\67\181\181\48\84\47\66\170\202\51\76\47\67\164\181\113", "\78\48\193\149\67\36");
					end
				end
				if ((v105 and v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == 0) and v13:BuffUp(v91.NetherPrecisionBuff) and v13:BuffDown(v91.ArcaneArtilleryBuff)) or (4118 <= 3578)) then
					if (v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (2915 < 1909)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\49\12\131\25\79\53\33\141\17\82\35\23\140\29\82\112\23\142\12\68\34\12\149\8\85\112\13\144\25\83\59\33\144\16\64\35\27\192\76", "\33\80\126\224\120");
					end
				end
				if ((634 <= 2275) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\205\186\0\197\82\233\133\10\215\79\229\164\6\215", "\60\140\200\99\164")]:IsCastable() and v36 and v105 and v13:BloodlustUp() and v13:BuffUp(v91.ClearcastingBuff) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\181\245\0\47\163\137\224\55\54\163\149\255", "\194\231\148\100\70")]:CooldownRemains() < 5) and v13:BuffDown(v91.NetherPrecisionBuff) and (v13:BuffDown(v91.ArcaneArtilleryBuff) or (v13:BuffRemains(v91.ArcaneArtilleryBuff) <= (v112 * 6))) and v13:HasTier(31, 4)) then
					if ((1091 <= 2785) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\71\94\194\162\248\205\121\65\200\176\229\193\74\73\210\227\229\216\71\94\202\156\230\192\71\95\196\227\162", "\168\38\44\161\195\150");
					end
				end
				v136 = 1;
			end
			if ((4638 >= 2840) and (v136 == 4)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\24\97\122\64\192\60\81\117\64\221\45", "\174\89\19\25\33")]:IsReady() and v31) or (1292 > 4414)) then
					if ((3511 == 3511) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\46\0\81\79\249\130\52\45\30\83\93\227\199\24\63\19\64\69\200\151\3\46\1\87\14\165\209", "\107\79\114\50\46\151\231");
					end
				end
				if ((2132 == 2132) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\24\180\182\40\132\60\149\193\43\180\180\46\143", "\160\89\198\213\73\234\89\215")]:IsReady() and v32) then
					if ((932 <= 3972) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\99\183\255\203\77\78\182\255\215\90\112\179\251\133\91\97\181\236\206\119\97\188\255\214\77\49\230\166", "\165\40\17\212\158");
					end
				end
				break;
			end
			if ((v136 == 2) or (4560 <= 2694)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\215\24\81\138\30\3\59\109\245\24\71\136", "\62\133\121\53\227\127\109\79")]:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) or (2531 >= 3969)) then
					if (v19(v91.RadiantSpark, not v14:IsSpellInRange(v91.RadiantSpark)) or (738 > 2193)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\2\21\54\252\215\160\182\47\7\34\244\196\165\226\3\4\51\231\221\145\178\24\21\33\240\150\255\246", "\194\112\116\82\149\182\206");
					end
				end
				if ((4606 >= 3398) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\23\173\88\16\197\240\58\60\165\92\29\211\246", "\110\89\200\44\120\160\130")]:IsReady() and v41 and not v106 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\133\198\95\78\70\88\15\72\166\211\78\85\87", "\45\203\163\43\38\35\42\91")]:TimeSinceLastCast() >= 15) and ((not v106 and v13:PrevGCDP(4, v91.RadiantSpark) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\243\151\223\34\137\172\103\199\151\219\38", "\52\178\229\188\67\231\201")]:CooldownRemains() <= v91[LUAOBFUSACTOR_DECRYPT_STR_0("\15\68\68\12\242\78\23\36\76\64\1\228\72", "\67\65\33\48\100\151\60")]:ExecuteTime())) or v13:PrevGCDP(5, v91.RadiantSpark))) then
					if ((1853 > 1742) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\226\186\208\246\205\216\186\221\254\207\226\189\204\179\204\247\175\202\248\224\247\166\217\224\218\167\255\142", "\147\191\135\206\184");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\165\58\165\192\214\86\129\145\58\161\196", "\210\228\72\198\161\184\51")]:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111) and ((not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\24\76\231\24\118\220\2\76\254\0\118\221\34", "\174\86\41\147\112\19")]:IsAvailable() and ((v13:PrevGCDP(4, v91.RadiantSpark) and not v106) or v13:PrevGCDP(5, v91.RadiantSpark))) or v13:PrevGCDP(1, v91.NetherTempest))) or (2442 > 2564)) then
					if ((4374 >= 4168) and v19(v91.ArcaneSurge, not v14:IsSpellInRange(v91.ArcaneSurge))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\18\142\10\43\10\46\184\78\18\138\14\101\28\1\170\73\11\178\27\45\14\2\174\27\81\213", "\203\59\96\237\107\69\111\113");
					end
				end
				v136 = 3;
			end
		end
	end
	local function v120()
		local v137 = 0;
		while true do
			if ((v137 == 1) or (4576 > 4938)) then
				if ((2930 > 649) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\34\77\192\250\13\90\236\233\1", "\155\99\63\163")]:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\163\195\162\140\183\129\173\195\163", "\228\226\177\193\237\217")]:TimeSinceLastCast() >= 15) and (v13:ArcaneCharges() < 3)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (1394 < 133)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\162\32\231\58\181\28\233\38\178\99\231\59\181\28\245\36\177\49\237\11\160\43\231\39\181\99\176", "\134\84\208\67");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\61\169\146\84\22\190\178\89\30\188\131\79\7", "\60\115\204\230")]:IsReady() and v41 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\201\63\255\120\226\40\223\117\234\42\238\99\243", "\16\135\90\139")]:TimeSinceLastCast() >= 15) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\117\102\5\50\64\81\93\87\124\9", "\24\52\20\102\83\46\52")]:IsAvailable())) or (432 == 495)) then
					if ((66 < 1456) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\202\42\53\44\10\214\16\53\33\2\212\42\50\48\79\197\32\36\27\28\212\46\51\47\48\212\39\32\55\10\132\119", "\111\164\79\65\68");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\231\203\128\223\32\239\245\204\145\217\43", "\138\166\185\227\190\78")]:IsReady() and v45 and ((v50 and v28) or not v50) and (v76 < v111)) or (878 >= 3222)) then
					if (v19(v91.ArcaneSurge, not v14:IsSpellInRange(v91.ArcaneSurge)) or (254 >= 3289)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\202\102\198\54\92\38\38\216\97\215\48\87\99\24\196\113\250\36\66\34\11\192\75\213\63\83\48\28\139\37\149", "\121\171\20\165\87\50\67");
					end
				end
				v137 = 2;
			end
			if ((v137 == 3) or (2711 <= 705)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\135\69\192\14\36\176\180\82\202\27\12\183\185\83", "\222\215\55\165\125\65")]:IsCastable() and v42) or (2506 >= 3366)) then
					if (v19(v91.PresenceofMind) or (123 > 746)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\195\195\9\247\207\238\79\19\222\192\37\255\200\227\78\108\208\201\31\205\210\253\75\62\218\249\10\250\192\254\79\108\128\158", "\42\76\177\166\122\146\161\141");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\132\152\6\207\119\115\135\134\4\221\109", "\22\197\234\101\174\25")]:IsReady() and v31 and ((((v14:DebuffStack(v91.RadiantSparkVulnerability) == 2) or (v14:DebuffStack(v91.RadiantSparkVulnerability) == 3)) and not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\2\38\167\254\119\189\197\135\42\49", "\230\77\84\197\188\22\207\183")]:IsAvailable()) or (v14:DebuffUp(v91.RadiantSparkVulnerability) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\214\6\196\222\141\179\226\52\254\17", "\85\153\116\166\156\236\193\144")]:IsAvailable()))) or (4444 <= 894)) then
					if ((1376 > 583) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\165\242\78\178\234\5\155\226\65\178\247\20\228\225\66\182\219\19\180\225\95\184\219\16\172\225\94\182\164\82\244", "\96\196\128\45\211\132");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\20\159\120\94\220\170\150\217\39\159\122\88\215", "\184\85\237\27\63\178\207\212")]:IsReady() and v32 and (((v14:DebuffStack(v91.RadiantSparkVulnerability) == 4) and v13:BuffUp(v91.ArcaneSurgeBuff)) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 3) and v13:BuffDown(v91.ArcaneSurgeBuff) and not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\39\75\11\125\9\75\27\94\15\92", "\63\104\57\105")]:IsAvailable()))) or (2427 == 2455)) then
					if ((3393 >= 2729) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\149\167\69\5\130\155\70\10\149\182\69\12\130\228\69\4\130\155\87\27\134\182\79\52\151\172\69\24\130\228\22\89", "\36\107\231\196");
					end
				end
				break;
			end
			if ((4175 == 4175) and (v137 == 2)) then
				if ((4584 > 1886) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\231\42\186\55\183\7\228\57\171\36\184\5\195", "\98\166\88\217\86\217")]:IsReady() and v32 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\215\228\122\0\136\217\197\227\107\6\131", "\188\150\150\25\97\230")]:CooldownRemains() < 75) and (v14:DebuffStack(v91.RadiantSparkVulnerability) == 4) and not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\245\155\93\32\13\255\200\136\88\7", "\141\186\233\63\98\108")]:IsAvailable()) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (1043 >= 2280)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\248\47\183\43\244\213\46\183\55\227\235\43\179\101\240\229\41\137\54\225\235\62\189\26\225\226\45\165\32\177\187\126", "\69\145\138\76\214");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\81\221\138\136\177\19\82\206\155\155\190\17\117", "\118\16\175\233\233\223")]:IsReady() and v32 and (((v14:DebuffStack(v91.RadiantSparkVulnerability) == 2) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\170\150\54\186\224\142\78\158\150\50\190", "\29\235\228\85\219\142\235")]:CooldownRemains() > 75)) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 1) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\28\198\185\220\121\75\20\71\47\211\191", "\50\93\180\218\189\23\46\71")]:CooldownRemains() < 75) and not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\241\182\89\110\69\206\90\223\163\94", "\40\190\196\59\44\36\188")]:IsAvailable()))) or (667 < 71)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (4482 < 2793)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\87\223\181\244\120\50\62\68\206\166\251\122\8\124\68\211\177\197\110\29\61\87\215\139\234\117\12\47\64\156\229\174", "\109\92\37\188\212\154\29");
					end
				end
				if ((561 < 4519) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\37\253\167\194\63\95\38\238\182\209\48\93\1", "\58\100\143\196\163\81")]:IsReady() and v32 and ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 1) or (v14:DebuffStack(v91.RadiantSparkVulnerability) == 2) or ((v14:DebuffStack(v91.RadiantSparkVulnerability) == 3) and ((v98 > 5) or (v99 > 5))) or (v14:DebuffStack(v91.RadiantSparkVulnerability) == 4)) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\53\80\33\129\62\91\247\15\29\71", "\110\122\34\67\195\95\41\133")]:IsAvailable()) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (677 == 1434)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\116\163\88\75\216\112\142\89\75\196\103\176\92\79\150\116\190\94\117\197\101\176\73\65\233\101\185\90\89\211\53\224\13", "\182\21\209\59\42");
					end
				end
				v137 = 3;
			end
			if ((2827 == 2827) and (v137 == 0)) then
				if ((2556 == 2556) and v13:BuffUp(v91.PresenceofMindBuff) and v89 and (v13:PrevGCDP(1, v91.ArcaneBlast)) and (v13:CooldownRemains(v91.ArcaneSurge) > 75)) then
					if (v19(v93.CancelPOM) or (3106 >= 4932)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\230\216\6\48\35\233\153\24\33\35\246\220\6\48\35\218\214\14\12\43\236\215\12\115\39\234\220\55\32\54\228\203\3\12\54\237\216\27\54\102\180", "\70\133\185\104\83");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\48\74\81\41\193\11\67\80\34\204\41\68\67\35", "\169\100\37\36\74")]:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v13:PrevGCDP(1, v91.ArcaneBarrage))) or (1217 <= 503)) then
					if (v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi)) or (441 >= 4871)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\20\136\183\83\8\184\173\86\63\147\170\85\63\138\163\87\9\199\163\95\5\184\177\64\1\149\169\111\16\143\163\67\5\199\240", "\48\96\231\194");
					end
				end
				if ((3751 > 731) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\250\91\10\36\24\214\187\176\216\91\28\38", "\227\168\58\110\77\121\184\207")]:IsReady() and v48 and ((v53 and v29) or not v53) and (v76 < v111)) then
					if (v19(v91.RadiantSpark, not v14:IsSpellInRange(v91.RadiantSpark), true) or (2515 < 1804)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\105\61\187\73\176\213\101\154\104\44\190\82\186\155\112\170\126\3\172\80\176\201\122\154\107\52\190\83\180\155\37", "\197\27\92\223\32\209\187\17");
					end
				end
				v137 = 1;
			end
		end
	end
	local function v121()
		local v138 = 0;
		while true do
			if ((3008 > 1924) and (v138 == 2)) then
				if ((295 == 295) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\149\155\211\47\50\168\23\184\136\195\58", "\85\212\233\176\78\92\205")]:IsReady() and v31 and (v13:BuffUp(v91.NetherPrecisionBuff))) then
					if ((4828 >= 1725) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\74\139\227\68\93\183\224\70\89\155\246\10\76\135\247\73\80\183\242\66\89\155\231\10\9\220", "\130\42\56\232");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\203\167\39\226\78\58\199\188\55\240\73\51\239\166", "\95\138\213\68\131\32")]:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and ((v14:DebuffRemains(v91.TouchoftheMagiDebuff) > v91[LUAOBFUSACTOR_DECRYPT_STR_0("\11\58\162\66\120\47\5\168\80\101\35\36\164\80", "\22\74\72\193\35")]:CastTime()) or not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\28\107\225\75\41\119\231\93\35\127\201\81\34\125", "\56\76\25\132")]:IsAvailable())) or (4201 < 2150)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (3076 >= 4666)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\95\211\168\39\193\91\254\166\47\220\77\200\167\35\220\30\213\164\51\204\86\254\187\46\206\77\196\235\119\151", "\175\62\161\203\70");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\29\207\192\18\59\57\255\207\18\38\40", "\85\92\189\163\115")]:IsReady() and v31) or (2027 >= 3030)) then
					if ((3245 <= 3566) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\40\190\51\57\39\169\15\58\37\173\35\44\105\184\63\45\42\164\15\40\33\173\35\61\105\254\96", "\88\73\204\80");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\15\145\19\71\39\223\12\130\2\84\40\221\43", "\186\78\227\112\38\73")]:IsReady() and v32) or (2627 <= 381)) then
					if ((283 < 4544) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\253\69\254\84\93\127\195\85\252\71\65\123\251\82\189\65\92\111\255\95\194\69\91\123\239\82\189\7\1", "\26\156\55\157\53\51");
					end
				end
				break;
			end
			if ((618 < 3820) and (v138 == 0)) then
				if ((4287 >= 124) and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) > 9)) then
					v102 = not v102;
				end
				if ((2569 <= 3918) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\115\176\182\143\88\167\150\130\80\165\167\148\73", "\231\61\213\194")]:IsReady() and v41 and (v14:DebuffRefreshable(v91.NetherTempestDebuff) or not v14:DebuffUp(v91.NetherTempestDebuff)) and (v13:ArcaneCharges() == 4) and (v13:ManaPercentage() < 30) and (v13:SpellHaste() < 0.667) and v13:BuffDown(v91.ArcaneSurgeBuff)) then
					if (v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest)) or (3154 <= 2030)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\7\168\41\123\12\191\2\103\12\160\45\118\26\185\125\103\6\184\62\123\54\189\53\114\26\168\125\33", "\19\105\205\93");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\136\26\221\128\49\172\39\204\131", "\95\201\104\190\225")]:IsReady() and v47 and ((v52 and v29) or not v52) and (v13:ArcaneCharges() < 2) and (v13:ManaPercentage() < 30) and (v13:SpellHaste() < 0.667) and v13:BuffDown(v91.ArcaneSurgeBuff)) or (3761 <= 682)) then
					if ((2128 > 836) and v19(v91.ArcaneOrb, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\174\217\194\207\161\206\254\193\189\201\129\218\160\222\194\198\144\219\201\207\188\206\129\154", "\174\207\171\161");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\221\236\8\224\253\217\238\251\2\245\213\222\227\250", "\183\141\158\109\147\152")]:IsCastable() and v42 and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) or (2361 <= 1063)) then
					if (v19(v91.PresenceofMind) or (1790 >= 3221)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\27\227\31\41\7\229\9\19\6\224\51\33\0\232\8\108\29\233\25\47\1\217\28\36\8\245\9\108\95", "\108\76\105\134");
					end
				end
				v138 = 1;
			end
			if ((4459 >= 3851) and (1 == v138)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\202\215\178\224\192\238\231\189\224\221\255", "\174\139\165\209\129")]:IsReady() and v31 and v13:BuffUp(v91.PresenceofMindBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or (2969 <= 1860)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (2123 == 39)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\162\161\225\192\200\6\79\122\175\178\241\213\134\23\127\109\160\187\221\209\206\2\99\125\227\235", "\24\195\211\130\161\166\99\16");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\103\17\234\45\93\19\100\2\251\62\82\17\67", "\118\38\99\137\76\51")]:IsReady() and v32 and (v13:BuffUp(v91.ArcaneHarmonyBuff) or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\220\52\6\19\7\37\223\41\8\16\8\50\249\43\0\28\29", "\64\157\70\101\114\105")]:IsAvailable() and (v14:HealthPercentage() < 35))) and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) <= v112)) or (2132 <= 201)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (4338 >= 4477)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\65\186\164\226\30\69\151\165\226\2\82\169\160\230\80\84\167\178\224\24\127\184\175\226\3\69\232\246\179", "\112\32\200\199\131");
					end
				end
				if ((v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == 0) and v13:BuffUp(v91.NetherPrecisionBuff) and (((v13:ManaPercentage() > 30) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\24\95\73\187\203\164\36\56\88\89\149\194\172\43", "\66\76\48\60\216\163\203")]:CooldownRemains() > 30)) or (v13:ManaPercentage() > 70)) and v13:BuffDown(v91.ArcaneArtilleryBuff)) or (1732 >= 3545)) then
					if ((1125 >= 64) and v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\187\148\122\242\81\203\27\183\143\106\224\86\194\33\169\198\112\253\75\203\54\168\147\105\231\31\218\43\175\133\113\204\79\198\37\169\131\57\162\13", "\68\218\230\25\147\63\174");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\140\56\80\77\184\168\7\90\95\165\164\38\86\95", "\214\205\74\51\44")]:IsCastable() and v36 and (v13:BuffStack(v91.ClearcastingBuff) > 1) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\217\67\236\246\98\232\73\207\253\121\251\107\231\241", "\23\154\44\130\156")]:IsAvailable() and v92[LUAOBFUSACTOR_DECRYPT_STR_0("\60\167\163\175\17\22\28", "\115\113\198\205\206\86")]:CooldownUp()) or (3215 > 4005)) then
					if ((2415 > 665) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\133\69\253\91\138\82\193\87\141\68\237\83\136\82\237\26\144\88\235\89\140\104\238\82\133\68\251\26\213\5", "\58\228\55\158");
					end
				end
				v138 = 2;
			end
		end
	end
	local function v122()
		local v139 = 0;
		while true do
			if ((v139 == 2) or (1089 > 2205)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\247\103\42\162\233\137\137\14\198\121\38\176\238\131\162", "\118\182\21\73\195\135\236\204")]:IsReady() and v33) or (2146 <= 628)) then
					if (v19(v91.ArcaneExplosion, not v14:IsInRange(30)) or (3415 >= 4449)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\9\46\25\65\10\8\194\13\36\10\76\11\30\244\7\50\90\65\11\8\194\28\51\15\67\12\50\237\0\61\9\69\68\85", "\157\104\92\122\32\100\109");
					end
				end
				break;
			end
			if ((v139 == 1) or (1765 > 4310)) then
				if ((906 > 200) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\156\245\39\167\201\89\159\230\54\180\198\91\184", "\60\221\135\68\198\167")]:IsReady() and v32 and ((((v98 <= 4) or (v99 <= 4)) and (v13:ArcaneCharges() == 3)) or (v13:ArcaneCharges() == v13:ArcaneChargesMax()))) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (3072 <= 2133)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\239\175\251\130\76\220\209\191\249\145\80\216\233\184\184\130\77\220\209\169\247\150\65\209\209\173\240\130\81\220\174\233", "\185\142\221\152\227\34");
					end
				end
				if ((904 <= 1400) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\121\215\84\251\77\54\216\74\199", "\151\56\165\55\154\35\83")]:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v13:ArcaneCharges() < 2)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (718 > 3863)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\161\81\6\239\174\70\58\225\178\65\69\239\175\70\58\250\175\86\6\230\159\83\13\239\179\70\69\184", "\142\192\35\101");
					end
				end
				v139 = 2;
			end
			if ((v139 == 0) or (2483 == 2223)) then
				if ((1405 >= 829) and (v14:DebuffRemains(v91.TouchoftheMagiDebuff) > 9)) then
					v102 = not v102;
				end
				if ((3341 < 3863) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\173\202\21\216\182\85\161\209\5\202\177\92\137\203", "\48\236\184\118\185\216")]:IsCastable() and v36 and v13:BuffUp(v91.ArcaneArtilleryBuff) and v13:BuffUp(v91.ClearcastingBuff)) then
					if ((3840 > 1000) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\228\175\84\49\193\49\218\176\94\35\220\61\233\184\68\112\206\59\224\130\67\63\218\55\237\130\71\56\206\39\224\253\5", "\84\133\221\55\80\175");
					end
				end
				v139 = 1;
			end
		end
	end
	local function v123()
		local v140 = 0;
		while true do
			if ((v140 == 0) or (2660 < 1908)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\130\180\204\203\51\34\162\185\161", "\203\195\198\175\170\93\71\237")]:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v13:ArcaneCharges() < 3) and (v13:BloodlustDown() or (v13:ManaPercentage() > 70) or (v107 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\26\68\43\214\89\30\250\58\67\59\248\80\22\245", "\156\78\43\94\181\49\113")]:CooldownRemains() > 30)))) or (2288 > 2511)) then
					if (v19(v91.ArcaneOrb, not v14:IsInRange(40)) or (3592 >= 4409)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\115\250\199\162\5\70\70\125\250\198\227\25\76\109\115\252\205\172\5\3\43", "\25\18\136\164\195\107\35");
					end
				end
				v102 = ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\201\63\170\78\124\185\242\173\250\42\172", "\216\136\77\201\47\18\220\161")]:CooldownRemains() > 30) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\25\227\62\217\0\211\132\57\228\46\247\9\219\139", "\226\77\140\75\186\104\188")]:CooldownRemains() > 10)) or false;
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\138\198\217\57\91\176\192\215\15\64\174\203\194", "\47\217\174\176\95")]:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and v107 and (not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\157\203\121\1\179\64\113\41\182", "\70\216\189\22\98\210\52\24")]:IsAvailable() or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\255\201\172\132\210\206\214\172\137", "\179\186\191\195\231")]:CooldownRemains() > 12)) and (not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\216\45\27\229\247\58\43\241\235\56\29", "\132\153\95\120")]:IsAvailable() or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\144\160\13\44\249\223\147\164\160\9\40", "\192\209\210\110\77\151\186")]:CooldownRemains() > 12)) and (not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\212\12\55\234\247\203\230\23\42\236\210\197\231\10", "\164\128\99\66\137\159")]:IsAvailable() or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\52\134\252\189\8\134\239\170\8\140\196\191\7\128", "\222\96\233\137")]:CooldownRemains() > 12)) and (v111 > 15)) or (4841 < 2991)) then
					if (v19(v91.ShiftingPower, not v14:IsInRange(40)) or (2863 <= 2540)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\170\187\174\25\156\250\254\190\140\183\16\159\246\226\249\161\168\11\137\231\249\182\189\231\75", "\144\217\211\199\127\232\147");
					end
				end
				v140 = 1;
			end
			if ((3057 <= 4822) and (v140 == 4)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\242\171\44\6\221\188\2\14\192\170\38\11\214\170", "\103\179\217\79")]:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and v13:BuffUp(v91.ConcentrationBuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax())) or (4688 < 1489)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (832 >= 4770)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\165\31\212\79\137\156\71\190\15\198\72\128\166\89\247\14\218\85\141\183\67\184\18\149\19\222", "\195\42\215\124\181\33\236");
					end
				end
				if ((1934 == 1934) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\44\75\52\63\43\253\47\85\54\45\49", "\152\109\57\87\94\69")]:IsReady() and v31 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffUp(v91.NetherPrecisionBuff)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (4524 <= 2618)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\197\9\162\176\215\107\170\245\214\25\183\254\192\91\188\248\195\3\172\176\146\6\252", "\200\153\183\106\195\222\178\52");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\19\241\139\60\71\95\16\226\154\47\72\93\55", "\58\82\131\232\93\41")]:IsReady() and v32 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < 60) and v102 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\183\88\197\22\85\48\133\67\216\16\112\62\132\94", "\95\227\55\176\117\61")]:CooldownRemains() > 10) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\61\104\44\72\170\12\119\44\69", "\203\120\30\67\43")]:CooldownRemains() > 40) and (v111 > 20)) or (4166 >= 4169)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (3725 < 86)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\55\78\238\215\244\26\79\238\203\227\36\74\234\153\227\42\89\238\205\248\42\67\175\139\167", "\185\145\69\45\143");
					end
				end
				v140 = 5;
			end
			if ((v140 == 2) or (4822 <= 153)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\226\41\238\19\246\51\225\55\236\1\236", "\86\163\91\141\114\152")]:IsReady() and v31 and v13:BuffUp(v91.PresenceofMindBuff) and (v14:HealthPercentage() < 35) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\114\25\119\114\52\86\41\123\126\56\82\25\112\126\63\93\31", "\90\51\107\20\19")]:IsAvailable() and (v13:ArcaneCharges() < 3)) or (1816 > 2293)) then
					if (v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast)) or (2823 >= 3213)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\140\226\134\238\51\136\207\135\227\60\158\228\197\253\50\153\241\145\230\50\131\176\212\189", "\93\237\144\229\143");
					end
				end
				if ((4702 > 2133) and v13:IsChanneling(v91.ArcaneMissiles) and (v13:GCDRemains() == 0) and v13:BuffUp(v91.NetherPrecisionBuff) and (((v13:ManaPercentage() > 30) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\33\249\229\26\3\73\19\226\248\28\38\71\18\255", "\38\117\150\144\121\107")]:CooldownRemains() > 30)) or (v13:ManaPercentage() > 70)) and v13:BuffDown(v91.ArcaneArtilleryBuff)) then
					if (v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (3335 <= 3201)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\44\169\237\59\35\190\209\55\36\168\253\51\33\190\253\122\36\181\250\63\63\169\251\42\57\251\252\53\57\186\250\51\34\181\174\104\125", "\90\77\219\142");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\199\22\34\56\66\2\87\239\23\50\48\64\2\105", "\26\134\100\65\89\44\103")]:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and (v13:BuffStack(v91.ClearcastingBuff) == v109)) or (3347 < 1460)) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (4691 < 4371)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\240\241\51\34\170\244\220\61\42\183\226\234\60\38\183\177\241\63\55\165\229\234\63\45\228\160\183", "\196\145\131\80\67");
					end
				end
				v140 = 3;
			end
			if ((612 == 612) and (v140 == 5)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\171\13\26\167\210\143\50\16\181\207\131\19\28\181", "\188\234\127\121\198")]:IsCastable() and v36 and v13:BuffUp(v91.ClearcastingBuff) and v13:BuffDown(v91.NetherPrecisionBuff) and (not v107 or not v105)) or (4840 <= 4170)) then
					if ((1346 == 1346) and v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\32\16\130\54\55\44\142\49\33\0\138\52\55\0\195\42\61\7\130\44\59\28\141\120\97\67", "\227\88\82\115");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\98\13\185\166\12\118\97\19\187\180\22", "\19\35\127\218\199\98")]:IsReady() and v31) or (3020 <= 2751)) then
					if ((3824 > 3667) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\29\233\9\227\18\254\53\224\16\250\25\246\92\233\5\246\29\239\3\237\18\187\89\176", "\130\124\155\106");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\244\217\245\174\173\243\94\190\199\217\247\168\166", "\223\181\171\150\207\195\150\28")]:IsReady() and v32) or (3048 > 3830)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (2117 < 1050)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\77\40\224\175\7\73\5\225\175\27\94\59\228\171\73\94\53\247\175\29\69\53\237\238\90\24", "\105\44\90\131\206");
					end
				end
				break;
			end
			if ((v140 == 1) or (1099 == 1810)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\203\39\55\46\193\76\12\67\200\32\41\45\199", "\36\152\79\94\72\181\37\98")]:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and not v107 and v13:BuffDown(v91.ArcaneSurgeBuff) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\246\202\68\62\217\221\116\42\197\223\66", "\95\183\184\39")]:CooldownRemains() > 45) and (v111 > 15)) or (4892 == 3708)) then
					if ((2393 > 617) and v19(v91.ShiftingPower, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\55\238\32\64\137\12\178\0\247\41\67\133\16\245\45\232\50\85\148\11\186\49\167\112", "\98\213\95\135\70\52\224");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\206\177\204\100\81\240\160\204\120\82\211\170\199\115", "\52\158\195\169\23")]:IsCastable() and v42 and (v13:ArcaneCharges() < 3) and (v14:HealthPercentage() < 35) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\91\174\49\117\136\48\89\132\119\190\51\102\130\56\126\133\110", "\235\26\220\82\20\230\85\27")]:IsAvailable()) or (1352 > 2414)) then
					if (v19(v91.PresenceofMind) or (1584 == 2283)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\152\179\236\209\113\134\162\236\253\123\142\158\228\203\122\140\225\251\205\96\137\181\224\205\122\200\249", "\20\232\193\137\162");
					end
				end
				if ((2073 < 2845) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\3\205\198\167\233\137\53\125\35\204\209", "\17\66\191\165\198\135\236\119")]:IsReady() and v31 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\59\166\163\22\222\230\227\220\14\163\183", "\177\111\207\206\115\159\136\140")]:IsAvailable() and v13:BuffUp(v91.ArcaneSurgeBuff) and (v13:BuffRemains(v91.ArcaneSurgeBuff) <= 6)) then
					if ((2894 <= 3293) and v19(v91.ArcaneBlast, not v14:IsSpellInRange(v91.ArcaneBlast))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\4\155\19\21\218\74\96\7\133\17\7\192\15\77\10\157\17\0\221\64\81\69\216\64", "\63\101\233\112\116\180\47");
					end
				end
				v140 = 2;
			end
			if ((1275 > 942) and (v140 == 3)) then
				if ((1190 < 4108) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\48\181\18\0\29\250\42\181\11\24\29\251\10", "\136\126\208\102\104\120")]:IsReady() and v41 and v14:DebuffRefreshable(v91.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:BuffUp(v91.TemporalWarpBuff) or (v13:ManaPercentage() < 10) or not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\75\130\199\69\187\91\51\86\72\133\217\70\189", "\49\24\234\174\35\207\50\93")]:IsAvailable()) and v13:BuffDown(v91.ArcaneSurgeBuff) and (v111 >= 12)) then
					if ((2404 <= 2475) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\2\247\233\128\116\30\205\233\141\124\28\247\238\156\49\30\253\233\137\101\5\253\243\200\32\90", "\17\108\146\157\232");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\106\209\23\236\33\173\105\194\6\255\46\175\78", "\200\43\163\116\141\79")]:IsReady() and v32 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < 50) and not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\154\32\50\128\177\224\234\176\56", "\131\223\86\93\227\208\148")]:IsAvailable() and (v111 > 20)) or (2100 <= 635)) then
					if ((2967 > 196) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\226\87\181\183\19\176\220\71\183\164\15\180\228\64\246\164\18\161\226\81\191\185\19\245\178\29", "\213\131\37\214\214\125");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\7\57\38\190\239\35\9\36\173\243\39\44\32", "\129\70\75\69\223")]:IsReady() and v32 and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and (v13:ManaPercentage() < 70) and v102 and v13:BloodlustUp() and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\114\196\230\234\116\224\64\223\251\236\81\238\65\194", "\143\38\171\147\137\28")]:CooldownRemains() > 5) and (v111 > 20)) or (4689 < 3047)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (422 <= 411)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\209\144\186\242\13\230\235\210\131\171\225\2\228\209\144\144\182\231\2\247\221\223\140\249\161\83", "\180\176\226\217\147\99\131");
					end
				end
				v140 = 4;
			end
		end
	end
	local function v124()
		local v141 = 0;
		while true do
			if ((v141 == 0) or (2476 > 2899)) then
				if ((1312 == 1312) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\204\232\187\191\28\55\241\231\130\182\31\59\237", "\94\159\128\210\217\104")]:IsReady() and v46 and ((v28 and v51) or not v51) and (v76 < v111) and (not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\117\239\9\188\94\107\240\117\94", "\26\48\153\102\223\63\31\153")]:IsAvailable() or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\39\86\226\240\3\84\228\252\12", "\147\98\32\141")]:CooldownRemains() > 12)) and (not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\57\81\224\203\8\83\120\13\81\228\207", "\43\120\35\131\170\102\54")]:IsAvailable() or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\117\20\132\183\171\181\183\65\20\128\179", "\228\52\102\231\214\197\208")]:CooldownRemains() > 12)) and (not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\42\239\96\201\226\132\31\194\22\229\88\203\237\130", "\182\126\128\21\170\138\235\121")]:IsAvailable() or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\191\213\32\229\142\28\54\18\131\223\24\231\129\26", "\102\235\186\85\134\230\115\80")]:CooldownRemains() > 12)) and v13:BuffDown(v91.ArcaneSurgeBuff) and ((not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\116\4\63\77\117\209\38\120\30\60", "\66\55\108\94\63\18\180")]:IsAvailable() and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\53\159\134\54\41\92\59\159\135", "\57\116\237\229\87\71")]:CooldownRemains() > 12)) or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\139\163\238\230\121\235\104\184\179", "\39\202\209\141\135\23\142")]:Charges() == 0) or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\222\33\10\11\60\253\208\33\11", "\152\159\83\105\106\82")]:CooldownRemains() > 12))) then
					if (v19(v91.ShiftingPower, not v14:IsInRange(40), true) or (3503 == 3404)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\146\206\88\244\221\85\143\193\110\226\198\75\132\212\17\243\198\89\190\212\94\230\200\72\136\201\95\178\155", "\60\225\166\49\146\169");
					end
				end
				if ((2284 < 4260) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\1\27\59\34\4\21\27\27\34\58\4\20\59", "\103\79\126\79\74\97")]:IsReady() and v41 and v14:DebuffRefreshable(v91.NetherTempestDebuff) and (v13:ArcaneCharges() == v13:ArcaneChargesMax()) and v13:BuffDown(v91.ArcaneSurgeBuff) and ((v98 > 6) or (v99 > 6) or not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\149\109\209\81\95\8\168\126\212\118", "\122\218\31\179\19\62")]:IsAvailable())) then
					if ((638 <= 1080) and v19(v91.NetherTempest, not v14:IsSpellInRange(v91.NetherTempest))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\189\211\217\201\204\179\122\167\211\192\209\204\178\81\243\215\194\196\246\179\74\167\215\217\200\198\175\5\231", "\37\211\182\173\161\169\193");
					end
				end
				v141 = 1;
			end
			if ((v141 == 2) or (2440 == 4141)) then
				if ((4376 > 2959) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\15\28\248\247\32\11\212\228\44", "\150\78\110\155")]:IsReady() and v47 and ((v52 and v29) or not v52) and (v76 < v111) and (v13:ArcaneCharges() == 0) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\177\202\50\226\172\17\185\84\141\192\10\224\163\23", "\32\229\165\71\129\196\126\223")]:CooldownRemains() > 18)) then
					if ((1668 == 1668) and v19(v91.ArcaneOrb, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\194\155\199\128\143\208\252\134\214\131\193\212\204\140\251\147\142\193\194\157\205\142\143\149\146\217", "\181\163\233\164\225\225");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\113\153\61\118\94\142\28\118\66\153\63\112\85", "\23\48\235\94")]:IsReady() and v32 and ((v13:ArcaneCharges() == v13:ArcaneChargesMax()) or (v13:ManaPercentage() < 10))) or (3358 >= 4904)) then
					if ((2885 > 2876) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\125\200\219\92\89\54\237\126\219\202\79\86\52\215\60\219\215\88\104\33\221\104\219\204\84\88\61\146\45\136", "\178\28\186\184\61\55\83");
					end
				end
				v141 = 3;
			end
			if ((3 == v141) or (2525 == 2957)) then
				if ((3983 > 649) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\229\223\68\61\252\11\208\220\221\75\51\225\7\250\202", "\149\164\173\39\92\146\110")]:IsReady() and v33) then
					if ((1916 == 1916) and v19(v91.ArcaneExplosion, not v14:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\242\53\19\30\20\30\204\34\8\15\22\20\224\46\31\17\90\26\252\34\47\13\21\15\242\51\25\16\20\91\162\115", "\123\147\71\112\127\122");
					end
				end
				break;
			end
			if ((4247 >= 3723) and (v141 == 1)) then
				if ((1446 < 3001) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\214\40\78\216\38\126\148\254\41\94\208\36\126\170", "\217\151\90\45\185\72\27")]:IsCastable() and v36 and v13:BuffUp(v91.ArcaneArtilleryBuff) and v13:BuffUp(v91.ClearcastingBuff) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\247\115\242\17\94\204\122\243\26\83\238\125\224\27", "\54\163\28\135\114")]:CooldownRemains() > (v13:BuffRemains(v91.ArcaneArtilleryBuff) + 5))) then
					if (v19(v91.ArcaneMissiles, not v14:IsSpellInRange(v91.ArcaneMissiles)) or (3380 < 199)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\41\201\94\131\64\122\23\214\84\145\93\118\36\222\78\194\79\112\45\228\79\141\90\126\60\210\82\140\14\41", "\31\72\187\61\226\46");
					end
				end
				if ((1494 <= 4564) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\226\20\64\211\73\123\6\194\20\81\211\64\123", "\68\163\102\35\178\39\30")]:IsReady() and v32 and ((v98 <= 4) or (v99 <= 4) or v13:BuffUp(v91.ClearcastingBuff)) and (v13:ArcaneCharges() == 3)) then
					if ((4256 > 469) and v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\191\98\217\198\13\176\188\19\191\98\200\198\4\176\195\16\177\117\229\213\12\161\130\5\183\127\212\135\91", "\113\222\16\186\167\99\213\227");
					end
				end
				v141 = 2;
			end
		end
	end
	local function v125()
		local v142 = 0;
		local v143;
		while true do
			if ((v142 == 1) or (3727 < 87)) then
				if ((609 <= 3889) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\245\169\233\205\108\165\211\139\230\201\120\144\211\171", "\215\182\198\135\167\25")]:IsCastable() and v37 and v14:DebuffDown(v91.TouchoftheMagiDebuff) and v13:BuffDown(v91.ArcaneSurgeBuff) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\172\91\233\73\131\76\217\93\159\78\239", "\40\237\41\138")]:CooldownRemains() < 30) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\230\102\249\249\68\194\71\239\234\77\194", "\42\167\20\154\152")]:CooldownRemains() < v111) and not v92[LUAOBFUSACTOR_DECRYPT_STR_0("\103\255\172\67\86\36\71", "\65\42\158\194\34\17")]:Exists()) then
					if (v19(v91.ConjureManaGem) or (2628 < 2175)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\25\40\92\6\56\255\30\209\23\38\92\13\18\234\30\227\90\42\83\5\35\173\72\182", "\142\122\71\50\108\77\141\123");
					end
				end
				if ((2999 == 2999) and v92[LUAOBFUSACTOR_DECRYPT_STR_0("\56\163\241\25\28\16\175", "\91\117\194\159\120")]:IsReady() and v40 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\57\28\45\27\52\245\45\20\26\14\23\34\244\54", "\68\122\125\94\120\85\145")]:IsAvailable() and (v13:BuffStack(v91.ClearcastingBuff) < 2) and v13:BuffUp(v91.ArcaneSurgeBuff)) then
					if (v19(v93.ManaGem) or (2968 == 71)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\26\29\193\95\247\222\191\26\92\194\95\193\215\250\67\76", "\218\119\124\175\62\168\185");
					end
				end
				if ((3429 < 3464) and v92[LUAOBFUSACTOR_DECRYPT_STR_0("\136\241\70\197\130\245\69", "\164\197\144\40")]:IsReady() and v40 and not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\160\241\185\136\220\178\138\254\173\187\210\161\134\226", "\214\227\144\202\235\189")]:IsAvailable() and v13:PrevGCDP(1, v91.ArcaneSurge) and (not v106 or (v106 and v13:PrevGCDP(2, v91.ArcaneSurge)))) then
					if (v19(v93.ManaGem) or (2337 <= 423)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\224\164\137\122\47\180\86\49\173\168\134\114\30\243\7\110", "\92\141\197\231\27\112\211\51");
					end
				end
				if ((not v107 and ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\199\237\137\162\223\227\204\159\177\214\227", "\177\134\159\234\195")]:CooldownRemains() <= (v112 * (1 + v22(v91[LUAOBFUSACTOR_DECRYPT_STR_0("\147\238\43\168\204\175\223\58\173\217\184\248\43", "\169\221\139\95\192")]:IsAvailable() and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\255\153\124\62\44\35\251\136\119\48", "\70\190\235\31\95\66")]:IsAvailable())))) or (v13:BuffRemains(v91.ArcaneSurgeBuff) > (3 * v22(v13:HasTier(30, 2) and not v13:HasTier(30, 4)))) or v13:BuffUp(v91.ArcaneOverloadBuff)) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\159\244\21\229\228\174\235\21\232", "\133\218\130\122\134")]:CooldownRemains() > 45) and ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\8\240\246\199\212\172\62\40\247\230\233\221\164\49", "\88\92\159\131\164\188\195")]:CooldownRemains() < (v112 * 4)) or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\180\33\170\72\223\228\219\148\38\186\102\214\236\212", "\189\224\78\223\43\183\139")]:CooldownRemains() > 20)) and ((v98 < v101) or (v99 < v101))) or (4775 == 715)) then
					local v206 = 0;
					local v207;
					while true do
						if ((3636 >= 1819) and (v206 == 0)) then
							v207 = v118();
							if (v207 or (1101 >= 2393)) then
								return v207;
							end
							break;
						end
					end
				end
				v142 = 2;
			end
			if ((1347 == 1347) and (v142 == 2)) then
				if ((3743 > 2332) and not v107 and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\15\238\137\23\207\43\207\159\4\198\43", "\161\78\156\234\118")]:CooldownRemains() > 30) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\149\182\205\213\166\185\221\239\183\182\219\215", "\188\199\215\169")]:CooldownUp() or v14:DebuffUp(v91.RadiantSparkDebuff) or v14:DebuffUp(v91.RadiantSparkVulnerability)) and ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\200\6\74\120\224\243\15\75\115\237\209\8\88\114", "\136\156\105\63\27")]:CooldownRemains() <= (v112 * 3)) or v14:DebuffUp(v91.TouchoftheMagiDebuff)) and ((v98 < v101) or (v99 < v101))) then
					local v208 = 0;
					local v209;
					while true do
						if ((3220 <= 4732) and (0 == v208)) then
							v209 = v118();
							if (v209 or (4482 >= 4962)) then
								return v209;
							end
							break;
						end
					end
				end
				if ((3467 >= 2430) and v28 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\41\141\125\61\26\130\109\7\11\141\107\63", "\84\123\236\25")]:IsAvailable() and v103) then
					local v210 = 0;
					local v211;
					while true do
						if ((526 > 511) and (v210 == 0)) then
							v211 = v120();
							if (v211 or (2130 == 1868)) then
								return v211;
							end
							break;
						end
					end
				end
				if ((v28 and v107 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\194\138\174\30\173\187\228\184\186\22\190\190", "\213\144\235\202\119\204")]:IsAvailable() and v104) or (2083 > 3867)) then
					local v212 = 0;
					local v213;
					while true do
						if ((v212 == 0) or (3090 >= 3604)) then
							v213 = v119();
							if ((3370 < 4153) and v213) then
								return v213;
							end
							break;
						end
					end
				end
				if ((4132 == 4132) and v28 and v14:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 >= v101) or (v99 >= v101))) then
					local v214 = 0;
					local v215;
					while true do
						if ((v214 == 0) or (91 >= 2748)) then
							v215 = v122();
							if ((1807 >= 1725) and v215) then
								return v215;
							end
							break;
						end
					end
				end
				v142 = 3;
			end
			if ((v142 == 3) or (633 >= 2602)) then
				if ((v28 and v107 and v14:DebuffUp(v91.TouchoftheMagiDebuff) and ((v98 < v101) or (v99 < v101))) or (377 >= 4657)) then
					local v216 = 0;
					local v217;
					while true do
						if ((4868 > 1056) and (v216 == 0)) then
							v217 = v121();
							if (v217 or (1372 < 761)) then
								return v217;
							end
							break;
						end
					end
				end
				if ((v98 >= v101) or (v99 >= v101) or (3776 < 3310)) then
					local v218 = 0;
					local v219;
					while true do
						if ((3991 == 3991) and (0 == v218)) then
							v219 = v124();
							if ((3538 >= 3305) and v219) then
								return v219;
							end
							break;
						end
					end
				end
				v143 = v123();
				if (v143 or (1165 < 1091)) then
					return v143;
				end
				break;
			end
			if ((3782 == 3782) and (v142 == 0)) then
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\248\194\151\114\78\195\203\150\121\67\225\204\133\120", "\38\172\173\226\17")]:IsReady() and v49 and ((v54 and v29) or not v54) and (v76 < v111) and (v13:PrevGCDP(1, v91.ArcaneBarrage))) or (2838 < 2736)) then
					if ((3651 == 3651) and v19(v91.TouchoftheMagi, not v14:IsSpellInRange(v91.TouchoftheMagi))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\89\30\57\236\69\46\35\233\114\5\36\234\114\28\45\232\68\81\33\238\68\31\108\188\29", "\143\45\113\76");
					end
				end
				if ((1382 > 677) and v13:IsChanneling(v91.Evocation) and (((v13:ManaPercentage() >= 95) and not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\139\177\12\52\183\182\47\40\183\170\17", "\92\216\216\124")]:IsAvailable()) or ((v13:ManaPercentage() > (v111 * 4)) and not ((v111 > 10) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\122\32\175\65\243\94\1\185\82\250\94", "\157\59\82\204\32")]:CooldownRemains() < 1))))) then
					if ((903 < 2719) and v19(v93.StopCasting, not v14:IsSpellInRange(v91.ArcaneMissiles))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\59\63\237\249\236\230\236\176\59\42\234\245\231\170\214\167\55\61\226\238\224\229\221\241\53\63\234\244\169\185\129", "\209\88\94\131\154\137\138\179");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\9\179\199\125\16\38\19\35\58\179\197\123\27", "\66\72\193\164\28\126\67\81")]:IsReady() and v32 and (v111 < 2)) or (2145 > 4711)) then
					if (v19(v91.ArcaneBarrage, not v14:IsSpellInRange(v91.ArcaneBarrage)) or (4848 <= 4317)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\230\62\171\89\40\115\216\46\169\74\52\119\224\41\232\85\39\127\233\108\251\12", "\22\135\76\200\56\70");
					end
				end
				if ((641 < 4795) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\168\38\247\39\92\245\132\63\246", "\129\237\80\152\68\61")]:IsCastable() and v39 and not v105 and v13:BuffDown(v91.ArcaneSurgeBuff) and v14:DebuffDown(v91.TouchoftheMagiDebuff) and (((v13:ManaPercentage() < 10) and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\101\167\17\240\20\24\94\69\160\1\222\29\16\81", "\56\49\200\100\147\124\119")]:CooldownRemains() < 20)) or (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\248\49\170\243\196\49\185\228\196\59\146\241\203\55", "\144\172\94\223")]:CooldownRemains() < 15)) and (v13:ManaPercentage() < (v111 * 4))) then
					if (v19(v91.Evocation) or (3538 <= 1184)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\33\25\173\68\37\27\171\72\42\79\175\70\45\1\226\20\114", "\39\68\111\194");
					end
				end
				v142 = 1;
			end
		end
	end
	local function v126()
		local v144 = 0;
		while true do
			if ((v144 == 0) or (3810 > 4775)) then
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\29\202\62\33\45\74\48", "\45\67\120\190\74\72\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\49\232\132\235\139\239\231\37\0\225\164\234\156", "\137\64\66\141\197\153\232\142")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\213\54\178\129\13\215\49", "\232\99\176\66\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\249\50\45\39\105\142\248\34\233\3\41\20\105\140\254\41", "\76\140\65\72\102\27\237\153")];
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\223\2\198\222\15\185\89", "\222\42\186\118\178\183\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\72\255\65\171\79\239\69\132\88\201\92\154\81\227\87\131\82\226", "\234\61\140\36")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\216\174\102\6\47\218\169", "\111\65\189\218\18")][LUAOBFUSACTOR_DECRYPT_STR_0("\86\88\30\20\25\95\174\77\78\61\52\6\85\163\74\74\9", "\207\35\43\123\85\107\60")];
				v144 = 1;
			end
			if ((v144 == 5) or (3401 <= 2215)) then
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\232\82\14\242\235\234\85", "\155\133\141\38\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\36\56\175\64\65\122\150\48\56\171\68\120\118\177\45\9\136", "\197\69\74\204\33\47\31")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\195\74\78\147\249\65\93\148", "\231\144\47\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\161\208\211\115\12\52\193\62\130\215\205\112\10\10\198\45\186\251\254", "\89\210\184\186\21\120\93\175")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\86\104\193\112\52\182\64", "\90\209\51\28\181\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\209\105\84\239\177\213\84\69\236\136\217\111\95\195\182\222\114\116\202", "\223\176\27\55\142")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\23\190\218\161\45\181\201\166", "\213\68\219\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\225\39\238\43\203\43\76\27\225\49\236\29\204\43\119\38\233\45\238\9\225", "\31\107\128\67\135\74\165\95")];
				v144 = 6;
			end
			if ((2557 == 2557) and (v144 == 8)) then
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\219\57\17\254\197\217\62", "\151\171\190\77\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\35\236\172\234\73\2\200\42\208\153", "\107\165\79\152\201\152\29")] or 0;
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\75\252\223\93\113\80\93", "\31\55\46\136\171\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\193\58\213\231\220\41\200\253\210\10\221\230\195\33\217\230\249\24", "\148\177\72\188")] or 0;
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\149\179\67\199\175\184\80\192", "\179\198\214\55")][LUAOBFUSACTOR_DECRYPT_STR_0("\247\30\119\119\81\214\226\37\124\96\76\192\249\14\123\122\76\199\233\36\66", "\179\144\108\18\22\37")] or 0;
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\245\166\15\157\198\200\164\8", "\175\166\195\123\233")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\193\88\107\252\224\193\86\97\192", "\144\143\162\61\41")] or 0;
				v144 = 9;
			end
			if ((9 == v144) or (2318 <= 1935)) then
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\211\214\9\68\123\137\52\243", "\83\128\179\125\48\18\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\84\180\246\254\72\18\89\159\195", "\126\61\215\147\189\39")] or 0;
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\250\9\81\113\241\26\86", "\37\24\159\125")][LUAOBFUSACTOR_DECRYPT_STR_0("\215\175\103\80\213\180\92\79\219\161\112\106\234", "\34\186\198\21")] or 0;
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\13\209\73\203\246\15\214", "\162\152\104\165\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\192\46\161\110\82\228\223\61\187\120\98\205\253", "\133\173\79\210\29\16")] or 0;
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\121\249\63\132\114\234\56", "\75\237\28\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\201\76\201\130\63\30\235\237\239\75\201\176\35\47\230\243\219\90\216", "\129\188\63\172\209\79\123\135")];
				v144 = 10;
			end
			if ((3449 == 3449) and (v144 == 2)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\92\81\110\236\117\207\74", "\27\168\57\37\26\133")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\185\121\133\214\35\171\91\173\218", "\183\77\202\28\200")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\36\54\157\28\30\61\142\27", "\104\119\83\233")][LUAOBFUSACTOR_DECRYPT_STR_0("\224\235\34\12\70\225\240\34\48\119\240\245\55\39\80\225", "\35\149\152\71\66")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\237\86\164\51\23\239\81", "\90\121\136\34\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\210\29\80\46\213\11\70\27\201\13\80\49\193\35\92\16\195", "\126\167\110\53")];
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\14\21\58\236\213\49\58\3", "\95\93\112\78\152\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\194\244\139\22\225\178\226\238\216", "\178\161\149\229\117\132\222")];
				v144 = 3;
			end
			if ((v144 == 4) or (1349 >= 1360)) then
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\160\105\141\187\41\167", "\228\213\78\212\29")][LUAOBFUSACTOR_DECRYPT_STR_0("\146\95\179\54\227\142\74\162\12\229\128\124\185\18\238\149", "\139\231\44\214\101")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\234\234\18\74\25\191\54\5", "\118\185\143\102\62\112\209\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\73\99\44\199\183\22\29\54\89\95\59\228", "\88\60\16\73\134\197\117\124")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\239\236\220\72\94\237\235", "\33\48\138\152\168")][LUAOBFUSACTOR_DECRYPT_STR_0("\103\5\53\99\192\51\123\23\62\69\242\39\115\4\59", "\87\18\118\80\49\161")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\27\206\180\185\66\25\201", "\208\44\126\186\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\9\161\242\27\233\202\70\216\28\144\206\17\209\200\73\254", "\46\151\122\196\166\116\156\169")];
				v144 = 5;
			end
			if ((3810 >= 779) and (v144 == 10)) then
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\225\242\217\73\234\225\222", "\173\32\132\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\91\8\13\219\167\60\200\121\26\26\255\153\56\217\70\47\9\227\171\63\217", "\173\46\123\104\143\206\81")];
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\135\24\54\158\76\141\6\167", "\97\212\125\66\234\37\227")][LUAOBFUSACTOR_DECRYPT_STR_0("\135\234\164\39\17\152\202\187\52\25\143\193\179\51\17\152\230\134\32\18\134", "\126\234\131\214\85")];
				v90 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\208\93\78\70\138\210\90", "\47\228\181\41\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\179\239\220\9\6\61\16\176\249\250\46\17\35\26\145\245\205\51\34\54\25\170\245\218\47\6\52", "\127\198\156\185\91\99\80")];
				break;
			end
			if ((6 == v144) or (2423 == 1135)) then
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\235\237\232\89\72\191\223\251", "\209\184\136\156\45\33")][LUAOBFUSACTOR_DECRYPT_STR_0("\19\199\96\11\176\40\206\65\0\189\42\201\114\1\143\14\220\125\37\177\9\193\86\44", "\216\103\168\21\104")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\168\87\176\113\163\68\183", "\196\24\205\35")][LUAOBFUSACTOR_DECRYPT_STR_0("\59\152\230\39\34\159\230\20\26\130\238\3", "\102\78\235\131")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\201\43\32\80\78\55\176\39", "\84\154\78\84\36\39\89\215")][LUAOBFUSACTOR_DECRYPT_STR_0("\232\242\83\104\23\244\242\91\89\17\244\226\116\89\23\239\232\83\74", "\101\157\129\54\56")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\46\172\158\191\42\119\26\186", "\25\125\201\234\203\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\108\231\29\36\6\34\18\109\241\10\42\26\49\26\106\253\26\10\24\46\7\96", "\115\25\148\120\99\116\71")];
				v144 = 7;
			end
			if ((v144 == 1) or (4712 <= 2944)) then
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\175\180\254\112\126\173\179", "\25\16\202\192\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\232\216\168\195\187\247\252\197\168\203\167\224\248\199\161\231\170\224", "\148\157\171\205\130\201")];
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\209\96\61\216\248\36\199", "\150\67\180\20\73\177")][LUAOBFUSACTOR_DECRYPT_STR_0("\152\11\31\108\159\27\27\67\136\53\19\94\158\17\22\72\158", "\45\237\120\122")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\237\182\56\222\230\165\63", "\76\183\136\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\111\245\224\27\95\65\30\111\244\224\21\81\65\21\93\227\232", "\116\26\134\133\88\48\47")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\196\180\240\180\124\25\210", "\18\126\161\192\132\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\74\59\171\33\64\80\43\175\16\95\80\38", "\54\63\72\206\100")];
				v144 = 2;
			end
			if ((v144 == 7) or (4586 <= 2063)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\56\173\48\72\2\58\170", "\33\108\93\217\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\206\88\164\132\216\78\131\161\212\72\170", "\205\187\43\193")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\205\119\17\203\247\124\2\204", "\191\158\18\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\208\130\158\172\192\224\136\187\171", "\207\165\163\231\215")];
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\245\252\237\66\45\126\193\234", "\16\166\153\153\54\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\199\160\197\107\53\50\234\240\178\210\84\61\36\235", "\153\178\211\160\38\84\65")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\177\14\78\63\139\5\93\56", "\75\226\107\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\205\20\87\24\208\223\87\204\56\119\16\197\200", "\173\56\190\113\26\113\162")];
				v144 = 8;
			end
			if ((v144 == 3) or (3589 <= 3247)) then
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\187\222\201\184\168\24\161\48", "\67\232\187\189\204\193\118\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\61\176\3\52\23\225\159\43\167\51\43\7\227\135", "\143\235\78\213\64\91\98")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\77\144\253\121\184\138\91", "\214\237\40\228\137\16")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\240\234\251\15\167\150\247\216\216\21\163", "\198\229\131\143\185\99")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\98\137\188\103\88\130\175\96", "\19\49\236\200")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\36\243\147\246\187\249\56\248\164\198\168\251\54\226\191", "\218\158\87\150\215\132")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\200\27\205\246\63\44\202\232", "\173\155\126\185\130\86\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\240\181\191\230\154\239\228\168\191\244\157\254\226\163", "\140\133\198\218\167\232")];
				v144 = 4;
			end
		end
	end
	local function v127()
		local v145 = 0;
		while true do
			if ((v145 == 3) or (1763 < 1755)) then
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\152\38\190\179\132\169\255\184", "\152\203\67\202\199\237\199")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\70\161\3\11\125\106\242\245\77\165\39\47", "\134\154\35\192\111\127\21\25")] or 0;
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\139\35\29\30\41\220\191\53", "\178\216\70\105\106\64")][LUAOBFUSACTOR_DECRYPT_STR_0("\55\46\123\250\192\219\211\176\48\63\115\249\199\253\228", "\224\95\75\26\150\169\181\180")] or 0;
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\56\223\204\60\77\162\113\24", "\22\107\186\184\72\36\204")][LUAOBFUSACTOR_DECRYPT_STR_0("\207\184\37\66\7\233\186\20\65\26\238\178\42\96\15\234\184", "\110\135\221\68\46")] or "";
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\208\51\24\255\199\189\60\240", "\91\131\86\108\139\174\211")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\42\182\19\81\254\10\190\17\81\242\40\172\18\89", "\61\155\75\216\119")];
				v145 = 4;
			end
			if ((v145 == 0) or (3427 < 2151)) then
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\198\31\216\228\174\5\62\205", "\190\149\122\172\144\199\107\89")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\12\246\246\234\0\0\252\255\247\60\22\210\246\251\49\14", "\158\82\101\145\158")] or 0;
				v73 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\251\22\2\77\126\249\17", "\36\16\158\98\118")][LUAOBFUSACTOR_DECRYPT_STR_0("\233\24\215\254\74\250\50\245\212\33\202\239\80\219\51\240\206", "\133\160\118\163\155\56\136\71")];
				v74 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\167\101\230\191\17\178\229", "\213\150\194\17\146\214\127")][LUAOBFUSACTOR_DECRYPT_STR_0("\50\167\176\209\84\182\183\38\15\134\170\216\95\147\170\63\15\172\168\221\85\176", "\86\123\201\196\180\38\196\194")];
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\196\237\205\187\254\230\222\188", "\207\151\136\185")][LUAOBFUSACTOR_DECRYPT_STR_0("\129\141\60\135\102\106\100\184\151\28\138\102\125\98\160\140\36\134", "\17\200\227\72\226\20\24")];
				v145 = 1;
			end
			if ((2 == v145) or (3829 == 3060)) then
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\119\242\246\218\11\227\67\228", "\141\36\151\130\174\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\104\203\3\143\127\214\30\179\115\214\5\167\94", "\109\228\26\162")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\109\224\233\108\233\232\89\246", "\134\62\133\157\24\128")][LUAOBFUSACTOR_DECRYPT_STR_0("\21\164\25\208\46\189\197\48\172\14\209\12\149", "\182\103\197\122\185\79\209")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\192\130\245\99\9\70\244\148", "\40\147\231\129\23\96")][LUAOBFUSACTOR_DECRYPT_STR_0("\96\235\137\109\190\173\208\97\240\159\81\180\162\217", "\188\21\152\236\37\219\204")];
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\115\236\35\24\73\231\48\31", "\108\32\137\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\191\251\5\142\42\248\71\80\164\239\48\169\59\240\68\87", "\57\202\136\96\198\79\153\43")];
				v145 = 3;
			end
			if ((v145 == 1) or (250 == 371)) then
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\131\68\15\195\192\255\232\236", "\159\208\33\123\183\169\145\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\83\43\38\247\86\28\51\240\79\62\48\225", "\86\146\58\88")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\218\254\212\167\231\49\233", "\154\56\191\138\160\206\137\86")][LUAOBFUSACTOR_DECRYPT_STR_0("\162\80\230\151\121\54\163\217\128\95\230", "\172\230\57\149\231\28\90\225")];
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\49\175\146\198\33\213\5\185", "\187\98\202\230\178\72")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\242\161\4\88\40\239\175\53\94\50", "\42\65\129\196\80")];
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\49\79\73\206\30\9\5\253", "\142\98\42\61\186\119\103\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\172\7\58\57\188\11\9\52\172", "\104\88\223\98")];
				v145 = 2;
			end
			if ((4374 > 1370) and (v145 == 4)) then
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\174\166\40\81\7\218\23", "\189\100\203\210\92\56\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\80\243\44\35\84\212\38\44\94\239\56\32\67\248\41\35", "\72\79\49\157")];
				break;
			end
		end
	end
	local function v128()
		local v146 = 0;
		while true do
			if ((3519 > 3133) and (v146 == 0)) then
				v126();
				v127();
				v26 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\188\191\54\187\132\181\34", "\220\232\208\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\177\230", "\193\149\222\133\80\76\58")];
				v27 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\242\82\72\213\202\88\92", "\178\166\61\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\250\69\237", "\94\155\42\136\26\170")];
				v146 = 1;
			end
			if ((4996 > 4721) and (v146 == 3)) then
				v112 = v13:GCD();
				if ((4023 >= 2719) and v71) then
					if ((243 <= 4516) and v90) then
						local v225 = 0;
						while true do
							if ((3743 >= 1870) and (v225 == 0)) then
								v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 30);
								if ((298 <= 3318) and v25) then
									return v25;
								end
								break;
							end
						end
					end
				end
				if ((1156 < 3232) and not v13:AffectingCombat()) then
					local v220 = 0;
					while true do
						if ((777 < 2530) and (v220 == 1)) then
							if ((3745 >= 2715) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\137\227\5\129\191\254\14\166\171\226\10\172\175\225", "\235\202\140\107")]:IsCastable() and v37) then
								if (v19(v91.ConjureManaGem) or (4942 == 1715)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\15\123\58\162\252\53\242\250\1\117\58\169\214\32\242\200\76\100\38\173\234\40\250\199\13\96\116\252", "\165\108\20\84\200\137\71\151");
								end
							end
							break;
						end
						if ((v220 == 0) or (2975 > 4424)) then
							if ((2898 >= 1084) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\164\53\218\54\62\134\98\173\145\34\213\59\53\128\95", "\195\229\71\185\87\80\227\43")]:IsCastable() and v35 and (v13:BuffDown(v91.ArcaneIntellect, true) or v95.GroupBuffMissing(v91.ArcaneIntellect))) then
								if (v19(v91.ArcaneIntellect) or (103 == 4087)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\225\238\3\81\225\229\195\9\94\251\229\240\12\85\236\244\188\7\66\224\245\236\63\82\250\230\250", "\143\128\156\96\48");
								end
							end
							if ((3036 > 2582) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\153\195\243\19\25\189\247\241\31\30\180\216\241\0", "\119\216\177\144\114")]:IsReady() and v34 and v13:BuffDown(v91.ArcaneFamiliarBuff)) then
								if (v19(v91.ArcaneFamiliar) or (255 > 608)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\200\59\250\67\199\44\198\68\200\36\240\78\192\40\235\2\217\59\252\65\198\36\251\67\221\105\171", "\34\169\73\153");
								end
							end
							v220 = 1;
						end
					end
				end
				if (v95.TargetIsValid() or (3982 <= 2940)) then
					local v221 = 0;
					while true do
						if ((v221 == 1) or (3791 > 4684)) then
							v25 = v113();
							if (v25 or (2927 <= 967)) then
								return v25;
							end
							v221 = 2;
						end
						if ((v221 == 2) or (631 > 2929)) then
							if (v71 or (341 > 3956)) then
								if (v90 or (4842 <= 1498)) then
									local v232 = 0;
									while true do
										if ((v232 == 0) or (1312 > 4950)) then
											v25 = v95.HandleAfflicted(v91.RemoveCurse, v93.RemoveCurseMouseover, 30);
											if (v25 or (840 == 1211)) then
												return v25;
											end
											break;
										end
									end
								end
							end
							if ((4499 > 1584) and v72) then
								local v226 = 0;
								while true do
									if ((3708 <= 4221) and (v226 == 0)) then
										v25 = v95.HandleIncorporeal(v91.Polymorph, v93.PolymorphMouseOver, 30, true);
										if (v25 or (3680 <= 483)) then
											return v25;
										end
										break;
									end
								end
							end
							v221 = 3;
						end
						if ((1429 <= 3193) and (v221 == 3)) then
							if ((2629 > 487) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\73\164\46\132\118\167\63\141\123\184", "\232\26\212\75")]:IsAvailable() and v86 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\4\89\119\228\251\36\93\119\233\251", "\151\87\41\18\136")]:IsReady() and v30 and v69 and not v13:IsCasting() and not v13:IsChanneling() and v95.UnitHasMagicBuff(v14)) then
								if (v19(v91.Spellsteal, not v14:IsSpellInRange(v91.Spellsteal)) or (4372 < 2905)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\72\191\207\220\242\72\187\207\209\242\27\171\203\221\255\92\170", "\158\59\207\170\176");
								end
							end
							if ((1134 > 513) and not v13:IsCasting() and not v13:IsChanneling() and v13:AffectingCombat() and v95.TargetIsValid()) then
								local v227 = 0;
								local v228;
								while true do
									if ((0 == v227) or (3433 == 2550)) then
										v228 = v95.HandleDPSPotion(not v91[LUAOBFUSACTOR_DECRYPT_STR_0("\110\76\48\72\130\74\109\38\91\139\74", "\236\47\62\83\41")]:IsReady());
										if ((407 <= 1997) and v228) then
											return v228;
										end
										v227 = 1;
									end
									if ((v227 == 3) or (1455 >= 2073)) then
										if (v25 or (3473 > 4578)) then
											return v25;
										end
										v25 = v125();
										v227 = 4;
									end
									if ((2519 < 3193) and (v227 == 4)) then
										if (v25 or (463 >= 4937)) then
											return v25;
										end
										break;
									end
									if ((1 == v227) or (3991 <= 3758)) then
										if ((v87 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\206\160\45\62\157\131\232\185", "\226\154\201\64\91\202")]:IsReady() and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\245\76\16\8\69\174\192\69\42\25\88\172", "\220\161\41\125\120\42")]:IsAvailable() and v13:BloodlustExhaustUp() and (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\157\99\163\15\178\116\147\27\174\118\165", "\110\220\17\192")]:CooldownUp() or (v111 <= 40) or (v13:BuffUp(v91.ArcaneSurgeBuff) and (v111 <= (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\85\107\55\27\229\50\194\178\102\126\49", "\199\20\25\84\122\139\87\145")]:CooldownRemains() + 14))))) or (4387 <= 2300)) then
											if (v19(v91.TimeWarp, not v14:IsInRange(40)) or (4301 == 2660)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\83\0\208\171\36\253\70\27\205\238\22\235\78\7\157\250", "\138\39\105\189\206\123");
											end
										end
										if ((1590 <= 3077) and v77 and ((v80 and v28) or not v80) and (v76 < v111)) then
											local v234 = 0;
											while true do
												if ((v234 == 1) or (4107 <= 1029)) then
													if (v13:PrevGCDP(1, v91.ArcaneSurge) or (1843 == 3876)) then
														local v236 = 0;
														while true do
															if ((4715 >= 1158) and (v236 == 0)) then
																if ((1989 == 1989) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\213\241\37\211\9\222\216\229\228", "\173\151\157\74\188\109\152")]:IsCastable()) then
																	if (v19(v91.BloodFury) or (3162 == 4103)) then
																		return LUAOBFUSACTOR_DECRYPT_STR_0("\38\4\55\210\216\107\211\230\54\17\120\208\221\93\219\179\117\88", "\147\68\104\88\189\188\52\181");
																	end
																end
																if (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\60\129\153\213\24\132\132\223\30", "\176\122\232\235")]:IsCastable() or (3247 == 4400)) then
																	if ((3761 > 2745) and v19(v91.Fireblood)) then
																		return LUAOBFUSACTOR_DECRYPT_STR_0("\134\124\40\74\236\140\122\53\75\174\141\116\51\65\174\209\39", "\142\224\21\90\47");
																	end
																end
																v236 = 1;
															end
															if ((772 < 4176) and (v236 == 1)) then
																if ((2766 >= 654) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\85\218\36\83\183\159\151\117\216\4\87\168\135", "\229\20\180\71\54\196\235")]:IsCastable()) then
																	if (v19(v91.AncestralCall) or (4827 == 2370)) then
																		return LUAOBFUSACTOR_DECRYPT_STR_0("\40\112\194\230\230\190\146\40\114\254\224\244\166\140\105\115\192\234\251\234\209\125", "\224\73\30\161\131\149\202");
																	end
																end
																break;
															end
														end
													end
													break;
												end
												if ((v234 == 0) or (2486 > 2851)) then
													if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\51\14\142\37\231\234\229\234\27\0\132\40\253\237", "\159\127\103\233\77\147\153\175")]:IsCastable() and v13:BuffDown(v91.ArcaneSurgeBuff) and v14:DebuffDown(v91.TouchoftheMagiDebuff) and ((v98 >= 2) or (v99 >= 2))) or (3984 == 1629)) then
														if (v19(v91.LightsJudgment, not v14:IsSpellInRange(v91.LightsJudgment)) or (2473 > 3375)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\11\249\227\162\84\216\56\250\241\174\71\198\2\254\240\234\77\202\14\254\164\252", "\171\103\144\132\202\32");
														end
													end
													if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\50\42\251\31\21\61\226\5\30\40", "\108\112\79\137")]:IsCastable() and ((v13:PrevGCDP(1, v91.ArcaneSurge) and not (v13:BuffUp(v91.TemporalWarpBuff) and v13:BloodlustUp())) or (v13:BuffUp(v91.ArcaneSurgeBuff) and v14:DebuffUp(v91.TouchoftheMagiDebuff)))) or (4886 == 1971)) then
														if (v19(v91.Berserking) or (2594 <= 1430)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\61\199\102\59\168\19\226\60\49\197\52\37\172\8\231\117\103", "\85\95\162\20\72\205\97\137");
														end
													end
													v234 = 1;
												end
											end
										end
										v227 = 2;
									end
									if ((4813 > 4545) and (v227 == 2)) then
										if ((v76 < v111) or (4915 < 4893)) then
											if ((4143 == 4143) and v78 and ((v28 and v79) or not v79)) then
												local v235 = 0;
												while true do
													if ((1223 < 3414) and (v235 == 0)) then
														v25 = v115();
														if ((450 < 2517) and v25) then
															return v25;
														end
														break;
													end
												end
											end
										end
										v25 = v117();
										v227 = 3;
									end
								end
							end
							break;
						end
						if ((2235 == 2235) and (0 == v221)) then
							if ((927 <= 2517) and Focus) then
								if (v70 or (2073 > 4117)) then
									local v233 = 0;
									while true do
										if ((v233 == 0) or (3015 > 4666)) then
											v25 = v114();
											if ((1039 < 4270) and v25) then
												return v25;
											end
											break;
										end
									end
								end
							end
							if ((125 < 2081) and not v13:AffectingCombat() and v26) then
								local v229 = 0;
								while true do
									if ((v229 == 0) or (1869 == 4900)) then
										v25 = v116();
										if (v25 or (1777 >= 3312)) then
											return v25;
										end
										break;
									end
								end
							end
							v221 = 1;
						end
					end
				end
				break;
			end
			if ((v146 == 1) or (1170 > 1897)) then
				v28 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\48\33\178\136\58\53", "\213\228\95\70")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\191\209", "\23\74\219\162\228")];
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\13\233\65\168\55\60\245", "\91\89\134\38\207")][LUAOBFUSACTOR_DECRYPT_STR_0("\73\231\198\63\16\212\52", "\71\36\142\168\86\115\176")];
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\235\174\117\184\15\187\69", "\41\191\193\18\223\99\222\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\175\47\212\58\175\167", "\202\203\70\167\74")];
				if ((888 >= 752) and v13:IsDeadOrGhost()) then
					return;
				end
				v146 = 2;
			end
			if ((v146 == 2) or (3089 > 4023)) then
				v97 = v14:GetEnemiesInSplashRange(5);
				v100 = v13:GetEnemiesInRange(40);
				if (v27 or (4850 == 1446)) then
					local v222 = 0;
					while true do
						if ((v222 == 0) or (3104 == 1021)) then
							v98 = max(v14:GetEnemiesInSplashRangeCount(5), #v100);
							v99 = #v100;
							break;
						end
					end
				else
					local v223 = 0;
					while true do
						if ((1584 < 4428) and (v223 == 0)) then
							v98 = 1;
							v99 = 1;
							break;
						end
					end
				end
				if ((1324 < 1928) and (v95.TargetIsValid() or v13:AffectingCombat())) then
					local v224 = 0;
					while true do
						if ((4629 == 4629) and (0 == v224)) then
							if ((2911 < 3901) and (v13:AffectingCombat() or v70)) then
								local v230 = 0;
								local v231;
								while true do
									if ((379 < 1357) and (v230 == 0)) then
										v231 = v70 and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\30\4\209\60\103\41\34\201\33\98\41", "\17\76\97\188\83")]:IsReady() and v30;
										v25 = v95.FocusUnit(v231, v93, 20, nil, 20);
										v230 = 1;
									end
									if ((v230 == 1) or (1393 <= 362)) then
										if ((1460 == 1460) and v25) then
											return v25;
										end
										break;
									end
								end
							end
							v110 = v10.BossFightRemains(nil, true);
							v224 = 1;
						end
						if ((v224 == 1) or (3516 <= 1360)) then
							v111 = v110;
							if ((v111 == 11111) or (1890 <= 123)) then
								v111 = v10.FightRemains(v100, false);
							end
							break;
						end
					end
				end
				v146 = 3;
			end
		end
	end
	local function v129()
		local v147 = 0;
		while true do
			if ((v147 == 0) or (1683 >= 3073)) then
				v96();
				v17.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\208\247\242\81\255\224\177\125\240\226\244\16\227\234\229\81\229\236\254\94\177\231\232\16\212\245\248\83\191\165\194\69\225\245\254\66\229\224\245\16\243\252\177\72\218\228\255\85\229\234\191", "\48\145\133\145"));
				break;
			end
		end
	end
	v17.SetAPL(62, v128, v129);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\127\92\188\246\238\1\91\75\176\209\240\62\89\77\187\235\159\32\79\77", "\76\58\44\213\142\177")]();

