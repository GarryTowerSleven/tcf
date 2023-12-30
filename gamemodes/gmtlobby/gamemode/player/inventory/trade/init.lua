AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_gui.lua")
AddCSLuaFile("cl_item.lua")
AddCSLuaFile("shared.lua")

TRADE_DISABLED = false

include("shared.lua")
include("sv_trade.lua")
include("sv_concommand.lua")
include("sv_log.lua")

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