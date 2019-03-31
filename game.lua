--adicionando a fisica
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed(os.time())

local score = 0

local life = 3

local gameLoopTimer
local scoreText
local barra_vida = nil


local backGroup = display.newGroup()
local mainGroup = display.newGroup()

nome_image={
    rocket = "power_force_one",
    asteroid = 'asteroid',
    recover_life = 'recover_life'

}

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
background.xScale = 1.0
background.yScale = 1.0

local background2 = display.newImageRect( backGroup, "image/background3.jpg", 360, 580 )
background2.x = display.contentCenterX
background2.y = -display.contentCenterY
background2.xScale = 1.0
background2.yScale = 1.0

local scrollSpeed = 3
print(display.contentCenterY)

heightScreen =background.contentHeight
local function move( event )
    -- print(background.y)
   background.y = background.y + scrollSpeed
     background2.y = background2.y + scrollSpeed
    -- print(background2.y)
    --if ( fun ) then
        --local tDelta = event.time - tPrevious
        if ( background.y - heightScreen / 2 > heightScreen ) then
            background:translate( 0, -background.contentHeight * 2 )
        end
        if ( background2.y - heightScreen / 2 > heightScreen ) then
            background2:translate( 0, -background2.contentHeight * 2 )
        end
    --end
    -- background:translate( 0, -10 )
end


 timer.performWithDelay(20, move, 0)
-- move()
-- background2:translate( 0, 100 )

-- background:translate( 0, -background.contentHeight * 2 )




rocket = display.newImageRect(mainGroup, "./image/power_force_one.png",60,60)
rocket.x = display.contentCenterX
rocket.y = display.contentHeight - 60
rocket.isBodyActive = true
rocket.touchOffsetX = 0
rocket.touchOffsetY = 0

physics.addBody( rocket, 'dynamic', { radius=30, isSensor=true } )
rocket.myName = nome_image.rocket

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
        elseif (rocket.y < 68) then
            rocket.y = 68
        end
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- deixar de focar
        display.currentStage:setFocus( nil )
    end

    return true
end


local asteroidTable = {}
local recover_lifeTable = {}
local velocidadeDoFluxo = 10
--sempre inicia com esse valor padrão
local positionRocket = display.contentCenterX
local contadorDeFluxo = 0

local function createRecovers_life()
    local newRecovers_life = display.newImageRect( mainGroup, "./image/recovers_life.png", 30, 50 )
    table.insert(recover_lifeTable, newRecovers_life)
    physics.addBody( newRecovers_life, "dynamic", { radius=30, bounce=0.8 } )
    newRecovers_life.myName = nome_image.recover_life
    newRecovers_life:setLinearVelocity( math.random( -25,23 ), 300 )
    newRecovers_life.x = math.random( 70,250)
    newRecovers_life.y = 0
end


local function createAsteroid()

    local newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 40, 60 )
    table.insert(asteroidTable, newAsteroid)
    physics.addBody( newAsteroid, "dynamic", { radius=30, bounce=0.8 } )
    newAsteroid.myName = nome_image.asteroid
    newAsteroid:applyTorque( math.random( -2,3 ) )


    newAsteroid:toBack()
    --physics.addBody(newAsteroid, 'dynamic', {isSensor = true})
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

local function verificarVida()

    if (life ==3) then
        display.remove(barra_vida)
        barra_vida = display.newImageRect(mainGroup, "./image/green_life_bar.png",120,25)
        barra_vida.x = 90
        barra_vida.y = 25
    elseif(life ==2) then
        display.remove(barra_vida)
        barra_vida = display.newImageRect(mainGroup, "./image/yellow_life_bar.png",80,25)
        barra_vida.x = 70
        barra_vida.y = 25

    elseif(life == 1) then        
        display.remove(barra_vida)
        barra_vida = display.newImageRect(mainGroup, "./image/red_life_bar.png",40,25)
        barra_vida.x = 50
        barra_vida.y = 25

    else
        
        display.remove(barra_vida)
        
    end
end
verificarVida()

local function gameLoop()
    -- print(rocket.y)
    if (score == 8 or score == 18 or score == 44 or score == 80 or score == 130) then
        score = score + 2
        velocidadeDoFluxo = velocidadeDoFluxo - 1
        scrollSpeed = scrollSpeed + 0.5
    end

    if (contadorDeFluxo % velocidadeDoFluxo == 0) then
        createAsteroid()
        score = score + 2
        updateText()
        if ( math.random( -20,100 ) > 90) then
            createRecovers_life()
        end
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
    -- print(rocket.y)

    --rocket:rotate(12)

end


local tempo = 100



gameLoopTimer = timer.performWithDelay( tempo, gameLoop, 0 )


rocket:addEventListener( "touch", dragRocket )


local function onCollision( event )

    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == nome_image.rocket and obj2.myName == nome_image.asteroid ) or
             ( obj1.myName == nome_image.asteroid and obj2.myName == nome_image.rocket ) )
        then
            
            --obj2 sempre será o rocket
            if (( obj1.myName == nome_image.asteroid and obj2.myName == nome_image.rocket ))
            then
                obj1 = obj1
                obj2 = obj2
            else
                local obj = obj2
                obj2 = obj1
                obj1 = obj
            end

            for i = #asteroidTable, 1, -1 do
                if ( asteroidTable[i] == obj1) then
                    table.remove( asteroidTable, i )
                    display.remove(obj1)
                    break
                end
            end

            life = life - 1
            
        elseif (( obj1.myName == nome_image.asteroid and obj2.myName == nome_image.recover_life ) or
        ( obj1.myName == nome_image.recover_life and obj2.myName == nome_image.asteroid )) then

        --asteroid será sempre obj1
        if (( obj1.myName == nome_image.asteroid and obj2.myName== nome_image.recover_life )) then
                obj1 = obj1
                obj2 = obj2
            else
                local obj = obj2
                obj2 = obj1
                obj1 = obj
            end
            for i = #asteroidTable, 1, -1 do
                if ( asteroidTable[i] == obj1) then
                    table.remove( asteroidTable, i )
                    display.remove(obj1)
                    break
                end
            end
        elseif (( obj1.myName == nome_image.rocket and obj2.myName == nome_image.recover_life ) or
        ( obj1.myName == nome_image.recover_life and obj2.myName == nome_image.rocket )) then

        --asteroid será sempre obj1
        if (( obj1.myName == nome_image.rocket and obj2.myName== nome_image.recover_life )) then
                obj1 = obj1
                obj2 = obj2
            else
                local obj = obj2
                obj2 = obj1
                obj1 = obj
            end
            for i = #recover_lifeTable, 1, -1 do
                if ( recover_lifeTable[i] == obj2) then
                    table.remove( recover_lifeTable, i )
                    display.remove(obj2)
                    break
                end
            end

            if (life < 3) then
                life = life +1
            end
        end
        verificarVida()
    end

end
Runtime:addEventListener( "collision", onCollision )