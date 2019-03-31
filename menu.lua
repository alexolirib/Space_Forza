local composer = require("composer")

local scene = composer.newScene()
-- zoomInOutFade
local function gotoGame()
    composer.gotoScene( "game" , { time=600, effect="zoomInOutFade" })
end

local position_btn = 280
local dif_btn = 65
function scene:create( event )

    local sceneGroup = self.view

    local background = display.newImageRect( sceneGroup, "image/background3.jpg", 360, 580 )
	background.x = display.contentCenterX
    background.y = display.contentCenterY
    
    local title = display.newImageRect( sceneGroup, "image/logo_1.png", 160, 160 )
	title.x = display.contentCenterX
    title.y = 85
    
    local btn_play = display.newImageRect( sceneGroup, "image/btn_play.png", 148, 45 )
    btn_play.x = display.contentCenterX
    btn_play.y = position_btn
    
    local btn_option = display.newImageRect( sceneGroup, "image/btn_options.png", 148, 45 )
    btn_option.x = display.contentCenterX
    btn_option.y = position_btn + dif_btn
    
    local btn_h_scores = display.newImageRect( sceneGroup, "image/btn_h_scores.png", 148, 45 )
    btn_h_scores.x = display.contentCenterX
    btn_h_scores.y = position_btn + (dif_btn*2)

    btn_play:addEventListener("tap", gotoGame)


end

scene:addEventListener( "create", scene )

return scene