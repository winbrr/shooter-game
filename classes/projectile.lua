local Projectile
do
    Projectile = setmetatable({}, {
        __tostring = function()
            return "Projectile"
        end,
    })
    Projectile.__index = Projectile
    
    local projectiles = {}

    function Projectile.new(...)
        local self = setmetatable({}, Projectile)
        return self:constructor(...) or self
    end
    
    function Projectile:constructor(origin, direction, speed, isFriendly, size)
        self.position = origin
        self.origin = origin
        self.direction = direction
        self.speed = speed
        self.isFriendly = isFriendly
        self.t = love.timer.getTime()
        self.size = size

        table.insert(projectiles, self)
    end

    function Projectile.update(deltaTime)
        local t = love.timer.getTime()
        for _, obj in ipairs(projectiles) do
            obj.position = obj.origin:add(obj.direction:mul(obj.speed * (t - obj.t)))
        end
    end

    function Projectile.draw()
        for i, obj in ipairs(projectiles) do
            local halfSize = obj.size / 2
            love.graphics.circle("fill", obj.position.x - camera.Xpos + (windowWidth / 2) - halfSize, obj.position.y - camera.Ypos + (windowHeight / 2) - halfSize, obj.size)
        end
    end

    function Projectile.detectCollision(plr)
        for i, obj in ipairs(projectiles) do
            local playerPosition = Vector2.new(plr.Xpos, plr.Ypos)
            local difference = playerPosition:sub(obj.position)
            
            if Vector2.magnitude(difference) < obj.size  and obj.isFriendly == false then
                plr.health = plr.health - 1
                table.remove(projectiles,i)
            end
        end
    end
end

return Projectile