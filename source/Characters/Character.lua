import "Core/Entity"
import "Managers/SceneManager"
import "Effects/DamageText"

Character = setmetatable({}, { __index = Entity })
Character.__index = Character

local gfx<const> = playdate.graphics
local sceneManager = SceneManager.new()

function Character.new(spriteSheet, x, y, speed, animations)
    local self = setmetatable(Entity.new(x,y), Character)
    self.spriteSheet = spriteSheet
    self.x = x or 0
    self.y = y or 0
    self.speed = speed or 2
    self.animations = animations
    self.currentAnimation = animations["idle"]
    self.animationTimer = 0
    self.currentFrame = 1
    self.hitTimer = -1
    self.hitDuration = 0.15
    self.moving = false
    self.maxHp = 0
    self.hp = self.maxHp

    return self
end

function Character:update(dt)
    self.animationTimer = self.animationTimer + dt

    if self.hitTimer >= 0 then
        self.hitTimer = self.hitTimer + dt
        self.hit = true
    end

    if self.hitTimer >= self.hitDuration then
        self.hit = false
        self.hitTimer = -1
    end

    -- Check if it's time to update the frame
    if self.animationTimer >= self.currentAnimation.speed then
        self.currentFrame =
            (self.currentFrame % #self.currentAnimation.frames) + 1
        self.animationTimer = self.animationTimer - self.currentAnimation.speed
    end
end

function Character:changeAnimation(animationName)
    if self.currentAnimation == self.animations[animationName] then return end
    self.currentAnimation = self.animations[animationName]
    self.currentFrame = 1
    self.animationTimer = 0
end

function Character:move(dx, dy)
    if dx > 0 then
        self.fliped = false
    elseif dx < 0 then
        self.fliped = true
    end

    self.x = self.x + dx * self.speed
    self.y = self.y + dy * self.speed
end

function Character:draw()
    -- Drawing logic for the character
    if self.hit then
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    else
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
    if self.fliped then
        self.spriteSheet:drawImage(
            self.currentAnimation.frames[self.currentFrame], self.x, self.y,
            gfx.kImageFlippedX)
    else
        self.spriteSheet:drawImage(
            self.currentAnimation.frames[self.currentFrame], self.x, self.y,
            gfx.kImageUnflipped)
    end

    gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

-- Assuming you have a function to calculate the angle between two points
function Character:angleBetween(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.atan(dy / dx)
end

function Character:onHit(damage)
    local text = DamageText.new(self.x, self.y, tostring(damage), 1.5)
    self.hp = self.hp - damage
    sceneManager:spawnEntity(text)
    self.hitTimer = 0
    if self.hp <= 0 then
        self:die()
    end
end

function Character:die()
    
end