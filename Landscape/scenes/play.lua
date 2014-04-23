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

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


local physics = require( "physics" )
local chunk_array = {}
local player
local chunk_count = 3
local chunk_width = 250
local chunk_height = 200
local chunk_space = 70
local chunk_travel = (chunk_width+chunk_space) * chunk_count

local bubble_array = {}
local bubble_count = 6
local bubble_size = 40
local bubble_speed = 2
local bubble_travel = display.contentWidth + (bubble_size*2)

local home_button
local background
local foreground

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	local background = display.newGroup()
	group:insert( background )
	local foreground = display.newGroup()
	group:insert( foreground )
	
	local clouds = require( "lua.clouds" )
	background:insert( clouds )
	clouds.make_clouds( {
		count=6, 
		top=40, 
		bottom=display.contentHeight - 60, 
		minSpeed=15000, 
		maxSpeed=30000, 
		left=-300, 
		right=display.contentWidth + 300
	})
	
	local widget = require( "widget" )
	local home_button = widget.newButton( {
		label="Home",
		onRelease=function() 
			storyboard.gotoScene( "scenes.splash" )
		end 
	} )
	
	foreground:insert( home_button )
	
end

local function on_frame( event )
	for i = 1, #chunk_array do 
		local chunk = chunk_array[i]
		chunk.x = chunk.x - 3
		if chunk.x < -chunk_width then 
			chunk.x = chunk.x + chunk_travel
		end 
	end 
	
	for i = 1, #bubble_array do 
		local bubble = bubble_array[i]
		bubble.x = bubble.x - bubble_speed
		if bubble.x < (-bubble_size*2) then 
			bubble.x = math.random( display.contentWidth, display.contentWidth*2 )
			bubble.y = math.random( 100, 300 )
		end 
	end 
	
	if player.y > display.contentHeight then 
		storyboard.gotoScene( "scenes.splash", {effect="slideRight"} )
	end 
end 

local function on_touch( event )
	if event.phase == "began" then 
		player:applyLinearImpulse( 0, -0.2, player.x, player.y )
	end 
end 	

local function make_chunk()
	local chunk = display.newRect( 0, 0, chunk_width, chunk_height )
	physics.addBody( chunk, "static", {friction=0, bounce=0.1} )
	
	return chunk
end 

local function make_bubble()
	local bubble = display.newCircle( 0, 0, bubble_size )
	bubble:setFillColor( 1, 1, 1, 0.2 )
	bubble:setStrokeColor( 1, 1, 1, 0.6 )
	bubble.strokeWidth = 6
	
	return bubble
end 

-- Called immediately BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
	local group = self.view
	
	-- Make all physics objects here. 
	physics.start()
	physics.setDrawMode( "hybrid" )
	
	for i = 1, chunk_count do 
		local chunk = make_chunk()
		chunk_array[#chunk_array + 1] = chunk
		chunk.x = 320 * (i-1)
		chunk.y = 330
		chunk.n = i - 1
		group:insert( chunk )
	end
	
	for i = 1, bubble_count do 
		local bubble = make_bubble()
		bubble_array[#bubble_array+1] = bubble
		bubble.x = math.random( display.contentWidth, display.contentWidth*2 )
		bubble.y = math.random( 100, 300 )
		group:insert( bubble )
	end 
	
	player = display.newRect( 0, 0, 40, 60 )
	group:insert( player )
	player.x = display.contentCenterX 
	player.y = display.contentCenterY
	physics.addBody( player, "dynamic", {friction=0, denisty=10, bounce=0.3} )
	player.isFixedRotation = true
	player.isSleepingAllowed = false
	
	Runtime:addEventListener( "touch", on_touch )
	Runtime:addEventListener( "enterFrame", on_frame )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
end

-- Called when scene HAS moved off screen:
function scene:didExitScene( event )
	local group = self.view
	
	-- Remove all physics objects here
	for i = #chunk_array, 1, -1 do 
		display.remove( table.remove( chunk_array, i ) )
	end 
	for i = #bubble_array, 1, -1 do 
		display.remove( table.remove( bubble_array, i ) )
	end 
	display.remove( player )
	
	physics.stop()
	Runtime:removeEventListener( "touch", on_touch )
	Runtime:removeEventListener( "enterFrame", on_frame )
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