local playerClass = require("classes/player")
local projectileClass = require("classes/projectile")
local Vector2 = require("classes/vector2")

local windowWidth, windowHeight = love.graphics.getDimensions()
local t = 0
local player = playerClass.new(50, 400,  windowWidth / 2, windowHeight / 2)

function love.load()
    player:loadPlayer()
end

function love.update(deltaTime)
    player:updatePlayer(deltaTime)
    projectileClass.update()
    t = t + deltaTime

    if t > 0.2 and love.keyboard.isDown("space") then
        projectileClass.new(Vector2.new(player.Xpos, player.Ypos), math.random(175,185), 500)
        t = 0
    end
end

function love.draw()
    player:drawPlayer()
    projectileClass.draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
end

function love.resize(w, h)
    windowWidth, windowHeight = w, h
end