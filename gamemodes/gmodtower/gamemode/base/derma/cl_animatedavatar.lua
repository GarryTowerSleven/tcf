local PANEL = {}
PANEL.FrameScale = 1.22 -- Steam uses this on their website.

function PANEL:Init()
end

function PANEL:OnSizeChanged(w, h)
    if IsValid(self.AvatarImage) then
        self.AvatarImage:SetSize(w, h)
    end

    if IsValid(self.AvatarDHTML) then
        self.AvatarDHTML:SetSize(w, h)
    end

    if IsValid(self.FrameDHTML) then
        self.FrameDHTML:SetSize(w, h)
    end
end

function PANEL:GetHTML(account, type)
    local uri = "https://gtower.app/avatar/?id=" .. account .. "&type=" .. type

    -- Prevent cache on random avatars.
    if account == 0 then
        uri = uri .. "&t=" .. math.random(1, 100000)
    end

    return [[
        <style>
            body {
                margin: 0;
                padding: 0;
                background-color: transparent;
                overflow: hidden;
            }
            img {
                position: absolute;
                inset: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
        </style>
        <body>
            <img id="img" src="]] .. uri .. [[">
        </body>
        <script>
            function checkImage()
            {
                const width = document.querySelector("img").naturalWidth;
                (width > 1) ? gmod.avatarLoaded() : gmod.avatarError();
            }
        </script>
    ]];
end

function PANEL:SetupAnimatedAvatar(accountID, size)
    self.AvatarDHTML:SetHTML( self:GetHTML(accountID, "avatar") )
    self.AvatarDHTML:SetPos(0, 0)
    self.AvatarDHTML:SetSize(size, size)
    self.AvatarDHTML:SetZPos(1)

    self.AvatarDHTML.OnDocumentReady = function()
        self.AvatarDHTML:AddFunction( "gmod", "avatarLoaded", function( str )
            self.AvatarImage:SetVisible(false)
        end)
    
        self.AvatarDHTML:AddFunction( "gmod", "avatarError", function( str )
            if IsValid(self.AvatarDHTML) then
                self.AvatarDHTML:Remove()
            end
        end)

        self.AvatarDHTML:Call([[checkImage();]])
    end
end

function PANEL:SetupAnimatedFrame(accountID, size)
    self.FrameDHTML:SetHTML( self:GetHTML(accountID, "frame") )
    self.FrameDHTML:SetPos(0, 0)
    self.FrameDHTML:SetSize(size, size)
    self.FrameDHTML:SetZPos(2)

    self.FrameDHTML.OnDocumentReady = function()
        self.FrameDHTML:AddFunction( "gmod", "avatarLoaded", function()
            -- Shrink avatar because of the frame.
            -- TODO: The frame should be 1.22x larger than the avatar instead shrinking the avatar.
            if IsValid(self.AvatarDHTML) then
                self.AvatarDHTML:SetSize(size * (1 / self.FrameScale), size * (1 / self.FrameScale))
                self.AvatarDHTML:SetPos(size * (1 - (1 / self.FrameScale)) / 2 + 1, size * (1 - (1 / self.FrameScale)) / 2 + 1)
            end

            -- Call scoreboard alterations.
            self:OnFrameLoaded()
        end)  
    
        self.FrameDHTML:AddFunction( "gmod", "avatarError", function()
            if IsValid(self.FrameDHTML) then
                self.FrameDHTML:Remove()
            end
        end)

        self.FrameDHTML:Call([[checkImage();]])
    end
end

function PANEL:SetPlayer(ply, size)
    if self.Ply == ply then return end
    if not size then size = 42 end

    self.Ply = ply

    self.AvatarImage = vgui.Create("AvatarImage", self)
    self.AvatarImage:SetSize(size, size)
    self.AvatarImage:SetPlayer(ply, size)

    self.AvatarDHTML = vgui.Create("DHTML", self)
    self.FrameDHTML = vgui.Create("DHTML", self)

    local accountID = 0

    if ply and not ply:IsBot() and not ply:IsHidden() then
        accountID = ply:AccountID()
    end

    self:SetupAnimatedAvatar(accountID, size)
    self:SetupAnimatedFrame(accountID, size)
end

vgui.Register("AnimatedAvatar", PANEL, "Panel")
