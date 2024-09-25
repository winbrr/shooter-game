-- classes
Vector2 = require("classes/vector2")
projectileClass = require("classes/projectile")
mathUtils = require("classes/mathUtils")
local playerClass = require("classes/player")
local weaponClass = require("classes/weapon")
local cameraClass = require("classes/camera")

windowWidth, windowHeight = love.graphics.getDimensions()
player = playerClass.new(50, 600,  windowWidth / 2, windowHeight / 2)
local defaultWeapon = weaponClass.new(0.2, 10, 1, 800)
local inventory = {defaultWeapon}
camera = cameraClass.new()

local function drawReference()
    local rx, ry = camera:toScreen(0,0)
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", rx, ry, 3)
    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(0, 1, 0)
    local Rx, Ry =  camera:toScreen(camera:toWorld(64, 64))
    love.graphics.circle("fill", Rx, Ry, 3)
    love.graphics.setColor(1, 1, 1)
  end

function love.update(deltaTime)
    weaponClass.update(deltaTime, inventory)
    camera:update(deltaTime)
end

function love.draw()
    camera:draw()
    drawReference()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
end

function love.resize(w, h)
    windowWidth, windowHeight = w, h
end
