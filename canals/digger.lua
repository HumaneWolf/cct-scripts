local START_X, START_Y, START_Z, START_DIR = 0, 0, 0, 'north'
local DESIRED_DISTANCE, WIDTH = 2, 6

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

local function digUpUntilClear()
    while turtle.detectDown() do
        turtle.digUp()
    end
end


local turtleHelper = require('turtlehelper')

turtleHelper.StartTurtle(START_X, START_Y, START_Z, START_DIR)
turtleHelper.DumpState()

digUntilClear()
turtleHelper.Forward()
digDownUntilClear()
digUpUntilClear()
turtleHelper.TurnRight()

local distanceTravelled = 0
local widthTravelled

while distanceTravelled <= DESIRED_DISTANCE do
    widthTravelled = 1
    
    while widthTravelled < WIDTH do
        digUntilClear()
        turtleHelper.Forward()
        digDownUntilClear()
        digUpUntilClear()
        widthTravelled = widthTravelled + 1
    end

    -- Turn to next row
    if distanceTravelled % 2 == 0 then
        turtleHelper.TurnRight()
    else
        turtleHelper.TurnLeft()
    end

    -- Dig first bit
    digUntilClear()
    turtleHelper.Forward()
    digDownUntilClear()
    digUpUntilClear()
    
    -- Turn to face row
    if distanceTravelled % 2 == 0 then
        turtleHelper.TurnRight()
    else
        turtleHelper.TurnLeft()
    end

    distanceTravelled = distanceTravelled + 1
    print('Distance: '..distanceTravelled..'/'..DESIRED_DISTANCE)
end
