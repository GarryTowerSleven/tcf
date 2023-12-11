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
end

function PANEL:GetHTML(account)
    local uri = "https://gtower.app/avatar/?id=" .. account

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
            <img id="avatar" src="]] .. uri .. [[&type=avatar">
            <img id="frame" src="]] .. uri .. [[&type=frame">
        </body>
        <script>
            function shrinkAvatar()
            {
                document.getElementById("avatar").style.scale = ]] .. (1 / self.FrameScale) .. [[;
            }

            function checkImageState(type)
            {
                const img = document.getElementById(type);

                const width = img.naturalWidth;
                const loaded = (width > 1);

                loaded ? gmod.imageLoaded(type) : gmod.imageError(type);

                if ( type === "frame" && loaded ) shrinkAvatar();
                if ( !loaded ) img.remove();
            }
        </script>
    ]];
end

function PANEL:SetupAnimatedAvatar(ply, size)
    if IsValid( self.AvatarDHTML ) then return end

    local accountID = 0

    if ply and not ply:IsBot() and not ply:IsHidden() then
        accountID = ply:AccountID()
    end

    self.AvatarDHTML = vgui.Create("DHTML", self)
    self.AvatarDHTML:SetHTML( self:GetHTML(accountID) )
    self.AvatarDHTML:SetPos(0, 0)
    self.AvatarDHTML:SetSize(size, size)
    self.AvatarDHTML:SetZPos(1)

    self.AvatarDHTML.OnDocumentReady = function()
        self.AvatarDHTML:AddFunction( "gmod", "imageLoaded", function( avatarType )
            if avatarType == "avatar" then
                self.AvatarImage:SetVisible( false )
            end

            if avatarType == "frame" then
                self:OnFrameLoaded()
            end
        end)
    
        self.AvatarDHTML:AddFunction( "gmod", "imageError", function( avatarType )
        end)

        self.AvatarDHTML:Call([[checkImageState("avatar");]])
        self.AvatarDHTML:Call([[checkImageState("frame");]])
    end
end

function PANEL:SetPlayer(ply, size)
    if self.Ply == ply then return end
    if not size then size = 42 end

    self.Ply = ply

    self.AvatarImage = vgui.Create("AvatarImage", self)
    self.AvatarImage:SetSize(size, size)
    self.AvatarImage:SetPlayer(ply, size)

    if ply:IsBot() then return end

    self:SetupAnimatedAvatar(ply, size)
end

function PANEL:ToggleVisible(a)
    print("ToggleVisible")
end

vgui.Register("AnimatedAvatar", PANEL, "Panel")
