WINDOW_WIDTH = 800
WINDOW_HEIGTH = 600

VIRTUAL_WIDTH = 400
VIRTUAL_HEIGTH = 200

PADDLE_SPEED = 200

push = require 'push'


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGTH, WINDOW_WIDTH, WINDOW_HEIGTH, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    -- Variáveis globais

    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGTH - 40

end


function love.update(dt)

    if love.keyboard.isDown('w') then
        player1Y = player1Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end


    if love.keyboard.isDown('up') then
        player2Y = player2Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end


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

    love.graphics.setFont(smallFont)
    -- Escreve Hello pong na tela
    love.graphics.printf("Hello pong", 0, 20, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGTH/3 )
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGTH/3 )

    -- Desenha bola no meio da tela
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2-2, VIRTUAL_HEIGTH/2-2, 5, 5)
   
    -- Desenha uma raquete na esquerda
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    
    -- Desenha uma raquete na direita
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)



    push:apply('end')
end
