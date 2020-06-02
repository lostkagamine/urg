--[[
    -- THE URG LOADER --
    THIS IS MEANT TO BE RUN WITHIN A LOVE2D THREAD.
    REMEMBER THIS FOR FUTURE NOTICE RIN
]]

require "love.timer"
require "love.filesystem"
local json = require "lib/json"

local songs = {}

local h = love.filesystem.getDirectoryItems('songs')
for _, i in ipairs(h) do
    local hydrogen = love.filesystem.getDirectoryItems(string.format('songs/%s', i))
    for _, j in ipairs(hydrogen) do
        if j:sub(#j-4) == '.json' then
            local obj = json.decode(love.filesystem.read(string.format('songs/%s/%s', i, j)))
            -- inefficient?? ^^
            --todo shit
            obj.id = i
            table.insert(songs, obj)
        end
    end
end

love.thread.getChannel('loader'):push(songs)