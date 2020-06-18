Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAl_WIDTH
    self.y = math.random(VIRTUAl_HEIGHT / 2, VIRTUAl_HEIGHT - 10)

    self.width = PIPE_IMAGE:getWidth()   
end