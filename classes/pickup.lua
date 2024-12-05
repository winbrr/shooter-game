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
        self.position = Vector2.new(Xpos, Ypos)
        self.size = size
        pickups[id()] = self
    end
    

    function Pickup.update()
        for i, obj in pairs(pickups) do
            if player:distanceFrom(obj) < player.pickupRange then
                if obj.category == "ammo" then
                    for ammoType in pairs(player.ammoReserve) do
                        player.ammoReserve[ammoType] = player.ammoReserve[ammoType] + obj.value
                        pickups[i] = nil
                    end
                elseif obj.category == "health" then
                    player.health = player.health + obj.value
                    if player.health > player.healthLimit then
                        player.health = player.healthLimit
                    end
                    pickups[i] = nil
                end
            end
        end
    end

    function Pickup.draw()
        for _, obj in pairs(pickups) do
            local halfSize = obj.size / 2
            local position =  camera:toScreen(obj.position)
            love.graphics.rectangle("fill", position.x - halfSize, position.y - halfSize, obj.size, obj.size)
        end
    end
end

return Pickup