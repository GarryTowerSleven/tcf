GM.Name     = "GMod Tower"
GM.Author   = "PixelTail Games & TCF Team"
GM.Website  = "https://gtower.net/"
GM.WebsiteUrl  = GM.Website .. "apps/"

ServerName 		= "GMod Tower: The Community First"
ServerNameShort = "TCF"

Website 	= GM.Website
WebsiteApps = Website .. "apps/"

color_green = Color( 50, 255, 50 )
color_red = Color( 255, 50, 50 )

GMT = true
TestingMode = CreateConVar( "gmt_testing", 0, { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "GMT testing mode" )
EmptyFunction = function() end

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