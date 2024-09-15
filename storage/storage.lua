-- Options
local HEIGHT = 3


-- Functions
local function countChest(direction, index)
    local inv = peripheral.wrap(direction)
    if inv == nil or inv.list == nil then
        print('No inventory found to the '..direction)
        return false, index
    end
    print('Found inventory to the '..direction)

    local items = inv.list()
    for slot, item in pairs(items) do
        print(slot..' - '..item.name..' ('..item.count..')')
        if index[item.name] == nil then
            index[item.name] = 0
        end
        index[item.name] = index[item.name] + item.count
    end
    return true, index
end

local function executeOrWait(func)
    local success, ifany = func()
    if success ~= true then
        print('Function reported lack of success. Press enter to try again.')
        if ifany then
            print('Returned failure reason: '..ifany)
        end
        read()
        turtle.refuel()
        executeOrWait(func)
    end
end


-- Main
local currentHeight = 1
local movement = 1

local currentIndex = {}
local hasChestRight, hasChestLeft

while true do -- Main loop
    while true do -- Move and check loop
        -- Check
        hasChestRight, currentIndex = countChest('right', currentIndex)
        hasChestLeft, currentIndex = countChest('left', currentIndex)

        -- Find direction and move on
        if hasChestLeft == false and hasChestRight == false then
            print('Loop done. Will pause for a bit.')
            turtle.turnLeft()
            turtle.turnLeft()
            os.sleep(60)
            executeOrWait(turtle.forward)
            break
        elseif movement == 1 and (currentHeight == HEIGHT or turtle.detectUp()) then -- If done with column
            if turtle.detect() then
                print('Cannot move forward.')
                os.exit(100, true)
            end
            executeOrWait(turtle.forward)
            movement = -1
        elseif movement == -1 and (currentHeight == 1 or turtle.detectDown()) then
            if turtle.detect() then
                print('Cannot move forward.')
                os.exit(100, true)
            end
            executeOrWait(turtle.forward)
            movement = 1
        elseif movement == 1 then
            if turtle.detectUp() then
                print('Cannot move up.')
                os.exit(100, true)
            end
            executeOrWait(turtle.up)
            currentHeight = currentHeight + 1
        elseif movement == -1 then
            if turtle.detectDown() then
                print('Cannot move down.')
                os.exit(100, true)
            end
            executeOrWait(turtle.down)
            currentHeight = currentHeight - 1
        end
    end

    for item, count in pairs(currentIndex) do
        print(item..': '..count)
    end

    currentIndex = {}
end
