local movement           = require("movement")
local Vector2            = require("utils.vector2")
local switchContext      = "menu"
local game               = {}
local player             = Vector2:new(0, 0)
local playerSize         = 50
local w, h               = love.graphics.getDimensions()
local dx                 = 0
local dy                 = 0
local bullets            = {}
local bulletSpeed        = 2000
local shootInterval      = 0.2
local shootTimer         = shootInterval
local playerSpeed        = 500
local previousMouseState = false
local mousePosition      = Vector2:new(0, 0)
local cannonAngle        = 0

function bulletSound()
  bulletSnd = love.audio.newSource("sounds/gun.mp3", "static")
  bulletSnd:setVolume(0.1)
  bulletSnd:play()
end

function drawPlayer()
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", player.x, player.y, playerSize)
  love.graphics.setColor(1, 1, 1)
end

function drawPlayerCannon()
  local dx = mousePosition.x - player.x
  local dy = mousePosition.y - player.y
  local cannonAngle = math.atan(dy / dx)

  if dx < 0 and dy >= 0 then
    cannonAngle = cannonAngle + math.pi
  elseif dx < 0 and dy < 0 then
    cannonAngle = cannonAngle - math.pi
  end

  local offsetX = playerSize / 2
  local offsetY = -15
  local w = playerSize + 25
  local h = 30
  love.graphics.push()
  love.graphics.translate(player.x, player.y)
  love.graphics.rotate(cannonAngle)
  love.graphics.setColor(1, 1, 0)
  love.graphics.rectangle("fill", offsetX, offsetY, w, h)
  love.graphics.pop()
  love.graphics.setColor(1, 1, 1)
end

function drawDebugInfos()
  local playerInfo = {
    "dx: " .. dx,
    "dy: " .. dy,
    "Player X: " .. player.x,
    "Player Y: " .. player.y,
    "Mouse X: " .. mousePosition.x,
    "Mouse Y: " .. mousePosition.y,
    "Cannon Angle: " .. cannonAngle,
    "YY: " .. mousePosition.y - player.y,
    "XX: " .. mousePosition.x - player.x
  }
  for i, info in ipairs(playerInfo) do
    love.graphics.print(info, 10, 10 + (i - 1) * 20)
  end
end

function drawPlayerCursor()
  love.graphics.setColor(0, 1, 0)
  love.graphics.circle("fill", mousePosition.x, mousePosition.y, 3)
  love.graphics.setColor(1, 1, 1)
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
  mousePosition = Vector2:new(mouseX, mouseY)

  local isMouseDown = love.mouse.isDown(1)

  if isMouseDown then
    shootTimer = shootTimer - dt
    if shootTimer <= 0 then
      shootBullet(mousePosition)
      shootTimer = shootInterval
    end
  elseif previousMouseState and not isMouseDown then
    shootBullet(mousePosition)
    shootTimer = shootInterval
  end

  previousMouseState = isMouseDown
end

function game.draw()
  drawPlayer()
  drawPlayerCannon()
  drawDebugInfos()
  drawBullets()
  drawPlayerCursor()
end

function game.keypressed(key)
  if key == "escape" then
    switchContext("menu")
  end
end

function shootBullet(mousePosition)
  local dx = mousePosition.x - player.x
  local dy = mousePosition.y - player.y
  local normalized = Vector2:new(dx, dy):normalize()
  local cannonLength = playerSize + 65
  local bulletStartX = player.x + normalized.x * cannonLength
  local bulletStartY = player.y + normalized.y * cannonLength
  bulletSound()

  table.insert(bullets, { x = bulletStartX, y = bulletStartY, dx = normalized.x, dy = normalized.y })
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
