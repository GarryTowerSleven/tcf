local function WarpStar_On( mul, time )
	local layer = postman.NewColorLayer()
	layer.brightness = 0
	layer.contrast = 1
	layer.color = 1.94
	layer.addr = 2
	layer.addg = 2
	layer.addb = 2
	postman.FadeColorIn( "WarpStar_on", layer, .8 )
end
AddPostEvent( "warpstar_on", WarpStar_On )

local function WarpStar_Off( mul, time )
	postman.ForceColorFade( "WarpStar_on" )
	postman.FadeColorOut( "WarpStar_on", 1 )
end
AddPostEvent( "warpstar_off", WarpStar_Off )
