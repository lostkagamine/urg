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
    local obj = json.decode(love.filesystem.read(string.format('songs/%s/%s.json', i, i)))
    -- inefficient?? ^^
    --todo shit
    obj.id = i
    table.insert(songs, obj)
end

love.thread.getChannel('loader'):push(songs)