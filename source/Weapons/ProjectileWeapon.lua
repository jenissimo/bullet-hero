import "Weapons/Weapon"
import "Managers/SceneManager"
import "Weapons/Projectile"
import "CoreLibs/math"

ProjectileWeapon = {}
ProjectileWeapon.__index = ProjectileWeapon

local sceneManager = SceneManager.new()

function ProjectileWeapon.new(spriteSheet, targetTag, cooldown, damage, config)
    local self = setmetatable(Weapon.new(spriteSheet, targetTag, cooldown,
                                         damage), ProjectileWeapon)
    self.spriteSheet = spriteSheet
    self.cooldown = cooldown
    self.damage = damage
    self.lastShootTime = 0
    self.projectileSpeed = config.projectileSpeed
    self.projectileLifetime = config.projectileLifetime
    self.projectileCount = config.projectileCount
    self.projectileSpreadAngle = config.projectileSpreadAngle
    self.projectileRandomSpread = config.projectileRandomSpread

    return self
end

function ProjectileWeapon:attack(startX, startY, dx, dy)
    if self.lastShootTime < self.cooldown then return end

    self.lastShootTime = 0
    local baseAngle = math.atan2(dy, dx)

    for i = 1, self.projectileCount do
        local baseDirection = {x = dx, y = dy}
        local newDirection = self:calculateDirection(baseDirection, i)

        local projectile = Projectile.new(self.spriteSheet, self.targetTag,
                                          startX, startY,
                                          newDirection.x, newDirection.y,
                                          self.projectileSpeed,
                                          self.damage,
                                          self.projectileLifetime)
        projectile.damage = self.damage
        projectile.angle = angle
        sceneManager:spawnEntity(projectile)
    end
end

function ProjectileWeapon:calculateDirection(baseDirection, index)
    local vector = {x = baseDirection.x, y = baseDirection.y}

    if self.projectileCount > 1 then
        local spread = math.rad(self.projectileSpreadAngle)
        local minAngle = -spread / 2
        local maxAngle = spread / 2
        local angle = playdate.math.lerp(minAngle, maxAngle,
                                         index / (self.projectileCount - 1))

        vector.x = baseDirection.x * math.cos(angle) - baseDirection.y *
                       math.sin(angle)
        vector.y = baseDirection.x * math.sin(angle) + baseDirection.y *
                       math.cos(angle)
    elseif self.projectileRandomSpread > 0 then
        local randomSpread = math.rad(self.projectileRandomSpread *
                                          self.projectileSpreadAngle *
                                          math.random() -
                                          self.projectileSpreadAngle / 2)

        vector.x = baseDirection.x * math.cos(randomSpread) - baseDirection.y *
                       math.sin(randomSpread)
        vector.y = baseDirection.x * math.sin(randomSpread) + baseDirection.y *
                       math.cos(randomSpread)
    end

    print(vector.x, vector.y)

    return vector
end

function ProjectileWeapon:update(dt) self.lastShootTime =
    self.lastShootTime + dt end

function ProjectileWeapon:draw() end
