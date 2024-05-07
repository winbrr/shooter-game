local playerClass = require("classes/player")

local windowWidth, windowHeight = love.graphics.getDimensions()

local player = playerClass.new(50, 400,  windowWidth / 2, windowHeight / 2)

function love.load()
    player:loadPlayer()
end

function love.update(deltaTime)
    player:updatePlayer(deltaTime)

end

function love.draw()
    player:drawPlayer()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
end`

function love.resize(w, h)
    windowWidth, windowHeight = w, h
end