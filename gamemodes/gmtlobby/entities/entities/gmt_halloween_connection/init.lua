util.AddNetworkString("open_halloween")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel( self.Model )
	self:SetUseType( SIMPLE_USE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetTrigger( true )
	self:UseTriggerBounds( true, 60 )
	self:SetPos( Vector( -419.450562, -1002.996887, 32.621159 ) )
	self:SetAngles( Angle( 0, 90, 0 ) )
	self:DrawShadow( false )

	self:CacheDoors()

end

function ENT:Use( ply )

	net.Start( "open_halloween" )
	net.Send( ply )

end

local doors = {}
ENT.Toggled = false
ENT.Opener = NULL

function ENT:CacheDoors()

	for k,v in pairs( ents.FindInSphere( self:GetPos(), 80 ) ) do
		if v:GetClass() != "func_door" then continue end

		doors[k] = v
		v:SetSaveValue( "m_flWait", -1 )
	end

end

function ENT:ControlDoors( toggle )

	for k,v in pairs( doors ) do
		if IsValid( v ) then
			v:Fire( toggle )
		end
	end

end

function ENT:StartTouch( ply )

	if !ply:IsPlayer() then return end

	if self.Toggled != true then
		self.Opener = ply
		self:ControlDoors( "Open" )
		self.Toggled = true
	end

end

function ENT:EndTouch( ply )

	if !ply:IsPlayer() then return end

	if IsValid( self.Opener ) then
		if ply == self.Opener then
			self:ControlDoors( "Close" )
			self.Toggled = false
		end
	end

end
