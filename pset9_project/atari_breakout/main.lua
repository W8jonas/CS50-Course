WINDOW_WIDTH = 800
WINDOW_HEIGTH = 600

VIRTUAL_WIDTH = 400
VIRTUAL_HEIGTH = 200

paddleWidth = 100
paddleHeight = 20
paddleSpeed = 400

ballDimension = 10

brickRows = 20
brickCols = 20
bricks = {}

PADDLE_SPEED = 400

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'


function love.load()
	love.window.setTitle("Final Project CS50 - Breakout game")
	love.graphics.setBackgroundColor(32, 32, 32, 255)

	paddle = Paddle(WINDOW_WIDTH/2-paddleWidth/2, WINDOW_HEIGTH-paddleHeight-50, paddleWidth, paddleHeight)
	ball = Ball(WINDOW_WIDTH/2,WINDOW_HEIGTH/2, paddleWidth, paddleHeight)

end


function love.update(dt)

	if love.keyboard.isDown('a') then
		paddle.dx = - PADDLE_SPEED
	elseif love.keyboard.isDown('d') then
		paddle.dx = PADDLE_SPEED
	else
		paddle.dx = 0
	end

	if ball:Collides(paddle) then
		ball.dy = - ball.dy 

		if ball.dx < 0 then
			ball.dx = -math.random(20, 150)
		else
			ball.dx = math.random(20, 150)
		end
	end

	paddle:update(dt)
	ball:update(dt)
end


function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end


function love.draw()
  -- push:apply('start')

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

  paddle:render()
  ball:render()

  -- push:apply('end')
end

