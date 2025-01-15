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
        self.buyFrame = love.graphics.newImage("assets/sprites/ui/frames/frame_buy_card.png")
        self.tempIcon = love.graphics.newImage("assets/sprites/ui/icons/icon_temp.png")
        self.buttonResume = buttonClass.new("Resume", 20, 20, 200, 50, fonts.menuFont, function() self:resume() end)
        self.quitButton01 = buttonClass.new("Quit", 20, 90, 200, 50, fonts.menuFont, function() love.event.quit() end)
        self.quitButton02 = buttonClass.new("Quit", 10, 140, 120, 50, fonts.menuFont, function() love.event.quit() end)

        self.buyButton = buttonClass.new("Buy", 668, 900, 120, 50, fonts.menuFont, function() 
            local data = upgrades[self.currentUpgrade]
            if player.points >= data.cost then
                player:upgrade(self.currentUpgrade)
                player.points = player.points - data.cost
                self:pickCard()
                self.active = false
                self.state = ""
                waveManager.buyMenuToggle = false
                self:resume()
            end
        end)
        
        self.skipButton = buttonClass.new("Skip", 1100, 900, 120, 50, fonts.menuFont, function() self:skipCard() end)
        self:pickCard()
    end

    function Menu:update()
        self:activatePause()
        self:activateGameOver()
        self:activateBuyMenu()
        self:updateBuyMenu()
    end

    function Menu:draw()
        self:drawGameOver()
        self:drawBuyMenu()
    end

    function Menu:activatePause()
        if self.active == true and self.state == "pause" then -- runs if the pause menu is active
            self.buttonResume.visible = true
            self.quitButton01.visible = true
        end
    end

    function Menu:activateGameOver()
        if player.health <= 0 then
            self.active = true
            self.state = "gameover"
            self.quitButton02.visible = true
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
        for i, obj in pairs(buttons) do -- hides buttons
            obj.visible = false
        end
    end

    function Menu:activateBuyMenu()
        if waveManager.buyMenuToggle == true then
            self.active = true
            self.state = "buy"
            self.buyButton.visible = true
            self.skipButton.visible = true
        end
    end

    function Menu:skipCard()
        self.buyMenuStrikes = self.buyMenuStrikes - 1
        self:pickCard()
    end

    function Menu:drawBuyMenu()
        if self.state == "buy" and self.active == true then
            local data = upgrades[self.currentUpgrade]
            love.graphics.draw(self.buyFrame, 448, 28)
        end
    end
    
    function Menu:updateBuyMenu()
        if self.buyMenuStrikes <= 0 then
            self.state = ""
            self.active = false
            waveManager.buyMenuToggle = false
            self.buyMenuStrikes = 3
            self:resume()
        end
    end

    function Menu:pickCard()
        self.currentUpgrade = math.random(1, #upgrades)
    end
end

return Menu