require('du_lib/requires/network-request-server')
local json = require('dkjson')

emitter = emitter
receiver = receiver
---@type ManualSwitch
switch = switch

local remoteChannel = 'testClientChannel' --export:
local listenChannel = 'testServerChannel' --export:
local connectionTimeout = 1 --export:
local sendBufferSize = 100 --export:

local networkService = NetworkService.new(emitter, receiver, listenChannel, connectionTimeout, sendBufferSize)

---@param source string
---@param request string
local function handleRequest(source, request)
    system.print('Received request from client with source "' .. source .. '": ' .. json.encode(request))
    return 'Hello from server!'
end
local networkResponseServer = NetworkRequestServer.new(networkService, handleRequest, switch, 2, remoteChannel)

State.new({ networkResponseServer, networkService }, unit, system, 0, 0).start()