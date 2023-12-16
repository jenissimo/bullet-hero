import "Weapons/Weapon"
import "Managers/SceneManager"

MeleeWeapon = {}
MeleeWeapon.__index = MeleeWeapon

local sceneManager = SceneManager.new()

function MeleeWeapon.new(spriteSheet, targetTag, cooldown, damage, player)
    local self = setmetatable(
        Weapon.new(spriteSheet, targetTag, cooldown, damage), MeleeWeapon)
    self.spriteSheet = spriteSheet
    self.cooldown = cooldown
    self.damage = damage
    self.lastShootTime = 0
    self.player = player

    return self
end

function MeleeWeapon:attack(startX, startY, dx, dy)
    if self.lastShootTime < self.cooldown then
        return
    end

    self.player:onHit(self.damage)

    self.lastShootTime = 0
end

function MeleeWeapon:update(dt)
    self.lastShootTime = self.lastShootTime + dt
end