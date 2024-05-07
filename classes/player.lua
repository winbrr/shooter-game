local Vector2 = require("classes/vector2")


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
    
    function Player:constructor(size, speed, Xpos, Ypos)
        self.size = size
        self.speed = speed
        self.Xpos, self.Ypos = Xpos, Ypos
    end

    function Player:loadPlayer()
    
    end

    function Player:updatePlayer(dt)
        local x, y = 0, 0
        
        if love.keyboard.isDown("d") then
            x = 1
        elseif love.keyboard.isDown("a") then
            x = -1 
        end

        if love.keyboard.isDown("w") then
            y = -1
        elseif love.keyboard.isDown("s") then
            y = 1
        end

        
        local vector = Vector2.new(x,y)

        vector = vector:unit() * self.speed * dt

        self.Xpos = self.Xpos + vector.x
        self.Ypos = self.Ypos + vector.y
    end

    function Player:drawPlayer()
        local halfSize = self.size / 2
        love.graphics.rectangle("fill", self.Xpos - halfSize, self.Ypos - halfSize, self.size, self.size)
    end
end

return Player