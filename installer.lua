local systemName = ({ ... })[1]

local ghBaseUrl = "https://raw.githubusercontent.com/HumaneWolf/cct-scripts/main/"

local systemDefs = {
    ["metrics:host"] = {
        ["server"] = "monitoring/metricshost.lua",
    },
    ["canal:digger"] = {
        ["canal"] = "canals/digger.lua",
        ["turtlehelper"] = "helpers/turtle.lua",
    },
}

local function installSystem(systemName)
    for localTarget, remotePath in pairs(systemDefs[systemName]) do
        print('Downloading '..localTarget..' from '..ghBaseUrl..remotePath)
        shell.run('wget', ghBaseUrl..remotePath, localTarget)
        print('Done downloading '..localTarget)
    end
end

print('Installing system '..systemName)
installSystem(systemName)
