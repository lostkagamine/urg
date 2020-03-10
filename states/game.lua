local judgments = {
    "Great!!",
    "Great",
    "Good",
    "Bad",
    "Miss..."
}

local fotime = 3

return {
    init = function(self)
        self.time = love.timer.getTime()
        self.fadeout = false
        self.fadeouttime = -1
    end,
    update = function(self, t)
        game:update()

        if game.started and not game.audio:isPlaying() and not self.fadeout then
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
        love.graphics.print(debug, 0, height(game.font.med))

        for i, obj in ipairs(game.chart.notes) do
            local j = obj.notes
            love.graphics.draw(game.assets.note, LEFT_OFFSET+((j-1)*NOTE_WIDTH), (600-BOTTOM_OFFSET)-((obj.beat-game.beat)*NOTE_HEIGHT*(6*game.highspeed)))
        end

        if game.lastjudgetime <= love.timer.getTime()+0.75 and game.lastjudge ~= 0 then
            love.graphics.setFont(game.font.sys)
            local judge = string.format("%s %d", judgments[game.lastjudge], game.combo)
            if game.combo == 0 then
                judge = judgments[game.lastjudge]
            end
            love.graphics.print(judge, LEFT_OFFSET+(widthex(judge)/2), 430)
        end
        
        love.graphics.setFont(game.font.med)
        local song = string.format("%s - %s", game.chart.author, game.chart.title)
        love.graphics.print(song, cen_x(song), 150)

        if self.fadeout then
            local h = (love.timer.getTime() - self.fadeouttime) / fotime -- take 2s to fade out?
            -- wtf was i making another local for
            love.graphics.setColor(0, 0, 0, h)
            love.graphics.rectangle('fill', 0, 0, 800, 600) --fukc xd
        end
    end,
    keyDown = function(self, k, sc, r)
        game:checkinputex()
    end
}