--adicionando a fisica
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed(os.time())

local score = 0

local gameLoopTimer
local scoreText


local rocket_name = 'power_force_one'

local backGroup = display.newGroup() 
local mainGroup = display.newGroup()

local sheetOptions =
{
    frames =
    {
        {   -- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) asteroid 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        {   -- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
    }, 
}

local objectSheet = graphics.newImageSheet( "image/gameObjects.png", sheetOptions )


local background = display.newImageRect( backGroup, "image/background3.jpg", 360, 800 )
background.x = display.contentCenterX
background.y = display.contentCenterY

transition.moveBy(background, {y=1000, time=500001})


rocket = display.newImageRect(mainGroup, "./image/power_force_one.png",60,60)
rocket.x = display.contentCenterX
rocket.y = display.contentHeight - 60

physics.addBody( rocket, { radius=30, isSensor=true } )
rocket.myName = rocket_name

scoreText = display.newText( "Score: " .. score, 240, 25, native.systemFont, 16 )

scoreText:setFillColor(0.180, 0.65, 0.35  )


local function updateText()
    scoreText.text = "Score: " .. score
end



local function dragRocket( event )
    
    local rocket = event.target
    local phase = event.phase


    --inicio do toque
    if ( "began" == phase ) then
        -- focar na nave
        display.currentStage:setFocus( rocket )
        rocket.touchOffsetX = event.x - rocket.x
        rocket.touchOffsetY = event.y - rocket.y
    elseif ( "moved" == phase ) then
        -- Move the rocket to the new touch position
        rocket.x = event.x - rocket.touchOffsetX
        rocket.y = event.y - rocket.touchOffsetY
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- deixar de focar
        display.currentStage:setFocus( nil )
    end
    
    return true
end


local asteroidTable = {}

local function createAsteroid()
    
    local newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 102, 10 )
    physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )
    newAsteroid.myName = "asteroid"

    
    newAsteroid:toBack()
    table.insert(asteroidTable, newAsteroid)
    physics.addBody(newAsteroid, 'dynamic', {isSensor = true})

    newAsteroid.x = math.random( display.contentWidth )
    newAsteroid.y = 5
    newAsteroid:setLinearVelocity( math.random( -30,20 ), math.random( 120,190 ) )
end

--sempre inicia com esse valor padrão
local positionRocket = display.contentCenterX
local contadorDeFluxo = 0

local function gameLoop()
    if (contadorDeFluxo % 10 == 0) then
        print('entrou')
        createAsteroid()
        score = score + 2
        updateText()
    end
    print(contadorDeFluxo % 10 == 0)
    contadorDeFluxo = contadorDeFluxo +1
    
    
    if (rocket.x > positionRocket) then
        rocket.rotation = 20
    elseif (rocket.x < positionRocket) then
        rocket.rotation = -20
    elseif (rocket.x == positionRocket) then
        rocket.rotation = 0
    end
    positionRocket = rocket.x
    
    --rocket:rotate(12)
    
end


local tempo = 100



gameLoopTimer = timer.performWithDelay( tempo, gameLoop, 0 )


rocket:addEventListener( "touch", dragRocket )