local judgments = {
    'Great!!',
    'Great',
    'Good',
    'Bad',
    'Miss...'
}

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

local function doScore(percent)
    local grades = {'F', 'E', 'D', 'C', 'B', 'A', 'AA', 'AAA'}
    return grades[math.floor(percent*#grades)+1]
end

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
        self.exscore = (game.judgments[1] * 2) + game.judgments[2]
        self.maxscore = #game.origchart * 2
        self.percent = self.exscore / self.maxscore
        self.grade = doScore(self.percent)
    end,
    draw = function(self)
        love.graphics.setFont(game.font.ssbig)
        love.graphics.print(tern(game.clear, 'Stage cleared!', 'Stage failed...'), 20, 20)
        love.graphics.setFont(game.font.ssmed)
        love.graphics.print(string.format([[%s - %s
Clear type: %s
High-speed: %s
Random: %s]], game.chart.author, dotitle(game.chart), ltnames[game.lifetype], tostring(game.highspeed), rannames[game.mods.random]), 20, 60)

        for i, j in ipairs(judgments) do
            love.graphics.print(string.format('%s - %d', j, game.judgments[i]), 20, 150+(i*45))
        end

        love.graphics.print(string.format('EX-Score: %d/%d (%s%%)', self.exscore, self.maxscore, tostring(roundtodp(self.percent*100))), 20, 600-65)

        love.graphics.draw(game.grades[self.grade], 800-192-25, 100)
    end,
    keyDown = function(self, k, sc, r)
        if k == 'return' then game:switchState('songselect') end
    end
}