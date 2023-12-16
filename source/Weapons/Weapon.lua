Weapon = {}
Weapon.__index = Weapon

local gfx<const> = playdate.graphics

function Weapon.new(spriteSheet, targetTag, cooldown, damage)
    local self = setmetatable({}, Weapon)
    self.spriteSheet = spriteSheet
    self.targetTag = targetTag
    self.cooldown = cooldown
    self.damage = damage
    self.lastShootTime = 0

    return self
end

function Weapon:attack(startX, startY, dx, dy)
    
end

function Weapon:update(dt)
    self.lastShootTime = self.lastShootTime + dt
end

function Weapon:draw()
    
end