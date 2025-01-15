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
        self.buyMenuStrikes = 3
    end

    function Menu:load()
        self.active = false
        self.state = "" -- dont remove
        self.buyMenuStrikes = 3
        self.buyFrame = love.graphics.newImage("assets/sprites/hud/frame_buy_card.png")
    end

    function Menu:update()
        Menu:activatePause()
        Menu:activateGameOver()
        Menu:activateBuyMenu()
        Menu:updateBuyMenu()
    end

    function Menu:draw()
        Menu:drawGameOver()
        Menu:drawBuyMenu()
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

    function Menu:activateBuyMenu()
        if waveManager.buyMenuToggle == true then
            self.active = true
            self.state = "buy"
            buttonClass.new("Buy", 668, 900, 120, 50, fonts.menuFont, function() love.event.quit() end)
            buttonClass.new("Skip", 1100, 900, 120, 50, fonts.menuFont, function() Menu:skipCard() end)
        end
    end

    function Menu:skipCard()
        self.buyMenuStrikes = self.buyMenuStrikes - 1
    end

    function Menu:drawBuyMenu()
        if self.state == "buy" and self.active == true then
            love.graphics.draw(self.buyFrame, 448, 28)
        end
    end
    
    function Menu:updateBuyMenu()
        if self.buyMenuStrikes <= 0 then
            self.state = ""
            self.active = false
            Menu:resume()
        end
    end
end

return Menu