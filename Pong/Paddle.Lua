Paddle = Class{}

function Paddle:init(allignment)
    self.width = 20 / Scaling
    self.height = 80 / Scaling
    self.y = WINDOW_HEIGHT / 2 - self.height / 2
    self.allignment = allignment
    if self.allignment == 'left' then
        self.x = 30
    elseif self.allignment == 'right' then
        self.x = WINDOW_WIDTH - (30 + self.height)
    else
        self.x = WINDOW_WIDTH / 2
    end
    self.dy = 0
end

function Paddle:reset()
    self.y = WINDOW_HEIGHT / 2 - self.height / 2
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0,self.y + self.dy * dt)
    else
        self.y = math.min(WINDOW_HEIGHT - self.height,self.y + self.dy * dt)
    end
end

function Paddle:render()
    self.width = 20 / Scaling
    self.height = 80 / Scaling
    if self.allignment == 'left' then
        self.x = 30
    elseif self.allignment == 'right' then
        self.x = WINDOW_WIDTH - (30 + self.height)
    else
        self.x = WINDOW_WIDTH / 2
    end
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height) -- Renders left paddle
end