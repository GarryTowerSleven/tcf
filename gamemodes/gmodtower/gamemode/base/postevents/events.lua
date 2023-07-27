---------------------------------
--[[
 	Post-Processing Events

	Put the code for your PostEvents
	in here.
]]--

//Adrenaline
local function Adrenaline_On( mul, time )
	local layer = postman.NewSharpenLayer()
	layer.distance = 0.62
	layer.contrast = 1.81
	postman.FadeSharpenIn( "adrenaline_on", layer, 1 )

	layer = postman.NewBloomLayer()
	layer.passes = 1
	layer.darken = 0.8
	layer.multiply = 3.25
	layer.sizex = 10
	layer.sizey = 4.57
	layer.color = 0.23
	postman.FadeBloomIn( "adrenaline_on", layer, 4 )
	
end
AddPostEvent( "adrenaline_on", Adrenaline_On )

local function Adrenaline_Off( mul, time )
    postman.ForceSharpenFade( "adrenaline_on" )
    postman.RemoveSharpenLayer( "adrenaline_on" )
   
	postman.ForceBloomFade( "adrenaline_on" )
	postman.FadeBloomOut( "adrenaline_on", 2 )
end
AddPostEvent( "adrenaline_off", Adrenaline_Off )




local function playerDamage( mul, time )

	-- Red fade
	local layer = postman.NewColorLayer()
	layer.addr = mul
	postman.AddColorLayer( "pdamage", layer )
	postman.FadeColorOut( "pdamage", mul * 3 )

	-- Motionblur fade
	layer = postman.NewMotionBlurLayer()
	layer.addalpha = 0.02
	postman.AddMotionBlurLayer( "pdamage", layer )
	postman.FadeMotionBlurOut( "pdamage", mul * 3 )

end
AddPostEvent( "pdamage", playerDamage )




local function ironsightsOn( mul, time )

	-- Dark edges
	layer = postman.NewMaterialLayer()
		layer.material = "refract/bluredges"
		layer.alpha    = math.Clamp( mul, 0, 1 )
	postman.FadeMaterialIn( "ironsights", layer, time )

end
AddPostEvent( "isights_on", ironsightsOn )




local function ironsightsOff( mul, time )

    postman.ForceMaterialFade( "ironsights" )
	postman.FadeMaterialOut( "ironsights", time )

end
AddPostEvent( "isights_off", ironsightsOff )

local function Cloak_On( mul, time )
	local layer = postman.NewColorLayer()
	layer.color = 0.20
	layer.addr = 0.0
	layer.addg = 0.15
	layer.addb = 0.45
	postman.FadeColorIn( "cloak_on", layer, 0.5 )

	layer = postman.NewBloomLayer()
	layer.sizex = 0.0
	layer.sizey = 50.0
	layer.multiply = 1.0
	layer.color = 1.0
	layer.passes = 1.0
	layer.darken = 0.45
	postman.FadeBloomIn( "cloak_on", layer, 0.5 )
end
AddPostEvent( "cloak_on", Cloak_On )

local function Cloak_Off( mul, time )
	postman.ForceColorFade( "cloak_on" )
	postman.FadeColorOut( "cloak_on", 0.5 )

	postman.ForceBloomFade( "cloak_on" )
    postman.FadeBloomOut( "cloak_on", 0.5 )
end
AddPostEvent( "cloak_off", Cloak_Off )


local function testOn( mul, time )

	-- Grey/green fade
	local layer = postman.NewColorLayer()
	layer.addr = -0.1
	layer.addg = -0.1
	layer.addb = 0.25
	layer.mulr = 0.2
	layer.mulg = 0.2
	layer.mulb = 0.2
	layer.color = 0
	layer.contrast = 1.1
	layer.brightness = 0.1
	postman.FadeColorIn( "nvg", layer, 0.2 )
	
	-- Fade to sharp edges
	layer = postman.NewSharpenLayer()
	layer.contrast = 3
	layer.distance = 0.75
	postman.FadeSharpenIn( "nvg", layer, 0.2 )

	-- Dark edges
	layer = postman.NewMaterialLayer()
	layer.material = "refract/bluredges"
	layer.alpha = 1
	postman.FadeMaterialIn( "nvg", layer, 0.2 )
	
end
AddPostEvent( "teston", testOn )

local function testOff( mul, time )

	postman.ForceColorFade( "nvg" )
	postman.FadeColorOut( "nvg", 0.2 )

	postman.ForceSharpenFade( "nvg" )
	postman.FadeSharpenOut( "nvg", 0.2 )

    postman.ForceMaterialFade( "nvg" )
	postman.FadeMaterialOut( "nvg", 0.2 )
	
end
AddPostEvent( "testoff", testOff )


local function test2On( mul, time )

	-- Ripple overlay
	layer = postman.NewMaterialLayer()
	layer.material = "refract/tank_glass"
	layer.alpha = 0.5
	layer.refract = 0.1
	postman.FadeMaterialIn( "test2", layer, 3 )
	
end
AddPostEvent( "test2on", test2On )

local function test2Off( mul, time )

    postman.ForceMaterialFade( "test2" )
	postman.FadeMaterialOut( "test2", 3 )
	
end
AddPostEvent( "test2off", test2Off )