ENT.Type 				= "anim"
ENT.Base 				= "base_anim"

ENT.Model				= Model( "models/map_detail/condo_panel.mdl" )

ENT.IsMediaPlayerEntity = true

ENT.scr_offsety			= -1.13
ENT.scr_width			= 37
ENT.scr_height			= 21.15
ENT.ui_scale			= 0.03
ENT.max_use_dist		= 64

-- Dimensions
ENT.Width			= ENT.scr_width / ENT.ui_scale
ENT.Height			= ENT.scr_height / ENT.ui_scale
ENT.HalfWidth 		= ENT.Width/2
ENT.HalfHeight 		= ENT.Height/2

--8.288495
--14.371841

function ENT:PhysicsUpdate() end
function ENT:PhysicsCollide(data,phys) end

function ENT:MakeEyeTrace(ply)

	local pos = ply:GetShootPos()
	local aim = GetMouseAimVector()
	local pnormal = self:GetRight()
	local porigin = self:GetPos()

	local a = (porigin - pos):Dot(pnormal)
	local b = aim:Dot(pnormal)
	local v = self:WorldToLocal( pos + aim * ( a / b ) )

	local mx = v.x / self.ui_scale
	local my = ( -v.z - self.scr_offsety ) / self.ui_scale

	local visible = ( b < 0 and math.abs(a) < self.max_use_dist and math.abs( mx ) <= self.HalfWidth and math.abs( my ) <= self.HalfHeight )

	mx = mx + self.HalfWidth
	my = my + self.HalfHeight

	return mx, my, visible

end

function ENT:OSInit()

	self.instance = panelos.createOSInstance( self )
	self.instance:Launch("homescreen")

end

function ENT:Think()

	if self.instance then

		--print(self:EntIndex() .. " (" .. (SERVER and "SERVER" or "CLIENT") .. ") Thinkd: " .. tostring(self.instance:Current(true)))
		self.instance:Think()

	end

end

function ENT:Sound( sound )

	self:EmitSound( sound, 60 )

end

function ENT:GetCondoID()

	if not self.CondoID then
		self.CondoID = (Location.Find(self:GetPos()))
	end

	return self.CondoID
	
end

function ENT:GetCondo()

	local condoid = self:GetCondoID()
	return GTowerRooms:Get( condoid )

end

function ENT:GetCondoMediaPlayer()

	local condo = self:GetCondo()
	if not condo then return end

	if IsValid( condo.RefEnt ) then
		return condo.RefEnt:GetMediaPlayer()
	end

end

hook.Add( "PhysgunPickup", "CondoPanelGrab", function( ply, ent )

	if ent:GetClass() == "gmt_condo_panel" then return false end

end )
