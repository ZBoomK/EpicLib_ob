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
		if ((0 == v5) or (3711 == 503)) then
			v6 = v0[v4];
			if (not v6 or (420 == 4318)) then
				return v1(v4, ...);
			end
			v5 = 1;
		end
		if ((v5 == 1) or (4158 <= 33)) then
			return v6(...);
		end
	end
end
v0[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\194\19\222\205\243\48\232\175\194\12\238\245\222\43\225\190\198\16\210\198\149\41\243\186", "\126\177\163\187\69\134\219\167")] = function(...)
	local v7, v8 = ...;
	local v9 = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local v10 = EpicLib;
	local v11 = EpicCache;
	local v12 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\1\163\64\26\175", "\38\84\215\41\118\220\70")];
	local v13 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\101\24\43\6", "\158\48\118\66\114")];
	local v14 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\155\40\17\47\118\183", "\155\203\68\112\86\19\197")];
	local v15 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\114\220\36\251\69\108", "\152\38\189\86\156\32\24\133")];
	local v16 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\209\88\178\85\249\120\177\67\238", "\38\156\55\199")];
	local v17 = v13[LUAOBFUSACTOR_DECRYPT_STR_0("\152\120\104", "\35\200\29\28\72\115\20\154")];
	local v18 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\42\175\212\211\129", "\84\121\223\177\191\237\76")];
	local v19 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local v20 = EpicLib;
	local v21 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\107\75\14\33", "\69\41\34\96")];
	local v22 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30", "\75\220\163\183\106\98")];
	local v23 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\33\187\152\35\234\23\189\140\50\202\22\191\143", "\185\98\218\235\87")];
	local v24 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\232\61\52\242\255\164\197\51\51\231\202\175\207", "\202\171\92\71\134\190")];
	local v25 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\25\211\41\155\58", "\232\73\161\76")];
	local v26 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\150\216\65\79\17", "\126\219\185\34\61")];
	local v27 = v20[LUAOBFUSACTOR_DECRYPT_STR_0("\47\193\83\127\113\121\224", "\135\108\174\62\18\30\23\147")][LUAOBFUSACTOR_DECRYPT_STR_0("\147\255\47\217\1\161\61\194", "\167\214\137\74\171\120\206\83")];
	local v28 = v10[LUAOBFUSACTOR_DECRYPT_STR_0("\190\228\59\81\235", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\42\19\171\44\2\34\184\41\11\19\155\50\44\19\160", "\75\103\118\217")];
	local v29 = v27[LUAOBFUSACTOR_DECRYPT_STR_0("\201\65\125", "\126\167\52\16\116\217")];
	local v30 = v27[LUAOBFUSACTOR_DECRYPT_STR_0("\202\33\47\140", "\156\168\78\64\224\212\121")];
	local v31 = GetTime;
	local v32 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\10\239\189", "\174\103\142\197")];
	local v33 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\85\45\86\52", "\152\54\72\63\88\69\62")];
	local v34 = math[LUAOBFUSACTOR_DECRYPT_STR_0("\217\205\224", "\60\180\164\142")];
	local v35 = 5;
	local v36;
	local v37 = false;
	local v38 = false;
	local v39 = false;
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
	local v90 = v18[LUAOBFUSACTOR_DECRYPT_STR_0("\124\91\8\38\41\197\7\86\74\0\59", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\142\236\213\195\189\232\213\199\189", "\164\216\137\187")];
	local v91 = v19[LUAOBFUSACTOR_DECRYPT_STR_0("\246\227\60\189\168\214\30\220\242\52\160", "\107\178\134\81\210\198\158")][LUAOBFUSACTOR_DECRYPT_STR_0("\14\11\140\193\175\57\0\129\195", "\202\88\110\226\166")];
	local v92 = v26[LUAOBFUSACTOR_DECRYPT_STR_0("\231\10\143\248\196\235\26\140\227\207\209", "\170\163\111\226\151")][LUAOBFUSACTOR_DECRYPT_STR_0("\39\53\188\63\75\54\39\18\53", "\73\113\80\210\88\46\87")];
	local v93 = {};
	local v94, v95;
	local v96 = 0;
	local v97, v98;
	local v99;
	local v100;
	local v101;
	local v102;
	local v103 = true;
	local v104 = 11111;
	local v105 = 11111;
	local v106 = {169421,169425,168932,169426,169429,169428,169430};
	v10:RegisterForEvent(function()
		local v124 = 0;
		while true do
			if ((v124 == 0) or (99 > 4744)) then
				v104 = 11111;
				v105 = 11111;
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\177\0\236\43\194\179\19\255\55\192\164\2\242\55\201\160\14\225\55\195", "\135\225\76\173\114"));
	local function v107()
		local v125 = 0;
		while true do
			if ((4341 == 4341) and (v125 == 0)) then
				v94 = v14:BuffStack(v90.SoulFragments);
				if ((255 <= 1596) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\41\253\177\162\165\169\133\21\224\186", "\199\122\141\216\208\204\221")]:TimeSinceLastCast() < v14:GCD())) then
					v96 = 0;
				end
				v125 = 1;
			end
			if ((1 == v125) or (4433 < 1635)) then
				if ((v96 == 0) or (4300 < 3244)) then
					local v187 = 0;
					local v188;
					while true do
						if ((0 == v187) or (3534 > 4677)) then
							v188 = ((v14:BuffUp(v90.MetamorphosisBuff)) and 1) or 0;
							if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\158\210\5\252\91\247\191\203\21\226", "\150\205\189\112\144\24")]:IsAvailable() and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\22\139\170\64\39\137\3\6\32\150", "\112\69\228\223\44\100\232\113")]:TimeSinceLastCast() < v14:GCD()) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\231\16\18\223\149\125\148\194\26\21", "\230\180\127\103\179\214\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\160\4\76\82\199\64\243\152\49\86\75\225", "\128\236\101\63\38\132\33")] ~= v95)) or (4859 < 2999)) then
								local v201 = 0;
								while true do
									if ((4726 > 2407) and (v201 == 0)) then
										v96 = v34(v94 + 2, 5);
										v95 = v90[LUAOBFUSACTOR_DECRYPT_STR_0("\159\166\4\72\149\234\221\186\172\3", "\175\204\201\113\36\214\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\107\205\38\200\39\70\223\33\232\13\74\201", "\100\39\172\85\188")];
										break;
									end
								end
							elseif ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\139\106\184\131\39\184\106\188", "\83\205\24\217\224")]:IsAvailable() and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\192\215\204\62\242\208\223\56", "\93\134\165\173")]:TimeSinceLastCast() < v14:GCD()) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\152\224\192\193\46\219\160\123", "\30\222\146\161\162\90\174\210")][LUAOBFUSACTOR_DECRYPT_STR_0("\201\79\99\30\198\79\99\30\209\71\125\15", "\106\133\46\16")] ~= v95)) or (1284 > 3669)) then
								local v213 = 0;
								while true do
									if ((1117 < 2549) and (v213 == 0)) then
										v96 = v34(v94 + 2 + v188, 5);
										v95 = v90[LUAOBFUSACTOR_DECRYPT_STR_0("\126\50\114\255\78\85\74\37", "\32\56\64\19\156\58")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\201\246\66\121\243\147\78\252\236\91\95", "\224\58\168\133\54\58\146")];
										break;
									end
								end
							elseif (((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\106\94\78\252\103", "\107\57\54\43\157\21\230\231")]:TimeSinceLastCast() < v14:GCD()) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\253\153\16\246\173\201\221\222", "\175\187\235\113\149\217\188")][LUAOBFUSACTOR_DECRYPT_STR_0("\15\167\132\77\241", "\24\92\207\225\44\131\25")] ~= v95)) or (2851 > 4774)) then
								local v216 = 0;
								while true do
									if ((1031 < 3848) and (v216 == 0)) then
										v96 = v34(v94 + 1 + v188, 5);
										v95 = v90[LUAOBFUSACTOR_DECRYPT_STR_0("\120\219\189\77\9", "\29\43\179\216\44\123")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\216\51\88\158\216\51\88\137\208\45\73", "\44\221\185\64")];
										break;
									end
								end
							elseif ((1854 > 903) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\50\232\93\83\64\8\224\65\83\96", "\19\97\135\40\63")]:IsAvailable()) then
								local v218 = 0;
								local v219;
								local v220;
								while true do
									if ((4663 > 1860) and (v218 == 0)) then
										v219 = v32(v90[LUAOBFUSACTOR_DECRYPT_STR_0("\157\85\52\50\35\30\168\122\63\58\34\52", "\81\206\60\83\91\79")].LastCastTime, v90[LUAOBFUSACTOR_DECRYPT_STR_0("\125\162\215\123\35\236\75\151\71\167\213\124\44\198", "\196\46\203\176\18\79\163\45")].LastCastTime, v90[LUAOBFUSACTOR_DECRYPT_STR_0("\139\43\121\23\40\212\233\155\42\127\23\42\232", "\143\216\66\30\126\68\155")].LastCastTime, v90[LUAOBFUSACTOR_DECRYPT_STR_0("\143\196\20\216\204\162\217\197\175\203\31\206\192", "\129\202\168\109\171\165\195\183")].LastCastTime);
										v220 = v34(v90[LUAOBFUSACTOR_DECRYPT_STR_0("\17\81\48\209\210\59\224\4\84\54\213\219", "\134\66\56\87\184\190\116")]:TimeSinceLastCast(), v90[LUAOBFUSACTOR_DECRYPT_STR_0("\15\56\14\178\21\196\39\6\53\61\12\181\26\238", "\85\92\81\105\219\121\139\65")]:TimeSinceLastCast(), v90[LUAOBFUSACTOR_DECRYPT_STR_0("\206\186\87\76\112\240\251\144\88\68\117\209\238", "\191\157\211\48\37\28")]:TimeSinceLastCast(), v90[LUAOBFUSACTOR_DECRYPT_STR_0("\250\19\237\15\51\222\17\208\25\57\205\26\241", "\90\191\127\148\124")]:TimeSinceLastCast());
										v218 = 1;
									end
									if ((v218 == 1) or (3053 <= 469)) then
										if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\93\139\55\4\113\134\32\51\125\132\60\18\125", "\119\24\231\78")]:IsAvailable() and (v219 == v90[LUAOBFUSACTOR_DECRYPT_STR_0("\167\33\188\89\213\65\31\166\40\166\88\217\69", "\113\226\77\197\42\188\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\22\23\231\161\25\23\231\161\14\31\249\176", "\213\90\118\148")]) and (v220 < v14:GCD()) and (v219 ~= v95)) or (540 >= 1869)) then
											local v226 = 0;
											local v227;
											while true do
												if ((3292 == 3292) and (1 == v226)) then
													v95 = v219;
													break;
												end
												if ((1038 <= 2645) and (v226 == 0)) then
													v227 = v34(v102, 3);
													v96 = v34(v94 + v227, 5);
													v226 = 1;
												end
											end
										elseif (((v220 < v14:GCD()) and (v219 ~= v95)) or (3230 < 2525)) then
											local v229 = 0;
											while true do
												if ((v229 == 0) or (2400 > 4083)) then
													v96 = v34(v94 + 1, 5);
													v95 = v219;
													break;
												end
											end
										end
										break;
									end
								end
							elseif ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\125\47\184\90\66\78\58", "\45\59\78\212\54")]:IsAvailable() and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\57\91\142\132\138\47\185\249\31\88\162\158\148\47", "\144\112\54\227\235\230\78\205")]:TimeSinceLastCast() < v14:GCD()) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\154\37\2\243\220\90\167\33\0\242\241\78\161\41", "\59\211\72\111\156\176")][LUAOBFUSACTOR_DECRYPT_STR_0("\98\134\240\57\109\134\240\57\122\142\238\40", "\77\46\231\131")] ~= v95)) or (2745 > 4359)) then
								local v222 = 0;
								local v223;
								while true do
									if ((172 <= 1810) and (v222 == 1)) then
										v95 = v90[LUAOBFUSACTOR_DECRYPT_STR_0("\147\89\187\79\182\85\162\73\181\90\151\85\168\85", "\32\218\52\214")][LUAOBFUSACTOR_DECRYPT_STR_0("\98\22\34\188\210\177\86\78\122\30\60\173", "\58\46\119\81\200\145\208\37")];
										break;
									end
									if ((v222 == 0) or (492 >= 4959)) then
										v223 = 0.6 * v34(v102, 5);
										v96 = v34(v94 + v223, 5);
										v222 = 1;
									end
								end
							elseif ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\9\153\60\167\140\165\34\57\141\51\184\160\178\56", "\86\75\236\80\204\201\221")]:IsAvailable() and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\80\84\123\142\219\147\102\83\118\134\234\130\125\79", "\235\18\33\23\229\158")]:TimeSinceLastCast() < v14:GCD()) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\114\175\205\176\117\162\213\169\81\185\213\178\95\180", "\219\48\218\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\112\111\93\248\78\243\240\69\117\68\222", "\128\132\17\28\41\187\47")] ~= v95)) or (756 == 2072)) then
								local v224 = 0;
								local v225;
								while true do
									if ((1605 <= 4664) and (v224 == 0)) then
										v225 = v34(v102, 5);
										v96 = v34(v94 + v225, 5);
										v224 = 1;
									end
									if ((1816 == 1816) and (v224 == 1)) then
										v95 = v90[LUAOBFUSACTOR_DECRYPT_STR_0("\35\39\10\49\120\25\38\20\59\94\21\59\9\52", "\61\97\82\102\90")][LUAOBFUSACTOR_DECRYPT_STR_0("\128\47\184\95\228\86\13\29\152\39\166\78", "\105\204\78\203\43\167\55\126")];
										break;
									end
								end
							end
							break;
						end
					end
				else
					local v189 = 0;
					local v190;
					local v191;
					while true do
						if ((2 == v189) or (621 > 3100)) then
							for v199, v200 in pairs(v191) do
								if (((v190 == v200:ID()) and (v200:TimeSinceLastCast() >= v14:GCD())) or (1157 >= 4225)) then
									v96 = 0;
									break;
								end
							end
							break;
						end
						if ((1 == v189) or (4986 == 4138)) then
							if (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\199\126\224\161\22\36\128\253\125\230", "\231\148\17\149\205\69\77")]:IsAvailable() or (2033 <= 224)) then
								local v202 = 0;
								while true do
									if ((v202 == 1) or (1223 == 2011)) then
										v28(v191, v90.SigilOfChains);
										v28(v191, v90.ElysianDecree);
										break;
									end
									if ((4827 > 4695) and (v202 == 0)) then
										v28(v191, v90.SigilOfFlame);
										v28(v191, v90.SigilOfSilence);
										v202 = 1;
									end
								end
							end
							if ((3710 > 3065) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\166\166\203\247\88\234\148", "\159\224\199\167\155\55")]:IsAvailable()) then
								v28(v191, v90.ImmolationAura);
							end
							v189 = 2;
						end
						if ((2135 <= 2696) and (0 == v189)) then
							v190 = v14:PrevGCD(1);
							v191 = {v90[LUAOBFUSACTOR_DECRYPT_STR_0("\150\165\54\18\48\5\213\71\160\184", "\49\197\202\67\126\115\100\167")],v90[LUAOBFUSACTOR_DECRYPT_STR_0("\17\73\222\42\148\67\76\50", "\62\87\59\191\73\224\54")],v90[LUAOBFUSACTOR_DECRYPT_STR_0("\212\10\255\200\245", "\169\135\98\154")],v90[LUAOBFUSACTOR_DECRYPT_STR_0("\233\98\40\95\216\43\220\217\118\39\64\244\60\198", "\168\171\23\68\52\157\83")]};
							v189 = 1;
						end
					end
				end
				if ((v96 > v94) or (1742 > 4397)) then
					v94 = v96;
				elseif ((3900 >= 1904) and (v96 > 0)) then
					v96 = 0;
				end
				break;
			end
		end
	end
	local function v108()
		local v126 = 0;
		while true do
			if ((0 == v126) or (1724 == 909)) then
				if ((1282 < 1421) and ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\209\246\48\208\251\242\56\215", "\178\151\147\92")]:TimeSinceLastCast() < v14:GCD()) or (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\165\243\74\55\0\66\123\128\206\88\32\27\71\127", "\26\236\157\44\82\114\44")]:TimeSinceLastCast() < v14:GCD()))) then
					local v192 = 0;
					while true do
						if ((4876 >= 4337) and (v192 == 1)) then
							return;
						end
						if ((4005 >= 3005) and (0 == v192)) then
							v97 = true;
							v98 = true;
							v192 = 1;
						end
					end
				end
				v97 = v15:IsInMeleeRange(5);
				v126 = 1;
			end
			if ((1 == v126) or (4781 <= 4448)) then
				v98 = v97 or (v102 > 0);
				break;
			end
		end
	end
	local function v109(v127)
		return (v127:DebuffRemains(v90.FieryBrandDebuff));
	end
	local function v110(v128)
		return (v128:DebuffUp(v90.FieryBrandDebuff));
	end
	local function v111()
		local v129 = 0;
		while true do
			if ((1317 > 172) and (v129 == 0)) then
				v36 = v27.HandleTopTrinket(v93, v39, 40, nil);
				if ((4791 == 4791) and v36) then
					return v36;
				end
				v129 = 1;
			end
			if ((3988 > 1261) and (v129 == 1)) then
				v36 = v27.HandleBottomTrinket(v93, v39, 40, nil);
				if ((2240 <= 3616) and v36) then
					return v36;
				end
				break;
			end
		end
	end
	local function v112()
		local v130 = 0;
		while true do
			if ((v130 == 0) or (3988 < 3947)) then
				if ((4644 == 4644) and v47 and not v14:IsMoving() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\25\39\210\82\38\1\211\125\38\47\216\94", "\59\74\78\181")]:IsCastable()) then
					if ((1323 > 1271) and ((v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\53\221\91\67\182\55", "\211\69\177\58\58")) or v90[LUAOBFUSACTOR_DECRYPT_STR_0("\148\234\119\246\236\197\163\247\120\225\236\207\132\236\126\252\229\216", "\171\215\133\25\149\137")]:IsAvailable())) then
						if ((1619 > 1457) and v25(v92.SigilOfFlamePlayer, not v15:IsInMeleeRange(v35))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\242\193\53\243\227\15\243\68\222\206\62\251\226\53\188\82\243\205\49\245\226\50\253\86\161\154", "\34\129\168\82\154\143\80\156");
						end
					elseif ((v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\134\167\33\24\71\92", "\233\229\210\83\107\40\46")) or (2860 < 1808)) then
						if (v25(v92.SigilOfFlameCursor, not v15:IsInRange(30)) or (739 >= 1809)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\210\75\53\223\9\254\77\52\233\3\205\67\63\211\69\209\80\55\213\10\204\64\51\194\69\147", "\101\161\34\82\182");
						end
					end
				end
				if ((1539 <= 4148) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\193\0\84\241\215\227\150\39\231\3\120\235\201\227", "\78\136\109\57\158\187\130\226")]:IsCastable() and v44) then
					if (v25(v90.ImmolationAura, not v15:IsInMeleeRange(v35)) or (434 > 3050)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\55\50\244\254\50\62\237\248\49\49\198\240\43\45\248\177\46\45\252\242\49\50\251\240\42\127\173", "\145\94\95\153");
					end
				end
				v130 = 1;
			end
			if ((v130 == 2) or (3054 < 1683)) then
				if ((47 < 2706) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\2\138\121\189\35", "\220\81\226\28")]:IsCastable() and v46 and v97) then
					if ((1519 >= 580) and v25(v90.Shear)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\0\221\135\250\248\135\3\199\135\248\229\202\17\212\150\187\187\151", "\167\115\181\226\155\138");
					end
				end
				break;
			end
			if ((v130 == 1) or (3110 == 4177)) then
				if ((4200 > 2076) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\212\195\18\208\92\185\252\193\39\193\92\190\246\200", "\215\157\173\116\181\46")]:IsCastable() and v45) then
					if (v25(v92.InfernalStrikePlayer, not v15:IsInMeleeRange(v35)) or (601 >= 2346)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\186\141\247\200\59\181\135\205\201\33\166\130\249\223\117\164\153\247\217\58\185\137\243\206\117\226", "\186\85\212\235\146");
					end
				end
				if ((3970 <= 4354) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\228\147\23\253\45\251\74\199", "\56\162\225\118\158\89\142")]:IsCastable() and v43 and v97) then
					if (v25(v90.Fracture) or (1542 < 208)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\90\23\193\172\54\205\78\0\128\191\48\221\95\10\205\173\35\204\28\93", "\184\60\101\160\207\66");
					end
				end
				v130 = 2;
			end
		end
	end
	local function v113()
		local v131 = 0;
		while true do
			if ((1612 <= 2926) and (v131 == 2)) then
				if ((v82 and (v14:HealthPercentage() <= v84)) or (2006 <= 540)) then
					local v193 = 0;
					while true do
						if ((v193 == 0) or (2412 == 4677)) then
							if ((v86 == LUAOBFUSACTOR_DECRYPT_STR_0("\1\87\84\228\252\32\90\91\248\254\115\122\87\247\245\58\92\85\182\201\60\70\91\249\247", "\153\83\50\50\150")) or (4897 <= 1972)) then
								if ((3101 <= 3584) and v91[LUAOBFUSACTOR_DECRYPT_STR_0("\111\115\117\14\118\184\69\84\120\116\52\118\170\65\84\120\116\44\124\191\68\82\120", "\45\61\22\19\124\19\203")]:IsReady()) then
									if (v25(v92.RefreshingHealingPotion) or (1568 >= 4543)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\211\23\11\231\7\99\177\200\28\10\181\10\117\184\205\27\3\242\66\96\182\213\27\2\251\66\116\188\199\23\3\230\11\102\188", "\217\161\114\109\149\98\16");
									end
								end
							end
							if ((4258 >= 1841) and (v86 == "Dreamwalker's Healing Potion")) then
								if (v91[LUAOBFUSACTOR_DECRYPT_STR_0("\54\50\61\125\177\99\19\44\51\121\174\103\58\37\57\112\181\122\21\16\55\104\181\123\28", "\20\114\64\88\28\220")]:IsReady() or (3052 >= 3554)) then
									if (v25(v92.RefreshingHealingPotion) or (2098 > 3885)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\53\19\215\181\245\199\188\61\10\215\166\235\144\181\52\0\222\189\246\215\253\33\14\198\189\247\222\253\53\4\212\177\246\195\180\39\4", "\221\81\97\178\212\152\176");
									end
								end
							end
							break;
						end
					end
				end
				break;
			end
			if ((v131 == 0) or (2970 == 1172)) then
				if ((3913 > 3881) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\198\39\234\83\117\66\214\235\41\226\79", "\166\130\66\135\60\27\17")]:IsCastable() and v66 and v14:BuffDown(v90.DemonSpikesBuff) and v14:BuffDown(v90.MetamorphosisBuff) and (((v102 == 1) and v14:BuffDown(v90.FieryBrandDebuff)) or (v102 > 1))) then
					if ((4932 >= 1750) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\96\79\195\122\62\119\90\199\126\53\87", "\80\36\42\174\21")]:ChargesFractional() > 1.9)) then
						if (v25(v90.DemonSpikes) or (135 == 1669)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\74\21\58\117\64\47\36\106\71\27\50\105\14\20\50\124\75\30\36\115\88\21\36\58\6\51\54\106\94\21\51\51", "\26\46\112\87");
						end
					elseif ((4802 >= 109) and (v99 or (v14:HealthPercentage() <= v69))) then
						if (v25(v90.DemonSpikes) or (3911 > 4952)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\189\38\166\123\177\128\86\164\176\40\174\103\255\187\64\178\188\45\184\125\169\186\86\244\241\7\170\122\184\186\87\253", "\212\217\67\203\20\223\223\37");
						end
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\151\136\188\211\183\130\186\194\178\130\187\219\169", "\178\218\237\200")]:IsCastable() and v68 and (v14:HealthPercentage() <= v71) and (v14:BuffDown(v90.MetamorphosisBuff) or (v15:TimeToDie() < 15))) or (265 > 4194)) then
					if ((2655 <= 2908) and v25(v92.MetamorphosisPlayer)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\187\176\242\209\187\186\244\192\190\186\245\217\165\245\226\213\176\176\232\195\191\163\227\195", "\176\214\213\134");
					end
				end
				v131 = 1;
			end
			if ((963 > 651) and (v131 == 1)) then
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\210\164\179\198\177\116\75\245\163\178", "\57\148\205\214\180\200\54")]:IsCastable() and v67 and (v99 or (v14:HealthPercentage() <= v70))) or (3503 <= 195)) then
					if ((1382 <= 4404) and v25(v90.FieryBrand, not v15:IsSpellInRange(v90.FieryBrand))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\20\244\48\38\111\45\255\39\53\120\22\189\49\49\112\23\243\38\61\96\23\238", "\22\114\157\85\84");
					end
				end
				if ((v91[LUAOBFUSACTOR_DECRYPT_STR_0("\236\206\18\200\73\254\187\208\196\29\193", "\200\164\171\115\164\61\150")]:IsReady() and v83 and (v14:HealthPercentage() <= v85)) or (4857 <= 767)) then
					if (v25(v92.Healthstone) or (4018 > 4021)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\182\241\2\73\151\182\231\23\74\141\187\180\7\64\133\187\250\16\76\149\187", "\227\222\148\99\37");
					end
				end
				v131 = 2;
			end
		end
	end
	local function v114()
		local v132 = 0;
		while true do
			if ((v132 == 0) or (2270 == 1932)) then
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\254\238\26\242\22\226\225\62\243\27\196\233\14", "\122\173\135\125\155")]:IsCastable() and v54 and not v14:IsMoving() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\167\216\3\181\58\62\206\166\200\14\189\54\63\207", "\168\228\161\96\217\95\81")]:IsAvailable() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\232\216\41\85\35\120\221\242\38\93\38\89\200", "\55\187\177\78\60\79")]:IsAvailable()) or (3430 <= 1176)) then
					if ((v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\61\194\94\242\67\221", "\224\77\174\63\139\38\175")) or v90[LUAOBFUSACTOR_DECRYPT_STR_0("\167\78\86\45\129\79\76\60\133\85\93\42\183\72\95\39\136\82", "\78\228\33\56")]:IsAvailable() or (1198 >= 3717)) then
						if ((3730 >= 1333) and v25(v92.SigilOfChainsPlayer, not v15:IsInMeleeRange(v35))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\221\119\181\10\137\241\113\180\60\134\198\127\187\13\150\142\110\190\2\156\203\108\242\5\140\194\114\183\17\197\156", "\229\174\30\210\99");
						end
					elseif ((v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\24\248\148\66\226\47", "\89\123\141\230\49\141\93")) or (2152 == 2797)) then
						if (v25(v92.SigilOfChainsCursor, not v15:IsInRange(30)) or (1709 < 588)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\224\120\241\5\28\117\252\119\201\15\24\75\250\127\229\76\19\95\225\98\249\30\80\76\250\125\250\9\2\10\161", "\42\147\17\150\108\112");
						end
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\60\175\42\118\235\199\9\139\36\108\226\250\22", "\136\111\198\77\31\135")]:IsCastable() and v55 and not v14:IsMoving() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\33\16\164\90\184\235\17\139\11\7\163\95\179\227", "\201\98\105\199\54\221\132\119")]:IsAvailable() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\138\5\132\40\14\26\170\148\5\144\36\16\44", "\204\217\108\227\65\98\85")]:IsAvailable()) or (3575 <= 3202)) then
					if ((v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\78\207\244\252\41\210", "\160\62\163\149\133\76")) or v90[LUAOBFUSACTOR_DECRYPT_STR_0("\245\175\3\44\198\216\180\31\46\215\211\164\62\38\196\223\172\30", "\163\182\192\109\79")]:IsAvailable() or (4397 < 3715)) then
						if (v25(v92.SigilOfMiseryPlayer, not v15:IsInMeleeRange(v35)) or (4075 <= 2245)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\39\47\7\201\249\11\41\6\255\248\61\53\5\210\236\116\54\12\193\236\49\52\64\198\252\56\42\5\210\181\96", "\149\84\70\96\160");
						end
					elseif ((v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\59\19\31\254\55\20", "\141\88\102\109")) or (3966 > 4788)) then
						if ((3826 > 588) and v25(v92.SigilOfMiseryCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\160\90\205\121\22\2\90\199\140\94\195\99\31\47\76\129\176\70\216\99\21\47\21\199\186\95\198\117\8\125\1", "\161\211\51\170\16\122\93\53");
						end
					end
				end
				v132 = 1;
			end
			if ((694 <= 1507) and (v132 == 1)) then
				if ((3900 >= 1116) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\200\167\181\33\247\129\180\27\242\162\183\38\248\171", "\72\155\206\210")]:IsCastable() and v53 and not v14:IsMoving() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\101\99\87\2\54\73\124\118\7\61\66\115\90\9", "\83\38\26\52\110")]:IsAvailable() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\107\30\32\79\84\56\33\117\81\27\34\72\91\18", "\38\56\119\71")]:IsAvailable()) then
					if ((4907 > 3311) and ((v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\227\227\89\207\32\68", "\54\147\143\56\182\69")) or v90[LUAOBFUSACTOR_DECRYPT_STR_0("\245\142\241\74\218\216\149\237\72\203\211\133\204\64\216\223\141\236", "\191\182\225\159\41")]:IsAvailable())) then
						if (v25(v92.SigilOfSilencePlayer, not v15:IsInMeleeRange(v35)) or (3408 <= 2617)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\56\27\47\92\135\184\205\45\45\59\92\135\130\204\40\23\104\69\135\134\219\46\0\104\83\130\139\206\46\0\104\3", "\162\75\114\72\53\235\231");
						end
					elseif ((3201 == 3201) and (v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\143\41\86\241\92\16", "\98\236\92\36\130\51"))) then
						if ((2195 == 2195) and v25(v92.SigilOfSilenceCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\183\16\11\179\73\151\186\54\155\10\5\182\64\166\182\53\228\26\25\168\86\167\167\112\162\16\0\182\64\186\245\102", "\80\196\121\108\218\37\200\213");
						end
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\52\123\16\112\92\41\134\1\122\20\122", "\234\96\19\98\31\43\110")]:IsCastable() and v50) or (3025 > 3506)) then
					if (v25(v90.ThrowGlaive, not v15:IsSpellInRange(v90.ThrowGlaive)) or (736 < 356)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\18\23\64\200\187\77\140\10\30\91\209\169\50\141\15\19\94\194\190\50\211", "\235\102\127\50\167\204\18");
					end
				end
				break;
			end
		end
	end
	local function v115()
		local v133 = 0;
		local v134;
		while true do
			if ((1171 <= 2774) and (v133 == 1)) then
				if ((4108 >= 312) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\37\195\123\104\6\208\118\95\23\199\99\69\12\200", "\44\99\166\23")]:IsReady() and (v79 < v105) and v57 and ((v39 and v61) or not v61)) then
					if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or (679 > 2893)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\122\242\37\9\55\161\106\246\58\34\50\176\117\248\39\118\49\173\123\200\40\57\54\228\36", "\196\28\151\73\86\83");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\192\12\60\28\161\89\10\96\246\17", "\22\147\99\73\112\226\56\120")]:IsCastable() and v58) or (876 < 200)) then
					if (v25(v90.SoulCarver, not v97) or (2325 > 3562)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\171\122\247\249\178\187\116\240\227\136\170\53\224\252\138\135\116\237\240\205\233\37", "\237\216\21\130\149");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\177\94\86\77\185\221\124\141\67\93", "\62\226\46\63\63\208\169")]:IsReady() and (v94 >= 4) and v49) or (3661 > 4704)) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or (4133 <= 1928)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\246\9\92\145\22\25\16\92\234\20\87\195\29\4\40\97\228\22\80\195\78\95", "\62\133\121\53\227\127\109\79");
					end
				end
				v133 = 2;
			end
			if ((4418 >= 1433) and (3 == v133)) then
				v134 = v114();
				if (v134 or (4123 >= 4123)) then
					return v134;
				end
				break;
			end
			if ((v133 == 0) or (205 >= 2345)) then
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\118\164\249\7\65\56\81\178\225\34\80\39\95\175", "\78\48\193\149\67\36")]:IsReady() and (v79 < v105) and v57 and ((v39 and v61) or not v61) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\19\17\140\20\68\51\10\137\14\68\17\16\135\13\72\35\22", "\33\80\126\224\120")]:IsAvailable() or v90[LUAOBFUSACTOR_DECRYPT_STR_0("\223\188\12\207\89\248\160\6\226\80\237\165\6\215", "\60\140\200\99\164")]:IsAvailable())) or (537 == 1004)) then
					if (v25(v90.FelDevastation, not v15:IsInMeleeRange(v35)) or (2345 < 545)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\129\241\8\25\166\130\226\5\53\182\134\224\13\41\172\199\246\13\33\157\134\251\1\102\240", "\194\231\148\100\70");
					end
				end
				if ((1649 > 243) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\114\68\196\139\227\198\82", "\168\38\44\161\195\150")]:IsCastable() and (v79 < v105) and v59 and ((v39 and v63) or not v63)) then
					if (v25(v90.TheHunt, not v15:IsInRange(50)) or (3910 <= 3193)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\148\244\135\73\56\253\184\2\192\254\139\113\15\233\185\19\192\168", "\118\224\156\226\22\80\136\214");
					end
				end
				if ((2005 == 2005) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\103\226\64\147\75\239\87\164\71\237\75\133\71", "\224\34\142\57")]:IsCastable() and (v79 < v105) and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v102 > v65)) then
					if ((4688 > 4572) and (v64 == LUAOBFUSACTOR_DECRYPT_STR_0("\206\171\196\196\118\227", "\110\190\199\165\189\19\145\61"))) then
						if ((1567 < 3260) and v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\223\231\110\251\130\198\212\212\115\237\136\213\223\238\55\234\130\192\229\234\120\237\203\145\154\163\71\228\138\222\223\249\62", "\167\186\139\23\136\235");
						end
					elseif ((v64 == LUAOBFUSACTOR_DECRYPT_STR_0("\25\160\154\30\21\167", "\109\122\213\232")) or (3761 == 621)) then
						if ((4755 > 3454) and v25(v92.ElysianDecreeCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\235\251\187\35\231\246\172\15\234\242\161\34\235\242\226\50\231\240\157\49\225\242\226\102\174\191\129\37\252\228\173\34\167", "\80\142\151\194");
						end
					end
				end
				v133 = 1;
			end
			if ((4819 >= 1607) and (2 == v133)) then
				if ((4546 >= 1896) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\54\6\51\246\194\187\176\21", "\194\112\116\82\149\182\206")]:IsCastable() and v43) then
					if ((3546 > 933) and v25(v90.Fracture, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\186\77\27\212\247\28\60\232\78\17\199\221\15\54\173\12\73\148", "\110\89\200\44\120\160\130");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\152\203\78\71\81", "\45\203\163\43\38\35\42\91")]:IsCastable() and v46) or (3985 <= 3160)) then
					if ((1987 == 1987) and v25(v90.Shear, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\193\141\217\34\149\233\86\219\130\227\34\136\172\20\131\211", "\52\178\229\188\67\231\201");
					end
				end
				if ((994 <= 4540) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\18\78\69\8\212\80\38\32\87\85", "\67\65\33\48\100\151\60")]:IsReady() and (v94 < 1) and v48) then
					if ((4917 == 4917) and v25(v90.SoulCleave, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\204\232\187\212\204\220\235\171\217\229\218\167\172\209\244\224\230\161\221\179\142\191", "\147\191\135\206\184");
					end
				end
				v133 = 3;
			end
		end
	end
	local function v116()
		local v135 = 0;
		while true do
			if ((v135 == 2) or (324 > 4896)) then
				if ((772 < 4670) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\52\143\167\120\21\137\182", "\48\96\231\194")]:IsCastable() and v59 and ((v39 and v63) or not v63) and (v79 < v105)) then
					if ((3172 >= 2578) and v25(v90.TheHunt, not v15:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\220\82\11\18\17\205\161\151\136\92\7\40\11\193\144\135\205\87\7\62\28\152\254\219", "\227\168\58\110\77\121\184\207");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\94\48\166\83\184\218\127\129\126\63\173\69\180", "\197\27\92\223\32\209\187\17")]:IsCastable() and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v79 < v105) and (v102 > v65)) or (721 == 834)) then
					if ((1312 < 2654) and (v64 == LUAOBFUSACTOR_DECRYPT_STR_0("\19\83\194\226\6\77", "\155\99\63\163"))) then
						if ((3213 >= 1613) and v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\135\221\184\158\176\133\140\238\165\136\186\150\135\212\225\139\176\129\144\200\158\137\188\137\139\194\164\205\235\212\194\153\145\129\184\157\135\195\232", "\228\226\177\193\237\217");
						end
					elseif ((v64 == LUAOBFUSACTOR_DECRYPT_STR_0("\55\165\49\245\59\162", "\134\84\208\67")) or (3786 > 4196)) then
						if ((4218 == 4218) and v25(v92.ElysianDecreeCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\22\160\159\79\26\173\136\99\23\169\133\78\22\169\198\90\26\169\148\69\44\168\131\81\26\191\131\28\65\252\198\20\48\185\148\79\28\190\207", "\60\115\204\230");
						end
					end
				end
				if ((1517 < 4050) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\212\53\254\124\196\54\238\113\241\63", "\16\135\90\139")]:IsReady() and (v14:FuryDeficit() <= 30) and not v103 and v48) then
					if ((4390 == 4390) and v25(v90.SoulCleave, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\71\123\19\63\113\87\116\81\117\16\54\14\82\113\81\102\31\12\74\81\117\93\103\3\115\28\6", "\24\52\20\102\83\46\52");
					end
				end
				break;
			end
			if ((1919 > 289) and (v135 == 1)) then
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\144\67\148\16\159\14\177\90\132\14", "\111\195\44\225\124\220")]:IsCastable() and v58) or (1205 < 751)) then
					if (v25(v90.SoulCarver, not v15:IsInMeleeRange(v35)) or (2561 <= 1717)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\203\73\21\127\148\168\217\84\22\118\185\235\222\79\5\97\178\148\220\67\13\122\184\174\152\23\80", "\203\184\38\96\19\203");
					end
				end
				if ((1723 <= 3600) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\10\99\112\83\199\45\81\118\76\204", "\174\89\19\25\33")]:IsReady() and (v102 == 1) and (v94 >= 5) and v49) then
					if ((3271 >= 1633) and v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\60\2\91\92\254\147\52\45\29\95\76\183\129\2\42\0\75\113\243\130\6\38\1\87\14\166\213", "\107\79\114\50\46\151\231");
					end
				end
				if ((3103 >= 2873) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\10\182\188\59\131\45\149\207\52\164", "\160\89\198\213\73\234\89\215")]:IsReady() and (v102 > 1) and (v102 <= 5) and (v94 >= 4) and v49) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or (3603 == 725)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\97\189\236\204\92\78\182\241\200\74\49\178\247\192\90\104\139\250\192\69\120\167\251\133\25\37", "\165\40\17\212\158");
					end
				end
				if ((2843 == 2843) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\214\201\1\33\47\241\251\7\62\36", "\70\133\185\104\83")]:IsReady() and (v102 >= 6) and (v94 >= 3) and v49) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or (174 >= 2515)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\23\85\77\56\192\16\122\70\37\196\6\5\66\35\204\22\92\123\46\204\9\76\87\47\137\85\19", "\169\100\37\36\74");
					end
				end
				v135 = 2;
			end
			if ((4411 >= 2020) and (v135 == 0)) then
				if ((1347 == 1347) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\173\37\171\206\212\82\166\141\39\168\224\205\65\179", "\210\228\72\198\161\184\51")]:IsCastable() and v44) then
					if ((4461 == 4461) and v25(v90.ImmolationAura, not v15:IsInMeleeRange(v35))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\63\68\254\31\127\207\34\64\252\30\76\207\35\91\242\80\117\199\51\91\234\47\119\203\59\64\224\21\51\156", "\174\86\41\147\112\19");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\104\9\138\2\41\32\23\141\87\1\128\14", "\203\59\96\237\107\69\111\113")]:IsCastable() and v47 and not v14:IsMoving() and (v98 or not v90[LUAOBFUSACTOR_DECRYPT_STR_0("\7\25\162\226\52\254\195\54\23\184\228\53\195\222\35\31\160\242", "\183\68\118\204\129\81\144")]:IsAvailable()) and v15:DebuffRefreshable(v90.SigilOfFlameDebuff)) or (4340 == 2872)) then
					if ((568 <= 2207) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\45\162\126\231\14\140\26\191\113\240\14\134\61\164\119\237\7\145", "\226\110\205\16\132\107")]:IsAvailable() or (v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\251\207\225\192\68\249", "\33\139\163\128\185")))) then
						if (v25(v92.SigilOfFlamePlayer, not v15:IsInMeleeRange(v35)) or (3789 <= 863)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\68\81\3\215\91\103\11\216\104\94\8\223\90\93\68\216\94\93\22\199\104\92\1\211\94\75\1\158\3\24\76\238\91\89\29\219\69\17", "\190\55\56\100");
						end
					elseif ((238 < 4997) and (v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\85\186\46\13\28\241", "\147\54\207\92\126\115\131"))) then
						if ((4285 > 3803) and v25(v92.SigilOfFlameCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\30\56\50\116\1\65\2\55\10\123\1\127\0\52\117\123\4\123\31\40\10\121\8\115\4\34\48\61\89\62\69\18\32\111\30\113\31\120", "\30\109\81\85\29\109");
						end
					end
				end
				if ((2672 < 4910) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\217\116\88\180\58\223\248\250", "\156\159\17\52\214\86\190")]:IsCastable() and v42 and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\136\234\177\152\171\249\188\175\186\238\169\181\161\225", "\220\206\143\221")]:CooldownRemains() <= (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\160\120\33\51\221\218\211\149\105\44\3\209\195\220", "\178\230\29\77\119\184\172")]:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < 50)) then
					if (v25(v90.Felblade, not v97) or (2956 > 4353)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\243\187\6\25\123\249\241\187\74\29\126\253\231\167\53\31\114\245\252\173\15\91\33", "\152\149\222\106\123\23");
					end
				end
				if ((3534 > 2097) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\251\35\250\103\176\203\39\229\87\180\201\47\249\77", "\213\189\70\150\35")]:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105)) then
					if ((3255 >= 534) and v25(v90.FelDevastation, not v15:IsInMeleeRange(v35))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\73\80\120\55\75\80\98\9\92\65\117\28\70\90\122\72\73\92\113\26\86\106\112\13\66\92\103\13\15\13", "\104\47\53\20");
					end
				end
				v135 = 1;
			end
		end
	end
	local function v117()
		local v136 = 0;
		while true do
			if ((4254 < 4460) and (v136 == 0)) then
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\226\38\36\54\22\230\61\32\42\11", "\111\164\79\65\68")]:IsCastable() and v67 and ((v15:DebuffDown(v90.FieryBrandDebuff) and ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\245\208\132\215\34\197\192\255\143\223\35\239", "\138\166\185\227\190\78")]:CooldownRemains() < (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\248\125\194\62\94\12\31\237\120\196\58\87", "\121\171\20\165\87\50\67")]:ExecuteTime() + v14:GCDRemains())) or (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\245\55\172\58\154\3\212\46\188\36", "\98\166\88\217\86\217")]:CooldownRemains() < (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\197\249\108\13\165\221\228\224\124\19", "\188\150\150\25\97\230")]:ExecuteTime() + v14:GCDRemains())) or (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\252\140\83\38\9\251\219\154\75\3\24\228\213\135", "\141\186\233\63\98\108")]:CooldownRemains() < (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\215\239\32\146\32\231\235\63\162\36\229\227\35\184", "\69\145\138\76\214")]:ExecuteTime() + v14:GCDRemains())))) or (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\84\192\158\135\150\24\86\195\136\132\186\5", "\118\16\175\233\233\223")]:IsAvailable() and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\173\141\48\169\247\169\111\138\138\49", "\29\235\228\85\219\142\235")]:FullRechargeTime() < (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\27\221\191\207\110\108\53\83\51\208", "\50\93\180\218\189\23\46\71")]:ExecuteTime() + v14:GCDRemains()))))) or (4661 <= 4405)) then
					if ((4575 >= 1943) and v25(v90.FieryBrand, not v15:IsSpellInRange(v90.FieryBrand))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\216\173\94\94\93\227\74\204\165\85\72\4\209\73\215\170\79\73\74\221\70\221\161\27\30", "\40\190\196\59\44\36\188");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\15\76\219\189\246\82\11\26\73\221\185\255", "\109\92\37\188\212\154\29")]:IsCastable() and not v14:IsMoving()) or (326 > 1137)) then
					if ((1284 == 1284) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\39\224\170\192\52\84\16\253\165\215\52\94\55\230\163\202\61\73", "\58\100\143\196\163\81")]:IsAvailable() or (v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\10\78\34\186\58\91", "\110\122\34\67\195\95\41\133")))) then
						if (v25(v92.SigilOfFlamePlayer, not v15:IsInMeleeRange(v35)) or (3072 >= 3426)) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\102\184\92\67\218\74\190\93\117\208\121\176\86\79\150\120\176\82\68\194\112\191\90\68\213\112\241\15\10\158\69\189\90\83\211\103\248", "\182\21\209\59\42");
						end
					elseif ((v87 == LUAOBFUSACTOR_DECRYPT_STR_0("\180\66\215\14\46\172", "\222\215\55\165\125\65")) or (4036 > 4375)) then
						if ((3928 == 3928) and v25(v92.SigilOfFlameCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\63\216\193\19\254\254\226\76\19\215\202\27\255\196\173\71\45\216\200\14\247\207\236\68\47\212\134\78\178\137\206\95\62\194\201\8\187", "\42\76\177\166\122\146\161\141");
						end
					end
				end
				v136 = 1;
			end
			if ((2 == v136) or (2629 >= 3005)) then
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\23\152\119\84\247\183\160\202\52\142\111\86\221\161", "\184\85\237\27\63\178\207\212")]:IsCastable() and v40 and v14:PrevGCD(1, v90.SpiritBomb)) or (2620 <= 422)) then
					if ((1896 > 1857) and v25(v90.BulkExtraction, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\10\76\5\84\55\92\17\75\26\88\10\75\1\86\7\31\5\88\0\81\28\92\7\94\6\90\12\31\89\9", "\63\104\57\105");
					end
				end
				if ((1466 >= 492) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\45\130\168\70\7\134\160\65", "\36\107\231\196")]:IsCastable() and v42 and (v14:FuryDeficit() >= 40)) then
					if ((868 < 3853) and v25(v90.Felblade, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\176\174\133\81\180\166\130\29\184\163\142\83\161\167\137\92\187\161\130\29\228\240", "\231\61\213\194");
					end
				end
				v136 = 3;
			end
			if ((v136 == 1) or (1815 > 4717)) then
				if ((3671 == 3671) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\150\154\12\220\112\98\135\133\8\204", "\22\197\234\101\174\25")]:IsReady() and (v94 >= 5) and v49) then
					if ((216 <= 284) and v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\62\36\172\206\127\187\232\132\34\57\167\156\123\174\222\136\57\49\171\221\120\172\210\198\123", "\230\77\84\197\188\22\207\183");
					end
				end
				if ((3257 > 2207) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\208\25\203\243\128\160\228\60\246\26\231\233\158\160", "\85\153\116\166\156\236\193\144")]:IsCastable() and v44) then
					if (v25(v90.ImmolationAura, not v15:IsInMeleeRange(v35)) or (2087 < 137)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\173\237\64\188\232\1\176\233\66\189\219\1\177\242\76\243\233\1\173\238\89\182\234\1\170\227\72\243\188", "\96\196\128\45\211\132");
					end
				end
				v136 = 2;
			end
			if ((v136 == 4) or (3923 >= 4763)) then
				if ((1744 == 1744) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\206\54\12\0\0\52\223\41\8\16", "\64\157\70\101\114\105")]:IsReady() and (v14:FuryDeficit() < 30) and (((v102 >= 2) and (v94 >= 5)) or ((v102 >= 6) and (v94 >= 4))) and not v103 and v49) then
					if ((248 <= 1150) and v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\83\184\174\241\25\84\151\165\236\29\66\232\170\226\25\78\188\162\237\17\78\171\162\163\65\24", "\112\32\200\199\131");
					end
				end
				if ((3994 >= 294) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\31\95\73\180\224\167\39\45\70\89", "\66\76\48\60\216\163\203")]:IsReady() and (v14:FuryDeficit() < 30) and (v94 <= 3) and not v103 and v48) then
					if ((1641 > 693) and v25(v90.SoulCleave, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\169\137\108\255\96\205\40\191\135\111\246\31\195\37\179\136\109\246\81\207\42\185\131\57\161\15", "\68\218\230\25\147\63\174");
					end
				end
				break;
			end
			if ((v136 == 3) or (4519 < 2235)) then
				if ((892 < 1213) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\47\191\60\112\29\184\47\118", "\19\105\205\93")]:IsCastable() and v43 and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\143\13\210\165\58\191\9\205\149\62\189\1\209\143", "\95\201\104\190\225")]:CooldownRemains() <= (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\137\206\205\234\170\221\192\221\187\202\213\199\160\197", "\174\207\171\161")]:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < 50)) then
					if ((3313 <= 4655) and v25(v90.Fracture, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\235\236\12\240\236\194\255\251\77\254\249\222\227\234\8\253\249\217\238\251\77\162\172", "\183\141\158\109\147\152");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\31\1\227\13\62", "\108\76\105\134")]:IsCastable() and v46 and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\205\192\189\197\203\253\196\162\245\207\255\204\190\239", "\174\139\165\209\129")]:CooldownRemains() <= (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\133\182\238\229\195\21\113\107\183\178\246\200\201\13", "\24\195\211\130\161\166\99\16")]:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < 50)) or (3956 < 2705)) then
					if ((1959 < 3037) and v25(v90.Shear, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\85\11\236\45\65\86\75\2\224\34\71\19\72\2\231\47\86\86\23\85", "\118\38\99\137\76\51");
					end
				end
				v136 = 4;
			end
		end
	end
	local function v118()
		local v137 = 0;
		local v138;
		while true do
			if ((v137 == 1) or (1241 > 2213)) then
				if ((4905 < 4974) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\170\221\26\253\189\70\141\203\2\216\172\89\131\214", "\48\236\184\118\185\216")]:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105)) then
					if ((3557 == 3557) and v25(v90.FelDevastation, not v15:IsInMeleeRange(v35))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\227\184\91\15\203\49\243\188\68\36\206\32\236\178\89\112\220\61\235\186\91\53\240\32\228\175\80\53\219\116\180\237", "\84\133\221\55\80\175");
					end
				end
				if ((369 == 369) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\142\232\49\170\228\80\184\230\50\163", "\60\221\135\68\198\167")]:IsReady() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\200\178\251\150\81\220\234\158\244\134\67\207\235", "\185\142\221\152\227\34")]:IsAvailable() and not v103 and v48) then
					if (v25(v90.SoulCleave, not v97) or (3589 < 2987)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\75\202\66\246\124\48\251\93\196\65\255\3\32\254\86\194\91\255\124\39\246\74\194\82\238\3\98\165", "\151\56\165\55\154\35\83");
					end
				end
				if ((4378 > 2853) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\134\81\4\237\180\86\23\235", "\142\192\35\101")]:IsCastable() and v43) then
					if (v25(v90.Fracture, not v97) or (1712 > 3602)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\208\103\40\160\243\153\190\19\150\102\32\173\224\128\169\41\194\116\59\164\226\152\236\71\130", "\118\182\21\73\195\135\236\204");
					end
				end
				if ((4539 >= 2733) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\59\52\31\65\22", "\157\104\92\122\32\100\109")]:IsCastable() and v46) then
					if (v25(v90.Shear, not v97) or (2599 <= 515)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\176\174\202\203\47\103\158\162\173\161\195\207\2\51\140\185\164\163\219\138\108\113", "\203\195\198\175\170\93\71\237");
					end
				end
				v137 = 2;
			end
			if ((v137 == 0) or (3754 < 810)) then
				if ((1633 <= 1977) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\153\34\86\100\163\163\62", "\214\205\74\51\44")]:IsCastable() and v59 and ((v39 and v63) or not v63) and (v79 < v105)) then
					if ((4528 >= 3619) and v25(v90.TheHunt, not v15:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\238\68\231\195\127\239\66\246\188\100\243\66\229\240\114\197\88\227\238\112\255\88\162\174", "\23\154\44\130\156");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\34\169\184\162\21\18\3\176\168\188", "\115\113\198\205\206\86")]:IsCastable() and v58) or (172 >= 2092)) then
					if ((2120 == 2120) and v25(v90.SoulCarver, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\151\88\235\86\187\84\255\72\146\82\236\26\151\94\240\93\136\82\193\78\133\69\249\95\144\23\170", "\58\228\55\158");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\146\140\220\10\57\187\52\167\157\209\58\53\162\59", "\85\212\233\176\78\92\205")]:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\105\87\132\238\79\91\156\235\92\93\169\236\77\77\129\241\66", "\130\42\56\232")]:IsAvailable() or (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\217\161\43\232\69\43\226\176\2\239\65\50\239\166", "\95\138\213\68\131\32")]:IsAvailable() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\8\61\179\77\127\36\47\131\79\121\37\44", "\22\74\72\193\35")]:IsAvailable()))) or (2398 == 358)) then
					if ((2387 < 4637) and v25(v90.FelDevastation, not v15:IsInMeleeRange(v35))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\42\124\232\103\40\124\242\89\63\109\229\76\37\118\234\24\63\112\234\95\32\124\219\76\45\107\227\93\56\57\178", "\56\76\25\132");
					end
				end
				if ((1265 < 2775) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\123\205\178\53\198\95\207\143\35\204\76\196\174", "\175\62\161\203\70")]:IsCastable() and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v79 < v105) and (v102 > v65)) then
					if ((v64 == LUAOBFUSACTOR_DECRYPT_STR_0("\44\209\194\10\48\46", "\85\92\189\163\115")) or (4430 < 51)) then
						if ((1871 <= 1998) and v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\44\160\41\43\32\173\62\7\45\169\51\42\44\169\112\43\32\162\55\52\44\147\36\57\59\171\53\44\105\244\112\112\25\160\49\33\44\190\121", "\88\73\204\80");
						end
					elseif ((v64 == LUAOBFUSACTOR_DECRYPT_STR_0("\45\150\2\85\38\200", "\186\78\227\112\38\73")) or (2083 >= 3954)) then
						if ((1857 > 59) and v25(v92.ElysianDecreeCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\249\91\228\70\90\123\242\104\249\80\80\104\249\82\189\70\90\116\251\91\248\106\71\123\238\80\248\65\19\34\188\31\222\64\65\105\243\69\180", "\26\156\55\157\53\51");
						end
					end
				end
				v137 = 1;
			end
			if ((v137 == 2) or (1232 == 3045)) then
				if ((104 == 104) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\29\68\43\217\114\29\249\47\93\59", "\156\78\43\94\181\49\113")]:IsReady() and not v103 and v48) then
					if ((4534 > 2967) and v25(v90.SoulCleave, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\97\231\209\175\52\64\117\119\233\210\166\75\80\112\124\239\200\166\52\87\120\96\239\193\183\75\18\33", "\25\18\136\164\195\107\35");
					end
				end
				v138 = v114();
				if (v138 or (3449 <= 2368)) then
					return v138;
				end
				break;
			end
		end
	end
	local function v119()
		local v139 = 0;
		local v140;
		while true do
			if ((4733 >= 3548) and (1 == v139)) then
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\73\179\39\120\165\52\105\157\127\174", "\235\26\220\82\20\230\85\27")]:IsCastable() and v58) or (2005 > 4687)) then
					if (v25(v90.SoulCarver, not v97) or (1767 <= 916)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\155\174\252\206\75\139\160\251\212\113\154\225\250\207\117\132\173\214\195\123\141\225\184\146", "\20\232\193\137\162");
					end
				end
				if ((3589 < 3682) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\17\207\204\180\238\152\53\126\47\221", "\17\66\191\165\198\135\236\119")]:IsReady() and (v94 >= 5) and v49) then
					if (v25(v90.SpiritBomb, not v15:IsInMeleeRange(v35)) or (75 >= 430)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\28\191\167\1\246\252\211\211\0\162\172\83\236\229\237\221\3\144\175\28\250\168\189\131", "\177\111\207\206\115\159\136\140");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\54\134\5\24\247\67\90\4\159\21", "\63\101\233\112\116\180\47")]:IsReady() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\229\52\238\7\235\51\199\24\225\23\249\32\198", "\86\163\91\141\114\152")]:IsAvailable() and (v94 <= 2) and v48) or (4157 <= 3219)) then
					if ((1823 < 2782) and v25(v90.SoulCleave, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\64\4\97\127\5\80\7\113\114\44\86\75\103\126\59\95\7\75\114\53\86\75\37\39", "\90\51\107\20\19");
					end
				end
				if ((3434 >= 1764) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\171\226\132\236\41\152\226\128", "\93\237\144\229\143")]:IsCastable() and v43) then
					if ((4040 > 1820) and v25(v90.Fracture, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\19\228\241\26\31\83\7\243\176\10\6\71\25\250\207\24\4\67\85\167\166", "\38\117\150\144\121\107");
					end
				end
				v139 = 2;
			end
			if ((4192 >= 2529) and (v139 == 2)) then
				if ((1554 < 2325) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\30\179\235\59\63", "\90\77\219\142")]:IsCastable() and v46) then
					if ((1108 < 4525) and v25(v90.Shear, not v97)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\245\12\36\56\94\71\105\235\5\45\53\115\6\117\227\68\112\97", "\26\134\100\65\89\44\103");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\194\236\37\47\135\253\230\49\53\161", "\196\145\131\80\67")]:IsReady() and (v94 <= 2) and v48) or (4367 <= 3332)) then
					if (v25(v90.SoulCleave, not v97) or (2896 > 4641)) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\13\191\19\4\39\235\18\181\7\30\29\168\13\189\7\4\20\215\31\191\3\72\74\184", "\136\126\208\102\104\120");
					end
				end
				v140 = v114();
				if ((882 > 21) and v140) then
					return v140;
				end
				break;
			end
			if ((2373 <= 4789) and (v139 == 0)) then
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\220\37\172\103\103\178\213", "\216\136\77\201\47\18\220\161")]:IsCastable() and v59 and ((v39 and v63) or not v63) and (v79 < v105)) or (1839 < 1136)) then
					if ((3430 == 3430) and v25(v90.TheHunt, not v15:IsInRange(30))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\57\228\46\229\0\201\140\57\172\56\215\9\208\142\18\237\36\223\72\142", "\226\77\140\75\186\104\188");
					end
				end
				if ((748 <= 2288) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\159\203\220\27\74\175\207\195\43\78\173\199\223\49", "\47\217\174\176\95")]:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\155\210\122\14\183\87\108\47\174\216\87\12\181\65\113\53\176", "\70\216\189\22\98\210\52\24")]:IsAvailable() or (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\233\203\172\140\214\206\215\166\161\223\219\210\166\148", "\179\186\191\195\231")]:IsAvailable() and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\219\42\10\234\240\49\31\198\245\48\23\224", "\132\153\95\120")]:IsAvailable()))) then
					if ((891 < 4473) and v25(v90.FelDevastation, not v15:IsInMeleeRange(v35))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\183\183\2\18\243\223\182\176\161\26\44\227\211\175\191\242\29\32\246\214\172\142\179\1\40\183\142", "\192\209\210\110\77\151\186");
					end
				end
				if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\197\15\59\250\246\197\238\39\39\234\237\193\229", "\164\128\99\66\137\159")]:IsCastable() and v56 and not v14:IsMoving() and ((v39 and v60) or not v60) and (v79 < v105) and (v102 > v65)) or (3071 <= 2647)) then
					if ((v64 == LUAOBFUSACTOR_DECRYPT_STR_0("\16\133\232\167\5\155", "\222\96\233\137")) or (633 > 1640)) then
						if ((3764 > 2404) and v25(v92.ElysianDecreePlayer, not v15:IsInMeleeRange(v35))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\188\191\190\12\129\242\254\134\183\162\28\154\246\245\249\160\170\30\132\255\207\184\188\162\95\222\179\184\137\191\166\6\141\225\185", "\144\217\211\199\127\232\147");
						end
					elseif ((v64 == LUAOBFUSACTOR_DECRYPT_STR_0("\251\58\44\59\218\87", "\36\152\79\94\72\181\37\98")) or (3811 >= 4158)) then
						if ((743 > 47) and v25(v92.ElysianDecreeCursor, not v15:IsInRange(30))) then
							return LUAOBFUSACTOR_DECRYPT_STR_0("\210\212\94\44\222\217\73\0\211\221\68\45\210\221\7\44\218\217\75\51\232\217\72\58\151\142\7\119\244\205\85\44\216\202\14", "\95\183\184\39");
						end
					end
				end
				if ((3599 >= 1059) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\147\58\235\2\81\150\3\166\43\230\50\93\143\12", "\98\213\95\135\70\52\224")]:IsReady() and v57 and ((v39 and v61) or not v61) and (v79 < v105)) then
					if ((1371 <= 2507) and v25(v90.FelDevastation, not v15:IsInMeleeRange(v35))) then
						return LUAOBFUSACTOR_DECRYPT_STR_0("\248\166\197\72\80\251\181\200\100\64\255\183\192\120\90\190\176\196\118\88\242\156\200\120\81\190\251", "\52\158\195\169\23");
					end
				end
				v139 = 1;
			end
		end
	end
	local function v120()
		local v141 = 0;
		while true do
			if ((v141 == 5) or (3607 == 2536)) then
				v67 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\126\20\56\251\68\31\43\252", "\143\45\113\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\173\171\25\26\177\189\14\37\154\170\29\50\188", "\92\216\216\124")];
				v68 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\104\55\184\84\244\85\53\191", "\157\59\82\204\32")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\45\230\215\236\254\210\188\55\44\243\242\230\249\218\162", "\209\88\94\131\154\137\138\179")];
				v69 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\27\164\208\104\23\45\54\49", "\66\72\193\164\28\126\67\81")][LUAOBFUSACTOR_DECRYPT_STR_0("\227\41\165\87\40\69\247\37\163\93\53\94\215", "\22\135\76\200\56\70")] or 0;
				v70 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\190\53\236\48\84\239\138\35", "\129\237\80\152\68\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\87\161\1\225\5\53\74\80\166\0\219\44", "\56\49\200\100\147\124\119")] or 0;
				v71 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\255\59\171\228\197\48\184\227", "\144\172\94\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\41\10\182\70\41\0\176\87\44\0\177\78\55\39\146", "\39\68\111\194")] or 0;
				v141 = 6;
			end
			if ((1126 < 3675) and (2 == v141)) then
				v50 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\230\206\226\187\170\248\123\172", "\223\181\171\150\207\195\150\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\89\41\230\154\1\94\53\244\137\5\77\51\245\171", "\105\44\90\131\206")];
				v51 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\229\166\173\1\48\248\243", "\94\159\128\210\217\104")][LUAOBFUSACTOR_DECRYPT_STR_0("\69\234\3\156\87\126\246\105\126\246\16\190", "\26\48\153\102\223\63\31\153")];
				v52 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\49\69\249\231\11\78\234\224", "\147\98\32\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\13\80\230\238\15\69\89\13\83\247", "\43\120\35\131\170\102\54")];
				v53 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\103\3\147\162\172\190\131\71", "\228\52\102\231\214\197\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\11\243\112\249\227\140\16\218\49\230\70\195\230\142\23\213\27", "\182\126\128\21\170\138\235\121")];
				v54 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\184\223\33\242\143\29\55\21", "\102\235\186\85\134\230\115\80")][LUAOBFUSACTOR_DECRYPT_STR_0("\66\31\59\108\123\211\43\91\35\56\124\122\213\43\89\31", "\66\55\108\94\63\18\180")];
				v141 = 3;
			end
			if ((v141 == 3) or (3344 >= 3615)) then
				v55 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\39\136\145\35\46\87\19\158", "\57\116\237\229\87\71")][LUAOBFUSACTOR_DECRYPT_STR_0("\191\162\232\212\126\233\78\166\158\235\202\126\253\66\184\168", "\39\202\209\141\135\23\142")];
				v56 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\204\54\29\30\59\246\248\32", "\152\159\83\105\106\82")][LUAOBFUSACTOR_DECRYPT_STR_0("\148\213\84\215\197\69\146\207\80\252\237\89\130\212\84\247", "\60\225\166\49\146\169")];
				v57 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\28\27\59\62\8\9\40\13", "\103\79\126\79\74\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\175\108\214\85\91\22\158\122\197\114\77\14\187\107\218\124\80", "\122\218\31\179\19\62")];
				v58 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\128\211\217\213\192\175\66\160", "\37\211\182\173\161\169\193")][LUAOBFUSACTOR_DECRYPT_STR_0("\226\41\72\234\39\110\181\212\59\95\207\45\105", "\217\151\90\45\185\72\27")];
				v59 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\121\243\6\95\205\123\244", "\54\163\28\135\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\61\200\88\182\70\122\0\206\83\150", "\31\72\187\61\226\46")];
				v141 = 4;
			end
			if ((0 == v141) or (4776 <= 210)) then
				v40 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\75\143\218\87\166\92\58\66", "\49\24\234\174\35\207\50\93")][LUAOBFUSACTOR_DECRYPT_STR_0("\25\225\248\170\100\0\249\216\144\101\30\243\254\156\120\3\252", "\17\108\146\157\232")];
				v41 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\120\198\0\249\38\166\76\208", "\200\43\163\116\141\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\170\37\56\160\191\250\240\170\59\56\174\177\243\234\188", "\131\223\86\93\227\208\148")];
				v42 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\208\64\162\162\20\187\228\86", "\213\131\37\214\214\125")][LUAOBFUSACTOR_DECRYPT_STR_0("\51\56\32\153\228\42\41\41\190\229\35", "\129\70\75\69\223")];
				v43 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\117\206\231\253\117\225\65\216", "\143\38\171\147\137\28")][LUAOBFUSACTOR_DECRYPT_STR_0("\197\145\188\213\17\226\215\196\151\171\246", "\180\176\226\217\147\99\131")];
				v44 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\224\188\59\19\218\183\40\20", "\103\179\217\79")][LUAOBFUSACTOR_DECRYPT_STR_0("\95\164\25\252\76\129\172\70\182\8\220\78\130\130\95\165\29", "\195\42\215\124\181\33\236")];
				v141 = 1;
			end
			if ((v141 == 6) or (2613 > 2752)) then
				v87 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\229\163\243\211\112\185\209\181", "\215\182\198\135\167\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\64\237\65\129\122\239\92\153\64\228\79", "\40\237\41\138")] or LUAOBFUSACTOR_DECRYPT_STR_0("\215\120\251\225\79\213", "\42\167\20\154\152");
				v64 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\251\182\86\120\47\77\237", "\65\42\158\194\34\17")][LUAOBFUSACTOR_DECRYPT_STR_0("\31\43\75\31\36\236\21\202\31\36\64\9\40\222\30\250\14\46\92\11", "\142\122\71\50\108\77\141\123")] or LUAOBFUSACTOR_DECRYPT_STR_0("\5\174\254\1\62\7", "\91\117\194\159\120");
				v65 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\41\24\42\12\60\255\35\9", "\68\122\125\94\120\85\145")][LUAOBFUSACTOR_DECRYPT_STR_0("\18\16\214\77\193\216\180\51\25\204\76\205\220\137\27\21\203\91\218", "\218\119\124\175\62\168\185")] or 0;
				v88 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\150\245\92\208\172\254\79\215", "\164\197\144\40")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\249\175\153\196\148\145\241\164\143\242\176\133\245\164\152\212\160\134\252\179", "\214\227\144\202\235\189")];
				v89 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\222\160\147\111\25\189\84\47", "\92\141\197\231\27\112\211\51")][LUAOBFUSACTOR_DECRYPT_STR_0("\235\250\158\162\220\233\237\154\171\222\245\246\153\140\215\224\250\132\176\216\240\250\134\186", "\177\134\159\234\195")];
				break;
			end
			if ((4542 > 2119) and (v141 == 1)) then
				v45 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\62\92\35\42\44\246\10\74", "\152\109\57\87\94\69")][LUAOBFUSACTOR_DECRYPT_STR_0("\236\196\15\138\176\212\81\186\247\214\6\144\170\192\93\163\252", "\200\153\183\106\195\222\178\52")];
				v46 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\1\230\156\41\64\84\53\240", "\58\82\131\232\93\41")][LUAOBFUSACTOR_DECRYPT_STR_0("\150\68\213\38\85\58\130\69", "\95\227\55\176\117\61")];
				v47 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\43\123\55\95\162\22\121\48", "\203\120\30\67\43")][LUAOBFUSACTOR_DECRYPT_STR_0("\228\54\72\220\208\246\44\65\192\223\215\41\76\226\220", "\185\145\69\45\143")];
				v48 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\185\26\13\178\213\132\24\10", "\188\234\127\121\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\33\22\176\55\39\31\160\52\55\18\149\61", "\227\88\82\115")];
				v49 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\112\26\174\179\11\125\68\12", "\19\35\127\218\199\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\232\15\209\12\242\24\235\8\217\5\239\30", "\130\124\155\106")];
				v141 = 2;
			end
			if ((v141 == 4) or (1039 == 338)) then
				v60 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\3\87\198\78\112\35\208", "\68\163\102\35\178\39\30")][LUAOBFUSACTOR_DECRYPT_STR_0("\187\124\195\212\10\180\141\53\187\115\200\194\6\130\138\5\182\83\254", "\113\222\16\186\167\99\213\227")];
				v61 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\11\239\226\39\0\252\229", "\150\78\110\155")][LUAOBFUSACTOR_DECRYPT_STR_0("\131\192\43\197\161\8\190\83\145\196\51\232\171\16\136\73\145\205\4\197", "\32\229\165\71\129\196\126\223")];
				v62 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\240\140\208\149\136\219\196\154", "\181\163\233\164\225\225")][LUAOBFUSACTOR_DECRYPT_STR_0("\67\132\43\123\115\138\44\97\85\153\9\126\68\131\29\83", "\23\48\235\94")];
				v63 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\79\223\204\73\94\61\213\111", "\178\28\186\184\61\55\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\208\197\66\20\231\0\225\243\196\83\52\209\42", "\149\164\173\39\92\146\110")];
				v66 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\192\34\4\11\19\21\244\52", "\123\147\71\112\127\122")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\222\135\85\67\193\194\140\66\86\197\198\135\98", "\38\172\173\226\17")];
				v141 = 5;
			end
		end
	end
	local function v121()
		local v142 = 0;
		while true do
			if ((v142 == 3) or (4131 > 4610)) then
				v85 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\67\175\180\254\112\126\173\179", "\25\16\202\192\138")][LUAOBFUSACTOR_DECRYPT_STR_0("\245\206\172\238\189\252\238\223\162\236\172\220\205", "\148\157\171\205\130\201")] or 0;
				v84 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\209\96\61\216\248\36\199", "\150\67\180\20\73\177")][LUAOBFUSACTOR_DECRYPT_STR_0("\133\29\27\65\132\22\29\125\130\12\19\66\131\48\42", "\45\237\120\122")] or 0;
				v86 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\228\237\182\56\222\230\165\63", "\76\183\136\194")][LUAOBFUSACTOR_DECRYPT_STR_0("\82\227\228\52\89\65\19\74\233\241\49\95\65\58\123\235\224", "\116\26\134\133\88\48\47")] or "";
				v142 = 4;
			end
			if ((4129 >= 672) and (v142 == 1)) then
				v77 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\148\178\221\200\174\185\206\207", "\188\199\215\169")][LUAOBFUSACTOR_DECRYPT_STR_0("\213\7\75\126\250\238\28\79\111\199\242\5\70\76\224\245\29\90\119\225\239\29", "\136\156\105\63\27")];
				v78 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\40\137\109\32\18\130\126\39", "\84\123\236\25")][LUAOBFUSACTOR_DECRYPT_STR_0("\217\133\190\18\190\167\229\155\190\35\164\167\245\152\162\24\160\177", "\213\144\235\202\119\204")];
				v80 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\16\29\202\62\33\45\74\48", "\45\67\120\190\74\72\67")][LUAOBFUSACTOR_DECRYPT_STR_0("\53\49\232\145\235\129\224\226\37\54\254", "\137\64\66\141\197\153\232\142")];
				v142 = 2;
			end
			if ((1019 < 3466) and (v142 == 4)) then
				v75 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\196\180\240\180\124\25\210", "\18\126\161\192\132\221")][LUAOBFUSACTOR_DECRYPT_STR_0("\119\41\160\0\90\90\1\160\7\89\77\56\161\22\83\94\36", "\54\63\72\206\100")];
				break;
			end
			if ((290 <= 855) and (v142 == 2)) then
				v81 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\48\213\54\178\129\13\215\49", "\232\99\176\66\198")][LUAOBFUSACTOR_DECRYPT_STR_0("\248\51\33\8\112\136\237\63\219\40\60\14\88\169", "\76\140\65\72\102\27\237\153")];
				v83 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\223\2\198\222\15\185\89", "\222\42\186\118\178\183\97")][LUAOBFUSACTOR_DECRYPT_STR_0("\72\255\65\162\88\237\72\158\85\255\80\133\83\233", "\234\61\140\36")];
				v82 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\18\216\174\102\6\47\218\169", "\111\65\189\218\18")][LUAOBFUSACTOR_DECRYPT_STR_0("\86\88\30\29\14\93\163\74\69\28\5\4\72\166\76\69", "\207\35\43\123\85\107\60")];
				v142 = 3;
			end
			if ((4601 > 4446) and (0 == v142)) then
				v79 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\142\238\43\180\192\179\236\44", "\169\221\139\95\192")][LUAOBFUSACTOR_DECRYPT_STR_0("\216\130\120\55\54\20\219\134\126\54\44\53\253\131\122\60\41", "\70\190\235\31\95\66")] or 0;
				v72 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\137\231\14\242\236\180\229\9", "\133\218\130\122\134")][LUAOBFUSACTOR_DECRYPT_STR_0("\56\246\240\212\217\175\26\41\249\229\215", "\88\92\159\131\164\188\195")];
				v76 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\179\43\171\95\222\229\218\147", "\189\224\78\223\43\183\139")][LUAOBFUSACTOR_DECRYPT_STR_0("\7\242\158\19\211\60\233\154\2\246\39\232\130\37\213\59\242", "\161\78\156\234\118")];
				v142 = 1;
			end
		end
	end
	local function v122()
		local v143 = 0;
		while true do
			if ((v143 == 2) or (995 >= 2099)) then
				if ((961 < 4006) and v38) then
					v102 = #v101;
				else
					v102 = 1;
				end
				v107();
				v108();
				v99 = v14:ActiveMitigationNeeded();
				v143 = 3;
			end
			if ((2694 < 4854) and (v143 == 0)) then
				v120();
				v121();
				v37 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\252\86\66\125\233\126\219", "\27\168\57\37\26\133")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\165\127", "\183\77\202\28\200")];
				v38 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\35\60\142\15\27\54\154", "\104\119\83\233")][LUAOBFUSACTOR_DECRYPT_STR_0("\244\247\34", "\35\149\152\71\66")];
				v143 = 1;
			end
			if ((v143 == 1) or (4174 <= 3733)) then
				v39 = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\231\69\183\54\28\251", "\90\121\136\34\208")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\10\70", "\126\167\110\53")];
				if (v14:IsDeadOrGhost() or (2626 <= 648)) then
					return;
				end
				if ((1595 <= 2078) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\20\29\62\234\211\41\56\20\10\241\207\45\40\0\58", "\95\93\112\78\152\188")]:IsAvailable()) then
					v35 = 10;
				end
				v101 = v14:GetEnemiesInMeleeRange(v35);
				v143 = 2;
			end
			if ((1635 > 653) and (v143 == 3)) then
				v100 = v14:IsTankingAoE(8) or v14:IsTanking(v15);
				if ((3738 == 3738) and (v27.TargetIsValid() or v14:AffectingCombat())) then
					local v194 = 0;
					while true do
						if ((v194 == 0) or (3963 > 4742)) then
							v104 = v10.BossFightRemains(nil, true);
							v105 = v104;
							v194 = 1;
						end
						if ((v194 == 1) or (4072 > 4695)) then
							if ((v105 == 11111) or (2220 > 2889)) then
								v105 = v10.FightRemains(v101, false);
							end
							break;
						end
					end
				end
				if (v75 or (4914 < 4399)) then
					local v195 = 0;
					while true do
						if ((3660 == 3660) and (v195 == 0)) then
							v36 = v27.HandleIncorporeal(v90.Imprison, v92.ImprisonMouseover, 20);
							if ((2915 >= 196) and v36) then
								return v36;
							end
							break;
						end
					end
				end
				if ((v27.TargetIsValid() and not v14:IsChanneling() and not v14:IsCasting()) or (4638 < 3902)) then
					local v196 = 0;
					local v197;
					local v198;
					while true do
						if ((v196 == 1) or (1100 >= 1292)) then
							if ((not v14:AffectingCombat() and v37) or (547 > 3511)) then
								local v203 = 0;
								while true do
									if ((v203 == 0) or (314 > 2132)) then
										v198 = v112();
										if ((932 == 932) and v198) then
											return v198;
										end
										break;
									end
								end
							end
							if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\221\56\248\164\241\183\251\26\247\176\237\185", "\218\158\87\150\215\132")]:IsAvailable() and v41 and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\216\17\215\241\35\47\200\214\31\222\235\53", "\173\155\126\185\130\86\66")]:IsReady() and v72 and not v14:IsCasting() and not v14:IsChanneling() and v27.UnitHasMagicBuff(v15)) or (2939 == 4366)) then
								if (v25(v90.ConsumeMagic, not v15:IsSpellInRange(v90.ConsumeMagic)) or (3969 <= 3657)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\226\180\191\198\156\233\247\153\170\210\154\235\224\230\190\198\133\237\226\163", "\140\133\198\218\167\232");
								end
							end
							if (v100 or (1379 == 1462)) then
								local v204 = 0;
								while true do
									if ((v204 == 0) or (4606 <= 3927)) then
										v198 = v113();
										if (v198 or (1578 <= 1012)) then
											return v198;
										end
										break;
									end
								end
							end
							v196 = 2;
						end
						if ((v196 == 0) or (2399 > 3386)) then
							v103 = (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\231\240\137\49\225\168\211\210\225\132\1\237\177\220", "\178\161\149\229\117\132\222")]:CooldownRemains() < (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\187\212\200\160\130\26\163\34\158\222", "\67\232\187\189\204\193\118\198")]:ExecuteTime() + v14:GCDRemains())) and (v14:Fury() < 50);
							if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\191\38\167\47\44\37\227\138\39\163\37", "\143\235\78\213\64\91\98")]:IsCastable() and v50 and v12.ValueIsInArray(v106, v15:NPCID())) or (3476 > 4701)) then
								if (v25(v90.ThrowGlaive, not v15:IsSpellInRange(v90.ThrowGlaive)) or (4374 <= 3729)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\139\71\128\237\117\164\205\92\139\169\100\190\136\8\130\229\113\187\136\91\196\230\126\246\153\64\139\250\117\246\139\65\136\253\120\175\205\76\129\228\127\184\158", "\214\237\40\228\137\16");
								end
							end
							if ((v90[LUAOBFUSACTOR_DECRYPT_STR_0("\177\235\253\214\20\129\137\226\230\207\6", "\198\229\131\143\185\99")]:IsReady() and v50 and v12.ValueIsInArray(v106, v16:NPCID())) or (4938 <= 1325)) then
								if (v25(v92.ThrowGlaiveMouseover, not v15:IsSpellInRange(v90.ThrowGlaive)) or (2930 > 4142)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\87\131\172\119\84\158\232\103\94\204\188\123\84\204\174\127\80\129\173\96\17\158\173\114\82\152\232\99\84\158\232\126\94\153\187\118\94\154\173\97", "\19\49\236\200");
								end
							end
							v196 = 1;
						end
						if ((583 >= 133) and (v196 == 4)) then
							v198 = v117();
							if ((432 == 432) and v198) then
								return v198;
							end
							if ((1456 <= 4224) and (v102 <= 1)) then
								local v205 = 0;
								local v206;
								while true do
									if ((v205 == 0) or (1698 >= 2384)) then
										v206 = v118();
										if ((2711 < 3812) and v206) then
											return v206;
										end
										break;
									end
								end
							end
							v196 = 5;
						end
						if ((v196 == 5) or (746 >= 2339)) then
							if ((3002 >= 894) and (v102 > 1) and (v102 <= 5)) then
								local v207 = 0;
								local v208;
								while true do
									if ((0 == v207) or (1376 <= 1032)) then
										v208 = v119();
										if ((2427 == 2427) and v208) then
											return v208;
										end
										break;
									end
								end
							end
							if ((3491 > 3393) and (v102 >= 6)) then
								local v209 = 0;
								local v210;
								while true do
									if ((v209 == 0) or (3885 > 4312)) then
										v210 = v115();
										if (v210 or (2128 < 1754)) then
											return v210;
										end
										break;
									end
								end
							end
							break;
						end
						if ((v196 == 3) or (4584 <= 3272)) then
							if ((1043 <= 3558) and v197) then
								return v197;
							end
							if ((71 == 71) and (v79 < v105)) then
								if ((2793 == 2793) and v80 and ((v39 and v81) or not v81)) then
									local v214 = 0;
									while true do
										if ((v214 == 0) or (561 > 911)) then
											v198 = v111();
											if (v198 or (677 >= 4143)) then
												return v198;
											end
											break;
										end
									end
								end
							end
							if ((4422 > 2292) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\106\23\223\178\169\104\27\215\169\163\73", "\208\44\126\186\192")]:IsAvailable() and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\209\19\161\212\13\222\219\79\249\30\128\195\22\233\207\72", "\46\151\122\196\166\116\156\169")]:AuraActiveCount() > 1)) then
								local v211 = 0;
								local v212;
								while true do
									if ((v211 == 0) or (3386 <= 2556)) then
										v212 = v116();
										if (v212 or (4932 < 902)) then
											return v212;
										end
										break;
									end
								end
							end
							v196 = 4;
						end
						if ((v196 == 2) or (503 >= 1425)) then
							if ((4871 == 4871) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\156\32\178\120\150\187\47\184\78\144\167\39\191\120", "\228\213\78\212\29")]:IsCastable() and (v45 or (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\174\66\176\0\249\137\77\186\54\255\149\69\189\0", "\139\231\44\214\101")]:ChargesFractional() > 1.9)) and (v90[LUAOBFUSACTOR_DECRYPT_STR_0("\240\225\0\91\2\191\48\26\234\251\20\87\27\180", "\118\185\143\102\62\112\209\81")]:TimeSinceLastCast() > 2)) then
								if ((2515 > 2280) and v25(v92.InfernalStrikePlayer, not v15:IsInMeleeRange(v35))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\85\126\47\227\183\27\29\52\99\99\61\244\172\30\25\120\81\113\32\232\229\71", "\88\60\16\73\134\197\117\124");
								end
							end
							if ((3008 == 3008) and (v79 < v105) and v90[LUAOBFUSACTOR_DECRYPT_STR_0("\125\239\236\201\76\95\248\232\192\78\67\227\235", "\33\48\138\152\168")]:IsCastable() and v68 and v89 and v14:BuffDown(v90.MetamorphosisBuff) and v15:DebuffDown(v90.FieryBrandDebuff)) then
								if ((295 < 775) and v25(v92.MetamorphosisPlayer, not v97)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\127\19\36\80\204\56\96\6\56\94\210\62\97\86\61\80\200\57\50\66", "\87\18\118\80\49\161");
								end
							end
							v197 = v27.HandleDPSPotion();
							v196 = 3;
						end
					end
				end
				break;
			end
		end
	end
	local function v123()
		local v144 = 0;
		while true do
			if ((v144 == 0) or (4828 <= 3019)) then
				v20.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\211\232\72\29\254\228\227\69\31\187\193\232\75\21\245\165\197\83\20\239\224\255\6\24\226\165\200\86\19\248\171\173\117\15\235\245\226\84\14\254\225\173\68\3\187\253\198\71\20\254\241\226\8", "\155\133\141\38\122"));
				v90[LUAOBFUSACTOR_DECRYPT_STR_0("\3\35\169\83\86\93\183\36\36\168\101\74\125\176\35\44", "\197\69\74\204\33\47\31")]:RegisterAuraTracking();
				break;
			end
		end
	end
	v20.SetAPL(581, v122, v123);
end;
return v0[LUAOBFUSACTOR_DECRYPT_STR_0("\213\95\83\159\207\107\95\138\255\65\114\146\254\91\95\149\207\121\95\137\247\74\91\137\243\74\20\139\229\78", "\231\144\47\58")]();

