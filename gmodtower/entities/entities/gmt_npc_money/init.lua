AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.MoneyValue = 500

function ENT:Think()
	if self.TaskSequenceEnd == nil then
		self:PlaySequence(nil, "pose_standing_01", nil, 1)
	end
end

function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		timer.Simple( 0.0, function()
			if ply:GetNWBool("MoneyNpcTimeout") then ply:SendLua([[Msg2("Whoa, slow down there! You already got some dosh!")]]) return end
			ply:AddMoney( self.MoneyValue )
			ply:SetNWBool("MoneyNpcTimeout",true)
			timer.Simple(10,function() ply:SetNWBool("MoneyNpcTimeout",false) end)
		end)

    end

end
