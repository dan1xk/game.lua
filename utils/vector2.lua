local Vector2 = {}
Vector2.__index = Vector2

-- Constructor
function Vector2:new(x, y)
  local self = setmetatable({}, Vector2)
  self.x = x or 0
  self.y = y or 0
  return self
end

function Vector2:add(other)
  return Vector2:new(self.x + other.x, self.y + other.y)
end

function Vector2:normalize()
  local len = math.sqrt(self.x * self.x + self.y * self.y)
  if len > 0 then
    return Vector2:new(self.x / len, self.y / len)
  else
    return Vector2:new(0, 0)
  end
end

return Vector2
