// BORROWED FROM RESORT: https://discord.gg/PtCv5yB

if !IsLobby then return end

resort = {}

emotes = {
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/fire_1f525.png",name="Fire"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/thinking-face_1f914.png",name="Thinking"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/heavy-black-heart_2764.png",name="Heart"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/ok-hand-sign_1f44c.png",name="OK-Hand"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/loudly-crying-face_1f62d.png",name="Crying-Loudly"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/aubergine_1f346.png",name="Eggplant"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/splashing-sweat-symbol_1f4a6.png",name="Sweat"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/sleeping-symbol_1f4a4.png",name="isleep"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/face-with-tears-of-joy_1f602.png",name="xD"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/twitter/154/pouting-face_1f621.png",name="Rage-Face"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/240/twitter/248/sleeping-face_1f634.png", name = "sleeping"},
	{img="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/240/twitter/248/yawning-face_1f971.png", name="yawning"},
	{img="https://i.imgur.com/TFawhmn.png", name="monkey"},
}

--[[
-- rendering moved to cl_animselector and effect
if CLIENT then
	for _,em in pairs(emotes) do
		CasinoKit.getRemoteMaterial(em.img, function(mat)
			em.mat = mat
		end, true)		
	end
end
]]

resort.LookupEmote = function(name)
	for k,data in pairs(emotes) do
		if data.name == name then
			return k
		end
	end	
	return -1
end

local plymeta = FindMetaTable("Entity")

if SERVER then
	
	util.AddNetworkString("RunEmote")
	
	function plymeta:RunEmote(sprite)
		if self:IsPlayer() then
			net.Start("RunEmote")
				net.WriteEntity(self)
			net.Broadcast()	
		end	
		timer.Simple(0.75,function()
			if IsValid(self) then
				local pos = self:EyePos() + self:GetForward() * 30 - Vector(0,0,5)
				if not self:IsPlayer() then
					pos = self:EyePos() + self:GetForward() * 30 + Vector(0,0,15)
				end
				/*if self:IsPlayer() and !Location.IsTheater( self:Location() ) then -- no emote noise in cinema
					URLSound3D("http://188.226.142.121/assets/emote.ogg",pos)
				end*/
				local effectdata = EffectData()
				effectdata:SetOrigin( pos )
				effectdata:SetAngles( Angle(0,0,0))
				effectdata:SetAttachment(sprite)
				effectdata:SetRadius(1)
				util.Effect( "emoji", effectdata )
			end
		end)		
		hook.Call("PlayerEmoteRun",GAMEMODE,self,sprite)
	end

	-- make this more complicated if abused, idk
	util.AddNetworkString("RequestEmote")
	net.Receive("RequestEmote",function(len,ply)
		if Location.IsArcade( ply:Location() ) then return end
		
		local sprite = net.ReadUInt(4)
		ply.lastEmote = ply.lastEmote or 0
		if CurTime() > ply.lastEmote + 0.8 then
			ply.lastEmote = CurTime()
			ply:RunEmote(sprite)
		end	
	end)
	
end	

if CLIENT then
	net.Receive("RunEmote",function(len)
		local ply = net.ReadEntity()
		if IsValid(ply) then
			ply:AnimRestartGesture( 0, ACT_GMOD_GESTURE_ITEM_GIVE, true )
		end	
	end)
	
	function plymeta:RequestEmote(sprite)
		net.Start("RequestEmote")
			net.WriteUInt(sprite,4)
		net.SendToServer()
	end	
	
    concommand.Add("emote_request", function( ply, cmd, args )
		if !args[1] then return end
		if !tonumber(args[1]) then return end
		if tonumber(args[1]) > #emotes || tonumber(args[1]) < 1 then return end

		ply:RequestEmote(args[1])
	end)
end