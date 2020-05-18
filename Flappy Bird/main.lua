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


-- physical screen dimensions
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080



-- images we load into memory from files to later draw onto the screen
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

function love.load()
    -- app window title
    love.window.setTitle('Flappy Bird')

    -- initialize our virtual resolution
    love.window.setMode(0,0, {
        fullscreen = true,
        resizable = true,
        vsync = true
    })
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
end



function love.keypressed(key)
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
    --1/2 toggles player1/2.ai
end

function love.draw()
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, 0, 0)

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, 0, WINDOW_HEIGHT - 16)
    
end

function love.update()
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
end