import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "Managers/GameManager"
import "Managers/SceneManager"
import "Characters/Player"
import "Characters/Enemy"

local gfx<const> = playdate.graphics
local sfx<const> = playdate.sound

local sceneManager = SceneManager.new()
local gameManager = GameManager.new()
local lastFrameTime = 0

local function init()
    local font = gfx.font.new("Fonts/Space Harrier")
    print(font)
    gfx.setFont(font)

    gfx.setBackgroundColor(playdate.graphics.kColorBlack)

    gameManager:init()
end

function playdate.update()
    playdate.graphics.clear()

    if not gameManager:isGameOver() then
        sceneManager:update(playdate.getElapsedTime() - lastFrameTime)
    else
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite) -- Set draw mode to white
        gfx.drawText("GAME OVER", 160, 120)
        gfx.drawText("PRESS A TO RESTART", 122, 136)
        if playdate.buttonJustPressed(playdate.kButtonA) then
            gameManager:init()
        end
    end
    lastFrameTime = playdate.getElapsedTime()

    drawUI()

    playdate.timer.updateTimers()
end

function drawUI()
    -- Health bar
    gameManager.spriteSheet:drawImage(130, 10, 10)
    gfx.setColor(playdate.graphics.kColorWhite)
    gfx.drawRoundRect(34, 13, 64, 10, 4)

    local hp = gameManager.player.hp
    local maxHp = gameManager.player.maxHp
    if hp > 0 then
        gfx.fillRoundRect(37, 15, 58*(hp/maxHp), 6, 4)
    end

    -- Frags count
    gameManager.spriteSheet:drawImage(129, 10, 32)
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite) -- Set draw mode to white
    gfx.drawText(string.format("%03d", gameManager.frags), 34, 36)

    --gfx.drawText(#sceneManager.entities, 340, 16)
end

init()
