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
        self.active = false -- Menu is initially inactive
        self.state = "" -- Initial state of the menu
        self.buyMenuStrikes = 3 -- Number of strikes allowed in the buy menu
        self.buyFrame = love.graphics.newImage("assets/sprites/ui/frames/frame_buy_card.png") -- Image for the buy frame
    
        -- Create buttons for the menu
        self.buttonResume = buttonClass.new("Resume", 20, 20, 200, 50, fonts.menuFont, function() self:resume() end)
        self.quitButton01 = buttonClass.new("Quit", 20, 90, 200, 50, fonts.menuFont, function() love.event.quit() end)
        self.quitButton02 = buttonClass.new("Quit", 10, 140, 120, 50, fonts.menuFont, function() love.event.quit() end)
    
        -- Create buy button with functionality to purchase upgrades
        self.buyButton = buttonClass.new("Buy", (windowWidth / 2) - 256, 900, 120, 50, fonts.menuFont, function() 
            local data = upgrades[self.currentUpgrade]
            if player.points >= data.cost then
                player:upgrade(self.currentUpgrade) -- Upgrade the player
                player.points = player.points - data.cost -- Deduct points
                self:pickCard() -- Pick a new card
                self.active = false -- Deactivate menu
                self.state = "" -- Reset state
                waveManager.buyMenuToggle = false -- Toggle buy menu off
                self.buyMenuStrikes = 3 -- Reset strikes
                self:resume() -- Resume the game
            end
        end)
        -- Create skip button with functionality to skip the current card
        self.skipButton = buttonClass.new("Skip", (windowWidth / 2) + 136, 900, 120, 50, fonts.menuFont, function() self:skipCard() end)
        self:pickCard() -- Pick the initial card
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

    function Menu:activateGameOver() -- runs if the player's health is 0
        if player.health <= 0 then
            self.active = true -- activates the game over menu
            self.state = "gameover"
            self.quitButton02.visible = true -- shows the quit button
        end  
    end

    function Menu:drawGameOver() -- draws the game over menu
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

    function Menu:activateBuyMenu() -- activates the buy menu
        if waveManager.buyMenuToggle == true then
            self.active = true
            self.state = "buy"
            self.buyButton.visible = true
            self.skipButton.visible = true -- shows the buy and skip buttons
        end
    end

    function Menu:skipCard()
        self.buyMenuStrikes = self.buyMenuStrikes - 1
        self:pickCard()
    end

    function Menu:drawBuyMenu()
        if self.state == "buy" and self.active == true then
            local data = upgrades[self.currentUpgrade]
            love.graphics.draw(self.buyFrame, (windowWidth / 2) - 512, 28)
            love.graphics.print(data.name, fonts.menuFontMed, (windowWidth / 2) - 256, 160)
            love.graphics.print("Cards remaining: "..self.buyMenuStrikes, fonts.menuFont, 10, 10)
            love.graphics.printf(data.description, fonts.menuFont, (windowWidth / 2) - 256, 240, 550)
            love.graphics.printf("Price: $" .. data.cost, fonts.menuFont, (windowWidth / 2) - 256, 350, 550)
            love.graphics.draw(data.icon, (windowWidth / 2) - 256, 410)
        end
    end
    
    function Menu:updateBuyMenu()
        if self.buyMenuStrikes <= 0 then -- runs if the player has no strikes left
            self.state = ""
            self.active = false
            waveManager.buyMenuToggle = false
            self.buyMenuStrikes = 3
            self:resume()
        end
    end

    function Menu:pickCard()
        self.currentUpgrade = math.random(1, #upgrades) -- picks a random card
    end
end

return Menu