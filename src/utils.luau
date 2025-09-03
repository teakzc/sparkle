--!strict

local types = require("./types")

local function emit(scope: types.Scope, target: Instance)
    for _, v in target:GetDescendants() do
        if v:IsA("ParticleEmitter") then
            local attributes = v:GetAttributes()
            
            if type(attributes["EmitCount"]) == "number" then
                v:Emit(attributes["EmitCount"])
            end

            if type(attributes["EmitDuration"]) == "number" then
                v.Enabled = true
                scope:delay(attributes["EmitDuration"], function()
                    v.Enabled = false
                end)
            end
        end
    end
end

local function toggle(target: Instance, state: boolean)
    for _, v in target:GetDescendants() do
        if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") then
            (v::any).Enabled = true
        end
    end
end

return {
    emit = emit,
    toggle = toggle,
}