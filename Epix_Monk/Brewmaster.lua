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
		if ((2244 == 2244) and (v5 == 0)) then
			v6 = v0[v4];
			if (not v6 or (3546 <= 2809)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((4904 > 2166) and (v5 == 1)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\150\200\16\218\252\249\55\227\172\202\31\194\215\222\55\168\183\210\31", "\126\177\163\187\69\134\219\167")] = function(...)
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
	local v26 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\152\214\79\80\17\181\202", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\216\91\96\103\120\253\226", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\252\39", "\167\214\137\74\171\120\206\83")];
	local v27 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\168\255\63\80\247\169\152", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\0\188\57\30\25\183\46", "\75\103\118\217")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\91\127\24", "\126\167\52\16\116\217")];
	local v28 = GetTime;
	local v29 = UnitHealthMax;
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
	local v62 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\229\33\46\139", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\37\252\160\217\10\239\182\218\2\252", "\174\103\142\197")];
	local v63 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\123\39\81\51", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\214\235\75\217\197\253\72\209\214", "\60\180\164\142")];
	local v64 = v23[LUAOBFUSACTOR_DECRYPT_STR_0("\117\81\11\34", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\154\251\222\211\181\232\200\208\189\251", "\164\216\137\187")];
	local v65 = {v63[LUAOBFUSACTOR_DECRYPT_STR_0("\243\234\54\183\178\246\10\192\214\36\168\188\242\14\240\233\41", "\107\178\134\81\210\198\158")]:ID(),v63[LUAOBFUSACTOR_DECRYPT_STR_0("\28\4\131\212\191\45\0", "\202\88\110\226\166")]:ID()};
	local v66;
	local v67;
	local v68;
	local v69;
	local v70 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\224\0\143\250\197\205\28", "\170\163\111\226\151")][LUAOBFUSACTOR_DECRYPT_STR_0("\52\38\183\42\87\56\39\20", "\73\113\80\210\88\46\87")];
	local v71 = v21[LUAOBFUSACTOR_DECRYPT_STR_0("\162\35\192\31\232\143\63", "\135\225\76\173\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\55\226\182\187", "\199\122\141\216\208\204\221")];
	local function v72()
		v70[LUAOBFUSACTOR_DECRYPT_STR_0("\137\212\3\224\125\250\161\220\18\252\125\210\168\223\5\246\126\229", "\150\205\189\112\144\24")] = v25.MergeTable(v70.DispellablePoisonDebuffs, v70.DispellableDiseaseDebuffs);
	end
	v10:RegisterForEvent(function()
		v72();
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\4\167\139\101\50\173\46\32\9\165\134\105\54\183\34\32\0\167\150\109\40\161\43\49\17\173\144\98\59\171\57\49\11\163\154\104", "\112\69\228\223\44\100\232\113"));
	local v73 = GetInventoryItemLink(LUAOBFUSACTOR_DECRYPT_STR_0("\196\19\6\202\179\110", "\230\180\127\103\179\214\28"), 16) or "";
	local v74 = IsEquippedItemType(LUAOBFUSACTOR_DECRYPT_STR_0("\184\18\80\11\204\64\238\136", "\128\236\101\63\38\132\33"));
	v10:RegisterForEvent(function()
		local v83 = 0;
		while true do
			if ((109 >= 90) and (v83 == 0)) then
				v73 = GetInventoryItemLink(LUAOBFUSACTOR_DECRYPT_STR_0("\188\165\16\93\179\249", "\175\204\201\113\36\214\139"), 16) or "";
				v74 = IsEquippedItemType(LUAOBFUSACTOR_DECRYPT_STR_0("\115\219\58\145\44\70\194\49", "\100\39\172\85\188"));
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\157\84\152\185\22\159\71\156\177\6\132\72\148\165\29\153\71\154\168\18\131\95\156\164", "\83\205\24\217\224"));
	local function v75()
		local v84 = 0;
		while true do
			if ((4978 > 2905) and (v84 == 0)) then
				ShouldReturn = v70.HandleTopTrinket(v65, v13:BuffUp(v62.BonedustBrewBuff) or v13:BuffUp(v62.WeaponsOfOrder) or v13:BloodlustUp(), 40, nil);
				if (ShouldReturn or (3026 <= 2280)) then
					return ShouldReturn;
				end
				v84 = 1;
			end
			if ((1 == v84) or (1653 <= 1108)) then
				ShouldReturn = v70.HandleBottomTrinket(v65, v13:BuffUp(v62.BonedustBrewBuff) or v13:BuffUp(v62.WeaponsOfOrder) or v13:BloodlustUp(), 40, nil);
				if ((2909 > 2609) and ShouldReturn) then
					return ShouldReturn;
				end
				break;
			end
		end
	end
	local function v76()
		local v85 = 0;
		local v86;
		local v87;
		local v88;
		while true do
			if ((757 > 194) and (v85 == 0)) then
				v86 = v13:StaggerFull() or 0;
				if ((v86 == 0) or (31 >= 1398)) then
					return false;
				end
				v85 = 1;
			end
			if ((3196 <= 4872) and (v85 == 1)) then
				v87 = 0;
				v88 = nil;
				v85 = 2;
			end
			if ((3326 == 3326) and (v85 == 2)) then
				if ((1433 <= 3878) and v13:BuffUp(v62.LightStagger)) then
					v88 = v62[LUAOBFUSACTOR_DECRYPT_STR_0("\202\204\202\53\242\246\217\60\225\194\200\47", "\93\134\165\173")];
				elseif (v13:BuffUp(v62.ModerateStagger) or (1583 == 1735)) then
					v88 = v62[LUAOBFUSACTOR_DECRYPT_STR_0("\147\253\197\199\40\207\166\123\141\230\192\197\61\203\160", "\30\222\146\161\162\90\174\210")];
				elseif (v13:BuffUp(v62.HeavyStagger) or (2981 == 2350)) then
					v88 = v62[LUAOBFUSACTOR_DECRYPT_STR_0("\205\75\113\28\252\125\100\11\226\73\117\24", "\106\133\46\16")];
				end
				if (v88 or (4466 <= 493)) then
					local v116 = 0;
					local v117;
					while true do
						if ((v116 == 0) or (2547 <= 1987)) then
							v117 = v13:DebuffInfo(v88, false, true);
							v87 = v117[LUAOBFUSACTOR_DECRYPT_STR_0("\72\47\122\242\78\83", "\32\56\64\19\156\58")][2];
							break;
						end
					end
				end
				v85 = 3;
			end
			if ((2961 > 2740) and (v85 == 3)) then
				if ((3696 >= 3612) and (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\106\221\247\95\92\235\137\84\207\199\68\95\229", "\224\58\168\133\54\58\146")]:ChargesFractional() >= 1.8) and (v13:DebuffUp(v62.HeavyStagger) or v13:DebuffUp(v62.ModerateStagger) or v13:DebuffUp(v62.LightStagger))) then
					return true;
				end
				return false;
			end
		end
	end
	local function v77()
		local v89 = 0;
		while true do
			if ((v89 == 1) or (2970 == 1878)) then
				if (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\141\84\58\12\46\39\171", "\81\206\60\83\91\79")]:IsReady() or (3693 < 1977)) then
					if (v24(v62.ChiWave, not v14:IsInMeleeRange(8), true) or (930 > 2101)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\77\163\217\77\56\194\91\161\14\187\194\119\44\204\64\166\79\191\144\35\127", "\196\46\203\176\18\79\163\45");
					end
				end
				if ((4153 > 3086) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\138\55\109\22\45\245\232\146\35\122\27\19\242\225\188", "\143\216\66\30\126\68\155")]:IsReady()) then
					if (v24(v62.RushingJadeWind, not v14:IsInMeleeRange(8)) or (4654 <= 4050)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\184\221\30\195\204\173\208\222\160\201\9\206\250\180\222\239\174\136\29\217\192\160\216\236\168\201\25\139\145", "\129\202\168\109\171\165\195\183");
					end
				end
				v89 = 2;
			end
			if ((v89 == 0) or (2602 < 1496)) then
				if ((v60 == LUAOBFUSACTOR_DECRYPT_STR_0("\118\121\104", "\107\57\54\43\157\21\230\231")) or (v60 == LUAOBFUSACTOR_DECRYPT_STR_0("\249\132\5\253", "\175\187\235\113\149\217\188")) or (1020 > 2288)) then
					if ((328 == 328) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\31\163\128\95\235", "\24\92\207\225\44\131\25")]:IsReady() and not v14:IsInRange(8) and v14:IsInRange(30)) then
						if ((1511 < 3808) and v24(v62.Clash)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\72\223\185\95\19\61\91\193\189\79\20\112\73\210\172\12\67", "\29\43\179\216\44\123");
						end
					end
				end
				if ((v62[LUAOBFUSACTOR_DECRYPT_STR_0("\158\209\41\110\168\203\51\88", "\44\221\185\64")]:IsReady() and (CovenantID ~= 3)) or (2510 > 4919)) then
					if ((4763 == 4763) and v24(v62.ChiBurst, not v14:IsInMeleeRange(8), true)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\2\239\65\96\113\20\245\91\75\51\17\245\77\92\124\12\229\73\75\51\87", "\19\97\135\40\63");
					end
				end
				v89 = 1;
			end
			if ((4137 > 1848) and (v89 == 2)) then
				if ((2436 <= 3134) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\9\93\48\235\211\21\245\42", "\134\66\56\87\184\190\116")]:IsReady()) then
					if ((3723 == 3723) and v24(v62.KegSmash, not v14:IsInRange(40))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\52\14\132\10\230\32\38\52\113\25\169\28\232\46\56\62\48\29\251\65", "\85\92\81\105\219\121\139\65");
					end
				end
				break;
			end
		end
	end
	local function v78()
		local v90 = 0;
		while true do
			if ((4 == v90) or (4046 >= 4316)) then
				if ((v34 and (v13:HealthPercentage() <= v36)) or (2008 < 1929)) then
					if ((2384 > 1775) and (v35 == LUAOBFUSACTOR_DECRYPT_STR_0("\151\175\37\12\22\23\207\88\171\173\99\54\22\5\203\88\171\173\99\46\28\16\206\94\171", "\49\197\202\67\126\115\100\167"))) then
						if (v63[LUAOBFUSACTOR_DECRYPT_STR_0("\5\94\217\59\133\69\86\62\85\216\1\133\87\82\62\85\216\25\143\66\87\56\85", "\62\87\59\191\73\224\54")]:IsReady() or (4543 <= 4376)) then
							if ((728 == 728) and v24(v64.RefreshingHealingPotion, nil, nil, true)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\245\7\252\219\226\17\242\192\233\5\186\193\226\3\246\192\233\5\186\217\232\22\243\198\233\66\254\204\225\7\244\218\238\20\255\137\179", "\169\135\98\154");
							end
						end
					end
				end
				break;
			end
			if ((v90 == 1) or (1076 > 4671)) then
				if ((1851 >= 378) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\126\54\164\83\65\115\47\166\91", "\45\59\78\212\54")]:IsCastable() and (v13:HealthPercentage() <= 80)) then
					if (v24(v62.ExpelHarm) or (1948 >= 3476)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\53\78\147\142\138\110\133\241\2\91", "\144\112\54\227\235\230\78\205");
					end
				end
				if ((4794 >= 833) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\151\41\2\236\213\85\155\41\29\241", "\59\211\72\111\156\176")]:IsCastable() and v13:BuffDown(v62.FortifyingBrewBuff) and (v13:HealthPercentage() <= 35)) then
					if ((4090 == 4090) and v24(v62.DampenHarm)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\106\134\238\61\75\137\163\5\79\149\238", "\77\46\231\131");
					end
				end
				v90 = 2;
			end
			if ((v90 == 3) or (3758 == 2498)) then
				if ((v62[LUAOBFUSACTOR_DECRYPT_STR_0("\116\179\199\189\69\169\196\150\81\189\200\184", "\219\48\218\161")]:IsCastable() and v58 and (v13:HealthPercentage() <= v59)) or (2673 < 1575)) then
					if (v24(v62.DiffuseMagic) or (3721 <= 1455)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\192\120\122\79\206\92\229\164\92\125\78\210\76", "\128\132\17\28\41\187\47");
					end
				end
				if ((934 < 2270) and v63[LUAOBFUSACTOR_DECRYPT_STR_0("\41\55\7\54\73\9\33\18\53\83\4", "\61\97\82\102\90")]:IsReady() and v37 and (v13:HealthPercentage() <= v38)) then
					if (v24(v64.Healthstone, nil, nil, true) or (1612 == 1255)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\164\43\170\71\211\95\13\29\163\32\174\11\195\82\24\12\162\61\162\93\194\23\77", "\105\204\78\203\43\167\55\126");
					end
				end
				v90 = 4;
			end
			if ((v90 == 2) or (4352 < 4206)) then
				if ((v62[LUAOBFUSACTOR_DECRYPT_STR_0("\156\91\164\84\179\82\175\73\180\83\148\82\191\67", "\32\218\52\214")]:IsCastable() and v50 and v13:BuffDown(v62.DampenHarmBuff) and (v13:HealthPercentage() <= v51)) or (2860 <= 181)) then
					if ((3222 >= 1527) and v24(v62.FortifyingBrew)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\104\24\35\188\248\182\92\83\64\16\113\138\227\181\82", "\58\46\119\81\200\145\208\37");
					end
				end
				if ((1505 <= 2121) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\3\137\49\160\160\179\49\14\128\57\180\160\175", "\86\75\236\80\204\201\221")]:IsCastable() and v52 and (v13:HealthPercentage() <= v53)) then
					if ((744 == 744) and v24(v62.HealingElixir)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\68\118\137\247\133\117\1\82\137\247\147\123\83\55\167\236\142\101", "\235\18\33\23\229\158");
					end
				end
				v90 = 3;
			end
			if ((v90 == 0) or (1979 >= 2836)) then
				if ((1833 <= 2668) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\222\182\92\64\111\203\244\178\92\103\110\218\234", "\191\157\211\48\37\28")]:IsCastable() and v49 and v13:BuffDown(v62.BlackoutComboBuff) and (v13:IncomingDamageTaken(1999) > ((v29(LUAOBFUSACTOR_DECRYPT_STR_0("\207\19\245\5\63\205", "\90\191\127\148\124")) * 0.1) + v13:StaggerLastTickDamage(4))) and (v13:BuffStack(v62.ElusiveBrawlerBuff) < 2)) then
					if ((3686 == 3686) and v24(v62.CelestialBrew)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\130\34\18\107\147\39\22\116\199\12\5\125\144", "\119\24\231\78");
					end
				end
				if ((3467 > 477) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\178\56\183\67\218\89\24\140\42\135\88\217\87", "\113\226\77\197\42\188\32")]:IsCastable() and v76() and v47 and (v13:HealthPercentage() <= v48)) then
					if (v24(v62.PurifyingBrew) or (3288 >= 3541)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\3\230\188\60\15\253\187\61\86\214\167\63\1", "\213\90\118\148");
					end
				end
				v90 = 1;
			end
		end
	end
	local function v79()
		local v91 = 0;
		while true do
			if ((v91 == 3) or (3557 == 4540)) then
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\133\176\242\196\191\187\225\195", "\176\214\213\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\193\190\179\246\164\87\90\255\130\174\246\186\83\78", "\57\148\205\214\180\200\54")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\33\248\33\32\127\28\250\38", "\22\114\157\85\84")][LUAOBFUSACTOR_DECRYPT_STR_0("\241\216\22\244\72\228\161\194\210\26\202\90\212\186\193\220", "\200\164\171\115\164\61\150")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\141\241\23\81\138\176\243\16", "\227\222\148\99\37")][LUAOBFUSACTOR_DECRYPT_STR_0("\3\71\64\255\255\42\91\92\241\219\33\87\69\222\201", "\153\83\50\50\150")] or 0;
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\110\115\103\8\122\165\74\78", "\45\61\22\19\124\19\203")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\1\8\214\7\124\188\210\6\4\244\14\82\171\196\5", "\217\161\114\109\149\98\16")];
				v91 = 4;
			end
			if ((v91 == 5) or (261 > 1267)) then
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\40\232\146\69\228\51\62\8", "\89\123\141\230\49\141\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\105\230\0\31\78\250\127\241\39\21\77\198\98\247\11\21", "\42\147\17\150\108\112")] or "";
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\60\163\57\107\238\230\8\181", "\136\111\198\77\31\135")][LUAOBFUSACTOR_DECRYPT_STR_0("\55\26\162\120\180\241\13\168\13", "\201\98\105\199\54\221\132\119")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\9\151\53\11\59\171\170", "\204\217\108\227\65\98\85")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\214\248\232\35\206\105\203\252\241\41\244\87\196\240\247\31\212\95\215\224\224\25\211\95\196\240", "\160\62\163\149\133\76")] or "";
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\165\25\59\202\216\167\30", "\163\182\192\109\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\22\41\14\197\241\33\53\20\226\231\49\49\53\211\244\51\35", "\149\84\70\96\160")] or "";
				v91 = 6;
			end
			if ((1272 < 3858) and (v91 == 6)) then
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\3\25\249\49\8\10\254", "\141\88\102\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\134\64\207\84\19\59\83\212\160\86\231\113\29\52\86", "\161\211\51\170\16\122\93\53")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\200\171\166\60\242\160\181\59", "\72\155\206\210")][LUAOBFUSACTOR_DECRYPT_STR_0("\98\115\82\8\38\85\127\121\15\52\79\121\124\62", "\83\38\26\52\110")] or 0;
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\107\18\51\82\81\25\32\85", "\38\56\119\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\227\89\197\45\99\224\238\95\211", "\54\147\143\56\182\69")] or "";
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\132\235\93\214\216\134\236", "\191\182\225\159\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\30\1\45\113\129\134\208\62\7\38", "\162\75\114\72\53\235\231")];
				break;
			end
			if ((3664 == 3664) and (v91 == 0)) then
				v34 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\248\114\48\64\244\61\207\216", "\168\171\23\68\52\157\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\193\98\240\133\32\44\139\253\127\242\157\42\57\142\251\127", "\231\148\17\149\205\69\77")];
				v35 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\162\211\239\94\241\135\180", "\159\224\199\167\155\55")][LUAOBFUSACTOR_DECRYPT_STR_0("\223\246\61\222\254\253\59\226\248\231\53\221\249\221\61\223\242", "\178\151\147\92")] or "";
				v36 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\191\248\88\38\27\66\125\159", "\26\236\157\44\82\114\44")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\43\212\87\35\32\210\107\37\58\220\84\36\6\229", "\59\74\78\181")] or 0;
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\22\212\78\78\186\43\214\73", "\211\69\177\58\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\130\246\124\221\236\202\187\241\113\230\253\196\185\224", "\171\215\133\25\149\137")];
				v91 = 1;
			end
			if ((1941 >= 450) and (1 == v91)) then
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\210\205\38\238\230\62\251\81", "\34\129\168\82\154\143\80\156")][LUAOBFUSACTOR_DECRYPT_STR_0("\173\183\50\7\92\70\154\145\189\61\14\96\126", "\233\229\210\83\107\40\46")] or 0;
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\242\71\38\194\12\207\69\33", "\101\161\34\82\182")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\4\74\238\222\238\166\43\234\24\95\248\200", "\78\136\109\57\158\187\130\226")];
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\13\58\237\229\55\49\254\226", "\145\94\95\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\196\7\197\75\187\223\216\18\211\93", "\215\157\173\116\181\46")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\6\177\159\230\211\59\179\152", "\186\85\212\235\146")][LUAOBFUSACTOR_DECRYPT_STR_0("\234\128\24\250\53\235\121\196\135\26\247\58\250\93\198", "\56\162\225\118\158\89\142")];
				v91 = 2;
			end
			if ((v91 == 4) or (4646 < 324)) then
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\33\37\44\104\181\122\21\51", "\20\114\64\88\28\220")][LUAOBFUSACTOR_DECRYPT_STR_0("\4\18\215\146\247\194\169\56\7\203\189\246\215\159\35\4\197", "\221\81\97\178\212\152\176")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\254\226\9\239\19\195\224\14", "\122\173\135\125\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\162\206\18\173\54\55\209\141\207\7\155\45\52\223\172\241", "\168\228\161\96\217\95\81")] or 0;
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\232\212\58\72\38\89\220\194", "\55\187\177\78\60\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\24\221\90\195\67\206\140\36\192\88\206\74\198\152\36\220", "\224\77\174\63\139\38\175")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\183\68\76\58\141\79\95\61", "\78\228\33\56")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\123\179\15\140\192\121\151\15\140\214\119\160\43\181", "\229\174\30\210\99")] or 0;
				v91 = 5;
			end
			if ((3833 == 3833) and (2 == v91)) then
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\111\0\212\187\43\214\91\22", "\184\60\101\160\207\66")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\131\114\184\61\135\85\178\50\141\110\172\62\144\121\189\61", "\220\81\226\28")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\32\208\150\239\227\201\20\198", "\167\115\181\226\155\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\203\44\243\89\105\99\211\242\54\208\85\111\121\245\246\55\233", "\166\130\66\135\60\27\17")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\119\79\218\97\57\74\77\221", "\80\36\42\174\21")][LUAOBFUSACTOR_DECRYPT_STR_0("\103\30\35\127\92\2\34\106\90\63\57\118\87\39\63\115\90\21\59\115\93\4", "\26\46\112\87")];
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\38\191\96\182\177\66\167", "\212\217\67\203\20\223\223\37")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\131\188\215\168\159\189\194\174\185\160\192\191\158\160\221\182\137", "\178\218\237\200")] or 0;
				v91 = 3;
			end
		end
	end
	local function v80()
		local v92 = 0;
		while true do
			if ((0 == v92) or (1240 > 3370)) then
				v79();
				v30 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\51\67\229\95\7\159", "\98\236\92\36\130\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\171\22\15", "\80\196\121\108\218\37\200\213")];
				v31 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\52\124\5\120\71\11\153", "\234\96\19\98\31\43\110")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\16\87", "\235\102\127\50\167\204\18")];
				v32 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\100\174\242\36\72\43\67", "\78\48\193\149\67\36")][LUAOBFUSACTOR_DECRYPT_STR_0("\51\26\147", "\33\80\126\224\120")];
				v92 = 1;
			end
			if ((3 == v92) or (2481 == 4682)) then
				if ((4727 >= 208) and v13:AffectingCombat() and v39) then
					if ((280 < 3851) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\98\73\213\172\238", "\168\38\44\161\195\150")]:IsReady() and v33) then
						local v120 = 0;
						while true do
							if ((v120 == 0) or (3007 > 3194)) then
								ShouldReturn = v70.FocusUnit(true, nil, nil, nil);
								if (ShouldReturn or (2136 >= 2946)) then
									return ShouldReturn;
								end
								break;
							end
						end
					end
				end
				if ((2165 <= 2521) and v70.TargetIsValid()) then
					local v118 = 0;
					while true do
						if ((2861 > 661) and (v118 == 0)) then
							if ((4525 > 4519) and not v13:AffectingCombat() and v30) then
								local v123 = 0;
								local v124;
								while true do
									if ((3178 > 972) and (v123 == 0)) then
										v124 = v77();
										if ((4766 == 4766) and v124) then
											return v124;
										end
										break;
									end
								end
							end
							if (v13:AffectingCombat() or v30 or (2745 > 3128)) then
								local v125 = 0;
								while true do
									if ((v125 == 1) or (1144 >= 4606)) then
										if ((3338 >= 277) and v15) then
											if ((2610 > 2560) and v39 and v33 and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\164\249\150\121\40", "\118\224\156\226\22\80\136\214")]:IsReady() and v70.DispellableFriendlyUnit()) then
												if (v24(v64.DetoxFocus) or (1194 > 3083)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\70\235\77\143\90\174\84\129\75\224", "\224\34\142\57");
												end
											end
										end
										if ((916 >= 747) and v32) then
											local v126 = 0;
											while true do
												if ((v126 == 3) or (2444 > 2954)) then
													if ((2892 < 3514) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\221\126\90\179\50\203\239\235\83\70\179\33", "\156\159\17\52\214\86\190")]:IsCastable() and (v14:DebuffDown(v62.BonedustBrew))) then
														if ((533 == 533) and (v57 == LUAOBFUSACTOR_DECRYPT_STR_0("\158\227\188\165\171\253", "\220\206\143\221"))) then
															if ((595 <= 3413) and v24(v64.BonedustBrewPlayer, not v14:IsInMeleeRange(8))) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\132\114\35\18\220\217\193\146\66\47\5\221\219\146\212\43", "\178\230\29\77\119\184\172");
															end
														elseif ((3078 >= 2591) and (v57 == LUAOBFUSACTOR_DECRYPT_STR_0("\208\176\15\22\110\184\192\176\14\30\101\184\214\171\24\8\120\234", "\152\149\222\106\123\23"))) then
															if ((3199 < 4030) and v16:Exists() and v13:CanAttack(v16) and (v16:DebuffDown(v62.BonedustBrew))) then
																if ((777 < 2078) and v24(v64.BonedustBrewCursor)) then
																	return LUAOBFUSACTOR_DECRYPT_STR_0("\223\41\248\70\177\200\53\226\124\183\207\35\225\3\231\139", "\213\189\70\150\35");
																end
															end
														elseif ((1696 <= 2282) and (v57 == LUAOBFUSACTOR_DECRYPT_STR_0("\108\64\102\27\64\71", "\104\47\53\20"))) then
															if (v24(v64.BonedustBrewCursor) or (1761 >= 2462)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\161\67\143\25\184\26\176\88\190\30\174\10\180\12\211\74", "\111\195\44\225\124\220");
															end
														elseif ((4551 > 2328) and (v57 == LUAOBFUSACTOR_DECRYPT_STR_0("\251\73\14\117\162\185\213\71\20\122\164\165", "\203\184\38\96\19\203"))) then
															if ((3825 >= 467) and v24(v62.BonedustBrew)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\59\124\119\68\202\44\96\109\126\204\43\118\110\1\156\111", "\174\89\19\25\33");
															end
														end
													end
													break;
												end
												if ((v126 == 2) or (2890 == 557)) then
													if (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\20\72\244\31\117\250\36\64\240\27\96", "\174\86\41\147\112\19")]:IsCastable() or (4770 == 2904)) then
														if (v24(v62.BagofTricks, not v14:IsInRange(40)) or (3903 == 4536)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\89\1\138\52\42\9\46\191\73\9\142\0\54\79\28\170\82\14\205\90\115", "\203\59\96\237\107\69\111\113");
														end
													end
													if ((4093 <= 4845) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\13\24\186\238\58\245\249\45\3\182\224\62\196\223\33\52\160\224\50\251\248\60", "\183\68\118\204\129\81\144")]:IsCastable() and v10.BossFilteredFightRemains(">", 25) and v55) then
														if ((1569 <= 3647) and v24(v62.InvokeNiuzaoTheBlackOx, not v14:IsInRange(40))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\7\163\102\235\0\135\49\163\121\241\17\131\1\146\100\236\14\189\12\161\113\231\0\189\1\181\48\233\10\139\0\237\33\188", "\226\110\205\16\132\107");
														end
													end
													if ((v62[LUAOBFUSACTOR_DECRYPT_STR_0("\223\204\245\218\73\228\197\196\220\64\255\203", "\33\139\163\128\185")]:IsCastable() and (v14:HealthPercentage() <= 15)) or (4046 >= 4927)) then
														if ((4623 >= 2787) and v24(v62.TouchofDeath, not v14:IsInMeleeRange(5))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\67\87\17\221\95\103\11\216\104\92\1\223\67\80\68\211\86\81\10\158\5\8", "\190\55\56\100");
														end
													end
													if ((2234 >= 1230) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\97\170\61\14\28\237\224\121\169\19\12\23\230\225", "\147\54\207\92\126\115\131")]:IsCastable()) then
														if (v24(v62.WeaponsOfOrder) or (343 == 1786)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\26\52\52\109\2\112\30\14\58\123\50\113\31\53\48\111\77\115\12\56\59\61\95\44", "\30\109\81\85\29\109");
														end
													end
													v126 = 3;
												end
												if ((2570 > 2409) and (0 == v126)) then
													if (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\237\178\200\208\124\255\106\6\215\179\192\233\122\246\88\28\237\179\196\201\102\244", "\110\190\199\165\189\19\145\61")]:IsCastable() or (2609 >= 3234)) then
														if ((v56 == LUAOBFUSACTOR_DECRYPT_STR_0("\234\231\118\241\142\213", "\167\186\139\23\136\235")) or (3033 >= 4031)) then
															if (v24(v64.SummonWhiteTigerStatuePlayer, not v14:IsInMeleeRange(8)) or (1401 == 4668)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\9\160\133\0\21\187\183\26\18\188\156\8\37\161\129\10\31\167\183\30\14\180\156\24\31\245\220", "\109\122\213\232");
															end
														elseif ((2776 >= 1321) and (v56 == LUAOBFUSACTOR_DECRYPT_STR_0("\205\226\176\35\225\229", "\80\142\151\194"))) then
															if (v24(v64.SummonWhiteTigerStatueCursor) or (487 > 2303)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\16\211\122\65\12\200\72\91\11\207\99\73\60\210\126\75\6\212\72\95\23\199\99\89\6\134\35", "\44\99\166\23");
															end
														end
													end
													if ((v32 and v61 and v63[LUAOBFUSACTOR_DECRYPT_STR_0("\88\253\40\36\38\177\114", "\196\28\151\73\86\83")]:IsEquippedAndReady()) or (4503 == 3462)) then
														if ((553 <= 1543) and v24(v64.Djaruun, not v14:IsInMeleeRange(8))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\247\9\40\2\151\77\22\73\227\10\37\28\131\74\39\121\245\60\61\24\135\103\29\122\247\6\59\47\132\84\25\123\246\67\36\17\139\86\88\34", "\22\147\99\73\112\226\56\120");
														end
													end
													if ((2015 == 2015) and v32) then
														local v134 = 0;
														local v135;
														while true do
															if ((v134 == 0) or (4241 <= 2332)) then
																v135 = v75();
																if (v135 or (2364 < 1157)) then
																	return v135;
																end
																break;
															end
														end
													end
													if (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\154\121\237\250\137\158\96\240\236", "\237\216\21\130\149")]:IsCastable() or (1167 > 1278)) then
														if (v24(v62.BloodFury) or (1145 <= 1082)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\128\66\80\80\180\246\88\151\92\70\31\189\200\87\140\14\9", "\62\226\46\63\63\208\169");
														end
													end
													v126 = 1;
												end
												if ((1 == v126) or (3105 == 4881)) then
													if (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\199\28\71\144\26\31\36\87\235\30", "\62\133\121\53\227\127\109\79")]:IsCastable() or (1887 > 4878)) then
														if (v24(v62.Berserking) or (4087 > 4116)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\18\17\32\230\211\188\169\25\26\53\181\219\175\171\30\84\106", "\194\112\116\82\149\182\206");
														end
													end
													if ((1106 <= 1266) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\21\161\75\16\212\241\36\44\172\75\21\197\236\26", "\110\89\200\44\120\160\130")]:IsCastable()) then
														if ((3155 < 4650) and v24(v62.LightsJudgment, not v14:IsInRange(40))) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\167\202\76\78\87\89\4\71\190\199\76\75\70\68\47\13\166\194\66\72\3\27\107", "\45\203\163\43\38\35\42\91");
														end
													end
													if ((3774 >= 1839) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\244\140\206\38\133\165\91\221\129", "\52\178\229\188\67\231\201")]:IsCastable()) then
														if ((2811 == 2811) and v24(v62.Fireblood)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\39\72\66\1\245\80\44\46\69\16\9\246\85\45\97\16\2", "\67\65\33\48\100\151\60");
														end
													end
													if ((2146 > 1122) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\254\233\173\221\224\203\245\175\212\208\222\235\162", "\147\191\135\206\184")]:IsCastable()) then
														if (v24(v62.AncestralCall) or (56 == 3616)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\133\38\165\196\203\71\160\133\36\153\194\217\95\190\196\37\167\200\214\19\227\208", "\210\228\72\198\161\184\51");
														end
													end
													v126 = 2;
												end
											end
										end
										if ((v32 and v46) or (2421 < 622)) then
											local v127 = 0;
											while true do
												if ((1009 <= 1130) and (v127 == 0)) then
													if ((2758 < 2980) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\13\30\83\77\252\168\19\13\0\87\89", "\107\79\114\50\46\151\231")]:IsCastable() and (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\9\179\167\32\140\32\190\206\62\132\167\44\157", "\160\89\198\213\73\234\89\215")]:ChargesFractional() < 0.5)) then
														if (v24(v62.BlackOxBrew) or (86 >= 3626)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\74\125\181\253\206\119\126\172\193\199\90\116\163\190\200\73\120\186\190\151\16", "\165\40\17\212\158");
														end
													end
													if ((2395 == 2395) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\199\213\9\48\45\202\193\42\33\35\242", "\70\133\185\104\83")]:IsCastable() and ((v13:Energy() + (v13:EnergyRegen() * v62[LUAOBFUSACTOR_DECRYPT_STR_0("\47\64\67\25\196\5\86\76", "\169\100\37\36\74")]:CooldownRemains())) < 40) and v13:BuffDown(v62.BlackoutComboBuff) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\43\130\165\99\13\134\177\88", "\48\96\231\194")]:CooldownUp()) then
														if ((3780 > 2709) and v24(v62.BlackOxBrew)) then
															return LUAOBFUSACTOR_DECRYPT_STR_0("\202\86\15\46\18\231\160\155\247\88\28\40\14\152\162\130\193\84\78\126\73", "\227\168\58\110\77\121\184\207");
														end
													end
													break;
												end
											end
										end
										if ((v62[LUAOBFUSACTOR_DECRYPT_STR_0("\80\57\184\115\188\218\98\173", "\197\27\92\223\32\209\187\17")]:IsCastable() and (v68 >= 2)) or (237 >= 2273)) then
											if (v24(v62.KegSmash, not v14:IsSpellInRange(v62.KegSmash)) or (2040 <= 703)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\8\90\196\196\16\82\194\232\11\31\206\250\10\81\131\168\87", "\155\99\63\163");
											end
										end
										v125 = 2;
									end
									if ((3279 <= 3967) and (v125 == 0)) then
										if ((not v13:IsCasting() and not v13:IsChanneling()) or (1988 == 877)) then
											local v128 = 0;
											local v129;
											while true do
												if ((4291 > 1912) and (v128 == 0)) then
													v129 = v70.Interrupt(v62.SpearHandStrike, 8, true);
													if ((2003 < 2339) and v129) then
														return v129;
													end
													v128 = 1;
												end
												if ((432 == 432) and (2 == v128)) then
													v129 = v70.Interrupt(v62.SpearHandStrike, 40, true, v16, v64.SpearHandStrikeMouseover);
													if (v129 or (1145 >= 1253)) then
														return v129;
													end
													break;
												end
												if ((3418 > 2118) and (v128 == 1)) then
													v129 = v70.InterruptWithStun(v62.LegSweep, 8);
													if ((3066 <= 3890) and v129) then
														return v129;
													end
													v128 = 2;
												end
											end
										end
										if (v69 or (2998 >= 3281)) then
											local v130 = 0;
											local v131;
											while true do
												if ((v130 == 0) or (4649 <= 2632)) then
													v131 = v78();
													if (v131 or (3860 > 4872)) then
														return v131;
													end
													break;
												end
											end
										end
										if (v41 or (3998 == 2298)) then
											local v132 = 0;
											while true do
												if ((v132 == 0) or (8 >= 2739)) then
													ShouldReturn = v70.HandleAfflicted(v62.Detox, v64.DetoxMouseover, 40);
													if ((2590 == 2590) and ShouldReturn) then
														return ShouldReturn;
													end
													break;
												end
											end
										end
										if (v42 or (82 >= 1870)) then
											local v133 = 0;
											while true do
												if ((2624 < 4557) and (v133 == 0)) then
													ShouldReturn = v70.HandleIncorporeal(v62.Paralysis, v64.ParalysisMouseover, 20);
													if (ShouldReturn or (3131 > 3542)) then
														return ShouldReturn;
													end
													break;
												end
											end
										end
										v125 = 1;
									end
									if ((2577 >= 1578) and (6 == v125)) then
										if ((4103 <= 4571) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\97\93\143\209\71\89\155\234", "\130\42\56\232")]:IsReady()) then
											if (v24(v62.KegSmash, not v14:IsSpellInRange(v62.KegSmash)) or (1495 == 4787)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\225\176\35\220\83\50\235\166\44\163\77\62\227\187\100\183\22", "\95\138\213\68\131\32");
											end
										end
										if ((v62[LUAOBFUSACTOR_DECRYPT_STR_0("\30\33\166\70\100\26\41\173\78", "\22\74\72\193\35")]:IsCastable() and not v62[LUAOBFUSACTOR_DECRYPT_STR_0("\14\117\229\91\39\118\241\76\15\118\233\90\35", "\56\76\25\132")]:IsAvailable() and (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\117\196\172\21\194\95\210\163", "\175\62\161\203\70")]:CooldownRemains() > v13:GCD()) and ((v13:Energy() + (v13:EnergyRegen() * (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\23\216\196\32\56\61\206\203", "\85\92\189\163\115")]:CooldownRemains() + v13:GCD()))) >= 65)) or (310 > 4434)) then
											if ((2168 <= 4360) and v24(v62.TigerPalm, not v14:IsSpellInRange(v62.TigerPalm))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\61\165\55\61\59\147\32\57\37\161\112\53\40\165\62\120\127\250", "\88\73\204\80");
											end
										end
										break;
									end
									if ((994 == 994) and (2 == v125)) then
										if ((1655 > 401) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\167\201\177\129\182\128\139\223\166\166\188\131", "\228\226\177\193\237\217")]:IsCastable()) then
											if ((3063 <= 3426) and (v54 == LUAOBFUSACTOR_DECRYPT_STR_0("\4\188\34\255\49\162", "\134\84\208\67"))) then
												if ((1459 > 764) and v24(v64.ExplodingKegPlayer, not v14:IsInMeleeRange(8))) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\22\180\150\80\28\168\143\82\20\147\141\89\20\236\213\5", "\60\115\204\230");
												end
											elseif ((v54 == LUAOBFUSACTOR_DECRYPT_STR_0("\194\52\238\125\254\122\222\126\227\63\249\48\196\47\249\99\232\40", "\16\135\90\139")) or (641 > 4334)) then
												if ((3399 >= 2260) and v16:Exists() and v13:CanAttack(v16)) then
													if (v24(v64.ExplodingKegCursor) or (393 >= 4242)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\81\108\22\63\65\80\113\90\115\57\56\75\83\56\7\45", "\24\52\20\102\83\46\52");
													end
												end
											elseif ((989 < 4859) and (v54 == LUAOBFUSACTOR_DECRYPT_STR_0("\231\58\51\55\0\214", "\111\164\79\65\68"))) then
												if (v24(v64.ExplodingKegCursor) or (4795 < 949)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\195\193\147\210\33\238\207\215\132\225\37\239\193\153\208\135", "\138\166\185\227\190\78");
												end
											elseif ((3842 == 3842) and (v54 == LUAOBFUSACTOR_DECRYPT_STR_0("\232\123\203\49\91\49\20\202\96\204\56\92", "\121\171\20\165\87\50\67"))) then
												if ((1747 <= 3601) and v24(v62.ExplodingKeg)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\195\32\169\58\182\6\207\54\190\9\178\7\193\120\234\111", "\98\166\88\217\86\217");
												end
											end
										end
										if ((v60 == LUAOBFUSACTOR_DECRYPT_STR_0("\213\249\116\3\135\200", "\188\150\150\25\97\230")) or (v60 == LUAOBFUSACTOR_DECRYPT_STR_0("\248\134\75\10", "\141\186\233\63\98\108")) or (804 > 4359)) then
											if ((4670 >= 3623) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\210\230\45\165\45", "\69\145\138\76\214")]:IsReady() and not v14:IsInRange(8) and v14:IsInRange(30)) then
												if ((2065 < 2544) and v24(v62.Clash)) then
													return LUAOBFUSACTOR_DECRYPT_STR_0("\115\195\136\154\183\86\115\192\132\139\190\2\48\151", "\118\16\175\233\233\223");
												end
											end
										end
										if ((1311 <= 3359) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\168\140\60\153\251\153\110\159", "\29\235\228\85\219\142\235")]:IsCastable() and (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\27\213\191\209\126\64\34\97\41\219\183\205", "\50\93\180\218\189\23\46\71")]:CooldownRemains() > 2) and (v68 >= 2)) then
											if ((2717 <= 3156) and v24(v62.ChiBurst, not v14:IsInMeleeRange(8))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\221\172\82\115\70\201\90\205\176\27\65\69\213\70\158\240\3", "\40\190\196\59\44\36\188");
											end
										end
										if ((1081 < 4524) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\29\87\223\181\244\120\57\51\87\206\177\244\105", "\109\92\37\188\212\154\29")]:IsCastable() and v32 and (v13:Energy() < 31)) then
											if ((440 >= 71) and v24(v62.ArcaneTorrent, not v14:IsInMeleeRange(8))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\5\253\167\194\63\95\59\251\171\209\35\95\10\251\228\206\48\83\10\175\242\155", "\58\100\143\196\163\81");
											end
										end
										v125 = 3;
									end
									if ((4934 > 2607) and (v125 == 4)) then
										if ((v62[LUAOBFUSACTOR_DECRYPT_STR_0("\6\157\114\81\220\166\186\223\22\159\122\81\215\132\189\219\62", "\184\85\237\27\63\178\207\212")]:IsReady() and (v13:BuffUp(v62.CharredPassions))) or (1400 > 3116)) then
											if ((525 < 1662) and v24(v62.SpinningCraneKick, not v14:IsInMeleeRange(8))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\27\73\0\81\6\80\7\88\55\90\27\94\6\92\54\84\1\90\2\31\5\88\0\81\72\12\95", "\63\104\57\105");
											end
										end
										if (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\40\143\173\102\30\149\183\80", "\36\107\231\196")]:IsCastable() or (876 > 2550)) then
											if ((219 <= 2456) and v24(v62.ChiBurst, not v14:IsInMeleeRange(8))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\94\189\171\184\95\160\176\148\73\245\175\134\84\187\226\209\13", "\231\61\213\194");
											end
										end
										if (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\42\165\52\68\8\187\56", "\19\105\205\93")]:IsCastable() or (4219 == 1150)) then
											if (v24(v62.ChiWave, not v14:IsInMeleeRange(8)) or (2989 <= 222)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\170\0\215\190\40\168\30\219\193\50\168\1\208\193\105\251", "\95\201\104\190\225");
											end
										end
										if ((2258 > 1241) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\156\219\200\192\161\194\207\201\140\217\192\192\170\224\200\205\164", "\174\207\171\161")]:IsCastable() and not ShaohaosMightEquipped and (v68 >= 3) and (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\198\251\10\192\245\214\254\246", "\183\141\158\109\147\152")]:CooldownRemains() > v13:GCD()) and ((v13:Energy() + (v13:EnergyRegen() * (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\7\12\225\63\33\8\245\4", "\108\76\105\134")]:CooldownRemains() + v62[LUAOBFUSACTOR_DECRYPT_STR_0("\216\213\184\239\192\226\203\182\194\220\234\203\180\202\199\232\206", "\174\139\165\209\129")]:ExecuteTime()))) >= 65) and (not v62[LUAOBFUSACTOR_DECRYPT_STR_0("\144\163\235\213\192\10\98\125", "\24\195\211\130\161\166\99\16")]:IsAvailable() or not CharredPassionsEquipped)) then
											if ((41 < 4259) and v24(v62.SpinningCraneKick, not v14:IsInMeleeRange(8))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\85\19\224\34\93\31\72\4\214\47\65\23\72\6\214\39\90\21\77\67\228\45\90\24\6\85\189", "\118\38\99\137\76\51");
											end
										end
										v125 = 5;
									end
									if ((v125 == 3) or (1930 < 56)) then
										if ((3333 == 3333) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\46\77\54\160\55\70\227\42\31\67\55\171", "\110\122\34\67\195\95\41\133")]:IsCastable() and v32) then
											if (v24(v62.TouchofDeath, not v14:IsInMeleeRange(5)) or (2225 == 20)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\97\190\78\73\222\74\190\93\117\210\112\176\79\66\150\120\176\82\68\150\32\227", "\182\21\209\59\42");
											end
										end
										if ((v62[LUAOBFUSACTOR_DECRYPT_STR_0("\149\69\192\28\53\182\152\81\227\20\51\187", "\222\215\55\165\125\65")]:IsCastable() and CharredPassionsEquipped and v13:BuffDown(v62.CharredPassions)) or (872 >= 3092)) then
											if ((4404 >= 3252) and v24(v62.BreathOfFire, not v14:IsInRange(12))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\46\195\195\27\230\201\210\69\42\238\192\19\224\196\173\71\45\216\200\90\166\147", "\42\76\177\166\122\146\161\141");
											end
										end
										if ((1107 > 796) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\135\152\0\207\109\126\138\140\35\199\107\115", "\22\197\234\101\174\25")]:IsCastable() and v13:BuffDown(v62.BlackoutComboBuff) and (v13:BloodlustDown() or (v13:BloodlustUp() and v14:BuffRefreshable(v62.BreathOfFireDotDebuff)))) then
											if ((959 == 959) and v24(v62.BreathOfFire, not v14:IsInMeleeRange(8))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\47\38\160\221\98\167\232\137\43\11\163\213\100\170\151\139\44\61\171\156\35\247", "\230\77\84\197\188\22\207\183");
											end
										end
										if (v62[LUAOBFUSACTOR_DECRYPT_STR_0("\203\1\213\244\133\175\247\31\248\16\195\203\133\175\244", "\85\153\116\166\156\236\193\144")]:IsCastable() or (245 >= 2204)) then
											if ((3162 >= 2069) and v24(v62.RushingJadeWind, not v14:IsInMeleeRange(8))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\182\245\94\187\237\14\163\223\71\178\224\5\155\247\68\189\224\64\169\225\68\189\164\87\246", "\96\196\128\45\211\132");
											end
										end
										v125 = 4;
									end
									if ((v125 == 5) or (306 > 3081)) then
										if ((v62[LUAOBFUSACTOR_DECRYPT_STR_0("\207\51\22\26\0\46\250\12\4\22\12\23\244\40\1", "\64\157\70\101\114\105")]:IsCastable() and (v13:BuffDown(v62.RushingJadeWind))) or (3513 < 2706)) then
											if ((2978 < 3639) and v24(v62.RushingJadeWind, not v14:IsInMeleeRange(8))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\82\189\180\235\25\78\175\152\233\17\68\173\152\244\25\78\172\231\238\17\73\166\231\182\68", "\112\32\200\199\131");
											end
										end
										if ((3682 >= 2888) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\24\89\91\189\209\155\35\32\93", "\66\76\48\60\216\163\203")]:IsReady() and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\136\147\106\251\86\192\35\144\135\125\246\104\199\42\190", "\68\218\230\25\147\63\174")]:IsAvailable() and v13:BuffUp(v62.BlackoutComboBuff) and v13:BuffUp(v62.RushingJadeWind)) then
											if ((149 < 479) and v24(v62.TigerPalm, not v14:IsInMeleeRange(5))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\185\35\84\73\164\146\58\82\64\187\237\39\82\69\184\237\126\3", "\214\205\74\51\44");
											end
										end
										if ((1020 >= 567) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\216\64\227\255\124\245\89\246\215\126\249\71", "\23\154\44\130\156")]:IsCastable()) then
											if (v24(v62.BlackoutKick, not v14:IsInMeleeRange(5)) or (733 > 2469)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\19\170\172\173\61\28\4\178\146\165\63\16\26\230\160\175\63\29\81\242\249", "\115\113\198\205\206\86");
											end
										end
										if ((2497 == 2497) and v62[LUAOBFUSACTOR_DECRYPT_STR_0("\182\94\237\83\138\80\205\79\138\124\247\89\143", "\58\228\55\158")]:IsCastable()) then
											if ((3901 == 3901) and v24(v62.RisingSunKick, not v14:IsInMeleeRange(5))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\166\128\195\39\50\170\10\167\156\222\17\55\164\54\191\201\221\47\53\163\117\224\223", "\85\212\233\176\78\92\205");
											end
										end
										v125 = 6;
									end
								end
							end
							v118 = 1;
						end
						if ((201 < 415) and (v118 == 1)) then
							if (v24(v62.PoolEnergy) or (133 == 1784)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\30\140\31\74\105\255\32\134\2\65\48", "\186\78\227\112\38\73");
							end
							break;
						end
					end
				end
				break;
			end
			if ((2 == v92) or (7 >= 310)) then
				v68 = ((#v67 > 0) and #v67) or 1;
				EnemiesCount5 = ((#v66 > 0) and #v66) or 1;
				v69 = v13:IsTankingAoE(8) or v13:IsTanking(v14);
				if ((4992 > 286) and v13:IsDeadOrGhost()) then
					return;
				end
				v92 = 3;
			end
			if ((1 == v92) or (2561 == 3893)) then
				v33 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\216\167\4\195\80\233\187", "\60\140\200\99\164")][LUAOBFUSACTOR_DECRYPT_STR_0("\131\253\23\54\167\139", "\194\231\148\100\70")];
				v66 = v13:GetEnemiesInMeleeRange(5);
				v67 = v13:GetEnemiesInMeleeRange(8);
				v68 = #v67;
				v92 = 2;
			end
		end
	end
	local function v81()
		local v93 = 0;
		while true do
			if ((4362 >= 1421) and (v93 == 0)) then
				v72();
				v21.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\222\69\248\66\94\123\239\67\248\71\19\87\243\89\246\21\65\117\232\86\233\92\92\116\188\85\228\21\118\106\245\84\189\119\92\117\241\124", "\26\156\55\157\53\51"));
				v93 = 1;
			end
			if ((75 <= 3546) and (v93 == 1)) then
				EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\174\202\19\206\181\81\159\204\19\203\248\125\131\214\29\153\128\16\154\152\71\137\246\2\194\136\70\153\154\73\204\250\25\214\181\123", "\48\236\184\118\185\216"));
				break;
			end
		end
	end
	v21.SetAPL(268, v80, v81);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\192\173\94\40\240\25\234\179\92\15\237\38\224\170\90\49\220\32\224\175\25\60\218\53", "\84\133\221\55\80\175")]();

