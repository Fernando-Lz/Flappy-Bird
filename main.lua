-- TODO
-- #1 update bird images to create the motion of flutter (dt/3) por las tres fases de aleteo
-- #2 be able to change bird color

-- Assets obtained from https://github.com/samuelcust/flappy-bird-assets
push = require "push"
Class = require "class"

require 'Bird'
require 'Pipe'

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

-- Looping Points
local BACKGROUND_LOOPING_POINT = 300
local GROUND_LOOPING_POINT = 43

-- Classes instantiation
local bird = Bird()
local pipes = {}

local spawnTimer = 0


function love.load(arg)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Flappy Bird!")

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true  
    })

    -- Table of keys pressed  is defined to be used outside main.lua
    love.keyboard.keysPressed = {}


end


function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] =  true
    -- escape
    if key == 'escape' then
        love.event.quit()
    end

end


function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.update(dt)
    -- Scroll background
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT
    -- Scroll ground
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % GROUND_LOOPING_POINT

    -- Update of spawnTimer
    spawnTimer = spawnTimer + dt

    -- How often a pipe is generated, is updated each two and half second
    if spawnTimer > 1.5 then
        table.insert(pipes, Pipe())
        spawnTimer = 0
    end

    bird:update(dt)

    for k, pipe in pairs(pipes) do
        pipe:update(dt)
    
        -- Makes the pipe disapear once traversed all the screen
        if pipe.x < -pipe.witdh then
            table.remove(pipes, k)
        end
    end

    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()
    --Simulate a draw layer by setting an order in which objects will be drawn
    -- Draw background
    love.graphics.draw(background, -backgroundScroll, -200)
    -- Draw pipes
    for k, pipe in pairs(pipes) do
        pipe:render()
    end
    -- Draw ground
    love.graphics.draw(ground, -groundScroll-1, VIRTUAL_HEIGHT - 20)
    -- Draw Bird
    bird:render()

    push:finish()
end
