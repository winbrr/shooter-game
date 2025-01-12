local Menu
do
    Menu = setmetatable({}, {
        __tostring = function()
            return "Menu"
        end,
    })
    Menu.__index = Menu
    
    function Menu.new(...)
        local self = setmetatable({}, Menu)
        return self:constructor(...) or self
    end
    
    function Menu:constructor()
        self.active = false
        self.state = ""
    end

    function Menu:load()
        self.active = false
        self.state = "" -- dont remove
    end

    function Menu:update()
        Menu:activatePause()
        Menu:activateGameOver()
    end

    function Menu:draw()
        Menu:drawGameOver()
    end

    function Menu:activatePause()
        if self.active == true and self.state == "pause" then -- runs if the pause menu is active
            if table.getn(buttons) == 0 then -- checks of there are no buttons on screen currently
                buttonClass.new("Resume", 20, 20, 200, 50, fonts.menuFont, function() Menu:resume() end)
                buttonClass.new("Quit", 20, 90, 200, 50, fonts.menuFont, function() love.event.quit() end)
            end
        end
    end

    function Menu:activateGameOver()
        if player.health <= 0 then
            self.active = true
            self.state = "gameover"
            buttonClass.new("Quit", 10, 140, 120, 50, fonts.menuFont, function() love.event.quit() end)
        end
            
    end

    function Menu:drawGameOver()
        if self.state == "gameover" and self.active == true then
            love.graphics.print("Game Over!", fonts.menuFontLarge, 10, 10)
            love.graphics.print("You survived " .. waveManager.currentWave .. " rounds", fonts.menuFont, 10, 90)
        end
    end
    
    function Menu:resume()
        self.active = false
        self.state = ""
        for i, obj in pairs(buttons) do -- removes pause buttons
            buttons[i] = nil
        end
    end
end

return Menu