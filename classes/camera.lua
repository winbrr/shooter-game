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
        self.Xpos = 0
        self.Ypos = 0
    end

    function Camera:update(deltaTime)
        player:update(deltaTime)
        projectileClass.update(deltaTime)
        pickupClass:update()
        local cameraSpeed = 4
        self.Xpos = mathUtils.lerpF(self.Xpos, player.Xpos + (windowWidth / 2), cameraSpeed, deltaTime)
        self.Ypos = mathUtils.lerpF(self.Ypos, player.Ypos + (windowHeight / 2), cameraSpeed, deltaTime)
    end

    function Camera:draw()
        player:draw()
        projectileClass.draw()
        pickupClass.draw()
    end

    function Camera:toWorld(x,y)
        local wx, wy = x - (windowWidth / 2) - self.Xpos, y - (windowHeight / 2) - self.Ypos
        return self.Xpos - x, self.Ypos - y
    end

    function Camera:toScreen(x,y)
        return self.Xpos - x, self.Ypos - y
    end
end
return Camera