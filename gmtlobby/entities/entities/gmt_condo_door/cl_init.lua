
-----------------------------------------------------
include("shared.lua")



ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

surface.CreateFont( "CondoNameText", { font = "Verdana", size = 80, weight = 500 } )

surface.CreateFont( "CondoTagText", { font = "Oswald", size = 80, weight = 800 } )



local nameplateModel = "models/map_detail/condo_nameplate_mid.mdl"

local nameplateCapModel = "models/map_detail/condo_nameplate_cap.mdl"

local maxNameSize = 800



function ENT:CreateNamePlate()



	if not self.NamePlate then

		self.NamePlate = ClientsideModel(nameplateModel)

		self.NamePlate:SetNoDraw(true)

	end



	if not self.NamePlateCapLeft then

		self.NamePlateCapLeft = ClientsideModel(nameplateCapModel)

		self.NamePlateCapLeft:SetNoDraw(true)

	end



	if not self.NamePlateCapRight then

		self.NamePlateCapRight = ClientsideModel(nameplateCapModel)

		self.NamePlateCapRight:SetNoDraw(true)

	end



end



function ENT:RemoveNamePlate()

	if self.NamePlate then self.NamePlate:Remove() end

	if self.NamePlateCapLeft then self.NamePlateCapLeft:Remove() end

	if self.NamePlateCapRight then self.NamePlateCapRight:Remove() end



	self.NamePlate = nil

	self.NamePlateCapLeft = nil

	self.NamePlateCapRight = nil

end


function ENT:GetPlayer()
  return GtowerRooms:Get( self:GetCondoID() ).Owner
end

function ENT:Think()



	if self:GetCondoID() == 0 then return end



	if not IsValid( self:GetPlayer() ) then

		self:RemoveNamePlate()

		return

	end



	self:CreateNamePlate()



	if not self._Name or self._Name ~= self:GetPlayer():GetName() then

		self._Name = self:GetPlayer():GetName()

	end



end



function ENT:OnRemove()

	self:RemoveNamePlate()

end



function ENT:GetNameText()



	local name = self._Name or "Player"

	name = stringmod.RestrictStringWidth( name, "CondoNameText", maxNameSize )

	return name



end



function ENT:GetTagText()



	local room = self:GetCondo()



	if IsValid( room.Owner ) then

		if CondoNames[room.Owner] then
			return CondoNames[room.Owner]
		end
		
		return "LOADING"
	end



end



function ENT:GetTextSize()



	surface.SetFont("CondoNameText")

	local tw, th = surface.GetTextSize( self:GetNameText() )

	return tw, th

end



local _nameplatematrix = Matrix()

function ENT:DrawNamePlate(bonemtx)



	local tw, th = self:GetTextSize()



	local nameplatescale = tw / 320 + 0.1

	local mtx = _nameplatematrix

	mtx:Set(bonemtx)

	mtx:Scale(Vector(nameplatescale,1,1))

	self.NamePlate:EnableMatrix("RenderMultiply", mtx)



	mtx:Set(bonemtx)

	mtx:Translate(Vector(8*nameplatescale,0,0))

	self.NamePlateCapLeft:EnableMatrix("RenderMultiply", mtx)



	mtx:Set(bonemtx)

	mtx:Translate(Vector(-8*nameplatescale,0,0))

	mtx:Scale(Vector(-1,-1,1))

	self.NamePlateCapRight:EnableMatrix("RenderMultiply", mtx)



	self.NamePlate:DrawModel()

	self.NamePlateCapLeft:DrawModel()

	self.NamePlateCapRight:DrawModel()

end



local _plateoffset = Vector(24,-55,1.5)

local _3d2doffset = Vector(0,0,.25)

function ENT:DrawTranslucent()



	self:DrawModel()



	if self:GetCondoID() == 0 then return end

	if not self.NamePlate or not self.NamePlateCapLeft or not self.NamePlateCapRight then return end



	local mtx = self:GetBoneMatrix( 1 )

	if mtx then

		local v = mtx:ToTable()



		--align bone matrix for plate components

		mtx:SetField(1,1,v[1][1])

		mtx:SetField(2,1,v[2][1])

		mtx:SetField(3,1,v[3][1])

		mtx:SetField(1,2,-v[1][3])

		mtx:SetField(2,2,-v[2][3])

		mtx:SetField(3,2,-v[3][3])

		mtx:SetField(1,3,v[1][2])

		mtx:SetField(2,3,v[2][2])

		mtx:SetField(3,3,v[3][2])



		--translate plate location

		mtx:Translate(_plateoffset)



		self:DrawNamePlate(mtx)



		--push out a bit for 3D2D

		mtx:Translate(_3d2doffset)



		--rotate that shit

		local ang = mtx:GetForward():Angle()

		ang:RotateAroundAxis(mtx:GetForward(), 90)

		ang:RotateAroundAxis(mtx:GetRight(), 180)



		cam.Start3D2D( mtx:GetTranslation(), ang, .05 )



			pcall(function()

				local text = self:GetNameText()

				draw.SimpleText( text, "CondoNameText", 0, 0, Color( 98 * 2, 68 * 2, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end)



		cam.End3D2D()

	end



	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)

	ang:RotateAroundAxis(ang:Right(), 270)



	local pos = self:GetPos()

	pos = pos + self:GetForward() * 55

	pos = pos + self:GetUp() * 145



	cam.Start3D2D( pos, ang, .3 )



		pcall(function()

			local text = self:GetTagText()

			if text then

				draw.SimpleText( text, "CondoTagText", 0, 0, Color( 220, 230, 230 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end

		end)



	cam.End3D2D()



end