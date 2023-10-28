--[[
 	Post-Processing Events

	Put the code for your PostEvents
	in here.
]]--


//Lobby

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

local function speed_On( mul, time )

	local layer = postman.NewColorLayer()
	layer.color = 2
	postman.FadeColorIn( "pspeed_on", layer, 5 )
	
	layer = postman.NewBloomLayer()
	layer.sizex = 10
	layer.sizey = 10
	layer.multiply = 0.6
	layer.passes = 2
	postman.FadeBloomIn( "pspeed_on", layer, 5 )
end
AddPostEvent( "pspeed_on", speed_On )

local function speed_Off( mul, time )

	postman.ForceColorFade( "pspeed_on" )
	postman.FadeColorOut( "pspeed_on", 2 )
	
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

local function sleepyOn( mul, time )

	layer = postman.NewMotionBlurLayer()
	layer.addalpha = 0.06
	layer.drawalpha = 0.36
	postman.AddMotionBlurLayer( "psleepy_on", layer )
	
	local layer = postman.NewColorLayer()
	layer.brightness = -0.1
	postman.FadeColorIn( "psleepy_on", layer, 3 )

end
AddPostEvent( "psleepy_on", sleepyOn )

local function sleepyOff( mul, time )

	postman.FadeMotionBlurOut( "psleepy_on", mul * 3 )

    postman.ForceColorFade( "psleepy_on" )
	postman.FadeColorOut( "psleepy_on", 1.5 )

end
AddPostEvent( "psleepy_off", sleepyOff )

local function sleepOn( mul, time )

	local layer = postman.NewColorLayer()
	layer.brightness = -2
	postman.FadeColorIn( "sleep", layer, 3 )

end
AddPostEvent( "sleepon", sleepOn )

local function sleepOff( mul, time )

    postman.ForceColorFade( "sleep" )
	postman.FadeColorOut( "sleep", 3 )

end
AddPostEvent( "sleepoff", sleepOff )

local function drunkOn( mul, time )
	local layer = postman.NewMotionBlurLayer()
	layer.addalpha = 0.02
	layer.drawalpha = 0.8
	postman.FadeMotionBlurIn( "dblur", layer, 3 )

	layer = postman.NewBloomLayer()
	layer.passes = 5
	layer.darken = 0.5
	layer.multiply = 2
	layer.sizex = 9
	layer.sizey = 9
	postman.FadeBloomIn( "dbloom", layer, 1 )
end
AddPostEvent( "drunkon", drunkOn )

local function drunkOff( mul, time )
	postman.ForceMotionBlurFade( "dblur" )
	postman.FadeMotionBlurOut( "dblur", 1 )

	postman.ForceBloomFade( "dbloom" )
	postman.FadeBloomOut( "dbloom", 1 )
end
AddPostEvent( "drunkoff", drunkOff )

local function usePainkillers( mul, time )
	local layer = postman.NewColorLayer()
	layer.contrast = 1.15
	layer.color = 4.0
	postman.FadeColorIn( "ppainkiller", layer, 0.2 )

	layer = postman.NewBloomLayer()
	layer.sizex = 9.0
	layer.sizey = 9.0
	layer.multiply = 0.45
	layer.color = 1.0
	layer.passes = 0.0
	layer.darken = 0.0
	postman.FadeBloomIn( "ppainkiller", layer, 1 )

	layer = postman.NewSharpenLayer()
	layer.contrast = .20
	layer.distance = 3
	postman.FadeSharpenIn( "ppainkiller", layer, 1.5 )

	postman.ForceColorFade( "ppainkiller" )
	postman.FadeColorOut( "ppainkiller", 1 )

	postman.ForceBloomFade( "ppainkiller" )
    postman.FadeBloomOut( "ppainkiller", 1 )

	postman.ForceSharpenFade( "ppainkiller" )
    postman.FadeSharpenOut( "ppainkiller", 1 )
end
AddPostEvent( "ppainkiller", usePainkillers )

local function StartBW()
  local layer = postman.NewColorLayer()
  layer.contrast = 0.8
  layer.color = 0
  postman.FadeColorIn( "bw_on", layer, 2.2 )

  layer = postman.NewSharpenLayer()
  layer.contrast = .5
  layer.distance = 3
  postman.FadeSharpenIn( "bw", layer, 1.5 )
end
AddPostEvent( "bw_on", StartBW )

local function EndBW()
  postman.ForceColorFade( "bw_on" )
  postman.FadeColorOut( "bw_on", 1 )

  postman.ForceSharpenFade( "bw" )
  postman.FadeSharpenOut( "bw", 1 )
end
AddPostEvent( "bw_off", EndBW )

//Power-ups
local function powerupTakeOn_On( mul, time )
	layer = postman.NewMotionBlurLayer()
	layer.addalpha = 0.11
	layer.drawalpha = 0.36
	postman.AddMotionBlurLayer( "putakeon_on", layer )

	local layer = postman.NewColorLayer()
	layer.color = 0.0
	layer.brightness = -0.02
	layer.contrast = 0.98
	postman.FadeColorIn( "putakeon_on", layer, 1 )

	layer = postman.NewSharpenLayer()
	layer.contrast = -0.55
	layer.distance = 1.75
	postman.FadeSharpenIn( "putakeon_on", layer, 2 )
end
AddPostEvent( "putakeon_on", powerupTakeOn_On )

local function powerupTakeOn_Off( mul, time )
	postman.FadeMotionBlurOut( "putakeon_on", mul * 3 )

	postman.ForceColorFade( "putakeon_on" )
	postman.FadeColorOut( "putakeon_on", 1 )

	postman.ForceSharpenFade( "putakeon_on" )
    postman.FadeSharpenOut( "putakeon_on", 1 )
end
AddPostEvent( "putakeon_off", powerupTakeOn_Off )


local function powerupHeadphones_On( mul, time )
	local layer = postman.NewColorLayer()
	layer.contrast = 1.15
	layer.color = 4.0
	postman.FadeColorIn( "puheadphones_on", layer, 0.2 )

	layer = postman.NewBloomLayer()
	layer.sizex = 9.0
	layer.sizey = 9.0
	layer.multiply = 0.45
	layer.color = 1.0
	layer.passes = 0.0
	layer.darken = 0.0
	postman.FadeBloomIn( "puheadphones_on", layer, 1 )

	layer = postman.NewSharpenLayer()
	layer.contrast = .20
	layer.distance = 3
	postman.FadeSharpenIn( "puheadphones_on", layer, 1.5 )

	LocalPlayer().Headphones = true
end
AddPostEvent( "puheadphones_on", powerupHeadphones_On )

local function powerupHeadphones_Off( mul, time )
	postman.ForceColorFade( "puheadphones_on" )
	postman.FadeColorOut( "puheadphones_on", 1 )

	postman.ForceBloomFade( "puheadphones_on" )
    postman.FadeBloomOut( "puheadphones_on", 1 )

	postman.ForceSharpenFade( "puheadphones_on" )
    postman.FadeSharpenOut( "puheadphones_on", 1 )

	LocalPlayer().Headphones = false
end
AddPostEvent( "puheadphones_off", powerupHeadphones_Off )


//SWEPS
local function swepNESZapper( mul, time )
	local layer = postman.NewColorLayer()
	layer.contrast = 2.0
	layer.brightness = 0.5
	postman.AddColorLayer( "neszapper", layer )
	postman.FadeColorOut( "neszapper", mul * .5 )

	layer = postman.NewSharpenLayer()
	layer.contrast = 0.55
	layer.distance = 5.25
	postman.AddSharpenLayer( "neszapper", layer, 2 )
	postman.FadeSharpenOut( "neszapper", mul * .5 )
end
AddPostEvent( "neszapper", swepNESZapper )

local function ironsightsOn( mul, time )

	-- Dark edges
	layer = postman.NewMaterialLayer()
		layer.material = "gmod_tower/pvpbattle/bluredges"
		layer.alpha    = math.Clamp( mul, 0, 1 )
	postman.FadeMaterialIn( "ironsights", layer, time )

end
AddPostEvent( "isights_on", ironsightsOn )

local function ironsightsOff( mul, time )

    postman.ForceMaterialFade( "ironsights" )
	postman.FadeMaterialOut( "ironsights", time )

end
AddPostEvent( "isights_off", ironsightsOff )
