
PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    
    self.timer = self.timer + dt

    if self.timer > 2 then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 5, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 95 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))--insert the gap position in a table  

       
        self.timer = 0
    end


    for k,pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x+PIPE_WIDTH<self.bird.x then--scoring system
                self.score=self.score+1
                pair.scored=true
                sounds['score']:play()
            end
        end
        pair:update(dt)
    end
   
    for k, pair in pairs(self.pipePairs) do--after passing the screen remove from the table
        if pair.remove then
            table.remove(self.pipePairs,k)
        end
    end

    self.bird:update(dt)

    for k,pair in pairs(self.pipePairs) do--bird collision with pipes (AABB collision)
        for l,pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                gStateMachine:change('score',{
                    score=self.score
                })
            end
        end
    end

    if self.bird.y>VIRTUAL_HEIGHT-15 then--bird collision with the ground
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score',{
            score=self.score
        })
    end

end
            

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    love.graphics.setFont(flappyFont)
    love.graphics.print("Score:"..tostring(self.score),8,8)
    self.bird:render()
end