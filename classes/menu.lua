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
        self.active = false -- dont remove
    end

    function Menu:update()
        Menu:activatePause()
    end

    function Menu:draw()

    end

    function Menu:activatePause()
        if self.active == true and self.state == "pause" then -- runs if the pause menu is active
            if table.getn(buttons) == 0 then -- checks of there are no buttons on screen currently
                buttonClass.new("Resume", 20, 20, 200, 50, fonts.pauseFont, function() Menu:resume() end)
                buttonClass.new("Quit", 20, 90, 200, 50, fonts.pauseFont, function() love.event.quit() end)
            end
        end
    end

    function Menu:drawPause()
        
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