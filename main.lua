push = require "push"
Class = require "class"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 534
VIRTUAL_HEIGHT =  300

--background and ground images
local background = love.graphics.newImage('/assets/background.png')
local ground = love.graphics.newImage('/assets/ground.png')

-- Scroll offset
local backgroundScroll = 0
local groundScroll = 0

-- Scroll speeds
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 70

local BACKGROUND_LOOPING_POINT = 300
local GROUND_LOOPING_POINT = 43

function love.load(arg)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Flappy Bird!")

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true  
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key, scancode, isrepeat)
    -- escape
    if key == 'escape' then
        love.event.quit()
    end


end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % GROUND_LOOPING_POINT
end

function love.draw()
    push:start()

    -- Draw background
    love.graphics.draw(background, -backgroundScroll, -200)
    -- Draw ground
    love.graphics.draw(ground, -groundScroll-1, VIRTUAL_HEIGHT - 20)

    push:finish()
end
