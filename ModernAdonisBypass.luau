local ExploitEnvIndex = getrawmetatable(getfenv(1)).__index
local RobloxEnv = getrenv()

local OldDebugInfo; OldDebugInfo = oth.hook(RobloxEnv.debug.info, function(Level: number | (...any) -> ...any, Options: string): ...any
    if not checkcaller() and typeof(Level) == "number" then
        local Args = {OldDebugInfo(Level, Options)}
        for _, v in Args do
            if typeof(v) == "function" and isexecutorclosure(v) then
                return nil
            end
        end
        return table.unpack(Args)
    end
    return OldDebugInfo(Level, Options)
end)

local OldGetfenv; OldGetfenv = oth.hook(RobloxEnv.getfenv, function(Func: (number | (...any) -> ...any)?): any
    local Env = OldGetfenv(Func)
    if not checkcaller() then
        if not Func then return OldGetfenv(2) end
        local RawMetatableIndex = getrawmetatable(Env).__index
        if RawMetatableIndex == ExploitEnvIndex then
            return error("invalid argument #1 to 'getfenv' (invalid level)", 0)
        end
    end
    return Env
end)

local OldSetfenv; OldSetfenv = oth.hook(RobloxEnv.setfenv, function(Func: (number | (...any) -> ...any)?, NewEnv: {[string]: any}): ...any
    if not checkcaller() then
        if typeof(Func) == "function" and isexecutorclosure(Func) then
            return error("'setfenv' cannot change environment of given object", 0)
        elseif typeof(Func) == "number" then
            local Env = RobloxEnv.getfenv(Func + 1)
            local RawMetatableIndex = getrawmetatable(Env).__index
            if RawMetatableIndex == ExploitEnvIndex then
                return error("invalid argument #1 to 'setfenv' (invalid level)", 0)
            end
        end
    end
    return OldSetfenv(Func, NewEnv)
end)
