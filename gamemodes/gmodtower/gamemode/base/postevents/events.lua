---------------------------------
--[[
 	Post-Processing Events

	Put the code for your PostEvents
	in here.
]]--




local function playerDeath( mul, time )

	-- Fade to near black and white
	local layer = postman.NewColorLayer()
	layer.color = 0.2
	postman.FadeColorIn( "pdeath", layer, 2 )

	-- Fade to sharp edges
	layer = postman.NewSharpenLayer()
	layer.contrast = 3
	layer.distance = 1
	postman.FadeSharpenIn( "pdeath", layer, 2 )

	-- Slow fade to white
	layer = postman.NewColorLayer()
	layer.contrast = 2
	layer.brightness = 0.5
	postman.FadeColorIn( "pdeathslow", layer, 20 )

	-- Slow bloom
	layer = postman.NewBloomLayer()
	layer.sizex = 10
	layer.sizey = 10
	layer.multiply = 0.9
	layer.color = 0.2
	layer.passes = 2
	postman.FadeBloomIn( "pdeathslow", layer, 20 )

end
AddPostEvent( "pdeath", playerDeath )

local function speed_On( mul, time )
	-- Slow bloom
	layer = postman.NewBloomLayer()
	layer.sizex = 10
	layer.sizey = 10
	layer.multiply = 0.6
	layer.color = 1.5
	layer.passes = 2
	postman.FadeBloomIn( "pspeed_on", layer, 5 )
end
AddPostEvent( "pspeed_on", speed_On )

local function speed_Off( mul, time )
	postman.ForceBloomFade( "pspeed_on" )
	postman.FadeBloomOut( "pspeed_on", 2 )
end
AddPostEvent( "pspeed_off", speed_Off )

local function bone_On( mul, time )
	layer = postman.NewMotionBlurLayer()
	layer.addalpha = 0.11
	layer.drawalpha = 0.36
	postman.AddMotionBlurLayer( "pbone_on", layer )
	
	local layer = postman.NewColorLayer()
	layer.color = 0.0
	layer.brightness = -0.02
	layer.contrast = 0.98
	postman.FadeColorIn( "pbone_on", layer, 1 )
	
	layer = postman.NewSharpenLayer()
	layer.contrast = -0.55
	layer.distance = 1.75
	postman.FadeSharpenIn( "pbone_on", layer, 2 )
end
AddPostEvent( "pbone_on", bone_On )

local function bone_Off( mul, time )
	postman.FadeMotionBlurOut( "pbone_on", mul * 3 )
	
	postman.ForceColorFade( "pbone_on" )
	postman.FadeColorOut( "pbone_on", 1 )
	
	postman.ForceSharpenFade( "pbone_on" )
    postman.FadeSharpenOut( "pbone_on", 1 )
end
AddPostEvent( "pbone_off", bone_Off )

local function timeOn( mul, time )
	layer = postman.NewBloomLayer()
	layer.sizex = 15.0
	layer.sizey = 0.0
	layer.multiply = 2.0
	layer.color = 0.0
	layer.passes = 1.0
	layer.darken = 0.3
	postman.FadeBloomIn( "ptime_on", layer, 1 )
	
	local layer = postman.NewColorLayer()
	layer.color = 0.5
	postman.FadeColorIn( "ptime_on", layer, 1 )
end
AddPostEvent( "ptime_on", timeOn )

local function timeOff( mul, time )
	postman.ForceColorFade( "ptime_on" )
	postman.FadeColorOut( "ptime_on", 1 )
	
	postman.ForceBloomFade( "ptime_on" )
    postman.FadeBloomOut( "ptime_on", 1 )
end
AddPostEvent( "ptime_off", timeOff )

local function coloredOn( mul, time )
	local layer = postman.NewColorLayer()
	layer.contrast = 1.15
	layer.color = 4.0
	postman.FadeColorIn( "pcolored_on", layer, 0.2 )
	
	layer = postman.NewBloomLayer()
	layer.sizex = 9.0
	layer.sizey = 9.0
	layer.multiply = 0.45
	layer.color = 1.0
	layer.passes = 0.0
	layer.darken = 0.0
	postman.FadeBloomIn( "pcolored_on", layer, 1 )
	
	layer = postman.NewSharpenLayer()
	layer.contrast = .20
	layer.distance = 3
	postman.FadeSharpenIn( "pcolored_on", layer, 1.5 )
end
AddPostEvent( "pcolored_on", coloredOn )

local function coloredOff( mul, time )
	postman.ForceColorFade( "pcolored_on" )
	postman.FadeColorOut( "pcolored_on", 1 )
	
	postman.ForceBloomFade( "pcolored_on" )
    postman.FadeBloomOut( "pcolored_on", 1 )
	
	postman.ForceSharpenFade( "pcolored_on" )
    postman.FadeSharpenOut( "pcolored_on", 1 )
end
AddPostEvent( "pcolored_off", coloredOff )

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

local function playerSpawn( mul, time )

	-- Undo death effects
	postman.ForceColorFade( "pdeath" )
    postman.RemoveColorLayer( "pdeath" )
    postman.ForceSharpenFade( "pdeath" )
    postman.RemoveSharpenLayer( "pdeath" )
    
	postman.ForceColorFade( "pdeathslow" )
	postman.FadeColorOut( "pdeathslow", 2 )
	postman.ForceBloomFade( "pdeathslow" )
	postman.FadeBloomOut( "pdeathslow", 2 )

end
AddPostEvent( "pspawn", playerSpawn )




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




local function cloakOn( mul, time )

	-- Grey/blue fade
	local layer = postman.NewColorLayer()
	layer.addr = -0.1
	layer.addg = -0.1
	layer.addb = 0.25
	layer.mulr = 0.2
	layer.mulg = 0.2
	layer.mulb = 0.2
	layer.color = 0.1
	layer.contrast = 1.1
	layer.brightness = 0.1
	postman.FadeColorIn( "cloak", layer, 0.5 )
	
	-- Fade to sharp edges
	layer = postman.NewSharpenLayer()
	layer.contrast = 3
	layer.distance = 0.75
	postman.FadeSharpenIn( "cloak", layer, 0.5 )
	
	-- Ripple overlay
	layer = postman.NewMaterialLayer()
	layer.material = "models/props_combine/com_shield001a"
	layer.alpha = 0.5
	layer.refract = 0.1
	postman.FadeMaterialIn( "cloak", layer, 0.5 )
	
end
AddPostEvent( "cloakon", cloakOn )


local function cloakOff( mul, time )

	postman.ForceColorFade( "cloak" )
	postman.FadeColorOut( "cloak", 0.5 )

	postman.ForceSharpenFade( "cloak" )
	postman.FadeSharpenOut( "cloak", 0.5 )

    postman.ForceMaterialFade( "cloak" )
	postman.FadeMaterialOut( "cloak", 0.5 )
	
end
AddPostEvent( "cloakoff", cloakOff )


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