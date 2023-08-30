function SetModelScaleVector( ent, scale )

	if !IsValid( ent ) then return end

	local scalefix = Matrix()
	scalefix:Scale( scale )

	ent:EnableMatrix( "RenderMultiply", scalefix )

end

function DrawModelMaterial( ent, scale, material )

	// start stencil
	render.SetStencilEnable( true )
	
	// render the model normally, and into the stencil buffer
	render.ClearStencil()
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilWriteMask( 1 )
	render.SetStencilReferenceValue( 1 )
	
		// render model
		/*ent:SetModelScale( 1, 0 )
		ent:SetupBones()
		ent:DrawModel()*/
	
	// render the outline everywhere the model isn't
	render.SetStencilReferenceValue( 0 )
	render.SetStencilTestMask( 1 )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	
	// render black model
	render.SuppressEngineLighting( true )
	render.MaterialOverride( material )
	
		// render model
		ent:SetModelScale( scale, 0 )
		ent:SetupBones()
		ent:DrawModel()
		
	// clear
	render.MaterialOverride()
	render.SuppressEngineLighting( false )
	
	// end stencil buffer
	render.SetStencilEnable( false )

end

local meta = FindMetaTable("Entity")

function meta:SetPlayerProperties( ply )

	if !IsValid( ply ) then return end

	if !self.GetPlayerColor then
		self.GetPlayerColor = function() return ply:GetPlayerColor() end
	end

	self:SetBodygroup( ply:GetBodygroup(1), 1 )
	self:SetMaterial( ply:GetMaterial() )
	self:SetSkin( ply:GetSkin() or 1 )

	if self.MinecraftMat then
		self:SetMaterial( self.MinecraftMat )
	end

end

hook.Add("PostPlayerDraw", "ties", function(ply)
	if ply:GetModel() ~= "models/player/macdguy.mdl" then
		if ply.TiePhysics then
			for i = 0, ply:GetBoneCount() - 1 do
				ply:ManipulateBoneAngles(i, angle_zero)
			end

			ply.TiePhysics = nil
		end
	
		return
	end

	ply.TiePhysics = ply.TiePhysics and math.Clamp(ply.TiePhysics, -32, 32) or 0
	ply.TiePhysics2 = ply.TiePhysics2 or 0

	ply.TiePhysics3 = ply.TiePhysics3 or 0
	ply.TiePhysics4 = ply.TiePhysics4 or 0

	local ang = ply:EyeAngles().y
	if ply.TiePhysics2 ~= ang then
		ply.TiePhysics = ply.TiePhysics + math.NormalizeAngle(ply.TiePhysics2 - ang) / 4
		ply.TiePhysics2 = ang
	end

	if ply.TiePhysics4 ~= ply:EyeAngles().p then
		ply.TiePhysics3 = ply.TiePhysics3 + math.NormalizeAngle(ply.TiePhysics4 - ply:EyeAngles().p) / 4
		ply.TiePhysics4 = ply:EyeAngles().p
	end

	local d = ply:GetVelocity():Dot(ply:GetRight())
	ply.TiePhysics = ply.TiePhysics + d * 0.004
	local d = ply:GetVelocity():Dot(ply:GetForward())
	ply.TiePhysics3 = ply.TiePhysics3 + d * -0.2


	local m = (math.abs(ply.TiePhysics) / 32) * 32
	ply.TiePhysics = (ply.TiePhysics < 0 and ply.TiePhysics + FrameTime() * m or ply.TiePhysics > 0 and ply.TiePhysics - FrameTime() * m or 0)

	local m = (math.abs(ply.TiePhysics3) / 32) * 64
	ply.TiePhysics3 = (ply.TiePhysics3 < 0 and ply.TiePhysics3 + FrameTime() * m or ply.TiePhysics3 > 0 and ply.TiePhysics3 - FrameTime() * m or 0)

	for i = 0, ply:GetBoneCount() - 1 do
		if string.find(ply:GetBoneName(i), "Tie") then
			ply:ManipulateBoneAngles(i, Angle(ply.TiePhysics, Lerp(0 or ply:EyeAngles().p / -90, Lerp(ply:EyeAngles().p / 90, 2.5 + math.sin(CurTime() * 2) * 1, 3), -0), -ply.TiePhysics))
		end
	end
end)

local limit = 4
local glow = Material("cable/redlaser")
local glow2 = Material("sprites/glow04_noz")

hook.Add("Think", "Wesker", function()
	for _, ply in ipairs(player.GetAll()) do
		if ply:GetModel() ~= "models/player/re/albert_wesker_overcoat_pm.mdl" then continue end

		local pos = ply:GetAttachment(1)
		ply.Eyes = ply.Eyes or {{}, {}}
	
		if !ply.LastEyes2 or ply.LastEyes2 < SysTime() then
			table.remove(ply.Eyes[1], limit + 1)
			table.remove(ply.Eyes[2], limit + 1)

			if ply:GetVelocity():Length2D() < 64 or math.abs(math.NormalizeAngle(ply:EyeAngles().y - ply:GetVelocity():Angle().y)) > 90 then
				// table.insert(ply.Eyes[1], 1, pos.Pos + pos.Ang:Forward() * 0 + pos.Ang:Up() * 0.5 + pos.Ang:Right() * 1)
				// table.insert(ply.Eyes[2], 1, pos.Pos + pos.Ang:Forward() * 0 + pos.Ang:Up() * 0.5 - pos.Ang:Right() * 1.25)
			else
				table.remove(ply.Eyes[1], 1)
				table.remove(ply.Eyes[2], 1)
			end

			ply.LastEyes2 = SysTime() + 0.01
		end
	
	end
end)

hook.Add("PostPlayerDraw", "Wesker", function(ply)
	if ply:GetModel() ~= "models/player/re/albert_wesker_overcoat_pm.mdl" then return end
	local pos = ply:GetAttachment(1)
	ply.Eyes = ply.Eyes or {{}, {}}

	if !ply.LastEyes or ply.LastEyes < SysTime() then
		table.remove(ply.Eyes[1], limit + 1)
		table.remove(ply.Eyes[2], limit + 1)

		if ply:GetVelocity():Length2D() < 64 or math.abs(math.NormalizeAngle(ply:EyeAngles().y - ply:GetVelocity():Angle().y)) > 90 then
			table.insert(ply.Eyes[1], 1, pos.Pos + pos.Ang:Forward() * 0 + pos.Ang:Up() * 0.5 + pos.Ang:Right() * 1)
			table.insert(ply.Eyes[2], 1, pos.Pos + pos.Ang:Forward() * 0 + pos.Ang:Up() * 0.5 - pos.Ang:Right() * 1.25)
		end

		ply.LastEyes = SysTime() + 0.01
	end

	render.SetMaterial(glow)
	glow:SetVector("$color2", Vector(1, 0.9, 0))

	render.StartBeam(#ply.Eyes[1])
	local color = Color(124, 72, 0, 100)
	for _, e in ipairs(ply.Eyes[1]) do
		render.AddBeam(e, 1 - (_ / (#ply.Eyes[1])), 1 - (_ / (#ply.Eyes[1])), color)
	end
	render.EndBeam()

	render.StartBeam(#ply.Eyes[2])
	for _, e in ipairs(ply.Eyes[2]) do
		render.AddBeam(e, 1 - (_ / (#ply.Eyes[2])), 1 - (_ / (#ply.Eyes[2])), color)
	end
	render.EndBeam()

	render.SetMaterial(glow2)
	color = Color(255, 150, 0)
	color.a = 8
	render.DrawSprite(pos.Pos + pos.Ang:Forward() * 0.4 + pos.Ang:Up() * 0.5 + pos.Ang:Right() * 1, 2, 2, color)
	render.DrawSprite(pos.Pos + pos.Ang:Forward() * 0.4 + pos.Ang:Up() * 0.5 + pos.Ang:Right() * -1.25, 2, 2, color)
	//render.DrawBeam()
end)