Bird = Class{}

-- Multiples gravitys can be defined to set difficulty levels
local GRAVITY = 12

function Bird:init()
    -- Load image
    self.image = love.graphics.newImage('/assets/yellowbird-downflap.png')
    self.witdh = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Displays bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.witdh / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- y-axis velocity
    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    -- Only changes y-axis velocity
    self.dy = self.dy + GRAVITY * dt
    
    -- Defines how high the bird will jump
    if love.keyboard.wasPressed('space') then
        self.dy = -3
    end

    -- Changes the posotion of the bird
    self.y = self.y + self.dy
end