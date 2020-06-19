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

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()

local pipes = {}

local spawn_timer = 0

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

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] 
end


function love.update(dt)
    background_scroll = (background_scroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    ground_scroll = (ground_scroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    spawn_timer = spawn_timer + dt

    if spawn_timer > 2 then
        table.insert(pipes, Pipe())
        spawn_timer = 0
    end

    bird:update(dt)

    for k, pipe in pairs(pipes) do
        pipe:update(dt)

        if pipe.x < 0 + pipe.x then
            table.remove(pipes, k)
        end
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -background_scroll, 0)

    for k, pipe in pairs(pipes) do 
        pipe:render()
    end
    -- draw the ground on top of the background, toward the bottom of the screen
    -- at its negative looping point
    love.graphics.draw(ground, -ground_scroll, VIRTUAL_HEIGHT - 16)
    
    bird:render()

    push:finish()
end