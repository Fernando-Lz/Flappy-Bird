push = require "push"
Class = require "class"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--background image
local background = love.graphics.newImage('/assets/background.png')
local ground = love.graphics.newImage('/assets/ground.png')


function love.load(arg)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Flappy Bird!")

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true  
    })
end

function function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key, scancode, isrepeat)
    -- escape
    if key == 'escape' then
        love.event.quit()
    end


end

function love.update(dt)
    -- body...
end

function love.draw()
    push:start()

    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    push:finish()
end
