--!strict

local RS = game:GetService("RunService")

export type animated = {
    stepped: (dT: number) -> ()
}

export type cycle = {
    active: {animated}
}

local cycle = {
    active = {}
} :: cycle

local function animate(animated)
    table.insert(cycle.active, animated)
end

RS.Heartbeat:Connect(function(dT: number)
    for _, animated in cycle.active do
        animated.stepped(dT)
    end
end)

return animate
