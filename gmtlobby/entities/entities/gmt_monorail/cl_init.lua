
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	self:DrawModel()
end

hook.Add("Think", "MonorailThink", function()
	if !Monorail && IsValid( ents.FindByClass("gmt_monorail")[1] ) then
		Monorail = ents.FindByClass("gmt_monorail")[1]
	end

	for k,v in pairs(player.GetAll()) do
		if v:GetNWBool("inMonorail") && !v.MonorailModel then
			v.MonorailModel = fakeclientmodel.CreateFake(v)
		end

		if v.MonorailModel && !v:GetNWBool("inMonorail") then
			v.MonorailModel:Remove()
			v.MonorailModel = nil
		end
	end

end)

hook.Add("PostDrawOpaqueRenderables","DrawFakeMonorailPlayers",function()

	for k,v in pairs(player.GetAll()) do
		if IsValid(v.MonorailModel) then

			if v == LocalPlayer() && !v.ThirdPerson then continue end

			local newPos = Monorail:GetPlayerOffset( v ) - (Monorail:GetUp() * 70)
			local ang = Monorail:GetAngles()
			ang.z = 0

			fakeclientmodel.Draw( v.MonorailModel, newPos, v:GetAngles() + ang, v:GetModelScale() )
			fakeclientmodel.UpdateFakeAnimation( v, v.MonorailModel, 1 )
		end
	end
end)

hook.Add( "CalcView", "MonoView", function( ply, pos, angles, fov )

  if !ply:GetNWBool("inMonorail") || !IsValid(Monorail) || ply.ThirdPerson then return end

	local newVec = Monorail:GetPlayerOffset( ply )

  local ang = Monorail:GetAngles()
  ang.z = 0

	local view = {
		origin = newVec,
		angles = ang + angles,
		fov = fov
	}

	return view
end )
