WINDOW_WIDTH = 800
WINDOW_HEIGTH = 600

VIRTUAL_WIDTH = 400
VIRTUAL_HEIGTH = 200

PADDLE_SPEED = 200

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    math.randomseed(os.time())

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

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGTH - 30, 5, 20)

    ballX = VIRTUAL_WIDTH/2-2
    ballY = VIRTUAL_HEIGTH/2-2

    -- math.random(2) == 1 ? -100 : 100
    ballDX = math.random(2) == 1 and -100 or 100
    ballDY = math.random(-50, 50)

    gameState = 'start'


end


function love.update(dt)

    paddle1:update(dt)
    paddle2:update(dt)

    if love.keyboard.isDown('w') then
        paddle1.dy = - PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end


    if love.keyboard.isDown('up') then
        paddle2.dy = - PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else 
        paddle2.dy = 0
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key== 'return' then

        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'

            ballX = VIRTUAL_WIDTH/2-2
            ballY = VIRTUAL_HEIGTH/2-2

            ballDX = math.random(2) == 1 and -100 or 100
            ballDY = math.random(-50, 50)
        end

    end


end

function love.draw()
    push:apply('start')

    -- Colocar cor de fundo
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        -- Escreve Hello pong na tela
        love.graphics.printf("Hello Pong! Hit ENTER to Start the game", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- Escreve Hello pong na tela
        love.graphics.printf("Hello Pong!, Press ESC or SCAPE to exit", 0, 20, VIRTUAL_WIDTH, 'center')
    end
    
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGTH/3 )
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGTH/3 )

    -- Desenha bola no meio da tela
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)
   
    -- Desenha uma raquete na esquerda
    paddle1:render()
    -- love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    
    -- Desenha uma raquete na direita
    paddle2:render()
    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)



    push:apply('end')
end
