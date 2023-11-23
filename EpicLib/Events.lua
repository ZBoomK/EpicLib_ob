--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, EL = ...;
  -- EpicLib
  local EL = EpicLib;
  local Cache = EpicCache;
  local Unit = EL.Unit;
  local Player = Unit.Player;
  local Target = Unit.Target;
  local Spell = EL.Spell;
  local Item = EL.Item;
  local Commons = EL.Commons.Everyone;
  -- Lua

  -- File Locals



--- ============================ CONTENT ============================
--- ======= NON-COMBATLOG =======
  -- OnSpecChange
  --DEFAULT_CHAT_FRAME:AddMessage("test2");

  local SpecTimer = 0;
  EL:RegisterForEvent(
    function (Event)
      -- Prevent the first event firing (when login)
      if not EL.PulseInitialized then return; end
      -- Timer to prevent bug due to the double/triple event firing.
      -- Since it takes 5s to change spec, we'll take 3seconds as timer.
      if GetTime() > SpecTimer then
        -- Update the timer only on valid scan.
        if EL.PulseInit() ~= "Invalid SpecID" then
          SpecTimer = GetTime() + 3;
        end
      end
    end
    , "PLAYER_SPECIALIZATION_CHANGED"
  );

  EL:RegisterForEvent(
    function (Event, encounterID, encounterName, difficultyID, groupSize)
        Commons.CurrentEncounterID = encounterID;
    end
    , "ENCOUNTER_START"
  );

  EL:RegisterForEvent(
    function (Event, encounterID, encounterName, difficultyID, groupSize)
        Commons.CurrentEncounterID = 0;
    end
    , "ENCOUNTER_END"
  );

--- ======= COMBATLOG =======
  --- Combat Log Arguments
    ------- Base -------
      --     1        2         3           4           5           6              7             8         9        10           11
      -- TimeStamp, Event, HideCaster, SourceGUID, SourceName, SourceFlags, SourceRaidFlags, DestGUID, DestName, DestFlags, DestRaidFlags

    ------- Prefixes -------
      --- SWING
      -- N/A

      --- SPELL & SPELL_PACIODIC
      --    12        13          14
      -- SpellID, SpellName, SpellSchool

    ------- Suffixes -------
      --- _CAST_START & _CAST_SUCCESS & _SUMMON & _RESURRECT
      -- N/A

      --- _CAST_FAILED
      --     15
      -- FailedType

      --- _AURA_APPLIED & _AURA_REMOVED & _AURA_REFRESH
      --    15
      -- AuraType

      --- _AURA_APPLIED_DOSE
      --    15       16
      -- AuraType, Charges

      --- _INTERRUPT
      --      15            16             17
      -- ExtraSpellID, ExtraSpellName, ExtraSchool

      --- _HEAL
      --   15         16         17        18
      -- Amount, Overhealing, Absorbed, Critical

      --- _DAMAGE
      --   15       16       17       18        19       20        21        22        23
      -- Amount, Overkill, School, Resisted, Blocked, Absorbed, Critical, Glancing, Crushing

      --- _MISSED
      --    15        16           17
      -- MissType, IsOffHand, AmountMissed

    ------- Special -------
      --- UNIT_DIED, UNIT_DESTROYED
      -- N/A

  --- End Combat Log Arguments

  -- Arguments Variables

