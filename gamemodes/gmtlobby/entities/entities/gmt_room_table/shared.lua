---------------------------------
ENT.Base = "gmt_tictactoe"
ENT.Type = "anim"
ENT.PrintName		= "TicTacToe table"
ENT.Author			= "Nican"
ENT.Contact			= ""
ENT.Purpose			= "For GMod Tower"
ENT.Instructions	= ""
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model		= "models/gmod_tower/suitetable.mdl"

util.PrecacheModel( ENT.Model )
local StoreBedId = nil

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Level" )
end

function ENT:GetStoreId()
	return StoreBedId
end
/*
hook.Add("GTowerStoreLoad", "GTowerLoadTableTic", function()
	
	if !GTowerRooms then
		return
	end
	
	StoreTableId = GTowerStore:SQLInsert( {
		storeid = GTowerRooms.StoreId,
		upgradable = true,
		ClientSide = true,
		unique_name = StoreTableName,
		name  = "Table",
		unique_name = "SuiteTicTac",
		description = "Play tic tac toe in your room.",
		model = "models/gmod_tower/suitetable.mdl",
		drawmodel = true,
		price = 25
	} )

end )
*/