
local Player
do
    Player = setmetatable({}, {
        __tostring = function()
            return "Player"
        end,
    })
    Player.__index = Player
    
    function Player.new(...)
        local self = setmetatable({}, Player)
        return self:constructor(...) or self
    end
    
    function Player:constructor(size, speed, health, pickupRange)
        self.size = size
        self.speed = speed
        self.position = Vector2.zero
        self.health = health
        self.pickupRange = pickupRange
        self.healthLimit = upgrades[upgradesEnum.increaseHealth].default
        self.points = 0
        self.moveDirection = Vector2.zero
        self.ammoReserve = { 
            light = 10,
            medium = 30,
            heavy = 0,
            shotgun = 0,
            special = math.huge
        }
        self.upgrades = {}
    end

    -- Function to calculate the distance from the player to another object
    function Player:distanceFrom(obj)
        return self.position:distance(obj.position)
    end

    -- Function to detect collisions with projectiles
    function Player:detectCollisions()
        for i, obj in pairs(projectiles) do
            if self:distanceFrom(obj) < self.size and obj.isFriendly == false then
                self.health = self.health - obj.damage -- Reduce health by projectile damage
                projectiles[i] = nil -- Remove the projectile
            end
        end
    end

    -- Update function to handle player behavior
    function Player:update(deltaTime)
        self:detectCollisions() -- Detect collisions with projectiles
        self:checkHealth() -- Check health status
        self:updateUpgrades(deltaTime) -- Update upgrades

        local x, y = 0, 0

        -- Handle player movement input
        if love.keyboard.isDown("d") then
            x = -1
        elseif love.keyboard.isDown("a") then
            x = 1 
        end

        if love.keyboard.isDown("w") then
            y = 1
        elseif love.keyboard.isDown("s") then
            y = -1
        end

        local vector = Vector2.new(x, y)
        vector = vector:unit():mul(self.speed * deltaTime)
        self.position = self.position:add(vector)
        self.moveDirection = Vector2.new(x, y):unit():mul(self.speed) -- Update the player's movement direction
    end

    -- Draw function to render the player
    function Player:draw()
        local halfSize = self.size / 2
        local position = camera:toScreen(self.position)
        love.graphics.rectangle("fill", position.x - halfSize, position.y - halfSize, self.size, self.size) -- Draw the player
    end

    -- Function to check the player's health
    function Player:checkHealth()
        if self.health < 1 then
            self.health = -1 -- Set health to -1 if it drops below 1
        end
    end

    -- Function to upgrade the player
    function Player:upgrade(upgrade)
        self.upgrades[upgrade] = (self.upgrades[upgrade] or 0) + 1 -- Track the number of times an upgrade is bought
        
        if upgrade == upgradesEnum.increaseHealth then
            self.healthLimit = upgrades[upgrade].default + (self.upgrades[upgrade] * 50) -- Increase health limit
        
        elseif upgrade == upgradesEnum.addAmmo then
            for ammoType in pairs(player.ammoReserve) do
                player.ammoReserve[ammoType] = player.ammoReserve[ammoType] + upgrades[upgrade].value -- Add ammo to reserve
            end

        elseif upgrade == upgradesEnum.addHealth then
            player.health = player.healthLimit -- Restore health to the limit
        end
    end

    -- Function to update player upgrades over time
    function Player:updateUpgrades(deltaTime)
        for upgrade, amount in pairs(self.upgrades) do
            local data = upgrades[upgrade]
            if upgrade == upgradesEnum.regenerateHealth then
                self.health = math.min(self.healthLimit, self.health + (data.regenRate * amount * deltaTime)) -- Regenerate health
            end
            if upgrade == upgradesEnum.regenerateMediumAmmo then
                self.ammoReserve["medium"] = math.min(999, self.ammoReserve["medium"] + (data.regenRate * amount * deltaTime)) -- Regenerate medium ammo
            end
        end
    end
end

return Player