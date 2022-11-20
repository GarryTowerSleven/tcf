
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.SpinSpeed = 20

local IsWatchingFish = false

function ENT:Initialize()
    self:ResetSequenceInfo()
		self:SetSequence( "idle" )
end

function ENT:Draw()
	self:DrawModel()
	self:FrameAdvance(FrameTime())
end

hook.Add( "HUDPaint", "DopefishBox", function()
	if IsWatchingFish then
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.DrawRect(0,0,ScrW(),ScrH()/8)
		surface.DrawRect(0,ScrH() - (ScrH()/8),ScrW(),(ScrH()/8))
	end
end)

hook.Add( "CalcView", "DopefishCutscene", function()
	if IsWatchingFish then

		local fish = ents.FindByClass("gmt_dopefish")[1]

		if !IsValid(fish) then return end

		local view = {}

		view.origin = fish:GetPos() + (fish:GetRight() * 125) + (fish:GetForward() * -120)
		view.angles = -fish:GetAngles() + Angle(0,45,0)
		view.fov = 25
		view.drawviewer = false

		return view
	end
end )

local Flenghts = {
	[1] = 8,
	[2] = 5,
	[3] = 5,
	[4] = 8,
	[5] = 10,
	[6] = 9,
	[7] = 10,
	[8] = 9,
	[9] = 10,
	[10] = 11,
}

net.Receive( "fishTalk", function()
	local hasAchi = net.ReadBool()

	IsWatchingFish = true

	local snd = math.random(2,10)

	if !hasAchi then
		surface.PlaySound("gmodtower/voice/dopefish/fish1.mp3")
		snd = 1
	else
		surface.PlaySound("gmodtower/voice/dopefish/fish"..snd..".mp3")
	end

	timer.Simple( Flenghts[snd] + 1, function()
		IsWatchingFish = false
	end)

end )
