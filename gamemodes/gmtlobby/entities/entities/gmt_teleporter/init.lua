AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal
	
	local ent = ents.Create( "gmt_teleporter" )
	ent:SetPos( SpawnPos )	
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize()
	self.Entity:SetModel( self.Model )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(true)

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end	
	
	if Location then
		--local LocalPosition = self:Location()
		local LocalPosition = Location.Find( self:GetPos() )
		
		if LocalPosition then 
			Location.AddEnt( self, LocalPosition )
		end
	else
		self:Remove()
	end
	
end

local NextTeleportTime = {}
util.AddNetworkString( "Teleport" )

concommand.Add("gmt_cteleporter", function( ply, cmd, args )

	if #args != 2 || !Location then
		return
	end
	
	local index = ply:EntIndex()
	
	if (NextTeleportTime[ index ] or 0.0 ) > CurTime() then
		return
	end
	
	local ent = ents.GetByIndex( tonumber( args[1] ) )
	
	if !IsValid( ent ) || ent:GetClass() != "gmt_teleporter" then
		return
	end
	
	if ply:GetPos():Distance(ent:GetPos()) > 32 then
		return
	end

	local target = tonumber( args[2] )
	
	if !target || !Location.TeleportLocations[ target ] then
		return
	end

	net.Start( "Teleport" )
	net.WriteVector( ply:EyePos() )
	net.WriteAngle( ply:EyeAngles() )
	net.Send( ply )

	Location.TeleportPlayer( ply, ent, target )

	ent:EmitSound("ambient/machines/teleport4.wav", 65, 100)

	timer.Simple(0.1, function()
	
		for _, e in ipairs( ents.FindByClass("gmt_teleporter") ) do
		
			if e:GetPos():Distance( ply:GetPos() ) < 24 then
	
				e:EmitSound("ambient/machines/teleport" .. table.Random({1, 4}) .. ".wav", 65, 100)
	
			end
	
		end
	
	end)

	NextTeleportTime[ index ] = CurTime() + 1.0

end )