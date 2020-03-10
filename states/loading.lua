local fotime = 1.5

return {
    init = function(self)
        self.time = love.timer.getTime()
        self.fadeout = false
        self.fadeouttime = -1
        self.callback = nil
    end,
    draw = function(self)
        local t = love.timer.getTime() - self.time
        local a = math.abs(math.sin(t))
        love.graphics.setColor(a, a, a, 1)
        love.graphics.setFont(game.font.ssmed)
        love.graphics.print("Loading...", 20, 600-45)

        if self.fadeout then
            local h = (love.timer.getTime() - self.fadeouttime) / fotime -- take 2s to fade out?
            -- wtf was i making another local for
            love.graphics.setColor(0, 0, 0, h)
            love.graphics.rectangle('fill', 0, 0, 800, 600) --fukc xd
        end
    end,
    update = function(self)
        if self.fadeout then
            local h = (love.timer.getTime() - self.fadeouttime) / fotime
            if h >= 1.1 and self.callback ~= nil then
                self.callback()
                self.callback = nil -- hehdrfhsdgfhjkgsdjlkgh
            end
        end
    end,
    doneLoading = function(self, callback)
        self.callback = callback
        self.fadeouttime = love.timer.getTime()
        self.fadeout = true
    end
}