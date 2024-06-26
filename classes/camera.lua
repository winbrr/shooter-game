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

    end

    function Camera:update(deltaTime)
        player:update(deltaTime)
        projectileClass.update(deltaTime)
    end

    function Camera:draw()
        player:draw()
        projectileClass.draw()
    end
end
return Camera