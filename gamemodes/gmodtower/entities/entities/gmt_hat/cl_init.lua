include('shared.lua')

function ENT:Initialize()
	self:SetLegacyTransform( true ) -- Because they suck
end

function ENT:InitOffset()
	self.OffsetTable = GTowerHats.DefaultValue
end

local function GetHeadPos( ent )

	if !IsValid( ent ) then return end

	local Head = ent:LookupBone( "ValveBiped.Bip01_Head1" )

	if !Head then return ent:GetPos() + Vector( 0, 0, 64 ) end

	local pos, ang = ent:GetBonePosition( Head )

	if !ent:IsPlayer() then return pos end

	if ent.GetBallRaceBall && IsValid( ent:GetBallRaceBall() ) then
		return ent:GetBallRaceBall():GetPos() + Vector( 0, 0, 64 )
	end

	return pos

end

function ENT:PositionItem(ent)
	if !IsValid(ent) then return end

	local eyes = ent:LookupAttachment( GTowerHats.HatAttachment )
	local EyeTbl = ent:GetAttachment( eyes )

	local pos, ang, scale

	if !EyeTbl then
		if ent:GetModel() == "models/uch/mghost.mdl" then
			local head = ent:LookupBone("head")

			if head then
				pos, ang = ent:GetBonePosition(head)
			end
		else
			return
		end
	else
		pos, ang = EyeTbl.Pos, EyeTbl.Ang
	end

	if engine.ActiveGamemode() == "minigolf" then
		local ball = ent:GetGolfBall()
		pos, ang, scale = hook.Run("PositionHatOverride", ball)
	end
	local s = ent:GetManipulateBoneScale(ent:LookupBone("ValveBiped.Bip01_Head1") or 0)
	local modelscale = ent:GetModelScale()
	if !IsLobby && engine.ActiveGamemode() != "ballrace" then modelscale = 1 end
	local Offsets
	if engine.ActiveGamemode() == "minigolf" then
		Offsets = GTowerHats:GetTranslation( self:GetNWString("HatName"), "minigolf" )
	else
		Offsets = GTowerHats:GetTranslation( self:GetNWString("HatName"), self.PlyModel )
	end

	if engine.ActiveGamemode() != "minigolf" then
		ang:RotateAroundAxis(ang:Right(), Offsets[2][1])
		ang:RotateAroundAxis(ang:Up(), Offsets[2][2])
		ang:RotateAroundAxis(ang:Right(), Offsets[2][3])
	end

	local HatOffsets = ang:Up() * Offsets[1][1] * (1 + ((1 - s.z) * 0)) + ang:Forward() * Offsets[1][2] + ang:Right() * Offsets[1][3]

	HatOffsets.x = HatOffsets.x * modelscale
	HatOffsets.y = HatOffsets.y * modelscale
	HatOffsets.z = HatOffsets.z * modelscale

	pos = pos + HatOffsets

	if GTowerHats.FixScales[self.HatModel] then
        scale = Offsets[3] * modelscale + math.sqrt(s.z - 1) / 2
		return pos, ang, scale
	else
		scale = Offsets[3] * modelscale * s.z 
		return pos, ang, scale
    end
end

function ENT:UpdatedModel(ply)
	local PlyModel = string.lower( ply:GetModel() )
	local HatModel = self:GetModel()

	local PlayerId = GTowerHats:FindPlayerModelByName( PlyModel )
	local HatId = GTowerHats:FindByModel( HatModel ) or ""

	self.PlyModel = PlayerId
	self.HatModel = HatId
	self.OffsetTable = GTowerHats:GetTranslation( self:GetNWString("HatName"), self.PlyModel )

	self:SetModelScale( self.OffsetTable[3] * ply:GetModelScale() )
end



// debug:
/*
concommand.Add("gmt_printhatoffsets", function()

	for _, ent in pairs( ents.FindByClass("gmt_hat") ) do
		local ply = ent:GetOwner()

		if IsValid( ply ) then

			local PlyModel =  string.lower( ply:GetModel() )
			local HatModel = ent:GetModel()
			local PlyModel2 = string.sub( PlyModel, 1, 7 ) .. "player" .. string.sub( PlyModel, 7 )

			local PlayerId = GTowerHats:FindPlayerModelByName( PlyModel )
			local HatId = GTowerHats:FindByModel( HatModel ) or ""

			//self.OffsetTable = table.Copy( GTowerHats:GetTranslation( self.HatModel, self.PlyModel ) )
			local eyes = ply:LookupAttachment( GTowerHats.HatAttachment )
			local EyeTbl = ply:GetAttachment( eyes )
			if !EyeTbl then
				return
			end
			local pos, ang = EyeTbl.Pos, EyeTbl.Ang

			local scale = ply:GetModelScale()
			local Offsets = GTowerHats:GetTranslation( HatId, PlayerId )

			ang:RotateAroundAxis(ang:Right(), Offsets[4])
			ang:RotateAroundAxis(ang:Up(), Offsets[5])
			ang:RotateAroundAxis(ang:Right(), Offsets[6])

			Msg( ply , " (", ply:GetModelScale() ,")\n")
			Msg("\t", PlayerId, " - ", PlyModel, "\n" )
			Msg("\t", HatId, " - ", HatModel, "\n" )
			Msg("\tOffsetTable: ", Offsets[1] ," - ", Offsets[2] ," - ", Offsets[3] ,"\n")

		end

	end

end )*/
