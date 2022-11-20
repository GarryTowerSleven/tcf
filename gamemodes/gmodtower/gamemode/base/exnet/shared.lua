if SERVER then
	AddCSLuaFile("net_tools.lua")
	AddCSLuaFile("net_rpc.lua")
	AddCSLuaFile("net_tables.lua")
	AddCSLuaFile("net_util.lua")
end

include("net_tools.lua")
include("net_rpc.lua")
include("net_tables.lua")
include("net_util.lua")