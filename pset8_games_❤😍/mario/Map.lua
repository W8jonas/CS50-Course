require 'util'
require 'Player'

Map = Class{}

TILE_BRICK = 1
TILE_EMPTY = -1

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
JUMP_BLOCK_HIT = 9

local SCROLL_SPEED = 62


function Map:init()

    self.spriteSheet = love.graphics.newImage('graphics/spritesheet.png')
    
    self.tileWidth = 16
    self.tileHeight = 16
    
    self.tileSprites = generateQuads(self.spriteSheet, self.tileWidth, self.tileHeight)

    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

    self.gravity = 40

    self.player = Player(self)

    self.camX = 0
    self.camY = -3


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

                -- chance de criar um bloco de pulo
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


function Map:collides(tile)
    -- define our collidable tiles
    local collidables = {
        TILE_BRICK, JUMP_BLOCK, JUMP_BLOCK_HIT,
        MUSHROOM_TOP, MUSHROOM_BOTTOM
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

function Map:update(dt)
    self.player:update(dt)

    self.camX = math.max(0, 
        math.min(self.player.x - VIRTUAL_WIDTH/2,
            math.min(self.mapWidthPixel - VIRTUAL_WIDTH, self.player.x)
        )
    )
end


function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
    }
end


function Map:getTile(x, y)
    return self.tiles[(y-1) * self.mapWidth + x]
end


function Map:setTile(x, y, id)
    self.tiles[(y-1) * self.mapWidth + x] = id
end


function Map:render()
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            local tile = self:getTile(x, y)
            if tile ~= TILE_EMPTY then
                love.graphics.draw(self.spriteSheet, self.tileSprites[self:getTile(x, y)],
                    (x-1) * self.tileWidth, (y-1) * self.tileHeight)
            end
        end
    end

    self.player:render()

end

