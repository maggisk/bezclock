local C = require "const"

-- clock state
local timestamp = 0
local millisecond = 1.0

-- bezier curves created with the editor
digits = {
  ["0"] = {105,10,-16,39,-5,236,79,278,68,331,280,126,91,11},
  ["1"] = {54,49,136,-13,93,-55,109,96,104,141,104,164,104,237},
  ["2"] = {22,88,111,-47,128,21,375,31,-71,261,-103,245,159,230},
  ["3"] = {19,23,354,-12,-54,229,32,145,-116,-44,381,209,23,227},
  ["4"] = {36,26,24,230,76,-74,232,365,123,-98,123,-98,141,237},
  ["5"] = {156,30,-145,-12,244,45,-145,313,152,-137,316,278,21,230},
  ["6"] = {147,18,16,124,-32,341,53,253,236,237,214,145,39,151},
  ["7"] = {23,24,141,23,144,20,144,20,144,20,144,20,27,227},
  ["8"] = {86,14,-140,29,522,199,-75,380,-98,230,265,2,92,9},
  ["9"] = {150,16,-51,-27,-6,210,117,172,210,-8,138,-135,147,218},
}

function format_hms(ts)
  local h = math.floor(ts / (60*60)) % 24
  local m = math.floor(ts / 60) % 60
  local s = ts % 60
  return string.format("%02d %02d %02d", h, m, s)
end

function love.load()
  love.window.setFullscreen(true)
  love.mouse.setVisible(false)
  love.graphics.setLineWidth(3)
end

function love.update(dt)
  if timestamp == 0 then
    -- render once initially
    timestamp = os.time()
  elseif millisecond < C.ANIMATION_TIME then
    -- currently animating from one time to another
    millisecond = millisecond + dt
  elseif os.time() == timestamp then
    -- sleep until next animation
    while os.time() == timestamp do
      love.timer.sleep(0.01)
    end
  else
    -- start animation for the new time
    timestamp = os.time()
    millisecond = 0.0
  end
end

function love.keypressed(key)
  -- exit on any key press
  love.event.quit()
end

function love.draw()
  -- center on screen
  local w, h = love.graphics.getDimensions()
  love.graphics.translate(w / 2 - (C.DIGIT_WIDTH * 6 + C.COLON_WIDTH * 2) / 2, h / 2 - C.DIGIT_HEIGHT / 2)

  -- get string representation of time
  local be4 = format_hms(timestamp - 1)
  local now = format_hms(timestamp)

  -- where we are in the animation, between 0 and 1
  local anim = math.min(1, millisecond / C.ANIMATION_TIME)

  for i = 1, #now do
    local a = be4:sub(i, i)
    local b = now:sub(i, i)

    if a == " " then
      -- draw colon between every two digits
      love.graphics.circle("fill", math.floor(C.COLON_WIDTH / 2), math.floor(C.DIGIT_HEIGHT * 0.35), 6)
      love.graphics.circle("fill", math.floor(C.COLON_WIDTH / 2), math.floor(C.DIGIT_HEIGHT * 0.65), 6)
      love.graphics.translate(C.COLON_WIDTH, 0)
    else
      -- render digit
      local curve = {}
      for j = 1, #digits[a] do
        table.insert(curve, (digits[b][j] - digits[a][j]) * anim + digits[a][j])
      end
      love.graphics.line(love.math.newBezierCurve(curve):render())
      love.graphics.translate(C.DIGIT_WIDTH, 0)
    end
  end
end
