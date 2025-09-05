--!strict

local scope = require("@self/scope")

export type registrydir = { [string]: registrydir } | effect

export type registry = { [string]: registrydir }

export type effect = (fx: scope.Scope, data: { [unknown]: unknown }) -> ()

export type sparkle = {
	registry: registry,
	scope: scope.Scope,

	register: (self: sparkle, container: Instance) -> sparkle,
	ignite: (self: sparkle, str: string, data: { [unknown]: unknown }) -> (),
	clone: (self: sparkle, target: Instance) -> Instance,
}

local function constructor(): sparkle
	local sparkle = {
		registry = {},
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

	function sparkle.register(self: sparkle, container: Instance): sparkle
		self.registry = define(container)
		self.scope = scope(self.registry)
		return self
	end

	return sparkle
end

return constructor
