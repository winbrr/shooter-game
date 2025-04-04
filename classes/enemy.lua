local Enemy
do
    Enemy = setmetatable({}, {
        __tostring = function()
            return "Enemy"
        end,
    })
    Enemy.__index = Enemy

    enemies = {}
   
    function Enemy.new(...)
        local self = setmetatable({}, Enemy)
        return self:constructor(...) or self
    end
   
    function Enemy:constructor(size, Xpos, Ypos, maxHealth)
        self.velocity = Vector2.zero
        self.size = size
        self.position = Vector2.new(Xpos, Ypos)
        self.maxHealth = maxHealth
        self.health = maxHealth
        self.id = id()
        self.speed = 3
        self.lastShot = 0
        self.fireRate = 1
        self.dropChance = 0.4
        enemies[self.id] = self
    end

    local t = 0

    function Enemy.update(deltaTime)
        t = t + deltaTime -- Increment global time by deltaTime
        for i, obj in pairs(enemies) do
            obj:detectCollisions() -- Detect collisions with other objects
            obj:basicAttack() -- Perform basic attack
            obj:checkHealth(i) -- Check health and handle death
    
            local speed = obj.speed
    
            -- If the player is within a certain distance, move towards the player
            if player:distanceFrom(obj) < 500 then
                if player:distanceFrom(obj) < 450 then
                    obj.velocity = player.position:sub(obj.position):unit():mul(-obj.speed)
                    obj.position = obj.position:add(obj.velocity)
                end
                goto ignore -- Skip the rest of the loop for this enemy
            end
    
            -- Calculate velocity towards the player
            obj.velocity = player.position:sub(obj.position):unit():mul(speed)
    
            -- Calculate flocking behavior and adjust velocity
            local flocking = obj:calculateFlocking(obj.velocity)
            obj.velocity = obj.velocity:add(flocking):unit():mul(speed)
            obj.position = obj.position:add(obj.velocity)
    
            ::ignore::
        end
    end

    function Enemy:dropLoot() -- Drop loot on death
        local chance = math.random()
        local typeChance = math.random()
        local value = math.random(10, 30)
       
        if chance < self.dropChance then
            if typeChance < 0.75 then
                pickupClass.new(value, "ammo", self.position.x, self.position.y)
            else
                pickupClass.new(value, "health", self.position.x, self.position.y)
            end
        end
    end

    function Enemy:basicAttack() -- Shoot a projectile at the player
        if self.lastShot + self.fireRate < t then
            local direction, _ = player.position:add(player.moveDirection):getDirection(self.position) 
            projectileClass.new(self.position, direction, 300, false, 5, 10)
            self.lastShot = t -- Update the last shot time
        end
    end

    function Enemy:detectCollisions() -- Check if the enemy is hit by a projectile
        for i, obj in pairs(projectiles) do
            if obj.position:distance(self.position) < self.size and obj.isFriendly == true then
                self.health = self.health - obj.damage
                projectiles[i] = nil
                player.points = player.points + 10
            end
        end
    end

    function Enemy:checkHealth(index) -- Check if the enemy is dead + drop loot
        if self.health <= 0 then
            self:dropLoot()
            player.points = player.points + 50
            enemies[index] = nil
         end
    end

    function Enemy:getNeighbours()
        local neighbours = {}
        for id, neighbour in pairs(enemies) do
            if id ~= self.id then
                table.insert(neighbours, neighbour) -- Add nearby enemies to the neighbours table
            end
        end
        return neighbours
    end


function Enemy:calculateFlocking(velocity)
    local separationDistance = 120 -- Distance for separation behavior
    local cohesionWeight = 0.032 -- Weight for cohesion behavior
    local alignmentWeight = 0.161 -- Weight for alignment behavior
    local separationWeight = 0.46 -- Weight for separation behavior
    local neighbours = self:getNeighbours() -- Get nearby enemies

    if #neighbours == 0 then
        return Vector2.zero -- Return zero vector if no neighbours
    end

    local cohesion = Vector2.zero -- Cohesion vector
    local alignment = Vector2.zero -- Alignment vector
    local separation = Vector2.zero -- Separation vector

    local count = 0 -- Number of nearby enemies within separation distance

    for _, neighbour in ipairs(neighbours) do
        local distance = self.position:distance(neighbour.position)
        alignment = alignment:add(neighbour.velocity or Vector2.zero) -- Sum of velocities for alignment

        if distance < separationDistance then
            count = count + 1
            cohesion = cohesion:add(neighbour.position) -- Sum of positions for cohesion
            separation = separation:add(self.position:sub(neighbour.position)) -- Sum of separation vectors
        end
    end

    if count > 0 then
        cohesion = cohesion:div(count):sub(self.position):mul(cohesionWeight) -- Average cohesion vector
    end

    alignment = alignment:div(#neighbours):sub(velocity):mul(alignmentWeight) -- Average alignment vector
    separation = separation:mul(separationWeight) -- Weighted separation vector

    return cohesion:add(alignment):add(separation) -- Combined flocking vector
end

    function Enemy:healthBar()
        local position = camera:toScreen(self.position)
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", position.x - 20, position.y - 35, 40, 6) --red background
        love.graphics.setColor(0,1,0)
        love.graphics.rectangle("fill", position.x - 20, position.y - 35, 40 * (1 / self.maxHealth)* self.health,6) --green bar
        love.graphics.setColor(1,1,1) --reset colour
    end

    function Enemy.draw()
        if menu.state ~= "buy" then
            for _, obj in pairs(enemies) do
                obj:healthBar()
                local halfSize = obj.size / 2
                local position =  camera:toScreen(obj.position)
                love.graphics.rectangle("fill", position.x - halfSize, position.y - halfSize, obj.size, obj.size)
            end
        end
    end
end

return Enemy