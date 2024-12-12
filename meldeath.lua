CreateConVar("meldeath_enabled", "1", FCVAR_ARCHIVE, "1 - Enable melon death effect, 0 - Disable melon death effect")
CreateConVar("meldeath_lifetime", "7", FCVAR_ARCHIVE, "Time (in seconds) before the melons disappear")
CreateConVar("meldeath_shrink_time", "5", FCVAR_ARCHIVE, "Time (in seconds) before the melons start shrinking")

hook.Add("OnNPCKilled", "MelonDeathEffects", function(npc, attacker, inflictor)
    if not IsValid(npc) or GetConVar("meldeath_enabled"):GetInt() == 0 then return end

    local melonLifetime = GetConVar("meldeath_lifetime"):GetInt() or 7
    local melonShrinkTime = melonLifetime * 0.7

    local pos = npc:GetPos() + Vector(0, 0, 35)
    local effect = EffectData()
    effect:SetOrigin(pos)
    util.Effect("BloodImpact", effect)

    for i = 1, 5 do
        local melon = ents.Create("prop_physics")
        if IsValid(melon) then
            melon:SetModel("models/props_junk/watermelon01.mdl")
            melon:SetPos(pos + VectorRand() * 20)
            melon:Spawn()

            local phys = melon:GetPhysicsObject()
            if IsValid(phys) then
                phys:ApplyForceCenter(VectorRand() * 500)
            end

            melon:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

            timer.Simple(melonShrinkTime, function()
                if IsValid(melon) then
                    local scale = melon:GetModelScale()
                    local newScale = scale * 0.05
                    melon:SetModelScale(newScale, 0.5)

                    local phys = melon:GetPhysicsObject()
                    if IsValid(phys) then
                        phys:SetMass(phys:GetMass() * 0.05)
                        phys:EnableCollisions(false)
                    end
                end
            end)

            timer.Simple(melonLifetime, function()
                if IsValid(melon) then
                    melon:Remove()
                end
            end)
        end
    end

    npc:EmitSound("physics/flesh/flesh_bloody_break.wav")
    npc:Remove()
end)

hook.Add("PlayerDeath", "MelonDeathEffects_Player", function(victim, inflictor, attacker)
    if GetConVar("meldeath_enabled"):GetInt() == 0 then return end

    local melonLifetime = GetConVar("meldeath_lifetime"):GetInt() or 7
    local melonShrinkTime = melonLifetime * 0.7

    local pos = victim:GetPos() + Vector(0, 0, 10)
    local effect = EffectData()
    effect:SetOrigin(pos)
    util.Effect("BloodImpact", effect)

    for i = 1, 5 do
        local melon = ents.Create("prop_physics")
        if IsValid(melon) then
            melon:SetModel("models/props_junk/watermelon01.mdl")
            melon:SetPos(pos + VectorRand() * 20)
            melon:Spawn()

            local phys = melon:GetPhysicsObject()
            if IsValid(phys) then
                phys:ApplyForceCenter(VectorRand() * 500)
            end

            melon:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

            timer.Simple(melonShrinkTime, function()
                if IsValid(melon) then
                    local scale = melon:GetModelScale()
                    local newScale = scale * 0.05
                    melon:SetModelScale(newScale, 0.5)

                    local phys = melon:GetPhysicsObject()
                    if IsValid(phys) then
                        phys:SetMass(phys:GetMass() * 0.05)
                        phys:EnableCollisions(false)
                    end
                end
            end)

            timer.Simple(melonLifetime, function()
                if IsValid(melon) then
                    melon:Remove()
                end
            end)
        end
    end

    victim:EmitSound("physics/flesh/flesh_bloody_break.wav")
    local ragdoll = victim:GetRagdollEntity()
    if IsValid(ragdoll) then
        ragdoll:Remove()
    end
end)
