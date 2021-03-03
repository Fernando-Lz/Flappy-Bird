Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('/assets/pipe.png')

-- Scroll speed of pipes
local PIPE_SCROLL = -90

function Pipe:init()
    self.x = VIRTUAL_WIDTH
    -- Retrieves a random position between the maximum and minimum position on screen
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 45)

    self.witdh = PIPE_IMAGE:getWidth()
end


function Pipe:update(dt)
    -- Only moves on x-axis
    self.x = self.x + PIPE_SCROLL * dt
end


function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end