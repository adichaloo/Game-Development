Ball=Class{}

function Ball:init(x,y,width,height)
    self.x=x
    self.y=y
    self.width=width
    self.height=height
    self.dx=math.random(-50,50)
    self.dy=math.random(-50,50)
end


function Ball:update(dt)
    self.y=self.y+self.dy*dt--updating the change in motion
    self.x=self.x+self.dx*dt
end

function Ball:collides(paddle)--collision conditions 
    if self.x>paddle.x+paddle.width or paddle.x>self.x+self.width then
        return false
    end
    if self.y>paddle.y+paddle.height or paddle.y>self.y+self.height then
        return false
    end
    return true
end

function Ball:reset()--reset the ball after every point
    self.x=VIRTUAL_WIDTH/2
    self.y=VIRTUAL_HEIGHT/2
    self.dx=math.random(-50,50)
    self.dy=math.random(-50,50)
end

function Ball:render()--ball design
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
end