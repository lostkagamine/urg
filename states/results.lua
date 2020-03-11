local judgments = {
    'Great!!',
    'Great',
    'Good',
    'Bad',
    'Miss...'
}

return {
    init = function(self)
        self.exscore = (game.judgments[1] * 2) + game.judgments[2]
    end,
    draw = function(self)
        love.graphics.setFont(game.font.ssbig)
        love.graphics.print('Results', 20, 20)
        love.graphics.setFont(game.font.ssmed)
        love.graphics.print(string.format('%s - %s', game.chart.author, game.chart.title), 20, 60)

        for i, j in ipairs(judgments) do
            love.graphics.print(string.format('%s - %d', j, game.judgments[i]), 20, 100+(i*45))
        end

        love.graphics.print('EX-Score: '..self.exscore, 20, 600-65)
    end,
    keyDown = function(self, k, sc, r)
        if k == 'return' then game:switchState('songselect') end
    end
}