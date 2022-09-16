---------------------------------
include('shared.lua')
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

local Player = FindMetaTable("Player")

function Player:ReplaceHat(hatname, model, index, hatSlot)

	if hatSlot == SLOT_HEAD && IsValid(self.Hat) then
		self.OldHat = self.Hat:GetModel()
	elseif hatSlot == SLOT_FACE && IsValid(self.FaceHat) then
		self.OldFaceHat = self.FaceHat:GetModel()
	elseif hatSlot == SLOT_FACE then
		self.FaceHat = ents.Create("gmt_hat")

		self.FaceHat:SetOwner(self)
		self.FaceHat:Spawn()
	else
		self.Hat = ents.Create("gmt_hat")

		self.Hat:SetOwner(self)
		self.Hat:Spawn()
	end

	local id = index

	/*if ( id == 14 || id == 21 || id == 22 || id == 23 || id == 24 ) then
		self:SetBodygroup( 0, 0 ) // show hat when we use glasses
	end*/

	local owner = self.Hat or self.FaceHat
	local bodygroup = GTowerHats:GetBodyGroups(player_manager.TranslateToPlayerModelName( owner:GetOwner():GetModel() ), hatname, hatSlot)
	
	print( player_manager.TranslateToPlayerModelName( owner:GetOwner():GetModel() ) )
	if bodygroup then
		if hatSlot == SLOT_FACE then 
			self.FaceHat:GetOwner():SetBodygroup( bodygroup[1], bodygroup[2] ) // hide model hat, if it exists
		elseif hatSlot == SLOT_HEAD then
			self.Hat:GetOwner():SetBodygroup( bodygroup[1], bodygroup[2] ) // hide model hat, if it exists
		end
	end

	// skins
	local hatskin = 0

	local hatData = GTowerHats.Hats[id]
	if hatData && hatData.ModelSkin then
		hatskin = hatData.ModelSkin
	end

	if hatSlot == SLOT_FACE then
		self.FaceHat:SetModel(model)
		self.FaceHat:SetSkin(hatskin)
		self.FaceHat:SetNWString("HatName", hatname)
	else
		self.Hat:SetModel(model)
		self.Hat:SetSkin(hatskin)
		self.Hat:SetNWString("HatName", hatname)
	end
end

function Player:ReturnHat()
	if !IsValid(self.Hat) then return end

	if !self.OldHat then
		self.Hat:Remove()
		return
	end

	self.Hat:SetModel(self.OldHat)

	self.OldHat = nil
end

function Player:RemoveHat( isFace )
	--if (isFace && !IsValid(self.FaceHat)) or (!isFace && !IsValid(self.Hat)) then return end

	if isFace && IsValid( self.FaceHat ) then
		self.FaceHat:Remove()
	elseif IsValid( self.Hat ) then
		self.Hat:Remove()
		self:SetBodygroup( 0, 0 )
	end

	// show model hat, if it exists
	// self:SetBodygroup( 0, 0 )

	if isFace then
		self.FaceHat, self.OldFaceHat = nil, nil
	else
		self.Hat, self.OldHat = nil, nil
	end
end