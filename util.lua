function height()
    local f = love.graphics.getFont()
    return f:getHeight('a')
end

function width()
    local f = love.graphics.getFont()
    return f:getWidth('a')
end

function widthex(t) -- how to name your functions after windows api
    local f = love.graphics.getFont()
    return f:getWidth(t)
end

function heightex(t) -- how to name your functions after windows api
    local f = love.graphics.getFont()
    return f:getHeight(t)
end

function cen_x(t)
    local f = love.graphics.getFont()
    return (800/2)-(f:getWidth(t)/2)
end

function cen_y(t)
    local f = love.graphics.getFont()
    return (600/2)-(f:getHeight(t)/2)
end

function nearest(tab, val) -- stackoverflow saves the day once again
    local smallestSoFar, smallestIndex
    for i, y in ipairs(tab) do
        if not smallestSoFar or (math.abs(val-y) < smallestSoFar) then
            smallestSoFar = math.abs(val-y)
            smallestIndex = i
        end
    end
    return smallestIndex, tab[smallestIndex]
end

function trimtable(t, s, e)
    if not e then e = #t end
    local n = {}
    for i=s,e do
        table.insert(n, t[i])
    end 
    return n
end

function findclosestnote()
    local smallestSoFar, smallestIndex
    local whatdoinamethisvar = trimtable(game.chart.notes, game.curr.note)
    for i, h in ipairs(whatdoinamethisvar) do
        local y = h.beat
        if not smallestSoFar or (math.abs(game.beat-y) < smallestSoFar) then
            smallestSoFar = math.abs(game.beat-y)
            smallestIndex = i
        end
    end
    return smallestIndex, whatdoinamethisvar[smallestIndex]
end