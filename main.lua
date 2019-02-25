--adicionando a fisica
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed(os.time())


local rocket_name = 'power_force_one'

local backGroup = display.newGroup() 
local mainGroup = display.newGroup()


local background = display.newImageRect( backGroup, "image/background3.jpg", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

rocket = display.newImageRect(mainGroup, "./image/power_force_one.png",60,60)
rocket.x = display.contentCenterX
rocket.y = display.contentHeight - 60

physics.addBody( rocket, { radius=30, isSensor=true } )
rocket.myName = rocket_name


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



rocket:addEventListener( "touch", dragRocket )