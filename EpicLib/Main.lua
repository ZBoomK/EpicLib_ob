--- ============================ HEADER ============================
-- reup
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...;
-- EpicLib
local EL = EpicLib;
local Cache = EpicCache;
local Unit = EL.Unit;
local Player = Unit.Player;
local Spell = EL.Spell;

-- Lua
local mathmax = math.max;
local mathmin = math.min;
local tableinsert = table.insert;
local tonumber = tonumber;
local tostring = tostring;
local type = type;
-- File Locals
local PrevResult, CurrResult;

-- Commons
local Everyone = EL.Commons.Everyone



-- Add a button
EL.Toggles = {};
--- ======= MAIN =======
local EnabledRotation = {
  -- Death Knight
    [250]   = "Epix_DeathKnight",   -- Blood
    [251]   = "Epix_DeathKnight",   -- Frost
    [252]   = "Epix_DeathKnight",   -- Unholy
  -- Demon Hunter
    [577]   = "Epix_DemonHunter",   -- Havoc
    [581]   = "Epix_DemonHunter",   -- Vengeance
  -- Druid
    [102]   = "Epix_Druid",         -- Balance
    --[103]   = "Epix_Druid",         -- Feral
    --[104]   = "Epix_Druid",         -- Guardian
    [105]   = "Epix_Druid",         -- Restoration
  -- Evoker
    [1467]  = "Epix_Evoker",        -- Devastation
    [1468] = "Epix_Evoker",         -- Preservation
    --[1473]  = "Epix_Evoker",        -- Augmentation
  -- Hunter
    [253]   = "Epix_Hunter",        -- Beast Mastery
    [254]   = "Epix_Hunter",        -- Marksmanship
    [255]   = "Epix_Hunter",        -- Survival
  -- Mage
    [62]    = "Epix_Mage",          -- Arcane
    [63]    = "Epix_Mage",          -- Fire
    [64]    = "Epix_Mage",          -- Frost
  -- Monk
    --[268]   = "Epix_Monk",          -- Brewmaster
    --[269]   = "Epix_Monk",          -- Windwalker
    [270]   = "Epix_Monk",          -- Mistweaver
  -- Paladin
    --[65]    = "Epix_Paladin",       -- Holy
    [66]    = "Epix_Paladin",       -- Protection
    [70]    = "Epix_Paladin",       -- Retribution
  -- Priest
    [256]   = "Epix_Priest",        -- Discipline
    [257]   = "Epix_Priest",        -- Holy
    [258]   = "Epix_Priest",        -- Shadow
  -- Rogue
    [259]   = "Epix_Rogue",         -- Assassination
    [260]   = "Epix_Rogue",         -- Outlaw
    [261]   = "Epix_Rogue",         -- Subtlety
  -- Shaman
    [262]   = "Epix_Shaman",        -- Elemental
    [263]   = "Epix_Shaman",        -- Enhancement
    [264]   = "Epix_Shaman",        -- Restoration
  -- Warlock
    [265]   = "Epix_Warlock",       -- Affliction
    [266]   = "Epix_Warlock",       -- Demonology
    --[267]   = "Epix_Warlock",       -- Destruction
  -- Warrior
    [71]    = "Epix_Warrior",       -- Arms
    [72]    = "Epix_Warrior",       -- Fury
    [73]    = "Epix_Warrior"        -- Protection
};

local LatestSpecIDChecked = 0;
function EL.PulseInit ()
  local Spec = GetSpecialization();
  -- Delay by 1 second until the WoW API returns a valid value.
  if Spec == nil then
    EL.PulseInitialized = false;
    C_Timer.After(1, function ()
      EL.PulseInit();
    end
    );
  else
    -- Force a refresh from the Core
    Cache.Persistent.Player.Spec = {GetSpecializationInfo(Spec)};
    local SpecID = Cache.Persistent.Player.Spec[1];

    -- Delay by 1 second until the WoW API returns a valid value.
    if SpecID == nil then
      EL.PulseInitialized = false;
      C_Timer.After(1, function ()
        EL.PulseInit();
      end
      );
    else
      -- Fill Rotation Setting
      local RotationIsValid = EL.Utils.ValueIsInTable(EnabledRotation, EnabledRotation[SpecID]);
      -- Load the Class Module if it's possible and not already loaded
      if RotationIsValid and not IsAddOnLoaded(EnabledRotation[SpecID]) then
        LoadAddOn(EnabledRotation[SpecID]);
        EL.Frame:SetScript("OnUpdate", EL.Pulse);
        EL.LoadOverrides(SpecID)
      end

      -- Check if there is a Rotation for this Spec
      if LatestSpecIDChecked ~= SpecID then
        if RotationIsValid and EL.APLs[SpecID] then
          -- Spec Registers
          -- Spells
          Player:RegisterListenedSpells(SpecID);
          EL.UnregisterAuraTracking();
          -- Enums Filters
          Player:FilterTriggerGCD(SpecID);
          Spell:FilterProjectileSpeed(SpecID);
          -- Module Init Function
          if EL.APLInits[SpecID] then
            EL.SpellObjects = {};
            EL.ItemObjects = {};
            EL.MacroObjects = {};
            EL.FreeBinds = {};
            EL.SetupFreeBinds = true;
            EL.APLInits[SpecID]();
          end
          -- Special Checks
          if GetCVar("nameplateShowEnemies") ~= "1" then
            EL.Print("It looks like enemy nameplates are disabled, you should enable them in order to get proper AoE rotation.");
          end
        else
          EL.Print("No Rotation selected for this class/spec (SpecID: ".. SpecID .. "), addon disabled. This is likely due to the rotation being unsupported at this time or you have to select it in the addon settings. Please check supported rotations.");
        end
        LatestSpecIDChecked = SpecID;
      end
      Everyone.InitTimers();
      if not EL.PulseInitialized then EL.PulseInitialized = true; end
    end
  end
end

function EL.Pulse ()
  if GetTime() > EL.Timer.Pulse then
    EL.Timer.PulseOffset = 0.120 + (EpicSettings.Settings["pulseSaveCPU"] and (EpicSettings.Settings["pulseSaveCPUOffset"] / 1000) or 0)
    EL.Timer.Pulse = GetTime() + EL.Timer.PulseOffset;

    -- Check if the current spec is available (might not always be the case)
    -- Especially when switching from area (open world -> instance)
    local SpecID = Cache.Persistent.Player.Spec[1];
    if SpecID then
      -- Check if we are ready to cast something to save FPS.
      if EL.ON() and EL.Ready() then

        -- Reset return variables
        EL.EpicSettingsM = 0
        EL.EpicSettingsS = 0

        Cache.HasBeenReset = false;
        Cache.Reset();

        if GetTime() > EL.Timer.TTD then
          EL.Timer.TTD = GetTime() + EL.TTD.Settings.Refresh
          EL.TTDRefresh()
        end
        
        -- Rotational Debug Output
        --   if EL.DebugON() then

        local debugOn = EpicSettings.DebugOn or false;
        if debugOn then
          CurrResult = Everyone.TargetNextEnemy()
          if CurrResult and CurrResult ~= PrevResult then
            EL.Print(CurrResult);
            PrevResult = CurrResult;
          else
            CurrResult = EL.APLs[SpecID]();
            if CurrResult and CurrResult ~= PrevResult then
              EL.Print(CurrResult);
              PrevResult = CurrResult;
            end
          end
        else
          if not Everyone.TargetNextEnemy() then
            EL.APLs[SpecID]();
          end
        end
      end
    end
  end
end

function EL.Ready ()
  local AreWeReady
  if EL.GUISettings.General.ShowWhileMounted then
    AreWeReady = not Player:IsDeadOrGhost() and not Player:IsInVehicle() and not C_PetBattles.IsInBattle();
  else
    AreWeReady = not Player:IsDeadOrGhost() and not Player:IsMounted() and not Player:IsInVehicle() and not C_PetBattles.IsInBattle();
  end
  return AreWeReady
end

function EL.Break()
  EL.ChangePulseTimer(Player:GCD() + 0.05);
end

-- Used to force a short/long pulse wait, it also resets the icons.
function EL.ChangePulseTimer (Offset)
  EL.MainFrame:ChangeBind(nil);
  EL.Timer.Pulse = GetTime() + Offset;
end

C_Timer.After(2, function ()
  EL.PulseInit();
end
);
