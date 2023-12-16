import "Characters/Player"
import "Weapons/MeleeWeapon"
import "Managers/GameManager"

Enemy = setmetatable({}, {__index = Character})
Enemy.__index = Enemy

local gameManager = GameManager.new()

function Enemy.new(spriteSheet, x, y, speed, animations, player)
    local self = setmetatable(
                     Character.new(spriteSheet, x, y, speed, animations), Enemy)
    -- Add more enemy-specific properties if needed
    self.player = player
    self.rect = {x1=3, y1=4, x2=13, y2=15}
    self.weapon = MeleeWeapon.new(spriteSheet, "enemy", 0.5, 10, player)
    self.attackDistance = 24
    self.maxHp = 20
    self.hp = self.maxHp
    return self
end

function Enemy:update(dt)
    self.weapon:update(dt)
    self:aiBehavior()

    if self.hp <= 0 then
        self:changeAnimation("death")
    elseif not self.moving then
        self:changeAnimation("idle")
    else
        self:changeAnimation("run")
    end

    Character.update(self, dt)
end

function Enemy:aiBehavior()
    -- Define AI behavior for the enemy
    if self.player and self.hp > 0 then
        local dx = self.player.x - self.x
        local dy = self.player.y - self.y
        local len = math.sqrt(dx * dx + dy * dy)

        self.moving = false

        -- Normalize diagonal movement
        if dx ~= 0 and dy ~= 0 then
            dx, dy = dx / len, dy / len

            if len > self.attackDistance then
                self.moving = true
                self:move(dx, dy)
            end
        end

        if len <= self.attackDistance*1.05 then
            self:attack()
        end
    end
end

function Enemy:attack()
    self.weapon:attack(self.x, self.y, self.player.x - self.x, self.player.y - self.y)
end

function Enemy:die()
    self:removeTag("enemy")
    gameManager:addFrag()
end