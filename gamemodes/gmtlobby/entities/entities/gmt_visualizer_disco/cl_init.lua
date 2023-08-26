include('shared.lua')
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Sprite = Material("sprites/powerup_effects")

function ENT:Initialize()
    self.NextRandomLazers = 0
    self.NextScale = 0.2
    self:GetStream()
end

function ENT:Draw()
    self:DrawModel()
	if !GetConVar("gmt_visualizer_effects"):GetBool() then 
		self:SetColor(Color( 255, 255, 255, 255 ))
		self:SetModelScale( 1, 0 )
		if self.P2 && IsValid(self.P2[1]) then
			self.P2[1]:Remove()
		end
	return end
    local c = colorutil.Rainbow(50 + self.NextScale * 0.1)
    c = HSVToColor(ColorToHSV(c), math.Clamp(self.NextScale * 8, 0, 1), 1)
    self:SetColor(c)
    /*if GTowerMainGui.MenuEnabled then
		self:SetModelScale( 1, 0 )
	end*/
    local size = self.NextScale || .1
    size = size * 4
    render.SetMaterial(self.Sprite)
    self.Sprite:SetFloat("$alpha", self.NextScale)
    render.DrawSprite(self:GetPos(), 64 + (size * 32), 64 + (size * 32), colorutil.Rainbow(50 + self.NextScale * 0.1 || self.NextScale))
    self.Sprite:SetFloat("$alpha", 1)
end

function ENT:InLimit(loc)
    return loc == self:Location()
end

function ENT:OnRemove()
    if self.P2 && IsValid(self.P2[1]) then
        self.P2[1]:Remove()
    end
end

function ENT:Think()
    if self:Location() != LocalPlayer():GetLocation() then return self:OnRemove() end
    local Stream = self:GetStream()
    if !Stream then return end

    // Lasers
    if CurTime() > self.NextRandomLazers || self.NextScale > 0.4 && (!self.NextBass || self.NextBass < CurTime()) then
	if !GetConVar("gmt_visualizer_effects"):GetBool() then return end
		local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())
        effectdata:SetEntity(self)
        effectdata:SetMagnitude(5.0 + math.Rand(-1, 1))
        effectdata:SetNormal(self:GetColor():ToVector())
        util.Effect("disco_light", effectdata)
        self.NextRandomLazers = self.NextScale > 0.4 && CurTime() + 0.1 || CurTime() + 0.25 + math.Rand(-0.15, 0.15) + (2 * (1 - self.NextScale))
        self.NextBass = CurTime() + 0.1
    end

    if !self.NextSpark || self.NextSpark < CurTime() then
        if self.NextScale > 0.5 && GetConVar("gmt_visualizer_advanced"):GetBool() then
            local fx = EffectData()
            fx:SetOrigin(self:WorldSpaceCenter() + VectorRand() * 4)
            fx:SetScale(24)
            util.Effect("firework_npc", fx)
        end

        self.NextSpark = CurTime() + 0.1
    end

    // Visualizers
    self:UpdateStreamVals(Stream)
end

function ENT:UpdateStreamVals(Stream)
    if !self:StreamIsPlaying() then
        self:SetModelScale(1, 0)
        self.NextScale = 0.2

		if self.P2 then
			for _, p in ipairs(self.P2) do
				if IsValid(p) then
					p:Remove()
				end
			end
		end

        return
    end

    local Bands = self:GetFFTFromStream()
    local Max = 0
    local Sum = 0
    local Total = 40

    if Bands[1] then
        for i = 1, Total do
            Max = math.max(Max, Bands[i])
            Sum = Sum + Bands[i]
        end
    end

    local Avg = Sum / Total
    self.NextScale = Lerp(FrameTime() * 8, self.NextScale, Avg * 18/2)
    self.NextScaleS = self.NextScaleS || 0
    self.NextScaleS = Lerp(FrameTime(), self.NextScaleS, self.NextScale)
    //self.NextScale = 0.5 + math.Clamp( ( Avg / Max ) * 0.8, 0, 0.8 )
    //self.NextScale = math.Clamp( self.NextScale, .1, 3 )
    self:SetModelScale(1 + math.Clamp(self.NextScale, 0, 2), 0)
    self:SetRenderAngles(self:GetAngles() + Angle(FrameTime() * 64, FrameTime() * 24, FrameTime() * 64) * self.NextScale)
    self.P2 = self.P2 || {}
    /*self.TP = Location.GetMediaPlayersInLocation( self:Location() )[1]
	if self.TP then
		local e=  self.TP:GetEntity()
		self.TP = e:GetPos() + e:GetForward() * 512
	else*/
    local plys = {}

    for _, ply in ipairs(player.GetAll()) do
        if ply:GetPos():DistToSqr(self:GetPos()) < (1000 * 1000) then
            table.insert(plys, ply:GetPos())
        end
    end

    local avg = Vector(0, 0, 0)

    for i = 1, 3 do
        for _, v in ipairs(plys) do
            local l = i == 1 && v.x || i == 2 && v.y || v.z

            if i == 1 then
                avg.x = avg.x + l
            elseif i == 2 then
                avg.y = avg.y + l
            else
                avg.z = avg.z + l
            end
        end
    end

    avg.x = avg.x / #plys
    avg.y = avg.y / #plys
    avg.z = avg.z / #plys
    self.TP = avg

    // end
    if self.P2[2] then
        self.P2[2]:Remove()
    end

    self.FT = self.FT || 0
    self.FT = self.FT + FrameTime() * self.NextScaleS

    if self.NextScale <= 0.01 then
        self.FT = math.random(-128, 128)
    end

    local function CurTime()
        return self.FT
    end

    for i = 1, 1 do
        local p = self.P2[i]
        self.P2[i] = IsValid(p) and self.P2[i] || ProjectedTexture()
        if !IsValid(p) then return end
        local os = self:EntIndex()
        p:SetTexture("effects/flashlight001")
        p:SetPos(self:WorldSpaceCenter() + ((self.TP) - self:GetPos()):Angle():Forward() * (i == 2 && 24 || 32)) // Vector(0, 0, 96))
        p:SetAngles(((self.TP) - self:GetPos()):Angle() + Angle(math.sin(CurTime() + os) * 8 + 40, math.sin(CurTime() * 2 + os * 80) * 40, math.sin(CurTime() * 0.1 + os) * 180)) // self:GetRenderAngles() + Angle(i == 1 and 180 or 0, 0, 0))
        p:SetFarZ(2000 * self.NextScaleS)
        p:SetNearZ(1 + 0 * self:GetModelScale())
        p:SetBrightness(8 * self.NextScaleS / 2)
        p:SetFOV(120 + 40 * self.NextScaleS)
        p:SetColor(colorutil.Rainbow(50 + self.NextScaleS * 0.1))
		if GetConVar("gmt_visualizer_advanced"):GetBool() then 
			p:SetEnableShadows(true)
		else
			p:SetEnableShadows(false)
		end
        p:Update()
    end

    local e = DynamicLight(self:EntIndex())
    if !e then return end
    e.Pos = self:WorldSpaceCenter()
    e.DieTime = CurTime() + 1
    e.Decay = 1000
    e.Radius = 400
    e.Brightness = self.NextScale * 4
    e.r = self:GetColor().r
    e.g = self:GetColor().g
    e.b = self:GetColor().b
end

MEDIACYCLE = 0.89
CUSTOMTAUNT = true

hook.Add("Think", "DiscoBall", function()
	local ft = LastThink and SysTime() - LastThink or 0
	LastThink = SysTime()

    local mp2 = Location.GetMediaPlayersInLocation(LocalPlayer():Location())[1]
    local mp2
    DISCO = false // Location.GetSuiteID(LocalPlayer():Location()) != 0

	if mp then
		for _, b in ipairs(ents.FindByClass(("gmt_visualizer_disco"))) do
			if b:Location() == LocalPlayer():Location() then
				DISCO = b
			end
		end
	end

    for _, m in ipairs(Location.GetMediaPlayersInLocation(LocalPlayer():Location())) do
        // print(m, m.Entity, m.Entity:GetClass(), !mp)
        if m.Entity && m.Entity:GetClass() == "gmt_jukebox" || !mp then
            mp2 = m
        end
    end

    mp = nil

    if !mp2 then
        MEDIACYCLE = 0.2 + math.fmod(CurTime() * 2, 1.8) * 0.03

        return
    end

    mp2 = mp2:GetMedia()
    if !mp2 then return end
    mp = mp2.Channel
    if !mp then return end
    local b = 0
    local fft = mp2.fft
    if !fft or #fft <= 0 then return end
    station = mp
    local url = tostring(mp)
    url = string.Split(url, "[")
    url = table.concat(url, "[", 2)
    url = string.sub(url, 1, string.len(url) - 1)

    if RHYTHM && string.StartsWith(url, "http") then
        if st != url || !IsValid(station2) && (!lasts || lasts < CurTime()) then
            if station2 then
                station2:Stop()
                station2 = nil
            end

            sound.PlayURL(url, "noplay noblock", function(s)
                station2 = s
            end)

            lasts = CurTime() + 8
            played = false
            st = url
        elseif IsValid(station2) then
            if !played then
                station2:SetTime(mp:GetTime() + 4, true)
                station2:Play()
                station2:SetVolume(0.001)
                justadded = 0
                played = true
            else
                if !t || math.abs(mp:GetTime() - t) > 8 then
                    t = mp:GetTime()
                    played = false
                else
                    t = mp:GetTime()
                end
            end
        end
    end

    local m = 0

    for i = 1, 20 do
        b = b + fft[i]
    end

    for i = 40, 400 do
        m = m + fft[i]
    end

    if b > 1.4 then
        if !DIED || DIED < CurTime() then
            DIED = CurTime() + math.Rand(4, 8)
            DEAD = true
        end
    end

    b = b > 1.2 && b / 20 || b / 22
    m = m / 400
    lerp = lerp || 0
    lerp = Lerp(ft * (2 - b), lerp, math.Clamp(b * 2 + m, 0, 0.14))

	// print((lerp - math.Clamp(b * 2 + m, 0, 0.14)) * 24, ft, lerp, math.Clamp(b * 2 + m, 0, 0.1))
    if !CUSTOMTAUNT && MEDIACYCLE <= 0.01 then
        MEDIACYCLE = 0.01
        DEAD = true
    end

    MEDIACYCLE = math.fmod(MEDIACYCLE + ft * (0.001 + lerp), CUSTOMTAUNT && 1 || 0.9)

    if !CUSTOMTAUNT && MEDIACYCLE <= 0.01 then
        MEDIACYCLE = 0.01
        DEAD = true
    end

	lastThink = SysTime()
end)

local keys = {
    [1] = {},
    [2] = {},
    [3] = {}
}

local delay = {}
local sens = 20

hook.Add("StartCommand", "ply", function(ply, cmd)
    if LocalPlayer():GetNWBool("Dancing") || RHYTHM then
        if cmd:GetForwardMove() != 0 then
            RunConsoleCommand("syncdance", 0)
        end

        cmd:SetButtons(0)
        cmd:SetMouseX(0)
        cmd:ClearMovement()
    end
end)

hook.Add("Think", "t", function()
    if input.IsMouseDown(MOUSE_RIGHT) and LocalPlayer():GetNWBool("Dancing") then
        if !jumptogg then
            // RHYTHM = RHYTHM == nil and true or !RHYTHM
			DEATH = !DEATH
			if !RHYTHM then
				// if IsValid(station2) then
					// station2:Stop()
					// station2 = nil
					// keys[2] = {}
				// end
			end

            jumptogg = true
        end
    else
        jumptogg = false
    end

    if !RHYTHM then
        if IsValid(station2) then
            station2:Stop()
        end

        return
    end

    local fft = {}
    if !IsValid(station2) then return end
    station2:FFT(fft, FFT_2048)
    if #fft <= 0 then return end
    local b = 0

    for i = 1, 40 do
        b = b + fft[i]
    end

    b = b / 40
    if !IsValid(station) then return end
    local t = station:GetTime()
    if justadded && justadded > t then return end

    if b * sens < 0.7 then
        sens = sens + FrameTime() * 2
    else
        sens = sens - FrameTime() * 24
    end

    sens = math.min(sens, 20)

    if b * sens > 0.7 && (!delay[2] || delay[2] < t) then
        // chat.AddText("DOWN!")
        LocalPlayer():EmitSound("buttons/button01.wav")
        table.insert(keys[2], {t + 4, b * sens})
        delay[2] = t + 0.1
        sens = sens - FrameTime() * 24
    end

    local m = 0

    for i = 600, 800 do
        m = m + fft[i]
    end

    m = m / 300
    local m4 = 0

    for i = 40, 800 do
        m4 = m4 + fft[i]
    end

    if sens == 20 then
        b = b + m4

        if b > 2 && (!delay[2] || delay[2] < t) then
            chat.AddText("DOWN!")
            LocalPlayer():EmitSound("buttons/button01.wav")
            table.insert(keys[2], {t + 4, b})
            delay[2] = t + 0.2
        end
    end

    if CLIENT then return end

    if m * 4000 > 2 && (!delay[1] || delay[1] < t) then
        if m * 4000 > 2 then
            table.insert(keys[m4 > 0.8 && 1 || 1], {t + 4})
            delay[1] = t + 0.2
        end

        if m4 > 1.2 && (!delay[3] || delay[3] < t) then
            table.insert(keys[3], {t + 4})
            delay[3] = t + 0.2
        end

        justadded = t + 0.001
    end

    if m4 * 0.8 > 1 && (!delay[3] || delay[3] < t) then
        table.insert(keys[3], {t + 4})
        delay[3] = t + 0.2
    end
end)

local rating = 0
local keydown = {}
local active = {}
local glow = Material("sprites/powerup_effects")
local grad = Material("vgui/gradient_up")
local VignetteMat = Material("gmod_tower/halloween/vignette")
local rhythmgame = GetRenderTarget("RHYTHM24822", 1024, 512)
local rg = CreateMaterial("RHYTHMGAME24822224", "UnlitGeneric", {["$basetexture"] = rhythmgame:GetName(), ["$translucent"] = 0, ["$vertexalpha"] = 1})

hook.Add("HUDPaint", "DiscoBall", function()
    if !mp then return end
    if !IsValid(station) then return end
    if !lerp then return end
    if !DISCO then return end
    // DrawMotionBlur(Lerp(math.min(lerp * 20, 1), 0.8, 0.4), 1, 0.001)
    surface.SetMaterial(VignetteMat)
    c = colorutil.Rainbow(50 + lerp * 0.1) || HSVToColor(MEDIACYCLE * 360, 1, 0.4)
    c.a = lerp * 2555 / 8
    c.a = math.min(c.a, 255)
	if GetConVar("gmt_visualizer_advanced"):GetBool() then
		DrawBloom(0, 2 * lerp, 1, 1, 1, 2, c.r / 255, c.g / 255, c.b / 255)
	end
    surface.SetDrawColor(c)
    surface.DrawTexturedRect(-ScrW() * 0.1, -ScrH() * 0.1, ScrW() * 1.2, ScrH() * 1.2) // ScrH() - 128, ScrW(), 256)
    if !RHYTHM then return end
	
	cam.Start2D()
	render.PushRenderTarget(rhythmgame)
	render.SetWriteDepthToDestAlpha(true)
	render.OverrideAlphaWriteEnable(true, true)
	render.Clear(0, 0, 0, 0, true, true)
    local t = station:GetTime()
    surface.SetMaterial(grad)
    surface.SetDrawColor(HSVToColor(MEDIACYCLE * 360, 1, 0.2))
    surface.DrawTexturedRect(0, 0, 512, 256)
    draw.SimpleTextOutlined("RHYTHM GAME - Jump", "GTowerHUDMain", 264, ScrH() - 90 - 2, HSVToColor(MEDIACYCLE * 360, 1, 1), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, c)
    surface.SetMaterial(glow)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(128, 0 - 0 - 8 - lerp * 128, 16, 256 + lerp * 256)

    if input.IsMouseDown(MOUSE_LEFT) then
        surface.DrawTexturedRect(ScrW() / 2 - 8 - 128 - 24, ScrH() - 378 - 8 - lerp * 128, 64, 512 + lerp * 256)
    end

    for i = 2, 3 do
        // draw.SimpleText(i == 2 and "V" or i, "DermaLarge", ScrW() / 2, ScrH() / 2 - 32, Color(255, 255, 255, 40), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local b = BASS

        if !active[i] then
            if keys[i][1] && keys[i][1][1] > t then
                active[i] = keys[i][1][1]
            end
        end

        local key = keys[i]

        for _, key in ipairs(key) do
            //print(key[1], "!!!!!!")
            if !key[1] then continue end

            if key[1] > t then
                local l = key[1] - t
                l = l / 4
                key[2] = key[2] || math.random(-2, 2)
                key[2] = math.Clamp(math.sin(key[2]) * 8, -32, 32)

                if !key[3] then
                    // key[2] = math.random(4) == 1 and -key[2] or key[2]
                    key[3] = true
                end

                // draw.SimpleText(i == 2 and "V" or i, "DermaLarge", ScrW() / 2 + i * 64, ScrH() / 2 - 32, Color(255, 255, 255, l * 255))
                // draw.SimpleText(i == 2 and "V" or i, "DermaLarge", ScrW() / 2, ScrH() / 2 - 400 * l, Color(255, 255, 255, (1 - l) * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                surface.SetMaterial(glow)
                surface.SetDrawColor(HSVToColor(math.fmod(key[1] * 128, 360), 1, 1))
                surface.DrawTexturedRect(128 - 64 + 400 * l, 128 - 32 + key[2] * 1, 64, 64)
                surface.SetDrawColor(color_white)
                surface.DrawTexturedRect(128 - 64 + 400 * l + 16, 128 - 16 + key[2] * 1, 32, 32)

                if l <= 0.08 then
                    // keys[i][_] = nil
                    table.remove(keys[i], _)
                    active[i] = nil
                    // chat.AddText("Removing")
                end

                if active[i] && active[i] != key[1] then continue end
                if l >= 0.14 then continue end
                local k = i == 2 && MOUSE_LEFT || i == 1 && KEY_A || KEY_D

                if input.IsMouseDown(k) || l <= 0 then
                    if !keydown[k] || l <= 0 then
                        keydown[k] = true
                        table.remove(keys[i], _)
                        active[i] = nil
                        chat.AddText(tostring(l))
                        SetClipboardText(l)

                        if l >= 0.05 && l <= 0.1 then
                        else
                            rating = rating - 1
                            chat.AddText(tostring(l))
                        end
                    end
                else
                    keydown[k] = false
                end
            end
        end
    end
		render.OverrideAlphaWriteEnable(false, false)
	render.PopRenderTarget(rhythmgame)
	cam.End2D()

	surface.SetMaterial(rg)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(ScrW() / 2 - 256, ScrH() - 256, rg:Width() * 2, rg:Height() * 2)

    draw.SimpleText(rating, "DermaLarge", ScrW() / 2, ScrH() / 2, color_white)
end)

hook.Add("UpdateAnimation", "DiscoBall", function(ply)
    if ply:GetNWBool("dancing") then
        if ply == LocalPlayer() then
			ply:SetRenderAngles(ply.RenderAngle or angle_zero)
            DanceLight = IsValid(DanceLight) && DanceLight || ProjectedTexture()

            if IsValid(DanceLight) then
                DanceLight:SetPos(ply:GetPos() + Vector(0, 0, 128))
                DanceLight:SetAngles(Angle(90, 0, 0))
                DanceLight:SetTexture("effects/flashlight001")
                DanceLight:SetFarZ(128)
                DanceLight:SetBrightness(!DISCO && 8 || lerp * 40)
                DanceLight:SetEnableShadows(true)
                c2 = !DISCO && color_white || colorutil.Rainbow(50 + lerp * 0.1) || HSVToColor(MEDIACYCLE * 360, 1, 0.4)
                c2.a = lerp * 2555 / 8
                c2.a = !DISCO && 255 || math.min(c2.a, 255)
                DanceLight:SetColor(c2)
                DanceLight:Update()
            end
        end

        local os = util.SharedRandom(ply:EntIndex(), 0, 1)
        local c = !mp && 0 || math.fmod(MEDIACYCLE + os, CUSTOMTAUNT && 1 || 0.9)

        if mp then
            c = !CUSTOMTAUNT && c <= 0.01 && c + 0.01 || c

            if c <= 0.8 then
                if !ply.Danced then
                    // ply.Dance = ply:SelectWeightedSequenceSeeded(ply:GetNWInt("dance", ACT_GMOD_TAUNT_DANCE), math.random(99999999))
                    ply.Danced = true
                end
            else
                ply.Danced = false
            end

            // ply:SetCycle(c || 0.4 + math.sin(CurTime() * 2) * 0.1)
        end

        if !ply.DanceSeq or !ply.Dance or ply.DanceCycle and ply.DanceCycle > 0.9 then // !ply.DanceTime or ply.DanceTime < CurTime() then
            ply.Dance = ply:SelectWeightedSequenceSeeded(ply:GetNWInt("dance", ACT_GMOD_TAUNT_DANCE), math.random(99999999))
            ply.DanceSeq = ply.DanceSeq == GESTURE_SLOT_ATTACK_AND_RELOAD and GESTURE_SLOT_CUSTOM or GESTURE_SLOT_ATTACK_AND_RELOAD
            ply.DanceTime = CurTime() + ply:SequenceDuration(ply.Dance) - 0.4
            ply.DanceCycle = 0
        end

        ply.DanceCycle = ply.DanceCycle or 0
		lerp = lerp or 0.1
        ply.DanceCycle = math.fmod(ply.DanceCycle + FrameTime() * (mp and 0.001 + lerp or 0.1), 1)

        ply:AddVCDSequenceToGestureSlot(ply.DanceSeq or GESTURE_SLOT_CUSTOM, CUSTOMTAUNT && ply.Dance || ply:LookupSequence("taunt_dance_base"), ply.DanceCycle || mp && c || ply:GetCycle(), true)

        local other = ply.DanceSeq == GESTURE_SLOT_ATTACK_AND_RELOAD and GESTURE_SLOT_CUSTOM or GESTURE_SLOT_ATTACK_AND_RELOAD
        ply:SetLayerWeight(other, 1 - (ply.DanceCycle / 0.1))
        ply:SetLayerWeight(ply.DanceSeq, (ply.DanceCycle / 0.1))

        return ACT_GMOD_TAUNT_DANCE, -1
    else
        if ply == LocalPlayer() then
			if IsValid(DanceLight) then
				DanceLight:Remove()
			end

			ang = ply:EyeAngles()
				
			DEAD = true
			lerpv = nil
        end

		ply.RenderAngle = ply:EyeAngles()


        ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
    end
end)

hook.Add("CalcMainActivity", "DiscoBall", function(ply)
    if ply:GetNWBool("dancing") then
        ply.Dance = ply.Dance || ply:SelectWeightedSequence(ply:GetNWInt("dance", ACT_GMOD_TAUNT_DANCE), -1)

        return ACT_HL2MP_IDLE, -1
    end
end)

DEATH = true

hook.Add("ForceThirdperson", "Dancing", function(ply)
	if ply:GetNWBool("dancing") and !DEATH then return true end
end)

hook.Add("CalcView", "DiscoBall", function(ply, pos, ang)
    if !ply:GetNWBool("dancing") then return end
	if !DEATH then return end
    local ragdoll = ply
    dang = dang || math.random(0, 180)
    ang = Angle(30, dang, 0)
    local hitpos = LerpVector(0.5, ragdoll:WorldSpaceCenter(), ragdoll:GetAttachment(1).Pos)
    local filter = player.GetAll()
    table.insert(filter, ragdoll)
    local zoom = math.Remap(util.QuickTrace(hitpos, Vector(0, 0, 512), ragdoll).HitPos:Distance(hitpos), 0, 512, 128, 512)
    local min = Vector(8, 8, 8)

    dtr = dtr || util.TraceHull({
        start = hitpos,
        endpos = hitpos + ang:Forward() * (-math.random(-256, -128)),
        filter = filter,
        mins = -min,
        maxs = min,
        mask = MASK_SHOT_HULL
    })

    if DEAD || dt && dt < CurTime() || !dtrans && lerpv && (lerpv:DistToSqr(hitpos) < 128 || util.TraceLine({
        start = lerpv,
        endpos = hitpos,
        filter = filter,
        mask = MASK_SHOT_HULL
    }).HitPos:DistToSqr(hitpos) > 64) then
        local r = dtr.r

        dtr = util.TraceHull({
            start = hitpos,
            endpos = hitpos + Angle(math.random(-20, 65), math.random(-180, 180), 0):Forward() * math.random(-256, -128),
            filter = filter,
            mins = -min,
            maxs = min,
            mask = MASK_SHOT_HULL
        })

        DEAD = false

        if math.random(2) == 1 then
            lerpv = nil
            lerpa = nil
            lerpf = nil
        else
            dtrans = true
            dtr.r = r
        end

        /*if math.random(4) == 1 then
					lerpv = ply:GetAttachment(1).Pos
					dtrans = false
					face = true
					else
						face = false
				end*/
        dt = CurTime() + math.Rand(8, 12)
    end

    dtr.r = dtr.r || math.random(-16, 16)
    lerpv = lerpv || dtr.HitPos

    if dtrans then
        if lerpv:DistToSqr(dtr.HitPos) < 64 then
            dtrans = false
        end

        lerpv = LerpVector(FrameTime() * 0.4, lerpv, dtr.HitPos)
    end

    lerpa = lerpa || (hitpos - lerpv):Angle() + AngleRand() * 0.01

    if face then
        lerpv = LerpVector(FrameTime() * 2.4, lerpv, ply:GetAttachment(1).Pos + ply:GetAttachment(1).Ang:Forward() * 64)
        lerpa = LerpAngle(FrameTime() * 4, lerpa, (ply:GetAttachment(1).Pos - lerpv):Angle())
    else
        lerpa = LerpAngle(FrameTime() * 12, lerpa, (hitpos - lerpv):Angle())
    end

	lerp = !mp and 1 or lerp
    lerpa.r = dtr.r
    lerpf = lerpf || 25
    lerpf = Lerp(FrameTime() * 0.4, lerpf, Lerp(dtr.HitPos:Distance(hitpos) / 256, 64, 32 / 2))
    pos = lerpv - lerpa:Forward() * lerp * 8
    ang = lerpa
    fov = lerpf - lerp * -8

    return {
        origin = pos,
        angles = ang,
        fov = fov,
        drawviewer = true
    }
end)