---@diagnostic disable: lowercase-global
local game = require("game")
local menu = require("menu")

local currentScreen = "menu"

function love.load()
    love.window.setTitle("Lua_game")
    love.mouse.setVisible(false)

    love.window.setFullscreen(true, "desktop")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    menu.load(switchContext)
    game.load(switchContext)

    updateDimensions()
end

function love.update(dt)
    if currentScreen == "menu" then
        menu.update(dt)
    elseif currentScreen == "game" then
        game.update(dt)
    end
end

function love.draw()
    if currentScreen == "menu" then
        menu.draw()
    elseif currentScreen == "game" then
        game.draw()
    end
end

function love.keypressed(key)
    if currentScreen == "menu" then
        menu.keypressed(key)
    elseif currentScreen == "game" then
        game.keypressed(key)
    end
end

function switchContext(context)
    if context == "menu" then
        currentScreen = "menu"
    elseif context == "game" then
        currentScreen = "game"
    end
end

function updateDimensions()
    local width, height = love.graphics.getDimensions()
    game.updateDimensions(width, height)
end
