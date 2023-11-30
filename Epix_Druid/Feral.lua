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
local obf_OR = obf_bitlib.bor;
local obf_AND = obf_bitlib.band;
local luaobf_bundle = {};
local _require = require;
local function require(path, ...)
	local FlatIdent_38200 = 0 + 0;
	local fn;
	while true do
		local FlatIdent_11E32 = 0;
		while true do
			if ((1472 == 1472) and ((FlatIdent_11E32 == 0) or (3066 > 3851))) then
				if ((4520 > 4486) and (FlatIdent_38200 == 0)) then
					fn = luaobf_bundle[path];
					if (not fn or (622 > 1409)) then
						return _require(path, ...);
					end
					FlatIdent_38200 = 1;
				end
				if ((1 == FlatIdent_38200) or (2065 == 4654)) then
					return fn(...);
				end
				break;
			end
		end
	end
end
luaobf_bundle[LUAOBFUSACTOR_DECRYPT_STR_0("\244\211\210\61\217\159\213\11\216\199\228\3\227\169\198\18\159\207\206\36", "\126\177\163\187\69\134\219\167")] = function(...)
	local addonName, addonTable = ...;
	local DBC = EpicDBC[LUAOBFUSACTOR_DECRYPT_STR_0("\7\239\9", "\156\67\173\74\165")];
	local EL = EpicLib;
	local Cache = EpicCache;
	local Unit = EL[LUAOBFUSACTOR_DECRYPT_STR_0("\1\185\64\2", "\38\84\215\41\118\220\70")];
	local Player = Unit[LUAOBFUSACTOR_DECRYPT_STR_0("\96\26\35\11\251\66", "\158\48\118\66\114")];
	local Mouseover = Unit[LUAOBFUSACTOR_DECRYPT_STR_0("\134\43\5\37\118\138\237\174\54", "\155\203\68\112\86\19\197")];
	local Pet = Unit[LUAOBFUSACTOR_DECRYPT_STR_0("\118\216\34", "\152\38\189\86\156\32\24\133")];
	local Target = Unit[LUAOBFUSACTOR_DECRYPT_STR_0("\200\86\181\65\249\67", "\38\156\55\199")];
	local Spell = EL[LUAOBFUSACTOR_DECRYPT_STR_0("\155\109\121\36\31", "\35\200\29\28\72\115\20\154")];
	local MultiSpell = EL[LUAOBFUSACTOR_DECRYPT_STR_0("\52\170\221\203\132\31\36\28\179\221", "\84\121\223\177\191\237\76")];
	local Item = EL[LUAOBFUSACTOR_DECRYPT_STR_0("\146\66\204\173", "\161\219\54\169\192\90\48\80")];
	local ER = EpicLib;
	local Cast = ER[LUAOBFUSACTOR_DECRYPT_STR_0("\106\67\19\49", "\69\41\34\96")];
	local CastPooling = ER[LUAOBFUSACTOR_DECRYPT_STR_0("\159\194\196\30\50\36\179\207\222\4\5", "\75\220\163\183\106\98")];
	local Macro = ER[LUAOBFUSACTOR_DECRYPT_STR_0("\47\187\136\37\214", "\185\98\218\235\87")];
	local Press = ER[LUAOBFUSACTOR_DECRYPT_STR_0("\251\46\34\245\205", "\202\171\92\71\134\190")];
	local num = ER[LUAOBFUSACTOR_DECRYPT_STR_0("\10\206\33\133\38\207\63", "\232\73\161\76")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\207\71\79\7\180\215\71", "\126\219\185\34\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\2\219\83", "\135\108\174\62\18\30\23\147")];
	local bool = ER[LUAOBFUSACTOR_DECRYPT_STR_0("\149\230\39\198\23\160\32", "\167\214\137\74\171\120\206\83")][LUAOBFUSACTOR_DECRYPT_STR_0("\174\230\55\79\225\168\133\245", "\199\235\144\82\61\152")][LUAOBFUSACTOR_DECRYPT_STR_0("\5\25\182\39", "\75\103\118\217")];
	local mathfloor = math[LUAOBFUSACTOR_DECRYPT_STR_0("\193\88\127\27\171", "\126\167\52\16\116\217")];
	local OOC = false;
	local AOE = false;
	local CDs = false;
	local DispelToggle = false;
	local Everyone = ER[LUAOBFUSACTOR_DECRYPT_STR_0("\235\33\45\141\187\23\239", "\156\168\78\64\224\212\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\34\248\160\220\30\225\171\203", "\174\103\142\197")];
	local S = Spell[LUAOBFUSACTOR_DECRYPT_STR_0("\114\58\74\49\33", "\152\54\72\63\88\69\62")][LUAOBFUSACTOR_DECRYPT_STR_0("\242\193\252\93\216", "\60\180\164\142")];
	local I = Item[LUAOBFUSACTOR_DECRYPT_STR_0("\124\76\16\32\35", "\114\56\62\101\73\71\141")][LUAOBFUSACTOR_DECRYPT_STR_0("\158\236\201\197\180", "\164\216\137\187")];
	local OnUseExcludes = {I[LUAOBFUSACTOR_DECRYPT_STR_0("\243\245\57\183\181\241\13\198\238\52\151\171\252\14\192\245\62\167\170", "\107\178\134\81\210\198\158")]:ID(),I[LUAOBFUSACTOR_DECRYPT_STR_0("\26\15\140\194\165\52\7\135\212\165\62\58\149\207\185\44\11\134\228\166\57\10\135\213", "\202\88\110\226\166")]:ID(),I[LUAOBFUSACTOR_DECRYPT_STR_0("\238\22\134\246\217\247\14\142\254\217\206\14\140", "\170\163\111\226\151")]:ID(),I[LUAOBFUSACTOR_DECRYPT_STR_0("\38\57\166\48\75\37\43\16\34\185\43\108\37\40\31\51\186", "\73\113\80\210\88\46\87")]:ID()};
	local UseRacials;
	local UseHealingPotion;
	local HealingPotionName;
	local HealingPotionHP;
	local UseMarkOfTheWild;
	local DispelDebuffs;
	local DispelBuffs;
	local UseHealthstone;
	local HealthstoneHP;
	local HandleAfflicted;
	local HandleIncorporeal;
	local InterruptWithStun;
	local InterruptOnlyWhitelist;
	local InterruptThreshold;
	local UseCatFormOOC;
	local UsageProwlOOC;
	local ProwlRange;
	local UseWildCharge;
	local UseBarkskin;
	local BarkskinHP;
	local UseNaturesVigil;
	local NaturesVigilHP;
	local UseRenewal;
	local RenewalHP;
	local UseRegrowth;
	local UseRegrowthMouseover;
	local RegrowthHP;
	local M = Macro[LUAOBFUSACTOR_DECRYPT_STR_0("\165\62\216\27\227", "\135\225\76\173\114")][LUAOBFUSACTOR_DECRYPT_STR_0("\60\232\170\177\160", "\199\122\141\216\208\204\221")];
	local VarNeedBT, VarAlign3Mins, VarLastConvoke, VarLastZerk, VarZerkBiteweave, VarRegrowth, VarEasySwipe;
	local VarForceAlign2Min, VarAlignCDs;
	local ComboPoints, ComboPointsDeficit;
	local BossFightRemains = 12549 - (1059 + 379);
	local FightRemains = 13796 - 2685;
	local MeleeRange, AoERange;
	local IsInMeleeRange, IsInAoERange;
	local EnemiesMelee, EnemiesCountMelee;
	local Enemies11y, EnemiesCount11y;
	local BsInc = (S[LUAOBFUSACTOR_DECRYPT_STR_0("\132\211\19\241\106\248\172\201\25\255\118", "\150\205\189\112\144\24")]:IsAvailable() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\12\138\188\77\22\134\16\4\44\139\177", "\112\69\228\223\44\100\232\113")]) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\246\26\21\192\179\110\141", "\230\180\127\103\179\214\28")];
	EL:RegisterForEvent(function()
		BsInc = (S[LUAOBFUSACTOR_DECRYPT_STR_0("\165\11\92\71\246\79\225\152\12\80\72", "\128\236\101\63\38\132\33")]:IsAvailable() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\18\69\164\229\206\184\160\30\74", "\175\204\201\113\36\214\139")]) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\101\201\39\207\1\85\199", "\100\39\172\85\188")];
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\158\72\156\172\31\158\71\154\168\18\131\95\156\164", "\83\205\24\217\224"), LUAOBFUSACTOR_DECRYPT_STR_0("\202\224\236\15\200\224\233\2\213\245\232\17\202\250\228\19\217\241\236\31", "\93\134\165\173"));
	EL:RegisterForEvent(function()
		local FlatIdent_4F93 = 0;
		local FlatIdent_3EAF3;
		while true do
			if (FlatIdent_4F93 == 0) then
				FlatIdent_3EAF3 = 0 + 0;
				while true do
					if ((FlatIdent_3EAF3 == 0) or (4584 < 2479)) then
						BossFightRemains = 11111;
						FightRemains = 11111;
						break;
					end
				end
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\142\222\224\251\31\252\141\76\155\213\228\236\5\235\156\95\156\222\228\230", "\30\222\146\161\162\90\174\210"));
	EL:RegisterForEvent(function()
		local FlatIdent_18900 = 0;
		local FlatIdent_8CBF0;
		local FlatIdent_10550;
		while true do
			if ((1753 >= 1055) and (4894 > 2123) and (FlatIdent_18900 == 0)) then
				FlatIdent_8CBF0 = 0;
				FlatIdent_10550 = nil;
				FlatIdent_18900 = 1;
			end
			if ((3619 == 3619) and (FlatIdent_18900 == 1)) then
				while true do
					if ((2136 >= 510) and (2132 < 3335) and (FlatIdent_8CBF0 == (0 + 0))) then
						FlatIdent_10550 = 0;
						while true do
							if ((2377 < 2472) and ((FlatIdent_10550 == 0) or (4477 <= 3601))) then
								S[LUAOBFUSACTOR_DECRYPT_STR_0("\196\74\113\26\241\71\102\15\214\89\113\24\232", "\106\133\46\16")]:RegisterInFlightEffect(391889);
								S[LUAOBFUSACTOR_DECRYPT_STR_0("\121\36\114\236\78\73\78\37\64\235\91\82\85", "\32\56\64\19\156\58")]:RegisterInFlight();
								break;
							end
						end
						break;
					end
				end
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\118\237\196\100\116\215\164\101\251\213\115\118\222\191\115\230\218\98\123\208", "\224\58\168\133\54\58\146"));
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\120\82\74\237\97\143\145\14\106\65\74\239\120", "\107\57\54\43\157\21\230\231")]:RegisterInFlightEffect(392281 - (145 + 247));
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\250\143\16\229\173\213\217\222\184\6\244\171\209", "\175\187\235\113\149\217\188")]:RegisterInFlight();
	local function ComputeRakePMultiplier()
		return (Player:StealthUp(true, true) and 1.6) or (1 + 0);
	end
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\14\174\138\73", "\24\92\207\225\44\131\25")]:RegisterPMultiplier(S.RakeDebuff, ComputeRakePMultiplier);
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\120\219\170\73\31", "\29\43\179\216\44\123")]:RegisterDamageFormula(function()
		return Player:AttackPowerDamageMod() * 0.7762 * ((Player:StealthUp(true) and 1.6) or 1) * (obf_AND(1, Player:VersatilityDmgPct() / (47 + 53)) + obf_OR(1, Player:VersatilityDmgPct() / (47 + 53)));
	end);
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\137\209\50\77\174\209", "\44\221\185\64")]:RegisterDamageFormula(function()
		return obf_AND(Player:AttackPowerDamageMod() * 0.1272, Player:AttackPowerDamageMod() * 0.4055) + obf_OR(Player:AttackPowerDamageMod() * 0.1272, Player:AttackPowerDamageMod() * 0.4055);
	end);
	local BtTriggers = {S[LUAOBFUSACTOR_DECRYPT_STR_0("\51\230\67\90", "\19\97\135\40\63")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\130\117\30\52\32\63\168\85\33\62", "\81\206\60\83\91\79")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\122\163\194\115\60\203", "\196\46\203\176\18\79\163\45")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\154\48\107\10\37\247\220\180\35\109\22", "\143\216\66\30\126\68\155")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\153\223\4\219\192", "\129\202\168\109\171\165\195\183")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\17\80\37\221\218", "\134\66\56\87\184\190\116")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\26\52\27\186\21\205\51\48\50\43\16", "\85\92\81\105\219\121\139\65")]};
	local function DebuffRefreshAny(Enemies, Spell)
		local FlatIdent_C2C2 = 0;
		local FlatIdent_29BDD;
		while true do
			if ((FlatIdent_C2C2 == 0) or (2764 > 2956)) then
				FlatIdent_29BDD = 0 + 0;
				while true do
					if ((3192 <= 3445) and (FlatIdent_29BDD == 0)) then
						local FlatIdent_1DD07 = 0;
						while true do
							if ((4775 > 3465) and (FlatIdent_1DD07 == 0)) then
								for _, Enemy in pairs(Enemies) do
									if Enemy:DebuffRefreshable(Spell) then
										return true;
									end
								end
								return false;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function LowRakePMult(Enemies)
		local FlatIdent_73409 = 0 - 0;
		local FlatIdent_7E818;
		local FlatIdent_2BCFB;
		local Lowest;
		while true do
			if ((1 == FlatIdent_73409) or (3478 == 589)) then
				Lowest = nil;
				while true do
					if (((1732 >= 130) and (FlatIdent_7E818 == 0)) or (3711 < 507)) then
						local FlatIdent_AE19 = 720 - (254 + 466);
						while true do
							if (((560 - (544 + 16)) == FlatIdent_AE19) or (867 > 3215)) then
								FlatIdent_2BCFB = 0;
								Lowest = nil;
								FlatIdent_AE19 = 1;
							end
							if (FlatIdent_AE19 == 1) then
								FlatIdent_7E818 = 1;
								break;
							end
						end
					end
					if ((665 <= 4541) and (FlatIdent_7E818 == 1)) then
						while true do
							local FlatIdent_244F6 = 0 - 0;
							while true do
								if (FlatIdent_244F6 == 0) then
									if ((1089 <= 3455) and (FlatIdent_2BCFB == 0)) then
										local FlatIdent_7F4ED = 628 - (294 + 334);
										while true do
											if (FlatIdent_7F4ED == (253 - (236 + 17))) then
												Lowest = nil;
												for _, Enemy in pairs(Enemies) do
													local FlatIdent_92EAD = 0;
													local FlatIdent_4DC41;
													local FlatIdent_65740;
													local EnemyPMult;
													while true do
														if ((FlatIdent_92EAD == (0 + 0)) or (3522 < 2146)) then
															FlatIdent_4DC41 = 0;
															FlatIdent_65740 = nil;
															FlatIdent_92EAD = 1;
														end
														if ((3276 <= 4677) and (FlatIdent_92EAD == 1)) then
															EnemyPMult = nil;
															while true do
																if ((0 == FlatIdent_4DC41) or (3491 <= 3258)) then
																	FlatIdent_65740 = 0;
																	EnemyPMult = nil;
																	FlatIdent_4DC41 = 1;
																end
																if ((2272 >= 1107) and ((FlatIdent_4DC41 == 1) or (4449 < 3644))) then
																	while true do
																		if ((911 >= 521) and ((FlatIdent_65740 == 0) or (153 >= 1887))) then
																			EnemyPMult = Enemy:PMultiplier(S.Rake);
																			if ((3804 > 3392) and (1765 > 640) and (not Lowest or (EnemyPMult < Lowest))) then
																				Lowest = EnemyPMult;
																			end
																			break;
																		end
																	end
																	break;
																end
															end
															break;
														end
													end
												end
												FlatIdent_7F4ED = 1;
											end
											if ((200 < 4059) and (FlatIdent_7F4ED == 1)) then
												FlatIdent_2BCFB = 1;
												break;
											end
										end
									end
									if ((FlatIdent_2BCFB == (1 + 0)) or (3210 <= 1400)) then
										return Lowest;
									end
									break;
								end
							end
						end
						break;
					end
				end
				break;
			end
			if ((1380 < 3863) and (FlatIdent_73409 == 0)) then
				FlatIdent_7E818 = 0;
				FlatIdent_2BCFB = nil;
				FlatIdent_73409 = 1;
			end
		end
	end
	local function BTBuffUp(Trigger)
		local FlatIdent_8AF8D = 0;
		local FlatIdent_3E5FC;
		local FlatIdent_94041;
		while true do
			if ((183 <= 3341) and (FlatIdent_8AF8D == 0)) then
				FlatIdent_3E5FC = 0;
				FlatIdent_94041 = nil;
				FlatIdent_8AF8D = 3 - 2;
			end
			if ((FlatIdent_8AF8D == (4 - 3)) or (426 > 3276)) then
				while true do
					if (FlatIdent_3E5FC == 0) then
						FlatIdent_94041 = 0 + 0;
						while true do
							if ((FlatIdent_94041 == 0) or (3592 == 4092) or (935 <= 162)) then
								local FlatIdent_90515 = 0;
								while true do
									if ((3380 == 3380) and (FlatIdent_90515 == 0)) then
										if ((414 < 1183) and (4841 >= 4597) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\223\191\95\74\120\203\252\191\95\75\111", "\191\157\211\48\37\28")]:IsAvailable()) then
											return false;
										end
										return Trigger:TimeSinceLastCast() < math.min(5, S[LUAOBFUSACTOR_DECRYPT_STR_0("\253\19\251\19\62\203\30\248\19\52\204\61\225\26\60", "\90\191\127\148\124")]:TimeSinceLastAppliedOnPlayer());
									end
								end
							end
						end
						break;
					end
				end
				break;
			end
		end
	end
	local function BTBuffDown(Trigger)
		return not BTBuffUp(Trigger);
	end
	function CountActiveBtTriggers()
		local FlatIdent_53DF8 = 0;
		local FlatIdent_5D994;
		local FlatIdent_85F7E;
		local ActiveTriggers;
		while true do
			if ((4098 > 766) and (3962 == 3962) and (1 == FlatIdent_53DF8)) then
				ActiveTriggers = nil;
				while true do
					if ((FlatIdent_5D994 == 1) or (3904 <= 98)) then
						while true do
							local FlatIdent_1D9A3 = 0;
							local FlatIdent_76268;
							while true do
								if ((FlatIdent_1D9A3 == 0) or (3057 <= 2101)) then
									FlatIdent_76268 = 0 + 0;
									while true do
										if ((FlatIdent_76268 == (794 - (413 + 381))) or (4255 <= 549)) then
											if ((FlatIdent_85F7E == 0) or (472 > 516)) then
												local FlatIdent_1C794 = 0;
												local FlatIdent_82AB6;
												while true do
													if ((FlatIdent_1C794 == 0) or (3977 >= 4688)) then
														FlatIdent_82AB6 = 0 + 0;
														while true do
															if ((4264 > 983) and (FlatIdent_82AB6 == 1)) then
																FlatIdent_85F7E = 1;
																break;
															end
															if ((386 < 4511) and (FlatIdent_82AB6 == 0)) then
																ActiveTriggers = 0;
																for i = 1, #BtTriggers do
																	if ((4795 > 3065) and (BTBuffUp(BtTriggers[i]) or (774 < 455))) then
																		ActiveTriggers = obf_AND(ActiveTriggers, 1) + obf_OR(ActiveTriggers, 1);
																	end
																end
																FlatIdent_82AB6 = 1;
															end
														end
														break;
													end
												end
											end
											if ((FlatIdent_85F7E == 1) or (4884 == 1777)) then
												return ActiveTriggers;
											end
											break;
										end
									end
									break;
								end
							end
						end
						break;
					end
					if ((FlatIdent_5D994 == 0) or (832 == 2347)) then
						FlatIdent_85F7E = 0;
						ActiveTriggers = nil;
						FlatIdent_5D994 = 1 - 0;
					end
				end
				break;
			end
			if (FlatIdent_53DF8 == (0 - 0)) then
				FlatIdent_5D994 = 1970 - (582 + 1388);
				FlatIdent_85F7E = nil;
				FlatIdent_53DF8 = 1;
			end
		end
	end
	local function TicksGainedOnRefresh(Spell, Tar)
		local FlatIdent_963CA = 0;
		local FlatIdent_4721F;
		local AddedDuration;
		local MaxDuration;
		local TickTime;
		local OldTicks;
		local OldTime;
		local NewTime;
		local NewTicks;
		local TicksAdded;
		while true do
			if ((FlatIdent_963CA == 4) or (1934 == 2777)) then
				TicksAdded = nil;
				while true do
					local FlatIdent_163EF = 0;
					while true do
						if ((FlatIdent_163EF == 1) or (604 == 4669) or (2997 == 3076)) then
							if ((FlatIdent_4721F == 2) or (2088 > 2395)) then
								local FlatIdent_48421 = 0;
								local FlatIdent_60AF9;
								while true do
									if ((FlatIdent_48421 == 0) or (1158 >= 4765)) then
										FlatIdent_60AF9 = 0 - 0;
										while true do
											if (0 == FlatIdent_60AF9) then
												if ((1992 <= 2618) and (NewTime <= MaxDuration)) then
												else
													NewTime = MaxDuration;
												end
												NewTicks = NewTime / TickTime;
												FlatIdent_60AF9 = 1;
											end
											if ((FlatIdent_60AF9 == 1) or (844 == 250)) then
												if (not OldTicks or (4757 < 3588)) then
													OldTicks = 0;
												end
												TicksAdded = NewTicks - OldTicks;
												FlatIdent_60AF9 = 2;
											end
											if ((FlatIdent_60AF9 == 2) or (3318 == 418)) then
												FlatIdent_4721F = 3 + 0;
												break;
											end
										end
										break;
									end
								end
							end
							if (FlatIdent_4721F == 1) then
								local FlatIdent_1CBA3 = 0;
								while true do
									if ((FlatIdent_1CBA3 == 2) or (197 > 4460)) then
										FlatIdent_4721F = 2;
										break;
									end
									if ((FlatIdent_1CBA3 == 1) or (4067 <= 2537) or (475 < 230)) then
										local FlatIdent_4BAEC = 0;
										while true do
											if ((69 <= 137) and ((FlatIdent_4BAEC == 1) or (4169 <= 4060))) then
												FlatIdent_1CBA3 = 366 - (326 + 38);
												break;
											end
											if (FlatIdent_4BAEC == 0) then
												OldTime = Tar:DebuffRemains(Spell);
												NewTime = obf_AND(AddedDuration, OldTime) + obf_OR(AddedDuration, OldTime);
												FlatIdent_4BAEC = 1;
											end
										end
									end
									if ((FlatIdent_1CBA3 == (0 - 0)) or (86 >= 606)) then
										local FlatIdent_1BC6A = 0;
										while true do
											if (FlatIdent_1BC6A == (0 - 0)) then
												if ((2296 == 2296) and ((Spell == S[LUAOBFUSACTOR_DECRYPT_STR_0("\74\142\62", "\119\24\231\78")]) or (153 >= 2453))) then
													local FlatIdent_44EF4 = 0;
													local FlatIdent_85638;
													local FlatIdent_57EB7;
													while true do
														if (FlatIdent_44EF4 == 0) then
															FlatIdent_85638 = 0;
															FlatIdent_57EB7 = nil;
															FlatIdent_44EF4 = 1;
														end
														if ((1 == FlatIdent_44EF4) or (532 >= 1376)) then
															while true do
																if ((1698 < 2725) and (FlatIdent_85638 == 0)) then
																	FlatIdent_57EB7 = 0;
																	while true do
																		if (((621 - (47 + 573)) == FlatIdent_57EB7) or (2676 >= 4227)) then
																			TickTime = Spell:TickTime();
																			break;
																		end
																		if ((FlatIdent_57EB7 == 0) or (283 >= 2823)) then
																			local FlatIdent_8EFBC = 0 + 0;
																			while true do
																				if ((4242 > 366) and (FlatIdent_8EFBC == 1)) then
																					FlatIdent_57EB7 = 1;
																					break;
																				end
																				if ((4712 == 4712) and (FlatIdent_8EFBC == 0)) then
																					AddedDuration = obf_AND(16 - 12, ComboPoints * (5 - 1)) + obf_OR(4, ComboPoints * (5 - 1));
																					MaxDuration = 31.2;
																					FlatIdent_8EFBC = 1;
																				end
																			end
																		end
																	end
																	break;
																end
															end
															break;
														end
													end
												else
													local FlatIdent_68A13 = 0;
													local FlatIdent_39DAE;
													while true do
														if (FlatIdent_68A13 == 0) then
															FlatIdent_39DAE = 1664 - (1269 + 395);
															while true do
																if ((3335 >= 2992) and (FlatIdent_39DAE == 0)) then
																	local FlatIdent_608D0 = 0;
																	while true do
																		if ((1482 >= 1460) and (FlatIdent_608D0 == 1)) then
																			FlatIdent_39DAE = 1;
																			break;
																		end
																		if ((4064 == 4064) and ((FlatIdent_608D0 == 0) or (171 >= 4691))) then
																			AddedDuration = Spell:BaseDuration();
																			MaxDuration = Spell:MaxDuration();
																			FlatIdent_608D0 = 493 - (76 + 416);
																		end
																	end
																end
																if ((FlatIdent_39DAE == 1) or (2173 > 4840) or (2270 == 3114)) then
																	TickTime = Spell:TickTime();
																	break;
																end
															end
															break;
														end
													end
												end
												OldTicks = Tar:DebuffTicksRemain(Spell);
												FlatIdent_1BC6A = 1;
											end
											if ((FlatIdent_1BC6A == 1) or (3884 < 1346)) then
												FlatIdent_1CBA3 = 1;
												break;
											end
										end
									end
								end
							end
							break;
						end
						if ((FlatIdent_163EF == 0) or (1564 > 3303)) then
							if ((FlatIdent_4721F == 0) or (2164 > 3146)) then
								local FlatIdent_25C29 = 0;
								local FlatIdent_74D70;
								while true do
									if ((686 < 2227) and (FlatIdent_25C29 == 0)) then
										FlatIdent_74D70 = 0;
										while true do
											if (FlatIdent_74D70 == (444 - (319 + 124))) then
												MaxDuration = 0;
												TickTime = 0;
												FlatIdent_74D70 = 2;
											end
											if ((605 == 605) and (3360 == 3360) and (FlatIdent_74D70 == (0 - 0))) then
												if (not Tar or (2878 < 141)) then
													Tar = Target;
												end
												AddedDuration = 0;
												FlatIdent_74D70 = 1;
											end
											if ((474 < 1065) and (1082 <= 2816) and (FlatIdent_74D70 == (1009 - (564 + 443)))) then
												FlatIdent_4721F = 2 - 1;
												break;
											end
										end
										break;
									end
								end
							end
							if ((4139 > 3173) and (FlatIdent_4721F == (461 - (337 + 121)))) then
								return TicksAdded;
							end
							FlatIdent_163EF = 1;
						end
					end
				end
				break;
			end
			if ((FlatIdent_963CA == 0) or (3830 >= 4328)) then
				FlatIdent_4721F = 0;
				AddedDuration = nil;
				FlatIdent_963CA = 1;
			end
			if ((4392 == 4392) and ((FlatIdent_963CA == 3) or (1099 >= 4754))) then
				NewTime = nil;
				NewTicks = nil;
				FlatIdent_963CA = 11 - 7;
			end
			if ((1013 == 1013) and (FlatIdent_963CA == 2)) then
				OldTicks = nil;
				OldTime = nil;
				FlatIdent_963CA = 3;
			end
			if ((520 == 520) and (4871 <= 4892) and (FlatIdent_963CA == 1)) then
				MaxDuration = nil;
				TickTime = nil;
				FlatIdent_963CA = 6 - 4;
			end
		end
	end
	local function HighestTTD(enemies)
		local FlatIdent_37710 = 0;
		local FlatIdent_930C2;
		local HighTTD;
		local HighTTDTar;
		while true do
			if (FlatIdent_37710 == 0) then
				FlatIdent_930C2 = 0;
				HighTTD = nil;
				FlatIdent_37710 = 1;
			end
			if (FlatIdent_37710 == 1) then
				HighTTDTar = nil;
				while true do
					local FlatIdent_93393 = 0;
					while true do
						if ((FlatIdent_93393 == (1912 - (1261 + 650))) or (2393 <= 1632) or (3546 <= 2759)) then
							if (FlatIdent_930C2 == (1 + 0)) then
								local FlatIdent_7ABC9 = 0;
								while true do
									if ((4016 > 3561) and (FlatIdent_7ABC9 == 1)) then
										FlatIdent_930C2 = 2;
										break;
									end
									if (FlatIdent_7ABC9 == 0) then
										local FlatIdent_4AC34 = 0;
										while true do
											if ((1857 < 3234) and (2414 == 2414) and (FlatIdent_4AC34 == 1)) then
												FlatIdent_7ABC9 = 1;
												break;
											end
											if ((4068 > 1180) and (FlatIdent_4AC34 == 0)) then
												HighTTDTar = nil;
												for _, enemy in pairs(enemies) do
													local FlatIdent_5FCCA = 0;
													local FlatIdent_6F5E5;
													local FlatIdent_37FC;
													local TTD;
													while true do
														if (FlatIdent_5FCCA == (0 - 0)) then
															FlatIdent_6F5E5 = 0;
															FlatIdent_37FC = nil;
															FlatIdent_5FCCA = 1;
														end
														if (FlatIdent_5FCCA == 1) then
															TTD = nil;
															while true do
																if ((1584 == 1584) and (FlatIdent_6F5E5 == 1)) then
																	while true do
																		if ((2285 > 2073) and (FlatIdent_37FC == 0)) then
																			TTD = enemy:TimeToDie();
																			if ((2513 == 2513) and (TTD > HighTTD)) then
																				local FlatIdent_8EC0B = 0;
																				local FlatIdent_4D321;
																				while true do
																					if (FlatIdent_8EC0B == (1817 - (772 + 1045))) then
																						FlatIdent_4D321 = 0 + 0;
																						while true do
																							if ((0 == FlatIdent_4D321) or (2894 < 2799)) then
																								HighTTD = TTD;
																								HighTTDTar = enemy;
																								break;
																							end
																						end
																						break;
																					end
																				end
																			end
																			break;
																		end
																	end
																	break;
																end
																if ((3331 > 1280) and ((FlatIdent_6F5E5 == (144 - (102 + 42))) or (1275 > 3605))) then
																	FlatIdent_37FC = 1844 - (1524 + 320);
																	TTD = nil;
																	FlatIdent_6F5E5 = 1;
																end
															end
															break;
														end
													end
												end
												FlatIdent_4AC34 = 1271 - (1049 + 221);
											end
										end
									end
								end
							end
							break;
						end
						if (FlatIdent_93393 == 0) then
							if ((2347 >= 579) and (240 < 1190) and ((156 - (18 + 138)) == FlatIdent_930C2)) then
								if not enemies then
									return 0;
								end
								HighTTD = 0;
								FlatIdent_930C2 = 1;
							end
							if ((FlatIdent_930C2 == 2) or (635 > 2257)) then
								return HighTTD, HighTTDTar;
							end
							FlatIdent_93393 = 1;
						end
					end
				end
				break;
			end
		end
	end
	local function EvaluateTargetIfFilterAdaptiveSwarm(TargetUnit)
		return (obf_AND(2 - 1, TargetUnit:DebuffStack(S.AdaptiveSwarmDebuff)) + obf_OR(1, TargetUnit:DebuffStack(S.AdaptiveSwarmDebuff))) * num(TargetUnit:DebuffStack(S.AdaptiveSwarmDebuff) < (1105 - (67 + 1035))) * TargetUnit:TimeToDie();
	end
	local function EvaluateTargetIfFilterLIMoonfire(TargetUnit)
		return obf_AND(3 * num(TargetUnit:DebuffRefreshable(S.LIMoonfireDebuff)), num(TargetUnit:DebuffUp(S.LIMoonfireDebuff))) + obf_OR(3 * num(TargetUnit:DebuffRefreshable(S.LIMoonfireDebuff)), num(TargetUnit:DebuffUp(S.LIMoonfireDebuff)));
	end
	local function EvaluateTargetIfFilterRake(TargetUnit)
		return obf_AND((373 - (136 + 212)) * num(Player:PMultiplier(S.Rake) < TargetUnit:PMultiplier(S.Rake)), TargetUnit:DebuffRemains(S.RakeDebuff)) + obf_OR((373 - (136 + 212)) * num(Player:PMultiplier(S.Rake) < TargetUnit:PMultiplier(S.Rake)), TargetUnit:DebuffRemains(S.RakeDebuff));
	end
	local function EvaluateTargetIfFilterRakeTicks(TargetUnit)
		return (TicksGainedOnRefresh(S.RakeDebuff, TargetUnit));
	end
	local function EvaluateTargetIfFilterTTD(TargetUnit)
		return (TargetUnit:TimeToDie());
	end
	local function EvaluateTargetIfAdaptiveSwarm(TargetUnit)
		return TargetUnit:DebuffStack(S.AdaptiveSwarmDebuff) < 3;
	end
	local function EvaluateTargetIfBrutalSlashAoeBuilder(TargetUnit)
		return (S[LUAOBFUSACTOR_DECRYPT_STR_0("\160\63\176\94\221\76\34\142\44\182\66", "\113\226\77\197\42\188\32")]:FullRechargeTime() < 4) or (TargetUnit:TimeToDie() < 5);
	end
	local function EvaluateTargetIfBrutalSlashBT(TargetUnit)
		return ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\24\4\225\161\59\26\199\185\59\5\252", "\213\90\118\148")]:FullRechargeTime() < 4) or (TargetUnit:TimeToDie() < (21 - 16))) and BTBuffDown(S.BrutalSlash) and (Player:BuffUp(BsInc) or VarNeedBT);
	end
	local function EvaluateTargetIfConvokeCD(TargetUnit)
		return (FightRemains < 5) or ((Player:BuffUp(S.SmolderingFrenzyBuff) or not Player:HasTier(31, 4)) and (TargetUnit:DebuffRemains(S.Rip) > (4 - num(S[LUAOBFUSACTOR_DECRYPT_STR_0("\122\61\188\87\64\90\32\177\69\106\78\39\176\87\67\88\43", "\45\59\78\212\54")]:IsAvailable()))) and Player:BuffUp(S.TigersFury) and (ComboPoints < 2) and (TargetUnit:DebuffUp(S.DireFixationDebuff) or not S[LUAOBFUSACTOR_DECRYPT_STR_0("\52\95\145\142\160\39\181\241\4\95\140\133", "\144\112\54\227\235\230\78\205")]:IsAvailable() or (EnemiesCount11y > 1)) and (((TargetUnit:TimeToDie() < FightRemains) and (TargetUnit:TimeToDie() > (5 - num(S[LUAOBFUSACTOR_DECRYPT_STR_0("\146\59\7\253\221\90\189\45\28\219\197\82\183\41\1\255\213", "\59\211\72\111\156\176")]:IsAvailable())))) or (TargetUnit:TimeToDie() == FightRemains)));
	end
	local function EvaluateTargetIfLIMoonfireAoEBuilder(TargetUnit)
		return (TargetUnit:DebuffRefreshable(S.LIMoonfireDebuff));
	end
	local function EvaluateTargetIfLIMoonfireBT(TargetUnit)
		return (TicksGainedOnRefresh(S.LIMoonfireDebuff, TargetUnit));
	end
	local function EvaluateTargetIfFeralFrenzy(TargetUnit)
		return ((ComboPoints < (3 + 0)) or ((EL.CombatTime() < (10 + 0)) and (ComboPoints < 4))) and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\106\142\241\40\104\142\251\44\90\142\236\35", "\77\46\231\131")]:IsAvailable() or TargetUnit:DebuffUp(S.DireFixationDebuff) or (EnemiesCount11y > 1)) and (((TargetUnit:TimeToDie() < FightRemains) and (Target:TimeToDie() > 6)) or (TargetUnit:TimeToDie() == FightRemains)) and not ((EnemiesCount11y == 1) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\153\91\184\86\181\95\179\116\178\81\133\80\179\70\191\84\169", "\32\218\52\214")]:IsAvailable());
	end
	local function EvaluateTargetIfRakeAoeBuilder(TargetUnit)
		return Player:PMultiplier(S.Rake) > Target:PMultiplier(S.Rake);
	end
	local function EvaluateTargetIfRakeBloodtalons(TargetUnit)
		return (TargetUnit:DebuffRefreshable(S.RakeDebuff) or (Player:BuffUp(S.SuddenAmbushBuff) and (Player:PMultiplier(S.Rake) > TargetUnit:PMultiplier(S.Rake)))) and BTBuffDown(S.Rake);
	end
	local function EvaluateTargetIfFerociousBiteBerserk(TargetUnit)
		return TargetUnit:DebuffRemains(S.Rip) > 5;
	end
	local function EvaluateCycleAdaptiveSwarm(TargetUnit)
		return (TargetUnit:DebuffDown(S.AdaptiveSwarmDebuff) or (TargetUnit:DebuffRemains(S.AdaptiveSwarmDebuff) < 2)) and (TargetUnit:DebuffStack(S.AdaptiveSwarmDebuff) < (1607 - (240 + 1364))) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\111\19\48\184\229\185\83\95\125\0\48\186\252", "\58\46\119\81\200\145\208\37")]:InFlight() and (TargetUnit:TimeToDie() > 5);
	end
	local function EvaluateCycleLIMoonfire(TargetUnit)
		return (TargetUnit:DebuffRefreshable(S.LIMoonfireDebuff));
	end
	local function EvaluateCycleRakeAoeBuilder(TargetUnit)
		return (Player:BuffUp(S.SuddenAmbushBuff) and (Player:PMultiplier(S.Rake) > TargetUnit:PMultiplier(S.Rake))) or TargetUnit:DebuffRefreshable(S.RakeDebuff);
	end
	local function EvaluateCycleRake(TargetUnit)
		return Player:BuffUp(S.SuddenAmbushBuff) and (Player:PMultiplier(S.Rake) > TargetUnit:PMultiplier(S.Rake));
	end
	local function EvaluateCycleRakeMain(TargetUnit)
		return Player:PMultiplier(S.Rake) > TargetUnit:PMultiplier(S.Rake);
	end
	local function EvaluateCycleRip(TargetUnit)
		return ((Player:HasTier(31, 1084 - (1050 + 32)) and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\13\137\34\173\165\155\36\46\130\42\181", "\86\75\236\80\204\201\221")]:CooldownRemains() < (7 - 5)) and (TargetUnit:DebuffRemains(S.Rip) < (6 + 4))) or (((EL.CombatTime() < 8) or Player:BuffUp(S.BloodtalonsBuff) or not S[LUAOBFUSACTOR_DECRYPT_STR_0("\80\77\120\138\250\159\115\77\120\139\237", "\235\18\33\23\229\158")]:IsAvailable() or (Player:BuffUp(BsInc) and (TargetUnit:DebuffRemains(S.Rip) < 2))) and TargetUnit:DebuffRefreshable(S.Rip))) and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\96\168\200\182\81\182\246\169\81\174\201", "\219\48\218\161")]:IsAvailable() or (EnemiesCount11y == 1)) and not (Player:BuffUp(S.SmolderingFrenzyBuff) and (TargetUnit:DebuffRemains(S.Rip) > 2));
	end
	local function EvaluateCycleThrash(TargetUnit)
		return (TargetUnit:DebuffRefreshable(S.ThrashDebuff));
	end
	local function Precombat()
		local FlatIdent_26456 = 0;
		local FlatIdent_7FA38;
		while true do
			if (FlatIdent_26456 == 0) then
				FlatIdent_7FA38 = 0;
				while true do
					if ((2409 == 2409) and (1961 > 534) and (0 == FlatIdent_7FA38)) then
						local FlatIdent_2ACDD = 1055 - (331 + 724);
						while true do
							if (FlatIdent_2ACDD == 0) then
								local FlatIdent_890C6 = 0;
								while true do
									if (FlatIdent_890C6 == 0) then
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\199\112\104\111\212\93\237", "\128\132\17\28\41\187\47")]:IsCastable() and UseCatFormOOC) then
											if (((196 <= 3023) and Press(S.CatForm)) or (962 >= 3722)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\2\51\18\5\91\14\32\11\122\77\19\55\5\53\80\3\51\18\122\15", "\61\97\82\102\90");
											end
										end
										if ((2395 < 2649) and (2048 <= 3047) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\132\43\170\89\211\120\24\61\164\43\156\66\203\83", "\105\204\78\203\43\167\55\126")]:IsCastable()) then
											if (Press(S.HeartOfTheWild) or (411 >= 2970) or (1373 > 4744)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\173\175\34\12\7\59\200\87\154\190\43\27\44\19\206\93\161\234\51\12\22\7\200\92\167\171\55\94\71", "\49\197\202\67\126\115\100\167");
											end
										end
										FlatIdent_890C6 = 1 + 0;
									end
									if ((1312 <= 2793) and (1 == FlatIdent_890C6)) then
										FlatIdent_2ACDD = 1;
										break;
									end
								end
							end
							if ((2479 < 3052) and (1 == FlatIdent_2ACDD)) then
								FlatIdent_7FA38 = 1;
								break;
							end
						end
					end
					if (((646 - (269 + 375)) == FlatIdent_7FA38) or (2164 >= 3404) or (3777 < 1129)) then
						if ((1185 < 2612) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\23\208\81\95", "\211\69\177\58\58")]:IsReady()) then
							if ((4480 >= 683) and Press(S.Rake, not IsInMeleeRange)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\165\228\114\240\169\219\165\224\122\250\228\201\182\241\57\173", "\171\215\133\25\149\137");
							end
						end
						break;
					end
					if (FlatIdent_7FA38 == 1) then
						local FlatIdent_40663 = 0;
						while true do
							if ((1080 <= 2918) and (FlatIdent_40663 == (725 - (267 + 458)))) then
								if ((2796 >= 2496) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\7\73\208\62\140", "\62\87\59\191\73\224\54")]:IsCastable() and (UsageProwlOOC == LUAOBFUSACTOR_DECRYPT_STR_0("\198\14\237\200\254\17", "\169\135\98\154"))) or (3426 <= 1781))) then
									if Press(S.Prowl) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\219\101\43\67\241\115\216\217\114\39\91\240\49\201\223\55\112", "\168\171\23\68\52\157\83");
									end
								elseif (S[LUAOBFUSACTOR_DECRYPT_STR_0("\196\99\250\186\41", "\231\148\17\149\205\69\77")]:IsCastable() and (UsageProwlOOC == LUAOBFUSACTOR_DECRYPT_STR_0("\164\174\212\239\86\241\131\162", "\159\224\199\167\155\55")) and Target:IsInRange(ProwlRange)) then
									if (Press(S.Prowl) or (4376 <= 4070)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\231\225\51\197\251\179\44\192\242\240\51\223\245\242\40\146\163", "\178\151\147\92");
									end
								end
								if ((4636 > 3610) and UseWildCharge and S[LUAOBFUSACTOR_DECRYPT_STR_0("\187\244\64\54\49\68\123\158\250\73", "\26\236\157\44\82\114\44")]:IsCastable() and not Target:IsInRange(8)) then
									if (Press(S.WildCharge, not Target:IsInRange(28)) or (24 == 1960)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\61\39\217\95\21\45\221\90\56\41\208\27\58\60\208\88\37\35\215\90\62\110\131", "\59\74\78\181");
									end
								end
								FlatIdent_40663 = 1;
							end
							if ((FlatIdent_40663 == 1) or (805 > 4162)) then
								FlatIdent_7FA38 = 2;
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function Variables()
		local FlatIdent_81306 = 0;
		local FlatIdent_7557A;
		local FlatIdent_60906;
		local DungeonSlice;
		local CombatTime;
		local TimeCheck;
		while true do
			if ((639 < 3347) and (4904 == 4904) and (FlatIdent_81306 == 1)) then
				DungeonSlice = nil;
				CombatTime = nil;
				FlatIdent_81306 = 2;
			end
			if ((4167 <= 4286) and ((FlatIdent_81306 == 0) or (2525 > 4643))) then
				FlatIdent_7557A = 0;
				FlatIdent_60906 = nil;
				FlatIdent_81306 = 1;
			end
			if ((2 == FlatIdent_81306) or (3983 < 1150)) then
				TimeCheck = nil;
				while true do
					if ((3441 < 3525) and (FlatIdent_7557A == 0)) then
						FlatIdent_60906 = 0;
						DungeonSlice = nil;
						FlatIdent_7557A = 1;
					end
					if (FlatIdent_7557A == 2) then
						while true do
							if ((4114 < 4964) and (FlatIdent_60906 == (0 + 0))) then
								local FlatIdent_265BB = 0;
								while true do
									if (((4066 < 4247) and (FlatIdent_265BB == 1)) or (1161 == 2575)) then
										VarAlign3Mins = (EnemiesCount11y == 1) and not DungeonSlice;
										FlatIdent_60906 = 1;
										break;
									end
									if ((0 == FlatIdent_265BB) or (3531 > 3543)) then
										local FlatIdent_29127 = 0;
										while true do
											if (FlatIdent_29127 == 1) then
												FlatIdent_265BB = 1;
												break;
											end
											if ((543 == 543) and ((FlatIdent_29127 == (0 - 0)) or (1446 < 545))) then
												VarNeedBT = S[LUAOBFUSACTOR_DECRYPT_STR_0("\195\196\61\245\235\36\253\78\238\198\33", "\34\129\168\82\154\143\80\156")]:IsAvailable() and (Player:BuffStack(S.BloodtalonsBuff) <= 1);
												DungeonSlice = Player:IsInParty() and not Player:IsInRaid();
												FlatIdent_29127 = 819 - (667 + 151);
											end
										end
									end
								end
							end
							if ((FlatIdent_60906 == 1) or (616 == 199)) then
								local FlatIdent_E088 = 0;
								while true do
									if ((FlatIdent_E088 == 0) or (4384 <= 2280) or (3788 < 44)) then
										VarLastConvoke = (FightRemains > (obf_AND(S[LUAOBFUSACTOR_DECRYPT_STR_0("\166\189\61\29\71\69\140\177\186\54\56\88\71\155\140\166\32", "\233\229\210\83\107\40\46")]:CooldownRemains(), 1500 - (1410 + 87)) + obf_OR(S[LUAOBFUSACTOR_DECRYPT_STR_0("\166\189\61\29\71\69\140\177\186\54\56\88\71\155\140\166\32", "\233\229\210\83\107\40\46")]:CooldownRemains(), 3))) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\224\81\58\215\8\192\76\55\197\34\212\75\54\215\11\194\71", "\101\161\34\82\182")]:IsAvailable() and (FightRemains < (obf_AND(S[LUAOBFUSACTOR_DECRYPT_STR_0("\203\2\87\232\212\233\135\26\224\8\106\238\210\240\139\58\251", "\78\136\109\57\158\187\130\226")]:CooldownRemains(), 60) + obf_OR(S[LUAOBFUSACTOR_DECRYPT_STR_0("\203\2\87\232\212\233\135\26\224\8\106\238\210\240\139\58\251", "\78\136\109\57\158\187\130\226")]:CooldownRemains(), 60)))) or (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\31\44\241\240\51\62\247\244\45\24\236\248\58\62\247\242\59", "\145\94\95\153")]:IsAvailable() and (FightRemains < (obf_AND(S[LUAOBFUSACTOR_DECRYPT_STR_0("\222\194\26\195\65\188\248\249\28\208\125\167\244\223\29\193\93", "\215\157\173\116\181\46")]:CooldownRemains(), 12) + obf_OR(S[LUAOBFUSACTOR_DECRYPT_STR_0("\222\194\26\195\65\188\248\249\28\208\125\167\244\223\29\193\93", "\215\157\173\116\181\46")]:CooldownRemains(), 12)))));
										VarLastZerk = (FightRemains > (30 + (BsInc:CooldownRemains() / 1.6))) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\23\177\153\225\223\39\191\163\247\219\39\160\132\244\206\61\177\167\251\213\59", "\186\85\212\235\146")]:IsAvailable() and (FightRemains < (obf_AND(243 - 153, BsInc:CooldownRemains() / (1898.6 - (1504 + 393))) + obf_OR(90, BsInc:CooldownRemains() / (1898.6 - (1504 + 393)))))) or (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\224\132\4\237\60\252\83\234\132\23\236\45\225\94\214\137\19\210\48\225\86", "\56\162\225\118\158\89\142")]:IsAvailable() and (FightRemains < (obf_AND(466 - 286, BsInc:CooldownRemains()) + obf_OR(180, BsInc:CooldownRemains())))));
										FlatIdent_E088 = 1;
									end
									if (FlatIdent_E088 == (797 - (461 + 335))) then
										VarZerkBiteweave = true;
										FlatIdent_60906 = 1 + 1;
										break;
									end
								end
							end
							if (((4564 > 598) and (FlatIdent_60906 == 2)) or (4790 < 2768)) then
								local FlatIdent_5693A = 0;
								while true do
									if (FlatIdent_5693A == 1) then
										VarForceAlign2Min = true;
										FlatIdent_60906 = 3;
										break;
									end
									if ((FlatIdent_5693A == 0) or (4805 < 3074)) then
										local FlatIdent_85E0E = 0;
										while true do
											if ((FlatIdent_85E0E == (1761 - (1730 + 31))) or (2084 >= 3519)) then
												VarRegrowth = true;
												VarEasySwipe = true;
												FlatIdent_85E0E = 1;
											end
											if ((4855 > 3864) and (FlatIdent_85E0E == 1)) then
												FlatIdent_5693A = 1668 - (728 + 939);
												break;
											end
										end
									end
								end
							end
							if ((4274 == 4274) and (FlatIdent_60906 == 3)) then
								CombatTime = EL.CombatTime();
								TimeCheck = obf_AND(CombatTime, FightRemains) + obf_OR(CombatTime, FightRemains);
								VarAlignCDs = (VarForceAlign2Min or I[LUAOBFUSACTOR_DECRYPT_STR_0("\107\12\212\167\39\202\94\4\210\164\49\250\78\4\206\172\42", "\184\60\101\160\207\66")]:IsEquipped() or I[LUAOBFUSACTOR_DECRYPT_STR_0("\16\145\116\185\34\141\122\168\57\135\89\177\51\135\110\175\62\151\112", "\220\81\226\28")]:IsEquipped() or ((TimeCheck > 150) and (TimeCheck < 200)) or ((TimeCheck > 270) and (TimeCheck < 295)) or ((TimeCheck > 395) and (TimeCheck < 400)) or ((TimeCheck > (1735 - 1245)) and (TimeCheck < (1003 - 508)))) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\48\218\140\237\229\204\22\225\138\254\217\215\26\199\139\239\249", "\167\115\181\226\155\138")]:IsAvailable() and not DungeonSlice and (EnemiesCount11y == 1) and Player:HasTier(31, 4 - 2);
								break;
							end
						end
						break;
					end
					if (FlatIdent_7557A == 1) then
						CombatTime = nil;
						TimeCheck = nil;
						FlatIdent_7557A = 2;
					end
				end
				break;
			end
		end
	end
	local function Builder()
		local FlatIdent_96E45 = 0;
		local FlatIdent_546BA;
		local FlatIdent_1306;
		while true do
			if ((1029 == 1029) and (FlatIdent_96E45 == 1)) then
				while true do
					if (FlatIdent_546BA == (1068 - (138 + 930))) then
						FlatIdent_1306 = 0;
						while true do
							if ((89 == 89) and (3747 == 3747) and (FlatIdent_1306 == 2)) then
								local FlatIdent_82BA = 0;
								while true do
									if ((3889 < 4766) and (FlatIdent_82BA == 1)) then
										if ((2628 > 2464) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\45\180\56\107\230\228\60\170\44\108\239", "\136\111\198\77\31\135")]:IsReady() and not (VarNeedBT and BTBuffUp(S.BrutalSlash))) then
											if (Press(S.BrutalSlash, not IsInAoERange) or (810 > 944)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\0\27\178\66\188\232\40\186\14\8\180\94\253\230\2\160\14\13\162\68\253\181\69", "\201\98\105\199\54\221\132\119");
											end
										end
										FlatIdent_1306 = 3;
										break;
									end
									if ((FlatIdent_82BA == 0) or (3197 <= 2999)) then
										local FlatIdent_1146B = 0;
										while true do
											if ((0 == FlatIdent_1146B) or (952 <= 71) or (3503 <= 13)) then
												if ((2347 >= 423) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\1\231\114\228\73\193\134\36\220\90", "\224\77\174\63\139\38\175")]:IsReady()) then
													if ((4997 >= 4775) and Everyone.CastCycle(S.LIMoonfire, Enemies11y, EvaluateCycleLIMoonfire, not Target:IsSpellInRange(S.LIMoonfire), nil, nil, M.MoonfireMouseover)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\137\78\87\32\130\72\74\43\187\66\89\58\196\67\77\39\136\69\93\60\196\25", "\78\228\33\56");
													end
												end
												if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\250\118\160\2\150\198", "\229\174\30\210\99")]:IsCastable() and Target:DebuffRefreshable(S.ThrashDebuff) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\47\229\148\80\254\53\48\21\234\165\93\236\42\42", "\89\123\141\230\49\141\93")]:IsAvailable()) then
													if (((3333 < 3636) and Press(S.Thrash, not IsInAoERange)) or (4949 <= 3018)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\231\121\228\13\3\66\179\115\227\5\28\78\246\99\182\93\64", "\42\147\17\150\108\112");
													end
												end
												FlatIdent_1146B = 1;
											end
											if ((1602 >= 298) and (3706 >= 2393) and (1 == FlatIdent_1146B)) then
												FlatIdent_82BA = 1;
												break;
											end
										end
									end
								end
							end
							if ((4189 >= 4175) and (1756 < 3743) and (FlatIdent_1306 == 0)) then
								local FlatIdent_26E4 = 0;
								while true do
									if (FlatIdent_26E4 == 0) then
										if ((4621 >= 1815) and (2598 <= 3220) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\214\42\245\93\104\121", "\166\130\66\135\60\27\17")]:IsCastable() and Target:DebuffRefreshable(S.ThrashDebuff) and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\96\67\220\112\22\77\82\207\97\57\75\68", "\80\36\42\174\21")]:IsAvailable() or (S[LUAOBFUSACTOR_DECRYPT_STR_0("\106\25\37\127\104\25\47\123\90\25\56\116", "\26\46\112\87")]:IsAvailable() and Target:DebuffUp(S.DireFixationDebuff))) and Player:BuffUp(S.Clearcasting) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\141\43\185\117\172\183\76\186\190\0\167\117\168\172", "\212\217\67\203\20\223\223\37")]:IsAvailable()) then
											if Press(S.Thrash, not IsInAoERange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\174\133\186\211\169\133\232\208\175\132\164\214\191\159\232\128", "\178\218\237\200");
											end
										end
										if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\133\189\244\213\178", "\176\214\213\134")]:IsReady() and (Player:BuffUp(S.Clearcasting) or (S[LUAOBFUSACTOR_DECRYPT_STR_0("\208\164\164\209\142\95\65\245\185\191\219\166", "\57\148\205\214\180\200\54")]:IsAvailable() and Target:DebuffDown(S.DireFixationDebuff))) and not (VarNeedBT and BTBuffUp(S.Shred))) or (4962 <= 3676)) then
											if ((1897 >= 326) and Press(S.Shred, not IsInMeleeRange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\1\245\39\49\114\82\255\32\61\122\22\248\39\116\34", "\22\114\157\85\84");
											end
										end
										FlatIdent_26E4 = 1;
									end
									if ((FlatIdent_26E4 == 1) or (2811 < 2702)) then
										if ((3539 > 1888) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\230\217\6\208\92\250\155\200\202\0\204", "\200\164\171\115\164\61\150")]:IsReady() and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\156\230\22\81\130\178\199\15\68\144\182", "\227\222\148\99\37")]:FullRechargeTime() < (4 + 0)) and not (VarNeedBT and BTBuffUp(S.BrutalSlash))) or (3467 < 3261))) then
											if ((1461 <= 2309) and Press(S.BrutalSlash, not IsInAoERange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\49\64\71\226\248\63\109\65\250\248\32\90\18\244\236\58\94\86\243\235\115\4", "\153\83\50\50\150");
											end
										end
										FlatIdent_1306 = 1;
										break;
									end
								end
							end
							if (FlatIdent_1306 == 3) then
								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\138\27\138\49\7", "\204\217\108\227\65\98\85")]:IsReady() and ((EnemiesCount11y > 1) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\105\202\249\225\31\204\95\208\253\224\63", "\160\62\163\149\133\76")]:IsAvailable())) then
									if ((985 < 2861) and (Press(S.Swipe, not IsInAoERange) or (4669 < 511))) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\197\183\4\63\198\150\162\24\38\207\210\165\31\111\146\130", "\163\182\192\109\79");
									end
								end
								if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\7\46\18\197\241", "\149\84\70\96\160")]:IsReady() and not (VarNeedBT and BTBuffUp(S.Shred))) or (4777 == 4762)) then
									if Press(S.Shred, not IsInMeleeRange) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\43\14\31\232\60\70\15\248\49\10\9\232\42\70\92\187", "\141\88\102\109");
									end
								end
								if ((1768 == 1768) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\159\122\231\127\21\51\83\200\161\86", "\161\211\51\170\16\122\93\53")]:IsReady() and VarNeedBT and BTBuffDown(S.LIMoonfire)) or (4222 <= 1868))) then
									if ((3346 > 1448) and Press(S.LIMoonfire, not Target:IsSpellInRange(S.LIMoonfire))) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\246\161\189\38\253\167\160\45\196\173\179\60\187\172\167\33\247\170\183\58\187\255\234", "\72\155\206\210");
									end
								end
								FlatIdent_1306 = 4 + 0;
							end
							if ((4 == FlatIdent_1306) or (2418 > 4432)) then
								if ((1758 <= 3423) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\117\109\93\30\54", "\83\38\26\52\110")]:IsReady() and VarNeedBT and BTBuffDown(S.Swipe)) then
									if (Press(S.Swipe, not IsInAoERange) or (2091 > 3050)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\75\0\46\86\93\87\37\83\81\27\35\67\74\87\117\22", "\38\56\119\71");
									end
								end
								if ((3090 >= 102) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\193\238\83\211", "\54\147\143\56\182\69")]:IsReady() and VarNeedBT and BTBuffDown(S.Rake) and (Player:PMultiplier(S.Rake) >= Target:PMultiplier(S.Rake))) then
									if (((4153 > 1521) and Press(S.Rake, not IsInMeleeRange)) or (4386 <= 1106)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\196\128\244\76\159\212\148\246\69\219\211\147\191\27\141", "\191\182\225\159\41");
									end
								end
								if ((3992 >= 3533) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\31\26\58\84\152\143", "\162\75\114\72\53\235\231")]:IsCastable() and VarNeedBT and BTBuffDown(S.Thrash)) then
									if (Press(S.Thrash, not IsInAoERange) or (249 < 91)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\152\52\86\227\64\10\204\62\81\235\95\6\137\46\4\176\7", "\98\236\92\36\130\51");
									end
								end
								break;
							end
							if ((FlatIdent_1306 == (1 + 0)) or (4612 == 1807)) then
								local FlatIdent_11649 = 0;
								local FlatIdent_6F430;
								while true do
									if ((3541 <= 4155) and (0 == FlatIdent_11649)) then
										FlatIdent_6F430 = 0 - 0;
										while true do
											if ((633 <= 4454) and (FlatIdent_6F430 == 1)) then
												if ((4365 >= 2825) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\182\192\11\188", "\168\228\161\96\217\95\81")]:IsReady() and (Target:DebuffRefreshable(S.RakeDebuff) or (Player:BuffUp(S.SuddenAmbushBuff) and (Player:PMultiplier(S.Rake) > Target:PMultiplier(S.Rake)))) and not (VarNeedBT and BTBuffUp(S.Rake))) or (2328 < 377))) then
													if Press(S.Rake, not IsInMeleeRange) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\201\208\37\89\111\85\206\216\34\88\42\69\155\135", "\55\187\177\78\60\79");
													end
												end
												FlatIdent_1306 = 2;
												break;
											end
											if (FlatIdent_6F430 == 0) then
												if (((3247 == 3247) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\111\119\120\25", "\45\61\22\19\124\19\203")]:IsReady() and (Target:DebuffRefreshable(S.RakeDebuff) or (Player:BuffUp(S.SuddenAmbushBuff) and (Player:PMultiplier(S.Rake) > Target:PMultiplier(S.Rake)) and (Target:DebuffRemains(S.RakeDebuff) > 6))) and Player:BuffDown(S.Clearcasting) and not (VarNeedBT and BTBuffUp(S.Rake))) or (1053 > 3604)) then
													if ((4882 >= 3904) and (1372 < 3989) and Press(S.Pool)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\241\29\2\249\66\118\182\211\82\63\244\9\117\249\200\28\77\215\23\121\181\197\23\31\189\75", "\217\161\114\109\149\98\16");
													end
												end
												if ((3776 >= 1834) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\33\40\57\120\179\99\31\37\52\120", "\20\114\64\88\28\220")]:IsCastable() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\3\0\217\177", "\221\81\97\178\212\152\176")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (Target:DebuffRefreshable(S.RakeDebuff) or (Target:PMultiplier(S.Rake) < 1.4)) and not (VarNeedBT and BTBuffUp(S.Rake)) and Player:BuffDown(S.Prowl)) then
													if (Press(S.Shadowmeld) or (1284 >= 3991)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\222\239\28\255\21\218\234\24\247\30\141\229\8\242\22\201\226\15\187\78", "\122\173\135\125\155");
													end
												end
												FlatIdent_6F430 = 1;
											end
										end
										break;
									end
								end
							end
						end
						break;
					end
				end
				break;
			end
			if (FlatIdent_96E45 == 0) then
				FlatIdent_546BA = 0;
				FlatIdent_1306 = nil;
				FlatIdent_96E45 = 1;
			end
		end
	end
	local function AoeBuilder()
		local FlatIdent_13CA1 = 0;
		local FlatIdent_57294;
		local FlatIdent_931A7;
		while true do
			if ((FlatIdent_13CA1 == 1) or (1599 == 3736)) then
				while true do
					if ((FlatIdent_57294 == 0) or (2991 > 4434)) then
						FlatIdent_931A7 = 0;
						while true do
							if (((1769 - (459 + 1307)) == FlatIdent_931A7) or (1676 == 1704)) then
								if ((1145 <= 2799) and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\203\121\70\183\37\214", "\156\159\17\52\214\86\190")]:IsReady() or (4187 <= 3305))) then
									if ((1913 == 1913) and Press(S.Thrash, not IsInAoERange)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\186\231\175\189\189\231\253\189\161\234\130\190\187\230\177\184\171\253\253\238\248", "\220\206\143\221");
									end
								end
								break;
							end
							if ((0 == FlatIdent_931A7) or (2086 < 2040)) then
								local FlatIdent_35162 = 0;
								while true do
									if ((FlatIdent_35162 == (1872 - (474 + 1396))) or (510 == 4402)) then
										FlatIdent_931A7 = 1;
										break;
									end
									if ((FlatIdent_35162 == (0 - 0)) or (1901 >= 3884)) then
										if ((4377 >= 309) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\134\11\25\174\68\164\134\60\165\10\4", "\80\196\121\108\218\37\200\213")]:IsReady()) then
											if ((367 < 2905) and Everyone.CastTargetIf(S.BrutalSlash, Enemies11y, LUAOBFUSACTOR_DECRYPT_STR_0("\13\122\12", "\234\96\19\98\31\43\110"), EvaluateTargetIfFilterTTD, EvaluateTargetIfBrutalSlashAoeBuilder, not IsInAoERange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\4\13\71\211\173\126\180\21\19\83\212\164\50\138\9\26\109\197\185\123\135\2\26\64\135\254", "\235\102\127\50\167\204\18");
											end
										end
										if ((1697 < 2409) and (1091 == 1091) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\100\169\231\34\87\38", "\78\48\193\149\67\36")]:IsReady() and (Player:BuffUp(S.Clearcasting) or (((EnemiesCount11y > 10) or ((EnemiesCount11y > 5) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\20\17\149\26\77\53\61\140\25\86\53\26\178\25\74\53", "\33\80\126\224\120")]:IsAvailable())) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\216\160\17\197\79\228\161\13\195\127\224\169\20\215", "\60\140\200\99\164")]:IsAvailable()))) then
											if Everyone.CastCycle(S.Thrash, Enemies11y, EvaluateCycleThrash, not IsInAoERange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\147\252\22\39\177\143\180\5\41\167\184\246\17\47\174\131\241\22\102\246", "\194\231\148\100\70");
											end
										end
										FlatIdent_35162 = 1 + 0;
									end
									if (((3782 < 3851) and (FlatIdent_35162 == 1)) or (3877 <= 2723)) then
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\117\68\192\167\249\223\75\73\205\167", "\168\38\44\161\195\150")]:IsReady() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\178\253\137\115", "\118\224\156\226\22\80\136\214")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (DebuffRefreshAny(Enemies11y, S.RakeDebuff) or (LowRakePMult(Enemies11y) < 1.4)) and Player:BuffDown(S.Prowl) and Player:BuffDown(S.ApexPredatorsCravingBuff)) then
											if Press(S.Shadowmeld) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\81\230\88\132\77\249\84\133\78\234\25\129\77\235\102\130\87\231\85\132\71\252\25\214", "\224\34\142\57");
											end
										end
										if (((677 <= 1197) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\237\175\196\217\124\230\80\11\210\163", "\110\190\199\165\189\19\145\61")]:IsReady() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\232\234\124\237", "\167\186\139\23\136\235")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (LowRakePMult(Enemies11y) < 1.4) and Player:BuffDown(S.Prowl) and Player:BuffDown(S.ApexPredatorsCravingBuff)) or (2493 < 2135)) then
											if Press(S.Shadowmeld) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\9\189\137\9\21\162\133\8\22\177\200\12\21\176\183\15\15\188\132\9\31\167\200\85", "\109\122\213\232");
											end
										end
										FlatIdent_35162 = 2;
									end
								end
							end
							if (((3950 == 3950) and (FlatIdent_931A7 == 2)) or (1039 >= 1586)) then
								local FlatIdent_41BE4 = 0;
								while true do
									if (1 == FlatIdent_41BE4) then
										if S[LUAOBFUSACTOR_DECRYPT_STR_0("\26\96\222\31\124\192\48\64\225\21", "\174\86\41\147\112\19")]:IsReady() then
											if Everyone.CastTargetIf(S.LIMoonfire, Enemies11y, LUAOBFUSACTOR_DECRYPT_STR_0("\86\1\149", "\203\59\96\237\107\69\111\113"), EvaluateTargetIfFilterLIMoonfire, EvaluateTargetIfLIMoonfireAoEBuilder, not Target:IsSpellInRange(S.LIMoonfire)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\41\25\163\239\55\249\197\33\41\175\224\37\176\214\43\19\147\227\36\249\219\32\19\190\242\113\162\133", "\183\68\118\204\129\81\144");
											end
										end
										if ((4848 >= 141) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\61\165\98\225\15", "\226\110\205\16\132\107")]:IsReady() and ((EnemiesCount11y < 4) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\207\202\242\220\103\226\219\225\205\72\228\205", "\33\139\163\128\185")]:IsAvailable()) and Player:BuffDown(S.SuddenAmbushBuff) and not (VarEasySwipe and S[LUAOBFUSACTOR_DECRYPT_STR_0("\96\81\8\218\100\84\5\205\95\93\23", "\190\55\56\100")]:IsAvailable())) then
											if Everyone.CastTargetIf(S.Shred, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\91\174\36", "\147\54\207\92\126\115\131"), EvaluateTargetIfFilterTTD, nil, not IsInMeleeRange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\30\57\39\120\9\62\12\62\48\66\15\107\4\61\49\120\31\62\95\101", "\30\109\81\85\29\109");
											end
										end
										FlatIdent_41BE4 = 2;
									end
									if (2 == FlatIdent_41BE4) then
										FlatIdent_931A7 = 3;
										break;
									end
									if ((2474 <= 4531) and (3538 < 3871) and (0 == FlatIdent_41BE4)) then
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\135\234\102\73\76\68\61\68\185\198", "\45\203\163\43\38\35\42\91")]:IsReady() and (EnemiesCount11y < (1 + 4))) then
											if ((3810 > 3164) and Everyone.CastTargetIf(S.LIMoonfire, Enemies11y, LUAOBFUSACTOR_DECRYPT_STR_0("\223\132\196", "\52\178\229\188\67\231\201"), EvaluateTargetIfFilterLIMoonfire, EvaluateTargetIfLIMoonfireAoEBuilder, not Target:IsSpellInRange(S.LIMoonfire))) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\44\78\95\10\241\85\49\36\126\83\5\227\28\34\46\68\111\6\226\85\47\37\68\66\23\183\13\123", "\67\65\33\48\100\151\60");
											end
										end
										if ((2432 > 980) and (2557 <= 2601) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\236\240\167\200\246", "\147\191\135\206\184")]:IsReady()) then
											if ((1069 == 1069) and Press(S.Swipe, not IsInAoERange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\151\63\175\209\221\19\179\139\45\153\195\205\90\190\128\45\180\129\138\3", "\210\228\72\198\161\184\51");
											end
										end
										FlatIdent_41BE4 = 2 - 1;
									end
								end
							end
							if ((FlatIdent_931A7 == (1 + 0)) or (4793 < 2333)) then
								local FlatIdent_81C66 = 0 - 0;
								local FlatIdent_55BDF;
								while true do
									if (((2318 > 1082) and (FlatIdent_81C66 == 0)) or (4926 < 1320)) then
										FlatIdent_55BDF = 0;
										while true do
											if ((FlatIdent_55BDF == 0) or (3285 >= 3449)) then
												if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\220\246\169\53", "\80\142\151\194")]:IsReady() and (Player:BuffUp(S.SuddenAmbushBuff))) or (525 > 1349)) then
													if Everyone.CastTargetIf(S.Rake, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\14\199\111", "\44\99\166\23"), EvaluateTargetIfFilterRakeTicks, EvaluateTargetIfRakeAoeBuilder, not IsInMeleeRange) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\110\246\34\51\115\165\115\242\22\52\38\173\112\243\44\36\115\245\44", "\196\28\151\73\86\83");
													end
												end
												if S[LUAOBFUSACTOR_DECRYPT_STR_0("\193\2\34\21", "\22\147\99\73\112\226\56\120")]:IsReady() then
													if Everyone.CastCycle(S.Rake, EnemiesMelee, EvaluateCycleRakeAoeBuilder, not IsInMeleeRange, nil, nil, M.RakeMouseover) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\170\116\233\240\205\185\122\231\202\143\173\124\238\241\136\170\53\179\167", "\237\216\21\130\149");
													end
												end
												FlatIdent_55BDF = 1;
											end
											if ((FlatIdent_55BDF == 1) or (3810 >= 4154)) then
												local FlatIdent_AF38 = 0;
												while true do
													if ((1769 == 1769) and (0 == FlatIdent_AF38)) then
														if (((2423 == 2423) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\182\70\77\94\163\193", "\62\226\46\63\63\208\169")]:IsReady() and (Target:DebuffRefreshable(S.ThrashDebuff))) or (1840 <= 1445)) then
															if Press(S.Thrash, not IsInAoERange) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\241\17\71\130\12\5\111\95\234\28\106\129\10\4\35\90\224\11\21\210\75", "\62\133\121\53\227\127\109\79");
															end
														end
														if ((4712 >= 3813) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\50\6\39\225\215\162\145\28\21\33\253", "\194\112\116\82\149\182\206")]:IsReady()) then
															if (Press(S.BrutalSlash, not IsInAoERange) or (153 == 2063) or (3252 <= 538)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\59\186\89\12\193\238\49\42\164\77\11\200\162\15\54\173\115\26\213\235\2\61\173\94\88\145\180", "\110\89\200\44\120\160\130");
															end
														end
														FlatIdent_AF38 = 1;
													end
													if (FlatIdent_AF38 == 1) then
														FlatIdent_55BDF = 2;
														break;
													end
												end
											end
											if (FlatIdent_55BDF == 2) then
												FlatIdent_931A7 = 2;
												break;
											end
										end
										break;
									end
								end
							end
						end
						break;
					end
				end
				break;
			end
			if ((0 == FlatIdent_13CA1) or (2584 == 3247)) then
				FlatIdent_57294 = 0;
				FlatIdent_931A7 = nil;
				FlatIdent_13CA1 = 1;
			end
		end
	end
	local function Finisher()
		local FlatIdent_46DBF = 0;
		local FlatIdent_589FE;
		while true do
			if (FlatIdent_46DBF == (0 - 0)) then
				FlatIdent_589FE = 591 - (562 + 29);
				while true do
					if ((1 == FlatIdent_589FE) or (1755 <= 693)) then
						if (((3413 == 3413) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\9\23\64\65\244\142\4\58\1\112\71\227\130", "\107\79\114\50\46\151\231")]:IsReady() and Player:BuffDown(S.ApexPredatorsCravingBuff) and (Player:BuffDown(BsInc) or (Player:BuffUp(BsInc) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\10\169\160\37\133\63\163\200\60\128\186\59\143\42\163", "\160\89\198\213\73\234\89\215")]:IsAvailable()))) or (1291 > 3029)) then
							if ((not S[LUAOBFUSACTOR_DECRYPT_STR_0("\124\120\179\251\215\91\87\161\236\220", "\165\40\17\212\158")]:IsReady() and Player:BuffDown(S.ApexPredatorsCravingBuff)) or (946 == 2209)) then
								if CastPooling(S.FerociousBite, Player:EnergyTimeToX(50)) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\227\220\26\60\37\236\214\29\32\25\231\208\28\54\102\227\208\6\58\53\237\220\26\115\112", "\70\133\185\104\83");
								end
							elseif ((Player:Energy() < (43 + 7)) or (4591 <= 3060) or (866 > 4384)) then
							elseif Everyone.CastTargetIf(S.FerociousBite, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\9\68\92", "\169\100\37\36\74"), EvaluateTargetIfFilterTTD, nil, not IsInMeleeRange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\6\130\176\95\3\142\173\69\19\184\160\89\20\130\226\86\9\137\171\67\8\130\176\16\88", "\48\96\231\194");
							end
						end
						if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\238\95\28\34\26\209\160\150\219\120\7\57\28", "\227\168\58\110\77\121\184\207")]:IsReady() and ((Player:BuffUp(BsInc) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\72\51\170\76\190\221\101\173\126\26\176\82\180\200\101", "\197\27\92\223\32\209\187\17")]:IsAvailable()) or Player:BuffUp(S.ApexPredatorsCravingBuff))) then
							if (Everyone.CastTargetIf(S.FerociousBite, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\14\94\219", "\155\99\63\163"), EvaluateTargetIfFilterTTD, nil, not IsInMeleeRange) or (3292 < 1467) or (2992 <= 1370)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\132\212\179\130\186\141\141\196\178\178\187\141\150\212\225\139\176\138\139\194\169\136\171\196\211\129", "\228\226\177\193\237\217");
							end
						end
						break;
					end
					if ((4817 == 4817) and (FlatIdent_589FE == 0)) then
						local FlatIdent_63C75 = 0;
						while true do
							if ((FlatIdent_63C75 == (1419 - (374 + 1045))) or (1370 == 608)) then
								if ((788 < 4081) and (3133 >= 1678) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\182\111\36\26\217\192\229\148\124\57\31", "\178\230\29\77\119\184\172")]:IsCastable() and (Target:DebuffRefreshable(S.PrimalWrath) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\193\187\11\9\88\232\240\176\61\20\98\246\241\173", "\152\149\222\106\123\23")]:IsAvailable() or ((EnemiesCount11y > 4) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\239\39\251\83\180\211\50\208\70\167\210\37\255\87\172", "\213\189\70\150\35")]:IsAvailable())) and (EnemiesCount11y > 1) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\127\71\125\5\78\89\67\26\78\65\124", "\104\47\53\20")]:IsAvailable()) then
									if ((4721 > 1294) and CastPooling(S.PrimalWrath, Player:EnergyTimeToX(20))) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\179\94\136\17\189\3\156\91\147\29\168\7\227\74\136\18\181\28\171\73\147\92\238", "\111\195\44\225\124\220");
									end
								end
								if S[LUAOBFUSACTOR_DECRYPT_STR_0("\234\79\16", "\203\184\38\96\19\203")]:IsReady() then
									if Everyone.CastCycle(S.Rip, EnemiesMelee, EvaluateCycleRip, not Target:IsInRange(8), nil, nil, M.RipMouseover) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\43\122\105\1\200\48\125\112\82\198\60\97\57\21", "\174\89\19\25\33");
									end
								end
								FlatIdent_63C75 = 1 + 0;
							end
							if (FlatIdent_63C75 == 1) then
								FlatIdent_589FE = 1;
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function Berserk()
		local FlatIdent_6E609 = 0;
		local FlatIdent_32D53;
		while true do
			if ((2339 > 29) and (FlatIdent_6E609 == (0 - 0))) then
				FlatIdent_32D53 = 638 - (448 + 190);
				while true do
					if ((FlatIdent_32D53 == (2 + 2)) or (2719 == 338)) then
						if ((2023 < 3715) and (2263 <= 4336) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\56\143\182\65\15", "\36\107\231\196")]:IsReady()) then
							if ((3517 < 3859) and Press(S.Shred, not IsInMeleeRange)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\78\189\176\130\89\245\160\130\79\166\167\149\86\245\240\213", "\231\61\213\194");
							end
						end
						break;
					end
					if (FlatIdent_32D53 == 0) then
						local FlatIdent_817B6 = 0 + 0;
						while true do
							if ((FlatIdent_817B6 == (1 + 0)) or (1156 <= 385) or (2180 == 3317)) then
								if ((EnemiesCount11y <= 1) or (1767 > 4108) or (3098 <= 1172)) then
								else
									local FlatIdent_461B2 = 0;
									local FlatIdent_30D8C;
									local FlatIdent_39168;
									local ShouldReturn;
									while true do
										if ((4216 >= 814) and (3132 < 3745) and (FlatIdent_461B2 == 1)) then
											ShouldReturn = nil;
											while true do
												if ((FlatIdent_30D8C == 0) or (4858 == 4942)) then
													FlatIdent_39168 = 0;
													ShouldReturn = nil;
													FlatIdent_30D8C = 3 - 2;
												end
												if (((1649 <= 2572) and (FlatIdent_30D8C == 1)) or (3975 == 4556)) then
													while true do
														if ((FlatIdent_39168 == 0) or (4424 <= 3216) or (1822 < 969)) then
															local FlatIdent_8ECFB = 0;
															local FlatIdent_54376;
															while true do
																if ((FlatIdent_8ECFB == 0) or (1756 < 1301)) then
																	FlatIdent_54376 = 0;
																	while true do
																		if ((3768 == 3768) and (FlatIdent_54376 == (2 - 1))) then
																			FlatIdent_39168 = 1;
																			break;
																		end
																		if ((2198 >= 1225) and (FlatIdent_54376 == (1494 - (1307 + 187)))) then
																			ShouldReturn = AoeBuilder();
																			if ((3105 == 3105) and (ShouldReturn or (1564 > 3638))) then
																				return ShouldReturn;
																			end
																			FlatIdent_54376 = 1;
																		end
																	end
																	break;
																end
															end
														end
														if (FlatIdent_39168 == 1) then
															if ((1719 <= 3213) and (2442 < 4070) and Press(S.Pool)) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\99\117\15\39\14\82\119\70\52\39\60\75\118\109\93\120\2\54\92\28\49", "\24\52\20\102\83\46\52");
															end
															break;
														end
													end
													break;
												end
											end
											break;
										end
										if (FlatIdent_461B2 == 0) then
											FlatIdent_30D8C = 0;
											FlatIdent_39168 = nil;
											FlatIdent_461B2 = 3 - 2;
										end
									end
								end
								FlatIdent_32D53 = 1;
								break;
							end
							if ((FlatIdent_817B6 == 0) or (3968 <= 1084) or (3004 <= 2878)) then
								if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\18\181\49\233\55\185\44\243\39\146\42\242\49", "\134\84\208\67")]:IsReady() and (ComboPoints == 5) and VarZerkBiteweave and (EnemiesCount11y > 1)) or (4515 == 4788)) then
									if (Everyone.CastTargetIf(S.FerociousBite, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\30\173\158", "\60\115\204\230"), EvaluateTargetIfFilterTTD, EvaluateTargetIfFerociousBiteBerserk, not IsInMeleeRange) or (4137 < 1807)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\225\63\249\127\228\51\228\101\244\5\233\121\243\63\171\114\226\40\248\117\245\49\171\34", "\16\135\90\139");
									end
								end
								if ((ComboPoints == 5) and not ((Player:BuffStack(S.OverflowingPowerBuff) <= 1) and (CountActiveBtTriggers() == 2) and (Player:BuffStack(S.BloodtalonsBuff) <= 1) and Player:HasTier(30, 4))) then
									local FlatIdent_47707 = 0;
									local ShouldReturn;
									while true do
										if ((FlatIdent_47707 == (0 - 0)) or (443 >= 1460)) then
											ShouldReturn = Finisher();
											if ((3106 <= 3129) and ShouldReturn) then
												return ShouldReturn;
											end
											break;
										end
									end
								end
								FlatIdent_817B6 = 1;
							end
						end
					end
					if (FlatIdent_32D53 == 1) then
						local FlatIdent_5EBF2 = 0;
						while true do
							if ((47 < 1298) and ((FlatIdent_5EBF2 == 1) or (2707 < 255))) then
								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\195\235\39\179", "\69\145\138\76\214")]:IsReady() and not (BTBuffUp(S.Rake) and (CountActiveBtTriggers() == 2)) and ((Target:DebuffRemains(S.RakeDebuff) < 3) or (Player:BuffUp(S.SuddenAmbushBuff) and (Player:PMultiplier(S.Rake) > Target:PMultiplier(S.Rake))))) then
									if Press(S.Rake, not IsInMeleeRange) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\98\206\130\140\255\20\117\221\154\140\173\29\48\151", "\118\16\175\233\233\223");
									end
								end
								FlatIdent_32D53 = 5 - 3;
								break;
							end
							if ((2250 <= 4114) and (3982 <= 4852) and (FlatIdent_5EBF2 == 0)) then
								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\244\61\46\51\3", "\111\164\79\65\68")]:IsReady() and not (BTBuffUp(S.Rake) and (CountActiveBtTriggers() == 2)) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\244\216\136\219", "\138\166\185\227\190\78")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (Target:DebuffRefreshable(S.RakeDebuff) or (Target:PMultiplier(S.Rake) < 1.4)) and Player:BuffDown(S.Shadowmeld)) then
									if ((4673 == 4673) and Press(S.Prowl)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\219\102\202\32\94\99\27\206\102\214\50\64\40\89\159", "\121\171\20\165\87\50\67");
									end
								end
								if ((2927 < 3035) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\245\48\184\50\182\21\203\61\181\50", "\98\166\88\217\86\217")]:IsCastable() and not (BTBuffUp(S.Rake) and (CountActiveBtTriggers() == (685 - (232 + 451)))) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\196\247\114\4", "\188\150\150\25\97\230")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (Target:DebuffRefreshable(S.RakeDebuff) or (Target:PMultiplier(S.Rake) < 1.4)) and Player:BuffDown(S.Prowl)) then
									if ((262 < 4193) and Press(S.Shadowmeld)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\201\129\94\6\3\250\215\140\83\6\76\239\223\155\76\7\30\230\154\223", "\141\186\233\63\98\108");
									end
								end
								FlatIdent_5EBF2 = 1;
							end
						end
					end
					if ((4435 >= 1961) and (FlatIdent_32D53 == 2)) then
						if ((2960 > 856) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\184\140\39\190\234", "\29\235\228\85\219\142\235")]:IsReady() and (CountActiveBtTriggers() == 2) and BTBuffDown(S.Shred)) then
							if (Press(S.Shred, not IsInMeleeRange) or (3500 <= 631)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\46\220\168\216\115\14\37\87\47\199\191\207\124\14\118\2", "\50\93\180\218\189\23\46\71");
							end
						end
						if ((1388 == 1388) and (1842 < 3956) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\252\182\78\88\69\208\123\210\165\72\68", "\40\190\196\59\44\36\188")]:IsReady() and (CountActiveBtTriggers() == 2) and BTBuffDown(S.BrutalSlash)) then
							if Press(S.BrutalSlash, not IsInAoERange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\62\87\201\160\251\113\50\47\73\221\167\242\61\15\57\87\207\177\232\118\77\109\23", "\109\92\37\188\212\154\29");
							end
						end
						if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\40\198\137\204\62\84\2\230\182\198", "\58\100\143\196\163\81")]:IsReady() and (CountActiveBtTriggers() == 2) and BTBuffDown(S.LIMoonfire)) then
							if ((3933 > 416) and (2123 >= 1498) and Press(S.LIMoonfire, not Target:IsSpellInRange(S.LIMoonfire))) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\23\77\44\173\57\64\247\11\37\65\34\183\127\75\224\28\9\71\49\168\127\24\177", "\110\122\34\67\195\95\41\133");
							end
						end
						FlatIdent_32D53 = 3;
					end
					if (3 == FlatIdent_32D53) then
						local FlatIdent_7773D = 0;
						while true do
							if ((FlatIdent_7773D == 1) or (1979 == 1924) or (252 > 759)) then
								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\219\6\211\232\141\173\195\57\248\7\206", "\85\153\116\166\156\236\193\144")]:IsReady() and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\134\242\88\167\229\12\151\236\76\160\236", "\96\196\128\45\211\132")]:Charges() > 1) and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\17\132\105\90\244\166\172\217\33\132\116\81", "\184\85\237\27\63\178\207\212")]:IsAvailable() or Target:DebuffUp(S.DireFixationDebuff))) then
									if ((745 <= 2549) and (Press(S.BrutalSlash, not IsInAoERange) or (840 > 4348))) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\10\75\28\75\9\85\54\76\4\88\26\87\72\91\12\77\27\92\27\84\72\11\89", "\63\104\57\105");
									end
								end
								FlatIdent_32D53 = 4;
								break;
							end
							if ((4583 > 4499) and (FlatIdent_7773D == 0)) then
								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\65\185\73\75\197\125", "\182\21\209\59\42")]:IsReady() and (CountActiveBtTriggers() == 2) and BTBuffDown(S.Thrash) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\131\95\215\28\50\182\190\89\194\62\45\191\160\68", "\222\215\55\165\125\65")]:IsAvailable() and VarNeedBT) then
									if ((2746 <= 4845) and Press(S.Thrash, not IsInAoERange)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\56\217\212\27\225\201\173\72\41\195\213\31\224\202\173\27\122", "\42\76\177\166\122\146\161\141");
									end
								end
								if S[LUAOBFUSACTOR_DECRYPT_STR_0("\137\163\40\193\118\120\163\131\23\203", "\22\197\234\101\174\25")]:IsReady() then
									if ((2391 < 2591) and Everyone.CastCycle(S.LIMoonfire, Enemies11y, EvaluateCycleLIMoonfire, not Target:IsSpellInRange(S.LIMoonfire), nil, nil, M.MoonfireMouseover)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\32\59\170\210\112\166\197\131\18\55\164\200\54\173\210\148\62\49\183\215\54\254\143", "\230\77\84\197\188\22\207\183");
									end
								end
								FlatIdent_7773D = 1 + 0;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function Cooldown()
		local FlatIdent_978B7 = 0;
		local FlatIdent_161BA;
		local HighTTD;
		local _;
		while true do
			if ((4221 > 4162) and (1 == FlatIdent_978B7)) then
				_ = nil;
				while true do
					if ((2842 < 4835) and (FlatIdent_161BA == 3)) then
						if ((CDs and I[LUAOBFUSACTOR_DECRYPT_STR_0("\216\93\252\71\70\111\242", "\26\156\55\157\53\51")]:IsEquippedAndReady()) or (1429 >= 3843) or (1195 >= 1319)) then
							if (Press(M.Djaruun, not IsInMeleeRange) or (2629 > 3045)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\136\210\23\203\173\69\130\231\6\208\180\92\141\202\41\214\190\111\152\208\19\230\189\92\136\221\4\230\190\92\141\213\19\153\181\81\133\214\86\141", "\48\236\184\118\185\216");
							end
						end
						break;
					end
					if (FlatIdent_161BA == 0) then
						HighTTD, _ = HighestTTD(Enemies11y);
						if ((3414 > 2251) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\32\163\62\114\27\163\60\103\0\162\51", "\19\105\205\93")]:IsReady() and CDs and (((HighTTD < FightRemains) and (HighTTD > 25)) or (HighTTD == FightRemains))) then
							if Press(S.Incarnation, not IsInMeleeRange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\160\6\221\128\45\167\9\202\136\48\167\72\221\142\48\165\12\209\150\49\233\94", "\95\201\104\190\225");
							end
						end
						if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\141\206\211\221\170\217\202", "\174\207\171\161")]:IsReady() and CDs and ((FightRemains < 25) or (S[LUAOBFUSACTOR_DECRYPT_STR_0("\206\241\3\229\247\220\232\202\5\246\203\199\228\236\4\231\235", "\183\141\158\109\147\152")]:IsAvailable() and ((FightRemains < S[LUAOBFUSACTOR_DECRYPT_STR_0("\15\6\232\26\35\2\227\56\36\12\213\28\37\27\239\24\63", "\108\76\105\134")]:CooldownRemains()) or (VarAlignCDs and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\205\192\163\224\194\205\215\180\239\212\242", "\174\139\165\209\129")]:IsReady() and ((ComboPoints < 3) or ((EL.CombatTime() < 10) and (ComboPoints < 4)))) or ((EL.CombatTime() < (9 + 1)) and (ComboPoints < (568 - (510 + 54))))) and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\128\188\236\215\201\8\117\76\171\182\209\209\207\17\121\108\176", "\24\195\211\130\161\166\99\16")]:CooldownRemains() < 10)))))) then
							if ((2820 > 224) and Press(S.Berserk, not IsInMeleeRange)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\68\6\251\63\86\4\77\67\234\35\92\26\66\12\254\34\19\78", "\118\38\99\137\76\51");
							end
						end
						if ((3447 >= 2905) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\223\35\23\1\12\50\246", "\64\157\70\101\114\105")]:IsReady() and CDs and not VarAlignCDs and not (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\102\186\166\237\4\73\171\138\236\29\69\166\179\246\29", "\112\32\200\199\131")]:IsAvailable() and I[LUAOBFUSACTOR_DECRYPT_STR_0("\27\89\72\176\198\185\32\45\66\87\171\225\185\35\34\83\84", "\66\76\48\60\216\163\203")]:IsEquipped() and (EnemiesCount11y == 1)) and (not VarLastZerk or (VarLastZerk and not VarLastConvoke) or (VarLastConvoke and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\153\137\119\229\80\197\33\142\142\124\192\79\199\54\179\146\106", "\68\218\230\25\147\63\174")]:CooldownRemains() < 10) and (not Player:HasTier(31, 3 - 1) or (Player:HasTier(67 - (13 + 23), 3 - 1) and Player:BuffUp(S.SmolderingFrenzyBuff))))) and (((Target:TimeToDie() < FightRemains) and (Target:TimeToDie() > 18)) or (Target:TimeToDie() == FightRemains))) then
							if (Press(S.Berserk, not IsInMeleeRange) or (3759 < 1073)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\175\47\65\95\179\191\33\19\79\185\162\38\87\67\161\163\106\2\28", "\214\205\74\51\44");
							end
						end
						FlatIdent_161BA = 1;
					end
					if ((3858 >= 1776) and (FlatIdent_161BA == (1 - 0))) then
						local FlatIdent_95066 = 0;
						local FlatIdent_93951;
						while true do
							if ((3370 >= 3257) and (FlatIdent_95066 == 0)) then
								FlatIdent_93951 = 0;
								while true do
									if ((2429 > 1167) and ((FlatIdent_93951 == 0) or (2817 < 513))) then
										if ((3932 > 957) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\216\73\240\239\114\232\71", "\23\154\44\130\156")]:IsReady() and ((FightRemains < 23) or ((((obf_AND(EL.CombatTime(), 118) + obf_OR(EL.CombatTime(), 118)) % 120) < 30) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\55\180\172\160\34\26\18\139\162\163\51\29\5\179\160", "\115\113\198\205\206\86")]:IsAvailable() and (I[LUAOBFUSACTOR_DECRYPT_STR_0("\179\94\234\82\129\69\252\91\150\92\237\120\150\86\240\89\140", "\58\228\55\158")]:IsEquipped() or I[LUAOBFUSACTOR_DECRYPT_STR_0("\149\154\216\43\47\162\51\160\129\213\11\49\175\48\166\154\223\59\48", "\85\212\233\176\78\92\205")]:IsEquipped()) and (EnemiesCount11y == 1)))) or (732 >= 2550))) then
											if Press(S.Berserk, not IsInMeleeRange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\72\93\154\241\79\74\131\162\73\87\135\238\78\87\159\236\10\9\218", "\130\42\56\232");
											end
										end
										if ((644 == 644) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\200\176\54\240\69\45\225\188\42\228", "\95\138\213\68\131\32")]:IsCastable() and CDs and (not VarAlign3Mins or Player:BuffUp(BsInc))) then
											if ((4771 == 4771) and Press(S.Berserking, not IsInMeleeRange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\40\45\179\80\115\56\35\168\77\113\106\43\174\76\122\46\39\182\77\54\123\122", "\22\74\72\193\35");
											end
										end
										FlatIdent_93951 = 1;
									end
									if ((3089 > 164) and (FlatIdent_93951 == 1)) then
										if ((1455 <= 3954) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\15\118\234\78\35\114\225\108\36\124\215\72\37\107\237\76\63", "\56\76\25\132")]:IsReady() and CDs) then
											if ((1164 > 1095) and (150 == 150) and Press(S.ConvokeTheSpirits, not IsInMeleeRange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\93\206\165\48\192\85\196\148\50\199\91\254\184\54\198\76\200\191\53\143\93\206\164\42\203\81\214\165\102\158\8", "\175\62\161\203\70");
											end
										end
										if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\31\210\205\5\58\55\216\247\27\48\15\205\202\1\60\40\206", "\85\92\189\163\115")]:IsReady() and CDs and Player:BuffUp(S.SmolderingFrenzyBuff) and (Player:BuffRemains(S.SmolderingFrenzyBuff) < (5.1 - num(S[LUAOBFUSACTOR_DECRYPT_STR_0("\8\191\56\57\36\173\62\61\58\139\37\49\45\173\62\59\44", "\88\73\204\80")]:IsAvailable())))) or (511 == 4655)) then
											if ((3479 >= 2378) and (3193 <= 3790) and Press(S.ConvokeTheSpirits, not IsInMeleeRange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\45\140\30\80\38\209\43\188\4\78\44\229\61\147\25\84\32\206\61\195\19\73\38\214\42\140\7\72\105\136\120", "\186\78\227\112\38\73");
											end
										end
										FlatIdent_93951 = 3 - 1;
									end
									if ((FlatIdent_93951 == 2) or (463 == 3491)) then
										FlatIdent_161BA = 2;
										break;
									end
								end
								break;
							end
						end
					end
					if (FlatIdent_161BA == (1090 - (830 + 258))) then
						local FlatIdent_AEAF = 0;
						while true do
							if ((2549 >= 2060) and (FlatIdent_AEAF == (0 - 0))) then
								ShouldReturn = Everyone.HandleTopTrinket(OnUseExcludes, CDs and (Player:BuffUp(S.HeartOfTheWild) or Player:BuffUp(S.Incarnation) or Player:BloodlustUp()), 40, nil);
								if ((2069 <= 4346) and ShouldReturn) then
									return ShouldReturn;
								end
								FlatIdent_AEAF = 1;
							end
							if ((FlatIdent_AEAF == 2) or (124 > 191)) then
								FlatIdent_161BA = 2 + 1;
								break;
							end
							if ((1 == FlatIdent_AEAF) or (663 > 2245)) then
								ShouldReturn = Everyone.HandleBottomTrinket(OnUseExcludes, CDs and (Player:BuffUp(S.HeartOfTheWild) or Player:BuffUp(S.Incarnation) or Player:BloodlustUp()), 40, nil);
								if (((3991 >= 3174) and ShouldReturn) or (1608 == 1524)) then
									return ShouldReturn;
								end
								FlatIdent_AEAF = 2;
							end
						end
					end
				end
				break;
			end
			if ((581 <= 2774) and (FlatIdent_978B7 == (0 + 0))) then
				FlatIdent_161BA = 0;
				HighTTD = nil;
				FlatIdent_978B7 = 1;
			end
		end
	end
	local function FetchSettings()
		local FlatIdent_4D091 = 0;
		local FlatIdent_7AD4E;
		while true do
			if (FlatIdent_4D091 == 0) then
				FlatIdent_7AD4E = 0;
				while true do
					if (FlatIdent_7AD4E == 5) then
						RegrowthHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\252\18\171\86\113\254\105", "\26\48\153\102\223\63\31\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\48\69\234\225\13\87\249\251\42\112", "\147\98\32\141")] or 0;
						break;
					end
					if (FlatIdent_7AD4E == 0) then
						UseRacials = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\184\67\36\198\58\226\174", "\84\133\221\55\80\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\244\33\148\198\95\180\230\40\181", "\60\221\135\68\198\167")];
						UseHealingPotion = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\184\236\151\75\215\233\174", "\185\142\221\152\227\34")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\214\82\210\70\50\251\81\203\80\202\76\39\254\87\203", "\151\56\165\55\154\35\83")] or 0;
						HealingPotionName = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\147\70\17\250\169\77\2\253", "\142\192\35\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\112\40\175\238\130\171\38\217\97\32\172\233\162\173\27\211", "\118\182\21\73\195\135\236\204")] or "";
						HealingPotionHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\57\14\84\13\3\250\27", "\157\104\92\122\32\100\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\163\206\198\52\41\138\155\172\178\198\197\51\15\189", "\203\195\198\175\170\93\71\237")] or 0;
						UseMarkOfTheWild = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\78\42\193\88\31\251\61", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\71\251\193\142\10\81\114\93\238\240\171\14\116\112\126\236", "\25\18\136\164\195\107\35")];
						DispelDebuffs = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\189\91\123\178\198\171", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\229\56\202\13\208\166\40\238\62\220\14\207", "\226\77\140\75\186\104\188")];
						FlatIdent_7AD4E = 1;
					end
					if ((3575 > 1313) and ((2 == FlatIdent_7AD4E) or (3284 <= 1801))) then
						local FlatIdent_6D931 = 0;
						while true do
							if ((4581 >= 1179) and (4219 <= 4301) and (FlatIdent_6D931 == 3)) then
								FlatIdent_7AD4E = 3;
								break;
							end
							if ((FlatIdent_6D931 == 0) or (3760 < 241)) then
								InterruptOnlyWhitelist = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\185\38\96\143\59\124\152", "\235\26\220\82\20\230\85\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\161\175\253\199\102\154\180\249\214\91\134\173\240\245\124\129\181\236\206\125\155\181", "\20\232\193\137\162")];
								InterruptThreshold = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\218\209\178\238\130\16\98", "\17\66\191\165\198\135\236\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\38\161\186\22\237\250\249\193\27\155\166\1\250\251\228\222\3\171", "\177\111\207\206\115\159\136\140")] or (1441 - (860 + 581));
								FlatIdent_6D931 = 1;
							end
							if ((FlatIdent_6D931 == 1) or (1590 <= 1014) or (4804 == 790)) then
								UseCatFormOOC = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\140\4\0\221\65\88\22", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\40\232\49\249\34\229\52\255\31\215\25\224", "\86\163\91\141\114\152")];
								UsageProwlOOC = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\14\96\103\51\93\12\103", "\90\51\107\20\19")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\227\132\232\56\189\226\138\248\49\162\223\166", "\93\237\144\229\143")] or "";
								FlatIdent_6D931 = 7 - 5;
							end
							if ((FlatIdent_6D931 == (2 + 0)) or (283 >= 2410)) then
								ProwlRange = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\38\243\228\13\2\72\18\229", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\169\225\45\33\137\239\52\42\190", "\90\77\219\142")] or 0;
								UseWildCharge = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\1\53\45\69\9\125\245", "\26\134\100\65\89\44\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\240\53\20\173\253\231\19\43\165\227\228\53", "\196\145\131\80\67")];
								FlatIdent_6D931 = 244 - (237 + 4);
							end
						end
					end
					if ((FlatIdent_7AD4E == 3) or (1029 >= 2232)) then
						UseBarkskin = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\181\18\28\17\230\25\163", "\136\126\208\102\104\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\153\203\97\174\64\54\66\115\131\192", "\49\24\234\174\35\207\50\93")];
						BarkskinHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\247\233\156\120\2\245\238", "\17\108\146\157\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\105\194\6\230\60\163\66\205\60\221", "\200\43\163\116\141\79")] or (0 - 0);
						UseNaturesVigil = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\140\51\41\151\185\250\228\172", "\131\223\86\93\227\208\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\86\179\152\28\161\246\87\179\165\43\188\228\76\186", "\213\131\37\214\214\125")];
						NaturesVigilHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\21\46\49\171\232\40\44\54", "\129\70\75\69\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\104\202\231\252\110\234\85\253\250\238\117\227\110\251", "\143\38\171\147\137\28")] or (0 - 0);
						UseRenewal = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\135\173\231\10\237\211\195", "\180\176\226\217\147\99\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\170\42\53\214\183\42\16\210\181", "\103\179\217\79")];
						RenewalHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\178\8\193\72\130\164\89", "\195\42\215\124\181\33\236")][LUAOBFUSACTOR_DECRYPT_STR_0("\63\92\57\59\50\249\1\113\7", "\152\109\57\87\94\69")] or 0;
						FlatIdent_7AD4E = 7 - 3;
					end
					if (FlatIdent_7AD4E == 4) then
						local FlatIdent_701DC = 0;
						while true do
							if (3 == FlatIdent_701DC) then
								FlatIdent_7AD4E = 5;
								break;
							end
							if (0 == FlatIdent_701DC) then
								FrenziedRegenerationHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\210\30\183\183\220\83\187", "\200\153\183\106\195\222\178\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\241\141\51\83\83\55\231\186\56\78\95\60\230\154\60\93\83\61\237\160\13", "\58\82\131\232\93\41")] or 0;
								UseFrenziedRegeneration = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\82\196\1\84\49\132\68", "\95\227\55\176\117\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\109\38\109\185\29\112\57\66\174\28\76\38\76\174\22\123\49\74\191\17\113\45", "\203\120\30\67\43")];
								FlatIdent_701DC = 1;
							end
							if ((FlatIdent_701DC == 1) or (1843 >= 4176)) then
								local FlatIdent_38A95 = 0;
								while true do
									if (FlatIdent_38A95 == 0) then
										SurvivalInstinctsHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\32\89\251\208\255\34\94", "\185\145\69\45\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\185\10\11\176\213\156\30\21\143\210\153\11\16\168\223\158\12\49\150", "\188\234\127\121\198")] or 0;
										UseSurvivalInstincts = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\55\7\151\49\60\20\144", "\227\88\82\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\12\191\148\23\97\85\22\172\166\14\90\77\12\174\174\12\112\87\12", "\19\35\127\218\199\98")];
										FlatIdent_38A95 = 1;
									end
									if ((FlatIdent_38A95 == (1 + 0)) or (685 > 4725)) then
										FlatIdent_701DC = 2;
										break;
									end
								end
							end
							if (FlatIdent_701DC == 2) then
								UseRegrowth = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\47\254\30\246\21\245\13\241", "\130\124\155\106")][LUAOBFUSACTOR_DECRYPT_STR_0("\224\216\243\157\166\241\110\176\194\223\254", "\223\181\171\150\207\195\150\28")];
								UseRegrowthMouseover = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\63\247\186\0\66\61\240", "\105\44\90\131\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\243\183\139\13\57\237\239\165\173\0\19\240\245\161\188\7\40\250\242", "\94\159\128\210\217\104")];
								FlatIdent_701DC = 3;
							end
						end
					end
					if ((3162 == 3162) and (1 == FlatIdent_7AD4E)) then
						local FlatIdent_953ED = 0;
						while true do
							if (FlatIdent_953ED == (0 + 0)) then
								DispelBuffs = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\203\196\43\70\183\201\195", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\212\101\18\183\88\90\51\190\219\101", "\70\216\189\22\98\210\52\24")];
								UseHealthstone = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\218\183\147\218\212\216\176", "\179\186\191\195\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\44\29\204\252\62\20\240\241\44\12\235\247\58", "\132\153\95\120")];
								FlatIdent_953ED = 1;
							end
							if (FlatIdent_953ED == 3) then
								FlatIdent_7AD4E = 2;
								break;
							end
							if ((2530 >= 1955) and ((FlatIdent_953ED == 1) or (4195 == 3247))) then
								local FlatIdent_16D8E = 0 - 0;
								while true do
									if ((1932 == 1932) and ((FlatIdent_16D8E == 1) or (3761 < 2103))) then
										FlatIdent_953ED = 2;
										break;
									end
									if (FlatIdent_16D8E == 0) then
										HealthstoneHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\183\26\57\254\212\167\162", "\192\209\210\110\77\151\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\6\35\229\235\204\243\23\45\231\250\236\208", "\164\128\99\66\137\159")] or 0;
										HandleAfflicted = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\51\140\253\170\9\135\238\173", "\222\96\233\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\178\169\27\132\246\209\191\181\171\22\139\231\245\189", "\144\217\211\199\127\232\147")];
										FlatIdent_16D8E = 1;
									end
								end
							end
							if ((889 <= 2417) and (FlatIdent_953ED == 2)) then
								local FlatIdent_5D967 = 0 + 0;
								while true do
									if ((FlatIdent_5D967 == (0 + 0)) or (1496 > 2249)) then
										HandleIncorporeal = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\42\42\60\220\75\5\87", "\36\152\79\94\72\181\37\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\217\73\59\219\221\110\49\212\215\85\47\216\202\66\62\219", "\95\183\184\39")];
										InterruptWithStun = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\58\243\50\93\142\5\166", "\98\213\95\135\70\52\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\215\173\221\114\70\236\182\217\99\99\247\183\193\68\64\235\173", "\52\158\195\169\23")];
										FlatIdent_5D967 = 1427 - (85 + 1341);
									end
									if (FlatIdent_5D967 == 1) then
										FlatIdent_953ED = 3;
										break;
									end
								end
							end
						end
					end
				end
				break;
			end
		end
	end
	local function APL()
		local FlatIdent_1004C = 0;
		local FlatIdent_7B827;
		local FlatIdent_36517;
		local AIRange;
		while true do
			if (FlatIdent_1004C == 0) then
				FlatIdent_7B827 = 0;
				FlatIdent_36517 = nil;
				FlatIdent_1004C = 1 - 0;
			end
			if ((FlatIdent_1004C == 1) or (4212 <= 98) or (2981 <= 333)) then
				AIRange = nil;
				while true do
					if ((364 <= 4940) and (654 < 2945) and (FlatIdent_7B827 == 0)) then
						local FlatIdent_3861C = 0;
						while true do
							if (FlatIdent_3861C == 1) then
								FlatIdent_7B827 = 1;
								break;
							end
							if ((2265 > 522) and (0 == FlatIdent_3861C)) then
								FlatIdent_36517 = 0;
								AIRange = nil;
								FlatIdent_3861C = 1;
							end
						end
					end
					if ((4152 >= 1643) and (FlatIdent_7B827 == 1)) then
						while true do
							if ((2810 >= 2165) and ((FlatIdent_36517 == 2) or (2370 == 4556))) then
								MeleeRange = obf_AND(5, AIRange) + obf_OR(5, AIRange);
								AoERange = obf_AND(8, AIRange) + obf_OR(8, AIRange);
								if ((4693 > 2870) and AOE) then
									local FlatIdent_DA9B = 0;
									local FlatIdent_DCCB;
									while true do
										if (FlatIdent_DA9B == 0) then
											FlatIdent_DCCB = 0;
											while true do
												if ((357 <= 3812) and (FlatIdent_DCCB == 0)) then
													local FlatIdent_5FE29 = 0;
													while true do
														if ((1186 == 1186) and (FlatIdent_5FE29 == 0)) then
															local FlatIdent_796F = 0 - 0;
															while true do
																if ((2486 <= 3406) and (FlatIdent_796F == 1)) then
																	FlatIdent_5FE29 = 373 - (45 + 327);
																	break;
																end
																if ((FlatIdent_796F == 0) or (514 >= 2311) or (586 == 611)) then
																	EnemiesMelee = Player:GetEnemiesInMeleeRange(MeleeRange);
																	Enemies11y = Player:GetEnemiesInMeleeRange(AoERange);
																	FlatIdent_796F = 1;
																end
															end
														end
														if ((2594 > 1455) and (FlatIdent_5FE29 == 1)) then
															FlatIdent_DCCB = 1;
															break;
														end
													end
												end
												if (FlatIdent_DCCB == 1) then
													EnemiesCountMelee = #EnemiesMelee;
													EnemiesCount11y = #Enemies11y;
													break;
												end
											end
											break;
										end
									end
								else
									local FlatIdent_56606 = 0;
									local FlatIdent_82125;
									while true do
										if ((FlatIdent_56606 == 0) or (4778 < 99)) then
											FlatIdent_82125 = 0;
											while true do
												if ((4545 > 4248) and (FlatIdent_82125 == (0 - 0))) then
													EnemiesMelee = {};
													Enemies11y = {};
													FlatIdent_82125 = 1;
												end
												if ((FlatIdent_82125 == (503 - (444 + 58))) or (2025 >= 4681)) then
													EnemiesCountMelee = 1 + 0;
													EnemiesCount11y = 1;
													break;
												end
											end
											break;
										end
									end
								end
								ComboPoints = Player:ComboPoints();
								FlatIdent_36517 = 3;
							end
							if (FlatIdent_36517 == (1 + 0)) then
								DispelToggle = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\190\234\224\123\235\84", "\39\202\209\141\135\23\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\58\26\26\55\244", "\152\159\83\105\106\82")];
								if ((1561 < 2644) and (1691 == 1691) and Player:IsDeadOrGhost()) then
									return;
								end
								if (Player:BuffUp(S.TravelForm) or Player:IsMounted() or (763 > 4143)) then
									return;
								end
								AIRange = mathfloor(1.5 * S[LUAOBFUSACTOR_DECRYPT_STR_0("\160\213\69\224\200\80\168\200\87\254\220\89\143\197\84", "\60\225\166\49\146\169")]:TalentRank());
								FlatIdent_36517 = 2;
							end
							if ((44 <= 3142) and (1223 == 1223) and (FlatIdent_36517 == (2 + 2))) then
								local FlatIdent_838BA = 0;
								local FlatIdent_A82A;
								while true do
									if ((FlatIdent_838BA == 0) or (2957 < 2517) or (1817 >= 4076)) then
										FlatIdent_A82A = 0;
										while true do
											if ((4522 >= 234) and (FlatIdent_A82A == 0)) then
												local FlatIdent_7EF1A = 0;
												while true do
													if ((4624 > 1588) and (687 < 4117) and (0 == FlatIdent_7EF1A)) then
														if ((292 == 292) and Mouseover and Mouseover:Exists() and Mouseover:IsAPlayer() and Mouseover:IsDeadOrGhost() and not Player:CanAttack(Mouseover)) then
															if (Player:AffectingCombat() or (1101 >= 2067)) then
																if (((1826 == 1826) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\29\27\45\35\19\19\39", "\103\79\126\79\74\97")]:IsReady()) or (122 >= 2949)) then
																	if ((3995 == 3995) and Press(M.RebirthMouseover, nil, true)) then
																		return LUAOBFUSACTOR_DECRYPT_STR_0("\168\122\209\122\76\14\178", "\122\218\31\179\19\62");
																	end
																end
															elseif Press(M.ReviveMouseover, nil, true) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\161\211\219\200\223\164", "\37\211\182\173\161\169\193");
															end
														end
														if HandleAfflicted then
															local FlatIdent_63758 = 0 - 0;
															while true do
																if ((0 == FlatIdent_63758) or (2388 <= 1882)) then
																	ShouldReturn = Everyone.HandleAfflicted(S.RemoveCorruption, M.RemoveCorruptionMouseover, 40);
																	if ((4270 > 1575) and ShouldReturn) then
																		return ShouldReturn;
																	end
																	break;
																end
															end
														end
														FlatIdent_7EF1A = 1;
													end
													if (FlatIdent_7EF1A == 1) then
														FlatIdent_A82A = 1;
														break;
													end
												end
											end
											if (((2014 >= 125) and (FlatIdent_A82A == 2)) or (3507 < 2485)) then
												FlatIdent_36517 = 5;
												break;
											end
											if (((4173 >= 1869) and (FlatIdent_A82A == 1)) or (933 >= 3101)) then
												local FlatIdent_8173E = 1732 - (64 + 1668);
												while true do
													if (FlatIdent_8173E == (1974 - (1227 + 746))) then
														FlatIdent_A82A = 2;
														break;
													end
													if ((1977 <= 3119) and (FlatIdent_8173E == 0)) then
														if ((2321 < 3422) and HandleIncorporeal) then
															local FlatIdent_1F906 = 0 - 0;
															local FlatIdent_1AA4F;
															local FlatIdent_744F3;
															while true do
																if ((FlatIdent_1F906 == 1) or (381 >= 3836)) then
																	while true do
																		if (((0 - 0) == FlatIdent_1AA4F) or (3312 <= 3209)) then
																			FlatIdent_744F3 = 0;
																			while true do
																				if (FlatIdent_744F3 == 0) then
																					ShouldReturn = Everyone.HandleIncorporeal(S.Hibernate, M.HibernateMouseover, 30, true);
																					if ((1170 >= 32) and ShouldReturn) then
																						return ShouldReturn;
																					end
																					break;
																				end
																			end
																			break;
																		end
																	end
																	break;
																end
																if (FlatIdent_1F906 == 0) then
																	FlatIdent_1AA4F = 0;
																	FlatIdent_744F3 = nil;
																	FlatIdent_1F906 = 1;
																end
															end
														end
														if (not Player:AffectingCombat() and OOC) then
															local FlatIdent_16248 = 0;
															local FlatIdent_55754;
															local FlatIdent_67869;
															while true do
																if ((3757 <= 4903) and ((495 - (415 + 79)) == FlatIdent_16248)) then
																	while true do
																		if (FlatIdent_55754 == (0 + 0)) then
																			FlatIdent_67869 = 491 - (142 + 349);
																			while true do
																				if (FlatIdent_67869 == 0) then
																					if ((UseMarkOfTheWild and S[LUAOBFUSACTOR_DECRYPT_STR_0("\218\59\95\210\7\125\141\255\63\122\208\36\127", "\217\151\90\45\185\72\27")]:IsCastable() and (Player:BuffDown(S.MarkOfTheWild, true) or Everyone.GroupBuffMissing(S.MarkOfTheWild))) or (3368 <= 752)) then
																						if ((872 < 4220) and (3866 == 3866) and Press(M.MarkOfTheWildPlayer)) then
																							return LUAOBFUSACTOR_DECRYPT_STR_0("\206\125\245\25\105\204\122\216\6\94\198\67\240\27\90\199", "\54\163\28\135\114");
																						end
																					end
																					if S[LUAOBFUSACTOR_DECRYPT_STR_0("\11\218\73\164\65\109\37", "\31\72\187\61\226\46")]:IsCastable() then
																						if (Press(S.CatForm) or (1446 == 3817)) then
																							return LUAOBFUSACTOR_DECRYPT_STR_0("\192\7\87\237\65\113\54\206\70\76\221\68", "\68\163\102\35\178\39\30");
																						end
																					end
																					break;
																				end
																			end
																			break;
																		end
																	end
																	break;
																end
																if ((FlatIdent_16248 == 0) or (2373 >= 4428)) then
																	FlatIdent_55754 = 0;
																	FlatIdent_67869 = nil;
																	FlatIdent_16248 = 1;
																end
															end
														end
														FlatIdent_8173E = 1 + 0;
													end
												end
											end
										end
										break;
									end
								end
							end
							if (FlatIdent_36517 == 5) then
								if ((1365 <= 4238) and Everyone.TargetIsValid() and Target:IsInRange(11)) then
									local FlatIdent_572E4 = 0;
									local FlatIdent_74D28;
									while true do
										if ((508 < 4636) and ((0 - 0) == FlatIdent_572E4)) then
											FlatIdent_74D28 = 0;
											while true do
												if ((1324 == 1324) and (1 == FlatIdent_74D28)) then
													if (Press(S.Pool) or (268 == 3559)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\111\39\161\8\22\122\38\171\22\81\70", "\54\63\72\206\100");
													end
													break;
												end
												if ((FlatIdent_74D28 == 0) or (2668 < 2021)) then
													local FlatIdent_2655D = 0;
													while true do
														if ((1647 <= 3116) and (417 < 4185) and (FlatIdent_2655D == 0)) then
															if (((451 <= 2352) and not Player:AffectingCombat() and OOC) or (4709 == 4502)) then
																local FlatIdent_203DC = 0;
																local FlatIdent_21E6D;
																local FlatIdent_3CD26;
																local ShouldReturn;
																while true do
																	if (((1357 < 2767) and (FlatIdent_203DC == 0)) or (1950 >= 3843)) then
																		FlatIdent_21E6D = 0;
																		FlatIdent_3CD26 = nil;
																		FlatIdent_203DC = 1 + 0;
																	end
																	if ((FlatIdent_203DC == 1) or (2417 > 3687)) then
																		ShouldReturn = nil;
																		while true do
																			if ((1460 < 3378) and (FlatIdent_21E6D == 0)) then
																				local FlatIdent_5BD80 = 0;
																				while true do
																					if ((2401 >= 1851) and (FlatIdent_5BD80 == 0)) then
																						FlatIdent_3CD26 = 0;
																						ShouldReturn = nil;
																						FlatIdent_5BD80 = 1;
																					end
																					if ((FlatIdent_5BD80 == 1) or (1753 > 3514)) then
																						FlatIdent_21E6D = 1;
																						break;
																					end
																				end
																			end
																			if ((FlatIdent_21E6D == 1) or (1862 >= 3732)) then
																				while true do
																					if (0 == FlatIdent_3CD26) then
																						ShouldReturn = Precombat();
																						if (ShouldReturn or (3452 > 3516)) then
																							return ShouldReturn;
																						end
																						break;
																					end
																				end
																				break;
																			end
																		end
																		break;
																	end
																end
															end
															if (Player:AffectingCombat() or OOC) then
																local FlatIdent_4D69 = 0;
																while true do
																	if ((4473 > 1694) and ((FlatIdent_4D69 == 2) or (3881 < 1890))) then
																		local FlatIdent_3CC61 = 0;
																		while true do
																			if ((0 == FlatIdent_3CC61) or (2272 >= 3660) or (1091 > 2982)) then
																				if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\212\254\129\166", "\177\134\159\234\195")]:IsReady() and (Player:StealthUp(false, true))) or (3054 <= 1922)) then
																					if (Everyone.CastCycle(S.Rake, EnemiesMelee, EvaluateCycleRakeMain, not IsInMeleeRange, nil, nil, M.RakeMouseover) or (2101 == 1780)) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\175\234\52\165\137\176\234\54\174\137\236\187", "\169\221\139\95\192");
																					end
																				end
																				if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\255\143\126\47\54\47\200\142\76\40\35\52\211", "\70\190\235\31\95\66")]:IsReady() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\143\236\24\244\236\190\238\31\226\214\173\227\8\235", "\133\218\130\122\134")]:IsAvailable() and (EnemiesCount11y <= 1) and (Player:BuffStack(S.AdaptiveSwarmHeal) < 4) and (Player:BuffRemains(S.AdaptiveSwarmHeal) > 4)) or (4189 < 2526)) then
																					if Press(M.AdaptiveSwarmPlayer) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\61\251\226\212\200\170\46\57\192\240\211\221\177\53\124\236\230\200\218\227\53\61\246\237\132\141\247", "\88\92\159\131\164\188\195");
																					end
																				end
																				FlatIdent_3CC61 = 1;
																			end
																			if ((FlatIdent_3CC61 == 1) or (1251 > 1489) or (4377 <= 1948)) then
																				if ((928 <= 4223) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\161\42\190\91\195\226\203\133\29\168\74\197\230", "\189\224\78\223\43\183\139")]:IsReady() and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\27\242\136\4\200\42\240\143\18\242\57\253\152\27", "\161\78\156\234\118")]:IsAvailable() or (EnemiesCount11y == (1 + 0)))) or (670 == 1771))) then
																					if ((1328 <= 1816) and (1459 >= 329) and Everyone.CastCycle(S.AdaptiveSwarm, Enemies11y, EvaluateCycleAdaptiveSwarm, not Target:IsSpellInRange(S.AdaptiveSwarm), nil, nil, M.AdaptiveSwarmMouseover)) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\166\179\200\204\179\190\223\217\152\164\222\221\181\186\137\209\166\190\199\156\246\229", "\188\199\215\169");
																					end
																				end
																				if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\221\13\94\107\252\245\31\90\72\255\253\27\82", "\136\156\105\63\27")]:IsReady() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\46\130\123\38\18\136\117\49\31\191\110\53\9\129", "\84\123\236\25")]:IsAvailable() and (EnemiesCount11y > 1)) then
																					if ((2910 > 1112) and Everyone.CastTargetIf(S.AdaptiveSwarm, Enemies11y, LUAOBFUSACTOR_DECRYPT_STR_0("\253\138\178", "\213\144\235\202\119\204"), EvaluateTargetIfFilterAdaptiveSwarm, EvaluateTargetIfAdaptiveSwarm, not Target:IsSpellInRange(S.AdaptiveSwarm))) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\34\28\223\58\60\42\91\38\39\205\61\41\49\64\99\21\223\35\38\99\28\112", "\45\67\120\190\74\72\67");
																					end
																				end
																				FlatIdent_3CC61 = 2;
																			end
																			if (FlatIdent_3CC61 == 2) then
																				FlatIdent_4D69 = 7 - 4;
																				break;
																			end
																		end
																	end
																	if ((FlatIdent_4D69 == 5) or (1306 >= 2276)) then
																		if ((EnemiesCount11y > 1) and (ComboPoints < 4)) then
																			local FlatIdent_23B1E = 0;
																			local FlatIdent_769D9;
																			local ShouldReturn;
																			while true do
																				if ((579 < 4604) and (FlatIdent_23B1E == (1864 - (1710 + 154)))) then
																					local FlatIdent_32B7F = 0;
																					while true do
																						if ((2046 <= 4218) and (FlatIdent_32B7F == 1)) then
																							FlatIdent_23B1E = 1;
																							break;
																						end
																						if ((2488 > 810) and (0 == FlatIdent_32B7F)) then
																							FlatIdent_769D9 = 0;
																							ShouldReturn = nil;
																							FlatIdent_32B7F = 1;
																						end
																					end
																				end
																				if ((4727 > 1153) and (FlatIdent_23B1E == 1)) then
																					while true do
																						if ((3344 == 3344) and (4794 >= 3564) and (FlatIdent_769D9 == 0)) then
																							ShouldReturn = AoeBuilder();
																							if (ShouldReturn or (261 <= 137) or (3894 > 4440)) then
																								return ShouldReturn;
																							end
																							break;
																						end
																					end
																					break;
																				end
																			end
																		end
																		if ((Player:BuffDown(BsInc) and (EnemiesCount11y == 1) and (ComboPoints < 4)) or (2141 >= 4882)) then
																			local FlatIdent_86D54 = 0;
																			local FlatIdent_796BD;
																			local ShouldReturn;
																			while true do
																				if ((FlatIdent_86D54 == 0) or (653 >= 1699)) then
																					FlatIdent_796BD = 318 - (200 + 118);
																					ShouldReturn = nil;
																					FlatIdent_86D54 = 1;
																				end
																				if ((2518 <= 3050) and (1 == FlatIdent_86D54)) then
																					while true do
																						if ((4807 > 177) and (0 == FlatIdent_796BD)) then
																							ShouldReturn = Builder();
																							if (((3663 >= 863) and ShouldReturn) or (4349 >= 4788)) then
																								return ShouldReturn;
																							end
																							break;
																						end
																					end
																					break;
																				end
																			end
																		end
																		break;
																	end
																	if (FlatIdent_4D69 == 3) then
																		local FlatIdent_5E9B9 = 0;
																		while true do
																			if ((2411 > 1017) and (4018 <= 4690) and (FlatIdent_5E9B9 == 0)) then
																				if (CDs and ((EL.CombatTime() > 3) or not S[LUAOBFUSACTOR_DECRYPT_STR_0("\4\43\255\160\223\129\246\232\52\43\226\171", "\137\64\66\141\197\153\232\142")]:IsAvailable() or (Target:DebuffUp(S.DireFixationDebuff) and (ComboPoints < 4)) or (EnemiesCount11y > 1)) and not ((EnemiesCount11y == 1) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\32\223\44\176\135\8\213\22\174\141\48\192\43\180\129\23\195", "\232\99\176\66\198")]:IsAvailable())) then
																					local FlatIdent_96BA6 = 0;
																					local FlatIdent_9257B;
																					local ShouldReturn;
																					while true do
																						if (FlatIdent_96BA6 == 0) then
																							FlatIdent_9257B = 0;
																							ShouldReturn = nil;
																							FlatIdent_96BA6 = 1;
																						end
																						if (FlatIdent_96BA6 == 1) then
																							while true do
																								if ((FlatIdent_9257B == 0) or (392 > 2140)) then
																									ShouldReturn = Cooldown();
																									if (ShouldReturn or (652 > 1802)) then
																										return ShouldReturn;
																									end
																									break;
																								end
																							end
																							break;
																						end
																					end
																				end
																				if ((CDs and Target:DebuffUp(S.Rip)) or (4531 <= 3105) or (3601 < 1710)) then
																					local FlatIdent_BDC2 = 0;
																					local FlatIdent_457DB;
																					local ShouldReturn;
																					while true do
																						if (((3863 == 3863) and (FlatIdent_BDC2 == 0)) or (2033 <= 813)) then
																							FlatIdent_457DB = 0 + 0;
																							ShouldReturn = nil;
																							FlatIdent_BDC2 = 1 - 0;
																						end
																						if ((FlatIdent_BDC2 == 1) or (721 >= 1517)) then
																							while true do
																								if ((3203 > 2189) and (FlatIdent_457DB == 0)) then
																									ShouldReturn = Cooldown();
																									if ((4719 >= 2813) and ShouldReturn) then
																										return ShouldReturn;
																									end
																									break;
																								end
																							end
																							break;
																						end
																					end
																				end
																				FlatIdent_5E9B9 = 1;
																			end
																			if ((3544 == 3544) and (989 < 4245) and (FlatIdent_5E9B9 == 2)) then
																				FlatIdent_4D69 = 4;
																				break;
																			end
																			if ((15 <= 390) and (FlatIdent_5E9B9 == (1 - 0))) then
																				if (((2545 >= 1717) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\202\36\58\7\119\171\235\41\226\59\49", "\76\140\65\72\102\27\237\153")]:IsReady()) or (2666 >= 4978)) then
																					if (Everyone.CastTargetIf(S.FeralFrenzy, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\71\219\14", "\222\42\186\118\178\183\97"), EvaluateTargetIfFilterTTD, EvaluateTargetIfFeralFrenzy, not IsInMeleeRange) or (4635 == 118)) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\91\233\86\139\81\211\66\152\88\226\94\147\29\225\69\131\83\172\22\218", "\234\61\140\36");
																					end
																				end
																				if ((1226 < 3232) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\7\216\168\115\3\7\207\191\124\21\56", "\111\65\189\218\18")]:IsReady() and (ComboPoints < 3) and Target:DebuffUp(S.DireFixationDebuff) and Target:DebuffUp(S.Rip) and (EnemiesCount11y == 1) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\96\68\21\35\4\87\170\119\67\30\6\27\85\189\74\95\8", "\207\35\43\123\85\107\60")]:IsAvailable()) then
																					if (((3767 > 706) and Press(S.FeralFrenzy, not IsInMeleeRange)) or (262 > 1628)) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\118\175\178\235\117\79\172\178\239\119\106\179\224\231\120\121\164\224\184\40", "\25\16\202\192\138");
																					end
																				end
																				FlatIdent_5E9B9 = 2;
																			end
																		end
																	end
																	if ((3292 >= 1475) and (FlatIdent_4D69 == 4)) then
																		local FlatIdent_47B53 = 0;
																		local FlatIdent_7E663;
																		while true do
																			if (FlatIdent_47B53 == 0) then
																				FlatIdent_7E663 = 0;
																				while true do
																					if ((4108 == 4108) and (FlatIdent_7E663 == 2)) then
																						FlatIdent_4D69 = 5;
																						break;
																					end
																					if ((4654 == 4654) and ((FlatIdent_7E663 == 1) or (4773 < 1343))) then
																						local FlatIdent_6E880 = 0;
																						while true do
																							if ((4278 >= 989) and (FlatIdent_6E880 == (1 + 0))) then
																								FlatIdent_7E663 = 2;
																								break;
																							end
																							if ((FlatIdent_6E880 == 0) or (1751 < 1528) or (2563 == 4349)) then
																								if (((ComboPoints == 4) and Player:BuffUp(S.PredatorRevealedBuff) and (Player:EnergyDeficit() > 40) and (EnemiesCount11y == (1 + 0))) or (2522 == 4177)) then
																									if Press(S.Pool) then
																										return LUAOBFUSACTOR_DECRYPT_STR_0("\41\192\169\240\253\116\17\211\224\194\180\124\23\210\168\225\175\58\87", "\18\126\161\192\132\221");
																									end
																								end
																								if ((941 < 4267) and (ComboPoints >= 4)) then
																									local FlatIdent_86A1A = 0;
																									local FlatIdent_450D9;
																									local FlatIdent_8B965;
																									local ShouldReturn;
																									while true do
																										if ((1185 <= 3160) and (FlatIdent_86A1A == (1 + 0))) then
																											ShouldReturn = nil;
																											while true do
																												if ((1263 == 1263) and (FlatIdent_450D9 == (1 + 0))) then
																													while true do
																														if ((0 == FlatIdent_8B965) or (4092 == 464)) then
																															ShouldReturn = Finisher();
																															if ((1526 >= 1264) and ShouldReturn) then
																																return ShouldReturn;
																															end
																															break;
																														end
																													end
																													break;
																												end
																												if (FlatIdent_450D9 == 0) then
																													local FlatIdent_8B882 = 0;
																													while true do
																														if ((FlatIdent_8B882 == 0) or (2828 < 2068)) then
																															FlatIdent_8B965 = 0;
																															ShouldReturn = nil;
																															FlatIdent_8B882 = 1;
																														end
																														if ((FlatIdent_8B882 == 1) or (3492 <= 964)) then
																															FlatIdent_450D9 = 1;
																															break;
																														end
																													end
																												end
																											end
																											break;
																										end
																										if ((FlatIdent_86A1A == 0) or (2726 == 4578) or (1051 > 4964)) then
																											FlatIdent_450D9 = 0 - 0;
																											FlatIdent_8B965 = nil;
																											FlatIdent_86A1A = 1251 - (363 + 887);
																										end
																									end
																								end
																								FlatIdent_6E880 = 1;
																							end
																						end
																					end
																					if ((FlatIdent_7E663 == (0 - 0)) or (4623 == 1784)) then
																						local FlatIdent_2DAF = 0;
																						while true do
																							if (FlatIdent_2DAF == 1) then
																								FlatIdent_7E663 = 1;
																								break;
																							end
																							if ((3042 < 4228) and (FlatIdent_2DAF == (0 - 0))) then
																								if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\219\206\191\237\170\253\242\222\190\192\160\224\248", "\148\157\171\205\130\201")]:IsReady() and Player:BuffUp(S.ApexPredatorsCravingBuff) and ((EnemiesCount11y == 1) or not S[LUAOBFUSACTOR_DECRYPT_STR_0("\19\198\125\36\208\250\20\198\117\61\217", "\150\67\180\20\73\177")]:IsAvailable() or Player:BuffDown(S.SabertoothBuff)) and not (VarNeedBT and (CountActiveBtTriggers() == 2))) or (4899 <= 2526)) then
																									if ((3549 < 4585) and (546 <= 1071) and Everyone.CastTargetIf(S.FerociousBite, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\128\25\2", "\45\237\120\122"), EvaluateTargetIfFilterTTD, nil, not IsInMeleeRange)) then
																										return LUAOBFUSACTOR_DECRYPT_STR_0("\209\237\176\35\212\225\173\57\196\215\160\37\195\237\226\33\214\225\172\108\134\190", "\76\183\136\194");
																									end
																								end
																								if ((1240 <= 2244) and Player:BuffUp(BsInc)) then
																									local FlatIdent_803A9 = 0 + 0;
																									local FlatIdent_3A381;
																									local ShouldReturn;
																									while true do
																										if ((1 == FlatIdent_803A9) or (4862 <= 3641)) then
																											while true do
																												if (1 == FlatIdent_3A381) then
																													if (((2850 > 997) and Press(S.Pool)) or (451 > 4866)) then
																														return LUAOBFUSACTOR_DECRYPT_STR_0("\77\231\236\44\16\73\27\104\166\199\61\66\92\17\104\237\173\113", "\116\26\134\133\88\48\47");
																													end
																													break;
																												end
																												if (((4180 <= 4502) and (FlatIdent_3A381 == 0)) or (1642 <= 392)) then
																													local FlatIdent_33E2D = 0;
																													while true do
																														if ((2519 == 2519) and ((FlatIdent_33E2D == 0) or (149 == 893))) then
																															ShouldReturn = Berserk();
																															if ((2932 <= 4411) and ShouldReturn) then
																																return ShouldReturn;
																															end
																															FlatIdent_33E2D = 1;
																														end
																														if ((FlatIdent_33E2D == 1) or (102 > 4278)) then
																															FlatIdent_3A381 = 1;
																															break;
																														end
																													end
																												end
																											end
																											break;
																										end
																										if (FlatIdent_803A9 == 0) then
																											FlatIdent_3A381 = 0;
																											ShouldReturn = nil;
																											FlatIdent_803A9 = 2 - 1;
																										end
																									end
																								end
																								FlatIdent_2DAF = 1 + 0;
																							end
																						end
																					end
																				end
																				break;
																			end
																		end
																	end
																	if ((0 == FlatIdent_4D69) or (1765 <= 1197)) then
																		local FlatIdent_7BF92 = 0;
																		while true do
																			if ((1037 < 1746) and (FlatIdent_7BF92 == 1)) then
																				local FlatIdent_52DF3 = 1664 - (674 + 990);
																				while true do
																					if ((3738 >= 3692) and (FlatIdent_52DF3 == 1)) then
																						FlatIdent_7BF92 = 2;
																						break;
																					end
																					if (((0 + 0) == FlatIdent_52DF3) or (3822 < 823) or (4308 <= 2584)) then
																						if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\181\215\40\246\168", "\32\229\165\71\129\196\126\223")]:IsCastable() and (Player:BuffDown(BsInc))) or (2869 < 1587)) then
																							if (Press(S.Prowl) or (254 > 4194)) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\211\155\203\150\141\149\206\136\205\143\193\135", "\181\163\233\164\225\225");
																							end
																						end
																						if ((4131 > 455) and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\115\138\42\81\95\153\51", "\23\48\235\94")]:IsCastable() or (4962 == 3146))) then
																							if Press(S.CatForm) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\127\219\204\98\81\60\192\113\154\213\92\94\61\146\40", "\178\28\186\184\61\55\83");
																							end
																						end
																						FlatIdent_52DF3 = 1 + 0;
																					end
																				end
																			end
																			if ((FlatIdent_7BF92 == (0 - 0)) or (710 >= 3594)) then
																				local FlatIdent_63E5 = 0;
																				while true do
																					if ((343 < 1457) and ((0 == FlatIdent_63E5) or (475 > 4146))) then
																						if ((not Player:IsCasting() and not Player:IsChanneling()) or (121 >= 129)) then
																							local FlatIdent_4A2BF = 0;
																							local FlatIdent_87DC7;
																							local FlatIdent_6CDAF;
																							local ShouldReturn;
																							while true do
																								if ((4058 >= 1397) and (1 == FlatIdent_4A2BF)) then
																									ShouldReturn = nil;
																									while true do
																										if ((FlatIdent_87DC7 == 0) or (2058 > 4958)) then
																											FlatIdent_6CDAF = 1055 - (507 + 548);
																											ShouldReturn = nil;
																											FlatIdent_87DC7 = 1;
																										end
																										if ((932 < 2554) and (FlatIdent_87DC7 == 1)) then
																											while true do
																												if (((1759 == 1759) and (FlatIdent_6CDAF == 1)) or (1620 > 3807)) then
																													local FlatIdent_48912 = 0;
																													while true do
																														if (FlatIdent_48912 == 1) then
																															FlatIdent_6CDAF = 839 - (289 + 548);
																															break;
																														end
																														if (FlatIdent_48912 == (1818 - (821 + 997))) then
																															ShouldReturn = Everyone.Interrupt(S.SkullBash, 10, true, Mouseover, M.SkullBashMouseover);
																															if ShouldReturn then
																																return ShouldReturn;
																															end
																															FlatIdent_48912 = 1;
																														end
																													end
																												end
																												if ((FlatIdent_6CDAF == 0) or (4543 == 358)) then
																													local FlatIdent_33061 = 255 - (195 + 60);
																													local FlatIdent_3F22;
																													while true do
																														if (((2003 == 2003) and (FlatIdent_33061 == 0)) or (313 > 911)) then
																															FlatIdent_3F22 = 0;
																															while true do
																																if ((FlatIdent_3F22 == 1) or (3 == 2368) or (3015 <= 2049)) then
																																	FlatIdent_6CDAF = 1;
																																	break;
																																end
																																if ((FlatIdent_3F22 == (0 + 0)) or (2757 > 3968)) then
																																	ShouldReturn = Everyone.Interrupt(S.SkullBash, 10, true);
																																	if ShouldReturn then
																																		return ShouldReturn;
																																	end
																																	FlatIdent_3F22 = 1;
																																end
																															end
																															break;
																														end
																													end
																												end
																												if ((FlatIdent_6CDAF == 2) or (605 == 780)) then
																													local FlatIdent_342AE = 0;
																													while true do
																														if ((1196 > 312) and (FlatIdent_342AE == 0)) then
																															ShouldReturn = Everyone.InterruptWithStun(S.MightyBash, 8);
																															if (((812 <= 1870) and ShouldReturn) or (983 == 3300)) then
																																return ShouldReturn;
																															end
																															FlatIdent_342AE = 1;
																														end
																														if ((1 == FlatIdent_342AE) or (1831 <= 547)) then
																															FlatIdent_6CDAF = 1504 - (251 + 1250);
																															break;
																														end
																													end
																												end
																												if (FlatIdent_6CDAF == (8 - 5)) then
																													local FlatIdent_453D = 0;
																													local FlatIdent_7856B;
																													while true do
																														if ((3889 == 3889) and (FlatIdent_453D == 0)) then
																															FlatIdent_7856B = 0 + 0;
																															while true do
																																if ((4973 > 1380) and (1411 < 2388) and (FlatIdent_7856B == 1)) then
																																	FlatIdent_6CDAF = 1036 - (809 + 223);
																																	break;
																																end
																																if (0 == FlatIdent_7856B) then
																																	local FlatIdent_55B1D = 0 - 0;
																																	while true do
																																		if ((1 == FlatIdent_55B1D) or (700 < 506)) then
																																			FlatIdent_7856B = 2 - 1;
																																			break;
																																		end
																																		if ((3592 == 3592) and (4771 == 4771) and (FlatIdent_55B1D == 0)) then
																																			ShouldReturn = Everyone.InterruptWithStun(S.IncapacitatingRoar, 8);
																																			if ((533 == 533) and ShouldReturn) then
																																				return ShouldReturn;
																																			end
																																			FlatIdent_55B1D = 1;
																																		end
																																	end
																																end
																															end
																															break;
																														end
																													end
																												end
																												if (FlatIdent_6CDAF == 4) then
																													if ((Player:BuffUp(S.CatForm) and (Player:ComboPoints() > 0)) or (98 >= 2345)) then
																														local FlatIdent_7B1C5 = 0;
																														local FlatIdent_1348A;
																														while true do
																															if ((0 == FlatIdent_7B1C5) or (790 <= 756)) then
																																FlatIdent_1348A = 0;
																																while true do
																																	if (FlatIdent_1348A == 0) then
																																		ShouldReturn = Everyone.InterruptWithStun(S.Maim, 8);
																																		if ((234 < 3849) and ShouldReturn) then
																																			return ShouldReturn;
																																		end
																																		break;
																																	end
																																end
																																break;
																															end
																														end
																													end
																													break;
																												end
																											end
																											break;
																										end
																									end
																									break;
																								end
																								if (0 == FlatIdent_4A2BF) then
																									FlatIdent_87DC7 = 0;
																									FlatIdent_6CDAF = nil;
																									FlatIdent_4A2BF = 1;
																								end
																							end
																						end
																						if ((3613 == 3613) and (4297 > 1243) and DispelBuffs and DispelToggle and S[LUAOBFUSACTOR_DECRYPT_STR_0("\141\127\213\211\11\176", "\113\222\16\186\167\99\213\227")]:IsReady() and not Player:IsCasting() and not Player:IsChanneling() and Everyone.UnitHasEnrageBuff(Target)) then
																							if ((167 <= 4460) and Press(S.Soothe, not IsInMeleeRange)) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\42\7\232\230\43\2", "\150\78\110\155");
																							end
																						end
																						FlatIdent_63E5 = 1;
																					end
																					if ((2794 < 3857) and (FlatIdent_63E5 == 1)) then
																						FlatIdent_7BF92 = 1;
																						break;
																					end
																				end
																			end
																			if ((FlatIdent_7BF92 == (6 - 4)) or (3812 < 3081)) then
																				FlatIdent_4D69 = 1;
																				break;
																			end
																		end
																	end
																	if ((4809 > 1993) and ((1 + 0) == FlatIdent_4D69)) then
																		local FlatIdent_3DF68 = 0;
																		local FlatIdent_73B61;
																		while true do
																			if ((FlatIdent_3DF68 == 0) or (3611 > 4881) or (4255 <= 1075)) then
																				FlatIdent_73B61 = 0;
																				while true do
																					if ((3468 == 3468) and (2187 < 3817) and (FlatIdent_73B61 == (0 + 0))) then
																						if (Player:AffectingCombat() or (4782 < 195)) then
																							local FlatIdent_54AEA = 0;
																							local FlatIdent_73CDA;
																							local FlatIdent_3BE5E;
																							while true do
																								if ((428 <= 985) and (FlatIdent_54AEA == (618 - (14 + 603)))) then
																									while true do
																										if ((765 <= 3541) and (2952 >= 1023) and (FlatIdent_73CDA == 0)) then
																											FlatIdent_3BE5E = 129 - (118 + 11);
																											while true do
																												if (FlatIdent_3BE5E == (1 + 0)) then
																													local FlatIdent_2C74 = 0;
																													local FlatIdent_92256;
																													while true do
																														if (((554 <= 3482) and (0 == FlatIdent_2C74)) or (3947 < 1151)) then
																															FlatIdent_92256 = 0;
																															while true do
																																if ((1787 <= 2297) and (74 <= 3533) and (FlatIdent_92256 == 1)) then
																																	FlatIdent_3BE5E = 2;
																																	break;
																																end
																																if (((1657 < 3319) and (FlatIdent_92256 == 0)) or (525 > 2824)) then
																																	local FlatIdent_5DECF = 0;
																																	while true do
																																		if ((1 == FlatIdent_5DECF) or (2497 <= 1948)) then
																																			FlatIdent_92256 = 1;
																																			break;
																																		end
																																		if ((3779 == 3779) and (FlatIdent_5DECF == 0)) then
																																			if ((542 == 542) and (Player:HealthPercentage() <= FrenziedRegenerationHP) and UseFrenziedRegeneration and S[LUAOBFUSACTOR_DECRYPT_STR_0("\158\170\25\50\162\177\25\56\138\189\27\57\182\189\14\61\172\177\19\50", "\92\216\216\124")]:IsReady()) then
																																				if (Press(S.FrenziedRegeneration, nil, nil, true) or (1616 == 1003) or (4176 < 3120)) then
																																					return LUAOBFUSACTOR_DECRYPT_STR_0("\125\32\169\78\231\82\55\168\114\248\92\55\162\69\239\90\38\165\79\243\27\54\169\70\248\85\33\165\86\248\27\96", "\157\59\82\204\32");
																																				end
																																			end
																																			if (((Player:HealthPercentage() <= SurvivalInstinctsHP) and UseSurvivalInstincts and S[LUAOBFUSACTOR_DECRYPT_STR_0("\11\43\241\236\224\252\210\189\17\48\240\238\224\228\208\165\43", "\209\88\94\131\154\137\138\179")]:IsReady()) or (3672 <= 863)) then
																																				if ((612 < 1082) and Press(S.SurvivalInstincts, nil, nil, true)) then
																																					return LUAOBFUSACTOR_DECRYPT_STR_0("\27\180\214\106\23\53\48\46\1\175\215\104\23\45\50\54\59\225\192\121\24\38\63\49\33\183\193\60\76", "\66\72\193\164\28\126\67\81");
																																				end
																																			end
																																			FlatIdent_5DECF = 1;
																																		end
																																	end
																																end
																															end
																															break;
																														end
																													end
																												end
																												if ((FlatIdent_3BE5E == 0) or (4670 <= 692)) then
																													local FlatIdent_BA17 = 0;
																													local FlatIdent_69D40;
																													while true do
																														if ((1534 >= 1131) and (FlatIdent_BA17 == 0)) then
																															FlatIdent_69D40 = 0;
																															while true do
																																if (FlatIdent_69D40 == 0) then
																																	if ((2142 == 2142) and (Player:HealthPercentage() <= NaturesVigilHP) and UseNaturesVigil and S[LUAOBFUSACTOR_DECRYPT_STR_0("\234\204\83\41\224\11\230\242\196\64\53\254", "\149\164\173\39\92\146\110")]:IsReady()) then
																																		if (Press(S.NaturesVigil, nil, nil, true) or (1680 < 749) or (73 == 610)) then
																																			return LUAOBFUSACTOR_DECRYPT_STR_0("\253\38\4\10\8\30\224\24\6\22\29\18\255\103\20\26\28\30\253\52\25\9\31\91\161", "\123\147\71\112\127\122");
																																		end
																																	end
																																	if (((Player:HealthPercentage() <= RenewalHP) and UseRenewal and S[LUAOBFUSACTOR_DECRYPT_STR_0("\254\200\140\116\81\205\193", "\38\172\173\226\17")]:IsReady()) or (1400 > 1854)) then
																																		if Press(S.Renewal, nil, nil, true) then
																																			return LUAOBFUSACTOR_DECRYPT_STR_0("\95\20\34\234\90\16\32\175\73\20\42\234\67\2\37\249\72\81\126", "\143\45\113\76");
																																		end
																																	end
																																	FlatIdent_69D40 = 1;
																																end
																																if (FlatIdent_69D40 == 1) then
																																	FlatIdent_3BE5E = 1 + 0;
																																	break;
																																end
																															end
																															break;
																														end
																													end
																												end
																												if ((2 == FlatIdent_3BE5E) or (2836 >= 3349)) then
																													local FlatIdent_8B61F = 0;
																													local FlatIdent_35204;
																													while true do
																														if ((FlatIdent_8B61F == 0) or (2012 < 213)) then
																															FlatIdent_35204 = 0;
																															while true do
																																if (FlatIdent_35204 == (2 - 1)) then
																																	FlatIdent_3BE5E = 3;
																																	break;
																																end
																																if ((4516 >= 2342) and (FlatIdent_35204 == 0)) then
																																	if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\213\41\175\74\41\97\243\36", "\22\135\76\200\56\70")]:IsCastable() and UseRegrowth and Player:BuffUp(S.PredatorySwiftnessBuff) and (Player:HealthPercentage() <= RegrowthHP)) then
																																		if (Press(M.RegrowthPlayer) or (4095 == 963)) then
																																			return LUAOBFUSACTOR_DECRYPT_STR_0("\159\53\255\54\82\246\153\56\184\32\88\231\136\62\235\45\75\228\205\100", "\129\237\80\152\68\61");
																																		end
																																	end
																																	if (((Player:HealthPercentage() <= BarkskinHP) and UseBarkskin and S[LUAOBFUSACTOR_DECRYPT_STR_0("\115\169\22\248\15\28\81\95", "\56\49\200\100\147\124\119")]:IsReady()) or (2402 == 3445)) then
																																		if Press(S.Barkskin, nil, nil, true) then
																																			return LUAOBFUSACTOR_DECRYPT_STR_0("\206\63\173\251\223\53\182\254\140\58\186\246\201\48\172\249\218\59\255\166", "\144\172\94\223");
																																		end
																																	end
																																	FlatIdent_35204 = 1;
																																end
																															end
																															break;
																														end
																													end
																												end
																												if ((160 <= 3550) and (3 == FlatIdent_3BE5E)) then
																													if ((149 < 3450) and I[LUAOBFUSACTOR_DECRYPT_STR_0("\12\10\163\75\48\7\177\83\43\1\167", "\39\68\111\194")]:IsReady() and UseHealthstone and (Player:HealthPercentage() <= HealthstoneHP)) then
																														if ((4849 >= 4402) and Press(M.Healthstone, nil, nil, true)) then
																															return LUAOBFUSACTOR_DECRYPT_STR_0("\222\163\230\203\109\191\197\178\232\201\124\247\210\163\225\194\119\164\223\176\226\135\42", "\215\182\198\135\167\25");
																														end
																													end
																													if (UseHealingPotion and (Player:HealthPercentage() <= HealingPotionHP)) then
																														if (HealingPotionName ~= LUAOBFUSACTOR_DECRYPT_STR_0("\191\76\236\90\136\90\226\65\131\78\170\96\136\72\230\65\131\78\170\120\130\93\227\71\131", "\40\237\41\138")) then
																														elseif (I[LUAOBFUSACTOR_DECRYPT_STR_0("\245\113\252\234\79\212\124\243\246\77\239\113\251\244\67\201\115\202\247\94\206\123\244", "\42\167\20\154\152")]:IsReady() or (3406 < 2659) or (3772 <= 1370)) then
																															if ((2770 < 3538) and Press(M.RefreshingHealingPotion, nil, nil, true)) then
																																return LUAOBFUSACTOR_DECRYPT_STR_0("\88\251\164\80\116\50\66\247\172\69\49\41\79\255\174\75\127\38\10\238\173\86\120\46\68\190\166\71\119\36\68\237\171\84\116\97\30", "\65\42\158\194\34\17");
																															end
																														end
																													end
																													break;
																												end
																											end
																											break;
																										end
																									end
																									break;
																								end
																								if ((FlatIdent_54AEA == 0) or (3283 <= 304)) then
																									FlatIdent_73CDA = 0;
																									FlatIdent_3BE5E = nil;
																									FlatIdent_54AEA = 1;
																								end
																							end
																						end
																						if ((205 < 1318) and (3445 == 3445) and UseRegrowthMouseover and S[LUAOBFUSACTOR_DECRYPT_STR_0("\40\34\85\30\34\250\15\230", "\142\122\71\50\108\77\141\123")]:IsReady() and Player:BuffUp(S.PredatorySwiftnessBuff)) then
																							if (((4871 == 4871) and (Player:HealthPercentage() > RegrowthHP) and Player:IsInParty() and not Player:IsInRaid()) or (2701 <= 2035)) then
																								if ((Mouseover and Mouseover:Exists() and (Mouseover:HealthPercentage() <= RegrowthHP) and not Mouseover:IsDeadOrGhost() and not Player:CanAttack(Mouseover)) or (473 > 761)) then
																									if (Press(M.RegrowthMouseover) or (2384 < 828)) then
																										return LUAOBFUSACTOR_DECRYPT_STR_0("\7\167\248\10\52\2\182\247\39\54\26\183\236\29\52\3\167\237", "\91\117\194\159\120");
																									end
																								end
																							end
																						end
																						FlatIdent_73B61 = 1;
																					end
																					if (FlatIdent_73B61 == 2) then
																						FlatIdent_4D69 = 2;
																						break;
																					end
																					if ((FlatIdent_73B61 == 1) or (1438 == 3376)) then
																						Variables();
																						if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\46\20\57\29\39\226\2\15\15\39", "\68\122\125\94\120\85\145")]:IsCastable() and ((not Player:HasTier(31, 4) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\52\19\193\72\199\210\191\35\20\202\109\216\208\168\30\8\220", "\218\119\124\175\62\168\185")]:IsAvailable()) or Player:BuffDown(S.TigersFury) or (Player:EnergyDeficit() > 65) or (Player:HasTier(31, 951 - (551 + 398)) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\131\245\90\197\169\214\90\193\171\234\81", "\164\197\144\40")]:CooldownUp()) or ((FightRemains < 15) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\179\226\175\143\220\162\140\226", "\214\227\144\202\235\189")]:IsAvailable()))) or (1848 > 3551)) then
																							if (Press(S.TigersFury, not IsInMeleeRange) or (3490 >= 3857) or (4811 <= 1337)) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\249\172\128\126\2\160\108\58\248\183\158\59\29\178\90\50\173\243", "\92\141\197\231\27\112\211\51");
																							end
																						end
																						FlatIdent_73B61 = 2;
																					end
																				end
																				break;
																			end
																		end
																	end
																end
															end
															FlatIdent_2655D = 1;
														end
														if ((FlatIdent_2655D == (1 + 0)) or (1930 == 3490)) then
															FlatIdent_74D28 = 1;
															break;
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
							if (((284 == 284) and (FlatIdent_36517 == 0)) or (813 > 4547)) then
								local FlatIdent_4E8FD = 0;
								local FlatIdent_8BA60;
								while true do
									if ((2448 > 1585) and (FlatIdent_4E8FD == (0 + 0))) then
										FlatIdent_8BA60 = 0;
										while true do
											if (2 == FlatIdent_8BA60) then
												FlatIdent_36517 = 1;
												break;
											end
											if ((FlatIdent_8BA60 == 0) or (55 == 4077)) then
												FetchSettings();
												OOC = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\44\76\228\205\10\83\88", "\43\120\35\131\170\102\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\91\9\132", "\228\52\102\231\214\197\208")];
												FlatIdent_8BA60 = 1;
											end
											if ((2452 < 3645) and (FlatIdent_8BA60 == 1)) then
												AOE = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\239\114\205\230\142\10", "\182\126\128\21\170\138\235\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\213\48", "\102\235\186\85\134\230\115\80")];
												CDs = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\3\57\88\126\209\49", "\66\55\108\94\63\18\180")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\137\150", "\57\116\237\229\87\71")];
												FlatIdent_8BA60 = 2 + 0;
											end
										end
										break;
									end
								end
							end
							if (FlatIdent_36517 == 3) then
								local FlatIdent_43A94 = 0;
								while true do
									if ((3970 > 289) and (FlatIdent_43A94 == 2)) then
										FlatIdent_36517 = 4;
										break;
									end
									if (FlatIdent_43A94 == 1) then
										IsInAoERange = Target:IsInRange(AoERange);
										if (Everyone.TargetIsValid() or Player:AffectingCombat()) then
											local FlatIdent_1F50F = 0;
											while true do
												if ((4729 == 4729) and (FlatIdent_1F50F == 0)) then
													BossFightRemains = EL.BossFightRemains(nil, true);
													FightRemains = BossFightRemains;
													FlatIdent_1F50F = 1;
												end
												if ((4644 < 4686) and (1189 == 1189) and (FlatIdent_1F50F == 1)) then
													if ((2221 >= 2202) and ((FightRemains == 11111) or (4168 <= 1718))) then
														FightRemains = EL.FightRemains(Enemies11y, false);
													end
													break;
												end
											end
										end
										FlatIdent_43A94 = 2;
									end
									if ((3622 <= 4280) and (FlatIdent_43A94 == 0)) then
										ComboPointsDeficit = Player:ComboPointsDeficit();
										IsInMeleeRange = Target:IsInRange(MeleeRange);
										FlatIdent_43A94 = 1;
									end
								end
							end
						end
						break;
					end
				end
				break;
			end
		end
	end
	local function OnInit()
		local FlatIdent_277BD = 0;
		local FlatIdent_2F8F2;
		while true do
			if (0 == FlatIdent_277BD) then
				FlatIdent_2F8F2 = 0;
				while true do
					if ((2034 > 984) and ((FlatIdent_2F8F2 == 0) or (2379 > 3094))) then
						S[LUAOBFUSACTOR_DECRYPT_STR_0("\250\80\85", "\27\168\57\37\26\133")]:RegisterAuraTracking();
						ER.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\11\175\110\169\219\109\142\110\189\222\41\234\126\177\151\8\186\117\171\151\15\165\115\165\252", "\183\77\202\28\200"));
						FlatIdent_2F8F2 = 1;
					end
					if ((3966 >= 570) and (4075 <= 4717) and (FlatIdent_2F8F2 == 1)) then
						EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\49\54\155\9\27\115\173\26\2\58\141\72\47\115\159\72\70\99\199\90\89\99\217\72\53\42\201\42\24\60\132\35", "\104\119\83\233"));
						break;
					end
				end
				break;
			end
		end
	end
	ER.SetAPL(103, APL, OnInit);
end;
return luaobf_bundle[LUAOBFUSACTOR_DECRYPT_STR_0("\208\232\46\58\124\209\234\50\43\71\202\222\34\48\66\249\182\43\55\66", "\35\149\152\71\66")]();

