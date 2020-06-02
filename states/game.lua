local judgments = {
    "Great!!",
    "Great",
    "Good",
    "Bad",
    "Miss..."
}

local lifecolors = {
    normal = {0, 0.8, 0.8, 1},
    hard = {0.9, 0.05, 0.05, 1},
    exhard = {0.9, 0.9, 0.05, 1}
}

local fotime = 3

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
        self.time = love.timer.getTime()
        self.fadeout = false
        self.fadeouttime = -1
    end,
    update = function(self, t)
        game:update()

        if game.ended and not self.fadeout then
            self.fadeouttime = love.timer.getTime()
            self.fadeout = true
        end

        if self.fadeout then
            local h = (love.timer.getTime() - self.fadeouttime) / fotime
            if h >= 1.1 then
                game:switchState('results')
            end
        end
    end,
    draw = function(self)
        love.graphics.setColor(1, 0.1, 0.1, 1)
        love.graphics.rectangle("fill", LEFT_OFFSET, (600)-BOTTOM_OFFSET, NOTE_WIDTH*LANE_COUNT, NOTE_HEIGHT)
        local debug = string.format("engine debug\nb: %f\npos: %f\nbpm: %f", game.beat, game.audio:tell(), game.bpm or 0)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(game.font.med)
        --love.graphics.print(debug, 0, height(game.font.med))

        local stats = string.format("HS %sx - BPM %d", game.highspeed, game.bpm)
        love.graphics.print(stats, 10, 600-10-(heightex(stats)))

        for i, obj in ipairs(trimtable(game.chart.notes, game.curr.note)) do
            local j = obj.note
            local bigscaryformula = (600-BOTTOM_OFFSET)-((obj.beat-game.beat)*NOTE_HEIGHT*(6*game.highspeed))
            local stop = (600-BOTTOM_OFFSET)
            love.graphics.draw(game.assets.note, LEFT_OFFSET+((j-1)*NOTE_WIDTH), math.min(bigscaryformula, stop))
        end

        if game.lastjudgetime <= love.timer.getTime()+0.75 and game.lastjudge ~= 0 then
            love.graphics.setFont(game.font.sys)
            local judge = string.format("%s %d", judgments[game.lastjudge], game.combo)
            if game.combo == 0 then
                judge = judgments[game.lastjudge]
            end
            love.graphics.print(judge, (NOTE_WIDTH*LANE_COUNT+LEFT_OFFSET)*0.6-(widthex(judge)/2), 430)
        end
        
        love.graphics.setFont(game.font.med)
        local song = string.format("%s - %s", game.chart.author, dotitle(game.chart))
        love.graphics.print(song, 800-(widthex(song))-20, 20)

        love.graphics.setColor(unpack(lifecolors[game.lifetype]))
        love.graphics.rectangle('fill', LEFT_OFFSET, (600-BOTTOM_OFFSET+NOTE_HEIGHT), game.life/100 * (NOTE_WIDTH*LANE_COUNT), 15)
        love.graphics.setColor(1, 1, 1, 1)

        if self.fadeout then
            local h = (love.timer.getTime() - self.fadeouttime) / fotime -- take 2s to fade out?
            -- wtf was i making another local for
            love.graphics.setColor(0, 0, 0, h)
            love.graphics.rectangle('fill', 0, 0, 800, 600) --fukc xd
        end
    end,
    keyDown = function(self, k, sc, r)
        if k == "escape" then
            game.clear = false
            game:endSong(true)
        end

        game:checkinputex()
    end
}