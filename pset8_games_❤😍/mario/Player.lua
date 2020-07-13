Player = Class{}

require "Animation"

local MOVE_SPEED = 80
local JUMP_VELOCITY = 400
local MOVE_SPEED = 130
local JUMP_VELOCITY = 700

win = false

function Player:init(map)
    self.x = 0
    self.y = 0
    self.width = 16
    self.height = 20

    self.xOffset = 8
    self.yOffset = 10
    
    self.map = map
    self.texture = love.graphics.newImage('graphics/blue_alien.png')

    self.sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
        ['coin'] = love.audio.newSource('sounds/coin.wav', 'static')
    }

    self.frames = {}

    self.currentFrame = nil

    self.state = 'idle'
    self.direction = 'right'
 
    self.dx = 0
    self.dy = 0

    self.x = map.tileWidth * 10
    self.y = map.tileHeight * ((map.mapHeight - 2) / 2) - self.height

    self.frames = generateQuads(self.texture, 16, 20)

    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[1]
            },
            interval = 1
        },
        ['walking'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[9],
                self.frames[10],
                self.frames[11]
            },
            interval = 0.15
        },
        ['jumping'] = Animation {
            texture = self.texture,
            frames = {
                self.frames[3],
            },
            interval = 1
        },
    }

    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    self.behaviors = {
        ['idle'] = function(dt)

            if love.keyboard.wasPressed('space') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
                self.sounds['jump']:play()
            elseif love.keyboard.isDown('a') then
                self.direction = 'left'
                self.dx = -MOVE_SPEED
                self.state = 'walking'
                self.animations['walking']:restart()
                self.animation = self.animations['walking']
            elseif love.keyboard.isDown('d') then
                self.direction = 'right'
                self.dx = MOVE_SPEED
                self.state = 'walking'
                self.animations['walking']:restart()
                self.animation = self.animations['walking']
            else 
                self.dx = 0
            end
        end,
        ['walking'] = function(dt)

            if love.keyboard.wasPressed('space') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
                self.sounds['jump']:play()
            elseif love.keyboard.isDown('a') then
                self.direction = 'left'
                self.dx = -MOVE_SPEED
            elseif love.keyboard.isDown('d') then
                self.direction = 'right'
                self.dx = MOVE_SPEED
            else 
                self.dx = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
            end

            self:checkLeftCollision()
            self:checkRightCollision()

            if not self.map:collides(self.map:tileAt(self.x, self.y+self.height)) and
                not self.map:collides(self.map:tileAt(self.x + self.width-1, self.y + self.height)) then

                self.state = 'jumping'
                self.animation = self.animations['jumping']
            end

        end,
        ['jumping'] = function(dt)
            if self.y > 300 then
                return
            end
            
            if love.keyboard.isDown('a') then
                self.dx = -MOVE_SPEED
                self.direction = 'left'
            elseif love.keyboard.isDown('d') then
                self.dx = MOVE_SPEED
                self.direction = 'right'
            end

            self.dy = self.dy + self.map.gravity

            -- if self.y >= map.tileHeight * (map.mapHeight/2-1) - self.height then
            --     self.y = map.tileHeight * (map.mapHeight/2-1) - self.height
            --     self.dy = 0
            --     self.dx = 0
            --     self.state = 'idle'
            --     self.animation = self.animations[self.state] 
            -- end

            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                self.map:collides(self.map:tileAt(self.x + self.width -1, self.y + self.height)) then
                
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations[self.state]
                self.y = (self.map:tileAt(self.x, self.y + self.height).y-1)* self.map.tileHeight - self.height 
            end

            self:checkLeftCollision()
            self:checkRightCollision()
        end
    }
end

function Player:update(dt)
    love.graphics.printf('You win!!', 0, 42, VIRTUAL_WIDTH, 'center')
    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()

    self.x = self.x + self.dx * dt
    
    self:checkJumpingCollision()

    self:check_flag_Collision()

    self.y = self.y + self.dy * dt
end


function Player:check_flag_Collision()
    if self.dx < 0 then
        if self.map:collides_to_flag(self.map:tileAt(self.x-1, self.y)) or
            self.map:collides_to_flag(self.map:tileAt(self.x - 1, self.y + self.height -1)) then
            
            self.dx = 0
            self.dy = 0
            win = true 
        end
    end

    if self.dx > 0 then
        if self.map:collides_to_flag(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides_to_flag(self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then

            self.dx = 0
            self.dy = 0
            win = true 
        end
    end
end


function Player:checkJumpingCollision()
    if self.dy < 0 then
        if self.map:tileAt(self.x, self.y).id ~= TILE_EMPTY or
            self.map:tileAt(self.x + self.width-1, self.y).id ~= TILE_EMPTY then

            self.dy = 0
            local playCoin = false
            local playHit = false
            if self.map:tileAt(self.x, self.y).id == JUMP_BLOCK then
                self.map:setTile(math.floor(self.x/self.map.tileWidth)+1,
                    math.floor(self.y/self.map.tileHeight)+1, JUMP_BLOCK_HIT)
                playCoin = true
            else 
                playHit = true
            end
            if self.map:tileAt(self.x + self.width - 1, self.y) == JUMP_BLOCK then
                self.map:setTile(math.floor((self.x + self.width -1)/self.map.tileWidth) + 1,
                    math.floor(self.y/self.map.tileHeight)+1, JUMP_BLOCK_HIT)
                playHit = true
            else 
                playHit = true
            end
            
            if playCoin then
                self.sounds['coin']:play()
            elseif playHit then
                self.sounds['hit']:play()
            end
        end
    end
end

function Player:checkLeftCollision()
    if self.dx < 0 then
        if self.map:collides(self.map:tileAt(self.x-1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1, self.y + self.height -1)) then

            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end


function Player:checkRightCollision()
    if self.dx > 0 then
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width, self.y + self.height - 1)) then

            self.dx = 0
            self.x = (self.map:tileAt(self.x + self.width, self.y).x -1)* self.map.tileWidth - self.width
        end
    end
end


function Player:render()
    local scaleX

    -- set negative x scale factor if facing left, which will flip the sprite
    -- when applied
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    -- draw sprite with scale factor and offsets
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, scaleX, 1, self.xOffset, self.yOffset)


    if win then
        love.graphics.printf('You win!!', 0, 50, self.x*2, 'center')
    end
end
