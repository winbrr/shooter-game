local Pickup
do
    Pickup = setmetatable({}, {
        __tostring = function()
            return "Pickup"
        end,
    })
    Pickup.__index = Pickup

    local pickups = {}
    
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
        pickups[id()] = self
    end
    
    function Pickup:getPlayerDistance()
        local plrPos = Vector2.new(player.Xpos,player.Ypos)
        local pickupPos = Vector2.new(self.Xpos, self.Ypos)
        return plrPos:sub(pickupPos):magnitude()
    end

    function Pickup.update()
        for i, obj in pairs(pickups) do
            if obj:getPlayerDistance() < player.pickupRange then
                if obj.category == "ammo" then
                    for ammoType in pairs(player.ammoReserve) do
                        player.ammoReserve[ammoType] = player.ammoReserve[ammoType] + obj.value
                        pickups[i] = nil
                    end
                end
            end
        end
    end

    function Pickup.draw()
        for _, obj in pairs(pickups) do
            local halfSize = obj.size / 2
            local rx, ry =  camera:toScreen(obj.Xpos, obj.Ypos)
            love.graphics.rectangle("fill", rx - halfSize, ry - halfSize, obj.size, obj.size)
        end
    end
end

return Pickup