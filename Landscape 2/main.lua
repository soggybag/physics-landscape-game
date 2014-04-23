-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )


local back = display.newImageRect( "images/landscape.png", 570, 360 )
back.x = display.contentCenterX
back.y = display.contentCenterY


local storyboard = require "storyboard"

-- load scenetemplate.lua
storyboard.gotoScene( "scenes.splash" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):