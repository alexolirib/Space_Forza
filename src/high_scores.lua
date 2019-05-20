
local composer = require( "composer" )

local scene = composer.newScene()

local json = require( "json" )

local scoresTable = {}

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

local selectMenuSound

local toPlay = true

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

local musicBack

local function gotoMenu()
	if toPlay then
		audio.play(selectMenuSound) 
	end
	composer.gotoScene( "src.menu", { time=400, effect="crossFade" } )
end

function scene:create( event )

	local sceneGroup = self.view

	toPlay = composer.getVariable('toPlay')
	
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Load the previous scores
    loadScores()

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

    local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 30, native.systemFont, 44 )
    local sizeWord = 25
    for i = 1, 10 do
        if ( scoresTable[i] ) then
            local yPos = 40 + ( i * 38 )
            

            local rankNum = display.newText( sceneGroup, i .. "º -------------------- ", display.contentCenterX+75, yPos, native.systemFont, sizeWord )
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1

            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX+70, yPos, native.systemFont, sizeWord )
            thisScore.anchorX = 0
        end
    end

    local btn_menu = display.newImageRect( sceneGroup, "resources/image/btn_menu.png", 148, 45 )
	btn_menu.x = display.contentCenterX
    btn_menu.y = display.contentCenterY + 210
	btn_menu:addEventListener('tap', gotoMenu)
	selectMenuSound = audio.loadSound('resources/music/music_click.mp3')
	musicBack = audio.loadStream('resources/music/music_menu.mp3')
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		if toPlay then
			audio.play( musicBack, { channel=1, loops=-1 } )
		else         
			audio.stop(1)
		end

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
		composer.removeScene( "src.high_scores" )
		audio.stop( 1 )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	
	audio.dispose( selectMenuSound )
	audio.dispose( musicBack )

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
