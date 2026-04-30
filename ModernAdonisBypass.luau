local RobloxEnv = getrenv()

local OldDebugInfo; OldDebugInfo = oth.hook(RobloxEnv.debug.info, function(Level: number | (...any) -> ...any, Options: string): ...any
     if not checkcaller() then
        if type(Level) == "function" then
            if isexecutorclosure(Level) then
                return nil
            end
            return OldDebugInfo(Level, Options)
        end
        local Func = OldDebugInfo(Level, "f")
        local RealLevel = 0
        local i = 1
        while RealLevel < Level do
            local f = OldDebugInfo(i, "f")
            if not f then return nil end
            if not isexecutorclosure(f) then
                RealLevel += 1
            end
            i += 1
        end

        local TargetFunc = OldDebugInfo(i - 1, "f")
        return OldDebugInfo(TargetFunc, Options)
    end
    return OldDebugInfo(Level, Options)
end)

local OldGetfenv; OldGetfenv = oth.hook(RobloxEnv.getfenv, function(Level: number | (...any) -> ...any): {[string]: any}
    if not checkcaller() then
        local TargetLevel = if Level == nil then 1 else Level
        local Func = OldDebugInfo(TargetLevel, "f")
        if Func and isexecutorclosure(Func) then
            return RobloxEnv
        end
        return OldGetfenv(Func)
    end
    return OldGetfenv(Level)
end)
