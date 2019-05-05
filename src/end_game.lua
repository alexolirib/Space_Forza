
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
local json = require( "json" )

local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )


local function loadScores()

	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		scoresTable = json.decode( contents )
	end

	if ( scoresTable == nil or #scoresTable == 0 ) then
		scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	end
end

local function saveScores()

	for i = #scoresTable, 11, -1 do
		table.remove( scoresTable, i )
	end

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( scoresTable ) )
		io.close( file )
	end
end



local function gotoMenu()
	composer.gotoScene( "src.menu", { time=600, effect="crossFade" } )
end

local function goToGame()
	composer.gotoScene( "src.game", { time=800, effect="zoomInOutFade" } )
end

function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Load the previous scores
    loadScores()


    local pontuacao = composer.getVariable( "finalScore" )
    
        print('1ª  -  ' .. pontuacao)
    if (pontuacao == nil) then
        pontuacao = ""
    end 

    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )

    -- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )




    -- Save the scores
    saveScores()

    local background = display.newImageRect( sceneGroup, "resources/image/background3.jpg", 360, 580 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local scoresText = display.newText( sceneGroup, pontuacao, display.contentCenterX,  display.contentCenterY-40, native.systemFont, 40 )

    
    local highScoresHeader = display.newText( sceneGroup, "PONTUAÇÃO", display.contentCenterX, 50, native.systemFont, 40 )

    local size_image_btn = 60

    local btn_game_novamente = display.newImageRect( sceneGroup, "resources/image/btn_game_novamente.png", size_image_btn*3.28, size_image_btn )
	btn_game_novamente.x = display.contentCenterX
    btn_game_novamente.y = display.contentCenterY + 130
    btn_game_novamente:addEventListener('tap', goToGame)

    local size_btn_menu = size_image_btn -10

    local btn_menu = display.newImageRect( sceneGroup, "resources/image/btn_menu.png", size_btn_menu*3.28, size_btn_menu  )
	btn_menu.x = display.contentCenterX
    btn_menu.y = btn_game_novamente.y  + 70
    btn_menu:addEventListener('tap', gotoMenu)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "src.end_game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
