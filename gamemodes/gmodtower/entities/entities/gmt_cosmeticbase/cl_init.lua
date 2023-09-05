include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.LastModel = ""
ENT.LastPlayerModel = ""
ENT.LastScale = Vector(0,0,0)
ENT.MaxDist = 800

function ENT:Initialize()
	self:SetRenderBounds( Vector(-60, -60, -60), Vector(60, 60, 60) )
	self:DrawShadow(false)

	self:InitOffset()
end

function ENT:InitOffset()
end

function ENT:Think()

	local ply = self:GetOwner()
	if !IsValid(ply) then return end

	local color = ply:GetColor()

	self:SetColor( color )

	if color.a < 255 then
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
	else
		self:SetRenderMode( RENDERMODE_NORMAL )
	end

	self:SetMaterial( ply:GetMaterial() )

	if self.PlayerEquipIndex == 0 then
		self:AddToEquipment()
	end

	self:NextThink(CurTime() + 0.1)

end

// Torochan
local mat = Material("models/gmod_tower/hats/toro_mask")
local mat2 = CreateMaterial("Torochan2", "UnlitGeneric", {
	["$basetexture"] = "models/gmod_tower/hats/toro_mask",
	["$ignorez"] = 1
})

// FIXME: This should be called when needed. I know, I love sourcemod's arrays.
local RTs = {}

for i = 1, game.MaxPlayers() do
	RTs[i] = GetRenderTarget("Torochan" .. i, mat:Width(), mat:Height())
end

local emotions = {
	["happy"] = {0, 0},
	["happy_talk"] = {1, 0},
	["talking"] = {2, 0},
	["talking_talk"] = {3, 0},
	["shout"] = {0, 1},
	["shout_talk"] = {1, 1},
	["pain"] = {2, 1},
	["pain_talk"] = {3, 1},
	["pensive"] = {0, 2},
	["pensive_talk"] = {1, 2},
	["excited"] = {3, 2},
	["excited_talk"] = {2, 2},
	["sad"] = {0, 3},
	["sad_talk"] = {1, 3},
	["bored"] = {2, 3},
	["bored_talk"] = {3, 3}
}

local emotions2 = {
	[EMOTION_HAPPY] = "happy",
	[EMOTION_ANGRY] = "shout",
	[EMOTION_BORED] = "bored",
	[EMOTION_SLEEPY] = "pensive",
	[EMOTION_WASTED] = "excited",
	[EMOTION_SAD] = "sad",
	[EMOTION_PAIN] = "pain"
}

local pos, ang, scale = nil, nil, nil
function ENT:Draw()

	local ply = self:GetOwner()
	if !IsValid( ply ) || !self:ShouldDraw( ply ) then return end

	pos, ang, scale = self:Position( ply )
	if !pos then return end

	if Emotions then
		if self:GetModel() == "models/gmod_tower/hats/toro_mask.mdl" then
			local emotion = ply:GetEmotion()
			local rt = RTs[ply:EntIndex()]

			if self.LastEmotion != emotion then

				hook.Add("PreRender", self, function()
					hook.Remove("PreRender", self)
					cam.Start2D()
					render.PushRenderTarget(rt)
					render.Clear(255, 255, 255, 255)
					surface.SetMaterial(mat2)
					surface.SetDrawColor(color_white)
					local emotion = "happy"
					local emotion2 = ply:GetEmotion()
					emotion = emotions2[emotion2] or "happy"
					emotion = emotions[emotion]
					local x, y = emotion[1], emotion[2]
					x = (x * mat:Width() / 4) / mat:Width()
					y = (y * mat:Width() / 4) / mat:Width()
					surface.DrawTexturedRectUV(0, 0, mat2:Width() * 1.9, mat2:Height(), x, y, 1 + x, 1 + y)
					render.PopRenderTarget()
					cam.End2D()
				end)
				
				self.LastEmotion = emotion
			end

			mat:SetTexture("$basetexture", rt:GetName())
		elseif self:GetModel() == "models/gmod_tower/catears.mdl" then
			local emotion = ply:GetEmotion()
			local p = emotion == EMOTION_SLEEPY && -50 || emotion == EMOTION_SAD && -40 || emotion == EMOTION_PAIN && -20 || 0
			self.Pitch = self.Pitch or 0
			self.Pitch = math.Approach(self.Pitch, p, FrameTime() * 64)
			p = self.Pitch
			pos = pos + ang:Forward() * p * 0.025
			ang:RotateAroundAxis(ang:Right(), p)
		end
	end

	self:SetPos( pos )
	self:SetAngles( ang )
	self:SetModelScale( scale or 1, 0 )
	self:DrawModel()

	if engine.ActiveGamemode() == "minigolf" then
		local ball = ply:GetGolfBall()
		if IsValid(ball) then
			self:SetNoDraw(true)
		else
			self:SetNoDraw(false)
		end
	end
end

hook.Add( "PostPlayerDraw", "DrawHats", function(ply, flags)
	if engine.ActiveGamemode() == "minigolf" then return end
	if not ply.CosmeticEquipment then return end

    for _, v in pairs(ply.CosmeticEquipment) do
		if ( not v.Draw ) then continue end
        v:Draw()
    end
end )

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Position( ply )

	local override = hook.Call( "OverrideHatEntity", GAMEMODE, ply )
	if override then
		ply = override
	end

	if ply.Alive && !ply:Alive() then
		ply = ply:GetRagdollEntity()
	end

	return self:PositionItem( ply )

end

function ENT:ShouldDraw( ply, dist )

	if !IsValid( ply ) then return false end

	if IsLobby then

		if ( ply:GetNWBool( "InLimbo" ) ) then return false end

		// Hide for distance
		local dist = LocalPlayer():EyePos():Distance( self:GetPos() )
		if dist > self.MaxDist then
			return false
		end

	else

		// Hide for gamemode stuff
		if hook.Call( "ShouldHideHats", GAMEMODE, ply ) then
			return false
		end

	end

	if ply == LocalPlayer() then

		if GAMEMODE.DrawHatsAlways || (GAMEMODE.ShouldDrawLocalPlayer && GAMEMODE:ShouldDrawLocalPlayer( ply )) || hook.Call( "ShouldDrawLocalPlayer", GAMEMODE, ply ) then
			return true
		end

		if ThirdPerson && !ThirdPerson.ShouldDraw then
			return false
		end

		if ply.ThirdPerson || ply.ViewingSelf then
			return true
		end

		return false

	end

	return true

end

-- ENT.PositionItem is replaced in child entities
function ENT:PositionItem( ent )
	return false
end

local PlayerMeta = FindMetaTable("Player")

// manual drawing for ballrace!
function PlayerMeta:ManualEquipmentDraw()
 	if !self.CosmeticEquipment then return end

	for k,v in pairs(self.CosmeticEquipment) do
		if IsValid( v ) then
			if v.DrawTranslucent then // really crappy computers can't handle drawing
				v:DrawTranslucent()
			end
			local scale = 1
			if v.getHatScale then
				scale = v:getHatScale()
			end
			v:SetModelScale( scale, 0 )
		end
	end
end

function PlayerMeta:ResetEquipmentScale()
 	if !self.CosmeticEquipment then return end

	for k,v in pairs(self.CosmeticEquipment) do
		if IsValid( v ) then
			v:SetModelScale( self:GetModelScale(), 0 )
		end
	end
end