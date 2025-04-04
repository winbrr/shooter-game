local Projectile
do
    Projectile = setmetatable({}, {
        __tostring = function()
            return "Projectile"
        end,
    })
    Projectile.__index = Projectile

    projectiles = {}

    function Projectile.new(...)
        local self = setmetatable({}, Projectile)
        return self:constructor(...) or self
    end
    
    function Projectile:constructor(origin, direction, speed, isFriendly, size, damage)
        self.position = origin
        self.origin = origin
        self.direction = direction
        self.speed = speed
        self.isFriendly = isFriendly
        self.t = love.timer.getTime()
        self.size = size
        self.damage = damage
        projectiles[id()] = self
    end

    function Projectile.update(deltaTime)
        local t = love.timer.getTime() -- Get the current time
    
        for i, obj in pairs(projectiles) do
            if menu.active then
                obj.t = obj.t + deltaTime -- Increment the projectile's time if the menu is active
            end
            obj.position = obj.origin:add(obj.direction:mul(obj.speed * (t - obj.t))) -- Update the projectile's position
            if t - obj.t > 10 then
                projectiles[i] = nil -- Remove the projectile if it has existed for more than 10 seconds
            end
        end
    end
    
    -- Draw function to render the projectiles
    function Projectile.draw()
        for i, obj in pairs(projectiles) do
            local halfSize = obj.size / 2
            local position = camera:toScreen(obj.position)
            love.graphics.circle("fill", position.x, position.y, obj.size) -- Draw the projectile as a circle
        end
    end
end
return Projectile