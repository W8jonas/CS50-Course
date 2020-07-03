WINDOW_WIDTH = 800
WINDOW_HEIGTH = 600

VIRTUAL_WIDTH = 400
VIRTUAL_HEIGTH = 200

Class = require 'class'
push = require 'push'

require 'Map'

function love.load()
    map = Map()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGTH, WINDOW_WIDTH, WINDOW_HEIGTH, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

end


function love.update()
    
end


function love.draw()
    push:apply('start')
    love.graphics.clear(108/255, 140/255, 1, 1)

    love.graphics.print('Hello Mario!')
    map:render()
    
    push:apply('end')
end


