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
        self.t = love.timer.getTime() -- Timestamp for debounce
        self.visible = false -- Button visibility
        buttons[id()] = self -- Store the button instance in the buttons table
    end

    -- Update function to handle button interactions
    function Button.update()
        local t = love.timer.getTime()
        local mx, my = love.mouse.getPosition()
        for i, obj in pairs(buttons) do
            -- Check if the button is visible, mouse is clicked, debounce time has passed, and mouse is hovering over the button
            if obj.visible and love.mouse.isDown(1) and (t - obj.t) > .1 and obj:isHovering(mx, my) then
                obj.t = t -- Update the timestamp
                obj:callback() -- Call the button's callback function
            end
        end
    end

    -- Draw function to render the buttons
    function Button.draw()
        for i, obj in pairs(buttons) do
            if obj.visible then
                love.graphics.setColor(0,0,0,0.3) -- Set color for opaque black background
                love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height) -- Draw the button rectangle
                love.graphics.setColor(1,1,1,1) -- Reset color to white
                love.graphics.print(obj.text, obj.font, obj.x + 5 , obj.y + (obj.height / 8)) -- Draw the button text
            end
        end
    end

    -- Function to check if the mouse is hovering over the button
    function Button:isHovering(x, y)
        return x >= self.x and x <= (self.x + self.width) and y >= self.y and y <= (self.y + self.height) -- Check if mouse position overlaps with button
    end
end

return Button