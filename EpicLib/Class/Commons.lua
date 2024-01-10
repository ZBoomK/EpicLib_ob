--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, EL = ...;
  -- EpicLib
  local EL = EpicLib;
  local Cache, Utils = EpicCache, EL.Utils;
  local Unit = EL.Unit;
  local Player = Unit.Player;
  local Focus = Unit.Focus;
  local Target = Unit.Target;
  local Mouseover = Unit.MouseOver;
  local Boss = Unit.Boss;
  local Nameplate = Unit.Nameplate;
  local Party = Unit.Party;
  local Raid = Unit.Raid;
  local Spell = EL.Spell;
  local Item = EL.Item;
  -- Lua
  local pairs = pairs;
  local stringformat = string.format
  local tableinsert = table.insert;
  -- File Locals
  EL.Commons = {};
  local Commons = {};
  EL.Commons.Everyone = Commons;
  --local Settings = EL.GUISettings.General;
  --local AbilitySettings = EL.GUISettings.Abilities;

--Variables
Commons.CurrentEncounterID = 0;

--- ============================ CONTENT ============================
-- Num/Bool helper functions
function Commons.num(val)
  if val then return 1 else return 0 end
end

function Commons.bool(val)
  return val ~= 0
end

-- Is the current target valid?
function Commons.TargetIsValid()
  return Target:Exists() and Player:CanAttack(Target) and (not Target:IsDeadOrGhost());
end

-- Is the current target also the mouseover?
function Commons.TargetIsMouseover()
  return Mouseover and Target and Mouseover:Exists() and Target:Exists() and Mouseover:GUID() == Target:GUID();
end

-- Is the current target a valid npc healable unit?
do
  Commons.HealableNpcIDs = {
  };
  function Commons.TargetIsValidHealableNpc()
    return Target:Exists() and (not Player:CanAttack(Target)) and Utils.ValueIsInArray(Commons.HealableNpcIDs, Target:NPCID());
  end
end

-- Is the current unit valid during cycle?
function Commons.UnitIsCycleValid(Unit, BestUnitTTD, TimeToDieOffset)
  return not Unit:IsFacingBlacklisted() and not Unit:IsUserCycleBlacklisted() and (not BestUnitTTD or Unit:FilteredTimeToDie(">", BestUnitTTD, TimeToDieOffset));
end

-- Is it worth to DoT the unit?
function Commons.CanDoTUnit(Unit, HealthThreshold)
  return Unit:Health() >= HealthThreshold or Unit:IsDummy();
end

function Commons.IsItTimeToRamp(id, times, duration)
  local currentTime = EL.CombatTime()

  if id ~= Commons.CurrentEncounterID then
    return false;
  end

  for _,k in pairs(times) do
    if currentTime >= k and currentTime <= k+duration then
      return true
    end
  end

  return false
end

-- Return which Boss  is casting the spell
function Commons.GetCastingEnemy(spell)
  for _, u in pairs(Nameplate) do
    if u:Exists() and u:IsCasting(spell) then
      return u
    end
  end

  return nil
end

-- Return which Boss is casting the spell
function Commons.EnemiesWithDebuffCount(spell, range)
  local count = 0
  for _, u in pairs(Nameplate) do
    if u:Exists() and u:DebuffUp(spell) and u:IsSpellInRange(spell) and Player:CanAttack(u) then
      count = count + 1
    end
  end
  return count
end

function Commons.GetUnitsTargetFriendly(unit)
  local FriendlyUnits = Commons.FriendlyUnits();
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if UnitIsUnit(FriendlyUnit:ID(), unit:ID().."target") then
      return FriendlyUnit
    end
  end
  return nil
end

-- Incorporeal
do
  local IncorporealNPCID = 204560;
  function Commons.HandleIncorporeal(Spell, Macro, Range, Immovable)
    if not Range then Range = 40; end
    if Target and Target:Exists() and Target:NPCID() == IncorporealNPCID and Target:IsSpellInRange(Spell) and Spell:IsReady() then
      if EL.Press(Spell, not Target:IsSpellInRange(Spell), Immovable) then return "Handle Incorporeal"; end
    end
    if Macro then
      if Mouseover and Mouseover:Exists() and Mouseover:NPCID() == IncorporealNPCID and Mouseover:IsSpellInRange(Spell) and Spell:IsReady() then
        if EL.Press(Macro, not Mouseover:IsSpellInRange(Spell), Immovable) then return "Handle Incorporeal Mouseover"; end
      end
    end
  end
end

-- Afflicted
do
  local AfflictedNPCID = 204773;
  function Commons.HandleAfflicted(Spell, Macro, Range, Immovable)
    if not Range then Range = 40; end
    if Target and Target:Exists() and Target:NPCID() == AfflictedNPCID and Target:IsSpellInRange(Spell) and Spell:IsReady() then
      if EL.Press(Spell, not Target:IsSpellInRange(Spell), Immovable) then return "Handle Afflicted"; end
    end
    if Macro then
      if Mouseover and Mouseover:Exists() and Mouseover:NPCID() == AfflictedNPCID and Mouseover:IsSpellInRange(Spell) and Spell:IsReady() then
        if EL.Press(Macro, not Mouseover:IsSpellInRange(Spell), Immovable) then return "Handle Afflicted Mouseover"; end
      end
    end
  end
end

-- Chromie
do
  local ChromieNPCID = 204449;
  function Commons.HandleChromie(Spell, Macro, Range, Immovable)
    if not Range then Range = 40; end
    if Target and Target:Exists() and Target:NPCID() == ChromieNPCID and Target:IsSpellInRange(Spell) and Spell:IsReady() then
      if EL.Press(Spell, not Target:IsSpellInRange(Spell), Immovable) then return "Handle Chromie"; end
    end
    if Macro then
      if Mouseover and Mouseover:Exists() and Mouseover:NPCID() == ChromieNPCID and Mouseover:IsSpellInRange(Spell) and Spell:IsReady() then
        if EL.Press(Macro, not Mouseover:IsSpellInRange(Spell), Immovable) then return "Handle Chromie Mouseover"; end
      end
    end
  end
end

-- charred-treant
do
  local TreantNPCID = 208849;
  function Commons.HandleCharredTreant(Spell, Macro, Range, Immovable)
    if not Range then Range = 40; end
    if Target and Target:Exists() and Target:HealthPercentage() < 90 and Target:NPCID() == TreantNPCID and Target:IsSpellInRange(Spell) and Spell:IsReady() then
      if EL.Press(Spell, not Target:IsSpellInRange(Spell), Immovable) then return "Handle Treant"; end
    end
    if Macro then
      if Mouseover and Mouseover:Exists() and Mouseover:HealthPercentage() < 90 and Mouseover:NPCID() == TreantNPCID and Mouseover:IsSpellInRange(Spell) and Spell:IsReady() then
        if EL.Press(Macro, not Mouseover:IsSpellInRange(Spell), Immovable) then return "Handle Treant Mouseover"; end
      end
    end
  end
end

-- charred-brambles
do
  local BramblesNPCID = 209542;
  function Commons.HandleCharredBrambles(Spell, Macro, Range, Immovable)
    if not Range then Range = 40; end
    if Target and Target:Exists() and Target:HealthPercentage() < 90 and Target:NPCID() == BramblesNPCID and Target:IsSpellInRange(Spell) and Spell:IsReady() then
      if EL.Press(Spell, not Target:IsSpellInRange(Spell), Immovable) then return "Handle Brambles"; end
    end
    if Macro then
      if Mouseover and Mouseover:Exists() and Mouseover:HealthPercentage() < 90 and Mouseover:NPCID() == BramblesNPCID and Mouseover:IsSpellInRange(Spell) and Spell:IsReady() then
        if EL.Press(Macro, not Mouseover:IsSpellInRange(Spell), Immovable) then return "Handle Brambles Mouseover"; end
      end
    end
  end
end

-- fyrakk-spirits
do
  local KaldoreiSpiritID = 207800;
  function Commons.HandleFyrakkNPC(Spell, Macro, Range, Immovable)
    if not Range then Range = 40; end
    if Target and Target:Exists() and Target:HealthPercentage() < 90 and Target:NPCID() == KaldoreiSpiritID and Target:IsSpellInRange(Spell) and Spell:IsReady() then
      if EL.Press(Spell, not Target:IsSpellInRange(Spell), Immovable) then return "Handle Kaldorei Spirits"; end
    end
    if Macro then
      if Mouseover and Mouseover:Exists() and Mouseover:HealthPercentage() < 90 and Mouseover:NPCID() == KaldoreiSpiritID and Mouseover:IsSpellInRange(Spell) and Spell:IsReady() then
        if EL.Press(Macro, not Mouseover:IsSpellInRange(Spell), Immovable) then return "Handle Kaldorei Spirits Mouseover"; end
      end
    end
  end
end

--Trinkets
do
  function Commons.HandleTopTrinket(ExcludeList, WithCooldownsCondition, Range, Immovable)
    if not Range then Range = 40; end
    if Target and Target:Exists() then
      if Player:GetUseableItems(ExcludeList, 13) then
        local target = EpicSettings.Settings["TopTrinketTarget"] or "Enemy"
        local cursorSettings = EpicSettings.Settings["TopTrinketCursor"] or "Enemy Under Cursor"
        local trinketCondition = EpicSettings.Settings["TopTrinketCondition"] or "Don't Use"
        local trinketHP = EpicSettings.Settings["TopTrinketHP"] or 0
        local spoilsSlot = EpicSettings.Settings["SpoilsOfNeltharusUsage"] or "Not Equipped"
        local spoilsWithHaste = EpicSettings.Settings["NeltharusHaste"] or false
        local spoilsWithCrit = EpicSettings.Settings["NeltharusCrit"] or false
        local spoilsWithMastery = EpicSettings.Settings["NeltharusMastery"] or false
        local spoilsWithVersatility = EpicSettings.Settings["NeltharusVersatility"] or false
        if trinketCondition == "Don't Use" then
          return false
        elseif trinketCondition == "At HP" then
          if target == "Player" then
            if Player:HealthPercentage() > trinketHP then
              return false
            end
          elseif target == "Friendly" then
            if Focus:HealthPercentage() > trinketHP then
              return false
            end
          elseif target == "Enemy" then
            if Target:HealthPercentage() > trinketHP then
              return false
            end
          elseif target == "Cursor" then
            if Target:HealthPercentage() > trinketHP then
              return false
            end
          end
        elseif trinketCondition == "With Cooldowns" then
          if not WithCooldownsCondition then
            return false
          end
        end

        --Handle Enemy Under Cursor
        if cursorSettings == "Enemy Under Cursor" then
          if not (Mouseover and Mouseover:Exists() and Player:CanAttack(Mouseover) and (not Mouseover:IsDeadOrGhost())) then
            return false
          end
        end

        --Handle spoils of neltharus
        if spoilsSlot == "Top" then
          local shouldSpoil = false
          for i=1,21 do
            local b, _, _, _, _, expire, _, _, _, id = UnitBuff("player", i)
            if id == 381957 and spoilsWithVersatility then
              shouldSpoil = true
            end
            if id == 381955 and spoilsWithHaste then
              shouldSpoil = true
            end
            if id == 381956 and spoilsWithMastery then
              shouldSpoil = true
            end
            if id == 381954 and spoilsWithCrit then
              shouldSpoil = true
            end
            if not shouldSpoil then
              return false
            end
          end
        end

        if EL.PressTrinket(13, target, cursorSettings) then return "Handle Top Trinket"; end
      end
    end
  end
end

-- DPS Potion
do
  function Commons.HandleDPSPotion(CooldownsCondition)
    local PotionType = EpicSettings.Settings["DPSPotionName"]
    local PotionUsage = EpicSettings.Settings["DPSPotionUsage"]
    local SelectedPotion = Commons.PotionSelected()
  
    if SelectedPotion and SelectedPotion:IsReady() then
      if PotionUsage == "Bloodlust+Cooldowns" then
        if Player:BloodlustUp() and CooldownsCondition then
          EL.EpicSettingsM = 500;
          return true;
        end
      elseif PotionUsage == "Cooldowns" then
        if CooldownsCondition then
          EL.EpicSettingsM = 500;
          return true;
        end
      elseif PotionUsage == "Bloodlust" then
        if Player:BloodlustUp() then
          EL.EpicSettingsM = 500;
          return true;
        end
      elseif PotionUsage == "On Cooldown" then
          EL.EpicSettingsM = 500;
          return true;
      end
    end
  
    return false;
  end
  
  function Commons.PotionSelected()
    local PotionType = EpicSettings.Settings["DPSPotionName"]
    local FleetingUltimatePowerPotionIDs = {
      -- Fleeting Ultimate Power
      191914, 191913, 191912
    }
    local FleetingPowerPotionIDs = {
      -- Fleeting Power
      191907, 191906, 191905
    }
    local UltimatePowerPotionIDs = {
      -- Ultimate Power
      191383, 191382, 191381
    }
    local PowerPotionIDs = {
      -- Power
      191389, 191388, 191387
    }
    local FrozenFocusIDs = { 191365, 191364, 191363 }
    local ChilledClarityIDs = { 191368, 191367, 191366 }
    local ShockingDisclosureIDs = { 191401, 191400, 191399 }
    if PotionType == "Fleeting Ultimate Power" then
      for _, PotionID in ipairs(FleetingUltimatePowerPotionIDs) do
        if Item(PotionID):IsUsable() then
          return Item(PotionID)
        end
      end
    elseif PotionType == "Fleeting Power" then
      for _, PotionID in ipairs(FleetingPowerPotionIDs) do
        if Item(PotionID):IsUsable() then
          return Item(PotionID)
        end
      end
    elseif PotionType == "Ultimate Power" then
      for _, PotionID in ipairs(UltimatePowerPotionIDs) do
        if Item(PotionID):IsUsable() then
          return Item(PotionID)
        end
      end
    elseif PotionType == "Power" then
      for _, PotionID in ipairs(PowerPotionIDs) do
        if Item(PotionID):IsUsable() then
          return Item(PotionID)
        end
      end
    elseif PotionType == "Shocking Disclosure" then
      for _, PotionID in ipairs(ShockingDisclosureIDs) do
        if Item(PotionID):IsUsable() then
          return Item(PotionID)
        end
      end
    else
      return nil
    end
  end
end

do
  function Commons.HandleBottomTrinket(ExcludeList, WithCooldownsCondition, Range, Immovable)
    if not Range then Range = 40; end
    if Target and Target:Exists() then
      if Player:GetUseableItems(ExcludeList, 14) then
        local target = EpicSettings.Settings["BottomTrinketTarget"] or "Enemy"
        local cursorSettings = EpicSettings.Settings["BottomTrinketCursor"] or "Enemy Under Cursor"
        local trinketCondition = EpicSettings.Settings["BottomTrinketCondition"] or "Don't Use"
        local trinketHP = EpicSettings.Settings["BottomTrinketHP"] or 0
        local spoilsSlot = EpicSettings.Settings["SpoilsOfNeltharusUsage"] or "Not Equipped"
        local spoilsWithHaste = EpicSettings.Settings["NeltharusHaste"] or false
        local spoilsWithCrit = EpicSettings.Settings["NeltharusCrit"] or false
        local spoilsWithMastery = EpicSettings.Settings["NeltharusMastery"] or false
        local spoilsWithVersatility = EpicSettings.Settings["NeltharusVersatility"] or false
        
        if trinketCondition == "Don't Use" then
          return false
        elseif trinketCondition == "At HP" then
          if target == "Player" then
            if Player:HealthPercentage() > trinketHP then
              return false
            end
          elseif target == "Friendly" then
            if Focus:HealthPercentage() > trinketHP then
              return false
            end
          elseif target == "Enemy" then
            if Target:HealthPercentage() > trinketHP then
              return false
            end
          elseif target == "Cursor" then
            if Target:HealthPercentage() > trinketHP then
              return false
            end
          end
        elseif trinketCondition == "With Cooldowns" then
          if not WithCooldownsCondition then
            return false
          end
        end

        --Handle Enemy Under Cursor
        if cursorSettings == "Enemy Under Cursor" then
          if not (Mouseover and Mouseover:Exists() and Player:CanAttack(Mouseover) and (not Mouseover:IsDeadOrGhost())) then
            return false
          end
        end

        --Handle spoils of neltharus
        if spoilsSlot == "Bottom" then
          local shouldSpoil = false
          for i=1,21 do
            local b, _, _, _, _, expire, _, _, _, id = UnitBuff("player", i)
            if id == 381957 and spoilsWithVersatility then
              shouldSpoil = true
            end
            if id == 381955 and spoilsWithHaste then
              shouldSpoil = true
            end
            if id == 381956 and spoilsWithMastery then
              shouldSpoil = true
            end
            if id == 381954 and spoilsWithCrit then
              shouldSpoil = true
            end
            if not shouldSpoil then
              return false
            end
          end
        end

        if EL.PressTrinket(14, target, cursorSettings) then return "Handle Bottom Trinket"; end
      end
    end
  end
end
  


-- Interrupt
do
  Commons.InterruptWhitelistIDs = {
    396812,
    388392,
    388863,
    377389,
    396640,
    387843,
    209413,
    207980,
    208165,
    198595,
    198959,
    215433,
    199726,
    198750,
    373017,
    392451,
    385310,
    152818,
    -- 154327, -- Domination Manual Interrupt
    156776,
    398206,
    156718,
    153524,
    397888,
    397889,
    395859,
    396073,
    397914,
    387564,
    375602,
    386546,
    377488,
    373932,
    384365,
    386024,
    387411,
    387606,
    384808,
    373395,
    376725,
    192288,
    -- Underrot
    265089,
    265091,
    278755,
    278961,
    266106,
    272183,
    413044,
    265433,
    265487,
    260879,
    -- Freehold
    257397,
    281420,
    257784,
    259092,
    -- Neltharions Lair
    202108,
    202075,
    193585,
    -- Uldaman
    369400,
    369365,
    369411,
    369675,
    369823,
    369399,
    377500,
    -- Brackenhide Hollow
    367500,
    367503,
    382347,
    372711,
    374544,
    385029,
    382474,
    -- Neltharus
    378172,
    395427,
    372223,
    372538,
    384161,
    383656,
    396925,
    -- Vortex
    410870,
    88170,
    88186,
    87779,
    87761,
    86331,
    -- Halls of Infusion
    374045,
    374020,
    374339,
    374563,
    395694,
    374706,
    374699,
    385036,
    377384,
    377348,
    377402,
    376171,
    -- Dawn of the Infinite
    411994,
    415770,
    415435,
    415437,
    416256,
    400165,
    412922,
    417481,
    412378,
    412233,
    413427,
    --General
    396812, 388392, 388863, 377389, 396640, 387843, 209413, 207980, 208165, 198595, 198959, 215433, 199726, 198750, 373017, 392451, 385310, 152818,
    -- 154327, -- Domination Manual Interrupt
    156776, 398206, 156718, 153524, 397888, 397889, 395859, 396073, 397914, 387564, 375602, 386546, 377488, 373932, 384365, 386024, 387411, 387606, 384808, 373395, 376725, 192288,
    -- Underrot
    265089, 265091, 278755, 278961, 266106, 272183, 413044, 265433, 265487, 260879, 266209, 272180,
    -- Freehold
    257397, 281420, 257784, 259092,
    -- Neltharions Lair
    202108, 202075, 193585, 186269, 188587, 202181, 226296,
    -- Uldaman
    369400, 369365, 369411, 369675, 369823, 369399, 377500,
    -- Brackenhide Hollow
    367500, 367503, 382347, 372711, 374544, 385029, 382474,
    -- Neltharus
    378172, 395427, 372223, 372538, 384161, 383656, 396925, 372615, 378282,
    -- Vortex
    410870, 88170, 88186, 87779, 87761, 86331, 410760,
    -- Halls of Infusion
    374045, 374020, 374339, 374563, 395694, 374706, 374699, 385036, 377384, 377348, 377402, 376171,
    -- Dawn of the Infinite
    411994, 415770, 415435, 415437, 416256, 400165, 412922, 417481, 412378, 412233, 413427, 415439, 407124, 411300, 418200,
    --Atal'Dazar
    250096, 250368, 252781, 253517, 253544, 253583, 255041,
    --Blackrook Hold
    200248, 225573, 227913,
    --Darkheart Thicket
    200630, 201400, 201839, 204243, 225562,
    --Everbloom
    164887, 164965, 168082, 169825, 169839, 169840, 427459,
    --Throne of Tides
    76813, 429176,
    --Waycrest Manor
    263959, 264390, 265346, 265876, 266036, 271174, 278444,
  };
  Commons.StunWhitelistIDs = {
    210261,
    198959,
    398206,
    388392,
    395859,
    397889,
    397914,
    153524,
    215433,
    396812,
    372749,
    372735,
    370225,
    386526,
    384476,
    383823,
    386490,
    387615,
    382077,
    387564,
    386546,
    385536,
    387910,
    212784,
    199210,
    114646,
    397899,
    397931,
    -- Underrot
    265540,
    265376,
    265089,
    265091,
    278961,
    266106,
    272183,
    413044,
    -- Freehold
    257397,
    272402,
    281420,
    257784,
    257756,
    257739,
    -- Neltharions Lair
    193941,
    183526,
    202108,
    202075,
    193803,
    188587,
    200154,
    193585,
    -- Uldaman
    369400,
    369365,
    369423,
    369411,
    369674,
    369675,
    369823,
    369465,
    377486,
    377500,
    -- Brackenhide Hollow
    367484,
    367521,
    372711,
    385029,
    385039,
    -- Neltharus
    378818,
    371875,
    372223,
    384161,
    -- Vortex
    410870,
    88170,
    88186,
    87779,
    -- Halls of Infusion
    374045,
    374020,
    374339,
    374563,
    395694,
    376171,
    385036,
    377384,
    377348,
    -- Dawn of the Infinite
    412012,
    413606,
    419327,
    407535,
    --General
    210261, 198959, 398206, 388392, 395859, 397889, 397914, 153524, 215433, 396812, 372749, 372735, 370225, 386526, 384476, 383823, 386490, 387615, 382077, 387564, 386546, 385536, 387910, 212784, 199210, 114646, 397899, 397931,
    -- Underrot
    265540, 265376, 265089, 265091, 278961, 266106, 272183, 413044,
    -- Freehold
    257397, 272402, 281420, 257784, 257756, 257739, 257899, 258777,
    -- Neltharions Lair
    193941, 183526, 202108, 202075, 193803, 188587, 200154, 193585,
    -- Uldaman
    369400, 369365, 369423, 369411, 369674, 369675, 369823, 369465, 377486, 377500,
    -- Brackenhide Hollow
    367484, 367521, 372711, 385029, 385039,
    -- Neltharus
    378818, 371875, 372223, 384161,
    -- Vortex
    410870, 88170, 88186, 87779,
    -- Halls of Infusion
    374045, 374020, 374339, 374563, 395694, 376171, 385036, 377384, 377348,
    -- Dawn of the Infinite
    412012, 413606, 419327, 407535,
  };

  function Commons.Interrupt(Spell, Range, OffGCD, Unit, Macro)
    if not Unit then
      Unit = Target;
    end
    if Unit:IsInterruptible() and (Unit:CastPercentage() >= (EpicSettings.Settings["InterruptThreshold"] or 0) or Unit:IsChanneling()) and (not EpicSettings.Settings["InterruptOnlyWhitelist"] or Utils.ValueIsInArray(Commons.InterruptWhitelistIDs, Unit:CastSpellID()) or Utils.ValueIsInArray(Commons.InterruptWhitelistIDs, Unit:ChannelSpellID())) then
      if Spell:IsCastable() then
        if Macro then
          if EL.Press(Macro, not Unit:IsSpellInRange(Spell), nil, OffGCD) then return "Cast " .. Spell:Name() .. " (Interrupt)"; end
        else
          if EL.Press(Spell, not Unit:IsSpellInRange(Spell), nil, OffGCD) then return "Cast " .. Spell:Name() .. " (Interrupt)"; end
        end
      end
    end
  end

  function Commons.InterruptCursor(Spell, Macro, Range, OffGCD, Unit)
    if not Unit then
      Unit = Target;
    end
    if Unit:IsInterruptible() and (Unit:CastPercentage() >= (EpicSettings.Settings["InterruptThreshold"] or 0) or Unit:IsChanneling()) and (not EpicSettings.Settings["InterruptOnlyWhitelist"] or Utils.ValueIsInArray(Commons.InterruptWhitelistIDs, Unit:CastSpellID()) or Utils.ValueIsInArray(Commons.InterruptWhitelistIDs, Unit:ChannelSpellID())) then
      if Spell:IsCastable() then
        if EL.Press(Macro, not Unit:IsSpellInRange(Spell), nil, OffGCD) then return "Cast " .. Spell:Name() .. " (Interrupt)"; end
      end
    end
  end

  function Commons.InterruptWithStun(Spell, Range, OffGCD, Unit)
    if not Unit then
      Unit = Target;
    end
    if EpicSettings.Settings["InterruptWithStun"] and (Unit:CastPercentage() >= (EpicSettings.Settings["InterruptThreshold"] or 0) or Unit:IsChanneling()) then
      if (EpicSettings.Settings["InterruptOnlyWhitelist"] and (Utils.ValueIsInArray(Commons.StunWhitelistIDs, Unit:CastSpellID()) or Utils.ValueIsInArray(Commons.StunWhitelistIDs, Unit:ChannelSpellID()))) or (not EpicSettings.Settings["InterruptOnlyWhitelist"] and Unit:CanBeStunned()) then
        if Spell:IsCastable() then
            if EL.Press(Spell, not Unit:IsSpellInRange(Spell), nil, OffGCD) then return "Cast " .. Spell:Name() .. " (Interrupt With Stun)"; end
        end
      end
    end
  end


  function Commons.InterruptWithStunCursor(Spell, Macro, Range, OffGCD, Unit)
    if not Unit then
      Unit = Target;
    end
    if EpicSettings.Settings["InterruptWithStun"] and (Unit:CastPercentage() >= (EpicSettings.Settings["InterruptThreshold"] or 0) or Unit:IsChanneling()) then
      if (EpicSettings.Settings["InterruptOnlyWhitelist"] and (Utils.ValueIsInArray(Commons.StunWhitelistIDs, Unit:CastSpellID()) or Utils.ValueIsInArray(Commons.StunWhitelistIDs, Unit:ChannelSpellID()))) or (not EpicSettings.Settings["InterruptOnlyWhitelist"] and Unit:CanBeStunned()) then
        if Spell:IsCastable() then
          if EL.Press(Macro, not Unit:IsSpellInRange(Spell), nil, OffGCD) then return "Cast " .. Spell:Name() .. " (Interrupt With Stun)"; end
        end
      end
    end
  end

end

-- Old Cycle Unit
  --function Commons.CastCycle(Object, Enemies, Condition, OutofRange, OffGCD, DisplayStyle, MouseoverMacro, Immovable)
  --  if (Immovable and Player:IsMoving()) then return false; end
  --  local BestUnit, BestConditionValue = nil, nil;
  --  local CycleUnits = {};
  --  if Target and Target:Exists() and Player:CanAttack(Target) and (not Target:IsDeadOrGhost()) then
  --    tableinsert(CycleUnits, Target);
  --  end
  --  if Mouseover and Mouseover:Exists() and Player:CanAttack(Mouseover) and (not Mouseover:IsDeadOrGhost()) then
  --    tableinsert(CycleUnits, Mouseover);
  --  end
  --  for _, CycleUnit in pairs(CycleUnits) do
  --    if not CycleUnit:IsFacingBlacklisted() and not CycleUnit:IsUserCycleBlacklisted() and Condition(CycleUnit) and (CycleUnit:AffectingCombat() or CycleUnit:IsDummy()) then
  --      BestUnit, BestConditionValue = CycleUnit, Condition(CycleUnit);
  --    end
  --  end
  --  if BestUnit then
  --    if BestUnit:GUID() == Target:GUID() then
  --      return EL.Cast(Object, OffGCD, DisplayStyle, OutofRange);
  --    elseif Mouseover and Mouseover:Exists() and BestUnit:GUID() == Mouseover:GUID() and MouseoverMacro then
  --      return EL.Press(MouseoverMacro, OutofRange, nil, OffGCD);
  --    end
  --  end
  --  if Condition(Target) then
  --    return EL.Cast(Object, OffGCD, DisplayStyle, OutofRange);
  --  elseif Mouseover and Mouseover:Exists() and Player:CanAttack(Mouseover) and (not Mouseover:IsDeadOrGhost()) and MouseoverMacro and Condition(Mouseover) then
  --    return EL.Press(MouseoverMacro, OutofRange, nil, OffGCD);
  --  end
  --end

--TODO: Function that returns the number of units with a Debuff for cycle

-- Cycle Unit Helper
Commons.LastTargetSwap = 0
function Commons.CastCycle(Object, Enemies, Condition, OutofRange, OffGCD, DisplayStyle, MouseoverMacro, Immovable)
  local shouldCycle = EpicSettings.Toggles["cycle"] or false
  local cycleDelay = EpicSettings.Settings["cycleDelay"] or 500

  if Condition(Target) and (Target:AffectingCombat() or Target:IsDummy()) then
    return EL.Press(Object, OutofRange, Immovable, OffGCD)
  end
  if shouldCycle then
    local TargetGUID = Target:GUID()
    for _, CycleUnit in pairs(Enemies) do
      if CycleUnit:GUID() ~= TargetGUID and (CycleUnit:AffectingCombat() or CycleUnit:IsDummy()) and not CycleUnit:IsFacingBlacklisted() and (not CycleUnit:IsUserCycleBlacklisted()) and Condition(CycleUnit) then
        if (GetTime() - Commons.LastTargetSwap)*1000 >= cycleDelay then
          Commons.LastTargetSwap = GetTime()
          EL.EpicSettingsM = 100;
          return true;
        end
      end
    end
  end
end

do
  function Commons.TargetNextEnemy()
    local shouldCycle = EpicSettings.Toggles["cycle"] or false
    if shouldCycle and Player:AffectingCombat() and (not Target:Exists() or Target:HealthPercentage() <= 0) then
      if (GetTime() - Commons.LastTargetSwap)*1000 >= 500 then
        Commons.LastTargetSwap = GetTime()
        EL.EpicSettingsM = 100;
        return "Swapping to next Target";
      end
    end
    return false
  end
end

-- Old Target If Helper
-- function Commons.CastTargetIf(Object, Enemies, TargetIfMode, TargetIfCondition, Condition, OutofRange, OffGCD, DisplayStyle, MouseoverMacro, Immovable)
--   local TargetCondition = (not Condition or (Condition and Condition(Target)));
--   if (Immovable and Player:IsMoving()) then return false; end
--   if not EL.AoEON() and TargetCondition then
--     return EL.Cast(Object, OffGCD, DisplayStyle, OutofRange);
--   end
--   if EL.AoEON() then
--     local BestUnit, BestConditionValue = nil, nil;
--     local CycleUnits = {};
--     if Target and Target:Exists() then
--       tableinsert(CycleUnits, Target);
--     end
--     if Mouseover and Mouseover:Exists() then
--       tableinsert(CycleUnits, Mouseover);
--     end
--     for _, CycleUnit in pairs(CycleUnits) do
--       if not CycleUnit:IsFacingBlacklisted() and not CycleUnit:IsUserCycleBlacklisted() and (CycleUnit:AffectingCombat() or CycleUnit:IsDummy())
--         and (not BestConditionValue or Utils.CompareThis(TargetIfMode, TargetIfCondition(CycleUnit), BestConditionValue)) then
--         BestUnit, BestConditionValue = CycleUnit, TargetIfCondition(CycleUnit);
--       end
--     end
--     if BestUnit then
--       if BestUnit:GUID() == Target:GUID() and TargetCondition then
--         return EL.Cast(Object, OffGCD, DisplayStyle, OutofRange);
--       elseif Mouseover and Mouseover:Exists() and BestUnit:GUID() == Mouseover:GUID() and MouseoverMacro and ((Condition and Condition(Mouseover)) or not Condition) then
--         return EL.Press(MouseoverMacro, OutofRange, nil, OffGCD);
--       end
--     end
--     if TargetCondition then
--       return EL.Cast(Object, OffGCD, DisplayStyle, OutofRange);
--     elseif Mouseover and Mouseover:Exists() and MouseoverMacro and ((Condition and Condition(Mouseover)) or not Condition) then
--       return EL.Press(MouseoverMacro, OutofRange, nil, OffGCD);
--     end
--   end
-- end

-- Target If Helper
function Commons.CastTargetIf(Object, Enemies, TargetIfMode, TargetIfCondition, Condition, OutofRange, OffGCD, DisplayStyle, MouseoverMacro, Immovable)
  local shouldCycle = EpicSettings.Toggles["cycle"] or false
  local cycleDelay = EpicSettings.Settings["cycleDelay"] or 500

  local TargetCondition = (not Condition or (Condition and Condition(Target)));
  if (Immovable and Player:IsMoving()) then return false; end
  if shouldCycle then
    local BestUnit, BestConditionValue = nil, nil;
    for _, CycleUnit in pairs(Enemies) do
      if not CycleUnit:IsFacingBlacklisted() and not CycleUnit:IsUserCycleBlacklisted() and (CycleUnit:AffectingCombat() or CycleUnit:IsDummy())
        and (not BestConditionValue or Utils.CompareThis(TargetIfMode, TargetIfCondition(CycleUnit), BestConditionValue)) then
        BestUnit, BestConditionValue = CycleUnit, TargetIfCondition(CycleUnit);
      end
    end
    if BestUnit then
      if BestUnit:GUID() == Target:GUID() and TargetCondition then
        return EL.Cast(Object, OffGCD, DisplayStyle, OutofRange);
      elseif (GetTime() - Commons.LastTargetSwap)*1000 >= cycleDelay then
        --EL.Print("Swapping Target to "..BestUnit:ID());
        Commons.LastTargetSwap = GetTime()
        EL.EpicSettingsM = 100;
        return true;
      end
    end
  end
  if TargetCondition then
    return EL.Cast(Object, OffGCD, DisplayStyle, OutofRange);
  end
end

-- Mitigate
do
  Commons.MitigateIDs = {
    388911,
    193092,
    193668,
    381514,
    396019,
    397904,
    106823,
    106841,
    389804,
    377105,
    384978,
    384686,
    382836,
    -- Freehold
    222501,
    -- Dawn of the Infinite
    413013,
    413487,
    410254,
  };
  function Commons.ShouldMitigate()
    return Utils.ValueIsInArray(Commons.MitigateIDs, Target:CastSpellID()) or Utils.ValueIsInArray(Commons.MitigateIDs, Target:ChannelSpellID());
  end
end

-- Dispel Buffs
do
  Commons.DispellableEnrageBuffIDs = {
    -- Affix
    Spell(228318),
    Spell(390938),
    Spell(397410),
    Spell(190225),
    Spell(396018),
    -- Underrot
    Spell(265081),
    Spell(266209),
    -- Freehold
    Spell(257476),
    Spell(257739),
    Spell(257899),
    -- Neltharions Lair
    Spell(201983),
    -- Uldaman
    Spell(369806),
    -- Brackenhide Hollow
    Spell(382555),
    Spell(385827),
    -- Neltharus
    Spell(371875),
    -- Halls of Infusion
    Spell(377384),
    -- Dawn of the Infinite
    Spell(412695),
  };
  function Commons.UnitHasEnrageBuff(U)
    -- for i = 1, #Commons.DispellableEnrageBuffIDs do
    --   if U:BuffUp(Commons.DispellableEnrageBuffIDs[i], true) then
    --     return true;
    --   end
    -- end
    -- return false;
    for i=1,21 do
      local b,_,_,type = UnitBuff(U:ID(), i);
      if b ~= nil and type == "" then
        return true;
      end
    end
    return false;
  end

  Commons.DispellableMagicBuffIDs = {
    Spell(392454),
    Spell(398151),
    Spell(386223),
    -- Underrot
    Spell(265091),
    Spell(266201),
    -- Uldaman
    Spell(369400),
    Spell(369823),
    -- Neltharus
    Spell(378149),
    -- Vortex
    Spell(411743),
    -- Halls of Infusion
    Spell(395694),
    Spell(377402),
  };
  function Commons.UnitHasMagicBuff(U)
    -- for i = 1, #Commons.DispellableMagicBuffIDs do
    --   if U:BuffUp(Commons.DispellableMagicBuffIDs[i], true) then
    --     return true;
    --   end
    -- end
    -- return false;
    for i=1,21 do
      local b,_,_,type = UnitBuff(U:ID(), i);
      if b ~= nil and type == "Magic" then
        return true;
      end
    end
    return false;
  end
end

-- Dispel Debuffs
do
  Commons.DispellableMagicDebuffs = {
    Spell(388392),
    Spell(391977),
    -- Manual
    --Spell(374352),
    Spell(207278),
    Spell(207981),
    Spell(372682),
    Spell(392641),
    Spell(397878),
    Spell(114803),
    Spell(395872),
    Spell(386549),
    Spell(377488),
    Spell(386025),
    Spell(384686),
    Spell(376827),
    Spell(106113),
    Spell(209516),
    Spell(215429),
    -- Underrot
    Spell(266265),
    -- Freehold
    Spell(257908),
    Spell(256106),
    -- Uldaman
    Spell(377405),
    -- Brackenhide Hollow
    Spell(373899),
    Spell(381379),
    -- Vortex
    Spell(410997),
    Spell(87618),
    -- Halls of Infusion
    Spell(374724),
--     Spell(389179), -- manual
    Spell(383935),
    Spell(385963),
    Spell(387359),
    -- Dawn of the Infinite
    -- Spell(415554), Chronoburst which should be manually dispelled
    -- Spell(404141), Chrono Faded which should be manually dispelled
    Spell(416716),
    Spell(411994),
    Spell(415436),
    Spell(415437),
    Spell(413547),
    Spell(400681),
    Spell(401667),
    Spell(407121),
    Spell(417030),
    Spell(412027),
    Spell(412131),
    Spell(411644),
    Spell(413606),
    Spell(418200),
    Spell(401667),
    Spell(412378),
    -- Atal'Dazar
    Spell(253562),
    Spell(255371),
    Spell(255041),
    Spell(255582),
    -- Black Rook Hold
    Spell(200084),
    Spell(194960),
    Spell(225909),
    -- Darkheart Thicket
    Spell(200642),
    Spell(204246),
    Spell(200182),
    Spell(201902),
    -- Everbloom
    Spell(428084),
    Spell(427863),
    Spell(169840),
    Spell(164965),
    Spell(169839),
    Spell(426849),
    -- Throne of Tides
    Spell(75992),
    Spell(429048),
    Spell(428103),
    -- Waycrest Manor
    Spell(265881),
    Spell(264378),
    Spell(264390),
    Spell(264407),
    -- Amirdrassil
    Spell(420856), -- Council
    Spell(417807), -- Fyrakk
    Spell(421326), -- Larodar
  };
  function Commons.UnitHasMagicDebuff(U)
    -- for i = 1, #Commons.DispellableMagicDebuffs do
    --   if U:DebuffUp(Commons.DispellableMagicDebuffs[i], true) then
    --     return true;
    --   end
    -- end
    -- return false;
    for i=1,21 do
      local b,_,_,type = UnitDebuff(U:ID(), i);
      if b ~= nil and type == "Magic" then
        return true;
      end
    end
    return false;
  end

  Commons.DispellableDiseaseDebuffs = {
    -- Underrot
    Spell(278961),
    -- Freehold
    Spell(258323),
    Spell(257775),
    -- Uldaman
    Spell(369818),
    -- Brackenhide Hollow
    Spell(368081),
    Spell(385039),
    Spell(396305),
    Spell(377864),
    Spell(382808),
    -- Atal'Dazar
    Spell(250372),
    -- Darkheart Thicket
    Spell(201365),
    -- Throne of Tides
    Spell(76363),
    -- Waycrest Manor
    Spell(261440),
    Spell(264050),
  };
  function Commons.UnitHasDiseaseDebuff(U)
    -- for i = 1, #Commons.DispellableDiseaseDebuffs do
    --   if U:DebuffUp(Commons.DispellableDiseaseDebuffs[i], true) then
    --     return true;
    --   end
    -- end
    -- return false;
    for i=1,21 do
      local b,_,_,type = UnitDebuff(U:ID(), i);
      if b ~= nil and type == "Disease" then
        return true;
      end
    end
    return false;
  end

  Commons.DispellablePoisonDebuffs = {
    -- Dispellable Debuffs
    Spell(123456), --TODO Fix Spell IDs
    -- Atal'Dazar
    Spell(252687),
    -- Darkheart Thicket
    Spell(200684),
    Spell(198904),
    -- Everbloom
    Spell(165123),
    Spell(169658),
    Spell(427460),
    -- Throne of Tides
    Spell(76516),
    --- Waycrest Manor
    Spell(264520),
  };
  function Commons.UnitHasPoisonDebuff(U)
    -- for i = 1, #Commons.DispellablePoisonDebuffs do
    --   if U:DebuffUp(Commons.DispellablePoisonDebuffs[i], true) then
    --     return true;
    --   end
    -- end
    -- return false;
    for i=1,21 do
      local b,_,_,type = UnitDebuff(U:ID(), i);
      if b ~= nil and type == "Poison" then
        return true;
      end
    end
    return false;
  end

  Commons.DispellableCurseDebuffs = {
    Spell(397911),
    Spell(387615),
    -- Uldaman
    Spell(369365),
    -- Dawn of the Infinite
    Spell(413618),
  };
  function Commons.UnitHasCurseDebuff(U)
    -- for i = 1, #Commons.DispellableCurseDebuffs do
    --   if U:DebuffUp(Commons.DispellableCurseDebuffs[i], true) then
    --     return true;
    --   end
    -- end
    -- return false;
    for i=1,21 do
      local b,_,_,type = UnitDebuff(U:ID(), i);
      if b ~= nil and type == "Curse" then
        return true;
      end
    end
    return false;
  end
end

--Check if Unit has a debuff from a list
function Commons.UnitHasDebuffFromList(U, L)
  for i = 1, #L do
    if U:DebuffUp(L[i], true) then
      return true;
    end
  end
  return false;
end

-- Is in Solo Mode?
function Commons.IsSoloMode()
  return not Player:IsInRaid() and not Player:IsInParty();
end

-- Get friendly units.
do
  local PartyUnits = {};
  local RaidUnits = {};
  function Commons.FriendlyUnits(ExcludePlayer, maxRaid)
    PartyUnits = {}
    local raidunits = maxRaid or 30
    if #PartyUnits == 0 then
      if ExcludePlayer then
        --Skipping player on friendly units
      else
        tableinsert(PartyUnits, Player);
      end

      for i = 1, 4 do
        local PartyUnitKey = stringformat("party%d", i);
        tableinsert(PartyUnits, Party[PartyUnitKey]);
      end
    end
    if #RaidUnits == 0 then
      for i = 1, raidunits do
        local RaidUnitKey = stringformat("raid%d", i);
        tableinsert(RaidUnits, Raid[RaidUnitKey]);
      end
    end
    if Commons.IsSoloMode() then
      return {Player};
    elseif Player:IsInParty() and not Player:IsInRaid() then
      return PartyUnits;
    elseif Player:IsInRaid() then
      return RaidUnits;
    end
    return {};
  end
end

do
  Commons.DispellableDebuffs = {};
  -- Get dispellable friendly units.
  function Commons.DispellableFriendlyUnits(maxRaid)
    local FriendlyUnits = Commons.FriendlyUnits(false,maxRaid);
    local DispellableUnits = {};
    for i = 1, #FriendlyUnits do
      local DispellableUnit = FriendlyUnits[i];
      for j = 1, #Commons.DispellableDebuffs do
        if DispellableUnit:DebuffUp(Commons.DispellableDebuffs[j], true) then
          tableinsert(DispellableUnits, DispellableUnit);
        end
      end
    end
    return DispellableUnits;
  end
  function Commons.DispellableFriendlyUnit(maxRaid)
    local DispellableFriendlyUnits = Commons.DispellableFriendlyUnits(maxRaid);
    local DispellableFriendlyUnitsCount = #DispellableFriendlyUnits;
    if DispellableFriendlyUnitsCount > 0 then
      for i = 1, DispellableFriendlyUnitsCount do
        local DispellableFriendlyUnit = DispellableFriendlyUnits[i];
        if not Commons.UnitGroupRole(DispellableFriendlyUnit) == "TANK" then
          return DispellableFriendlyUnit;
        end
      end
      return DispellableFriendlyUnits[1];
    end
  end
end

-- Get assigned unit role.
function Commons.UnitGroupRole(GroupUnit)
  if GroupUnit:IsAPlayer() then
    return UnitGroupRolesAssigned(GroupUnit:ID());
  end
end

-- Mind Control Blacklist
do
  Commons.MindControllSpells = {};
  function Commons.IsMindControlled(FriendlyUnit)
    if FriendlyUnit and FriendlyUnit:Exists() and not FriendlyUnit:IsDeadOrGhost() then
      for i = 1, #Commons.MindControllSpells do
        if FriendlyUnit:DebuffUp(Commons.MindControllSpells[i], true) then
          return true;
        end
      end
    end
    return false;
  end
end

-- Get named friendly unit.
function Commons.NamedUnit(Range, Name, maxRaid)
  if not Range then Range = 40; end
  local NamedUnit;
  local FriendlyUnits = Commons.FriendlyUnits(false, maxRaid);
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if FriendlyUnit and FriendlyUnit:Exists() and (not FriendlyUnit:IsDeadOrGhost()) and (not Commons.IsMindControlled(FriendlyUnit)) then
      if FriendlyUnit:Name() == Name then
        NamedUnit = FriendlyUnit;
      end
    end
  end
  return NamedUnit;
end

-- Get lowest friendly unit.
function Commons.LowestFriendlyUnit(Range, Role, maxRaid)
  if not Range then Range = 40; end
  local LowestUnit;
  local FriendlyUnits = Commons.FriendlyUnits(false, maxRaid);
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if Role == nil or Commons.UnitGroupRole(FriendlyUnit) == Role then
      if FriendlyUnit and FriendlyUnit:Exists() and (not FriendlyUnit:IsDeadOrGhost()) and (not Commons.IsMindControlled(FriendlyUnit)) then
        if (not LowestUnit) or FriendlyUnit:HealthPercentage() < LowestUnit:HealthPercentage() then
          LowestUnit = FriendlyUnit;
        end
      end
    end
  end
  return LowestUnit;
end

-- Get lowest friendly unit with Buff's remaining time under Time
function Commons.LowestFriendlyUnitRefreshableBuff(Buff, Time, Range, Role, ExcludePlayer, maxRaid)
  if not Range then Range = 40; end
  local LowestUnit;
  local FriendlyUnits = Commons.FriendlyUnits(false, maxRaid);
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if Role == nil or Commons.UnitGroupRole(FriendlyUnit) == Role then
      if FriendlyUnit and (FriendlyUnit:BuffDown(Buff) or FriendlyUnit:BuffRemains(Buff) < Time) and FriendlyUnit:Exists() and (not FriendlyUnit:IsDeadOrGhost()) and (not Commons.IsMindControlled(FriendlyUnit)) then
        if (not LowestUnit) or FriendlyUnit:HealthPercentage() < LowestUnit:HealthPercentage() then
          LowestUnit = FriendlyUnit;
        end
      end
    end
  end
  return LowestUnit;
end

-- Get friendly units count below health percentage.
function Commons.FriendlyUnitsBelowHealthPercentageCount(HealthPercentage, maxRaid, Range)
  if not Range then Range = 40; end
  local Count = 0;
  local FriendlyUnits = Commons.FriendlyUnits(false, maxRaid);
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if FriendlyUnit:Exists() and not FriendlyUnit:IsDeadOrGhost() then
      if FriendlyUnit:HealthPercentage() <= HealthPercentage then
        Count = Count + 1;
      end
    end
  end
  return Count;
end

-- Get friendly Named units that need a buff refreshed
function Commons.FriendlyNamedUnitsWithRefreshableBuff(Buff, Time, Range, ...)
  local arg = {...}
  if not Range then Range = 40; end
  local FriendlyUnits = {}
  local i = 1
  for _, u in pairs(arg) do
    local unit = Commons.NamedUnit(Range, u)
    if unit and (unit:BuffDown(Buff) or unit:BuffRemains(Buff) < Time) then
      FriendlyUnits[i] = Commons.NamedUnit(Range, u)
      i = i+1
    end
  end
  return FriendlyUnits;
end

-- Get friendly units with a buff.
function Commons.FriendlyUnitsWithBuffCount(Buff, OnlyTanks, OnlyNonTanks, maxRaid)
  local Count = 0;
  local FriendlyUnits = Commons.FriendlyUnits(false, maxRaid);
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if FriendlyUnit:Exists() and not FriendlyUnit:IsDeadOrGhost() and (not OnlyTanks or Commons.UnitGroupRole(FriendlyUnit) == "TANK") and (not OnlyNonTanks or (Commons.UnitGroupRole(FriendlyUnit) ~= "TANK")) then
      if FriendlyUnit:BuffUp(Buff) and not FriendlyUnit:BuffRefreshable(Buff) then
        Count = Count + 1;
      end
    end
  end
  return Count;
end

-- Get friendly units with a debuff from a list
function Commons.FriendlyUnitsWithDebuffFromList(DebuffList, Range, maxRaid)
  local UnitsWithDebuff = {}
  if not Range then Range = 40; end
  local FriendlyUnits = Commons.FriendlyUnits(false, maxRaid);
  local j = 1
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if FriendlyUnit:Exists() and not FriendlyUnit:IsDeadOrGhost() then
      if Commons.UnitHasDebuffFromList(FriendlyUnit, DebuffList) then
        UnitsWithDebuff[j] = FriendlyUnits[i]
        j = j+1
      end
    end
  end
  return UnitsWithDebuff;
end

-- Get friendly units with a buff under HP
function Commons.FriendlyUnitsWithBuffBelowHealthPercentageCount(Buff, HealthPercentage, OnlyTanks, OnlyNonTanks, maxRaid)
  local Count = 0;
  local FriendlyUnits = Commons.FriendlyUnits(false, maxRaid);
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if FriendlyUnit:Exists() and FriendlyUnit:HealthPercentage() <= HealthPercentage and not FriendlyUnit:IsDeadOrGhost() and (not OnlyTanks or Commons.UnitGroupRole(FriendlyUnit) == "TANK") and (not OnlyNonTanks or (Commons.UnitGroupRole(FriendlyUnit) ~= "TANK")) then
      if FriendlyUnit:BuffUp(Buff) and not FriendlyUnit:BuffRefreshable(Buff) then
        Count = Count + 1;
      end
    end
  end
  return Count;
end

-- Get friendly units without a buff.
function Commons.FriendlyUnitsWithoutBuffCount(Buff, OnlyTanks, OnlyNonTanks, maxRaid)
  local FriendlyUnits = Commons.FriendlyUnits(false, maxRaid);
  local Count = #FriendlyUnits;
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if FriendlyUnit:Exists() and not FriendlyUnit:IsDeadOrGhost() and (not OnlyTanks or Commons.UnitGroupRole(FriendlyUnit) == "TANK") and (not OnlyNonTanks or (Commons.UnitGroupRole(FriendlyUnit) ~= "TANK")) then
      if FriendlyUnit:BuffUp(Buff) and not FriendlyUnit:BuffRefreshable(Buff) then
        Count = Count - 1;
      end
    end
  end
  return Count;
end

-- Get friendly units without a buff under HP
function Commons.FriendlyUnitsWithoutBuffBelowHealthPercentageCount(Buff, HealthPercentage, OnlyTanks, OnlyNonTanks, maxRaid)
  local FriendlyUnits = Commons.FriendlyUnits(false, maxRaid);
  local Count = #FriendlyUnits;
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if FriendlyUnit:Exists() and FriendlyUnit:HealthPercentage() <= HealthPercentage and not FriendlyUnit:IsDeadOrGhost() and (not OnlyTanks or Commons.UnitGroupRole(FriendlyUnit) == "TANK") and (not OnlyNonTanks or (Commons.UnitGroupRole(FriendlyUnit) ~= "TANK")) then
      if FriendlyUnit:BuffUp(Buff) and not FriendlyUnit:BuffRefreshable(Buff) then
        Count = Count - 1;
      end
    end
  end
  return Count;
end

-- Get dead friendly units count.
function Commons.DeadFriendlyUnitsCount()
  local Count = 0;
  local FriendlyUnits = Commons.FriendlyUnits();
  for i = 1, #FriendlyUnits do
    local FriendlyUnit = FriendlyUnits[i];
    if FriendlyUnit:IsDeadOrGhost() then
      Count = Count + 1;
    end
  end
  return Count;
end


Commons.LastFocusSwap = 0
-- Focus Specified Unit
function Commons.FocusSpecifiedUnit(UnitToFocus, Range)
  local cycleDelay = 500
  if not Range then Range = 40; end
  if UnitToFocus ~= nil and (Focus == nil or not Focus:Exists() or UnitToFocus:GUID() ~= Focus:GUID()) then
    local FocusUnitKey = "Focus" .. Utils.UpperCaseFirst(UnitToFocus:ID())
    if (GetTime() - Commons.LastFocusSwap)*1000 >= cycleDelay then
      Commons.LastFocusSwap = GetTime()
      --if EL.Press(Macros[FocusUnitKey], nil, nil, true) then return "focus " .. NewFocusUnit:ID() .. " focus_unit 1"; end
      if UnitToFocus:ID() == "player" then
        --EL.Print("Focusing "..UnitToFocus:ID());
        EL.ReturnFocus = 50;
        return "Changing Focus to player"
      elseif UnitToFocus:ID() == "Target" then
        --EL.Print("Focusing "..UnitToFocus:ID());
        EL.ReturnFocus = 60;
        return "Changing Focus to target"
      elseif string.find(UnitToFocus:ID(), "Party") then
        --EL.Print("Focusing "..UnitToFocus:ID());
        EL.ReturnFocus = 50+tonumber(string.sub(UnitToFocus:ID(), 6));
        return "Changing Focus to party"..tonumber(string.sub(UnitToFocus:ID(), 6))
      elseif string.find(UnitToFocus:ID(), "Raid") then
        --EL.Print("Focusing "..UnitToFocus:ID());
        EL.ReturnFocus = string.sub(UnitToFocus:ID(), 5);
        return "Changing Focus to raid"..string.sub(UnitToFocus:ID(), 5)
      end
      --return EL.Press(Macros[FocusUnitKey], nil, nil, true);
      return "Changing Focus"
    end
  else
    EL.ReturnFocus = 0
    return false
  end
end

-- Focus Unit With a Debuff From a List
function Commons.FocusUnitWithDebuffFromList(DebuffList, Range, maxRaid)
  local cycleDelay = 500
  if not Range then Range = 40; end
  local NewFocusUnit = nil
  if Commons.FriendlyUnitsWithDebuffFromList(DebuffList, Range, maxRaid) then
    NewFocusUnit = Commons.FriendlyUnitsWithDebuffFromList(DebuffList, Range, maxRaid)[1]
  end
  if NewFocusUnit ~= nil and (Focus == nil or not Focus:Exists() or NewFocusUnit:GUID() ~= Focus:GUID()) then
    local FocusUnitKey = "Focus" .. Utils.UpperCaseFirst(NewFocusUnit:ID())
    if (GetTime() - Commons.LastFocusSwap)*1000 >= cycleDelay then
      Commons.LastFocusSwap = GetTime()
      --if EL.Press(Macros[FocusUnitKey], nil, nil, true) then return "focus " .. NewFocusUnit:ID() .. " focus_unit 1"; end
      if NewFocusUnit:ID() == "player" then
        EL.ReturnFocus = 50;
        return "Changing Focus to player"
      elseif NewFocusUnit:ID() == "Target" then
        EL.ReturnFocus = 60;
        return "Changing Focus to target"
      elseif string.find(NewFocusUnit:ID(), "Party") then
        EL.ReturnFocus = 50+tonumber(string.sub(NewFocusUnit:ID(), 6));
        return "Changing Focus to party"..tonumber(string.sub(NewFocusUnit:ID(), 6))
      elseif string.find(NewFocusUnit:ID(), "Raid") then
        EL.ReturnFocus = string.sub(NewFocusUnit:ID(), 5);
        return "Changing Focus to raid"..string.sub(NewFocusUnit:ID(), 5)
      end
      --return EL.Press(Macros[FocusUnitKey], nil, nil, true);
      return "Changing Focus"
    end
  else
    EL.ReturnFocus = 0
    return false
  end
end

-- Get Focus Unit
function Commons.GetFocusUnit(IncludeDispellableUnits, Range, Role, maxRaid)
  if not Range then Range = 40; end
  if Commons.TargetIsValidHealableNpc() then return Target; end
  if Commons.IsSoloMode() then
     return Player; end

  if IncludeDispellableUnits then
    local DispellableFriendlyUnit = Commons.DispellableFriendlyUnit(maxRaid);
    if DispellableFriendlyUnit then
      return DispellableFriendlyUnit;
    end
  end
  local LowestFriendlyUnit = Commons.LowestFriendlyUnit(Range, Role, maxRaid);
  if LowestFriendlyUnit then return LowestFriendlyUnit; end
end

-- Focus Unit
function Commons.FocusUnit(IncludeDispellableUnits, Macros, Range, Role, maxRaid)
  local cycleDelay = 500
  if not Range then Range = 40; end
  local NewFocusUnit = Commons.GetFocusUnit(IncludeDispellableUnits, Range, Role, maxRaid);
  if NewFocusUnit ~= nil and (Focus == nil or not Focus:Exists() or NewFocusUnit:GUID() ~= Focus:GUID()) then
    local FocusUnitKey = "Focus" .. Utils.UpperCaseFirst(NewFocusUnit:ID())
    if (GetTime() - Commons.LastFocusSwap)*1000 >= cycleDelay then
      Commons.LastFocusSwap = GetTime()
      --if EL.Press(Macros[FocusUnitKey], nil, nil, true) then return "focus " .. NewFocusUnit:ID() .. " focus_unit 1"; end
      if NewFocusUnit:ID() == "player" then
        --EL.Print("Focusing "..NewFocusUnit:ID());
        EL.ReturnFocus = 50;
        return "Changing Focus to player"
      elseif NewFocusUnit:ID() == "Target" then
        --EL.Print("Focusing "..NewFocusUnit:ID());
        EL.ReturnFocus = 60;
        return "Changing Focus to target"
      elseif string.find(NewFocusUnit:ID(), "Party") then
        --EL.Print("Focusing "..NewFocusUnit:ID());
        EL.ReturnFocus = 50+tonumber(string.sub(NewFocusUnit:ID(), 6));
        return "Changing Focus to party"..tonumber(string.sub(NewFocusUnit:ID(), 6))
      elseif string.find(NewFocusUnit:ID(), "Raid") then
        --EL.Print("Focusing "..NewFocusUnit:ID());
        EL.ReturnFocus = string.sub(NewFocusUnit:ID(), 5);
        return "Changing Focus to raid"..string.sub(NewFocusUnit:ID(), 5)
      end
      --return EL.Press(Macros[FocusUnitKey], nil, nil, true);
      return "Changing Focus"
    end
  else
    EL.ReturnFocus = 0
    return false
  end
end

-- Get Focus Unit With Buff Remaining less than Time
function Commons.GetFocusUnitRefreshableBuff(Buff, Time, Range, Role, ExcludePlayer, maxRaid)
  if not Range then Range = 40; end
  if Commons.TargetIsValidHealableNpc() then return Target; end
  if Commons.IsSoloMode() then return Player; end
  local LowestFriendlyUnit = Commons.LowestFriendlyUnitRefreshableBuff(Buff, Time, Range, Role, ExcludePlayer, maxRaid);
  if LowestFriendlyUnit then return LowestFriendlyUnit; end
end

-- Focus Unit With Buff Remaining less than Time
function Commons.FocusUnitRefreshableBuff(Buff, Time, Range, Role, ExcludePlayer, maxRaid)
  local cycleDelay = 500
  if not Range then Range = 40; end
  local NewFocusUnit = Commons.GetFocusUnitRefreshableBuff(Buff, Time, Range, Role, ExcludePlayer, maxRaid);
  if NewFocusUnit ~= nil and (Focus == nil or not Focus:Exists() or NewFocusUnit:GUID() ~= Focus:GUID()) then
    local FocusUnitKey = "Focus" .. Utils.UpperCaseFirst(NewFocusUnit:ID())
    if (GetTime() - Commons.LastFocusSwap)*1000 >= cycleDelay then
      Commons.LastFocusSwap = GetTime()
      if NewFocusUnit:ID() == "player" then
        EL.ReturnFocus = 50;
        return "Changing Focus to player"
      elseif NewFocusUnit:ID() == "Target" then
        EL.ReturnFocus = 60;
        return "Changing Focus to target"
      elseif string.find(NewFocusUnit:ID(), "Party") then
        EL.ReturnFocus = 50+tonumber(string.sub(NewFocusUnit:ID(), 6));
        return "Changing Focus to party"..tonumber(string.sub(NewFocusUnit:ID(), 6))
      elseif string.find(NewFocusUnit:ID(), "Raid") then
        EL.ReturnFocus = string.sub(NewFocusUnit:ID(), 5);
        return "Changing Focus to raid"..string.sub(NewFocusUnit:ID(), 5)
      end
      return "Changing Focus"
    end
  else
    EL.ReturnFocus = 0
    return false
  end
end

function Commons.IsTankBelowHealthPercentage(HPSetting, maxRaid)
    local lowestUnit = Commons.LowestFriendlyUnit(40, "TANK", maxRaid);
    if lowestUnit then
      return lowestUnit:HealthPercentage() < HPSetting
    else
      return false
    end
end

-- Settings Utils
function Commons.AreUnitsBelowHealthPercentage(HPSetting, MinPlayersSetting)
  if Commons.IsSoloMode() or (Player:IsInParty() and (not Player:IsInRaid())) then
    return Commons.FriendlyUnitsBelowHealthPercentageCount(HPSetting) >= MinPlayersSetting
  elseif Player:IsInRaid() then
    return Commons.FriendlyUnitsBelowHealthPercentageCount(HPSetting) >= MinPlayersSetting
  end
end

-- Group Buffs
function Commons.GroupBuffMissing(spell)
  local range = 40;
  local buffIDs = { 381732, 381741, 381746, 381748, 381749, 381750, 381751, 381752, 381753, 381754, 381756, 381757, 381758 };
  if spell:Name() == "Battle Shout" then range = 100; end
  local Group;
  if UnitInRaid("player") then
    Group = Unit.Raid;
  elseif UnitInParty("player") then
    Group = Unit.Party;
  else
    return false;
  end
  for _, Char in pairs(Group) do
    if spell:Name() == "Blessing of the Bronze" then
      if Char:Exists() and Char:IsSpellInRange(spell) then
        for _, v in pairs(buffIDs) do
          if Char:BuffUp(EL.Spell(v)) then return false; end
        end
        return true;
      end
    else
      if Char:Exists() and Char:IsSpellInRange(spell) and Char:BuffDown(spell, true) then
        return true;
      end
    end
  end
  return false;
end

-- Timers
do
  Commons.Timers = {};
  function Commons.InitTimers()
    if IsAddOnLoaded("DBM-Core") then
      -- Currently unsupported.
    elseif IsAddOnLoaded("BigWigs") then
      local startTimerCallback = function(...)
        local _, _, spellId, _, duration, icon = ...;
        if spellId == nil then
          if icon == 134062 then
            spellId = "Break";
          elseif icon == 132337 then
            spellId = "Pull";
          else
            return;
          end
        end
        
        for i = 0, #Commons.Timers do
          if Commons.Timers[i] ~= nil and Commons.Timers[i].id == spellId then
            Commons.Timers[i].time = GetTime() + duration;
            return;
          end
        end
        
        local timer = {};
        timer.id = spellId;
        timer.time = GetTime() + duration;
        tableinsert(Commons.Timers, timer);
      end
      local stopTimerCallback = function(...)
        local _, _, spellId = ...;
        for i = 0, #Commons.Timers do
          if Commons.Timers[i] ~= nil and Commons.Timers[i].id == spellId then
            Commons.Timers[i] = nil;
            return;
          end
        end
      end
      local cleanupTimersCallback = function(...)
        for i = 0, #Commons.Timers do
          Commons.Timers[i] = nil;
        end
      end
      local callback = {};
      BigWigsLoader.RegisterMessage(callback, "BigWigs_StartBar", startTimerCallback);
      BigWigsLoader.RegisterMessage(callback, "BigWigs_StopBar", stopTimerCallback);
      BigWigsLoader.RegisterMessage(callback, "BigWigs_StopBars", cleanupTimersCallback);
      BigWigsLoader.RegisterMessage(callback, "BigWigs_OnBossDisable", cleanupTimersCallback);
      BigWigsLoader.RegisterMessage(callback, "BigWigs_OnPluginDisable", cleanupTimersCallback);
    end
  end
  
  function Commons.PulseTimers()
    if IsAddOnLoaded("DBM-Core") then
      -- Currently unsupported.
    elseif IsAddOnLoaded("BigWigs") then
      for i = 0, #Commons.Timers do
        if Commons.Timers[i] ~= nil then
          if Commons.Timers[i].time < GetTime() then
            Commons.Timers[i] = nil;
          end
        end
      end
    end
  end

  function Commons.GetTimer(spellId)
    for i = 0, #Commons.Timers do
      if Commons.Timers[i] ~= nil and Commons.Timers[i].id == spellId then
        local time = Commons.Timers[i].time - GetTime();
        if time < 0 then
          return nil;
        else
          return time;
        end
      end
    end
    return nil;
  end

  function Commons.GetPullTimer()
    return Commons.GetTimer("Pull");
  end
  
  function Commons.GetBreakTimer()
    return Commons.GetTimer("Break");
  end
end