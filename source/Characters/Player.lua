import "Characters/Character"
import "Weapons/ProjectileWeapon"
import "CoreLibs/crank"

local gfx<const> = playdate.graphics

Player = setmetatable({}, {__index = Character})
Player.__index = Player

function Player.new(spriteSheet, x, y, speed, animations)
    local self = setmetatable(
                     Character.new(spriteSheet, x, y, speed, animations), Player)
    -- Add more player-specific properties if needed
    self.pistolAngle = 0 -- Initial angle for the pistol
    self.pistolImage = spriteSheet:getImage(97)
    self.rect = {x1=2, y1=5, x2=14, y2=16}
    local weaponConfig = {
        projectileSpeed = 300,
        projectileLifetime = 1,
        projectileCount = 5,
        projectileSpreadAngle = 30,
        projectileRandomSpread = 0
    }
    self.weapon = ProjectileWeapon.new(spriteSheet, "enemy", 0.5, 10, weaponConfig)
    self.maxHp = 50
    self.hp = self.maxHp
    return self
end

function Player:update(dt)
    self:handleInput()

    if not self.moving then
        self:changeAnimation("idle")
    else
        self:changeAnimation("run")
    end

    -- Auto attack
    self:attack()
    self.weapon:update(dt)

    Character.update(self, dt)
end

function Player:handleInput()
    local dx, dy = 0, 0
    self.moving = false

    self.pistolAngle = playdate.getCrankPosition() - 90
    --print(self.pistolAngle)

    if playdate.buttonIsPressed(playdate.kButtonUp) then
        dy = -1
        self.moving = true
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        dy = 1
        self.moving = true
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        dx = -1
        self.fliped = true
        self.moving = true
    end
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        dx = 1
        self.fliped = false
        self.moving = true
    end

    -- Normalize diagonal movement
    if dx ~= 0 and dy ~= 0 then
        local len = math.sqrt(dx * dx + dy * dy)
        dx, dy = dx / len, dy / len
    end

    self:move(dx, dy)
end

function Player:attack()
    -- Calculate the direction of the attack
    local rad = math.rad(self.pistolAngle)
    local dx = math.cos(rad)
    local dy = math.sin(rad)

    -- Trigger the attack
    self.weapon:attack(self.x, self.y, dx, dy)
end

function Player:draw()
    Character.draw(self)
    self:drawPistol()
end

function Player:drawPistol()
    local rad = math.rad(self.pistolAngle)
    local pistolX = self.x + 8 + math.cos(rad) * 15
    local pistolY = self.y + 10 + math.sin(rad) * 15

    self.pistolImage:drawRotated(pistolX, pistolY, self.pistolAngle)
end
