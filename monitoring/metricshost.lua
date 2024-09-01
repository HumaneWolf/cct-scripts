local MODEM_SIDE = 'bottom'

local PROTOCOL_NAME = 'monitoring.submit'
local HOST_NAME = 'monitoring.mane'

-- Set up storage
local dailyMetricsDay = os.day()
local dailyTrackedMetrics = {}
local trackedMetrics = {}

-- Load storage from disk
local fh = fs.open('/data/total', 'r')
local data = fh.readAll()
trackedMetrics = textutils.unserialiseJSON(data)
fh.close()

if fs.exists('/data/day'..os.day()) then
    fh = fs.open('/data/day'..os.day(), 'r')
    data = fh.readAll()
    dailyTrackedMetrics = textutils.unserialiseJSON(data)
    fh.close()
end

-- Set up network
print('Starting monitoring host.')
rednet.open(MODEM_SIDE)
rednet.unhost(PROTOCOL_NAME, HOST_NAME)
rednet.host(PROTOCOL_NAME, HOST_NAME)

local senderId, message, protocol
local freeSpace
while true do
    -- Setup
    if dailyMetricsDay ~= os.day() then
        dailyMetricsDay = os.day()
        dailyTrackedMetrics = {}
    end

    -- Status logging
    freeSpace = fs.getFreeSpace('/data/')
    print('Free space available for data: '..freeSpace)
    trackedMetrics['freeDataSpace'] = freeSpace

    -- Receive
    senderId, message, protocol = rednet.receive(PROTOCOL_NAME)
    print('Received: '..senderId..' - '..message.emitter..'/'..message.metricName..' is '..message.metricValue..' at '..os.day()..'/'..os.time())

    -- Process
    if message.metricName == 'bambooHarvested' then
        trackedMetrics['bambooHarvested'] = trackedMetrics['bambooHarvested'] + message.metricValue
        dailyTrackedMetrics['bambooHarvested'] = dailyTrackedMetrics['bambooHarvested'] + message.metricValue
    end

    -- Save to disk
    fh = fs.open('/data/total', 'w')
    fh.write(textutils.serialiseJSON(trackedMetrics))
    fh.close()

    fh = fs.open('/data/day'..dailyMetricsDay, 'w')
    fh.write(textutils.serialiseJSON(dailyTrackedMetrics))
    fh.close()

    -- Delete old files
    if fs.exists('/data/day'..(os.day() - 7)) then
        fs.delete('/data/day'..(os.day() - 7))
    end
end
