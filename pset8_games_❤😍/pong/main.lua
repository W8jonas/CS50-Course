WINDOW_WIDTH = 800
WINDOW_HEIGTH = 600

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGTH, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end

function love.draw()
    love.graphics.printf("Hello pong", 0, WINDOW_HEIGTH / 2 - 6, WINDOW_WIDTH, 'center')
end
