ENT.Base = "base_brush"
ENT.Type = "brush"

ENT.ExitDelay = 1

function ENT:Initialize()
end

function ENT:StartTouch( ply )

	if !ply:IsPlayer() then return end

	if ply.LastMonoEnter and ply.LastMonoEnter > CurTime() - 1 then return end

	local Monorail = ents.FindByClass("gmt_monorail")[1]

	if IsValid( Monorail ) && Monorail.DoorsOpen then

		ply.LastMonoExit = CurTime()

		ply:SetNWBool( "inMonorail", false )
		ply.DesiredPosition = Monorail:GetPos() - (Monorail.FakeOrigin - ply:GetPos()) + (Monorail:GetUp() * 12) + (Monorail:GetForward() * -10)
	end

end

function ENT:EndTouch( ply )
end

function ENT:Touch()
end

function ENT:KeyValue( key, value )
end

function ENT:AcceptInput( input, activator, ply )

end
