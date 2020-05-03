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




    --Runs when the game first starts up, only once; used to initialize the game.

function love.load()
    love.window.setMode(0, 0, {
        fullscreen = true,
        resizable = true,
        vsync = true
    })
    love.window.maximize()
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
    Current_window_width, Current_window_height = love.graphics.getDimensions()
    Scaling1 = 1080 / WINDOW_HEIGHT
    Scaling2 = 1920 / WINDOW_WIDTH
    Scaling = (Scaling1 + Scaling2) / 2
    Current_scaling = Scaling
    font50 = love.graphics.newFont(50)
    font80 = love.graphics.newFont(80)
    P1Score = 0
    P2Score = 0
    Paddle_width = 20 / Scaling
    Paddle_height = 80 / Scaling
    Paddle_speed = 450 / Scaling
    Ball_radius = 10 / Scaling
    P1Y = WINDOW_HEIGHT / 2 - Paddle_height / 2
    P2Y = WINDOW_HEIGHT / 2 - Paddle_height / 2
end


function love.update(dt)
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
    Scaling1 = 1080 / WINDOW_HEIGHT
    Scaling2 = 1920 / WINDOW_WIDTH
    Scaling = (Scaling1 + Scaling2) / 2
    --Controls paddel movement
    --dt stands for delta time and keeps this consistent across different frame rates
    if love.keyboard.isDown('w') then
        P1Y = math.max(0,P1Y - Paddle_speed * dt)
    elseif love.keyboard.isDown('s') then
        P1Y = math.min(WINDOW_HEIGHT - Paddle_height,P1Y + Paddle_speed * dt)
    end
    if love.keyboard.isDown('up') then
        P2Y = math.max(0,P2Y - Paddle_speed * dt)
    elseif love.keyboard.isDown('down') then
        P2Y = math.min(WINDOW_HEIGHT - Paddle_height,P2Y + Paddle_speed * dt)
    end

    if Current_window_width ~= WINDOW_WIDTH or Current_window_height ~= WINDOW_HEIGHT then
        Scaling_change = Scaling / Current_scaling
        Current_scaling = Scaling
        if Current_window_height ~= WINDOW_HEIGHT then
            P1Y = P1Y / Scaling_change
            P2Y = P2Y / Scaling_change
        end
        Paddle_width = 20 / Scaling
        Paddle_height = 80 / Scaling
        Paddle_speed = 450 / Scaling
        Ball_radius = 10 / Scaling
        Current_window_width = WINDOW_WIDTH
        Current_window_height = WINDOW_HEIGHT
    end  
    
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
            love.window.maximize()
        end
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
    love.graphics.rectangle('fill', 30, P1Y, Paddle_width, Paddle_height) -- Renders left paddle
    love.graphics.rectangle('fill', WINDOW_WIDTH - (30 + Paddle_width), P2Y, Paddle_width, Paddle_height) -- Renders right paddle
    love.graphics.circle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, Ball_radius) -- Renders pong ball
end