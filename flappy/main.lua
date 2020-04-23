
WINDOW_HEIGHT=720
WINDOW_WIDTH=1280

VIRTUAL_WIDTH=512
VIRTUAL_HEIGHT=288
push=require 'push'
Class=require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountdownState'


local background=love.graphics.newImage("background.png")
local backgroundScroll=0
local ground=love.graphics.newImage("ground.png")
local groundScroll=0

local background_scroll_speed=30
local ground_scroll_spreed=60

local background_looping_point=413


--local pipe=Pipe()

count=0

function love.load()

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)


    love.graphics.setDefaultFilter('nearest','nearest')
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        resizable=true,
        vsync=true
    })
    
    math.randomseed(os.time())
    love.window.setTitle("Flappy Birds")
    gStateMachine=StateMachine{--StateMachine Initialised
        ['title']=function() return TitleScreenState() end,
        ['play']=function() return PlayState() end,
        ['score']=function() return ScoreState() end,
    ['countdown']=function() return CountdownState() end}
    

    sounds={
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }
    gStateMachine:change('title')
    sounds['music']:setLooping(true)
    sounds['music']:play()
    love.keyboard.keysPressed={}--buffer for keys pressed
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key]=true

    if key=="escape" then
        love.event.quit()
    end
  
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    
    backgroundScroll=(backgroundScroll+background_scroll_speed*dt)%background_looping_point
    groundScroll=(groundScroll+ground_scroll_spreed*dt)%VIRTUAL_WIDTH--scroll of ground an dhills continuous(Parallax update)
    gStateMachine:update(dt)
    love.keyboard.keysPressed={}

end

function love.draw()
    push:start()
    
    love.graphics.draw(background,-backgroundScroll,0)
    gStateMachine:render()
    love.graphics.draw(ground,-groundScroll,VIRTUAL_HEIGHT-16)
    
    push:finish()

end