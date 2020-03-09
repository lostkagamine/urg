local judgments = {
    "Great!!",
    "Great",
    "Good",
    "Miss..."
}

return {
    update = function(self, t)
        game:update()
    end,
    draw = function(self)
        love.graphics.setColor(1, 0.1, 0.1, 1)
        love.graphics.rectangle("fill", LEFT_OFFSET, (600)-BOTTOM_OFFSET, NOTE_WIDTH*LANE_COUNT, NOTE_HEIGHT)

        local debug = string.format("engine debug\nb: %f\npos: %f\nind: %d\nbpm: %f", game.beat, game.audio:tell(), game.curr.note, game.bpm)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(game.font.med)
        love.graphics.print(debug, 0, height(game.font.med))

        for i=game.curr.note, #game.chart.notes do
            local obj = game.chart.notes[i]
            local j = obj.notes
            love.graphics.draw(game.assets.note, LEFT_OFFSET+((j-1)*NOTE_WIDTH), (600-BOTTOM_OFFSET)-((obj.beat-game.beat)*NOTE_HEIGHT*(2*game.highspeed)))
        end

        if game.lastjudgetime <= love.timer.getTime()+0.75 and game.lastjudge ~= 0 then
            love.graphics.setFont(game.font.sys)
            local judge = string.format("%s %d", judgments[game.lastjudge], game.combo)
            if game.combo == 0 then
                judge = judgments[game.lastjudge]
            end
            love.graphics.print(judge, LEFT_OFFSET/2+(widthex(judge)/2), 480)
        end
        
        love.graphics.setFont(game.font.med)
        local song = string.format("%s - %s", game.chart.author, game.chart.title)
        love.graphics.print(song, cen_x(song), 150)
    end,
    keyDown = function(self, k, sc, r)
        game:checkinputex()
    end
}