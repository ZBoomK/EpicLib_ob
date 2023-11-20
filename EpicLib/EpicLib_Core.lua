--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...
local Cache = EpicCache
-- Lua
local gmatch = gmatch
local pairs = pairs
local print = print
local stringupper = string.upper
local tableinsert = table.insert
local tonumber = tonumber
local type = type
local wipe = table.wipe
-- File Locals


--- ======= GLOBALIZE =======
EpicLib = EL
EL.MAXIMUM = 40 -- Max # Buffs and Max # Nameplates.


--- ============================ CONTENT ============================
--- Build Infos
local LiveVersion, PTRVersion, BetaVersion = "10.1.0", "10.1.5", "10.1.5","10.1.7"
-- version, build, date, tocversion
EL.BuildInfo = { GetBuildInfo() }
-- Get the current build version.
function EL.BuildVersion()
  return EL.BuildInfo[1]
end

-- Get if we are on the Live or not.
function EL.LiveRealm()
  return EL.BuildVersion() == LiveVersion
end

-- Get if we are on the PTR or not.
function EL.PTRRealm()
  return EL.BuildVersion() == PTRVersion
end

-- Get if we are on the Beta or not.
function EL.BetaRealm()
  return EL.BuildVersion() == BetaVersion
end

-- Print with EL Prefix
function EL.Print(...)
  print("[|cFFFF6600Epic Lib|r]", ...)
end

do
  local Setting = EL.GUISettings.General
  -- Debug print with EL Prefix
  function EL.Debug(...)
    if Setting.DebugMode then
      print("[|cFFFF6600Epic Lib Debug|r]", ...)
    end
  end
end

EL.SpecID_ClassesSpecs = {
  -- Death Knight
  [250] = { "DeathKnight", "Blood" },
  [251] = { "DeathKnight", "Frost" },
  [252] = { "DeathKnight", "Unholy" },
  -- Demon Hunter
  [577] = { "DemonHunter", "Havoc" },
  [581] = { "DemonHunter", "Vengeance" },
  -- Druid
  [102] = { "Druid", "Balance" },
  [103] = { "Druid", "Feral" },
  [104] = { "Druid", "Guardian" },
  [105] = { "Druid", "Restoration" },
  -- Evoker
  [1467] = { "Evoker", "Devastation" },
  [1468] = { "Evoker", "Preservation" },
  [1473] = { "Evoker", "Augmentation" },
  -- Hunter
  [253] = { "Hunter", "Beast Mastery" },
  [254] = { "Hunter", "Marksmanship" },
  [255] = { "Hunter", "Survival" },
  -- Mage
  [62] = { "Mage", "Arcane" },
  [63] = { "Mage", "Fire" },
  [64] = { "Mage", "Frost" },
  -- Monk
  [268] = { "Monk", "Brewmaster" },
  [269] = { "Monk", "Windwalker" },
  [270] = { "Monk", "Mistweaver" },
  -- Paladin
  [65] = { "Paladin", "Holy" },
  [66] = { "Paladin", "Protection" },
  [70] = { "Paladin", "Retribution" },
  -- Priest
  [256] = { "Priest", "Discipline" },
  [257] = { "Priest", "Holy" },
  [258] = { "Priest", "Shadow" },
  -- Rogue
  [259] = { "Rogue", "Assassination" },
  [260] = { "Rogue", "Outlaw" },
  [261] = { "Rogue", "Subtlety" },
  -- Shaman
  [262] = { "Shaman", "Elemental" },
  [263] = { "Shaman", "Enhancement" },
  [264] = { "Shaman", "Restoration" },
  -- Warlock
  [265] = { "Warlock", "Affliction" },
  [266] = { "Warlock", "Demonology" },
  [267] = { "Warlock", "Destruction" },
  -- Warrior
  [71] = { "Warrior", "Arms" },
  [72] = { "Warrior", "Fury" },
  [73] = { "Warrior", "Protection" }
}
