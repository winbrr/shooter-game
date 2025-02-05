-- Load required classes and utilities
Vector2 = require("classes/vector2")
projectileClass = require("classes/projectile")
pickupClass = require("classes/pickup")
enemyClass = require("classes/enemy")
mathUtils = require("utils/mathUtils")
HUDclass = require("classes/HUD")
buttonClass = require("classes/button")
id = require("utils/id")
require("config/fonts")
require("config/upgrades")
local waveManagerClass = require("classes/waveManager")
local playerClass = require("classes/player")
local weaponClass = require("classes/weapon")
local cameraClass = require("classes/camera")
menuClass = require("classes/menu")

-- Initialize game variables
windowWidth, windowHeight = love.graphics.getDimensions()
player = playerClass.new(50, 600, 100, 40)
local defaultWeapon = weaponClass.new("Pistol", 0.2, 10, 1, 1500, "assets/sprites/weapons/G19.png", "special", 25)
local defaultWeapon2 = weaponClass.new("Rifle", 0.1, 5, 1, 1500, "assets/sprites/weapons/F1.png", "medium", 35)
waveManager = waveManagerClass.new()
camera = cameraClass.new()
menu = menuClass.new()
hud = HUDclass.new()
inventory = {defaultWeapon, defaultWeapon2}
weaponIndex = 1

-- Function to get the number of elements in a table
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
    for i, obj in ipairs(inventory) do -- Load all weapons
        obj:load()
    end
end


function love.update(deltaTime)
    if menu.active == false then -- Update game elements if the menu is not active
        weaponClass.update(deltaTime, inventory)
        camera:update(deltaTime)
        waveManager:update(deltaTime)
    end
    projectileClass.update(deltaTime)
    buttonClass.update()
    menu:update()
end


function love.draw(deltaTime)
    camera:draw()
    local obj = inventory[weaponIndex] -- Get the current weapon
    obj:draw()
    menu:draw()
    buttonClass.draw()
end

-- Key pressed function to handle input
function love.keypressed(key, scancode, isrepeat)
    if key == "escape" and menu.state == "" then -- Pause the game
        menu.active = true
        menu.state = "pause"
    end
    if key == "1" then
        weaponIndex = 1
    end
    if key == "2" then
        weaponIndex = 2
    end
end

-- Resize function to handle window resizing
function love.resize(w, h)
    windowWidth, windowHeight = w, h
end