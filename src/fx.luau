--!strict

local scope = require("./scope")

export type fxspark = scope.Scope & {
    clone: (self: fxspark, target: Instance) -> Instance,
    finished: (self: fxspark) -> ()
}

local function constructor(): fxspark
    local fxspark = scope() :: fxspark

    function fxspark.clone(self: fxspark, target: Instance): Instance
        local cloned = target:Clone()
        self:mount(cloned)

        return cloned
    end

    function fxspark.finished(self: fxspark)
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

    return fxspark
end

return constructor
