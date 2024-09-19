-- classes
Vector2 = require("classes/vector2")
projectileClass = require("classes/projectile")
mathUtils = require("classes/mathUtils")
local playerClass = require("classes/player")
local weaponClass = require("classes/weapon")
local cameraClass = require("classes/camera")

windowWidth, windowHeight = love.graphics.getDimensions()
player = playerClass.new(50, 400,  windowWidth / 2, windowHeight / 2)
local defaultWeapon = weaponClass.new(0.2, 10, 1, 500)
local inventory = {defaultWeapon}
camera = cameraClass.new()

local function drawReference()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", camera.Xpos, camera.Ypos, 3)
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
