-- clouds.lua

local M = display.newGroup()
------------------------------------------
local cloud_file_name = "images/cloud.png"
local cloud_width = 159
local cloud_height = 118
local cloud_left = -cloud_width
local cloud_right = display.contentWidth + cloud_width
local cloud_range = cloud_right - cloud_left
local cloud_speed = 1

local cloud_array = {}

-- This functions makes a cloud image
local function newCloud() 
	local cloud = display.newImageRect( cloud_file_name, cloud_width, cloud_height )
	return cloud
end 
---------------------------------------------------------------
local function set_cloud_file( name, width, height )
	cloud_file_name = name
	cloud_file_width = width
	cloud_file_height = height
end 
M.set_cloud_file = set_cloud_file
---------------------------------------------------------------
-- This functions makes any number of clouds and starts them moving across the screen.
local function make_clouds( options )
	local count = options.count or 6 
	local top = options.top or 40 
	local bottom = options.bottom or 300 
	cloud_speed = options.speed or 1
	local left = options.left or -cloud_file_width 
	local right = options.right or display.contentWidth + cloud_file_width
	
	print( cloud_speed, options.speed )
	
	for i = 1, count do 
		local cloud = newCloud()
		M:insert( cloud )
		cloud.x = math.random( left, right )
		cloud.y = math.random( top, bottom )
		cloud_array[#cloud_array+1] = cloud
	end 
end 
M.make_clouds = make_clouds
---------------------------------------------------------
local function on_frame( event )
	for i = 1, #cloud_array do 
		local cloud = cloud_array[i]
		cloud.x = cloud.x + cloud_speed
		
		if cloud.x > cloud_right and cloud_speed > 0 then 
			cloud.x = cloud.x - cloud_range
		elseif cloud.x < cloud_left and cloud_speed < 0 then 
			cloud.x = cloud.x + cloud_range
		end  
	end 
end 

----------------------------------------
local function start()
	Runtime:addEventListener( "enterFrame", on_frame )
end 
M.start = start
------------------------------------------
local function stop()
	Runtime:removeEventListener( "enterFrame", on_frame )
end 
M.stop = stop

------------------------------------------
return M