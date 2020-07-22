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

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'


function love.load()
    love.window.setTitle("Final Project CS50 - Breakout game")
    love.graphics.setBackgroundColor(32, 32, 32, 255)

    paddle = Paddle(5, 20, paddleWidth, paddleHeight)
    ball = Ball(50,50, paddleWidth, paddleHeight)

end


function love.update(dt)
  paddle:update(dt)
  ball:update(dt)
end


function love.keypressed(key)

end


function love.draw()
  -- push:apply('start')

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

  paddle:render()
  ball:render()

  -- push:apply('end')
end

