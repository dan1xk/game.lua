local menu = {}
local switchContext

function menu.load(switchContextCallback)
  switchContext = switchContextCallback
end

function menu.update(dt) end

function menu.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Press any key to start", 0, love.graphics.getHeight() / 2,
    love.graphics.getWidth(), "center")
end

function menu.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key then
    switchContext('game')
  end
end

return menu
