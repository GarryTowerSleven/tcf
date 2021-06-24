---------------------------------
include('shared.lua')
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

local Player = FindMetaTable("Player")

function Player:ReplaceHat(model, index, hatSlot)

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

	if ( id == 14 || id == 21 || id == 22 || id == 23 || id == 24 ) then
		self:SetBodygroup( 0, 0 ) // show hat when we use glasses
	elseif self:GetModel() != "models/player/hatman.mdl" then
		self:SetBodygroup( 0, 1 ) // hide model hat, if it exists
	end

	if hatSlot == SLOT_FACE then
		self.FaceHat:SetModel(model)
	else
		self.Hat:SetModel(model)
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
	end

	// show model hat, if it exists
	self:SetBodygroup( 0, 0 )

	if isFace then
		self.FaceHat, self.OldFaceHat = nil, nil
	else
		self.Hat, self.OldHat = nil, nil
	end
end
