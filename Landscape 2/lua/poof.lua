-------------------------------------------
--
-- poof.lua 
--
-------------------------------------------
local M = {}
---------------------------------------
local poof_sheet = graphics.newImageSheet( "images/poof.png", {width=128, height=128,numFrames=5} )

local function make_poof()
	local poof = display.newSprite( poof_sheet, {start=1, count=5, loopCount=1, time=300} )
	poof:play()
	poof:addEventListener( "sprite", function( event ) 
		if event.phase == "ended" then 
			display.remove( event.target )
		end 
	end )
	return poof
end 
M.make_poof = make_poof

-----------------------------------------
return M