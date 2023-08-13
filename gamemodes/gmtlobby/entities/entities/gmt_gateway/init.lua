---------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "TurtleUse" )

function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Use( activator )

	if activator:IsPlayer() then
	
		if activator.TurtleList == nil then activator.TurtleList = {} end
		if activator.Delay == nil then activator.Delay = CurTime() end
		if activator.TurtleNumber == nil then activator.TurtleNumber = 0 end
		
		if activator.Delay <= CurTime() then
			activator.Delay = CurTime() + 3
			
			if self.TurtleNumber == 6 && activator.TurtleNumber == 6 then
				activator.TurtleNumber = 0
				net.Start( "TurtleUse" )
					net.WriteBool( true )
					net.WriteEntity( self )
				net.Send( activator )
				// Pt 2
				timer.Simple(0.25, function()
					activator:SetNWBool("Outside", true)
					GAMEMODE:SetPlayerSpeed( activator, 100, 100 )
					activator:SetModel("models/player/group01/male_01.mdl")
					activator:StripWeapons()
					activator:SafeTeleport( Vector(15880, 16225, 6335 ))
				end)
			elseif self.TurtleNumber == 1 && activator.TurtleNumber == 0 then
				activator.TurtleNumber = 2
				net.Start( "TurtleUse" )
					net.WriteBool( true )
					net.WriteEntity( self )
				net.Send( activator )
			elseif self.TurtleNumber == activator.TurtleNumber then	
				activator.TurtleNumber = activator.TurtleNumber + 1
				net.Start( "TurtleUse" )
					net.WriteBool( true )
					net.WriteEntity( self )
				net.Send( activator )
			else
				activator.TurtleNumber = 0
				net.Start( "TurtleUse" )
					net.WriteBool( false )
					net.WriteEntity( self )
				net.Send( activator )
			end
			
		end
	end
end

function ENT:KeyValue( key, value )

	if key == "door" then
		self.TurtleNumber = tonumber(value)
	end

end

hook.Add("PlayerDeath", "RemoveEffects", function( ply )

	if ply:GetNWBool("Outside") then

		ply:SetNWBool("Outside", false)
		ply:SetNWBool("ForceModel", false)
		ply:ConCommand( "gmt_updateplayermodel" )

	end

end )
