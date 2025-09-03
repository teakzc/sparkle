--!strict

export type Destroyable =
    Instance
    | RBXScriptConnection
    | Scope
    | () -> ()

export type Scope = {
    destroy: (self: Scope) -> (),
    innerscope: (self: Scope) -> Scope,
    mount: (self: Scope, child: Destroyable) -> Destroyable,

    children: {Destroyable},
}

local function scope(): Scope
    local createdscope = {
        children = {} :: {Destroyable}
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
            end
        end

        table.clear(self.children)

        table.clear(self)

        self =  nil :: any
    end

    return createdscope
end

return scope
