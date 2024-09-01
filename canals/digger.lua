local START_X, START_Y, START_Z, START_DIR = 0, 0, 0, 'north'
local DESIRED_DISTANCE, WIDTH = 10, 6

local function digUntilClear()
    while turtle.detect() do
        turtle.dig()
    end
end

local function digDownUntilClear()
    while turtle.detectDown() do
        turtle.digDown()
    end
end

local turtleHelper = require('turtlehelper')

turtleHelper.StartTurtle(START_X, START_Y, START_Z, START_DIR)
turtleHelper.DumpState()

digUntilClear()
turtleHelper.Forward()
digDownUntilClear()
turtleHelper.TurnRight()

local distanceTravelled = 0
local widthTravelled

while distanceTravelled <= DESIRED_DISTANCE do
    widthTravelled = 0
    
    while widthTravelled < WIDTH do
        digUntilClear()
        turtleHelper.Forward()
        digDownUntilClear()
        widthTravelled = widthTravelled + 1
    end

    -- Turn to next row
    if distanceTravelled % 2 == 0 then
        turtleHelper.TurnLeft()
    else
        turtleHelper.TurnRight()
    end

    -- Dig first bit
    turtle.dig()
    turtleHelper.Forward()
    turtle.digDown()
    
    -- Turn to face row
    if distanceTravelled % 2 == 0 then
        turtleHelper.TurnLeft()
    else
        turtleHelper.TurnRight()
    end

    distanceTravelled = distanceTravelled + 1
    print('Distance: '..distanceTravelled..'/'..DESIRED_DISTANCE)
end
