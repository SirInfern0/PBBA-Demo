--Platforms that let you jump through the bottom and land on top
onewayplatform = {}
onewayplatform.__index = onewayplatform
platforms = {}
require("player")

function onewayplatform.new(x,y,width)
    local instance = setmetatable({}, onewayplatform)
    instance.x = x
    instance.y = y
    instance.width = width
    instance.height = 16
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    table.insert(platforms, instance)
end

function onewayplatform:preSolve(a, b, collision)
    for i,instance in ipairs(platforms) do
        if a == instance.physics.fixture or b == instance.physics.fixture then 
            if instance.y - instance.height / 2 > Player.y + Player.height / 2 then
                collision:setEnabled(true)
            else
                collision:setEnabled(false)
            end
        end
    end
    for y,instance in ipairs(ladders) do
        if instance.holding == true then
            collision:setEnabled(true)
        end
    end
end