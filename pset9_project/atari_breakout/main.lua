-- Configurações de tela
WINDOW_WIDTH = 800
WINDOW_HEIGTH = 600

VIRTUAL_WIDTH = 400
VIRTUAL_HEIGTH = 200

-- Configuracões de raquete e bola
paddleWidth = 100
paddleHeight = 20
paddleSpeed = 400

ballDimension = 10

PADDLE_SPEED = 400
BALL_SPEED = 200

-- Configuracões dos tijolos
brickRows = 10
brickCols = 20
bricks = {}

brickWidth = 40
brickHeight = 30
levels = {
	  { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
	  { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
	  { 0,1,1,1,0,1,1,1,1,0,1,1,1,0,0,1,1,0,0,0 },
	  { 0,1,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,0 },
	  { 0,1,0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,1,0,0 },
	  { 0,1,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,1,0,0 },
	  { 0,1,0,0,0,0,0,0,1,0,0,0,1,0,1,0,0,1,0,0 },
	  { 0,1,1,1,0,1,1,1,1,0,1,1,1,0,0,1,1,0,0,0 },
	  { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 },
	  { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
  }
  
colors = {
	{ 0/255, 		255/255, 		0/255, 			255/255, },
	{ 0/255, 		255/255, 		128/255, 		255/255, },
	{ 0/255, 		255/255, 		255/255, 		255/255, },
	{ 0/255, 		128/255, 		255/255, 		255/255, },
	{ 0/255, 		0/255, 			255/255, 		255/255, },
	{ 255/255, 		0/255, 			0/255, 			255/255, },
	{ 255/255, 		128/255, 		0/255, 			255/255, },
	{ 255/255, 		255/255, 		0/255, 			255/255, },
	{ 128/255, 		255/255, 		0/255, 			255/255, },
	{ 128/255, 		0/255, 			255/255, 		255/255, },
	{ 255/255, 		0/255, 			255/255, 		255/255, },
	{ 255/255, 		0/255, 			128/255, 		255/255, },
  }


-- Configuracões do jogo
missingBricks = 0
TOTAL_LIVES = 5
win = false 

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'


function love.load()
	love.window.setTitle("Final Project CS50 - Breakout game")
	love.graphics.setBackgroundColor(32, 32, 32, 255)

	paddle = Paddle(WINDOW_WIDTH/2-paddleWidth/2, WINDOW_HEIGTH-paddleHeight-50, paddleWidth, paddleHeight)
	ball = Ball(WINDOW_WIDTH/2,WINDOW_HEIGTH/2, ballDimension, ballDimension)

	for j = 1, brickRows do
		bricks[j] = {}
		for i = 1, brickCols do
		  	bricks[j][i] = 0
		end
	end

	for _row = 1, brickRows do
		for _column = 1, brickCols do
			  bricks[_row][_column] = levels[_row][_column]
			  if levels[_row][_column] == 1 then 
				missingBricks = missingBricks + 1
			  end
		end
	end

end


function love.update(dt)

	if love.keyboard.isDown('a') then
		paddle.dx = - PADDLE_SPEED
	elseif love.keyboard.isDown('d') then
		paddle.dx = PADDLE_SPEED
	else
		paddle.dx = 0
	end

	ball:CollidesWithBlocks(dt)

	if ball:Collides(paddle) then
		ball.dy = - ball.dy * 1.10

		-- if (paddle.dx < 0) then
		-- 	ball.dx = ball.dx * 1.06 * -1
		-- else
		-- 	ball.dx = ball.dx * 1.06 * 1
		-- end
		
		-- ball.dx = ball.dx + paddle_x
		-- ball.dx = ball.dx + paddle.dx - math.random(20, 150)


		local paddle_x = math.min(math.max(-50, paddle.dx), 50)
		
		ball.dx = math.min(math.max(-150, ball.dx + paddle_x), 150)

		ball.dy = math.min(math.max(-650, ball.dy), 650)
	end


	if missingBricks == 0 then 
		win = true 
	end

	if win == false then
		paddle:update(dt)
		ball:update(dt)
	end
end


function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end


function love.draw()
	-- push:apply('start')

	love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

	love.graphics.setColor(16, 16, 16, 1)
	paddle:render()
	ball:render()

	if win == false then
		local c
		for j = 1, brickRows do
			c = 1
			for i = 1, brickCols do
				if bricks[j][i] == 1 then
					love.graphics.setColor(16, 16, 16, 1)
					love.graphics.rectangle("fill", (i - 1)*brickWidth, (j - 1)*brickHeight, brickWidth, brickHeight)
					love.graphics.setColor(colors[c])
					love.graphics.rectangle("fill", (i - 1)*brickWidth + 2, (j - 1)*brickHeight + 2, brickWidth - 4, brickHeight - 4)
				end
				
				c = c + 1
				c = c > 12 and 1 or c
			end
		end
	else
		love.graphics.print('YOU WIN!', WINDOW_WIDTH/2, WINDOW_HEIGTH/2)
	end

	-- love.graphics.print(missingBricks, WINDOW_WIDTH/2, WINDOW_HEIGTH/2)

	-- push:apply('end')
end

