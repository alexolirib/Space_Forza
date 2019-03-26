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

local borderLeft = display.newRect( 1, 0, 41.5, 1000 )

local borderRight = display.newRect( 1, 0, 1, 1000)

borderRight.x = 298
borderLeft:setFillColor(0,0,0)
borderRight:setFillColor(0,0,0)

physics.addBody(borderLeft, "static")
physics.addBody(borderRight, "static")

local objectSheet = graphics.newImageSheet( "image/gameObjects.png", sheetOptions )


local background = display.newImageRect( backGroup, "image/background3.jpg", 360, 580 )
background.x = display.contentCenterX
background.y = display.contentCenterY

transition.moveBy(background, {y=800, time=500001})


rocket = display.newImageRect(mainGroup, "./image/power_force_one.png",60,60)
rocket.x = display.contentCenterX
rocket.y = display.contentHeight - 60

rocket.touchOffsetX = 0
rocket.touchOffsetY = 0

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
        if (rocket.x > 270) then
            rocket.x = 270
        elseif (rocket.x < 49.5) then
            rocket.x = 49.5
        end
        rocket.y = event.y - rocket.touchOffsetY
        if (rocket.y > 468) then
            rocket.y = 468
        elseif (rocket.y < 33) then
            rocket.y = 33
        end
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- deixar de focar
        display.currentStage:setFocus( nil )
    end
    
    return true
end


local asteroidTable = {}
local velocidadeDoFluxo = 10
--sempre inicia com esse valor padrão
local positionRocket = display.contentCenterX
local contadorDeFluxo = 0

local function createAsteroid()
    
    local newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 102, 10 )
    physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )
    newAsteroid.myName = "asteroid"

    
    newAsteroid:toBack()
    table.insert(asteroidTable, newAsteroid)
    physics.addBody(newAsteroid, 'dynamic', {isSensor = true})
    newAsteroid.x = math.random( 70,250)
    newAsteroid.y = 0
    
    if (velocidadeDoFluxo == 10) then
        newAsteroid:setLinearVelocity( math.random( -10,12), math.random( 80,115 ) )
    elseif (velocidadeDoFluxo == 9) then
        newAsteroid:setLinearVelocity( math.random( -15,20 ), math.random( 95,142 ) )
    elseif (velocidadeDoFluxo == 8) then
        newAsteroid:setLinearVelocity( math.random( -22,21 ), math.random( 110,167 ) )
    elseif (velocidadeDoFluxo == 7) then
        newAsteroid:setLinearVelocity( math.random( -24,22), math.random( 125,195 ) )
    elseif (velocidadeDoFluxo == 6) then
        newAsteroid:setLinearVelocity( math.random( -24,22 ), math.random( 135,210 ) )
    else
        newAsteroid:setLinearVelocity( math.random( -25,23 ), math.random( 145,230 ) )
    end
end




local function gameLoop()
    if (score == 8 or score == 18 or score == 44 or score == 80 or score == 130) then
        score = score + 2
        velocidadeDoFluxo = velocidadeDoFluxo - 1
    end

    if (contadorDeFluxo % velocidadeDoFluxo == 0) then
        createAsteroid()
        score = score + 2
        updateText()
    end
    contadorDeFluxo = contadorDeFluxo +1

    
    
    if (rocket.x > positionRocket) then
        rocket.rotation = 23
    elseif (rocket.x < positionRocket) then
        rocket.rotation = -23
    elseif (rocket.x == positionRocket) then
        rocket.rotation = 0
    end
    positionRocket = rocket.x
    print(rocket.y)

    --rocket:rotate(12)
    
end


local tempo = 100



gameLoopTimer = timer.performWithDelay( tempo, gameLoop, 0 )


rocket:addEventListener( "touch", dragRocket )
