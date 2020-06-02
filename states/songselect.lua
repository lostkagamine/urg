local ltnames = {
    normal = 'Normal',
    hard = 'Hard',
    exhard = 'EX-Hard'
}
local rannames = {
    off = 'Off',
    random = 'Random',
    srandom = 'S-Random'
}

local barcycle = {'normal', 'hard', 'exhard'}
local rancycle = {'off', 'random', 'srandom'}

local selectedindex = 1

local function dotitle(song)
    local songname = song.title
    local songdiff = song.difficulty
    local nameappend = ''
    if songdiff then
        nameappend = string.format(' [%s]', songdiff)
    end
    return songname..nameappend
end

return {
    init = function(self)
        self.barindex = index(barcycle, game.lifetype)
        self.ranindex = index(rancycle, game.mods.random)
        self.optionspanel = false
        self.optionstime = love.timer.getTime()
    end,
    draw = function(self)
        love.graphics.setFont(game.font.ssbig)
        love.graphics.print('Select music', 20, 20)

        local stxt = dotitle(game.songs[selectedindex])
        love.graphics.print(stxt, 800-10-widthex(stxt), cen_y(stxt))

        love.graphics.setFont(game.font.ssmed)
        love.graphics.setColor(0.7, 0.7, 0.7, 1)
        for i=selectedindex+1,#game.songs do
            local so = game.songs[i]
            local sn = dotitle(so)
            love.graphics.print(sn, 800-10-widthex(sn), cen_y(sn)+game.font.ssbig:getHeight(stxt)/2+15+((i-selectedindex-1)*heightex(sn)))
        end

        for i=selectedindex-1,1,-1 do
            local so = game.songs[i]
            local sn = dotitle(so)
            love.graphics.print(sn, 800-10-widthex(sn), cen_y(sn)-game.font.ssbig:getHeight(stxt)/2-15-(-(i-selectedindex+1)*heightex(sn)))
        end

        if self.optionspanel then
            love.graphics.setColor(0, 0, 0, 0.75)
            love.graphics.rectangle('fill', 0, 0, 800, 600)

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(game.font.ssmed)
            local fstr = string.format([[-- Options --
            
High-speed: %sx (Q/W)
Life bar: %s (E)
Random: %s (R)
Lane cover: NOT IMPLEMENTED (A)

Please check back at a later date!]], tostring(game.highspeed), ltnames[game.lifetype], rannames[game.mods.random])
            love.graphics.print(fstr, 20, 20)
        end
    end,
    keyDown = function(self, k, sc, r)
        if k == 'down' then
            selectedindex = selectedindex + 1
            if selectedindex > #game.songs then
                selectedindex = 1
            end
            game.sounds.cursor:play()
        end
        if k == 'up' then
            selectedindex = selectedindex - 1
            if selectedindex < 1 then
                selectedindex = #game.songs
            end
            game.sounds.cursor:play()
        end
        if k == 'return' then
            game:load(game.songs[selectedindex])
        end
        if k == 'space' then
            self.optionspanel = true
            self.optionstime = love.timer.getTime()
        end
        if self.optionspanel then
            if k == 'q' then
                game.highspeed = game.highspeed - 0.25
                if game.highspeed < 0.25 then game.highspeed = 0.25 end
            end
            if k == 'w' then
                game.highspeed = game.highspeed + 0.25
            end
            if k == 'e' then
                self.barindex = self.barindex + 1
                game.lifetype = barcycle[math.mod(self.barindex-1, #barcycle)+1]
            end
            if k == 'r' then
                self.ranindex = self.ranindex + 1
                game.mods.random = rancycle[math.mod(self.ranindex-1, #rancycle)+1]
            end
        end
    end,
    keyUp = function(self, k, sc)
        if k == 'space' then
            self.optionspanel = false
            self.optionstime = love.timer.getTime()
        end
    end
}