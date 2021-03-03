Bird = Class{}

-- Multiples gravitys can be defined to set difficulty levels
local GRAVITY = 9.5
local BIRD_WITDH = 34
local BIRD_HEIGHT = 24
local birdImage
local birdFrames = {}
local totalNumberofFrames = 3

local currentFrame = 1
local desiredDelay = 0.3
local timePassedSinceLastFrame = 0

local flap = love.audio.newSource('/assets/audio/flap.wav', 'stream')

function Bird:init()
    math.randomseed(os.time())
    -- Load image
    selection = math.random(1, 3)
    if selection == 1 then
        birdImage = love.graphics.newImage('/assets/birdstages.png')
        for frame = 1, totalNumberofFrames do
            birdFrames[frame] = love.graphics.newQuad((frame - 1) * BIRD_WITDH, 0, BIRD_WITDH, BIRD_HEIGHT, birdImage:getDimensions())
        end
    elseif selection == 2 then
        birdImage = love.graphics.newImage('/assets/birdstages2.png')
        for frame = 1, totalNumberofFrames do
            birdFrames[frame] = love.graphics.newQuad((frame - 1) * BIRD_WITDH, 0, BIRD_WITDH, BIRD_HEIGHT, birdImage:getDimensions())
        end
    else
        birdImage = love.graphics.newImage('/assets/birdstages3.png')
        for frame = 1, totalNumberofFrames do
            birdFrames[frame] = love.graphics.newQuad((frame - 1) * BIRD_WITDH, 0, BIRD_WITDH, BIRD_HEIGHT, birdImage:getDimensions())
        end
    end
    self.witdh = WITDH
    self.height = HEIGHT

    -- Displays bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (BIRD_WITDH / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (BIRD_HEIGHT / 2)

    -- y-axis velocity
    self.dy = 0
    
end

function Bird:update(dt)
    -- Bird Image Update
    timePassedSinceLastFrame = timePassedSinceLastFrame + dt
    if timePassedSinceLastFrame > desiredDelay then
        timePassedSinceLastFrame = timePassedSinceLastFrame - desiredDelay
        currentFrame = currentFrame % totalNumberofFrames + 1
    end

    -- Only changes y-axis velocity
    self.dy = self.dy + GRAVITY * dt
    
    -- Defines how high the bird will jump
    if love.keyboard.wasPressed('space') then
        self.dy = -2.5
        love.audio.play(flap)
    end

    -- Changes the posotion of the bird
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(birdImage, birdFrames[currentFrame], self.x, self.y)
end

function Bird:collides(pipe)
    -- Shifts the hit box of the bird to give more opportunities to the user
    -- X axis hitbox
    -- left        right
    if (self.x + 3) + (BIRD_WITDH - 8) >= pipe.x and self.x + 3 <= pipe.x + PIPE_WIDTH - 15 then
        -- top         bottom
        if (self.y + 2) + (BIRD_HEIGHT - 2) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end    