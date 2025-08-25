-- hello.lua
local function run(event)
  lcd.clear()
  lcd.drawText(10, 10, "Hello World!", DBLSIZE)  -- doppelt so groß
end

return { run=run }
