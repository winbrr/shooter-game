local Player = require("classes/player")

local Weapon
do
    Weapon = setmetatable({}, {
        __tostring = function()
            return "Weapon"
        end,
    })
    Weapon.__index = Weapon
    
    function Weapon.new(...)
        local self = setmetatable({}, Weapon)
        return self:constructor(...) or self
    end
    
    function Weapon:constructor(fireRate, magSize, reloadSpeed, projectileSpeed)
        self.fireRate = fireRate
        self.magSize = magSize
        self.reloadSpeed = reloadSpeed
        self.projectileSpeed = projectileSpeed
    end

    local t = 0

    function Weapon.update(deltaTime, inventory)
        t = t + deltaTime
        for i, obj in ipairs(inventory) do
            if t > obj.fireRate and love.keyboard.isDown("space") then
                local Xdif = player.Xpos - camera.Xpos
                local Ydif = player.Ypos - camera.Ypos
                projectileClass.new(Vector2.new(camera.Xpos - Xdif, camera.Ypos - Ydif), Weapon.getProjectileAngle(), obj.projectileSpeed, true, 10)
                t = 0
            end
        end
    end

    function Weapon.getProjectileAngle()
        local mousePos = Vector2.new(love.mouse.getPosition())
        local plrPos = Vector2.new(windowWidth / 2, windowHeight / 2)
        return mousePos:sub(plrPos):unit()
    end                         
end

return Weapon