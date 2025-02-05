local waveManager
do
    waveManager = setmetatable({}, {
        __tostring = function()
            return "waveManager"
        end,
    })
    waveManager.__index = waveManager
    
    function waveManager.new(...)
        local self = setmetatable({}, waveManager)
        return self:constructor(...) or self
    end
    
    function waveManager:constructor()
        self.currentWave = 0
        self.baseEnemies = 3
        self.waveDelay = 3
        self.buyMenuToggle = false
    end

    function waveManager:spawnWave()
        local enemiesToSpawn = self.baseEnemies + (self.currentWave - 1) * 2 -- Increase number of enemies every wave
    
        for i = 1, enemiesToSpawn do
            local Xpos, Ypos = self:generateSpawnPosition() -- Generate spawn position for each enemy
            local enemyTest = enemyClass.new(50, Xpos, Ypos, 100) -- Create a new enemy instance
        end
    end
    

    function waveManager:generateSpawnPosition()
        local angle = math.pi * 2 * math.random() -- Random angle
        local distance = math.random(600, 700) -- Random distance from the player
        local Xpos = player.position.x + math.cos(angle) * distance -- Calculate X position
        local Ypos = player.position.y + math.sin(angle) * distance * 1.5 -- Calculate Y position
        return Xpos, Ypos
    end
    

    function waveManager:startWave()
        self.currentWave = self.currentWave + 1 -- Increment the wave counter
        self:spawnWave() -- Spawn the new wave of enemies
    end
    
    -- Global time variable for wave updates
    local t = 0
    

    function waveManager:update(deltaTime)
        if table.getn(enemies) == 0 and t >= self.waveDelay then
            if self.currentWave ~= 0 then -- Won't activate when the game starts
                self.buyMenuToggle = true -- Toggle the buy menu
            end
            self:startWave() -- Start a new wave
            t = 0 -- Reset the timer
        elseif table.getn(enemies) == 0 then
            t = t + deltaTime -- Increment the timer
        end
    end
end
return waveManager