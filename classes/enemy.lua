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
   
    function Enemy:constructor(size, Xpos, Ypos)
        self.velocity = Vector2.zero
        self.size = size
        self.position = Vector2.new(Xpos, Ypos)
        self.id = id()
        enemies[self.id] = self
    end
   
    function Enemy.update(deltaTime)
        for _, obj in pairs(enemies) do
            local speed = 3
            local plrPos = Vector2.new(player.Xpos, player.Ypos)
           
            obj.velocity = plrPos:sub(obj.position):unit():mul(speed)

            local flocking = obj:calculateFlocking(obj.velocity)
            if obj:getPlayerDistance() > 350 then
                obj.velocity = obj.velocity:add(flocking):unit():mul(speed)
                obj.position = obj.position:add(obj.velocity)
            
            elseif obj:getPlayerDistance() < 300 then
                obj.velocity = obj.velocity:sub(flocking):unit():mul(speed)
                obj.position = obj.position:sub(obj.velocity)
            end
        end
    end

    function Enemy:getNeighbours()
        local neighbours = {}
        for id, neighbour in pairs(enemies) do
            if id ~= self.id then
                table.insert(neighbours, neighbour)
            end
        end
        return neighbours
    end

    function Enemy:getPlayerDistance()
        local plrPos = Vector2.new(player.Xpos,player.Ypos)
        local pickupPos = Vector2.new(self.position.x, self.position.y)
        return plrPos:sub(pickupPos):magnitude()
    end

    function Enemy:calculateFlocking(velocity)
        local separationDistance = 75
        local cohesionWeight = 0.032
        local alignmentWeight = 0.161
        local separationWeight = 0.46
        local neighbours = self:getNeighbours()

        if #neighbours == 0 then
            return Vector2.zero
        end

        local cohesion = Vector2.zero
        local alignment = Vector2.zero
        local separation = Vector2.zero

        local count = 0

        for _, neighbour in ipairs(neighbours) do
            local distance = self.position:sub(neighbour.position):magnitude()
            alignment = alignment:add(neighbour.velocity or Vector2.zero)

            if distance < separationDistance then
                count = count + 1
                cohesion = cohesion:add(neighbour.position)
                separation = separation:add(self.position:sub(neighbour.position))
            end
        end

        if count > 0 then
            cohesion = cohesion:div(count):sub(self.position):mul(cohesionWeight)
        end

        alignment = alignment:div(#neighbours):sub(velocity):mul(alignmentWeight)
        separation = separation:mul(separationWeight)

        return cohesion:add(alignment):add(separation)
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