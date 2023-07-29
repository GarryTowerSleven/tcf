include("shared.lua")

CreateClientConVar("gmt_outfit", "", true, true)

cvars.AddChangeCallback("gmt_outfit", function(convar_name, value_old, value_new)
    RunConsoleCommand("gmt_updateplayermodel")
end)

outfits = {
    players = {},
    outfits = {
        ["models/player/gman_high.mdl"] = {
            mats = {
                
            }
        }
    }
}

function DrawPlayer(ply)
    ply:SetMaterial("null")
    ply:DrawShadow(false)
    ply.MDLs = ply.MDLs or {}

    for i = 1, 2 do
        local m = ply:GetModel2(i)
        local mdl = ply.MDLs[i]
        m = string.lower(m)
        if (ply ~= LocalPlayer() || ply:ShouldDrawLocalPlayer()) && !ply:GetNoDraw() && ply:Alive() && string.len(m) ~= 0 && (!IsValid(mdl) || mdl:GetModel() == m) then
            if !IsValid(mdl) then
                ply.MDLs[i] = ClientsideModel(m)
                mdl = ply.MDLs[i]

                mdl.GetPlayerColor = function()
                    return ply:GetPlayerColor()
                end

                local face = false
                local neck = false

                for _, mat in ipairs(mdl:GetMaterials()) do
                    if string.find(mat, "face") || string.find(mat, "eye") || string.find(mat, "face") || string.find(mat, "tongue") || string.find(mat, "teeth") then
                        face = _

                        if i == 2 then
                            mdl:SetSubMaterial(_ - 1, "null")
                        else
                            mdl:SetSubMaterial()
                        end
                    /*elseif i == 1 and string.find(mat, "sheet") then
                        mdl:SetSubMaterial(_ - 1, "null")
                        neck = _*/
                    end
                end

                mdl:SetupBones()


                mdl:AddCallback("BuildBonePositions", function(ent, bones)
                    local m3, m4 = Matrix(), Matrix()

                    if !ent.Matrix then
                        ent.Matrix = {
                            {},
                            {}
                        }

                        for i2 = 0, mdl:GetBoneCount() - 1 do
                            local ihateyou = {}

                            if i2 == 0 then
                                ihateyou = {0}
                            end
    
                            local m1 = mdl:GetBoneMatrix(i2)
                            if !m1 then print("what?", mdl:GetBoneName(i2), ply) continue end
    
                            for i3 = 0, mdl:GetBoneCount() - 1 do
                                if mdl:GetBoneParent(i3) == i2 then
                                    table.insert(ihateyou, i3) 
                                end
                            end

                            ent.Matrix[1][i2] = m1
                            ent.Matrix[2][i2] = ihateyou
                        end

                        if i == 2 || IsValid(ply.MDLs[2]) && i == 1 then
                            for i2 = 0, mdl:GetBoneCount() - 1 do
                                local name = mdl:GetBoneName(i2)
                                local die = string.find(name, "Finger") || string.find(name, "Hand") // || string.find(name, "Forearm") || string.find(name, "Wrist")
                                local head = string.find(name, "Neck") || string.find(name, "Head")
                                local spine = false // string.find(name, "Spine4")
                            
                                print(name, die)
                                if (die || head && !face) and i == 2 || ((!neck and !head) && !die && !spine) && i == 1 then
                                    mdl:ManipulateBoneScale(i2, spine and Vector(0.4, 0.4, 0.4) or Vector(0, 0, 0))
                                else
                                    mdl:ManipulateBoneScale(i2, Vector(1, 1, 1))
                                end
                            end
                        elseif i == 1 then
                            for i2 = 0, mdl:GetBoneCount() - 1 do
             
                                    mdl:ManipulateBoneScale(i2, Vector(1, 1, 1))
                                
                            end
                        end
                    end

                    for i2 = 0, bones do

                        local m1 = ent.Matrix[1][i2]

                        if !m1 then continue end

                        local ihateyou = ent.Matrix[2][i2]

                        m3:Set(m1)
                        m3:Invert()
                        
                        for _, i4 in ipairs(ihateyou) do
                            //print("YOU ARE" .. i4)


                            
                            local m2 = mdl:GetBoneMatrix(i4)

                            if !ent.Matrix[3] or !ent.Matrix[3][i4] then
                                ent.Matrix[3] = {}

                                local blood = ply:LookupBone(mdl:GetBoneName(i4))
                                ent.Matrix[3][i4] = blood or 0
                                if blood then
                                    ent.Matrix[3][i4] = ply:GetBoneMatrix(blood) // BLOOD IS WARM
                                end
                            end

                            m5 = ent.Matrix[3][i4]
                                if m5 and m5 ~= 0 then
                                    mdl:SetBoneMatrix(i4, m5)
                                    m2 = m5
                                else
                                    
                            if !m2 then continue end
                            local m = Matrix()
                            m:Set(m1)
                            m:Mul(m3)
                            m:Mul(m2)

                            mdl:SetBoneMatrix(i4, m)
                            m1 = m
                            m3:Set(m2)
                            m3:Invert()
                                end
                            


                        end
                    end
                end)

            end




            mdl:SetPos(ply:GetPos())
            mdl:RemoveAllDecals()
            mdl:SetEyeTarget(ply:EyePos() + ply:GetAimVector() * 64)

            mdl:SetParent(ply)
            mdl:AddEffects(EF_BONEMERGE)
            mdl:DrawShadow(true)
            mdl:CreateShadow()
        elseif IsValid(mdl) then
            mdl:Remove()
        end
    end
end

hook.Add("PrePlayerDraw", "Models", function(ply)
    //for _, ply in ipairs(player.GetAll()) do
        DrawPlayer(ply)
    //end
end)