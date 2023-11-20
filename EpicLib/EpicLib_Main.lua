--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, EL = ...
-- EpicLib
local Cache = EpicCache
local Unit = EL.Unit
local Player = Unit.Player
local Target = Unit.Target
local Spell = EL.Spell
local Item = EL.Item
-- Lua
local mathmax = math.max
local mathmin = math.min
-- File Locals
local OnRetail = true
local PrintedClassicWarning = false

EL.Frame = CreateFrame("Frame")
--- ============================ CONTENT ============================


-- Main
EL.Timer = {
  Pulse = 0,
  PulseOffset = 0,
  TTD = 0
}

function EL.Pulse()
  if EL.BuildInfo[4] and EL.BuildInfo[4] < 100000 then
    OnRetail = false
  end
  if not OnRetail then
    if not PrintedClassicWarning then
      EL.Print("EpicRotation and EpicLib currently only support retail WoW (Dragonflight). Classic, Wrath of the Lich King, and Hardcore Classic are not supported.")
      PrintedClassicWarning = true
    end
    return
  end
  if GetTime(true) > EL.Timer.Pulse and OnRetail then
    -- Put a 10ms min and 50ms max limiter to save FPS (depending on World Latency).
    -- And add the Reduce CPU Load offset (default 50ms) in case it's enabled.
    --EL.Timer.PulseOffset = mathmax(10, mathmin(50, EL.Latency()))/1000 + (EL.GUISettings.General.ReduceCPULoad and EL.GUISettings.General.ReduceCPULoadOffset or 0)
    
    -- Until further performance improvements, we'll use 66ms (i.e. 15Hz) as baseline. Offset (positive or negative) can still be added from Settings.lua
    EL.Timer.PulseOffset = 0.066 + (EpicSettings.Settings["pulseSaveCPU"] and (EpicSettings.Settings["pulseSaveCPUOffset"] / 1000) or 0)
    EL.Timer.Pulse = GetTime() + EL.Timer.PulseOffset

    Cache.HasBeenReset = false
    Cache.Reset()

    if GetTime() > EL.Timer.TTD then
      EL.Timer.TTD = GetTime() + EL.TTD.Settings.Refresh
      EL.TTDRefresh()
    end
  end
end

EL.Frame:SetScript("OnUpdate", EL.Pulse)