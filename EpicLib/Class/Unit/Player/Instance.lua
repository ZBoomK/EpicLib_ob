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
local GetInstanceInfo = GetInstanceInfo -- name, instanceType, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, mapID, instanceGroupSize, lfgID
-- File Locals



--- ============================ CONTENT ============================
-- Get the instance information about the current area.
function Player:InstanceInfo(Index)
  return GetInstanceInfo()
end

-- Get the player instance type.
function Player:InstanceType()
  local _, InstanceType = self:InstanceInfo()

  return InstanceType
end

-- Get the player instance difficulty.
function Player:InstanceDifficulty()
  local _, _, Difficulty = self:InstanceInfo()

  return Difficulty
end

-- Get wether the player is in an instanced pvp area.
function Player:IsInInstancedPvP()
  local InstanceType = self:InstanceType()

  return (InstanceType == "arena" or InstanceType == "pvp") or false
end

-- Get wether the player is in a raid area.
function Player:IsInRaidArea()
  return self:InstanceType() == "raid" or false
end

-- Get wether the player is in a dungeon area.
function Player:IsInDungeonArea()
  return self:InstanceType() == "party" or false
end
