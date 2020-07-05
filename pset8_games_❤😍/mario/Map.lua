Map = Class{}

TILE_BRICK = 1
TILE_EMPTY = 4

local SCROLL_SPEED = 62

function Map:init()
    self.spriteSheet = love.graphics.newImage('graphics/spritesheet.png')
    self.tileWidht = 16
    self.tileHeith = 16
    self.mapWidth = 30
    self.mapHeigth = 28
    self.tiles = {}

    self.camX = 0
    self.camY = 0

    self.tileSprites = generateQuads(self.spriteSheet, self.tileWidht, self.tileHeith)

    -- Colocando céu
    for y = 1, self.mapHeigth/2 do 
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    -- Colocando chão
    for y = self.mapHeigth/2, self.mapHeigth do 
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

    self.camX = self.camX + SCROLL_SPEED * dt

end


function Map:render()
    for y = 1, self.mapHeigth do
        for x = 1, self.mapWidth do
            love.graphics.draw(self.spriteSheet, self.tileSprites[self:getTile(x, y)],
                (x-1) * self.tileWidht, (y-1) * self.tileHeith)
        end
    end
end

