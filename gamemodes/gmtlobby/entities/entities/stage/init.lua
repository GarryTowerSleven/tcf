util.AddNetworkString("UpdateShowDelay")
util.AddNetworkString("StartShow")

include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

AddCSLuaFile("gmidi2.lua")
AddCSLuaFile("foreplay.lua")
AddCSLuaFile("cl_util.lua")
AddCSLuaFile("cl_songinfo.lua")
AddCSLuaFile("cl_events.lua")
AddCSLuaFile("cl_lasers.lua")

function ENT:Initialize()
	self:SetModel( "models/gmod_tower/stage.mdl" )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:PhysicsInit( SOLID_VPHYSICS )

  	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end

function ENT:Start()
	net.Start("StartShow")
		net.WriteEntity(self)
	net.Broadcast()
end

function ENT:ShowTime(delay)
	if delay > 0 then

		net.Start("UpdateShowDelay")
			net.WriteEntity(self)
			net.WriteFloat(delay)
		net.Broadcast()

		return
	end

	if !self.Started then
		self.Started = true
		self:Start()
	end
end

concommand.Add("showtime", function( ply, cmd, args, str )
	if !ply:IsAdmin() then return end

	local delay = tonumber(args[1]) or 0

	for k,v in pairs( ents.FindByClass("stage") ) do
		v:ShowTime(delay)
	end
end)