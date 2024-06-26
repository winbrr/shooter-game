local Projectile = require("classes/projectile")
local Player = require("classes/player")

local Weapon
do
    Weapon = setmetatable({}, {
        __tostring = function()
            return "Weapon"
        end,
    })
    Weapon.__index = Weapon
    
    local t = 0

    function Weapon.update(deltaTime, inventory)
        t = t + deltaTime
        for i, obj in ipairs(inventory) do
            if t > obj.fireRate and love.keyboard.isDown("space") then
                projectileClass.new(Vector2.new(player.Xpos, player.Ypos), Weapon.getProjectileAngle(), obj.bulletSpeed, true, 10)
                t = 0
            end
        end
    end

    function Weapon.getProjectileAngle()
        local mousePos = Vector2.new(love.mouse.getPosition())
        local plrPos = Vector2.new(player.Xpos, player.Ypos)
        return mousePos:sub(plrPos):unit()
    end                         

    function Weapon.new(...)
        local self = setmetatable({}, Weapon)
        return self:constructor(...) or self
    end
    
    function Weapon:constructor(fireRate, magSize, reloadSpeed, bulletSpeed)
        self.fireRate = fireRate
        self.magSize = magSize
        self.reloadSpeed = reloadSpeed
        self.bulletSpeed = bulletSpeed
    end
end

return Weapon