include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()

	-- Store the soundscape we started in, it'll be our little home
	-- Unfortunately, we can't insert the soundscape here as ent:OnRemove() is called more than it should
	self.HumSoundscape = soundscape.GetSoundscape(self:Location())

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


hook.Add("StoreFinishBuy", "PlayBuySound", function()
	if GTowerStore.StoreId == GTowerStore.VENDING then
		self2:EmitSound("gmodtower/stores/purchase_vending.wav")
	end
end )