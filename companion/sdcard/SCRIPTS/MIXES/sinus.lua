-- /SCRIPTS/MIXES/sinus.lua
-- erzeugt einen sinusförmigen Kanalwert (-100..100)

local t = 0            -- Zeit/Zähler
local step = 0.1       -- Schrittweite pro Aufruf (~20-30 Hz)

local function run(inputs)
  t = t + step
  local value = math.sin(t) * 100  -- Bereich -100..100
  return value                     -- Rückgabewert = Kanalwert
end

return { run=run }
