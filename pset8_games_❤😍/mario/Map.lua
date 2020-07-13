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

-- flags blocks
FLAG_1 = 13
FLAG_2 = 14
FLAG_3 = 15

-- flagpole blocks
FLAGPOLE_TOP = 8
FLAGPOLE_M = 12
FLAGPOLE_BOTTOM = 16


local SCROLL_SPEED = 62


function Map:init()

    self.spriteSheet = love.graphics.newImage('graphics/spritesheet.png')
    
    self.tileWidth = 16
    self.tileHeight = 16
    
    self.tileSprites = generateQuads(self.spriteSheet, self.tileWidth, self.tileHeight)
    self.music = love.audio.newSource('sounds/music.wav', 'static')


    self.mapWidth = 50
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
    while x < self.mapWidth - 20 do

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

    self:GeneratePyramid(x)

    self.music:setLooping(true)
    self.music:setVolume(0.05)
    self.music:play()

end

function Map:GeneratePyramid(mapWidth_x)
    local pyramidDimension = 4 + math.random(3)
    local pyramidHeight = 0
    local x = mapWidth_x

    for x = x, (self.mapWidth - 20)+20 do
        for y = self.mapHeight/2, self.mapHeight do
            self:setTile(x, y, TILE_BRICK)
        end
    end

    for x = x, x+pyramidDimension do
        for y = 0, pyramidHeight do
            self:setTile(x, self.mapHeight/2-y, TILE_BRICK)
        end
        pyramidHeight = pyramidHeight + 1
    end

    x = x + pyramidDimension + 7

    local position = self.mapHeight/2 - 1

    for y = 0, pyramidDimension do
        if y == 0 then
            self:setTile(x, position-y, FLAGPOLE_BOTTOM)
        elseif pyramidDimension ~= y then
            self:setTile(x, position-y, FLAGPOLE_M)
        else
            self:setTile(x, position-y, FLAGPOLE_TOP)
            self:setTile(x+1, position-y, FLAG_1)
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

function Map:collides_to_flag(tile)
    -- define our collidable tiles
    local collidables = {
        FLAGPOLE_TOP, FLAGPOLE_M, FLAGPOLE_BOTTOM,
        FLAG_1, FLAG_2, FLAG_3
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

