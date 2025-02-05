local Camera
do
    Camera = setmetatable({}, {
        __tostring = function()
            return "Camera"
        end,
    })
    Camera.__index = Camera
    
    function Camera.new(...)
        local self = setmetatable({}, Camera)
        return self:constructor(...) or self
    end
    
    function Camera:constructor()
        self.position = Vector2.zero
    end

-- Update function to handle camera movement
function Camera:update(deltaTime)
    player:update(deltaTime)
    pickupClass:update()
    enemyClass.update(deltaTime)

    local cameraSpeed = 4
    local center = Vector2.new(windowWidth / 2, windowHeight / 2)
    -- Smoothly move the camera towards the player position
    self.position = self.position:add(player.position:add(center):sub(self.position):mul(1 - math.exp(-cameraSpeed * deltaTime)))
end

-- Draw function to render the game elements
function Camera:draw()
    player:draw()
    projectileClass.draw()
    pickupClass.draw()
    enemyClass.draw()
    hud:draw()
end

-- UNUSED
function Camera:toWorld(position)
    -- Implementation needed
end

-- Convert world position to screen position
function Camera:toScreen(position)
    return self.position:sub(position)
end
end
return Camera