-- clouds.lua

local M = display.newGroup()
------------------------------------------
local cloud_file_name = "images/cloud.png"
local cloud_file_width = 159
local cloud_file_height = 118

local cloud_array = {}

-- This functions makes a cloud image
local function newCloud() 
	local cloud = display.newImageRect( cloud_file_name, cloud_file_width, cloud_file_height )
	return cloud
end 

local function set_cloud_file( name, width, height )
	cloud_file_name = name
	cloud_file_width = width
	cloud_file_height = height
end 
M.set_cloud_file = set_cloud_file

-- This functions makes any number of clouds and starts them moving across the screen.
local function make_clouds( options )
	local count = options.count or 6 
	local top = options.top or 40 
	local bottom = options.bottom or 300 
	local minSpeed = options.minSpeed or 15000 
	local maxSpeed = options.maxSpeed or 30000 
	local left = options.left or -300 
	local right = options.right or 300
	
	for i = 1, count do 
		local cloud = newCloud()
		M:insert( cloud )
		cloud.x = -( math.random( 0, display.contentWidth ) + left )
		cloud.y = math.random( top, bottom )
		local speed = math.random( minSpeed, maxSpeed )
		cloud_array[#cloud_array+1] = cloud
		transition.to( cloud, {x=right, time=speed, iterations=9999} )
	end 
end 
M.make_clouds = make_clouds
------------------------------------------
return M