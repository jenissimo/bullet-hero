
SceneManager = {}
SceneManager.__index = SceneManager

local instance = nil

function SceneManager.new()
    if not instance then
        instance = setmetatable({}, SceneManager)
        instance.entities = {}
    end
    return instance
end

function SceneManager:spawnEntity(entity)
    table.insert(self.entities, entity)
end

function SceneManager:removeEntity(entity)
    for i = #self.entities, 1, -1 do
        if self.entities[i] == entity then
            print("Entity removed")
            table.remove(self.entities, i)
            break
        end
    end
end

-- Example methods for SceneManager
function SceneManager:update(dt)
    for i, entity in ipairs(self.entities) do
        entity:update(dt)
    end

    for i, entity in ipairs(self.entities) do
        entity:draw()
    end
end

function SceneManager:clear()
    for i, entity in ipairs(self.entities) do
        entity:destroy()
    end
    self.entities = {}
end