
 --Pong 
WINDOW_WIDTH=1300
WINDOW_HEIGHT=800

VIRTUAL_WIDTH=432
VIRTUAL_HEIGHT=243
--virtual resolution for decreasing the resolution giving it a more retro look 
PADDLE_SPEED=200

push=require "push"
Class=require "class"
require "Paddle"
require "Ball"

function love.load()--executed once in the start
    -- love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT,{
    --     fullscreen=false,
    --     resizable=false,
    --     vsync=true
    -- })
    math.randomseed(os.time())--seed
    love.graphics.setDefaultFilter("nearest","nearest")--nearest neighbor (no-interpolation technique)
    smallfont=love.graphics.newFont("font.ttf",8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scorefont=love.graphics.newFont("font.ttf",32)
    sounds={
        ["paddle_sound"]=love.audio.newSource("sounds/paddle_hit.wav","static"),
        ["score_sound"]=love.audio.newSource("sounds/score.wav","static"),
        ["wall_rebound"]=love.audio.newSource("sounds/wall_hit.wav","static")

    }--sounds

    love.graphics.setFont(smallfont)

    love.window.setTitle("Pong")--window title
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        resizable=false,
        vsync=true
    })
    player1=Paddle(10,30,5,20)--player 1 initialised
    player2=Paddle(VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-50,5,20)--player 2 initialised
    ball=Ball(VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT/2,4,4)--ball initialised
   
    player1score=0
    player2score=0
    servingplayer=1
    multiplayer=0
    winningplayer=1
    x=0
    gameState="start"
end

function love.update(dt)--update
    if gameState=="serve" then
        ball.dy=math.random(-50,50)-- y velocity
        if servingplayer==1 then
            ball.dx=math.random(140,200) --x velocity 
        elseif servingplayer==2 then
            ball.dx=-math.random(140,200)
        end
    elseif gameState=="play" then
        if ball:collides(player1) then --if collision occurs then inverse direction of velocity and rebound ahead of the width
            ball.dx=-ball.dx*1.03
            ball.x=player1.x+5

            if ball.dy<0 then--y velocity when collision occurs it will go in the same diection 
                ball.dy=-math.random(10,150)
            else
                ball.dy=math.random(10,150)
            end
            sounds["paddle_sound"]:play()
        end

        if ball:collides(player2) then
            ball.dx=-ball.dx*1.03
            ball.x=player2.x-5

            if ball.dy<0 then
                ball.dy=-math.random(10,150)
            else
                ball.dy=math.random(10,150)
            end
            sounds["paddle_sound"]:play()
        end

        if ball.y<=0 then--collision with upper wall
            ball.y=0
            ball.dy=-ball.dy
            sounds["wall_rebound"]:play()
        end

        if ball.y>=VIRTUAL_HEIGHT-4 then--collision with lower wall
            ball.y=VIRTUAL_HEIGHT-4
            ball.dy=-ball.dy
            sounds["wall_rebound"]:play()
        end
        
        if ball.x<0 then-- if the ball is  past the first player then player2 scores and player 1 serves
            sounds["score_sound"]:play()
            servingplayer=1
            player2score=player2score+1
            
            if player2score==10 then--condition for winning the match for player 2
                winningplayer=2
                gameState="Done"
            else
                ball:reset()--reset the ball to the center 
                gameState="serve"--change gamestate to serve
            end
        end
        if ball.x>VIRTUAL_WIDTH then--if the  ball is past the second player
            sounds["score_sound"]:play()
            servingplayer=2--player 2 serves
            player1score=player1score+1
            if player1score==10 then--condition for winning the match for player 1
                winningplayer=1
                gameState="Done"
            else
                ball:reset()
                gameState="serve"
            end
        end
    end

    --player 1 is comp
    if gameState=="play" and multiplayer==0 then --if against bot
        
        player1.y=ball.y-10
        if ball.dy<0 then 
            player1.dy=-PADDLE_SPEED
        else
            player1.dy=PADDLE_SPEED
        end
        

    elseif gameState=="start" or gameState=="serve" or gameState=="play" or gameState=="Done" and multiplayer==1 then --if multiplayer

        if love.keyboard.isDown('w') then 
            player1.dy=-PADDLE_SPEED--decreases value as its the up button for every dt time
        elseif love.keyboard.isDown('s') then
            player1.dy=PADDLE_SPEED--increases value as its the down button for every dt time
        else
            player1.dy=0
        end
    end


    if love.keyboard.isDown('up') then
        player2.dy=-PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy=PADDLE_SPEED
    else
        player2.dy=0
    end
    if gameState=="play" then
        ball:update(dt)
    end
    player1:update(dt)
    player2:update(dt)
end


function love.keypressed(key)
    if key=="escape" then
        love.event.quit()

    elseif gameState=="option" then
        if key=="1" then
            multiplayer=0
        elseif key=="2" then
            multiplayer=1
        end
        gameState="serve"
    
    
    elseif key=="enter" or key == 'return' then
        
        if gameState=="start" then
            if x==1 then 
                gameState="serve"
            else
                gameState="option"
                x=1
            end

        
        elseif gameState=="serve" then
            gameState="play"
        elseif gameState=="Done" then
            gameState="option"
            ball:reset()

            player1score=0
            player2score=0

            if winningplayer==1 then
                servingplayer=2
            else
                servingplayer=1
            end
        end
    end
end

function love.draw()

    --render the update
    push:apply("start")
    love.graphics.clear(40/255,45/255,52/255,255/255)

    
    if gameState=="start" then 
        love.graphics.setFont(smallfont)
        love.graphics.printf("Welcome to Pong!",0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to begin",0,20,VIRTUAL_WIDTH,"center")

    elseif gameState=="option"then
        love.graphics.setFont(smallfont)
        --love.graphics.printf("Player"..tostring(servingplayer).."'s serve!",0,10,VIRTUAL_WIDTH,"center")
        love.graphics.printf("Press 1 for AI Bot",0,10,VIRTUAL_WIDTH,"center")
        love.graphics.printf("Press 2 for Multiplayer",0,30,VIRTUAL_WIDTH,"center")

    elseif gameState=="serve"then
        love.graphics.setFont(smallfont)
        love.graphics.printf("Press Enter to serve",0,20,VIRTUAL_WIDTH,"center")

    elseif gameState=="play" then
        love.graphics.printf("Lets Play Pong!",0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState=="Done" then
        love.graphics.setFont(largeFont)
        love.graphics.printf("Player"..tostring(winningplayer).." wins!",0,10,VIRTUAL_WIDTH,"center")
        love.graphics.setFont(smallfont)
        love.graphics.printf("Press Enter to Restart!",0,30,VIRTUAL_WIDTH,"center")

    end
    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(player1score),VIRTUAL_WIDTH/2-60,VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2score),VIRTUAL_WIDTH/2+50,VIRTUAL_HEIGHT/3)
    --love.graphics.rectangle("fill",10,player1Y,5,20)--left paddle
    -- love.graphics.rectangle("fill",VIRTUAL_WIDTH-10,player2Y,5,20)--right paddle
    -- love.graphics.rectangle("fill",ballX,ballY,4,4)--ball
    player1:render()
    player2:render()
    ball:render()
    displayFPS()
    love.graphics.setFont(smallfont)
    love.graphics.setColor(255,255,255,255)
    love.graphics.line(VIRTUAL_WIDTH/2,0,VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT)
    love.graphics.line(0,0,VIRTUAL_WIDTH,0)
    love.graphics.line(0,VIRTUAL_HEIGHT,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
    push:apply("end")
end

function displayFPS()
    love.graphics.setFont(smallfont)
    love.graphics.setColor(0,255,0,255)
    love.graphics.print("FPS:"..tostring(love.timer.getFPS()),10,10)
end
