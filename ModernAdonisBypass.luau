local RobloxEnv = getrenv()

local OldDebugInfo; OldDebugInfo = oth.hook(RobloxEnv.debug.info, function(Level: number | (...any) -> ...any, Options: string): ...any
     if not checkcaller() then
        local Func = OldDebugInfo(Level, "f")
        if Func and isexecutorclosure(Func) then
            return nil
        end
    end
    return OldDebugInfo(Level, Options)
end)

local OldGetfenv; OldGetfenv = oth.hook(RobloxEnv.getfenv, function(Level: number | (...any) -> ...any): {[string]: any}
    if not checkcaller() then
        local TargetLevel = if Level == nil then 1 else Level
        local Func = OldDebugInfo(TargetLevel, "f")
        if Func and isexecutorclosure(Func) then
            return error("invalid argument #1 to 'getfenv' (invalid level)", 0)
        end
        return OldGetfenv(Func)
    end
    return OldGetfenv(Level)
end)
