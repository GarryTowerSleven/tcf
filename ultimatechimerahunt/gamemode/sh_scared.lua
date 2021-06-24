local meta = FindMetaTable( "Player" )
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

if CLIENT then return end

function meta:Scare( t )

	if (self:IsPig() && self:GetNWBool("IsScared")) then return end

	self.UnScareTime = self.UnScareTime or 0

	self:SetNWBool("IsScared",true)
	self:SetNWBool("IsSprintting",false)

	self:StripSaturn()
	self:SetNWBool("HasSaturn",false)

	self:PlaybackRateOV( 1 )

	local num = ( 6.5 + ( ( t * ( 1 - ( self:GetNWInt("Rank") / 5 ) ) ) * .5 ) )
	self.UnScareTime = CurTime() + num

	self:EmitSound( "vo/halloween_scream" .. tostring( math.random( 1, 8 ) ) .. ".mp3", 75, math.random( 94, 105))

end

function meta:UnScare()

	if !self:GetNWBool("IsScared") then return end

	self:SetNWBool("IsScared",false)

	local num = math.Clamp( self:GetNWFloat("Sprint") - .5, 0, 1 )
	self:SetNWFloat("Sprint",num)

	local num = 3.5 + ( 1.5 * ( 1 - ( self:GetNWInt("Rank") / 5) ) )
	self.SprintCooldown = CurTime() + num

end

local function ScareThink()

	for k, v in pairs( player.GetAll() ) do

		if v:GetNWBool("IsScared") then

			if v:GetNWBool("IsTaunting") then
				v:StopTaunting()
			end

			if CurTime() >= v.UnScareTime then
				v:UnScare()
			end

		end

	end

end
hook.Add( "Think", "UC_ScareThink", ScareThink )
