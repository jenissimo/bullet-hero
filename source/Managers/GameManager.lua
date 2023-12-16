import "Managers/SceneManager"

GameManager = {}
GameManager.__index = GameManager

local gfx<const> = playdate.graphics

local instance = nil
local sceneManager = SceneManager.new()

local startEnemies = 3
local maxEnemies = 10
local enemiesCount = startEnemies

function GameManager.new()
    if not instance then
        instance = setmetatable({}, GameManager)
        -- Initialize the SceneManager instance here (e.g., loading scenes, setting up variables)
        instance.spriteSheet = gfx.imagetable.new("images/spritesheet")
        -- instance:init()
    end
    return instance
end

function GameManager:init()
    enemiesCount = startEnemies
    self.frags = 0
    sceneManager:clear()
    self.player = Player.new(self.spriteSheet, 100, 100, 2, {
        idle = {frames = {2, 1}, speed = 0.4},
        run = {frames = {2, 3, 4, 5}, speed = 0.1},
        death = {frames = {5}, speed = 0.25}
    })
    sceneManager:spawnEntity(self.player)
    self.player:addTag("player")

    for i = 1, enemiesCount do
        self:spawnEnemy()
    end
end

function GameManager:spawnEnemy()
    local screenWidth, screenHeight = playdate.display.getSize()
    local enemy = Enemy.new(self.spriteSheet,
                            math.floor(math.random(0, screenWidth)),
                            math.floor(math.random(0, screenHeight)), 1, {
        idle = {frames = {33, 34}, speed = 0.1},
        run = {frames = {33, 34}, speed = 0.1},
        death = {frames = {35}, speed = 1}
    }, self.player)
    enemy:addTag("enemy")
    sceneManager:spawnEntity(enemy)
end

function GameManager:addFrag()
    self.frags = self.frags + 1

    if self.frags > 5 then
        self:removeBody()
    end

    if self.frags%5 == 0 and enemiesCount < maxEnemies then
        self:spawnEnemy()
        enemiesCount = enemiesCount + 1
    end

    self:spawnEnemy()
end

function GameManager:removeBody()
    for i, entity in ipairs(sceneManager.entities) do
        if entity.hp <= 0 then
            entity:destroy()
            return
        end
    end
end

function GameManager:isGameOver()
    return self.player.hp <= 0
end

function GameManager:update() end
