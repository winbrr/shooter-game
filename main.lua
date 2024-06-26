-- classes
Vector2 = require("classes/vector2")
local playerClass = require("classes/player")
projectileClass = require("classes/projectile")
local weaponClass = require("classes/weapon")
local cameraClass = require("classes/camera")

local windowWidth, windowHeight = love.graphics.getDimensions()
player = playerClass.new(50, 400,  windowWidth / 2, windowHeight / 2)
local defaultWeapon = weaponClass.new(0.2, 10, 1, 500)
local inventory = {defaultWeapon}
local camera = cameraClass.new()

function love.update(deltaTime)
    weaponClass.update(deltaTime, inventory)
    camera:update(deltaTime)
end

function love.draw()
    camera:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
end

function love.resize(w, h)
    windowWidth, windowHeight = w, h
end
