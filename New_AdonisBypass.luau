local RobloxEnv = getrenv()
local old
old = hookfunction(RobloxEnv.require, newcclosure(function(Module)
    if not checkcaller() and typeof(Module) == "Instance" and Module.Name == 'Anti' and Module.Parent and Module.Parent.Name == "Core" then
        print('[!] Adonis sucks:', Module)
        return {}
    end
    return old(Module)
end))
