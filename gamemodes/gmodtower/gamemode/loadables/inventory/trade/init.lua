AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_gui.lua")
AddCSLuaFile("cl_item.lua")
AddCSLuaFile("shared.lua")

TRADE_DISABLED = true

include("shared.lua")
include("trade.lua")
include("concommand.lua")
include("log.lua")

local meta = FindMetaTable( "Player" )

if (!meta) then 
    Msg("ALERT! Could not hook Player Meta Table\n")
	return
end


function meta:InvTrade( ply )

	if TRADE_DISABLED then
		return
	end
	
	local Trade = GTowerItems:GetTrade( self, ply )
	
	Trade:PlayerStartAccept( self )
	
end