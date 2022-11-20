function EFFECT:Init(data)
	self.RemoveTime = CurTime() + 1.5

	local rnd = (VectorRand() * math.Rand(-20, 20));
	rnd.z = 0;
	local pos = (data:GetOrigin() + Vector(0, 0, 4) + rnd);
	local vel = data:GetStart();
	local num = data:GetAngles();
	local nummin, nummax = num.p, num.y;
	local size = data:GetScale();
	local norm = data:GetNormal();
	local push = data:GetMagnitude();
	local em = ParticleEmitter(pos);

	for i = 1, math.random(1, 2) do
		local part = em:Add("particles/smokey", pos);
		local size = math.random(2,4)
		if (part) then
			part:SetColor(255, 210, 255, 255);
			local fan = (1);
			part:SetVelocity(Vector(0,0,-10))
			part:SetDieTime(math.Rand(.5, 1.5));
			part:SetLifeTime(0);
			part:SetStartSize(20);
			part:SetEndSize((0));
			part:SetStartAlpha(255);
			part:SetEndAlpha(0);
			part:SetBounce(0);
			part:SetCollide(false);
			part:SetGravity(Vector(0, 0, -10 ));
			part:SetAirResistance(50);
			part:SetAngleVelocity(Angle(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)));
			part:SetLighting(false);
		end
	end
	em:Finish()

end

function EFFECT:Think() if CurTime() >= self.RemoveTime then return true end end

function EFFECT:Render() end
