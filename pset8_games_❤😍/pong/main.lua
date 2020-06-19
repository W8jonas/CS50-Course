WINDOW_WIDTH = 800
WINDOW_HEIGTH = 600

VIRTUAL_WIDTH = 400
VIRTUAL_HEIGTH = 200

push = require 'push'



function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    smallFont = love.graphics.newFont('font.ttf', 8)

    love.graphics.setFont(smallFont)

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

    -- Colocar cor de fundo
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- Desenha bola no meio da tela
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2-2, VIRTUAL_HEIGTH/2-2, 5, 5)
   
    -- Desenha bola no meio da tela
    love.graphics.rectangle('fill', 5, 20, 5, 20)
    
    -- Desenha bola no meio da tela
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGTH - 40, 5, 20)


    -- Escreve Hello pong na tela
    love.graphics.printf("Hello pong", 0, 20, VIRTUAL_WIDTH, 'center')
    
    push:apply('end')
end
