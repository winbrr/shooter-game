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
        self.t = love.timer.getTime()
        self.visible = false
        buttons[id()] = self
    end

    function Button.update()
        local t = love.timer.getTime()
        local mx, my = love.mouse.getPosition()
        for i, obj in pairs(buttons) do
            if obj.visible and love.mouse.isDown(1) and (t - obj.t) > .1 and obj:isHovering(mx, my) then -- debounce, checks if mouse over button
                obj.t = t
                obj:callback() -- calls the button's function
            end
        end
    end

    function Button.draw()
        for i, obj in pairs(buttons) do
            if obj.visible then
                love.graphics.setColor(0,0,0,0.3) -- opaque black background
                love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height) -- button
                love.graphics.setColor(1,1,1,1) -- reset colour
                love.graphics.print(obj.text, obj.font, obj.x + 5 , obj.y + (obj.height / 8)) -- text
            end
        end
    end

    function Button:isHovering(x, y)
        return x >= self.x and x <= (self.x + self.width) and y >= self.y and y <= (self.y + self.height) -- checks if there is positions overlap
    end
end

return Button