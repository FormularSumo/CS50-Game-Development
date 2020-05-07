--[[
    GD50 Computer Science
    Pong Remake


    -- Main Program --

    Author: Formularsumo, based off Colton Ogden's version - cogden@cs50.harvard.edu

    Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
    the ball past your opponent's edge. First to 10 points wins.

    
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
    Serving_player = math.random(1,2)
    ball:reset()
    gamestate = 'serve'
end
    --Runs when the game first starts up, only once; used to initialize the game.

function love.load()
    love.window.setTitle('Pong')
    love.window.setMode(0, 0, {
        fullscreen = true,
        resizable = true,
        vsync = true
    })
    love.window.maximize()
    math.randomseed(os.time()) --Not sure what this is used for, not needed
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

    if gamestate == 'play' or gamestate == 'serve' then
        if ball:collides(player1) then
            ball.dx = ball.dx * -1.03 --Reverses x velocity, increasing it slightly
            ball.x = player1.x + player1.width + ball.radius / 2--Makes sure ball is not collding with paddle after it changes direction

            if ball.dy < 0 then
                ball.dy = math.random(30,400)
            else
                ball.dy = -math.random(30,400)
            end
        end

        if ball:collides(player2) then
            ball.dx = ball.dx * -1.05
            ball.x = player2.x - ball.radius / 2

            if ball.dy < 0 then
                ball.dy = math.random(10,150)
            else
                ball.dy = -math.random(10,150)
            end
        end

        --Invert Y and speed up X if touching ceiling or ground
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            ball.dx = ball.dx * 1.03
        end

        if ball.y >= WINDOW_HEIGHT - ball.radius / 2 then
            ball.y = WINDOW_HEIGHT - ball.radius / 2
            ball.dy = -ball.dy
            ball.dx = ball.dx * 1.03
        end

        --Controls paddel movement
        --dt stands for delta time and keeps movement consistent across different frame rates
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
        player1:update(dt)
        player2:update(dt)
    end

    if gamestate == 'play' then
        ball:update(dt)
    end

    --If offscreen change points and reset ball location
    if ball.x + ball.radius / 2 < 0 then
        P2Score = P2Score + 1
        if P2Score == 5 then
            winner = 2
            gamestate = 'done'
            ball:reset()
        else
            Serving_player = 1
            gamestate = 'serve'
            ball:reset()
        end
    end

    if ball.x - ball.radius / 2 > WINDOW_WIDTH then
        P1Score = P1Score + 1
        if P1Score == 5 then
            winner = 1
            gamestate = 'done'
            ball:reset()
        else
            Serving_player = 2
            gamestate = 'serve'
            ball:reset()
        end
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
        ball.dx = ball.dx / Scaling_change
        ball.dy = ball.dy / Scaling_change
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
        if gamestate == 'pause' or gamestate == 'serve' then
            gamestate = 'play'
        elseif gamestate == 'play' then
            gamestate = 'pause'
        else
            reset()
            gamestate = 'play'
        end
    end
    --F5 exits program
    if key == 'f5' then 
        reset()
    end
end


--Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.

function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(font50)
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
    elseif gamestate == 'serve' then
        love.graphics.printf('Player ' .. tostring(Serving_player) .. "'s serve",0,WINDOW_HEIGHT / 2 + 20 * Scaling1,WINDOW_WIDTH ,'center')
    elseif gamestate == 'done' then
        love.graphics.printf('Player ' .. tostring(winner) .. " has won",0,WINDOW_HEIGHT / 2 + 20 * Scaling1,WINDOW_WIDTH ,'center')
    end
    love.graphics.setFont(font50)

    if gamestate == 'pause' or gamestate == 'serve' then
        love.graphics.printf('Press space to play/pause',0,WINDOW_HEIGHT / 2 + 130,WINDOW_WIDTH ,'center')
        love.graphics.printf('Press F5 to reset',0,WINDOW_HEIGHT / 2 + 200,WINDOW_WIDTH ,'center')
    end

    if gamestate == 'done' then
        love.graphics.printf('Press space to play again',0,WINDOW_HEIGHT / 2 + 130,WINDOW_WIDTH ,'center')
    end

    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print(gamestate,50,50)
    --love.graphics.print(player2.y,50,50)

end