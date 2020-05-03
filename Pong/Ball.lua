Ball = Class{}

function Ball:init(x, y, radius) -- Creates ball
    self.x = x
    self.y = y
    self.radius = radius
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

function Ball:reset() -- Resets ball position and speed and randomises direction
    self.x = WINDOW_WIDTH / 2
    self.y = WINDOW_HEIGHT / 2
    self.dx = math.random(2) == 1 and 350 or -350
    self.dy = math.random(-300, 300)
end

function Ball:update(dt) -- Updates ball postion
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render() -- Renders ball
    love.graphics.circle('fill', self.x, self.y, self.radius)
end