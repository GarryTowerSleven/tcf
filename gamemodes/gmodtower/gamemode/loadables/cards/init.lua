AddCSLuaFile("cl_dcardlist.lua")
AddCSLuaFile("cl_dmodel_card.lua")
AddCSLuaFile("cl_dnumsliderbet.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_panel_help.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_player.lua")

include("shared.lua")
include("sh_player.lua")

hook.Add("SQLStartColumns", "SQLGetPlayerChips", function()
	SQLColumn.Init( {
		["column"] = "chips",
		["update"] = function( ply )
			return math.Clamp( ply:PokerChips(), 0, 2147483647 )
		end,
		["defaultvalue"] = function( ply )
			ply:SetPokerChips( 0 )
		end,
		["onupdate"] = function( ply, val )
			ply:SetPokerChips( tonumber( val ) or 0 )
		end
	} )
end )
