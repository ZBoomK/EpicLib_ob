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
		if ((2893 >= 2383) and (0 == v5)) then
			v6 = v0[v4];
			if ((1108 < 1653) and not v6) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((2909 > 2609) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\213\11\216\199\228\2\243\186\213\26\216\194\213\107\234\174\198", "\126\177\163\187\69\134\219\167")] = function(...)
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
	local v22 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\145\194\212\24\13", "\75\220\163\183\106\98")];
	local v23 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\32\179\133\51", "\185\98\218\235\87")];
	local v24 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local v25 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local v26 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local v27 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\193\88\127\27\171", "\126\167\52\16\116\217")];
	local v28 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\235\33\45\141\187\23\239", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\248\160\220\30\225\171\203", "\174\103\142\197")];
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
	local v65 = v17[LUAOBFUSACTOR_DECRYPT_STR_0("\114\58\74\49\33", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\209\239\78\208\205\239\82", "\60\180\164\142")];
	v65[LUAOBFUSACTOR_DECRYPT_STR_0("\122\82\4\51\46\227\21\108\86\10\59\41\254\48\77\88\3", "\114\56\62\101\73\71\141")] = v17(425407);
	if ((757 > 194) and v13:HasTier(31, 4)) then
		v65[LUAOBFUSACTOR_DECRYPT_STR_0("\154\229\218\222\177\231\220\240\176\230\201\202\171\203\206\194\190", "\164\216\137\187")] = v17(425441);
	end
	local v67 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\246\244\36\187\162", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\31\27\131\212\174\49\15\140", "\202\88\110\226\166")];
	local v68 = {v67[LUAOBFUSACTOR_DECRYPT_STR_0("\231\5\131\229\223\214\1", "\170\163\111\226\151")]:ID()};
	local v69 = v22[LUAOBFUSACTOR_DECRYPT_STR_0("\53\34\167\49\74", "\73\113\80\210\88\46\87")][LUAOBFUSACTOR_DECRYPT_STR_0("\166\57\204\0\227\136\45\195", "\135\225\76\173\114")];
	local v70;
	local v71, v72;
	local v73, v74;
	local v75;
	local v76;
	local v77;
	local v78 = v65[LUAOBFUSACTOR_DECRYPT_STR_0("\46\229\183\162\162\174\168\28\196\170\191\162", "\199\122\141\216\208\204\221")]:IsAvailable() and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\159\216\25\254\126\249\191\222\21\244\94\227\191", "\150\205\189\112\144\24")]:IsAvailable();
	local v79, v80;
	v10:RegisterForEvent(function()
		local v95 = 0;
		while true do
			if ((v95 == 0) or (31 >= 1398)) then
				v65[LUAOBFUSACTOR_DECRYPT_STR_0("\7\136\190\86\13\134\22\36\45\139\173\66\23\170\4\22\35", "\112\69\228\223\44\100\232\113")] = v17(425407);
				if ((3196 <= 4872) and v13:HasTier(31, 4)) then
					v65[LUAOBFUSACTOR_DECRYPT_STR_0("\246\19\6\201\191\114\129\224\23\8\193\184\111\164\193\25\1", "\230\180\127\103\179\214\28")] = v17(425441);
				end
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\188\41\126\127\193\115\223\169\52\106\111\212\108\197\162\49\96\101\204\96\206\171\32\123", "\128\236\101\63\38\132\33"));
	v10:RegisterForEvent(function()
		IFBuild = v65[LUAOBFUSACTOR_DECRYPT_STR_0("\152\161\30\86\184\248\192\170\128\3\75\184", "\175\204\201\113\36\214\139")]:IsAvailable() and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\117\201\60\210\2\72\222\54\217\0\97\217\39", "\100\39\172\85\188")]:IsAvailable();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\158\72\156\172\31\158\71\154\168\18\131\95\156\164", "\83\205\24\217\224"), LUAOBFUSACTOR_DECRYPT_STR_0("\202\224\236\15\200\224\233\2\213\245\232\17\202\250\228\19\217\241\236\31", "\93\134\165\173"));
	local function v81(v96)
		local v97 = 0;
		while true do
			if ((3326 == 3326) and (v97 == 0)) then
				for v139, v140 in pairs(v96) do
					if ((1433 <= 3878) and v140:DebuffUp(v65.ToothandClawDebuff)) then
						return false;
					end
				end
				return true;
			end
		end
	end
	local function v82(v98)
		return v98:DebuffRefreshable(v65.MoonfireDebuff) and (v98:TimeToDie() > 12) and (((v80 < 7) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\152\231\211\219\53\200\156\127\170\231\211\199", "\30\222\146\161\162\90\174\210")]:IsAvailable()) or ((v80 < 4) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\195\91\98\19\234\72\94\11\241\91\98\15", "\106\133\46\16")]:IsAvailable()));
	end
	local function v83(v99)
		return v99:DebuffRefreshable(v65.ThrashDebuff) or ((v16:DebuffStack(v65.ThrashDebuff) < 5) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\126\44\114\239\82\73\86\39\80\240\91\87\75", "\32\56\64\19\156\58")]:TalentRank() == 2)) or ((v16:DebuffStack(v65.ThrashDebuff) < 4) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\124\196\228\69\82\251\142\93\235\233\87\77\225", "\224\58\168\133\54\58\146")]:TalentRank() == 1)) or ((v16:DebuffStack(v65.ThrashDebuff) < 3) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\127\90\74\238\125\143\137\12\122\90\74\234\102", "\107\57\54\43\157\21\230\231")]:IsAvailable());
	end
	local function v84(v100)
		return v100:DebuffRefreshable(v65.ThrashDebuff) or (v100:DebuffStack(v65.ThrashDebuff) < 3) or (v80 >= 5);
	end
	local function v85(v101)
		return v101:DebuffStack(v65.ThrashDebuff) > 2;
	end
	local function v86()
		return v65[LUAOBFUSACTOR_DECRYPT_STR_0("\233\142\19\252\171\200\199", "\175\187\235\113\149\217\188")]:CooldownUp() and v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14);
	end
	local function v87()
		local v102 = 0;
		while true do
			if ((1 == v102) or (1583 == 1735)) then
				v70 = v28.HandleBottomTrinket(v68, v31 and (v13:BuffUp(v65.HeartOfTheWild) or v13:BuffUp(v65.Incarnation) or v13:BloodlustUp()), 40, nil);
				if (v70 or (2981 == 2350)) then
					return v70;
				end
				break;
			end
			if ((v102 == 0) or (4466 <= 493)) then
				v70 = v28.HandleTopTrinket(v68, v31 and (v13:BuffUp(v65.HeartOfTheWild) or v13:BuffUp(v65.Incarnation) or v13:BloodlustUp()), 40, nil);
				if (v70 or (2547 <= 1987)) then
					return v70;
				end
				v102 = 1;
			end
		end
	end
	local function v88()
		local v103 = 0;
		while true do
			if ((2961 > 2740) and (v103 == 0)) then
				if ((3696 >= 3612) and (v13:HealthPercentage() < v59) and v58 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\26\189\132\66\249\112\125\56\157\132\75\230\119\125\46\174\149\69\236\119", "\24\92\207\225\44\131\25")]:IsReady() and v13:BuffDown(v65.FrenziedRegenerationBuff) and not v13:HealingAbsorbed()) then
					if (v24(v65.FrenziedRegeneration) or (2970 == 1878)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\77\193\189\66\1\116\78\215\135\94\30\122\78\221\189\94\26\105\66\220\182\12\31\120\77\214\182\95\18\107\78\147\234", "\29\43\179\216\44\123");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\143\220\39\94\178\206\52\68", "\44\221\185\64")]:IsCastable() and v13:BuffUp(v65.DreamofCenariusBuff) and ((v13:BuffDown(v65.PoPHealBuff) and (v13:HealthPercentage() < v52)) or (v13:BuffUp(v65.PoPHealBuff) and (v13:HealthPercentage() < v53)))) or (3693 < 1977)) then
					if (v24(v69.RegrowthPlayer) or (930 > 2101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\226\79\77\124\22\243\64\31\119\4\225\77\81\96\8\241\77\31\39", "\19\97\135\40\63");
					end
				end
				v103 = 1;
			end
			if ((4153 > 3086) and (v103 == 1)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\156\89\61\62\56\48\162", "\81\206\60\83\91\79")]:IsCastable() and (v13:HealthPercentage() < v57) and v56) or (4654 <= 4050)) then
					if (v24(v65.Renewal) or (2602 < 1496)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\92\174\222\119\56\194\65\228\74\174\214\119\33\208\68\178\75\235\134", "\196\46\203\176\18\79\163\45");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\145\48\113\16\34\238\253", "\143\216\66\30\126\68\155")]:IsReady() and (v13:BuffDown(v65.IronfurBuff) or ((v13:BuffStack(v65.IronfurBuff) < 2) and v13:BuffRefreshable(v65.Ironfur)))) or (1020 > 2288)) then
					if ((328 == 328) and v24(v65.Ironfur)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\163\218\2\197\195\182\197\161\174\205\11\206\203\176\222\247\175\136\85", "\129\202\168\109\171\165\195\183");
					end
				end
				v103 = 2;
			end
			if ((1511 < 3808) and (3 == v103)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\90\149\39\4\108\139\39\25\127\161\59\5", "\119\24\231\78")]:IsCastable() and (v13:Rage() < 50) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\176\44\162\79\211\70\5\138\40\150\70\217\69\1\135\63", "\113\226\77\197\42\188\32")]:CooldownRemains() > 8)) or (2510 > 4919)) then
					if ((4763 == 4763) and v24(v65.BristlingFur)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\56\4\253\166\46\26\253\187\61\41\242\160\40\86\240\176\60\19\250\166\51\0\241\245\107\66", "\213\90\118\148");
					end
				end
				if ((4137 > 1848) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\117\47\160\67\95\94\61\130\95\74\82\34", "\45\59\78\212\54")]:IsReady() and (v13:HealthPercentage() <= v61) and v60) then
					if ((2436 <= 3134) and v24(v65.NaturesVigil, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\30\87\151\158\148\43\190\207\6\95\132\130\138\110\169\245\22\83\141\152\143\56\168\176\65\14", "\144\112\54\227\235\230\78\205");
					end
				end
				v103 = 4;
			end
			if ((3723 == 3723) and (v103 == 2)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\0\89\37\211\205\31\239\44", "\134\66\56\87\184\190\116")]:IsCastable() and v54 and (((v13:HealthPercentage() < v55) and v13:BuffDown(v65.IronfurBuff)) or (v13:HealthPercentage() < (v55 * 0.75)))) or (4046 >= 4316)) then
					if (v24(v65.Barkskin) or (2008 < 1929)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\48\27\176\10\224\40\59\124\53\12\189\28\229\50\60\42\52\73\234\73", "\85\92\81\105\219\121\139\65");
					end
				end
				if ((2384 > 1775) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\206\166\66\83\117\201\252\191\121\75\111\203\244\189\83\81\111", "\191\157\211\48\37\28")]:IsCastable() and (v13:HealthPercentage() < v63) and v62) then
					if (v24(v65.SurvivalInstincts) or (4543 <= 4376)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\10\230\10\51\201\30\248\35\51\209\12\224\21\52\220\11\231\92\62\218\25\241\18\41\214\9\241\92\107\141", "\90\191\127\148\124");
					end
				end
				v103 = 3;
			end
			if ((728 == 728) and (4 == v103)) then
				if ((v67[LUAOBFUSACTOR_DECRYPT_STR_0("\155\45\14\240\196\83\160\60\0\242\213", "\59\211\72\111\156\176")]:IsReady() and v39 and (v13:HealthPercentage() <= v40)) or (1076 > 4671)) then
					if ((1851 >= 378) and v24(v69.Healthstone, nil, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\70\130\226\33\90\143\240\57\65\137\230\109\74\130\229\40\64\148\234\59\75\199\176", "\77\46\231\131");
					end
				end
				if ((v34 and (v13:HealthPercentage() <= v36)) or (1948 >= 3476)) then
					if ((4794 >= 833) and (v35 == LUAOBFUSACTOR_DECRYPT_STR_0("\136\81\176\82\191\71\190\73\180\83\246\104\191\85\186\73\180\83\246\112\181\64\191\79\180", "\32\218\52\214"))) then
						if ((4090 == 4090) and v67[LUAOBFUSACTOR_DECRYPT_STR_0("\124\18\55\186\244\163\77\83\64\16\25\173\240\188\76\84\73\39\62\188\248\191\75", "\58\46\119\81\200\145\208\37")]:IsReady()) then
							if (v24(v69.RefreshingHealingPotion, nil, nil, true) or (3758 == 2498)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\57\137\54\190\172\174\62\34\130\55\236\161\184\55\39\133\62\171\233\173\57\63\133\63\162\233\185\51\45\137\62\191\160\171\51\107\216", "\86\75\236\80\204\201\221");
							end
						end
					end
				end
				break;
			end
		end
	end
	local function v89()
		local v104 = 0;
		while true do
			if ((v104 == 1) or (2673 < 1575)) then
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\152\38\185\74\212\95", "\105\204\78\203\43\167\55\126")]:IsCastable() or (3721 <= 1455)) then
					if ((934 < 2270) and v24(v65.Thrash, not v74)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\177\162\49\31\0\12\135\65\183\175\32\17\30\6\198\69\229\251\113", "\49\197\202\67\126\115\100\167");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\26\90\209\46\140\83", "\62\87\59\191\73\224\54")]:IsCastable() or (1612 == 1255)) then
					if (v24(v65.Mangle, not v73) or (4352 < 4206)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\234\3\244\206\235\7\186\217\245\7\249\198\234\0\251\221\167\83\174", "\169\135\98\154");
					end
				end
				break;
			end
			if ((v104 == 0) or (2860 <= 181)) then
				if ((3222 >= 1527) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\95\78\120\139\248\130\96\68", "\235\18\33\23\229\158")]:IsCastable()) then
					if ((1505 <= 2121) and v24(v65.Moonfire, not v16:IsSpellInRange(v65.Moonfire))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\93\181\206\181\86\179\211\190\16\170\211\190\83\181\204\185\81\174\129\227", "\219\48\218\161");
					end
				end
				if ((744 == 744) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\211\120\112\77\248\71\225\246\118\121", "\128\132\17\28\41\187\47")]:IsCastable() and not v74 and v50) then
					if (v24(v65.WildCharge, not v16:IsInRange(25)) or (1979 >= 2836)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\22\59\10\62\98\2\58\7\40\90\4\114\22\40\88\2\61\11\56\92\21\114\87\106", "\61\97\82\102\90");
					end
				end
				v104 = 1;
			end
		end
	end
	local function v90()
	end
	local function v91()
		local v105 = 0;
		while true do
			if ((1833 <= 2668) and (v105 == 3)) then
				if ((3686 == 3686) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\31\207\69\238", "\224\77\174\63\139\38\175")]:IsReady() and not v78 and (v13:BuffUp(v65.IncarnationBuff) or v13:BuffUp(v65.BerserkBuff)) and (v80 > 1) and ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\182\64\95\43\139\71\76\38\129\114\84\43\129\81\93\60", "\78\228\33\56")]:CooldownRemains() > 3) or v13:BuffUp(v65.RageoftheSleeper))) then
					if ((3467 > 477) and v24(v65.Raze, not v73)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\127\168\6\197\204\123\179\17\197\157\46", "\229\174\30\210\99");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\50\255\137\95\235\40\43", "\89\123\141\230\49\141\93")]:IsReady() and not v78 and v48 and ((v13:BuffDown(v65.IronfurBuff) and (v13:Rage() > 50) and v76) or (v13:Rage() > 90)) and v13:BuffUp(v65.RageoftheSleeper) and v13:BuffDown(v65.BlazingThornsBuff)) or (3288 >= 3541)) then
					if (v24(v65.Ironfur) or (3557 == 4540)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\250\99\249\2\22\95\225\49\244\9\17\88\179\34\164", "\42\147\17\150\108\112");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\38\180\34\113\225\253\29", "\136\111\198\77\31\135")]:IsReady() and v48 and v78 and (((v13:BuffUp(v65.IncarnationBuff) or v13:BuffUp(v65.BerserkBuff)) and (v13:Rage() > 20)) or (v13:Rage() > 90)) and ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\48\8\160\83\178\226\3\161\7\58\171\83\184\244\18\187", "\201\98\105\199\54\221\132\119")]:CooldownRemains() > 3) or v13:BuffUp(v65.RageoftheSleeper))) or (261 > 1267)) then
					if ((1272 < 3858) and v24(v65.Ironfur)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\176\30\140\47\4\32\190\249\14\134\32\16\117\255\237", "\204\217\108\227\65\98\85");
					end
				end
				if ((3664 == 3664) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\108\194\239\224", "\160\62\163\149\133\76")]:IsReady() and v13:BuffUp(v65.ToothandClawBuff) and (v80 > 1) and ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\228\161\10\42\204\208\180\5\42\240\218\165\8\63\198\196", "\163\182\192\109\79")]:CooldownRemains() > 3) or v13:BuffUp(v65.RageoftheSleeper))) then
					if ((1941 >= 450) and v24(v65.Raze, not v73)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\38\39\26\197\181\54\35\1\210\181\103\112", "\149\84\70\96\160");
					end
				end
				v105 = 4;
			end
			if ((v105 == 2) or (4646 < 324)) then
				if ((3833 == 3833) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\148\176\244\195\179\167\237\217\184\178", "\176\214\213\134")]:IsCastable() and (v13:BuffUp(v65.BerserkBuff) or v13:BuffUp(v65.IncarnationBuff))) then
					if (v24(v65.Berserking, not v73) or (1240 > 3370)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\168\164\199\173\68\82\253\163\177\148\170\83\88\230\237\228\134", "\57\148\205\214\180\200\54");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\63\252\32\56", "\22\114\157\85\84")]:IsReady() and v77 and v13:BuffUp(v65.RageoftheSleeper) and (v13:BuffStack(v65.ToothandClawBuff) > 0) and not v78 and (((v80 <= 6) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\246\202\9\193", "\200\164\171\115\164\61\150")]:IsAvailable()) or ((v80 == 1) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\140\245\25\64", "\227\222\148\99\37")]:IsAvailable()))) or (2481 == 4682)) then
					if ((4727 >= 208) and v24(v65.Maul, not v73)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\83\71\250\185\49\87\83\228\185\97\6", "\153\83\50\50\150");
					end
				end
				if ((280 < 3851) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\111\119\105\25", "\45\61\22\19\124\19\203")]:IsReady() and v13:BuffUp(v65.RageoftheSleeper) and (v13:BuffStack(v65.ToothandClawBuff) > 0) and not v78 and (v80 > 1)) then
					if (v24(v65.Raze, not v73) or (3007 > 3194)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\211\19\23\240\66\114\188\192\0\77\167\84", "\217\161\114\109\149\98\16");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\63\33\45\112", "\20\114\64\88\28\220")]:IsReady() and not v78 and v77 and (v13:BuffUp(v65.IncarnationBuff) or v13:BuffUp(v65.BerserkBuff)) and (v13:BuffStack(v65.ToothandClawBuff) >= 1) and (((v80 <= 5) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\3\0\200\177", "\221\81\97\178\212\152\176")]:IsAvailable()) or ((v80 == 1) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\255\230\7\254", "\122\173\135\125\155")]:IsAvailable())) and (v13:BuffUp(v65.RageoftheSleeper) or (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\182\192\7\188\48\55\220\140\196\51\181\58\52\216\129\211", "\168\228\161\96\217\95\81")]:CooldownRemains() > 3))) or (2136 >= 2946)) then
					if ((2165 <= 2521) and v24(v65.Maul, not v73)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\214\208\59\80\111\85\222\208\60\28\125\15", "\55\187\177\78\60\79");
					end
				end
				v105 = 3;
			end
			if ((2861 > 661) and (v105 == 1)) then
				if ((4525 > 4519) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\195\201\32\241\252\59\245\76", "\34\129\168\82\154\143\80\156")]:IsReady() and (v13:BuffDown(v65.BearForm))) then
					if ((3178 > 972) and v24(v65.Barkskin)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\135\179\33\0\91\69\128\139\242\49\14\73\92\201\212\226", "\233\229\210\83\107\40\46");
					end
				end
				if ((4766 == 4766) and v31) then
					local v142 = 0;
					while true do
						if ((1 == v142) or (2745 > 3128)) then
							if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\28\186\136\243\200\59\181\159\251\213\59", "\186\85\212\235\146")]:IsCastable() or (1144 >= 4606)) then
								if ((3338 >= 277) and v24(v65.Incarnation, not v73)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\203\143\21\255\43\224\89\214\136\25\240\121\236\93\195\147\86\175\111", "\56\162\225\118\158\89\142");
								end
							end
							break;
						end
						if ((2610 > 2560) and (v142 == 0)) then
							if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\226\77\60\192\10\202\71\6\222\0\242\82\59\196\12\213\81", "\101\161\34\82\182")]:IsCastable() or (1194 > 3083)) then
								if ((916 >= 747) and v24(v65.ConvokeTheSpirits, not v73, true)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\235\2\87\232\212\233\135\17\252\5\92\193\200\242\139\60\225\25\74\190\217\231\131\60\168\92\11", "\78\136\109\57\158\187\130\226");
								end
							end
							if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\28\58\235\226\59\45\242", "\145\94\95\153")]:IsCastable() or (2444 > 2954)) then
								if ((2892 < 3514) and v24(v65.Berserk, not v73)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\255\200\6\198\75\165\246\141\22\208\79\165\189\156\64", "\215\157\173\116\181\46");
								end
							end
							v142 = 1;
						end
					end
				end
				if ((533 == 533) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\112\16\206\174\48\250\89\4\205", "\184\60\101\160\207\66")]:IsReady() and v31) then
					if ((595 <= 3413) and v24(v65.LunarBeam)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\151\114\189\35\189\126\185\48\143\60\190\52\131\110\252\96\218", "\220\81\226\28");
					end
				end
				if ((3078 >= 2591) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\33\212\133\254\229\193\7\221\135\200\230\194\22\197\135\233", "\167\115\181\226\155\138")]:IsCastable() and v76 and ((((v13:BuffDown(v65.IncarnationBuff) and (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\203\44\228\93\105\127\199\246\43\232\82", "\166\130\66\135\60\27\17")]:CooldownRemains() > 60)) or v13:BuffDown(v65.BerserkBuff)) and (v13:Rage() > 75) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\103\69\192\99\63\79\79\250\125\53\119\90\199\103\57\80\89", "\80\36\42\174\21")]:IsAvailable()) or ((v13:BuffUp(v65.IncarnationBuff) or v13:BuffUp(v65.BerserkBuff)) and (v13:Rage() > 75) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\109\31\57\108\65\27\50\78\70\21\4\106\71\2\62\110\93", "\26\46\112\87")]:IsAvailable()) or (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\154\44\165\98\176\180\64\128\177\38\152\100\182\173\76\160\170", "\212\217\67\203\20\223\223\37")]:IsAvailable() and (v13:Rage() > 75)))) then
					if ((3199 < 4030) and v24(v65.RageoftheSleeper)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\140\175\215\133\130\174\237\174\133\173\237\169\129\173\215\170\136\186\146\184\136\169\192\250\223\248", "\178\218\237\200");
					end
				end
				v105 = 2;
			end
			if ((777 < 2078) and (v105 == 0)) then
				if ((1696 <= 2282) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\233\114\37\70\219\60\218\198", "\168\171\23\68\52\157\83")]:IsCastable() and v13:BuffDown(v65.BearForm)) then
					if (v24(v65.BearForm) or (1761 >= 2462)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\116\244\191\26\43\136\230\124\181\175\32\44\149\180\35", "\231\148\17\149\205\69\77");
					end
				end
				if ((4551 > 2328) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\168\162\198\233\67\208\134\147\207\254\96\246\140\163", "\159\224\199\167\155\55")]:IsCastable() and v31 and v47) then
					if ((3825 >= 467) and v24(v65.HeartOfTheWild)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\255\246\61\192\227\204\51\212\200\231\52\215\200\228\53\222\243\179\62\215\246\225\124\134", "\178\151\147\92");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\161\242\67\60\20\69\104\137", "\26\236\157\44\82\114\44")]:IsReady() or (2890 == 557)) then
					if (v28.CastCycle(v65.Moonfire, v79, v82, not v16:IsSpellInRange(v65.Moonfire), nil, nil, v69.MoonfireMouseover) or (4770 == 2904)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\39\33\218\85\44\39\199\94\106\44\208\90\56\110\131", "\59\74\78\181");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\17\217\72\91\160\45", "\211\69\177\58\58")]:IsCastable() or (3903 == 4536)) then
					if ((4093 <= 4845) and v28.CastCycle(v65.Thrash, v79, v83, not v74, nil, nil, v69.ThrashMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\163\237\107\244\250\195\247\231\124\244\251\139\239", "\171\215\133\25\149\137");
					end
				end
				v105 = 1;
			end
			if ((1569 <= 3647) and (v105 == 6)) then
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\195\22\37\6\135\74\17\108\246", "\22\147\99\73\112\226\56\120")]:IsReady() or (4046 >= 4927)) then
					if ((4623 >= 2787) and v28.CastCycle(v65.Pulverize, v79, v85, not v73, nil, nil, v69.PulverizeMouseover)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\168\96\238\227\136\170\124\248\240\205\186\112\227\231\205\237\33", "\237\216\21\130\149");
					end
				end
				if ((2234 >= 1230) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\182\70\77\94\163\193", "\62\226\46\63\63\208\169")]:IsCastable()) then
					if (v24(v65.Thrash, not v74) or (343 == 1786)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\241\17\71\130\12\5\111\92\224\24\71\195\74\91", "\62\133\121\53\227\127\109\79");
					end
				end
				if ((2570 > 2409) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\61\27\61\251\208\167\176\21", "\194\112\116\82\149\182\206")]:IsCastable() and (v13:BuffUp(v65.GalacticGuardianBuff))) then
					if (v24(v65.Moonfire, not v16:IsSpellInRange(v65.Moonfire)) or (2609 >= 3234)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\52\167\67\22\198\235\28\60\232\78\29\193\240\78\108\240", "\110\89\200\44\120\160\130");
					end
				end
				if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\152\212\66\86\70", "\45\203\163\43\38\35\42\91")]:IsCastable() or (3033 >= 4031)) then
					if (v24(v65.Swipe, not v74) or (1401 == 4668)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\193\146\213\51\130\233\86\215\132\206\99\209\249", "\52\178\229\188\67\231\201");
					end
				end
				break;
			end
			if ((2776 >= 1321) and (v105 == 4)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\10\7\23\232", "\141\88\102\109")]:IsReady() and not v78 and (v80 > 1) and ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\129\82\205\117\21\59\65\201\182\96\198\117\31\45\80\211", "\161\211\51\170\16\122\93\53")]:CooldownRemains() > 3) or v13:BuffUp(v65.RageoftheSleeper))) or (487 > 2303)) then
					if (v24(v65.Raze, not v73) or (4503 == 3462)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\233\175\168\45\187\172\183\41\233\238\225\112", "\72\155\206\210");
					end
				end
				if ((553 <= 1543) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\107\123\90\9\63\67", "\83\38\26\52\110")]:IsCastable() and ((v13:BuffUp(v65.GoreBuff) and (v80 < 11)) or (v13:BuffStack(v65.ViciousCycleMaulBuff) == 3))) then
					if ((2015 == 2015) and v24(v65.Mangle, not v73)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\22\41\65\84\18\103\68\93\22\53\6\12\71", "\38\56\119\71");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\222\238\77\218", "\54\147\143\56\182\69")]:IsReady() and v13:BuffUp(v65.ToothandClawBuff) and (((v80 <= 5) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\228\128\229\76", "\191\182\225\159\41")]:IsAvailable()) or ((v80 == 1) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\25\19\50\80", "\162\75\114\72\53\235\231")]:IsAvailable())) and (v13:BuffUp(v65.RageoftheSleeper) or (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\190\61\67\231\92\4\152\52\65\209\95\7\137\44\65\240", "\98\236\92\36\130\51")]:CooldownRemains() > 3))) or (4241 <= 2332)) then
					if (v24(v65.Maul, not v73) or (2364 < 1157)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\24\25\182\5\170\176\49\182\89\88\232", "\80\196\121\108\218\37\200\213");
					end
				end
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\45\114\23\115", "\234\96\19\98\31\43\110")]:IsReady() and not v78 and (((v80 <= 5) and not v65[LUAOBFUSACTOR_DECRYPT_STR_0("\52\30\72\194", "\235\102\127\50\167\204\18")]:IsAvailable()) or ((v80 == 1) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\98\160\239\38", "\78\48\193\149\67\36")]:IsAvailable())) and (v13:BuffUp(v65.RageoftheSleeper) or (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\2\31\135\29\78\54\10\136\29\114\60\27\133\8\68\34", "\33\80\126\224\120")]:CooldownRemains() > 3))) or (1167 > 1278)) then
					if (v24(v65.Maul, not v73) or (1145 <= 1082)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\225\169\22\200\28\238\173\2\214\28\184\252", "\60\140\200\99\164");
					end
				end
				v105 = 5;
			end
			if ((v105 == 5) or (3105 == 4881)) then
				if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\179\252\22\39\177\143", "\194\231\148\100\70")]:IsCastable() and (v80 >= 5)) or (1887 > 4878)) then
					if (v24(v65.Thrash, not v74) or (4087 > 4116)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\82\68\211\162\229\192\6\78\196\162\228\136\18\26", "\168\38\44\161\195\150");
					end
				end
				if ((1106 <= 1266) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\179\235\139\102\53", "\118\224\156\226\22\80\136\214")]:IsCastable() and v13:BuffDown(v65.IncarnationBuff) and v13:BuffDown(v65.BerserkBuff) and (v80 >= 11)) then
					if ((3155 < 4650) and v24(v65.Swipe, not v74)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\81\249\80\144\71\174\91\133\67\252\25\212\26", "\224\34\142\57");
					end
				end
				if ((3774 >= 1839) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\243\166\203\218\127\244", "\110\190\199\165\189\19\145\61")]:IsCastable() and ((v13:BuffUp(v65.IncarnationBuff) and (v80 <= 4)) or (v13:BuffUp(v65.IncarnationBuff) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\233\228\98\228\132\193\206\227\114\206\132\213\223\248\99", "\167\186\139\23\136\235")]:IsAvailable() and (v80 <= 5)) or ((v13:Rage() < 90) and (v80 < 11)) or ((v13:Rage() < 85) and (v80 < 11) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\41\186\157\1\21\179\156\5\31\147\135\31\31\166\156", "\109\122\213\232")]:IsAvailable()))) then
					if ((2811 == 2811) and v24(v65.Mangle, not v73)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\246\172\55\226\242\226\50\235\246\176\112\187\167", "\80\142\151\194");
					end
				end
				if ((2146 > 1122) and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\55\206\101\77\16\206", "\44\99\166\23")]:IsCastable() and (v80 > 1)) then
					if (v24(v65.Thrash, not v74) or (56 == 3616)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\104\255\59\55\32\172\60\245\44\55\33\228\41\165", "\196\28\151\73\86\83");
					end
				end
				v105 = 6;
			end
		end
	end
	local function v92()
		local v106 = 0;
		while true do
			if ((v106 == 0) or (2421 < 622)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\68\68\16\254\82\36\50", "\67\65\33\48\100\151\60")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\244\171\234\242\220\238\175\212\224", "\147\191\135\206\184")];
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\45\178\213\209\93\181\151", "\210\228\72\198\161\184\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\3\90\246\56\118\207\58\64\253\23\67\193\34\64\252\30", "\174\86\41\147\112\19")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\5\153\31\44\1\22\184", "\203\59\96\237\107\69\111\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\12\19\173\237\56\254\208\20\25\184\232\62\254\249\37\27\169", "\183\68\118\204\129\81\144")] or "";
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\61\168\100\240\2\140\9\190", "\226\110\205\16\132\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\195\198\225\213\72\229\196\208\214\85\226\204\238\241\113", "\33\139\163\128\185")] or 0;
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\93\16\202\94\86\3\205", "\190\55\56\100")][LUAOBFUSACTOR_DECRYPT_STR_0("\99\188\57\51\18\241\248\121\169\8\22\22\212\250\90\171", "\147\54\207\92\126\115\131")];
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\52\33\105\4\112\10\34", "\30\109\81\85\29\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\219\120\71\166\51\210\216\250\115\65\176\48\205", "\156\159\17\52\214\86\190")];
				v106 = 1;
			end
			if ((1009 <= 1130) and (v106 == 1)) then
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\157\234\169\168\167\225\186\175", "\220\206\143\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\162\116\62\7\221\192\240\147\123\43\4", "\178\230\29\77\119\184\172")];
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\198\187\30\15\126\246\242\173", "\152\149\222\106\123\23")][LUAOBFUSACTOR_DECRYPT_STR_0("\232\53\243\107\176\220\42\226\75\166\201\41\248\70", "\213\189\70\150\35")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\124\80\96\28\70\91\115\27", "\104\47\53\20")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\73\128\16\168\7\176\88\142\18\185\39\147", "\111\195\44\225\124\220")] or 0;
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\235\67\20\103\162\165\223\85", "\203\184\38\96\19\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\114\119\69\194\60\82\127\71\194\48\112\109\68\202", "\174\89\19\25\33")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\23\70\90\254\137\12\60", "\107\79\114\50\46\151\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\17\167\187\45\134\60\158\206\58\169\167\57\133\43\178\193\53", "\160\89\198\213\73\234\89\215")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\123\116\160\234\204\70\118\167", "\165\40\17\212\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\215\28\54\52\247\204\24\39\17\236\205\0\0\50\240\215", "\70\133\185\104\83")];
				v106 = 2;
			end
			if ((2758 < 2980) and (v106 == 5)) then
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\154\13\202\149\54\167\15\205", "\95\201\104\190\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\222\211\216\166\221\192\194\134\197\210\218\166\197\194\218\188\227\241", "\174\207\171\161")] or 0;
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\251\25\231\241\217\234\237", "\183\141\158\109\147\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\26\227\46\41\8\244\42\35\27\235", "\108\76\105\134")];
				break;
			end
			if ((3 == v106) or (86 >= 3626)) then
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\113\209\35\91\45\30\216", "\121\171\20\165\87\50\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\43\188\4\188\5\212\55\174\34\177\47\201\45\170\51\182\20\195\42", "\98\166\88\217\86\217")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\197\243\109\21\143\210\241\229", "\188\150\150\25\97\230")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\134\124\48\9\234\200\134\72\22\4\195\213\185\80\50\36\221", "\141\186\233\63\98\108")] or 0;
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\239\56\162\44\255\237\63", "\69\145\138\76\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\84\192\170\187\186\17\98\192\158\157\183\33\121\219\129\185\176\38\88\255", "\118\16\175\233\233\223")] or 0;
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\129\33\175\231\133\122\152", "\29\235\228\85\219\142\235")][LUAOBFUSACTOR_DECRYPT_STR_0("\8\199\191\255\118\92\44\65\54\221\180", "\50\93\180\218\189\23\46\71")];
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\237\161\79\88\77\210\79\205", "\40\190\196\59\44\36\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\68\206\191\233\118\4\50\109\236", "\109\92\37\188\212\154\29")] or 0;
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\234\176\215\56\84\3\252", "\58\100\143\196\163\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\47\81\38\145\58\71\224\25\27\78", "\110\122\34\67\195\95\41\133")];
				v106 = 4;
			end
			if ((2395 == 2395) and (v106 == 2)) then
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\55\64\80\62\192\10\66\87", "\169\100\37\36\74")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\137\182\85\18\149\183\64\20\168\172\92\25\176\170\89\20\130\174\89\19\147", "\48\96\231\194")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\251\95\26\57\16\214\168\144", "\227\168\58\110\77\121\184\207")][LUAOBFUSACTOR_DECRYPT_STR_0("\82\50\171\69\163\201\100\181\111\8\183\82\180\200\121\170\119\56", "\197\27\92\223\32\209\187\17")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\90\215\239\10\81\196\232", "\155\99\63\163")][LUAOBFUSACTOR_DECRYPT_STR_0("\183\194\164\165\188\133\144\197\142\139\141\140\135\230\168\129\189", "\228\226\177\193\237\217")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\7\181\55\242\61\190\36\245", "\134\84\208\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\38\191\131\117\1\163\136\90\6\190\169\90\21\169\136\79\26\186\131\80\10", "\60\115\204\230")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\212\63\255\100\238\52\236\99", "\16\135\90\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\97\103\3\1\79\83\125\112\113\0\54\64\71\113\66\113\10\42", "\24\52\20\102\83\46\52")];
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\247\42\53\48\6\202\40\50", "\111\164\79\65\68")][LUAOBFUSACTOR_DECRYPT_STR_0("\243\202\134\233\39\230\194\250\139\223\60\237\195", "\138\166\185\227\190\78")];
				v106 = 3;
			end
			if ((3780 > 2709) and (v106 == 4)) then
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\70\180\79\94\223\123\182\72", "\182\21\209\59\42")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\82\203\24\54\191\187\127\245", "\222\215\55\165\125\65")] or 0;
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\31\212\210\14\251\207\234\89", "\42\76\177\166\122\146\161\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\144\153\0\232\107\115\171\144\12\203\125\68\160\141\0\192", "\22\197\234\101\174\25")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\30\49\177\200\127\161\208\149", "\230\77\84\197\188\22\207\183")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\6\195\242\150\168\245\49\203\17\193\249\130\137\192", "\85\153\116\166\156\236\193\144")] or 0;
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\151\229\89\167\237\14\163\243", "\96\196\128\45\211\132")][LUAOBFUSACTOR_DECRYPT_STR_0("\0\158\126\113\211\187\161\202\48\158\77\86\213\166\184", "\184\85\237\27\63\178\207\212")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\92\29\75\1\87\14\76", "\63\104\57\105")][LUAOBFUSACTOR_DECRYPT_STR_0("\37\134\176\81\25\130\183\114\2\128\173\72\35\183", "\36\107\231\196")] or 0;
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\176\182\147\84\187\165\148", "\231\61\213\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\60\190\56\64\28\191\43\122\31\172\49\90\7\190\41\122\7\174\41\96", "\19\105\205\93")];
				v106 = 5;
			end
		end
	end
	local function v93()
		local v107 = 0;
		local v108;
		while true do
			if ((v107 == 3) or (237 >= 2273)) then
				if ((v14 and v14:Exists() and v14:IsAPlayer() and v14:IsDeadOrGhost() and not v13:CanAttack(v14)) or (2040 <= 703)) then
					if ((3279 <= 3967) and v13:AffectingCombat()) then
						if (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\182\82\252\83\150\67\246", "\58\228\55\158")]:IsReady() or (1988 == 877)) then
							if ((4291 > 1912) and v24(v69.RebirthMouseover, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\166\140\210\39\46\185\61", "\85\212\233\176\78\92\205");
							end
						end
					elseif ((2003 < 2339) and v24(v69.ReviveMouseover, nil, true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\88\93\158\235\92\93", "\130\42\56\232");
					end
				end
				if ((432 == 432) and v41) then
					local v143 = 0;
					while true do
						if ((v143 == 0) or (1145 >= 1253)) then
							v70 = v28.HandleAfflicted(v65.RemoveCorruption, v69.RemoveCorruptionMouseover, 40);
							if ((3418 > 2118) and v70) then
								return v70;
							end
							break;
						end
					end
				end
				if ((3066 <= 3890) and not v13:AffectingCombat() and v29) then
					local v144 = 0;
					while true do
						if ((0 == v144) or (2998 >= 3281)) then
							if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\199\180\54\232\111\57\222\189\33\212\73\51\238", "\95\138\213\68\131\32")]:IsCastable() and (v13:BuffDown(v65.MarkOfTheWild, true) or v28.GroupBuffMissing(v65.MarkOfTheWild))) or (4649 <= 2632)) then
								if (v24(v69.MarkOfTheWildPlayer) or (3860 > 4872)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\39\41\179\72\73\37\46\158\87\126\47\23\182\74\122\46\104\174\76\117", "\22\74\72\193\35");
								end
							end
							if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\14\124\229\74\10\118\246\85", "\56\76\25\132")]:IsCastable() and v13:BuffDown(v65.BearForm) and v13:BuffDown(v65.CatForm) and v13:BuffDown(v65.TravelForm) and not v13:IsMounted() and v64 and v16:IsInRange(20) and v13:CanAttack(v16)) or (3998 == 2298)) then
								if (v24(v65.BearForm) or (8 >= 2739)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\92\196\170\52\240\88\206\185\43\143\81\206\168", "\175\62\161\203\70");
								end
							end
							break;
						end
					end
				end
				if ((2590 == 2590) and v28.TargetIsValid()) then
					local v145 = 0;
					while true do
						if ((v145 == 0) or (82 >= 1870)) then
							if ((2624 < 4557) and not v13:AffectingCombat() and v29) then
								local v149 = 0;
								while true do
									if ((v149 == 0) or (3131 > 3542)) then
										v70 = v89();
										if ((2577 >= 1578) and v70) then
											return v70;
										end
										break;
									end
								end
							end
							if ((4103 <= 4571) and (v13:AffectingCombat() or v29)) then
								local v150 = 0;
								while true do
									if ((v150 == 1) or (1495 == 4787)) then
										if ((v76 and v13:BuffUp(v65.BearForm)) or (310 > 4434)) then
											local v151 = 0;
											while true do
												if ((2168 <= 4360) and (0 == v151)) then
													v70 = v88();
													if ((994 == 994) and v70) then
														return v70;
													end
													break;
												end
											end
										end
										if ((1655 > 401) and v51 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\28\134\23\84\38\205\58\139", "\186\78\227\112\38\73")]:IsReady() and v13:BuffUp(v65.DreamofCenariusBuff)) then
											if ((3063 <= 3426) and (v13:HealthPercentage() > v53) and v13:IsInParty() and not v13:IsInRaid()) then
												if ((1459 > 764) and v14 and v14:Exists() and (v14:HealthPercentage() < 80) and not v14:IsDeadOrGhost() and not v13:CanAttack(v14)) then
													if (v24(v69.RegrowthMouseover) or (641 > 4334)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\238\82\250\71\92\109\232\95\194\88\92\111\239\82\242\67\86\104", "\26\156\55\157\53\51");
													end
												end
											end
										end
										v150 = 2;
									end
									if ((3399 >= 2260) and (v150 == 3)) then
										if ((v31 and v67[LUAOBFUSACTOR_DECRYPT_STR_0("\153\237\37\180\210\73\179", "\60\221\135\68\198\167")]:IsEquippedAndReady() and (v16:DebuffUp(v65.MoonfireDebuff))) or (393 >= 4242)) then
											if ((989 < 4859) and v24(v69.Djaruun, not v73)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\234\183\249\145\87\204\224\130\232\138\78\213\239\175\199\140\68\230\250\181\253\188\71\213\234\184\234\188\68\213\239\176\253\195\79\216\231\179\184\215", "\185\142\221\152\227\34");
											end
										end
										v70 = v91();
										v150 = 4;
									end
									if ((v150 == 0) or (4795 < 949)) then
										if ((3842 == 3842) and not v13:IsCasting() and not v13:IsChanneling()) then
											local v152 = 0;
											local v153;
											while true do
												if ((1747 <= 3601) and (v152 == 2)) then
													v153 = v28.InterruptWithStun(v65.MightyBash, 8);
													if (v153 or (804 > 4359)) then
														return v153;
													end
													v152 = 3;
												end
												if ((4670 >= 3623) and (v152 == 0)) then
													v153 = v28.Interrupt(v65.SkullBash, 10, true);
													if ((2065 < 2544) and v153) then
														return v153;
													end
													v152 = 1;
												end
												if ((1311 <= 3359) and (v152 == 3)) then
													v153 = v28.InterruptWithStun(v65.IncapacitatingRoar, 8);
													if ((2717 <= 3156) and v153) then
														return v153;
													end
													break;
												end
												if ((1081 < 4524) and (v152 == 1)) then
													v153 = v28.Interrupt(v65.SkullBash, 10, true, v14, v69.SkullBashMouseover);
													if ((440 >= 71) and v153) then
														return v153;
													end
													v152 = 2;
												end
											end
										end
										if ((4934 > 2607) and v38 and v32 and v65[LUAOBFUSACTOR_DECRYPT_STR_0("\15\210\204\7\61\57", "\85\92\189\163\115")]:IsReady() and not v13:IsCasting() and not v13:IsChanneling() and v28.UnitHasEnrageBuff(v16)) then
											if (v24(v65.Soothe, not v73) or (1400 > 3116)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\45\165\35\40\44\160", "\88\73\204\80");
											end
										end
										v150 = 1;
									end
									if ((525 < 1662) and (v150 == 4)) then
										if (v70 or (876 > 2550)) then
											return v70;
										end
										break;
									end
									if ((219 <= 2456) and (2 == v150)) then
										if ((v65[LUAOBFUSACTOR_DECRYPT_STR_0("\187\209\26\221\155\88\141\202\17\220", "\48\236\184\118\185\216")]:IsCastable() and not v74 and v50) or (4219 == 1150)) then
											if (v24(v65.WildCharge, not v16:IsInRange(28)) or (2989 <= 222)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\242\180\91\52\240\55\237\188\69\55\202\116\232\188\94\62", "\84\133\221\55\80\175");
											end
										end
										if ((2258 > 1241) and v31) then
											local v154 = 0;
											while true do
												if ((41 < 4259) and (v154 == 0)) then
													v70 = v87();
													if (v70 or (1930 < 56)) then
														return v70;
													end
													break;
												end
											end
										end
										v150 = 3;
									end
								end
							end
							v145 = 1;
						end
						if ((3333 == 3333) and (v145 == 1)) then
							if (v24(v65.Pool) or (2225 == 20)) then
								return "Wait/Pool Resources";
							end
							break;
						end
					end
				end
				break;
			end
			if ((v107 == 2) or (872 >= 3092)) then
				v71 = 5 + v108;
				v72 = 8 + v108;
				if ((4404 >= 3252) and v30) then
					local v146 = 0;
					while true do
						if ((1107 > 796) and (v146 == 0)) then
							v79 = v13:GetEnemiesInMeleeRange(v72);
							v80 = #v79;
							break;
						end
					end
				else
					local v147 = 0;
					while true do
						if ((959 == 959) and (v147 == 0)) then
							v79 = {};
							v80 = 1;
							break;
						end
					end
				end
				if (v28.TargetIsValid() or v13:AffectingCombat() or (245 >= 2204)) then
					local v148 = 0;
					while true do
						if ((3162 >= 2069) and (v148 == 2)) then
							v73 = v16:IsInRange(v71);
							v74 = v16:IsInRange(v72);
							break;
						end
						if ((v148 == 1) or (306 > 3081)) then
							v77 = false;
							if ((not v86() and (((v13:Rage() >= (v65[LUAOBFUSACTOR_DECRYPT_STR_0("\60\167\184\162", "\115\113\198\205\206\86")]:Cost() + 20)) and not v76) or (v13:RageDeficit() <= 10) or not v49)) or (3513 < 2706)) then
								v77 = true;
							end
							v148 = 2;
						end
						if ((2978 < 3639) and (v148 == 0)) then
							v75 = v13:ActiveMitigationNeeded();
							v76 = v13:IsTankingAoE(8) or v13:IsTanking(v16);
							v148 = 1;
						end
					end
				end
				v107 = 3;
			end
			if ((3682 >= 2888) and (v107 == 0)) then
				v92();
				v29 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\223\202\182\230\194\238\214", "\174\139\165\209\129")][LUAOBFUSACTOR_DECRYPT_STR_0("\172\188\225", "\24\195\211\130\161\166\99\16")];
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\114\12\238\43\95\19\85", "\118\38\99\137\76\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\252\41\0", "\64\157\70\101\114\105")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\116\167\160\228\28\69\187", "\112\32\200\199\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\47\84\79", "\66\76\48\60\216\163\203")];
				v107 = 1;
			end
			if ((149 < 479) and (v107 == 1)) then
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\137\126\244\83\203\55", "\68\218\230\25\147\63\174")][LUAOBFUSACTOR_DECRYPT_STR_0("\169\35\64\92\179\161", "\214\205\74\51\44")];
				if ((1020 >= 567) and v13:IsDeadOrGhost()) then
					return;
				end
				if (v13:BuffUp(v65.TravelForm) or v13:IsMounted() or (733 > 2469)) then
					return;
				end
				v108 = v27(1.5 * v65[LUAOBFUSACTOR_DECRYPT_STR_0("\219\95\246\238\118\246\101\236\250\123\239\73\236\255\114", "\23\154\44\130\156")]:TalentRank());
				v107 = 2;
			end
		end
	end
	local function v94()
		local v109 = 0;
		while true do
			if ((2497 == 2497) and (v109 == 0)) then
				v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\127\208\86\232\71\58\246\86\133\115\232\86\58\243\24\215\88\238\66\39\254\87\203\23\248\90\115\210\72\204\84\186\97\60\248\85\238", "\151\56\165\55\154\35\83"));
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\135\86\4\252\164\74\4\224\224\103\23\251\169\71\69\214\224\85\69\191\240\13\87\160\240\19\69\204\185\3\39\225\175\78\46", "\142\192\35\101"));
				break;
			end
		end
	end
	v20.SetAPL(104, v93, v94);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\243\101\32\187\216\168\190\3\223\113\22\132\242\141\190\18\223\116\39\237\235\153\173", "\118\182\21\73\195\135\236\204")]();

