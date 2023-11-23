--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...
-- EpicLib
local Cache, Utils = EpicCache, EL.Utils
local Unit, UnitGUIDMap = EL.Unit, EL.UnitGUIDMap
local Player, Pet, Target = Unit.Player, Unit.Pet, Unit.Target
local Focus, MouseOver = Unit.Focus, Unit.MouseOver
local Arena, Boss, Nameplate = Unit.Arena, Unit.Boss, Unit.Nameplate
local Party, Raid = Unit.Party, Unit.Raid
local Spell = EL.Spell
local Item = EL.Item
-- Lua
local pairs = pairs
local tableinsert = table.insert
local loadstring = loadstring
local setfenv = setfenv
-- File Locals
local restoreDB = {}
local overrideDB = {}


--- ============================ CONTENT ============================
-- Core Override System
function EL.AddCoreOverride(target, newfunction, specKey)
  local loadOverrideFunc = assert(loadstring([[
      return function (func)
      ]] .. target .. [[ = func
      end, ]] .. target .. [[
      ]]))
  setfenv(loadOverrideFunc, { EL = EL, Player = Player, Spell = Spell, Item = Item, Target = Target, Unit = Unit, Pet = Pet })
  local overrideFunc, oldfunction = loadOverrideFunc()
  if overrideDB[specKey] == nil then
    overrideDB[specKey] = {}
  end
  tableinsert(overrideDB[specKey], { overrideFunc, newfunction })
  tableinsert(restoreDB, { overrideFunc, oldfunction })
  return oldfunction
end

function EL.LoadRestores()
  for k, v in pairs(restoreDB) do
    v[1](v[2])
  end
end

function EL.LoadOverrides(specKey)
  if type(overrideDB[specKey]) == "table" then
    for k, v in pairs(overrideDB[specKey]) do
      v[1](v[2])
    end
  end
end
