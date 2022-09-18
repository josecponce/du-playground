require('du_lib/requires/network')

emitter = emitter
receiver = receiver

local listenChannel = 'testServerChannel' --export:
local connectionTimeout = 3 --export:
local sendBufferSize = 100 --export:

local networkService = NetworkService.new(emitter, receiver, listenChannel, connectionTimeout, sendBufferSize)

networkService:onEvent(NETWORK_SERVICE_EVENTS.DATA, function(_, _, data)
    system.print('Server: Data received from client: ' .. data)
    networkService.send('Data from Server.')
    system.print('Server: Data sent to client.')
end)

networkService:onEvent(NETWORK_SERVICE_EVENTS.ACK_DATA, function(_, _)
    system.print('Server: Data Ack received from client.')
end)

networkService:onEvent(NETWORK_SERVICE_EVENTS.OPEN, function(_, _)
    system.print('Server: Connection Open received from client.')
end)

networkService:onEvent(NETWORK_SERVICE_EVENTS.CLOSE, function(_, _)
    system.print('Server: Connection Close received from client.')
end)

State.new({ networkService }, unit, system, 0, 0).start()