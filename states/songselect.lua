return {
    init = function(self)
        self.selectedindex = 1
    end,
    draw = function(self)
        love.graphics.setFont(game.font.ssbig)
        love.graphics.print('Select music', 20, 20)

        local songname = game.songs[self.selectedindex].title
        local stxt = string.format('%s', songname)
        love.graphics.print(stxt, 800-10-widthex(stxt), cen_y(stxt))

        love.graphics.setFont(game.font.ssmed)
        love.graphics.setColor(0.7, 0.7, 0.7, 1)
        for i=self.selectedindex+1,#game.songs do
            local so = game.songs[i]
            local sn = so.title
            love.graphics.print(sn, 800-10-widthex(sn), cen_y(sn)+game.font.ssbig:getHeight(stxt)/2+15+((i-self.selectedindex-1)*heightex(sn)))
        end

        for i=self.selectedindex-1,1,-1 do
            local so = game.songs[i]
            local sn = so.title
            love.graphics.print(sn, 800-10-widthex(sn), cen_y(sn)-game.font.ssbig:getHeight(stxt)/2-15-(-(i-self.selectedindex+1)*heightex(sn)))
        end
    end,
    keyDown = function(self, k, sc, r)
        if k == 'down' then
            self.selectedindex = self.selectedindex + 1
            if self.selectedindex > #game.songs then
                self.selectedindex = 1
            end
        end
        if k == 'up' then
            self.selectedindex = self.selectedindex - 1
            if self.selectedindex < 1 then
                self.selectedindex = #game.songs
            end
        end
        if k == 'return' then
            game:load(game.songs[self.selectedindex])
        end
    end
}