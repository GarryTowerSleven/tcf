include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
end




    function createObama2(pos, ang, z, z2, vel)
        z = z or 24
        local obama = ents.CreateClientside("gmt_minigame_obama")
        obama:SetPos(pos)
		obama:SetModel("models/gmod_tower/obamacutout.mdl")
        // local z = 24

        obama.CutOut = {1, (z / 64) * 64, (z2 or 1)}
        obama:SetAngles(ang)
        obama:Spawn()
        obama:PhysicsInitBox(Vector(0, -6, z), Vector(4, 4, z2 == -1 and 0 or 72))
        obama:PhysWake()

        obama:GetPhysicsObject():SetVelocity(vel * 0.1)
        obama:GetPhysicsObject():SetAngleVelocity(Vector(math.random(-100, 100), z2 == 1 and -400 or 100, 0))

        timer.Simple(3, function()
            obama:Remove()
        end)
    end

    net.Receive("ObamaSmashed", function()
        local pos, ang = net.ReadVector(), net.ReadAngle()
        local z = net.ReadVector().z
		local vel = net.ReadAngle():Forward() * 128
        print(z)
        createObama2(pos, ang, z, 1, vel)
        createObama2(pos, ang, z, -1, vel)
    end)


    function ENT:Draw()

            if self.CutOut then
                render.EnableClipping(true)
                render.PushCustomClipPlane(self:GetUp() * self.CutOut[3], self:GetUp():Dot(self:GetPos() + self:GetUp() * self.CutOut[2]) * self.CutOut[3])
                self:DrawModel()
                render.PopCustomClipPlane()
                render.EnableClipping(false)
            else
                self:DrawModel()
            end
    end
