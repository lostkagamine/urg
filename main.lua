--[[
    unnamed-rhythm-game version "no"

    created and programmed by Rin 2020
]]

require "engine/constants"
-- REQUIRE EVERYTHING AFTER THAT LINE

require "util"
inspect = require "lib/inspect"
json = require "lib/json"
easings = require "lib/easings"
require "engine/engine"

local next_time = love.timer.getTime()

game.states = {
    'game',
    'songselect'
}

game.font = {
    sys = love.graphics.newFont('assets/system.ttf', 48),
    med = love.graphics.newFont('assets/standard.ttf', 20),
    ssbig = love.graphics.newFont('assets/standard.ttf', 36),
    ssmed = love.graphics.newFont('assets/standard.ttf', 24)
}

game.assets = {
    note = love.graphics.newImage('assets/note.png')
}

game.songs = {}

function game:switchState(name, args)
    if not game.states[name] then
        error("Could not switch to state "..name)
    end
    if game.state and game.state.stop then
        game.state:stop()
    end
    game.stateName = name
    game.state = game.states[name]
    if game.state.init then
        game.state:init(args)
    end

    -- RESET THE SCREEN VARIABLES
    screenX = 0
    screenY = 0
    screenCol = {1, 1, 1, 1}

    love.window.setTitle("Unnamed Project: "..name)
end

function love.load(args)
    for _, i in ipairs(game.states) do -- handle state loading
        game.states[i] = require("./states/"..i)
    end

    local h = love.filesystem.getDirectoryItems('songs')
    for _, i in ipairs(h) do
        local obj = json.decode(love.filesystem.read(string.format('songs/%s/%s.json', i, i)))
        -- inefficient?? ^^
        --todo shit
        obj.id = i
        table.insert(game.songs, obj)
    end

    game:switchState("songselect")
end

function love.update(dt)
    if game.state and game.state.update then
        game.state:update(dt)
    end

    next_time = next_time + 1/MAX_FPS
end

function love.draw()
    if game.state and game.state.draw then
        game.state:draw()
    end

    love.graphics.setFont(game.font.med)
    love.graphics.setColor(1, 1, 1, 1)
    local fpstext = tostring(love.timer.getFPS()).."/"..MAX_FPS
    if MAX_FPS == math.huge then
        fpstext = tostring(love.timer.getFPS())
    end
    love.graphics.print(fpstext, 0, 0)

    local current_time = love.timer.getTime()
    if next_time <= current_time then
        next_time = current_time
        return
    end
    love.timer.sleep(next_time - current_time)
end

function love.keypressed(k, sc, r)
    if game.state and game.state.keyDown then
        game.state:keyDown(k, sc, r)
    end
end