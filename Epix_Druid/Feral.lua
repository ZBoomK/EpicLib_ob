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
	local FlatIdent_2E7B6 = 0;
	local FlatIdent_5F01B;
	local FlatIdent_540CD;
	local fn;
	while true do
		if (FlatIdent_2E7B6 == 0) then
			FlatIdent_5F01B = 0;
			FlatIdent_540CD = nil;
			FlatIdent_2E7B6 = 1 + 0;
		end
		if (FlatIdent_2E7B6 == 1) then
			fn = nil;
			while true do
				if ((FlatIdent_5F01B == 1) or (469 > 4256)) then
					while true do
						local FlatIdent_82F73 = 0 - 0;
						while true do
							if ((FlatIdent_82F73 == 0) or (3727 < 87)) then
								if ((609 <= 3889) and (0 == FlatIdent_540CD)) then
									local FlatIdent_162B3 = 0;
									while true do
										if ((FlatIdent_162B3 == 0) or (2628 < 2175)) then
											local FlatIdent_16C76 = 0;
											while true do
												if ((2999 == 2999) and (FlatIdent_16C76 == 0)) then
													fn = luaobf_bundle[path];
													if not fn then
														return _require(path, ...);
													end
													FlatIdent_16C76 = 1;
												end
												if ((FlatIdent_16C76 == 1) or (2968 == 71)) then
													FlatIdent_162B3 = 1;
													break;
												end
											end
										end
										if ((3429 < 3464) and (FlatIdent_162B3 == (2 - 1))) then
											FlatIdent_540CD = 1;
											break;
										end
									end
								end
								if (FlatIdent_540CD == 1) then
									return fn(...);
								end
								break;
							end
						end
					end
					break;
				end
				if (FlatIdent_5F01B == 0) then
					local FlatIdent_3ADAE = 0;
					while true do
						if (FlatIdent_3ADAE == 1) then
							FlatIdent_5F01B = 1;
							break;
						end
						if (FlatIdent_3ADAE == 0) then
							FlatIdent_540CD = 0 + 0;
							fn = nil;
							FlatIdent_3ADAE = 1;
						end
					end
				end
			end
			break;
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
	local BossFightRemains = 11749 - (448 + 190);
	local FightRemains = 11111;
	local MeleeRange, AoERange;
	local IsInMeleeRange, IsInAoERange;
	local EnemiesMelee, EnemiesCountMelee;
	local Enemies11y, EnemiesCount11y;
	local BsInc = (S[LUAOBFUSACTOR_DECRYPT_STR_0("\132\211\19\241\106\248\172\201\25\255\118", "\150\205\189\112\144\24")]:IsAvailable() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\12\138\188\77\22\134\16\4\44\139\177", "\112\69\228\223\44\100\232\113")]) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\246\26\21\192\179\110\141", "\230\180\127\103\179\214\28")];
	EL:RegisterForEvent(function()
		BsInc = (S[LUAOBFUSACTOR_DECRYPT_STR_0("\165\11\92\71\246\79\225\152\12\80\72", "\128\236\101\63\38\132\33")]:IsAvailable() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\133\167\18\69\164\229\206\184\160\30\74", "\175\204\201\113\36\214\139")]) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\101\201\39\207\1\85\199", "\100\39\172\85\188")];
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\158\72\156\172\31\158\71\154\168\18\131\95\156\164", "\83\205\24\217\224"), LUAOBFUSACTOR_DECRYPT_STR_0("\202\224\236\15\200\224\233\2\213\245\232\17\202\250\228\19\217\241\236\31", "\93\134\165\173"));
	EL:RegisterForEvent(function()
		local FlatIdent_7E461 = 0 + 0;
		local FlatIdent_432FF;
		while true do
			if ((FlatIdent_7E461 == 0) or (2337 <= 423)) then
				FlatIdent_432FF = 0 + 0;
				while true do
					if (FlatIdent_432FF == 0) then
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
		local FlatIdent_59212 = 0 + 0;
		local FlatIdent_648BB;
		while true do
			if ((0 - 0) == FlatIdent_59212) then
				FlatIdent_648BB = 0;
				while true do
					if (FlatIdent_648BB == (0 - 0)) then
						S[LUAOBFUSACTOR_DECRYPT_STR_0("\196\74\113\26\241\71\102\15\214\89\113\24\232", "\106\133\46\16")]:RegisterInFlightEffect(393383 - (1307 + 187));
						S[LUAOBFUSACTOR_DECRYPT_STR_0("\121\36\114\236\78\73\78\37\64\235\91\82\85", "\32\56\64\19\156\58")]:RegisterInFlight();
						break;
					end
				end
				break;
			end
		end
	end, LUAOBFUSACTOR_DECRYPT_STR_0("\118\237\196\100\116\215\164\101\251\213\115\118\222\191\115\230\218\98\123\208", "\224\58\168\133\54\58\146"));
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\120\82\74\237\97\143\145\14\106\65\74\239\120", "\107\57\54\43\157\21\230\231")]:RegisterInFlightEffect(1554047 - 1162158);
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\250\143\16\229\173\213\217\222\184\6\244\171\209", "\175\187\235\113\149\217\188")]:RegisterInFlight();
	local function ComputeRakePMultiplier()
		return (Player:StealthUp(true, true) and 1.6) or (2 - 1);
	end
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\14\174\138\73", "\24\92\207\225\44\131\25")]:RegisterPMultiplier(S.RakeDebuff, ComputeRakePMultiplier);
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\120\219\170\73\31", "\29\43\179\216\44\123")]:RegisterDamageFormula(function()
		return Player:AttackPowerDamageMod() * (0.7762 - 0) * ((Player:StealthUp(true) and 1.6) or (684 - (232 + 451))) * (obf_AND(1 + 0, Player:VersatilityDmgPct() / 100) + obf_OR(1, Player:VersatilityDmgPct() / 100));
	end);
	S[LUAOBFUSACTOR_DECRYPT_STR_0("\137\209\50\77\174\209", "\44\221\185\64")]:RegisterDamageFormula(function()
		return obf_AND(Player:AttackPowerDamageMod() * (0.1272 + 0), Player:AttackPowerDamageMod() * (564.4055 - (510 + 54))) + obf_OR(Player:AttackPowerDamageMod() * (0.1272 + 0), Player:AttackPowerDamageMod() * (564.4055 - (510 + 54)));
	end);
	local BtTriggers = {S[LUAOBFUSACTOR_DECRYPT_STR_0("\51\230\67\90", "\19\97\135\40\63")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\130\117\30\52\32\63\168\85\33\62", "\81\206\60\83\91\79")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\122\163\194\115\60\203", "\196\46\203\176\18\79\163\45")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\154\48\107\10\37\247\220\180\35\109\22", "\143\216\66\30\126\68\155")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\153\223\4\219\192", "\129\202\168\109\171\165\195\183")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\17\80\37\221\218", "\134\66\56\87\184\190\116")],S[LUAOBFUSACTOR_DECRYPT_STR_0("\26\52\27\186\21\205\51\48\50\43\16", "\85\92\81\105\219\121\139\65")]};
	local function DebuffRefreshAny(Enemies, Spell)
		local FlatIdent_3861C = 0;
		local FlatIdent_F9D5;
		local FlatIdent_94041;
		while true do
			if (FlatIdent_3861C == 1) then
				while true do
					if (FlatIdent_F9D5 == 0) then
						FlatIdent_94041 = 0;
						while true do
							if (FlatIdent_94041 == 0) then
								local FlatIdent_51D6 = 36 - (13 + 23);
								while true do
									if ((FlatIdent_51D6 == (0 - 0)) or (4775 == 715)) then
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
				break;
			end
			if (0 == FlatIdent_3861C) then
				FlatIdent_F9D5 = 0;
				FlatIdent_94041 = nil;
				FlatIdent_3861C = 1 - 0;
			end
		end
	end
	local function LowRakePMult(Enemies)
		local FlatIdent_7C3F6 = 0 - 0;
		local FlatIdent_85F7E;
		local Lowest;
		while true do
			if (FlatIdent_7C3F6 == 0) then
				local FlatIdent_D71E = 0;
				while true do
					if (0 == FlatIdent_D71E) then
						FlatIdent_85F7E = 0;
						Lowest = nil;
						FlatIdent_D71E = 1;
					end
					if (FlatIdent_D71E == (1089 - (830 + 258))) then
						FlatIdent_7C3F6 = 3 - 2;
						break;
					end
				end
			end
			if ((3636 >= 1819) and (FlatIdent_7C3F6 == 1)) then
				while true do
					local FlatIdent_201F4 = 0;
					while true do
						if (FlatIdent_201F4 == 0) then
							if ((FlatIdent_85F7E == 0) or (1101 >= 2393)) then
								local FlatIdent_4E77C = 0;
								while true do
									if (FlatIdent_4E77C == 0) then
										local FlatIdent_80C85 = 0;
										while true do
											if ((1347 == 1347) and (0 == FlatIdent_80C85)) then
												Lowest = nil;
												for _, Enemy in pairs(Enemies) do
													local FlatIdent_82C9B = 0;
													local FlatIdent_4D321;
													local FlatIdent_4721F;
													local EnemyPMult;
													while true do
														if (0 == FlatIdent_82C9B) then
															FlatIdent_4D321 = 0;
															FlatIdent_4721F = nil;
															FlatIdent_82C9B = 1;
														end
														if (FlatIdent_82C9B == (1 + 0)) then
															EnemyPMult = nil;
															while true do
																if ((3743 > 2332) and (FlatIdent_4D321 == (1 + 0))) then
																	while true do
																		if (FlatIdent_4721F == 0) then
																			EnemyPMult = Enemy:PMultiplier(S.Rake);
																			if ((3220 <= 4732) and (not Lowest or (EnemyPMult < Lowest))) then
																				Lowest = EnemyPMult;
																			end
																			break;
																		end
																	end
																	break;
																end
																if ((0 == FlatIdent_4D321) or (4482 >= 4962)) then
																	local FlatIdent_35903 = 0;
																	while true do
																		if ((3467 >= 2430) and (FlatIdent_35903 == 0)) then
																			FlatIdent_4721F = 0;
																			EnemyPMult = nil;
																			FlatIdent_35903 = 1;
																		end
																		if (FlatIdent_35903 == 1) then
																			FlatIdent_4D321 = 1;
																			break;
																		end
																	end
																end
															end
															break;
														end
													end
												end
												FlatIdent_80C85 = 1442 - (860 + 581);
											end
											if ((526 > 511) and (1 == FlatIdent_80C85)) then
												FlatIdent_4E77C = 1;
												break;
											end
										end
									end
									if ((3 - 2) == FlatIdent_4E77C) then
										FlatIdent_85F7E = 1;
										break;
									end
								end
							end
							if (FlatIdent_85F7E == 1) then
								return Lowest;
							end
							break;
						end
					end
				end
				break;
			end
		end
	end
	local function BTBuffUp(Trigger)
		local FlatIdent_FD90 = 0;
		local FlatIdent_979B6;
		while true do
			if ((FlatIdent_FD90 == 0) or (2130 == 1868)) then
				FlatIdent_979B6 = 0;
				while true do
					if ((0 == FlatIdent_979B6) or (2083 > 3867)) then
						local FlatIdent_71D9 = 0;
						while true do
							if (FlatIdent_71D9 == (0 + 0)) then
								local FlatIdent_24149 = 0;
								while true do
									if ((FlatIdent_24149 == 0) or (3090 >= 3604)) then
										if ((3370 < 4153) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\223\191\95\74\120\203\252\191\95\75\111", "\191\157\211\48\37\28")]:IsAvailable()) then
											return false;
										end
										return Trigger:TimeSinceLastCast() < math.min(5, S[LUAOBFUSACTOR_DECRYPT_STR_0("\253\19\251\19\62\203\30\248\19\52\204\61\225\26\60", "\90\191\127\148\124")]:TimeSinceLastAppliedOnPlayer());
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
	local function BTBuffDown(Trigger)
		return not BTBuffUp(Trigger);
	end
	function CountActiveBtTriggers()
		local FlatIdent_50CE = 0;
		local ActiveTriggers;
		while true do
			if (FlatIdent_50CE == 0) then
				ActiveTriggers = 0;
				for i = 1, #BtTriggers do
					if BTBuffUp(BtTriggers[i]) then
						ActiveTriggers = ActiveTriggers + (242 - (237 + 4));
					end
				end
				FlatIdent_50CE = 1;
			end
			if ((4132 == 4132) and (FlatIdent_50CE == 1)) then
				return ActiveTriggers;
			end
		end
	end
	local function TicksGainedOnRefresh(Spell, Tar)
		local FlatIdent_503B5 = 0;
		local FlatIdent_34FAC;
		local AddedDuration;
		local MaxDuration;
		local TickTime;
		local OldTicks;
		local OldTime;
		local NewTime;
		local NewTicks;
		local TicksAdded;
		while true do
			if ((FlatIdent_503B5 == (0 - 0)) or (91 >= 2748)) then
				FlatIdent_34FAC = 0;
				AddedDuration = nil;
				FlatIdent_503B5 = 1;
			end
			if (4 == FlatIdent_503B5) then
				TicksAdded = nil;
				while true do
					local FlatIdent_6CA2C = 0 - 0;
					while true do
						if (FlatIdent_6CA2C == 2) then
							if (FlatIdent_34FAC == 2) then
								local FlatIdent_7E6C0 = 0;
								while true do
									if ((1807 >= 1725) and (FlatIdent_7E6C0 == 1)) then
										if (NewTime <= MaxDuration) then
										else
											NewTime = MaxDuration;
										end
										FlatIdent_34FAC = 3;
										break;
									end
									if ((FlatIdent_7E6C0 == 0) or (633 >= 2602)) then
										OldTime = Tar:DebuffRemains(Spell);
										NewTime = obf_AND(AddedDuration, OldTime) + obf_OR(AddedDuration, OldTime);
										FlatIdent_7E6C0 = 1;
									end
								end
							end
							break;
						end
						if ((FlatIdent_6CA2C == 1) or (377 >= 4657)) then
							if (FlatIdent_34FAC == (5 - 2)) then
								local FlatIdent_16AD9 = 0;
								while true do
									if (FlatIdent_16AD9 == 0) then
										local FlatIdent_3317B = 0;
										while true do
											if ((4868 > 1056) and (FlatIdent_3317B == 0)) then
												NewTicks = NewTime / TickTime;
												if (not OldTicks or (1372 < 761)) then
													OldTicks = 0;
												end
												FlatIdent_3317B = 1;
											end
											if (FlatIdent_3317B == 1) then
												FlatIdent_16AD9 = 1;
												break;
											end
										end
									end
									if ((FlatIdent_16AD9 == (1 + 0)) or (3776 < 3310)) then
										TicksAdded = NewTicks - OldTicks;
										FlatIdent_34FAC = 4;
										break;
									end
								end
							end
							if (FlatIdent_34FAC == (3 + 1)) then
								return TicksAdded;
							end
							FlatIdent_6CA2C = 2;
						end
						if (FlatIdent_6CA2C == 0) then
							if (FlatIdent_34FAC == (3 - 2)) then
								local FlatIdent_FB30 = 0;
								local FlatIdent_69525;
								while true do
									if ((3991 == 3991) and (FlatIdent_FB30 == 0)) then
										FlatIdent_69525 = 0;
										while true do
											if ((3538 >= 3305) and (FlatIdent_69525 == 0)) then
												local FlatIdent_203DC = 0;
												while true do
													if ((FlatIdent_203DC == 0) or (1165 < 1091)) then
														TickTime = 0;
														if ((3782 == 3782) and (Spell == S[LUAOBFUSACTOR_DECRYPT_STR_0("\74\142\62", "\119\24\231\78")])) then
															local FlatIdent_3B88 = 0 + 0;
															while true do
																if ((FlatIdent_3B88 == 0) or (2838 < 2736)) then
																	local FlatIdent_69F0 = 0;
																	local FlatIdent_69A3A;
																	while true do
																		if (FlatIdent_69F0 == 0) then
																			FlatIdent_69A3A = 0;
																			while true do
																				if ((3651 == 3651) and (0 == FlatIdent_69A3A)) then
																					AddedDuration = obf_AND(4, ComboPoints * (3 + 1)) + obf_OR(4, ComboPoints * (3 + 1));
																					MaxDuration = 31.2;
																					FlatIdent_69A3A = 1;
																				end
																				if ((1382 > 677) and (FlatIdent_69A3A == 1)) then
																					FlatIdent_3B88 = 1;
																					break;
																				end
																			end
																			break;
																		end
																	end
																end
																if (FlatIdent_3B88 == 1) then
																	TickTime = Spell:TickTime();
																	break;
																end
															end
														else
															local FlatIdent_79BC0 = 1426 - (85 + 1341);
															local FlatIdent_3A14C;
															while true do
																if ((903 < 2719) and (FlatIdent_79BC0 == 0)) then
																	FlatIdent_3A14C = 0;
																	while true do
																		if (1 == FlatIdent_3A14C) then
																			TickTime = Spell:TickTime();
																			break;
																		end
																		if (FlatIdent_3A14C == (0 - 0)) then
																			AddedDuration = Spell:BaseDuration();
																			MaxDuration = Spell:MaxDuration();
																			FlatIdent_3A14C = 1;
																		end
																	end
																	break;
																end
															end
														end
														FlatIdent_203DC = 1;
													end
													if (FlatIdent_203DC == 1) then
														FlatIdent_69525 = 2 - 1;
														break;
													end
												end
											end
											if ((FlatIdent_69525 == 1) or (2145 > 4711)) then
												OldTicks = Tar:DebuffTicksRemain(Spell);
												FlatIdent_34FAC = 374 - (45 + 327);
												break;
											end
										end
										break;
									end
								end
							end
							if (((0 - 0) == FlatIdent_34FAC) or (4848 <= 4317)) then
								local FlatIdent_86D0A = 502 - (444 + 58);
								while true do
									if ((641 < 4795) and (FlatIdent_86D0A == 0)) then
										if not Tar then
											Tar = Target;
										end
										AddedDuration = 0 + 0;
										FlatIdent_86D0A = 1 + 0;
									end
									if (FlatIdent_86D0A == 1) then
										MaxDuration = 0;
										FlatIdent_34FAC = 1;
										break;
									end
								end
							end
							FlatIdent_6CA2C = 1;
						end
					end
				end
				break;
			end
			if ((1 == FlatIdent_503B5) or (3538 <= 1184)) then
				MaxDuration = nil;
				TickTime = nil;
				FlatIdent_503B5 = 2;
			end
			if (FlatIdent_503B5 == (2 + 1)) then
				NewTime = nil;
				NewTicks = nil;
				FlatIdent_503B5 = 4;
			end
			if (2 == FlatIdent_503B5) then
				OldTicks = nil;
				OldTime = nil;
				FlatIdent_503B5 = 3;
			end
		end
	end
	local function HighestTTD(enemies)
		local FlatIdent_78AA7 = 0;
		local FlatIdent_32176;
		local HighTTD;
		local HighTTDTar;
		while true do
			if ((FlatIdent_78AA7 == 0) or (3810 > 4775)) then
				FlatIdent_32176 = 0;
				HighTTD = nil;
				FlatIdent_78AA7 = 1;
			end
			if (FlatIdent_78AA7 == (2 - 1)) then
				HighTTDTar = nil;
				while true do
					local FlatIdent_69CD1 = 1732 - (64 + 1668);
					local FlatIdent_334A4;
					while true do
						if ((FlatIdent_69CD1 == (1973 - (1227 + 746))) or (3401 <= 2215)) then
							FlatIdent_334A4 = 0 - 0;
							while true do
								if (FlatIdent_334A4 == 0) then
									if ((2557 == 2557) and (0 == FlatIdent_32176)) then
										local FlatIdent_87354 = 0;
										while true do
											if (FlatIdent_87354 == (0 - 0)) then
												if (not enemies or (2318 <= 1935)) then
													return 0;
												end
												HighTTD = 0;
												FlatIdent_87354 = 1;
											end
											if ((3449 == 3449) and (FlatIdent_87354 == 1)) then
												FlatIdent_32176 = 1;
												break;
											end
										end
									end
									if ((FlatIdent_32176 == 2) or (1349 >= 1360)) then
										return HighTTD, HighTTDTar;
									end
									FlatIdent_334A4 = 1;
								end
								if ((3810 >= 779) and (FlatIdent_334A4 == 1)) then
									if ((FlatIdent_32176 == 1) or (2423 == 1135)) then
										local FlatIdent_26DD3 = 0;
										local FlatIdent_218A5;
										while true do
											if (0 == FlatIdent_26DD3) then
												FlatIdent_218A5 = 0;
												while true do
													if ((FlatIdent_218A5 == (495 - (415 + 79))) or (4712 <= 2944)) then
														FlatIdent_32176 = 2;
														break;
													end
													if (0 == FlatIdent_218A5) then
														HighTTDTar = nil;
														for _, enemy in pairs(enemies) do
															local FlatIdent_98D08 = 0;
															local FlatIdent_52048;
															local FlatIdent_312A5;
															local TTD;
															while true do
																if ((FlatIdent_98D08 == 1) or (4586 <= 2063)) then
																	TTD = nil;
																	while true do
																		if ((FlatIdent_52048 == (1 + 0)) or (3589 <= 3247)) then
																			while true do
																				if ((FlatIdent_312A5 == (491 - (142 + 349))) or (1763 < 1755)) then
																					TTD = enemy:TimeToDie();
																					if ((TTD > HighTTD) or (3427 < 2151)) then
																						local FlatIdent_6FFD7 = 0 + 0;
																						local FlatIdent_51E4F;
																						while true do
																							if ((FlatIdent_6FFD7 == (0 - 0)) or (3829 == 3060)) then
																								FlatIdent_51E4F = 0;
																								while true do
																									if ((0 + 0) == FlatIdent_51E4F) then
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
																		if ((FlatIdent_52048 == 0) or (250 == 371)) then
																			FlatIdent_312A5 = 0;
																			TTD = nil;
																			FlatIdent_52048 = 1;
																		end
																	end
																	break;
																end
																if (FlatIdent_98D08 == 0) then
																	FlatIdent_52048 = 0;
																	FlatIdent_312A5 = nil;
																	FlatIdent_98D08 = 1;
																end
															end
														end
														FlatIdent_218A5 = 1;
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
				end
				break;
			end
		end
	end
	local function EvaluateTargetIfFilterAdaptiveSwarm(TargetUnit)
		return (1 + 0 + TargetUnit:DebuffStack(S.AdaptiveSwarmDebuff)) * num(TargetUnit:DebuffStack(S.AdaptiveSwarmDebuff) < 3) * TargetUnit:TimeToDie();
	end
	local function EvaluateTargetIfFilterLIMoonfire(TargetUnit)
		return obf_AND((7 - 4) * num(TargetUnit:DebuffRefreshable(S.LIMoonfireDebuff)), num(TargetUnit:DebuffUp(S.LIMoonfireDebuff))) + obf_OR((7 - 4) * num(TargetUnit:DebuffRefreshable(S.LIMoonfireDebuff)), num(TargetUnit:DebuffUp(S.LIMoonfireDebuff)));
	end
	local function EvaluateTargetIfFilterRake(TargetUnit)
		return obf_AND(25 * num(Player:PMultiplier(S.Rake) < TargetUnit:PMultiplier(S.Rake)), TargetUnit:DebuffRemains(S.RakeDebuff)) + obf_OR(25 * num(Player:PMultiplier(S.Rake) < TargetUnit:PMultiplier(S.Rake)), TargetUnit:DebuffRemains(S.RakeDebuff));
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
		return (S[LUAOBFUSACTOR_DECRYPT_STR_0("\160\63\176\94\221\76\34\142\44\182\66", "\113\226\77\197\42\188\32")]:FullRechargeTime() < (322 - (200 + 118))) or (TargetUnit:TimeToDie() < (2 + 3));
	end
	local function EvaluateTargetIfBrutalSlashBT(TargetUnit)
		return ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\24\4\225\161\59\26\199\185\59\5\252", "\213\90\118\148")]:FullRechargeTime() < 4) or (TargetUnit:TimeToDie() < 5)) and BTBuffDown(S.BrutalSlash) and (Player:BuffUp(BsInc) or VarNeedBT);
	end
	local function EvaluateTargetIfConvokeCD(TargetUnit)
		return (FightRemains < (8 - 3)) or ((Player:BuffUp(S.SmolderingFrenzyBuff) or not Player:HasTier(31, 4)) and (TargetUnit:DebuffRemains(S.Rip) > (4 - num(S[LUAOBFUSACTOR_DECRYPT_STR_0("\122\61\188\87\64\90\32\177\69\106\78\39\176\87\67\88\43", "\45\59\78\212\54")]:IsAvailable()))) and Player:BuffUp(S.TigersFury) and (ComboPoints < 2) and (TargetUnit:DebuffUp(S.DireFixationDebuff) or not S[LUAOBFUSACTOR_DECRYPT_STR_0("\52\95\145\142\160\39\181\241\4\95\140\133", "\144\112\54\227\235\230\78\205")]:IsAvailable() or (EnemiesCount11y > 1)) and (((TargetUnit:TimeToDie() < FightRemains) and (TargetUnit:TimeToDie() > (5 - num(S[LUAOBFUSACTOR_DECRYPT_STR_0("\146\59\7\253\221\90\189\45\28\219\197\82\183\41\1\255\213", "\59\211\72\111\156\176")]:IsAvailable())))) or (TargetUnit:TimeToDie() == FightRemains)));
	end
	local function EvaluateTargetIfLIMoonfireAoEBuilder(TargetUnit)
		return (TargetUnit:DebuffRefreshable(S.LIMoonfireDebuff));
	end
	local function EvaluateTargetIfLIMoonfireBT(TargetUnit)
		return (TicksGainedOnRefresh(S.LIMoonfireDebuff, TargetUnit));
	end
	local function EvaluateTargetIfFeralFrenzy(TargetUnit)
		return ((ComboPoints < 3) or ((EL.CombatTime() < 10) and (ComboPoints < (5 - 1)))) and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\106\142\241\40\104\142\251\44\90\142\236\35", "\77\46\231\131")]:IsAvailable() or TargetUnit:DebuffUp(S.DireFixationDebuff) or (EnemiesCount11y > 1)) and (((TargetUnit:TimeToDie() < FightRemains) and (Target:TimeToDie() > 6)) or (TargetUnit:TimeToDie() == FightRemains)) and not ((EnemiesCount11y == 1) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\153\91\184\86\181\95\179\116\178\81\133\80\179\70\191\84\169", "\32\218\52\214")]:IsAvailable());
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
		return (TargetUnit:DebuffDown(S.AdaptiveSwarmDebuff) or (TargetUnit:DebuffRemains(S.AdaptiveSwarmDebuff) < 2)) and (TargetUnit:DebuffStack(S.AdaptiveSwarmDebuff) < 3) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\111\19\48\184\229\185\83\95\125\0\48\186\252", "\58\46\119\81\200\145\208\37")]:InFlight() and (TargetUnit:TimeToDie() > 5);
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
		return ((Player:HasTier(31, 2) and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\13\137\34\173\165\155\36\46\130\42\181", "\86\75\236\80\204\201\221")]:CooldownRemains() < (2 + 0)) and (TargetUnit:DebuffRemains(S.Rip) < 10)) or (((EL.CombatTime() < 8) or Player:BuffUp(S.BloodtalonsBuff) or not S[LUAOBFUSACTOR_DECRYPT_STR_0("\80\77\120\138\250\159\115\77\120\139\237", "\235\18\33\23\229\158")]:IsAvailable() or (Player:BuffUp(BsInc) and (TargetUnit:DebuffRemains(S.Rip) < 2))) and TargetUnit:DebuffRefreshable(S.Rip))) and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\96\168\200\182\81\182\246\169\81\174\201", "\219\48\218\161")]:IsAvailable() or (EnemiesCount11y == 1)) and not (Player:BuffUp(S.SmolderingFrenzyBuff) and (TargetUnit:DebuffRemains(S.Rip) > (2 + 0)));
	end
	local function EvaluateCycleThrash(TargetUnit)
		return (TargetUnit:DebuffRefreshable(S.ThrashDebuff));
	end
	local function Precombat()
		local FlatIdent_56875 = 0;
		local FlatIdent_4A991;
		local FlatIdent_957A6;
		while true do
			if ((4374 > 1370) and (1 == FlatIdent_56875)) then
				while true do
					if ((3519 > 3133) and (FlatIdent_4A991 == 0)) then
						FlatIdent_957A6 = 0;
						while true do
							if ((4996 > 4721) and (FlatIdent_957A6 == 0)) then
								local FlatIdent_5B03D = 0;
								while true do
									if (FlatIdent_5B03D == 1) then
										FlatIdent_957A6 = 1;
										break;
									end
									if ((4023 >= 2719) and (FlatIdent_5B03D == 0)) then
										local FlatIdent_4A385 = 0 + 0;
										while true do
											if (FlatIdent_4A385 == 0) then
												if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\199\112\104\111\212\93\237", "\128\132\17\28\41\187\47")]:IsCastable() and UseCatFormOOC) then
													if Press(S.CatForm) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\2\51\18\5\91\14\32\11\122\77\19\55\5\53\80\3\51\18\122\15", "\61\97\82\102\90");
													end
												end
												if ((243 <= 4516) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\132\43\170\89\211\120\24\61\164\43\156\66\203\83", "\105\204\78\203\43\167\55\126")]:IsCastable()) then
													if ((3743 >= 1870) and Press(S.HeartOfTheWild)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\173\175\34\12\7\59\200\87\154\190\43\27\44\19\206\93\161\234\51\12\22\7\200\92\167\171\55\94\71", "\49\197\202\67\126\115\100\167");
													end
												end
												FlatIdent_4A385 = 1;
											end
											if (FlatIdent_4A385 == 1) then
												FlatIdent_5B03D = 1;
												break;
											end
										end
									end
								end
							end
							if (2 == FlatIdent_957A6) then
								if ((298 <= 3318) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\23\208\81\95", "\211\69\177\58\58")]:IsReady()) then
									if Press(S.Rake, not IsInMeleeRange) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\165\228\114\240\169\219\165\224\122\250\228\201\182\241\57\173", "\171\215\133\25\149\137");
									end
								end
								break;
							end
							if (FlatIdent_957A6 == 1) then
								local FlatIdent_33725 = 0;
								while true do
									if (FlatIdent_33725 == 0) then
										local FlatIdent_19E1C = 0 + 0;
										while true do
											if ((1156 < 3232) and (FlatIdent_19E1C == 1)) then
												FlatIdent_33725 = 1;
												break;
											end
											if ((777 < 2530) and ((0 - 0) == FlatIdent_19E1C)) then
												if ((3745 >= 2715) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\7\73\208\62\140", "\62\87\59\191\73\224\54")]:IsCastable() and (UsageProwlOOC == LUAOBFUSACTOR_DECRYPT_STR_0("\198\14\237\200\254\17", "\169\135\98\154"))) then
													if Press(S.Prowl) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\219\101\43\67\241\115\216\217\114\39\91\240\49\201\223\55\112", "\168\171\23\68\52\157\83");
													end
												elseif (S[LUAOBFUSACTOR_DECRYPT_STR_0("\196\99\250\186\41", "\231\148\17\149\205\69\77")]:IsCastable() and (UsageProwlOOC == LUAOBFUSACTOR_DECRYPT_STR_0("\164\174\212\239\86\241\131\162", "\159\224\199\167\155\55")) and Target:IsInRange(ProwlRange)) then
													if (Press(S.Prowl) or (4942 == 1715)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\231\225\51\197\251\179\44\192\242\240\51\223\245\242\40\146\163", "\178\151\147\92");
													end
												end
												if (UseWildCharge and S[LUAOBFUSACTOR_DECRYPT_STR_0("\187\244\64\54\49\68\123\158\250\73", "\26\236\157\44\82\114\44")]:IsCastable() and not Target:IsInRange(1258 - (363 + 887))) then
													if (Press(S.WildCharge, not Target:IsInRange(28)) or (2975 > 4424)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\61\39\217\95\21\45\221\90\56\41\208\27\58\60\208\88\37\35\215\90\62\110\131", "\59\74\78\181");
													end
												end
												FlatIdent_19E1C = 1;
											end
										end
									end
									if ((2898 >= 1084) and (FlatIdent_33725 == 1)) then
										FlatIdent_957A6 = 2;
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
			if (FlatIdent_56875 == 0) then
				FlatIdent_4A991 = 0 - 0;
				FlatIdent_957A6 = nil;
				FlatIdent_56875 = 1;
			end
		end
	end
	local function Variables()
		local FlatIdent_7CFCE = 0;
		local FlatIdent_14BDB;
		local DungeonSlice;
		local CombatTime;
		local TimeCheck;
		while true do
			if (FlatIdent_7CFCE == 0) then
				FlatIdent_14BDB = 0;
				DungeonSlice = nil;
				FlatIdent_7CFCE = 4 - 3;
			end
			if ((2 == FlatIdent_7CFCE) or (103 == 4087)) then
				while true do
					if (FlatIdent_14BDB == 1) then
						local FlatIdent_1FC2 = 0;
						while true do
							if (FlatIdent_1FC2 == 0) then
								VarLastZerk = (FightRemains > (obf_AND(5 + 25, BsInc:CooldownRemains() / (2.6 - 1)) + obf_OR(30, BsInc:CooldownRemains() / (2.6 - 1)))) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\23\177\153\225\223\39\191\163\247\219\39\160\132\244\206\61\177\167\251\213\59", "\186\85\212\235\146")]:IsAvailable() and (FightRemains < (obf_AND(90, BsInc:CooldownRemains() / 1.6) + obf_OR(90, BsInc:CooldownRemains() / 1.6)))) or (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\224\132\4\237\60\252\83\234\132\23\236\45\225\94\214\137\19\210\48\225\86", "\56\162\225\118\158\89\142")]:IsAvailable() and (FightRemains < (obf_AND(180, BsInc:CooldownRemains()) + obf_OR(180, BsInc:CooldownRemains())))));
								VarZerkBiteweave = true;
								FlatIdent_1FC2 = 1;
							end
							if ((3036 > 2582) and (FlatIdent_1FC2 == 1)) then
								local FlatIdent_50510 = 0;
								while true do
									if ((FlatIdent_50510 == (1 + 0)) or (255 > 608)) then
										FlatIdent_1FC2 = 2;
										break;
									end
									if ((0 == FlatIdent_50510) or (3982 <= 2940)) then
										VarRegrowth = true;
										VarEasySwipe = true;
										FlatIdent_50510 = 1;
									end
								end
							end
							if ((2 == FlatIdent_1FC2) or (3791 > 4684)) then
								FlatIdent_14BDB = 2;
								break;
							end
						end
					end
					if ((FlatIdent_14BDB == (1666 - (674 + 990))) or (2927 <= 967)) then
						VarForceAlign2Min = true;
						CombatTime = EL.CombatTime();
						TimeCheck = obf_AND(CombatTime, FightRemains) + obf_OR(CombatTime, FightRemains);
						VarAlignCDs = (VarForceAlign2Min or I[LUAOBFUSACTOR_DECRYPT_STR_0("\107\12\212\167\39\202\94\4\210\164\49\250\78\4\206\172\42", "\184\60\101\160\207\66")]:IsEquipped() or I[LUAOBFUSACTOR_DECRYPT_STR_0("\16\145\116\185\34\141\122\168\57\135\89\177\51\135\110\175\62\151\112", "\220\81\226\28")]:IsEquipped() or ((TimeCheck > 150) and (TimeCheck < 200)) or ((TimeCheck > 270) and (TimeCheck < 295)) or ((TimeCheck > 395) and (TimeCheck < 400)) or ((TimeCheck > (141 + 349)) and (TimeCheck < 495))) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\48\218\140\237\229\204\22\225\138\254\217\215\26\199\139\239\249", "\167\115\181\226\155\138")]:IsAvailable() and not DungeonSlice and (EnemiesCount11y == (1 + 0)) and Player:HasTier(31, 2);
						break;
					end
					if (FlatIdent_14BDB == 0) then
						local FlatIdent_7393F = 0;
						local FlatIdent_4B180;
						while true do
							if (FlatIdent_7393F == (0 - 0)) then
								FlatIdent_4B180 = 1055 - (507 + 548);
								while true do
									if ((FlatIdent_4B180 == 2) or (631 > 2929)) then
										FlatIdent_14BDB = 1;
										break;
									end
									if (FlatIdent_4B180 == 0) then
										VarNeedBT = S[LUAOBFUSACTOR_DECRYPT_STR_0("\195\196\61\245\235\36\253\78\238\198\33", "\34\129\168\82\154\143\80\156")]:IsAvailable() and (Player:BuffStack(S.BloodtalonsBuff) <= 1);
										DungeonSlice = Player:IsInParty() and not Player:IsInRaid();
										FlatIdent_4B180 = 1;
									end
									if ((FlatIdent_4B180 == 1) or (341 > 3956)) then
										local FlatIdent_EA1A = 0;
										while true do
											if ((837 - (289 + 548)) == FlatIdent_EA1A) then
												VarAlign3Mins = (EnemiesCount11y == 1) and not DungeonSlice;
												VarLastConvoke = (FightRemains > (obf_AND(S[LUAOBFUSACTOR_DECRYPT_STR_0("\166\189\61\29\71\69\140\177\186\54\56\88\71\155\140\166\32", "\233\229\210\83\107\40\46")]:CooldownRemains(), 1821 - (821 + 997)) + obf_OR(S[LUAOBFUSACTOR_DECRYPT_STR_0("\166\189\61\29\71\69\140\177\186\54\56\88\71\155\140\166\32", "\233\229\210\83\107\40\46")]:CooldownRemains(), 3))) and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\224\81\58\215\8\192\76\55\197\34\212\75\54\215\11\194\71", "\101\161\34\82\182")]:IsAvailable() and (FightRemains < (obf_AND(S[LUAOBFUSACTOR_DECRYPT_STR_0("\203\2\87\232\212\233\135\26\224\8\106\238\210\240\139\58\251", "\78\136\109\57\158\187\130\226")]:CooldownRemains(), 315 - (195 + 60)) + obf_OR(S[LUAOBFUSACTOR_DECRYPT_STR_0("\203\2\87\232\212\233\135\26\224\8\106\238\210\240\139\58\251", "\78\136\109\57\158\187\130\226")]:CooldownRemains(), 60)))) or (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\31\44\241\240\51\62\247\244\45\24\236\248\58\62\247\242\59", "\145\94\95\153")]:IsAvailable() and (FightRemains < (obf_AND(S[LUAOBFUSACTOR_DECRYPT_STR_0("\222\194\26\195\65\188\248\249\28\208\125\167\244\223\29\193\93", "\215\157\173\116\181\46")]:CooldownRemains(), 12) + obf_OR(S[LUAOBFUSACTOR_DECRYPT_STR_0("\222\194\26\195\65\188\248\249\28\208\125\167\244\223\29\193\93", "\215\157\173\116\181\46")]:CooldownRemains(), 12)))));
												FlatIdent_EA1A = 1 + 0;
											end
											if ((FlatIdent_EA1A == 1) or (4842 <= 1498)) then
												FlatIdent_4B180 = 2;
												break;
											end
										end
									end
								end
								break;
							end
						end
					end
				end
				break;
			end
			if (FlatIdent_7CFCE == 1) then
				CombatTime = nil;
				TimeCheck = nil;
				FlatIdent_7CFCE = 2;
			end
		end
	end
	local function Builder()
		local FlatIdent_5F6CE = 1501 - (251 + 1250);
		local FlatIdent_884CA;
		while true do
			if (FlatIdent_5F6CE == (0 - 0)) then
				FlatIdent_884CA = 0 + 0;
				while true do
					if ((FlatIdent_884CA == 1) or (1312 > 4950)) then
						if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\33\40\57\120\179\99\31\37\52\120", "\20\114\64\88\28\220")]:IsCastable() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\3\0\217\177", "\221\81\97\178\212\152\176")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (Target:DebuffRefreshable(S.RakeDebuff) or (Target:PMultiplier(S.Rake) < 1.4)) and not (VarNeedBT and BTBuffUp(S.Rake)) and Player:BuffDown(S.Prowl)) or (840 == 1211)) then
							if ((4499 > 1584) and Press(S.Shadowmeld)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\222\239\28\255\21\218\234\24\247\30\141\229\8\242\22\201\226\15\187\78", "\122\173\135\125\155");
							end
						end
						if ((3708 <= 4221) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\182\192\11\188", "\168\228\161\96\217\95\81")]:IsReady() and (Target:DebuffRefreshable(S.RakeDebuff) or (Player:BuffUp(S.SuddenAmbushBuff) and (Player:PMultiplier(S.Rake) > Target:PMultiplier(S.Rake)))) and not (VarNeedBT and BTBuffUp(S.Rake))) then
							if Press(S.Rake, not IsInMeleeRange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\201\208\37\89\111\85\206\216\34\88\42\69\155\135", "\55\187\177\78\60\79");
							end
						end
						if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\1\231\114\228\73\193\134\36\220\90", "\224\77\174\63\139\38\175")]:IsReady() or (3680 <= 483)) then
							if ((1429 <= 3193) and Everyone.CastCycle(S.LIMoonfire, Enemies11y, EvaluateCycleLIMoonfire, not Target:IsSpellInRange(S.LIMoonfire), nil, nil, M.MoonfireMouseover)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\137\78\87\32\130\72\74\43\187\66\89\58\196\67\77\39\136\69\93\60\196\25", "\78\228\33\56");
							end
						end
						if ((2629 > 487) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\250\118\160\2\150\198", "\229\174\30\210\99")]:IsCastable() and Target:DebuffRefreshable(S.ThrashDebuff) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\47\229\148\80\254\53\48\21\234\165\93\236\42\42", "\89\123\141\230\49\141\93")]:IsAvailable()) then
							if Press(S.Thrash, not IsInAoERange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\231\121\228\13\3\66\179\115\227\5\28\78\246\99\182\93\64", "\42\147\17\150\108\112");
							end
						end
						FlatIdent_884CA = 2;
					end
					if (FlatIdent_884CA == 0) then
						if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\214\42\245\93\104\121", "\166\130\66\135\60\27\17")]:IsCastable() and Target:DebuffRefreshable(S.ThrashDebuff) and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\96\67\220\112\22\77\82\207\97\57\75\68", "\80\36\42\174\21")]:IsAvailable() or (S[LUAOBFUSACTOR_DECRYPT_STR_0("\106\25\37\127\104\25\47\123\90\25\56\116", "\26\46\112\87")]:IsAvailable() and Target:DebuffUp(S.DireFixationDebuff))) and Player:BuffUp(S.Clearcasting) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\141\43\185\117\172\183\76\186\190\0\167\117\168\172", "\212\217\67\203\20\223\223\37")]:IsAvailable()) or (4372 < 2905)) then
							if Press(S.Thrash, not IsInAoERange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\174\133\186\211\169\133\232\208\175\132\164\214\191\159\232\128", "\178\218\237\200");
							end
						end
						if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\133\189\244\213\178", "\176\214\213\134")]:IsReady() and (Player:BuffUp(S.Clearcasting) or (S[LUAOBFUSACTOR_DECRYPT_STR_0("\208\164\164\209\142\95\65\245\185\191\219\166", "\57\148\205\214\180\200\54")]:IsAvailable() and Target:DebuffDown(S.DireFixationDebuff))) and not (VarNeedBT and BTBuffUp(S.Shred))) then
							if Press(S.Shred, not IsInMeleeRange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\1\245\39\49\114\82\255\32\61\122\22\248\39\116\34", "\22\114\157\85\84");
							end
						end
						if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\230\217\6\208\92\250\155\200\202\0\204", "\200\164\171\115\164\61\150")]:IsReady() and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\156\230\22\81\130\178\199\15\68\144\182", "\227\222\148\99\37")]:FullRechargeTime() < 4) and not (VarNeedBT and BTBuffUp(S.BrutalSlash))) then
							if Press(S.BrutalSlash, not IsInAoERange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\49\64\71\226\248\63\109\65\250\248\32\90\18\244\236\58\94\86\243\235\115\4", "\153\83\50\50\150");
							end
						end
						if (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\111\119\120\25", "\45\61\22\19\124\19\203")]:IsReady() and (Target:DebuffRefreshable(S.RakeDebuff) or (Player:BuffUp(S.SuddenAmbushBuff) and (Player:PMultiplier(S.Rake) > Target:PMultiplier(S.Rake)) and (Target:DebuffRemains(S.RakeDebuff) > 6))) and Player:BuffDown(S.Clearcasting) and not (VarNeedBT and BTBuffUp(S.Rake))) then
							if Press(S.Pool) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\241\29\2\249\66\118\182\211\82\63\244\9\117\249\200\28\77\215\23\121\181\197\23\31\189\75", "\217\161\114\109\149\98\16");
							end
						end
						FlatIdent_884CA = 1;
					end
					if ((1134 > 513) and (FlatIdent_884CA == 3)) then
						if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\117\109\93\30\54", "\83\38\26\52\110")]:IsReady() and VarNeedBT and BTBuffDown(S.Swipe)) or (3433 == 2550)) then
							if Press(S.Swipe, not IsInAoERange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\75\0\46\86\93\87\37\83\81\27\35\67\74\87\117\22", "\38\56\119\71");
							end
						end
						if ((407 <= 1997) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\193\238\83\211", "\54\147\143\56\182\69")]:IsReady() and VarNeedBT and BTBuffDown(S.Rake) and (Player:PMultiplier(S.Rake) >= Target:PMultiplier(S.Rake))) then
							if (Press(S.Rake, not IsInMeleeRange) or (1455 >= 2073)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\196\128\244\76\159\212\148\246\69\219\211\147\191\27\141", "\191\182\225\159\41");
							end
						end
						if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\31\26\58\84\152\143", "\162\75\114\72\53\235\231")]:IsCastable() and VarNeedBT and BTBuffDown(S.Thrash)) or (3473 > 4578)) then
							if ((2519 < 3193) and Press(S.Thrash, not IsInAoERange)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\152\52\86\227\64\10\204\62\81\235\95\6\137\46\4\176\7", "\98\236\92\36\130\51");
							end
						end
						break;
					end
					if (FlatIdent_884CA == 2) then
						local FlatIdent_63E5 = 0;
						while true do
							if ((FlatIdent_63E5 == 2) or (463 >= 4937)) then
								FlatIdent_884CA = 1035 - (809 + 223);
								break;
							end
							if (0 == FlatIdent_63E5) then
								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\45\180\56\107\230\228\60\170\44\108\239", "\136\111\198\77\31\135")]:IsReady() and not (VarNeedBT and BTBuffUp(S.BrutalSlash))) then
									if (Press(S.BrutalSlash, not IsInAoERange) or (3991 <= 3758)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\0\27\178\66\188\232\40\186\14\8\180\94\253\230\2\160\14\13\162\68\253\181\69", "\201\98\105\199\54\221\132\119");
									end
								end
								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\138\27\138\49\7", "\204\217\108\227\65\98\85")]:IsReady() and ((EnemiesCount11y > 1) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\105\202\249\225\31\204\95\208\253\224\63", "\160\62\163\149\133\76")]:IsAvailable())) then
									if Press(S.Swipe, not IsInAoERange) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\197\183\4\63\198\150\162\24\38\207\210\165\31\111\146\130", "\163\182\192\109\79");
									end
								end
								FlatIdent_63E5 = 1;
							end
							if ((FlatIdent_63E5 == (1 - 0)) or (4387 <= 2300)) then
								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\7\46\18\197\241", "\149\84\70\96\160")]:IsReady() and not (VarNeedBT and BTBuffUp(S.Shred))) then
									if Press(S.Shred, not IsInMeleeRange) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\43\14\31\232\60\70\15\248\49\10\9\232\42\70\92\187", "\141\88\102\109");
									end
								end
								if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\159\122\231\127\21\51\83\200\161\86", "\161\211\51\170\16\122\93\53")]:IsReady() and VarNeedBT and BTBuffDown(S.LIMoonfire)) or (4301 == 2660)) then
									if Press(S.LIMoonfire, not Target:IsSpellInRange(S.LIMoonfire)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\246\161\189\38\253\167\160\45\196\173\179\60\187\172\167\33\247\170\183\58\187\255\234", "\72\155\206\210");
									end
								end
								FlatIdent_63E5 = 2;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function AoeBuilder()
		local FlatIdent_14194 = 0;
		local FlatIdent_2DBA1;
		while true do
			if (FlatIdent_14194 == 0) then
				FlatIdent_2DBA1 = 0;
				while true do
					if (FlatIdent_2DBA1 == 3) then
						if ((1590 <= 3077) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\203\121\70\183\37\214", "\156\159\17\52\214\86\190")]:IsReady()) then
							if (Press(S.Thrash, not IsInAoERange) or (4107 <= 1029)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\186\231\175\189\189\231\253\189\161\234\130\190\187\230\177\184\171\253\253\238\248", "\220\206\143\221");
							end
						end
						break;
					end
					if ((FlatIdent_2DBA1 == 2) or (1843 == 3876)) then
						local FlatIdent_345DE = 0;
						while true do
							if ((4715 >= 1158) and (FlatIdent_345DE == 1)) then
								local FlatIdent_B46D = 0 - 0;
								while true do
									if ((1989 == 1989) and (1 == FlatIdent_B46D)) then
										FlatIdent_345DE = 2;
										break;
									end
									if ((FlatIdent_B46D == (0 - 0)) or (3162 == 4103)) then
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\26\96\222\31\124\192\48\64\225\21", "\174\86\41\147\112\19")]:IsReady() or (3247 == 4400)) then
											if Everyone.CastTargetIf(S.LIMoonfire, Enemies11y, LUAOBFUSACTOR_DECRYPT_STR_0("\86\1\149", "\203\59\96\237\107\69\111\113"), EvaluateTargetIfFilterLIMoonfire, EvaluateTargetIfLIMoonfireAoEBuilder, not Target:IsSpellInRange(S.LIMoonfire)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\41\25\163\239\55\249\197\33\41\175\224\37\176\214\43\19\147\227\36\249\219\32\19\190\242\113\162\133", "\183\68\118\204\129\81\144");
											end
										end
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\61\165\98\225\15", "\226\110\205\16\132\107")]:IsReady() and ((EnemiesCount11y < (3 + 1)) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\207\202\242\220\103\226\219\225\205\72\228\205", "\33\139\163\128\185")]:IsAvailable()) and Player:BuffDown(S.SuddenAmbushBuff) and not (VarEasySwipe and S[LUAOBFUSACTOR_DECRYPT_STR_0("\96\81\8\218\100\84\5\205\95\93\23", "\190\55\56\100")]:IsAvailable())) then
											if ((3761 > 2745) and Everyone.CastTargetIf(S.Shred, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\91\174\36", "\147\54\207\92\126\115\131"), EvaluateTargetIfFilterTTD, nil, not IsInMeleeRange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\30\57\39\120\9\62\12\62\48\66\15\107\4\61\49\120\31\62\95\101", "\30\109\81\85\29\109");
											end
										end
										FlatIdent_B46D = 1;
									end
								end
							end
							if ((772 < 4176) and (FlatIdent_345DE == 0)) then
								local FlatIdent_25330 = 0 + 0;
								while true do
									if ((2766 >= 654) and (FlatIdent_25330 == 0)) then
										if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\135\234\102\73\76\68\61\68\185\198", "\45\203\163\43\38\35\42\91")]:IsReady() and (EnemiesCount11y < (622 - (14 + 603)))) or (4827 == 2370)) then
											if Everyone.CastTargetIf(S.LIMoonfire, Enemies11y, LUAOBFUSACTOR_DECRYPT_STR_0("\223\132\196", "\52\178\229\188\67\231\201"), EvaluateTargetIfFilterLIMoonfire, EvaluateTargetIfLIMoonfireAoEBuilder, not Target:IsSpellInRange(S.LIMoonfire)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\44\78\95\10\241\85\49\36\126\83\5\227\28\34\46\68\111\6\226\85\47\37\68\66\23\183\13\123", "\67\65\33\48\100\151\60");
											end
										end
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\236\240\167\200\246", "\147\191\135\206\184")]:IsReady() or (2486 > 2851)) then
											if Press(S.Swipe, not IsInAoERange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\151\63\175\209\221\19\179\139\45\153\195\205\90\190\128\45\180\129\138\3", "\210\228\72\198\161\184\51");
											end
										end
										FlatIdent_25330 = 1;
									end
									if (FlatIdent_25330 == 1) then
										FlatIdent_345DE = 1;
										break;
									end
								end
							end
							if ((FlatIdent_345DE == (131 - (118 + 11))) or (3984 == 1629)) then
								FlatIdent_2DBA1 = 3;
								break;
							end
						end
					end
					if (FlatIdent_2DBA1 == 0) then
						local FlatIdent_22ADB = 0;
						while true do
							if ((FlatIdent_22ADB == (1 + 0)) or (2473 > 3375)) then
								local FlatIdent_1D10A = 0;
								while true do
									if ((FlatIdent_1D10A == 1) or (4886 == 1971)) then
										FlatIdent_22ADB = 2;
										break;
									end
									if (((0 + 0) == FlatIdent_1D10A) or (2594 <= 1430)) then
										if ((4813 > 4545) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\117\68\192\167\249\223\75\73\205\167", "\168\38\44\161\195\150")]:IsReady() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\178\253\137\115", "\118\224\156\226\22\80\136\214")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (DebuffRefreshAny(Enemies11y, S.RakeDebuff) or (LowRakePMult(Enemies11y) < 1.4)) and Player:BuffDown(S.Prowl) and Player:BuffDown(S.ApexPredatorsCravingBuff)) then
											if (Press(S.Shadowmeld) or (4915 < 4893)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\81\230\88\132\77\249\84\133\78\234\25\129\77\235\102\130\87\231\85\132\71\252\25\214", "\224\34\142\57");
											end
										end
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\237\175\196\217\124\230\80\11\210\163", "\110\190\199\165\189\19\145\61")]:IsReady() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\232\234\124\237", "\167\186\139\23\136\235")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (LowRakePMult(Enemies11y) < 1.4) and Player:BuffDown(S.Prowl) and Player:BuffDown(S.ApexPredatorsCravingBuff)) then
											if ((4143 == 4143) and Press(S.Shadowmeld)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\9\189\137\9\21\162\133\8\22\177\200\12\21\176\183\15\15\188\132\9\31\167\200\85", "\109\122\213\232");
											end
										end
										FlatIdent_1D10A = 2 - 1;
									end
								end
							end
							if (FlatIdent_22ADB == 0) then
								local FlatIdent_5B99E = 949 - (551 + 398);
								while true do
									if (FlatIdent_5B99E == 0) then
										if ((1223 < 3414) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\134\11\25\174\68\164\134\60\165\10\4", "\80\196\121\108\218\37\200\213")]:IsReady()) then
											if ((450 < 2517) and Everyone.CastTargetIf(S.BrutalSlash, Enemies11y, LUAOBFUSACTOR_DECRYPT_STR_0("\13\122\12", "\234\96\19\98\31\43\110"), EvaluateTargetIfFilterTTD, EvaluateTargetIfBrutalSlashAoeBuilder, not IsInAoERange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\4\13\71\211\173\126\180\21\19\83\212\164\50\138\9\26\109\197\185\123\135\2\26\64\135\254", "\235\102\127\50\167\204\18");
											end
										end
										if ((2235 == 2235) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\100\169\231\34\87\38", "\78\48\193\149\67\36")]:IsReady() and (Player:BuffUp(S.Clearcasting) or (((EnemiesCount11y > 10) or ((EnemiesCount11y > (4 + 1)) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\20\17\149\26\77\53\61\140\25\86\53\26\178\25\74\53", "\33\80\126\224\120")]:IsAvailable())) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\216\160\17\197\79\228\161\13\195\127\224\169\20\215", "\60\140\200\99\164")]:IsAvailable()))) then
											if Everyone.CastCycle(S.Thrash, Enemies11y, EvaluateCycleThrash, not IsInAoERange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\147\252\22\39\177\143\180\5\41\167\184\246\17\47\174\131\241\22\102\246", "\194\231\148\100\70");
											end
										end
										FlatIdent_5B99E = 1 + 0;
									end
									if ((927 <= 2517) and (FlatIdent_5B99E == 1)) then
										FlatIdent_22ADB = 1;
										break;
									end
								end
							end
							if ((2 == FlatIdent_22ADB) or (2073 > 4117)) then
								FlatIdent_2DBA1 = 1;
								break;
							end
						end
					end
					if (FlatIdent_2DBA1 == 1) then
						local FlatIdent_1348A = 0;
						while true do
							if ((FlatIdent_1348A == (2 + 0)) or (3015 > 4666)) then
								FlatIdent_2DBA1 = 2;
								break;
							end
							if (FlatIdent_1348A == 0) then
								if ((1039 < 4270) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\220\246\169\53", "\80\142\151\194")]:IsReady() and (Player:BuffUp(S.SuddenAmbushBuff))) then
									if ((125 < 2081) and Everyone.CastTargetIf(S.Rake, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\14\199\111", "\44\99\166\23"), EvaluateTargetIfFilterRakeTicks, EvaluateTargetIfRakeAoeBuilder, not IsInMeleeRange)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\110\246\34\51\115\165\115\242\22\52\38\173\112\243\44\36\115\245\44", "\196\28\151\73\86\83");
									end
								end
								if S[LUAOBFUSACTOR_DECRYPT_STR_0("\193\2\34\21", "\22\147\99\73\112\226\56\120")]:IsReady() then
									if (Everyone.CastCycle(S.Rake, EnemiesMelee, EvaluateCycleRakeAoeBuilder, not IsInMeleeRange, nil, nil, M.RakeMouseover) or (1869 == 4900)) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\170\116\233\240\205\185\122\231\202\143\173\124\238\241\136\170\53\179\167", "\237\216\21\130\149");
									end
								end
								FlatIdent_1348A = 1;
							end
							if ((FlatIdent_1348A == 1) or (1777 >= 3312)) then
								local FlatIdent_C761 = 0;
								while true do
									if ((FlatIdent_C761 == 0) or (1170 > 1897)) then
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\182\70\77\94\163\193", "\62\226\46\63\63\208\169")]:IsReady() and (Target:DebuffRefreshable(S.ThrashDebuff))) then
											if ((888 >= 752) and Press(S.Thrash, not IsInAoERange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\241\17\71\130\12\5\111\95\234\28\106\129\10\4\35\90\224\11\21\210\75", "\62\133\121\53\227\127\109\79");
											end
										end
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\50\6\39\225\215\162\145\28\21\33\253", "\194\112\116\82\149\182\206")]:IsReady() or (3089 > 4023)) then
											if Press(S.BrutalSlash, not IsInAoERange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\59\186\89\12\193\238\49\42\164\77\11\200\162\15\54\173\115\26\213\235\2\61\173\94\88\145\180", "\110\89\200\44\120\160\130");
											end
										end
										FlatIdent_C761 = 3 - 2;
									end
									if ((FlatIdent_C761 == 1) or (4850 == 1446)) then
										FlatIdent_1348A = 2;
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
	local function Finisher()
		local FlatIdent_63089 = 0 - 0;
		local FlatIdent_5E7E6;
		while true do
			if ((0 == FlatIdent_63089) or (3104 == 1021)) then
				FlatIdent_5E7E6 = 0;
				while true do
					if ((1584 < 4428) and (1 == FlatIdent_5E7E6)) then
						if ((1324 < 1928) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\9\23\64\65\244\142\4\58\1\112\71\227\130", "\107\79\114\50\46\151\231")]:IsReady() and Player:BuffDown(S.ApexPredatorsCravingBuff) and (Player:BuffDown(BsInc) or (Player:BuffUp(BsInc) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\10\169\160\37\133\63\163\200\60\128\186\59\143\42\163", "\160\89\198\213\73\234\89\215")]:IsAvailable()))) then
							if ((4629 == 4629) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\124\120\179\251\215\91\87\161\236\220", "\165\40\17\212\158")]:IsReady() and Player:BuffDown(S.ApexPredatorsCravingBuff)) then
								if ((2911 < 3901) and CastPooling(S.FerociousBite, Player:EnergyTimeToX(50))) then
									return LUAOBFUSACTOR_DECRYPT_STR_0("\227\220\26\60\37\236\214\29\32\25\231\208\28\54\102\227\208\6\58\53\237\220\26\115\112", "\70\133\185\104\83");
								end
							elseif (Player:Energy() < 50) then
							elseif ((379 < 1357) and Everyone.CastTargetIf(S.FerociousBite, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\9\68\92", "\169\100\37\36\74"), EvaluateTargetIfFilterTTD, nil, not IsInMeleeRange)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\6\130\176\95\3\142\173\69\19\184\160\89\20\130\226\86\9\137\171\67\8\130\176\16\88", "\48\96\231\194");
							end
						end
						if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\238\95\28\34\26\209\160\150\219\120\7\57\28", "\227\168\58\110\77\121\184\207")]:IsReady() and ((Player:BuffUp(BsInc) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\72\51\170\76\190\221\101\173\126\26\176\82\180\200\101", "\197\27\92\223\32\209\187\17")]:IsAvailable()) or Player:BuffUp(S.ApexPredatorsCravingBuff))) or (1393 <= 362)) then
							if Everyone.CastTargetIf(S.FerociousBite, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\14\94\219", "\155\99\63\163"), EvaluateTargetIfFilterTTD, nil, not IsInMeleeRange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\132\212\179\130\186\141\141\196\178\178\187\141\150\212\225\139\176\138\139\194\169\136\171\196\211\129", "\228\226\177\193\237\217");
							end
						end
						break;
					end
					if ((1460 == 1460) and (FlatIdent_5E7E6 == 0)) then
						local FlatIdent_3B073 = 0 + 0;
						local FlatIdent_47E7C;
						while true do
							if (FlatIdent_3B073 == 0) then
								FlatIdent_47E7C = 0 - 0;
								while true do
									if ((FlatIdent_47E7C == 1) or (3516 <= 1360)) then
										FlatIdent_5E7E6 = 1 + 0;
										break;
									end
									if ((FlatIdent_47E7C == 0) or (1890 <= 123)) then
										if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\182\111\36\26\217\192\229\148\124\57\31", "\178\230\29\77\119\184\172")]:IsCastable() and (Target:DebuffRefreshable(S.PrimalWrath) or S[LUAOBFUSACTOR_DECRYPT_STR_0("\193\187\11\9\88\232\240\176\61\20\98\246\241\173", "\152\149\222\106\123\23")]:IsAvailable() or ((EnemiesCount11y > 4) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\239\39\251\83\180\211\50\208\70\167\210\37\255\87\172", "\213\189\70\150\35")]:IsAvailable())) and (EnemiesCount11y > 1) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\127\71\125\5\78\89\67\26\78\65\124", "\104\47\53\20")]:IsAvailable()) or (1683 >= 3073)) then
											if (CastPooling(S.PrimalWrath, Player:EnergyTimeToX(20)) or (1922 >= 2669)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\179\94\136\17\189\3\156\91\147\29\168\7\227\74\136\18\181\28\171\73\147\92\238", "\111\195\44\225\124\220");
											end
										end
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\234\79\16", "\203\184\38\96\19\203")]:IsReady() or (130 == 3280)) then
											if (Everyone.CastCycle(S.Rip, EnemiesMelee, EvaluateCycleRip, not Target:IsInRange(8), nil, nil, M.RipMouseover) or (4930 <= 4189)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\43\122\105\1\200\48\125\112\82\198\60\97\57\21", "\174\89\19\25\33");
											end
										end
										FlatIdent_47E7C = 1;
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
	end
	local function Berserk()
		local FlatIdent_39C0F = 0;
		local FlatIdent_184D7;
		while true do
			if (FlatIdent_39C0F == 0) then
				FlatIdent_184D7 = 0;
				while true do
					if (0 == FlatIdent_184D7) then
						local FlatIdent_3D86B = 0;
						local FlatIdent_8689;
						while true do
							if (FlatIdent_3D86B == 0) then
								FlatIdent_8689 = 0;
								while true do
									if (FlatIdent_8689 == 1) then
										local FlatIdent_98961 = 0;
										while true do
											if (FlatIdent_98961 == (89 - (40 + 49))) then
												if (EnemiesCount11y > 1) then
													local FlatIdent_6C5C6 = 0 - 0;
													local FlatIdent_50079;
													local FlatIdent_6118E;
													local ShouldReturn;
													while true do
														if ((1167 < 1489) and (FlatIdent_6C5C6 == (490 - (99 + 391)))) then
															FlatIdent_50079 = 0 + 0;
															FlatIdent_6118E = nil;
															FlatIdent_6C5C6 = 4 - 3;
														end
														if (FlatIdent_6C5C6 == 1) then
															ShouldReturn = nil;
															while true do
																if (FlatIdent_50079 == 0) then
																	local FlatIdent_597D1 = 0 - 0;
																	while true do
																		if (FlatIdent_597D1 == 0) then
																			FlatIdent_6118E = 0 + 0;
																			ShouldReturn = nil;
																			FlatIdent_597D1 = 1;
																		end
																		if (FlatIdent_597D1 == 1) then
																			FlatIdent_50079 = 2 - 1;
																			break;
																		end
																	end
																end
																if ((4056 >= 670) and (FlatIdent_50079 == 1)) then
																	while true do
																		if (FlatIdent_6118E == 0) then
																			local FlatIdent_90192 = 0;
																			while true do
																				if ((329 < 462) and (FlatIdent_90192 == 0)) then
																					local FlatIdent_3E335 = 1604 - (1032 + 572);
																					while true do
																						if (FlatIdent_3E335 == 1) then
																							FlatIdent_90192 = 418 - (203 + 214);
																							break;
																						end
																						if ((3283 > 1085) and (FlatIdent_3E335 == 0)) then
																							ShouldReturn = AoeBuilder();
																							if ShouldReturn then
																								return ShouldReturn;
																							end
																							FlatIdent_3E335 = 1;
																						end
																					end
																				end
																				if ((FlatIdent_90192 == 1) or (759 > 4120)) then
																					FlatIdent_6118E = 1;
																					break;
																				end
																			end
																		end
																		if ((202 < 3063) and (FlatIdent_6118E == 1)) then
																			if (Press(S.Pool) or (1603 > 4604)) then
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
													end
												end
												if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\244\61\46\51\3", "\111\164\79\65\68")]:IsReady() and not (BTBuffUp(S.Rake) and (CountActiveBtTriggers() == 2)) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\244\216\136\219", "\138\166\185\227\190\78")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (Target:DebuffRefreshable(S.RakeDebuff) or (Target:PMultiplier(S.Rake) < 1.4)) and Player:BuffDown(S.Shadowmeld)) or (2592 <= 1594)) then
													if Press(S.Prowl) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\219\102\202\32\94\99\27\206\102\214\50\64\40\89\159", "\121\171\20\165\87\50\67");
													end
												end
												FlatIdent_98961 = 1;
											end
											if (FlatIdent_98961 == 1) then
												FlatIdent_8689 = 1819 - (568 + 1249);
												break;
											end
										end
									end
									if (FlatIdent_8689 == (0 + 0)) then
										local FlatIdent_6E8CF = 0;
										while true do
											if (FlatIdent_6E8CF == 1) then
												FlatIdent_8689 = 1;
												break;
											end
											if (FlatIdent_6E8CF == 0) then
												if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\18\181\49\233\55\185\44\243\39\146\42\242\49", "\134\84\208\67")]:IsReady() and (ComboPoints == 5) and VarZerkBiteweave and (EnemiesCount11y > (2 - 1))) or (2195 >= 4996)) then
													if Everyone.CastTargetIf(S.FerociousBite, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\30\173\158", "\60\115\204\230"), EvaluateTargetIfFilterTTD, EvaluateTargetIfFerociousBiteBerserk, not IsInMeleeRange) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\225\63\249\127\228\51\228\101\244\5\233\121\243\63\171\114\226\40\248\117\245\49\171\34", "\16\135\90\139");
													end
												end
												if ((ComboPoints == 5) and not ((Player:BuffStack(S.OverflowingPowerBuff) <= 1) and (CountActiveBtTriggers() == 2) and (Player:BuffStack(S.BloodtalonsBuff) <= 1) and Player:HasTier(30, 4))) then
													local FlatIdent_4A836 = 0 - 0;
													local FlatIdent_45F7F;
													local ShouldReturn;
													while true do
														if (FlatIdent_4A836 == 1) then
															while true do
																if ((FlatIdent_45F7F == (1306 - (913 + 393))) or (930 <= 810)) then
																	ShouldReturn = Finisher();
																	if ShouldReturn then
																		return ShouldReturn;
																	end
																	break;
																end
															end
															break;
														end
														if ((FlatIdent_4A836 == 0) or (4794 < 2698)) then
															FlatIdent_45F7F = 0;
															ShouldReturn = nil;
															FlatIdent_4A836 = 1;
														end
													end
												end
												FlatIdent_6E8CF = 1;
											end
										end
									end
									if (((5 - 3) == FlatIdent_8689) or (555 <= 551)) then
										FlatIdent_184D7 = 1;
										break;
									end
								end
								break;
							end
						end
					end
					if (FlatIdent_184D7 == (3 - 0)) then
						if ((261 < 3869) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\56\143\182\65\15", "\36\107\231\196")]:IsReady()) then
							if (Press(S.Shred, not IsInMeleeRange) or (334 > 3050)) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\78\189\176\130\89\245\160\130\79\166\167\149\86\245\240\213", "\231\61\213\194");
							end
						end
						break;
					end
					if ((3653 <= 4807) and (FlatIdent_184D7 == (411 - (269 + 141)))) then
						local FlatIdent_4572F = 0;
						while true do
							if (FlatIdent_4572F == (0 - 0)) then
								local FlatIdent_5CAFD = 0;
								while true do
									if ((3366 <= 3623) and (FlatIdent_5CAFD == (1982 - (362 + 1619)))) then
										FlatIdent_4572F = 1;
										break;
									end
									if ((FlatIdent_5CAFD == 0) or (4624 == 1921)) then
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\245\48\184\50\182\21\203\61\181\50", "\98\166\88\217\86\217")]:IsCastable() and not (BTBuffUp(S.Rake) and (CountActiveBtTriggers() == 2)) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\196\247\114\4", "\188\150\150\25\97\230")]:IsReady() and Player:BuffDown(S.SuddenAmbushBuff) and (Target:DebuffRefreshable(S.RakeDebuff) or (Target:PMultiplier(S.Rake) < (1626.4 - (950 + 675)))) and Player:BuffDown(S.Prowl)) then
											if (Press(S.Shadowmeld) or (2088 < 2014)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\201\129\94\6\3\250\215\140\83\6\76\239\223\155\76\7\30\230\154\223", "\141\186\233\63\98\108");
											end
										end
										if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\195\235\39\179", "\69\145\138\76\214")]:IsReady() and not (BTBuffUp(S.Rake) and (CountActiveBtTriggers() == 2)) and ((Target:DebuffRemains(S.RakeDebuff) < 3) or (Player:BuffUp(S.SuddenAmbushBuff) and (Player:PMultiplier(S.Rake) > Target:PMultiplier(S.Rake))))) or (3297 > 4690)) then
											if Press(S.Rake, not IsInMeleeRange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\98\206\130\140\255\20\117\221\154\140\173\29\48\151", "\118\16\175\233\233\223");
											end
										end
										FlatIdent_5CAFD = 1;
									end
								end
							end
							if (FlatIdent_4572F == 2) then
								FlatIdent_184D7 = 1 + 1;
								break;
							end
							if (FlatIdent_4572F == 1) then
								local FlatIdent_7C526 = 0;
								while true do
									if ((392 <= 3292) and (FlatIdent_7C526 == 0)) then
										if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\184\140\39\190\234", "\29\235\228\85\219\142\235")]:IsReady() and (CountActiveBtTriggers() == (1181 - (216 + 963))) and BTBuffDown(S.Shred)) or (119 >= 4531)) then
											if (Press(S.Shred, not IsInMeleeRange) or (2475 > 3863)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\46\220\168\216\115\14\37\87\47\199\191\207\124\14\118\2", "\50\93\180\218\189\23\46\71");
											end
										end
										if ((2189 >= 1725) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\252\182\78\88\69\208\123\210\165\72\68", "\40\190\196\59\44\36\188")]:IsReady() and (CountActiveBtTriggers() == 2) and BTBuffDown(S.BrutalSlash)) then
											if ((1717 < 3405) and Press(S.BrutalSlash, not IsInAoERange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\62\87\201\160\251\113\50\47\73\221\167\242\61\15\57\87\207\177\232\118\77\109\23", "\109\92\37\188\212\154\29");
											end
										end
										FlatIdent_7C526 = 1288 - (485 + 802);
									end
									if (1 == FlatIdent_7C526) then
										FlatIdent_4572F = 2;
										break;
									end
								end
							end
						end
					end
					if ((FlatIdent_184D7 == 2) or (118 == 1880)) then
						local FlatIdent_142F9 = 0;
						local FlatIdent_7D9F6;
						while true do
							if ((3232 > 1090) and (FlatIdent_142F9 == 0)) then
								FlatIdent_7D9F6 = 0;
								while true do
									if (FlatIdent_7D9F6 == 0) then
										if ((3225 > 1844) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\40\198\137\204\62\84\2\230\182\198", "\58\100\143\196\163\81")]:IsReady() and (CountActiveBtTriggers() == 2) and BTBuffDown(S.LIMoonfire)) then
											if Press(S.LIMoonfire, not Target:IsSpellInRange(S.LIMoonfire)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\23\77\44\173\57\64\247\11\37\65\34\183\127\75\224\28\9\71\49\168\127\24\177", "\110\122\34\67\195\95\41\133");
											end
										end
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\65\185\73\75\197\125", "\182\21\209\59\42")]:IsReady() and (CountActiveBtTriggers() == (561 - (432 + 127))) and BTBuffDown(S.Thrash) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\131\95\215\28\50\182\190\89\194\62\45\191\160\68", "\222\215\55\165\125\65")]:IsAvailable() and VarNeedBT) then
											if (Press(S.Thrash, not IsInAoERange) or (2722 >= 4773)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\56\217\212\27\225\201\173\72\41\195\213\31\224\202\173\27\122", "\42\76\177\166\122\146\161\141");
											end
										end
										FlatIdent_7D9F6 = 1;
									end
									if ((1751 > 383) and (FlatIdent_7D9F6 == 2)) then
										FlatIdent_184D7 = 1076 - (1065 + 8);
										break;
									end
									if (1 == FlatIdent_7D9F6) then
										if S[LUAOBFUSACTOR_DECRYPT_STR_0("\137\163\40\193\118\120\163\131\23\203", "\22\197\234\101\174\25")]:IsReady() then
											if Everyone.CastCycle(S.LIMoonfire, Enemies11y, EvaluateCycleLIMoonfire, not Target:IsSpellInRange(S.LIMoonfire), nil, nil, M.MoonfireMouseover) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\32\59\170\210\112\166\197\131\18\55\164\200\54\173\210\148\62\49\183\215\54\254\143", "\230\77\84\197\188\22\207\183");
											end
										end
										if ((1264 < 4227) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\219\6\211\232\141\173\195\57\248\7\206", "\85\153\116\166\156\236\193\144")]:IsReady() and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\134\242\88\167\229\12\151\236\76\160\236", "\96\196\128\45\211\132")]:Charges() > 1) and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\17\132\105\90\244\166\172\217\33\132\116\81", "\184\85\237\27\63\178\207\212")]:IsAvailable() or Target:DebuffUp(S.DireFixationDebuff))) then
											if ((964 == 964) and Press(S.BrutalSlash, not IsInAoERange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\10\75\28\75\9\85\54\76\4\88\26\87\72\91\12\77\27\92\27\84\72\11\89", "\63\104\57\105");
											end
										end
										FlatIdent_7D9F6 = 2 + 0;
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
	end
	local function Cooldown()
		local FlatIdent_63C9 = 1601 - (635 + 966);
		local FlatIdent_25B3C;
		local HighTTD;
		local _;
		while true do
			if (FlatIdent_63C9 == 0) then
				FlatIdent_25B3C = 0;
				HighTTD = nil;
				FlatIdent_63C9 = 1;
			end
			if (((1 + 0) == FlatIdent_63C9) or (4597 == 2726)) then
				_ = nil;
				while true do
					if (0 == FlatIdent_25B3C) then
						local FlatIdent_6AC46 = 0;
						local FlatIdent_8CBF0;
						while true do
							if ((FlatIdent_6AC46 == 0) or (4308 == 4623)) then
								FlatIdent_8CBF0 = 0;
								while true do
									if (FlatIdent_8CBF0 == 0) then
										HighTTD, _ = HighestTTD(Enemies11y);
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\32\163\62\114\27\163\60\103\0\162\51", "\19\105\205\93")]:IsReady() and CDs and (((HighTTD < FightRemains) and (HighTTD > 25)) or (HighTTD == FightRemains))) then
											if ((2249 > 546) and Press(S.Incarnation, not IsInMeleeRange)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\160\6\221\128\45\167\9\202\136\48\167\72\221\142\48\165\12\209\150\49\233\94", "\95\201\104\190\225");
											end
										end
										FlatIdent_8CBF0 = 1;
									end
									if ((43 - (5 + 37)) == FlatIdent_8CBF0) then
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\141\206\211\221\170\217\202", "\174\207\171\161")]:IsReady() and CDs and ((FightRemains < 25) or (S[LUAOBFUSACTOR_DECRYPT_STR_0("\206\241\3\229\247\220\232\202\5\246\203\199\228\236\4\231\235", "\183\141\158\109\147\152")]:IsAvailable() and ((FightRemains < S[LUAOBFUSACTOR_DECRYPT_STR_0("\15\6\232\26\35\2\227\56\36\12\213\28\37\27\239\24\63", "\108\76\105\134")]:CooldownRemains()) or (VarAlignCDs and ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\205\192\163\224\194\205\215\180\239\212\242", "\174\139\165\209\129")]:IsReady() and ((ComboPoints < 3) or ((EL.CombatTime() < 10) and (ComboPoints < (9 - 5))))) or ((EL.CombatTime() < 10) and (ComboPoints < 4))) and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\128\188\236\215\201\8\117\76\171\182\209\209\207\17\121\108\176", "\24\195\211\130\161\166\99\16")]:CooldownRemains() < 10)))))) then
											if Press(S.Berserk, not IsInMeleeRange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\68\6\251\63\86\4\77\67\234\35\92\26\66\12\254\34\19\78", "\118\38\99\137\76\51");
											end
										end
										FlatIdent_25B3C = 1;
										break;
									end
								end
								break;
							end
						end
					end
					if ((2704 <= 3641) and (FlatIdent_25B3C == 4)) then
						if ((CDs and I[LUAOBFUSACTOR_DECRYPT_STR_0("\216\93\252\71\70\111\242", "\26\156\55\157\53\51")]:IsEquippedAndReady()) or (4277 <= 1396)) then
							if Press(M.Djaruun, not IsInMeleeRange) then
								return LUAOBFUSACTOR_DECRYPT_STR_0("\136\210\23\203\173\69\130\231\6\208\180\92\141\202\41\214\190\111\152\208\19\230\189\92\136\221\4\230\190\92\141\213\19\153\181\81\133\214\86\141", "\48\236\184\118\185\216");
							end
						end
						break;
					end
					if (FlatIdent_25B3C == (1 + 1)) then
						local FlatIdent_306DA = 0;
						local FlatIdent_1DD07;
						while true do
							if (0 == FlatIdent_306DA) then
								FlatIdent_1DD07 = 0;
								while true do
									if (FlatIdent_1DD07 == (1 - 0)) then
										ShouldReturn = Everyone.HandleTopTrinket(OnUseExcludes, CDs and (Player:BuffUp(S.HeartOfTheWild) or Player:BuffUp(S.Incarnation) or Player:BloodlustUp()), 40, nil);
										FlatIdent_25B3C = 3;
										break;
									end
									if (FlatIdent_1DD07 == 0) then
										local FlatIdent_6621E = 0;
										while true do
											if ((FlatIdent_6621E == (0 + 0)) or (4180 <= 366)) then
												if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\15\118\234\78\35\114\225\108\36\124\215\72\37\107\237\76\63", "\56\76\25\132")]:IsReady() and CDs) or (149 >= 4486)) then
													if ((646 < 1037) and Press(S.ConvokeTheSpirits, not IsInMeleeRange)) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\93\206\165\48\192\85\196\148\50\199\91\254\184\54\198\76\200\191\53\143\93\206\164\42\203\81\214\165\102\158\8", "\175\62\161\203\70");
													end
												end
												if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\31\210\205\5\58\55\216\247\27\48\15\205\202\1\60\40\206", "\85\92\189\163\115")]:IsReady() and CDs and Player:BuffUp(S.SmolderingFrenzyBuff) and (Player:BuffRemains(S.SmolderingFrenzyBuff) < (5.1 - num(S[LUAOBFUSACTOR_DECRYPT_STR_0("\8\191\56\57\36\173\62\61\58\139\37\49\45\173\62\59\44", "\88\73\204\80")]:IsAvailable())))) then
													if Press(S.ConvokeTheSpirits, not IsInMeleeRange) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\45\140\30\80\38\209\43\188\4\78\44\229\61\147\25\84\32\206\61\195\19\73\38\214\42\140\7\72\105\136\120", "\186\78\227\112\38\73");
													end
												end
												FlatIdent_6621E = 1;
											end
											if ((3598 <= 3738) and (1 == FlatIdent_6621E)) then
												FlatIdent_1DD07 = 1;
												break;
											end
										end
									end
								end
								break;
							end
						end
					end
					if ((FlatIdent_25B3C == 3) or (823 >= 915)) then
						local FlatIdent_66B5D = 0;
						while true do
							if ((FlatIdent_66B5D == (0 - 0)) or (4962 <= 4365)) then
								if (ShouldReturn or (643 >= 1489)) then
									return ShouldReturn;
								end
								ShouldReturn = Everyone.HandleBottomTrinket(OnUseExcludes, CDs and (Player:BuffUp(S.HeartOfTheWild) or Player:BuffUp(S.Incarnation) or Player:BloodlustUp()), 151 - 111, nil);
								FlatIdent_66B5D = 1;
							end
							if ((FlatIdent_66B5D == 1) or (475 == 4175)) then
								if ShouldReturn then
									return ShouldReturn;
								end
								FlatIdent_25B3C = 4;
								break;
							end
						end
					end
					if ((1 == FlatIdent_25B3C) or (2786 < 121)) then
						local FlatIdent_13ED5 = 0;
						while true do
							if ((1896 <= 2815) and (FlatIdent_13ED5 == 0)) then
								local FlatIdent_1BEAA = 0;
								while true do
									if (FlatIdent_1BEAA == 0) then
										if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\223\35\23\1\12\50\246", "\64\157\70\101\114\105")]:IsReady() and CDs and not VarAlignCDs and not (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\102\186\166\237\4\73\171\138\236\29\69\166\179\246\29", "\112\32\200\199\131")]:IsAvailable() and I[LUAOBFUSACTOR_DECRYPT_STR_0("\27\89\72\176\198\185\32\45\66\87\171\225\185\35\34\83\84", "\66\76\48\60\216\163\203")]:IsEquipped() and (EnemiesCount11y == 1)) and (not VarLastZerk or (VarLastZerk and not VarLastConvoke) or (VarLastConvoke and (S[LUAOBFUSACTOR_DECRYPT_STR_0("\153\137\119\229\80\197\33\142\142\124\192\79\199\54\179\146\106", "\68\218\230\25\147\63\174")]:CooldownRemains() < 10) and (not Player:HasTier(31, 2) or (Player:HasTier(31, 2) and Player:BuffUp(S.SmolderingFrenzyBuff))))) and (((Target:TimeToDie() < FightRemains) and (Target:TimeToDie() > 18)) or (Target:TimeToDie() == FightRemains))) then
											if (Press(S.Berserk, not IsInMeleeRange) or (2058 == 2348)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\175\47\65\95\179\191\33\19\79\185\162\38\87\67\161\163\106\2\28", "\214\205\74\51\44");
											end
										end
										if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\216\73\240\239\114\232\71", "\23\154\44\130\156")]:IsReady() and ((FightRemains < (43 - 20)) or ((((obf_AND(EL.CombatTime(), 118) + obf_OR(EL.CombatTime(), 118)) % 120) < 30) and not S[LUAOBFUSACTOR_DECRYPT_STR_0("\55\180\172\160\34\26\18\139\162\163\51\29\5\179\160", "\115\113\198\205\206\86")]:IsAvailable() and (I[LUAOBFUSACTOR_DECRYPT_STR_0("\179\94\234\82\129\69\252\91\150\92\237\120\150\86\240\89\140", "\58\228\55\158")]:IsEquipped() or I[LUAOBFUSACTOR_DECRYPT_STR_0("\149\154\216\43\47\162\51\160\129\213\11\49\175\48\166\154\223\59\48", "\85\212\233\176\78\92\205")]:IsEquipped()) and (EnemiesCount11y == (2 - 1))))) or (3529 <= 1759)) then
											if Press(S.Berserk, not IsInMeleeRange) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\72\93\154\241\79\74\131\162\73\87\135\238\78\87\159\236\10\9\218", "\130\42\56\232");
											end
										end
										FlatIdent_1BEAA = 1;
									end
									if (FlatIdent_1BEAA == 1) then
										FlatIdent_13ED5 = 1;
										break;
									end
								end
							end
							if ((FlatIdent_13ED5 == 1) or (358 == 1881)) then
								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\200\176\54\240\69\45\225\188\42\228", "\95\138\213\68\131\32")]:IsCastable() and CDs and (not VarAlign3Mins or Player:BuffUp(BsInc))) then
									if Press(S.Berserking, not IsInMeleeRange) then
										return LUAOBFUSACTOR_DECRYPT_STR_0("\40\45\179\80\115\56\35\168\77\113\106\43\174\76\122\46\39\182\77\54\123\122", "\22\74\72\193\35");
									end
								end
								FlatIdent_25B3C = 2;
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	local function FetchSettings()
		local FlatIdent_5A310 = 0;
		local FlatIdent_992C4;
		local FlatIdent_488FB;
		while true do
			if ((FlatIdent_5A310 == 1) or (2003 == 2771)) then
				while true do
					if ((FlatIdent_992C4 == (0 + 0)) or (2599 < 2368)) then
						FlatIdent_488FB = 0;
						while true do
							if ((2757 >= 2090) and (FlatIdent_488FB == 6)) then
								RegrowthHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\252\18\171\86\113\254\105", "\26\48\153\102\223\63\31\153")][LUAOBFUSACTOR_DECRYPT_STR_0("\48\69\234\225\13\87\249\251\42\112", "\147\98\32\141")] or (529 - (318 + 211));
								break;
							end
							if (FlatIdent_488FB == (19 - 15)) then
								local FlatIdent_7A47F = 0;
								while true do
									if ((726 < 1551) and (1 == FlatIdent_7A47F)) then
										local FlatIdent_2DE5D = 1587 - (963 + 624);
										while true do
											if (FlatIdent_2DE5D == (1 + 0)) then
												FlatIdent_7A47F = 848 - (518 + 328);
												break;
											end
											if ((2388 >= 1946) and (FlatIdent_2DE5D == 0)) then
												UseRenewal = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\227\135\173\231\10\237\211\195", "\180\176\226\217\147\99\131")][LUAOBFUSACTOR_DECRYPT_STR_0("\230\170\42\53\214\183\42\16\210\181", "\103\179\217\79")];
												RenewalHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\121\178\8\193\72\130\164\89", "\195\42\215\124\181\33\236")][LUAOBFUSACTOR_DECRYPT_STR_0("\63\92\57\59\50\249\1\113\7", "\152\109\57\87\94\69")] or 0;
												FlatIdent_2DE5D = 1;
											end
										end
									end
									if (FlatIdent_7A47F == 0) then
										UseNaturesVigil = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\140\51\41\151\185\250\228\172", "\131\223\86\93\227\208\148")][LUAOBFUSACTOR_DECRYPT_STR_0("\214\86\179\152\28\161\246\87\179\165\43\188\228\76\186", "\213\131\37\214\214\125")];
										NaturesVigilHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\21\46\49\171\232\40\44\54", "\129\70\75\69\223")][LUAOBFUSACTOR_DECRYPT_STR_0("\104\202\231\252\110\234\85\253\250\238\117\227\110\251", "\143\38\171\147\137\28")] or 0;
										FlatIdent_7A47F = 2 - 1;
									end
									if ((FlatIdent_7A47F == 2) or (4771 == 3240)) then
										FrenziedRegenerationHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\202\210\30\183\183\220\83\187", "\200\153\183\106\195\222\178\52")][LUAOBFUSACTOR_DECRYPT_STR_0("\20\241\141\51\83\83\55\231\186\56\78\95\60\230\154\60\93\83\61\237\160\13", "\58\82\131\232\93\41")] or 0;
										FlatIdent_488FB = 5;
										break;
									end
								end
							end
							if ((2 == FlatIdent_488FB) or (1882 <= 98)) then
								local FlatIdent_785F5 = 0;
								while true do
									if (2 == FlatIdent_785F5) then
										UseCatFormOOC = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\54\140\4\0\221\65\88\22", "\63\101\233\112\116\180\47")][LUAOBFUSACTOR_DECRYPT_STR_0("\246\40\232\49\249\34\229\52\255\31\215\25\224", "\86\163\91\141\114\152")];
										FlatIdent_488FB = 3 - 0;
										break;
									end
									if ((4298 > 4297) and ((318 - (301 + 16)) == FlatIdent_785F5)) then
										InterruptOnlyWhitelist = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\73\185\38\96\143\59\124\152", "\235\26\220\82\20\230\85\27")][LUAOBFUSACTOR_DECRYPT_STR_0("\161\175\253\199\102\154\180\249\214\91\134\173\240\245\124\129\181\236\206\125\155\181", "\20\232\193\137\162")];
										InterruptThreshold = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\17\218\209\178\238\130\16\98", "\17\66\191\165\198\135\236\119")][LUAOBFUSACTOR_DECRYPT_STR_0("\38\161\186\22\237\250\249\193\27\155\166\1\250\251\228\222\3\171", "\177\111\207\206\115\159\136\140")] or (0 - 0);
										FlatIdent_785F5 = 2;
									end
									if (FlatIdent_785F5 == 0) then
										local FlatIdent_1C2F1 = 0;
										while true do
											if (FlatIdent_1C2F1 == 0) then
												HandleIncorporeal = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\203\42\42\60\220\75\5\87", "\36\152\79\94\72\181\37\98")][LUAOBFUSACTOR_DECRYPT_STR_0("\255\217\73\59\219\221\110\49\212\215\85\47\216\202\66\62\219", "\95\183\184\39")];
												InterruptWithStun = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\134\58\243\50\93\142\5\166", "\98\213\95\135\70\52\224")][LUAOBFUSACTOR_DECRYPT_STR_0("\215\173\221\114\70\236\182\217\99\99\247\183\193\68\64\235\173", "\52\158\195\169\23")];
												FlatIdent_1C2F1 = 1;
											end
											if (FlatIdent_1C2F1 == 1) then
												FlatIdent_785F5 = 1;
												break;
											end
										end
									end
								end
							end
							if (3 == FlatIdent_488FB) then
								local FlatIdent_2841D = 0 - 0;
								local FlatIdent_3F0FC;
								while true do
									if ((2202 < 4968) and (FlatIdent_2841D == 0)) then
										FlatIdent_3F0FC = 0;
										while true do
											if (FlatIdent_3F0FC == 0) then
												UsageProwlOOC = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\96\14\96\103\51\93\12\103", "\90\51\107\20\19")][LUAOBFUSACTOR_DECRYPT_STR_0("\184\227\132\232\56\189\226\138\248\49\162\223\166", "\93\237\144\229\143")] or "";
												ProwlRange = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\38\243\228\13\2\72\18\229", "\38\117\150\144\121\107")][LUAOBFUSACTOR_DECRYPT_STR_0("\29\169\225\45\33\137\239\52\42\190", "\90\77\219\142")] or 0;
												FlatIdent_3F0FC = 2 - 1;
											end
											if ((2 + 0) == FlatIdent_3F0FC) then
												BarkskinHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\63\247\233\156\120\2\245\238", "\17\108\146\157\232")][LUAOBFUSACTOR_DECRYPT_STR_0("\105\194\6\230\60\163\66\205\60\221", "\200\43\163\116\141\79")] or 0;
												FlatIdent_488FB = 3 + 1;
												break;
											end
											if ((388 >= 167) and (FlatIdent_3F0FC == 1)) then
												UseWildCharge = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\213\1\53\45\69\9\125\245", "\26\134\100\65\89\44\103")][LUAOBFUSACTOR_DECRYPT_STR_0("\196\240\53\20\173\253\231\19\43\165\227\228\53", "\196\145\131\80\67")];
												UseBarkskin = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\45\181\18\28\17\230\25\163", "\136\126\208\102\104\120")][LUAOBFUSACTOR_DECRYPT_STR_0("\77\153\203\97\174\64\54\66\115\131\192", "\49\24\234\174\35\207\50\93")];
												FlatIdent_3F0FC = 2;
											end
										end
										break;
									end
								end
							end
							if ((1 == FlatIdent_488FB) or (655 == 3201)) then
								local FlatIdent_72393 = 0;
								while true do
									if (FlatIdent_72393 == 2) then
										HandleAfflicted = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\51\140\253\170\9\135\238\173", "\222\96\233\137")][LUAOBFUSACTOR_DECRYPT_STR_0("\145\178\169\27\132\246\209\191\181\171\22\139\231\245\189", "\144\217\211\199\127\232\147")];
										FlatIdent_488FB = 2;
										break;
									end
									if ((3611 >= 958) and (FlatIdent_72393 == 1)) then
										UseHealthstone = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\233\218\183\147\218\212\216\176", "\179\186\191\195\231")][LUAOBFUSACTOR_DECRYPT_STR_0("\204\44\29\204\252\62\20\240\241\44\12\235\247\58", "\132\153\95\120")];
										HealthstoneHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\130\183\26\57\254\212\167\162", "\192\209\210\110\77\151\186")][LUAOBFUSACTOR_DECRYPT_STR_0("\200\6\35\229\235\204\243\23\45\231\250\236\208", "\164\128\99\66\137\159")] or 0;
										FlatIdent_72393 = 2;
									end
									if ((0 - 0) == FlatIdent_72393) then
										DispelDebuffs = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\219\40\189\91\123\178\198\171", "\216\136\77\201\47\18\220\161")][LUAOBFUSACTOR_DECRYPT_STR_0("\9\229\56\202\13\208\166\40\238\62\220\14\207", "\226\77\140\75\186\104\188")];
										DispelBuffs = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\138\203\196\43\70\183\201\195", "\47\217\174\176\95")][LUAOBFUSACTOR_DECRYPT_STR_0("\156\212\101\18\183\88\90\51\190\219\101", "\70\216\189\22\98\210\52\24")];
										FlatIdent_72393 = 1;
									end
								end
							end
							if (5 == FlatIdent_488FB) then
								local FlatIdent_290E5 = 0 + 0;
								while true do
									if (FlatIdent_290E5 == 1) then
										UseSurvivalInstincts = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\11\55\7\151\49\60\20\144", "\227\88\82\115")][LUAOBFUSACTOR_DECRYPT_STR_0("\118\12\191\148\23\97\85\22\172\166\14\90\77\12\174\174\12\112\87\12", "\19\35\127\218\199\98")];
										UseRegrowth = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\47\254\30\246\21\245\13\241", "\130\124\155\106")][LUAOBFUSACTOR_DECRYPT_STR_0("\224\216\243\157\166\241\110\176\194\223\254", "\223\181\171\150\207\195\150\28")];
										FlatIdent_290E5 = 2;
									end
									if ((3619 == 3619) and (FlatIdent_290E5 == 2)) then
										UseRegrowthMouseover = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\127\63\247\186\0\66\61\240", "\105\44\90\131\206")][LUAOBFUSACTOR_DECRYPT_STR_0("\202\243\183\139\13\57\237\239\165\173\0\19\240\245\161\188\7\40\250\242", "\94\159\128\210\217\104")];
										FlatIdent_488FB = 6;
										break;
									end
									if ((3817 >= 1959) and (FlatIdent_290E5 == 0)) then
										UseFrenziedRegeneration = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\176\82\196\1\84\49\132\68", "\95\227\55\176\117\61")][LUAOBFUSACTOR_DECRYPT_STR_0("\45\109\38\109\185\29\112\57\66\174\28\76\38\76\174\22\123\49\74\191\17\113\45", "\203\120\30\67\43")];
										SurvivalInstinctsHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\194\32\89\251\208\255\34\94", "\185\145\69\45\143")][LUAOBFUSACTOR_DECRYPT_STR_0("\185\10\11\176\213\156\30\21\143\210\153\11\16\168\223\158\12\49\150", "\188\234\127\121\198")] or 0;
										FlatIdent_290E5 = 1;
									end
								end
							end
							if ((FlatIdent_488FB == (0 + 0)) or (2952 > 3799)) then
								local FlatIdent_42282 = 0;
								while true do
									if ((176 <= 1657) and (FlatIdent_42282 == 2)) then
										UseMarkOfTheWild = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\29\78\42\193\88\31\251\61", "\156\78\43\94\181\49\113")][LUAOBFUSACTOR_DECRYPT_STR_0("\71\251\193\142\10\81\114\93\238\240\171\14\116\112\126\236", "\25\18\136\164\195\107\35")];
										FlatIdent_488FB = 1;
										break;
									end
									if ((FlatIdent_42282 == 0) or (1616 >= 4086)) then
										local FlatIdent_5494A = 0;
										while true do
											if (FlatIdent_5494A == 0) then
												UseRacials = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\214\184\67\36\198\58\226\174", "\84\133\221\55\80\175")][LUAOBFUSACTOR_DECRYPT_STR_0("\136\244\33\148\198\95\180\230\40\181", "\60\221\135\68\198\167")];
												UseHealingPotion = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\221\184\236\151\75\215\233\174", "\185\142\221\152\227\34")][LUAOBFUSACTOR_DECRYPT_STR_0("\109\214\82\210\70\50\251\81\203\80\202\76\39\254\87\203", "\151\56\165\55\154\35\83")] or 0;
												FlatIdent_5494A = 3 - 2;
											end
											if (FlatIdent_5494A == 1) then
												FlatIdent_42282 = 1;
												break;
											end
										end
									end
									if (FlatIdent_42282 == 1) then
										HealingPotionName = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\147\70\17\250\169\77\2\253", "\142\192\35\101")][LUAOBFUSACTOR_DECRYPT_STR_0("\254\112\40\175\238\130\171\38\217\97\32\172\233\162\173\27\211", "\118\182\21\73\195\135\236\204")] or "";
										HealingPotionHP = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\59\57\14\84\13\3\250\27", "\157\104\92\122\32\100\109")][LUAOBFUSACTOR_DECRYPT_STR_0("\139\163\206\198\52\41\138\155\172\178\198\197\51\15\189", "\203\195\198\175\170\93\71\237")] or 0;
										FlatIdent_42282 = 1 + 1;
									end
								end
							end
						end
						break;
					end
				end
				break;
			end
			if ((2650 >= 1576) and (FlatIdent_5A310 == 0)) then
				FlatIdent_992C4 = 0;
				FlatIdent_488FB = nil;
				FlatIdent_5A310 = 1020 - (829 + 190);
			end
		end
	end
	local function APL()
		local FlatIdent_1673F = 0;
		local FlatIdent_55EB8;
		local FlatIdent_4004D;
		local AIRange;
		while true do
			if (FlatIdent_1673F == 0) then
				FlatIdent_55EB8 = 0;
				FlatIdent_4004D = nil;
				FlatIdent_1673F = 1;
			end
			if ((317 < 3696) and (FlatIdent_1673F == 1)) then
				AIRange = nil;
				while true do
					if (0 == FlatIdent_55EB8) then
						FlatIdent_4004D = 0;
						AIRange = nil;
						FlatIdent_55EB8 = 1;
					end
					if (FlatIdent_55EB8 == 1) then
						while true do
							if ((3384 == 3384) and (FlatIdent_4004D == 3)) then
								local FlatIdent_25F6B = 0;
								local FlatIdent_8AD22;
								while true do
									if (0 == FlatIdent_25F6B) then
										FlatIdent_8AD22 = 0 - 0;
										while true do
											if (2 == FlatIdent_8AD22) then
												FlatIdent_4004D = 4;
												break;
											end
											if ((FlatIdent_8AD22 == 0) or (3727 < 2142)) then
												ComboPointsDeficit = Player:ComboPointsDeficit();
												IsInMeleeRange = Target:IsInRange(MeleeRange);
												FlatIdent_8AD22 = 1;
											end
											if ((1680 < 2583) and (FlatIdent_8AD22 == (1 - 0))) then
												local FlatIdent_6ED81 = 0 - 0;
												while true do
													if (FlatIdent_6ED81 == 0) then
														IsInAoERange = Target:IsInRange(AoERange);
														if (Everyone.TargetIsValid() or Player:AffectingCombat()) then
															local FlatIdent_EDE5 = 0;
															local FlatIdent_4D69;
															while true do
																if ((2012 < 2160) and (FlatIdent_EDE5 == 0)) then
																	FlatIdent_4D69 = 0;
																	while true do
																		if ((FlatIdent_4D69 == 1) or (2342 == 3691)) then
																			if ((FightRemains == 11111) or (4786 <= 238)) then
																				FightRemains = EL.FightRemains(Enemies11y, false);
																			end
																			break;
																		end
																		if ((3450 <= 4563) and (0 == FlatIdent_4D69)) then
																			local FlatIdent_970B = 0;
																			while true do
																				if (FlatIdent_970B == (0 - 0)) then
																					BossFightRemains = EL.BossFightRemains(nil, true);
																					FightRemains = BossFightRemains;
																					FlatIdent_970B = 1;
																				end
																				if (FlatIdent_970B == 1) then
																					FlatIdent_4D69 = 1;
																					break;
																				end
																			end
																		end
																	end
																	break;
																end
															end
														end
														FlatIdent_6ED81 = 1;
													end
													if ((262 <= 3156) and (FlatIdent_6ED81 == (1 + 0))) then
														FlatIdent_8AD22 = 2;
														break;
													end
												end
											end
										end
										break;
									end
								end
							end
							if ((2384 < 4082) and (FlatIdent_4004D == 0)) then
								local FlatIdent_95124 = 0;
								local FlatIdent_72448;
								while true do
									if ((FlatIdent_95124 == 0) or (3857 < 2167)) then
										FlatIdent_72448 = 0;
										while true do
											if (FlatIdent_72448 == 1) then
												local FlatIdent_105CE = 0;
												while true do
													if (FlatIdent_105CE == 1) then
														FlatIdent_72448 = 2;
														break;
													end
													if ((FlatIdent_105CE == (0 + 0)) or (4438 == 1930)) then
														AOE = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\42\239\114\205\230\142\10", "\182\126\128\21\170\138\235\121")][LUAOBFUSACTOR_DECRYPT_STR_0("\138\213\48", "\102\235\186\85\134\230\115\80")];
														CDs = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\99\3\57\88\126\209\49", "\66\55\108\94\63\18\180")][LUAOBFUSACTOR_DECRYPT_STR_0("\23\137\150", "\57\116\237\229\87\71")];
														FlatIdent_105CE = 2 - 1;
													end
												end
											end
											if (FlatIdent_72448 == (0 + 0)) then
												FetchSettings();
												OOC = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\44\76\228\205\10\83\88", "\43\120\35\131\170\102\54")][LUAOBFUSACTOR_DECRYPT_STR_0("\91\9\132", "\228\52\102\231\214\197\208")];
												FlatIdent_72448 = 614 - (520 + 93);
											end
											if ((2 == FlatIdent_72448) or (844 < 284)) then
												FlatIdent_4004D = 1;
												break;
											end
										end
										break;
									end
								end
							end
							if (FlatIdent_4004D == 2) then
								local FlatIdent_5CB67 = 0;
								while true do
									if (FlatIdent_5CB67 == 0) then
										MeleeRange = obf_AND(5, AIRange) + obf_OR(5, AIRange);
										AoERange = obf_AND(8, AIRange) + obf_OR(8, AIRange);
										FlatIdent_5CB67 = 1;
									end
									if ((1111 <= 1244) and (FlatIdent_5CB67 == 1)) then
										if (AOE or (3970 <= 2329)) then
											local FlatIdent_1676F = 276 - (259 + 17);
											while true do
												if (FlatIdent_1676F == 0) then
													local FlatIdent_6F58A = 0;
													while true do
														if ((1189 < 3021) and (FlatIdent_6F58A == 0)) then
															EnemiesMelee = Player:GetEnemiesInMeleeRange(MeleeRange);
															Enemies11y = Player:GetEnemiesInMeleeRange(AoERange);
															FlatIdent_6F58A = 1;
														end
														if ((4168 > 3631) and (1 == FlatIdent_6F58A)) then
															FlatIdent_1676F = 1;
															break;
														end
													end
												end
												if (FlatIdent_1676F == 1) then
													EnemiesCountMelee = #EnemiesMelee;
													EnemiesCount11y = #Enemies11y;
													break;
												end
											end
										else
											local FlatIdent_3BBE8 = 0;
											local FlatIdent_6B148;
											while true do
												if ((2916 <= 4027) and (FlatIdent_3BBE8 == 0)) then
													FlatIdent_6B148 = 0 + 0;
													while true do
														if ((1572 <= 4075) and (FlatIdent_6B148 == 1)) then
															EnemiesCountMelee = 1;
															EnemiesCount11y = 1;
															break;
														end
														if (((0 + 0) == FlatIdent_6B148) or (1810 > 4864)) then
															EnemiesMelee = {};
															Enemies11y = {};
															FlatIdent_6B148 = 1;
														end
													end
													break;
												end
											end
										end
										ComboPoints = Player:ComboPoints();
										FlatIdent_5CB67 = 2;
									end
									if ((6 - 4) == FlatIdent_5CB67) then
										FlatIdent_4004D = 594 - (396 + 195);
										break;
									end
								end
							end
							if ((1529 < 4520) and (5 == FlatIdent_4004D)) then
								if (Everyone.TargetIsValid() and Target:IsInRange(11)) then
									local FlatIdent_297C4 = 0;
									while true do
										if ((FlatIdent_297C4 == 1) or (1980 == 1409)) then
											if ((2065 == 2065) and Press(S.Pool)) then
												return LUAOBFUSACTOR_DECRYPT_STR_0("\111\39\161\8\22\122\38\171\22\81\70", "\54\63\72\206\100");
											end
											break;
										end
										if ((FlatIdent_297C4 == (0 - 0)) or (1672 >= 4584)) then
											if (not Player:AffectingCombat() and OOC) then
												local FlatIdent_8EC6E = 0;
												local FlatIdent_30264;
												local ShouldReturn;
												while true do
													if (FlatIdent_8EC6E == 1) then
														while true do
															if (FlatIdent_30264 == (1761 - (440 + 1321))) then
																ShouldReturn = Precombat();
																if (ShouldReturn or (1261 < 1055)) then
																	return ShouldReturn;
																end
																break;
															end
														end
														break;
													end
													if ((FlatIdent_8EC6E == 0) or (655 <= 510)) then
														FlatIdent_30264 = 0;
														ShouldReturn = nil;
														FlatIdent_8EC6E = 1;
													end
												end
											end
											if ((4144 >= 2313) and (Player:AffectingCombat() or OOC)) then
												local FlatIdent_5A929 = 0;
												local FlatIdent_1090B;
												local FlatIdent_ED25;
												while true do
													if (FlatIdent_5A929 == 1) then
														while true do
															if ((2472 <= 3253) and (FlatIdent_1090B == (1829 - (1059 + 770)))) then
																FlatIdent_ED25 = 0;
																while true do
																	if ((18 - 14) == FlatIdent_ED25) then
																		local FlatIdent_7F135 = 0;
																		local FlatIdent_F137;
																		while true do
																			if ((1556 < 3192) and (FlatIdent_7F135 == 0)) then
																				FlatIdent_F137 = 545 - (424 + 121);
																				while true do
																					if (FlatIdent_F137 == 0) then
																						if ((CDs and ((EL.CombatTime() > (1 + 2)) or not S[LUAOBFUSACTOR_DECRYPT_STR_0("\4\43\255\160\223\129\246\232\52\43\226\171", "\137\64\66\141\197\153\232\142")]:IsAvailable() or (Target:DebuffUp(S.DireFixationDebuff) and (ComboPoints < 4)) or (EnemiesCount11y > (1348 - (641 + 706)))) and not ((EnemiesCount11y == 1) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\32\223\44\176\135\8\213\22\174\141\48\192\43\180\129\23\195", "\232\99\176\66\198")]:IsAvailable())) or (4775 < 1460)) then
																							local FlatIdent_87A12 = 0 + 0;
																							local FlatIdent_10550;
																							local ShouldReturn;
																							while true do
																								if ((441 - (249 + 191)) == FlatIdent_87A12) then
																									while true do
																										if ((FlatIdent_10550 == 0) or (507 >= 3446)) then
																											ShouldReturn = Cooldown();
																											if (ShouldReturn or (3276 < 2191)) then
																												return ShouldReturn;
																											end
																											break;
																										end
																									end
																									break;
																								end
																								if ((FlatIdent_87A12 == 0) or (3441 <= 3392)) then
																									FlatIdent_10550 = 0;
																									ShouldReturn = nil;
																									FlatIdent_87A12 = 1;
																								end
																							end
																						end
																						if ((935 < 940) and CDs and Target:DebuffUp(S.Rip)) then
																							local FlatIdent_79781 = 0;
																							local ShouldReturn;
																							while true do
																								if ((1477 < 2505) and (0 == FlatIdent_79781)) then
																									ShouldReturn = Cooldown();
																									if (ShouldReturn or (4098 < 2139)) then
																										return ShouldReturn;
																									end
																									break;
																								end
																							end
																						end
																						FlatIdent_F137 = 1;
																					end
																					if ((98 == 98) and (FlatIdent_F137 == 1)) then
																						if S[LUAOBFUSACTOR_DECRYPT_STR_0("\202\36\58\7\119\171\235\41\226\59\49", "\76\140\65\72\102\27\237\153")]:IsReady() then
																							if (Everyone.CastTargetIf(S.FeralFrenzy, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\71\219\14", "\222\42\186\118\178\183\97"), EvaluateTargetIfFilterTTD, EvaluateTargetIfFeralFrenzy, not IsInMeleeRange) or (2085 == 2457)) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\91\233\86\139\81\211\66\152\88\226\94\147\29\225\69\131\83\172\22\218", "\234\61\140\36");
																							end
																						end
																						FlatIdent_ED25 = 5;
																						break;
																					end
																				end
																				break;
																			end
																		end
																	end
																	if (6 == FlatIdent_ED25) then
																		local FlatIdent_3AAAB = 0;
																		while true do
																			if ((472 < 2095) and (FlatIdent_3AAAB == 0)) then
																				if ((ComboPoints == 4) and Player:BuffUp(S.PredatorRevealedBuff) and (Player:EnergyDeficit() > 40) and (EnemiesCount11y == 1)) then
																					if ((3226 < 3550) and Press(S.Pool)) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\41\192\169\240\253\116\17\211\224\194\180\124\23\210\168\225\175\58\87", "\18\126\161\192\132\221");
																					end
																				end
																				if (ComboPoints < 4) then
																				else
																					local FlatIdent_692EE = 0 - 0;
																					local FlatIdent_78AE8;
																					local ShouldReturn;
																					while true do
																						if ((FlatIdent_692EE == (1 + 0)) or (386 > 913)) then
																							while true do
																								if ((0 == FlatIdent_78AE8) or (4795 < 1103)) then
																									ShouldReturn = Finisher();
																									if (ShouldReturn or (4884 <= 4672)) then
																										return ShouldReturn;
																									end
																									break;
																								end
																							end
																							break;
																						end
																						if ((4537 >= 2997) and (FlatIdent_692EE == 0)) then
																							FlatIdent_78AE8 = 0;
																							ShouldReturn = nil;
																							FlatIdent_692EE = 3 - 2;
																						end
																					end
																				end
																				FlatIdent_3AAAB = 428 - (183 + 244);
																			end
																			if (1 == FlatIdent_3AAAB) then
																				if (((EnemiesCount11y > (1 + 0)) and (ComboPoints < (734 - (434 + 296)))) or (844 >= 4582)) then
																					local FlatIdent_31653 = 0;
																					local FlatIdent_850EB;
																					local FlatIdent_65740;
																					local ShouldReturn;
																					while true do
																						if (FlatIdent_31653 == 1) then
																							ShouldReturn = nil;
																							while true do
																								if (FlatIdent_850EB == (2 - 1)) then
																									while true do
																										if ((4802 == 4802) and (FlatIdent_65740 == (512 - (169 + 343)))) then
																											ShouldReturn = AoeBuilder();
																											if ((4757 >= 4514) and ShouldReturn) then
																												return ShouldReturn;
																											end
																											break;
																										end
																									end
																									break;
																								end
																								if (FlatIdent_850EB == 0) then
																									FlatIdent_65740 = 0 + 0;
																									ShouldReturn = nil;
																									FlatIdent_850EB = 1;
																								end
																							end
																							break;
																						end
																						if ((4446 <= 4460) and (FlatIdent_31653 == (0 - 0))) then
																							FlatIdent_850EB = 0;
																							FlatIdent_65740 = nil;
																							FlatIdent_31653 = 1;
																						end
																					end
																				end
																				FlatIdent_ED25 = 7;
																				break;
																			end
																		end
																	end
																	if (5 == FlatIdent_ED25) then
																		if ((844 >= 587) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\7\216\168\115\3\7\207\191\124\21\56", "\111\65\189\218\18")]:IsReady() and (ComboPoints < 3) and Target:DebuffUp(S.DireFixationDebuff) and Target:DebuffUp(S.Rip) and (EnemiesCount11y == 1) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\96\68\21\35\4\87\170\119\67\30\6\27\85\189\74\95\8", "\207\35\43\123\85\107\60")]:IsAvailable()) then
																			if Press(S.FeralFrenzy, not IsInMeleeRange) then
																				return LUAOBFUSACTOR_DECRYPT_STR_0("\118\175\178\235\117\79\172\178\239\119\106\179\224\231\120\121\164\224\184\40", "\25\16\202\192\138");
																			end
																		end
																		if ((469 >= 230) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\219\206\191\237\170\253\242\222\190\192\160\224\248", "\148\157\171\205\130\201")]:IsReady() and Player:BuffUp(S.ApexPredatorsCravingBuff) and ((EnemiesCount11y == 1) or not S[LUAOBFUSACTOR_DECRYPT_STR_0("\19\198\125\36\208\250\20\198\117\61\217", "\150\67\180\20\73\177")]:IsAvailable() or Player:BuffDown(S.SabertoothBuff)) and not (VarNeedBT and (CountActiveBtTriggers() == 2))) then
																			if ((2529 < 3197) and Everyone.CastTargetIf(S.FerociousBite, EnemiesMelee, LUAOBFUSACTOR_DECRYPT_STR_0("\128\25\2", "\45\237\120\122"), EvaluateTargetIfFilterTTD, nil, not IsInMeleeRange)) then
																				return LUAOBFUSACTOR_DECRYPT_STR_0("\209\237\176\35\212\225\173\57\196\215\160\37\195\237\226\33\214\225\172\108\134\190", "\76\183\136\194");
																			end
																		end
																		if (Player:BuffUp(BsInc) or (69 >= 2833)) then
																			local FlatIdent_14236 = 0;
																			local FlatIdent_29BDD;
																			local ShouldReturn;
																			while true do
																				if (FlatIdent_14236 == 1) then
																					while true do
																						if (FlatIdent_29BDD == 0) then
																							local FlatIdent_485F5 = 0;
																							while true do
																								if ((2296 < 4476) and (FlatIdent_485F5 == 1)) then
																									FlatIdent_29BDD = 1;
																									break;
																								end
																								if ((FlatIdent_485F5 == 0) or (4013 < 3360)) then
																									ShouldReturn = Berserk();
																									if ShouldReturn then
																										return ShouldReturn;
																									end
																									FlatIdent_485F5 = 2 - 1;
																								end
																							end
																						end
																						if ((FlatIdent_29BDD == 1) or (1376 >= 4624)) then
																							if ((319 <= 1698) and Press(S.Pool)) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\77\231\236\44\16\73\27\104\166\199\61\66\92\17\104\237\173\113", "\116\26\134\133\88\48\47");
																							end
																							break;
																						end
																					end
																					break;
																				end
																				if ((FlatIdent_14236 == 0) or (4662 > 4999)) then
																					local FlatIdent_88B43 = 0;
																					while true do
																						if (FlatIdent_88B43 == 1) then
																							FlatIdent_14236 = 1;
																							break;
																						end
																						if (FlatIdent_88B43 == 0) then
																							FlatIdent_29BDD = 0;
																							ShouldReturn = nil;
																							FlatIdent_88B43 = 1;
																						end
																					end
																				end
																			end
																		end
																		FlatIdent_ED25 = 6;
																	end
																	if (FlatIdent_ED25 == 1) then
																		local FlatIdent_283EA = 0;
																		while true do
																			if ((FlatIdent_283EA == 0) or (3893 <= 3114)) then
																				if ((4657 >= 1054) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\115\138\42\81\95\153\51", "\23\48\235\94")]:IsCastable()) then
																					if (Press(S.CatForm) or (720 >= 2164)) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\127\219\204\98\81\60\192\113\154\213\92\94\61\146\40", "\178\28\186\184\61\55\83");
																					end
																				end
																				if ((605 < 4098) and Player:AffectingCombat()) then
																					local FlatIdent_8A256 = 0;
																					while true do
																						if (0 == FlatIdent_8A256) then
																							if ((337 < 1799) and (Player:HealthPercentage() <= NaturesVigilHP) and UseNaturesVigil and S[LUAOBFUSACTOR_DECRYPT_STR_0("\234\204\83\41\224\11\230\242\196\64\53\254", "\149\164\173\39\92\146\110")]:IsReady()) then
																								if ((1065 < 2308) and Press(S.NaturesVigil, nil, nil, true)) then
																									return LUAOBFUSACTOR_DECRYPT_STR_0("\253\38\4\10\8\30\224\24\6\22\29\18\255\103\20\26\28\30\253\52\25\9\31\91\161", "\123\147\71\112\127\122");
																								end
																							end
																							if ((Player:HealthPercentage() <= RenewalHP) and UseRenewal and S[LUAOBFUSACTOR_DECRYPT_STR_0("\254\200\140\116\81\205\193", "\38\172\173\226\17")]:IsReady()) then
																								if ((1363 < 4139) and Press(S.Renewal, nil, nil, true)) then
																									return LUAOBFUSACTOR_DECRYPT_STR_0("\95\20\34\234\90\16\32\175\73\20\42\234\67\2\37\249\72\81\126", "\143\45\113\76");
																								end
																							end
																							FlatIdent_8A256 = 1;
																						end
																						if (FlatIdent_8A256 == 1) then
																							local FlatIdent_3325E = 0;
																							while true do
																								if ((FlatIdent_3325E == 0) or (2173 < 1013)) then
																									local FlatIdent_179A7 = 0 + 0;
																									while true do
																										if ((FlatIdent_179A7 == (2 - 1)) or (4314 <= 520)) then
																											FlatIdent_3325E = 1124 - (651 + 472);
																											break;
																										end
																										if ((1665 <= 4016) and (FlatIdent_179A7 == 0)) then
																											if ((Player:HealthPercentage() <= FrenziedRegenerationHP) and UseFrenziedRegeneration and S[LUAOBFUSACTOR_DECRYPT_STR_0("\158\170\25\50\162\177\25\56\138\189\27\57\182\189\14\61\172\177\19\50", "\92\216\216\124")]:IsReady()) then
																												if Press(S.FrenziedRegeneration, nil, nil, true) then
																													return LUAOBFUSACTOR_DECRYPT_STR_0("\125\32\169\78\231\82\55\168\114\248\92\55\162\69\239\90\38\165\79\243\27\54\169\70\248\85\33\165\86\248\27\96", "\157\59\82\204\32");
																												end
																											end
																											if (((Player:HealthPercentage() <= SurvivalInstinctsHP) and UseSurvivalInstincts and S[LUAOBFUSACTOR_DECRYPT_STR_0("\11\43\241\236\224\252\210\189\17\48\240\238\224\228\208\165\43", "\209\88\94\131\154\137\138\179")]:IsReady()) or (1090 > 3234)) then
																												if ((2138 == 2138) and Press(S.SurvivalInstincts, nil, nil, true)) then
																													return LUAOBFUSACTOR_DECRYPT_STR_0("\27\180\214\106\23\53\48\46\1\175\215\104\23\45\50\54\59\225\192\121\24\38\63\49\33\183\193\60\76", "\66\72\193\164\28\126\67\81");
																												end
																											end
																											FlatIdent_179A7 = 1 + 0;
																										end
																									end
																								end
																								if (FlatIdent_3325E == (1 + 0)) then
																									FlatIdent_8A256 = 2;
																									break;
																								end
																							end
																						end
																						if (FlatIdent_8A256 == 3) then
																							if ((I[LUAOBFUSACTOR_DECRYPT_STR_0("\12\10\163\75\48\7\177\83\43\1\167", "\39\68\111\194")]:IsReady() and UseHealthstone and (Player:HealthPercentage() <= HealthstoneHP)) or (2195 > 2513)) then
																								if Press(M.Healthstone, nil, nil, true) then
																									return LUAOBFUSACTOR_DECRYPT_STR_0("\222\163\230\203\109\191\197\178\232\201\124\247\210\163\225\194\119\164\223\176\226\135\42", "\215\182\198\135\167\25");
																								end
																							end
																							if (UseHealingPotion and (Player:HealthPercentage() <= HealingPotionHP)) then
																								if (HealingPotionName ~= LUAOBFUSACTOR_DECRYPT_STR_0("\191\76\236\90\136\90\226\65\131\78\170\96\136\72\230\65\131\78\170\120\130\93\227\71\131", "\40\237\41\138")) then
																								elseif ((3027 < 4282) and I[LUAOBFUSACTOR_DECRYPT_STR_0("\245\113\252\234\79\212\124\243\246\77\239\113\251\244\67\201\115\202\247\94\206\123\244", "\42\167\20\154\152")]:IsReady()) then
																									if (Press(M.RefreshingHealingPotion, nil, nil, true) or (3331 <= 1876)) then
																										return LUAOBFUSACTOR_DECRYPT_STR_0("\88\251\164\80\116\50\66\247\172\69\49\41\79\255\174\75\127\38\10\238\173\86\120\46\68\190\166\71\119\36\68\237\171\84\116\97\30", "\65\42\158\194\34\17");
																									end
																								end
																							end
																							break;
																						end
																						if (FlatIdent_8A256 == (2 - 0)) then
																							local FlatIdent_40AAD = 0;
																							while true do
																								if (FlatIdent_40AAD == (484 - (397 + 86))) then
																									FlatIdent_8A256 = 3;
																									break;
																								end
																								if (FlatIdent_40AAD == 0) then
																									if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\213\41\175\74\41\97\243\36", "\22\135\76\200\56\70")]:IsCastable() and UseRegrowth and Player:BuffUp(S.PredatorySwiftnessBuff) and (Player:HealthPercentage() <= RegrowthHP)) then
																										if ((3038 < 3306) and Press(M.RegrowthPlayer)) then
																											return LUAOBFUSACTOR_DECRYPT_STR_0("\159\53\255\54\82\246\153\56\184\32\88\231\136\62\235\45\75\228\205\100", "\129\237\80\152\68\61");
																										end
																									end
																									if (((Player:HealthPercentage() <= BarkskinHP) and UseBarkskin and S[LUAOBFUSACTOR_DECRYPT_STR_0("\115\169\22\248\15\28\81\95", "\56\49\200\100\147\124\119")]:IsReady()) or (1328 < 579)) then
																										if Press(S.Barkskin, nil, nil, true) then
																											return LUAOBFUSACTOR_DECRYPT_STR_0("\206\63\173\251\223\53\182\254\140\58\186\246\201\48\172\249\218\59\255\166", "\144\172\94\223");
																										end
																									end
																									FlatIdent_40AAD = 1;
																								end
																							end
																						end
																					end
																				end
																				FlatIdent_283EA = 1;
																			end
																			if ((1 == FlatIdent_283EA) or (242 > 1801)) then
																				if (UseRegrowthMouseover and S[LUAOBFUSACTOR_DECRYPT_STR_0("\40\34\85\30\34\250\15\230", "\142\122\71\50\108\77\141\123")]:IsReady() and Player:BuffUp(S.PredatorySwiftnessBuff)) then
																					if ((Player:HealthPercentage() > RegrowthHP) and Player:IsInParty() and not Player:IsInRaid()) then
																						if ((2718 <= 4744) and Mouseover and Mouseover:Exists() and (Mouseover:HealthPercentage() <= RegrowthHP) and not Mouseover:IsDeadOrGhost() and not Player:CanAttack(Mouseover)) then
																							if ((577 <= 2479) and Press(M.RegrowthMouseover)) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\7\167\248\10\52\2\182\247\39\54\26\183\236\29\52\3\167\237", "\91\117\194\159\120");
																							end
																						end
																					end
																				end
																				FlatIdent_ED25 = 2;
																				break;
																			end
																		end
																	end
																	if ((FlatIdent_ED25 == 2) or (2010 >= 3777)) then
																		local FlatIdent_E37E = 876 - (423 + 453);
																		while true do
																			if ((2612 > 841) and (FlatIdent_E37E == 1)) then
																				if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\212\254\129\166", "\177\134\159\234\195")]:IsReady() and (Player:StealthUp(false, true))) or (2182 < 1656)) then
																					if (Everyone.CastCycle(S.Rake, EnemiesMelee, EvaluateCycleRakeMain, not IsInMeleeRange, nil, nil, M.RakeMouseover) or (683 == 2136)) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\175\234\52\165\137\176\234\54\174\137\236\187", "\169\221\139\95\192");
																					end
																				end
																				FlatIdent_ED25 = 3;
																				break;
																			end
																			if (0 == FlatIdent_E37E) then
																				Variables();
																				if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\46\20\57\29\39\226\2\15\15\39", "\68\122\125\94\120\85\145")]:IsCastable() and ((not Player:HasTier(31, 4) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\52\19\193\72\199\210\191\35\20\202\109\216\208\168\30\8\220", "\218\119\124\175\62\168\185")]:IsAvailable()) or Player:BuffDown(S.TigersFury) or (Player:EnergyDeficit() > 65) or (Player:HasTier(4 + 27, 2) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\131\245\90\197\169\214\90\193\171\234\81", "\164\197\144\40")]:CooldownUp()) or ((FightRemains < 15) and S[LUAOBFUSACTOR_DECRYPT_STR_0("\179\226\175\143\220\162\140\226", "\214\227\144\202\235\189")]:IsAvailable()))) then
																					if (Press(S.TigersFury, not IsInMeleeRange) or (4636 <= 2617)) then
																						return LUAOBFUSACTOR_DECRYPT_STR_0("\249\172\128\126\2\160\108\58\248\183\158\59\29\178\90\50\173\243", "\92\141\197\231\27\112\211\51");
																					end
																				end
																				FlatIdent_E37E = 1;
																			end
																		end
																	end
																	if (FlatIdent_ED25 == 7) then
																		if ((Player:BuffDown(BsInc) and (EnemiesCount11y == 1) and (ComboPoints < 4)) or (4735 == 24)) then
																			local FlatIdent_14C34 = 0 + 0;
																			local FlatIdent_12D0E;
																			local FlatIdent_78CCA;
																			local ShouldReturn;
																			while true do
																				if ((671 < 2516) and (FlatIdent_14C34 == 1)) then
																					ShouldReturn = nil;
																					while true do
																						if (FlatIdent_12D0E == (1 + 0)) then
																							while true do
																								if ((639 == 639) and (FlatIdent_78CCA == 0)) then
																									ShouldReturn = Builder();
																									if (ShouldReturn or (4969 < 2629)) then
																										return ShouldReturn;
																									end
																									break;
																								end
																							end
																							break;
																						end
																						if (FlatIdent_12D0E == 0) then
																							local FlatIdent_38D88 = 0;
																							while true do
																								if (FlatIdent_38D88 == 0) then
																									FlatIdent_78CCA = 0;
																									ShouldReturn = nil;
																									FlatIdent_38D88 = 1 + 0;
																								end
																								if (FlatIdent_38D88 == (1 + 0)) then
																									FlatIdent_12D0E = 1191 - (50 + 1140);
																									break;
																								end
																							end
																						end
																					end
																					break;
																				end
																				if (FlatIdent_14C34 == 0) then
																					FlatIdent_12D0E = 0;
																					FlatIdent_78CCA = nil;
																					FlatIdent_14C34 = 1;
																				end
																			end
																		end
																		break;
																	end
																	if ((0 == FlatIdent_ED25) or (536 >= 4286)) then
																		local FlatIdent_14EC9 = 0 + 0;
																		local FlatIdent_30968;
																		while true do
																			if ((3525 > 256) and (FlatIdent_14EC9 == 0)) then
																				FlatIdent_30968 = 0;
																				while true do
																					if ((2799 == 2799) and (0 == FlatIdent_30968)) then
																						if ((not Player:IsCasting() and not Player:IsChanneling()) or (587 > 3531)) then
																							local FlatIdent_6F430 = 0;
																							local FlatIdent_CD2D;
																							local ShouldReturn;
																							while true do
																								if ((FlatIdent_6F430 == 1) or (543 == 4848)) then
																									while true do
																										if (FlatIdent_CD2D == 1) then
																											ShouldReturn = Everyone.Interrupt(S.SkullBash, 10, true, Mouseover, M.SkullBashMouseover);
																											if ShouldReturn then
																												return ShouldReturn;
																											end
																											FlatIdent_CD2D = 2;
																										end
																										if ((168 < 2526) and (4 == FlatIdent_CD2D)) then
																											if (Player:BuffUp(S.CatForm) and (Player:ComboPoints() > (0 + 0))) then
																												local FlatIdent_23B19 = 0 + 0;
																												local FlatIdent_84A3C;
																												while true do
																													if ((351 <= 3074) and (FlatIdent_23B19 == (0 - 0))) then
																														FlatIdent_84A3C = 0;
																														while true do
																															if ((FlatIdent_84A3C == 0) or (3519 <= 3320)) then
																																ShouldReturn = Everyone.InterruptWithStun(S.Maim, 8);
																																if ShouldReturn then
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
																										if ((1566 < 2525) and (FlatIdent_CD2D == 0)) then
																											local FlatIdent_2A8AE = 0;
																											local FlatIdent_91FCF;
																											while true do
																												if (FlatIdent_2A8AE == 0) then
																													FlatIdent_91FCF = 0;
																													while true do
																														if ((0 + 0) == FlatIdent_91FCF) then
																															ShouldReturn = Everyone.Interrupt(S.SkullBash, 10, true);
																															if ShouldReturn then
																																return ShouldReturn;
																															end
																															FlatIdent_91FCF = 1;
																														end
																														if ((FlatIdent_91FCF == 1) or (2187 < 1246)) then
																															FlatIdent_CD2D = 1;
																															break;
																														end
																													end
																													break;
																												end
																											end
																										end
																										if (2 == FlatIdent_CD2D) then
																											ShouldReturn = Everyone.InterruptWithStun(S.MightyBash, 8);
																											if (ShouldReturn or (3864 == 460)) then
																												return ShouldReturn;
																											end
																											FlatIdent_CD2D = 3;
																										end
																										if ((FlatIdent_CD2D == 3) or (1660 < 1029)) then
																											local FlatIdent_904BF = 596 - (157 + 439);
																											local FlatIdent_8D8D4;
																											while true do
																												if ((FlatIdent_904BF == 0) or (3424 < 89)) then
																													FlatIdent_8D8D4 = 0 - 0;
																													while true do
																														if ((810 <= 4501) and (FlatIdent_8D8D4 == 1)) then
																															FlatIdent_CD2D = 4;
																															break;
																														end
																														if ((FlatIdent_8D8D4 == 0) or (13 >= 223)) then
																															ShouldReturn = Everyone.InterruptWithStun(S.IncapacitatingRoar, 8);
																															if ShouldReturn then
																																return ShouldReturn;
																															end
																															FlatIdent_8D8D4 = 3 - 2;
																														end
																													end
																													break;
																												end
																											end
																										end
																									end
																									break;
																								end
																								if ((FlatIdent_6F430 == (0 - 0)) or (2574 == 3018)) then
																									FlatIdent_CD2D = 0;
																									ShouldReturn = nil;
																									FlatIdent_6F430 = 1;
																								end
																							end
																						end
																						if ((DispelBuffs and DispelToggle and S[LUAOBFUSACTOR_DECRYPT_STR_0("\141\127\213\211\11\176", "\113\222\16\186\167\99\213\227")]:IsReady() and not Player:IsCasting() and not Player:IsChanneling() and Everyone.UnitHasEnrageBuff(Target)) or (312 < 298)) then
																							if (Press(S.Soothe, not IsInMeleeRange) or (205 > 4175)) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\42\7\232\230\43\2", "\150\78\110\155");
																							end
																						end
																						FlatIdent_30968 = 1;
																					end
																					if ((FlatIdent_30968 == 1) or (1815 == 1661)) then
																						if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\181\215\40\246\168", "\32\229\165\71\129\196\126\223")]:IsCastable() and (Player:BuffDown(BsInc))) then
																							if (Press(S.Prowl) or (302 > 2811)) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\211\155\203\150\141\149\206\136\205\143\193\135", "\181\163\233\164\225\225");
																							end
																						end
																						FlatIdent_ED25 = 1;
																						break;
																					end
																				end
																				break;
																			end
																		end
																	end
																	if (FlatIdent_ED25 == 3) then
																		local FlatIdent_61FEE = 918 - (782 + 136);
																		local FlatIdent_41BE4;
																		while true do
																			if ((1888 >= 603) and (FlatIdent_61FEE == (855 - (112 + 743)))) then
																				FlatIdent_41BE4 = 0;
																				while true do
																					if (0 == FlatIdent_41BE4) then
																						local FlatIdent_44C3A = 0;
																						while true do
																							if (FlatIdent_44C3A == 1) then
																								FlatIdent_41BE4 = 1172 - (1026 + 145);
																								break;
																							end
																							if (FlatIdent_44C3A == 0) then
																								if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\255\143\126\47\54\47\200\142\76\40\35\52\211", "\70\190\235\31\95\66")]:IsReady() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\143\236\24\244\236\190\238\31\226\214\173\227\8\235", "\133\218\130\122\134")]:IsAvailable() and (EnemiesCount11y <= 1) and (Player:BuffStack(S.AdaptiveSwarmHeal) < (1 + 3)) and (Player:BuffRemains(S.AdaptiveSwarmHeal) > 4)) then
																									if ((4795 == 4795) and Press(M.AdaptiveSwarmPlayer)) then
																										return LUAOBFUSACTOR_DECRYPT_STR_0("\61\251\226\212\200\170\46\57\192\240\211\221\177\53\124\236\230\200\218\227\53\61\246\237\132\141\247", "\88\92\159\131\164\188\195");
																									end
																								end
																								if ((S[LUAOBFUSACTOR_DECRYPT_STR_0("\161\42\190\91\195\226\203\133\29\168\74\197\230", "\189\224\78\223\43\183\139")]:IsReady() and (not S[LUAOBFUSACTOR_DECRYPT_STR_0("\27\242\136\4\200\42\240\143\18\242\57\253\152\27", "\161\78\156\234\118")]:IsAvailable() or (EnemiesCount11y == (719 - (493 + 225))))) or (4777 > 4889)) then
																									if (Everyone.CastCycle(S.AdaptiveSwarm, Enemies11y, EvaluateCycleAdaptiveSwarm, not Target:IsSpellInRange(S.AdaptiveSwarm), nil, nil, M.AdaptiveSwarmMouseover) or (3346 < 1420)) then
																										return LUAOBFUSACTOR_DECRYPT_STR_0("\166\179\200\204\179\190\223\217\152\164\222\221\181\186\137\209\166\190\199\156\246\229", "\188\199\215\169");
																									end
																								end
																								FlatIdent_44C3A = 1;
																							end
																						end
																					end
																					if ((2418 >= 2247) and ((3 - 2) == FlatIdent_41BE4)) then
																						if (S[LUAOBFUSACTOR_DECRYPT_STR_0("\221\13\94\107\252\245\31\90\72\255\253\27\82", "\136\156\105\63\27")]:IsReady() and S[LUAOBFUSACTOR_DECRYPT_STR_0("\46\130\123\38\18\136\117\49\31\191\110\53\9\129", "\84\123\236\25")]:IsAvailable() and (EnemiesCount11y > 1)) then
																							if ((3423 >= 3059) and Everyone.CastTargetIf(S.AdaptiveSwarm, Enemies11y, LUAOBFUSACTOR_DECRYPT_STR_0("\253\138\178", "\213\144\235\202\119\204"), EvaluateTargetIfFilterAdaptiveSwarm, EvaluateTargetIfAdaptiveSwarm, not Target:IsSpellInRange(S.AdaptiveSwarm))) then
																								return LUAOBFUSACTOR_DECRYPT_STR_0("\34\28\223\58\60\42\91\38\39\205\61\41\49\64\99\21\223\35\38\99\28\112", "\45\67\120\190\74\72\67");
																							end
																						end
																						FlatIdent_ED25 = 3 + 1;
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
													if ((2633 >= 1106) and (FlatIdent_5A929 == (0 - 0))) then
														FlatIdent_1090B = 0 + 0;
														FlatIdent_ED25 = nil;
														FlatIdent_5A929 = 1;
													end
												end
											end
											FlatIdent_297C4 = 1;
										end
									end
								end
								break;
							end
							if ((FlatIdent_4004D == 4) or (3992 < 3408)) then
								local FlatIdent_43707 = 0;
								local FlatIdent_7566;
								while true do
									if (FlatIdent_43707 == 0) then
										FlatIdent_7566 = 0 - 0;
										while true do
											if (FlatIdent_7566 == 2) then
												FlatIdent_4004D = 2 + 3;
												break;
											end
											if ((FlatIdent_7566 == 0) or (3541 < 2119)) then
												if ((Mouseover and Mouseover:Exists() and Mouseover:IsAPlayer() and Mouseover:IsDeadOrGhost() and not Player:CanAttack(Mouseover)) or (493 > 3707)) then
													if Player:AffectingCombat() then
														if S[LUAOBFUSACTOR_DECRYPT_STR_0("\29\27\45\35\19\19\39", "\103\79\126\79\74\97")]:IsReady() then
															if Press(M.RebirthMouseover, nil, true) then
																return LUAOBFUSACTOR_DECRYPT_STR_0("\168\122\209\122\76\14\178", "\122\218\31\179\19\62");
															end
														end
													elseif Press(M.ReviveMouseover, nil, true) then
														return LUAOBFUSACTOR_DECRYPT_STR_0("\161\211\219\200\223\164", "\37\211\182\173\161\169\193");
													end
												end
												if ((4557 >= 2988) and HandleAfflicted) then
													local FlatIdent_78785 = 0;
													while true do
														if (FlatIdent_78785 == 0) then
															ShouldReturn = Everyone.HandleAfflicted(S.RemoveCorruption, M.RemoveCorruptionMouseover, 40);
															if (ShouldReturn or (2825 == 3131)) then
																return ShouldReturn;
															end
															break;
														end
													end
												end
												FlatIdent_7566 = 1 - 0;
											end
											if ((3702 > 1244) and (FlatIdent_7566 == (1596 - (210 + 1385)))) then
												local FlatIdent_1718C = 0;
												while true do
													if ((1053 <= 2012) and (FlatIdent_1718C == 1)) then
														FlatIdent_7566 = 2;
														break;
													end
													if ((FlatIdent_1718C == 0) or (4453 >= 4963)) then
														if (HandleIncorporeal or (3904 == 4817)) then
															local FlatIdent_6F93 = 0;
															local FlatIdent_63C75;
															while true do
																if ((FlatIdent_6F93 == 0) or (1399 > 1549)) then
																	FlatIdent_63C75 = 0;
																	while true do
																		if ((3876 == 3876) and (FlatIdent_63C75 == 0)) then
																			ShouldReturn = Everyone.HandleIncorporeal(S.Hibernate, M.HibernateMouseover, 30, true);
																			if (ShouldReturn or (1145 > 2264)) then
																				return ShouldReturn;
																			end
																			break;
																		end
																	end
																	break;
																end
															end
														end
														if ((not Player:AffectingCombat() and OOC) or (3537 > 4581)) then
															local FlatIdent_E26B = 1689 - (1201 + 488);
															local FlatIdent_2B395;
															local FlatIdent_2BC83;
															while true do
																if (FlatIdent_E26B == (0 + 0)) then
																	FlatIdent_2B395 = 0;
																	FlatIdent_2BC83 = nil;
																	FlatIdent_E26B = 1;
																end
																if (FlatIdent_E26B == 1) then
																	while true do
																		if ((4149 >= 510) and (FlatIdent_2B395 == 0)) then
																			FlatIdent_2BC83 = 0;
																			while true do
																				if (FlatIdent_2BC83 == 0) then
																					if (UseMarkOfTheWild and S[LUAOBFUSACTOR_DECRYPT_STR_0("\218\59\95\210\7\125\141\255\63\122\208\36\127", "\217\151\90\45\185\72\27")]:IsCastable() and (Player:BuffDown(S.MarkOfTheWild, true) or Everyone.GroupBuffMissing(S.MarkOfTheWild))) then
																						if (Press(M.MarkOfTheWildPlayer) or (1472 >= 3492)) then
																							return LUAOBFUSACTOR_DECRYPT_STR_0("\206\125\245\25\105\204\122\216\6\94\198\67\240\27\90\199", "\54\163\28\135\114");
																						end
																					end
																					if S[LUAOBFUSACTOR_DECRYPT_STR_0("\11\218\73\164\65\109\37", "\31\72\187\61\226\46")]:IsCastable() then
																						if (Press(S.CatForm) or (130 >= 1901)) then
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
															end
														end
														FlatIdent_1718C = 1;
													end
												end
											end
										end
										break;
									end
								end
							end
							if ((FlatIdent_4004D == 1) or (2562 >= 3765)) then
								local FlatIdent_73CA7 = 0;
								while true do
									if (FlatIdent_73CA7 == 1) then
										if (Player:BuffUp(S.TravelForm) or Player:IsMounted()) then
											return;
										end
										AIRange = mathfloor(1.5 * S[LUAOBFUSACTOR_DECRYPT_STR_0("\160\213\69\224\200\80\168\200\87\254\220\89\143\197\84", "\60\225\166\49\146\169")]:TalentRank());
										FlatIdent_73CA7 = 2 - 0;
									end
									if (0 == FlatIdent_73CA7) then
										DispelToggle = EpicSettings[LUAOBFUSACTOR_DECRYPT_STR_0("\158\190\234\224\123\235\84", "\39\202\209\141\135\23\142")][LUAOBFUSACTOR_DECRYPT_STR_0("\251\58\26\26\55\244", "\152\159\83\105\106\82")];
										if Player:IsDeadOrGhost() then
											return;
										end
										FlatIdent_73CA7 = 1;
									end
									if ((FlatIdent_73CA7 == (2 - 0)) or (1675 < 309)) then
										FlatIdent_4004D = 587 - (352 + 233);
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
		end
	end
	local function OnInit()
		local FlatIdent_2205B = 0;
		local FlatIdent_6C07D;
		while true do
			if (0 == FlatIdent_2205B) then
				FlatIdent_6C07D = 0;
				while true do
					if ((2905 >= 966) and ((2 - 1) == FlatIdent_6C07D)) then
						EpicSettings.SetupVersion(LUAOBFUSACTOR_DECRYPT_STR_0("\49\54\155\9\27\115\173\26\2\58\141\72\1\115\216\88\89\97\199\88\70\115\171\17\87\17\134\7\26\24", "\104\119\83\233"));
						break;
					end
					if (FlatIdent_6C07D == 0) then
						local FlatIdent_672E4 = 0;
						while true do
							if ((2250 > 1570) and (FlatIdent_672E4 == 0)) then
								S[LUAOBFUSACTOR_DECRYPT_STR_0("\250\80\85", "\27\168\57\37\26\133")]:RegisterAuraTracking();
								ER.Print(LUAOBFUSACTOR_DECRYPT_STR_0("\11\175\110\169\219\109\142\110\189\222\41\234\126\177\151\8\186\117\171\151\15\165\115\165\252", "\183\77\202\28\200"));
								FlatIdent_672E4 = 1;
							end
							if ((2723 == 2723) and (FlatIdent_672E4 == (1 + 0))) then
								FlatIdent_6C07D = 1;
								break;
							end
						end
					end
				end
				break;
			end
		end
	end
	ER.SetAPL(103, APL, OnInit);
end;
return luaobf_bundle[LUAOBFUSACTOR_DECRYPT_STR_0("\208\232\46\58\124\209\234\50\43\71\202\222\34\48\66\249\182\43\55\66", "\35\149\152\71\66")]();

