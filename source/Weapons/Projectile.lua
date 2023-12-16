import "Managers/CollisionManager"
Projectile = {}

Projectile = setmetatable({}, { __index = Entity })
Projectile.__index = Projectile

local collisionManager = CollisionManager.new()

function Projectile.new(spriteSheet, targetTag, x, y, dx, dy, speed, damage, lifetime)
    local self = setmetatable(Entity.new(x,y), Projectile)
    self.spriteSheet = spriteSheet
    self.targetTag = targetTag
    self.x = x
    self.y = y
    self.dx = dx
    self.dy = dy
    self.speed = speed
    self.damage = damage
    self.lifetime = lifetime
    self.rect={x1 = 0, y1 = 0, x2 = 2, y2 = 2}
    return self
end

function Projectile:update(dt)
    self.x = self.x + self.dx * dt * self.speed
    self.y = self.y + self.dy * dt * self.speed
    self.lifetime = self.lifetime - dt

    if self.lifetime <= 0 then
        self:destroy()
        return
    end

    local hit = collisionManager:getCollisionByTag(self, self.targetTag)
    if hit then
        if hit.onHit then
            hit:onHit(self.damage)
        end
        self:destroy()
    end
end

function Projectile:draw()
    playdate.graphics.setColor(playdate.graphics.kColorWhite)
    playdate.graphics.fillCircleAtPoint(self.x, self.y, 2)
    --self.spriteSheet:drawImage(0, self.x, self.y)
end