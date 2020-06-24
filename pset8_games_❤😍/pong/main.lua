WINDOW_WIDTH = 800
WINDOW_HEIGTH = 600

VIRTUAL_WIDTH = 400
VIRTUAL_HEIGTH = 200

PADDLE_SPEED = 200

POINTS_TO_VICTORY = 3

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    love.window.setTitle('Pong')

    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    victoryFont = love.graphics.newFont('font.ttf', 24)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGTH, WINDOW_WIDTH, WINDOW_HEIGTH, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    -- Variáveis globais

    player1Score = 0
    player2Score = 0

    servingPlayer = math.random(2) == 1 and 1 or 2

    winningPlayer = 0

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGTH - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGTH/2 - 2, 5, 5)

    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    gameState = 'start'

end


function love.update(dt)
    if gameState == 'play' then

        if ball.x <= 0 then
            player2Score = player2Score + 1 
            servingPlayer = 1
            ball:reset()
            ball.dx = 100            
            gameState = 'serve'

            if player2Score >= POINTS_TO_VICTORY then
                gameState = 'victory'
                winningPlayer = 2
            else
                gameState = 'serve'
            end
        end

        if ball.x >= VIRTUAL_WIDTH - 4 then
            player1Score = player1Score + 1 
            servingPlayer = 2
            ball:reset()
            ball.dx = -100            
            gameState = 'serve'

            if player1Score >= POINTS_TO_VICTORY then
                gameState = 'victory'
                winningPlayer = 1
            else
                gameState = 'serve'
            end
        end

        if ball:Collides(paddle1) then
            ball.dx = -ball.dx * 1.03
            ball.x = paddle1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
    
        if ball:Collides(paddle2) then
            ball.dx = -ball.dx
        end
    
        if ball.y <= 0 then
            ball.dy = - ball.dy
            ball.y = 0
        end
    
        if ball.y > VIRTUAL_HEIGTH then
            ball.dy = - ball.dy
            ball.y = VIRTUAL_HEIGTH - 4
        end
        
        -- Movimentação do jogador 1
        if love.keyboard.isDown('w') then
            paddle1.dy = - PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            paddle1.dy = PADDLE_SPEED
        else
            paddle1.dy = 0
        end
    
        -- Movimentação do jogador 2
        if love.keyboard.isDown('up') then
            paddle2.dy = - PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            paddle2.dy = PADDLE_SPEED
        else 
            paddle2.dy = 0
        end

    end


    if gameState == 'play' then
        ball:update(dt)
    end

    paddle1:update(dt)
    paddle2:update(dt)

end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key== 'return' then

        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'victory' then
            gameState = 'start'
            player1Score = 0
            player2Score = 0
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
end

function love.draw()
    push:apply('start')

    -- Colocar cor de fundo
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.setFont(smallFont)

    
    if gameState == 'start' then
        love.graphics.printf('Welcome to Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Play!', 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s turn!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(scoreFont)
        love.graphics.printf('Press Enter to serve!', 0, 42, VIRTUAL_WIDTH, 'center')
    end
    

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGTH/3 )
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGTH/3 )

    
    -- Desenha uma raquete na esquerda
    paddle1:render()
    
    -- Desenha uma raquete na direita
    paddle2:render()
    
    -- Desenha bola no meio da tela
    ball:render()

    displayFPS()

    push:apply('end')
end


function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 5)
    love.graphics.setColor(1, 1 ,1, 1)
end