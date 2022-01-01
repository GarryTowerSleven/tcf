GM.Name     = "GMod Tower: Deluxe"
GM.Author   = "Deluxe Team & PixelTail Games"
GM.Website  = "https://www.gmtdeluxe.org/"
GM.WebsiteUrl  = "https://www.gmodtower.org/apps/" // TODO: Change to gmtdeluxe.org

co_color = Color( 50, 255, 50 )
co_color2 = Color( 255, 50, 50 )

// This breaks things????
--DeriveGamemode("base")

GMT = true
TestingMode = CreateConVar( "gmt_testing", 0, { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "GMT testing mode" )
EmptyFunction = function() end

hook.Remove( "PlayerTick", "TickWidgets" ) -- Remove tick widgets

function GetWorldEntity()
	return game.GetWorld() //ents.FindByClass("worldspawn")[1]
end

function GtowerPrecacheModel(Model)
	if !Model then return end

	if !util.IsValidModel(Model) then
		--print("GtowerPrecacheModel: Invalid Model!", Model)
		--debug.Trace()
		return
	end

	util.PrecacheModel(Model)
end

function GtowerPrecacheModelTable(Table)
	for k,v in pairs(Table) do
		GtowerPrecacheModel(v)
	end
end

function GM:PhysgunPickup( ply, ent )	

	if ent:IsPlayer() && ent:IsAdmin() then
		return false
	end

	return ply:GetSetting( "GTAllowInvAllEnts" )

end