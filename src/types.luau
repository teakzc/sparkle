
export type Destroyable =
    Instance
    | RBXScriptConnection
    | Scope
    | () -> ()

export type Scope = {
    destroy: (self: Scope) -> (),
    innerscope: (self: Scope) -> Scope,
    mount: (self: Scope, child: Destroyable) -> Destroyable,

    clone: (self: Scope, target: Instance) -> Instance,
    delay: (self: Scope, time: number, Fn: () -> ()) -> (),
    connect: (self: Scope, signal: RBXScriptSignal, Fn: (...any) -> ()) -> RBXScriptConnection,
    task: (self: Scope, Fn: () -> ()) -> (),

    emit: (self: Scope, target: Instance) -> (),
    toggle: (self: Scope, target: Instance, state: boolean) -> (),

    children: {Destroyable},
    running: boolean
}

export type registrydir = { [string]: registrydir } | effect

export type registry = { [string]: registrydir }

export type effect = (fx: Scope, data: { [unknown]: unknown }) -> ()

export type sparkle = {
	registry: registry,
	scope: Scope,

	register: (self: sparkle, container: Instance) -> sparkle,
	ignite: (self: sparkle, str: string, data: { [unknown]: unknown }) -> (),
	clone: (self: sparkle, target: Instance) -> Instance,
}


return {}