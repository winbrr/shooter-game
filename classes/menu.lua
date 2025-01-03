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
    end

    function Menu:update()

    end

    function Menu:draw()
        if self.active == true and self.state == "pause" then
            self:drawPause()
        end
    end

    function Menu:drawPause()
        love.graphics.print("Resume game", fonts.pauseFont, 10, 10)
        love.graphics.print("Quit", fonts.pauseFont, 10, 60)
    end
end

return Menu