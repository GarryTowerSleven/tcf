if !IsLobby then return end

if SERVER then

util.AddNetworkString("urlsound")
util.AddNetworkString("urlsound3d")
util.AddNetworkString("urlsound3dpl")

FindMetaTable("Player").URLSound = function(self, url, pbr)
    net.Start("urlsound")
    net.WriteString(url)
    net.WriteFloat(pbr or 1)
    net.Send(self)
end

FindMetaTable("Entity").URLSound3D = function(self, url, tag)
    net.Start("urlsound3dpl")
    net.WriteEntity(self)
    net.WriteString(url)
    net.WriteString(tag or "")
    --net.Broadcast()
    net.SendPVS(self:GetPos())
end

function URLSound3D(url,pos)
    net.Start("urlsound3d")
    net.WriteVector(pos)
    net.WriteString(url)
    --net.Broadcast()	
    net.SendPVS(pos)
end

else -- CLIENTSIDE


local sndcvar = GetConVar("snd_mute_losefocus")
local function shouldplay()
    return not system.IsWindows() or system.HasFocus() or not sndcvar:GetBool()
end

local function play(url, flags, cb)
    if not shouldplay() then return end
    
    local fnm = "cgg_" .. util.CRC(url) .. ".txt"
    
    if file.Exists(fnm, "DATA") then
        sound.PlayFile("data/" .. fnm, flags, function(c,enum,enam)
            -- line below did some shit, idk
            if not IsValid(c) then return end
            cb(c)
        end)
    else
        http.Fetch(url, function(b)
            file.Write(fnm, b)
            
            sound.PlayFile("data/" .. fnm, flags, function(c)
                if not IsValid(c) then return end
                cb(c)
            end)
        end)
    end
end

net.Receive("urlsound", function()
    local url = net.ReadString()
    local pbr = net.ReadFloat()
    
    play(url, "", function(c)
        c:SetPlaybackRate(pbr)
    end)
end)

local taunt_cvar = CreateConVar("resort_tauntvolume", 1, FCVAR_ARCHIVE)

local function volumeFor(tag)
    if tag == "taunt" then
        return taunt_cvar:GetFloat()
    end
    return 1
end

net.Receive("urlsound3dpl", function()
    local ent = net.ReadEntity()
    local url = net.ReadString()
    local tag = net.ReadString()
    
    if IsValid(ent) then
        play(url, "3d", function(c)
            if not IsValid(c) then return end
            
            c:SetPos(ent:GetPos())
            c:SetVolume(volumeFor(tag))
            timer.Create("UrlS3DPosTracker" .. tostring(c), 0.1, math.floor(c:GetLength() * 10), function()
                if IsValid(c) and IsValid(ent) then
                    c:SetPos(ent:GetPos())
                    c:SetVolume(volumeFor(tag))
                end
            end)
        end)
    end
end)

net.Receive("urlsound3d", function()
    local pos = net.ReadVector()
    local url = net.ReadString()
    play(url, "3d", function(c)
        if IsValid(c) then c:SetPos(pos) end
    end)
end)

resort.DialogURL = function(ent, url, cb)
    play(url, "3d", function(c)
        if not IsValid(c) then return end
        
        c:SetPos(ent:GetPos())
        c:SetVolume(volumeFor(tag))
        timer.Create("UrlS3DPosTracker" .. tostring(c), 0.1, math.floor(c:GetLength() * 10), function()
            if IsValid(c) and IsValid(ent) then
                c:SetPos(ent:GetPos())
                c:SetVolume(volumeFor(tag))
            end
        end)
        cb(c)
    end)	
end
    

end -- END CLIENT SIDE