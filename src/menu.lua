local composer = require("composer")

local scene = composer.newScene()

local selectMenuSound
local musicTrack
-- zoomInOutFade
local function gotoGame()
    audio.play(selectMenuSound) 
    composer.gotoScene( "src.game" , { time=600, effect="zoomInOutFade" })
end


local function gotoHighScore()    
    audio.play(selectMenuSound)
    composer.gotoScene( "src.high_scores" , { time=600, effect="zoomInOutFade" })
end


local position_btn = 350
local dif_btn = 65
function scene:create( event )

    local sceneGroup = self.view

    

    local ImgMusic = display.newImageRect( sceneGroup, "resources/image/music.png", 360, 580 )
	ImgMusic.x = display.contentCenterX
    ImgMusic.y = display.contentCenterY

    local background = display.newImageRect( sceneGroup, "resources/image/background3.jpg", 360, 580 )
	background.x = display.contentCenterX
    background.y = display.contentCenterY
    
    log_dim = 220
    local title = display.newImageRect( sceneGroup, "resources/image/logo1.png", log_dim, log_dim/2.5 )
	title.x = display.contentCenterX
    title.y = 85
    
    local btn_play = display.newImageRect( sceneGroup, "resources/image/btn_play.png", 148, 45 )
    btn_play.x = display.contentCenterX
    btn_play.y = position_btn
    
    local btn_h_scores = display.newImageRect( sceneGroup, "resources/image/btn_h_scores.png", 148, 45 )
    btn_h_scores.x = display.contentCenterX
    btn_h_scores.y = position_btn + dif_btn

    btn_play:addEventListener("tap", gotoGame)
    btn_h_scores:addEventListener("tap", gotoHighScore)

    selectMenuSound = audio.loadSound('resources/music/music_click.mp3')
    musicTrack = audio.loadStream('resources/music/music_menu.mp3')

end


function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
        audio.play( musicTrack, { channel=1, loops=-1 } )
    end
end
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
    elseif ( phase == "did" ) then

        audio.stop( 1 )
    end
end

function scene:destroy( event )
 
    local sceneGroup = self.view
    audio.dispose(selectMenuSound)
    audio.dispose( musicTrack )
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene