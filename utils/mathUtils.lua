local function lerp(from, to, alpha)
    return from + alpha * (to - from)
end

local function lerpF(from, to, speed, deltaTime)
    return lerp(from, to, 1 - math.exp(-speed * deltaTime))
end

return {lerpF = lerpF, lerp = lerp}