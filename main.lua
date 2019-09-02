local DIGIT_HEIGHT = 250
local DIGIT_WIDTH  = 160
local SPACING = 50
local ANIMATION_TIME = 1/3

local timestamp = os.time()
local millisecond = 0.0

function love.load()
  love.window.setFullscreen(true)
  love.mouse.setVisible(false)
  love.graphics.setLineWidth(3)
end

function love.update(dt)
  local now = os.time()
  if now == timestamp and millisecond > ANIMATION_TIME then
    -- sleep until next animation
    while os.time() == timestamp do
      love.timer.sleep(0.01)
    end
  elseif now == timestamp then
    millisecond = millisecond + dt
  else
    timestamp = now
    millisecond = 0.0
  end
end

function love.keypressed(key)
  -- exit on any key press
  love.event.quit()
end

digits = {
  ["0"] = {105,10,-16,39,-5,236,79,278,68,331,280,126,91,11},
  ["1"] = {54,49,136,-13,93,-55,109,96,104,141,104,164,104,237},
  ["2"] = {22,88,111,-47,128,21,375,31,-71,261,-103,245,159,230},
  ["3"] = {19,23,354,-12,-54,229,32,145,-116,-44,381,209,23,227},
  ["4"] = {43,31,18,266,83,-121,264,438,101,-104,156,-104,147,239},
  ["5"] = {156,30,-145,-12,244,45,-145,313,152,-137,316,278,21,230},
  ["6"] = {147,18,16,124,-32,341,53,253,236,237,214,145,39,151},
  ["7"] = {14,24,210,-2,162,68,204,-98,83,123,68,171,21,222},
  ["8"] = {86,14,-140,29,522,199,-75,380,-98,230,265,2,92,9},
  ["9"] = {150,16,-51,-27,-6,210,117,172,210,-8,138,-135,147,218},
}

function HMS(ts)
  local h = math.floor(ts / (60*60)) % 24
  local m = math.floor(ts / 60) % 60
  local s = ts % 60
  return string.format("%02d %02d %02d", h, m, s)
end

function love.draw()
  local w, h = love.graphics.getDimensions()
  love.graphics.translate(w / 2 - (DIGIT_WIDTH * 6 + SPACING * 2) / 2, h / 2 - DIGIT_HEIGHT / 2)

  local be4 = HMS(timestamp - 1)
  local now = HMS(timestamp)

  -- where we are in the animation, between 0 and 1
  local anim = math.min(1, millisecond / ANIMATION_TIME)

  for i = 1, #now do
    local a = be4:sub(i, i)
    local b = now:sub(i, i)

    if a == " " then
      -- double dot between every two digits
      love.graphics.circle("fill", math.floor(SPACING / 2), math.floor(DIGIT_HEIGHT * 0.35), 6)
      love.graphics.circle("fill", math.floor(SPACING / 2), math.floor(DIGIT_HEIGHT * 0.65), 6)
      love.graphics.translate(SPACING, 0)
    else
      -- render digit
      local curve = {}
      for j = 1, #digits[a] do
        table.insert(curve, (digits[b][j] - digits[a][j]) * anim + digits[a][j])
      end
      love.graphics.line(love.math.newBezierCurve(curve):render())
      love.graphics.translate(DIGIT_WIDTH, 0)
    end
  end
end


-- Uncomment to get an "editor" to create letters
-- current_i = 1
-- points = {
--   50, 100,
--   100, 100,
--   150, 100,
--   200, 100,
--   250, 100,
--   300, 100,
--   350, 100,
-- }
--
-- function love.load()
--   love.mouse.setVisible(true)
-- end
--
-- local w, h = 0, 0
--
-- function love.draw()
--   w, h = love.graphics.getDimensions()
--   love.graphics.translate(w / 2 - DIGIT_WIDTH / 2, h / 2 - DIGIT_HEIGHT / 2)
--   love.graphics.setLineWidth(1)
--   love.graphics.rectangle("line", 0, 0, DIGIT_WIDTH, DIGIT_HEIGHT)
--   love.graphics.setLineWidth(3)
--   curve = love.math.newBezierCurve(points)
--   love.graphics.line(curve:render())
-- end
--
-- function love.mousepressed(x, y)
--   points[current_i * 2 - 1] = x - w / 2 + DIGIT_WIDTH / 2
--   points[current_i * 2] = y - h / 2 + DIGIT_HEIGHT / 2
--   t = {}
--   for _, v in ipairs(points) do
--     table.insert(t, v - 150)
--   end
--   print(table.concat(t, ','))
-- end
--
-- function love.keypressed(key)
--   n = tonumber(key)
--   if n ~= nil and n >= 1 and n <= 7 then
--     current_i = n
--   end
-- end
