local Pickup
do
    Pickup = setmetatable({}, {
        __tostring = function()
            return "Pickup"
        end,
    })
    Pickup.__index = Pickup
    
    function Pickup.new(...)
        local self = setmetatable({}, Pickup)
        return self:constructor(...) or self
    end
    
    function Pickup:constructor(value, category, Xpos, Ypos, size)
        self.value = value
        self.category = category
        self.Xpos = Xpos
        self.Ypos = Ypos
        self.size = size
    end
    
    function Pickup:getPlayerDistance()
        local plrPos = Vector2.new(player.Xpos,player.Ypos)
        local pickupPos = Vector2.new(self.Xpos, self.Ypos)
        return Vector2.magnitude(plrPos:sub(pickupPos))
    end

    function Pickup:update()
        if Pickup:getPlayerDistance() < player.pickupRange then
            love.graphics.print("TEST")
        end
    end

    function Pickup:draw()
        local halfSize = self.size / 2
        local rx, ry =  camera:toScreen(self.Xpos, self.Ypos)
        love.graphics.rectangle("fill", rx - halfSize, ry - halfSize, self.size, self.size)
    end
end

return Pickup