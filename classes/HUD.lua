local HUD
do
    HUD = setmetatable({}, {
        __tostring = function()
            return "HUD"
        end,
    })
    HUD.__index = HUD
    
    function HUD.new(...)
        local self = setmetatable({}, HUD)
        return self:constructor(...) or self
    end
    
    function HUD:constructor()
        self.pointsFrame = love.graphics.newImage("assets/sprites/ui/frames/frame_points.png")
    end

    function HUD:draw()
        self:drawPoints()
        self:drawAmmo()
        self:drawWave()
        self:drawHealth()
    end

    function HUD:drawPoints() -- Draw the points frame and the player's points
        local pointsX = windowWidth - 250
        local pointsY = windowHeight - 200
        local width, height = self.pointsFrame:getDimensions( )
        love.graphics.draw(self.pointsFrame, pointsX, pointsY, 0, 0.5)
        love.graphics.print("$".. player.points, fonts.pointsFont, pointsX + (width / 16), pointsY + (height / 5.5))
    end

    function HUD:drawAmmo() -- Draw the current weapon and ammo
        local currentWeapon = inventory[weaponIndex]
        if player.ammoReserve[currentWeapon.ammoType] == "special" then
            love.graphics.print(currentWeapon.name .. "| inf", fonts.ammoFont, windowWidth - 250, windowHeight - 75)
        else
            love.graphics.print(currentWeapon.name .. "|" .. math.ceil(player.ammoReserve[currentWeapon.ammoType]) , fonts.ammoFont, windowWidth - 250, windowHeight - 75)
        end
    end

    function HUD:drawWave() -- Draw the current wave
        love.graphics.setColor(0.7,0,0)
        love.graphics.print(waveManager.currentWave, fonts.waveFont, 25, windowHeight - 150)
        love.graphics.setColor(1,1,1)
    end

    function HUD:drawHealth() -- Draw the player's health bar
        love.graphics.setColor(0,0,0,0.3)
        love.graphics.rectangle("fill", 25, windowHeight - 200, 250, 18) -- opaque black background
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill", 27, windowHeight - 198, 246 * (1 / player.healthLimit)* player.health,14) --white health bar
        love.graphics.setColor(1,1,1) --reset colour
        love.graphics.print(math.ceil(player.health), fonts.healthFont, 275, windowHeight - 200)
    end
end

return HUD