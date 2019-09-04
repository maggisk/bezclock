local C = require "const"

local current_i = 1
local points = {105,10,-16,39,-5,236,79,278,68,331,280,126,91,11}

local w, h

function love.load()
  love.window.setFullscreen(true)
  w, h = love.graphics.getDimensions()
end

function love.draw()
  love.graphics.translate(w / 2 - C.DIGIT_WIDTH / 2, h / 2 - C.DIGIT_HEIGHT / 2)
  love.graphics.setLineWidth(1)
  love.graphics.rectangle("line", 0, 0, C.DIGIT_WIDTH, C.DIGIT_HEIGHT)
  love.graphics.setLineWidth(3)
  curve = love.math.newBezierCurve(points)
  love.graphics.line(curve:render())
  love.graphics.circle("fill", points[current_i * 2 - 1], points[current_i * 2], 5)
end

function love.mousepressed(x, y)
  points[current_i * 2 - 1] = x - w / 2 + C.DIGIT_WIDTH / 2
  points[current_i * 2]     = y - h / 2 + C.DIGIT_HEIGHT / 2
  -- print coordinates on every change so thay can be copy pasted into the clock code
  print(table.concat(points, ','))
end

function love.keypressed(key)
  n = tonumber(key)
  if n ~= nil and n >= 1 and n <= 7 then
    current_i = n
  elseif key == "escape" then
    love.event.quit()
  end
end
