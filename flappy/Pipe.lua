Pipe=Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')


function Pipe:init(orientation,y)
    self.x=VIRTUAL_WIDTH
    self.y=y
    self.orientation=orientation
    -- self.y=math.random(VIRTUAL_HEIGHT/4,VIRTUAL_HEIGHT-10)
    self.width=PIPE_IMAGE:getWidth()
    self.height=PIPE_HEIGHT
end

function Pipe:update(dt)
    --self.x=self.x+pipe_scroll*dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE,self.x,
    (self.orientation=="top" and self.y+PIPE_HEIGHT or self.y),--position on y axis
    0,--rotation
    1,--X scale
    self.orientation=="top" and -1 or 1)--Y scale
end