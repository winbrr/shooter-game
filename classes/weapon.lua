local Projectile = require("classes/projectile")
local Vector2 = require("classes/vector2")
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
    
    function Weapon:constructor(fireRate, magSize, reloadSpeed, plr, projectile)
        self.fireRate = fireRate
        self.magSize = magSize
        self.reloadSpeed = reloadSpeed
        self.plr = plr
        self.projectile = projectile
    end

    function Weapon:getProjectileAngle(plr)
        mouseX = love.mouse.getX
        mouseY = love.mouse.getY
        local mousePos = Vector2.new(mouseX,MouseY)
        local plrX = self.plr.Xpos
        local plrY = self.plr.Ypos
        local plrPos = Vector2.new(plrX,plrY)

        return Vector2.angle(mousePos, plrPos)
    end

    function Weapon:shoot(time)
        if time > self.fireRate and love.keyboard.isDown("space") then
            projectile.new(Vector2.new(plr.Xpos, plr.Ypos), Weapon:getProjectileAngle(), 500, true, 10)
            time = 0
        end
    end
end
