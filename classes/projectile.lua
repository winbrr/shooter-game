local Vector2 = require("classes/vector2")

local Projectile
do
    Projectile = setmetatable({}, {
        __tostring = function()
            return "Projectile"
        end,
    })
    Projectile.__index = Projectile
    
    local projectiles = {}

    function Projectile.update()
        local t = love.timer.getTime()
        for _, obj in ipairs(projectiles) do
            obj.position = obj.origin:add(obj.angle:mul(obj.speed * (t - obj.t)))
            
        end
    end

    function Projectile.draw()
        local size = 10
        local halfSize = size / 2
        for _, obj in ipairs(projectiles) do
            love.graphics.circle("fill", obj.position.x - halfSize, obj.position.y - halfSize, size)
        end
    end

    function Projectile.new(...)
        local self = setmetatable({}, Projectile)
        return self:constructor(...) or self
    end
    
    function Projectile:constructor(origin, angle, speed)
        self.position = origin
        self.origin = origin
        self.angle = Vector2.new(math.sin(math.rad(angle)), math.cos(math.rad(angle)))
        self.speed = speed
        self.t = love.timer.getTime()

        table.insert(projectiles, self)
    end
end

return Projectile