import "Managers/SceneManager"

CollisionManager = {}
CollisionManager.__index = CollisionManager

local instance = nil
local sceneManager = SceneManager.new()

function CollisionManager.new()
    if not instance then
        instance = setmetatable({}, CollisionManager)
        -- Initialize the SceneManager instance here (e.g., loading scenes, setting up variables)
    end
    return instance
end

function CollisionManager:getCollisionByTag(entity, targetTag)
    for i, entity2 in ipairs(sceneManager.entities) do
        if entity2:hasTag(targetTag) and self:checkCollision(entity, entity2) then
            return entity2
        end
    end
    return nil
end

function CollisionManager:checkCollision(entity1, entity2)
    if entity1 == entity2 then return false end
    if entity1.rect == nil or entity2.rect == nil then return false end

    -- check collision rect combined with x and y
    if entity1.x < entity2.x + entity2.rect.x2 and entity1.x + entity1.rect.x2 >
        entity2.x and entity1.y < entity2.y + entity2.rect.y2 and entity1.y +
        entity1.rect.y2 > entity2.y then return true end
    return false
end
