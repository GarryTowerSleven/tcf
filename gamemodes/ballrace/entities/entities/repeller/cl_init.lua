include('shared.lua')

local activeSounds = {}

usermessage.Hook("br_electrify", function(um)
	local repeller = um:ReadEntity()
	local ball = um:ReadEntity()
	local link = um:ReadBool()
	
	if !IsValid(repeller) || !IsValid(ball) then return end
	
	if !ball.Links then
		ball.Links = {}
	end
	
	if link && ball.Links then
		ball.Links[repeller] = true
		local edata = EffectData()
		
		edata:SetOrigin(repeller:LocalToWorld(repeller:OBBCenter()))
		edata:SetEntity(ball)
		edata:SetAttachment(repeller:EntIndex())
		
		util.Effect("lightning", edata)
		
		repeller:EmitSound("gmodtower/virus/ui/accept.wav", 100, 100)
		
		if !repeller.Sound then
			repeller.Sound = CreateSound( repeller, "gmodtower/zom/weapons/flamethrower/idle.wav" )
			repeller.Sound:PlayEx( 1, 150 )
			
			activeSounds[repeller] = ball
		end
	else
		ball.Links[repeller] = false
		
		if repeller.Sound then
			repeller.Sound:FadeOut( .25 )
			repeller.Sound = nil
			
			activeSounds[repeller] = nil
		end
	end
end)

hook.Add("Think", "RepellerSoundThink", function() 
	for repeller, ball in pairs(activeSounds) do
		if IsValid(repeller) and not IsValid(ball) and repeller.Sound then
			repeller.Sound:FadeOut( .25 )
			repeller.Sound = nil
		end
	end
end)