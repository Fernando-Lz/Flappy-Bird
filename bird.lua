Bird = Class{}

function Bird:init()
    self.image = love.graphics.newImage('/assets/yellowbird-downflap.png')
    self.witdh = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.witdh / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end