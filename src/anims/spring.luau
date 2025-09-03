--!strict

export type spring<T> = {
    goal: T,
    current: T,
    velocity: T,
    damping: number,
    speed: number
}

local function constructor<T>(goal: T, speed: number?, damping: number?)
   local spring = {
        goal = goal,
        speed = speed or 1,
        damping = damping or 0.5
   } :: spring<T>

end

return constructor