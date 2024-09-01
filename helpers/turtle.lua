PosX, PosY, PosZ = 0, 0, 0
Facing = ''


local function DumpState()
    print('Position: '..PosX..', '..PosY..', '..PosZ)
    print('Facing: '..Facing)
    -- todo: Dump inventory
end

local function getFacingModifier()
    if Facing == 'north' then
        return 0, -1
    end
    if Facing == 'south' then
        return 0, 1
    end
    if Facing == 'west' then
        return -1, 0
    end
    if Facing == 'east' then
        return 1, 0
    end
end

local function executeOrWait(func)
    local success, ifany = func()
    if success ~= true then
        print('Function reported lack of success. Press enter to try again.')
        if ifany then
            print('Returned failure reason: '..ifany)
        end
        DumpState()
        read()
        executeOrWait(func)
    end
end

local function StartTurtle(posX, posY, posZ, facing)
    PosX = posX
    PosY = posY
    PosZ = posZ
    Facing = facing
end

local function TurnLeft()
    executeOrWait(turtle.turnLeft)
    if Facing == 'north' then
        Facing = 'west'
    end
    if Facing == 'south' then
        Facing = 'east'
    end
    if Facing == 'west' then
        Facing = 'south'
    end
    if Facing == 'east' then
        Facing = 'north'
    end
end

local function TurnRight()
    executeOrWait(turtle.turnRight)
    if Facing == 'north' then
        Facing = 'east'
    end
    if Facing == 'south' then
        Facing = 'west'
    end
    if Facing == 'west' then
        Facing = 'north'
    end
    if Facing == 'east' then
        Facing = 'south'
    end
end

local function TurnAround()
    TurnLeft()
    TurnLeft()
end

local function Forward(distance)
    if distance == nil then
        distance = 1
    end

    local moved = 0
    while moved < distance do
        executeOrWait(turtle.forward)
        local modX, modZ = getFacingModifier()
        PosX = PosX + modX
        PosZ = PosZ + modZ
    end
end

local function Back(distance)
    if distance == nil then
        distance = 1
    end

    local moved = 0
    while moved < distance do
        executeOrWait(turtle.back)
        local modX, modZ = getFacingModifier()
        PosX = PosX + (modX * -1)
        PosZ = PosZ + (modZ * -1)
    end
end

local function Up(distance)
    if distance == nil then
        distance = 1
    end

    local moved = 0
    while moved < distance do
        executeOrWait(turtle.up)
        PosY = PosY + 1
    end
end

local function Down(distance)
    if distance == nil then
        distance = 1
    end

    local moved = 0
    while moved < distance do
        executeOrWait(turtle.down)
        PosY = PosY - 1
    end
end

return {
    StartTurtle = StartTurtle,
    TurnLeft = TurnLeft,
    TurnRight = TurnRight,
    TurnAround = TurnAround,
    Forward = Forward,
    Back = Back,
    Up = Up,
    Down = Down,
    DumpState = DumpState,
}
