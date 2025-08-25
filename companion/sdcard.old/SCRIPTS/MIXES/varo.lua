-- Continuous variometer tone script for EdgeTX
-- Reads climb rate from altitude sensor and outputs continuous audio
-- Place this in SCRIPTS/MODEL/

local sensorName = "Alt"
local lastAltitude = 0
local lastTime = 0

-- Configuration
local minRate = 0.1        -- minimum climb rate (m/s) to start tone
local maxRate = 5.0        -- maximum climb rate for highest tone
local minFreq = 500        -- lowest tone frequency (Hz)
local maxFreq = 2000       -- highest tone frequency (Hz)
local volume = 1.0         -- volume (0..1)
local updateInterval = 0.05 -- seconds between updates

-- Find first altitude/vario sensor
local function findVarioSensor()
    local sensors = getSensors()
    for i, s in ipairs(sensors) do
        if s.unit == "m" or s.unit == "ft" then
            return s.label
        end
    end
    return nil
end

-- Main loop, runs continuously
local function run(event)
    if not sensorName then
        sensorName = findVarioSensor()
        if not sensorName then return end
    end

    local t = getTime() / 1000
    if t - lastTime < updateInterval then return end
    lastTime = t

    local alt = getValue(sensorName)
    if lastAltitude == 0 then
        lastAltitude = alt
        return
    end

    -- Calculate climb rate in m/s
    local rate = (alt - lastAltitude) / updateInterval
    lastAltitude = alt

    -- Generate tone for positive climb rate
    if rate >= minRate then
        if rate > maxRate then rate = maxRate end
        local freq = minFreq + (rate - minRate) / (maxRate - minRate) * (maxFreq - minFreq)
        playTone(freq, updateInterval * 1000, volume)
    else
        stopTone()  -- silence if climbing too slowly or descending
    end
end

return { run = run }
