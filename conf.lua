function love.conf(t)
    t.window.vsync = false
end

function love.threaderror(thr, e)
    error(string.format('\n\n'..[[
OOPSIE WHOOPSIE, A THREAD DID A FUCKY WUCKY!
- This usually means something went wrong while loading. Usually. -

%s]]..'\n', e))
end