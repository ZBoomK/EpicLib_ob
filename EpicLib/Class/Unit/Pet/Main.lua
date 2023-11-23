--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...
-- EpicLib
local Cache, Utils = EpicCache, EL.Utils
local Unit = EL.Unit
local Player, Pet, Target = Unit.Player, Unit.Pet, Unit.Target
local Focus, MouseOver = Unit.Focus, Unit.MouseOver
local Arena, Boss, Nameplate = Unit.Arena, Unit.Boss, Unit.Nameplate
local Party, Raid = Unit.Party, Unit.Raid
local Spell = EL.Spell
local Item = EL.Item
-- Lua
local IsPetActive = IsPetActive
-- File Locals



--- ============================ CONTENT ============================
-- Get if there is a pet currently active or not.
function Pet:IsActive()
  return IsPetActive()
end
