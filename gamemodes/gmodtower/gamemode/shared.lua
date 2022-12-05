GM.Name     = "GMod Tower: Deluxe"
GM.Author   = "Deluxe Team & PixelTail Games"
GM.Website  = "https://www.gmtdeluxe.org/"
GM.WebsiteUrl  = "https://www.gmtdeluxe.org/apps/"

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