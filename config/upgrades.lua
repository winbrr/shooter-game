local defaultIcon = love.graphics.newImage("assets/sprites/ui/icons/icon_temp.png")

upgradesEnum = {
    ["increaseHealth"] = 1, 
    [1] = "increaseHealth",
    ["regenerateHealth"] = 2, 
    [2] = "regenerateHealth",
    ["regenerateMediumAmmo"] = 3, 
    [3] = "regenerateMediumAmmo",
        ["addAmmo"] = 4, 
    [4] = "addAmmo",
        ["addHealth"] = 5, 
    [5] = "addHealth"
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
        cost = 31,
        regenRate = 0.5,
        icon = defaultIcon
    },
    [upgradesEnum.regenerateMediumAmmo] = {
        name = "Medium Regen",
        description = "Replenishes medium ammo over time",
        cost = 2000,
        regenRate = 0.5,
        icon = defaultIcon
    },
    [upgradesEnum.addAmmo] = {
        name = "Resupply",
        description = "Gives ammo for every weapon",
        cost = 500,
        value = 240,
        icon = defaultIcon
    },
    [upgradesEnum.addHealth] = {
        name = "Vital Surge",
        description = "Restores all health",
        cost = 500,
        icon = defaultIcon
    }
}