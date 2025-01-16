local defaultIcon = love.graphics.newImage("assets/sprites/ui/icons/icon_temp.png")

upgradesEnum = {
    ["increaseHealth"] = 1, 
    [1] = "increaseHealth",
    ["regenerateHealth"] = 2, 
    [2] = "regenerateHealth"
}

upgrades = {
    [upgradesEnum.increaseHealth] = {
        name = "Juggernaut",
        description = "Increases maximum health",
        cost = 2500,
        default = 100,
        icon = defaultIcon
    },
    [upgradesEnum.regenerateHealth] = {
        name = "Healing Aura",
        description = "Provides passive health regeneration",
        cost = 3000,
        regenRate = 0.5,
        icon = defaultIcon
    }
}