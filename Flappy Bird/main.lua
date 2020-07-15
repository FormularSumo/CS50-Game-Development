--[[
    GD50
    Flappy Bird Remake

    Author: Formularsumo, based off Colton Ogden's version - cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple 
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping 
    the screen, making the player's bird avatar flap its wings and move upwards slightly. 
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]

-- virtual resolution handling library
push = require 'push'

-- classic OOP class library
Class = require 'class'

-- bird class from Bird.lua
require 'Bird'

-- Pipe.lua
require 'Pipe'

require 'PipePair'

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- images we load into memory from files to later draw onto the screen
local background = love.graphics.newImage('background.png')
local background_scroll = 0

local ground = love.graphics.newImage('ground.png')
local ground_scroll = 0

local BACKGROUND_SCROLL_SPEED = 20
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our ground back to X 0
local GROUND_LOOPING_POINT = 514

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

local pipePairs = {}

local spawn_timer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

local scrolling = true -- whether game is paused 

function love.load()
    -- app window title
    love.window.setTitle('Flappy Bird')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time()) --Randomises randomiser each time program is run. 

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 0, 0, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    --Escape exits fullscreen
    if key == 'escape' then
        love.window.setFullscreen(false)
        love.window.maximize()
    end
    --F11 toggles between fullscreen and maximised
    if key == 'f11' then
        if love.window.getFullscreen() == false then
            love.window.setFullscreen(true)
        else
            love.window.setFullscreen(false)
            love.window.maximize()
        end
    end
    --Space plays/pauses
    -- if key == 'space' then
    --     if gamestate == 'pause' or gamestate == 'serve' then
    --         gamestate = 'play'
    --     elseif gamestate == 'play' then
    --         gamestate = 'pause'
    --     else
    --         reset()
    --         gamestate = 'serve'
    --     end
    -- end
    --F5 exits program
    -- if key == 'f5' then 
    --     reset()
    -- end
end

function love.touchpressed()
    love.keyboard.keysPressed['space'] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] 
end


function love.update(dt)
    if scrolling then

        background_scroll = (background_scroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

        ground_scroll = (ground_scroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH % GROUND_LOOPING_POINT

        spawn_timer = spawn_timer + dt

        -- spawn a new PipePair if the timer is past 2 seconds
        if spawn_timer > 2 then
            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT))
            lastY = y
            
            table.insert(pipePairs, PipePair(y))
            spawn_timer = 0
        end

        bird:update(dt)

        for k, pair in pairs(pipePairs) do
            pair:update(dt)

            -- if pipe is no longer visible past left edge, remove it from scene
            if pair.x < -PIPE_WIDTH then
                pair.remove = true
            end
        end

        -- remove any flagged pipes
        -- we need this second loop, rather than deleting in the previous loop, because
        -- modifying the table in-place without explicit keys will result in skipping the
        -- next pipe, since all implicit keys (numerical indices) are automatically shifted
        -- down after a table removal
        for k, pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end
    end
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -background_scroll, 0)

    for k, pair in pairs(pipePairs) do
        pair:render()
    end
    -- draw the ground on top of the background, toward the bottom of the screen
    -- at its negative looping point
    love.graphics.draw(ground, -ground_scroll, VIRTUAL_HEIGHT - 16)
    
    bird:render()

    push:finish()
end