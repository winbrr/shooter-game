
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
        self.healthLimit = 100
        self.points = 0
        self.moveDirection = Vector2.zero
        self.ammoReserve = {
            light = 10,
            medium = 999999,
            heavy = 0,
            shotgun = 0
        }
  
    end

    function Player:loadPlayer()
    
    end

    function Player:distanceFrom(obj)
        return self.position:distance(obj.position)
    end

    function Player:detectCollisions()
        for i, obj in pairs(projectiles) do
            if self:distanceFrom(obj) < self.size and obj.isFriendly == false then
                self.health = self.health - obj.damage
                projectiles[i] = nil
            end
        end
    end

    function Player:update(deltaTime)
        self:detectCollisions()

        local x, y = 0, 0

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

        local vector = Vector2.new(x,y)

        vector = vector:unit():mul(self.speed * deltaTime)

        self.position = self.position:add(vector)
        self.moveDirection = Vector2.new(x,y):unit():mul(self.speed)
    end

    function Player:draw()
        local halfSize = self.size / 2
        local position = camera:toScreen(self.position)
        love.graphics.rectangle("fill", position.x - halfSize, position.y - halfSize, self.size, self.size)
    end
end

return Player