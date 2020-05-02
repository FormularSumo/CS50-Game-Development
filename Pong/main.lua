--[[
    GD50 2018
    Pong Remake

    pong-0
    "The Day-0 Update"

    -- Main Program --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
    the ball past your opponent's edge. First to 10 points wins.

    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on 
    modern systems.
]]



WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080
Paddle_width = 20
Paddle_height = 80

    --Runs when the game first starts up, only once; used to initialize the game.

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    love.window.maximize()
    font = love.graphics.newFont(50)
    love.graphics.setFont(font)
end



    --Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.

function love.draw()
    love.graphics.printf(
        'Pong',                 -- text to render
        0,                      -- starting X (0 as it's going to be centered based on WINDOW_WIDTH)
        40,                     -- starting Y
        WINDOW_WIDTH,           -- number of pixels to allign within
        'center')               -- alignment mode, can be 'center', 'left', or 'right'

    love.graphics.rectangle('fill', 30, 90, Paddle_width, Paddle_height) -- Renders left rectangle
    love.graphics.rectangle('fill', WINDOW_WIDTH - (30 + Paddle_width), WINDOW_HEIGHT - (90 + Paddle_height), Paddle_width, Paddle_height) -- Renders right rectangle
    love.graphics.circle('fill', WINDOW_WIDTH / 2 , WINDOW_HEIGHT / 2, 8) -- Renders pong ball rectangle

end


function love.keypressed(key)
    --If escape key is pressed exit fullscreen
    if key == 'escape' then
        love.window.setFullscreen(false)
    end
    --F11 toggles between fullscreen and maximised
    if key == 'f11' then
        if love.window.getFullscreen() == false then
            love.window.setFullscreen(true)
        else
            love.window.setFullscreen(false)
        end
    end
end

