
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
    
    function Player:constructor(size, speed, Xpos, Ypos,health)
        self.size = size
        self.speed = speed
        self.Xpos, self.Ypos = Xpos, Ypos
        self.health = health
        self.ammoReserve = {
            light = 10,
            medium = 0,
            heavy = 0,
            shotgun = 0
        }
    end

    function Player:loadPlayer()
    
    end

    function Player:update(deltaTime)
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

        self.Xpos = self.Xpos + vector.x
        self.Ypos = self.Ypos + vector.y
    end

    function Player:draw()
        local halfSize = self.size / 2
        local rx, ry = camera:toScreen(self.Xpos, self.Ypos)
        love.graphics.rectangle("fill", rx - halfSize, ry - halfSize, self.size, self.size)
    end

    function Player:drawHealth()
        love.graphics.print("Health: ".. self.health,0,0)
    end
end

return Player