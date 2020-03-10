judgments = {
    'Great!!',
    'Great',
    'Good',
    'Bad',
    'Miss...'
}

return {
    draw = function(self)
        love.graphics.setFont(game.font.big)
        love.graphics.print('Results', 20, 20)
    end
}