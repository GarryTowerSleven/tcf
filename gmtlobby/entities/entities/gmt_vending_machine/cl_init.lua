
-----------------------------------------------------
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()

	-- Store the soundscape we started in, it'll be our little home
	-- Unfortunately, we can't insert the soundscape here as ent:OnRemove() is called more than it should
	self.HumSoundscape = soundscape.GetSoundscape(GTowerLocation:FindPlacePos( self:GetPos() ))

	-- Create the soundinfo table
	self.SoundInfo = {
		type = "playlooping",
		volume = 0.30,
		position = self,
		soundlevel = 150,
		sound = { self.Sound, 10}, }
end

function ENT:Think()

	-- This doesn't need to poll very often
	if self.NextThinkTime and self.NextThinkTime > RealTime() then return end
	self.NextThinkTime = RealTime() + 5


	-- Define our hum soundscape only if it isn't defined already
	if self.HumSoundscape and soundscape.IsDefined(self.HumSoundscape) and not soundscape.HasRule(self.HumSoundscape, tostring(self)) then

		-- Add our hum to the soundscape system
		soundscape.AppendRuleDefinition(self.HumSoundscape, self.SoundInfo, tostring(self))
	end
end


function ENT:OnRemove()
	if not self.HumSoundscape then return end

	-- Remove our hum from the soundscape system
	soundscape.AppendRuleDefinition(self.HumSoundscape, nil, tostring(self))
end

function ENT:Draw()
	self:DrawModel()
	self2 = self
	--self:DrawTranslucent()
end

hook.Add("StoreFinishBuy", "PlayBuySound", function()
	if GTowerStore.StoreId == 17 then
		self2:EmitSound("gmodtower/stores/purchase_vending.wav")
	end
end )

/*function ENT:DrawTranslucent()
	local NPCNAME = self.PrintName

	local offset = Vector( 0, 0, 110 )

	local ang = LocalPlayer():EyeAngles()
	local pos = self:GetPos() + offset + ang:Up() * ( math.sin( CurTime() ) * 4 )

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.14 )
		draw.DrawText( NPCNAME, "GTowerNPC", 2, 2, Color( 0, 0, 0, 225 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.DrawText( NPCNAME, "GTowerNPC", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end*/
