local composer = require("composer")
local jslib = require('src.joystick')
local scene = composer.newScene()
local js

--adicionando a fisica
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
local score = 0

local life = 3

local planet
local planet2

local background
local background2


local gameLoopTimer
local jsLoop
local scoreText
local barra_vida = nil


local backGroup = display.newGroup()
local mainGroup = display.newGroup()

nome_image={
    rocket = "power_force_one",
    asteroid = 'asteroid',
    recover_life = 'recover_life'

}



local borderLeft = display.newRect( 1, 0, 41.5, 1000 )

local borderRight = display.newRect( 1, 0, 1, 1000)

borderRight.x = 298
borderLeft:setFillColor(0,0,0)
borderRight:setFillColor(0,0,0)

physics.addBody(borderLeft, "static")
physics.addBody(borderRight, "static")

local scrollSpeed = 3

heightScreen =display.contentHeight
local function move_loop( event )
   background.y = background.y + scrollSpeed
     background2.y = background2.y + scrollSpeed
        if ( background.y - heightScreen / 2 > heightScreen ) then
            background:translate( 0, -background.contentHeight * 2 )
        end
        if ( background2.y - heightScreen / 2 > heightScreen ) then
            background2:translate( 0, -background2.contentHeight * 2 )
        end
end

scrollSpeed_planet = 0.2
local function move_loop_planet( event )
    planet.y = planet.y + scrollSpeed_planet
    planet2.y = planet2.y + scrollSpeed_planet
         if ( planet.y - heightScreen / 2 > heightScreen ) then
            planet:translate( 0, -background.contentHeight * 2 )
         end
         if ( planet2.y - heightScreen / 2 > heightScreen ) then
            planet2:translate( 0, -background.contentHeight * 2 )
         end
 end

local function updateText()
    scoreText.text = "Score: " .. score
end



local function dragRocket( event )

    local rocket = event.target
    local phase = event.phase

    if ( "began" == phase ) then
        display.currentStage:setFocus( rocket )

        rocket.touchOffsetX = event.x - rocket.x
        rocket.touchOffsetY = event.y - rocket.y
    elseif ( "moved" == phase ) then

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


local function endGame()
    composer.setVariable('finalScore', score)
    composer.gotoScene( "src.end_game", { time=250, effect="fade" } )
end

local asteroidTable = {}
local recover_lifeTable = {}
local velocidadeDoFluxo = 10
local positionRocket = display.contentCenterX
local contadorDeFluxo = 0

local function createRecovers_life()
    local newRecovers_life = display.newImageRect( mainGroup, "resources/image/recovers_life.png", 30, 50 )
    table.insert(recover_lifeTable, newRecovers_life)
    physics.addBody( newRecovers_life, "dynamic", { radius=30, bounce=0.8 } )
    newRecovers_life.myName = nome_image.recover_life
    newRecovers_life:setLinearVelocity( math.random( -25,23 ), 300 )
    newRecovers_life.x = math.random( 70,250)
    newRecovers_life.y = 0
end


local function createAsteroid()

    local newAsteroid
    local choose_asteroid = math.random(0,100)    
    local size = math.random(35,55)

    if (choose_asteroid >66) then
        newAsteroid = display.newImageRect( mainGroup, "resources/image/asteroid3.png", size, size )
    elseif (choose_asteroid >33)  then
        newAsteroid = display.newImageRect( mainGroup, "resources/image/asteroid2.png", size, size )
    else
        newAsteroid = display.newImageRect( mainGroup, "resources/image/asteroid.png", size, size )
    end    
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
        barra_vida = display.newImageRect(mainGroup, "resources/image/green_life_bar.png",120,25)
        barra_vida.x = 90
        barra_vida.y = 25
    elseif(life ==2) then
        display.remove(barra_vida)
        barra_vida = display.newImageRect(mainGroup, "resources/image/yellow_life_bar.png",80,25)
        barra_vida.x = 70
        barra_vida.y = 25

    elseif(life == 1) then        
        display.remove(barra_vida)
        barra_vida = display.newImageRect(mainGroup, "resources/image/red_life_bar.png",40,25)
        barra_vida.x = 50
        barra_vida.y = 25

    else
        
        display.remove(barra_vida)
        display.remove(rocket)
        display.remove(scoreText)
        display.remove(js)
        endGame()
        
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
        if ( math.random( -20,100 ) > 91) then
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
-- Runtime:addEventListener( "collision", onCollision )
function catchTimer( e )

    -- local rocket = event.target
    -- local phase = event.phase

    -- if ( "began" == phase ) then
    --     display.currentStage:setFocus( rocket )

    --     rocket.touchOffsetX = event.x - rocket.x
    --     rocket.touchOffsetY = event.y - rocket.y
    -- elseif ( "moved" == phase ) then

    --     rocket.x = event.x - rocket.touchOffsetX
    --     if (rocket.x > 270) then
    --         rocket.x = 270
    --     elseif (rocket.x < 49.5) then
    --         rocket.x = 49.5
    --     end
    --     rocket.y = event.y - rocket.touchOffsetY
    --     if (rocket.y > 468) then
    --         rocket.y = 468
    --     elseif (rocket.y < 68) then
    --         rocket.y = 68
    --     end
    -- elseif ( "ended" == phase or "cancelled" == phase ) then

    --     -- deixar de focar
    --     display.currentStage:setFocus( nil )
    -- end

    -- return true
    velocityRocket = 5
    if (js:getDirection() == 1) then
        if rocket.x <270 then
            rocket.x = rocket.x + velocityRocket 
        end
    elseif (js:getDirection() == 2) then
        if (rocket.y > 68) then    
            rocket.y = rocket.y - velocityRocket
        end
    elseif (js:getDirection() == 3) then
        if (rocket.x > 55) then
            rocket.x = rocket.x - velocityRocket 
        end
    elseif (js:getDirection() == 4) then
        if (rocket.y < 468) then
            rocket.y = rocket.y + velocityRocket
        end
    end

    	-- print( "  joystick info: "
    	-- 	.. " dir=" .. js:getDirection()
    	-- 	.. " angle=" .. js:getAngle()
        --     .. " dist="..js:getDistance() )
        
    	return true
    end
-- function onTap(event)
--     js.x=  event.x
--     js.y=   event.y
--     print(event)
--     local phase = event.phase
--     if phase == 
--     print(phase)
--     print('x -->'.. event.x)
--     print('y -->'.. event.y)

--     local phase = event.phase

--     if ( "began" == phase ) then
--         js.x=  event.x
--         js.y=   event.y
        
--     -- elseif ( "moved" == phase ) then

--     --     pr
        
--     -- elseif ( "ended" == phase or "cancelled" == phase ) then

        
--     -- end

--     -- return true
-- end
function onTouch(event)
    local phase = event.phase
    --print(phase)
    -- js:activate()
    if ( "began" == phase ) then
        js.x=  event.x
        js.y=   event.y
    end

end


function scene:create(event)
    
    Runtime:addEventListener( "touch", onTouch )
    --Runtime:addEventListener( "tap", onTap )

    local sceneGroup = self.view
 
    --aqui fazemos umas pausa para poder criar os objetos na tela
    physics.pause()  

    --criando o joystick
    js = jslib.new( 20, 40 )
    js.x = -150
    js.y = -150
    js:activate()

    --vamos criar grupo de exibição, e inserir no grupo de visualização da cena
    backGroup = display.newGroup()  
    sceneGroup:insert( backGroup )  

    mainGroup = display.newGroup()  
    sceneGroup:insert( mainGroup )
     
    planet = display.newImageRect( backGroup, "resources/image/planet1.png",220, 220 )
    planet.x = display.contentCenterX-150
    planet.y = display.contentCenterY
    planet.xScale = 1.0
    planet.yScale = 1.0
    
    planet2 = display.newImageRect( backGroup, "resources/image/planet3.png",180, 180 )
    planet2.x = display.contentCenterX+ 180
    planet2.y = display.contentCenterY - display.actualContentHeight
    planet2.xScale = 1.0
    planet2.yScale = 1.0
    
    
    planet2 = display.newImageRect( backGroup, "resources/image/planet4.png",180, 180 )
    planet2.x = display.contentCenterX -150
    planet2.y = display.contentCenterY - display.actualContentHeight
    planet2.xScale = 1.0
    planet2.yScale = 1.0
    
    background = display.newImageRect( backGroup, "resources/image/background7.jpg",320, 480 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background.xScale = 1.0
    background.yScale = 1.0
    background:toBack()

    background2 = display.newImageRect( backGroup, "resources/image/background7.jpg", 320, 480 )
    background2.x = display.contentCenterX
    background2.y = display.contentCenterY - display.actualContentHeight
    background2.xScale = 1.0
    background2.yScale = 1.0    
    background2:toBack()

    rocket = display.newImageRect(mainGroup, "resources/image/power_force_one2.png",40,60)
    rocket.x = display.contentCenterX
    rocket.y = display.contentHeight - 60
    rocket.isBodyActive = true
    rocket.touchOffsetX = 0
    rocket.touchOffsetY = 0

    physics.addBody( rocket, 'dynamic', { radius=25, isSensor=true } )
    rocket.myName = nome_image.rocket

    scoreText = display.newText( "Score: " .. score, 240, 25, native.systemFont, 16 )
    scoreText:setFillColor(0.180, 0.65, 0.35  )

  --  rocket:addEventListener( "touch", dragRocket )
    

end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    
    --quando a cena está pronta para ser mostrada, logo após que o create ter sido exxecutado
    if ( phase == "will" ) then

    --ocorre imediatamente após a cena ter sido mostrada
    elseif ( phase == "did" ) then
        physics.start()

        Runtime:addEventListener( "collision", onCollision )
        background_loop_movement = timer.performWithDelay(2, move_loop, 0)
        background_loop_planet_movement = timer.performWithDelay(2, move_loop_planet, 0)
        gameLoopTimer = timer.performWithDelay( 100, gameLoop, 0 ) 
        jsLoop = timer.performWithDelay( 30, catchTimer, -1 )
        
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    -- A primeira chamada ocorre quando a cena está prestes a ser ocultada
    if ( phase == "will" ) then
        
        print('entrou aqui will')
        timer.cancel( background_loop_planet_movement )
        timer.cancel( background_loop_movement )
        if (gameLoopTimer) then
            timer.cancel( gameLoopTimer )
        end
        timer.cancel(jsLoop)
        
    -- A segunda chamada ocorre imediatamente após a cena estar totalmente fora da tela.
    elseif ( phase == "did" ) then
        

        print('entrou aqui did')
        physics.pause()
        Runtime:removeEventListener( "collision", onCollision )
        composer.removeScene( "src.game" )
        --Runtime:removeEventListener( "collision", onCollision )
        --physics.pause()
        --print('entrou aqui')
        --composer.removeScene( "src.game" )
    end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene