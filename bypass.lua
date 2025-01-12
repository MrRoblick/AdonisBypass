local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local KickFunc = LocalPlayer.Kick
local RobloxEnv = getrenv()

hookfunction(KickFunc, newcclosure(function(self, reason)
    return task.wait(9e9)
end))

local old
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Name = getnamecallmethod()
    if Name == 'Kick' or Name == 'kick' then
        return task.wait(9e9)
    end
    return old(self, ...)
end))

local Detected, Kill
for i, v in getgc(true) do
    if typeof(v) ~= 'table' then continue end

    local DetectFunc = rawget(v, "Detected")
    local KillFunc = rawget(v, "Kill")

    if typeof(DetectFunc) == "function" and not Detected then
        Detected = DetectFunc
        hookfunction(DetectFunc, newcclosure(function()
            return true
        end))
    end

    if rawget(v, "Variables") and rawget(v, "Process") and typeof(KillFunc) == "function" and not Kill then
        Kill = KillFunc
        hookfunction(KillFunc, newcclosure(function()
            return true
        end))
    end
end

local old
old = hookfunction(RobloxEnv.debug.info, newcclosure(function(...)
    local Func = ...
    if Func == Detected or Func == Kill then
        return coroutine.yield(coroutine.running())
    end
    return old(...)
end))
