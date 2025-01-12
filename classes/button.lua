local Button
do
    Button = setmetatable({}, {
        __tostring = function()
            return "Button"
        end,
    })
    Button.__index = Button

    buttons = {}
    
    function Button.new(...)
        local self = setmetatable({}, Button)
        return self:constructor(...) or self
    end
    
    function Button:constructor(text, x, y, width, height, font, callback)
        self.text = text
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.font = font
        self.callback = callback
        buttons[id()] = self
    end

    function Button.update()
        if love.mouse.isDown(1) then
            local mx, my = love.mouse.getPosition()
            for i, obj in pairs(buttons) do
                if Button:isHovering(obj, mx, my) then -- checks if mouse is over button
                    obj:callback() -- calls the buttons function
                end
            end
        end
    end

    function Button.draw()
        for i, obj in pairs(buttons) do
            love.graphics.setColor(0,0,0,0.3) -- grey transparent background
            love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height) -- button
            love.graphics.setColor(1,1,1,1) -- reset colour
            love.graphics.print(obj.text, obj.font, obj.x + 5 , obj.y + (obj.height / 8)) -- text
        end
    end

    function Button:isHovering(button, x, y)
        return x >= button.x and button.x <= (button.x + button.width) and y >= button.y and y <= (button.y + button.height) -- checks if there is positions overlap
    end
end

return Button