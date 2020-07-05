require 'util'

Map = Class{}

TILE_BRICK = 1
TILE_EMPTY = 4

-- cloud tiles
CLOUD_LEFT = 6
CLOUD_RIGHT = 7

-- bush tiles
BUSH_LEFT = 2
BUSH_RIGHT = 3

-- mustroom tiles
MUSHROOM_TOP = 10
MUSHROOM_BOTTOM = 11

-- jump block
JUMP_BLOCK = 5

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
    for y = 1, self.mapHeight do 
        for x = 1, self.mapWidth do
            self:setTile(x, y, TILE_EMPTY)
        end
    end












    -- gerando o terreno usando vertical scan
    local x = 1
    while x < self.mapWidth do

        -- 2% chance de gerar nuvens
        -- garantindo que existe espaco para colocar os dois blocos
        if x < self.mapWidth - 2 then
            if math.random(20) == 1 then 
                
                -- escolhendo uma posicao aleatoria para colocar os blocos
                local cloudStart = math.random(self.mapHeight / 2 - 6)

                self:setTile(x, cloudStart, CLOUD_LEFT)
                self:setTile(x+1, cloudStart, CLOUD_RIGHT)
            end
        end

        -- 5% chance para gerar mushroom
        if math.random(20) == 1 then
            -- pega posicoes do cano
            self:setTile(x, self.mapHeight/2-2, MUSHROOM_TOP)
            self:setTile(x, self.mapHeight/2-1, MUSHROOM_BOTTOM)
            
            -- coloca o chao do mapa
            for y = self.mapHeight/2, self.mapHeight do 
                self:setTile(x, y, TILE_BRICK)
            end

            -- proxima linha
            x = x + 1

        -- 10% de chance de gerar bush
        elseif math.random(10) == 1 and x < self.mapWidth - 3 then
            local bushLevel = self.mapHeight / 2 - 1
            
            -- colocando arbusto e coluna de tijolos
            self:setTile(x, bushLevel, BUSH_LEFT)
            for y = self.mapHeight /2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

            self:setTile(x, bushLevel, BUSH_RIGHT)
            for y = self.mapHeight /2, self.mapHeight do
                self:setTile(x, y, TILE_BRICK)
            end
            x = x + 1

            -- 10% chance de nao fazer nada, criando um buraco
            elseif math.random(10) ~= 1 then

                -- criando coluna
                for y = self.mapHeight /2, self.mapHeight do
                    self:setTile(x, y, TILE_BRICK)
                end

                -- chance de criar um bloco de puto
                if math.random(15) == 1 then
                    self:setTile(x, self.mapHeight / 2 - 4, JUMP_BLOCK)
                end

                -- 
            x = x + 1
        else 
            x = x + 2
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

