Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x 
    self.y = y 
    self.width = width 
    self.height = height
    self.dy = 0
    self.dx = 0

    -- self.x = VIRTUAL_WIDTH/2-2
    -- ballY = VIRTUAL_HEIGTH/2-2

    self.dy = math.random(2) == 1 and -BALL_SPEED or BALL_SPEED
    self.dx = math.random(-50, 50)

end

function Ball:Collides(box)
    if self.x > box.x + box.width or self.x < box.x then
        return false
    end

    if self.y > box.y + box.height or self.y + self.height < box.y then
        return false
    end

    return true
end

function Ball:reset()
    self.x = WINDOW_WIDTH/2
    self.y = WINDOW_HEIGTH/2

    self.dy = math.random(2) == 1 and -BALL_SPEED or BALL_SPEED
    self.dx = math.random(-50, 50)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.y <= 0 then
        self.dy = - self.dy
        self.y = 0 * dt
    end

    if self.x <= 0 then
        self.dx = - self.dx
        self.x = 0 * dt
    end

    if self.x > WINDOW_WIDTH then
        self.dx = - self.dx
        self.x = WINDOW_WIDTH - self.x * dt
    end

    if self.y > WINDOW_HEIGTH then
        TOTAL_LIVES = TOTAL_LIVES - 1
        self:reset()
    end

end


function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, ballDimension, ballDimension)
end
