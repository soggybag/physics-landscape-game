----------------------------------------------------------------------------------
--
-- play.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------


-- To do
-- add animated player
-- add scoring
-- more background elements

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
-- Import some lua stuff
local physics = require( "physics" )
local poof = require( "lua.poof" )






-- ==============================================================================
--
-- Modify these variables
--
-- ==============================================================================

-- Set the size and number of platforms. 
local platform_count = 3
local platform_width = 150
local platform_height = 100
local platform_space = 70
local platform_speed = 3


-- Set the size and number of coins
local coin_count = 6
local coin_size = 10
local coin_speed = 2


-- Player physics properties 
local player_properties = {friction=0, denisty=10, bounce=0.3}
local player_linear_damping = 0.5

-- Adjust this number along with the density above, to controller how the player object
-- reacts to taps. 
local tap_nudge = 0.2

-- To control the motion of the player object play with the values for 
-- density, player_linear_damping, and tap_nudge. 
-- All of these interact to change how much, how fast, and how far the player
-- object will move when you tap the screen. 













-- ==============================================================================
-- 
-- More variables to control the program
-- 
-- ==============================================================================

local platform_array = {}
local coin_array = {}
local player
local platform_travel = ( platform_width + platform_space ) * platform_count
local platform_left = 0 - platform_width / 2

local home_button
local background
local midground
local foreground


local clouds










-- ============================================================
-- 
-- Some functions to run the game
--
-- ============================================================

---------------------------------------------------------------
-- Enter frame event. Here we'll animate objects
---------------------------------------------------------------

local function on_frame( event )
	-- Move the platforms
	for i = 1, #platform_array do 
		local platform = platform_array[i]
		platform.x = platform.x - platform_speed
		if platform.x < platform_left then 
			platform.x = platform.x + platform_travel
			platform.y = display.contentHeight - math.random( 0, platform_height / 2)
		end 
	end 
	
	-- Move the coins
	for i = 1, #coin_array do 
		local coin = coin_array[i]
		coin.x = coin.x - coin_speed
		if coin.x < ( -coin_size * 2 ) then 
			coin.x = math.random( display.contentWidth, display.contentWidth * 2 )
			coin.y = math.random( 100, 300 )
		end
	end 
	
	-- Check if player has fallen below the bottom of the screen
	if player.y > display.contentHeight then 
		storyboard.gotoScene( "scenes.splash", { effect="slideRight" } )
	end 
end 





-------------------------------------------------------------------------
-- Check for touch events
-------------------------------------------------------------------------
local function on_touch( event )
	if event.phase == "began" then 
		player:setFrame( 2 )
		player:applyLinearImpulse( 0, -tap_nudge, player.x, player.y )
	elseif event.phase == "ended" then 
		player:setFrame( 1 )
	end 
end 	





------------------------------------------------------------------------
-- this function creates a platform
------------------------------------------------------------------------
local function make_platform()
	local platform = display.newRect( 0, 0, platform_width, platform_height )
	physics.addBody( platform, "static", { friction=0, bounce=0.1 } )
	return platform
end 





-------------------------------------------------------------------------
-- This function makes all platforms 
-------------------------------------------------------------------------
local function make_platforms()
	for i = 1, platform_count do 
		local platform = make_platform()
		platform_array[#platform_array + 1] = platform
		platform.x = ( i - 1 ) * ( platform_width + platform_space )
		platform.y = display.contentHeight - math.random( 0, platform_height / 2)
		platform.n = i - 1
		midground:insert( platform )
	end
end






-------------------------------------------------------------------------
-- Make Player 
-------------------------------------------------------------------------
local function make_player()
	local bird_sheet = graphics.newImageSheet( "images/bird.png", {width=51, height=39, numFrames=2} )
	local player = display.newSprite( bird_sheet, {start=1, count=2} )
	player.x = display.contentCenterX 
	player.y = display.contentCenterY
	physics.addBody( player, "dynamic", player_properties )
	player.linearDamping = player_linear_damping
	player.isFixedRotation = true
	player.isSleepingAllowed = false
	midground:insert( player )
	return player
end 







-------------------------------------------------------------------------
-- Reset coins
-------------------------------------------------------------------------
local function reset_coin( coin )
	coin.x = math.random( display.contentWidth, display.contentWidth * 2 )
	coin.y = math.random( 50, display.contentCenterY )
end 







--------------------------------------------------------------------------
-- make a coin
--------------------------------------------------------------------------
local function make_coin()
	local coin = display.newCircle( 0, 0, coin_size )
	coin:setFillColor( 1, 1, 1, 0.2 )
	coin:setStrokeColor( 1, 1, 1, 0.6 )
	coin.strokeWidth = 6
	physics.addBody( coin, "kinematic", {isSensor=true} )
	coin.isCoin = true
	return coin
end 






-------------------------------------------------------------------------
-- Check for collisions
-------------------------------------------------------------------------
local function on_collision( event )
	if event.phase == "began" and event.other.isCoin then 
		
		local explosion = poof.make_poof()
		midground:insert( explosion )
		explosion.x = event.other.x
		explosion.y = event.other.y
		
		timer.performWithDelay( 1, function() 
			reset_coin( event.other ) 
		end  )
	end 
end 






-- *****************************************************
-- =====================================================
-- 
-- storyboard event handlers 
-- 
-- =====================================================
-- *****************************************************



------------------------------------------------------
-- The mighty create scene event! 
-- Make all non physics elements here. 
------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	---------------------------------------------------
	-- Make some groups to hold game objects
	background = display.newGroup()
	group:insert( background )
	
	midground = display.newGroup()
	group:insert( midground )
	
	foreground = display.newGroup()
	group:insert( foreground )
	
	---------------------------------------------------
	-- Make a cloud thing (see clouds.lua)
	clouds = require( "lua.clouds" )
	background:insert( clouds )
	clouds.make_clouds( {
		count=6, 
		top=0, 
		bottom=display.contentCenterY, 
		speed=-0.5,
		left=-300, 
		right=display.contentWidth + 300
	})
	
	---------------------------------------------------
	-- Make the home button
	local widget = require( "widget" )
	local home_button = widget.newButton( {
		label="Home",
		onRelease=function() 
			storyboard.gotoScene( "scenes.splash", {effect="slideRight", time=400} )
		end 
	} )
	
	home_button.x = 40
	home_button.y = 20
	
	foreground:insert( home_button )
end







------------------------------------------------------------
-- Called immediately BEFORE scene has moved onscreen:
------------------------------------------------------------
function scene:willEnterScene( event )
	local group = self.view
	
	-- Make all physics objects here. 
	physics.start()
	-- physics.setGravity( 0, 0 )
	physics.setDrawMode( "hybrid" )
	
	make_platforms()
	
	for i = 1, coin_count do 
		local coin = make_coin()
		coin_array[#coin_array+1] = coin
		reset_coin( coin )
		group:insert( coin )
	end 
	
	player = make_player()
	
	Runtime:addEventListener( "touch", on_touch )
	Runtime:addEventListener( "enterFrame", on_frame )
	player:addEventListener( "collision", on_collision )
end





--------------------------------------------------------------
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	clouds.start()
end




---------------------------------------------------------------
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	clouds.stop()
end

-- Called when scene HAS moved off screen:
function scene:didExitScene( event )
	local group = self.view
	-- Remove all physics objects here
	for i = #platform_array, 1, -1 do 
		display.remove( table.remove( platform_array, i ) )
	end 
	for i = #coin_array, 1, -1 do 
		display.remove( table.remove( coin_array, i ) )
	end 
	display.remove( player )
	
	physics.stop()
	Runtime:removeEventListener( "touch", on_touch )
	Runtime:removeEventListener( "enterFrame", on_frame )
	player:removeEventListener( "collision", on_collision )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "didExitScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene