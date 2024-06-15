local Vector2 = require("utils.vector2")

local function movement(dt, player, playerSpeed, playerSize, w, h)
  local movement = Vector2.new(0, 0)

  if love.keyboard.isDown("w", "up") then movement.y = movement.y - 1 end
  if love.keyboard.isDown("s", "down") then movement.y = movement.y + 1 end
  if love.keyboard.isDown("a", "left") then movement.x = movement.x - 1 end
  if love.keyboard.isDown("d", "right") then movement.x = movement.x + 1 end

  movement = Vector2.normalize(movement)

  local nextPosition = Vector2.new(player.x, player.y):add(Vector2.new(movement.x * playerSpeed * dt,
    movement.y * playerSpeed * dt))

  -- Collision
  if nextPosition.x + playerSize > w then nextPosition.x = w - playerSize end
  if nextPosition.x - playerSize < 0 then nextPosition.x = playerSize end
  if nextPosition.y + playerSize > h then nextPosition.y = h - playerSize end
  if nextPosition.y - playerSize < 0 then nextPosition.y = playerSize end

  player.x = nextPosition.x
  player.y = nextPosition.y

  return movement
end

return movement
