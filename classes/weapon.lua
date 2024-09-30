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
    
    function Weapon:constructor(fireRate, magSize, reloadSpeed, projectileSpeed, imagePath)
        self.fireRate = fireRate
        self.magSize = magSize
        self.reloadSpeed = reloadSpeed
        self.projectileSpeed = projectileSpeed
        self.imagePath = imagePath
    end

    local t = 0

    function Weapon.update(deltaTime, inventory)
        t = t + deltaTime
        local obj = inventory[weaponIndex]
        if t > obj.fireRate and love.mouse.isDown(1) then
            projectileClass.new(Vector2.new(player.Xpos, player.Ypos), Weapon.getProjectileDirection(), obj.projectileSpeed, true, 5)
            t = 0
        end
    end

    function Weapon.getProjectileDirection()
        local mousePos = Vector2.new(love.mouse.getPosition())
        local plrPos = Vector2.new(camera:toScreen(player.Xpos,player.Ypos))
        return plrPos:sub(mousePos):unit(), Vector2.angle(plrPos, mousePos)
    end

    function Weapon:load()
        self.image = love.graphics.newImage(self.imagePath)
    end
    
    function Weapon:draw()
        if not self.image then
            return
        end
        local _, angle = Weapon.getProjectileDirection()
        local width, height = self.image:getDimensions()
        local px, py = camera:toScreen(player.Xpos, player.Ypos)
        local flip = 1
        if love.mouse.getX() < (px) then
            flip = -1
        else
            flip = 1 
        end
        love.graphics.draw(self.image, px, py, angle, 1, flip, width / 2, height / 2)
    end
end

return Weapon