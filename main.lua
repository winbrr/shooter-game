-- classes
Vector2 = require("classes/vector2")
projectileClass = require("classes/projectile")
pickupClass = require("classes/pickup")
enemyClass = require("classes/enemy")
mathUtils = require("utils/mathUtils")
HUDclass = require("classes/HUD")
id = require("utils/id")
fonts = require("utils/fonts")
local waveManagerClass = require("classes/waveManager")
local playerClass = require("classes/player")
local weaponClass = require("classes/weapon")
local cameraClass = require("classes/camera")
local menuClass = require("classes/menu")


windowWidth, windowHeight = love.graphics.getDimensions()
player = playerClass.new(50, 600, 100, 40)
local defaultWeapon = weaponClass.new("Pistol", 0.2, 10, 1, 1500, "assets/sprites/guns/G19.png", "light", 25)
local defaultWeapon2 = weaponClass.new("Famas", 0.1, 5, 1, 1500, "assets/sprites/guns/F1.png", "medium", 35)
waveManager = waveManagerClass.new()
camera = cameraClass.new()
inventory = {defaultWeapon, defaultWeapon2}
weaponIndex = 1

-- local function drawReference()
--     local rx, ry = camera:toScreen(0,0)
--     love.graphics.setColor(1, 0, 0)
--     love.graphics.circle("fill", rx, ry, 3)
--     love.graphics.setColor(1, 1, 1)

--     love.graphics.setColor(0, 1, 0)
--     local Rx, Ry =  camera:toScreen(camera:toWorld(64, 64))
--     love.graphics.circle("fill", Rx, Ry, 3)
--     love.graphics.setColor(1, 1, 1)
--   end

function table.getn(t)
    local n = 0
    for _, _ in pairs(t) do
        n = n + 1
    end
    return n
end

function love.load()
    love._openConsole()
    love.graphics.setBackgroundColor(0.024, 0.029, 0.046)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    menuClass:load()
    cameraClass:load()
    for i, obj in ipairs(inventory) do
        obj:load()
    end
end

function love.update(deltaTime)
    if menuClass.active == false then
        weaponClass.update(deltaTime, inventory)
        camera:update(deltaTime)
        waveManager:update(deltaTime)
    end
end

function love.draw(deltaTime)
    camera:draw()
    -- drawReference()
    local obj = inventory[weaponIndex]
    obj:draw()
    menuClass:draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        menuClass.active = true
        menuClass.state = "pause"
    end
    if key == "1" then
        weaponIndex = 1
    end
    if key == "2" then
        weaponIndex = 2
    end
end

function love.resize(w, h)
    windowWidth, windowHeight = w, h
end
