Entity = {}
Entity.__index = Entity

-- Constructor for the Entity class with position parameters
function Entity.new(x, y)
    local self = setmetatable({}, Entity)
    self.x = x or 0  -- Default to 0 if not provided
    self.y = y or 0  -- Default to 0 if not provided
    self.tags = {}   -- Table to hold tags
    return self
end

-- Function to add a tag to the entity
function Entity:addTag(tag)
    self.tags[tag] = true
end

-- Function to remove a tag from the entity
function Entity:removeTag(tag)
    self.tags[tag] = nil
end

-- Function to check if the entity has a specific tag
function Entity:hasTag(tag)
    return self.tags[tag] == true
end

-- Function to set the entity's position
function Entity:setPosition(x, y)
    self.x = x
    self.y = y
end

-- Function to move the entity by a certain amount
function Entity:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Entity:destroy()
    self.tags = nil
    SceneManager:removeEntity(self)
end