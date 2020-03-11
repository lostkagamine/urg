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

game.inputoffset = 0 -- MILLISECONDS

game.states = {
    'game',
    'songselect',
    'loading',
    'results'
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

game.sounds = {
    cursor = love.audio.newSource('assets/change.wav', 'static')
}

game.songs = {}

local loaderThread = love.thread.newThread('loader.lua')

local currentNotification = nil
local cnTime = 0

function notify(text)
    currentNotification = text
    cnTime = love.timer.getTime()
end

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

    love.window.setTitle("Unnamed Rhythm Game: "..name)
end

function love.load(args)
    for _, i in ipairs(game.states) do -- handle state loading
        game.states[i] = require("./states/"..i)
    end

    loaderThread:start()

    game:switchState("loading")
end

function love.update(dt)
    if game.state and game.state.update then
        game.state:update(dt)
    end

    local m = love.thread.getChannel('loader'):pop()
    if m and game.stateName == 'loading' then
        game.songs = m
        game.state:doneLoading(function()
            game:switchState('songselect')
        end)
    end

    next_time = next_time + 1/MAX_FPS
end

function love.draw()
    if game.state and game.state.draw then
        game.state:draw()
    end

    if currentNotification ~= nil then
        love.graphics.setFont(game.font.med)
        local notifalpha = 1.5 + (1 - (love.timer.getTime() - cnTime))
        love.graphics.setColor(0.1, 0.1, 0.1, notifalpha)
        love.graphics.rectangle('fill', 0, 0, widthex(currentNotification)+40, 60)
        love.graphics.setColor(1, 1, 1, notifalpha)
        love.graphics.print(currentNotification, 20, 20)
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
    local shift = love.keyboard.isDown('lshift')
    local offsetchange = 0
    if k == 'f11' then
        if shift then offsetchange = 0.1 else offsetchange = 0.01 end
        notify(string.format('Offset changed: %s => %s', game.inputoffset, game.inputoffset + offsetchange))
        game.inputoffset = game.inputoffset - offsetchange
    end
    if k == 'f12' then
        if shift then offsetchange = 0.1 else offsetchange = 0.01 end
        notify(string.format('Offset changed: %s => %s', game.inputoffset, game.inputoffset + offsetchange))
        game.inputoffset = game.inputoffset + offsetchange
    end
    if game.state and game.state.keyDown then
        game.state:keyDown(k, sc, r)
    end
end

function love.keyreleased(k, sc)
    if game.state and game.state.keyUp then
        game.state:keyUp(k, sc)
    end
end