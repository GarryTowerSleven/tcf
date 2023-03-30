
-----------------------------------------------------
include("shared.lua")

function ENT:Draw()
	--self:SetRenderBounds(Vector(-9999,-9999,-9999), Vector(9999,9999,9999))
	--self:Debug()
end

function ENT:ShowTrajectory(start, vel, color)

	for t=1, 80 do

		local t0 = (t-1) / 10
		local t1 = (t) / 10
		local p0,v0 = self:EvalTrajectory(t0, start, vel)
		local p1,v1 = self:EvalTrajectory(t1, start, vel)

		render.DrawLine(p0, p1, color, true)
		--debugoverlay.Line(p0, p0 + v0, .1, Color(0,255,0), false)

	end

end

function ENT:Debug()
	local dir = self:GetTrajectory(self:GetPos())
	local target = self:GetTargetEntity()

	debugoverlay.Line(self:GetPos(), self:GetPos() + Vector(0,0,100), .1, Color(255,0,0), true)
	debugoverlay.Line(self:GetPos(), target:GetPos(), .1, Color(255,0,0), true)

	self:ShowTrajectory(self:GetPos(), dir, Color(255,255,0))
end

net.Receive( "launchpad_msg", function(len)

	local b = net.ReadBit()
	local ent = net.ReadEntity()
	local ply = net.ReadEntity()
	local t = net.ReadFloat()

	if not IsValid(ent) or not IsValid(ply) then return end

	if b == 1 then if ent.OnPlayerTouch then ent:OnPlayerTouch(ply, t) end
	else ent:OnStopPlayer(ply, t) end

end )
