Paddle = Class{}

function Paddle:init(allignment)
    self.ai = 'human'
    self.width = 20 / Scaling
    self.height = 80 / Scaling
    self.y = WINDOW_HEIGHT / 2 - self.height / 2
    self.allignment = allignment
    if self.allignment == 'left' then
        self.x = 30
    elseif self.allignment == 'right' then
        self.x = WINDOW_WIDTH - (30 + self.width)
    else
        self.x = WINDOW_WIDTH / 2
    end
    self.dy = 0
end

function Paddle:reset()
    self.y = WINDOW_HEIGHT / 2 - self.height / 2
end

function Paddle:update(dt)
    --Controls paddel movement
    --dt stands for delta time and keeps movement consistent across different frame rates
    if gamestate == 'play' then
        if self.ai == 'ai' then
            if ball.y < self.y + self.height / 2 then
                self.movement = 'up'
            elseif ball.y > self.y + self.height / 2 then
                self.movement = 'down'
            else
                self.movement = 'none'
            end
        else
            if love.keyboard.isDown('w') and self.allignment == 'left' or love.keyboard.isDown('up') and self.allignment == 'right' then
                self.movement = 'up'
            elseif love.keyboard.isDown('s') and self.allignment == 'left' or love.keyboard.isDown('down') and self.allignment == 'right' then
                self.movement = 'down'
            else 
                self.movement = 'none'
            end
        end
    else
        self.movement = 'none'
    end



    if self.movement == 'up' then
        self.y = math.max(0,self.y - Paddle_speed * dt)
    elseif self.movement == 'down' then
        self.y = math.min(WINDOW_HEIGHT - self.height,self.y + Paddle_speed * dt)    
    end
end

function Paddle:render()
    self.width = 20 / Scaling
    self.height = 80 / Scaling
    if self.allignment == 'left' then
        self.x = 30
    elseif self.allignment == 'right' then
        self.x = WINDOW_WIDTH - (30 + self.width)
    else
        self.x = WINDOW_WIDTH / 2
    end
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height) -- Renders left paddle
end