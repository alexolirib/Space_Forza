local composer = require("composer")

local scene = composer.newScene()
local toPlay = false
local setup_music = require('src.setup_music')

local selectMenuSound
local musicTrack

local imgMusic
local imgNotMusic

local function gotoGame()
    if toPlay then
        audio.play(selectMenuSound) 
    end
    composer.gotoScene( "src.game" , { time=600, effect="zoomInOutFade" })
end


local function gotoHighScore()    
    if toPlay then
        audio.play(selectMenuSound) 
    end
    composer.setVariable('toPlay', toPlay)
    composer.gotoScene( "src.high_scores" , { time=600, effect="zoomInOutFade" })
end 

function setupMusic(event)
    toPlay = not toPlay
    if toPlay then
        audio.play( musicTrack, { channel=1, loops=-1 } )
        imgNotMusic.isVisible = false
        imgMusic.isVisible =true
    else         
        audio.stop(1)
        imgNotMusic.isVisible = true
        imgMusic.isVisible =false
    end
    setup_music.save(toPlay)

end



local position_btn = 350
local dif_btn = 65
function scene:create( event )

    local sceneGroup = self.view    

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
    
    local icon_music_dim = 30
    imgMusic = display.newImageRect( sceneGroup, "resources/image/music_play.png", icon_music_dim*0.7695325, icon_music_dim )
	imgMusic.x = display.contentCenterX +100
    imgMusic.y = 25    
    imgMusic.isVisible = false
    
    local sum_icon_music_dim= 2
    imgNotMusic = display.newImageRect( sceneGroup, "resources/image/music_stop.png", icon_music_dim+sum_icon_music_dim, icon_music_dim+sum_icon_music_dim )
	imgNotMusic.x = display.contentCenterX +100
    imgNotMusic.y = 25
    imgNotMusic.isVisible = false

    imgNotMusic:addEventListener('tap',setupMusic)
    imgMusic:addEventListener('tap', setupMusic)
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
        toPlay = setup_music.load()
        if toPlay then
            audio.play( musicTrack, { channel=1, loops=-1 } )
            imgNotMusic.isVisible = false
            imgMusic.isVisible =true
        else         
            audio.stop(1)
            imgNotMusic.isVisible = true
            imgMusic.isVisible =false
        end
    
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