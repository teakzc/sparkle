--!strict

export type registrydir = {[string]: registrydir} | effect

export type registry = {[string]: registrydir}

export type effect = {
    (sparkle: sparkle, data: {[unknown]: unknown}) -> ()
}

export type sparkle = {
    registry: registry,

    register: (self: sparkle, container: Instance) -> sparkle,
    ignite: (self: sparkle, dir: (registry) -> (effect | Folder)) -> effect?
}

local function constructor(): sparkle
    local self = {
        registry = {}
    } :: sparkle

    local function define(container: Instance)
        local Result = {}

        for _, effect in container:GetChildren() do
            if effect:IsA("ModuleScript") then -- Register the effect into the registry
                Result[effect.Name] = require(effect) :: effect
            elseif effect:IsA("Folder") then -- Recursive
                Result[effect.Name] = define(effect)
            end
        end

        return Result
    end

    function self.register(self: sparkle, container: Instance): sparkle
        self.registry = define(container)
        return self
    end

    function self.ignite(self: sparkle, dir: (registry) -> (effect| Folder)): effect?
        local effect = dir(self.registry)

        if typeof(effect) == "Folder" then
            return nil
        else
            return effect    
        end
    end

    return self
end


local s = constructor()
s:register(script)
s:ignite(function(registry)
    return registry.Baller
end)

return constructor