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
            vector:div(magnitude)
        else
            vector.x = 0
            vector.y = 0
        end

        return vector
    end

    function Vector2:div(n)
        if Vector2.is(n) then
            self.x = self.x / n.x
            self.y = self.y / n.y
        else
            self.x = self.x / n
            self.y = self.y / n
        end
        
        return self
    end

    function Vector2:mul(n)
        if Vector2.is(n) then
            self.x = self.x * n.x
            self.y = self.y * n.y
        else
            self.x = self.x * n
            self.y = self.y * n
        end

        return self
    end

    function Vector2:add(n)
        if Vector2.is(n) then
            self.x = self.x + n.x
            self.y = self.y + n.y
        else
            self.x = self.x + n
            self.y = self.y + n
        end

        return self
    end

    function Vector2:sub(n)
        if Vector2.is(n) then
            self.x = self.x - n.x
            self.y = self.y - n.y
        else
            self.x = self.x - n
            self.y = self.y - n
        end
        
        return self
    end

    function Vector2.magnitude(vector)
        return math.sqrt(vector.x * vector.x + vector.y * vector.y)
    end

    function Vector2.dot(lhs, rhs)
        return lhs.x * rhs.x + lhs.y * rhs.y
    end

    function Vector2.angle(from, to)
        return math.acos(clamp(Vector2.dot(from:unit(), to:unit()), -1, 1))    * 57.29578
    end

    function Vector2.is(v)
        return type(v) == "table" and tostring(v) == "Vector2"
    end

    Vector2.up = Vector2.new(0, 1)
    Vector2.right = Vector2.new(1, 0)
    Vector2.zero = Vector2.new(0, 0)
    Vector2.one = Vector2.new(1, 1)

    function Vector2.__div(a, b)
        return a:clone():div(b)
    end
    function Vector2.__mul(a, b)
        return a:clone():mul(b)
    end
    function Vector2.__add(a, b)
        return a:clone():add(b)
    end
    function Vector2.__sub(a, b)
        return a:clone():sub(b)
    end
    function Vector2.__unm(v)
        return Vector2.new(-v.x, -v.y)
    end
    function Vector2.__eq(a, b)
        return a.x == b.x and a.y == b.y
    end
end

return Vector2