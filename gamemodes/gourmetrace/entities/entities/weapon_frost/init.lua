AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:CustomInit()

	self:SetPos( self:GetPos() + Vector(0,0,10) )
	self:SetAngles( self:GetAngles() + Angle(0,-90,0) )

end

function ENT:CustomTouch( ply )

	timer.Create( "ForceWalk"..ply.EntIndex(), 0.1, 50, function() // Try making players go slow or be slippery in Gourmet Race. It won't work...

		if IsValid( ply ) && !ply:GetNet( "Invincible" ) then
			ply:SetPos(ply:GetPos()-Vector(5,0,0))
		end

	end )

end
