--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...
-- EpicLib
local Cache, Utils = EpicCache, EL.Utils
local Unit = EL.Unit
local Player = Unit.Player
local Pet = Unit.Pet
local Target = Unit.Target
local Spell = EL.Spell
local Item = EL.Item
-- Lua
local CreateFrame = CreateFrame
local UIParent = UIParent
local GetTime = GetTime
local UnitGUID = UnitGUID
local pairs = pairs
local tableinsert = table.insert
local tablesort = table.sort
local tableremove = table.remove
local wipe = table.wipe
-- File Locals
local Splash = {}
local SPLASH_TRACKER_TIMEOUT = 3 -- 3000ms
local NucleusAbilities = {} -- Every abilities that are used in order to compute splash data. { [SpellID] = { Type, Radius } }
local FriendTargets = {} -- Track the targets of our friend (player, party, raid, pets, ...) in order to potentially assign the splash to their target (see NucleusAbility type). { [FriendGUID] = FriendTargetGUID }
local TrackerBuffer = {} -- Buffer of the tracker since splash is coming from multiple events. { [SpellID] = { [SourceGUID] = { FirstTime, FriendTargetGUID, FirstDestGUID, Enemies = { GUID, LastTime, LastSpellID } } } }
local Tracker = {} -- Track each enemies from where we splash from. { [PrimaryEnemyGUID] = { [Radius] = { [EnemyGUID] = { GUID, LastDamageTime, LastDamageSpellID } } } }

--- ======= GLOBALIZE =======
EL.SplashEnemies = Splash


--- ============================ CONTENT ============================
-- Update the targets of our friends.
do
  local StartsWith = Utils.StartsWith
  -- TODO: Add more available tracking like choosing between tanks, melees, ranged, etc...
  -- Who are the friend units we are tracking
  local FRIEND_TARGETS_TRACKING_ALL = 1 -- "All": Player + Party/Raid and their Pet
  local FRIEND_TARGETS_TRACKING_MINE = 2 -- "Mine Only": Player and his Pet
  local FriendTargetsTrackings = {
    ["All"] = FRIEND_TARGETS_TRACKING_ALL,
    ["Mine Only"] = FRIEND_TARGETS_TRACKING_MINE
  }
  local FriendTargetsTracking = FRIEND_TARGETS_TRACKING_ALL
  local function UpdateFriendTarget(UnitID)
    -- EL.Print("[SplashEnemies] Updating friend target for UnitID '" .. UnitID .."'.")
    local FriendGUID = UnitGUID(UnitID)
    local TargetGUID = UnitGUID(UnitID .. "target")
    if FriendGUID then
      FriendTargets[FriendGUID] = TargetGUID
    end
  end
  local function UpdateGroupData()
    if Player:IsInRaidArea() and Player:IsInRaid() then
      SPLASH_TRACKER_TIMEOUT = 3
    elseif Player:IsInDungeonArea() and Player:IsInParty() then
      SPLASH_TRACKER_TIMEOUT = 4
    else
      SPLASH_TRACKER_TIMEOUT = 5
    end

    -- Player update
    UpdateFriendTarget("player")
    UpdateFriendTarget("pet")
    -- Party/Raid update
    if FriendTargetsTracking == FRIEND_TARGETS_TRACKING_ALL then
      if Player:IsInParty() then
        for _, PartyUnit in pairs(Unit.Party) do
          local UnitID = PartyUnit:ID()
          UpdateFriendTarget(UnitID)
          UpdateFriendTarget(UnitID .. "pet")
        end
      end
      if Player:IsInRaid() then
        for _, RaidUnit in pairs(Unit.Raid) do
          local UnitID = RaidUnit:ID()
          UpdateFriendTarget(UnitID)
          UpdateFriendTarget(UnitID .. "pet")
        end
      end
    end
  end

  -- OnInit
  UpdateGroupData()
  -- OnCombatEnter, OnGroupUpdate
  EL:RegisterForEvent(UpdateGroupData, "PLAYER_REGEN_DISABLED", "GROUP_ROSTER_UPDATE")
  -- OnTargetUpdate
  EL:RegisterForEvent(
    function(Event, UnitID)
      if FriendTargetsTracking == FRIEND_TARGETS_TRACKING_ALL and not StartsWith(UnitID, "player") and not StartsWith(UnitID, "pet") and not StartsWith(UnitID, "party") and not StartsWith(UnitID, "raid") then
        return
      end
      if FriendTargetsTracking == FRIEND_TARGETS_TRACKING_MINE and not StartsWith(UnitID, "player") and not StartsWith(UnitID, "pet") then
        return
      end

      UpdateFriendTarget(UnitID)
    end,
    "UNIT_TARGET"
  )
  EL:RegisterForEvent(
    function(Event, UnitID)
      if FriendTargetsTracking == FRIEND_TARGETS_TRACKING_ALL and not StartsWith(UnitID, "player") and not StartsWith(UnitID, "party") and not StartsWith(UnitID, "raid") then
        return
      end
      if FriendTargetsTracking == FRIEND_TARGETS_TRACKING_MINE and not StartsWith(UnitID, "player") then
        return
      end

      UpdateFriendTarget(UnitID .. "pet")
    end,
    "UNIT_PET"
  )

  function Splash.ChangeFriendTargetsTracking(TrackingMode)
    assert(type(TrackingMode) == "string" and (TrackingMode == "All" or TrackingMode == "Mine Only"), "Invalid Tracking.")

    local Tracking = FriendTargetsTrackings[TrackingMode]
    if Tracking == FriendTargetsTracking then
      return
    end

    FriendTargetsTracking = Tracking
    FriendTargets = {}
    UpdateGroupData()
  end
end

-- Update the tracker using damage from the combatlog.
do
  local function UpdateSplashes(_, Event, _, SourceGUID, _, _, _, DestGUID, _, _, _, SpellID)
    -- Check if the ability used to damage the unit is valid.
    local NucleusAbility = NucleusAbilities[SpellID]
    if not NucleusAbility then return end

    -- Stop processing if the event is not corresponding to the type of the NucleusAbility.
    if Event ~= "SPELL_DAMAGE" and NucleusAbility.Type ~= "PeriodicDamage" then return end

    -- Check if the SourceGUID is valid.
    local FriendTargetGUID = FriendTargets[SourceGUID]
    if not FriendTargetGUID then return end

    -- Retrieve the buffer or create it.
    local Buffer = TrackerBuffer[SpellID][SourceGUID]
    if not Buffer then
      -- Buffer are created only on SPELL_DAMAGE event, it should always be the case since it's triggered before the AURA ones though.
      if Event ~= "SPELL_DAMAGE" and Event ~= "SPELL_PERIODIC_DAMAGE" then return end

      -- EL.Print("[SplashEnemies] Creating buffer for SpellID '" .. SpellID .. "' from SourceGUID '" .. SourceGUID .. "'.")
      Buffer = { FirstTime = GetTime(), FriendTargetGUID = FriendTargetGUID, FirstDestGUID = DestGUID, Enemies = { { GUID = DestGUID, LastTime = GetTime(), LastSpellID = SpellID } } }
      TrackerBuffer[SpellID][SourceGUID] = Buffer

      -- Stop here since we already process the enemy on buffer creation
      return
    end

    -- Find the enemy if it exists in order to update it, otherwise insert it.
    local DestEnemy
    local BufferEnemies = Buffer.Enemies
    for i = 1, #BufferEnemies do
      local BufferEnemy = BufferEnemies[i]
      if BufferEnemy.GUID == DestGUID then
        DestEnemy = BufferEnemy
        break
      end
    end
    if DestEnemy then
      -- EL.Print("[SplashEnemies] Updating enemy with GUID '" .. DestGUID .. "' in buffer with SpellID '" .. SpellID .. "' from SourceGUID '" .. SourceGUID .. "'.")
      DestEnemy.LastTime = GetTime()
      DestEnemy.LastSpellID = SpellID
    else
      -- EL.Print("[SplashEnemies] Adding enemy with GUID '" .. DestGUID .. "' in buffer with SpellID '" .. SpellID .. "' from SourceGUID '" .. SourceGUID .. "'.")
      DestEnemy = { GUID = DestGUID, LastTime = GetTime(), LastSpellID = SpellID }
      tableinsert(BufferEnemies, DestEnemy)
    end
  end

  EL:RegisterForCombatEvent(UpdateSplashes, "SPELL_DAMAGE", "SPELL_PERIODIC_DAMAGE", "SPELL_AURA_APPLIED", "SPELL_AURA_REFRESH", "SPELL_AURA_APPLIED_DOSE")
end

-- Process the tracker buffer every 50ms.
do
  local SplashBufferFrame = CreateFrame("Frame", "EpicLib_SplashBufferFrame", UIParent)
  local SplashBufferFrameNextUpdate = 0
  local SplashBufferFrameUpdateFrequency = 0.05 -- 50ms
  SplashBufferFrame:SetScript(
    "OnUpdate",
    function ()
      if GetTime() <= SplashBufferFrameNextUpdate then return end
      SplashBufferFrameNextUpdate = GetTime() + SplashBufferFrameUpdateFrequency

      local BufferThresholdTime = GetTime() - SplashBufferFrameUpdateFrequency
      for SpellID, BufferBySourceGUID in pairs(TrackerBuffer) do
        local NucleusAbility = NucleusAbilities[SpellID]

        for SourceGUID, Buffer in pairs(BufferBySourceGUID) do
          -- Do process only the buffer that are old enough.
          if Buffer.FirstTime <= BufferThresholdTime then
            local BufferEnemies = Buffer.Enemies

            -- Assign the correct PrimaryTargetGUID (see Type explanation).
            local PrimaryEnemyGUID
            if NucleusAbility.Type == "PeriodicDamage" then
              -- The FirstDestGUID for PeriodicDamage type is always the DestGUID of the SPELL_DAMAGE event.
              PrimaryEnemyGUID = Buffer.FirstDestGUID
            else
              local FriendTargetGUID = Buffer.FriendTargetGUID
              for i = 1, #BufferEnemies do
                local Enemy = BufferEnemies[i]
                if Enemy.GUID == FriendTargetGUID then
                  PrimaryEnemyGUID = Enemy.GUID
                  break
                end
              end
            end

            -- Do process the buffer only if we have a PrimaryEnemyGUID
            if PrimaryEnemyGUID then
              -- Retrieve the tracker entry or create it.
              local EnemiesByRadius = Tracker[PrimaryEnemyGUID]
              if not EnemiesByRadius then
                -- EL.Print("[SplashEnemies] Creating enemies by radius table for PrimaryEnemyGUID '" .. PrimaryEnemyGUID .. "'.")
                EnemiesByRadius = {}
                Tracker[PrimaryEnemyGUID] = EnemiesByRadius
              end

              -- Retrieve the enemies table in order to update it or create it from the buffer.
              local Enemies = EnemiesByRadius[NucleusAbility.Radius]
              if not Enemies then
                -- EL.Print("[SplashEnemies] Creating enemies table within '" .. NucleusAbility.Radius .. "y' radius of enemy with GUID '" .. PrimaryEnemyGUID .. ".")
                Enemies = {}
                EnemiesByRadius[NucleusAbility.Radius] = Enemies
              end

              -- Iterate to find the enemy if it exists in order to update it, otherwise add it.
              for i = 1, #BufferEnemies do
                local BufferEnemy = BufferEnemies[i]
                local Enemy = Enemies[BufferEnemy.GUID]
                if Enemy then
                  if (BufferEnemy.LastTime > Enemy.LastTime) then
                    -- EL.Print("[SplashEnemies] Updating enemy with GUID '" .. BufferEnemy.GUID .. "' in enemies table within '" .. NucleusAbility.Radius .. "y' radius of enemy with GUID '" .. PrimaryEnemyGUID .. ".")
                    Enemy.LastTime = BufferEnemy.LastTime
                    Enemy.LastSpellID = BufferEnemy.LastSpellID
                  end
                else
                  -- EL.Print("[SplashEnemies] Adding enemy with GUID '" .. BufferEnemy.GUID .. "' in enemies table within '" .. NucleusAbility.Radius .. "y' radius of enemy with GUID '" .. PrimaryEnemyGUID .. ".")
                  Enemies[BufferEnemy.GUID] = BufferEnemy
                  --Enemies[BufferEnemy.GUID] = { GUID = BufferEnemy.GUID, LastTime = BufferEnemy.LastTime, LastSpellID = BufferEnemy.LastSpellID }
                end
              end
            end

            -- Remove the buffer
            BufferBySourceGUID[SourceGUID] = nil
          end
        end
      end
    end
  )
end

-- Clear the enemies that timed out from the tracker every 250ms.
do
  local SplashCleanerFrame = CreateFrame("Frame", "EpicLib_SplashCleanerFrame", UIParent)
  local SplashCleanerFrameNextUpdate = 0
  local SplashCleanerFrameUpdateFrequency = 0.25 -- 250ms
  SplashCleanerFrame:SetScript(
    "OnUpdate",
    function ()
      if GetTime() <= SplashCleanerFrameNextUpdate then return end
      SplashCleanerFrameNextUpdate = GetTime() + SplashCleanerFrameUpdateFrequency

      local TimeoutTime = GetTime() - SPLASH_TRACKER_TIMEOUT
      for PrimaryEnemyGUID, EnemiesByRadius in pairs(Tracker) do
        for Radius, Enemies in pairs(EnemiesByRadius) do
          local EnemiesCount = 0
          -- Remove expired enemies
          for EnemyGUID, Enemy in pairs(Enemies) do
            if Enemy.LastTime <= TimeoutTime then
              -- EL.Print("[SplashEnemies] Removing enemy with GUID '" .. EnemyGUID .. "' from enemies table within '" .. Radius .. "y' radius of enemy with GUID '" .. PrimaryEnemyGUID .. "' due to timeout.")
              Enemies[EnemyGUID] = nil
            else
              EnemiesCount = EnemiesCount + 1
            end
          end
          -- Remove the entry if it does not contain any enemy
          if EnemiesCount == 0 then
            -- EL.Print("[SplashEnemies] Removing enemies table within '" .. Radius .. "y' radius of enemy with GUID '" .. PrimaryEnemyGUID .. "' due to timeout.")
            EnemiesByRadius[Radius] = nil
          end
        end
      end
    end
  )
end

-- Clear the enemies that dies from the tracker.
EL:RegisterForCombatEvent(
  function (_, _, _, _, _, _, _, DestGUID)
    if Tracker[DestGUID] then
      -- EL.Print("[SplashEnemies] Removing enemy with GUID '" .. DestGUID .. "' from the tracker.")
      Tracker[DestGUID] = nil
    end

    for PrimaryEnemyGUID, EnemiesByRadius in pairs(Tracker) do
      for Radius, Enemies in pairs(EnemiesByRadius) do
        local EnemiesCount = 0
        -- Find the enemy and if it exists remove it.
        for EnemyGUID, Enemy in pairs(Enemies) do
          if DestGUID == Enemy.GUID then
            -- EL.Print("[SplashEnemies] Removing enemy with GUID '" .. EnemyGUID .. "' from enemies table within '" .. Radius .. "y' radius of enemy with GUID '" .. PrimaryEnemyGUID .. "' due to death event.")
            Enemies[EnemyGUID] = nil
          else
            EnemiesCount = EnemiesCount + 1
          end
        end
        -- Remove the entry if it does not contain any enemy.
        if EnemiesCount == 0 then
          -- EL.Print("[SplashEnemies] Removing enemies table within '" .. Radius .. "y' radius of enemy with GUID '" .. PrimaryEnemyGUID .. "' due to death event.")
          EnemiesByRadius[Radius] = nil
        end
      end
    end
  end,
  "UNIT_DIED", "UNIT_DESTROYED"
)

-- Clear the tracker once the player leaves combat, technically it's not needed but not doing so keep undefinetely the GUID as index with a nil value.
EL:RegisterForEvent(
  function()
    -- EL.Print("[SplashEnemies] Clearing the tracker and the buffers.")
    wipe(Tracker)
    for _, BufferBySourceGUID in pairs(TrackerBuffer) do
      wipe(BufferBySourceGUID)
    end
  end,
  "PLAYER_REGEN_ENABLED"
)

-- Register a NucleusAbility.
-- Type: DirectDamage               = Ability like Multi-Shot, Fan of Knives or Eye Beam where the area of effect is near an unit and deals direct damage.
--                                    We listen only on the SPELL_DAMAGE event.
--                                    The main target is considered to be the current target of the source if it has been hit.
-- Type: GroundDirectDamage         = Ability like Cataclysm or Metamorphosis where the area of effect deals direct damage one time.
--                                    We listen only on the SPELL_DAMAGE event.
--                                    The main target is considered to be the current target of the source if it has been hit.
-- Type: PeriodicDamage             = Ability like Sunfire where the area of effect is near an unit and deals direct damage then periodic damage.
--                                    We listen on SPELL_DAMAGE, SPELL_AURA_APPLIED, SPELL_AURA_REFRESH, SPELL_AURA_APPLIED_DOSE events.
--                                    The main target is the unit hit by the SPELL_DAMAGE event.
-- TODO: TYPES BELOW ARE TO BE IMPLEMENTED
-- Type: ChainDirectDamage          = Ability like Throw Glaive or Chain Lightning where it deals direct damage on one enemy inside the area of effect.
--                                    We listen only on the SPELL_DAMAGE event.
--                                    The main target is the unit hit by the first SPELL_DAMAGE event.
-- Type: GroundMultipleDirectDamage = Ability like Rain of Fire or Blizzard where the area of effect deals direct damage multiple time.
--                                    We listen only on the SPELL_DAMAGE event.
--                                    The main target is considered to be the current target of the source if it has been hit.

function Splash.RegisterNucleusAbility(Type, SpellID, Radius)
  assert(type(Type) == "string" and (Type == "DirectDamage" or Type == "GroundDirectDamage" or Type == "PeriodicDamage"), "Invalid or Unsupported Type.")
  assert(type(SpellID) == "number", "Invalid SpellID.")
  assert(type(Radius) == "number" and Radius >= 1 and Radius < 100, "Radius must be between 1 and 100.")

  EL.Debug("RegisterNucleusAbility - Adding ability " .. SpellID .. " with " .. Radius .. "y radius.")
  NucleusAbilities[SpellID] = { Type = Type, Radius = Radius }
  TrackerBuffer[SpellID] = {}
end

-- Register every default NucleusAbilities.
function Splash.RegisterNucleusAbilities()
  EL.Debug("RegisterNucleusAbilities")
  local RegisterNucleusAbility = Splash.RegisterNucleusAbility

  -- Commons

  -- Death Knight
  -- Commons
  RegisterNucleusAbility("DirectDamage", 383313, 8)               -- Abomination Limb
  RegisterNucleusAbility("GroundDirectDamage", 52212, 8)          -- Death and Decay
  -- Blood
  RegisterNucleusAbility("DirectDamage", 50842, 10)               -- Blood Boil
  RegisterNucleusAbility("DirectDamage", 196528, 8)               -- Bonestorm
  RegisterNucleusAbility("DirectDamage", 274156, 8)               -- Consumption
  -- Frost
  RegisterNucleusAbility("DirectDamage", 155166, 12)              -- Breath of Sindragosa
  RegisterNucleusAbility("DirectDamage", 204167, 6)               -- Chill Streak
  RegisterNucleusAbility("DirectDamage", 207230, 8)               -- Frostscythe
  RegisterNucleusAbility("DirectDamage", 49184, 10)               -- Howling Blast
  RegisterNucleusAbility("DirectDamage", 196771, 8)               -- Remorseless Winter
  -- Unholy
  RegisterNucleusAbility("GroundDirectDamage", 156000, 8)         -- Defile
  RegisterNucleusAbility("DirectDamage", 115994, 10)              -- Unholy Blight
  RegisterNucleusAbility("DirectDamage", 212739, 8)               -- Epidemic

  -- Demon Hunter
  -- Commons
  RegisterNucleusAbility("DirectDamage", 179057, 8)               -- Chaos Nova
  RegisterNucleusAbility("DirectDamage", 258922, 8)               -- Immolation Aura
  RegisterNucleusAbility("GroundDirectDamage", 307046, 8)         -- Elysian Decree
  RegisterNucleusAbility("GroundDirectDamage", 204598, 8)         -- Sigil of Flame
  -- Havoc
  RegisterNucleusAbility("DirectDamage", 200685, 8)               -- Blade Dance 1
  RegisterNucleusAbility("DirectDamage", 199552, 8)               -- Blade Dance 2
  RegisterNucleusAbility("DirectDamage", 210153, 8)               -- Death Sweep 1
  RegisterNucleusAbility("DirectDamage", 210155, 8)               -- Death Sweep 2
  RegisterNucleusAbility("DirectDamage", 258860, 10)              -- Essence Break
  RegisterNucleusAbility("DirectDamage", 198030, 20)              -- Eye Beam
  RegisterNucleusAbility("GroundDirectDamage", 200166, 8)         -- Metamorphosis
  -- Vengeance
  RegisterNucleusAbility("DirectDamage", 320341, 8)               -- Bulk Extraction
  RegisterNucleusAbility("DirectDamage", 212105, 13)              -- Fel Devastation
  RegisterNucleusAbility("DirectDamage", 189112, 6)               -- Infernal Strike
  RegisterNucleusAbility("DirectDamage", 228478, 8)               -- Soul Cleave
  RegisterNucleusAbility("DirectDamage", 247455, 8)               -- Spirit Bomb

  -- Druid
  -- Commons
  RegisterNucleusAbility("PeriodicDamage", 164815, 8)             -- Sunfire
  RegisterNucleusAbility("DirectDamage", 194153, 10)               -- Starfire
  -- Balance
  --RegisterNucleusAbility("TO_INVESTIGATE", 191037, 45)            -- Starfall
  RegisterNucleusAbility("DirectDamage", 274283, 8)               -- New Moon/Full Moon
  RegisterNucleusAbility("DirectDamage", 88751, 8)                -- Wild Mushroom
  -- Feral
  RegisterNucleusAbility("DirectDamage", 285381, 8)               -- Primal Wrath
  RegisterNucleusAbility("DirectDamage", 202028, 8)               -- Brutal Slash
  RegisterNucleusAbility("DirectDamage", 106830, 8)               -- Thrash (Cat)
  RegisterNucleusAbility("DirectDamage", 106785, 8)               -- Swipe (Cat)
  -- Guardian
  RegisterNucleusAbility("DirectDamage", 77758, 8)                -- Thrash (Bear)
  RegisterNucleusAbility("DirectDamage", 213771, 8)               -- Swipe (Bear)
  -- Restoration

  -- Evoker
  -- Commons
  RegisterNucleusAbility("DirectDamage", 357209, 12)              -- Fire Breath (Check spell ID; Range? It's a cone up to 25y(?))
  -- Augmentation
  RegisterNucleusAbility("DirectDamage", 395160, 8)               -- Eruption
  RegisterNucleusAbility("DirectDamage", 396288, 6)              -- Upheaval (Range? Spell goes from 3/6/9/12y depending on empower level)
  RegisterNucleusAbility("GroundDirectDamage", 403631, 12)        -- Breath of Eons (Range? Spell range is 15-50y)
  -- Devastation
  RegisterNucleusAbility("DirectDamage", 357212, 8)               -- Pyre (Check spell ID)
  RegisterNucleusAbility("DirectDamage", 359077, 12)              -- Eternity Surge (Check spell ID; Range? Could technically be out to 25y)
  RegisterNucleusAbility("DirectDamage", 362969, 6)               -- Azure Strike (Check spell ID, as it could also be 355627)
  RegisterNucleusAbility("GroundDirectDamage", 369374, 8)         -- Firestorm (Check spell ID; Should be GroundMultipleDirectDamage?)
  RegisterNucleusAbility("GroundDirectDamage", 353759, 12)        -- Deep Breath (Check spell ID; Range? Spell range is listed 20-50y)
  -- Preservation

  -- Hunter
  -- Commons
  RegisterNucleusAbility("DirectDamage", 171454, 8)               -- Chimaera Shot 1
  RegisterNucleusAbility("DirectDamage", 171457, 8)               -- Chimaera Shot 2
  -- Beast Mastery
  RegisterNucleusAbility("DirectDamage", 118459, 10)              -- Beast Cleave
  RegisterNucleusAbility("DirectDamage", 2643, 8)                 -- Multi-Shot
  RegisterNucleusAbility("DirectDamage", 201754, 8)               -- Stomp
  -- Marksmanship
  RegisterNucleusAbility("DirectDamage", 257620, 10)              -- Multi-Shot
  RegisterNucleusAbility("GroundDirectDamage", 260247, 8)         -- Volley
  RegisterNucleusAbility("DirectDamage", 212680, 8)               -- ExplosiveShot
  -- Survival
  RegisterNucleusAbility("DirectDamage", 212436, 8)               -- Butchery
  RegisterNucleusAbility("DirectDamage", 187708, 8)               -- Carve
  RegisterNucleusAbility("DirectDamage", 259495, 8)               -- Bombs 1
  RegisterNucleusAbility("DirectDamage", 270335, 8)               -- Bombs 2
  RegisterNucleusAbility("DirectDamage", 270323, 8)               -- Bombs 3
  RegisterNucleusAbility("DirectDamage", 271045, 8)               -- Bombs 4

  -- Mage
  -- Arcane
  RegisterNucleusAbility("DirectDamage", 1449, 10)                -- Arcane Explosion
  RegisterNucleusAbility("DirectDamage", 44425, 10)               -- Arcane Barrage
  -- Fire
  RegisterNucleusAbility("DirectDamage", 157981, 8)               -- Blast Wave
  --RegisterNucleusAbility("GroundMultipleDirectDamage", 153561, 8) -- Meteor
  RegisterNucleusAbility("DirectDamage", 31661, 8)                -- Dragon's Breath
  RegisterNucleusAbility("DirectDamage", 44457, 10)               -- Living Bomb
  RegisterNucleusAbility("GroundDirectDamage", 2120, 8)           -- Flamestrike
  RegisterNucleusAbility("DirectDamage", 257542, 8)               -- Phoenix Flames
  --RegisterNucleusAbility("TO_INVESTIGATE", 12654, 8)            -- AoE Ignite
  -- Frost
  RegisterNucleusAbility("GroundDirectDamage", 84721, 8)          -- Frozen Orb
  RegisterNucleusAbility("GroundDirectDamage", 190357, 8)         -- Blizzard
  RegisterNucleusAbility("DirectDamage", 153596, 6)               -- Comet Storm
  RegisterNucleusAbility("DirectDamage", 120, 12)                 -- Cone of Cold
  RegisterNucleusAbility("DirectDamage", 228600, 8)               -- Glacial Spike
  RegisterNucleusAbility("DirectDamage", 148022, 8)               -- Icicle
  RegisterNucleusAbility("DirectDamage", 228598, 8)               -- Ice Lance
  RegisterNucleusAbility("DirectDamage", 122, 12)                 -- Frost Nova
  RegisterNucleusAbility("DirectDamage", 157997, 8)               -- Ice Nova

  -- Monk
  -- Brewmaster
  -- Windwalker
  RegisterNucleusAbility("DirectDamage", 113656, 8)               -- Fists of Fury
  RegisterNucleusAbility("DirectDamage", 101546, 8)               -- Spinning Crane Kick
  RegisterNucleusAbility("DirectDamage", 261715, 8)               -- Rushing Jade Wind
  RegisterNucleusAbility("DirectDamage", 152175, 8)               -- Whirling Dragon Punch

  -- Paladin
  -- Commons
  --RegisterNucleusAbility("GroundMultipleDirectDamage", 81297, 8) -- Consecration
  -- Holy
  -- Protection
  --RegisterNucleusAbility("GroundMultipleDirectDamage", 204301, 8) -- Blessed Hammer (Usable? Spirals outward from caster)
  RegisterNucleusAbility("DirectDamage", 53600, 6)       -- Shield of the Righteous
  -- Retribution
  RegisterNucleusAbility("DirectDamage", 53385, 8)          -- Divine Storm
  RegisterNucleusAbility("GroundDirectDamage", 81297, 8)    -- Consecration
  RegisterNucleusAbility("GroundDirectDamage", 343721, 8)   -- Final Reckoning
  RegisterNucleusAbility("DirectDamage", 385816, 8)         -- Incandescence

  -- Priest
  -- Discipline
  -- Holy
  -- Shadow
  RegisterNucleusAbility("DirectDamage", 205386, 8)               -- Shadow Crash
  RegisterNucleusAbility("DirectDamage", 228360, 10)              -- Void Eruption 1
  RegisterNucleusAbility("DirectDamage", 228361, 10)              -- Void Eruption 2
  RegisterNucleusAbility("DirectDamage", 394979, 10)              -- Mind Sear (Void Lasher)
  RegisterNucleusAbility("DirectDamage", 373279, 10)              -- Void Spike (Thing From Beyond)

  -- Rogue
  -- Assassination
  RegisterNucleusAbility("DirectDamage", 121411, 10)              -- Crimson Tempest
  RegisterNucleusAbility("DirectDamage", 51723, 10)               -- Fan of Knives
  RegisterNucleusAbility("DirectDamage", 255546, 6)               -- Poison Bomb
  -- Outlaw
  RegisterNucleusAbility("DirectDamage", 22482, 6)                -- Blade Flurry
  RegisterNucleusAbility("DirectDamage", 271881, 8)               -- Blade Rush
  -- Subtlety
  RegisterNucleusAbility("DirectDamage", 197835, 10)              -- Shuriken Storm
  RegisterNucleusAbility("DirectDamage", 282449, 10)              -- Secret Technique
  RegisterNucleusAbility("DirectDamage", 319175, 10)              -- Black Powder

  -- Shaman
  -- Elemental
  RegisterNucleusAbility("DirectDamage", 188443, 10)              -- Chain Lightning
  RegisterNucleusAbility("DirectDamage", 77478, 8)                -- Earthquake
  RegisterNucleusAbility("DirectDamage", 192231, 8)               -- Liquid Magma Totem
  -- Enhancement
  RegisterNucleusAbility("DirectDamage", 187874, 8)               -- Crash Lightning
  RegisterNucleusAbility("DirectDamage", 197214, 11)              -- Sundering
  -- Restoration

  -- Warlock
  -- Afflication
  RegisterNucleusAbility("DirectDamage", 27285, 10)               -- Seed Explosion
  -- Demonology
  RegisterNucleusAbility("DirectDamage", 89753, 8)                -- Felstorm (Felguard)
  RegisterNucleusAbility("GroundDirectDamage", 386609, 8)         -- Guillotine's Fel Explosion
  RegisterNucleusAbility("DirectDamage", 86040, 8)                -- Hand of Gul'dan
  RegisterNucleusAbility("DirectDamage", 196278, 8)               -- Implosion
  -- Destruction
  RegisterNucleusAbility("GroundDirectDamage", 152108, 8)         -- Cataclysm
  RegisterNucleusAbility("DirectDamage", 387547, 8)               -- Cry Havoc
  --RegisterNucleusAbility("GroundMultipleDirectDamage", 42223, 8)  -- Rain of Fire
  RegisterNucleusAbility("GroundDirectDamage", 42223, 8)          -- Rain of Fire (temp, since Destruction has very few AoEs)
  RegisterNucleusAbility("GroundDirectDamage", 22703, 10)         -- Summon Infernal
  RegisterNucleusAbility("DirectDamage", 20153, 12)               -- Infernal/Blasphemy AoE Immolation pulse (not working... minion vs pet issue?)

  -- Warrior
  -- Commons
  RegisterNucleusAbility("GroundDirectDamage", 156287, 8)         -- Ravager
  RegisterNucleusAbility("DirectDamage", 396719, 8)               -- Thunder Clap
  RegisterNucleusAbility("DirectDamage", 384318, 12)              -- Thunderous Roar
  RegisterNucleusAbility("DirectDamage", 199658, 8)               -- Whirlwind
  -- Arms
  RegisterNucleusAbility("DirectDamage", 50622, 8)                -- Bladestorm
  RegisterNucleusAbility("DirectDamage", 845, 8)                  -- Cleave
  RegisterNucleusAbility("DirectDamage", 262161, 8)               -- Warbreaker
  RegisterNucleusAbility("DirectDamage", 1680, 8)                 -- Whirlwind
  -- Fury
  RegisterNucleusAbility("DirectDamage", 385061, 12)              -- Odyn's Fury
  RegisterNucleusAbility("DirectDamage", 385062, 12)              -- Odyn's Fury also (offhand?)
  -- Protection
  RegisterNucleusAbility("DirectDamage", 6572, 8)                 -- Revenge
  RegisterNucleusAbility("DirectDamage", 6343, 8)                 -- Thunder Clap
end

-- Unregister every NucleusAbilities.
function Splash.UnregisterNucleusAbilities()
  EL.Debug("UnregisterNucleusAbilities")
  wipe(NucleusAbilities)
  wipe(TrackerBuffer)
end

-- Get the enemies in given range of the unit using splash data.
function Unit:GetEnemiesInSplashRangeCount(Radius)
  if not self:Exists() then return 0 end

  local GUID = self:GUID()
  local EnemiesByRadius = Tracker[GUID]
  if not EnemiesByRadius then return 1 end

  -- Look for an entry with the given radius.
  local Enemies = EnemiesByRadius[Radius]
  if Enemies then
    local EnemiesCount = 0
    for _, _ in pairs(Enemies) do
      EnemiesCount = EnemiesCount + 1
    end

    return EnemiesCount
  else
    -- If we did not find, look for lower radiuses (since they are inside the circle from the unit to the edge).
    -- Always took the entry that have the highest count of enemies.
    local HighestEnemiesCount = 1
    for TrackerRadius, TrackerEnemies in pairs(EnemiesByRadius) do
      local EnemiesCount = 0
      for _, _ in pairs(TrackerEnemies) do
        EnemiesCount = EnemiesCount + 1
      end
      if TrackerRadius < Radius and EnemiesCount > HighestEnemiesCount then
        HighestEnemiesCount = EnemiesCount
      end
    end

    return HighestEnemiesCount
  end
end

-- Get a table of enemies within specified splash range
function Unit:GetEnemiesInSplashRange(Radius)
  if not self:Exists() then return {} end

  local GUID = self:GUID()
  local EnemiesByRadius = Tracker[GUID]
  local EnemiesTable = {}
  if not EnemiesByRadius then
    tableinsert(EnemiesTable, self)
    return EnemiesTable
  end

  for TrackerRadius, TrackerEnemy in pairs(EnemiesByRadius) do
    if TrackerRadius <= Radius then
      local FarRange = self:MaxDistance() or 0
      FarRange = FarRange + Radius
      if FarRange < 5 then FarRange = 5 end
      if FarRange > 100 then FarRange = 100 end
      for TrackerGUID in pairs(TrackerEnemy) do
        for UnitObject, UnitInfo in pairs(Player:GetEnemiesInRange(FarRange)) do
          if UnitInfo.UnitGUID == TrackerGUID then tableinsert(EnemiesTable, UnitInfo) end
        end
      end
    end
  end

  if #EnemiesTable >= 1 then
    return EnemiesTable
  end
  tableinsert(EnemiesTable, self)
  return EnemiesTable
end

-- OnInit
Splash.RegisterNucleusAbilities()
