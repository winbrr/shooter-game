local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local Vector2
do
    Vector2 = setmetatable({}, {
        __tostring = function()
            return "Vector2"
        end,
    })
    Vector2.__index = Vector2
    
    function Vector2.new(...)
        local self = setmetatable({}, Vector2)

        return self:constructor(...) or self
    end
    
    function Vector2:constructor(x, y)
        if x == nil then
            x = 0
        end
        if y == nil then
            y = 0
        end

        self.x = x
        self.y = y
    end

    function Vector2:clone()
        return Vector2.new(self.x, self.y)
    end

    function Vector2:unit()
        local vector = self:clone()
        local magnitude = vector:magnitude()

        if magnitude == 1 then
            return vector
        elseif magnitude > 1e-05 then
            return vector:div(magnitude)
        else
            vector.x = 0
            vector.y = 0
        end

        return vector

    end

    function Vector2:div(n)
        if Vector2.is(n) then
            return Vector2.new(self.x / n.x, self.y / n.y)
        else
            return Vector2.new(self.x / n, self.y / n)
        end
    end

    function Vector2:mul(n)
        if Vector2.is(n) then
            return Vector2.new(self.x * n.x, self.y * n.y)
        else
            return Vector2.new(self.x * n, self.y * n)
        end
    end

    function Vector2:add(n)
        if Vector2.is(n) then
            return Vector2.new(self.x + n.x, self.y + n.y)
        else
            return Vector2.new(self.x + n, self.y + n)
        end
    end

    function Vector2:sub(n)
        if Vector2.is(n) then
            return Vector2.new(self.x - n.x, self.y - n.y)
        else
            return Vector2.new(self.x - n, self.y - n)
        end
    end

    function Vector2.magnitude(vector)
        return math.sqrt(vector.x * vector.x + vector.y * vector.y)
    end

    function Vector2.dot(lhs, rhs)
        return lhs.x * rhs.x + lhs.y * rhs.y
    end

    function Vector2.angle(from, to)
        -- return math.acos(clamp(from:unit():dot(to:unit()), -1, 1)) * 57.29578
        return math.atan2(to.y - from.y, to.x - from.x)
    end

    function Vector2.angleRad(from, to)
        return math.acos(clamp(from:unit():dot(to:unit()), -1, 1))
    end

    function Vector2.is(v)
        return type(v) == "table" or tostring(v) == "Vector2"
    end

    Vector2.up = Vector2.new(0, 1)
    Vector2.right = Vector2.new(1, 0)
    Vector2.zero = Vector2.new(0, 0)
    Vector2.one = Vector2.new(1, 1)
end

return Vector2