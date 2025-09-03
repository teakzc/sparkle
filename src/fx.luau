--!strict

local scope = require("./scope")

local spring = require("./anims/spring")

export type fxscope = scope.Scope & {
    clone: (self: fxscope, target: Instance) -> Instance,
    finished: (self: fxscope) -> ()
}

local function constructor(): fxscope
    local fxscope = scope() :: fxscope

    function fxscope.clone(self: fxscope, target: Instance): Instance
        local cloned = target:Clone()
        self:mount(cloned)

        return cloned
    end

    function fxscope.finished(self: fxscope)
        local highestlifetime = 0
        for _, v in self.children do
            if typeof(v) == "Instance" then
                if v:IsA("ParticleEmitter") then
                    if v.Lifetime.Max > highestlifetime then
                        highestlifetime = v.Lifetime.Max
                    end
                end
            end
        end
    end

    return fxscope
end

return constructor
