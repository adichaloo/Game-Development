PipePair=Class{}

GAP_HEIGHT=95
-- local PIPE_SPEED
function PipePair:init(y)
    self.y=y
    self.x=VIRTUAL_WIDTH
    self.pipes={["upper"]=Pipe("top",self.y),--initialise bottom and top pipe position
["lower"]=Pipe("bottom",self.y+PIPE_HEIGHT+GAP_HEIGHT)}
    self.remove=false
end

function PipePair:update(dt)
    if self.x>-PIPE_WIDTH then
        self.x=self.x-PIPE_SPEED*dt
        self.pipes["upper"].x=self.x--move the upper and lower pipes to the left by self.x
        self.pipes["lower"].x=self.x
    else
        self.remove=true
    end
end

function PipePair:render()
    for k,pair in pairs(self.pipes) do--render both the upper and lower pipes
        pair:render()
    end
end