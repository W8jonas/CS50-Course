Map = Class{}

TILE_BRICK = 1
TILE_EMPTY = 4

local SCROLL_SPEED = 62

function Map:init()
    self.spriteSheet = love.graphics.newImage('graphics/spritesheet.png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    self.camX = 0
    self.camY = -3

    self.tileSprites = generateQuads(self.spriteSheet, self.tileWidth, self.tileHeight)


    self.mapWidthPixel = self.mapWidth * self.tileWidth
    self.mapHeightPixel = self.mapHeight * self.tileHeight


    -- Colocando céu
    for y = 1, self.mapHeight/2 do 
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    -- Colocando chão
    for y = self.mapHeight/2, self.mapHeight do 
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_BRICK)
        end
    end

end


function Map:setTile(x, y, tile)
    self.tiles[(y-1) * self.mapWidth + x] = tile
end


function Map:getTile(x, y)
    return self.tiles[(y-1) * self.mapWidth + x]
end


function Map:update(dt)

    if love.keyboard.isDown('w') then
        self.camY = math.max(0, math.floor(self.camY - SCROLL_SPEED * dt))

    elseif love.keyboard.isDown('a') then
        self.camX = math.max(0, math.floor(self.camX - SCROLL_SPEED * dt))

    elseif love.keyboard.isDown('s') then
        self.camY = math.min(self.mapHeightPixel - VIRTUAL_HEIGHT, math.floor(self.camY + SCROLL_SPEED * dt))
        
    elseif love.keyboard.isDown('d') then
        self.camX = math.min(self.mapWidthPixel - VIRTUAL_WIDTH, math.floor(self.camX + SCROLL_SPEED * dt))
    end

end


function Map:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            love.graphics.draw(self.spriteSheet, self.tileSprites[self:getTile(x, y)],
                (x-1) * self.tileWidth, (y-1) * self.tileHeight)
        end
    end
end

