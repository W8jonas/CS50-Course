Player = Class{}


function Player:init(map)
    self.width = 16
    self.height = 20

    self.x = map.tileWidth * 10
    self.y = map.tileHeight * (map.mapHeight/2-1) - self.height

    self.texture = love.graphics.newImage('graphics/blue_alien.png')
    self.frames = generateQuads(self.texture, 16, 20)

end


function Player:update(dt)

end


function Player:render()
    love.graphics.draw(self.texture, self.frames[1], self.x, self.y)
end

