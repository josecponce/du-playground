require('du_lib/requires/network-request-client')
local json = require('dkjson')

emitter = emitter
receiver = receiver

local remoteChannel = 'testServerChannel' --export:
local listenChannel = 'testClientChannel' --export:
local connectionTimeout = 2 --export:
local sendBufferSize = 100 --export:

local commandsQueueSize = 10 --export:
local commandTimerInterval = 0.5 --export:

local networkService = NetworkService.new(emitter, receiver, listenChannel, connectionTimeout, sendBufferSize)
local networkRequestClient = NetworkRequestClient.new(networkService, commandsQueueSize, commandTimerInterval, true)

---@param result string
local function handleResponse(result)
    system.print('Received response from server: ' .. json.encode(result))
end

local request1 = NetworkRequest.new(remoteChannel, 'Hello from client 1!', handleResponse)
networkRequestClient.sendRequest(request1)

local request2 = NetworkRequest.new(remoteChannel, 'Hello from client 2!', handleResponse)
networkRequestClient.sendRequest(request2)

State.new({ networkRequestClient, networkService }, unit, system, 0, 0).start()