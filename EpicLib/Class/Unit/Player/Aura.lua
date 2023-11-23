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
local tostring = tostring
-- File Locals



--- ============================ CONTENT ============================
-- Get if the player is stealthed or not
do
  local StealthSpellsByType = {
    -- Normal Stealth
    {
      -- Rogue
      Spell(1784), -- Stealth
      Spell(115191), -- Stealth w/ Subterfuge Talent
      Spell(11327), -- Vanish
      Spell(115193), -- Vanish w/ Subterfuge Talent
      -- Feral
      Spell(5215) -- Prowl
    },
    -- Combat Stealth
    {
      -- Rogue
      Spell(115192), -- Subterfuge Buff
      Spell(185422), -- Stealth from Shadow Dance
      -- Druid
      Spell(102543) -- Incarnation: King of the Jungle
    },
    -- Special Stealth
    {
      -- Rogue
      Spell(375939), -- Sepsis stance mask buff
      -- Night Elf
      Spell(58984) -- Shadowmeld
    }
  }

  function Player:StealthRemains(CheckCombat, CheckSpecial, BypassRecovery)
    -- Considering there is a small delay between the ability cast and the buff trigger we also look at the time since last cast.
    if Spell.Rogue then
      if (CheckCombat and (Spell.Rogue.Commons.ShadowDance:TimeSinceLastCast() < 0.3 or Spell.Rogue.Commons.Vanish:TimeSinceLastCast() < 0.3))
        or (CheckSpecial and Spell.Rogue.Commons.Shadowmeld:TimeSinceLastCast() < 0.3) then
          return 1
      end
    end

    if Spell.Druid then
      local Feral = Spell.Druid.Feral

      if Feral then
        if (CheckCombat and Feral.Incarnation:TimeSinceLastCast() < 0.3)
          or (CheckSpecial and Feral.Shadowmeld:TimeSinceLastCast() < 0.3) then
          return 1
        end
      end
    end

    for i = 1, #StealthSpellsByType do
      if i == 1 or (i == 2 and CheckCombat) or (i == 3 and CheckSpecial) then
        local StealthSpells = StealthSpellsByType[i]
        for j = 1, #StealthSpells do
          local StealthSpell = StealthSpells[j]
          if Player:BuffUp(StealthSpell, nil, BypassRecovery) then
            return Player:BuffRemains(StealthSpell, nil, BypassRecovery)
          end
        end
      end
    end

    return 0
  end

  function Player:StealthUp(CheckCombat, CheckSpecial, BypassRecovery)
    return self:StealthRemains(CheckCombat, CheckSpecial, BypassRecovery) > 0
  end

  function Player:StealthDown(CheckCombat, CheckSpecial, BypassRecovery)
    return not self:StealthUp(CheckCombat, CheckSpecial, BypassRecovery)
  end
end
