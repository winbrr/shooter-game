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

    function Camera:update(deltaTime)
        player:update(deltaTime)
        projectileClass.update(deltaTime)
        pickupClass:update()
        enemyClass.update(deltaTime)

        local cameraSpeed = 4
        local center = Vector2.new(windowWidth / 2, windowHeight / 2);
        self.position = self.position:add(player.position:add(center):sub(self.position):mul(1 - math.exp(-cameraSpeed * deltaTime)))
    end

    function Camera:draw()
        player:draw()
        projectileClass.draw()
        pickupClass.draw()
        enemyClass.draw()
        HUDclass:draw()
    end

    function Camera:load()
        HUDclass:load()
    end

    function Camera:toWorld(position)
        -- do later
    end

    function Camera:toScreen(position)
        return self.position:sub(position)
    end
end
return Camera