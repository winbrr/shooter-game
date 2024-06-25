-- classes
local Vector2 = require("classes/vector2")
local playerClass = require("classes/player")
local projectileClass = require("classes/projectile")
local weaponClass = require("classes/weapon")

local t = 0
local windowWidth, windowHeight = love.graphics.getDimensions()
local player = playerClass.new(50, 400,  windowWidth / 2, windowHeight / 2)
local defaultWeapon = weaponClass.new(0.2, 10, 1, player, projectileClass)

function love.update(deltaTime)
    t = t + deltaTime
    
    player:updatePlayer(deltaTime)
    defaultWeapon:shoot(t)
end

function love.draw()
    player:drawPlayer()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
end

function love.resize(w, h)
    windowWidth, windowHeight = w, h
end
