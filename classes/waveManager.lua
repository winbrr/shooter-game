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
    end

    function waveManager:spawnWave()
        local enemiesToSpawn = self.baseEnemies + (self.currentWave - 1) * 2 --increase number of enemies every wave

        for i = 1, enemiesToSpawn do
            local enemyTest = enemyClass.new(50, 200, 200, 100)
        end
    end

    function waveManager:startWave()
        self.currentWave = self.currentWave + 1
        self:spawnWave()
    end

    local t = 0

    function waveManager:update(deltaTime)
        if table.getn(enemies) == 0 and t >= self.waveDelay then
            self:startWave()
            t = 0
        elseif table.getn(enemies) == 0 then
        t = t + deltaTime
        end
    end
end
return waveManager