GM.Name     = "GMod Tower"
GM.Author   = "Deluxe Team & PixelTail Games"
GM.Website  = "https://gmtower.nailgunworld.com/"
GM.WebsiteUrl  = GM.Website .. "apps/"

color_green = Color( 50, 255, 50 )
color_red = Color( 255, 50, 50 )

GMT = true
TestingMode = CreateConVar( "gmt_testing", 0, { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "GMT testing mode" )
EmptyFunction = function() end

IsDeluxe = string.StartsWith( game.GetMap(), "gmt_lobby2" ) && tonumber( string.Replace( game.GetMap(), "gmt_lobby2_r", "" ) or 0 ) > 3

hook.Remove( "PlayerTick", "TickWidgets" ) -- Remove tick widgets

function GetWorldEntity()
	return game.GetWorld() //ents.FindByClass("worldspawn")[1]
end

function GM:PhysgunPickup( ply, ent )	

	if ent:IsPlayer() && ent:IsAdmin() then
		return false
	end

	return ply:GetSetting( "GTAllowInvAllEnts" )

end