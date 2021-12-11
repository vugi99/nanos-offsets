
function Offsets_SM(ply, attach_to, Attach_Bone, Model, sx, sy, sz)
    local SM = StaticMesh(
        Vector(0, 0, 0),
        Rotator(0, 0, 0),
        Model
    )
    SM:SetScale(Vector(sx, sy, sz))
    SM:AttachTo(attach_to, AttachmentRule.SnapToTarget, Attach_Bone, 0)
    SM:SetCollision(CollisionType.NoCollision)

    local Attached = attach_to:GetValue("OffsetsAttached")
    Attached = Attached or {}
    local tbl_insert = {
        type = "StaticMesh",
        id = SM:GetID(),
    }
    table.insert(Attached, tbl_insert)
    attach_to:SetValue("OffsetsAttached", Attached, false)

    ply:SetValue("LastAttached", tbl_insert, false)
end

Events.Subscribe("ASM_Remote", function(ply, Attach_Type, Attach_Bone, Model, sx, sy, sz)
    --print("ASM", Attach_Type, Attach_Bone, Model, sx, sy, sz)
    local char = ply:GetControlledCharacter()
    if char then
        if Attach_Type == "Character" then
            Offsets_SM(ply, char, Attach_Bone, Model, sx, sy, sz)
        elseif Attach_Type == "Weapon" then
            local picked_thing = char:GetPicked()
            if picked_thing then
                Offsets_SM(ply, picked_thing, Attach_Bone, Model, sx, sy, sz)
            end
        end
    end
end)

function Offsets_Light(ply, attach_to, Attach_Bone)
    local Light = Light(
        Vector(-152, 245, 115),
        Rotator(0, 90, 90), -- Relevant only for Rect and Spot light types
        Color(1, 1, 1), -- Red Tint
        LightType.Spot, -- Point Light type
        100, -- Intensity
        2500, -- Attenuation Radius
        44, -- Cone Angle (Relevant only for Spot light type)
        0, -- Inner Cone Angle Percent (Relevant only for Spot light type)
        10000, -- Max Draw Distance (Good for performance - 0 for infinite)
        true, -- Whether to use physically based inverse squared distance falloff, where Attenuation Radius is only clamping the light's contribution. (Spot and Point types only)
        true, -- Cast Shadows?
        true -- Enabled?
    )
    Light:AttachTo(attach_to, AttachmentRule.SnapToTarget, Attach_Bone, 0)

    local Attached = attach_to:GetValue("OffsetsAttached")
    Attached = Attached or {}
    local tbl_insert = {
        type = "Light",
        id = Light:GetID(),
    }
    table.insert(Attached, tbl_insert)
    attach_to:SetValue("OffsetsAttached", Attached, false)

    ply:SetValue("LastAttached", tbl_insert, false)
end

Events.Subscribe("ALight_Remote", function(ply, Attach_Type, Attach_Bone)
    local char = ply:GetControlledCharacter()
    if char then
        if Attach_Type == "Character" then
            Offsets_Light(ply, char, Attach_Bone)

        elseif Attach_Type == "Weapon" then
            local picked_thing = char:GetPicked()
            if picked_thing then
                Offsets_Light(ply, picked_thing, Attach_Bone)
            end
        end
    end
end)

Events.Subscribe("UpdateOffsets_Remote", function(ply, x, y, z, rx, ry, rz)
    local last_attached = ply:GetValue("LastAttached")
    if last_attached then
        for k, v in pairs(_ENV[last_attached.type].GetPairs()) do
            if v:GetID() == last_attached.id then
                v:SetRelativeLocation(Vector(x, y, z))
                v:SetRelativeRotation(Rotator(rx, ry, rz))
                break
            end
        end
    end
end)

function DestroyOffsetsAttached(class)
    for k, v in pairs(class.GetPairs()) do
        local Attached = v:GetValue("OffsetsAttached")
        if Attached then
            for k2, v2 in pairs(Attached) do
                for k3, v3 in pairs(_ENV[v2.type].GetPairs()) do
                    if v3:GetID() == v2.id then
                        v3:Destroy()
                        break
                    end
                end
            end
        end
        v:SetValue("OffsetsAttached", nil, false)
    end
end

Events.Subscribe("ADestroy_Remote", function()
    DestroyOffsetsAttached(Character)
    DestroyOffsetsAttached(Weapon)

    for k, v in pairs(Player.GetPairs()) do
        v:SetValue("LastAttached", nil, false)
    end
end)