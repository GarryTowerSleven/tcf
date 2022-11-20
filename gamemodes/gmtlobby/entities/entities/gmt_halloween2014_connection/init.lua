include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow(false)
end

local NextUse = 0
function ENT:Use( ply )
	if CurTime() < NextUse then return end
	NextUse = CurTime() + 1

	SendUserMessage( "OpenHalloweenConnection", ply )
end