GM.Name     = "GMod Tower"
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

function EmptyFunction() end

function GM:PhysgunPickup( ply, ent )

	local tbl = hook.GetTable().GTowerPhysgunPickup

	if ply:IsAdmin() && ent:IsPlayer() then
		return true
	end

	for _, v in pairs( tbl ) do
		local b, CantMove = SafeCall( v, ply, ent )
		if b && CantMove == false then
			return false
		end
	end

	return true
end


local PlayerModels = player_manager.AllValidModels()

PlayerModels["american_assault"] = nil
PlayerModels["german_assault"] = nil
PlayerModels["scientist"] = nil
PlayerModels["gina"] = nil
PlayerModels["magnusson"] = nil