--[[
    GD50 2018
    Pong Remake


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
    
    The "Class" library that's being used allows us to represent anything in
    our game as code, rather than keeping track of many disparate variables and
    methods
    https://github.com/vrld/hump/blob/master/class.lua
]]

Class = require 'class'

require 'Ball'

require 'Paddle'

function reset()
    P1Score = 0
    P2Score = 0
    Paddle_speed = 450 / Scaling
    ball:reset()
    gamestate = 'pause'
end
    --Runs when the game first starts up, only once; used to initialize the game.

function love.load()
    love.window.setMode(0, 0, {
        fullscreen = true,
        resizable = true,
        vsync = true
    })
    love.window.maximize()
    math.randomseed(os.time())
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
    Current_window_width, Current_window_height = love.graphics.getDimensions()
    Scaling1 = 1080 / WINDOW_HEIGHT
    Scaling2 = 1920 / WINDOW_WIDTH
    Scaling = (Scaling1 + Scaling2) / 2
    Current_scaling = Scaling
    font50 = love.graphics.newFont(50)
    font80 = love.graphics.newFont(80)
    ball = Ball(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 10 / Scaling)
    player1 = Paddle('left')
    player2 = Paddle('right')
    reset()
end


function love.update(dt)
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
    Scaling1 = 1080 / WINDOW_HEIGHT
    Scaling2 = 1920 / WINDOW_WIDTH
    Scaling = (Scaling1 + Scaling2) / 2
    --Controls paddel movement
    --dt stands for delta time and keeps this consistent across different frame rates
    if gamestate == 'play' then
        if love.keyboard.isDown('w') then
            player1.dy = - Paddle_speed
        elseif love.keyboard.isDown('s') then
            player1.dy = Paddle_speed
        else 
            player1.dy = 0
        end

        if love.keyboard.isDown('up') then
            player2.dy = - Paddle_speed
        elseif love.keyboard.isDown('down') then
            player2.dy = Paddle_speed
        else 
            player2.dy = 0
        end
        ball:update(dt)
        player1:update(dt)
        player2:update(dt)
    end

    if Current_window_width ~= WINDOW_WIDTH or Current_window_height ~= WINDOW_HEIGHT then
        Scaling_change = Scaling / Current_scaling
        Current_scaling = Scaling
        if Current_window_height ~= WINDOW_HEIGHT then
            player1.y = player1.y / Scaling_change
            player2.y = player2.y / Scaling_change
        end
        ball.x = ball.x / Scaling_change
        ball.y = ball.y / Scaling_change
        Paddle_speed = 450 / Scaling
        ball.radius = 10 / Scaling
        Current_window_width = WINDOW_WIDTH
        Current_window_height = WINDOW_HEIGHT
    end  
    
end



function love.keypressed(key)
    --Escape exits fullscreen
    if key == 'escape' then
        love.window.setFullscreen(false)
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
    if key == 'space' then
        if gamestate == 'pause' then
            gamestate = 'play'
        else
            gamestate = 'pause'
        end
    end
    --F5 exits program
    if key == 'f5' then 
        reset()
    end
end


--Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.

function love.draw()
    love.graphics.setFont(font50)
    --love.graphics.printf(WINDOW_WIDTH .. ' x '.. WINDOW_HEIGHT,0,WINDOW_HEIGHT / 2 - 25,WINDOW_WIDTH,'center')
    --love.graphics.printf(Scaling,0,WINDOW_HEIGHT / 1.5 - 25,WINDOW_WIDTH,'center')
    love.graphics.printf(
        'Pong',                 -- text to render
        0,                      -- starting X (0 as it's going to be centered based on WINDOW_WIDTH)
        40,                     -- starting Y
        WINDOW_WIDTH,           -- number of pixels to allign within
        'center')               -- alignment mode, can be 'center', 'left', or 'right'
    
    love.graphics.setFont(font80)
    love.graphics.printf(P1Score,-400 / Scaling2,25,WINDOW_WIDTH,'center')
    love.graphics.printf(P2Score,400 / Scaling2,25,WINDOW_WIDTH,'center')
    player1:render()
    player2:render()
    ball:render()
    if gamestate == 'pause' then
        love.graphics.printf('Paused',0,WINDOW_HEIGHT / 2 + 20 * Scaling1,WINDOW_WIDTH ,'center')
        love.graphics.setFont(font50)
        love.graphics.printf('Press space to pause/unpause',0,WINDOW_HEIGHT / 2 + 130,WINDOW_WIDTH ,'center')
        love.graphics.printf('Press F5 to reset game',0,WINDOW_HEIGHT / 2 + 200,WINDOW_WIDTH ,'center')
    end
end