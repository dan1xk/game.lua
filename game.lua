local movement = require("movement")
local Vector2 = require("utils.vector2")
local switchContext
local game = {}
local player = Vector2.new(0, 0)
local playerSize = 50
local w, h = love.graphics.getDimensions()
local dx = 0
local dy = 0
local bullets = {}
local bulletSpeed = 2000
local shootInterval = 0.1
local shootTimer = shootInterval
local playerSpeed = 500

function drawPlayer()
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", player.x, player.y, playerSize)
  love.graphics.setColor(1, 1, 1)
end

function drawPlayerInfo()
  local playerInfo = {
    "dx: " .. dx,
    "dy: " .. dy,
    "Player X: " .. player.x,
    "Player Y: " .. player.y,
    "Mouse X: " .. mousePosition.x,
    "Mouse Y: " .. mousePosition.y
  }
  for i, info in ipairs(playerInfo) do
    love.graphics.print(info, 10, 10 + (i - 1) * 20)
  end
end

function game.load(switchContextCallback)
  switchContext = switchContextCallback
  player.x = w / 2
  player.y = h / 2
end

function game.update(dt)
  local delta = movement(dt, player, playerSpeed, playerSize, w, h)
  dx, dy = delta.x, delta.y
  updateBullets(dt)
  local mouseX, mouseY = love.mouse.getPosition()
  mousePosition = Vector2.new(mouseX, mouseY)

  print(mouseX, mouseY, player.x, player.y, playerSize, dx, dy)

  if love.mouse.isDown(1) then
    shootTimer = shootTimer - dt
    if shootTimer <= 0 then
      shootBullet(mousePosition)
      shootTimer = shootInterval
    end
  end
end

function game.draw()
  drawPlayer()
  drawPlayerInfo()
  drawBullets()
end

function game.keypressed(key)
  if key == "escape" then
    switchContext("menu")
  end
end

function shootBullet(mousePosition)
  local dx = mousePosition.x - player.x
  local dy = mousePosition.y - player.y
  local len = math.sqrt(dx * dx + dy * dy)
  if len > 0 then
    dx, dy = dx / len, dy / len
  end
  table.insert(bullets, { x = player.x, y = player.y, dx = dx, dy = dy })
end

function updateBullets(dt)
  for i = #bullets, 1, -1 do
    local bullet = bullets[i]
    bullet.x = bullet.x + bullet.dx * bulletSpeed * dt
    bullet.y = bullet.y + bullet.dy * bulletSpeed * dt
    if bullet.x < 0 or bullet.x > w or bullet.y < 0 or bullet.y > h then
      table.remove(bullets, i)
    end
  end
end

function drawBullets()
  love.graphics.setColor(1, 1, 0)
  for _, bullet in ipairs(bullets) do
    love.graphics.circle("fill", bullet.x, bullet.y, playerSize / 3)
  end
end

function game.updateDimensions(width, height)
  w = width
  h = height
  player.x = width / 2
  player.y = height / 2
end

return game
