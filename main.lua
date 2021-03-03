-- TODO
-- #2 be able to change bird color

-- Assets obtained from https://github.com/samuelcust/flappy-bird-assets
push = require "push"
Class = require "class"

require 'Bird'
require 'Pipe'
require 'PipePair'
local saveData = require("saveData")
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 534
VIRTUAL_HEIGHT =  300
GROUND_HEIGHT = VIRTUAL_HEIGHT - 45

--background and ground images
local background = love.graphics.newImage('/assets/background.png')
local ground = love.graphics.newImage('/assets/ground.png')

-- Scroll offset
local backgroundScroll = 0
local groundScroll = 0

-- Scroll speeds
local BACKGROUND_SCROLL_SPEED = 50
local GROUND_SCROLL_SPEED = 70

-- Looping Points
local BACKGROUND_LOOPING_POINT = 753
local GROUND_LOOPING_POINT = 120

-- Classes instantiation
local bird = Bird()
-- Table of spawning pipes
local pipePairs = {}

-- spawnTimer variable, in seconds
local spawnTimer = 0

-- Variable to keep continuity on the pipes path for the bird
local lastY = -PIPE_HEIGHT + math.random(80) + 20

score = 0
local bestScore = 0

local point = love.audio.newSource('/assets/audio/point.wav', 'stream')
local hit = love.audio.newSource('/assets/audio/hit.wav', 'stream')
local death = love.audio.newSource('/assets/audio/die.wav', 'stream')
-- Variable that changes when the bird collides with a pipe
--local aliveBird = true

gameState = 'start'

function love.load(arg)
    --saveData.save(t, "test.txt")
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Flappy Bird!")

    --Fonts
    bigFont = love.graphics.newFont('/assets/Flappy-Bird.ttf', 56)
    smallFont = love.graphics.newFont('/assets/Flappy-Bird.ttf', 34)
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

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end



function love.keypressed(key)
    love.keyboard.keysPressed[key] =  true
    -- escape
    if key == 'escape' then

        love.event.quit()

    -- Change states when the return key is pressed
    elseif key == 'enter' or key == 'return' then

    	if gameState == 'start' then
    		gameState = 'play'    	

    	elseif gameState == 'gameOver' then    		    	

    		gameState = 'leaderboard'
    	
    	-- Respawn Bird
    	elseif gameState == 'leaderboard' then

    		bird:init()

    		-- Reset score 
            score = 0

    		for k in pairs(pipePairs) do
			    pipePairs[k] = nil
			end

            gameState = 'start'
    	end
    	
    end
end


function love.update(dt)
    --if aliveBird then
    if gameState == 'start' or gameState == 'play' then
        -- Scroll background
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT
        -- Scroll ground
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % GROUND_LOOPING_POINT
    end

    -- Avoided using elseif, given that it wouldn't trigger until after the play stage.
    if gameState == 'play' then

        -- Update of spawnTimer
        spawnTimer = spawnTimer + dt
        -- How often a pipe is generated, is updated each two and half second
        if spawnTimer > 2 then
            --Can be changed for dificulties
            -- Sets the new pipes, no higher than 10 pixels below the top of the screen and no loweer than 90 pixels from the bottom
            -- Within the math random are the values of the shift of the next pipes, how high or low will be respect the previous one,
            local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-40, 40), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = y

            table.insert(pipePairs, PipePair(y))
            -- Reset spawnTimer
            spawnTimer = 0
        end

        bird:update(dt)
        
        -- Ground collision
        if bird.y >= GROUND_HEIGHT then
            --aliveBird = false
            love.audio.play(hit)
            love.audio.play(death)
            gameState = 'gameOver'
        end
        
        --  for each pipe pair
        for k, pair in pairs(pipePairs) do
            pair:update(dt)

            -- update score
            if pair.checked == false then

	            if bird.x > pair.x then
	            	score = score + 1
	            	love.audio.play(point)
	            	pair.checked = true
	            end
        	end

            --checks collision
            for i, pipe in pairs(pair.pipes) do
                if bird:collides(pipe) then
                    
                    -- check if new best score
                    if score > bestScore then
                    	bestScore = score
                    end

                    love.audio.play(hit)
                    love.audio.play(death)
                    
                    gameState = 'gameOver'
                end
            end
            
            -- Removes the pipe one it is not visible
            if pair.x < -PIPE_WIDTH then
                pair.remove = true
            end
        end

        for k, pair in pairs(pipePairs) do    
            -- Makes the pipe disapear once traversed all the screen
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end

    -- 
    elseif gameState == 'gameOver' then
    	
    	GRAVITY = 100
    	bird.y =  bird.y + GRAVITY * dt

    	--GROUND_HEIGHT = VIRTUAL_HEIGHT - 45
    	--[[pipe = Pipe()

    	if bird:collides(pipe) and bird.y >= pipe.height then
    		bird.y = pipe.height
    	else]]if bird.y >= GROUND_HEIGHT then
            bird.y = GROUND_HEIGHT
        end
    end
    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()
    --Simulate a draw layer by setting an order in which objects will be drawn
    
    if --[[gameState == 'start' or gameState == 'play' or gameState == 'gameOver']] gameState ~= 'leaderboard' then
	    -- Draw background
	    love.graphics.draw(background, -backgroundScroll, -200)
	    
	    -- Draw ground
	    love.graphics.draw(ground, -groundScroll-1, VIRTUAL_HEIGHT - 20)

	    -- Draw Bird
	    bird:render()
        if gameState == 'start' then
            love.graphics.setColor(0,0,0,1)
            love.graphics.setFont(bigFont)
            love.graphics.printf('Flappy Bird', 0, 18, VIRTUAL_WIDTH, 'center')
            love.graphics.setFont(smallFont)
            love.graphics.printf('Press enter to Start', 0, 60, VIRTUAL_WIDTH, 'center')

        end
	end

	if gameState == 'play' or gameState == 'gameOver' then	    	

	    -- Draw pipes
	    for k, pair in pairs(pipePairs) do
	        pair:render()
	    end

        -- Draw ground
	    love.graphics.draw(ground, -groundScroll-1, VIRTUAL_HEIGHT - 20)

	    -- Draw Bird front of the pipes
	    bird:render()

	    love.graphics.setColor(0,0,0,1)
	    love.graphics.print(score, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/4)
	end

	if gameState == 'leaderboard' then

		--love.graphics.rotate(math.pi/2)
		--bird:render()
		love.graphics.print('Score: ' ..score, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/4)
		love.graphics.print('Highscore: ' ..bestScore, VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/4 + 45)
	end     

    push:finish()
end