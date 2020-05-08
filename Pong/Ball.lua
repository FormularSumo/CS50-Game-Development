Ball = Class{}

function Ball:init(x, y, radius) -- Creates ball
    self.x = x
    self.y = y
    self.radius = radius
    self.original_radius = radius
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

function Ball:reset() -- Resets ball position and speed and randomises direction
    self.x = WINDOW_WIDTH / 2
    self.y = WINDOW_HEIGHT / 2
    self.dx = (Serving_player == 1 and 350 or -350) / Scaling
    self.dy = math.random(-300, 300) / Scaling
end

function Ball:collides(paddle)
    if self.x - self.radius / 2 > paddle.x + paddle.width or paddle.x > self.x + self.radius / 2 then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y - self.radius / 2 > paddle.y + paddle.height or paddle.y > self.y + self.radius / 2 then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Ball:update(dt) -- Updates ball postion
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render() -- Renders ball
    self.radius = self.original_radius / Scaling
    love.graphics.circle('fill', self.x, self.y, self.radius)
end