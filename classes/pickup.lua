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
    
    function Pickup:constructor(value, category, Xpos, Ypos)
        self.value = value
        self.category = category
        self.position = Vector2.new(Xpos, Ypos)
        self.size = 40
        pickups[id()] = self
    end
    

    function Pickup.update()
        for i, obj in pairs(pickups) do
            -- Check if the player is within pickup range
            if player:distanceFrom(obj) < player.pickupRange then
                if obj.category == "ammo" then
                    -- Add ammo to the player's reserve
                    for ammoType in pairs(player.ammoReserve) do
                        player.ammoReserve[ammoType] = player.ammoReserve[ammoType] + obj.value
                        pickups[i] = nil -- Remove the pickup
                    end
                elseif obj.category == "health" then
                    -- Add health to the player
                    player.health = player.health + obj.value
                    if player.health > player.healthLimit then
                        player.health = player.healthLimit -- Cap health at the limit
                    end
                    pickups[i] = nil -- Remove the pickup
                end
            end
        end
    end
    
    function Pickup.draw()
        for _, obj in pairs(pickups) do
            local halfSize = obj.size / 2
            local position = camera:toScreen(obj.position)
            love.graphics.rectangle("fill", position.x - halfSize, position.y - halfSize, obj.size, obj.size) -- Draw the pickup
        end
    end
end
return Pickup