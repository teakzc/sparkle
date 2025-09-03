--!strict

local utils = require("./utils")

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

local function scope(): Scope
    local createdscope = {
        children = {} :: {Destroyable},
        running = true,
    }

    function createdscope.mount(self: Scope, child: Destroyable): Destroyable
        table.insert(self.children, child)
        return child
    end

    function createdscope.innerscope(self: Scope): Scope
        local innerscope = scope()
        self:mount(innerscope)
        return innerscope
    end

    function createdscope.destroy(self: Scope)
        for _, child in self.children do
            if typeof(child) == "Instance" then
                child:Destroy()
            elseif typeof(child) == "RBXScriptConnection" then
                child:Disconnect()
            elseif type(child) == "table" and child.destroy then
                child:destroy()
            elseif type(child) == "function" then
                child()
            end
        end

        table.clear(self.children)

        table.clear(self)

        self =  nil :: any
    end

    function createdscope.clone(self: Scope, target: Instance): Instance
        local cloned = target:Clone()
        self:mount(cloned)

        return cloned
    end

    function createdscope.delay(self: Scope, time: number, Fn: () -> ())
        task.delay(time, function()
            if self.running == true then
                Fn()
            end
        end)
    end

    function createdscope.connect(self: Scope, signal: RBXScriptSignal, Fn: (...any) -> ()): RBXScriptConnection
        local connection = signal:Connect(Fn)
        self:mount(connection)
        return connection
    end

    function createdscope.task(self: Scope, Fn: () -> ())
        task.spawn(function()
            if self.running == true then
                Fn()
            end
        end)
    end

    function createdscope.emit(self: Scope, target: Instance)
        utils.emit(self, target)
    end

    function createdscope.toggle(self: Scope, target: Instance, state: boolean)
        utils.toggle(target, state)
    end

    createdscope:mount(function()
        createdscope.running = false
    end)

    return createdscope
end

return scope
