--!strict

export type registrydir = {[string]: registrydir} | effect

export type registry = {[string]: registrydir}

export type effect = (sparkle: sparkle, data: {[unknown]: unknown}) -> ()

export type sparkle = {
    registry: registry,

    register: (self: sparkle, container: Instance) -> sparkle,
    ignite: (self: sparkle, str: string) -> effect?
}

local function constructor(): sparkle
    local self = {
        registry = {}
    } :: sparkle

    local function define(container: Instance): registry
        local Result: registry = {}

        for _, effect in container:GetChildren() do
            if effect:IsA("ModuleScript") then -- Register the effect into the registry
                local _module = require(effect) :: any
                if typeof(_module) == "function" then
                    Result[effect.Name] = require(effect) :: effect
                end
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

    function self.ignite(self: sparkle, str: string): effect?

    end

    return self
end


local s = constructor()
s:register(script)
s:ignite()

return constructor