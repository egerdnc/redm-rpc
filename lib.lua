RPC = {}
-- Delay all exports calls before resource starts
RPC.isWaitingForResourceStart = true

local pendingExportCalls = {}
local isResourceStarted = false

local function CallExport(name, ...)
    if isResourceStarted or not RPC.isWaitingForResourceStart then
        return exports["redm-rpc"][name](exports["redm-rpc"], ...)
    else
        table.insert(pendingExportCalls, {
            name = name,
            args = {...}
        })
    end
end

AddEventHandler(("on%sResourceStart"):format(IsDuplicityVersion() and "Server" or "Client"), function (resource)
    if GetCurrentResourceName() ~= resource then return end

    for i, c in ipairs(pendingExportCalls) do
        exports["redm-rpc"][c.name](exports["redm-rpc"], table.unpack(c.args))
    end

    isResourceStarted = true
end)

function RPC.Register(name, callback)
    return CallExport("RegisterMethod", name, callback)
end

function RPC.Notify(name, params, source)
    if not params then
        params = {}
    end
    return CallExport("CallRemoteMethod", name, params, nil, source)
end

function RPC.Call(name, params, callback, source)
    if not params then
        params = {}
    end
    return CallExport("CallRemoteMethod", name, params, callback, source)
end

function RPC.CallAsync(name, params, source)
    if not params then
        params = {}
    end
    local p = promise.new()

    CallExport("CallRemoteMethod", name, params, function (...)
        p:resolve({...})
    end, source)

    return table.unpack(Citizen.Await(p))
end
