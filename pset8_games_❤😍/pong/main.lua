WINDOW_WIDTH = 800
WINDOW_HEIGTH = 600

VIRTUAL_WIDTH = 400
VIRTUAL_HEIGTH = 200

push = require 'push'


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGTH, WINDOW_WIDTH, WINDOW_HEIGTH, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')

    love.graphics.printf("Hello pong", 0, VIRTUAL_HEIGTH / 2 - 6, VIRTUAL_WIDTH, 'center')
    
    push:apply('end')
end
