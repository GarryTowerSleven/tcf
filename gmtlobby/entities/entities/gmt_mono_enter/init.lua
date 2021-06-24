ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
end

function ENT:StartTouch( ply )
	if !ply:IsPlayer() then return end

	if ply.LastMonoExit and ply.LastMonoExit > CurTime() - 1 then return end

	local Monorail = ents.FindByClass("gmt_monorail")[1]

	if IsValid( Monorail ) then
		if !Monorail.DoorsOpen then return end

		ply.LastMonoEnter = CurTime()

		ply:SetNWBool( "inMonorail", true )
		ply.DesiredPosition = Monorail.FakeOrigin - (Monorail.StartPostion - ply:GetPos())
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
