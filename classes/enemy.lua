local Enemy
do
    Enemy = setmetatable({}, {
        __tostring = function()
            return "Enemy"
        end,
    })
    Enemy.__index = Enemy

    local enemies = {}
    
    function Enemy.new(...)
        local self = setmetatable({}, Enemy)
        return self:constructor(...) or self
    end
    
    function Enemy:constructor(velocity, size, Xpos, Ypos)
        self.velocity = velocity
        self.size = size
        self.Xpos = Xpos
        self.Ypos = Ypos
        self.position = Vector2.new(self.Xpos, self.Ypos)
        enemies[id()] = self
    end
    
    function Enemy.update(deltaTime)
        for _, obj in pairs(enemies) do
            local speed = 0.2 * deltaTime
            local plrPos = Vector2.new(player.Xpos,player.Ypos)
            obj.position = Vector2.new(obj.Xpos, obj.Ypos)
            
            obj.velocity = (plrPos:sub(obj.position)):unit():mul(speed)

            local flocking = obj:calculateFlocking(obj.velocity)
            obj.velocity = (obj.velocity:add(flocking)):unit():mul(speed)

            obj.position = obj.position:add(obj.velocity)
            obj.Xpos = obj.position.x
            obj.Ypos= obj.position.y
        end
    end

    function Enemy:calculateFlocking(velocity)
        local separationDistance = 48
        local cohesionWeight = 0.032
        local alignmentWeight = 0.161
        local separationWeight = 0.46

        local neighbours = enemies
        if #neighbours == 0 then
            return Vector2.new()
        end

        local cohesion = Vector2.new()
        local alignment = Vector2.new()
        local separation = Vector2.new()

        local count = 0

        for _, neighbour in ipairs(neighbours) do
            self.position = Vector2.new(self.Xpos, self.Ypos)
            local distance = self.position:sub():magnitude()

            alignment = alignment + (neighbour.velocity or Vector2.new())

            if distance < separationDistance then
                count = count + 1
                cohesion = cohesion + neighbour.position
                separation = separation + (self.position - neighbour.position)
            end
        end

        if count > 0 then
            cohesion = ((cohesion / count) - self.position) * cohesionWeight
        end

        alignment = ((alignment / #neighbours) - velocity) * alignmentWeight
        separation = separation * separationWeight

        return cohesion + alignment + separation
    end  
    function Enemy.draw()
        for _, obj in pairs(enemies) do
            local halfSize = obj.size / 2
            local rx, ry =  camera:toScreen(obj.position.x, obj.position.y)
            love.graphics.rectangle("fill", rx - halfSize, ry - halfSize, obj.size, obj.size)
        end
    end 
end

return Enemy