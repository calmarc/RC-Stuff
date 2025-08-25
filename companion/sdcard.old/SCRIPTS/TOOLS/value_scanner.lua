local line = 0
local names = {}

local function init()
  for i = 0, 400 do
    local val = getValue(i)
    if type(val) == "number" then
      local info = getFieldInfo(i)
      if info and info.name then
        table.insert(names, string.format("%03d: %s = %.2f", i, info.name, val))
      end
    end
  end
end

local function run(event)
  lcd.clear()
  lcd.drawText(5, 0, "getValue() Scanner", SMLSIZE + INVERS)

  -- Anzahl Zeilen pro Seite
  local maxLines = 12
  for i = 0, maxLines - 1 do
    local idx = line + i + 1
    if names[idx] then
      lcd.drawText(2, 12 + i * 10, names[idx], SMLSIZE)
    end
  end

  -- Scrollfunktion
  if event == EVT_PLUS_BREAK or event == EVT_ROT_RIGHT then
    line = math.min(line + 1, #names - maxLines)
  elseif event == EVT_MINUS_BREAK or event == EVT_ROT_LEFT then
    line = math.max(0, line - 1)
  end

  return 0
end

return {
  init = init,
  run = run
}
