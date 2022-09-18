require('du_lib/requires/network')

emitter = emitter
receiver = receiver

local remoteChannel = 'testServerChannel' --export:
local listenChannel = 'testClientChannel' --export:
local connectionTimeout = 3 --export:
local sendBufferSize = 100 --export:

local networkService = NetworkService.new(emitter, receiver, listenChannel, connectionTimeout, sendBufferSize)

networkService:onEvent(NETWORK_SERVICE_EVENTS.DATA, function(_, _, data)
    system.print('Client: Data received from server: ' .. data)
    networkService.close()
    system.print('Client: Connection close sent to server')
end)

networkService:onEvent(NETWORK_SERVICE_EVENTS.ACK_CLOSE, function(_, _)
    system.print('Client: Close Ack received from server.')
end)

networkService:onEvent(NETWORK_SERVICE_EVENTS.ACK_DATA, function(_, _)
    system.print('Client: Data Ack received from server.')
end)

networkService:onEvent(NETWORK_SERVICE_EVENTS.ACK_OPEN, function(_, _)
    system.print('Client: Connection Open Ack received from server.')
    networkService.send('Data from client.')
    system.print('Client: Data sent to server.')
end)

State.new({ networkService }, unit, system, 0, 0).start()

networkService.connect(remoteChannel)