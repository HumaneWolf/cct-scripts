local START_X, START_Y, START_Z, START_DIR = 0, 0, 0, 'north'
local DESIRED_DISTANCE, WIDTH = 10, 6

local turtleHelper = require('turtlehelper')

turtleHelper.StartTurtle(START_X, START_Y, START_Z, START_DIR)
turtleHelper.DumpState()

turtleHelper.TurnRight()

local distanceTravelled = 0
local widthTravelled

while distanceTravelled <= DESIRED_DISTANCE do
    widthTravelled = 0
    
    while widthTravelled <= WIDTH do
        turtle.dig()
        turtleHelper.Forward()
        turtle.digDown()
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
end
