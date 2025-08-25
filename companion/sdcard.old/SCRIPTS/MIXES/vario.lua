-- Hybrid variometer script for EdgeTX
-- Works as Custom Script (MIXES) on radio, or as Tool in simulator
-- Save as /SCRIPTS/MIXES/vario.lua
-- For simulator testing: also copy to /SCRIPTS/TOOLS/vario.lua

local sensor = "Alt"  -- name of your altitude sensor (as shown in telemetry)

-- Configuration
local minRate = 0.1        -- minimum climb rate (m/s) to start tone
local maxRate = 5.0        -- maximum climb rate for highest tone
local minFreq = 500        -- lowest tone frequency (Hz)
local maxFreq = 2000       -- highest tone frequency (Hz)
local volume = 1.0         -- volume (0..1)
local interval = 0.1       -- seconds between updates

-- State
local lastAlt = 0
local lastTime = 0
local simT = 0  -- simulation time for demo mode

-- Returns climb rate either from sensor or simulated
local function getClimbRate(dt)
    local alt = getValue(sensor)

    -- If sensor not available → demo mode (for simulator)
    if alt == nil or type(alt) ~= "number" then
        simT = simT + dt
        -- oscillate between 0 and 6 m/s
        return 3 + 3 * math.sin(simT * 2)
    end

    if lastAlt == 0 then
        lastAlt = alt
        return 0
    end

    local rate = (alt - lastAlt) / dt
    lastAlt = alt
    return rate
end

local function run(event)
    local now = getTime() / 100.0 -- getTime returns ticks (1/100s)
    local dt = now - lastTime
    if dt < interval then return end
    lastTime = now

    local rate = getClimbRate(dt)

    if rate >= minRate then
        if rate > maxRate then rate = maxRate end
        local freq = minFreq + (rate - minRate) / (maxRate - minRate) * (maxFreq - minFreq)
        playTone(freq, interval * 1000, volume)
    else
        stopTone()
    end
end

return { run = run }
