AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:UpdateModel()
	self:SetModel( self.Model )
	self:SetSubMaterial(1,self.Material)
	self:ResetSequence("idle_all_01")
end

function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		timer.Simple( 0.0, function()
			GTowerStore:OpenStore( ply, 16 )
			if math.random(1,2) == 1 then
				self:EmitSound("vo/compmode/cm_spy_matchwon_08.mp3",80)
			else
				self:EmitSound("vo/spy_Revenge01.mp3",80)
			end
		end)


    end

end
