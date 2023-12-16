
SceneManager = {}
SceneManager.__index = SceneManager

local instance = nil

function SceneManager.new()
    if not instance then
        instance = setmetatable({}, SceneManager)
        instance.entities = {}
        -- Initialize the SceneManager instance here (e.g., loading scenes, setting up variables)
    end
    return instance
end

function SceneManager:spawnEntity(entity)
    table.insert(instance.entities, entity)
end

function SceneManager:removeEntity(entity)
    for i = #instance.entities, 1, -1 do
        if instance.entities[i] == entity then
            table.remove(instance.entities, i)
            break
        end
    end
end

-- Example methods for SceneManager
function SceneManager:update(dt)
    for i, entity in ipairs(instance.entities) do
        entity:update(dt)
    end

    for i, entity in ipairs(instance.entities) do
        entity:draw()
    end
end

function SceneManager:clear()
    for i, entity in ipairs(instance.entities) do
        entity:destroy()
    end
end