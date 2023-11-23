--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, EL = ...;
  -- EpicLib
  local EL = EpicLib;
  local Cache, Utils = EpicCache, EL.Utils;
  local EpicDBC = HDBC
  local Unit = EL.Unit;
  local Player = Unit.Player;
  local Target = Unit.Target;
  local Focus = Unit.Focus;
  local Mouseover = Unit.MouseOver
  local Spell = EL.Spell;
  local Item = EL.Item;
  -- Lua
  local error = error
  local tableinsert = table.insert;
  local tableremove = table.remove;
  local mathmin = math.min;
  local mathmax = math.max;
  local pairs = pairs;
  local print = print;
  local select = select;
  local setmetatable = setmetatable
  local stringlower = string.lower;
  local strsplit = strsplit;
  local strsplittable = strsplittable;
  local tostring = tostring;
  local type = type
  -- File Locals


--- ======= GLOBALIZE =======
  -- Addon

--- ============================ CONTENT ============================
--- ======= CORE =======
  -- Print with EL Prefix
  function EL.Print (...)
    print("[|cFFFF6600Epic|r]", ...);
  end

  -- Defines the APL
  EL.APLs = {};
  EL.APLInits = {};
  function EL.SetAPL (Spec, APL, APLInit)
    EL.APLs[Spec] = APL;
    EL.APLInits[Spec] = APLInit;
  end

  -- Define Macro
  local function Class()
    local Class = {}
    Class.__index = Class
    setmetatable(Class, {
      __call =
      function(self, ...)
        local Object = {}
        setmetatable(Object, self)
        Object:New(...)
        return Object
      end
    })
    return Class
  end

  local Macro = Class()
  EL.Macro = Macro
  
  function Macro:New(MacroID)
    if type(MacroID) ~= "number" then error("Invalid MacroID.") end
  
    -- Attributes
    self.MacroID = MacroID
  end


--- ======= CASTS =======
  -- Main Cast
do
  local SilenceIDs = {
    377004,
    397892,
    196543,
    381516,
  };
  local QuakingDebuffId = Spell(240447);
  local PoolResource = 999910;
  local SpellQueueWindow = tonumber(C_CVar.GetCVar("SpellQueueWindow"));
  function EL.Press(Object, OutofRange, Immovable, OffGCD)
    local SpellID = Object.SpellID;
    local SpellReturnID = Object.ReturnID;
    local MacroID = Object.MacroID;
    local Usable = MacroID or Object:IsUsable();
    local ShowPooling = Object.SpellID == PoolResource;
    local TargetIsCastingSilence = Target:Exists() and Utils.ValueIsInArray(SilenceIDs, Target:CastSpellID());

    if not EpicSettings.Toggles["toggle"] then
      return false;
    end

    if ShowPooling then
      Object.LastDisplayTime = GetTime();
      return true;
    end
    
    local PrecastWindow = mathmin(mathmax(SpellQueueWindow - EL.Latency(), 75), 150);
    if (not Usable) or OutofRange or (Immovable and (Player:IsMoving() or Player:DebuffUp(QuakingDebuffId, true) or TargetIsCastingSilence)) or ((not OffGCD) and ((Player:CastEnd() - PrecastWindow > 0) or (Player:GCDRemains() - PrecastWindow > 0))) then
      Object.LastDisplayTime = GetTime();
      return false;
    end

    if SpellID then
      EL.EpicSettingsS = SpellReturnID;
      --EL.Print("Casting Spell: "..SpellReturnID);
    end
    if MacroID then
      EL.EpicSettingsM = MacroID;
      --EL.Print("Casting Macro: "..MacroID);
    end

    Object.LastDisplayTime = GetTime();
    return true;
  end

  function EL.PressTrinket(Trinket, TrinketTarget, CursorSettings)

    if not EpicSettings.Toggles["toggle"] then
      return false;
    end

    if Trinket == 13 then
      if TrinketTarget == "Enemy" then
        EL.EpicSettingsM = 1;
        --EL.Print("TrinketID: "..Trinket);
      elseif TrinketTarget == "Player" then
        EL.EpicSettingsM = 2;
        --EL.Print("TrinketID: "..Trinket);
      elseif TrinketTarget == "Cursor" and CursorSettings == "Confirmation"  then
        EL.EpicSettingsM = 1;
        --EL.Print("TrinketID: "..Trinket);
      elseif TrinketTarget == "Cursor" and (CursorSettings == "Enemy Under Cursor" or CursorSettings == "Cursor") then
        EL.EpicSettingsM = 3;
        --EL.Print("TrinketID: "..Trinket);
      elseif TrinketTarget == "Friendly" then
        EL.EpicSettingsM = 4;
        --EL.Print("TrinketID: "..Trinket);
      end
    else
      if TrinketTarget == "Enemy" then
        EL.EpicSettingsM = 5;
        --EL.Print("TrinketID: "..Trinket);
      elseif TrinketTarget == "Player" then
        EL.EpicSettingsM = 6;
        --EL.Print("TrinketID: "..Trinket);
      elseif TrinketTarget == "Cursor" and CursorSettings == "Confirmation"  then
        EL.EpicSettingsM = 5;
        --EL.Print("TrinketID: "..Trinket);
      elseif TrinketTarget == "Cursor" and (CursorSettings == "Enemy Under Cursor" or CursorSettings == "Cursor") then
        EL.EpicSettingsM = 7;
        --EL.Print("TrinketID: "..Trinket);
      elseif TrinketTarget == "Friendly" then
        EL.EpicSettingsM = 8;
        --EL.Print("TrinketID: "..Trinket); 
      end
    end

    return true;
  end

  function EL.Cast(Object, OffGCD, DisplayStyle, OutofRange, CustomTime)
    return EL.Press(Object, OutofRange, nil, OffGCD);
  end
  function EL.CastAnnotated(Object, OffGCD, Text, OutofRange)
    return EL.Press(Object, OutofRange, nil, OffGCD);
  end
  function EL.CastPooling(Object, CustomTime, OutofRange)
    return EL.Press(Object, OutofRange);
  end
  function EL.CastSuggested(Object, OutofRange)
    return EL.Press(Object, OutofRange);
  end
end

--- ======= COMMANDS =======
  -- Command Handler
  function EL.CmdHandler (Message)
    local Argument, Argument1 = strsplit(" ", Message);
    local ArgumentLower = stringlower(Argument);
    for k, v in pairs(EL.Toggles) do
      local Toggle = k;
      local Index = v;
      if ArgumentLower == Toggle then
        EpicDBC.Toggles[Index] = not EpicDBC.Toggles[Index];
        EL.Print(Toggle .. " is now "..(EpicDBC.Toggles[Index] and "|cff00ff00enabled|r." or "|cffff0000disabled|r."));
        EL.ToggleFrame:UpdateButtonText(Index);
        return;
      end
    end
    if ArgumentLower == "lock" then
      EL.ToggleFrame:ToggleLock();
    elseif ArgumentLower == "break" then
      EL.Break();
    elseif ArgumentLower == "cast" and Argument1 then
      local Bind = EL.SpellBinds[tonumber(Argument1)];
      EL.Timer.Pulse = GetTime() + 0.150;
    elseif ArgumentLower == "use" and Argument1 then
      local Bind = EL.ItemBinds[tonumber(Argument1)];
      EL.Timer.Pulse = GetTime() + 0.150;
    elseif ArgumentLower == "macro" and Argument1 then
      local Bind = EL.MacroBinds[tostring(Argument1)];
      EL.Timer.Pulse = GetTime() + 0.150;
    elseif ArgumentLower == "help" then
      EL.Print("|cffffff00--[Toggles]--|r");
      EL.Print("  On/Off: |cff8888ff/EL toggle|r");
      EL.Print("  CDs: |cff8888ff/EL cds|r");
      EL.Print("  AoE: |cff8888ff/EL aoe|r");
      EL.Print("  Un-/Lock: |cff8888ff/EL lock|r");
      EL.Print("  Break: |cff8888ff/EL break|r");
      EL.Print("  Cast: |cff8888ff/EL cast <SpellID>|r");
      EL.Print("  Use: |cff8888ff/EL use <ItemID>|r");
      EL.Print("  Macro: |cff8888ff/EL macro <MacroID>|r");
    else
      EL.Print("Invalid arguments.");
      EL.Print("Type |cff8888ff/EL help|r for more infos.");
    end
  end

  -- Add a toggle
  function EL.AddToggle(Toggle)
    table.insert(EL.Toggles, Toggle);
  end

  -- Get if the main toggle is on.
  function EL.ON ()
    return true;
  end
  

  -- Get if the CDs are enabled.
  function EL.CDsON ()
    return true;
  end

  -- Get if the AoE is enabled.
  do
    local AoEImmuneNPCID = {
    }
    -- Disable the AoE if we target an unit that is immune to AoE spells.
    function EL.AoEON ()
      return true;
    end
  end

