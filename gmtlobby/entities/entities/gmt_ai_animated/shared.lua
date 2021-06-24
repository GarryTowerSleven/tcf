
-----------------------------------------------------

AddCSLuaFile()


ENT.Base 			= "base_anim"

ENT.Type 			= "anim"

ENT.Spawnable		= false

ENT.AdminSpawnable	= true



ENT.Types = {

	"infected",

	"survivor"

}

ENT.Models = {
	"mossman",
	"alyx",
	"p2_chell",
	"zoey",
	"skeleton",
	"faith",
	"zelda",
	"foohysaurusrex",
	"spacesuit",
}

ENT.StartPos = {

	["pigmask1"] = Vector(2320.03125, -6759.322265625, -895.96875),
	["pigmask2"] = Vector(2799.96875, -6978.0244140625, -895.96875),
	["chimera1"] = Vector(2320.03125, -6759.322265625, -895.96875),
	["chimera2"] = Vector(2799.96875, -6978.0244140625, -895.96875),
}

ENT.Angles = {

	["pigmask0"] = Angle(0,180,0),
	["pigmask1"] = Angle(0,0,0),
	["pigmask2"] = Angle(0,180,0),
	["chimera0"] = Angle(0,180,0),
	["chimera1"] = Angle(0,0,0),
	["chimera2"] = Angle(0,180,0),
}

ENT.EndPos = {

	["infected"] = Vector(1064.2440185547, -5861.2783203125, -901.96875),
	["survivor"] = Vector(1064.2440185547, -5861.2783203125, -901.96875),
	["pigmask"] = Vector(2320.03125, -6531.375, -895.96875),
	["pigmask1"] = Vector(2799.96875, -6752.6259765625, -895.96875),
	["pigmask2"] = Vector(2320.03125, -7015.9926757813, -895.96875),
	["chimera"] = Vector(2320.03125, -6531.375, -895.96875),
	["chimera1"] = Vector(2799.96875, -6752.6259765625, -895.96875),
	["chimera2"] = Vector(2320.03125, -7015.9926757813, -895.96875),
	["ballrace"] = Vector(3427.1577148438, -6698.6298828125, -757.74664306641),
}


ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:KeyValue( key, value )
	if key == "type" then
		self:SetNWString("Type",value)
	end
end

function ENT:Initialize()
    self:DrawShadow(false)
end

function ENT:StartPlayback( name )

	if SERVER then return end

	--LocalPlayer():ChatPrint("Starting animation playback")

	if name == "infected" then
		--LocalPlayer():ChatPrint("INFECTED")
		self.Model = ClientsideModel( "models/player/virusi.mdl", RENDER_GROUP_OPAQUE_ENTITY )

		self:SetLoopSequence( "run_all_01" )
		--LocalPlayer():ChatPrint("SET LOOP SEQUENCE")

	end

	if name == "ballrace" then
		self.Model = ClientsideModel( "models/player/" .. self.Models[math.random(1,#self.Models)] .. ".mdl", RENDER_GROUP_OPAQUE_ENTITY )
		self:SetLoopSequence( "run_all_01" )
	end

	if name == "survivor" then
		--LocalPlayer():ChatPrint("SURVIVOR")
		self.Model = ClientsideModel( "models/player/" .. self.Models[math.random(1,#self.Models)] .. ".mdl", RENDER_GROUP_OPAQUE_ENTITY )

		self:SetLoopSequence( "run_all_01" )
		--LocalPlayer():ChatPrint("SET LOOP SEQUENCE")

	end

	if name == "pigmask" then
		--LocalPlayer():ChatPrint("SURVIVOR")
		self.Model = ClientsideModel( "models/uch/pigmask.mdl", RENDER_GROUP_OPAQUE_ENTITY )

		self:SetLoopSequence( "run_scared" )
		--LocalPlayer():ChatPrint("SET LOOP SEQUENCE")

	end

	if name == "chimera" then
		--LocalPlayer():ChatPrint("SURVIVOR")
		self.Model = ClientsideModel( "models/uch/uchimeragm.mdl", RENDER_GROUP_OPAQUE_ENTITY )

		self:SetLoopSequence( "run" )
		--LocalPlayer():ChatPrint("SET LOOP SEQUENCE")

	end



	self.PlayName = name
	--LocalPlayer():ChatPrint("Playname set...")


end



function ENT:SetLoopSequence( seq )



	if not IsValid( self.Model ) then return end



	-- Set the default sequence

	self.Sequence = self.Model:LookupSequence( seq )



	self.Model:ClearPoseParameters()

	self.Model:ResetSequenceInfo()



	self.Model:SetSequence( self.Sequence )

	self.Model:ResetSequence( self.Sequence )

	self.Model:SetCycle( 0.0 )



	self.Model:SetPos( self:GetPos() )

	self.Model:SetAngles( self:GetAngles() )



end



function ENT:Think()

	if self:GetNWString("Type") == "infected" then
			if CurTime() > (self.InfectedDelay or 0) then
			self.InfectedDelay = CurTime() + 10
			self:StartShit("infected")
			timer.Simple(5,function()
				if IsValid(self) then self:StartShit("survivor") end
			end)
		end
	elseif self:GetNWString("Type") == "pigmask" || self:GetNWString("Type") == "chimera" then
		if CurTime() > (self.ANIM_PigDelay or 0) then
			self.ANIM_PigDelay = CurTime() + 10
			if self:GetNWString("Type") == "chimera" then
				timer.Simple(1,function()
					if IsValid(self) then
						self:StartShit(self:GetNWString("Type"))
					end
				end)
			else
				self:StartShit(self:GetNWString("Type"))
			end
		end
	elseif self:GetNWString("Type") == "ballrace" then

		if self.ChangeModel == nil then self.ChangeModel = true end

		if self.ChangeModel then
			self:StartShit("ballrace")
		end
	end

	if not IsValid( self.Model ) then return end

	if self:GetNWString("Type") == "pigmask" || self:GetNWString("Type") == "chimera" then
		self.Model:SetAngles(self.Angles[self.PlayName..tostring(self.State or 0)])
	end

	-- Update sequence

	if self.Sequence then



		if self.Model:GetSequence() != self.Sequence then

			self.Model:SetPlaybackRate( 1.0 )

			self.Model:ResetSequence( self.Sequence )

			self.Model:SetCycle( 0 )

		end



		self.Model:SetPlaybackRate( 1 )



		-- Fixup frame advance

		if !self.Model.LastTick then self.Model.LastTick = CurTime() end

		self.Model:FrameAdvance( CurTime() - self.Model.LastTick )

		self.Model.LastTick = CurTime()



		self:UpdateSequence()



	end



end



function ENT:Draw()



	if not IsValid( self.Model ) then return end



	-- Set pos and angles

	self.Model:SetupBones()



	self:DrawEffects()



end



function ENT:OnRemove()



	if IsValid( self.Model ) then

		self:RemoveModel()

	end



end



function ENT:UpdateSequence()



	if self.PlayName == "infected" or self.PlayName == "survivor" then



		self.Model:SetPoseParameter( "move_x", 1 )

		self:MoveToEndPos( 250 )



	end

	if self.PlayName == "pigmask" || self.PlayName == "chimera" then

		--self.Model:SetAngles(self.Angles[self.PlayName..tostring((self.State or 0))])

		self.Model:SetPoseParameter( "move_x", 1 )

		self:MoveToEndPos( 250 )



	end

	if self.PlayName == "ballrace" then

		--self.Model:SetAngles(self.Angles[self.PlayName..tostring((self.State or 0))])

		self.Model:SetPoseParameter( "move_x", 1 )

		self:MoveToEndPos( 25 )



	end

end



function ENT:MoveToEndPos( speed )



	if not IsValid( self.Model ) then return end



	local pos = self.Model:GetPos()

	if self:GetNWString("Type") == "ballrace" then
		self.Model:SetModelScale(1.75)
		for k,v in pairs(ents.FindByClass("gmt_gmball")) do
			if IsValid(v.Cars[1]) then self.Model:SetPos(v.Cars[1]:GetPos() - Vector(0,0,75)) end
			self.Model:SetAngles(Angle(0,90,0))
			if (v.Cars[1]:GetPos() - Vector(0,0,75)).z < -1100 then self.ChangeModel = true else self.ChangeModel = false end
		end
		return
	end

	local endpos = self.EndPos[self.PlayName]

	if self.State then
		endpos = self.EndPos[self.PlayName..tostring(self.State)]
		if !endpos then endpos = self.EndPos[self.PlayName] end
	end

	pos.x = math.Approach( pos.x, endpos.x, FrameTime()*speed )

	pos.y = math.Approach( pos.y, endpos.y, FrameTime()*speed )

	pos.z = math.Approach( pos.z, endpos.z, FrameTime()*speed )



	self.Model:SetPos( pos )



	-- Remove

	if pos == endpos then

		if self:GetNWString("Type") == "pigmask" || self:GetNWString("Type") == "chimera" then

			if !self.State then self.State = 0 end
			self.State = self.State + 1

			if self.State > 2 then
				self.State = 0
				self.Model:SetPos( self:GetPos() )
				self:RemoveModel()
				return
			end

			self.Model:SetPos( self.StartPos[self.PlayName..tostring(self.State)] )
			self:MoveToEndPos( 250 )

			return
		end

		self:RemoveModel()

	end



end



function ENT:RemoveModel()

	self.Model:Remove()

	self.Model = nil

end



function ENT:DrawEffects()



	local pos = self.Model:GetPos()

	local ang = self.Model:GetAngles()



	if self.PlayName == "infected" then



		local dlight = DynamicLight( self:EntIndex() )

		if ( dlight ) then

			dlight.Pos = pos + Vector( 0, 0, 40 )

			dlight.r = 150

			dlight.g = 255

			dlight.b = 150

			dlight.Brightness = 1

			dlight.Decay = 768

			dlight.Size = 256

			dlight.DieTime = CurTime() + 1

		end



	end



end

function ENT:StartShit(typeid)

	if IsValid( self.Model ) then
		self.Model:Remove()
		self.Model = nil
	end

	self:StartPlayback( typeid )

end
