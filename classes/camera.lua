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
        local cameraSpeed = 4
        self.Xpos = mathUtils.lerpF(self.Xpos, player.Xpos, cameraSpeed, deltaTime)
        self.Ypos = mathUtils.lerpF(self.Ypos, player.Ypos, cameraSpeed, deltaTime)
    end

    function Camera:draw()
        player:draw()
        projectileClass.draw()
    end
end
return Camera