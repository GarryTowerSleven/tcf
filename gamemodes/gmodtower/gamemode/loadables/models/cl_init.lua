include("shared.lua")

function DrawPlayer(ply)
    ply:SetMaterial("null")
    ply:DrawShadow(false)
    ply.MDLs = ply.MDLs or {}

    for i = 1, 8 do
        local m = ply:GetModel2(i)
        local mdl = ply.MDLs[i]
        m = string.lower(m)
        if !ply:GetNoDraw() && ply:Alive() && string.len(m) ~= 0 && (!IsValid(mdl) || mdl:GetModel() == m) then
            if !IsValid(mdl) then
                ply.MDLs[i] = ClientsideModel(m)
                mdl = ply.MDLs[i]

                mdl.GetPlayerColor = function()
                    return ply:GetPlayerColor()
                end
            end


            if i == 2 || IsValid(ply.MDLs[2]) && i == 1 then
                for i2 = 0, mdl:GetBoneCount() - 1 do
                    local name = mdl:GetBoneName(i2)
                    local die = string.find(name, "Finger") || string.find(name, "Hand") || string.find(name, "Neck") || string.find(name, "Head")
                
                    print(name, die)
                    if die and i == 2 || !die && i == 1 then
                        mdl:ManipulateBoneScale(i2, Vector(0, 0, 0))
                    else
                        mdl:ManipulateBoneScale(i2, Vector(1, 1, 1))
                    end
                end
            elseif i == 1 then

            end

            mdl:SetPos(ply:GetPos())
            
            /*for i2 = 0, mdl:GetBoneCount() - 1 do
                local b = ply:LookupBone(mdl:GetBoneName(i2))
                if !b then continue end
                local pos, ang = ply:GetBonePosition(b)
                
                local matrix = mdl:GetBoneMatrix(i2)
                if !matrix then continue end
                matrix:SetTranslation(pos)
                matrix:SetAngles(ang)
                mdl:SetBoneMatrix(i2, matrix)
            end*/

            mdl:SetParent(ply)
            mdl:AddEffects(EF_BONEMERGE)
            mdl:DrawShadow(true)
            mdl:CreateShadow()
        elseif IsValid(mdl) then
            mdl:Remove()
        end
    end
end

hook.Add("PreRender", "Models", function(ply)
    for _, ply in ipairs(player.GetAll()) do
        DrawPlayer(ply)
    end
end)