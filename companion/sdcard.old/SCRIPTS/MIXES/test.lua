-- SINUS.lua   (max. 6 Zeichen!)
-- Minimal Lua-Mixer-Script mit Sinus

local t = 0       -- Zeit/Zähler
local step = 0.1  -- Schritt pro Aufruf (~30 ms)

-- Output-Tabelle für Mixer
local my_output = { "Val1" }  -- zwingend für Mixer

-- Run-Funktion
local function run()
  t = t + step
  local value = math.sin(t) * 1000  -- Sinuswert –100..100
  return value
end

-- Rückgabe an EdgeTX
return { run = run, output = my_output }
