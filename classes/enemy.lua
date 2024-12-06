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
   
    function Enemy:constructor(size, Xpos, Ypos, health)
        self.velocity = Vector2.zero
        self.size = size
        self.position = Vector2.new(Xpos, Ypos)
        self.health = health
        self.id = id()
        self.speed = 3
        enemies[self.id] = self
    end

    function Enemy.update()
        for i, obj in pairs(enemies) do
            obj:detectCollisions()
            obj:checkHealth(obj, i)
            
            local speed = obj.speed
            
            if player:distanceFrom(obj) < 300 then
                if player:distanceFrom(obj) < 250 then
                    obj.velocity = player.position:sub(obj.position):unit():mul(-obj.speed)
                    obj.position = obj.position:add(obj.velocity)
                end
    
                goto ignore
            end
    
            obj.velocity = player.position:sub(obj.position):unit():mul(speed)
            
            local flocking = obj:calculateFlocking(obj.velocity)
            obj.velocity = obj.velocity:add(flocking):unit():mul(speed)
            obj.position = obj.position:add(obj.velocity)
    
            ::ignore::
        end
    end

    function Enemy:detectCollisions()
        for i, obj in pairs(projectiles) do
            if obj.position:distance(self.position) < self.size and obj.isFriendly == true then
                self.health = self.health - obj.damage
                projectiles[i] = nil
            end
        end
    end

    function Enemy:checkHealth(enemy, index)
        if enemy.health <= 0 then
            enemies[index] = nil
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
            local distance = self.position:distance(neighbour.position)
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
            local position =  camera:toScreen(obj.position)
            love.graphics.rectangle("fill", position.x - halfSize, position.y - halfSize, obj.size, obj.size)
        end
    end
end

return Enemy