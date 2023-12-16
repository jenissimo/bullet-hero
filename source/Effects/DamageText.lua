import "Core/Entity"

DamageText = setmetatable({}, { __index = Entity })
DamageText.__index = DamageText

local gfx<const> = playdate.graphics

function DamageText.new(x, y, damage, duration)
    local self = setmetatable(Entity.new(x, y), DamageText)
    self.damage = damage
    self.duration = duration or 1.0
    self.elapsedTime = 0

    return self
end

function DamageText:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    self.y = self.y - dt * 30

    if self.elapsedTime >= self.duration then
        self:destroy()
        return
    end
end

function DamageText:draw()
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)  -- Set draw mode to white
    gfx.drawText(self.damage, self.x, self.y)
end