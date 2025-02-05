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
    
    function Weapon:constructor(name, fireRate, magSize, reloadSpeed, projectileSpeed, imagePath, ammoType, damage)
        self.name = name
        self.fireRate = fireRate
        self.magSize = magSize
        self.reloadSpeed = reloadSpeed
        self.projectileSpeed = projectileSpeed
        self.imagePath = imagePath
        self.ammoType = ammoType
        self.damage = damage
    end

    -- time variable for weapon updates
    local t = 0


    function Weapon.update(deltaTime, inventory)
        t = t + deltaTime
        local obj = inventory[weaponIndex]
        if t > obj.fireRate and love.mouse.isDown(1) and player.ammoReserve[obj.ammoType] > 0 then -- Check if the player can fire
            projectileClass.new(player.position, Weapon.getProjectileDirection(), obj.projectileSpeed, true, 5, obj.damage) -- Create a new projectile
            player.ammoReserve[obj.ammoType] = player.ammoReserve[obj.ammoType] - 1 -- Reduce ammo reserve
            t = 0 -- Reset the timer
        end
    end


    function Weapon.getProjectileDirection()
        local mousePos = Vector2.new(love.mouse.getPosition())
        local plrPos = camera:toScreen(player.position)
        return plrPos:getDirection(mousePos) -- Get the direction from the player to the mouse
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
        local position = camera:toScreen(player.position)
        local flip = 1
        if love.mouse.getX() < position.x then -- Flip the weapon based on the mouse position
            flip = -1
        else
            flip = 1 
        end
        love.graphics.draw(self.image, position.x, position.y, angle, 1, flip, width / 2, height / 2) -- Draw the weapon
    end
end

return Weapon